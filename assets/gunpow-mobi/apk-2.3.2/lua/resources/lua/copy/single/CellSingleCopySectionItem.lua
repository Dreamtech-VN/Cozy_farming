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
    
    if self.m_tData.openState == false then 
        MsgBoxManager:showTipBox(LocalStrings.COPY_CHAPTER_NOT_OPEN_TIP)
        return 
    end

    WndSingleCopy:onChangeSection(self.m_tData.section_id, self)
end

--@brief    加载
function CellSingleCopySectionItem:onLoadData(element)
	--body
	local celElement = WZUISystem:getInstance():createElement("CellSingleCopySectionItem")
	self.m_root:addChild(celElement)
	--更新函数
	self:_update()
end

--@brief    设置选中状态
function CellSingleCopySectionItem:setSelState(bSel)
    -- body
    self.m_bSelState = bSel 
    if self.m_root == nil then return end 

    local conSel = GetElement(self.m_root, "conSel_CellSingleCopySectionItem", WZUIContainer)
    if conSel then 
        conSel:setVisible(bSel)
    end
end

--@brief    设置红点
function CellSingleCopySectionItem:setReDot(bVisible)
    --body
    self.m_bRedDot = bVisible
    if self.m_root == nil then return end 

    local imgRedDot = GetElement(self.m_root, "imgRedDot_CellSingleCopySectionItem", WZUIImage)
    if imgRedDot then 
        imgRedDot:setVisible(bVisible)
    end
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

	--章节地图
	WZLog("CellSingleCopySectionItem:_update", Serialize(self.m_tData))
	local imgIcon = GetElement(self.m_root, "imgIcon_CellSingleCopySectionItem", WZUIImage)
	if imgIcon then 
		imgIcon:setFile(self.m_tData.resources)
	end

    GetElement(self.m_root, "conLock_CellSingleCopySectionItem", WZUIContainer):setVisible(not self.m_tData.openState)
	self:setSelState(self.m_bSelState)
	self:setReDot(self.m_bRedDot)
end




-------------------------------------私有方法模块End----------------------------------------
