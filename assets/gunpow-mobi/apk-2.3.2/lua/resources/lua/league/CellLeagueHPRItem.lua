--CellLeagueHPRItem.lua
--@brief	CellLeagueHPRItem的UI模块
--@date		2016/06/15
--@author	Tianxiang_Xu
--@note		英雄联赛-荣誉、回放、奖励左列表项


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellLeagueHPRItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellLeagueHPRItem:onExit(element)
	self:_unInit()
end

--@brief    加载cell数据信息
function CellLeagueHPRItem:onLoadData(element)
    -- body
    local cellElement = WZUISystem:getInstance():createElement("CellLeagueHPRItem")
    self.m_root:addChild(cellElement)

    self.m_bIsLoaded = true
    self:_update()
end

--@brief    是否选中状态
function CellLeagueHPRItem:setHighLight(bClick)
    -- body
    self.m_bIsHighLight = bClick 
    if self.m_bIsLoaded == false then return end 

    --设置选中按钮状态及文本颜色
    local btnLeft = GetElement(self.m_root, "btnLeft_CellLeagueHPRItem", WZUIButton)
    local txtName = GetElement(self.m_root, "txtName_CellLeagueHPRItem", WZUILabelTTF)

    if btnLeft and txtName then        
        btnLeft:setButtonStatus(0)
        txtName:setColor(GlobalMethod:ccc3(255,236,193))
        txtName:setEnableStroke(true)
        if bClick then
            btnLeft:setButtonStatus(1)
            txtName:setColor(GlobalMethod:ccc3(127,70,26))
            txtName:setEnableStroke(false)
        end
    end
end

--@brief    点击回调函数
function CellLeagueHPRItem:onClickCellItem(element)
    -- body
    --设置选中按钮状态及文本颜色
    local btnLeft = GetElement(self.m_root, "btnLeft_CellLeagueHPRItem", WZUIButton)
    local txtName = GetElement(self.m_root, "txtName_CellLeagueHPRItem", WZUILabelTTF)
    if btnLeft and txtName then
        btnLeft:setButtonStatus(1)
        txtName:setColor(GlobalMethod:ccc3(127,70,26))
        txtName:setEnableStroke(false)
    end
    if self.m_bIsHighLight then 
        return 
    end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

    if self.m_tCallBackFunc then
        self.m_tCallBackFunc[2](self.m_tCallBackFunc[1], self.m_keyId)
    end
end

--@brief    获取Id
function CellLeagueHPRItem:getId()
    -- body
    return self.m_keyId
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新cell信息
function CellLeagueHPRItem:_update()
    -- body
    local txtName = GetElement(self.m_root, "txtName_CellLeagueHPRItem", WZUILabelTTF)
    if self.m_sItemName then
        txtName:setText(self.m_sItemName)
    end

    if self.m_nRoundId then
        GetElement(self.m_root, "conForHonour_CellLeagueHPRItem", WZUIContainer):setVisible(true)

        local sFormat = [[<A IMG = "ui/common_num/common_num_yaoqianshuzi.png" Z ="0.67" W = "26" H = "34" CHAR = "0">%d</A><I Z ="0.87">ui/hero/hero_icon_jie.png</I>]]
        local txtRound = GetElement(self.m_root, "txtRound_CellLeagueHPRItem", WZUIFreeTextBox)
        local txtContent = string.format(sFormat, self.m_nRoundId)
        txtRound:setShowText(txtContent)

        txtName:setRelativePosition(GlobalMethod:ccp(0.5,0.34))
        txtName:setFontSize(22)
    end
    self:setHighLight(self.m_bIsHighLight)
    if ProjConfig.LANGUAGE == "vn" then
        txtName:setFontSize(18)
    end
end




-------------------------------------私有方法模块End----------------------------------------
