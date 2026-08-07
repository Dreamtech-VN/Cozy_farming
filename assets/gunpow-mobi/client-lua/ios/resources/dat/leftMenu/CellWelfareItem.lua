--CellWelfareItem.lua
--@brief	CellWelfareItem的UI模块
--@date		2016/05/12
--@author	Tianxiang_Xu
--@note		福利或比赛子分类


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellWelfareItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellWelfareItem:onExit(element)
	self:_unInit()
end

--@brief    设置是否高亮显示
function CellWelfareItem:setLightVisible(bVisible)
    -- body
    self.m_bIsHighLight = bVisible
    if self.m_bIsLoad == false then return end
    GetElement(self.m_root, "img_itemState", WZUIImage):setVisible(bVisible)
end

--@brief    加载时才显示cell信息
function CellWelfareItem:onLoadData(element)
    WZLog("CellWelfareItem:onLoadData")
    local cellElement = WZUISystem:getInstance():createElement("CellWelfareItem")
    self.m_root:addChild(cellElement)

    self.m_bIsLoad = true
    self:_update()
end

--@brief    获取itemId
function CellWelfareItem:getItemId()
    -- body
    return self.m_nItemId
end

--@brief    点击回调
function CellWelfareItem:onClickCellItem(element)
    -- body
    local bVisible = GetElement(self.m_root, "img_itemState", WZUIImage):isVisible()
    if bVisible and self.m_nItemId ~= 999998 then 
        return 
    end

    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    if self.m_tCallBack then
        self.m_tCallBack[2](self.m_tCallBack[1],self.m_nItemId)
    end
end

--@brief    设置红点是否可见
function CellWelfareItem:setRedDotVisible(bVisible)
    -- body
    self.m_bIsHaveRedDot = bVisible
    if self.m_bIsLoad == false then return end
    if self.m_bIsHaveRedDot == true then
        if not  self.m_root:getChildByTag(99) then 
            local spr_redPoint =  CCSprite:create("ui/common/common_icon_xiaodianzhui.png")
            spr_redPoint:setAnchorPoint(GlobalMethod:ccp(1,1))
            spr_redPoint:setPosition(220, 75)
            self.m_root:addChild(spr_redPoint,5,99)
        end
    end
end

--@brief    移除红点
function CellWelfareItem:removeRedDot()
    -- body
    if self.m_root:getChildByTag(99) then 
        self.m_root:removeChildByTag(99, true)
        self.m_bIsHaveRedDot = false
    end
end


function CellWelfareItem:setFyberTime()
    if NeedFyber(2) then
        local conFyber = self.m_root:getChildElement("conTop_CellWelfareItem")
        conFyber:setVisible(true)
        GetElement(self.m_root,"txtItemName_CellWelfareItem",WZUILabelTTF):setText(LocalStrings.ATH_REWARD_CHECK)
    end 
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    信息刷新
function CellWelfareItem:_update()
    -- body
    --语言适配
    AdaptLanguage(self)

    local txtItemName = GetElement(self.m_root, "txtItemName_CellWelfareItem", WZUILabelTTF)
    if self.m_sItemName then
        txtItemName:setText(self.m_sItemName)
    end
    --设置高亮
    if self.m_bIsHighLight ~= nil then
        self:setLightVisible(self.m_bIsHighLight)
    end
    if self.m_bIsHaveRedDot ~= nil then
        self:setRedDotVisible(self.m_bIsHaveRedDot)
    end

    if self.m_nItemId == 999998 then
        self:setFyberTime()
    end
end
-------------------------------------私有方法模块End----------------------------------------
-------------------------------------语言适配模块Start----------------------------------------
--@brief    英语适配
function CellWelfareItem:_adaptLanguage_en()
    local txtItemName = GetElement(self.m_root, "txtItemName_CellWelfareItem", WZUILabelTTF)
    if txtItemName then
        txtItemName:setFontSize(22)
        txtItemName:setDimensions((GlobalMethod:CCSize(200,0)))
    end
end

function CellWelfareItem:_adaptLanguage_th()
    local txtItemName = GetElement(self.m_root, "txtItemName_CellWelfareItem", WZUILabelTTF)
    if txtItemName then
        txtItemName:setScale(0.8)
        txtItemName:setDimensions(GlobalMethod:CCSize(240))
    end
end

function CellWelfareItem:_adaptLanguage_pt( )
    local txtItemName = GetElement(self.m_root, "txtItemName_CellWelfareItem", WZUILabelTTF)
    if txtItemName then
        txtItemName:setFontSize(20)
        txtItemName:setDimensions((GlobalMethod:CCSize(200,0)))
    end
end

function CellWelfareItem:_adaptLanguage_vn( )
    local txtItemName = GetElement(self.m_root, "txtItemName_CellWelfareItem", WZUILabelTTF)
    if txtItemName then
        txtItemName:setFontSize(20)
        txtItemName:setDimensions((GlobalMethod:CCSize(200,0)))
    end
end

function CellWelfareItem:_adaptLanguage_tr( )
    local txtItemName = GetElement(self.m_root, "txtItemName_CellWelfareItem", WZUILabelTTF)
    if txtItemName then
        txtItemName:setFontSize(20)
        txtItemName:setDimensions((GlobalMethod:CCSize(200,0)))
    end
end

function CellWelfareItem:_adaptLanguage_es( )
    local txtItemName = GetElement(self.m_root, "txtItemName_CellWelfareItem", WZUILabelTTF)
    if txtItemName then
        txtItemName:setFontSize(20)
        txtItemName:setDimensions((GlobalMethod:CCSize(200,0)))
    end
end
-------------------------------------语言适配模块End----------------------------------------