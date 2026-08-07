--ProtocolProcessorCommunityBossRoom.lua
--@brief	公会副本房间协议
--@date  	2017/01/18
--@note 	公会副本房间协议


ProtocolProcessorCommunityBossRoom = ProtocolProcessorBase:new()

-------------------------------------公有方法模块--------------------------------------

--@brief	注册协议组所有协议
function ProtocolProcessorCommunityBossRoom:regAll()
	--@brief	获取公会副本信息
	self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildBossInfoOk, "ProtocolProcessorCommunityBossRoom:parse_GUILD_GetGuildBossInfoOk", "iiiiivivsviiisvi")
	--@brief	获取公会副本排行榜
	self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildBossRankOk, "ProtocolProcessorCommunityBossRoom:parse_GUILD_GetGuildBossRankOk", "iisisvivsvivi")
	--@brief	开始战斗成功
	self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_MakePairOk, "ProtocolProcessorCommunityBossRoom:parse_GUILD_MakePairOk", "iiivivsvsvsvivivivivivivivivivivivivivivivivivivivivivivivsvivivsvivivivivivivnvivi")
    --@brief	公会副本领取伤害奖励（GUILD_GetHurtRewardOk = 89）
    self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_GetHurtRewardOk, "ProtocolProcessorCommunityBossRoom:parse_GUILD_GetHurtRewardOk", "vivi")


     
	--@brief	获取公会副本信息错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildBossInfo, "ProtocolProcessorCommunityBossRoom:send_GUILD_GetGuildBossInfo_ErrorProcess", "is" )
	--@brief	公会副本鼓舞错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_GuildInspire, "ProtocolProcessorCommunityBossRoom:send_GUILD_GuildInspire_ErrorProcess", "is" )
	--@brief	获取公会副本排行榜错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildBossRank, "ProtocolProcessorCommunityBossRoom:send_GUILD_GetGuildBossRank_ErrorProcess", "is" )
    --@brief	公会副本领取伤害奖励（GUILD_GetHurtReward = 88）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_GetHurtReward , "ProtocolProcessorCommunityBossRoom:send_GUILD_GetHurtReward_ErrorProcess", "is" )

    --@brief	开始挑战（GUILD_GetHurtReward = 83）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_MakePair , "ProtocolProcessorCommunityBossRoom:send_GUILD_MakePair_ErrorProcess", "is" )
end

--@brief	反注册协议组所有协议
function ProtocolProcessorCommunityBossRoom:unregAll()
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief	获取公会副本信息
function ProtocolProcessorCommunityBossRoom:send_GUILD_GetGuildBossInfo( )
	WZLog("send_GUILD_GetGuildBossInfo")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildBossInfo )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	公会副本鼓舞
function ProtocolProcessorCommunityBossRoom:send_GUILD_GuildInspire(times,copyId)
	WZLog("send_GUILD_GuildInspire")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_GuildInspire )
	if sender==nil then WZLog("sender == nil") return end
	sender:writeInt( times )
	sender:writeInt( copyId )
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取公会副本排行榜
function ProtocolProcessorCommunityBossRoom:send_GUILD_GetGuildBossRank(sectionId )
	WZLog("send_GUILD_GetGuildBossRank")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildBossRank )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( sectionId )	-- 章节ID
	SendProtocol(sender,false) --true:showLoading
end

--@brief	公会副本领取伤害奖励（GUILD_GetHurtReward = 88）
function ProtocolProcessorCommunityBossRoom:send_GUILD_GetHurtReward(rewardId)
	WZLog("send_GUILD_GetHurtReward ")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_GetHurtReward  )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( rewardId )	-- 奖励ID
	SendProtocol(sender,false) --true:showLoading
end

--@brief	开始挑战
function ProtocolProcessorCommunityBossRoom:send_GUILD_GetGuildMakePair(copyId )
	WZLog("send_GUILD_GetGuildMakePair")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_MakePair )
	if sender==nil then WZLog("sender == nil") return end
	sender:writeInt( copyId )
	SendProtocol(sender,false) --true:showLoading
end

-------------------------------------服务器到客户端协议回调方法模块--------------------------------------

--@brief	获取公会副本信息
function ProtocolProcessorCommunityBossRoom:parse_GUILD_GetGuildBossInfoOk(sectionId, boosId, boosHP, hurtAdd,playerNum,cheerId, cheerName, cheerCost, playTimes, todayGain, weekHurt, reward)
	-- sectionId : 挑战中章节ID
	-- boosId : 挑战中BossID
	-- boosHP : Boss当前血量
	-- hurtAdd : 当前伤害加成
	-- cheerId : 鼓舞玩家ID
	-- cheerName : 鼓舞玩家名称
	-- cheerCost : 鼓舞花费钻石数
	-- playTimes : 今日挑战次数
	-- todayGain : 公会货币今日收获数量
	-- weekHurt : 本周伤害输出
	-- reward : 已领取的周奖励ID
	WZLog("ProtocolProcessorCommunityBossRoom:parse_GUILD_GetGuildBossInfoOk =",sectionId)
	local data = {
		sectionId = sectionId,
		bossId = boosId,
		bossHp = boosHP,
		hurtAdd = hurtAdd,
		cheerId = VectorToTable(cheerId),
		cheerName = VectorToTable(cheerName),
		cheerCost = VectorToTable(cheerCost),
		playTimes = playTimes,
		todayGain = todayGain,
		weekHurt = weekHurt,
		reward = reward,	
		fighterNum = playerNum,	
	}
	SceneCommunityBossInfo:updateInfoViewData(data)
	SceneCommunityCopy:updateInfoViewData(data)
	WndCommunityBossInspire:update(data.hurtAdd)

end

--@brief	获取公会副本排行榜
function ProtocolProcessorCommunityBossRoom:parse_GUILD_GetGuildBossRankOk(sectionId, fgId, fgName, fgLv, firstTime, guildId, guildName, guildLv, useTime)
	-- sectionId : 挑战中章节ID
	-- fgId : 全服首次通关公会ID
	-- fgName : 全服首次通关公会名称
	-- firstTime : 全服首次通关时间
	-- guildId : 公会ID
	-- guildName : 公会名称
	-- useTime : 耗时（秒）
	WZLog("ProtocolProcessorCommunityBossRoom:parse_GUILD_GetGuildBossRankOk")
	WndCommunityBossWarRank:setData(sectionId, fgId, fgName, fgLv, firstTime, VectorToTable(guildId), VectorToTable(guildName), VectorToTable(guildLv), VectorToTable(useTime))
end

--@brief	开始战斗成功
function ProtocolProcessorCommunityBossRoom:parse_GUILD_MakePairOk(battleId, mapId, playerCount, 
	playerId, playerName, playerTitle, playerGuild, playerLevel, playerSex, 
	maxHP, maxPF, maxSP, attack, critRate, defence, 
	injuryFree, wreckDefense, reduceCrit, power, armor, constitution, 
	agility, lucky, inspire, headId, faceId, bodyId, 
	weaponId, wingId, item_id, petSkill, playerBuffCount, buffId, petAnimation, 
	petGift, guaiBattleId, guaiId, guaiMaxHP, guaiNowHP, 
	guaiAttack, petAdvancedLevel, colour, bodycolour)
	-- battleId : 战斗组Id
	-- mapId : 地图id
	WZLog("ProtocolProcessorCommunityBossRoom:parse_GUILD_MakePairOk ",Serialize(VectorToTable(inspire)))
	WZLog("ProtocolProcessorCommunityBossRoom:parse_GUILD_MakePairOk ",battleId, mapId, playerCount, Serialize(VectorToTable(playerId)), Serialize(VectorToTable(playerName)), Serialize(VectorToTable(playerTitle)), Serialize(VectorToTable(playerGuild)), Serialize(VectorToTable(playerLevel)), Serialize(VectorToTable(playerSex)), Serialize(VectorToTable(maxHP)), Serialize(VectorToTable(maxPF)), Serialize(VectorToTable(maxSP)),
		"\nattack\n", Serialize(VectorToTable(attack)), Serialize(VectorToTable(critRate)), Serialize(VectorToTable(defence)), Serialize(VectorToTable(injuryFree)), Serialize(VectorToTable(wreckDefense)), Serialize(VectorToTable(reduceCrit)), Serialize(VectorToTable(power)), Serialize(VectorToTable(armor)), Serialize(VectorToTable(constitution)), Serialize(VectorToTable(agility)), Serialize(VectorToTable(lucky)),Serialize(VectorToTable(inspire)), Serialize(VectorToTable(headId)), Serialize(VectorToTable(faceId)), Serialize(VectorToTable(bodyId)), Serialize(VectorToTable(weaponId)), Serialize(VectorToTable(wingId)),
		"\nitem_id\n", Serialize(VectorToTable(item_id)), Serialize(VectorToTable(playerBuffCount)), Serialize(VectorToTable(buffId)), Serialize(VectorToTable(petAnimation)), Serialize(VectorToTable(petSkill)), 
		"\nguaiBattleId\n", Serialize(VectorToTable(guaiBattleId)), Serialize(VectorToTable(guaiId)), Serialize(VectorToTable(guaiMaxHP)), Serialize(VectorToTable(guaiNowHP)), VectorToTable(weaponSkill),
        "\npetLevel:", Serialize(VectorToTable(colour)),Serialize(VectorToTable(bodycolour)))

	SceneCommunityBossInfo:receiveMakePairOk(battleId, mapId, playerCount,
		VectorToTable(playerId), VectorToTable(playerName), VectorToTable(playerTitle), VectorToTable(playerGuild), VectorToTable(playerLevel), VectorToTable(playerSex), 
		VectorToTable(maxHP), VectorToTable(maxPF), VectorToTable(maxSP), VectorToTable(attack), VectorToTable(critRate), VectorToTable(defence), 
		VectorToTable(injuryFree), VectorToTable(wreckDefense), VectorToTable(reduceCrit), VectorToTable(power), VectorToTable(armor), VectorToTable(constitution), 
		VectorToTable(agility), VectorToTable(lucky), VectorToTable(inspire),VectorToTable(headId), VectorToTable(faceId), VectorToTable(bodyId), 
		VectorToTable(weaponId), VectorToTable(wingId), VectorToTable(item_id), VectorToTable(playerBuffCount), VectorToTable(buffId), VectorToTable(petAnimation), 
		VectorToTable(petSkill), VectorToTable(petGift), VectorToTable(guaiBattleId), VectorToTable(guaiId), VectorToTable(guaiMaxHP), VectorToTable(guaiNowHP),
		VectorToTable(guaiAttack), VectorToTable(weaponSkill), VectorToTable(petAdvancedLevel),VectorToTable(colour),VectorToTable(bodycolour))
end

--@brief	公会副本领取伤害奖励（GUILD_GetHurtRewardOk = 89）
function ProtocolProcessorCommunityBossRoom:parse_GUILD_GetHurtRewardOk(itemId, itemNum)
	-- itemId : 活动物品Id
	-- itemNum : 活动物品数量
	WZLog("ProtocolProcessorCommunityBossRoom:parse_GUILD_GetHurtRewardOk")
	SceneCommunityCopy:getRewrdSuccess(VectorToTable(itemId), VectorToTable(itemNum))
end

-------------------------------------服务器到客户端协议回调方法模块Error--------------------------------------
--@brief	获取公会副本信息错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorCommunityBossRoom:send_GUILD_GetGuildBossInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorCommunityBossRoom:send_GUILD_GetGuildBossInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildBossInfo, nflag, sMessage)
end

--@brief	公会副本鼓舞错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorCommunityBossRoom:send_GUILD_GuildInspire_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorCommunityBossRoom:send_GUILD_GuildInspire_ErrorProcess",sMessage)
	-- ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_GuildInspire, nflag, sMessage)
	WndCommunityBossInspire:closeLoading()
	if sMessage == "3" then
		replaceScene(SceneCommunityCopy:createElement())
		MsgBoxManager:showTipBox(LocalStrings.HAVE_KILL_BOSS)
	elseif sMessage == "2" then
		WndCommunityBossInspire:OnCloseClick()
		MsgBoxManager:showTipBox(LocalStrings.GUILD_BOSS_INSPIRE_FULL)
		ProtocolProcessorCommunityBossRoom:send_GUILD_GetGuildBossInfo()
	else
		MsgBoxManager:showTipBox(LocalStrings.WORLD_INSPIRE_ADD_Fail)
	end
end

--@brief	获取公会副本排行榜错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorCommunityBossRoom:send_GUILD_MakePair_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorCommunityBossRoom:send_GUILD_MakePair_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_MakePair, nflag, sMessage)
	replaceScene(SceneCommunityCopy:createElement())
	MsgBoxManager:showTipBox(LocalStrings.HAVE_KILL_BOSS)
end

--@brief	公会副本领取伤害奖励（GUILD_GetHurtReward = 88）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorCommunityBossRoom:send_GUILD_GetHurtReward_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorCommunityBossRoom:send_GUILD_GetHurtReward _ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_GetHurtReward , nflag, sMessage)
end

--@brief	公会副本开始挑战 错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorCommunityBossRoom:send_GUILD_GetHurtReward_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorCommunityBossRoom:send_GUILD_GetHurtReward _ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_GetHurtReward , nflag, sMessage)
end