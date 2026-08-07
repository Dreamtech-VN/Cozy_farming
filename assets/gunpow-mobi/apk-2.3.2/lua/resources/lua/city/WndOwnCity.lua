--WndOwnCity.lua
--@brief	WndOwnCity的UI模块
--@date		2015/2/11
--@author	莫剑峰
--@note		主城UI


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note	在这里做场景进入前的准备工作
function WndOwnCity:onEnter(element)
    WZLog("WndOwnCity:onEnter",self.g_tMailCount)    
	self.m_root = element

    CacheCenter:registerUpatePlayerInfoObserver(self)
    CacheCenter:registerUpdateDecorationObserver(self)
    CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
    self:_moreLanguage()
    AdaptLanguage(self)

    if IsIphoneX() then
        GetElement(self.m_root, "conUp_WndOwnCity", WZUIContainer):setRelativePositionLuaTo(0.4,1.04)
        GetElement(self.m_root, "conBtnInfo_WndOwnCity", WZUIContainer):setRelativePositionLuaTo(0.04,-0.768004)
    end

    -- 登录定向推送
    if tostring(ProjConfig:getChannelId()) ~= "53" and tostring(ProjConfig:getChannelId()) ~= "75" and tostring(ProjConfig:getChannelId()) ~= "275" then
        ProtocolProcessorCommonPush:send_COMMONPUSH_LoginDirectionalPush( )
    end

    self:finishCallFunc(element)
end
--@brief    获取前景Layer
function WndOwnCity:getFrontLayer()
    if self.m_root then
        local layer = GetElement(self.m_root,"conFrontLayer",WZUIContainer)
        return layer
    end
end

function WndOwnCity:_moreLanguage()
    GetElement(self.m_root, "txtInfoCheck_WndOwnCity", WZUILabelTTF):setText(LocalStrings.PETLOOK)
    GetElement(self.m_root, "txtInfoCheckSel_WndOwnCity", WZUILabelTTF):setText(LocalStrings.PETLOOK)
end

--@brief	删除多余的资源
function WndOwnCity:finishCallFunc(element)
    WZLog("WndOwnCity:finishCallFunc one") 
    WndSetting:_initUserData()

    self:init()
    if CacheCenter.m_nDailyMark == 1 then
        CacheCenter:addMark("btnFriend_WndOwnCity",1,2)
    end
    if CacheCenter.m_nMailMark == 1 then
        CacheCenter:addMark("btnMail_WndOwnCity",1,3)
    end
    local conGold = self.m_root:getChildElement("conGold_WndOwnCity")
    if conGold then
        local celElement,tCell = CellGold:createElement()
        if celElement and tCell then
            conGold:addChild(celElement)
            tCell:showCoin({1,177,2,6},{1,1,1,1})
            tCell:setCellType(1)
            celElement:setRelativePosition(GlobalMethod:ccp(0.34,0.6))
            celElement:setScale(0.9)
            -- if IsIphoneX() then
            --     celElement:setRelativePosition(GlobalMethod:ccp(0.38,0.63))
            -- end
        end
    end
    WZLog("_update_update_update_update_update 000")
    self:_update()
    ProtocolProcessorSceneCity:send_PLAYER_GetUpdateRedDot()
    
    ProtocolProcessorFund:regAll()
    ProtocolProcessorFund:send_FUNDGROW_GetFundInfo()

    WndOwnCity:updateMonthCardRedPoint()

    WndOwnCity:updateSingleCopyGuild()

    self.m_tLine = BattleOtherPointsLine:create(self:getFrontLayer(), 20, nil, nil, nil, nil, nil, nil, GlobalMethod:ccp(480,320), self, 
        {x1=0,x2=1136,y1=0,y2=640})
    self.m_root:enableSchedule("loopTime", 1)

    --Add By Tianxiang_Xu
    --登录时战斗力变化，延迟到这里显示
    g_bIsShowFightingLater = false
    if g_nLaterShowFighting then
        WZLog("+++++++++++  WndOwnCity:finishCallFunc", g_nLaterShowFighting)
        local nFighting = g_nLaterShowFighting
        g_nLaterShowFighting = nil
        upPlayerFightingAni(nFighting)
    end

    
    --越南语渠道那里悬浮窗的控制
    if WGameCmUtil:GetBundleIdentifier() == "com.wyd.gunpow" then
        local sdkTab = {}
        sdkTab.funType = "showButton"
        PassportSdkManager:Others(sdkTab)
    end
end

--@brief    特定等级显示单人副本引导框
function WndOwnCity:updateSingleCopyGuild()
    WZLog("WndOwnCity:updateSingleCopyGuild")
    if self.m_root == nil then
        return
    end
    local level = CacheCenter:getPlayerInfo().level
    local conBtnCopyGuild = GetElement(self.m_root,"conBtnCopyGuild_WndOwnCity",WZUIContainer)
    local imgCopyIcon = GetElement(self.m_root,"imgCopyIcon_WndOwnCity",WZUIImage)
    local txtCopyName = GetElement(self.m_root,"txtCopyName_WndOwnCity",WZUILabelTTF)
    local txtCopyTalk = GetElement(self.m_root,"txtCopyTalk_WndOwnCity",WZUILabelTTF)

    if IsIphoneX() then
        conBtnCopyGuild:setRelativePosition(GlobalMethod:ccp(0.02,-2.5))
    end

    conBtnCopyGuild:setVisible(false)

    if level >= 6 and level <= 13 then
        local nLastCopyId = WndSingleCopy:getCommonTypeLastLevel()
        local mapInfo = WndSingleCopy:_getNextLevel(nLastCopyId)
        if mapInfo then
            conBtnCopyGuild:setVisible(true)
            local sectionIcon = "ui/copy/common_fb_map" .. (mapInfo.section + 1) .. ".png" --第一章为common_fb_map2
            local sectionName = mapInfo.section_name
            imgCopyIcon:setFile(sectionIcon)
            txtCopyName:setText(sectionName)
            local str = LocalStrings.GUIDE_TEXT1[mapInfo.section] or ""
            txtCopyTalk:setText(str)
        end
    end

end

--@brief    点击前往单人副本引导按钮回调
function WndOwnCity:onClickCopyGuild(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local nLastCopyId = WndSingleCopy:getCommonTypeLastLevel()
    local mapInfo = WndSingleCopy:_getNextLevel(nLastCopyId)
    if mapInfo then
        SceneCopy:showScene(1,nil,nil,nil,mapInfo.section)
    end
end

    --登录定向推送礼包入口回调
function WndOwnCity:openLimitPackage( element )
    local tNewUserPackageList = CacheCenter:getLimitPackageList()
    if #tNewUserPackageList == 1 then
        local curPackage = tNewUserPackageList[1] 
        if curPackage then
            local pushInfo = {}
            table.insert(pushInfo, curPackage.pushInfo)
            local lastNum = {}
            table.insert(lastNum, curPackage.lastNum)
            local originPrice = {}
            table.insert(originPrice, curPackage.originPrice)
            local endTime = {}
            table.insert(endTime, curPackage.endTime)
            WndVipGift:showInterface(pushInfo, lastNum, 2, originPrice, 505, endTime)
        end
    elseif #tNewUserPackageList > 1 then
        local pushInfo = {}
        local lastNum = {}
        local originPrice = {}
        for k,v in pairs(tNewUserPackageList) do
            table.insert(pushInfo, v.pushInfo)
            table.insert(lastNum, v.lastNum)
            table.insert(originPrice, v.originPrice)
        end
        WndSpecifyActivity:showInterface(pushInfo, lastNum, originPrice)
    end
end


function WndOwnCity:createLimitPackageBtn( )
    if not self.m_root then return end
    if CacheCenter:getGameParam().gameStatus == "1" then return end 
    local tNewUserPackageList = CacheCenter:getLimitPackageList()
    if tNewUserPackageList == nil or #tNewUserPackageList == 0 then return end 

    local btnLimitPackage = GetElement(self.m_root,"btnLimitPackage_WndOwnCity",WZUIButton)
    if btnLimitPackage then return end

    local btnPackage = WZUIButton:create()
    btnPackage:setName("btnLimitPackage_WndOwnCity")
    btnPackage:setAbsContentSize(GlobalMethod:CCSize(100,80))
    btnPackage:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    btnPackage:setUseAbsSize(true)
    btnPackage:setRelativePosition(GlobalMethod:ccp(1.008, 0.77))
    btnPackage:setVisible(true)
    btnPackage:setShowAll(true)
    if IsIphoneX() then 
        btnPackage:setRelativePosition(GlobalMethod:ccp(0.97, 0.77))
    end

    local imgNormal = WZUIImage:create()
    imgNormal:setUseOriginSize(true)
    imgNormal:setFile("ui/city/beta/commom_icon_wz_tuijian.png")

    local imgSel = WZUIImage:create()
    imgSel:setUseOriginSize(true)
    imgSel:setFile("ui/city/beta/commom_icon_wz_tuijian.png")
    imgSel:setScale(1.1)
    
    btnPackage:setNormalElement(imgNormal)
    btnPackage:setSelectElement(imgSel)
    btnPackage:setLuaDoneFunctionName("openLimitPackage")

    local spineBtn = WZUISpine:create()
    spineBtn:setLoop(true)
    spineBtn:setRelativePosition(GlobalMethod:ccp(0.5,1))
    spineBtn:setVisible(true)
    spineBtn:setTouchEnable(false)
    spineBtn:setFileJson("city/ui_main_iconeffect.json")
    spineBtn:setFileAtlas("city/ui_main_iconeffect.atlas")
    spineBtn:setAnimationName("animation")
    btnPackage:addChild(spineBtn)

    local txtBtn = WZUILabelTTF:create()
    txtBtn:setName("txtLimitPackageBtn_WndOwnCity")
    txtBtn:setText(LocalStrings.VIPWEEK_PACKAGE3)
    txtBtn:setColor(GlobalMethod:ccc3(255,236,193))
    txtBtn:setStrokeColor(GlobalMethod:ccc3(79,60,48))
    txtBtn:setRelativePosition(GlobalMethod:ccp(0.5, 0))
    txtBtn:setFontSize(18)
    txtBtn:setEnableStroke(true)
    txtBtn:setStrokeSize(4)
    btnPackage:addChild(txtBtn)

    self.m_root:addChild(btnPackage, 0, 505)
end

function WndOwnCity:_showLeftTime()
    local nCurTime = SystemTime:getServerTime()
    local tNewUserPackageList = CacheCenter:getLimitPackageList()
    local maxLimitTime = 0
    if tNewUserPackageList == nil then return end 
    for k,v in pairs(tNewUserPackageList) do
        maxLimitTime = math.max(maxLimitTime,v.endTime)
    end

    local btnLimitPackage = GetElement(self.m_root,"btnLimitPackage_WndOwnCity",WZUIButton)
    if btnLimitPackage == nil then return end 

    if nCurTime > maxLimitTime then 
        btnLimitPackage:setVisible(false)
        return 
    end
    local nLeftSeconds = maxLimitTime - nCurTime 
    local txtLimitPackageBtn = GetElement(self.m_root,"txtLimitPackageBtn_WndOwnCity",WZUILabelTTF)
    
    if txtLimitPackageBtn then 
        txtLimitPackageBtn:setVisible(true)
        if nLeftSeconds >= 0 then 
            local hours,minutes,seconds
            hours = math.floor(nLeftSeconds/3600)
            minutes = math.floor((nLeftSeconds%3600)/60)
            seconds = nLeftSeconds%60
            txtLimitPackageBtn:setText(string.format("%d:%d:%d", hours, minutes, seconds))
        else
            btnLimitPackage:setVisible(false)
        end
    end
end

--@brief    更新月卡小红点
function WndOwnCity:updateMonthCardRedPoint()
    if self.m_root == nil or self.m_tBtnList == nil then
        WZLog("WndOwnCity:updateMonthCardRedPoint")
        return
    end
    local isOpen = GetMonthCardTime() <= 0

    local con = GetElement(self.m_root, "con66_WndOwnCity", WZUIContainer)
    WZLog("WndOwnCity:updateMonthCardRedPoint1", isOpen, con)
    if con then
        local armature = GetElement(con, "armaFirstRechangeNormal_WndOwnCity")
        WZLog("WndOwnCity:updateMonthCardRedPoint2", isOpen, armature)
        if isOpen and armature == nil then
            local anim = BattleAnimation:createAnimation("ui_main_iconeffect", false, "city")
            local armature = anim.m_node
            armature:setName("armaFirstRechangeNormal_WndOwnCity")
            armature:setUseOriginSize(true)
            armature:setAnchorPoint(GlobalMethod:ccp(0.5,yArma))
            armature:setTouchEnable(false)
            armature:setAnimationName("animation")
            armature:setLoop(true)
            GetElement(con, "conNormal_WndOwnCity", WZUIContainer):addChild(armature)
            GetElement(con, "conNormal_WndOwnCity", WZUIContainer):setZOrder(2)

            local anim = BattleAnimation:createAnimation("ui_main_iconeffect", false, "city")
            local armature = anim.m_node
            armature:setName("armaFirseRechangeSel_WndOwnCity")
            armature:setUseOriginSize(true)
            armature:setAnchorPoint(GlobalMethod:ccp(0.5,yArma))
            armature:setTouchEnable(false)
            armature:setAnimationName("animation")
            armature:setLoop(true)
            GetElement(con, "conSel_WndOwnCity", WZUIContainer):addChild(armature)
            GetElement(con, "conSel_WndOwnCity", WZUIContainer):setZOrder(2)
        elseif isOpen == false and armature ~= nil then
            armature:removeFromParentAndCleanup(true)
            local armature2 = GetElement(con, "armaFirseRechangeSel_WndOwnCity")
            armature2:removeFromParentAndCleanup(true)
        end
    end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndOwnCity:onExit(element)

    if self.m_adapter then
        WydPlAdapterManager:sharedWydPlAdapterManager():destroyAdapter(self.m_adapter:getId())
        self.m_adapter = nil
    end

    --add by wuweidong
    GlobalGame:getBtnRedPointEvent():unregListener("Sign","WndOwnCity")
    GlobalGame:getBtnRedPointEvent():unregListener("GameActivity","WndOwnCity")
    GlobalGame:getBtnRedPointEvent():unregListener("WishWell","WndOwnCity")
    WZLog("WndOwnCity:onExit", tostring(g_bIsPushScene), tostring(g_bIsPopScene))
    CacheCenter:unregisterUpatePlayerInfoObserver(self)
    CacheCenter:unregisterUpateDecorationObserver(self)
    CacheCenter:unregisterUpatePlayerItemObserver(self)
    if self.m_root then 
        self.m_root:disableSchedule()
    end
	self:_unInit()
    --Teach:isStartTeach("WndOwnCity:onExit")
     --越南语渠道那里悬浮窗的控制
    if WGameCmUtil:GetBundleIdentifier() == "com.wyd.gunpow" then
        local sdkTab = {}
        sdkTab.funType = "hideButton"
        PassportSdkManager:Others(sdkTab)
    end
end

--@param    设置当前场景
function WndOwnCity:setScene(scene)
    self.m_tScene = scene
end

--@note     检查中文
function WndOwnCity:checkChinese(str)
    local isChinese = false
    for ch in string.gmatch(str, "[\\0-\127\194-\244][\128-\191]*") do
        isChinese = #ch~=1
    end
    WZLog("WndOwnCity:checkChinese", str , isChinese)
    return isChinese
end

--@brief	初始化
--@note		界面前的所有初始化
function WndOwnCity:init(isUpdate)
    WZLog("WndOwnCity:init one", CacheCenter:getPlayerInfo().level, g_CityTopBtnState, tostring(self.m_sRes))
    if self.m_sRes == nil then 
        self:setSwitchState(g_CityTopBtnState)
        if not g_CityTopBtnState then 
            self.m_nMoveDirection = 1
            GetElement(self.m_root, "conActivityBtns_WndOwnCity", WZUIContainer):setRelativePosition(GlobalMethod:ccp(3,0.86))
        end
    end

    local playerInfo = CacheCenter:getPlayerInfo()

    local txtName = GetElement(self.m_root, "txtName_WndOwnCity", WZUILabelTTF)
    txtName:setText(playerInfo.name)
    local isChinese = self:checkChinese(playerInfo.name)
    if isChinese and txtName:getWordCount() >= 7 then
       txtName:setMaxLength(5)
    elseif not isChinese then
        if txtName:getWordCount() >= 13 then
            txtName:setMaxLength(10)
            WZLog("WndOwnCity:init four1")
        else
            txtName:setMaxLength(12)
            WZLog("WndOwnCity:init four2")
        end
    end
    txtName:setText(playerInfo.name)

    local txtLv = GetElement(self.m_root, "txtLv_WndOwnCity", WZUILabelTTF)
    txtLv:setText(playerInfo.level)

    local txtFight = GetElement(self.m_root, "txtFight_WndOwnCity", WZUILabelAtlasFont)
    txtFight:setText(playerInfo.fighting)

	--人物经验条
	local exp = playerInfo.exp
	local maxExp = playerInfo.maxExp
	local percent = math.floor(tonumber(exp)*100/tonumber(maxExp))
	WZLog("经验条",percent, exp, maxExp)
	GetElement(self.m_root,"progressExp_WndOwnCity",WZUIProgress):setPercentage(percent)
    local txtExp = GetElement(self.m_root, "txtExp_WndOwnCity", WZUILabelTTF)
    txtExp:setText("" ..percent .. "%")

    --职业图标
    local namePosX = 1.2
    local vipIconPosX = 0.5
    local qqBluePosX = 1.3
    if playerInfo.professionId and playerInfo.professionId > 0 then 
        if CacheCenter:getPlayerInfo().professionAttr2 == "{}" then
            GetElement(self.m_root, "imgProfessionIcon_WndOwnCity", WZUIImage):setFile(g_professionIcon[playerInfo.professionId])
        else 
            GetElement(self.m_root, "imgProfessionIcon_WndOwnCity", WZUIImage):setFile(g_professionIcon2[playerInfo.professionId])
        end
        namePosX = 1.45
        qqBluePosX = 1.62
    else
        GetElement(self.m_root, "imgProfessionIcon_WndOwnCity", WZUIImage):setFile("")
    end
    local conVipIcon = GetElement(self.m_root, "conVipIcon_WndOwnCity", WZUIContainer)
    local imgQQBlue = GetElement(self.m_root, "imgQQBlue_WndOwnCity", WZUIImage)
    local imgQQYear = GetElement(self.m_root, "imgQQYear_WndOwnCity", WZUIImage)
    --qq大厅蓝钻年费图标
    if playerInfo.qqHallData then 
        if playerInfo.qqHallData.is_blue_vip or playerInfo.qqHallData.is_super_blue_vip then 
            namePosX = namePosX + 0.35
            vipIconPosX = vipIconPosX + 0.3
            if playerInfo.qqHallData.is_super_blue_vip and imgQQBlue then 
                imgQQBlue:setFile("ui/qqHall/hh_" .. playerInfo.qqHallData.blue_vip_level .. ".png")
            elseif imgQQBlue then 
                imgQQBlue:setFile("ui/qqHall/pz_" .. playerInfo.qqHallData.blue_vip_level .. ".png")
            end
            if playerInfo.qqHallData.is_blue_year_vip and imgQQYear then 
                namePosX = namePosX + 0.35
                vipIconPosX = vipIconPosX + 0.3
                imgQQYear:setFile("ui/qqHall/nian.png")
            elseif imgQQYear then 
                imgQQYear:setFile("")
            end
        elseif imgQQBlue then 
            imgQQBlue:setFile("")
        end
    end
    txtName:setRelativePosition(GlobalMethod:ccp(namePosX, 0.75))
    conVipIcon:setRelativePosition(GlobalMethod:ccp(vipIconPosX, 0.5))
    if imgQQBlue then 
        imgQQBlue:setRelativePosition(GlobalMethod:ccp(qqBluePosX, 0.755))
    end

    local imgVip0 = GetElement(self.m_root, "imgVip0_WndOwnCity", WZUIImage)
    if tonumber(playerInfo.vipLevel) > 0 then
        local txtVip = GetElement(self.m_root, "txtVip_WndOwnCity", WZUILabelAtlasFont)
        txtVip:setText(playerInfo.vipLevel)
        txtVip:setVisible(true)

        imgVip0:setVisible(true)
        setVipIconByVipLevel(imgVip0, tonumber(playerInfo.vipLevel))
        GetElement(self.m_root, "imgVip1_WndOwnCity", WZUIImage):setVisible(true)
    else
        GetElement(self.m_root, "txtVip_WndOwnCity", WZUILabelAtlasFont):setVisible(false)
        imgVip0:setVisible(false)
        GetElement(self.m_root, "imgVip1_WndOwnCity", WZUIImage):setVisible(false)
    end

    if isUpdate == nil then
        local conPlayerAni = WndOwnCity.m_root:getChildElement("conHead_WndOwnCity")
        local tEquip = CacheCenter:getEquipmentList()
        local head = nil
        local face = nil

        if tEquip and next(tEquip) then
            for i = 1, #tEquip do
                local nEquipId = tEquip[i]
                if nEquipId ~= nil then
                    if type(nEquipId) == "table" then nEquipId = nEquipId.id end
                    local tEquipData = GetItemLocalData(nEquipId)

                    if tEquipData then
                        local maintype = tEquipData.main_type
                        local subtype = tEquipData.sub_type
--                        WZLog("WndOwnCity:init two", i, maintype, subtype, Serialize(tEquipData))
                        if maintype == 5 and subtype == 1 then --物品是否是脸谱
                            face = (tEquipData.id)
                        elseif maintype == 5 and subtype == 0 then -- 物品是否是头部 
                            head = (tEquipData.id)
                        end
                    end
                end
            end
        end

        --设置默认显示
        local gameParam = CacheCenter:getGameParam()
        if bIsBoy == true then
            if head == nil then head = gameParam.defaultManHeadId or 4903 end
            if face == nil then face = gameParam.defaultManFaceId or 4902 end
        else
            if head == nil then head = gameParam.defaultWomanHeadId or 4906 end
            if face == nil then face = gameParam.defaultWomanFaceId or 4905 end
            --head = 6004
        end
        local color, bcolor = CacheCenter:getHeadAndBodyColor()
        local headEffectId = CacheCenter:getPlayerHeadEffectItemId()
        local headAnim, headObj = CellHead:show(conPlayerAni,head,face,playerInfo.sex,false,{x=0.52, y=0.28},nil,color,"ui/city/newUI/common_shade_touxiang.png", 1, nil, nil, headEffectId)
        headAnim:setScale(0.9)
        self.m_tHeadAnim = headObj
        self.m_tHeadAnim:setHeadEffectScale(1.2)
    end

end

--@brief	教学
function WndOwnCity:teach()
    WZLog("WndOwnCity:teach")
    local tCell = GetElement(self.m_root, "conBtnFriend_WndOwnCity", WZUIContainer)
    local conShelter = WindowManager:addTeachShelterLayer( 1 )
    conShelter:setLuaObjectIndex(WndOwnCity)
    WndOwnCity.SHELTER = conShelter
    WndOwnCity.CELL = tCell
    WindowManager:addTeachTouchLayerForElement(tCell, tCell:getContentSize())
    WindowManager:setTeachTouchCallBack( WndOwnCity, "onTouchBegan" , nil, "onTouchEnd" , "onMoveOut")
end

--@brief	移开事件函数
function WndOwnCity:onMoveOut()
    WZLog("WndOwnCity:onMoveOut")
    WndOwnCity.ISMOVE = true
end

--@brief	更新玩家信息
--@note		界面前的所有初始化
function WndOwnCity:updateInfo()
    WZLog("WndOwnCity:updateInfo", tostring(self.m_root))
    if self.m_root == nil then
        return
    end
    self:init(true)
    --Add By Tianxiang_Xu
    if g_tTempSignData ~= nil then
        WZLog("******* 123123 *******", Serialize(g_tTempSignData))
        if g_tTempSignData.sign == true and g_tTempSignData.vipSign == false and g_tTempSignData.isVip == true and g_tTempSignData.vip_level <= CacheCenter:getPlayerInfo().vipLevel then
            CacheCenter:setRedState("btnSign",true) 
            GlobalGame:getBtnRedPointEvent():dispatcher("Sign",true)
            WZLog("******* 123123 111*******", Serialize(g_tTempSignData))
        end
    end
    --End Add
end

--@brief	隐藏他人头像
function WndOwnCity:hideOtherHead()
    if self.m_root == nil then
        return
    end

    local conBtn = GetElement(self.m_root, "conBtnInfo_WndOwnCity", WZUIContainer)
    conBtn:setVisible(false)

end

--@brief	显示他人头像
function WndOwnCity:showOtherHead(id)
    if self.m_root == nil then
        return
    end

    for i,figure in pairs(FigureSceneManager:getInstance().m_tFigureList) do
        if id == figure.m_nFigureId then
            self.m_nOtherId = id
            local txtInfoName = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtInfoName_WndOwnCity"))
            txtInfoName:setText(figure.m_tPlayerInfo.name)
            local txtTTF = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtInfoLv_WndOwnCity"))
            txtTTF:setText("LV"..figure.m_tPlayerInfo.level)
            --职业图标
            if figure.m_tPlayerInfo.professionId and figure.m_tPlayerInfo.professionId > 0 then 
                if figure.m_tPlayerInfo.professionAttr2 == "{}" then
                    GetElement(self.m_root, "imgOtherProfessionWndOwnCity", WZUIImage):setFile(g_professionIcon[figure.m_tPlayerInfo.professionId])
                else
                    GetElement(self.m_root, "imgOtherProfessionWndOwnCity", WZUIImage):setFile(g_professionIcon2[figure.m_tPlayerInfo.professionId])
                end
                txtInfoName:setRelativePosition(GlobalMethod:ccp(1.337, 0.698))
            end

            local conBtn = GetElement(WndOwnCity.m_root, "conBtnInfo_WndOwnCity", WZUIContainer)
            conBtn:setVisible(true)
            WndOwnCity.m_nOtherId = id

            local conHead = GetElement(WndOwnCity.m_root, "conHeadOther_WndOwnCity", WZUIContainer)
            local headAnim-- = CreateHeadAnim(conHead, 0.45, figure.m_tEquips, figure.m_tPlayerInfo.sex)
            local tEquip = figure.m_tEquips
            local head = nil
            local face = nil
            for i = 1, #tEquip do
                local nEquipId = tEquip[i]
                if nEquipId ~= nil then
                    if type(nEquipId) == "table" then nEquipId = nEquipId.id end
                    local tEquipData = GetItemLocalData(nEquipId)

                    if tEquipData then
                        local maintype = tEquipData.main_type
                        local subtype = tEquipData.sub_type
                        WZLog("WndOwnCity:showOtherHead two", i, maintype, subtype, Serialize(tEquipData))
                        if maintype == 5 and subtype == 1 then --物品是否是脸谱
                            face = (tEquipData.id)
                        elseif maintype == 5 and subtype == 0 then -- 物品是否是头部 
                            head = (tEquipData.id)
                        end
                    end
                end
            end

            --设置默认显示
            local gameParam = CacheCenter:getGameParam()
            if bIsBoy == true then
                if head == nil then head = gameParam.defaultManHeadId or 4903 end
                if face == nil then face = gameParam.defaultManFaceId or 4902 end
            else
                if head == nil then head = gameParam.defaultWomanHeadId or 4906 end
                if face == nil then face = gameParam.defaultWomanFaceId or 4905 end
                --head = 6004
            end

            WZLog("WndOwnCity:showOtherHead three", #tEquip, head, face, figure.m_tPlayerInfo.sex)
            headAnim = CellHead:show(conHead,head,face,figure.m_tPlayerInfo.sex,nil,GlobalMethod:ccp(0.43, 0.35),nil,figure.m_tPlayerInfo.colour,"ui/common/common_scale9_beibaodi.png", 1.5)
            headAnim:setScale(0.9)
            --headAnim:setPosition(Vector2:create(37,60))
        end
    end
end

--@brief    创建头像
function WndOwnCity:createHeadAnimOther(tStrList, nSex, con)
    WZLog("WndOwnCity:createHeadAnim")

    local tHeadA = {}
    tHeadA.bhead = tStrList.bhead
    tHeadA.bface = tStrList.bface
    local headAnim
    if nSex == 0 then
        headAnim = BattleAnimation:createAnimation(IWCO_BATTLEBOY)
    else
        headAnim = BattleAnimation:createAnimation(IWCO_BATTLEGIRL)
    end
    headAnim:getAnimNode():retain()
    headAnim:addAnimation("standby1",tHeadA, 0.2, false)
    headAnim:playTimes("standby1",0)
    headAnim:setFlipX(true)
    headAnim:setPosition(Vector2:create(117,-11))

    if con ~= nil then
        con:setVisible(true)
        if con:getChildByTag(77) ~= nil then
            WZLog("WndOwnCity:createHeadAnim two")
            con:removeChildByTag(77,true)
        end
        con:addChild(headAnim:getAnimNode(),0,77)
    end
    return headAnim
end

--@brief    点击问卷按钮后的响应方法
--@param    element:按钮的UI节点引用
--@note 在这里做相应的按钮相应事件
function WndOwnCity:onClickOPPOAmberPlayer(element)
    WZLog("WndOwnCity:onClickOPPOAmberPlayer")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    local isTeach = (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 24 and TeachGroup1.STEP == 1) or (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 29 and TeachGroup1.STEP == 1) or (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 1 and TeachGroup1.STEP == 2)
    local isOpenOPPOAmberPlayer = g_cityExtenInfo ~= nil and g_cityExtenInfo.oppoActivity and g_cityExtenInfo.oppoActivity ~= 0 and ProjConfig.CHANNEL_ID == 23
    if isOpenOPPOAmberPlayer and isTeach ~= true then
        WndActivityIntegrate:showInterface(6)
    end
end

--@brief    点击问卷按钮后的响应方法
--@param    element:按钮的UI节点引用
--@note 在这里做相应的按钮相应事件
function WndOwnCity:onClickSurvey(element)
    WZLog("WndOwnCity:onClickSurvey")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    local isTeach = (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 15 and TeachGroup1.STEP == 1) or (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 17 and TeachGroup1.STEP == 1)
    if self:_checkBuildingOpen(ISLAND_LEFT_SURVEY) and isTeach ~= true then
        local url = CacheCenter:getGameParam()["surveyUrl"]
        WZLog("WndOwnCity:onClickSurvey:", url)
        url = url or "https://docs.google.com/forms/d/e/1FAIpQLSeI-PjtcMoDOEyFY872EG3tptNcn04CJrX0AOW2V_Oo8bj0zw/viewform?usp=sf_link"
        WZPush:openURL(url)
    end
end

--@brief    点击FB按钮后的响应方法
--@param    element:按钮的UI节点引用
--@note 在这里做相应的按钮相应事件
function WndOwnCity:onClickFb(element)
    WZLog("WndOwnCity:onClickFb")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    local isTeach = (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 15 and TeachGroup1.STEP == 1) or (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 17 and TeachGroup1.STEP == 1)
    if self:_checkBuildingOpen(ISLAND_LEFT_FB) and isTeach ~= true then
        local url = "https://www.facebook.com/bombman.hero"
        if ProjConfig.LANGUAGE == "th" then
            url = "https://www.facebook.com/bombman.th"
        end
        local packageName = WGameCmUtil:GetBundleIdentifier()
        if packageName == "com.wyd.gunpow" then
            url = "https://www.facebook.com/gunpow.360game.vn"
        elseif packageName == "com.wyd.gplay.bombheroes" or packageName == "com.wyd.brgp.bombheroes" 
            or packageName == "com.wyd.tcl.bombheroes" or packageName == "com.wyd.samsung.bombheroes" 
            or packageName == "com.wyd.samsungbr.bombheroes" or packageName == "com.ios.rwt.bombcrash" then
            url = "https://www.facebook.com/bombheroes"
            if ProjConfig.LANGUAGE == "en" then
                url = "https://goo.gl/juMMYc"
            elseif ProjConfig.LANGUAGE == "pt" then
                url = "https://goo.gl/q7kRjE"
            elseif ProjConfig.LANGUAGE == "es" then
                url = "https://goo.gl/MNPhgX"
            end
        elseif packageName == "com.wyd.appstore.bombheroes" or packageName == "com.wyd.gplay.bombheroesen" 
            or packageName == "com.wyd.gplay.heroibomba" or packageName == "com.edo.ios.Ihabombom" then
            url = "https://www.facebook.com/bombheroes"
        elseif packageName == "com.ios.jt.bombboombang" or packageName == "com.ios.edo.bomb"  then
            url = "https://www.facebook.com/bombheroes"
        elseif packageName == "com.ios.jt.bombgala" or packageName == "com.ios.rwt.bomberclash" 
            or packageName == "com.ios.jt.bombmonster" or packageName == "com.ios.jt.bouncelegends" 
            or packageName == "com.ios.jt.bouncingchurch" or packageName == "com.ios.jt.bombcyclone" 
            or packageName == "com.ios.jt.shootertribe" or packageName == "com.DDBom.b" 
            or packageName == "com.mh.jl" or packageName == "com.ios.jt.secrettreasure"  
            or packageName == "dd.pd.cr" or packageName == "com.ios.jt.projectilefiring" 
             or packageName == "com.ios.jt.mysteriousland" or packageName == "com.ios.jt.galgun" then
            url = "https://www.facebook.com/bombheroes"
        elseif packageName == "com.ios.rwt.bombcrash" then
            url = "https://www.facebook.com/bombheroes"
        elseif packageName == "com.letui.doombomb" then
            url = "https://www.facebook.com/bombheroes"
        elseif packageName == "com.bombman.omgEU" or packageName == "com.bombman.omg" then
             url = "https://www.facebook.com/ChibiBomber"
        elseif packageName == "com.tutu.chibibomberios" then
             url = "https://www.facebook.com/ChibiBomber"
         elseif packageName == "com.tutu.chibibomberandroid" then
             url = "https://www.facebook.com/ChibiBomber"
        elseif packageName == "com.bombmaster.mg" or packageName == "com.sao.ios.bmmj" or packageName == "com.sfrz.ddd" 
            or packageName == "com.ddd.haiwai" or packageName == "com.overseas.dan" then
            url = "https://www.facebook.com/theBombMaster"
        end
        WZLog("rrrrrrrrrr:",url)
        --WndActivities:showView()
        --WndActivities:_setActivityUrl(url)
        WZPush:openURL(url)
    end
    
end


--@brief    点击FB按钮后的响应方法
--@param    element:按钮的UI节点引用
--@note 在这里做相应的按钮相应事件
function WndOwnCity:onClickGroup(element)
    WZLog("WndOwnCity:onClickGroup")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    local isTeach = (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 15 and TeachGroup1.STEP == 1) or (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 17 and TeachGroup1.STEP == 1)
    if self:_checkBuildingOpen(ISLAND_LEFT_GROUP) and isTeach ~= true then
        local url = "https://www.facebook.com/groups/1690069517950035/?__mref=message_bubble"
        WZLog("rrrrrrrrrr:",url)
        --WndActivities:showView()
        --WndActivities:_setActivityUrl(url)
        WZPush:openURL(url)
    end
    
end

--@brief	点击头像按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note	在这里做相应的按钮相应事件
function WndOwnCity:onClickFigure(element)
	WZLog("WndOwnCity:onClickFigure")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    if WindowManager:isHaveTeachTouchLayer() == true or WndTeachTalk.m_root ~= nil then
        return
    end
    
	WndCheckOther:show(tonumber(CacheCenter:getPlayerInfo().id))
end

--@brief	点击邮件按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note	在这里做相应的按钮相应事件
function WndOwnCity:onClickMail(element)
    WZLog("点击邮件图标WndOwnCity:onClickMail")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    if CheckButtonOpen(ISLAND_LEFT_MAIL) then
        WndMail:showMail()
    end

end

--@brief  点击活动
function WndOwnCity:onClickGameActivity( element )
    WZLog("WndOwnCity:onClickGameActivity")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    local isTeach = (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 24 and TeachGroup1.STEP == 1) or (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 29 and TeachGroup1.STEP == 1) or (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 1 and TeachGroup1.STEP == 2)
    if CheckButtonOpen(ISLAND_UP_EVENT) and isTeach ~= true then
        GlobalGame.g_autoGameActivity = false
        WndActivityIntegrate:showInterface(2)
    end
end

--@brief	点击VIP按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note	在这里做相应的按钮相应事件
function WndOwnCity:onClickVip(element)
    WZLog("WndOwnCity:onClickVip")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

   local isTeach = (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 43) 

    if CheckButtonOpen(ISLAND_UP_RECHARGE) and isTeach ~= true then
        DataUUtil("OL_Island_HuiYuan","")
        CheckLuaLoad(LUAFILES_BLOCK_COMMON)
        CheckLuaLoad(Chat_Channel_vip)
        g_payEventId = -1
        PostPlayerEvent:postEvent(PostPlayerEvent.event_payStep2,-1) 
        WndVip:showWndUI(0)       
    end
end

--@brief    点击七天乐按钮后的响应方法
--@param    element:按钮的UI节点引用
--@note 在这里做相应的按钮相应事件
function WndOwnCity:onClickSevenDay(element)
    WZLog("WndOwnCity:onClickSevenDay")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    local isTeach = (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 43) 

    if CheckButtonOpen(ISLAND_UP_SEVEN_DAY) and isTeach ~= true then
        self:_postSevenDayEvent()
        WndSevenDayActivity:showInterface()
    end
end

function WndOwnCity:onClickBless(element)
    WZLog("WndOwnCity:onClickBless")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    if CheckButtonOpen(ISLAND_UP_BLESS) then
        WndSummonEntrance:showInterface(3)
    end

end

--@brief    点击MTO按钮后的响应方法
function WndOwnCity:onClickMTO(element)
    WZLog("WndOwnCity:onClickMTO")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    local isTeach = (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 24 and TeachGroup1.STEP == 1) or (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 1 and TeachGroup1.STEP == 2)
    if true then --CheckButtonOpen(ISLAND_UP_MTO) and isTeach ~= true then
      local postData = {}
      postData.funType = "showWebView"
      local playInfo = CacheCenter:getPlayerInfo()
      postData.serverID = IPDhttpServer:getCurServerId()     --服务器id
      if playInfo  then
        postData.guildName = playInfo.guildName
        postData.vipLevel = playInfo.vipLevel
        postData.roleName = playInfo.name
        postData.roleId = playInfo.id 
        postData.roleLevel = playInfo.level
      end
      PassportSdkManager:Others(postData)  

    end
end

--@brief	点击弹王按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note	在这里做相应的按钮相应事件
function WndOwnCity:onClickKing(element)
    WZLog("WndOwnCity:onClickKing")

    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    local isTeach = (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 24 and TeachGroup1.STEP == 1) or (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 1 and TeachGroup1.STEP == 2)

    if CheckButtonOpen(ISLAND_UP_KING) and isTeach ~= true then
        local sceneKingEntrance = SceneKingEntrance:createElement()
        replaceScene(sceneKingEntrance)
    end
end

--@brief	点击月卡按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note	在这里做相应的按钮相应事件
function WndOwnCity:onClickMonth(element)
    WZLog("WndOwnCity:onClickMonth")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
	local wndMonthCards = WndMonthCards:createElement()
	if wndMonthCards ~= nil then
		WindowManager:addWindow( wndMonthCards , WndMonthCards )
	end
end

--@brief    点击好友按钮后的响应方法
--@param    element:按钮的UI节点引用
--@note 在这里做相应的按钮相应事件
function WndOwnCity:onClickFriend(element)
    WZLog("WndOwnCity:onClickFriend")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    local isTeach = (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 15 and TeachGroup1.STEP == 1) or (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 17 and TeachGroup1.STEP == 1)
    if CheckButtonOpen(ISLAND_LEFT_FRIEND) and isTeach ~= true then
        CheckLuaLoad(LUAFILES_BLOCK_COMMON)
        CheckLuaLoad(Chat_Channel_Friend)
        local wndFriends = WndFriends:createElement()
        if wndFriends ~= nil then
            WindowManager:addWindow(wndFriends,WndFriends,nil,false)
        end
    end   
end

--@brief    点击小游戏按钮后的响应方法
--@param    element:按钮的UI节点引用
--@note 在这里做相应的按钮相应事件
function WndOwnCity:onClickSmallGame(element)
    WZLog("WndOwnCity:onClickSmallGame")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    if CheckButtonOpen(ISLAND_UP_YANGLEGEYANG) then
        SceneYangLeGeYang:showInterface()
    end
end

--@brief    点击助手按钮后的响应方法
--@param    element:按钮的UI节点引用
--@note 在这里做相应的按钮相应事件
function WndOwnCity:onClickHelper(element)
    WZLog("WndOwnCity:onClickHelper", PassportSdkManager.showHeoTactic)
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    local isTeach = (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 15 and TeachGroup1.STEP == 1) or (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 17 and TeachGroup1.STEP == 1)
    if isTeach ~= true then
        SceneCity:updateRedDotBuilding("help", false)
        if PassportSdkManager.showHeoTactic then
            local curSdkObj = PassportSdkManager:getCurSdkObj()
            if curSdkObj and curSdkObj.m_tConfig.SDKOtherConfig.needBloc == "true" then
                PassportSdkManager:showHeoTactic()
            else
               MsgBoxManager:showTipBox(LocalStrings.BLOCTIPS)
            end
        end
    end
    
end

--@brief    点击4399按钮后的响应方法
--@param    element:按钮的UI节点引用
--@note 在这里做相应的按钮相应事件
function WndOwnCity:onClick4399(element)
    WZLog("WndOwnCity:onClick4399")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    local isTeach = (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 15 and TeachGroup1.STEP == 1) or (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 17 and TeachGroup1.STEP == 1)
    if CheckButtonOpen(ISLAND_LEFT_4399) and isTeach ~= true then
		WndAdvertising:show4399()
    end
    
end

--@brief    点击公告回调
function WndOwnCity:onClickNotice(element)
    WZLog("WndOwnCity:onClickNotice",element:getTag())
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    if CheckButtonOpen(ISLAND_LEFT_MESSAGE) then
        local title,content = g_gameNoticeInfo.title,g_gameNoticeInfo.content
        if title == nil and content == nil then
            MsgBoxManager:showTipBox(LocalStrings.NO_ANNOUNCE_MES)
            return
        end
        local wndAnnouncement = WndAnnouncement:createElement()
        if wndAnnouncement ~= nil then
            WindowManager:addWindow(wndAnnouncement,WndAnnouncement,nil,false)
        end
    end
   
end

--@brief    点击签到按钮后的响应方法
--@param    element:按钮的UI节点引用
--@note 在这里做相应的按钮相应事件
function WndOwnCity:onClickSingIn(element)
    WZLog("WndOwnCity:onClickSingIn")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    local isTeach = TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 24 and TeachGroup1.STEP == 1
    if CheckButtonOpen(ISLAND_UP_ATTENDANCE) and isTeach ~= true then
        WndGameSingIn.m_bNeedSendProtocol = true  
        local wndGameSingIn = WndGameSingIn:createElement()
        WindowManager:addWindow(wndGameSingIn,WndGameSingIn)
    end
end

--@brief    点击排位赛按钮后的响应方法
--@param    element:按钮的UI节点引用
--@note 在这里做相应的按钮相应事件
function WndOwnCity:onClickQualifying(element)
    WZLog("WndOwnCity:onClickQualifying")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    local isTeach = (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 24 and TeachGroup1.STEP == 1) or (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 29 and TeachGroup1.STEP == 1) or (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 1 and TeachGroup1.STEP == 2)

    if GlobalGame.g_nRankOpenDay == 0 then
        if CheckButtonOpen(ISLAND_UP_QUALIFYING) and isTeach ~= true then
            local scene = ScenePvpRank:createElement()
            replaceScene(scene)
        end
    elseif isTeach ~= true then
        MsgBoxManager:showTipBox(string.format(LocalStrings.MASTEROPENTIPS,GlobalGame.g_nRankOpenDay))
    end
end

--@brief    点击指引按钮后的响应方法
--@param    element:按钮的UI节点引用
--@note 在这里做相应的按钮相应事件
function WndOwnCity:onClickGuide(element)
    WZLog("WndOwnCity:onClickGuide")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    local wndLibrary = WndLibrary:createElement()
    if wndLibrary ~= nil then
        WindowManager:addWindow(wndLibrary,WndLibrary,nil,false)
    end
end

--@brief    点击成长基金按钮后的响应方法
--@param    element:按钮的UI节点引用
--@note 在这里做相应的按钮相应事件
function WndOwnCity:onClickFund(element)
    WZLog("WndOwnCity:onClickFund")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    local isTeach = TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 24 and TeachGroup1.STEP == 1
    if CheckButtonOpen(ISLAND_UP_FUND) and isTeach ~= true then
		-- WndWelfare:showInterface(1, 115)
        WndActivityIntegrate:showInterface(1, 115)
    end
end

--@brief    点击绑定按钮后的响应方法
--@param    element:按钮的UI节点引用
--@note 在这里做相应的按钮相应事件
function WndOwnCity:onClickBinding(element)
    WZLog("WndOwnCity:onClickBinding")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    local isTeach = (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 29 and TeachGroup1.STEP == 1) or (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 1 and TeachGroup1.STEP == 2)
    if ProjConfig.LANGUAGE == "vn" then
        DoTouristsVn()
        return
    end
    if CheckButtonOpen(ISLAND_UP_BINDING) and isTeach ~= true then
        local packageName = WGameCmUtil:GetBundleIdentifier()
        if packageName == "com.bombman.omgEU" or packageName == "com.bombman.omg" or  
            packageName == "com.bombmaster.mg" or packageName == "com.sao.ios.bmmj" or 
            packageName == "com.sfrz.ddd" or packageName == "com.ddd.haiwai" or 
            packageName == "com.overseas.dan" then
            --ProtocolProcessorAccount:send_ACCOUNT_Register("wyd001","123456","")
            MsgBoxManager:showConfirmBox(LocalStrings.FB_ACCOUNT_TIP1, WndOwnCity,self.bindFacebookAccount)   
            return
        end
        WndBindAccount:showWndUI()
    end
end

function WndOwnCity:bindFacebookAccount(element)
   local sdkTab = {}
    sdkTab.funType = "bindFacebookAccount"
    PassportSdkManager:Others(sdkTab)
end

--@brief    点击设置按钮后的响应方法
--@param    element:按钮的UI节点引用
--@note 在这里做相应的按钮相应事件
function WndOwnCity:onClickSet(element)
    WZLog("WndOwnCity:onClickSet")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    local isTeach = TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 17 and TeachGroup1.STEP == 1
    if CheckButtonOpen(ISLAND_LEFT_SETTING) and isTeach ~= true then
        local wndSettingElement = WndSetting:createElement()
        WindowManager:addWindow( wndSettingElement , WndSetting )
    end
end

--@brief	查看玩家信息按钮
function WndOwnCity:onClickInfo(element)
    WZLog("WndOwnCity:onClickInfo", self.m_nOtherId)
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    WndCheckOther:show(self.m_nOtherId)
end

--@brief	爱心点击回调
function WndOwnCity:onClickLove(element)
    WZLog("WndOwnCity:onClickLove")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    if CheckButtonOpen(ISLAND_BUILDING_LOTTERY) then
        local wnd = WndLoveLottery:createElement()
        WindowManager:addWindow( wnd ,WndLoveLottery,true)
    end
end

--@brief	首冲回调
function WndOwnCity:onClickFirstRecharge(element)
    WZLog("WndOwnCity:onClickFirstRecharge")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    local isTeach = (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 24 and 
        TeachGroup1.STEP == 1) or 
    (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 1 and TeachGroup1.STEP == 2)
     or 
    (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP)

    if CheckButtonOpen(ISLAND_UP_FIRST_RECHARGE) and isTeach ~= true then
        local wnd = CellRechargePanelActivity:createElement()
        WindowManager:addWindow(wnd, CellRechargePanelActivity, true)
    end
end

--@brief	月卡回调
function WndOwnCity:onClickMonthCard(element)
    WZLog("WndOwnCity:onClickMonthCard")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    local isTeach = (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 24 and TeachGroup1.STEP == 1) or (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 1 and TeachGroup1.STEP == 2)


    if CheckButtonOpen(ISLAND_UP_MONTHCARD) and isTeach ~= true then
        -- WndGameActivity:showInterface(143)
        WndActivityIntegrate:showInterface(2, 143)
    end
end

--@brief    点击魅力空间按钮后的响应方法
function WndOwnCity:onClickCharm(element)
    WZLog("WndOwnCity:onClickCharm")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    local isTeach = TeachGroup1.ISTEACH == true and 
        (TeachGroup1.GROUP == 43)
    if CheckButtonOpen(ISLAND_EXTEND_CHARM) and isTeach ~= true then
        WndCharmSpace:showInterface(1)
    end
end

--@brief    人物升级后更新左菜单
function WndOwnCity:updateForUpgrade()
    if self.m_root == nil then
        return
    end
    
    local bUpdateFlag = false --是否更新，仅当有新功能开放时才更新
    if self.m_tBtnsInfo and CacheCenter:getPlayerInfo().level <= 99 then
        for i,v in ipairs(self.m_tBtnsInfo) do
            if v.buttonStatus3Level == CacheCenter:getPlayerInfo().level and checkbuttonChannel(v.buttonChannel) then
                bUpdateFlag = true
                break
            end
        end
    end
    if bUpdateFlag then
        WZLog("_update_update_update_update_update 111")
        self:_update()
    end
end

--@brief	比赛点击回调
function WndOwnCity:onClickMatch(element)
    WZLog("WndOwnCity:onClickMatch")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    local isTeach = (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 24 and TeachGroup1.STEP == 1) or 
    (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 29 and TeachGroup1.STEP == 1) or 
    (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 1 and TeachGroup1.STEP == 2) or 
    (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 16 and TeachGroup1.STEP == 1)
    if CheckButtonOpen(ISLAND_UP_MATCH) and isTeach ~= true then
        -- WndWelfare:showInterface(2)
        WndActivityIntegrate:showInterface(3)
    end
end

--@brief	福利点击回调
function WndOwnCity:onClickWelfare(element)
    WZLog("WndOwnCity:onClickWelfare")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    --self:updateFirstRecharge(false)
    local isTeach = (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 16 and TeachGroup1.STEP == 1)
    if CheckButtonOpen(ISLAND_UP_WELFARE) and isTeach ~= true then
        -- WndWelfare:showInterface(1)
        WndActivityIntegrate:showInterface(1)
        
        WndOwnCity.m_bIsClickWelfare = true
    end

    --福利按钮
    local btn = GetElementWithoutAssert(self.m_root, "btn"..ISLAND_UP_WELFARE.."_WndOwnCity", WZUIButton)
    if btn then
        if CacheCenter.m_tWelfareItemRedDotList and #CacheCenter.m_tWelfareItemRedDotList == 0 and CacheCenter:getPlayerItemCountById(116) < 10 then 
            SceneCity:setRedPoint(btn,false)
            WZLog("WndOwnCity:onClickWelfare two")
        end
    end
end

--@brief    永久福利卡点击回调
function WndOwnCity:onClickCardWelfare(element)
    WZLog("WndOwnCity:onClickCardWelfare")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    if CheckButtonOpen(ISLAND_UP_CARD_WELFARE) then
        WndActivityIntegrate:showInterface(1, 999997)
    end
end

--@brief    一元充活动点击回调
function WndOwnCity:onClickOneYuan(element)
    WZLog("WndOwnCity:onClickOneYuan")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    if CheckButtonOpen(ISLAND_UP_ONE_YUAN) then
        WndOneRechargeActivity:showInterface()
    end
end
--@brief    七夕活动点击回调
function WndOwnCity:onClickDoubleSeven(element)
    WZLog("WndOwnCity:onClickOneYuan")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    if CheckButtonOpen(DOUBLE_SEVEN_CONFREE) then
        WndDoubleSeven:showInterface()
    end
end
--@brief    国庆签到点击回调
function WndOwnCity:onClickNationalFestival(element)
    WZLog("WndOwnCity:onClickOneYuan")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    if CheckButtonOpen(NATIONAL_FESTIVAL) then
        WndNationalFestival:showInterface()
    end
end
--@brief    答题点击回调
function WndOwnCity:onClickNationalAnswer(element)
    WZLog("WndOwnCity:onClickOneYuan")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    if CheckButtonOpen(NATIONAL_ANSWER) then
        WndNationalAnswer:showInterface()
    end
end
--@brief    全民购物点击回调
function WndOwnCity:onClickPeopleShop(element)
    WZLog("WndOwnCity:onClickPeopleShop")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    if CheckButtonOpen(PEOPLESHOP) then
        WndPeopleShop:showInterface()
    end
end
--寻宝
function WndOwnCity:onClickTreasureSerach()
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    if CheckButtonOpen(TREASURESEARCH) then
        WndTreasure:showInterface()
    end
end
--每日必购
function WndOwnCity:onClickEveryDayBuy()
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    if CheckButtonOpen(EVERYDAYBUY) then
        WndEveryDayBuy:showInterface()
    end
end
--元旦
function WndOwnCity:onClickNerYearDay()
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    if CheckButtonOpen(NEWYEARDAY) then
        WndNewYearMain:showInterface()
    end
end
--新年活动
function WndOwnCity:onClickEveryFebruaryNewYear()
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    if CheckButtonOpen(FEBRUARYNEWYEAR) then
        WndNewYearActivityMain:showInterface()
    end
end
--四象星宿
function WndOwnCity:onClickFourStar()
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    WndFourStar:showInterface()
end
--盲盒
function WndOwnCity:onClickBlindBox()
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    WndBlind:showInterface()
end
--娃娃机
function WndOwnCity:onClickDollMachine()
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    WndDollMachine:showInterface()
end
--限时登录
function WndOwnCity:onClickLimitLogin()
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    WndActivityLimitLogin:showInterface()
end
--新首冲
function WndOwnCity:onClickNewRecharge()
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    WndFirstReCharge:showInterface()
end
--回归活动
function WndOwnCity:onClickRebackActivity()
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    WndReturnActivityMain:showInterface()
end
function WndOwnCity:onClickFightActivity()
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    WndFightActivity:showInterface()
end

function WndOwnCity:onClickFightActivity1()
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    WndFightActivity1:showInterface()
end

function WndOwnCity:onClickFightActivity2()
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    WndFightActivity2:showInterface()
end

--@brief    点击射箭活动入口回调
function WndOwnCity:onClickShootArrow(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    if CheckButtonOpen(ACTIVITY_SHOOT_ARROW) then
        WndShootArrow:showInterface()
    end
end
--崛起之路
function WndOwnCity:onClickRiseActivity(element)
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    WndRiseMainActivity:showInterface()
end
--占星
function WndOwnCity:onClickHoraryActivity(element)
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    WndMainHorary:showInterface()
end
--中秋活动
function WndOwnCity:onClickMidFestivalActivity()
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    WndMidFestivalActivity:showInterface()
end
--钓鱼活动
function WndOwnCity:onClickFishActivity()
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    WndFishMain:showInterface()
end
function WndOwnCity:onClickPelletActivity()
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    WndPelletMain:showInterface()
end
function WndOwnCity:onClickHouseInvestActivity()
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    WndHouseMain:showInterface()
end

--@brief    点击水之国度按钮回调
function WndOwnCity:onClickWaterCountry(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndWaterCountry:showInterface()
end

--@brief    点击张灯结彩按钮回调
function WndOwnCity:onClickDecorations(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndDecorations:showInterface()
end

--@brief    点击年兽大作战按钮回调
function WndOwnCity:onClickYearMonster(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndYearMonster:showInterface()
end

--@brief    点击新年愿望按钮回调
function WndOwnCity:onClickNewYearWish(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndNewYearWish:showInterface()
end

--@brief    点击暴揍策划按钮回调
function WndOwnCity:onClickBeatEngineer(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndBeatEngineer:showInterface()
end

--@brief    点击英雄联赛按钮回调
function WndOwnCity:onClickLeague(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if CheckButtonOpen(71) then
        SceneLeagueMain:show()
    end
end

--@brief    点击丹道修真按钮回调
function WndOwnCity:onClickAlchemy(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndAlchemy:showInterface()
end

--@brief    点击欢乐地鼠按钮回调
function WndOwnCity:onClickBeatMice(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndBeatMice:showInterface()
end

--@brief    点击蓝钻特权按钮回调
function WndOwnCity:onClickBluePrivilege(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndBluePrivilege:showInterface()
end

--@brief    点击大厅特权按钮回调
function WndOwnCity:onClickQQHallPrivilege(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndLobbyPrivilegesAct:showInterface()
end

--@brief    点击套圈圈按钮回调
function WndOwnCity:onClickSetCircle(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndSetCircle:showInterface()
end

--@brief    点击小岛果园按钮回调
function WndOwnCity:onClickGarden(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndGarden:showInterface()
end

--@brief    点击咖啡大师按钮回调
function WndOwnCity:onClickCaffee(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndCaffee:showInterface()
end

--@brief    点击保龄球按钮回调
function WndOwnCity:onClickBowling(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndBowling:showInterface()
end

--@brief    点击年度玩家按钮回调
function WndOwnCity:onClickYearPlayer(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndYearPlayer:showInterface()
end

--@brief    点击年度玩家按钮回调
function WndOwnCity:onClickWatermelon(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndWatermelon:showInterface()
end

--@brief    点击秘境闯塔按钮回调
function WndOwnCity:onClickSecretTower(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndSecretTower:showInterface()
end

--@brief    点击摇钱树按钮回调
function WndOwnCity:onClickMoneyTree(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if g_cityExtenInfo.activity7054 == nil or g_cityExtenInfo.activity7054 == 0 then 
        MsgBoxManager:showTipBox(LocalStrings.MONEYTREE_TEXT1[11])
        return 
    end
    WndMoneyTree:showInterface()
end

--@brief    点击台无止境按钮回调
function WndOwnCity:onClickBilliardBall(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndBilliardBall:showInterface()
end

--@brief    点击时装惠送按钮回调
function WndOwnCity:onClickDressGive(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndDressGive:showInterface()
end

--@brief    点击疯狂扭蛋按钮回调
function WndOwnCity:onClickCrazyGashapon(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndCrazyGashapon:showInterface()
end

--@brief    点击深夜食堂按钮回调
function WndOwnCity:onClickMidnightDiner(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndMidnightDiner:showInterface()
end

--@brief    点击全垒打按钮回调
function WndOwnCity:onClickGopherBall(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndGopherBall:showInterface()
end

--@brief    点击新萌榜按钮回调
function WndOwnCity:onClickNewCuteList(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndNewCuteList:showInterface()
end

--@brief    点击修仙传按钮回调
function WndOwnCity:onClickBeingImmortal(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndBeingImmortal:showInterface()
end

--@brief    点击拜财神按钮回调
function WndOwnCity:onClickWorshipGod(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndWorshipGod:showInterface()
end

--@brief    点击葫芦娃按钮回调
function WndOwnCity:onClickCalabash(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndCalabash:showInterface()
end

--@brief    点击春游踏青按钮回调
function WndOwnCity:onClickSpringOuting(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndSpringOuting:showInterface()
end

--@brief    点击感恩打卡按钮回调
function WndOwnCity:onClickThankfulSign(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndThankfulSign:showInterface(2)
end

--@brief    点击欢迎回来按钮回调
function WndOwnCity:onClickWelcomeBack(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndWelcomeBackActivity:showInterface(2)
end

--@brief    点击打气球按钮回调
function WndOwnCity:onClickBeatBalloon(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndBeatBalloon:showInterface()
end

--@brief    点击耀眼榜按钮回调
function WndOwnCity:onClickDazzleRank(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndDazzleRank:showInterface()
end

--@brief    点击超值特购按钮回调
function WndOwnCity:onClickSuperSpecial(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSuperSpecialActivity:showInterface()
end

--@brief    点击组团消费按钮回调
function WndOwnCity:onClickTeamConsume(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndTeamConsume:showInterface()
end

--@brief    点击航海之路按钮回调
function WndOwnCity:onClickSeafarRoad(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndSeafarRoad:showInterface()
end

--@brief    点击爬藤比赛按钮回调
function WndOwnCity:onClickClimbTree(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndClimbTree:showInterface()
end

--@brief    点击夏日冲浪按钮回调
function WndOwnCity:onClickSummerSurf(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndSummerSurf:showInterface()
end

--@brief    点击行星搜索按钮回调
function WndOwnCity:onClickPlanetSearch(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndPlanetSearch:showInterface()
end

--@brief    点击七周年签到按钮回调
function WndOwnCity:onClickSevenYear(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndSevenYear:showInterface()
end

--@brief    点击粽有不同按钮回调
function WndOwnCity:onClickZongZi(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndZongZi:showInterface()
end

--@brief    点击限定活动[7080][90]
function WndOwnCity:onClickSpecificSales(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    -- WZResourceManager:getInstance():executeLuaFile("newActivity/WndActivitySpecificSales.lua")
    -- WZResourceManager:getInstance():executeLuaFile("protocol/ProtocolProcessorWndActivityOnLine.lua")
    -- WZResourceManager:getInstance():executeLuaFile("protocol/ProtocolProcessorRedPack.lua")
    -- WZResourceManager:getInstance():executeLuaFile("protocol/ProtocolProcessorFestivalActivity.lua")
    -- WZResourceManager:getInstance():executeLuaFile("LocalStrings.lua")
    -- WZResourceManager:getInstance():executeLuaFile("LocalData6.lua")
    WndActivitySpecificSales:showInterface()
end

--@brief    点击欢乐蹦床按钮回调
function WndOwnCity:onClickTrampoline(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndTrampoline:showInterface()
end

--@brief    点击高尔夫赛事按钮回调
function WndOwnCity:onClickGolfball(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndGolfball:showInterface()
end

--@brief    点击许愿瓶按钮回调
function WndOwnCity:onClickWishingBottle(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndWishingBottle:showInterface()
end

--@brief    点击贝克侦探所按钮回调
function WndOwnCity:onClickDetective(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndDetective:showInterface()
end

--@brief    点击捕魚大王按钮回调
function WndOwnCity:onClickCatchFish(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndCatchFish:showInterface()
end

--@brief    点击8周年庆典按钮回调
function WndOwnCity:onClickEightYear(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    WndEightYear:showInterface()
end

--@brief    点击清凉冰饮按钮回调
function WndOwnCity:onClickColdDrink(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndColdDrink:showInterface()
end

--@brief    点击射门大战按钮回调
function WndOwnCity:onClickFootballShoot(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndFootballShooting:showInterface()
end

--@brief    点击成长礼包按钮回调
function WndOwnCity:onClickGrowGift(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndGrowGiftActivity:showInterface()
end

--@brief    点击欢度中秋按钮回调
function WndOwnCity:onClickHappyMidAutumn(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndHappyMidAutumn:showInterface()
end

--@brief    点击周末特惠按钮回调
function WndOwnCity:onClickWeekendSpecial(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndWeekendSpecial:showInterface()
end

--@brief    点击周末特惠按钮回调
function WndOwnCity:onClickWeekendSpecial2(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndWeekendSpecial2:showInterface()
end

--@brief    点击双11神秘商店按钮回调
function WndOwnCity:onClickMysteriousShop(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndMysteriousShop:showInterface()
end

--@brief    点击动物园观光按钮回调
function WndOwnCity:onClickZooSightseeing(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndZooSightseeing:showInterface()
end

--@brief    点击锣鼓喧天按钮回调
function WndOwnCity:onClickGongAndDrum(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndGongAndDrum:showInterface()
end

--@brief    点击黄金矿工按钮回调
function WndOwnCity:onClickGoldMiner(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndGoldMiner:showInterface()
end

--@brief    点击深海寻宝按钮回调
function WndOwnCity:onClickDeepSea(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndDeepSea:showInterface()
end

--@brief    点击奕仙棋按钮回调
function WndOwnCity:onClickChess(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndChessActivities:showInterface()
end

--@brief    点击秋日露营按钮回调
function WndOwnCity:onClickAutumnCamp(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndAutumnCamp:showInterface()
end

--@brief    点击热血篮球按钮回调
function WndOwnCity:onClickHotBasketball(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndHotBasketball:showInterface()
end

--@brief    点击放风筝按钮回调
function WndOwnCity:onClickFlyKites(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndFlyKites:showInterface()
end

--@brief    点击投壺按钮回调
function WndOwnCity:onClickThrowPot(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndThrowPot:showInterface()
end

--@brief    点击捕魚大王按钮回调
function WndOwnCity:onClickCatchFish(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndCatchFish:showInterface()
end

--@brief    点击自行车赛按钮回调
function WndOwnCity:onClickBikeMatch(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndBikeMatch:showInterface()
end

--@brief    点击抽陀螺按钮回调
function WndOwnCity:onClickLashTop(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndLashTop:showInterface()
end

--@brief    点击福兔送礼按钮回调
function WndOwnCity:onClickRabbitGift(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndRabbitGift:showInterface()
end

--@brief    点击幸运翻牌按钮回调
function WndOwnCity:onClickLuckyFlip(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndLuckyFlip:showInterface()
end

--@brief    点击勇闯高塔按钮回调
function WndOwnCity:onClickBravingTower(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndBravingTower:showInterface()
end

--@brief    点击踢毽子按钮回调
function WndOwnCity:onClickKickingBirdie(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndKickingBirdie:showInterface()
end

--@brief    点击魔法学院按钮回调
function WndOwnCity:onClickMagicClassroom(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndMagicClassroom:showInterface()
end

--@brief    点击堆雪人按钮回调
function WndOwnCity:onClickMakeSnowman(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndMakeSnowman:showInterface()
end

--@brief    点击钢琴演奏家按钮回调
function WndOwnCity:onClickPianist(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndPianist:showInterface()
end

--@brief    点击陶艺工坊按钮回调
function WndOwnCity:onClickCeramicWorkshop(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndCeramicWorkshop:showInterface()
end

--@brief    点击举重比赛按钮回调
function WndOwnCity:onClickWeightlifting(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndWeightlifting:showInterface()
end

--@brief    点击极地探险按钮回调
function WndOwnCity:onClickArcticExploration(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndArcticExploration:showInterface()
end

--@brief    点击拼装积木按钮回调
function WndOwnCity:onClickBuildingBlocks(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndBuildingBlocks:showInterface()
end

--@brief    点击铸剑神匠按钮回调
function WndOwnCity:onClickSwordCastingMaster(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSwordCastingMaster:showInterface()
end
--@brief    点击采茶按钮回调
function WndOwnCity:onClickPickTea(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndPickTea:showInterface()
end

--@brief    点击泛舟游湖按钮回调
function WndOwnCity:onClickBoatingLake(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndBoatingLake:showInterface()
end

--@brief    点击吹泡泡按钮回调
function WndOwnCity:onClickBlowBubbles(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndBlowBubbles:showInterface()
end

--@brief    点击植树造林按钮回调
function WndOwnCity:onClickAfforestation(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndAfforestation:showInterface()
end

--@brief    点击魔药炼制按钮回调
function WndOwnCity:onClickPotionsRefinin(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndPotionsRefining:showInterface()
end

--@brief    点击首饰大师按钮回调
function WndOwnCity:onClickJewelry(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndJewelry:showInterface()
end

--@brief    检查戒指
function WndOwnCity:checkRings(equipList)
    if equipList[3] == nil then
        return 3
    elseif equipList[4] == nil then
        return 4
    end
    return 3
end

--@brief    更新左菜单UI界面
function WndOwnCity:getActiveInfo(awardId, awardStatus)

    WZLog("WndOwnCity:getActiveInfo one", tostring(self.m_root))
    if true or self.m_root == nil then
        return
    end

    local isActive
    for i,v in pairs (awardStatus) do
        WZLog("WndOwnCity:getActiveInfo two",i,v)
        if v == "0" then
            WZLog("WndOwnCity:getActiveInfo three")
            isActive = true
        end

    end

    local btn = GetElementWithoutAssert(self.m_root, "btn20_WndOwnCity", WZUIButton)
    if btn then
        if isActive then
            SceneCity:setRedPoint(btn,true,GlobalMethod:ccp(83,83))
            WZLog("WndOwnCity:getActiveInfo four")
        else
            SceneCity:setRedPoint(btn,false)
            if GlobalGame.g_tRedPointList.activity then
                GlobalGame.g_tRedPointList.activity = nil
                ProtocolProcessorSceneCity:send_PLAYER_CancelRedDot(78)
            end
            WZLog("WndOwnCity:getActiveInfo five")
        end
    end

end

--@brief    隐藏绑定
function WndOwnCity:hideBinding()
    if self.m_root and GetElement(self.m_root, "con55_WndOwnCity", WZUIContainer) then
        local bind = GetElement(self.m_root, "con55_WndOwnCity", WZUIContainer)
        bind:setVisible(false)
        for i, v in ipairs (self.m_tBtnList) do
            if bind == v then
                table.remove(self.m_tBtnList, i)
                local flcBtns = GetElement(self.m_root, "flcBtns_WndOwnCity", WZUIFreeListContainer)
                flcBtns:removeAt(i-1)
                break
            end
        end
    end
end

--@brief    更新永久卡
function WndOwnCity:updateCardWelfare()
    WZLog("WndOwnCity:updateCardWelfare")
    if self.m_root == nil then
        return
    end

    WZLog("WndOwnCity:_createIconButton three-2", tostring(CacheCenter:getPlayerItemById(50)), tostring(CacheCenter:getPlayerItemById(52)), tostring(CacheCenter:getPlayerItemById(55)), tostring(CacheCenter:getPlayerItemById(56)))

    if CacheCenter:getPlayerItemById(50) == nil or CacheCenter:getPlayerItemById(52) == nil or 
        CacheCenter:getPlayerItemById(55) == nil or CacheCenter:getPlayerItemById(56) == nil then
        if self.m_tArmatureCardWelfare then
            self.m_tArmatureCardWelfare:setVisible(true)
            self.m_tArmatureCardWelfare2:setVisible(true)
        end
    else
        if self.m_tArmatureCardWelfare then
            self.m_tArmatureCardWelfare:setVisible(false)
            self.m_tArmatureCardWelfare2:setVisible(false)
        end
    end
    
end

--@brief    更新基金开放红点
function WndOwnCity:updateFundOpen(isOpen)
    if self.m_root == nil or self.m_tBtnList == nil then
        WZLog("WndOwnCity:updateFundOpen0")
        return
    end

    local con = GetElement(self.m_root, "con19_WndOwnCity", WZUIContainer)
    WZLog("WndOwnCity:updateFundOpen1", isOpen, con)
    if con then
        local armature = GetElement(con, "armaFirstRechangeNormal_WndOwnCity")
        WZLog("WndOwnCity:updateFundOpen2", isOpen, armature)
        if isOpen and armature == nil then
            local anim = BattleAnimation:createAnimation("ui_main_iconeffect", false, "city")
            local armature = anim.m_node
            armature:setName("armaFirstRechangeNormal_WndOwnCity")
            armature:setUseOriginSize(true)
            armature:setAnchorPoint(GlobalMethod:ccp(0.5,yArma))
            armature:setTouchEnable(false)
            armature:setAnimationName("animation")
            armature:setLoop(true)
            GetElement(con, "conNormal_WndOwnCity", WZUIContainer):addChild(armature)
            GetElement(con, "conNormal_WndOwnCity", WZUIContainer):setZOrder(2)

            local anim = BattleAnimation:createAnimation("ui_main_iconeffect", false, "city")
            local armature = anim.m_node
            armature:setName("armaFirseRechangeSel_WndOwnCity")
            armature:setUseOriginSize(true)
            armature:setAnchorPoint(GlobalMethod:ccp(0.5,yArma))
            armature:setTouchEnable(false)
            armature:setAnimationName("animation")
            armature:setLoop(true)
            GetElement(con, "conSel_WndOwnCity", WZUIContainer):addChild(armature)
            GetElement(con, "conSel_WndOwnCity", WZUIContainer):setZOrder(2)
        elseif isOpen == false and armature ~= nil then
            armature:removeFromParentAndCleanup(true)
            local armature2 = GetElement(con, "armaFirseRechangeSel_WndOwnCity")
            armature2:removeFromParentAndCleanup(true)
        end
    end

end

--@brief    更新精英商城
function WndOwnCity:updateEliteShopAndHelpAndShare()
    WZLog("WndOwnCity:updateEliteShopAndHelpAndShare", g_bloc_shop, g_bloc_tactic, g_bloc_spread, g_bloc_pray)
    if IsNewHeroControl() and SceneCity.m_root then
        SceneCity.m_tWndBottomBarObj:_update()
        WndOwnCity:updateEliteShop()
        WndOwnCity:updatePray()
        --WndOwnCity:updateHelp()
    end
    
end

--@brief    更新精英商城
function WndOwnCity:updateEliteShop()
    WZLog("WndOwnCity:updateEliteShop zero", tostring(self.m_root), tostring(self.m_tBtnList))
    if self.m_root == nil or self.m_tBtnList == nil then
        return
    end

    local isOpen = CheckButtonOpen(103, false) and g_bloc_shop == "true"
    local conFirst = GetElement(self.m_root, "con103_WndOwnCity", WZUIContainer)
    WZLog("WndOwnCity:updateEliteShop one", tostring(isOpen), tostring(conFirst))
    if isOpen then
        if conFirst == nil then
            local flcBtns = GetElement(self.m_root, "flcBtns_WndOwnCity", WZUIFreeListContainer)
            local conBtn = self:_createIconButton(ISLAND_UP_ELITE_SHOP, false)
            flcBtns:pushBack(conBtn)
            conBtn.btnId = ISLAND_UP_ELITE_SHOP
            table.insert(self.m_tBtnList, conBtn)
            self.m_nIndex = self.m_nIndex + 1
        else
            conFirst:setVisible(true)
        end
    end
end

--@brief    更新祈愿
function WndOwnCity:updatePray()
    WZLog("WndOwnCity:updatePray zero", tostring(self.m_root), tostring(self.m_tBtnList))
    if self.m_root == nil or self.m_tBtnList == nil then
        return
    end

    local isOpen = CheckButtonOpen(103, false) and g_bloc_pray == "true"
    local conFirst = GetElement(self.m_root, "con138_WndOwnCity", WZUIContainer)
    WZLog("WndOwnCity:updatePray one", tostring(isOpen), tostring(conFirst))
    if isOpen then
        if conFirst == nil then
            local flcBtns = GetElement(self.m_root, "flcBtns_WndOwnCity", WZUIFreeListContainer)
            local conBtn = self:_createIconButton(ISLAND_UP_PRAY, false)
            flcBtns:pushBack(conBtn)
            conBtn.btnId = ISLAND_UP_PRAY
            table.insert(self.m_tBtnList, conBtn)
            self.m_nIndex = self.m_nIndex + 1
        else
            conFirst:setVisible(true)
        end
    end
end

local btnIndex =
{
    [ISLAND_LEFT_MESSAGE] = "Notice",
    [ISLAND_LEFT_MAIL] = "Mail",
    [ISLAND_LEFT_FRIEND] = "Friend",
    [ISLAND_LEFT_TEACH] = "Guide",
    [ISLAND_LEFT_SETTING] = "Set",
    [ISLAND_LEFT_HELPER] = "Helper",
    [ISLAND_LEFT_4399] = "4399",
    [ISLAND_LEFT_FB] = "Fb",
}

--@brief    更新助手
function WndOwnCity:updateHelp()
    WZLog("WndOwnCity:updateHelp zero", tostring(self.m_root), tostring(self.m_tBtnList))
    if self.m_root == nil or self.m_tBtnList == nil then
        return
    end

    local nTag = 0
    local offset = 0.037

    -- local id = 0
    for i,v in ipairs(self.m_tLeftBtnsInfo) do
        local conBtn = GetElement(self.m_root, "conBtn"..btnIndex[v.buttonId].."_WndOwnCity", WZUIContainer)
        local isOpen = SceneCity:checkIconButtonOpen(v) and checkbuttonChannel(v.buttonChannel, v.buttonId)

        if v.buttonId == 15 then
            isOpen = false
        end

        if v.buttonId == ISLAND_LEFT_HELPER and IsNewHeroControl() then
            isOpen = isOpen and g_bloc_tactic == "true"
        end

        if conBtn and isOpen then
            conBtn:setVisible(true)
        elseif conBtn then
            conBtn:setVisible(false)
        end
    end
end

--@brief    更新许愿
function WndOwnCity:updateWishWell(isOpen)
    --isOpen = false
    WZLog("WndOwnCity:updateWishWell zero", tostring(self.m_root), tostring(self.m_tBtnList))
    if self.m_root == nil or self.m_tBtnList == nil then
        return
    end

    local conWishWell = GetElement(self.m_root, "con113_WndOwnCity", WZUIContainer)
    WZLog("WndOwnCity:updateWishWell one", tostring(isOpen), tostring(conWishWell:isVisible()))

    if isOpen and conWishWell:isVisible() ~= true then
        conWishWell:setVisible(true)
        self.m_nIndex = self.m_nIndex + 1
    elseif isOpen ~= true and conWishWell:isVisible() == true then
        conWishWell:setVisible(false)
        local index2 = 999
        for i,v in ipairs(self.m_tBtnList) do
            if v.btnId == ISLAND_UP_WISHING_WELL then
                index2 = i
                break
            end
        end
        table.remove(self.m_tBtnList, index2)
        if index2 ~= 999 then
            local flcBtns = GetElement(self.m_root, "flcBtns_WndOwnCity", WZUIFreeListContainer)
            flcBtns:removeAt(index2-1)
        end
        self.m_nIndex = self.m_nIndex - 1
    end
end


--@brief    更新基金
function WndOwnCity:updateFund(isOpen)
    WZLog("WndOwnCity:updateFund zero", tostring(self.m_root), tostring(self.m_tBtnList))
    if self.m_root == nil or self.m_tBtnList == nil then
        return
    end

    local hide_lv = GDatatab_button_info["id_19"].hide_lv
    if hide_lv ~= -1 and CacheCenter:getPlayerInfo().level >= hide_lv then
        return 
    end

    isOpen = isOpen and CheckButtonShow(ISLAND_UP_FUND, true)
    local conWishWell = GetElement(self.m_root, "con19_WndOwnCity", WZUIContainer)
    WZLog("WndOwnCity:updateFund one", tostring(isOpen), tostring(conWishWell))

    if isOpen and (conWishWell == nil or conWishWell:isVisible() ~= true) then
        if conWishWell == nil then
            local flcBtns = GetElement(self.m_root, "flcBtns_WndOwnCity", WZUIFreeListContainer)
            conWishWell = self:_createIconButton(ISLAND_UP_FUND, false)
            flcBtns:pushBack(conWishWell)
            conWishWell.btnId = ISLAND_UP_FUND
            table.insert(self.m_tBtnList, conWishWell)
        end

        conWishWell:setVisible(true)
        self.m_nIndex = self.m_nIndex + 1
    elseif isOpen ~= true and conWishWell and conWishWell:isVisible() == true then
        conWishWell:setVisible(false)
        local index2 = 999
        for i,v in ipairs(self.m_tBtnList) do
            if v.btnId == ISLAND_UP_FUND then
                index2 = i
            end
        end
        table.remove(self.m_tBtnList, index2)
        if index2 ~= 999 then
            local flcBtns = GetElement(self.m_root, "flcBtns_WndOwnCity", WZUIFreeListContainer)
            flcBtns:removeAt(index2-1)
        end
        self.m_nIndex = self.m_nIndex - 1
    end
end

--@brief    更新七天乐
function WndOwnCity:checkSevenDay()
--    WZLog("WndOwnCity:checkSevenDay zero", tostring(self.m_root), tostring(self.m_tBtnList), tostring(GlobalGame.g_isServerTaskOpen))
    if self.m_root == nil or self.m_tBtnList == nil then
        return
    end

    local time = SystemTime:getServerTime() - GlobalGame.g_serverTaskTime

    local isOpen = CheckButtonShow(ISLAND_UP_SEVEN_DAY, true) and time < 777600 and GlobalGame.g_isServerTaskOpen
    local conWishWell = GetElement(self.m_root, "con143_WndOwnCity", WZUIContainer)
--    WZLog("WndOwnCity:checkSevenDay one", tostring(isOpen), tostring(conWishWell), time, SystemTime:getServerTime(), GlobalGame.g_serverTaskTime)

    if isOpen and (conWishWell == nil or conWishWell:isVisible() ~= true) then
        if conWishWell == nil then
            local flcBtns = GetElement(self.m_root, "flcBtns_WndOwnCity", WZUIFreeListContainer)
            conWishWell = self:_createIconButton(ISLAND_UP_SEVEN_DAY, false)
            flcBtns:pushBack(conWishWell)
            conWishWell.btnId = ISLAND_UP_SEVEN_DAY
            table.insert(self.m_tBtnList, conWishWell)
        end

        conWishWell:setVisible(true)
        self.m_nIndex = self.m_nIndex + 1
    elseif isOpen ~= true and conWishWell and conWishWell:isVisible() == true then
        conWishWell:setVisible(false)
        local index2 = 999
        for i,v in ipairs(self.m_tBtnList) do
            if v.btnId == ISLAND_UP_SEVEN_DAY then
                index2 = i
                break
            end
        end
        table.remove(self.m_tBtnList, index2)
        if index2 ~= 999 then
            local flcBtns = GetElement(self.m_root, "flcBtns_WndOwnCity", WZUIFreeListContainer)
            flcBtns:removeAt(index2-1)
        end
        self.m_nIndex = self.m_nIndex - 1
    end
end

--@brief    更新首冲
function WndOwnCity:updateFirstRecharge(isOpen)
    if self.m_root == nil or self.m_tBtnList == nil then
        return
    end

    --isOpen = false
    local conFirst = GetElement(self.m_root, "con65_WndOwnCity", WZUIContainer)
    local conVip = GetElement(self.m_root, "con17_WndOwnCity", WZUIContainer)
    WZLog("WndOwnCity:updateFirstRecharge one", tostring(isOpen), tostring(conFirst), tostring(conVip))

    if isOpen then
        if conFirst == nil then
            local flcBtns = GetElement(self.m_root, "flcBtns_WndOwnCity", WZUIFreeListContainer)
            local conBtn = self:_createIconButton(ISLAND_UP_FIRST_RECHARGE, false)
            flcBtns:pushBack(conBtn)
            conBtn.btnId = ISLAND_UP_FIRST_RECHARGE
            for k,v in pairs(self.m_tBtnList) do
                if v.btnId == ISLAND_UP_RECHARGE then
                    self.m_tBtnList[k] = conBtn
                end
            end
        else
            conFirst:setVisible(true)
        end

        if conVip then
            conVip:setVisible(false)
        end
    else
        if conVip == nil then
            local flcBtns = GetElement(self.m_root, "flcBtns_WndOwnCity", WZUIFreeListContainer)
            local conBtn = self:_createIconButton(ISLAND_UP_RECHARGE, false)
            if conBtn then 
                flcBtns:pushBack(conBtn)
                conBtn.btnId = ISLAND_UP_RECHARGE
                for k,v in pairs(self.m_tBtnList) do
                    if v.btnId == ISLAND_UP_FIRST_RECHARGE then
                        self.m_tBtnList[k] = conBtn
                    end
                end
            end
        else
            conVip:setVisible(true)
        end

        if conFirst then
            conFirst:setVisible(false)
        end
    end
end

--@brief    更新左菜单UI界面
function WndOwnCity:GetFundInfoOk(buy, levellist, receivelist)
    WZLog("WndOwnCity:GetFundInfoOk one",buy,Serialize(VectorToTable(levellist)),Serialize(VectorToTable(receivelist)))

    if WndOwnCity.m_root and buy then
        local isRed = nil
        for i , v in pairs (levellist) do
            local isReceive = receivelist[i]
            if v <= CacheCenter.m_tPlayerInfo.level and isReceive == 0 then
                WZLog("WndOwnCity:GetFundInfoOk two")
                isRed = true
                break
            end
        end

        local btn = GetElementWithoutAssert(self.m_root, "btn19_WndOwnCity", WZUIButton)
        if btn and isRed then
            SceneCity:setRedPoint(btn,true,GlobalMethod:ccp(83,83))
        elseif btn and isRed ~= true then
            SceneCity:setRedPoint(btn,false)
        end
    end
end

--@brief    商城点击回调
function WndOwnCity:onClickShop(element)
    WZLog("WndOwnCity:onClickShop")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    TeachGroup1:endTeachStep({26,2})

    local isEndTeach26, teachStep26 = TeachGroup1:isTeachFinish(26)
    if teachStep26 >= 5 then
        TeachGroup1:setTeachFinish(26, -1)
        TeachGroup1:removeTeach()
    end

    local isTeach = TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 43 and TeachGroup1.STEP == 3
    
    if CheckButtonOpen(ISLAND_BUILDING_SHOP) and isTeach ~= true then
        local wndShop = WndShop:createElement()
        --WindowManager:addWindow(wndShop,WndShop)

        WindowManager:addWindow(wndShop, WndShop)
    end
end

--@brief    商店点击回调
function WndOwnCity:onClickUpShop(element)
    WZLog("WndOwnCity:onClickUpShop")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    local isTeach = TeachGroup1.ISTEACH == true and (TeachGroup1.GROUP == 1 and TeachGroup1.STEP == 2 or TeachGroup1.GROUP == 13 and TeachGroup1.STEP == 1)

    if CheckButtonOpen(ISLAND_UP_SHOP) and isTeach ~= true then
        local wndPractice = WndPractice:createElement()
        if wndPractice ~= nil then
            WindowManager:addWindow(wndPractice, WndPractice, false)
        end
    end
end

--@brief    排行榜点击回调
function WndOwnCity:onClickRank(element)
    WZLog("WndOwnCity:onClickRank")
    TeachGroup1:endTeachStep({16,1})
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    if CheckButtonOpen(ISLAND_BUILDING_RANK) then
       local pWndRankList = WndRankList:createElement()
       if pWndRankList ~= nil then
           WindowManager:addWindow( pWndRankList , WndRankList )
       end
    end
end

--@brief    点击精英商城按钮后的响应方法
--@param    element:按钮的UI节点引用
--@note 在这里做相应的按钮相应事件
function WndOwnCity:onClickEliteShop(element)
    WZLog("WndOwnCity:onClickEliteShop")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    SceneCity:updateRedDotBuilding("eliteShop", false)
    if PassportSdkManager.showHeoShop then
        local curSdkObj = PassportSdkManager:getCurSdkObj()
        if curSdkObj and curSdkObj.m_tConfig.SDKOtherConfig.needBloc == "true" then
            PassportSdkManager:showHeoShop()
        else
           MsgBoxManager:showTipBox(LocalStrings.BLOCTIPS)
        end
    end

end

--@brief    点击祈愿按钮后的响应方法
--@param    element:按钮的UI节点引用
--@note 在这里做相应的按钮相应事件
function WndOwnCity:onClickPray(element)
    WZLog("WndOwnCity:onClickPray")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    SceneCity:updateRedDotBuilding("pray", false)

    PassportSdkManager:showHeroPray()
end

--@brief    点击精英商城按钮后的响应方法
--@param    element:按钮的UI节点引用
--@note 在这里做相应的按钮相应事件
function WndOwnCity:onClickWishingWell(element)
    WZLog("WndOwnCity:onClickWishingWell")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    if CheckButtonOpen(ISLAND_UP_WISHING_WELL) then
       -- WndPromiseShrine:showWnd()
       WndActivityIntegrate:showInterface(4)
    else
        MsgBoxManager:showTipBox(LocalStrings.WORLD_BOSS_END_TITLE)
    end
end

--@brief    点击世界杯按钮后的响应方法
--@param    element:按钮的UI节点引用
--@note 在这里做相应的按钮相应事件
function WndOwnCity:onClickFootBall(element)
    WZLog("WndOwnCity:onClickFootBall")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    if GlobalGame.g_autoFootballActivity ~= 1 then
        MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END)
        return 
    end
    if CheckButtonOpen(ISLAND_UP_FOOT_BALL, false) then
        WndFootballActivity:showInterface()
    end
end

--@brief    点击回归活动按钮回调
function WndOwnCity:onClickBackActivity(element)
    -- body
    WZLog("WndOwnCity:onClickBackActivity")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    if CheckButtonOpen(ISLAND_UP_BACK_ACTIVITY, false) then
        GlobalGame.g_autoReturneeActivity = false
        WndReturneeActivity:showInterface(6)
    end
end

--@brief    点击问答回调
function WndOwnCity:onClickQuestion(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    if CheckButtonOpen(ISLAND_UP_QUESTION, false) then
        WndAnswerSurvey:showInterface()
    end
end

--@brief    点击幻石按钮后的响应方法
--@param    element:按钮的UI节点引用
--@note 在这里做相应的按钮相应事件
function WndOwnCity:onClickMagicStone(element)
    WZLog("WndOwnCity:onClickMagicStone")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    if g_cityExtenInfo and tonumber(g_cityExtenInfo.magicStoneStatus) == 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAGIC_STONE_TEXT23)
        return 
    end
    if CheckButtonOpen(ISLAND_UP_MAGIC_STONE) then
        WndMagicStone:showInterface()
    end
end

--@brief    点击投资返利按钮后的响应方法
--@param    element:按钮的UI节点引用
--@note 在这里做相应的按钮相应事件
function WndOwnCity:onClickInvestRebate(element)
    WZLog("WndOwnCity:onClickInvestRebate")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    if g_cityExtenInfo and tonumber(g_cityExtenInfo.investRebate) == 0 then
        MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END)
        return 
    end
    if CheckButtonOpen(ISLAND_UP_INVESTREBATE) then
        WndFrameActivity:showInterface(g_tGameActivityTypes.ACTIVITY_INVESTREBATE)
    end
end

--@brief    点击全民摇摇乐按钮后的响应方法
--@param    element:按钮的UI节点引用
--@note 在这里做相应的按钮相应事件
function WndOwnCity:onClickHappyShake(element)
    WZLog("WndOwnCity:onClickHappyShake", g_cityExtenInfo.activityPokerStatus)
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    if g_cityExtenInfo and tonumber(g_cityExtenInfo.activityPokerStatus) == 0 then
        MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END)
        return 
    end
    if CheckButtonOpen(ISLAND_UP_HAPPYSHAKE) then
        WndFrameActivity:showInterface(g_tGameActivityTypes.ACTIVITY_HAPPYSHAKE)
    end
end

--@brief    点击疯狂翻倍按钮后的响应方法
--@param    element:按钮的UI节点引用
--@note     在这里做相应的按钮相应事件
function WndOwnCity:onClickCrazyDoubling(element)
    WZLog("WndOwnCity:onClickHappyShake")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    if g_cityExtenInfo and tonumber(g_cityExtenInfo.CDStatus) == 0 then
        MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END)
        return 
    end
    if CheckButtonOpen(ISLAND_UP_CRAZY_DOUBLING) then
        WndFrameActivity:showInterface(g_tGameActivityTypes.ACTIVITY_CRAZY_DOUBLING)
    end
end

--@brief    点击拍卖行按钮后的响应方法
--@param    element:按钮的UI节点引用
--@note 在这里做相应的按钮相应事件
function WndOwnCity:onClickAuctionHouse(element)
    WZLog("WndOwnCity:onClickAuctionHouse")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    if g_cityExtenInfo and tonumber(g_cityExtenInfo.auction) == 0 then
        MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END)
        return 
    end
    if CheckButtonOpen(ISLAND_UP_AUCTION_HOUSE) then
        WndAuctionHouseAct:showInterface(g_tGameActivityTypes.ACTIVITY_AUCTION_HOUSE)
    end
end

--@brief    点击鲜花榜排行按钮后的响应方法
function WndOwnCity:onClickFlowerRank(element)
    WZLog("WndOwnCity:onClickFlowerRank")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    if g_cityExtenInfo and tonumber(g_cityExtenInfo.Activity5019) == 0 then
        MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END)
        return 
    end
    if CheckButtonOpen(ISLAND_UP_FLOWER_RANK) then
        WndFlowerRank:showInterface()
    end
end

--@brief    设置额外信息
function WndOwnCity:setExtraInfoForBtn()
    -- body
    if self.m_root == nil then return end 
    WndOwnCity:openOther()
end

--@brief    点击开关按钮后的响应方法
--@param    element:按钮的UI节点引用
--@note 在这里做相应的按钮相应事件
function WndOwnCity:onClickSwitch(element, parm1, parm2, state)
    WZLog("WndOwnCity:onClickSwitch one", state, self:getSwitchState())
    -- 每次点击都会更新红点的状态
    if state ~= self:getSwitchState() then
--        CacheCenter:updateRedPoint("right",self.m_root,nil,3)
        state = state and state or self:getSwitchState()
        WZLog("WndOwnCity:onClickSwitch two", tostring(not state), 1 - self.m_nMoveDirection, tostring(element), tostring(self.m_bIsMoveVerticalBar))
        SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
        if self.m_bIsMoveVerticalBar ~= true then
            self:setSwitchState(not state)
            g_CityTopBtnState = not state
            WZLog("WndOwnCity:onClickSwitch three", tostring(state), self.m_nMoveDirection)
            self:moveVerticalBar(1 - ((not state) and 1 or 0))
        end
    end
end

--@brief    设置开关
--@note     开关图片设置
function WndOwnCity:setSwitchState(state)
    WZLog("WndOwnCity:setSwitchState", self.m_bIsMoveVerticalBar, self.m_bIsNeedMoveVerticalBar)
    if self.m_root and self.m_bIsMoveVerticalBar ~= true and self.m_bIsNeedMoveVerticalBar == true then
        local res = "ui/city/beta/main_icon_di09_2.png"
        local imgSwitchIcon = GetElement(self.m_root, "imgSwitchIcon_WndOwnCity", WZUIImage)
        local txtActivity = GetElement(self.m_root, "txtActivity_WndOwnCity", WZUILabelTTF)
        imgSwitchIcon:setVisible(false)
        txtActivity:setVisible(false)
        if state ~= true then
            res = "ui/city/beta/main_icon_di01_2.png"
            imgSwitchIcon:setVisible(true)
            txtActivity:setVisible(true)
        end
        self.m_sRes = res
        GetElement(self.m_root,"imgSwitch_WndOwnCity",WZUIImage):setFile(res)
        GetElement(self.m_root,"imgSwitch2_WndOwnCity",WZUIImage):setFile(res)
    end
end

--@brief    设置开关
--@note     开关图片设置
function WndOwnCity:getSwitchState()
    WZLog("WndOwnCity:getSwitchState one")
    if self.m_root then
        local file = GetElement(self.m_root,"imgSwitch_WndOwnCity",WZUIImage):getFile()
        local state = false
        if self.m_sRes == "ui/city/beta/main_icon_di09_2.png" then
            state = true
        end
        return state
    end
end

--@brief    移动活动按钮栏
--@note
function WndOwnCity:moveVerticalBar(direction)
    WZLog("WndOwnCity:moveVerticalBar one", direction, tostring(self.m_nMoveDirection), tostring(self.m_bIsMoveVerticalBar), tostring(self.m_bIsNeedMoveVerticalBar))
    if self.m_bIsMoveVerticalBar ~= true and self.m_bIsNeedMoveVerticalBar == true then
        self.m_bIsMoveVerticalBar = true
        self.m_nMoveDirection = direction
        local t = 0.3
        local x, y = 0,1.01

        if direction == 0 then
            x, y = 0.945,0.86
            WZLog("WndOwnCity:moveVerticalBar two", self.m_nBtnCount, y)
            --WndCurrentChat:wndCurChatVisible(false)
        else
            x, y = 3,0.86
        end

        
        if direction == 0 then
            self:endMoveVerticalBar3()
        else
            --创建序列动作
            local actionSequence = WZUIActionSequence:create()
            actionSequence:setIsLoop( false )
            --创建移动动作
            local actMoveTo = WZUIActionMoveTo:create()
            actMoveTo:setDuration(t)
            actMoveTo:setMoveX(x)
            -- actMoveTo:setMoveY(y - self.m_nAdditionalMoveDis)--1.6.4:整行下移大概20像素
            actMoveTo:setMoveY(y)
            actMoveTo:setFinishLuaFunction("endMoveVerticalBar2")
            actMoveTo:setFinishLuaTable(self)
            actionSequence:setChildAction( actMoveTo )

            GetElement(self.m_root, "conActivityBtns_WndOwnCity", WZUIContainer):runUIAction( actionSequence )
        end
    end
end

--@brief    移动的结束回调
--@param    sender:回调元素
--@note
function WndOwnCity:endMoveVerticalBar2(sender)
    WZLog("WndOwnCity:endMoveVerticalBar2")
    GetElement(self.m_root, "conActivityBtns_WndOwnCity", WZUIContainer):setVisible(true)

    local x, y = 3,0.86
    local t = 0.15

    --创建序列动作
    local actionSequence = WZUIActionSequence:create()
    actionSequence:setIsLoop( false )
    --创建移动动作
    local actMoveTo = WZUIActionMoveTo:create()
    actMoveTo:setDuration(t)
    actMoveTo:setMoveX(x)
    actMoveTo:setMoveY(y)
    actMoveTo:setFinishLuaFunction("endMoveVerticalBar2_2")
    actMoveTo:setFinishLuaTable(self)
    actionSequence:setChildAction( actMoveTo )
    GetElement(self.m_root, "conActivityBtns_WndOwnCity", WZUIContainer):runUIAction( actionSequence )
end

--@brief    移动的结束回调
--@param    sender:回调元素
--@note
function WndOwnCity:endMoveVerticalBar2_2(sender, levelUp, isTrailerAnim)
    self.m_bIsMoveVerticalBar = false
end

--@brief    移动的结束回调
--@param    sender:回调元素
--@note
function WndOwnCity:endMoveVerticalBar3(sender)
    WZLog("WndOwnCity:endMoveVerticalBar3")
    local x, y = 0.945,0.86
    local t = 0.15

    --创建序列动作
    local actionSequence = WZUIActionSequence:create()
    actionSequence:setIsLoop( false )
    --创建移动动作
    local actMoveTo = WZUIActionMoveTo:create()
    actMoveTo:setDuration(t)
    actMoveTo:setMoveX(x)
    actMoveTo:setMoveY(y)
    actMoveTo:setFinishLuaFunction("endMoveVerticalBar4")
    actMoveTo:setFinishLuaTable(self)
    actionSequence:setChildAction( actMoveTo )
    GetElement(self.m_root, "conActivityBtns_WndOwnCity", WZUIContainer):runUIAction( actionSequence )
end

--@brief    移动的结束回调
--@param    sender:回调元素
--@note
function WndOwnCity:endMoveVerticalBar4(sender)
    WZLog("WndOwnCity:endMoveVerticalBar4")
    GetElement(self.m_root, "conActivityBtns_WndOwnCity", WZUIContainer):setVisible(true)

    local x, y = 0.945,0.86
    local t = 0.3

    --创建序列动作
    local actionSequence = WZUIActionSequence:create()
    actionSequence:setIsLoop( false )
    --创建移动动作
    local actMoveTo = WZUIActionMoveTo:create()
    actMoveTo:setDuration(t)
    actMoveTo:setMoveX(x)
    actMoveTo:setMoveY(y)
    actMoveTo:setFinishLuaFunction("endMoveVerticalBar2_2")
    actMoveTo:setFinishLuaTable(self)
    actionSequence:setChildAction( actMoveTo )

    GetElement(self.m_root, "conActivityBtns_WndOwnCity", WZUIContainer):runUIAction( actionSequence )
end

--@brief    设置是否需要移动垂直条
--@note
function WndOwnCity:setNeedMoveVerticalBar(isNeed)
    WZLog("WndOwnCity:setNeedMoveVerticalBar one")
    self.m_bIsNeedMoveVerticalBar = isNeed
end

--@brief    垂直条
--@note     滚动条
function WndOwnCity:getVerticalBar()
    WZLog("WndOwnCity:getVerticalBar one")
    if self.m_root then
        return GetElement(self.m_root, "flcBtns_WndOwnCity", WZUIFreeListContainer)
    end
end

--@brief    限购推送礼包时间结束，隐藏入口
function WndOwnCity:setFiveTypePackBtnVisible(bVisible)
    if self.m_root == nil then return end 

    local btnLimitPackage = GetElement(self.m_root,"btnFiveTypePackage_WndOwnCity",WZUIButton)
    if btnLimitPackage then 
        btnLimitPackage:setVisible(bVisible)
    end
end
-------------------------------------公有方法模块End----------------------------------------
-------------------------------------私有方法模块Begin--------------------------------------

local buildOpenList =
{

}

--@brief	检查建筑物功能是否开放
--@param    nBtnId, 按钮id
--@return   #1, 是否开放
function WndOwnCity:_checkBuildingOpen(nBtnId)
    if TeachGroup1.ISTEACHMODE then return true end
    if self.m_tBtnsInfo then
        for i,v in ipairs(self.m_tBtnsInfo) do
            WZLog(v.buttonId)
            if v.buttonId == nBtnId then
                WZLog(v.buttonId)
                local bFlag = SceneCity:ifBuildingOpen(v)
                if bFlag == false then
                    WZLog("WndOwnCity:_checkBuildingOpen 1", tostring(v.buttonTips))
                    MsgBoxManager:showTipBox(v.buttonTips)
                end
                return bFlag
            end
        end
    end

    if self.m_tLeftBtnsInfo then
        for i,v in ipairs(self.m_tLeftBtnsInfo) do
            WZLog(v.buttonId)
            if v.buttonId == nBtnId then
                WZLog(v.buttonId)
                local bFlag = SceneCity:ifBuildingOpen(v)
                if bFlag == false then
                    WZLog("WndOwnCity:_checkBuildingOpen 2", tostring(v.buttonTips))
                    MsgBoxManager:showTipBox(v.buttonTips)
                end
                return bFlag
            end
        end
    end
    return true

end

--菜单按钮的响应方法
local tBtnClickFunc = {
    [ISLAND_UP_BINDING] = "onClickBinding",
    [ISLAND_BUILDING_LOTTERY] = "onClickLove",
    [ISLAND_UP_BLESS] = "onClickBless",
    [ISLAND_UP_FIRST_RECHARGE] = "onClickFirstRecharge",
    [ISLAND_BUILDING_SHOP] = "onClickShop",
    [ISLAND_UP_SHOP] = "onClickUpShop",
    [ISLAND_UP_EVENT] = "onClickGameActivity",
    [ISLAND_UP_MATCH] = "onClickMatch",
    [ISLAND_BUILDING_RANK] = "onClickRank",
    [ISLAND_UP_LBS] = "onClickLbs",
    [ISLAND_UP_WELFARE] = "onClickWelfare",
    [ISLAND_EXTEND_CHARM] = "onClickCharm",
    [ISLAND_UP_FUND] = "onClickFund",
    [ISLAND_UP_MONTHCARD] = "onClickMonthCard",
    [ISLAND_UP_MTO] = "onClickMTO",
    [ISLAND_LEFT_4399] = "onClick4399",
    [ISLAND_UP_ELITE_SHOP] = "onClickEliteShop",
    [ISLAND_UP_WISHING_WELL] = "onClickWishingWell",
    [ISLAND_UP_PRAY] = "onClickPray",
    [ISLAND_UP_FOOT_BALL] = "onClickFootBall",
    [ISLAND_UP_SEVEN_DAY] = "onClickSevenDay",
    [ISLAND_UP_BACK_ACTIVITY] = "onClickBackActivity",
    [ISLAND_UP_QUESTION] = "onClickQuestion",
    [ISLAND_UP_MAGIC_STONE] = "onClickMagicStone",
    [ISLAND_UP_INVESTREBATE] = "onClickInvestRebate",
    [ISLAND_UP_HAPPYSHAKE] = "onClickHappyShake",
    [ISLAND_UP_ONE_YUAN] = "onClickOneYuan",
    [ISLAND_UP_CRAZY_DOUBLING] = "onClickCrazyDoubling",
    [ISLAND_UP_AUCTION_HOUSE] = "onClickAuctionHouse",
    [DOUBLE_SEVEN_CONFREE] = "onClickDoubleSeven",
    [NATIONAL_FESTIVAL] = "onClickNationalFestival",
    [NATIONAL_ANSWER] = "onClickNationalAnswer",
    [ISLAND_UP_OPPO_AMBERPLAYER] = "onClickOPPOAmberPlayer",
    [PEOPLESHOP] = "onClickPeopleShop",
    [TREASURESEARCH] = "onClickTreasureSerach",
    [EVERYDAYBUY] = "onClickEveryDayBuy",
    [NEWYEARDAY] = "onClickNerYearDay",
    [FEBRUARYNEWYEAR] = "onClickEveryFebruaryNewYear",
    [FOURSTARS] = "onClickFourStar",
    [BLINDBOX] = "onClickBlindBox",
    [DOLLMACHINE] = "onClickDollMachine",
    [ACTIVITYLIMITLOGIN] = "onClickLimitLogin",
    [ACTIVITYNEWRECHARGE] = "onClickNewRecharge",
    [REBACKACTIVITY] = "onClickRebackActivity",
    [FIGHT_ACTIVITY] = "onClickFightActivity",
    [FIGHT_ACTIVITY1] = "onClickFightActivity1",
    [FIGHT_ACTIVITY2] = "onClickFightActivity2",
    [ACTIVITY_SHOOT_ARROW] = "onClickShootArrow",
    [RISE_ACTIVITY] = "onClickRiseActivity",
    [HORARY_ACTIVITY] = "onClickHoraryActivity",
    [MIDFESTIVAL_ACTIVITY] = "onClickMidFestivalActivity",
    [FISH_ACTIVITY] = "onClickFishActivity",
    [PELLET_ACTIVITY] = "onClickPelletActivity",
    [HOUSEINVEST_ACTIVITY] = "onClickHouseInvestActivity",
    [WATERCOUNTRY_ACTIVITY] = "onClickWaterCountry",
    [DECORATIONS_ACTIVITY] = "onClickDecorations",
    [YEARMONSTER_ACTIVITY] = "onClickYearMonster",
    [NEWYEARWISH_ACTIVITY] = "onClickNewYearWish",
    [BEATENGINEER_ACTIVITY] = "onClickBeatEngineer",
    [ISLAND_UP_LEAGUE] = "onClickLeague",
    [ALCHEMY_ACTIVITY] = "onClickAlchemy",
    [BEATMICE_ACTIVITY] = "onClickBeatMice",
    [BLUEPRIVILEGE_ACTIVITY] = "onClickBluePrivilege",
    [QQHALLPRIVILEGE_ACTIVITY] = "onClickQQHallPrivilege",
    [SETCIECLE_ACTIVITY] = "onClickSetCircle",
    [GARDEN_ACTIVITY] = "onClickGarden",
    [CAFFEE_ACTIVITY] = "onClickCaffee",
    [BOWLING_ACTIVITY] = "onClickBowling",
    [YEARPLAYER_ACTIVITY] = "onClickYearPlayer",
    [WATERMELON_ACTIVITY] = "onClickWatermelon",
    [SECRETTOWER_ACTIVITY] = "onClickSecretTower",
    [MONEYTREE_ACTIVITY] = "onClickMoneyTree",
    [BILLIARDBALL_ACTIVITY] = "onClickBilliardBall",
    [DRESSGIVE_ACTIVITY] = "onClickDressGive",
    [CRAZY_GASHAPON_ACTIVITY] = "onClickCrazyGashapon",
    [MIDNIGHTDINER_ACTIVITY] = "onClickMidnightDiner",
    [GOPHERBALL_ACTIVITY] = "onClickGopherBall",
    [NEWCUTELIST_ACTIVITY] = "onClickNewCuteList",
    [BEINGIMMORTAL_ACTIVITY] = "onClickBeingImmortal",
    [WORSHIPGOD_ACTIVITY] = "onClickWorshipGod",
    [CALABASH_ACTIVITY] = "onClickCalabash",
    [SPRINGOUTING_ACTIVITY] = "onClickSpringOuting",
    [THANKFULSIGN_ACTIVITY] = "onClickThankfulSign",
    [WELCOMEBACK_ACTIVITY] = "onClickWelcomeBack",
    [BEATBALLOON_ACTIVITY] = "onClickBeatBalloon",
    [DAZZLERANK_ACTIVITY] = "onClickDazzleRank",
    [SUPER_SPECIAL_ACTIVITY] = "onClickSuperSpecial",
    [TEAMCONSUME_ACTIVITY] = "onClickTeamConsume",
    [SEAFARROAD_ACTIVITY] = "onClickSeafarRoad",
    [CLIMBTREE_ACTIVITY] = "onClickClimbTree",
    [SUMMERSURF_ACTIVITY] = "onClickSummerSurf",
    [PLANETSEARCH_ACTIVITY] = "onClickPlanetSearch",
    [SEVENYEAR_ACTIVITY] = "onClickSevenYear",
    [ZONGZI_ACTIVITY] = "onClickZongZi",
    [SPECIFICSALES_ACTIVITY] = "onClickSpecificSales", --限定活动(特殊售卖)
    [TRAMPOLINE_ACTIVITY] = "onClickTrampoline",
    [GOLFBALL_ACTIVITY] = "onClickGolfball",
    [WISHING_BOTTLE_ACTIVITY] = "onClickWishingBottle",
    [DETECTIVE_ACTIVITY] = "onClickDetective",
    [CATCHFISH_ACTIVITY] = "onClickCatchFish",
    [EIGHTYEAR_ACTIVITY] = "onClickEightYear",
    [COLDDRINK_ACTIVITY] = "onClickColdDrink",
    [ISLAND_UP_FLOWER_RANK] = "onClickFlowerRank",
    [FOOTBALL_SHOOT_ACTIVITY] = "onClickFootballShoot",
    [GROW_GIFT_ACTIVITY] = "onClickGrowGift",
    [HAPPY_MIDAUTUMN_ACTIVITY] = "onClickHappyMidAutumn",
    [WEEKEND_SPECIAL_ACTIVITY] = "onClickWeekendSpecial",
    [MYSTERIOUS_SHOP_ACTIVITY] = "onClickMysteriousShop",
    [ZOO_SIGHTSEEING_ACTIVITY] = "onClickZooSightseeing",
    [WEEKEND_SPECIAL_ACTIVITY2] = "onClickWeekendSpecial2",
    [GONGANDDRUM_ACTIVITY] = "onClickGongAndDrum",
    [GOLD_MINER_ACTIVITY] = "onClickGoldMiner",
    [DEEPSEA_ACTIVITY] = "onClickDeepSea",
    [CHESS_ACTIVITY] = "onClickChess",
    [AUTUMNCAMP_ACTIVITY] = "onClickAutumnCamp",
    [HOTBASKETBALL_ACTIVITY] = "onClickHotBasketball",
    [FLY_KITES_ACTIVITY] = "onClickFlyKites",
    [THROWPOT_ACTIVITY] = "onClickThrowPot",
    [CATCHFISH_ACTIVITY] = "onClickCatchFish",
    [BIKEMATCH_ACTIVITY] = "onClickBikeMatch",
    [LASHTOP_ACTIVITY] = "onClickLashTop",
    [RABBIT_GIFT_ACTIVITY] = "onClickRabbitGift",
    [LUCKY_FLIP_ACTIVITY] = "onClickLuckyFlip",
    [BRAVING_TOWER_ACTIVITY] = "onClickBravingTower",
    [KICKINGBIRDIE_ACTIVITY] = "onClickKickingBirdie",
    [MAGICCLASSROOM_ACTIVITY] = "onClickMagicClassroom",
    [MAKESNOWMAN_ACTIVITY] = "onClickMakeSnowman",
    [PIANIST_ACTIVITY] = "onClickPianist",
    [CERAMIC_WORKSHOP_ACTIVITY] = "onClickCeramicWorkshop",
    [WEIGHTLIFTING_ACTIVITY] = "onClickWeightlifting",
    [ARCTIC_EXPLORATION_ACTIVITY] = "onClickArcticExploration",
    [BUILDING_BLOCKS_ACTIVITY] = "onClickBuildingBlocks",
    [SWORD_CASTING_MASTER_ACTIVITY] = "onClickSwordCastingMaster",
    [BOATING_LAKE_ACTIVITY] = "onClickBoatingLake",
    [BLOW_BUBBLES_ACTIVITY] = "onClickBlowBubbles",
    [PICKTEA_ACTIVITY] = "onClickPickTea",
    [AFFORESTATION_ACTIVITY] = "onClickAfforestation",
    [POTIONS_REFININ_ACTIVITY] = "onClickPotionsRefinin",
    [JEWELRY_ACTIVITY] = "onClickJewelry",
}

--菜单按钮的图片
local tBtnImgPath = {
    [ISLAND_UP_BINDING] =       "ui/city/newUI/common_icon_zhbd",
    [ISLAND_BUILDING_LOTTERY] =       "ui/city/newUI/common_icon_axxy2",
    [ISLAND_UP_BLESS] =       "ui/city/newUI/common_icon_xhxt",
    [ISLAND_UP_FIRST_RECHARGE] =       "ui/city/beta/main_icon_shouchong_2",
    [ISLAND_BUILDING_SHOP] =        "ui/city/beta/main_icon_shangcheng_2",
    [ISLAND_UP_SHOP] =        "ui/city/beta/main_icon_xiulian_2",
    [ISLAND_UP_EVENT] =     "ui/city/beta/main_icon_huodong_2",
    [ISLAND_UP_MATCH] =  "ui/city/beta/main_icon_bisai_2",
    [ISLAND_BUILDING_RANK] =  "ui/city/beta/main_icon_paihangbang_2",
    [ISLAND_UP_LBS] =  "ui/city/beta/main_icon_sousuo_2",
    [ISLAND_UP_WELFARE] =       "ui/city/beta/main_icon_fuli_2",
    [ISLAND_EXTEND_CHARM] =       "ui/city/beta/main_icon_meilikongjian_2",
    [ISLAND_UP_FUND] =     "ui/city/beta/main_icon_chengzhangjijin_2",
    [ISLAND_UP_MONTHCARD] =       "ui/city/beta/main_icon_yueka_2",
    [ISLAND_LEFT_4399] =     "ui/city/beta/main_icon_43992",
    [ISLAND_UP_ELITE_SHOP] =     "ui/city/beta/main_icon_shangcheng_2",
    [ISLAND_UP_WISHING_WELL] = "ui/city/beta/main_icon_xuyuanchi_2",
    [ISLAND_UP_PRAY] =     "ui/city/beta/main_icon_qiyuandali_2",
    [ISLAND_UP_MTO] =       "ui/city/newUI/common_icon_zctzlb",
    [ISLAND_UP_FOOT_BALL] =       "ui/city/beta/main_icon_hd_football",
    [ISLAND_UP_SEVEN_DAY] =       "ui/city/beta/main_icon_qtl_2",
    [ISLAND_UP_BACK_ACTIVITY] =       "shopitems/xiaodao_tubiao",
    [ISLAND_UP_QUESTION] =       "ui/city/beta/main_icon_diaoyan",
    [ISLAND_UP_MAGIC_STONE] =       "ui/city/beta/main_icon_hd_sjb",
    [ISLAND_UP_INVESTREBATE] =       "ui/city/beta/main_icon_hd_tzfl",
    [ISLAND_UP_HAPPYSHAKE] =       "ui/city/beta/main_icon_hd_yyl",
    [ISLAND_UP_ONE_YUAN] = "ui/city/beta/main_icon_1yuanchong",
    [ISLAND_UP_CRAZY_DOUBLING] = "ui/city/beta/main_icon_hd_fkfb",
    [ISLAND_UP_AUCTION_HOUSE] = "ui/city/beta/main_icon_hd_pmh",
    [DOUBLE_SEVEN_CONFREE] = "ui/city/beta/main_icon_hd_qx",
    [NATIONAL_FESTIVAL] = "ui/city/beta/main_icon_hd_zypx",
    [NATIONAL_ANSWER] = "ui/city/beta/main_icon_hd_dt",
    [ISLAND_UP_OPPO_AMBERPLAYER] = "ui/city/beta/main_icon_hd_hphy",
    [PEOPLESHOP] = "ui/city/beta/main_icon_hd_qmgw",
    [TREASURESEARCH] = "ui/city/beta/main_icon_hd_xb",
    [EVERYDAYBUY] = "ui/city/beta/main_icon_hd_mrbg",
    [NEWYEARDAY] = "ui/city/beta/main_icon_hd_qq",
    [FEBRUARYNEWYEAR] = "ui/city/beta/main_icon_hd_xnkh",
    [FOURSTARS] = "ui/city/beta/main_icon_sxxx",
    [BLINDBOX] = "ui/city/beta/main_icon_hd_ddmh",
    [DOLLMACHINE] = "ui/city/beta/main_icon_hd_wwj",
    [ACTIVITYLIMITLOGIN] = "ui/city/beta/main_icon_hd_xsdl",
    [ACTIVITYNEWRECHARGE] = "ui/city/beta/main_icon_shouchong_2",
    [REBACKACTIVITY] = "ui/city/beta/main_icon_hd_hghl",
    [FIGHT_ACTIVITY] = "ui/city/beta/main_icon_hd_zlfs",
    [FIGHT_ACTIVITY1] = "ui/city/beta/main_icon_hd_zlfs",
    [FIGHT_ACTIVITY2] = "ui/city/beta/main_icon_hd_zlfs",
    [ACTIVITY_SHOOT_ARROW] = "ui/city/beta/main_icon_sj",
    [RISE_ACTIVITY] = "ui/city/beta/main_icon_jqzl",
    [HORARY_ACTIVITY] = "ui/city/beta/main_icon_hd_hjqm",
    [MIDFESTIVAL_ACTIVITY] = "ui/city/beta/main_icon_hd_dxr",
    [FISH_ACTIVITY] = "ui/city/beta/main_icon_dy",
    [PELLET_ACTIVITY] = "ui/city/beta/main_icon_hd_tndz",
    [HOUSEINVEST_ACTIVITY] = "ui/city/beta/main_icon_hd_fcdh",
    [WATERCOUNTRY_ACTIVITY] = "ui/city/beta/main_icon_hd_szgd",
    [DECORATIONS_ACTIVITY] = "ui/city/beta/main_icon_hd_zdjc",
    [YEARMONSTER_ACTIVITY] = "ui/city/beta/main_icon_hd_nsdzz",
    [NEWYEARWISH_ACTIVITY] = "ui/city/beta/main_icon_hd_xnyy",
    [BEATENGINEER_ACTIVITY] = "ui/city/beta/main_icon_hd_bzch",
    [ISLAND_UP_LEAGUE] = "ui/city/beta/main_icon_bisai_2",
    [ALCHEMY_ACTIVITY] = "ui/city/beta/main_icon_hd_ddxz",
    [BEATMICE_ACTIVITY] = "ui/city/beta/main_icon_hd_hlds",
    [BLUEPRIVILEGE_ACTIVITY] = "ui/city/beta/main_icon_hd_lztq",
    [QQHALLPRIVILEGE_ACTIVITY] = "ui/city/beta/main_icon_hd_dttq",
    [SETCIECLE_ACTIVITY] = "ui/city/beta/main_icon_hd_tqq",
    [GARDEN_ACTIVITY] = "ui/city/beta/main_icon_hd_xdgy",
    [CAFFEE_ACTIVITY] = "ui/city/beta/main_icon_hd_kfds",
    [BOWLING_ACTIVITY] = "ui/city/beta/main_icon_hd_ddblq",
    [YEARPLAYER_ACTIVITY] = "ui/city/beta/main_icon_hd_ndwj",
    [WATERMELON_ACTIVITY] = "ui/city/beta/main_icon_hd_xrxg",
    [SECRETTOWER_ACTIVITY] = "ui/city/beta/main_icon_mjct",
    [MONEYTREE_ACTIVITY] = "ui/city/beta/main_icon_yqs",
    [BILLIARDBALL_ACTIVITY] = "ui/city/beta/main_icon_twzj",
    [DRESSGIVE_ACTIVITY] = "ui/city/beta/main_icon_hd_szhs",
    [CRAZY_GASHAPON_ACTIVITY] = "ui/city/beta/main_icon_fknd",
    [MIDNIGHTDINER_ACTIVITY] = "ui/city/beta/main_icon_syst",
    [GOPHERBALL_ACTIVITY] = "ui/city/beta/main_icon_qld",
    [NEWCUTELIST_ACTIVITY] = "ui/city/beta/main_icon_hd_xmb",
    [BEINGIMMORTAL_ACTIVITY] = "ui/city/beta/main_icon_hd_xxz",
    [WORSHIPGOD_ACTIVITY] = "ui/city/beta/main_icon_hd_bcs",
    [CALABASH_ACTIVITY] = "ui/city/beta/main_icon_hd_hlw",
    [SPRINGOUTING_ACTIVITY] = "ui/city/beta/main_icon_hd_cytq",
    [THANKFULSIGN_ACTIVITY] = "ui/city/beta/main_icon_hd_gehk",
    [WELCOMEBACK_ACTIVITY] = "ui/city/beta/main_icon_hd_hyhg",
    [BEATBALLOON_ACTIVITY] = "ui/city/beta/main_icon_hd_dqq",
    [DAZZLERANK_ACTIVITY] = "ui/city/beta/main_icon_hd_yyb",
    [SUPER_SPECIAL_ACTIVITY] = "ui/city/beta/main_icon_hd_cztg",
    [TEAMCONSUME_ACTIVITY] = "ui/city/beta/main_icon_hd_ztxf",
    [SEAFARROAD_ACTIVITY] = "ui/city/beta/main_icon_hd_hhzs",
    [CLIMBTREE_ACTIVITY] = "ui/city/beta/main_icon_hd_ptds",
    [SUMMERSURF_ACTIVITY] = "ui/city/beta/main_icon_hd_xrcl",
    [PLANETSEARCH_ACTIVITY] = "ui/city/beta/main_icon_hd_xxts",
    [SEVENYEAR_ACTIVITY] = "ui/city/beta/main_icon_hd_7znq",
    [ZONGZI_ACTIVITY] = "ui/city/beta/main_icon_hd_zybt",
    [SPECIFICSALES_ACTIVITY] = "ui/city/beta/main_icon_hd_xdcs_01",
    [TRAMPOLINE_ACTIVITY] = "ui/city/beta/main_icon_hd_hlbc",
    [GOLFBALL_ACTIVITY] = "ui/city/beta/main_icon_hd_gefss",
    [WISHING_BOTTLE_ACTIVITY] = "ui/city/beta/main_icon_hd_xyp",
    [CATCHFISH_ACTIVITY] = "ui/city/beta/main_icon_hd_bydw",
    [EIGHTYEAR_ACTIVITY] = "ui/city/beta/main_icon_hd_8znqd",
    [COLDDRINK_ACTIVITY] = "ui/city/beta/main_icon_hd_qlby",
    [ISLAND_UP_FLOWER_RANK] = "ui/city/beta/main_icon_hd_xhb",
    [DETECTIVE_ACTIVITY] = "ui/city/beta/main_icon_hd_bkjzts",
    [FOOTBALL_SHOOT_ACTIVITY] = "ui/city/beta/main_icon_hd_smdz",
    [GROW_GIFT_ACTIVITY] = "ui/city/beta/main_icon_czlb",
    [HAPPY_MIDAUTUMN_ACTIVITY] = "ui/city/beta/main_icon_hd_hddw",
    [WEEKEND_SPECIAL_ACTIVITY] = "ui/city/beta/main_icon_hd_zmth",
    [MYSTERIOUS_SHOP_ACTIVITY] = "ui/city/beta/main_icon_hd_smsd_cg",
    [ZOO_SIGHTSEEING_ACTIVITY] = "ui/city/beta/main_icon_hd_dwygg",
    [WEEKEND_SPECIAL_ACTIVITY2] = "ui/city/beta/main_icon_hd_zmth",
    [GONGANDDRUM_ACTIVITY] = "ui/city/beta/main_icon_hd_lgxt",
    [GOLD_MINER_ACTIVITY] = "ui/city/beta/main_icon_hd_hjkg",
    [DEEPSEA_ACTIVITY] = "ui/city/beta/main_icon_hd_hdxb",
    [CHESS_ACTIVITY] = "ui/city/beta/main_icon_hd_yxq",
    [AUTUMNCAMP_ACTIVITY] = "ui/city/beta/main_icon_hd_qrly",
    [HOTBASKETBALL_ACTIVITY] = "ui/city/beta/main_icon_hd_rxlq",
    [FLY_KITES_ACTIVITY] = "ui/city/beta/main_icon_hd_ffz",
    [THROWPOT_ACTIVITY] = "ui/city/beta/main_icon_hd_th",
    [CATCHFISH_ACTIVITY] = "ui/city/beta/main_icon_hd_bydw",
    [BIKEMATCH_ACTIVITY] = "ui/city/beta/main_icon_hd_zxcs",
    [LASHTOP_ACTIVITY] = "ui/city/beta/main_icon_hd_ctl",
    [RABBIT_GIFT_ACTIVITY] = "ui/city/beta/main_icon_hd_ftsl",
    [LUCKY_FLIP_ACTIVITY] = "ui/city/beta/main_icon_hd_xyfp",
    [BRAVING_TOWER_ACTIVITY] = "ui/city/beta/main_icon_hd_ycgt",
    [KICKINGBIRDIE_ACTIVITY] = "ui/city/beta/main_icon_hd_tjz",
    [MAGICCLASSROOM_ACTIVITY] = "ui/city/beta/main_icon_hd_mfkt",
    [MAKESNOWMAN_ACTIVITY] = "ui/city/beta/main_icon_hd_dxr",
    [PIANIST_ACTIVITY] = "ui/city/beta/main_icon_hd_gqyzh",
    [CERAMIC_WORKSHOP_ACTIVITY] = "ui/city/beta/main_icon_hd_tygf",
    [WEIGHTLIFTING_ACTIVITY] = "ui/city/beta/main_icon_hd_jzss",
    [ARCTIC_EXPLORATION_ACTIVITY] = "ui/city/beta/main_icon_hd_xytx",
    [BUILDING_BLOCKS_ACTIVITY] = "ui/city/beta/main_icon_hd_pzjm",
    [SWORD_CASTING_MASTER_ACTIVITY] = "ui/city/beta/main_icon_hd_zjsj",
    [BOATING_LAKE_ACTIVITY] = "ui/city/beta/main_icon_hd_yhfz",
    [BLOW_BUBBLES_ACTIVITY] = "ui/city/beta/main_icon_hd_cpp",
    [PICKTEA_ACTIVITY] = "ui/city/beta/main_icon_hd_yqlcc",
    [AFFORESTATION_ACTIVITY] = "ui/city/beta/main_icon_hd_zszl",
    [POTIONS_REFININ_ACTIVITY] = "ui/city/beta/main_icon_hd_mylz",
    [JEWELRY_ACTIVITY] = "ui/city/beta/main_icon_hd_ssds",
}

--菜单按钮的文字图片
local tBtnImgNamePath = {
    [ISLAND_UP_FIRST_RECHARGE] =       LocalStrings.VIP_FIRST_DOUBLE,
    [ISLAND_BUILDING_SHOP] =        LocalStrings.SHOP,
    [ISLAND_UP_SHOP] =        LocalStrings.PRACTICE,
    [ISLAND_UP_EVENT] =     LocalStrings.GAMEACTIVITY_NEWTEXT1,
    [ISLAND_UP_MATCH] =  LocalStrings.WELFARE_NEWTEXT2,
    [ISLAND_BUILDING_RANK] =  LocalStrings.ACTIVITY_TEXT6,
    [ISLAND_UP_LBS] =  LocalStrings.FRIENDS_TEXT1,
    [ISLAND_UP_WELFARE] =       LocalStrings.WELFARE_NEWTEXT1,
    [ISLAND_EXTEND_CHARM] =       LocalStrings.CHARMSPACE_TEXT11,
    [ISLAND_UP_FUND] =     LocalStrings.FUNDINFO6,
    [ISLAND_UP_MONTHCARD] =       LocalStrings.MONTH_CARDS,
    [ISLAND_LEFT_4399] =     LocalStrings.CITY_TITLE1,
    [ISLAND_UP_ELITE_SHOP] =     LocalStrings.CITY_TITLE2,
    [ISLAND_UP_WISHING_WELL] = LocalStrings.PROMISE_SHRINE_TEXT10,
    [ISLAND_UP_PRAY] =     LocalStrings.CITY_TITLE3,
    [ISLAND_UP_MONTHCARD] =       LocalStrings.MONTH_CARDS,
    [ISLAND_UP_MTO] =       LocalStrings.CITY_TITLE27,
    [ISLAND_UP_FOOT_BALL] =       LocalStrings.CITY_TITLE4,
    [ISLAND_UP_SEVEN_DAY] =       LocalStrings.CITY_TITLE5,
    [ISLAND_UP_BACK_ACTIVITY] =       LocalStrings.CITY_TITLE6,
    [ISLAND_UP_QUESTION] =       LocalStrings.CITY_TITLE7,
    [ISLAND_UP_MAGIC_STONE] =       LocalStrings.MAGIC_STONE_TEXT1,
    [ISLAND_UP_INVESTREBATE] =       LocalStrings.GAMEACTIVITY_INVESTREBATE,
    [ISLAND_UP_HAPPYSHAKE] =       LocalStrings.CITY_TITLE8,
    [ISLAND_UP_ONE_YUAN] = LocalStrings.CITY_TITLE9,
    [ISLAND_UP_CRAZY_DOUBLING] = LocalStrings.GAME_ACTIVITY_CRAZY_DOUBLING,
    [ISLAND_UP_AUCTION_HOUSE] = LocalStrings.CITY_TITLE11,
    [DOUBLE_SEVEN_CONFREE] = LocalStrings.CITY_TITLE10,
    [NATIONAL_FESTIVAL] = LocalStrings.CITY_TITLE12,
    [NATIONAL_ANSWER] = LocalStrings.FESTIVAL_TEXT33,
    [ISLAND_UP_OPPO_AMBERPLAYER] = LocalStrings.CITY_TITLE13,
    [PEOPLESHOP] = LocalStrings.CITY_TITLE14,
    [TREASURESEARCH] = LocalStrings.NEWSHOP7,
    [EVERYDAYBUY] = LocalStrings.CITY_TITLE15,
    [NEWYEARDAY] = LocalStrings.CITY_TITLE16,
    [FEBRUARYNEWYEAR] = LocalStrings.CITY_TITLE17,
    [FOURSTARS] = LocalStrings.CITY_TITLE18,
    [BLINDBOX] = LocalStrings.BLIND_TEXT1,
    [DOLLMACHINE] = LocalStrings.CITY_TITLE19,
    [ACTIVITYLIMITLOGIN] = LocalStrings.CITY_TITLE20,
    [ACTIVITYNEWRECHARGE] = LocalStrings.VIP_FIRST_DOUBLE,
    [REBACKACTIVITY] = LocalStrings.CITY_TITLE21,
    [FIGHT_ACTIVITY] = LocalStrings.CITY_TITLE22,
    [FIGHT_ACTIVITY1] = LocalStrings.FIGHTACTIVITY1_TEXT1[1],
    [FIGHT_ACTIVITY2] = LocalStrings.FIGHTACTIVITY2_TEXT1[1],
    [ACTIVITY_SHOOT_ARROW] = LocalStrings.CITY_TITLE23,
    [RISE_ACTIVITY] = LocalStrings.CITY_TITLE24,
    [HORARY_ACTIVITY] = LocalStrings.CITY_TITLE25,
    [MIDFESTIVAL_ACTIVITY] = LocalStrings.ACTIVITY_TEXT110[4],
    [FISH_ACTIVITY] = LocalStrings.CITY_TITLE26,
    [PELLET_ACTIVITY] = LocalStrings.CITY_TITLE31,
    [HOUSEINVEST_ACTIVITY] = LocalStrings.CITY_TITLE36,
    [WATERCOUNTRY_ACTIVITY] = LocalStrings.WATERCOUNTRY_TEXT2[7],
    [DECORATIONS_ACTIVITY] = LocalStrings.DECORATIONS_TEXT1[1],
    [YEARMONSTER_ACTIVITY] = LocalStrings.YEARMONSTER_TEXT1[1],
    [NEWYEARWISH_ACTIVITY] = LocalStrings.NEWYEARWISH_TEXT1[1],
    [BEATENGINEER_ACTIVITY] = LocalStrings.BEATENGINEER_TEXT1[1],
    [ISLAND_UP_LEAGUE] = LocalStrings.LEAGUE10,
    [ALCHEMY_ACTIVITY] = LocalStrings.ALCHEMY_TEXT1[1],
    [BEATMICE_ACTIVITY] = LocalStrings.BEATMICE_TEXT1[1],
    [BLUEPRIVILEGE_ACTIVITY] = LocalStrings.LZTQ_TEXT1[1],
    [QQHALLPRIVILEGE_ACTIVITY] = LocalStrings.LZTQ_TEXT1[2],
    [SETCIECLE_ACTIVITY] = LocalStrings.SETCIRCLE_TEXT1[1],
    [GARDEN_ACTIVITY] = LocalStrings.GARDEN_TEXT1[1],
    [CAFFEE_ACTIVITY] = LocalStrings.CAFFEE_TEXT1[1],
    [BOWLING_ACTIVITY] = LocalStrings.BOWLING_TEXT1[1],
    [YEARPLAYER_ACTIVITY] = LocalStrings.YEARPLAYER_TEXT1[1],
    [WATERMELON_ACTIVITY] = LocalStrings.WATERMELON_TEXT1[1],
    [SECRETTOWER_ACTIVITY] = LocalStrings.SECRETTOWER_TEXT1[1],
    [MONEYTREE_ACTIVITY] = LocalStrings.MONEYTREE_TEXT1[1],
    [BILLIARDBALL_ACTIVITY] = LocalStrings.BILLIARDBALL_TEXT1[1],
    [DRESSGIVE_ACTIVITY] = LocalStrings.DRESSGIVE_TEXT1[1],
    [CRAZY_GASHAPON_ACTIVITY] = LocalStrings.CRAZY_GASHAPON_TEXT1[1],
    [MIDNIGHTDINER_ACTIVITY] = LocalStrings.MIDNIGHTDINER_TEXT1[1],
    [GOPHERBALL_ACTIVITY] = LocalStrings.GOPHERBALL_TEXT1[1],
    [NEWCUTELIST_ACTIVITY] = LocalStrings.GOPHERBALL_TEXT1[22],
    [BEINGIMMORTAL_ACTIVITY] = LocalStrings.BEINGIMMORTAL_TEXT1[1],
    [WORSHIPGOD_ACTIVITY] = LocalStrings.WORSHIPGOD_TEXT1[1],
    [CALABASH_ACTIVITY] = LocalStrings.CALABASH_TEXT1[1],
    [SPRINGOUTING_ACTIVITY] = LocalStrings.SPRINGOUTING_TEXT1[1],
    [THANKFULSIGN_ACTIVITY] = LocalStrings.SPRINGOUTING_TEXT1[19],
    [WELCOMEBACK_ACTIVITY] = LocalStrings.ACITVITY_WELCOME_BACK[1],
    [BEATBALLOON_ACTIVITY] = LocalStrings.BEATBALLOON_TEXT1[1],
    [DAZZLERANK_ACTIVITY] = LocalStrings.DAZZLERANK_TEXT1[1],
    [SUPER_SPECIAL_ACTIVITY] = LocalStrings.SUPER_SELL_ACTIVITY[1],
    [TEAMCONSUME_ACTIVITY] = LocalStrings.TEAMCONSUME_TEXT1[1],
    [SEAFARROAD_ACTIVITY] = LocalStrings.SEAFARROAD_TEXT1[1],
    [CLIMBTREE_ACTIVITY] = LocalStrings.CLIMBTREE_TEXT1[1],
    [SUMMERSURF_ACTIVITY] = LocalStrings.SUMMERSURF_TEXT1[1],
    [PLANETSEARCH_ACTIVITY] = LocalStrings.PLANETSEARCH_TEXT1[1],
    [SEVENYEAR_ACTIVITY] = LocalStrings.SEVENYEAR_TEXT1[1],
    [ZONGZI_ACTIVITY] = LocalStrings.ZONGZI_TEXT1[1],
    [SPECIFICSALES_ACTIVITY] = LocalStrings.SPECIFICSALES_TEXT1[1],
    [TRAMPOLINE_ACTIVITY] = LocalStrings.TRAMPOLINE_TEXT1[1],
    [GOLFBALL_ACTIVITY] = LocalStrings.GOLFBALL_TEXT1[1],
    [WISHING_BOTTLE_ACTIVITY] = LocalStrings.WISHING_BOTTLE_TEXT1[1],
    [DETECTIVE_ACTIVITY] = LocalStrings.DETECTIVE_TEXT1[1],
    [CATCHFISH_ACTIVITY] = LocalStrings.CATCHFISH_TEXT1[1],
    [EIGHTYEAR_ACTIVITY] = LocalStrings.EIGHTYEAR_TEXT1[1],
    [COLDDRINK_ACTIVITY] = LocalStrings.COLDDRINK_TEXT1[1],
    [ISLAND_UP_FLOWER_RANK] = LocalStrings.FLOWER_RANK_TEXT1[1],
    [FOOTBALL_SHOOT_ACTIVITY] = LocalStrings.FOOTBALL_SHOOT_TEXT1[1],
    [GROW_GIFT_ACTIVITY] = LocalStrings.GROW_GIFT_TEXT1[1],
    [HAPPY_MIDAUTUMN_ACTIVITY] = LocalStrings.HAPPY_MIDAUTUMN_TEXT1[1],
    [WEEKEND_SPECIAL_ACTIVITY] = LocalStrings.WEEKEND_SPECIAL_TEXT1[1],
    [MYSTERIOUS_SHOP_ACTIVITY] = LocalStrings.MYSTERIOUS_SHOP_TEXT1[1],
    [ZOO_SIGHTSEEING_ACTIVITY] = LocalStrings.ZOO_SIGHTSEEING_TEXT1[1],
    [WEEKEND_SPECIAL_ACTIVITY2] = LocalStrings.WEEKEND_SPECIAL_TWO_TEXT1[1],
    [GONGANDDRUM_ACTIVITY] = LocalStrings.GONGANDDRUM_TEXT1[1],
    [GOLD_MINER_ACTIVITY] = LocalStrings.GOLD_MINER_TEXT1[1],
    [DEEPSEA_ACTIVITY] = LocalStrings.DEEPSEA_TEXT1[1],
    [CHESS_ACTIVITY] = LocalStrings.CHESS_ACTIVITY_TEXT1[1],
    [AUTUMNCAMP_ACTIVITY] = LocalStrings.AUTUMNCAMP_TEXT1[1],
    [HOTBASKETBALL_ACTIVITY] = LocalStrings.HOTBASKETBALL_TEXT1[1],
    [FLY_KITES_ACTIVITY] = LocalStrings.FLYKITES_TEXT1[1],
    [THROWPOT_ACTIVITY] = LocalStrings.THROWPOT_TEXT1[1],
    [CATCHFISH_ACTIVITY] = LocalStrings.CATCHFISH_TEXT1[1],
    [BIKEMATCH_ACTIVITY] = LocalStrings.BIKEMATCH_TEXT1[1],
    [LASHTOP_ACTIVITY] = LocalStrings.LASHTOP_TEXT1[1],
    [RABBIT_GIFT_ACTIVITY] = LocalStrings.RABBIT_GIFT_TEXT1[1],
    [LUCKY_FLIP_ACTIVITY] = LocalStrings.LUCKY_FLIP_TEXT1[1],
    [BRAVING_TOWER_ACTIVITY] = LocalStrings.BRAVING_TOWER_TEXT1[1],
    [KICKINGBIRDIE_ACTIVITY] = LocalStrings.KICKING_BIRDIE_TEXT1[1],
    [MAGICCLASSROOM_ACTIVITY] = LocalStrings.MAGIC_CLASSROOM_TEXT1[1],
    [MAKESNOWMAN_ACTIVITY] = LocalStrings.MAKE_SHOWMAN_TEXT1[1],
    [PIANIST_ACTIVITY] = LocalStrings.PIANIST_TEXT1[1],
    [CERAMIC_WORKSHOP_ACTIVITY] = LocalStrings.CERAMIC_WORKSHOP_TEXT1[1],
    [WEIGHTLIFTING_ACTIVITY] = LocalStrings.WEIGHTLIFTING_TEXT1[1],
    [ARCTIC_EXPLORATION_ACTIVITY] = LocalStrings.ARCTIC_EXPLORATION_TEXT1[1],
    [BUILDING_BLOCKS_ACTIVITY] = LocalStrings.BUILDING_BLOCKS_TEXT1[1],
    [SWORD_CASTING_MASTER_ACTIVITY] = LocalStrings.CASTING_MASTER_ACTIVITY_TEXT1[1],
    [BOATING_LAKE_ACTIVITY] = LocalStrings.BOATING_LAKE_TEXT1[1],
    [BLOW_BUBBLES_ACTIVITY] = LocalStrings.BLOW_BUBBLES_TEXT1[1],
    [PICKTEA_ACTIVITY] = LocalStrings.PICKTEA_TEXT1[1],
    [AFFORESTATION_ACTIVITY] = LocalStrings.AFFORESTATION_TEXT1[1],
    [POTIONS_REFININ_ACTIVITY] = LocalStrings.POTIONS_REFININ_TEXT1[1],
    [JEWELRY_ACTIVITY] = LocalStrings.JEWELRY_TEXT1[1],
}

--@brief    根据按钮id创建一个按=钮common_icon_yjkwz
--@param    nButtonId, 按钮id
--@param    bIsHighlight, 是否高亮
--@return   #1, 按钮的节点引用
function WndOwnCity:_createIconButton(nButtonId, bIsHighlight)
    WZLog("WndOwnCity:_createIconButton one", nButtonId, tostring(g_isRegist), tostring(bIsHighlight), tostring(tBtnImgPath[nButtonId]))

    local conBtn = WZUISystem:getInstance():createElement("conBtn_WndOwnCity")
    local conBtn = WZUIContainer:luaTo(conBtn)
    conBtn:setName("con"..nButtonId.."_WndOwnCity")
    if conBtn == nil or tBtnImgPath[nButtonId] == nil then
        return
    end
    conBtn:setVisible(true)

    WZLog("WndOwnCity:_createIconButton two", "btn"..nButtonId.."_WndOwnCity")
    local btn = GetElement(conBtn, "btn_WndOwnCity", WZUIButton)
    btn:setName("btn"..nButtonId.."_WndOwnCity")
    btn:setLuaDoneFunctionName(tBtnClickFunc[nButtonId])
    local imgIconNormal = GetElement(btn, "imgIconNormal_WndOwnCity", WZUIImage)
    imgIconNormal:setFile(tBtnImgPath[nButtonId]..".png")
    local imgIconSe = GetElement(btn, "imgIconSel_WndOwnCity", WZUIImage)
    imgIconSe:setFile(tBtnImgPath[nButtonId]..".png")

    local imgIconNormalName
    local imgIconSeName
    if tBtnImgNamePath[nButtonId] then
        txtIconNormalName = GetElement(btn, "txtIconNameNormal_WndOwnCity", WZUILabelTTF)
        txtIconNormalName:setText(tBtnImgNamePath[nButtonId])
        txtIconSeName = GetElement(btn, "txtIconNameSel_WndOwnCity", WZUILabelTTF)
        txtIconSeName:setText(tBtnImgNamePath[nButtonId])
        if ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "vn" then
            txtIconNormalName:setScale(0.7)
            txtIconSeName:setScale(0.7)
        end
    end

    if nButtonId == ISLAND_UP_RECHARGE then
        GlobalGame.g_bIsNoFirstRechange = true
    end

    local tTempButtonId = {ISLAND_UP_RECHARGE, ISLAND_UP_FIRST_RECHARGE, ISLAND_UP_INVESTREBATE, ISLAND_UP_HAPPYSHAKE, ISLAND_UP_CRAZY_DOUBLING, DOUBLE_SEVEN_CONFREE, ISLAND_UP_AUCTION_HOUSE, NATIONAL_FESTIVAL, NATIONAL_ANSWER, ISLAND_UP_OPPO_AMBERPLAYER, PEOPLESHOP, TREASURESEARCH, EVERYDAYBUY, NEWYEARDAY, FEBRUARYNEWYEAR, DOLLMACHINE, ACTIVITYLIMITLOGIN, ACTIVITYNEWRECHARGE, REBACKACTIVITY, FIGHT_ACTIVITY, RISE_ACTIVITY, ACTIVITY_SHOOT_ARROW, HORARY_ACTIVITY, MIDFESTIVAL_ACTIVITY, FISH_ACTIVITY, PELLET_ACTIVITY, HOUSEINVEST_ACTIVITY, WATERCOUNTRY_ACTIVITY, DECORATIONS_ACTIVITY, YEARMONSTER_ACTIVITY, NEWYEARWISH_ACTIVITY, BEATENGINEER_ACTIVITY, ALCHEMY_ACTIVITY, BEATMICE_ACTIVITY, BLUEPRIVILEGE_ACTIVITY, QQHALLPRIVILEGE_ACTIVITY, SETCIECLE_ACTIVITY, GARDEN_ACTIVITY, CAFFEE_ACTIVITY, BOWLING_ACTIVITY, YEARPLAYER_ACTIVITY, WATERMELON_ACTIVITY, SECRETTOWER_ACTIVITY, MONEYTREE_ACTIVITY, BILLIARDBALL_ACTIVITY, DRESSGIVE_ACTIVITY, CRAZY_GASHAPON_ACTIVITY, MIDNIGHTDINER_ACTIVITY, GOPHERBALL_ACTIVITY, NEWCUTELIST_ACTIVITY, BEINGIMMORTAL_ACTIVITY, WORSHIPGOD_ACTIVITY, CALABASH_ACTIVITY, SPRINGOUTING_ACTIVITY, THANKFULSIGN_ACTIVITY, WELCOMEBACK_ACTIVITY, BEATBALLOON_ACTIVITY, DAZZLERANK_ACTIVITY, TEAMCONSUME_ACTIVITY, SEAFARROAD_ACTIVITY, SUPER_SPECIAL_ACTIVITY, CLIMBTREE_ACTIVITY, SUMMERSURF_ACTIVITY, PLANETSEARCH_ACTIVITY, SEVENYEAR_ACTIVITY, ZONGZI_ACTIVITY, SPECIFICSALES_ACTIVITY, TRAMPOLINE_ACTIVITY, GOLFBALL_ACTIVITY, WISHING_BOTTLE_ACTIVITY, DETECTIVE_ACTIVITY, GONGANDDRUM_ACTIVITY, GOLD_MINER_ACTIVITY, DEEPSEA_ACTIVITY, CHESS_ACTIVITY, AUTUMNCAMP_ACTIVITY, HOTBASKETBALL_ACTIVITY, FLY_KITES_ACTIVITY, THROWPOT_ACTIVITY, CATCHFISH_ACTIVITY, BIKEMATCH_ACTIVITY, LASHTOP_ACTIVITY, EIGHTYEAR_ACTIVITY, LEIZHUZHEN_ACTIVITY, COLDDRINK_ACTIVITY}
    for i = 1, GetTableLen(g_tAloneActivity) do
        table.insert(tTempButtonId, g_tAloneActivity[i])
    end
    if (nButtonId == ISLAND_UP_BINDING and g_isRegist ~= true) and ProjConfig.LANGUAGE ~= "vn" then
        GetElement(conBtn, "armaBtn_WndOwnCity", WZArmature):setVisible(true)
    -- elseif nButtonId == ISLAND_UP_BINDING and ProjConfig.LANGUAGE == "vn" then
    --     GetElement(conBtn, "armaBtn_WndOwnCity", WZArmature):setVisible(true)
    elseif nButtonId == ISLAND_UP_BINDING and g_isRegist == true then
        return
    elseif utilsValueInTable(nButtonId, tTempButtonId) then
        local y = 0.2
        local yArma = 0
        -- imgIconNormalName:setRelativePositionLuaTo(0.5,y)
        -- imgIconSeName:setRelativePositionLuaTo(0.5,y)

        local anim = BattleAnimation:createAnimation("ui_main_iconeffect", false, "city")
        local armature = anim.m_node
        armature:setName("armaFirstRechangeNormal_WndOwnCity")
        armature:setUseOriginSize(true)
        armature:setAnchorPoint(GlobalMethod:ccp(0.5,yArma))
        armature:setTouchEnable(false)
        armature:setAnimationName("animation")
        armature:setLoop(true)
        GetElement(conBtn, "conNormal_WndOwnCity", WZUIContainer):addChild(armature)
        GetElement(conBtn, "conNormal_WndOwnCity", WZUIContainer):setZOrder(2)

        local anim = BattleAnimation:createAnimation("ui_main_iconeffect", false, "city")
        local armature = anim.m_node
        armature:setName("armaFirseRechangeSel_WndOwnCity")
        armature:setUseOriginSize(true)
        armature:setAnchorPoint(GlobalMethod:ccp(0.5,yArma))
        armature:setTouchEnable(false)
        armature:setAnimationName("animation")
        armature:setLoop(true)
        GetElement(conBtn, "conSel_WndOwnCity", WZUIContainer):addChild(armature)
        GetElement(conBtn, "conSel_WndOwnCity", WZUIContainer):setZOrder(2)
    elseif nButtonId == ISLAND_UP_CARD_WELFARE then
    elseif nButtonId == ISLAND_UP_MONTHCARD or nButtonId == ISLAND_UP_MTO then
    elseif nButtonId == ISLAND_UP_MONTHCARD or nButtonId == ISLAND_UP_CARD_WELFARE then
        local y = 0.2
        local yArma = 0
        -- imgIconNormalName:setRelativePositionLuaTo(0.5,y)
        -- imgIconSeName:setRelativePositionLuaTo(0.5,y)

        local anim = BattleAnimation:createAnimation("ui_main_iconeffect", false, "city")
        local armature = anim.m_node
        armature:setName("armaWelfareNormal_WndOwnCity")
        armature:setUseOriginSize(true)
        armature:setAnchorPoint(GlobalMethod:ccp(0.5,yArma))
        armature:setTouchEnable(false)
        armature:setAnimationName("animation")
        armature:setLoop(true)
        armature:setTag(99)
        GetElement(conBtn, "conNormal_WndOwnCity", WZUIContainer):addChild(armature)
        GetElement(conBtn, "conNormal_WndOwnCity", WZUIContainer):setZOrder(2)
        self.m_tArmatureCardWelfare = armature

        local anim = BattleAnimation:createAnimation("ui_main_iconeffect", false, "city")
        local armature2 = anim.m_node
        armature2:setName("armaWelfareSel_WndOwnCity")
        armature2:setUseOriginSize(true)
        armature2:setAnchorPoint(GlobalMethod:ccp(0.5,yArma))
        armature2:setTouchEnable(false)
        armature2:setAnimationName("animation")
        armature2:setLoop(true)
        armature2:setTag(98)
        GetElement(conBtn, "conSel_WndOwnCity", WZUIContainer):addChild(armature2)
        GetElement(conBtn, "conSel_WndOwnCity", WZUIContainer):setZOrder(2)
        self.m_tArmatureCardWelfare2 = armature2

        WZLog("WndOwnCity:_createIconButton three-1", tostring(CacheCenter:getPlayerItemById(50)), tostring(CacheCenter:getPlayerItemById(52)), tostring(CacheCenter:getPlayerItemById(55)), tostring(CacheCenter:getPlayerItemById(56)))
        if CacheCenter:getPlayerItemById(50) == nil or CacheCenter:getPlayerItemById(52) == nil or 
            CacheCenter:getPlayerItemById(55) == nil or CacheCenter:getPlayerItemById(56) == nil then
            armature:setVisible(true)
            armature2:setVisible(true)
        else
            armature:setVisible(false)
            armature2:setVisible(false)
        end
    elseif nButtonId == ISLAND_UP_MATCH then
        local anim = BattleAnimation:createAnimation("ui_main_iconeffect", false, "city")
        local armature = anim.m_node
        armature:setName("armaMatchNormal_WndOwnCity")
        armature:setUseOriginSize(true)
        armature:setAnchorPoint(GlobalMethod:ccp(0.5,yArma))
        armature:setTouchEnable(false)
        armature:setAnimationName("animation")
        armature:setLoop(true)
        GetElement(conBtn, "conNormal_WndOwnCity", WZUIContainer):addChild(armature)
        GetElement(conBtn, "conNormal_WndOwnCity", WZUIContainer):setZOrder(2)
        armature:setVisible(false)

        local anim = BattleAnimation:createAnimation("ui_main_iconeffect", false, "city")
        local armature = anim.m_node
        armature:setName("armaReMatchSel_WndOwnCity")
        armature:setUseOriginSize(true)
        armature:setAnchorPoint(GlobalMethod:ccp(0.5,yArma))
        armature:setTouchEnable(false)
        armature:setAnimationName("animation")
        armature:setLoop(true)
        GetElement(conBtn, "conSel_WndOwnCity", WZUIContainer):addChild(armature)
        GetElement(conBtn, "conSel_WndOwnCity", WZUIContainer):setZOrder(2)
        armature:setVisible(false)
    end
    return conBtn
end

local btnIndex =
{
    [ISLAND_LEFT_MESSAGE] = "Notice",
    [ISLAND_LEFT_MAIL] = "Mail",
    [ISLAND_LEFT_FRIEND] = "Friend",
    [ISLAND_LEFT_TEACH] = "Guide",
    [ISLAND_LEFT_SETTING] = "Set",
    [ISLAND_LEFT_FB] = "Fb",
    [ISLAND_LEFT_HELPER] = "Helper",
    [ISLAND_LEFT_4399] = "4399",
    [ISLAND_LEFT_FB] = "Fb",
    [ISLAND_LEFT_GROUP] = "Group",
    [ISLAND_LEFT_SURVEY] = "Survey",
}

--@brief    更新左菜单UI界面
function WndOwnCity:_update()
    
    if self.m_root == nil then
        return
    end
    self.m_nIndex = 0
    self.m_tBtnList = {}
    self:_setDefaultBtnsInfo()
    WZLog("WndOwnCity:_update zero", tostring(GlobalGame.g_bIsGetFirstRecharge), CacheCenter:getMouthCardDays(), tonumber(CacheCenter:getGameParam().limitMonthlyCardDay))

    local flcBtns = GetElement(self.m_root, "flcBtns_WndOwnCity", WZUIFreeListContainer)
    if flcBtns then
        flcBtns:removeAll()
    end
    local conFirstRecharge = GetElement(self.m_root, "con65_WndOwnCity", WZUIContainer)
    local conVip17 = GetElement(self.m_root, "con17_WndOwnCity", WZUIContainer)
    if conFirstRecharge then 
        conFirstRecharge:removeFromParentAndCleanup(true)
    end
    if conVip17 then 
        conVip17:removeFromParentAndCleanup(true)
    end
    local nTag = 0
    local offsetX = 0.21
    local indexNo = 0
    local index = 0
    local bAddRecharge = false 
    local tTempButtonId = {ISLAND_UP_MAGIC_STONE, ISLAND_UP_INVESTREBATE, ISLAND_UP_HAPPYSHAKE, ISLAND_UP_ONE_YUAN, ISLAND_UP_CRAZY_DOUBLING, ISLAND_UP_AUCTION_HOUSE, DOUBLE_SEVEN_CONFREE, NATIONAL_FESTIVAL, NATIONAL_ANSWER, ISLAND_UP_OPPO_AMBERPLAYER, PEOPLESHOP, TREASURESEARCH, EVERYDAYBUY, NEWYEARDAY, FEBRUARYNEWYEAR, DOLLMACHINE, ACTIVITYLIMITLOGIN, ACTIVITYNEWRECHARGE, REBACKACTIVITY, FIGHT_ACTIVITY, RISE_ACTIVITY, ACTIVITY_SHOOT_ARROW, HORARY_ACTIVITY, MIDFESTIVAL_ACTIVITY, FISH_ACTIVITY, PELLET_ACTIVITY, HOUSEINVEST_ACTIVITY, ISLAND_UP_LEAGUE, BLUEPRIVILEGE_ACTIVITY, EIGHTYEAR_ACTIVITY, LEIZHUZHEN_ACTIVITY, COLDDRINK_ACTIVITY, WATERCOUNTRY_ACTIVITY, DECORATIONS_ACTIVITY, YEARMONSTER_ACTIVITY, NEWYEARWISH_ACTIVITY, BEATENGINEER_ACTIVITY, ISLAND_UP_LEAGUE, ALCHEMY_ACTIVITY, BEATMICE_ACTIVITY, BLUEPRIVILEGE_ACTIVITY, QQHALLPRIVILEGE_ACTIVITY, SETCIECLE_ACTIVITY, GARDEN_ACTIVITY, CAFFEE_ACTIVITY, BOWLING_ACTIVITY, YEARPLAYER_ACTIVITY, WATERMELON_ACTIVITY, SECRETTOWER_ACTIVITY, MONEYTREE_ACTIVITY, DRESSGIVE_ACTIVITY, BILLIARDBALL_ACTIVITY, MIDNIGHTDINER_ACTIVITY, GOPHERBALL_ACTIVITY, NEWCUTELIST_ACTIVITY, BEINGIMMORTAL_ACTIVITY, WORSHIPGOD_ACTIVITY, CRAZY_GASHAPON_ACTIVITY, CALABASH_ACTIVITY, SPRINGOUTING_ACTIVITY, THANKFULSIGN_ACTIVITY, WELCOMEBACK_ACTIVITY, BEATBALLOON_ACTIVITY, DAZZLERANK_ACTIVITY, TEAMCONSUME_ACTIVITY, SEAFARROAD_ACTIVITY, SUPER_SPECIAL_ACTIVITY, CLIMBTREE_ACTIVITY, SUMMERSURF_ACTIVITY, PLANETSEARCH_ACTIVITY, SEVENYEAR_ACTIVITY, ZONGZI_ACTIVITY, SPECIFICSALES_ACTIVITY, TRAMPOLINE_ACTIVITY, GOLFBALL_ACTIVITY, WISHING_BOTTLE_ACTIVITY, DETECTIVE_ACTIVITY, GONGANDDRUM_ACTIVITY, GOLD_MINER_ACTIVITY, DEEPSEA_ACTIVITY, CHESS_ACTIVITY, HOTBASKETBALL_ACTIVITY, AUTUMNCAMP_ACTIVITY, FLY_KITES_ACTIVITY, THROWPOT_ACTIVITY, CATCHFISH_ACTIVITY, BIKEMATCH_ACTIVITY, LASHTOP_ACTIVITY}
    for i = 1, GetTableLen(g_tAloneActivity) do
        table.insert(tTempButtonId, g_tAloneActivity[i])
    end

    for i,v in ipairs(self.m_tBtnsInfo) do
        WZLog("WndOwnCity:_update three", v.buttonId, GlobalMethod:crossServiceOpen(), v.buttonChannel, ProjConfig.CHANNEL_ID, checkbuttonChannel(v.buttonChannel))
            
        local conFirst = GetElement(self.m_root, "con65_WndOwnCity", WZUIContainer)
        local conVip = GetElement(self.m_root, "con17_WndOwnCity", WZUIContainer)
        WZLog("WndOwnCity:_update five", type(conFirst), type(conVip))
        if ((CheckButtonOpen(v.buttonId ,false) or TeachGroup1.ISTEACHMODE == true) and 
            (v.buttonId == ISLAND_UP_BINDING and g_isRegist ~= true or v.buttonId ~= ISLAND_UP_BINDING --[[or ProjConfig.LANGUAGE == "vn"--]]) and 
            (v.buttonId ~= ISLAND_UP_FIRST_RECHARGE or conVip == nil and GlobalGame.g_bIsNoFirstRechange == false) and 
            (v.buttonId ~= ISLAND_UP_MONTHCARD or v.buttonId == ISLAND_UP_MONTHCARD and false) and
            (v.buttonId ~= ISLAND_UP_RECHARGE or conFirst == nil) and
            (v.buttonId ~= ISLAND_UP_FUND or CacheCenter:getFundFinish() ~= true) and
            (v.buttonId ~= ISLAND_UP_MATCH or tonumber(GlobalMethod:crossServiceOpen()) == 1) and
            (v.buttonId ~= ISLAND_EXTEND_CHARM or tonumber(GlobalMethod:crossServiceOpen()) == 1) and
            (v.buttonId ~= ISLAND_UP_ELITE_SHOP or (IsNewHeroControl() and g_bloc_shop == "true" or (not IsNewHeroControl()) )) and
            (v.buttonId ~= ISLAND_UP_PRAY or (IsNewHeroControl() and g_bloc_pray == "true" )) and
            checkbuttonChannel(v.buttonChannel) and (v.buttonId ~= ISLAND_UP_QUESTION or GlobalGame.g_questionOpen == true) and 
            (not utilsValueInTable(v.buttonId, tTempButtonId))) then

            local isCon = GetElement(self.m_root, "con".. v.buttonId .."_WndOwnCity", WZUIContainer)

            local conBtn = isCon and isCon or self:_createIconButton(v.buttonId, false)
            --add by wuweidong 
            --签到图标处理
            if v.buttonId == ISLAND_UP_ATTENDANCE then 
                GlobalGame:getBtnRedPointEvent():regListener("Sign","WndOwnCity",conBtn,nil)
                local SignState =  CacheCenter:getRedState( "btnSign" )
                GlobalGame:getBtnRedPointEvent():dispatcher("Sign",SignState)
            end

            if v.buttonId == ISLAND_UP_EVENT then
                GlobalGame:getBtnRedPointEvent():regListener("GameActivity","WndOwnCity",conBtn,nil)
            end

            --add by wuweidong end 
            if conBtn ~= nil then
                index = index + 1

                conBtn.index = index
                conBtn.btnId = v.buttonId
                if isCon then
                    conBtn:setVisible(true)
                else
                    flcBtns:pushBack(conBtn)
                end
                table.insert(self.m_tBtnList, conBtn)
                self.m_nIndex = self.m_nIndex + 1
                WZLog("WndOwnCity:_update FOUR", i, v.buttonId, tostring(isCon), index, indexNo, 1-offsetX * (i - 1- indexNo), tostring(conFirst), tostring(conVip))
            end
        else
            indexNo = indexNo+ 1
        end
    end

    local conWishWell = GetElement(self.m_root, "con113_WndOwnCity", WZUIContainer)
    if conWishWell then
        GlobalGame:getBtnRedPointEvent():regListener("WishWell","WndOwnCity",conWishWell,nil)
        GlobalGame:getBtnRedPointEvent():dispatcher("WishWell",{[1]=CacheCenter:isOpenPromiseRedPoint(), [2]=CacheCenter:isOpenPromise()})
    end

    for i,v in ipairs(self.m_tLeftBtnsInfo) do
        if v.buttonId == 129 and SceneCity:checkIconButtonOpen(v) then --129问卷调查按钮
            GetElement(self.m_root, "conBtnSurvey_WndOwnCity", WZUIContainer):setVisible(true)
        end
    end
	
    local conNetSignal = GetElement(self.m_root, "conNetSignal_WndOwnCity", WZUIContainer)
    conNetSignal:setRelativePosition(GlobalMethod:ccp(0.96,0.98))
    if IsIphoneX() then
        conNetSignal:setRelativePosition(GlobalMethod:ccp(0.95,0.98))
    end
    CellNetSignal:showInterface(conNetSignal, nil, 1)

    WndOwnCity:checkSevenDay()
    WndOwnCity:setExtraInfoForBtn()
end

function WndOwnCity:openFootball(isOpen)
    if WndOwnCity.m_root == nil then return end 
    
    isOpen = isOpen and CheckButtonShow(ISLAND_UP_FOOT_BALL, true)
    WZLog("WndOwnCity:openFootball", isOpen, tostring(WndOwnCity.m_root))
    if WndOwnCity.m_root then
        local con147 = GetElement(self.m_root, "con147_WndOwnCity", WZUIContainer)
        if con147 then 
            local isVisible = con147:isVisible()
            if isOpen and isVisible == false then
                GetElement(self.m_root, "con147_WndOwnCity", WZUIButton):setVisible(true)
            elseif not isOpen and isVisible == true then
                GetElement(self.m_root, "con147_WndOwnCity", WZUIButton):setVisible(false)
            end
        end
    end
end

function WndOwnCity:isFootball()
    local isFootball = tonumber(GlobalGame.g_autoFootballActivity or 0) == 1

    isFootball = isFootball and CheckButtonShow(147, true)

    return isFootball
end

--@brief    是否开启回归活动
function WndOwnCity:openBackActivity(isOpen)
    if WndOwnCity.m_root == nil then return end 
    
    isOpen = isOpen and CheckButtonShow(ISLAND_UP_BACK_ACTIVITY, true)
    WZLog("WndOwnCity:openBackActivity", isOpen)
    if WndOwnCity.m_root then
        local con149 = GetElement(self.m_root, "con149_WndOwnCity", WZUIContainer)
        if con149 then 
            local isVisible = con149:isVisible()
            if isOpen and isVisible == false then
                GetElement(self.m_root, "con149_WndOwnCity", WZUIButton):setVisible(true)
            elseif not isOpen and isVisible == true then
                GetElement(self.m_root, "con149_WndOwnCity", WZUIButton):setVisible(false)
            end
        end
    end
end

function WndOwnCity:openQuestion(isOpen)
    if WndOwnCity.m_root == nil then return end 
    
    isOpen = isOpen and CheckButtonShow(ISLAND_UP_QUESTION, true)
    WZLog("WndOwnCity:openQuestion", isOpen)
    if WndOwnCity.m_root then
        local con154 = GetElement(self.m_root, "con" .. ISLAND_UP_QUESTION .. "_WndOwnCity", WZUIContainer)
        if isOpen then 
            if con154 == nil then 
                local flcBtns = GetElement(self.m_root, "flcBtns_WndOwnCity", WZUIFreeListContainer)
                local conBtn = self:_createIconButton(ISLAND_UP_QUESTION, false)
                flcBtns:pushBack(conBtn)
                conBtn.btnId = ISLAND_UP_QUESTION
                table.insert(self.m_tBtnList, conBtn)
                self.m_nIndex = self.m_nIndex + 1
            else
                con154:setVisible(true)
            end
        else
            if con154 then 
                con154:setVisible(false)
            end
        end
    end
end

function WndOwnCity:openOther()
    if WndOwnCity.m_root == nil then return end 
    
    local isOpen161 = g_cityExtenInfo ~= nil and g_cityExtenInfo.magicStoneStatus ~= nil and g_cityExtenInfo.magicStoneStatus ~= 0 and CheckButtonShow(ISLAND_UP_MAGIC_STONE, true)
    local isOpen162 = g_cityExtenInfo ~= nil and g_cityExtenInfo.IRStatus ~= nil and g_cityExtenInfo.IRStatus ~= 0 and CheckButtonShow(ISLAND_UP_INVESTREBATE, true)
    local isOpen164 = g_cityExtenInfo ~= nil and g_cityExtenInfo.activityPokerStatus ~= nil and g_cityExtenInfo.activityPokerStatus ~= 0 and CheckButtonShow(ISLAND_UP_HAPPYSHAKE, true)
    local isOpen173 = g_cityExtenInfo ~= nil and g_cityExtenInfo.oneYuanLuckyActivity ~= nil and g_cityExtenInfo.oneYuanLuckyActivity ~= 0 and CheckButtonShow(ISLAND_UP_ONE_YUAN, true)
    local isOpen176 = g_cityExtenInfo ~= nil and g_cityExtenInfo.CDStatus ~= nil and g_cityExtenInfo.CDStatus ~= 0 and CheckButtonShow(ISLAND_UP_CRAZY_DOUBLING, true)
    local isOpen177 = g_cityExtenInfo ~= nil and g_cityExtenInfo.auction ~= ninil and g_cityExtenInfo.auction ~= nil and g_cityExtenInfo.auction ~= 0 and CheckButtonShow(ISLAND_UP_AUCTION_HOUSE, true)
    local isOpen178 = g_cityExtenInfo ~= nil and g_cityExtenInfo.qiXiActivity ~= nil and g_cityExtenInfo.qiXiActivity ~= 0 and CheckButtonShow(DOUBLE_SEVEN_CONFREE, true)
    local isOpen183 = g_cityExtenInfo ~= nil and g_cityExtenInfo.rechargeSignInActivity ~= nil and g_cityExtenInfo.rechargeSignInActivity ~= 0 and CheckButtonShow(NATIONAL_FESTIVAL, true)
    local isOpen184 = g_cityExtenInfo ~= nil and g_cityExtenInfo.funAnswerActivity ~= nil and g_cityExtenInfo.funAnswerActivity ~= 0 and CheckButtonShow(NATIONAL_ANSWER, true)
    local isOpen185 = GlobalMethod:getIsShowOVAmberPlayer()
    local isOpen186 = g_cityExtenInfo ~= nil and g_cityExtenInfo.shoppingActivity ~= nil and g_cityExtenInfo.shoppingActivity ~= 0 and CheckButtonShow(PEOPLESHOP, true)
    local isOpen187 = g_cityExtenInfo ~= nil and g_cityExtenInfo.treasureActivity ~= nil and g_cityExtenInfo.treasureActivity ~= 0 and CheckButtonShow(TREASURESEARCH, true)
    local isOpen189 = g_cityExtenInfo ~= nil and g_cityExtenInfo.Activity6120 ~= nil and g_cityExtenInfo.Activity6120 ~= 0 and CheckButtonShow(NEWYEARDAY, true)
    local isOpen190 = g_cityExtenInfo ~= nil and g_cityExtenInfo.dailyBuyActivity ~= nil and g_cityExtenInfo.dailyBuyActivity ~= 0 and CheckButtonShow(EVERYDAYBUY, true)
    local isOpen192 = g_cityExtenInfo ~= nil and g_cityExtenInfo.activityLabel10 ~= nil and g_cityExtenInfo.activityLabel10 ~= 0 and CheckButtonShow(FEBRUARYNEWYEAR, true)
    local isOpen193 = g_cityExtenInfo ~= nil and g_cityExtenInfo.activity7008 ~= nil and g_cityExtenInfo.activity7008 ~= 0
    local isOpen194 = g_cityExtenInfo ~= nil and g_cityExtenInfo.activity7009 ~= nil and g_cityExtenInfo.activity7009 ~= 0
    local isOpen195 = g_cityExtenInfo ~= nil and g_cityExtenInfo.activity7010 ~= nil and g_cityExtenInfo.activity7010 ~= 0
    local isOpen196 = g_cityExtenInfo ~= nil and g_cityExtenInfo.activity7013 ~= nil and g_cityExtenInfo.activity7013 ~= 0
    local isOpen197 = g_cityExtenInfo ~= nil and g_cityExtenInfo.activity7012 ~= nil and g_cityExtenInfo.activity7012 ~= 0
    local isOpen198 = g_cityExtenInfo ~= nil and g_cityExtenInfo.activityLabel11 ~= nil and g_cityExtenInfo.activityLabel11 ~= 0
    local isOpen199 = g_cityExtenInfo ~= nil and g_cityExtenInfo.activity7018 ~= nil and g_cityExtenInfo.activity7018 ~= 0
    local isOpen119 = g_cityExtenInfo ~= nil and g_cityExtenInfo.ActivityWorldCup ~= nil and g_cityExtenInfo.ActivityWorldCup ~= 0 and CheckButtonShow(ISLAND_UP_FOOT_BALL, true)
    local isOpen120 = g_cityExtenInfo ~= nil and g_cityExtenInfo.activity7019 ~= nil and g_cityExtenInfo.activity7019 ~= 0
    local isOpen121 = g_cityExtenInfo ~= nil and g_cityExtenInfo.activity7020 ~= nil and g_cityExtenInfo.activity7020 ~= 0
    local isOpen122 = g_cityExtenInfo ~= nil and g_cityExtenInfo.activity7023 ~= nil and g_cityExtenInfo.activity7023 ~= 0
    local isOpen123 = g_cityExtenInfo ~= nil and g_cityExtenInfo.activityLabel12 ~= nil and g_cityExtenInfo.activityLabel12 ~= 0
    local isOpen124 = g_cityExtenInfo ~= nil and g_cityExtenInfo.activity7024 ~= nil and g_cityExtenInfo.activity7024 ~= 0
    local isOpen125 = g_cityExtenInfo ~= nil and g_cityExtenInfo.activity7028 ~= nil and g_cityExtenInfo.activity7028 ~= 0
    local isOpen126 = g_cityExtenInfo ~= nil and g_cityExtenInfo.activity7029 ~= nil and g_cityExtenInfo.activity7029 ~= 0
    local isOpen134 = g_cityExtenInfo ~= nil and g_cityExtenInfo.activityLabel21 ~= nil and g_cityExtenInfo.activityLabel21 ~= 0
    local isOpen135 = g_cityExtenInfo ~= nil and g_cityExtenInfo.activityLabel22 ~= nil and g_cityExtenInfo.activityLabel22 ~= 0
    local isOpen136 = g_cityExtenInfo ~= nil and (g_cityExtenInfo.activity7120 ~= nil and g_cityExtenInfo.activity7120 ~= 0 or g_cityExtenInfo.activity7121 ~= nil and g_cityExtenInfo.activity7121 ~= 0 or g_cityExtenInfo.activity7122 ~= nil and g_cityExtenInfo.activity7122 ~= 0 or g_cityExtenInfo.activity7123 ~= nil and g_cityExtenInfo.activity7123 ~= 0)
    local isOpen233 = g_cityExtenInfo ~= nil and g_cityExtenInfo.Activity5019 ~= nil and g_cityExtenInfo.Activity5019 ~= 0 and CheckButtonShow(ISLAND_UP_FLOWER_RANK, true)

    local tTempActivityType = g_tAloneActivity
    if WndOwnCity.m_root then
        self:createMainIcon(isOpen161, ISLAND_UP_MAGIC_STONE)

        local con162 = GetElement(self.m_root, "con" .. ISLAND_UP_INVESTREBATE .. "_WndOwnCity", WZUIContainer)
        if isOpen162 then 
            if con162 == nil then 
                local flcBtns = GetElement(self.m_root, "flcBtns_WndOwnCity", WZUIFreeListContainer)
                local conBtn = self:_createIconButton(ISLAND_UP_INVESTREBATE, false)
                flcBtns:pushBack(conBtn)
                conBtn.btnId = ISLAND_UP_INVESTREBATE
                table.insert(self.m_tBtnList, conBtn)
                self.m_nIndex = self.m_nIndex + 1
            else
                con162:setVisible(true)
            end
        else
            if con162 then 
                con162:setVisible(false)
            end
        end
        local con164 = GetElement(self.m_root, "con" .. ISLAND_UP_HAPPYSHAKE .. "_WndOwnCity", WZUIContainer)
        if isOpen164 then 
            if con164 == nil then 
                local flcBtns = GetElement(self.m_root, "flcBtns_WndOwnCity", WZUIFreeListContainer)
                local conBtn = self:_createIconButton(ISLAND_UP_HAPPYSHAKE, false)
                flcBtns:pushBack(conBtn)
                conBtn.btnId = ISLAND_UP_HAPPYSHAKE
                table.insert(self.m_tBtnList, conBtn)
                self.m_nIndex = self.m_nIndex + 1
            else
                con164:setVisible(true)
            end
        else
            if con164 then 
                con164:setVisible(false)
            end
        end
        local con173 = GetElement(self.m_root, "con" .. ISLAND_UP_ONE_YUAN .. "_WndOwnCity", WZUIContainer)
        if isOpen173 then 
            if con173 == nil then 
                local flcBtns = GetElement(self.m_root, "flcBtns_WndOwnCity", WZUIFreeListContainer)
                local conBtn = self:_createIconButton(ISLAND_UP_ONE_YUAN, false)
                flcBtns:pushBack(conBtn)
                conBtn.btnId = ISLAND_UP_ONE_YUAN
                table.insert(self.m_tBtnList, conBtn)
                self.m_nIndex = self.m_nIndex + 1
            else
                con173:setVisible(true)
            end
        else
            if con173 then 
                con173:setVisible(false)
            end
        end
        local con176 = GetElement(self.m_root, "con" .. ISLAND_UP_CRAZY_DOUBLING .. "_WndOwnCity", WZUIContainer)
        if isOpen176 then 
            if con176 == nil then 
                local flcBtns = GetElement(self.m_root, "flcBtns_WndOwnCity", WZUIFreeListContainer)
                local conBtn = self:_createIconButton(ISLAND_UP_CRAZY_DOUBLING, false)
                flcBtns:pushBack(conBtn)
                conBtn.btnId = ISLAND_UP_CRAZY_DOUBLING
                table.insert(self.m_tBtnList, conBtn)
                self.m_nIndex = self.m_nIndex + 1
            else
                con176:setVisible(true)
            end
        else
            if con176 then 
                con176:setVisible(false)
            end
        end
        local con177 = GetElement(self.m_root, "con" .. ISLAND_UP_AUCTION_HOUSE .. "_WndOwnCity", WZUIContainer)
        if isOpen177 then 
            if con177 == nil then 
                local flcBtns = GetElement(self.m_root, "flcBtns_WndOwnCity", WZUIFreeListContainer)
                local conBtn = self:_createIconButton(ISLAND_UP_AUCTION_HOUSE, false)
                flcBtns:pushBack(conBtn)
                conBtn.btnId = ISLAND_UP_AUCTION_HOUSE
                table.insert(self.m_tBtnList, conBtn)
                self.m_nIndex = self.m_nIndex + 1
            else
                con177:setVisible(true)
            end
        else
            if con177 then 
                con177:setVisible(false)
            end
        end
        local con178 = GetElement(self.m_root, "con" .. DOUBLE_SEVEN_CONFREE .. "_WndOwnCity", WZUIContainer)
        if isOpen178 then 
            if con178 == nil then 
                local flcBtns = GetElement(self.m_root, "flcBtns_WndOwnCity", WZUIFreeListContainer)
                local conBtn = self:_createIconButton(DOUBLE_SEVEN_CONFREE, false)
                flcBtns:pushBack(conBtn)
                conBtn.btnId = DOUBLE_SEVEN_CONFREE
                table.insert(self.m_tBtnList, conBtn)
                self.m_nIndex = self.m_nIndex + 1
            else
                con178:setVisible(true)
            end
        else
            if con178 then 
                con178:setVisible(false)
            end
        end

        self:createMainIcon(isOpen183, NATIONAL_FESTIVAL)
        self:createMainIcon(isOpen184, NATIONAL_ANSWER)
        self:createMainIcon(isOpen186, PEOPLESHOP)
        self:createMainIcon(isOpen187, TREASURESEARCH)
        self:createMainIcon(isOpen190, EVERYDAYBUY)
        self:createMainIcon(isOpen189, NEWYEARDAY)
        self:createMainIcon(isOpen192, FEBRUARYNEWYEAR)
        self:createMainIcon(isOpen193, FOURSTARS)
        self:createMainIcon(isOpen194, BLINDBOX)
        self:createMainIcon(isOpen195, DOLLMACHINE)
        self:createMainIcon(isOpen196, ACTIVITYLIMITLOGIN)
        self:createMainIcon(isOpen197, ACTIVITYNEWRECHARGE)
        self:createMainIcon(isOpen198, REBACKACTIVITY)
        self:createMainIcon(isOpen199, FIGHT_ACTIVITY)
        self:createMainIcon(isOpen119, ISLAND_UP_FOOT_BALL)
        self:createMainIcon(isOpen120, RISE_ACTIVITY)
        self:createMainIcon(isOpen121, ACTIVITY_SHOOT_ARROW)
        self:createMainIcon(isOpen122, HORARY_ACTIVITY)
        self:createMainIcon(isOpen123, MIDFESTIVAL_ACTIVITY)
        self:createMainIcon(isOpen124, FISH_ACTIVITY)
        self:createMainIcon(isOpen125, PELLET_ACTIVITY)
        self:createMainIcon(isOpen126, HOUSEINVEST_ACTIVITY)
        self:createMainIcon(isOpen134, BLUEPRIVILEGE_ACTIVITY)
        self:createMainIcon(isOpen135, QQHALLPRIVILEGE_ACTIVITY)
        self:createMainIcon(isOpen136, EIGHTYEAR_ACTIVITY)
        --独立活动入口
        for i = 1, #tTempActivityType do
            local isTempOpen = g_cityExtenInfo ~= nil and g_cityExtenInfo["activity" .. tTempActivityType[i]] ~= nil and g_cityExtenInfo["activity" .. tTempActivityType[i]] ~= 0
            self:createMainIcon(isTempOpen, tTempActivityType[i])
        end
        self:createMainIcon(isOpen233, ISLAND_UP_FLOWER_RANK) --鲜花榜活动
        
        --OV琥珀大玩家
        local con185 = GetElement(self.m_root, "con" .. ISLAND_UP_OPPO_AMBERPLAYER .. "_WndOwnCity", WZUIContainer)
        if isOpen185 then 
            if con185 == nil then 
                local flcBtns = GetElement(self.m_root, "flcBtns_WndOwnCity", WZUIFreeListContainer)
                local conBtn = self:_createIconButton(ISLAND_UP_OPPO_AMBERPLAYER, false)
                flcBtns:pushBack(conBtn)
                conBtn.btnId = ISLAND_UP_OPPO_AMBERPLAYER
                table.insert(self.m_tBtnList, conBtn)
                self.m_nIndex = self.m_nIndex + 1
            else
                con185:setVisible(true)
            end
        else
            if con185 then 
                con185:setVisible(false)
            end
        end
    end
end

--创建主城图标
function WndOwnCity:createMainIcon(bBool, icon_id)
    if self.m_root == nil then return end 
    if not self.m_nIndex then return end
    if not icon_id then return end

    local icon = GetElement(self.m_root, "con" .. icon_id .. "_WndOwnCity", WZUIContainer)
    if bBool then 
        if icon == nil then 
            local flcBtns = GetElement(self.m_root, "flcBtns_WndOwnCity", WZUIFreeListContainer)
            local conBtn = self:_createIconButton(icon_id, false)
            flcBtns:pushBack(conBtn)
            conBtn.btnId = icon_id
            table.insert(self.m_tBtnList, conBtn)
            self.m_nIndex = self.m_nIndex + 1
        else
            icon:setVisible(true)
        end
    else
        for i, v in ipairs (self.m_tBtnList) do
            if icon_id == v.btnId then
                table.remove(self.m_tBtnList, i)
                local flcBtns = GetElement(self.m_root, "flcBtns_WndOwnCity", WZUIFreeListContainer)
                flcBtns:removeAt(i-1)
                break
            end
        end
    end
end

--@brief    点击七天乐活动事件
function WndOwnCity:_postSevenDayEvent()
    -- body
    local level = CacheCenter:getPlayerInfo().level
    if level >= 6 and level <= 10 then 
        local eventKey = PostPlayerEvent["event_clickSevenDay" .. level]
        if eventKey then 
            PostPlayerEvent:postEvent(eventKey)    
        end
    end
end

--@brief    登录推送限购礼包入口回调
function WndOwnCity:openFiveTypePackage( element )
    local tNewUserPackageList = CacheCenter:getFiveTypePackageList()

    local curPackage = tNewUserPackageList[1] 
    if curPackage then
        local pushInfo = {}
        table.insert(pushInfo, curPackage.pushInfo)
        local lastNum = {}
        table.insert(lastNum, curPackage.lastNum)
        local originPrice = {}
        table.insert(originPrice, curPackage.originPrice)
        local endTime = {}
        table.insert(endTime, curPackage.endTime)
        WndVipGift:showInterface(pushInfo, lastNum, 5, originPrice, 0, endTime)
    end
end

function WndOwnCity:createFiveTypePackageBtn( )
    if not self.m_root then return end
    if CacheCenter:getGameParam() == nil or CacheCenter:getGameParam().gameStatus == "1" then return end 
    if os.time() - g_TimePlayerLogin < 10 * 60 then return end 

    local tNewUserPackageList = CacheCenter:getFiveTypePackageList()
    if tNewUserPackageList == nil or #tNewUserPackageList == 0 then return end 

    local btnLimitPackage = GetElement(self.m_root,"btnFiveTypePackage_WndOwnCity",WZUIButton)
    local btnLimitP = GetElement(self.m_root,"btnLimitPackage_WndOwnCity",WZUIButton)
    if btnLimitPackage then return end

    local btnPackage = WZUIButton:create()
    btnPackage:setName("btnFiveTypePackage_WndOwnCity")
    btnPackage:setAbsContentSize(GlobalMethod:CCSize(100,80))
    btnPackage:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    btnPackage:setUseAbsSize(true)
    if btnLimitP and btnLimitP:isVisible() then 
        btnPackage:setRelativePosition(GlobalMethod:ccp(1.008, 0.655))
    else
        btnPackage:setRelativePosition(GlobalMethod:ccp(1.008, 0.77))
    end
    btnPackage:setVisible(true)
    btnPackage:setShowAll(true)
    if IsIphoneX() then 
        if btnLimitP and btnLimitP:isVisible() then 
            btnPackage:setRelativePosition(GlobalMethod:ccp(0.97, 0.66))
        else
            btnPackage:setRelativePosition(GlobalMethod:ccp(0.97, 0.77))
        end
    end

    local imgNormal = WZUIImage:create()
    imgNormal:setUseOriginSize(true)
    imgNormal:setFile("ui/city/beta/main_icon_libao.png")

    local imgSel = WZUIImage:create()
    imgSel:setUseOriginSize(true)
    imgSel:setFile("ui/city/beta/main_icon_libao.png")
    imgSel:setScale(1.1)
    
    btnPackage:setNormalElement(imgNormal)
    btnPackage:setSelectElement(imgSel)
    btnPackage:setLuaDoneFunctionName("openFiveTypePackage")

    local spineBtn = WZUISpine:create()
    spineBtn:setLoop(true)
    spineBtn:setRelativePosition(GlobalMethod:ccp(0.5,1))
    spineBtn:setVisible(true)
    spineBtn:setTouchEnable(false)
    spineBtn:setFileJson("city/ui_main_iconeffect.json")
    spineBtn:setFileAtlas("city/ui_main_iconeffect.atlas")
    spineBtn:setAnimationName("animation")
    btnPackage:addChild(spineBtn)

    local txtBtn = WZUILabelTTF:create()
    txtBtn:setName("txtFiveTypePackageBtn_WndOwnCity")
    txtBtn:setText(LocalStrings.VIPWEEK_PACKAGE8)
    txtBtn:setColor(GlobalMethod:ccc3(255,236,193))
    txtBtn:setStrokeColor(GlobalMethod:ccc3(79,60,48))
    txtBtn:setRelativePosition(GlobalMethod:ccp(0.5, 0))
    txtBtn:setFontSize(18)
    txtBtn:setEnableStroke(true)
    txtBtn:setStrokeSize(4)
    btnPackage:addChild(txtBtn)

    self.m_root:addChild(btnPackage, 0, 505)
end

function WndOwnCity:_showLeftTime_FiveType()
    self:createFiveTypePackageBtn( )
    local tNewUserPackageList = CacheCenter:getFiveTypePackageList()
    if tNewUserPackageList == nil then return end 
    
    local btnLimitPackage = GetElement(self.m_root,"btnFiveTypePackage_WndOwnCity",WZUIButton)
    if btnLimitPackage == nil or btnLimitPackage:isVisible() == false then return end 

    if tNewUserPackageList[1].endTime <= 0 then 
        btnLimitPackage:setVisible(false)
        return 
    end

    tNewUserPackageList[1].endTime = tNewUserPackageList[1].endTime - 1
    local txtLimitPackageBtn = GetElement(self.m_root,"txtFiveTypePackageBtn_WndOwnCity",WZUILabelTTF)
    
    if txtLimitPackageBtn then 
        txtLimitPackageBtn:setVisible(true)
        if tNewUserPackageList[1].endTime >= 0 then 
            local hours,minutes,seconds
            hours = math.floor(tNewUserPackageList[1].endTime/3600)
            minutes = math.floor((tNewUserPackageList[1].endTime%3600)/60)
            seconds = tNewUserPackageList[1].endTime%60
            txtLimitPackageBtn:setText(string.format("%d:%d:%d", hours, minutes, seconds))
        else
            btnLimitPackage:setVisible(false)
        end
    end
end

--@brief    循环
function WndOwnCity:loopTime(element, delta)
    self:_showLeftTime()
    self:_showLeftTime_FiveType()
    self:_showAloneActivityLeftTime()
end

--@brief    开启英雄联赛
function WndOwnCity:openLeague()
    if self.m_root == nil then return end 

    local isOpen132 = CheckButtonShow(ISLAND_UP_LEAGUE, true)
    local nStartTime = SceneLeagueMain:transformStringToTime(SceneCity.startDateAll, false, true)
    local nEndTime = SceneLeagueMain:transformStringToTime(SceneCity.endTimeFThree, true, false)    
    local nNowTime = SystemTime:getServerTime()
    local bIsInTime = false 
    if nStartTime <= nNowTime and nNowTime <= nEndTime then 
        bIsInTime = true 
    end

    isOpen132 = isOpen132 and bIsInTime 
    self:createMainIcon(isOpen132, ISLAND_UP_LEAGUE)
end

--@brief    显示独立活动结束时间倒计时
--@note     小于24小时才显示
function WndOwnCity:_showAloneActivityLeftTime()
    if g_cityExtenInfo == nil then return end 

    local tTempActivityType = g_tAloneActivity
    local tTempActivityType2 = {FISH_ACTIVITY, PELLET_ACTIVITY, HOUSEINVEST_ACTIVITY, HORARY_ACTIVITY, RISE_ACTIVITY, FOURSTARS, BLINDBOX, DOLLMACHINE, FIGHT_ACTIVITY, ACTIVITY_SHOOT_ARROW, ISLAND_UP_FLOWER_RANK} --一开始的活动不是用活动类型的，需要做一下映射
    local tTempActivityOtherType = {7024, 7028, 7029, 7023, 7019, 7008, 7009, 7010, 7018, 7020, 5019} 
    for i = 1, #tTempActivityOtherType do 
        table.insert(tTempActivityType, tTempActivityOtherType[i])
    end

    local nCurServerTime = SystemTime:getServerTime()
    for i = 1, #tTempActivityType do
        if g_cityExtenInfo["endTime" .. tTempActivityType[i]] ~= nil and g_cityExtenInfo["endTime" .. tTempActivityType[i]] > 0 and nCurServerTime <
            g_cityExtenInfo["endTime" .. tTempActivityType[i]] and g_cityExtenInfo["endTime" .. tTempActivityType[i]] - nCurServerTime <= 24 * 3600 then 
            local nLeftTime = g_cityExtenInfo["endTime" .. tTempActivityType[i]] - nCurServerTime
            local strTime = returnToTimeFormat(nLeftTime)
            local nTempType = tTempActivityType[i]
            for j = 1, #tTempActivityOtherType do
                if tTempActivityType[i] == tTempActivityOtherType[j] then 
                    nTempType = tTempActivityType2[j]
                    break 
                end
            end
            local conBtn = GetElement(self.m_root, "con" .. nTempType .. "_WndOwnCity", WZUIContainer)
            if conBtn then 
                local txtEndTime = GetElement(conBtn, "txtActivityEndTime_WndOwnCity", WZUILabelTTF)
                if txtEndTime then 
                    txtEndTime:setText(strTime)
                end
            end
        end   
    end
end
-------------------------------------私有方法模块End----------------------------------------



-------------------------------------语言适配Begin------------------------------------------
function WndOwnCity:_adaptLanguage_pt(  )
    local txtInfoCheck = GetElement(self.m_root, "txtInfoCheck_WndOwnCity", WZUILabelTTF)
    txtInfoCheck:setScale(0.6)
    txtInfoCheck:setRelativePosition(GlobalMethod:ccp(0.57,0.300445))
    local txtInfoCheckSel = GetElement(self.m_root, "txtInfoCheckSel_WndOwnCity", WZUILabelTTF)
    txtInfoCheckSel:setScale(0.6)
    txtInfoCheckSel:setRelativePosition(GlobalMethod:ccp(0.57,0.300445))
end

function WndOwnCity:_adaptLanguage_en(  )
    local txtInfoCheck = GetElement(self.m_root, "txtInfoCheck_WndOwnCity", WZUILabelTTF)
    txtInfoCheck:setScale(0.78)
    txtInfoCheck:setRelativePosition(GlobalMethod:ccp(0.57,0.300445))
    local txtInfoCheckSel = GetElement(self.m_root, "txtInfoCheckSel_WndOwnCity", WZUILabelTTF)
    txtInfoCheckSel:setScale(0.78)
    txtInfoCheckSel:setRelativePosition(GlobalMethod:ccp(0.57,0.300445))
end

function WndOwnCity:_adaptLanguage_hk(  )
    local txtName = GetElement(self.m_root, "txtName_WndOwnCity", WZUILabelTTF)
    txtName:setMaxLength(12)
end

function WndOwnCity:_adaptLanguage_ug(  )
    local txtInfoCheck = GetElement(self.m_root, "txtInfoCheck_WndOwnCity", WZUILabelTTF)
    txtInfoCheck:setScale(0.42)
    txtInfoCheck:setRelativePosition(GlobalMethod:ccp(0.57,0.300445))
    txtInfoCheck:setDimensions(GlobalMethod:CCSize(100))
    local txtInfoCheckSel = GetElement(self.m_root, "txtInfoCheckSel_WndOwnCity", WZUILabelTTF)
    txtInfoCheckSel:setScale(0.42)
    txtInfoCheckSel:setRelativePosition(GlobalMethod:ccp(0.57,0.300445))
    txtInfoCheckSel:setDimensions(GlobalMethod:CCSize(100))
end

function WndOwnCity:_adaptLanguage_vn(  )

    -- 越南12+防沉迷图片
    local imgVN = GetElement(self.m_root, "imgVN_WndOwnCity",WZUIImage)
    imgVN:setVisible(true)
    imgVN:setFile("ui/common/12-plus-detail.png")
    --ios审核不显示12+防沉迷图片
    if CacheCenter:getGameParam().gameStatus == "1" then
        imgVN:setVisible(false)
    end
end
-------------------------------------语言适配End--------------------------------------------