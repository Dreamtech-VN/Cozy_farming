--WndWeekendSpecial.lua
--@brief	WndWeekendSpecial的UI模块
--@date		2024/08/19
--@author	yrd
--@note		周末特惠


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndWeekendSpecial:onEnter(element)
	self.m_root = element

	g_bIsShowWndDressUp = false
	g_tTempItemForLaterShow = {}
	ProtocolProcessorFestivalActivity:regAll6()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
	GlobalGame:getGameEventDispathcer():Add(NewVipEvent.NewVipEvent_ChargeSuccessResult,self._onRechargeSuccessResult,self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndWeekendSpecial:onExit(element)
	g_bIsShowWndDressUp = true
	g_tTempItemForLaterShow = {}
	ProtocolProcessorFestivalActivity:unregAll6()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
	GlobalGame:getGameEventDispathcer():Remove(NewVipEvent.NewVipEvent_ChargeSuccessResult,self._onRechargeSuccessResult,self)

	self:_unInit()
	LoadNewActivityRes(false)
end

--@brief    onenter函数已执行
function WndWeekendSpecial:onEnterTransitionDidFinish(element)
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7138, 7138)
end

--@brief    点击关闭窗口按钮
function WndWeekendSpecial:showInterface()
	LoadNewActivityRes(true)
	local wnd = WndWeekendSpecial:createElement()
	WindowManager:addWindow(wnd, WndWeekendSpecial, nil, nil, nil, true)
end

--@brief    点击关闭窗口按钮
function WndWeekendSpecial:onClickClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    显示礼包
function WndWeekendSpecial:showGifts()
	local tcGiftsA = GetElement(self.m_root,"tcGiftsA",WZUITableContainer)
	local tcGiftsB = GetElement(self.m_root,"tcGiftsB",WZUITableContainer)
	tcGiftsA:setVisible(false)
	tcGiftsB:setVisible(false)
	if self.m_nShowGift == 0 then
		tcGiftsA:setVisible(true)
	elseif self.m_nShowGift == 1 then
		tcGiftsB:setVisible(true)
	end

	if self.m_bRecordedPt then
		self.m_nGiftAPrevPtY = tcGiftsA:getMoveElement():getPositionY()
	end
	-- self.m_tFirstGiftObj = {}
	-- tcGiftsA:cleanTable()
	local tData = self.m_tFirstGiftCopy
	local nShowCount = math.min(#tData, 12)
	for i=1,nShowCount do
		if self.m_tFirstGiftObj[i] then
			self.m_tFirstGiftObj[i]:setData(tData[i])
			self.m_tFirstGiftObj[i]:setArrawType(math.floor((i - 1) % 6 / 2) + 1)

			self.m_tFirstGiftObj[i]:showUI(true)
		    local action = WZUIActionSequence:create()
			local actFadeTo = WZUIActionContainerFadeFromTo:create()
			actFadeTo:setDuration(0)
			actFadeTo:setOpacityFrom(255)
			actFadeTo:setOpacityTo(255)
			action:setChildAction(actFadeTo)
			self.m_tFirstGiftObj[i].m_root:runUIAction(action)
		else
			local celElement, tLuaObj = CellWeekendSpecial:createElement()
			celElement:setTag(i-1)
			tcGiftsA:setCellElement(celElement)
			tLuaObj:setData(tData[i])
			tLuaObj:setArrawType(math.floor((i - 1) % 6 / 2) + 1)
			table.insert(self.m_tFirstGiftObj, tLuaObj)
		end
	end
	for i=#self.m_tFirstGiftObj, nShowCount+1, -1 do
		self.m_tFirstGiftObj[i].m_root:removeAllChildrenWithCleanup(true)
		table.remove(self.m_tFirstGiftObj, i)
	end
	if self.m_nGiftAPrevPtY then
		tcGiftsA:getMoveElement():setPositionY(self.m_nGiftAPrevPtY)
	else
		tcGiftsA:getMoveElement():setPositionY(tcGiftsA:getMinPosition().y)
	end

	if self.m_bRecordedPt then
		self.m_nGiftBPrevPtY = tcGiftsB:getMoveElement():getPositionY()
	end
	-- self.m_tSuperGiftObj = {}
	-- tcGiftsB:cleanTable()
	local tData = self.m_tSuperGiftCopy
	local nShowCount = math.min(#tData, 12)
	for i=1,nShowCount do
		if self.m_tSuperGiftObj[i] then
			self.m_tSuperGiftObj[i]:setData(tData[i])
			self.m_tSuperGiftObj[i]:setArrawType(math.floor((i - 1) % 6 / 2) + 1)

			self.m_tSuperGiftObj[i]:showUI(true)
		    local action = WZUIActionSequence:create()
			local actFadeTo = WZUIActionContainerFadeFromTo:create()
			actFadeTo:setDuration(0)
			actFadeTo:setOpacityFrom(255)
			actFadeTo:setOpacityTo(255)
			action:setChildAction(actFadeTo)
			self.m_tSuperGiftObj[i].m_root:runUIAction(action)
		else
			local celElement, tLuaObj = CellWeekendSpecial:createElement()
			celElement:setTag(i-1)
			tcGiftsB:setCellElement(celElement)
			tLuaObj:setData(tData[i])
			tLuaObj:setArrawType(math.floor((i - 1) % 6 / 2) + 1)
			table.insert(self.m_tSuperGiftObj, tLuaObj)
		end
	end
	for i=#self.m_tSuperGiftObj, nShowCount+1, -1 do
		self.m_tSuperGiftObj[i].m_root:removeAllChildrenWithCleanup(true)
		table.remove(self.m_tSuperGiftObj, i)
	end
	if self.m_nGiftBPrevPtY then
		tcGiftsB:getMoveElement():setPositionY(self.m_nGiftBPrevPtY)
	else
		tcGiftsB:getMoveElement():setPositionY(tcGiftsB:getMinPosition().y)
	end

	self.m_bRecordedPt = true
	self.m_tReceivedInfo = nil
end

--@brief    播放动画
function WndWeekendSpecial:playAnimation()
	local giftDataList = {self.m_tFirstGiftCopy, self.m_tSuperGiftCopy}
	local tGiftData =  giftDataList[self.m_tReceivedInfo.type]
	if tGiftData[1].index ~= self.m_tReceivedInfo.index then
		GetElement(self.m_root, "tcGiftsA", WZUITableContainer):setTouchEnable(false)
		GetElement(self.m_root, "tcGiftsB", WZUITableContainer):setTouchEnable(false)

		local giftObjList = {self.m_tFirstGiftObj, self.m_tSuperGiftObj}
		local tGiftObj = giftObjList[self.m_tReceivedInfo.type]
		local nDuration = 0.5
	    local action = WZUIActionSequence:create()
		local actFadeTo = WZUIActionContainerFadeFromTo:create()
		actFadeTo:setDuration(nDuration)
		actFadeTo:setOpacityFrom(255)
		actFadeTo:setOpacityTo(0)
		action:setChildAction(actFadeTo)
		tGiftObj[1].m_root:runUIAction(action)

		for i=1,#tGiftObj do
			tGiftObj[i]:setArrawType(0)
		end

		self.m_nStartIndex = 0
		local conGifts = GetElement(self.m_root,"conGifts",WZUIContainer)
		conGifts:enableSchedule("_scheduleAnimation1", nDuration)
	else
		self:showGifts()
	end
end

--@brief    播放动画
function WndWeekendSpecial:_scheduleAnimation1(element)
	local giftObjList = {self.m_tFirstGiftObj, self.m_tSuperGiftObj}
	local tGiftObj = giftObjList[self.m_tReceivedInfo.type]
	tGiftObj[1]:showUI(false)

	local nDuration = 1
	local conGifts = GetElement(self.m_root,"conGifts",WZUIContainer)
	conGifts:disableSchedule()

	local tcGiftsA = GetElement(self.m_root, "tcGiftsA", WZUITableContainer)
	local tcGiftsB = GetElement(self.m_root, "tcGiftsB", WZUITableContainer)
	local tcList = {tcGiftsA, tcGiftsB}
	local tcGifts = tcList[self.m_tReceivedInfo.type]

	local giftObjList = {self.m_tFirstGiftObj, self.m_tSuperGiftObj}
	local tGiftObj = giftObjList[self.m_tReceivedInfo.type]
	for i=1,#tGiftObj do
		local tLastSize = tcGifts:getMoveElement():getContentSize()
		local nColNum = tcGifts:getColumnCount()
		local nRowNum = math.ceil(#tGiftObj / nColNum)
		local nOffsetX = tLastSize.width / nColNum
		local nOffsetY = tLastSize.height / nRowNum

		local actionArray = CCArray:create()

		local moveBy1
		local moveBy2
		local tempIndex = (i - 1) % 6 + 1
		if tempIndex == 1 or tempIndex == 6 then
			moveBy1 = CCMoveBy:create(nDuration, GlobalMethod:ccp(0, nOffsetY))
			moveBy2 = CCMoveBy:create(0, GlobalMethod:ccp(0, -nOffsetY))
		elseif tempIndex == 2 or tempIndex == 3 then
			moveBy1 = CCMoveBy:create(nDuration, GlobalMethod:ccp(-nOffsetX, 0))
			moveBy2 = CCMoveBy:create(0, GlobalMethod:ccp(nOffsetX, 0))
		elseif tempIndex == 4 or tempIndex == 5 then
			moveBy1 = CCMoveBy:create(nDuration, GlobalMethod:ccp(nOffsetX, 0))
			moveBy2 = CCMoveBy:create(0, GlobalMethod:ccp(-nOffsetX, 0))
		end
		actionArray:addObject(moveBy1)
		actionArray:addObject(moveBy2)
        actionArray:addObject(CCCallFuncN:create(function ()
			self:_scheduleAnimation2(element)
        end))
		local sequence = CCSequence:create(actionArray)
		tGiftObj[i].m_root:runAction(sequence) 
	end
end

--@brief    播放动画
function WndWeekendSpecial:_scheduleAnimation2(element)
	element:disableSchedule()

	GetElement(self.m_root, "tcGiftsA", WZUITableContainer):setTouchEnable(true)
	GetElement(self.m_root, "tcGiftsB", WZUITableContainer):setTouchEnable(true)

	self:showGifts()
end

--@brief    显示剩余时间
function WndWeekendSpecial:showRemainingTime(element)
	local txtLeftTime = GetElement(self.m_root,"txtLeftTime",WZUILabelTTF)
	self:_ScheduleTime()
	txtLeftTime:enableSchedule("_ScheduleTime",1)
end

--@brief    显示剩余时间
function WndWeekendSpecial:_ScheduleTime(element)
	local txtLeftTime = GetElement(self.m_root,"txtLeftTime",WZUILabelTTF)
	local nServerTime = SystemTime:getServerTime()
	local diffTime = self.m_nEndTimestamp - nServerTime
	if diffTime > 0 then
		if diffTime > 86400 then
			local nLeftHour = math.ceil(diffTime / 3600)
			local day = math.floor(nLeftHour / 24)
			local hour = nLeftHour % 24
			txtLeftTime:setText(string.format(LocalStrings.TOPGOLD_TEXT1, day, hour))
		elseif diffTime > 3600 then
			local nLeftMin = math.ceil(diffTime / 60)
			local hour = math.floor(nLeftMin / 60)
			local min = nLeftMin % 60
			txtLeftTime:setText(string.format(LocalStrings.TOPGOLD_TEXT2, hour, min))
		else
			local min = math.floor(diffTime / 60)
			local sec = diffTime % 60
			txtLeftTime:setText(string.format(LocalStrings.TOPGOLD_TEXT5, min, sec))
		end
	else
		txtLeftTime:setText("")
		txtLeftTime:disableSchedule()
		WindowManager:removeWindow(self.m_root, self, true)
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
