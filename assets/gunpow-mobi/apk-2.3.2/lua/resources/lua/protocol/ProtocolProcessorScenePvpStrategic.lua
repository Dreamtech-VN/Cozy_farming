--ProtocolProcessorScenePvpStrategic.lua
--@brief	星魂系统相关协议
--@date  	2014/8/18
--@author 	郭月奇
--@note 	星魂系统相关协议


ProtocolProcessorScenePvpStrategic = ProtocolProcessorBase:new()


-------------------------------------公有方法模块--------------------------------------

--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorScenePvpStrategic:regAll()
    WZLog("ProtocolProcessorScenePvpStrategic:regAll")
    --@brief    创建房间（ROOM_CreateRoom = 1）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_CreateRoom, "ProtocolProcessorScenePvpStrategic:send_ROOM_CreateRoom_ErrorProcess", "is" )
    --@brief    快速游戏（ROOM_QuickGame = 13）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_QuickGame, "ProtocolProcessorScenePvpStrategic:send_ROOM_QuickGame_ErrorProcess", "is" )
    -- --@brief    查找房间（ROOM_SelectRoom = 14）错误处理(S->C)
    -- self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_SelectRoom, "ProtocolProcessorScenePvpStrategic:send_ROOM_SelectRoom_ErrorProcess", "is" )
    --@brief    找到房间需要密码（ROOM_SelectRoomOk = 15）
    self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_SelectRoomOk, "ProtocolProcessorSceneArena:parse_ROOM_SelectRoomOk", "is")
    --@brief    取消随机配对对战用户（ROOM_EndPair = 34）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_EndPair, "ProtocolProcessorScenePvpStrategic:send_ROOM_EndPair_ErrorProcess", "is" )
    --@brief    退出匹配成功（ROOM_EndPairOk = 35）
    self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_EndPairOk, "ProtocolProcessorScenePvpStrategic:parse_ROOM_EndPairOk", "")


    --@brief    获取战略赛信息（TRIO_GetZlsBattleInfo = 50）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_TRIO, Protocol.TRIO_GetZlsBattleInfo, "ProtocolProcessorScenePvpStrategic:send_TRIO_GetZlsBattleInfo_ErrorProcess", "is")
    --@brief    获取战略赛技能道具池（TRIO_GetZlsSkillList = 52）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_TRIO, Protocol.TRIO_GetZlsSkillList, "ProtocolProcessorScenePvpStrategic:send_TRIO_GetZlsSkillList_ErrorProcess", "is")
    --@brief    装备战略赛技能/道具（TRIO_EquipZlsSkill = 54）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_TRIO, Protocol.TRIO_EquipZlsSkill, "ProtocolProcessorScenePvpStrategic:send_TRIO_EquipZlsSkill_ErrorProcess", "is")
    --@brief    获取战略赛历届赛季信息（TRIO_GetZlsSeasonInfoList = 56）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_TRIO, Protocol.TRIO_GetZlsSeasonInfoList, "ProtocolProcessorScenePvpStrategic:send_TRIO_GetZlsSeasonInfoList_ErrorProcess", "is")
    --@brief    获取战略赛排行榜（TRIO_GetZlsRankList = 58）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_TRIO, Protocol.TRIO_GetZlsRankList, "ProtocolProcessorScenePvpStrategic:send_TRIO_GetZlsRankList_ErrorProcess", "is")


    --@brief    获取战略赛信息结果（TRIO_GetZlsBattleInfoOk = 51）
    self:regProtocolCallbackFunction( Protocol.MAIN_TRIO, Protocol.TRIO_GetZlsBattleInfoOk, "ProtocolProcessorScenePvpStrategic:parse_TRIO_GetZlsBattleInfoOk", "iiivsvivitiiiviviiiivivii")
    --@brief    获取战略赛技能道具池结果（TRIO_GetZlsSkillListOk = 53）
    self:regProtocolCallbackFunction( Protocol.MAIN_TRIO, Protocol.TRIO_GetZlsSkillListOk, "ProtocolProcessorScenePvpStrategic:parse_TRIO_GetZlsSkillListOk", "vivivivivi")
    --@brief    装备战略赛技能/道具结果（TRIO_EquipZlsSkillOk = 55）
    self:regProtocolCallbackFunction( Protocol.MAIN_TRIO, Protocol.TRIO_EquipZlsSkillOk, "ProtocolProcessorScenePvpStrategic:parse_TRIO_EquipZlsSkillOk", "ittvi")
    --@brief    获取战略赛历届赛季信息结果（TRIO_GetZlsSeasonInfoListOk = 57）
    self:regProtocolCallbackFunction( Protocol.MAIN_TRIO, Protocol.TRIO_GetZlsSeasonInfoListOk, "ProtocolProcessorScenePvpStrategic:parse_TRIO_GetZlsSeasonInfoListOk", "vivivivivivivivivivivivi")
    --@brief    获取战略赛排行榜结果（TRIO_GetZlsRankListOk = 59）
    self:regProtocolCallbackFunction( Protocol.MAIN_TRIO, Protocol.TRIO_GetZlsRankListOk, "ProtocolProcessorScenePvpStrategic:parse_TRIO_GetZlsRankListOk", "tvivivivsvivivivtvivtviviviviviiiii")


end 


--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorScenePvpStrategic:unregAll()
    WZLog("ProtocolProcessorSingleMap:unregAll")
	self:clearReg()
end



-------------------------------------客户端到服务器协议发送方法模块--------------------------------------

--@brief    创建房间（ROOM_CreateRoom = 1）
function ProtocolProcessorScenePvpStrategic:send_ROOM_CreateRoom(roomName, battleMode, playerNumMode, passWord, startMode, roomChannel, schedule)
    WZLog("ProtocolProcessorScenePvpStrategic:send_ROOM_CreateRoom", roomName, battleMode, playerNumMode, passWord, startMode, roomChannel, schedule)
    local sender = Protocol:getSender( Protocol.MAIN_ROOM, Protocol.ROOM_CreateRoom )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeString( roomName )  -- 房间名称
    sender:writeInt( battleMode )   -- 战斗模式
    sender:writeInt( playerNumMode )    -- 对战人数模式
    sender:writeString( passWord )  -- 房间密码
    sender:writeInt( startMode )    -- 撮合方式
    sender:writeInt( roomChannel )  -- 房间所属频道
    sender:writeInt( schedule )  -- 赛程
    SendProtocol(sender,false) --true:showLoading
end

--@brief    快速游戏（ROOM_QuickGame = 13）
function ProtocolProcessorScenePvpStrategic:send_ROOM_QuickGame(roomChannel,battleMode,schedule,numMode)
    WZLog("ProtocolProcessorScenePvpStrategic:send_ROOM_QuickGam", roomChannel,battleMode,schedule)
    local sender = Protocol:getSender( Protocol.MAIN_ROOM, Protocol.ROOM_QuickGame )
    if sender==nil then WZLog("sender == nil") return end
    sender:writeInt(roomChannel)    -- 房间所属频道
    sender:writeInt(battleMode)   -- 战斗模式
    sender:writeInt(schedule) --赛程
    sender:writeInt(numMode or 0) --[177+]房间人数模式(2=2V2|3=3V3)
    SendProtocol(sender,false) --true:showLoading
end

--@brief    查找房间（ROOM_SelectRoom = 14）
function ProtocolProcessorScenePvpStrategic:send_ROOM_SelectRoom(roomId, roomChannel, numMode, passWord)
    WZLog("ProtocolProcessorScenePvpStrategic:send_ROOM_SelectRoom ", roomId, roomChannel, passWord)
    local sender = Protocol:getSender( Protocol.MAIN_ROOM, Protocol.ROOM_SelectRoom )
    if sender==nil then WZLog("sender == nil") return end
    sender:writeInt(roomId) -- 房间Id
    sender:writeInt(roomChannel) --房间频道
    sender:writeInt(numMode) --[177+]房间人数模式(2=2V2|3=3V3)
    sender:writeString(passWord)    -- 房间密码，"-1"为没有密码
    SendProtocol(sender,false) --true:showLoading
end

--@brief    取消随机配对对战用户（ROOM_EndPair = 34）
function ProtocolProcessorScenePvpStrategic:send_ROOM_EndPair(roomId )
    WZLog("ProtocolProcessorScenePvpStrategic:send_ROOM_EndPair", roomId)
    local sender = Protocol:getSender( Protocol.MAIN_ROOM, Protocol.ROOM_EndPair )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( roomId )   -- 房间Id
    SendProtocol(sender,false) --true:showLoading
end


--@brief    获取战略赛信息（TRIO_GetZlsBattleInfo = 50）
function ProtocolProcessorScenePvpStrategic:send_TRIO_GetZlsBattleInfo()
    WZLog("send_TRIO_GetZlsBattleInfo")
    local sender = Protocol:getSender( Protocol.MAIN_TRIO, Protocol.TRIO_GetZlsBattleInfo )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取战略赛技能道具池（TRIO_GetZlsSkillList = 52）
function ProtocolProcessorScenePvpStrategic:send_TRIO_GetZlsSkillList()
    WZLog("send_TRIO_GetZlsSkillList")
    local sender = Protocol:getSender( Protocol.MAIN_TRIO, Protocol.TRIO_GetZlsSkillList )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    装备战略赛技能/道具（TRIO_EquipZlsSkill = 54）
function ProtocolProcessorScenePvpStrategic:send_TRIO_EquipZlsSkill(doType, mode, skillIds)
    WZLog("send_TRIO_EquipZlsSkill", doType, mode, Serialize(VectorToTable(skillIds)))
    local sender = Protocol:getSender( Protocol.MAIN_TRIO, Protocol.TRIO_EquipZlsSkill )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeByte(doType)    -- 操作类型【0=装备技能|1=装备道具】
    sender:writeByte(mode)  -- 战略赛人数模式【2=2V2模式|3=3V3模式】
    sender:writeInts(skillIds)  -- 要装备的技能/道具ID集合
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取战略赛历届赛季信息（TRIO_GetZlsSeasonInfoList = 56）
function ProtocolProcessorScenePvpStrategic:send_TRIO_GetZlsSeasonInfoList(mode)
    WZLog("send_TRIO_GetZlsSeasonInfoList", mode)
    local sender = Protocol:getSender( Protocol.MAIN_TRIO, Protocol.TRIO_GetZlsSeasonInfoList )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeByte(mode)  -- 战略赛人数模式【2=2V2模式|3=3V3模式】
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取战略赛排行榜（TRIO_GetZlsRankList = 58）
function ProtocolProcessorScenePvpStrategic:send_TRIO_GetZlsRankList(mode)
    WZLog("send_TRIO_GetZlsRankList", mode)
    local sender = Protocol:getSender( Protocol.MAIN_TRIO, Protocol.TRIO_GetZlsRankList )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeByte(mode)  -- 战略赛人数模式【2=2V2模式|3=3V3模式】
    SendProtocol(sender,false) --true:showLoading
end

-------------------------------------服务器到客户端协议回调方法模块--------------------------------------

--@brief    找到房间需要密码
function ProtocolProcessorScenePvpStrategic:parse_ROOM_SelectRoomOk(roomId, passWord)
    -- roomId : 房间Id
    -- passWord : 房间密码
    WZLog("ProtocolProcessorScenePvpStrategic:parse_ROOM_SelectRoomOk", roomId, passWord)
end

--@brief    退出匹配成功（ROOM_EndPairOk = 35）
function ProtocolProcessorScenePvpStrategic:parse_ROOM_EndPairOk()
    WZLog("ProtocolProcessorScenePvpStrategic:parse_ROOM_EndPairOk")
end

--@brief    获取战略赛信息结果（TRIO_GetZlsBattleInfoOk = 51）
function ProtocolProcessorScenePvpStrategic:parse_TRIO_GetZlsBattleInfoOk(season, startDate, dayNum, openTimes, openDay2V2, openDay3V3, mode, level, star, score, skillIds, propIds, level2, star2, score2, skillIds2, propIds2, protectNum)
    -- season : 当前赛季编号
    -- startDate : 赛季开始日期时间戳
    -- dayNum : 赛季持续天数
    -- openTimes : 赛事每日开放时间段,格式：[11:00,14:00,19:00,23:59]
    -- openDay2V2 : 2V2模式开放日期: [1,3,..]
    -- openDay3V3 : 3V3模式开放日期: [2,4,..]
    -- mode : 上次参与的人数模式【2=2V2模式|3=3V3模式】
    -- level : 玩家2V2模式段位等级
    -- star : 玩家2V2模式无限段位星级
    -- score : 玩家2V2模式积分
    -- skillIds : 玩家2V2模式携带的技能
    -- propIds : 玩家2V2模式携带的道具
    -- level2 : 玩家3V3模式段位等级
    -- star2 : 玩家3V3模式无限段位星级
    -- score2 : 玩家3V3模式积分
    -- skillIds2 : 玩家3V3模式携带的技能
    -- propIds2 : 玩家3V3模式携带的道具
    -- protectNum : 玩家拥有的掉段保护次数
    WZLog("ProtocolProcessorScenePvpStrategic:parse_TRIO_GetZlsBattleInfoOk", 
        "\n season =",Serialize(VectorToTable(season)), 
        "\n startDate =",Serialize(VectorToTable(startDate)), 
        "\n dayNum =",Serialize(VectorToTable(dayNum)), 
        "\n openTimes =",Serialize(VectorToTable(openTimes)), 
        "\n openDay2V2 =",Serialize(VectorToTable(openDay2V2)), 
        "\n openDay3V3 =",Serialize(VectorToTable(openDay3V3)), 
        "\n mode =",Serialize(VectorToTable(mode)), 
        "\n level =",Serialize(VectorToTable(level)), 
        "\n star =",Serialize(VectorToTable(star)), 
        "\n score =",Serialize(VectorToTable(score)), 
        "\n skillIds =",Serialize(VectorToTable(skillIds)), 
        "\n propIds =",Serialize(VectorToTable(propIds)), 
        "\n level2 =",Serialize(VectorToTable(level2)), 
        "\n star2 =",Serialize(VectorToTable(star2)), 
        "\n score2 =",Serialize(VectorToTable(score2)), 
        "\n skillIds2 =",Serialize(VectorToTable(skillIds2)), 
        "\n propIds2 =",Serialize(VectorToTable(propIds2)), 
        "\n protectNum =",Serialize(VectorToTable(protectNum)))

    ScenePvpStrategic:getZlsBattleInfoOk(season, startDate, dayNum, VectorToTable(openTimes), VectorToTable(openDay2V2), VectorToTable(openDay3V3), mode, level, star, score, VectorToTable(skillIds), VectorToTable(propIds), level2, star2, score2, VectorToTable(skillIds2), VectorToTable(propIds2), protectNum)
    WndPvpStrategicRank:getZlsBattleInfoOk(season, startDate, dayNum, VectorToTable(openTimes), VectorToTable(openDay2V2), VectorToTable(openDay3V3), mode, level, star, score, VectorToTable(skillIds), VectorToTable(propIds), level2, star2, score2, VectorToTable(skillIds2), VectorToTable(propIds2), protectNum)
end

--@brief    获取战略赛技能道具池结果（TRIO_GetZlsSkillListOk = 53）
function ProtocolProcessorScenePvpStrategic:parse_TRIO_GetZlsSkillListOk(ids, skillIds, propIds, skillIds2, propIds2)
    -- ids : 战略赛所有技能道具ID集合
    -- skillIds : 玩家2V2模式携带的技能
    -- propIds : 玩家2V2模式携带的道具
    -- skillIds2 : 玩家3V3模式携带的技能
    -- propIds2 : 玩家3V3模式携带的道具
    WZLog("ProtocolProcessorScenePvpStrategic:parse_TRIO_GetZlsSkillListOk", 
        "\n ids =",Serialize(VectorToTable(ids)), 
        "\n skillIds =",Serialize(VectorToTable(skillIds)), 
        "\n propIds =",Serialize(VectorToTable(propIds)), 
        "\n skillIds2 =",Serialize(VectorToTable(skillIds2)), 
        "\n propIds2 =",Serialize(VectorToTable(propIds2)))

    WndPvpStrategicSkillProp:getZlsSkillListOk(VectorToTable(ids), VectorToTable(skillIds), VectorToTable(propIds), VectorToTable(skillIds2), VectorToTable(propIds2))
end

--@brief    装备战略赛技能/道具结果（TRIO_EquipZlsSkillOk = 55）
function ProtocolProcessorScenePvpStrategic:parse_TRIO_EquipZlsSkillOk(result, doType, mode, ids)
    -- result : 装备战略赛技能结果【0=成功|1=失败-装备的技能数量不合法|2=装备的技能不合法】
    -- doType : 操作类型【1=装备技能|2=装备道具】
    -- mode : 战略赛人数模式【2=2V2模式|3=3V3模式】
    -- ids : 装备后的技能/道具ID集合
    WZLog("ProtocolProcessorScenePvpStrategic:parse_TRIO_EquipZlsSkillOk", 
        "\n result =",Serialize(VectorToTable(result)), 
        "\n doType =",Serialize(VectorToTable(doType)), 
        "\n mode =",Serialize(VectorToTable(mode)), 
        "\n ids =",Serialize(VectorToTable(ids)))

    WndPvpStrategicSkillProp:equipZlsSkillOk(result, doType, mode, VectorToTable(ids))
    ScenePvpStrategic:equipZlsSkillOk(result, doType, mode, VectorToTable(ids))
end

--@brief    获取战略赛历届赛季信息结果（TRIO_GetZlsSeasonInfoListOk = 57）
function ProtocolProcessorScenePvpStrategic:parse_TRIO_GetZlsSeasonInfoListOk(season, startDate, endDate, finishLevel, finishStar, maxLevel, maxStar, joinNum, winNum, mvpNum, assists, lianWinMax)
    -- season : 第几赛季
    -- startDate : 赛季起始日期时间戳秒
    -- endDate : 赛季结束日期时间戳秒
    -- finishLevel : 赛季最终等级
    -- finishStar : 赛季最终星级[达到最高段位后才有用]
    -- maxLevel : 赛季最高等级
    -- maxStar : 赛季最高星级[达到最高段位后才有用]
    -- joinNum : 赛季参赛场数
    -- winNum : 赛季胜利场数
    -- mvpNum : 赛季MVP次数
    -- assists : 赛季助攻次数
    -- lianWinMax : 赛季最高连胜
    WZLog("ProtocolProcessorScenePvpStrategic:parse_TRIO_GetZlsSeasonInfoListOk", 
        "\n season = ",Serialize(VectorToTable(season)), 
        "\n startDate = ",Serialize(VectorToTable(startDate)), 
        "\n endDate = ",Serialize(VectorToTable(endDate)), 
        "\n finishLevel = ",Serialize(VectorToTable(finishLevel)), 
        "\n finishStar = ",Serialize(VectorToTable(finishStar)), 
        "\n maxLevel = ",Serialize(VectorToTable(maxLevel)), 
        "\n maxStar = ",Serialize(VectorToTable(maxStar)), 
        "\n joinNum = ",Serialize(VectorToTable(joinNum)), 
        "\n winNum = ",Serialize(VectorToTable(winNum)), 
        "\n mvpNum = ",Serialize(VectorToTable(mvpNum)), 
        "\n assists = ",Serialize(VectorToTable(assists)), 
        "\n lianWinMax = ",Serialize(VectorToTable(lianWinMax)))

    ScenePvpStrategic:getZlsSeasonInfoListOk(VectorToTable(season), VectorToTable(startDate), VectorToTable(endDate), VectorToTable(finishLevel), VectorToTable(finishStar), VectorToTable(maxLevel), VectorToTable(maxStar), VectorToTable(joinNum), VectorToTable(winNum), VectorToTable(mvpNum), VectorToTable(assists), VectorToTable(lianWinMax))
end

--@brief    获取战略赛排行榜结果（TRIO_GetZlsRankListOk = 59）
function ProtocolProcessorScenePvpStrategic:parse_TRIO_GetZlsRankListOk(mode, rank, serverId, playerId, name, faceId, headId, headColour, sex, level, vipLevel, zlsLevel, zlsStar, zlsScore, battleTimes, winTimes, playerRank, playerZlsLevel, playerZlsStar, playerZlsSocre)
    -- mode : 战略赛人数模式【2=2V2模式排行榜|3=3V3模式排行榜】
    -- rank : 排名
    -- serverId : 服id
    -- playerId : 玩家id
    -- name : 玩家名称
    -- faceId : 脸id
    -- headId : 头id
    -- headColour : 头颜色
    -- sex : 性别
    -- level : 等级
    -- vipLevel : vip等级
    -- zlsLevel : 战略赛等级
    -- zlsStar : 战略赛星级
    -- zlsScore : 战略赛积分
    -- battleTimes : 参战的场数【预留，空数组】
    -- winTimes : 胜利的场数【预留，空数组】
    -- playerRank : 玩家个人排名
    -- playerZlsLevel : 玩家个人战略赛等级
    -- playerZlsStar : 玩家个人战略赛星级
    -- playerZlsSocre : 玩家个人战略赛积分
    WZLog("ProtocolProcessorScenePvpStrategic:parse_TRIO_GetZlsRankListOk", 
        "\n mode =",Serialize(VectorToTable(mode)), 
        "\n rank =",Serialize(VectorToTable(rank)), 
        "\n serverId =",Serialize(VectorToTable(serverId)), 
        "\n playerId =",Serialize(VectorToTable(playerId)), 
        "\n name =",Serialize(VectorToTable(name)), 
        "\n faceId =",Serialize(VectorToTable(faceId)), 
        "\n headId =",Serialize(VectorToTable(headId)), 
        "\n headColour =",Serialize(VectorToTable(headColour)), 
        "\n sex =",Serialize(VectorToTable(sex)), 
        "\n level =",Serialize(VectorToTable(level)), 
        "\n vipLevel =",Serialize(VectorToTable(vipLevel)), 
        "\n zlsLevel =",Serialize(VectorToTable(zlsLevel)), 
        "\n zlsStar =",Serialize(VectorToTable(zlsStar)), 
        "\n zlsScore =",Serialize(VectorToTable(zlsScore)), 
        "\n battleTimes =",Serialize(VectorToTable(battleTimes)), 
        "\n winTimes =",Serialize(VectorToTable(winTimes)), 
        "\n playerRank =",Serialize(VectorToTable(playerRank)), 
        "\n playerZlsLevel =",Serialize(VectorToTable(playerZlsLevel)), 
        "\n playerZlsStar =",Serialize(VectorToTable(playerZlsStar)), 
        "\n playerZlsSocre =",Serialize(VectorToTable(playerZlsSocre)))

    WndPvpStrategicRank:getZlsRankListOk(mode, VectorToTable(rank), VectorToTable(serverId), VectorToTable(playerId), VectorToTable(name), VectorToTable(faceId), VectorToTable(headId), VectorToTable(headColour), VectorToTable(sex), VectorToTable(level), VectorToTable(vipLevel), VectorToTable(zlsLevel), VectorToTable(zlsStar), VectorToTable(zlsScore), VectorToTable(battleTimes), VectorToTable(winTimes), playerRank, playerZlsLevel, playerZlsStar, playerZlsSocre)
end

-------------------------------------协议错误处理方法模块--------------------------------------

--@brief    创建房间（ROOM_CreateRoom = 1）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorScenePvpStrategic:send_ROOM_CreateRoom_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorScenePvpStrategic:send_ROOM_CreateRoom_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ROOM, Protocol.ROOM_CreateRoom, nFlag, sMessage)
end

--@brief    快速游戏（ROOM_QuickGame = 13）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorScenePvpStrategic:send_ROOM_QuickGame_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorScenePvpStrategic:send_ROOM_QuickGame_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ROOM, Protocol.ROOM_QuickGame, nFlag, sMessage)
end

-- --@brief    查找房间错误处理函数(S->C)
-- --@param    nFlag:标志位
-- --@param    sMessage:错误信息
-- --@note 在此对协议错误进行相应处理
-- function ProtocolProcessorScenePvpStrategic:send_ROOM_SelectRoom_ErrorProcess(nFlag, sMessage)
--     WZLog("ProtocolProcessorScenePvpStrategic:send_ROOM_SelectRoom_ErrorProcess")
--     ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ROOM, Protocol.ROOM_SelectRoom, nFlag, sMessage)
-- end

--@brief    取消随机配对对战用户（ROOM_EndPair = 34）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorScenePvpStrategic:send_ROOM_EndPair_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorScenePvpStrategic:send_ROOM_EndPair_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ROOM, Protocol.ROOM_EndPair, nflag, sMessage)
end


--@brief    获取战略赛信息（TRIO_GetZlsBattleInfo = 50）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorScenePvpStrategic:send_TRIO_GetZlsBattleInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorScenePvpStrategic:parse_TRIO_GetZlsBattleInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TRIO, Protocol.TRIO_GetZlsBattleInfo, nflag, sMessage)
end

--@brief    获取战略赛技能道具池（TRIO_GetZlsSkillList = 52）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorScenePvpStrategic:send_TRIO_GetZlsSkillList_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorScenePvpStrategic:parse_TRIO_GetZlsSkillList_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TRIO, Protocol.TRIO_GetZlsSkillList, nflag, sMessage)
end

--@brief    装备战略赛技能/道具（TRIO_EquipZlsSkill = 54）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorScenePvpStrategic:send_TRIO_EquipZlsSkill_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorScenePvpStrategic:parse_TRIO_EquipZlsSkill_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TRIO, Protocol.TRIO_EquipZlsSkill, nflag, sMessage)
end

--@brief    获取战略赛历届赛季信息（TRIO_GetZlsSeasonInfoList = 56）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorScenePvpStrategic:send_TRIO_GetZlsSeasonInfoList_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorScenePvpStrategic:parse_TRIO_GetZlsSeasonInfoList_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TRIO, Protocol.TRIO_GetZlsSeasonInfoList, nflag, sMessage)
end

--@brief    获取战略赛排行榜（TRIO_GetZlsRankList = 58）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorScenePvpStrategic:send_TRIO_GetZlsRankList_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorScenePvpStrategic:parse_TRIO_GetZlsRankList_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TRIO, Protocol.TRIO_GetZlsRankList, nflag, sMessage)
end








