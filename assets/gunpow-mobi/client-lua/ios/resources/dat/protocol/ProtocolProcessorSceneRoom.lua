--ProtocolProcessorSceneRoom.lua
--@brief	大厅房间协议
--@date  	2013/12/10
--@author 	李光森
--@note 	大厅房间使用的协议


ProtocolProcessorSceneRoom = ProtocolProcessorBase:new()

-------------------------------------公有方法模块--------------------------------------

--@brief	注册协议组所有协议
function ProtocolProcessorSceneRoom:regAll()
	
	--数据表
	self.m_tData = nil
	--@brief	通知所有玩家正在随机配对对战用户
	self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_MakePair, "ProtocolProcessorSceneRoom:parse_ROOM_MakePair", "i")
	--@brief	随机配对成功同步对战玩家数据
    self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_MakePairOk, "ProtocolProcessorSceneRoom:parse_ROOM_MakePairOk", "iiiiiivivivsvsvsvsvivivivivivivivivivivivivivivivivivivivivivivivivsvivivsvivivivivivivivsvsvnvivivbvii")

	--@brief	退出房间成功
	self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_QuitRoomOk, "ProtocolProcessorSceneRoom:parse_ROOM_QuitRoomOk", "b")
	
	--@brief	邀请战斗错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_Invite, "ProtocolProcessorSceneRoom:send_ROOM_Invite_ErrorProcess", "is" )
	--@brief	玩家准备错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_GameReady, "ProtocolProcessorSceneRoom:send_ROOM_GameReady_ErrorProcess", "is" )
	--@brief	通知所有玩家正在随机配对对战用户
	self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_MakePairFail, "ProtocolProcessorSceneRoom:parse_ROOM_MakePairFail", "")
	--@brief	房主更新房间属性错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_UpdateRoom, "ProtocolProcessorSceneRoom:send_ROOM_UpdateRoom_ErrorProcess", "is" )
	--@brief	退出房间错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_QuitRoom, "ProtocolProcessorSceneRoom:send_ROOM_QuitRoom_ErrorProcess", "is" )
	--@brief	玩家更换座位错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_UpdateSeat, "ProtocolProcessorSceneRoom:send_ROOM_UpdateSeat_ErrorProcess", "is" )
	--@brief	随机配对对战用户错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_MakePair, "ProtocolProcessorSceneRoom:parse_ROOM_MakePair_ErrorProcess", "is")
    --@brief	开启座位（ROOM_TurnOnSeat = 28）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_TurnOnSeat, "ProtocolProcessorSceneRoom:send_ROOM_TurnOnSeat_ErrorProcess", "is" )
    --@brief	关闭座位（ROOM_TurnOffSeat = 29）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_TurnOffSeat, "ProtocolProcessorSceneRoom:send_ROOM_TurnOffSeat_ErrorProcess", "is" )
    
    --@brief	取消随机配对对战用户（ROOM_EndPair = 34）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_EndPair , "ProtocolProcessorSceneRoom:send_ROOM_EndPair_ErrorProcess", "is" )
    --@brief    公会战排名（GUILDWAR_MyGuildWarRank = 28）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_MyGuildWarRank, "ProtocolProcessorSceneRoom:send_GUILDWAR_MyGuildWarRank_ErrorProcess", "is" )

    --@brief	退出匹配成功（ROOM_EndPairOk = 35）
    self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_EndPairOk, "ProtocolProcessorSceneRoom:parse_ROOM_EndPairOk", "")
    --@brief    公会战排名（GUILDWAR_MyGuildWarRankOk = 29）
    self:regProtocolCallbackFunction( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_MyGuildWarRankOk, "ProtocolProcessorSceneRoom:parse_GUILDWAR_MyGuildWarRankOk", "i")

end

--@brief	反注册协议组所有协议
function ProtocolProcessorSceneRoom:unregAll()
	self.m_tData = nil
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块--------------------------------------

--@brief	退出房间
function ProtocolProcessorSceneRoom:send_ROOM_QuitRoom(roomId, oldSeat )
	WZLog("send_ROOM_QuitRoom")
	local sender = Protocol:getSender( Protocol.MAIN_ROOM, Protocol.ROOM_QuitRoom )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( roomId )	-- 房间Id
	sender:writeInt( oldSeat )	-- 玩家所在的座位位置
	SendProtocol(sender,false) --true:showLoading
end

--@brief	邀请战斗
function ProtocolProcessorSceneRoom:send_ROOM_Invite(roomId, playerId )
	WZLog("send_ROOM_Invite",roomId, playerId)
	local sender = Protocol:getSender( Protocol.MAIN_ROOM, Protocol.ROOM_Invite )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( roomId )	-- 房间ID
	sender:writeInt( playerId )	-- 玩家Id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	玩家准备
function ProtocolProcessorSceneRoom:send_ROOM_GameReady(roomId, oldSeat, ready )
	WZLog("send_ROOM_GameReady")
	local sender = Protocol:getSender( Protocol.MAIN_ROOM, Protocol.ROOM_GameReady )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( roomId )	-- 房间Id
	sender:writeInt( oldSeat )	-- 玩家所在的座位位置
	sender:writeBoolean( ready )	-- rrue准备，false取消准备
	SendProtocol(sender,false) --true:showLoading
end

--@brief	随机配对对战用户
function ProtocolProcessorSceneRoom:send_ROOM_MakePair(roomId,channel,schedule,battleMode)
	WZLog("send_ROOM_MakePair =",roomId,channel,schedule,battleMode)
	local sender = Protocol:getSender( Protocol.MAIN_ROOM, Protocol.ROOM_MakePair )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( roomId )	-- 房间Id
	sender:writeInt( channel )	-- 房间所属频道
	sender:writeInt( schedule )	-- 赛程
	sender:writeInt( battleMode )	-- 战斗模式
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获得地图列表
function ProtocolProcessorSceneRoom:send_MAP_GetMapList( )
	WZLog("send_MAP_GetMapList")
	--local sender = Protocol:getSender( Protocol.MAIN_MAP, Protocol.MAP_GetMapList )
	--if sender==nil then WZLog("sender == nil") return end

	--SendProtocol(sender,false) --true:showLoading
end

--@brief	房主更新房间属性
function ProtocolProcessorSceneRoom:send_ROOM_UpdateRoom(roomId, battleMode, playerNumMode, passWord, mapId, startMode,roomName)
	WZLog("send_ROOM_UpdateRoom ")
	local sender = Protocol:getSender( Protocol.MAIN_ROOM, Protocol.ROOM_UpdateRoom )
	if sender==nil then WZLog("sender == nil") return end
	sender:writeInt( roomId )	-- 房间Id
	sender:writeInt( battleMode )	-- 战斗模式
	sender:writeInt( playerNumMode )	-- 对战人数模式
	sender:writeString( passWord )	-- 房间密码
	sender:writeInt( mapId )	-- 房间地图id
	sender:writeInt( startMode )	-- 撮合方式
	sender:writeString( roomName )	-- 房间名称
	SendProtocol(sender,false) --true:showLoading
end

--@brief	玩家更换座位
function ProtocolProcessorSceneRoom:send_ROOM_UpdateSeat(roomId, oldSeat, newSeat )
	WZLog("send_ROOM_UpdateSeat")
	local sender = Protocol:getSender( Protocol.MAIN_ROOM, Protocol.ROOM_UpdateSeat )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( roomId )	-- 房间Id
	sender:writeInt( oldSeat )	-- 玩家所在的座位位置
	sender:writeInt( newSeat )	-- 玩家新座位位置
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取玩家技能
function ProtocolProcessorSceneRoom:send_PLAYER_GetPlayerSkill( )
	WZLog("send_PLAYER_GetPlayerSkill")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerSkill )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	位置开关（ROOM_SeatSwitch = 23）
function ProtocolProcessorSceneRoom:send_ROOM_SeatSwitch(roomId, seatIndex )
	WZLog("send_ROOM_SeatSwitch")
	local sender = Protocol:getSender( Protocol.MAIN_ROOM, Protocol.ROOM_SeatSwitch )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( roomId )	-- 房ID
	sender:writeInts( seatIndex )	-- 座位序号
	SendProtocol(sender,false) --true:showLoading
end

--@brief	开启座位（ROOM_TurnOnSeat = 28）
function ProtocolProcessorSceneRoom:send_ROOM_TurnOnSeat(roomId, seatIndex )
	WZLog("send_ROOM_TurnOnSeat")
	local sender = Protocol:getSender( Protocol.MAIN_ROOM, Protocol.ROOM_TurnOnSeat )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( roomId )	-- 房间ID
	sender:writeInt( seatIndex )	-- 座位下标（从0开始）
	SendProtocol(sender,false) --true:showLoading
end

--@brief	关闭座位（ROOM_TurnOffSeat = 29）
function ProtocolProcessorSceneRoom:send_ROOM_TurnOffSeat(roomId, seatIndex )
	WZLog("send_ROOM_TurnOffSeat")
	local sender = Protocol:getSender( Protocol.MAIN_ROOM, Protocol.ROOM_TurnOffSeat )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( roomId )	-- 房间ID
	sender:writeInt( seatIndex )	-- 座位下标（从0开始）
	SendProtocol(sender,false) --true:showLoading
end

--@brief	取消随机配对对战用户（ROOM_EndPair = 34）
function ProtocolProcessorSceneRoom:send_ROOM_EndPair(roomId)
	WZLog("send_ROOM_EndPair ")
	local sender = Protocol:getSender( Protocol.MAIN_ROOM, Protocol.ROOM_EndPair  )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( roomId )	-- 房间Id
	SendProtocol(sender,false) --true:showLoading
end

--@brief    公会战排名（GUILDWAR_MyGuildWarRank = 28）
function ProtocolProcessorSceneRoom:send_GUILDWAR_MyGuildWarRank(warType )
    WZLog("send_GUILDWAR_MyGuildWarRank")
    local sender = Protocol:getSender( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_MyGuildWarRank )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( warType )  -- 公会战类型（1为出线赛，2为入围赛）
    SendProtocol(sender,false) --true:showLoading
end

-------------------------------------服务器到客户端协议回调方法模块--------------------------------------

--@brief	通知所有玩家正在随机配对对战用户
function ProtocolProcessorSceneRoom:parse_ROOM_MakePair(roomId)
	-- roomId : 房间Id
	WZLog("ProtocolProcessorSceneRoom:parse_ROOM_MakePair")
	SceneRoom:receiveMakePairring(roomId)
	SceneGuildWarRoom:receiveMakePairring(roomId)
end

--@brief	通知所有玩家正在随机配对对战用户
function ProtocolProcessorSceneRoom:parse_ROOM_MakePairFail()
	WZLog("ProtocolProcessorSceneRoom:parse_ROOM_MakePairFail")
	SceneRoom:receiveMakePairFail()
	SceneGuildWarRoom:receiveMakePairFail()
end

--@brief	副本随机配对成功同步对战玩家数据
function ProtocolProcessorSceneRoom:parse_ROOM_MakePairOk(battleId,battleMode,battleChannle,schedule,
mapId, playerCount, playerCamp,playerId, serverId, playerName, playerTitle, playerCommunity, playerLevel,
playerSex, maxHP, maxPF, maxSP, attack, critRate, defence, injuryFree, wreckDefense, reduceCrit, power, armor,
constitution, agility, lucky, winRate, fighting, headId, faceId, bodyId, weaponId, wingId, item_id, petSkill,
playerBuffCount, buffId, petId, petParam, battleTimes, winTimes, streakTimes, segmentLevel,tournamentLevel,
teamId,teamName,url,petLevel, colour, bodyColour,isCaptain,footmark, monsterId)
    -- battleId : 战斗组Id
    -- battleId : 战斗模式
    -- playerCount : 玩家数量
    -- playerId : 所有玩家id
    -- playerName : 房间内玩家昵称
    -- playerTitle : 称号
    -- playerCommunity : 公会名称

    -- playerLevel : 房间内玩家等级
    -- playerSex : 玩家性别（0男1女）
    -- maxHP : 最大血量
    -- maxPF : 最大体力值
    -- maxSP : 最大怒气
    -- attack : 普攻击力
    -- critRate : 爆击攻击力比率
    -- defence : 防御力
    -- injuryFree : 免伤(10000)
    -- wreckDefense : 破防(10000)
    -- reduceCrit : 免暴(10000)
    -- reduceBury : 免坑(10000)
    -- power : 力量
    -- armor : 护甲
    -- constitution : 体质
    -- agility : 敏捷
    -- lucky : 幸运
    -- headId : 着装串头
    -- faceId : 着装串脸
    -- bodyId : 着装串身
    -- weaponId : 着装串武器
    -- wingId : 着装翅膀
    -- item_id : 技能道具ID（0没装备，-1锁, 其他ID）
    -- playerBuffCount : 表示每一个player,buff的数量,如果没有要填零
    -- buffId : 玩家BUFFID
    -- petId : 宠物id，0表示无宠物
    -- petSkillId : 宠物技能id（每个宠物固定两个技能没有则填0）

    -- petParam : 宠物属性参数

    WZLog("ProtocolProcessorSceneRoom:parse_ROOM_MakePairOk")
    local roomLua = SceneRoom
	if battleChannle == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_GZ then
    	roomLua = SceneGuildWarRoom
	end
	roomLua:receiveMakePairOk(VectorToTable(battleId), battleMode, battleChannle, schedule,
		VectorToTable(mapId), VectorToTable(playerCount), VectorToTable(playerCamp), VectorToTable(playerId), 
		VectorToTable(serverId),VectorToTable(playerName), VectorToTable(playerTitle), VectorToTable(playerCommunity), 
		VectorToTable(playerLevel), VectorToTable(playerSex), VectorToTable(maxHP), VectorToTable(maxPF), 
		VectorToTable(maxSP), VectorToTable(attack), VectorToTable(critRate), VectorToTable(defence), 
		VectorToTable(injuryFree), VectorToTable(wreckDefense), VectorToTable(reduceCrit), 
		VectorToTable(reduceBury), VectorToTable(power), VectorToTable(armor), VectorToTable(constitution), 
		VectorToTable(agility), VectorToTable(lucky), VectorToTable(winRate), VectorToTable(fighting), 
		VectorToTable(headId), VectorToTable(faceId), VectorToTable(bodyId), VectorToTable(weaponId), 
		VectorToTable(wingId), VectorToTable(item_id), VectorToTable(playerBuffCount), VectorToTable(buffId), 
		VectorToTable(petId), VectorToTable(petSkill), VectorToTable(petParam), VectorToTable(weaponSkill), 
		VectorToTable(tournamentLevel),VectorToTable(teamId),VectorToTable(teamName),VectorToTable(url),
		VectorToTable(petLevel),VectorToTable(colour),VectorToTable(bodyColour),VectorToTable(isCaptain),VectorToTable(footmark), monsterId)

    WZLog("ProtocolProcessorSceneRoom:parse_ROOM_MakePairOk two", battleMode, battleChannle, schedule,"\n\nbattleId",serverId,

    Serialize(VectorToTable(battleId)),Serialize(VectorToTable(mapId)),Serialize(VectorToTable(playerCount)),Serialize(VectorToTable(playerCamp)),Serialize(VectorToTable(playerId)),Serialize(VectorToTable(playerName)),Serialize(VectorToTable(playerTitle)),Serialize(VectorToTable(playerCommunity)),"\n\nplayerLevel",

    Serialize(VectorToTable(playerLevel)),Serialize(VectorToTable(playerSex)),Serialize(VectorToTable(maxHP)),Serialize(VectorToTable(maxPF)),Serialize(VectorToTable(maxSP)),Serialize(VectorToTable(attack)),Serialize(VectorToTable(critRate)),Serialize(VectorToTable(defence)),Serialize(VectorToTable(injuryFree)),"\n\nwreckDefense",

    Serialize(VectorToTable(wreckDefense)),Serialize(VectorToTable(reduceCrit)),Serialize(VectorToTable(power)),Serialize(VectorToTable(armor)),Serialize(VectorToTable(constitution)),Serialize(VectorToTable(agility)),Serialize(VectorToTable(lucky)),"\n\nheadId",

    Serialize(VectorToTable(headId)),Serialize(VectorToTable(faceId)),Serialize(VectorToTable(bodyId)),Serialize(VectorToTable(weaponId)),Serialize(VectorToTable(wingId)),Serialize(VectorToTable(item_id)),Serialize(VectorToTable(playerBuffCount)),Serialize(VectorToTable(buffId)),"\n\npetId",

        Serialize(VectorToTable(petId)),Serialize(VectorToTable(petParam)), "\n\nweaponSkill",
        Serialize(VectorToTable(weaponSkill)),
        "\npetSkill:", Serialize(VectorToTable(petSkill)),
        "\npetLevel:", Serialize(VectorToTable(petLevel)),
        Serialize(VectorToTable(tournamentLevel)),
        Serialize(VectorToTable(colour)),Serialize(VectorToTable(bodyColour)),
        "\nisCaptain:", Serialize(VectorToTable(isCaptain)))

end

--@brief	退出房间成功
function ProtocolProcessorSceneRoom:parse_ROOM_QuitRoomOk(mark)
	-- mark : 是否被踢
	WZLog("ProtocolProcessorSceneRoom:parse_ROOM_QuitRoomOk")
	SceneRoom:receiveQuitRoomOk(mark)
	SceneGuildWarRoom:receiveQuitRoomOk(mark)
end

--@brief	退出匹配成功（ROOM_EndPairOk = 35）
function ProtocolProcessorSceneRoom:parse_ROOM_EndPairOk()
	WZLog("ProtocolProcessorSceneRoom:parse_ROOM_EndPairOk")
	SceneRoom:cancelMatchingOk()
	SceneGuildWarRoom:cancelMatchingOk()
end

--@brief    公会战排名（GUILDWAR_MyGuildWarRankOk = 29）
function ProtocolProcessorSceneRoom:parse_GUILDWAR_MyGuildWarRankOk(rank)
    -- rank : 玩家所在公会排名（-1为没上榜）
    WZLog("ProtocolProcessorSceneRoom:parse_GUILDWAR_MyGuildWarRankOk")
    SceneGuildWarRoom:updateRewardItem(rank)
end

------------------------------------------------------------------------------------------

--@brief	房主更新房间属性错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneRoom:send_ROOM_UpdateRoom_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneRoom:send_ROOM_UpdateRoom_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ROOM, Protocol.ROOM_UpdateRoom, nflag, sMessage)
end

--@brief	退出房间错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneRoom:send_ROOM_QuitRoom_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneRoom:send_ROOM_QuitRoom_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ROOM, Protocol.ROOM_QuitRoom, nflag, sMessage)
end

--@brief	邀请战斗错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneRoom:send_ROOM_Invite_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneRoom:send_ROOM_Invite_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ROOM, Protocol.ROOM_Invite, nflag, sMessage)
end

--@brief	随机配对对战用户错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneRoom:send_ROOM_MakePair_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneRoom:send_ROOM_MakePair_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ROOM, Protocol.ROOM_MakePair, nflag, sMessage)
end

--@brief	玩家更换座位错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneRoom:send_ROOM_UpdateSeat_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneRoom:send_ROOM_UpdateSeat_ErrorProcess")
	--MsgBoxManager:showTipBox(sMessage)
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ROOM, Protocol.ROOM_UpdateSeat, nflag, sMessage)
end

--@brief	随机配对对战用户错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneRoom:parse_ROOM_MakePair_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneRoom:parse_ROOM_MakePair_ErrorProcess")
	SceneRoom:receiveMakePairError(nFlag, sMessage)
	SceneGuildWarRoom:receiveMakePairError(nFlag, sMessage)
end

--@brief	开启座位（ROOM_TurnOnSeat = 28）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneRoom:send_ROOM_TurnOnSeat_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneRoom:send_ROOM_TurnOnSeat_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ROOM, Protocol.ROOM_TurnOnSeat, nflag, sMessage)
end

--@brief	关闭座位（ROOM_TurnOffSeat = 29）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneRoom:send_ROOM_TurnOffSeat_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneRoom:send_ROOM_TurnOffSeat_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ROOM, Protocol.ROOM_TurnOffSeat, nflag, sMessage)
end

--@brief	取消随机配对对战用户（ROOM_EndPair = 34）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneRoom:send_ROOM_EndPair_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneRoom:send_ROOM_EndPair_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ROOM, Protocol.ROOM_EndPair , nflag, sMessage)
	SceneRoom:closeLoading()
end

--@brief  发送改变准备状态协议错误
function ProtocolProcessorSceneRoom:send_ROOM_GameReady_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneRoom:send_ROOM_GameReady_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ROOM, Protocol.ROOM_GameReady,nflag,sMessage)
	SceneRoom:closeLoading()
end

--@brief    公会战排名（GUILDWAR_MyGuildWarRank = 28）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorSceneRoom:send_GUILDWAR_MyGuildWarRank_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorSceneRoom:send_GUILDWAR_MyGuildWarRank_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_MyGuildWarRank, nflag, sMessage)
end