--WndAuctionBuy.lua
--@brief	WndAuctionBuy的UI模块
--@date		2020/09/03
--@author	yrd
--@note		拍卖行商店购买


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndAuctionBuy:onEnter(element)
	self.m_root = element

	self:update()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndAuctionBuy:onExit(element)
	self:_unInit()
end

--@brief    关闭窗口
function WndAuctionBuy:onCloseClick()
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManager:removeWindow(self.m_root, self, true)
end

function WndAuctionBuy:update()
	--标题
	local txtTitle = GetElement(self.m_root,"txtTitle_WndAuctionBuy",WZUILabelTTF)
	if self.m_nWinType == 0 then 
		txtTitle:setText(LocalStrings.duihuan)
	elseif self.m_nWinType == 1 then 
		txtTitle:setText(LocalStrings.GARDEN_TEXT1[25])
		for i = 1, 3 do
			GetElement(self.m_root, "txtExchange" .. i .. "_WndAuctionBuy", WZUILabelTTF):setTextKey("SELL")
		end
	elseif self.m_nWinType == 2 then 
		txtTitle:setText(LocalStrings.duihuan)
		GetElement(self.m_root, "img9Bg_WndAuctionBuy", WZUI9Image):setFile("ui/common/frame_tc_xiao_zi.png")
		GetElement(self.m_root, "ingBtnClose_WndAuctionBuy", WZUIImage):setFile("ui/common/common_top_btn_guanbi_zi.png")
		GetElement(self.m_root, "imgCircle_WndAuctionBuy", WZUIImage):setFile("ui/activity/common_jl_ditu.png")
	elseif self.m_nWinType == 3 then 
		txtTitle:setText(LocalStrings.BUY)
		for i = 1, 3 do
			GetElement(self.m_root, "txtExchange" .. i .. "_WndAuctionBuy", WZUILabelTTF):setTextKey("BUY")
		end
	end

	--物品
	local conItem = GetElement(self.m_root,"conItem_WndAuctionBuy",WZUIContainer)
	conItem:removeAllChildrenWithCleanup(true)
	if self.m_nWinType == 0 or self.m_nWinType == 2 or self.m_nWinType == 3 then 
		local celElement,tLuaObj = CellGoodItem:createElement()
		if celElement ~= nil and tLuaObj ~= nil then
			if self.m_nWinType == 3 then 
				local tabItem = GDatatab_item["id_" .. self.m_nitemId]
				local itemInfo = {lastTime=self.m_nitemCount,lastNum=self.m_nitemCount,basicInfo=CopyTable(tabItem)}
				local seedData = WndHVLibrary:getSeedDataByItemId(self.m_nitemId)
				if seedData then 
					itemInfo.basicInfo.icon = seedData.icon_zz
				end
				tLuaObj:setCellGoodItem(itemInfo, 17)
			else
				tLuaObj:setCellGoodLocalId(self.m_nitemId, self.m_nitemCount, 17)
			end
			tLuaObj:setBackImgFile2()
			tLuaObj:setItemClickFun(self,self.onClickItem)
			conItem:addChild(celElement)
		end
	elseif self.m_nWinType == 1 then 
		local imgIcon = createImage("ui/newActivity/xdgy_cs.png", nil, nil, true, GlobalMethod:ccp(0.5,0.5))
		if imgIcon then 
			conItem:addChild(imgIcon)
		end
	end

	--一次最多减少
	local txtSubtractTen1 = GetElement(self.m_root,"txtSubtractTen1_WndAuctionBuy",WZUILabelTTF)
	txtSubtractTen1:setText("-"..self.m_nMaxSubtractNUm)
	local txtSubtractTen2 = GetElement(self.m_root,"txtSubtractTen2_WndAuctionBuy",WZUILabelTTF)
	txtSubtractTen2:setText("-"..self.m_nMaxSubtractNUm)

	--一次最多增加
	local txtAddTen1 = GetElement(self.m_root,"txtAddTen1_WndAuctionBuy",WZUILabelTTF)
	txtAddTen1:setText("+"..self.m_nMaxAddNUm)
	local txtAddTen2 = GetElement(self.m_root,"txtAddTen2_WndAuctionBuy",WZUILabelTTF)
	txtAddTen2:setText("+"..self.m_nMaxAddNUm)

	--消耗币
	local imgMyCurrency = GetElement(self.m_root,"imgCostCoin_WndAuctionBuy",WZUIImage)
	if self.m_nWinType == 0 or self.m_nWinType == 2 or self.m_nWinType == 3 then 
		imgMyCurrency:setFile(GDatatab_item["id_"..self.m_ncostId].icon)
	elseif self.m_nWinType == 1 then 
		imgMyCurrency:setFile("")
		GetElement(self.m_root, "txtCostCoin1_WndAuctionBuy", WZUILabelTTF):setVisible(false)
	end
	self:updateCostCount()
end

--刷新消耗数
function WndAuctionBuy:updateCostCount()
	local costNum = self.m_nCurNum ~= -1 and self.m_nCurNum or 1
	GetElement(self.m_root,"txtTotalCost_WndAuctionBuy",WZUILabelTTF):setText(costNum)
	if self.m_nWinType == 0 or self.m_nWinType == 2 or self.m_nWinType == 3 then 
		GetElement(self.m_root,"txtCostCoin2_WndAuctionBuy",WZUILabelTTF):setText(self.m_ncostCount*costNum)
	elseif self.m_nWinType == 1 then 
		GetElement(self.m_root,"txtSellNum_WndAuctionBuy",WZUILabelTTF):setText(string.format(LocalStrings.GARDEN_TEXT1[26], costNum, self.m_nlimitNum - costNum))
	end
end

--点击物品回调
function WndAuctionBuy:onClickItem(tItem, nTag, tData)
	WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData, false)
end

--加十次
function WndAuctionBuy:onClickAddTen(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	if self.m_nitemCount == -1 then
		MsgBoxManager:showTipBox(LocalStrings.AUCTION_HOUSE_TEXT34)
		return
	end

	local maxBuyNum = 0 
	if self.m_nWinType == 0 or self.m_nWinType == 2 or self.m_nWinType == 3 then 
    	local myCostCoin = CacheCenter:getPlayerItemCountById(self.m_ncostId)
		local itemInfo = GDatatab_item["id_" .. self.m_ncostId]
		if itemInfo.main_type == 45 and itemInfo.sub_type == 2 then
			myCostCoin = SceneHolidayVillage:getItemCountByItemId(self.m_ncostId)
		end
    	if self.m_ncostId == 70 then 
    		local blueNum = CacheCenter:getMoneyList().blueDiamond
    		myCostCoin = myCostCoin + blueNum
    	end
    	maxBuyNum = math.floor(myCostCoin/self.m_ncostCount) --剩余金币可购买数量
    elseif self.m_nWinType == 1 then
    	maxBuyNum = 100 
    end

    local max = math.min(self.m_nlimitNum,maxBuyNum)
	if self.m_nCurNum + self.m_nMaxAddNUm <= max then
		self.m_nCurNum = self.m_nCurNum + self.m_nMaxAddNUm
	else
		if self.m_nCurNum >= max then
			MsgBoxManager:showTipBox(LocalStrings.CHESTMAXNUM)
			return
		else
			self.m_nCurNum = max
		end
	end
	self:updateCostCount()
end

--减十次
function WndAuctionBuy:onClickSubtractTen(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_nitemCount == -1 then
		MsgBoxManager:showTipBox(LocalStrings.AUCTION_HOUSE_TEXT34)
		return
	end

	if self.m_nCurNum - self.m_nMaxSubtractNUm >= 1 then
		self.m_nCurNum = self.m_nCurNum - self.m_nMaxSubtractNUm
	else
		if self.m_nCurNum <= 1 then
			MsgBoxManager:showTipBox(LocalStrings.CHESTMINNUM)
			return
		else
			self.m_nCurNum = 1
		end
	end
	self:updateCostCount()
end

--加一次
function WndAuctionBuy:onClickAddOne(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_nitemCount == -1 then
		MsgBoxManager:showTipBox(LocalStrings.AUCTION_HOUSE_TEXT34)
		return
	end

	local maxBuyNum = 0 
	if self.m_nWinType == 0 or self.m_nWinType == 2 or self.m_nWinType == 3 then 
    	local myCostCoin = CacheCenter:getPlayerItemCountById(self.m_ncostId)
		local itemInfo = GDatatab_item["id_" .. self.m_ncostId]
		if itemInfo.main_type == 45 and itemInfo.sub_type == 2 then
			myCostCoin = SceneHolidayVillage:getItemCountByItemId(self.m_ncostId)
		end
    	if self.m_ncostId == 70 then 
    		local blueNum = CacheCenter:getMoneyList().blueDiamond
    		myCostCoin = myCostCoin + blueNum
    	end
    	maxBuyNum = math.floor(myCostCoin/self.m_ncostCount) --剩余金币可购买数量
    elseif self.m_nWinType == 1 then
    	maxBuyNum = 100 
    end

    local max = math.min(self.m_nlimitNum,maxBuyNum)
	if self.m_nCurNum + 1 <= max then
		self.m_nCurNum = self.m_nCurNum + 1
	else
		MsgBoxManager:showTipBox(LocalStrings.CHESTMAXNUM)
		return
	end
	self:updateCostCount()
end

--减一次
function WndAuctionBuy:onClickSubtractOne(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_nitemCount == -1 then
		MsgBoxManager:showTipBox(LocalStrings.AUCTION_HOUSE_TEXT34)
		return
	end

	if self.m_nCurNum - 1 >= 1 then
		self.m_nCurNum = self.m_nCurNum - 1
	else
		MsgBoxManager:showTipBox(LocalStrings.CHESTMINNUM)
		return
	end
	self:updateCostCount()
end

--点击兑换按钮
function WndAuctionBuy:onClickExchange(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_nWinType == 0 or self.m_nWinType == 2 or self.m_nWinType == 3 then 
		local costNum = self.m_nCurNum ~= -1 and self.m_nCurNum or 1
		local costCoinNum = self.m_ncostCount*costNum

		if self.m_ncostId == 1 or self.m_ncostId == 2 or self.m_ncostId == 70 then 
			if not JudgeMoneyIsEnough(self.m_ncostId, costCoinNum, nil, nil, nil, nil, nil, nil, nil, self, self.sureUseDiamondInstead) then 
				return
			end
		else
		    local myCostCoin = CacheCenter:getPlayerItemCountById(self.m_ncostId)
			local itemInfo = GDatatab_item["id_" .. self.m_ncostId]
			if itemInfo.main_type == 45 and itemInfo.sub_type == 2 then
				myCostCoin = SceneHolidayVillage:getItemCountByItemId(self.m_ncostId)
			end
			local name = itemInfo.name
			if costCoinNum > myCostCoin then
				if self.m_ncostId == 160139 then
					MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT129)
				else
					MsgBoxManager:showTipBox(string.format(LocalStrings.CARD_COUNT1,name))
				end
				return
			end
		end
	elseif self.m_nWinType == 1 then 
	end

	self:sureUseDiamondInstead()
end

--@brief 	确定购买
function WndAuctionBuy:sureUseDiamondInstead()
	if self.m_buyCallbackLua and self.m_buyCallbackFun then
		WZLog("WndAuctionBuy:onClickExchange", self.m_nitemId,self.m_nCurNum,self.m_nStoreId)
		self.m_buyCallbackFun(self.m_buyCallbackLua,self.m_nitemId,self.m_nCurNum,self.m_nStoreId)
		WindowManager:removeWindow(self.m_root, self, true)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
