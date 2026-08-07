--ProtocolProcessorSceneWorldBoss.lua
--@brief	世界BOSS相关协议
--@date  	2014/2/11
--@author 	liangguang_long
--@note 	世界BOSS相关协议


ProtocolProcessorSceneWorldBoss = ProtocolProcessorBase:new()

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorSceneWorldBoss:regAll()
	--@brief	发送开启状态
	self:regProtocolCallbackFunction( Protocol.MAIN_WORLDBOSS, Protocol.WORLDBOSS_SendOpenState, "ProtocolProcessorSceneWorldBoss:parse_WORLDBOSS_SendOpenState", "vivbvivi")
	--@brief	获取房间状态成功	
	self:regProtocolCallbackFunction( Protocol.MAIN_WORLDBOSS, Protocol.WORLDBOSS_GetRoomStateOk, "ProtocolProcessorSceneWorldBoss:parse_WORLDBOSS_GetRoomStateOk", "iiivivsviiiiiiiiiii")
	--@brief	开始战斗失败	
	self:regProtocolCallbackFunction( Protocol.MAIN_WORLDBOSS, Protocol.WORLDBOSS_MakePairFail , "ProtocolProcessorSceneWorldBoss:parse_WORLDBOSS_MakePairFail ", "")
	--@brief	开始战斗成功
	self:regProtocolCallbackFunction( Protocol.MAIN_WORLDBOSS, Protocol.WORLDBOSS_MakePairOK , "ProtocolProcessorSceneWorldBoss:parse_WORLDBOSS_MakePairOk", "iiivivsvsvsvivivivivivivivivivivivivivivivivivivivivivivivsvivivsvivivivivivivivnvivivi")
	--@brief	发送结算信息	
	self:regProtocolCallbackFunction( Protocol.MAIN_WORLDBOSS, Protocol.WORLDBOSS_SendSettlementInfo, "ProtocolProcessorSceneWorldBoss:parse_WORLDBOSS_SendSettlementInfo", "iiibis")
    --@brief	获取房间状态错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_WORLDBOSS, Protocol.WORLDBOSS_GetRoomState, "ProtocolProcessorSceneWorldBoss:send_WORLDBOSS_GetRoomState_ErrorProcess", "is" )
    --@brief	清除冷却时间错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_WORLDBOSS, Protocol.WORLDBOSS_Accelerate, "ProtocolProcessorSceneWorldBoss:send_WORLDBOSS_Accelerate_ErrorProcess", "is" )
    --@brief	鼓舞错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_WORLDBOSS, Protocol.WORLDBOSS_Inspire, "ProtocolProcessorSceneWorldBoss:send_WORLDBOSS_Inspire_ErrorProcess", "is" )
end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorSceneWorldBoss:unregAll()
    WZLog("ProtocolProcessorSceneWorldBoss:unregAll")
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块--------------------------------------

--@brief	获取开启状态
function ProtocolProcessorSceneWorldBoss:send_WORLDBOSSHALL_GetOpenState( )
	WZLog("send_WORLDBOSSHALL_GetOpenState")
	local sender = Protocol:getSender( Protocol.MAIN_WORLDBOSS, Protocol.WORLDBOSS_GetOpenState )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end


--@brief	获取房间状态
function ProtocolProcessorSceneWorldBoss:send_WORLDBOSS_GetRoomState(mapId )
	WZLog("send_WORLDBOSS_GetRoomState")
	local sender = Protocol:getSender( Protocol.MAIN_WORLDBOSS, Protocol.WORLDBOSS_GetRoomState )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( mapId )	-- boss地图Id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	清除冷却时间
function ProtocolProcessorSceneWorldBoss:send_WORLDBOSS_Accelerate(mapId )
	WZLog("send_WORLDBOSS_Accelerate")
	local sender = Protocol:getSender( Protocol.MAIN_WORLDBOSS, Protocol.WORLDBOSS_Accelerate )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( mapId )	-- boss地图Id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	鼓舞
function ProtocolProcessorSceneWorldBoss:send_WORLDBOSS_Inspire(mapId, iType )
	WZLog("send_WORLDBOSS_Inspire")
	local sender = Protocol:getSender( Protocol.MAIN_WORLDBOSS, Protocol.WORLDBOSS_Inspire )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( mapId )	-- boss地图Id
	sender:writeByte( iType )	-- 鼓舞类型（1钻石，2金币）
	SendProtocol(sender,false) --true:showLoading
end

--@brief	开始战斗
function ProtocolProcessorSceneWorldBoss:send_WORLDBOSS_MakePair(mapId )
	WZLog("send_WORLDBOSS_MakePair", mapId)
	local sender = Protocol:getSender( Protocol.MAIN_WORLDBOSS, Protocol.WORLDBOSS_MakePair )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( mapId )	-- boss地图Id
	SendProtocol(sender,false) --true:showLoading
end

-------------------------------------服务器到客户端协议回调方法模块--------------------------------------
--@brief	发送开启状态
function ProtocolProcessorSceneWorldBoss:parse_WORLDBOSS_SendOpenState(mapId, state, time, overTime)
	-- mapId : boss地图Id
	-- state : 是否开启
	-- time : 开启时间(秒)
	-- overTiem : 结束时间
	WZLog("ProtocolProcessorSceneWorldBoss:parse_WORLDBOSS_SendOpenState")
	if WndWorldBoss.m_root then
		WndWorldBoss:setRoomOpenState(VectorToTable(mapId), VectorToTable(state), VectorToTable(time))
	elseif WndChallengeEntrance.m_root then
		WndChallengeEntrance:setRoomOpenState(VectorToTable(mapId), VectorToTable(state), VectorToTable(time), VectorToTable(overTime))
	end
end


--@brief	获取房间状态成功	
function ProtocolProcessorSceneWorldBoss:parse_WORLDBOSS_GetRoomStateOk(mapId, bossBloodMax, bossBloodCurrent,rankPlayerId, rankPlayerName, rankHurt, hurt, cdTime, accelerateCost, inspire, bossLevel, myRank, dimaCDTime, goldCDTime,bossState,openTime)
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
	WZLog("ProtocolProcessorSceneWorldBoss:parse_WORLDBOSS_GetRoomStateOk")
    GlobalGame.g_nWorldBossInspire = inspire
    if SceneWorldBoss.m_root then
		SceneWorldBoss:setEnterRoomData( mapId, bossBloodMax, bossBloodCurrent,rankPlayerId, rankPlayerName, rankHurt, hurt, cdTime, accelerateCost, inspire, bossLevel, myRank, dimaCDTime, goldCDTime,bossState,openTime)
	elseif WndChallengeEntrance.m_root then
		WndChallengeEntrance:getTime(openTime)
	end
end

--@brief	开始战斗失败	
function ProtocolProcessorSceneWorldBoss:parse_WORLDBOSS_MakePairFail ()
	WZLog("ProtocolProcessorSceneWorldBoss:parse_WORLDBOSS_MakePairFail ")
end

--@brief	开始战斗成功
function ProtocolProcessorSceneWorldBoss:parse_WORLDBOSS_MakePairOk(battleId, mapId, playerCount, playerId, playerName, 
	playerTitle, playerGuild, playerLevel, playerSex, maxHP, maxPF, maxSP, attack, critRate, defence, injuryFree, 
	wreckDefense, reduceCrit, power, armor, constitution, agility, lucky, insptre, headId, faceId, bodyId, weaponId, 
	wingId, item_id, petSkill, playerBuffCount, buffId, petId, petParam, guaiBattleId, guaiId, guaiMaxHP, guaiNowHP,
	guaiAtk,guaiLv,petLevel, colour, bodyColour,footmark)
	-- battleId : 战斗组Id
	-- mapId : 地图id
	-- playerCount : 玩家数量
	-- playerId : 所有玩家id
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
	-- headId : 头ID
	-- faceId : 脸ID
	-- bodyId : 身ID
	-- weaponId : 武器ID
	-- wingId : 翅膀ID
	-- item_id : 技能道具ID（0没装备，-1锁, 其他ID）
	-- playerBuffCount : 表示每一个player,buff的数量,如果没有要填零
	-- buffId : 玩家BUFFID
	-- petId : 宠物id，0表示无宠物
	-- petSkill : 宠物技能id
	-- petSkillId : 宠物技能id（每个宠物固定两个技能没有则填0）
	-- petParam : 宠物属性参数
	-- guaiBattleId : BOSS的战斗ID
	-- guaiId : BOSS怪表中的id
	-- guaiMaxHP : BOSS最大血量
	-- guaiNowHP : BOSS当前血量
	-- guaiAtk	:	boss攻击力
	-- guaiLv	:	boss等级
	WZLog("ProtocolProcessorSceneWorldBoss:parse_WORLDBOSS_MakePairOk ",battleId, mapId, playerCount, Serialize(VectorToTable(playerId)), Serialize(VectorToTable(playerName)), Serialize(VectorToTable(playerTitle)), Serialize(VectorToTable(playerGuild)), Serialize(VectorToTable(playerLevel)), Serialize(VectorToTable(playerSex)), Serialize(VectorToTable(maxHP)), Serialize(VectorToTable(maxPF)), Serialize(VectorToTable(maxSP)),"\nattack\n", Serialize(VectorToTable(attack)), Serialize(VectorToTable(critRate)), Serialize(VectorToTable(defence)), Serialize(VectorToTable(injuryFree)), Serialize(VectorToTable(wreckDefense)), Serialize(VectorToTable(reduceCrit)), Serialize(VectorToTable(power)), Serialize(VectorToTable(armor)), Serialize(VectorToTable(constitution)), Serialize(VectorToTable(agility)), Serialize(VectorToTable(lucky)), Serialize(VectorToTable(insptre)), Serialize(VectorToTable(headId)), Serialize(VectorToTable(faceId)), Serialize(VectorToTable(bodyId)), Serialize(VectorToTable(weaponId)), Serialize(VectorToTable(wingId)), "\nitem_id\n", Serialize(VectorToTable(item_id)), Serialize(VectorToTable(playerBuffCount)), Serialize(VectorToTable(buffId)), Serialize(VectorToTable(petId)), Serialize(VectorToTable(petParam)), "\nguaiBattleId\n", Serialize(VectorToTable(guaiBattleId)), Serialize(VectorToTable(guaiId)), Serialize(VectorToTable(guaiMaxHP)), Serialize(VectorToTable(guaiNowHP)), VectorToTable(weaponSkill),
        "\npetLevel:", Serialize(VectorToTable(petLevel)))

	SceneWorldBoss:receiveStartOk(battleId, mapId, playerCount,VectorToTable(playerId), VectorToTable(playerName), VectorToTable(playerTitle), VectorToTable(playerGuild), VectorToTable(playerLevel), VectorToTable(playerSex), VectorToTable(maxHP), VectorToTable(maxPF), VectorToTable(maxSP), VectorToTable(attack), VectorToTable(critRate), VectorToTable(defence), VectorToTable(injuryFree), VectorToTable(wreckDefense), VectorToTable(reduceCrit), VectorToTable(power), VectorToTable(armor), VectorToTable(constitution), VectorToTable(agility), VectorToTable(lucky), VectorToTable(insptre),VectorToTable(headId), VectorToTable(faceId), VectorToTable(bodyId), VectorToTable(weaponId), VectorToTable(wingId), VectorToTable(item_id), VectorToTable(playerBuffCount), VectorToTable(buffId), VectorToTable(petId), VectorToTable(petSkill), VectorToTable(petParam), VectorToTable(guaiBattleId), VectorToTable(guaiId), VectorToTable(guaiMaxHP), VectorToTable(guaiNowHP),VectorToTable(guaiAtk),VectorToTable(guaiLv), VectorToTable(weaponSkill), VectorToTable(petLevel),VectorToTable(colour),VectorToTable(bodyColour),VectorToTable(footmark))
end


--@brief	发送结算信息	
function ProtocolProcessorSceneWorldBoss:parse_WORLDBOSS_SendSettlementInfo(hurtValue, hurtRank, hurtPercent, isWin, killerId, killerName)
	-- hurtValue : 总伤害输出
	-- hurtRank : 输出排名
	-- hurtPercent : 伤害所占百分比
	-- isWin : 是否赢了
	-- killerId : 击杀玩家id
	-- killerName : 击杀玩家名称
	WZLog("ProtocolProcessorSceneWorldBoss:parse_WORLDBOSS_SendSettlementInfo",hurtValue, hurtRank, hurtPercent, isWin, killerId, killerName)
    local data = {bossId = g_selectWorldBossId,
        isWin = isWin, hurtValue = hurtValue, hurtRank = hurtRank, killerName = killerName,killerId = killerId,hurtPercent = hurtPercent }
    if SceneWorldBoss.m_root then
        WndWorldBossEnd:showWnd( data ,false)
    end
end

-------------------------------------协议错误处理方法模块--------------------------------------

--@brief	获取开启状态错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneWorldBoss:send_WORLDBOSSHALL_GetOpenState_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneWorldBoss:send_WORLDBOSSHALL_GetOpenState_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WORLDBOSSHALL, Protocol.WORLDBOSSHALL_GetOpenState, nflag, sMessage)
end

--@brief	获取房间状态错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneWorldBoss:send_WORLDBOSS_GetRoomState_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneWorldBoss:send_WORLDBOSS_GetRoomState_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WORLDBOSS, Protocol.WORLDBOSS_GetRoomState, nflag, sMessage)
    SceneWorldBoss:closeLoading()
end

--@brief	清除冷却时间错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneWorldBoss:send_WORLDBOSS_Accelerate_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneWorldBoss:send_WORLDBOSS_Accelerate_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WORLDBOSS, Protocol.WORLDBOSS_Accelerate, nflag, sMessage)
end

--@brief	鼓舞错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneWorldBoss:send_WORLDBOSS_Inspire_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneWorldBoss:send_WORLDBOSS_Inspire_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WORLDBOSS, Protocol.WORLDBOSS_Inspire, nflag, sMessage)
end

-------------------------------------公有方法模块End----------------------------------------


