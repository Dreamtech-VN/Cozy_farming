--CellDiscountLimitItem.lua
--@brief	CellDiscountLimitItem的UI模块
--@date		2017/07/19
--@author	Tianxiang_Xu
--@note		折扣限购活动，可以配置消耗货币类型


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellDiscountLimitItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellDiscountLimitItem:onExit(element)
	self:_unInit()
end


--@brief    加载cell信息数据
function CellDiscountLimitItem:onLoadData(element)
    -- body
    local celElement = WZUISystem:getInstance():createElement("CellDiscountLimitItem")
    self.m_root:addChild(celElement)

    self:_update()
    AdaptLanguage(self)
end

--@brief    点击购买回调
function CellDiscountLimitItem:onClickBuy(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_tCallBack then
        self.m_tCallBack[2](self.m_tCallBack[1], self.m_tData)
    end
end

--@brief    点击Item时回调tips
function CellDiscountLimitItem:onOthersClick(luaTable,tag,tData)
    if tData == nil then
       return
    end

    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(luaTable.m_root,CellDiscountLimitPanel.m_root,1,tData,false)
end

--@brief    更新数据
--@param    tData:最新的数据
function CellDiscountLimitItem:refreshItem(tData)
    -- body
    self.m_tData = tData

    self:_update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新cell信息
function CellDiscountLimitItem:_update()
    -- body
    --商品
    WZLog("CellDiscountLimitItem:_update")
    local conItem = GetElement(self.m_root, "conItem_CellDiscountLimitItem", WZUIContainer)
    conItem:removeAllChildrenWithCleanup(true)
    if conItem then
        local element, tNewObj = CellGoodItem:createElement()
        local key = "id_"..self.m_tData.id
        WZLog("CellDiscountLimitItem:_update"..key)
        if element and tNewObj then 
            local itemInfo = {id = self.m_tData.id, name=GDatatab_item[key].name,icon=GDatatab_item[key].icon,lastTime=self.m_tData.num,quality=GDatatab_item[key].quality,basicInfo=CopyTable(GDatatab_item[key])}
            tNewObj:setCellGoodItem(itemInfo,17)
        --    tNewObj:setItemCount(self.m_tData.num)
            tNewObj:setItemClickFun(self,self.onOthersClick)
            conItem:addChild(element)
        end

        --名字
        local txtName = GetElement(self.m_root, "txtName_CellDiscountLimitItem", WZUILabelTTF)
        if txtName then
            txtName:setText(GDatatab_item[key].name)
            txtName:setColor(QUALITYCOLOR[GDatatab_item[key].quality])
        end
    end
    --剩余次数
    local txtLeftTime = GetElement(self.m_root, "txtLeftTime_CellDiscountLimitItem", WZUILabelTTF)
    if txtLeftTime then
        txtLeftTime:setText(LocalStrings.SHOP_GOODSSHEGN .. ":" .. self.m_tData.times)
    end
    local sPriceFormat = [[<T C="255,236,193" S="18" P="1" SC="128,54,13" SS="4" SE="1">%s:%d</T><I Z="0.45" P="1">%s</I>]]
    local sIconPath = GDatatab_item["id_" .. self.m_tData.priceId].icon
    --原价
    local txtOriginPrice = GetElement(self.m_root, "txtOriginPrice_CellDiscountLimitItem", WZUIFreeTextBox)
    local nOriginPrice = CacheCenter:getPriceByItemId(self.m_tData.id)
    if txtOriginPrice then
        txtOriginPrice:setShowText(string.format(sPriceFormat, LocalStrings.LIMITE_BUY_ORIGINPRICE, self.m_tData.originPrice, sIconPath))
    end
    --现价
    local txtCurPrice = GetElement(self.m_root, "txtCurPrice_CellDiscountLimitItem", WZUIFreeTextBox)
    sPriceFormat = [[<T C="255,227,116" S="20" P="1" SC="0,72,3" SS="4" SE="1">%s:%d</T><I Z="0.45" P="1">%s</I>]]
    if txtCurPrice then
        txtCurPrice:setShowText(string.format(sPriceFormat, LocalStrings.LIMITE_BUY_CURPRICE, self.m_tData.curPrice, sIconPath))
    end
    --购买按钮
    local btnBuy = GetElement(self.m_root, "btnBuy_CellDiscountLimitItem", WZUIButton)
    if btnBuy then
        if self.m_tData.times > 0 then
            btnBuy:setTouchEnable(true)
        else
            btnBuy:setTouchEnable(false)
            local txtBuy = GetElement(self.m_root, "txtBuy_CellDiscountLimitItem", WZUILabelTTF)
            txtBuy:setColor(GlobalMethod:ccc3(255,255,255))
            txtBuy:setStrokeColor(GlobalMethod:ccc3(79,60,48))
        end
    end
    --售罄
    local conSoldAll = GetElement(self.m_root, "conSoldAll_CellDiscountLimitItem", WZUIContainer)
    if conSoldAll then
        if self.m_tData.times > 0 then
            conSoldAll:setVisible(false)
        else
            conSoldAll:setVisible(true)
        end
    end
end




-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin---------------------------------------
function CellDiscountLimitItem:_adaptLanguage_vn(  )
    local txtName = GetElement(self.m_root,"txtName_CellDiscountLimitItem",WZUILabelTTF)
    txtName:setScale(0.7)
    txtName:setDimensions(GlobalMethod:CCSize(130))
end

function CellDiscountLimitItem:_adaptLanguage_en(  )
    local txtName = GetElement(self.m_root,"txtName_CellDiscountLimitItem",WZUILabelTTF)
    txtName:setScale(0.7)
    txtName:setDimensions(GlobalMethod:CCSize(130))
end

function CellDiscountLimitItem:_adaptLanguage_th(  )
    local txtName = GetElement(self.m_root,"txtName_CellDiscountLimitItem",WZUILabelTTF)
    txtName:setScale(0.7)
    txtName:setDimensions(GlobalMethod:CCSize(130))
end

function CellDiscountLimitItem:_adaptLanguage_es(  )
    local txtName = GetElement(self.m_root,"txtName_CellDiscountLimitItem",WZUILabelTTF)
    txtName:setScale(0.7)
    txtName:setDimensions(GlobalMethod:CCSize(130))

    local txtOriginPrice = GetElement(self.m_root, "txtOriginPrice_CellDiscountLimitItem", WZUIFreeTextBox)
    txtOriginPrice:setMaxWidth(320)
    txtOriginPrice:setScale(0.7)
    local txtCurPrice = GetElement(self.m_root, "txtCurPrice_CellDiscountLimitItem", WZUIFreeTextBox)
    txtCurPrice:setMaxWidth(320)
    txtCurPrice:setScale(0.7)
end

function CellDiscountLimitItem:_adaptLanguage_pt(  )
    local txtName = GetElement(self.m_root,"txtName_CellDiscountLimitItem",WZUILabelTTF)
    txtName:setScale(0.7)
    txtName:setDimensions(GlobalMethod:CCSize(130))
end
-------------------------------------语言适配End-----------------------------------------