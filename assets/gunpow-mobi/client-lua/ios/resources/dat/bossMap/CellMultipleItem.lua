--CellMultipleItem.lua
--@brief	CellMultipleItem的UI模块
--@date		2013/12/18
--@author	Hugo.zheng
--@note		单人副本的副本项


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellMultipleItem:onEnter(element)
	self.m_root = element
    --多语言版本界面适配
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellMultipleItem:onExit(element)
	self:_unInit()
end

--@brief	cell点击回调
--@param	element:触发事件的控件引用
function CellMultipleItem:onCellClickCallback(element)
    WZLog("CellMultipleItem:onCellClickCallback")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_lpClickCallback ~= nil then
        self.m_lpClickCallback(self.m_tCallbackTable,self)
    end
end
--@brief	设置HighLight是否可视
--@param	isVisible:true/false
function CellMultipleItem:setHighLightVisible(isVisible)
    WZUIImage:luaTo(GetElement(self.m_root,"highLight_CellMultipleItem")):setVisible(isVisible)
    WZUIImage:luaTo(GetElement(self.m_root,"highLight_CellMultipleItem")):setTouchEnable(false)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	cell更新函数
--@note     实际上的初始化函数
function CellMultipleItem:_update()
    if self.m_root == nil then
        WZLog("CellMultipleItem:_update() m_root is nil.")
        return
    end
    
    if self.m_tData == nil then
        WZLog("CellMultipleItem:_update() cells' data is nil")
        return
    end
    --图片
    WZUIImage:luaTo(GetElement(self.m_root,"img_o_CellMultipleItem")):setFile("battle/map/"..self.m_tData.mapCode.."_bg.png")
    WZUIImage:luaTo(GetElement(self.m_root,"img_u_CellMultipleItem")):setFile("battle/map/"..self.m_tData.mapCode.."_bg.png")
    WZUIImage:luaTo(GetElement(self.m_root,"img_d_CellMultipleItem")):setFile("battle/map/"..self.m_tData.mapCode.."_not_bg.png")
    
    --名字
    WZUILabelTTF:luaTo(GetElement(self.m_root,"txtTitle_CellMultipleItem")):setText(self.m_tData.mapName)
    --可否点击
    WZUIButton:luaTo(GetElement(self.m_root,"btnBg_CellMultipleItem")):setTouchEnable(self.m_tData.canPlay)
    if self.m_tData.canPlay == true then
        WZUILabelTTF:luaTo(GetElement(self.m_root,"txtTitle_CellMultipleItem")):setColor(ccc3(255,234,0))
    else
        WZUILabelTTF:luaTo(GetElement(self.m_root,"txtTitle_CellMultipleItem")):setColor(ccc3(255,255,255))
    end
    
    if self.m_tData.starLevel == 1 then
        WZUIImage:luaTo(GetElement(self.m_root,"stars1_o_CellMultipleItem")):setVisible(false)
    elseif self.m_tData.starLevel == 2 then
        WZUIImage:luaTo(GetElement(self.m_root,"stars1_o_CellMultipleItem")):setVisible(false)
        WZUIImage:luaTo(GetElement(self.m_root,"stars2_o_CellMultipleItem")):setVisible(false)
    elseif self.m_tData.starLevel == 3 then
        WZUIImage:luaTo(GetElement(self.m_root,"stars1_o_CellMultipleItem")):setVisible(false)
        WZUIImage:luaTo(GetElement(self.m_root,"stars2_o_CellMultipleItem")):setVisible(false)
        WZUIImage:luaTo(GetElement(self.m_root,"stars3_o_CellMultipleItem")):setVisible(false)
    else
        WZUIImage:luaTo(GetElement(self.m_root,"stars1_o_CellMultipleItem")):setVisible(true)
        WZUIImage:luaTo(GetElement(self.m_root,"stars2_o_CellMultipleItem")):setVisible(true)
        WZUIImage:luaTo(GetElement(self.m_root,"stars3_o_CellMultipleItem")):setVisible(true)
    end
end

--@note     英文适配函数
function CellMultipleItem:_adaptLanguage_en()
    WZLog("CellMultipleItem:_adaptLanguage_en")
    local txtTitle = WZUILabelTTF:luaTo(GetElement(self.m_root,"txtTitle_CellMultipleItem"))
    txtTitle:setFontSize(25)
    txtTitle:setAnchorPoint(ccp(0.5,0.66))
    txtTitle:setRelativePosition(ccp(0.5,0.6))
    txtTitle:setDimensions(CCSize(180,70))
end
--@note     葡语适配函数
function CellMultipleItem:_adaptLanguage_pt()
    WZLog("CellMultipleItem:_adaptLanguage_en")
    local txtTitle = WZUILabelTTF:luaTo(GetElement(self.m_root,"txtTitle_CellMultipleItem"))
    txtTitle:setFontSize(24)
    txtTitle:setAnchorPoint(ccp(0.5,0.66))
    txtTitle:setRelativePosition(ccp(0.5,0.6))
    txtTitle:setDimensions(CCSize(190,70))
end
-------------------------------------私有方法模块End----------------------------------------

--@brief  越南语适配函数
--@return 无
--@note   备注
function CellMultipleItem:_adaptLanguage_vn() 
    --副本单元标题 
    local txtTitle = WZUILabelTTF:luaTo(GetElement(self.m_root,"txtTitle_CellMultipleItem"))
    txtTitle:setFontSize(24)
    txtTitle:setAnchorPoint(ccp(0.5,0.66))
    txtTitle:setRelativePosition(ccp(0.5,0.6))
    txtTitle:setDimensions(CCSize(180,70))
end
