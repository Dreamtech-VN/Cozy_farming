--CellCardShopItem.lua
--@brief	CellCardShopItem的UI模块
--@date		2016/07/26
--@author	Tianxiang_Xu
--@note		卡牌系统-卡片


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCardShopItem:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCardShopItem:onExit(element)
	self:_unInit()
end

--@brief    点击购买回调
function CellCardShopItem:onClickbuyBtn()
    WZLog("CellCardShopItem:onClickbuyBtn")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    CellCardShopItem.m_current = self
    local costInfo = SplitStringWithSeparator(self.tData[3],",")
    local costDis = self:getDisPrice(tonumber(costInfo[2]),self.tData[4])
    if JudgeMoneyIsEnough(costInfo[1],costDis,nil,nil,8, nil, nil, nil, nil, CellCardShopItem.m_current, CellCardShopItem.m_current.sureUseDiamondInstead) then
        CellCardShopItem.m_current:sureUseDiamondInstead()
    end
end

--@brief    确认用钻石代替礼券购买
function CellCardShopItem:sureUseDiamondInstead()
    -- body
    WZLog("CellCardShopItem:sureUseDiamondInstead =",CellCardShopItem.m_current.tData[1])
    WndStore:showLoadingB()
    WndStore:setItemTag(CellCardShopItem.m_current.m_root:getTag())
    ProtocolProcessorStore:send_CARD_BuyCard(CellCardShopItem.m_current.tData[1])
end

--@brief    设置折扣
function CellCardShopItem:setDiscount(discount)
    WZLog("CellCardShopItem:setDiscount = ",discount)
    self.m_nDiscount = discount
    if tonumber(discount) ~= nil and discount < 10 then     --输入全是数字
        GetElement(self.m_root, "conDiscount_CellCardShopItem", WZUIContainer):setVisible(true)
        local setInput = tonumber(discount)     
        --输入是小数或负数
        if (math.floor(setInput) < setInput) or (setInput < 0) or setInput >= 100 then
            if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "en" or 
                ProjConfig.LANGUAGE == "es" then
                GetElement(self.m_root, "labCnt_CellCardShopItem", WZUILabelAtlasFont):setText(100-setInput*10)
            else 
                GetElement(self.m_root, "labCnt_CellCardShopItem", WZUILabelAtlasFont):setText(setInput*10)
            end
        else
            if ProjConfig.LANGUAGE == "vn" then
                GetElement(self.m_root, "labCnt_CellCardShopItem", WZUILabelAtlasFont):setText(100-setInput*10)
            else
                GetElement(self.m_root, "labCnt_CellCardShopItem", WZUILabelAtlasFont):setText(setInput)
            end
        end
    else  
        GetElement(self.m_root, "conDiscount_CellCardShopItem", WZUIContainer):setVisible(false)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellCardShopItem:_update()
    self:_createOnePropUI()
    -- if ProjConfig.LANGUAGE == "tr" then
    --     local txtCostValue = GetElement(self.m_root,"txtCostValue_CellCardShopItem",WZUILabelTTF)
    --     txtCostValue:setScale(0.8)
    --     txtCostValue:setRelativePosition(GlobalMethod:ccp(0.27,0.48))
    --     local txtWordBuy = GetElement(self.m_root,"txtWordBuy_CellCardShopItem",WZUILabelTTF)
    --     txtWordBuy:setScale(0.8)

    --     local txtCostValueAll = GetElement(self.m_root,"txtCostValueAll_CellCardShopItem",WZUILabelTTF)
    --     txtCostValueAll:setScale(0.8)
    --     txtCostValueAll:setRelativePosition(GlobalMethod:ccp(0.27,0.48))
    --     local txtWordAll = GetElement(self.m_root,"txtWordAll_CellCardShopItem",WZUILabelTTF)
    --     txtWordAll:setScale(0.8)
    -- end
end

-- 更新商品的信息
function CellCardShopItem:_createOnePropUI()
    WZLog("CellCardShopItem:_createOnePropUI")

    -- 商品名字
    local txtName = GetElement(self.m_root,"txtPropName_CellCardShopItem",WZUILabelTTF)
    local shopItemInfo = SplitStringWithSeparator(self.tData[2],",")
    local itemInfo = GDatatab_item["id_" .. shopItemInfo[1]]
    local name = itemInfo.name
    txtName:setText(name)
    txtName:setColor(QUALITYCOLOR[itemInfo.quality])

    -- 货币类型和价格
    local imgMoney = GetElement(self.m_root,"imgMoney_CellCardShopItem",WZUIImage)
    local costInfo = SplitStringWithSeparator(self.tData[3],",")
   
    local imgFile = GDatatab_item["id_"..costInfo[1]].icon
    imgMoney:setFile(imgFile)

    -- 商品图标
    local conP = GetElement(self.m_root,"conProp_CellCardShopItem",WZUIContainer)
    local cell,tcell = CellGoodItem:createElement()
    conP:addChild(cell)
    local prop = {}
    prop.storeId = self.tData[1]
    prop.propId = shopItemInfo[1]
    prop.propNum = tonumber(shopItemInfo[2])
    prop.costId = costInfo[1]
    prop.costNum = costInfo[2]
    prop.basicInfo = GDatatab_item["id_" ..shopItemInfo[1] ]
     if prop.propNum ~= nil and prop.propNum > 1 then prop.lastNum = prop.propNum  end
    tcell:setCellGoodItem(prop,5)
    tcell:_showItemNum()

    self:setSellOut(self.tData[5] == 1)

    self:setDiscount(self.tData[4])

    local costDis = self:getDisPrice(tonumber(costInfo[2]),self.tData[4])
    local txtPrice = GetElement(self.m_root,"txtPrice_CellCardShopItem",WZUILabelTTF)
    txtPrice:setText(costDis)
end

function CellCardShopItem:getDisPrice(cost,discount)
    -- body
    WZLog("CellCardShopItem:setPrice ",cost,discount)
    local temp = cost
    if discount > 0 and discount < 10 then
        local dis = discount / 10
        temp = temp * dis
    end
    temp = math.ceil(temp)
    return temp
end

function CellCardShopItem:OnBtnBuy(element)
    WZLog("---------CellCardShopItem:OnBtnBuy------------")
    if WndItemInfo.m_root ~= nil then return end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.tData[5] == 1 then  return  end
    local shopItemInfo = SplitStringWithSeparator(self.tData[2],",")
    local costInfo = SplitStringWithSeparator(self.tData[3],",")
    local other = {interface = 2,tcell = self }
    local prop = {}
    local costDis = self:getDisPrice(tonumber(costInfo[2]),self.tData[4])
    prop.storeId = self.tData[1]
    prop.propId = shopItemInfo[1]
    prop.propNum = shopItemInfo[2]
    prop.costId = costInfo[1]
    prop.costNum = costDis
    prop.id = shopItemInfo[1]

    prop.basicInfo = GDatatab_item["id_" ..shopItemInfo[1] ]
    WndItemInfo:showInfo(self.m_root,WndStore.m_root,1,prop,true,nil,nil,other)
end

function CellCardShopItem:_adaptLanguage_tr(  )
    local txtName = GetElement(self.m_root,"txtPropName_CellCardShopItem",WZUILabelTTF)
    txtName:setScale(0.7)
    txtName:setDimensions(GlobalMethod:CCSize(180))

    local labCnt = GetElement(self.m_root,"labCnt_CellCardShopItem",WZUILabelAtlasFont)
    labCnt:setScale(0.6)
    labCnt:setRelativePosition(GlobalMethod:ccp(0.548789,0.228581))
    local imgCnt = GetElement(self.m_root,"imgCnt_CellCardShopItem",WZUIImage)
    imgCnt:setScale(0.7)
    imgCnt:setRelativePosition(GlobalMethod:ccp(0.770348,0.433802))
    
end


function CellCardShopItem:_adaptLanguage_vn(  )
    local txtPropName = GetElement(self.m_root,"txtPropName_CellCardShopItem",WZUILabelTTF)
    txtPropName:setScale(0.6)
    txtPropName:setDimensions(GlobalMethod:CCSize(160))
    txtPropName:setRelativePosition(GlobalMethod:ccp(0.5,0.4))
end

function CellCardShopItem:_adaptLanguage_en(  )
    local txtPropName = GetElement(self.m_root,"txtPropName_CellCardShopItem",WZUILabelTTF)
    txtPropName:setScale(0.6)
    txtPropName:setDimensions(GlobalMethod:CCSize(260))
    txtPropName:setRelativePosition(GlobalMethod:ccp(0.5,0.427141))  
end

function CellCardShopItem:_adaptLanguage_th(  )
    local txtName = GetElement(self.m_root,"txtPropName_CellCardShopItem",WZUILabelTTF)
    txtName:setScale(0.7)
    txtName:setDimensions(GlobalMethod:CCSize(180))
end

function CellCardShopItem:_adaptLanguage_pt(  )
    local txtPropName = GetElement(self.m_root,"txtPropName_CellCardShopItem",WZUILabelTTF)
    txtPropName:setScale(0.6)
    txtPropName:setDimensions(GlobalMethod:CCSize(260))
    txtPropName:setRelativePosition(GlobalMethod:ccp(0.5,0.427141))    
end

function CellCardShopItem:_adaptLanguage_es(  )
    local txtPropName = GetElement(self.m_root,"txtPropName_CellCardShopItem",WZUILabelTTF)
    txtPropName:setScale(0.6)
    txtPropName:setDimensions(GlobalMethod:CCSize(260))
    txtPropName:setRelativePosition(GlobalMethod:ccp(0.5,0.173))  
end

function CellCardShopItem:_adaptLanguage_ug(  )
    local txtPropName = GetElement(self.m_root,"txtPropName_CellCardShopItem",WZUILabelTTF)
    txtPropName:setScale(0.6)
    txtPropName:setDimensions(GlobalMethod:CCSize(260))
    txtPropName:setRelativePosition(GlobalMethod:ccp(0.5,0.427141))    
end

---------------------------------语言适配End------------------------------------------------