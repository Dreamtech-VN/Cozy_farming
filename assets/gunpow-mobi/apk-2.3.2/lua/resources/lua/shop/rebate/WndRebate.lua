--WndRebate.lua
--@brief	WndRebate的UI模块
--@date		2017/09/19
--@author	zsq
--@note		回扣商店


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndRebate:onEnter(element)
	self.m_root = element
	CacheCenter:registerUpateMoneyObserver(tObserver)
end

function WndRebate:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)

	--每日限购倒计时
	self.m_root:enableSchedule("_countDown",1)

	ProtocolProcessorWndShop:send_MALL_GetDiscountStore( )
end

--@brief    弹窗动画完成后的回调
function WndRebate:actionCallback(element, data)
	WZLog("WndRebate:actionCallback")
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndRebate:onExit(element)
	CacheCenter:unregisterUpateMoneyObserver(tObserver)
	self:_unInit()
end

--@brief	关闭窗口
function WndRebate:onClose(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	弹出黑店界面
function WndRebate:show()
	local wnd = WndRebate:createElement()
   	WindowManager:addWindow(wnd, WndRebate, false)
end

function WndRebate:updateMoneyData() 
	self:setMoney()
end

function WndRebate:setMoney() 
	local tData = CacheCenter:getMoneyList()
	GetElement(self.m_root,"txtDiamond_WndRebate",WZUILabelTTF):setText(tData.blueDiamond)
	GetElement(self.m_root,"txtTicket_WndRebate",WZUILabelTTF):setText(tData.ticket)
end

function WndRebate:_countDown() 
	if self.m_root == nil then return end

	if self.leftTime == nil then self.leftTime = 86400 end
	self.leftTime = self.leftTime - 1
	--倒计时完刷新商品
	if self.leftTime < 0 then
		self.leftTime = 86400
		ProtocolProcessorWndShop:send_MALL_GetDiscountStore( )
	end

	local left = self.leftTime
	GetElement(self.m_root,"txtCountDown",WZUILabelTTF):setText(utilsFormatTime(left))
end

--贿赂
function WndRebate:onRebate(element) 
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local n = 0
	for i=1,#self.m_tDataList do
		if self.m_tDataList[i].leftNum > 0 then
			n = n + 1
		end
	end
	if n < 5 then
		MsgBoxManager:showTipBox(LocalStrings.REBATE7)
		return
	end

	local briberyCost = CacheCenter:getGameParam().briberyCost
	local costId, costNum = SplitItemString(briberyCost)
	if not JudgeMoneyIsEnough(tonumber(costId[1]), tonumber(costNum[1]), nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.onRebate1) then 
		return 
	end
	self:onRebate1()
end

function WndRebate:onRebate1() 
	local briberyCost = CacheCenter:getGameParam().briberyCost
	local discountRange = CacheCenter:getGameParam().discountRange
	local costId, costNum = SplitItemString(briberyCost)
	local discountValue1, discountValue2 = SplitItemString(discountRange)
	local msg1 = string.format(LocalStrings.REBATE6, tostring(costNum[1]), discountValue1[1], discountValue2[2])	
	MsgBoxManager:showConfirmBoxWithBg(msg1, self, self.onRebateConfirm, MSGBOXLEVEL_HIGH, {[MSGBOXUICFG_USEFREETXT] = true})
end

function WndRebate:onRebateConfirm()
	WZLog("WndRebate:onRebateConfirm")
	ProtocolProcessorWndShop:send_MALL_DiscountStoreBribery()
end

--刷新
function WndRebate:onRefresh(element) 
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local discountStoreRefreshCost = CacheCenter:getGameParam().discountStoreRefreshCost
	local costId, costNum = SplitItemString(discountStoreRefreshCost)

	if not JudgeMoneyIsEnough(tonumber(costId[1]), tonumber(costNum[1]), nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.onRefresh1) then 
		return 
	end
	self:onRefresh1()
end

function WndRebate:onRefresh1() 
	local tip = false
	for i=1,#self.m_tDataList do
		if self.m_tDataList[i].discount ~= 0 and self.m_tDataList[i].leftNum > 0 then
			tip = true
			break
		end
	end

	local discountStoreRefreshCost = CacheCenter:getGameParam().discountStoreRefreshCost
	local costId, costNum = SplitItemString(discountStoreRefreshCost)
	
	if tip then
		local msg1 = string.format(LocalStrings.REBATE8, tostring(costNum[1]))	
    	MsgBoxManager:showConfirmCancelBox(msg1, self, self.onRefreshConfirm, MSGBOXLEVEL_NORMAL, nil)
	else
		ProtocolProcessorWndShop:send_MALL_DiscountStoreRefresh( )
	end
end

function WndRebate:onRefreshConfirm(nId, nResType)
	WZLog("WndRebate:onRefreshConfirm")
	if nResType == MSGBOXRESTYPE_CONFIRM then
		ProtocolProcessorWndShop:send_MALL_DiscountStoreRefresh( )
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndRebate:_update() 
	if self.m_root == nil then return end 
	local tbCon = GetElement(self.m_root,"tbCon_WndRebate",WZUITableContainer)
	tbCon:cleanTable()

	--没有数据时显示提示
	if self.m_tDataList == nil or #self.m_tDataList == 0 then 
		do return end
	end
	


	for i=1,#self.m_tDataList do
		local celElement,tCell = CellRebate:createElement()
		if celElement ~= nil and tCell ~= nil then 
			celElement = WZUIContainer:luaTo(celElement)
			tCell:setData(self.m_tDataList[i])
			celElement:setTag(i-1)
			tbCon:setCellElement(celElement)
		end 
	end

	--活动时间
	if self.startDateStr ~= nil and self.endDateStr ~= nil then
		local startDateStr = SplitStringWithSeparator(self.startDateStr,"-")
		local endDateStr = SplitStringWithSeparator(self.endDateStr,"-")
		local date = string.format(LocalStrings.ACTIVITY_TIMELINE_KEY, tonumber(startDateStr[1]), tonumber(startDateStr[2]), tonumber(endDateStr[1]), tonumber(endDateStr[2]))
		GetElement(self.m_root,"txtDate",WZUILabelTTF):setText(date)
	end
	--贿赂消耗
	local briberyCost = CacheCenter:getGameParam().briberyCost
	local costId, costNum = SplitItemString(briberyCost)
	GetElement(self.m_root,"imgCost",WZUIImage):setFile(GDatatab_item["id_"..costId[1]].icon)
	GetElement(self.m_root,"imgCost1",WZUIImage):setFile(GDatatab_item["id_"..costId[1]].icon)
	GetElement(self.m_root,"txtCostBtn",WZUILabelTTF):setText(costNum[1])
	GetElement(self.m_root,"txtCostBtn1",WZUILabelTTF):setText(costNum[1])
	--刷新消耗
	local discountStoreRefreshCost = CacheCenter:getGameParam().discountStoreRefreshCost
	local costId, costNum = SplitItemString(discountStoreRefreshCost)
	GetElement(self.m_root,"txtCostCount_WndRebate",WZUILabelTTF):setText(costNum[1])

	self:setMoney()

	GetElement(self.m_root,"tip1",WZUILabelTTF):setText(string.format(LocalStrings.EVERYDAY_REFRESH_TIME, "00:00:00"))

	--贿赂状态
	if self.status == 0 then
		GetElement(self.m_root,"btnRebate",WZUIButton):setTouchEnable(true)
		GetElement(self.m_root,"txtRebate",WZUILabelTTF):setText(LocalStrings.REBATE1)
		
		local n = 0
		for i=1,#self.m_tDataList do
			if self.m_tDataList[i].leftNum > 0 then
				n = n + 1
			end
		end
		if n < 5 then
			GetElement(self.m_root,"txtRebate",WZUILabelTTF):setText(LocalStrings.REBATE9)
			return
		end
	elseif self.status == 1 then
		GetElement(self.m_root,"btnRebate",WZUIButton):setTouchEnable(false)
		GetElement(self.m_root,"txtRebate",WZUILabelTTF):setText(LocalStrings.REBATE4)
	end

end

function WndRebate:onRuleClick(element) 
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface(LocalStrings.REBATE_DESC)
end

function WndRebate:onAddDiamond(element) 
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if CacheCenter:getPlayerInfo().level < GDatatab_button_info["id_34"].open_level then
        MsgBoxManager:showTipBox(GDatatab_button_info["id_34"].feedback_info)
		return
	end
	--跳转到充值界面
	PassportSdkManager:gotoPaymentPage()
end

-------------------------------------私有方法模块End----------------------------------------
