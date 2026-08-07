--BattleAiCtrlInterface.lua
--@brief	英雄的Ai接口数据表
--@date		2014/11/25
--@author	莫剑峰
--@note

--@brief	英雄的Ai接口数据表
BattleAiCtrlInterface = {
    m_tHero = nil,                          --所属英雄
    
    m_tTalkTextList = nil,                  --说话文本列表
    m_tTalkTriggerList = nil,               --说话的触发内容列表
    
    m_tMovePointXList = nil,                --移动地点X坐标列表
    m_tMovePointYList = nil,                --移动地点Y坐标列表
    m_tMoveTriggerList = nil,               --移动的触发内容列表
    
    m_tFlyPointXList = nil,                 --飞行地点X坐标列表
    m_tFlyPointYList = nil,                 --飞行地点Y坐标列表
    m_tFlyTriggerList = nil,                --飞行的触发内容列表
    
    m_tSkillList = nil,                     --技能列表
    m_tSkillTriggerList = nil,              --使用技能的触发内容列表
    
    m_tItemList = nil,                      --道具列表
    m_tItemTriggerList = nil,               --使用道具的触发内容列表
    
    m_tSummonTriggerList = nil,             --召唤列表

    m_tThreatList = nil,                    --仇恨值列表
    
    --状态标识
    --公共
    m_bIsActWithRandom = nil,             --随机概率触发：根据随机数来确定触发行为
    m_bIsActWithHPValueEnemy = nil,       --敌人血量剩余值触发：根敌人血量剩余值触发行为
    m_bIsActWithHPPercentEnemy = nil,     --敌人血量剩余百分比：根敌人血量剩余百分比行为
    m_bIsActWithHPPercentHero = nil,      --玩家剩余血量百分比：根据玩家剩余血量百分比行为
    m_bIsActWithTurn = nil,               --攻击回合数触发：根据双方攻击回合数触发行为
    m_bIsActWithSkill = nil,              --技能触发：根据玩家使用技能触发行为
    m_bIsActWithBeHit = nil,              --受击触发：根据NPC是否受击次触发行为

}

--@brief	英雄的行为触发类型
WHeroActTriggerType = {
    TRIGGER_RANDOM = 1,                     --随机概率触发：根据随机数来确定触发行为
    TRIGGER_HP_VALUE_TARGET = 2,            --敌人血量剩余值触发：根敌人血量剩余值触发行为
    TRIGGER_HP_PERCENT_TARGET = 3,          --敌人血量剩余百分比：根敌人血量剩余百分比行为
    TRIGGER_HP_PERCENT_ME = 4,              --玩家剩余血量百分比：根据玩家剩余血量百分比行为
    TRIGGER_TURN = 5,                       --攻击回合数触发：根据回合数触发行为
    TRIGGER_SKILL = 6,                      --技能触发：根据玩家使用技能触发行为
    TRIGGER_BE_HIT = 7,                     --受击触发：-1/技能ID
}

--@brief	英雄的行为类型
WHeroActType = {
    TYPE_SUMMON = 1,                        --召唤小怪行为：小怪id，小怪数量，召唤地点
    TYPE_SKILL = 2,                         --释放技能行为：技能id
    TYPE_TALK = 3,                          --说话冒泡行为：文字id,说话次数
    TYPE_MOVE = 4,                          --移动行为：移动坐标或距离
    TYPE_FLY = 5,                           --飞行行为：分析坐标或距离
    TYPE_ITEM = 6,                          --使用道具行为：道具id
}

--@brief	英雄的技能类型
WHeroSkillType = {
    SKILL_ADDTIMES_ONE =   2,	--连发+1
	SKILL_ADDTIMES_TWO =   3,	--连发+2
	SKILL_DIVIDE_THREE =   4,	--散射x3
	SKILL_ATTACKUP_FIVE =  5,	--攻击+50%
	SKILL_ATTACKUP_FOUR =  6,	--攻击+40%
	SKILL_ATTACKUP_THREE = 7,	--攻击+30%
	SKILL_ATTACKUP_TWO =   8,	--攻击+20%
	SKILL_ATTACKUP_ONE =   9,	--攻击+10%
	SKILL_DIVIDE_TWO =     18,	--散射x2
}

--@brief	英雄的道具类型
WHeroItemType = {
    FLY        =           1,   --飞行
    ITEM_BLOOD =           10,	--医疗包
	ITEM_BLOODT =          11,	--群体医疗
	ITEM_FROZEN =          12,	--冰冻弹
	ITEM_FOLLOW =          13,	--追踪弹
	ITEM_HIDE =            14,	--隐身
	ITEM_HIDET =           15,	--群体隐身
	ITEM_FLY =             16,	--飞行器
	ITEM_ANGER =           17,	--暴怒
}

-------------------------------------公有方法模块--------------------------------------
--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function BattleAiCtrlInterface:new()
    WZLog("BattleAiCtrlInterface:new")
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
    tNewObj.m_tThreatList = {}
    
    tNewObj.m_tTalkTextList = {}
    tNewObj.m_tTalkTriggerList = {}
    
    tNewObj.m_tMovePointXList = {}
    tNewObj.m_tMovePointYList = {}
    tNewObj.m_tMoveTriggerList = {}
    
    tNewObj.m_tFlyPointXList = {}
    tNewObj.m_tFlyPointYList = {}
    tNewObj.m_tFlyTriggerList = {}
    
    tNewObj.m_tSkillList = {}
    tNewObj.m_tSkillTriggerList = {}
    
    tNewObj.m_tItemList = {}
    tNewObj.m_tItemTriggerList = {}

    tNewObj.m_tSummonTriggerList = {}
    
	return tNewObj
end

--@brief	销毁Ai接口
function BattleAiCtrlInterface:destroy()
    self.m_tHero = nil
    
    self.m_tTalkTextList = nil                  --说话文本列表
    self.m_tTalkTriggerList = nil               --说话的触发内容列表
    
    self.m_tMovePointXList = nil                --移动地点X坐标列表
    self.m_tMovePointYList = nil                --移动地点Y坐标列表
    self.m_tMoveTriggerList = nil               --移动的触发内容列表
    
    self.m_tFlyPointXList = nil                 --飞行地点X坐标列表
    self.m_tFlyPointYList = nil                 --飞行地点Y坐标列表
    self.m_tFlyTriggerList = nil                --飞行的触发内容列表
    
    self.m_tSkillList = nil                     --技能列表
    self.m_tSkillTriggerList = nil              --使用技能的触发内容列表
    
    self.m_tItemList = nil                      --道具列表
    self.m_tItemTriggerList = nil               --使用道具的触发内容列表

    self.m_tSummonTriggerList = nil             --召唤列表
    
    self.m_tThreatList = nil
    
end

--@brief	设置所属英雄
function BattleAiCtrlInterface:setHero(Hero)
    self.m_tHero = Hero
end

--@brief	切换行动时重置操作
function BattleAiCtrlInterface:resetParam()    

    self.m_bIsActWithRandom = false         --随机概率触发：根据随机数来确定触发行为
    self.m_bIsActWithHPValueEnemy = false   --敌人血量剩余值触发：根敌人血量剩余值触发行为
    self.m_bIsActWithHPPercentEnemy = false --敌人血量剩余百分比：根敌人血量剩余百分比行为
    self.m_bIsActWithHPPercentHero = false  --玩家剩余血量百分比：根据玩家剩余血量百分比行为
    self.m_bIsActWithTurn = false           --攻击回合数触发：根据双方攻击回合数触发行为
    self.m_bIsActWithSkill = false          --技能触发：根据玩家使用技能触发行为
    self.m_bIsActWithBeHit = false          --受击触发：根据NPC是否受击次触发行为
end

--@brief    说话文本列表
--@param	tTalkTextList:文本列表,
function BattleAiCtrlInterface:setTalkText(tTalkTextList)
    self.m_tTalkTextList = tTalkTextList
end

--@brief    说话
--@param	triggerType:触发类型, 
--@param	paramTrigger:说话内容的下标,
--@param	paramX:参数1,
--@param	paramY:参数2,
--@param	paramZ:参数3, 
function BattleAiCtrlInterface:setTalk(triggerType, paramTrigger, paramX, paramY, paramZ, index)
    if self.m_tTalkTriggerList == nil then
        self.m_tTalkTriggerList = {}
    end

    table.insert(self.m_tTalkTriggerList, {triggerType, paramTrigger, paramX, paramY, paramZ, index})
end

--@brief    移动地点列表
--@param	tPointXList:地点X坐标列表, 
--@param	tPointYList:地点Y坐标列表, 
function BattleAiCtrlInterface:setMovePoint(tPointXList, tPointYList)
    self.m_tMovePointXList = tPointXList
    self.m_tMovePointYList = tPointYList
end

--@brief    移动
--@param	triggerType:触发类型,
--@param	paramTrigger:移动地点的下标,
--@param	paramX:参数1,
--@param	paramY:参数2,
--@param	paramZ:参数3,
function BattleAiCtrlInterface:setMove(triggerType, paramTrigger, paramX, paramY, paramZ, index)
    if self.m_tMoveTriggerList == nil then
        self.m_tMoveTriggerList = {}
    end
    
    table.insert(self.m_tMoveTriggerList, {triggerType, paramTrigger, paramX, paramY, paramZ, index})
end

--@brief    飞行地点列表
--@param	tPointXList:地点X坐标列表,
--@param	tPointYList:地点Y坐标列表,
function BattleAiCtrlInterface:setFlyPoint(tPointXList, tPointYList)
    self.m_tFlyPointXList = tPointXList
    self.m_tFlyPointYList = tPointYList
end

--@brief    飞行
--@param	triggerType:触发类型,
--@param	paramTrigger:飞行地点的下标,
--@param	paramX:参数1,
--@param	paramY:参数2,
--@param	paramZ:参数3,
function BattleAiCtrlInterface:setFly(triggerType, paramTrigger, paramX, paramY, paramZ, index)
    if self.m_tFlyTriggerList == nil then
        self.m_tFlyTriggerList = {}
    end
    
    table.insert(self.m_tFlyTriggerList, {triggerType, paramTrigger, paramX, paramY, paramZ, index})
end

--@brief    技能列表
--@param	tSkillList:技能列表,
function BattleAiCtrlInterface:setSkill(tSkillList)
    self.m_tSkillList = tSkillList
end

--@brief    技能
--@param	triggerType:触发类型,
--@param	paramTrigger:技能的下标,
--@param	paramX:参数1,
--@param	paramY:参数2,
--@param	paramZ:参数3,
function BattleAiCtrlInterface:setSkillUse(triggerType, paramTrigger, paramX, paramY, paramZ, index)
    if self.m_tSkillTriggerList == nil then
        self.m_tSkillTriggerList = {}
    end
    
    table.insert(self.m_tSkillTriggerList, {triggerType, paramTrigger, paramX, paramY, paramZ, index})
end

--@brief    道具列表
--@param	tItemList:道具列表,
function BattleAiCtrlInterface:setItem(tItemList)
    self.m_tItemList = tItemList
end

--@brief    道具
--@param	triggerType:触发类型,
--@param	paramTrigger:道具的下标,
--@param	paramX:参数1,
--@param	paramY:参数2,
--@param	paramZ:参数3,
function BattleAiCtrlInterface:setItemUse(triggerType, paramTrigger, paramX, paramY, paramZ, index)
    if self.m_tItemTriggerList == nil then
        self.m_tItemTriggerList = {}
    end
    
    table.insert(self.m_tItemTriggerList, {triggerType, paramTrigger, paramX, paramY, paramZ, index})
end

--@brief    召唤
--@param	triggerType:触发类型,
--@param	paramTrigger:召唤的下标,
--@param	paramX:参数1,
--@param	paramY:参数2,
--@param	paramZ:参数3,
function BattleAiCtrlInterface:setSummon(triggerType, paramTrigger, paramX, paramY, paramZ, index)
    if self.m_tSummonTriggerList == nil then
        self.m_tSummonTriggerList = {}
    end
    
    table.insert(self.m_tSummonTriggerList, {triggerType, paramTrigger, paramX, paramY, paramZ, index})
end

--@brief    获取仇恨值X的玩家
--@param	nRanking:排名
function BattleAiCtrlInterface:getThreatPlayer(nRanking)
    WZLog("BattleAiCtrlInterface:getThreatPlayer0", BattleCommon:tableLen(self.m_tThreatList))
    nRanking = math.abs(nRanking)
    local threatMax = 0
    local threatMaxPlayer = WMonster:getRandomPlayer()
    local cleanPlayerList = {}
    
    for i, v in pairs(self.m_tThreatList) do
        WZLog("BattleAiCtrlInterface:getThreatPlayer0.5")
        if WBattleGlobal:getCurrent():getCharacterWithId(i):isDead() then
            WZLog("BattleAiCtrlInterface:getThreatPlayer0.5 dead", i)
           table.insert(cleanPlayerList, i)            
        end
    end
    
    for i, v in pairs(cleanPlayerList) do
        WZLog("BattleAiCtrlInterface:getThreatPlayer0.9", v, BattleCommon:tableLen(self.m_tThreatList))
        table.remove(self.m_tThreatList, v)
    end
    
    local sortThreatList = {}
    local sortMax = 1
    local sortValue = nil
    for i, v in pairs(self.m_tThreatList) do
        WZLog("BattleAiCtrlInterface:getThreatPlayer1")
        if sortValue == nil or v > self.m_tThreatList[sortValue] then
            sortValue = i
            WZLog("BattleAiCtrlInterface:getThreatPlayer1", sortValue)
        end
    end
    if sortValue ~= nil then
        table.insert(sortThreatList, sortMax, sortValue)
    end
    
    local sortMin = 1
    local sortMid = 1
    if BattleCommon:tableLen(self.m_tThreatList) >= 3 then
        sortMin = 3
        sortValue = nil
        for i, v in pairs(self.m_tThreatList) do
            if sortValue == nil or v < self.m_tThreatList[sortValue] then
                sortValue = i
            end
        end
        if sortValue ~= nil then
            table.insert(sortThreatList, sortMin, sortValue)
        end
        sortMid = 2
        sortValue = nil
        for i, v in pairs(self.m_tThreatList) do
            if (v ~= sortThreatList[sortMax] and v ~= sortThreatList[sortMin]) then
                sortValue = i
            end
        end
        if sortValue ~= nil then
            table.insert(sortThreatList, sortMid, sortValue)
        end
    elseif BattleCommon:tableLen(self.m_tThreatList) >= 2 then
        sortMin = 2
        sortValue = nil
        for i, v in pairs(self.m_tThreatList) do
            if sortValue == nil or v < self.m_tThreatList[sortValue] then
                sortValue = i
            end
        end
        if sortValue ~= nil then
            table.insert(sortThreatList, sortMin, sortValue)
        end
    end
    
    local chooseMode = nil
    if BattleCommon:tableLen(sortThreatList) == 0 then
        chooseMode = 1
        threatMaxPlayer =  WMonster:getRandomPlayer()
    elseif nRanking <= BattleCommon:tableLen(self.m_tThreatList) then
        chooseMode = 2
        threatMaxPlayer = WBattleGlobal:getCurrent():getCharacterWithId(sortThreatList[nRanking])
    else
        chooseMode = 3
        threatMaxPlayer = WBattleGlobal:getCurrent():getCharacterWithId(sortThreatList[sortMin])
    end
    WZLog("BattleAiCtrlInterface:getThreatPlayer", nRanking, tostring(chooseMode), BattleCommon:tableLen(self.m_tThreatList), BattleCommon:tableLen(sortThreatList), tostring( sortThreatList[sortMin] ), tostring( sortThreatList[sortMax] ), sortMin)
    
    if threatMaxPlayer == nil then
        threatMaxPlayer = WMonster:getRandomPlayer()
    end
    return threatMaxPlayer
end

-------------------------------------私有方法模块--------------------------------------
