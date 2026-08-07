--SceneMemberList.lua
--@brief	SceneMemberList的UI模块
--@date		2013/12/26
--@author	zsq
--@note		公会大厅


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function SceneMemberList:onEnter(element)
	self.m_root = element
	--注册协议
	ProtocolProcessorSceneCommunity:regAll()	

	--静态初始化UI文字
	self:_initStaticUiText()

	--添加顶部栏
	self:_addTop()

	--获取公会大厅
	self.m_bFirstEntry = true
	ProtocolProcessorSceneCommunity:send_GUILD_GetGuildHall()
	SceneCommunityMain:createLoading()
	self:AdaptResolution()
	AdaptLanguage(self)
end

function SceneMemberList:onEnterTransitionDidFinish(element)
	GetElement(self.m_root,"conMain1",WZUIContainer):setVisible(true)
	GetElement(self.m_root,"conMain2",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conMain3",WZUIContainer):setVisible(false)
    if "hk" == ProjConfig.LANGUAGE then
        GetElement(self.m_root,"con3",WZUIContainer):setVisible(false)
    end
end

function SceneMemberList:_addTop()
    local cell,tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
    tcell:setTopData("ui/community/common_icon_ghdt.png",SceneMemberList,SceneMemberList.onClose,true,true,false,"SceneMemberList")
	self.m_tTop = cell
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function SceneMemberList:onExit(element)
	--add by wuweidong
    GlobalGame:getBtnRedPointEvent():unregListener("btnTask","SceneMemberList")
    GlobalGame:getBtnRedPointEvent():unregListener("btnBag","SceneMemberList")
	self:_unInit()
end

--@brief	关闭按钮
function SceneMemberList:onClose(element)
	WZLog("SceneMemberList:onClose")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	--进入公会场景
    WindowManager:removeWindow(self.m_root, self, true)

	SceneCommunityMain:showBtns()
end

function SceneMemberList:onNormal() 
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_tTop:removeFromParentAndCleanup(true)
    local cell,tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
	self.m_tTop = cell
    tcell:setTopData("ui/community/common_icon_ghdt.png",SceneMemberList,SceneMemberList.onClose,true,true,false,"SceneMemberList")

	GetElement(self.m_root,"conMain1",WZUIContainer):setVisible(true)
	GetElement(self.m_root,"conMain2",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conMain3",WZUIContainer):setVisible(false)

	self:_updateKeepPosition()
    local tbconList = GetElement(self.m_root, "tbconTextContent_SceneMemberList", WZUITableContainer)
    tbconList:getMoveElement():setPositionY(tbconList:getMinPosition().y)
end

function SceneMemberList:onSetToNormal() 
	self:onNormal()
end

--@brief	升级
function SceneMemberList:onBtm1() 
	WZLog("SceneMemberList:onBtm1")
	self:onUpgrade()
end

--@brief	设置
function SceneMemberList:onBtm2() 
	WZLog("SceneMemberList:onBtm2")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_tTop:removeFromParentAndCleanup(true)
    local cell,tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
	self.m_tTop = cell
    tcell:setTopData("ui/community/gonghui_biaoti02.png",SceneMemberList,SceneMemberList.onSetToNormal,true,true,false,"SceneMemberList")

	GetElement(self.m_root,"conMain1",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conMain2",WZUIContainer):setVisible(true)
	GetElement(self.m_root,"conMain3",WZUIContainer):setVisible(false)
end

--@brief	管理
function SceneMemberList:onBtm3() 
	WZLog("SceneMemberList:onBtm3")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_tTop:removeFromParentAndCleanup(true)
    local cell,tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
	self.m_tTop = cell
    tcell:setTopData("ui/community/gonghui_biaoti01.png",SceneMemberList,SceneMemberList.onNormal,true,true,false,"SceneMemberList")

	GetElement(self.m_root,"conMain1",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conMain2",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conMain3",WZUIContainer):setVisible(true)
end

--@brief	公会日志
function SceneMemberList:onLog(element)
	WZLog("SceneMemberList:onLog")
	--SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local wndCommunityLog = WndCommunityLog:createElement()
	if wndCommunityLog ~= nil then 
		WindowManager:addWindow(wndCommunityLog,WndCommunityLog,nil,nil,nil,true)
	end 
end

--@brief	管理按钮
function SceneMemberList:onManage(element)
	WZLog("SceneMemberList:onManage")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)


	local conForPopMenu = GetElement(self.m_root, "conForPopMenu_SceneMemberList", WZUIContainer)
	local sizeCon = conForPopMenu:getAbsContentSize()
	WZLog("********** sizeCon *************", sizeCon.width)
	
	local popupMenu = WndPopupMenu:createElement()
	conForPopMenu:addChild(popupMenu)	
	popupMenu:setVisible(true)
	WZLog("self.m_root",self.m_root,popupMenu:getPositionX(),popupMenu:getPositionY(),popupMenu:isVisible())

	WndPopupMenu:disappear()

	local menuList = self:setManageMenuItems()
	WndPopupMenu:setPopupMenuItem(menuList,nil,2)
	WndPopupMenu:setCallBackFunc(self, self.onClickPopup)

	local menuNum = 0
	for _,v in pairs(menuList) do
		menuNum = menuNum + 1
	end

	if self.m_root ~= nil then
		local position = tonumber(CacheCenter:getPlayerInfo().position)
		if position == 4 then
			GetElement(self.m_root,"conForPopMenu_SceneMemberList",WZUIContainer):setRelativePosition(ccp(0.68,0.2))
		end
		if position == 3 then
			GetElement(self.m_root,"conForPopMenu_SceneMemberList",WZUIContainer):setRelativePosition(ccp(0.68,0.4))
		end
		WndPopupMenu:popUpAtPoint(conForPopMenu, ccp((sizeCon.width - 190)/2, -500))
		WndPopupMenu.m_root:setScaleY(0.88)
		GetElement(WndPopupMenu.m_root,"tbconMenuItem_WndPopupMenu",WZUITableContainer):setScaleY(0.97)
	end 
end

--@brief	根据权限设置管理菜单
function SceneMemberList:setManageMenuItems()
	local position = tonumber(CacheCenter:getPlayerInfo().position)
	WZLog("SceneMemberList:setManageMenuItems",position)

	local tPopupMenuItems = {}

	--公会邀请
	if position >= 3 then
		table.insert(tPopupMenuItems,POPUPMENU_COMMUNITY9)
	end
	 
	--职位任命
	if position >= 2 then
		table.insert(tPopupMenuItems,POPUPMENU_COMMUNITY8)
	end

	--是否显示查看会员贡献按钮
	table.insert(tPopupMenuItems,POPUPMENU_COMMUNITY7)

	--是否显示入会申请按钮
	if position >= COMMUNITY_ELDER then
    	if GlobalGame.g_tRedPointList.community then
			table.insert(tPopupMenuItems,tostring(POPUPMENU_COMMUNITY1))
		else
			table.insert(tPopupMenuItems,POPUPMENU_COMMUNITY1)
		end
	end

	--是否显示公会升级按钮
	if position >= 3 then
		table.insert(tPopupMenuItems,POPUPMENU_COMMUNITY3)
	end

	--是否显示群发邮件按钮
	if position >= 2 then
		table.insert(tPopupMenuItems,POPUPMENU_COMMUNITY5)
	end

	--是否显示修改宣言按钮
	if position >= 3 then
		table.insert(tPopupMenuItems,POPUPMENU_COMMUNITY2)
	end

	--是否显示公会设置按钮
	if position >= 4 then
		table.insert(tPopupMenuItems,POPUPMENU_COMMUNITY4)
	end

	--显示退出公会按钮
	table.insert(tPopupMenuItems,POPUPMENU_COMMUNITY6)

	return tPopupMenuItems
end

--@brief	查看会员贡献
function SceneMemberList:onDonate(element)
	WZLog("SceneMemberList:onDonate")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local wndCommunityCheckDonate = WndCommunityCheckDonate:createElement()
	if wndCommunityCheckDonate ~= nil then 
		WindowManager:addWindow(wndCommunityCheckDonate,WndCommunityCheckDonate,nil,nil,nil,true)
	end
end

--@brief	公会申请
function SceneMemberList:onApply(element)
	WZLog("SceneMemberList:onApply")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	--审批设置为已查看状态
	GlobalGame.g_tRedPointList.community = false
	SceneCommunityMain.m_bRecruitChecked = true
	GetElement(self.m_root,"imgApply_SceneMemberList",WZUIImage):setVisible(false)
	GetElement(self.m_root,"imgApply1_SceneMemberList",WZUIImage):setVisible(false)
    --大厅图片
    local imgHall = GetElement(SceneCommunityMain.m_root,"img2_SceneCommunity",WZUIImage)
	--删除重复节点
	if imgHall:getChildByTag(668) then
		imgHall:removeChildByTag(668,true)
	end

    --if GlobalGame.g_tRedPointList.community then
        --SceneCity:updateRedDotBuilding("community", false)
        ProtocolProcessorSceneCity:send_PLAYER_CancelRedDot(34)
    --end

	local wndRecruit = WndRecruit:createElement()
	if wndRecruit ~= nil then 
		WindowManager:addWindow(wndRecruit,WndRecruit,nil,nil,nil,true)
	end
end

--@brief	公会升级
function SceneMemberList:onUpgrade(element)
	WZLog("SceneMemberList:onUpgrade")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local guildInfo = CacheCenter:getGuildInfo()
	if GUILDMAXLEVEL == nil then
		GUILDMAXLEVEL = GetMaxGuildLevel()
	end
	--公会已是最高等级
	if guildInfo.guildLevel >= GUILDMAXLEVEL then
		MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO45)
		return
	end

	local cost = 0
	local costZuan = 0
	local costId = 70
	for k,v in pairs(GDatatab_guild_level) do
		if v.level == (guildInfo.guildLevel + 1) then
			cost = v.cost[1][2]
			costZuan = v.cost[2][2]
			costId = v.cost[2][1]
		end
	end 

	WndCommunityUpgrade:showCommunityUpgrade() 
	WndCommunityUpgrade.m_nCost = cost
	WndCommunityUpgrade.m_nCostZuan = costZuan
	WndCommunityUpgrade.m_nCostId = costId
end

--@brief	公会邮件
function SceneMemberList:onMail(element)
	WZLog("SceneMemberList:onMail")
	--音效
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local wndCommunityPopContent = WndCommunityPopContent:createElement()
	WindowManager:addWindow(wndCommunityPopContent,WndCommunityPopContent)
	--设置群发邮件内容
	WndCommunityPopContent:setImgTitle(3)
	--设置窗口标记
	WndCommunityPopContent:modifyCurWindow(3)
	--设置默认内容
	--WndCommunityPopContent:setEditBoxInputContent(LocalStrings.COMMUNITYINFO54,155,131,122)
	WndCommunityPopContent:setEditBoxPlaceHolder(LocalStrings.COMMUNITYINFO54)
end

--@brief	公会宣言
function SceneMemberList:onDeclaration(element)
	WZLog("SceneMemberList:onDeclaration")
	--音效
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local wndCommunityPopContent = WndCommunityPopContent:createElement()
	WindowManager:addWindow(wndCommunityPopContent,WndCommunityPopContent)
	--设置公会宣言
	WndCommunityPopContent:setImgTitle(1)
	--设置默认内容
	if CacheCenter:getGuildInfo().desc == "" then
		--WndCommunityPopContent:setEditBoxInputContent(LocalStrings.COMMUNITYINFO44,155,131,122)
		WndCommunityPopContent:setEditBoxPlaceHolder(LocalStrings.COMMUNITYINFO44)
	else
		--WndCommunityPopContent:setEditBoxInputContent(CacheCenter:getGuildInfo().desc,155,131,122)
		WndCommunityPopContent:setEditBoxPlaceHolder(CacheCenter:getGuildInfo().desc)
	end
	--设置窗口标记
	WndCommunityPopContent:modifyCurWindow(1) 
end

--@brief	公会设置
function SceneMemberList:onSetting(element)
	WZLog("SceneMemberList:onSetting")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local wndSetEnemyCommunity = WndSetEnemyCommunity:createElement()
	WindowManager:addWindow(wndSetEnemyCommunity,WndSetEnemyCommunity)
end

--@brief	退出公会
function SceneMemberList:onQuit(element)
	WZLog("SceneMemberList:onQuit")
	--音效
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local myPosition
	for k,v in pairs(SceneMemberList.m_tMemberList) do
		if v.playerId == CacheCenter:getPlayerInfo().id then
			myPosition = v.position
		end
	end
	WZLog("我的职位:",myPosition,myPosition==COMMUNITY_PRESIDENT)
	if myPosition == COMMUNITY_PRESIDENT then
		--我是会长并且公会成员数大于一，提示请先转让会长
		if SceneMemberList.m_nMembers > 1 then
			MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO23)
			return
		else
		--我是会长并且公会成员数等于一，弹出是否解散公会的窗口
			local wndDismissCommunity = WndDismissCommunity:createElement()
			WindowManager:addWindow(wndDismissCommunity,WndDismissCommunity)
    		WndDismissCommunity:setBtnVisable(1)
			WndDismissCommunity:setFlagWindow(3)
			WndDismissCommunity:setTxtMidContent(LocalStrings.COMMUNITYINFO24)
			--标题退出公会
			GetElement(WndDismissCommunity.m_root, "txtTitle_WndDismiss", WZUILabelTTF):setText(LocalStrings.COMMUNITY6)
		end
	else
		--弹出是否退出公会的窗口
		local wndDismissCommunity = WndDismissCommunity:createElement()
		WindowManager:addWindow(wndDismissCommunity,WndDismissCommunity)
		WndDismissCommunity:setExitCommunityWindow()
    	WndDismissCommunity:setBtnVisable(1)
	end
	--ProtocolProcessorSceneCommunity:send_GUILD_Resignations()
end

--@brief  按钮回调函数
--@param #1 element:点击消息框的窗口对象
--@param #2	nId:点击消息框的那个ID
function SceneMemberList:onClickPopup(element,nId)
	WndPopupMenu:disappear()
	if nId == POPUPMENU_COMMUNITY1 then 	
		self:onApply()
	elseif nId == POPUPMENU_COMMUNITY2 then   
		self:onDeclaration()
	elseif nId == POPUPMENU_COMMUNITY3 then
		self:onUpgrade()
	elseif nId == POPUPMENU_COMMUNITY4 then
		self:onSetting()
	elseif nId == POPUPMENU_COMMUNITY5 then
		self:onMail()
	elseif nId == POPUPMENU_COMMUNITY6 then
		self:onQuit()
	elseif nId == POPUPMENU_COMMUNITY7 then
		self:onDonate()
	elseif nId == POPUPMENU_COMMUNITY8 then
		self:onAppoint()
	elseif nId == POPUPMENU_COMMUNITY9 then
		self:onInvite()
	end
end

--@brief	公会邀请
function SceneMemberList:onInvite()
	WZLog("SceneMemberList:onInvite")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndFriendList:showInterface(13, SceneMemberList, SceneMemberList.inviteCommunityMember)
end

function SceneMemberList:inviteCommunityMember(tData)
	WZLog("SceneMemberList:inviteCommunityMember", tData.id)
	ProtocolProcessorSceneCommunity:send_GUILD_Invite(tData.id )
end

function SceneMemberList:onAcceptInvite()
	WZLog("SceneMemberList:onAcceptInvite", SceneMemberList.inviteId)
	ProtocolProcessorSceneCommunity:send_GUILD_ResponseInvite(SceneMemberList.inviteId, true )
end

--@brief	职位任命
function SceneMemberList:onAppoint()
	WZLog("SceneMemberList:onAppoint")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local wnd = WndCommunityAppoint:createElement()
	WindowManager:addWindow(wnd, WndCommunityAppoint, true, nil, nil, true)
end

--@brief	贡献按钮
function SceneMemberList:onContribution(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--判断今天是否已经贡献过
	if CacheCenter:getGuildInfo() == nil then return end
	if CacheCenter:getGuildInfo().buyDonate ~= "0" and CacheCenter:getGuildInfo().buyDonate ~= 0 then
		if LocalStrings.FIRST_DAY_CAN_NOT_DONATE and tonumber(CacheCenter:getGuildInfo().buyDonate) == 2 then
			MsgBoxManager:showTipBox(LocalStrings.FIRST_DAY_CAN_NOT_DONATE)
		else
			MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO103)
		end
	else
		local wndCommunityDonate = WndCommunityDonate:createElement()
		WindowManager:addWindow(wndCommunityDonate,WndCommunityDonate,nil,nil,nil,true)
	end
end

--@brief	点击表格中元素调用的函数
--@param	#1 element,点击表格元素那个对象本身
--@param	#2 nJob 点击单元格的职位
--@param	#3 sCelName 点击单元格的名字
--@param	#4 nCellPlayerId 点击单元格的ID
function SceneMemberList:onClickBtnFromCellCommunityMemberList(element,nJob,sCelName,nCellPlayerId,nTime,nState)
	WZLog("SceneMemberList:onClickBtnFromCellCommunityMemberList",nJob,nCellPlayerId,self:_getMyId())
	--点击自己直接返回
	if nCellPlayerId == self:_getMyId() then 
		return 
	end 
	
	WZLog("SceneMemberList:onClickBtnFromCellCommunityMemberList1",nJob,nCellPlayerId,self:_getMyId())
	--创建弹出框
	local popupMenu = WndPopupMenu:createElement()
	popupMenu:setShowAll(true)
	self.m_root:addChild(popupMenu)	
	popupMenu:setVisible(true)
	WZLog("self.m_root",self.m_root,popupMenu:getPositionX(),popupMenu:getPositionY(),popupMenu:isVisible())
	popupMenu:setShowAll(false)
	
	--音效
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	--if self.m_nCurWindowFlag == 1 then           --公会成员列表场景
		WZLog("self.m_nCurWindowFlag == 1 ")
		self.m_sCurCelName = sCelName
		self.m_nCurCelId = nCellPlayerId
		self.m_nJob = nJob
		self.m_nTime = nTime
		self.m_nState = nState
		WZLog("self.m_nCurCelId = ",self.m_nCurCelId )
		WndPopupMenu:disappear()
		--根据自己的职位和点击单元格的职位判断是否可降职和升职
		--self.m_nMyJob = COMMUNITY_PRESIDENT
		self.m_nMyJob = CacheCenter:getGuildInfo().position
		local tPopMenuItems = self:_getPopMenuItems(self.m_nMyJob,nJob)
		WndPopupMenu:setPopupMenuItem(tPopMenuItems, nil, 3)
		WndPopupMenu:setCallBackFunc(self, self.onClickPopupMenuItem)
		
		--转换触摸点坐标
		local cell = element:getParentElement()
		local x = cell:getPositionX()
		local y = cell:getPositionY()
		position = cell:convertToWorldSpace(CCPoint(x, y))
		position = self.m_root:convertToNodeSpace(position)
		position.y = position.y - 26
		if self.m_root ~= nil then
			WndPopupMenu:popUpAtPoint(self.m_root, position)
		end 
end 

function SceneMemberList:needHigherVipCallBack(nId, nResType)
    -- body
    if nResType == MSGBOXRESTYPE_CONFIRM then
        PassportSdkManager:gotoPaymentPage()
    end
end

--@brief  按钮回调函数
--@param #1 element:点击消息框的窗口对象
--@param #2	nId:点击消息框的那个ID，如私聊，发送邮件，查看资料，黑名单，删除等
function SceneMemberList:onClickPopupMenuItem(element,nId)
	WZLog(" WndFriend:onClickPopupMenuItem(element,nId)",self.m_nCurCelId)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if nId == POPUPMENU_ADD then 		    --加为好友
		local friendList = CacheCenter:getFriendList()
		--已经是好友提示
		if friendList ~= nil then
			for k,v in pairs(friendList) do
				if v.id == self.m_nCurCelId and v.type == 1 then
					WZLog("=======================1111111==========================")
					MsgBoxManager:showTipBox(LocalStrings.ISFRIEND)
					WndPopupMenu:disappear()
					return
				end
			end
		end
		--好友人数到上限提示
		if CacheCenter:getFriendCount() >= GetMaxFriends(CacheCenter:getPlayerInfo().vipLevel) then
        	local nMaxVipLevel = GetMaxVipLevel()
        	if CacheCenter:getPlayerInfo().vipLevel >= nMaxVipLevel then
        	    MsgBoxManager:showTipBox(LocalStrings.FRIEND_MAX)
        	else
        	    MsgBoxManager:showConfirmBox(LocalStrings.FRIENDS_FULL_ATT, self, self.needHigherVipCallBack, nil, nil)
        	end
			WndPopupMenu:disappear()
        	return
		end

		local vector = WZLuaVector_int_:create()
		vector:push(self.m_nCurCelId)
		ProtocolProcessorWndFriends:send_FRIEND_AddFriend(vector)
		WndPopupMenu:disappear()
		
	elseif nId == POPUPMENU_MAIL then       --发送邮件
		WndMail:showMail(self.m_nCurCelId,self.m_sCurCelName,"")
		WndPopupMenu:disappear()
		
	elseif nId == POPUPMENU_CHAT then 	    --私聊
		local tInfo
		for i=1,#self.m_tMemberList do
			if self.m_tMemberList[i].playerId == self.m_nCurCelId then
				tInfo = self.m_tMemberList[i]
				break
			end
		end
		--WndChat:showChatWindowForPrivateWithIdAndName(self.m_nCurCelId,self.m_sCurCelName)
		WndChat:showChatWindowForPrivateWithIdAndName(tInfo.playerId,tInfo.playerName,tInfo.sex,tInfo.playerLevel,tInfo.vipLevel,tInfo.headId,tInfo.faceId,tInfo.headColor)
		WndPopupMenu:disappear()
		
	elseif nId == POPUPMENU_INFO  then 	    --查看资料
        WndCheckOther:show(self.m_nCurCelId)
		WndPopupMenu:disappear()
		
	elseif nId == POPUPMENU_TRANSFER  then 	 --转让会长
		local wndDismissCommunity = WndDismissCommunity:createElement()
		WindowManager:addWindow(wndDismissCommunity,WndDismissCommunity)

		local txtYes = WndDismissCommunity.m_root:getChildElement("txtYes_WndDismissCommunity")
		   if txtYes then 
	            WZUILabelTTF:luaTo(txtYes):setText(LocalStrings.YES)
	            WZUILabelTTF:luaTo(txtYes):setVisible(true)
	       end 

		WndDismissCommunity:setClickCelPlayerId(self.m_nCurCelId)
		WndDismissCommunity:setClickCelPlayerName(self.m_sCurCelName)
		WndDismissCommunity:setPresidentContainerVisable()
		WndPopupMenu:disappear()
		
	elseif nId == POPUPMENU_PROMOTION then 	 --升职
		--副会长以下才能升职
		if self.m_nJob < COMMUNITY_VICE_PRESIDENT then
			ProtocolProcessorSceneCommunity:send_GUILD_ChangePost(self.m_nCurCelId, 1 )
		else
			MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO53)
		end
		WndPopupMenu:disappear()
	
	elseif nId == POPUPMENU_DEMOTED then 	 --降职
		--普通会员以上才能降职
		if self.m_nJob > COMMUNITY_MEMBER then
			ProtocolProcessorSceneCommunity:send_GUILD_ChangePost(self.m_nCurCelId, -1 )
		else
			MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO54)
		end
		WndPopupMenu:disappear()
	 
	elseif nId == POPUPMENU_FIRED then 	    --开除
		--弹出窗口内容：你确定将该玩家开除？
		local wndDismissCommunity = WndDismissCommunity:createElement()
		if wndDismissCommunity == nil then 
			return 
		end 
		WindowManager:addWindow(wndDismissCommunity,WndDismissCommunity)

		GetElement(WndDismissCommunity.m_root,"txtOK_WndDismissCommunity",WZUILabelTTF):setText(LocalStrings.CONFIRM)

		WndDismissCommunity:setCommunityFriedWindow(self.m_nTime, self.m_sCurCelName)
		WndDismissCommunity:setClickCelPlayerId(self.m_nCurCelId)
		WndPopupMenu:disappear()
	end 	
end 
	

--@brief	触摸函数，判断消息是否在消息框显示范围内，如果不是的话，就让消息框不显示，反之，显示
--@param #1	element:表绑定的UI节点引用
--@param #2	point:点击位置
function SceneMemberList:onTouchBegan(element, point)
	if self.m_root == nil then 
		WZLog("WndFriend:onTouchBegan(element, point) self.m_root is nil ")
	end 
	local bFlag = WndPopupMenu:ifPointInMenu(point)
	if bFlag == false then 
		--WndPopupMenu:disappear()
		WndPopupMenu:delMenu()
	end 

	if WndItemInfo.m_root then
        WndItemInfo:onCloseClick()
    end
end
	
function SceneMemberList:onFriendFind(element) 
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_sFind = GetElement(self.m_root,"editFind",WZUIEditBox):getText()
	GetElement(self.m_root,"btnCancelFind",WZUIButton):setVisible(true)
	self.m_bFirstEntry = true

	self:_updateKeepPosition()
end

function SceneMemberList:_updateKeepPosition()
    --刷新列表会员队伍状态
    local tbconList = GetElement(self.m_root, "tbconTextContent_SceneMemberList", WZUITableContainer)
    local nCurPositionY = tbconList:getMoveElement():getPositionY()
    local tLastSize = tbconList:getMoveElement():getContentSize()

	self:_update()

    --重新设置列表的位置
    local tCurSize = tbconList:getMoveElement():getContentSize()
    local nTempPositionY = nCurPositionY - (tCurSize.height - tLastSize.height)/2
    if nTempPositionY > tbconList:getMaxPosition().y then
        nTempPositionY = tbconList:getMaxPosition().y
    end
    tbconList:getMoveElement():setPositionY(nTempPositionY)
    tbconList:getMoveElement():setPositionY(tbconList:getMinPosition().y)
end

function SceneMemberList:onCancelFind(element) 
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tbconList = GetElement(self.m_root, "tbconTextContent_SceneMemberList", WZUITableContainer)
	self.m_bFirstEntry = true
	self.m_sFind = ""
	GetElement(self.m_root,"btnCancelFind",WZUIButton):setVisible(false)
	self:_update()
    tbconList:getMoveElement():setPositionY(tbconList:getMinPosition().y)
end

function SceneMemberList:setMinPosition() 
	if self.m_root == nil then return end
    local tbconList = GetElement(self.m_root, "tbconTextContent_SceneMemberList", WZUITableContainer)
    tbconList:getMoveElement():setPositionY(tbconList:getMinPosition().y)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	更新函数
function SceneMemberList:_update()
	WZLog("SceneMemberList:_update")
	if self.m_root == nil then 
		WZLog("function SceneMemberList:_update() self.m_root is nil ")
		return 
	end 

	--公会宣言
	local info2 = [[<T C="255,227,116" S="20" P="0">%s </T><BR>6</BR><T C="195,171,148" S="18" P="0">%s</T>]]
	local info3 = string.format(info2,LocalStrings.COMMUNITYINFO58,self.m_sDesc)
	GetElement(self.m_root,"CommunityDeclaration",WZUIFreeTextBox):setShowText(info3)
	GetElement(self.m_root,"communityDeclaration2",WZUILabelTTF):setText(self.m_sDesc)
	
	local guildInfo = CacheCenter:getGuildInfo()
	if guildInfo ~= nil then
	GetElement(self.m_root,"CommunityName",WZUILabelTTF):setText(guildInfo.guildName)
	GetElement(self.m_root,"communityName2",WZUILabelTTF):setText(guildInfo.guildName)
	end
	
	if not GetElement(self.m_root,"conMain1",WZUIContainer):isVisible() then
		return
	end

	--下方按钮
	GetElement(self.m_root,"btnLog",WZUIButton):setVisible(false)
	GetElement(self.m_root,"btnManage",WZUIButton):setVisible(false)
	GetElement(self.m_root,"btnContribution",WZUIButton):setVisible(true)
	GetElement(self.m_root,"btnFight",WZUIButton):setVisible(false)
	GetElement(self.m_root,"btnCover",WZUIButton):setVisible(true)
	GetElement(self.m_root,"btnChangeName_SceneMemberList",WZUIButton):setVisible(false)

	local position = tonumber(CacheCenter:getPlayerInfo().position)	
	WZLog("公会职位",position)
	if position == COMMUNITY_PRESIDENT then
		GetElement(self.m_root,"btnLog",WZUIButton):setVisible(true)
		GetElement(self.m_root,"btnManage",WZUIButton):setVisible(true)
		GetElement(self.m_root,"btnContribution",WZUIButton):setVisible(true)
		GetElement(self.m_root,"btnCover",WZUIButton):setVisible(false)

		GetElement(self.m_root,"btnChangeName_SceneMemberList",WZUIButton):setVisible(true)
	elseif position == COMMUNITY_VICE_PRESIDENT then
		GetElement(self.m_root,"btnManage",WZUIButton):setVisible(true)
		GetElement(self.m_root,"btnContribution",WZUIButton):setVisible(true)
	elseif position == COMMUNITY_ELDER then
		GetElement(self.m_root,"btnContribution",WZUIButton):setVisible(true)
	end
	--是否显示公会战按钮
	GetElement(self.m_root,"txtFight",WZUILabelTTF):setText(LocalStrings.NEWCOMMUNITY7)
	if self.guildwarStage ~= -1 then
		GetElement(self.m_root,"txtFight",WZUILabelTTF):setText(LocalStrings.COMMUNITYINFO161.."...")
	end
	if self.qualification==1 and (self.guildwarStage==1 or self.guildwarStage==2 or self.guildwarStage==3) then
		GetElement(self.m_root,"btnFight",WZUIButton):setVisible(true)
	end


	local gameParam = CacheCenter:getGameParam()
	--设置公会信息
	GetElement(self.m_root,"CommunityPrestige1",WZUILabelTTF):setText(self.m_nPrestige)
	GetElement(self.m_root,"CommunityMember1",WZUILabelTTF):setText(self.m_nMembers.."/"..GDatatab_guild_level["id_"..guildInfo.guildLevel].total)
	GetElement(self.m_root,"Contribution1",WZUILabelTTF):setText(guildInfo.donate)
	GetElement(self.m_root,"Contribution4",WZUILabelTTF):setText(guildInfo.totalDonate)
	GetElement(self.m_root,"Contribution6",WZUILabelTTF):setText(self.m_nLimitDonate.."/"..gameParam.guildMaxDonate)
	--搜索默认字符串
	GetElement(self.m_root,"editFind",WZUIEditBox):setPlaceHolder(LocalStrings.INPUT_KEY_SEARCH)

	--if guildInfo.newApply == 1 and CacheCenter:getGuildInfo().position >= COMMUNITY_ELDER and SceneCommunityMain.m_bRecruitChecked ~= true then
	--if guildInfo.newApply == 1 and CacheCenter:getGuildInfo().position >= COMMUNITY_ELDER then
    if GlobalGame.g_tRedPointList.community then
		GetElement(self.m_root,"imgApply_SceneMemberList",WZUIImage):setVisible(true)
		GetElement(self.m_root,"imgApply1_SceneMemberList",WZUIImage):setVisible(true)
	else
		GetElement(self.m_root,"imgApply_SceneMemberList",WZUIImage):setVisible(false)
		GetElement(self.m_root,"imgApply1_SceneMemberList",WZUIImage):setVisible(false)
	end
	--公会等级名称id
	local info = [[<T C="255,227,116" S="20" P="0">Lv%s </T><T C="255,236,193" S="20" P="0">%s  </T><T C="255,236,193" S="20" P="0"> （ID:%s）</T>]]
	local info1 = string.format(info,guildInfo.guildLevel,guildInfo.guildName,guildInfo.guildId)
	GetElement(self.m_root,"infoFree_SceneMemberList",WZUIFreeTextBox):setShowText(info1)

	GetElement(self.m_root,"CommunityName",WZUILabelTTF):setText(guildInfo.guildName)
	GetElement(self.m_root,"communityName2",WZUILabelTTF):setText(guildInfo.guildName)
	GetElement(self.m_root,"CommunityId",WZUILabelTTF):setText(guildInfo.guildId)
	GetElement(self.m_root,"CommunityLv",WZUILabelTTF):setText(guildInfo.guildLevel)
	--更新设置面板
	self:updateSetting()
	--更新管理面板
	self:updateManage()

	--设置成员列表中的内容
	if self.m_tCellList == nil then self.m_tCellList = {} end

	local tbconTextContent = self.m_root:getChildElement("tbconTextContent_SceneMemberList")
	self.m_nCurrentCellIndex = 1 
	self.m_nTag = 1
	if tbconTextContent ~= nil then 
		tbconTextContent = WZUITableContainer:luaTo(tbconTextContent)
		if tbconTextContent ~= nil then 
			--记录容器当前位置
        	self.m_nConListPositionY = tbconTextContent:getMoveElement():getPositionY()
			--先把数据清空
			tbconTextContent:cleanTable()
			self.m_tCellList = {}
			--分页，如果有第一页的话就改变在表格中的Tag值，让Tag值从1开始，因为0已经是第一页的索引
			if self:_getUpPage() == true  then 
				tbconTextContent:setEnableDropRefresh(false)
				local ttf = WZUILabelTTF:create()
				ttf:setText(LocalStrings.FRONT_PAGE)
				ttf:setFontSize(22)
				ttf:setUseOriginSize(true)
				ttf:setColor(GlobalMethod:ccc3(117,69,15))
				tbconTextContent:setTopNotice(LocalStrings.FRONT_PAGE, LocalStrings.FRONT_PAGE_TIP)
				tbconTextContent:setTopElementFunction("onFrontPageBtn")--设置TopElement的Lua回调函数
				tbconTextContent:setEnableTopElement(true)--设置TopElement是否可用
				tbconTextContent:setVisibleHeight(30)
				tbconTextContent:setHideTopElement(false)--设置topElement是否隐藏
				tbconTextContent:setTopElement(ttf)--设置容器的TopElement对象
			else
				tbconTextContent:setEnableDropRefresh(false)
				tbconTextContent:setEnableTopElement(false)
				tbconTextContent:setHideTopElement(true)
			end 
			--判断是否有下一页
			if self:_getDownPage() == true then
				tbconTextContent:setEnableDagLoading(false)
				local ttf = WZUILabelTTF:create()
				ttf:setText(LocalStrings.NEXT_PAGE)
				ttf:setFontSize(22)
				ttf:setUseOriginSize(true)
				ttf:setColor(GlobalMethod:ccc3(117,69,15))
				tbconTextContent:setBottomNotice(LocalStrings.NEXT_PAGE, LocalStrings.NEXT_PAGE_TIP)
				tbconTextContent:setBottomElementFunction("onNextPageBtn")--设置BottomElement的Lua回调函数
				tbconTextContent:setVisibleHeight(30)
				tbconTextContent:setEnableBottomElement(true)--设置BottomElement是否可用
				tbconTextContent:setHideBottomElement(false)--设置bottomElement是否隐藏
				tbconTextContent:setBottomElement(ttf)--设置容器的BottomElement对象
			else 
				tbconTextContent:setEnableDagLoading(false)
				tbconTextContent:setEnableBottomElement(false)
				tbconTextContent:setHideBottomElement(true)
			end 
			--开启定时器器加载列表内容
			tbconTextContent:enableSchedule("_scheduleCreateCell")
		end 
	end 
end 

--@brief	逐帧加载tbconTextContent每个单元格的定时器回调方法
--@param	element:定时器绑定的UI节点引用
--@param	delta:定时器回调间隔
--@note		采用定时器逐帧加载tbconTextContent的每一项(或几项)，防止在同一帧中加载太多数据导致的卡顿以及瞬间的内存脉冲
function SceneMemberList:_scheduleCreateCell(element, delta)
	if element == nil or  self.m_tMemberList == nil then 
		element:disableSchedule()
		return 
	end 	

	local tbconTextContent = GetElement(self.m_root,"tbconTextContent_SceneMemberList",WZUITableContainer)

	if self.m_nCurrentCellIndex > #self.m_tMemberList  or self.m_nCurrentCellIndex < 1 then 
		--如果有多余的Cell,删除
		if self.m_tCellList[self.m_nCurrentCellIndex] ~= nil then
			table.remove(self.m_tCellList,self.m_nCurrentCellIndex)
			tbconTextContent:removeCellElement(self.m_nCurrentCellIndex-1)
		end
		tbconTextContent:disableSchedule()
		local moveEle= tbconTextContent:getMoveElement()
		--重定位滚动容器位置
		if self.m_bUpPageShowLastPosition == true then 
			self.m_bUpPageShowLastPosition = false
			moveEle:setPositionY(tbconTextContent:getMaxPosition().y)
			tbconTextContent:updateTopDownPosition()
		end
		if self.m_bFirstEntry == false and self.m_nConListPositionY ~= nil then
			moveEle:setPositionY(self.m_nConListPositionY)
		end
		self.m_bFirstEntry = false
		return 
	end 
	--每帧最多只能加载7个表格元素
	for var = 1,50 do 
		if self.m_nCurrentCellIndex > #self.m_tMemberList then    
			return 
		end 

		--还没创建Cell
		local celElement,tCell
		if self.m_tCellList[self.m_nCurrentCellIndex] == nil then
			celElement,tCell =  CellCommunityMemberList:createElement()
			if celElement ~= nil and tCell ~= nil then 
				celElement:setTag(self.m_nTag - 1)
				if self.m_sFind == nil then self.m_sFind = "" end
				local a, b = string.find(self.m_tMemberList[self.m_nCurrentCellIndex].playerName, self.m_sFind)
				if a ~= nil then
					tbconTextContent:setCellElement(celElement)
					self.m_nTag = self.m_nTag + 1
				end
			end 
			self.m_tCellList[self.m_nCurrentCellIndex] = tCell
		else
			tCell = self.m_tCellList[self.m_nCurrentCellIndex]
		end

			--设置玩家转生等级
			tCell:setPlayerZslevel(self.m_tMemberList[self.m_nCurrentCellIndex].zsLevel)
			--设置：排名,等级,姓名,工作,总贡献,当天贡献,在线状态,离线时间)
			tCell:setData(self.m_tMemberList[self.m_nCurrentCellIndex].headId,
										self.m_tMemberList[self.m_nCurrentCellIndex].faceId,
										self.m_tMemberList[self.m_nCurrentCellIndex].rank,
										self.m_tMemberList[self.m_nCurrentCellIndex].playerLevel,
										self.m_tMemberList[self.m_nCurrentCellIndex].playerName,
										self.m_tMemberList[self.m_nCurrentCellIndex].position,
										tostring(self.m_tMemberList[self.m_nCurrentCellIndex].playerContribution),
										tostring(self.m_tMemberList[self.m_nCurrentCellIndex].todayContribution),
										self.m_tMemberList[self.m_nCurrentCellIndex].onLineState,
										self.m_tMemberList[self.m_nCurrentCellIndex].onLine,
										self.m_tMemberList[self.m_nCurrentCellIndex].sex,
										self.m_tMemberList[self.m_nCurrentCellIndex].vipLevel,
										self.m_tMemberList[self.m_nCurrentCellIndex].headColor)
			--设置玩家ID								
			tCell:setPlayerId(self.m_tMemberList[self.m_nCurrentCellIndex].playerId)	
			--取得自己ID
			local myId = self:_getMyId()
			if self.m_tMemberList[self.m_nCurrentCellIndex].playerId == myId then 
				tCell:setCellContentFontColor(0,72,3)
			end 

		self.m_nCurrentCellIndex = self.m_nCurrentCellIndex + 1 
	end 
end 



--@brief 点击上一页的函数
function  SceneMemberList:onFrontPageBtn()
	WZLog("SceneMemberList:onFrontPageBtn()")
	--加载圆圈
	self.m_nLoadingCircleId = MsgBoxManager:showLoadingBox()
	--获取成员列表协议
	ProtocolProcessorSceneCommunity:send_COMMUNITY_GetCommunityMemberListNew(CacheCenter:getPlayerInfo().guildId,self.m_nPageNumber-1)
	self.m_bUpPageShowLastPosition = true
end 


--@brief 点击下一页的函数
function SceneMemberList:onNextPageBtn()
	WZLog("SceneMemberList:onNextPageBtn()")
	--加载圆圈
	self.m_nLoadingCircleId = MsgBoxManager:showLoadingBox()
	--获取成员列表协议
	ProtocolProcessorSceneCommunity:send_COMMUNITY_GetCommunityMemberListNew(CacheCenter:getPlayerInfo().guildId,self.m_nPageNumber+1)
end 

--@brief  根据职位判断调用弹出框内容的函数
--@param #1  nMyJob 自己职位 
--@param #2 nJob 点击公会成员的职位
function SceneMemberList:_getPopMenuItems(nMyJob,nCellJob)
	local tPopupMenuItems = {}

	--第一行显示被操作玩家的名字
	table.insert(tPopupMenuItems, POPUPMENU_VARIABLE)
	g_tPopupMenuString[POPUPMENU_VARIABLE] = self.m_sCurCelName

	if nMyJob == COMMUNITY_PRESIDENT then
		table.insert(tPopupMenuItems, POPUPMENU_TRANSFER)
	end

	table.insert(tPopupMenuItems, POPUPMENU_CHAT)		--聊天
	table.insert(tPopupMenuItems, POPUPMENU_ADD)		--好友
	table.insert(tPopupMenuItems, POPUPMENU_MAIL)		--邮件

	--自己是会长
	if nMyJob == COMMUNITY_PRESIDENT then
		--table.insert(tPopupMenuItems, POPUPMENU_FIRED)
	--自己是副会长
	elseif nMyJob == COMMUNITY_VICE_PRESIDENT then
		if nMyJob ~= nCellJob and nCellJob < COMMUNITY_VICE_PRESIDENT then
			--table.insert(tPopupMenuItems, POPUPMENU_FIRED)
		end
	end 
	
	return tPopupMenuItems
end 

--@brief	获得公会当前特定职位人数
function SceneMemberList:getPositionNum(position)
	local count = 0
	if self.m_tMemberList == nil or position == nil then return count end
	for i=1,#self.m_tMemberList do
		if self.m_tMemberList[i].position == position then
			count = count + 1
		end
	end
	return count
end

--@brief	获得公会当前等级特定职位最大人数
function SceneMemberList:getPositionMaxNum(position)
	local guildInfo = CacheCenter:getGuildInfo()
	if guildInfo == nil or position == nil then return 0 end
	local positionNumName = {"hy","jy","zl","fhz","hz"}
	local guildLevel = guildInfo.guildLevel
	local limitNum = GDatatab_guild_level["id_"..guildLevel][positionNumName[position+1]]
	if limitNum == -1 then limitNum = 99999 end
	return limitNum
end
	
--@brief  取得自己ID的函数
--@return nMyId  自己ID
function SceneMemberList:_getMyId()
	return CacheCenter:getPlayerInfo().id
end 
	
--@brief 静态初始化UI文字
function SceneMemberList:_initStaticUiText()
	WZLog("SceneMemberList:_initStaticUiText")
	if self.m_root == nil then 
		WZLog(" SceneMemberList:_initStaticUiText() self.m_root is nil")
		return 
	end 

	
	--职位
	local txtJob = self.m_root:getChildElement("txtJob_SceneMemberList")
	if txtJob ~= nil then 
		WZUILabelTTF:luaTo(txtJob):setText(LocalStrings.POST)
	end 
	
	--今日贡献
	local txtCon = self.m_root:getChildElement("txtCon_SceneMemberList")
	if txtCon ~= nil then 
		WZUILabelTTF:luaTo(txtCon):setText(LocalStrings.COMMUNITYINFO50)
	end 
	
	--登陆时间
	local txtState = self.m_root:getChildElement("txtState_SceneMemberList")
	if txtState ~= nil then 
		WZUILabelTTF:luaTo(txtState):setText(LocalStrings.COMMUNITYINFO51)
	end 

	GetElement(self.m_root,"Contribution",WZUILabelTTF):setText(LocalStrings.COMMUNITYINFO50..":")
end 

--@brief	判断是否显示上一页函数
--@note		当前页大于1的时候显示上一页，否则不显示
function SceneMemberList:_getUpPage( )
	local nCurPage = self.m_nPageNumber-- self.m_nRecordPage--假设当前页
	--nCurPage = 2
	if nCurPage > 1 then
		return true
	else
		return false
	end
end

--@brief	判断是否显示下一页函数
--@note		当前页小于总页数的时候显示下一页，否则不显示
function SceneMemberList:_getDownPage()
	WZLog("self.m_nTotalNumber = ",self.m_nTotalNumber)
	local totalPageNum = self.m_nTotalNumber
	local nCurPage = self.m_nPageNumber
	--nCurPage = 1
	--totalPageNum = 2
	if nCurPage < totalPageNum then
		return true
	else
		return false
	end
end

-------------------------------------私有方法模块End----------------------------------------
--@brief	适配分辨率
function SceneMemberList:AdaptResolution()
	local directorSize = CCDirector:sharedDirector():getOpenGLView():getFrameSize()
	WZLog("SceneMemberList:AdaptResolution",directorSize.height)
	--iphone5适配
	if directorSize.width > 960 then
	
	end
	--ipad适配
	--if directorSize.height == 768 then
	--	GetElement(self.m_root,"conBottom_SceneMemberList",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5,0.2))
	--end
	--if directorSize.height == 1536 then
	--	GetElement(self.m_root,"conBottom_SceneMemberList",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5,0.2))
	--end
end

-----------------------------------语言适配Begin----------------------------------------------
function SceneMemberList:_adaptLanguage_th(  )
	local CommunityMember1 = GetElement(self.m_root,"CommunityMember1",WZUILabelTTF)
	CommunityMember1:setRelativePosition(GlobalMethod:ccp(0.44,0.13))

	local Contribution1 = GetElement(self.m_root,"Contribution1",WZUILabelTTF)
	Contribution1:setRelativePosition(GlobalMethod:ccp(0.52,0.75))

	local Contribution6 = GetElement(self.m_root,"Contribution6",WZUILabelTTF)
	Contribution6:setRelativePosition(GlobalMethod:ccp(0.44,0.2))

	local communityDeclar = GetElement(self.m_root,"CommunityDeclaration",WZUIFreeTextBox)
	communityDeclar:setMaxWidth(260)
	communityDeclar:setScale(0.8)

	local txtFight = GetElement(self.m_root,"txtFight",WZUILabelTTF)
	txtFight:setRelativePosition(GlobalMethod:ccp(0.1,0.73))
	txtFight:setFontSize(16)

	local editFind = GetElement(self.m_root,"editFind",WZUIEditBox)
	editFind:setRelativeSize(GlobalMethod:CCSize(0.8,1))
	editFind:setRelativePosition(GlobalMethod:ccp(0.8,0.5))

	local txtMain2Title1 = GetElement(self.m_root,"txtMain2Title1_SceneMemberList",WZUILabelTTF)
	txtMain2Title1:setRelativePosition(GlobalMethod:ccp(0.1,0.5))

	for i=1,2 do
		local txtMain2Check = GetElement(self.m_root,"txtMain2Check"..i.."_SceneMemberList",WZUILabelTTF)
		txtMain2Check:setRelativePosition(GlobalMethod:ccp(0.78,0.5))
	end

	local CommunityMember3 = GetElement(self.m_root,"CommunityMember3",WZUILabelTTF)
	CommunityMember3:setRelativePosition(GlobalMethod:ccp(0.14,0.500371))

	for i=1,2 do
		local txtMain3Check = GetElement(self.m_root,"txtMain3Check"..i.."_SceneMemberList",WZUILabelTTF)
		txtMain3Check:setRelativePosition(GlobalMethod:ccp(0.74,0.5))
	end
end

function SceneMemberList:_adaptLanguage_vn()
	local communityPrestige1 = GetElement(self.m_root,"CommunityPrestige1",WZUILabelTTF)
	communityPrestige1:setRelativePosition(GlobalMethod:ccp(0.47,0.3))

	local CommunityMember1 = GetElement(self.m_root,"CommunityMember1",WZUILabelTTF)
	CommunityMember1:setRelativePosition(GlobalMethod:ccp(0.41,0.13))

	local Contribution1 = GetElement(self.m_root,"Contribution1",WZUILabelTTF)
	Contribution1:setRelativePosition(GlobalMethod:ccp(0.52,0.75))

	local Contribution6 = GetElement(self.m_root,"Contribution6",WZUILabelTTF)
	Contribution6:setRelativePosition(GlobalMethod:ccp(0.57,0.2))

	local Contribution1 = GetElement(self.m_root,"CommunityName",WZUILabelTTF)
	Contribution1:setRelativePosition(GlobalMethod:ccp(0.43,0.81))

	GetElement(self.m_root,"Contribution5",WZUILabelTTF):setFontSize(16)

	local communityDeclar = GetElement(self.m_root,"CommunityDeclaration",WZUIFreeTextBox)
	communityDeclar:setMaxWidth(260)
	communityDeclar:setScale(0.8)

	local txtFight = GetElement(self.m_root,"txtFight",WZUILabelTTF)
	txtFight:setRelativePosition(GlobalMethod:ccp(0.1,0.73))
	txtFight:setFontSize(16)

	local editFind = GetElement(self.m_root,"editFind",WZUIEditBox)
	editFind:setRelativeSize(GlobalMethod:CCSize(0.8,1))
	editFind:setRelativePosition(GlobalMethod:ccp(0.8,0.5))

	for i=1,3 do
		local txtMain2Title = GetElement(self.m_root,"txtMain2Title"..i.."_SceneMemberList",WZUILabelTTF)
		txtMain2Title:setRelativePosition(GlobalMethod:ccp(0.15,0.5))
	end

	for i=1,2 do
		local txtMain2Check = GetElement(self.m_root,"txtMain2Check"..i.."_SceneMemberList",WZUILabelTTF)
		txtMain2Check:setScale(0.8)
		txtMain2Check:setRelativePosition(GlobalMethod:ccp(0.78,0.5))
	end

	for i=1,2 do
		local txtMain2Open = GetElement(self.m_root,"txtMain2Open"..i.."_SceneMemberList",WZUILabelTTF)
		txtMain2Open:setScale(0.8)
		txtMain2Open:setRelativePosition(GlobalMethod:ccp(-0.03,0.5))
	end

	local CommunityMember3 = GetElement(self.m_root,"CommunityMember3",WZUILabelTTF)
	CommunityMember3:setRelativePosition(GlobalMethod:ccp(0.13,0.500371))

	for i=1,2 do
		local txtMain3Check = GetElement(self.m_root,"txtMain3Check"..i.."_SceneMemberList",WZUILabelTTF)
		txtMain3Check:setScale(0.8)
		txtMain3Check:setDimensions(GlobalMethod:CCSize(130,0))
		txtMain3Check:setRelativePosition(GlobalMethod:ccp(0.74,0.5))
	end

	local txtManage2 = GetElement(self.m_root,"txtManage2_SceneMemberList",WZUILabelTTF)
	txtManage2:setDimensions(GlobalMethod:CCSize(160,0))
	txtManage2:setScale(0.8)

	local txtManage3 = GetElement(self.m_root,"txtManage3_SceneMemberList",WZUILabelTTF)
	txtManage3:setDimensions(GlobalMethod:CCSize(160,0))
	txtManage3:setScale(0.8)

	local txtManage5 = GetElement(self.m_root,"txtManage5_SceneMemberList",WZUILabelTTF)
	txtManage5:setDimensions(GlobalMethod:CCSize(160,0))
	txtManage5:setScale(0.8)

	local txtManage6 = GetElement(self.m_root,"txtManage6_SceneMemberList",WZUILabelTTF)
	txtManage6:setDimensions(GlobalMethod:CCSize(160,0))
	txtManage6:setScale(0.8)

	local txtMain3Btn = GetElement(self.m_root,"txtMain3Btn_SceneMemberList",WZUILabelTTF)
	txtMain3Btn:setScale(0.8)
	txtMain3Btn:setRelativePosition(GlobalMethod:ccp(0.12,0.5))
end

--@brief	英文包适配函数
function SceneMemberList:_adaptLanguage_en()
	if self.m_root == nil then
		return
	end

	local communityPrestige1 = GetElement(self.m_root,"CommunityPrestige1",WZUILabelTTF)
	communityPrestige1:setRelativePosition(GlobalMethod:ccp(0.44,0.3))

	local CommunityMember1 = GetElement(self.m_root,"CommunityMember1",WZUILabelTTF)
	CommunityMember1:setRelativePosition(GlobalMethod:ccp(0.47,0.13))

	local Contribution1 = GetElement(self.m_root,"Contribution1",WZUILabelTTF)
	Contribution1:setRelativePosition(GlobalMethod:ccp(0.62,0.75))
	Contribution1:setFontSize(16)

	local Contribution6 = GetElement(self.m_root,"Contribution6",WZUILabelTTF)
	Contribution6:setRelativePosition(GlobalMethod:ccp(0.57,0.2))
	Contribution6:setFontSize(16)

	local Contribution = GetElement(self.m_root,"Contribution",WZUILabelTTF)
	Contribution:setFontSize(16)
	Contribution:setRelativePosition(GlobalMethod:ccp(0.1,0.75))

	local Contribution5 = GetElement(self.m_root,"Contribution5",WZUILabelTTF)
	Contribution5:setFontSize(16)
	Contribution5:setRelativePosition(GlobalMethod:ccp(0.1,0.2))

	local communityDeclar = GetElement(self.m_root,"CommunityDeclaration",WZUIFreeTextBox)
	communityDeclar:setMaxWidth(260)
	communityDeclar:setScale(0.8)

	local txtFight = GetElement(self.m_root,"txtFight",WZUILabelTTF)
	txtFight:setRelativePosition(GlobalMethod:ccp(0.1,0.73))
	txtFight:setFontSize(16)

	for i=1,3 do
		local txtMain2Title = GetElement(self.m_root,"txtMain2Title"..i.."_SceneMemberList",WZUILabelTTF)
		txtMain2Title:setRelativePosition(GlobalMethod:ccp(0.15,0.5))
	end

	for i=1,2 do
		local txtMain2Check = GetElement(self.m_root,"txtMain2Check"..i.."_SceneMemberList",WZUILabelTTF)
		txtMain2Check:setScale(0.8)
		txtMain2Check:setRelativePosition(GlobalMethod:ccp(0.78,0.5))
	end

	for i=1,2 do
		local txtMain2Open = GetElement(self.m_root,"txtMain2Open"..i.."_SceneMemberList",WZUILabelTTF)
		txtMain2Open:setScale(0.8)
		txtMain2Open:setRelativePosition(GlobalMethod:ccp(-0.03,0.5))
	end

	local CommunityMember3 = GetElement(self.m_root,"CommunityMember3",WZUILabelTTF)
	CommunityMember3:setRelativePosition(GlobalMethod:ccp(0.14,0.500371))

	for i=1,2 do
		local txtMain3Check = GetElement(self.m_root,"txtMain3Check"..i.."_SceneMemberList",WZUILabelTTF)
		txtMain3Check:setScale(0.8)
		txtMain3Check:setDimensions(GlobalMethod:CCSize(130,0))
		txtMain3Check:setRelativePosition(GlobalMethod:ccp(0.74,0.5))
	end

	local txtManage4 = GetElement(self.m_root,"txtManage4_SceneMemberList",WZUILabelTTF)
	txtManage4:setScale(0.8)

	local txtManage3 = GetElement(self.m_root,"txtManage3_SceneMemberList",WZUILabelTTF)
	txtManage3:setDimensions(GlobalMethod:CCSize(160,0))
	txtManage3:setScale(0.8)

	local txtManage5 = GetElement(self.m_root,"txtManage5_SceneMemberList",WZUILabelTTF)
	txtManage5:setDimensions(GlobalMethod:CCSize(160,0))
	txtManage5:setScale(0.8)

	local txtManage6 = GetElement(self.m_root,"txtManage6_SceneMemberList",WZUILabelTTF)
	txtManage6:setDimensions(GlobalMethod:CCSize(160,0))
	txtManage6:setScale(0.8)

	local txtMain3Btn = GetElement(self.m_root,"txtMain3Btn_SceneMemberList",WZUILabelTTF)
	txtMain3Btn:setScale(0.8)
	txtMain3Btn:setRelativePosition(GlobalMethod:ccp(0.12,0.5))

	GetElement(self.m_root,"txtJob_SceneMemberList",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtCon_SceneMemberList",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtState_SceneMemberList",WZUILabelTTF):setScale(0.7)
end

function SceneMemberList:_adaptLanguage_pt(  )
	if self.m_root == nil then
		return
	end
	local communityPrestige1 = GetElement(self.m_root,"CommunityPrestige1",WZUILabelTTF)
	communityPrestige1:setRelativePosition(GlobalMethod:ccp(0.44,0.3))

	local CommunityMember1 = GetElement(self.m_root,"CommunityMember1",WZUILabelTTF)
	CommunityMember1:setRelativePosition(GlobalMethod:ccp(0.43,0.13))

	local Contribution1 = GetElement(self.m_root,"Contribution1",WZUILabelTTF)
	Contribution1:setRelativePosition(GlobalMethod:ccp(0.62,0.75))
	Contribution1:setFontSize(16)

	local Contribution6 = GetElement(self.m_root,"Contribution6",WZUILabelTTF)
	Contribution6:setRelativePosition(GlobalMethod:ccp(0.65,0.2))
	Contribution6:setFontSize(16)

	local Contribution = GetElement(self.m_root,"Contribution",WZUILabelTTF)
	Contribution:setFontSize(16)
	Contribution:setRelativePosition(GlobalMethod:ccp(0.1,0.75))

	local Contribution5 = GetElement(self.m_root,"Contribution5",WZUILabelTTF)
	Contribution5:setFontSize(16)
	Contribution5:setRelativePosition(GlobalMethod:ccp(0.1,0.2))

	local communityDeclar = GetElement(self.m_root,"CommunityDeclaration",WZUIFreeTextBox)
	communityDeclar:setMaxWidth(260)
	communityDeclar:setScale(0.8)

	local txtFight = GetElement(self.m_root,"txtFight",WZUILabelTTF)
	txtFight:setRelativePosition(GlobalMethod:ccp(0.1,0.73))
	txtFight:setFontSize(16)
	txtFight:setDimensions(GlobalMethod:CCSize(200,0))

	for i=1,3 do
		local txtMain2Title = GetElement(self.m_root,"txtMain2Title"..i.."_SceneMemberList",WZUILabelTTF)
		if i == 3 then
			txtMain2Title:setRelativePosition(GlobalMethod:ccp(0.2,0.5))
		else
			txtMain2Title:setRelativePosition(GlobalMethod:ccp(0.15,0.5))
		end
	end

	for i=1,2 do
		local txtMain2Check = GetElement(self.m_root,"txtMain2Check"..i.."_SceneMemberList",WZUILabelTTF)
		txtMain2Check:setScale(0.8)
		txtMain2Check:setRelativePosition(GlobalMethod:ccp(0.78,0.5))
		txtMain2Check:setDimensions(GlobalMethod:CCSize(150,0))
	end

	for i=1,2 do
		local txtMain2Open = GetElement(self.m_root,"txtMain2Open"..i.."_SceneMemberList",WZUILabelTTF)
		txtMain2Open:setScale(0.8)
		txtMain2Open:setRelativePosition(GlobalMethod:ccp(-0.03,0.5))
		txtMain2Open:setDimensions(GlobalMethod:CCSize(270,0))
	end

	local CommunityMember3 = GetElement(self.m_root,"CommunityMember3",WZUILabelTTF)
	CommunityMember3:setRelativePosition(GlobalMethod:ccp(0.13,0.500371))

	for i=1,2 do
		local txtMain3Check = GetElement(self.m_root,"txtMain3Check"..i.."_SceneMemberList",WZUILabelTTF)
		txtMain3Check:setScale(0.8)
		txtMain3Check:setDimensions(GlobalMethod:CCSize(130,0))
		txtMain3Check:setRelativePosition(GlobalMethod:ccp(0.74,0.5))
	end

	local txtManage2 = GetElement(self.m_root,"txtManage2_SceneMemberList",WZUILabelTTF)
	txtManage2:setScale(0.8)

	local txtManage3 = GetElement(self.m_root,"txtManage3_SceneMemberList",WZUILabelTTF)
	txtManage3:setDimensions(GlobalMethod:CCSize(160,0))
	txtManage3:setScale(0.8)

	local txtManage5 = GetElement(self.m_root,"txtManage5_SceneMemberList",WZUILabelTTF)
	txtManage5:setDimensions(GlobalMethod:CCSize(160,0))
	txtManage5:setScale(0.8)

	local txtManage6 = GetElement(self.m_root,"txtManage6_SceneMemberList",WZUILabelTTF)
	txtManage6:setDimensions(GlobalMethod:CCSize(160,0))
	txtManage6:setScale(0.8)

	local editFind = GetElement(self.m_root,"editFind",WZUIEditBox)
	editFind:setRelativeSize(GlobalMethod:CCSize(0.8,1))
	editFind:setRelativePosition(GlobalMethod:ccp(0.8,0.5))

	GetElement(self.m_root,"txtJob_SceneMemberList",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtCon_SceneMemberList",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtState_SceneMemberList",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtContribution_SceneMemberList",WZUILabelTTF):setScale(0.8)

	local communityName1 = GetElement(self.m_root,"communityName1_SceneMemberList",WZUILabelTTF)
	communityName1:setRelativePosition(GlobalMethod:ccp(0.16,0.715))

	local communityName2 = GetElement(self.m_root,"communityName2",WZUILabelTTF)
	communityName2:setRelativePosition(GlobalMethod:ccp(0.26,0.715))
end

function SceneMemberList:_adaptLanguage_tr(  )
	local communityPrestige1 = GetElement(self.m_root,"CommunityPrestige1",WZUILabelTTF)
	communityPrestige1:setRelativePosition(GlobalMethod:ccp(0.44,0.3))

	local CommunityMember1 = GetElement(self.m_root,"CommunityMember1",WZUILabelTTF)
	CommunityMember1:setRelativePosition(GlobalMethod:ccp(0.43,0.13))

	local Contribution1 = GetElement(self.m_root,"Contribution1",WZUILabelTTF)
	Contribution1:setRelativePosition(GlobalMethod:ccp(0.62,0.75))
	Contribution1:setFontSize(16)

	local Contribution6 = GetElement(self.m_root,"Contribution6",WZUILabelTTF)
	Contribution6:setRelativePosition(GlobalMethod:ccp(0.6,0.2))
	Contribution6:setFontSize(16)

	local Contribution = GetElement(self.m_root,"Contribution",WZUILabelTTF)
	Contribution:setFontSize(16)
	Contribution:setRelativePosition(GlobalMethod:ccp(0.1,0.75))

	local Contribution5 = GetElement(self.m_root,"Contribution5",WZUILabelTTF)
	Contribution5:setFontSize(16)
	Contribution5:setRelativePosition(GlobalMethod:ccp(0.1,0.2))

	local communityDeclar = GetElement(self.m_root,"CommunityDeclaration",WZUIFreeTextBox)
	communityDeclar:setMaxWidth(260)
	communityDeclar:setScale(0.8)

	local txtFight = GetElement(self.m_root,"txtFight",WZUILabelTTF)
	txtFight:setRelativePosition(GlobalMethod:ccp(0.1,0.73))
	txtFight:setFontSize(16)
	txtFight:setDimensions(GlobalMethod:CCSize(200,0))

	for i=1,3 do
		local txtMain2Title = GetElement(self.m_root,"txtMain2Title"..i.."_SceneMemberList",WZUILabelTTF)
		if i == 3 then
			txtMain2Title:setRelativePosition(GlobalMethod:ccp(0.2,0.5))
		else
			txtMain2Title:setRelativePosition(GlobalMethod:ccp(0.15,0.5))
		end
	end

	for i=1,2 do
		local txtMain2Check = GetElement(self.m_root,"txtMain2Check"..i.."_SceneMemberList",WZUILabelTTF)
		txtMain2Check:setScale(0.8)
		txtMain2Check:setRelativePosition(GlobalMethod:ccp(0.78,0.5))
		txtMain2Check:setDimensions(GlobalMethod:CCSize(150,0))
	end

	for i=1,2 do
		local txtMain2Open = GetElement(self.m_root,"txtMain2Open"..i.."_SceneMemberList",WZUILabelTTF)
		txtMain2Open:setScale(0.8)
		txtMain2Open:setRelativePosition(GlobalMethod:ccp(-0.03,0.5))
		txtMain2Open:setDimensions(GlobalMethod:CCSize(270,0))
	end

	local CommunityMember3 = GetElement(self.m_root,"CommunityMember3",WZUILabelTTF)
	CommunityMember3:setRelativePosition(GlobalMethod:ccp(0.13,0.500371))

	for i=1,2 do
		local txtMain3Check = GetElement(self.m_root,"txtMain3Check"..i.."_SceneMemberList",WZUILabelTTF)
		txtMain3Check:setScale(0.8)
		txtMain3Check:setDimensions(GlobalMethod:CCSize(130,0))
		txtMain3Check:setRelativePosition(GlobalMethod:ccp(0.74,0.5))
	end

	local txtManage2 = GetElement(self.m_root,"txtManage2_SceneMemberList",WZUILabelTTF)
	txtManage2:setScale(0.8)

	local txtManage3 = GetElement(self.m_root,"txtManage3_SceneMemberList",WZUILabelTTF)
	txtManage3:setDimensions(GlobalMethod:CCSize(160,0))
	txtManage3:setScale(0.8)

	local txtManage5 = GetElement(self.m_root,"txtManage5_SceneMemberList",WZUILabelTTF)
	txtManage5:setDimensions(GlobalMethod:CCSize(160,0))
	txtManage5:setScale(0.8)

	local txtManage6 = GetElement(self.m_root,"txtManage6_SceneMemberList",WZUILabelTTF)
	txtManage6:setDimensions(GlobalMethod:CCSize(160,0))
	txtManage6:setScale(0.8)

	local editFind = GetElement(self.m_root,"editFind",WZUIEditBox)
	editFind:setRelativeSize(GlobalMethod:CCSize(0.8,1))
	editFind:setRelativePosition(GlobalMethod:ccp(0.8,0.5))

	GetElement(self.m_root,"txtJob_SceneMemberList",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtCon_SceneMemberList",WZUILabelTTF):setScale(0.7)

	local txtState = GetElement(self.m_root,"txtState_SceneMemberList",WZUILabelTTF)
	txtState:setScale(0.7)
	txtState:setRelativePosition(GlobalMethod:ccp(0.83,0.5))

	GetElement(self.m_root,"txtContribution_SceneMemberList",WZUILabelTTF):setScale(0.8)

	local communityName1 = GetElement(self.m_root,"communityName1_SceneMemberList",WZUILabelTTF)
	communityName1:setRelativePosition(GlobalMethod:ccp(0.16,0.715))

	local communityName2 = GetElement(self.m_root,"communityName2",WZUILabelTTF)
	communityName2:setRelativePosition(GlobalMethod:ccp(0.26,0.715))

	local txtMain3Btn = GetElement(self.m_root,"txtMain3Btn_SceneMemberList",WZUILabelTTF)
	txtMain3Btn:setScale(0.8)
	txtMain3Btn:setDimensions(GlobalMethod:CCSize(100,0))
end

function SceneMemberList:_adaptLanguage_es(  )
	if self.m_root == nil then
		return
	end
	local communityPrestige1 = GetElement(self.m_root,"CommunityPrestige1",WZUILabelTTF)
	communityPrestige1:setRelativePosition(GlobalMethod:ccp(0.44,0.3))

	local CommunityMember1 = GetElement(self.m_root,"CommunityMember1",WZUILabelTTF)
	CommunityMember1:setRelativePosition(GlobalMethod:ccp(0.57,0.13))

	local Contribution1 = GetElement(self.m_root,"Contribution1",WZUILabelTTF)
	Contribution1:setRelativePosition(GlobalMethod:ccp(0.62,0.75))
	Contribution1:setFontSize(16)

	local Contribution6 = GetElement(self.m_root,"Contribution6",WZUILabelTTF)
	Contribution6:setRelativePosition(GlobalMethod:ccp(0.65,0.2))
	Contribution6:setFontSize(16)

	local Contribution = GetElement(self.m_root,"Contribution",WZUILabelTTF)
	Contribution:setFontSize(16)
	Contribution:setRelativePosition(GlobalMethod:ccp(0.1,0.75))

	local Contribution5 = GetElement(self.m_root,"Contribution5",WZUILabelTTF)
	Contribution5:setFontSize(16)
	Contribution5:setRelativePosition(GlobalMethod:ccp(0.1,0.2))

	local communityDeclar = GetElement(self.m_root,"CommunityDeclaration",WZUIFreeTextBox)
	communityDeclar:setMaxWidth(260)
	communityDeclar:setScale(0.8)

	local txtFight = GetElement(self.m_root,"txtFight",WZUILabelTTF)
	txtFight:setRelativePosition(GlobalMethod:ccp(0.1,0.73))
	txtFight:setFontSize(16)
	txtFight:setDimensions(GlobalMethod:CCSize(200,0))

	for i=1,3 do
		local txtMain2Title = GetElement(self.m_root,"txtMain2Title"..i.."_SceneMemberList",WZUILabelTTF)
		if i == 3 then
			txtMain2Title:setRelativePosition(GlobalMethod:ccp(0.28,0.5))
		else
			txtMain2Title:setRelativePosition(GlobalMethod:ccp(0.15,0.5))
		end
	end

	for i=1,2 do
		local txtMain2Check = GetElement(self.m_root,"txtMain2Check"..i.."_SceneMemberList",WZUILabelTTF)
		txtMain2Check:setScale(0.8)
		txtMain2Check:setRelativePosition(GlobalMethod:ccp(0.78,0.5))
		txtMain2Check:setDimensions(GlobalMethod:CCSize(150,0))
	end

	for i=1,2 do
		local txtMain2Open = GetElement(self.m_root,"txtMain2Open"..i.."_SceneMemberList",WZUILabelTTF)
		txtMain2Open:setScale(0.8)
		txtMain2Open:setRelativePosition(GlobalMethod:ccp(-0.03,0.5))
		if i == 2 then
			txtMain2Open:setDimensions(GlobalMethod:CCSize(240,0))
		else
			txtMain2Open:setDimensions(GlobalMethod:CCSize(270,0))
		end
	end

	GetElement(self.m_root,"CommunityMember2",WZUILabelTTF):setScale(0.8)

	local CommunityMember3 = GetElement(self.m_root,"CommunityMember3",WZUILabelTTF)
	CommunityMember3:setRelativePosition(GlobalMethod:ccp(0.15,0.500371))
	CommunityMember3:setScale(0.8)

	for i=1,2 do
		local txtMain3Check = GetElement(self.m_root,"txtMain3Check"..i.."_SceneMemberList",WZUILabelTTF)
		txtMain3Check:setScale(0.8)
		txtMain3Check:setDimensions(GlobalMethod:CCSize(130,0))
		txtMain3Check:setRelativePosition(GlobalMethod:ccp(0.74,0.5))
	end

	local txtManage2 = GetElement(self.m_root,"txtManage2_SceneMemberList",WZUILabelTTF)
	txtManage2:setScale(0.8)
	txtManage2:setDimensions(GlobalMethod:CCSize(160,0))

	local txtManage3 = GetElement(self.m_root,"txtManage3_SceneMemberList",WZUILabelTTF)
	txtManage3:setDimensions(GlobalMethod:CCSize(160,0))
	txtManage3:setScale(0.8)

	local txtManage5 = GetElement(self.m_root,"txtManage5_SceneMemberList",WZUILabelTTF)
	txtManage5:setDimensions(GlobalMethod:CCSize(160,0))
	txtManage5:setScale(0.8)

	local txtManage6 = GetElement(self.m_root,"txtManage6_SceneMemberList",WZUILabelTTF)
	txtManage6:setDimensions(GlobalMethod:CCSize(160,0))
	txtManage6:setScale(0.8)

	local editFind = GetElement(self.m_root,"editFind",WZUIEditBox)
	editFind:setRelativeSize(GlobalMethod:CCSize(0.8,1))
	editFind:setRelativePosition(GlobalMethod:ccp(0.8,0.5))

	GetElement(self.m_root,"txtJob_SceneMemberList",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtCon_SceneMemberList",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtState_SceneMemberList",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtContribution_SceneMemberList",WZUILabelTTF):setScale(0.8)

	local communityName1 = GetElement(self.m_root,"communityName1_SceneMemberList",WZUILabelTTF)
	communityName1:setRelativePosition(GlobalMethod:ccp(0.16,0.715))

	local communityName2 = GetElement(self.m_root,"communityName2",WZUILabelTTF)
	communityName2:setRelativePosition(GlobalMethod:ccp(0.26,0.715))

	local txtBtnLog = GetElement(self.m_root,"txtBtnLog_SceneMemberList",WZUILabelTTF)
	txtBtnLog:setScale(0.8)
	txtBtnLog:setDimensions(GlobalMethod:CCSize(130,0))
end
-----------------------------------语言适配End------------------------------------------------
