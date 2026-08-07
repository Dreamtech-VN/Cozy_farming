--CellHouseInviteNotice.lua
--@brief	CellHouseInviteNotice的UI模块
--@date		2021/09/27
--@author	hyx
--@note		房产主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellHouseInviteNotice:onEnter(element)
	self.m_root = element
	self:register()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellHouseInviteNotice:onExit(element)
	self:_unInit()
	self:unregister()
end
function CellHouseInviteNotice:register()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetInvestNoticeResult,self)
end
function CellHouseInviteNotice:unregister()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetInvestNoticeResult,self)
end
function CellHouseInviteNotice:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,false,"actionCallback",self)
end
function CellHouseInviteNotice:actionCallback()
end
function CellHouseInviteNotice:setVisibleStatus(bool)
	bool = bool or false
	if self.m_root then
		self.m_root:setVisible(bool)
	end
	local txtBottomDesc = GetElement(self.m_root, "txtBottomDesc_CellHouseInviteNotice", WZUILabelTTF)
	if self.m_nWinType == 2 then 
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7030, 4, "")
	elseif self.m_nWinType == 5 then 
		txtBottomDesc:setText(LocalStrings.MIDNIGHTDINER_TEXT1[25])
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7058, 2, "")
	elseif self.m_nWinType == 6 then 
		txtBottomDesc:setText(LocalStrings.TEAMCONSUME_TEXT1[12])
		txtBottomDesc:setColor(GlobalMethod:ccc3(255,255,255))
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7074, 4, "")
	elseif self.m_nWinType == 7 then 
		txtBottomDesc:setText(LocalStrings.GOLFBALL_TEXT1[26])
		txtBottomDesc:setFontSize(18)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7082, 7, "")
	elseif self.m_nWinType == 9 then 
		txtBottomDesc:setText(LocalStrings.GOLFBALL_TEXT1[26])
		txtBottomDesc:setFontSize(18)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7087, 7, "")
	elseif self.m_nWinType == 20 then 
		txtBottomDesc:setText(string.format(LocalStrings.KINGOFMINING_TEXT1[28], WndKingOfMining.m_tContent.teamLimitConfig))
		txtBottomDesc:setFontSize(18)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7130, 9, "")
	else
		txtBottomDesc:setText(LocalStrings.ACTIVITY_TEXT208)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7029, 2, "")
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellHouseInviteNotice:_onGetInvestNoticeResult(activityId, doType, result, msg)
	WZLog("CellHouseInviteNotice:_onGetInvestNoticeResult", activityId, doType, result, msg)
	if activityId == tonumber(g_cityExtenInfo.activity7029) or activityId == tonumber(g_cityExtenInfo.activity7058) then
		msg = json.decode(msg)
		if msg then 
			if doType == 2 then
				self.m_tNoticeData = self:setHouseNoticeData(msg.type, msg.names, msg.ids, msg.headIds, msg.faceIds, msg.sexs, msg.vipLevels, msg.headColors, msg.levels, msg.serverIds, activityId)
				self:setCreateNoticeItem(self.m_tNoticeData)
			elseif doType == 4 then
				MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT205[result])
				for i=#self.m_tNoticeData, 1, -1 do
					if self.m_tNoticeData[i].playerid == msg.id then
						table.remove(self.m_tNoticeData, i)
						break
					end
				end
				self:setCreateNoticeItem(self.m_tNoticeData)
			elseif doType == 5 then
				MsgBoxManager:showTipBox(LocalStrings.MASTERINFO55)
				for i=#self.m_tNoticeData, 1, -1 do
					if self.m_tNoticeData[i].playerid == msg.id then
						table.remove(self.m_tNoticeData, i)
						break
					end
				end
				self:setCreateNoticeItem(self.m_tNoticeData)
			end
		end
	elseif activityId == tonumber(g_cityExtenInfo.activity7030) then
		msg = json.decode(msg)
		if msg then 
			self:updateLeftNum()
			if doType == 4 then
				self.m_tNoticeData = self:setCardNoticeData(msg.uncheckedIndexes, msg.name, msg.playerId, msg.headId, msg.faceId, msg.sex, msg.vipLevel, msg.headColor, msg.level, msg.serverId, msg.profileFrame)
				self:setCreateNoticeItem(self.m_tNoticeData)
			end
		end
	elseif activityId == tonumber(g_cityExtenInfo.activity7074) then
		msg = json.decode(msg)
		if msg then 
			if doType == 4 then
				self.m_tNoticeData = self:setHouseNoticeData(msg.type, msg.names, msg.ids, msg.headIds, msg.faceIds, msg.sexs, msg.vipLevels, msg.headColors, msg.levels, msg.serverIds, activityId)
				self:setCreateNoticeItem(self.m_tNoticeData)
			elseif doType == 6 then
				MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT205[result])
				for i=#self.m_tNoticeData, 1, -1 do
					if self.m_tNoticeData[i].playerid == msg.id then
						table.remove(self.m_tNoticeData, i)
						break
					end
				end
				self:setCreateNoticeItem(self.m_tNoticeData)
			elseif doType == 7 then
				MsgBoxManager:showTipBox(LocalStrings.MASTERINFO55)
				for i=#self.m_tNoticeData, 1, -1 do
					if self.m_tNoticeData[i].playerid == msg.id then
						table.remove(self.m_tNoticeData, i)
						break
					end
				end
				self:setCreateNoticeItem(self.m_tNoticeData)
			end
		end
	elseif activityId == tonumber(g_cityExtenInfo.activity7082) then
		msg = json.decode(msg)
		if msg then 
			if doType == 7 then
				self.m_tNoticeData = self:setHouseNoticeData(msg.type, msg.names, msg.ids, msg.headIds, msg.faceIds, msg.sexs, msg.vipLevels, msg.headColors, msg.levels, msg.serverIds, activityId, msg.desc)
				self:setCreateNoticeItem(self.m_tNoticeData)
			elseif doType == 9 then
				MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT205[result])
				for i=#self.m_tNoticeData, 1, -1 do
					if self.m_tNoticeData[i].playerid == msg.id then
						table.remove(self.m_tNoticeData, i)
						break
					end
				end
				self:setCreateNoticeItem(self.m_tNoticeData)
			elseif doType == 10 then
				MsgBoxManager:showTipBox(LocalStrings.MASTERINFO55)
				for i=#self.m_tNoticeData, 1, -1 do
					if self.m_tNoticeData[i].playerid == msg.id then
						table.remove(self.m_tNoticeData, i)
						break
					end
				end
				self:setCreateNoticeItem(self.m_tNoticeData)
			end
		end
	elseif activityId == tonumber(g_cityExtenInfo.activity7087) then
		msg = json.decode(msg)
		if msg then 
			if doType == 7 then
				self.m_tNoticeData = self:setHouseNoticeData(msg.type, msg.names, msg.ids, msg.headIds, msg.faceIds, msg.sexs, msg.vipLevels, msg.headColors, msg.levels, msg.serverIds, activityId, msg.desc)
				self:setCreateNoticeItem(self.m_tNoticeData)
			elseif doType == 9 then
				MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT205[result])
				for i=#self.m_tNoticeData, 1, -1 do
					if self.m_tNoticeData[i].playerid == msg.id then
						table.remove(self.m_tNoticeData, i)
						break
					end
				end
				self:setCreateNoticeItem(self.m_tNoticeData)
			elseif doType == 10 then
				MsgBoxManager:showTipBox(LocalStrings.MASTERINFO55)
				for i=#self.m_tNoticeData, 1, -1 do
					if self.m_tNoticeData[i].playerid == msg.id then
						table.remove(self.m_tNoticeData, i)
						break
					end
				end
				self:setCreateNoticeItem(self.m_tNoticeData)
			end
		end
	elseif activityId == tonumber(g_cityExtenInfo.activity7130) then
		msg = json.decode(msg)
		if msg then
			if doType == 9 then
				self.m_tNoticeData = self:setHouseNoticeData(msg.type, msg.names, msg.ids, msg.headIds, msg.faceIds, msg.sexs, msg.vipLevels, msg.headColors, msg.levels, msg.serverIds, activityId, msg.desc)
				self:setCreateNoticeItem(self.m_tNoticeData)
			elseif doType == 11 then
				MsgBoxManager:showTipBox(LocalStrings.KINGOFMINING_TEXT4[result])
				for i=#self.m_tNoticeData, 1, -1 do
					if self.m_tNoticeData[i].playerid == msg.id then
						table.remove(self.m_tNoticeData, i)
						break
					end
				end
				self:setCreateNoticeItem(self.m_tNoticeData)

				--刷新采矿主界面
				ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7130, 1, "")
			elseif doType == 12 then
				MsgBoxManager:showTipBox(LocalStrings.MASTERINFO55)
				for i=#self.m_tNoticeData, 1, -1 do
					if self.m_tNoticeData[i].playerid == msg.id then
						table.remove(self.m_tNoticeData, i)
						break
					end
				end
				self:setCreateNoticeItem(self.m_tNoticeData)
			end
		end
	end
end
function CellHouseInviteNotice:setCreateNoticeItem(data)
	if not data then return end

	local noticeFreeList = GetElement(self.m_root,"noticeFreeList",WZUIFreeListContainer)
	noticeFreeList:removeAll()
	if next(data) == nil then
		ShowPanelNullTip(noticeFreeList, LocalStrings.ACTIVITY_TEXT210)
	else
		removeShowPanelNullTip(noticeFreeList)
		for i = 1, #data do
			local element, tLuaObj = NoticeItem:createElement()
			self.m_tNoticeItem[data[i].playerid] = tLuaObj
			noticeFreeList:pushBack(WZUIContainer:luaTo(element))
			noticeFreeList:getMoveElement():setPositionY(noticeFreeList:getMinPosition().y)
			tLuaObj:setNoticeData(data[i])
		end
	end
end

--@brief 	移除领取的礼品卡
function CellHouseInviteNotice:updateList(uniIndex)
	if self.m_root == nil then return end 

	local AchieFreeList =  GetElement(self.m_root, "noticeFreeList", WZUIFreeListContainer)
	local nCurPos = AchieFreeList:getPositionY()
	for i=1, AchieFreeList:size() do
		local element               
		element = AchieFreeList:getAt(i-1)	
		if element == nil then
			return
		end
		element = WZUIContainer:luaTo(element)
		local tNewObj = element:getLuaObjectIndex()
		local cellJobid = tNewObj:getUniqueId()

		for k=1, #self.m_tNoticeData do
			if uniIndex == self.m_tNoticeData[k].uncheckedIndexes then
				table.remove(self.m_tNoticeData, k)
				break 
			end
		end

		if cellJobid == uniIndex then 
			AchieFreeList:removeAt(i - 1)
			break 
		end
	end

	if nCurPos < AchieFreeList:getMinPosition().y then 
		nCurPos = AchieFreeList:getMinPosition().y
	end
	AchieFreeList:getMoveElement():setPositionY(nCurPos)
	if #self.m_tNoticeData <= 0 then
		if self.m_nWinType == 2 then  
			GlobalGame.g_tRedPointTypeList[27030] = false 
		elseif self.m_nWinType == 5 then 
			GlobalGame.g_tRedPointTypeList[17058] = false 
		elseif self.m_nWinType == 6 then 
			GlobalGame.g_tRedPointTypeList[17074] = false 
		elseif self.m_nWinType == 7 then 
			GlobalGame.g_tRedPointTypeList[17082] = false 
		elseif self.m_nWinType == 9 then 
			GlobalGame.g_tRedPointTypeList[17087] = false 
		elseif self.m_nWinType == 20 then 
			GlobalGame.g_tRedPointTypeList[17130] = false 
		end
		WndHouseInvite:setInviteNoticeRedPoint()
		WndDecorations:showRedDot()

		ShowPanelNullTip(AchieFreeList, LocalStrings.ACTIVITY_TEXT210)
	end
end
-------------------------------------私有方法模块End----------------------------------------
