--WndPeopleShop.lua
--@brief	WndPeopleShop的UI模块
--@date		2020/09/27
--@author	hyx
--@note		全民购物


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPeopleShop:onEnter(element)
	self.m_root = element

	AdaptLanguage(self)

	ProtocolProcessorFestivalActivity:regAll1()
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetShoppingCoupon( ) --获取优惠劵的信息
	self:initShowUI()
	self:register()
end
function WndPeopleShop:register()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self._onPeopleShopInfo,self)
	GlobalGame:getGameEventDispathcer():Add(WndPeopleShopEvent.WndPeopleShopEvent_PaySuccess,self._onPaySuccessResult,self)
	GlobalGame:getGameEventDispathcer():Add(WndPeopleShopEvent.WndPeopleShopEvent_DiscountInfo,self._onGetDiscountInfo,self) --获取优惠券信息
end
function WndPeopleShop:unregister()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self._onPeopleShopInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(WndPeopleShopEvent.WndPeopleShopEvent_PaySuccess,self._onPaySuccessResult,self)
	GlobalGame:getGameEventDispathcer():Remove(WndPeopleShopEvent.WndPeopleShopEvent_DiscountInfo,self._onGetDiscountInfo,self)
end
--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPeopleShop:onExit(element)
	self:_unInit()
	self:unregister()
	ProtocolProcessorFestivalActivity:unregAll()
end
function WndPeopleShop:showInterface()
	local peopleShop = WndPeopleShop:createElement()
    WindowManager:addWindow(peopleShop,WndPeopleShop,nil,false)
end
function WndPeopleShop:initShowUI()
	
	self.imgDisCountRedPoint = GetElement(self.m_root,"imgDisCountRedPoint",WZUIImage)
	--合计的价格
	self.m_sTotleLabel = GetElement(self.m_root,"totle_label",WZUILabelTTF)
	self.m_sTotleLabel:setText(0)
	--打折的价格
	self.m_sDiscountLabel = GetElement(self.m_root,"discount_label",WZUILabelTTF)
	self.m_sDiscountLabel:setText(0)

	self.m_tDeleteIitemGoods = GetElement(self.m_root,"itemGoodsTableContainer",WZUITableContainer)
	-- self.m_tDeleteIitemGoods:cleanTable()

	GetElement(self.m_root,"shop_currency",WZUILabelTTF):setText(LocalStrings.PEOPLE_SHOP_TEXT15..":")
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.shoppingActivity, 6116)
end

function WndPeopleShop:setDiscountRedPointStatus(visible)
	if self.imgDisCountRedPoint then
		self.imgDisCountRedPoint:setVisible(visible)
	end	
end

--放入购物车的返回处理  -- 物品id，数量，购买的数量, 单个物品的价格, 商品id
function WndPeopleShop:setTouchPushShopCardFunc(id, num, buy_num, price, shop_id)
	self.m_tChooseItemDelete[id] = nil

	if self.m_tChooseShopCarMsg[id] and self.m_tChooseShopCarMsg[id].buy_num == buy_num then
		return
	end
	local info = GDatatab_item["id_"..id]
	if info and info.main_type == 5 then
		-- num = 1
	end

	local temp = {}
	temp.num = num
	temp.buy_num = buy_num
	temp.price = price
	temp.shop_id = shop_id
	self.m_tChooseShopCarMsg[id] = temp

	if self.m_tDeleteIitemGoods then
		if self.m_tCreateShopCarItem[id] then
			self.m_tCreateShopCarItem[id]:setGoodItemCount(math.abs(num) * buy_num)
		else
			local cellElement,tCell = CellGoodItem:createElement()
			cellElement:setTag(self.m_nTouchCardIndex)
			local key = "id_"..id
			local tabItem = GDatatab_item[key]
			local itemInfo = {id = tabItem.id, icon=tabItem.icon,lastTime=num*buy_num,quality=tabItem.quality,basicInfo=CopyTable(tabItem)}
			tCell:setCellGoodItem(itemInfo,16)
			tCell:setItemClickFun(WndPeopleShop,self.onItemChooseClick)

			self.m_tDeleteIitemGoods:setCellElement(cellElement)
			self.m_tCreateShopCarItem[id] = tCell

			self.m_nTouchCardIndex = self.m_nTouchCardIndex + 1
			self.m_tChooseItemID[self.m_nTouchCardIndex] = id
		end
	end
	
	local totlePrice = 0
	for i,v in pairs(self.m_tChooseItemID) do
		if self.m_tChooseShopCarMsg[v] then
			totlePrice = totlePrice + self.m_tChooseShopCarMsg[v].buy_num * self.m_tChooseShopCarMsg[v].price
		end
	end

	self:showTotleOrDiscountPrice(totlePrice)
end
--购物车里面的删除操作
function WndPeopleShop:onItemChooseClick(tCell,tag,tData)
	if tData == nil or tCell == nil then
       return
    end
	if self.m_tChooseItemDelete[tData.id] == nil then
		self.m_tChooseItemDelete[tData.id] = true
		self.m_tIsDeleteTips[tData.id] = true
		tCell:setChooseSelect()
	else
		tCell:setChooseNormal()
		self.m_tChooseItemDelete[tData.id] = nil
		self.m_tIsDeleteTips[tData.id] = nil
	end
end

--优惠券
function WndPeopleShop:onBtnClickDiscount()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local wndDiscount = WndShopDiscount:createElement()
    WindowManager:addWindow(wndDiscount,WndShopDiscount,nil,false)
end
--排行榜
function WndPeopleShop:onBtnClickRank()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local wndRank = WndShopRank:createElement()
    WindowManager:addWindow(wndRank,WndShopRank,nil,false)
end
--规则
function WndPeopleShop:onBtnClickRule()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSingleMapDesc:showInterface(LocalStrings.PEOPLE_SHOP_TEXT8)
end
--选中物品的删除
function WndPeopleShop:onBtnClickChooseItemDelete()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	if not self.m_tDeleteIitemGoods then return end
	if next(self.m_tIsDeleteTips) == nil then
		MsgBoxManager:showTipBox(LocalStrings.PEOPLE_SHOP_TEXT23)
		return
	end

	for i,v in pairs(self.m_tChooseItemDelete) do
		self.m_tCreateShopCarItem[i] = nil
		self.m_tChooseShopCarMsg[i] = nil
	end
	WndPeopleShop:saveShoppingCart()

	self.m_nTouchCardIndex = 0
	self.m_tDeleteIitemGoods:cleanTable() --释放掉选中的物品信息
	local totlePrice = 0
	local tab_temp = {}
	for i,v in ipairs(self.m_tChooseItemID) do
		if not self.m_tChooseItemDelete[v] then --没有删除的
			local cellElement,tCell = CellGoodItem:createElement()
			cellElement:setTag(self.m_nTouchCardIndex)
			table.insert(tab_temp, v)
			local key = "id_"..v
			local tabItem = GDatatab_item[key]
			local num = 1
			if self.m_tChooseShopCarMsg[v] then
				num = self.m_tChooseShopCarMsg[v].buy_num * math.abs(self.m_tChooseShopCarMsg[v].num)
				totlePrice = totlePrice + self.m_tChooseShopCarMsg[v].buy_num * self.m_tChooseShopCarMsg[v].price
			end
			local itemInfo = {id = tabItem.id, icon=tabItem.icon,lastTime=num,quality=tabItem.quality,basicInfo=CopyTable(tabItem)}
			tCell:setCellGoodItem(itemInfo,16)
			tCell:setItemClickFun(WndPeopleShop,self.onItemChooseClick)
			self.m_tDeleteIitemGoods:setCellElement(cellElement)

			self.m_tCreateShopCarItem[v] = tCell
			self.m_nTouchCardIndex = self.m_nTouchCardIndex + 1
 		end
	end
	self.m_tChooseItemID = tab_temp
	self:showTotleOrDiscountPrice(totlePrice)
	self.m_tIsDeleteTips = {}
end
--显示原价与折后价
function WndPeopleShop:showTotleOrDiscountPrice(price)
	if self.m_sTotleLabel and self.m_sDiscountLabel then
		self.m_sTotleLabel:setText(price)
		WZLog("WndPeopleShop:showTotleOrDiscountPrice", Serialize(self.m_tDiscountMaxPrice))
		--折后价格
		local dis_price = price
		local cur_dis = 0 --当前折扣的价格
		for i,v in pairs(self.m_tDiscountMaxPrice) do
			if dis_price >= v.fulls then
				if v.subs >= cur_dis then
					cur_dis = v.subs
				end
			end
		end
		self.m_sDiscountLabel:setText(dis_price - cur_dis)
	end
end
--结算按钮
function WndPeopleShop:onBtnClickSettle()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if next(self.m_tChooseShopCarMsg) == nil then
		MsgBoxManager:showTipBox(LocalStrings.PEOPLE_SHOP_TEXT14)
		return
	end
	local dis = tonumber(self.m_sDiscountLabel:getText())
	if dis > self.m_nCurrentCoin then
		MsgBoxManager:showTipBox(LocalStrings.PEOPLE_SHOP_TEXT15..LocalStrings.NOT_ENABLE)
		return
	end
	local tab = {}
	local nums = {}
	for i,v in pairs(self.m_tChooseShopCarMsg) do
		table.insert(tab, v.shop_id)
		local num = v.buy_num
		table.insert(nums, num)
	end
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_PayForShoppingCar(TableToVector(tab, WZLuaVector_int_), TableToVector(nums, WZLuaVector_int_), self.m_refresData, tonumber(self.m_sDiscountLabel:getText()) )
end
function WndPeopleShop:onBtnClickClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WindowManager:removeWindow(self.m_root, self, true)
end

-- 保存购物车
function WndPeopleShop:saveShoppingCart()
	local tData = {}
	tData.goodIds = {}
	tData.nums = {}
	tData.refreshDate = self.m_refresData
	for i,v in pairs(self.m_tChooseShopCarMsg) do
		table.insert(tData.goodIds, v.shop_id)
		table.insert(tData.nums, v.buy_num)
	end
	local sJson = json.encode(tData)
	sJson = string.gsub(sJson,'{}','[]')

	-- sJson = json.encode({refreshDate=self.m_refresData,goodIds={},nums={}})
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_AddToShoppingCar(0, sJson)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--[[
activityId;               // 活动ID
content;                  // 购物车json [{\"goodId\":商品id(int),\"num\":商品数量(int)}]
startTime;                // 生效开始时间
endTime;                  // 生效结束时间
serverTime;               // 服务器时间
rewardId;                 // 商品id
status;                   // 限购数量
rewardItems;              // 商品对应的物品id
rewardItemsParamCount;    // 物品数量
rewardCounts;             // 剩余可购买数量
count;                    // 当前购物币数量
finishCondition;          // 价格
tips 					  //商城刷新日期
]]
function WndPeopleShop:_onPeopleShopInfo(activityId,maxCount,count,status, rewardCounts, rewardItems,rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	if g_cityExtenInfo.shoppingActivity and tonumber(g_cityExtenInfo.shoppingActivity) == tonumber(activityId) then
		local activity_value = GetElement(self.m_root,"activity_value",WZUILabelTTF)
		if activity_value then
			local startT = SystemTime:getTimeConverLocal4(startTime)
			local endT = SystemTime:getTimeConverLocal4(endTime)
			activity_value:setText(startT.." - "..endT)
		end
		GetElement(self.m_root,"shop_currency_count",WZUILabelTTF):setText(count)

		self.m_tContent = json.decode(content)
		self.m_nCurrentCoin = count
		self:_getShopBuyInfo(rewardId, rewardItems, rewardItemsParamCount, rewardCounts, finishCondition, tips)
		self:_getShopCarInfo()
		self.m_nRefreshCount = maxCount
		self:showRefresh()
	end
end
--购买的东西
function WndPeopleShop:_getShopBuyInfo(rewardId, rewardItems, rewardItemsParamCount, rewardCounts, finishCondition, tips)
	self.m_refresData = tips[1] or SystemTime:getServerTime()
	if next(rewardId) == nil then return end
	local shopItemTabel = GetElement(self.m_root,"shopItemTableContainer",WZUITableContainer)
	if not shopItemTabel then return end
	shopItemTabel:cleanTable()

	local data = {}
	for i,v in ipairs(rewardId) do
		local tab = {}
		tab.shop_id = v --商品id
		tab.id = rewardItems[i]
		tab.num = tonumber(rewardItemsParamCount[i])
		tab.limit_num = rewardCounts[i]
		tab.price = finishCondition[i]
		data[i] = tab
	end
	for i=1, #data do
		local cellElement,tCell = CellPeopleShopItem:createElement()
		cellElement:setTag(i - 1)
		shopItemTabel:setCellElement(cellElement)

		tCell:setShopItemMessage(i,data[i])
		tCell:setCallFuncShopItem(function(id, num, buy_num, price, shop_id)
			self:setTouchPushShopCardFunc(id, num, buy_num, price, shop_id)
			
			WndPeopleShop:saveShoppingCart()
		end)
	end	

end
--购物车的东西
function WndPeopleShop:_getShopCarInfo()
	if self.m_tDeleteIitemGoods then
		self.m_tDeleteIitemGoods:cleanTable()
	end
	local tCarData = json.decode(self.m_tContent.car)
	if tCarData == nil or #tCarData == 0 then return end
	if not tCarData then return end

	if self.m_tDeleteIitemGoods then
		local totle_price = 0
		for i,v in pairs(tCarData) do
			local cellElement,tCell = CellGoodItem:createElement()
			cellElement:setTag(self.m_nTouchCardIndex)
			local key = "id_"..v.itemId
			local tabItem = GDatatab_item[key]
			local itemInfo = {id = tabItem.id, icon=tabItem.icon,lastTime=v.num * v.itemNum,quality=tabItem.quality, basicInfo=CopyTable(tabItem)}
			tCell:setCellGoodItem(itemInfo,17)
			tCell:setItemClickFun(WndPeopleShop,self.onItemChooseClick)

			self.m_tDeleteIitemGoods:setCellElement(cellElement)
			self.m_tCreateShopCarItem[v.itemId] = tCell

			self.m_nTouchCardIndex = self.m_nTouchCardIndex + 1
			self.m_tChooseItemID[self.m_nTouchCardIndex] = v.itemId

			local temp = {}
			temp.num = v.itemNum
			temp.buy_num = v.num
			temp.price = v.price
			temp.shop_id = v.goodId
			self.m_tChooseShopCarMsg[v.itemId] = temp
			totle_price = totle_price + (v.num * v.price)
		end
		self:showTotleOrDiscountPrice(totle_price)
	end
end

function WndPeopleShop:_onPaySuccessResult(result, itemIds, itemNums, coin)
	-- 3金额不一致 4跨天，数据不一致  5 购物币不足
	if result == 3 or result == 4 or result == 5 then
		if result == 3 then
			MsgBoxManager:showTipBox(LocalStrings.PEOPLE_SHOP_TEXT21)
		elseif result == 4 then
			MsgBoxManager:showTipBox(LocalStrings.PEOPLE_SHOP_TEXT22)
		elseif result == 5 then
			MsgBoxManager:showTipBox(LocalStrings.PEOPLE_SHOP_TEXT15..LocalStrings.NOT_ENABLE)
		end		
		return
	end
	self.m_nCurrentCoin = coin
	GetElement(self.m_root,"shop_currency_count",WZUILabelTTF):setText(coin)
	WndRewardShow:showById(itemIds, itemNums)
	if self.m_tCreateShopCarItem then
		for i,v in pairs(self.m_tCreateShopCarItem) do
			self.m_tCreateShopCarItem[i] = nil
			self.m_tChooseShopCarMsg[i] = nil
		end
	end
	self.m_tChooseItemID = {}
	self:showTotleOrDiscountPrice(0)
	self.m_nTouchCardIndex = 0
	if self.m_tDeleteIitemGoods then
		self.m_tDeleteIitemGoods:cleanTable()
	end
end

function WndPeopleShop:_onGetDiscountInfo(rewardIds, status, process, targets, tips1, tips2, fulls, subs)
	WZLog("WndPeopleShop:_onGetDiscountInfo 000")
	if next(rewardIds) == nil then return end
	self.m_tDiscountMaxPrice = {}
	WZLog("WndPeopleShop:_onGetDiscountInfo 111", #status)
	local red_status = false
	for i,v in ipairs(status) do
		if v == 0 then --可领取
			red_status = true
		elseif v == 1 then --已领取
			local temp = {}
			temp.fulls = fulls[i]
			temp.subs = subs[i]
			self.m_tDiscountMaxPrice[rewardIds[i]] = temp
		end
	end
	self:setDiscountRedPointStatus(red_status)
	if self.m_root and self.m_sTotleLabel then 
		local price = tonumber(self.m_sTotleLabel:getText())
		if price then 
			self:showTotleOrDiscountPrice(price)
		end
	end
end

--	显示刷新按钮信息
function WndPeopleShop:showRefresh()
	local strFormat = [[<T S="18" C="127,70,26" P="1">%s</T><I Z="0.5">%s</I><T S="18" C="127,70,26" P="1">%s</T>]]
	local num = self.m_tContent.shopConfig[2] + self.m_tContent.shopConfig[3] * math.min(self.m_nRefreshCount, self.m_tContent.shopConfig[4])
	local icon = GDatatab_item["id_"..self.m_tContent.shopConfig[1]].icon
	local ftbRefresh = GetElement(self.m_root,"ftbRefresh",WZUIFreeTextBox)
	ftbRefresh:setShowText(string.format(strFormat, num, icon, LocalStrings.REFRESH))

	local btnRefresh = GetElement(self.m_root,"btnRefresh",WZUIButton)
	btnRefresh:setTouchEnable(self.m_nRefreshCount < self.m_tContent.shopConfig[6])
end

--	点击刷新按钮
function WndPeopleShop:onClickRefresh()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local num = self.m_tContent.shopConfig[2] + self.m_tContent.shopConfig[3] * math.min(self.m_nRefreshCount, self.m_tContent.shopConfig[4])
	--钻石不足
	if not JudgeMoneyIsEnough(self.m_tContent.shopConfig[1], num, nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureUseDiamond) then
		return 
	end
	self.sureUseDiamond()
end

function WndPeopleShop:sureUseDiamond()
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_AddToShoppingCar(1, "")
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配begin----------------------------------------
function WndPeopleShop:_adaptLanguage_vn()
	GetElement(self.m_root,"activity_key",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.54,0.786))
	GetElement(self.m_root,"activity_value",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.61,0.786))
	GetElement(self.m_root,"shop_currency",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.53,1.213))
end
-------------------------------------语言适配End----------------------------------------
