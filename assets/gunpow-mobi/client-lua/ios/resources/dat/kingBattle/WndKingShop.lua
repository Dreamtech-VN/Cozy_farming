--WndKingShop.lua
--@brief	WndKingShop的UI模块
--@date		2015/5/12
--@author	Zjh
--@note

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndKingShop:onEnter(element)
	self.m_root = element

	ProtocolProcessorSceneKing:send_KING_GetMallInfo( )
	
	self:_updateUI_static_txt()
end

----@brief onEnter函数执行完成回调
function WndKingShop:onEnterTransitionDidFinish(element)
    --弹窗动画
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
end

----@brief    弹窗动画完成后的回调
function WndKingShop:actionCallback(element, data)
	--初始化界面
	self:_updateUI_dynamic()
end

----@brief    获取根节点
function WndKingShop:getRoot()
	return self.m_root
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndKingShop:onExit(element)
	self:_unInit()
end

--@brief	点击关闭按钮时被调用的函数
--@param	element:按钮绑定的UI节点引用
function WndKingShop:onClose(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManagerAni:createCloseAction(self.m_root, "onActionCallBack", self)
end

--@brief	动画播完后的回调
function WndKingShop:onActionCallBack()
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	窗口触摸事件回调
function WndKingShop:onTouchBegan(element)
	WndItemInfo:onCloseClick()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function WndKingShop:_updateUI_dynamic()
	local nKingMoney = getBagItemCount(4) or 0
	
	local moneyImg = GDatatab_item["id_"..4].icon
	GetElement(self.m_root, "txtKingMoney_WndKingShop", WZUIFreeTextBox):setShowText(string.format( [[<T C="255,255,255" S="24" P="1">%s：</T><I Z="0.4" P="1">%s</I><T C="255,255,255" S="24" P="1">%d</T>]] , LocalStrings.KING_MONEY , moneyImg, nKingMoney))
	
	--self:_updateShopList()
end

--@brief	更新商品列表
function WndKingShop:_updateShopList()
    if self.m_root == nil or self.m_tData == nil then
        return
    end
    
    local tbconShop = GetElement(self.m_root, "tabShop_WndKingShop", WZUITableContainer)
    tbconShop:cleanTable()
    for i = 1, #self.m_tData do
        local eCell,tCell = CellKingShopItem:createElement()
        eCell:setTag(i-1)
        tCell:setData(self.m_tData[i])
		tCell:setItemInfoRoot(tbconShop:getParent())
        --[[tCell:setClickCallback(function(nTag, tCell)
            self:onClickCell(nTag, tCell)
        end)]]
        
        tbconShop:setCellElement(eCell)
    end
end

function WndKingShop:_updateUI_static_txt()

	GetElement(self.m_root, "txtTitle_WndKingShop", WZUILabelTTF):setText( LocalStrings.KING_SHOP )

end
-------------------------------------私有方法模块End----------------------------------------
