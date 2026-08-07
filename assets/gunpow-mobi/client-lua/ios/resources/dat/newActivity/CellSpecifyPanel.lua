--CellSpecifyPanel.lua
--@brief	CellSpecifyPanel的UI模块
--@date		2017/08/21
--@author	Tianxiang_Xu
--@note		定向推送活动-礼包详情


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellSpecifyPanel:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellSpecifyPanel:onExit(element)
	self:_unInit()
end

--@brief    点击奖励物品回调
function CellSpecifyPanel:onClickItem(luaTable, tag, tData)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    -- body
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(luaTable.m_root, WndSpecifyActivity.m_root, 1, tData, false, nil, false, nil, nil, false)
end

--@brief    购买按钮回调
function CellSpecifyPanel:onClickBuy(element)

    if tostring(ProjConfig:getChannelId()) == "8888" or tostring(ProjConfig:getChannelId()) == "53" or tostring(ProjConfig:getChannelId()) == "75" or tostring(ProjConfig:getChannelId()) == "275" or tostring(ProjConfig:getChannelId()) == "68" or tostring(ProjConfig:getChannelId()) == "10" then
        return
    end
    
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_nLeftCount == 0 then
        MsgBoxManager:showTipBox(LocalStrings.NEWACTIVITY_TEXT3)
        return 
    end
    --背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
    
    if self.m_nGiftType == 1 then 
        WndSpecifyActivity:_createLoading()
        PostPlayerEvent:postEvent(PostPlayerEvent.event_clickPay)
        local sdkData = {}
        local vipData = GDatatab_recharge["id_" .. self.m_ItemId]
        WZLog("CellSpecifyPanel:onClickBuy:",self.m_ItemId,vipData.pay_code_id)
        sdkData.id = self.m_ItemId
        sdkData.price = vipData.price
        sdkData.productName = vipData.name
        sdkData.payCode = vipData.pay_code_id
        sdkData.quantifier = LocalStrings.SHOP_IND
        sdkData.number = "1"
        sdkData.giftNumber = "0"
        sdkData.productDesc = vipData.name

        PassportSdkManager:getOrderNum(sdkData)
    else
        local tShopData = CacheCenter:getShopGoodData(self.m_ItemId)
        if not JudgeMoneyIsEnough(tShopData.moneyId, tShopData.floorPrice, nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureToUseDiamondInstead) then
            return 
        end

        self:sureToUseDiamondInstead()
    end
end

--@brief    确认用礼钻代替钻石购买礼包
function CellSpecifyPanel:sureToUseDiamondInstead()
    -- body
    local index = 0
    local count = WZLuaVector_int_:create()
    count:push(index)
    local mallId = WZLuaVector_int_:create()
    mallId:push(self.m_ItemId)

    WndSpecifyActivity:_createLoading()
    ProtocolProcessorWndShop:send_MALL_BuyItems(count, mallId, 1, 0)
end

--@brief    界面显示
function CellSpecifyPanel:showWindow()
    -- body
    --礼包图标
    local conIcon = GetElement(self.m_root, "conIcon_CellSpecifyPanel", WZUIContainer)
    local txtDesc = GetElement(self.m_root, "txtDesc_CellSpecifyPanel", WZUILabelTTF)
    if conIcon then
        local element, tNewObj = CellGoodItem:createElement()
        if element and tNewObj then 
            local itemId = self.m_ItemId
            if self.m_nGiftType == 1 then 
                itemId = GDatatab_recharge["id_" .. self.m_ItemId].item_id
            else
                local tShopData = CacheCenter:getShopGoodData(self.m_ItemId)
                itemId = tShopData.shopItemId
            end
            tNewObj:setCellGoodLocalId(itemId, 1, 4)
            tNewObj:_setItemVisible(false)
            tNewObj:setItemClickFun(self, self.onClickItem)

            conIcon:addChild(element)
            --描述
            txtDesc:setText(GDatatab_item["id_" .. itemId].desc)
        end
    end

    --剩余次数
    self:_updateLeftTimes()
    --按钮字
    self:_showBtnWord()
    --消耗
    self:_showCost()
    --显示礼包中的物品
    self:_showGoodInGift()
end

--@brief    更新剩余次数
function CellSpecifyPanel:resetLeftCount()
    -- body
    WZLog("CellSpecifyPanel:resetLeftCount", self.m_nLeftCount)
    if self.m_nLeftCount ~= -1 and self.m_nLeftCount > 0 then
        self.m_nLeftCount = self.m_nLeftCount - 1
        self:_updateLeftTimes()
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    剩余次数
function CellSpecifyPanel:_updateLeftTimes()
    -- body
    local ftxtLeftNum = GetElement(self.m_root, "ftxtLeftNum_CellSpecifyPanel", WZUIFreeTextBox)
    local sFormat = [[<T C="255,236,193" S="18" P="1" SC="79,60,48" SS="4" SE="1">%s</T><T C="255,89,74" S="18" P="1" SC="79,60,48" SS="4" SE="1">%d</T><T C="255,236,193" S="18" P="1" SC="79,60,48" SS="4" SE="1">%s</T>]]
    if ftxtLeftNum then 
        if self.m_nLeftCount == -1 then 
            sFormat = [[<T C="255,236,193" S="18" P="1" SC="79,60,48" SS="4" SE="1">%s</T>]]
            ftxtLeftNum:setShowText(string.format(sFormat, LocalStrings.COMMUNITYINFO235))
        else
            ftxtLeftNum:setShowText(string.format(sFormat, LocalStrings.SHOP_GOODSSHEGN, self.m_nLeftCount, LocalStrings.SHOP_IND))
        end

        --根据渠道号屏蔽限购
        local tabChannel = {1042,1043,1065,1066,1067,1069,1072,1074,1087,1089,1091,1094,1096,1097,1098,1101,1099,1102,1103,1104,1105}
        for _,v in ipairs(tabChannel) do
            if ProjConfig.CHANNEL_ID == v then
                ftxtLeftNum:setVisible(false)
            end
        end
    end
end

--@brief    按钮字
function CellSpecifyPanel:_showBtnWord()
    -- body
    local txtBuy = GetElement(self.m_root, "txtBuy_CellSpecifyPanel", WZUILabelTTF)
    if txtBuy then
        if self.m_nGiftType == 1 then   --vip礼包
            if not self.m_originPrice then
                GetElement(self.m_root, "btnBuy_CellSpecifyPanel", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.5,0.5))
            end
            txtBuy:setUseSystemFont(true)
            local vipData = GDatatab_recharge["id_" .. self.m_ItemId]
            txtBuy:setText(vipData.unit .. LocalStrings.BUY)
        else
            GetElement(self.m_root, "btnBuy_CellSpecifyPanel", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.5,0.4))
            txtBuy:setText(LocalStrings.BUY)
        end
    end
end

--@brief    消耗
function CellSpecifyPanel:_showCost()
    -- body
    local ftxtPrice = GetElement(self.m_root, "ftxtPrice_CellSpecifyPanel", WZUIFreeTextBox)
    local sFormat = [[<I Z="0.5" P="1">%s</I><T C="99,255,95" S="18" P="1" SC="79,60,48" SS="4" SE="1">%d</T>]]
    if ftxtPrice then
        if self.m_nGiftType == 1 then 
            if self.m_originPrice then
                local string = string.sub(self.m_originPrice,2,-2) 
                local originPrice = SplitStringWithSeparator(string,",")[2]
                local originPriceFormat = [[<T C="255,236,193" S="20" P="1" SC="105,65,46" SS="4" SE="1">%s</T>]]
                ftxtPrice:setShowText(string.format(originPriceFormat, LocalStrings.LIMITE_BUY_ORIGINPRICE .. ":" .. originPrice))
                GetElement(self.m_root,"imgLine_CellSpecifyPanel",WZUIImage):setVisible(true)
            else
                ftxtPrice:setVisible(false)
            end
        else
            ftxtPrice:setVisible(true)
            local tShopData = CacheCenter:getShopGoodData(self.m_ItemId)
            local priceIcon = GDatatab_item["id_" .. tShopData.moneyId].icon
            local curPrice = math.ceil(tShopData.floorPrice * (tShopData.discount/10000))
            ftxtPrice:setShowText(string.format(sFormat, priceIcon, curPrice))
        end
    end
end

--@brief    展示礼包中的物品
function CellSpecifyPanel:_showGoodInGift()
    -- body
    local tableGoodList = GetElement(self.m_root, "tableGoodList_CellSpecifyPanel", WZUITableContainer)
    if tableGoodList then 
        tableGoodList:cleanTable()
    end

    local sex = CacheCenter:getPlayerInfo().sex
    local giftList = {}
    local sexIndex = {"man_item_id","woman_item_id"}

    local itemId = self.m_ItemId
    if self.m_nGiftType == 1 then 
        itemId = GDatatab_recharge["id_" .. self.m_ItemId].item_id
    else
        local tShopData = CacheCenter:getShopGoodData(self.m_ItemId)
        itemId = tShopData.shopItemId
    end

    for k,v in pairs(GDatatab_gifts) do
        if v.item_id == itemId then
            local temp = {}
            temp.id = v[sexIndex[sex+1]]
            temp.count = v["count"]
            table.insert(giftList,temp)
        end
    end

    --
    for i = 1, #giftList do
        local element, tNewObj = CellGoodItem:createElement()
        if element and tNewObj then 
            tNewObj:setCellGoodLocalId(giftList[i].id, giftList[i].count, 4)
            tNewObj:setItemClickFun(self, self.onClickItem)
            element:setTag(i - 1)

            tableGoodList:setCellElement(element)
        end
    end

end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin-------------------------------------------
function CellSpecifyPanel:_adaptLanguage_es(  )
    GetElement(self.m_root,"txtBuy_CellSpecifyPanel",WZUILabelTTF):setScale(0.7)
end

function CellSpecifyPanel:_adaptLanguage_pt(  )
    GetElement(self.m_root,"txtBuy_CellSpecifyPanel",WZUILabelTTF):setScale(0.7)
end
-------------------------------------语言适配End--------------------------------------------