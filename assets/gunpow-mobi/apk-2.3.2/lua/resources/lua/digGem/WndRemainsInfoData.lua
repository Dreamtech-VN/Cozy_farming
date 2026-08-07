--WndRemainsInfoData.lua
--@brief	WndRemainsInfo的数据模块
--@date		2019/07/04
--@author	yrd
--@note		遗迹之光副本信息

WndRemainsInfo = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function WndRemainsInfo:_init()
	self.m_root = nil  			--Cell的根节点
	self.mapId = nil
	self.m_nMapId = nil					--副本Id
	self.m_nMapNum = nil				--遗迹副本表中id
	self.m_nMapTime = nil				--剩余时间
	self.m_nBossBloodMax = nil			--boss总血量
	self.m_nBossBloodCurrent = nil		--boss当前血量	
	self.m_nChallengeTime = nil			--剩余挑战次数
	self.m_nTime = nil					--恢复挑战次数剩余时间
	self.m_nReward = nil				--奖励领取状态
	self.m_sMapStatus = nil				--副本状态 0挑战中 1挑战成功 2挑战失败
	self.m_sPlayerName = nil			--发现者名字
	self.m_tRankList = {}				--输出排行列表
	self.m_nShareTime = nil				--分享cd时间
	self.m_nPlayerRank = -1				--我的排名
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndRemainsInfo:_unInit()
	self.m_root = nil
	self.mapId = nil
	self.m_nMapId = nil					--副本Id
	self.m_nMapNum = nil				--遗迹副本表中id
	self.m_nMapTime = nil				--剩余时间
	self.m_nBossBloodMax = nil			--boss总血量
	self.m_nBossBloodCurrent = nil		--boss当前血量	
	self.m_nChallengeTime = nil			--剩余挑战次数
	self.m_nTime = nil					--恢复挑战次数剩余时间
	self.m_nReward = nil				--副本状态 0挑战中 1挑战成功 2挑战失败
	self.m_sMapStatus = nil				--副本状态
	self.m_sPlayerName = nil			--发现者名字
	self.m_tRankList = nil				--输出排行列表
	self.m_nShareTime = nil				--分享cd时间
	self.m_nPlayerRank = nil			--我的排名
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function WndRemainsInfo:createElement()
    if self.m_root then
        WindowManager:removeWindow(self.m_root,WndRemainsInfo,true)
    end
	local element = WZUISystem:getInstance():createElement("WndRemainsInfo")
	assert(element, "WndRemainsInfo create element failed!")
	self:_init()
	return element
end

function WndRemainsInfo:showInterface(mapId)
	if CheckButtonOpen(114) then
	    local wndRemainsInfo = WndRemainsInfo:createElement()
		WindowManager:addWindow(wndRemainsInfo, WndRemainsInfo, nil, nil, nil, true)
		self.mapId = mapId

		ProtocolProcessorDigGem:send_MINING_GetRelicInfo(self.mapId)
	end
end

function WndRemainsInfo:setRemainsData(mapId, mapNum, mapTime, bossBloodMax, bossBloodCurrent, challengeTime, time, reward, mapStatus, rank, rankPlayerId, rankPlayerName, rankHurt, vip, playerName, shareTime, playerRank)
	self.m_nMapId = mapId
	self.m_nMapNum = mapNum
	self.m_nMapTime = mapTime
	self.m_nBossBloodMax = bossBloodMax
	self.m_nBossBloodCurrent = bossBloodCurrent
	self.m_nChallengeTime = challengeTime
	self.m_nTime = time
	self.m_nReward = reward
	self.m_sMapStatus = mapStatus
	self.m_sPlayerName = playerName
	self.m_nShareTime = shareTime
	self.m_nPlayerRank = playerRank

	self.m_tRankList = {}
	for i = 1, #rank do
		local tempRankData = {}
		tempRankData.rank = rank[i]
		tempRankData.rankPlayerId = rankPlayerId[i]
		tempRankData.rankPlayerName = rankPlayerName[i]
		tempRankData.rankHurt = rankHurt[i]
		tempRankData.vip = vip[i]
		tempRankData.bossBloodMax = bossBloodMax
		table.insert(self.m_tRankList, tempRankData)
	end

	self:_update()
end

--@brief	开始挑战
function WndRemainsInfo:receiveStartOk(
    battleId, mapId, playerCount, playerId, playerName, playerTitle, playerGuild, playerLevel, playerSex,
    maxHP, maxPF, maxSP, attack, critRate, defence, injuryFree, wreckDefense, reduceCrit, power, armor,
    constitution, agility, lucky, insptre, headId, faceId, bodyId, weaponId, wingId, item_id, playerBuffCount,
    buffId, petId, petSkill, petParam, guaiBattleId, guaiId, guaiMaxHP, guaiNowHP,guaiAtk,guaiLv,weaponSkill,petLevel, colour, bodyColour,footmark, professionId, professionSkill, mountId, childId, childName, childSex, childImage, assistSkillIds, defaultShapeBigSkill, blastEffect, extPropertyKey, extPropertyValue, extPropertyCount)

	WZLog("WndRemainsInfo:receiveStartOk")

	if WndDigGem.m_root then
		IS_BATTLEOVER_JUMP_REMAINS = true
	end

    for i , v in pairs( attack ) do
		WZLog("WndRemainsInfo:receiveStartOk attack = " , v )
	end
    WBattleGlobal:getCurrent():destroy()
	WBattleGlobal:getCurrent().m_tMakePairOk ={
        battleId=battleId,battleMode=BattleConstants.g_tBossBattleMode.MODE_REMAINSBOSS, battleMull=false, battleChannle=-1,
        mapId=mapId,playerCount=playerCount,playerId=playerId,playerName=playerName,playerTitle=playerTitle,playerCommunity=playerGuild,
        playerLevel=playerLevel,playerSex=playerSex,maxHP=maxHP,maxPF=maxPF,maxSP=maxSP,attack=attack,critRate=critRate,defence=defence,
        injuryFree=injuryFree,wreckDefense=wreckDefense,reduceCrit=reduceCrit,power=power,armor=armor,constitution=constitution,agility=agility,
        lucky=lucky,insptre=insptre,headId=headId,faceId=faceId,bodyId=bodyId,weaponId=weaponId,wingId=wingId,item_id=item_id,playerBuffCount,
        buffId=buffId,petId=petId,petSkill = petSkill,petLevel=petLevel,petSkillId=petId,petParam=petParam,guaiBattleId=guaiBattleId,guaiId=guaiId,
        guaiMaxHP=guaiMaxHP,guaiNowHP=guaiNowHP,guaiAtk=guaiAtk,guaiLv = guaiLv,weaponSkill=weaponSkill, colour=colour, bodyColour=bodyColour,footmark = footmark, professionId = professionId, professionSkill = professionSkill, mountId = mountId, childId = childId, childName = childName, childSex = childSex, childImage = childImage, assistSkillIds = assistSkillIds, defaultShapeBigSkill = defaultShapeBigSkill, blastEffect = blastEffect, extPropertyKey = extPropertyKey, extPropertyValue = extPropertyValue, extPropertyCount = extPropertyCount
    }
	WBattleGlobal:getCurrent().m_nBattleType = BattleConstants.g_nBATTLE_TYPE_BOSS
    WBattleGlobal:getCurrent().battleMode = BattleConstants.g_tBossBattleMode.MODE_REMAINSBOSS
	replaceScene(SceneBattleLoading:createElement())

    WBattleGlobal:getCurrent().m_tMakePairOk.m_tPlayerInfo = {colour = {[1]=colour},bodyColour = {[1]=bodyColour},sex =CacheCenter.m_tPlayerInfo.sex,level = CacheCenter.m_tPlayerInfo.level,exp = CacheCenter.m_tPlayerInfo.exp,equip = {faceId,headId,bodyId,wingId,weaponId}}
end

function WndRemainsInfo:getRewardOk(status, itemId, num)
	if status == 0 then
		WndRewardShow:showById(itemId,num)
   		GetElement(self.m_root,"conBtnChallenge_WndRemainsInfo",WZUIContainer):setVisible(true)
   		GetElement(self.m_root,"btnReceive_WndRemainsInfo",WZUIButton):setVisible(false)
	else
		MsgBoxManager:showTipBox(LocalStrings.FAIL)
	end
end

--@brief	分享结果
function WndRemainsInfo:getShareMapOk(result)
	if result == 0 then
		MsgBoxManager:showTipBox(LocalStrings.SHARE_SUCCESS)

		ProtocolProcessorDigGem:send_MINING_GetRelicInfo(self.mapId)
		if WndDigGem.m_root then
			ProtocolProcessorDigGem:send_MINING_GetMining()
        end
	else
		MsgBoxManager:showTipBox(LocalStrings.RELIC_TEXT_17)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------
