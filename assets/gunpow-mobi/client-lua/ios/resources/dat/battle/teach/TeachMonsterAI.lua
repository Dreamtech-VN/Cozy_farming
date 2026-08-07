--TeachMonsterAI.lua
--@brief	怪物的Ai数据表
--@date		2014/11/5
--@author	莫剑峰
--@note

--@brief	怪物的Ai数据表
TeachMonsterAI = {
	m_nCurStatus = 0,       --状态
    m_tBoss = nil,          --AI对应的怪物
    m_nCharacterId,         --角色ID
    m_tRandNumList = nil,   --战斗随机数组
    m_nRandNumIndex = 0,    --战斗随机数组下标
    m_nCurRandNum = 0,      --当前回合随机数
    m_tSkills = nil,        --技能列表
    m_tItems = nil,         --道具列表
    m_nSkillItemId = 0,     --使用的AI策略
    m_tAction = nil,        --动作类型顺序表
	m_nDt = 0,              --调用时间累加
	m_bMoved = false,       --是否移动
    m_tAiInterface = nil,   --AI接口
    m_tMovePos = nil,       --移动地点
    m_tFlyPos = nil,        --飞行地点
    m_nSkillId = 0,         --技能Id
    m_nItemId = 0,          --道具Id
    m_nHPWithTurnStart = 0, --回合开始时的血量
    m_bIsAtked = false,     --本回合是否已经攻击过
    m_bUseBigSkill = false, --是否使用了大招
    m_runTime = 0,          --本回合经过了的时间
    m_bIsDead = false,      --是否死亡
    m_bIsAddFlyWithNextTurn = false,    --下一回合是否一定飞行
    m_tCheckOnceArray = nil,            --只检测一次
}

-------------------------------------公有方法模块--------------------------------------
--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function TeachMonsterAI:new(nCharacterId)
    -- WZLog("TeachMonsterAI:new")
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
    tNewObj.m_nCharacterId = nCharacterId
    tNewObj:setBoss(WBattleGlobal:getCurrent():getCharacterWithId(nCharacterId))
    tNewObj.m_tAction = {}
    
    --[[
    --过关条件
    WBattleGlobal:getCurrent().m_bIsSingleChallengeGameOver = false
    WBattleGlobal:getCurrent():setCleanCondition(SingleChallengeCleanCondition.TYPE_GUAI_DESTROY)
    --]]
    
	return tNewObj
end

--@brief	销毁
function TeachMonsterAI:destroy()

    --self:getAiInterface():destroy()

    self.m_nCurStatus = 0
    self.m_tBoss = nil
    self.m_tRandNumList = nil   --战斗随机数组
    self.m_nRandNumIndex = 0    --战斗随机数组下标
    self.m_nCurRandNum = 0      --当前回合随机数
    self.m_tSkills = nil        --技能列表
    self.m_tItems = nil         --道具列表
    self.m_nSkillItemId = 0     --使用的AI策略
    self.m_tAction = nil        --动作类型顺序表
    self.m_nDt = 0              --调用时间累加
    self.m_bMoved = false       --是否移动
    self.m_tAiInterface = nil   --AI接口
    self.m_tMovePos = nil       --移动地点
    self.m_tFlyPos = nil        --飞行地点
    self.m_nSkillId = 0         --技能Id
    self.m_nItemId = 0          --道具Id
    self.m_nHPWithTurnStart = 0 --回合开始时的血量
    self.m_bIsAtked = false     --本回合是否已经攻击过
    self.m_bUseBigSkill = false --是否使用了大招
    self.m_runTime = 0
    self.m_bIsAddFlyWithNextTurn = false
    self.m_tCheckOnceArray = nil
end

--@brief	设置AI接口
function TeachMonsterAI:setAiInterface()
    if self.m_tAiInterface ~= nil then
        return
    end
    self.m_tAiInterface = TeachMonsterAIInterface:new()
    self:getAiInterface():setMonster(self.m_tBoss)
    
    if self.m_tBoss.m_tDialogue then
        for i, v in pairs (self.m_tBoss.m_tDialogue) do
            -- WZLog("TeachMonsterAI:setAiInterface 对话:", v, i)
        end
        self.m_tAiInterface:setTalkText(self.m_tBoss.m_tDialogue)
    end
    
    for i, v in pairs (self.m_tBoss.m_tAiScript) do
        -- WZLog("TeachMonsterAI:setAiInterface AI:", tonumber(v[1]), tonumber(v[2]), tonumber(v[3]), tonumber(v[4]), tonumber(v[5]))
        
        local actType = tonumber(v[1])
        local triggerType = tonumber(v[2])
        local param = tonumber(v[3])
        local paramXorId = tonumber(v[4])
        local paramY = tonumber(v[5])
        
        ---[[
        if actType == 1 then
            self:getAiInterface():setAtkTarget(WBattleGlobal:getCurrent():getHeroList())
            self:getAiInterface():setAtkTargetChoose(triggerType, param)
            
        elseif actType == 2 then
            self:getAiInterface():setTalk(triggerType, paramXorId, param)
            
        elseif actType == 3 then
            self:getAiInterface():setSkillUse(triggerType, paramXorId, param)
            
        elseif actType == 4 then
            local index = i
            if paramXorId ~= nil then
                table.insert(self:getAiInterface().m_tMovePointXList, i, paramXorId)
                table.insert(self:getAiInterface().m_tMovePointYList, i, paramY)
            else
                index = -1
            end
            self:getAiInterface():setMove(triggerType, index, param, paramXorId, paramY)
            
        elseif actType == 5 then
            local index = i
            if paramXorId ~= nil then
                table.insert(self:getAiInterface().m_tFlyPointXList, i, paramXorId)
                table.insert(self:getAiInterface().m_tFlyPointYList, i, paramY)
            else
                index = -1
            end
            self:getAiInterface():setFly(triggerType, index, param, paramXorId, paramY)
            
        elseif actType == 6 then
            self:getAiInterface():setItemUse(triggerType, paramXorId, param)            
        end
        --]]
    end


    for j, u in pairs (TeachMonsterSkillType) do
        table.insert(self:getAiInterface().m_tSkillList, u, u)
    end
    for j, u in pairs (TeachMonsterItemType) do
        table.insert(self:getAiInterface().m_tItemList, u, u)
    end

    for j, u in pairs (self:getAiInterface().m_tFlyPointXList) do
        -- WZLog("m_tFlyPointXList = ", j, u, self:getAiInterface().m_tFlyPointYList[j])
    end

    --self:getAiInterface():setAtkTargetChoose(TeachMonsterAtkTriggerType.TRIGGER_THRET, 2)

    --self:getAiInterface():setSkillUse(TeachMonsterSkillTriggerType.TRIGGER_TURN, 4, 1)
    --self:getAiInterface():setItemUse(TeachMonsterItemTriggerType.TRIGGER_TURN, 13, 1)

    --self:getAiInterface():setSkillUse(TeachMonsterSkillTriggerType.TRIGGER_RANDOM, 5000)
    --self:getAiInterface():setItemUse(TeachMonsterItemTriggerType.TRIGGER_RANDOM, BattleHeroUse.ITEM_HIDET, 5000)
end

--@brief	获取AI接口
function TeachMonsterAI:getAiInterface()
    return self.m_tAiInterface
end

--@brief	获取当前随机数
function TeachMonsterAI:getCurRandNum()
    self.m_tRandNumList = WBattleGlobal:getCurrent().m_tBattleRand
    self.m_nRandNumIndex = (self.m_nRandNumIndex + math.abs(self.m_tBoss:getBattleId()) ) % 10 + 1
    self.m_nCurRandNum = self.m_tRandNumList[self.m_nRandNumIndex]
    
    return self.m_nCurRandNum
end


--@brief	开始行动
function TeachMonsterAI:startRound()
    -- WZLog("TeachMonsterAI:startRound", self.m_tBoss.m_nAiType)
    
    self.m_tRandNumList = WBattleGlobal:getCurrent().m_tBattleRand
    self.m_nRandNumIndex = (WBattleGlobal:getCurrent():getTurnTimes() + math.abs(self.m_tBoss:getBattleId())) % 10 + 1
    self.m_nCurRandNum = self.m_tRandNumList[self.m_nRandNumIndex]
    
    self:getAiInterface():resetParam()
    self.m_nHPWithTurnStart = self.m_tBoss:getHp()
    self.m_tMovePos = nil
    self.m_tFlyPos = nil
    self.m_nSkillId = 0
    self.m_nItemId = 0
    self.m_bMoved = false
    self.m_bIsAtked = false
    self.m_bUseBigSkill = false
    self.m_runTime = 0
    self.m_tCheckOnceArray = {}
    for i=1,10 do
        self.m_tCheckOnceArray[i] = false
    end

    if WBattleGlobal:getCurrent().m_tUseSkillItemInCurTurnList ~= nil then
        WBattleGlobal:getCurrent().m_tUseSkillItemInCurTurnList = {}
    end
    
    -- WZLog("TeachMonsterAI:startRound is my trun", WBattleGlobal:getCurrent():getCurrentCharacter():getId(), self.m_tBoss:getSp())
    if self.m_tBoss.m_nAiType == MonsterAiType.AI_ROBOT and WBattleGlobal:getCurrent():getCurrentCharacter():getId() == self.m_tBoss:getId() then
        self.m_nCurStatus = -1
        
        if self.m_nCharacterId == 0 then
            self.m_nCharacterId = self.m_tBoss:getBattleId()
        end
        
        local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCharacterId)
        hero:setPF(100)
        if hero:getSp() <= 0 then
            --hero:setSp(80)
        end
        self:addAction(0)
        self:resetParam()
        
    elseif  WBattleGlobal:getCurrent():getCurrentCharacter():getBattleId() == self.m_tBoss:getBattleId() then
        
        self.m_nCurStatus = -1
        self.m_nCharacterId = self.m_tBoss:getBattleId()
        
        local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCharacterId)
        hero:setPF(100)
        --hero:setSp(80)
        self:addAction(0)
        self:resetParam()
    end
    
    
    
    local tPlayerList = WBattleGlobal:getCurrent():getHeroList()
	for i,player in pairs(tPlayerList) do
        -- WZLog("TeachMonsterAI:startRound hp Player = ", player:getHp(), player:getId(), player:getBattleId())
	end
    
    local tGuaiList = WBattleGlobal:getCurrent():getGuaiList()
	for i,player in pairs(tGuaiList) do
        -- WZLog("TeachMonsterAI:startRound hp Guai = ", player:getHp(), player:getId(), player:getBattleId())
	end
end

--@brief	结束行动
function TeachMonsterAI:endRound()
    ---- WZLog("TeachMonsterAI:endRound")
    if self.m_tAction and #self.m_tAction>0 then
		for i=#self.m_tAction,1,-1 do
			table.remove(self.m_tAction,i)
		end
		self:resetParam()
	end
    self.m_nCurStatus = 0
end

--@brief	切换行动时重置操作
function TeachMonsterAI:resetParam()
    
	self.m_nDt = 0
end

--@brief	增加一个动作
--@param	nActionType,动作类型
function TeachMonsterAI:addAction(nActionType)
	if self.m_tAction == nil then
		self.m_tAction = {}
	end
	table.insert(self.m_tAction,nActionType)
end

--@brief	执行下一个动作
function TeachMonsterAI:doNextAction()
	if self.m_tAction and #self.m_tAction>0 then
		table.remove(self.m_tAction,1)
		self:resetParam()
    else
		self:endRound()
	end
end

--@brief    设置AI对应的怪
function TeachMonsterAI:setBoss(tBoss)
	self.m_tBoss = tBoss
end

--@brief	消息处理完成函数
--@note		结束当前回合
function TeachMonsterAI:nextRound()
    -- WZLog("TeachMonsterAI:nextRound")

    local msg = MsgManager:createMsg(BattleMsgEndCurRound)
    msg.m_nBattleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
    msg.m_nPlayerId = WBattleGlobal:getCurrent():getMyHero():getId()
    msg.m_nCurrentPlayerId = WBattleGlobal:getCurrent():getMyHero():getId()
    msg.m_nPlayerOrGuai = WBattleGlobal:getCurrent():getMyHero():getType()
    msg.note =17
    MsgManager:pushBlockMsg(msg)
end

--@brief	运作
--@param	dt:距离上一次调用的时间（秒）
function TeachMonsterAI:run(dt)
    do return end
end

--@brief	小怪近身行动
function TeachMonsterAI:meleeAction()
    -- WZLog("TeachMonsterAI:meleeAction")
    if self.m_bIsAtked == true then
        return
    else
        self.m_bIsAtked = true
    end
    
	if self.m_tBoss:_shouldAttack() or self.m_bMoved == true then
        self:meleeAtk()
    else
        self:move(true, true)
	end
end

--@brief	近身移动
function TeachMonsterAI:move(bIsEndCurRound, bIsAtkAfterMove)
    -- WZLog("TeachMonsterAI:move 0", tostring( bIsEndCurRound), tostring(bIsAtkAfterMove), tostring( self.m_tBoss:getId()), tostring(self.m_tBoss.m_nAiType))
    ---[[
    if self.m_bMoved == true then
        
        return
    else
        self.m_bMoved = true
    end
    --]]
    if bIsAtkAfterMove == nil then
        bIsAtkAfterMove = false
    end
    local tPos = self.m_tMovePos
    if self.m_tBoss.m_nAiType == MonsterAiType.AI_ROBOT then
        self:moveRobot(tPos)
    else
        local msg = MsgManager:createMsg(BattleMsgMonsterMove)
        msg.m_bIsEndCurRound = bIsEndCurRound
        msg.m_bIsAtkAfterMove = bIsAtkAfterMove
        msg.m_tGuai = self.m_tBoss
        msg.m_tPos = tPos
        MsgManager:pushBlockMsg(msg)
    end
end

--@brief	近身攻击
function TeachMonsterAI:meleeAtk()
    -- WZLog("TeachMonsterAI:meleeAtk")
    
    local msg = MsgManager:createMsg(BattleMsgMonsterMeleeAttack)
    msg.m_tGuai = self.m_tBoss
    MsgManager:pushBlockMsg(msg)
end

--@brief	远程攻击
function TeachMonsterAI:rangedAtk()
    if self.m_bIsAtked == true then
        return
    else
        self.m_bIsAtked = true
    end
    -- WZLog("TeachMonsterAI:rangedAtk", tostring(self.m_tBoss.m_sWeaponName))
    
    local tPos = self.m_tMovePos
    if self.m_tBoss.m_nAiType == MonsterAiType.AI_ROBOT then
        self:rangedAtkRobot()
    else        
        self.m_tBoss:sendAiProcol(MonsterAiType.AI_RANGED)
        local msg = MsgManager:createMsg(BattleMsgBossMapShoot)
        if self.m_tBoss.m_bIsOldAnim == true then
            msg.m_sBulletAnimMainName = IWCO_BATTLEEFFICIENTS
            msg.m_sBulletAnimFlyName = "fly1"
        else
            msg.m_sBulletAnimMainName = self.m_tBoss.m_sAniFileId.."_w"
            msg.m_sBulletAnimFlyName = "0"
        end
        msg.m_tOwner = self.m_tBoss
        msg.m_tTargetHero = self.m_tBoss.m_tTargetPlayer
        if self.m_tBoss.m_bIsOldAnim == true then
            msg.m_sReadyShootAnim = "ranged_attack1"
        else
            msg.m_sReadyShootAnim = "2"
        end
        
        msg.m_nAttack = self.m_tBoss.m_nAttack
        msg.m_tAcceleration = {x=WBattleGlobal:getCurrent():getWind().x+BattleConstants.g_nFlyGravity.x,y=WBattleGlobal:getCurrent():getWind().y+BattleConstants.g_nFlyGravity.y}
        msg.m_tWeaponAnim = {weapon=self.m_tBoss.m_sWeaponName} --{weapon="weapon17a"}
        
        msg.m_nBulletAnimScale = 1.5                --默认值是1
        msg.m_nBulletType = 0                       --默认值是1(直线)
        msg.m_nCheckCharacterCollisionRadius = 40   --默认值是2
        msg.m_bIsPenetrateMap = true                --默认值是true
        msg.m_nAttTimes = 1                         --默认值是1
        msg.m_bIsIgnoreDef = false                   --默认值是false
        msg.m_bBulletAnimFlipX = false              --默认值是false
        msg.m_bIsNeedExplode = true                --默认值是false
        msg.m_nBulletAnimDefaultDirection = 1       --默认值是1(向左)
        msg.m_nEveryBulletShootDeltaTime = 0.4      --默认值是0.7
        
        MsgManager:pushBlockMsg(msg)
    end
end

--@brief	AI移动
function TeachMonsterAI:moveRobot(tPos)
    -- WZLog("TeachMonsterAI:moveRobot")
	local hero = self.m_tBoss
    
	local movetime = math.min(hero:getPF(), self:getCurRandNum() % 31 + 20)
    
	if movetime > 0 then
		local nBattleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
		local nPlayerId = self.m_nCharacterId
		local sPos = hero:getPosition()
		local face = self:getCurRandNum() % 2
        if tPos ~= nil then
            if hero:getPosition().x < tPos.x then
                face = 0
            else
                face = 1
            end
        end
        
		--不允许走到屏幕边缘
		if hero:getPosition().x < 100 then
			-- WZLog("Can't no move Left")
			face = 0
            elseif hero:getPosition().x > SceneBattle:getFrontLayerSize().width - 100 then
			-- WZLog("Can't no move Right")
			face = 1
		end
		local movestep = {}
		for i = 1, movetime do
			table.insert(movestep, face)
		end
        
        -- WZLog("TeachMonsterAI:_move movetime = "..movetime.." sPos.x = "..sPos.x.." sPos.y = "..sPos.y)
        local msg = MsgManager:createMsg(BattleMsgPlayerMove)
		msg.m_nBattleId = nBattleId
		msg.m_nCurrentPlayerId = nPlayerId
		msg.m_nMovecount = movetime
		msg.m_tMovestep = movestep
		msg.m_nCurPositionX = math.floor(sPos.x)
		msg.m_nCurPositionY = math.floor(sPos.y)
		MsgManager:pushBlockMsg(msg)
	end
end

--@brief	AI射击
function TeachMonsterAI:rangedAtkRobot()
    -- WZLog("TeachMonsterAI:shoot")
    
    
	local hero = self.m_tBoss
    
    local aimHero = self.m_tBoss.m_tTargetPlayer
    if aimHero == nil then
        -- WZLog("No aimHero,use myHero instead")
        aimHero = WBattleGlobal:getCurrent():getMyHero()
    end
    local sPos = hero:getPosition()
    local ePos = aimHero:getPosition()
    local angle
    local face
    
    if ePos.x <= sPos.x then
		face = 1
		angle = -30 -90;
        sPos = BattleCommon:getShootPos(true)
		--sPos.x = sPos.x - 40;
		--sPos.y = sPos.y + 30 * 2;
    else
		face = 0
		angle = -30;
        sPos = BattleCommon:getShootPos(false)
		--sPos.x = sPos.x + 40;
		--sPos.y = sPos.y + 30 * 2;
	end

    local isAtkSucceed = false
    local power= (self:getCurRandNum() % 4 + 1) * SceneBattle:getFrontLayer():getScale() * 0.9;
    local speed = BattleCommon:angleToPoint(BattleCommon:degressToRadius(-angle))
    isAtkSucceed, speed = BattleCommon:vectorNormalize(speed)
    isAtkSucceed, power = BattleCommon:getStartSpeedPowerWithSpeed(speed, sPos, ePos, power)
    if isAtkSucceed == false then
        speed = self:_shootLine()
    else
        speed.x = speed.x * power
        speed.y = speed.y * power
    end
    
    local tan = speed.y / speed.x
    local arctan = math.atan(tan)
    local deg = math.deg(arctan)
    -- WZLog("TeachMonsterAI:rangedAtkRobot ", isAtkSucceed, speed.x, speed.y)
    
    local msg = MsgManager:createMsg(BattleMsgPlayerShoot)
    msg.m_nBattleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
    msg.m_nPlayerId = self.m_nCharacterId
    msg.m_nCurrentPlayerId = self.m_nCharacterId
    msg.m_nSpeedx = math.ceil(speed.x)
    msg.m_nSpeedy = math.ceil(speed.y)
    msg.m_nLeftRight = face
    msg.m_nStartX = sPos.x
    msg.m_nStartY = sPos.y
    MsgManager:pushBlockMsg(msg)
    
end

--@brief	AI飞行
function TeachMonsterAI:fly()
    -- WZLog("TeachMonsterAI:fly")
    local tPos = self.m_tFlyPos
	local hero = self.m_tBoss
    
	local aimHero = TeachMonster:getRandomPlayer()
	if aimHero == nil then
		-- WZLog("No aimHero,use myHero instead")
		aimHero = WBattleGlobal:getCurrent():getMyHero()
	end
	local sPos = hero:getPosition()
	local ePos = aimHero:getPosition()
    if tPos ~= nil and tPos.x ~= -1  then
        ePos = {}
        ePos.x = tPos.x
        ePos.y = tPos.y
        tPos = nil
    end
    
	local angle
	local face
    
	local s = self:getCurRandNum() % 2
	local dis = self:getCurRandNum() % 301
	if s == 0 then
		ePos.x = ePos.x + dis
    else
		ePos.x = ePos.x - dis
	end
    
	if ePos.x <= sPos.x then
		face = 1
		angle = -20 - (self:getCurRandNum() % 21) -90
		sPos = BattleCommon:getShootPos(true)
    else
		face = 0
		angle = -20 - (self:getCurRandNum() % 21)
		sPos = BattleCommon:getShootPos(false)
	end
    
	local power= 3 * SceneBattle:getFrontLayer():getScale();
	local speed = BattleCommon:angleToPoint(BattleCommon:degressToRadius(-angle))
	_, speed = BattleCommon:vectorNormalize(speed)
	_, power = BattleCommon:getStartSpeedPowerWithSpeed(speed, sPos, ePos, power)
	speed.x = speed.x * power
	speed.y = speed.y * power
    
	local nBattleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
	local nPlayerId = self.m_nCharacterId
	local nPlayerCount = 0
	local tPlayerId = {}
	local nIsEquip = 0
	local tCurPositionX = {}
	local tCurPositionY = {}
	for id, player in pairs(WBattleGlobal:getCurrent().m_tHeros) do
		table.insert(tPlayerId, id)
		table.insert(tCurPositionX, player:getMover():getMoverPosition().x)
		table.insert(tCurPositionY, player:getMover():getMoverPosition().y)
		nPlayerCount = nPlayerCount + 1
	end
    
	local guaiCount = 0
	local guaiBattleIds = {}
	local guaiCurPosX = {}
	local guaiCurPosY = {}
	if WBattleGlobal:getCurrent():getGuaiList() ~= nil then
		for id,guai in pairs(WBattleGlobal:getCurrent():getGuaiList()) do
			table.insert(guaiBattleIds, id)
			table.insert(guaiCurPosX, guai:getAnimation():getPosition().x)
			table.insert(guaiCurPosY, guai:getAnimation():getPosition().y)
			guaiCount = guaiCount + 1
		end
	end
    
    hero.m_mover:setMoverSpeed(Vector2:create(3,-1))
    
    local msg = MsgManager:createMsg(BattleMsgPlayerFly)
    msg.m_nBattleId = nBattleId
    msg.m_nPlayerId = nPlayerId
    msg.m_nCurrentPlayerId = nPlayerId
    msg.m_nStartX = sPos.x
    msg.m_nStartY = sPos.y
    msg.m_nLeftRight = face
    msg.m_nIsEquip = nIsEquip
    msg.m_nSpeedx = math.floor(speed.x)
    msg.m_nSpeedy = math.floor(speed.y)
    msg.m_nPlayerCount = nPlayerCount
    msg.m_tPlayerId = tPlayerId
    msg.m_tCurPositionX = tCurPositionX
    msg.m_tCurPositionY = tCurPositionY
    msg.m_nGuaiCount = guaiCount
    msg.m_tGuaiBattleId = guaiBattleIds
    msg.m_tGuaiCurPositionX = guaiCurPosX
    msg.m_tGuaiCurPositionY = guaiCurPosY
    
    -- WZLog("TeachMonsterAI:fly", msg.m_nSpeedx, msg.m_nSpeedy, ePos.x, ePos.y , sPos.x, sPos.y)
    MsgManager:pushBlockMsg(msg)
end

--@brief	AI使用技能
function TeachMonsterAI:useSkill()
    -- WZLog("TeachMonsterAI:useSkill")
	local hero = self.m_tBoss
    
    local i = (self:getCurRandNum() + self:getCurRandNum() % 3 )% BattleCommon:tableLen(self:getAiInterface().m_tSkillList) + 1
    local skillId
    local index = 0
    for j, v in pairs(self:getAiInterface().m_tSkillList ) do
        index = index + 1
        if i == index then
            skillId = v
        end
    end

    if self.m_nSkillId > 0 then
        skillId = self.m_nSkillId
        self.m_nSkillId = 0
    end
    ---- WZLog("TeachMonsterAI:useSkill OK"..skillId.." "..tostring(self.m_nSkillId).." ")
    
    if BattleHeroUse:heroUse(self.m_nCharacterId, BattleHeroUse.USE_SKILL_OR_ITEM, skillId) then
        
        for i, talkTrigger in pairs(self:getAiInterface().m_tTalkTriggerList) do
            if not self:getAiInterface().m_bIsTalkWithSkill and talkTrigger[1] == TeachMonsterTalkTriggerType.TRIGGER_SKILL and skillId == talkTrigger[3] then
                local talkIndex = talkTrigger[2]
                -- WZLog("TeachMonsterTalkTriggerType.TRIGGER_SKILL")
                self:getAiInterface().m_bIsTalkWithSkill = true
                self:talk(self:getAiInterface().m_tTalkTextList[talkIndex])
                talkTriggerWithHp = i
            end
        end
        
        local vector = WZLuaVector_int_:create()
        vector:push(skillId)
        ProtocolProcessorBattleInterface:send_BATTLE_SkillEquip(WBattleGlobal:getCurrent():getBattleId(), self.m_nCharacterId, 1, vector, 1)
        return false
    end
end

--@brief	AI使用道具
function TeachMonsterAI:useItem()
	local hero = self.m_tBoss
    
    local i = (self:getCurRandNum() + self:getCurRandNum() % 3 )% BattleCommon:tableLen(self:getAiInterface().m_tItemList) + 1
    local itemId
    local index = 0
    local isCanUseBlood = false

    for j, v in pairs(self:getAiInterface().m_tItemList ) do
        index = index + 1
        if i == index then
            if ((v ~= BattleHeroUse.ITEM_BLOOD and v ~= BattleHeroUse.ITEM_BLOODT) or ((v == BattleHeroUse.ITEM_BLOOD or v == BattleHeroUse.ITEM_BLOODT) and self.m_tBoss:getHp() < self.m_tBoss:getMaxHp())) and v ~= BattleHeroUse.ITEM_FLY then

                itemId = v
            else
                index = index - 1
            end
        end
    end

    if self.m_nItemId > 0 then
        itemId = self.m_nItemId
        self.m_nItemId = 0
    end
    -- WZLog("TeachMonsterAI:useItem OK", tostring(itemId))
    if BattleHeroUse:heroUse(self.m_nCharacterId,BattleHeroUse.USE_SKILL_OR_ITEM,itemId) then
        local vector = WZLuaVector_int_:create()
        vector:push(itemId)
        --ProtocolProcessorBattleInterface:send_BATTLE_SkillEquip(WBattleGlobal:getCurrent():getBattleId(), self.m_nCharacterId, 1, vector, 1)
        --table.remove(self.m_tItems, 1)
    end
end

--@brief	设置技能列表
function TeachMonsterAI:setSkillList(tSkillList)
	self.m_tSkills = tSkillList
    if self:getAiInterface() ~= nil then
        self:getAiInterface():setSkill(tSkillList)
    end
end

--@brief	设置道具列表
function TeachMonsterAI:setItemList(tItemList)
	self.m_tItems = tItemList
    if self:getAiInterface() ~= nil then
        self:getAiInterface():setItem(tItemList)
    end
end

--@brief        剧情对话
--@param		text:对话的内容
--@param		needZoomToMonster:对话的内容
function TeachMonsterAI:talk(text, needZoomToMonster)
    -- WZLog("TeachMonsterAI:talk :---"..text.."---end")
    local msg = MsgManager:createMsg(BattleMsgStoryTalk)
    msg.m_sTalkText = text          --文本内容
    msg.m_nMaxWidth = 280           --最大宽度
    msg.m_nScale = 1.0              --缩放大小
    msg.m_bNeedZoomToBoss = needZoomToMonster   --是否需要把屏幕移向怪
    msg.m_tOwner = self.m_tBoss
    msg.m_tFollowObj = self.m_tBoss
    msg.m_bIsUpdatePos = true
    msg.m_nTime = 3
    
    local height = nil
    local width = nil
    WZLog("TeachMonsterAI:talk", tostring(self.m_tBoss.m_tCollisionRang))
    if self.m_tBoss.m_tCollisionRang ~= nil then
        height = self.m_tBoss.m_tCollisionRang[1].m_fHeight * 0.7
        width = self.m_tBoss.m_tCollisionRang[1].m_fWidth * 0.4
    elseif self.m_tBoss.m_nAiType == MonsterAiType.AI_ROBOT then
        height = 70
        width = 50
    end

    if self.m_tBoss:getPosition().x < 450 then
        msg.m_nDirection = CellDialog.DIR_RIGHT
        msg.m_tPosOffset = ccp(width, height)   --位置偏移量
    elseif self.m_tBoss:getPosition().x > 1200 then
        msg.m_nDirection = CellDialog.DIR_LEFT
        msg.m_tPosOffset = ccp(-width, height)   --位置偏移量
    else
        if self.m_tBoss.m_bIsFilpX == true then
            msg.m_nDirection = CellDialog.DIR_LEFT
            msg.m_tPosOffset = ccp(-width, height)   --位置偏移量
        else
            msg.m_nDirection = CellDialog.DIR_RIGHT
            msg.m_tPosOffset = ccp(width, height)   --位置偏移量
        end
    end
    MsgManager:pushBlockMsg(msg)
end
    
    
    
    
    
    
    
    
-------------------------------------私有方法模块--------------------------------------
--@brief	计算直线射击
--@return   发射速度
function TeachMonsterAI:_shootLine(shootPower)
    local hero = self.m_tBoss

    local targetHero = self.m_tBoss.m_tTargetPlayer

    local eOffset = ccp(targetHero.m_anim:getAnimNode():getContentSize().width * 0, targetHero.m_anim:getAnimNode():getContentSize().height * 0.3)
    local sPos = ccp(hero:getPosition().x, hero:getPosition().y)
    local ePos = ccp(targetHero:getPosition().x + eOffset.x,targetHero:getPosition().y + eOffset.y)
    local angle
    local face

    local power = 15
    local scale = 2
    if shootPower ~= nil then
        scale = shootPower
    end
    local speed = {}

    if ePos.x <= sPos.x then
        face = 1
    else
        face = 0
    end

    if face == 1 then
        speed.x = -1 * scale
    else
        speed.x = scale
    end

    --斜率公式
    if (ePos.x - sPos.x == 0) then
        speed.x = 0
        speed.y = 10
    elseif (ePos.y - sPos.y == 0) then
        if (ePos.x - sPos.x >= 0) then
            speed.x = 10
        else
            speed.x = -10
        end
        speed.y = 5
    else
        speed.y = (speed.x) / ((ePos.x - sPos.x) / (ePos.y - sPos.y))
    end
    if ePos.y - sPos.y > 500 or math.abs(speed.y) > 3.3 then
        speed.x = speed.x * 1
        speed.y = speed.y * 1
    else
        speed.x = speed.x * power
        speed.y = speed.y * power
    end

    -- WZLog("TeachMonsterAI:_shootLine ", speed.x, speed.y, ePos.x, ePos.y, sPos.x, sPos.y, power)
    return speed
end
