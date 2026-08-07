--WndEveryDayBuy.lua
--@brief	WndEveryDayBuy的UI模块
--@date		2020/11/30
--@author	hyx
--@note		每日必购


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndEveryDayBuy:onEnter(element)
	self.m_root = element
	self:register()
	ProtocolProcessorFestivalActivity:regAll3()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndEveryDayBuy:onExit(element)
	if self.m_sRemainTimeTicker then 
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_sRemainTimeTicker)
		self.m_sRemainTimeTicker = nil
	end 
	if self.m_nTouchBuyTicker then 
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_nTouchBuyTicker)
		self.m_nTouchBuyTicker = nil
	end
	self:_unInit()
	self:unregister()
	ProtocolProcessorFestivalActivity:unregAll()
	LoadNewActivityRes(false)
end
function WndEveryDayBuy:register()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetEveryDayInfo,self._onGetEveryDayInfo,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetEveryDayGetReward,self._onGetTotleReward,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetEveryDayBuyResult,self._onBuyResult,self)
end
function WndEveryDayBuy:unregister()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetEveryDayInfo,self._onGetEveryDayInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetEveryDayGetReward,self._onGetTotleReward,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetEveryDayBuyResult,self._onBuyResult,self)
end
function WndEveryDayBuy:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndEveryDayBuy:actionCallback()
	self:initShow()
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_DailyBuyActivityInfo( )
end
function WndEveryDayBuy:showInterface()
	LoadNewActivityRes(true)
	local wndDayBuy = WndEveryDayBuy:createElement()
    WindowManager:addWindow(wndDayBuy,WndEveryDayBuy,nil,false)
end
function WndEveryDayBuy:initShow()
	self:setInitData()

	self.m_sGiftItemFreeListContainer = GetElement(self.m_root,"giftItemFreeListContainer",WZUIFreeListContainer)
	local giftDesFreeText = GetElement(self.m_root,"giftDesFreeText",WZUIFreeTextBox)
	giftDesFreeText:setShowText(string.format(LocalStrings.EVERYDAYBUY_TEXT8,self.m_nGiftChooseNum,self.m_nDayBuyNumLimit))

	self.m_sGetContainer = GetElement(self.m_root,"get_container",WZUIContainer)
	self.m_sTxtTotleBuy = GetElement(self.m_root,"txtTotleBuy",WZUILabelTTF)
end
--礼包的选择
function WndEveryDayBuy:setChooseGiftData(tCell, index, tag, itenData)
	if not self.m_tChooseGiftType[index] then return end

	WndItemInfo:onCloseClick()
	if not self.m_tChooseGiftType[index][tag] then
		local count = self:getChooseBuyNum()
		local choose_num = self:getn_table(self.m_tChooseGiftType[index])
		if choose_num >= count then
			MsgBoxManager:showTipBox(string.format(LocalStrings.EVERYDAYBUY_TEXT13,count))
			self.m_tChooseGiftType[index][tag] = nil
			return
		end
		tCell:setItemSelState(true)
		self.m_tChooseGiftType[index][tag] = true   		
   		WndItemInfo:showInfo(tCell.m_root,self.m_root,1,itenData,false)
	else
		tCell:setItemSelState(false)
		self.m_tChooseGiftType[index][tag] = nil
	end
end

--领取奖励的左边
function WndEveryDayBuy:onBtnClickLeft()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	self.m_nCurGetIndex = self.m_nCurGetIndex - 1
	if self.m_nCurGetIndex <= 0 then
		self.m_nCurGetIndex = 1
		MsgBoxManager:showTipBox(LocalStrings.EVERYDAYBUY_TEXT6)
		return
	end
	self:changeGetReward(self.m_nCurGetIndex)
end
--领取奖励的右边
function WndEveryDayBuy:onBtnClickRight()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	self.m_nCurGetIndex = self.m_nCurGetIndex + 1
	if self.m_nCurGetIndex > #self.m_tGetRewardTable then
		self.m_nCurGetIndex = #self.m_tGetRewardTable
		MsgBoxManager:showTipBox(LocalStrings.EVERYDAYBUY_TEXT7)
		return
	end
	self:changeGetReward(self.m_nCurGetIndex)
end

function WndEveryDayBuy:changeGetReward(index)
	if not self.m_sGetContainer then return end

	if next(self.m_tGetRewardTable) ~= nil then
		for i,v in pairs(self.m_tSaveItemCell) do
			if v and v.celElement then
				v.celElement:setVisible(false)
				v.tLuaObj:setItemSelState(false)
			end
		end
		self:setChangeTotleRewardMessage(index)
		local data = self.m_tGetRewardTable[index]
		for i=1, #data.reward do
			local key = "id_"..data.reward[i]
			local tabItem = GDatatab_item[key]

			local num = data.num[i]
			local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key])}
			if not self.m_tSaveItemCell[i] then
				--物品底框
				local imgItemBg = WZUIImage:create()
				imgItemBg:setUseOriginSize(true)
				imgItemBg:setFile("ui/newActivity/common_fkfb_02.png")
				imgItemBg:setScale(0.8)
				local _x = 44 + (i-1) * 75
				imgItemBg:setUseAbsCoordinate(true)
				imgItemBg:setAbsPosition(GlobalMethod:ccp(_x, 35))
				self.m_sGetContainer:addChild(imgItemBg)

				local celElement,tLuaObj = CellGoodItem:createElement()
				self.m_sGetContainer:addChild(celElement)
				celElement:setScale(0.8)
				celElement:setUseAbsCoordinate(true)
				local tab = {}
				tab.celElement = celElement
				tab.tLuaObj = tLuaObj
				self.m_tSaveItemCell[i] = tab
			end
			local item = self.m_tSaveItemCell[i]
			if item then
				item.celElement:setVisible(true)
				item.celElement:setTag(i)
				item.tLuaObj:setCellGoodItem(itemInfo, 17)
				item.tLuaObj:_setBgImgVisible(false)
				item.tLuaObj:clearItemQualityPic(false)
				local _x = 40 + (i-1) * 75
				item.celElement:setAbsPosition(GlobalMethod:ccp(_x, 40))
				if self.m_tGetChooseType[self.m_nCurGetIndex] and self.m_tGetChooseType[self.m_nCurGetIndex][i] then
					item.tLuaObj:setItemSelState(true)
				end
				item.tLuaObj:setGoodItemCallFunc(function(tCell, tag, itenData)
					self:setGetChooseGiftData(tCell, tag, itenData)
				end)
			end
		end
	end
end

function WndEveryDayBuy:setChangeTotleRewardMessage(index)
	if not self.m_tTotleGetCount[index] then return end

	local btnGetTotleReward = GetElement(self.m_root,"btnGetTotleReward",WZUIButton)
	local btnGetArmature = GetElement(self.m_root,"btnGetArmature",WZUIContainer)
	if self.m_tRewardStatus[index] == 0 then
	 	btnGetTotleReward:setVisible(true)
	 	btnGetTotleReward:setTouchEnable(false)
	 	btnGetArmature:setVisible(false)
	elseif self.m_tRewardStatus[index] == 1 then
		btnGetTotleReward:setVisible(true)
		btnGetTotleReward:setTouchEnable(true)
		btnGetArmature:setVisible(true)
	else
		btnGetTotleReward:setVisible(false)
		btnGetArmature:setVisible(false)
	end
	GetElement(self.m_root,"imageGet",WZUIImage):setVisible(self.m_tRewardStatus[index] == 2)

	local str = string.format("%s/%s %s",self.m_nTotleRewardCount, self.m_tTotleGetCount[index], LocalStrings.SHOP_CISHU)
	self.m_sTxtTotleBuy:setText(str)
end

function WndEveryDayBuy:setGetChooseGiftData(tCell, tag, itenData)
	if not self.m_tGetChooseType[self.m_nCurGetIndex] then return end

	WndItemInfo:onCloseClick()
	if not self.m_tGetChooseType[self.m_nCurGetIndex][tag] then
		local count = self:getRewardChooseNum()
		local choose_num = self:getn_table(self.m_tGetChooseType[self.m_nCurGetIndex])
		if choose_num >= count then
			MsgBoxManager:showTipBox(string.format(LocalStrings.EVERYDAYBUY_TEXT13,count))
			self.m_tGetChooseType[self.m_nCurGetIndex][tag] = nil
			return
		end
		tCell:setItemSelState(true)
		self.m_tGetChooseType[self.m_nCurGetIndex][tag] = true   		
   		WndItemInfo:showInfo(tCell.m_root,self.m_root,1,itenData,false)
	else
		tCell:setItemSelState(false)
		self.m_tGetChooseType[self.m_nCurGetIndex][tag] = nil
	end
end
function WndEveryDayBuy:onDailyBuyPreorderOk(index, changeid)
	if self.m_nTouchBuyTicker then
		MsgBoxManager:showTipBox(LocalStrings.EVERYDAYBUY_TEXT11)
		return
	end
	if not changeid then
		MsgBoxManager:showTipBox("渠道不存在")
		return
	end
	--存在0.5秒的时间冻结，主要是不给连续点击按钮的
	self.m_nTouchBuyTicker = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(function(dt)
        if self.m_nTouchBuyTicker then
			CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_nTouchBuyTicker)
			self.m_nTouchBuyTicker = nil
		end 
    end, 1, false)
	local nums = {}
	for i,v in pairs(self.m_tChooseGiftType[index]) do
		table.insert(nums, i-1)
	end
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_DailyBuyPreorder(index-1, TableToVector(nums, WZLuaVector_int_), tonumber(changeid))
end
--领取奖励
function WndEveryDayBuy:onBtnClickGet()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tGetChooseType[self.m_nCurGetIndex] and next(self.m_tGetChooseType[self.m_nCurGetIndex]) == nil then 
		MsgBoxManager:showTipBox(LocalStrings.EVERYDAYBUY_TEXT14)
		return
	end

	local reward_count = self:getRewardChooseNum()
	local choose_count = self:getn_table(self.m_tGetChooseType[self.m_nCurGetIndex])

	if choose_count < reward_count then
		MsgBoxManager:showTipBox(string.format(LocalStrings.EVERYDAYBUY_TEXT12,reward_count))
		return
	end
	if choose_count > reward_count then
		MsgBoxManager:showTipBox(string.format(LocalStrings.EVERYDAYBUY_TEXT13,reward_count))
		return
	end
	
	local nums = {}
	for i,v in pairs(self.m_tGetChooseType[self.m_nCurGetIndex]) do
		table.insert(nums, i-1)
	end
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_DailyBuyReceiveReward(self.m_nCurGetIndex-1, TableToVector(nums, WZLuaVector_int_))
end
--获取真实的长度
function WndEveryDayBuy:getn_table(nums)
	if not nums or next(nums) == nil then return 0 end

	local count = 0
	for i,v in pairs(nums) do
		if v ~= nil then
			count = count + 1
		end
	end
	return count
end
function WndEveryDayBuy:onBtnClickRule(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSingleMapDesc:showInterface(LocalStrings.EVERYDAYBUY_TEXT1)
end
function WndEveryDayBuy:onBtnTotleReward(element)
	local str = string.format(LocalStrings.EVERYDAYBUY_TEXT16,self:getRewardChooseNum())
	WndNewTips:showInterface(self.m_root, element, str)
end
function WndEveryDayBuy:onBtnClickClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndEveryDayBuy:_onGetEveryDayInfo(activityId, startTime, endTime, nextDayTime, rechargeType, rechargeSort, giftItemId, giftItemNum, giftSize, 
	giftDayBuyCount, rewardItemId, rewardItemNum, rewardSize, giftBuyCount, rewardBuyNum, rewardStatus)
	if not self.m_sRemainTimeTicker then
		self.m_sRemainTimeTicker = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(function(dt)
			nextDayTime = nextDayTime - 1 
			if nextDayTime <= 0 then
				if self.m_sRemainTimeTicker then 
					CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_sRemainTimeTicker)
				end
				MsgBoxManager:showConfirmBox(LocalStrings.EVERYDAYBUY_TEXT15, self, function()
					self.m_tChooseGiftType = {}
					self.m_tGetChooseType = {}
					WndItemInfo:_onCloseClick()
					ProtocolProcessorFestivalActivity:send_ACTIVITY2_DailyBuyActivityInfo( )
				end, nil, nil,true)
			end
	    end, 1, false)
	end

	local activity_time = GetElement(self.m_root,"txtActivityTime",WZUILabelTTF)
	if activity_time then
		activity_time:setText(SystemTime:getTimeConverLocal4(startTime).." - "..SystemTime:getTimeConverLocal4(endTime))
	end
	if self.m_sGiftItemFreeListContainer then
		self.m_sGiftItemFreeListContainer:removeAll()
		self.m_nTotleRewardCount = giftBuyCount --总累购次数
		self.m_tRewardStatus = rewardStatus

		local buy_data = self:setBuyGiftData(giftItemId, giftItemNum, giftSize, giftDayBuyCount, rechargeType, rechargeSort)
		for i=1,#buy_data do
			self.m_tChooseGiftType[i] = {}
		end
		for i = 1, #buy_data do
			local element, tLuaObj = CellEveryDayBuyItem:createElement()
			self.m_sGiftItemFreeListContainer:pushBack(WZUIContainer:luaTo(element))
			self.m_sGiftItemFreeListContainer:getMoveElement():setPositionX(self.m_sGiftItemFreeListContainer:getMaxPosition().x)
			tLuaObj:setGiftBuyMessage(i, buy_data[i])
			tLuaObj:setChooseTypeFunc(function(tCell, index, tag, itenData)
				self:setChooseGiftData(tCell, index, tag, itenData)
			end,function(index, changeid)
				self:onDailyBuyPreorderOk(index, changeid)
			end)
		end

		local get_data = self:setBuyGiftData(rewardItemId, rewardItemNum, rewardSize)
		for i=1,#get_data do
			self.m_tGetChooseType[i] = {}
		end
		self.m_tGetRewardTable = get_data
		self.m_tTotleGetCount = rewardBuyNum
		self:changeGetReward(self.m_nCurGetIndex)
	end
end

function WndEveryDayBuy:_onBuyResult(result, rechargeId)
	if result == 0 then
		local data = GDatatab_recharge["id_" .. rechargeId]
		--必带。id：产品id，price:价格；productName:商品名称；payCode:商品号
		if data then
			local tab = {}
			tab.id = data.id
			tab.price = data.price
			tab.number = 1
			tab.productName = data.name
			tab.payCode = GetPayCodeIdByChannelId(data)
			PassportSdkManager:getOrderNum(tab)
		end
	else
		MsgBoxManager:showTipBox(LocalStrings.EVERYDAYBUY_TEXT10)
	end
end

function WndEveryDayBuy:_onGetTotleReward(result, itemId, itemNum, taskId, giftBuyCount, rewardBuyNum, rewardStatus)
	if result ~= 0 then
		MsgBoxManager:showTipBox(LocalStrings.RETURNEE_TEXT28)
		return
	end
	WndRewardShow:showById(itemId, itemNum)
end

-------------------------------------私有方法模块End----------------------------------------
