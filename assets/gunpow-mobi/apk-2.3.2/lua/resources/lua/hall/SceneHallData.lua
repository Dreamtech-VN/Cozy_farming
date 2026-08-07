--SceneHallData.lua
--@brief	SceneHall的数据模块
--@date		2013/12/16
--@author	李光森
--@note		游戏大厅模块

SceneHall = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function SceneHall:_init()
	self.m_root = nil	 	  			--场景根节点

	self.m_tSearchRoomData = nil		--查找房间数据
	self.m_tPlayer = nil
    self.m_scheduleId = -1              --定时器id
    self.loadingId = nil
    self.roomPageIndex = 1      -- 当前房间的下标
    self.roomMaxIndex = 3       -- 当前房间的最大下标
    self.curIndexCnt = 15        -- 当前页房间的数量
    self.roomData = {}          -- 当前房间数据
	self.goalTipsTime = 0       -- 气泡时间间隔
    self.matchType = 1          -- 比赛类型， 1 积分赛 
    self.m_nRoomChannel = 1     -- 房间频道 1 为对战赛 10 为练习赛
    self.personCnt = 2          -- 人数 1v1 = 1, 2v2 = 2, 3v3 = 3
    self.tabFlag = false        -- tab 是否初始化过
    self.roomCell = {}          -- 存放当前tab中cell的信息
    self.moveDirection = 0      -- 是否需要调整当前tab 0不需要  1向上  2 向下
    self.matchTime = 1          -- 匹配时间
    self.topCell = {}
    self.matchState = false
    self.m_nCount = 0
    self.m_nTouchButtonType = nil
    self.m_sRoleFootSpine = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function SceneHall:_unInit()
	self.m_root = nil
	--self.m_tEquipmentData = nil
	--self.m_tOnlinePlayerData = nil
	self.m_tSearchRoomData = nil
	self.m_tPlayer = nil
    self.loadingId = nil
    self.goalTipsTime = 0
    self.matchTime = 1
    self.topCell = nil
    self.matchState = false
    self.m_nCount = nil
    self.m_nTouchButtonType = nil
    self.m_sRoleFootSpine = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function SceneHall:createElement()
	local element = WZUISystem:getInstance():createElement("SceneHall")
	assert(element, "SceneHall create element failed!")
	self:_init()
	return element
end

-- 直接进入竞技商店
function SceneHall:immediateAthShop()
    local scene = SceneHall:createElement()
    replaceScene(scene)
    local wnd =  WndAthShop:createElement()
    WindowManager:addWindow(wnd, WndAthShop,true,true,nil,true)
end

--@brief	返回房间列表
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function SceneHall:receiveRoomList(channel, roomId, roomName, battleStatus, battleMode, playerNumMode, passWord, playerNum, startMode, roomStaus,totalSize)
	WZLog("SceneHall:receiveRoomList")
	if self.m_root == nil then return end
    self.roomMaxIndex = 3
    if totalSize then
        local curMax = math.ceil(totalSize/self.curIndexCnt)
        self.roomMaxIndex = curMax > 3 and curMax or 3
    end
    WZLog("------------self.matchType-------------------",self.matchType)
    self.roomData = {}
    local emptyRoomId = nil
    local roomCount = #roomId
    for i = 1, roomCount do
        local data = {}
        local maxNum = startMode[i] == 2 and playerNumMode[i]*2 or playerNumMode[i]
        local roomId = string.format("%04d",roomId[i])
        data = {roomId=roomId, roomName=roomName[i], battleStatus=battleStatus[i], battleMode=battleMode[i],
                playerNumMode=playerNumMode[i], passWord=passWord[i], playerNum=playerNum[i], startMode=startMode[i],
                roomStaus=roomStaus[i],maxNum = maxNum }
                WZLog("-------------------info-------------------",passWord[i],roomId,roomName[i],startMode,playerNumMode,maxNum)
        WZLog("-------------------server room id-------------------",roomId)
        table.insert(self.roomData,data)
        WZLog("checkRoomList===",data.playerNum , data.maxNum , data.battleStatus)
        if data.playerNum ~= data.maxNum and data.battleStatus == 0 and data.passWord == AutoRunBattleConst.BattlePassWord then
            emptyRoomId = roomId
        end
    end

    if roomCount < self.curIndexCnt then
        self:_initNoRoomData(roomCount)
    end

    local function sort(v1,v2)
        if v1.battleStatus == v2.battleStatus then
            return v1.roomId < v2.roomId
        else
            return v1.battleStatus < v2.battleStatus
        end
    end
    table.sort(self.roomData,sort)
    self:updateRoomList(emptyRoomId)
end

--@brief	找到房间，但需要密码
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function SceneHall:receiveSelectRoomOk(roomId, password)
    WZLog("SceneHall:receiveSelectRoomOk")
    if self.m_root == nil then return end
    self:closeLoadingBox()
	self.m_tSearchRoomData = {roomId=roomId, password=password}
	self:enterRoomPassword()
end

--@brief	查找房间失败
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function SceneHall:receiveSelectRoomFail()
    WZLog("SceneHall:receiveSelectRoomFail")
    if not self.m_root then return end
    self:closeLoadingBox()
end

--@brief	快速游戏错误
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function SceneHall:receiveQuickGameFail()
	WZLog("SceneHall:receiveQuickGameFail")
    self:closeLoadingBox()
end

--@brief	创建房间失败
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function SceneHall:receiveCreateRoomFail(nFlag, sMessage)
    WZLog("SceneHall:receiveCreateRoomFail")
    self:closeLoadingBox()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function SceneHall:setPlayerData(tData)
	if self.m_root == nil or tData == nil then
		return
	end
	self.m_tPlayer = CopyTable(tData)
end

-- 获取竞技商店的红点
function SceneHall:_checkAthShopRedPoint()
    local isRed1,isRed2 = false,false

    for i = 1, #CacheCenter.m_tRedPointInfo do
        WZLog("----------all red-------------",i,CacheCenter.m_tRedPointInfo[i].type,CacheCenter.m_tRedPointInfo[i].state)
    end


    for i = 1, #CacheCenter.m_tRedPointInfo do
        if CacheCenter.m_tRedPointInfo[i].type == 8 then
            if CacheCenter.m_tRedPointInfo[i].state > 0 then
                isRed1 = true
            end
        end

        if CacheCenter.m_tRedPointInfo[i].type == 122 then
            if CacheCenter.m_tRedPointInfo[i].state > 0 then
                isRed2 = true
            end
        end
    end
    WZLog("-------------ath shop red point-------------------",isRed1,isRed2)
    return isRed1, isRed2
end

-- 改变竞技商店的红点状态
function SceneHall:_cancelAthShopRedPoint()
    for i = 1, #CacheCenter.m_tRedPointInfo do
        if CacheCenter.m_tRedPointInfo[i].type == 8 then
            table.remove(CacheCenter.m_tRedPointInfo,i)
            break
        end
    end

    local imgRed = GetElement(self.m_root,"imgAthRed_SceneHall",WZUIImage)
    imgRed:setVisible(false)
    ProtocolProcessorSceneCity:send_PLAYER_CancelRedDot(8)
end

-- 竞技场目标tips
function SceneHall:setGoalTipsData(fightCnt,winCnt)
	do return end
    WZLog("---------------win fight----------------",fightCnt,winCnt)
    local data = {}
    local fightNum = {}
    local winNum = {}
    for k,v in pairs(GDatatab_rank_sports) do
        if v.type == 1 then
            if v.sub_type == 0 then
                table.insert(fightNum,v.win_num)
            elseif v.sub_type == 1 then
                table.insert(winNum,v.win_num)
            end
        end
    end

    local function sort(v1,v2)
        return v1 < v2
    end

    table.sort(fightNum,sort)
    table.sort(winNum,sort)
    for i = 1, #fightNum do
        WZLog("----------------fight num -+-----",fightNum[i])
    end
    for i = 1, #winNum do
        WZLog("----------------winNum num -+-----",winNum[i])
    end

    local txt
    if fightCnt < fightNum[#fightNum] then
        for i = 1, #fightNum do
            if fightCnt < fightNum[i] then
                txt = string.format(LocalStrings.HALL_GET_RAEARD,fightNum[i]-fightCnt)
                break
            end
        end
    elseif winCnt < winNum[#winNum] then
        for i = 1, #winNum do
            if winCnt < winNum[i] then
                txt = string.format(LocalStrings.HALL_GET_RAEARD1,winNum[i]-winCnt)
                break
            end
        end
    end

    self:_initGoalTips(txt)
end

function SceneHall:_initRoomId()
    local bFlag = true
    local roomId
    while bFlag do
        bFlag = false
        roomId = (self.roomPageIndex-1)*5+math.random(6,20)
        for i = 1, #self.roomData do
            if tonumber(self.roomData[i].roomId) == roomId then
                bFlag = true
                break
            end
        end
    end
    roomId = string.format("%04d",roomId)
    --WZLog("local room id init-------------------",roomId,self.roomPageIndex)
    return roomId
end

-- 当前房间不足时，房间的假数据
function SceneHall:_initNoRoomData(curCnt)
    local name = LocalStrings.ROOM_NAME_RANDOM
    for i = curCnt+1, self.curIndexCnt do
        local data = {}
        local index = math.random(1,#name)
        data.roomName = name[index]
        data.roomId = self:_initRoomId()
        data.battleMode = 1
        if self.matchType == 1 then
            data.startMode = 1
        else
            data.startMode = math.random(2,3)
        end
        data.curNum = math.random(1,3)
        data.maxNum = data.curNum
        data.battleStatus = 1
        local curIndex = math.random(1,3)
        data.playerNumMode = curIndex
        data.roomStaus = true
        if data.startMode == 3 then
            data.playerNum = math.random(2,6)
            data.maxNum = math.random(2,6)
            data.maxNum = data.maxNum >= data.playerNum and data.maxNum or data.playerNum
        else
            local cnt = math.random(1,3)
            data.playerNum = 2*cnt
            data.maxNum = 2*cnt
        end
        if index%2 == 0 then
            data.passWord = "-1"
        else
            data.passWord = "12306"
        end
		data.fake = true
        table.insert(self.roomData,data)
    end
end

function SceneHall:_saveCurCell(tag,cell,tcell)
    if not self.roomCell then self.roomCell = {} end
    if not self.roomCell[tag] then self.roomCell[tag] = {} end
    self.roomCell[tag].cell = cell
    self.roomCell[tag].tcell = tcell
end

function SceneHall:getMatchState()
    return self.matchState
end
-------------------------------------私有方法模块End----------------------------------------
