--CellBlessItem.lua
--@brief	CellBlessItem的UI模块
--@date		2016/03/25
--@author	Tianxiang_Xu
--@note		祈福节点


-------------------------------------公有方法模块Begin--------------------------------------
QUALITY_RECT = {"ui/common/common_scale9_wuse.png","ui/common/frame_green.png", "ui/common/frame_bule.png", "ui/common/frame_violet.png", "ui/common/frame_orange.png"}

GRID_ONLY_BK = 1    --只显示格子
GRID_NO_LEVEL = 2   --不显示背景格子
GRID_ALL_INFO = 3   --显示背景格子，名字，等级
GRID_BAG_INFO = 4   --背包中显示类型
GRID_DEVOUR_BK = 5   --只显示圆底格子
GRID_DEVOUR_NODE = 6   --显示圆底格子,等级，名字，图标，不弹tips
GRID_DEVOUR_CHOOSE = 7   --不显示圆底格子,显示等级，名字，图标，不弹tips，不可触摸
GRID_SHOP_BLESS = 8   --只显示图标，不可触摸
GRID_FOR_FUSE = 9   --不显示背景格子,等级属性往下移
GRID_FOR_FUSE_YELLOW = 10 --
GRID_FOR_REWARD = 11    --展示奖励


--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellBlessItem:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellBlessItem:onExit(element)
	self:_unInit()
end

--@brief    更新节点显示信息
function CellBlessItem:update()
    -- body
    WZLog("CellBlessItem:update")
    local btnBlessItem = GetElement(self.m_root, "btnBlessItem_CellBlessItem", WZUIButton)
    local spineBlessIcon = GetElement(self.m_root, "spineItem_CellBlessItem", WZUISpine)
    local imgQuality = GetElement(self.m_root, "imgQuality_CellBlessItem", WZUIImage)
    local txtBlessName = GetElement(self.m_root, "txtBlessName_CellBlessItem", WZUILabelTTF)
    local imgBK = GetElement(self.m_root, "imgBK_CellBlessItem", WZUIImage)
    local conInfo = GetElement(self.m_root, "conInfo_CellBlessItem", WZUIContainer)
    local QUALITY_COLOR = {GlobalMethod:ccc3(255,255,255), GlobalMethod:ccc3(99,255,95), GlobalMethod:ccc3(93,222,254), GlobalMethod:ccc3(198,130,255), GlobalMethod:ccc3(233,166,62)}

    imgQuality:setVisible(false)
    
    if self.m_nType == GRID_ONLY_BK then
        conInfo:setVisible(false)
        imgBK:setFile("ui/common/common_scale9_beibaodi.png")
    elseif self.m_nType == GRID_NO_LEVEL then
        conInfo:setVisible(true)
        imgBK:setVisible(false)
    elseif self.m_nType == GRID_BAG_INFO then
        txtBlessName:setFontSize(20)
        conInfo:setVisible(true)
    elseif self.m_nType == GRID_DEVOUR_BK then
        conInfo:setVisible(false)
        imgBK:setFile("ui/bless/common_icon_qifudikuang.png")
    elseif self.m_nType == GRID_DEVOUR_NODE then
        conInfo:setVisible(true)
        imgBK:setFile("ui/bless/common_icon_qifudikuang.png")
    elseif self.m_nType == GRID_DEVOUR_CHOOSE then
        conInfo:setVisible(true)
        imgBK:setVisible(false)
        btnBlessItem:setTouchEnable(false)
    elseif self.m_nType == GRID_SHOP_BLESS then
        conInfo:setVisible(true)
        imgQuality:setVisible(false)
        imgBK:setVisible(false)
        txtBlessName:setVisible(false)
        btnBlessItem:setTouchEnable(false)
    elseif self.m_nType == GRID_FOR_FUSE or self.m_nType == GRID_FOR_FUSE_YELLOW then
        conInfo:setVisible(true)
        imgBK:setVisible(false)
        if self.m_nType == GRID_FOR_FUSE then
            txtBlessName:setFontSize(24)
        else
            txtBlessName:setFontSize(18)
        end
        txtBlessName:setRelativePosition(GlobalMethod:ccp(0.5, -0.32))
    elseif self.m_nType == GRID_FOR_REWARD then 
        imgQuality:setVisible(true)
        txtBlessName:setVisible(false)
        --数量
        self:_createNum(conInfo)
    else
        conInfo:setVisible(true)
    end

    if self.m_tData then
        --品质框和祈福图标
        if self.m_nType == GRID_BAG_INFO then
            txtBlessName:setFontSize(20)
            imgBK:setFile("ui/common/common_scale9_beibaodi2.png")
            imgQuality:setVisible(true)
        elseif self.m_nType == GRID_DEVOUR_NODE then
            txtBlessName:setFontSize(20)
            GetElement(self.m_root, "conGou_CellBlessItem", WZUIContainer):setVisible(self.m_tData.bIsChoose)
        end
        WZLog("******** ICON ********", self.m_tData.basicInfo.icon)

        spineBlessIcon:setAnimationName(self.m_tData.basicInfo.icon)

        if self.m_nType == GRID_SHOP_BLESS then 
            imgQuality:setFile(g_tShopItemQuality[self.m_tData.basicInfo.quality + 1])
        else
            imgQuality:setFile(QUALITY_RECT[self.m_tData.basicInfo.quality + 1])
        end
        --祈福名称，等级
        txtBlessName:setText("Lv"..self.m_tData.level .. self.m_tData.basicInfo.name)
        txtBlessName:setColor(QUALITY_COLOR[self.m_tData.basicInfo.quality + 1])
    end

    if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "ug" then
        txtBlessName:setFontSize(12)
        txtBlessName:setDimensions(GlobalMethod:CCSize(80))
    end

    if ProjConfig.LANGUAGE == "th" then
        txtBlessName:setFontSize(12)
    end

    if ProjConfig.LANGUAGE == "vn" then
        txtBlessName:setFontSize(12)
    end

    if ProjConfig.LANGUAGE == "tr" or ProjConfig.LANGUAGE == "es" then
        txtBlessName:setFontSize(12)
    end
end

--@brief    点击相应函数
function CellBlessItem:onClickEvent(element)
    -- body
    WZLog("CellBlessItem:onClickEvent")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_bIsExtraction then
        if WndExtraction.m_root and not WndExtraction.m_bIsCanExtraction then
            return 
        end
    end
    
    if self.m_nType == GRID_DEVOUR_NODE then
        self.m_tData.bIsChoose = not self.m_tData.bIsChoose
    --    GetElement(self.m_root, "conGou_CellBlessItem", WZUIContainer):setVisible(self.m_tData.bIsChoose)
        self.m_tDevourCallBack[2](self.m_tDevourCallBack[1], self.m_tData, self)
        return
    end

    local tData = self.m_tData
    tData.tCallBack = self.m_tCallBack

    if self.m_tCallBack2 then
        local nTag = self.m_root:getTag()
        local bTempVisible = self.m_bIsGrayBG 
        self.m_tCallBack2[2](self.m_tCallBack2[1], self, nTag, tData)
        if bTempVisible then
            return 
        end
    end
    if self.m_nType == GRID_FOR_REWARD then
        WZLog("CellBlessItem:onClickEvent 11111")
        WndTips:show(element, self.m_tTipParentNode, 25, tData, GlobalMethod:ccp(-200, -100))
        return 
    end
    WndTips:show(element,self.m_tTipParentNode,25,tData,GlobalMethod:ccp(200,20))
end

--@brief    重新设置祝福点的选中状态
function CellBlessItem:setConGouVisible(bVisible)
    -- body
    if self.m_root then
        self.m_tData.bIsChoose = bVisible
        GetElement(self.m_root, "conGou_CellBlessItem", WZUIContainer):setVisible(bVisible)
    end
end

--@brief    设置祝福半透明状态
function CellBlessItem:setConGrayBGVisible(bVisible)
    -- body
    if self.m_root then
        self.m_bIsGrayBG = bVisible
        GetElement(self.m_root, "conGrayBG_CellBlessItem", WZUIContainer):setVisible(bVisible)
    end
end

--@brief    获取祝福节点数据
function CellBlessItem:getData()
    -- body
    return self.m_tData
end

--@brief    重置祝福节点数据
function CellBlessItem:resetData(tData)
    -- body
    self.m_tData = tData 
    
    local txtBlessName = GetElement(self.m_root, "txtBlessName_CellBlessItem", WZUILabelTTF)
    txtBlessName:setText("Lv"..self.m_tData.level .. self.m_tData.basicInfo.name)
end

function CellBlessItem:displayName()
    GetElement(self.m_root, "txtBlessName_CellBlessItem", WZUILabelTTF):setVisible(false)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    设置数量
function CellBlessItem:_createNum(nodeParent)
    -- body
    if self.m_tData.num == nil then return end 

    local txtNum = WZUILabelTTF:create()
    txtNum:setAnchorPoint(GlobalMethod:ccp(1, 0))
    txtNum:setRelativePosition(GlobalMethod:ccp(1, 0))
    txtNum:setText(self.m_tData.num)
    txtNum:setColor(GlobalMethod:ccc3(255,255,255))
    txtNum:setFontSize(24)
    nodeParent:addChild(txtNum)
end




-------------------------------------私有方法模块End----------------------------------------

----------------------------------------语言适配Begin----------------------------------------
-- function CellBlessItem:_adaptLanguage_en(  )
--     local txtName = GetElement(self.m_root,"txtBlessName_CellBlessItem",WZUILabelTTF)
--     txtName:setFontSize(16)
-- end
----------------------------------------语言适配End------------------------------------------