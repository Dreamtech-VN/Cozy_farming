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
function CellCommunityShop:setCellShop(itemInfo, storeID, id, num, cost,costID,discount)
	if self.m_root == nil then
		return
	end

	self.m_tItemInfo = itemInfo
	self.m_nStoreID = storeID
	self.m_nID = id
	self.m_nCostCount = cost
	self.m_nNum = num
	self.m_nCostId = costID
	self.m_nDiscount = discount
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
	GetElement(self.m_root, "txtName_CellGoodsList", WZUILabelTTF):setText(name)
	GetElement(self.m_root, "txtName_CellGoodsList", WZUILabelTTF):setColor(QUALITYCOLOR[GDatatab_item[key].quality])
	--价格图标
	if tonumber(costID) == 1 then
		GetElement(self.m_root,"imgMoney_CellGoodsList",WZUIImage):setFile("ui/common/common_icon_zuanshi.png")	
		GetElement(self.m_root,"imgMoney_CellGoodsList",WZUIImage):setScale(0.75)
	elseif tonumber(costID) == 2 then
		GetElement(self.m_root,"imgMoney_CellGoodsList",WZUIImage):setFile("ui/common/common_icon_jinbi.png")	
		GetElement(self.m_root,"imgMoney_CellGoodsList",WZUIImage):setScale(0.75)
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
	if tonumber(discount) ~= nil and discount < 10 then     --输入全是数字
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
	WZLog("CellCommunityShop:onClickBuy",self.m_nID)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local costCount = math.ceil(self.m_nCostCount*self.m_nDiscount/10)
    WndBuyMultipleItem:show(self.m_nID,self.m_nNum,self.m_nCostId,costCount,self.m_nStoreID,self,self.onClickbuyBtn)
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
	
	WndStore:showLoadingB()
	ProtocolProcessorStore:send_GUILD_BuyGuildStore(nStoreId,nNum)
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
---------------------------------语言适配End---------------------------------------------