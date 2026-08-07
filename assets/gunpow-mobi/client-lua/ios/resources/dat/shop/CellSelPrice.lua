--CellSelPrice.lua
--@brief	CellSelPrice的UI模块
--@date		2015-5-26
--@author	binshao
--@note		商城道具g购买的cell模块


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellSelPrice:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellSelPrice:onExit(element)
	self:_unInit()
end

-- 获得当前cell的选中状态，如果没选中，则价格为0，选中默认最低价格
function CellSelPrice:OnCheckSel(element)
    self.selState = not self.selState
    local imgNO = GetElement(self.m_root, "imgNoSel_CellSelPrice", WZUI9Image)
    local imgNO1 = GetElement(self.m_root, "imgNoSel1_CellSelPrice", WZUI9Image)
    imgNO:setVisible(not self.selState)
    imgNO1:setVisible(not self.selState)
    if self.selState then
        self:_setCheckboxPriceIndex({1,0,0})
        self:SetCurPropPrice(self.m_tPrice[1].price)
        self.m_curData.index = 0
    else
        self:_setCheckboxPriceIndex({0,0,0})
        self:SetCurPropPrice(0)
        self.m_curData.index = -1
    end
end

-- 点击第1个checkbox
function CellSelPrice:OnCheckType1(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local checkbox = GetElement(self.m_root,"checkboxPrice1_CellSelPrice",WZUICheckBox)
    local index = checkbox:getCheckIndex()
    local price = index == 0 and 0 or self.m_tPrice[1].price
    self:SetCurPropPrice(price)

    if index == 1 then
        self.m_curData.index = 0
        local tIndex = {1,0,0}
        self:_setCheckboxPriceIndex(tIndex)
    end
end

-- 点击第2个checkbox
function CellSelPrice:OnCheckType2(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local checkbox = GetElement(self.m_root,"checkboxPrice2_CellSelPrice",WZUICheckBox)
    local index = checkbox:getCheckIndex()
    local price = index == 0 and 0 or self.m_tPrice[2].price
    self:SetCurPropPrice(price)

    if index == 1 then
        self.m_curData.index = 1
        local tIndex = {0,1,0}
        self:_setCheckboxPriceIndex(tIndex)
    end
end

-- 点击第3个checkbox
function CellSelPrice:OnCheckType3(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local checkbox = GetElement(self.m_root,"checkboxPrice3_CellSelPrice",WZUICheckBox)
    local index = checkbox:getCheckIndex()
    local price = index == 0 and 0 or self.m_tPrice[3].price
    self:SetCurPropPrice(price)

    if index == 1 then
        self.m_curData.index = 2
        local tIndex = {0,0,1}
        self:_setCheckboxPriceIndex(tIndex)
    end
end

-- 获取当前商品的价格
function CellSelPrice:GetCurPropPrice()
    return self.m_nCurPrice
end

-- 设置当前商品的价格
function CellSelPrice:SetCurPropPrice(price)
    self.m_nCurPrice = price
    -- 如果价格为0，表示当前没有选中商品
    if price == 0 then self.m_curData.index = -1 end

    self.m_tCallBackFunc[2](self.m_tCallBackFunc[1])
end

function CellSelPrice:getMoneyId()
    return self.m_propData.initData.moneyId
end

function CellSelPrice:GetCurData()
    return self.m_curData
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
-- 更新
function CellSelPrice:_update()
    self:_setPropIcon()
    self:_initAllCheckBoxIndex()
    self:_setPropInfo()
end

-- 设置商品的图标
function CellSelPrice:_setPropIcon()
    local conIcon = WZUIContainer:luaTo(self.m_root:getChildElement("conItem_CellSelPrice"))
    local celElement,tLuaObj = CellGoodItem:createElement()
    if celElement ~= nil then
        celElement = WZUIContainer:luaTo(celElement)
        tLuaObj:setSZBg()
        tLuaObj:setCellGoodItem(self.m_propData.initData,14)
        conIcon:addChild(celElement)
    end
end

-- 设置cell上的商品信息
function CellSelPrice:_setPropInfo()
    local propData = self.m_propData.initData
    local agingPrice = json.decode(propData.agingPrice)
	local discount = self.m_propData.initData.discount

    -- 存钱商品的价格等信息
    local index = 1
    for i = 0, 2 do
        local data = agingPrice[tostring(i)]
        WZLog("--------------iii-------------",i,data)
        if data then
            for k,v in pairs(data) do
                self.m_tPrice[index] = {day = tonumber(k) , price = math.ceil(tonumber(v)*discount/10000) }
            end
        end
        index = index + 1
    end

    -- 设置cell上的天数，价格，钻石UI信息
    WZLog("--------------#self.m_tPrice---------------",#self.m_tPrice)
    for i = 1, #self.m_tPrice do
        local checkbox = WZUICheckBox:luaTo(self.m_root:getChildElement("checkboxPrice"..i.."_CellSelPrice"))
        checkbox:setVisible(true)

        local conDesc = WZUIContainer:luaTo(self.m_root:getChildElement("conDesc"..i.."_CellSelPrice"))
        conDesc:setVisible(true)

        -- 标志无限制时装还是时效时装
        local day =  WZUILabelTTF:luaTo(self.m_root:getChildElement("txtDay"..i.."_CellSelPrice"))
        if CacheCenter:getGameParam().gameStatus == "1" then
            if self.m_tPrice[i].day ~= -1 then
                day:setText(self.m_tPrice[i].day..LocalStrings.DAY)
            else
                day:setText("1"..LocalStrings.SHOP_IND)
            end
        else
            if self.m_tPrice[i].day ~= -1 then
                day:setText(self.m_tPrice[i].day..LocalStrings.DAY)
            else
                day:setText(LocalStrings.NOLIMIT)
            end
        end

        local price =  WZUILabelTTF:luaTo(self.m_root:getChildElement("txtPrice"..i.."_CellSelPrice"))
        price:setText(self.m_tPrice[i].price)
		--货币图标
		GetElement(self.m_root,"imgIcon"..i.."_CellSelPrice",WZUI9Image):setFile(GDatatab_item["id_"..self:getMoneyId()].icon)
    end

	--WZLog("CellSelPrice:_setPropInfo", Serialize(self.m_tPrice))
    self.m_nCurPrice = self.m_tPrice[1].price

    local txtName = GetElement(self.m_root,"txtShopName_CellSelPrice",WZUILabelTTF)
    txtName:setText(propData.basicInfo.name)
    txtName:setColor(QUALITYCOLOR[propData.basicInfo.quality])
end

-- 设置选择商品类型的checkbox状态
function CellSelPrice:_setCheckboxPriceIndex(t_index)
    for i = 1, 3 do
        local checkbox = GetElement(self.m_root,"checkboxPrice"..i.."_CellSelPrice",WZUICheckBox)
        checkbox:setCheckIndex(t_index[i])
    end
end


-- 初始化checkbox 的状态
function CellSelPrice:_initAllCheckBoxIndex()
    local group_index = {1,0,0 }
    self:_setCheckboxPriceIndex(group_index)
end

function CellSelPrice:_adaptLanguage_vn()
    WZLog("CellSelPrice:_adaptLanguage_vn ")
    GetElement(self.m_root,"txtShopName_CellSelPrice",WZUILabelTTF):setFontSize(15)
end

function CellSelPrice:_adaptLanguage_en(  )
    local txtShopName = GetElement(self.m_root,"txtShopName_CellSelPrice",WZUILabelTTF)
    txtShopName:setFontSize(14)
    txtShopName:setDimensions(GlobalMethod:CCSize(120,0))
    txtShopName:setRelativePosition(GlobalMethod:ccp(0.5,-0.0803573))
end

function CellSelPrice:_adaptLanguage_th(  )
    GetElement(self.m_root,"txtShopName_CellSelPrice",WZUILabelTTF):setFontSize(16)
end

function CellSelPrice:_adaptLanguage_pt(  )
    local txtShopName = GetElement(self.m_root,"txtShopName_CellSelPrice",WZUILabelTTF)
    txtShopName:setFontSize(13)
    txtShopName:setDimensions(GlobalMethod:CCSize(140,0))
    txtShopName:setRelativePosition(GlobalMethod:ccp(0.5,-0.05))

    for i=1,3 do
        -- local labCnt = GetElement(self.m_root,"labCnt"..i.."_CellSelPrice",WZUILabelAtlasFont)
        -- labCnt:setScale(0.5)
        -- labCnt:setRelativePosition(GlobalMethod:ccp(0.475804,0.132894))
        -- local imgCnt = GetElement(self.m_root, "imgCnt"..i.."_CellSelPrice", WZUIImage)
        -- imgCnt:setScale(0.6)
        -- imgCnt:setRelativePosition(GlobalMethod:ccp(0.759565,0.433622))

        GetElement(self.m_root,"txtDay"..i.."_CellSelPrice",WZUILabelTTF):setFontSize(22)
    end

end

function CellSelPrice:_adaptLanguage_tr()
    local txtShopName = GetElement(self.m_root,"txtShopName_CellSelPrice",WZUILabelTTF)
    txtShopName:setFontSize(14)
    txtShopName:setDimensions(GlobalMethod:CCSize(120,0))
    txtShopName:setRelativePosition(GlobalMethod:ccp(0.5,-0.0803573))
end

function CellSelPrice:_adaptLanguage_es(  )
    local txtShopName = GetElement(self.m_root,"txtShopName_CellSelPrice",WZUILabelTTF)
    txtShopName:setFontSize(13)
    txtShopName:setDimensions(GlobalMethod:CCSize(140,0))
    txtShopName:setRelativePosition(GlobalMethod:ccp(0.5,-0.05))

    for i=1,3 do
        -- local labCnt = GetElement(self.m_root, "labCnt"..i.."_CellSelPrice", WZUILabelAtlasFont)
        -- labCnt:setScale(0.5)
        -- labCnt:setRelativePosition(GlobalMethod:ccp(0.48,0.132894))
        -- local imgCnt = GetElement(self.m_root, "imgCnt"..i.."_CellSelPrice", WZUIImage)
        -- imgCnt:setScale(0.6)
        -- imgCnt:setRelativePosition(GlobalMethod:ccp(0.76,0.433622))

        GetElement(self.m_root,"txtDay"..i.."_CellSelPrice",WZUILabelTTF):setFontSize(22)
    end
end
-------------------------------------私有方法模块End----------------------------------------