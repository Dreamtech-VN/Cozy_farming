--BattleMsgAssistedBoss10_2.lua
--@brief    组队副本10命令行动
--@date     2017/11/03
--@author   mbq
--@note

--@brief    消息数据表
BattleMsgAssistedBoss10_2 = {
    m_sName = "BattleMsgAssistedBoss10_2",
    m_tSkillShowMsg = nil,      --调用者（BattleMsgShow）
    m_tFollowList = nil,    --跟随怪物行动
    m_nHitDistance = nil,   --攻击碰撞
    m_tTargetPos = nil,
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgAssistedBoss10_2:init()
    WZLog("BattleMsgAssistedBoss10_2:init")

    self.m_nBoomDistance = 100
    self.m_tTargetPos = self:getOwnerPos()
    local owner = self:getOwner()
    --重置小怪状态
    owner:followStartRound()
    self.m_tFollowList = owner:getFollowMonsterList()
    for i,monster in pairs(self.m_tFollowList) do
        if not monster:isDead() and not monster:isSacrifice() and not monster:isBoom() then
            local collsioin = self:checkHeroCollision(monster)
            if not collsioin then
                collsioin = self:checkTargetCollision(monster)
            end
            if not collsioin then
                monster:setPF(100)
                local moveDistance = 400
                if monster:getPosition().x < self.m_tTargetPos.x then
                    moveDistance = 400
                else
                    moveDistance = -400
                end
                monster:getAI():doAction(AiActionConfig.MOVE_NEW,{[1] = {actionParm1 = moveDistance,actionParm2 = 0,actionParm3 = self.m_tTargetPos.x,actionParm4 = self.m_tTargetPos.y}},nil,nil,nil,nil,nil,true)
            end
        end
    end
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgAssistedBoss10_2:process(dt)
    if WBattleGlobal:getCurrent():isGameOver() then
        return true
    end
    local msgCount = 0
    for i = #self.m_tFollowList,1,-1 do
        local monster = self.m_tFollowList[i]
        local pos = monster:getPosition()
        
        if self:checkTargetCollision(monster) then
            self:bossUseSkill(monster,i)
        elseif self:checkHeroCollision(monster) then
            self:monsterUseSkill(monster,i)
        end
    end

    local list = self:getOwner():getFollowMonsterList()
    for i,v in pairs(list) do
        if v.m_tOwnerMsgMgr and #v.m_tOwnerMsgMgr.m_tBlockMsgList > 0 then
            msgCount = msgCount + 1
        end
    end
    
    WZLog("BattleMsgAssistedBoss10_2:process II",msgCount)
    
    if msgCount > 0 then
        return false
    else
        return true
    end
end

function BattleMsgAssistedBoss10_2:checkHeroCollision(monster)
    local pos = monster:getPosition()
    local list = WBattleGlobal:getCurrent():getHeroSortList()
    for k,hero in ipairs(list) do
        if not hero:isDead() then
            local tmpPos = hero:getPosition()
            if BattleCommon:pointDis(tmpPos,pos) < self.m_nBoomDistance then
                return true
            end    
        end
    end
    return false
end

function BattleMsgAssistedBoss10_2:checkTargetCollision(monster)
    local pos = monster:getPosition()
    if BattleCommon:pointDis(self.m_tTargetPos,pos) < self.m_nBoomDistance then
        return true
    end    
    return false
end

--@小怪 使用技能
function BattleMsgAssistedBoss10_2:monsterUseSkill(monster,i)
    WZLog("BattleMsgAssistedBoss10_2:monsterUseSkill")
    table.remove(self.m_tFollowList,i)
    monster.m_bIsCanMove = nil
    --怪物技能附加参数 第一位自爆技能id
    monster:getAI():doAction(AiActionConfig.SKILL,{[1] = {actionParm1 = monster.m_tSkillParam[1][1]}},nil,nil,nil,nil,nil,true)
end

--@boss 使用技能
function BattleMsgAssistedBoss10_2:bossUseSkill(monster,i)
    WZLog("BattleMsgAssistedBoss10_2:bossUseSkill")
    table.remove(self.m_tFollowList,i)
    local effect  = BattleEffect:createAnimation(1007)
    monster:getAnimation():getAnimNode():addChild(effect:getAnimNode())
    monster:setSacrifice(true)
    monster.m_bIsCanMove = nil
    --怪物触发boss ai
    local boss = monster.m_tBoss
    if boss then
        --怪物技能附加参数 第二位牺牲技能id
        boss:getAI():doAction(AiActionConfig.FOLLOW_ACTION_SKILL,{[1] = {actionParm1 = monster.m_tSkillParam[1][2]}}, nil, nil,nil, true,2,true)
    end
end

--@brief 镜头控制
function BattleMsgAssistedBoss10_2:isCanCtrlCamera()
    return self.m_tSkillShowMsg:isCanCtrlCamera()
end

--@brief 获得技能所有者
function BattleMsgAssistedBoss10_2:getOwner()
    return self.m_tSkillShowMsg.m_tOwner
end

--@brief 获得owner坐标
function BattleMsgAssistedBoss10_2:getOwnerPos()
    return self.m_tSkillShowMsg.m_tOwner:getPosition()
end

--@brief 获得目标列表
function BattleMsgAssistedBoss10_2:getMsgTargetList()
    return self.m_tSkillShowMsg.m_tTargetList
end

function BattleMsgAssistedBoss10_2:msgDoAction(config)
    self.m_tSkillShowMsg:doAction(config)
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgAssistedBoss10_2:done()
    WZLog("BattleMsgAssistedBoss10_2:done")
    self.m_tSkillShowMsg:reduceWait(BattleSkillType.CREATE_ASSISTED_MSG)
end

-------------------------------------私有方法模块--------------------------------------
