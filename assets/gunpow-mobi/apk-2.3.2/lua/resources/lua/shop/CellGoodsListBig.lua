--CellGoodsListBig.lua
--@brief	CellGoodsListBig的UI模块
--@date		2016-12-7
--@author	binshao

-------------------------------------公有方法模块--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellGoodsListBig:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellGoodsListBig:onExit(element)
	self:_unInit()
end

-- 加载数据
function CellGoodsListBig:onLoadData(element)
    local cellElement = WZUISystem:getInstance():createElement("CellGoodsListBig")
    self.m_root:addChild(cellElement)
    self.loadEnd = true
    self:_update()

    AdaptLanguage(self)
end

--@brief  设置cell中的内容
function CellGoodsListBig:setCellAllElement(tData)
	self.cellData =  tData
	--self:_update()
end

-- 购买，根据情况弹出购买界面
function CellGoodsListBig:onClickAllBtn(buyType)
    local cellData = self.cellData
    local tag = self.m_root:getTag()
    local itemId = cellData.initData.shopItemId
    if cellData.initData.limitLeave == -1 or cellData.initData.limitLeave > 0 then
        WndShop:showShopInterfaceByTag(itemId,buyType, cellData.initData.id)
    else
        MsgBoxManager:showTipBox(LocalStrings.SHOP_DAY_LIMITED )
    end
end

-- 购买
function CellGoodsListBig:onBuy()
    WZLog("------------onBuy--------------")
    WndItemInfo:onCloseClick()
    self:onClickAllBtn(3)
end

-- 赠送
function CellGoodsListBig:onGive()
    WZLog("------------onGive--------------")
    WndItemInfo:onCloseClick()
    self:onClickAllBtn(1)
end

-- 试穿
function CellGoodsListBig:onTry()
    WZLog("------------onTry--------------")
    WndItemInfo:onCloseClick()
    WndShop:UpdatePlayerDress(self.cellData)
    WndShop:playDressAni()
end

-- 赠送，索要，购买
function CellGoodsListBig:onTips()
	if WndItemInfo.m_root ~= nil then return end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tipData = CopyTable(self.cellData.initData)
	WZLog("CellGoodsListBig:onTips",tipData.moneyId)
    local other = {interface = 2,tcell = self }
    local con = GetElement(WndShop.m_root,"conTips_WndShop",WZUIContainer)
    WndItemInfo:showInfo(self.goodItemCell.tcell.m_root,con,1,tipData,true,nil,nil,other)
end

function CellGoodsListBig:onClickbuyBtn()
    WZLog("------------onClickbuyBtn--------------")
    WndItemInfo:onCloseClick()
    self:onClickAllBtn(3)
end

---- 当前物品是限购，那么tips只有一个购买按键
---- 当前是时装，如果性别相同，那么显示 索要，赠送, 根据自己是否拥有显示购买和续费
---- 当前是时装，如果性别不同，那么显示赠送按键
function CellGoodsListBig:initTipBtnInfo()
    local tipData = CopyTable(self.cellData.initData)
	WZLog("CellGoodsListBig:initTipBtnInfo",tipData.moneyId)
    local other = {interface = 2,tcell = self }
    local con = GetElement(WndShop.m_root,"conTips_WndShop",WZUIContainer)
    WndItemInfo:showInfo(self.goodItemCell.tcell.m_root,con,1,tipData,true,nil,nil,other)
end

-- 当前物品是限购，那么tips只有一个购买按键
-- 当前是时装，如果性别相同，那么显示 索要，赠送, 根据自己是否拥有显示购买和续费
-- 当前是时装，如果性别不同，那么显示赠送按键
function CellGoodsListBig:initBottomBtn()
	do return end
    local conBuy = GetElement(self.m_root,"conDressBuy_CellGoodsListBig",WZUIContainer)
    local conGive = GetElement(self.m_root,"conDressGive_CellGoodsListBig",WZUIContainer)
    local conPropGive = GetElement(self.m_root,"conPropGive_CellGoodsListBig",WZUIContainer)
    local conProp = GetElement(self.m_root,"conPropBuy_CellGoodsListBig",WZUIContainer)

    local con = {conBuy,conGive,conPropGive,conProp }
    local index = WndShop:getCellShowType()
    WZLog("---------showIndex-------------",index)
    con[index]:setVisible(true)
end

-------------------------------------私有方法模块--------------------------------------

--@brief  更新cell界面元素
function CellGoodsListBig:_update()
	if self.m_root == nil then return end
	local cellData = self.cellData.initData
	if WndShop.m_tPromotion ~= nil then
		for i=1,#WndShop.m_tPromotion do
			local tt = WndShop.m_tPromotion[i]
			if tt.initData.id == cellData.id then
				cellData.discount = tt.initData.discount
			end
		end
	end

    --商品名字描述
    local txtDescript = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtDescript_CellGoodsList"))
    txtDescript:setText(cellData.basicInfo.name)
    txtDescript:setColor(QUALITYCOLOR[cellData.basicInfo.quality])
--txtDescript:setScale(0.8)
    --商品图标
	local conItemIcon = GetElement(self.m_root, "conItemIcon_CellGoodsList", WZUIContainer)
	local cell,tcell = CellGoodItem:createElement()
    if cell then
        cell = WZUIContainer:luaTo(cell)
        tcell:setCellGoodItem(cellData,5)
        conItemIcon:addChild(cell)
    end
    self.goodItemCell = {cell = cell, tcell = tcell }

    -- 商品类型 折扣，热， 新 等
    WZLog("CellGoodsListBig.cellData.discount=",cellData.basicInfo.id,cellData.discount)
    if cellData.discount < 10000 then
        -- 折扣标签
        local conDis = GetElement(self.m_root, "conDiscount_CellGoodsList", WZUIContainer)
        conDis:setVisible(true)

        -- 商品的折扣 = 现价/原价*10
        -- 为了方便显示，在原来的折扣上再*10，如果此时小于1，则补一个0在前面
        -- 50 显示5， 38显示38， 1 显示01
        local lab = GetElement(self.m_root, "labCnt_CelllGoodsList", WZUILabelAtlasFont)
        local dis = math.floor(cellData.discount/100) 
        WZLog("CellGoodsList:update dis big",dis)
        if dis > 10 then
            -- 整数倍时比如10，20，30，等，就取1，2，3
            local desc = dis
            if math.ceil(dis/10) == dis/10 then desc = dis/10 end
            if ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "th" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "tr" then
                lab:setText(100-dis)
            else
                lab:setText(desc)
            end
        else
            if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "tr" then
                lab:setText(100-dis)
            else
                lab:setText("0"..dis)
            end
        end

        -- 折扣不是整数，显示小数点
        if math.ceil(dis/10) ~= dis/10 or dis < 10 then
            local imgPoint = GetElement(self.m_root, "imgNumPoint_CellGoodsList", WZUIImage)
            imgPoint:setVisible(true)
            if ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "tr" then
                imgPoint:setVisible(false)
            end
        end
    else
        -- 显示热，新等商品
        local conNormal = GetElement(self.m_root, "conNormal_CellGoodsList", WZUIContainer)
        local imgTuijian = WZUIImage:luaTo(self.m_root:getChildElement("imgTuijian_CellGoodsList"))
        local txtTuijian = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtTuijian_CellGoodsList"))
        if cellData.isHot then
            conNormal:setVisible(true)
            imgTuijian:setFile("ui/common/common_icon_hot.png")
            txtTuijian:setVisible(false)
        elseif cellData.isNew then
            conNormal:setVisible(true)
            imgTuijian:setFile("ui/common/common_bq_lv.png")
            txtTuijian:setVisible(true)
        else
            conNormal:setVisible(false)
        end
    end

    -- 是否限购
    local conLimit = GetElement(self.m_root, "conLimitTxt_CellGoodsList", WZUIContainer)
    local conNotLimit = GetElement(self.m_root, "conNotLimitTxt_CellGoodsList", WZUIContainer)
    local isLimit = cellData.limitLeave ~= -1 and true or false
    conLimit:setVisible(isLimit)
    conNotLimit:setVisible(not isLimit)

    local moneyIcon = GDatatab_item["id_"..cellData.moneyId].icon
    if cellData.limitLeave ~= -1 then
        --限购个数
        local txtLimit = GetElement(self.m_root, "txtLimit_CellGoodsList", WZUILabelTTF)
        txtLimit:setText(string.format(LocalStrings.SHOP_LIMIT,cellData.limitLeave))

        -- 售罄
        if cellData.limitLeave == 0 then
            local conLimit = GetElement(self.m_root, "conSellUp_CellGoodsList", WZUIContainer)
            conLimit:setVisible(true)
        end

        local imgMoney = GetElement(self.m_root,"imgMoneyLimit_CellGoodsList",WZUIImage)
        imgMoney:setFile(moneyIcon)

        WZLog("----------------555-----------------------",cellData.moneyId)

        --商品价格
        local txtCost = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtCostLimit_CellGoodsList"))
		local discount = cellData.discount
		local showPrice = math.ceil(cellData.floorPrice*discount/10000)
		if discount ~= 10000 and showPrice == cellData.floorPrice then
			showPrice = showPrice - 1
		end
        txtCost:setText(showPrice)
    else
        local imgMoney = GetElement(self.m_root,"imgMoneyNotLimit_CellGoodsList",WZUIImage)
        imgMoney:setFile(moneyIcon)

        --商品价格
        local txtCost = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtCostNotLimit_CellGoodsList"))
		local discount = cellData.discount
		local showPrice = math.ceil(cellData.floorPrice*discount/10000)
		if discount ~= 10000 and showPrice == cellData.floorPrice then
			showPrice = showPrice - 1
		end
        txtCost:setText(showPrice)
    end

    -- 试穿状态
    local con = GetElement(self.m_root, "conSelFlag_CellGoodsList", WZUIContainer)
    con:setVisible(self.tryState)
	if cellData.basicInfo.main_type ~= 5 then
    	con:setVisible(false)
	end

    -- 选中状态
    local con = GetElement(self.m_root, "conSel_CellGoodsList", WZUIContainer)
    con:setVisible(self.selState)

    -- 限购
    local txtLimit = GetElement(self.m_root, "txtLimit_CellGoodsList", WZUILabelTTF)
    if cellData.limitLeave ~= -1 then
        txtLimit:setVisible(true)
        txtLimit:setText(string.format(LocalStrings.SHOP_LIMIT,cellData.limitLeave))

        if cellData.limitLeave == 0 then
            local conLimit = GetElement(self.m_root, "conSellUp_CellGoodsList", WZUIContainer)
            conLimit:setVisible(true)
        end
    else
        txtLimit:setVisible(false)
    end

	WZLog("CellGoodsListBig:_update", cellData.basicInfo.id, WndFastGetItems.m_nShopTipItemId)
	if WndFastGetItems.m_nShopTipItemId ~= nil and cellData.basicInfo.id == WndFastGetItems.m_nShopTipItemId then
		WZLog("显示tips:", cellData.basicInfo.name)
		WndFastGetItems.m_nShopTipItemId = nil
    	local tipData = CopyTable(self.cellData.initData)
    	local other = {interface = 2,tcell = self }
    	local con = GetElement(WndShop.m_root,"conTips_WndShop",WZUIContainer)
    	WndItemInfo:showInfo(self.goodItemCell.tcell.m_root,con,1,tipData,true,nil,nil,other)
	end
end

--@brief 设置试穿图片的显示状态
function CellGoodsListBig:SetPropSelState(bVisible)
    self.tryState = bVisible
    if self.loadEnd == false then return end
    local con = GetElement(self.m_root, "conSelFlag_CellGoodsList", WZUIContainer)
    con:setVisible(bVisible)
end

function CellGoodsListBig:setCellSel(bVisible)
    self.selState = bVisible
    if self.loadEnd == false then return end
    local con = GetElement(self.m_root, "conSel_CellGoodsList", WZUIContainer)
    con:setVisible(bVisible)
end

-- 设置显示限购次数
function CellGoodsListBig:SetLimitCount()
    if self.loadEnd == false then return end

    local data = self.cellData.initData
    local txtLimit = GetElement(self.m_root, "txtLimit_CellGoodsList", WZUILabelTTF)
    if data.limitLeave ~= -1 then
        txtLimit:setVisible(true)
        txtLimit:setText(string.format(LocalStrings.SHOP_LIMIT,data.limitLeave))
        WZLog("----------cell list tag-----------",data.limitLeave,self.m_root:getTag())

        if data.limitLeave == 0 then
            local conLimit = GetElement(self.m_root, "conSellUp_CellGoodsList", WZUIContainer)
            conLimit:setVisible(true)
        end
    else
        txtLimit:setVisible(false)
    end
end

function CellGoodsListBig:_haveFlag()
    local equip = CacheCenter:getPlayerItems()
    for k,v in pairs(equip) do
        if v.maintype == 5 and v.id == self.cellData.initData.shopItemId then
            return true
        end
    end
    return false
end

-------------------------语言适配Begin-------------------------

function CellGoodsListBig:_adaptLanguage_th(  )
    local labCnt = GetElement(self.m_root,"labCnt_CelllGoodsList",WZUILabelAtlasFont)
    labCnt:setRelativePosition(GlobalMethod:ccp(0.566842,0.185294))
    labCnt:setScale(0.75)
    local imgOff = GetElement(self.m_root, "imgOff_CelllGoodsList", WZUIImage)
    imgOff:setRelativePosition(GlobalMethod:ccp(0.817093,0.464855))
    imgOff:setScale(0.8)
    local imgPoint = GetElement(self.m_root, "imgNumPoint_CellGoodsList", WZUIImage)
    imgPoint:setRelativePosition(GlobalMethod:ccp(0.630602,0.136365))

    local txtLimit = GetElement(self.m_root,"txtLimit_CellGoodsList",WZUILabelTTF)
    txtLimit:setFontSize(18)
    local txtDescript = GetElement(self.m_root,"txtDescript_CellGoodsList",WZUILabelTTF)
    txtDescript:setFontSize(18)


end

function CellGoodsListBig:_adaptLanguage_en(  )
    local labCnt = GetElement(self.m_root,"labCnt_CelllGoodsList",WZUILabelAtlasFont)
    labCnt:setRelativePosition(GlobalMethod:ccp(0.566842,0.185294))
    labCnt:setScale(0.75)
    local imgOff = GetElement(self.m_root, "imgOff_CelllGoodsList", WZUIImage)
    imgOff:setRelativePosition(GlobalMethod:ccp(0.817093,0.464855))
    imgOff:setScale(0.8)
    local imgPoint = GetElement(self.m_root, "imgNumPoint_CellGoodsList", WZUIImage)
    imgPoint:setRelativePosition(GlobalMethod:ccp(0.630602,0.136365))
    
    GetElement(self.m_root,"txtCostLimit_CellGoodsList",WZUILabelTTF):setFontSize(16)
    GetElement(self.m_root,"txtLimit_CellGoodsList",WZUILabelTTF):setFontSize(14)
    local txtDescript = GetElement(self.m_root,"txtDescript_CellGoodsList",WZUILabelTTF)
    txtDescript:setFontSize(18)
end

function CellGoodsListBig:_adaptLanguage_vn(  )
    local labCnt = GetElement(self.m_root,"labCnt_CelllGoodsList",WZUILabelAtlasFont)
    labCnt:setScale(0.9)
    local imgOff = GetElement(self.m_root, "imgOff_CelllGoodsList", WZUIImage)
    imgOff:setScale(0.9)

    local txtLimit = GetElement(self.m_root,"txtLimit_CellGoodsList",WZUILabelTTF)
    txtLimit:setFontSize(18)
end

function CellGoodsListBig:_adaptLanguage_pt(  )
    local labCnt = GetElement(self.m_root,"labCnt_CelllGoodsList",WZUILabelAtlasFont)
    labCnt:setScale(0.5)
    labCnt:setRelativePosition(GlobalMethod:ccp(0.475804,0.132894))
    local imgOff = GetElement(self.m_root, "imgOff_CelllGoodsList", WZUIImage)
    imgOff:setScale(0.6)
    imgOff:setRelativePosition(GlobalMethod:ccp(0.759565,0.433622))

    
    GetElement(self.m_root,"txtCostLimit_CellGoodsList",WZUILabelTTF):setFontSize(16)
    GetElement(self.m_root,"txtLimit_CellGoodsList",WZUILabelTTF):setFontSize(14)
    local txtDescript = GetElement(self.m_root,"txtDescript_CellGoodsList",WZUILabelTTF)
    txtDescript:setScale(0.65)
    txtDescript:setDimensions(GlobalMethod:CCSize(220))
end

function CellGoodsListBig:_adaptLanguage_es(  )
    local txtDescript = GetElement(self.m_root,"txtDescript_CellGoodsList",WZUILabelTTF)
    txtDescript:setScale(0.65)
    txtDescript:setDimensions(GlobalMethod:CCSize(220))
    GetElement(self.m_root,"txtCostLimit_CellGoodsList",WZUILabelTTF):setFontSize(16)
    GetElement(self.m_root,"txtLimit_CellGoodsList",WZUILabelTTF):setFontSize(14)

    local labCnt = GetElement(self.m_root,"labCnt_CelllGoodsList",WZUILabelAtlasFont)
    labCnt:setRelativePosition(GlobalMethod:ccp(0.57,0.185294))
    labCnt:setScale(0.75)

    local imgOff = GetElement(self.m_root, "imgOff_CelllGoodsList", WZUIImage)
    imgOff:setRelativePosition(GlobalMethod:ccp(0.82,0.464855))
    imgOff:setScale(0.8)
end

function CellGoodsListBig:_adaptLanguage_tr()
    GetElement(self.m_root,"txtLimit_CellGoodsList",WZUILabelTTF):setFontSize(16)
    GetElement(self.m_root,"txtDescript_CellGoodsList",WZUILabelTTF):setFontSize(18)

    local labCnt = GetElement(self.m_root,"labCnt_CelllGoodsList",WZUILabelAtlasFont)
    labCnt:setRelativePosition(GlobalMethod:ccp(0.528696,0.134659))
    labCnt:setScale(0.7)

end

function CellGoodsListBig:_adaptLanguage_ug(  )
    local labCnt = GetElement(self.m_root,"labCnt_CelllGoodsList",WZUILabelAtlasFont)
    labCnt:setRelativePosition(GlobalMethod:ccp(0.566842,0.185294))
    labCnt:setScale(0.75)
    local imgOff = GetElement(self.m_root, "imgOff_CelllGoodsList", WZUIImage)
    imgOff:setRelativePosition(GlobalMethod:ccp(0.817093,0.464855))
    imgOff:setScale(0.8)
    local imgPoint = GetElement(self.m_root, "imgNumPoint_CellGoodsList", WZUIImage)
    imgPoint:setRelativePosition(GlobalMethod:ccp(0.630602,0.136365))
    
    GetElement(self.m_root,"txtCostLimit_CellGoodsList",WZUILabelTTF):setFontSize(16)
    GetElement(self.m_root,"txtLimit_CellGoodsList",WZUILabelTTF):setFontSize(14)
    local txtDescript = GetElement(self.m_root,"txtDescript_CellGoodsList",WZUILabelTTF)
    txtDescript:setFontSize(18)
end
-------------------------语言适配End---------------------------