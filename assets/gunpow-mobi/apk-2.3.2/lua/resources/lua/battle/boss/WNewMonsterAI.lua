--WNewMonsterAI.lua
--@brief    怪物的Ai数据表
--@date     2014/3/18
--@author   莫剑峰
--@note

--@brief    怪物的Ai数据表
WNewMonsterAI = {
    m_nCurStatus = 0,       --状态
    m_tBoss = nil,          --AI对应的怪物
    m_nCharacterId,         --角色ID
    m_tRandNumList = nil,   --战斗随机数组
    m_nRandNumIndex = 0,    --战斗随机数组下标
    m_nCurRandNum = 0,      --当前回合随机数
    m_nAttackRound = 0,     --当前攻击回合
    m_nDt = 0,              --调用时间累加

    m_bFollowIndependentDone = false, --跟随行动怪物行动处理
    m_bIsONFollowAction = nil,      --无CTB小怪行动中

    m_tActionList = nil,--行动队列
    m_bCurRoundAiIsCheck = nil,--当前回合已经行动
    m_tEndSkillAction = nil,
}

-------------------------------------公有方法模块--------------------------------------
--@brief    以本表为模版创建一个新的表实例对象
--@return   新建的表实例对象
function WNewMonsterAI:new(nCharacterId)
    --WZLog("WNewMonsterAI:new")
    local tNewObj = {}
    setmetatable(tNewObj, self)
    self.__index = self
    tNewObj.m_nCharacterId = nCharacterId
    tNewObj:setBoss(WBattleGlobal:getCurrent():getCharacterWithId(nCharacterId))
    tNewObj.m_tSkillsUsed = {} --技能使用记录
    tNewObj.m_nLastSkillUsedId = -1 --上一回合使用技能
    tNewObj.m_bAiDisplacementDone = true
    return tNewObj
end

--@brief    销毁
function WNewMonsterAI:destroy()
    self.m_nCurStatus = 0
    self.m_tBoss = nil
    self.m_tRandNumList = nil   --战斗随机数组
    self.m_nRandNumIndex = 0    --战斗随机数组下标
    self.m_nCurRandNum = 0      --当前回合随机数
    self.m_nDt = 0              --调用时间累加
    self.m_bIsAddFlyWithNextTurn = false
    self.m_tCheckOnceArray = nil
end

--@brief    根据分隔符拆分ai字符串"
--@param    s:要分隔的字符串
function WNewMonsterAI:splitAiStringWithSeparator(s)
    --WZLog("WNewMonsterAI:splitAiStringWithSeparator zero", s)
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
        --WZLog("WNewMonsterAI:splitAiStringWithSeparator one", i, s, action)
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
        --WZLog("WNewMonsterAI:splitAiStringWithSeparator three", i, action)
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
                --WZLog("WNewMonsterAI:splitAiStringWithSeparator four-0", k, vOri, tostring(v), tostring(ai[i]["actionCountMax"]), Serialize(actCount))
            end
            --WZLog("WNewMonsterAI:splitAiStringWithSeparator four-1", k, v)
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
                    --WZLog("WNewMonsterAI:splitAiStringWithSeparator five-1", j, i, v)
                end
            elseif j ~= "actionCountMax" and j ~= "actionCount" then
                for k, w in pairs (u) do
                    for i, v in pairs (w) do
                        --WZLog("WNewMonsterAI:splitAiStringWithSeparator five-1", j, k, i, v)
                    end
                end
            end
        end
    end

    return ai
end

--@brief 解析配置
function WNewMonsterAI:parseScript()
    local aiScript = self.m_tBoss.m_tAiScript
    if aiScript == -1 then
        self.m_tBoss.m_tAiScript = {}
        return
    else
        for i,v in pairs (aiScript) do
            aiScript[i] = self:splitAiStringWithSeparator(v)
        end
    end
   
    WZLog("WNewMonsterAI:setAiInterface one", Serialize(aiScript))

    self.m_tBoss.m_tAiScript = aiScript
end

function WNewMonsterAI:sendSkill(skillId)
     --协议发送
    if self:isCanControl() then
        if id and id ~= -1 then
            self.m_tBoss:sendAiProcol(id)
        end
    end

    local skillConfig = GDatatab_skill["id_"..skillId]
    local targetList = BattleChooseMethod:chooseTarget(self.m_tBoss,{[1]=skillConfig.choose,[2]=skillConfig.chooseParm[1],[3]=skillConfig.chooseParm[2]})
    local targetIds = {}
    for i,v in pairs(targetList) do
        table.insert(targetIds,v:getBattleId())
    end
    ProtocolProcessorBattleInterface:send_BATTLE_SkillEquip(WBattleGlobal:getCurrent():getBattleId(), self.m_tBoss:getBattleId(), skillId ,targetIds)
end

--@brief    行动
function WNewMonsterAI:doAction(actionType, parmList, conditionList, isNoMyTurn,id, isNoBlock,msgIndex,notReplayMsg)
    WZLog("WNewMonsterAI:doAction",tostring(notReplayMsg),tostring(isNoBlock))
    if not self.m_tBoss or self.m_tBoss:isDead() then
        return
    end
    if WBattleGlobal:getCurrent():isSingleStage() == true and self.m_tBoss and self.m_tBoss:isDead() == true then
        if WBattleGlobal:getCurrent().m_bIsCurTurnActed ~= true then
            self:nextRound()
        end
        return
    end

    if WBattleGlobal:getCurrent():isFlyCopy() and notReplayMsg == nil then
        if WBattleGlobal:getCurrent().m_bIsCurTurnActed ~= true then
            local dis = BattleCommon:pointDis(self.m_tBoss:getPosition(), WBattleGlobal:getCurrent():getMyHero():getPosition())
            if dis < 80 then
                self:doAction(AiActionConfig.SKILL,{[1] = {actionParm1 = 80003}},nil,nil,nil,nil,nil,true)
            else
                self:nextRound()
            end
        end
        return
    end

    WBattleGlobal:getCurrent().m_bIsCurTurnActed = true
    
    --WZLog("WNewMonsterAI:doAction one", id, actionType,tostring(self.m_nAiActionCount), tostring(isNoMyTurn), tostring(isNoBlock))
 
    local boss = self.m_tBoss
    local talkId = nil
    --发送同步技能协议，只有主机，当前回合控制怪物和跟随行动小怪
    if self.m_tBoss:isCanControl() then
        if actionType == AiActionConfig.SKILL or actionType == AiActionConfig.FOLLOW_ACTION_SKILL or actionType == AiActionConfig.MOVE_ACTION_SKILL then
            self:sendSkill(parmList[1].actionParm1)
        end 
    end

    if actionType == AiActionConfig.END_ACTION_SKILL then
        table.insert(self.m_tEndSkillAction,parmList[1].actionParm1)
    elseif actionType == AiActionConfig.SUICIDE then
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
        --WZLog("WNewMonsterAI:doAction two",parmList.actionParm1, parmList.actionParm2, parmList.actionParm3)
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
        local moveStepPos =  BattleCommon:getPointTable(tx,ty)
        local targetPos = BattleCommon:getPointTable(tx,ty)
        WZLog("targetPos:",parmList.actionParm1,parmList.actionParm2,parmList.actionParm3,parmList.actionParm4)
        --目标位置不存在(最近存活玩家)
        if parmList.actionParm3 == -1 then
            local list = self:getTargetList()
            local dis = nil
            local heroPos = nil
            for id, hero in ipairs(list) do
                local distance = BattleCommon:pointDis(hero:getPosition(),bossPos)
                if not dis then
                    dis = distance
                    heroPos = hero:getPosition()
                elseif dis > distance then
                    dis = distance
                    heroPos = hero:getPosition()
                end
            end
            targetPos = BattleCommon:getPointTable(heroPos.x,heroPos.y)
            moveStepPos = BattleCommon:getPointTable(heroPos.x,heroPos.y)
        else
            local tx2,ty2 = parmList.actionParm3,parmList.actionParm4
            targetPos = BattleCommon:getPointTable(tx2,ty2)
        end
        

        local msg = MsgManager:createMsg(BattleMsgSkillShow)
        msg.m_tOwner = self.m_tBoss or WBattleGlobal:getCurrent():getCurrentCharacter()
        msg.m_nSkillId = nil
        msg.m_nActionId = 1 --移动表演id
        msg.m_tMoveParm = {}
        msg.m_tMoveParm.moveStepPos = moveStepPos
        msg.m_tMoveParm.targetPos = targetPos
        if  notReplayMsg then
            msg.m_bIsReplayMsg = false --结束标记
        end
        if isNoBlock == nil then
            self:pushMonsterMsg(msg,true)
        else
            self:pushMonsterMsg(msg,false)
        end
        WZLog("WNewMonsterAI:doAction-move",tostring(notReplayMsg))
        if WBattleGlobal:getCurrent():canRecordGame() then
        -- self.m_tOwner:getAI():doAction(AiActionConfig.MOVE_NEW,
        -- {[1] = {actionParm1 = moveDis,actionParm2 = 0,actionParm3 = self.m_tOwner:getPosition().x + moveDis,actionParm4 = 0}},
        -- nil, nil,nil, true)
            --录像记录
            local replayParam = {}
            replayParam.m_nBattleId = self.m_tBoss.m_nBattleId
            replayParam.actionParm1 = parmList.actionParm1
            replayParam.actionParm2 = parmList.actionParm2
            replayParam.actionParm3 = parmList.actionParm3
            replayParam.actionParm4 = parmList.actionParm4
            
            BattleMsgReplayGameRecord:setMonsterMove(replayParam)
        end

    elseif actionType == AiActionConfig.SELF_BOOM then
        WBattleGlobal:getCurrent():setHoldMonsterRecord(self.m_tBoss:getBattleId())
        parmList = parmList[1]

        local msg = MsgManager:createMsg(BattleMsgSkillShow)
        msg.m_tOwner = self.m_tBoss or WBattleGlobal:getCurrent():getCurrentCharacter()
        msg.m_nSkillId = nil
        msg.m_nActionId = 2 --自爆表演id
        msg.m_nBoomDistance = parmList.actionParm1
         if not notReplayMsg then
            msg.m_bIsReplayMsg = true --结束标记
        end
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
         if notReplayMsg then
            msg.m_bIsReplayMsg = false --结束标记
        end
        if isNoBlock == nil then
            self:pushMonsterMsg(msg,true)
        else
            self:pushMonsterMsg(msg,false)
        end


        if WBattleGlobal:getCurrent():canRecordGame() then
       -- self.m_tOwner:getAI():doAction(AiActionConfig.FLY,{[1] = {actionParm1 = sPos.x,actionParm2 = sPos.y,actionParm3 = speed.x,actionParm4 = speed.y}})
            --录像记录
            local replayParam = {}
            replayParam.m_nBattleId = self.m_tBoss.m_nBattleId
            replayParam.actionParm1 = parmList.actionParm1
            replayParam.actionParm2 = parmList.actionParm2
            replayParam.actionParm3 = parmList.actionParm3
            replayParam.actionParm4 = parmList.actionParm4
            
            BattleMsgReplayGameRecord:setMonsterFly(replayParam)
        end
    elseif actionType == AiActionConfig.SKILL or actionType == AiActionConfig.FOLLOW_ACTION_SKILL or actionType == AiActionConfig.MOVE_ACTION_SKILL then
        parmList = parmList[1]
        local skillId = parmList.actionParm1
        
        self.m_tSkillsUsed[skillId] = self.m_nAttackRound
        if actionType == AiActionConfig.SKILL then
            self.m_nLastSkillUsedId = skillId
        end
        self:doSkillAction(skillId,isNoBlock)
        --WZLog("WNewMonsterAI:doAction four", parmList.actionParm1)
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
                                --WZLog("WNewMonsterAI:doAction three-1111",boss.m_tActiveAttackPos[i].bulletId,condition.conditionParm1)
                                if not boss.m_tActiveAttackPos[i].bulletId or boss.m_tActiveAttackPos[i].bulletId == condition.conditionParm1 then
                                    table.insert(posX, boss.m_tActiveAttackPos[i].x)
                                    table.insert(posY, boss.m_tActiveAttackPos[i].y)
                                    --WZLog("WNewMonsterAI:doAction three-1",boss.m_tActiveAttackPos[i].x, boss.m_tActiveAttackPos[i].y)
                                end
                                break
                            end
                        end
                    end
                end
                if #posX > 0 and #posY > 0 then
                    table.insert(summonMonsterList, {battleId={},id=parms.actionParm1,count=parms.actionParm2,maxCount=parms.actionParm3,scale=BossData["id_"..parms.actionParm1].scale,posX=posX,posY=posY})
                    --WZLog("WNewMonsterAI:doAction three-2", parms.actionParm1, parms.actionParm2, parms.actionParm3, parms.actionParm4, 1, parms.actionParm6, parms.actionParm7, parms.actionParm8)
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
        --WZLog("WNewMonsterAI:doAction five-0", tostring(parmList.actionParm1), tostring(tonumber(parmList.actionParm1)))
        talkId = parmList.actionParm2
        if self.m_tBoss.m_nAiType == MonsterAiType.AI_MELEE or self.m_tBoss.m_nAiType == MonsterAiType.AI_MELEE_SKY then
            self.m_tBoss:getNearestPlayer()
            table.insert(moveMonsterList, boss)

            if #moveMonsterList > 0 then
                --WZLog("WNewMonsterAI:doAction five-1")
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
            end
        else
            local bulletId = tonumber(parmList.actionParm1) or self.m_tBoss.m_nBulletId
            local readyShootAnim = parmList.actionParm2 and tostring(parmList.actionParm2) or nil
            if bulletId ~= -1 then
                --WZLog("WNewMonsterAI:doAction five-2")
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
            end
        end
    elseif actionType == AiActionConfig.TALK then
        --WZLog("WNewMonsterAI:doAction talk:",Serialize(parmList))
        self:castSkillTalk(nil,
        nil,
        parmList[1].actionParm1,{}
        )
        local msg = MsgManager:createMsg(BattleMsgBossMapSkill)
        msg.m_nId = nil
        msg.m_nTalkId = parmList[1].actionParm1
        msg.m_tSkillTypeList = {}
        msg.m_tOwner = self.m_tBoss or WBattleGlobal:getCurrent():getCurrentCharacter()
        msg.m_bIsCompareAction = false
        self:pushMonsterMsg(msg,false)
    end

end

function WNewMonsterAI:doSkillAction(skillId,isNoBlock)
    local talkId = self:checkSkillTalk(skillId)
    local msg = MsgManager:createMsg(BattleMsgSkillShow)
    msg.m_tOwner = self.m_tBoss or WBattleGlobal:getCurrent():getCurrentCharacter()
    msg.m_nSkillId = skillId
    msg.m_nTalkId = talkId
     if notReplayMsg then
        msg.m_bIsReplayMsg = false --结束标记
    end
    if isNoBlock == nil then
        -- MsgManager:pushBlockMsg(msg)
        self:pushMonsterMsg(msg,true,msgIndex)
    else
        -- MsgManager:pushNonBlockMsg(msg)
        self:pushMonsterMsg(msg,false)
    end

    --录像记录
    WBattleGlobal:getCurrent():replayRecordSinglePos()
    if WBattleGlobal:getCurrent():canRecordGame() then
        local replayParam = {}
        replayParam.m_nBattleId = self.m_tBoss.m_nBattleId
        replayParam.m_nSkillId = skillId
        replayParam.m_nTalkId = talkId
        BattleMsgReplayGameRecord:setMonsterAction(replayParam)
    end

end

--@brief 技能说话
function WNewMonsterAI:checkSkillTalk(skillId)
    local talkId = -1
    for i = 1,#self.m_tBoss.m_nSklillTalkList[1] do
        local tSkillId = self.m_tBoss.m_nSklillTalkList[1][i]
        if tSkillId == skillId then
            talkId = self.m_tBoss.m_nSklillTalkList[2][i]
            break
        end
    end
    return talkId
end

--@brief 判断ai行为条件
function WNewMonsterAI:checkActionAiCondition(actionType,parmList,actionSpace)
    local result = true
    if actionSpace then
        local skillId = parmList[1].actionParm1
         --上一回合已经使用
        if self.m_tSkillsUsed[skillId] and self.m_tSkillsUsed[skillId] == self.m_nAttackRound - 1 then
            result = false
        end
        --WZLog("WNewMonsterAI:checkActionAiCondition",result,skillId,self.m_nAttackRound,self.m_tSkillsUsed[skillId])
    end
    return result
end

--@brief    判断满足AI条件
function WNewMonsterAI:checkMatchAiCondition(conditionType, parmList)
    --local function WZLog(...) end
    --WZLog("WNewMonsterAI:checkMatchAiCondition zero", self.m_tBoss:getBattleId(), conditionType, parmList.conditionParm1, parmList.conditionParm2, parmList.conditionParm3, parmList.conditionParm4)
    local isMatch = false
    local boss = self.m_tBoss

    if conditionType == AiConditionConfig.ACTIVE_ATTACK then
        --WZLog("WNewMonsterAI:checkMatchAiCondition zero-1", tostring(boss.m_bActiveAttack))
        if boss.m_bActiveAttack == true then
            isMatch = true
        end
    elseif conditionType == AiConditionConfig.PASSIVE_ATTACK then
        --WZLog("WNewMonsterAI:checkMatchAiCondition zero-2", tostring(boss.m_bPassiveAttack))
        if boss.m_bPassiveAttack == true then
            isMatch = true
        end
    elseif conditionType == AiConditionConfig.ATTACK_TURN then
        --WZLog("WNewMonsterAI:checkMatchAiCondition one-1", parmList.conditionParm1, parmList.conditionParm2, WBattleGlobal:getCurrent():getTurnTimes())
        --if self:comparison(WBattleGlobal:getCurrent():getTurnTimes(), parmList.conditionParm2, parmList.conditionParm1) then
        if self:comparison(self.m_nAttackRound, parmList.conditionParm2, parmList.conditionParm1) then
            isMatch = true
        end
    elseif conditionType == AiConditionConfig.ATTACK_TURN_PRE then
        if self.m_nAttackRound > 1 and (self.m_nAttackRound %  parmList.conditionParm1 == 0) then
            return true
        else
            return false
        end
    elseif conditionType == AiConditionConfig.RANDOM then
        local randList = WBattleGlobal:getCurrent().m_tBattleRand
        local randIndex = WBattleGlobal:getCurrent():getTurnTimes() % 10 + 1
        local randValue = (math.abs(randList[randIndex]) / 10000) * 100
        --WZLog("WNewMonsterAI:checkMatchAiCondition one-2",randValue, parmList.conditionParm1)
        if randValue <= parmList.conditionParm1 then
            isMatch = true
        end
    elseif conditionType == AiConditionConfig.HP_PERCENT_TARGET then
        --WZLog("WNewMonsterAI:checkMatchAiCondition one-3")
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
        --WZLog("WNewMonsterAI:checkMatchAiCondition one-4")
        isMatch = self:checkTargetListMatchCondition(parmList.conditionParm1, self.getTargetHpIsDead, OperatorConfig.EQUAL, true)
    elseif conditionType == AiConditionConfig.DISTANCE_X then
        isMatch = self:checkTargetListMatchCondition(parmList.conditionParm3, self.getTargetDistance, parmList.conditionParm2, parmList.conditionParm1, 1, DistanceConfig.X)
    elseif conditionType == AiConditionConfig.DISTANCE_Y then
        isMatch = self:checkTargetListMatchCondition(parmList.conditionParm3, self.getTargetDistance, parmList.conditionParm2, parmList.conditionParm1, 1, DistanceConfig.Y)
    elseif conditionType == AiConditionConfig.DISTANCE then
        isMatch = self:checkTargetListMatchCondition(parmList.conditionParm3, self.getTargetDistance, parmList.conditionParm2, parmList.conditionParm1, 1, DistanceConfig.NO)
         --取反
        if parmList.conditionParm4 == 0 then
            isMatch = not isMatch
        end
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
    elseif conditionType == AiConditionConfig.SUMMON_POS_EMPTY then
        isMatch = self:checkSummonPosEmpty(parmList.conditionParm1, parmList.conditionParm2,parmList.conditionParm3)  
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
            if v == tostring(self.m_nLastSkillUsedId) then
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
    elseif conditionType == AiConditionConfig.MONSTER_TYPE_IN_BATTLE then
        isMatch = self:checkMonsterTypeInBattle(parmList.conditionParm1,parmList.conditionParm2)
    elseif conditionType == AiConditionConfig.IN_BUFF_ID then
        isMatch = self:checkMonsterInBuffId(parmList.conditionParm1,parmList.conditionParm2,parmList.conditionParm3)
        WZLog("WNewMonsterAI:checkMonsterInBuffId",tostring(isMatch),parmList.conditionParm1,parmList.conditionParm2)
    elseif conditionType == AiConditionConfig.IN_MAX_SP then
        isMatch = self.m_tBoss:getSp() >= self.m_tBoss.m_nMaxSP
    end
    
    --WZLog("WNewMonsterAI:checkMatchAiCondition two", conditionType, isMatch)
    return isMatch
end

--@brief    检查目标存在buffId 
--@param    isNot == 0 取反
function WNewMonsterAI:checkMonsterInBuffId(buffId,targetType,isNot)
    targetType = targetType or 1
    isNot = isNot or 1
    if targetType == 1 then
        --自己
        local hero = self.m_tBoss
        if hero:isDead() ~= true then
            for index, buff in pairs (hero.m_tBuffChangeStateList) do 
                if buffId == buff.m_nID then
                    if isNot == 1 then
                        return true
                    else
                        return false
                    end
                end
            end
        end
    elseif targetType == 2 then
        --所有敌人
        for i,hero in pairs(WBattleGlobal:getCurrent():getHeroSortList()) do
            if hero:isDead() ~= true then
                for index, buff in pairs (hero.m_tBuffChangeStateList) do 
                    if buffId == buff.m_nID then
                        if isNot == 1 then
                            return true
                        else
                            return false
                        end
                    end
                end
            end
        end
    end
    if isNot == 1 then
        return false
    else
        return true
    end
end

--@brief    检查目标是否存在buff效果
function WNewMonsterAI:checkMonsterInBuff(limitType)
    for i,hero in pairs(WBattleGlobal:getCurrent():getHeroSortList()) do
        if not hero:isDead() and hero:isInBuffState(limitType) then
            return true
        end 
    end
    return false
end

--@brief    检查对应的怪物id 是否在场
function WNewMonsterAI:checkMonsterInBattle(monsterId,isOut)
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

--@brief 检查怪物类型数量
function WNewMonsterAI:checkMonsterTypeInBattle(monsterType,max)
    local count = 0
    for j, u in pairs(WBattleGlobal:getCurrent():getCharacterList()) do
        if u:getType() ~=0 and u.m_nMonsterType == monsterType then
            count = count + 1
        end
    end
    WZLog("WNewMonsterAI:checkMonsterInBattle",count,max)
    return count == max
end

--@brief    检查目标在范围内
function WNewMonsterAI:checkTargetInRect(nLeftPointX,nRightPointX,nDownPointY,nUpPointY)
    local result,heroList = WMonster:getPlayerWithArea(nLeftPointX, nRightPointX,nDownPointY, nUpPointY)
    return result
end

--@brief    检查召唤怪物数量
function WNewMonsterAI:checkSummonMax(monsterId,max)
    --WZLog("WNewMonsterAI:checkSummonMax",monsterId,max)
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

--@brief    检查召唤怪物位置是否为空
function WNewMonsterAI:checkSummonPosEmpty(posX,posY,distance)
    -- WZLog("WNewMonsterAI:checkSummonPosEmpty",posX,PosY,distance)
    local summonCount = 0
    distance = distance or 100
    local tPos = BattleCommon:getPointTable(posX,posY)
    for i, monster in pairs(WBattleGlobal:getCurrent():getGuaiList()) do
        local monsterPos = monster:getPosition()
        -- WZLog("WNewMonsterAI:checkSummonPosEmpty-2",BattleCommon:pointDis(tPos,monsterPos),monsterPos.x,monsterPos.y)
        if BattleCommon:pointDis(tPos,monsterPos) < distance then
            return false
        end
    end
    return true
end

--@brief    检查目标状态值
function WNewMonsterAI:checkMonsterState(stateType,state,targetListMark)
    --WZLog("WNewMonsterAI:checkMonsterState", targetListMark, state)
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
function WNewMonsterAI:checkTargetState(target,stateType,state)
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
function WNewMonsterAI:getTargetHpPercent(hero)
    local value = hero:getHp() / hero:getMaxHp() * 100
    return value
end

--@brief    获取目标血量值
function WNewMonsterAI:getTargetHpValue(hero)
    local value = hero:getHp()
    return value
end

--@brief    获取目标是否死亡
function WNewMonsterAI:getTargetHpIsDead(hero)
    local value = hero:isDead()
    return value
end

--@brief    获取目标X方向的距离
function WNewMonsterAI:getTargetDistance(hero, haveTarget, distanceConfig)
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

function WNewMonsterAI:getTargetList(targetListMark)
    if targetListMark == 2 or targetListMark == 3 then
        local targetAll = {}
        for id, hero in ipairs(WBattleGlobal:getCurrent():getHeroSortList()) do
            if (not hero:isDead()) then--and hero.m_bLoseNet ~= true then
                table.insert(targetAll, hero)
            end
        end
        return targetAll
    end
    return {[1]=self.m_tBoss}
end

--@brief    检查目标群是否符合条件
function WNewMonsterAI:checkTargetListMatchCondition(targetListMark, leftValueFunction, operator, rightValue, etc1, etc2)
    local isMatch = false
    local target = {}
    local matchList = {}
    local targetOne = {[1]=self.m_tBoss}
    local targetAll = {}
    for id, hero in pairs(WBattleGlobal:getCurrent():getHeroList()) do
        if (not hero:isDead()) then--and hero.m_bLoseNet ~= true then
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
            --WZLog("WNewMonsterAI:checkTargetListMatchCondition three",id ,hero.m_nPlayerId,targetListMark)
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
        --WZLog("WNewMonsterAI:checkTargetListMatchCondition one",i ,result)
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

    --WZLog("WNewMonsterAI:checkTargetListMatchCondition two", tostring(isMatch), #matchList, #target, targetListMark, tostring(leftValueFunction), operator, rightValue, tostring(etc1), tostring(etc2))
    return isMatch
end

--@brief    关系运算
function WNewMonsterAI:comparison(leftValue, operator, rightValue)
    --WZLog("WNewMonsterAI:comparison one", leftValue, operator, rightValue)
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

    --WZLog("WNewMonsterAI:comparison two", result)
    return result
end

--@brief    获取当前随机数
function WNewMonsterAI:getCurRandNum()
    self.m_tRandNumList = WBattleGlobal:getCurrent().m_tBattleRand
    self.m_nRandNumIndex = (self.m_nRandNumIndex + math.abs(self.m_tBoss:getBattleId()) ) % 10 + 1
    self.m_nCurRandNum = self.m_tRandNumList[self.m_nRandNumIndex]
    
    return self.m_nCurRandNum
end


--@brief    开始行动
function WNewMonsterAI:startRound()
    WZLog("WNewMonsterAI:startRound", self.m_tBoss:getBattleId(), self.m_tBoss:isDead(), WBattleGlobal:getCurrent():isSingleStage())

    if self.m_tBoss:isDead() then
        WZLog("WNewMonsterAI:startRound zero")
        return
    end
    self.m_nAttackRound = self.m_nAttackRound + 1
    self.m_tRandNumList = WBattleGlobal:getCurrent().m_tBattleRand
    self.m_nRandNumIndex = (WBattleGlobal:getCurrent():getTurnTimes() + math.abs(self.m_tBoss:getBattleId())) % 10 + 1
    self.m_nCurRandNum = self.m_tRandNumList[self.m_nRandNumIndex]

    local mapId = WBattleGlobal:getCurrent().m_tMakePairOk.mapId
    local turnTimes = WBattleGlobal:getCurrent():getTurnTimes()
    if mapId == 10101 and turnTimes == 2 then 
        PostPlayerEvent:postEvent(PostPlayerEvent.event_oneLvMonsterAttack)
    elseif mapId == 10101 and turnTimes == 4 then 
        PostPlayerEvent:postEvent(PostPlayerEvent.event_oneLvMonsterAttack2)
    end

    self.m_bFollowIndependentDone = false
    self.m_bCurRoundAiIsCheck = false
    self.m_tActionList = {} --行动队列
    self.m_tSyncActionList = {} --已经同步的行动队列
    self.m_tEndSkillAction = {}
    
    self.m_tBoss.m_bPassiveAttack = false
    self.m_tBoss.m_bActiveAttack = false
    self.m_tBoss.m_tActiveAttackPos = {}
    self.m_tBoss.m_tActiveAttackHero = {}

    for id, ai in ipairs (self.m_tBoss:getAiScript()) do
        ai.isAction = nil
    end
    self.m_nCharacterId = self.m_tBoss:getBattleId()
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCharacterId)
    -- hero:setPF(100)
    --WZLog("WNewMonsterAI:startRound is my trun", WBattleGlobal:getCurrent():getCurrentCharacterId(), self.m_tBoss.m_nAiType, self.m_tBoss:getBattleId(), self:isCanControl())
    
    self.m_bMoveActionIn = false

    if not WBattleGlobal:getCurrent():isReplayGame() and (self:isCanControl() or WBattleGlobal:getCurrent():isDoubleTowerStage() or WBattleGlobal:getCurrent():isHostChallengeStage()) then--WBattleGlobal:getCurrent():getCurrentCharacterId() == self.m_tBoss:getBattleId() then

        self.m_nCurStatus = -1
        WZLog("WNewMonsterAI:startRound",self.m_tBoss.m_nAiDisplaceType)
        --位移行动(不支持组队副本boss做通用位移行动)
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
end

--@brief 改变ai策略
function WNewMonsterAI:changeAiState()
    for id, ai in ipairs (self.m_tBoss:getAiScript()) do
        ai.isAction = nil
    end

    self.m_nCurStatus = -1
end

--@brief    结束行动
function WNewMonsterAI:endRound()
    --WZLog("WNewMonsterAI:endRound")
   
    self.m_nCurStatus = 0
end

--@brief    切换行动时重置操作
function WNewMonsterAI:resetParam()
    
    self.m_nDt = 0
end

--@brief    设置AI对应的怪
function WNewMonsterAI:setBoss(tBoss)
    self.m_tBoss = tBoss
end

--@brief    消息处理完成函数
--@note     结束当前回合
function WNewMonsterAI:nextRound()
    local isRealEnd = self:isRealEnd()
    WZLog("WNewMonsterAI:nextRound",isRealEnd)
    
    if not isRealEnd then
        return
    end
    WBattleGlobal:getCurrent():endCurRound(self.m_tBoss:getBattleId(),21)
    
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

function WNewMonsterAI:isRealEnd()
    --（跟随行动）主怪物行动结束
    if self.m_tBoss:isFollowIndependent() then 
        WZLog("WNewMonsterAI:isRealEnd Follow Done")
        local owner = self.m_tBoss.m_tBoss
        self.m_bFollowIndependentDone = true
        owner:getAI():nextRound()
        return false
    end
    --拥有更随小怪的行动结束
    if self.m_tBoss:hasFollowIndependentMonster() then
        WZLog("WNewMonsterAI:isRealEnd II")
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
            WZLog("WNewMonsterAI:isRealEnd V",count,tmpCount)
            return false
        end
    end
    --正常结束
    return true
end

--@brief 控制权
function WNewMonsterAI:isCanControl()
    if self.m_tBoss:isCanControl() == true then
        return true
    end
    if self.m_tBoss:isFollowIndependent() and self.m_tBoss.m_tBoss:isCanControl() then
        return true
    end
    return false
end

function WNewMonsterAI:aiAllDone()
    if self:isCanControl() then
        WZLog("WNewMonsterAI:aiAllDone",self.m_tBoss:getBattleId())
        self.m_nCurStatus = 0
        if self.m_tBoss:isCurrentControl() then
            self:nextRound()
        end
    end
end

--@brief    运作
--@param    dt:距离上一次调用的时间（秒）
function WNewMonsterAI:run(dt)
    if WBattleGlobal:getCurrent():isReplayGame() then
        return
    end
    --跟随行动 没独立ai的忽略
    if TeachGroup1.ISBATTLE_MYTURN or self.m_tBoss:isFollowAct() or WBattleGlobal:getCurrent():isGameOver() then
        return
    end
    if not self.m_bAiDisplacementDone then
        return
    end
    --位移
    if self.m_bMoveActionIn then
        return
    end

--    WZLog("WNewMonsterAI:run nine", self.m_tBoss:getId(), self.m_tBoss:getBattleId(), self.m_nCurStatus)
    if self:isCanControl() == true and self.m_nCurStatus == -1 then
        if MsgManager:getBlockMsgByName("BattleMsgSomeOneDead") then
            return
        end
       

        local hero = self.m_tBoss
        local turnTimes = WBattleGlobal:getCurrent():getTurnTimes()

        WZLog("WNewMonsterAI:nextRound check", self.m_bCurRoundAiIsCheck, self:checkActionIsEnd())
        if self.m_bCurRoundAiIsCheck and self:checkActionIsEnd() then
            WZLog("WNewMonsterAI:nextRound check",self.m_tBoss:getBattleId())
            self.m_nCurStatus = 0
            if self.m_tBoss:isCurrentControl() then
                self:nextRound()
            end
            return
        end
        local defualDone = true
        for id, ai in ipairs (self.m_tBoss:getAiScript()) do
            local action = ai.action
            --buff限制使用技能,只能用普通攻击
            local isLimitSkil = self.m_tBoss:isInBuffState(EffectTypeConfig.LIMIT_USE_SKILL)
            --WZLog("WNewMonsterAI:run ten-1", self.m_tBoss:getId(), tostring(ai.isAction), id, ai.actionCount, ai.actionCountMax, tostring(action.actionFormat), tostring(ai.action[1] and ai.action[1].actionParm1), tostring(isLimitSkil), Serialize(ai))
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
                        WZLog("WNewMonsterAI:run ten-2", self.m_tBoss:getId(), id, ai.actionCount, ai.actionCountMax, tostring(action.actionFormat), tostring(ai.action[1] and ai.action[1].actionParm1), tostring(isLimitSkil), Serialize(ai))

                        if (not isLimitSkil) or (isLimitSkil and action.actionType ~= AiActionConfig.SKILL) or (isLimitSkil and ai.action[1] and ai.action[1].actionParm1 ~= nil and ai.action[1].actionParm1 == 20000) then
                            WZLog("WNewMonsterAI:run ten-3", self.m_tBoss:getId(), id, ai.actionCount, ai.actionCountMax, tostring(action.actionFormat), tostring(ai.action[1] and ai.action[1].actionParm1), tostring(isLimitSkil), Serialize(ai))

                            --添加行动记录
                            if action.actionType == AiActionConfig.SKILL or action.actionType == AiActionConfig.MOVE_ACTION_SKILL then
                                self:addActionList(AiActionConfig.SKILL,action[1].actionParm1)
                            end
                            ai.isAction = true
                            ai.actionCount = ai.actionCount + 1
                            self:doAction(action.actionType, action, conditionList,nil, id)
                            defualDone = false
                            --触发默认ai
                            if action.actionFormat then
                                self:setAiActionDone()
                                break
                            end
                        end
                        if action.actionType == AiActionConfig.MOVE_ACTION_SKILL then
                            self.m_bMoveActionIn = true
                            return
                        end
                    end
                end
            end
        end
        --第一次ai遍历 无任何匹配选项 执行默认行动
        if defualDone and not self.m_bCurRoundAiIsCheck then
            self.m_tBoss:sendAiProcol(0)
            if self.m_tBoss.m_nBulletId ~= -1 then
                WZLog("WNewMonsterAI:defual AI")
                self:doAction(AiActionConfig.SKILL,{[1] = {actionParm1 = 20000}})
            end
            self:setAiActionDone()
        end
        --第一次遍历ai结束
        self.m_bCurRoundAiIsCheck = true
    end
end

--@breif ai触发 互斥ai行为设置true
function WNewMonsterAI:setAiActionDone()
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

function WNewMonsterAI:pushMonsterMsg(msg,isBlock,msgIndex)
    WZLog("WNewMonsterAI:pushMonsterMsg",tostring(self.m_tBoss:isFollowAct()))
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

--@brief 检查行动队列是否结束
function WNewMonsterAI:checkActionIsEnd()
    if #self.m_tActionList == 0 and self.m_bCurRoundAiIsCheck then
        return true
    end
    if self.m_tBoss and self.m_tBoss:isDead() then 
        return true
    end
    return false
end

--@brief 检查行动队列(ai控制权转移)
function WNewMonsterAI:aiCtrlChange()
    WZLog("WNewMonsterAI:aiCtrlChange",tostring(WBattleGlobal:getCurrent():getCurrentCharacterId() == self.m_tBoss:getBattleId()))
    WZLog("WNewMonsterAI:aiCtrlChange-one",WBattleGlobal:getCurrent().m_nReceivePassRound,WBattleGlobal:getCurrent().m_nTurnTimes)
    --属于怪物当前回合
    if WBattleGlobal:getCurrent():getCurrentCharacterId() == self.m_tBoss:getBattleId() then
        --补发技能协议
        for i,v in pairs(self.m_tActionList) do
            local skillId = tonumber(SplitStringWithSeparator(v, "_")[2])
            local list = MsgManager.m_tBlockMsgList
            local isNotSyncSkil = true

            for _,k in pairs(self.m_tSyncActionList) do
                if k == v then
                    isNotSyncSkil = false
                end
            end
            if not isNotSyncSkil then
                WZLog("WNewMonsterAI:aiCtrlChange-syncSkill")
                self:doAction(AiActionConfig.SKILL,{[1] = {actionParm1 = skillId}})
            end
        end
        --当前回合没有收到主机发送的pass ai启动继续行动
        if WBattleGlobal:getCurrent().m_nReceivePassRound ~= WBattleGlobal:getCurrent().m_nTurnTimes then
            self.m_nCurStatus = -1
        end
    end
end

--@brief 添加行动队列
--@param type 类型（技能） id（技能id）
function WNewMonsterAI:addActionList(type,id)
    local flag = tostring(type).."_"..tostring(id)
    WZLog("WNewMonsterAI:addActionList",flag)
    --ai控制权转移 检查出主机没发技能协议 执行一次doaction会多添加一次队列需要过滤，
    --导致ai统一回合不支持多次同样技能（如有必要，请修改技能id，否则导致控制权 补发协议的判断失效）
    for i,v in pairs(self.m_tActionList) do
        if v == flag then
            return
        end
    end
    table.insert(self.m_tActionList,flag)
end

--@brief 移除行动队列(表演结束)
--@param type 类型（技能） id（技能id）
function WNewMonsterAI:removeActionList(type,id)
    if WBattleGlobal:getCurrent():isReplayGame() or self.m_tActionList == nil then
        return
    end

    local flag = tostring(type).."_"..tostring(id)
    WZLog("WNewMonsterAI:removeActionList",flag)
    for i = #self.m_tActionList ,1,-1 do
        
        if self.m_tActionList[i] == flag then
            table.remove(self.m_tActionList,i)
        end
    end
    if #self.m_tEndSkillAction > 0 then
        local skillId = self.m_tEndSkillAction[1]
        self:doSkillAction(skillId)
        self:sendSkill(skillId)
        table.remove(self.m_tEndSkillAction,1)
    end
    if self.m_bMoveActionIn then
        self.m_bMoveActionIn = false
    end
end

--@brief 添加本回合同步行动队列
--@param type 类型（技能） id（技能id）
function WNewMonsterAI:addSyncActionList(type,id)
    local flag = tostring(type).."_"..tostring(id)
    --ai控制权转移 检查出主机没发技能协议 执行一次doaction会多添加一次队列需要过滤，
    --导致ai统一回合不支持多次同样技能（如有必要，请修改技能id，否则导致控制权 补发协议的判断失效）
    if not self.m_tSyncActionList then
        self.m_tSyncActionList = {}
    end
    for i,v in pairs(self.m_tSyncActionList) do
        if v == flag then
            return
        end
    end
    table.insert(self.m_tSyncActionList,flag)
end


--同步ai状态
function WNewMonsterAI:syncAiState(aiCtrlId)
    WZLog("WNewMonsterAI:syncAiState",aiCtrlId)
    --如果报错消失 说明 回合开始前收到同步ai的协议
     if not self.m_tActionList then
        self.m_tActionList = {}
    end
    --第一次遍历ai结束
    self.m_bCurRoundAiIsCheck = true
    if aiCtrlId == 0 then
        self:addActionList(AiActionConfig.SKILL,20000)
        self:setAiActionDone()
        return
    end

    for id, ai in ipairs (self.m_tBoss:getAiScript()) do
        if id == aiCtrlId then
            local action = ai.action
            ai.isAction = true
            ai.actionCount = ai.actionCount + 1
            -- self:doAction(action.actionType, action, conditionList,nil, id)
            if action.actionType == AiActionConfig.SKILL then
                WZLog("WNewMonsterAI:syncAiState",action[1].actionParm1)
                self:addActionList(AiActionConfig.SKILL,action[1].actionParm1)
            end
            if action.actionFormat then
                self:setAiActionDone()
                break
            end
        end
    end
end



    
    
    
    
    
    
    
    
-------------------------------------私有方法模块--------------------------------------

