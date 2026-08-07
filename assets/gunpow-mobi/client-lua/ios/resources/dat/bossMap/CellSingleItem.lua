--CellSingleItem.lua
--@brief	CellSingleItem的UI模块
--@date		2013/12/18
--@author	Hugo.zheng
--@note		单人副本的副本项


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellSingleItem:onEnter(element)
	self.m_root = element
    --多语言版本界面适配
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellSingleItem:onExit(element)
	self:_unInit()
    Teach:isStartTeach("CellSingleItem:onExit")
end

--@brief	cell点击回调
--@param	element:触发事件的控件引用
function CellSingleItem:onCellClickCallback(element)
    WZLog("CellSingleItem:onCellClickCallback")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_lpClickCallback ~= nil then
        self.m_lpClickCallback(self.m_tCallbackTable,self)
    end
end
--@brief	设置HighLight是否可视
--@param	isVisible:true/false
function CellSingleItem:setHighLightVisible(isVisible)
    WZUIImage:luaTo(GetElement(self.m_root,"highLight_CellSingleItem")):setVisible(isVisible)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	cell更新函数
--@note     实际上的初始化函数
function CellSingleItem:_update()
    if self.m_root == nil then
        WZLog("CellSingleItem:_update() m_root is nil.")
        return
    end
    
    if self.m_tData == nil then
        WZLog("CellSingleItem:_update() cells' data is nil")
        return
    end

    --图片
    
    --WZUIImage:luaTo(GetElement(self.m_root,"img_o_CellSingleItem")):setFile("ui/main/bossMap/duplicate_bg01.png")
    --WZUIImage:luaTo(GetElement(self.m_root,"img_u_CellSingleItem")):setFile("ui/main/bossMap/duplicate_bg01.png")
    --WZUIImage:luaTo(GetElement(self.m_root,"img_d_CellSingleItem")):setFile("ui/main/bossMap/duplicate_bg01_not.png")
    --名字
     WZUILabelTTF:luaTo(GetElement(self.m_root,"txtTitle_CellSingleItem")):setText(self.m_tData.name)
    WZUIImage:luaTo(GetElement(self.m_root,"imgShowPass_cellSingleItem")):setVisible(false)
    if self.m_tData.status == 2 then
        WZUIButton:luaTo(GetElement(self.m_root,"btnBg_CellSingleItem")):setTouchEnable(true)
        WZUILabelTTF:luaTo(GetElement(self.m_root,"txtCurNum_CellSingleItem")):setVisible(false)
        WZUILabelTTF:luaTo(GetElement(self.m_root,"txtMaxNum_CellSingleItem")):setVisible(false)
        WZUILabelTTF:luaTo(GetElement(self.m_root,"txtXieGang_CellSingleItem")):setVisible(false)
        WZUIImage:luaTo(GetElement(self.m_root,"imgShowPass_cellSingleItem")):setVisible(true)
        WZUILabelTTF:luaTo(GetElement(self.m_root,"txtTitle_CellSingleItem")):setColor(ccc3(255,234,0))
    elseif self.m_tData.status == 1 then  
        WZUIButton:luaTo(GetElement(self.m_root,"btnBg_CellSingleItem")):setTouchEnable(true)
        WZUILabelTTF:luaTo(GetElement(self.m_root,"txtCurNum_CellSingleItem")):setVisible(true)
        WZUILabelTTF:luaTo(GetElement(self.m_root,"txtMaxNum_CellSingleItem")):setVisible(true)
        WZUILabelTTF:luaTo(GetElement(self.m_root,"txtXieGang_CellSingleItem")):setVisible(true)        
  
        --当前玩家数
        WZUILabelTTF:luaTo(GetElement(self.m_root,"txtCurNum_CellSingleItem")):setText(tostring(self.m_tData.passPoint))
        --最大玩家数
        WZUILabelTTF:luaTo(GetElement(self.m_root,"txtMaxNum_CellSingleItem")):setText(tostring(self.m_tData.tPoint))
        WZUILabelTTF:luaTo(GetElement(self.m_root,"txtTitle_CellSingleItem")):setColor(ccc3(255,234,0))
    else
        WZUIButton:luaTo(GetElement(self.m_root,"btnBg_CellSingleItem")):setTouchEnable(false)
        WZUILabelTTF:luaTo(GetElement(self.m_root,"txtCurNum_CellSingleItem")):setVisible(false)
        WZUILabelTTF:luaTo(GetElement(self.m_root,"txtMaxNum_CellSingleItem")):setVisible(false)
        WZUILabelTTF:luaTo(GetElement(self.m_root,"txtXieGang_CellSingleItem")):setVisible(false)  
        
        WZUILabelTTF:luaTo(GetElement(self.m_root,"txtTitle_CellSingleItem")):setColor(ccc3(255,255,255))
    end
end

--@note     英文适配函数
function CellSingleItem:_adaptLanguage_en()
    WZLog("CellSingleItem:_adaptLanguage_en")
    local txtTitle = WZUILabelTTF:luaTo(GetElement(self.m_root,"txtTitle_CellSingleItem"))
    txtTitle:setFontSize(25)
    txtTitle:setAnchorPoint(ccp(0.5,0.66))
    txtTitle:setRelativePosition(ccp(0.48,0.64))
    txtTitle:setDimensions(CCSize(200,80))
end
--@note     葡语适配函数
function CellSingleItem:_adaptLanguage_pt()
    WZLog("CellSingleItem:_adaptLanguage_en")
    local txtTitle = WZUILabelTTF:luaTo(GetElement(self.m_root,"txtTitle_CellSingleItem"))
    txtTitle:setFontSize(25)
    txtTitle:setAnchorPoint(ccp(0.5,0.66))
    txtTitle:setRelativePosition(ccp(0.48,0.64))
    txtTitle:setDimensions(CCSize(200,80))
end

-------------------------------------私有方法模块End----------------------------------------
-------------------------------------多语言适配模块Begin------------------------------------
--@brief  越南语适配函数
--@return 无
--@note   备注
function CellSingleItem:_adaptLanguage_vn()
    local txtTitle = WZUILabelTTF:luaTo(GetElement(self.m_root,"txtTitle_CellSingleItem"))
    txtTitle:setFontSize(25)
    txtTitle:setAnchorPoint(ccp(0.5,0.66))
    txtTitle:setRelativePosition(ccp(0.48,0.64))
    txtTitle:setDimensions(CCSize(200,80))
end

-------------------------------------多语言适配模块End------------------------------------
