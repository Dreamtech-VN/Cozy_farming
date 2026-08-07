--BattleMsgAssistedDailyCopyOrder.lua
--@brief    日常副本 经验本集体行动
--@date     2015/11/14
--@author   mbq
--@note

--@brief    消息数据表
BattleMsgAssistedDailyCopyOrder = {
    m_sName = "BattleMsgAssistedDailyCopyOrder",
    m_tSkillShowMsg = nil,      --调用者（BattleMsgShow）
    m_tFollowList = nil,    --跟随怪物行动
    m_tTargetPos = nil,
    m_tHero = nil,
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgAssistedDailyCopyOrder:init()
    WZLog("BattleMsgAssistedDailyCopyOrder:init")
    self.m_tTargetPos = BattleCommon:getPointTable(180,0)
    self.m_tHero = WBattleGlobal:getCurrent():getMyHero()
    local owner = self:getOwner()
    --重置小怪状态
    owner:followStartRound()
    self.m_tFollowList = owner:getFollowMonsterList()
    for i = #self.m_tFollowList ,1,-1 do
        local monster = self.m_tFollowList[i]
        if self:canHitHero(monster) then
            self:doHitHero(monster,i)
        else
            monster:setPF(100)
            monster:getAI():doAction(AiActionConfig.MOVE_NEW,{[1] = {actionParm1 = -300,actionParm2 = 0,actionParm3 = self.m_tTargetPos.x,actionParm4 = self.m_tTargetPos.y}},nil,nil,nil,nil,nil,true)
        end
    end
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgAssistedDailyCopyOrder:process(dt)
    if WBattleGlobal:getCurrent():isGameOver() then
        return true
    end
    local msgCount = 0
    for i = #self.m_tFollowList,1,-1 do
        local monster = self.m_tFollowList[i]
        local pos = monster:getPosition()
        if pos.x <= self.m_tTargetPos.x + 5 then
            self:setMonsterDead(monster,i)
        else
            if self:canHitHero(monster) then
                self:doHitHero(monster,i)
            end
        end
    end

    local list = self:getOwner():getFollowMonsterList()
    for i,v in pairs(list) do
        if v.m_tOwnerMsgMgr and #v.m_tOwnerMsgMgr.m_tBlockMsgList > 0 then
            msgCount = msgCount + 1
        end
    end
    
    WZLog("BattleMsgAssistedDailyCopyOrder:process II",msgCount)
    
    if msgCount > 0 then
        return false
    else
        return true
    end
end

--@小怪 能否攻击玩家
function BattleMsgAssistedDailyCopyOrder:canHitHero(monster)
    local guaiPos = monster:getMover():getMoverPosition()
    guaiPos = {x=guaiPos:getX(),y=guaiPos:getY()}
    
    local charaPos = self.m_tHero:getCenterPos()
    charaPos = Vector2:create(charaPos.x,charaPos.y)
    if BattleCommon:checkCircleCollosion(guaiPos,monster.m_nAttackArea,charaPos,self.m_tHero:getRadiusForHurt()) then
        return true
    end
    return false
end

--@boss 攻击玩家
function BattleMsgAssistedDailyCopyOrder:doHitHero(monster,i)
    table.remove(self.m_tFollowList,i)
    monster.m_bIsCanMove = nil
    monster:getAI():doAction(AiActionConfig.SKILL,{[1] = {actionParm1 = 19999}},nil,nil,nil,nil,nil,true)
end

function BattleMsgAssistedDailyCopyOrder:setMonsterDead(monster,i)
    table.remove(self.m_tFollowList,i)
    monster:getAI():doAction(AiActionConfig.SUICIDE,nil,nil,nil,nil,nil,nil,true)
end

--@brief 镜头控制
function BattleMsgAssistedDailyCopyOrder:isCanCtrlCamera()
    return self.m_tSkillShowMsg:isCanCtrlCamera()
end

--@brief 获得技能所有者
function BattleMsgAssistedDailyCopyOrder:getOwner()
    return self.m_tSkillShowMsg.m_tOwner
end

--@brief 获得owner坐标
function BattleMsgAssistedDailyCopyOrder:getOwnerPos()
    return self.m_tSkillShowMsg.m_tOwner:getPosition()
end

--@brief 获得目标列表
function BattleMsgAssistedDailyCopyOrder:getMsgTargetList()
    return self.m_tSkillShowMsg.m_tTargetList
end

function BattleMsgAssistedDailyCopyOrder:msgDoAction(config)
    self.m_tSkillShowMsg:doAction(config)
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgAssistedDailyCopyOrder:done()
    WZLog("BattleMsgAssistedDailyCopyOrder:done")
    self.m_tSkillShowMsg:reduceWait(BattleSkillType.CREATE_ASSISTED_MSG)
end

-------------------------------------私有方法模块--------------------------------------
