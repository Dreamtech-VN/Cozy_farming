--CellKidSchoolRole.lua
--@brief	CellKidSchoolRole的UI模块
--@date     2021/5/10
--@author   yrd
--@note		家园打工宠物或守卫兽节点


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellKidSchoolRole:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellKidSchoolRole:onExit(element)
    local conOutSide = self:createOutSideCon() 
    conOutSide:disableSchedule()
    self.m_root:disableSchedule()
    
	self:_unInit()
end


--@brief    点击头像回调
function CellKidSchoolRole:onClickHead(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndKidSchoolKidInfo:showInterface(self.m_tData)
end

--@brief    创建根容器节点
function CellKidSchoolRole:createOutSideCon()
    -- body
    WZLog("CellKidSchoolRole:createOutSideCon")
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

--@brief    设置小孩的朝向
function CellKidSchoolRole:setKidDirector(bFlipX)
    -- body
    local conOutSide = self:createOutSideCon() 
    local element = conOutSide:getChildByTag(55)
    if element then
        element:setFlipX(bFlipX)
    end
end

--@brief    播放动作
function CellKidSchoolRole:playKidAni(actionName,loop)
    if self.m_conKidRole == nil then
        return
    end
    self.m_conKidRole:play(actionName, loop)
end

--@brief    获取格子数据
function CellKidSchoolRole:getRoleGridData()
    -- body
    return self.m_tGridData
end

--@brief    获取正在播放的动画名字
function CellKidSchoolRole:getAnimationName()
    -- body
    if self.m_conPlayer then 
        return self.m_sPlayerActionName
    elseif self.m_conKidRole then 
        return self.m_sKidActionName
    elseif self.m_conVisitorRole then
        return self.m_sVisitorActionName
    end
end

--@brief    播放指定动作
function CellKidSchoolRole:playAnimationByName(actionName)
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
    end
end

--@brief    获取形象
function CellKidSchoolRole:getPlayer()
    return self.m_conKidRole
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新
function CellKidSchoolRole:update()
    self:updateKidRole()

    self:_createBtnBuilding()
    self:_createName(self.m_tData.name, GlobalMethod:ccp(0.5, 0), GlobalMethod:ccp(0.5, 1.3), 88)
    --操作时间
    self:showOperatingTime()
    --状态
    self:createStatusIcon()
end

--@brief    创建孩子形象
function CellKidSchoolRole:updateKidRole()
    local conOutSide = self:createOutSideCon() 

    local tEquip = {}
    table.insert(tEquip,self.m_tData.headId)
    table.insert(tEquip,self.m_tData.faceId)
    table.insert(tEquip,self.m_tData.bodyId)
    if self.m_conKidRole == nil then
        self.m_sKidActionName = "wait"
        local conKid = CreatePlayerBabyFigure(self.m_tData.sex, tEquip, "wait")
        local animNode = conKid:getAnimNode()
        animNode:setScale(0.6)
        animNode:setTag(55)
        conOutSide:addChild(conKid:getAnimNode())
        self.m_conKidRole = conKid
    else
        local head = nil
        local face = nil
        local body = nil
        for i = 1, #tEquip do
            local nEquipId = tEquip[i]
            if nEquipId ~= nil then
                if type(nEquipId) == "table" then nEquipId = nEquipId.id end
                local tEquipData = GetItemLocalData(nEquipId)

                if tEquipData then
                    local maintype = tEquipData.main_type
                    local subtype = tEquipData.sub_type
                    if maintype == 31 and subtype == 3 then --物品是否是衣服 
                        body = (tEquipData.animation_index_code)
                    elseif maintype == 31 and subtype == 2 then --物品是否是脸谱
                        face = (tEquipData.animation_index_code)
                    elseif maintype == 31 and subtype == 1 then -- 物品是否是头部 
                        head = (tEquipData.animation_index_code)
                    end
                end
            end
        end
        --设置默认显示
        local gameParam = CacheCenter:getGameParam()
        if bIsBoy == true then
            if head == nil then head = GDatatab_item["id_"..(gameParam.defaultmaleHeadId or 51000)].animation_index_code end
            if face == nil then face = GDatatab_item["id_"..(gameParam.defaultmaleFaceId or 51200)].animation_index_code end
            if body == nil then body = GDatatab_item["id_"..(gameParam.defaultmaleBodyId or 51400)].animation_index_code end
        else
            if head == nil then head = GDatatab_item["id_"..(gameParam.defaultfemaleHeadId or 51100)].animation_index_code end
            if face == nil then face = GDatatab_item["id_"..(gameParam.defaultfemaleFaceId or 51300)].animation_index_code end
            if body == nil then body = GDatatab_item["id_"..(gameParam.defaultfemaleBodyId or 51500)].animation_index_code end
        end
        self.m_conKidRole:setHead(head)
        self.m_conKidRole:setFace(face)
        self.m_conKidRole:setBody(body)
    end
end

function CellKidSchoolRole:_createPlayerOrServantState(text, rpt, nTag, nType)
    -- body
    local conOutSide = self:createOutSideCon()
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
            ftxtText:setScale(0.8)
            ftxtText:setMaxWidth(150)
        elseif ProjConfig.LANGUAGE == "en" then
            ftxtText:setScale(0.7)
            ftxtText:setMaxWidth(240)
            con:setAbsContentSize(GlobalMethod:CCSize(160, 50))
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
function CellKidSchoolRole:_createName(text, anchorPt, relativePt, nTag)
    anchorPt = anchorPt or GlobalMethod:ccp(0.5, 0)
    relativePt = relativePt or GlobalMethod:ccp(0.5, 1.3)
    nTag = nTag or 88
    local conOutSide = self:createOutSideCon() 

    local txtName = conOutSide:getChildByTag(nTag)
    if txtName then 
        txtName = WZUILabelTTF:luaTo(txtName)
        txtName:setText(text)
    else
        local colorccc3 = GlobalMethod:ccc3(255,255,255)
        if SceneKidSchoolHome:isMyChild(self.m_tData.id) == true then
            colorccc3 = GlobalMethod:ccc3(99,255,95)
        end
        local txtName = WZUILabelTTF:create()
        txtName:setColor(colorccc3)
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

--@brief    创建状态
function CellKidSchoolRole:createStatusIcon()
    local conOutSide = self:createOutSideCon()

    if conOutSide:getChildByTag(333) then 
        conOutSide:removeChildByTag(333, true)
    end
    if SceneKidSchoolHome:isMyChild(self.m_tData.id) and self.m_tData.reward ~= 0 then
        local conStatus = WZUIContainer:create()
        conStatus:setUseAbsSize(true)
        conStatus:setAbsContentSize(GlobalMethod:CCSize(65,65))
        conStatus:setAnchorPoint(GlobalMethod:ccp(0.5, 0))
        conStatus:setRelativePosition(GlobalMethod:ccp(0, 1.7))

        local imgCollectState = WZUIImage:create()
        imgCollectState:setScale(1)
        imgCollectState:setUseOriginSize(true)
        imgCollectState:setTouchEnable(false)
        local spineFilePath = "ui/kid/kidicon/commom_qipao.png"
        imgCollectState:setFile(spineFilePath)
        conStatus:addChild(imgCollectState)

        local imgPath = {"ui/kid/kidicon/commom_hz_shu.png","ui/kid/kidicon/commom_hz_zzz.png","ui/kid/kidicon/commom_hz_qiu.png","ui/kid/kidicon/commom_hz_ufo.png"}
        --收集的物品图标
        local imgIcon = WZUIImage:create()
        imgIcon:setAnchorPoint(GlobalMethod:ccp(0.5, 0.5))
        imgIcon:setUseOriginSize(true)
        imgIcon:setTouchEnable(false)
        local pathStatus = imgPath[self.m_tData.reward]
        imgIcon:setFile(pathStatus)
        imgIcon:setRelativePosition(GlobalMethod:ccp(0.5, 0.6))
        imgIcon:setZOrder(1)
        imgCollectState:setZOrder(4)
        imgCollectState:addChild(imgIcon)

        -- local arrayAni = CCArray:create()
        -- local act1 = CCScaleTo:create(1,0.9)
        -- local act2 = CCScaleTo:create(1,1)
        -- arrayAni:addObject(act1)
        -- arrayAni:addObject(act2)
        -- local sequence = CCSequence:create(arrayAni)
        -- local repeatAni = CCRepeatForever:create(sequence)
        -- imgIcon:runAction(repeatAni)

        --添加点击回调
        local btnStatus = WZUIButton:create()
        btnStatus:setLuaDoneFunctionName("onClickStatus")
        conStatus:addChild(btnStatus)

        conStatus:setTag(333)
        conOutSide:addChild(conStatus)
    end

end

--@brief    点击宝箱图标
function CellKidSchoolRole:onClickStatus(element)
    --领取奖励
    ProtocolProcessorKidSchool:send_SCHOOL_ReceiveReward()
end

--@brief    显示操作时间进度条
function CellKidSchoolRole:showOperatingTime( )
    local conOutSide = self:createOutSideCon()

    if conOutSide:getChildByTag(444) then 
        conOutSide:removeChildByTag(444, true)
    end
    if SceneKidSchoolHome:isMyChild(self.m_tData.id) and self.m_tData.area ~= 0 then
        local conOperatingTime = WZUIContainer:create()
        conOperatingTime:setUseAbsSize(true)
        conOperatingTime:setAbsContentSize(GlobalMethod:CCSize(88,12))
        conOperatingTime:setAnchorPoint(GlobalMethod:ccp(0.5, 0))
        conOperatingTime:setRelativePosition(GlobalMethod:ccp(0.5, 1.5))

        local imgCollectState = WZUIImage:create()
        imgCollectState:setScale(1)
        imgCollectState:setUseOriginSize(true)
        imgCollectState:setTouchEnable(false)
        local spineFilePath = "ui/common/progress_hz_01.png"
        imgCollectState:setFile(spineFilePath)
        conOperatingTime:addChild(imgCollectState)

        local imgProgPath = "ui/common/progress_hz_02.png"
        local curTime = 0
        local maxTime = 0
        if self.m_tData.area == 1 or self.m_tData.area == 2 or self.m_tData.area == 3 then
            curTime = math.ceil(self.m_tData.learnTime / 60)
            maxTime = tonumber(CacheCenter:getGameParam().schoolLearnForDay)
            imgProgPath = "ui/common/progress_hz_03.png"
        elseif self.m_tData.area == 4 then
            curTime = math.ceil(self.m_tData.scienceTime / 60)
            maxTime = tonumber(CacheCenter:getGameParam().schoolSkillForDay)
            imgProgPath = "ui/common/progress_hz_02.png"
        end
        local prgLeftTime = WZUIProgress:create()
        prgLeftTime:setBgPicture(imgProgPath)
        prgLeftTime:setUseOriginSize(true)
        prgLeftTime:setPercentage(curTime/maxTime*100)
        conOperatingTime:addChild(prgLeftTime)

        local txtProg = WZUILabelTTF:create()
        txtProg:setText(curTime.."/"..maxTime..LocalStrings.MINUTE1)
        txtProg:setColor(ccc3(255,236,193))
        txtProg:setFontSize(12)
        txtProg:setEnableStroke(true)
        txtProg:setStrokeSize(4)
        txtProg:setStrokeColor(ccc3(132,66,29))
        conOperatingTime:addChild(txtProg)

        conOperatingTime:setTag(444)
        conOutSide:addChild(conOperatingTime)
    end
end

--@brief    创建孩子点击按钮
function CellKidSchoolRole:_createBtnBuilding()
    -- body
    WZLog("CellKidSchoolRole:_createBtnBuilding")
    local conOutSide = self:createOutSideCon() 

    if conOutSide:getChildByTag(91) then 
        conOutSide:removeChildByTag(91, true)
    end
    btnBuilding = WZUIButton:create()
    btnBuilding:setName("btnHead_CellKidSchoolRole")
    btnBuilding:setAnchorPoint(GlobalMethod:ccp(0.5, 0))
    btnBuilding:setRelativePosition(GlobalMethod:ccp(0.5, 0))
    btnBuilding:setUseAbsSize(true)
    btnBuilding:setAbsContentSize(GlobalMethod:CCSize(65,100))
    btnBuilding:setLuaDoneFunctionName("onClickHead")
    btnBuilding:setZOrder(3)
    btnBuilding:setTag(91)

    conOutSide:addChild(btnBuilding)
end

--@brief    创建阴影
function CellKidSchoolRole:_createShadow(parentNode, imgPath, relativePt, nScale)
    -- body
    local imgGold = WZUIImage:create()
    imgGold:setUseOriginSize(true)
    imgGold:setRelativePosition(relativePt)
    imgGold:setFile(imgPath)
    imgGold:setScale(nScale)
    parentNode:addChild(imgGold)
end

--@brief    设置孩子的状态
function CellKidSchoolRole:setKidState(state)
    -- body
    self.m_tData.state = state
end

--@brief    小孩更换时装
function CellKidSchoolRole:resetDress(itemId)
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

--@brief    小孩飘字
function CellKidSchoolRole:showFloatWord(rType, rId, rNum)
    local conOutSide = self:createOutSideCon()

    local nAddNum = rNum[1]
    local imgPathWord = ""
    local imgPathSymbols = ""
    local imgPathNum = ""
    if rType[1] == 1 then
        imgPathWord = "ui/common/commom_text_zl.png"
        imgPathSymbols = "ui/common_num/hzlv_+.png"
        imgPathNum = "ui/common_num/hzlv_0-9.png"
    elseif rType[1] == 2 then
        imgPathWord = "ui/common/commom_text_xs.png"
        imgPathSymbols = "ui/common_num/hzlv_+.png"
        imgPathNum = "ui/common_num/hzl_0-9.png"
    elseif rType[1] == 3 then
        imgPathWord = "ui/common/commom_text_tl.png"
        imgPathSymbols = "ui/common_num/hzlv_+.png"
        imgPathNum = "ui/common_num/hzh_0-9.png"
    end

    local conWord = WZUIContainer:create()
    conWord:setUseAbsSize(true)
    conWord:setAbsContentSize(GlobalMethod:CCSize(120,20))
    conWord:setAnchorPoint(GlobalMethod:ccp(0.5, 0))
    conWord:setRelativePosition(GlobalMethod:ccp(0.5, 1.5))

    local imgWord = WZUIImage:create()
    imgWord:setAnchorPoint(ccp(1,0.5))
    imgWord:setRelativePosition(ccp(0.5,0.5))
    imgWord:setUseOriginSize(true)
    imgWord:setFile(imgPathWord)
    conWord:addChild(imgWord)

    local imgSymbols = WZUIImage:create()
    imgSymbols:setAnchorPoint(ccp(0,0.5))
    imgSymbols:setRelativePosition(ccp(0.5,0.5))
    imgSymbols:setUseOriginSize(true)
    imgSymbols:setFile(imgPathSymbols)
    conWord:addChild(imgSymbols)

    local txtAtlasFont = WZUILabelAtlasFont:create()
    txtAtlasFont:setCharMapFileName(imgPathNum)
    txtAtlasFont:setStartChar(48)
    txtAtlasFont:setHeight(27)
    txtAtlasFont:setWidth(19)
    txtAtlasFont:setUseOriginSize(true)
    txtAtlasFont:setAnchorPoint(ccp(0,0.5))
    txtAtlasFont:setRelativePosition(ccp(0.7,0.5))
    txtAtlasFont:setText(nAddNum)
    conWord:addChild(txtAtlasFont)

    conOutSide:addChild(conWord, 12, 900)

    local x,y = conWord:getPosition()
    local startSpeed = 0.3

    local act1=CCMoveTo:create(startSpeed,ccp(x,y+20))
    local act2=CCDelayTime:create(0.7)
    local act3=CCCallFuncN:create(self.endFloatWord)
    local array = CCArray:create()
    array:addObject(act1)
    array:addObject(act2)
    array:addObject(act3)
    conWord:runAction(CCSequence:create(array))
end

function CellKidSchoolRole:endFloatWord()
    WZLog("CellKidSchoolRole:endFloatWord")
    local kidObj = SceneKidSchoolHome:getMayChildRole()
    local conOutSide = self:createOutSideCon()
    if conOutSide and conOutSide:getChildByTag(900) then
        conOutSide:removeChildByTag(900, true)
    end
end
-------------------------------------私有方法模块End----------------------------------------
