--ProtocolProcessorSceneBattle.lua
--@brief	战斗协议
--@date  	2013/12/10
--@author 	李光森
--@note 	普通战斗


ProtocolProcessorSceneBattle = ProtocolProcessorBase:new()

-------------------------------------公有方法模块--------------------------------------

--@brief	注册协议组所有协议
function ProtocolProcessorSceneBattle:regAll()
	--@brief	通知角色当前操作角色时间到了
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_CanStartCurRound, "ProtocolProcessorSceneBattle:parse_BATTLE_CanStartCurRound", "iiiivivivsviviviii", ProtocolProcessorSceneBattle.parse_BATTLE_CanStartCurRound)
	--@brief	其他角色移动
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_OtherPlayerMove, "ProtocolProcessorSceneBattle:parse_BATTLE_OtherPlayerMove", "iiiivtii", ProtocolProcessorSceneBattle.parse_BATTLE_OtherPlayerMove)
	--@brief	其他角色使用技能和道具
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_OtherSkillEquip, "ProtocolProcessorSceneBattle:parse_BATTLE_OtherSkillEquip", "iiivisvi", ProtocolProcessorSceneBattle.parse_BATTLE_OtherSkillEquip)
	--@brief	更新怒气值
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_ChangeAngryValue, "ProtocolProcessorSceneBattle:parse_BATTLE_ChangeAngryValue", "iii", ProtocolProcessorSceneBattle.parse_BATTLE_ChangeAngryValue)
	--@brief	是否可以使用大招
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_OtherBigSkill, "ProtocolProcessorSceneBattle:parse_BATTLE_OtherBigSkill", "iii", ProtocolProcessorSceneBattle.parse_BATTLE_OtherBigSkill)
	--@brief	其它人发射
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_OtherShoot, "ProtocolProcessorSceneBattle:parse_BATTLE_OtherShoot", "iiiiitiiivivivivivi", ProtocolProcessorSceneBattle.parse_BATTLE_OtherShoot)
	--@brief	其它人飞行
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_OtherFly, "ProtocolProcessorSceneBattle:parse_BATTLE_OtherFly", "iiiiitiiiivivivi", ProtocolProcessorSceneBattle.parse_BATTLE_OtherFly)
	--@brief	人物死亡
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_SomeOneDead, "ProtocolProcessorSceneBattle:parse_BATTLE_SomeOneDead", "iivibi", ProtocolProcessorSceneBattle.parse_BATTLE_SomeOneDead)
	--@brief	跳过本轮操作
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_OtherPass, "ProtocolProcessorSceneBattle:parse_BATTLE_OtherPass", "iii", ProtocolProcessorSceneBattle.parse_BATTLE_OtherPass)
	--@brief	通知游戏结束(BATTLE_GameOver = 27)
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_GameOver, "ProtocolProcessorSceneBattle:parse_BATTLE_GameOver", "iiivivivivivivivsiiiiiiiiiiiiiiiiiiivisi", ProtocolProcessorSceneBattle.parse_BATTLE_GameOver)
    --@brief	玩家掉线
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_PlayerLose, "ProtocolProcessorSceneBattle:parse_BATTLE_PlayerLose", "iiib", ProtocolProcessorSceneBattle.parse_BATTLE_PlayerLose)
	--@brief	人物复活
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_PlayerReborn, "ProtocolProcessorSceneBattle:parse_BATTLE_PlayerReborn", "iiivivivi", ProtocolProcessorSceneBattle.parse_BATTLE_PlayerReborn)
	--@brief	更新每个阵营的击杀数量
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_UpdateMedal, "ProtocolProcessorSceneBattle:parse_BATTLE_UpdateMedal", "iiivivi", ProtocolProcessorSceneBattle.parse_BATTLE_UpdateMedal)
	--@brief	强制退出战斗成功
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_QuitBattleOk, "ProtocolProcessorSceneBattle:parse_BATTLE_QuitBattleOk", "ii", ProtocolProcessorSceneBattle.parse_BATTLE_QuitBattleOk)
	--@brief	其他人使用表情
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_OtherUsingFace, "ProtocolProcessorSceneBattle:parse_BATTLE_OtherUsingFace", "iii", ProtocolProcessorSceneBattle.parse_BATTLE_OtherUsingFace)
	--@brief	通知客户端对指定角色进行控制
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_AIControlCommon, "ProtocolProcessorSceneBattle:parse_BATTLE_AIControlCommon", "iivi", ProtocolProcessorSceneBattle.parse_BATTLE_AIControlCommon)
	--@brief	其他人加载百份比
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_OtherLoadingPercent, "ProtocolProcessorSceneBattle:parse_BATTLE_OtherLoadingPercent", "iii", ProtocolProcessorSceneBattle.parse_BATTLE_OtherLoadingPercent)
	--@brief	每一个角色出现的位置
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_PostionsForPlayers, "ProtocolProcessorSceneBattle:parse_BATTLE_PostionsForPlayers", "iiivivivi", ProtocolProcessorSceneBattle.parse_BATTLE_PostionsForPlayers)
	--@brief	通知角色进入战斗
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_GotoBattle, "ProtocolProcessorSceneBattle:parse_BATTLE_GotoBattle", "b", ProtocolProcessorSceneBattle.parse_BATTLE_GotoBattle)
	--获取技能列表成功
	-- self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetSkillListOk, "ProtocolProcessorSceneBattle:parse_PLAYER_GetSkillListOk", "ivivsvsvivsvtvtvivivivivivi")
	--获取道具列表成功
	--self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPropListOk, "ProtocolProcessorSceneBattle:parse_PLAYER_GetPropListOk", "ivivsvsvivsvtvtvivivivivivi")
	--@brief	获取角色技能列表成功
	--self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerSkillOk, "ProtocolProcessorSceneBattle:parse_PLAYER_GetPlayerSkillOk", "ivivsvsvivsvtvtvivivivivivi")
	--@brief	获取角色道具列表成功
	--self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerPropOk, "ProtocolProcessorSceneBattle:parse_PLAYER_GetPlayerPropOk", "ivivsvsvivsvtvtvivivivivivi")
	--@brief	其他人生成怪
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_OtherBuildGuai, "ProtocolProcessorSceneBattle:parse_BATTLE_OtherBuildGuai", "iivivivivi", ProtocolProcessorSceneBattle.parse_BATTLE_OtherBuildGuai)
	--@brief	获得提示语成功
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_GetTipsOk, "ProtocolProcessorSceneBattle:parse_BATTLE_GetTipsOk", "vs", ProtocolProcessorSceneBattle.parse_BATTLE_GetTipsOk)
    --@brief	获取特殊事件信息OK
    -- self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_GetEventInfoOk, "ProtocolProcessorSceneBattle:parse_BATTLE_GetEventInfoOk", "iisii")
    --@brief	通知其它玩家触碰特殊事件
    -- self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_OtherEventContact, "ProtocolProcessorSceneBattle:parse_BATTLE_OtherEventContact", "iii")
    --@brief	添加Buff
    self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_AddBuff, "ProtocolProcessorSceneBattle:parse_BATTLE_AddBuff", "iiti", ProtocolProcessorSceneBattle.parse_BATTLE_AddBuff)
    --@brief	获得战斗道具 (RANKMATCH_SendPropsList = 26)
    self:regProtocolCallbackFunction( Protocol.MAIN_PROPS, Protocol.PROPS_SendPropsList, "ProtocolProcessorSceneBattle:parse_BATTLE_SendPropsList", "vivi", ProtocolProcessorSceneBattle.parse_BATTLE_SendPropsList)
    --@brief	击中战斗道具(BATTLE_HitOK = 30)
    self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_HitOK, "ProtocolProcessorSceneBattle:parse_BATTLE_HitPropOK", "iiivi", ProtocolProcessorSceneBattle.parse_BATTLE_HitPropOK)
    --@brief	发送当前回合的信息成功
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_SendCurRoundInfoOk, "ProtocolProcessorSceneBattle:parse_BATTLE_SendCurRoundInfoOk", "iiiviviviviviiivivis", ProtocolProcessorSceneBattle.parse_BATTLE_SendCurRoundInfoOk)
	--@brief	同步战斗信息成功
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_SynchronousBattleInfoOk, "ProtocolProcessorSceneBattle:parse_BATTLE_SynchronousBattleInfoOk", "ivivivivivsvivivsviviviviviviviviviviviviviiivivis", ProtocolProcessorSceneBattle.parse_BATTLE_SynchronousBattleInfoOk)
	--@brief	通知其他玩家有玩家返回战斗成功
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_ComeBackBattleInfoOk, "ProtocolProcessorSceneBattle:parse_BATTLE_ComeBackBattleInfoOk", "ii", ProtocolProcessorSceneBattle.parse_BATTLE_ComeBackBattleInfoOk)


	--@brief	战斗心跳错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SYSTEM, Protocol.SYSTEM_BattleShakeHands, "ProtocolProcessorSceneBattle:send_SYSTEM_BattleShakeHands_ErrorProcess", "is" )
	--@brief	通知已经开始加载错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_StartLoading, "ProtocolProcessorSceneBattle:send_BATTLE_StartLoading_ErrorProcess", "is" )
	--@brief	发送加载百份比错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_LoadingPercent, "ProtocolProcessorSceneBattle:send_BATTLE_LoadingPercent_ErrorProcess", "is" )
	--@brief	提交地图可选择的出现位置给服务器错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_PositionsInMap, "ProtocolProcessorSceneBattle:send_BATTLE_PositionsInMap_ErrorProcess", "is" )
	--@brief	通知已经完成加载错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_FinishLoading, "ProtocolProcessorSceneBattle:send_BATTLE_FinishLoading_ErrorProcess", "is" )
	--@brief	获得提示语错误处理(S->C)
	--self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_GetTips, "ProtocolProcessorSceneBattle:send_BATTLE_GetTips_ErrorProcess", "is" )
	--@brief	开始新的战斗操作计时错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_StartNewTimer, "ProtocolProcessorSceneBattle:send_BATTLE_StartNewTimer_ErrorProcess", "is" )
	--@brief	战斗操作结束错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_EndCurRound, "ProtocolProcessorSceneBattle:send_BATTLE_EndCurRound_ErrorProcess", "is" )
	--@brief	角色移动错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_PlayerMove, "ProtocolProcessorSceneBattle:send_BATTLE_PlayerMove_ErrorProcess", "is" )
	--@brief	使用技能和道具错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_SkillEquip, "ProtocolProcessorSceneBattle:send_BATTLE_SkillEquip_ErrorProcess", "is" )
	--@brief	使用大招错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_PetAttack, "ProtocolProcessorSceneBattle:send_BATTLE_PetAttack_ErrorProcess", "is" )
	--@brief	发射错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_Shoot, "ProtocolProcessorSceneBattle:send_BATTLE_Shoot_ErrorProcess", "is" )
	--@brief	发射完成错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_Hurt, "ProtocolProcessorSceneBattle:send_BATTLE_Hurt_ErrorProcess", "is" )
	--@brief	飞行错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_Fly, "ProtocolProcessorSceneBattle:send_BATTLE_Fly_ErrorProcess", "is" )
	--@brief	跳过本轮操作错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_Pass, "ProtocolProcessorSceneBattle:send_BATTLE_Pass_ErrorProcess", "is" )
	--@brief	返回房间错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_BackToRoom, "ProtocolProcessorSceneBattle:send_BATTLE_BackToRoom_ErrorProcess", "is" )
	--@brief	重生点错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_RebornPosition, "ProtocolProcessorSceneBattle:send_BATTLE_RebornPosition_ErrorProcess", "is" )
	--@brief	某角色掉出了场景错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_OutOfScene, "ProtocolProcessorSceneBattle:send_BATTLE_OutOfScene_ErrorProcess", "is" )
	--@brief	强制退出战斗错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_QuitBattle, "ProtocolProcessorSceneBattle:send_BATTLE_QuitBattle_ErrorProcess", "is" )
	--@brief	发送使用的表情错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_UsingFace, "ProtocolProcessorSceneBattle:send_BATTLE_UsingFace_ErrorProcess", "is" )
	--@brief	发送玩家战斗属性错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_SendPlayerBattleAttribute, "ProtocolProcessorSceneBattle:send_BATTLE_SendPlayerBattleAttribute_ErrorProcess", "is" )
    --@brief	获取特殊事件信息错误处理(S->C)
    -- self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_GetEventInfo, "ProtocolProcessorSceneBattle:send_BATTLE_GetEventInfo_ErrorProcess", "is" )
    --@brief	玩家触碰特殊事件错误处理(S->C)
    -- self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_EventContact, "ProtocolProcessorSceneBattle:send_BATTLE_EventContact_ErrorProcess", "is" )
    --@brief	生成怪错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_BuildGuai, "ProtocolProcessorSceneBattle:send_BATTLE_BuildGuai_ErrorProcess", "is" )
	--@brief	发送当前回合的信息错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_SendCurRoundInfo, "ProtocolProcessorSceneBattle:send_BATTLE_SendCurRoundInfo_ErrorProcess", "is" )
	--@brief	同步战斗信息错误处理(S->C)
	--self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_SynchronousBattleInfo, "ProtocolProcessorSceneBattle:send_BATTLE_SynchronousBattleInfo_ErrorProcess", "is" )

	--@brief	添加或移除BUFF(BATTLE_BuffChange = 65)错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_BuffChange, "ProtocolProcessorSceneBattle:send_BATTLE_BuffChange_ErrorProcess", "is" )
	--@brief	拾取幽灵技能(BATTLE_GetGhostSkill = 108)错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_GetGhostSkill, "ProtocolProcessorSceneBattle:send_BATTLE_GetGhostSkill_ErrorProcess", "is" )
	--@brief	移除幽灵技能(BATTLE_RemoveGhostSkill = 110)错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_RemoveGhostSkill, "ProtocolProcessorSceneBattle:send_BATTLE_RemoveGhostSkill_ErrorProcess", "is" )
	--@brief	同步新生成的幽灵技能(BATTLE_SyncGhostSkillList = 107)
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_SyncGhostSkillList, "ProtocolProcessorSceneBattle:parse_BATTLE_SyncGhostSkillList", "iiii")
	--@brief	拾取幽灵技能(BATTLE_GetGhostSkillOk = 109)
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_GetGhostSkillOk, "ProtocolProcessorSceneBattle:parse_BATTLE_GetGhostSkillOk", "iiii")
	--@brief	移除幽灵技能(BATTLE_RemoveGhostSkillOk = 111)
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_RemoveGhostSkillOk, "ProtocolProcessorSceneBattle:parse_BATTLE_RemoveGhostSkillOk", "ii")
	--@brief	幽灵移动错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_GhostMove, "ProtocolProcessorSceneBattle:send_BATTLE_GhostMove_ErrorProcess", "is" )
	--@brief	幽灵移动(BATTLE_OtherGhostMove = 113)
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_OtherGhostMove, "ProtocolProcessorSceneBattle:parse_BATTLE_OtherGhostMove", "iiiivtiivti", ProtocolProcessorSceneBattle.parse_BATTLE_OtherGhostMove)
	
	if WBattleGlobal:getCurrent():getBattleType() == BattleConstants.g_nBATTLE_TYPE_BOSS then
		self:regBoss()
	end
end

function ProtocolProcessorSceneBattle:regBoss()
	--@brief	boss变身错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BOSSMAPBATTLE_BossChange, "ProtocolProcessorSceneBattle:send_BOSSMAPBATTLE_BossChange_ErrorProcess", "is" )
	--@brief	boss变身
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BOSSMAPBATTLE_OtherChange, "ProtocolProcessorSceneBattle:parse_BOSSMAPBATTLE_OtherChange", "iiii",ProtocolProcessorSceneBattle.parse_BOSSMAPBATTLE_OtherChange)

	--@brief	使用近距离攻击错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BOSSMAPBATTLE_NearAttack, "ProtocolProcessorSceneBattle:send_BOSSMAPBATTLE_NearAttack_ErrorProcess", "is" )
	--@brief	其他人使用近距离攻击
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BOSSMAPBATTLE_OtherNearAttack, "ProtocolProcessorSceneBattle:parse_BOSSMAPBATTLE_OtherNearAttack", "iii",nil)

	--@brief	同步战斗对象位置信息(BOSSMAPBATTLE_SynPosition = 63)错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BOSSMAPBATTLE_SynPosition, "ProtocolProcessorSceneBattle:send_BOSSMAPBATTLE_SynPosition_ErrorProcess", "is" )
	--@brief	同步战斗对象位置信息(BOSSMAPBATTLE_OtherSynPosition = 64)
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BOSSMAPBATTLE_OtherSynPosition, "ProtocolProcessorSceneBattle:parse_BOSSMAPBATTLE_OtherSynPosition", "ivivivi",ProtocolProcessorSceneBattle.parse_BOSSMAPBATTLE_OtherSynPosition)

	--@brief	通知游戏结束
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BOSSMAPBATTLE_GameOver, "ProtocolProcessorSceneBattle:parse_BOSSMAPBATTLE_GameOver", "iivivivivivivivivivivii",ProtocolProcessorSceneBattle.parse_BOSSMAPBATTLE_GameOver)

	--@brief	返回房间错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_BackToRoom, "ProtocolProcessorSceneBattle:send_BOSSMAPROOM_BackToRoom_ErrorProcess", "is" )
	--@brief	抽奖错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_Reward, "ProtocolProcessorSceneBattle:send_BOSSMAPROOM_Reward_ErrorProcess", "is" )
	--@brief	其它人抽一次奖
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_OtherRewardOk, "ProtocolProcessorSceneBattle:parse_BOSSMAPROOM_OtherRewardOk", "ii",ProtocolProcessorSceneBattle.parse_BOSSMAPROOM_OtherRewardOk)


	 --@brief	获取房间状态成功
    self:regProtocolCallbackFunction( Protocol.MAIN_WORLDBOSS, Protocol.WORLDBOSS_GetRoomStateOk, "ProtocolProcessorSceneBattle:parse_WORLDBOSS_GetRoomStateOk", "iiivivsviiiiiiiiiii",ProtocolProcessorSceneBattle.parse_WORLDBOSS_GetRoomStateOk)
    --@brief	发送结算信息
    self:regProtocolCallbackFunction( Protocol.MAIN_WORLDBOSS, Protocol.WORLDBOSS_SendSettlementInfo, "ProtocolProcessorSceneBattle:parse_WORLDBOSS_SendSettlementInfo", "iiibis",ProtocolProcessorSceneBattle.parse_WORLDBOSS_SendSettlementInfo)

    --@brief	公会副本发送结算信息
	self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_SendSettlementInfo, "ProtocolProcessorSceneBattle:parse_GUILD_SendSettlementInfo", "ibisvivivivivivis")

	--@brief	组队世界boss战斗结束返回（TEAMWORLDBOSS_SendSettlementInfo = 30）
	self:regProtocolCallbackFunction( Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_SendSettlementInfo, "ProtocolProcessorSceneBattle:parse_TEAMWORLDBOSS_SendSettlementInfo", "biisvivsisib")

	--@brief	伤害详情（TEAMWORLDBOSS_BattleHurtInfo = 34）
	self:regProtocolCallbackFunction( Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_BattleHurtInfo, "ProtocolProcessorSceneBattle:parse_TEAMWORLDBOSS_BattleHurtInfo", "vivi")
end

--@brief	反注册协议组所有协议
function ProtocolProcessorSceneBattle:unregAll()
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块--------------------------------------

--@brief	击中战斗道具
function ProtocolProcessorSceneBattle:send_BATTLE_HitProp(propsId,battleId,currentId,targetId)
    WZLog("ProtocolProcessorSceneBattle:send_BATTLE_HitProp",propsId,battleId,currentId,targetId)
    local sender = Protocol:getSender( Protocol.MAIN_BATTLE, Protocol.BATTLE_Hit )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( propsId )
    sender:writeInt( battleId )
    sender:writeInt( currentId )
    sender:writeInts( targetId )
    SendProtocol(sender,false) --true:showLoading
end

--@brief	战斗心跳
function ProtocolProcessorSceneBattle:send_SYSTEM_BattleShakeHands(battleId )
	WZLog("send_SYSTEM_BattleShakeHands")
	local sender = Protocol:getSender( Protocol.MAIN_SYSTEM, Protocol.SYSTEM_BattleShakeHands )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( battleId )	-- 战斗id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	开始新的战斗操作计时
function ProtocolProcessorSceneBattle:send_BATTLE_StartNewTimer(battleId, playerId )
	WZLog("send_BATTLE_StartNewTimer")
	local sender = Protocol:getSender( Protocol.MAIN_BATTLE, Protocol.BATTLE_StartNewTimer )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( playerId )	-- 角色id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	战斗操作结束
function ProtocolProcessorSceneBattle:send_BATTLE_EndCurRound(battleId, playerId, playerIds, isHide, isFog, isPenetrate)
	WZLog("send_BATTLE_EndCurRound")
	local sender = Protocol:getSender( Protocol.MAIN_BATTLE, Protocol.BATTLE_EndCurRound )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( playerId )	-- 角色id
	sender:writeInts( TableToIntVector(playerIds) )	-- 所有人id
	sender:writeInts( TableToIntVector(isHide) )	-- 是否有隐身buff
	sender:writeInts( TableToIntVector(isFog) )	-- 是否有致盲buff
	sender:writeInts( TableToIntVector(isPenetrate) )	-- 是否有穿透buff
	SendProtocol(sender,false) --true:showLoading
end

--@brief	角色移动
function ProtocolProcessorSceneBattle:send_BATTLE_PlayerMove(battleId, playerId, movecount, movestep, curPositionX, curPositionY )
	WZLog("send_BATTLE_PlayerMove")
	local sender = Protocol:getSender( Protocol.MAIN_BATTLE, Protocol.BATTLE_PlayerMove )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( playerId )	-- 角色id
	sender:writeInt( movecount )	-- 移动的次数
	local vtMoveStep = WZLuaVector_byte_:create()
	for i = 1, movecount do
		vtMoveStep:push( movestep[i] )	-- 每一次移动的方向（1：左，0：右）
	end
	sender:writeBytes( vtMoveStep )
	sender:writeInt( BattleUtil:float2int(curPositionX) )	-- 没移动前的x坐标
	sender:writeInt( BattleUtil:float2int(curPositionY) )	-- 没移动前的y坐标
	SendProtocol(sender,false) --true:showLoading
end

--@brief	使用技能和道具
function ProtocolProcessorSceneBattle:send_BATTLE_SkillEquip(battleId, playerId, item_id , targetIds, param, uniqueId)
	WZLog("ProtocolProcessorSceneBattle:send_BATTLE_SkillEquip", battleId, playerId, item_id, type(uniqueId), uniqueId)
	local sender = Protocol:getSender( Protocol.MAIN_BATTLE, Protocol.BATTLE_SkillEquip )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( playerId )	-- 角色id
	sender:writeInt( item_id )	-- 使用技能道具的数量(服务器要设置上限）
    sender:writeInts( targetIds ) --目标id
    sender:writeString(param)	--客户端参数
	sender:writeInt( uniqueId )	-- 幽灵技能唯一ID，其它技能传0
	SendProtocol(sender,false) --true:showLoading
end

--@brief	宠物攻击
function ProtocolProcessorSceneBattle:send_BATTLE_PetAttack(battleId, playerId, hurtPlayer,hurtValue )
	WZLog("send_BATTLE_PetAttack")
	local sender = Protocol:getSender( Protocol.MAIN_BATTLE, Protocol.BATTLE_PetAttack )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( playerId )	-- 角色id
    sender:writeInts( hurtPlayer )
    sender:writeInts( hurtValue )
	SendProtocol(sender,false) --true:showLoading
    WZLog("send_BATTLE_PetAttack",Protocol.MAIN_BATTLE, Protocol.BATTLE_PetAttack)
end

--@brief	发射
function ProtocolProcessorSceneBattle:send_BATTLE_Shoot(battleId, playerId, speedx, speedy, leftRight, startX, startY, playerCount, playerIds, curPositionX, curPositionY, curPositionR, curPositionD, attackCount)
	local speedx1 = BattleUtil:float2int(speedx)
	local speedy1 = BattleUtil:float2int(speedy)
	-- local speedx2 = BattleUtil:int2float(speedx1)
	-- local speedy2 = BattleUtil:int2float(speedy1)

	-- local speedx3 = BattleCommon:float2int2float(speedx2)
	-- local speedx4 = BattleCommon:float2int2float(speedx)

	WZLog("send_BATTLE_Shoot", playerId, "speedx", speedx--[[, "speedx2", speedx2, "speedx3", speedx3, "speedx4", speedx4--]], "speedx1, speedy1", speedx1, speedy1, Serialize(curPositionR), Serialize(curPositionD), attackCount)
	local sender = Protocol:getSender( Protocol.MAIN_BATTLE, Protocol.BATTLE_Shoot )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( playerId )	-- 角色id
	sender:writeInt( speedx1 )	-- 发射速度
	sender:writeInt( speedy1 )	-- 力度速度
	sender:writeByte( leftRight )	-- 1：左 0：右（向左还是向右）
	sender:writeInt( BattleUtil:float2int(startX) )	-- 发射初始位置
	sender:writeInt( BattleUtil:float2int(startY) )	-- 发射初始位置
	sender:writeInt( playerCount )	-- 同步角色位置信息，角色数量
	local viPlayerId = WZLuaVector_int_:create()
	local viCurPositionX = WZLuaVector_int_:create()
	local viCurPositionY = WZLuaVector_int_:create()
    local viCurPositionR = WZLuaVector_int_:create()
    local viCurPositionD = WZLuaVector_int_:create()
	for i = 1, playerCount do
		viPlayerId:push( playerIds[i] )	-- 用户id
		viCurPositionX:push( BattleUtil:float2int(curPositionX[i]) )	-- 没飞行前的x坐标
		viCurPositionY:push( BattleUtil:float2int(curPositionY[i]) )	-- 没飞行前的y坐标
        viCurPositionR:push( BattleUtil:float2int(curPositionR[i]) )
        viCurPositionD:push( BattleUtil:float2int(curPositionD[i]) )
	end
	sender:writeInts( viPlayerId )
	sender:writeInts( viCurPositionX )
	sender:writeInts( viCurPositionY )
    sender:writeInts( viCurPositionR )
    sender:writeInts( viCurPositionD )

    if attackCount then
        sender:writeInt( attackCount )
    end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	发射完成
function ProtocolProcessorSceneBattle:send_BATTLE_Hurt(battleId, playerId, PlayerIds, hurtvalue, distance)

	local sender = Protocol:getSender( Protocol.MAIN_BATTLE, Protocol.BATTLE_Hurt )
	if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( battleId )	-- 战斗id
    sender:writeInt( playerId )	-- 角色id
    sender:writeInts( TableToIntVector(PlayerIds) )	-- 对应受伤害的序列
    sender:writeInts( TableToIntVector(hurtvalue) )	-- 受伤害值
    sender:writeInts( TableToIntVector(distance) )	-- 受伤害值

	SendProtocol(sender,false) --true:showLoading
    WZLog("ProtocolProcessorSceneBattle:send_BATTLE_Hurt", battleId, Serialize(VectorToTable(playerId)), 
    	Serialize(VectorToTable(PlayerIds)), Serialize(VectorToTable(hurtvalue)), Serialize(VectorToTable(distance)))
end

--@brief	飞行
function ProtocolProcessorSceneBattle:send_BATTLE_Fly(battleId, playerId, speedx, speedy, leftRight, isEquip, startX, startY, playerCount, playerIds, curPositionX, curPositionY )
	WZLog("send_BATTLE_Fly")
	local sender = Protocol:getSender( Protocol.MAIN_BATTLE, Protocol.BATTLE_Fly )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( playerId )	-- 角色id
	sender:writeInt( BattleUtil:float2int(speedx) )	-- 飞行速度
	sender:writeInt( BattleUtil:float2int(speedy) )	-- 飞行速度
	sender:writeByte( leftRight )	-- 1：左 0：右（向左还是向右）
	sender:writeInt( isEquip )	-- 是否道具飞行（0否1是）
	sender:writeInt( BattleUtil:float2int(startX) )	-- 飞行初始位置
	sender:writeInt( BattleUtil:float2int(startY) )	-- 飞行初始位置
	sender:writeInt( playerCount )	-- 同步角色位置信息，角色数量
	local viPlayerId = WZLuaVector_int_:create()
	local viCurPositionX = WZLuaVector_int_:create()
	local viCurPositionY = WZLuaVector_int_:create()
	for i = 1, playerCount do
		viPlayerId:push( playerIds[i] )	-- 用户id
		viCurPositionX:push( BattleUtil:float2int(curPositionX[i]) )	-- 没飞行前的x坐标
		viCurPositionY:push( BattleUtil:float2int(curPositionY[i]) )	-- 没飞行前的y坐标
	end
	sender:writeInts( viPlayerId )
	sender:writeInts( viCurPositionX )
	sender:writeInts( viCurPositionY )
	SendProtocol(sender,false) --true:showLoading
end

--@brief	跳过本轮操作
function ProtocolProcessorSceneBattle:send_BATTLE_Pass(battleId, playerId )
	WZLog("send_BATTLE_Pass")
	local sender = Protocol:getSender( Protocol.MAIN_BATTLE, Protocol.BATTLE_Pass )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( playerId )	-- 角色id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	返回房间
function ProtocolProcessorSceneBattle:send_BATTLE_BackToRoom(roomId )
	local player = WBattleGlobal:getCurrent():getMyBattleId()
	WZLog("send_BATTLE_BackToRoom", roomId, player)
	local sender = Protocol:getSender( Protocol.MAIN_ROOM, Protocol.ROOM_BackToRoom )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( roomId )	-- 房间号
	sender:writeInt(player)
	SendProtocol(sender,false) --true:showLoading
end

--@brief	重生点
function ProtocolProcessorSceneBattle:send_BATTLE_RebornPosition(battleId, playerId, playercount, PlayerIds, postionX, postionY )
	WZLog("send_BATTLE_RebornPosition")
	local sender = Protocol:getSender( Protocol.MAIN_BATTLE, Protocol.BATTLE_RebornPosition )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( playerId )	-- 角色id
	sender:writeInt( playercount )	-- 人数
	sender:writeInts( PlayerIds )	-- 所有人id
	sender:writeInts( postionX )	-- x坐标
	sender:writeInts( postionY )	-- y坐标
	SendProtocol(sender,false) --true:showLoading
end

--@brief	某角色掉出了场景
function ProtocolProcessorSceneBattle:send_BATTLE_OutOfScene(battleId, playerId, currentPlayerId )
	WZLog("send_BATTLE_OutOfScene", playerId, currentPlayerId)
	local sender = Protocol:getSender( Protocol.MAIN_BATTLE, Protocol.BATTLE_OutOfScene )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( battleId )	-- 战斗id
    sender:writeInt( currentPlayerId )	-- 角色id
	sender:writeInt( playerId )	-- 死亡角色id
	sender:writeInt( 0 )	-- 当前发送的玩家Id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	强制退出战斗
function ProtocolProcessorSceneBattle:send_BATTLE_QuitBattle(battleId, playerId )
	WZLog("send_BATTLE_QuitBattle")
	local sender = Protocol:getSender( Protocol.MAIN_BATTLE, Protocol.BATTLE_QuitBattle )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( playerId )	-- 角色id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	发送使用的表情
function ProtocolProcessorSceneBattle:send_BATTLE_UsingFace(battleId, playerId, faceId )
	WZLog("send_BATTLE_UsingFace")
	local sender = Protocol:getSender( Protocol.MAIN_BATTLE, Protocol.BATTLE_UsingFace )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( playerId )	-- 角色id
	sender:writeInt( faceId )	-- 使用的表情
	SendProtocol(sender,false) --true:showLoading
end

--@brief	发送玩家战斗属性
function ProtocolProcessorSceneBattle:send_BATTLE_SendPlayerBattleAttribute(battleId, playerId, hp, pf, angry, hpMax, pfMax, angryMax, attack, defend, BigSkillAttack )
	WZLog("send_BATTLE_SendPlayerBattleAttribute")
	local sender = Protocol:getSender( Protocol.MAIN_BATTLE, Protocol.BATTLE_SendPlayerBattleAttribute )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( playerId )	-- 角色
	sender:writeInt( hp )	-- 血量
	sender:writeInt( pf )	-- 体力
	sender:writeInt( angry )	-- 怒气
	sender:writeInt( hpMax )	-- 血量最大值
	sender:writeInt( pfMax )	-- 体力最大值
	sender:writeInt( angryMax )	-- 怒气最大值
	sender:writeInt( attack )	-- 攻击力
	sender:writeInt( defend )	-- 防御力
	sender:writeInt( BigSkillAttack )	-- 大招攻击力
	SendProtocol(sender,false) --true:showLoading
end

--@brief	通知已经开始加载
function ProtocolProcessorSceneBattle:send_BATTLE_StartLoading(battleId, playerId )
	WZLog("send_BATTLE_StartLoading")
	local sender = Protocol:getSender( Protocol.MAIN_BATTLE, Protocol.BATTLE_StartLoading )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( playerId )	-- 角色id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	发送加载百份比
function ProtocolProcessorSceneBattle:send_BATTLE_LoadingPercent(battleId, currentPlayerId, percent )
	WZLog("send_BATTLE_LoadingPercent")
	local sender = Protocol:getSender( Protocol.MAIN_BATTLE, Protocol.BATTLE_LoadingPercent )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( currentPlayerId )	-- 哪个角色的百份比id
	sender:writeInt( percent )	-- 0~100
	SendProtocol(sender,false) --true:showLoading
end

--@brief	提交地图可选择的出现位置给服务器
function ProtocolProcessorSceneBattle:send_BATTLE_PositionsInMap(battleId, playerId, postionCount, postionX, postionY )
	WZLog("send_BATTLE_PositionsInMap")
	local sender = Protocol:getSender( Protocol.MAIN_BATTLE, Protocol.BATTLE_PositionsInMap )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( battleId )	-- 战斗id
    sender:writeInt( playerId )	-- 战斗id
	sender:writeInt( postionCount )	-- 位置的数量
	sender:writeInts( postionX )	-- x坐标
	sender:writeInts( postionY )	-- y坐标
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获得提示语
function ProtocolProcessorSceneBattle:send_BATTLE_GetTips( )
	WZLog("send_BATTLE_GetTips")
	local sender = Protocol:getSender( Protocol.MAIN_BATTLE, Protocol.BATTLE_GetTips )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	通知已经完成加载
function ProtocolProcessorSceneBattle:send_BATTLE_FinishLoading(battleId, playerId )
	WZLog("send_BATTLE_FinishLoading")
	local sender = Protocol:getSender( Protocol.MAIN_BATTLE, Protocol.BATTLE_FinishLoading )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( playerId )	-- 角色id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取技能列表
function ProtocolProcessorSceneBattle:send_PLAYER_GetSkillList( )
	WZLog("send_PLAYER_GetSkillList")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetSkillList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取道具列表
function ProtocolProcessorSceneBattle:send_PLAYER_GetPropList( )
	WZLog("send_PLAYER_GetPropList")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPropList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取玩家技能
function ProtocolProcessorSceneBattle:send_PLAYER_GetPlayerSkill( )
	WZLog("send_PLAYER_GetPlayerSkill")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerSkill )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取玩家道具
function ProtocolProcessorSceneBattle:send_PLAYER_GetPlayerProp( )
	WZLog("send_PLAYER_GetPlayerProp")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerProp )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取特殊事件信息
function ProtocolProcessorSceneBattle:send_BATTLE_GetEventInfo(battleId )
	WZLog("send_BATTLE_GetEventInfo")
	local sender = Protocol:getSender( Protocol.MAIN_BATTLE, Protocol.BATTLE_GetEventInfo )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( battleId )	-- 战斗id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	玩家触碰特殊事件
function ProtocolProcessorSceneBattle:send_BATTLE_EventContact(battleId, playerId, eventId )
	WZLog("send_BATTLE_EventContact")
	local sender = Protocol:getSender( Protocol.MAIN_BATTLE, Protocol.BATTLE_EventContact )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( playerId )	-- 玩家id
	sender:writeInt( eventId )	-- 特殊事件id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	生成怪
function ProtocolProcessorSceneBattle:send_BATTLE_BuildGuai(battleId, currentId,  guaiId, guaiPositionX, guaiPositionY, ghostPlayerId)
	WZLog("send_BATTLE_BuildGuai")
	WZLog(battleId,currentId,Serialize(guaiId),Serialize(guaiPositionX),Serialize(guaiPositionY))
	local sender = Protocol:getSender( Protocol.MAIN_BATTLE, Protocol.BOSSMAPBATTLE_BuildGuai )
	if sender==nil then WZLog("sender == nil") return end
    if WBattleGlobal:getCurrent():isSingleStage() == true then return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( currentId )	-- 角色id,谁生成的
	sender:writeInts( TableToIntVector(guaiId) )	-- 怪的数据形象id
	sender:writeInts( FloatTableToIntVector(guaiPositionX) )	-- X坐标
	sender:writeInts( FloatTableToIntVector(guaiPositionY) )	-- Y坐标
	sender:writeInt( ghostPlayerId or 0 )	-- 幽灵玩家id,不是幽灵时候传0
	SendProtocol(sender,false) --true:showLoading
end


--@brief	发送当前回合的信息
function ProtocolProcessorSceneBattle:send_BATTLE_SendCurRoundInfo(battleId,turn, playerIds, postionX, postionY, angle, face, explodePlayerId, explodeSkillId, explodePosX, explodePosY, battleInfo)
	local sender = Protocol:getSender( Protocol.MAIN_BATTLE, Protocol.BATTLE_SendCurRoundInfo )
	WZLog("send_BATTLE_SendCurRoundInfo1", battleInfo)
	WBattleGlobal:getCurrent().m_bSendCurRoundInfo = turn

	if sender==nil then WZLog("sender == nil") return end
	
	sender:writeInt( battleId )	-- 战斗id
    sender:writeInt( WBattleGlobal:getCurrent():getMyBattleId() )	-- id
    sender:writeInt( turn )	-- 回合数
	sender:writeInts( TableToIntVector(playerIds) )	-- 所有人id
	sender:writeInts( FloatTableToIntVector(postionX) )	-- x坐标
	sender:writeInts( FloatTableToIntVector(postionY) )	-- y坐标
	sender:writeInts( FloatTableToIntVector(angle) )	-- 角度
	sender:writeInts( TableToIntVector(face) )	-- 朝向
	sender:writeInt( explodePlayerId )	-- 炸点对应的角色
	sender:writeInt( explodeSkillId )	-- 炸点所使用的技能Id
	sender:writeInts( FloatTableToIntVector(explodePosX) )	-- 炸点的x坐标
	sender:writeInts( FloatTableToIntVector(explodePosY) )	-- 炸点的y坐标
	sender:writeString( battleInfo )	--战斗信息
	SendProtocol(sender,false) --true:showLoading
end

--@brief	同步战斗信息
function ProtocolProcessorSceneBattle:send_BATTLE_SynchronousBattleInfo(battleId, playerId, scene )
	WZLog("send_BATTLE_SynchronousBattleInfo",battleId, playerId, scene)
	local sender = Protocol:getSender( Protocol.MAIN_BATTLE, Protocol.BATTLE_SynchronousBattleInfo )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( 0 )	-- 服务器id
	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( playerId )	-- 角色
	sender:writeByte( scene )	-- 1：战斗场景 0：加载场景
	SendProtocol(sender,false) --true:showLoading
end

--@brief	boss变身
function ProtocolProcessorSceneBattle:send_BOSSMAPBATTLE_BossChange(battleId, guaiBattleId, guaiOldId, guaiNewId )
	WZLog("send_BOSSMAPBATTLE_BossChange")
	local sender = Protocol:getSender( Protocol.MAIN_BATTLE, Protocol.BOSSMAPBATTLE_BossChange )
	if sender==nil then WZLog("sender == nil") return end
    if WBattleGlobal:getCurrent():isSingleStage() == true then return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( guaiBattleId )	-- 怪的战斗id
	sender:writeInt( guaiOldId )	-- 变身前在表中的id
	sender:writeInt( guaiNewId )	-- 变身后在表中的id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	使用近距离攻击
function ProtocolProcessorSceneBattle:send_BOSSMAPBATTLE_NearAttack(battleId, currentId, leftRight )
	WZLog("send_BOSSMAPBATTLE_NearAttack", currentId, leftRight)
	local sender = Protocol:getSender( Protocol.MAIN_BATTLE, Protocol.BOSSMAPBATTLE_NearAttack )
	if sender==nil then WZLog("sender == nil") return end
    if WBattleGlobal:getCurrent():isSingleStage() == true then return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( currentId )	-- 角色id
	sender:writeInt( leftRight )	-- 1：左 0：右（向左还是向右）
	SendProtocol(sender,false) --true:showLoading
end

--@brief	同步战斗对象位置信息(BOSSMAPBATTLE_SynPosition = 63)
function ProtocolProcessorSceneBattle:send_BOSSMAPBATTLE_SynPosition(battleId, combatId, positionX, positionY )
	WZLog("send_BOSSMAPBATTLE_SynPosition")
	local sender = Protocol:getSender( Protocol.MAIN_BATTLE, Protocol.BOSSMAPBATTLE_SynPosition )
	if sender==nil then WZLog("sender == nil") return end

	local viCombatId = WZLuaVector_int_:create()
	local viPositionX = WZLuaVector_int_:create()
    local viPositionY = WZLuaVector_int_:create()
	for i = 1, #combatId do
		viCombatId:push(combatId[i])	
		viPositionX:push( BattleUtil:float2int(positionX[i]) )	
        viPositionY:push( BattleUtil:float2int(positionY[i]) )
	end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInts( viCombatId )	-- 成员id
	sender:writeInts( viPositionX )	-- x坐标
	sender:writeInts( viPositionY )	-- y坐标
	SendProtocol(sender,false) --true:showLoading
end

--@brief	返回房间
function ProtocolProcessorSceneBattle:send_BOSSMAPROOM_BackToRoom(roomId,mapId, playerId)
	WZLog("send_BOSSMAPROOM_BackToRoom")
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_BackToRoom )
	if sender==nil then WZLog("sender == nil") return end
    if WBattleGlobal:getCurrent():isSingleStage() == true then return end

	sender:writeInt( roomId )	-- 房间号
	sender:writeInt( mapId )	-- 地图号
	sender:writeInt( playerId or 0 )	-- 玩家id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	抽奖
function ProtocolProcessorSceneBattle:send_BOSSMAPROOM_Reward(rewardIndex, index)
	WZLog("send_BOSSMAPROOM_Reward")
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_Reward )
	if sender==nil then WZLog("sender == nil") return end
    if WBattleGlobal:getCurrent():isSingleStage() == true then return end

    sender:writeInt( rewardIndex )	-- 翻牌的位置 1免费翻牌，2VIP翻牌，3钻石翻牌
    sender:writeInt( index or 1)	-- 第几个牌子，只有钻石翻牌需要该值. 从1开始
    
	SendProtocol(sender,false) --true:showLoading
end

--@brief	添加或移除BUFF(BATTLE_BuffChange = 65)
function ProtocolProcessorSceneBattle:send_BATTLE_BuffChange(battleId, combatId, useType, buffid, tagetId )
	WZLog("send_BATTLE_BuffChange")
	local sender = Protocol:getSender( Protocol.MAIN_BATTLE, Protocol.BATTLE_BuffChange )
	if sender==nil then WZLog("sender == nil") return end

	local tagvec = WZLuaVector_int_:create()
	if tagetId then
		for i,v in pairs(tagetId) do
	        tagvec:push(v)
		end
	end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( combatId )	-- 角色id
	sender:writeByte( useType )	-- 0添加buff，1移除buff
	sender:writeInt( buffid )	-- 技能道具的id
	sender:writeInts( tagvec )	-- 作用目标Id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	拾取幽灵技能(BATTLE_GetGhostSkill = 108)
function ProtocolProcessorSceneBattle:send_BATTLE_GetGhostSkill(battleId, playerId, uniqueId)
	WZLog("send_BATTLE_GetGhostSkill")
	local sender = Protocol:getSender( Protocol.MAIN_BATTLE, Protocol.BATTLE_GetGhostSkill )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( playerId )	-- 角色id
	sender:writeInt(uniqueId)	-- 幽灵技能Id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	移除幽灵技能(BATTLE_RemoveGhostSkill = 110)
function ProtocolProcessorSceneBattle:send_BATTLE_RemoveGhostSkill(battleId, playerId, uniqueId)
	WZLog("send_BATTLE_RemoveGhostSkill")
	local sender = Protocol:getSender( Protocol.MAIN_BATTLE, Protocol.BATTLE_RemoveGhostSkill )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( playerId )	-- 角色id
	sender:writeInt(uniqueId)	-- 幽灵技能Id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	幽灵移动(BATTLE_GhostMove = 112)
function ProtocolProcessorSceneBattle:send_BATTLE_GhostMove(battleId, playerId, movecount, movestep, curPositionX, curPositionY, movestepY, addYRate)
	WZLog("send_BATTLE_GhostMove")
	local sender = Protocol:getSender( Protocol.MAIN_BATTLE, Protocol.BATTLE_GhostMove)
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( playerId )	-- 角色id
	sender:writeInt( movecount )	-- 移动的次数
	local vtMoveStep = WZLuaVector_byte_:create()
	for i = 1, movecount do
		vtMoveStep:push( movestep[i] )	-- 每一次移动的方向（1：左，0：右）
	end
	sender:writeBytes( vtMoveStep )
	sender:writeInt( BattleUtil:float2int(curPositionX) )	-- 没移动前的x坐标
	sender:writeInt( BattleUtil:float2int(curPositionY) )	-- 没移动前的y坐标
	local vtMoveStepY = WZLuaVector_byte_:create()
	for i = 1, movecount do
		vtMoveStepY:push( movestepY[i] )	-- 每一次移动的方向（1：下，0：上）
	end
	sender:writeBytes( vtMoveStepY )
	sender:writeInt( addYRate )            
	SendProtocol(sender,false) --true:showLoading
end
-------------------------------------服务器到客户端协议回调方法模块--------------------------------------
--@brief	公会副本发送结算信息
function ProtocolProcessorSceneBattle:parse_GUILD_SendSettlementInfo(hurtValue, isWin, killerId, killerName, hrId, hrNum, krId, krNum, brId, brNum, hurtPercent)
	-- hurtValue : 总伤害输出
	-- isWin : 是否赢了
	-- killerId : 击杀玩家id
	-- killerName : 击杀玩家名称
	-- hrId : 伤害输出奖励ID
	-- hrNum : 伤害输出奖励数量
	-- krId : 击杀奖励ID
	-- krNum : 击杀奖励数量
	-- brId : BOSS产出ID
	-- brNum : BOSS产出数量
	-- hurtPercent : 伤害百分比
	WZLog("ProtocolProcessorSceneBattle:parse_GUILD_SendSettlementInfo",tostring(WBattleGlobal:getCurrent():isGuildBossStage()), Serialize(VectorToTable(hrId)), Serialize(VectorToTable(hrNum)))
	if WBattleGlobal:getCurrent():isGuildBossStage() then

        WBattleGlobal:getCurrent():setGameOver(true)
        WindowManager:removeAllWindow()
        
        hrId = VectorToTable(hrId)
        hrNum = VectorToTable(hrNum)
        krId = VectorToTable(krId)
        krNum = VectorToTable(krNum)
        brId = VectorToTable(brId)
        brNum = VectorToTable(brNum)

        local hurtReward = {id = hrId[1],num = hrNum[1]}
        local killReward = {id = krId[1],num = krNum[1]}
        local guildRewardList = {}
        for i = 1,#brId do
        	table.insert(guildRewardList,{id = brId[i],num = brNum[i]})
        end
        --额外奖励
        local exdReward = {}
        for i = 2, #hrId do
        	table.insert(exdReward,{id = hrId[i],num = hrNum[i]})
        end
        local remainHp = 0
        if not isWin then
        	local monster = WBattleGlobal:getCurrent():getBossArray()[1]
        	if monster then
        		remainHp = math.ceil(monster:getHp()/monster:getMaxHp() * 100)
        	end
        end
	    local data = {mapId = WBattleGlobal:getCurrent().m_tMakePairOk.mapId,
	    isWin = isWin, hurtValue = hurtValue, killerName = killerName,
	    killerId = killerId,hurtReward = hurtReward,killReward = killReward,
	    guildRewardList = guildRewardList,remainHp = remainHp, hurtPercent = hurtPercent, exdReward = exdReward}
	    WZLog("ProtocolProcessorSceneBattle:parse_GUILD_SendSettlementInfo",Serialize(data))
	    WndCommunityBossEnd:showWnd( data ,true)
	end
end

--@brief	发送当前回合的信息成功
function ProtocolProcessorSceneBattle:parse_BATTLE_SendCurRoundInfoOk(battleId, playerId, roundCount, playerIds, postionX, postionY, angle, face, explodePlayerId, explodeSkillId, explodePosX, explodePosY, battleInfo)
	-- battleId : 战斗id
	-- roundCount : 回合数
	-- playerIds : 所有人id
	-- postionX : x坐标
	-- postionY : y坐标
	-- angle : 角度
	-- explodePlayerId : 炸点对应的角色
	-- explodeSkillId : 炸点所使用的技能Id
	-- explodePosX : 炸点的x坐标
	-- explodePosY : 炸点的y坐标

	if playerId == WBattleGlobal:getCurrent():getMyBattleId() then
		WBattleGlobal:getCurrent().m_bSendCurRoundInfoOk = roundCount
	else
		table.insert(WBattleGlobal:getCurrent().m_bSendCurRoundInfoLisk, playerId)
	end
	WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_SendCurRoundInfoOk",battleId, "battleInfo", battleInfo, "playerId", playerId, roundCount,"\nplayer", 
		Serialize(VectorToTable(playerIds)), Serialize(IntVectorToFloatTable(postionX)), Serialize(IntVectorToFloatTable(postionY)), 
		Serialize(IntVectorToFloatTable(angle)), Serialize(IntVectorToFloatTable(face)), "\nexplode", Serialize(VectorToTable(explodePlayerId)), 
		Serialize(VectorToTable(explodeSkillId)), Serialize(IntVectorToFloatTable(explodePosX)), Serialize(IntVectorToFloatTable(explodePosY)))
end

--@brief	重连同步战斗信息成功
function ProtocolProcessorSceneBattle:parse_BATTLE_SynchronousBattleInfoOk(battleId, playerIds, dataIds, masterIds, camp, 
	hp, sp, CTB, propIds, postionX, postionY, angle, face, buffCount, buffId, buffPassCtb, buffUserId, 
	explodePlayerId, explodeSkillId, explodePosNum, explodePosX, explodePosY, finishPercent, roundNum, killCount, 
	onlineStatus, battleInfo)
	-- battleId : 战斗id
	-- playerIds : 角色id
	-- dataIds : 数据表id(玩家为0,怪物为对应的ID)
	-- hp : 角色的血量
	-- sp : 角色的怒气
	-- CTB : 角色的回合CTB
	-- postionX : 角色的x坐标
	-- postionY : 角色的y坐标
	-- angle : 角色的角度
	-- buffCount : 角色的buff数目
	-- buffId : buff的ID
	-- buffPassCtb : buff剩下的CTB时间
	-- buffUserId : buff的使用者ID
	-- explodePlayerId : 炸点对应的角色
	-- explodeSkillId : 炸点所使用的技能
	-- explodePosX : 炸点的x坐标
	-- explodePosY : 炸点的y坐标
	-- onlineStatus: 玩家在线状态（0在线，1掉线，2强退）
	WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_SynchronousBattleInfoOk", roundNum, "\n设置当前属性",Serialize(VectorToTable(playerIds)), Serialize(VectorToTable(dataIds)), Serialize(VectorToTable(masterIds)), Serialize(VectorToTable(camp)), 
		"\nhp",Serialize(VectorToTable(hp)), Serialize(VectorToTable(sp)), Serialize(VectorToTable(CTB)), Serialize(IntVectorToFloatTable(postionX)), Serialize(IntVectorToFloatTable(postionY)), Serialize(IntVectorToFloatTable(angle)), Serialize(VectorToTable(face))
		, "\n增减buff", Serialize(VectorToTable(buffCount)), Serialize(VectorToTable(buffId)), Serialize(VectorToTable(buffPassCtb)), Serialize(VectorToTable(buffUserId))
		, "\n地图爆炸", Serialize(VectorToTable(explodePlayerId)), Serialize(VectorToTable(explodeSkillId)), Serialize(VectorToTable(explodePosNum)), Serialize(IntVectorToFloatTable(explodePosX)), Serialize(IntVectorToFloatTable(explodePosY))
		, "\n被杀次数", Serialize(VectorToTable(killCount)), "\n在线状态", Serialize(VectorToTable(onlineStatus)), finishPercent, "\nbattleInfo", type(battleInfo), battleInfo, "\npropIds", Serialize(VectorToTable(propIds)))

	--[[
	WBattleGlobal:getCurrent().m_nHostBattleId = nil
	WBattleGlobal:getCurrent():synchronousBattleInfo(
		VectorToTable(playerIds), VectorToTable(dataIds), VectorToTable(masterIds), VectorToTable(hp), VectorToTable(sp), VectorToTable(CTB), IntVectorToFloatTable(postionX), IntVectorToFloatTable(postionY)
		, IntVectorToFloatTable(angle), VectorToTable(face), VectorToTable(buffCount), VectorToTable(buffId), VectorToTable(buffPassCtb), VectorToTable(buffUserId)
		, VectorToTable(explodePlayerId), VectorToTable(explodeSkillId), VectorToTable(explodePosNum), IntVectorToFloatTable(explodePosX), IntVectorToFloatTable(explodePosY),finishPercent)
	--]]

	local tempHp1 = VectorToTable(hp)
	local tempHp = {}
	for i = 1, #tempHp1 do
		tempHp[i] = tonumber(tempHp1[i])
	end

	--战斗中
	if finishPercent == 100 then
		MsgManager:clear(true, true)
	    WBattleGlobal:getCurrent():clearBulletsList()
	    WBattleGlobal:getCurrent():clearBossBulletsList()

		local data = {}
		data.playerIds = VectorToTable(playerIds)
		data.dataIds = VectorToTable(dataIds)
		data.masterIds = VectorToTable(masterIds)
		data.camp = VectorToTable(camp)
		data.hp = tempHp
		data.sp = VectorToTable(sp)
		data.CTB = VectorToTable(CTB)
		data.propIds = propIds and VectorToTable(propIds) or {}
		data.postionX = IntVectorToFloatTable(postionX)
		data.postionY = IntVectorToFloatTable(postionY)
		data.angle = IntVectorToFloatTable(angle)
		data.face = VectorToTable(face)

		data.buffCount = VectorToTable(buffCount)
		data.buffId = VectorToTable(buffId)
		data.buffPassCtb = VectorToTable(buffPassCtb)
		data.buffUserId = VectorToTable(buffUserId)

		data.explodePlayerId = VectorToTable(explodePlayerId)
		data.explodeSkillId = VectorToTable(explodeSkillId)
		data.explodePosNum = VectorToTable(explodePosNum)
		data.explodePosX = IntVectorToFloatTable(explodePosX)
		data.explodePosY = IntVectorToFloatTable(explodePosY)
		data.finishPercent = finishPercent
		data.roundNum = roundNum
		data.killCount = VectorToTable(killCount)
		data.onlineStatus = VectorToTable(onlineStatus)
		data.battleInfo = battleInfo

		local msg = MsgManager:createMsg(BattleMsgSynchronousBattleInfo)
		msg.m_tData = data
	    MsgManager:pushBlockMsg(msg)
	else
		--加载中
		if WBattleGlobal:getCurrent().m_nRelinkLoading ~= -1 then
	        MsgBoxManager:stopLoadingBoxByMsgId(WBattleGlobal:getCurrent().m_nRelinkLoading)
	        WBattleGlobal:getCurrent().m_nRelinkLoading = -1
	    end
		if SceneBattleLoading.__bReceivePos == false then
			SceneBattleLoading.m_bIsTestLink = true
			SceneBattleLoading.__bReceivePos = nil
		end
		WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle = nil
	end
end

--@brief	通知其他玩家有玩家返回战斗成功
function ProtocolProcessorSceneBattle:parse_BATTLE_ComeBackBattleInfoOk(battleId, playerId)
	-- battleId : 战斗id
	-- playerId : 角色id
	WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_ComeBackBattleInfoOk", playerId)
	WBattleGlobal:getCurrent().m_nComeBackBattleId = playerId
	local msg = MsgManager:createMsg(BattleMsgComeBackBattleInfoOk)
	msg.m_nPlayerId = playerId
	MsgManager:pushBlockMsg(msg)
end

--@brief	获得战斗道具
function ProtocolProcessorSceneBattle:parse_BATTLE_SendPropsList(catchId, propsId)
    WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_SendPropsList", WBattleGlobal:getCurrent().m_nTurnTimes, Serialize(VectorToTable(catchId)), Serialize(VectorToTable(propsId)))

    WBattleGlobal:getCurrent().m_tTreasureCatchIdList = VectorToTable(catchId)
    WBattleGlobal:getCurrent().m_tTreasureAppearList = VectorToTable(propsId)
    WBattleGlobal:getCurrent().m_nTreasureRound = WBattleGlobal:getCurrent().m_nTurnTimes
    --WBattleGlobal:getCurrent():buildTreasure(VectorToTable(propsId))
end

--@brief	击中战斗道具
function ProtocolProcessorSceneBattle:parse_BATTLE_HitPropOK(battleId, playerId, catchId, propsId)
	--propsId = {[1]=32,[2]=36,}
	propsId = VectorToTable(propsId)
	if not WBattleGlobal:getCurrent():isEscapeBattle() then
		return
	end
    WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_HitPropOK one",playerId , catchId, Serialize(propsId))
    
    local msg = MsgManager:createMsg(BattleMsgGetProp)
	msg.m_tData = {playerIds={[1]=playerId},propsIds={[1]=propsId}}
	MsgManager:pushNonBlockMsg(msg)
	WBattleGlobal:getCurrent():destroyErosionTreasure(catchId)
end

--@brief	添加Buff
--@return	#1:返回数据表
function ProtocolProcessorSceneBattle:parse_BATTLE_AddBuff(userId, playerId,useType, buffId)
    WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_AddBuff", playerId, buffId,userId)

    local hero = WBattleGlobal:getCurrent():getCharacterWithId(userId)
    	
    local msg = MsgManager:createMsg(BattleMsgAddBuff)
	msg.m_tData = {userId=userId,playerId=playerId,buffId=buffId,useType = useType}
    if hero and hero:isDead() and WBattleGlobal:getCurrent():isGhostStage() then 
		MsgManager:pushNonBlockMsg(msg)
	else
		MsgManager:pushBlockMsg(msg)
	end
end

--@brief	通知角色当前操作角色时间到了
--@return	#1:返回数据表
function ProtocolProcessorSceneBattle:parse_BATTLE_CanStartCurRound(battleId, playerId, wind, attackRate, battleRand, playerIds, nowHP, nowSP, oldCTB, newCTB, updateCTB_time, windSkillId)
	-- battleId : 战斗id
	-- playerId : 角色id(发给哪个的)
	-- wind : 风力（负数为坐风向，正数为右风向）
	-- currentPlayerId : 角色id(下回和操作的角色）
	-- isCrit : 是否暴击(0否1是)
	-- attackRate : 攻击力比率
	-- isNewRound : 是否新回合1是0否
	-- battleRand : 游戏随机数
	-- windSkillId : 当前回合的风向药剂技能ID，0表示不存在
	WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_CanStartCurRound", WBattleGlobal:getCurrent().m_nTurnTimes,windSkillId)
    WBattleGlobal:getCurrent().m_nStartRoundTimes = WBattleGlobal:getCurrent().m_nTurnTimes + 1
    WBattleGlobal:getCurrent().m_nStartRoundPlayerId = playerId

    if WBattleGlobal:getCurrent().m_nTurnTimes == 0 then
    	--WndBattleHud:joinVoice()
    end
	local tPlayerId = VectorToTable(playerIds)
	local tNowHP = VectorToTable(nowHP)
    local tNowSP = VectorToTable(nowSP)

	local hero = WBattleGlobal:getCurrent():getCharacterWithId(playerId)

	if hero == nil then
		WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_CanStartCurRound", "can't find player:", playerId)
		WBattleGlobal:getCurrent():endCurRound(WBattleGlobal:getCurrent():getMyBattleId(),40,nil,nil,true)
		return
	end
	
	local tNowCtb = VectorToTable(oldCTB)
	local tNewCtb = VectorToTable(newCTB)
	BattleCtbManager:refreshLastCtb(tPlayerId,tNowCtb,tNewCtb,updateCTB_time)

    WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_CanStartCurRound turn \n tPlayerId=",Serialize(tPlayerId),"\n tNowHP=", Serialize(tNowHP),"\n tNowSP=", Serialize(tNowSP),"\n tNowCtb=", Serialize(tNowCtb), "\n tNewCtb", Serialize(tNewCtb),"\n updateCTB_time=", updateCTB_time,"\n battleRand=", Serialize(VectorToTable(battleRand)))

    local tempNowHp = {}
    for i = 1, #tNowHP do
    	tempNowHp[i] = tonumber(tNowHP[i])
    end
	local msg = MsgManager:createMsg(BattleMsgShowCtbTime)
	msg.m_tPlayerId = tPlayerId
	msg.m_tNowHP = tempNowHp
	msg.m_tNowSP= tNowSP
	msg.m_tBattleRand = VectorToTable(battleRand)
    MsgManager:pushBlockMsg(msg)

    ---[[
	local msg = MsgManager:createMsg(BattleMsgZoomToHero)
	msg.m_nPlayerId = playerId
	msg.m_nPlayerPos = hero:getAnimation():getPosition()
    msg.m_bIsFollow = true
	MsgManager:pushBlockMsg(msg)
    --]]

    local msg = MsgManager:createMsg(BattleMsgReadyStartRound)
    MsgManager:pushBlockMsg(msg)

	local msg = MsgManager:createMsg(BattleMsgCanStartCurRound)
	msg.m_nBattleId = battleId
	msg.m_nPlayerId = playerId
	msg.m_nCurrentPlayerId = playerId
	msg.m_nWind = wind
	msg.m_bIsCrit = 0
	msg.m_tAttackRate = VectorToTable(attackRate)
	msg.m_nIsNewRound = isNewRound
    msg.m_tBattleRand = VectorToTable(battleRand)
    msg.m_nWindSkillId = windSkillId
	MsgManager:pushBlockMsg(msg)
end

--@brief	其他角色移动
--@return	#1:返回数据表
function ProtocolProcessorSceneBattle:parse_BATTLE_OtherPlayerMove(battleId, playerId, currentPlayerId, movecount, movestep, curPositionX, curPositionY)
	-- battleId : 战斗id
	-- playerId : 角色id(发给哪个的)
	-- currentPlayerId : 角色id(当前在操作的角色）
	-- movecount : 移动的次数
	-- movestep : 每一次移动的方向（1：左，0：右）
	-- curPositionX : 没移动前的x坐标
	-- curPositionY : 没移动前的y坐标
	WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_OtherPlayerMove zero", battleId, playerId, currentPlayerId, movecount, movestep, curPositionX, curPositionY)
    local localPlayerPos = WBattleGlobal:getCurrent():getCharacterWithId(currentPlayerId):getPosition()
	WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_OtherPlayerMove", curPositionX, curPositionY, localPlayerPos and localPlayerPos.x, localPlayerPos and localPlayerPos.y, movecount)

	local msg = MsgManager:createMsg(BattleMsgPlayerMove)
	msg.m_nBattleId = battleId
	msg.m_nPlayerId = playerId
	msg.m_nCurrentPlayerId = currentPlayerId
	msg.m_nMovecount = movecount
	msg.m_tMovestep = {}
	for i = 1, movecount do
		table.insert(msg.m_tMovestep, movestep:get(i-1))
	end
	msg.m_nCurPositionX = BattleUtil:int2float(curPositionX)
	msg.m_nCurPositionY = BattleUtil:int2float(curPositionY)
	MsgManager:pushBlockMsg(msg)
end

--@brief	其他角色使用技能和道具
function ProtocolProcessorSceneBattle:parse_BATTLE_OtherSkillEquip(battleId,  currentId, item_id, targetIds, params, spatterAngle)
	-- battleId : 战斗id
	-- playerId : 角色id
	-- currentPlayerId : 角色id(当前在操作的角色）
	-- item_count : 使用技能道具的数量(服务器要设置上限）
	-- item_id : 技能道具的id
	-- spatterAngle : 溅射子弹角度

	WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_OtherSkillEquip", currentId, item_id)
	--图腾加血技能不需要同步
	local config = CopyTable(GDatatab_skill["id_"..item_id])
	if config and config.isNotSync == 1 then
		return
	end
	if (config.id_group == 107 and config.sub_type == 12) or item_id == 2060 or item_id == 2148 or item_id == 20052 or item_id == 20053 or item_id == 20054 or item_id == 2151 then
		WBattleGlobal:getCurrent():setCurSpatterAngle(VectorToTable(spatterAngle))
	end
	local hero = WBattleGlobal:getCurrent():getCharacterWithId(currentId)
	local nType = BattleHeroUse.USE_SKILL_OR_ITEM
	local nPlayerId = currentId
	if config.skill_type == 9 then 
		local tTargetId = VectorToTable(targetIds)
		WZLog("parse_BATTLE_OtherSkillEquip 0000", #tTargetId, Serialize(tTargetId))
		for i = 1, #tTargetId do
			hero = WBattleGlobal:getCurrent():getCharacterWithId(tTargetId[i])
			nType = BattleHeroUse.USE_GHOSTSKILL
			nPlayerId = tTargetId[i]
			if hero then 
				break 
			end
		end
		if hero and hero:getType() == 0 then
			local msg = MsgManager:createMsg(BattleMsgUseSkill)
			msg.m_tData = {playerId=nPlayerId,type=nType,itemId=item_id, targetId = tTargetId, ownPlayerId = currentId}
			MsgManager:pushNonBlockMsg(msg)
		end
	else
	    if hero and hero:isCanControl() == false and hero:getType() == 0 then
				-- BattleHeroUse:heroUse(currentId,BattleHeroUse.USE_SKILL_OR_ITEM,item_id)
			local msg = MsgManager:createMsg(BattleMsgUseSkill)
			msg.m_tData = {playerId=nPlayerId,type=nType,itemId=item_id}
			MsgManager:pushBlockMsg(msg)
			--机器人移除使用的技能道具
			if WBattleGlobal:getCurrent():getMyBattleId() ~= nPlayerId then
				for i,v in pairs (hero.m_tItems) do
			        WZLog("parse_BATTLE_OtherSkillEquip:two", i, item_id, v)
			        if item_id == v then
			            table.remove(hero.m_tItems, i)
			            break
			        end
			    end
			end
		end
		
		if hero and hero:isCanControl() == false and hero:getType() == 1 then
			--添加本回合技能同步
			local msg = MsgManager:createMsg(BattleMsgSyncSkill)
			msg.m_nCurrentPlayerId = currentId
			msg.m_nSkillId = item_id
			MsgManager:pushBlockMsg(msg)
		end
	end
end

--@brief	更新怒气值
function ProtocolProcessorSceneBattle:parse_BATTLE_ChangeAngryValue(battleId, playerId, AngryValue)
	-- battleId : 战斗id
	-- playerId : 角色id(发给哪个的)
	-- AngryValue : 更新怒气值（由服务器计算所得）
	WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_ChangeAngryValue", AngryValue)

	--WBattleGlobal:getCurrent():getHeroWithId(playerId):setSp(AngryValue)
end

--@brief	是否可以使用大招
function ProtocolProcessorSceneBattle:parse_BATTLE_OtherBigSkill(battleId, playerId, currentPlayerId)
	-- battleId : 战斗id
	-- playerId : 角色id(发给哪个的)
	-- currentPlayerId : 角色id(当前在操作的角色）
	WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_OtherBigSkill")

	local msg = MsgManager:createMsg(BattleMsgUseSkill)
	msg.m_tData = {playerId=currentPlayerId,type=BattleHeroUse.USE_BIGSKILL,itemId=nil}
	MsgManager:pushBlockMsg(msg)
end

--@brief	其它人发射
function ProtocolProcessorSceneBattle:parse_BATTLE_OtherShoot(battleId, playerId, currentPlayerId, speedx, speedy, leftRight, startX, startY, playerCount, playerIds, curPositionX, curPositionY, curPositionR, curPositionD)
	-- battleId : 战斗id
	-- playerId : 角色id(发给哪个的)
	-- currentPlayerId : 角色id(当前在操作的角色）
	-- speedx : 发射速度
	-- speedy : 发射速度
	-- leftRight : 1：左 0：右（向左还是向右）
	-- startX : 发射初始位置
	-- startY : 发射初始位置
	-- playerCount : 同步角色数量
	-- playerIds : 用户id
	-- curPositionX : 没飞行前的x坐标
	-- curPositionY : 没飞行前的y坐标

	local speedx1 = BattleUtil:int2float(speedx)
	local speedy1 = BattleUtil:int2float(speedy)

    WBattleGlobal:getCurrent().m_tCurRoundAction = {round=WBattleGlobal:getCurrent().m_nTurnTimes, player=currentPlayerId}

	local msg = MsgManager:createMsg(BattleMsgPlayerShoot)
	msg.m_nBattleId = battleId
	msg.m_nPlayerId = playerId
	msg.m_nCurrentPlayerId = currentPlayerId
	msg.m_nStartX = BattleUtil:int2float(startX)
	msg.m_nStartY = BattleUtil:int2float(startY)
	msg.m_nLeftRight = leftRight
	msg.m_nSpeedx = speedx1
	msg.m_nSpeedy = speedy1
	msg.m_nPlayerCount = playerCount
	msg.m_tPlayerId = {}
	msg.m_tCurPositionX = {}
	msg.m_tCurPositionY = {}
    msg.m_tCurPositionR = {}
    msg.m_tCurPositionD = {}
	for i = 1, playerCount do
		table.insert(msg.m_tPlayerId, playerIds:get(i-1))
	end
	for i = 1, playerCount do
		table.insert(msg.m_tCurPositionX, BattleUtil:int2float(curPositionX:get(i-1)) )
	end
	for i = 1, playerCount do
		table.insert(msg.m_tCurPositionY, BattleUtil:int2float(curPositionY:get(i-1)) )
	end
    for i = 1, playerCount do
        table.insert(msg.m_tCurPositionR, BattleUtil:int2float(curPositionR:get(i-1)) )
    end
    for i = 1, playerCount do
        table.insert(msg.m_tCurPositionD, BattleUtil:int2float(curPositionD:get(i-1)) )
    end

    WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_OtherShoot", currentPlayerId, "speedx, speedy", speedx, speedy, "speedx1, speedy1", speedx1, speedy1, Serialize(msg.m_tCurPositionR),Serialize(msg.m_tCurPositionD))
	MsgManager:pushBlockMsg(msg)
end


--@brief	其它人飞行
function ProtocolProcessorSceneBattle:parse_BATTLE_OtherFly(battleId, playerId, currentPlayerId, speedx, speedy, leftRight, isEquip, startX, startY, playerCount, playerIds, curPositionX, curPositionY)
	-- battleId : 战斗id
	-- playerId : 角色id(发给哪个的)
	-- currentPlayerId : 角色id(当前在操作的角色）
	-- speedx : 飞行速度
	-- speedy : 飞行速度
	-- leftRight : 1：左 0：右（向左还是向右）
	-- isEquip : 是否道具飞行（0否1是）
	-- startX : 飞行初始位置
	-- startY : 飞行初始位置
	-- playerCount : 同步角色数量
	-- playerIds : 用户id
	-- curPositionX : 没飞行前的x坐标
	-- curPositionY : 没飞行前的y坐标
	WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_OtherFly", playerCount)

    WBattleGlobal:getCurrent().m_tCurRoundAction = {round=WBattleGlobal:getCurrent().m_nTurnTimes, player=currentPlayerId}

	local msg = MsgManager:createMsg(BattleMsgPlayerFly)
	msg.m_nBattleId = battleId
	msg.m_nPlayerId = playerId
	msg.m_nCurrentPlayerId = currentPlayerId
	msg.m_nStartX = BattleUtil:int2float(startX)
	msg.m_nStartY = BattleUtil:int2float(startY)
	msg.m_nLeftRight = leftRight
	msg.m_nIsEquip = isEquip
	msg.m_nSpeedx = BattleUtil:int2float(speedx)
	msg.m_nSpeedy = BattleUtil:int2float(speedy)
	msg.m_nPlayerCount = playerCount
	msg.m_tPlayerId = VectorToTable(playerIds)
	msg.m_tCurPositionX = {}
	msg.m_tCurPositionY = {}
	for i = 1, playerCount do
		table.insert(msg.m_tCurPositionX, BattleUtil:int2float(curPositionX:get(i-1)) )
	end
	for i = 1, playerCount do
		table.insert(msg.m_tCurPositionY, BattleUtil:int2float(curPositionY:get(i-1)) )
	end
	MsgManager:pushBlockMsg(msg)
end

--@brief	人物死亡
function ProtocolProcessorSceneBattle:parse_BATTLE_SomeOneDead(battleId, playerId, PlayerIds, firstBlood, killNum)
	-- battleId : 战斗id
	-- playerId : 角色id
	-- deadPlayerCount : 死亡人量
	-- PlayerIds : 谁死了
	-- firstBlood : 是否首杀
	WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_SomeOneDead one", playerId, tostring(firstBlood), killNum)

	if WBattleGlobal:getCurrent():getBattleType() == BattleConstants.g_nBATTLE_TYPE_BOSS then
		self:parse_BOSSMAPBATTLE_SomeOneDead(battleId,  PlayerIds)
		return 
	end

	if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_NORMAL and WBattleGlobal:getCurrent().m_tMakePairOk.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_FH then
		WBattleGlobal:getCurrent().m_tReceiveDeadPlayerId = VectorToTable(PlayerIds)
	end

    local msg = MsgManager:createMsg(BattleMsgSomeOneDead)
    msg.m_nBattleId = battleId
    msg.m_nPlayerId = playerId
    msg.m_nDeadPlayerCount = #VectorToTable(PlayerIds)
    msg.m_tPlayerIds = VectorToTable(PlayerIds)
    msg.m_bFirstBlood = VectorToTable(firstBlood)
    msg.m_nKillNum = killNum
    msg.m_bIsShow = true
    MsgManager:pushBlockMsg(msg)

    --WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_SomeOneDead two", playerId, beKillId, tostring(isKillPre), tostring(showKillCount))
end

--@brief	人物死亡
function ProtocolProcessorSceneBattle:parse_BOSSMAPBATTLE_SomeOneDead(battleId,  PlayerIds)
	-- battleId : 战斗id
	-- deadPlayerCount : 死亡人量
	-- PlayerIds : 谁死了
	-- deadGuaiCount : 死亡怪量
	-- guaiBattleIds : 谁死了
	WZLog("ProtocolProcessorSceneBattle:parse_BOSSMAPBATTLE_SomeOneDead")
	local msg = MsgManager:createMsg(BattleMsgSomeOneDead)
	msg.m_nBattleId = battleId
    msg.m_nDeadPlayerCount = #VectorToTable(PlayerIds)
	msg.m_tPlayerIds = VectorToTable(PlayerIds)
	MsgManager:pushBlockMsg(msg)

	for i,deadHero in pairs(VectorToTable(PlayerIds)) do
        local hero = WBattleGlobal:getCurrent():getCharacterWithId(deadHero)
        WZLog("ProtocolProcessorSceneBattle:parse_BOSSMAPBATTLE_SomeOneDead m_bServerDead", i,deadHero)
    end
	WMonster:receiveSomeOneDead(deadPlayerCount, VectorToTable(PlayerIds), deadGuaiCount, VectorToTable(guaiBattleIds))
	-- for id,guai in pairs(WBattleGlobal:getCurrent():getGuaiList()) do
	-- 	guai:receiveSomeOneDead(deadPlayerCount, VectorToTable(PlayerIds), deadGuaiCount, VectorToTable(guaiBattleIds))
	-- end
end

--@brief	跳过本轮操作
function ProtocolProcessorSceneBattle:parse_BATTLE_OtherPass(battleId, playerId, currentPlayerId)
	-- battleId : 战斗id
	-- playerId : 角色id
	-- currentPlayerId : 角色id(当前在操作的角色）
	WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_OtherPass")

    if WBattleGlobal:getCurrent().m_bIsCurTurnActed == true then
        --return
    end
	
	-- WndBattleHud:endTurnTime()
	-- WBattleGlobal:getCurrent():endCurRound(WBattleGlobal:getCurrent():getMyBattleId(),41,nil,nil,true)

	local msg = MsgManager:createMsg(BattleMsgOtherPass)
	msg.m_nBattleId = battleId
	msg.m_nPlayerId = playerId
	msg.m_nCurrentPlayerId = currentPlayerId
	MsgManager:pushBlockMsg(msg)
end

--@brief	通知游戏结束(BATTLE_GameOver = 27)
function ProtocolProcessorSceneBattle:parse_BATTLE_GameOver(battleId, firstKillPlayerId, winCamp, playerIds, playerCamp, shootRate, killCount, integral, tournamentLevel, serverId, mvpId, mvpTimes, continuousKillNums, continuousKillTimes, weekIncome, weekIncomeLimit, gainCoin, weekCoinIncome, weekCoinIncomeLimit, continuousWinTimes, prePlayerLevel, prePlayerExp, addExp, preSportLevel, preSportScore, addSportScore, preRankLevel, preRankScore, addRankScore,integralAdds, rewardItem, rewardDropTimes)
	-- battleId : 战斗id
	-- firstKillPlayerId : 首杀角色
	-- winCamp : 胜利的一方
	-- playerIds : 角色id
	-- playerCamp : 角色的阵营
	-- shootRate : 命中率(放大100倍)
	-- killCount : 杀人数(包括同队的)
	-- integral : 获得积分(娱乐赛,排位赛以外的战斗使用)
	-- tournamentLevel : 竞技等级
	-- serverId : 玩家服id
	-- mvpId : mvpId
	-- mvpTimes : 总mvp次数
	-- continuousKillNums : 连杀次数
	-- continuousKillTimes : 本连杀总次数
	-- weekIncome : 经验每周收益
	-- weekIncomeLimit : 经验每周收益上限
	-- gainCoin : 竞技币
	-- weekCoinIncome : 竞技币-每周收益
	-- weekCoinIncomeLimit : 竞技币-每周收益上限
	-- continuousWinTimes : 连胜次数
	-- prePlayerLevel : 之前等级(玩家)
	-- prePlayerExp : 之前积分(玩家)
	-- addExp : 获得经验(玩家)
	-- preSportLevel : 之前等级-竞技
	-- preSportScore : 之前积分-竞技
	-- addSportScore : 增加竞技积分
	-- preRankLevel : 之前排位赛等级
	-- preRankScore : 之前排位赛勇者积分
	-- addRankScore : 增加排位赛勇者积分
	-- integralAdds : 玩家积分加成
	-- rewardItem : 掉落的奖励
	-- rewardDropTimes : 当天奖励掉落次数
	WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_GameOver")

    local playerId = CacheCenter:getPlayerInfo().id

    if WBattleGlobal:getCurrent():isAudience() or WBattleGlobal:getCurrent():isReplayGame() then
    	playerId = WBattleGlobal:getCurrent():getMyBattleId()
	end

    WBattleGlobal:getCurrent():setGameOver(true)
	WindowManager:removeAllWindow()
    local msg = MsgManager:createMsg(BattleMsgGameOver)
	msg.m_bWin = WBattleGlobal:getCurrent():getHeroWithId(playerId):getCamp() == winCamp
    WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_GameOver", tostring(msg.m_bWin), winCamp, WBattleGlobal:getCurrent():getHeroWithId(playerId):getCamp(), playerId)

    msg.m_tSettlementData = {
        battleId = battleId,
        firstKillPlayerId = firstKillPlayerId,
        winCamp = winCamp,
        playerIds = VectorToTable(playerIds),
        playerCamp = VectorToTable(playerCamp),
        shootRate = VectorToTable(shootRate),
        killCount = VectorToTable(killCount),
        integral = VectorToTable(integral),
        tournamentLevel = VectorToTable(tournamentLevel),
        serverId = VectorToTable(serverId),
        mvpId = mvpId,

        mvpTimes = mvpTimes, --vip成就次数
        continuousKillNums = continuousKillNums, --获得3,4,5杀次数（有次数更新时候刷）
        continuousKillTimes = continuousKillTimes,	

        gainCoin = gainCoin,
        weekCoinIncome = weekCoinIncome,	--获得竞技币
        weekCoinIncomeLimit = weekCoinIncomeLimit, --周上限制
        weekIncome = weekIncome,	--当周获得经验
        weekIncomeLimit = weekIncomeLimit,

        continuousWinTimes = continuousWinTimes,	--连赢次数

        prePlayerLevel = prePlayerLevel,	--当前英雄等级
        prePlayerExp = prePlayerExp,	--当前英雄经验
        addExp = addExp,	--获得英雄经验

        preSportLevel = preSportLevel,
        preSportScore = preSportScore,
        addSportScore = addSportScore,

        preRankLevel = preRankLevel,
        preRankScore = preRankScore,
        addRankScore = addRankScore,

        integralAdds = VectorToTable(integralAdds),
      
        isWin = msg.m_bWin,
    }
    if WBattleGlobal:getCurrent():isReplayGame() then
    	msg.m_tSettlementData.isVideo = true
	end

    MsgManager:pushNonBlockMsg(msg)
    RANK_OVER_REWARD_ID = rewardItem
    RANK_OVER_REWARD_COUNT = rewardDropTimes

    TeachGroup1:taskTeach(TeachGroup1.TASK_ID_6)
end



--@brief	玩家掉线
function ProtocolProcessorSceneBattle:parse_BATTLE_PlayerLose(battleId, playerId, currentPlayerId, isQuit)
	-- battleId : 战斗id
	-- playerId : 角色id(发给哪个的)
	-- currentPlayerId : 掉线角色id
    -- isQuit : 是否强退
	WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_PlayerLose",playerId, currentPlayerId, tostring(isQuit))
	if currentPlayerId == WBattleGlobal:getCurrent():getMyBattleId() and (not WBattleGlobal:getCurrent():isAudience() or WBattleGlobal:getCurrent():isReplayGame())then
		MsgBoxManager:showConfirmBox(LocalStrings.BATTLE_RECONNECT_FAIL, SceneBattle, SceneBattle.leftBattle, MSGBOXLEVEL_NORMAL, nil, true)
        --WBattleGlobal:getCurrent().m_nShowNetLostTime = 5
        
	end

    local msg = MsgManager:createMsg(BattleMsgPlayerExit)
    msg.m_nBattleId = battleId
    msg.m_nPlayerId = currentPlayerId
    msg.m_bIsQuit = isQuit
    MsgManager:pushBlockMsg(msg)

end

--@brief	人物复活
function ProtocolProcessorSceneBattle:parse_BATTLE_PlayerReborn(battleId, playerId, playercount, PlayerIds, postionX, postionY)
	-- battleId : 战斗id
	-- playerId : 角色id(发给哪个的)
	-- playercount : 人数
	-- PlayerIds : 所有人id
	-- postionX : x坐标
	-- postionY : y坐标
	WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_PlayerReborn")
	
	for i,deadHero in pairs(VectorToTable(PlayerIds)) do
        local hero = WBattleGlobal:getCurrent():getCharacterWithId(deadHero)
        hero.m_bServerDead = nil
        BattleMsgSomeOneDead:removeRebornPosList(deadHero)
        WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_PlayerReborn m_bServerDead")
    end

	local msg = MsgManager:createMsg(BattleMsgPlayerReborn)
	msg.m_nBattleId = battleId
	msg.m_nPlayerId = playerId
	msg.m_nPlayercount = playercount
	msg.m_tPlayerIds = VectorToTable(PlayerIds)
	msg.m_tPostionX = VectorToTable(postionX)
	msg.m_tPostionY = VectorToTable(postionY)
	MsgManager:pushBlockMsg(msg)

	local msg1 = MsgManager:createMsg(BattleMsgUpdatePlayerHP)
	msg1.m_nBattleId = battleId
	msg1.m_nPlayerId = playerId
	msg1.m_nPlayercount = playercount
	msg1.m_tPlayerIds = VectorToTable(PlayerIds)
	msg1.m_bReborn = true
	msg1.m_tHp = {}
	for i=1,playercount do
		msg1.m_tHp[i] = WBattleGlobal:getCurrent():getHeroWithId(msg1.m_tPlayerIds[i]):getMaxHp()
	end
	MsgManager:pushBlockMsg(msg1)
end

--@brief	更新每个阵营的击杀数量
function ProtocolProcessorSceneBattle:parse_BATTLE_UpdateMedal(battleId, playerId, campCount, campId, campMedalNum)
	-- battleId : 战斗id
	-- playerId : 角色id(发给哪个的)
	-- campCount : 阵营数量
	-- campId : 阵营id
	-- campMedalNum : 阵营所得的奖牌数
	WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_UpdateMedal")
end

--@brief	强制退出战斗成功
function ProtocolProcessorSceneBattle:parse_BATTLE_QuitBattleOk(battleId, playerId)
	-- battleId : 战斗id
	-- playerId : 角色id
	WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_QuitBattleOk")

	if not WBattleGlobal:getCurrent():isAudience() or not WBattleGlobal:getCurrent():isReplayGame() then
		MsgBoxManager:showConfirmBox(LocalStrings.BATTLE_RECONNECT_FAIL, SceneBattle, SceneBattle.leftBattle, MSGBOXLEVEL_NORMAL, nil, true)
	end
end

--@brief	其他人使用表情
function ProtocolProcessorSceneBattle:parse_BATTLE_OtherUsingFace(battleId, playerId, faceId)
	-- battleId : 战斗id
	-- playerId : 角色id
	-- currentPlayerId : 哪个角色使用表情
	-- faceId : 使用的表情
	WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_OtherUsingFace")

	local hero = WBattleGlobal:getCurrent():getHeroWithId(playerId)
	hero:playFaceAnimation(faceId)
end


--@brief	boss变身
function ProtocolProcessorSceneBattle:parse_BOSSMAPBATTLE_OtherChange(battleId, guaiBattleId, guaiOldId, guaiNewId)
	-- battleId : 战斗id
	-- guaiBattleId : 怪的战斗id
	-- guaiOldId : 变身前在表中的id
	-- guaiNewId : 变身后在表中的id
	WZLog("ProtocolProcessorSceneBattle:parse_BOSSMAPBATTLE_OtherChange")
	local guai = WBattleGlobal:getCurrent():getGuaiWithId(guaiBattleId)
	if guai ~= nil then
		guai:receiveBossChange(VectorToTable(guaiOldId), VectorToTable(guaiNewId))
		return
	end
end

--@brief	开始新的战斗操作计时错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBattle:send_BATTLE_StartNewTimer_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBattle:send_BATTLE_StartNewTimer_ErrorProcess")
	MsgBoxManager:showTipBox(sMessage)
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BATTLE, Protocol.BATTLE_StartNewTimer, nflag, sMessage)
end

--@brief	通知客户端对指定角色进行控制
function ProtocolProcessorSceneBattle:parse_BATTLE_AIControlCommon(battleId, idcount, playerIds)
	-- battleId : 战斗id
	-- idcount : 要控制的ai数量
	-- playerIds : 需要被控制的角色id
	-- aiCtrlId : 控制方案id
	WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_AIControlCommon")

	SceneBattleLoading:receiveAIControlCommon(VectorToTable(battleId), VectorToTable(idcount), VectorToTable(playerIds))

end

--@brief	其他人加载百份比
function ProtocolProcessorSceneBattle:parse_BATTLE_OtherLoadingPercent(battleId, currentPlayerId, percent)
	-- battleId : 战斗id
	-- playerId : 角色id
	-- currentPlayerId : 哪个角色的百份比id
	-- percent : 0~100
	WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_OtherLoadingPercent",VectorToTable(battleId), VectorToTable(currentPlayerId), VectorToTable(percent))
	SceneBattleLoading:receiveOtherPercent(VectorToTable(battleId), VectorToTable(currentPlayerId), VectorToTable(percent))
end

--@brief	每一个角色出现的位置
function ProtocolProcessorSceneBattle:parse_BATTLE_PostionsForPlayers(battleId, playerId, idcount, playerIds, postionX, postionY)
	-- battleId : 战斗id
	-- playerId : 角色id(发给哪个的)
	-- idcount : 角色数量
	-- playerIds : 对应的坐标的角色id
	-- postionX : x坐标
	-- postionY : y坐标
	WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_PostionsForPlayers")
	SceneBattleLoading:receivePlayerPos(VectorToTable(battleId), VectorToTable(playerId), VectorToTable(idcount), VectorToTable(playerIds), VectorToTable(postionX), VectorToTable(postionY))
end

--@brief	通知角色进入战斗
function ProtocolProcessorSceneBattle:parse_BATTLE_GotoBattle(bIsGhost)
	-- bIsGhost : 是否开启幽灵模式
	WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_GotoBattle GotoBattle", bIsGhost)
	WBattleGlobal:getCurrent().m_bIsGhost = bIsGhost
	--SceneBattleLoading:receiveGotoBattle(VectorToTable(battleId), VectorToTable(playerId), VectorToTable(wind), VectorToTable(currentPlayerId), VectorToTable(attackRate),VectorToTable(battleRand), playerIds, oldCTB, newCTB, updateCTB_time)

	SceneBattleLoading:receiveGotoBattle()
end

--@brief	获取技能列表成功
function ProtocolProcessorSceneBattle:parse_PLAYER_GetSkillListOk(count, id, name, icon, priceCostGold, desc, itemMainType, itemSubType, param1, param2, tireValue, consumePower, specialAttackType, specialAttackParam)
	-- count : 数量
	-- id : 道具序号
	-- name : 道具名字
	-- icon : relativePath/图标名称.png(资源会放到同一个目录下)
	-- priceCostGold : 价格消耗多少金币
	-- desc : 物品描述
	-- itemMainType : 0：技能 1：道具
	-- itemSubType : 暂时没用
	-- param1 : 参数1    不同类型的道具参数的成值，意义都不同
	-- param2 : 参数2    不同类型的道具参数的成值，意义都不同
	-- tireValue : 使用这个道使资增加的疲劳值
	-- consumePower : 体力消耗
	-- specialAttackType : 附加的特殊攻击类型
	-- specialAttackParam : 附加的特殊攻击数值参数
	WZLog("ProtocolProcessorSceneBattle:parse_PLAYER_GetSkillListOk")
	SceneBattleLoading:receiveGetSkillListOk(VectorToTable(count), VectorToTable(id), VectorToTable(name), VectorToTable(icon), VectorToTable(priceCostGold), VectorToTable(desc), VectorToTable(itemMainType), VectorToTable(itemSubType), VectorToTable(param1), VectorToTable(param2), VectorToTable(tireValue), VectorToTable(consumePower), VectorToTable(specialAttackType), VectorToTable(specialAttackParam))
end

--@brief	获取道具列表成功
function ProtocolProcessorSceneBattle:parse_PLAYER_GetPropListOk(count, id, name, icon, priceCostGold, desc, itemMainType, itemSubType, param1, param2, tireValue, consumePower, specialAttackType, specialAttackParam)
	-- count : 数量
	-- id : 道具序号
	-- name : 道具名字
	-- icon : relativePath/图标名称.png(资源会放到同一个目录下)
	-- priceCostGold : 价格消耗多少金币
	-- desc : 物品描述
	-- itemMainType : 0：技能 1：道具
	-- itemSubType : 暂时没用
	-- param1 : 参数1    不同类型的道具参数的成值，意义都不同
	-- param2 : 参数2    不同类型的道具参数的成值，意义都不同
	-- tireValue : 使用这个道使资增加的疲劳值
	-- consumePower : 体力消耗
	-- specialAttackType : 附加的特殊攻击类型
	-- specialAttackParam : 附加的特殊攻击数值参数
	WZLog("ProtocolProcessorSceneBattle:parse_PLAYER_GetPropListOk")
	SceneBattleLoading:receiveGetPropListOk(VectorToTable(count), VectorToTable(id), VectorToTable(name), VectorToTable(icon), VectorToTable(priceCostGold), VectorToTable(desc), VectorToTable(itemMainType), VectorToTable(itemSubType), VectorToTable(param1), VectorToTable(param2), VectorToTable(tireValue), VectorToTable(consumePower), VectorToTable(specialAttackType), VectorToTable(specialAttackParam))
end

--@brief	获取角色技能列表成功
function ProtocolProcessorSceneBattle:parse_PLAYER_GetPlayerSkillOk(count, id, name, icon, priceCostGold, desc, itemMainType, itemSubType, param1, param2, tireValue, consumePower, specialAttackType, specialAttackParam)
	-- count : 数量
	-- id : 道具序号
	-- name : 道具名字
	-- icon : relativePath/图标名称.png(资源会放到同一个目录下)
	-- priceCostGold : 价格消耗多少金币
	-- desc : 物品描述
	-- itemMainType : 0：技能 1：道具
	-- itemSubType : 暂时没用
	-- param1 : 参数1    不同类型的道具参数的成值，意义都不同
	-- param2 : 参数2    不同类型的道具参数的成值，意义都不同
	-- tireValue : 使用这个道使资增加的疲劳值
	-- consumePower : 体力消耗
	-- specialAttackType : 附加的特殊攻击类型
	-- specialAttackParam : 附加的特殊攻击数值参数
	WZLog("ProtocolProcessorSceneBattle:parse_PLAYER_GetPlayerSkillOk")
	SceneBattleLoading:receiveGetPlayerSkillOk(VectorToTable(count), VectorToTable(id), VectorToTable(name), VectorToTable(icon), VectorToTable(priceCostGold), VectorToTable(desc), VectorToTable(itemMainType), VectorToTable(itemSubType), VectorToTable(param1), VectorToTable(param2), VectorToTable(tireValue), VectorToTable(consumePower), VectorToTable(specialAttackType), VectorToTable(specialAttackParam))
end

--@brief	获取角色道具列表成功
function ProtocolProcessorSceneBattle:parse_PLAYER_GetPlayerPropOk(count, id, name, icon, priceCostGold, desc, itemMainType, itemSubType, param1, param2, tireValue, consumePower, specialAttackType, specialAttackParam)
	-- count : 数量
	-- id : 道具序号
	-- name : 道具名字
	-- icon : relativePath/图标名称.png(资源会放到同一个目录下)
	-- priceCostGold : 价格消耗多少金币
	-- desc : 物品描述
	-- itemMainType : 0：技能 1：道具
	-- itemSubType : 暂时没用
	-- param1 : 参数1    不同类型的道具参数的成值，意义都不同
	-- param2 : 参数2    不同类型的道具参数的成值，意义都不同
	-- tireValue : 使用这个道使资增加的疲劳值
	-- consumePower : 体力消耗
	-- specialAttackType : 附加的特殊攻击类型
	-- specialAttackParam : 附加的特殊攻击数值参数
	WZLog("ProtocolProcessorSceneBattle:parse_PLAYER_GetPlayerPropOk")
	SceneBattleLoading:receiveGetPlayerPropOk(VectorToTable(count), VectorToTable(id), VectorToTable(name), VectorToTable(icon), VectorToTable(priceCostGold), VectorToTable(desc), VectorToTable(itemMainType), VectorToTable(itemSubType), VectorToTable(param1), VectorToTable(param2), VectorToTable(tireValue), VectorToTable(consumePower), VectorToTable(specialAttackType), VectorToTable(specialAttackParam))
end

--@brief	获得提示语成功
function ProtocolProcessorSceneBattle:parse_BATTLE_GetTipsOk(tips)
	-- tips : 提示语
	WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_GetTipsOk")
	SceneBattleLoading:receiveTips(VectorToTable(tips))
end

--@brief	获取特殊事件信息OK
function ProtocolProcessorSceneBattle:parse_BATTLE_GetEventInfoOk(battleId, weatherId, name, effect1, effect2)
	-- battleId : 战斗ID
	-- weatherId : 特殊事件的id
	-- name : 特殊事件的名字
	-- effect1 : 特殊事件的效果参数1
	-- effect2 : 特殊事件的效果参数2
	WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_GetEventInfoOk", weatherId, name, effect1, effect2)
    
    --地图事件
    if WBattleGlobal:getCurrent().m_tMapEvents ~= nil and #WBattleGlobal:getCurrent().m_tMapEvents > 0  then
        for i, event in pairs(WBattleGlobal:getCurrent().m_tMapEvents) do
            event:destroy()
        end
    end
    WBattleGlobal:getCurrent().m_tMapEvents = nil

    if WBattleGlobal:getCurrent().m_tMapEvents == nil then
        WBattleGlobal:getCurrent().m_tMapEvents = {}
    end
    
    if weatherId == MapEnenvtTornado.ID then
        local mapEvent = MapEnenvtTornado:buildEvent(weatherId, name, effect1, effect2)
        if mapEvent ~= nil then
            table.insert(WBattleGlobal:getCurrent().m_tMapEvents, mapEvent)
        end
    elseif weatherId == MapEnenvtLava.ID then
        local mapEvent = MapEnenvtLava:buildEvent(weatherId, name, effect1, effect2)
        if mapEvent ~= nil then
            table.insert(WBattleGlobal:getCurrent().m_tMapEvents, mapEvent)
        end

    elseif weatherId == MapEnenvtMeteorite.ID then
        local mapEvent = MapEnenvtMeteorite:buildEvent(weatherId, name, effect1, effect2)
        if mapEvent ~= nil then
            table.insert(WBattleGlobal:getCurrent().m_tMapEvents, mapEvent)
        end
    elseif weatherId == MapEnenvtBubble.ID then
        local mapEvent = MapEnenvtBubble:buildEvent(weatherId, name, effect1, effect2)
        if mapEvent ~= nil then
            table.insert(WBattleGlobal:getCurrent().m_tMapEvents, mapEvent)
        end
    end

    --清除地图事件状态
    if WBattleGlobal:getCurrent().m_tMapEvents ~= nil and #WBattleGlobal:getCurrent().m_tMapEvents > 0  then
        for i, event in pairs(WBattleGlobal:getCurrent().m_tMapEvents) do
            event:clearState()
        end
    end

end

--@brief	通知其它玩家触碰特殊事件
function ProtocolProcessorSceneBattle:parse_BATTLE_OtherEventContact(battleId, playerId, eventId)
	-- battleId : 战斗id
	-- playerId : 玩家id
	-- eventId : 特殊事件id
	WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_OtherEventContact", battleId, playerId, eventId)
end

--@brief	其他人生成怪
function ProtocolProcessorSceneBattle:parse_BATTLE_OtherBuildGuai(battleId, currentId, guaiBattleId, guaiId, guaiPositionX, guaiPositionY)
	-- battleId : 战斗id
	-- currentId : 角色id,谁生成的
	-- guaiCount : 生成的数量
	-- guaiBattleId : 生成怪的战斗id
	-- guaiId : 怪的数据形象id
	-- guaiPositionX : X坐标
	-- guaiPositionY : Y坐标
	WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_OtherBuildGuai", currentId)
	local  guai = WBattleGlobal:getCurrent():getGuaiWithId(currentId)
	if not guai then
		guai = WBattleGlobal:getCurrent():getCharacterWithId(currentId)
	end

	if guai ~= nil then
		guai:receiveBuildXiaoGuai(VectorToTable(guaiBattleId), VectorToTable(guaiId), IntVectorToFloatTable(guaiPositionX), IntVectorToFloatTable(guaiPositionY))
	end
end

--@brief	其他人使用近距离攻击
function ProtocolProcessorSceneBattle:parse_BOSSMAPBATTLE_OtherNearAttack(battleId,  currentId, leftRight)
	-- battleId : 战斗id
	-- currentId : 角色id
	-- leftRight : 1：左 0：右（向左还是向右）
	WZLog("ProtocolProcessorSceneBattle:parse_BOSSMAPBATTLE_OtherNearAttack", currentId, leftRight)
	local guai = WBattleGlobal:getCurrent():getGuaiWithId(currentId)
	if guai ~= nil then
		guai:receiveNearAttack(VectorToTable(leftRight))
	end

end

--@brief	同步战斗对象位置信息(BOSSMAPBATTLE_OtherSynPosition = 64)
function ProtocolProcessorSceneBattle:parse_BOSSMAPBATTLE_OtherSynPosition(battleId, combatId, positionX, positionY)
	-- battleId : 战斗id
	-- combatId : 成员id
	-- positionX : x坐标
	-- positionY : y坐标
	WZLog("ProtocolProcessorSceneBattle:parse_BOSSMAPBATTLE_OtherSynPosition")
	WBattleGlobal:getCurrent():updateBattleSynPosition(VectorToTable(combatId),IntVectorToFloatTable(positionX),IntVectorToFloatTable(positionY))
end

--@brief	通知游戏结束
function ProtocolProcessorSceneBattle:parse_BOSSMAPBATTLE_GameOver(battleId, winCamp, playerIds, playerLevel, playerExp, rewardNum, rewardId, rewardCount, flopNum, flopId, flopCount, hurtNum, flopRebate)
	-- battleId : 战斗id
	-- winCamp : 胜利的一方
	-- playerIds : 角色id
	-- playerLevel : 玩家当前的等级(增加经验后的数据)
	-- playerExp : 玩家当前的经验(增加经验后的数据)
	-- rewardNum : 玩家固定奖励物品数
	-- rewardId : 固定奖励物品id
	-- rewardCount : 固定奖励物品数量
	-- flopNum : 玩家翻牌奖励物品数
	-- flopId : 翻牌奖励物品id
	-- flopCount : 翻牌奖励物品数量
	-- flopRebate : 组队副本翻牌折扣
	WZLog("ProtocolProcessorSceneBattle:parse_BOSSMAPBATTLE_GameOver", flopRebate)

    WBattleGlobal:getCurrent():setGameOver(true)
	WindowManager:removeAllWindow()
    local msg = MsgManager:createMsg(BattleMsgGameOver)
	msg.m_bWin = WBattleGlobal:getCurrent():getHeroWithId(WBattleGlobal:getCurrent():getMyBattleId()):getCamp() == winCamp
	msg.m_tSettlementData = {
        battleId = battleId,
        winCamp = winCamp,
        playerIds = VectorToTable(playerIds),
        playerLevel = VectorToTable(playerLevel),
        playerExp = VectorToTable(playerExp),
        rewardNum = VectorToTable(rewardNum),
        rewardId = VectorToTable(rewardId),
        rewardCount = VectorToTable(rewardCount),
        flopNum = VectorToTable(flopNum),
        flopId = VectorToTable(flopId),
        flopCount = VectorToTable(flopCount),
		hurtNum = VectorToTable(hurtNum),
		flopRebate = flopRebate,
	}

	local hurt = VectorToTable(hurtNum)
	for i = 1, #hurt do
		WZLog("----------------hurt------------",hurt[i])
	end
	if WBattleGlobal:getCurrent():isReplayGame() then
    	msg.m_tSettlementData.isVideo = true
	end
    MsgManager:pushNonBlockMsg(msg)
end

--@brief	其它人抽一次奖
function ProtocolProcessorSceneBattle:parse_BOSSMAPROOM_OtherRewardOk(playerId, rewardIndex)
	-- playerId : 谁抽奖了
    -- rewardIndex : 翻牌的位置 1免费翻牌，2VIP翻牌，3钻石翻牌
	WZLog("ProtocolProcessorSceneBattle:parse_BOSSMAPROOM_OtherRewardOk")
    WndMultiWin:otherRewardOk(playerId, rewardIndex)
end

--@brief	获取房间状态成功
function ProtocolProcessorSceneBattle:parse_WORLDBOSS_GetRoomStateOk(mapId, bossBloodMax, bossBloodCurrent,rankPlayerId, rankPlayerName, rankHurt, hurt, cdTime, accelerateCost, inspire, bossLevel, myRank, dimaCDTime, goldCDTime,bossIsDead,openTime)
    -- mapId : 地图id
    -- bossBloodMax : boss总血量
    -- bossBloodCurrent : boss当前血量
    -- rankPlayerName : 排行榜玩家名字
    -- rankHurt : 排位赛伤害输出
    -- hurt : 自己对boss造成的伤害合计值
    -- cdTime : 冷却时间(秒)
    -- accelerateCost : 加速所需钻石
    -- inspire : 当前鼓舞值（最大10000）
    -- bossLevel : 世界BOSS等级
    -- myRank : 我的伤害排名（0表示没有伤害）
    -- dimaCDTime : 钻石鼓舞冷却时间(秒)
    -- goldCDTime : 金币鼓舞冷却时间(秒)
    WZLog("ProtocolProcessorSceneBattle:parse_WORLDBOSS_GetRoomStateOk")
    --SceneWorldBoss:setEnterRoomData( mapId, bossBloodMax, bossBloodCurrent, rankPlayerName, rankHurt, hurt, cdTime, accelerateCost, inspire, bossLevel, myRank, dimaCDTime, goldCDTime)

    -- WBattleGlobal:getCurrent():destroy()
    -- local worldBossElement = SceneWorldBoss:createElement(mapId)
    -- if worldBossElement ~= nil then
    --     replaceScene( worldBossElement )
    -- end
    WBattleGlobal:getCurrent():setGameOver(true)
    local msg = MsgManager:createMsg(BattleMsgGameOver)
    MsgManager:pushNonBlockMsg(msg)
end

--@brief	发送结算信息
function ProtocolProcessorSceneBattle:parse_WORLDBOSS_SendSettlementInfo(hurtValue, hurtRank, hurtPercent, isWin, killerId, killerName)
    -- hurtValue : 总伤害输出
    -- hurtRank : 输出排名
    -- hurtPercent : 伤害所占百分比
    -- isWin : 是否赢了
    -- killerId : 击杀玩家id
    -- killerName : 击杀玩家名称
    WZLog("ProtocolProcessorSceneBattle:parse_WORLDBOSS_SendSettlementInfo",hurtValue, hurtRank, hurtPercent, tostring(isWin), killerId, killerName)
    if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS and WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_WORLDBOSS then

        WBattleGlobal:getCurrent():setGameOver(true)
        WindowManager:removeAllWindow()

	    local data = {bossId = WBattleGlobal:getCurrent().m_tMakePairOk.mapId,
	    isWin = isWin, hurtValue = hurtValue, hurtRank = hurtRank, killerName = killerName,killerId = killerId,hurtPercent = hurtPercent}
	    WndWorldBossEnd:showWnd( data ,true)
	end
end

--@brief	组队世界boss战斗结束返回（TEAMWORLDBOSS_SendSettlementInfo = 30）
function ProtocolProcessorSceneBattle:parse_TEAMWORLDBOSS_SendSettlementInfo(isWin, myHurt, teamHurt, bossMaxHp, killerId, killerName, goldNum, bossNowHp, leaveNum, timeOver)
	-- isWin : 战斗是否胜利
	-- myHurt : 自己的伤害
	-- teamHurt : 队伍伤害
	-- bossMaxHp : boss总血量
	-- killerId : 击杀玩家
	-- killerName : 击杀玩家名
	-- goldNum : 伤害转换金币数
	-- leaveNum : 玩家剩余挑战次数
	-- timeOver : 是否时间到
	WZLog("ProtocolProcessorSceneBattle:parse_TEAMWORLDBOSS_SendSettlementInfo")
	WBattleGlobal:getCurrent():setGameOver(true)
	WindowManager:removeAllWindow()
    local msg = MsgManager:createMsg(BattleMsgGameOver)
	msg.m_bWin = isWin
	msg.m_bTimeOver = timeOver
	local tKillerId = VectorToTable(killerId)
	local tKillerName = VectorToTable(killerName)
	msg.m_tSettlementData = {
		bWin = isWin,
        myHurt = myHurt,
        teamHurt = teamHurt,
        bossMaxHp = tonumber(bossMaxHp),
        killerId = tKillerId,
        killerName = tKillerName,
        goldNum = goldNum,
        bossNowHp = tonumber(bossNowHp),
        leaveNum = leaveNum,
        timeOver = timeOver,
	}
	WZLog("ProtocolProcessorSceneBattle:parse_TEAMWORLDBOSS_SendSettlementInfo", Serialize(msg.m_tSettlementData))
	if WBattleGlobal:getCurrent():isReplayGame() then
    	msg.m_tSettlementData.isVideo = true
	end
    MsgManager:pushNonBlockMsg(msg)
end

--@brief	伤害详情（TEAMWORLDBOSS_BattleHurtInfo = 34）
function ProtocolProcessorSceneBattle:parse_TEAMWORLDBOSS_BattleHurtInfo(playerId, hurt)
	-- playerId : 玩家Id
	-- hurt : 伤害
	WZLog("ProtocolProcessorSceneBattle:parse_TEAMWORLDBOSS_BattleHurtInfo")
	
    if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS and WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_WORLDTEAMBOSS then
    	WndWorldTeamBossInfoView:setData(VectorToTable(playerId), VectorToTable(hurt))
    end
end

--@brief	同步新生成的幽灵技能(BATTLE_SyncGhostSkillList = 107)
function ProtocolProcessorSceneBattle:parse_BATTLE_SyncGhostSkillList(x, y, skillId, uniqueId)
	-- x : x坐标
	-- y : y坐标
	-- skillId : 技能Id
	-- uniqueId : 唯一Id
	WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_SyncGhostSkillList")
	
    SceneBattle:addNewGhostBox(x, y, skillId, uniqueId)
end

--@brief	拾取幽灵技能(BATTLE_GetGhostSkillOk = 109)
function ProtocolProcessorSceneBattle:parse_BATTLE_GetGhostSkillOk(status, uniqueId, skillId, playerId)
	-- status : 状态. 1成功 2非幽灵 3数量超过上限，摧毁宝箱 4没找到对应的幽灵技能
	-- skillId : 技能Id
	-- uniqueId : 唯一Id
	-- playerId ： 拾取的玩家Id
	WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_GetGhostSkillOk")
	
	SceneBattle:removeGhostBox(status, uniqueId, skillId, playerId)
end

--@brief	移除幽灵技能(BATTLE_RemoveGhostSkillOk = 111)
function ProtocolProcessorSceneBattle:parse_BATTLE_RemoveGhostSkillOk(playerId, uniqueId)
	-- playerId : 玩家Id
	-- uniqueId : 唯一Id
	WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_RemoveGhostSkillOk")
	
	WndBattleHud:dropGhostSkillSuccess(playerId, uniqueId)
end

--@brief	幽灵移动(BATTLE_OtherGhostMove = 113)
--@return	#1:返回数据表
function ProtocolProcessorSceneBattle:parse_BATTLE_OtherGhostMove(battleId, playerId, currentPlayerId, movecount, movestep, curPositionX, curPositionY, movestepY, addYRate)
	-- battleId : 战斗id
	-- playerId : 角色id(发给哪个的)
	-- currentPlayerId : 角色id(当前在操作的角色）
	-- movecount : 移动的次数
	-- movestep : 每一次移动的方向（1：左，0：右）
	-- curPositionX : 没移动前的x坐标
	-- curPositionY : 没移动前的y坐标
	WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_OtherGhostMove zero", battleId, playerId, currentPlayerId, movecount, movestep, curPositionX, curPositionY, movestepY, addYRate)
    local localPlayerPos = WBattleGlobal:getCurrent():getCharacterWithId(currentPlayerId):getPosition()
	WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_OtherGhostMove", curPositionX, curPositionY, localPlayerPos and localPlayerPos.x, localPlayerPos and localPlayerPos.y, movecount)

	local msg = MsgManager:createMsg(BattleMsgGhostMove)
	msg.m_nBattleId = battleId
	msg.m_nPlayerId = playerId
	msg.m_nCurrentPlayerId = currentPlayerId
	msg.m_nMovecount = movecount
	msg.m_tMovestep = {}
	msg.m_tMovestepY = {}
	for i = 1, movecount do
		table.insert(msg.m_tMovestep, movestep:get(i-1))
		table.insert(msg.m_tMovestepY, movestepY:get(i-1))
	end
	msg.m_nCurPositionX = BattleUtil:int2float(curPositionX)
	msg.m_nCurPositionY = BattleUtil:int2float(curPositionY)
	msg.m_nAddYRate = BattleUtil:int2float(addYRate)

	MsgManager:pushNonBlockMsg(msg)
end

--@brief	战斗心跳错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBattle:send_SYSTEM_BattleShakeHands_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBattle:send_SYSTEM_BattleShakeHands_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SYSTEM, Protocol.SYSTEM_BattleShakeHands, nflag, sMessage)
end

--@brief	通知已经开始加载错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBattle:send_BATTLE_StartLoading_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBattle:send_BATTLE_StartLoading_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BATTLE, Protocol.BATTLE_StartLoading, nflag, sMessage)
end

--@brief	提交地图可选择的出现位置给服务器错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBattle:send_BATTLE_PositionsInMap_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBattle:send_BATTLE_PositionsInMap_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BATTLE, Protocol.BATTLE_PositionsInMap, nflag, sMessage)
end

--@brief	通知已经完成加载错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBattle:send_BATTLE_FinishLoading_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBattle:send_BATTLE_FinishLoading_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BATTLE, Protocol.BATTLE_FinishLoading, nflag, sMessage)
end

--@brief	获得提示语错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBattle:send_BATTLE_GetTips_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBattle:send_BATTLE_GetTips_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BATTLE, Protocol.BATTLE_GetTips, nflag, sMessage)
end

--@brief	发送加载百份比错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBattle:send_BATTLE_LoadingPercent_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBattle:send_BATTLE_LoadingPercent_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BATTLE, Protocol.BATTLE_LoadingPercent, nflag, sMessage)
end

--@brief	战斗操作结束错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBattle:send_BATTLE_EndCurRound_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBattle:send_BATTLE_EndCurRound_ErrorProcess")
	MsgBoxManager:showTipBox(sMessage)
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BATTLE, Protocol.BATTLE_EndCurRound, nflag, sMessage)
end

--@brief	角色移动错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBattle:send_BATTLE_PlayerMove_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBattle:send_BATTLE_PlayerMove_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BATTLE, Protocol.BATTLE_PlayerMove, nflag, sMessage)
end

--@brief	使用技能和道具错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBattle:send_BATTLE_SkillEquip_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBattle:send_BATTLE_SkillEquip_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BATTLE, Protocol.BATTLE_SkillEquip, nflag, sMessage)
end

--@brief	使用大招错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBattle:send_BATTLE_PetAttack_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBattle:send_BATTLE_PetAttack_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BATTLE, Protocol.BATTLE_PetAttack, nflag, sMessage)
end

--@brief	发射错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBattle:send_BATTLE_Shoot_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBattle:send_BATTLE_Shoot_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BATTLE, Protocol.BATTLE_Shoot, nflag, sMessage)
end

--@brief	发射完成错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBattle:send_BATTLE_Hurt_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBattle:send_BATTLE_Hurt_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BATTLE, Protocol.BATTLE_Hurt, nflag, sMessage)
end

--@brief	飞行错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBattle:send_BATTLE_Fly_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBattle:send_BATTLE_Fly_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BATTLE, Protocol.BATTLE_Fly, nflag, sMessage)
end

--@brief	跳过本轮操作错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBattle:send_BATTLE_Pass_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBattle:send_BATTLE_Pass_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BATTLE, Protocol.BATTLE_Pass, nflag, sMessage)
end

--@brief	返回房间错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBattle:send_BATTLE_BackToRoom_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBattle:send_BATTLE_BackToRoom_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BATTLE, Protocol.BATTLE_BackToRoom, nflag, sMessage)
end

--@brief	重生点错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBattle:send_BATTLE_RebornPosition_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBattle:send_BATTLE_RebornPosition_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BATTLE, Protocol.BATTLE_RebornPosition, nflag, sMessage)
end

--@brief	某角色掉出了场景错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBattle:send_BATTLE_OutOfScene_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBattle:send_BATTLE_OutOfScene_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BATTLE, Protocol.BATTLE_OutOfScene, nflag, sMessage)
end

--@brief	强制退出战斗错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBattle:send_BATTLE_QuitBattle_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBattle:send_BATTLE_QuitBattle_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BATTLE, Protocol.BATTLE_QuitBattle, nflag, sMessage)
end

--@brief	发送使用的表情错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBattle:send_BATTLE_UsingFace_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBattle:send_BATTLE_UsingFace_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BATTLE, Protocol.BATTLE_UsingFace, nflag, sMessage)
end



--@brief	发送玩家战斗属性错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBattle:send_BATTLE_SendPlayerBattleAttribute_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBattle:send_BATTLE_SendPlayerBattleAttribute_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BATTLE, Protocol.BATTLE_SendPlayerBattleAttribute, nflag, sMessage)
end

--@brief	获取特殊事件信息错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBattle:send_BATTLE_GetEventInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBattle:send_BATTLE_GetEventInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BATTLE, Protocol.BATTLE_GetEventInfo, nflag, sMessage)
end

--@brief	玩家触碰特殊事件错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBattle:send_BATTLE_EventContact_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBattle:send_BATTLE_EventContact_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BATTLE, Protocol.BATTLE_EventContact, nflag, sMessage)
end

--@brief	生成怪错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBattle:send_BATTLE_BuildGuai_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBattle:send_BATTLE_BuildGuai_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BATTLE, Protocol.BOSSMAPBATTLE_BuildGuai, nflag, sMessage)
end

--@brief	同步战斗信息错误处理错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBattle:send_BATTLE_SynchronousBattleInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBattle:send_BATTLE_SynchronousBattleInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BATTLE, Protocol.BATTLE_SynchronousBattleInfo, nflag, "")

	MsgBoxManager:showConfirmBox(sMessage, SceneBattle, SceneBattle.leftBattle, MSGBOXLEVEL_NORMAL, nil, true)
end

--@brief	boss变身错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBattle:send_BOSSMAPBATTLE_BossChange_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBattle:send_BOSSMAPBATTLE_BossChange_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BATTLE, Protocol.BOSSMAPBATTLE_BossChange, nflag, sMessage)
end

--@brief	使用近距离攻击错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBattle:send_BOSSMAPBATTLE_NearAttack_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBattle:send_BOSSMAPBATTLE_NearAttack_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BATTLE, Protocol.BOSSMAPBATTLE_NearAttack, nflag, sMessage)
end

--@brief	同步战斗对象位置信息(BOSSMAPBATTLE_SynPosition = 63)错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBattle:send_BOSSMAPBATTLE_SynPosition_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBattle:send_BOSSMAPBATTLE_SynPosition_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BATTLE, Protocol.BOSSMAPBATTLE_SynPosition, nflag, sMessage)
end

--@brief	返回房间错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBattle:send_BOSSMAPROOM_BackToRoom_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBattle:send_BOSSMAPROOM_BackToRoom_ErrorProcess =",sMessage)
	if sMessage == "1" then
		--房间不存在
	elseif sMessage == "2" then
		--地图不存在
	elseif sMessage == "3" or sMessage == "4" then
		--3体力不足
		--4次数不足
		WndMultiCopy.g_nBackRoomState = tonumber(sMessage)
	elseif sMessage == "7" then --助战不返回房间
		SceneCopy:showScene(2)
		return
	else
		ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BATTLE, Protocol.BATTLE_BackToRoom, nflag, sMessage)
	end

	if WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_LOVE_STAGE then
        ProtocolProcessorWndMarry:send_WEDDING_GetMarryInfo()
        WndMarryManager:createLoading()
    else
        SceneCopy:showScene(2)
    end

    if sMessage == "1" then
		--房间不存在
		MsgBoxManager:showTipBox(LocalStrings.MULTI_ROOM_EMPTY)
    end
end

--@brief	抽奖错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBattle:send_BOSSMAPROOM_Reward_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBattle:send_BOSSMAPROOM_Reward_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_Reward, nflag, sMessage)
    MsgBoxManager:showTipBox(sMessage)
end

--@brief	添加或移除BUFF(BATTLE_BuffChange = 65)错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBattle:send_BATTLE_BuffChange_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBattle:send_BATTLE_BuffChange_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BATTLE, Protocol.BATTLE_BuffChange, nflag, sMessage)
end

--@brief	拾取幽灵技能(BATTLE_GetGhostSkill = 108)错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBattle:send_BATTLE_GetGhostSkill_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBattle:send_BATTLE_GetGhostSkill_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BATTLE, Protocol.BATTLE_GetGhostSkill, nflag, sMessage)
end

--@brief	移除幽灵技能(BATTLE_RemoveGhostSkill = 110)错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBattle:send_BATTLE_RemoveGhostSkill_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBattle:send_BATTLE_RemoveGhostSkill_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BATTLE, Protocol.BATTLE_RemoveGhostSkill, nflag, sMessage)
end

--@brief	幽灵移动(BATTLE_GhostMove = 112)错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBattle:send_BATTLE_GhostMove_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBattle:send_BATTLE_GhostMove_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BATTLE, Protocol.BATTLE_GhostMove, nflag, sMessage)
end