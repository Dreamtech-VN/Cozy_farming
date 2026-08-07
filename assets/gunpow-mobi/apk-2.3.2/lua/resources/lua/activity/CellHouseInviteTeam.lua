--CellHouseInviteTeam.lua
--@brief	CellHouseInviteTeam的UI模块
--@date		2021/09/27
--@author	hyx
--@note		房产主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellHouseInviteTeam:onEnter(element)
	self.m_root = element
	self:register()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellHouseInviteTeam:onExit(element)
	self:_unInit()
	self:unregister()
end
function CellHouseInviteTeam:register()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetInvestMyTeamResult,self)
end
function CellHouseInviteTeam:unregister()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetInvestMyTeamResult,self)
end
function CellHouseInviteTeam:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,false,"actionCallback",self)
end
function CellHouseInviteTeam:actionCallback()
end
function CellHouseInviteTeam:setVisibleStatus(bool)
	bool = bool or false
	if self.m_root then
		self.m_root:setVisible(bool)
	end
	if self.m_nWinType == 1 then 
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7029, 11, "")
	elseif self.m_nWinType == 5 then 
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7058, 8, "")
	elseif self.m_nWinType == 7 then 
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7082, 5, "")
	elseif self.m_nWinType == 9 then
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7087, 5, "")
	elseif self.m_nWinType == 20 then
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7130, 7, "")
	end
	self:_setStaticText()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellHouseInviteTeam:_onGetInvestMyTeamResult(activityId, doType, result, msg)
	if activityId == tonumber(g_cityExtenInfo.activity7029) then
		msg = json.decode(msg)
		if msg then
			if doType == 11 then
				self:_showMyTeam(msg)
			end
		end
	elseif activityId == tonumber(g_cityExtenInfo.activity7058) then 
		msg = json.decode(msg)
		if msg then
			if doType == 8 then
				self:_showMyTeam(msg)
			end
		end
	elseif activityId == tonumber(g_cityExtenInfo.activity7082) then 
		msg = json.decode(msg)
		if msg then
			if doType == 5 then
				self:_showMyTeam(msg)
			end
		end
	elseif activityId == tonumber(g_cityExtenInfo.activity7087) then 
		msg = json.decode(msg)
		if msg then
			if doType == 5 then
				self:_showMyTeam(msg)
			end
		end
	elseif activityId == tonumber(g_cityExtenInfo.activity7130) then 
		msg = json.decode(msg)
		if msg then
			if doType == 7 then
				self:_showMyTeam(msg)
			end
		end
	end
end

--@brief 	显示我的团队
function CellHouseInviteTeam:_showMyTeam(msg)
	local data = self:setHouseMyTeamData(msg.names, msg.ids, msg.headIds, msg.faceIds, msg.sexs, msg.vipLevels, msg.headColors, msg.levels, msg.times, msg.serverIds, msg.profileFrame)
	local teamFreeList = GetElement(self.m_root,"teamFreeList",WZUIFreeListContainer)
	teamFreeList:removeAll()
	if next(data) == nil then
		ShowPanelNullTip(teamFreeList, LocalStrings.ACTIVITY_TEXT211)
	else
		removeShowPanelNullTip(teamFreeList)
		for i = 1, #data do
			local element, tLuaObj = TeamItem:createElement()
			teamFreeList:pushBack(WZUIContainer:luaTo(element))
			teamFreeList:getMoveElement():setPositionY(teamFreeList:getMinPosition().y)
			tLuaObj:setTeamData(data[i])
		end
	end
end

--@brief 	设置一些文字的显示
function CellHouseInviteTeam:_setStaticText()
	local txtAtt = GetElement(self.m_root, "txtAtt_CellHouseInviteTeam", WZUILabelTTF)
	local txtTopTitle2 = GetElement(self.m_root, "txtTopTitle2_CellHouseInviteTeam", WZUILabelTTF)
	if self.m_nWinType == 5 then 
		txtTopTitle2:setTextKey("")
		txtTopTitle2:setText(LocalStrings.MIDNIGHTDINER_TEXT1[19])

		txtAtt:setTextKey("")
		txtAtt:setText(LocalStrings.MIDNIGHTDINER_TEXT1[23])
	elseif self.m_nWinType == 7 then 
		txtTopTitle2:setTextKey("")
		txtTopTitle2:setText(LocalStrings.GOLFBALL_TEXT1[19])

		txtAtt:setTextKey("")
		txtAtt:setFontSize(18)
		txtAtt:setText(LocalStrings.GOLFBALL_TEXT1[9])
	elseif self.m_nWinType == 9 then 
		txtTopTitle2:setTextKey("")
		txtTopTitle2:setText(LocalStrings.GOLD_MINER_TEXT1[12])

		txtAtt:setTextKey("")
		txtAtt:setFontSize(18)
		txtAtt:setText(LocalStrings.GOLFBALL_TEXT1[9])
	elseif self.m_nWinType == 20 then 
		txtTopTitle2:setTextKey("")
		txtTopTitle2:setText(LocalStrings.KINGOFMINING_TEXT1[26])

		txtAtt:setTextKey("")
		txtAtt:setFontSize(18)
		txtAtt:setText(LocalStrings.GOLFBALL_TEXT1[9])
	end
end
-------------------------------------私有方法模块End----------------------------------------
