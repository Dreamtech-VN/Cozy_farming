--ProtocolProcessorScenePvpRank.lua
--@brief	排位赛相关协议
--@date  	2015-11-13
--@author 	binshao
--@note 	排位赛相关协议


ProtocolProcessorScenePvpRank = ProtocolProcessorBase:new()

-----------------------------公有方法模块Begin--------------------------------------

--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorScenePvpRank:regAll()
    --@brief    获取比赛状态结果(TRIO_GetMatchInfoOk = 2）
    self:regProtocolCallbackFunction( Protocol.MAIN_TRIO, Protocol.TRIO_GetMatchInfoOk, "ProtocolProcessorScenePvpRank:parse_TRIO_GetMatchInfoOk", "iiibiiii")
    --@brief  获取排行榜结果(TRIO_GetMathcRankOk = 6）
    self:regProtocolCallbackFunction( Protocol.MAIN_TRIO, Protocol.TRIO_GetMathcRankOk, "ProtocolProcessorScenePvpRank:parse_TRIO_GetMathcRankOk", "vivivivsvivivivtvivtviviviviviiiii")
    --@brief    主城雕像形象成功
    self:regProtocolCallbackFunction( Protocol.MAIN_TRIO, Protocol.TRIO_GetStatueInfoOK, "ProtocolProcessorScenePvpRank:parse_RANKMATCH_GetStatueInfoOK", "vivsvivivivivtvivivt")
    --@brief    膜拜成功
    self:regProtocolCallbackFunction( Protocol.MAIN_TRIO, Protocol.TRIO_WorshipOK, "ProtocolProcessorScenePvpRank:parse_RANKMATCH_WorshipOK", "ii")
    --@brief    膜拜日志成功
    self:regProtocolCallbackFunction( Protocol.MAIN_TRIO, Protocol.TRIO_GetWorshipLogOK, "ProtocolProcessorScenePvpRank:parse_RANKMATCH_GetWorshipLogOK", "vsviviitvs")
    --@brief    领取膜拜金币成功
    self:regProtocolCallbackFunction( Protocol.MAIN_TRIO, Protocol.TRIO_GetWorshipGoldOK, "ProtocolProcessorScenePvpRank:parse_RANKMATCH_GetWorshipGoldOK", "")
    --@brief    主城雕像形象 (RANKMATCH_GetPlayerInfoOK = 28）
    self:regProtocolCallbackFunction( Protocol.MAIN_TRIO, Protocol.TRIO_GetPlayerInfoOK, "ProtocolProcessorScenePvpRank:parse_RANKMATCH_GetPlayerInfoOK", "isiiiitisiiiiis")
    --@brief    随机配对成功同步对战玩家数据
    self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_MakePairOk, "ProtocolProcessorScenePvpRank:parse_ROOM_MakePairOk", "iiiiiivivivsvsvsvsvivivivivivivivivivivivivivivivivivivivivivivivivsvivivsvivivivivivivivsvsvnvivivbvii")
    --@brief    获取积分赛前三名玩家信息（TRIO_GetTourPlayerInfoOk = 41）
    self:regProtocolCallbackFunction( Protocol.MAIN_TRIO, Protocol.TRIO_GetTourPlayerInfoOk, "ProtocolProcessorScenePvpRank:parse_TRIO_GetTourPlayerInfoOk", "vivsvivivivivtvivsvivivivivs")
    --@brief    膜拜积分赛雕像（TRIO_TourWorshipOk = 43）
    self:regProtocolCallbackFunction( Protocol.MAIN_TRIO, Protocol.TRIO_TourWorshipOk, "ProtocolProcessorScenePvpRank:parse_TRIO_TourWorshipOk", "ii")
    --@brief    积分赛膜拜日志（TRIO_GetTourWorshipLogOk = 45）
    self:regProtocolCallbackFunction( Protocol.MAIN_TRIO, Protocol.TRIO_GetTourWorshipLogOk, "ProtocolProcessorScenePvpRank:parse_TRIO_GetTourWorshipLogOk", "vsvivst")
    

    --@brief    获取比赛状态（TRIO_GetMatchInfo = 1）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_TRIO, Protocol.TRIO_GetMatchInfo, "ProtocolProcessorScenePvpRank:send_TRIO_GetMatchInfo_ErrorProcess", "is" )
    --@brief  获取排行榜（TRIO_GetMathcRank = 5）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_TRIO, Protocol.TRIO_GetMathcRank, "ProtocolProcessorScenePvpRank:send_TRIO_GetMathcRank_ErrorProcess", "is" )
    --@brief    主城雕像形象错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_TRIO, Protocol.TRIO_GetStatueInfo, "ProtocolProcessorScenePvpRank:send_RANKMATCH_GetStatueInfo_ErrorProcess", "is" )
    --@brief    膜拜错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_TRIO, Protocol.TRIO_Worship, "ProtocolProcessorScenePvpRank:send_RANKMATCH_Worship_ErrorProcess", "is" )
    --@brief    膜拜日志错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_TRIO, Protocol.TRIO_GetWorshipLog, "ProtocolProcessorScenePvpRank:send_RANKMATCH_GetWorshipLog_ErrorProcess", "is" )
    --@brief    领取膜拜金币错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_TRIO, Protocol.TRIO_GetWorshipGold, "ProtocolProcessorScenePvpRank:send_RANKMATCH_GetWorshipGold_ErrorProcess", "is" )
    --@brief    冠军形象（RANKMATCH_GetPlayerInfo = 27）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_TRIO, Protocol.TRIO_GetPlayerInfo, "ProtocolProcessorScenePvpRank:send_RANKMATCH_GetPlayerInfo_ErrorProcess", "is" )
    --@brief    快速游戏（ROOM_QuickGame = 13）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_QuickGame, "ProtocolProcessorScenePvpRank:send_ROOM_QuickGame_ErrorProcess", "is" )
    --@brief    获取积分赛前三名玩家信息（TRIO_GetTourPlayerInfo = 40）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_TRIO, Protocol.TRIO_GetTourPlayerInfo, "ProtocolProcessorScenePvpRank:send_TRIO_GetTourPlayerInfo_ErrorProcess", "is" )
    --@brief    膜拜积分赛雕像（TRIO_TourWorship = 42）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_TRIO, Protocol.TRIO_TourWorship, "ProtocolProcessorScenePvpRank:send_TRIO_TourWorship_ErrorProcess", "is" )
    --@brief    积分赛膜拜日志（TRIO_GetTourWorshipLog = 44）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_TRIO, Protocol.TRIO_GetTourWorshipLog, "ProtocolProcessorScenePvpRank:send_TRIO_GetTourWorshipLog_ErrorProcess", "is" )
end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorScenePvpRank:unregAll()
	self:clearReg()
end

---------------------send--------------------------------------------------------
--@brief    获取比赛状态（TRIO_GetMatchInfo = 1）
function ProtocolProcessorScenePvpRank:send_TRIO_GetMatchInfo( )
    WZLog("send_TRIO_GetMatchInfo")
    local sender = Protocol:getSender( Protocol.MAIN_TRIO, Protocol.TRIO_GetMatchInfo )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief  获取排行榜（TRIO_GetMathcRank = 5）
function ProtocolProcessorScenePvpRank:send_TRIO_GetMathcRank( )
  WZLog("send_TRIO_GetMathcRank")
  local sender = Protocol:getSender( Protocol.MAIN_TRIO, Protocol.TRIO_GetMathcRank )
  if sender==nil then WZLog("sender == nil") return end

  SendProtocol(sender,false) --true:showLoading
end

--@brief    主城雕像形象
function ProtocolProcessorScenePvpRank:send_RANKMATCH_GetStatueInfo( )
    WZLog("send_RANKMATCH_GetStatueInfo")
    local sender = Protocol:getSender( Protocol.MAIN_TRIO, Protocol.TRIO_GetStatueInfo )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    膜拜
function ProtocolProcessorScenePvpRank:send_RANKMATCH_Worship(playerId)
    WZLog("send_RANKMATCH_Worship")
    local sender = Protocol:getSender( Protocol.MAIN_TRIO, Protocol.TRIO_Worship )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt(playerId)    -- 膜拜的玩家Id
    SendProtocol(sender,false) --true:showLoading
end

--@brief    膜拜日志
function ProtocolProcessorScenePvpRank:send_RANKMATCH_GetWorshipLog( )
    WZLog("send_RANKMATCH_GetWorshipLog")
    local sender = Protocol:getSender( Protocol.MAIN_TRIO, Protocol.TRIO_GetWorshipLog )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    领取膜拜金币
function ProtocolProcessorScenePvpRank:send_RANKMATCH_GetWorshipGold( )
    WZLog("send_RANKMATCH_GetWorshipGold")
    local sender = Protocol:getSender( Protocol.MAIN_TRIO, Protocol.TRIO_GetWorshipGold )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    冠军形象（RANKMATCH_GetPlayerInfo = 27）
function ProtocolProcessorScenePvpRank:send_RANKMATCH_GetPlayerInfo( )
    WZLog("send_RANKMATCH_GetPlayerInfo")
    local sender = Protocol:getSender( Protocol.MAIN_TRIO, Protocol.TRIO_GetPlayerInfo )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    快速游戏（ROOM_QuickGame = 13）
function ProtocolProcessorScenePvpRank:send_ROOM_QuickGame(roomChannel,battleMode,schedule )
    WZLog("ProtocolProcessorScenePvpRank:send_ROOM_QuickGam", roomChannel)
    local sender = Protocol:getSender( Protocol.MAIN_ROOM, Protocol.ROOM_QuickGame )
    if sender==nil then WZLog("sender == nil") return end
    sender:writeInt(roomChannel)    -- 房间所属频道
    sender:writeInt(battleMode)    -- 战斗模式
    sender:writeInt(schedule)  --赛程
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取积分赛前三名玩家信息（TRIO_GetTourPlayerInfo = 40）
function ProtocolProcessorScenePvpRank:send_TRIO_GetTourPlayerInfo( )
    WZLog("send_TRIO_GetTourPlayerInfo")
    local sender = Protocol:getSender( Protocol.MAIN_TRIO, Protocol.TRIO_GetTourPlayerInfo )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    膜拜积分赛雕像（TRIO_TourWorship = 42）
function ProtocolProcessorScenePvpRank:send_TRIO_TourWorship(playerId)
    WZLog("send_TRIO_TourWorship")
    local sender = Protocol:getSender( Protocol.MAIN_TRIO, Protocol.TRIO_TourWorship )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt(playerId)    -- 玩家id
    SendProtocol(sender,false) --true:showLoading
end

--@brief    积分赛膜拜日志（TRIO_GetTourWorshipLog = 44）
function ProtocolProcessorScenePvpRank:send_TRIO_GetTourWorshipLog( )
    WZLog("send_TRIO_GetTourWorshipLog")
    local sender = Protocol:getSender( Protocol.MAIN_TRIO, Protocol.TRIO_GetTourWorshipLog )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end
----------------------------------------receive ok----------------------------------
--@brief    获取比赛状态结果(TRIO_GetMatchInfoOk = 2）
function ProtocolProcessorScenePvpRank:parse_TRIO_GetMatchInfoOk(currentSeason, startTimestamp, endTimestamp, isInActivity, matchLevel, matchScore, startTime, endTime)
    -- currentSeason : 当前赛季(-1则整个赛程已经结束)
    -- startTimestamp : 总的开启时间戳
    -- endTimestamp : 总的结束时间戳
    -- isInActivity : 是否可以进行匹配
    -- matchLevel : 玩家赛事等级
    -- matchScore : 玩家赛季积分(当前等级)
    -- startTime : 距离赛季开始时间
    -- endTime ：距离赛季结束时间
    WZLog("ProtocolProcessorScenePvpRank:parse_TRIO_GetMatchInfoOk")
    if WndWelfare.m_root then
        WndWelfare:onReceiveDataOK(currentSeason, startTimestamp, endTimestamp, isInActivity, startTime, endTime)
        return 
    end
    if WndPvpRankKing.m_root then 
        WndPvpRankKing:initData(currentSeason, startTimestamp, endTimestamp, isInActivity, matchLevel, matchScore,startTime, endTime)
        return 
    end
    ScenePvpRank:initData(currentSeason, startTimestamp, endTimestamp, isInActivity, matchLevel, matchScore,startTime, endTime)
end

--@brief  获取排行榜结果(TRIO_GetMathcRankOk = 6）
function ProtocolProcessorScenePvpRank:parse_TRIO_GetMathcRankOk(rank, serverId, playerId, name, faceId, headId, headColor, sex, level, vipLevel, matchLevel, matchScore, matchConfigId, battleTimes, winTimes, playerRank, playerMatchLevel, playerMatchSocre, playerMatchConfigId)
    -- rank : 排名
    -- playerId : 玩家id
    -- name : 玩家名称
    -- faceId : 脸id
    -- headId : 头id
    -- sex : 性别
    -- vipLevel : vip等级
    -- matchLevel : 排位赛等级
    -- matchScore : 排位赛积分
    -- matchConfigId : 排位赛等级对应的配置表id,用于读取段位 
    -- playerRank : 玩家个人排名
    -- playerMatchLevel : 玩家个人排位赛等级
    -- playerMatchSocre : 玩家个人排位赛积分
    -- playerMatchConfigId : 玩家个人排位赛等级对应的配置表id,用于读取段位 
    WZLog("ProtocolProcessorScenePvpRank:parse_TRIO_GetMathcRankOk")
    if WndPvpMatchRank.m_root then
        --排名奖励
        WndPvpMatchRank:setMyRankData(playerRank)
        return 
    end
    WndPvpRankList:setRankData(rank, serverId, playerId, name, faceId, headId, headColor, sex, level, vipLevel, matchLevel, matchScore, matchConfigId, battleTimes, winTimes, playerRank, playerMatchLevel, playerMatchSocre, playerMatchConfigId)
end

--@brief    主城雕像形象成功
function ProtocolProcessorScenePvpRank:parse_RANKMATCH_GetStatueInfoOK(playerId, playerName, playerHeadId, playerFaceId, playerBodyId, playerWingId, playerSex, colour, bodyColour, statueType)
    -- playerId : 玩家id
    -- playerName : 玩家名称
    -- playerHeadId : 头
    -- playerFaceId : 脸
    -- playerBodyId : 身
    -- playerWingId : 翅膀
    -- playerSex : 性别
    -- statueType : 雕像类型.1-排位赛雕像 2-积分赛雕像
    WZLog("ProtocolProcessorScenePvpRank:parse_RANKMATCH_GetStatueInfoOK", type(GlobalMethod:crossServiceOpen()), GlobalMethod:crossServiceOpen(), playerId:size())

    if playerId:size() > 0 and GlobalMethod:crossServiceOpen() ~= 0 then
        for i = 0, playerId:size() - 1 do
            local info = {playerId = playerId:get(i), playerName = playerName:get(i), playerSex = playerSex:get(i), headId = playerHeadId:get(i), faceId = playerFaceId:get(i), bodyId = playerBodyId:get(i), wingId = playerWingId:get(i), playerTitle="", mountsId=0, colour=colour:get(i), bodyColour=bodyColour:get(i), statueType = statueType:get(i)}
            if SceneCity.m_root then
                WZLog("parse_RANKMATCH_GetStatueInfoOK", Serialize(info))
                FigureSceneManager:getInstance():createOtherFigures({info}, true)
            end
        end
    end
end

--@brief    膜拜成功
function ProtocolProcessorScenePvpRank:parse_RANKMATCH_WorshipOK(playerId, worshipNum)
    -- playerId : 玩家id
    -- worshipNum : 膜拜次数

    WZLog("ProtocolProcessorScenePvpRank:parse_RANKMATCH_WorshipOK")
    local power = CacheCenter:getGameParam().matchRankWorshipVigor
    MsgBoxManager:showTipBox(string.format(LocalStrings.WORSHIP_SUCCESS, power), nil, nil, nil, nil)
    CellRankSeat:receiveWorshipOK(0, 1)
    ProtocolProcessorScenePvpRank:send_RANKMATCH_GetWorshipLog()
end


--@brief    膜拜日志成功
function ProtocolProcessorScenePvpRank:parse_RANKMATCH_GetWorshipLogOK(playerName, serverId, worshipDate, gold,worshipState, beWorshipName)
    -- playerName : 膜拜者名称
    -- worshipDate : 膜拜时间
    -- gold : 膜拜可以被领取金币
    -- beWorshipName : 被膜拜的玩家名字
    WZLog("ProtocolProcessorScenePvpRank:parse_RANKMATCH_GetWorshipLogOK")

    local log = {playerName = VectorToTable(playerName), serverId = VectorToTable(serverId), worshipDate = VectorToTable(worshipDate), gold = gold ,worshipState = worshipState, beWorshipName = VectorToTable(beWorshipName)}
    WndPvpRankKing:setLogData(log)
end

--@brief    领取膜拜金币成功
function ProtocolProcessorScenePvpRank:parse_RANKMATCH_GetWorshipGoldOK()
    WZLog("ProtocolProcessorScenePvpRank:parse_RANKMATCH_GetWorshipGoldOK")

    MsgBoxManager:showTipBox(LocalStrings.GET_WORSHIP_GOLD, nil, nil, nil, nil)
    WndPvpRankKing:receiveGoldOk()
end

--@brief    主城雕像形象 (RANKMATCH_GetPlayerInfoOK = 28）
function ProtocolProcessorScenePvpRank:parse_RANKMATCH_GetPlayerInfoOK(playerId, playerName, playerHeadId, playerFaceId, playerBodyId, playerWingId, playerSex, playerLevel, petMessage, fighting,headColour,bodyColour, rank, times, title)
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
    -- rank : 排名
    -- times ： 膜拜次数
    -- title : 称号
    WZLog("ProtocolProcessorScenePvpRank:parse_RANKMATCH_GetPlayerInfoOK")
    local info = {id = playerId, name = playerName, headId = playerHeadId, faceId = playerFaceId,
        bodyId = playerBodyId, wingId = playerWingId, sex = playerSex, level = playerLevel,
        petMessage = petMessage, fighting = fighting, headColour = headColour,bodyColour = bodyColour, rank = rank, worshipNum = times, title = title}
    WndPvpRankKing:setPlayerInfo(info)
end

--@brief    副本随机配对成功同步对战玩家数据
function ProtocolProcessorScenePvpRank:parse_ROOM_MakePairOk(battleId,battleMode,battleChannle,schedule,
mapId, playerCount, playerCamp,playerId, serverId, playerName, playerTitle, playerCommunity, playerLevel, 
playerSex, maxHP, maxPF, maxSP, attack, critRate, defence, injuryFree, wreckDefense, reduceCrit, power, armor, 
constitution, agility, lucky, winRate, fighting, headId, faceId, bodyId, weaponId, wingId, item_id, petSkill, 
playerBuffCount, buffId, petId, petParam, battleTimes, winTimes, streakTimes, segmentLevel,tournamentLevel,
teamId,teamName,url,petLevel, colour, bodyColour,isCaptain,footmark, monsterId)
    WZLog("ProtocolProcessorScenePvpRank:parse_ROOM_MakePairOk",battleMode, battleChannle, schedule)

    WZLog("ProtocolProcessorScenePvpRank:parse_ROOM_MakePairOk two","\n\nbattleId", serverId,

    Serialize(VectorToTable(battleId)),Serialize(VectorToTable(battleMode)),Serialize(VectorToTable(mapId)),Serialize(VectorToTable(playerCount)),Serialize(VectorToTable(playerCamp)),Serialize(VectorToTable(playerId)),Serialize(VectorToTable(playerName)),Serialize(VectorToTable(playerTitle)),Serialize(VectorToTable(playerCommunity)),"\n\nplayerLevel",

    Serialize(VectorToTable(playerLevel)),Serialize(VectorToTable(playerSex)),Serialize(VectorToTable(maxHP)),Serialize(VectorToTable(maxPF)),Serialize(VectorToTable(maxSP)),Serialize(VectorToTable(attack)),Serialize(VectorToTable(critRate)),Serialize(VectorToTable(defence)),Serialize(VectorToTable(injuryFree)),"\n\nwreckDefense",

    Serialize(VectorToTable(wreckDefense)),Serialize(VectorToTable(reduceCrit)),Serialize(VectorToTable(power)),Serialize(VectorToTable(armor)),Serialize(VectorToTable(constitution)),Serialize(VectorToTable(agility)),Serialize(VectorToTable(lucky)),"\n\nheadId",

    Serialize(VectorToTable(headId)),Serialize(VectorToTable(faceId)),Serialize(VectorToTable(bodyId)),Serialize(VectorToTable(weaponId)),Serialize(VectorToTable(wingId)),Serialize(VectorToTable(item_id)),Serialize(VectorToTable(playerBuffCount)),Serialize(VectorToTable(buffId)),"\n\npetId",

    Serialize(VectorToTable(petId)),Serialize(VectorToTable(petParam)),Serialize(VectorToTable(tournamentLevel)))


    ProtocolProcessorScenePvpRank:receiveMakePairOk(VectorToTable(battleId), VectorToTable(battleMode), battleChannle, schedule,VectorToTable(mapId), VectorToTable(playerCount), VectorToTable(playerCamp), VectorToTable(playerId), VectorToTable(serverId), VectorToTable(playerName), VectorToTable(playerTitle), VectorToTable(playerCommunity), VectorToTable(playerLevel), VectorToTable(playerSex), VectorToTable(maxHP), VectorToTable(maxPF), VectorToTable(maxSP), VectorToTable(attack), VectorToTable(critRate), VectorToTable(defence), VectorToTable(injuryFree), VectorToTable(wreckDefense), VectorToTable(reduceCrit), VectorToTable(power), VectorToTable(armor), VectorToTable(constitution), VectorToTable(agility), VectorToTable(lucky), VectorToTable(winRate), VectorToTable(fighting), VectorToTable(headId), VectorToTable(faceId), VectorToTable(bodyId), VectorToTable(weaponId), VectorToTable(wingId), VectorToTable(item_id), VectorToTable(playerBuffCount), VectorToTable(buffId), VectorToTable(petId), VectorToTable(petSkill), VectorToTable(petParam), VectorToTable(battleTimes), VectorToTable(winTimes), VectorToTable(streakTimes), VectorToTable(segmentLevel), VectorToTable(weaponSkill), VectorToTable(tournamentLevel),VectorToTable(teamId),VectorToTable(teamName),VectorToTable(url),VectorToTable(petLevel),VectorToTable(colour),VectorToTable(bodyColour),VectorToTable(isCaptain),VectorToTable(footmark), monsterId)

end

--@brief    副本随机配对成功同步对战玩家数据
function ProtocolProcessorScenePvpRank:receiveMakePairOk(battleId,battleMode, battleChannle, schedule,mapId, playerCount, playerCamp,playerId,serverId, playerName, playerTitle, playerCommunity, playerLevel, playerSex, maxHP, maxPF, maxSP, attack, critRate, defence, injuryFree, wreckDefense, reduceCrit, power, armor, constitution, agility, lucky, winRate, fighting, headId, faceId, bodyId, weaponId, wingId, item_id, playerBuffCount, buffId, petId, petSkill, petParam, battleTimes, winTimes, streakTimes, segmentLevel, weaponSkill,tournamentLevel,teamId,teamName,url,petLevel, colour, bodyColour, isCaptain,footmark, monsterId)
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

    WZLog("ProtocolProcessorScenePvpRank:receiveMakePairOk", type(battleTimes), type(winTimes),type(streakTimes),type(segmentLevel), Serialize(buffId))

    replaceScene(SceneBattleLoading:createElement())

end

--@brief    获取积分赛前三名玩家信息（TRIO_GetTourPlayerInfoOk = 41）
function ProtocolProcessorScenePvpRank:parse_TRIO_GetTourPlayerInfoOk(playerId, playerName, playerHeadId, playerFaceId, playerBodyId, playerWingId, playerSex, playerLevel, petMessage, fighting,headColour,bodyColour, times, title)
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
    -- times ： 膜拜次数
    -- title : 称号
    WZLog("ProtocolProcessorScenePvpRank:parse_TRIO_GetTourPlayerInfoOk")
    for i = 0, playerId:size() - 1 do
        local info = {id = playerId:get(i), name = playerName:get(i), headId = playerHeadId:get(i), faceId = playerFaceId:get(i),
            bodyId = playerBodyId:get(i), wingId = playerWingId:get(i), sex = playerSex:get(i), level = playerLevel:get(i),
            petMessage = petMessage:get(i), fighting = fighting:get(i), headColour = headColour:get(i), bodyColour = bodyColour:get(i), worshipNum = times:get(i), title = title:get(i), rank = i + 1}
        WndPvpRankKing:setPlayerInfo(info)
    end
end

--@brief    膜拜积分赛雕像（TRIO_TourWorshipOk = 43）
function ProtocolProcessorScenePvpRank:parse_TRIO_TourWorshipOk(playerId, worshipNum)
    -- playerId : 被膜拜玩家id
    -- worshipNum : 被膜拜玩家总膜拜次数
    WZLog("ProtocolProcessorScenePvpRank:parse_TRIO_TourWorshipOk")
    local power = CacheCenter:getGameParam().matchRankWorshipVigor
    MsgBoxManager:showTipBox(string.format(LocalStrings.WORSHIP_SUCCESS, power), nil, nil, nil, nil)
    CellRankSeat:receiveWorshipOK(0, 1)
    ProtocolProcessorScenePvpRank:send_TRIO_GetTourWorshipLog()
end

--@brief    积分赛膜拜日志（TRIO_GetTourWorshipLogOk = 45）
function ProtocolProcessorScenePvpRank:parse_TRIO_GetTourWorshipLogOk(playerName, worshipTime, worshipName, worshipState)
    -- playerName : 膜拜者名称
    -- worshipTime : 膜拜时间（秒）时间戳
    -- worshipName : 被膜拜玩家名
    -- worshipState : 膜拜状态1.已膜拜，2.可膜拜
    WZLog("ProtocolProcessorScenePvpRank:parse_TRIO_GetTourWorshipLogOk")

    local log = {playerName = VectorToTable(playerName), worshipDate = VectorToTable(worshipTime), worshipState = worshipState, beWorshipName = VectorToTable(worshipName)}
    WndPvpRankKing:setLogData(log)
end
---------------------------------receive error-------------------------------------
--@brief    冠军形象（RANKMATCH_GetPlayerInfo = 27）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorScenePvpRank:send_RANKMATCH_GetStatueInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorScenePvpRank:send_RANKMATCH_GetPlayerInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TRIO, Protocol.TRIO_GetStatueInfo, nflag, sMessage)
end

--@brief    膜拜错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorScenePvpRank:send_RANKMATCH_Worship_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorScenePvpRank:send_RANKMATCH_Worship_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TRIO, Protocol.TRIO_Worship, nflag, sMessage)
end

--@brief    膜拜日志错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorScenePvpRank:send_RANKMATCH_GetWorshipLog_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorScenePvpRank:send_RANKMATCH_GetWorshipLog_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TRIO, Protocol.TRIO_GetWorshipLog, nflag, sMessage)
end

--@brief    冠军形象（RANKMATCH_GetPlayerInfo = 27）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorScenePvpRank:send_RANKMATCH_GetPlayerInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorScenePvpRank:send_RANKMATCH_GetPlayerInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TRIO, Protocol.TRIO_GetPlayerInfo, nflag, sMessage)
end

--@brief    快速游戏（ROOM_QuickGame = 13）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorScenePvpRank:send_ROOM_QuickGame_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorScenePvpRank:send_ROOM_QuickGame_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ROOM, Protocol.ROOM_QuickGame, nFlag, sMessage)
end

--@brief    获取积分赛前三名玩家信息（TRIO_GetTourPlayerInfo = 40）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorScenePvpRank:send_TRIO_GetTourPlayerInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorScenePvpRank:send_TRIO_GetTourPlayerInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TRIO, Protocol.TRIO_GetTourPlayerInfo, nflag, sMessage)
end

--@brief    膜拜积分赛雕像（TRIO_TourWorship = 42）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorScenePvpRank:send_TRIO_TourWorship_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorScenePvpRank:send_TRIO_TourWorship_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TRIO, Protocol.TRIO_TourWorship, nflag, sMessage)
end

--@brief    积分赛膜拜日志（TRIO_GetTourWorshipLog = 44）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorScenePvpRank:send_TRIO_GetTourWorshipLog_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorScenePvpRank:send_TRIO_GetTourWorshipLog_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TRIO, Protocol.TRIO_GetTourWorshipLog, nflag, sMessage)
end