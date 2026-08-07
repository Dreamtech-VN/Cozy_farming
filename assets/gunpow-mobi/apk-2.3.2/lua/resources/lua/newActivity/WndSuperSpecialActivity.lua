--WndSuperSpecialActivity.lua
--@brief	WndSuperSpecialActivity的UI模块
--@date		2023/04/12
--@author	yrd
--@note		超值特购活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSuperSpecialActivity:onEnter(element)
	self.m_root = element

	ProtocolProcessorFestivalActivity:regAll6()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self.getActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetRewardRiseResult,self)

	self:sendActivityInfoProtolcol()

	self:_initStaticText()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSuperSpecialActivity:onExit(element)
	ProtocolProcessorFestivalActivity:unregAll6()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self.getActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetRewardRiseResult,self)

	self:_unInit()
	LoadNewActivityRes(false)
end

function WndSuperSpecialActivity:sendActivityInfoProtolcol()
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7073, 7073)
end

--@brief	外部接口
function WndSuperSpecialActivity:showInterface()
	LoadNewActivityRes(true)
	local wnd = WndSuperSpecialActivity:createElement()
	if wnd ~= nil then
	    WindowManager:addWindow(wnd, WndSuperSpecialActivity, nil, false)
	end
end

--@brief	点击关闭
function WndSuperSpecialActivity:onClickClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	初始化静态文本
function WndSuperSpecialActivity:_initStaticText()
	local btnBuy = GetElement(self.m_root,"btnBuy_WndSuperSpecialActivity",WZUIButton)
	btnBuy:setTouchEnable(false)
	local txtBtnBuy1 = GetElement(self.m_root,"txtBtnBuy1_WndSuperSpecialActivity",WZUILabelTTF)
	local txtBtnBuy2 = GetElement(self.m_root,"txtBtnBuy2_WndSuperSpecialActivity",WZUILabelTTF)
	local txtBtnBuy3 = GetElement(self.m_root,"txtBtnBuy3_WndSuperSpecialActivity",WZUILabelTTF)
	txtBtnBuy1:setText(LocalStrings.BOUGHT)
	txtBtnBuy2:setText(LocalStrings.BOUGHT)
	txtBtnBuy3:setText(LocalStrings.BOUGHT)

	local txtActivityDesc = GetElement(self.m_root,"txtActivityDesc_WndSuperSpecialActivity",WZUILabelTTF)
	txtActivityDesc:setText(LocalStrings.SUPER_SELL_ACTIVITY[3])
end

--@brief    更新活动时间
function WndSuperSpecialActivity:_updateActivityTime()
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndSuperSpecialActivity", WZUILabelTTF)
    local strTimeWord = LocalStrings.ACTIVE_TIME .. ": %d.%02d.%02d %02d:%02d-%02d.%02d %02d:%02d"
    local startDate = os.date("*t", self.startTime)
    local endDate = os.date("*t", self.endTime)
    txtActivityTime:setText(string.format(strTimeWord, startDate.year, startDate.month, startDate.day, startDate.hour, startDate.min, endDate.month, endDate.day, endDate.hour, endDate.min))
end

--@brief    开启计时器
function WndSuperSpecialActivity:startTimer()
	local btnBuy = GetElement(self.m_root,"btnBuy_WndSuperSpecialActivity",WZUIButton)
	btnBuy:disableSchedule()
	btnBuy:enableSchedule("scheduleTime",1)
end

--@brief    更新计时器
function WndSuperSpecialActivity:scheduleTime(element, dt)
	if os.date("*t", self.refreshTime).day ~= os.date("*t", SystemTime:getServerTime()).day then
		self:sendActivityInfoProtolcol()
		-- local btnBuy = GetElement(self.m_root,"btnBuy_WndSuperSpecialActivity",WZUIButton)
		-- btnBuy:disableSchedule()
	end
end

--@brief    更新界面
function WndSuperSpecialActivity:updateUI()
	local conAllReward = GetElement(self.m_root,"conAllReward_WndSuperSpecialActivity",WZUIContainer)
	conAllReward:setRelativePosition(GlobalMethod:ccp(0.67+(5-self.giftSize[1])*0.0635,0.3))
	for i=1,5 do
		local conReward = GetElement(self.m_root,"conReward"..i.."_WndSuperSpecialActivity",WZUIContainer)
		if i <= self.giftSize[1] then
			conReward:setVisible(true)

			local conItem = GetElement(conReward,"conItem_WndSuperSpecialActivity",WZUIContainer)
			local celElement, tNewObj = CellGoodItem:createElement()
			celElement:setTag(i - 1)
			celElement:setScale(0.9)
			tNewObj:setCellGoodLocalId(self.giftItemId[i], self.giftItemNum[i], 15)
			tNewObj:setItemClickFun(self, self.onClickItem)
			conItem:addChild(celElement)

			local txtNum = GetElement(conReward,"txtNum_WndSuperSpecialActivity",WZUILabelTTF)
			txtNum:setText(self.giftItemNum[i])
		else
			conReward:setVisible(false)

			local conItem = GetElement(conReward,"conItem_WndSuperSpecialActivity",WZUIContainer)
			conItem:removeAllChildrenWithCleanup(true)

			local txtNum = GetElement(conReward,"txtNum_WndSuperSpecialActivity",WZUILabelTTF)
			txtNum:setText("")
		end
	end

	self:updateBuyBtn()
end

--@brief	更新购买按钮
function WndSuperSpecialActivity:updateBuyBtn(element)
	local btnBuy = GetElement(self.m_root,"btnBuy_WndSuperSpecialActivity",WZUIButton)
	local txtBtnBuy1 = GetElement(self.m_root,"txtBtnBuy1_WndSuperSpecialActivity",WZUILabelTTF)
	local txtBtnBuy2 = GetElement(self.m_root,"txtBtnBuy2_WndSuperSpecialActivity",WZUILabelTTF)
	local txtBtnBuy3 = GetElement(self.m_root,"txtBtnBuy3_WndSuperSpecialActivity",WZUILabelTTF)
	if self.giftBuyCount[1] < self.giftBuyLimit[1] then
		btnBuy:setTouchEnable(true)
		txtBtnBuy1:setText(LocalStrings.SUPER_SELL_ACTIVITY[2])
		txtBtnBuy2:setText(LocalStrings.SUPER_SELL_ACTIVITY[2])
		txtBtnBuy3:setText(LocalStrings.SUPER_SELL_ACTIVITY[2])
	else
		btnBuy:setTouchEnable(false)
		txtBtnBuy1:setText(LocalStrings.BOUGHT)
		txtBtnBuy2:setText(LocalStrings.BOUGHT)
		txtBtnBuy3:setText(LocalStrings.BOUGHT)
	end
end

--@brief	点击物品
function WndSuperSpecialActivity:onClickItem(tCell, tag, tData)
	WndItemInfo:showInfo(tCell.m_root, self.m_root, 1, tData, false)
end

--@brief	点击购买
function WndSuperSpecialActivity:onClickBuy()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local rechargeId
	for i, value in pairs(GDatatab_recharge) do
		if value.sort == self.rechargeSort[1] and value.type == self.rechargeType[1] then 
			rechargeId = value.id
		end
	end

	if rechargeId then
		local activityId = g_cityExtenInfo.activity7073
		local doType = 2
		local sjson = {}
		sjson.refreshTime = self.refreshTime
		sjson.giftId = 0
		sjson.rechargeId = rechargeId
		sjson = json.encode(sjson)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(activityId, doType, sjson )
	end
end

--@brief 	下订单
function WndSuperSpecialActivity:gotoBuy(rechargeId)
	--购买
	local sdkData = {}
    local vipData = GDatatab_recharge["id_" .. rechargeId]
    sdkData.id = rechargeId
    sdkData.price = vipData.price
    sdkData.productName = tostring(vipData.name)
    sdkData.payCode = GetPayCodeIdByChannelId(vipData)
    sdkData.quantifier = LocalStrings.SHOP_IND
    sdkData.number = "1"
    sdkData.giftNumber = "0"
    sdkData.productDesc = tostring(vipData.name)

    PassportSdkManager:getOrderNum(sdkData)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
