--WndAuctionStore.lua
--@brief	WndAuctionStore的UI模块
--@date		2020/09/03
--@author	yrd
--@note		拍卖行商店


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndAuctionStore:onEnter(element)
	self.m_root = element

	local activityId = g_cityExtenInfo.auction
	if activityId and activityId ~= 0 then
		ProtocolProcessorNewActivity:send_ACTIVITY2_GetAuctionMallInfo(activityId )
	end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndAuctionStore:onExit(element)
	self:_unInit()
end

--@brief    关闭窗口
function WndAuctionStore:onCloseClick()
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	刷新界面
function WndAuctionStore:update()
	if self.m_nTime > 0 then
		self.m_root:enableSchedule("_timeDownSchedule",1)
	end

	local auctionShopPrice = CacheCenter:getGameParam()["auctionShopPrice"]
	local ids, nums = SplitItemString(auctionShopPrice)
	WZLog("WndAuctionStore:update",auctionShopPrice,Serialize(ids),Serialize(nums))

	--关闭按钮
	local btnClose = GetElement(self.m_root,"btnClose_WndAuctionStore",WZUIButton)
	btnClose:setLuaActionName("Normal")

	--提示按钮
	local btnTips = GetElement(self.m_root,"btnTips_WndAuctionStore",WZUIButton)
	btnTips:setLuaActionName("Normal")

	--标题
	local txtTitle = GetElement(self.m_root,"txtTitle_WndAuctionStore",WZUILabelTTF)
	txtTitle:setText(LocalStrings.ATH_SHOP)

	--我的竞拍币
	local tCurrencyInfo = GDatatab_item["id_"..self.m_currencyId]
	local nMyCurrencyNum = CacheCenter:getPlayerItemCountById(self.m_currencyId)

	local txtMyCurrency1 = GetElement(self.m_root,"txtMyCurrency1_WndAuctionStore",WZUILabelTTF)
	txtMyCurrency1:setText(LocalStrings.AUCTION_HOUSE_TEXT5)
	local imgMyCurrency = GetElement(self.m_root,"imgMyCurrency_WndAuctionStore",WZUIImage)
	imgMyCurrency:setFile(tCurrencyInfo.icon)
	local txtMyCurrency2 = GetElement(self.m_root,"txtMyCurrency2_WndAuctionStore",WZUILabelTTF)
	txtMyCurrency2:setText(nMyCurrencyNum)

	--刷新次数
	local txtRefreshNum1 = GetElement(self.m_root,"txtRefreshNum1_WndAuctionStore",WZUILabelTTF)
	txtRefreshNum1:setText(LocalStrings.REFRESH_COUNT..":")
	local txtRefreshNum2 = GetElement(self.m_root,"txtRefreshNum2_WndAuctionStore",WZUILabelTTF)
	txtRefreshNum2:setText((#ids-self.m_nResetNum).."/"..#ids)

	--刷新消耗
	local resetNum = ids[self.m_nResetNum+1] and self.m_nResetNum+1 or self.m_nResetNum
	local tRefreshCostInfo = GDatatab_item["id_"..ids[resetNum]]

	local txtRefreshCost1 = GetElement(self.m_root,"txtRefreshCost1_WndAuctionStore",WZUILabelTTF)
	txtRefreshCost1:setText(LocalStrings.CONSUME)
	local imgRefreshCost = GetElement(self.m_root,"imgRefreshCost_WndAuctionStore",WZUIImage)
	imgRefreshCost:setFile(tRefreshCostInfo.icon)
	local txtRefreshCost2 = GetElement(self.m_root,"txtRefreshCost2_WndAuctionStore",WZUILabelTTF)
	txtRefreshCost2:setText(nums[resetNum])

	--刷新按钮
	local btnRefresh = GetElement(self.m_root,"btnRefresh_WndAuctionStore",WZUIButton)
	btnRefresh:setLuaActionName("Normal")

	--商品
	local tconCommodity = GetElement(self.m_root,"tconCommodity_WndAuctionStore",WZUITableContainer)
    tconCommodity:cleanTable()
    for i = 1, #self.m_tCommodityData do
        local cell,tcell = CellAuctionStore:createElement()
        cell:setTag(i-1)
        tconCommodity:setCellElement(cell)
        tcell:setData(self.m_tCommodityData[i])
    end

end

--倒计时
function WndAuctionStore:_timeDownSchedule(element)
	self.m_nTime = self.m_nTime - 1
	if self.m_nTime <= 0 then
		self.m_root:disableSchedule()
		local activityId = g_cityExtenInfo.auction
		if activityId and activityId ~= 0 then
			ProtocolProcessorNewActivity:send_ACTIVITY2_GetAuctionMallInfo(activityId )
		end
	end

end

--@brief	点击刷新按钮回调
function WndAuctionStore:onClickRefresh(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local auctionShopPrice = CacheCenter:getGameParam()["auctionShopPrice"]
	local ids, nums = SplitItemString(auctionShopPrice)
    if #ids-self.m_nResetNum <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.ATH_REFRESH_LIMIT)
        return
    end

	ProtocolProcessorNewActivity:send_ACTIVITY2_ResetAuction( )
end

--@brief	点击提示按钮回调
function WndAuctionStore:onClickTips(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tData = {}
    tData.type = 1
	WndTips:show(element,self.m_root,64,tData,GlobalMethod:ccp(200,70))
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
