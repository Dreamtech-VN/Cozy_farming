--CellWakeupDetail.lua
--@brief	CellWakeupDetail的UI模块
--@date		2017/05/20
--@author	Tianxiang_Xu
--@note		觉醒模块-魂，体，力，技


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellWakeupDetail:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
    CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellWakeupDetail:onExit(element)
    CacheCenter:unregisterUpatePlayerItemObserver(self)
	self:_unInit()
end

--@brief    界面加载完成回调
function CellWakeupDetail:onEnterTransitionDidFinish(element)
	self.m_nSelM = 1
    -- body
    self:_setStaticText()
    WndWakeup:_stopLoading()
    self:_update()
end

--@brief    觉醒之魂属性按钮回调
function CellWakeupDetail:onClickPro(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local tUpgradeData = GDatatab_awake_crystal["id_" .. self.m_nSoulLevel]
    if tUpgradeData.add_property == 0 then
        MsgBoxManager:showTipBox(LocalStrings.WAKEUP_TEXT17)
    else
        local fighting = self:_caculateFighting(tUpgradeData.add_property)
        self:_createPropertyTips(self.m_root, fighting, tUpgradeData.add_property)
    end
end

--@brief    觉醒之魂点击培养按钮回调
function CellWakeupDetail:onClickTrain(nTag, num)
    -- body
    local tCostId = {503,502,501,500}
    local nTempNum = CacheCenter:getPlayerItemCountById(tCostId[nTag])
    if nTempNum == 0 then
        local basicInfo = GDatatab_item["id_" .. tCostId[nTag]]
        local tipContent = basicInfo.name .. LocalStrings.NOT_ENABLE
        JudgeMoneyIsEnough(tCostId[nTag], 1, tipContent,nil,202)
    else
        self.m_nUseCoinIndex = nTag
        WndWakeup:_createLoading()
        ProtocolProcessorWakeup:send_AWAKE_AwakeSoulTrain(tCostId[nTag], num)
    end
end

--@brief    觉醒之体点击领取或前往按钮回调
function CellWakeupDetail:onClickRec(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_nBodyState == 0 then
        --发送领取协议领取时装
        WndWakeup:_createLoading()
		WndPhantom.show = 1
        ProtocolProcessorWakeup:send_AWAKE_DrawAwakeSuit( )
    elseif self.m_nBodyState == 1 then
        --前往幻化界面
        self:addCellItemId()
        JumpByUIId(201)
    end
end

--@brief    获取路径
function CellWakeupDetail:onClickPath(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndWakeupcoinJump:showInterface()
end

--@brief    点击幻化技能图标回调
function CellWakeupDetail:onClickSkill(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local conBody = GetElement(self.m_root, "conBody_CellWakeupDetail", WZUIContainer)
    skinId = self:_getCorrectSkin()
    local tData = GDatatab_shape_skins["id_" .. skinId]
    WndTips:show(element,conBody,36,tData,GlobalMethod:ccp(410,-22))
end

--@brief    点击觉醒之力界面的技能图标回调
function CellWakeupDetail:onClickPowerSkill(element, tCell, tData)
    -- body
    self.m_tCellClick = tCell 
    WndTips:show(element, WndWakeup.m_root, 45, tData, GlobalMethod:ccp(40,0), true)
end

--@brief    点击觉醒之力天赋tips升级或激活按钮回调
function CellWakeupDetail:onClickPowerUpgrade(tData)
    -- body
    if self.m_root == nil then return end 
    WZLog("CellWakeupDetail:onClickPowerUpgrade")
    local tBasicData = GDatatab_talent_Skill["id_" .. tData.id]
    local nCostGoodNum = CacheCenter:getPlayerItemCountById(tBasicData.consume[1][1])
    local tTempData = GDatatab_item["id_" .. tBasicData.consume[1][1]]
    if tBasicData.consume[1][2] > nCostGoodNum then 
        MsgBoxManager:showTipBox(string.format(LocalStrings.CARD_COUNT1, tTempData.name))
        return 
    end
    WndWakeup:_createLoading()
    ProtocolProcessorWakeup:send_AWAKE_UpTalent(tData.id)
end

--@breif    点击觉醒之技中升级按钮回调
function CellWakeupDetail:onClickSkillUpgrade(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local nAwakeSkillId = WndWakeup:getAwakeSkillId()
    local tBasicData = self:getSubSkillData(nAwakeSkillId)
    if not JudgeMoneyIsEnough(tBasicData.upgrade[1][1], tBasicData.upgrade[1][2], nil, nil, GlobalGame.g_nCurrentUIChannelId) then
        return
    end

    --发送升级协议
    WndWakeup:_createLoading()
    ProtocolProcessorWndSkillProp:send_PLAYER_UpgradeSkill(nAwakeSkillId, tBasicData.upgrade[1][1])
end

--@brief    点击进化按钮回调
function CellWakeupDetail:onClickEvolve(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local nTag = element:getTag()
    local tEvolveData = GDatatab_awake_evolution["id_" .. nTag]
    if not JudgeMoneyIsEnough(tEvolveData.awake_cost[1][1], tEvolveData.awake_cost[1][2], nil, nil, GlobalGame.g_nCurrentUIChannelId) then
        return
    end

    --发送升级协议
    WndWakeup:_createLoading()
    ProtocolProcessorWakeup:send_AWAKE_AwakeEvolve()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新界面信息
function CellWakeupDetail:_update()
    -- body
    self:_switchChunk()
end

--@brief    设置静态文本
function CellWakeupDetail:_setStaticText()
    -- body
    
end

--@brief    设置动态的文本
function CellWakeupDetail:_setDynamicText(nSoulLevel, nCurSoulExp)
    -- body
    if self.m_root == nil then return end 
    if nSoulLevel and nCurSoulExp then
        self.m_nSoulLevel, self.m_nCurSoulExp = nSoulLevel, nCurSoulExp
    else
        self.m_nSoulLevel, self.m_nCurSoulExp = WndWakeup:getSoulLevelAndExp()
    end
    local tUpgradeData = GDatatab_awake_crystal["id_" .. self.m_nSoulLevel]
    self.m_nTotalExpForAni = tUpgradeData.need_exp 
    --消耗
    self:_createTrainCoinList()
    --等级
    local ftxtSoulLevel = GetElement(self.m_root, "ftxtSoulLevel_CellWakeupDetail", WZUIFreeTextBox)
    if ftxtSoulLevel then
        local sContentFormat = [[<T C="255,227,116" S="20" P="1" SC="79,60,48" SS="4" SE="1">Lv.%d</T>]]
        ftxtSoulLevel:setShowText(string.format(sContentFormat, self.m_nSoulLevel))
    end
    --天赋点
    self:_showInbornValue()
    --进度条
    self:_setDynamicPrg(self.m_nCurSoulExp, self.m_nSoulLevel)
end

--@brief    天赋点
function CellWakeupDetail:_showInbornValue()
    -- body
    if self.m_root == nil then return end 

    local tUpgradeData = GDatatab_awake_crystal["id_" .. self.m_nSoulLevel]
    local ftxtInbornValue = GetElement(self.m_root, "ftxtInbornValue_CellWakeupDetail", WZUIFreeTextBox)
    if ftxtInbornValue then
        local sTempAtt = string.format(LocalStrings.WAKEUP_TEXT10, tUpgradeData.talent_point)

        local sContentFormat = [[<T C="93,222,254" S="20" P="1" SC="79,60,48" SS="4" SE="1">%s:</T><T C="255,255,255" S="20" P="1">%d</T><T C="255,255,255" S="20" P="1">(%s)</T>]]
        self.m_nInbornValue = CacheCenter:getPlayerItemCountById(62)
        local contentString = string.format(sContentFormat, LocalStrings.WAKEUP_TEXT11, self.m_nInbornValue, sTempAtt)
        ftxtInbornValue:setShowText(contentString)
    end
end

--@brief    创建培养之晶列表
function CellWakeupDetail:_createTrainCoinList()
    -- body
    local tCostId = {503,502,501,500}

    for i = 1, 4 do 
        local conForCoin = GetElement(self.m_root, "conForCoin" .. i .. "_CellWakeupDetail", WZUIContainer)
        conForCoin:removeAllChildrenWithCleanup(true)
        if conForCoin then
            local element, objNew = CellWakeupCoinUse:createElement()
            if element and objNew then
                objNew:setData(tCostId[i])
				objNew.m_nTag = i
                --objNew:setCallBackFunc(self, self.onClickTrain)
                element:setTag(i)
                conForCoin:addChild(element)
            end
			if i==self.m_nSelM then
				self.m_tSelected = objNew
				objNew:setLight(true)
			end
        end
    end
end

--@brief    设置水瓶进度
function CellWakeupDetail:_setDynamicPrg(nTempExp, nLevel)
    -- body
    local tUpgradeData = GDatatab_awake_crystal["id_" .. nLevel]
    if not tUpgradeData then return end 

    self.m_nTotalExpForAni = tUpgradeData.need_exp
    --经验
    local ftxtSoulExp = GetElement(self.m_root, "ftxtSoulExp_CellWakeupDetail", WZUIFreeTextBox)
    if ftxtSoulExp then
        local sContentFormat = [[<T C="99,255,95" S="20" P="1" SC="79,60,48" SS="4" SE="1">Exp:</T><T C="255,255,255" S="20" P="1">%d/%d</T>]]
        local contentString = string.format(sContentFormat, nTempExp, tUpgradeData.need_exp)
        ftxtSoulExp:setShowText(contentString)
    end
    --进度条
    local prgSoulExp = GetElement(self.m_root, "prgSoulExp_CellWakeupDetail", WZUIProgress)
    if prgSoulExp then
        prgSoulExp:setPercentage(100 * nTempExp/tUpgradeData.need_exp)
    end
    --水纹的大小
    local spineCrimp = GetElement(self.m_root, "spineCrimp_CellWakeupDetail", WZUISpine)
    local spineBubble = GetElement(self.m_root, "spineBubble_CellWakeupDetail", WZUISpine)
    local nPercent = math.floor(100 * nTempExp/tUpgradeData.need_exp)
    local nPtY = nPercent / 100 
    if spineCrimp then
        spineCrimp:setRelativePosition(GlobalMethod:ccp(0.5,  nPtY))
    end
    if spineBubble then
        local nPercent = math.floor(100 * nTempExp/tUpgradeData.need_exp)
        if nPtY > 0.5 then
            nPtY = 0.5 
        end
        spineBubble:setRelativePosition(GlobalMethod:ccp(0.5, nPtY))
    end
end

--@brief    根据传进来的值显示相应模块的信息
function CellWakeupDetail:_switchChunk()
    -- body
    local conSoul = GetElement(self.m_root, "conSoul_CellWakeupDetail", WZUIContainer)
    local conBody = GetElement(self.m_root, "conBody_CellWakeupDetail", WZUIContainer)
    local conPower = GetElement(self.m_root, "conPower_CellWakeupDetail", WZUIContainer)
    local conSkill = GetElement(self.m_root, "conSkill_CellWakeupDetail", WZUIContainer)
    local conEvolve = GetElement(self.m_root, "conEvolve_CellWakeupDetail", WZUIContainer)

    conSoul:setVisible(false)
    conBody:setVisible(false)
    conPower:setVisible(false)
    conSkill:setVisible(false)
    conEvolve:setVisible(false)

    if self.m_nLeftSelIndex == 1 then
        conSoul:setVisible(true)
        self:_setDynamicText()
    elseif self.m_nLeftSelIndex == 2 then
        conBody:setVisible(true)
        self:_showBodyInfo()
    elseif self.m_nLeftSelIndex == 3 then
        conPower:setVisible(true)
        self:_showPowerInfo()
    elseif self.m_nLeftSelIndex == 4 then
        conSkill:setVisible(true)
        self:_showSkillInfo()
    elseif self.m_nLeftSelIndex == 5 then
        conEvolve:setVisible(true)
        self:_showEvolveInfo()
    end
end

--@brief    觉醒之体界面信息显示
function CellWakeupDetail:_showBodyInfo()
    -- body
    self.m_nBodyState = WndWakeup:getBodyState()

    local txtBodyBtn = GetElement(self.m_root, "txtBodyBtn_CellWakeupDetail", WZUILabelTTF)
    local txtBodyRecAtt = GetElement(self.m_root, "txtBodyRecAtt_CellWakeupDetail", WZUILabelTTF)
    if txtBodyBtn then
        if self.m_nBodyState == 0 then
            txtBodyRecAtt:setVisible(true)
            txtBodyRecAtt:setText(string.format(LocalStrings.WAKEUP_TEXT14, LocalStrings.WAKEUP_TEXT2[2]))
            txtBodyBtn:setText(LocalStrings.INVITE_RECEIVE)
        elseif self.m_nBodyState == 1 then
            txtBodyRecAtt:setVisible(false)
            txtBodyBtn:setText(LocalStrings.WAKEUP_TEXT13)
        end
    end

    local skinId = self:_getCorrectSkin()
    local tSkinData = GDatatab_shape_skins["id_" .. skinId]
    --时装的名字
    local txtBodyClotheName = GetElement(self.m_root, "txtBodyClotheName_CellWakeupDetail", WZUILabelTTF)
    if txtBodyClotheName then
        txtBodyClotheName:setText(tSkinData.name)
        txtBodyClotheName:setColor(QUALITYCOLOR[tSkinData.quality])
    end
    local txtBodyProValue = GetElement(self.m_root, "txtBodyProValue_CellWakeupDetail", WZUILabelTTF)
    if txtBodyProValue then
        txtBodyProValue:setText(LocalStrings.PHANTOM10 .. ":" .. tSkinData.shape_exp)
    end

    self:_createPlayerHuanhua()

    local imgSkillIcon = GetElement(self.m_root, "imgSkillIcon_CellWakeupDetail", WZUIImage)
    if imgSkillIcon then
        local filePath = GDatatab_skill["id_" .. tSkinData.passive_skill[1][1]].icon
        imgSkillIcon:setFile(filePath)
    end

    local btnBodyGoto = GetElement(self.m_root, "btnBodyGoto_CellWakeupDetail", WZUIButton)
    if btnBodyGoto then 
        local bVisible = self:CheckItemIsClick()
        btnBodyGoto:setVisible(not bVisible)
    end
end

--@brief    添加点击事件的id
function CellWakeupDetail:addCellItemId()
    WZLog("CellWakeupDetail:addCellItemId|nCellId=")
    local _KeyString = ""
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = "WAKEUP_BODY" .. tostring(CacheCenter:getPlayerInfo().id)
    local cellId_stringArray =  data:getStringValue("WAKEUP_BODY_MARK", _KeyString)
    if cellId_stringArray == nil or cellId_stringArray == "" then
        local idString = string.format("%d", 1)
        data:setStringValue("WAKEUP_BODY_MARK", _KeyString, idString)
        data:flush()
        --隐藏前往按钮
        GetElement(self.m_root, "btnBodyGoto_CellWakeupDetail", WZUIButton):setVisible(false)
    end
end

--@breif    判断是否点击过
function CellWakeupDetail:CheckItemIsClick()
    local cellId_stringArray = ""
    local data = WZDataFile:getInstance():getUserData()
    cellId_stringArray = data:getStringValue("WAKEUP_BODY_MARK", "WAKEUP_BODY" .. tostring(CacheCenter:getPlayerInfo().id))
    local bRet = false
    WZLog("CellWakeupDetail:CheckItemIsClick ", cellId_stringArray)
    if cellId_stringArray == nil or cellId_stringArray == "" then
        return bRet
    end
    bRet = true

    return bRet
end


function CellWakeupDetail:_createAtlasFont(nAddNum, nMultiple)
    -- body
    WZLog("CellWakeupDetail:_createAtlasFont")
    --音效
    SoundManager:playEffectSound(SoundDefine.E_S_STRENGTHEN_SUCCESS2) 
    --加号
    local imgAddSign = WZUIImage:create()
    imgAddSign:setFile("ui/common/common_num_yaoqianshujiahao.png")
    imgAddSign:setUseOriginSize(true)
    imgAddSign:setAnchorPoint(ccp(1, 0.5))
    imgAddSign:setRelativePosition(ccp(0.59, 0.5))

    --增加的类型图标
    local txtExp = WZUILabelTTF:create()
    txtExp:setFontSize(26)
    txtExp:setAnchorPoint(ccp(0, 0.5))
    txtExp:setRelativePosition(ccp(0.595, 0.5))
    txtExp:setText(LocalStrings.WAKEUP_TEXT19)
    txtExp:setColor(GlobalMethod:ccc3(255,236,193))
    txtExp:setStrokeColor(GlobalMethod:ccc3(127,70,26))
    txtExp:setEnableStroke(true)
    txtExp:setStrokeSize(4)

    --获得的结果数量
    local txtAtlasFont = WZUILabelAtlasFont:create()
    txtAtlasFont:setCharMapFileName("ui/common_num/common_num_yaoqianshuzi.png")
    txtAtlasFont:setStartChar(48)
    txtAtlasFont:setHeight(34)
    txtAtlasFont:setWidth(26)
    txtAtlasFont:setUseOriginSize(true)
    txtAtlasFont:setAnchorPoint(ccp(0, 0.5))
    txtAtlasFont:setRelativePosition(ccp(0.73, 0.5))

    txtAtlasFont:setText(nAddNum)

    local imgBaoJi = nil 
    local imgMulSign = nil 
    local txtAtlasBaoJiNum = nil

    if nMultiple > 1 then
        --暴击
        imgBaoJi = WZUIImage:create()
        imgBaoJi:setFile("ui/combat/common_icon_baoji.png")
        imgBaoJi:setUseOriginSize(true)
        imgBaoJi:setScaleY(0.46)
        imgBaoJi:setScaleX(0.46)
        imgBaoJi:setAnchorPoint(ccp(0, 0.5))
        imgBaoJi:setRelativePosition(ccp(0.17, 0.5))
        --乘号
        imgMulSign = WZUIImage:create()
        imgMulSign:setFile("ui/common/common_num_yaoqianshuchenhao.png")
        imgMulSign:setUseOriginSize(true)
        imgMulSign:setAnchorPoint(ccp(1, 0.5))
        imgMulSign:setRelativePosition(ccp(0.4, 0.5))
        --暴击倍数
        txtAtlasBaoJiNum = WZUILabelAtlasFont:create()
        txtAtlasBaoJiNum:setCharMapFileName("ui/common_num/common_num_yaoqianshuzi.png")
        txtAtlasBaoJiNum:setStartChar(48)
        txtAtlasBaoJiNum:setHeight(34)
        txtAtlasBaoJiNum:setWidth(26)
        txtAtlasBaoJiNum:setUseOriginSize(true)
        txtAtlasBaoJiNum:setAnchorPoint(ccp(0, 0.5))
        txtAtlasBaoJiNum:setRelativePosition(ccp(0.4, 0.5))

        txtAtlasBaoJiNum:setText(nMultiple)
    else  --没有暴击时候，居中
        imgAddSign:setAnchorPoint(ccp(0.5, 0.5))
        imgAddSign:setRelativePosition(ccp(0.27, 0.5))

        txtExp:setAnchorPoint(ccp(1, 0.5))
        txtExp:setRelativePosition(ccp(0.45, 0.5))

        txtAtlasFont:setAnchorPoint(ccp(0, 0.5))
        txtAtlasFont:setRelativePosition(ccp(0.5, 0.5))
    end

     local conResult = WZUIContainer:create()
    local conRoot = GetElement(self.m_root, "conSoulLeft_CellWakeupDetail", WZUIContainer)

     if conResult then
        conResult:addChild(imgAddSign)
        conResult:addChild(txtExp)
        conResult:addChild(txtAtlasFont)
        if nMultiple > 1 then
            conResult:addChild(imgBaoJi)
            conResult:addChild(imgMulSign)
            conResult:addChild(txtAtlasBaoJiNum)
        end
        conRoot:addChild(conResult, 10, 10)
     end
    --购买成功后的界面特效
    local actionScaleTo1 = WZUIActionScaleTo:create()
    actionScaleTo1:setDuration(0.2)
    actionScaleTo1:setScaleY(1.1)
    actionScaleTo1:setScaleX(1.1)
    local actionScaleTo2 = WZUIActionScaleTo:create()
    actionScaleTo2:setDuration(0.2)
    actionScaleTo2:setScaleY(0.7)
    actionScaleTo2:setScaleX(0.7)
    local actionScaleTo3 = WZUIActionScaleTo:create()
    actionScaleTo3:setDuration(0.2)
    actionScaleTo3:setScaleY(0.85)
    actionScaleTo3:setScaleX(0.85)
     local actionScaleTo4 = WZUIActionScaleTo:create()
    actionScaleTo4:setDuration(0.5)
    actionScaleTo4:setScaleY(0.85)
    actionScaleTo4:setScaleX(0.85)
    local actionSqu = WZUIActionSequence:create()
    actionSqu:setIsLoop(false)
    actionSqu:setChildAction(actionScaleTo1)
    actionSqu:setChildAction(actionScaleTo2)
    actionSqu:setChildAction(actionScaleTo3)
    actionSqu:setChildAction(actionScaleTo4)

    local action = WZUIActionSpawn:create()

    local actMoveTo = WZUIActionMoveTo:create()
    actMoveTo:setDuration(0.6)
    actMoveTo:setMoveX(0.5)
    actMoveTo:setMoveY(0.65)

    local actFadeTo = WZUIActionContainerFadeFromTo:create()
    actFadeTo:setDuration(0.6)
    actFadeTo:setOpacityFrom(255)
    actFadeTo:setOpacityTo(0)

    action:setChildAction(actFadeTo)
    action:setChildAction(actMoveTo)

    actionSqu:setChildAction(action)
    actionSqu:setFinishLuaFunction("onActionFinishBack")

    conResult:runUIAction(actionSqu)
end

function CellWakeupDetail:onActionFinishBack(element, b)
    -- body
    WZLog("***********************CellWakeupDetail:onActionFinishBack****************************")
    local conSoul = GetElement(self.m_root, "conSoul_CellWakeupDetail", WZUIContainer)
    if conSoul then
        conSoul:disableSchedule()
    end

--    self:_update()

    --移除操作限制
    -- if self.m_root:getChildByTag(888) then
    --     self.m_root:removeChildByTag(888, true)
    -- end

    element:removeFromParentAndCleanup(true)
    element = nil
end

function CellWakeupDetail:use1() 
	WZLog("CellWakeupDetail:use1")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.use5Time = false
	CellWakeupDetail:onClickTrain(self.m_nSelM, 1)
end

function CellWakeupDetail:use5() 
	WZLog("CellWakeupDetail:use5")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--判断vip等级
    --if CacheCenter:getPlayerInfo().vipLevel < 4 then
    --	local sMsg = string.format(LocalStrings.MULTI_SWEEP_TIP, 4)
    --    MsgBoxManager:showConfirmCancelBox(sMsg, self, self.needMoreDiamondCallBack, MSGBOXLEVEL_HIGH,nil)
	--	return
	--end
	self.use5Time = true
	CellWakeupDetail:onClickTrain(self.m_nSelM, 5)
	--self:updateUpLog()
end

--@brief	提示框的回调
function CellWakeupDetail:needMoreDiamondCallBack(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
		PassportSdkManager:gotoPaymentPage()
    end
end

-- 更新升级日志
function CellWakeupDetail:updateUpLog(info)
	if self.use5Time ~= true then return end

    local conLog = GetElement(self.m_root,"conLog_CellWakeupDetail",WZUIContainer)
    conLog:setVisible(true)
    conLog:setScale(0)

    local disTime = 0.3
    -- 设置日志
    local upCnt = #self.baseExp
	local totalExp = 0
    for i = 1, 5 do
        local ftb = GetElement(self.m_root,"tfbLog"..i.."_CellWakeupDetail",WZUIFreeTextBox)
        if i <= upCnt then
            local startLv = self.preLevel[i]
            local endLv = self.level[i]
            WZLog("----------curInfo-----------",i,startLv,endLv)
            if tonumber(self.multiple[i]) == 1 then
                ftb:setShowText(string.format(LocalStrings.WAKEUP3,i,startLv,endLv,self.baseExp[i]))
            else
                ftb:setShowText(string.format(LocalStrings.WAKEUP4,i,startLv,endLv,self.multiple[i],self.baseExp[i]*self.multiple[i]))
            end
			totalExp = totalExp + self.baseExp[i]*self.multiple[i]

            ftb:setScale(0)
            ftb:setVisible(true)
            local act1 = CCDelayTime:create(0.1+disTime*i)
            local act2 = CCScaleTo:create(0,1)
            local act = CCSequence:createWithTwoActions(act1,act2)
            ftb:runAction(act)
        else
            ftb:setVisible(false)
        end
    end

    -- 总消耗
    local ftb = GetElement(self.m_root,"tfbLog6_CellWakeupDetail",WZUIFreeTextBox)
    ftb:setShowText(string.format(LocalStrings.WAKEUP5,upCnt,(self.level[upCnt] - self.preLevel[1]),totalExp))
    ftb:setScale(0)
    local act1 = CCDelayTime:create(0.1+disTime*(upCnt+1))
    local act2 = CCScaleTo:create(0,1)
    local act = CCSequence:createWithTwoActions(act1,act2)
    ftb:runAction(act)

    local act1 = CCScaleTo:create(0.1,1)
    conLog:runAction(act1)

    self.logTime = disTime*(upCnt+1)+0.1
    conLog:enableSchedule("updateLogTime",self.logTime)
end

function CellWakeupDetail:updateLogTime()
    local conLog = GetElement(self.m_root,"conLog_CellWakeupDetail",WZUIContainer)
    conLog:disableSchedule()
    self.logTime = 0
end

function CellWakeupDetail:closeLog() 
	GetElement(self.m_root,"conLog_CellWakeupDetail",WZUIContainer):setVisible(false)
end

--@brief    显示觉醒之力信息
function CellWakeupDetail:_showPowerInfo()
    -- body
    --创建属性和财富类天赋列表
    self:_createPowerList()
end

--@brief    创建技能列表
function CellWakeupDetail:_createPowerList()
    -- body
    local tableProperty = GetElement(self.m_root, "tableProperty_CellWakeupDetail", WZUITableContainer)
    local tableWealth = GetElement(self.m_root, "tableWealth_CellWakeupDetail", WZUITableContainer)
    local tPowerList = WndWakeup:getPowerData()

    local nProIndex = 1
    local nWealthIndex = 1
    for i = 1, #tPowerList do
        local element, tNewObj = CellWakeupPowerItem:createElement()
        if element and tNewObj then 
            tNewObj:setData(tPowerList[i])
            tNewObj:setCallBackFunc(self, self.onClickPowerSkill)
            if tPowerList[i].type < 11 then --属性类
                element:setTag(nProIndex - 1)
                tableProperty:setCellElement(element)

                nProIndex = nProIndex + 1
            else    --财富类
                element:setTag(nWealthIndex - 1)
                tableWealth:setCellElement(element)

                nWealthIndex = nWealthIndex + 1
            end
        end
    end
end

--@brief    展示觉醒之技界面信息
function CellWakeupDetail:_showSkillInfo()
    -- body
    local nAwakeSkillId = WndWakeup:getAwakeSkillId()
    local sCostFormat = [[<T C="255,227,116" S="18" P="1" SC="79,60,48" SE="0" SS="4">%s</T>]]
    local sCostFormat2 = [[<I Z = "0.45">%s</I><T C="255,227,116" S="18" P="1" SC="79,60,48" SE="0" SS="4">%d</T>]]
    local sCostFormat3 = [[<T C="99,255,95" S="18" P="1" SC="79,60,48" SE="0" SS="4">%.1f</T>]]
    local nTotalLevel = 1 
    local nCtbValue = 0
    local tBasicData = self:getSubSkillData(nAwakeSkillId)

    if tBasicData then 
        local txtSkillValue11 = GetElement(self.m_root, "txtSkillTopValue1_1_CellWakeupDetail", WZUIFreeTextBox)
        local txtSkillValue12 = GetElement(self.m_root, "txtSkillTopValue1_2_CellWakeupDetail", WZUIFreeTextBox)
        local txtSkillValue13 = GetElement(self.m_root, "txtSkillTopValue1_3_CellWakeupDetail", WZUIFreeTextBox)
        local ftxtCost = GetElement(self.m_root, "ftxtCost_CellWakeupDetail", WZUIFreeTextBox)
        local btnSkillUpgrade = GetElement(self.m_root, "btnSkillUpgrade_CellWakeupDetail", WZUIButton)

        local tEffectData = GDatatab_effect["id_" .. tBasicData.effect_id[1][1]]
        local sFormatValue = LocalStrings.WAKEUP_TEXT42[1] .. ":"
        txtSkillValue11:setShowText(string.format(sCostFormat .. sCostFormat3, sFormatValue, tBasicData.start_time/1000))
        sFormatValue = LocalStrings.WAKEUP_TEXT42[2] .. ":"
        txtSkillValue12:setShowText(string.format(sCostFormat .. sCostFormat3, sFormatValue, tBasicData.cooling_time/1000))
        sFormatValue = LocalStrings.WAKEUP_TEXT42[3] .. ":"
        txtSkillValue13:setShowText(string.format(sCostFormat .. sCostFormat3, sFormatValue, tEffectData.effect[1][5]/1000))
        local conCurLevel = GetElement(self.m_root, "conCurLevel_CellWakeupDetail", WZUIContainer)
        local conNextLevel = GetElement(self.m_root, "conNextLevel_CellWakeupDetail", WZUIContainer)
        local imgSkillArrow = GetElement(self.m_root, "imgSkillArrow_CellWakeupDetail", WZUIImage)
        if tBasicData.upgrade == -1 then
            conNextLevel:setVisible(false)
            btnSkillUpgrade:setVisible(false)
            imgSkillArrow:setVisible(false)
            conCurLevel:setRelativePosition(GlobalMethod:ccp(0.5, 0.5))

            ftxtCost:setShowText(string.format(sCostFormat, LocalStrings.COMMUNITYINFO42))
            ftxtCost:setRelativePosition(GlobalMethod:ccp(0.5,0.2))
        else
            local tNextData = self:getSubSkillData(nAwakeSkillId, true)
            local txtSkillValue21 = GetElement(self.m_root, "txtSkillTopValue2_1_CellWakeupDetail", WZUIFreeTextBox)
            local txtSkillValue22 = GetElement(self.m_root, "txtSkillTopValue2_2_CellWakeupDetail", WZUIFreeTextBox)
            local txtSkillValue23 = GetElement(self.m_root, "txtSkillTopValue2_3_CellWakeupDetail", WZUIFreeTextBox)

            local tEffectData = GDatatab_effect["id_" .. tNextData.effect_id[1][1]]
            local sFormatValue = LocalStrings.WAKEUP_TEXT42[1] .. ":"
            txtSkillValue21:setShowText(string.format(sCostFormat .. sCostFormat3, sFormatValue, tNextData.start_time/1000))
            sFormatValue = LocalStrings.WAKEUP_TEXT42[2] .. ":"
            txtSkillValue22:setShowText(string.format(sCostFormat .. sCostFormat3, sFormatValue, tNextData.cooling_time/1000))
            sFormatValue = LocalStrings.WAKEUP_TEXT42[3] .. ":"
            txtSkillValue23:setShowText(string.format(sCostFormat .. sCostFormat3, sFormatValue, tEffectData.effect[1][5]/1000))

            btnSkillUpgrade:setVisible(true)
            
            ftxtCost:setShowText(string.format(sCostFormat .. sCostFormat2, LocalStrings.COST, GDatatab_item["id_" .. tBasicData.upgrade[1][1]].icon, tBasicData.upgrade[1][2]))
        end
    end

    local tEffectData = GDatatab_effect["id_" .. tBasicData.effect_id[1][1]]

    local txtSkillLevel = GetElement(self.m_root, "txtSkillLevel_CellWakeupDetail", WZUILabelTTF)
    txtSkillLevel:setText(LocalStrings.WAKEUP_TEXT39 .. "Lv." .. tBasicData.specialAttackParam)
    local txtSkillTips = GetElement(self.m_root, "txtSkillTips_CellWakeupDetail", WZUILabelTTF)
    txtSkillTips:setText(string.format(LocalStrings.WAKEUP_TEXT40, tEffectData.effect[1][5]/1000))
end

--@brief    显示进化详细信息
function CellWakeupDetail:_showEvolveInfo()
    -- body
    local tableEvolveList = GetElement(self.m_root, "tableEvolveList_CellWakeupDetail", WZUITableContainer)
    tableEvolveList:cleanTable()

    local nEvolveLevel = WndWakeup:getEvolveLevel()
    if nEvolveLevel == nil then return end 

    local tEvolveList = CopyTable(GDatatab_awake_evolution)
    table.sort(tEvolveList, function (a, b)
        -- body
        return a.id < b.id
    end)
    for i, value in pairs(tEvolveList) do
        local element = WZUISystem:getInstance():createElement("CellEvolveItem_CellWakeupDetail")
        if element then 
            element:setTag(value.id - 1)
            element:setVisible(true)
            GetElement(element, "txtEvolveName_CellEvolveItem", WZUILabelTTF):setText(value.name)
            GetElement(element, "txtEvolveDesc_CellEvolveItem", WZUILabelTTF):setText(value.awake_introduce)
            GetElement(element, "imgCostIcon_CellEvolveItem", WZUIImage):setFile(GDatatab_item["id_" .. value.awake_cost[1][1]].icon)
            GetElement(element, "txtCostValue_CellEvolveItem", WZUILabelTTF):setText(value.awake_cost[1][2])
            local txtEvolveState = GetElement(element, "txtEvolveState_CellEvolveItem", WZUILabelTTF)
            local btnEvolve = GetElement(element, "btnEvolve_CellEvolveItem", WZUIButton)
            btnEvolve:setTag(value.id)

            local sIconGray = "evolve_icon_gray" .. value.id .. ".png"
            if nEvolveLevel >= value.id then 
                txtEvolveState:setText(LocalStrings.WAKEUP_TEXT50)
                txtEvolveState:setVisible(true)
                btnEvolve:setVisible(false)

                GetElement(element, "imgEvolveIcon_CellEvolveItem", WZUIImage):setFile("ui/extraction/" .. value.icon)
            else
                if value.pre_id > 0 then 
                    txtEvolveState:setText(LocalStrings.WAKEUP_TEXT51[value.pre_id])
                end
                txtEvolveState:setVisible(true)
                btnEvolve:setVisible(false)

                if nEvolveLevel + 1 == value.id then 
                    btnEvolve:setVisible(true)
                    txtEvolveState:setVisible(false)
                end
                GetElement(element, "imgEvolveIcon_CellEvolveItem", WZUIImage):setFile("ui/extraction/" .. sIconGray)
            end
            self:_createEvolveProperty(element, value)

            tableEvolveList:setCellElement(element)
        end
    end
end

--@brief    创建进化属性
function CellWakeupDetail:_createEvolveProperty(element, tEvolveData)
    -- body
    local conForProperty = GetElement(element, "conProperty_CellEvolveItem", WZUIContainer)
    conForProperty:removeAllChildrenWithCleanup(true)
    local sPropertyFormat = [[<T C="255,227,116" S="18" P="1">%s: </T><T C="99,255,95" S="18" P="1">+%d</T>]]
    local tPropertyList = tEvolveData.property
    table.insert(tPropertyList, tEvolveData.reward[1])
    if #tPropertyList == 0 then return end 
    local nTempDisY = (1 - 0.1 * 2)/(#tPropertyList)
    for i = 1, #tPropertyList do
        local ftxtProperty = WZUIFreeTextBox:create()
        ftxtProperty:setMaxWidth(240)
        ftxtProperty:setRelativePosition(GlobalMethod:ccp(0.18, 0.86 - (i - 1)* nTempDisY))
        ftxtProperty:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
        if tPropertyList[i][1] == 63 or tPropertyList[i][1] == 62 then 
            local txtContent = string.format(sPropertyFormat, GDatatab_item["id_" .. tPropertyList[i][1]].name, tPropertyList[i][2])
            ftxtProperty:setShowText(txtContent)
        else
            local txtContent = string.format(sPropertyFormat, ATTR_TITLE[tPropertyList[i][1]], tPropertyList[i][2])
            ftxtProperty:setShowText(txtContent)
        end
        conForProperty:addChild(ftxtProperty)
    end
    --战斗力提升
    local nFighting = self:_caculateFighting(tPropertyList)
    local ftxtProperty = WZUIFreeTextBox:create()
    ftxtProperty:setMaxWidth(240)
    ftxtProperty:setRelativePosition(GlobalMethod:ccp(0.5, 0.86 - (#tPropertyList) * nTempDisY))
    ftxtProperty:setAnchorPoint(GlobalMethod:ccp(0.5, 0.5))

    local txtContent = string.format(sPropertyFormat, LocalStrings.WAKEUP_TEXT53, nFighting)
    ftxtProperty:setShowText(txtContent)

    conForProperty:addChild(ftxtProperty)
end

--@brief    根据属性表，计算战力
--@param    tProperty:属性表
function CellWakeupDetail:_caculateFighting(tProperty)
    -- body
    if tProperty == nil or #tProperty == 0 then return 0 end

    local extraInfo = {}
    extraInfo["12"] = 0 
    extraInfo["13"] = 0
    extraInfo["10"] = 0
    extraInfo["11"] = 0
    extraInfo["9"] = 0 
    extraInfo["1"] = 0
    extraInfo["3"] = 0
    extraInfo["4"] = 0
    extraInfo["5"] = 0
    extraInfo["7"] = 0
    extraInfo["19"] = 0
    extraInfo["20"] = 0
    extraInfo["18"] = 0

    for i = 1, #tProperty do
        if tProperty[i][1] <= 20 then 
            local sIndex = tostring(tProperty[i][1])
            extraInfo[sIndex] = tProperty[i][2]
        end
    end

    local nFighting = caculateClothesFighting(extraInfo)

    return nFighting
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function CellWakeupDetail:_adaptLanguage_th(  )
    GetElement(self.m_root,"txtNewMount_CellWakeupDetail",WZUILabelTTF):setScale(0.5)
    local ftxtInbornValue = GetElement(self.m_root,"ftxtInbornValue_CellWakeupDetail",WZUIFreeTextBox)
    ftxtInbornValue:setMaxWidth(310)
    ftxtInbornValue:setRelativePosition(GlobalMethod:ccp(0.285,0.065))
end

function CellWakeupDetail:_adaptLanguage_en(  )
    GetElement(self.m_root,"txtNewMount_CellWakeupDetail",WZUILabelTTF):setScale(0.9)
    local ftxtInbornValue = GetElement(self.m_root,"ftxtInbornValue_CellWakeupDetail",WZUIFreeTextBox)
    ftxtInbornValue:setMaxWidth(310)
    ftxtInbornValue:setRelativePosition(GlobalMethod:ccp(0.285,0.065))

    local txtWakeup2 = GetElement(self.m_root,"txtWakeup2_CellWakeupDetail",WZUILabelTTF)
    txtWakeup2:setScale(0.8)
    txtWakeup2:setDimensions(GlobalMethod:CCSize(110))

    local txtWakeupLog = GetElement(self.m_root,"txtWakeupLog_CellWakeupDetail",WZUILabelTTF)
    txtWakeupLog:setRelativePosition(GlobalMethod:ccp(0.170034,0.878504))

    -- for i = 1, 5 do
    --     local tfbLog = GetElement(self.m_root,"tfbLog"..i.."_CellWakeupDetail",WZUILabelTTF)
    --     tfbLog:setMaxWidth(800)
    -- end

    local txtBodyBtn = GetElement(self.m_root, "txtBodyBtn_CellWakeupDetail", WZUILabelTTF)
    txtBodyBtn:setScale(0.8)

    local conCurLevel = GetElement(self.m_root, "conCurLevel_CellWakeupDetail", WZUIContainer)
    conCurLevel:setRelativePosition(GlobalMethod:ccp(0.23,0.5))
end

function CellWakeupDetail:_adaptLanguage_vn(  )
    local txtNewMount = GetElement(self.m_root,"txtNewMount_CellWakeupDetail",WZUILabelTTF)
    txtNewMount:setDimensions(GlobalMethod:CCSize(60,0))
    txtNewMount:setScale(0.8)
    local ftxtInbornValue = GetElement(self.m_root,"ftxtInbornValue_CellWakeupDetail",WZUIFreeTextBox)
    ftxtInbornValue:setMaxWidth(310)
    ftxtInbornValue:setRelativePosition(GlobalMethod:ccp(0.285,0.065))
end

function CellWakeupDetail:_adaptLanguage_pt(  )
    local txtNewMount = GetElement(self.m_root,"txtNewMount_CellWakeupDetail",WZUILabelTTF)
    txtNewMount:setDimensions(GlobalMethod:CCSize(60,0))
    txtNewMount:setScale(0.6)
    local ftxtInbornValue = GetElement(self.m_root,"ftxtInbornValue_CellWakeupDetail",WZUIFreeTextBox)
    ftxtInbornValue:setScale(0.7)
    ftxtInbornValue:setRelativePosition(GlobalMethod:ccp(0.285,0.065))

    local txtWakeupLog = GetElement(self.m_root,"txtWakeupLog_CellWakeupDetail",WZUILabelTTF)
    txtWakeupLog:setRelativePosition(GlobalMethod:ccp(0.170034,0.878504))

    local txtWakeup2 = GetElement(self.m_root,"txtWakeup2_CellWakeupDetail",WZUILabelTTF)
    txtWakeup2:setScale(0.8)
    txtWakeup2:setDimensions(GlobalMethod:CCSize(110))

    local txtBodyBtn = GetElement(self.m_root, "txtBodyBtn_CellWakeupDetail", WZUILabelTTF)
    txtBodyBtn:setScale(0.7)

    local conCurLevel = GetElement(self.m_root, "conCurLevel_CellWakeupDetail", WZUIContainer)
    conCurLevel:setRelativePosition(GlobalMethod:ccp(0.23,0.5))
end

function CellWakeupDetail:_adaptLanguage_es(  )
    local txtNewMount = GetElement(self.m_root,"txtNewMount_CellWakeupDetail",WZUILabelTTF)
    txtNewMount:setDimensions(GlobalMethod:CCSize(60,0))
    txtNewMount:setScale(0.6)
    local ftxtInbornValue = GetElement(self.m_root,"ftxtInbornValue_CellWakeupDetail",WZUIFreeTextBox)
    ftxtInbornValue:setScale(0.7)
    ftxtInbornValue:setRelativePosition(GlobalMethod:ccp(0.285,0.065))

    local txtBodyBtn = GetElement(self.m_root, "txtBodyBtn_CellWakeupDetail", WZUILabelTTF)
    txtBodyBtn:setScale(0.7)

    local txtWakeup2 = GetElement(self.m_root,"txtWakeup2_CellWakeupDetail",WZUILabelTTF)
    txtWakeup2:setScale(0.8)
    txtWakeup2:setDimensions(GlobalMethod:CCSize(110))

    local txtWakeupLog = GetElement(self.m_root,"txtWakeupLog_CellWakeupDetail",WZUILabelTTF)
    txtWakeupLog:setRelativePosition(GlobalMethod:ccp(0.170034,0.878504))

    local conCurLevel = GetElement(self.m_root, "conCurLevel_CellWakeupDetail", WZUIContainer)
    conCurLevel:setRelativePosition(GlobalMethod:ccp(0.23,0.5))

    local txtSkillBtn2 = GetElement(self.m_root, "txtSkillBtn2_CellWakeupDetail", WZUILabelTTF)
    txtSkillBtn2:setScale(0.7)
end

function CellWakeupDetail:_adaptLanguage_tr(  )
    local txtNewMount = GetElement(self.m_root,"txtNewMount_CellWakeupDetail",WZUILabelTTF)
    txtNewMount:setDimensions(GlobalMethod:CCSize(60,0))
    txtNewMount:setScale(0.6)
    local ftxtInbornValue = GetElement(self.m_root,"ftxtInbornValue_CellWakeupDetail",WZUIFreeTextBox)
    ftxtInbornValue:setScale(0.7)
    ftxtInbornValue:setRelativePosition(GlobalMethod:ccp(0.285,0.065))

    local txtWakeupLog = GetElement(self.m_root,"txtWakeupLog_CellWakeupDetail",WZUILabelTTF)
    txtWakeupLog:setRelativePosition(GlobalMethod:ccp(0.170034,0.878504))

    local txtWakeup2 = GetElement(self.m_root,"txtWakeup2_CellWakeupDetail",WZUILabelTTF)
    txtWakeup2:setScale(0.8)
    txtWakeup2:setDimensions(GlobalMethod:CCSize(110))

    local txtBodyBtn = GetElement(self.m_root, "txtBodyBtn_CellWakeupDetail", WZUILabelTTF)
    txtBodyBtn:setScale(0.7)
    
    local conCurLevel = GetElement(self.m_root, "conCurLevel_CellWakeupDetail", WZUIContainer)
    conCurLevel:setRelativePosition(GlobalMethod:ccp(0.23,0.5))
end
--------------------------------语言适配End----------------------------------------------------