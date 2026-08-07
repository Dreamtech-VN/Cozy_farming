--CellKingShopItem.lua
--@brief	CellKingShopItem的UI模块
--@date		2015/05/15
--@author	xiaoyu_wu
--@note		商店物品单元格


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellKingShopItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellKingShopItem:onExit(element)
	self:_unInit()
end

--@brief	点击单元格时被调用的函数
--@param	element:按钮绑定的UI节点引用
function CellKingShopItem:onClickCell(element)
    WZLog("CellKingShopItem:onClickCell")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    --[[if self.m_fClickCallback then
        self.m_fClickCallback(self.m_root:getTag(), self)
    end
	
	self.m_tData.rest_num = self.m_tData.rest_num - 1
	self:_updateSoldOut()]]
	local wnd = WndAthBuy:createElement()
    WindowManager:addWindow(wnd, WndAthBuy)
	local data = {}
	data.storeId 	= self.m_tData.id
	data.basicInfo	= GetItemLocalData(self.m_tData.itemId)
	data.propId 	= self.m_tData.itemId
	data.propNum 	= self.m_tData.itemCount
	data.costId		= self.m_tData.currencyId
	data.costNum	= self.m_tData.currencyCost
	WndAthBuy:SetData(data,2)
end

--@brief	点击物品后的回调
--@param	tItem:物品节点绑定的lua表
--@param    nTag:序号
--@param    tData:物品数据表
function CellKingShopItem:onClickListItem(tItem, nTag, tData)
    WZLog("WndKingShowAward:onClickListItem")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
    WndItemInfo:onCloseClick()
	if self.m_itemInfoRoot then
		WndItemInfo:showInfo(tItem.m_root,self.m_itemInfoRoot,1,tData, false)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	更新界面
function CellKingShopItem:_update()
    if self.m_root == nil or self.m_tData == nil then
        return
    end
    
    local tItemData = GetItemLocalData(self.m_tData.itemId)
    if tItemData == nil then
        WZLog("CellKingShopItem:_update Item id:", self.m_tData.itemId, " is not exist!")
        return
    end
    
    --创建物品格子
    local eItem, tItem = CellGoodItem:createElement()
    eItem:setScale(0.82)
	tItem:setItemClickFun(self, self.onClickListItem)
    tItem:setCellGoodItem({
        id = self.m_tData.itemId,
        lastNum = self.m_tData.itemCount,
        lastTime = self.m_tData.itemCount,
        isUse = false,
        data = "",
        playerItemId = -1,
        basicInfo = tItemData
    }, 4)
    local conItem = GetElement(self.m_root, "conItem_CellKingShopItem")
    conItem:addChild(eItem)
    
    local imgCurrency = GetElement(self.m_root, "imgCurrency_CellKingShopItem", WZUIImage)
    imgCurrency:setFile(self:_getCurrencyIcon())
	imgCurrency:setScale(0.38)
    
    local txtCurrency = GetElement(self.m_root, "txtCurrency_CellKingShopItem", WZUILabelTTF)
    txtCurrency:setText(self.m_tData.currencyCost)
	
    self:_updateSoldOut()
end

--@brief	更新售罄界面
function CellKingShopItem:_updateSoldOut()
    if self.m_root == nil or self.m_tData == nil then
        return
    end
    local conSoldOut = GetElement(self.m_root, "conSoldOut_CellKingShopItem")
	if self.m_tData.rest_num <= 0 then
		conSoldOut:setVisible(true)
	else
		conSoldOut:setVisible(false)
	end
end


--@brief	获取货币icon
function CellKingShopItem:_getCurrencyIcon()
	return GDatatab_item["id_"..self.m_tData.currencyId].icon
end

-------------------------------------私有方法模块End----------------------------------------
