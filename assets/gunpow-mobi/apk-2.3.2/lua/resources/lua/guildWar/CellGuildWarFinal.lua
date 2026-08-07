--CellGuildWarFinal.lua
--@brief	CellGuildWarFinal的UI模块
--@date		2017/02/09
--@author	Tianxiang_Xu
--@note		公会战-决赛界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellGuildWarFinal:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellGuildWarFinal:onExit(element)
	self:_unInit()
end

--@brief    点击某一公会回调
function CellGuildWarFinal:onCheckGuildInfo(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local tData = self.m_tData 
    local nTag = element:getTag()
    tTag = {math.floor(nTag/10), math.fmod(nTag,10)}
    WZLog("CellGuildWarFinal:onCheckGuildInfo", Serialize(tTag))
    local guildId = -1 
    if tTag[1] == 0 then
        if nTag == 1 then
            for i = 1, #tData do
                if tData[i].guildResult == 10 then
                    guildId = tData[i].guildId
                    break 
                end
            end
        elseif nTag == 2 then
            for i = 1, #tData do
                if tData[i].guildResult == 9 then
                    guildId = tData[i].guildId
                    break 
                end
            end
        elseif nTag == 3 then
            for i = 1, #tData do
                if tData[i].guildResult == 8 then
                    guildId = tData[i].guildId
                    break 
                end
            end
        end
    else
        if tTag[1] == 1 then
            guildId = tData[tTag[2]].guildId
        elseif tTag[1] == 2 then
            for i = 1, #tData do
                if tData[i].guildResult == 6 or tData[i].guildResult == 9 or tData[i].guildResult == 10 then
                    local nSecondIndex = math.ceil(i/2)
                    if nSecondIndex == tTag[2] then
                        guildId = tData[i].guildId
                        break 
                    end
                end
            end
        elseif tTag[1] == 3 then
            for i = 1, #tData do
                if tData[i].guildResult == 5 or tData[i].guildResult == 7 or tData[i].guildResult == 8 then
                    local nTempIndex = math.ceil(i/2)
                    if nTempIndex == tTag[2] then
                        guildId = tData[i].guildId
                        break 
                    end
                end
            end
        elseif tTag[1] == 4 then
            for i = 1, #tData do
                if tData[i].guildResult == 10 then
                    guildId = tData[i].guildId
                end
            end
        end
    end

    SceneCommunityWar:onCheckCommunityInfo(guildId)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新
--@nate     guildResult:（1为32强,2为16强，3为8强，4为4强，5为 4强进2强失败，6为2强，7为 第四名,8为季军，9为亚军，10为冠军）
function CellGuildWarFinal:_update()
    -- body
    self:_setStaticText() 

    local tData = self.m_tData 
    local sNameFormat = [[<T C="127,70,26" S="18" P="1">%s%d</T><T C="127,70,26" S="18" P="1"> %s</T>]]
    local sNameFormat2 = [[<T C="255,236,193" S="18" P="1">%s%d</T><T C="255,236,193" S="18" P="1"> %s</T>]]
    
    WZLog("CellGuildWarFinal:_update")
    for i = 1, #tData do
        local sGroupMark 
        if i == 1 then
            sGroupMark = "A"
        elseif i == 2 then
            sGroupMark = "B"
        elseif i == 3 then
            sGroupMark = "C"
        elseif i == 4 then
            sGroupMark = "D"
        end
        --第一阶段
        if tData[i].guildResult > 3 then
            local ftxtGuildName = GetElement(self.m_root, "ftxtGuildName1_" .. i .. "_CellGuildWarFinal", WZUIFreeTextBox)
            if ftxtGuildName then
                ftxtGuildName:setShowText(string.format(sNameFormat, sGroupMark, tData[i].guildGroupNo, tData[i].guildName))
            end
            if tData[i].guildResult == 6 or tData[i].guildResult == 9 or tData[i].guildResult == 10 then
                ftxtGuildName:setShowText(string.format(sNameFormat2, sGroupMark, tData[i].guildGroupNo, tData[i].guildName))
                local img9WinBg = GetElement(self.m_root, "img9WinBg1_" .. i .. "_CellGuildWarFinal", WZUI9Image)
                if img9WinBg then
                    img9WinBg:setVisible(true)
                end
                --亮的线
                local imgLine = GetElement(self.m_root, "imgLine1_" .. i .. "_CellGuildWarFinal", WZUIImage)
                if imgLine then
                    imgLine:setFile("ui/community/common_pic_xiank1_sel.png")
                    imgLine:setZOrder(tData[i].guildResult)
                end
            end
        end
        --第二阶段
        if tData[i].guildResult == 6 or tData[i].guildResult == 9 or tData[i].guildResult == 10 then
            local nSecondIndex = math.ceil(i/2)
            local txtGroupName = GetElement(self.m_root, "txtGroupName2_" .. nSecondIndex .. "_CellGuildWarFinal", WZUILabelTTF)
            if txtGroupName then
                txtGroupName:setColor(GlobalMethod:ccc3(233,166,62))
                txtGroupName:setText(sGroupMark .. tData[i].guildGroupNo)
            end
            if tData[i].guildResult == 10 then
                txtGroupName:setColor(GlobalMethod:ccc3(255,227,116))
                local img9WinBg = GetElement(self.m_root, "img9WinBg2_" .. nSecondIndex .. "_CellGuildWarFinal", WZUI9Image)
                if img9WinBg then
                    img9WinBg:setVisible(true)
                end
                --亮的线
                local imgLine = GetElement(self.m_root, "imgLine2_" .. nSecondIndex .. "_CellGuildWarFinal", WZUIImage)
                if imgLine then
                    imgLine:setFile("ui/community/common_pic_xiank2_sel.png")
                    imgLine:setZOrder(tData[i].guildResult)
                end
            end
        end
        --冠军
        if tData[i].guildResult == 10 then
            local ftxtGuildName = GetElement(self.m_root, "ftxtGuildName4_1_CellGuildWarFinal", WZUIFreeTextBox)
            if ftxtGuildName then
                ftxtGuildName:setShowText(string.format(sNameFormat2, sGroupMark, tData[i].guildGroupNo, tData[i].guildName))
            end
            local img9WinBg = GetElement(self.m_root, "img9WinBg4_1_CellGuildWarFinal", WZUI9Image)
            if img9WinBg then
                img9WinBg:setVisible(true)
            end
        end
        --第季军赛
        if tData[i].guildResult == 5 or tData[i].guildResult == 7 or tData[i].guildResult == 8 then
            local nThirdIndex = math.ceil(i/2)
            local txtGroupName = GetElement(self.m_root, "txtGroupName3_" .. nThirdIndex .. "_CellGuildWarFinal", WZUILabelTTF)
            if txtGroupName then
                txtGroupName:setColor(GlobalMethod:ccc3(233,166,62))
                txtGroupName:setText(sGroupMark .. tData[i].guildGroupNo)
            end
            if tData[i].guildResult == 8 then
                txtGroupName:setColor(GlobalMethod:ccc3(255,227,116))
                local img9WinBg = GetElement(self.m_root, "img9WinBg3_" .. nThirdIndex .. "_CellGuildWarFinal", WZUI9Image)
                if img9WinBg then
                    img9WinBg:setVisible(true)
                end
                --季军
                local txtGroupName = GetElement(self.m_root, "txtGroupName3_3_CellGuildWarFinal", WZUILabelTTF)
                if txtGroupName then
                    txtGroupName:setColor(GlobalMethod:ccc3(255,227,116))
                    txtGroupName:setText(sGroupMark .. tData[i].guildGroupNo)
                end
                GetElement(self.m_root, "img9WinBg3_3_CellGuildWarFinal", WZUI9Image):setVisible(true) 
                --亮的线
                local imgLine = GetElement(self.m_root, "imgLine3_" .. nThirdIndex .. "_CellGuildWarFinal", WZUIImage)
                if imgLine then
                    imgLine:setFile("ui/community/common_pic_xiank1_sel.png")
                    imgLine:setZOrder(tData[i].guildResult)
                end
            end
        end
        --冠军
        if tData[i].guildResult == 10 then
            local ftxtFirstName = GetElement(self.m_root, "ftxtFirstName_CellGuildWarFinal", WZUIFreeTextBox)
            if ftxtFirstName then
                ftxtFirstName:setShowText(string.format(sNameFormat, sGroupMark, tData[i].guildGroupNo, tData[i].guildName))
            end
        --亚军
        elseif tData[i].guildResult == 9 then
            local ftxtSecondName = GetElement(self.m_root, "ftxtSecondName_CellGuildWarFinal", WZUIFreeTextBox)
            if ftxtSecondName then
                ftxtSecondName:setShowText(string.format(sNameFormat, sGroupMark, tData[i].guildGroupNo, tData[i].guildName))
            end
        --季军
        elseif tData[i].guildResult == 8 then
            local ftxtThirdName = GetElement(self.m_root, "ftxtThirdName_CellGuildWarFinal", WZUIFreeTextBox)
            if ftxtThirdName then
                ftxtThirdName:setShowText(string.format(sNameFormat, sGroupMark, tData[i].guildGroupNo, tData[i].guildName))
            end
        end
    end
end

--@brief    设置默认文字
function CellGuildWarFinal:_setStaticText()
    -- body
    local sNameFormat = [[<T C="127,70,26" S="18" P="1">%s</T>]]
    for i = 1, 4 do 
        local ftxtGuildName = GetElement(self.m_root, "ftxtGuildName1_" .. i .. "_CellGuildWarFinal", WZUIFreeTextBox)
        if ftxtGuildName then
            ftxtGuildName:setShowText(string.format(sNameFormat,LocalStrings.COMMUNITY_COMPETE_TEXT15))
        end
    end
    for i = 1, 2 do 
        local txtGroupName = GetElement(self.m_root, "txtGroupName2_" .. i .. "_CellGuildWarFinal", WZUILabelTTF)
        if txtGroupName then
            txtGroupName:setColor(GlobalMethod:ccc3(127,70,26))
            txtGroupName:setText(LocalStrings.COMMUNITY_COMPETE_TEXT15)
            if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "tr" then
                txtGroupName:setScale(0.5)
                txtGroupName:setDimensions(GlobalMethod:CCSize(100))
            elseif ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" then
                txtGroupName:setScale(0.5)
                txtGroupName:setDimensions(GlobalMethod:CCSize(100))
            elseif ProjConfig.LANGUAGE == "vn" then
                txtGroupName:setFontSize(13)
                txtGroupName:setDimensions(GlobalMethod:CCSize(60,0))
            end
        end
    end
    for i = 1, 3 do 
        local txtGroupName = GetElement(self.m_root, "txtGroupName3_" .. i .. "_CellGuildWarFinal", WZUILabelTTF)
        if txtGroupName then
            txtGroupName:setColor(GlobalMethod:ccc3(127,70,26))
            txtGroupName:setText(LocalStrings.COMMUNITY_COMPETE_TEXT15)
            if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "tr" then
                txtGroupName:setScale(0.5)
                txtGroupName:setDimensions(GlobalMethod:CCSize(100))
            elseif ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" then
                txtGroupName:setScale(0.5)
                txtGroupName:setDimensions(GlobalMethod:CCSize(100))
            elseif ProjConfig.LANGUAGE == "vn" then
                txtGroupName:setFontSize(13)
                txtGroupName:setDimensions(GlobalMethod:CCSize(60,0))
            end
        end
    end

    local ftxtGuildName = GetElement(self.m_root, "ftxtGuildName4_1_CellGuildWarFinal", WZUIFreeTextBox)
    if ftxtGuildName then
        ftxtGuildName:setShowText(string.format(sNameFormat, LocalStrings.COMMUNITY_COMPETE_TEXT15))
    end

    local ftxtFirstName = GetElement(self.m_root, "ftxtFirstName_CellGuildWarFinal", WZUIFreeTextBox)
    if ftxtFirstName then
        ftxtFirstName:setShowText(string.format(sNameFormat, LocalStrings.COMMUNITY_COMPETE_TEXT15))
    end

    local ftxtSecondName = GetElement(self.m_root, "ftxtSecondName_CellGuildWarFinal", WZUIFreeTextBox)
    if ftxtSecondName then
        ftxtSecondName:setShowText(string.format(sNameFormat, LocalStrings.COMMUNITY_COMPETE_TEXT15))
    end

    local ftxtThirdName = GetElement(self.m_root, "ftxtThirdName_CellGuildWarFinal", WZUIFreeTextBox)
    if ftxtThirdName then
        ftxtThirdName:setShowText(string.format(sNameFormat, LocalStrings.COMMUNITY_COMPETE_TEXT15))
    end
end




-------------------------------------私有方法模块End----------------------------------------

------------------------------------语言适配Begin---------------------------------------
function CellGuildWarFinal:_adaptLanguage_en(  )
    local txtGrouThird = GetElement(self.m_root,"txtGrouThird_CellGuildWarFinal",WZUILabelTTF)
    txtGrouThird:setDimensions(GlobalMethod:CCSize(70,0))
    txtGrouThird:setFontSize(16)
end

function CellGuildWarFinal:_adaptLanguage_th(  )
    local txtGrouThird = GetElement(self.m_root,"txtGrouThird_CellGuildWarFinal",WZUILabelTTF)
    txtGrouThird:setFontSize(14)
    local txtChamp = GetElement(self.m_root,"txtGroupChampion_CellGuildWarFinal",WZUILabelTTF)
    txtChamp:setFontSize(14)
end

function CellGuildWarFinal:_adaptLanguage_vn(  )
    local txtGrouThird = GetElement(self.m_root,"txtGrouThird_CellGuildWarFinal",WZUILabelTTF)
    txtGrouThird:setFontSize(14)
    local txtChamp = GetElement(self.m_root,"txtGroupChampion_CellGuildWarFinal",WZUILabelTTF)
    txtChamp:setFontSize(14)
end

function CellGuildWarFinal:_adaptLanguage_pt(  )
    local txtGrouThird = GetElement(self.m_root,"txtGrouThird_CellGuildWarFinal",WZUILabelTTF)
    txtGrouThird:setDimensions(GlobalMethod:CCSize(120,0))
    txtGrouThird:setScale(0.6)
end

function CellGuildWarFinal:_adaptLanguage_es(  )
    local txtGrouThird = GetElement(self.m_root,"txtGrouThird_CellGuildWarFinal",WZUILabelTTF)
    txtGrouThird:setFontSize(12)
    txtGrouThird:setDimensions(GlobalMethod:CCSize(80,0))
    
    local txtChamp = GetElement(self.m_root,"txtGroupChampion_CellGuildWarFinal",WZUILabelTTF)
    txtChamp:setFontSize(14)
    txtChamp:setDimensions(GlobalMethod:CCSize(100,0))
end

function CellGuildWarFinal:_adaptLanguage_tr(  )
    local txtGrouThird = GetElement(self.m_root,"txtGrouThird_CellGuildWarFinal",WZUILabelTTF)
    txtGrouThird:setDimensions(GlobalMethod:CCSize(90,0))
    txtGrouThird:setScale(0.8)
end
------------------------------------语言适配End-----------------------------------------