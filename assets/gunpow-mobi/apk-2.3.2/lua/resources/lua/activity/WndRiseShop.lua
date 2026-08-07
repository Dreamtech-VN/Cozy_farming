--WndRiseShop.lua
--@brief	WndRiseShop的UI模块
--@date		2021/06/25
--@author	hyx
--@note		崛起之路商店


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndRiseShop:onEnter(element)
	self.m_root = element
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
	self:register()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndRiseShop:onExit(element)
	self:_unInit()
	CacheCenter:unregisterUpatePlayerItemObserver(self)
	self:unregister()
end
function WndRiseShop:showInterface()
	local wndShop = WndRiseShop:createElement()
	if wndShop ~= nil then
	    WindowManager:addWindow(wndShop,WndRiseShop,nil,false)
	end
end
function WndRiseShop:register()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetRiseShopInfo,self)
end
function WndRiseShop:unregister()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetRiseShopInfo,self)
end
function WndRiseShop:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndRiseShop:actionCallback()
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7019, 3, "")
end
function WndRiseShop:updatePlayerItemData()
	local txtHasNum = GetElement(self.m_root,"txtHasNum",WZUIFreeTextBox)
	if self.m_nCoinid then
		local info = GDatatab_item["id_".. self.m_nCoinid]
		if info then
			local num =  CacheCenter:getPlayerItemCountById(self.m_nCoinid)
			txtHasNum:setShowText(string.format([[<I Z="0.35">%s </I><T C="255,236,193" S="20" P="1" SC="132,66,29" SS="4" SE="1">%d%s</T>]],info.icon,num,LocalStrings.SHOP_IND))
		end
	end
end
function WndRiseShop:onBtnRefresh()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not self.m_tRiseShopData.refreshPriceId then return end
	local num =  CacheCenter:getPlayerItemCountById(self.m_tRiseShopData.refreshPriceId)
	if tonumber(num) >= tonumber(self.m_tRiseShopData.refreshPriceNum) then	
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7019, 4, "")
	else
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT68)
	end
end
function WndRiseShop:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndRiseShop:_onGetRiseShopInfo(activityId, doType, result, msg)
	if activityId == tonumber(g_cityExtenInfo.activity7019) then
		msg = json.decode(msg)
		if msg then
			if doType == 3 then
				self:setGetShopList(msg, result)
			elseif doType == 5 then
				self:setChangeSuccess(msg, result)
			end
		end
	end
end
--商店列表
function WndRiseShop:setGetShopList(msg, result)
	if result == 1 then
		self:setRiseShopData(msg)
		local shopTable = GetElement(self.m_root,"shopTableContainer",WZUITableContainer)
		shopTable:cleanTable()
		self.m_tShopCellItem = {}
		for i = 1, #self.m_tRiseShopData.tab_item do
	        local celElement,tCell = CellRiseShopItem:createElement()
	        self.m_tShopCellItem[i] = tCell
			celElement:setTag(i-1)
	        shopTable:setCellElement(celElement)
	        tCell:setRiseShopItemData(self.m_tRiseShopData.tab_item[i], self.m_tRiseShopData.refreshTime)
		end
		local txtRefresh = GetElement(self.m_root,"txtRefresh",WZUIFreeTextBox)
		txtRefresh:setShowText(string.format([[<T C="255,236,193" S="18" P="1">%s %d/%d</T>]],LocalStrings.REFRESH,self.m_tRiseShopData.refreshCount,self.m_tRiseShopData.refreshLimit))
		
		local btnRefresh = GetElement(self.m_root,"btnRefresh",WZUIButton)
		local txtConsume = GetElement(self.m_root,"txtConsume",WZUIFreeTextBox)
		local info = GDatatab_item["id_"..self.m_tRiseShopData.refreshPriceId]
		if info then
			btnRefresh:setTouchEnable(true)
			txtConsume:setVisible(true)
			txtConsume:setShowText(string.format([[<T C="255,236,193" S="18" P="1">%s%s%d%s</T>]],LocalStrings.PETUSE,info.name,self.m_tRiseShopData.refreshPriceNum,LocalStrings.ACTIVITY_TEXT62))
			if ProjConfig.LANGUAGE == "vn" then
				btnRefresh:setScale(0.8)
				txtConsume:setShowText(string.format([[<T C="255,236,193" S="18" P="1">%s %s %s</T>]],LocalStrings.PETUSE,self.m_tRiseShopData.refreshPriceNum,info.name))
				txtConsume:setScale(0.8)
				txtConsume:setMaxWidth(300)
			end
		else
			btnRefresh:setTouchEnable(false)
			txtConsume:setVisible(false)
		end
		self:updatePlayerItemData()
	else
		local tip_str = {"",LocalStrings.ACTIVITY_TEXT71, LocalStrings.ACTIVITY_TEXT68}
		MsgBoxManager:showTipBox(tip_str[result])
	end
end
--兑换成功
function WndRiseShop:setChangeSuccess(msg, result)
	if result == 1 then
		MsgBoxManager:showTipBox(LocalStrings.AUCTION_HOUSE_TEXT35)
		WindowManager:removeWindow(WndRiseShopChange.m_root, WndRiseShopChange, true)
		local itemsId = {} 
		local count = {}
		local index = nil
		for i = 1, #self.m_tRiseShopData.tab_item do
			if msg.id == self.m_tRiseShopData.tab_item[i].shop_id then
				index = i
				self.m_tRiseShopData.tab_item[i].buyCount = msg.buyCount
				table.insert(itemsId, msg.itemId)
				table.insert(count, msg.itemNum)
				break
			end
		end
		WndRewardShow:showById(itemsId, count)
		if index and self.m_tShopCellItem[index] then
			self.m_tShopCellItem[index]:setCellRiseShopItem(self.m_tRiseShopData.tab_item[index])
		end
	else
		local tip_str = {"",LocalStrings.ACTIVITY_TEXT69, LocalStrings.ACTIVITY_TEXT68, LocalStrings.ACTIVITY_TEXT70}
		MsgBoxManager:showTipBox(tip_str[result])
	end
end

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配方法模块Begin----------------------------------------

function WndRiseShop:_adaptLanguage_vn()
	local txtRefresh = GetElement(self.m_root,"txtRefresh",WZUIFreeTextBox)
	txtRefresh:setRelativePosition(GlobalMethod:ccp(0.823,0.12))
	-- local txtConsume = GetElement(self.m_root,"txtConsume",WZUIFreeTextBox)
	-- txtConsume:setRelativePosition(GlobalMethod:ccp(0.823,0.3))
end
-------------------------------------语言适配方法模块End----------------------------------------
