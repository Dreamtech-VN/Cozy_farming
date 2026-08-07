--CellShopSel.lua
--@brief	CellShopSel的UI模块
--@date		2015-5-22
--@author	binshao
--@note		商城道具类型选择模块


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellShopSel:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellShopSel:onExit(element)
	self:_unInit()
end

-- 点击商品类型选择回调
function CellShopSel:OnCheckSel(element)
    local tag = self.m_root:getTag()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self.m_tCallBackFunc[2](self.m_tCallBackFunc[1],tag)
end

-- 设置checkbox的显示状态
function CellShopSel:SetCheckBoxIndex(index)
    local checkBox = GetElement(self.m_root, "checkSel_CellShopSel", WZUICheckBox)
    checkBox:setCheckIndex(index)
end

-- 获取当前cell的一级和二级标题，若二级标题为空，表示该标题为一级标题，否则是二级标题
function CellShopSel:GetCellTitle()
    return self.m_tData.mainTitle,self.m_tData.subTitle
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
-- 更新物品类型选择
function CellShopSel:_update()
    self:_setCheckTTF()
    self:_changeState()
end

-- 改变cell的状态
function CellShopSel:_changeState()
    local checkBox = GetElement(self.m_root, "checkSel_CellShopSel", WZUICheckBox)
    checkBox:setCheckIndex(self.m_tData.index)
end

-- 设置cell的显示文字
function CellShopSel:_setCheckTTF()
    local txtCheck = GetElement(self.m_root, "txtSel_CellShopSel", WZUILabelTTF)
    txtCheck:setText(self.m_tData.txtName)
end
-------------------------------------私有方法模块End----------------------------------------





