--CellFuseBlessList.lua
--@brief	CellFuseBlessList的UI模块
--@date		2016/10/12
--@author	Tianxiang_Xu
--@note		圣光系统-融合祈福子节点


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellFuseBlessList:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellFuseBlessList:onExit(element)
	self:_unInit()
end

--@brief    加载
function CellFuseBlessList:onLoadData(element)
    -- body
    local celElement = WZUISystem:getInstance():createElement("CellFuseBlessList")
    self.m_root:addChild(celElement)

    self.m_nIsLoaded = true
    self:_update()
    AdaptLanguage(self)
end

--@brief    点击回调
function CellFuseBlessList:onCellClicked(element)
    -- body
    local imgHighlight = GetElement(self.m_root, "imgHighlight_CellFuseBlessList", WZUI9Image)
    if imgHighlight:isVisible() then
        return 
    end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_tCallBack then
        self.m_tCallBack[2](self.m_tCallBack[1], self.m_tData, self)
    end
end

--@brief    设置选中状态
function CellFuseBlessList:setHightLightVisible(bVisible)
    -- body
    if self.m_nIsLoaded then
        local imgHighlight = GetElement(self.m_root, "imgHighlight_CellFuseBlessList", WZUI9Image)
        if imgHighlight then
            imgHighlight:setVisible(bVisible)
        end
    end
end

--@brief    获取数据
function CellFuseBlessList:getData()
    -- body
    return self.m_tData
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新
function CellFuseBlessList:_update()
    -- body
    WZLog("CellFuseBlessList:_update")
    local tData = self.m_tData
    --名字
    local txtName = GetElement(self.m_root, "txtName_CellFuseBlessList", WZUILabelTTF)
    if txtName then
        txtName:setText(tData.basicInfo.name)
        txtName:setColor(QUALITYCOLOR[tData.basicInfo.quality])
    end
    --图标
    local spineItem = GetElement(self.m_root, "spineItem_CellFuseBlessList", WZUISpine)
    if spineItem then
        spineItem:setAnimationName(tData.basicInfo.icon)
    end
    --品质框
    local imgQuality = GetElement(self.m_root, "imgQuality_CellFuseBlessList", WZUIImage)
    if imgQuality then
        imgQuality:setFile(QUALITY_RECT_DEVOUR[tData.basicInfo.quality])
    end
    --
    self:_showState()
    --高亮
    local tTempData = WndAscending:getSelectedData()
    if tTempData ~= nil and tTempData.mergeInfo.id == tData.mergeInfo.id then
        self:setHightLightVisible(true)
    end
end

--@brief    显示状态和数量
function CellFuseBlessList:_showState()
    -- body
    local tData = self.m_tData
    
    local txtState = GetElement(self.m_root, "txtState_CellFuseBlessList", WZUILabelTTF)
    if txtState then
        local sContent
        if self.m_nLabelIndex == 1 then
            local nHavedNum = WndAscending:_getCanFuseNum(tData.mergeInfo.scrap)
            if nHavedNum < tData.nNeededNum then
                txtState:setColor(GlobalMethod:ccc3(138,122,106))
                sContent = LocalStrings.ASCENDING_FUSE17 .. "(" .. nHavedNum .. "/" .. tData.nNeededNum .. ")"
            else
                txtState:setColor(GlobalMethod:ccc3(229,105,22))
                sContent = LocalStrings.ASCENDING_FUSE18 .. "(" .. nHavedNum .. "/" .. tData.nNeededNum .. ")"
            end
        elseif self.m_nLabelIndex == 2 then
            txtState:setColor(GlobalMethod:ccc3(138,122,106))
            sContent = LocalStrings.ASCENDING_FUSE4
        end

        txtState:setText(sContent)
    end
end


-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin-------------------------------------------
function CellFuseBlessList:_adaptLanguage_pt(  )
    GetElement(self.m_root,"txtState_CellFuseBlessList",WZUILabelTTF):setFontSize(16)
end

function CellFuseBlessList:_adaptLanguage_es(  )
    GetElement(self.m_root,"txtState_CellFuseBlessList",WZUILabelTTF):setFontSize(14)
    GetElement(self.m_root,"txtName_CellFuseBlessList",WZUILabelTTF):setFontSize(16)
end
function CellFuseBlessList:_adaptLanguage_en(  )
    GetElement(self.m_root,"txtState_CellFuseBlessList",WZUILabelTTF):setFontSize(16)
end
--------------------------------------语言适配End----------------------------------------------