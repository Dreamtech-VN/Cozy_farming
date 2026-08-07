--CellRankSeat.lua
--@brief	CellRankSeat的UI模块
--@date		2015/09/17
--@author	Tianxiang_Xu
--@note		排行榜人物格子


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellRankSeat:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellRankSeat:onExit(element)
	self:_unInit()
end

--@brief    设置格子数据显示
--@param    nType:1战力榜，2等级榜，3宠物榜, 11战绩榜，13成就榜，22师德榜，23恩爱榜, 98积分榜, 99竞技之王,
--@param    bBool 判断玩家形象是否setFlipX
--@param    ccpAnchor 角色锚点
function CellRankSeat:setRankSeat(tData, nType, bBool, ccpAnchor)
    -- WZLog("CellMasterSeat:setMasterSeat",nType,Serialize(tData))
    if tData == nil then return end
    self.m_tData = tData
    nType = nType or 1
    self.m_nType = nType
    --人物信息
    local conInfo = GetElement(self.m_root, "conInfo_CellRankSeat", WZUIContainer)
    conInfo:setVisible(true)

    --调试用数据
    local level = tData.level
    local fighting = tData.fighting

    GetElement(self.m_root,"playerName",WZUILabelTTF):setText("Lv" .. tostring(level) .. " " .. tData.name)
    local atlasFightLabel = GetElement(self.m_root,"playerFight",WZUILabelAtlasFont)
    atlasFightLabel:setText(fighting)

    --人物形象
    if nType == 3 or nType == 98 or nType == 99 then
        self:_setPlayer(tData, bBool, true)
    else
        self:_setPlayer(tData, bBool, nil, ccpAnchor)
    end

    local imgMedal2 = GetElement(self.m_root, "imgMedal2_CellRankSeat", WZUIImage)
    local txtLabelValue = GetElement(self.m_root, "txtLabelValue_CellRankSeat", WZUILabelTTF)
    txtLabelValue:setText(fighting)

    --被膜拜的次数
    local sBeworshipTimes = string.format(LocalStrings.BEWORSHIP_TIMES, tData.worshipNum)
    if nType ~= 23 or (nType == 23 and tData.sex == 0) then
        GetElement(self.m_root, "txtBeWorshipTimes_CellRankSeat", WZUIFreeTextBox):setShowText(sBeworshipTimes)
    end
    --红点
    if nType ~= 98 and nType ~= 99 then 
        self.m_nCanWorship = self:getWorshipRight()
        if self.m_nCanWorship == 0 or self.m_nCanWorship == nil then
            GetElement(self.m_root, "imgRedDot_CellRankSeat", WZUIImage):setVisible(false)
        else
            GetElement(self.m_root, "imgRedDot_CellRankSeat", WZUIImage):setVisible(true)
        end
    end

    if nType == 23 then
        local txtTitle = GetElement(self.m_root, "playerTitle", WZUILabelTTF)
        local txtName = GetElement(self.m_root, "playerName", WZUILabelTTF)
        local imgHWWord = GetElement(self.m_root, "imgWifeHasband_CellRankSeat", WZUIImage)
        atlasFightLabel:setVisible(false)
        --设置两个标签左对齐
        txtTitle:setVisible(false)
        txtName:setText(tData.name)
        txtName:setFontSize(20)
        imgHWWord:setVisible(true)
        --排名
        imgMedal2:setRelativePosition(GlobalMethod:ccp(0.01,0.06))
        --恩爱值
        local txtProperty = GetElement(self.m_root, "txtShowProperty_CellRankList", WZUILabelTTF)
        txtProperty:setRelativePosition(GlobalMethod:ccp(0.56,0.5))
        txtProperty:setText(LocalStrings.COUPLE_LOVE..":")
        --恩爱等级和图标
        local parentNode = GetElement(self.m_root, "conFight", WZUIContainer)
        self:_createLoveIcon(parentNode, "ui/common/common_icon_enai1.png", tostring(tData.valueLv), "ui/common_num/common_num_yxtbsz.png", GlobalMethod:ccp(0.5,0.5))

        txtLabelValue:setVisible(true)
        txtLabelValue:setRelativePosition(GlobalMethod:ccp(0.56, 0.5))
        txtLabelValue:setStrokeColor(GlobalMethod:ccc3(255,89,74))

        GetElement(self.m_root, "txtCheck1", WZUILabelTTF):setText(LocalStrings.CHECK_WIFE)
        GetElement(self.m_root, "txtCheck2", WZUILabelTTF):setText(LocalStrings.CHECK_HUSBAND)
    --    GetElement(self.m_root, "btnWorship", WZUIButton):setVisible(false)
        GetElement(self.m_root, "txtWorship", WZUILabelTTF):setText(LocalStrings.WORSHIP_WORD)
        --恩爱值框上方的心
        GetElement(self.m_root, "imgHeart_CellRankSeat", WZUIImage):setVisible(true)
        --恩爱值框
        GetElement(self.m_root, "imgValueBk_CellRankSeat", WZUI9Image):setFile("ui/common/common_scale9_di41.png")
        --
        if tData.sex == 0 then
            imgHWWord:setFile("ui/common/common_icon_lgz.png")
        elseif tData.sex == 1 then
            imgHWWord:setFile("ui/common/common_icon_lpz.png")
        end

        if ProjConfig.LANGUAGE == "en" then
            GetElement(self.m_root,"txtCheck1",WZUILabelTTF):setFontSize(20)
            GetElement(self.m_root,"txtCheck2",WZUILabelTTF):setFontSize(15)
            txtProperty:setFontSize(18)
            txtProperty:setRelativePosition(GlobalMethod:ccp(0.625,0.5))
            txtLabelValue:setRelativePosition(GlobalMethod:ccp(0.635,0.5))
        end
        if ProjConfig.LANGUAGE == "pt" then
            GetElement(self.m_root,"txtCheck1",WZUILabelTTF):setFontSize(17)
            GetElement(self.m_root,"txtCheck2",WZUILabelTTF):setFontSize(15)
            local txtProperty = GetElement(self.m_root, "txtShowProperty_CellRankList", WZUILabelTTF)
            txtProperty:setRelativePosition(GlobalMethod:ccp(0.625,0.5))
            txtLabelValue:setRelativePosition(GlobalMethod:ccp(0.635,0.5))
        end
        if ProjConfig.LANGUAGE == "tr" then
            local txtProperty = GetElement(self.m_root, "txtShowProperty_CellRankList", WZUILabelTTF)
            txtProperty:setRelativePosition(GlobalMethod:ccp(0.625,0.5))
            txtLabelValue:setRelativePosition(GlobalMethod:ccp(0.635,0.5))
            local txtCheck1 = GetElement(self.m_root,"txtCheck1",WZUILabelTTF)
            txtCheck1:setFontSize(18)
            txtCheck1:setDimensions(GlobalMethod:CCSize(100,0))
            local txtCheck2 = GetElement(self.m_root,"txtCheck2",WZUILabelTTF)
            txtCheck2:setFontSize(18)
            txtCheck2:setDimensions(GlobalMethod:CCSize(100,0))
        end
        if ProjConfig.LANGUAGE == "es" then
            local txtCheck1 = GetElement(self.m_root,"txtCheck1",WZUILabelTTF)
            txtCheck1:setFontSize(18)
            txtCheck1:setDimensions(GlobalMethod:CCSize(110,0))
            local txtCheck2 = GetElement(self.m_root,"txtCheck2",WZUILabelTTF)
            txtCheck2:setFontSize(18)
            txtCheck2:setDimensions(GlobalMethod:CCSize(110,0))
        end
        GetElement(self.m_root, "imgFightIcon_CellRankList", WZUIImage):setVisible(false)
        GetElement(self.m_root, "playerLevel", WZUILabelTTF):setVisible(false)
    else
        local sTitleString
        local sTempTitle 
        local bTitleStroke = false
        local playerTitle = GetElement(self.m_root,"playerTitle",WZUILabelTTF)
        local tempPoint = GlobalMethod:ccp(0.5,1.09)

        if tData.title ~= nil and tData.title ~= "" then
            local sTitleName = SplitStringWithSeparator(tData.title,"&")
            local sNewTitle, nLetterNum = string.gsub(tData.title, "&", ",")
            if sTitleName[2] ~= nil and sTitleName[2] ~= "" then
                if tonumber(sTitleName[2]) == nil or nLetterNum > 2 then
                    sTitleString = "<"..tData.title..">"
                else
                    local bExist = WZFileUtil:isFileExist(string.format(g_sTitleSpineName, sTitleName[2]) .. ".json")
                    if bExist then
                        bTitleStroke = true
                        sTitleString = tData.title
                        sTempTitle = sTitleName[1]
                    else
                        sTitleString = "<"..tData.title..">"
                    end
                end
            else
                sTitleString = "<"..tData.title..">"
            end
        else
            sTitleString = LocalStrings.SHOP_NOCHENGHAO
        end
        CreateDesiSpine(conInfo, playerTitle, sTitleString, tempPoint, bTitleStroke)
        if nType ~= 12 and nType ~= 22 then 
            self:_createName(conInfo, "Lv" .. tostring(level) .. " ", tData.name, qqHallData)
        end

        GetElement(self.m_root, "txtCheck1", WZUILabelTTF):setText(LocalStrings.PETLOOK)
        GetElement(self.m_root, "txtWorship", WZUILabelTTF):setText(LocalStrings.WORSHIP_WORD)
        local imgFightIcon = GetElement(self.m_root, "imgFightIcon_CellRankList", WZUIImage)
        imgFightIcon:setVisible(true)
        GetElement(self.m_root, "btnWorship", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.5, 0.38))
--        GetElement(self.m_root, "playerLevel", WZUILabelTTF):setText(string.format("lv.%d", level))

        GetElement(self.m_root, "btnCheckHusband", WZUIButton):setVisible(false)
        local txtShowProperty = GetElement(self.m_root, "txtShowProperty_CellRankList", WZUILabelTTF)
        txtShowProperty:setVisible(false)
        local txtFamousIconLv = GetElement(self.m_root, "txtFamousIconLv_CellRankSeat", WZUILabelAtlasFont)
        local imgIconLv = GetElement(self.m_root, "imgIconLv_CellRankSeat", WZUIImage)

        if nType == 1 or nType == 59 then --战力榜(1本服战力榜 59全服战力榜)
            atlasFightLabel:setVisible(true)
            imgMedal2:setRelativePosition(GlobalMethod:ccp(0.15, 0.06))
            if ProjConfig.LANGUAGE == "tr" then
                GetElement(self.m_root,"playerTitle",WZUILabelTTF):setFontSize(18)
            end
        elseif nType == 2 then --等级榜
            atlasFightLabel:setVisible(true)
            imgMedal2:setRelativePosition(GlobalMethod:ccp(0.15, 0.06))
        elseif nType == 3 or nType == 60 then --宠物榜(3本服 60全服)
            if ProjConfig.LANGUAGE == "tr" then
                GetElement(self.m_root,"playerTitle",WZUILabelTTF):setFontSize(18)
            end
            if bBool then
                GetElement(self.m_root, "btnPetInfoRight_CellRankSeat", WZUIButton):setTouchEnable(true)
            else
                GetElement(self.m_root, "btnPetInfoLeft_CellRankSeat", WZUIButton):setTouchEnable(true)
            end
            atlasFightLabel:setVisible(true)
            imgFightIcon:setFile("ui/common/common_icon_cwzli.png")
            imgFightIcon:setRelativePosition(GlobalMethod:ccp(0.5, 0.5))
        elseif nType == 12 then     --竞技榜
        --    GetElement(self.m_root, "spineDesi_CellRankSeat", WZUISpine):setRelativePosition(GlobalMethod:ccp(0.55,1.1))
            --名次
            imgMedal2:setRelativePosition(GlobalMethod:ccp(0.01, 0.06))
            --战力图标
            imgFightIcon:setVisible(false)
            --竞技图标
        --    imgIconLv:setFile("ui/common/common_icon_hz1.png")
        --    imgIconLv:setVisible(true)
        --    imgFightIcon:setRelativePosition(GlobalMethod:ccp(0.7, 0.45))
            --竞技等级
            local tCurLevelTable = self:_getIntegralName(tData.valueLv)
            
            local sIconFilePath = "ui/common/" .. tCurLevelTable.iocn .. ".png"
            local nPartLevel = tCurLevelTable.iocn_level
            self:_createNameTitle(conInfo, sTempTitle or sTitleString, "Lv" .. tostring(level) .. " ", tData.name, sIconFilePath, tostring(nPartLevel), "ui/common_num/common_num_yxtbsz.png", GlobalMethod:ccp(0.5, 0.47), bTitleStroke, qqHallData)
--            txtFamousIconLv:setVisible(true)
--            txtFamousIconLv:setText(tostring(tData.valueLv))
--            txtFamousIconLv:setRelativePosition(ccp(-0.1, 0.5))
            --显示的值
--            atlasFightLabel:setRelativePosition(GlobalMethod:ccp(0.65, 0.5))
            --积分
            txtShowProperty:setColor(GlobalMethod:ccc3(255,227,116))
            txtShowProperty:setStrokeColor(GlobalMethod:ccc3(132,66,29))
            txtShowProperty:setVisible(true)
            txtShowProperty:setText(LocalStrings.INTEGRATION .. ":")
--            txtShowProperty:setRelativePosition(GlobalMethod:ccp(0.64, 0.5))
            --积分值
            txtLabelValue:setVisible(true)
            if ProjConfig.LANGUAGE == "pt" then
                txtShowProperty:setRelativePosition(GlobalMethod:ccp(0.6, 0.5))
                txtShowProperty:setFontSize(18)
                txtLabelValue:setRelativePosition(GlobalMethod:ccp(0.6, 0.5))
                txtLabelValue:setFontSize(18)
            end
        elseif nType == 13 then     --成就榜
            --名次
            imgMedal2:setRelativePosition(GlobalMethod:ccp(0.01, 0.06))
            imgFightIcon:setVisible(false)
            txtShowProperty:setVisible(true)
            --显示的数值
            txtLabelValue:setVisible(true)
            txtLabelValue:setRelativePosition(GlobalMethod:ccp(0.63, 0.5))
--            atlasFightLabel:setRelativePosition(GlobalMethod:ccp(0.65, 0.5))
            --成就数量
            txtShowProperty:setColor(GlobalMethod:ccc3(255,227,116))
            txtShowProperty:setStrokeColor(GlobalMethod:ccc3(132,66,29))
            txtShowProperty:setText(LocalStrings.ACHIE_NUMBER .. ":")
            txtShowProperty:setRelativePosition(GlobalMethod:ccp(0.63, 0.5))
            if ProjConfig.LANGUAGE == "en" then
                txtShowProperty:setRelativePosition(GlobalMethod:ccp(0.65, 0.5))
                txtShowProperty:setFontSize(18)
                txtLabelValue:setRelativePosition(GlobalMethod:ccp(0.65, 0.5))
                txtLabelValue:setFontSize(18)
            end
            if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "vn" then
                txtShowProperty:setRelativePosition(GlobalMethod:ccp(0.6, 0.5))
                txtShowProperty:setFontSize(18)
                txtLabelValue:setRelativePosition(GlobalMethod:ccp(0.6, 0.5))
                txtLabelValue:setFontSize(18)
            end
            if ProjConfig.LANGUAGE == "tr" then
                GetElement(self.m_root,"playerTitle",WZUILabelTTF):setFontSize(18)
            end
        elseif nType == 22 then     --师德榜
        --    GetElement(self.m_root, "spineDesi_CellRankSeat", WZUISpine):setRelativePosition(GlobalMethod:ccp(0.55,1.1))
            --名次
            imgMedal2:setRelativePosition(GlobalMethod:ccp(0.07, 0.06))
            --战力图标
            imgFightIcon:setVisible(false)
            --师德图标
            self:_createNameTitle(conInfo, sTempTitle or sTitleString, "Lv" .. tostring(level) .. " ", tData.name, "ui/bag/bag_icon_shitu.png", tostring(tData.valueLv), "ui/common_num/common_num_yxtbsz.png", GlobalMethod:ccp(0.5, 0.5), bTitleStroke, qqHallData)
        --    imgIconLv:setFile("ui/common/common_icon_shidei.png")
        --    imgIconLv:setVisible(true)
--            imgFightIcon:setRelativePosition(GlobalMethod:ccp(0.7, 0.45))
            --显示的值
            txtLabelValue:setVisible(true)
            txtLabelValue:setRelativePosition(GlobalMethod:ccp(0.6, 0.5))
--            atlasFightLabel:setRelativePosition(GlobalMethod:ccp(0.74, 0.5))
            --师德等级
--            txtFamousIconLv:setVisible(true)
--            txtFamousIconLv:setText(tostring(tData.valueLv))
--            txtFamousIconLv:setRelativePosition(ccp(-0.1, 0.5))
            --师德值
            txtShowProperty:setVisible(true)
            txtShowProperty:setColor(GlobalMethod:ccc3(255,227,116))
            txtShowProperty:setStrokeColor(GlobalMethod:ccc3(132,66,29))
            txtShowProperty:setText(LocalStrings.TEACHER_VALUE .. ":")
            txtShowProperty:setRelativePosition(GlobalMethod:ccp(0.6, 0.5))
            if ProjConfig.LANGUAGE == "pt" then
                --txtShowProperty:setRelativePosition(GlobalMethod:ccp(0.65, 0.5))
                txtShowProperty:setFontSize(14)
                --txtLabelValue:setRelativePosition(GlobalMethod:ccp(0.65, 0.5))
                --txtLabelValue:setFontSize(18)
            end
        elseif nType == 98 then
            atlasFightLabel:setVisible(true)
            imgMedal2:setRelativePosition(GlobalMethod:ccp(0.15, 0.06))
            if bBool then
                GetElement(self.m_root, "btnPetInfoRight_CellRankSeat", WZUIButton):setTouchEnable(true)
            else
                GetElement(self.m_root, "btnPetInfoLeft_CellRankSeat", WZUIButton):setTouchEnable(true)
            end
        elseif nType == 99 then 
            atlasFightLabel:setVisible(true)
            imgMedal2:setRelativePosition(GlobalMethod:ccp(0.15, 0.06))
            if self.m_tData.id == CacheCenter:getPlayerInfo().id then 
                GetElement(self.m_root, "txtWorship", WZUILabelTTF):setTextKey("ACTIVE_BTN_GET")
            end
            if bBool then
                GetElement(self.m_root, "btnPetInfoRight_CellRankSeat", WZUIButton):setTouchEnable(true)
            else
                GetElement(self.m_root, "btnPetInfoLeft_CellRankSeat", WZUIButton):setTouchEnable(true)
            end
        elseif nType == 56 then
            imgMedal2:setRelativePosition(GlobalMethod:ccp(0.01, 0.06))
            --战力图标
            imgFightIcon:setVisible(false)
            --竞技图标
        --    imgIconLv:setFile("ui/common/common_icon_hz1.png")
        --    imgIconLv:setVisible(true)
        --    imgFightIcon:setRelativePosition(GlobalMethod:ccp(0.7, 0.45))
            local medolPoint = tData.fighting
            local lv = 1
            WZLog("名人榜勋章积分",tonumber(GDatatab_vip_medal_level["id_"..2].point),tonumber(medolPoint))
            for i = 1,30 do
                if tonumber(GDatatab_vip_medal_level["id_"..i].point) > tonumber(medolPoint) then
                    lv = GDatatab_vip_medal_level["id_"..i].level 
                    break
                elseif tonumber(GDatatab_vip_medal_level["id_"..i].point) == tonumber(medolPoint) then
                    lv = GDatatab_vip_medal_level["id_"..i].level + 1
                    break
                elseif tonumber(GDatatab_vip_medal_level["id_"..i].point) < tonumber(medolPoint) then
                    lv = GDatatab_vip_medal_level["id_"..i].level
                end
            end
            local icon = GDatatab_vip_medal_level["id_"..lv].icon
            imgIconLv:setFile(icon)
            imgIconLv:setScale(0.5)
            imgIconLv:setRelativePosition(GlobalMethod:ccp(-0.15,0.95))
           imgIconLv:setVisible(true)
           imgFightIcon:setRelativePosition(GlobalMethod:ccp(0.7, 0.45))
            txtLabelValue:setText(medolPoint)
            GetElement(self.m_root,"medolPoint",WZUILabelTTF):setVisible(true)
            GetElement(self.m_root,"medolPoint",WZUILabelTTF):setText(lv)
            txtLabelValue:setRelativePosition(GlobalMethod:ccp(0.66,0.5))
            -- WZLog("名人榜勋章积分",medolPoint)
            --竞技等级
            -- local tCurLevelTable = self:_getIntegralName(tData.valueLv)
            
            -- local sIconFilePath = "ui/common/" .. tCurLevelTable.iocn .. ".png"
            -- local nPartLevel = tCurLevelTable.iocn_level
            -- self:_createNameTitle(conInfo, sTempTitle or sTitleString, "Lv" .. tostring(level) .. " ", tData.name, sIconFilePath, tostring(nPartLevel), "ui/common_num/common_num_yxtbsz.png", GlobalMethod:ccp(0.5, 0.47), bTitleStroke, qqHallData)
--            txtFamousIconLv:setVisible(true)
--            txtFamousIconLv:setText(tostring(tData.valueLv))
--            txtFamousIconLv:setRelativePosition(ccp(-0.1, 0.5))
            --显示的值
--            atlasFightLabel:setRelativePosition(GlobalMethod:ccp(0.65, 0.5))
            --积分
            txtShowProperty:setColor(GlobalMethod:ccc3(255,227,116))
            txtShowProperty:setStrokeColor(GlobalMethod:ccc3(132,66,29))
            txtShowProperty:setVisible(true)
            txtShowProperty:setText(LocalStrings.NEWVIP_TEXT18)
            txtShowProperty:setRelativePosition(GlobalMethod:ccp(0.65,0.5))
--            txtShowProperty:setRelativePosition(GlobalMethod:ccp(0.64, 0.5))
            --积分值
            txtLabelValue:setVisible(true)            
        end
    end

    local isEndTeach, finishStep = TeachGroup1:isTeachFinish(16)
    WZLog("CellRankSeat:setRankSeat two", isEndTeach, finishStep)
    if isEndTeach ~= true and TeachGroup1:isTeach() and CacheCenter:getPlayerInfo().level == 10 then
        WindowManager:removeTeachShelterLayer()
        TeachGroup1:startGroup({16,2,WndRankList.m_root})
    else
        WindowManager:removeTeachShelterLayer()
    end
end

--@brief    根据当前等级返回相应的数据表数据
--@param    level 当前竞技等级
function CellRankSeat:_getIntegralName(level)
    return WndRankList:_getIntegralName(level)
end

--@brief    恩爱榜等级图标
--@param    parentNode 父节点
--@param    sIconFile 图标文件
--@param    sLvNum 图标等级
--@param    sAtlasFileName 显示图标等级用到的数字图片
--@param    ccpAtlas 等级的相对坐标
function CellRankSeat:_createLoveIcon(parentNode, sIconFile, sLvNum, sAtlasFileName, ccpAtlas)
    -- body
    local imgIcon = WZUIImage:create()
    imgIcon:setFile(sIconFile)
    imgIcon:setUseOriginSize(true)
    imgIcon:setAnchorPoint(GlobalMethod:ccp(0.5, 0.3))
    imgIcon:setRelativePosition(GlobalMethod:ccp(0.5, 1))

    local atlasLevel = WZUILabelAtlasFont:create()
    atlasLevel:setAnchorPoint(GlobalMethod:ccp(0.5, 0.5))
    atlasLevel:setRelativePosition(ccpAtlas)
    atlasLevel:setCharMapFileName(sAtlasFileName)    --ui/common/common_num_ghdj.png
    atlasLevel:setHeight(22)
    atlasLevel:setWidth(16)
    atlasLevel:setUseOriginSize(true)
    atlasLevel:setStartChar(48)
    atlasLevel:setText(sLvNum)

    imgIcon:addChild(atlasLevel, 10, 10)
    if self.m_nType == 23 then
        imgIcon:setScale(0.5)
        atlasLevel:setVisible(false)
    end

    parentNode:addChild(imgIcon)
end

--@brief    创建师德榜、竞技榜中角色的名字，称号，等级图标
--@param    parentNode 父节点
--@param    sTitle 称号
--@param    sName 名字
--@param    sIconFile 图标文件
--@param    sLvNum 图标等级
--@param    sAtlasFileName 显示图标等级用到的数字图片
--@param    ccpAtlas 等级的想多坐标
--@param    bTitleStroke: 称号是否加描边
function CellRankSeat:_createNameTitle(parentNode, sTitle, strLv, sName, sIconFile, sLvNum, sAtlasFileName, ccpAtlas, bTitleStroke, qqHallData)
    GetElement(self.m_root,"playerName",WZUILabelTTF):setVisible(false)
    GetElement(self.m_root,"playerTitle",WZUILabelTTF):setVisible(false)
    -- body
    local imgIcon = WZUIImage:create()
    imgIcon:setFile(sIconFile)
    imgIcon:setUseOriginSize(true)
    imgIcon:setAnchorPoint(GlobalMethod:ccp(1, 0.5))
    imgIcon:setRelativePosition(GlobalMethod:ccp(0.05, 0))

    local atlasLevel = WZUILabelAtlasFont:create()
    atlasLevel:setAnchorPoint(GlobalMethod:ccp(0.5, 0.5))
    atlasLevel:setRelativePosition(ccpAtlas)
    atlasLevel:setCharMapFileName(sAtlasFileName)    --ui/common/common_num_ghdj.png
    atlasLevel:setHeight(22)
    atlasLevel:setWidth(16)
    atlasLevel:setUseOriginSize(true)
    atlasLevel:setStartChar(48)
    atlasLevel:setText(sLvNum)

    imgIcon:addChild(atlasLevel, 10, 10)
    if self.m_nType == 12 then
        atlasLevel:setVisible(false)
    elseif self.m_nType == 22 then
        imgIcon:setScale(0.5)
        atlasLevel:setVisible(false)
    end

    local txtTitle = WZUILabelTTF:create()
    txtTitle:setText(sTitle)
    txtTitle:setFontSize(22)
    txtTitle:setColor(GlobalMethod:ccc3(255,121,31))
    txtTitle:setAnchorPoint(GlobalMethod:ccp(0.5, 0))
    txtTitle:setUseOriginSize(true)
    txtTitle:setMaxLength(7)
    if bTitleStroke then
        txtTitle:setEnableStroke(true)
        txtTitle:setStrokeColor(GlobalMethod:ccc3(79,60,48))
        txtTitle:setStrokeSize(4)
    end
    
    local conTemp = WZUIContainer:create()
    conTemp:setAbsContentSize(GlobalMethod:CCSize(100, 50))
    conTemp:setAnchorPoint(GlobalMethod:ccp(0.5, 1))
    conTemp:setRelativePosition(GlobalMethod:ccp(0.55, 1))
    conTemp:setUseAbsSize(true)
    parentNode:addChild(conTemp)

    local conName = WZUIContainer:create()
    conName:setAnchorPoint(GlobalMethod:ccp(0.5, 1))
    conName:setRelativePosition(GlobalMethod:ccp(0.5, 0.35))
    conName:setUseAbsSize(true)
    conTemp:addChild(conName)
    --玩家等级
    local nTempWidth = 0 
    local txtLv = WZUILabelTTF:create()
    txtLv:setText(strLv)
    txtLv:setFontSize(20)
    txtLv:setColor(GlobalMethod:ccc3(255,255,255))
    txtLv:setStrokeColor(GlobalMethod:ccc3(132,66,29))
    txtLv:setEnableStroke(true)
    txtLv:setStrokeSize(4)
    txtLv:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
    txtLv:setUseAbsCoordinate(true)
    txtLv:setAbsPosition(GlobalMethod:ccp(nTempWidth, 15))
    txtLv:setUseOriginSize(true)
    conName:addChild(txtLv)
    local tempLvSize = txtLv:getContentSize()
    nTempWidth = nTempWidth + tempLvSize.width

    local bShowQQInfo = true 
    if ProjConfig:getChannelId() ~= 1118 then 
        bShowQQInfo = false 
    end 
    if qqHallData and bShowQQInfo then 
        if qqHallData.is_blue_vip or qqHallData.is_super_blue_vip then 
            local imgIconBlue = WZUIImage:create()
            imgIconBlue:setUseOriginSize(true)
            imgIconBlue:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
            imgIconBlue:setUseAbsCoordinate(true)
            imgIconBlue:setAbsPosition(GlobalMethod:ccp(nTempWidth, 15))
            local iconPath = ""
            if qqHallData.is_super_blue_vip then 
                iconPath = "ui/qqHall/hh_" .. qqHallData.blue_vip_level .. ".png"
            else
                iconPath = "ui/qqHall/pz_" .. qqHallData.blue_vip_level .. ".png"
            end
            imgIconBlue:setFile(iconPath)
            imgIconBlue:setScale(0.6)
            conName:addChild(imgIconBlue)
            nTempWidth = nTempWidth + 25

            if qqHallData.is_blue_year_vip then 
                local iconYearPath = "ui/qqHall/nian.png"
                local imgIconYear = WZUIImage:create()
                imgIconYear:setUseOriginSize(true)
                imgIconYear:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
                imgIconYear:setUseAbsCoordinate(true)
                imgIconYear:setAbsPosition(GlobalMethod:ccp(nTempWidth, 15))
                imgIconYear:setFile(iconYearPath)
                imgIconYear:setScale(0.6)
                conName:addChild(imgIconYear)
                nTempWidth = nTempWidth + 25
            end
        end
    end
    --玩家名字
    local txtName = WZUILabelTTF:create()
    txtName:setText(sName)
    txtName:setFontSize(20)
    txtName:setColor(GlobalMethod:ccc3(255,255,255))
    txtName:setStrokeColor(GlobalMethod:ccc3(132,66,29))
    txtName:setEnableStroke(true)
    txtName:setStrokeSize(4)
    txtName:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
    txtName:setUseAbsCoordinate(true)
    txtName:setAbsPosition(GlobalMethod:ccp(nTempWidth, 15))
    txtName:setUseOriginSize(true)
    conName:addChild(txtName)
    local tempNameSize = txtName:getContentSize()
    nTempWidth = nTempWidth + tempNameSize.width

    conName:setAbsContentSize(GlobalMethod:CCSize(nTempWidth, 30))
    conName:updateRelativeSize()

    if txtTitle then
        conTemp:addChild(txtTitle)
    end

    if imgIcon then
        if string.len(sName) >= string.len(sTitle) then
            imgIcon:setRelativePosition(GlobalMethod:ccp(0.05, 1))
            conName:addChild(imgIcon)
        else
            txtTitle:addChild(imgIcon)
        end
    end

end

--@brief    设置奖章类型：金、银、铜
--@param    名次：1,2,3
--@param    排行榜类型
function CellRankSeat:setMedalType(nRankIndex, nType)
    -- body
    local imgMedal
    if nType == 3 then 
        imgMedal = GetElement(self.m_root, "imgMedal_CellRankSeat", WZUIImage)
    else
        imgMedal = GetElement(self.m_root, "imgMedal2_CellRankSeat", WZUIImage)
    end
    imgMedal:setVisible(true)

    if nRankIndex == 1 then
        imgMedal:setFile("ui/common/common_icon_1st_1.png")
    elseif nRankIndex == 2 then
        imgMedal:setFile("ui/common/common_icon_2nd_1.png")
    elseif nRankIndex == 3 then
        imgMedal:setFile("ui/common/common_icon_3rd_1.png")
    end
end

--@brief    膜拜按钮回调
function CellRankSeat:onWorship()
    -- body
    WZLog("************ CellRankSeat:onWorship *************", CacheCenter:getPlayerInfo().id, self.m_tDatawifeId, self.m_tData.id)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    --不能膜拜自己，提示：不可自恋噢
    TeachGroup1:endTeachStep({16,3})
    if self.m_nType == 23 then 
        if self.m_tData.id == CacheCenter:getPlayerInfo().id or self.m_tData.wifeId == CacheCenter:getPlayerInfo().id then
            MsgBoxManager:showTipBox(LocalStrings.CANT_WORSHIP_SELF)
            return 
        end
    else
        if self.m_tData.id == CacheCenter:getPlayerInfo().id then
            if self.m_nType == 99 then 
                if WndPvpRankKing.logData.gold <= 0 then
                    MsgBoxManager:showTipBox(LocalStrings.RANK_SCORE_DESC2)
                else
                    ProtocolProcessorScenePvpRank:send_RANKMATCH_GetWorshipGold()
                end
            else
                MsgBoxManager:showTipBox(LocalStrings.CANT_WORSHIP_SELF)
            end
            return 
        end
    end
    --提示今日已经膜拜过
    self.m_nCanWorship = self:getWorshipRight()
    WZLog("******** self.m_nCanWorship ********", self.m_nCanWorship)
    if self.m_nCanWorship == 0 or self.m_nCanWorship == nil then
        MsgBoxManager:showTipBox(LocalStrings.HAVED_WORSHIP_TODAY)
        return 
    else
        if CacheCenter:getPlayerInfo().vigor + 10 >= g_nMaxVigor  then
            MsgBoxManager:showTipBox(LocalStrings.TIPS10)
            return 
        end
        CellRankSeat.m_current_click = self
        --可以膜拜
        if self.m_nType == 98 then 
            ProtocolProcessorScenePvpRank:send_TRIO_TourWorship(self.m_tData.id)
        elseif self.m_nType == 99 then 
            ProtocolProcessorScenePvpRank:send_RANKMATCH_Worship(self.m_tData.id)
        else
            PostPlayerEvent:postEvent(PostPlayerEvent.event_tenLvClickWorship)
            
            ProtocolProcessorWndRankList:send_RANK_Worship(self.m_nType, self.m_tData.id)
        end
    end

    
end

--@brief    查看信息
function CellRankSeat:onCheckWifeInfo()
    -- body
    -- WZLog("*******************", Serialize(self.m_tData))
    WZLog("************ CellRankSeat:onCheckWifeInfo ***********", self.m_tData.wifeId)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    --妻子的ID
    if self.m_nType == 23 then 
        WndCheckOther:show(self.m_tData.wifeId)
    else
        WndCheckOther:show(self.m_tData.id)
    end
end


--@brief    查看信息
function CellRankSeat:onCheckHusbandInfo()
    -- body
    -- WZLog("*******************", Serialize(self.m_tData))
    WZLog("************ CellRankSeat:onCheckHasbandInfo ***********", self.m_tData.id)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    --丈夫的ID
    WndCheckOther:show(self.m_tData.id)
end

--@brief    点击人物回调
function CellRankSeat:onCheckRole()
    -- body
    WZLog("********** CellRankSeat:onCheckRole **********", self.m_bIsLightHide)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_bIsLightHide then
        if self.m_tParentWnd ~= nil then
            self.m_tParentWnd:clearChecked()
        end

        self:setChecked(false)
    else
        if self.m_tParentWnd ~= nil then
            self.m_tParentWnd:clearChecked()
        end
        PostPlayerEvent:postEvent(PostPlayerEvent.event_tenLvClickPlayer)

        self:setChecked(true) 
    end

    local isEndTeach, finishStep = TeachGroup1:isTeachFinish(16)
    WZLog("CellRankSeat:onCheckRole two", isEndTeach, finishStep)
    if isEndTeach ~= true and TeachGroup1:isTeach() and CacheCenter:getPlayerInfo().level == 10 then
        WindowManager:removeTeachShelterLayer()
        TeachGroup1:endTeachStep({16,2})
        TeachGroup1:startGroup({16,3,self.m_root})
    end
end

--@brief    点击宠物回调
function CellRankSeat:onCheckedPetInfo(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    local petMessage = self.m_tData.petMessage
    WZLog("宠物触摸结束:",petMessage)
    if petMessage ~= nil and petMessage ~= "" and petMessage ~= "{}" then
        petMessage = json.decode(self.m_tData.petMessage)
        local conPet = GetElement(self.m_root, "conRole", WZUIContainer)
        WndTips:show(conPet,self.m_parentNodeForTips,13,petMessage,GlobalMethod:ccp(200,60),false,false)
    end
end

--@brief    设置用到的一些数据
--@param    _rankType排行榜的类型
--@param    parentTable 父类表对象
--@param    parentNodeForTips 弹宠物Tips的父节点
function CellRankSeat:setOtherData(_rankType, parentTable, parentNodeForTips)
    -- body
    self.m_tParentWnd = parentTable
    if _rankType == 3 or _rankType == 60 or _rankType == 98 or _rankType == 99 then  --宠物榜
        self.m_parentNodeForTips = parentNodeForTips
    end
end

--@brief    设置膜拜按钮等是否可见
function CellRankSeat:setChecked(bBool)
    -- body
    GetElement(self.m_root, "conCheck_CellRankSeat", WZUIContainer):setVisible(bBool)
    GetElement(self.m_root, "armature_CellRankSeat", WZArmature):setVisible(bBool)
end

--@brief    膜拜权限
function CellRankSeat:getWorshipRight()
    -- body
    if self.m_nType == 98 or self.m_nType == 99 then 
        return WndPvpRankKing:getCanWorship()
    else
        return WndRankList:getCanWorship()
    end
end

--@brief    检查坐标点是否在某容器范围内
--@param    pt:鼠标点击的世界坐标
--@return   在按钮范围内返回true,否则返回false
function CellRankSeat:checkPointInCon(pt)
    WZLog("CellRankSeat:checkPoint",pt.x,pt.y)
    if self.m_root == nil then return end
    local btn = GetElement(self.m_root,"conInfo_CellRankSeat",WZUIContainer)
    if btn == nil then return false end
    local btnSize = btn:getContentSize()
    --获得btn的世界坐标
    local ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
    WZLog("获得btn 世界坐标",ptA.x,ptA.y)
    WZLog("按钮大小",btnSize.width,btnSize.height)
    local conCheck = GetElement(self.m_root, "conCheck_CellRankSeat", WZUIContainer)
    
    if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
        WZLog("点击在按钮范围内")
        if conCheck:isVisible() then
            if not self:checkPointInBtn(pt, "btnCheckWife") and not self:checkPointInBtn(pt, "btnCheckHusband") and not self:checkPointInBtn(pt, "btnWorship") then
                WZLog("点击在按钮范围外 111111")
                self.m_bIsLightHide = true
                return false
            end
            WZLog("点击在按钮范围外 222222")
            self.m_bIsLightHide = false
            return true
        else
            WZLog("点击在按钮范围外 33333")
            self.m_bIsLightHide = false
            return true
        end
    else
        WZLog("点击在按钮范围外")
        self.m_bIsLightHide = true
        return false
    end 
end

--@brief    检查坐标点是否在某容器范围内
--@param    pt:鼠标点击的世界坐标
--@return   在按钮范围内返回true,否则返回false
function CellRankSeat:checkPointInBtn(pt, sBtnName)
    WZLog("CellRankSeat:checkPoint",pt.x,pt.y)
    if self.m_root == nil then return end
    local btn = GetElement(self.m_root,sBtnName,WZUIButton)
    if btn == nil then return false end
    if not btn:isVisible() then return false end
    local btnSize = btn:getAbsContentSize()
    --获得btn的世界坐标
    local ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
    WZLog("获得btn 世界坐标",ptA.x,ptA.y)
    WZLog("按钮大小",btnSize.width,btnSize.height)
    if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
        WZLog("点击在按钮范围内")
        return true
    else
        WZLog("点击在按钮范围外")
        return false
    end 
end

--@brief    設置其中的某些节点控件不可见
function CellRankSeat:setNodeVisible()
    --body
    GetElement(self.m_root, "onlineState_CellRankSeat", WZUILabelTTF):setVisible(false)
    GetElement(self.m_root, "conFight", WZUIContainer):setVisible(false)
    --设置妻子不可点击
    GetElement(self.m_root, "btnCheckInfo", WZUIButton):setTouchEnable(false)
end

function CellRankSeat:setRedDot(bBool)
    -- body
    GetElement(self.m_root, "imgRedDot_CellRankSeat", WZUIImage):setVisible(bBool)
end

--@brief    设置其中的某些控件的锚点
function CellRankSeat:setAnchorPointForNode(nAnchorX)
    --body
    GetElement(self.m_root, "imgWifeHasband_CellRankSeat", WZUIImage):setRelativePosition(GlobalMethod:ccp(nAnchorX, 0.95))
    GetElement(self.m_root, "playerName", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(nAnchorX, 0.85))
end

function CellRankSeat:receiveWorshipOK(vigor, result)
    -- body
    self:_closeLoading()
    if result == 1 and CellRankSeat.m_current_click and CellRankSeat.m_current_click.m_root then
        if CellRankSeat.m_current_click.m_nType ~= 98 and CellRankSeat.m_current_click.m_nType ~= 99 then 
            WndRankList:setCanWorship(0)
            local sWorshipResult = string.format(LocalStrings.WORSHIP_SUCCESS, vigor)
            MsgBoxManager:showTipBox(sWorshipResult)
        end
        self:updateWorshipTime()
    else
        WZLog("******** Worship Failed ! ********")
    end
end

--@brief    更新膜拜次数
function CellRankSeat:updateWorshipTime()
    -- body
    local tData = CellRankSeat.m_current_click.m_tData
    -- WZLog("CellRankSeat:updateWorshipTime", Serialize(tData))
    local sBeworshipTimes = string.format(LocalStrings.BEWORSHIP_TIMES, tData.worshipNum + 1)
    GetElement(CellRankSeat.m_current_click.m_root, "txtBeWorshipTimes_CellRankSeat", WZUIFreeTextBox):setShowText(sBeworshipTimes)
end

--@brief    切换播放角色动画
function CellRankSeat:changeRoleAni()
    -- body
    if self.m_tPlayerAni == nil then return end
    if self.m_tData.bodyId and self.m_tData.bodyId < 0 then return end 
    self.m_tPlayerAni:play(g_tRoleAnitionName[2],false)
    self.m_root:enableSchedule("updateRole")
end

--@brief    角色relax动画播完的回调
function CellRankSeat:updateRole(element, delta)
    -- body
    if not self.m_tPlayerAni:isPlaying() then
        local isEnd = self.m_tPlayerAni:isCurrentAnimationDone()
        if isEnd then
            self.m_tPlayerAni:play("wait0", true)
            self.m_root:disableSchedule()
        end
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief   玩家人物
--@param   tData玩家数据
--@param    是否显示宠物
--@param    角色的锚点
function CellRankSeat:_setPlayer(tData, bFlipX, bShowPet, ccpAnchor)
    if self.m_root == nil then return end

    local anchorPoint = ccpAnchor or GlobalMethod:ccp(0.5, 0)
    local bDisplayPet = bShowPet or false
    local nSex = tData.sex or 0
    local bBool = bFlipX or false
    local tEquip = {}
    table.insert(tEquip,tData.headId)
    table.insert(tEquip,tData.faceId)
    table.insert(tEquip,tData.bodyId)
    table.insert(tEquip,tData.wingId)

    local petAni = nil 
    local petAdvancedLevel = nil 
    if bDisplayPet then
        if tData.petMessage ~= nil and tData.petMessage ~= "" then
            local petMessage = json.decode(tData.petMessage)
            petAni = petMessage.animation
            if petMessage.petSkinItemId and petMessage.petSkinItemId > 0 then
                local tempAnimation = GetPetAnimation(petMessage.petSkinItemId, petMessage.advancedLevel)
                petAni = tempAnimation
            end
            petAdvancedLevel = petMessage.advancedLevel
        end
    end

    local conPlayerAni = self.m_root:getChildElement("conRole")

    local conPlayer
    if self.m_tPlayerAni == nil then --"wait0"
        conPlayer, pet, effect = CreatePlayerFigure(nSex, tEquip, "wait0", nil, petAni, ccp(-0.4,1.5), nil, nil, nil, petAdvancedLevel,tData.headColor, tData.bodyColor)
        conPlayerAni:addChild(conPlayer:getAnimNode())
        conPlayer:getAnimNode():setScale(0.85)
        self.m_tPlayerAni = conPlayer
        conPlayer:setFlipX(bBool)
        conPlayer:getAnimNode():setRelativePosition(anchorPoint) 

        if pet and effect then
            local size = pet:getAnimNode():getContentSize()
            local effectX, effectY = effect:getPosition()
            effect:setPosition(GlobalMethod:ccp(-60, effectY-40))
        end

        conPlayer:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5, 0))
    else
        conPlayer = self.m_tPlayerAni
        conPlayer:setFlipX(bBool)
        conPlayer:getAnimNode():setRelativePosition(anchorPoint)
    end
end

--@brief    创建加载框
function CellRankSeat:_createLoading()
    self.m_nLoadingId = MsgBoxManager:showLoadingBox()
    WZLog("******** CellRankSeat:_createLoading ********", self.m_nLoadingId)
end

--@brief   关闭加载框
function CellRankSeat:_closeLoading()
    WZLog("******** CellRankSeat:_closeLoading ********", self.m_nLoadingId)
    MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
end

--@brief    创建榜中角色的名字，等级
--@param    parentNode 父节点
--@param    sTitle 称号
--@param    sName 名字
--@param    sIconFile 图标文件
--@param    sLvNum 图标等级
--@param    sAtlasFileName 显示图标等级用到的数字图片
--@param    ccpAtlas 等级的想多坐标
--@param    bTitleStroke: 称号是否加描边
function CellRankSeat:_createName(parentNode, strLv, sName, qqHallData)
    GetElement(self.m_root,"playerName",WZUILabelTTF):setVisible(false)
    -- body
    local conTemp = WZUIContainer:create()
    conTemp:setAbsContentSize(GlobalMethod:CCSize(100, 50))
    conTemp:setAnchorPoint(GlobalMethod:ccp(0.5, 1))
    conTemp:setRelativePosition(GlobalMethod:ccp(0.55, 1))
    conTemp:setUseAbsSize(true)
    parentNode:addChild(conTemp)

    local conName = WZUIContainer:create()
    conName:setAnchorPoint(GlobalMethod:ccp(0.5, 1))
    conName:setRelativePosition(GlobalMethod:ccp(0.5, 0.35))
    conName:setUseAbsSize(true)
    conTemp:addChild(conName)
    --玩家等级
    local nTempWidth = 0 
    local txtLv = WZUILabelTTF:create()
    txtLv:setText(strLv)
    txtLv:setFontSize(20)
    txtLv:setColor(GlobalMethod:ccc3(255,255,255))
    txtLv:setStrokeColor(GlobalMethod:ccc3(132,66,29))
    txtLv:setEnableStroke(true)
    txtLv:setStrokeSize(4)
    txtLv:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
    txtLv:setUseAbsCoordinate(true)
    txtLv:setAbsPosition(GlobalMethod:ccp(nTempWidth, 15))
    txtLv:setUseOriginSize(true)
    conName:addChild(txtLv)
    local tempLvSize = txtLv:getContentSize()
    nTempWidth = nTempWidth + tempLvSize.width

    local bShowQQInfo = true 
    if ProjConfig:getChannelId() ~= 1118 then 
        bShowQQInfo = false 
    end 

    if qqHallData and bShowQQInfo then 
        if qqHallData.is_blue_vip or qqHallData.is_super_blue_vip then 
            local imgIconBlue = WZUIImage:create()
            imgIconBlue:setUseOriginSize(true)
            imgIconBlue:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
            imgIconBlue:setUseAbsCoordinate(true)
            imgIconBlue:setAbsPosition(GlobalMethod:ccp(nTempWidth, 15))
            local iconPath = ""
            if qqHallData.is_super_blue_vip then 
                iconPath = "ui/qqHall/hh_" .. qqHallData.blue_vip_level .. ".png"
            else
                iconPath = "ui/qqHall/pz_" .. qqHallData.blue_vip_level .. ".png"
            end
            imgIconBlue:setFile(iconPath)
            imgIconBlue:setScale(0.6)
            conName:addChild(imgIconBlue)
            nTempWidth = nTempWidth + 25

            if qqHallData.is_blue_year_vip then 
                local iconYearPath = "ui/qqHall/nian.png"
                local imgIconYear = WZUIImage:create()
                imgIconYear:setUseOriginSize(true)
                imgIconYear:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
                imgIconYear:setUseAbsCoordinate(true)
                imgIconYear:setAbsPosition(GlobalMethod:ccp(nTempWidth, 15))
                imgIconYear:setFile(iconYearPath)
                imgIconYear:setScale(0.6)
                conName:addChild(imgIconYear)
                nTempWidth = nTempWidth + 25
            end
        end
    end
    WZLog("CellRankSeat:_createName Two", nTempWidth)
    --玩家名字
    local txtName = WZUILabelTTF:create()
    txtName:setText(sName)
    txtName:setFontSize(20)
    txtName:setColor(GlobalMethod:ccc3(255,255,255))
    txtName:setStrokeColor(GlobalMethod:ccc3(132,66,29))
    txtName:setEnableStroke(true)
    txtName:setStrokeSize(4)
    txtName:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
    txtName:setUseAbsCoordinate(true)
    txtName:setAbsPosition(GlobalMethod:ccp(nTempWidth, 15))
    txtName:setUseOriginSize(true)
    conName:addChild(txtName)
    local tempNameSize = txtName:getContentSize()
    nTempWidth = nTempWidth + tempNameSize.width

    WZLog("CellRankSeat:_createName Three", nTempWidth)
    conName:setAbsContentSize(GlobalMethod:CCSize(nTempWidth, 30))
    conName:updateRelativeSize()
end
-------------------------------------私有方法模块End----------------------------------------
