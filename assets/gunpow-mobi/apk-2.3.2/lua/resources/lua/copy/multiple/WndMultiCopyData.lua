--WndMultiCopyData.lua
--@brief	WndMultiCopy的数据模块
--@date		2015-7-28
--@author	binshao
--@note		多人副本

WndMultiCopy = {
	--请不要在这里定义变量
}

WndMultiCopy.g_nBackRoomState = 0   --副本返回房间状态
--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndMultiCopy:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_tCopyData = nil              --副本数据
    self.m_tCellCopyList = nil          --副本单元格绑定的lua对象列表
    self.m_tRoomListData = nil          --副本房间数据表
    self.m_nTotalCopy = 0               --副本总数
    self.m_nSelectedIndex = 0           --当前选中的副本序号
    self.clickRoomData = {}
    self.loadingId = nil
    self.vipLimit = nil
    self.videoData = {}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndMultiCopy:_unInit()
	self.m_root = nil
    self.m_tCopyData = nil
    self.m_tCellCopyList = nil
    self.m_tRoomListData = nil
    self.m_nTotalCopy = 0
    self.m_nSelectedIndex = 0
    self.clickRoomData = nil
    self.loadingId = nil
    self.vipLimit = nil
    self.videoData = nil

    WndMultiCopy.g_nBackRoomState = 0
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndMultiCopy:createElement()
	local element = WZUISystem:getInstance():createElement("WndMultiCopy")
	assert(element, "WndMultiCopy create element failed!")
	self:_init()
	return element
end


--@brief	更新玩家的副本数据
function WndMultiCopy:updateData()
    local tMultiCopyData = CacheCenter:getMultiCopyData()
    for i,v in ipairs(tMultiCopyData) do
        local nMapId = v.mapId
        if self.m_tCopyData[nMapId] then
            self.m_tCopyData[nMapId].userData = v
            local tCellCopy = self.m_tCellCopyList[nMapId]
            if tCellCopy then
                tCellCopy:setData(self.m_tCopyData[nMapId])
            end
        end
    end

    if self.m_root == nil then return end 
    self:setSweepBtnText()
end


--@brief	获取房间列表
--@param    tData, 房间数据表，包含以下参数
-- roomCount :      房间数量
-- roomId :         房间Id数组
-- battleStatus :   房间状态数组（0是等待中，1是战斗中）
-- playerCountNum : 房间对战人数
-- passWord :       房间密码数组
-- playerNum :      房间当前人数数组
-- roomStaus :      房间是否已满（true是已满，false未满）
-- mapId :          房间地图id
-- roomName :       房间名称
function WndMultiCopy:getRoomListOk(tData)
    WZLog("-------------room cnt-------------",tData.roomCount)
    self.m_tRoomListData = {}
    for i = 1, tData.roomCount do
        self.m_tRoomListData[i] = {
            roomId = tData.roomId[i],
            battleStatus = tData.battleStatus[i],
            playerCountNum = tData.playerCountNum[i],
            passWord = tData.passWord[i],
            playerNum = tData.playerNum[i],
            roomStaus = tData.roomStaus[i],
            mapId = tData.mapId[i],
            roomName = tData.roomName[i],
            assist = tData.assist,
        }
    end
    self:sortRoomData()
    self:_updateRoomList()
end

-- 记录玩家的点击的房间数据,防止房间列表刷新时丢失数据
function WndMultiCopy:setClickRoomData(roomId, passWord,mapId)
    self.clickRoomData = {roomId = roomId, passWord = passWord,mapId = mapId}
end

function WndMultiCopy:getClickRoomData()
    return self.clickRoomData
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	初始化数据
-- 地图关卡数据 stage = {{简单难度},{困难难度},{地狱难度}}
-- self.m_tCopyData = {{stage1}，{stage2}，...}
function WndMultiCopy:_initData()
    WZLog("WndMultiCopy:_initData")
    -- 初始化本地数据和玩家初始数据
    self.m_tCopyData = {}
    for i,v in pairs(GDatatab_team_map) do
        local nCopyIndex,nDifficulty = v.map_num,v.difficulty
        if nCopyIndex > 0 then
            self.m_tCopyData[nCopyIndex] = self.m_tCopyData[nCopyIndex] or {}
            self.m_tCopyData[nCopyIndex][nDifficulty] = v

            -- 初始化玩家的关卡信息
            local userData ={ mapId = nCopyIndex, passTime = 0, starLevel = 0 }
            self.m_tCopyData[nCopyIndex].userData = userData
        end
    end

    self.m_nTotalCopy = #self.m_tCopyData
    
    --从缓存中心读取用户数据，更新用户数据
    local tMultiCopyData = CacheCenter:getMultiCopyData()
    
    for i,v in ipairs(tMultiCopyData) do
        local nMapId = v.mapId
        if self.m_tCopyData[nMapId] then self.m_tCopyData[nMapId].userData = v end
    end

    -- 初始化地图的状态
    for i=1,self.m_nTotalCopy do
        local curData = self.m_tCopyData[i]
        curData.openState = self:_getCopyState(i)
    end

    -- 重置次数
    self.m_tCopyData.resetTime = tMultiCopyData.resetTime
end

-- 获得当前副本的状态，1可以挑战，2次数用完，3前面关卡没有过，4等级不足
function WndMultiCopy:_getCopyState(nIndex)
    local tData = self.m_tCopyData[nIndex]      -- 当前关数据
    local pData = self.m_tCopyData[nIndex-1]    -- 当前关的前一关数据
    local nPlayerLevel = CacheCenter:getPlayerInfo().level
    if tData.userData.passTime >= tData[1].challenge_num then --次数已经用完
        return 2
    elseif pData and pData.userData.starLevel == 0 then -- 前面存在没打过的副本
        return 3
    elseif nPlayerLevel < tData[1].map_level then --等级不足
        return 4
    else
        return 1
    end
end

-- VIP限购信息
function WndMultiCopy:_initVipLimitInfo()
    if self.vipLimit then return end

    local mulData = {}
    for k,v in pairs(GDatatab_vip_restriction) do
        if v.type == 7 then table.insert(mulData,v) end
    end
    local function sort(v1,v2)
        return v1.vip_level > v2.vip_level
    end
    table.sort(mulData,sort)
    self.vipLimit = mulData
end

-- 获得自己的重置次数
function WndMultiCopy:_getMyResetCnt()
    local vipLv = CacheCenter:getPlayerInfo().vipLevel
    for i = 1, #self.vipLimit do
        if vipLv >= self.vipLimit[i].vip_level then
            return self.vipLimit[i].count
        end
    end
    return 0
end

-- 获得当前重置次数的花费
function WndMultiCopy:_getResetCost(resetCnt)
    for i = 1, #self.vipLimit do
        if self.vipLimit[i].count == resetCnt then
            local costId = self.vipLimit[i].cost[1][1]
            local costCnt = self.vipLimit[i].cost[1][2]
            WZLog("-----------------cost--------------",costId,costCnt)
            return costId,costCnt
        end
    end
end


-- 给房间排序
function WndMultiCopy:sortRoomData()
    local function sort(v1,v2)
        -- 优先没密码的
        if v1.passWord == "" and v2.passWord ~= "" then return true end
        if v1.passWord ~= "" and v2.passWord == "" then return false end

        -- 如果密码情况一样，优先房间人数未满的
        if v1.roomStaus == false and v2.roomStaus == true then return true end
        if v1.roomStaus == true and v2.roomStaus == false then return false end

        -- 房间状态
        if v1.battleStatus == 0 and v2.battleStatus == 1 then return true end
        if v1.battleStatus == 1 and v2.battleStatus == 0 then return false end

        return false
    end

    table.sort(self.m_tRoomListData,sort)

    -- 取前面15条
    if #self.m_tRoomListData > 15 then
        local tempData = {}
        for i = 1, 15 do
            table.insert(tempData,self.m_tRoomListData[i])
        end
        self.m_tRoomListData = tempData
    end
end

function WndMultiCopy:initVideoData(playerId, playerName, level, headId, faceId, fight, sex, difficulty,recordId,mapId,headColor)
    self.videoData = {}
    local playerId = VectorToTable(playerId)
    local playerName = VectorToTable(playerName)
    local level = VectorToTable(level)
    local headId = VectorToTable(headId)
    local faceId = VectorToTable(faceId)
    local fight = VectorToTable(fight)
    local sex = VectorToTable(sex)
    local difficulty = VectorToTable(difficulty)
    local recordId = VectorToTable(recordId)
    local mapId = VectorToTable(mapId)
    local headColor = VectorToTable(headColor)

    WZLog("----------------WndMultiCopy:initVideoData------------",#playerId)
    --  每3人为一组录像
    local videoCnt = #playerId/3
    for i = 1, videoCnt do
        local video = {}
        video.fight = 0
        video.pInfo = {}
        video.difficulty = difficulty[i]
        video.mapId = mapId[i]
        video.recordId = recordId[i]
        for k = 1, 3 do
            local data = {}
            local index = (i-1)*3+k
            WZLog("--------------index------------",index,k)
            data.playerId = playerId[index]
            data.playerName = playerName[index]
            data.level = level[index]
            data.headId = headId[index]
            data.faceId = faceId[index]
            data.sex = sex[index]
            data.headColor = sex[headColor]
            video.fight = video.fight + fight[index]
            table.insert(video.pInfo,data)
        end
        if video.difficulty <= 3 then 
            table.insert(self.videoData,video)
        end
    end

    -- 按照难度排序
    local function sort(v1,v2)
        return v1.difficulty < v2.difficulty
    end
    if videoCnt > 1 then table.sort(self.videoData,sort) end
    WZLog("--------------video cnt----------",#self.videoData)
    self:_createVideo()
end

function WndMultiCopy:_getMapId()
    local GDatatab_team_map
end

function WndMultiCopy:createLoadingBox()
    if not self.loadingId then
        self.loadingId = MsgBoxManager:showLoadingBox(10,self,self.closeLoadingBox)
        WZLog("WndMultiCopy--------createloadingID",self.loadingId)
    end
end

function WndMultiCopy:closeLoadingBox()
    if self.m_root == nil then return end
    if self.loadingId then
        MsgBoxManager:stopLoadingBoxByMsgId(self.loadingId)
        WZLog("WndMultiCopy--------closeloadingID",self.loadingId)
        self.loadingId = nil
    end
end
-------------------------------------私有方法模块End----------------------------------------