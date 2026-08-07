--CellSingleCopySectionItem.lua
--@brief	CellSingleCopySectionItem的UI模块
--@date		2019/06/13
--@author	Tianxiang_Xu
--@note		章节名字cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellSingleCopySectionItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellSingleCopySectionItem:onExit(element)
	self:_unInit()
end

--@brief	点击按钮时被调用的函数
--@param	element:按钮绑定的UI节点引用
function CellSingleCopySectionItem:onClickSection(element)
    WZLog("CellSingleCopySectionItem:onClickLevel")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    WndSingleCopy:onChangeSection(self.m_tData.section_id)
end

--@brief    加载
function CellSingleCopySectionItem:onLoadData(element)
	--body
	local celElement = WZUISystem:getInstance():createElement("CellSingleCopySectionItem")
	self.m_root:addChild(celElement)
	--更新函数
	self:_update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function CellSingleCopySectionItem:_update()
	-- body
	local txtSectionName = GetElement(self.m_root, "txtSectionName_CellSingleCopySectionItem", WZUILabelTTF)
	if txtSectionName then 
		txtSectionName:setText(self.m_tData.sectionName)
	end
end




-------------------------------------私有方法模块End----------------------------------------
