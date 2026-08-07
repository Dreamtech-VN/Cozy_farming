--WndTrainData.lua
--@brief	WndTrain的数据模块
--@date		2017/04/21
--@author	 
--@note		训练营

WndTrain = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndTrain:_init()
	self.m_root = nil	 	  			--场景根节点
	self.loadingId = nil
	self.m_tSearchRoomData = nil
	self.roomData = nil
	self.curIndexCnt = 15
	self.roomPageIndex = 1
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndTrain:_unInit()
	self.m_root = nil
	self.loadingId = nil
	self.m_tSearchRoomData = nil
	self.roomData = nil
	self.curIndexCnt = nil
	self.roomPageIndex = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndTrain:createElement()
	if WndTrain.m_root ~= nil then
		WindowManager:removeWindow(WndTrain.m_root, WndTrain, true)
	end
	local element = WZUISystem:getInstance():createElement("WndTrain")
	assert(element, "WndTrain create element failed!")
	self:_init()
	return element
end

function WndTrain:show()
	WZLog("WndTrain:show")
	local root = self:createElement()
	WindowManager:addWindow(root,self,nil,nil,nil,true)
end

--@brief	找到房间，但需要密码
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function WndTrain:receiveSelectRoomOk(roomId, password)
    WZLog("WndTrain:receiveSelectRoomOk")
    if self.m_root == nil then return end
    self:closeLoadingBox()
	self.m_tSearchRoomData = {roomId=roomId, password=password}
	self:enterRoomPassword()
end


--@brief	查找房间失败
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function WndTrain:receiveSelectRoomFail()
    WZLog("WndTrain:receiveSelectRoomFail")
    if self.m_root == nil then return end
    self:closeLoadingBox()
end


--@brief	返回房间列表
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function WndTrain:receiveRoomList(channel, roomId, roomName, battleStatus, battleMode, playerNumMode, passWord, playerNum, startMode, roomStaus,totalSize)
	WZLog("WndTrain:receiveRoomList ")
	if self.m_root == nil then return end
    self.roomData = {}
    local emptyRoomId = nil
    local roomCount = #roomId
    for i = 1, roomCount do
        local data = {}
        local maxNum = startMode[i] == 2 and playerNumMode[i]*2 or playerNumMode[i]
        local roomId = string.format("%04d",roomId[i])
        data = {roomId=roomId, roomName=roomName[i], battleStatus=battleStatus[i], battleMode=battleMode[i],
                playerNumMode=playerNumMode[i], passWord=passWord[i], playerNum=playerNum[i], startMode=startMode[i],
                roomStaus=roomStaus[i] ,maxNum = maxNum }
        table.insert(self.roomData,data)
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
    WZLog("roomData = ",Serialize(self.roomData))
    -- self:initRoomListOnce()
end


-- 当前房间不足时，房间的假数据
function WndTrain:_initNoRoomData(curCnt)
    local name = LocalStrings.ROOM_NAME_RANDOM
    for i = curCnt+1, self.curIndexCnt do
        local data = {}
        local index = math.random(1,#name)
        data.roomName = name[index]
        data.roomId = self:_initRoomId()
        data.battleMode = 1
        data.startMode = 2
        data.curNum = math.random(1,3)
        data.maxNum = data.curNum
        data.fake = true
        data.battleStatus = 1
        local curIndex = math.random(1,3)
        data.playerNumMode = curIndex
        data.roomStaus = true
        local cnt = math.random(1,3)
        data.playerNum = 2*cnt
        data.maxNum = 2*cnt
        if index%2 == 0 then
            data.passWord = "-1"
        else
            data.passWord = "12306"
        end
        table.insert(self.roomData,data)
    end
end

function WndTrain:_initRoomId()
    local bFlag = true
    local roomId = nil
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
    return roomId
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
