--SceneTeachBattleLoadingData.lua
--@brief	SceneTeachBattleLoading的数据模块
--@date		2014/01/08
--@author	李光森
--@note		战斗载入场景

SceneTeachBattleLoading = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function SceneTeachBattleLoading:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tPlayer = nil				--玩家表
	self.m_tBoss = nil					--Boss表
	self.m_tPlayerInfo = nil			--玩家信息
	self.m_tTips = nil					--提示
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function SceneTeachBattleLoading:_unInit()
	self.m_root = nil
	self.m_tPlayer = nil
	self.m_tBoss = nil
	self.m_tPlayerInfo = nil
	self.m_tTips = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function SceneTeachBattleLoading:createElement()
	local element = WZUISystem:getInstance():createElement("SceneBattleLoading")
	assert(element, "SceneBattleLoading create element failed!")
	element:setLuaObjectIndex(SceneTeachBattleLoading)
	self:_init()
	return element
end

--@brief	角色信息获取成功
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function SceneTeachBattleLoading:receiveGetPlayerInfoOk(playerId, playerName, tickets, maxLevel, playerHp, playerDefend, playerPhysical, playerDefense, playerGold, playerHonor, playerSex, level, attack, exp, guildName, medalNum, critRate, explodeRadius, proficiency, suit_head, suit_face, suit_body, suit_weapon, weapon_type, upgradeexp, vipLevel, suit_wing, player_title, weaponLevel, wbUserId, zsleve, injuryFree, wreckDefense, reduceCrit, reduceBury, force, armor, agility, physique, luck, fighting, vipMark, vipLastDay)
	WZLog("SceneTeachBattleLoading:receiveGetPlayerInfoOk")
	
	self.m_tPlayerInfo = {playerId=playerId, playerName=playerName, tickets=tickets, maxLevel=maxLevel, playerHp=playerHp, playerDefend=playerDefend, playerPhysical=playerPhysical, playerDefense=playerDefense, playerGold=playerGold, playerHonor=playerHonor, playerSex=playerSex, level=level, attack=attack, exp=exp, guildName=guildName, medalNum=medalNum, critRate=critRate, explodeRadius=explodeRadius, proficiency=proficiency, suit_head=suit_head, suit_face=suit_face, suit_body=suit_body, suit_weapon=suit_weapon, weapon_type=weapon_type, upgradeexp=upgradeexp, vipLevel=vipLevel, suit_wing=suit_wing, player_title=player_title, weaponLevel=weaponLevel, wbUserId=wbUserId, zsleve=zsleve, injuryFree=injuryFree, wreckDefense=wreckDefense, reduceCrit=reduceCrit, reduceBury=reduceBury, force=force, armor=armor, agility=agility, physique=physique, luck=luck, fighting=fighting, vipMark=vipMark, vipLastDay=vipLastDay}

	self.m_bReceivePlayerInfo = true
end

--@brief	其他人加载百份比
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function SceneTeachBattleLoading:receiveOtherPercent(battleId, currentPlayerId, percent, playerOrGuai)
	self:_updatePercent(battleId, currentPlayerId, percent)
end

--@brief	接收每一个角色出现的位置
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function SceneTeachBattleLoading:receivePlayerPos(battleId, playerId, idcount, playerIds, postionX, postionY)
	WZLog("SceneTeachBattleLoading:receivePlayerPos")
	
	self.m_tPlayerPos = {battleId=battleId, playerId=playerId, idcount=idcount, playerIds=playerIds, postionX=postionX, postionY=postionY}
	
	self.__bReceivePos = true
end

--@brief	通知角色进入战斗
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function SceneTeachBattleLoading:receiveGotoBattle(battleId, playerId, wind, currentPlayerId, isCriticalHit, attackRate, battleRand, playerOrGuai, runTimes)
	WZLog("SceneTeachBattleLoading:receiveGotoBattle")
	
	self.m_tGotoToBattle = {battleId=battleId, playerId=playerId, wind=wind, currentPlayerId=currentPlayerId, isCriticalHit=isCriticalHit, attackRate=attackRate, battleRand=battleRand, playerOrGuai=playerOrGuai, runTimes=runTimes}
	
	self.__bReceiveEndLoading = true
end

--@brief	接受技能列表
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function SceneTeachBattleLoading:receiveGetSkillListOk(count, id, name, icon, priceCostGold, desc, itemMainType, itemSubType, param1, param2, tireValue, consumePower, specialAttackType, specialAttackParam)
	
	local skillList = { name=name, icon=icon, priceCostGold=priceCostGold, desc=desc, itemMainType=itemMainType, itemSubType=itemSubType, param1=param1, param2=param2, tireValue=tireValue, consumePower=consumePower, specialAttackType=specialAttackType, specialAttackParam=specialAttackParam}
	
	WBattleGlobal:getCurrent().m_tSkillList = {}
	for i=1,count do
		WBattleGlobal:getCurrent().m_tSkillList[id[i]] = {}
		for key,tab in pairs(skillList) do
			WBattleGlobal:getCurrent().m_tSkillList[id[i]][key] = tab[i]
		end
	end
	
	self.__bReceiveSkill = true
end

--@brief	接受道具列表
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function SceneTeachBattleLoading:receiveGetPropListOk(count, id, name, icon, priceCostGold, desc, itemMainType, itemSubType, param1, param2, tireValue, consumePower, specialAttackType, specialAttackParam)

	local propList = {name=name, icon=icon, priceCostGold=priceCostGold, desc=desc, itemMainType=itemMainType, itemSubType=itemSubType, param1=param1, param2=param2, tireValue=tireValue, consumePower=consumePower, specialAttackType=specialAttackType, specialAttackParam=specialAttackParam}
	
	WBattleGlobal:getCurrent().m_tPropList = {}
	for i=1,count do
		WBattleGlobal:getCurrent().m_tPropList[id[i]] = {}
		for key,tab in pairs(propList) do
			WBattleGlobal:getCurrent().m_tPropList[id[i]][key] = tab[i]
		end
	end
	
	self.__bReceiveProp = true
end

--@brief	接受玩家技能
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function SceneTeachBattleLoading:receiveGetPlayerSkillOk(count, id, name, icon, priceCostGold, desc, itemMainType, itemSubType, param1, param2, tireValue, consumePower, specialAttackType, specialAttackParam)

	WBattleGlobal:getCurrent().m_tMySkill_Beginning = {count=count, id=id, name=name, icon=icon, priceCostGold=priceCostGold, desc=desc, itemMainType=itemMainType, itemSubType=itemSubType, param1=param1, param2=param2, tireValue=tireValue, consumePower=consumePower, specialAttackType=specialAttackType, specialAttackParam=specialAttackParam}
	
	self.__bReceiveSkill = true
end

--@brief	接受玩家道具
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function SceneTeachBattleLoading:receiveGetPlayerPropOk(count, id, name, icon, priceCostGold, desc, itemMainType, itemSubType, param1, param2, tireValue, consumePower, specialAttackType, specialAttackParam)

	WBattleGlobal:getCurrent().m_tMyProp_Beginning = {count=count, id=id, name=name, icon=icon, priceCostGold=priceCostGold, desc=desc, itemMainType=itemMainType, itemSubType=itemSubType, param1=param1, param2=param2, tireValue=tireValue, consumePower=consumePower, specialAttackType=specialAttackType, specialAttackParam=specialAttackParam}
	
	self.__bReceiveProp = true
end

--@brief	获得提示语成功
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function SceneTeachBattleLoading:receiveTips(tips)
	self.m_tTips = {tips=tips}
	
	self:_updateTips()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------
