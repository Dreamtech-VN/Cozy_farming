--SceneBattleLoadingData.lua
--@brief	SceneBattleLoading的数据模块
--@date		2014/01/08
--@author	李光森
--@note		战斗载入场景

SceneBattleLoading = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function SceneBattleLoading:_init()
    WZLog("SceneBattleLoading:_init0")
	self.m_root = nil	 	  			--场景根节点
	self.m_tPlayerControl = nil			--需要控制的玩家
	self.m_tPlayerPos = nil				--玩家位置
	self.m_tGotoToBattle = nil			--进入战斗
	self.m_tMakePairOk = nil			--makePairOk协议
	self.m_tTips = nil					--提示
	self.m_tSceneBattle = nil			--战斗场景表引用
	self.m_tStepFunction = nil			--步骤函数
	self.m_nLeftPeopleNum = nil			--左边的人数
	self.m_nRightPeopleNum = nil		--左边的人数
    
    self.m_fShakeHands = 0              --心跳协议
    self.__bReceiveSkill = nil
    self.__bReceiveProp = nil
    self.__bReceivePos = nil
    self.__nPlayerIndex = nil
    self.m_tSkillList = nil             --技能列表
    self.m_tPropList = nil             --道具列表
    self.__bReceiveEndLoading = nil

    self.m_nMyCamp = nil                --我方的阵营值
    self.m_bIsLoadMyself = false        --标记混战模式，是否我已经加载
    self.m_bIsTestLink = nil
    self.m_bIsCreate = true
    self.m_tNoCoolTimeSubType = nil 	--挖坑赛不需要冷却时间的技能子类型
    MsgManager:clear()
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function SceneBattleLoading:_unInit()
    WZLog("SceneBattleLoading:_unInit")
	self.m_root = nil
	self.m_tPlayerControl = nil
	self.m_tPlayerPos = nil
	self.m_tGotoToBattle = nil
	self.m_tMakePairOk = nil
	self.m_tTips = nil
	self.m_tSceneBattle = nil
	self.m_tStepFunction = nil
	self.m_nLeftPeopleNum = nil
	self.m_nRightPeopleNum = nil
    
    self.m_fShakeHands = nil            --心跳协议
    self.__bReceiveSkill = nil
    self.__bReceiveProp = nil
    self.__bReceivePos = nil
    self.__nPlayerIndex = nil
    self.m_tSkillList = nil
    self.m_tPropList = nil
    self.__bReceiveEndLoading = nil

    self.m_nMyCamp = nil                --我方的阵营值
    self.m_bIsLoadMyself = nil        --标记混战模式，是否我已经加载
    self.m_bIsTestLink = nil
    self.m_bIsCreate = nil
    self.m_tNoCoolTimeSubType = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function SceneBattleLoading:createElement()
	local element = WZUISystem:getInstance():createElement("SceneBattleLoading")
	assert(element, "SceneBattleLoading create element failed!")
	self:_init()
	return element
end

--@brief	接收通知客户端对指定角色进行控制
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function SceneBattleLoading:receiveAIControlCommon(battleId, idcount, playerIds)
    -- WBattleGlobal:getCurrent().m_nHostBattleId = battleId
	WZLog("SceneBattleLoading:receiveAIControlCommon one", tostring(idcount))

    if idcount then
        local msg = MsgManager:createMsg(BattleMsgPlayerAIControl)
        msg.m_nCount = idcount
        msg.m_nPlayerIds = playerIds
        MsgManager:pushBlockMsg(msg)

        local currentPlayer = WBattleGlobal:getCurrent():getCurrentCharacter()
        if idcount ~= 0 then
            --会变AI的玩法   掉线处理
            for i = 1, idcount do
                local hero = WBattleGlobal:getCurrent():getHeroWithId(playerIds[i])
                WZLog("SceneBattleLoading:receiveAIControlCommon two", playerIds[i])
                if hero == nil then
                    WZLog("SceneBattleLoading:receiveAIControlCommon", "can't find player:", playerIds[i])
                    WBattleGlobal:getCurrent().m_tAIControlList = WBattleGlobal:getCurrent().m_tAIControlList or {}
                    table.insert(WBattleGlobal:getCurrent().m_tAIControlList, playerIds[i])
                else

                    hero.m_bCanControl = true
                    hero.m_nAiCtrlId = 1
                    hero:buildAiCombination()
                end
            end
        end
    end

   
	for id, guai in pairs (WBattleGlobal:getCurrent():getGuaiList()) do
        guai.m_bCanControl = true
	end
    --当前回合控制的怪物激活ai
   local msg = MsgManager:createMsg(BattleMsgAiControlChange)
   msg.m_nbattleId = battleId
    MsgManager:pushBlockMsg(msg)
end

--@brief	其他人加载百份比
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function SceneBattleLoading:receiveOtherPercent(battleId, currentPlayerId, percent, playerOrGuai)
	WZLog("SceneBattleLoading:receiveOtherPercent")
	self:_updatePercent(battleId, currentPlayerId, percent)
end

--@brief	接收每一个角色出现的位置
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function SceneBattleLoading:receivePlayerPos(battleId, playerId, idcount, playerIds, postionX, postionY)
	WZLog("SceneBattleLoading:receivePlayerPos", Serialize(VectorToTable(playerId)), Serialize(VectorToTable(idcount)), Serialize(VectorToTable(playerIds)), Serialize(VectorToTable(postionX)), Serialize(VectorToTable(postionY)))
	
	self.m_tPlayerPos = {battleId=battleId, playerId=playerId, idcount=idcount, playerIds=playerIds, postionX=postionX, postionY=postionY}
	
	self.__bReceivePos = true
end

--@brief	通知角色进入战斗
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function SceneBattleLoading:receiveGotoBattle(battleId, playerId, wind, currentPlayerId, attackRate, battleRand, playerIds, oldCTB, newCTB, updateCTB_time)
	WZLog("SceneBattleLoading:receiveGotoBattle")

	--[[
	local tPlayerId = VectorToTable(playerIds)
	local tNowCtb = VectorToTable(oldCTB)
	local tNewCtb = VectorToTable(newCTB)
	BattleCtbManager:refreshLastCtb(tPlayerId,tNowCtb,tNewCtb,updateCTB_time)

	self.m_tGotoToBattle = {battleId=battleId, playerId=playerId, wind=wind, currentPlayerId=currentPlayerId, attackRate=attackRate, battleRand=battleRand}
	--]]
	self.__bReceiveEndLoading = true
end

--@brief	接受技能列表
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function SceneBattleLoading:receiveGetSkillListOk(count, id, name, icon, priceCostGold, desc, itemMainType, itemSubType, param1, param2, tireValue, consumePower, specialAttackType, specialAttackParam)
	
	--[[local skillList = { name=name, icon=icon, priceCostGold=priceCostGold, desc=desc, itemMainType=itemMainType, itemSubType=itemSubType, param1=param1, param2=param2, tireValue=tireValue, consumePower=consumePower, specialAttackType=specialAttackType, specialAttackParam=specialAttackParam}

    for i, v in pairs(name) do
        WZLog("receiveGetSkillListOk ", i, id[i], name[i], icon[i], priceCostGold[i], desc[i], itemMainType[i], itemSubType[i], param1[i], param2[i], tireValue[i], consumePower[i], specialAttackType[i], specialAttackParam[i])
    end


	
	WBattleGlobal:getCurrent().m_tSkillList = {}
	for i=1,count do
		WBattleGlobal:getCurrent().m_tSkillList[ id[i] ] = {}
		for key,tab in pairs(skillList) do
			WBattleGlobal:getCurrent().m_tSkillList[ id[i] ][key] = tab[i]
		end
	end]]
	
	self.__bReceiveSkill = true
end

--@brief	接受道具列表
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function SceneBattleLoading:receiveGetPropListOk(count, id, name, icon, priceCostGold, desc, itemMainType, itemSubType, param1, param2, tireValue, consumePower, specialAttackType, specialAttackParam)

	--[[local propList = {name=name, icon=icon, priceCostGold=priceCostGold, desc=desc, itemMainType=itemMainType, itemSubType=itemSubType, param1=param1, param2=param2, tireValue=tireValue, consumePower=consumePower, specialAttackType=specialAttackType, specialAttackParam=specialAttackParam}

    for i, v in pairs(name) do
        WZLog("receiveGetPropListOk ", i, id[i], name[i], icon[i], priceCostGold[i], desc[i], itemMainType[i], itemSubType[i], param1[i], param2[i], tireValue[i], consumePower[i], specialAttackType[i], specialAttackParam[i])
    end

	WBattleGlobal:getCurrent().m_tPropList = {}
	for i=1,count do
		WBattleGlobal:getCurrent().m_tPropList[id[i] ] = {}
		for key,tab in pairs(propList) do
			WBattleGlobal:getCurrent().m_tPropList[id[i] ][key] = tab[i]
		end
	end]]
	
	self.__bReceiveProp = true
end

--@brief	接受玩家技能
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function SceneBattleLoading:receiveGetPlayerSkillOk(count, id, name, icon, priceCostGold, desc, itemMainType, itemSubType, param1, param2, tireValue, consumePower, specialAttackType, specialAttackParam)

	WBattleGlobal:getCurrent().m_tMySkill_Beginning = {count=count, id=id, name=name, icon=icon, priceCostGold=priceCostGold, desc=desc, itemMainType=itemMainType, itemSubType=itemSubType, param1=param1, param2=param2, tireValue=tireValue, consumePower=consumePower, specialAttackType=specialAttackType, specialAttackParam=specialAttackParam}
	
	self.__bReceiveSkill = true
end

--@brief	接受玩家道具
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function SceneBattleLoading:receiveGetPlayerPropOk(count, id, name, icon, priceCostGold, desc, itemMainType, itemSubType, param1, param2, tireValue, consumePower, specialAttackType, specialAttackParam)

	WBattleGlobal:getCurrent().m_tMyProp_Beginning = {count=count, id=id, name=name, icon=icon, priceCostGold=priceCostGold, desc=desc, itemMainType=itemMainType, itemSubType=itemSubType, param1=param1, param2=param2, tireValue=tireValue, consumePower=consumePower, specialAttackType=specialAttackType, specialAttackParam=specialAttackParam}
	
	self.__bReceiveProp = true
end

--@brief	获得提示语成功
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function SceneBattleLoading:receiveTips(tips)
    if tips == nil then
        return
    end

    local tipList = {}
    local lv = CacheCenter.m_tPlayerInfo.level
    for i, info in pairs (tips) do
        if info.leveln == nil or info.leveln <= lv then
            table.insert(tipList, CopyTable(info))
        end
    end

    self.m_tTips = {tips=tipList}
	
	self:_updateTips()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------
