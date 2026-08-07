--WndAuctionIdentifyRule.lua
--@brief	WndAuctionIdentifyRule的UI模块
--@date		2023/06/01
--@author	yrd
--@note		拍卖行-鉴宝界面规则说明


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndAuctionIdentifyRule:onEnter(element)
	self.m_root = element

	self:_initStaticText()
	self:updateUI()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndAuctionIdentifyRule:onExit(element)
	self:_unInit()
end

--@brief	更新界面
function WndAuctionIdentifyRule:updateUI()
	local txtDesc1 = GetElement(self.m_root, "txtDesc1", WZUIFreeTextBox)
	txtDesc1:setShowText(self.m_sDesc)
	txtDesc1:setPositionY(txtDesc1:getContentSize().height)
	local scrollConDesc = GetElement(self.m_root,"scrollConDesc",WZUIScrollContainer)
	local moveElement = scrollConDesc:getMoveElement()
	moveElement:setRelativeSize( CCSize( moveElement:getRelativeSize().width , (txtDesc1:getContentSize().height + 10) / scrollConDesc:getContentSize().height ) )
	scrollConDesc:UpdateInsidePosition()  --更新滚动容器内部布局
	moveElement:setPositionY(scrollConDesc:getMinPosition().y)
end

--@brief	点击确认按钮回调
function WndAuctionIdentifyRule:onClickConfirm()
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManager:removeWindow(self.m_root, self, true)	
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


--@brief	更新界面
function WndAuctionIdentifyRule:_initStaticText()
	GetElement(self.m_root, "txtTitle_WndAuctionIdentifyRule", WZUILabelTTF):setText(LocalStrings.ACTIVITY_TEXT_DESC_15)
	GetElement(self.m_root, "txtConfirm1_WndAuctionIdentifyRule", WZUILabelTTF):setText(LocalStrings.BUY_FIVE_AFFIRM)
end


-------------------------------------私有方法模块End----------------------------------------
