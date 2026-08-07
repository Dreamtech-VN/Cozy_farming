--CellHouseInviteFriend.lua
--@brief	CellHouseInviteFriend的UI模块
--@date		2021/09/27
--@author	hyx
--@note		房产主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellHouseInviteFriend:onEnter(element)
	self.m_root = element
	self:register()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellHouseInviteFriend:onExit(element)
	self:_unInit()
	self:unregister()
end
function CellHouseInviteFriend:register()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetInvestFriendResult,self)
end
function CellHouseInviteFriend:unregister()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetInvestFriendResult,self)
end
function CellHouseInviteFriend:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,false,"actionCallback",self)
end
function CellHouseInviteFriend:actionCallback()
end
function CellHouseInviteFriend:setVisibleStatus(bool)
	bool = bool or false
	if self.m_root then
		self.m_root:setVisible(bool)
	end

	local txtBottomAtt = GetElement(self.m_root, "txtBottomAtt_CellHouseInviteFriend", WZUILabelTTF)
	if self.m_nWinType == 1 then 
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7029, 1, "")
	elseif self.m_nWinType == 5 then 
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7058, 1, "")
	elseif self.m_nWinType == 6 then 
		txtBottomAtt:setColor(GlobalMethod:ccc3(255,255,255))
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7074, 3, "")
	elseif self.m_nWinType == 7 then 
		txtBottomAtt:setTextKey("")
		txtBottomAtt:setFontSize(18)
		txtBottomAtt:setText(LocalStrings.GOLFBALL_TEXT1[20])
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7082, 6, "")
	elseif self.m_nWinType == 9 then 
		txtBottomAtt:setTextKey("")
		txtBottomAtt:setFontSize(18)
		txtBottomAtt:setText(LocalStrings.GOLFBALL_TEXT1[20])
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7087, 6, "")
	elseif self.m_nWinType == 20 then
		txtBottomAtt:setTextKey("")
		txtBottomAtt:setFontSize(18)
		txtBottomAtt:setText(string.format(LocalStrings.KINGOFMINING_TEXT1[27], WndKingOfMining.m_tContent.teamLimitConfig))
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7130, 8, "")
	end
end
function CellHouseInviteFriend:onBtnInvest( ... )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if next(self.m_tChoosePlsyerId) == nil then
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT203)
		return
	end
	local ids = {}
	for i,v in pairs(self.m_tChoosePlsyerId) do
		table.insert(ids, i)
	end
	local tab = {}
	tab.ids = ids
	tab = json.encode(tab)
	if self.m_nWinType == 1 then 
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7029, 3, tab)
	elseif self.m_nWinType == 5 then 
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7058, 3, tab)
	elseif self.m_nWinType == 6 then 
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7074, 5, tab)
	elseif self.m_nWinType == 7 then 
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7082, 8, tab)
	elseif self.m_nWinType == 9 then 
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7087, 8, tab)
	elseif self.m_nWinType == 20 then 
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7130, 10, tab)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellHouseInviteFriend:_onGetInvestFriendResult(activityId, doType, result, msg)
	if activityId == tonumber(g_cityExtenInfo.activity7029) or activityId == tonumber(g_cityExtenInfo.activity7058) then
		msg = json.decode(msg)
		if doType == 1 then
			self.m_tFriendInvestData = self:setInviteData(msg)
			self:setCreateInvestItem()
		elseif doType == 3 then --发出邀请
			for m=1, #msg.ids do
				for i = 1, #self.m_tFriendInvestData do
					if msg.ids[m] == self.m_tFriendInvestData[i].playerId and self.m_tFriendItem[self.m_tFriendInvestData[i].playerId] then
						self.m_tFriendItem[self.m_tFriendInvestData[i].playerId]:setChooseApplyVisible(2)
						break
					end
				end
			end
			self.m_tChoosePlsyerId = {}
		end
	elseif activityId == tonumber(g_cityExtenInfo.activity7074) then
		msg = json.decode(msg)
		if doType == 3 then
			self.m_tFriendInvestData = self:setInviteData(msg)
			self:setCreateInvestItem()
		elseif doType == 5 then --发出邀请
			for m=1, #msg.ids do
				for i = 1, #self.m_tFriendInvestData do
					if msg.ids[m] == self.m_tFriendInvestData[i].playerId and self.m_tFriendItem[self.m_tFriendInvestData[i].playerId] then
						self.m_tFriendItem[self.m_tFriendInvestData[i].playerId]:setChooseApplyVisible(2)
						break
					end
				end
			end
			self.m_tChoosePlsyerId = {}
		end
	elseif activityId == tonumber(g_cityExtenInfo.activity7082) then
		msg = json.decode(msg)
		if doType == 6 then
			self.m_tFriendInvestData = self:setInviteData(msg)
			self.m_nInviteState = msg.applyStatus 
			self:setCreateInvestItem()
		elseif doType == 8 then --发出邀请
			for m=1, #msg.ids do
				for i = 1, #self.m_tFriendInvestData do
					if msg.ids[m] == self.m_tFriendInvestData[i].playerId and self.m_tFriendItem[self.m_tFriendInvestData[i].playerId] then
						self.m_tFriendItem[self.m_tFriendInvestData[i].playerId]:setChooseApplyVisible(2)
						break
					end
				end
			end
			self.m_tChoosePlsyerId = {}
		end
	elseif activityId == tonumber(g_cityExtenInfo.activity7087) then
		msg = json.decode(msg)
		if doType == 6 then
			self.m_tFriendInvestData = self:setInviteData(msg)
			self.m_nInviteState = msg.applyStatus 
			self:setCreateInvestItem()
		elseif doType == 8 then --发出邀请
			for m=1, #msg.ids do
				for i = 1, #self.m_tFriendInvestData do
					if msg.ids[m] == self.m_tFriendInvestData[i].playerId and self.m_tFriendItem[self.m_tFriendInvestData[i].playerId] then
						self.m_tFriendItem[self.m_tFriendInvestData[i].playerId]:setChooseApplyVisible(2)
						break
					end
				end
			end
			self.m_tChoosePlsyerId = {}
		end
	elseif activityId == tonumber(g_cityExtenInfo.activity7130) then
		msg = json.decode(msg)
		if doType == 8 then
			self.m_tFriendInvestData = self:setInviteData(msg)
			self.m_nInviteState = msg.applyStatus 
			self:setCreateInvestItem()
		elseif doType == 10 then --发出邀请
			for m=1, #msg.ids do
				for i = 1, #self.m_tFriendInvestData do
					if msg.ids[m] == self.m_tFriendInvestData[i].playerId and self.m_tFriendItem[self.m_tFriendInvestData[i].playerId] then
						self.m_tFriendItem[self.m_tFriendInvestData[i].playerId]:setChooseApplyVisible(2)
						break
					end
				end
			end
			self.m_tChoosePlsyerId = {}
		end
	end
end
function CellHouseInviteFriend:setCreateInvestItem()
	local friendFreeList = GetElement(self.m_root,"friendFreeList",WZUIFreeListContainer)
	friendFreeList:removeAll()
	if next(self.m_tFriendInvestData) == nil then
		local defaultStr = LocalStrings.CHARM_RESULT
		if self.m_nInviteState == 1 then 
			defaultStr = LocalStrings.ACTIVITY_TEXT205[6]
		elseif self.m_nInviteState == 2 then 
			defaultStr = LocalStrings.GOLFBALL_TEXT1[30]
		elseif self.m_nInviteState == 3 then 
			defaultStr = LocalStrings.GOLFBALL_TEXT1[31]
		end
		ShowPanelNullTip(friendFreeList, defaultStr)
	else
		removeShowPanelNullTip(friendFreeList)
		for i = 1, #self.m_tFriendInvestData do
			local element, tLuaObj = FriendItem:createElement()
			self.m_tFriendItem[self.m_tFriendInvestData[i].playerId] = tLuaObj
			friendFreeList:pushBack(WZUIContainer:luaTo(element))
			friendFreeList:getMoveElement():setPositionY(friendFreeList:getMinPosition().y)
			tLuaObj:setNoticeData(self.m_tFriendInvestData[i],function(playerid)
				self:setChoosePlayerId(playerid)
			end)
		end
	end
end
function CellHouseInviteFriend:setChoosePlayerId(playerid)
	local visible = false
	if self.m_tChoosePlsyerId[playerid] then
		self.m_tChoosePlsyerId[playerid] = nil
	else
		self.m_tChoosePlsyerId[playerid] = true
		visible = true
	end
	if self.m_tFriendItem[playerid] then
		self.m_tFriendItem[playerid]:setSelectPlayer(visible)
	end
end
-------------------------------------私有方法模块End----------------------------------------


function CellHouseInviteFriend:_adaptLanguage_vn()
	local txtBottomAtt = GetElement(self.m_root,"txtBottomAtt_CellHouseInviteFriend",WZUILabelTTF)
	txtBottomAtt:setDimensions(GlobalMethod:CCSize(620,0))
	txtBottomAtt:setAlignment(kCCTextAlignmentLeft)
end