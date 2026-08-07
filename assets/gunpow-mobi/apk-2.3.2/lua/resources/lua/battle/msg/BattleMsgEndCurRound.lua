--BattleMsgEndCurRound.lua
--@brief	战斗相关消息
--@date		2013/12/31
--@author	李俊鸿
--@note		战斗操作结束

--@brief	消息数据表
BattleMsgEndCurRound = {
    m_sName = "BattleMsgEndCurRound",
	m_nBattleId = 0, --战斗id
	m_nPlayerId = 0, --角色id
	m_nCurrentPlayerId = 0, --角色id(当前在操作的角色）
	m_nPlayerOrGuai = nil, --英雄还是怪物(0:player,1:guai)
    m_nbIsFirstMsg = false, --是否一进战斗时候执行的
    m_tStepFunction = nil, --步骤函数
    m_tShootSoulHero = nil, --出手的灵魂分身
    m_nShootGapping = 0,    --灵魂分身出手间隔
}

-------------------------------------公有方法模块--------------------------------------

--@brief	消息初始化函数
--@note		消息系统第一次调用process函数前调用
function BattleMsgEndCurRound:init()
	WZLog("BattleMsgEndCurRound:init", tostring(self.note), tostring(WBattleGlobal:getCurrent():isCurTurnHaveSendEndMsg()), self.m_nPlayerId, self.m_nCurrentPlayerId)
    WBattleGlobal:getCurrent().m_bIsCanUseAwakeSkill = false
    WBattleGlobal:getCurrent():checkHurtBuffTotem(MonsterType.FIRE_TOTEM)
    WBattleGlobal:getCurrent():checkHurtBuffTotem(MonsterType.GUARDIAN_TOTEM)
    WBattleGlobal:getCurrent():checkHurtBuffTotem(MonsterType.MARITIME1_TOTEM)
    WBattleGlobal:getCurrent():checkHurtBuffTotem(MonsterType.MARITIME2_TOTEM)
    WBattleGlobal:getCurrent():checkHurtBuffTotem(MonsterType.MARITIME3_TOTEM)
    WBattleGlobal:getCurrent():checkHurtBuffTotem(MonsterType.JIANGZIYA_TOTEM)
    WBattleGlobal:getCurrent():checkHurtBuffTotem(MonsterType.UMBRELLA1_TOTEM)
    WBattleGlobal:getCurrent():checkHurtBuffTotem(MonsterType.UMBRELLA2_TOTEM)
    
    --假如使用了大招，是皮肤大招，隐藏了正常英雄，而没有出手，则这里恢复
    local hero = WBattleGlobal:getCurrent():getCurrentHero()
    if hero and hero._showNormalHero then 
        hero:_showNormalHero()
    end

    if WBattleGlobal:getCurrent():isCurTurnHaveSendEndMsg() == true then
        return
    end
    WBattleGlobal:getCurrent():setWaitNextRound(true,4)

    self.m_tStepFunction = {}
    self.m_tShootSoulHero = nil 
    self.m_nShootGapping = 0 
    --进行孩子出手
    WBattleGlobal:getCurrent():kidTakeShoot()
    table.insert(self.m_tStepFunction,self._finishKidShoot)
    --进行灵魂宿主-灵魂分身射击
    table.insert(self.m_tStepFunction,self._doSoulHeroEquipSkill)
    table.insert(self.m_tStepFunction,self._finishSoulHeroEquipSkill)
    table.insert(self.m_tStepFunction,self._doSoulHeroShoot)
    table.insert(self.m_tStepFunction,self._finishSoulHeroShoot)
    --进行棋圣-棋子分身射击
    table.insert(self.m_tStepFunction,self._doSubHeroShoot)
    table.insert(self.m_tStepFunction,self._finishSubHeroShoot)
    --回合结束，生效需要回合结束处理的职业技能/道具-血之契约
    table.insert(self.m_tStepFunction,self._isActiveHurtGrowup)
    table.insert(self.m_tStepFunction,self._finishSoulHeroEquipSkill)
    table.insert(self.m_tStepFunction,self.clearHoldEffect)
end

--@brief	消息处理过程函数
--@return	#1,nil或true表示消息处理结束，否则返回false
--@note		未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgEndCurRound:process()
    --WZLog("BattleMsgEndCurRound:process")
    --WZLog(debug.traceback())
    if WBattleGlobal:getCurrent():isReplayGame() or WBattleGlobal:getCurrent():isAudience() then
        return
    end
--    WZLog("BattleMsgEndCurRound:process one")
    if #self.m_tStepFunction > 0 then
        local res = self.m_tStepFunction[1](self)
        if res == true or res == nil then
            table.remove(self.m_tStepFunction,1)
        end
        return false
    end
--    WZLog("BattleMsgEndCurRound:process two")
    if MsgManager:isInShowNonBlockMsg() then 
        return false 
    end
    
    if WBattleGlobal:getCurrent():isCurTurnHaveSendEndMsg() == true then
        return
    else
        WBattleGlobal:getCurrent().m_nSendEndMsgTurn = WBattleGlobal:getCurrent():getTurnTimes()
        WBattleGlobal:getCurrent().m_tSendEndMsgPlayer = WBattleGlobal:getCurrent():getCurrentHero()
    end

    self:sendRoundInfo()

	if WBattleGlobal:getCurrent():isSingleStage() then
        local isCtbRun = nil
        for i,v in pairs (BattleCtbManager.m_tCellBattleCtb) do
            if v.m_bIsAction then
                isCtbRun = true
            end
        end

        if isCtbRun then
            WZLog("BattleMsgEndCurRound:process isCtbRun")
            return false
        else
            self:processWithSingleMap()
        end
    else
        WZLog("BattleMsgEndCurRound:process send", self.m_nBattleId, self.m_nPlayerId, self.m_nCurrentPlayerId)
        local battle = WBattleGlobal:getCurrent()
        local playerIds = {}
        local isHide = {}
        local isFog = {}
        local isPenetrate = {}

        for id, hero in ipairs (battle:getCharacterList()) do
            table.insert(playerIds, hero:getBattleId())
            if hero:isHide() then 
                table.insert(isHide, 1)
            else
                table.insert(isHide, 0)
            end
            if hero:isFog() then 
                table.insert(isFog, 1)
            else
                table.insert(isFog, 0)
            end
            if hero:getCanPenetrate() then 
                table.insert(isPenetrate, 1)
            else
                table.insert(isPenetrate, 0)
            end
        end
        local roundCount = battle.m_nTurnTimes
        WZLog("BattleMsgEndCurRound:process send end", roundCount,
        "\n playerIds:", Serialize(playerIds),
        "\n isHide:", Serialize(isHide),
        "\n isFog:", Serialize(isFog),
        "\n isPenetrate:", Serialize(isPenetrate))
        ProtocolProcessorBattleInterface:send_BATTLE_EndCurRound(self.m_nBattleId, self.m_nPlayerId, playerIds, isHide, isFog, isPenetrate)--, self.m_nCurrentPlayerId)
    end
end

--@note     发送回合信息
function BattleMsgEndCurRound:sendRoundInfo()
    local battle = WBattleGlobal:getCurrent()
    local curId = battle:getCurrentCharacterId()
    local playerId = battle:getMyHero():getBattleId()
    local isHost = battle:isHostControl()
    local isGhost = battle:isGhostStage()

    local roundCount = battle.m_nTurnTimes
    local playerIds = {}
    local postionX = {}
    local postionY = {}
    local angle = {}
    local face = {}
    local explodePlayerId = -1
    local explodeSkillId = -1
    local explodePosX = {}
    local explodePosY = {}
    local explodePosWidth = {}
    local explodePosHeight = {}
    local explodeDirection = {}

    for id, hero in ipairs (battle:getCharacterList()) do
        local x = BattleCommon:float2int2float(hero:getPosition().x)
        local y = BattleCommon:float2int2float(hero:getPosition().y)
        local r = BattleCommon:float2int2float(hero:getAnimation():getRotate())
        --幽灵模式，如果掉出屏幕，则幽灵显示在出生点
        local isOutOfScene,_ = hero:checkIsOutOfScene()
        if isGhost and hero:isDead() then 
            r = 0
            if isOutOfScene then 
                WZLog("BattleMsgEndCurRound:sendRoundInfo 00000", Serialize(WBattleGlobal:getCurrent().m_tPlayerBornPt), hero:getBattleId())
                x = WBattleGlobal:getCurrent().m_tPlayerBornPt[hero:getBattleId()].x
                y = WBattleGlobal:getCurrent().m_tPlayerBornPt[hero:getBattleId()].y
            end
        end

        hero:setPosition({x = x , y = y } )
        hero:getAnimation():setRotate(r)

        table.insert(playerIds, hero:getBattleId())
        table.insert(postionX, x)
        table.insert(postionY, y)
        table.insert(angle, r)
        table.insert(face, hero:getAnimation():isFlipX() == true and 1 or 0)
    end

    if battle.m_nBattleType == BattleConstants.g_nBATTLE_TYPE_NORMAL and curId then
        for id, info in ipairs (battle.m_tExplodeInfoCurRound) do
            explodePlayerId = info.id
            explodeSkillId = info.skillId
            table.insert(explodePosX, info.x)
            table.insert(explodePosY, info.y)
            table.insert(explodePosWidth, info.width)
            table.insert(explodePosHeight, info.height)
            table.insert(explodeDirection, info.explodeDirection)
        end
    end

    local battleInfo = {}
    if battle:isEscapeBattle() then
        battleInfo.escapeBattle = {}
        battleInfo.escapeBattle.erosionDir = battle.m_tErosionData and battle.m_tErosionData.dir or 0
        battleInfo.escapeBattle.erosionCount = battle.m_tErosionData and  battle.m_tErosionData.count or 0

        local treasureIdList, treasureCatchIdIdList, treasurePosList = {}, {}, {}
        if battle.m_tTreasureList then            
            for i,info in ipairs(battle.m_tTreasureList) do
                if info.m_tSprite then
                    local x, y = info:getPosition()
                    table.insert(treasureIdList, info.m_nId)
                    table.insert(treasureCatchIdIdList, info.m_nCatchId)
                    table.insert(treasurePosList, {x=x, y=y})
                end
            end
        end
        battleInfo.escapeBattle.treasureIdList = treasureIdList
        battleInfo.escapeBattle.treasureCatchIdIdList = treasureCatchIdIdList
        battleInfo.escapeBattle.treasurePosList = treasurePosList
    end
    battleInfo = json.encode(battleInfo)

    WZLog("BattleMsgEndCurRound:sendRoundInfo two", roundCount,
        "\n playerIds:", Serialize(playerIds),
        "\n postionX:", Serialize(postionX),
        "\n postionY:", Serialize(postionY),
        "\n angle:", Serialize(angle),
        "\n face:", Serialize(face),
        "\n explodePlayerId:", Serialize(explodePlayerId),
        "\n explodeSkillId:", Serialize(explodeSkillId),
        "\n explodePosX:", Serialize(explodePosX),
        "\n explodePosY:", Serialize(explodePosY),
        "\n explodePosWidth:", Serialize(explodePosWidth),
        "\n explodePosHeight:", Serialize(explodePosHeight),
        "\n explodeDirection:", Serialize(explodeDirection),
        "\n battleInfo:", type(battleInfo), battleInfo)

    ProtocolProcessorBattleInterface:send_BATTLE_SendCurRoundInfo(self.m_nBattleId, roundCount,playerIds, postionX, postionY, angle, face, explodePlayerId, explodeSkillId, explodePosX, explodePosY, battleInfo, explodeDirection)
end

--@note     单人副本处理
function BattleMsgEndCurRound:processWithSingleMap()
    WZLog("BattleMsgEndCurRound:processWithSingleMap")

    if WBattleGlobal:getCurrent().m_bIsSingleChallengeGameOver == true or WBattleGlobal:getCurrent():isGameOver() then
        return
    end

    if WBattleGlobal:getCurrent():isReplayGame() then
        return
    end

    if WBattleGlobal:getCurrent():isFlyCopy() then
        local monster 
        for i,guai in pairs(WBattleGlobal:getCurrent():getGuaiList()) do
            monster = guai
            break
        end
        local dis = BattleCommon:pointDis(monster:getPosition(), WBattleGlobal:getCurrent():getMyHero():getPosition())
        if dis < 80 then
            monster:getAI():doAction(AiActionConfig.SKILL,{[1] = {actionParm1 = 80003}},nil,nil,nil,nil,nil,true)
            WZLog("BattleMsgEndCurRound:processWithSingleMap zero")
        end
    end

    WBattleGlobal:getCurrent():setCtbEndRecord()

    local playerId = WBattleGlobal:getCurrent():getMyHero():getBattleId()
    -- local wind = math.random(-100,100)
    -- if WBattleGlobal:getCurrent():getMyHero().m_nRealLevel < 10 then
    --     wind = 0
    -- elseif math.abs(wind) > 98 then
    --     wind = wind / math.abs(wind) * 6
    -- elseif math.abs(wind) > 93 then
    --     wind = wind / math.abs(wind) * 5
    -- elseif math.abs(wind) > 90 then
    --     wind = wind / math.abs(wind) * 4
    -- elseif math.abs(wind) > 80 then
    --     wind = wind / math.abs(wind) * 3
    -- elseif math.abs(wind) > 60 then
    --     wind = wind / math.abs(wind) * 2
    -- elseif math.abs(wind) > 35 then
    --     wind = wind / math.abs(wind) * 1
    -- else
    --     wind = 0
    -- end
    local myHero = WBattleGlobal:getCurrent():getMyHero()
    local currentCharacter = WBattleGlobal:getCurrent():getCurrentCharacter()
    local myTurnCount = myHero.m_nMyTurnCount
    if myTurnCount == 2 and WBattleGlobal:getCurrent():isChapterOne_ThreeTeach() and myHero:getId() == currentCharacter:getId() then 
        BattleMsgTeachStep4:_skinHelperAppear()
    end
    
    local  wind = 0
    if WBattleGlobal:getCurrent():getMyHero().m_nRealLevel >= 10 or WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_TRAIN) then
        local windWeightList = {}
        local totalWeight = 0
        local startW,endW = 0,6
        if WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_TRAIN)then
            local mapInfo = CopyTable(GDatatab_train_map["id_"..WBattleGlobal:getCurrent().m_tMakePairOk.mapId] or GDatatab_train_map["id_1011"])
            if type(mapInfo.move) == "table" then
                startW = mapInfo.move[1][1]
                endW = mapInfo.move[1][2] - mapInfo.move[1][1]
            end
        end
        for i = 0,endW - 1 do
            local weight = -500 * i + 3000 + WBattleGlobal:getCurrent():getMyHero().m_nRealLevel * 10
            if i < 3 and GlobalGame.g_nSingleCopyType == 3 then
                weight = 0
            end
            totalWeight = totalWeight + weight
            table.insert(windWeightList,weight)
        end
        local tmp = math.random(totalWeight)
        local tmpWeight = 0
        
        for i = 1,#windWeightList do
            tmpWeight = tmpWeight + windWeightList[i]
            if tmp > tmpWeight then
                wind = i
            else
                break
            end
            -- WZLog("checkWind:===",wind,i,tmp,tmpWeight)
        end

        wind = wind + startW
        WZLog("BattleMsgEndCurRound:processWithSingleMap zero",startW,endW,wind)
    end

    if WBattleGlobal:getCurrent():isWindTeach() then
        if wind == 0 or wind == 1 then
            wind = 3
        elseif wind == 2 then
            wind = 4
        elseif wind == 6 then
            wind = 5
        end
    elseif WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_TOWER) then 
        local mapInfo = CopyTable(GDatatab_tower_map["id_"..WBattleGlobal:getCurrent().m_tMakePairOk.mapId] or GDatatab_tower_map["id_40001"])
        if mapInfo.floor_num >= 191 and mapInfo.floor_num <= 200 then 
            if wind == 0 or wind == 2 or wind == 4 then 
                wind = 6
            elseif wind == 1 or wind == 3 then 
                wind = 5
            end
        end
    end
    local currentPlayerId = 0
    local attackRate = 100

    BattleCtbManager:sortCTB()

    local updateCTB_time = BattleCtbManager.m_nMinCTBTime
    local playerIds = BattleCtbManager.m_tCharaList
    local oldCTB = BattleCtbManager.m_tCharaCtbOldList
    local newCTB = BattleCtbManager.m_tCharaCtbNewList

    local playerId = #BattleCtbManager.m_tCharaList
    local hero = nil
    while playerId > 0 do
        currentPlayerId = BattleCtbManager.m_tCharaList[playerId]
        hero = WBattleGlobal:getCurrent():getCharacterWithId(currentPlayerId)
        WZLog("BattleMsgEndCurRound:processWithSingleMap one", tostring(hero:isDead()), hero.m_nFreezeCTB, hero.m_bIsInCtb)
        if hero.m_nFreezeCTB == 0 and hero:isDead() ~= true and hero.m_bIsInCtb then
            break
        else
            playerId = playerId - 1
        end
    end

    if not WBattleGlobal:getCurrent():isWindTeach() then 
        local changeCtb = math.ceil(updateCTB_time * hero:getCTBSpeed() / 1000)

        WndBattleHud.m_nWindSkillBuffTime = WndBattleHud.m_nWindSkillBuffTime - changeCtb
        if WndBattleHud.m_nWindSkillBuffTime > 0 then 
            if WndBattleHud.m_tWindConfig then 
                if self.m_sEffectType == EffectTypeConfig.DISPERSE_MONSTER_BY_TYPE and WBattleGlobal:getCurrent():isMyTeam(currentPlayerId) then 
                    wind = math.random(WndBattleHud.m_tWindConfig[1], WndBattleHud.m_tWindConfig[2])
                else
                    wind = math.random(WndBattleHud.m_tWindConfig[1], WndBattleHud.m_tWindConfig[2])
                end
            end
        else
            WndBattleHud.m_nWindSkillBuffTime = 0 
            WndBattleHud.m_nWindSkillId = 0
            WndBattleHud.m_tWindConfig = nil 
        end
    end
    if wind ~= 0 then
        wind = math.random() > 0.5 and wind or wind * -1
    end

    local tPlayerId = VectorToTable(playerIds)
    local tNowCtb = VectorToTable(oldCTB)
    local tNewCtb = VectorToTable(newCTB)
    BattleCtbManager:refreshLastCtb(tPlayerId,tNowCtb,tNewCtb,updateCTB_time)

    WZLog("ProtocolProcessorSceneBossBattle:parse_BATTLE_CanStartCurRound turn ", currentPlayerId, "\n tPlayerId=",Serialize(tPlayerId),"\n tNowCtb=", Serialize(tNowCtb), "\n tNewCtb", Serialize(tNewCtb),"\n updateCTB_time=", updateCTB_time)

    WBattleGlobal:getCurrent().m_nStartRoundTimes = WBattleGlobal:getCurrent().m_nTurnTimes + 1
    WBattleGlobal:getCurrent().m_nStartRoundPlayerId = currentPlayerId

    local randList = {[1]=math.random(9999),[2]=math.random(9999),[3]=math.random(9999),[4]=math.random(9999),[5]=math.random(9999),[6]=math.random(9999),[7]=math.random(9999),[8]=math.random(9999),[9]=math.random(9999),[10]=math.random(9999)}
    local randIndexList = GetRandomNum(10, 10)
    WBattleGlobal:getCurrent().m_tBattleRand = {}
    for i = 1, 10 do
        table.insert(WBattleGlobal:getCurrent().m_tBattleRand, randList[randIndexList[i]])
    end

    local msg = MsgManager:createMsg(BattleMsgShowCtbTime)
    msg.m_tBattleRand = WBattleGlobal:getCurrent().m_tBattleRand
    MsgManager:pushBlockMsg(msg)

    if not WBattleGlobal:getCurrent():isExpCopy() then
        local msg = MsgManager:createMsg(BattleMsgZoomToHero)
        msg.m_nPlayerId = currentPlayerId
        msg.m_nPlayerPos = hero:getAnimation():getPosition()
        --新手boss关镜头Y坐标偏移100,方便拉线
        if WBattleGlobal:getCurrent().m_tMakePairOk.mapId == 9999 then
            msg.m_nPlayerPos.y = msg.m_nPlayerPos.y - 50
        end
        msg.m_bIsFollow = true
        MsgManager:pushBlockMsg(msg)
    end

    local msg = MsgManager:createMsg(BattleMsgReadyStartRound)
    MsgManager:pushBlockMsg(msg)

    local msg = MsgManager:createMsg(BattleMsgCanStartCurRound)
    msg.m_nBattleId = battleId
    msg.m_nPlayerId = playerId
    msg.m_nCurrentPlayerId = currentPlayerId
    msg.m_nWind = wind
    msg.m_bIsCrit = 0
    msg.m_tAttackRate = attackRate
    msg.m_nIsNewRound = isNewRound
    msg.m_tBattleRand = WBattleGlobal:getCurrent().m_tBattleRand
    msg.m_nWindSkillId = WndBattleHud.m_nWindSkillId
    MsgManager:pushBlockMsg(msg)

    --录像记录
    if WBattleGlobal:getCurrent():canRecordGame() then
        local replayParam = {}
        replayParam.playerIds = playerIds
        replayParam.oldCTB = oldCTB
        replayParam.newCTB = newCTB
        replayParam.updateCTB_time = updateCTB_time
        BattleMsgReplayGameRecord:setRefreshCtb(replayParam)
    end

    --录像记录
    if WBattleGlobal:getCurrent():canRecordGame() then
        local replayParam = {}
        replayParam.m_nBattleId = battleId
        replayParam.m_nPlayerId = playerId
        replayParam.m_nCurrentPlayerId = currentPlayerId
        replayParam.m_nPlayerOrGuai = WBattleGlobal:getCurrent().m_nPlayerOrGuai
        replayParam.m_nWind = wind
        replayParam.m_bIsCrit = 0
        replayParam.m_tAttackRate = attackRate
        replayParam.m_nIsNewRound = isNewRound--WBattleGlobal:getCurrent().m_nIsNewRound
        replayParam.m_tBattleRand = WBattleGlobal:getCurrent().m_tBattleRand
        
        BattleMsgReplayGameRecord:setStartRound(replayParam)
    end

end

--@brief    回合结束，触发回合结束技能
--@note     触发回合结束职业节能
function BattleMsgEndCurRound:_isActiveHurtGrowup()
    -- body
    if not self.m_nbIsFirstMsg then
        local heroList = WBattleGlobal:getCurrent():getHeroList()
        local currentPlayerId = WBattleGlobal:getCurrent():getCurrentCharacterId()
        for i, hero in pairs(heroList) do
            if currentPlayerId == hero:getBattleId() and not hero:isDead() and hero.m_tSkillTakeEffectEndRoundList and #hero.m_tSkillTakeEffectEndRoundList > 0 then 
                for j, skillId in pairs(hero.m_tSkillTakeEffectEndRoundList) do
                    local skillData = GDatatab_skill["id_" .. skillId]
                    WMonsterAI:castSkill(nil,
                        nil,
                        nil,
                        {[1]=SkillTypeConfig.BEHIT_DO_EFFECT},
                        nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,nil,nil,nil,nil,nil,
                        nil,
                        nil,
                        nil,nil,
                        nil,nil,nil,nil,
                        nil,
                        nil,
                        skillData.effect_id[1][1], TakeEffectType.END_CUR_ROUND,
                        nil,
                        nil,
                        nil,
                        nil,
                        hero
                        )
                end
            end
        end
    end

    return true
end

--@brief    小孩射击是否完成
function BattleMsgEndCurRound:_finishKidShoot()
    if MsgManager:isInShowNonBlockMsg("BattleMsgKidShoot") then 
        return false 
    end

    return true 
end 

--@brief    灵魂分身使用技能
function BattleMsgEndCurRound:_doSoulHeroEquipSkill()
    WBattleGlobal:getCurrent():soulHeroEquipSkill()

    return true
end

--@brief    灵魂分身是否完成使用技能
function BattleMsgEndCurRound:_finishSoulHeroEquipSkill()
    if MsgManager:isInShowNonBlockMsg("BattleMsgBossMapSkill") then 
        return false 
    end

    return true 
end

--@brief    灵魂分身出手
function BattleMsgEndCurRound:_doSoulHeroShoot()
    if self.m_tShootSoulHero == nil then 
        self.m_tShootSoulHero = WBattleGlobal:getCurrent():soulHeroTakeShoot()
        if self.m_tShootSoulHero[1] then 
            self.m_tShootSoulHero[1]:soulHeroTakeShoot()
            table.remove(self.m_tShootSoulHero, 1)
            self.m_nShootGapping = 10
        end
        return false 
    end

    self.m_nShootGapping = self.m_nShootGapping - 1
    while self.m_nShootGapping < 0 do
        if self.m_tShootSoulHero[1] then 
            self.m_tShootSoulHero[1]:soulHeroTakeShoot()
            table.remove(self.m_tShootSoulHero, 1)
            self.m_nShootGapping = 10
            return false
        else
            return true 
        end
    end

    return false 
end

--@brief    灵魂分身射击是否完成
function BattleMsgEndCurRound:_finishSoulHeroShoot()
    if WBattleGlobal:getCurrent().m_tCurRoundSoulHeroShootId and #WBattleGlobal:getCurrent().m_tCurRoundSoulHeroShootId > 0 then 
        return false 
    end
    if MsgManager:isInShowNonBlockMsg("BattleMsgPlayerShoot") then 
        return false 
    end

    return true 
end

--@brief    棋圣-棋子分身出手
function BattleMsgEndCurRound:_doSubHeroShoot()
    local hero = WBattleGlobal:getCurrent():getCurrentCharacter()
    --判断玩家本回合有没有出手并使用武器技能（大招除外包括普通大招和皮肤大招）
    local useSkillId = WBattleGlobal:getCurrent():getUseWeaponSkillId()
    if not hero.m_bIsDoShoot or useSkillId == nil then 
        WZLog("BattleMsgEndCurRound:_doSubHeroShoot one")
        return true 
    end
    --如果当前回合出手的英雄已死，则不检测棋圣分身出手
    if hero:isDead() then 
        return true 
    end
    WZLog("BattleMsgEndCurRound:_doSubHeroShoot Two")
    --获取出手的白子分身
    local subHeroList = WBattleGlobal:getCurrent():getSubHero(hero:getBattleId(), CharacterSubType.SUBTYPE_BCHESS)
    if GetTableLen(subHeroList) == 0 then 
        return true 
    end
    WZLog("BattleMsgEndCurRound:_doSubHeroShoot Three")
    for id, subHero in pairs(subHeroList) do
        WBattleGlobal:getCurrent().m_nCurRoundSubHeroShootCount = WBattleGlobal:getCurrent().m_nCurRoundSubHeroShootCount + 1
        subHero:soulHeroTakeShoot()
    end

    return true  
end

--@brief    棋圣-棋子分身射击是否完成
function BattleMsgEndCurRound:_finishSubHeroShoot()
    if WBattleGlobal:getCurrent().m_nCurRoundSubHeroShootCount and WBattleGlobal:getCurrent().m_nCurRoundSubHeroShootCount > 0 then 
        return false 
    end
    if MsgManager:isInShowNonBlockMsg("BattleMsgPlayerShoot") then 
        return false 
    end

    return true 
end

--@brief    清除保留的特效
function BattleMsgEndCurRound:clearHoldEffect()
    WZLog("BattleMsgEndCurRound:clearHoldEffect")
    BattleShowHeroUse:clearHoldEffect()

    return true 
end

--@brief	消息处理完成函数
--@note		消息系统最后一次调用process函数后调用
function BattleMsgEndCurRound:done()
	WZLog("BattleMsgEndCurRound:done")
    WndBattleHud:getTargetRangeElement():setVisible(false)
    WndBattleHud:cleanBigSkillShaded()
    
    if WBattleGlobal:getCurrent():isAudience() then
        WndBattleHud:setMyHudSwitchEnable(false)
        WndBattleHud:setMyHudShow(false)
    end
end

-------------------------------------私有方法模块--------------------------------------
