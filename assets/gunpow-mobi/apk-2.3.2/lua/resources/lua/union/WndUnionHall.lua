--WndUnionHall.lua
--@brief	WndUnionHall的UI模块
--@date		2024/01/10
--@author	XTX
--@note		联盟大厅界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndUnionHall:onEnter(element)
	self.m_root = element

	--静态初始化UI文字
	self:_initStaticUiText()

	--获取公会大厅
	self.m_bFirstEntry = true

	local unionId = CacheCenter:getPlayerInfo().unionInfo.id
	ProtocolProcessorUnion:send_LEAGUE_GetLeagueInfo(unionId)
	GlobalGame:getGameEventDispathcer():Add(Independent_Activity.ActivityReddot, self.showRedDot, self)

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndUnionHall:onExit(element)
	self:_unInit()

	GlobalGame:getGameEventDispathcer():Remove(Independent_Activity.ActivityReddot, self.showRedDot, self)
end

function WndUnionHall:onEnterTransitionDidFinish(element)
	GetElement(self.m_root,"conMain1",WZUIContainer):setVisible(true)
	GetElement(self.m_root,"conMain3",WZUIContainer):setVisible(false)
    if "hk" == ProjConfig.LANGUAGE then
        GetElement(self.m_root,"con3",WZUIContainer):setVisible(false)
    end
end

function WndUnionHall:_addTop()
    local cell,tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
    tcell:setTopData("ui/common/common_icon_ghdt.png",WndUnionHall,WndUnionHall.onClose,true,true,false,"WndUnionHall")
	self.m_tTop = cell
end

--@brief	关闭按钮
function WndUnionHall:onClose(element)
	WZLog("WndUnionHall:onClose")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	--进入公会场景
    WindowManager:removeWindow(self.m_root, self, true)
end

function WndUnionHall:onNormal() 
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	WndUnionList:resetTopTitle("ui/common/common_icon_lm.png", WndUnionList, WndUnionList.onClose)
   
	GetElement(self.m_root,"conMain1",WZUIContainer):setVisible(true)
	GetElement(self.m_root,"conMain3",WZUIContainer):setVisible(false)

	self:_updateKeepPosition()
    local tbconList = GetElement(self.m_root, "tbconTextContent_WndUnionHall", WZUITableContainer)
    tbconList:getMoveElement():setPositionY(tbconList:getMinPosition().y)
end

function WndUnionHall:onSetToNormal() 
	self:onNormal()
end

--@brief	管理
function WndUnionHall:onBtm3() 
	WZLog("WndUnionHall:onBtm3")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
 	WndUnionList:resetTopTitle("ui/common/common_icon_lmgl.png", WndUnionHall, WndUnionHall.onNormal)

	GetElement(self.m_root,"conMain1",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conMain3",WZUIContainer):setVisible(true)
end

--@brief	公会日志
function WndUnionHall:onLog(element)
	WZLog("WndUnionHall:onLog")
	--SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local wndCommunityLog = WndCommunityLog:createElement()
	if wndCommunityLog ~= nil then 
		WindowManager:addWindow(wndCommunityLog,WndCommunityLog,nil,nil,nil,true)
	end 
end

--@brief	根据权限设置管理菜单
function WndUnionHall:setManageMenuItems()
	local position = tonumber(CacheCenter:getPlayerInfo().position)
	WZLog("WndUnionHall:setManageMenuItems",position)

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
	if position >= UNION_ELDER then
    	if GlobalGame.g_tRedPointList.union then
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
function WndUnionHall:onDonate(element)
	WZLog("WndUnionHall:onDonate")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	WndCommunityCheckDonate:showInterface(1)
end

--@brief	公会申请
function WndUnionHall:onApply(element)
	WZLog("WndUnionHall:onApply")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	--审批设置为已查看状态
	GlobalGame.g_tRedPointList.union = false
	self:showRedDot()
    
    ProtocolProcessorSceneCity:send_PLAYER_CancelRedDot(305)

	WndRecruit:showInterface(1)
end

--@brief	公会宣言
function WndUnionHall:onDeclaration(element)
	WZLog("WndUnionHall:onDeclaration")
	--音效
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if CheckButtonOpen(158) then 
		local wndCommunityPopContent = WndCommunityPopContent:createElement()
		WindowManager:addWindow(wndCommunityPopContent,WndCommunityPopContent)
		--设置公会宣言
		WndCommunityPopContent:setImgTitle(1)
		--设置默认内容
		if CacheCenter:getUnionInfo().desc == "" then
			--WndCommunityPopContent:setEditBoxInputContent(LocalStrings.COMMUNITYINFO44,155,131,122)
			WndCommunityPopContent:setEditBoxPlaceHolder(LocalStrings.COMMUNITYINFO44)
		else
			--WndCommunityPopContent:setEditBoxInputContent(CacheCenter:getUnionInfo().desc,155,131,122)
			WndCommunityPopContent:setEditBoxPlaceHolder(CacheCenter:getUnionInfo().desc)
		end
		--设置窗口标记
		WndCommunityPopContent:modifyCurWindow(1) 
	end
end

--@brief	公会设置
function WndUnionHall:onSetting(element)
	WZLog("WndUnionHall:onSetting")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local wndSetEnemyCommunity = WndSetEnemyCommunity:createElement()
	WindowManager:addWindow(wndSetEnemyCommunity,WndSetEnemyCommunity)
end

--@brief	退出公会
function WndUnionHall:onQuit(element)
	WZLog("WndUnionHall:onQuit")
	--音效
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local myPosition
	for k,v in pairs(WndUnionHall.m_tMemberList) do
		if v.playerId == CacheCenter:getPlayerInfo().id then
			myPosition = v.position
		end
	end
	WZLog("我的职位:",myPosition,myPosition==UNION_PRESIDENT)
	if myPosition == UNION_PRESIDENT then
		--我是盟主并且公会成员数大于一，提示请先转让盟主
		if WndUnionHall.m_nMembers > 1 then
			MsgBoxManager:showTipBox(LocalStrings.UNION_TEXT1[47])
			return
		else
			--我是盟主并且盟主成员数等于一，弹出是否解散盟主的窗口
			local wndDismissCommunity = WndDismissCommunity:createElement()
			WindowManager:addWindow(wndDismissCommunity,WndDismissCommunity)
    		WndDismissCommunity:setBtnVisable(1)
			WndDismissCommunity:setFlagWindow(6)
			WndDismissCommunity:setTxtMidContent(LocalStrings.UNION_TEXT1[45])
			--标题退出公会
			GetElement(WndDismissCommunity.m_root, "txtTitle_WndDismiss", WZUILabelTTF):setText(LocalStrings.UNION_TEXT1[5])
		end
	else
		--弹出是否退出联盟的窗口
		local wndDismissCommunity = WndDismissCommunity:createElement()
		WindowManager:addWindow(wndDismissCommunity,WndDismissCommunity)
		WndDismissCommunity:setExitCommunityWindow(6)
    	WndDismissCommunity:setBtnVisable(1)
	end
end

--@brief  按钮回调函数
--@param #1 element:点击消息框的窗口对象
--@param #2	nId:点击消息框的那个ID
function WndUnionHall:onClickPopup(element,nId)
	WndPopupMenu:disappear()
	if nId == POPUPMENU_COMMUNITY1 then 	
		self:onApply()
	elseif nId == POPUPMENU_COMMUNITY2 then   
		self:onDeclaration()
	elseif nId == POPUPMENU_COMMUNITY3 then
		self:onUpgrade()
	elseif nId == POPUPMENU_COMMUNITY4 then
		self:onSetting()
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
function WndUnionHall:onInvite()
	WZLog("WndUnionHall:onInvite")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndFriendList:showInterface(21, WndUnionHall, WndUnionHall.inviteCommunityMember)
end

function WndUnionHall:inviteCommunityMember(tData)
	WZLog("WndUnionHall:inviteCommunityMember", tData.id)
	ProtocolProcessorUnion:send_LEAGUE_Invite(tData.id)
end

function WndUnionHall:onAcceptInvite()
	WZLog("WndUnionHall:onAcceptInvite", WndUnionHall.inviteId, WndUnionHall.inviteLeagueName)
	ProtocolProcessorUnion:send_LEAGUE_ResponseInvite(WndUnionHall.inviteId, WndUnionHall.inviteLeagueName, true)
end

--@brief	职位任命
function WndUnionHall:onAppoint()
	WZLog("WndUnionHall:onAppoint")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndCommunityAppoint:showInterface(1)
end

--@brief	贡献按钮
function WndUnionHall:onContribution(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--判断今天是否已经贡献过
	if CacheCenter:getUnionInfo() == nil then return end
	if CacheCenter:getUnionInfo().buyDonate ~= "0" and CacheCenter:getUnionInfo().buyDonate ~= 0 then
		if LocalStrings.FIRST_DAY_CAN_NOT_DONATE and tonumber(CacheCenter:getUnionInfo().buyDonate) == 2 then
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
function WndUnionHall:onClickBtnFromCellCommunityMemberList(element,nJob,sCelName,nCellPlayerId,nTime,nState, fight, vipLevel, level)
	WZLog("WndUnionHall:onClickBtnFromCellCommunityMemberList",nJob,nCellPlayerId,self:_getMyId())
	--点击自己直接返回
	if nCellPlayerId == self:_getMyId() then 
		return 
	end 
	
	WZLog("WndUnionHall:onClickBtnFromCellCommunityMemberList1",nJob,nCellPlayerId,self:_getMyId())
	--创建弹出框
	local popupMenu = WndPopupMenu:createElement()
	-- popupMenu:setShowAll(true)
	self.m_root:addChild(popupMenu)	
	popupMenu:setVisible(true)
	WZLog("self.m_root",self.m_root,popupMenu:getPositionX(),popupMenu:getPositionY(),popupMenu:isVisible())
	popupMenu:setShowAll(false)
	
	--音效
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	WZLog("self.m_nCurWindowFlag == 1 ")
	self.m_sCurCelName = sCelName
	self.m_nCurCelId = nCellPlayerId
	self.m_nJob = nJob
	self.m_nTime = nTime
	self.m_nState = nState
	self.m_tSelMember = {fighting = fight, vipLevel = vipLevel, level = level}
	WZLog("self.m_nCurCelId = ",self.m_nCurCelId )
	WndPopupMenu:disappear()
	--根据自己的职位和点击单元格的职位判断是否可降职和升职
	--self.m_nMyJob = UNION_PRESIDENT
	self.m_nMyJob = CacheCenter:getUnionInfo().position
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

function WndUnionHall:needHigherVipCallBack(nId, nResType)
    -- body
    if nResType == MSGBOXRESTYPE_CONFIRM then
        PassportSdkManager:gotoPaymentPage()
    end
end

--@brief  按钮回调函数
--@param #1 element:点击消息框的窗口对象
--@param #2	nId:点击消息框的那个ID，如私聊，发送邮件，查看资料，黑名单，删除等
function WndUnionHall:onClickPopupMenuItem(element,nId)
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
		if whetherCanPrivateChat(tInfo.playerId) then 
			WndChat:showChatWindowForPrivateWithIdAndName(tInfo.playerId,tInfo.playerName,tInfo.sex,tInfo.playerLevel,tInfo.vipLevel,tInfo.headId,tInfo.faceId,tInfo.headColor, tInfo.headEffectId)
			WndPopupMenu:disappear()
		end
	elseif nId == POPUPMENU_INFO  then 	    --查看资料
        WndCheckOther:show(self.m_nCurCelId)
		WndPopupMenu:disappear()
		
	elseif nId == POPUPMENU_UNION1  then 	 --转让盟主
		local leagueCreateLevel = tonumber(CacheCenter:getGameParam().leagueCreateLevel)
		local leagueCreateVipLv = tonumber(CacheCenter:getGameParam().leagueCreateVipLv)
		local leagueCreateFight = tonumber(CacheCenter:getGameParam().leagueCreateFight)
		if self.m_tSelMember.level < leagueCreateLevel then  
			--创建失败，淡入淡出提示
			MsgBoxManager:showTipBox(string.format(LocalStrings.UNION_TEXT2[2], leagueCreateLevel))
			return 
		end 
		if self.m_tSelMember.vipLevel < leagueCreateVipLv then  
			--创建失败，淡入淡出提示
			MsgBoxManager:showTipBox(string.format(LocalStrings.UNION_TEXT2[3], leagueCreateVipLv))
			return 
		end 
		if self.m_tSelMember.fighting < leagueCreateFight then  
			--创建失败，淡入淡出提示
			MsgBoxManager:showTipBox(string.format(LocalStrings.UNION_TEXT2[4], leagueCreateFight))
			return 
		end 
		local wndDismissCommunity = WndDismissCommunity:createElement()
		WindowManager:addWindow(wndDismissCommunity,WndDismissCommunity)

		local txtYes = WndDismissCommunity.m_root:getChildElement("txtYes_WndDismissCommunity")
	    if txtYes then 
            WZUILabelTTF:luaTo(txtYes):setText(LocalStrings.YES)
            WZUILabelTTF:luaTo(txtYes):setVisible(true)
        end 

		WndDismissCommunity:setClickCelPlayerId(self.m_nCurCelId)
		WndDismissCommunity:setClickCelPlayerName(self.m_sCurCelName)
		WndDismissCommunity:setPresidentContainerVisable(6)
		WndPopupMenu:disappear()
	elseif nId == POPUPMENU_PROMOTION then 	 --升职
		--副会长以下才能升职
		if self.m_nJob < UNION_VICE_PRESIDENT then
			ProtocolProcessorUnion:send_LEAGUE_ChangePost(self.m_nCurCelId, 1 )
		else
			MsgBoxManager:showTipBox(LocalStrings.UNION_TEXT1[46])
		end
		WndPopupMenu:disappear()
	
	elseif nId == POPUPMENU_DEMOTED then 	 --降职
		--普通会员以上才能降职
		if self.m_nJob > UNION_MEMBER then
			ProtocolProcessorUnion:send_LEAGUE_ChangePost(self.m_nCurCelId, -1 )
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
function WndUnionHall:onTouchBegan(element, point)
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
	
function WndUnionHall:onFriendFind(element) 
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_sFind = GetElement(self.m_root,"editFind",WZUIEditBox):getText()
	GetElement(self.m_root,"btnCancelFind",WZUIButton):setVisible(true)
	self.m_bFirstEntry = true
	WZLog("onFriendFind", self.m_sFind)
	self:_updateKeepPosition()
end

function WndUnionHall:_updateKeepPosition()
    --刷新列表会员队伍状态
    local tbconList = GetElement(self.m_root, "tbconTextContent_WndUnionHall", WZUITableContainer)
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

function WndUnionHall:onCancelFind(element) 
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tbconList = GetElement(self.m_root, "tbconTextContent_WndUnionHall", WZUITableContainer)
	self.m_bFirstEntry = true
	self.m_sFind = ""
	GetElement(self.m_root, "editFind", WZUIEditBox):setText("")
	GetElement(self.m_root,"btnCancelFind",WZUIButton):setVisible(false)
	self:_update()
    tbconList:getMoveElement():setPositionY(tbconList:getMinPosition().y)
end

function WndUnionHall:setMinPosition() 
	if self.m_root == nil then return end
    local tbconList = GetElement(self.m_root, "tbconTextContent_WndUnionHall", WZUITableContainer)
    tbconList:getMoveElement():setPositionY(tbconList:getMinPosition().y)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	更新函数
function WndUnionHall:_update()
	WZLog("WndUnionHall:_update")
	if self.m_root == nil then 
		WZLog("function WndUnionHall:_update() self.m_root is nil ")
		return 
	end 

	local guildInfo = CacheCenter:getUnionInfo()
	if not GetElement(self.m_root,"conMain1",WZUIContainer):isVisible() then
		return
	end

	--设置联盟信息
	local otherInfo = LocalStrings.COMMUNITYINFO50..":" .. guildInfo.donate .. "  "
	GetElement(self.m_root,"CommunityPrestige1",WZUILabelTTF):setText(LocalStrings.COMMUNITYINFO57 .. self.m_nPrestige .. "  " .. otherInfo)
	--搜索默认字符串
	GetElement(self.m_root,"editFind",WZUIEditBox):setPlaceHolder(LocalStrings.MASTERINFO16)

    self:showRedDot()
	--联盟等级名称id

--	local strNameAndLv = guildInfo.guildName .. "  " .. LocalStrings.PEOPLE_NUM .. self.m_nMembers.."/"..GDatatab_league_level["id_"..guildInfo.guildLevel].total
	local strNameAndLv = guildInfo.guildName .. "(" .. LocalStrings.LV .. guildInfo.guildLevel .. ")" .. "  " .. LocalStrings.PEOPLE_NUM .. self.m_nMembers.."/"..GDatatab_league_level["id_"..guildInfo.guildLevel].total
	GetElement(self.m_root,"CommunityId",WZUILabelTTF):setText(LocalStrings.MUL_ID .. guildInfo.guildId .. "  " .. strNameAndLv)

	--更新管理面板
	self:updateManage()

	--设置成员列表中的内容
	if self.m_tCellList == nil then self.m_tCellList = {} end

	local tbconTextContent = self.m_root:getChildElement("tbconTextContent_WndUnionHall")
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
--				tbconTextContent:setTopElementFunction("onFrontPageBtn")--设置TopElement的Lua回调函数
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
--				tbconTextContent:setBottomElementFunction("onNextPageBtn")--设置BottomElement的Lua回调函数
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
function WndUnionHall:_scheduleCreateCell(element, delta)
	if element == nil or self.m_tMemberList == nil then 
		element:disableSchedule()
		return 
	end 	

	local tbconTextContent = GetElement(self.m_root,"tbconTextContent_WndUnionHall",WZUITableContainer)

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
	for i = 1, 50 do 
		if self.m_nCurrentCellIndex > #self.m_tMemberList then    
			return 
		end 
		--还没创建Cell
		local celElement,tCell
		if self.m_tCellList[self.m_nCurrentCellIndex] == nil then
			celElement,tCell =  CellUnionMemberList:createElement()
			if celElement ~= nil and tCell ~= nil then 
				celElement:setTag(self.m_nTag - 1)
				if self.m_sFind == nil then self.m_sFind = "" end
				local a, b = string.find(tostring(self.m_tMemberList[self.m_nCurrentCellIndex].playerId), self.m_sFind)
				if a ~= nil then
					tbconTextContent:setCellElement(celElement)
					self.m_nTag = self.m_nTag + 1
				end
			end 
			self.m_tCellList[self.m_nCurrentCellIndex] = tCell
		else
			tCell = self.m_tCellList[self.m_nCurrentCellIndex]
		end
		--设置：排名,等级,姓名,工作,总贡献,当天贡献,在线状态,离线时间)
		local tTempData = self.m_tMemberList[self.m_nCurrentCellIndex]
		tCell:setData(tTempData.headId, tTempData.faceId, tTempData.rank, tTempData.playerLevel, tTempData.playerName, tTempData.position, tostring(tTempData.playerContribution), tostring(tTempData.todayContribution), tTempData.onLineState, tTempData.onLine, tTempData.sex, tTempData.vipLevel, tTempData.headColor, tTempData.headEffectId, tTempData.fight)
		--设置玩家ID								
		tCell:setPlayerId(tTempData.playerId)

		self.m_nCurrentCellIndex = self.m_nCurrentCellIndex + 1
	end 
end 



--@brief 点击上一页的函数
function  WndUnionHall:onFrontPageBtn()
	WZLog("WndUnionHall:onFrontPageBtn()")
	--加载圆圈
	self.m_nLoadingCircleId = MsgBoxManager:showLoadingBox()
	--获取成员列表协议
	ProtocolProcessorSceneCommunity:send_COMMUNITY_GetCommunityMemberListNew(CacheCenter:getPlayerInfo().guildId,self.m_nPageNumber-1)
	self.m_bUpPageShowLastPosition = true
end 


--@brief 点击下一页的函数
function WndUnionHall:onNextPageBtn()
	WZLog("WndUnionHall:onNextPageBtn()")
	--加载圆圈
	self.m_nLoadingCircleId = MsgBoxManager:showLoadingBox()
	--获取成员列表协议
	ProtocolProcessorSceneCommunity:send_COMMUNITY_GetCommunityMemberListNew(CacheCenter:getPlayerInfo().guildId,self.m_nPageNumber+1)
end 

--@brief  根据职位判断调用弹出框内容的函数
--@param #1  nMyJob 自己职位 
--@param #2 nJob 点击公会成员的职位
function WndUnionHall:_getPopMenuItems(nMyJob,nCellJob)
	local tPopupMenuItems = {}

	--第一行显示被操作玩家的名字
	table.insert(tPopupMenuItems, POPUPMENU_VARIABLE)
	g_tPopupMenuString[POPUPMENU_VARIABLE] = self.m_sCurCelName

	if nMyJob == UNION_PRESIDENT then
		table.insert(tPopupMenuItems, POPUPMENU_UNION1)
	end

	table.insert(tPopupMenuItems, POPUPMENU_CHAT)		--聊天
	table.insert(tPopupMenuItems, POPUPMENU_ADD)		--好友
	
	return tPopupMenuItems
end 

--@brief	获得公会当前特定职位人数
function WndUnionHall:getPositionNum(position)
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
function WndUnionHall:getPositionMaxNum(position)
	local guildInfo = CacheCenter:getUnionInfo()
	if guildInfo == nil or position == nil then return 0 end
	local positionNumName = {"hy","jy","zl","fhz","hz"}
	local guildLevel = guildInfo.guildLevel
	local limitNum = GDatatab_league_level["id_"..guildLevel][positionNumName[position+1]]
	if limitNum == -1 then limitNum = 99999 end
	return limitNum
end
	
--@brief  取得自己ID的函数
--@return nMyId  自己ID
function WndUnionHall:_getMyId()
	return CacheCenter:getPlayerInfo().id
end 
	
--@brief 静态初始化UI文字
function WndUnionHall:_initStaticUiText()
	WZLog("WndUnionHall:_initStaticUiText")
	if self.m_root == nil then 
		WZLog(" WndUnionHall:_initStaticUiText() self.m_root is nil")
		return 
	end 

	
	--职位
	local txtJob = self.m_root:getChildElement("txtJob_WndUnionHall")
	if txtJob ~= nil then 
		WZUILabelTTF:luaTo(txtJob):setText(LocalStrings.UNION_TEXT1[26])
	end 
	
	--今日贡献
	local txtCon = self.m_root:getChildElement("txtCon_WndUnionHall")
	if txtCon ~= nil then 
		WZUILabelTTF:luaTo(txtCon):setText(LocalStrings.COMMUNITYINFO50)
	end 
	
	--登陆时间
	local txtState = self.m_root:getChildElement("txtState_WndUnionHall")
	if txtState ~= nil then 
		WZUILabelTTF:luaTo(txtState):setText(LocalStrings.COMMUNITYINFO51)
	end 
	GetElement(self.m_root, "txtMain3Btn_WndUnionHall", WZUILabelTTF):setText(LocalStrings.UNION_TEXT1[5])
	GetElement(self.m_root, "txtManage7_WndUnionHall", WZUILabelTTF):setText(LocalStrings.UNION_TEXT1[6])
	GetElement(self.m_root, "txtManage2_WndUnionHall", WZUILabelTTF):setText(LocalStrings.UNION_TEXT2[10])
	GetElement(self.m_root, "txtManage5_WndUnionHall", WZUILabelTTF):setText(LocalStrings.UNION_TEXT2[9])
end 

--@brief	判断是否显示上一页函数
--@note		当前页大于1的时候显示上一页，否则不显示
function WndUnionHall:_getUpPage( )
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
function WndUnionHall:_getDownPage()
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

--@brief 	显示红点
function WndUnionHall:showRedDot()
	if self.m_root == nil then return end 

	if GlobalGame.g_tRedPointList.union then
		GetElement(self.m_root,"imgApply_WndUnionHall",WZUIImage):setVisible(true)
		GetElement(self.m_root,"imgApply1_WndUnionHall",WZUIImage):setVisible(true)
	else
		GetElement(self.m_root,"imgApply_WndUnionHall",WZUIImage):setVisible(false)
		GetElement(self.m_root,"imgApply1_WndUnionHall",WZUIImage):setVisible(false)
	end
end
-------------------------------------私有方法模块End----------------------------------------

---------------------------------------------语言适配Begin-----------------------------------

function WndUnionHall:_adaptLanguage_vn(  )
	GetElement(self.m_root, "txtMain3Btn_WndUnionHall", WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root, "txtManage7_WndUnionHall", WZUILabelTTF):setScale(0.9)
	GetElement(self.m_root, "txtManage2_WndUnionHall", WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root, "txtManage5_WndUnionHall", WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root, "txtManage3_WndUnionHall", WZUILabelTTF):setScale(0.6)
end

---------------------------------------------语言适配End--------------------------------------
