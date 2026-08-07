--CellSevenDayItem.lua
--@brief	CellSevenDayItem的UI模块
--@date		2017/12/19
--@author	Tianxiang_Xu
--@note		七天乐活动-左侧菜单


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellSevenDayItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellSevenDayItem:onExit(element)
	self:_unInit()
end

--@brief 	点击回调
function CellSevenDayItem:onClickCellItem(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	
	WndSevenDayActivity:onClickDayBtn(self.m_nDayIndex)
end

--@brief 	加载
function CellSevenDayItem:onLoadData(element)
	-- body
	local celElement = WZUISystem:getInstance():createElement("CellSevenDayItem")
	self.m_root:addChild(celElement)
	self.m_bIsLoad = true

	self:_update()
end

--@brief    选项高亮
function CellSevenDayItem:isItemHighLighted(bState)
    WZLog("CellSevenDayItem:isItemHighLighted = ",bState)
    self.m_bIsHighLight = bState
    if self.m_bIsLoad == false then return end

    local btnLeft = GetElement(self.m_root,"btnLeft_CellSevenDayItem",WZUIButton)
    local txtTitle = GetElement(self.m_root, "txtTitle_CellSevenDayItem", WZUILabelTTF)
    if bState then 
        local img_itemSelected = WZUI9Image:create()
        img_itemSelected = WZUI9Image:luaTo(img_itemSelected)
        img_itemSelected:setFile("ui/common/common_btn_anniu_qt_sel.png")
        btnLeft:addChild(img_itemSelected, 0, 999)
        txtTitle:setStrokeColor(GlobalMethod:ccc3(128,54,13))
    else
        txtTitle:setStrokeColor(GlobalMethod:ccc3(105,65,46))
        if btnLeft:getChildByTag(999) then 
            btnLeft:removeChildByTag(999, true)
        end 
    end 
end

--@brief 	设置红点
function CellSevenDayItem:setRedDot(bVisible)
	-- body
	self.m_bIsRedDotVisible = bVisible

	if self.m_bIsLoad == false then return end 
	local imgRedDot = GetElement(self.m_root, "imgRedDot_CellSevenDayItem", WZUIImage)
	if imgRedDot then 
		imgRedDot:setVisible(bVisible)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function CellSevenDayItem:_update()
	-- body
	local txtTitle = GetElement(self.m_root, "txtTitle_CellSevenDayItem", WZUILabelTTF)
	if txtTitle then 
		txtTitle:setText(self.m_sTitle)
	end

	self:isItemHighLighted(self.m_bIsHighLight)
	self:setRedDot(self.m_bIsRedDotVisible)
end




-------------------------------------私有方法模块End----------------------------------------
