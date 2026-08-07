--WndWorldTeamBossInviteData.lua
--@brief	WndWorldTeamBossInvite的数据模块
--@date		2020/05/11
--@author	XTX
--@note		世界组队Boss邀请界面

WndWorldTeamBossInvite = {
	--请不要在这里定义变量
}

GUILD = 2
FRIEND = 1

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndWorldTeamBossInvite:_init()
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
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndWorldTeamBossInvite:_unInit()
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
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndWorldTeamBossInvite:createElement()
	if WndWorldTeamBossInvite.m_root ~= nil then
		WindowManager:removeWindow(WndWorldTeamBossInvite.m_root, WndWorldTeamBossInvite, true)
	end
	local element = WZUISystem:getInstance():createElement("WndWorldTeamBossInvite")
	assert(element, "WndWorldTeamBossInvite create element failed!")
	self:_init()
	return element
end

--@brief 	在房间内的玩家Id
function WndWorldTeamBossInvite:setInviteFriendIds( m_tInviteFriendIds )
	WZLog("WndWorldTeamBossInvite:setInviteFriendIds..."..#m_tInviteFriendIds)
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


function WndWorldTeamBossInvite:receiveFriendListData()
	WZLog("WndWorldTeamBossInvite:receiveFriendListData()::")
	self:closeLoading()
	self:setFriendData(CacheCenter:getFriendDataList())
end

function WndWorldTeamBossInvite:setFriendData(tFriend)
	if self.m_root == nil then
		return
    end
    if tFriend ~= nil then
        WZLog("tFriend ~= nil")
        table.sort(tFriend,_sortWndWorldTeamBossInvite)
    end
	if self.m_nSelect == 1 then 
        local tTempFriend = CopyTable(tFriend)
        self.m_tFriend = {}
        
        if self.m_nInterface == 3 or self.m_nInterface == 6 or self.m_nInterface == 7 or self.m_nInterface == 11 or self.m_nInterface == 12 or self.m_nInterface == 14 or self.m_nInterface == 15 or self.m_nInterface == 16 then
            self.m_tFriend = tTempFriend
        else
            for k, value in pairs(tTempFriend) do
                if value.serverId == CacheCenter:getPlayerInfo().serverId then
                    table.insert(self.m_tFriend, value)
                end
            end
        end
	elseif self.m_nSelect == 2 then
        local tTempFriend = {}
        for i = 1, #tFriend do
            if tFriend[i].serverId == tonumber(CacheCenter:getPlayerInfo().serverId) then
                table.insert(tTempFriend, tFriend[i])
            end
        end
		self.m_tGuild = CopyTable(tTempFriend)
    elseif self.m_nSelect == 3 then
        self.m_tHall = CopyTable(tFriend)
    elseif self.m_nSelect == 5 then
        self.m_tAssistIn = {}
        local tTempFriend = CopyTable(tFriend)
        for k, value in pairs(tTempFriend) do
            if value.serverId == CacheCenter:getPlayerInfo().serverId then
                table.insert(self.m_tAssistIn, value)
            end
        end
    elseif self.m_nSelect == 6 then
    	if not self.m_tMaster then
    		local tTempFriend = {}
	        for i = 1, #tFriend do
	            if tFriend[i].serverId == tonumber(CacheCenter:getPlayerInfo().serverId) then
	                table.insert(tTempFriend, tFriend[i])
	            end
	        end
			self.m_tMaster = CopyTable(tTempFriend)
    	end
	end

	self:_update()
end

--@brief    排序
function _sortWndWorldTeamBossInvite(a,b)
    WZLog("_sortWndWorldTeamBossInvite(a,b)")
    --伴侣 》师徒 》等级 
    local mateName = CacheCenter:getPlayerInfo().mateName
    WZLog("mateName===",mateName)
    --伴侣
    if a.name == mateName then
        return true
    elseif b.name == mateName then
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


function sortMarryFriend(a,b)
	if a.level ~= b.level then 
		return a.level >= b.level
	end
end

--@brief   创建加载框
function WndWorldTeamBossInvite:createLoading()
	self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end

--@brief   关闭加载框
function WndWorldTeamBossInvite:closeLoading()
	MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
end

--@brief	刷新界面
function WndWorldTeamBossInvite:RefreshInterface()
	
end

--1、发请柬,2、婚礼邀请,3、战斗邀请,4、邮件邀请,5、异性单身 ,31、公会战好友(Add By Shengqiang), 8、英雄联赛邀请, 9.公会战房间邀请（Add by Tianxiang）,11、排位赛，12、娱乐赛，13、公会邀请, 14.组队世界boss邀请, 15.邀请双修 16.双人爬塔邀请
--tCell回调的类self a
--backFun回调的方法接受一个参数data function a:b(data,index) end
--结婚返回：回调方法tData: tData[1].id,tData[2].id...... index是界面索引id(如有"好友","公会"),索引1:好友，2:公会
--3、战斗邀请,4、邮件邀请返回tData,tData.id,tData.name
--topLevel :排位赛房间用到（排位等级）
function WndWorldTeamBossInvite:showInterface(index,tCell,backFun,topLevel)
	if index == 1 or index == 2 or index == 5 then
		WndMarryFriend:showInterface(index,tCell,backFun)
		return
	end
	local approval = WndWorldTeamBossInvite:createElement()
	self.m_nInterface = index 	
    self.m_nTopLevel = topLevel
	WindowManager:addWindow( approval , WndWorldTeamBossInvite)
	if tCell and backFun then
		self.m_tBack = {}
		self.m_tBack[1] = tCell
		self.m_tBack[2] = backFun
	end
 
end

--@brief    设置相关操作
function WndWorldTeamBossInvite:onInitInterface(index)
    -- body
    --邮件邀请：大厅不可按
    local checkTheme1 = GetElement(self.m_root,"btnTheme1_WndWorldTeamBossInvite",WZUIButton) --大厅
    local checkTheme2 = GetElement(self.m_root,"btnTheme2_WndWorldTeamBossInvite",WZUIButton) --好友
    local checkTheme3 = GetElement(self.m_root,"btnTheme3_WndWorldTeamBossInvite",WZUIButton) --公会
    local checkTheme5 = GetElement(self.m_root,"btnTheme5_WndWorldTeamBossInvite",WZUIButton) --助战
    local checkTheme6 = GetElement(self.m_root,"btnTheme6_WndWorldTeamBossInvite",WZUIButton) --师门

    local conImgTheme_WndWorldTeamBossInvite = GetElement(self.m_root,"conImgTheme_WndWorldTeamBossInvite",WZUIContainer)
    
    local conTheme1 = GetElement(self.m_root,"conCheck3_WndWorldTeamBossInvite",WZUIContainer) --大厅
    local conTheme2 = GetElement(self.m_root,"conCheck1_WndWorldTeamBossInvite",WZUIContainer) --好友
    local conTheme3 = GetElement(self.m_root,"conCheck2_WndWorldTeamBossInvite",WZUIContainer) --公会
    local conCheck5 = GetElement(self.m_root,"conCheck5_WndWorldTeamBossInvite",WZUIContainer) --助战
    local conCheck6 = GetElement(self.m_root,"conCheck6_WndWorldTeamBossInvite",WZUIContainer) --师门
    checkTheme5:setVisible(false)
    conCheck5:setVisible(false)
    checkTheme6:setVisible(false)
    conCheck6:setVisible(false)
    if index == 14 then 
        self.m_nSelect = 3
        checkTheme6:setVisible(true)
    	conCheck6:setVisible(true)
    end

    --发送协议
    if index ==4 or index == 7 then 
        ProtocolProcessorWndFriends:send_FRIEND_GetFriend(index,1)
    elseif index==3  or index == 6 then 
        ProtocolProcessorWndFriends:send_FRIEND_GetFriend(index,3) 
    elseif index == 31 then 
        ProtocolProcessorWndFriends:send_FRIEND_GetFriend(6,2)
    elseif index == 8 then  --英雄联赛邀请
        ProtocolProcessorWndFriends:send_FRIEND_GetFriend(index,1)
    elseif index == 9 then  --公会战房间邀请
        ProtocolProcessorWndFriends:send_FRIEND_GetFriend(index,2)
    elseif index == 11 then  --排位赛房间邀请
        ProtocolProcessorWndFriends:send_FRIEND_GetFriend(index,3,self.m_nTopLevel)
    elseif index == 12 then  --娱乐赛房间邀请
        ProtocolProcessorWndFriends:send_FRIEND_GetFriend(index,3)
    elseif index == 13 then  --邀请加入公会
        ProtocolProcessorWndFriends:send_FRIEND_GetFriend(index,1)
    elseif index == 14 then  --世界组队boss
        ProtocolProcessorWndFriends:send_FRIEND_GetFriend(index,3)
    elseif index == 15 then  --邀请双修
        ProtocolProcessorWndFriends:send_FRIEND_GetFriend(index,1)
    elseif index == 16 then  --邀请助战双人爬塔
        ProtocolProcessorWndFriends:send_FRIEND_GetFriend(index,3)
    end
end


--@brief   	获取一帧创建多少个列表数量
--@param   	element:列表容器的节点
function WndWorldTeamBossInvite:_getOneFrameCount(element,tFriend)
	if tFriend == nil or element == nil then
		element:disableSchedule()
		return 0
	end
	local mailCount = #tFriend
	local nMailTime = 1
	local nTime = mailCount - self.m_nIndex
	if nTime < nMailTime then
		nMailTime = nTime
		element:disableSchedule()--停止定时器
	end
	return nMailTime
end

--@brief	空数据提示语
function WndWorldTeamBossInvite:_showEmptyTip(count,desc)
	local conInvitedMsg_WndWorldTeamBossInvite = GetElement(self.m_root,"conInvitedMsg_WndWorldTeamBossInvite",WZUIContainer)
	removeShowPanelNullTip(conInvitedMsg_WndWorldTeamBossInvite)
	if count > 0 then
		return
	else
        ShowPanelNullTip(conInvitedMsg_WndWorldTeamBossInvite, desc)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
