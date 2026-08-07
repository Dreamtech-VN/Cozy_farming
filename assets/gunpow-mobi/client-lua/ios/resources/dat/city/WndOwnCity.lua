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

end

-- --@brief    触摸面板Began回调
-- function WndOwnCity:onTouchBegan(element, point)
--     if self.m_tLine then
--         self.m_tLine:onTouchBegan(element, point)
--     end
-- end

-- --@brief    触摸面板Moved回调
-- function WndOwnCity:onTouchMoved(element, point)
--     if self.m_tLine then
--         self.m_tLine:onTouchMoved(element, point)
--     end
-- end

-- --@brief    触摸面板End回调
-- function WndOwnCity:onTouchEnd(element, point)
--     if self.m_tLine then
--         self.m_tLine:onTouchEnd(element, point)
--     end
-- end

-- --@brief    每帧调用
-- function WndOwnCity:loop()
--     if self.m_tLine then
--         self.m_tLine:loop()
--     end
-- end

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
function WndOwnCity:onEnterTransitionDidFinish(element)
    WZLog("WndOwnCity:onEnterTransitionDidFinish one") 
    
    WndSetting:_initUserData()

    if self.m_bOnEnter == true then
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
                tCell:showCoin({1,70,2,6},{1,1,1,1})
                tCell:setCellType(1)
                celElement:setRelativePosition(GlobalMethod:ccp(0.575,0.63))
                celElement:setScale(1)
                if IsIphoneX() then
                    celElement:setRelativePosition(GlobalMethod:ccp(0.54,0.63))
                end
            end
        end
        self:_update()

        ProtocolProcessorSceneCity:send_PLAYER_GetUpdateRedDot()
        --ProtocolProcessorWndActive:send_ACTIVE_GetActiveInfo()

        ProtocolProcessorFund:regAll()
        ProtocolProcessorFund:send_FUNDGROW_GetFundInfo()

        WndOwnCity:updateMonthCardRedPoint()

        self.m_tLine = BattleOtherPointsLine:create(self:getFrontLayer(), 20, nil, nil, nil, nil, nil, nil, GlobalMethod:ccp(480,320), self, 
            {x1=0,x2=960,y1=0,y2=640})
        self.m_root:enableSchedule("loop",0)
    end
    self.m_bOnEnter = true
    --Add By Tianxiang_Xu
    --登录时战斗力变化，延迟到这里显示
    g_bIsShowFightingLater = false
    if g_nLaterShowFighting then
        WZLog("+++++++++++  WndOwnCity:onEnterTransitionDidFinish", g_nLaterShowFighting)
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

    --登录定向推送礼包入口回调
function WndOwnCity:openLimitPackage( element )
    local tNewUserPackageList = CacheCenter:getLimitPackageList()
    if #tNewUserPackageList == 1 then
        curPackage = tNewUserPackageList[1] 
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

    self.m_root:enableSchedule("_showLeftTime", 1)
end

function WndOwnCity:_showLeftTime(  )
    local nCurTime = SystemTime:getServerTime()
    local tNewUserPackageList = CacheCenter:getLimitPackageList()
    local maxLimitTime = 0
    for k,v in pairs(tNewUserPackageList) do
        maxLimitTime = math.max(maxLimitTime,v.endTime)
    end

    local btnLimitPackage = GetElement(self.m_root,"btnLimitPackage_WndOwnCity",WZUIButton)
    if nCurTime > maxLimitTime then 
        btnLimitPackage:setVisible(false)
        self.m_root:disableSchedule()
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
            self.m_root:disableSchedule()
        end
    end
end

--@brief    更新月卡小红点
function WndOwnCity:updateMonthCardRedPoint()
    --do return end
    -- if self.m_root then
    --     local btn = GetElementWithoutAssert(self.m_root, "btn66_WndOwnCity", WZUIButton)
    --     if btn then
    --         SceneCity:setRedPoint(btn,GetMonthCardTime() <= 0,GlobalMethod:ccp(83,83))
    --     end
    -- end
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
    WZLog("WndOwnCity:init one", CacheCenter:getPlayerInfo().level)
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

    local txtOtherName = GetElement(self.m_root, "txtInfoName_WndOwnCity", WZUILabelTTF)
    --txtOtherName:setMaxLength(6)

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

    if tonumber(playerInfo.vipLevel) > 0 then
        local txtVip = GetElement(self.m_root, "txtVip_WndOwnCity", WZUILabelAtlasFont)
        txtVip:setText(playerInfo.vipLevel)
        txtVip:setVisible(true)

        GetElement(self.m_root, "imgVip0_WndOwnCity", WZUIImage):setVisible(true)
        GetElement(self.m_root, "imgVip1_WndOwnCity", WZUIImage):setVisible(true)
    else
        GetElement(self.m_root, "txtVip_WndOwnCity", WZUILabelAtlasFont):setVisible(false)
        GetElement(self.m_root, "imgVip0_WndOwnCity", WZUIImage):setVisible(false)
        GetElement(self.m_root, "imgVip1_WndOwnCity", WZUIImage):setVisible(false)
    end

    if isUpdate == nil then
        local conPlayerAni = WndOwnCity.m_root:getChildElement("conHead_WndOwnCity")
        local headAnim --= CreateHeadAnim(conPlayerAni, 0.7,nil, playerInfo.sex)

        local tEquip = CacheCenter:getEquipmentList()
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
                    WZLog("WndOwnCity:init two", i, maintype, subtype, Serialize(tEquipData))
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

        WZLog("WndOwnCity:init three", #tEquip, head, face, playerInfo.sex)
        local color, bcolor = CacheCenter:getHeadAndBodyColor()
        headAnim, headObj = CellHead:show(conPlayerAni,head,face,playerInfo.sex,false,{x=0.52, y=0.28},nil,color,"ui/city/beta/common_scale9_zhezhaoheidifx02.png", 1)
        headAnim:setScale(0.9)
        --conPlayerAni:setRelativePosition(GlobalMethod:ccp(-0.1, 1.35))
        self.m_tHeadAnim = headObj
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
            local txtTTF = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtInfoName_WndOwnCity"))
            txtTTF:setText(figure.m_tPlayerInfo.name)
            local txtTTF = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtInfoLv_WndOwnCity"))
            txtTTF:setText("LV"..figure.m_tPlayerInfo.level)

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
    --WndBag:showBag()
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


--@brief	点击活动按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note	在这里做相应的按钮相应事件
function WndOwnCity:onClickActivity(element)
    WZLog("WndOwnCity:onClickActivity")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    TeachGroup1:endTeachStep({22,1})

    local isTeach = TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 24 and TeachGroup1.STEP == 1


    if CheckButtonOpen(ISLAND_UP_ACTIVITY) and isTeach ~= true then
        local wndPets = WndActive:createElement()
        if wndPets ~= nil then
            WindowManager:addWindow(wndPets, WndActive, false)
        end

        if self.m_tActivitiesDialogLuaObj then
            self.m_tActivitiesDialogLuaObj:removeDialog()
            self.m_tActivitiesDialogLuaObj = nil
        end
        self.m_bIfActivitiesClicked = true
    end
    
end


--@brief  点击活动
function WndOwnCity:onClickGameActivity( element )
    WZLog("WndOwnCity:onClickGameActivity")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    local isTeach = (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 24 and TeachGroup1.STEP == 1) or (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 29 and TeachGroup1.STEP == 1) or (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 1 and TeachGroup1.STEP == 2)
    if CheckButtonOpen(ISLAND_UP_EVENT) and isTeach ~= true then
        GlobalGame.g_autoGameActivity = false
        local wndGameActivity = WndGameActivity:createElement()
        if wndGameActivity ~= nil then
            WindowManager:addWindow(wndGameActivity,WndGameActivity)
        end
    end
end

--@brief	点击世界Boss按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note	在这里做相应的按钮相应事件
function WndOwnCity:onClickWorldBoss(element)
    WZLog("WndOwnCity:onClickWorldBoss")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    local isTeach = (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 24 and TeachGroup1.STEP == 1) or (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 29 and TeachGroup1.STEP == 1) or (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 1 and TeachGroup1.STEP == 2)
    if isTeach ~= true  then
        DataUUtil("OL_Island_WorldBossHall","")
    	SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
        CheckLuaLoad(LUAFILES_BLOCK_COMMON)
        CheckLuaLoad(Chat_Channel_WorldBoss)

        WndWorldBoss:showWnd(true)

        --WndWorldBossEndReward:showWnd()

--        local scene = SceneWorldBoss:createElement()
--        replaceScene(scene)
    end
end

--@brief	点击VIP按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note	在这里做相应的按钮相应事件
function WndOwnCity:onClickVip(element)
    WZLog("WndOwnCity:onClickVip")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

--    local scene = ScenePvpRank:createElement()
--    replaceScene(scene)

--    local data = {count = 100,isUp = true,vipLevel = 5,itemId = 51}
--     WndRechargeSuccess:showWndUI(data)

   --  self:onClickWorldBoss(element)

   --  WndWorldBossEnd:showWnd( data, true)

   -- SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

   -- --WndBuyActivity:showBuyInterface(26)


   -- WndAccountChange:showWndUI()

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
       WndSevenDayActivity:showInterface()
    end
end

function WndOwnCity:onClickBless(element)
    WZLog("WndOwnCity:onClickBless")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    if CheckButtonOpen(ISLAND_UP_BLESS) then
        local wndBless = WndBless:createElement()
        if wndBless ~= nil then
            WindowManager:addWindow(wndBless,WndBless)
            return
        end
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

-- --@brief    点击FB按钮后的响应方法
-- --@param    element:按钮的UI节点引用
-- --@note 在这里做相应的按钮相应事件
-- function WndOwnCity:onClickFb(element)
--     WZLog("WndOwnCity:onClickFb")
--     SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

--     local isTeach = (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 15 and TeachGroup1.STEP == 1) or (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 17 and TeachGroup1.STEP == 1)
--     if self:_checkBuildingOpen(ISLAND_LEFT_FB) and isTeach ~= true then
--         local url = "https://www.facebook.com/bombman.hero"
--         if ProjConfig.LANGUAGE == "th" then
--             url = "https://www.facebook.com/bombman.th"
--         end
--         WZLog("rrrrrrrrrr:",url)
--         WndActivities:showView()
--         WndActivities:_setActivityUrl(url)
--     end
    
-- end

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
    --TeachGroup1:endTeachStep({17,1})

    -- if CheckButtonOpen(ISLAND_LEFT_TEACH) then
    --     CheckLuaLoad(LUAFILES_BLOCK_COMMON)
    --     CheckLuaLoad(Chat_Channel_BecomeStronger)
    --     WndStrong:showInterface()
    -- end

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
        --WndGameActivity:showInterface(3015)
        local wnd = CellRechargePanelActivity:createElement()
        WindowManager:addWindow(wnd, CellRechargePanelActivity, true)
		--CellRechargePanelActivity:setMessage(content,status,rewardItems,activityId,rewardId, rewardCounts, target, rewardItemsParamCount)
		--CellRechargePanelActivity:showWindow()
    end
end

--@brief	月卡回调
function WndOwnCity:onClickMonthCard(element)
    WZLog("WndOwnCity:onClickMonthCard")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    local isTeach = (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 24 and TeachGroup1.STEP == 1) or (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 1 and TeachGroup1.STEP == 2)


    if CheckButtonOpen(ISLAND_UP_MONTHCARD) and isTeach ~= true then
        WndGameActivity:showInterface(143)
    end
end

--@brief    点击魅力空间按钮后的响应方法
function WndOwnCity:onClickCharm(element)
    WZLog("WndOwnCity:onClickCharm")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    local isTeach = TeachGroup1.ISTEACH == true and 
        (TeachGroup1.GROUP == 43)
    if CheckButtonOpen(ISLAND_EXTEND_CHARM) and isTeach ~= true then
        local wndCharmSpace = WndCharmSpace:createElement()
        if wndCharmSpace ~= nil then
            WindowManager:addWindow(wndCharmSpace, WndCharmSpace, false)
        end
    end
end

--@brief    人物升级后更新左菜单
function WndOwnCity:updateForUpgrade()
    if self.m_root == nil then
        return
    end
    
    local bUpdateFlag = false --是否更新，仅当有新功能开放时才更新
    if CacheCenter:getPlayerInfo().level <= 99 then
        for i,v in ipairs(self.m_tBtnsInfo) do
            if v.buttonStatus3Level == CacheCenter:getPlayerInfo().level and checkbuttonChannel(v.buttonChannel) then
                bUpdateFlag = true
                break
            end
        end
    end
    if bUpdateFlag then
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
        WndWelfare:showInterface(2)
    end
end

--@brief	福利点击回调
function WndOwnCity:onClickWelfare(element)
    WZLog("WndOwnCity:onClickWelfare")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    --self:updateFirstRecharge(false)
    local isTeach = (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 16 and TeachGroup1.STEP == 1)
    if CheckButtonOpen(ISLAND_UP_WELFARE) and isTeach ~= true then
        WndWelfare:showInterface(1)
        
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
        --WndGameActivity:showInterface(167)
        local wndFreeca = WndFreeca:createElement()
        WindowManager:addWindow(wndFreeca, WndFreeca, false)
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
    
    if CheckButtonOpen(ISLAND_UP_FOOT_BALL) then
        WndFootballActivity:showInterface()
    end
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

    if self.m_root then

        local index = 999
        for i, v in ipairs (self.m_tBtnList) do
            if v.btnId == ISLAND_UP_BINDING then
                index = i
            end

            WZLog("WndOwnCity:hideBinding", i, v.btnId, index, v.index)
            if i > index then
                local posPro = v:getRelativePosition().x
                local offsetX = 0.25
                if v.index == 8 then
                    v:setRelativePosition(GlobalMethod:ccp(1.54-offsetX * 6, 0.5))
                else
                    v:setRelativePosition(GlobalMethod:ccp(v:getRelativePosition().x + 0.25, v:getRelativePosition().y))
                end
            end
        end
    end

    if self.m_root and GetElement(self.m_root, "con55_WndOwnCity", WZUIContainer) then
        local bind = GetElement(self.m_root, "con55_WndOwnCity", WZUIContainer)
        bind:setVisible(false)
        for i, v in ipairs (self.m_tBtnList) do
            if bind == v then
                table.remove(self.m_tBtnList, i)
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
            local conBtns = GetElement(self.m_root, "conBtns_WndOwnCity", WZUIContainer)
            local conBtn = self:_createIconButton(ISLAND_UP_ELITE_SHOP, false)

            local pos = {}
            local offsetX = 0.21
            local right = 1.04
            if IsIphoneX() then
                right = 0.88
            end
            pos.x = right-offsetX * (self.m_nIndex - 0)
            pos.y = 0
            conBtn:setRelativePosition(GlobalMethod:ccp(pos.x, pos.y))

            conBtns:addChild(conBtn)
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
            local conBtns = GetElement(self.m_root, "conBtns_WndOwnCity", WZUIContainer)
            local conBtn = self:_createIconButton(ISLAND_UP_PRAY, false)

            local pos = {}
            local offsetX = 0.21
            local right = 1.04
            if IsIphoneX() then
                right = 0.88
            end
            pos.x = right-offsetX * (self.m_nIndex - 0)
            pos.y = 0
            conBtn:setRelativePosition(GlobalMethod:ccp(pos.x, pos.y))

            conBtns:addChild(conBtn)
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

    local id = 0
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
            id =id +1
            local offsetY = 0.96 - offset * (id - 1)
            conBtn:setRelativePosition(GlobalMethod:ccp(offsetY, 0.991))
            WZLog("WndOwnCity:_update one", i, id, tostring(v.buttonId), tostring(btnIndex[v.buttonId]), offsetY)
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
    local right = 1.04
    if IsIphoneX() then
        right = 0.88
    end
    if isOpen and conWishWell:isVisible() ~= true then
        conWishWell:setVisible(true)
        local posx = conWishWell:getRelativePosition().x
        local offsetX = 0.21
        local index = 999
        for i,v in ipairs(self.m_tBtnList) do
            if index == 999 and v.btnId == ISLAND_UP_WISHING_WELL then
                index = i
            end

            if i > index then
                posx = right-offsetX * (i - 1)
                v:setRelativePosition(GlobalMethod:ccp(posx, 0))
            end
        end
        self.m_nIndex = self.m_nIndex + 1
    elseif isOpen ~= true and conWishWell:isVisible() == true then
        conWishWell:setVisible(false)
        local posx = conWishWell:getRelativePosition().x
        local offsetX = 0.21
        local index = 999
        local index2 = 999
        for i,v in ipairs(self.m_tBtnList) do
            if index == 999 and v.btnId == ISLAND_UP_WISHING_WELL then
                index = i
            end
            if v.btnId == ISLAND_UP_WISHING_WELL then
                index2 = i
            end
            WZLog("WndOwnCity:updateWishWell two", index, i)
            if i > index then
                posx = right-offsetX * (i - 2)
                v:setRelativePosition(GlobalMethod:ccp(posx, 0))
                WZLog("WndOwnCity:updateWishWell three", index, i)
            end
        end
        table.remove(self.m_tBtnList, index2)
        self.m_nIndex = self.m_nIndex - 1
    end
end


--@brief    更新基金
function WndOwnCity:updateFund(isOpen)
    WZLog("WndOwnCity:updateFund zero", tostring(self.m_root), tostring(self.m_tBtnList))
    if self.m_root == nil or self.m_tBtnList == nil then
        return
    end

    isOpen = isOpen and CheckButtonShow(ISLAND_UP_FUND, true)
    local conWishWell = GetElement(self.m_root, "con19_WndOwnCity", WZUIContainer)
    WZLog("WndOwnCity:updateFund one", tostring(isOpen), tostring(conWishWell))

    local right = 1.04
    if IsIphoneX() then
        right = 0.88
    end
    if isOpen and (conWishWell == nil or conWishWell:isVisible() ~= true) then
        if conWishWell == nil then
            local conBtns = GetElement(self.m_root, "conBtns_WndOwnCity", WZUIContainer)
            conWishWell = self:_createIconButton(ISLAND_UP_FUND, false)
            conBtns:addChild(conWishWell)
            conWishWell.btnId = ISLAND_UP_FUND
            table.insert(self.m_tBtnList, conWishWell)
        end

        conWishWell:setVisible(true)
        local posx = conWishWell:getRelativePosition().x
        local offsetX = 0.21
        local index = 999
        local offset = 0
        for i,v in ipairs(self.m_tBtnList) do
            if index == 999 and v.btnId == ISLAND_UP_CARD_WELFARE then
                index = i
            end

            WZLog("WndOwnCity:updateFund two", i, index, v:isVisible())
            if i > index and v:isVisible() == false then
                offset = offset + 1
            elseif i > index then
                posx = right-offsetX * (i - offset)
                v:setRelativePosition(GlobalMethod:ccp(posx, 0))
            end
        end

        posx = right-offsetX * (index )
        conWishWell:setRelativePosition(GlobalMethod:ccp(posx, 0))
        self.m_nIndex = self.m_nIndex + 1
    elseif isOpen ~= true and conWishWell and conWishWell:isVisible() == true then
        conWishWell:setVisible(false)
        local posx = conWishWell:getRelativePosition().x
        local offsetX = 0.21
        local index = 999
        local offset = 0
        local index2 = 999
        for i,v in ipairs(self.m_tBtnList) do
            if index == 999 and v.btnId == ISLAND_UP_CARD_WELFARE then
                index = i
            end
            if v.btnId == ISLAND_UP_FUND then
                index2 = i
            end
            WZLog("WndOwnCity:updateFund two", i, index, v:isVisible())
            if i > index and v:isVisible() == false then
                offset = offset + 1
            elseif i > index then
                posx = right-offsetX * (i - 1 - offset)
                v:setRelativePosition(GlobalMethod:ccp(posx, 0))
            end
        end
        table.remove(self.m_tBtnList, index2)
        self.m_nIndex = self.m_nIndex - 1
    end
end

--@brief    更新七天乐
function WndOwnCity:checkSevenDay()
    WZLog("WndOwnCity:checkSevenDay zero", tostring(self.m_root), tostring(self.m_tBtnList), tostring(GlobalGame.g_isServerTaskOpen))
    if self.m_root == nil or self.m_tBtnList == nil then
        return
    end

    local time = SystemTime:getServerTime() - GlobalGame.g_serverTaskTime

    local isOpen = CheckButtonShow(ISLAND_UP_SEVEN_DAY, true) and time < 777600 and GlobalGame.g_isServerTaskOpen
    local conWishWell = GetElement(self.m_root, "con143_WndOwnCity", WZUIContainer)
    WZLog("WndOwnCity:checkSevenDay one", tostring(isOpen), tostring(conWishWell), time, SystemTime:getServerTime(), GlobalGame.g_serverTaskTime)

    local right = 1.04
    if IsIphoneX() then
        right = 0.88
    end
    if isOpen and (conWishWell == nil or conWishWell:isVisible() ~= true) then
        if conWishWell == nil then
            local conBtns = GetElement(self.m_root, "conBtns_WndOwnCity", WZUIContainer)
            conWishWell = self:_createIconButton(ISLAND_UP_SEVEN_DAY, false)
            conBtns:addChild(conWishWell)
            conWishWell.btnId = ISLAND_UP_SEVEN_DAY
            table.insert(self.m_tBtnList, conWishWell)
        end

        conWishWell:setVisible(true)
        local posx = conWishWell:getRelativePosition().x
        local offsetX = 0.21
        local index = 999
        local offset = 0
        for i,v in ipairs(self.m_tBtnList) do
            if index == 999 and v.btnId == ISLAND_UP_EVENT then
                index = i
            end

            WZLog("WndOwnCity:checkSevenDay two", i, index, v:isVisible())
            if i >= index and v:isVisible() == false then
                offset = offset + 1
            elseif i >= index then
                posx = right-offsetX * (i - offset)
                v:setRelativePosition(GlobalMethod:ccp(posx, 0))
            end
        end

        posx = right-offsetX * (index )
        conWishWell:setRelativePosition(GlobalMethod:ccp(posx, 0))
        self.m_nIndex = self.m_nIndex + 1
    elseif isOpen ~= true and conWishWell and conWishWell:isVisible() == true then
        conWishWell:setVisible(false)
        local posx = conWishWell:getRelativePosition().x
        local offsetX = 0.21
        local index = 999
        local offset = 0
        local index2 = 999
        for i,v in ipairs(self.m_tBtnList) do
            if index == 999 and v.btnId == ISLAND_UP_EVENT then
                index = i
            end
            if v.btnId == ISLAND_UP_SEVEN_DAY then
                index2 = i
            end
            WZLog("WndOwnCity:updatcheckSevenDayeFund three", i, index, v:isVisible())
            if i >= index and v:isVisible() == false then
                offset = offset + 1
            elseif i >= index then
                posx = right-offsetX * (i - 2 - offset)
                v:setRelativePosition(GlobalMethod:ccp(posx, 0))
            end
        end
        table.remove(self.m_tBtnList, index2)
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
    local right = 1.04
    if IsIphoneX() then
        right = 0.88
    end
    if isOpen then
        if conFirst == nil then
            local conBtns = GetElement(self.m_root, "conBtns_WndOwnCity", WZUIContainer)
            local conBtn = self:_createIconButton(ISLAND_UP_FIRST_RECHARGE, false)

            local pos = {}
            if conVip then
                pos.x = conVip:getRelativePosition().x
            else
                local offsetX = 0.21
                pos.x = right-offsetX * (self.m_nIndex - 0)
            end
            pos.y = 0
            conBtn:setRelativePosition(GlobalMethod:ccp(pos.x, pos.y))

            conBtns:addChild(conBtn)
            conBtn.btnId = ISLAND_UP_FIRST_RECHARGE
            --table.insert(self.m_tBtnList, conBtn)
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
            local conBtns = GetElement(self.m_root, "conBtns_WndOwnCity", WZUIContainer)
            local conBtn = self:_createIconButton(ISLAND_UP_RECHARGE, false)

            local pos = {}
            if conFirst then
                pos.x = conFirst:getRelativePosition().x
            else
                local offsetX = 0.21
                pos.x = right-offsetX * (self.m_nIndex - 0)
            end
            pos.y = 0
            conBtn:setRelativePosition(GlobalMethod:ccp(pos.x, pos.y))

            conBtns:addChild(conBtn)
            conBtn.btnId = ISLAND_UP_RECHARGE
            --table.insert(self.m_tBtnList, conBtn)
            for k,v in pairs(self.m_tBtnList) do
                if v.btnId == ISLAND_UP_FIRST_RECHARGE then
                    self.m_tBtnList[k] = conBtn
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

-- --@brief    点击FB按钮后的响应方法
-- --@param    element:按钮的UI节点引用
-- --@note 在这里做相应的按钮相应事件
-- function WndOwnCity:onClickFb(element)
--     WZLog("WndOwnCity:onClickFb")
--     SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

--     local isTeach = (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 15 and TeachGroup1.STEP == 1) or (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 17 and TeachGroup1.STEP == 1)
--     if CheckButtonOpen(ISLAND_LEFT_FB) and isTeach ~= true then
 

--     end
    
-- end

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
       WndPromiseShrine:showWnd()
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
    WZLog("WndOwnCity:onClickFootBall")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    if CheckButtonOpen(ISLAND_UP_BACK_ACTIVITY, false) then
        WndWelfare:showInterface(6)
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
    [ISLAND_UP_ATTENDANCE] = "onClickSingIn",
    [ISLAND_UP_ACTIVITY] = "onClickActivity",
    [ISLAND_UP_QUALIFYING] = "onClickQualifying",
    [ISLAND_UP_KING] = "onClickWorldBoss", --"onClickKing", --
    [ISLAND_UP_BINDING] = "onClickBinding",
    [ISLAND_BUILDING_LOTTERY] = "onClickLove",
    [ISLAND_UP_BLESS] = "onClickBless",
    



    [ISLAND_UP_RECHARGE] = "onClickVip",

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
    [ISLAND_UP_CARD_WELFARE] = "onClickCardWelfare",
    [ISLAND_LEFT_4399] = "onClick4399",
    [ISLAND_UP_ELITE_SHOP] = "onClickEliteShop",
    [ISLAND_UP_WISHING_WELL] = "onClickWishingWell",
    [ISLAND_UP_PRAY] = "onClickPray",
    [ISLAND_UP_FOOT_BALL] = "onClickFootBall",
    [ISLAND_UP_SEVEN_DAY] = "onClickSevenDay",
    [ISLAND_UP_FOOT_BALL] = "onClickFootBall",
    [ISLAND_UP_BACK_ACTIVITY] = "onClickBackActivity",
}

--菜单按钮的图片文件路径
local tBtnImgPath = {
    [ISLAND_UP_ATTENDANCE] =       "ui/city/newUI/common_icon_qd",
    [ISLAND_UP_ACTIVITY] =       "ui/city/newUI/common_icon_hyd",
    [ISLAND_UP_QUALIFYING] =  "ui/city/newUI/common_icon_pws",
    [ISLAND_UP_KING] =       "ui/city/newUI/common_icon_tws",
    [ISLAND_UP_BINDING] =       "ui/city/newUI/common_icon_zhbd",
    [ISLAND_BUILDING_LOTTERY] =       "ui/city/newUI/common_icon_axxy2",
    [ISLAND_UP_BLESS] =       "ui/city/newUI/common_icon_xhxt",
    


    [ISLAND_UP_FIRST_RECHARGE] =       "ui/city/beta/main_icon_shouchong_2",

    [ISLAND_UP_RECHARGE] =        "ui/city/beta/main_icon_chongzhi_2",
    [ISLAND_BUILDING_SHOP] =        "ui/city/beta/main_icon_shangcheng_2",
    [ISLAND_UP_SHOP] =        "ui/city/beta/main_icon_xiulian_2",
    [ISLAND_UP_EVENT] =     "ui/city/beta/main_icon_huodong_2",
    [ISLAND_UP_MATCH] =  "ui/city/beta/main_icon_bisai_2",
    [ISLAND_BUILDING_RANK] =  "ui/city/beta/main_icon_paihangbang_2",
    [ISLAND_UP_LBS] =  "ui/city/beta/main_icon_sousuo_2",
    [ISLAND_UP_WELFARE] =       "ui/city/beta/main_icon_fuli_2",
    [ISLAND_EXTEND_CHARM] =       "ui/city/beta/main_icon_meilikongjian_2",

    [ISLAND_UP_FUND] =     "ui/city/newUI/common_icon_pws",
    [ISLAND_UP_MONTHCARD] =       "ui/city/beta/main_icon_yueka_2",
    [ISLAND_UP_CARD_WELFARE] =       "ui/city/beta/main_icon_yueka_2",
    [ISLAND_LEFT_4399] =     "ui/city/beta/main_icon_43992",
    [ISLAND_UP_ELITE_SHOP] =     "ui/city/beta/main_icon_shangcheng_2",
    [ISLAND_UP_WISHING_WELL] = "ui/city/beta/main_icon_xuyuanchi_2",
    [ISLAND_UP_PRAY] =     "ui/city/beta/main_icon_qiyuandali_2",
    [ISLAND_UP_MTO] =       "ui/city/newUI/common_icon_zctzlb",
    [ISLAND_UP_FOOT_BALL] =       "ui/city/beta/main_icon_football_2",
    [ISLAND_UP_SEVEN_DAY] =       "ui/city/beta/main_icon_qtl_2",
    [ISLAND_UP_FOOT_BALL] =       "ui/city/beta/main_icon_football_2",
    [ISLAND_UP_BACK_ACTIVITY] =       "shopitems/xiaodao_tubiao",
}

--菜单按钮的文字图片文件路径
local tBtnImgNamePath = {

    [ISLAND_UP_FIRST_RECHARGE] =       "ui/city/beta/commom_icon_wz_shouchong_2",

    [ISLAND_UP_RECHARGE] =        "ui/city/beta/commom_icon_wz_chongzhi_2",
    [ISLAND_BUILDING_SHOP] =        "ui/city/beta/commom_icon_wz_shangcheng_2",
    [ISLAND_UP_SHOP] =        "ui/city/beta/commom_icon_wz_xiulian_2",
    [ISLAND_UP_EVENT] =     "ui/city/beta/commom_icon_wz_huodong_2",
    [ISLAND_UP_MATCH] =  "ui/city/beta/commom_icon_wz_bisai_2",
    [ISLAND_BUILDING_RANK] =  "ui/city/beta/commom_icon_wz_paihangbang_2",
    [ISLAND_UP_LBS] =  "ui/city/beta/commom_icon_wz_sousuo_2",
    [ISLAND_UP_WELFARE] =       "ui/city/beta/commom_icon_wz_fuli_2",
    [ISLAND_EXTEND_CHARM] =       "ui/city/beta/commom_icon_wz_meilikongjian_2",

    [ISLAND_UP_MONTHCARD] =       "ui/city/beta/commom_icon_wz_yueka_2",
    [ISLAND_UP_CARD_WELFARE] =       "ui/city/beta/commom_icon_wz_fulika",
    [ISLAND_LEFT_4399] =     "ui/city/beta/commom_icon_wz_youxidaquan_2",
    [ISLAND_UP_ELITE_SHOP] =     "ui/city/beta/commom_icon_wz_jingyingshangcheng_2",
    [ISLAND_UP_WISHING_WELL] = "ui/city/beta/commom_icon_wz_xuyuanchi_2",
    [ISLAND_UP_PRAY] =     "ui/city/beta/main_icon_qiyuandali",
    [ISLAND_UP_MONTHCARD] =       "ui/city/newUI/common_icon_yktbz",
    [ISLAND_UP_MTO] =       "ui/city/newUI/common_icon_zctzlbz",
    [ISLAND_UP_FOOT_BALL] =       "ui/city/beta/main_icon_football",
    [ISLAND_UP_SEVEN_DAY] =       "ui/city/beta/main_icon_qtl",
    [ISLAND_UP_FOOT_BALL] =       "ui/city/beta/main_icon_football",
    [ISLAND_UP_BACK_ACTIVITY] =       "ui/city/beta/main_pic_daozhuhuigui",
}

--@brief    根据按钮id创建一个按=钮common_icon_yjkwz
--@param    nButtonId, 按钮id
--@param    bIsHighlight, 是否高亮
--@return   #1, 按钮的节点引用
function WndOwnCity:_createIconButton(nButtonId, bIsHighlight)
    WZLog("WndOwnCity:_createIconButton one", nButtonId, tostring(g_isRegist), tostring(bIsHighlight), tostring(tBtnImgPath[nButtonId]))

    local conBtn = WZUISystem:getInstance():createElement("conBtn_WndOwnCity")
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
        imgIconNormalName = GetElement(btn, "imgIconNameNormal_WndOwnCity", WZUIImage)
        imgIconNormalName:setFile(tBtnImgNamePath[nButtonId]..".png")
        imgIconSeName = GetElement(btn, "imgIconNameSel_WndOwnCity", WZUIImage)
        imgIconSeName:setFile(tBtnImgNamePath[nButtonId]..".png")
        if ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "en" then
            imgIconNormalName:setScale(0.7)
            imgIconSeName:setScale(0.7)
        elseif ProjConfig.LANGUAGE == "th" or ProjConfig.LANGUAGE == "en" then
            imgIconNormalName:setScale(0.7)
            imgIconSeName:setScale(0.7)
        end
    end

    if nButtonId == ISLAND_UP_RECHARGE then
        GlobalGame.g_bIsNoFirstRechange = true
    end

    if (nButtonId == ISLAND_UP_BINDING and g_isRegist ~= true) then
        GetElement(conBtn, "armaBtn_WndOwnCity", WZArmature):setVisible(true)
    elseif nButtonId == ISLAND_UP_BINDING and ProjConfig.LANGUAGE == "vn" then
        GetElement(conBtn, "armaBtn_WndOwnCity", WZArmature):setVisible(true)
    elseif nButtonId == ISLAND_UP_BINDING and g_isRegist == true then
        return
    elseif nButtonId == ISLAND_UP_RECHARGE or nButtonId == ISLAND_UP_FIRST_RECHARGE then
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
    local conBtns = GetElement(self.m_root, "conBtns_WndOwnCity", WZUIContainer)

    local nTag = 0
    local offsetX = 0.21
    local indexNo = 0
    local index = 0
    for i,v in ipairs(self.m_tBtnsInfo) do
        WZLog("WndOwnCity:_update three", v.buttonId, GlobalMethod:crossServiceOpen(), v.buttonChannel, ProjConfig.CHANNEL_ID, checkbuttonChannel(v.buttonChannel))
            
        local conFirst = GetElement(self.m_root, "con65_WndOwnCity", WZUIContainer)
        local conVip = GetElement(self.m_root, "con17_WndOwnCity", WZUIContainer)
        if ((CheckButtonOpen(v.buttonId ,false) or TeachGroup1.ISTEACHMODE == true) and 
            (v.buttonId == ISLAND_UP_BINDING and g_isRegist ~= true or v.buttonId ~= ISLAND_UP_BINDING or ProjConfig.LANGUAGE == "vn") and 
            (v.buttonId ~= ISLAND_UP_FIRST_RECHARGE or conVip == nil and GlobalGame.g_bIsNoFirstRechange == false) and 
            --[[(v.buttonId ~= ISLAND_UP_CARD_WELFARE or CacheCenter:getPlayerItemById(52) == nil) and]]
            (v.buttonId ~= ISLAND_UP_MONTHCARD or v.buttonId == ISLAND_UP_MONTHCARD and false --[[CacheCenter:getMouthCardDays() < tonumber(CacheCenter:getGameParam().limitMonthlyCardDay)]]) and
            (v.buttonId ~= ISLAND_UP_RECHARGE or conFirst == nil --[[GlobalGame.g_bIsGetFirstRecharge~= true--]]) and
            --[[(v.buttonId ~= ISLAND_UP_WISHING_WELL or CacheCenter:isOpenPromise()) and]]
            (v.buttonId ~= ISLAND_UP_FUND or CacheCenter:getFundFinish() ~= true) and
            (v.buttonId ~= ISLAND_UP_MATCH or tonumber(GlobalMethod:crossServiceOpen()) == 1) and
            (v.buttonId ~= ISLAND_EXTEND_CHARM or tonumber(GlobalMethod:crossServiceOpen()) == 1) and
            (v.buttonId ~= ISLAND_UP_ELITE_SHOP or (IsNewHeroControl() and g_bloc_shop == "true" or (not IsNewHeroControl()) )) and
            (v.buttonId ~= ISLAND_UP_PRAY or (IsNewHeroControl() and g_bloc_pray == "true" )) and
            checkbuttonChannel(v.buttonChannel)) 
             then

            local isCon = GetElement(self.m_root, "con".. v.buttonId .."_WndOwnCity", WZUIContainer)

            local conBtn = isCon and isCon or self:_createIconButton(v.buttonId, false)
            --add by wuweidong 
            --签到图标处理
            if v.buttonId == ISLAND_UP_ATTENDANCE then 
                GlobalGame:getBtnRedPointEvent():regListener("Sign","WndOwnCity",conBtn,nil)
                local SignState =  CacheCenter:getRedState( "btnSign" )
                GlobalGame:getBtnRedPointEvent():dispatcher("Sign",SignState)
            end

            if v.buttonId == ISLAND_UP_QUALIFYING and GlobalGame.g_tRedPointList.qualifying then
                --[[
                local btn = GetElementWithoutAssert(self.m_root, "btn23_WndOwnCity", WZUIButton)
                if btn then
                    if true then
                        SceneCity:setRedPoint(btn,true,GlobalMethod:ccp(83,83))
                        WZLog("WndOwnCity:_update four")
                    else
                        SceneCity:setRedPoint(btn,false)
                        if GlobalGame.g_tRedPointList.qualifying then
                            GlobalGame.g_tRedPointList.qualifying = nil
                            ProtocolProcessorSceneCity:send_PLAYER_CancelRedDot(118)
                        end
                        WZLog("WndOwnCity:_update five")
                    end
                end
                --]]

            end

            if v.buttonId == ISLAND_UP_EVENT then
                GlobalGame:getBtnRedPointEvent():regListener("GameActivity","WndOwnCity",conBtn,nil)
                --[[
                if CacheCenter.m_tActivityItemRedDotList ~= nil then 
                    if #CacheCenter.m_tActivityItemRedDotList > 0 then 
                        GlobalGame:getBtnRedPointEvent():dispatcher("GameActivity",true)
                    else 
                        GlobalGame:getBtnRedPointEvent():dispatcher("GameActivity",false)
                    end 
                end
                --]]
            end

            --add by wuweidong end 
            if conBtn ~= nil then
                local right = 1.04
                if IsIphoneX() then
                    right = 0.88
                end
                index = index + 1
                if index <= -1 then
                    conBtn:setRelativePosition(GlobalMethod:ccp(right-offsetX * (i - 1- indexNo), 0.6))
                else
                    conBtn:setRelativePosition(GlobalMethod:ccp(right-offsetX * (index - 1), 0.0))
                end
                conBtn.index = index
                conBtn.btnId = v.buttonId
                if isCon then
                    conBtn:setVisible(true)
                else
                    conBtns:addChild(conBtn)
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

    --[[
    local nTag = 0
    local offset = 0.037

    local id = 0
    for i,v in ipairs(self.m_tLeftBtnsInfo) do
        WZLog("WndOwnCity:_update four", v.buttonId, btnIndex[v.buttonId])
        if btnIndex[v.buttonId] then
            local conBtn = GetElement(self.m_root, "conBtn"..btnIndex[v.buttonId].."_WndOwnCity", WZUIContainer)
            local isOpen = SceneCity:checkIconButtonOpen(v)
            if v.buttonId == 15 then
                isOpen = false
            end
            WZLog("WndOwnCity:_update one", i, id, tostring(isOpen), tostring(v.buttonId), tostring(btnIndex[v.buttonId]), offsetY, indexNo, self.m_nLeftBtnCount)
            

            if v.buttonId == 100 and isOpen then
                WZLog("WndOwnCity:_update one2")
                local conBtn = GetElement(SceneCity.m_tWndBottomBarObj.m_root, "btnFb_WndBottomBar", WZUIButton)
                conBtn:setVisible(true)
            elseif v.buttonId == 102 and isOpen then
                WZLog("WndOwnCity:_update one2")
                local conBtn = GetElement(SceneCity.m_tWndBottomBarObj.m_root, "btnGroup_WndBottomBar", WZUIButton)
                conBtn:setVisible(true)
            elseif conBtn and isOpen then
                conBtn:setVisible(true)
                id =id +1
                local offsetY = 0.9522 - offset * (id - 1)
                conBtn:setRelativePosition(GlobalMethod:ccp(offsetY, 1))
                WZLog("WndOwnCity:_update one", i, id, tostring(v.buttonId), tostring(btnIndex[v.buttonId]), offsetY)
            elseif conBtn then
                conBtn:setVisible(false)
            end
        end

        if v.buttonId == ISLAND_LEFT_HELPER and IsNewHeroControl() then
            isOpen = isOpen and g_bloc_tactic == "true"
        end

        if conBtn and isOpen then
            conBtn:setVisible(true)
            id =id +1
            local offsetY = 0.96 - offset * (id - 1)
            conBtn:setRelativePosition(GlobalMethod:ccp(offsetY, 0.991))
            WZLog("WndOwnCity:_update one", i, id, tostring(v.buttonId), tostring(btnIndex[v.buttonId]), offsetY)
        elseif conBtn then
            conBtn:setVisible(false)
        end
    end
    --]]
    local conNetSignal = GetElement(self.m_root, "conNetSignal_WndOwnCity", WZUIContainer)
    conNetSignal:setRelativePosition(GlobalMethod:ccp(0.96,0.991))
    if IsIphoneX() then
        conNetSignal:setRelativePosition(GlobalMethod:ccp(0.9,0.991))
    end
    CellNetSignal:showInterface(conNetSignal, nil, 1)

    WndOwnCity:checkSevenDay()
end

function WndOwnCity:openFootball(isOpen)
    if WndOwnCity.m_root == nil then return end 
    
    isOpen = isOpen and CheckButtonShow(ISLAND_UP_FOOT_BALL, true)
    WZLog("WndOwnCity:openFootball", isOpen)
    if WndOwnCity.m_root then
        local isVisible = GetElement(self.m_root, "con147_WndOwnCity", WZUIContainer):isVisible()
        if isOpen and isVisible == false then
            GetElement(self.m_root, "con147_WndOwnCity", WZUIButton):setVisible(true)
        elseif not isOpen and isVisible == true then
            GetElement(self.m_root, "con147_WndOwnCity", WZUIButton):setVisible(false)
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
        local isVisible = GetElement(self.m_root, "con149_WndOwnCity", WZUIContainer):isVisible()
        if isOpen and isVisible == false then
            GetElement(self.m_root, "con149_WndOwnCity", WZUIButton):setVisible(true)
        elseif not isOpen and isVisible == true then
            GetElement(self.m_root, "con149_WndOwnCity", WZUIButton):setVisible(false)
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
-------------------------------------语言适配End--------------------------------------------