--ProtocolProcessorSceneQualifying.lua
--@brief	排位赛相关协议
--@date  	2015-11-13
--@author 	binshao
--@note 	排位赛相关协议


ProtocolProcessorSceneQualifying = ProtocolProcessorBase:new()

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorSceneQualifying:regAll()
    --@brief	战绩日志成功
    self:regProtocolCallbackFunction( Protocol.MAIN_RANKMATCH, Protocol.RANKMATCH_GetLogOK, "ProtocolProcessorSceneQualifying:parse_RANKMATCH_GetLogOK", "vtvivivivs")
    --@brief	膜拜成功
    self:regProtocolCallbackFunction( Protocol.MAIN_RANKMATCH, Protocol.RANKMATCH_WorshipOK, "ProtocolProcessorSceneQualifying:parse_RANKMATCH_WorshipOK", "")
    --@brief	膜拜日志成功
    self:regProtocolCallbackFunction( Protocol.MAIN_RANKMATCH, Protocol.RANKMATCH_GetWorshipLogOK, "ProtocolProcessorSceneQualifying:parse_RANKMATCH_GetWorshipLogOK", "vsviviiit")
    --@brief	领取膜拜金币成功
    self:regProtocolCallbackFunction( Protocol.MAIN_RANKMATCH, Protocol.RANKMATCH_GetWorshipGoldOK, "ProtocolProcessorSceneQualifying:parse_RANKMATCH_GetWorshipGoldOK", "")
    --@brief	主城雕像形象成功
    self:regProtocolCallbackFunction( Protocol.MAIN_RANKMATCH, Protocol.RANKMATCH_GetStatueInfoOK, "ProtocolProcessorSceneQualifying:parse_RANKMATCH_GetStatueInfoOK", "isiiiitii")
    --@brief	排位等级提升 (RANKMATCH_SegmentUp = 24）
    self:regProtocolCallbackFunction( Protocol.MAIN_RANKMATCH, Protocol.RANKMATCH_SegmentUp, "ProtocolProcessorSceneQualifying:parse_RANKMATCH_SegmentUp", "ii")
    --@brief	主城雕像形象 (RANKMATCH_GetPlayerInfoOK = 28）
    self:regProtocolCallbackFunction( Protocol.MAIN_RANKMATCH, Protocol.RANKMATCH_GetPlayerInfoOK, "ProtocolProcessorSceneQualifying:parse_RANKMATCH_GetPlayerInfoOK", "isiiiitisiii")
    --@brief	随机配对成功同步对战玩家数据
    self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_MakePairOk, "ProtocolProcessorSceneQualifying:parse_ROOM_MakePairOk", "iiiiiivivivsvsvsvsvivivivivivivivivivivivivivivivivivivivivivivivivsvivivsvivivivivivivivsvsvnvivivbvii")
    --@brief	打开宝箱成功 (RANKMATCH_OpenBoxOK = 34）
    self:regProtocolCallbackFunction( Protocol.MAIN_RANKMATCH, Protocol.RANKMATCH_OpenBoxOK, "ProtocolProcessorSceneQualifying:parse_RANKMATCH_OpenBoxOK", "")
    --@brief	战斗结算(RANKMATCH_RMGameOver = 31）
    self:regProtocolCallbackFunction( Protocol.MAIN_RANKMATCH, Protocol.RANKMATCH_RMGameOver , "ProtocolProcessorSceneQualifying:parse_RANKMATCH_RMGameOver ", "vivivsvivivivivivivivivi")
    --@brief	段位情况(RANKMATCH_UpSegment = 32）
    self:regProtocolCallbackFunction( Protocol.MAIN_RANKMATCH, Protocol.RANKMATCH_UpSegment , "ProtocolProcessorSceneQualifying:parse_RANKMATCH_UpSegment ", "ii")
    --@brief	上周排行 (RANKMATCH_HistoryRankOK = 37）
    self:regProtocolCallbackFunction( Protocol.MAIN_RANKMATCH, Protocol.RANKMATCH_HistoryRankOK, "ProtocolProcessorSceneQualifying:parse_RANKMATCH_HistoryRankOK", "vivsvtvivivnvivivivivivivivi")


    -- error
    --@brief	战绩日志错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_RANKMATCH, Protocol.RANKMATCH_GetLog, "ProtocolProcessorSceneQualifying:send_RANKMATCH_GetLog_ErrorProcess", "is" )
    --@brief	排位赛排行榜错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_RANKMATCH, Protocol.RANKMATCH_GetRank, "ProtocolProcessorSceneQualifying:send_RANKMATCH_GetRank_ErrorProcess", "is" )
    --@brief	膜拜错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_RANKMATCH, Protocol.RANKMATCH_Worship, "ProtocolProcessorSceneQualifying:send_RANKMATCH_Worship_ErrorProcess", "is" )
    --@brief	膜拜日志错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_RANKMATCH, Protocol.RANKMATCH_GetWorshipLog, "ProtocolProcessorSceneQualifying:send_RANKMATCH_GetWorshipLog_ErrorProcess", "is" )
    --@brief	领取膜拜金币错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_RANKMATCH, Protocol.RANKMATCH_GetWorshipGold, "ProtocolProcessorSceneQualifying:send_RANKMATCH_GetWorshipGold_ErrorProcess", "is" )
    --@brief	主城雕像形象错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_RANKMATCH, Protocol.RANKMATCH_GetStatueInfo, "ProtocolProcessorSceneQualifying:send_RANKMATCH_GetStatueInfo_ErrorProcess", "is" )
    --@brief	开始挑战（RANKMATCH_Start = 25）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_RANKMATCH, Protocol.RANKMATCH_Start, "ProtocolProcessorSceneQualifying:send_RANKMATCH_Start_ErrorProcess", "is" )
    --@brief	冠军形象（RANKMATCH_GetPlayerInfo = 27）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_RANKMATCH, Protocol.RANKMATCH_GetPlayerInfo, "ProtocolProcessorSceneQualifying:send_RANKMATCH_GetPlayerInfo_ErrorProcess", "is" )
    --@brief	打开宝箱（RANKMATCH_OpenBox = 33）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_RANKMATCH, Protocol.RANKMATCH_OpenBox, "ProtocolProcessorSceneQualifying:send_RANKMATCH_OpenBox_ErrorProcess", "is" )
    --@brief	结束匹配（RANKMATCH_End = 35）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_RANKMATCH, Protocol.RANKMATCH_End, "ProtocolProcessorSceneQualifying:send_RANKMATCH_End_ErrorProcess", "is" )
    --@brief	上周排行（RANKMATCH_HistoryRank = 36）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_RANKMATCH, Protocol.RANKMATCH_HistoryRank, "ProtocolProcessorSceneQualifying:send_RANKMATCH_HistoryRank_ErrorProcess", "is" )
end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorSceneQualifying:unregAll()
	self:clearReg()
end

--------------------------------------------------send------------------------------------------------------------------
--@brief	战绩日志
function ProtocolProcessorSceneQualifying:send_RANKMATCH_GetLog( )
    WZLog("send_RANKMATCH_GetLog")
    local sender = Protocol:getSender( Protocol.MAIN_RANKMATCH, Protocol.RANKMATCH_GetLog )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief	排位赛排行榜
function ProtocolProcessorSceneQualifying:send_RANKMATCH_GetRank( )
    WZLog("send_RANKMATCH_GetRank")
    local sender = Protocol:getSender( Protocol.MAIN_RANKMATCH, Protocol.RANKMATCH_GetRank )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief	膜拜
function ProtocolProcessorSceneQualifying:send_RANKMATCH_Worship( )
    WZLog("send_RANKMATCH_Worship")
    local sender = Protocol:getSender( Protocol.MAIN_RANKMATCH, Protocol.RANKMATCH_Worship )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief	膜拜日志
function ProtocolProcessorSceneQualifying:send_RANKMATCH_GetWorshipLog( )
    WZLog("send_RANKMATCH_GetWorshipLog")
    local sender = Protocol:getSender( Protocol.MAIN_RANKMATCH, Protocol.RANKMATCH_GetWorshipLog )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief	领取膜拜金币
function ProtocolProcessorSceneQualifying:send_RANKMATCH_GetWorshipGold( )
    WZLog("send_RANKMATCH_GetWorshipGold")
    local sender = Protocol:getSender( Protocol.MAIN_RANKMATCH, Protocol.RANKMATCH_GetWorshipGold )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief	主城雕像形象
function ProtocolProcessorSceneQualifying:send_RANKMATCH_GetStatueInfo( )
    WZLog("send_RANKMATCH_GetStatueInfo")
    local sender = Protocol:getSender( Protocol.MAIN_RANKMATCH, Protocol.RANKMATCH_GetStatueInfo )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief	开始挑战（RANKMATCH_Start = 25）
function ProtocolProcessorSceneQualifying:send_RANKMATCH_Start( )
    WZLog("send_RANKMATCH_Start")
    local sender = Protocol:getSender( Protocol.MAIN_RANKMATCH, Protocol.RANKMATCH_Start )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief	冠军形象（RANKMATCH_GetPlayerInfo = 27）
function ProtocolProcessorSceneQualifying:send_RANKMATCH_GetPlayerInfo( )
    WZLog("send_RANKMATCH_GetPlayerInfo")
    local sender = Protocol:getSender( Protocol.MAIN_RANKMATCH, Protocol.RANKMATCH_GetPlayerInfo )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief	打开宝箱（RANKMATCH_OpenBox = 33）
function ProtocolProcessorSceneQualifying:send_RANKMATCH_OpenBox(boxId,boxType )
    WZLog("send_RANKMATCH_OpenBox")
    local sender = Protocol:getSender( Protocol.MAIN_RANKMATCH, Protocol.RANKMATCH_OpenBox )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( boxId )	-- 宝箱id
    sender:writeInt( boxType )	-- 类型（1为每日宝箱，2为每周宝箱）
    SendProtocol(sender,false) --true:showLoading
end

--@brief	结束匹配（RANKMATCH_End = 35）
function ProtocolProcessorSceneQualifying:send_RANKMATCH_End( )
    WZLog("send_RANKMATCH_End")
    local sender = Protocol:getSender( Protocol.MAIN_RANKMATCH, Protocol.RANKMATCH_End )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief	上周排行（RANKMATCH_HistoryRank = 36）
function ProtocolProcessorSceneQualifying:send_RANKMATCH_HistoryRank( )
    WZLog("send_RANKMATCH_HistoryRank")
    local sender = Protocol:getSender( Protocol.MAIN_RANKMATCH, Protocol.RANKMATCH_HistoryRank )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

-------------------------------------------------receive ok-------------------------------------------------------------
--@brief	副本随机配对成功同步对战玩家数据
function ProtocolProcessorSceneQualifying:parse_ROOM_MakePairOk(battleId,battleMode, battleChannle,schedule,mapId, playerCount, playerCamp,playerId, serverId, playerName, playerTitle, playerCommunity, playerLevel, playerSex, maxHP, maxPF, maxSP, attack, critRate, defence, injuryFree, wreckDefense, reduceCrit, power, armor, constitution, agility, lucky, winRate, fighting, headId, faceId, bodyId, weaponId, wingId, item_id, petSkill, playerBuffCount, buffId, petId, petParam, battleTimes, winTimes, streakTimes, segmentLevel,tournamentLevel,teamId,teamName,url,petLevel, colour, bodyColour,isCaptain,footmark, monsterId)
    WZLog("ProtocolProcessorSceneQualifying:parse_ROOM_MakePairOk",battleMode, battleChannle,schedule)

    WZLog("ProtocolProcessorSceneQualifying:parse_ROOM_MakePairOk two","\n\nbattleId", serverId,

    Serialize(VectorToTable(battleId)),Serialize(VectorToTable(battleMode)),Serialize(VectorToTable(mapId)),Serialize(VectorToTable(playerCount)),Serialize(VectorToTable(playerCamp)),Serialize(VectorToTable(playerId)),Serialize(VectorToTable(playerName)),Serialize(VectorToTable(playerTitle)),Serialize(VectorToTable(playerCommunity)),"\n\nplayerLevel",

    Serialize(VectorToTable(playerLevel)),Serialize(VectorToTable(playerSex)),Serialize(VectorToTable(maxHP)),Serialize(VectorToTable(maxPF)),Serialize(VectorToTable(maxSP)),Serialize(VectorToTable(attack)),Serialize(VectorToTable(critRate)),Serialize(VectorToTable(defence)),Serialize(VectorToTable(injuryFree)),"\n\nwreckDefense",

    Serialize(VectorToTable(wreckDefense)),Serialize(VectorToTable(reduceCrit)),Serialize(VectorToTable(power)),Serialize(VectorToTable(armor)),Serialize(VectorToTable(constitution)),Serialize(VectorToTable(agility)),Serialize(VectorToTable(lucky)),"\n\nheadId",

    Serialize(VectorToTable(headId)),Serialize(VectorToTable(faceId)),Serialize(VectorToTable(bodyId)),Serialize(VectorToTable(weaponId)),Serialize(VectorToTable(wingId)),Serialize(VectorToTable(item_id)),Serialize(VectorToTable(playerBuffCount)),Serialize(VectorToTable(buffId)),"\n\npetId",

    Serialize(VectorToTable(petId)),Serialize(VectorToTable(petParam)),Serialize(VectorToTable(tournamentLevel)))


    ProtocolProcessorSceneQualifying:receiveMakePairOk(VectorToTable(battleId), VectorToTable(battleMode), battleChannle, schedule,VectorToTable(mapId), VectorToTable(playerCount), VectorToTable(playerCamp), VectorToTable(playerId), VectorToTable(serverId), VectorToTable(playerName), VectorToTable(playerTitle), VectorToTable(playerCommunity), VectorToTable(playerLevel), VectorToTable(playerSex), VectorToTable(maxHP), VectorToTable(maxPF), VectorToTable(maxSP), VectorToTable(attack), VectorToTable(critRate), VectorToTable(defence), VectorToTable(injuryFree), VectorToTable(wreckDefense), VectorToTable(reduceCrit), VectorToTable(power), VectorToTable(armor), VectorToTable(constitution), VectorToTable(agility), VectorToTable(lucky), VectorToTable(winRate), VectorToTable(fighting), VectorToTable(headId), VectorToTable(faceId), VectorToTable(bodyId), VectorToTable(weaponId), VectorToTable(wingId), VectorToTable(item_id), VectorToTable(playerBuffCount), VectorToTable(buffId), VectorToTable(petId), VectorToTable(petSkill), VectorToTable(petParam), VectorToTable(battleTimes), VectorToTable(winTimes), VectorToTable(streakTimes), VectorToTable(segmentLevel), VectorToTable(weaponSkill), VectorToTable(tournamentLevel),VectorToTable(teamId),VectorToTable(teamName),VectorToTable(url),VectorToTable(petLevel),VectorToTable(colour),VectorToTable(bodyColour),VectorToTable(isCaptain),VectorToTable(footmark), monsterId)

end

--@brief	副本随机配对成功同步对战玩家数据
function ProtocolProcessorSceneQualifying:receiveMakePairOk(battleId,battleMode, battleChannle,schedule,mapId, playerCount, playerCamp,playerId,serverId, playerName, playerTitle, playerCommunity, playerLevel, playerSex, maxHP, maxPF, maxSP, attack, critRate, defence, injuryFree, wreckDefense, reduceCrit, power, armor, constitution, agility, lucky, winRate, fighting, headId, faceId, bodyId, weaponId, wingId, item_id, playerBuffCount, buffId, petId, petSkill, petParam, battleTimes, winTimes, streakTimes, segmentLevel, weaponSkill,tournamentLevel,teamId,teamName,url,petLevel, colour, bodyColour, isCaptain,footmark, monsterId)
    WBattleGlobal:getCurrent():destroy()
    WBattleGlobal:getCurrent().m_tMakePairOk = {
    battleId=battleId,battleMode=battleMode,battleChannle=battleChannle,schedule=schedule,mapId=mapId,playerCount=playerCount,playerCamp=playerCamp,playerId=playerId,serverId=serverId,playerName=playerName,

    playerTitle=playerTitle,playerCommunity=playerCommunity,playerLevel=playerLevel,playerSex=playerSex,maxHP=maxHP,maxPF=maxPF,maxSP=maxSP,attack=attack,

    critRate=critRate,defence=defence,injuryFree=injuryFree,wreckDefense=wreckDefense,reduceCrit=reduceCrit,reduceBury=reduceBury,power=power,armor=armor,

    constitution=constitution,agility=agility,lucky=lucky,winRate=winRate,fighting=fighting,headId=headId,faceId=faceId,bodyId=bodyId,weaponId=weaponId,wingId=wingId,item_id=item_id,

    playerBuffCount=playerBuffCount,buffId=buffId,petId=petId,petSkill=petSkill,petLevel=petLevel,petSkillId=petId,petParam=petParam,guaiBattleId=guaiBattleId,guaiId=guaiId,battleTimes=battleTimes,winTimes=winTimes,streakTimes=streakTimes,segmentLevel=segmentLevel,weaponSkill=weaponSkill,tournamentLevel=tournamentLevel,
    teamId =teamId,teamName=teamName,url=url, colour=colour, bodyColour=bodyColour,isCaptain=isCaptain,footmark = footmark, monsterId = monsterId}

    WBattleGlobal:getCurrent().m_nBattleType = BattleConstants.g_nBATTLE_TYPE_NORMAL
    WBattleGlobal:getCurrent().m_nServiceMode = 0

    WZLog("ProtocolProcessorSceneQualifying:receiveMakePairOk", type(battleTimes), type(winTimes),type(streakTimes),type(segmentLevel))

    replaceScene(SceneBattleLoading:createElement())

end

--@brief	战绩日志成功
function ProtocolProcessorSceneQualifying:parse_RANKMATCH_GetLogOK(logType, createDate, score, segmentLevel, opponentName)
    --    logType	byte[]	日志类型,1、胜利，2、失败，3、晋级,4、降级
    --    createDate	int[]	创建日期（秒）时间戳
    --    score	int[]	积分
    --    segmentLevel	int[]	段位等级
    --    opponentName	String[]	对手名称
    WZLog("ProtocolProcessorSceneQualifying:parse_RANKMATCH_GetLogOK")
    local data = {logType = VectorToTable(logType),createDate = VectorToTable(createDate),score = VectorToTable(score),segmentLevel = VectorToTable(segmentLevel),opponentName = VectorToTable(opponentName),}
    WndPvpRankLog:setData(data)
end

--@brief	膜拜成功
function ProtocolProcessorSceneQualifying:parse_RANKMATCH_WorshipOK()
    WZLog("ProtocolProcessorSceneQualifying:parse_RANKMATCH_WorshipOK")
    local power = CacheCenter:getGameParam().matchRankWorshipVigor
    MsgBoxManager:showTipBox(string.format(LocalStrings.WORSHIP_SUCCESS,power), nil, nil, nil, nil)
    ProtocolProcessorSceneQualifying:send_RANKMATCH_GetWorshipLog( )
end


--@brief	膜拜日志成功
function ProtocolProcessorSceneQualifying:parse_RANKMATCH_GetWorshipLogOK(playerName, serverId, worshipDate, times, gold,worshipState)
    -- playerName : 膜拜者名称
    -- worshipDate : 膜拜时间
    -- times : 膜拜次数
    -- gold : 膜拜可以被领取金币
    WZLog("ProtocolProcessorSceneQualifying:parse_RANKMATCH_GetWorshipLogOK")
    local log = {playerName = VectorToTable(playerName), serverId = VectorToTable(serverId), worshipDate = VectorToTable(worshipDate) , times = times, gold = gold ,worshipState = worshipState}
    WndPvpRankKing:setLogData(log)
end

--@brief	领取膜拜金币成功
function ProtocolProcessorSceneQualifying:parse_RANKMATCH_GetWorshipGoldOK()
    MsgBoxManager:showTipBox(LocalStrings.GET_WORSHIP_GOLD, nil, nil, nil, nil)
    WZLog("ProtocolProcessorSceneQualifying:parse_RANKMATCH_GetWorshipGoldOK")
end

--@brief	主城雕像形象成功
function ProtocolProcessorSceneQualifying:parse_RANKMATCH_GetStatueInfoOK(playerId, playerName, playerHeadId, playerFaceId, playerBodyId, playerWingId, playerSex, colour, bodyColour)
    -- playerId : 玩家id
    -- playerName : 玩家名称
    -- playerHeadId : 头
    -- playerFaceId : 脸
    -- playerBodyId : 身
    -- playerWingId : 翅膀
    -- playerSex : 性别
    WZLog("ProtocolProcessorSceneQualifying:parse_RANKMATCH_GetStatueInfoOK", type(GlobalMethod:crossServiceOpen()), GlobalMethod:crossServiceOpen(),playerId, playerName, colour, bodyColour, playerHeadId, playerFaceId, playerBodyId, playerWingId, playerSex)

    if playerId ~= 0 and GlobalMethod:crossServiceOpen() ~= 0 then
        local info = {playerId = playerId, playerName = playerName, playerSex = playerSex, headId = playerHeadId, faceId = playerFaceId, bodyId = playerBodyId, wingId = playerWingId, playerTitle="", mountsId=0, colour=colour, bodyColour=bodyColour}
        if SceneCity.m_root then
            FigureSceneManager:getInstance():createOtherFigures({info}, true)
        end
    end
end

--@brief	排位等级提升 (RANKMATCH_SegmentUp = 24）
function ProtocolProcessorSceneQualifying:parse_RANKMATCH_SegmentUp(segmentId, result)
    -- segmentId : 玩家段位id
    -- result : 0、升级，1、降级
    WZLog("ProtocolProcessorSceneQualifying:parse_RANKMATCH_SegmentUp")
end


--@brief	主城雕像形象 (RANKMATCH_GetPlayerInfoOK = 28）
function ProtocolProcessorSceneQualifying:parse_RANKMATCH_GetPlayerInfoOK(playerId, playerName, playerHeadId, playerFaceId, playerBodyId, playerWingId, playerSex, playerLevel, petMessage, fighting,headColour,bodyColour)
    -- playerId : 玩家id，不存在为0
    -- playerName : 玩家名称，不存在为""
    -- playerHeadId : 头,不存在为0
    -- playerFaceId : 脸，不存在为0
    -- playerBodyId : 身，不存在为0
    -- playerWingId : 翅膀，不存在为0
    -- playerSex : 玩家性别
    -- playerLevel : 等级
    -- petMessage : 宠物信息json结构
    -- fighting : 战斗力
    WZLog("ProtocolProcessorSceneQualifying:parse_RANKMATCH_GetPlayerInfoOK")
    local info = {playerId = playerId, playerName = playerName, playerHeadId = playerHeadId, playerFaceId = playerFaceId,
        playerBodyId = playerBodyId, playerWingId = playerWingId, playerSex = playerSex, playerLevel = playerLevel,
        petMessage = petMessage, fighting = fighting,headColour = headColour,bodyColour = bodyColour}
    WndPvpRankKing:setPlayerInfo(info)
end

--@brief	打开宝箱成功 (RANKMATCH_OpenBoxOK = 34）
function ProtocolProcessorSceneQualifying:parse_RANKMATCH_OpenBoxOK()
    WZLog("ProtocolProcessorSceneQualifying:parse_RANKMATCH_OpenBoxOK")
    if WndPvpDayReward.m_root then
        WndPvpDayReward:updateGetRewardState()
    elseif WndPvpRankList.m_root then
        WndPvpRankList:updateGetRewardState()
    end
end

--@brief	战斗结算(RANKMATCH_RMGameOver = 31）
function ProtocolProcessorSceneQualifying:parse_RANKMATCH_RMGameOver (playerId,playerLevel,playerName,segmentLevel,segmentExp,
            dayBattleTimes, dayWinTimes, dayWinStreak, score, isStreak, isCheck, result)
    -- playerId : 玩家ID
    -- dayBattleTimes : 当天战斗次数
    -- dayWinTimes : 当天胜利次数
    -- dayWinStreak : 当前最高连胜次数
    -- score : 获得积分
    -- isStreak : 连胜加成1、连胜，0、没有连胜
    -- isCheck : 阻击连胜1、阻击连胜，0、没有阻击连胜
    -- result : 战斗结果，1、胜利，0、失败
    WZLog("ProtocolProcessorSceneQualifying:parse_RANKMATCH_RMGameOver ")
    local playerId = VectorToTable(playerId)
    local playerLevel = VectorToTable(playerLevel)
    local playerName = VectorToTable(playerName)
    local segmentLevel = VectorToTable(segmentLevel)
    local segmentExp = VectorToTable(segmentExp)
    local dayBattleTimes = VectorToTable(dayBattleTimes)
    local dayWinTimes = VectorToTable(dayWinTimes)
    local dayWinStreak = VectorToTable(dayWinStreak)
    local score = VectorToTable(score)
    local isStreak = VectorToTable(isStreak)
    local isCheck = VectorToTable(isCheck)
    local result = VectorToTable(result)
    local data = {}
    for i = 1, #playerId do
        local info = {playerId = playerId[i], playerLevel = playerLevel[i],playerName = playerName[i],
            segmentLevel = segmentLevel[i], segmentExp = segmentExp[i],dayBattleTimes = dayBattleTimes[i],
            dayWinTimes = dayWinTimes[i],dayWinStreak = dayWinStreak[i],score = score[i],
            isStreak = isStreak[i], isCheck = isCheck[i], result = result[i] }
        table.insert(data,info)
    end
    WndPvpRankResult:ShowWndUI(data)
end

--@brief	段位情况(RANKMATCH_UpSegment = 32）
function ProtocolProcessorSceneQualifying:parse_RANKMATCH_UpSegment (level, result)
    -- level : 当前等级
    -- result : 结果，1、升级，2、降级
    WZLog("ProtocolProcessorSceneQualifying:parse_RANKMATCH_UpSegment ")
end

--@brief	上周排行 (RANKMATCH_HistoryRankOK = 37）
function ProtocolProcessorSceneQualifying:parse_RANKMATCH_HistoryRankOK(playerId, playerName, playerSex, playerHeadId, playerFaceId, playerLevel,
        segmentLevel, score, battleTimes, winTimes, winStreak,vipLv,serverId,headColour)
    -- playerId : 玩家id
    -- playerName : 玩家名称
    -- playerSex : 玩家性别
    -- playerHeadId : 玩家头
    -- playerFaceId : 玩家脸
    -- playerLevel : 玩家等级
    -- segmentLevel : 玩家段位等级
    -- score : 玩家积分
    WZLog("ProtocolProcessorSceneQualifying:parse_RANKMATCH_HistoryRankOK")
    local playerId = VectorToTable(playerId)
    local playerName = VectorToTable(playerName)
    local playerSex = VectorToTable(playerSex)
    local playerHeadId = VectorToTable(playerHeadId)
    local playerFaceId = VectorToTable(playerFaceId)
    local playerLevel = VectorToTable(playerLevel)
    local segmentLevel = VectorToTable(segmentLevel)
    local score = VectorToTable(score)
    local battleTimes = VectorToTable(battleTimes)
    local winTimes = VectorToTable(winTimes)
    local winStreak = VectorToTable(winStreak)
    local vipLv = VectorToTable(vipLv)
    local serverId = VectorToTable(serverId)
    local headColour = VectorToTable(headColour)

    local data = {}
    for i = 1, #playerId do
        local info = {
            rank = i,
            playerId = playerId[i],
            playerName = playerName[i],
            playerSex = playerSex[i],
            playerHeadId = playerHeadId[i],
            playerFaceId = playerFaceId[i],
            playerLevel = playerLevel[i],
            segmentLevel = segmentLevel[i],
            score = score[i],
            battleTimes = battleTimes[i],
            winTimes = winTimes[i],
            winStreak = winStreak[i],
            vipLv = vipLv[i],
            serverId = serverId[i],
            headColour = headColour[i],
        }
        table.insert(data,info)
    end
    WndPvpMatchRank:setHistoryData(data)
end


-------------------------------------------------receive error----------------------------------------------------------

--@brief	战绩日志错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneQualifying:send_RANKMATCH_GetLog_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorSceneQualifying:send_RANKMATCH_GetLog_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_RANKMATCH, Protocol.RANKMATCH_GetLog, nflag, sMessage)
end

--@brief	排位赛排行榜错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneQualifying:send_RANKMATCH_GetRank_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorSceneQualifying:send_RANKMATCH_GetRank_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_RANKMATCH, Protocol.RANKMATCH_GetRank, nflag, sMessage)
end

--@brief	膜拜错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneQualifying:send_RANKMATCH_Worship_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorSceneQualifying:send_RANKMATCH_Worship_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_RANKMATCH, Protocol.RANKMATCH_Worship, nflag, sMessage)
end

--@brief	膜拜日志错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneQualifying:send_RANKMATCH_GetWorshipLog_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorSceneQualifying:send_RANKMATCH_GetWorshipLog_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_RANKMATCH, Protocol.RANKMATCH_GetWorshipLog, nflag, sMessage)
end

--@brief	开始挑战（RANKMATCH_Start = 25）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneQualifying:send_RANKMATCH_Start_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorSceneQualifying:send_RANKMATCH_Start_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_RANKMATCH, Protocol.RANKMATCH_Start, nflag, sMessage)
end

--@brief	冠军形象（RANKMATCH_GetPlayerInfo = 27）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneQualifying:send_RANKMATCH_GetPlayerInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorSceneQualifying:send_RANKMATCH_GetPlayerInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_RANKMATCH, Protocol.RANKMATCH_GetPlayerInfo, nflag, sMessage)
end

--@brief	打开宝箱（RANKMATCH_OpenBox = 33）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneQualifying:send_RANKMATCH_OpenBox_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorSceneQualifying:send_RANKMATCH_OpenBox_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_RANKMATCH, Protocol.RANKMATCH_OpenBox, nflag, sMessage)
    ScenePvpRank:showReward(false)
end

--@brief	结束匹配（RANKMATCH_End = 35）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneQualifying:send_RANKMATCH_End_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorSceneQualifying:send_RANKMATCH_End_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_RANKMATCH, Protocol.RANKMATCH_End, nflag, sMessage)
end

--@brief	上周排行（RANKMATCH_HistoryRank = 36）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneQualifying:send_RANKMATCH_HistoryRank_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorSceneQualifying:send_RANKMATCH_HistoryRank_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_RANKMATCH, Protocol.RANKMATCH_HistoryRank, nflag, sMessage)
end
