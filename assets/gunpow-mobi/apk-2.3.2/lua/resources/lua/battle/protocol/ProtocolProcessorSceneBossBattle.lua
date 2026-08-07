--ProtocolProcessorSceneBossBattle.lua
--@brief	战斗协议
--@date  	2013/12/10
--@author 	李光森
--@note 	副本战斗


ProtocolProcessorSceneBossBattle = ProtocolProcessorBase:new()

-------------------------------------公有方法模块--------------------------------------

--@brief	注册协议组所有协议
function ProtocolProcessorSceneBossBattle:regAll()
	--@brief	获得提示语成功
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_GetTipsOk, "ProtocolProcessorSceneBossBattle:parse_BATTLE_GetTipsOk", "vs")
	--@brief	通知客户端对指定角色进行控制
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_AIControlCommon, "ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_AIControlCommon", "i")
	--@brief	通知角色进入战斗
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_GotoBattle, "ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_GotoBattle", "")
	--@brief	通知角色当前操作角色时间到了
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_CanStartCurRound, "ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_CanStartCurRound", "iiiivivivivivivii")
	--@brief	其他角色移动
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_OtherPlayerMove, "ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_OtherPlayerMove", "iiivtii")
	--@brief	其他角色使用技能和道具
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_OtherSkillEquip, "ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_OtherSkillEquip", "iiivis")
	--@brief	更新怒气值
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_ChangeAngryValue, "ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_ChangeAngryValue", "iii")
	--@brief	是否可以使用大招
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_OtherBigSkill, "ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_OtherBigSkill", "ii")
	--@brief	其它人发射
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_OtherShoot, "ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_OtherShoot", "iiiitiiivivivivivi")
	--@brief	发射完成
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_UpdateHP, "ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_UpdateHP", "iiviviivivi")
	--@brief	其它人飞行
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_OtherFly, "ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_OtherFly", "iiiitiiiivivivi")
	--@brief	冰冻解除
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_FrozenOver, "ProtocolProcessorSceneBossBattle:parse_BATTLE_FrozenOver", "vi")
	--@brief	人物死亡
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_SomeOneDead, "ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_SomeOneDead", "ivi")
	--@brief	跳过本轮操作
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_OtherPass, "ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_OtherPass", "ii")
	--@brief	通知游戏结束
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_GameOver, "ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_GameOver", "iivivivivivivivivivivi")
	--@brief	玩家掉线
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_PlayerLose, "ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_PlayerLose", "iib")
	--@brief	人物复活
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_PlayerReborn, "ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_PlayerReborn", "iivivivi")
	--@brief	更新勋章数
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_UpdateMedal, "ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_UpdateMedal", "iiivivi")
	--@brief	强制退出战斗成功
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_QuitBattleOk, "ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_QuitBattleOk", "ii")
	--@brief	其他人加载百份比
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_OtherLoadingPercent, "ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_OtherLoadingPercent", "iii")
	--@brief	其他人使用表情
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_OtherUsingFace, "ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_OtherUsingFace", "iii")
	--@brief	其他人使用近距离攻击
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_OtherNearAttack, "ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_OtherNearAttack", "iii")
	--@brief	其他人生成怪
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BATTLE_BossOtherMapBuildGuai, "ProtocolProcessorSceneBossBattle:parse_BATTLE_BossOtherMapBuildGuai", "iivivivivi")
	--@brief	请求怪物战斗id
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_RequestGuaiBattleIdOk, "ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_RequestGuaiBattleIdOk", "iivi")
	--@brief	boss变身
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_OtherChange, "ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_OtherChange", "iiii")
	--@brief	其它人抽一次奖
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_OtherRewardOk, "ProtocolProcessorSceneBossBattle:parse_BOSSMAPROOM_OtherRewardOk", "ii")
	--@brief	其他人位置改变
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_OtherChangePosition, "ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_OtherChangePosition", "iiiviviviivivivi")
	--@brief	获取宝箱信息成功
	-- self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_GetTreasureInfoOk, "ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_GetTreasureInfoOk", "ivivivivsvsvivivivivivi")
	--@brief	其他角色与宝箱接触
	-- self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_OtherTreasureContact, "ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_OtherTreasureContact", "iiiivi")
	--@brief	发送同步客户端
	-- self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_SendSynchroClients, "ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_SendSynchroClients", "iiivi")
	--获取技能列表成功
	-- self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetSkillListOk, "ProtocolProcessorSceneBossBattle:parse_PLAYER_GetSkillListOk", "ivivsvsvivsvtvtvivivivivivi")
	--获取道具列表成功
	--self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPropListOk, "ProtocolProcessorSceneBossBattle:parse_PLAYER_GetPropListOk", "ivivsvsvivsvtvtvivivivivivi")
	--@brief	获取角色技能列表成功
	--self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerSkillOk, "ProtocolProcessorSceneBossBattle:parse_PLAYER_GetPlayerSkillOk", "ivivsvsvivsvtvtvivivivivivi")
	--@brief	获取角色道具列表成功
	--self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerPropOk, "ProtocolProcessorSceneBossBattle:parse_PLAYER_GetPlayerPropOk", "ivivsvsvivsvtvtvivivivivivi")
	--@brief	发送结算信息（WORLDBOSSHALL_SendSettlementInfo = 11）
	--self:regProtocolCallbackFunction( Protocol.MAIN_WORLDBOSSHALL, Protocol.WORLDBOSSHALL_SendSettlementInfo, "ProtocolProcessorSceneBossBattle:parse_WORLDBOSSHALL_SendSettlementInfo", "iiibb")
    --@brief	添加Buff
    self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_AddBuff, "ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_AddBuff", "iii")

	--@brief	同步战斗对象位置信息(BOSSMAPBATTLE_OtherSynPosition = 64)
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_OtherSynPosition, "ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_OtherSynPosition", "ivivivi")
	--@brief	同步战斗对象位置信息(BOSSMAPBATTLE_SynPosition = 63)错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_SynPosition, "ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_SynPosition_ErrorProcess", "is" )

    --@brief	获取房间状态成功
    self:regProtocolCallbackFunction( Protocol.MAIN_WORLDBOSS, Protocol.WORLDBOSS_GetRoomStateOk, "ProtocolProcessorSceneBossBattle:parse_WORLDBOSS_GetRoomStateOk", "iiivivsvivivivtvivisiiiiiiiii")
    --@brief	发送结算信息
    self:regProtocolCallbackFunction( Protocol.MAIN_WORLDBOSS, Protocol.WORLDBOSS_SendSettlementInfo, "ProtocolProcessorSceneBossBattle:parse_WORLDBOSS_SendSettlementInfo", "siibis")
    --@brief	发送当前回合的信息成功
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_SendCurRoundInfoOk, "ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_SendCurRoundInfoOk", "iiiviviviviviiivivi")
	--@brief	同步战斗信息成功
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_SynchronousBattleInfoOk, "ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_SynchronousBattleInfoOk", "iviviviviviviviviviviviviviviviviviviviviiivivi")
	--@brief	通知其他玩家有玩家返回战斗成功
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_ComeBackBattleInfoOk, "ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_ComeBackBattleInfoOk", "ii")


	--@brief	战斗心跳错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SYSTEM, Protocol.SYSTEM_BattleShakeHands, "ProtocolProcessorSceneBossBattle:send_SYSTEM_BattleShakeHands_ErrorProcess", "is" )
	--@brief	获得提示语错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_GetTips, "ProtocolProcessorSceneBossBattle:send_BATTLE_GetTips_ErrorProcess", "is" )
	--@brief	通知已经开始加载错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_StartLoading, "ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_StartLoading_ErrorProcess", "is" )
	--@brief	通知已经完成加载错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_FinishLoading, "ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_FinishLoading_ErrorProcess", "is" )
	--@brief	战斗操作结束错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_EndCurRound, "ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_EndCurRound_ErrorProcess", "is" )
	--@brief	角色移动错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_PlayerMove, "ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_PlayerMove_ErrorProcess", "is" )
	--@brief	使用技能和道具错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_SkillEquip, "ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_SkillEquip_ErrorProcess", "is" )
	--@brief	宠物攻击错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_PetAttack, "ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_PetAttack_ErrorProcess", "is" )
	--@brief	发射错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_Shoot, "ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_Shoot_ErrorProcess", "is" )
	--@brief	发射完成错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_Hurt, "ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_Hurt_ErrorProcess", "is" )
	--@brief	飞行错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_Fly, "ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_Fly_ErrorProcess", "is" )
	--@brief	跳过本轮操作错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_Pass, "ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_Pass_ErrorProcess", "is" )
	--@brief	返回房间错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_BackToRoom, "ProtocolProcessorSceneBossBattle:send_BOSSMAPROOM_BackToRoom_ErrorProcess", "is" )
	--@brief	某角色掉出了场景错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_OutOfScene, "ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_OutOfScene_ErrorProcess", "is" )
	--@brief	重生点错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_RebornPosition, "ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_RebornPosition_ErrorProcess", "is" )
	--@brief	强制退出战斗错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_QuitBattle, "ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_QuitBattle_ErrorProcess", "is" )
	--@brief	发送加载百份比错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_LoadingPercent, "ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_LoadingPercent_ErrorProcess", "is" )
	--@brief	发送使用的表情错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_UsingFace, "ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_UsingFace_ErrorProcess", "is" )
	--@brief	 被冰冻错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_BeFrozen, "ProtocolProcessorSceneBossBattle:send_BATTLE_BeFrozen_ErrorProcess", "is" )
	--@brief	使用近距离攻击错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_NearAttack, "ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_NearAttack_ErrorProcess", "is" )
	--@brief	生成怪错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_BuildGuai, "ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_BuildGuai_ErrorProcess", "is" )
	--@brief	请求怪物战斗id错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_RequestGuaiBattleId, "ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_RequestGuaiBattleId_ErrorProcess", "is" )
	--@brief	boss变身错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_BossChange, "ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_BossChange_ErrorProcess", "is" )
	--@brief	抽奖错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_Reward, "ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_Reward_ErrorProcess", "is" )
	--@brief	改变位置错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_ChangePosition, "ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_ChangePosition_ErrorProcess", "is" )
	--@brief	杀死怪协议错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_KillGuai, "ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_KillGuai_ErrorProcess", "is" )
	--@brief	发送玩家战斗属性错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_SendPlayerBattleAttribute, "ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_SendPlayerBattleAttribute_ErrorProcess", "is" )
	--@brief	获取宝箱信息错误处理(S->C)
	-- self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_GetTreasureInfo, "ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_GetTreasureInfo_ErrorProcess", "is" )
	--@brief	与宝箱接触错误处理(S->C)
	-- self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_TreasureContact, "ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_TreasureContact_ErrorProcess", "is" )
	--@brief	请求同步客户端错误处理(S->C)
	-- self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_RequestSynchroClients, "ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_RequestSynchroClients_ErrorProcess", "is" )
	--@brief	同步战斗信息错误处理(S->C)
	--self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_SynchronousBattleInfo, "ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_SynchronousBattleInfo_ErrorProcess", "is" )

end

--@brief	反注册协议组所有协议
function ProtocolProcessorSceneBossBattle:unregAll()
	self.m_tData = nil
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief	战斗心跳
function ProtocolProcessorSceneBossBattle:send_SYSTEM_BattleShakeHands(battleId )
	WZLog("send_SYSTEM_BattleShakeHands")
	local sender = Protocol:getSender( Protocol.MAIN_SYSTEM, Protocol.SYSTEM_BattleShakeHands )
	if sender==nil then WZLog("sender == nil") return end
    --if WBattleGlobal:getCurrent():isSingleStage() == true then return end

	sender:writeInt( battleId )	-- 战斗id
	SendProtocol(sender,false) --true:showLoading
    WZLog("send_SYSTEM_BattleShakeHands end",battleId)
end

--@brief	获得提示语
function ProtocolProcessorSceneBossBattle:send_BATTLE_GetTips( )
	WZLog("send_BATTLE_GetTips")
	local sender = Protocol:getSender( Protocol.MAIN_BATTLE, Protocol.BATTLE_GetTips )
	if sender==nil then WZLog("sender == nil") return end
    --if WBattleGlobal:getCurrent():isSingleStage() == true then return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	通知已经开始加载
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_StartLoading(battleId, playerId )
	WZLog("send_BOSSMAPBATTLE_StartLoading")
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_StartLoading )
	if sender==nil then WZLog("sender == nil") return end
    --if WBattleGlobal:getCurrent():isSingleStage() == true then return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( playerId )	-- 角色id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	通知已经完成加载
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_FinishLoading(battleId, playerId )
	WZLog("send_BOSSMAPBATTLE_FinishLoading")
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_FinishLoading )
	if sender==nil then WZLog("sender == nil") return end
    --if WBattleGlobal:getCurrent():isSingleStage() == true then return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( playerId )	-- 角色id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	战斗操作结束
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_EndCurRound(battleId, currentId )
	WZLog("send_BOSSMAPBATTLE_EndCurRound")
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_EndCurRound )
	if sender==nil then WZLog("sender == nil") return end
    if WBattleGlobal:getCurrent():isSingleStage() == true then return end
    
	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( currentId )	-- 角色id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	角色移动
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_PlayerMove(battleId,  currentId, movecount, movestep, curPositionX, curPositionY )
	WZLog("send_BOSSMAPBATTLE_PlayerMove")
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_PlayerMove )
	if sender==nil then WZLog("sender == nil") return end
    if WBattleGlobal:getCurrent():isSingleStage() == true then return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( currentId )	-- 角色id
	sender:writeInt( movecount )	-- 移动的次数
	if type(movestep) == "table" then
		local vtMoveStep = WZLuaVector_byte_:create()
		for i = 1, movecount do
			vtMoveStep:push( movestep[i] )	-- 每一次移动的方向（0：左，1：右）
		end
		sender:writeBytes( vtMoveStep )	-- 每一次移动的方向（0：左，1：右）
	else
		sender:writeBytes( movestep )	-- 每一次移动的方向（0：左，1：右）
	end
	sender:writeInt( BattleUtil:float2int(curPositionX) )	-- 没移动前的x坐标
	sender:writeInt( BattleUtil:float2int(curPositionY) )	-- 没移动前的y坐标
	SendProtocol(sender,false) --true:showLoading
end

--@brief	使用技能和道具
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_SkillEquip(battleId, currentId,  item_id, targetIds,param)
	WZLog("send_BOSSMAPBATTLE_SkillEquip", currentId, item_id)
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_SkillEquip )
	if sender==nil then WZLog("sender == nil") return end
    if WBattleGlobal:getCurrent():isSingleStage() == true then return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( currentId )	-- 角色id
	sender:writeInt( item_id )	
	sender:writeInts( targetIds ) --目标id
	sender:writeString(param)
	SendProtocol(sender,false) --true:showLoading
end

--@brief	宠物攻击
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_PetAttack(battleId, currentId, hurtPlayer,hurtValue  )
	WZLog("send_BOSSMAPBATTLE_PetAttack")
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_PetAttack )
	if sender==nil then WZLog("sender == nil") return end
    if WBattleGlobal:getCurrent():isSingleStage() == true then return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( currentId )	-- 角色id
    sender:writeInts( hurtPlayer )
    sender:writeInts( hurtValue )
	SendProtocol(sender,false) --true:showLoading
end

--@brief	发射
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_Shoot(battleId, currentId, speedx, speedy, leftRight, startX, startY, playerCount, playerIds, curPositionX, curPositionY, curPositionR, curPositionD,attackCount)
	WZLog("send_BOSSMAPBATTLE_Shoot")
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_Shoot )
	if sender==nil then WZLog("sender == nil") return end
    if WBattleGlobal:getCurrent():isSingleStage() == true then return end



	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( currentId )	-- 角色id
	sender:writeInt( BattleUtil:float2int(speedx) )	-- 发射速度
	sender:writeInt( BattleUtil:float2int(speedy) )	-- 力度速度
	sender:writeByte( leftRight )	-- 1：左 0：右（向左还是向右）
	sender:writeInt( BattleUtil:float2int(startX) )	-- 发射初始位置
	sender:writeInt( BattleUtil:float2int(startY) )	-- 发射初始位置
	sender:writeInt( playerCount )	-- 同步角色数量

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
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_Hurt(battleId, playerId, PlayerIds, hurtvalue, distance)

    WZLog("ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_Hurt")
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_Hurt )
	if sender==nil then WZLog("sender == nil") return end
    if WBattleGlobal:getCurrent():isSingleStage() == true then return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( playerId )	-- 角色id
	sender:writeInts( TableToIntVector(PlayerIds) )	-- 对应受伤害的序列
	sender:writeInts( TableToIntVector(hurtvalue) )	-- 受伤害值
    sender:writeInts( TableToIntVector(distance) )	-- 受伤害值

	SendProtocol(sender,false) --true:showLoading
end

--@brief	飞行
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_Fly(battleId, currentId, speedx, speedy, leftRight, isEquip, startX, startY, playerCount, playerId, curPositionX, curPositionY)
	WZLog("send_BOSSMAPBATTLE_Fly")
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_Fly )
	if sender==nil then WZLog("sender == nil") return end
    if WBattleGlobal:getCurrent():isSingleStage() == true then return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( currentId )	-- 角色id
	sender:writeInt( BattleUtil:float2int(speedx) )	-- 飞行速度
	sender:writeInt( BattleUtil:float2int(speedy) )	-- 飞行速度
	sender:writeByte( leftRight )	-- 1：左 0：右（向左还是向右）
	sender:writeInt( isEquip )	-- 是否道具飞行（0否1是）
	sender:writeInt( BattleUtil:float2int(startX) )	-- 飞行初始位置
	sender:writeInt( BattleUtil:float2int(startY) )	-- 飞行初始位置
	sender:writeInt( playerCount )	-- 同步角色数量
	sender:writeInts( TableToIntVector(playerId) )	-- 用户id
	sender:writeInts( FloatTableToIntVector(curPositionX) )	-- 没飞行前的x坐标
	sender:writeInts( FloatTableToIntVector(curPositionY) )	-- 没飞行前的y坐标

	SendProtocol(sender,false) --true:showLoading
end

--@brief	 被冰冻
function ProtocolProcessorSceneBossBattle:send_BATTLE_BeFrozen(battleId, playerIds )
	WZLog("send_BATTLE_BeFrozen")
	local sender = Protocol:getSender( Protocol.MAIN_BATTLE, Protocol.BATTLE_BeFrozen )
	if sender==nil then WZLog("sender == nil") return end
    if WBattleGlobal:getCurrent():isSingleStage() == true then return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInts( TableToIntVector(playerIds) )	-- 被冰冻的玩家id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	跳过本轮操作
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_Pass(battleId, currentId )
	WZLog("send_BOSSMAPBATTLE_Pass", battleId, currentId)
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_Pass )
	if sender==nil then WZLog("sender == nil") return end
    if WBattleGlobal:getCurrent():isSingleStage() == true then return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( currentId )	-- 角色id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	返回房间
function ProtocolProcessorSceneBossBattle:send_BOSSMAPROOM_BackToRoom(roomId,mapId )
	WZLog("send_BOSSMAPROOM_BackToRoom")
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_BackToRoom )
	if sender==nil then WZLog("sender == nil") return end
    if WBattleGlobal:getCurrent():isSingleStage() == true then return end

	sender:writeInt( roomId )	-- 房间号
	sender:writeInt( mapId )	-- 地图ID
	SendProtocol(sender,false) --true:showLoading
end

--@brief	某角色掉出了场景
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_OutOfScene(battleId, playerId, currentId )
	WZLog("send_BOSSMAPBATTLE_OutOfScene")
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_OutOfScene )
	if sender==nil then WZLog("sender == nil") return end
    if WBattleGlobal:getCurrent():isSingleStage() == true then return end

	sender:writeInt( battleId )	-- 战斗id
    sender:writeInt( currentId )	--操作人
	sender:writeInt( playerId )	-- 受害人
	SendProtocol(sender,false) --true:showLoading
end

--@brief	重生点
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_RebornPosition(battleId, playercount, PlayerIds, postionX, postionY )
	WZLog("send_BOSSMAPBATTLE_RebornPosition")
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_RebornPosition )
	if sender==nil then WZLog("sender == nil") return end
    if WBattleGlobal:getCurrent():isSingleStage() == true then return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( playercount )	-- 人数
	sender:writeInts( TableToIntVector(PlayerIds) )	-- 所有人id
	sender:writeInts( FloatTableToIntVector(postionX) )	-- x坐标
	sender:writeInts( FloatTableToIntVector(postionY) )	-- y坐标
	SendProtocol(sender,false) --true:showLoading
end

--@brief	强制退出战斗
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_QuitBattle(battleId, playerId )
	WZLog("send_BOSSMAPBATTLE_QuitBattle")
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_QuitBattle )
	if sender==nil then WZLog("sender == nil") return end
    --if WBattleGlobal:getCurrent():isSingleStage() == true then return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( playerId )	-- 战斗id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	发送加载百份比
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_LoadingPercent(battleId,  currentId, percent )
	WZLog("send_BOSSMAPBATTLE_LoadingPercent")
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_LoadingPercent )
	if sender==nil then WZLog("sender == nil") return end
    --if WBattleGlobal:getCurrent():isSingleStage() == true then return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( currentId )	-- 角色id
	sender:writeInt( percent )	-- 0~100
	SendProtocol(sender,false) --true:showLoading
end

--@brief	发送使用的表情
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_UsingFace(battleId, currentId, faceId )
	WZLog("send_BOSSMAPBATTLE_UsingFace")
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_UsingFace )
	if sender==nil then WZLog("sender == nil") return end
    if WBattleGlobal:getCurrent():isSingleStage() == true then return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( currentId )	-- 角色id
	sender:writeInt( faceId )	-- 使用的表情
	SendProtocol(sender,false) --true:showLoading
end


--@brief	使用近距离攻击
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_NearAttack(battleId, currentId, leftRight )
	WZLog("send_BOSSMAPBATTLE_NearAttack", currentId, leftRight)
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_NearAttack )
	if sender==nil then WZLog("sender == nil") return end
    if WBattleGlobal:getCurrent():isSingleStage() == true then return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( currentId )	-- 角色id
	sender:writeInt( leftRight )	-- 1：左 0：右（向左还是向右）
	SendProtocol(sender,false) --true:showLoading
end

--@brief	生成怪
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_BuildGuai(battleId, currentId,  guaiId, guaiPositionX, guaiPositionY )
	WZLog("send_BOSSMAPBATTLE_BuildGuai")
	WZLog(battleId,currentId,Serialize(guaiId),Serialize(guaiPositionX),Serialize(guaiPositionY))
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_BuildGuai )
	if sender==nil then WZLog("sender == nil") return end
    if WBattleGlobal:getCurrent():isSingleStage() == true then return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( currentId )	-- 角色id,谁生成的
	sender:writeInts( TableToIntVector(guaiId) )	-- 怪的数据形象id
	sender:writeInts( FloatTableToIntVector(guaiPositionX) )	-- X坐标
	sender:writeInts( FloatTableToIntVector(guaiPositionY) )	-- Y坐标
	SendProtocol(sender,false) --true:showLoading
end

--@brief	请求怪物战斗id
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_RequestGuaiBattleId(battleId, count )
	WZLog("send_BOSSMAPBATTLE_RequestGuaiBattleId")
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_RequestGuaiBattleId )
	if sender==nil then WZLog("sender == nil") return end
    if WBattleGlobal:getCurrent():isSingleStage() == true then return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( count )	-- 请求的数量
	SendProtocol(sender,false) --true:showLoading
end

--@brief	boss变身
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_BossChange(battleId, guaiBattleId, guaiOldId, guaiNewId )
	WZLog("send_BOSSMAPBATTLE_BossChange")
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_BossChange )
	if sender==nil then WZLog("sender == nil") return end
    if WBattleGlobal:getCurrent():isSingleStage() == true then return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( guaiBattleId )	-- 怪的战斗id
	sender:writeInt( guaiOldId )	-- 变身前在表中的id
	sender:writeInt( guaiNewId )	-- 变身后在表中的id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	抽奖
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_Reward( rewardIndex )
	WZLog("send_BOSSMAPBATTLE_Reward")
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_Reward )
	if sender==nil then WZLog("sender == nil") return end
    if WBattleGlobal:getCurrent():isSingleStage() == true then return end

    sender:writeInt( rewardIndex )	-- 翻牌的位置 1免费翻牌，2VIP翻牌，3钻石翻牌
    
	SendProtocol(sender,false) --true:showLoading
end

--@brief	改变位置
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_ChangePosition(battleId,  currentId, playerCount, playerIds, curPositionX, curPositionY, guaiCount, guaiBattleIds, guaiCurPositionX, guaiCurPositionY )
	WZLog("send_BOSSMAPBATTLE_ChangePosition")
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_ChangePosition )
	if sender==nil then WZLog("sender == nil") return end
    if WBattleGlobal:getCurrent():isSingleStage() == true then return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( currentId )	-- 角色id
	sender:writeInt( playerCount )	-- 同步角色数量
	sender:writeInts( TableToIntVector(playerIds) )	-- 用户id
	sender:writeInts( TableToIntVector(curPositionX) )	-- 没飞行前的x坐标
	sender:writeInts( TableToIntVector(curPositionY) )	-- 没飞行前的y坐标
	sender:writeInt( guaiCount )	-- 怪的数量
	sender:writeInts( TableToIntVector(guaiBattleIds) )	-- 怪id
	sender:writeInts( TableToIntVector(guaiCurPositionX) )	-- 没飞行前的x坐标
	sender:writeInts( TableToIntVector(guaiCurPositionY) )	-- 没飞行前的y坐标
	SendProtocol(sender,false) --true:showLoading
end

--@brief	杀死怪协议
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_KillGuai(battleId, guaiBattleIds )
	WZLog("send_BOSSMAPBATTLE_KillGuai")
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_KillGuai )
	if sender==nil then WZLog("sender == nil") return end
    if WBattleGlobal:getCurrent():isSingleStage() == true then return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInts( TableToIntVector(guaiBattleIds) )	-- 怪id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	发送玩家战斗属性
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_SendPlayerBattleAttribute(battleId, playerId, hp, pf, angry, hpMax, pfpMax, angryMax, attack, defend, BigSkillAttack )
	WZLog("send_BOSSMAPBATTLE_SendPlayerBattleAttribute")
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_SendPlayerBattleAttribute )
	if sender==nil then WZLog("sender == nil") return end
    if WBattleGlobal:getCurrent():isSingleStage() == true then return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( playerId )	-- 角色
	sender:writeInt( hp )	-- 血量
	sender:writeInt( pf )	-- 体力
	sender:writeInt( angry )	-- 怒气
	sender:writeInt( hpMax )	-- 血量最大值
	sender:writeInt( pfpMax )	-- 体力最大值
	sender:writeInt( angryMax )	-- 怒气最大值
	sender:writeInt( attack )	-- 攻击力
	sender:writeInt( defend )	-- 防御力
	sender:writeInt( BigSkillAttack )	-- 大招攻击力
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取宝箱信息
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_GetTreasureInfo(battleId )
	WZLog("send_BOSSMAPBATTLE_GetTreasureInfo")
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_GetTreasureInfo )
	if sender==nil then WZLog("sender == nil") return end
    if WBattleGlobal:getCurrent():isSingleStage() == true then return end

	sender:writeInt( battleId )	-- 战斗id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	与宝箱接触
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_TreasureContact(battleId,  currentId, item_count, item_id )
	WZLog("send_BOSSMAPBATTLE_TreasureContact")
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_TreasureContact )
	if sender==nil then WZLog("sender == nil") return end
    if WBattleGlobal:getCurrent():isSingleStage() == true then return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( currentId )	-- 角色id
	sender:writeInt( item_count )	-- 使用技能道具的数量(服务器要设置上限）
	sender:writeInts( TableToIntVector(item_id) )	-- 宝箱的id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	请求同步客户端
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_RequestSynchroClients(battleId, currentId, state, parameter )
	WZLog("send_BOSSMAPBATTLE_RequestSynchroClients", currentId, state)
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_RequestSynchroClients )
	if sender==nil then WZLog("sender == nil") return end
    if WBattleGlobal:getCurrent():isSingleStage() == true then return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( currentId )	-- 角色id
	sender:writeInt( state )	-- 状态
	sender:writeInts( TableToIntVector(parameter) )	-- 参数数组
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取技能列表
function ProtocolProcessorSceneBossBattle:send_PLAYER_GetSkillList( )
	WZLog("send_PLAYER_GetSkillList")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetSkillList )
	if sender==nil then WZLog("sender == nil") return end
    --if WBattleGlobal:getCurrent():isSingleStage() == true then return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取道具列表
function ProtocolProcessorSceneBossBattle:send_PLAYER_GetPropList( )
	WZLog("send_PLAYER_GetPropList")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPropList )
	if sender==nil then WZLog("sender == nil") return end
    --if WBattleGlobal:getCurrent():isSingleStage() == true then return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取玩家技能
function ProtocolProcessorSceneBossBattle:send_PLAYER_GetPlayerSkill( )
	WZLog("send_PLAYER_GetPlayerSkill")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerSkill )
	if sender==nil then WZLog("sender == nil") return end
    --if WBattleGlobal:getCurrent():isSingleStage() == true then return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取玩家道具
function ProtocolProcessorSceneBossBattle:send_PLAYER_GetPlayerProp( )
	WZLog("send_PLAYER_GetPlayerProp")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerProp )
	if sender==nil then WZLog("sender == nil") return end
    --if WBattleGlobal:getCurrent():isSingleStage() == true then return end

	SendProtocol(sender,false) --true:showLoading
end


--@brief	同步战斗对象位置信息(BOSSMAPBATTLE_SynPosition = 63)
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_SynPosition(battleId, combatId, positionX, positionY )
	WZLog("send_BOSSMAPBATTLE_SynPosition")
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_SynPosition )
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

--@brief	发送当前回合的信息
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_SendCurRoundInfo(battleId,turn, playerIds, postionX, postionY, angle, face, explodePlayerId, explodeSkillId, explodePosX, explodePosY )
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_SendCurRoundInfo )
	WBattleGlobal:getCurrent().m_bSendCurRoundInfo = turn
	if sender==nil then WZLog("sender == nil") return end
	WZLog("send_BATTLE_SendCurRoundInfo2")

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
	SendProtocol(sender,false) --true:showLoading
end

--@brief	同步战斗信息
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_SynchronousBattleInfo(battleId, playerId, scene )
	WZLog("send_BATTLE_SynchronousBattleInfo",battleId, playerId, scene)
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_SynchronousBattleInfo )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( playerId )	-- 角色
	sender:writeByte( scene )	-- 1：战斗场景 0：加载场景
	SendProtocol(sender,false) --true:showLoading
end
-------------------------------------服务器到客户端协议回调方法模块--------------------------------------
--@brief	发送当前回合的信息成功
function ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_SendCurRoundInfoOk(battleId, playerId, roundCount, playerIds, postionX, postionY, angle, face, explodePlayerId, explodeSkillId, explodePosX, explodePosY)
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
	WZLog("ProtocolProcessorSceneBossBattle:parse_BATTLE_SendCurRoundInfoOk",battleId, playerId, roundCount,"\nplayer", Serialize(VectorToTable(playerIds)), Serialize(IntVectorToFloatTable(postionX)), Serialize(IntVectorToFloatTable(postionY)), Serialize(IntVectorToFloatTable(angle)), Serialize(IntVectorToFloatTable(face)), "\nexplode", Serialize(VectorToTable(explodePlayerId)), Serialize(VectorToTable(explodeSkillId)), Serialize(IntVectorToFloatTable(explodePosX)), Serialize(IntVectorToFloatTable(explodePosY)))
end

--@brief	同步战斗信息成功
function ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_SynchronousBattleInfoOk(battleId, playerIds, dataIds, masterIds, camp, hp, sp, CTB, postionX, postionY, angle, face, buffCount, buffId, buffPassCtb, buffUserId, explodePlayerId, explodeSkillId, explodePosNum, explodePosX, explodePosY, finishPercent, roundNum, killCount, onlineStatus)
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
	-- buffPassCtb : buff剩下的的CTB时间
	-- buffUserId : buff的使用者ID
	-- explodePlayerId : 炸点对应的角色
	-- explodeSkillId : 炸点所使用的技能
	-- explodePosX : 炸点的x坐标
	-- explodePosY : 炸点的y坐标
	WZLog("ProtocolProcessorSceneBossBattle:parse_BATTLE_SynchronousBattleInfoOk", roundNum, "\n设置当前属性",Serialize(VectorToTable(playerIds)), Serialize(VectorToTable(dataIds)), Serialize(VectorToTable(masterIds)), Serialize(VectorToTable(camp)), 
		"\nhp",Serialize(VectorToTable(hp)), Serialize(VectorToTable(sp)), Serialize(VectorToTable(CTB)), Serialize(IntVectorToFloatTable(postionX)), Serialize(IntVectorToFloatTable(postionY)), Serialize(IntVectorToFloatTable(angle)), Serialize(VectorToTable(face))
		, "\n增减buff", Serialize(VectorToTable(buffCount)), Serialize(VectorToTable(buffId)), Serialize(VectorToTable(buffPassCtb)), Serialize(VectorToTable(buffUserId))
		, "\n地图爆炸", Serialize(VectorToTable(explodePlayerId)), Serialize(VectorToTable(explodeSkillId)), Serialize(VectorToTable(explodePosNum)), Serialize(IntVectorToFloatTable(explodePosX)), Serialize(IntVectorToFloatTable(explodePosY))
		, "\n被杀次数", Serialize(VectorToTable(killCount)), "\n在线状态", Serialize(VectorToTable(onlineStatus)),finishPercent)

	--[[
	WBattleGlobal:getCurrent().m_nHostBattleId = nil
	WBattleGlobal:getCurrent():synchronousBattleInfo(
		VectorToTable(playerIds), VectorToTable(dataIds), VectorToTable(masterIds), VectorToTable(hp), VectorToTable(sp), VectorToTable(CTB), IntVectorToFloatTable(postionX), IntVectorToFloatTable(postionY)
		, IntVectorToFloatTable(angle), VectorToTable(face), VectorToTable(buffCount), VectorToTable(buffId), VectorToTable(buffPassCtb), VectorToTable(buffUserId)
		, VectorToTable(explodePlayerId), VectorToTable(explodeSkillId), VectorToTable(explodePosNum), IntVectorToFloatTable(explodePosX), IntVectorToFloatTable(explodePosY),finishPercent)
	--]]

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
		data.hp = VectorToTable(hp)
		data.sp = VectorToTable(sp)
		data.CTB = VectorToTable(CTB)
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
function ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_ComeBackBattleInfoOk(battleId, playerId)
	-- battleId : 战斗id
	-- playerId : 角色id
	WZLog("ProtocolProcessorSceneBossBattle:parse_BATTLE_ComeBackBattleInfoOk", playerId)
	WBattleGlobal:getCurrent().m_nComeBackBattleId = playerId
	local msg = MsgManager:createMsg(BattleMsgComeBackBattleInfoOk)
	msg.m_nPlayerId = playerId
	MsgManager:pushBlockMsg(msg)
end

--@brief	获取房间状态成功
function ProtocolProcessorSceneBossBattle:parse_WORLDBOSS_GetRoomStateOk(mapId, bossBloodMax, bossBloodCurrent,rankPlayerId, rankPlayerName, rankHurt, headId, faceId, sex, headColor, vipLevel, hurt, cdTime, accelerateCost, inspire, bossLevel, myRank, dimaCDTime, goldCDTime,bossIsDead,openTime)
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
    WZLog("ProtocolProcessorSceneBossBattle:parse_WORLDBOSS_GetRoomStateOk")
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
function ProtocolProcessorSceneBossBattle:parse_WORLDBOSS_SendSettlementInfo(hurtValue, hurtRank, hurtPercent, isWin, killerId, killerName)
    -- hurtValue : 总伤害输出
    -- hurtRank : 输出排名
    -- hurtPercent : 伤害所占百分比
    -- isWin : 是否赢了
    -- killerId : 击杀玩家id
    -- killerName : 击杀玩家名称
    WZLog("ProtocolProcessorSceneBossBattle:parse_WORLDBOSS_SendSettlementInfo",hurtValue, hurtRank, hurtPercent, tostring(isWin), killerId, killerName)
    if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS and WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_WORLDBOSS then

        WBattleGlobal:getCurrent():setGameOver(true)
        WindowManager:removeAllWindow()

	    local data = {bossId = WBattleGlobal:getCurrent().m_tMakePairOk.mapId,
	    isWin = isWin, hurtValue = tonumber(hurtValue), hurtRank = hurtRank, killerName = killerName,killerId = killerId,hurtPercent = hurtPercent}
	    WndWorldBossEnd:showWnd( data ,true)
	end
end

--@brief	获得提示语成功
function ProtocolProcessorSceneBossBattle:parse_BATTLE_GetTipsOk(tips)
	-- tips : 提示语
	WZLog("ProtocolProcessorSceneBossBattle:parse_BATTLE_GetTipsOk")
	SceneBattleLoading:receiveTips(VectorToTable(tips))
end

--@brief	通知客户端对指定角色进行控制
function ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_AIControlCommon(battleId)
	-- battleId : 战斗id
	-- idcount : 要控制的ai数量
	-- playerIds : 需要被控制的角色id
	-- aiCtrlId : 控制方案id
	-- guaiIdCount : 要控制的ai数量
	-- guaiBattleIds : 需要被控制的怪战斗id
	-- guaiAiCtrlId : 控制方案id
	WZLog("ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_AIControlCommon")
	SceneBattleLoading:receiveAIControlCommon(VectorToTable(battleId))
end

--@brief	通知角色进入战斗
function ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_GotoBattle(battleId, wind,  currentId, attackRate, battleRand, playerIds, oldCTB, newCTB, updateCTB_time)
	-- battleId : 战斗id
	-- wind : 风力（负数为坐风向，正数为右风向）
	-- currentId : 角色id(下回和操作的角色）
	-- isCriticalHit : 是否爆击
	-- attackRate : 攻击力比率
	-- battleRand : 游戏随机数
	-- runTimes : 副本游戏回合数限制
	WZLog("ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_GotoBattle")

	--[[
    local tPlayerId = VectorToTable(playerIds)
    local tNowCtb = VectorToTable(oldCTB)
    local tNewCtb = VectorToTable(newCTB)
    BattleCtbManager:refreshLastCtb(tPlayerId,tNowCtb,tNewCtb,updateCTB_time)

    WZLog("ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_CanStartCurRound_GotoBattle \n tPlayerId=",Serialize(tPlayerId),"\n tNowCtb=", Serialize(tNowCtb), "\n tNewCtb", Serialize(tNewCtb),"\n updateCTB_time=", updateCTB_time)
	SceneBattleLoading:receiveGotoBattle(VectorToTable(battleId), nil, VectorToTable(wind), VectorToTable(currentId), VectorToTable(attackRate),VectorToTable(battleRand))
	--]]

	SceneBattleLoading:receiveGotoBattle()
end

--@brief	添加Buff
--@return	#1:返回数据表
function ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_AddBuff(userId,playerId, buffId)
    WZLog("ProtocolProcessorSceneBossBattle:parse_BATTLE_AddBuff", playerId, buffId,userId)
    local msg = MsgManager:createMsg(BattleMsgAddBuff)
	msg.m_tData = {userId=userId,playerId=playerId,buffId=buffId}
	MsgManager:pushBlockMsg(msg)
end

--@brief	通知角色当前操作角色时间到了
function ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_CanStartCurRound(battleId, wind,  currentId, attackRate, battleRand,playerIds, nowHP, nowSP,oldCTB,newCTB,updateCTB_time)
	-- battleId : 战斗id
	-- wind : 风力（负数为坐风向，正数为右风向）
	-- currentId : 角色id(下回和操作的角色）
	-- isCriticalHit : 是否暴击(0否1是)
	-- attackRate : 攻击力比率
	-- isNewRound : 是否新回合1是0否
	-- battleRand : 游戏随机数
	-- roundTimes : 当前游戏回合数
	--WZLog("ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_CanStartCurRound")
    WBattleGlobal:getCurrent().m_nStartRoundTimes = WBattleGlobal:getCurrent().m_nTurnTimes + 1
    WBattleGlobal:getCurrent().m_nStartRoundPlayerId = currentId
    WBattleGlobal:getCurrent().m_tBattleRand = VectorToTable(battleRand)

	local list = WBattleGlobal:getCurrent():getCharacterList()
	local tPlayerId = VectorToTable(playerIds)
	local tNowHP = VectorToTable(nowHP)
    local tNowSP = VectorToTable(nowSP)

	local chara = WBattleGlobal:getCurrent():getCharacterWithId(currentId)

	if chara == nil and currentId ~= -1 then
		WZLog("ProtocolProcessorSceneBossBattle:parse_BATTLE_CanStartCurRound", "can't find player:", currentId)
        for i, v in pairs(WBattleGlobal:getCurrent():getGuaiList()) do
            WZLog("ProtocolProcessorSceneBossBattle:parse_BATTLE_CanStartCurRound two", i, v:getBattleId())
        end

        WBattleGlobal:getCurrent().m_bIsCurTurnActed = true

        WndBattleHud:endTurnTime()
        WBattleGlobal:getCurrent():endCurRound(currentId,43,nil,nil,true)
		return
	end

    local tNowCtb = VectorToTable(oldCTB)
    local tNewCtb = VectorToTable(newCTB)

    WZLog("ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_CanStartCurRound two \n tPlayerId=",Serialize(tPlayerId),"\n tNowHP=", Serialize(tNowHP),"\n tNowSP=", Serialize(tNowSP),"\n tNowCtb=", Serialize(tNowCtb), "\n tNewCtb", Serialize(tNewCtb),"\n updateCTB_time=", updateCTB_time)
    BattleCtbManager:refreshLastCtb(tPlayerId,tNowCtb,tNewCtb,updateCTB_time)

    local msg = MsgManager:createMsg(BattleMsgShowCtbTime)
    msg.m_tPlayerId = tPlayerId
	msg.m_tNowHP = tNowHP
	msg.m_tNowSP= tNowSP
    msg.m_tBattleRand = VectorToTable(battleRand)
    MsgManager:pushBlockMsg(msg)

	if currentId == -1 then
		for id,boss in pairs(WBattleGlobal:getCurrent():getBossList()) do
			for id,guai in pairs(boss:getChildCharaList()) do
				local msg = MsgManager:createMsg(BattleMsgZoomToHero)
				msg.m_nPlayerId = guai:getBattleId()
				msg.m_nPlayerPos = guai:getAnimation():getPosition()
				msg.m_bIsFollow = true
				MsgManager:pushBlockMsg(msg)
				break
			end
		end
	else
        ---[[
		local msg = MsgManager:createMsg(BattleMsgZoomToHero)
		msg.m_nPlayerId = currentId
		msg.m_nPlayerPos = chara:getAnimation():getPosition()
		msg.m_bIsFollow = true
		MsgManager:pushBlockMsg(msg)
        --]]
	end

	local msg = MsgManager:createMsg(BattleMsgReadyStartRound)
    MsgManager:pushBlockMsg(msg)
    
    WBattleGlobal:getCurrent().m_nEndCurRoundBattleId = nil
	local msg = MsgManager:createMsg(BattleMsgCanStartCurRound)
	msg.m_nBattleId = battleId
	msg.m_nCurrentPlayerId = currentId
	msg.m_nWind = wind
	msg.m_bIsCrit = 0
	msg.m_tAttackRate = VectorToTable(attackRate)
	msg.m_nIsNewRound = 1
	msg.m_tBattleRand = VectorToTable(battleRand)
	MsgManager:pushBlockMsg(msg)

end

--@brief	其他角色移动
function ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_OtherPlayerMove(battleId,  currentId, movecount, movestep, curPositionX, curPositionY)
	-- battleId : 战斗id
	-- currentId : 角色id
	-- movecount : 移动的次数
	-- movestep : 每一次移动的方向（1：左，0：右）
	-- curPositionX : 没移动前的x坐标
	-- curPositionY : 没移动前的y坐标
	WZLog("ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_OtherPlayerMove")
	local guai = WBattleGlobal:getCurrent():getGuaiWithId(currentId)
	movestep = VectorToTable(movestep)
	if guai ~= nil then
		guai:receiveMove(VectorToTable(movecount), VectorToTable(movestep), BattleUtil:int2float(curPositionX), BattleUtil:int2float(curPositionY))
	else
		local msg = MsgManager:createMsg(BattleMsgPlayerMove)
		msg.m_nBattleId = battleId
		msg.m_nCurrentPlayerId = currentId
		msg.m_nMovecount = VectorToTable(movecount)
		msg.m_tMovestep = VectorToTable(movestep)
		msg.m_nCurPositionX = BattleUtil:int2float(curPositionX)
		msg.m_nCurPositionY = BattleUtil:int2float(curPositionY)
		MsgManager:pushBlockMsg(msg)
	end
end

--@brief	其他角色使用技能和道具
function ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_OtherSkillEquip(battleId,  currentId, item_id,targetIds,params)
	-- battleId : 战斗id
	-- currentId : 角色id
	-- item_count : 使用技能道具的数量(服务器要设置上限）
	-- item_id : 技能道具的id
	WZLog("ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_OtherSkillEquip")
	--图腾加血技能不需要同步
	local config = CopyTable(GDatatab_skill["id_"..item_id])
	if config and config.isNotSync == 1 then
		return
	end
	
	local hero = WBattleGlobal:getCurrent():getCharacterWithId(currentId)
    if hero and hero:isCanControl() == false and hero:getType() == 0 then
			-- BattleHeroUse:heroUse(currentId,BattleHeroUse.USE_SKILL_OR_ITEM,item_id)
		local msg = MsgManager:createMsg(BattleMsgUseSkill)
		msg.m_tData = {playerId=currentId,type=BattleHeroUse.USE_SKILL_OR_ITEM,itemId=item_id}
		MsgManager:pushBlockMsg(msg)
	end
	
	if hero and hero:isCanControl() == false and hero:getType() == 1 then
		--添加本回合技能同步
		local msg = MsgManager:createMsg(BattleMsgSyncSkill)
		msg.m_nCurrentPlayerId = currentId
		msg.m_nSkillId = item_id
		MsgManager:pushBlockMsg(msg)
	end
end

--@brief	更新怒气值
function ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_ChangeAngryValue(battleId,  currentId, AngryValue)
	-- battleId : 战斗id
	-- currentId : 角色id
	-- AngryValue : 更新怒气值（由服务器计算所得）
	WZLog("ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_ChangeAngryValue", AngryValue)
    --WBattleGlobal:getCurrent():getCharacterWithId(currentId):setSp(AngryValue)
end

--@brief	是否可以使用大招
function ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_OtherBigSkill(battleId, currentId)
	-- battleId : 战斗id
	-- currentId : 角色id
	WZLog("ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_OtherBigSkill")
	local hero = WBattleGlobal:getCurrent():getCurrentHero()
	if hero:isCanControl() == false then
		BattleHeroUse:heroUse(currentId,BattleHeroUse.USE_BIGSKILL)
	end
end


--@brief	获得提示语错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBossBattle:send_BATTLE_GetTips_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBossBattle:send_BATTLE_GetTips_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BATTLE, Protocol.BATTLE_GetTips, nflag, sMessage)
end

--@brief	通知已经开始加载错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_StartLoading_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_StartLoading_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPBATTLE_StartLoading, nflag, sMessage)
end

--@brief	其它人发射
function ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_OtherShoot(battleId, currentId, speedx, speedy, leftRight, startX, startY, playerCount, playerIds, curPositionX, curPositionY, curPositionR, curPositionD)
	-- battleId : 战斗id
	-- currentId : 角色id
	-- speedx : 发射速度
	-- speedy : 发射速度
	-- leftRight : 1：左 0：右（向左还是向右）
	-- startX : 发射初始位置
	-- startY : 发射初始位置
	-- playerCount : 同步角色数量
	-- playerIds : 用户id
	-- curPositionX : 没飞行前的x坐标
	-- curPositionY : 没飞行前的y坐标
	-- guaiCount : 怪的数量
	-- guaiBattleIds : 怪id
	-- guaiCurPositionX : 没飞行前的x坐标
	-- guaiCurPositionY : 没飞行前的y坐标

	local player = WBattleGlobal:getCurrent():getCharacterWithId(currentId)


	if player ~= nil then
		-- 触发普攻技能
		BattleAttackSkillManager:triggerInitiativeSkill(player)


        WBattleGlobal:getCurrent().m_tCurRoundAction = {round=WBattleGlobal:getCurrent().m_nTurnTimes, player=currentId}

		local msg = MsgManager:createMsg(BattleMsgPlayerShoot)
		msg.m_nBattleId = VectorToTable(battleId)
		--msg.m_nPlayerId = VectorToTable(playerId)
		msg.m_nCurrentPlayerId = VectorToTable(currentId)
		msg.m_nStartX = VectorToTable(BattleUtil:int2float(startX))
		msg.m_nStartY = VectorToTable(BattleUtil:int2float(startY))
		msg.m_nLeftRight = VectorToTable(leftRight)
		msg.m_nSpeedx = VectorToTable(BattleUtil:int2float(speedx))
		msg.m_nSpeedy = VectorToTable(BattleUtil:int2float(speedy))

		msg.m_nPlayerCount = playerCount
		msg.m_tPlayerId = VectorToTable(playerIds)
		msg.m_tCurPositionX = IntVectorToFloatTable(curPositionX)
		msg.m_tCurPositionY = IntVectorToFloatTable(curPositionY)
        msg.m_tCurPositionR = IntVectorToFloatTable(curPositionR)
        msg.m_tCurPositionD = IntVectorToFloatTable(curPositionD)

	    -- 特定皮肤(宇航员,鬼新娘)大招特殊处理 皮肤大招技能发送的startX和startY是子弹爆炸位置 子弹初始位置设为(startX,地图高)
		local hero = WBattleGlobal:getCurrent():getCharacterWithId(currentPlayerId)
	    if hero:getUseSkinBigSkill() and (hero:getSkinBigSkill() == 3030 or hero:getSkinBigSkill() == 3046) then
			msg.m_nStartX = BattleUtil:int2float(startX)
			msg.m_nStartY = SceneBattle:getFrontLayerSize().height
			msg.m_nEndX = BattleUtil:int2float(startX)
			msg.m_nEndY = BattleUtil:int2float(startY)
	    end

        WZLog("ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_OtherShoot",Serialize(msg.m_tCurPositionR),Serialize(msg.m_tCurPositionD))
		MsgManager:pushBlockMsg(msg)
		return
	end
	local guai = WBattleGlobal:getCurrent():getGuaiWithId(currentId)
	if guai ~= nil then
		guai:receiveShoot(BattleUtil:int2float(speedx), BattleUtil:int2float(speedy), leftRight, BattleUtil:int2float(startX), BattleUtil:int2float(startY), playerCount, VectorToTable(playerIds), IntVectorToFloatTable(curPositionX), IntVectorToFloatTable(curPositionY), IntVectorToFloatTable(curPositionR), IntVectorToFloatTable(curPositionD))
		return
	end

end

--@brief	冰冻解除
function ProtocolProcessorSceneBossBattle:parse_BATTLE_FrozenOver(playerIds)
	-- playerIds : 冰冻解除的玩家id
	WZLog("ProtocolProcessorSceneBossBattle:parse_BATTLE_FrozenOver")
	for i=0,playerIds:size()-1 do
		local hero = WBattleGlobal:getCurrent():getHeroWithId(playerIds:get(i))
		hero:removeFrozenAnimation()
	end
end

--@brief	发射完成
function ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_UpdateHP(battleId, playercount, PlayerIds, hp, guaicount, guaiBattleIds, guaiHp, attackType)
	-- battleId : 战斗id
	-- playercount : 人数
	-- PlayerIds : 所有人id
	-- hp : 所有人的当前血量
	-- guaicount : 怪数量
	-- guaiBattleIds : 所有怪id
	-- guaiHp : 所有怪的当前血量
	WZLog("ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_UpdateHP")
	local msg = MsgManager:createMsg(BattleMsgUpdatePlayerHP)
	msg.m_nBattleId = VectorToTable(battleId)
	msg.m_nPlayercount = VectorToTable(playercount)
	msg.m_tPlayerIds = VectorToTable(PlayerIds)
	msg.m_tHp = VectorToTable(hp)
	msg.m_nGuaicount = VectorToTable(guaicount)
	msg.m_tGuaiBattleIds = VectorToTable(guaiBattleIds)
	msg.m_tGuaiHp = VectorToTable(guaiHp)
    msg.m_nAttackType = VectorToTable(attackType)
	MsgManager:pushNonBlockMsg(msg)
end

--@brief	其它人飞行
function ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_OtherFly(battleId, currentId, speedx, speedy, leftRight, isEquip, startX, startY, playerCount, playerId, curPositionX, curPositionY)
	-- battleId : 战斗id
	-- currentId : 角色id
	-- speedx : 飞行速度
	-- speedy : 飞行速度
	-- leftRight : 1：左 0：右（向左还是向右）
	-- isEquip : 是否道具飞行（0否1是）
	-- startX : 飞行初始位置
	-- startY : 飞行初始位置
	-- playerCount : 同步角色数量
	-- playerId : 用户id
	-- curPositionX : 没飞行前的x坐标
	-- curPositionY : 没飞行前的y坐标
	-- guaiCount : 怪的数量
	-- guaiBattleId : 怪id
	-- guaiCurPositionX : 没飞行前的x坐标
	-- guaiCurPositionY : 没飞行前的y坐标
	WZLog("ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_OtherFly")

    WBattleGlobal:getCurrent().m_tCurRoundAction = {round=WBattleGlobal:getCurrent().m_nTurnTimes, player=currentId}

    local msg = MsgManager:createMsg(BattleMsgPlayerFly)
    msg.m_nBattleId = battleId
    msg.m_nPlayerId = WBattleGlobal:getCurrent():getMyBattleId()
    msg.m_nCurrentPlayerId = currentId
    msg.m_nStartX = BattleUtil:int2float(startX)
    msg.m_nStartY = BattleUtil:int2float(startY)
    msg.m_nLeftRight = leftRight
    msg.m_nIsEquip = isEquip
    msg.m_nSpeedx = BattleUtil:int2float(speedx)
    msg.m_nSpeedy = BattleUtil:int2float(speedy)
    msg.m_nPlayerCount = playerCount
    msg.m_tPlayerId = VectorToTable(playerId)
    msg.m_tCurPositionX = IntVectorToFloatTable(curPositionX)
    msg.m_tCurPositionY = IntVectorToFloatTable(curPositionY)
    MsgManager:pushBlockMsg(msg)
end

--@brief	人物死亡
function ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_SomeOneDead(battleId,  PlayerIds)
	-- battleId : 战斗id
	-- deadPlayerCount : 死亡人量
	-- PlayerIds : 谁死了
	-- deadGuaiCount : 死亡怪量
	-- guaiBattleIds : 谁死了
	WZLog("ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_SomeOneDead")
	local msg = MsgManager:createMsg(BattleMsgSomeOneDead)
	msg.m_nBattleId = battleId
    msg.m_nDeadPlayerCount = #VectorToTable(PlayerIds)
	msg.m_tPlayerIds = VectorToTable(PlayerIds)
	MsgManager:pushBlockMsg(msg)

	for i,deadHero in pairs(VectorToTable(PlayerIds)) do
        local hero = WBattleGlobal:getCurrent():getCharacterWithId(deadHero)
        WZLog("ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_SomeOneDead m_bServerDead", i,deadHero)
    end
	WMonster:receiveSomeOneDead(deadPlayerCount, VectorToTable(PlayerIds), deadGuaiCount, VectorToTable(guaiBattleIds))
	-- for id,guai in pairs(WBattleGlobal:getCurrent():getGuaiList()) do
	-- 	guai:receiveSomeOneDead(deadPlayerCount, VectorToTable(PlayerIds), deadGuaiCount, VectorToTable(guaiBattleIds))
	-- end
end

--@brief	跳过本轮操作
function ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_OtherPass(battleId, currentId)
	-- battleId : 战斗id
	-- currentId : 角色id
	WZLog("ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_OtherPass", currentId, tostring( WBattleGlobal:getCurrent().m_bIsCurTurnActed),WBattleGlobal:getCurrent().m_nTurnTimes)

 --    if WBattleGlobal:getCurrent().m_bIsCurTurnActed == true then
 --        return
 --    end

	WndBattleHud:endTurnTime()
	WBattleGlobal:getCurrent():endCurRound(currentId,44,nil,nil,true)
	WBattleGlobal:getCurrent().m_nReceivePassRound = WBattleGlobal:getCurrent().m_nTurnTimes
	-- local msg = MsgManager:createMsg(BattleMsgEndCurRound)
	-- msg.m_nBattleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
	-- msg.m_nPlayerId = WBattleGlobal:getCurrent():getMyBattleId()
	-- msg.m_nCurrentPlayerId = WBattleGlobal:getCurrent():getMyBattleId()
	-- msg.m_nPlayerOrGuai = 0
 --    msg.note = 44
	-- MsgManager:pushBlockMsg(msg)
end

--@brief	通知游戏结束
function ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_GameOver(battleId, winCamp, playerIds, playerLevel, playerExp, rewardNum, rewardId, rewardCount, flopNum, flopId, flopCount, hurtNum)
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
	WZLog("ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_GameOver")

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
	}

	local hurt = VectorToTable(hurtNum)
	for i = 1, #hurt do
		WZLog("----------------hurt------------",hurt[i])
	end

    MsgManager:pushNonBlockMsg(msg)
end

--@brief	玩家掉线
function ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_PlayerLose(battleId, PlayerId, isQuit)
	-- battleId : 战斗id
	-- PlayerId : 掉线角色id
    -- isQuit : 是否强退
	WZLog("ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_PlayerLose", PlayerId, tostring(isQuit))
	if PlayerId == GlobalGame.g_tPlayerInfo.nPlayerId then
		MsgBoxManager:showConfirmBox(LocalStrings.BATTLE_RECONNECT_FAIL, SceneBattle, SceneBattle.leftBattle, MSGBOXLEVEL_NORMAL, nil, true)
        --WBattleGlobal:getCurrent().m_nShowNetLostTime = 5
	end

	local msg = MsgManager:createMsg(BattleMsgPlayerExit)
	msg.m_nBattleId = battleId
	msg.m_nPlayerId = PlayerId
    msg.m_bIsQuit = isQuit
	MsgManager:pushBlockMsg(msg)

  --   for id,hero in pairs(WBattleGlobal:getCurrent():getHeroList()) do
		-- if id == PlayerId then
  --           WZLog("ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_PlayerLose two", PlayerId)
		-- 	hero.m_bLoseNet = true
  --       end
  --   end
end

--@brief	人物复活
function ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_PlayerReborn(battleId, playercount, PlayerIds, postionX, postionY)
	-- battleId : 战斗id
	-- playercount : 人数
	-- PlayerIds : 所有人id
	-- postionX : x坐标
	-- postionY : y坐标
	-- guaicount : 怪数
	-- guaiBattleIds : 所有人id
	-- guaipostionX : x坐标
	-- guaipostionY : y坐标
	WZLog("ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_PlayerReborn")

	for id,guai in pairs(WBattleGlobal:getCurrent():getGuaiList()) do
		guai:receivePlayerReborn(playercount, VectorToTable(PlayerIds), IntVectorToFloatTable(postionX), IntVectorToFloatTable(postionY), guaicount, VectorToTable(guaiBattleIds), IntVectorToFloatTable(guaipostionX), IntVectorToFloatTable(guaipostionY))
	end
end

--@brief	更新勋章数
function ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_UpdateMedal(battleId, playerId, campCount, campId, campMedalNum)
	-- battleId : 战斗id
	-- playerId : 角色id(发给哪个的)
	-- campCount : 阵营数量
	-- campId : 阵营id
	-- campMedalNum : 阵营所得的奖牌数
	WZLog("ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_UpdateMedal")
end

--@brief	强制退出战斗成功
function ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_QuitBattleOk(battleId,playerId)
	-- battleId : 战斗id
	WZLog("ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_QuitBattleOk")

    MsgBoxManager:showConfirmBox(LocalStrings.BATTLE_RECONNECT_FAIL, SceneBattle, SceneBattle.leftBattle, MSGBOXLEVEL_NORMAL, nil, true)

end

--@brief	其他人加载百份比
function ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_OtherLoadingPercent(battleId,  currentId, percent)
	-- battleId : 战斗id
	-- currentId : 角色id
	-- percent : 0~100
	WZLog("ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_OtherLoadingPercent")
	SceneBattleLoading:receiveOtherPercent(VectorToTable(battleId), nil, VectorToTable(currentId), VectorToTable(percent))
end

--@brief	其他人使用表情
function ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_OtherUsingFace(battleId,  currentId, faceId)
	-- battleId : 战斗id
	-- currentId : 角色id
	-- faceId : 使用的表情
	WZLog("ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_OtherUsingFace")

	local hero = WBattleGlobal:getCurrent():getCharacterWithId(currentId)
	hero:playFaceAnimation(faceId)
end


--@brief	其他人使用近距离攻击
function ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_OtherNearAttack(battleId,  currentId, leftRight)
	-- battleId : 战斗id
	-- currentId : 角色id
	-- leftRight : 1：左 0：右（向左还是向右）
	WZLog("ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_OtherNearAttack", currentId, leftRight)
	local guai = WBattleGlobal:getCurrent():getGuaiWithId(currentId)
	if guai ~= nil then
		guai:receiveNearAttack(VectorToTable(leftRight))
	end

end

--@brief	其他人生成怪
function ProtocolProcessorSceneBossBattle:parse_BATTLE_BossOtherMapBuildGuai(battleId, currentId, guaiBattleId, guaiId, guaiPositionX, guaiPositionY)
	-- battleId : 战斗id
	-- currentId : 角色id,谁生成的
	-- guaiCount : 生成的数量
	-- guaiBattleId : 生成怪的战斗id
	-- guaiId : 怪的数据形象id
	-- guaiPositionX : X坐标
	-- guaiPositionY : Y坐标
	WZLog("ProtocolProcessorSceneBossBattle:parse_BATTLE_BossOtherMapBuildGuai")
	local  guai = WBattleGlobal:getCurrent():getGuaiWithId(currentId)
	if not guai then
		guai = WBattleGlobal:getCurrent():getCharacterWithId(currentId)
	end

	if guai ~= nil then
		guai:receiveBuildXiaoGuai(VectorToTable(guaiBattleId), VectorToTable(guaiId), IntVectorToFloatTable(guaiPositionX), IntVectorToFloatTable(guaiPositionY))
	end
end

--@brief	请求怪物战斗id
function ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_RequestGuaiBattleIdOk(battleId, count, guaiBattleId)
	-- battleId : 战斗id
	-- count : 数量
	-- guaiBattleId : 生成怪的战斗id,用于生成怪的时使,使各个客户端id不冲突
	WZLog("ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_RequestGuaiBattleIdOk")

	WBattleGlobal:getCurrent().m_bIsRequestingId = false
	for i=1,count do
		table.insert(WBattleGlobal:getCurrent().m_tGuaiBattleId,guaiBattleId:get(i-1))
	end
end

--@brief	boss变身
function ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_OtherChange(battleId, guaiBattleId, guaiOldId, guaiNewId)
	-- battleId : 战斗id
	-- guaiBattleId : 怪的战斗id
	-- guaiOldId : 变身前在表中的id
	-- guaiNewId : 变身后在表中的id
	WZLog("ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_OtherChange")
	local guai = WBattleGlobal:getCurrent():getGuaiWithId(guaiBattleId)
	if guai ~= nil then
		guai:receiveBossChange(VectorToTable(guaiOldId), VectorToTable(guaiNewId))
		return
	end
end

--@brief	其它人抽一次奖
function ProtocolProcessorSceneBossBattle:parse_BOSSMAPROOM_OtherRewardOk(playerId, rewardIndex)
	-- playerId : 谁抽奖了
    -- rewardIndex : 翻牌的位置 1免费翻牌，2VIP翻牌，3钻石翻牌
	WZLog("ProtocolProcessorSceneBossBattle:parse_BOSSMAPROOM_OtherRewardOk")
    WndMultiWin:otherRewardOk(playerId, rewardIndex)
end

--@brief	其他人位置改变
function ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_OtherChangePosition(battleId, currentId, playerCount, playerIds, curPositionX, curPositionY, guaiCount, guaiBattleIds, guaiCurPositionX, guaiCurPositionY)
	-- battleId : 战斗id
	-- currentId : 角色id
	-- playerCount : 同步角色数量
	-- playerIds : 用户id
	-- curPositionX : 没飞行前的x坐标
	-- curPositionY : 没飞行前的y坐标
	-- guaiCount : 怪的数量
	-- guaiBattleIds : 怪id
	-- guaiCurPositionX : 没飞行前的x坐标
	-- guaiCurPositionY : 没飞行前的y坐标
	WZLog("ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_OtherChangePosition")
end

--@brief	获取宝箱信息成功
function ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_GetTreasureInfoOk(battleId, id, group, nType, name, icon, effect1, effect2, turn, probability, posX, posY)
	-- battleId : 战斗id
	-- id : 宝箱的id
	-- group : 宝箱的分组
	-- nType : 宝箱的类型
	-- name : 宝箱的名字
	-- icon : 宝箱的icon
	-- effect1 : 宝箱的效果参数1
	-- effect2 : 宝箱的效果参数2
	-- turn : 效果回合数
	-- probability : 概率(10000)
	-- posX : 出现的位置的X坐标
	-- posY : 出现的位置的Y坐标
	WZLog("ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_GetTreasureInfoOk")
	for key,boss in pairs(WBattleGlobal:getCurrent():getBossList()) do
		boss:buildTreasure(VectorToTable(id), VectorToTable(group), VectorToTable(nType), VectorToTable(name), VectorToTable(icon), VectorToTable(effect1), VectorToTable(effect2), VectorToTable(turn), VectorToTable(probability), VectorToTable(posX), VectorToTable(posY))
		return
	end
end

--@brief	其他角色与宝箱接触
function ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_OtherTreasureContact(battleId,  currentId, item_count, item_id)
	-- battleId : 战斗id
	-- currentId : 角色id
	-- item_count : 使用技能道具的数量(服务器要设置上限）
	-- item_id : 宝箱的id
	WZLog("ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_OtherTreasureContact")
end

--@brief	发送同步客户端
function ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_SendSynchroClients(battleId, currentId, state, parameter)
	-- battleId : 战斗id
	-- playerOrGuai : 0:player 1:guai
	-- currentId : 角色id
	-- state : 状态
	-- parameter : 参数数组
	WZLog("ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_SendSynchroClients", currentId, state)
end

--@brief	获取技能列表成功
function ProtocolProcessorSceneBossBattle:parse_PLAYER_GetSkillListOk(count, id, name, icon, priceCostGold, desc, itemMainType, itemSubType, param1, param2, tireValue, consumePower, specialAttackType, specialAttackParam)
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
	WZLog("ProtocolProcessorSceneBossBattle:parse_PLAYER_GetSkillListOk")
	SceneBattleLoading:receiveGetSkillListOk(VectorToTable(count), VectorToTable(id), VectorToTable(name), VectorToTable(icon), VectorToTable(priceCostGold), VectorToTable(desc), VectorToTable(itemMainType), VectorToTable(itemSubType), VectorToTable(param1), VectorToTable(param2), VectorToTable(tireValue), VectorToTable(consumePower), VectorToTable(specialAttackType), VectorToTable(specialAttackParam))
end

--@brief	获取道具列表成功
function ProtocolProcessorSceneBossBattle:parse_PLAYER_GetPropListOk(count, id, name, icon, priceCostGold, desc, itemMainType, itemSubType, param1, param2, tireValue, consumePower, specialAttackType, specialAttackParam)
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
	WZLog("ProtocolProcessorSceneBossBattle:parse_PLAYER_GetPropListOk")
	SceneBattleLoading:receiveGetPropListOk(VectorToTable(count), VectorToTable(id), VectorToTable(name), VectorToTable(icon), VectorToTable(priceCostGold), VectorToTable(desc), VectorToTable(itemMainType), VectorToTable(itemSubType), VectorToTable(param1), VectorToTable(param2), VectorToTable(tireValue), VectorToTable(consumePower), VectorToTable(specialAttackType), VectorToTable(specialAttackParam))
end

--@brief	获取角色技能列表成功
function ProtocolProcessorSceneBossBattle:parse_PLAYER_GetPlayerSkillOk(count, id, name, icon, priceCostGold, desc, itemMainType, itemSubType, param1, param2, tireValue, consumePower, specialAttackType, specialAttackParam)
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
	WZLog("ProtocolProcessorSceneBossBattle:parse_PLAYER_GetPlayerSkillOk")
	SceneBattleLoading:receiveGetPlayerSkillOk(VectorToTable(count), VectorToTable(id), VectorToTable(name), VectorToTable(icon), VectorToTable(priceCostGold), VectorToTable(desc), VectorToTable(itemMainType), VectorToTable(itemSubType), VectorToTable(param1), VectorToTable(param2), VectorToTable(tireValue), VectorToTable(consumePower), VectorToTable(specialAttackType), VectorToTable(specialAttackParam))
end

--@brief	获取角色道具列表成功
function ProtocolProcessorSceneBossBattle:parse_PLAYER_GetPlayerPropOk(count, id, name, icon, priceCostGold, desc, itemMainType, itemSubType, param1, param2, tireValue, consumePower, specialAttackType, specialAttackParam)
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
	WZLog("ProtocolProcessorSceneBossBattle:parse_PLAYER_GetPlayerPropOk")
	SceneBattleLoading:receiveGetPlayerPropOk(VectorToTable(count), VectorToTable(id), VectorToTable(name), VectorToTable(icon), VectorToTable(priceCostGold), VectorToTable(desc), VectorToTable(itemMainType), VectorToTable(itemSubType), VectorToTable(param1), VectorToTable(param2), VectorToTable(tireValue), VectorToTable(consumePower), VectorToTable(specialAttackType), VectorToTable(specialAttackParam))
end


--@brief	同步战斗对象位置信息(BOSSMAPBATTLE_OtherSynPosition = 64)
function ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_OtherSynPosition(battleId, combatId, positionX, positionY)
	-- battleId : 战斗id
	-- combatId : 成员id
	-- positionX : x坐标
	-- positionY : y坐标
	WZLog("ProtocolProcessorSceneBossBattle:parse_BOSSMAPBATTLE_OtherSynPosition")
	if not WBattleGlobal:getCurrent():isHostControl() then
		WBattleGlobal:getCurrent():updateBattleSynPosition(VectorToTable(combatId),IntVectorToFloatTable(positionX),IntVectorToFloatTable(positionY))
	end
end


--@brief	发送结算信息（WORLDBOSSHALL_SendSettlementInfo = 11）
--[[function ProtocolProcessorSceneBossBattle:parse_WORLDBOSSHALL_SendSettlementInfo(hurtValue, hurtRank, hurtPercent, isLastKillGift, isWin)
	-- hurtValue : 总伤害输出
	-- hurtRank : 输出排名
	-- hurtPercent : 伤害所占百分比
	-- isLastKillGift : 是否获得击杀礼包
	-- isWin : 是否赢了
	WZLog("ProtocolProcessorSceneBossBattle:parse_WORLDBOSSHALL_SendSettlementInfo")

    if WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_WORLDBOSS then
        ScenceBattleSettlment:receiveWorldBoss(hurtValue,hurtRank,hurtPercent,isLastKillGift,isWin)

        local msg = MsgManager:createMsg(BattleMsgGameOver)
        msg.m_bWin = isWin
        msg.m_bWorldEnd = true
        MsgManager:pushNonBlockMsg(msg)
    end
end]]

--@brief	战斗心跳错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBossBattle:send_SYSTEM_BattleShakeHands_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBossBattle:send_SYSTEM_BattleShakeHands_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SYSTEM, Protocol.SYSTEM_BattleShakeHands, nflag, sMessage)
end

--@brief	通知已经完成加载错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_FinishLoading_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_FinishLoading_ErrorProcess")
	MsgBoxManager:showTipBox(sMessage)
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPBATTLE_FinishLoading, nflag, sMessage)
end

--@brief	战斗操作结束错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_EndCurRound_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_EndCurRound_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPBATTLE_EndCurRound, nflag, sMessage)
end

--@brief	角色移动错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_PlayerMove_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_PlayerMove_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPBATTLE_PlayerMove, nflag, sMessage)
end

--@brief	使用技能和道具错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_SkillEquip_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_SkillEquip_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_SkillEquip, nflag, sMessage)
end

--@brief	使用大招错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_PetAttack_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_PetAttack_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_PetAttack, nflag, sMessage)
end

--@brief	发射错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_Shoot_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_Shoot_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_Shoot, nflag, sMessage)
end

--@brief	发射完成错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_Hurt_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_Hurt_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_Hurt, nflag, sMessage)
end

--@brief	飞行错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_Fly_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_Fly_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_Fly, nflag, sMessage)
end

--@brief	 被冰冻错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBossBattle:send_BATTLE_BeFrozen_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBossBattle:send_BATTLE_BeFrozen_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BATTLE, Protocol.BATTLE_BeFrozen, nflag, sMessage)
end

--@brief	跳过本轮操作错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_Pass_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_Pass_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_Pass, nflag, sMessage)
end

--@brief	返回房间错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBossBattle:send_BOSSMAPROOM_BackToRoom_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBossBattle:send_BOSSMAPROOM_BackToRoom_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_BackToRoom, nflag, sMessage)
    --WndMultiCopySettlement:backToRoomError(sMessage)
    if WndMultiWin.m_root then
        WndMultiWin:backToRoomError(sMessage)
    else
        WndMultiLose:backToRoomError(sMessage)
    end
end

--@brief	某角色掉出了场景错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_OutOfScene_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_OutOfScene_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_OutOfScene, nflag, sMessage)
end

--@brief	重生点错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_RebornPosition_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_RebornPosition_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_RebornPosition, nflag, sMessage)
end

--@brief	强制退出战斗错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_QuitBattle_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_QuitBattle_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_QuitBattle, nflag, sMessage)
end

--@brief	发送加载百份比错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_LoadingPercent_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_LoadingPercent_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_LoadingPercent, nflag, sMessage)
end

--@brief	发送使用的表情错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_UsingFace_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_UsingFace_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_UsingFace, nflag, sMessage)
end


--@brief	使用近距离攻击错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_NearAttack_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_NearAttack_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_NearAttack, nflag, sMessage)
end

--@brief	生成怪错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_BuildGuai_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_BuildGuai_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_BuildGuai, nflag, sMessage)
end

--@brief	请求怪物战斗id错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_RequestGuaiBattleId_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_RequestGuaiBattleId_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_RequestGuaiBattleId, nflag, sMessage)
end

--@brief	boss变身错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_BossChange_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_BossChange_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_BossChange, nflag, sMessage)
end

--@brief	抽奖错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_Reward_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_Reward_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_Reward, nflag, sMessage)
    MsgBoxManager:showTipBox(sMessage)
end

--@brief	改变位置错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_ChangePosition_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_ChangePosition_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_ChangePosition, nflag, sMessage)
end

--@brief	杀死怪协议错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_KillGuai_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_KillGuai_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_KillGuai, nflag, sMessage)
end

--@brief	发送玩家战斗属性错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_SendPlayerBattleAttribute_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_SendPlayerBattleAttribute_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_SendPlayerBattleAttribute, nflag, sMessage)
end

--@brief	获取宝箱信息错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_GetTreasureInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_GetTreasureInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_GetTreasureInfo, nflag, sMessage)
end

--@brief	与宝箱接触错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_TreasureContact_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_TreasureContact_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_TreasureContact, nflag, sMessage)
end

--@brief	请求同步客户端错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_RequestSynchroClients_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_RequestSynchroClients_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_RequestSynchroClients, nflag, sMessage)
end

--@brief	同步战斗对象位置信息(BOSSMAPBATTLE_SynPosition = 63)错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_SynPosition_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_SynPosition_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_SynPosition, nflag, sMessage)
end

--@brief	同步战斗信息错误处理错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_SynchronousBattleInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBattle:send_BATTLE_SynchronousBattleInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_SynchronousBattleInfo, nflag, "")

	MsgBoxManager:showConfirmBox(sMessage, SceneBattle, SceneBattle.leftBattle, MSGBOXLEVEL_NORMAL, nil, true)
end
