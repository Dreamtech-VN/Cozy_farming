--ProtocolProcessorWorldTeamBossRoom.lua
--@brief	世界组队副本房间协议
--@date  	2018/07/13
--@author 	Tianxiang_Xu
--@note 	世界组队副本房间协议


ProtocolProcessorWorldTeamBossRoom = ProtocolProcessorBase:new()

-------------------------------------公有方法模块--------------------------------------

--@brief	注册协议组所有协议
function ProtocolProcessorWorldTeamBossRoom:regAll()
	--@brief	开始战斗（TEAMWORLDBOSS_MakePair = 3）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_MakePair, "ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_MakePair_ErrorProcess", "is" )
	--@brief	创建房间（TEAMWORLDBOSS_CreateRoom = 5）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_CreateRoom, "ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_CreateRoom_ErrorProcess", "is" )
	--@brief	准备（TEAMWORLDBOSS_GameReady = 7）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_GameReady, "ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_GameReady_ErrorProcess", "is" )
	--@brief	快速开始游戏（TEAMWORLDBOSS_QuickGame = 9）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_QuickGame, "ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_QuickGame_ErrorProcess", "is" )
	--@brief	退出房间（TEAMWORLDBOSS_QuitRoom = 10）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_QuitRoom, "ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_QuitRoom_ErrorProcess", "is" )
	--@brief	更新房间（TEAMWORLDBOSS_UpdateRoom = 12）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_UpdateRoom, "ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_UpdateRoom_ErrorProcess", "is" )
	--@brief	鼓舞（TEAMWORLDBOSS_Inspire = 18）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_Inspire, "ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_Inspire_ErrorProcess", "is" )
	--@brief	获取组队世界boss当前血量（TEAMWORLDBOSS_GetTeamWorldBossHp = 22）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_GetTeamWorldBossHp, "ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_GetTeamWorldBossHp_ErrorProcess", "is" )
	--@brief	选择房间（TEAMWORLDBOSS_SelectRoom = 24）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_SelectRoom, "ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_SelectRoom_ErrorProcess", "is" )
	--@brief	获取大厅信息（TEAMWORLDBOSS_GetRoomState = 26）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_GetRoomState, "ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_GetRoomState_ErrorProcess", "is" )
	--@brief	组队世界boss排行（TEAMWORLDBOSS_GetHurtRank = 28）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_GetHurtRank, "ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_GetHurtRank_ErrorProcess", "is" )
	--@brief	房间列表（TEAMWORLDBOSS_GetRoomList = 14）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_GetRoomList, "ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_GetRoomList_ErrorProcess", "is" )
	--@brief	购买挑战次数（TEAMWORLDBOSS_BuyChallengeNum = 31）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_BuyChallengeNum, "ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_BuyChallengeNum_ErrorProcess", "is" )
	--@brief	邀请（TEAMWORLDBOSS_Invite = 33）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_Invite, "ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_Invite_ErrorProcess", "is" )
	--@brief	返回房间（TEAMWORLDBOSS_BackToRoom = 35）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_BackToRoom, "ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_BackToRoom_ErrorProcess", "is" )

	--@brief	开始战斗（TEAMWORLDBOSS_MakePairOk = 4）
	self:regProtocolCallbackFunction( Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_MakePairOk, "ProtocolProcessorWorldTeamBossRoom:parse_TEAMWORLDBOSS_MakePairOk", "iiivivsvsvsvsvivivivivivivivivivivivivivivivivivivivivivivivsvivivsvivivivsvsvivnvivivi")
	--@brief	进入房间成功（TEAMWORLDBOSS_EnterRoomOk = 6）
	self:regProtocolCallbackFunction( Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_EnterRoomOk, "ProtocolProcessorWorldTeamBossRoom:parse_TEAMWORLDBOSS_EnterRoomOk", "issiiiivbvivivsvivbvivivivivsvivivivivsvsvivissssssvivivivivivivivivivi")
	--@brief	退出房间（TEAMWORLDBOSS_QuitRoomOk = 11）
	self:regProtocolCallbackFunction( Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_QuitRoomOk, "ProtocolProcessorWorldTeamBossRoom:parse_TEAMWORLDBOSS_QuitRoomOk", "b")
	--@brief	获取组队世界boss当前血量（TEAMWORLDBOSS_GetTeamWorldBossHpOk = 23）
	self:regProtocolCallbackFunction( Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_GetTeamWorldBossHpOk, "ProtocolProcessorWorldTeamBossRoom:parse_TEAMWORLDBOSS_GetTeamWorldBossHpOk", "ss")
	--@brief	鼓舞（TEAMWORLDBOSS_InspireOk = 25）
	self:regProtocolCallbackFunction( Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_InspireOk, "ProtocolProcessorWorldTeamBossRoom:parse_TEAMWORLDBOSS_InspireOk", "iii")
	--@brief	获取大厅信息（TEAMWORLDBOSS_GetRoomStateOk = 27）
	self:regProtocolCallbackFunction( Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_GetRoomStateOk, "ProtocolProcessorWorldTeamBossRoom:parse_TEAMWORLDBOSS_GetRoomStateOk", "isiiiiiiis")
	--@brief	组队世界boss排行（TEAMWORLDBOSS_GetHurtRankOk = 29）
	self:regProtocolCallbackFunction( Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_GetHurtRankOk, "ProtocolProcessorWorldTeamBossRoom:parse_TEAMWORLDBOSS_GetHurtRankOk", "vivsvbvivivivtviviviviii")
	--@brief	房间列表（TEAMWORLDBOSS_GetRoomListOk = 15）
	self:regProtocolCallbackFunction( Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_GetRoomListOk, "ProtocolProcessorWorldTeamBossRoom:parse_TEAMWORLDBOSS_GetRoomListOk", "ivivivivsvivbvsvivsvivivivtvi")
	--@brief	购买挑战次数（TEAMWORLDBOSS_BuyChallengeNumOk = 32）
	self:regProtocolCallbackFunction( Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_BuyChallengeNumOk, "ProtocolProcessorWorldTeamBossRoom:parse_TEAMWORLDBOSS_BuyChallengeNumOk", "i")

end

--@brief	反注册协议组所有协议
function ProtocolProcessorWorldTeamBossRoom:unregAll()
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief	开始战斗（TEAMWORLDBOSS_MakePair = 3）
function ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_MakePair(roomId )
	WZLog("send_TEAMWORLDBOSS_MakePair")
	local sender = Protocol:getSender( Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_MakePair )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( roomId )	-- 房间ID
	SendProtocol(sender,false) --true:showLoading
end

--@brief	创建房间（TEAMWORLDBOSS_CreateRoom = 5）
function ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_CreateRoom(roomName, password)
	WZLog("send_TEAMWORLDBOSS_CreateRoom")
	local sender = Protocol:getSender( Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_CreateRoom )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeString( roomName )	-- 房间名
	sender:writeString( password )	-- 密码
	SendProtocol(sender,false) --true:showLoading
end

--@brief	准备（TEAMWORLDBOSS_GameReady = 7）
function ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_GameReady(roomId, oldSeat, ready )
	WZLog("send_TEAMWORLDBOSS_GameReady")
	local sender = Protocol:getSender( Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_GameReady )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( roomId )	-- 房间ID
	sender:writeInt( oldSeat )	-- 位置
	sender:writeBoolean( ready )	-- 是否准备
	SendProtocol(sender,false) --true:showLoading
end

--@brief	快速开始游戏（TEAMWORLDBOSS_QuickGame = 9）
function ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_QuickGame( )
	WZLog("send_TEAMWORLDBOSS_QuickGame")
	local sender = Protocol:getSender( Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_QuickGame )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	退出房间（TEAMWORLDBOSS_QuitRoom = 10）
function ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_QuitRoom(roomId, oldSeat )
	WZLog("send_TEAMWORLDBOSS_QuitRoom")
	local sender = Protocol:getSender( Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_QuitRoom )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( roomId )	-- 房间ID
	sender:writeInt( oldSeat )	-- 位置
	SendProtocol(sender,false) --true:showLoading
end

--@brief	更新房间（TEAMWORLDBOSS_UpdateRoom = 12）
function ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_UpdateRoom(roomId, password, roomName )
	WZLog("send_TEAMWORLDBOSS_UpdateRoom")
	local sender = Protocol:getSender( Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_UpdateRoom )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( roomId )	-- 房间ID
	sender:writeString( password )	-- 密码
	sender:writeString( roomName )	-- 房间名
	SendProtocol(sender,false) --true:showLoading
end

--@brief	房间列表（TEAMWORLDBOSS_GetRoomList = 14）
function ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_GetRoomList( )
	WZLog("send_TEAMWORLDBOSS_GetRoomList")
	local sender = Protocol:getSender( Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_GetRoomList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end


--@brief	鼓舞（TEAMWORLDBOSS_Inspire = 18）
function ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_Inspire(itemId )
	WZLog("send_TEAMWORLDBOSS_Inspire")
	local sender = Protocol:getSender( Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_Inspire )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( itemId )	-- 物品ID
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取组队世界boss当前血量（TEAMWORLDBOSS_GetTeamWorldBossHp = 22）
function ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_GetTeamWorldBossHp( )
	WZLog("send_TEAMWORLDBOSS_GetTeamWorldBossHp")
	local sender = Protocol:getSender( Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_GetTeamWorldBossHp )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	选择房间（TEAMWORLDBOSS_SelectRoom = 24）
function ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_SelectRoom(roomId, password)
	WZLog("send_TEAMWORLDBOSS_SelectRoom")
	local sender = Protocol:getSender( Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_SelectRoom )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( roomId )	-- 房间ID
	sender:writeString( password )	-- 密码
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取大厅信息（TEAMWORLDBOSS_GetRoomState = 26）
function ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_GetRoomState( )
	WZLog("send_TEAMWORLDBOSS_GetRoomState")
	local sender = Protocol:getSender( Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_GetRoomState )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	组队世界boss排行（TEAMWORLDBOSS_GetHurtRank = 28）
function ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_GetHurtRank( )
	WZLog("send_TEAMWORLDBOSS_GetHurtRank")
	local sender = Protocol:getSender( Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_GetHurtRank )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	购买挑战次数（TEAMWORLDBOSS_BuyChallengeNum = 31）
function ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_BuyChallengeNum( )
	WZLog("send_TEAMWORLDBOSS_BuyChallengeNum")
	local sender = Protocol:getSender( Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_BuyChallengeNum )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	邀请（TEAMWORLDBOSS_Invite = 33）
function ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_Invite(roomId, playerId )
	WZLog("send_TEAMWORLDBOSS_Invite")
	local sender = Protocol:getSender( Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_Invite )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( roomId )	-- 房间ID
	sender:writeInt( playerId )	-- 玩家ID
	SendProtocol(sender,false) --true:showLoading
end

--@brief	返回房间（TEAMWORLDBOSS_BackToRoom = 35）
function ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_BackToRoom(roomId, mapId, playerId )
	WZLog("send_TEAMWORLDBOSS_BackToRoom")
	local sender = Protocol:getSender( Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_BackToRoom)
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( roomId )	-- 房间ID
	sender:writeInt( mapId )	-- 地图Id
	sender:writeInt( playerId )	-- 玩家ID
	SendProtocol(sender,false) --true:showLoading
end
-------------------------------------服务器到客户端协议回调方法模块--------------------------------------
--@brief	开始战斗（TEAMWORLDBOSS_MakePairOk = 4）
function ProtocolProcessorWorldTeamBossRoom:parse_TEAMWORLDBOSS_MakePairOk(battleId, mapId, playerCount, playerId, serverId, playerName, playerTitle, playerGuild, playerLevel, playerSex, maxHP, maxPF, maxSP, attack, critRate, defence, injuryFree, wreckDefense, reduceCrit, power, armor, constitution, agility, lucky, inspire, headId, faceId, bodyId, weaponId, wingId, item_id, skillId, playerBuffCount, buffId, petAnimation, petGift, guaiBattleId, guaiId, guaiMaxHP, guaiNowHP, guaiAttack, petAdvancedLevel, colour, bodycolour, footmark)
	-- battleId : 战斗组Id
	-- mapId : 地图id
	-- playerCount : 玩家数量
	-- playerId : 所有玩家id
	-- serverId : 玩家所在服ID
	-- playerName : 房间内玩家昵称
	-- playerTitle : 称号
	-- playerGuild : 公会名称
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
	-- power : 力量
	-- armor : 护甲
	-- constitution : 体质
	-- agility : 敏捷
	-- lucky : 幸运
	-- inspire : 鼓舞值
	-- headId : 头ID
	-- faceId : 脸ID
	-- bodyId : 身ID
	-- weaponId : 武器ID
	-- wingId : 翅膀ID
	-- item_id : 技能道具ID（0没装备，-1锁, 其他ID）
	-- skillId : 技能id
	-- playerBuffCount : 表示每一个player,buff的数量,如果没有要填零
	-- buffId : 玩家BUFFID
	-- petAnimation : 宠物形象，空字符串表示无宠物
	-- petGift : 宠物资质
	-- guaiBattleId : BOSS的战斗ID
	-- guaiId : BOSS怪表中的id
	-- guaiMaxHP : BOSS最大血量
	-- guaiNowHP : BOSS当前血量
	-- guaiAttack : BOSS攻击力
	-- petAdvancedLevel : 宠物进阶等级
	-- colour : 头部颜色
	-- bodycolour : 身颜色
	-- footmark : 足迹
	WZLog("ProtocolProcessorWorldTeamBossRoom:parse_TEAMWORLDBOSS_MakePairOk", colour:size())

	SceneWorldTeamBossRoom:receiveStartOk(battleId, mapId, playerCount, VectorToTable(playerId), VectorToTable(serverId), VectorToTable(playerName), VectorToTable(playerTitle), VectorToTable(playerGuild), VectorToTable(playerLevel), VectorToTable(playerSex), VectorToTable(maxHP), VectorToTable(maxPF), VectorToTable(maxSP), VectorToTable(attack), VectorToTable(critRate), VectorToTable(defence), VectorToTable(injuryFree), VectorToTable(wreckDefense), VectorToTable(reduceCrit), VectorToTable(power), VectorToTable(armor), VectorToTable(constitution), VectorToTable(agility), VectorToTable(lucky), VectorToTable(inspire), VectorToTable(headId), VectorToTable(faceId), VectorToTable(bodyId), VectorToTable(weaponId), VectorToTable(wingId), VectorToTable(item_id), VectorToTable(skillId), VectorToTable(playerBuffCount), VectorToTable(buffId), VectorToTable(petAnimation), VectorToTable(petGift), VectorToTable(guaiBattleId), VectorToTable(guaiId), VectorToTable(guaiMaxHP), VectorToTable(guaiNowHP), VectorToTable(guaiAttack), VectorToTable(petAdvancedLevel), VectorToTable(colour), VectorToTable(bodycolour), VectorToTable(footmark))
end

--@brief	进入房间成功（TEAMWORLDBOSS_EnterRoomOk = 6）
function ProtocolProcessorWorldTeamBossRoom:parse_TEAMWORLDBOSS_EnterRoomOk(roomId, passWord, roomName, playerNumMode, mapId, wnersId, playerNum, seatUsed, playerId, serviceId, playerName, playerLevel, playerReady, playerSex, playerEquipment, playerEquipmentLevel, vipLevel, player_title, qualifyingLevel, zsleve, playerStar, playerFighting, pet, extranInfo, playerHeadColour, playerBodyColour, mentoringStr, coupleStr, chumStr, coupleNum, chumNum, mentoringNum, winNum, playNum, tournamentExp, skillId, matchLevel, matchscore, joinTimes, winTimes, continuousWinTimes, inspire)
	-- roomId : 房间Id
	-- passWord : 房间密码
	-- roomName : 房间名称
	-- playerNumMode : 对战人数
	-- mapId : 房间地图id
	-- wnersId : 房主id
	-- playerNum : 房间座位数量
	-- seatUsed : 该座位是否使用
	-- playerId : 房间内玩家id
	-- serviceId : 房间内玩家所在服id
	-- playerName : 房间内玩家昵称
	-- playerLevel : 房间内玩家等级
	-- playerReady : 玩家是否已准备
	-- playerSex : 玩家性别
	-- playerEquipment : 玩家身上的装备
	-- playerEquipmentLevel : 玩家装备等级
	-- vipLevel : vip等级
	-- player_title : 玩家称号
	-- qualifyingLevel : 排位等级
	-- zsleve : 玩家转生等级
	-- playerStar : 房间内玩家的副本星级
	-- playerFighting : 房间内玩家的战斗力
	-- pet : 房间内玩家的宠物信息
	-- extranInfo : 装备扩展信息(武器)
	-- playerHeadColour : 房间内玩家的头颜色
	-- playerBodyColour : 房间内玩家的身颜色
	-- mentoringStr : 师徒关系(id|id,id|id)
	-- coupleStr : 夫妻关系(id|id,id|id)
	-- chumStr : 密友关系(id|id,id|id)
	-- coupleNum : 夫妻恩爱值(恩爱值|恩爱等级,恩爱值|恩爱等级)
	-- chumNum : 密友关系(好友值,好友值)
	-- mentoringNum : 师德值(好友值|师德等级,好友值|师德等级)
	-- winNum : 胜利场次
	-- playNum : 战斗场次
	-- tournamentExp : 竞技积分
	-- skillId : 携带技能id
	-- matchLevel : 排位赛等级
	-- matchscore : 排位赛积分
	-- joinTimes :  赛季参与次数
	-- winTimes : 赛季胜利次数
	-- continuousWinTimes : 赛季当前连胜次数
	-- inspire : 玩家鼓舞值
	WZLog("ProtocolProcessorWorldTeamBossRoom:parse_TEAMWORLDBOSS_EnterRoomOk", inspire:size())

	-- 世界组队Boss
	if SceneWorldTeamBossRoom.m_root == nil then
		SceneWorldTeamBossRoom:showInterface()
	end

	SceneWorldTeamBossRoom:receiveEnterRoomOk(
		roomId, passWord, roomName, playerNumMode, mapId, wnersId, playerNum,VectorToTable(seatUsed),VectorToTable(playerId),VectorToTable(serverId), VectorToTable(playerName), VectorToTable(playerLevel),VectorToTable(playerReady),VectorToTable(playerSex),VectorToTable(playerEquipment),VectorToTable(playerEquipmentLevel), VectorToTable(vipLevel), VectorToTable(player_title), VectorToTable(qualifyingLevel), VectorToTable(zsleve), VectorToTable(playerStar),VectorToTable(playerFighting),VectorToTable(pet),VectorToTable(extranInfo),VectorToTable(playerHeadColour),VectorToTable(playerBodyColour), 
		mentoringStr,coupleStr,chumStr,coupleNum,chumNum,mentoringNum,VectorToTable(matchLevel),VectorToTable(matchscore),VectorToTable(joinTimes),VectorToTable(winTimes),VectorToTable(continuousWinTimes),VectorToTable(serviceId),VectorToTable(inspire))
end

--@brief	退出房间（TEAMWORLDBOSS_QuitRoomOk = 11）
function ProtocolProcessorWorldTeamBossRoom:parse_TEAMWORLDBOSS_QuitRoomOk(makr)
	-- makr : 是否被踢
	WZLog("ProtocolProcessorWorldTeamBossRoom:parse_TEAMWORLDBOSS_QuitRoomOk")

	SceneWorldTeamBossRoom:exitMulRoom()
	if makr then
		DelayCallFunction(function ()
			MsgBoxManager:showTipBox(LocalStrings.BOOSROOM_KICKEDOUT)
		end,nil,0.5)
	end
end

--@brief	获取组队世界boss当前血量（TEAMWORLDBOSS_GetTeamWorldBossHpOk = 23）
function ProtocolProcessorWorldTeamBossRoom:parse_TEAMWORLDBOSS_GetTeamWorldBossHpOk(nowHp, maxHp)
	-- nowHp : 当前血量
	-- maxHp : Boss最大血量
	WZLog("ProtocolProcessorWorldTeamBossRoom:parse_TEAMWORLDBOSS_GetTeamWorldBossHpOk")

	SceneWorldTeamBossRoom:getBossBloodOk(tonumber(nowHp), tonumber(maxHp))
end


--@brief	鼓舞（TEAMWORLDBOSS_InspireOk = 25）
function ProtocolProcessorWorldTeamBossRoom:parse_TEAMWORLDBOSS_InspireOk(inspire, goldCDTime, diamondCDTime)
	-- inspire : 物品ID
	-- goldCDTime : 金币鼓舞CD
	-- diamondCDTime : 钻石/礼钻鼓舞CD
	WZLog("ProtocolProcessorWorldTeamBossRoom:parse_TEAMWORLDBOSS_InspireOk")
	if SceneWorldTeamBossRoom.m_root then 
		SceneWorldTeamBossRoom:inspireResult(inspire, goldCDTime, diamondCDTime)
	else
		SceneWorldTeamBoss:inspireResult(inspire, goldCDTime, diamondCDTime)
	end
end

--@brief	获取大厅信息（TEAMWORLDBOSS_GetRoomStateOk = 27）
function ProtocolProcessorWorldTeamBossRoom:parse_TEAMWORLDBOSS_GetRoomStateOk(mapId, bossNowHp, diamondCDTime, goldCDTime, bossState, openTime, inspire, challengeNum, leaveNum, maxHp)
	-- mapId : 物品ID
	-- bossNowHp : BOSS当前血量
	-- diamondCDTime : 钻石/礼钻鼓舞CD
	-- goldCDTime : 金币鼓舞CD
	-- bossState : boss状态 1活着，2死亡，3逃跑
	-- openTime : boss开始倒计时
	-- inspire : 鼓舞值
	-- challengeNum : 总挑战次数
	-- leaveNum : 剩余挑战次数
	-- maxHp : BOSS最大血量
	WZLog("ProtocolProcessorWorldTeamBossRoom:parse_TEAMWORLDBOSS_GetRoomStateOk")

	SceneWorldTeamBoss:setEnterRoomData( mapId, tonumber(bossNowHp), inspire, diamondCDTime, goldCDTime, bossState, openTime, challengeNum, leaveNum, tonumber(maxHp))
end

--@brief	组队世界boss排行（TEAMWORLDBOSS_GetHurtRankOk = 29）
function ProtocolProcessorWorldTeamBossRoom:parse_TEAMWORLDBOSS_GetHurtRankOk(playerId, playerName, cross, hurt, headId, faceId, sex, headColor, vipLevel, level, playerNum, myRank, myHurt)
	-- playerId : 玩家ID
	-- playerName : 玩家名
	-- cross : 是否跨服
	-- hurt : 伤害
	-- headId : 头id
	-- faceId : 脸Id
	-- sex : 性别
	-- headColor : 头颜色
	-- vipLevel : vip等级
	-- level : 等级
	-- playerNum : 队伍玩家数量
	-- myRank : 自己队伍的最高排名，-1为没有排名
	-- myHurt : 我的队伍的伤害
	WZLog("ProtocolProcessorWorldTeamBossRoom:parse_TEAMWORLDBOSS_GetHurtRankOk")
	SceneWorldTeamBoss:setHurtList(VectorToTable(playerNum), VectorToTable(playerId), VectorToTable(playerName), VectorToTable(sex), VectorToTable(headId), VectorToTable(faceId), VectorToTable(headColor), VectorToTable(vipLevel), VectorToTable(hurt), VectorToTable(level), myRank, myHurt)
end

--@brief	房间列表（TEAMWORLDBOSS_GetRoomListOk = 15）
function ProtocolProcessorWorldTeamBossRoom:parse_TEAMWORLDBOSS_GetRoomListOk(roomCount, roomId, battleStatus, playerCountNum, password, playerNum, roomStatus, roomName, playerId, playerName, headId, faceId, headColor, sex, vipLevel)
	-- roomCount : 房间数量
	-- roomId : 房间Id数组
	-- battleStatus : 房间状态数组（0是等待中，1是战斗中）
	-- playerCountNum : 房间对战人数
	-- password : 房间密码数组
	-- playerNum : 房间当前人数数组
	-- roomStatus : 房间是否已满（true是已满，false未满）
	-- roomName : 房间名称
	-- playerId : 玩家ID
	-- playerName : 玩家名
	-- headId : 头
	-- faceId : 脸ID
	-- headColor : 头颜色
	-- sex : 性别
	-- vipLevel : vip等级
	WZLog("ProtocolProcessorWorldTeamBossRoom:parse_TEAMWORLDBOSS_GetRoomListOk")

	SceneWorldTeamBoss:getRoomListOk(VectorToTable(roomId), VectorToTable(password), VectorToTable(playerNum), VectorToTable(battleStatus), VectorToTable(roomName), VectorToTable(playerId), VectorToTable(playerName), VectorToTable(sex), VectorToTable(headId), VectorToTable(faceId), VectorToTable(headColor), VectorToTable(vipLevel), VectorToTable(playerCountNum))
end

--@brief	购买挑战次数（TEAMWORLDBOSS_BuyChallengeNumOk = 32）
function ProtocolProcessorWorldTeamBossRoom:parse_TEAMWORLDBOSS_BuyChallengeNumOk(leaveNum)
	-- leaveNum : 剩余挑战次数
	WZLog("ProtocolProcessorWorldTeamBossRoom:parse_TEAMWORLDBOSS_BuyChallengeNumOk")

	SceneWorldTeamBoss:updateChallengeTimes(leaveNum)
end
------------------------------------------------------------------------------------------------

--@brief	创建房间（TEAMWORLDBOSS_CreateRoom = 5）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_CreateRoom_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_CreateRoom_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_CreateRoom, nflag, sMessage)
	SceneWorldTeamBoss:closeLoadingBox()
end

--@brief	准备（TEAMWORLDBOSS_GameReady = 7）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_GameReady_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_GameReady_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_GameReady, nflag, sMessage)
end

--@brief	快速开始游戏（TEAMWORLDBOSS_QuickGame = 9）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_QuickGame_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_QuickGame_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_QuickGame, nflag, sMessage)
	SceneWorldTeamBoss:closeLoadingBox()
end

--@brief	退出房间（TEAMWORLDBOSS_QuitRoom = 10）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_QuitRoom_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_QuitRoom_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_QuitRoom, nflag, sMessage)
end

--@brief	获取组队世界boss当前血量（TEAMWORLDBOSS_GetTeamWorldBossHp = 22）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_GetTeamWorldBossHp_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_GetTeamWorldBossHp_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_GetTeamWorldBossHp, nflag, sMessage)
end

--@brief	选择房间（TEAMWORLDBOSS_SelectRoom = 24）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_SelectRoom_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_SelectRoom_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_SelectRoom, nflag, sMessage)
	SceneWorldTeamBoss:closeLoadingBox()
end

--@brief	开始战斗（TEAMWORLDBOSS_MakePair = 3）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_MakePair_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_MakePair_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_MakePair, nflag, sMessage)
end

--@brief	更新房间（TEAMWORLDBOSS_UpdateRoom = 12）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_UpdateRoom_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_UpdateRoom_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_UpdateRoom, nflag, sMessage)
end

--@brief	鼓舞（TEAMWORLDBOSS_Inspire = 18）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_Inspire_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_Inspire_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_Inspire, nflag, sMessage)
end

--@brief	获取大厅信息（TEAMWORLDBOSS_GetRoomState = 26）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_GetRoomState_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_GetRoomState_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_GetRoomState, nflag, sMessage)
end

--@brief	组队世界boss排行（TEAMWORLDBOSS_GetHurtRank = 28）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_GetHurtRank_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_GetHurtRank_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_GetHurtRank, nflag, sMessage)
end

--@brief	房间列表（TEAMWORLDBOSS_GetRoomList = 14）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_GetRoomList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_GetRoomList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_GetRoomList, nflag, sMessage)
end

--@brief	购买挑战次数（TEAMWORLDBOSS_BuyChallengeNum = 31）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_BuyChallengeNum_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_BuyChallengeNum_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_BuyChallengeNum, nflag, sMessage)
end

--@brief	邀请（TEAMWORLDBOSS_Invite = 33）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_Invite_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_Invite_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_Invite, nflag, sMessage)
end

--@brief	返回房间（TEAMWORLDBOSS_BackToRoom = 35）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_BackToRoom_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_BackToRoom_ErrorProcess")
	if sMessage == "1" then
		--房间不存在
	elseif sMessage == "2" then
		--地图不存在
	else
		ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_BackToRoom, nflag, sMessage)
	end

    SceneWorldTeamBoss:showInterface()

    if sMessage == "1" then
		--房间不存在
		MsgBoxManager:showTipBox(LocalStrings.MULTI_ROOM_EMPTY)
    end
	
end