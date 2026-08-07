--ProtocolProcessorBattleInterface.lua
--@brief	战斗协议接口
--@date  	2013/12/10
--@author 	李光森
--@note


ProtocolProcessorBattleInterface = {
}

-------------------------------------公有方法模块--------------------------------------
--@brief	注册协议组所有协议
function ProtocolProcessorBattleInterface:regAll()
	if self:_getIsUseNormalProtocol() then
		ProtocolProcessorSceneBattle:regAll()
	else
		ProtocolProcessorSceneBossBattle:regAll()
	end
end

--@brief	反注册协议组所有协议
function ProtocolProcessorBattleInterface:unregAll()
	if self:_getIsUseNormalProtocol() then
		ProtocolProcessorSceneBattle:clearReg()
	else
		ProtocolProcessorSceneBossBattle:clearReg()
	end
end

--@brief	是否使用普通协议
function ProtocolProcessorBattleInterface:_getIsUseNormalProtocol()
	do return true end
	if WBattleGlobal:getCurrent():getBattleType() == BattleConstants.g_nBATTLE_TYPE_NORMAL then
		return true
	elseif WBattleGlobal:getCurrent():getBattleType() == BattleConstants.g_nBATTLE_TYPE_BOSS then
		return false
	end
end

-------------------------------------客户端到服务器协议发送方法模块--------------------------------------

--@brief	发送当前回合的信息
function ProtocolProcessorBattleInterface:send_BATTLE_SendCurRoundInfo(battleId, turn, playerIds, postionX, postionY, angle, face, explodePlayerId, explodeSkillId, explodePosX, explodePosY, battleInfo, explodeDirection)
	if WBattleGlobal:getCurrent():isReplayGame() then
		return
	end
	if WBattleGlobal:getCurrent():isRelink() or WBattleGlobal:getCurrent():isAudience() or WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle then WZLog("正在重连或观战或单人副本,不能发协议") return end
	if self:_getIsUseNormalProtocol() then
		ProtocolProcessorSceneBattle:send_BATTLE_SendCurRoundInfo(battleId, turn, playerIds, postionX, postionY, angle, face, explodePlayerId, explodeSkillId, explodePosX, explodePosY, battleInfo, explodeDirection)
	else
		ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_SendCurRoundInfo(battleId, turn, playerIds, postionX, postionY, angle, face, explodePlayerId, explodeSkillId, explodePosX, explodePosY, battleInfo, explodeDirection)
	end
end

--@brief	同步战斗信息
function ProtocolProcessorBattleInterface:send_BATTLE_SynchronousBattleInfo(battleId, playerId, scene )
	if WBattleGlobal:getCurrent():isReplayGame() then
		return
	end
	if self:_getIsUseNormalProtocol() then
		ProtocolProcessorSceneBattle:send_BATTLE_SynchronousBattleInfo(battleId, playerId, scene )
	else
		ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_SynchronousBattleInfo(battleId, playerId, scene )
	end
end

--@brief	战斗心跳
function ProtocolProcessorBattleInterface:send_SYSTEM_BattleShakeHands(battleId )
	if WBattleGlobal:getCurrent():isReplayGame() then
		return
	end
	if self:_getIsUseNormalProtocol() then
		ProtocolProcessorSceneBattle:send_SYSTEM_BattleShakeHands(battleId)
	else
		ProtocolProcessorSceneBossBattle:send_SYSTEM_BattleShakeHands(battleId)
	end
end

--@brief	开始新的战斗操作计时
function ProtocolProcessorBattleInterface:send_BATTLE_StartNewTimer(battleId, playerId )
	--WZLog("send_BATTLE_StartNewTimer")
	if WBattleGlobal:getCurrent():isReplayGame() then
		return
	end
	if WBattleGlobal:getCurrent():isRelink() or WBattleGlobal:getCurrent():isAudience() or WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle then WZLog("正在重连或观战或单人副本,不能发协议") return end
	ProtocolProcessorSceneBattle:send_BATTLE_StartNewTimer(battleId,playerId)
end

--@brief	战斗操作结束
function ProtocolProcessorBattleInterface:send_BATTLE_EndCurRound(battleId, playerId, playerIds, isHide, isFog, isPenetrate)
	--WZLog("send_BATTLE_EndCurRound")
	if WBattleGlobal:getCurrent():isReplayGame() then
		return
	end
	if WBattleGlobal:getCurrent():isRelink() or WBattleGlobal:getCurrent():isAudience() or WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle then WZLog("正在重连或观战或单人副本,不能发协议") return end
	if self:_getIsUseNormalProtocol() then
		ProtocolProcessorSceneBattle:send_BATTLE_EndCurRound(battleId, playerId, playerIds, isHide, isFog, isPenetrate)
	else
		ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_EndCurRound(battleId, playerId)
	end
end

--@brief	角色移动
function ProtocolProcessorBattleInterface:send_BATTLE_PlayerMove(battleId, playerId, movecount, movestep, curPositionX, curPositionY, moveSpeed, nPF)
	--WZLog("send_BATTLE_PlayerMove")
	if WBattleGlobal:getCurrent():isReplayGame() then
		return
	end
	if WBattleGlobal:getCurrent():isRelink() or WBattleGlobal:getCurrent():isAudience() or WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle then WZLog("正在重连或观战或单人副本,不能发协议") return end
	if self:_getIsUseNormalProtocol() then
		ProtocolProcessorSceneBattle:send_BATTLE_PlayerMove(battleId, playerId, movecount, movestep, curPositionX, curPositionY, moveSpeed, nPF)
	else
		ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_PlayerMove(battleId, playerId, movecount, movestep, curPositionX, curPositionY)
	end
end

--@brief	使用技能和道具
function ProtocolProcessorBattleInterface:send_BATTLE_SkillEquip(battleId, playerId, item_id, targetIds, param, uniqueId, copyPlayerId)
	--WZLog("send_BATTLE_SkillEquip")
	if WBattleGlobal:getCurrent():isReplayGame() then
		return
	end
	if WBattleGlobal:getCurrent():isRelink() or WBattleGlobal:getCurrent():isAudience() or WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle then 
		WZLog("正在重连或观战或单人副本,不能发协议") 
		local tSpatterAngle = GetRandomNum(20, 110, 70)
        WZLog("WndBattleHud:onSkill", Serialize(tSpatterAngle))
        WBattleGlobal:getCurrent():setCurSpatterAngle(tSpatterAngle)
		return 
	end
	local viPlayerId = WZLuaVector_int_:create()
	if targetIds then
		for i,v in pairs(targetIds) do
			WZLog("ProtocolProcessorBattleInterface:send_BATTLE_SkillEquip",v)
	        viPlayerId:push(v)
		end
	end

	if self:_getIsUseNormalProtocol() then
		param = param or ""
		ProtocolProcessorSceneBattle:send_BATTLE_SkillEquip(battleId, playerId, item_id, viPlayerId, param, uniqueId or 0, copyPlayerId or 0)
	else
		param = param or ""
		ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_SkillEquip(battleId, playerId, item_id, viPlayerId, param)
	end
end

--@brief	宠物攻击
function ProtocolProcessorBattleInterface:send_BATTLE_PetAttack(battleId, playerId, hurtPlayer, hurtValue )
	--WZLog("send_BATTLE_PetAttack")
	if WBattleGlobal:getCurrent():isReplayGame() then
		return
	end
	if WBattleGlobal:getCurrent():isRelink() or WBattleGlobal:getCurrent():isAudience() or WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle then WZLog("正在重连或观战或单人副本,不能发协议") return end
	if self:_getIsUseNormalProtocol() then
		ProtocolProcessorSceneBattle:send_BATTLE_PetAttack(battleId, playerId, hurtPlayer, hurtValue )
	else
		ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_PetAttack(battleId, playerId, hurtPlayer, hurtValue)
	end
end

--@brief	发射
function ProtocolProcessorBattleInterface:send_BATTLE_Shoot(battleId, playerId, speedx, speedy, leftRight, startX, startY, playerCount, playerIds, curPositionX, curPositionY, curPositionR, curPositionD, attackCount, linePointCount)
	WZLog("send_BATTLE_Shoot", battleId, playerId, speedx, speedy, leftRight, startX, startY, playerCount, playerIds, curPositionX, curPositionY, attackCount)
	if WBattleGlobal:getCurrent():isReplayGame() then
		return
	end
	if WBattleGlobal:getCurrent():isRelink() or WBattleGlobal:getCurrent():isAudience() or WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle then WZLog("正在重连或观战或单人副本,不能发协议") return end
    --attackCount = nil
	if self:_getIsUseNormalProtocol() then
		ProtocolProcessorSceneBattle:send_BATTLE_Shoot(battleId, playerId, speedx, speedy, leftRight, startX, startY, playerCount, playerIds, curPositionX, curPositionY, curPositionR, curPositionD, attackCount, linePointCount)
	else
		ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_Shoot(battleId, playerId, speedx, speedy, leftRight, startX, startY, playerCount, playerIds, curPositionX, curPositionY, curPositionR, curPositionD, attackCount)
	end
end

--@brief	发射完成
function ProtocolProcessorBattleInterface:send_BATTLE_Hurt(battleId, playerId, PlayerIds, hurtvalue, distance, superCritMark)
	if WBattleGlobal:getCurrent():isReplayGame() then
		return
	end
	WZLog("send_BATTLE_Hurt")
	if WBattleGlobal:getCurrent():isRelink() or WBattleGlobal:getCurrent():isAudience() or WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle then WZLog("正在重连或观战或单人副本,不能发协议") return end
	if WBattleGlobal:getCurrent():checkCheat() ~= true then
		if self:_getIsUseNormalProtocol() then
			ProtocolProcessorSceneBattle:send_BATTLE_Hurt(battleId, playerId, PlayerIds, hurtvalue, distance, superCritMark)
		else
			ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_Hurt(battleId, playerId, PlayerIds, hurtvalue, distance, superCritMark)
		end
	end
end

--@brief	飞行
function ProtocolProcessorBattleInterface:send_BATTLE_Fly(battleId, playerId, speedx, speedy, leftRight, isEquip, startX, startY, playerCount, playerIds, curPositionX, curPositionY)
	--WZLog("send_BATTLE_Fly")
	if WBattleGlobal:getCurrent():isReplayGame() then
		return
	end
	if WBattleGlobal:getCurrent():isRelink() or WBattleGlobal:getCurrent():isAudience() or WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle then WZLog("正在重连或观战或单人副本,不能发协议") return end
	if self:_getIsUseNormalProtocol() then
		ProtocolProcessorSceneBattle:send_BATTLE_Fly(battleId, playerId, speedx, speedy, leftRight, isEquip, startX, startY, playerCount, playerIds, curPositionX, curPositionY)
	else
		ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_Fly(battleId, playerId, speedx, speedy, leftRight, isEquip, startX, startY, playerCount, playerIds, curPositionX, curPositionY)
	end
end

--@brief	跳过本轮操作
function ProtocolProcessorBattleInterface:send_BATTLE_Pass(battleId, playerId)
	--WZLog("send_BATTLE_Pass")
	if WBattleGlobal:getCurrent():isReplayGame() then
		return
	end
	if WBattleGlobal:getCurrent():isRelink() or WBattleGlobal:getCurrent():isAudience() or WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle then WZLog("正在重连或观战或单人副本,不能发协议") return end
	if self:_getIsUseNormalProtocol() then
		ProtocolProcessorSceneBattle:send_BATTLE_Pass(battleId, playerId )
	else
		ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_Pass(battleId, playerId )
	end
end

--@brief	返回房间
function ProtocolProcessorBattleInterface:send_BATTLE_BackToRoom(roomId )
	WZLog("send_BATTLE_BackToRoom")
	if WBattleGlobal:getCurrent():isReplayGame() then
		return
	end
	if WBattleGlobal:getCurrent():isRelink() or WBattleGlobal:getCurrent():isAudience() then WZLog("正在重连或观战或单人副本,不能发协议") return end
	

	if WBattleGlobal:getCurrent():getBattleType() == BattleConstants.g_nBATTLE_TYPE_NORMAL then
		ProtocolProcessorSceneBattle:send_BATTLE_BackToRoom(roomId )
	elseif WBattleGlobal:getCurrent():getBattleType() == BattleConstants.g_nBATTLE_TYPE_BOSS then
		ProtocolProcessorSceneBattle:send_BOSSMAPROOM_BackToRoom(roomId,WBattleGlobal:getCurrent().m_tMakePairOk.mapId )
	end

	
end

--@brief	重生点
function ProtocolProcessorBattleInterface:send_BATTLE_RebornPosition(battleId, playerId, playercount, PlayerIds, postionX, postionY)
	--WZLog("send_BATTLE_RebornPosition")
	if WBattleGlobal:getCurrent():isReplayGame() then
		return
	end
	if WBattleGlobal:getCurrent():isRelink() or WBattleGlobal:getCurrent():isAudience() or WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle then WZLog("正在重连或观战或单人副本,不能发协议") return end
	if self:_getIsUseNormalProtocol() then
		ProtocolProcessorSceneBattle:send_BATTLE_RebornPosition(battleId, playerId, playercount, PlayerIds, postionX, postionY )
	else
		ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_RebornPosition(battleId, playercount, PlayerIds, postionX, postionY )
	end
end

--@brief	某角色掉出了场景
function ProtocolProcessorBattleInterface:send_BATTLE_OutOfScene(battleId, playerId ,currentPlayerId)
	--WZLog("send_BATTLE_OutOfScene")
	if WBattleGlobal:getCurrent():isReplayGame() then
		return
	end
	if WBattleGlobal:getCurrent():isRelink() or WBattleGlobal:getCurrent():isAudience() or WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle then WZLog("正在重连或观战或单人副本,不能发协议") return end
	if self:_getIsUseNormalProtocol() then
		ProtocolProcessorSceneBattle:send_BATTLE_OutOfScene(battleId, playerId ,currentPlayerId)
	else
		ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_OutOfScene(battleId, playerId, currentPlayerId)
	end
end

--@brief	强制退出战斗
function ProtocolProcessorBattleInterface:send_BATTLE_QuitBattle(battleId, playerId )
	--WZLog("send_BATTLE_QuitBattle")
	if WBattleGlobal:getCurrent():isReplayGame() then
		return
	end
	if WBattleGlobal:getCurrent():isRelink() or WBattleGlobal:getCurrent():isAudience() then WZLog("正在重连或观战或单人副本,不能发协议") return end
	if self:_getIsUseNormalProtocol() then
		ProtocolProcessorSceneBattle:send_BATTLE_QuitBattle(battleId, playerId )
	else
		ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_QuitBattle(battleId, playerId )
	end
end

--@brief	发送使用的表情
function ProtocolProcessorBattleInterface:send_BATTLE_UsingFace(battleId, playerId, faceId, playerOrGuai )
	--WZLog("send_BATTLE_UsingFace")
	if WBattleGlobal:getCurrent():isReplayGame() then
		return
	end
	if WBattleGlobal:getCurrent():isAudience() or WBattleGlobal:getCurrent():isSingleStage() then WZLog("正在重连或观战或单人副本,不能发协议") return end
	if self:_getIsUseNormalProtocol() then
		ProtocolProcessorSceneBattle:send_BATTLE_UsingFace(battleId, playerId, faceId )
	else
		ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_UsingFace(battleId, playerId, faceId )
	end
end

--@brief	发送玩家战斗属性
function ProtocolProcessorBattleInterface:send_BATTLE_SendPlayerBattleAttribute(battleId, playerId, hp, pf, angry, hpMax, pfMax, angryMax, attack, defend, BigSkillAttack )
	--WZLog("send_BATTLE_SendPlayerBattleAttribute")
	if WBattleGlobal:getCurrent():isReplayGame() then
		return
	end
	if WBattleGlobal:getCurrent():isRelink() or WBattleGlobal:getCurrent():isAudience() or WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle then WZLog("正在重连或观战或单人副本,不能发协议") return end
	if self:_getIsUseNormalProtocol() then
		ProtocolProcessorSceneBattle:send_BATTLE_SendPlayerBattleAttribute(battleId, playerId, hp, pf, angry, hpMax, pfMax, angryMax, attack, defend, BigSkillAttack )
	else
		ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_SendPlayerBattleAttribute(battleId, playerId, hp, pf, angry, hpMax, pfpMax, angryMax, attack, defend, BigSkillAttack )
	end
end

--@brief	通知已经开始加载
function ProtocolProcessorBattleInterface:send_BATTLE_StartLoading(battleId, playerId )
	--WZLog("send_BATTLE_StartLoading")
	if WBattleGlobal:getCurrent():isReplayGame() then
		return
	end
	if WBattleGlobal:getCurrent():isRelink() or WBattleGlobal:getCurrent():isAudience() or WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle then WZLog("正在重连或观战或单人副本,不能发协议") return end
	if self:_getIsUseNormalProtocol() then
		ProtocolProcessorSceneBattle:send_BATTLE_StartLoading(battleId, playerId)
	else
		ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_StartLoading(battleId, playerId)
	end

end

--@brief	发送加载百份比
function ProtocolProcessorBattleInterface:send_BATTLE_LoadingPercent(battleId, currentPlayerId, percent)
	WZLog("send_BATTLE_LoadingPercent",battleId, currentPlayerId, percent)
	if WBattleGlobal:getCurrent():isReplayGame() then
		return
	end
	if WBattleGlobal:getCurrent():isRelink() or WBattleGlobal:getCurrent():isAudience() or WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle then WZLog("正在重连或观战或单人副本,不能发协议") return end
	playerOrGuai = playerOrGuai or 0
	if self:_getIsUseNormalProtocol() then
		ProtocolProcessorSceneBattle:send_BATTLE_LoadingPercent(battleId, currentPlayerId, percent)
	else
		ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_LoadingPercent(battleId,currentPlayerId,percent)
	end
end

--@brief	提交地图可选择的出现位置给服务器
function ProtocolProcessorBattleInterface:send_BATTLE_PositionsInMap(battleId, postionCount, postionX, postionY,playerId )
	--WZLog("send_BATTLE_PositionsInMap")
	if WBattleGlobal:getCurrent():isReplayGame() then
		return
	end
	if WBattleGlobal:getCurrent():isRelink() or WBattleGlobal:getCurrent():isAudience() or WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle then WZLog("正在重连或观战或单人副本,不能发协议") return end
	if self:_getIsUseNormalProtocol() then
		ProtocolProcessorSceneBattle:send_BATTLE_PositionsInMap(battleId, playerId, postionCount, postionX, postionY)
    else
        ProtocolProcessorSceneBattle:send_BATTLE_PositionsInMap(battleId, postionCount, postionX, postionY)
	end
end

--@brief	获得提示语
function ProtocolProcessorBattleInterface:send_BATTLE_GetTips( )
	--WZLog("send_BATTLE_GetTips")
	if WBattleGlobal:getCurrent():isReplayGame() then
		return
	end
	if WBattleGlobal:getCurrent():isRelink() or WBattleGlobal:getCurrent():isAudience() then WZLog("正在重连或观战或单人副本,不能发协议") return end
	if self:_getIsUseNormalProtocol() then
		ProtocolProcessorSceneBattle:send_BATTLE_GetTips()
	else
		ProtocolProcessorSceneBossBattle:send_BATTLE_GetTips()
	end
end

--@brief	通知已经完成加载
function ProtocolProcessorBattleInterface:send_BATTLE_FinishLoading(battleId, playerId )
	WZLog("send_BATTLE_FinishLoading")
	if WBattleGlobal:getCurrent():isReplayGame() then
		return
	end
	if WBattleGlobal:getCurrent():isRelink() or WBattleGlobal:getCurrent():isAudience() or WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle then WZLog("正在重连或观战或单人副本,不能发协议") return end
	if self:_getIsUseNormalProtocol() then
		ProtocolProcessorSceneBattle:send_BATTLE_FinishLoading(battleId, playerId)
	else
		ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_FinishLoading(battleId, playerId)
	end
end

--@brief	获取技能列表
function ProtocolProcessorBattleInterface:send_PLAYER_GetSkillList( )
	--WZLog("send_PLAYER_GetSkillList")
	if WBattleGlobal:getCurrent():isReplayGame() then
		return
	end
	if WBattleGlobal:getCurrent():isRelink() or WBattleGlobal:getCurrent():isAudience() or WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle then WZLog("正在重连或观战或单人副本,不能发协议") return end
	if self:_getIsUseNormalProtocol() then
		ProtocolProcessorSceneBattle:send_PLAYER_GetSkillList()
	else
		ProtocolProcessorSceneBossBattle:send_PLAYER_GetSkillList()
	end
end

--@brief	获取道具列表
function ProtocolProcessorBattleInterface:send_PLAYER_GetPropList( )
	--WZLog("send_PLAYER_GetPropList")
	if WBattleGlobal:getCurrent():isReplayGame() then
		return
	end
	if WBattleGlobal:getCurrent():isRelink() or WBattleGlobal:getCurrent():isAudience() or WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle then WZLog("正在重连或观战或单人副本,不能发协议") return end
	if self:_getIsUseNormalProtocol() then
		ProtocolProcessorSceneBattle:send_PLAYER_GetPropList()
	else
		ProtocolProcessorSceneBossBattle:send_PLAYER_GetPropList()
	end
end

--@brief	获取玩家技能
function ProtocolProcessorBattleInterface:send_PLAYER_GetPlayerSkill( )
	--WZLog("send_PLAYER_GetPlayerSkill")
	if WBattleGlobal:getCurrent():isReplayGame() then
		return
	end
	if WBattleGlobal:getCurrent():isRelink() or WBattleGlobal:getCurrent():isAudience() or WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle then WZLog("正在重连或观战或单人副本,不能发协议") return end
	if self:_getIsUseNormalProtocol() then
		ProtocolProcessorSceneBattle:send_PLAYER_GetPlayerSkill()
	else
		ProtocolProcessorSceneBossBattle:send_PLAYER_GetPlayerSkill()
	end
end

--@brief	获取玩家道具
function ProtocolProcessorBattleInterface:send_PLAYER_GetPlayerProp( )
	--WZLog("send_PLAYER_GetPlayerProp")
	if WBattleGlobal:getCurrent():isReplayGame() then
		return
	end
	if WBattleGlobal:getCurrent():isRelink() or WBattleGlobal:getCurrent():isAudience() or WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle then WZLog("正在重连或观战或单人副本,不能发协议") return end
	if self:_getIsUseNormalProtocol() then
		ProtocolProcessorSceneBattle:send_PLAYER_GetPlayerProp()
	else
		ProtocolProcessorSceneBossBattle:send_PLAYER_GetPlayerProp()
	end
end

--@brief	玩家触碰特殊事件
function ProtocolProcessorBattleInterface:send_BATTLE_EventContact(battleId, playerId, eventId )
	--WZLog("ProtocolProcessorBattleInterface:send_BATTLE_EventContact")
	if WBattleGlobal:getCurrent():isReplayGame() then
		return
	end
	if WBattleGlobal:getCurrent():isRelink() or WBattleGlobal:getCurrent():isAudience() or WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle then WZLog("正在重连或观战或单人副本,不能发协议") return end
	if self:_getIsUseNormalProtocol() then
		ProtocolProcessorSceneBattle:send_BATTLE_EventContact(battleId, playerId, eventId )
	end
end

--@brief	宠物反击
--@nate 	宠物反击(BATTLE_PetCounterAttack = 18)【160新增】
function ProtocolProcessorBattleInterface:send_BATTLE_PetCounterAttack(battleId, playerId, hurtPlayer, hurtValue )
	--WZLog("send_BATTLE_PetCounterAttack")
	if WBattleGlobal:getCurrent():isReplayGame() then
		return
	end
	if WBattleGlobal:getCurrent():isRelink() or WBattleGlobal:getCurrent():isAudience() or WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle then WZLog("正在重连或观战或单人副本,不能发协议") return end

	ProtocolProcessorSceneBattle:send_BATTLE_PetCounterAttack(battleId, playerId, hurtPlayer, hurtValue )
end
----------------------------------------------------------副本独有--------------------------------------------------------

--@brief	使用近距离攻击
function ProtocolProcessorBattleInterface:send_BATTLE_NearAttack(battleId, currentId, leftRight )
	if WBattleGlobal:getCurrent():isReplayGame() then
		return
	end
	if WBattleGlobal:getCurrent():isRelink() or WBattleGlobal:getCurrent():isAudience() or WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle then WZLog("正在重连或观战或单人副本,不能发协议") return end
	
	ProtocolProcessorSceneBattle:send_BOSSMAPBATTLE_NearAttack(battleId, currentId, leftRight )
end

--@brief	生成怪
function ProtocolProcessorBattleInterface:send_BATTLE_BuildGuai(battleId, currentId, guaiId, guaiPositionX, guaiPositionY, ghostPlayerId)
	if WBattleGlobal:getCurrent():isReplayGame() then
		return
	end
	if WBattleGlobal:getCurrent():isRelink() or WBattleGlobal:getCurrent():isAudience() or WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle then WZLog("正在重连或观战或单人副本,不能发协议") return end
		
	ProtocolProcessorSceneBattle:send_BATTLE_BuildGuai(battleId, currentId,  guaiId, guaiPositionX, guaiPositionY, ghostPlayerId)
	
end

--@brief	请求怪物战斗id
function ProtocolProcessorBattleInterface:send_BATTLE_RequestGuaiBattleId(battleId, count )
	if WBattleGlobal:getCurrent():isReplayGame() then
		return
	end
	if WBattleGlobal:getCurrent():isRelink() or WBattleGlobal:getCurrent():isAudience() or WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle then WZLog("正在重连或观战或单人副本,不能发协议") return end
	
	ProtocolProcessorSceneBattle:send_BOSSMAPBATTLE_RequestGuaiBattleId(battleId, count)
end

--@brief	boss变身
function ProtocolProcessorBattleInterface:send_BATTLE_BossChange(battleId, guaiBattleId, guaiOldId, guaiNewId )
	if WBattleGlobal:getCurrent():isReplayGame() then
		return
	end
	if WBattleGlobal:getCurrent():isRelink() or WBattleGlobal:getCurrent():isAudience() or WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle then WZLog("正在重连或观战或单人副本,不能发协议") return end
	if not self:_getIsUseNormalProtocol() then
		ProtocolProcessorSceneBattle:send_BOSSMAPBATTLE_BossChange(battleId, guaiBattleId, guaiOldId, guaiNewId)
	end
end

--@brief	抽奖
function ProtocolProcessorBattleInterface:send_BATTLE_Reward( )
	if WBattleGlobal:getCurrent():isReplayGame() then
		return
	end
	if WBattleGlobal:getCurrent():isRelink() or WBattleGlobal:getCurrent():isAudience() or WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle then WZLog("正在重连或观战或单人副本,不能发协议") return end
	ProtocolProcessorSceneBattle:send_BOSSMAPBATTLE_Reward()
end

--@brief	改变位置
function ProtocolProcessorBattleInterface:send_BATTLE_ChangePosition(battleId, currentId, playerCount, playerIds, curPositionX, curPositionY, guaiCount, guaiBattleIds, guaiCurPositionX, guaiCurPositionY )
	if WBattleGlobal:getCurrent():isReplayGame() then
		return
	end
	if WBattleGlobal:getCurrent():isRelink() or WBattleGlobal:getCurrent():isAudience() or WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle then WZLog("正在重连或观战或单人副本,不能发协议") return end
	ProtocolProcessorSceneBattle:send_BOSSMAPBATTLE_ChangePosition(battleId, currentId, playerCount, playerIds, curPositionX, curPositionY, guaiCount, guaiBattleIds, guaiCurPositionX, guaiCurPositionY )
end

--@brief	杀死怪协议
function ProtocolProcessorBattleInterface:send_BATTLE_KillGuai(battleId, guaiBattleIds )
	if WBattleGlobal:getCurrent():isReplayGame() then
		return
	end
	if WBattleGlobal:getCurrent():isRelink() or WBattleGlobal:getCurrent():isAudience() or WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle then WZLog("正在重连或观战或单人副本,不能发协议") return end
		ProtocolProcessorSceneBattle:send_BOSSMAPBATTLE_KillGuai(battleId, guaiBattleIds )
end

--@brief	获取宝箱信息
function ProtocolProcessorBattleInterface:send_BATTLE_GetTreasureInfo(battleId )
	if WBattleGlobal:getCurrent():isReplayGame() then
		return
	end
	if WBattleGlobal:getCurrent():isRelink() or WBattleGlobal:getCurrent():isAudience() or WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle then WZLog("正在重连或观战或单人副本,不能发协议") return end
    ProtocolProcessorSceneBattle:send_BOSSMAPBATTLE_GetTreasureInfo(battleId)
end

--@brief	与宝箱接触
function ProtocolProcessorBattleInterface:send_BATTLE_TreasureContact(battleId, playerOrGuai, currentId, item_count, item_id )
    WZLog("ProtocolProcessorBattleInterface:send_BATTLE_TreasureContact")
    if WBattleGlobal:getCurrent():isReplayGame() then
		return
	end
    if WBattleGlobal:getCurrent():isRelink() or WBattleGlobal:getCurrent():isAudience() or WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle then WZLog("正在重连或观战或单人副本,不能发协议") return end
    ProtocolProcessorSceneBattle:send_BOSSMAPBATTLE_TreasureContact(battleId, playerOrGuai, currentId, item_count, item_id )
end

--@brief	请求同步客户端
function ProtocolProcessorBattleInterface:send_BATTLE_RequestSynchroClients(battleId, currentId, state, parameter )
    WZLog("ProtocolProcessorBattleInterface:send_BATTLE_RequestSynchroClients")
    if WBattleGlobal:getCurrent():isReplayGame() then
		return
	end
	if WBattleGlobal:getCurrent():isRelink() or WBattleGlobal:getCurrent():isAudience() or WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle then WZLog("正在重连或观战或单人副本,不能发协议") return end
		
	ProtocolProcessorSceneBattle:send_BOSSMAPBATTLE_RequestSynchroClients(battleId, currentId, state, parameter )
end

--@brief 同步战斗对象位置
function ProtocolProcessorBattleInterface:send_BOSSMAPBATTLE_SynPosition(battleId, combatId, positionX, positionY)
	if WBattleGlobal:getCurrent():isReplayGame() then
		return
	end
	if WBattleGlobal:getCurrent():isRelink() or WBattleGlobal:getCurrent():isAudience() or WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle then WZLog("正在重连或观战或单人副本,不能发协议") return end
	
	ProtocolProcessorSceneBattle:send_BOSSMAPBATTLE_SynPosition(battleId, combatId, positionX, positionY)
end

--@brief	创建孩子（BATTLE_BuildChild = 120）
function ProtocolProcessorBattleInterface:send_BATTLE_BuildChild(battleId, currentId, positionX, positionY)
	WZLog("ProtocolProcessorBattleInterface:send_BATTLE_BuildChild")
    if WBattleGlobal:getCurrent():isReplayGame() then
		return
	end
	if WBattleGlobal:getCurrent():isRelink() or WBattleGlobal:getCurrent():isAudience() or WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle then WZLog("正在重连或观战或单人副本,不能发协议") return end
	
	ProtocolProcessorSceneBattle:send_BATTLE_BuildChild(battleId, currentId, positionX, positionY)
end

--@brief	触碰孩子（BATTLE_HitChild = 122）
function ProtocolProcessorBattleInterface:send_BATTLE_HitChild(battleId, playerId, childId)
	WZLog("ProtocolProcessorBattleInterface:send_BATTLE_HitChild")
    if WBattleGlobal:getCurrent():isReplayGame() then
		return
	end
	if WBattleGlobal:getCurrent():isRelink() or WBattleGlobal:getCurrent():isAudience() or WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle then WZLog("正在重连或观战或单人副本,不能发协议") return end
	
	ProtocolProcessorSceneBattle:send_BATTLE_HitChild(battleId, playerId, childId)
end