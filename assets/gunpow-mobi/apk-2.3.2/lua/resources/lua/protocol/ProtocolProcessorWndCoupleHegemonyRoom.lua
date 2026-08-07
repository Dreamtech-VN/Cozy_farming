--ProtocolProcessorWndCoupleHegemonyRoom.lua
--@brief	世界组队副本房间协议
--@date  	2018/07/13
--@author 	Tianxiang_Xu
--@note 	世界组队副本房间协议


ProtocolProcessorWndCoupleHegemonyRoom = ProtocolProcessorBase:new()

-------------------------------------公有方法模块--------------------------------------

--@brief	注册协议组所有协议
function ProtocolProcessorWndCoupleHegemonyRoom:regAll()
	--@brief	匹配（COUPLEFIGHTBOSS_MakePair = 3）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_MakePair, "ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_MakePair_ErrorProcess", "is")
	--@brief	创建夫妻争霸房间（COUPLEFIGHTBOSS_CreateRoom = 5）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_CreateRoom, "ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_CreateRoom_ErrorProcess", "is")
	--@brief	准备（COUPLEFIGHTBOSS_GameReady = 7）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_GameReady, "ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_GameReady_ErrorProcess", "is")
	--@brief	退出（COUPLEFIGHTBOSS_QuickGame = 9）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_QuickGame, "ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_QuickGame_ErrorProcess", "is")
	--@brief	退出房间（COUPLEFIGHTBOSS_QuitRoom = 10）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_QuitRoom, "ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_QuitRoom_ErrorProcess", "is")
	--@brief	升级房间（COUPLEFIGHTBOSS_UpdateRoom = 12）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_UpdateRoom, "ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_UpdateRoom_ErrorProcess", "is")
	--@brief	获取房间列表（COUPLEFIGHTBOSS_GetRoomList = 14）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_GetRoomList, "ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_GetRoomList_ErrorProcess", "is")
	--@brief	鼓舞（COUPLEFIGHTBOSS_Inspire = 18）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_Inspire, "ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_Inspire_ErrorProcess", "is")
	--@brief	获取boss血量（COUPLEFIGHTBOSS_GetTeamWorldBossHp = 22）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_GetTeamWorldBossHp, "ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_GetTeamWorldBossHp_ErrorProcess", "is")
	--@brief	选择房间（COUPLEFIGHTBOSS_SelectRoom = 24）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_SelectRoom, "ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_SelectRoom_ErrorProcess", "is")
	--@brief	获取房间状态（COUPLEFIGHTBOSS_GetRoomState = 26）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_GetRoomState, "ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_GetRoomState_ErrorProcess", "is")
	--@brief	获取夫妻争霸伤害排行（COUPLEFIGHTBOSS_GetHurtRank = 28）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_GetHurtRank, "ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_GetHurtRank_ErrorProcess", "is")
	--@brief	购买夫妻争霸挑战次数（COUPLEFIGHTBOSS_BuyChallengeNum = 31）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_BuyChallengeNum, "ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_BuyChallengeNum_ErrorProcess", "is")
	--@brief	邀请（COUPLEFIGHTBOSS_Invite = 33）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_Invite, "ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_Invite_ErrorProcess", "is")
	--@brief	返回房间（COUPLEFIGHTBOSS_BackToRoom = 35）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_BackToRoom, "ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_BackToRoom_ErrorProcess", "is")
	--@brief	历史排行榜（COUPLEFIGHTBOSS_GetHistoryRank = 37）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_GetHistoryRank, "ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_GetHistoryRank_ErrorProcess", "is")

	--@brief	匹配（COUPLEFIGHTBOSS_MakePairOk = 4）
	self:regProtocolCallbackFunction( Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_MakePairOk, "ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_MakePairOk", "iiivivsvsvsvsvivivivivivivivivivivivivivivivivivivivivivivivsvivivsvivivivsvsvivnvivivivivsvivivsvivsvsvsvivivivi")
	--@brief	进入夫妻争霸房间（COUPLEFIGHTBOSS_EnterRoomOk = 6）
	self:regProtocolCallbackFunction( Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_EnterRoomOk, "ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_EnterRoomOk", "issiiiivbvivivsvivbvivivivivsvivivivivsvsvivissssssvivivivivivivivivivivivivi")
	-- --@brief	夫妻争霸被邀请（COUPLEFIGHTBOSS_BeInvite = 8）
	-- self:regProtocolCallbackFunction( Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_BeInvite, "ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_BeInvite", "isisiii")
	--@brief	退出房间（COUPLEFIGHTBOSS_QuitRoomOk = 11）
	self:regProtocolCallbackFunction( Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_QuitRoomOk, "ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_QuitRoomOk", "b")
	--@brief	获取房间列表（COUPLEFIGHTBOSS_GetRoomListOk = 15）
	self:regProtocolCallbackFunction( Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_GetRoomListOk, "ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_GetRoomListOk", "ivivivivsvivbvsvivsvivivivtvi")
	--@brief	获取boss数据（COUPLEFIGHTBOSS_GetTeamWorldBossHpOk = 23）
	self:regProtocolCallbackFunction( Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_GetTeamWorldBossHpOk, "ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_GetTeamWorldBossHpOk", "ss")
	--@brief	鼓舞（COUPLEFIGHTBOSS_InspireOk = 25）
	self:regProtocolCallbackFunction( Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_InspireOk, "ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_InspireOk", "iii")
	--@brief	获取房间状态（COUPLEFIGHTBOSS_GetRoomStateOk = 27）
	self:regProtocolCallbackFunction( Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_GetRoomStateOk, "ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_GetRoomStateOk", "isiiiiiiis")
	--@brief	获取夫妻争霸伤害排行（COUPLEFIGHTBOSS_GetHurtRankOk = 29）
	self:regProtocolCallbackFunction( Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_GetHurtRankOk, "ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_GetHurtRankOk", "vivsvbvsvivivtviviviviiss")
	-- --@brief	组队夫妻争霸战斗结束返回（COUPLEFIGHTBOSS_SendSettlementInfo = 30）
	-- self:regProtocolCallbackFunction( Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_SendSettlementInfo, "ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_SendSettlementInfo", "biisvivsisib")
	--@brief	购买夫妻争霸挑战次数（COUPLEFIGHTBOSS_BuyChallengeNumOk = 32）
	self:regProtocolCallbackFunction( Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_BuyChallengeNumOk, "ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_BuyChallengeNumOk", "i")
	-- --@brief	夫妻争霸战斗伤害统计（COUPLEFIGHTBOSS_BattleHurtInfo = 34）
	-- self:regProtocolCallbackFunction( Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_BattleHurtInfo, "ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_BattleHurtInfo", "vivs")
	--@brief	历史排行榜（COUPLEFIGHTBOSS_GetHistoryRankOk = 38）
	self:regProtocolCallbackFunction( Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_GetHistoryRankOk, "ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_GetHistoryRankOk", "vivsvbvsvivivtvivivivii")
end

--@brief	反注册协议组所有协议
function ProtocolProcessorWndCoupleHegemonyRoom:unregAll()
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief	匹配（COUPLEFIGHTBOSS_MakePair = 3）
function ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_MakePair(roomId)
	WZLog("send_COUPLEFIGHTBOSS_MakePair")
	local sender = Protocol:getSender( Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_MakePair )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(roomId)	-- 房间ID
	SendProtocol(sender,false) --true:showLoading
end

--@brief	创建夫妻争霸房间（COUPLEFIGHTBOSS_CreateRoom = 5）
function ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_CreateRoom(roomName, passWord)
	WZLog("send_COUPLEFIGHTBOSS_CreateRoom")
	local sender = Protocol:getSender( Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_CreateRoom )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeString(roomName)	-- 
	sender:writeString(passWord)	-- 
	SendProtocol(sender,false) --true:showLoading
end

--@brief	准备（COUPLEFIGHTBOSS_GameReady = 7）
function ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_GameReady(roomId, oldSeat, ready)
	WZLog("send_COUPLEFIGHTBOSS_GameReady")
	local sender = Protocol:getSender( Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_GameReady )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(roomId)	-- 
	sender:writeInt(oldSeat)	-- 
	sender:writeBoolean(ready)	-- 
	SendProtocol(sender,false) --true:showLoading
end

--@brief	退出（COUPLEFIGHTBOSS_QuickGame = 9）
function ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_QuickGame()
	WZLog("send_COUPLEFIGHTBOSS_QuickGame")
	local sender = Protocol:getSender( Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_QuickGame )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	退出房间（COUPLEFIGHTBOSS_QuitRoom = 10）
function ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_QuitRoom(roomId, oldSeat)
	WZLog("send_COUPLEFIGHTBOSS_QuitRoom", roomId, oldSeat)
	local sender = Protocol:getSender( Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_QuitRoom )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(roomId)	-- 
	sender:writeInt(oldSeat)	-- 
	SendProtocol(sender,false) --true:showLoading
end

--@brief	升级房间（COUPLEFIGHTBOSS_UpdateRoom = 12）
function ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_UpdateRoom(roomId, passWord, roomName)
	WZLog("send_COUPLEFIGHTBOSS_UpdateRoom")
	local sender = Protocol:getSender( Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_UpdateRoom )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(roomId)	-- 
	sender:writeString(passWord)	-- 
	sender:writeString(roomName)	-- 
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取房间列表（COUPLEFIGHTBOSS_GetRoomList = 14）
function ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_GetRoomList()
	WZLog("send_COUPLEFIGHTBOSS_GetRoomList")
	local sender = Protocol:getSender( Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_GetRoomList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	鼓舞（COUPLEFIGHTBOSS_Inspire = 18）
function ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_Inspire(itemId)
	WZLog("send_COUPLEFIGHTBOSS_Inspire")
	local sender = Protocol:getSender( Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_Inspire )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(itemId)	-- 
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取boss血量（COUPLEFIGHTBOSS_GetTeamWorldBossHp = 22）
function ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_GetTeamWorldBossHp()
	WZLog("send_COUPLEFIGHTBOSS_GetTeamWorldBossHp")
	local sender = Protocol:getSender( Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_GetTeamWorldBossHp )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	选择房间（COUPLEFIGHTBOSS_SelectRoom = 24）
function ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_SelectRoom(roomId, passWord)
	WZLog("send_COUPLEFIGHTBOSS_SelectRoom")
	local sender = Protocol:getSender( Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_SelectRoom )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(roomId)	-- 
	sender:writeString(passWord)	-- 
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取房间状态（COUPLEFIGHTBOSS_GetRoomState = 26）
function ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_GetRoomState()
	WZLog("send_COUPLEFIGHTBOSS_GetRoomState")
	local sender = Protocol:getSender( Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_GetRoomState )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取夫妻争霸伤害排行（COUPLEFIGHTBOSS_GetHurtRank = 28）
function ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_GetHurtRank()
	WZLog("send_COUPLEFIGHTBOSS_GetHurtRank")
	local sender = Protocol:getSender( Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_GetHurtRank )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	购买夫妻争霸挑战次数（COUPLEFIGHTBOSS_BuyChallengeNum = 31）
function ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_BuyChallengeNum()
	WZLog("send_COUPLEFIGHTBOSS_BuyChallengeNum")
	local sender = Protocol:getSender( Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_BuyChallengeNum )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	邀请（COUPLEFIGHTBOSS_Invite = 33）
function ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_Invite(roomId, paramInt1)
	WZLog("send_COUPLEFIGHTBOSS_Invite")
	local sender = Protocol:getSender( Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_Invite )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(roomId)	-- 
	sender:writeInt(paramInt1)	-- 客户端定义的参数，原封不动返回
	SendProtocol(sender,false) --true:showLoading
end

--@brief	返回房间（COUPLEFIGHTBOSS_BackToRoom = 35）
function ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_BackToRoom(roomId, mapId, playerId)
	WZLog("send_COUPLEFIGHTBOSS_BackToRoom")
	local sender = Protocol:getSender( Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_BackToRoom )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(roomId)	-- 
	sender:writeInt(mapId)	-- 
	sender:writeInt(playerId)	-- 
	SendProtocol(sender,false) --true:showLoading
end

--@brief	历史排行榜（COUPLEFIGHTBOSS_GetHistoryRank = 37）
function ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_GetHistoryRank()
	WZLog("send_COUPLEFIGHTBOSS_GetHistoryRank")
	local sender = Protocol:getSender( Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_GetHistoryRank )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end


-------------------------------------服务器到客户端协议回调方法模块--------------------------------------

--@brief	匹配（COUPLEFIGHTBOSS_MakePairOk = 4）
function ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_MakePairOk(battleId, mapId, playerCount, playerId, serverId, playerName, playerTitle, playerGuild, playerLevel, playerSex, maxHP, maxPF, maxSP, attack, critRate, defence, injuryFree, wreckDefense, reduceCrit, power, armor, constitution, agility, lucky, inspire, headId, faceId, bodyId, weaponId, wingId, item_id, skillId, playerBuffCount, buffId, petAnimation, petGift, guaiBattleId, guaiId, guaiMaxHP, guaiNowHP, guaiAttack, petAdvancedLevel, colour, bodycolour, footmark, profession, professionSkillId, mountId, childId, childName, childSex, childImage, assistSkillIds, defaultShapeBigSkill, blastEffect, extPropertyKey, extPropertyValue, extPropertyCount)
	-- battleId : 
	-- mapId : 
	-- playerCount : 
	-- playerId : 
	-- serverId : 
	-- playerName : 
	-- playerTitle : 
	-- playerGuild : 
	-- playerLevel : 
	-- playerSex : 
	-- maxHP : 
	-- maxPF : 
	-- maxSP : 
	-- attack : 
	-- crit : 
	-- defence : 
	-- injuryFree : 
	-- wreckDefense : 
	-- reduceCrit : 
	-- power : 
	-- armor : 
	-- constitution : 
	-- agility : 
	-- lucky : 
	-- inspire : 
	-- headId : 
	-- faceId : 
	-- bodyId : 
	-- weaponId : 
	-- wingId : 
	-- item_id : 
	-- skillId : 
	-- playerBuffCount : 
	-- buffId : 
	-- petAnimation : 
	-- petGift : 
	-- guaiBattleId : 
	-- guaiId : 
	-- guaiMaxHP : 
	-- guaiNowHP : 
	-- guaiAttack : 
	-- petAdvancedLevel : 
	-- colour : 
	-- bodycolour : 
	-- footmark : 
	-- profession : 
	-- professionSkillId : 
	-- mountId : 出战的坐骑ID，没有的传0【162新增】
	-- childId : 出战的孩子ID，没有的传0【162新增】
	-- childName : 孩子的名字没有的传""空字符串【162新增】
	-- childSex : 孩子性别
	-- childImage : 孩子的形象["A头,A脸,A身","B头,B脸,B身","C头,C脸,C身"] 没有的传""空字符串【162新增】
	-- assistSkillIds : 助战技ids["前3孩子技能后坐骑技能'1|2|3|4|0|-1'【1,2,3为孩子技能ID，4为坐骑技能ID，0表示空技能槽，-1表示技能槽未解锁】【162新增】
	-- defaultShapeBigSkill : 默认皮肤大招【166新增】
	-- blastEffect : 爆破特效【1681新增】
	-- extPropertyKey : 【1711新增】拓展属性key,如：36=免疫中毒概率
	-- extPropertyValue : 【1711新增】拓展属性value，与上面的extPropertyKey一一对应
	-- extPropertyCount : 【1711新增】玩家拥有的拓展属性个数，用于切割上面的两个数组
	WZLog("ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_MakePairOk",
		"\n battleId =",Serialize(VectorToTable(battleId)),
		"\n mapId =",Serialize(VectorToTable(mapId)),
		"\n playerCount =",Serialize(VectorToTable(playerCount)),
		"\n playerId =",Serialize(VectorToTable(playerId)),
		"\n serverId =",Serialize(VectorToTable(serverId)),
		"\n playerName =",Serialize(VectorToTable(playerName)),
		"\n playerTitle =",Serialize(VectorToTable(playerTitle)),
		"\n playerGuild =",Serialize(VectorToTable(playerGuild)),
		"\n playerLevel =",Serialize(VectorToTable(playerLevel)),
		"\n playerSex =",Serialize(VectorToTable(playerSex)),
		"\n maxHP =",Serialize(VectorToTable(maxHP)),
		"\n maxPF =",Serialize(VectorToTable(maxPF)),
		"\n maxSP =",Serialize(VectorToTable(maxSP)),
		"\n attack =",Serialize(VectorToTable(attack)),
		"\n critRate =",Serialize(VectorToTable(critRate)),
		"\n defence =",Serialize(VectorToTable(defence)),
		"\n injuryFree =",Serialize(VectorToTable(injuryFree)),
		"\n wreckDefense =",Serialize(VectorToTable(wreckDefense)),
		"\n reduceCrit =",Serialize(VectorToTable(reduceCrit)),
		"\n power =",Serialize(VectorToTable(power)),
		"\n armor =",Serialize(VectorToTable(armor)),
		"\n constitution =",Serialize(VectorToTable(constitution)),
		"\n agility =",Serialize(VectorToTable(agility)),
		"\n lucky =",Serialize(VectorToTable(lucky)),
		"\n inspire =",Serialize(VectorToTable(inspire)),
		"\n headId =",Serialize(VectorToTable(headId)),
		"\n faceId =",Serialize(VectorToTable(faceId)),
		"\n bodyId =",Serialize(VectorToTable(bodyId)),
		"\n weaponId =",Serialize(VectorToTable(weaponId)),
		"\n wingId =",Serialize(VectorToTable(wingId)),
		"\n item_id =",Serialize(VectorToTable(item_id)),
		"\n skillId =",Serialize(VectorToTable(skillId)),
		"\n playerBuffCount =",Serialize(VectorToTable(playerBuffCount)),
		"\n buffId =",Serialize(VectorToTable(buffId)),
		"\n petAnimation =",Serialize(VectorToTable(petAnimation)),
		"\n petGift =",Serialize(VectorToTable(petGift)),
		"\n guaiBattleId =",Serialize(VectorToTable(guaiBattleId)),
		"\n guaiId =",Serialize(VectorToTable(guaiId)),
		"\n guaiMaxHP =",Serialize(VectorToTable(guaiMaxHP)),
		"\n guaiNowHP =",Serialize(VectorToTable(guaiNowHP)),
		"\n guaiAttack =",Serialize(VectorToTable(guaiAttack)),
		"\n petAdvancedLevel =",Serialize(VectorToTable(petAdvancedLevel)),
		"\n colour =",Serialize(VectorToTable(colour)),
		"\n bodycolour =",Serialize(VectorToTable(bodycolour)),
		"\n footmark =",Serialize(VectorToTable(footmark)),
		"\n profession =",Serialize(VectorToTable(profession)),
		"\n professionSkillId =",Serialize(VectorToTable(professionSkillId)),
		"\n mountId =",Serialize(VectorToTable(mountId)),
		"\n childId =",Serialize(VectorToTable(childId)),
		"\n childName =",Serialize(VectorToTable(childName)),
		"\n childSex =",Serialize(VectorToTable(childSex)),
		"\n childImage =",Serialize(VectorToTable(childImage)),
		"\n assistSkillIds =",Serialize(VectorToTable(assistSkillIds)),
		"\n defaultShapeBigSkill =",Serialize(VectorToTable(defaultShapeBigSkill)),
		"\n blastEffect =",Serialize(VectorToTable(blastEffect)),
		"\n extPropertyKey =",Serialize(VectorToTable(extPropertyKey)),
		"\n extPropertyValue =",Serialize(VectorToTable(extPropertyValue)),
		"\n extPropertyCount =",Serialize(VectorToTable(extPropertyCount))
		)

	SceneCoupleHegemonyRoom:receiveStartOk(battleId, mapId, playerCount, VectorToTable(playerId), VectorToTable(serverId), VectorToTable(playerName), VectorToTable(playerTitle), VectorToTable(playerGuild), VectorToTable(playerLevel), VectorToTable(playerSex), VectorToTable(maxHP), VectorToTable(maxPF), VectorToTable(maxSP), VectorToTable(attack), VectorToTable(critRate), VectorToTable(defence), VectorToTable(injuryFree), VectorToTable(wreckDefense), VectorToTable(reduceCrit), VectorToTable(power), VectorToTable(armor), VectorToTable(constitution), VectorToTable(agility), VectorToTable(lucky), VectorToTable(inspire), VectorToTable(headId), VectorToTable(faceId), VectorToTable(bodyId), VectorToTable(weaponId), VectorToTable(wingId), VectorToTable(item_id), VectorToTable(skillId), VectorToTable(playerBuffCount), VectorToTable(buffId), VectorToTable(petAnimation), VectorToTable(petGift), VectorToTable(guaiBattleId), VectorToTable(guaiId), VectorToTable(guaiMaxHP), VectorToTable(guaiNowHP), VectorToTable(guaiAttack), VectorToTable(petAdvancedLevel), VectorToTable(colour), VectorToTable(bodycolour), VectorToTable(footmark), VectorToTable(professionId), VectorToTable(professionSkill), VectorToTable(mountId), VectorToTable(childId), VectorToTable(childName), VectorToTable(childSex), VectorToTable(childImage), VectorToTable(assistSkillIds), VectorToTable(defaultShapeBigSkill), VectorToTable(blastEffect), VectorToTable(extPropertyKey), VectorToTable(extPropertyValue), VectorToTable(extPropertyCount))
end

--@brief	进入夫妻争霸房间（COUPLEFIGHTBOSS_EnterRoomOk = 6）
function ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_EnterRoomOk(roomId, passWord, roomName, playerNumMode, mapId, wnersId, playerNum, seatUsed, playerId, serviceId, playerName, playerLevel, playerReady, playerSex, playerEquipment, playerEquipmentLevel, vipLevel, player_title, qualifyingLevel, zsleve, playerStar, playerFighting, pet, extranInfo, playerHeadColour, playerBodyColour, mentoringStr, coupleStr, chumStr, coupleNum, chumNum, mentoringNum, winNum, playNum, tournamentExp, skillId, matchLevel, matchscore, joinTimes, winTimes, continuousWinTimes, inspire, profession, openStatus, blastEffect)
	-- roomId : 
	-- passWord : 
	-- roomName : 
	-- playerNumMode : 
	-- mapId : 
	-- wnersId : 
	-- playerNum : 
	-- seatUsed : 
	-- playerId : 
	-- serviceId : 
	-- playerName : 
	-- playerLevel : 
	-- playerReady : 
	-- playerSex : 
	-- playerEquipment : 
	-- playerEquipmentLevel : 
	-- vipLevel : 
	-- player_title : 
	-- qualifyingLevel : 
	-- zsleve : 
	-- playerStar : 
	-- playerFighting : 
	-- pet : 
	-- extranInfo : 
	-- playerHeadColour : 
	-- playerBodyColour : 
	-- mentoringStr : 
	-- coupleStr : 
	-- chumStr : 
	-- coupleNum : 
	-- chumNum : 
	-- mentoringNum : 
	-- winNum : 
	-- playNum : 
	-- tournamentExp : 
	-- skillId : 
	-- matchLevel : 
	-- matchscore : 
	-- joinTimes : 
	-- winTimes : 
	-- continuousWinTimes : 
	-- inspire : 
	-- profession : 
	-- openStatus : 
	-- blastEffect : 
	WZLog("ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_EnterRoomOk",
		"\n roomId =",Serialize(VectorToTable(roomId)),
		"\n passWord =",Serialize(VectorToTable(passWord)),
		"\n roomName =",Serialize(VectorToTable(roomName)),
		"\n playerNumMode =",Serialize(VectorToTable(playerNumMode)),
		"\n mapId =",Serialize(VectorToTable(mapId)),
		"\n wnersId =",Serialize(VectorToTable(wnersId)),
		"\n playerNum =",Serialize(VectorToTable(playerNum)),
		"\n seatUsed =",Serialize(VectorToTable(seatUsed)),
		"\n playerId =",Serialize(VectorToTable(playerId)),
		"\n serviceId =",Serialize(VectorToTable(serviceId)),
		"\n playerName =",Serialize(VectorToTable(playerName)),
		"\n playerLevel =",Serialize(VectorToTable(playerLevel)),
		"\n playerReady =",Serialize(VectorToTable(playerReady)),
		"\n playerSex =",Serialize(VectorToTable(playerSex)),
		"\n playerEquipment =",Serialize(VectorToTable(playerEquipment)),
		"\n playerEquipmentLevel =",Serialize(VectorToTable(playerEquipmentLevel)),
		"\n vipLevel =",Serialize(VectorToTable(vipLevel)),
		"\n player_title =",Serialize(VectorToTable(player_title)),
		"\n qualifyingLevel =",Serialize(VectorToTable(qualifyingLevel)),
		"\n zsleve =",Serialize(VectorToTable(zsleve)),
		"\n playerStar =",Serialize(VectorToTable(playerStar)),
		"\n playerFighting =",Serialize(VectorToTable(playerFighting)),
		"\n pet =",Serialize(VectorToTable(pet)),
		"\n extranInfo =",Serialize(VectorToTable(extranInfo)),
		"\n playerHeadColour =",Serialize(VectorToTable(playerHeadColour)),
		"\n playerBodyColour =",Serialize(VectorToTable(playerBodyColour)),
		"\n mentoringStr =",Serialize(VectorToTable(mentoringStr)),
		"\n coupleStr =",Serialize(VectorToTable(coupleStr)),
		"\n chumStr =",Serialize(VectorToTable(chumStr)),
		"\n coupleNum =",Serialize(VectorToTable(coupleNum)),
		"\n chumNum =",Serialize(VectorToTable(chumNum)),
		"\n mentoringNum =",Serialize(VectorToTable(mentoringNum)),
		"\n winNum =",Serialize(VectorToTable(winNum)),
		"\n playNum =",Serialize(VectorToTable(playNum)),
		"\n tournamentExp =",Serialize(VectorToTable(tournamentExp)),
		"\n skillId =",Serialize(VectorToTable(skillId)),
		"\n matchLevel =",Serialize(VectorToTable(matchLevel)),
		"\n matchscore =",Serialize(VectorToTable(matchscore)),
		"\n joinTimes =",Serialize(VectorToTable(joinTimes)),
		"\n winTimes =",Serialize(VectorToTable(winTimes)),
		"\n continuousWinTimes =",Serialize(VectorToTable(continuousWinTimes)),
		"\n inspire =",Serialize(VectorToTable(inspire)),
		"\n profession =",Serialize(VectorToTable(profession)),
		"\n openStatus =",Serialize(VectorToTable(openStatus)),
		"\n blastEffect =",Serialize(VectorToTable(blastEffect)))

	if SceneCoupleHegemonyRoom.m_root == nil then
		SceneCoupleHegemonyRoom:showInterface()
	end

	SceneCoupleHegemonyRoom:receiveEnterRoomOk(
		roomId, passWord, roomName, playerNumMode, mapId, wnersId, playerNum,VectorToTable(seatUsed),VectorToTable(playerId),VectorToTable(serverId), VectorToTable(playerName), VectorToTable(playerLevel),VectorToTable(playerReady),VectorToTable(playerSex),VectorToTable(playerEquipment),VectorToTable(playerEquipmentLevel), VectorToTable(vipLevel), VectorToTable(player_title), VectorToTable(qualifyingLevel), VectorToTable(zsleve), VectorToTable(playerStar),VectorToTable(playerFighting),VectorToTable(pet),VectorToTable(extranInfo),VectorToTable(playerHeadColour),VectorToTable(playerBodyColour), 
		mentoringStr,coupleStr,chumStr,coupleNum,chumNum,mentoringNum,VectorToTable(matchLevel),VectorToTable(matchscore),VectorToTable(joinTimes),VectorToTable(winTimes),VectorToTable(continuousWinTimes),VectorToTable(serviceId),VectorToTable(inspire))

end

-- --@brief	夫妻争霸被邀请（COUPLEFIGHTBOSS_BeInvite = 8）
-- function ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_BeInvite(roomId, playerName, mapId, passWorld, roomChannel, paramInt1, fromPlayerId)
-- 	-- roomId : 
-- 	-- playerName : 
-- 	-- mapId : 
-- 	-- passWorld : 
-- 	-- roomChannel : 
-- 	-- paramInt1 : 客户端定义的参数，原封不动返回
-- 	-- fromPlayerId : 发出玩家id
-- 	WZLog("ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_BeInvite")
-- end

--@brief	退出房间（COUPLEFIGHTBOSS_QuitRoomOk = 11）
function ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_QuitRoomOk(makr)
	-- makr : 是否被踢
	WZLog("ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_QuitRoomOk", makr)

	SceneCoupleHegemonyRoom:exitMulRoom()
	if makr then
		DelayCallFunction(function ()
			MsgBoxManager:showTipBox(LocalStrings.BOOSROOM_KICKEDOUT)
		end,nil,0.5)
	end
end

--@brief	获取房间列表（COUPLEFIGHTBOSS_GetRoomListOk = 15）
function ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_GetRoomListOk(roomCount, roomId, battleStatus, playerCountNum, password, playerNum, roomStatus, roomName, playerId, playerName, headId, faceId, headColor, sex, vipLevel)
	-- roomCount : 
	-- roomId : 
	-- battleStatus : 
	-- playerCountNum : 
	-- password : 
	-- playerNum : 
	-- roomStatus : 
	-- roomName : 
	-- playerId : 
	-- playerName : 
	-- headId : 
	-- faceId : 
	-- headColor : 
	-- sex : 
	-- vipLevel : 
	WZLog("ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_GetRoomListOk")

	SceneCoupleHegemonyRoom:getRoomListOk(VectorToTable(roomId), VectorToTable(password), VectorToTable(playerNum), VectorToTable(battleStatus), VectorToTable(roomName), VectorToTable(playerId), VectorToTable(playerName), VectorToTable(sex), VectorToTable(headId), VectorToTable(faceId), VectorToTable(headColor), VectorToTable(vipLevel), VectorToTable(playerCountNum))
end

--@brief	获取boss数据（COUPLEFIGHTBOSS_GetTeamWorldBossHpOk = 23）
function ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_GetTeamWorldBossHpOk(nowHp, maxHp)
	-- nowHp : 
	-- maxHp : 
	WZLog("ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_GetTeamWorldBossHpOk")

	SceneCoupleHegemonyRoom:getBossBloodOk(tonumber(nowHp), tonumber(maxHp))
end

--@brief	鼓舞（COUPLEFIGHTBOSS_InspireOk = 25）
function ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_InspireOk(inspire, goldCDTime, diamondCDTime)
	-- inspire : 
	-- goldCDTime : 
	-- diamondCDTime : 
	WZLog("ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_InspireOk")
	if SceneCoupleHegemonyRoom.m_root then 
		SceneCoupleHegemonyRoom:inspireResult(inspire, goldCDTime, diamondCDTime)
	end
end

--@brief	获取房间状态（COUPLEFIGHTBOSS_GetRoomStateOk = 27）
function ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_GetRoomStateOk(mapId, bossNowHp, diamondCDTime, goldCDTime, bossState, openTime, inspire, challengeNum, leaveNum, bossMaxHp)
	-- mapId : 
	-- bossNowHp : 
	-- diamondCDTime : 
	-- goldCDTime : 
	-- bossState : 
	-- openTime : 
	-- inspire : 
	-- challengeNum : 
	-- leaveNum : 
	-- bossMaxHp : 
	WZLog("ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_GetRoomStateOk", mapId, bossNowHp, diamondCDTime, goldCDTime, bossState, openTime, inspire, challengeNum, leaveNum, bossMaxHp)

	SceneCoupleHegemonyRoom:setEnterRoomData( mapId, tonumber(bossNowHp), inspire, diamondCDTime, goldCDTime, bossState, openTime, challengeNum, leaveNum, tonumber(bossMaxHp))
end

--@brief	获取夫妻争霸伤害排行（COUPLEFIGHTBOSS_GetHurtRankOk = 29）
function ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_GetHurtRankOk(playerId, playerName, cross, hurt, headId, faceId, sex, headColor, vipLevel, level, playerNum, myRank, teamHurt, curBossTotalHurt)
	-- playerId : 
	-- playerName : 
	-- cross : 
	-- hurt : 
	-- headId : 
	-- faceId : 
	-- sex : 
	-- headColor : 
	-- vipLevel : 
	-- level : 
	-- playerNum : 
	-- myRank : 
	-- teamHurt : 
--[[	WZLog("ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_GetHurtRankOk", 
		"\n playerId =",Serialize(VectorToTable(playerId)), 
		"\n playerName =",Serialize(VectorToTable(playerName)), 
		"\n cross =",Serialize(VectorToTable(cross)), 
		"\n hurt =",Serialize(VectorToTable(hurt)), 
		"\n headId =",Serialize(VectorToTable(headId)), 
		"\n faceId =",Serialize(VectorToTable(faceId)), 
		"\n sex =",Serialize(VectorToTable(sex)), 
		"\n headColor =",Serialize(VectorToTable(headColor)), 
		"\n vipLevel =",Serialize(VectorToTable(vipLevel)), 
		"\n level =",Serialize(VectorToTable(level)), 
		"\n playerNum =",Serialize(VectorToTable(playerNum)), 
		"\n myRank =",Serialize(VectorToTable(myRank)), 
		"\n teamHurt =",teamHurt,
		"\n curBossTotalHurt =", curBossTotalHurt)
		]]
	local myHurt = tonumber(teamHurt)
	local curBossTotalHurt = tonumber(curBossTotalHurt)
	if SceneCoupleHegemonyRoom.m_root then
		SceneCoupleHegemonyRoom:setHurtList(VectorToTable(playerNum), VectorToTable(playerId), VectorToTable(playerName), VectorToTable(sex), VectorToTable(headId), VectorToTable(faceId), VectorToTable(headColor), VectorToTable(vipLevel), VectorToTable(hurt), VectorToTable(level), myRank, myHurt, curBossTotalHurt)
	end
	if WndTowerRank.m_root then
		WndTowerRank:getCoupleHegemonyRankOk(VectorToTable(playerId), VectorToTable(playerName), VectorToTable(cross), VectorToTable(hurt), VectorToTable(headId), VectorToTable(faceId), VectorToTable(sex), VectorToTable(headColor), VectorToTable(vipLevel), VectorToTable(level), VectorToTable(playerNum), myRank, myHurt, curBossTotalHurt)
	end
end

-- --@brief	组队夫妻争霸战斗结束返回（COUPLEFIGHTBOSS_SendSettlementInfo = 30）
-- function ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_SendSettlementInfo(win, myHurt, teamHurt, bossMaxHp, killerId, killerName, goldNum, bossNowHp, leaveNum, timeOver)
-- 	-- win : 
-- 	-- myHurt : 
-- 	-- teamHurt : 
-- 	-- bossMaxHp : 
-- 	-- killerId : 
-- 	-- killerName : 
-- 	-- goldNum : 
-- 	-- bossNowHp : 
-- 	-- leaveNum : 
-- 	-- timeOver : 
-- 	WZLog("ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_SendSettlementInfo")
-- end

--@brief	购买夫妻争霸挑战次数（COUPLEFIGHTBOSS_BuyChallengeNumOk = 32）
function ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_BuyChallengeNumOk(leaveNum)
	-- leaveNum : 
	WZLog("ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_BuyChallengeNumOk")

	SceneCoupleHegemonyRoom:updateChallengeTimes(leaveNum)
end

-- --@brief	夫妻争霸战斗伤害统计（COUPLEFIGHTBOSS_BattleHurtInfo = 34）
-- function ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_BattleHurtInfo(playerId, hurt)
-- 	-- playerId : 
-- 	-- hurt : 
-- 	WZLog("ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_BattleHurtInfo")
-- end

--@brief	历史排行榜（COUPLEFIGHTBOSS_GetHistoryRankOk = 38）
function ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_GetHistoryRankOk(playerId, playerName, cross, hurt, headId, faceId, sex, headColor, vipLevel, level, playerNum, rank)
	-- playerId : 
	-- playerName : 
	-- cross : 
	-- hurt : 
	-- headId : 
	-- faceId : 
	-- sex : 
	-- headColor : 
	-- vipLevel : 
	-- level : 
	-- playerNum : 
	-- rank : 
	WZLog("ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_GetHistoryRankOk", 
		"\n playerId = ",Serialize(VectorToTable(playerId)), 
		"\n playerName = ",Serialize(VectorToTable(playerName)), 
		"\n cross = ",Serialize(VectorToTable(cross)), 
		"\n hurt = ",Serialize(VectorToTable(hurt)), 
		"\n headId = ",Serialize(VectorToTable(headId)), 
		"\n faceId = ",Serialize(VectorToTable(faceId)), 
		"\n sex = ",Serialize(VectorToTable(sex)), 
		"\n headColor = ",Serialize(VectorToTable(headColor)), 
		"\n vipLevel = ",Serialize(VectorToTable(vipLevel)), 
		"\n level = ",Serialize(VectorToTable(level)), 
		"\n playerNum = ",Serialize(VectorToTable(playerNum)), 
		"\n rank = ",Serialize(VectorToTable(rank))
		)

	if WndTowerRank.m_root then
		WndTowerRank:getCoupleHegemonyHistoryRank(VectorToTable(playerId), VectorToTable(playerName), VectorToTable(cross), VectorToTable(hurt), VectorToTable(headId), VectorToTable(faceId), VectorToTable(sex), VectorToTable(headColor), VectorToTable(vipLevel), VectorToTable(level), VectorToTable(playerNum), rank)
	end
end



------------------------------------------------------------------------------------------------

--@brief	匹配（COUPLEFIGHTBOSS_MakePair = 3）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_MakePair_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_MakePair_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_MakePair, nflag, sMessage)
end

--@brief	创建夫妻争霸房间（COUPLEFIGHTBOSS_CreateRoom = 5）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_CreateRoom_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_CreateRoom_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_CreateRoom, nflag, sMessage)
	SceneCoupleHegemonyRoom:closeLoadingBox()
end

--@brief	准备（COUPLEFIGHTBOSS_GameReady = 7）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_GameReady_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_GameReady_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_GameReady, nflag, sMessage)
end

--@brief	退出（COUPLEFIGHTBOSS_QuickGame = 9）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_QuickGame_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_QuickGame_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_QuickGame, nflag, sMessage)
	SceneCoupleHegemonyRoom:closeLoadingBox()
end

--@brief	退出房间（COUPLEFIGHTBOSS_QuitRoom = 10）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_QuitRoom_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_QuitRoom_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_QuitRoom, nflag, sMessage)
end

--@brief	升级房间（COUPLEFIGHTBOSS_UpdateRoom = 12）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_UpdateRoom_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_UpdateRoom_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_UpdateRoom, nflag, sMessage)
end

--@brief	获取房间列表（COUPLEFIGHTBOSS_GetRoomList = 14）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_GetRoomList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_GetRoomList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_GetRoomList, nflag, sMessage)
end

--@brief	鼓舞（COUPLEFIGHTBOSS_Inspire = 18）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_Inspire_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_Inspire_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_Inspire, nflag, sMessage)
end

--@brief	获取boss血量（COUPLEFIGHTBOSS_GetTeamWorldBossHp = 22）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_GetTeamWorldBossHp_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_GetTeamWorldBossHp_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_GetTeamWorldBossHp, nflag, sMessage)
end

--@brief	选择房间（COUPLEFIGHTBOSS_SelectRoom = 24）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_SelectRoom_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_SelectRoom_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_SelectRoom, nflag, sMessage)
end

--@brief	获取房间状态（COUPLEFIGHTBOSS_GetRoomState = 26）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_GetRoomState_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_GetRoomState_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_GetRoomState, nflag, sMessage)
end

--@brief	获取夫妻争霸伤害排行（COUPLEFIGHTBOSS_GetHurtRank = 28）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_GetHurtRank_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_GetHurtRank_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_GetHurtRank, nflag, sMessage)
end

--@brief	购买夫妻争霸挑战次数（COUPLEFIGHTBOSS_BuyChallengeNum = 31）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_BuyChallengeNum_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_BuyChallengeNum_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_BuyChallengeNum, nflag, sMessage)
end

--@brief	邀请（COUPLEFIGHTBOSS_Invite = 33）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_Invite_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_Invite_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_Invite, nflag, sMessage)
end

--@brief	返回房间（COUPLEFIGHTBOSS_BackToRoom = 35）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_BackToRoom_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_BackToRoom_ErrorProcess", nFlag, sMessage)

	if sMessage == "1" then
		--房间不存在
	elseif sMessage == "2" then
		--地图不存在
	else
		ProtocolErrorProcessor:errorProcess(Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_BackToRoom, nflag, sMessage)
	end

    SceneCoupleHegemonyRoom:showInterface()

    if sMessage == "1" then
		--房间不存在
		MsgBoxManager:showTipBox(LocalStrings.MULTI_ROOM_EMPTY)
    end
end

--@brief	历史排行榜（COUPLEFIGHTBOSS_GetHistoryRank = 37）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_GetHistoryRank_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndCoupleHegemonyRoom:parse_COUPLEFIGHTBOSS_GetHistoryRank_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_GetHistoryRank, nflag, sMessage)
end
