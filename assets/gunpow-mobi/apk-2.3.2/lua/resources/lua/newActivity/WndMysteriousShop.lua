--WndMysteriousShop.lua
--@brief	WndMysteriousShop的UI模块
--@date		2024/10/21
--@author	yrd
--@note		双11神秘商店


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMysteriousShop:onEnter(element)
	self.m_root = element

	g_bIsShowWndDressUp = false
	g_tTempItemForLaterShow = {}
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
	ProtocolProcessorFestivalActivity:regAll6()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
	GlobalGame:getGameEventDispathcer():Add(Independent_Activity.ActivityReddot, self.showRedDot, self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetTaskList,self._onGetTaskInfo,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetResult,self._onGetTaskResult,self)

	self:_initStaticText()
	self:_updateCoinNum()
	self:showRedDot()

	GetElement(self.m_root,"cbgTitleList",WZUICheckBoxGroup):setCheckIndex(self.m_nTabIndex - 1)
	for i=1,4 do
		GetElement(self.m_root,"conMain"..i,WZUIContainer):setVisible(self.m_nTabIndex == i)
	end

	GetElement(self.m_root,"conMyCoupon",WZUIContainer):setVisible(false)

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMysteriousShop:onExit(element)
	g_bIsShowWndDressUp = true
	g_tTempItemForLaterShow = {}
	CacheCenter:unregisterUpatePlayerItemObserver(self)
	ProtocolProcessorFestivalActivity:unregAll6()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
	GlobalGame:getGameEventDispathcer():Remove(Independent_Activity.ActivityReddot, self.showRedDot, self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetTaskList,self._onGetTaskInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetResult,self._onGetTaskResult,self)

	self:_unInit()
	LoadNewActivityRes(false)
end

--@brief    onenter函数已执行
function WndMysteriousShop:onEnterTransitionDidFinish(element)
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7144, 7144)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7144, 4, "") --用来计算购物车数量
end

--@brief    外部接口
function WndMysteriousShop:showInterface()
	LoadNewActivityRes(true)
	local wnd = WndMysteriousShop:createElement()
	WindowManager:addWindow(wnd, WndMysteriousShop, false)
end

--@brief    点击关闭窗口按钮
function WndMysteriousShop:onClickClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    刷新购物卡数量
function WndMysteriousShop:_updateCoinNum()
	local sFormat = [[<I Z="0.4" P="1">%s</I><T C="255,236,193" S="20" P="1" SC="163,74,20" SS="4" SE="0">%d</T>]]
	local basicData = GDatatab_item["id_" .. self.m_nCoinId]
	local nNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	GetElement(self.m_root, "ftbM1Coin", WZUIFreeTextBox):setShowText(string.format(sFormat, basicData.icon, nNum))
	GetElement(self.m_root, "ftbM2Coin", WZUIFreeTextBox):setShowText(string.format(sFormat, basicData.icon, nNum))
	GetElement(self.m_root, "ftbM3Coin", WZUIFreeTextBox):setShowText(string.format(sFormat, basicData.icon, nNum))
	local sFormat = [[<I Z="0.4" P="1">%s</I><T C="255,255,255" S="20" P="1">%d</T>]]
	GetElement(self.m_root, "ftbM4Coin", WZUIFreeTextBox):setShowText(string.format(sFormat, basicData.icon, nNum))
end

--@brief 	初始化活动时间
function WndMysteriousShop:_initActivityTime()
	local tStartDate = os.date("*t", self.m_nStartTime)
	local tEndDate = os.date("*t", self.m_nEndTime)
	local sDuration = string.format(LocalStrings.ACTIVITYTIME_FORMAT, tStartDate.month, tStartDate.day, tStartDate.hour, tStartDate.min, tEndDate.month, tEndDate.day, tEndDate.hour, tEndDate.min)
	GetElement(self.m_root, "txtActivityTime", WZUILabelTTF):setText(sDuration)
end

--@brief    点击界面按钮
function WndMysteriousShop:onTouchBegan(element, pt)
	local conM4CouponPop = GetElement(self.m_root, "conM4CouponPop", WZUIContainer)
	if conM4CouponPop then
		local btnSize = conM4CouponPop:getContentSize()
		local ptA = conM4CouponPop:convertToWorldSpace(GlobalMethod:ccp(0,0))
		if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
		else
			conM4CouponPop:setVisible(false)
			if self.m_tM4CartObj and self.m_nM4CartIndex then
				local tCelObj = self.m_tM4CartObj[self.m_nM4CartIndex+1]
				if tCelObj and tCelObj.m_root then
					local imgCouponArrow = GetElement(tCelObj.m_root,"imgCouponArrow_cellM4Tasks",WZUIImage)
					imgCouponArrow:setFlipY(true)
				end
			end
		end 
	end

	local conM4CListW1 = GetElement(self.m_root, "conM4CListW1", WZUIContainer)
	if conM4CListW1 then
		local btnSize = conM4CListW1:getContentSize()
		local ptA = conM4CListW1:convertToWorldSpace(GlobalMethod:ccp(0,0))
		if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
		else
			conM4CListW1:setVisible(false)
			GetElement(self.m_root,"imgM4CouponArrow",WZUIImage):setFlipY(false)
		end 
	end
end

--@brief    点击规则按钮
function WndMysteriousShop:onRuleClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSingleMapDesc:showInterface(LocalStrings.MYSTERIOUS_SHOP_TEXT2)
end

--@brief 	红点
function WndMysteriousShop:showRedDot()
	if self.m_root == nil then return end 

	local cbTitle2 = GetElement(self.m_root,"cbTitle2",WZUICheckBox)
	local conRedDot = GetElement(cbTitle2,"conRedDot",WZUIContainer)
	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[217144] or GlobalGame.g_tRedPointTypeList[227144]) then 
		conRedDot:setVisible(true)
	else
		conRedDot:setVisible(false)
	end
end

--@brief    更新购物车标题红点数量
function WndMysteriousShop:updateTitle4()
	local cbTitle4 = GetElement(self.m_root,"cbTitle4",WZUICheckBox)
	local conRedDot = GetElement(cbTitle4,"conRedDot",WZUIContainer)
	local txtRedDotNum = GetElement(cbTitle4,"txtRedDotNum",WZUILabelTTF)
	conRedDot:setVisible(#self.m_tM4CartData > 0)
	txtRedDotNum:setText(#self.m_tM4CartData)
end

--@brief    点击标题标签
function WndMysteriousShop:onClickTitle(element)
	local tag = element
	if type(element) ~= "number" then
		SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
		tag = element:getTag()
	end

	if tag == self.m_nTabIndex then
		return
	end

	self.m_nTabIndex = tag

	GetElement(self.m_root,"cbgTitleList",WZUICheckBoxGroup):setCheckIndex(self.m_nTabIndex - 1)
	for i=1,4 do
		GetElement(self.m_root,"conMain"..i,WZUIContainer):setVisible(self.m_nTabIndex == i)
	end
	self:updateUI()
end

--@brief    更新界面
function WndMysteriousShop:updateUI()
	if self.m_nTabIndex == 1 then
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 1, "")
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 4, "") --用来计算购物车数量
	elseif self.m_nTabIndex == 2 then
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 1)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 2)
	elseif self.m_nTabIndex == 3 then
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, "")
	elseif self.m_nTabIndex == 4 then
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 4, "")
	end
end


--@brief    更新界面1
function WndMysteriousShop:updateUIM1()
	self:updateM1RefreshTime()
	GetElement(self.m_root,"txtM1RefreshTime",WZUILabelTTF):enableSchedule("updateM1RefreshTime",1)

	local nLeftCount = self.m_tContent.goodsConfig[2] - self.m_nResetTimes
	GetElement(self.m_root,"txtM1LeftCount",WZUILabelTTF):setText(LocalStrings.KING_REST_TIMES..nLeftCount)
	
	self.m_tM1GiftsObj = {}
	local tcM1Gifts = GetElement(self.m_root,"tcM1Gifts",WZUITableContainer)
	tcM1Gifts:cleanTable()
	for i=1,#self.m_tM1GiftsData do
		local newElement, tNewObj = CellMysteriousShop1:createElement()
		newElement = WZUIContainer:luaTo(newElement)
		newElement:setTag(i-1)
		tNewObj:setData(self.m_tM1GiftsData[i])
		tcM1Gifts:setCellElement(newElement)
		table.insert(self.m_tM1GiftsObj,tNewObj)
	end
	if self.m_tM1ConPtY then
		tcM1Gifts:getMoveElement():setPositionY(self.m_tM1ConPtY)
		self.m_tM1ConPtY = nil
	else
		tcM1Gifts:getMoveElement():setPositionY(tcM1Gifts:getMinPosition().y)
	end
end

--@brief    更新界面4
function WndMysteriousShop:saveM1ConPt()
	local tcM1Gifts = GetElement(self.m_root,"tcM1Gifts",WZUITableContainer)
	self.m_tM1ConPtY = tcM1Gifts:getMoveElement():getPositionY()
end

--@brief    更新界面一刷新时间
function WndMysteriousShop:updateM1RefreshTime(element)
	local currentTimeStamp = SystemTime:getServerTime() --现在时间戳
	local localTimeZone = os.difftime(currentTimeStamp, os.time(os.date("!*t", currentTimeStamp))) --玩家所在的时区(秒)
	local serverTimeZone = SystemTime:getServerTimeZone() * 3600 --服务器所在的时区(秒)
	local dstTime = (os.date("*t", currentTimeStamp).isdst and -1 or 0) * 3600 --夏令时时差(秒)
	local diffTime = serverTimeZone - localTimeZone

	local year = os.date("%Y", (currentTimeStamp+diffTime+dstTime) )
	local month = os.date("%m", (currentTimeStamp+diffTime+dstTime) )
	local day = os.date("%d", (currentTimeStamp+diffTime+dstTime) )
	local hour = 0
	local min = 0
	local sec = 0
	local nEndTime = os.time({year = year,month = month,day = day,hour = hour,min = min,sec = sec}) - diffTime - dstTime + 86400

	local leftTime = nEndTime - currentTimeStamp
	local hour = math.floor(leftTime / 3600)
	local min = math.floor((leftTime % 3600) / 60)
	local sec = leftTime % 60

	GetElement(self.m_root,"txtM1RefreshTime",WZUILabelTTF):setText(LocalStrings.MAGIC_STONE_TEXT13 .. ": " .. hour .. ":" .. min .. ":" .. sec)
end

--@brief    点击"换一批"按钮
function WndMysteriousShop:onClickM1B1()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_nResetTimes >= self.m_tContent.goodsConfig[2] then
		MsgBoxManager:showTipBox(LocalStrings.MYSTERIOUS_SHOP_TEXT1[14])
		return
	end

	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 8, "")
end


--@brief    更新界面2
function WndMysteriousShop:updateUIM2T1()
	self.m_tM2TasksObj = {}
	local flcDailyTasks = GetElement(self.m_root,"flcDailyTasks",WZUIFreeListContainer)
	flcDailyTasks:removeAll()
	for i=1,#self.m_tM2TasksData do
		local newElement, tNewObj = CellMysteriousShop2:createElement()
		newElement = WZUIContainer:luaTo(newElement)
		newElement:setTag(i-1)
		tNewObj:setData(self.m_tM2TasksData[i])
		flcDailyTasks:pushBack(newElement)
		table.insert(self.m_tM2TasksObj,tNewObj)
	end
	if self.m_tM2ConPtY then
		flcDailyTasks:getMoveElement():setPositionY(self.m_tM2ConPtY)
		self.m_tM2ConPtY = nil
	else
		flcDailyTasks:getMoveElement():setPositionY(flcDailyTasks:getMinPosition().y)
	end
end

--@brief    更新界面4
function WndMysteriousShop:saveM2ConPt()
	local flcDailyTasks = GetElement(self.m_root,"flcDailyTasks",WZUIFreeListContainer)
	self.m_tM2ConPtY = flcDailyTasks:getMoveElement():getPositionY()
end

--@brief    更新界面2
function WndMysteriousShop:updateUIM2T2()
	local taskData = GDatatab_new_activity_task["id_" .. self.m_tM2SpecialTaskData.id]

	local ftbM2SpecialTask = GetElement(self.m_root,"ftbM2SpecialTask",WZUIFreeTextBox)
	ftbM2SpecialTask:setShowText(string.format(taskData.desc, self.m_tM2SpecialTaskData.progress.."/"..self.m_tM2SpecialTaskData.target))

	for i=1,4 do
		local conM2SpecialItem = GetElement(self.m_root,"conM2SpecialItem"..i,WZUIContainer)
		conM2SpecialItem:setVisible(false)
		local conM2SItem = GetElement(conM2SpecialItem,"conM2SItem",WZUIContainer)
		conM2SItem:removeAllChildrenWithCleanup(true)
		local txtM2SItem = GetElement(conM2SpecialItem,"txtM2SItem",WZUILabelTTF)
		txtM2SItem:setText("")
		if taskData.reward[i] then
			conM2SpecialItem:setVisible(true)

			local celElement,tNewObj = CellGoodItem:createElement()
			celElement:setTag(i - 1)
			tNewObj:setCellGoodLocalId(taskData.reward[i][1], taskData.reward[i][2], 15)
			if taskData.reward[i][2] == -1 then
				tNewObj:_addSidebarTime(taskData.reward[i][2])
			end
			tNewObj:setItemClickFun(self, self.onClickItem)
			conM2SItem:addChild(WZUIContainer:luaTo(celElement))

			txtM2SItem:setText(math.abs(taskData.reward[i][2]))
		end
	end

	self:updateSpecialTaskStatus()
end

--@brief    界面2特殊任务按钮状态
function WndMysteriousShop:updateSpecialTaskStatus()
	local btnM2SGet = GetElement(self.m_root,"btnM2SGet",WZUIButton)
	local imgM2SGet = GetElement(self.m_root,"imgM2SGet",WZUIImage)
	local txtM2SGet = GetElement(self.m_root,"txtM2SGet",WZUILabelTTF)
	if self.m_tM2SpecialTaskData.status == -1 then
		btnM2SGet:setTouchEnable(false)
		imgM2SGet:setGrayRender(true)
		txtM2SGet:setColor(GlobalMethod:ccc3(255,255,255))
		txtM2SGet:setStrokeColor(GlobalMethod:ccc3(79,60,48))
		txtM2SGet:setText(LocalStrings.ACTIVE_BTN_GET)
	elseif self.m_tM2SpecialTaskData.status == 0 then
		btnM2SGet:setTouchEnable(true)
		imgM2SGet:setGrayRender(false)
		txtM2SGet:setColor(GlobalMethod:ccc3(255,250,236))
		txtM2SGet:setStrokeColor(GlobalMethod:ccc3(0,108,3))
		txtM2SGet:setText(LocalStrings.ACTIVE_BTN_GET)
	elseif self.m_tM2SpecialTaskData.status == 1 then
		btnM2SGet:setTouchEnable(false)
		imgM2SGet:setGrayRender(true)
		txtM2SGet:setColor(GlobalMethod:ccc3(255,255,255))
		txtM2SGet:setStrokeColor(GlobalMethod:ccc3(79,60,48))
		txtM2SGet:setText(LocalStrings.ACTIVE_GET)
	end
end

--@brief    界面2点击领取完成所有任务的奖励
function WndMysteriousShop:onClickM2SGet()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ReceiveTaskReward(self.m_nActivityId, self.m_tM2SpecialTaskData.id)
end


--@brief    更新界面3
function WndMysteriousShop:updateUIM3()
	self:updateM3Time()
	GetElement(self.m_root,"txtM3Time",WZUILabelTTF):enableSchedule("updateM3Time",1)

	self.m_tM3GiftsObj = {}
	local tcM3Gifts = GetElement(self.m_root,"tcM3Gifts",WZUITableContainer)
	tcM3Gifts:cleanTable()
	for i=1,#self.m_tM3GiftsData do
		local newElement, tNewObj = CellMysteriousShop3:createElement()
		newElement = WZUIContainer:luaTo(newElement)
		newElement:setTag(i-1)
		tNewObj:setData(self.m_tM3GiftsData[i])
		tcM3Gifts:setCellElement(newElement)
		table.insert(self.m_tM3GiftsObj,tNewObj)
	end
	if self.m_tM3ConPtY then
		tcM3Gifts:getMoveElement():setPositionY(self.m_tM3ConPtY)
		self.m_tM3ConPtY = nil
	else
		tcM3Gifts:getMoveElement():setPositionY(tcM3Gifts:getMinPosition().y)
	end
end

--@brief    更新界面3
function WndMysteriousShop:saveM3ConPt()
	local tcM3Gifts = GetElement(self.m_root,"tcM3Gifts",WZUITableContainer)
	self.m_tM3ConPtY = tcM3Gifts:getMoveElement():getPositionY()
end

--@brief    更新界面三时间
function WndMysteriousShop:updateM3Time(element)
	local currentTimeStamp = SystemTime:getServerTime() --现在时间戳
	local nEndTime = self.m_nSecKillTime
	local strContent = LocalStrings.MYSTERIOUS_SHOP_TEXT1[16]
	if currentTimeStamp >= self.m_nSecKillTime then --秒杀倒计时
		local localTimeZone = os.difftime(currentTimeStamp, os.time(os.date("!*t", currentTimeStamp))) --玩家所在的时区(秒)
		local serverTimeZone = SystemTime:getServerTimeZone() * 3600 --服务器所在的时区(秒)
		local dstTime = (os.date("*t", currentTimeStamp).isdst and -1 or 0) * 3600 --夏令时时差(秒)
		local diffTime = serverTimeZone - localTimeZone

		local year = os.date("%Y", (currentTimeStamp+diffTime+dstTime) )
		local month = os.date("%m", (currentTimeStamp+diffTime+dstTime) )
		local day = os.date("%d", (currentTimeStamp+diffTime+dstTime) )
		local hour = 0
		local min = 0
		local sec = 0
		nEndTime = os.time({year = year,month = month,day = day,hour = hour,min = min,sec = sec}) - diffTime - dstTime + 86400

		strContent = LocalStrings.MYSTERIOUS_SHOP_TEXT1[15]
	end

	local leftTime = nEndTime - currentTimeStamp
	local hour = math.floor(leftTime / 3600)
	local min = math.floor((leftTime % 3600) / 60)
	local sec = leftTime % 60
	local strFormat = "%d:%02d:%02d"
	local strTime = strContent .. ": " .. string.format(strFormat, hour, min, sec)
	GetElement(self.m_root,"txtM3Time",WZUILabelTTF):setText(strTime)
end


--@brief    更新界面4
function WndMysteriousShop:updateUIM4()
	local itemInfo = GDatatab_item["id_"..self.m_tContent.goodsConfig[3]]
	GetElement(self.m_root,"imgM4Cost",WZUIImage):setFile(itemInfo.icon)

	--合计价格
	local totalOriginalPrice, totalDiscountPrice1, totalDiscountPrice2 = self:getM4Price()
	local imgM4Line = GetElement(self.m_root,"imgM4Line",WZUIImage)
	imgM4Line:setVisible(false)
	local txtM4DiscountPrice = GetElement(self.m_root,"txtM4DiscountPrice",WZUILabelTTF)
	txtM4DiscountPrice:setText("")
	local txtM4OriginalPrice = GetElement(self.m_root,"txtM4OriginalPrice",WZUILabelTTF)
	txtM4OriginalPrice:setText(totalOriginalPrice)
	if totalOriginalPrice ~= totalDiscountPrice2 then
		imgM4Line:setVisible(true)
		txtM4DiscountPrice:setText(totalDiscountPrice2)
	end

	--调整价格框
	local nFontWidth = 13 --单个字宽度
	local size1 = txtM4OriginalPrice:getLabelContentSize()
	local size2 = txtM4DiscountPrice:getLabelContentSize()

	local width = size1.width
	local height = 4
	local conM4Line = GetElement(self.m_root,"conM4Line",WZUIContainer)
	conM4Line:setAbsContentSize(CCSize(width, height))
	conM4Line:updateRelativeSize()

	local originX = 100
	local originY = 15
	local offsetX = math.max(0, size1.width - nFontWidth * 3)
	txtM4DiscountPrice:setAbsPosition(ccp(originX + offsetX, originY))

	local width = 150
	local height = 30
	local deltaWidth = math.max(0, size1.width + size2.width - nFontWidth * 3 * 2)
	local conM4Cost = GetElement(self.m_root,"conM4Cost",WZUIContainer)
	conM4Cost:setAbsContentSize(CCSize(width + deltaWidth, height))
	conM4Cost:updateRelativeSize()


	local strFormat = [[<T C="255,255,255" S="20" P="1">%s</T>]]
	local strContent = string.format(strFormat, LocalStrings.MYSTERIOUS_SHOP_TEXT1[22])
	if self.m_nCartDisItem ~= 0 then
		local itemInfo = GDatatab_item["id_"..self.m_nCartDisItem]
		strFormat = [[<I Z="0.5">%s</I><T C="255,255,255" S="20" P="1">%s</T>]]
		strContent = string.format(strFormat, itemInfo.icon, itemInfo.name)
	end
	local ftbM4Coupon = GetElement(self.m_root,"ftbM4Coupon",WZUIFreeTextBox)
	ftbM4Coupon:setShowText(strContent)

	self.m_tM4CartObj = {}
	local flcM4Gifts = GetElement(self.m_root,"flcM4Gifts",WZUIFreeListContainer)
	flcM4Gifts:removeAll()
	for i=1,#self.m_tM4CartData do
		local newElement, tNewObj = CellMysteriousShop4:createElement()
		newElement = WZUIContainer:luaTo(newElement)
		newElement:setTag(i-1)
		tNewObj:setData(self.m_tM4CartData[i])
		tNewObj:setCouponCallback(self, self.showCouponList)
		flcM4Gifts:pushBack(newElement)
		table.insert(self.m_tM4CartObj,tNewObj)
	end
	if self.m_tM4ConPtY then
		flcM4Gifts:getMoveElement():setPositionY(self.m_tM4ConPtY)
		self.m_tM4ConPtY = nil
	else
		flcM4Gifts:getMoveElement():setPositionY(flcM4Gifts:getMinPosition().y)
	end


	--全选按钮
	local orderIds = {}
	for i=1,#self.m_tM4CartData do
		if self.m_tM4CartData[i].option == 1 then
			table.insert(orderIds, self.m_tM4CartData[i].orderId)
		end
	end
	local nAllIndex = 0
	if #orderIds ~= 0 and #orderIds == #self.m_tM4CartData then
		nAllIndex = 1
	end
	local checkM4All = GetElement(self.m_root,"checkM4All",WZUICheckBox)
	checkM4All:setCheckIndex(nAllIndex)

	--选中数量
	local txtM4Desc2 = GetElement(self.m_root,"txtM4Desc2",WZUILabelTTF)
	txtM4Desc2:setText(string.format(LocalStrings.MYSTERIOUS_SHOP_TEXT1[21], #orderIds))
end

--@brief    更新界面4
function WndMysteriousShop:saveM4ConPt()
	local flcM4Gifts = GetElement(self.m_root,"flcM4Gifts",WZUIFreeListContainer)
	self.m_tM4ConPtY = flcM4Gifts:getMoveElement():getPositionY()
end

--@brief    获得"原价","使用折扣券的价格","使用折扣券和满减券的价格"
function WndMysteriousShop:getM4Price()
	local totalOriginalPrice = 0
	local totalDiscountPrice1 = 0
	local totalDiscountPrice2 = 0
	for i=1,#self.m_tM4CartData do
		if self.m_tM4CartData[i].option == 1 then
			totalOriginalPrice = totalOriginalPrice + self.m_tM4CartData[i].discountPrice * self.m_tM4CartData[i].shopCartNum

			local tempPrice = self.m_tM4CartData[i].discountPrice
			local discountData = GDatatab_item["id_"..self.m_tM4CartData[i].discountItem]
			if discountData then
				tempPrice = math.floor(self.m_tM4CartData[i].discountPrice / 100 * discountData.property[1][2])
			end
			totalDiscountPrice1 = totalDiscountPrice1 + tempPrice * self.m_tM4CartData[i].shopCartNum
		end
	end
	totalDiscountPrice2 = totalDiscountPrice1
	if self.m_nCartDisItem ~= 0 then
		local discountData = GDatatab_item["id_"..self.m_nCartDisItem]
		totalDiscountPrice2 = totalDiscountPrice2 - discountData.property[1][3]
	end
	return totalOriginalPrice, totalDiscountPrice1, totalDiscountPrice2
end

--@brief	获得可显示的优惠券
function WndMysteriousShop:getCouponIdList()
	local tCartData = self.m_tM4CartData[self.m_nM4CartIndex + 1]
	local tCouponIdList = {}
	for i=1,#self.m_tCouponIds1 do
		if self.m_tCouponIds1[i] == tCartData.discountItem then
			table.insert(tCouponIdList, self.m_tCouponIds1[i])
		else
			local nCouponNum = CacheCenter:getPlayerItemCountById(self.m_tCouponIds1[i])
			if nCouponNum > 0 then
				for j=1,#self.m_tM4CartData do
					if self.m_tM4CartData[j].discountItem == self.m_tCouponIds1[i] then
						nCouponNum = nCouponNum - 1
					end
				end
			end
			if nCouponNum > 0 then
				table.insert(tCouponIdList, self.m_tCouponIds1[i])
			end
		end
	end
	return tCouponIdList
end

--@brief	显示优惠券列表
function WndMysteriousShop:showCouponList(tag)
	self.m_nM4CartIndex = tag
	local tCelData = self.m_tM4CartData[tag+1]
	local tCelObj = self.m_tM4CartObj[tag+1]

	local conM4CouponPop = GetElement(self.m_root,"conM4CouponPop",WZUIContainer)
	local visible = conM4CouponPop:isVisible()
	conM4CouponPop:setVisible(not visible)

	local imgCouponArrow = GetElement(tCelObj.m_root,"imgCouponArrow_cellM4Tasks",WZUIImage)
	imgCouponArrow:setFlipY(visible)

	if visible == false then
		local flcM4Gifts = GetElement(self.m_root,"flcM4Gifts",WZUIFreeListContainer)
		local posX = flcM4Gifts:getMoveElement():getPositionX()
		local nIndex = tag + 1
		local nRowNum = flcM4Gifts:size()
		local posY = flcM4Gifts:getMoveElement():getPositionY() - flcM4Gifts:getMinPosition().y + (flcM4Gifts:getContentSize().height - (flcM4Gifts:getMoveElement():getContentSize().height / nRowNum / 2) * (nIndex * 2 - 1))
		posX = posX + 192.5
		posY = posY - 35
		conM4CouponPop:setAbsPosition(GlobalMethod:ccp(posX, posY))

		--可用优惠券
		local tCouponIdList = self:getCouponIdList()
		local count = #tCouponIdList
		local width = 234
		local height = 35
		conM4CouponPop:setAbsContentSize(GlobalMethod:CCSize(width, height*(count+1)))
		conM4CouponPop:updateRelativeSize()

		local conM4WCList = GetElement(self.m_root,"conM4WCList",WZUIContainer)
		conM4WCList:removeAllChildrenWithCleanup(true)
		for i=0,#tCouponIdList do
			local conP = WZUIContainer:create()
			conP:setUseAbsSize(true)
			conP:setAbsContentSize(GlobalMethod:CCSize(width,height))
			conP:setRelativePosition(GlobalMethod:ccp(0.5, 0.5-i))
			conM4WCList:addChild(conP)

			local tempIndex = tCouponIdList[i] or 0

			local btnC = WZUIButton:create()
			btnC:setLuaDoneFunctionName("onClickUseCoupon")
			btnC:setTag(tempIndex)
			conP:addChild(btnC, 2)

			local strFormat = [[<T C="19,62,111" S="20" P="1">%s</T>]]
			if tCelData.discountItem == tempIndex then
				strFormat = [[<T C="255,255,255" S="20" P="1">%s</T>]]
			end
			local strContent = string.format(strFormat, LocalStrings.MYSTERIOUS_SHOP_TEXT1[22])
			if i ~= 0 then
				local conF = WZUIContainer:create()
				conF:setUseAbsSize(true)
				conF:setAbsContentSize(GlobalMethod:CCSize(214,3))
				conF:setRelativePosition(GlobalMethod:ccp(0.5, 1))
				conP:addChild(conF)
				local imgF = WZUI9Image:create()
				imgF:setFile("ui/common/frame_fengexian_01.png")
				conF:addChild(imgF)

				local itemInfo = GDatatab_item["id_"..tCouponIdList[i]]
				strFormat = [[<I Z="0.5">%s</I><T C="19,62,111" S="20" P="1">%s</T>]]
				if tCelData.discountItem == tempIndex then
					strFormat = [[<I Z="0.5">%s</I><T C="255,255,255" S="20" P="1">%s</T>]]
				end
				strContent = string.format(strFormat, itemInfo.icon, itemInfo.name)
			end

			local ftbC = WZUIFreeTextBox:create()
			ftbC:setMaxWidth(500)
			ftbC:setShowText(strContent)
			ftbC:setAnchorPoint(ccp(0, 0.5))
			ftbC:setRelativePosition(ccp(0.05, 0.5))
			conP:addChild(ftbC)

			if ProjConfig.LANGUAGE == "vn" then
				ftbC:setScale(0.7)
			end
		end
	end
end

--@brief	点击优惠券
function WndMysteriousShop:onClickUseCoupon(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	GetElement(self.m_root,"conM4CouponPop",WZUIContainer):setVisible(false)
	local tCelObj = self.m_tM4CartObj[self.m_nM4CartIndex+1]
	local imgCouponArrow = GetElement(tCelObj.m_root,"imgCouponArrow_cellM4Tasks",WZUIImage)
	imgCouponArrow:setFlipY(true)

	local tag = element:getTag()
	local tCartData = self.m_tM4CartData[self.m_nM4CartIndex + 1]
	if tCartData.discountItem == tag then
		return
	end

	self:saveM4ConPt()

	local tData = {}
	tData.orderId = tCartData.orderId
	tData.itemId = tag
	local strJson = json.encode(tData)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 6, strJson)
end


--@brief	获得可显示的优惠券
function WndMysteriousShop:getCouponId2List()
	local totalOriginalPrice, totalDiscountPrice1, totalDiscountPrice2 = self:getM4Price()
	local tCouponId2List = {}
	for i=1,#self.m_tCouponIds2 do
		if self.m_tCouponIds2[i] == self.m_nCartDisItem then
			table.insert(tCouponId2List, self.m_tCouponIds2[i])
		else
			local nCouponNum = CacheCenter:getPlayerItemCountById(self.m_tCouponIds2[i])
			if nCouponNum > 0 then
				local discountData = GDatatab_item["id_"..self.m_tCouponIds2[i]]
				if totalDiscountPrice1 > discountData.property[1][2] then
					table.insert(tCouponId2List, self.m_tCouponIds2[i])
				end
			end
		end
	end
	return tCouponId2List
end

--@brief	点击满减券列表
function WndMysteriousShop:onClickM4Coupon(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local conM4CListW1 = GetElement(self.m_root,"conM4CListW1",WZUIContainer)
	local visible = conM4CListW1:isVisible()
	conM4CListW1:setVisible(not visible)
	local imgM4CouponArrow = GetElement(self.m_root,"imgM4CouponArrow",WZUIImage)
	imgM4CouponArrow:setFlipY(not visible)

	--可用优惠券
	local tCouponId2List = self:getCouponId2List()

	local count = #tCouponId2List
	local width = 234
	local height = 35
	conM4CListW1:setAbsContentSize(GlobalMethod:CCSize(width, height*(count+1)))
	conM4CListW1:updateRelativeSize()

	local conM4CListW2 = GetElement(self.m_root,"conM4CListW2",WZUIContainer)
	conM4CListW2:removeAllChildrenWithCleanup(true)
	for i=0,#tCouponId2List do
		local conP = WZUIContainer:create()
		conP:setUseAbsSize(true)
		conP:setAbsContentSize(GlobalMethod:CCSize(width,height))
		conP:setRelativePosition(GlobalMethod:ccp(0.5, 0.5+i))
		conM4CListW2:addChild(conP)

		local tempIndex = tCouponId2List[i] or 0

		local btnC = WZUIButton:create()
		btnC:setLuaDoneFunctionName("onClickM4UseCoupon")
		btnC:setTag(tempIndex)
		conP:addChild(btnC, 2)

		local strFormat = [[<T C="19,62,111" S="20" P="1">%s</T>]]
		if self.m_nCartDisItem == tempIndex then
			strFormat = [[<T C="255,255,255" S="20" P="1">%s</T>]]
		end
		local strContent = string.format(strFormat, LocalStrings.MYSTERIOUS_SHOP_TEXT1[22])
		if i ~= 0 then
			local conF = WZUIContainer:create()
			conF:setUseAbsSize(true)
			conF:setAbsContentSize(GlobalMethod:CCSize(214,3))
			conF:setRelativePosition(GlobalMethod:ccp(0.5, 1))
			conP:addChild(conF)
			local imgF = WZUI9Image:create()
			imgF:setFile("ui/common/frame_fengexian_01.png")
			conF:addChild(imgF)

			local itemInfo = GDatatab_item["id_"..tCouponId2List[i]]
			strFormat = [[<I Z="0.5">%s</I><T C="19,62,111" S="20" P="1">%s</T>]]
			if self.m_nCartDisItem == tempIndex then
				strFormat = [[<I Z="0.5">%s</I><T C="255,255,255" S="20" P="1">%s</T>]]
			end
			strContent = string.format(strFormat, itemInfo.icon, itemInfo.name)
		end

		local ftbC = WZUIFreeTextBox:create()
		ftbC:setMaxWidth(500)
		ftbC:setShowText(strContent)
		ftbC:setAnchorPoint(ccp(0, 0.5))
		ftbC:setRelativePosition(ccp(0.05, 0.5))
		conP:addChild(ftbC)

		if ProjConfig.LANGUAGE == "vn" then
			ftbC:setScale(0.7)
		end
	end
end

--@brief	点击优惠券
function WndMysteriousShop:onClickM4UseCoupon(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	GetElement(self.m_root,"conM4CListW1",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"imgM4CouponArrow",WZUIImage):setFlipY(false)

	local tag = element:getTag()
	if self.m_nCartDisItem == tag then
		return
	end

	local tData = {}
	tData.orderId = -1
	tData.itemId = tag
	local strJson = json.encode(tData)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 6, strJson)
end

--@brief	点击全选
function WndMysteriousShop:onClickCheckAll(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	self:saveM4ConPt()

	local checkM4All = GetElement(self.m_root,"checkM4All",WZUICheckBox)
	local nIndex = checkM4All:getCheckIndex()

	local orderIds = {}
	for i=1,#self.m_tM4CartData do
		if self.m_tM4CartData[i].option == 1-nIndex then
			table.insert(orderIds, self.m_tM4CartData[i].orderId)
		end
	end

	if #orderIds == 0 then
		return
	end

	local tData = {}
	tData.orderId = orderIds
	tData.option = nIndex
	local strJson = json.encode(tData)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 7, strJson)
end

--@brief	点击结算
function WndMysteriousShop:onClickM4Buy(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local orderIds = {}
	local orderNums = {}
	for i=1,#self.m_tM4CartData do
		if self.m_tM4CartData[i].option == 1 then
			table.insert(orderIds, self.m_tM4CartData[i].orderId)
			table.insert(orderNums, self.m_tM4CartData[i].shopCartNum)
		end
	end

	if #orderIds <= 0 then
		MsgBoxManager:showTipBox(LocalStrings.MYSTERIOUS_SHOP_TEXT1[25])
		return
	end


	--购物卡不足
	local nCoinNum = CacheCenter:getPlayerItemCountById(self.m_tContent.goodsConfig[3])
	local totalOriginalPrice, totalDiscountPrice1, totalDiscountPrice2 = self:getM4Price()
	if nCoinNum < totalDiscountPrice2 then
		local itemInfo = GDatatab_item["id_"..self.m_tContent.goodsConfig[3]]
		MsgBoxManager:showConfirmBox(string.format(LocalStrings.WATERCOUNTRY_TEXT4, itemInfo.name), self, self.goToBuy)
		return
	end

	local tData = {}
	tData.orderId = orderIds
	tData.nums = orderNums
	local strJson = json.encode(tData)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 10, strJson)
end

--@brief 	前往小推车购买
function WndMysteriousShop:goToBuy(nId, nResType)
	if nResType == MSGBOXRESTYPE_CONFIRM then
		-- WndActivityPropsGift:showInterface(self.m_tContent.goodsConfig[3])
        WndApartmentAct:showInterface()
	end
end

--@brief	打开我的优惠券
function WndMysteriousShop:onClickMyCoupon(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local tM5CouponIdData = {}
	local tM5CouponNumData = {}
	for i=1,#self.m_tCouponIds1 do
		local nCouponNum = CacheCenter:getPlayerItemCountById(self.m_tCouponIds1[i])
		if nCouponNum > 0 then
			table.insert(tM5CouponIdData, self.m_tCouponIds1[i])
			table.insert(tM5CouponNumData, nCouponNum)
		end
	end
	for i=1,#self.m_tCouponIds2 do
		local nCouponNum = CacheCenter:getPlayerItemCountById(self.m_tCouponIds2[i])
		if nCouponNum > 0 then
			table.insert(tM5CouponIdData, self.m_tCouponIds2[i])
			table.insert(tM5CouponNumData, nCouponNum)
		end
	end

	self.m_tM5CartCell = {}
	local flcMyCoupon = GetElement(self.m_root,"flcMyCoupon",WZUIFreeListContainer)
	flcMyCoupon:removeAll()
	for i=1,#tM5CouponIdData do
		local itemInfo = GDatatab_item["id_"..tM5CouponIdData[i]]

		local cellMysteriousShop5 = WZUISystem:getInstance():createElement("CellMysteriousShop5")
		cellMysteriousShop5 = WZUIContainer:luaTo(cellMysteriousShop5)

		local conItem = GetElement(cellMysteriousShop5,"conItem_CellMysteriousShop5",WZUIContainer)
		conItem:removeAllChildrenWithCleanup(true)
		local celElement,tNewObj = CellGoodItem:createElement()
		celElement = WZUIContainer:luaTo(celElement)
		tNewObj:setCellGoodLocalId(tM5CouponIdData[i], tM5CouponNumData[i], 15)
		tNewObj:setItemClickFun(self, self.onClickItem)
		conItem:addChild(celElement)

		GetElement(cellMysteriousShop5,"txtItemName_CellMysteriousShop5",WZUILabelTTF):setText(itemInfo.name)

		GetElement(cellMysteriousShop5,"txtItemNum_CellMysteriousShop5",WZUILabelTTF):setText(LocalStrings.MYSTERIOUS_SHOP_TEXT1[23]..":"..tM5CouponNumData[i])

		flcMyCoupon:pushBack(cellMysteriousShop5)
		table.insert(self.m_tM5CartCell, cellMysteriousShop5)
	end
	flcMyCoupon:getMoveElement():setPositionY(flcMyCoupon:getMinPosition().y)

	GetElement(self.m_root,"conMyCoupon",WZUIContainer):setVisible(true)
end

--@brief	关闭我的优惠券
function WndMysteriousShop:onClickMyCClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	GetElement(self.m_root,"conMyCoupon",WZUIContainer):setVisible(false)
end


--@brief	点击物品弹出对应的tips
function WndMysteriousShop:onClickItem(tCell,tag,tData)
    if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData,false)
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief    初始化静态文本
function WndMysteriousShop:_initStaticText()
	local strContentList = {LocalStrings.MYSTERIOUS_SHOP_TEXT1[2], LocalStrings.MYSTERIOUS_SHOP_TEXT1[3], LocalStrings.MYSTERIOUS_SHOP_TEXT1[4], LocalStrings.MYSTERIOUS_SHOP_TEXT1[5]}
	for i=1,4 do
		local cbTitle = GetElement(self.m_root,"cbTitle"..i,WZUICheckBox)
		local txtTitleNor = GetElement(cbTitle,"txtTitleNor",WZUILabelTTF)
		local txtTitleSel = GetElement(cbTitle,"txtTitleSel",WZUILabelTTF)
		txtTitleNor:setText(strContentList[i])
		txtTitleSel:setText(strContentList[i])
	end

	GetElement(self.m_root,"txtM1Talk",WZUILabelTTF):setText(LocalStrings.MYSTERIOUS_SHOP_TEXT1[6])
	GetElement(self.m_root,"txtM2Talk",WZUILabelTTF):setText(LocalStrings.MYSTERIOUS_SHOP_TEXT1[6])
	GetElement(self.m_root,"txtM3Talk",WZUILabelTTF):setText(LocalStrings.MYSTERIOUS_SHOP_TEXT1[6])
	GetElement(self.m_root,"txtM1B1",WZUILabelTTF):setText(LocalStrings.MASTERINFO25)
	GetElement(self.m_root,"txtM2DailyTaskWord",WZUILabelTTF):setText(LocalStrings.MYSTERIOUS_SHOP_TEXT1[3])
	GetElement(self.m_root,"txtM4Desc1",WZUILabelTTF):setText(LocalStrings.MYSTERIOUS_SHOP_TEXT1[7])
	GetElement(self.m_root,"txtM4Desc3",WZUILabelTTF):setText(LocalStrings.MYSTERIOUS_SHOP_TEXT1[8])
	GetElement(self.m_root,"txtM4B1",WZUILabelTTF):setText(LocalStrings.MYSTERIOUS_SHOP_TEXT1[9])
	GetElement(self.m_root,"txtM4B2",WZUILabelTTF):setText(LocalStrings.MYSTERIOUS_SHOP_TEXT1[10])
	GetElement(self.m_root,"txtMyCTitle",WZUILabelTTF):setText(LocalStrings.MYSTERIOUS_SHOP_TEXT1[9])

end




-------------------------------------私有方法模块End----------------------------------------


--@brief	语言适配
function WndMysteriousShop:_adaptLanguage_vn()
	for i=1,4 do
		local cbTitle = GetElement(self.m_root,"cbTitle"..i,WZUICheckBox)
		local txtTitleNor = GetElement(cbTitle,"txtTitleNor",WZUILabelTTF)
		local txtTitleSel = GetElement(cbTitle,"txtTitleSel",WZUILabelTTF)
		txtTitleNor:setScale(0.8)
		txtTitleSel:setScale(0.8)
	end

	local txtM1Talk = GetElement(self.m_root,"txtM1Talk",WZUILabelTTF)
	txtM1Talk:setRelativePosition(GlobalMethod:ccp(0.09,0.66))
	txtM1Talk:setScale(0.75)
	txtM1Talk:setDimensions(GlobalMethod:CCSize(180,0))
	local txtM2Talk = GetElement(self.m_root,"txtM2Talk",WZUILabelTTF)
	txtM2Talk:setRelativePosition(GlobalMethod:ccp(0.09,0.66))
	txtM2Talk:setScale(0.75)
	txtM2Talk:setDimensions(GlobalMethod:CCSize(180,0))
	local txtM3Talk = GetElement(self.m_root,"txtM3Talk",WZUILabelTTF)
	txtM3Talk:setRelativePosition(GlobalMethod:ccp(0.09,0.66))
	txtM3Talk:setScale(0.75)
	txtM3Talk:setDimensions(GlobalMethod:CCSize(180,0))

	GetElement(self.m_root,"txtM2DailyTaskWord",WZUILabelTTF):setFontSize(16)

	GetElement(self.m_root,"txtM4Desc1",WZUILabelTTF):setFontSize(16)
	GetElement(self.m_root,"txtM4B1",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtM4Desc3",WZUILabelTTF):setVisible(false)

	GetElement(self.m_root,"ftbM4Coupon",WZUIFreeTextBox):setScale(0.7)
end