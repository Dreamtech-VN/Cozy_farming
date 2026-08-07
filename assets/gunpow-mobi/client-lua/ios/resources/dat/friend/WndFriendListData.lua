--WndFriendListData.lua
--@brief	WndFriendList的数据模块
--@date		2014/03/26
--@author	liangguang_long
--@note		附近好友模块

WndFriendList = {
	--请不要在这里定义变量
	
}

GUILD = 2
FRIEND = 1

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndFriendList:_init()
	self.m_root = nil
	self.m_tFriend = nil
	self.m_tPopupMenuItems = nil 
	self.m_tGuild = nil 
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
function WndFriendList:_unInit()
	self.m_root = nil
	self.m_tFriend = nil
	self.m_nIndex = nil 
	self.m_tPopupMenuItems = nil 
	self.m_tGuild = nil 
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

--@brief 	在房间内的玩家Id
function WndFriendList:setInviteFriendIds( m_tInviteFriendIds )
	WZLog("WndFriendList:setInviteFriendIds..."..#m_tInviteFriendIds)
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


function WndFriendList:receiveFriendListData()
	WZLog("WndFriendList:receiveFriendListData()::")
	self:closeLoading()
	self:setFriendData(CacheCenter:getFriendDataList())
end

function WndFriendList:setFriendData(tFriend)
	if self.m_root == nil then
		return
    end
    if tFriend ~= nil then
        WZLog("tFriend ~= nil")
        table.sort(tFriend,_sortWndFriendList)
    end

	if self.m_nSelect == 1 then 
        local tTempFriend = CopyTable(tFriend)
        self.m_tFriend = {}
        
        if self.m_nInterface == 3 or self.m_nInterface == 6 or self.m_nInterface == 7 or self.m_nInterface == 11 or self.m_nInterface == 12 or self.m_nInterface == 14 or self.m_nInterface == 15 then
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
	end

	self:_update()
end

--@brief    排序
function _sortWndFriendList(a,b)
    WZLog("_sortWndFriendList(a,b)")
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
function WndFriendList:createLoading()
	self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end

--@brief   关闭加载框
function WndFriendList:closeLoading()
	MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndFriendList:createElement()
	local element = WZUISystem:getInstance():createElement("WndFriendList")
	assert(element, "WndFriendList create element failed!")
	self:_init()
	WZLog("WndFriendList:createElement::")
	return element
end

--@brief	刷新界面
function WndFriendList:RefreshInterface()
	
end

--1、发请柬,2、婚礼邀请,3、战斗邀请,4、邮件邀请,5、异性单身 ,31、公会战好友(Add By Shengqiang), 8、英雄联赛邀请, 9.公会战房间邀请（Add by Tianxiang）,11、排位赛，12、娱乐赛，13、公会邀请, 14.组队世界boss邀请, 15.邀请双修
--tCell回调的类self a
--backFun回调的方法接受一个参数data function a:b(data,index) end
--结婚返回：回调方法tData: tData[1].id,tData[2].id...... index是界面索引id(如有"好友","公会"),索引1:好友，2:公会
--3、战斗邀请,4、邮件邀请返回tData,tData.id,tData.name
--topLevel :排位赛房间用到（排位等级）
function WndFriendList:showInterface(index,tCell,backFun,topLevel)
	if index == 1 or index == 2 or index == 5 then
		WndMarryFriend:showInterface(index,tCell,backFun)
		return
	end
	local approval = WndFriendList:createElement()
	self.m_nInterface = index 	
    self.m_nTopLevel = topLevel
	WindowManager:addWindow( approval , WndFriendList)
	if tCell and backFun then
		self.m_tBack = {}
		self.m_tBack[1] = tCell
		self.m_tBack[2] = backFun
	end
 
end

--@brief    设置相关操作
function WndFriendList:onInitInterface(index)
    -- body
    local txtWndTitleName_WndFriendList = GetElement(self.m_root,"txtWndTitleName_WndFriendList",WZUILabelTTF)

    --邮件邀请：大厅不可按
    local checkTheme1 = GetElement(self.m_root,"btnTheme1_WndFriendList",WZUIButton) --大厅
    local checkTheme2 = GetElement(self.m_root,"btnTheme2_WndFriendList",WZUIButton) --好友
    local checkTheme3 = GetElement(self.m_root,"btnTheme3_WndFriendList",WZUIButton) --公会
    local checkTheme5 = GetElement(self.m_root,"btnTheme5_WndFriendList",WZUIButton) --助战

    local conImgTheme_WndFriendList = GetElement(self.m_root,"conImgTheme_WndFriendList",WZUIContainer)
    
    local conTheme1 = GetElement(self.m_root,"conCheck3_WndFriendList",WZUIContainer) --大厅
    local conTheme2 = GetElement(self.m_root,"conCheck1_WndFriendList",WZUIContainer) --好友
    local conTheme3 = GetElement(self.m_root,"conCheck2_WndFriendList",WZUIContainer) --公会
    local conCheck5 = GetElement(self.m_root,"conCheck5_WndFriendList",WZUIContainer) --助战
    checkTheme5:setVisible(false)
    conCheck5:setVisible(false)

    if index == 4 or index == 7 then
        conTheme2:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        conTheme2:setRelativePosition(GlobalMethod:ccp(0.5,0.85))
        conTheme3:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        conTheme3:setRelativePosition(GlobalMethod:ccp(0.5,0.561538))
        conTheme1:setVisible(false)

        checkTheme2:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        checkTheme2:setRelativePosition(GlobalMethod:ccp(1.05,0.815))
        conImgTheme_WndFriendList:setRelativePosition(GlobalMethod:ccp(1.0575,0.815))
        checkTheme3:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        checkTheme3:setRelativePosition(GlobalMethod:ccp(1.05,0.68))
        checkTheme1:setVisible(false)
        self.m_nSelect=1
        txtWndTitleName_WndFriendList:setText(LocalStrings.FRIEND)
    elseif index == 31 or index == 9 then --公会战请求
        txtWndTitleName_WndFriendList:setText(LocalStrings.INVITE)
        checkTheme1:setVisible(false)
        checkTheme2:setVisible(false)
        checkTheme3:setVisible(false)
        conTheme1:setVisible(false)
        conTheme2:setVisible(false)
        conTheme3:setVisible(false)
        conImgTheme_WndFriendList:setVisible(false)
        self.m_nSelect = 2 
    elseif index == 8 then
        txtWndTitleName_WndFriendList:setText(LocalStrings.INVITE)
        self.m_nSelect=1
        checkTheme1:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        checkTheme1:setRelativePosition(GlobalMethod:ccp(1.05,0.815))
    
        checkTheme2:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        checkTheme2:setRelativePosition(GlobalMethod:ccp(1.05,0.68))
        checkTheme2:setVisible(true)

        checkTheme3:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        checkTheme3:setRelativePosition(GlobalMethod:ccp(1.05,0.545))
        
        conImgTheme_WndFriendList:setRelativePosition(GlobalMethod:ccp(1.0575,0.68))
        
        conTheme1:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        conTheme1:setRelativePosition(GlobalMethod:ccp(0.5,0.85))
        
        conTheme2:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        conTheme2:setRelativePosition(GlobalMethod:ccp(0.5,0.561538))
        conTheme2:setVisible(true)
        
        conTheme3:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        conTheme3:setRelativePosition(GlobalMethod:ccp(0.5,0.273077))
        self:_setSignWordStrokeColor()
    elseif index == 13 then
        txtWndTitleName_WndFriendList:setText(LocalStrings.INVITE)
        checkTheme1:setVisible(false)
        checkTheme3:setVisible(false)
        conTheme1:setVisible(false)
        conTheme3:setVisible(false)

        conImgTheme_WndFriendList:setRelativePosition(GlobalMethod:ccp(1.0575,0.815))

        checkTheme2:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        checkTheme2:setRelativePosition(GlobalMethod:ccp(1.05,0.815))
        checkTheme2:setVisible(true)

        conTheme2:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        conTheme2:setRelativePosition(GlobalMethod:ccp(0.5,0.85))
        conTheme2:setVisible(true)
    elseif index == 15 then 
        txtWndTitleName_WndFriendList:setText(LocalStrings.INVITE)
        checkTheme2:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        checkTheme2:setRelativePosition(GlobalMethod:ccp(1.05,0.815))
        conTheme2:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        conTheme2:setRelativePosition(GlobalMethod:ccp(0.5,0.835))
        conTheme2:setVisible(true)
    
        checkTheme3:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        checkTheme3:setRelativePosition(GlobalMethod:ccp(1.05,0.68))
        conTheme3:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        conTheme3:setRelativePosition(GlobalMethod:ccp(0.5,0.561538))
        conTheme3:setVisible(true)

        checkTheme1:setVisible(false)
        conTheme1:setVisible(false)
    else
        txtWndTitleName_WndFriendList:setText(LocalStrings.INVITE)
        self.m_nSelect=3
        checkTheme1:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        checkTheme1:setRelativePosition(GlobalMethod:ccp(1.05,0.815))
    
        checkTheme2:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        checkTheme2:setRelativePosition(GlobalMethod:ccp(1.05,0.68))
        
        checkTheme3:setVisible(true)
        checkTheme3:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        checkTheme3:setRelativePosition(GlobalMethod:ccp(1.05,0.545))
        
        conImgTheme_WndFriendList:setRelativePosition(GlobalMethod:ccp(1.0575,0.815))
        
        conTheme1:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        conTheme1:setRelativePosition(GlobalMethod:ccp(0.5,0.85))
        
        conTheme2:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        conTheme2:setRelativePosition(GlobalMethod:ccp(0.5,0.561538))
        
        conTheme3:setVisible(true)
        conTheme3:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        conTheme3:setRelativePosition(GlobalMethod:ccp(0.5,0.273077))
        if index == 6 then
            checkTheme5:setVisible(true)
            conCheck5:setVisible(true)
            if GlobalMethod:crossServiceOpen() == 0 then
                conCheck5:setRelativePosition(GlobalMethod:ccp(0.5,-0.015))
                checkTheme5:setRelativePosition(GlobalMethod:ccp(1.05,0.41))
            end
        end
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
    end
end


--@brief   	获取一帧创建多少个列表数量
--@param   	element:列表容器的节点
function WndFriendList:_getOneFrameCount(element,tFriend)
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
function WndFriendList:_showEmptyTip(count,desc)
	local conInvitedMsg_WndFriendList = GetElement(self.m_root,"conInvitedMsg_WndFriendList",WZUIContainer)
	removeShowPanelNullTip(conInvitedMsg_WndFriendList)
	if count > 0 then
		return
	else
        ShowPanelNullTip(conInvitedMsg_WndFriendList, desc)
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------







































