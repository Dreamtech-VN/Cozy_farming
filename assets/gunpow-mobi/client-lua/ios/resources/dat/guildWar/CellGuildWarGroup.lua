--CellGuildWarGroup.lua
--@brief	CellGuildWarGroup的UI模块
--@date		2017/02/08
--@author	Tianxiang_Xu
--@note		公会战小组分组赛况


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellGuildWarGroup:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellGuildWarGroup:onExit(element)
	self:_unInit()
end

--@brief    点击某一公会回调
function CellGuildWarGroup:onCheckGuildInfo(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local tData = self.m_tData 
    local nTag = element:getTag()
    tTag = {math.floor(nTag/10), math.mod(nTag,10)}
    WZLog("CellGuildWarGroup:onCheckGuildInfo", Serialize(tTag))
    local guildId = -1 
    if tTag[1] == 1 then
        guildId = tData[tTag[2]].guildId
    elseif tTag[1] == 2 then
        for i = 1, #tData do
            if tData[i].guildResult > 1 then
                local nSecondIndex = math.ceil(i/2)
                if nSecondIndex == tTag[2] then
                    guildId = tData[i].guildId
                    break 
                end
            end
        end
    elseif tTag[1] == 3 then
        for i = 1, #tData do
            if tData[i].guildResult > 2 then
                local nTempIndex = math.ceil(i/4)
                if nTempIndex == tTag[2] then
                    guildId = tData[i].guildId
                    break 
                end
            end
        end
    elseif tTag[1] == 4 then
        for i = 1, #tData do
            if tData[i].guildResult > 3 then
                guildId = tData[i].guildId
            end
        end
    end
    
    SceneCommunityWar:onCheckCommunityInfo(guildId)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新
-- 比赛名次（1为32强,2为16强，3为8强，4为4强，5为 4强进2强失败，6为2强，7为 第四名,8为季军，9为亚军，10为冠军）
function CellGuildWarGroup:_update()
    -- body
    self:_setStaticText() 

    local tData = self.m_tData 
    local sNameFormat = [[<T C="233,166,62" S="18" P="1">%s%d</T><T C="255,236,193" S="18" P="1"> %s</T>]]
    local sNameFormat2 = [[<T C="255,227,116" S="18" P="1">%s%d</T><T C="255,236,193" S="18" P="1"> %s</T>]]
    local sGroupMark 
    if self.m_nGroupIndex == 1 then
        sGroupMark = "A"
    elseif self.m_nGroupIndex == 2 then
        sGroupMark = "B"
    elseif self.m_nGroupIndex == 3 then
        sGroupMark = "C"
    elseif self.m_nGroupIndex == 4 then
        sGroupMark = "D"
    end
    WZLog("CellGuildWarGroup:_update")
    local nRealGuildNum = self:_getRealGuildNum(tData)
    for i = 1, #tData do
        --第一阶段
        local ftxtGuildName = GetElement(self.m_root, "ftxtGuildName1_" .. i .. "_CellGuildWarGroup", WZUIFreeTextBox)
        if ftxtGuildName then
            if tData[i].guildId == -1 then
                ftxtGuildName:setShowText(string.format(sNameFormat, sGroupMark, i, LocalStrings.COMMONITY_DESC14))
            else
                ftxtGuildName:setShowText(string.format(sNameFormat, sGroupMark, i, tData[i].guildName))
            end
        end
        if tData[i].guildResult > 1 then
            ftxtGuildName:setShowText(string.format(sNameFormat2, sGroupMark, i, tData[i].guildName))
            local img9WinBg = GetElement(self.m_root, "img9WinBg1_" .. i .. "_CellGuildWarGroup", WZUI9Image)
            if img9WinBg then
                img9WinBg:setVisible(true)
            end
            --亮的线
            local imgLine = GetElement(self.m_root, "imgLine1_" .. i .. "_CellGuildWarGroup", WZUIImage)
            if imgLine then
                imgLine:setFile("ui/community/common_pic_xiank1_sel.png")
                imgLine:setZOrder(tData[i].guildResult)
            end
        end
        --第二阶段
        if tData[i].guildResult > 1 then
            local nSecondIndex = math.ceil(i/2)
            local txtGroupName = GetElement(self.m_root, "txtGroupName2_" .. nSecondIndex .. "_CellGuildWarGroup", WZUILabelTTF)
            if txtGroupName then
                txtGroupName:setColor(GlobalMethod:ccc3(233,166,62))
                txtGroupName:setText(sGroupMark .. i)
            end
            if tData[i].guildResult > 2 then
                local img9WinBg = GetElement(self.m_root, "img9WinBg2_" .. nSecondIndex .. "_CellGuildWarGroup", WZUI9Image)
                txtGroupName:setColor(GlobalMethod:ccc3(255,227,116))
                if img9WinBg then
                    img9WinBg:setVisible(true)
                end
                --亮的线
                local imgLine = GetElement(self.m_root, "imgLine2_" .. nSecondIndex .. "_CellGuildWarGroup", WZUIImage)
                if imgLine then
                    imgLine:setFile("ui/community/common_pic_xiank2_sel.png")
                    imgLine:setZOrder(tData[i].guildResult)
                end
            end
        end
        --第三阶段
        if tData[i].guildResult > 2 then
            local nThirdIndex = math.ceil(i/4)
            local txtGroupName = GetElement(self.m_root, "txtGroupName3_" .. nThirdIndex .. "_CellGuildWarGroup", WZUILabelTTF)
            if txtGroupName then
                txtGroupName:setColor(GlobalMethod:ccc3(233,166,62))
                txtGroupName:setText(sGroupMark .. i)
            end
            if tData[i].guildResult > 3 then
                local img9WinBg = GetElement(self.m_root, "img9WinBg3_" .. nThirdIndex .. "_CellGuildWarGroup", WZUI9Image)
                txtGroupName:setColor(GlobalMethod:ccc3(255,227,116))
                if img9WinBg then
                    img9WinBg:setVisible(true)
                end
                --亮的线
                local imgLine = GetElement(self.m_root, "imgLine3_" .. nThirdIndex .. "_CellGuildWarGroup", WZUIImage)
                if imgLine then
                    imgLine:setFile("ui/community/common_pic_xiank3_sel.png")
                    imgLine:setZOrder(tData[i].guildResult)
                end
            end

            nThirdIndex = nThirdIndex + 1
        end
        --某一组的冠军
        if tData[i].guildResult > 3 then
            local ftxtGuildName = GetElement(self.m_root, "ftxtGuildName4_1_CellGuildWarGroup", WZUIFreeTextBox)
            if ftxtGuildName then
                ftxtGuildName:setShowText(string.format(sNameFormat2, sGroupMark, i, tData[i].guildName))
            end
            local img9WinBg = GetElement(self.m_root, "img9WinBg4_1_CellGuildWarGroup", WZUI9Image)
            if img9WinBg then
                img9WinBg:setVisible(true)
            end
            --
            local txtGroupChampion = GetElement(self.m_root, "txtGroupChampion_CellGuildWarGroup", WZUILabelTTF)
            if txtGroupChampion then
                txtGroupChampion:setVisible(true)
                txtGroupChampion:setText(sGroupMark .. LocalStrings.COMMUNITY_COMPETE_TEXT22 .. LocalStrings.FIRST_PLACE)
                if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "tr" then
                    txtGroupChampion:setText(sGroupMark .. " " .. LocalStrings.COMMUNITY_COMPETE_TEXT22 .. " " .. LocalStrings.FIRST_PLACE)
                end
            end
        end
    end
end

--@brief    设置默认文字
function CellGuildWarGroup:_setStaticText()
    -- body
    local sNameFormat = [[<T C="138,122,106" S="18" P="1">%s</T>]]
    for i = 1, 8 do 
        local ftxtGuildName = GetElement(self.m_root, "ftxtGuildName1_" .. i .. "_CellGuildWarGroup", WZUIFreeTextBox)
        if ftxtGuildName then
            ftxtGuildName:setShowText(string.format(sNameFormat,LocalStrings.COMMUNITY_COMPETE_TEXT15))
        end
    end
    for i = 1, 4 do 
        local txtGroupName = GetElement(self.m_root, "txtGroupName2_" .. i .. "_CellGuildWarGroup", WZUILabelTTF)
        if txtGroupName then
            txtGroupName:setColor(GlobalMethod:ccc3(138,122,106))
            txtGroupName:setText(LocalStrings.COMMUNITY_COMPETE_TEXT15)
            if ProjConfig.LANGUAGE == "en" then
                txtGroupName:setScale(0.5)
                txtGroupName:setDimensions(GlobalMethod:CCSize(100))
            elseif ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" then
                txtGroupName:setScale(0.5)
                txtGroupName:setDimensions(GlobalMethod:CCSize(100))
            elseif ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "tr" then
                txtGroupName:setScale(0.5)
                txtGroupName:setDimensions(GlobalMethod:CCSize(100))
            elseif ProjConfig.LANGUAGE == "vn" then
                txtGroupName:setFontSize(11)
                txtGroupName:setDimensions(GlobalMethod:CCSize(60,0))
            end
        end
    end
    for i = 1, 2 do 
        local txtGroupName = GetElement(self.m_root, "txtGroupName3_" .. i .. "_CellGuildWarGroup", WZUILabelTTF)
        if txtGroupName then
            txtGroupName:setColor(GlobalMethod:ccc3(138,122,106))
            txtGroupName:setText(LocalStrings.COMMUNITY_COMPETE_TEXT15)
            if ProjConfig.LANGUAGE == "en" then
                txtGroupName:setScale(0.5)
                txtGroupName:setDimensions(GlobalMethod:CCSize(100))
            elseif ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" then
                txtGroupName:setScale(0.5)
                txtGroupName:setDimensions(GlobalMethod:CCSize(100))
            elseif ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "tr" then
                txtGroupName:setScale(0.5)
                txtGroupName:setDimensions(GlobalMethod:CCSize(100))
            elseif ProjConfig.LANGUAGE == "vn" then
                txtGroupName:setFontSize(11)
                txtGroupName:setDimensions(GlobalMethod:CCSize(60,0))
            end
        end
    end

    local ftxtGuildName = GetElement(self.m_root, "ftxtGuildName4_1_CellGuildWarGroup", WZUIFreeTextBox)
    if ftxtGuildName then
        ftxtGuildName:setShowText(string.format(sNameFormat, LocalStrings.COMMUNITY_COMPETE_TEXT15))
    end
end

--@brief    获取实际参与的公会数量
function CellGuildWarGroup:_getRealGuildNum(tData)
    -- body
    local num = 0 
    for i = 1, #tData do
        if tData.guildId ~= -1 then
            num = num + 1
        end
    end

    return num 
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配Begin------------------------------------------
function CellGuildWarGroup:_adaptLanguage_pt( )
    GetElement(self.m_root, "txtGroupChampion_CellGuildWarGroup", WZUILabelTTF):setScale(0.8)
end


-------------------------------------语言适配End--------------------------------------------