--BattleMsgCanStartCurRound.lua
--@brief	战斗相关消息
--@date		2013/12/31
--@author	李俊鸿
--@note		通知角色当前操作角色时间到了

--@brief	消息数据表
BattleMsgCanStartCurRound = {
    m_sName = "BattleMsgCanStartCurRound",
	m_nBattleId = 0, --战斗id
	m_nPlayerId = 0, --角色id(发给哪个的)
	m_nCurrentPlayerId = 0, --角色id(下回和操作的角色）
	m_nPlayerOrGuai = 0, --0:player 1:guai
	m_nWind = 0, --风力（负数为坐风向，正数为右风向）
	m_bIsCrit = 0, --是否暴击(1是0否)
	m_tAttackRate = nil, --攻击力比率
	m_nIsNewRound = 0, --是否新回合(1是0否)
	m_tBattleRand = nil, --游戏随机数
    m_nTime = nil,
    m_bIsShowTurn = nil,
    m_bIsGameOver = nil,
    m_bIsEnd = nil,
    m_nWindSkillId = 0, --当前回合使用的风向药剂Id(0表示没有使用风向药剂)
}

-------------------------------------公有方法模块--------------------------------------

--@brief	消息初始化函数
--@note		消息系统第一次调用process函数前调用
function BattleMsgCanStartCurRound:init()
    WBattleGlobal:getCurrent().m_nEndCurRoundBattleId = nil
	BattleMsgCanStartCurRound.m_bIsEnd = false
    WBattleGlobal:getCurrent().m_bIsCanUseAwakeSkill = true
    --[[
    local playerId = WBattleGlobal:getCurrent():getMyBattleId()
    local beKillId = WBattleGlobal:getCurrent():getMyBattleId()
    local showKillCount = self.m_nTurnTimes % 5 + 1
    WBattleGlobal:getCurrent():showKillAni(playerId, beKillId, showKillCount)
    --]]

    --ProtocolProcessorSceneBattle:parse_BATTLE_SynchronousBattleInfoOk()

    if SceneBattle.m_bIsLostNet == true and SceneBattle.m_bIsLostNetSingleMap == 0 then
        --SceneBattle:disableSchedule()
    end

    if WBattleGlobal:getCurrent():isGameOver() then
        self.m_bIsGameOver = true
        return
    end

    local myHero = WBattleGlobal:getCurrent():getMyHero()
    if WBattleGlobal:getCurrent():isGhostStage() and myHero.m_bIsDead then 
    else
        BattleTouch:reset()
    end
    
    WBattleGlobal:getCurrent().m_nCurrentPlayerId = self.m_nCurrentPlayerId
    WBattleGlobal:getCurrent().m_nEndCurRoundBattleId = nil

    local hero = WBattleGlobal:getCurrent():getCurrentCharacter()
    WZLog("BattleMsgCanStartCurRound:init zero", tostring(hero.m_bLoseNet), WBattleGlobal:getCurrent():getMyHero():getBattleId(), self.m_nCurrentPlayerId, self.m_nPlayerOrGuai, m_nIsNewRound)

    if hero.m_bLoseNet == true then
        WBattleGlobal:getCurrent().m_nComeBackBattleId = -1
        hero.m_bLoseNet = false
        BattleCtbManager:setExit(self.m_nCurrentPlayerId, false)
        MsgBoxManager:showTipBox(string.format(LocalStrings.BATTLE_OTHER_RELINK_OK,hero.m_sPlayerName),nil,nil,nil,nil,nil,nil,nil,true)
    end

    if  not hero or hero:getHp() <= 0 or hero:isDead()  then
        if hero:getType() == 0 then
            WZLog("BattleMsgCanStartCurRound:init hero isDead",WBattleGlobal:getCurrent().m_nCurrentPlayerId,hero:isDead())
            if hero:isCanControl() then
                WZLog("BattleMsgCanStartCurRound:init ai or self end")
                WBattleGlobal:getCurrent():endCurRound(WBattleGlobal:getCurrent():getMyBattleId(),101,nil)
            else
                WZLog("BattleMsgCanStartCurRound:init common end")
                WBattleGlobal:getCurrent():endCurRound(self.m_nCurrentPlayerId,101,nil)
            end
        else
            -- if hero:isServerDead() then
                WZLog("BattleMsgCanStartCurRound:init monster isDead",WBattleGlobal:getCurrent().m_nCurrentPlayerId)
                WBattleGlobal:getCurrent():endCurRound(self.m_nCurrentPlayerId,102,nil)
            -- end
        end
        WBattleGlobal:getCurrent().m_nTurnTimes = WBattleGlobal:getCurrent().m_nTurnTimes + 1
        WBattleGlobal:getCurrent().m_nTurnTimes_Encrypt = BattleCommon:intEncrypt(WBattleGlobal:getCurrent().m_nTurnTimes)
        return
    end
	--WBattleGlobal:getCurrent():setWindLevel((WBattleGlobal:getCurrent():getTurnTimes() + 1) % 7)
    WBattleGlobal:getCurrent():setWindLevel(self.m_nWind, self.m_nWindSkillId)
	WBattleGlobal:getCurrent().m_nCurrentPlayerId = self.m_nCurrentPlayerId
	WBattleGlobal:getCurrent().m_nPlayerOrGuai = self.m_nPlayerOrGuai
	WBattleGlobal:getCurrent().m_nIsCriticalHit = 0
	WBattleGlobal:getCurrent().m_tAttackRate = self.m_tAttackRate
	WBattleGlobal:getCurrent().m_nIsNewRound = self.m_nIsNewRound
	WBattleGlobal:getCurrent().m_tBattleRand = self.m_tBattleRand
	WBattleGlobal:getCurrent():startNewRound()

    -- local myHero = WBattleGlobal:getCurrent():getMyHero()
    -- if self.m_nCurrentPlayerId == myHero:getBattleId() and not WBattleGlobal:getCurrent():isAudience() then
    --     myHero.m_nMyTurnCount = myHero.m_nMyTurnCount + 1
    -- end

	SceneBattle:getBattleLoop():setBattleStatus(BattleLoop.S_NORMAL)
   

	BattleCtbManager:updateByTurn()
    if not AutoRunBattleConst.AUTO_RUN_BATTLE and not WBattleGlobal:getCurrent():isReplayGame() then
        if GDatatab_story_talk and WndTeachTalk:IsNoExist() and WBattleGlobal:getCurrent().m_nTurnTimes <= 1 then
            for i ,v in pairs (GDatatab_story_talk) do
                if type(v.triggerWay) == "table" then
                    WZLog("BattleMsgCanStartCurRound:init one",i,v.triggerWay[1][1],v.triggerWay[1][2],v.triggerWay[1][3],WBattleGlobal:getCurrent().m_tMakePairOk.mapId, tostring(WndTeachTalk:isStoryFinish(v.storyId)), v.count == -1)
                    if v.triggerWay[1][1] == TRIGGER_BATTLE_START and (WndTeachTalk:isStoryFinish(v.storyId) ~= true or v.count == -1) and ((v.triggerWay[1][2] == COPYTYPE_SINGLE and WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_SINGLE) and v.triggerWay[1][3] == WBattleGlobal:getCurrent().m_tMakePairOk.mapId)
                    or (v.triggerWay[1][2] == COPYTYPE_DAILY and WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_DAILY) and v.triggerWay[1][3] == WBattleGlobal:getCurrent().m_tMakePairOk.mapId)
                    or (v.triggerWay[1][2] == COPYTYPE_TOWER and WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_TOWER) and v.triggerWay[1][3] == WBattleGlobal:getCurrent().m_tMakePairOk.mapId)
                    or (v.triggerWay[1][2] == 4 and WBattleGlobal:getCurrent():isSingleStage() ~= true and WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS and v.triggerWay[1][3] == WBattleGlobal:getCurrent().m_tMakePairOk.mapId)
                    ) then
                        WZLog("BattleMsgCanStartCurRound:init two")
                        CreateStoryTalkGroup(v.storyId, true)
                        break
                    end
                end
            end
        end
    end

    --使用宠物技能
    WBattleGlobal:getCurrent():petSkillUse()

    self:checkDailyPetGameStart()

    WBattleGlobal:getCurrent():doMapErosion()
    if WBattleGlobal:getCurrent().m_nTreasureRound + 1 == WBattleGlobal:getCurrent().m_nTurnTimes then
        if WBattleGlobal:getCurrent():isEscapeBattle() then
            WBattleGlobal:getCurrent():buildErosionTreasure(WBattleGlobal:getCurrent().m_tTreasureAppearList, WBattleGlobal:getCurrent().m_tTreasureCatchIdList)
        else
            WBattleGlobal:getCurrent():buildTreasure(WBattleGlobal:getCurrent().m_tTreasureAppearList, WBattleGlobal:getCurrent().m_tTreasureCatchIdList)
        end
        WBattleGlobal:getCurrent().m_tTreasureAppearList = nil
        WBattleGlobal:getCurrent().m_tTreasureCatchIdList = nil
        WBattleGlobal:getCurrent().m_nTreasureRound = -1
    end

    --WBattleGlobal:getCurrent():buildErosionTreasure(WBattleGlobal:getCurrent().m_tTreasureAppearList, WBattleGlobal:getCurrent().m_tTreasureCatchIdList)
        
    local currentCharacter = WBattleGlobal:getCurrent():getCurrentCharacter()
    currentCharacter.m_nMyTurnCount = currentCharacter.m_nMyTurnCount + 1 
    WZLog("BattleMsgCanStartCurRound init three", currentCharacter.m_nPlayerId, currentCharacter.m_nBattleId)
    if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS and WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_WORLDTEAMBOSS then
        if WBattleGlobal:getCurrent().m_tMakePairOk.guaiId[1] == currentCharacter.m_nPlayerId then
            WndWorldTeamBossInfoView:setRoundNum(currentCharacter.m_nMyTurnCount)
        end
    end
end

--@brief	消息处理过程函数
--@return	#1,nil或true表示消息处理结束，否则返回false
--@note		未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgCanStartCurRound:process()
    if self.m_bIsGameOver then
        return true
    end

    if not WBattleGlobal:getCurrent():getCurrentCharacter() or WBattleGlobal:getCurrent():getCurrentCharacter():isDead() or WBattleGlobal:getCurrent():getCurrentCharacter():getHp() <= 0 then
        return
    end

	WZLog("BattleMsgCanStartCurRound:process")

    if WBattleGlobal:getCurrent().m_bIsSchedule == false then
        return false
    end
    if not BattlePetSkillManager:isTriggerPassiveSkill() then
        return false
    end
    
    if self.m_nTime == nil and WBattleGlobal:getCurrent().m_nTurnTimes <= 1 then
        --[[
        SoundManager:playEffectSound(SoundDefine.E_S_BATTLE_START)
        GetElement(WndBattleHud.m_root,"conStart_SceneBattle",WZUIContainer):setVisible(true)

        local actionSequence = WZUIActionSequence:create()
        actionSequence:setIsLoop( false )
        local actionFadeTo1 = WZUIActionFadeTo:create()
        actionFadeTo1:setDuration( 0.5 )
        actionFadeTo1:setOpacity( 255 )
        actionSequence:setChildAction( actionFadeTo1 )
        local actionDelay = WZUIActionDelayTime:create()
        actionDelay:setDuration(0.8)
        actionSequence:setChildAction( actionDelay )
        local actionFadeTo2 = WZUIActionFadeTo:create()
        actionFadeTo2:setDuration( 0.5 )
        actionFadeTo2:setOpacity( 0 )
        actionSequence:setFinishLuaTable(self)
        actionSequence:setFinishLuaFunction("hide")
        actionSequence:setChildAction( actionFadeTo2 )

        local img = GetElement(SceneBattle.m_root,"imgStart2_SceneBattle",WZUIImage)
        img:setOpacity(0)

        local con = GetElement(SceneBattle.m_root,"conStart_SceneBattle",WZUIContainer)
        local name = "boundary"
        if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_NORMAL and WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_GZ then
            name = "gonghuizhan"
        end
        local anim = BattleAnimation:createAnimation(name,false,"battle/ui")
        self.anim = anim
        anim:getAnimNode():setOpacity(100)
        con:addChild(anim:getAnimNode(),1)
        anim:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0))
        anim:getAnimNode():setRelativePositionLuaTo(0.5,0.45)
        anim:play("animation",false)
        anim:setScale(1)
        anim:getAnimNode():runUIAction( actionSequence )
        --]]

        WZLog("BattleMsgZoomToHero 111")
        --[[
        local msg = MsgManager:createMsg(BattleMsgZoomToHero)
        msg.m_nPlayerId = self.m_nCurrentPlayerId
        local hero = WBattleGlobal:getCurrent():getCharacterWithId(msg.m_nPlayerId)
        msg.m_nPlayerPos = hero:getAnimation():getPosition()
        MsgManager:pushBlockMsg(msg)
        --]]
        self.m_nTime = 2
    elseif self.m_nTime == nil then
        self.m_nTime = 2
    elseif self.m_nTime >= 2 and self.m_bIsShowTurn ~= true then
        if self.m_nCurrentPlayerId == WBattleGlobal:getCurrent():getMyHero():getBattleId() and self.m_nCurrentPlayerId == WBattleGlobal:getCurrent():getMyHero():isDead() == true then
            self.m_nTime = self.m_nTime + SceneBattle:getBattleLoop():getBattleDeltaTime()
        else

            self.m_bIsShowTurn = true
            GetElement(WndBattleHud.m_root,"conStart_SceneBattle",WZUIContainer):setVisible(false)
            local bMyTurn = ( self.m_nCurrentPlayerId == WBattleGlobal:getCurrent():getMyHero():getBattleId() and not WBattleGlobal:getCurrent():isAudience() )
            WZLog("BattleMsgCanStartCurRound:process zero", tostring(bMyTurn), self.m_nCurrentPlayerId, WBattleGlobal:getCurrent():getMyHero():getBattleId())
            if bMyTurn == true then
                SceneBattle:playTurnShow( (self.m_nIsNewRound == 1) , bMyTurn )
            end
        end
    else
        self.m_nTime = self.m_nTime + SceneBattle:getBattleLoop():getBattleDeltaTime()
    end

	if SceneBattle:isRunningTurnShow() or self.m_nTime == nil or (self.m_nTime and self.m_nTime <= 2) then
		return false
	end
    if  self:waitForHurtNum() then
        return false
    end
    self:msgProcess()
   
    return true
end

--@brief    等待伤害数字消失
function BattleMsgCanStartCurRound:waitForHurtNum()
    if self.m_bWaitHurtCheck then
        return true
    end
    local isHurt, hurtOne = WBattleGlobal:getCurrent():IsAnyOneHurt()
    WZLog("BattleMsgCanStartCurRound:waitForHurtNum", tostring(hurtOne), tostring(not isHurt))
    return isHurt
end

--@brief
function BattleMsgCanStartCurRound:hide()
    WZLog("BattleMsgCanStartCurRound:hide")
    self.anim:getAnimNode():removeFromParentAndCleanup(true)
end

--@brief    教学
function BattleMsgCanStartCurRound:teach()
    --do return false end
    if TeachGroup1:isTeach() and TeachGroup1.ISBATTLE == true then
        local times = WBattleGlobal:getCurrent().m_nTurnTimes


        local hero = WBattleGlobal:getCurrent():getMyHero()
        local myTurnCount = hero.m_nMyTurnCount
        local mapId = WBattleGlobal:getCurrent().m_tMakePairOk.mapId

        WZLog("BattleMsgCanStartCurRound:teach one-0", times, self.m_nCurrentPlayerId, WBattleGlobal:getCurrent():getMyHero():getBattleId(), myTurnCount)

        local msg
        if mapId == 9999 or mapId == 10103 then

            WZLog("BattleMsgCanStartCurRound:teach one-1", myTurnCount)
            msg = MsgManager:createMsg(BattleMsgTeachStep4)
            if mapId == 10102 then
                if myTurnCount == 1 then
                    msg.m_nStep = 4
                end
            elseif mapId == 10103 then
                if myTurnCount == 1 then
                    msg.m_nStep = 5
                end
            elseif mapId == 9999 then
                WZLog("BattleMsgCanStartCurRound:teach one-11", myTurnCount)
                if self.m_nCurrentPlayerId == WBattleGlobal:getCurrent():getMyHero():getBattleId() then
                    if myTurnCount == 1 then
                        msg.m_nStep = 10
                    elseif myTurnCount == 2 then
                        msg.m_nStep = 11
                    elseif myTurnCount == 3 then
                        msg.m_nStep = 12
                    end
                else
                    if myTurnCount == 0 then
                        PostPlayerEvent:postTeach("0-2")
                    elseif myTurnCount == 1 then
                        msg.m_nStep = 14
                    elseif myTurnCount == 2 then
                        msg.m_nStep = 15
                    elseif myTurnCount == 3 then
                        --PostPlayerEvent:postTeach("0-13")
                    end
                end
            end
            if msg.m_nStep then
                TeachGroup1.ISBATTLE_MYTURN = true
                MsgManager:pushBlockMsg(msg)
            else
                TeachGroup1.ISBATTLE_MYTURN = false
            end
        else
            WZLog("BattleMsgCanStartCurRound:teach one-2")
            TeachGroup1.ISBATTLE_MYTURN = false
        end

        if self.m_nCurrentPlayerId == WBattleGlobal:getCurrent():getMyHero():getBattleId() and mapId == 10101 then
            msg = MsgManager:createMsg(BattleMsgTeachStep4)
            if myTurnCount == 1 then
                msg.m_nStep = 1
            elseif myTurnCount == 2 then
                msg.m_nStep = 2
            elseif myTurnCount == 3 then
                msg.m_nStep = 3
            else
                TeachGroup1.ISBATTLE_MYTURN = false
                return
            end
            if msg.m_nStep then
                TeachGroup1.ISBATTLE_MYTURN = true
                MsgManager:pushBlockMsg(msg)
            else
                TeachGroup1.ISBATTLE_MYTURN = false
            end
        end
    else
        TeachGroup1.ISBATTLE_MYTURN = false
    end
end

--@brief	消息处理完成函数
--@note		消息系统最后一次调用process函数后调用
function BattleMsgCanStartCurRound:done()
	WZLog("BattleMsgCanStartCurRound:done")
    if self.m_bIsGameOver then
        return
    end
    
    self:teach()

    BattleMsgCanStartCurRound.m_bIsEnd = true

    self:msgDone()


    local hero = WBattleGlobal:getCurrent():getCurrentCharacter()
    if hero:getType() == 0 then
        hero:addAppearAnimation()
    end
end

--@brief	消息处理函数
--@note		process函数调用
function BattleMsgCanStartCurRound:msgProcess()

        if WBattleGlobal:getCurrent():isEscapeBattle() then
            WndBattleHud:startTurnTime(15)
        else
            WndBattleHud:startTurnTime(20)
        end
        
        if WBattleGlobal:getCurrent().m_nCurrentPlayerId == WBattleGlobal:getCurrent():getMyBattleId() and not WBattleGlobal:getCurrent():isReplayGame() and not WBattleGlobal:getCurrent():isAudience() then
            WndBattleHud:setPassTurnBtnEnable(true)
            GetElement(WndBattleHud.m_root,"btnPassTurn_WndBattleHud"):setVisible(true)
        else
            WndBattleHud:setPassTurnBtnEnable(false)
            GetElement(WndBattleHud.m_root,"btnPassTurn_WndBattleHud"):setVisible(false)
        end

end

--@brief	消息处理完成函数
--@note		消息系统最后一次调用done函数时调用
function BattleMsgCanStartCurRound:msgDone()
    --WBattleGlobal:getCurrent().m_nShowNetLostTime = 5

    for i, v in pairs (WBattleGlobal:getCurrent():getCharacterList()) do
        WZLog("BattleMsgCanStartCurRound:msgDone zero", i, v:getBattleId(), v.m_sPlayerName, v:getPosition().x, v:getPosition().y, v:getAnimation():getRotate(), v:getHp())
    end

    local mapId = WBattleGlobal:getCurrent().m_tMakePairOk.mapId
    local ttf = GetElement(WndBattleHud.m_root,"txtTeach_WndBattleHud",WZUILabelTTF)
    local myHero = WBattleGlobal:getCurrent():getMyHero()
    WZLog("BattleMsgCanStartCurRound:msgDone one", WBattleGlobal:getCurrent().m_nCurrentPlayerId, myHero:getBattleId(), myHero.m_nLevel, mapId)

    --[[
    if WBattleGlobal:getCurrent().m_nCurrentPlayerId == myHero:getBattleId() and myHero.m_nLevel <= 7 and mapId ~= 10101 and mapId ~= 9999 then
        ttf:setText(TeachGroup1:getTeachText(131))
        ttf:setVisible(true)
    else
        ttf:setVisible(false)
    end
    --]]

    if TeachGroup1.ISBATTLE then
        --return
    end
    if not WBattleGlobal:getCurrent():getCurrentCharacter() or WBattleGlobal:getCurrent():getCurrentCharacter():isDead() then
        WndBattleHud:endTurnTime()
        return
    end

	local character = WBattleGlobal:getCurrent():getCurrentCharacter()
    --WZLog("BattleMsgCanStartCurRound:done ", tostring(character), tostring(character.m_nDebuffVertigoRound), tostring(character.m_nDebuffFrozenRound))
	if character == nil or (character.m_nDebuffVertigoRound == nil and (character.m_nDebuffFrozenRound == nil or character.m_nDebuffFrozenRound <= 0))  then

        WZLog("sendMsg BattleMsgEndCurRound: 9", self.m_nCurrentPlayerId, tostring(character))
		WBattleGlobal:getCurrent():setWaitNextRound(false,2)
        if not WBattleGlobal:getCurrent():isReplayGame() then
            WndBattleHud:reset(self.m_nCurrentPlayerId)
        else
            WndBattleHud:reset(-10000)
        end

        if WBattleGlobal:getCurrent():isAudience() then
            WndBattleHud:updateMySkillCtbAudience()
            WndBattleHud:resetByAudience()
        end

        if WBattleGlobal:getCurrent():isSingleStage() == false then
            local nCharaId = self.m_nCurrentPlayerId
            if nCharaId < 0 then
                WndBattleHud:endTurnTime()
            end
        end
        --ai启动
        self:checkRoundStart()
        local msg = MsgManager:createMsg(BattleMsgAiStart)
        MsgManager:pushBlockMsg(msg)
	else
		WBattleGlobal:getCurrent():setWaitNextRound(true,3)
		WndBattleHud:endTurnTime()
        WZLog("sendMsg BattleMsgEndCurRound: 8")
		local msg = MsgManager:createMsg(BattleMsgEndCurRound)
		msg.m_nBattleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
		msg.m_nPlayerId = WBattleGlobal:getCurrent():getMyBattleId()
		msg.m_nCurrentPlayerId = WBattleGlobal:getCurrent().m_nCurrentPlayerId
		msg.m_nPlayerOrGuai = character:getType()
        msg.note = 8
		MsgManager:pushBlockMsg(msg)
	end
end

function BattleMsgCanStartCurRound:checkRoundStart()
   self:checkTeamBoss7RoundStart()
   self:checkDailyPetRoundStart()
end

function BattleMsgCanStartCurRound:checkTeamBoss7RoundStart()
    local isCheck = false
    if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS then
        if math.floor(WBattleGlobal:getCurrent().m_tMakePairOk.mapId/100) == 208 then
            isCheck = true
        end
    end
    if not isCheck then
        return
    end
    local msg = MsgManager:createMsg(BattleMsgTeamBattle7Round)
    MsgManager:pushBlockMsg(msg)
end


function BattleMsgCanStartCurRound:checkDailyPetRoundStart()
    if WBattleGlobal:getCurrent():isPetCopy() then
        local msg = MsgManager:createMsg(BattleMsgDailyPetBattleRound)
        MsgManager:pushBlockMsg(msg)
    end
end

function BattleMsgCanStartCurRound:checkDailyPetGameStart()
    if WBattleGlobal:getCurrent():isPetCopy() then
        if WBattleGlobal:getCurrent().m_nTurnTimes == 1 then
            WBattleGlobal:addBuff({WBattleGlobal:getCurrent():getMyHero()},8001,WBattleGlobal:getCurrent():getMyHero():getBattleId(),0)
        end
    end
end

-------------------------------------私有方法模块--------------------------------------
