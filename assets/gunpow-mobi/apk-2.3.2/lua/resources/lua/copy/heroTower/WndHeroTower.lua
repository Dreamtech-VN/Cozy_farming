--WndHeroTower.lua
--@brief	WndHeroTower的UI模块
--@date		2020/03/27
--@author	XTX
--@note		英雄塔界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndHeroTower:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
    CacheCenter:registerUpatePlayerInfoObserver(self)
    ProtocolProcessorSingleMap:regAll()

    WndCurrentChat:addWndCurrentChatToCurScene(self.m_root:getLuaObjectName(),self.m_root)
    -- ChangeChatChannel(Chat_Channel_Tower_Copy_Hall)

    self.m_nAllFloorNum = GetTableLen(GDatatab_herotower_map)
    local sResetConsume = CacheCenter:getGameParam().heroTowerRestConsume
    local ids, nums = SplitItemString(sResetConsume)
    self.m_tResetCost = {}
    for i = 1, #ids do
        table.insert(self.m_tResetCost, {tonumber(ids[i]), tonumber(nums[i])})
    end
    self:adaptIphoneX()
    WZLog("WndHeroTower    00000")
    ProtocolProcessorSingleMap:send_MAP_GetHeroTowerData()

    --排行榜
    ProtocolProcessorSingleMap:send_MAP_CrossGetTodayHeroTowerRank(0)

    if g_tHeroChallengeReward then
        local tId, tNum = {}, {}
        for i = 1, #g_tHeroChallengeReward do
            table.insert(tId, g_tHeroChallengeReward[i][1])
            table.insert(tNum, g_tHeroChallengeReward[i][2])
        end
        WndRewardShow:showById(tId, tNum)
        g_tHeroChallengeReward = nil 
    end

    self:setSpineAni()
    self:_adaptIphoneX()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndHeroTower:onExit(element)
    CacheCenter:unregisterUpatePlayerInfoObserver(self)
    self.m_root:disableSchedule()
	self:_unInit()
end

--@brief    界面加载完成回调
function WndHeroTower:onEnterTransitionDidFinish(element)
	--body
end

--@brief 	点击刷新对手按钮回调
function WndHeroTower:onClickUpdateEnemy(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_nCurSelIndex - 1 ~= self.m_nMyFloor then 
        if self.m_nCurSelIndex - 1 < self.m_nMyFloor then 
            MsgBoxManager:showTipBox(LocalStrings.HEROTOWER_TEXT15)
        else
            MsgBoxManager:showTipBox(string.format(LocalStrings.HEROTOWER_TEXT14, self.m_tEnemyData[self.m_nMyFloor + 1].towerInfo.name))
        end
        return 
    end

	if self.m_nMyFloor >= self.m_nAllFloorNum then 
		MsgBoxManager:showTipBox(LocalStrings.HEROTOWER_TEXT5)
		return 
	end
	
	self:callRefreshEnemy(self.m_tEnemyData[self.m_nMyFloor + 1])
end

--@brief 	点击挑战按钮回调
function WndHeroTower:onClickChallenge(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_nCurSelIndex - 1 ~= self.m_nMyFloor then 
        if self.m_nCurSelIndex - 1 < self.m_nMyFloor then 
            MsgBoxManager:showTipBox(LocalStrings.HEROTOWER_TEXT15)
        else
            MsgBoxManager:showTipBox(string.format(LocalStrings.HEROTOWER_TEXT14, self.m_tEnemyData[self.m_nMyFloor + 1].towerInfo.name))
        end
        return 
    end

	if self.m_nMyFloor >= self.m_nAllFloorNum then 
		MsgBoxManager:showTipBox(LocalStrings.HEROTOWER_TEXT5)
		return 
	end

    if self.m_nMyCurHP == 0 then 
        local cost = self.m_tResetCost[self.m_nResetTimes + 1]

        if cost ~= nil then 
            MsgBoxManager:showTipBox(LocalStrings.HEROTOWER_TEXT11)
        else
            MsgBoxManager:showTipBox(LocalStrings.HEROTOWER_TEXT10)
        end
        return 
    end

    SceneCity:updateRedDotBuilding("heroTower", false)
    ProtocolProcessorSceneCity:send_PLAYER_CancelRedDot(247)
    GlobalGame.g_tRedPointList.heroTower = false
    -- 处理战斗时默认皮肤大招id获取不到的问题,做一层保险
    if GlobalGame.g_saveBigSkillType == 2 and (CacheCenter.m_nDefaultShapeBigSkill == nil or CacheCenter.m_nDefaultShapeBigSkill <= 0) then
        ProtocolProcessorWndSkillProp:send_PLAYER_GetShapeSkillList(2)
    end
    ProtocolProcessorSingleMap:send_SINGLEMAP_StartChallenge(self.m_tEnemyData[self.m_nMyFloor + 1].towerInfo.id, COPYTYPE_HEROTOWER)
end

--@brief 	点击重置按钮回调
function WndHeroTower:onClickReset(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
	if self.m_nMyFloor >= self.m_nAllFloorNum then 
		MsgBoxManager:showTipBox(LocalStrings.HEROTOWER_TEXT5)
		return 
	end

    local cost = self.m_tResetCost[self.m_nResetTimes + 1]
    if cost == nil then 
        MsgBoxManager:showTipBox(LocalStrings.HEROTOWER_TEXT8)
        return 
    end

    local costContent = ""

    local tempContent = string.format("%d%s", cost[2], GDatatab_item["id_" .. cost[1]].name)
    costContent = costContent .. tempContent
    
    local txtContent = string.format(LocalStrings.HEROTOWER_TEXT7, costContent)

    MsgBoxManager:showConfirmBox(txtContent, self, self.callSureToReset, nil, nil)
end

function WndHeroTower:callSureToReset(nId, nResType)
    -- body
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WZLog("WndHeroTower:callSureToReset 222")
        local tCustomUIConfig = {[MSGBOXUICFG_CONFIRM] = LocalStrings.REWARD_BTN_GET}

        local cost = self.m_tResetCost[self.m_nResetTimes + 1]
        if not JudgeMoneyIsEnough(cost[1], cost[2], nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, tCustomUIConfig, 1, self, self.sureUseDiamondToReset) then 
            return 
        end
        
        self:sureUseDiamondToReset()
    end
end

--@brief    确认用钻石代替礼券召唤回调
function WndHeroTower:sureUseDiamondToReset()
    -- body
    self.m_nLoadingTag = MsgBoxManager:showLoadingBox()
    ProtocolProcessorSingleMap:send_MAP_ResetHeroTower()
end

--@brief	点击图标
function WndHeroTower:onClickItem(tCell,tag,tData)
	WZLog("WndHeroTower:onClick")
    WndItemInfo:showInfo(tCell.m_root, self.m_root, 1, tData, false, nil, true)
end

--@brief 	点击buff图标回调
function WndHeroTower:onCLickBuff(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local tData = {}
    tData.buffId = g_myHeroTowerBuffId
    WndTips:show(element, self.m_root, 55, tData, GlobalMethod:ccp(20, 20), true)
end

--@brief    点击继续  回调
function WndHeroTower:onClickContinue(element)
    -- body
    GetElement(self.m_root, "img9OpacityBg_WndHeroTower", WZUI9Image):setOpacity(0)
    local conBuffIcon = GetElement(self.m_root, "conBuffIcon_WndHeroTower", WZUIContainer)
    local conForBuff = GetElement(self.m_root, "conForBuff_WndHeroTower", WZUIContainer)
    local conSize = conForBuff:getContentSize()
    local ptB = conForBuff:convertToWorldSpace(GlobalMethod:ccp(0,0))

    local moveTo = CCMoveTo:create(0.5, GlobalMethod:ccp(ptB.x + conSize.width/2, ptB.y + conSize.height/2))
    local scaleTo = CCScaleTo:create(0.5, 0.2)

    local spawnAct = CCSpawn:createWithTwoActions(moveTo, scaleTo)
    local actionArray = CCArray:create()
    actionArray:addObject(spawnAct)
    actionArray:addObject(CCCallFuncN:create(_removeTheBuffNode))
    local repH = CCSequence:create(actionArray)
    
    conBuffIcon:runAction(repH)
end

--@brief    触摸开始
function WndHeroTower:onTouchBegan(element, pt)
    -- body
    self.m_nMoveDistance = 0
    self.m_nTouchBeginX = pt.x
    self.m_bIsPtInList = self:checkInList(pt)

    self.m_nTouchBeginTime = WZThread:getUTickCount()
end

--@brief    触摸滑动
function WndHeroTower:onTouchMove(element, pt)
    -- body
    if self.m_nTouchBeginX == nil then 
        self.m_nTouchBeginX = pt.x
    end
    local moveX = pt.x - self.m_nTouchBeginX
    self.m_nMoveDistance = self.m_nMoveDistance + moveX
    self.m_nTouchBeginX = pt.x
end

--@brief    触摸结束
function WndHeroTower:onTouchEnd(element, pt)
    -- body
    if self.m_nMoveDistance > 0 and math.abs(self.m_nMoveDistance) > 30 and self.m_bIsPtInList then 
        self:moveHeroList(-1)
    elseif self.m_nMoveDistance < 0 and math.abs(self.m_nMoveDistance) > 30 and self.m_bIsPtInList then
        self:moveHeroList(1)
    end
end

function WndHeroTower:checkInList(pt)
    WZLog("WndHeroTower:checkInList")
    local btn = GetElement(self.m_root, "conScissor_WndHeroTower", WZUIContainer)
    if btn == nil then return false end
    local btnSize = btn:getContentSize()
    --获得btn的世界坐标
    local ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
    if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
        return true
    end 
    return false
end

--@brief    点击规则按钮回调
function WndHeroTower:onCLickRule(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndSingleMapDesc:showInterface1(LocalStrings.HEROTOWER_TEXT17)
end

-- 点击排名显示排行榜
function WndHeroTower:onBtnRank(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndTowerRank:showWindow(1)
end

--@brief    刷新小排行榜
function WndHeroTower:createMatchGoal()
    for i=1,5 do
        local conHead = GetElement(self.m_root,"conHead"..i.."_WndHeroTower",WZUIContainer)
        local conRank = GetElement(self.m_root,"conRank"..i.."_WndHeroTower",WZUIContainer)
        local txtNullSeat = GetElement(conHead, "txtNullSeat_WndHeroTower", WZUILabelTTF)
        if self.matchGoal.playerInfo[i] then
            local m_bIsOffline = false
            CellHead:show(conHead,self.matchGoal.playerInfo[i].headId,self.matchGoal.playerInfo[i].faceId,self.matchGoal.playerInfo[i].playerSex, m_bIsOffline, nil, nil, self.matchGoal.playerInfo[i].headColor)
            conRank:setVisible(true)
            txtNullSeat:setVisible(false)
        else
            conRank:setVisible(true)
            txtNullSeat:setVisible(true)
        end
    end
end

--@brief    点击头像回调
function WndHeroTower:onClickHead(element)
    local tag = element:getTag()
    if self.matchGoal.playerInfo[tag] == nil then return end

    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndCheckOther:show(self.matchGoal.playerInfo[tag].playerId)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndHeroTower:_update()
	--body
	self:_showBuffBtnIcon()
	self:_showUpdateEnemyCost()
	self:_showPlayerInfo()
	self:createHeroList()

	self:_showCurReward()
end

--@brief 	显示玩家自己的信息
function WndHeroTower:_showPlayerInfo()
	-- body
    WZLog("WndHeroTower:_showPlayerInfo()")
	local conHead = GetElement(self.m_root, "conHead_WndHeroTower", WZUIContainer)
	local playerInfo = CacheCenter:getPlayerInfo()

	local tEquip = CacheCenter:getEquipmentList()
    local head = nil
    local face = nil
    if tEquip then 
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
    end

    --设置默认显示
    local gameParam = CacheCenter:getGameParam()
    if playerInfo.sex == 0 then
        if head == nil then head = gameParam.defaultManHeadId or 4903 end
        if face == nil then face = gameParam.defaultManFaceId or 4902 end
    else
        if head == nil then head = gameParam.defaultWomanHeadId or 4906 end
        if face == nil then face = gameParam.defaultWomanFaceId or 4905 end
    end

	local headColor, bodyColor = CacheCenter:getHeadAndBodyColor()
	local element = CellHead:show(conHead, head, face, playerInfo.sex, nil, nil, playerInfo.vipLevel, headColor)
    element:setScale(1.1)
	--玩家血量
	--玩家怒气
    self:_showPlayerHP()
end

--@brief    刷新对手
function WndHeroTower:callRefreshEnemy(tEnamyData)
    -- body
    local tVipData = self:_getVipLimitData(tEnamyData)
    self.m_tCurEnemyData = tEnamyData
    --次數已經用完
    if tVipData == nil then 
        MsgBoxManager:showTipBox(LocalStrings.HEROTOWER_TEXT16)
        return 
    end
    --vip等級不夠
    if tVipData.vip_level > CacheCenter:getPlayerInfo().vipLevel then 
        local tCustomUIConfig = {[MSGBOXUICFG_CONFIRM] = LocalStrings.REWARD_BTN_GET}
        MsgBoxManager:showConfirmBox(LocalStrings.PET_STORE_REFRESH_TIMES_LIMIT, self, self.needHigherCallBack, nil, tCustomUIConfig)
        return 
    end
    --提示需要消耗的钻石
    local txtContent = string.format(LocalStrings.HEROTOWER_TEXT6, tVipData.cost[1][2], GDatatab_item["id_" .. tVipData.cost[1][1]].name)

    MsgBoxManager:showConfirmBox(txtContent,self,self.callSure, nil, nil)
end

function WndHeroTower:callSure(nId, nResType)
    -- body
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WZLog("WndHeroTower:callSure 222")
        local tVipData = self:_getVipLimitData(self.m_tCurEnemyData)
        if tVipData ~= nil then
            local tCustomUIConfig = {[MSGBOXUICFG_CONFIRM] = LocalStrings.REWARD_BTN_GET}
            if not JudgeMoneyIsEnough(tVipData.cost[1][1], tVipData.cost[1][2], nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, tCustomUIConfig, 1, self, self.sureUseDiamondInstead) then 
                return 
            end
        end
        
        self:sureUseDiamondInstead()
    end
end

--@brief    确认用钻石代替礼券召唤回调
function WndHeroTower:sureUseDiamondInstead()
    -- body
    self.m_nLoadingTag = MsgBoxManager:showLoadingBox()
    ProtocolProcessorSingleMap:send_MAP_ChangeHeroTowerEnemy(self.m_nMyFloor + 1)
end

--@brief    获取当前VIP限购数据
function WndHeroTower:_getVipLimitData(tEnemyData)
    -- body
    for key, value in pairs(GDatatab_vip_restriction) do
        if value.type == 27 and value.count == tEnemyData.refreshTimes + 1 then
            return value
        end
    end

    return nil 
end

--@brief    提示提升VIP等級的回调
--@param    nId:消息id
--@param    nResType:响应类型(超时，确定，取消)
function WndHeroTower:needHigherCallBack(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        PassportSdkManager:gotoPaymentPage()
    end
end

--@brief 	展示当前奖励预览
function WndHeroTower:_showCurReward()
	-- body
	local tableReward = GetElement(self.m_root, "tableReward_WndHeroTower", WZUITableContainer)
	tableReward:cleanTable()

	local tReward = self.m_tEnemyData[self.m_nCurSelIndex].towerInfo.floor_reward
	for i = 1, #tReward do
		local element, tNewObj = CellGoodItem:createElement()
		if element and tNewObj then
			element:setTag(i - 1) 
			tNewObj:setCellGoodLocalId(tReward[i][1], tReward[i][2], 4)
			tNewObj:setItemClickFun(self, self.onClickItem)

			tableReward:setCellElement(element)
		end
	end
end

function WndHeroTower:createHeroList()
    -- body
    local conScissor = GetElement(self.m_root, "conScissor_WndHeroTower", WZUIScissorContainer)
    self.m_tEnemyCell = {}
    self.m_tEnemyElement = {}
    self.m_nLoadIndex = 1
    conScissor:enableSchedule("_loadHero")
end

--@brief    展示全屏buff
function WndHeroTower:showHeroBuff()
    -- body
    if g_myHeroTowerBuffId == nil then 
        if self.m_tSweepRewardNum and #self.m_tSweepRewardNum > 0 then 
            self:showSweepResult(self.m_tSweepRewardNum, self.m_tSweepRewardId, self.m_tSweepRewardCount)
        end
        return 
    end 

    --本次登陆显示过就不显示了
    if g_bShowWndMsgConfirmBox ~= nil then
        for k,v in pairs(g_bShowWndMsgConfirmBox) do
            if v == "TOWER_DESC_HERO" then
                if self.m_tSweepRewardNum and #self.m_tSweepRewardNum > 0 then 
                    self:showSweepResult(self.m_tSweepRewardNum, self.m_tSweepRewardId, self.m_tSweepRewardCount)
                end
                return 
            end
        end
    end

    if g_bShowWndMsgConfirmBox == nil then g_bShowWndMsgConfirmBox = {} end
    local bIsExist = false 
    for k,v in pairs(g_bShowWndMsgConfirmBox) do
        if v == "TOWER_DESC_HERO" then 
            bIsExist = true
            break 
        end
    end
    --没有保存这次提示的句子，加入这句
    if not bIsExist then 
        table.insert(g_bShowWndMsgConfirmBox, "TOWER_DESC_HERO")
    end

    local buffData = GDatatab_herotower_map["id_" .. g_myHeroTowerBuffId]
    if buffData == nil then return end 
    GetElement(self.m_root, "CellBuffShow_WndHeroTower", WZUIContainer):setVisible(true)
    GetElement(self.m_root, "imgBuffIcon2_WndHeroTower", WZUIImage):setFile(buffData.buff2icon)
    GetElement(self.m_root, "txtBuffName_WndHeroTower", WZUILabelTTF):setText(buffData.name2)
end

--@brief    动画回调
function _removeTheBuffNode(element)
    --body
    WZLog("_removeTheBuffNode", #WndHeroTower.m_tSweepRewardNum)
    if WndHeroTower.m_tSweepRewardNum and #WndHeroTower.m_tSweepRewardNum > 0 then 
        WndHeroTower:showSweepResult(WndHeroTower.m_tSweepRewardNum, WndHeroTower.m_tSweepRewardId, WndHeroTower.m_tSweepRewardCount)
    end
    GetElement(WndHeroTower.m_root, "CellBuffShow_WndHeroTower", WZUIContainer):setVisible(false)
end

--@brief 	显示刷新消耗
function WndHeroTower:_showUpdateEnemyCost()
	-- body
	local ftxtUpdateCost = GetElement(self.m_root, "ftxtUpdateCost_WndHeroTower", WZUIFreeTextBox)
	if ftxtUpdateCost then 
		local tVipData = self:_getVipLimitData(self.m_tEnemyData[self.m_nCurSelIndex])
		if tVipData then 
			local formatCost = [[<I Z="0.5" P="1">%s</I><T C="255,255,255" S="22" P="1" SC="131,40,13" SE="1" SS="4">%d</T>]]
			ftxtUpdateCost:setShowText(string.format(formatCost, GDatatab_item["id_" .. tVipData.cost[1][1]].icon , tVipData.cost[1][2]))
        else
            local formatCost = [[<T C="255,255,255" S="22" P="1" SC="131,40,13" SE="1" SS="4">%s</T>]]
            ftxtUpdateCost:setShowText(string.format(formatCost, ""))
		end
	end
end

--@brief 	设置buff图标
function WndHeroTower:_showBuffBtnIcon()
	-- body
	local imgBuffIcon = GetElement(self.m_root, "imgBuffIcon_WndHeroTower", WZUIImage)
    if imgBuffIcon then 
        if g_myHeroTowerBuffId then 
            local buffData = GDatatab_herotower_map["id_" .. g_myHeroTowerBuffId]
            imgBuffIcon:setFile(buffData.buff2icon)
        end
    end
end

--@brief    显示玩家血量
function WndHeroTower:_showPlayerHP()
    -- body
    --玩家血量
    local txtMyPH = GetElement(self.m_root, "txtMyPH_WndHeroTower", WZUILabelTTF)
    if txtMyPH then 
        txtMyPH:setText(self.m_nMyCurHP .. "%")
    end
    --玩家怒气
    local txtMyPF = GetElement(self.m_root, "txtMyPF_WndHeroTower", WZUILabelTTF)
    if txtMyPF then 
        txtMyPF:setText(self.m_nMyCurSP .. "%")
    end
end

--@brief    适配iphoneX
function WndHeroTower:adaptIphoneX()
    -- body
    if IsIphoneX() then 
        GetElement(self.m_root, "conForBuff_WndHeroTower", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.95,0.73))
        GetElement(self.m_root, "conMyInfo_WndHeroTower", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.95,0.85))
        GetElement(self.m_root, "conBtnRule_WndHeroTower", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.05,0))
    end
end

--@brief    移动英雄列表
function WndHeroTower:moveHeroList(nMoveStep)
    -- body
    self.m_bIsPtInList = false 
    if self.m_bIsExchangeEnemy then return end 
    if not self.m_bLoadMapFinish then return end 

    self.m_bIsExchangeEnemy = true
    local nStartX, nStartY = 0.5, 0.5

    local nTempSelIndex = self.m_nCurSelIndex + nMoveStep
    if nTempSelIndex > self.m_nAllFloorNum then 
        nTempSelIndex = self.m_nAllFloorNum
    end
    if nTempSelIndex < 1 then 
        nTempSelIndex = 1
    end
    if self.m_nCurSelIndex == nTempSelIndex then 
        self.m_bIsExchangeEnemy = false
        return 
    end 

    self.m_tEnemyCell[self.m_nCurSelIndex]:setFightingVisible(false)

    for i = 1, #self.m_tEnemyElement do
        local element = self.m_tEnemyElement[i]
        if element then 
            local nRanPtY = nStartY - math.abs(i - nTempSelIndex) * 0.08
            local actionSqu = WZUIActionSequence:create()
            if self.m_nCurSelIndex == i then 
                local moveTo = WZUIActionMoveTo:create()
                moveTo:setMoveX(nStartX + (i - nTempSelIndex) * 0.2)
                moveTo:setMoveY(nRanPtY)
                moveTo:setDuration(0.4)

                local scaleTo = WZUIActionScaleTo:create()
                scaleTo:setDuration(0.4)
                scaleTo:setScaleX(0.78)
                scaleTo:setScaleY(0.78)

                local actionSpawn = WZUIActionSpawn:create()
                actionSpawn:setChildAction(moveTo)
                actionSpawn:setChildAction(scaleTo)

                actionSqu:setChildAction(actionSpawn)
            elseif i == nTempSelIndex then 
                local moveTo = WZUIActionMoveTo:create()
                moveTo:setMoveX(nStartX + (i - nTempSelIndex) * 0.2)
                moveTo:setMoveY(nRanPtY)
                moveTo:setDuration(0.4)

                local scaleTo = WZUIActionScaleTo:create()
                scaleTo:setDuration(0.4)
                scaleTo:setScaleX(1)
                scaleTo:setScaleY(1)

                local actionSpawn = WZUIActionSpawn:create()
                actionSpawn:setChildAction(moveTo)
                actionSpawn:setChildAction(scaleTo)

                actionSqu:setChildAction(actionSpawn)
            else
                local actionSpawn = WZUIActionMoveTo:create()
                actionSpawn:setMoveX(nStartX + (i - nTempSelIndex) * 0.2)
                actionSpawn:setMoveY(nRanPtY)
                actionSpawn:setDuration(0.4)
                
                actionSqu:setChildAction(actionSpawn)
            end

            if i == self.m_nAllFloorNum then 
                self.m_root:enableSchedule("onActionFinishBack", 0.5)
            end
            element:runUIAction(actionSqu)
        end
    end

    self.m_nCurSelIndex = nTempSelIndex
end

function WndHeroTower:onActionFinishBack(element)
    --body
    WZLog("WndHeroTower:onActionFinishBack")
    element:disableSchedule()
    self.m_tEnemyCell[self.m_nCurSelIndex]:setFightingVisible(true)

    self.m_bIsExchangeEnemy = false 

    self:_showUpdateEnemyCost()

    self:_showCurReward()
end

--@brief    加载英雄
function WndHeroTower:_loadHero(element)
    -- body
    local conScissor = GetElement(self.m_root, "conScissor_WndHeroTower", WZUIScissorContainer)
    
    if self.m_nLoadIndex > self.m_nAllFloorNum then 
        self.m_bLoadMapFinish = true
        conScissor:disableSchedule()
        return 
    end

    local nStartX, nStartY = 0.5, 0.5

    local element, tNewObj = CellHeroTower:createElementTwo()
    if element and tNewObj then 
        element:setTag(self.m_nLoadIndex - 1)
        tNewObj:setData1(self.m_tEnemyData[self.m_nLoadIndex])
        element:setRelativePosition(GlobalMethod:ccp(0.5 + (self.m_nLoadIndex - self.m_nCurSelIndex) * 0.2, 0.5 - math.abs(self.m_nLoadIndex - self.m_nCurSelIndex) * 0.08))
        conScissor:addChild(element)
        if self.m_nCurSelIndex == self.m_nLoadIndex then
            tNewObj:setFightingVisible(true)
        else
            element:setScale(0.78)
        end

        self.m_tEnemyCell[self.m_nLoadIndex] = tNewObj
        self.m_tEnemyElement[self.m_nLoadIndex] = element
    end

    self.m_nLoadIndex = self.m_nLoadIndex + 1
end
-------------------------------------私有方法模块End----------------------------------------



--@brief    适配iphoneX 
function WndHeroTower:_adaptIphoneX()
    if IsIphoneX() then
        GetElement(self.m_root, "conRankInfo_WndHeroTower", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.1, 0.5))
    end
end

--@brief    设置开箱特效
function WndHeroTower:setSpineAni()
    local spineReset = GetElement(self.m_root,"spineReset_WndHeroTower",WZUISpine)
    local spinePath = "ui/otherUI/ui_icon_nuqi"
    local bIsExist = CheckEffectFile(spinePath)
    
    if bIsExist then 
        spineReset:setFileJson(spinePath .. ".json")
        spineReset:setFileAtlas(spinePath .. ".atlas")
        spineReset:play("wait", true)
    end
end
-------------------------------------语言适配begin----------------------------------------
function WndHeroTower:_adaptLanguage_vn()
    GetElement(self.m_root,"txtReward_WndHeroTower",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtReset_WndHeroTower",WZUILabelTTF):setScale(0.6)
end


-------------------------------------语言适配end----------------------------------------
