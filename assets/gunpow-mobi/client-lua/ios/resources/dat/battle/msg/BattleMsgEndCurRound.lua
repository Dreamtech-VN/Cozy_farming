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
}

-------------------------------------公有方法模块--------------------------------------

--@brief	消息初始化函数
--@note		消息系统第一次调用process函数前调用
function BattleMsgEndCurRound:init()
	WZLog("BattleMsgEndCurRound:init", tostring(self.note), tostring(WBattleGlobal:getCurrent():isCurTurnHaveSendEndMsg()), self.m_nPlayerId, self.m_nCurrentPlayerId)
    WBattleGlobal:getCurrent().m_bIsCanUseAwakeSkill = false
    if WBattleGlobal:getCurrent():isCurTurnHaveSendEndMsg() == true then
        return
    end
	WBattleGlobal:getCurrent():setWaitNextRound(true,4)
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
        "\n battleInfo:", type(battleInfo), battleInfo)

    ProtocolProcessorBattleInterface:send_BATTLE_SendCurRoundInfo(self.m_nBattleId, roundCount,playerIds, postionX, postionY, angle, face, explodePlayerId, explodeSkillId, explodePosX, explodePosY, battleInfo)
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
            local tItemData = GDatatab_skill["id_" .. WndBattleHud.m_nWindSkillId]
            if tItemData then 
                local tEffectData = GDatatab_effect["id_" .. tItemData.effect_id[1][1]]
                wind = math.random(tEffectData.effect[1][5], tEffectData.effect[1][6])
            end
        else
            WndBattleHud.m_nWindSkillBuffTime = 0 
            WndBattleHud.m_nWindSkillId = 0
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

--@brief	消息处理完成函数
--@note		消息系统最后一次调用process函数后调用
function BattleMsgEndCurRound:done()
	WZLog("BattleMsgEndCurRound:done")
    if WBattleGlobal:getCurrent():isAudience() then
        WndBattleHud:setMyHudSwitchEnable(false)
        WndBattleHud:setMyHudShow(false)
    end
end

-------------------------------------私有方法模块--------------------------------------
