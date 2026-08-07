--BattleAiCtrl.lua
--@brief	战斗AI
--@date		2013/2/15
--@author	李俊鸿
--@modified zjh
--@note		AI控制

--@brief	AI动作类型
BattleAiAction = {
	ACTION_MOVE = 1, --移动
	ACTION_RAND = 2, --随机动作
	ACTION_SHOOT = 3, --射击
	ACTION_FLY = 4, --飞行
	ACTION_SKILL = 5, --使用技能
	ACTION_ITEM = 6, --使用道具
    ACTION_ADJUST_ANGLE = 7, --进行角度调整
    ACTION_FIND_WAY = 8, --攻击寻路
    ACTION_BIG_SKILL = 9, --使用大招
    ACTION_MOVE_TO_FAR = 10, --移动去远点
}

--@brief	Ai数据表
BattleAiCtrl = {
	m_tAction = nil, --动作类型顺序表
	m_nDt = 0, --调用时间累加
	m_bMoved = false, --是否移动
	m_bUseBigSkill = false, --是否使用大招
	m_nCharacterId,	--角色ID

    m_tHero = nil,                      --所属英雄
    m_tAiHelper = nil,                  --AI辅助
    m_tTargetPlayer = nil,              --目标玩家
    m_nDistanceMove = 0,                --移动距离
    m_nUseItemId = 0,                   --道具id
    m_nUseSkillId = 0,                  --技能id
    m_bIsFlyTobirthPos = nil,           --是否飞向出生点

    m_tAiInterface = nil,   --AI接口
    m_tMovePos = nil,       --移动地点
    m_tFlyPos = nil,        --飞行地点
    m_nSkillId = 0,         --技能Id
    m_nItemId = 0,          --道具Id
    m_nHPWithTurnStart = 0, --回合开始时的血量
    m_bIsAtked = false,     --本回合是否已经攻击过
    m_tRandNumList = nil,   --战斗随机数组
    m_nRandNumIndex = 0,    --战斗随机数组下标
    m_nCurRandNum = 0,      --当前回合随机数
    m_tSpeed = nil,
    m_tCheckOnceArray = nil,  --只检测一次
    m_nCurStatus = 0,       --状态
    m_bIsGetBaseData = false,   --是否已经获取到基本资料
    m_tAddActWithNextTurn = nil, --触发下一回合的行为
    m_nRandNum = 0,
    m_nTurnTimes = -1,
    m_nShootOffset = 0,
    m_nUseSkillItemTimer = 0,
    m_nWaitMoveTime = 0,

    m_bIsUseSkill = nil,
    m_nFirstTurnDirRand = nil,    --第一次转向随机数
}

-------------------------------------公有方法模块--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@param	nCharacterId，角色ID
--@return	新建的表实例对象
function BattleAiCtrl:new(nCharacterId)
	local tNewObj = {}
	setmetatable(tNewObj, { __index = BattleAiCtrl })
	tNewObj.m_nCharacterId = nCharacterId
	tNewObj.m_tAction = {}
    tNewObj.m_nLastSkillId = nil
    tNewObj.m_tHero = WBattleGlobal:getCurrent():getCharacterWithId(tNewObj.m_nCharacterId)
    tNewObj.m_nCurStatus = 0
	return tNewObj
end

--@brief	销毁Ai
function BattleAiCtrl:destroy()
    WZLog("BattleAiCtrl:destroy")

    self.m_tAction = nil
    self.m_nDt = 0
    self.m_bMoved = false
    self.m_bUseBigSkill = false
    self.m_nCharacterId = nil

    self.m_tHero = nil
    self.m_tTargetPlayer = nil
    self.m_nDistanceMove = 0
    self.m_nUseItemId = 0
    self.m_nUseSkillId = 0
    self.m_bIsFlyTobirthPos = nil

    self.m_bAdjustAngle = false
    self.m_tSpeed = nil
    self.m_tCheckOnceArray = nil

    self.m_tMovePos = nil       --移动地点
    self.m_tFlyPos = nil        --飞行地点
    self.m_nSkillId = 0         --技能Id
    self.m_nItemId = 0          --道具Id
    self.m_nHPWithTurnStart = 0 --回合开始时的血量
    self.m_bIsAtked = false     --本回合是否已经攻击过
    self.m_nCurStatus = 0
    self.m_bIsGetBaseData = false
    self.m_tAddActWithNextTurn = nil
    self.m_nRandNum = 0
    self.m_nTurnTimes = -1
    self.m_nShootOffset = 0
    self.m_nUseSkillItemTimer = 0
    self.m_nFirstTurnDirRand = nil 
    if self.m_tAiHelper then
        self.m_tAiHelper:destroy()
        self.m_tAiHelper = nil
    end
   if self.m_tAiInterface then
        self.m_tAiInterface:destroy()
        self.m_tAiInterface = nil
   end
end

--@brief    设置AI对应的怪
function BattleAiCtrl:setHero(hero)
    self.m_tHero = hero
end

--@brief	设置AI辅助
function BattleAiCtrl:setAiHelper()
    if self.m_tAiHelper ~= nil then
        return
    end
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCharacterId)
    self.m_tAiHelper = BattleAiCtrlHelper:new()
    self:getAiHelper():setHero(hero)

    if hero:isRobot() == true or hero.m_bIsGuaiWithSuit == true then
        self:getAiHelper():setSkillCombos()
    end
    
end

--@brief	获取AI辅助
function BattleAiCtrl:getAiHelper()
    if self.m_tAiHelper == nil then
        self:setAiHelper()
    end

    return self.m_tAiHelper
end

--@brief    根据分隔符拆分ai字符串"
--@param    s:要分隔的字符串
function BattleAiCtrl:splitAiStringWithSeparator(s)
    WZLog("BattleAiCtrl:splitAiStringWithSeparator zero", s)
    local nFindStartIndex = 1
    local nSplitIndex = 1
    local nSplitArray = {}
    local sSeparator = " | "
    local sChange = "%),%("
    local sChanged = " | "
    local actionStart = "%<"
    local actionEnd = "%>,%("
    local minus = "%-"
    local minus2 = "minus"

    local actionSeparator = "|"
    s = string.gsub(s, " ", "")
    local actionList = SplitStringWithSeparator(s, actionSeparator)
    local ai = {}
    for i, s in pairs (actionList) do
        local subStartIndex = 1
        local subEndIndex = string.find(s, actionEnd)
        local action = string.sub(s, 1, subEndIndex)
        WZLog("BattleAiCtrl:splitAiStringWithSeparator one", i, s, action)
        s = string.gsub(s, "%<", "")
        s = string.gsub(s, "%>", "")
        s = string.gsub(s, minus, minus2)
        action = string.gsub(action, minus, minus2)
        local action2 = string.gsub(action, "%>", "")
        action2 = string.gsub(action2, "%<", "")
        s = string.gsub(s, action2, "")
        s = string.gsub(s, sChange, sChanged)
        s = string.gsub(s, ",%(", "")
        s = string.gsub(s, "%),", "")
        s = string.gsub(s, "%(", "")
        s = string.gsub(s, "%)", "")

        action = [[<]]..action
        action = string.gsub(action, "%>,%<", sChanged)
        action = string.gsub(action, ",%<", "%>,%<")
        action = string.gsub(action, "%>,%<", sChanged)
        action = string.gsub(action, ",%<", "")
        action = string.gsub(action, "%>,", "")
        action = string.gsub(action, "%<", "")
        action = string.gsub(action, "%>", "")
        action = string.gsub(action, minus2, minus)
        WZLog("BattleAiCtrl:splitAiStringWithSeparator three", i, action)
        local actionInfoList = SplitStringWithSeparator(action, sSeparator)

        local conditionInfoList = SplitStringWithSeparator(s, sSeparator)
        local actionList = {}
        local conditionList = {}
        ai[i] = {}
        ai[i]["action"] = {}
        ai[i]["condition"] = {}
        for k, v in pairs(conditionInfoList) do
            ai[i]["condition"][k] = {}
            conditionList[k] = SplitStringWithSeparator(v, ",")
            for l, w in ipairs(conditionList[k]) do
                local value = tonumber(w)
                if value ~= nil then
                    w = value
                end
                if l == 1 then
                    ai[i]["condition"][k]["conditionType"] = w
                else
                    ai[i]["condition"][k]["conditionParm"..l-1] = w
                end
            end
        end

        for k, v in ipairs(actionInfoList) do
            
            if k == 1 then
                local vOri = v
                local actCount = SplitStringWithSeparator(v, ",")
                ai[i]["actionCountMax"] = tonumber(actCount[1])
                ai[i]["actionCount"] = 0
                v = actCount[2] or v
                WZLog("BattleAiCtrl:splitAiStringWithSeparator four-0", k, vOri, tostring(v), tostring(ai[i]["actionCountMax"]), Serialize(actCount))
            end
            WZLog("BattleAiCtrl:splitAiStringWithSeparator four-1", k, v)
            if k == 1 then
                local sAct = SplitStringWithSeparator(v, "_")
                ai[i]["action"]["actionType"] = tonumber(sAct[1])
                ai[i]["action"]["actionFormat"] = tonumber(sAct[2])
            else
                ai[i]["action"][k-1] = {}
                actionList[k-1] = SplitStringWithSeparator(v, ",")
                for j, u in ipairs(actionList[k-1]) do
                    local value = tonumber(u)
                    if value ~= nil then
                        u = value
                    end
                    ai[i]["action"][k-1]["actionParm"..j] = u
                end
            end
        end

        for j, u in pairs(ai[i]) do
            if j == "action" then
                for i, v in pairs (u) do
                    WZLog("BattleAiCtrl:splitAiStringWithSeparator five-1", j, i, v)
                end
            elseif j ~= "actionCountMax" and j ~= "actionCount" then
                for k, w in pairs (u) do
                    for i, v in pairs (w) do
                        WZLog("BattleAiCtrl:splitAiStringWithSeparator five-1", j, k, i, v)
                    end
                end
            end
        end
    end

    return ai
end


--@brief	设置AI接口
function BattleAiCtrl:setAiInterface()
    if self.m_tAiInterface ~= nil then
        return
    end
    WZLog("BattleAiCtrl:setAiInterface one",self.m_tHero:getAiScript())
    local aiScript = self:splitAiStringWithSeparator(self.m_tHero:getAiScript())
    self.m_tHero.m_tAiScript = aiScript

    self.m_tAiInterface = BattleAiCtrlInterface:new()
    self:getAiInterface():setHero(self.m_tHero)
end

--@brief	获取AI接口
function BattleAiCtrl:getAiInterface()
    if self.m_tAiInterface == nil then
        --self.m_tAiInterface = BattleAiCtrlInterface:new()
        --self:getAiInterface():setHero(self.m_tHero)
        self:setAiInterface()
    end
    return self.m_tAiInterface
end

--@brief	获取当前随机数
function BattleAiCtrl:getCurRandNum(offset)
    if offset == nil then
        offset = 0
    end
    self.m_tRandNumList = WBattleGlobal:getCurrent().m_tBattleRand
    self.m_nRandNumIndex = (self.m_nRandNumIndex + math.abs(self.m_tHero:getBattleId()) + offset) % 10 + 1
    self.m_nCurRandNum = self.m_tRandNumList[self.m_nRandNumIndex]

    return self.m_nCurRandNum
end

--@brief	开始行动
function BattleAiCtrl:startRound()
	WZLog("BattleAiCtrl:startRound")
    --self:_talk("nihaoa")
    self.m_tRandNumList = WBattleGlobal:getCurrent().m_tBattleRand
    self.m_nRandNumIndex = (WBattleGlobal:getCurrent():getTurnTimes() + math.abs(self.m_tHero:getBattleId())) % 10 + 1
    self.m_nCurRandNum = self.m_tRandNumList[self.m_nRandNumIndex]
    self.m_tAction = {}
    self:getAiInterface():resetParam()
    self.m_bAiCheck = false
    for id, ai in ipairs (self.m_tHero:getAiScript()) do
        ai.isAction = nil
    end
    
    self.m_nHPWithTurnStart = self.m_tHero:getHp()
    self.m_tMovePos = nil
    self.m_tFlyPos = nil
    self.m_nSkillId = 0
    self.m_nItemId = 0
    self.m_bMoved = false
    self.m_bIsAtked = false
    self.m_bUseBigSkill = false
    self.m_bAdjustAngle = false
    self.m_tSpeed = nil
    self.m_bIsGetBaseData = false
    self.m_nRandNum = 0
    self.m_nShootOffset = self:_shootOffset()
    self.m_bIsEndCurRround = nil
    self.m_nFirstTurnDirRand = nil 
    self.m_tHero.m_nUsePoint = 0

    self.m_tCheckOnceArray = {}
    for i=1,10 do
        self.m_tCheckOnceArray[i] = false
    end

    if self.m_tAddActWithNextTurn ~= nil and #self.m_tAddActWithNextTurn == 0 then
        self.m_tAddActWithNextTurn = nil
    end

    if self.m_tHero.m_nAiType ~= nil and self.m_tHero.m_nAiType == MonsterAiType.AI_ROBOT and WBattleGlobal:getCurrent():getCurrentCharacter():getId() == self.m_tHero:getId() then

        if self.m_nCharacterId == 0 then
            self.m_nCharacterId = self.m_tHero:getBattleId()
        end

        local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCharacterId)
        hero:setPF(hero.m_nPhysicalMax or 100)
    end

    self.m_nCurStatus = -1
	--self:addAction(0)
	self:resetParam()
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))
end

--@brief	结束行动
function BattleAiCtrl:endRound()
	WZLog("BattleAiCtrl:endRound")
	if self.m_tAction and #self.m_tAction>0 then
		for i=#self.m_tAction,1,-1 do
			table.remove(self.m_tAction,i)
		end
		self:resetParam()
	end
    self.m_nCurStatus = 0
end

--@brief	切换行动时重置操作
function BattleAiCtrl:resetParam()

	self.m_nDt = 0
    if self.m_tHero.m_bIsGuaiWithSuit then
        self.m_nDt = 10
    end
end

--@brief	增加一个动作
--@param	nActionType,动作类型
function BattleAiCtrl:addAction(nActionType)
	if self.m_tAction == nil then
		self.m_tAction = {}
	end
    WZLog("BattleAiCtrl:addAction", nActionType)
	table.insert(self.m_tAction,nActionType)
end

--@brief	执行下一个动作
function BattleAiCtrl:doNextAction()
	if self.m_tAction and #self.m_tAction>0 then
		table.remove(self.m_tAction,1)
		self:resetParam()
	else
		self:endRound()
	end
end

--@brief    AI处理函数
--@param    dt,帧间时间
--@return   AI没处理完会返回false，否则返回true/nil
function BattleAiCtrl:run(dt)
    if WBattleGlobal:getCurrent():isReplayGame() then
        return
    end
    
    if not (self.m_nCurStatus == -1) or self.m_tHero:isDead() then
        return
    end

    if self.m_nUseSkillItemTimer >= 0 then
    self.m_nUseSkillItemTimer = self.m_nUseSkillItemTimer - dt
    return
    end

    local hero = self.m_tHero
    if not hero or (hero:getType() == 0 and not hero:isRobot()) then
        return
    end

    if self.m_tAiInterface == nil then
        self:setAiInterface()
    end

    self:updateAction(dt)
    
    if self.m_bAiCheck then
        return
    end

    local defShoot = true
    
    for id, ai in ipairs (hero:getAiScript()) do
        if ai.action.actionType == -1 then 
            break
        end
        --WZLog("BattleAiCtrl:run ten-1", hero:getId(), tostring(ai.isAction), id, ai.actionCount, ai.actionCountMax, Serialize(ai))
        if ai.isAction ~= true and (ai.actionCountMax < 0 or(ai.actionCountMax == 0) or (ai.actionCountMax > 0 and ai.actionCount < ai.actionCountMax)) then
            local action = ai.action
            local conditionList = ai.condition
            local conditionMatchList = {}
            for index, condition in ipairs (conditionList) do
                if self:checkMatchAiCondition(condition.conditionType, condition) == true then
                    table.insert(conditionMatchList, true)
                end
            end
            if #conditionMatchList == #conditionList or ai.actionCountMax == 0 then
                WZLog("BattleAiCtrl:run ten-2", hero:getId(), id, ai.actionCount, ai.actionCountMax, tostring(action.actionFormat), Serialize(ai))
                ai.isAction = true
                ai.actionCount = ai.actionCount + 1
                --self:doAction(action.actionType, action, conditionList,nil, id)
                --[[
                if action.actionType == WHeroItemType then
                    if action[1] == WHeroItemType.FLY then
                        defShoot = false
                    end
                end
                --]]    
                 self:addAction(action.actionType)
                 
                 defShoot = false

                if action.actionFormat then
                    break
                end
            end
        end
    end

    if defShoot then
        self.m_tTargetPlayer = self:getAiHelper():getTargetPlayer()
        WZLog("BattleAiCtrl:run 000", type(self.m_tTargetPlayer))
        if self.m_tTargetPlayer == nil then
            return
        end
        self:addAction(0)
    end 

    self.m_bAiCheck = true

end

--@brief    判断满足AI条件
function BattleAiCtrl:checkMatchAiCondition(conditionType, parmList)
    return true
end

function BattleAiCtrl:getDtTime(bFirstTurn)
    if bFirstTurn then --机器人不用马上转向
        WZLog("BattleAiCtrl:getDtTime")
        if self.m_nFirstTurnDirRand == nil then 
            self.m_nFirstTurnDirRand = math.random(1,6)
        end

        return self.m_nFirstTurnDirRand or math.random(1,6)
    end
    if self.isFirstDt == nil then
        self.isFirstDt = true
        return 5
    end
    -- if WBattleGlobal:getCurrent():isArenaPWStage() then
    --     return math.random(2,5)
    -- end
    return 0.2
end

function BattleAiCtrl:updateAction(dt)
    local hero = self.m_tHero

    if hero:getIsFrozen() and self.m_bIsEndCurRround == nil then
        self.m_bIsEndCurRround = true
    end

    if hero.m_nDebuffVertigoRound or hero:getIsFrozen() or hero:isDead() or hero:isOutOfScene() then
        self:endRound()
        return
    end

    if self.m_tAction and #self.m_tAction <= 0 then
        return
    end

    local turnTimes, rand
    if self.m_nTurnTimes == nil or self.m_nTurnTimes ~= WBattleGlobal:getCurrent():getTurnTimes() then
        self.m_tTargetPlayer = self:getAiHelper():getTargetPlayer()
        WZLog("BattleAiCtrl:run 111", type(self.m_tTargetPlayer))
        if self.m_tTargetPlayer == nil then
            return
        end
        self.m_nRandNum = self:getCurRandNum()
        self.m_nHPWithTurnStart = self.m_tHero:getHp()
        self.m_nTurnTimes = WBattleGlobal:getCurrent():getTurnTimes()
    end

    local action = self.m_tAction[1]
    WZLog("BattleAiCtrl:run one", action, self.m_nRandNum, self.m_nDt)

    if action == 0 then
        --移动后延迟1.5秒
        self.m_nDt = self.m_nDt + dt
        if self.m_nDt < self:getDtTime(true) then
            WZLog("BattleAiCtrl:run one two", self.m_nDt, self.m_nFirstTurnDirRand)
            return false
        end
        local isNeedMove = 0
        isNeedMove, self.m_nPosTargetX = self:getAiHelper():isNeedMove()

        if false then
            self:addAction(BattleAiAction.ACTION_FLY)
        else
            if isNeedMove == 1 or WBattleGlobal:getCurrent():isHoleTeach() then     --移动
                self:addAction(BattleAiAction.ACTION_MOVE_TO_FAR)
            else                        --检测能否攻击命中
                self:addAction(BattleAiAction.ACTION_ADJUST_ANGLE)
            end
        end
    elseif action == BattleAiAction.ACTION_MOVE_TO_FAR then
        if self.m_bMoved == false then
            self:_moveFar(self.m_nPosTargetX)
            self.m_bMoved = true
        end

        --移动后延迟1.5秒
        self.m_nDt = self.m_nDt + dt
        if self.m_nDt < self:getDtTime() then
            return false
        end
        if BattleMsgPlayerMove.m_nProcess > 0 then
            return false
        end
        self:addAction(BattleAiAction.ACTION_BIG_SKILL)
        self.m_bMoved = false

    elseif action == BattleAiAction.ACTION_MOVE then
        if self.m_bMoved == false then
            self:_move()
            self.m_bMoved = true
        end

        --移动后延迟1.5秒
        self.m_nDt = self.m_nDt + dt
        if self.m_nDt < self:getDtTime() then
            return false
        end

        self:addAction(BattleAiAction.ACTION_BIG_SKILL)
        self.m_bMoved = false

    elseif action == BattleAiAction.ACTION_ADJUST_ANGLE then
        WZLog("BattleAiCtrl:run seven", action)
        --进行角度调整
        local isCanHit = false
        if self.m_bAdjustAngle == false then
            isCanHit = self:_adjustAngle()
            self.m_bAdjustAngle = true
        end

        if isCanHit == false then
            self:addAction(BattleAiAction.ACTION_FIND_WAY)
        else
            self:addAction(BattleAiAction.ACTION_BIG_SKILL)
        end

    elseif action == BattleAiAction.ACTION_FIND_WAY then
        WZLog("BattleAiCtrl:run five", action)

        local skillItemId = BattleHeroUse.ITEM_FOLLOW
        local isCanUse = self:getAiHelper():isCanUseItem(skillItemId)
        local rand = math.random(1, 10)
        local heroPos = self.m_tHero:getPosition()

        if isCanUse == true and BattleHeroUse:heroUse(hero:getBattleId(), BattleHeroUse.USE_SKILL_OR_ITEM, skillItemId) then
            for i,v in pairs (hero.m_tItems) do
                WZLog("BattleAiCtrl:_useItem two", i, skillItemId, v)
                if skillItemId == v then
                    table.remove(hero.m_tItems, i)
                    break
                end
            end
            local skillData = GDatatab_skill["id_" .. skillItemId]
            hero.m_nUsePoint = hero.m_nUsePoint + skillData.consume

            self.m_nUseSkillItemTimer = 1
            self:addAction(BattleAiAction.ACTION_SHOOT)
        elseif (heroPos.y < 400 or rand <= 3) and hero:isInBuffState(EffectTypeConfig.LIMIT_FLY) ~= true and (BattleHeroUse:heroUse(hero:getBattleId(),BattleHeroUse.USE_FLY) == true or (hero.m_nRemainUseItemCount > 0 and self:getAiHelper():isCanUseItem(BattleHeroUse.ITEM_FLY) and BattleHeroUse:heroUse(hero:getBattleId(),BattleHeroUse.USE_ITEM,BattleHeroUse.ITEM_FLY) == true)) then

            local skillData = GDatatab_skill["id_" .. BattleHeroUse.ITEM_FLY]
            hero.m_nUsePoint = hero.m_nUsePoint + skillData.consume

            self:addAction(BattleAiAction.ACTION_FLY)
            
        else
            self:addAction(BattleAiAction.ACTION_MOVE)
        end

    elseif action == BattleAiAction.ACTION_BIG_SKILL then
        if WBattleGlobal:getCurrent():isArenaPWStage() or WBattleGlobal:getCurrent():isArenaZLSStage() or WBattleGlobal:getCurrent():isHeroTowerStage() or WBattleGlobal:getCurrent():isHostChallengeStage() then
            if #hero.m_tItems > 0 and math.random(100) < 30 then
                self:addAction(BattleAiAction.ACTION_ITEM)
            end
        end

        --大招可用时使用大招，否则使用普通技能
        local bigSkillId = nil 

        local skillData = GDatatab_skill["id_" .. hero.m_nBigSkillType]
        if WBattleGlobal:getCurrent():isChapterOne_ThreeTeach() then 
            bigSkillId = hero:getSkinBigSkill() 
            skillData = GDatatab_skill["id_" .. bigSkillId]
        end
        local bCanUseBigSKill = true 
        if skillData and hero.m_nUsePoint + skillData.consume > 10000 then 
            bCanUseBigSKill = false 
        end
        if bCanUseBigSKill and hero.m_bIsGuaiWithSuit ~= true and self.m_bUseBigSkill == false and hero:isInBuffState(EffectTypeConfig.LIMIT_USE_SKILL) ~= true and (bigSkillId or math.random(100) > 50) and BattleHeroUse:heroUse(hero:getBattleId(), BattleHeroUse.USE_BIGSKILL, bigSkillId) then
            self.m_bUseBigSkill = true
            hero.m_nUsePoint = hero.m_nUsePoint + skillData.consume
            WZLog("BattleAiCtrl:run six1", action)
        elseif self.m_bUseBigSkill == true then
            WZLog("BattleAiCtrl:run six2", action)
        else
            WZLog("BattleAiCtrl:run six3", action)
            if math.random(100) < 80 then
                self:addAction(BattleAiAction.ACTION_SKILL)
            end
        end

        self:addAction(BattleAiAction.ACTION_SHOOT)

    elseif action == BattleAiAction.ACTION_SHOOT then
        --射击前延迟1秒
        self.m_nDt = self.m_nDt + dt
        if self.m_nDt < self:getDtTime() or self.m_bIsUseSkill == true then
            return false
        end
        if BattleMsgPlayerMove.m_nProcess > 0 then
            return false
        end
        self:_shoot()
    elseif action == BattleAiAction.ACTION_FLY then
        --飞行前延迟1.5秒
        self.m_nDt = self.m_nDt + dt
        if self.m_nDt < self:getDtTime() then
            return false
        end
        if BattleMsgPlayerMove.m_nProcess > 0 then
            return false
        end
        self:_fly()
    elseif action == BattleAiAction.ACTION_SKILL then
        if hero.m_nDebuffSealRound == nil then
            --使用技能前延迟1秒
            self.m_nDt = self.m_nDt + dt

            if self.m_tHero:isUseFly() == true then 
                return true
            end

            if self.m_bUseBigSkill == true then
                WZLog("BattleAiCtrl:run three", action)
                return true
            end

            if self.m_nDt < self:getDtTime() then
                WZLog("BattleAiCtrl:run two", action)
                return false
            end

            if BattleMsgPlayerMove.m_nProcess > 0 then
                return false
            end

            self:_useSkill()
        end
    elseif action == BattleAiAction.ACTION_ITEM then
        if self.m_bIsTriggerFly == true then
            self.m_bIsTriggerFly = false
            return
        end

        if hero.m_nDebuffSealRound == nil then
            --使用道具前延迟1秒
            self.m_nDt = self.m_nDt + dt

            if self.m_nDt < self:getDtTime() then
                return false
            end
            if BattleMsgPlayerMove.m_nProcess > 0 then
                return false
            end
            self:_useItem()
        end

        --self:addAction(BattleAiAction.ACTION_BIG_SKILL)
    end

    self:doNextAction()
end


-------------------------------------私有方法模块--------------------------------------

--@brief	AI移动去远处
function BattleAiCtrl:_moveFar(tPos)
    WZLog("BattleAiCtrl:_moveFar one")
	local hero = WBattleGlobal:getCurrent():getCurrentCharacter()
    if hero:isInBuffState(EffectTypeConfig.LIMIT_MOVE) then
        WZLog("BattleAiCtrl:useSkill NO-5")
        return
    end

    if hero.m_bIsGuaiWithSuit == true then
        self:_moveFarRobot(tPos)
    end
	if hero:isRobot() == false then
		return
	end

	if hero:getPF() > 0 then
		local nBattleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
		local nPlayerId = hero:getId()
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
			face = 0
		elseif hero:getPosition().x > SceneBattle:getFrontLayerSize().width - 100 then
			face = 1
        elseif hero:getPosition().x > hero:getAI().m_tTargetPlayer:getPosition().x then
            face = 2
        elseif hero:getPosition().x < hero:getAI().m_tTargetPlayer:getPosition().x then
            face = 3
		end

        local movetime = 0
        --movetime = math.min(hero:getPF(), math.random(0,50))

        self.m_nDistanceMove = self:getAiHelper():getMoveDistance(face % 2)
        if hero:getPosition().x < math.abs(self.m_nDistanceMove) + 60 then 
            face = 0 
        elseif hero:getPosition().x > SceneBattle:getFrontLayerSize().width - math.abs(self.m_nDistanceMove) - 60 then 
            face = 1 
        end
        movetime = math.min(hero:getPF(), math.abs(self.m_nDistanceMove * 0.333))

        WZLog("BattleAiCtrl:_moveFar two", movetime, math.abs(self.m_nDistanceMove), hero:getPF(), hero:getPosition().x, SceneBattle:getFrontLayerSize().width - 100, face)

        face = face % 2

		local movestep = {}
		for i = 1, movetime do
			table.insert(movestep, face)
		end

		ProtocolProcessorBattleInterface:send_BATTLE_PlayerMove(nBattleId, nPlayerId, movetime, movestep, sPos.x, sPos.y, nil, hero:getPF())
	end
end

--@brief    AI移动
function BattleAiCtrl:_move(tPos)
    WZLog("BattleAiCtrl:_move one")

    local hero = WBattleGlobal:getCurrent():getCurrentCharacter()

    if hero:isInBuffState(EffectTypeConfig.LIMIT_MOVE) then
        WZLog("BattleAiCtrl:useSkill NO-4")
        return
    end

    if hero.m_bIsGuaiWithSuit == true then
        self:_moveRobot(tPos)
    end
    if hero:isRobot() == false then
        return
    end

    local nBattleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
    local nPlayerId = hero:getId()
    local sPos = hero:getMover():getMoverPosition()
    local acceleration = BattleConstants.g_nGravity

    local face = math.random(0,1)
    if hero:getPosition().x < self.m_tTargetPlayer:getPosition().x then
        face = 0
    else
        face = 1
    end

    if tPos ~= nil then
        if hero:getPosition().x < tPos.x then
            face = 0
        else
            face = 1
        end
    end

    --不允许走到屏幕边缘
    if hero:getPosition().x < 100 then
        face = 2
    elseif hero:getPosition().x > SceneBattle:getFrontLayerSize().width - 100 then
        face = 3
    end

    local movetimeOri = math.min(hero:getPF(), math.random(0,20) + 40)
    local movetime = movetimeOri
    local canMove = false
    local count, offset, isChangeDir = 0, -5, false
    while canMove ~= true and count < 10 do
        count = count + 1
        movetime = movetime + offset
        WZLog("BattleAiCtrl:_move two", movetime, hero:getPF(), hero:getPosition().x, SceneBattle:getFrontLayerSize().width - 100, face)

        if face < 2 and isChangeDir == false and movetime <= 0 then
            face = 1 - face
            movetime = movetimeOri
            isChangeDir = true
        end

        if movetime > 0 then
            face = face % 2
            local speed = {x=4.8 + face * -9.6,y=0.2}
            canMove, posEnd =BattleCommon:checkMoveCollision(sPos,movetime,speed,acceleration,BattleMapManager.m_pixelByte)

            local sceneSize = SceneBattle:getFrontLayerSize()
            --横向超出屏幕,停止移动
            if not canMove and posEnd and (posEnd.x < -10 or posEnd.x > sceneSize.width + 10) then
                canMove = true
            end
            WZLog("BattleAiCtrl:_move three", movetime, tostring(canMove), tostring(posEnd.x), tostring(posEnd.y), face)

            if canMove == true then
                local movestep = {}
                for i = 1, movetime do
                    table.insert(movestep, face)
                end
                ProtocolProcessorBattleInterface:send_BATTLE_PlayerMove(nBattleId, nPlayerId, movetime, movestep, sPos.x, sPos.y, nil, hero:getPF())
                break
            end
        else
            break
        end
    end
end

--@brief	AI射击
function BattleAiCtrl:_shoot()
    
	local hero = WBattleGlobal:getCurrent():getCurrentCharacter()
    WZLog("BattleAiCtrl:_shoot one", hero:getBattleId(), tostring(self.m_tSpeed))
    if hero.m_bIsGuaiWithSuit == true or WBattleGlobal:getCurrent():isChapterOne_ThreeTeach() then
        self:_rangedAtkRobot(tPos)
    end
    if hero:isRobot() == false then
        return
    end

	local aimHero = self.m_tTargetPlayer
	if aimHero == nil then
		WZLog("No aimHero,use myHero instead")
		aimHero = WBattleGlobal:getCurrent():getMyHero()
	end

    local anim = hero:getAnimation()
    local offset
    if hero:getUseBigSkill() then
        offset = {x=BattleMsgPlayerReadyShoot.m_nOffsetX,y=BattleMsgPlayerReadyShoot.m_nOffsetY}
    end

	local sPos = hero:getPosition()
	local ePos = BattleCommon:getPointTable(aimHero:getPosition().x + self.m_nShootOffset, aimHero:getPosition().y)

    if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS and hero:getIsGuai() ~= true and not hero:isDevilGuai() then
        ePos.x = ePos.x + 130
        ePos.y = ePos.y + 10

        WZLog("BattleAiCtrl:_shoot four")
    end

	local angle
	local face

    local angleOffset = 100 * (aimHero:getHp() / aimHero:getMaxHp() + 0.5) / (3 * (hero:getHp() / hero:getMaxHp() + 0.5))
	if ePos.x <= sPos.x then
		face = 1
		angle = -angleOffset -90
		--sPos = BattleCommon:getShootPos(true)

        if anim:isFlipX() == false then
            hero:getAnimation():setFlipX(true)
        end
        sPos = BattleCommon:getShootPos(true,hero,offset)

	else
		face = 0
		angle = -angleOffset
		--sPos = BattleCommon:getShootPos(false)

        if anim:isFlipX() == true then
            hero:getAnimation():setFlipX(false)
        end
        sPos = BattleCommon:getShootPos(false,hero,offset)
	end

    local ePosOriX = ePos.x
    local hitPercentage = math.random(1,100)
    if (aimHero.m_nLevel <= 10 and hitPercentage > 30 or 
        aimHero.m_nLevel <= 25 and hitPercentage > 60 or
        hitPercentage > 90) and WBattleGlobal:getCurrent().m_nBattleType ~= BattleConstants.g_nBATTLE_TYPE_BOSS
        then
        
        ePos = BattleCommon:getPointTable(ePos.x + 100 * (hitPercentage > 85 and 1 or -1), ePos.y)
        WZLog("BattleAiCtrl:_shoot three-2",hitPercentage, ePosOriX, ePos.x)
    end

    WZLog("BattleAiCtrl:_shoot three-3", WBattleGlobal:getCurrent():isFirstPvp(), hero:getUseBigSkill())
    if WBattleGlobal:getCurrent():isFirstPvp() and (hero:getUseBigSkill() == true or (aimHero:getHp() / aimHero:getMaxHp() <= 0.3)) then
        ePos = BattleCommon:getPointTable(ePosOriX + 300 * (hitPercentage > 50 and 1 or -1), ePos.y)
        WZLog("BattleAiCtrl:_shoot three-4",hitPercentage, ePosOriX, ePos.x)
    end

    --命中率(排位赛,战略赛)
    if WBattleGlobal:getCurrent():isArenaPWStage() or WBattleGlobal:getCurrent():isArenaZLSStage() then
        if hitPercentage > 80 then
            ePos = BattleCommon:getPointTable(ePosOriX + 300 * (hitPercentage > 50 and 1 or -1), ePos.y)
        end
    end

    local speed = {}
    local heroPos = BattleCommon:getPointTable(aimHero:getPosition().x + self.m_nShootOffset, aimHero:getPosition().y)

    if self.m_tSpeed == nil or self.m_tSpeed.heroPos.x ~= heroPos.x  then
        local power= (1 + math.random(0,3)) * SceneBattle:getFrontLayer():getScale() * 0.9;
        local speedAngle = BattleCommon:angleToPoint(BattleCommon:degressToRadius(-angle))
        local isSucceed = false
        local length = -1
        local speedNormalize= {}
        length, speedNormalize = BattleCommon:vectorNormalize(speedAngle)
        isSucceed, power = BattleCommon:getStartSpeedPowerWithSpeed(speedNormalize, sPos, ePos, power)

        if isSucceed == false then
            speed = self:getAiHelper():shootLine()
        else
            speed.x = speedNormalize.x * power
            speed.y = speedNormalize.y * power
        end

        WZLog("BattleAiCtrl:_shoot two-1", length, isSucceed, angleOffset, power, speed.x, speed.y,speedAngle.x,speedAngle.y,speedNormalize.x,speedNormalize.y)

    else
        speed = self.m_tSpeed
        speed.x = self.m_tSpeed.x + 0
        WZLog("BattleAiCtrl:_shoot two-2")
    end

    if WBattleGlobal:getCurrent():isTeamStage() and hero:isDevilGuai() then 
        -- local eOffset = BattleCommon:getPointTable(aimHero.m_anim:getAnimNode():getContentSize().width * 0, aimHero.m_anim:getAnimNode():getContentSize().height * 0.3)
        -- ePos = BattleCommon:getPointTable(aimHero:getPosition().x + eOffset.x,aimHero:getPosition().y + eOffset.y)

        -- local degree = -30
        -- local degreeOffset = -90
        -- if ePos.y >= 800 then
        --     degree = -80
        --     degreeOffset = -20
        -- end
        -- --炮弹发射位置和角度修正
        -- if ePos.x <= sPos.x then
        --     face = 1
        --     angle = degree + degreeOffset
        -- else
        --     face = 0
        --     angle = degree
        -- end


        -- local power= (1 + 3) * SceneBattle:getFrontLayer():getScale() * 0.9
        -- local speedAngle = BattleCommon:angleToPoint(BattleCommon:degressToRadius(-angle))
        -- local isSucceed = false
        -- local length = -1
        -- local speedNormalize= {}
        -- length, speedNormalize = BattleCommon:vectorNormalize(speedAngle)
        -- isSucceed, power = BattleCommon:getStartSpeedPowerWithSpeed(speedNormalize, sPos, ePos, power)

        -- if isSucceed == false then
        --     speed = self:getAiHelper():shootLine()
        -- else
        --     speed.x = speedNormalize.x * power
        --     speed.y = speedNormalize.y * power
        -- end
    end

    speed.x = math.min(speed.x, 50)
    speed.y = math.min(speed.y, 50)

	local nBattleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
    local nPlayerId = hero:getId()
    local nPlayerCount = 0
    local tPlayerId = {}
    local tCurPositionX = {}
    local tCurPositionY = {}
    local tCurPositionR = {}
    local tCurPositionD = {}
	for id, player in pairs(WBattleGlobal:getCurrent().m_tHeros) do
        table.insert(tPlayerId, id)
		local x = BattleCommon:float2int2float(player:getMover():getMoverPosition().x)
        local y = BattleCommon:float2int2float(player:getMover():getMoverPosition().y)
        local r = BattleCommon:float2int2float(player:getAnimation():getRotate())
        table.insert(tCurPositionX, x)
        table.insert(tCurPositionY, y)
        table.insert(tCurPositionR, r)
        table.insert(tCurPositionD, player:getAnimation():isFlipX() and 1 or 0)
        nPlayerCount = nPlayerCount + 1

        player:setPosition(Vector2:create(x, y))
        player:getAnimation():setRotate(r)
	end
    WBattleGlobal:getCurrent().m_tAttackRandomList = {}
    WBattleGlobal:getCurrent().m_tTargetRandomList = {}

    local count = hero:getAttTimes() * hero:getAttScatterNum()
    WZLog("BattleAiCtrl:_shoot five", nPlayerCount, Serialize(tCurPositionX), Serialize(tCurPositionY), Serialize(tCurPositionR), Serialize(tCurPositionD))
    ProtocolProcessorBattleInterface:send_BATTLE_Shoot(nBattleId, nPlayerId, BattleCommon:float2int2float(speed.x), BattleCommon:float2int2float(speed.y), face, sPos.x, sPos.y, nPlayerCount, tPlayerId, tCurPositionX, tCurPositionY, tCurPositionR, tCurPositionD, count )
end

--@brief	AI飞行
function BattleAiCtrl:_fly()
    local hero = WBattleGlobal:getCurrent():getCurrentCharacter()
    if hero:isInBuffState(EffectTypeConfig.LIMIT_FLY) then
        WZLog("BattleAiCtrl:useSkill NO-3")
        return
    end

    if hero.m_bIsGuaiWithSuit == true then
        self:_flyRobot()
    end

    if hero:isRobot() == false then
        return
    end

	local aimHero = self.m_tTargetPlayer
	if aimHero == nil then
		WZLog("No aimHero,use myHero instead")
		aimHero = WBattleGlobal:getCurrent():getMyHero()
	end
	local sPos = hero:getPosition()
	local ePos = aimHero:getPosition()
	local angle
	local face

    WZLog("BattleAiCtrl:_fly", ePos.x, ePos.y, WBattleGlobal:getCurrent():getMyHero():getPosition().x, WBattleGlobal:getCurrent():getMyHero():getPosition().y)

    local s = math.random(0,1)
    local dis = math.random(10,100) --hero.m_fRadiusForBulletExplode + hero:getRadiusForHurt()
    if s == 0 then
        ePos.x = ePos.x + dis
    else
        ePos.x = ePos.x - dis
    end

	if ePos.x <= sPos.x then
		face = 1
		angle = -20 - (math.random(0,20)) -90
		sPos = BattleCommon:getShootPos(true)
	else
		face = 0
		angle = -20 - (math.random(0,20))
		sPos = BattleCommon:getShootPos(false)
	end

	local power= (1 + math.random(0,3)) * SceneBattle:getFrontLayer():getScale();
--	local speed = BattleCommon:angleToPoint(BattleCommon:degressToRadius(-angle))
    local _,speed = BattleAiCheck:adjustAngle(sPos,ePos)
--	_, speed = BattleCommon:vectorNormalize(speed)
	_, power = BattleCommon:getStartSpeedPowerWithSpeed(speed, sPos, ePos, power)
	speed.x = speed.x * power
	speed.y = speed.y * power

	local nBattleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
	local nPlayerId = hero:getBattleId()
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

    --BattleHeroUse:heroUse(nPlayerId,BattleHeroUse.USE_FLY)
	ProtocolProcessorBattleInterface:send_BATTLE_Fly(nBattleId, nPlayerId, speed.x, speed.y, face, nIsEquip, sPos.x, sPos.y, nPlayerCount, tPlayerId, tCurPositionX, tCurPositionY, 0, guaiCount, guaiBattleIds, guaiCurPosX, guaiCurPosY )
end

--@brief	AI移动去远处
function BattleAiCtrl:_moveFarRobot(tPos)
    WZLog("BattleAiCtrl:moveFarRobot")
	local hero = self.m_tHero

	local movetime = math.min(hero:getPF(), self:getCurRandNum() % 31 + 20)

    if WBattleGlobal:getCurrent():isHoleTeach() then
        movetime = 100
    end
    
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
        
        -- WZLog("BattleAiCtrl:_move movetime = "..movetime.." sPos.x = "..sPos.x.." sPos.y = "..sPos.y)
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

--@brief    AI移动
function BattleAiCtrl:_moveRobot(tPos)
    WZLog("BattleAiCtrl:moveRobot")
    local hero = self.m_tHero

    local nBattleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
    local nPlayerId = self.m_nCharacterId
    local sPos = hero:getMover():getMoverPosition()
    local acceleration = BattleConstants.g_nGravity

    local face = math.random(0,1)
    if hero:getPosition().x < self.m_tTargetPlayer:getPosition().x then
        face = 0
    else
        face = 1
    end

    if tPos ~= nil then
        if hero:getPosition().x < tPos.x then
            face = 0
        else
            face = 1
        end
    end

    --不允许走到屏幕边缘
    if hero:getPosition().x < 100 then
        face = 2
    elseif hero:getPosition().x > SceneBattle:getFrontLayerSize().width - 100 then
        face = 3
    end

    local movetimeOri = math.random(0,20) + 40 --math.min(hero:getPF(), math.random(0,20) + 40)
    local movetime = movetimeOri
    local canMove = false
    local count, offset, isChangeDir = 0, -5, false
    while canMove ~= true and count < 10 do
        count = count + 1
        movetime = movetime + offset
        WZLog("BattleAiCtrl:_moveRobot two", count, movetime, hero:getPF(), hero:getPosition().x, SceneBattle:getFrontLayerSize().width - 100, face, tostring(isChangeDir))

        if face < 2 and isChangeDir == false and movetime <= 0 then
            face = 1 - face
            movetime = movetimeOri
            isChangeDir = true
        end

        if movetime > 0 then
            face = face % 2
            local speed = {x=4.8 + face * -9.6,y=0.2}
            canMove, posEnd =BattleCommon:checkMoveCollision(sPos,movetime,speed,acceleration,BattleMapManager.m_pixelByte)

            local sceneSize = SceneBattle:getFrontLayerSize()
            --横向超出屏幕,停止移动
            if not canMove and posEnd and (posEnd.x < -10 or posEnd.x > sceneSize.width + 10) then
                canMove = true
            end
            WZLog("BattleAiCtrl:_move three", movetime, tostring(canMove), tostring(posEnd.x), tostring(posEnd.y), face)

            if canMove == true then
                local movestep = {}
                for i = 1, movetime do
                    table.insert(movestep, face)
                end
                local msg = MsgManager:createMsg(BattleMsgPlayerMove)
                msg.m_nBattleId = nBattleId
                msg.m_nCurrentPlayerId = nPlayerId
                msg.m_nMovecount = movetime
                msg.m_tMovestep = movestep
                msg.m_nCurPositionX = math.floor(sPos.x)
                msg.m_nCurPositionY = math.floor(sPos.y)
                MsgManager:pushBlockMsg(msg)
                break
            end
        else
            break
        end
    end
end

--@brief	AI进行角度调整
function BattleAiCtrl:_adjustAngle()
    --WZLog("BattleAiCtrl:_adjustAngle")
    
    
	local hero = self.m_tHero
    
    local aimHero = self.m_tTargetPlayer
    if aimHero == nil then
        WZLog("No aimHero,use myHero instead")
        aimHero = WBattleGlobal:getCurrent():getMyHero()
    end

    local anim = hero:getAnimation()
    local offset
    if hero:getUseBigSkill() then
        offset = {x=BattleMsgPlayerReadyShoot.m_nOffsetX,y=BattleMsgPlayerReadyShoot.m_nOffsetY}
    end

    local sPos = hero:getPosition()
    local ePos = BattleCommon:getPointTable(aimHero:getPosition().x + self.m_nShootOffset, aimHero:getPosition().y)
    local angle
    local angleOffset = -3
    local face
    local isAtkSucceed = false
    local acceleration = BattleCommon:pointAdd(BattleConstants.g_nFlyGravity,WBattleGlobal:getCurrent():getWind())
    if ePos.x <= sPos.x then
        face = 1
        angle = -45 -90;
        --sPos = BattleCommon:getShootPos(true)

        if anim:isFlipX() == false then
            hero:getAnimation():setFlipX(true)
        end
        sPos = BattleCommon:getShootPos(true,hero,offset)
    else
        face = 0
        angle = -45;
        --sPos = BattleCommon:getShootPos(false)

        if anim:isFlipX() == true then
        hero:getAnimation():setFlipX(false)
        end
        sPos = BattleCommon:getShootPos(false,hero,offset)
    end

    local hitPercentage = math.random(1,100)
    if hitPercentage > 25 and WBattleGlobal:getCurrent().m_nBattleType ~= BattleConstants.g_nBATTLE_TYPE_BOSS then
        if WBattleGlobal:getCurrent():isHeroTowerStage() or WBattleGlobal:getCurrent():isHostChallengeStage() then 
        else
            local ePosOriX = ePos.x
            ePos = BattleCommon:getPointTable(ePos.x + 100 * (hitPercentage > 85 and 1 or -1), ePos.y)
            WZLog("BattleAiCtrl:_shoot three-1",hitPercentage, ePosOriX, ePos.x)
        end
    elseif WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS and aimHero:getType() == 1 and aimHero.m_nMonsterType == MonsterType.BOSS then 
        WZLog("BattleAiCtrl:_shoot three-1_2", tostring(aimHero.getMonsterConfig), tostring(aimHero:getMonsterConfig().rectCollision))
        local collRange = aimHero:getCollisionRang()
        if collRange and collRange[1] then 
            local bossSize = collRange[1]
            local randomH =  math.random(5, 90)
            ePos.y = ePos.y + bossSize.m_fHeight * randomH/100
        end
    end

    -- for i=1,5 do
    --     angle = angle - angleOffset
    --     local power= (self:getCurRandNum(i) % 4 + 1) * SceneBattle:getFrontLayer():getScale() * 0.9;
    --     local speed = BattleCommon:angleToPoint(BattleCommon:degressToRadius(-angle))
    --     _, speed = BattleCommon:vectorNormalize(speed)
    --     isAtkSucceed, power = BattleCommon:getStartSpeedPowerWithSpeed(speed, sPos, ePos, power)

    --     WZLog("\nBattleAiCtrl:_adjustAngle two", "i="..i, "sPos.x="..sPos.x, "sPos.y="..sPos.y, "ePos.x="..ePos.x, "ePos.y="..ePos.y)
    --     WZLog("BattleAiCtrl:_adjustAngle three", "i="..i, "speed.x="..speed.x, "speed.y="..speed.y, "angle="..angle, "power="..power)
    --     if isAtkSucceed == true then
    --         speed.x = speed.x * power
    --         speed.y = speed.y * power

    --         local hasCollision, posCollision, posEnd = BattleCommon:checkHasCollision(sPos, ePos, speed, acceleration, BattleMapManager.m_pixelByte, BattleConstants.g_nE_COLLISION_CIRCLE)

    --             WZLog("BattleAiCtrl:_adjustAngle four", "hasCol=".. tostring(hasCollision), "posCol.x="..posCollision.x, "posCol.y="..posCollision.y, "posEnd.x="..posEnd.x, "posEnd.y="..posEnd.y, "speed.x="..speed.x, "speed.y="..speed.y)
    --         if hasCollision ~= true or (hasCollision == true and ((math.abs(posCollision.y - ePos.y) < 35) and (sPos.x >= ePos.x and posCollision.x < ePos.x + 35) or (sPos.x < ePos.x and posCollision.x > ePos.x - 35))) then
    --             WZLog("BattleAiCtrl:_adjustAngle five1")
    --             self.m_tSpeed = { x=speed.x * 1, y=speed.y * 1}
    --             isAtkSucceed = true
    --             break
    --         else
    --             WZLog("BattleAiCtrl:_adjustAngle five2")
    --             isAtkSucceed = false
    --         end
    --     end

    -- end
    isAtkSucceed,speed = BattleAiCheck:adjustAngle(sPos,ePos)

    local heroPos = BattleCommon:getPointTable(aimHero:getPosition().x + self.m_nShootOffset, aimHero:getPosition().y)
    self.m_tSpeed = { x=speed.x * 1, y=speed.y * 1, heroPos = heroPos}
    WZLog("BattleAiCtrl:_adjustAngle SIX", tostring(isAtkSucceed),"\n")
    return isAtkSucceed
end

--@brief	AI射击
function BattleAiCtrl:_rangedAtkRobot()
    WZLog("BattleAiCtrl:_rangedAtkRobot one",tostring(self.m_tSpeed))
    
    
	local hero = self.m_tHero
    
    local aimHero = self.m_tTargetPlayer
    if aimHero == nil then
        WZLog("No aimHero,use myHero instead")
        aimHero = WBattleGlobal:getCurrent():getMyHero()
    end
    local sPos = hero:getPosition()
    local ePos = BattleCommon:getPointTable(aimHero:getPosition().x + self.m_nShootOffset, aimHero:getPosition().y)
    local angle
    local face
    
    if ePos.x <= sPos.x then
		face = 1
		angle = -30 -90;
        sPos = BattleCommon:getShootPos(true)
    else
		face = 0
		angle = -30;
        sPos = BattleCommon:getShootPos(false)
	end

    local heroPos = BattleCommon:getPointTable(aimHero:getPosition().x + self.m_nShootOffset, aimHero:getPosition().y)
    local speed = {}
    if self.m_tSpeed == nil or self.m_tSpeed.heroPos.x ~= heroPos.x  then
        local isAtkSucceed = false
        local power= (self:getCurRandNum() % 4 + 1) * SceneBattle:getFrontLayer():getScale() * 0.9;
        speed = BattleCommon:angleToPoint(BattleCommon:degressToRadius(-angle))
        isAtkSucceed, speed = BattleCommon:vectorNormalize(speed)
        isAtkSucceed, power = BattleCommon:getStartSpeedPowerWithSpeed(speed, sPos, ePos, power)

        if isAtkSucceed == false then
            speed = self:getAiHelper():shootLine()
        else
            speed.x = speed.x * power
            speed.y = speed.y * power
        end

        local tan = speed.y / speed.x
        local arctan = math.atan(tan)
        local deg = math.deg(arctan)
        WZLog("BattleAiCtrl:rangedAtkRobot two", isAtkSucceed, speed.x, speed.y)

    else
        self.m_tSpeed.x = self.m_tSpeed.x
        speed = self.m_tSpeed
    end
    if WBattleGlobal:getCurrent():isChapterOne_ThreeTeach() then 
        local tSkinBigSkillTargetPos = BattleCommon:getPointTable(515,515)

        local msg = MsgManager:createMsg(BattleMsgPlayerShoot)
        msg.m_nBattleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
        msg.m_nPlayerId = self.m_nCharacterId
        msg.m_nCurrentPlayerId = self.m_nCharacterId
        msg.m_nSpeedx = 0
        msg.m_nSpeedy = 0
        msg.m_nLeftRight = face
        msg.m_nStartX = tSkinBigSkillTargetPos.x
        msg.m_nStartY = SceneBattle:getFrontLayerSize().height
        msg.m_nEndX = tSkinBigSkillTargetPos.x
        msg.m_nEndY = tSkinBigSkillTargetPos.y
        MsgManager:pushBlockMsg(msg)

        WBattleGlobal:getCurrent().m_bIsPlayerOperateAlready = true
        WndBattleHud:setMyHudSwitchEnable(false)
        WndBattleHud:setMyHudShow(false)
        WndBattleHud:endTurnTime()
        return
    end

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
function BattleAiCtrl:_flyRobot()
    WZLog("BattleAiCtrl:_flyRobot")
    local tPos = self.m_tFlyPos
	local hero = self.m_tHero
    
	local aimHero = WMonster:getRandomPlayer()
	if aimHero == nil then
		WZLog("No aimHero,use myHero instead")
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
	local dis = math.random(100,150) --self:getCurRandNum() % 301
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
    
    -- WZLog("BattleAiCtrl:fly", msg.m_nSpeedx, msg.m_nSpeedy, ePos.x, ePos.y , sPos.x, sPos.y)
    MsgManager:pushBlockMsg(msg)

    BattleHeroUse:heroUse(nPlayerId,BattleHeroUse.USE_FLY)
end

--@brief	AI使用技能
function BattleAiCtrl:_useSkill(id)
    WZLog("BattleAiCtrl:useSkill one", tostring(id), tostring(self.m_bUseBigSkill))

    local hero = self.m_tHero
    if self.m_bUseBigSkill == true or hero:isInBuffState(EffectTypeConfig.LIMIT_USE_SKILL) or not hero.m_tSkills then
        WZLog("BattleAiCtrl:useSkill NO-1")
        return true
    end

    if id == -1 then
        id = nil
    end

    local turnTimes, rand
    if self.m_nTurnTimes == nil or self.m_nTurnTimes ~= WBattleGlobal:getCurrent():getTurnTimes() then
        self.m_tTargetPlayer = self:getAiHelper():getTargetPlayer()
        WZLog("BattleAiCtrl:run 222", type(self.m_tTargetPlayer))
        if self.m_tTargetPlayer == nil then
            return
        end
        self.m_nRandNum = self:getCurRandNum()
        self.m_nHPWithTurnStart = self.m_tHero:getHp()
        self.m_nTurnTimes = WBattleGlobal:getCurrent():getTurnTimes()
    end
    turnTimes = self.m_nTurnTimes
    rand = self.m_nRandNum

    local skillLen = #hero.m_tSkills > 1 and #hero.m_tSkills or 2
    local randomNum = math.random(1, skillLen) % skillLen
    local skillId = id or hero.m_tSkills[randomNum + 1]
    
    if self.m_nLastSkillId == skillId then
        for id = 1,skillLen do
            if hero.m_tSkills[id] and hero.m_tSkills[id] ~= self.m_nLastSkillId then
                skillId = hero.m_tSkills[id]
                break
            end
        end
    end
    self.m_nLastSkillId = skillId

    local isCanUse

    --测试技能
    local testSkill = false
    if testSkill then
        isCanUse = math.random(1, 4) <= 4
        skillId = 19
    else
        isCanUse = self:getAiHelper():isCanUseSkill(skillId)
    end

    WZLog("BattleAiCtrl:useSkill four", tostring(skillId), tostring(isCanUse))
    if  isCanUse == true and BattleHeroUse:heroUse(hero:getBattleId(), BattleHeroUse.USE_SKILL_OR_ITEM, skillId) then
        local skillData = GDatatab_skill["id_" .. skillId]
        hero.m_nUsePoint = hero.m_nUsePoint + skillData.consume

        self.m_nUseSkillItemTimer = 1
    end
end

--@brief	AI使用道具
function BattleAiCtrl:_useItem(id)
    WZLog("BattleAiCtrl:_useItem", tostring(id))

    local hero = self.m_tHero
    if hero:isInBuffState(EffectTypeConfig.LIMIT_USE_ITEM) then
        WZLog("BattleAiCtrl:useSkill NO-2")
        return true
    end

    if id == -1 then
        id = nil
    end

    if id ~= nil then
        local tItemData = GDatatab_skill["id_" .. id]
        if tItemData then
            local tCondition = SplitStringWithSeparator(tItemData.use_condition,"&")
            for i=1,#tCondition do
                local nStart1, nEnd1 = string.find(tCondition[i],"^syxlxy%%=") --回光返照条件
                if nStart1 then
                    local hp = self.m_tHero:getHp()
                    local hpNow = hp/self.m_tHero:getMaxHp()*100
                    local use_condition_num = string.match(tCondition[i], "%d+")
                    if hpNow >= tonumber(use_condition_num) then 
                        id = nil
                    end
                end
            end
        end
    end

    local index = id or self:getAiHelper():getUseItemAction()

    local isCanUse = self:getAiHelper():isCanUseItem(index)

    if isCanUse == true and BattleHeroUse:heroUse(hero:getBattleId(),BattleHeroUse.USE_SKILL_OR_ITEM,index) then
        for i,v in pairs (hero.m_tItems) do
            WZLog("BattleAiCtrl:_useItem two", i, index, v)
            if index == v then
                table.remove(hero.m_tItems, i)
                break
            end
        end
        local skillData = GDatatab_skill["id_" .. index]
        hero.m_nUsePoint = hero.m_nUsePoint + skillData.consume

        self.m_nUseSkillItemTimer = 1
    end
end

--@brief	设置技能列表
function BattleAiCtrl:setSkillList(tSkillList)
	self.m_tSkills = tSkillList
    if self:getAiInterface() ~= nil then
        self:getAiInterface():setSkill(tSkillList)
    end
end

--@brief	设置道具列表
function BattleAiCtrl:setItemList(tItemList)
	self.m_tItems = tItemList
    if self:getAiInterface() ~= nil then
        self:getAiInterface():setItem(tItemList)
    end
end

--@brief        剧情对话
--@param		text:对话的内容
--@param		needZoomToHero:对话的内容
function BattleAiCtrl:_talk(text, needZoomToHero)
    if text == nil then
        return
    end

    WZLog("BattleAiCtrl:talk :---"..text.."---end")
    local msg = MsgManager:createMsg(BattleMsgStoryTalk)
    msg.m_sTalkText = text          --文本内容
    msg.m_nMaxWidth = 280           --最大宽度
    msg.m_nScale = 1.0              --缩放大小
    msg.m_bNeedZoomToBoss = needZoomToHero   --是否需要把屏幕移向怪
    msg.m_tOwner = self.m_tHero
    msg.m_tFollowObj = self.m_tHero
    msg.m_bIsUpdatePos = true
    msg.m_nTime = 3
    
    local height = nil
    local width = nil
    WZLog("BattleAiCtrl:talk", tostring(self.m_tHero.m_tCollisionRang))
    if self.m_tHero.m_tCollisionRang ~= nil then
        height = self.m_tHero.m_tCollisionRang[1].m_fHeight * 0.7
        width = self.m_tHero.m_tCollisionRang[1].m_fWidth * 0.4
    elseif true or self.m_tHero.m_nAiType == MonsterAiType.AI_ROBOT then
        height = 70
        width = 50
    end

    if self.m_tHero:getPosition().x < 450 then
        msg.m_nDirection = CellDialog.DIR_RIGHT
        msg.m_tPosOffset = BattleCommon:getPointTable(width, height)   --位置偏移量
    elseif self.m_tHero:getPosition().x > 1200 then
        msg.m_nDirection = CellDialog.DIR_LEFT
        msg.m_tPosOffset = BattleCommon:getPointTable(-width, height)   --位置偏移量
    else
        if self.m_tHero.m_bIsFilpX == true then
            msg.m_nDirection = CellDialog.DIR_LEFT
            msg.m_tPosOffset = BattleCommon:getPointTable(-width, height)   --位置偏移量
        else
            msg.m_nDirection = CellDialog.DIR_RIGHT
            msg.m_tPosOffset = BattleCommon:getPointTable(width, height)   --位置偏移量
        end
    end
    MsgManager:pushBlockMsg(msg)
end

--@brief	AI命中偏移
function BattleAiCtrl:_shootOffset()
    WZLog("BattleAiCtrl:_shootOffset one")
    local offset = 0
    local pm = 1
    local rand = self:getCurRandNum()
    if rand % 2 == 1 then
        pm = -1
    end

    local probability = 1
    if self.m_tHero.m_nHitRate ~= nil then
        probability = self.m_tHero.m_nHitRate / 100
    end
    if rand / 10000 > probability then
        offset = 100 * pm
    end

    WZLog("BattleAiCtrl:_shootOffset two", offset, rand)
    return offset
end