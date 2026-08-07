--WMonsterAIInterface.lua
--@brief	怪物的Ai接口数据表
--@date		2014/3/31
--@author	莫剑峰
--@note

--@brief	怪物的Ai接口数据表
WMonsterAIInterface = {
    m_tMonster = nil,                       --所属怪物
    
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
    
    m_tAtkTargetList = nil,                 --选择目标列表
    m_tAtkTargetChooseTriggerList = nil,    --选择目标的触发内容列表

    m_tThreatList = nil,                    --仇恨值列表
    
    --状态标识
    --说话
    m_bIsTalkWithSkill = false,             --是否已经使用技能触发说话
    m_bIsTalkWithHP = false,                --是否已经血量临界触发说话
    m_bIsTalkWithBeSkillHit = false,        --是否已经被特定技能击中触发说话
    m_bIsTalkWithTurn = false,              --是否已经回合数临界触发说话
    m_bIsTalkWithBeSkillHit = false,        --是否已经被特定技能击中触发说话
    
    --移动
    m_bIsMoveWithOverAtkRange = false,      --是否已经超出攻击范围触发移动
    m_bIsMoveWithOverAtkAngle = false,      --是否已经角度内无法攻击触发移动0
    m_bIsMoveWithBeHit = false,             --是否已经被击中触发移动
    m_bIsMoveWithRandom = false,            --是否已经主动随机移动
    m_bIsMoveWithTurn = false,              --是否已经回合数临界触发移动
    m_bIsMoveWithHP = false,                --是否已经血量临界触发移动
    
    --飞行
    m_bIsFlyWithOverAtkRange = false,       --是否已经超出攻击范围触发飞行
    m_bIsFlyWithBeHit = false,              --是否已经被击中触发飞行
    m_bIsFlyWithRandom = false,             --是否已经主动飞行
    m_bIsFlyWithBeSkillHit = false,         --是否已经被特定技能击中发飞行0
    m_bIsFlyWithTurn = false,               --是否已经回合数临界触发移动
    m_bIsFlyWithHP = false,                 --是否已经血量临界触发移动
    
    --技能
    m_bIsSkillUseWithHP = false,            --是否已经血量临界触发使用技能
    m_bIsSkillUseWithNear = false,          --是否已经最近距离临界触发使用技能
    m_bIsSkillUseWithFar = false,           --是否已经最远距离临界触触发使用技能0
    m_bIsSkillUseWithMap = false,           --是否已经怪在地图的指定区域触发使用技能0
    m_bIsSkillUseWithState = false,         --是否已经怪拥有某些状态触发使用技能
    m_bIsSkillUseWithTurn = false,          --是否已经回合数临界触发使用技能
    m_bIsSkillUseWithBeSkillHit = false,    --是否已经被特定技能击中触发使用技能
    m_bIsSkillUseWithRandom = false,        --是否已经主动使用技能
    
    --道具
    m_bIsItemUseWithRandom = false,         --是否已经主动使用道具
    m_bIsItemUseWithHP = false,             --是否已经血量临界触发使用道具
    m_bIsItemUseWithState = false,          --是否已经怪物拥有某些状态触发使用道具
    m_bIsItemUseWithBeSkillHit = false,     --是否已经被特定技能击中触发使用道具0
    m_bIsItemUsesWithTurn = false,          --是否已经回合数临界触发使用道具
    
    --攻击
    m_bIsAtkWithRandom = false,             --是否已经主动选择攻击目标
    m_bIsAtkWithHPMax = false,              --是否已经玩家血量最大触发选择攻击目标
    m_bIsAtkWithHPMin = false,              --是否已经玩家血量最小触发选择攻击目标0
    m_bIsAtkWithThreat = false,             --是否已经仇恨最大触发选择攻击目标
    m_bIsAtkWithNear = false,               --是否已经距离怪最近触发选择攻击目标
    m_bIsAtkWithFar = false,                --是否已经距离怪最远触发选择攻击目标0
}

--@brief	怪物的说话触发类型
WMonsterTalkTriggerType = {
    TRIGGER_SKILL = 1,          --使用技能
    TRIGGER_HP = 2,             --血量临界
    TRIGGER_BE_HIT = 3,         --被击中
    TRIGGER_TURN = 4,           --回合数临界
    TRIGGER_BE_SKILL_HIT = 5,   --被技能击中
    
}

--@brief	怪物的移动触发类型
WMonsterMoveTriggerType = {
    TRIGGER_OVER_ATK_RANGE = 1, --超出攻击范围
    TRIGGER_OVER_ATK_ANGLE = -2, --指定角度内无法攻击到目标
    TRIGGER_BE_HIT = 2,         --被击中
    TRIGGER_RANDOM = 3,         --主动随机移动
    TRIGGER_TURN = 4,           --回合数临界
    TRIGGER_HP = 5,             --血量临界
}

--@brief	怪物的飞行触发类型
WMonsterFlyTriggerType = {
    TRIGGER_OVER_ATK_RANGE = 1, --超出攻击范围
    TRIGGER_BE_HIT = 2,         --被击中
    TRIGGER_RANDOM = 3,         --主动飞行
    TRIGGER_BE_SKILL_HIT = -4, --被技能击中
    TRIGGER_TURN = 4,           --回合数临界
    TRIGGER_HP = 5,             --血量临界
}

--@brief	怪物的使用技能触发类型
WMonsterSkillTriggerType = {
    TRIGGER_HP = 1,             --血量临界
    TRIGGER_NEAR = 2,           --最近距离临界
    TRIGGER_FAR = -2.5,          --最远距离临界
    TRIGGER_MAP = -2.9,          --怪在地图的指定区域
    TRIGGER_STATE = 3,          --怪拥有某些状态
    TRIGGER_TURN = 4,           --回合数临界
    TRIGGER_RANDOM = 5,         --主动使用
    TRIGGER_BE_SKILL_HIT = 6,   --被技能击中
    
}

--@brief	怪物的使用道具触发类型
WMonsterItemTriggerType = {
    TRIGGER_RANDOM = 1,         --主动使用
    TRIGGER_HP = 2,             --血量临界
    TRIGGER_STATE = 3,          --怪拥有某些状态
    TRIGGER_BE_SKILL_HIT = -4, --被技能击中
    TRIGGER_TURN = 4,           --回合数临界
}

--@brief	怪物的选择目标触发类型
WMonsterAtkTriggerType = {
    TRIGGER_RANDOM = 1,         --主动使用
    TRIGGER_HP_MAX = 2,         --血量最高
    TRIGGER_HP_MIN = -2.5,       --血量最低
    TRIGGER_THRET = 3,          --仇恨值
    TRIGGER_NEAR = 4,           --最近距离
    TRIGGER_FAR = -4.5,          --最远距离
}

--@brief	怪物的技能类型
WMonsterSkillType = {
    SKILL_ADDTIMES_ONE = 2,		--连发+1
	SKILL_ADDTIMES_TWO = 3,		--连发+2
	SKILL_DIVIDE_THREE = 4,		--散射x3
	SKILL_ATTACKUP_FIVE = 5,	--攻击+50%
	SKILL_ATTACKUP_FOUR = 6,	--攻击+40%
	SKILL_ATTACKUP_THREE = 7,	--攻击+30%
	SKILL_ATTACKUP_TWO = 8,		--攻击+20%
	SKILL_ATTACKUP_ONE = 9,		--攻击+10%
	SKILL_DIVIDE_TWO = 18,		--散射x2
}

--@brief	怪物的道具类型
WMonsterItemType = {
    ITEM_BLOOD = 10,			--医疗包
	ITEM_BLOODT = 11,			--群体医疗
	ITEM_FROZEN = 12,			--冰冻弹
	ITEM_FOLLOW = 13,			--追踪弹
	ITEM_HIDE = 14,				--隐身
	ITEM_HIDET = 15,			--群体隐身
	ITEM_FLY = 16,				--飞行器
	ITEM_ANGER = 17,			--暴怒
}

--@brief	怪物的状态类型
WMonsterStateType = {
    STATE_BUTN = 1,             --灼烧
    STATE_POISON = 2,           --中毒
    STATE_ICE = 3,              --寒冰
    STATE_SEAL = 4,             --封技
    STATE_FLY_LOCK = 5,         --飞行锁定
    STATE_MOVE_LOCK = 6,        --移动锁定
}
-------------------------------------公有方法模块--------------------------------------
--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function WMonsterAIInterface:new()
    WZLog("WMonsterAIInterface:new")
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
    tNewObj.m_tThreatList = {}
    
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
    
    tNewObj.m_tAtkTargetList = {}
    tNewObj.m_tAtkTargetChooseTriggerList = {}
    
	return tNewObj
end

--@brief	销毁Ai接口
function WMonsterAIInterface:destroy()
    self.m_tMonster = nil
    
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
    
    self.m_tAtkTargetList = nil                    --选择目标列表
    self.m_tAtkTargetChooseTriggerList = nil       --选择目标的触发内容列表
    
    self.m_tThreatList = nil
    
end

--@brief	设置所属怪
function WMonsterAIInterface:setMonster(monster)
    self.m_tMonster = monster
end

--@brief	切换行动时重置操作
function WMonsterAIInterface:resetParam()    

    --说话
    self.m_bIsTalkWithSkill = false             --是否已经使用技能触发说话
    self.m_bIsTalkWithHP = false                --是否已经血量临界触发说话
    self.m_bIsTalkWithBeSkillHit = false        --是否已经被特定技能击中触发说话
    self.m_bIsTalkWithTurn = false              --是否已经回合数临界触发说话
    m_bIsTalkWithBeSkillHit = false             --是否已经被特定技能击中触发说话
    
    --移动
    self.m_bIsMoveWithOverAtkRange = false      --是否已经超出攻击范围触发移动
    self.m_bIsMoveWithOverAtkAngle = false      --是否已经角度内无法攻击触发移动
    self.m_bIsMoveWithBeHit = false             --是否已经被击中触发移动
    self.m_bIsMoveWithRandom = false            --是否已经主动随机移动
    self.m_bIsMoveWithTurn = false              --是否已经回合数临界触发移动
    m_bIsMoveWithHP = false                     --是否已经血量临界触发移动
    
    --飞行
    self.m_bIsFlyWithOverAtkRange = false       --是否已经超出攻击范围触发飞行
    self.m_bIsFlyWithBeHit = false              --是否已经被击中触发飞行
    self.m_bIsFlyWithRandom = false             --是否已经主动飞行
    self.m_bIsFlyWithBeSkillHit = false         --是否已经被特定技能击中发飞行
    m_bIsFlyWithTurn = false                    --是否已经回合数临界触发移动
    m_bIsFlyWithHP = false                      --是否已经血量临界触发移动
    
    --技能
    self.m_bIsSkillUseWithHP = false            --是否已经血量临界触发使用技能
    self.m_bIsSkillUseWithNear = false          --是否已经最近距离临界触发使用技能
    self.m_bIsSkillUseWithFar = false           --是否已经最远距离临界触触发使用技能
    self.m_bIsSkillUseWithMap = false           --是否已经怪在地图的指定区域触发使用技能
    self.m_bIsSkillUseWithState = false         --是否已经怪拥有某些状态触发使用技能
    self.m_bIsSkillUseWithTurn = false          --是否已经回合数临界触发使用技能
    self.m_bIsSkillUseWithBeSkillHit = false    --是否已经被特定技能击中触发使用技能
    self.m_bIsSkillUseWithRandom = false        --是否已经主动使用技能
    
    --道具
    self.m_bIsItemUseWithRandom = false         --是否已经主动使用道具
    self.m_bIsItemUseWithHP = false             --是否已经血量临界触发使用道具
    self.m_bIsItemUseWithState = false          --是否已经怪物拥有某些状态触发使用道具
    self.m_bIsItemUseWithBeSkillHit = false     --是否已经被特定技能击中触发使用道具
    m_bIsItemUsesWithTurn = false              --是否已经回合数临界触发使用道具
    
    --攻击
    self.m_bIsAtkWithRandom = false             --是否已经主动选择攻击目标
    self.m_bIsAtkWithHPMax = false              --是否已经玩家血量最大触发选择攻击目标
    self.m_bIsAtkWithHPMin = false              --是否已经玩家血量最小触发选择攻击目标
    self.m_bIsAtkWithThreat = false             --是否已经仇恨最大触发选择攻击目标
    self.m_bIsAtkWithNear = false               --是否已经距离怪最近触发选择攻击目标
    self.m_bIsAtkWithFar = false                --是否已经距离怪最远触发选择攻击目标
end

--@brief    说话文本列表
--@param	tTalkTextList:文本列表,
function WMonsterAIInterface:setTalkText(tTalkTextList)
    self.m_tTalkTextList = tTalkTextList
end

--@brief    说话
--@param	nTriggerType:触发类型, 
--@param	nIndex:说话内容的下标,
--@param	nParam1:参数1,
--@param	nParam2:参数2,
--@param	nParam3:参数3, 
function WMonsterAIInterface:setTalk(nTriggerType, nIndex, nParam1, nParam2, nParam3)
    if self.m_tTalkTriggerList == nil then
        self.m_tTalkTriggerList = {}
    end

    table.insert(self.m_tTalkTriggerList, {nTriggerType, nIndex, nParam1, nParam2, nParam3})    
end

--@brief    移动地点列表
--@param	tPointXList:地点X坐标列表, 
--@param	tPointYList:地点Y坐标列表, 
function WMonsterAIInterface:setMovePoint(tPointXList, tPointYList)
    self.m_tMovePointXList = tPointXList
    self.m_tMovePointYList = tPointYList
end

--@brief    移动
--@param	nTriggerType:触发类型,
--@param	nIndex:移动地点的下标,
--@param	nParam1:参数1,
--@param	nParam2:参数2,
--@param	nParam3:参数3,
function WMonsterAIInterface:setMove(nTriggerType, nIndex, nParam1, nParam2, nParam3)
    if self.m_tMoveTriggerList == nil then
        self.m_tMoveTriggerList = {}
    end
    
    table.insert(self.m_tMoveTriggerList, {nTriggerType, nIndex, nParam1, nParam2, nParam3})
end

--@brief    飞行地点列表
--@param	tPointXList:地点X坐标列表,
--@param	tPointYList:地点Y坐标列表,
function WMonsterAIInterface:setFlyPoint(tPointXList, tPointYList)
    self.m_tFlyPointXList = tPointXList
    self.m_tFlyPointYList = tPointYList
end

--@brief    飞行
--@param	nTriggerType:触发类型,
--@param	nIndex:飞行地点的下标,
--@param	nParam1:参数1,
--@param	nParam2:参数2,
--@param	nParam3:参数3,
function WMonsterAIInterface:setFly(nTriggerType, nIndex, nParam1, nParam2, nParam3)
    if self.m_tFlyTriggerList == nil then
        self.m_tFlyTriggerList = {}
    end
    
    table.insert(self.m_tFlyTriggerList, {nTriggerType, nIndex, nParam1, nParam2, nParam3})
end

--@brief    技能列表
--@param	tSkillList:技能列表,
function WMonsterAIInterface:setSkill(tSkillList)
    self.m_tSkillList = tSkillList
end

--@brief    技能
--@param	nTriggerType:触发类型,
--@param	nIndex:技能的下标,
--@param	nParam1:参数1,
--@param	nParam2:参数2,
--@param	nParam3:参数3,
function WMonsterAIInterface:setSkillUse(nTriggerType, nIndex, nParam1, nParam2, nParam3)
    if self.m_tSkillTriggerList == nil then
        self.m_tSkillTriggerList = {}
    end
    
    table.insert(self.m_tSkillTriggerList, {nTriggerType, nIndex, nParam1, nParam2, nParam3})
end

--@brief    道具列表
--@param	tItemList:道具列表,
function WMonsterAIInterface:setItem(tItemList)
    self.m_tItemList = tItemList
end

--@brief    道具
--@param	nTriggerType:触发类型,
--@param	nIndex:道具的下标,
--@param	nParam1:参数1,
--@param	nParam2:参数2,
--@param	nParam3:参数3,
function WMonsterAIInterface:setItemUse(nTriggerType, nIndex, nParam1, nParam2, nParam3)
    if self.m_tItemTriggerList == nil then
        self.m_tItemTriggerList = {}
    end
    
    table.insert(self.m_tItemTriggerList, {nTriggerType, nIndex, nParam1, nParam2, nParam3})
end

--@brief    攻击目标列表
--@param	tAtkTargetList:攻击列表,
function WMonsterAIInterface:setAtkTarget(tAtkTargetList)
    self.m_tAtkTargetList = tAtkTargetList
end

--@brief    攻击
--@param	nTriggerType:触发类型,
--@param	nIndex:攻击的下标,
--@param	nParam1:参数1,
--@param	nParam2:参数2,
--@param	nParam3:参数3,
function WMonsterAIInterface:setAtkTargetChoose(nTriggerType, nIndex, nParam1, nParam2, nParam3)
    if self.m_tAtkTargetChooseTriggerList == nil then
        self.m_tAtkTargetChooseTriggerList = {}
    end
    
    table.insert(self.m_tAtkTargetChooseTriggerList, {nTriggerType, nIndex, nParam1, nParam2, nParam3})
end

--@brief    获取仇恨值X的玩家
--@param	nRanking:排名
function WMonsterAIInterface:getThreatPlayer(nRanking)
    WZLog("WMonsterAIInterface:getThreatPlayer0", BattleCommon:tableLen(self.m_tThreatList))
    nRanking = math.abs(nRanking)
    local threatMax = 0
    local threatMaxPlayer = WMonster:getRandomPlayer()
    local cleanPlayerList = {}
    
    for i, v in pairs(self.m_tThreatList) do
        WZLog("WMonsterAIInterface:getThreatPlayer0.5")
        if WBattleGlobal:getCurrent():getCharacterWithId(i):isDead() then
            WZLog("WMonsterAIInterface:getThreatPlayer0.5 dead", i)
           table.insert(cleanPlayerList, i)            
        end
    end
    
    for i, v in pairs(cleanPlayerList) do
        WZLog("WMonsterAIInterface:getThreatPlayer0.9", v, BattleCommon:tableLen(self.m_tThreatList))
        table.remove(self.m_tThreatList, v)
    end
    
    
    local sortThreatList = {}
    local sortMax = 1
    local sortValue = nil
    for i, v in pairs(self.m_tThreatList) do
        WZLog("WMonsterAIInterface:getThreatPlayer1")
        if sortValue == nil or v > self.m_tThreatList[sortValue] then
            sortValue = i
            WZLog("WMonsterAIInterface:getThreatPlayer1", sortValue)
        end
    end
    if sortValue ~= nil then
        table.insert(sortThreatList, sortMax, sortValue)
    end
    
    ---[[
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
    --]]
    
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
    WZLog("WMonsterAIInterface:getThreatPlayer", nRanking, tostring(chooseMode), BattleCommon:tableLen(self.m_tThreatList), BattleCommon:tableLen(sortThreatList), tostring( sortThreatList[sortMin] ), tostring( sortThreatList[sortMax] ), sortMin)
    
    if threatMaxPlayer == nil then
        threatMaxPlayer = WMonster:getRandomPlayer()
    end
    return threatMaxPlayer
end

--@brief    获取状态
function WMonsterAIInterface:getState()
    local state = 0
    if self.m_tMonster.m_tHurtAnim ~= nil then
        if self.m_tMonster.m_tHurtAnim["butn"] ~= nil then
            state = WMonsterStateType.STATE_BUTN
        elseif self.m_tMonster.m_tHurtAnim["poison"] ~= nil then
            state = WMonsterStateType.STATE_POISON
        elseif self.m_tMonster.m_tHurtAnim["ice"] ~= nil then
            state = WMonsterStateType.STATE_ICE
        end
    elseif self.m_tMonster.m_nDebuffSealRound ~= nil then
        state = WMonsterStateType.STATE_SEAL
    elseif self.m_tMonster.m_nDebuffFlyLockRound ~= nil then
        state = WMonsterStateType.STATE_FLY_LOCK
    elseif self.m_tMonster.m_nDebuffMoveLockRound ~= nil then
        state = WMonsterStateType.STATE_MOVE_LOCK
    end
        
    return state
end


-------------------------------------私有方法模块--------------------------------------
