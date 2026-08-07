--CellTimeDiscountItem.lua
--@brief	CellTimeDiscountItem的UI模块
--@date		2016/08/12
--@author	Tianxiang_Xu
--@note		限时折扣子节点


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellTimeDiscountItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellTimeDiscountItem:onExit(element)
	self:_unInit()
end

--@brief    加载cell信息数据
function CellTimeDiscountItem:onLoadData(element)
    -- body
    local celElement = WZUISystem:getInstance():createElement("CellTimeDiscountItem")
    self.m_root:addChild(celElement)
    AdaptLanguage(self)
    self:_update()
end

--@brief    点击购买回调
function CellTimeDiscountItem:onClickBuy(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_tCallBack then
        self.m_tCallBack[2](self.m_tCallBack[1], self.m_tData)
    end
end

--@brief    点击Item时回调tips
function CellTimeDiscountItem:onOthersClick(luaTable,tag,tData)
    if tData == nil then
       return
    end

    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(luaTable.m_root,CellTimeDiscountPanel.m_current.m_root,1,tData,false)
end

--@brief    更新数据
--@param    tData:最新的数据
function CellTimeDiscountItem:refreshItem(tData)
    -- body
    self.m_tData = tData

    self:_update()
end
-------------------------------------公有方法模块End----------------------------------------
--@brief    刷新cell信息
function CellTimeDiscountItem:_update()
    -- body
    --商品
    local conItem = GetElement(self.m_root, "conItem_CellTimeDiscountItem", WZUIContainer)
    conItem:removeAllChildrenWithCleanup(true)
    if conItem then
        local element, tNewObj = CellGoodItem:createElement()
        local key = "id_"..self.m_tData.id
        WZLog("CellTimeDiscountItem:_update"..key)
        if element and tNewObj then 
            local itemInfo = {id = self.m_tData.id, name=GDatatab_item[key].name,icon=GDatatab_item[key].icon,lastTime=self.m_tData.num,quality=GDatatab_item[key].quality,basicInfo=CopyTable(GDatatab_item[key])}
            tNewObj:setCellGoodItem(itemInfo,17)
        --    tNewObj:setItemCount(self.m_tData.num)
            tNewObj:setItemClickFun(self,self.onOthersClick)
            conItem:addChild(element)
        end

        --名字
        local txtName = GetElement(self.m_root, "txtName_CellTimeDiscountItem", WZUILabelTTF)
        if txtName then
            txtName:setText(GDatatab_item[key].name)
            txtName:setColor(QUALITYCOLOR[GDatatab_item[key].quality])
        end
    end
    --剩余次数
    local txtLeftTime = GetElement(self.m_root, "txtLeftTime_CellTimeDiscountItem", WZUILabelTTF)
    if txtLeftTime then
        txtLeftTime:setText(LocalStrings.SHOP_GOODSSHEGN .. ":" .. self.m_tData.times)
    end
    local sPriceFormat = [[<T C="255,236,193" S="18" P="1" SC="128,54,13" SS="4" SE="1">%s:%d</T><I Z="0.7" P="1">%s</I>]]
    local sIconPath = "ui/common/common_icon_zuanshi.png"
    if self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_GOODSDISCOUNT_TICKET then
        sPriceFormat = [[<T C="255,236,193" S="18" P="1" SC="128,54,13" SS="4" SE="1">%s:%d</T><I Z="0.5" P="1">%s</I>]]
        sIconPath = GDatatab_item["id_70"].icon
    elseif self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_NEWSERVER_TIMEDISCOUNT then
        sPriceFormat = [[<T C="255,236,193" S="18" P="1" SC="128,54,13" SS="4" SE="1">%s:%d</T><I Z="0.5" P="1">%s</I>]]
        sIconPath = GDatatab_item["id_" .. self.m_tData.priceId].icon
    end
    --原价
    local txtOriginPrice = GetElement(self.m_root, "txtOriginPrice_CellTimeDiscountItem", WZUIFreeTextBox)
    local nOriginPrice = CacheCenter:getPriceByItemId(self.m_tData.id)
    if txtOriginPrice then
        txtOriginPrice:setShowText(string.format(sPriceFormat, LocalStrings.LIMITE_BUY_ORIGINPRICE, self.m_tData.originPrice, sIconPath))
    end
    --现价
    local txtCurPrice = GetElement(self.m_root, "txtCurPrice_CellTimeDiscountItem", WZUIFreeTextBox)
    if self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_GOODSDISCOUNT_TICKET then
        sPriceFormat = [[<T C="255,227,116" S="22" P="1" SC="0,72,3" SS="4" SE="1">%s:%d</T><I Z="0.5" P="1">%s</I>]]
        sIconPath = GDatatab_item["id_70"].icon
    elseif self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_NEWSERVER_TIMEDISCOUNT then
        sPriceFormat = [[<T C="255,227,116" S="22" P="1" SC="0,72,3" SS="4" SE="1">%s:%d</T><I Z="0.5" P="1">%s</I>]]
        sIconPath = GDatatab_item["id_" .. self.m_tData.priceId].icon
    else
        sPriceFormat = [[<T C="255,227,116" S="22" P="1" SC="0,72,3" SS="4" SE="1">%s:%d</T><I Z="0.7" P="1">%s</I>]]
    end
    if txtCurPrice then
        txtCurPrice:setShowText(string.format(sPriceFormat, LocalStrings.LIMITE_BUY_CURPRICE, self.m_tData.curPrice, sIconPath))
    end
    --购买按钮
    local btnBuy = GetElement(self.m_root, "btnBuy_CellTimeDiscountItem", WZUIButton)
    if btnBuy then
        if self.m_tData.times > 0 then
            btnBuy:setTouchEnable(true)
        else
            btnBuy:setTouchEnable(false)
            local txtBuy = GetElement(self.m_root, "txtBuy_CellTimeDiscountItem", WZUILabelTTF)
            txtBuy:setColor(GlobalMethod:ccc3(255,255,255))
            txtBuy:setStrokeColor(GlobalMethod:ccc3(79,60,48))
        end
    end
    --售罄
    local conSoldAll = GetElement(self.m_root, "conSoldAll_CellTimeDiscountItem", WZUIContainer)
    if conSoldAll then
        if self.m_tData.times > 0 then
            conSoldAll:setVisible(false)
        else
            conSoldAll:setVisible(true)
        end
    end
    --vip角标
    local conVip = GetElement(self.m_root, "conVip_CellTimeDiscountItem", WZUIContainer)
    if conVip then 
        if self.m_tData.needVip > 0 then 
            conVip:setVisible(true)
            local txtVip = GetElement(self.m_root, "txtVip_CellTimeDiscountItem", WZUILabelTTF)
            if txtVip then 
                txtVip:setText("VIP" .. self.m_tData.needVip .. LocalStrings.NEWACTIVITY_TEXT8)
            end
        else
            conVip:setVisible(false)
        end
    end
end

-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin--------------------------------------
function CellTimeDiscountItem:_adaptLanguage_th(  )
    GetElement(self.m_root,"txtCurPrice_CellTimeDiscountItem",WZUIFreeTextBox):setMaxWidth(200)

    local txtVip = GetElement(self.m_root,"txtVip_CellTimeDiscountItem",WZUILabelTTF)
    txtVip:setScale(0.7)
    txtVip:setRelativePosition(GlobalMethod:ccp(0.66,0.6))
end

function CellTimeDiscountItem:_adaptLanguage_pt(  )
    local txtName = GetElement(self.m_root,"txtName_CellTimeDiscountItem",WZUILabelTTF)
    txtName:setScale(0.6)
    txtName:setDimensions(GlobalMethod:CCSize(250))
end

function CellTimeDiscountItem:_adaptLanguage_en(  )
    local txtName = GetElement(self.m_root,"txtName_CellTimeDiscountItem",WZUILabelTTF)
    txtName:setScale(0.6)
    txtName:setDimensions(GlobalMethod:CCSize(250))

    local txtCurPrice = GetElement(self.m_root,"txtCurPrice_CellTimeDiscountItem",WZUIFreeTextBox)
    txtCurPrice:setScale(0.7)
    txtCurPrice:setMaxWidth(300)

    local txtVip = GetElement(self.m_root,"txtVip_CellTimeDiscountItem",WZUILabelTTF)
    txtVip:setScale(0.7)
    txtVip:setRelativePosition(GlobalMethod:ccp(0.66,0.6))
end

function CellTimeDiscountItem:_adaptLanguage_tr(  )
    local txtCurPrice = GetElement(self.m_root,"txtCurPrice_CellTimeDiscountItem",WZUIFreeTextBox)
    txtCurPrice:setScale(0.7)
    txtCurPrice:setMaxWidth(300)
    local txtName = GetElement(self.m_root,"txtName_CellTimeDiscountItem",WZUILabelTTF)
    txtName:setScale(0.6)
    txtName:setDimensions(GlobalMethod:CCSize(250))
end

function CellTimeDiscountItem:_adaptLanguage_vn(  )
    local txtName = GetElement(self.m_root,"txtName_CellTimeDiscountItem",WZUILabelTTF)
    txtName:setScale(0.6)
    txtName:setDimensions(GlobalMethod:CCSize(250))
end

function CellTimeDiscountItem:_adaptLanguage_es(  )
    local txtName = GetElement(self.m_root,"txtName_CellTimeDiscountItem",WZUILabelTTF)
    txtName:setScale(0.5)

    local txtOrigin = GetElement(self.m_root,"txtOriginPrice_CellTimeDiscountItem",WZUIFreeTextBox)
    txtOrigin:setScale(0.6)
    txtOrigin:setMaxWidth(200)
    
    local txtCur = GetElement(self.m_root,"txtCurPrice_CellTimeDiscountItem",WZUIFreeTextBox)
    txtCur:setScale(0.6)
    txtCur:setMaxWidth(230)
end
--------------------------------------语言适配End--------------------------------------