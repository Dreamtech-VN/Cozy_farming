--CellKidRole.lua
--@brief	CellKidRole的UI模块
--@date		2017/07/26
--@author	Tianxiang_Xu
--@note		家园打工宠物或守卫兽节点


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellKidRole:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellKidRole:onExit(element)
    local conOutSide = self:_createOutSideCon() 
    conOutSide:disableSchedule()
    self.m_root:disableSchedule()
    
	self:_unInit()
end

--@brief    点击头像回调
function CellKidRole:onClickHead(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if SceneKidHome.m_nPlayerId ~= CacheCenter:getPlayerInfo().id then return end 

    if self.m_nType == 3 then
        if self.m_tCellCar then
            --在玩摇摇车，不执行安抚、喂食、换尿布操作
            return 
        end
        local tBits = SceneKidHome:_NumberToBits(self.m_tData.state, 3)
        if tBits[1] == 1 then   --哭
            ProtocolProcessorKid:send_WEDDING_AppeaseChild(self.m_tData.id, 1, 0, 0)
        elseif tBits[2] == 1 then --饿
            WndKidFeed:showInterface(self.m_tData, 1)
        elseif tBits[3] == 1 then --尿裤子
            WndKidFeed:showInterface(self.m_tData, 2)
        else --抚摸
            if self.m_tData.touch == 0 then
                ProtocolProcessorKid:send_WEDDING_ChildInteract(self.m_tData.id, 1, 0, 0)
            else
                MsgBoxManager:showTipBox(LocalStrings.KID_TEXT118)
            end
        end
    end
end

--@brief    创建根容器节点
function CellKidRole:_createOutSideCon()
    -- body
    WZLog("CellKidRole:_createOutSideCon")
    if self.m_root == nil then return end 
    
    if self.m_conOutSide == nil then 
        local nConWidth = 65
        local nConHeight = 75

        conOutSide = WZUIContainer:create()
        conOutSide:setUseAbsSize(true)
        conOutSide:setAbsContentSize(GlobalMethod:CCSize(nConWidth, nConHeight))
        conOutSide:setTag(90)
        self.m_conOutSide = conOutSide 

        self.m_root:addChild(conOutSide)
    end

    return self.m_conOutSide
end

--@brief    设置宠物的朝向
function CellKidRole:setPetDirector(bFlipX)
    -- body
    local conOutSide = self:_createOutSideCon() 
    local element = conOutSide:getChildByTag(55)
    if element then
        element:setFlipX(bFlipX)
    end
end

--@brief    展示怀孕时间
function CellKidRole:setShowConceiveTime()
    -- body
    local conOutSide = self:_createOutSideCon() 

    if self.m_nType == 1 then
        if SceneKidHome.m_nServantTime > 0 then
            local sContent = self:_rtnContent()

            self:_createPlayerOrServantState(sContent, GlobalMethod:ccp(0.5, 1.1), 22)
            conOutSide:enableSchedule("_caculateTime", 1)
        end
    elseif self.m_nType == 2 then
        if SceneKidHome.m_nConceiveTime > 0 then
            local sContent = self:_rtnContent()

            self:_createPlayerOrServantState(sContent, GlobalMethod:ccp(0.5, 2.5), 11)
            conOutSide:enableSchedule("_caculateTime", 1)
        end
    elseif self.m_nType == 3 then
        if self.m_tData.nextCheckTime > 0 then
            --定时刷新小孩状态
            conOutSide:enableSchedule("_caculateTime", 1)
        end
    elseif self.m_nType == 4 then
        local nRemainingTime = SceneKidHome.m_nSingleVisitTime - (SystemTime:getServerTime() - self.m_tData.visitorTimes)
        local s = nRemainingTime%60
        local m = math.floor(nRemainingTime/60)%60
        local h = math.floor(nRemainingTime/3600)
        local strContent = string.format(LocalStrings.KID_HOME_TEXT8,h,m,s)
        if nRemainingTime > 0 then
            --定时刷新拜访时间
            self:_createPlayerOrServantState(strContent, GlobalMethod:ccp(0.5, 0), 44, 4)
            conOutSide:enableSchedule("_caculateTime", 1)
        end
    end
end

--@brief    设置翻转
function CellKidRole:setServantDirector(boolValue)
    -- body
    local conOutSide = self:_createOutSideCon() 
    if self.m_nType == 1 then
        local servantRole = conOutSide:getChildByTag(55)
        if servantRole then
            servantRole:setFlipX(boolValue)
        end
    end
end

--@brief    获取格子数据
function CellKidRole:getRoleGridData()
    -- body
    return self.m_tGridData
end

--@brief    获取正在播放的动画名字
function CellKidRole:getAnimationName()
    -- body
    if self.m_conPlayer then 
        return self.m_sPlayerActionName
    elseif self.m_conKidRole then 
        return self.m_sKidActionName
    elseif self.m_conVisitorRole then
        return self.m_sVisitorActionName
    elseif self.m_conSpiritRole then
        return self.m_sSpiritActionName
    end
end

--@brief    播放指定动作
function CellKidRole:playAnimationByName(actionName)
    -- body
    if self.m_conPlayer then 
        self.m_sPlayerActionName = actionName 
        return self.m_conPlayer:play(actionName, true)
    elseif self.m_conKidRole then 
        self.m_sKidActionName = actionName
        return self.m_conKidRole:play(actionName, true)
    elseif self.m_conVisitorRole then 
        self.m_sVisitorActionName = actionName
        return self.m_conVisitorRole:play(actionName, true)
    elseif self.m_conSpiritRole then 
        self.m_sSpiritActionName = actionName
        return self.m_conSpiritRole:play(actionName, true)
    end
end

--@brief    获取形象
function CellKidRole:getPlayer()
    -- body
    if self.m_nType == 2 then
        return self.m_conPlayer
    elseif self.m_nType == 3 then
        return self.m_conKidRole
    elseif self.m_nType == 4 or self.m_nType == 5 then
        return self.m_conVisitorRole
    elseif self.m_nType == 6 then
        return self.m_conSpiritRole
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新
function CellKidRole:_update()
    -- body
    local conOutSide = self:_createOutSideCon() 
    if self.m_nType == 1 then
        --宠物形象
        local petAni, backFire = CreatePetAni(conOutSide, self.m_tData.petId)
        local animNode = petAni:getAnimNode()
        animNode:setTouchEnable(false)
        animNode:setScale(0.6)
        animNode:setTag(55)
        if backFire then
            backFire:setVisible(false)
        end
        
        if SceneKidHome.m_nServantTime > 0 then
            --打工倒计时
            local sContent = self:_rtnContent()

            self:_createPlayerOrServantState(sContent, GlobalMethod:ccp(0.5, 1.1), 22)
            conOutSide:enableSchedule("_caculateTime", 1)
        end

        self:_createBtnBuilding()
    elseif self.m_nType == 2 then
        --名字（状态）
        local conPlayer = CreatePlayerFigure(self.m_tData.sex, self.m_tData.tEquip, "wait0", nil, nil ,nil, nil, nil ,nil, nil, self.m_tData.headColor, self.m_tData.bodyColor, false)
        conPlayer:getAnimNode():setScale(0.6)
        conPlayer:getAnimNode():setTouchEnable(false)
        conOutSide:addChild(conPlayer:getAnimNode())
        self.m_sPlayerActionName = "wait0"
        self.m_conPlayer = conPlayer
    elseif self.m_nType == 3 then
        local tEquip = {}

        table.insert(tEquip,self.m_tData.headId)
        table.insert(tEquip,self.m_tData.faceId)
        table.insert(tEquip,self.m_tData.bodyId)
        self.m_sKidActionName = "wait"
        local conKid = CreatePlayerBabyFigure(self.m_tData.sex, tEquip, "wait")
        conKid:getAnimNode():setScale(0.6)
        
        conOutSide:addChild(conKid:getAnimNode())
        self.m_conKidRole = conKid 

        self:_createBtnBuilding()
        self:_createName(self.m_tData.name, GlobalMethod:ccp(0.5, 0), GlobalMethod:ccp(0.5, 1.3), 88)
    elseif self.m_nType == 4 or self.m_nType == 5 then
        local bIsMonster = false  
        if self.m_nType == 5 then 
            bIsMonster = nil 
        end
        local conVisitor = CreatePlayerFigure(self.m_tData.sex, self.m_tData.tEquip, "wait0", nil, nil ,nil, nil, nil ,nil, nil, self.m_tData.headColor, self.m_tData.bodyColor, bIsMonster)
        conVisitor:getAnimNode():setScale(0.6)
        conVisitor:getAnimNode():setTouchEnable(false)
        if conOutSide:getChildByTag(99) then 
            conOutSide:removeChildByTag(99, true)
        end
        conOutSide:addChild(conVisitor:getAnimNode(), 0, 99)
        self.m_sVisitorActionName = "wait0"
        self.m_conVisitorRole = conVisitor

        if self.m_nType == 4 then 
            local nRemainingTime = SceneKidHome.m_nSingleVisitTime - (SystemTime:getServerTime() - self.m_tData.visitorTimes)
            if nRemainingTime <= 0 then
                self.m_root:setVisible(false)
            end
        else
            self:_createName(self.m_tData.name, GlobalMethod:ccp(0.5, 0), GlobalMethod:ccp(0.5, 2.2), 88)
        end
    elseif self.m_nType == 6 then
        local tSpiritInfo = GDatatab_holiday_spirit["id_"..self.m_tData.spiritId]
        local tSpiritStep = WndHVSpirit:getSpiritStep(self.m_tData.spiritId, self.m_tData.spiritStep)
        local spine = WZUISpine:create()
        spine:setTouchEnable(false)
        spine:setFileJson(tSpiritStep.animation..".json")
        spine:setFileAtlas(tSpiritStep.animation..".atlas")
        spine:setUseOriginSize(true)
        spine:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
        spine:play(tSpiritStep.action,true)
        if conOutSide:getChildByTag(99) then 
            conOutSide:removeChildByTag(99, true)
        end
        conOutSide:addChild(spine, 0, 99)
        self.m_sSpiritActionName = "wait"
        self.m_conSpiritRole = spine

        self:_createName(tSpiritInfo.name, GlobalMethod:ccp(0.5, 0), GlobalMethod:ccp(0.5, 2.2), 88)
    end
end

function CellKidRole:_createPlayerOrServantState(text, rpt, nTag, nType)
    -- body
    local conOutSide = self:_createOutSideCon()
    local con = conOutSide:getChildByTag(nTag)
    if con then
        local ftxtText = con:getChildByTag(94)
        if ftxtText then
            ftxtText = WZUIFreeTextBox:luaTo(ftxtText)
            ftxtText:setShowText(text)
        end
    else
        local con = WZUIContainer:create()
        con:setUseAbsSize(true)
        con:setAbsContentSize(GlobalMethod:CCSize(120, 42))
        con:setTag(nTag)
        con:setRelativePosition(rpt)
        conOutSide:addChild(con)

        local img9Bk = WZUI9Image:create()
        img9Bk:setFile("ui/kid/kidicon/couple_scale9_002.png")
        con:addChild(img9Bk)

        local ftxtText = WZUIFreeTextBox:create()
        ftxtText:setAnchorPoint(GlobalMethod:ccp(0, 1))
        ftxtText:setRelativePosition(GlobalMethod:ccp(0.05,0.95))
        ftxtText:setMaxWidth(110)
        ftxtText:setShowText(text)
        ftxtText:setTag(94)
        ftxtText:setName("ftxtText_conTime")
        con:addChild(ftxtText)
        if ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" then
            ftxtText:setScale(0.7)
            ftxtText:setMaxWidth(150)
        elseif ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "ug" then
            ftxtText:setScale(0.7)
            ftxtText:setMaxWidth(240)
            con:setAbsContentSize(GlobalMethod:CCSize(160, 50))
            con:updateRelativeSize()
        elseif ProjConfig.LANGUAGE == "tr" then
            ftxtText:setScale(0.7)
            ftxtText:setMaxWidth(240)
            con:setAbsContentSize(GlobalMethod:CCSize(120, 50))
            con:updateRelativeSize()
        end

        if nType == 4 then
            ftxtText:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
            ftxtText:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
            ftxtText:setMaxWidth(170)
            img9Bk:setFile("ui/common/frame_djs.png")
            con:setAbsContentSize(GlobalMethod:CCSize(178,42))
            con:updateRelativeSize()
            con:setRelativePosition(GlobalMethod:ccp(0.5,2.5))
        end
    end
end

--@brief    创建名字
function CellKidRole:_createName(text, anchorPt, relativePt, nTag)
    anchorPt = anchorPt or GlobalMethod:ccp(0.5, 0)
    relativePt = relativePt or GlobalMethod:ccp(0.5, 1.3)
    nTag = nTag or 88
    local conOutSide = self:_createOutSideCon() 

    local txtName = conOutSide:getChildByTag(nTag)
    if txtName then 
        txtName = WZUILabelTTF:luaTo(txtName)
        txtName:setText(text)
    else
        local txtName = WZUILabelTTF:create()
        txtName:setColor(GlobalMethod:ccc3(255,255,255))
        txtName:setStrokeColor(GlobalMethod:ccc3(105,65,46))
        txtName:setFontSize(14)
        txtName:setEnableStroke(true)
        txtName:setStrokeSize(2)
        txtName:setAnchorPoint(anchorPt)
        txtName:setRelativePosition(relativePt)
        txtName:setText(text)
        txtName:setZOrder(3)
        txtName:setTag(nTag)
        conOutSide:addChild(txtName)
    end
end

--@brief    创建完成打工图标
function CellKidRole:_createGoldIcon(imgPath, relativePt, nTag)
    -- body
    local conOutSide = self:_createOutSideCon() 

    local imgGold = conOutSide:getChildByTag(nTag)
    if not imgGold then 
        local imgGold = WZUIImage:create()
        imgGold:setRelativePosition(relativePt)
        imgGold:setFile(imgPath)
        imgGold:setZOrder(3)
        imgGold:setTag(nTag)
        imgGold:setScale(0.6)
        conOutSide:addChild(imgGold)
    end
end

--@brief    移除金币图标
function CellKidRole:removeGoldIcon()
    -- body
    local conOutSide = self:_createOutSideCon() 

    if conOutSide:getChildByTag(44) then
        conOutSide:removeChildByTag(44, true)
    end
end


--@brief    创建宠物点击按钮
function CellKidRole:_createBtnBuilding()
    -- body
    WZLog("CellKidRole:_createBtnBuilding")
    local conOutSide = self:_createOutSideCon() 

    btnBuilding = WZUIButton:create()
    btnBuilding:setName("btnHead_CellKidRole")
    btnBuilding:setAnchorPoint(GlobalMethod:ccp(0.5, 0))
    btnBuilding:setRelativePosition(GlobalMethod:ccp(0.5, 0))
    btnBuilding:setUseAbsSize(true)
    btnBuilding:setAbsContentSize(GlobalMethod:CCSize(65,100))
    btnBuilding:setLuaDoneFunctionName("onClickHead")
    btnBuilding:setZOrder(3)
    btnBuilding:setTag(91)

    conOutSide:addChild(btnBuilding)
end

--@brief    倒计时
function CellKidRole:_caculateTime()
    -- body
    local conOutSide = self:_createOutSideCon() 
    if self.m_nType == 1 then
        if SceneKidHome.m_nServantTime > 0 then
            SceneKidHome.m_nServantTime = SceneKidHome.m_nServantTime - 1 

            local sContent = self:_rtnContent()
            self:_createPlayerOrServantState(sContent, GlobalMethod:ccp(0.5, 1.1), 22)
        else
            conOutSide:disableSchedule()
            --移除佣人
            SceneKidHome:dealwithFinishTime(self.m_nType)
        end
    elseif self.m_nType == 2 then
        if SceneKidHome.m_nConceiveTime > 0 then
            SceneKidHome.m_nConceiveTime = SceneKidHome.m_nConceiveTime - 1

            local sContent = self:_rtnContent()
             self:_createPlayerOrServantState(sContent, GlobalMethod:ccp(0.5, 2.5), 11)
        else
            conOutSide:disableSchedule()
            if conOutSide:getChildByTag(11) then 
                conOutSide:removeChildByTag(11, true)
            end
            SceneKidHome:dealwithFinishTime(self.m_nType)
        end
    elseif self.m_nType == 3 then
        if self.m_tData.nextCheckTime > 0 then
            self.m_tData.nextCheckTime = self.m_tData.nextCheckTime - 1
        else
            conOutSide:disableSchedule()
            ProtocolProcessorKid:send_WEDDING_GetChildStatus(self.m_tData.id)
        end
    elseif self.m_nType == 4 then
        local nRemainingTime = SceneKidHome.m_nSingleVisitTime - (SystemTime:getServerTime() - self.m_tData.visitorTimes)
        local s = nRemainingTime%60
        local m = math.floor(nRemainingTime/60)%60
        local h = math.floor(nRemainingTime/3600)
        local strContent = string.format(LocalStrings.KID_HOME_TEXT8,h,m,s)
        if nRemainingTime > 0 then
             self:_createPlayerOrServantState(strContent, GlobalMethod:ccp(0.5, 0), 44, 4)
        else
            conOutSide:disableSchedule()
            if conOutSide:getChildByTag(44) then 
                conOutSide:removeChildByTag(44, true)
            end
            self.m_root:setVisible(false)
        end
    end
end

--@brief    返回显示的文本
function CellKidRole:_rtnContent()
    -- body
    local sFormat = [[<T C="105,65,46" S="18" P="1" SC="127,70,26" SS="4" SE="0">%s</T><BR></BR><T C="105,65,46" S="18" P="1" SC="127,70,26" SS="4" SE="0">%d:%02d:%02d</T>]]
    if self.m_nType == 1 then
        local hours = math.floor(SceneKidHome.m_nServantTime/3600)
        local minutes = math.floor((SceneKidHome.m_nServantTime%3600)/60)
        local seconds = SceneKidHome.m_nServantTime%60
        local sContent = string.format(sFormat, LocalStrings.KID_TEXT57, hours, minutes, seconds)

        return sContent
    elseif self.m_nType == 2 then
        local hours = math.floor(SceneKidHome.m_nConceiveTime/3600)
        local minutes = math.floor((SceneKidHome.m_nConceiveTime%3600)/60)
        local seconds = SceneKidHome.m_nConceiveTime%60
        if SceneKidHome.m_tMateData and GetTableLen(SceneKidHome.m_tMateData) > 0 then
            local sContent = string.format(sFormat, LocalStrings.KID_TEXT58, hours, minutes, seconds)
            return sContent
        else
            local sContent = string.format(sFormat, LocalStrings.KID_TEXT59, hours, minutes, seconds)
            return sContent
        end
    elseif self.m_nType == 3 then

    end
end

--@brief    创建阴影
function CellKidRole:_createShadow(parentNode, imgPath, relativePt, nScale)
    -- body
    local imgGold = WZUIImage:create()
    imgGold:setUseOriginSize(true)
    imgGold:setRelativePosition(relativePt)
    imgGold:setFile(imgPath)
    imgGold:setScale(nScale)
    parentNode:addChild(imgGold)
end

--@brief    设置孩子的状态
function CellKidRole:setKidState(state)
    -- body
    self.m_tData.state = state

    self:playKidState(true)
end

function CellKidRole:playKidState(bVisible)
    --body
    local conOutSide = self:_createOutSideCon() 
    local tBits = SceneKidHome:_NumberToBits(self.m_tData.state, 3)
    if conOutSide:getChildByTag(333) then 
        conOutSide:removeChildByTag(333, true)
    end
    if self.m_nType ~= 3 then return end 
    if bVisible == false then return end 
    local bIsExist = false 
    local nIndex = 0
    for i = 1, #tBits do
        if tBits[i] == 1 then
            bIsExist = true
            nIndex = i
            break 
        end
    end
    if not bIsExist then return end 

    if conOutSide then
        local imgCollectState = WZUIImage:create()
        imgCollectState:setScale(1)
        imgCollectState:setAnchorPoint(GlobalMethod:ccp(0.5, 0))
        imgCollectState:setVisible(true)
        imgCollectState:setUseOriginSize(true)
        imgCollectState:setTouchEnable(false)
        local spineFilePath = "ui/kid/kidicon/couple_scale9_001.png"
        imgCollectState:setFile(spineFilePath)
        imgCollectState:setRelativePosition(GlobalMethod:ccp(0.5, 1.3))
        --收集的物品图标
        local imgIcon = WZUIImage:create()
        imgIcon:setScale(0.5)
        imgIcon:setAnchorPoint(GlobalMethod:ccp(0.5, 1))
        imgIcon:setVisible(true)
        imgIcon:setUseOriginSize(true)
        imgIcon:setTouchEnable(false)

        if nIndex == 1 then
            spineFilePath = "ui/kid/kidicon/couple_icon_006.png"
        elseif nIndex == 2 then
            spineFilePath = "ui/kid/kidicon/couple_icon_naiping.png"
        elseif nIndex == 3 then 
            spineFilePath = "ui/kid/kidicon/couple_icon_004.png"
            if self.m_tData.sex == 1 then
                spineFilePath = "ui/kid/kidicon/couple_icon_005.png"
            end
        end
        imgIcon:setFile(spineFilePath)
        imgIcon:setRelativePosition(GlobalMethod:ccp(0.5, 0.96))
        imgIcon:setZOrder(1)
        imgCollectState:setZOrder(4)
        imgCollectState:addChild(imgIcon)

        imgCollectState:setTag(333)
        conOutSide:addChild(imgCollectState)
    end
end

--@brief    播放骑马机动画
function CellKidRole:playMountAni(flipStatus, tCellCar)
    --body
    local conOutSide = self:_createOutSideCon() 
    conOutSide:removeAllChildrenWithCleanup(true)

    self.m_bIsPlayCar = true
    self.m_tCellCar = tCellCar

    local tEquip = {}
    WZLog("CellKidRole:playMountAni")
    table.insert(tEquip,self.m_tData.headId)
    table.insert(tEquip,self.m_tData.faceId)
    table.insert(tEquip,self.m_tData.bodyId)
    self.m_sKidActionName = "ride"

    local conKid = CreatePlayerBabyFigure(self.m_tData.sex, tEquip, "wait")
    conKid:setMount(1)
    conKid:play("ride", true)
    conKid:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.55, 0.33))
    conOutSide:addChild(conKid:getAnimNode())
    self.m_conKidRole = conKid 
    self.m_conKidRole:getAnimNode():setScale(0.88)
    if flipStatus == 0 then
        self.m_conKidRole:setFlipX(true)
    else
        self.m_conKidRole:setFlipX(false)
    end

    self:_createBtnBuilding()
    self:_createName(self.m_tData.name, GlobalMethod:ccp(0.5, 0), GlobalMethod:ccp(0.5, 1.3), 88)

    self.m_root:enableSchedule("playNormalAni", 10)
end

--@brief    抚摸后播放微笑动作
function CellKidRole:playSmileAfterTouch()
    -- body
    if self.m_conKidRole then
        WZLog("CellKidRole:playSmileAfterTouch")
        self.m_conKidRole:play("wait_happy", true)
        self.m_sKidActionName = "wait_happy"

        self.m_root:enableSchedule("playNormalAni", 3)
    end
end

--@brief    恢复正常动作
function CellKidRole:playNormalAni()
    -- body
    self.m_root:disableSchedule()
    self.m_sKidActionName = "wait"
    if self.m_conKidRole then
        WZLog("CellKidRole:playNormalAni")
        self.m_conKidRole:play("wait", true)
        self.m_conKidRole:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.5, 0))
        self.m_conKidRole:getAnimNode():setScale(0.6)
        if self.m_tGridData then
            local tTempData = {}
            tTempData.size = {{1,1}}
            local nAbsX, nAbsY = SceneKidHome:_getAbsPosition(self.m_tGridData[1], self.m_tGridData[2], tTempData)
            self.m_root:setAbsPosition(GlobalMethod:ccp(nAbsX, nAbsY + KID_MAP_SIZEY))
        end
        self:showPlayCar(true)
        SceneKidHome:deleteKidRideData(self.m_tData.id)
    end
end

--@brief    设置摇摇车的可见与否
function CellKidRole:showPlayCar(bVisible)
    -- body
    if self.m_tCellCar then
        if bVisible then
            self.m_bIsPlayCar = false
        end
        self.m_tCellCar.m_root:setVisible(bVisible)
        self.m_tCellCar = nil 
    end
end

--@brief    小孩更换时装
function CellKidRole:resetDress(itemId)
    -- body
    if self.m_conKidRole == nil then return end 

    local basicInfo = GDatatab_item["id_" .. itemId]
    if basicInfo.sub_type == 1 then
        self.m_tData.headId = itemId
    elseif basicInfo.sub_type == 2 then
        self.m_tData.faceId = itemId
    elseif basicInfo.sub_type == 3 then
        self.m_tData.bodyId = itemId 
    end

    local conPlayer = self.m_conKidRole

    local animation_index_code = basicInfo.animation_index_code 
    if basicInfo.sub_type == 1 then
        conPlayer:setHead(animation_index_code)
    elseif basicInfo.sub_type == 2 then
        conPlayer:setFace(animation_index_code)
    elseif basicInfo.sub_type == 3 then
        conPlayer:setBody(animation_index_code)
    end

    conPlayer:play(self.m_sKidActionName, true)
end

--@brief    获取骑车状态
function CellKidRole:getPlayCarState()
    -- body
    return self.m_bIsPlayCar
end

--@brief    显示精灵饥饿对话框
function CellKidRole:showHungerStatus(bShow)
    local nTag = 456

    local conOutSide = self:_createOutSideCon()
    local con = conOutSide:getChildByTag(nTag)
    if not con then
        con = WZUIContainer:create()
        con:setUseAbsSize(true)
        con:setAbsContentSize(GlobalMethod:CCSize(120,94))
        con:setTag(nTag)
        con:setRelativePosition(GlobalMethod:ccp(-0.95,2.2))
        conOutSide:addChild(con)

        local img = WZUIImage:create()
        img:setFile("ui/common/commom_qipao_3.png")
        con:addChild(img)

        local txt = WZUILabelTTF:create()
        txt:setFontSize(18)
        txt:setColor(GlobalMethod:ccc3(127,70,26))
        txt:setDimensions(GlobalMethod:CCSize(100,0))
        txt:setRelativePosition(GlobalMethod:ccp(0.5,0.565))
        txt:setText(LocalStrings.HOLIDAYVILLAGE_TEXT4[30])
        con:addChild(txt)

        local btn = WZUIButton:create()
        btn:setLuaDoneFunctionName("onClickHungerDialog")
        con:addChild(btn)

        if ProjConfig.LANGUAGE == "vn" then
            txt:setScale(0.8)
        end
    end

    con:setVisible(bShow)
end

--@brief    点击精灵饥饿对话框
function CellKidRole:onClickHungerDialog(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndHVSpirit:showInterface()
end

-------------------------------------私有方法模块End----------------------------------------
