--BattleMsgGameOver.lua
--@brief	游戏结束消息
--@date		2013/1/28
--@author	Zjh
--@note

--@brief	消息数据表
BattleMsgGameOver = {
    m_sName = "BattleMsgGameOver",
	m_bShowEnd = false,		--动画播放结束标志
	m_bWin,					--是否胜利
	m_bWorldEnd = false,	--世界BOSS

	WIN_TXTIMAGE = "common/text/battle_hud_fightwin1.png",
	LOSE_TXTIMAGE = "common/text/battle_hud_fightlose1.png",
    m_firstRun = nil,
    m_aniCon = nil,
    
    m_tSettlementData = nil, --结算数据表
	m_nDatatime = 90,

    m_SendProtocolTimer = 0,
    m_SendProtocolFirstTime = 0,
    m_bIsConnect = 0,
    m_nRemainHp = 0,
    m_nStoryId = nil,
}

-------------------------------------公有方法模块--------------------------------------

--@brief	消息初始化函数
--@note		消息系统第一次调用process函数前调用
function BattleMsgGameOver:init()
	WZLog("BattleMsgGameOver:init")
    self:initData()
    self.m_SendProtocolTimer = os.time()
    self.m_SendProtocolFirstTime = self.m_SendProtocolTimer
    self.m_nHpActionTime = os.time()
end

function BattleMsgGameOver:initData()
    WZLog("BattleMsgGameOver:initData")
    g_bSingCopyOver = false
    if WBattleGlobal:getCurrent().m_nCurTimerScale then 
        CCDirector:sharedDirector():getScheduler():setTimeScale(WBattleGlobal:getCurrent().m_nCurTimerScale)
    else
        CCDirector:sharedDirector():getScheduler():setTimeScale(1)
    end
    if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS then
        self.m_nDatatime = 30
        local mapId = WBattleGlobal:getCurrent().m_tMakePairOk.mapId
        local isShowFirstRechange = TeachGroup1:isFirstRechangePushFinish("1_2")
        WZLog("BattleMsgGameOver:initData one", mapId, self.m_bWin, isShowFirstRechange)
        if TeachGroup1.ISFIRSTBATTLE then
            self.m_nDatatime = 3
        end

        if isShowFirstRechange == false and (mapId == TeachGroup1.FIRST_RECHARGE_ID_1 or mapId == TeachGroup1.FIRST_RECHARGE_ID_2 or mapId == TeachGroup1.FIRST_RECHARGE_ID_3) then
            TeachGroup1:setFirstRechangePushFinish("1_1")
        end
    else
        self.m_nDatatime = 30
    end

    WBattleGlobal:getCurrent().m_bIsWin = self.m_bWin

    if self.m_bWin then
        self:storyCheck()
    end

    self:sendSingleProcessor()

    if self.m_bWin and WBattleGlobal:getCurrent():isCopyTeach() then
        TeachGroup1:setTeachFinish(15,-1)
    end
end

--@brief 单人，日常，爬塔，副本挑战成功协议发送
function BattleMsgGameOver:sendSingleProcessor()
    if WBattleGlobal:getCurrent():isReplayGame() then
        return
    end
    -- body
    -- 单人副本
    if WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_SINGLE) then
        WZLog("BattleMsgGameOver:send single")
        local nRound = WBattleGlobal:getCurrent():getMyHero().m_nAttackRound
        local nHp = WBattleGlobal:getCurrent().m_nMyRemainHp--WBattleGlobal:getCurrent():getMyHero():getHp()
        local nMaxHp = WBattleGlobal:getCurrent():getMyHero():getMaxHp()
        local tVerify = {hp=nHp*100/nMaxHp, round=nRound }
        local mapId = WBattleGlobal:getCurrent().m_tMakePairOk.mapId
        local useSkillAndItemList = WBattleGlobal:getCurrent():getMyHero():getUseSkillAndItemList()
        if g_tSingCopyOver == nil then
            g_tSingCopyOver = {}
        end
        g_tSingCopyOver.curHp = nHp
        g_tSingCopyOver.maxHp = nMaxHp
        g_tSingCopyOver.round = nRound
        self.m_nRemainHp = nMaxHp
        g_singleCopyEndTime = os.time()
        local usedKMSkillId = WZLuaVector_int_:create()
        if useSkillAndItemList ~= nil then 
            for j = 1, #useSkillAndItemList do
                local skillData = GDatatab_skill["id_" .. useSkillAndItemList[j]]
                if skillData and (skillData.skill_type == 6 or skillData.skill_type == 7) then 
                    usedKMSkillId:push(useSkillAndItemList[j])
                end
            end
        end

        if self.m_bWin then
            local verifyData = self:_getVerifyData()
            tVerify.verify = verifyData
            if WBattleGlobal:getCurrent():isChapterOne_ThreeTeach() then 
                tVerify.verify = string.gsub(verifyData, "123456789", tostring(CacheCenter:getPlayerInfo().id))
            end
            local mapId = WBattleGlobal:getCurrent().m_tMakePairOk.mapId
            if mapId ~= 9999 then
                ProtocolProcessorSingleMap:send_SINGLEMAP_ChallengeSuccess(mapId, json.encode(tVerify), COPYTYPE_SINGLE, usedKMSkillId, 0)
            end
        else
            local verifyData = self:_getVerifyData()
            ProtocolProcessorSingleMap:send_SINGLEMAP_ChallengeSuccess(mapId, "", COPYTYPE_SINGLE, usedKMSkillId, 1)
        end
    --日常
    elseif WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_DAILY) then
        WZLog("BattleMsgGameOver:send daily")
        local useSkillAndItemList = WBattleGlobal:getCurrent():getMyHero():getUseSkillAndItemList()
        local tData = self.m_tSettlementData
        tData.expInfo = {}
        tData.expInfo.expLv = CacheCenter:getPlayerInfo().level
        tData.expInfo.exp = CacheCenter:getPlayerInfo().exp
        local usedKMSkillId = WZLuaVector_int_:create()
        if useSkillAndItemList ~= nil then 
            for j = 1, #useSkillAndItemList do
                local skillData = GDatatab_skill["id_" .. useSkillAndItemList[j]]
                if skillData and (skillData.skill_type == 6 or skillData.skill_type == 7) then 
                    usedKMSkillId:push(useSkillAndItemList[j])
                end
            end
        end
        if tData.isWin then
            local data
            local verifyData = self:_getVerifyData()
            if tData.fightId == 1 then
                -- 以下数据发服务器
                local temp = {totalhurt = tData.fightData[1] }
                temp.verify = verifyData
                data = json.encode(temp)
                
            elseif tData.fightId == 2 then
                -- 以下数据发服务器
                local temp = {killmonster1 = tData.fightData[1],killmonster2 = tData.fightData[2],killmonster3 = tData.fightData[3]}
                temp.verify = verifyData
                data = json.encode(temp)
            elseif tData.fightId == 3 then
                local temp = {totalExp = tData.fightData[1]}
                temp.verify = verifyData
                data = json.encode(temp)
            end
            ProtocolProcessorSingleMap:send_SINGLEMAP_ChallengeSuccess(tData.mapId, data, COPYTYPE_DAILY, usedKMSkillId, 0)
        else
            WBattleGlobal.getCurrent().m_bIsWin = false
            ProtocolProcessorSingleMap:send_SINGLEMAP_ChallengeSuccess(tData.mapId, "", COPYTYPE_DAILY, usedKMSkillId, 1)
        end
    --爬塔
    elseif WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_TOWER) then
        WZLog("BattleMsgGameOver:send tower")
        local data = self:_getTowerEndData()
        local towerData = GDatatab_tower_map["id_"..data.levelId]
        local curHp = data.curHpPer
        local curCnt = data.curRoundCnt
        local nMaxHp = data.maxHp
        local maxHurt = data.maxHurt
        local hitRate = data.hitRate
        local useItemTimes = data.useItemTimes
        local useSkillAndItemList = data.useSkillAndItemList
        local deadPlayerNum = data.deadPlayerNum
        local killEnemySkills = data.killEnemySkills
        local windLevelLimit = data.windLevelLimit
        local killEnemyKidSkills = data.killEnemyKidSkills
        local killMonsterNum = data.killMonsterNum

        local bWin = true

        for i = 1, 3 do
            if type(towerData["pass" .. i]) == "table" then 
                local tPass = towerData["pass" .. i][1]
                if tPass[1] == 1 then 
                    if curHp < tPass[2] then 
                        bWin = false 
                        break 
                    end
                elseif tPass[1] == 2 then 
                    if curCnt > tPass[2] then 
                        bWin = false 
                        break 
                    end
                elseif tPass[1] == 3 then 
                    if maxHurt < tPass[2] then 
                        bWin = false 
                        break 
                    end
                elseif tPass[1] == 4 then 
                    if hitRate < tPass[2] then 
                        bWin = false 
                        break 
                    end
                elseif tPass[1] == 5 then 
                    if useItemTimes >= tPass[2] then 
                        bWin = false 
                        break 
                    end
                elseif tPass[1] == 6 then 
                    if useSkillAndItemList ~= nil then 
                        for j = 1, #useSkillAndItemList do
                            local skillData = GDatatab_skill["id_" .. useSkillAndItemList[j]]
                            if skillData and skillData.skill_type ~= 6 and skillData.skill_type ~= 7 then 
                                for k = 1, #towerData["pass" .. i] do
                                    if skillData.sub_type == towerData["pass" .. i][k][2] then
                                        bWin = false 
                                        break 
                                    end
                                end
                            end
                            if not bWin then 
                                break 
                            end
                        end
                    end
                elseif tPass[1] == 7 then 
                elseif tPass[1] == 8 then 
                    local bAchie = false 
                    if killEnemySkills ~= nil then 
                        for j = 1, #killEnemySkills do
                            local skillData = GDatatab_skill["id_" .. killEnemySkills[j]]
                            if skillData then 
                                for k = 1, #towerData["pass" .. i] do
                                    if skillData.sub_type == towerData["pass" .. i][k][2] then
                                        bAchie = true 
                                        break 
                                    end
                                end
                            end
                            if bAchie then 
                                break 
                            end
                        end
                    end
                    if not bAchie then 
                        bWin = false 
                        break 
                    end
                elseif tPass[1] == 9 then 
                    local bAchie = false 
                    if killMonsterNum ~= nil then 
                        for k = 1, #towerData["pass" .. i] do
                            if killMonsterNum >= towerData["pass" .. i][k][2] then
                                bAchie = true 
                                break
                            end
                        end
                    end
                    if not bAchie then 
                        bWin = false 
                    end
                elseif tPass[1] == 10 then 
                    local bAchie = false 
                    if windLevelLimit ~= nil and windLevelLimit.min then 
                        for k = 1, #towerData["pass" .. i] do
                            if windLevelLimit.min >= towerData["pass" .. i][k][2] then
                                bAchie = true 
                                break 
                            end
                        end
                    end
                    if not bAchie then 
                        bWin = false 
                    end
                elseif tPass[1] == 11 then 
                    local bAchie = false 
                    if killEnemyKidSkills ~= nil then 
                        for j = 1, #killEnemyKidSkills do
                            local skillData = GDatatab_skill["id_" .. killEnemyKidSkills[j]]
                            if skillData then 
                                for k = 1, #towerData["pass" .. i] do
                                    if skillData.skill_type == towerData["pass" .. i][k][2] then
                                        bAchie = true 
                                        break 
                                    end
                                end
                            end
                            if bAchie then 
                                break 
                            end
                        end
                    end
                    if not bAchie then 
                        bWin = false 
                    end
                end
            end
        end
        local usedKMSkillId = WZLuaVector_int_:create()
        if useSkillAndItemList ~= nil then 
            for j = 1, #useSkillAndItemList do
                local skillData = GDatatab_skill["id_" .. useSkillAndItemList[j]]
                if skillData and (skillData.skill_type == 6 or skillData.skill_type == 7) then 
                    usedKMSkillId:push(useSkillAndItemList[j])
                end
            end
        end
        if bWin then
             WBattleGlobal.getCurrent().m_bIsWin = true
            local verifyData = self:_getVerifyData()
            local nRound = WBattleGlobal:getCurrent():getMyHero().m_nAttackRound
            local nHp = WBattleGlobal:getCurrent().m_nMyRemainHp

            local tVerify = {hp=nHp*100/nMaxHp, round=nRound, maxHurt = maxHurt, hitRate = hitRate, useItemTimes = useItemTimes, deadPlayerNum = 0}
            if useSkillAndItemList and #useSkillAndItemList > 0 then 
                tVerify.useSkillAndItemList = useSkillAndItemList
            end
            if killEnemySkills and #killEnemySkills > 0 then 
                tVerify.killEnemySkills = killEnemySkills
            end
            if windLevelLimit then 
                tVerify.windLevelLimit = windLevelLimit
            end
            if killEnemyKidSkills and #killEnemyKidSkills > 0 then 
                tVerify.killEnemyKidSkills = killEnemyKidSkills
            end
            if killMonsterNum then 
                tVerify.killMonsterNum = killMonsterNum
            end
            tVerify.verify = verifyData
            ProtocolProcessorSingleMap:send_SINGLEMAP_ChallengeSuccess(data.levelId, json.encode(tVerify), COPYTYPE_TOWER, usedKMSkillId, 0)
        else
            WBattleGlobal.getCurrent().m_bIsWin = false
            ProtocolProcessorSingleMap:send_SINGLEMAP_ChallengeSuccess(data.levelId, "", COPYTYPE_TOWER, usedKMSkillId, 1)
        end
    --英雄塔
    elseif WBattleGlobal:getCurrent():isHeroTowerStage() or WBattleGlobal:getCurrent():isHostChallengeStage() then
        WZLog("BattleMsgGameOver:send tower")
    elseif WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_TRAIN) then
        WZLog("BattleMsgGameOver:send train")
        local nRound = WBattleGlobal:getCurrent():getMyHero().m_nAttackRound
        local nHp = WBattleGlobal:getCurrent():getMyHero():getHp()
        local nMaxHp = WBattleGlobal:getCurrent():getMyHero():getMaxHp()
        local tVerify = {hp=nHp*100/nMaxHp, round=nRound }
        local mapId = WBattleGlobal:getCurrent().m_tMakePairOk.mapId
        if g_tSingCopyOver == nil then
            g_tSingCopyOver = {}
        end
        g_tSingCopyOver.curHp = nHp
        g_tSingCopyOver.maxHp = nMaxHp
        g_tSingCopyOver.round = nRound
        self.m_nRemainHp = nMaxHp
        g_tSingCopyOver.count = WndCopyFlyInfoView.m_tMapInfo.pass_count
        local usedKMSkillId = WZLuaVector_int_:create()
        if self.m_bWin then
            local verifyData = self:_getVerifyData()
            tVerify.verify = verifyData
            local mapId = WBattleGlobal:getCurrent().m_tMakePairOk.mapId

            if mapId ~= 9999 then
                ProtocolProcessorSingleMap:send_SINGLEMAP_ChallengeSuccess(mapId,
                json.encode(tVerify),
                COPYTYPE_TRAIN, usedKMSkillId, 0)
            end
        end
    end

    if WBattleGlobal:getCurrent():isSingleStage() then
        local mapId = WBattleGlobal:getCurrent().m_tMakePairOk.mapId
        if self.m_bWin then
            if mapId == 10102 then
                TeachGroup1:setTeachFinish(3,-1)
            elseif mapId == 10103 then
                TeachGroup1:setTeachFinish(6,-1)
            elseif mapId == 10104 then
                TeachGroup1:setTeachFinish(5,-1)
            elseif mapId == 10105 then
                TeachGroup1:setTeachFinish(9,-1)
            elseif mapId == 10301 then
                TeachGroup1:setTeachFinish(46,-1)
            elseif mapId == 10302 then
                TeachGroup1:setTeachFinish(47,-1)
            elseif mapId == 10206 then
                TeachGroup1:setTeachFinish(51,-1)
            elseif WBattleGlobal:getCurrent():isCopyTeach() then
                TeachGroup1:setTeachFinish(15,-1)
            end
        end
        WZLog("BattleMsgGameOver:send teach", mapId, tostring(self.m_bWin))
    end
end

--@brief	消息处理过程函数
--@return	#1,nil或true表示消息处理结束，否则返回false
--@note		未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgGameOver:process()
    if WBattleGlobal:getCurrent():isReplayGame() then
        g_bSingCopyOver = true
        if SceneBattle.m_bIsLostNetSingleMap ~= 0 then
            WZLog("BattleMsgGameOver:process lostNet1", SceneBattle.m_bIsLostNetSingleMap, BattleMsgGameOver.m_bIsConnect)
            if BattleMsgGameOver.m_bIsConnect ~= SceneBattle.m_bIsLostNetSingleMap then
                WZLog("BattleMsgGameOver:process lostNet2", SceneBattle.m_bIsLostNetSingleMap, BattleMsgGameOver.m_bIsConnect)
                BattleMsgGameOver.m_bIsConnect = SceneBattle.m_bIsLostNetSingleMap
                SceneLogin:connectCallbackByToken(CONNECTSERVER_DISCONNECT, true)
            end
            return false
        end
        if  MsgManager:isInShowBlockMsg() then
           return false
        end
        return true
    end
    
--    WZLog("BattleMsgGameOver:process zero-0", tostring(g_bSingCopyOver), tostring(WBattleGlobal:getCurrent().m_bIsSchedule))
    if TeachGroup1.ISFIRSTBATTLE ~= true and WBattleGlobal:getCurrent():isSingleStage() and g_bSingCopyOver == false and WBattleGlobal:getCurrent().m_bIsWin then
        local dt = os.time() - self.m_SendProtocolFirstTime
        if WBattleGlobal:getCurrent().m_nNetLoading == -1 and dt > 2 then
            WBattleGlobal:getCurrent().m_nNetLoading = MsgBoxManager:showLoadingBox(9999999)
        end
    end

    if SceneBattle.m_bIsLostNetSingleMap ~= 0 then
        WZLog("BattleMsgGameOver:process lostNet1", SceneBattle.m_bIsLostNetSingleMap, BattleMsgGameOver.m_bIsConnect)
        if BattleMsgGameOver.m_bIsConnect ~= SceneBattle.m_bIsLostNetSingleMap then
            WZLog("BattleMsgGameOver:process lostNet2", SceneBattle.m_bIsLostNetSingleMap, BattleMsgGameOver.m_bIsConnect)
            BattleMsgGameOver.m_bIsConnect = SceneBattle.m_bIsLostNetSingleMap
            SceneLogin:connectCallbackByToken(CONNECTSERVER_DISCONNECT, true)
        end
        return false
    end
    if TeachGroup1.ISFIRSTBATTLE ~= true and WBattleGlobal:getCurrent():isSingleStage() and g_bSingCopyOver == false and WBattleGlobal:getCurrent().m_bIsWin then
        local dt = os.time() - self.m_SendProtocolTimer
        if dt > 5 then
            self.m_SendProtocolTimer = os.time()
            self:sendSingleProcessor()
        end
        WZLog("BattleMsgGameOver:process lostNet3", dt, os.time(), self.m_SendProtocolTimer)
        return false
    end

    if TeachGroup1.ISFIRSTBATTLE ~= true and WBattleGlobal:getCurrent():isSingleStage() and WBattleGlobal:getCurrent().m_bIsWin and g_bSingCopyOver == false then
        return false
    end

    if WBattleGlobal:getCurrent().m_bIsSchedule == false then
        return false
    end

    for id, hero in pairs (WBattleGlobal:getCurrent():getCharacterList()) do
--        WZLog("BattleMsgGameOver:process zero", id, hero:getHp(), tostring(hero:isDead()))
        if hero:getHp() <= 0 and hero:isDead() ~= true then
            hero:setDead(true,10)
        end
    end

    local result = false
	local nBattleType = WBattleGlobal:getCurrent().m_nBattleType
    local nBattleMode = WBattleGlobal:getCurrent().battleMode

    local delayCheck = true
    

	if delayCheck then
		self.m_nDatatime = self.m_nDatatime - 1 
		if self.m_nDatatime <= 0 then
			result = true
		end
	end
    --怪物死亡
    if true or nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS then
        for id, hero in pairs (WBattleGlobal:getCurrent():getCharacterList())do
            if hero:getPlayerNameIcon() then
                WZLog("BattleMsgGameOver:process",id ,hero:getBattleId(), hero:getHp(), tostring(hero:getPlayerNameIcon().m_bIsHpActionDone))
                if hero:getPlayerNameIcon().m_bIsHpActionDone == false then
                    result = false
                end
            end
        end
        if os.time() - self.m_nHpActionTime > 5 then
            result = true
        end
    end

    if WBattleGlobal:getCurrent():isCopperCopy() and WBattleGlobal:getCurrent():getCopyData():getInfoView() then
        local copperInfo = WBattleGlobal:getCurrent():getCopyData():getInfoView():getLuaObjectIndex()
        WZLog("BattleMsgGameOver:process copper",copperInfo:getSceneCopperNum())
        if #MsgManager.m_tNonBlockMsgList > 1 or copperInfo:getSceneCopperNum() > 0 then
            result = false
        end
    end

    if  MsgManager:isInShowBlockMsg() then
        WZLog("BattleMsgGameOver:process blockMsg")
       result = false
    end

    if result ~= false then
        result = self:story()
    end
    return result
end

function BattleMsgGameOver:story()
    if AutoRunBattleConst.AUTO_RUN_BATTLE or WBattleGlobal:getCurrent():isReplayGame() or GlobalGame.g_bIsAutoFightOpen then
        return true
    end

    WZLog("BattleMsgGameOver:story")
    local result = nil
    if  GDatatab_story_talk and WndTeachTalk:IsNoExist() then
        if self.m_bWin then
            for i ,v in pairs (GDatatab_story_talk) do
                if type(v.triggerWay) == "table" then
--                    WZLog("BattleMsgGameOver:story one",i,v.triggerWay[1][1],v.triggerWay[1][2],v.triggerWay[1][3],WBattleGlobal:getCurrent().m_tMakePairOk.mapId, tostring(WndTeachTalk:isStoryFinish(v.storyId)))
                    if v.triggerWay[1][1] == TRIGGER_BATTLE_END and (self.m_nStoryId == nil or self.m_nStoryId ~= v.storyId)
                    and (WndTeachTalk:isStoryFinish(v.storyId) ~= true or v.count == -1) and ((v.triggerWay[1][2] == COPYTYPE_SINGLE and WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_SINGLE) and v.triggerWay[1][3] == WBattleGlobal:getCurrent().m_tMakePairOk.mapId)
                    or (v.triggerWay[1][2] == COPYTYPE_DAILY and WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_DAILY) and v.triggerWay[1][3] == WBattleGlobal:getCurrent().m_tMakePairOk.mapId)
                    or (v.triggerWay[1][2] == COPYTYPE_TOWER and WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_TOWER) and v.triggerWay[1][3] == WBattleGlobal:getCurrent().m_tMakePairOk.mapId)
                    or (v.triggerWay[1][2] == 4 and WBattleGlobal:getCurrent():isSingleStage() ~= true and WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS and v.triggerWay[1][3] == WBattleGlobal:getCurrent().m_tMakePairOk.mapId)
                    ) then
                        WZLog("BattleMsgGameOver:story two")
                        result = false
                        CreateStoryTalkGroup(v.storyId, true)
                        self.m_nStoryId = v.storyId
                        break
                    end
                end
            end
        end

        for i ,v in pairs (GDatatab_story_talk) do
            if type(v.triggerWay) == "table" then
--                WZLog("BattleMsgGameOver:story three",i,v.triggerWay[1][1],v.triggerWay[1][2],v.triggerWay[1][3],WBattleGlobal:getCurrent().m_tMakePairOk.mapId, v.storyId)
                if (v.triggerWay[1][1] == TRIGGER_BATTLE_START or (self.m_bWin and  v.triggerWay[1][1] == TRIGGER_BATTLE_END)) and ((v.triggerWay[1][2] == COPYTYPE_SINGLE and WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_SINGLE) and v.triggerWay[1][3] == WBattleGlobal:getCurrent().m_tMakePairOk.mapId)
                or (v.triggerWay[1][2] == COPYTYPE_DAILY and WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_DAILY) and v.triggerWay[1][3] == WBattleGlobal:getCurrent().m_tMakePairOk.mapId)
                or (v.triggerWay[1][2] == COPYTYPE_TOWER and WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_TOWER) and v.triggerWay[1][3] == WBattleGlobal:getCurrent().m_tMakePairOk.mapId)
                or (v.triggerWay[1][2] == 4 and WBattleGlobal:getCurrent():isSingleStage() ~= true and WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS and v.triggerWay[1][3] == WBattleGlobal:getCurrent().m_tMakePairOk.mapId)
                ) then
                    WZLog("BattleMsgGameOver:story four")
                    WndTeachTalk:setStoryFinish(v.storyId)
                end
            end
        end
    end
    return result
end

function BattleMsgGameOver:storyCheck()
    if AutoRunBattleConst.AUTO_RUN_BATTLE or WBattleGlobal:getCurrent():isReplayGame() or GlobalGame.g_bIsAutoFightOpen then
        return true
    end

    WZLog("BattleMsgGameOver:storyCheck")
    local result = nil
    if  GDatatab_story_talk and WndTeachTalk:IsNoExist() then
        if self.m_bWin then
            for i ,v in pairs (GDatatab_story_talk) do
                if type(v.triggerWay) == "table" then
                    --WZLog("BattleMsgGameOver:storyCheck one",i,v.triggerWay[1][1],v.triggerWay[1][2],v.triggerWay[1][3],WBattleGlobal:getCurrent().m_tMakePairOk.mapId, tostring(WndTeachTalk:isStoryFinish(v.storyId)))
                    if v.triggerWay[1][1] == TRIGGER_BATTLE_END and (self.m_nStoryId == nil or self.m_nStoryId ~= v.storyId)
                    and (WndTeachTalk:isStoryFinish(v.storyId) ~= true or v.count == -1) and ((v.triggerWay[1][2] == COPYTYPE_SINGLE and WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_SINGLE) and v.triggerWay[1][3] == WBattleGlobal:getCurrent().m_tMakePairOk.mapId)
                    or (v.triggerWay[1][2] == COPYTYPE_DAILY and WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_DAILY) and v.triggerWay[1][3] == WBattleGlobal:getCurrent().m_tMakePairOk.mapId)
                    or (v.triggerWay[1][2] == COPYTYPE_TOWER and WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_TOWER) and v.triggerWay[1][3] == WBattleGlobal:getCurrent().m_tMakePairOk.mapId)
                    or (v.triggerWay[1][2] == 4 and WBattleGlobal:getCurrent():isSingleStage() ~= true and WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS and v.triggerWay[1][3] == WBattleGlobal:getCurrent().m_tMakePairOk.mapId)
                    ) then
                        WZLog("BattleMsgGameOver:storyCheck two")
                        result = false
                        break
                    end
                end
            end
        end
    end

    if result == nil and TeachGroup1.ISBATTLE == nil then
        WZLog("BattleMsgGameOver:storyCheck five")
        if WBattleGlobal:getCurrent():getMyHero().m_nBoyOrGirl == 0 then
            SoundManager:playEffectSound(getSoundByType(302))
        else
            SoundManager:playEffectSound(getSoundByType(301))
        end
    end
    return result
end

--@brief	消息处理完成函数
--@note		消息系统最后一次调用process函数后调用
function BattleMsgGameOver:done()
    WndBattleHud:quitVoice()
    WndBattleHud:quitAutoFight()
    if WBattleGlobal:getCurrent():canRecordGame() then
        --录像记录
        local replayParam = {}
        replayParam.m_bWin = self.m_bWin
        replayParam.m_tSettlementData = self.m_tSettlementData or {}
        replayParam.g_tSingCopyOver = g_tSingCopyOver
        BattleMsgReplayGameRecord:setGameOver(replayParam)
    end
    if g_tSingCopyOver then
        g_tSingCopyOver.curHp = self.m_nRemainHp
    end
    if not WBattleGlobal:getCurrent():isReplayGame() and g_tSingCopyOver and g_tSingCopyOver.recordFlag == 1 then
        if WBattleGlobal:getCurrent().m_tMakePairOk.mapId == g_tSingCopyOver.pointId then
            local recordMsg = json.encode(BattleMsgReplayGameRecord.m_tSingleRecord)
            local makePairOk = BattleMsgReplayGameRecord.m_sSingleMakeOkRecord
--            WZLog("sendRecord:\n",recordMsg)
--            WZLog("sendRecordMakePairOK:\n",makePairOk)
            ProtocolProcessorSingleMap:send_SINGLEMAP_MapRecord(g_tSingCopyOver.pointId,recordMsg,makePairOk)
        else
            WZLog("BattleMsgGameOver:done error battleId",tostring(WBattleGlobal:getCurrent().m_tMakePairOk.mapId),tostring(g_tSingCopyOver.pointId))
        end
    end

	WZLog("BattleMsgGameOver:done", tostring(GlobalGame.g_tSysConfig.connectState))

    if CONNECTSERVER_FAILED == GlobalGame.g_tSysConfig.connectState or CONNECTSERVER_DISCONNECT == GlobalGame.g_tSysConfig.connectState then
        return
    end
    local nBattleType = WBattleGlobal:getCurrent().m_nBattleType
    local nBattleMode = WBattleGlobal:getCurrent().battleMode
    WZLog("BattleMsgGameOver:done", nBattleType,nBattleMode)
    --战斗结束，开启防沉迷
    GlobalMethod:YWFangchenmi(true)
    
    if WBattleGlobal:getCurrent():isSingleStage() then
        local mapId = WBattleGlobal:getCurrent().m_tMakePairOk.mapId

        WZLog("BattleMsgGameOver:done one", tostring(g_bSingCopyOver), mapId, self.m_bWin)
        local nRound = WBattleGlobal:getCurrent():getMyHero().m_nAttackRound
        local nHp = WBattleGlobal:getCurrent():getMyHero():getHp()
        local nMaxHp = WBattleGlobal:getCurrent():getMyHero():getMaxHp()
        local tVerify = {hp=nHp*100/nMaxHp, round=nRound }
        local mapId = WBattleGlobal:getCurrent().m_tMakePairOk.mapId

        WZLog("BattleMsgGameOver:done two", WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_SINGLE), tostring(self.m_bWin), tostring(g_bSingCopyOver))
        -- 单人副本
        if WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_SINGLE) then
            local tPlayerInfo = WBattleGlobal:getCurrent().m_tMakePairOk.m_tPlayerInfo
            if self.m_bWin then
                g_tSingCopyOver.playerData = tPlayerInfo
                WZLog("BattleMsgGameOver:g_tSingCopyOver",Serialize(g_tSingCopyOver))
                if g_bSingCopyOver then
                    WZLog("BattleMsgGameOver:done three")
                    WndSingleCopySettlement:showWindow(true,g_tSingCopyOver)
                else
                    g_bSingCopyOver = true

                    if TeachGroup1.ISFIRSTBATTLE then
                        g_bIsFirstBattleEnd = true
                        TeachGroup1:endFirstBattleTeach()
                    end
                end
            else
                WndSingleCopySettlement:showWindow(false,{pointId = mapId,playerData = tPlayerInfo})
            end

        -- 爬塔副本
        elseif WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_TOWER) then
            local data = self:_getTowerEndData()
            if g_tSingCopyOver ~= nil and g_tSingCopyOver.rewardId ~= nil then 
                data.rewardId = g_tSingCopyOver.rewardId
            end
            if g_tSingCopyOver ~= nil and g_tSingCopyOver.rewardCount ~= nil then 
                data.rewardCount = g_tSingCopyOver.rewardCount
            end
            
            WndTowerSettlement:showWindow(data,1)
        elseif WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_DAILY) then
             if g_tSingCopyOver ~= nil and g_tSingCopyOver.rewardId ~= nil then 
                self.m_tSettlementData.rewardId = g_tSingCopyOver.rewardId
            end
            if g_tSingCopyOver ~= nil and g_tSingCopyOver.rewardCount ~= nil then 
                self.m_tSettlementData.rewardCount = g_tSingCopyOver.rewardCount
            end
            WndDailyCopySettlement:showWindow(self.m_tSettlementData)
        elseif WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_TRAIN) then
            local tPlayerInfo = WBattleGlobal:getCurrent().m_tMakePairOk.m_tPlayerInfo
            if self.m_bWin then
                g_tSingCopyOver.playerData = tPlayerInfo
                WZLog("BattleMsgGameOver:g_tSingCopyOver five",Serialize(g_tSingCopyOver))
                if g_bSingCopyOver then
                    WZLog("BattleMsgGameOver:done six")
                    WndSingleCopySettlement:showWindow(true,g_tSingCopyOver)
                else
                    g_bSingCopyOver = true
                end
            else
                WndSingleCopySettlement:showWindow(false,{pointId = mapId,playerData = tPlayerInfo})
            end
        end

    elseif nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS and nBattleMode == BattleConstants.g_tBossBattleMode.MODE_WORLDBOSS then
        local worldBossElement = SceneWorldBoss:createElement(mapId)
        if worldBossElement ~= nil then
            replaceScene( worldBossElement )
        end
    elseif nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS and nBattleMode == BattleConstants.g_tBossBattleMode.MODE_REMAINSBOSS then
        WndRelicSettlement:showWnd( self.m_tSettlementData )
    elseif nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS and nBattleMode == BattleConstants.g_tBossBattleMode.MODE_WORLDTEAMBOSS then
        if self.m_bWin or self.m_bTimeOver then
            WndWorldBossEnd:showWnd( self.m_tSettlementData, true, 2)
        else
            WndWorldTeamBossEnd:showWindow(self.m_tSettlementData)
        end
    elseif nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS and nBattleMode == BattleConstants.g_tBossBattleMode.MODE_COUPLE_HEGEMONY then
        if self.m_bWin or self.m_bTimeOver then
            WndWorldBossEnd:showWnd( self.m_tSettlementData, true, 3)
        else
            WndCoupleHegemonyEnd:showWindow(self.m_tSettlementData)
        end
    elseif nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS and nBattleMode == BattleConstants.g_tBossBattleMode.MODE_DOUBLETOWER_STAGE then
        WndSingleCopySettlement:showWindow(self.m_bWin, self.m_tSettlementData, 1)
    elseif WBattleGlobal:getCurrent():isHostChallengeStage() then --岛主挑战
            self.m_tSettlementData.nHp = WBattleGlobal:getCurrent():getMyHero():getHp()
            self.m_tSettlementData.isWin = self.m_bWin
            self.m_tSettlementData.mapId = WBattleGlobal:getCurrent().m_tMakePairOk.mapId
            WndTowerSettlement:showWindow(self.m_tSettlementData,3)
            return 
    elseif nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS then
        local bIsWin = (WBattleGlobal:getCurrent():getHeroWithId(WBattleGlobal:getCurrent():getMyBattleId()):getCamp() == self.m_tSettlementData.winCamp)
        if bIsWin then
            WndMultiWin:showWindow(self.m_tSettlementData)
        else
            WndMultiLose:showWindow(self.m_tSettlementData)
        end
    elseif nBattleType == BattleConstants.g_nBATTLE_TYPE_NORMAL then
        local battleChannel = WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle

        if WBattleGlobal:getCurrent():isGuildWarStage() or (battleChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_LS)then
            local nWinCamp = self.m_tSettlementData.winCamp
            local nMyId = WBattleGlobal:getCurrent().m_tMakePairOk.selfId--CacheCenter:getPlayerInfo().id
            local nMyCamp = WBattleGlobal:getCurrent():getHeroWithId(nMyId):getCamp()
            WZLog("----------------arena over-------------------",nWinCamp,nMyCamp,nWinCamp == nMyCamp)
            if nWinCamp == nMyCamp then
                WZLog("----------------arena win-------------------")
                WndArenaWin:showWindow(self.m_tSettlementData)
            else
                WZLog("----------------arena lose-------------------")
                WndArenaLose:showWindow(self.m_tSettlementData)
            end
            return
        elseif WBattleGlobal:getCurrent():isHeroTowerStage() then
            local rewardId = {}
            local rewardCount = {}
            local fixed_reward = GDatatab_herotower_map["id_"..WBattleGlobal:getCurrent().m_tMakePairOk.mapId].fixed_reward
            local floorName = GDatatab_herotower_map["id_"..WBattleGlobal:getCurrent().m_tMakePairOk.mapId].name
            local floorReward = GDatatab_herotower_map["id_"..WBattleGlobal:getCurrent().m_tMakePairOk.mapId].floor_reward
            for i = 1, #fixed_reward do
                local num = math.floor(CacheCenter:getPlayerInfo().level * fixed_reward[i][2] * tonumber(CacheCenter:getGameParam().heroTowerRewardRatio)/100)
                table.insert(rewardId, fixed_reward[i][1])
                table.insert(rewardCount, num)
            end
            WZLog("isHeroTowerStageisHeroTowerStage", WBattleGlobal:getCurrent():getMyHero():getHp())
            self.m_tSettlementData.nHp = WBattleGlobal:getCurrent():getMyHero():getHp()
            self.m_tSettlementData.rewardId = rewardId
            self.m_tSettlementData.rewardCount = rewardCount
            self.m_tSettlementData.floorName = floorName
            self.m_tSettlementData.floorReward = floorReward
            WndTowerSettlement:showWindow(self.m_tSettlementData,2)
            return
        -- elseif WBattleGlobal:getCurrent():isHostChallengeStage() then
        --     local rewardId = {}
        --     local rewardCount = {}
        --     local fixed_reward = GDatatab_single_map["id_"..WBattleGlobal:getCurrent().m_tMakePairOk.mapId].fixed_reward
        --     for i = 1, #fixed_reward do
        --         local num = fixed_reward[i][2]
        --         table.insert(rewardId, fixed_reward[i][1])
        --         table.insert(rewardCount, num)
        --     end
        --     WZLog("isHostChallengeStage", WBattleGlobal:getCurrent():getMyHero():getHp())
        --     self.m_tSettlementData.nHp = WBattleGlobal:getCurrent():getMyHero():getHp()
        --     self.m_tSettlementData.rewardId = rewardId
        --     self.m_tSettlementData.rewardCount = rewardCount
        --     WndTowerSettlement:showWindow(self.m_tSettlementData,3)
        --     return 
        end

        --通用结算界面 + 排位赛
        WndArenaWinNew:showWindow(self.m_tSettlementData)
	end
end


-------------------------------------私有方法模块--------------------------------------

--@brief    获得爬塔结算数据结构
function BattleMsgGameOver:_getTowerEndData()
    if not self.m_towerEndData then
        local nRound = WBattleGlobal:getCurrent():getMyHero().m_nAttackRound
        local nHp = WBattleGlobal:getCurrent().m_nMyRemainHp--WBattleGlobal:getCurrent():getMyHero():getHp()
        local nMaxHp = WBattleGlobal:getCurrent():getMyHero():getMaxHp()
        local maxHurt = WBattleGlobal:getCurrent():getMyHero():getMaxHurt()
        local hitRate = WBattleGlobal:getCurrent():getMyHero():getHitRate()
        local useItemTimes = WBattleGlobal:getCurrent():getMyHero():getUseItemTimes()
        local useSkillAndItemList = WBattleGlobal:getCurrent():getMyHero():getUseSkillAndItemList()
        local deadPlayerNum = 0
        local killEnemySkills = WBattleGlobal:getCurrent():getMyHero():getKillEnemySkills()
        local windLevelLimit = WBattleGlobal:getCurrent():getWindLevelLimit()
        local killEnemyKidSkills = WBattleGlobal:getCurrent():getMyHero():getKillEnemyKidSkills()
        local killMonsterNum = WBattleGlobal:getCurrent():getMyHero():getMaxKillMonsterNum()

        local mapId = WBattleGlobal:getCurrent().m_tMakePairOk.mapId
        if not self.m_bWin then
            nHp = 0 
        end
        local data = {levelId = mapId, curHpPer = nHp*100/nMaxHp, curRoundCnt = nRound, maxHp = nMaxHp}
        data.curHpPer = math.floor(data.curHpPer)
        data.playerLv = CacheCenter:getPlayerInfo().level
        data.playerMaxExp =  CacheCenter:getPlayerInfo().maxExp
        data.playerExp = CacheCenter:getPlayerInfo().exp
        data.maxHurt = maxHurt
        data.hitRate = hitRate
        data.useItemTimes = useItemTimes
        data.useSkillAndItemList = useSkillAndItemList 
        data.deadPlayerNum = deadPlayerNum
        data.killEnemySkills = killEnemySkills 
        data.windLevelLimit = windLevelLimit 
        data.killEnemyKidSkills = killEnemyKidSkills 
        data.killMonsterNum = killMonsterNum 

        self.m_towerEndData = data
    end
    
    return self.m_towerEndData
end

--@brief    获得英雄塔结算数据结构
function BattleMsgGameOver:_getHeroTowerEndData()
    if not self.m_towerEndData then
        local nRound = WBattleGlobal:getCurrent():getMyHero().m_nAttackRound
        local nHp = WBattleGlobal:getCurrent().m_nMyRemainHp--WBattleGlobal:getCurrent():getMyHero():getHp()
        local nMaxHp = WBattleGlobal:getCurrent():getMyHero():getMaxHp()
        local mapId = WBattleGlobal:getCurrent().m_tMakePairOk.mapId
        if not self.m_bWin then
            nHp = 0 
        end
        local data = {levelId = mapId, curHpPer = nHp*100/nMaxHp, curRoundCnt = nRound}
        data.curHpPer = math.floor(data.curHpPer)
        data.playerLv = CacheCenter:getPlayerInfo().level
        data.playerMaxExp =  CacheCenter:getPlayerInfo().maxExp
        data.playerExp = CacheCenter:getPlayerInfo().exp
        data.nHp = nHp

        self.m_towerEndData = data
    end
    
    return self.m_towerEndData
end

--@brief    校验数据结构
--[[
战斗ID,对象ID,......|
行动者ID,
回合开始CTB;回合结束CTB;回合变动ctb,
炸弹数量1;炸弹数量2,
坑杀ID1;坑杀ID2,
战斗ID:加血:BUFF伤害:宠物伤害;战斗ID:加血:BUFF伤害:宠物伤害,
攻击者ID:受伤者ID:伤害比率:附加伤害:受伤次数:攻击伤害;攻击者ID:受伤者ID:伤害比率:附加伤害:受伤次数:攻击伤害&
行动者ID,
回合开始CTB;回合结束CTB,
炸弹数量1;炸弹数量2,
坑杀ID1;坑杀ID2,
战斗ID:加血:BUFF伤害:宠物伤害:宠物系数:攻击者ID:伤害比率:附加伤害:攻击伤害:攻击者ID:伤害比率:附加伤害:攻击伤害...;
战斗ID:加血:BUFF伤害:宠物伤害:宠物系数:攻击者ID:伤害比率:附加伤害:攻击伤害:攻击者ID:伤害比率:附加伤害:攻击伤害...
--]]
function BattleMsgGameOver:_getVerifyData()
    local data = {}
    data.monsters = WBattleGlobal:getCurrent().m_tBuildMonsterRecord
    -- data.holeMonster = WBattleGlobal:getCurrent().m_tHoleMonsterRecord
    data.records =  WBattleGlobal:getCurrent().m_tBattleRecord
    local result = ""
    local split = "|"
    local headStr = self:_getVerifyDataHeadString(data)
    local roundStr = self:_getVerifyDataRoundString(data)
    result = headStr..split..roundStr

    WZLog("BattleMsgGameOver:_getVerifyData\n",result)
    return result
end

--@brief 获得校验头字符
function BattleMsgGameOver:_getVerifyDataHeadString(data)
    local result = ""
    local split = ","
    local hero = WBattleGlobal:getCurrent():getMyHero()
    result = tostring(hero:getBattleId()) ..split.. tostring(hero:getId())
    for battleId,templateId in pairs(data.monsters) do
        result = result ..split..tostring(battleId)..split..tostring(templateId)
    end
    WZLog("BattleMsgGameOver:_getVerifyDataHeadString\n",result)
    return result
end

--@brief 获得回合校验
--round & round
function BattleMsgGameOver:_getVerifyDataRoundString(data)
    local result = ""
    local split = "&"
    function pairsByKeys(t)      
        local a = {}      
        for n in pairs(t) do          
            a[#a+1] = n      
        end      
        table.sort(a)      
        local i = 0      
        return function()          
            i = i + 1          
            return a[i], t[a[i]]      
        end  
    end

    for time,record in pairsByKeys(data.records) do 
        local str = self:_getVerifyDataOnceRoundString(time,record)
        if str ~="" then
            if result == "" then
                result = str
            else
                result = result..split..str
            end
        end
    end
    return result
end


--@brief 获得单回合校验
--[[
行动者ID,
回合开始CTB;回合结束CTB;回合变动ctb,
炸弹数量1;炸弹数量2,
坑杀ID1;坑杀ID2,
战斗ID:加血:BUFF伤害:宠物伤害:宠物系数:攻击者ID:伤害比率:附加伤害:攻击伤害:攻击者ID:伤害比率:附加伤害:攻击伤害...;
战斗ID:加血:BUFF伤害:宠物伤害:宠物系数:攻击者ID:伤害比率:附加伤害:攻击伤害:攻击者ID:伤害比率:附加伤害:攻击伤害...
...
--]]
function BattleMsgGameOver:_getVerifyDataOnceRoundString(time,record)
    local result = ""
    local split = ","
    local splitII = ";"
    local curId = record.currentPlayer
    local sCtb = record.ctbBeginRecord and math.floor(record.ctbBeginRecord) or 10000
    local eCtb = record.ctbEndRecord and math.floor(record.ctbEndRecord) or 10000
    local cCtb = record.ctbCostRecord and math.floor(record.ctbCostRecord) or 0
    -- if sCtb == eCtb then
    --     return ""
    -- end

    local atkRate = record.critRate or 0
    local atkAdd = record.addHurt or 0
    local scoreTime = record.scoreTime or 0
    local shootNum = record.bullets or 1
    local shootNumConfig = record.bulletsConfig or 1
    result = tostring(curId)..split..tostring(sCtb)..splitII..tostring(eCtb)..splitII..tostring(cCtb)..split..tostring(shootNum)..splitII..tostring(shootNumConfig)..split..
            self:_getVerifyDataRoundHoleString(time)..split..self:_getVerifyDataRoundHurtString(record)
    WZLog("BattleMsgGameOver:_getVerifyDataRoundString",time,result)
    return result
end

--@brief 获得回合坑杀结构
--id1;id2
function BattleMsgGameOver:_getVerifyDataRoundHoleString(time)
    local data = WBattleGlobal:getCurrent().m_tHoleMonsterRecord
    if not data then
        return ""
    end
    local holeList = data[time]
    if not holeList then
        return ""
    end

    local result = ""
    local split = ";"
    for i,battleId in pairs(holeList) do
        if result == "" then
            result = tostring(battleId)
        else
            result = result ..split.. tostring(battleId)
        end
    end
    
    return result
end

--@brief 获得回合伤害结构
--[[
战斗ID:加血:BUFF伤害:宠物伤害:宠物系数:宠物连击伤害:宠物连击系数:攻击者ID:伤害比率:附加伤害:攻击伤害:攻击者ID:伤害比率:附加伤害:攻击伤害:伤害半径:攻击者属性值加成...;
战斗ID:加血:BUFF伤害:宠物伤害:宠物系数:宠物连击伤害:宠物连击系数:攻击者ID:伤害比率:附加伤害:攻击伤害:攻击者ID:伤害比率:附加伤害:攻击伤害:伤害半径:攻击者属性值加成...
...
--]]
--@攻击者属性值加成：(1000+属性值) .. "_" .. addPercent .. 属性值 .. "_" .. addValue
function BattleMsgGameOver:_getVerifyDataRoundHurtString(data)
    if not data.hurtRecord then
        return ""
    end
    local heroBattleId = WBattleGlobal:getCurrent():getMyBattleId()
    local result = ""
    local split = ";"
    local splitII = ":"
    for battleId,hurtRecord in pairs(data.hurtRecord) do
        local playerAdd = hurtRecord.playerAdd or 0
        local buffHurt = hurtRecord.buffHurt or 0
        local petHurt = hurtRecord.petHurt or 0
        local petRatio = hurtRecord.petRatio or 0
        local petDoubleHurt = hurtRecord.petDoubleHurt or 0
        local petDoubleRatio = hurtRecord.petDoubleRatio or 0
        local extraHurt = hurtRecord.playerExtraHurt or 0
        if battleId == heroBattleId then
            self.m_nRemainHp = self.m_nRemainHp + playerAdd + buffHurt + petHurt + petDoubleHurt
        end
        local hurtListStr = ""
        if hurtRecord.playerHurts then
            for i,hurtInfo in pairs(hurtRecord.playerHurts) do
                local tmpHurtStr = tostring(hurtInfo.shootId)..splitII..tostring(hurtInfo.hurtRatio)..splitII..tostring(hurtInfo.hurtAdd)..splitII..tostring(hurtInfo.hurtHp)..splitII..tostring(hurtInfo.explodeRadius).. splitII..hurtInfo.hurtPropertyAdd
                if hurtListStr == "" then
                    hurtListStr = tmpHurtStr
                else
                    hurtListStr = hurtListStr..splitII..tmpHurtStr
                end

                if battleId == heroBattleId then
                    self.m_nRemainHp = self.m_nRemainHp + hurtInfo.hurtHp
                    --胜利才发送报告，不用考虑怪物打死玩家情况
                    if self.m_nRemainHp < 1 then
                        self.m_nRemainHp = 1
                    end
                end
            end
        end
        local str = tostring(battleId)..splitII..tostring(playerAdd)..splitII..tostring(buffHurt + extraHurt)..splitII..tostring(petHurt)..splitII..tostring(petRatio)..splitII..tostring(petDoubleHurt)..splitII..tostring(petDoubleRatio)..splitII..hurtListStr
        if result == "" then
            result = str
        else
            result = result ..split..str
        end
    end
    return result
end


--@brief	播放结束动画
function BattleMsgGameOver:_showAction()
	if self.m_bWin then
		self.m_aniCon = CreateCelebrateWithColorBarAnimation(BattleMsgGameOver.WIN_TXTIMAGE,SceneBattle:getTopInfoLayer(),self,"_showActionEnd")
	else
		self.m_aniCon = CreateCelebrateWithColorBarAnimation(BattleMsgGameOver.LOSE_TXTIMAGE,SceneBattle:getTopInfoLayer(),self,"_showActionEnd",true)
	end
end


function BattleMsgGameOver:_showActionEnd()
	self.m_bShowEnd = true
    self.m_aniCon:removeFromParentAndCleanup(true)
end
