--CellShopItem.lua
--@brief	CellShopItem的UI模块
--@date		2015/05/15
--@author	xiaoyu_wu
--@note		商店物品单元格


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellShopItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellShopItem:onExit(element)
	self:_unInit()
end

--@brief	点击单元格时被调用的函数
--@param	element:按钮绑定的UI节点引用
function CellShopItem:onClickCell(element)
    WZLog("CellShopItem:onClickCell")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_fClickCallback then
        self.m_fClickCallback(self.m_root:getTag(), self)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	更新界面
function CellShopItem:_update()
    if self.m_root == nil or self.m_tData == nil then
        return
    end
    
    local tItemData = GetItemLocalData(self.m_tData.id)
    if tItemData == nil then
        WZLog("CellShopItem:_update Item id:", self.m_tData.id, " is not exist!")
        return
    end
    local txtName = GetElement(self.m_root, "txtName_CellShopItem", WZUILabelTTF)
    local sName = tItemData.name
    if self.m_tData.count > 1 then
        sName = sName.."*"..self.m_tData.count
    end
    txtName:setText(sName)
    
    --创建物品格子
    local eItem, tItem = CellGoodItem:createElement()
    eItem:setScale(0.72)
    --tItem:setItemClickFun(self, self.onClickItem)
    tItem:setCellGoodItem({
        id = self.m_tData.id,
        lastNum = 1,
        lastTime = 1,
        isUse = false,
        data = "",
        playerItemId = -1,
        basicInfo = tItemData
    }, 5)
    local conItem = GetElement(self.m_root, "conItem_CellShopItem")
    conItem:addChild(eItem)
    
    local imgCurrency = GetElement(self.m_root, "imgCurrency_CellShopItem", WZUIImage)
    imgCurrency:setFile(self:_getCurrencyIcon())
    
    local txtCurrency = GetElement(self.m_root, "txtCurrency_CellShopItem", WZUILabelTTF)
    txtCurrency:setText(self.m_tData.currencyCost)

    self:_updateSoldOut()
end

--@brief	更新售罄界面
function CellShopItem:_updateSoldOut()
    if self.m_root == nil or self.m_tData == nil then
        return
    end
    local conSoldOut = GetElement(self.m_root, "conSoldOut_CellShopItem")
    conSoldOut:setVisible(self.m_tData.isSoldOut)
end


--@brief	获取货币icon
function CellShopItem:_getCurrencyIcon()
    if self.m_tData.currencyId == 1 then
        return "ui/main/shop/badge_s.png"
    elseif self.m_tData.currencyId == 2 then
        return "ui/main/shop/badge_s.png"
    else
        return "ui/main/shop/badge_s.png"
    end
end

-------------------------------------私有方法模块End----------------------------------------
