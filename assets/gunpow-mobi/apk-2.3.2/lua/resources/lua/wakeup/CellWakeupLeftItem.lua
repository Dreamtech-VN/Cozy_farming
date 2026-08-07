--CellWakeupLeftItem.lua
--@brief	CellWakeupLeftItem的UI模块
--@date		2017/05/20
--@author	Tianxiang_Xu
--@note		觉醒模块-左菜单项


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellWakeupLeftItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellWakeupLeftItem:onExit(element)
	self:_unInit()
end

--@brief    点击按钮回调
function CellWakeupLeftItem:onClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    if self.m_tCallBack then
        self.m_tCallBack[2](self.m_tCallBack[1], self.m_tData.id - 1)
    end
end

--@brief    开始加载
function CellWakeupLeftItem:onLoadData(element)
    -- body
    local celElement = WZUISystem:getInstance():createElement("CellWakeupLeftItem")
    self.m_root:addChild(celElement)

    self.m_bIsLoaded = true
    self:_update()
    AdaptLanguage(self)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    更新
function CellWakeupLeftItem:_update()
    -- body
    local txtName = GetElement(self.m_root, "txtName_CellWakeupLeftItem", WZUILabelTTF)
    if txtName then
        txtName:setText(self.m_tData.name)
    end

    self:setSelVisible(self.m_bIsSel)
end

--@brief    设置选中状态是否可见
function CellWakeupLeftItem:setSelVisible(bVisible)
    -- body
    self.m_bIsSel = bVisible 

    if not self.m_bIsLoaded then return end 
    local img9Sel = GetElement(self.m_root, "img9Sel_CellWakeupLeftItem", WZUI9Image)
    if img9Sel then
        img9Sel:setVisible(bVisible)
    end
end


-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function CellWakeupLeftItem:_adaptLanguage_vn(  )
    local txtName = GetElement(self.m_root,"txtName_CellWakeupLeftItem",WZUILabelTTF)
    --txtName:setDimensions(GlobalMethod:CCSize(170,0))
    txtName:setFontSize(20)
end

function CellWakeupLeftItem:_adaptLanguage_en(  )
    local txtName = GetElement(self.m_root,"txtName_CellWakeupLeftItem",WZUILabelTTF)
    txtName:setDimensions(GlobalMethod:CCSize(170,0))
    txtName:setFontSize(20)
end

function CellWakeupLeftItem:_adaptLanguage_th(  )
    local txtName = GetElement(self.m_root,"txtName_CellWakeupLeftItem",WZUILabelTTF)
    txtName:setDimensions(GlobalMethod:CCSize(170,0))
    txtName:setFontSize(20)
end

function CellWakeupLeftItem:_adaptLanguage_pt(  )
    local txtName = GetElement(self.m_root,"txtName_CellWakeupLeftItem",WZUILabelTTF)
    txtName:setDimensions(GlobalMethod:CCSize(170,0))
    txtName:setFontSize(20)
end

function CellWakeupLeftItem:_adaptLanguage_es(  )
    local txtName = GetElement(self.m_root,"txtName_CellWakeupLeftItem",WZUILabelTTF)
    txtName:setDimensions(GlobalMethod:CCSize(170,0))
    txtName:setFontSize(20)
end

function CellWakeupLeftItem:_adaptLanguage_tr(  )
    local txtName = GetElement(self.m_root,"txtName_CellWakeupLeftItem",WZUILabelTTF)
    txtName:setDimensions(GlobalMethod:CCSize(170,0))
    txtName:setFontSize(20)
end

function CellWakeupLeftItem:_adaptLanguage_ug(  )
    local txtName = GetElement(self.m_root,"txtName_CellWakeupLeftItem",WZUILabelTTF)
    txtName:setDimensions(GlobalMethod:CCSize(280,0))
    txtName:setScale(0.6)
end
-------------------------------------语言适配End--------------------------------------------