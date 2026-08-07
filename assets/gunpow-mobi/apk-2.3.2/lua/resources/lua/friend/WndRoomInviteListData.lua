--WndRoomInviteListData.lua
--@brief	WndRoomInviteList的数据模块
--@date		2019/03/12
--@author	Tianxiang_Xu
--@note		房间邀请界面

WndRoomInviteList = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndRoomInviteList:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tFriend = nil
	self.m_tPopupMenuItems = nil 
	self.m_tGuild = nil 
    self.m_tMaster = nil
    self.m_tAssistIn = nil
	self.m_nIndex = 0 
	self.m_selectIndex = 0
	self.m_nInterface = 0 
	self.m_tBack = nil 
	self.m_bSendGuild = false
	self.m_nSelect = 1	
	self.m_nLoadingId = nil
    self.m_tHall = nil
    self.m_tInvitePlayer = nil --战斗邀请的玩家
    --文本
    self.NO_PLAYER_IN_HALL = LocalStrings.NO_PLAYER_IN_HALL
    self.m_tInviteFriendIds = nil --已在房间的玩家ID
    self.m_nTopLevel = nil
    self.m_nLeftTime = 6

    self.m_bIsChangeBox = false         --是否手动切换了标签按钮
    self.m_bSetOriginalPos = false      --容器改变为初始位置
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndRoomInviteList:_unInit()
	self.m_root = nil
	self.m_tFriend = nil
	self.m_nIndex = nil 
	self.m_tPopupMenuItems = nil 
	self.m_tGuild = nil 
    self.m_tMaster = nil
    self.m_tAssistIn = nil
	self.m_selectIndex = nil
	self.m_nInterface = nil
	self.m_tBack = nil 
	self.m_bSendGuild = nil
	self.m_nSelect = nil
	self.m_nLoadingId = nil
    self.m_tHall = nil
    self.m_tInvitePlayer = nil
    --文本
    self.NO_PLAYER_IN_HALL = nil
    self.m_tInviteFriendIds = nil --已在房间的玩家ID
    self.m_nTopLevel = nil
    self.m_nLeftTime = nil 
    self.m_tPWLevelList = nil 
    self.m_nPlayerNum = nil 
    self.m_tPlayerId = nil 

    self.m_bIsChangeBox = nil
    self.m_bSetOriginalPos = false      --容器改变为初始位置
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndRoomInviteList:createElement()
	local element = WZUISystem:getInstance():createElement("WndRoomInviteList")
	assert(element, "WndRoomInviteList create element failed!")
	self:_init()
	return element
end

--3、战斗邀请,6、组队，11、排位赛，12、娱乐赛 20战略赛
--tCell回调的类self a
--backFun回调的方法接受一个参数data function a:b(data,index) end
--结婚返回：回调方法tData: tData[1].id,tData[2].id...... index是界面索引id(如有"好友","公会"),索引1:好友，2:公会
--3、战斗邀请,4、邮件邀请返回tData,tData.id,tData.name
--topLevel :排位赛房间用到（排位等级）
function WndRoomInviteList:showInterface(index,tCell,backFun,topLevel, parentNode)
	local approval = WndRoomInviteList:createElement()
	self.m_nInterface = index 	
    self.m_nTopLevel = topLevel
    if parentNode:getChildByTag(99) then 
    	parentNode:removeChildByTag(99, true)
    end
    approval:setTag(99)
    parentNode:addChild(approval)

	if tCell and backFun then
		self.m_tBack = {}
		self.m_tBack[1] = tCell
		self.m_tBack[2] = backFun
	end
end


--@brief    设置相关操作
function WndRoomInviteList:onInitInterface(index)
    -- body
    local checkGroupInvite = GetElement(self.m_root, "checkGroupInvite_WndRoomInviteList", WZUICheckBoxGroup) --大厅
    self.m_nSelect=1
    checkGroupInvite:setCheckIndex(0)
    local checkFriend = GetElement(checkGroupInvite,"checkFriend",WZUICheckBox)
    local checkGuild = GetElement(checkGroupInvite,"checkGuild",WZUICheckBox)
    local checkMaster = GetElement(checkGroupInvite,"checkMaster",WZUICheckBox)
    local checkHall = GetElement(checkGroupInvite,"checkHall",WZUICheckBox)
    
    if index == 6 or index == 3 or index == 11 or index == 12 or index == 20 then
        checkFriend:setRelativePosition(ccp(0.12,0.5))
        checkGuild:setRelativePosition(ccp(0.38,0.5))
        checkMaster:setRelativePosition(ccp(0.64,0.5))
        checkHall:setRelativePosition(ccp(0.9,0.5))
    else
        checkMaster:setVisible(false)
        checkFriend:setRelativePosition(ccp(0.2,0.5))
        checkGuild:setRelativePosition(ccp(0.5,0.5))
        checkHall:setRelativePosition(ccp(0.8,0.5))
    end
    --发送协议
    if index==3 or index == 6 then 
        ProtocolProcessorWndFriends:send_FRIEND_GetFriend(index,1)
    elseif index == 11 then  --排位赛房间邀请
        local pwLevel = SceneRoom:getPlayerPWLevel()
        ProtocolProcessorWndFriends:send_FRIEND_GetFriend(index,1,self.m_nTopLevel, pwLevel)
    elseif index == 12 then  --娱乐赛房间邀请
        local amuseLevel = SceneRoom:getPlayerAmuseLevel()
        ProtocolProcessorWndFriends:send_FRIEND_GetFriend(index, 1, nil, amuseLevel)
    elseif index == 20 then  --战略赛房间邀请
        local pwLevel = SceneRoom:getPlayerPWLevel()
        local playerNumMode = SceneRoom:getPlayerNumMode()
        ProtocolProcessorWndFriends:send_FRIEND_GetFriend(index,1,self.m_nTopLevel, pwLevel, playerNumMode)
    end
end

function WndRoomInviteList:receiveFriendListData(tFriendList)
    if self.m_root == nil then return end 
	WZLog("WndRoomInviteList:receiveFriendListData()::")
	self:setFriendData(tFriendList)
end

--@brief 	返回排序状态
function WndRoomInviteList:_getSortValue(a)
	-- body
	if a.isOnline == 0 then 
		return 4
	elseif a.isOnline == 2 then 
		return 3
	elseif a.isOnline == 3 then 
		return 2
	else
		return a.isOnline
	end
end

--@brief    排序
local function _sortInviteList(a,b)
    WZLog("_sortInviteList(a,b)")
    --伴侣 》师徒 》等级 
    local mateName = CacheCenter:getPlayerInfo().mateName
    WZLog("mateName===",mateName)
    local stateA = WndRoomInviteList:_getSortValue(a)
    local stateB = WndRoomInviteList:_getSortValue(b)
    if a.isTop ~= b.isTop then
        return a.isTop
    elseif a.status ~= b.status then
        return a.status < b.status
    elseif stateA ~= stateB then 
    	return stateA < stateB
    elseif a.name == mateName then
        return true
    elseif b.name == mateName then
        return false
    elseif a.bBestFriend == 1 then 
        return true
    elseif b.bBestFriend == 1 then 
        return false
    elseif a.isMentoring == true then
        return true
    elseif b.isMentoring == true then
        return false
    elseif a.level ~= b.level then
		return a.level >= b.level
	elseif a.fighting ~= b.fighting then
		return a.fighting >= b.fighting
	else 
		return a.id < b.id 
	end
end

function WndRoomInviteList:setFriendData(tFriend)
	if self.m_root == nil then
		return
    end

    if tFriend ~= nil then
        WZLog("tFriend ~= nil")
        table.sort(tFriend, _sortInviteList)
    end

	if self.m_nSelect == 1 or self.m_nSelect == 4 then 
        --防止频繁刷新
        if self.m_bIsChangeBox ~= true then
            local bIsChange = self:compareFriendData(self.m_tFriend,tFriend)
            if bIsChange == false then
                return
            end
        end
        --初始进入界面时或者手动点了标签按钮时
        if self.m_tFriend == nil or self.m_bIsChangeBox == true then
            self.m_bSetOriginalPos = true
        end

        self.m_tFriend = CopyTable(tFriend)
	elseif self.m_nSelect == 2 then
        local tTempFriend = {}
        for i = 1, #tFriend do
            if tFriend[i].serverId == tonumber(CacheCenter:getPlayerInfo().serverId) then
                table.insert(tTempFriend, tFriend[i])
            end
        end

        --防止频繁刷新
        if self.m_bIsChangeBox ~= true then
            local bIsChange = self:compareFriendData(self.m_tGuild,tTempFriend)
            if bIsChange == false then
                return
            end
        end
        --初始进入界面时或者手动点了标签按钮时
        if self.m_tGuild == nil or self.m_bIsChangeBox == true then
            self.m_bSetOriginalPos = true
        end

        self.m_tGuild = CopyTable(tTempFriend)
    elseif self.m_nSelect == 3 then
        --防止频繁刷新
        if self.m_bIsChangeBox ~= true then
            local bIsChange = self:compareFriendData(self.m_tHall,tFriend)
            if bIsChange == false then
                return
            end
        end
        --初始进入界面时或者手动点了标签按钮时
        if self.m_tHall == nil or self.m_bIsChangeBox == true then
            self.m_bSetOriginalPos = true
        end

        self.m_tHall = CopyTable(tFriend)
    elseif self.m_nSelect == 5 then
        local tTempFriend = {}
        for k, value in pairs(tFriend) do
            if value.serverId == CacheCenter:getPlayerInfo().serverId then
                table.insert(tTempFriend, value)
            end
        end

        --防止频繁刷新
        if self.m_bIsChangeBox ~= true then
            local bIsChange = self:compareFriendData(self.m_tAssistIn,tTempFriend)
            if bIsChange == false then
                return
            end
        end
        --初始进入界面时或者手动点了标签按钮时
        if self.m_tAssistIn == nil or self.m_bIsChangeBox == true then
            self.m_bSetOriginalPos = true
        end

        self.m_tAssistIn = CopyTable(tTempFriend)
    elseif self.m_nSelect == 6 then
        --防止频繁刷新
        if self.m_bIsChangeBox ~= true then
            local bIsChange = self:compareFriendData(self.m_tMaster,tFriend)
            if bIsChange == false then
                return
            end
        end
        --初始进入界面时或者手动点了标签按钮时
        if self.m_tMaster == nil or self.m_bIsChangeBox == true then
            self.m_bSetOriginalPos = true
        end

        self.m_tMaster = CopyTable(tFriend)
	end
    self.m_bIsChangeBox = false

	self:_update()
end

--@brief    比较2个好友id和状态是否改变
function WndRoomInviteList:compareFriendData(tabA,tabB)
    if tabA == nil or tabB == nil then
        return true
    end
    if #tabA ~= #tabB then
        return true
    end

    for i=1,#tabA do
        local bIsExist = false
        for j=1,#tabB do
            if tabA[i].id == tabB[j].id then
                bIsExist = true
                if tabA[i].status ~= tabB[j].status then
                    return true
                end
            end
        end
        if bIsExist == false then
            return true
        end
    end

    return false
end

--@brief    在房间内的玩家Id
function WndRoomInviteList:setInviteFriendIds( m_tInviteFriendIds )
    WZLog("WndRoomInviteList:setInviteFriendIds..."..#m_tInviteFriendIds)
    if self.m_tInviteFriendIds ~= nil then 
        local m_tIds = {}
        for i,v in ipairs(self.m_tInviteFriendIds) do
            local m_bHasId = true 
            for j, tData in ipairs(m_tInviteFriendIds) do
                if v == tData then 
                    m_bHasId = false
                end 
            end
            if m_bHasId then 
                table.insert(m_tIds,v)
            end 
        end
        local m_tDelIds = {}

        if self.m_tInvitePlayer~=nil and #self.m_tInvitePlayer >0 then 
            for j,v in ipairs(self.m_tInvitePlayer) do
                for i,tData in pairs(m_tIds) do
                    if v == tData then 
                        table.insert(m_tDelIds,v)
                    end 
                end
            end
            for j,tData in ipairs (m_tDelIds) do
                WZLog("remove data "..tData)
                table.remove(self.m_tInvitePlayer,j)
            end
        end 
        
        if m_tDelIds ~= nil and #m_tDelIds>0 then 
            WZLog("=======================================================xxx")
            self:_update()
        end 
    end 
    self.m_tInviteFriendIds = m_tInviteFriendIds 
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
