--WMonsterAI.lua
--@brief	怪物的Ai数据表
--@date		2014/3/18
--@author	莫剑峰
--@note

--@brief	怪物的Ai数据表
WMonsterAI = {
	m_nCurStatus = 0,       --状态
    m_tBoss = nil,          --AI对应的怪物
    m_nCharacterId,         --角色ID
    m_tRandNumList = nil,   --战斗随机数组
    m_nRandNumIndex = 0,    --战斗随机数组下标
    m_nCurRandNum = 0,      --当前回合随机数
    m_nAttackRound = 0,     --当前攻击回合
    m_tSkills = nil,        --技能列表
    m_tItems = nil,         --道具列表
    m_nSkillItemId = 0,     --使用的AI策略
    m_tAction = nil,        --动作类型顺序表
	m_nDt = 0,              --调用时间累加
	m_bMoved = false,       --是否移动
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

    m_nAiActionCount = 0,     --ai行动次数
    m_bFollowIndependentDone = false, --跟随行动怪物行动处理
    m_bIsONFollowAction = nil,      --无CTB小怪行动中
}

-------------------------------------公有方法模块--------------------------------------
--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function WMonsterAI:new(nCharacterId)
    --WZLog("WMonsterAI:new")
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
    tNewObj.m_nCharacterId = nCharacterId
    tNewObj:setBoss(WBattleGlobal:getCurrent():getCharacterWithId(nCharacterId))
    tNewObj.m_tAction = {}
    tNewObj.m_tSkillsUsed = {}
    tNewObj.m_nLastSkillUsedId = -1
    tNewObj.m_bAiDisplacementDone = true
	return tNewObj
end

--@brief	销毁
function WMonsterAI:destroy()
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

--@brief	根据分隔符拆分ai字符串"
--@param	s:要分隔的字符串
function WMonsterAI:splitAiStringWithSeparator(s)
    --WZLog("WMonsterAI:splitAiStringWithSeparator zero", s)
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
        --WZLog("WMonsterAI:splitAiStringWithSeparator one", i, s, action)
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
        --WZLog("WMonsterAI:splitAiStringWithSeparator three", i, action)
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
                --WZLog("WMonsterAI:splitAiStringWithSeparator four-0", k, vOri, tostring(v), tostring(ai[i]["actionCountMax"]), Serialize(actCount))
            end
            --WZLog("WMonsterAI:splitAiStringWithSeparator four-1", k, v)
            if k == 1 then
                local sAct = SplitStringWithSeparator(v, "_")
                ai[i]["action"]["actionType"] = tonumber(sAct[1])
                ai[i]["action"]["actionFormat"] = tonumber(sAct[2])
                ai[i]["action"]["actionSpace"] = tonumber(sAct[3])
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
                    --WZLog("WMonsterAI:splitAiStringWithSeparator five-1", j, i, v)
                end
            elseif j ~= "actionCountMax" and j ~= "actionCount" then
                for k, w in pairs (u) do
                    for i, v in pairs (w) do
                        --WZLog("WMonsterAI:splitAiStringWithSeparator five-1", j, k, i, v)
                    end
                end
            end
        end
    end

    return ai
end

--@brief 解析配置
function WMonsterAI:parseScript()
    local aiScript = self.m_tBoss.m_tAiScript
    if aiScript == -1 then
        self.m_tBoss.m_tAiScript = {}
        return
    else
        for i,v in pairs (aiScript) do
            aiScript[i] = self:splitAiStringWithSeparator(v)
        end
    end
   
    WZLog("WMonsterAI:setAiInterface one", Serialize(aiScript))

    self.m_tBoss.m_tAiScript = aiScript
end

--@brief    行动
function WMonsterAI:doAction(actionType, parmList, conditionList, isNoMyTurn,id, isNoBlock,msgIndex)

    if WBattleGlobal:getCurrent():isSingleStage() == true and self.m_tBoss:isDead() == true then
        if WBattleGlobal:getCurrent().m_bIsCurTurnActed ~= true then
            self:nextRound()
        end
        return
    end

    WBattleGlobal:getCurrent().m_bIsCurTurnActed = true
    
    --WZLog("WMonsterAI:doAction one", id, actionType,tostring(self.m_nAiActionCount), tostring(isNoMyTurn), tostring(isNoBlock))
    if isNoMyTurn == nil and actionType ~= AiActionConfig.TALK and actionType ~= AiActionConfig.FOLLOW_ACTION_SKILL and actionType ~= AiActionConfig.MOVE_NEW then
        self.m_nAiActionCount = self.m_nAiActionCount + 1
    end
    local boss = self.m_tBoss
    local talkId = nil
    --发送同步技能协议，只有主机，当前回合控制怪物和跟随行动小怪
    if self.m_tBoss:isCanControl() then
        local skillId
        if actionType == AiActionConfig.SKILL or actionType == AiActionConfig.FOLLOW_ACTION_SKILL then
            skillId = parmList[1].actionParm1
            local skillConfig = GDatatab_skill["id_"..skillId]
            -- local targetList = BattleMsgSkillShow.chooseTarget(self,self.m_tBoss,{[1]=skillConfig.choose,[2]=skillConfig.chooseParm[1],[3]=skillConfig.chooseParm[2]})
            local targetList = BattleChooseMethod:chooseTarget(self.m_tBoss,{[1]=skillConfig.choose,[2]=skillConfig.chooseParm[1],[3]=skillConfig.chooseParm[2]})
            local targetIds = {}
            for i,v in pairs(targetList) do
                table.insert(targetIds,v:getBattleId())
                --WZLog("WMonsterAI:doAction II",v:getBattleId())
            end
            ProtocolProcessorBattleInterface:send_BATTLE_SkillEquip(WBattleGlobal:getCurrent():getBattleId(), self.m_tBoss:getBattleId(), skillId ,targetIds)
        -- else
        --     skillId = 1001
        --     ProtocolProcessorBattleInterface:send_BATTLE_SkillEquip(WBattleGlobal:getCurrent():getBattleId(), self.m_tBoss:getBattleId(), skillId )
        end
        --WZLog("WMonsterAI:doAction zero ", self.m_tBoss:getBattleId(), skillId)
    end
    if actionType == AiActionConfig.SUICIDE then
        WBattleGlobal:getCurrent():setHoldMonsterRecord(self.m_tBoss:getBattleId())
        if WBattleGlobal:getCurrent():isExpCopy() then
            --self:nextRound()
            self.m_tBoss:setDead(true,7)
            GlobalGame:getBattleEventDispatcher():Dispatch(BATTLE_EVENT_TYPE.MONSTER_SUICIDE)
            return
        end
        
        self:castSkill(nil,
            nil,
            nil,
            {[1]=EffectTypeConfig.DEAD}
            )
        GlobalGame:getBattleEventDispatcher():Dispatch(BATTLE_EVENT_TYPE.MONSTER_SUICIDE)
        return
    elseif actionType == AiActionConfig.CHANGE_PARENT then
        boss.m_tBoss:getAI():castSkill()
    elseif actionType == AiActionConfig.MOVE then
        --移动,参数1:移动的距离X;2:移动的距离Y;3:是否攻击,1攻击0不攻击
        parmList = parmList[1]
        --WZLog("WMonsterAI:doAction two",parmList.actionParm1, parmList.actionParm2, parmList.actionParm3)
        local atkParm = nil
        local moveParm = nil
        local bossPos = self.m_tBoss:getPosition()
        if parmList.actionParm3 == 1 then
            atkParm = SkillTypeConfig.BEAT
        end
        if parmList.actionParm1 ~= 0 and parmList.actionParm2 ~= 0 then
            moveParm = BattleCommon:getPointTable(bossPos.x + parmList.actionParm1, bossPos.y + parmList.actionParm2)
        elseif parmList.actionParm1 ~= 0 then
            moveParm = BattleCommon:getPointTable(bossPos.x + parmList.actionParm1, 0)
        elseif parmList.actionParm2 ~= 0 then
            moveParm = BattleCommon:getPointTable(0, bossPos.y + parmList.actionParm2)
        end
        local moveMonsterList = {}
        self.m_tBoss:getNearestPlayer()
        table.insert(moveMonsterList, boss)

        self:castSkill(id,
            conditionList,
            talkId,
            {[1]=SkillTypeConfig.MOVE, [2]=atkParm},
            nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,nil,nil,nil,nil,nil,
            nil,
            nil,
            moveMonsterList, moveParm
            )
    elseif actionType == AiActionConfig.MOVE_NEW then
        --移动,参数1:移动的距离X;2:移动的距离Y;3:目标位置x,4目标位置y
        parmList = parmList[1]
        local bossPos = self.m_tBoss:getPosition()
        local tx,ty = bossPos.x + parmList.actionParm1,bossPos.y + parmList.actionParm2
        local tx2,ty2 = parmList.actionParm3,parmList.actionParm4
        local moveStepPos = BattleCommon:getPointTable(tx,ty)
        local targetPos = BattleCommon:getPointTable(tx2,ty2)

        local msg = MsgManager:createMsg(BattleMsgSkillShow)
        msg.m_tOwner = self.m_tBoss or WBattleGlobal:getCurrent():getCurrentCharacter()
        msg.m_nSkillId = nil
        msg.m_nActionId = 1 --移动表演id
        msg.m_tMoveParm = {}
        msg.m_tMoveParm.moveStepPos = moveStepPos
        msg.m_tMoveParm.targetPos = targetPos
        if isNoBlock == nil then
            self:pushMonsterMsg(msg,true)
        else
            self:pushMonsterMsg(msg,false)
        end
    elseif actionType == AiActionConfig.SELF_BOOM then
        WBattleGlobal:getCurrent():setHoldMonsterRecord(self.m_tBoss:getBattleId())
        parmList = parmList[1]

        local msg = MsgManager:createMsg(BattleMsgSkillShow)
        msg.m_tOwner = self.m_tBoss or WBattleGlobal:getCurrent():getCurrentCharacter()
        msg.m_nSkillId = nil
        msg.m_nActionId = 2 --自爆表演id
        msg.m_nBoomDistance = parmList.actionParm1
        if isNoBlock == nil then
            self:pushMonsterMsg(msg,true)
        else
            self:pushMonsterMsg(msg,false)
        end
    elseif actionType == AiActionConfig.FLY then
        self.m_nLastSkillUsedId = 19998
        parmList = parmList[1]
        local bossPos = self.m_tBoss:getPosition()
        local flyParam = {}
        flyParam.m_nStartX = parmList.actionParm1
        flyParam.m_nStartY = parmList.actionParm2
        flyParam.m_nSpeedx = parmList.actionParm3
        flyParam.m_nSpeedy = parmList.actionParm4

        local msg = MsgManager:createMsg(BattleMsgSkillShow)
        msg.m_tOwner = self.m_tBoss or WBattleGlobal:getCurrent():getCurrentCharacter()
        msg.m_nSkillId = nil
        msg.m_nActionId = 4 --飞行表演id
        msg.m_tFlyParam = flyParam
        if isNoBlock == nil then
            self:pushMonsterMsg(msg,true)
        else
            self:pushMonsterMsg(msg,false)
        end
    elseif actionType == AiActionConfig.SKILL or actionType == AiActionConfig.FOLLOW_ACTION_SKILL then
        parmList = parmList[1]
        local skillId = parmList.actionParm1
        local talkId = self:checkSkillTalk(skillId)
        self.m_tSkillsUsed[skillId] = self.m_nAttackRound
        if actionType == AiActionConfig.SKILL then
            self.m_nLastSkillUsedId = skillId
        end
        --talkId = parmList.actionParm2
        --[[
            self:castSkill(id,
                conditionList,
                talkId,
                {[1]=SkillTypeConfig.SKILL},
                nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,nil,nil,nil,nil,nil,
                nil,
                nil,
                nil,nil,
                nil,nil,nil,nil,
                parmList.actionParm1
                )
        ]]
        --协议发送
        if self:isCanControl() then
            if id and id ~= -1 then
                self.m_tBoss:sendAiProcol(id)
            end
        end
        
        local msg = MsgManager:createMsg(BattleMsgSkillShow)
        msg.m_tOwner = self.m_tBoss or WBattleGlobal:getCurrent():getCurrentCharacter()
        msg.m_nSkillId = skillId
        msg.m_nTalkId = talkId
        if isNoBlock == nil then
            -- MsgManager:pushBlockMsg(msg)
            self:pushMonsterMsg(msg,true,msgIndex)
        else
            -- MsgManager:pushNonBlockMsg(msg)
            self:pushMonsterMsg(msg,false)
        end

        --WZLog("WMonsterAI:doAction four", parmList.actionParm1)
    elseif actionType == AiActionConfig.SUMMON then
        --召唤,参数1:小怪id;2数量;3最大数量;4-6-8...出生位置X;5-7-9...出生位置Y
        local summonMonsterList = {}
        local doSummerAction = false
        for j, parms in pairs (parmList) do
            if type(parms) == "table" then
                local posX = {}
                local posY = {}

                for i = 1, parms.actionParm2 do
                    --ai条件参数 4,5   6,7位 成对出现对应怪物出生点优先进
                    if parms["actionParm"..(2+2*i)] ~= nil and parms["actionParm"..(3+2*i)] ~= nil then
                        table.insert(posX, parms["actionParm"..(2+2*i)])
                        table.insert(posY, parms["actionParm"..(3+2*i)])
                        doSummerAction = true
                    else
                        for index, condition in ipairs (conditionList) do
                            if condition.conditionType == AiConditionConfig.ACTIVE_ATTACK and boss.m_tActiveAttackPos and #boss.m_tActiveAttackPos > 0 then
                                --WZLog("WMonsterAI:doAction three-1111",boss.m_tActiveAttackPos[i].bulletId,condition.conditionParm1)
                                if not boss.m_tActiveAttackPos[i].bulletId or boss.m_tActiveAttackPos[i].bulletId == condition.conditionParm1 then
                                    table.insert(posX, boss.m_tActiveAttackPos[i].x)
                                    table.insert(posY, boss.m_tActiveAttackPos[i].y)
                                    --WZLog("WMonsterAI:doAction three-1",boss.m_tActiveAttackPos[i].x, boss.m_tActiveAttackPos[i].y)
                                end
                                break
                            end
                        end
                    end
                end
                if #posX > 0 and #posY > 0 then
                    table.insert(summonMonsterList, {battleId={},id=parms.actionParm1,count=parms.actionParm2,maxCount=parms.actionParm3,scale=BossData["id_"..parms.actionParm1].scale,posX=posX,posY=posY})
                    --WZLog("WMonsterAI:doAction three-2", parms.actionParm1, parms.actionParm2, parms.actionParm3, parms.actionParm4, 1, parms.actionParm6, parms.actionParm7, parms.actionParm8)
                end
                
            end
        end

        
        if #parmList[1] % 2 == 0 then
            talkId = parmList[1]["actionParm1"..#parmList[1]]
        end
        if #summonMonsterList > 0 then
            self:castSkill(id,
                conditionList,
                talkId,
                {[1]=SkillTypeConfig.SUMMON,[2] = doSummerAction},

                nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,nil,nil,nil,nil,nil,
                summonMonsterList,
                nil
                )
        else
            self.m_nAiActionCount = self.m_nAiActionCount - 1
        end
    elseif actionType == AiActionConfig.SHOOT_SUMMON then
        local shootSummonMonsterList = {}
        table.insert(shootSummonMonsterList, {battleId={},id=1,count=2,maxCount=3,index=2,scale=0.6,posX={[1]=self.m_tBoss.m_tTargetPlayer:getPosition().x,[2]=300,[3]=700},posY={[1]=self.m_tBoss.m_tTargetPlayer:getPosition().y,[2]=330,[3]=330}})
        table.insert(shootSummonMonsterList, {battleId={},id=2,count=2,maxCount=3,index=3,scale=0.6,posX={[1]=1000,[2]=800,[3]=1200},posY={[1]=330,[2]=330,[3]=330}})

        self:castSkill(id,
            conditionList,
            talkId,
            {[1]=SkillTypeConfig.SHOOT_SUMMON},

            "boss08effect02", "0", "weapon14a", "skill", boss.m_tTargetPlayer, boss.m_nAttack, 1, 0, 40, false, 1, false, false, true, DirectionType.LEFT, 0.4,nil,nil,nil,nil,1,nil,
            nil,
            shootSummonMonsterList
                            )
    elseif actionType == AiActionConfig.SHOOT then
        parmList = parmList[1]
        --WZLog("WMonsterAI:doAction five-0", tostring(parmList.actionParm1), tostring(tonumber(parmList.actionParm1)))
        talkId = parmList.actionParm2
        if self.m_tBoss.m_nAiType == MonsterAiType.AI_MELEE or self.m_tBoss.m_nAiType == MonsterAiType.AI_MELEE_SKY then
            self.m_tBoss:getNearestPlayer()
            table.insert(moveMonsterList, boss)

            if #moveMonsterList > 0 then
                --WZLog("WMonsterAI:doAction five-1")
                self.m_bMoved = true
                self:castSkill(id,
                    nil,
                    talkId,
                    {[1]=SkillTypeConfig.MOVE, [2]=SkillTypeConfig.BEAT},
                    nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,nil,nil,nil,nil,nil,
                    nil,
                    nil,
                    moveMonsterList, nil
                )
            else
                self.m_nAiActionCount = 100
            end
        else
            local bulletId = tonumber(parmList.actionParm1) or self.m_tBoss.m_nBulletId
            local readyShootAnim = parmList.actionParm2 and tostring(parmList.actionParm2) or nil
            if bulletId ~= -1 then
                --WZLog("WMonsterAI:doAction five-2")
                self:castSkill(id,
                    nil,
                    talkId,
                    {[1]=SkillTypeConfig.SHOOT},

                    nil, nil, nil, readyShootAnim, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,nil,nil,nil,nil,nil,
                    nil,
                    nil,
                    nil,nil,
                    nil,nil,nil,nil,
                    nil,
                    bulletId)
            else
                self.m_nAiActionCount = 100
            end
        end
    elseif actionType == AiActionConfig.TALK then
        --WZLog("WMonsterAI:doAction talk:",Serialize(parmList))
        self:castSkillTalk(nil,
        nil,
        parmList[1].actionParm1,{}
        )
    elseif actionType == AiActionConfig.NO then
        --self:castSkill()
        self.m_nAiActionCount = 100
    end

end

--@brief 技能说话
function WMonsterAI:checkSkillTalk(skillId)
    local talkId = -1
    for i = 1,#self.m_tBoss.m_nSklillTalkList[1] do
        local tSkillId = self.m_tBoss.m_nSklillTalkList[1][i]
        if tSkillId == skillId then
            talkId = self.m_tBoss.m_nSklillTalkList[2][i]
            break
        end
    end
    return talkId

    -- if talkId ~= -1 then
    --     self:castSkillTalk(nil,
    --     nil,
    --     talkId,{}
    --     )
    -- end
end

--@brief 判断ai行为条件
function WMonsterAI:checkActionAiCondition(actionType,parmList,actionSpace)
    local result = true
    if actionSpace then
        local skillId = parmList[1].actionParm1
         --上一回合已经使用
        if self.m_tSkillsUsed[skillId] and self.m_tSkillsUsed[skillId] == self.m_nAttackRound - 1 then
            result = false
        end
        --WZLog("WMonsterAI:checkActionAiCondition",result,skillId,self.m_nAttackRound,self.m_tSkillsUsed[skillId])
    end
    return result
end

--@brief	判断满足AI条件
function WMonsterAI:checkMatchAiCondition(conditionType, parmList)
    --local function WZLog(...) end
    --WZLog("WMonsterAI:checkMatchAiCondition zero", self.m_tBoss:getBattleId(), conditionType, parmList.conditionParm1, parmList.conditionParm2, parmList.conditionParm3, parmList.conditionParm4)
    local isMatch = false
    local boss = self.m_tBoss

    if conditionType == AiConditionConfig.ACTIVE_ATTACK then
        --WZLog("WMonsterAI:checkMatchAiCondition zero-1", tostring(boss.m_bActiveAttack))
        if boss.m_bActiveAttack == true then
            isMatch = true
        end
    elseif conditionType == AiConditionConfig.PASSIVE_ATTACK then
        --WZLog("WMonsterAI:checkMatchAiCondition zero-2", tostring(boss.m_bPassiveAttack))
        if boss.m_bPassiveAttack == true then
            isMatch = true
        end
    elseif conditionType == AiConditionConfig.ATTACK_TURN then
        --WZLog("WMonsterAI:checkMatchAiCondition one-1", parmList.conditionParm1, parmList.conditionParm2, WBattleGlobal:getCurrent():getTurnTimes())
        --if self:comparison(WBattleGlobal:getCurrent():getTurnTimes(), parmList.conditionParm2, parmList.conditionParm1) then
        if self:comparison(self.m_nAttackRound, parmList.conditionParm2, parmList.conditionParm1) then
            isMatch = true
        end
    elseif conditionType == AiConditionConfig.RANDOM then
        local randList = WBattleGlobal:getCurrent().m_tBattleRand
        local randIndex = WBattleGlobal:getCurrent():getTurnTimes() % 10 + 1
        local randValue = (math.abs(randList[randIndex]) / 10000) * 100
        --WZLog("WMonsterAI:checkMatchAiCondition one-2",randValue, parmList.conditionParm1)
        if randValue <= parmList.conditionParm1 then
            isMatch = true
        end
    elseif conditionType == AiConditionConfig.HP_PERCENT_TARGET then
        --WZLog("WMonsterAI:checkMatchAiCondition one-3")
        isMatch = self:checkTargetListMatchCondition(parmList.conditionParm3, self.getTargetHpPercent, parmList.conditionParm2, parmList.conditionParm1)
    elseif conditionType == AiConditionConfig.HP_VALUE_TARGET then
        isMatch = self:checkTargetListMatchCondition(parmList.conditionParm3, self.getTargetHpValue, parmList.conditionParm2, parmList.conditionParm1)
    elseif conditionType == AiConditionConfig.ACTIVE_SKILL then
        for i,v in pairs (boss.m_tActiveSkillList) do
            if parmList.conditionParm1 == v then
                isMatch = true
                break
            end
        end
    elseif conditionType == AiConditionConfig.PASSIVE_SKILL then
        for i,v in pairs (boss.m_tPassiveSkillList) do
            if parmList.conditionParm1 == v then
                isMatch = true
                break
            end
        end
    elseif conditionType == AiConditionConfig.DEAD_TARGET then
        --WZLog("WMonsterAI:checkMatchAiCondition one-4")
        isMatch = self:checkTargetListMatchCondition(parmList.conditionParm1, self.getTargetHpIsDead, OperatorConfig.EQUAL, true)
    elseif conditionType == AiConditionConfig.DISTANCE_X then
        isMatch = self:checkTargetListMatchCondition(parmList.conditionParm3, self.getTargetDistance, parmList.conditionParm2, parmList.conditionParm1, 1, DistanceConfig.X)
    elseif conditionType == AiConditionConfig.DISTANCE_Y then
        isMatch = self:checkTargetListMatchCondition(parmList.conditionParm3, self.getTargetDistance, parmList.conditionParm2, parmList.conditionParm1, 1, DistanceConfig.Y)
    elseif conditionType == AiConditionConfig.DISTANCE then
        isMatch = self:checkTargetListMatchCondition(parmList.conditionParm3, self.getTargetDistance, parmList.conditionParm2, parmList.conditionParm1, 1, DistanceConfig.NO)
    elseif conditionType == AiConditionConfig.MONSTER_STATE_IN then
        isMatch = self:checkMonsterState(parmList.conditionParm1, parmList.conditionParm2, parmList.conditionParm3)
    elseif conditionType == AiConditionConfig.MONSTER_STATE_OUT then
        isMatch = not self:checkMonsterState(parmList.conditionParm1, parmList.conditionParm2, parmList.conditionParm3)
    elseif conditionType == AiConditionConfig.SELF_POSITION_X then
        isMatch = self:checkTargetListMatchCondition(parmList.conditionParm3, self.getTargetDistance, parmList.conditionParm2, parmList.conditionParm1, 3, DistanceConfig.X)
    elseif conditionType == AiConditionConfig.SELF_POSITION_Y then
        isMatch = self:checkTargetListMatchCondition(parmList.conditionParm3, self.getTargetDistance, parmList.conditionParm2, parmList.conditionParm1, 3, DistanceConfig.Y)   
    elseif conditionType == AiConditionConfig.SUMMON_MAX then
        isMatch = self:checkSummonMax(parmList.conditionParm1, parmList.conditionParm2)  
    elseif conditionType == AiConditionConfig.TARGET_IN_RECT then
        --配置 ai条件类型 + x,y,w,h
        local x = parmList.conditionParm1
        local y = parmList.conditionParm2
        local tx = x + parmList.conditionParm3
        local ty = y + parmList.conditionParm4
        isMatch = self:checkTargetInRect(x,tx,y,ty)
    elseif conditionType == AiConditionConfig.LAST_ROUND then
        local skillList = SplitStringWithSeparator(parmList.conditionParm1, "_")
        local isReflect = false
        if parmList.conditionParm2 == 1 then
            isReflect = true
        end
        for i,v in pairs(skillList) do
            if v == self.m_nLastSkillUsedId then
                isMatch = true
            end
        end
        if isReflect then
            return not isMatch
        else
            return isMatch
        end
    elseif conditionType == AiConditionConfig.MONSTER_IN_BATTLE then
        isMatch = self:checkMonsterInBattle(parmList.conditionParm1,parmList.conditionParm2)
    elseif conditionType == AiConditionConfig.IN_BUFF_STATE then
        isMatch = self:checkMonsterInBuff(parmList.conditionParm1)
    end
    
    --WZLog("WMonsterAI:checkMatchAiCondition two", conditionType, isMatch)
    return isMatch
end

--@brief    检查目标在范围内
function WMonsterAI:checkMonsterInBuff(limitType)
    for i,hero in pairs(WBattleGlobal:getCurrent():getHeroSortList()) do
        if not hero:isDead() and hero:isInBuffState(limitType) then
            return true
        end 
    end
    return false
end

--@brief    检查目标在范围内
function WMonsterAI:checkMonsterInBattle(monsterId,isOut)
    local count = 0
    for j, u in pairs(WBattleGlobal:getCurrent():getGuaiList()) do
        if u:getId() == monsterId then
            count = count + 1
        end
    end
    if not isOut then
        return count > 0 
    else
        return count == 0
    end
end

--@brief    检查目标在范围内
function WMonsterAI:checkTargetInRect(nLeftPointX,nRightPointX,nDownPointY,nUpPointY)
    local result,heroList = WMonster:getPlayerWithArea(nLeftPointX, nRightPointX,nDownPointY, nUpPointY)
    return result
end

--@brief    检查召唤怪物数量
function WMonsterAI:checkSummonMax(monsterId,max)
    --WZLog("WMonsterAI:checkSummonMax",monsterId,max)
    local summonCount = 0
        
    for i, monster in pairs(WBattleGlobal:getCurrent():getGuaiList()) do
        if monster:getId() == monsterId then
           summonCount = summonCount + 1
        end
    end
    if summonCount >= max then
        return false
    end
    return true
end

--@brief    检查目标状态值
function WMonsterAI:checkMonsterState(stateType,state,targetListMark)
    --WZLog("WMonsterAI:checkMonsterState", targetListMark, state)
    local list = self:getTargetList(targetListMark)

    for i, targetObj in ipairs (list) do
        if targetListMark == 2 or targetListMark == 1 then
            if self:checkTargetState(targetObj,stateType,state) then 
                return true
            end
        end

        if targetListMark == 3 then 
            if not self:checkTargetState(targetObj,stateType,state) then
                return false
            end
        end
    end
    
    if targetListMark == 3 then 
        return true
    end
    return false
end

--@brief    匹配目标状态
function WMonsterAI:checkTargetState(target,stateType,state)
    if not target then
        return false
    end

    if stateType == 1 then
         if state == MonsterState.NORMAL then
            if not target.m_bIsAir  and not target.m_bIsViolent and not target.m_bIsAirViolent then
                return true
            end
        elseif state == MonsterState.AIR then
            if target.m_bIsAir then
                return true
            end
        end
        
        return false
    end
    
    if target:getTmpState() == state then
        return true
    end
    return false
end

--@brief    获取目标血量百分比
function WMonsterAI:getTargetHpPercent(hero)
    local value = hero:getHp() / hero:getMaxHp() * 100
    return value
end

--@brief    获取目标血量值
function WMonsterAI:getTargetHpValue(hero)
    local value = hero:getHp()
    return value
end

--@brief    获取目标是否死亡
function WMonsterAI:getTargetHpIsDead(hero)
    local value = hero:isDead()
    return value
end

--@brief    获取目标X方向的距离
function WMonsterAI:getTargetDistance(hero, haveTarget, distanceConfig)
    local value = 0
    local heroPos = hero:getPosition()
    local bossPos = self.m_tBoss:getPosition()

    if haveTarget == 1 then
        if distanceConfig == DistanceConfig.X then
            value = math.abs(bossPos.x - heroPos.x)
        elseif distanceConfig == DistanceConfig.Y then
            value = math.abs(bossPos.y - heroPos.y)
        else
            value = BattleCommon:pointDis(bossPos, heroPos)
        end
    elseif haveTarget == 2 then
        if distanceConfig == DistanceConfig.X then
            value = heroPos.x
        elseif distanceConfig == DistanceConfig.Y then
            value = heroPos.y
        else
            value = heroPos.y
        end
    else
        if distanceConfig == DistanceConfig.X then
            value = bossPos.x
        elseif distanceConfig == DistanceConfig.Y then
            value = bossPos.y
        else
            value = bossPos.y
        end
    end
    return value
end

function WMonsterAI:getTargetList(targetListMark)
    if targetListMark == 2 or targetListMark == 3 then
        local targetAll = {}
        for id, hero in ipairs(WBattleGlobal:getCurrent():getHeroSortList()) do
            if (not hero:isDead()) and hero.m_bLoseNet ~= true then
                table.insert(targetAll, hero)
            end
        end
        return targetAll
    end
    return {[1]=self.m_tBoss}
end

--@brief    检查目标群是否符合条件
function WMonsterAI:checkTargetListMatchCondition(targetListMark, leftValueFunction, operator, rightValue, etc1, etc2)
    local isMatch = false
    local target = {}
    local matchList = {}
    local targetOne = {[1]=self.m_tBoss}
    local targetAll = {}
    for id, hero in pairs(WBattleGlobal:getCurrent():getHeroList()) do
        if (not hero:isDead()) and hero.m_bLoseNet ~= true then
            table.insert(targetAll, hero)
        end
    end

    if targetListMark == 1 then
        target = targetOne
    elseif targetListMark == 2 or targetListMark == 3 then
        target = targetAll
    else
        local isExist = false
        for id, hero in pairs(WBattleGlobal:getCurrent():getGuaiList()) do
            --WZLog("WMonsterAI:checkTargetListMatchCondition three",id ,hero.m_nPlayerId,targetListMark)
            if hero.m_nPlayerId == targetListMark then
                isExist = true
                break
            end
        end
        if isExist == false then
            isMatch = true
        else
            isMatch = false
        end
        return isMatch
    end
    for i, targetObj in ipairs (target) do
        local result = leftValueFunction(self, targetObj, etc1, etc2)
        --WZLog("WMonsterAI:checkTargetListMatchCondition one",i ,result)
        if self:comparison(result, operator, rightValue) then
            table.insert(matchList, true)
        end
    end
    if targetListMark == 3 then
        if #matchList == #target then
            isMatch = true
        end
    else
         if #matchList > 0 then
            isMatch = true
        end
    end

    --WZLog("WMonsterAI:checkTargetListMatchCondition two", tostring(isMatch), #matchList, #target, targetListMark, tostring(leftValueFunction), operator, rightValue, tostring(etc1), tostring(etc2))
    return isMatch
end

--@brief    关系运算
function WMonsterAI:comparison(leftValue, operator, rightValue)
    --WZLog("WMonsterAI:comparison one", leftValue, operator, rightValue)
    local result = false
    if operator == OperatorConfig.EQUAL and leftValue == rightValue then
        result = true
    elseif operator == OperatorConfig.NOT_EQUAL and leftValue ~= rightValue then
        result = true
    elseif operator == OperatorConfig.GREATER and leftValue > rightValue then
        result = true
    elseif operator == OperatorConfig.GREATER_EQUAL and leftValue >= rightValue then
        result = true
    elseif operator == OperatorConfig.LESS and leftValue < rightValue then
        result = true
    elseif operator == OperatorConfig.LESS_EQUAL and leftValue <= rightValue then
        result = true
    end

    --WZLog("WMonsterAI:comparison two", result)
    return result
end

--@brief	获取当前随机数
function WMonsterAI:getCurRandNum()
    self.m_tRandNumList = WBattleGlobal:getCurrent().m_tBattleRand
    self.m_nRandNumIndex = (self.m_nRandNumIndex + math.abs(self.m_tBoss:getBattleId()) ) % 10 + 1
    self.m_nCurRandNum = self.m_tRandNumList[self.m_nRandNumIndex]
    
    return self.m_nCurRandNum
end


--@brief	开始行动
function WMonsterAI:startRound()
    WZLog("WMonsterAI:startRound", self.m_tBoss:getBattleId(), self.m_tBoss:isDead(), WBattleGlobal:getCurrent():isSingleStage())

    if self.m_tBoss:isDead() then
        WZLog("WMonsterAI:startRound zero")
        return
    end
    self.m_nAttackRound = self.m_nAttackRound + 1
    self.m_tRandNumList = WBattleGlobal:getCurrent().m_tBattleRand
    self.m_nRandNumIndex = (WBattleGlobal:getCurrent():getTurnTimes() + math.abs(self.m_tBoss:getBattleId())) % 10 + 1
    self.m_nCurRandNum = self.m_tRandNumList[self.m_nRandNumIndex]

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
    self.m_bFollowIndependentDone = false

    for i=1,10 do
        self.m_tCheckOnceArray[i] = false
    end

    if WBattleGlobal:getCurrent().m_tUseSkillItemInCurTurnList ~= nil then
        WBattleGlobal:getCurrent().m_tUseSkillItemInCurTurnList = {}
    end
    
    self.m_tBoss.m_bPassiveAttack = false
    --WZLog("WMonsterAI:startRound is my trun", WBattleGlobal:getCurrent():getCurrentCharacterId(), self.m_tBoss.m_nAiType, self.m_tBoss:getBattleId(), self:isCanControl())

    if self:isCanControl() then--WBattleGlobal:getCurrent():getCurrentCharacterId() == self.m_tBoss:getBattleId() then

        self.m_nCurStatus = -1
        self.m_nAiActionCount = 0
        self.m_tBoss.m_bActiveAttack = false
        self.m_tBoss.m_tActiveAttackPos = {}
        self.m_tBoss.m_tActiveAttackHero = {}

        self.m_tBoss.m_tActiveSkillList = {}
        self.m_tBoss.m_tPassiveSkillList = {}
        -- self.m_tBoss:getRandomPlayer()

        for id, ai in ipairs (self.m_tBoss:getAiScript()) do
            ai.isAction = nil
        end

        self.m_nCharacterId = self.m_tBoss:getBattleId()
        local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCharacterId)
        hero:setPF(100)
        self:addAction(0)
        self:resetParam()
        WZLog("WMonsterAI:startRound",self.m_tBoss.m_nAiDisplaceType)
        --位移行动
        if not TeachGroup1.ISBATTLE and self.m_tBoss.m_nAiDisplaceType ~= 0 and not self.m_tBoss:isInBuffState(EffectTypeConfig.LIMIT_MOVE) then 
            self.m_bAiDisplacementDone = false
            local msg = MsgManager:createMsg(BattleMsgAiDisplacement)
            if self.m_tBoss.m_nAiDisplaceType == 1 or  self.m_nLastSkillUsedId == 19998 or self.m_tBoss:isInBuffState(EffectTypeConfig.LIMIT_USE_SKILL) then
                msg.m_bLimitFly = true
            end
            msg.m_tOwner = self.m_tBoss or WBattleGlobal:getCurrent():getCurrentCharacter()
            self:pushMonsterMsg(msg,true)
        else
             self.m_bAiDisplacementDone = true
        end
    end
    
    
    
    local tPlayerList = WBattleGlobal:getCurrent():getHeroList()
	for i,player in pairs(tPlayerList) do
        --WZLog("WMonsterAI:startRound hp Player = ", player:getHp(), player:getId(), player:getBattleId())
	end
    
    local tGuaiList = WBattleGlobal:getCurrent():getGuaiList()
	for i,player in pairs(tGuaiList) do
        --WZLog("WMonsterAI:startRound hp Guai = ", player:getHp(), player:getId(), player:getBattleId())
	end
end

--@brief 改变ai策略
function WMonsterAI:changeAiState()
    for id, ai in ipairs (self.m_tBoss:getAiScript()) do
        ai.isAction = nil
    end

    self.m_nCurStatus = -1
    self.m_nAiActionCount = 0
end

--@brief	结束行动
function WMonsterAI:endRound()
    --WZLog("WMonsterAI:endRound")
    if self.m_tAction and #self.m_tAction>0 then
		for i=#self.m_tAction,1,-1 do
			table.remove(self.m_tAction,i)
		end
		self:resetParam()
	end
    self.m_nCurStatus = 0
end

--@brief	切换行动时重置操作
function WMonsterAI:resetParam()
    
	self.m_nDt = 0
end

--@brief	增加一个动作
--@param	nActionType,动作类型
function WMonsterAI:addAction(nActionType)
	if self.m_tAction == nil then
		self.m_tAction = {}
	end
	table.insert(self.m_tAction,nActionType)
end

--@brief	执行下一个动作
function WMonsterAI:doNextAction()
	if self.m_tAction and #self.m_tAction>0 then
		table.remove(self.m_tAction,1)
		self:resetParam()
    else
		self:endRound()
	end
end

--@brief    设置AI对应的怪
function WMonsterAI:setBoss(tBoss)
	self.m_tBoss = tBoss
end

--@brief	消息处理完成函数
--@note		结束当前回合
function WMonsterAI:nextRound()
    local isRealEnd = self:isRealEnd()
    WZLog("WMonsterAI:nextRound",isRealEnd)
    
    if not isRealEnd then
        return
    end
    WBattleGlobal:getCurrent():endCurRound(self.m_tBoss:getBattleId(),21)
    -- WBattleGlobal:getCurrent().m_bIsCurTurnActed = true
    
    -- local msg = MsgManager:createMsg(BattleMsgPass)
    -- msg.m_nBattleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
    -- msg.m_nPlayerId = self.m_tBoss:getBattleId()
    -- msg.m_nPlayerOrGuai = 1
    -- MsgManager:pushBlockMsg(msg)

    -- WndBattleHud:endTurnTime()
    -- local msg = MsgManager:createMsg(BattleMsgEndCurRound)
    -- msg.m_nBattleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
    -- msg.m_nPlayerId = WBattleGlobal:getCurrent():getMyHero():getId()
    -- msg.m_nCurrentPlayerId = WBattleGlobal:getCurrent():getMyHero():getId()
    -- msg.m_nPlayerOrGuai = 0
    -- msg.note =17
    -- MsgManager:pushBlockMsg(msg)
end

function WMonsterAI:isRealEnd()
    --（跟随行动）主怪物行动结束
    if self.m_tBoss:isFollowIndependent() then 
        WZLog("WMonsterAI:isRealEnd Follow Done")
        local owner = self.m_tBoss.m_tBoss
        self.m_bFollowIndependentDone = true
        owner:getAI():nextRound()
        return false
    end
    --拥有更随小怪的行动结束
    if self.m_tBoss:hasFollowIndependentMonster() then
        WZLog("WMonsterAI:isRealEnd II")
        if not self.m_bFollowIndependentDone then
            self.m_bFollowIndependentDone = true
            self.m_tBoss:followIndependentStartRound()
            return false
        else
            local list = self.m_tBoss:getFollowIndependentMonsterList()
            local count = #list
            local tmpCount = 0
            for index,monster in ipairs (list) do
                if monster:getAI().m_bFollowIndependentDone then
                    tmpCount = tmpCount + 1
                end
            end
            if count == tmpCount then
                return true
            end
            WZLog("WMonsterAI:isRealEnd V",count,tmpCount)
            return false
        end
    end
    --正常结束
    return true
end

--@brief 控制权
function WMonsterAI:isCanControl()
    if self.m_tBoss:isCanControl() == true then
        return true
    end
    if self.m_tBoss:isFollowIndependent() and self.m_tBoss.m_tBoss:isCanControl() then
        return true
    end
    return false
end

function WMonsterAI:aiAllDone()
    if self:isCanControl() then
        WZLog("WMonsterAI:aiAllDone",self.m_tBoss:getBattleId())
        self.m_nCurStatus = 0
        self.m_nAiActionCount = -1
        if self.m_tBoss:isCurrentControl() then
            self:nextRound()
        end
    end
end

--@brief	运作
--@param	dt:距离上一次调用的时间（秒）
function WMonsterAI:run(dt)
    if TeachGroup1.ISBATTLE_MYTURN or WBattleGlobal:getCurrent():isGameOver() then
        return
    end

    --WZLog("WMonsterAI:run", self.m_tBoss:getBattleId(),self.m_tBoss:isDead())

    --被攻击 或者 自杀 在state非 -1 状态也可以触发
    if self:isCanControl() == true then

        if not self.m_bAiDisplacementDone then
            return
        end

        local actionList = {}
        local aiScript = self.m_tBoss:getAiScript()
        for id, ai in ipairs (aiScript) do
            --WZLog("WMonsterAI:run zero", tostring(ai.actionCountMax), tostring(ai.actionCount))
            if ai.isAction ~= true and (ai.actionCountMax <= 0 or (ai.actionCountMax > 0 and ai.actionCount < ai.actionCountMax)) then
                local action = ai.action
                local conditionList = ai.condition
                local conditionMatchList = {}
                --if self:checkActionAiCondition(action.actionType,action,action.actionSpace) then
                    for index, condition in ipairs (conditionList) do
                        if (condition.conditionType == AiConditionConfig.PASSIVE_ATTACK or action.actionType == AiActionConfig.SUICIDE) and self:checkMatchAiCondition(condition.conditionType, condition) == true then
                            table.insert(conditionMatchList, true)
                        end
                    end
                        
                    if #conditionMatchList == #conditionList then
                        --WZLog("WMonsterAI:run")
                        ai.isAction = true
                        ai.actionCount = ai.actionCount + 1
                        self:doAction(action.actionType, action, conditionList, true, id)
                        if action.actionFormat then
                            self:setAiActionDone()
                            break
                        end
                    end
                --end
            end
        end
    end

    ----WZLog("WMonsterAI:run nine", self.m_tBoss:getId(), self.m_tBoss:getBattleId(), self.m_nCurStatus, self.m_nAiActionCount)
	if self.m_nCurStatus == -1 then
        -- if self.m_nAiActionCount == 100 then
        --     self.m_nCurStatus = 0
        --     self.m_nAiActionCount = -1
        --     self:nextRound()
        --     return
        -- end

        local hero = self.m_tBoss
        local turnTimes = WBattleGlobal:getCurrent():getTurnTimes()

        if self:isCanControl() then
             -- WZLog("WMonsterAI:nextRound check",self.m_nAiActionCount)
            if self.m_nAiActionCount == 100 then
                WZLog("WMonsterAI:nextRound check",self.m_tBoss:getBattleId())
                self.m_nCurStatus = 0
                self.m_nAiActionCount = -1
                if self.m_tBoss:isCurrentControl() then
                    self:nextRound()
                end
                return
            end
            
            if true then
                local actionList = {}
                for id, ai in ipairs (self.m_tBoss:getAiScript()) do
                    local action = ai.action
                    --buff限制使用技能,只能用普通攻击
                    local isLimitSkil = self.m_tBoss:isInBuffState(EffectTypeConfig.LIMIT_USE_SKILL)
                    --WZLog("WMonsterAI:run ten-1", self.m_tBoss:getId(), tostring(ai.isAction), id, ai.actionCount, ai.actionCountMax, tostring(action.actionFormat), tostring(ai.action[1] and ai.action[1].actionParm1), tostring(isLimitSkil), Serialize(ai))
                    if ai.isAction ~= true and (ai.actionCountMax < 0 or(ai.actionCountMax == 0) or (ai.actionCountMax > 0 and ai.actionCount < ai.actionCountMax)) then
                        local action = ai.action --[1]={["actionParm1"]=10003,},["actionType"]=4,},["actionCount"]=0,},
                        local conditionList = ai.condition -- ["condition"]={[1]={["conditionType"]=12,["conditionParm2"]=6,["conditionParm3"]=2,["conditionParm1"]=600,},
                        local conditionMatchList = {}
                        if self:checkActionAiCondition(action.actionType,action,action.actionSpace) then
                            for index, condition in ipairs (conditionList) do
                                if self:checkMatchAiCondition(condition.conditionType, condition) == true then
                                    table.insert(conditionMatchList, true)
                                end
                            end
                            if #conditionMatchList == #conditionList or ai.actionCountMax == 0 then
                                WZLog("WMonsterAI:run ten-2", self.m_tBoss:getId(), id, ai.actionCount, ai.actionCountMax, tostring(action.actionFormat), tostring(ai.action[1] and ai.action[1].actionParm1), tostring(isLimitSkil), Serialize(ai))

                                if (not isLimitSkil) or (isLimitSkil and action.actionType ~= AiActionConfig.SKILL) or (isLimitSkil and ai.action[1] and ai.action[1].actionParm1 ~= nil and ai.action[1].actionParm1 == 20000) then
                                    WZLog("WMonsterAI:run ten-3", self.m_tBoss:getId(), id, ai.actionCount, ai.actionCountMax, tostring(action.actionFormat), tostring(ai.action[1] and ai.action[1].actionParm1), tostring(isLimitSkil), Serialize(ai))
                                    ai.isAction = true
                                    ai.actionCount = ai.actionCount + 1
                                    self:doAction(action.actionType, action, conditionList,nil, id)
                                    if action.actionFormat then
                                        self:setAiActionDone()
                                        break
                                    end
                                end
                            end
                        end
                    end
                end
                
                if self.m_nAiActionCount == 0 then
                    self.m_tBoss:sendAiProcol(0)
                    --self.m_nAiActionCount = 100
                    if self.m_tBoss.m_nAiType == MonsterAiType.AI_MELEE or self.m_tBoss.m_nAiType == MonsterAiType.AI_MELEE_SKY then
                        local moveMonsterList = {}

                        self.m_tBoss:getNearestPlayer()
                        table.insert(moveMonsterList, self.m_tBoss)

                        if #moveMonsterList > 0 then
                            self.m_nAiActionCount = self.m_nAiActionCount + 1

                            self.m_bMoved = true
                            self:castSkill(-1,
                                nil,
                                nil,
                                {[1]=SkillTypeConfig.MOVE, [2]=SkillTypeConfig.BEAT},
                                nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,nil,nil,nil,nil,nil,
                                nil,
                                nil,
                                moveMonsterList, nil
                            )
                            WBattleGlobal:getCurrent().m_bIsCurTurnActed = true

                            
                        else
                            self.m_nAiActionCount = 100
                        end
                    else
                        if self.m_tBoss.m_nBulletId ~= -1 then
                            --[[
                            self.m_nAiActionCount = self.m_nAiActionCount + 1

                            self:castSkill(-1,
                                nil,
                                nil,
                                {[1]=SkillTypeConfig.SHOOT},

                                nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,nil,nil,nil,nil,nil,
                                nil,
                                nil,
                                nil,nil,
                                nil,nil,nil,nil,
                                nil,
                                self.m_tBoss.m_nBulletId)
                            WBattleGlobal:getCurrent().m_bIsCurTurnActed = true
                            ]]
                            WZLog("WMonsterAI:defual AI")
                            self:doAction(AiActionConfig.SKILL,{[1] = {actionParm1 = 20000}})
                        else
                            self.m_nAiActionCount = 100
                        end
                    end
                end
            end
        end
    end
end

--@breif ai触发 互斥ai行为设置true
function WMonsterAI:setAiActionDone()
    for id, ai in ipairs (self.m_tBoss:getAiScript()) do
        local isDone = true
        local conditionList = ai.condition
        for index, condition in ipairs (conditionList) do
            if condition.conditionType == AiConditionConfig.ACTIVE_ATTACK  then
                isDone = false
            end
        end
        ai.isAction = isDone
    end
end

function WMonsterAI:pushMonsterMsg(msg,isBlock,msgIndex)
    if isBlock then
        if self.m_tBoss:isFollowIndependent() or self.m_tBoss:isFollowAct() then
            self.m_tBoss:pushBlockMsg(msg)
        else
            MsgManager:pushBlockMsg(msg,msgIndex)
        end
    else
        if self.m_tBoss:isFollowIndependent() or self.m_tBoss:isFollowAct() then
            self.m_tBoss:pushNonBlockMsg(msg)
        else
            MsgManager:pushNonBlockMsg(msg)
        end
    end
end

--@brief    施放技能
function WMonsterAI:castSkillTalk(id,                          --ID
    conditionList,                                         --条件列表
    talkId,                                                 --对白
    skillTypeList
    )

    local msg = MsgManager:createMsg(BattleMsgBossMapSkill)
    msg.m_nId = id
    msg.m_tConditionList = conditionList
    msg.m_nTalkId = talkId
    msg.m_tSkillTypeList = skillTypeList
    msg.m_tOwner = self.m_tBoss or WBattleGlobal:getCurrent():getCurrentCharacter()
    msg.m_bIsCompareAction = false
    --MsgManager:pushBlockMsg(msg)
    self:pushMonsterMsg(msg,false)
end

--@brief    施放技能
function WMonsterAI:castSkill(id,                          --ID
    conditionList,                                         --条件列表
    talkId,                                                --对白
    skillTypeList,                                         --技能类型
    bulletAnimMainName, bulletAnimFlyName, weaponName, readyShootAnim, targetHero, attack, bulletAnimScale, bulletType, checkCharacterCollisionRadius, isPenetrateMap, attTimes, isIgnoreDef, bulletAnimFlipX, isNeedExplode, bulletAnimDefaultDirection, everyBulletShootDeltaTime,endPos,acceleration,isNeedHurt,startPos,scatterNum,offset,                              --射击
    summonMonsterList,                                     --召唤
    shootSummonMonsterList,                                --射击召唤
    moveMonsterList, moveEndPos,                           --移动和近攻
    transAniFileId, transAiType, transDataId, transState,  --变身
    skillId,                                               --技能
    bulletId,                                              --子弹Id
    effcetId,takeEffectType,
    hurtBullet,                                             --子弹计算伤害
    hurtTargetHeroList,                                     --技能计算伤害
    isPetSkillEffect,                                        --宠物技能效果 
    isBlock                                                --是否堵塞
    )

    WZLog("WMonsterAI:castSkill", tostring(skillId), tostring(effcetId), tostring(takeEffectType))

    local bulletInfo = {}
    if bulletId ~= nil then
        --WZLog("WMonsterAI:castSkill one", bulletId)
        --[[]
        bulletInfo = BulletInfoConfig["id_"..bulletId]
        bulletAnimMainName = bulletInfo.bulletAnimMainName
        bulletAnimFlyName = bulletInfo.bulletAnimFlyName
        bulletAnimScale = bulletInfo.bulletAnimScale / 100
        bulletType = bulletInfo.bulletType
        checkCharacterCollisionRadius = bulletInfo.checkCharacterCollisionRadius
        isPenetrateMap = bulletInfo.isPenetrateMap == 1
        attTimes = bulletInfo.attTimes
        isIgnoreDef = bulletInfo.isIgnoreDef == 1
        bulletAnimDefaultDirection = bulletInfo.bulletAnimDefaultDirection
        isNeedExplode = bulletInfo.isNeedExplode == 1
        isNeedHurt = bulletInfo.isNeedHurt == 1
        scatterNum = bulletInfo.scatterNum
        weaponName = bulletInfo.weaponName
        if bulletInfo.offsetX ~= 0 or bulletInfo.offsetY ~= 0 then
            offset =  {x=bulletInfo.offsetX, y=bulletInfo.offsetY}
        end
        ]]
        bulletInfo = BattleMethod:getBossBulletInfo(bulletId)
    end
    --[[
    local isOldBulletAnim = false
    if bulletAnimMainName ~= nil then
        for i,v in pairs (BulletConfig) do
            --WZLog("WMonsterAI:castSkill two", bulletAnimMainName, i, v)
            if string.gsub(bulletAnimMainName,"-","_") == i then
                isOldBulletAnim = true
                break
            end

        end
    end
    ]]

    local msg = MsgManager:createMsg(BattleMsgBossMapSkill)
    msg.m_nId = id
    msg.m_tConditionList = conditionList

    msg.m_nTalkId = talkId

    msg.m_tOwner = self.m_tBoss or WBattleGlobal:getCurrent():getCurrentCharacter()

    if TeachGroup1.ISBATTLE_MYTURN then
        msg.m_tOwner = WBattleGlobal:getCurrent():getMyHero()
    end

    if msg.m_tOwner:getType() == 1 and not msg.m_tOwner.m_bIsGuaiWithSuit then
        if WBattleGlobal:getCurrent():isExpCopy() then
            BattleCtbManager:addCtb(msg.m_tOwner:getBattleId(),1500)
        else
            BattleCtbManager:addCtb(msg.m_tOwner:getBattleId(),4000)
        end
    end

    msg.m_tBulletInfo = bulletInfo

    msg.m_tAcceleration = bulletInfo.m_tAcceleration
    msg.m_bIsOldBulletAnim = isOldBulletAnim
    msg.m_sBulletAnimMainName = bulletInfo.m_sBulletAnimMainName
    msg.m_sBulletAnimFlyName = bulletInfo.m_sBulletAnimFlyName
    msg.m_sWeaponName = bulletInfo.m_sWeaponName or self.m_tBoss and self.m_tBoss:getWeaponName()
    msg.m_sReadyShootAnim = readyShootAnim or "skill"
    msg.m_tSkillTypeList = skillTypeList
    msg.m_tWeaponAnim = {weapon=msg.m_sWeaponName}
    msg.m_tTargetHero = targetHero --or self.m_tBoss and self.m_tBoss.m_tTargetPlayer
    msg.m_nAttack = attack or self.m_tBoss and self.m_tBoss.m_nAttack
    msg.m_nBulletAnimScale = bulletInfo.m_nBulletAnimScale
    msg.m_nBulletType = bulletInfo.m_nBulletType
    msg.m_nCheckCharacterCollisionRadius = bulletInfo.m_nCheckCharacterCollisionRadius
    msg.m_bIsPenetrateMap = bulletInfo.m_bIsPenetrateMap
    msg.m_nAttTimes = bulletInfo.m_nAttTimes
    msg.m_bIsIgnoreDef = bulletInfo.m_bIsIgnoreDef
    msg.m_bBulletAnimFlipX = bulletInfo.m_bBulletAnimFlipX or (bulletAnimDefaultDirection == DirectionType.LEFT)
    msg.m_bIsNeedExplode = bulletInfo.m_bIsNeedExplode
    msg.m_nBulletAnimDefaultDirection = bulletInfo.m_nBulletAnimDefaultDirection
    msg.m_nEveryBulletShootDeltaTime = bulletInfo.m_nEveryBulletShootDeltaTime or 0.4
    msg.m_tEndPos = endPos
    msg.m_bIsNeedHurt = bulletInfo.m_bIsNeedHurt
    msg.m_tStartPos = startPos
    msg.m_nScatterNum = bulletInfo.m_nScatterNum
    msg.m_tOffset = bulletInfo.m_tOffset or BattleCommon:getPointTable(0,0)

    msg.m_tSummonMonsterList = summonMonsterList

    msg.m_tShootSummonMonsterList = shootSummonMonsterList

    msg.m_tMonsterList = moveMonsterList
    msg.m_tMoveEndPos = moveEndPos

    msg.m_nTransAniFileId = transAniFileId
    msg.m_nTransAiType = transAiType
    msg.m_nTransDataId = transDataId
    msg.m_nTransState = transState

    msg.m_nSkillId = skillId or effcetId

    msg.m_nEffcetId = skillId or effcetId

    msg.m_tHurtBullet = hurtBullet
    msg.m_tHurtTargetHeroList = hurtTargetHeroList
    msg.m_nTakeEffectType = takeEffectType
    msg.m_bIsPetSkillEffect = isPetSkillEffect
    if TeachGroup1.ISSKILL == nil and (takeEffectType == nil or takeEffectType == TakeEffectType.USE) then
        -- MsgManager:pushBlockMsg(msg)
        if takeEffectType == TakeEffectType.USE then
            MsgManager:pushBlockMsg(msg)
        elseif takeEffectType == TakeEffectType.TREASURE then
            MsgManager:pushNonBlockMsg(msg)
        else
            self:pushMonsterMsg(msg,true)
        end
    else
        if TeachGroup1.ISSKILL == true then
            TeachGroup1.ISSKILL = nil
        end
        WZLog("WMonsterAI:castSkill three")
        if WBattleGlobal:getCurrent():isReplayGame() then
            if isBlock then
                MsgManager:pushBlockMsg(msg)
            else
                MsgManager:pushNonBlockMsg(msg)
            end
        else
            MsgManager:pushNonBlockMsg(msg)
        end
    end
end







    
    
    
    
    
    
    
    
-------------------------------------私有方法模块--------------------------------------

