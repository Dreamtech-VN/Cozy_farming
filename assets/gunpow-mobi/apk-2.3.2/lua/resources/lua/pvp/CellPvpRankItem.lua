--CellPvpRankItem.lua
--@brief	CellPvpRankItem的UI模块
--@date		2017/01/12
--@author	Tianxiang_Xu
--@note		排位赛奖励面板排行


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPvpRankItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellPvpRankItem:onExit(element)
	self:_unInit()
end

-- 加载数据
function CellPvpRankItem:onLoadData(element)
    local celElement = WZUISystem:getInstance():createElement("CellPvpRankItem")
    self.m_root:addChild(celElement)

    self:_update()
end

--@brief    点击头像回调
function CellPvpRankItem:onClickHead(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndCheckOther:show(self.m_tData.id)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    更新
function CellPvpRankItem:_update()
    -- body
    WZLog("CellPvpRankItem:_update")
    local img9BK = GetElement(self.m_root, "img9BK_CellPvpRankItem", WZUI9Image)
    if self.m_tData.id == CacheCenter:getPlayerInfo().id then
        img9BK:setFile("ui/common/common_scale9_di38.png")
    end
    self:_showPhone()
    self:_showName()
end

--@brief    显示头像
function CellPvpRankItem:_showPhone()
    --设置默认显示
    local conHead = WZUIContainer:luaTo(self.m_root:getChildElement("conHead_CellPvpRankItem"))
    local m_bIsOffline = false   
    local cellElement =  CellHead:show(conHead,self.m_tData.headId,self.m_tData.faceId,self.m_tData.sex,m_bIsOffline, nil, self.m_tData.vipLevel, self.m_tData.headColor)
end

--@brief    显示名称
function CellPvpRankItem:_showName()
    local tThreeIcon = {"ui/common/common_icon_1st_1.png", "ui/common/common_icon_2nd_1.png", "ui/common/common_icon_3rd_1.png"}
    local imgRankNum = GetElement(self.m_root, "imgRankNum_CellPvpRankItem", WZUIImage)
    
    if self.m_tData.rank <= 3 then
        imgRankNum:setFile(tThreeIcon[self.m_tData.rank])
        imgRankNum:setVisible(true)
    else
        local txtRankNum = GetElement(self.m_root, "txtRankNum_CellPvpRankItem", WZUILabelTTF)
        if txtRankNum then
            txtRankNum:setText(self.m_tData.rank)
        end
    end
    local txtName = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtName_CellPvpRankItem"))
    local sName = self.m_tData.name or ""
    local sNameContent = "Lv" .. self.m_tData.level
--    txtName:setText(sNameContent)
    
    --服务器名字
    local txtServerName = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtServerName_CellPvpRankItem"))
    local sServerName = CacheCenter:getServerNameByServerId(self.m_tData.serverId)
    txtServerName:setRelativePosition(GlobalMethod:ccp(0.34,0.5))
    txtServerName:setText(sName)
    --段位
    local tBasicData = GetPvpDataByLevel(self.m_tData.matchLevel)

    if tBasicData then
        local imgIcon = GetElement(self.m_root, "imgIcon_CellPvpRankItem", WZUIImage)
        if imgIcon then 
            imgIcon:setFile("ui/common/" .. tBasicData.icon .. ".png")
            imgIcon:setScale(0.4)
        end
        local ftxtStar = GetElement(self.m_root, "ftxtStar_CellPvpRankItem", WZUIFreeTextBox)
        if ftxtStar then
            local formatStart = [[<I Z="0.6" P="1">ui/common/common_icon_xingxing5.png</I><T C="127,70,26" S="20" P="1">x%d</T>]]
            ftxtStar:setShowText(string.format(formatStart, tBasicData.level))
            local txtSectionName = GetElement(self.m_root, "txtSectionName_CellPvpRankItem", WZUILabelTTF)
            if txtSectionName then
                if tBasicData.id == 1 or tBasicData.id == 999 then
                    txtSectionName:setText(tBasicData.dan)
                else
                    txtSectionName:setText(tBasicData.dan .. tBasicData.level2)
                end
            end
        end
        -- local conSectionLevel = GetElement(self.m_root, "conSectionLevel_CellPvpRankItem", WZUIContainer)
        -- local celElement, tNewObj = CellPvpLevelIcon:createElement()
        -- if celElement and tNewObj then
        --     tNewObj:setData(tBasicData, false, 0.48)
        --     celElement:setScale(0.48)
        --     conSectionLevel:addChild(celElement)
        -- end
    end
    --战绩
    local txtBattleTimes = GetElement(self.m_root, "txtBattleTimes_CellPvpRankItem", WZUILabelTTF)
    if txtBattleTimes then
        txtBattleTimes:setText(string.format(LocalStrings.COMMUNITYINFO67, self.m_tData.attendNum, self.m_tData.winNum))
    end
    
    local ftxtResult = GetElement(self.m_root, "ftxtResult_CellPvpRankItem", WZUIFreeTextBox)
    if ftxtResult then
        local nWinPercent = 0
        if self.m_tData.attendNum > 0 then
            nWinPercent = math.floor(100 * self.m_tData.winNum / self.m_tData.attendNum)
        end
        local sContent = string.format(LocalStrings.PVP_RANK_TEXT4, nWinPercent)
        ftxtResult:setShowText(sContent)
    end

    if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "th" or ProjConfig.LANGUAGE == "tr" or ProjConfig.LANGUAGE == "vn" then
        txtBattleTimes:setScale(0.8)
        txtBattleTimes:setDimensions(GlobalMethod:CCSize(200))
        ftxtResult:setScale(0.8)
        GetElement(self.m_root, "txtSectionName_CellPvpRankItem", WZUILabelTTF):setScale(0.8)
    elseif ProjConfig.LANGUAGE == "es" then
        txtBattleTimes:setScale(0.6)
        txtBattleTimes:setDimensions(GlobalMethod:CCSize(260))
        ftxtResult:setScale(0.6)
        GetElement(self.m_root, "txtBattleTimes_CellPvpRankItem", WZUILabelTTF):setScale(0.78)
        local ftxtResult = GetElement(self.m_root, "ftxtResult_CellPvpRankItem", WZUIFreeTextBox)
        ftxtResult:setScale(0.75)
        ftxtResult:setMaxWidth(400)
        GetElement(self.m_root, "txtSectionName_CellPvpRankItem", WZUILabelTTF):setScale(0.7)
    elseif ProjConfig.LANGUAGE == "pt" then
        GetElement(self.m_root, "txtBattleTimes_CellPvpRankItem", WZUILabelTTF):setScale(0.75)
        local ftxtResult = GetElement(self.m_root, "ftxtResult_CellPvpRankItem", WZUIFreeTextBox)
        ftxtResult:setScale(0.75)
        ftxtResult:setMaxWidth(400)
    end
end
-------------------------------------私有方法模块End----------------------------------------

