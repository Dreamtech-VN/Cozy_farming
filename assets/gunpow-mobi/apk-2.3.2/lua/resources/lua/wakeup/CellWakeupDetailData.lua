--CellWakeupDetailData.lua
--@brief	CellWakeupDetail的数据模块
--@date		2017/05/20
--@author	Tianxiang_Xu
--@note		觉醒模块-魂，体，力，技

CellWakeupDetail = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellWakeupDetail:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_nSoulLevel = 0 
    self.m_nInbornValue = 0
    self.m_nCurSoulExp = 0 
    self.m_nLeftSelIndex = 1
    self.m_nBodyState = 0              --觉醒之体状态：0未激活；1可领取；2已领取
    self.m_tTargetPoint = {{229,334}}
    self.m_tStartPoint = {{507,425}, {507,325}, {507,215}, {507,120}}
    self.m_tSecondPoint = {{{429,450},{429,310}}, {{429,355},{429,235}}, {{429,300},{429,140}}, {{429,250},{429,7}}}
    self.m_tThirdPoint = {{{329,480},{329,280}}, {{329,385},{329,205}}, {{329,350},{300,110}}, {{329,300},{229,50}}}
    self.m_nUseCoinIndex = nil 
    self.m_tRoleAni = nil 
    self.m_nTempBaseExp = nil 
    self.m_nDoubleTimes = nil 
    self.m_nTotalExpForAni = nil 
    self.m_nTempExp = 0 
    self.m_nTotalAddExp = 0     --本次培养总增加的经验
    self.m_nEachAddExpForPgr = 1      --本次培养进度条的步长
    self.m_nTempLevel = 0 
	
	self.m_tSelected = nil
	self.m_nSelM = nil
	self.m_nAniNum = nil
	self.m_nCurAniNum = nil
	self.baseExp = nil
	self.multiple = nil
	self.preLevel = nil
	self.level = nil
	self.m_nIndex = nil
    self.m_tCellClick = nil 
end


--@brief    反初始化表的成员变量
--@note     在退出场景时回调的onExit函数里面必须调用本函数
function CellWakeupDetail:_unInit()
    self.m_root = nil
    self.m_nSoulLevel = nil 
    self.m_nInbornValue = nil 
    self.m_nCurSoulExp = nil 
    self.m_nLeftSelIndex = nil 
    self.m_nBodyState = nil 
    self.m_tTargetPoint = nil 
    self.m_tStartPoint = nil 
    self.m_nUseCoinIndex = nil 
    self.m_tRoleAni = nil 
    self.m_nTempBaseExp = nil 
    self.m_nDoubleTimes = nil 
    self.m_nTotalExpForAni = nil 
    self.m_nTempExp = nil 
    self.m_nTotalAddExp = nil 
    self.m_nEachAddExpForPgr = nil 
    self.m_nTempLevel = nil 

	self.m_tSelected = nil
	self.m_nSelM = nil
	self.m_nAniNum = nil
	self.m_nCurAniNum = nil
	self.baseExp = nil
	self.multiple = nil
	self.preLevel = nil
	self.level = nil
	self.m_nIndex = nil
    self.m_tCellClick = nil  
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellWakeupDetail:createElement()
	local element = WZUISystem:getInstance():createElement("CellWakeupDetail")
	assert(element, "CellWakeupDetail create element failed!")
	self:_init()
	return element
end

--@brief    外部接口
--@param    parentNode:父节点
--@param    nTag : 顶部标签
function CellWakeupDetail:showInterface(parentNode, nTag)
    -- body
    if not self.m_root then
        local wakeupDetail = CellWakeupDetail:createElement()
        if wakeupDetail then
            self.m_nLeftSelIndex = nTag
            parentNode:addChild(wakeupDetail)
        end
    else
        self.m_nLeftSelIndex = nTag    
        self:_update()  
    end
end

--@brief    培养成功
function CellWakeupDetail:trainOK(currentLevel, currentExp, baseExp, multiple, preLevel, level)
    -- body
	self.m_nIndex = 1
    self.m_nTempBaseExp = baseExp[self.m_nIndex] 
    self.m_nDoubleTimes = multiple[self.m_nIndex] 

	self.m_nAniNum = #baseExp
	self.m_nCurAniNum = 1

	self.baseExp = baseExp
	self.multiple = multiple
	self.preLevel = preLevel
	self.level = level

    self:_displayTrainParticle(self.m_nUseCoinIndex)
	if self.m_nAniNum > 1 then
		self.m_root:enableSchedule("_displayTrainParticle0", 0.1)
	end
end

function CellWakeupDetail:_displayTrainParticle0(dt) 
	CellWakeupDetail.m_nCurAniNum = CellWakeupDetail.m_nCurAniNum + 1
	if self.m_nCurAniNum > self.m_nAniNum then 
		self.m_root:disableSchedule() 
		return
	end
    self:_displayTrainParticle(self.m_nUseCoinIndex)
end

--@brief    检测觉醒之晶数量更新
function CellWakeupDetail:updatePlayerItemData()
    if self.m_root == nil then return end
    WZLog("CellWakeupDetail:updatePlayerItemData", CacheCenter:getPlayerItemCountById(62))
    self:_createTrainCoinList()
    self:_showInbornValue()
end

--@brief    激活或升级天赋技能成功
function CellWakeupDetail:upgradeInbornOK(talentId)
    -- body
    WZLog("CellWakeupDetail:upgradeInbornOK", talentId)
    if self.m_root == nil then return end
    local tBasicData = GDatatab_talent_Skill["id_" .. talentId]
    if tBasicData.type <= 15 then
        if self.m_tCellClick then 
            WZLog("CellWakeupDetail:upgradeInbornOK11111", tBasicData.level)
            if tBasicData.level == 1 then 
                MsgBoxManager:showTipBox(LocalStrings.NEWSKILL15)
            else
                MsgBoxManager:showTipBox(LocalStrings.NEWSKILL14)
            end
            local tItem = {}
            tItem.id = talentId
            tItem.type = GDatatab_talent_Skill["id_" .. talentId].type
            self.m_tCellClick:resetData(tItem)
        end
    end
end

--@brief    觉醒之技自己能升级成功
function CellWakeupDetail:upgradeSubSkillOK(talentId)
    -- body
    if self.m_root == nil then return end 
    --提示升级成功
    PopupResult("ui/common/common_icon_sjz.png")
    WZLog("CellWakeupDetail:upgradeSubSkillOK", talentId)
    WndWakeup:setSkillData(talentId)
    self:_showSkillInfo()
end

--@brief    如果连续点击升级，上一次的直接跳过动画
function CellWakeupDetail:resetImmediately(nSoulLevel, nCurSoulExp)
    -- body
    if self.m_root == nil then return end 

    local conSoulLeft = GetElement(self.m_root, "conSoulLeft_CellWakeupDetail", WZUIContainer)
    conSoulLeft:disableSchedule()

    self:_setDynamicText(nSoulLevel, nCurSoulExp)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
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
        local sIndex = tostring(tProperty[i][1])
        extraInfo[sIndex] = tProperty[i][2]
    end

    local nFighting = caculateClothesFighting(extraInfo)

    return nFighting
end

--@brief    创建战力属性总tips
--@param    parentNode:tips添加到的父节点
--@param    fighting:总战力
--@param    tProperty:总属性
function CellWakeupDetail:_createPropertyTips(parentNode, fighting, tProperty)
    -- body
    local conTips = WZUIContainer:create()
    conTips:setAbsContentSize(GlobalMethod:CCSize(175,202))
    conTips:setUseAbsSize(true)
    conTips:setAnchorPoint(GlobalMethod:ccp(0, 1))
    conTips:setRelativePosition(GlobalMethod:ccp(0.14,0.5))

    local imgBK = WZUI9Image:create()
    imgBK:setFile("ui/common/common_scale9_di24.png")
    conTips:addChild(imgBK)

    local sFormat = [[<T C="127,70,26" S="20" P="1">%s：</T><T C="5,180,0" S="20" P="1">%d</T>]]
    if ProjConfig.LANGUAGE ~= "cn" or ProjConfig.LANGUAGE ~= "hk" then
        sFormat = [[<T C="127,70,26" S="20" P="1">%s:</T><T C="5,180,0" S="20" P="1">%d</T>]]
    end
    local txtFighting = WZUIFreeTextBox:create()
    txtFighting:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
    txtFighting:setRelativePosition(GlobalMethod:ccp(0.1, 0.875))
    txtFighting:setMaxWidth(200)
    txtFighting:setShowText(string.format(sFormat, LocalStrings.COMBAT_IN_ALL, fighting))
    conTips:addChild(txtFighting)

    for i= 1, #tProperty do
        local txtProperty = WZUIFreeTextBox:create()
        txtProperty:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
        txtProperty:setRelativePosition(GlobalMethod:ccp(0.1, 0.72 - 0.15 * (i - 1)))
        txtProperty:setMaxWidth(200)
        txtProperty:setShowText(string.format(sFormat, ATTR_TITLE[tProperty[i][1]], tProperty[i][2]))
        conTips:addChild(txtProperty)
        if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" then
            txtProperty:setScale(0.8)
        end
    end

    parentNode:addChild(conTips, 2, 999)
end

--@brief    挖到宝物的特效
function CellWakeupDetail:_displayTrainParticle(nTag)
    -- body
    WZLog("CellWakeupDetail:_displayTrainParticle", nTag)
    local nLineIndex = math.floor(math.random(1,3))
    --屏蔽触摸层
    -- local img9Black = WZUI9Image:create()
    -- img9Black:setOpacity(0)
    -- img9Black:setFile("ui/common/common_black_bg.png")
    -- img9Black:setTag(888)
    -- self.m_root:addChild(img9Black)

    local particleTrain = CCParticleSystemQuad:create("particle/ui_juexingzhihun_tuowei.plist")
    particleTrain:setDuration(kCCParticleDurationInfinity)
    particleTrain:setAutoRemoveOnFinish(true)
    if nTag == 1 then
        particleTrain:setStartColor(ccc4f(233/255,166/255,62/255,1))
        particleTrain:setEndColor(ccc4f(0,0,0,0))
    elseif nTag == 2 then
        particleTrain:setStartColor(ccc4f(198/255,130/255,255/255,1))
        particleTrain:setEndColor(ccc4f(0,0,0,0))
    elseif nTag == 3 then
        particleTrain:setStartColor(ccc4f(93/255,222/255,254/255,1))
        particleTrain:setEndColor(ccc4f(0,0,0,0))
    end
    particleTrain:setPosition(self.m_tStartPoint[nTag][1], self.m_tStartPoint[nTag][2])

    local conSoul = GetElement(self.m_root, "conSoul_CellWakeupDetail", WZUIContainer)
    conSoul:addChild(particleTrain)

    if particleTrain then
        particleTrain:setVisible(true)

        local arrayAni = CCArray:create()

        local delayAni2 = CCDelayTime:create(0.3)
        local delayAni3 = CCDelayTime:create(0.5)
        local moveTo
        if nLineIndex == 1 then
            moveTo = CCMoveTo:create(0.5, ccp(self.m_tTargetPoint[1][1], self.m_tTargetPoint[1][2]))
        elseif nLineIndex == 2 then
            local configInfo = ccBezierConfig()
            configInfo.endPosition = GlobalMethod:ccp(self.m_tTargetPoint[1][1],self.m_tTargetPoint[1][2])
            configInfo.controlPoint_1 = GlobalMethod:ccp(self.m_tSecondPoint[nTag][1][1],self.m_tSecondPoint[nTag][1][2])
            configInfo.controlPoint_2 = GlobalMethod:ccp(self.m_tThirdPoint[nTag][1][1],self.m_tThirdPoint[nTag][1][2])

            moveTo = CCBezierTo:create(0.5, configInfo)
        else
            local configInfo = ccBezierConfig()
            configInfo.endPosition = GlobalMethod:ccp(self.m_tTargetPoint[1][1],self.m_tTargetPoint[1][2])
            configInfo.controlPoint_1 = GlobalMethod:ccp(self.m_tSecondPoint[nTag][2][1],self.m_tSecondPoint[nTag][2][2])
            configInfo.controlPoint_2 = GlobalMethod:ccp(self.m_tThirdPoint[nTag][2][1],self.m_tThirdPoint[nTag][2][2])

            moveTo = CCBezierTo:create(0.5, configInfo)
        end
        local functionAni1 = CCCallFuncN:create(playBaoJiType)
        local delayAni5 = CCDelayTime:create(0.5)
        local functionAni4 = CCCallFuncN:create(afterParticle)

        arrayAni:addObject(delayAni3)
        arrayAni:addObject(moveTo)
        arrayAni:addObject(delayAni2)
        arrayAni:addObject(functionAni1)
        arrayAni:addObject(delayAni5)
        arrayAni:addObject(functionAni4)

        local sequence = CCSequence:create(arrayAni)
        particleTrain:runAction(sequence)
    end
end

--@brief    特效播放完成后的回调
function afterParticle(element)
    -- body
    GetElement(CellWakeupDetail.m_root, "spineBig_CellWakeupDetail", WZUISpine):setVisible(false)
    GetElement(CellWakeupDetail.m_root, "spineSmall_CellWakeupDetail", WZUISpine):setVisible(false)

    CellWakeupDetail:_createAtlasFont(CellWakeupDetail.m_nTempBaseExp * CellWakeupDetail.m_nDoubleTimes, CellWakeupDetail.m_nDoubleTimes)
    CellWakeupDetail.m_nTempBaseExp = CellWakeupDetail.baseExp[CellWakeupDetail.m_nIndex] 
    CellWakeupDetail.m_nDoubleTimes = CellWakeupDetail.multiple[CellWakeupDetail.m_nIndex] 

    --展示经验条变化动画
    CellWakeupDetail:showProgress()
	CellWakeupDetail.m_nIndex = CellWakeupDetail.m_nIndex + 1

    if element then
        element:removeFromParentAndCleanup(true)
    end

	-- if CellWakeupDetail.use5Time == true then
	-- 	CellWakeupDetail:updateUpLog()
	-- 	CellWakeupDetail.use5Time = false
	-- end
end

--@brief    粒子效果播放完成以后，回复原来状态
function playBaoJiType(element)
    -- body
    if element then
        element:setVisible(false)
    end

    local spineBig = GetElement(CellWakeupDetail.m_root, "spineBig_CellWakeupDetail", WZUISpine)
    local spineSmall = GetElement(CellWakeupDetail.m_root, "spineSmall_CellWakeupDetail", WZUISpine)
    if CellWakeupDetail.m_nDoubleTimes > 5 then
        if spineBig then
            spineBig:play("ui_juexingzhihun_baoji", false)
            spineBig:setVisible(true)
        end
    else
        if spineSmall then
            spineSmall:play("ui_juexingzhihun_xiaobaoji", false)
            spineSmall:setVisible(true)
        end
    end
end

--@brief    创建角色动画
function CellWakeupDetail:_createPlayerHuanhua()
    -- body
    local sex = CacheCenter:getPlayerInfo().sex
    local tEquip = CacheCenter:getEquipmentList()
    local headColor, bodyColor = CacheCenter:getHeadAndBodyColor()
    local skinId = self:_getCorrectSkin()

    local con = CreatePlayerFigure( sex , tEquip, nil, nil, nil, nil, nil, nil, nil, nil, headColor, bodyColor, true, skinId)

    local conBody = GetElement(self.m_root, "conBody_CellWakeupDetail", WZUIContainer)
    con:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5, 0))
    con:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.5, 0.2))
    if self.m_tRoleAni == nil then
        self.m_tRoleAni = con
        conBody:addChild(con:getAnimNode())
    end
end

--@brief    获取相应的幻化皮肤
function CellWakeupDetail:_getCorrectSkin()
    -- body
    local sex = CacheCenter:getPlayerInfo().sex
    WZLog("CellWakeupDetail:_getCorrectSkin", type(CacheCenter:getGameParam()["awakeSkin"]), CacheCenter:getGameParam()["awakeSkin"])
    local tSkin, tNum = SplitItemString(CacheCenter:getGameParam()["awakeSkin"])
    for i = 1, #tSkin do
        local basicInfo = GDatatab_item["id_" .. tSkin[i]]
        if basicInfo.sex == sex then
            return basicInfo.property[1][1], tNum[i]
        end
    end

    return nil 
end

--@brief    滚动显示消耗进度
function CellWakeupDetail:showProgress()
    -- body
    self.m_nTotalAddExp = self.m_nTotalAddExp + self.m_nTempBaseExp * self.m_nDoubleTimes
    self.m_nTempExp = self.m_nCurSoulExp
    self.m_nEachAddExpForPgr = math.floor(self.m_nTotalExpForAni/50)
    self.m_nTempLevel = self.m_nSoulLevel

    local conSoulLeft = GetElement(self.m_root, "conSoulLeft_CellWakeupDetail", WZUIContainer)
    if conSoulLeft then
        WZLog("CellWakeupDetail:showProgress")
        conSoulLeft:enableSchedule("displayPrg", 0.01)
    end
end

function CellWakeupDetail:displayPrg()
    -- body
    WZLog("CellWakeupDetail:displayPrg", self.m_nTempExp, self.m_nTotalAddExp)
    local conSoulLeft = GetElement(self.m_root, "conSoulLeft_CellWakeupDetail", WZUIContainer)
    self.m_nTempExp = self.m_nTempExp + self.m_nEachAddExpForPgr 
    if self.m_nTempExp >= self.m_nTotalExpForAni then
        self.m_nTempExp = 0 
        self.m_nTempLevel = self.m_nTempLevel + 1
        local tUpgradeData = GDatatab_awake_crystal["id_" .. self.m_nTempLevel]
        if tUpgradeData then
            self.m_nEachAddExpForPgr = math.floor(tUpgradeData.need_exp/50)
        end
    end
    self.m_nTotalAddExp = self.m_nTotalAddExp - self.m_nEachAddExpForPgr
    if self.m_nTotalAddExp <= 0 then
        self.m_nTotalAddExp = 0 
        WndWakeup.m_bIsTraining = false 
        conSoulLeft:disableSchedule()

        self:_setDynamicText()
        return 
    end
    self:_setDynamicPrg(self.m_nTempExp, self.m_nTempLevel)
end

--@brief    获取子技能的基础数据
--@param    skillId : 技能的Id
--@param    bNextLevel : 子技能的等级
--@note     根据Id和等级获取子技能的相应的数据
function CellWakeupDetail:getSubSkillData(skillId, bNextLevel)
    -- body
    local tTempData = GDatatab_skill["id_" .. skillId]

    if not bNextLevel then 
        return tTempData 
    end

    for i, value in pairs(GDatatab_skill) do
        if value.skill_type == 5 and value.specialAttackParam == tTempData.specialAttackParam + 1 then
            return value
        end
    end
    return nil 
end
-------------------------------------私有方法模块End----------------------------------------
