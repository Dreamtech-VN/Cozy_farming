--CellCommunityShop.lua
--@brief	CellCommunityShop的UI模块
--@date		2015/04/28
--@author	zsq
--@note		公会商店Cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCommunityShop:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCommunityShop:onExit(element)
	self:_unInit()
end

--更新物品数量
function CellCommunityShop:updateStoreNum(storeNum)
	WZLog("CellCommunityShop:updateStoreNum =",storeNum)
	self.m_nNum = storeNum
	local conItemIcon = GetElement(self.m_root, "conItemIcon", WZUIContainer)
	conItemIcon:removeAllChildrenWithCleanup(true)
	local key = "id_"..self.m_nID
    local name = GDatatab_item[key].name
    local path = GDatatab_item[key].icon 
    local num =  num 
    local quality = GDatatab_item[key].quality
    local itemInfo = {name=name,icon=path,lastTime=self.m_nNum,lastNum=self.m_nNum,quality=quality,basicInfo=CopyTable(GDatatab_item[key]),isZero = true} 
	local celElement,tLuaObj = CellGoodItem:createElement()
    if celElement ~= nil then 
        celElement = WZUIContainer:luaTo(celElement)
        tLuaObj:setCellGoodItem(itemInfo,5)
    	tLuaObj:setItemClickFun(self,self.onClickBuy)
        tLuaObj:_showItemNum()
        conItemIcon:addChild(celElement)
	end
end

--@brief	设置格子显示
function CellCommunityShop:setCellShop(itemInfo, storeID, id, num, cost, costID, discount, openLevel)
	if self.m_root == nil then
		return
	end
	if itemInfo == nil then 
		GetElement(self.m_root, "conWait_CellCommunityShop", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "txtCost1_CellCommunityShop", WZUILabelTTF):setVisible(false)
		return 
	end

	self.m_tItemInfo = itemInfo
	self.m_nStoreID = storeID
	self.m_nID = id
	self.m_nCostCount = cost
	self.m_nNum = num
	self.m_nCostId = costID
	self.m_nDiscount = discount
	self.m_nOpenLevel = openLevel or 1
    local key = "id_"..self.m_nID
    local name = GDatatab_item[key].name
    local path = GDatatab_item[key].icon 
    local num =  num 
    local quality = GDatatab_item[key].quality
    local itemInfo = {name=name,icon=path,lastTime=self.m_nNum,lastNum=self.m_nNum,quality=quality,basicInfo=CopyTable(GDatatab_item[key]),isZero = true} 
    --商品图标
	local conItemIcon = GetElement(self.m_root, "conItemIcon", WZUIContainer)
	local celElement,tLuaObj = CellGoodItem:createElement()
    if celElement ~= nil then 
        celElement = WZUIContainer:luaTo(celElement)
        tLuaObj:setCellGoodItem(itemInfo,5)
    	tLuaObj:setItemClickFun(self,self.onClickBuy)
        tLuaObj:_showItemNum()
        conItemIcon:addChild(celElement)
	end
	--商品名称
	local txtName = GetElement(self.m_root, "txtName_CellGoodsList", WZUILabelTTF)
	txtName:setText(name)
	txtName:setColor(QUALITYCOLOR[GDatatab_item[key].quality])
	--价格图标
	local imgMoney = GetElement(self.m_root,"imgMoney_CellGoodsList",WZUIImage)
	if tonumber(costID) == 1 then
		imgMoney:setFile("ui/common/common_icon_zuanshi.png")	
		imgMoney:setScale(0.75)
	elseif tonumber(costID) == 2 then
		imgMoney:setFile("ui/common/common_icon_jinbi.png")	
		imgMoney:setScale(0.75)
	end
	if self.m_nShowType ~= 1 then 
		local moneyIcon = GDatatab_item["id_" .. costID].icon 	
		imgMoney:setFile(moneyIcon)	
		imgMoney:setScale(0.45)
		GetElement(self.m_root, "txtCost1_CellCommunityShop", WZUILabelTTF):setTextKey("")
		GetElement(self.m_root, "txtCost1_CellCommunityShop", WZUILabelTTF):setText("")
		GetElement(self.m_root, "txtCost1_CellCommunityShop", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.27, 0.091))
		GetElement(self.m_root, "txtNum_CellGoodsList", WZUILabelTTF):setScale(2)
	end
	if self.m_nShowType == 5 then 
		if self.m_nOpenLevel <= CacheCenter:getPlayerInfo().level then 
			GetElement(self.m_root, "conLock_CellCommunityShop", WZUIContainer):setVisible(false)
		else
			GetElement(self.m_root, "conLock_CellCommunityShop", WZUIContainer):setVisible(true)
			GetElement(self.m_root, "txtOpenLv_CellCommunityShop", WZUILabelTTF):setText(string.format(LocalStrings.UPGRADE_LEVEL_UNREACHED, self.m_nOpenLevel))
		end
	elseif self.m_nShowType == 6 then 
		txtName:setRelativePosition(GlobalMethod:ccp(0.5, 0.85))
		if self.m_tItemInfo.limitNum == -1 then 
			GetElement(self.m_root, "txtLimitNum_CellGoodsList", WZUILabelTTF):setText(LocalStrings.UNLIMITED_PURCHASE)
		else
			GetElement(self.m_root, "txtLimitNum_CellGoodsList", WZUILabelTTF):setText(LocalStrings.PEOPLE_SHOP_TEXT11 .. self.m_tItemInfo.canBuys .. "/" .. self.m_tItemInfo.limitNum)
		end
	end
	--商品价格
	GetElement(self.m_root, "txtNum_CellGoodsList", WZUILabelTTF):setText(cost)
	
	--商品折扣
	self:setDiscount(discount)
end

--@brief	设置折扣
function CellCommunityShop:setDiscount(discount)
	WZLog("CellCommunityShop:setDiscount = ",discount)
	self.m_nDiscount = discount
	if discount and tonumber(discount) ~= nil and discount < 10 then     --输入全是数字
		GetElement(self.m_root, "conDiscount_CellCommunityShop", WZUIContainer):setVisible(true)
		local setInput = tonumber(discount)		
		--输入是小数或负数
		if (math.floor(setInput) < setInput) or (setInput < 0) or setInput >= 100 then
			if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "tr" then
				GetElement(self.m_root, "labCnt_CelllCommunityShop", WZUILabelAtlasFont):setText(100-setInput*10)
			else 
				GetElement(self.m_root, "labCnt_CelllCommunityShop", WZUILabelAtlasFont):setText(setInput*10)
			end
	  	else
			GetElement(self.m_root, "labCnt_CelllCommunityShop", WZUILabelAtlasFont):setText(setInput)
	  	end
	  	if ProjConfig.LANGUAGE == "vn" then
			GetElement(self.m_root, "labCnt_CelllCommunityShop", WZUILabelAtlasFont):setText(100-setInput*10)
		end
		-- -- 东南亚setInput*10 
		-- if ProjConfig.LANGUAGE == "en" then
		-- 	GetElement(self.m_root, "labCnt_CelllCommunityShop", WZUILabelAtlasFont):setText(setInput*10)
		-- 	GetElement(self.m_root,"imgNumPoint_CellCommunityShop",WZUIImage):setVisible(true)
		-- end
		-- 美洲100-setInput*10
		if ProjConfig.LANGUAGE == "en" then
			GetElement(self.m_root, "labCnt_CelllCommunityShop", WZUILabelAtlasFont):setText(100-setInput*10)
		end
		if ProjConfig.LANGUAGE == "th" then
			GetElement(self.m_root,"imgNumPoint_CellCommunityShop",WZUIImage):setVisible(true)
		end
	else  
		GetElement(self.m_root, "conDiscount_CellCommunityShop", WZUIContainer):setVisible(false)
	end

end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	点击购买按钮
function CellCommunityShop:onClickBuy(element)
	if WndItemInfo.m_root ~= nil then return end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nTag = element:getTag()
	WZLog("CellCommunityShop:onClickBuy",self.m_nID, nTag)
	if self.m_nShowType == 5 and nTag == 2 then 
		MsgBoxManager:showTipBox(string.format(LocalStrings.UPGRADE_LEVEL_UNREACHED, self.m_nOpenLevel))
		return 
	end
	local costCount = math.ceil(self.m_nCostCount*self.m_nDiscount/10)

	local limitNum = self.m_tItemInfo.limitNum
	local tLimitConfig = nil 
	if self.m_nShowType == 5 then 
		limitNum = 100
	elseif self.m_nShowType == 6 then 
		if limitNum ~= -1 then 
			limitNum = self.m_tItemInfo.canBuys
			tLimitConfig = {self.m_tItemInfo.limitNum}
		else
			limitNum = 100
		end
		if limitNum <= 0 then 
			MsgBoxManager:showTipBox(LocalStrings.SHOP_DAY_LIMITED)
			return 
		end
	end
    WndBuyMultipleItem:show(self.m_nID, self.m_nNum, self.m_nCostId, costCount, self.m_nStoreID, self, self.onClickbuyBtn, self.m_nShowType, limitNum, tLimitConfig)
end

--@brief	点击购买回调
function CellCommunityShop:onClickbuyBtn(itemId,nNum,nStoreId)
	if WndItemInfo.m_root ~= nil then return end
	WZLog("CellCommunityShop:onClickbuyBtn",nStoreId,nNum)
	if self.m_root == nil then return end
	--背包已满
	if CacheCenter:getRemainAmount() <= 0 then
		MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
		return
	end
	
	if self.m_nShowType == 5 then
		ProtocolProcessorTaboo:send_ZONE_BuyProduct(nStoreId, nNum)
	elseif self.m_nShowType == 6 then
		ProtocolProcessorFootMark:send_FOOTMARK_BuyFootMarkCityShopItem(nStoreId, nNum)
	else
		WndStore:showLoadingB()
		ProtocolProcessorStore:send_GUILD_BuyGuildStore(nStoreId, nNum)
	end
end

--@brief	点击确定充值回调
function CellCommunityShop:clickSureMoney()
	PassportSdkManager:gotoPaymentPage()
end

--@brief    购买金币框
--@param    nResType:响应类型(超时，确定，取消)
function CellCommunityShop:buyGold(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndBuyActivity:showBuyInterface(26)
    end
end
-------------------------------------私有方法模块End----------------------------------------
---------------------------------语言适配Begin-------------------------------------------
function CellCommunityShop:_adaptLanguage_en(  )
	local labCnt = GetElement(self.m_root, "labCnt_CelllCommunityShop", WZUILabelAtlasFont)
	labCnt:setScale(0.6)
	labCnt:setRelativePosition(GlobalMethod:ccp(0.583075,0.250379))
	local imgCnt = GetElement(self.m_root, "imgCnt_CellCommunityShop", WZUIImage)
	imgCnt:setScale(0.6)
	imgCnt:setRelativePosition(GlobalMethod:ccp(0.759565,0.422633))
end

function CellCommunityShop:_adaptLanguage_pt(  )
	local txtName = GetElement(self.m_root,"txtName_CellGoodsList",WZUILabelTTF)
	txtName:setMaxLength(40)
	txtName:setScale(0.8)
	txtName:setDimensions(GlobalMethod:CCSize(200,0))
	txtName:setRelativePosition(GlobalMethod:ccp(0.5,0.817033))

	local labCnt = GetElement(self.m_root, "labCnt_CelllCommunityShop", WZUILabelAtlasFont)
	labCnt:setScale(0.5)
	labCnt:setRelativePosition(GlobalMethod:ccp(0.515278,0.206423))
	local imgCnt = GetElement(self.m_root, "imgCnt_CellCommunityShop", WZUIImage)
	imgCnt:setScale(0.6)
	imgCnt:setRelativePosition(GlobalMethod:ccp(0.759565,0.433622))

	GetElement(self.m_root, "imgMoney_CellGoodsList", WZUIImage):setRelativePosition(GlobalMethod:ccp(1.1,0.5))
	GetElement(self.m_root, "txtNum_CellGoodsList", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(1.2,0.5))
end

function CellCommunityShop:_adaptLanguage_tr(  )	
	local txtName = GetElement(self.m_root,"txtName_CellGoodsList",WZUILabelTTF)
	txtName:setMaxLength(40)
	txtName:setScale(0.8)
	txtName:setDimensions(GlobalMethod:CCSize(200,0))
	txtName:setRelativePosition(GlobalMethod:ccp(0.5,0.817033))

	local labCnt = GetElement(self.m_root, "labCnt_CelllCommunityShop", WZUILabelAtlasFont)
	labCnt:setScale(0.5)
	labCnt:setRelativePosition(GlobalMethod:ccp(0.515278,0.206423))
	
	local imgCnt = GetElement(self.m_root, "imgCnt_CellCommunityShop", WZUIImage)
	imgCnt:setScale(0.6)
	imgCnt:setRelativePosition(GlobalMethod:ccp(0.759565,0.433622))
end

function CellCommunityShop:_adaptLanguage_es(  )
	local txtName = GetElement(self.m_root,"txtName_CellGoodsList",WZUILabelTTF)
	txtName:setScale(0.8)
	txtName:setDimensions(GlobalMethod:CCSize(200,0))
	txtName:setRelativePosition(GlobalMethod:ccp(0.5,0.817))

	local labCnt = GetElement(self.m_root, "labCnt_CelllCommunityShop", WZUILabelAtlasFont)
	labCnt:setScale(0.8)
	labCnt:setRelativePosition(GlobalMethod:ccp(0.555,0.23))

	local imgCnt = GetElement(self.m_root, "imgCnt_CellCommunityShop", WZUIImage)
	imgCnt:setScale(0.8)
	imgCnt:setRelativePosition(GlobalMethod:ccp(0.816,0.47))
end

function CellCommunityShop:_adaptLanguage_ug(  )	
	local txtName = GetElement(self.m_root,"txtName_CellGoodsList",WZUILabelTTF)
	txtName:setMaxLength(40)
	txtName:setScale(0.8)
	txtName:setDimensions(GlobalMethod:CCSize(200,0))
	txtName:setRelativePosition(GlobalMethod:ccp(0.5,0.817033))
end

function CellCommunityShop:_adaptLanguage_vn(  )
    local txtPropName = GetElement(self.m_root,"txtName_CellGoodsList",WZUILabelTTF)
    txtPropName:setDimensions(GlobalMethod:CCSize(150))
    txtPropName:setFontSize(14)
end
---------------------------------语言适配End---------------------------------------------