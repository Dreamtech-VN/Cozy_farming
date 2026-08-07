--BattleMsgAssistedTeamBossCOrder.lua
--@brief    组队副本3命令行动
--@date     2015/9/15
--@author   mbq
--@note

--@brief    消息数据表
BattleMsgAssistedTeamBossCOrder = {
    m_sName = "BattleMsgAssistedTeamBossCOrder",
    m_tSkillShowMsg = nil,      --调用者（BattleMsgShow）
    m_tFollowList = nil,    --跟随怪物行动
    m_nHitDistance = nil,   --攻击碰撞
    m_tTargetPos = nil,
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgAssistedTeamBossCOrder:init()
    WZLog("BattleMsgAssistedTeamBossCOrder:init")
    self.m_nBoomDistance = 100
    self.m_tTargetPos = BattleCommon:getPointTable(1565,0)
    local owner = self:getOwner()
    --重置小怪状态
    owner:followStartRound()
    self.m_tFollowList = owner:getFollowMonsterList()
    for i,monster in pairs(self.m_tFollowList) do
        monster:setPF(100)
        monster:getAI():doAction(AiActionConfig.MOVE_NEW,{[1] = {actionParm1 = 400,actionParm2 = 0,actionParm3 = self.m_tTargetPos.x,actionParm4 = self.m_tTargetPos.y}},nil,nil,nil,nil,nil,true)
    end
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgAssistedTeamBossCOrder:process(dt)
    if WBattleGlobal:getCurrent():isGameOver() then
        return true
    end
    local msgCount = 0
    for i = #self.m_tFollowList,1,-1 do
        local monster = self.m_tFollowList[i]
        local pos = monster:getPosition()
        local list = WBattleGlobal:getCurrent():getHeroSortList()
        if pos.x >= self.m_tTargetPos.x - 5 then
            self:bossUseSkill(monster,i)
        else
            for k,hero in ipairs(list) do
                if not hero:isDead() then
                    local tmpPos = hero:getPosition()
                    if BattleCommon:pointDis(tmpPos,pos) < self.m_nBoomDistance then
                        self:monsterUseSkill(monster,i)
                    end    
                end 
            end
        end
    end

    local list = self:getOwner():getFollowMonsterList()
    for i,v in pairs(list) do
        if v.m_tOwnerMsgMgr and #v.m_tOwnerMsgMgr.m_tBlockMsgList > 0 then
            msgCount = msgCount + 1
        end
    end
    
    WZLog("BattleMsgAssistedTeamBossCOrder:process II",msgCount)
    
    if msgCount > 0 then
        return false
    else
        return true
    end
end

--@小怪 使用技能
function BattleMsgAssistedTeamBossCOrder:monsterUseSkill(monster,i)
    WZLog("BattleMsgAssistedTeamBossCOrder:monsterUseSkill")
    table.remove(self.m_tFollowList,i)
    monster.m_bIsCanMove = nil
    --怪物技能附加参数 第一位自爆技能id
    monster:getAI():doAction(AiActionConfig.SKILL,{[1] = {actionParm1 = monster.m_tSkillParam[1][1]}},nil,nil,nil,nil,nil,true)
end

--@boss 使用技能
function BattleMsgAssistedTeamBossCOrder:bossUseSkill(monster,i)
    WZLog("BattleMsgAssistedTeamBossCOrder:bossUseSkill")
    table.remove(self.m_tFollowList,i)
    local effect  = BattleEffect:createAnimation(1007)
    monster:getAnimation():getAnimNode():addChild(effect:getAnimNode())
    monster:setSacrifice(true)
    monster.m_bIsCanMove = nil
    --怪物触发boss ai
    local boss = monster.m_tBoss
    if boss then
        --怪物技能附加参数 第二位牺牲技能id
        boss:getAI():doAction(AiActionConfig.FOLLOW_ACTION_SKILL,{[1] = {actionParm1 = monster.m_tSkillParam[1][2]}}, nil, nil,nil, nil,2,true)
    end
end

--@brief 镜头控制
function BattleMsgAssistedTeamBossCOrder:isCanCtrlCamera()
    return self.m_tSkillShowMsg:isCanCtrlCamera()
end

--@brief 获得技能所有者
function BattleMsgAssistedTeamBossCOrder:getOwner()
    return self.m_tSkillShowMsg.m_tOwner
end

--@brief 获得owner坐标
function BattleMsgAssistedTeamBossCOrder:getOwnerPos()
    return self.m_tSkillShowMsg.m_tOwner:getPosition()
end

--@brief 获得目标列表
function BattleMsgAssistedTeamBossCOrder:getMsgTargetList()
    return self.m_tSkillShowMsg.m_tTargetList
end

function BattleMsgAssistedTeamBossCOrder:msgDoAction(config)
    self.m_tSkillShowMsg:doAction(config)
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgAssistedTeamBossCOrder:done()
    WZLog("BattleMsgAssistedTeamBossCOrder:done")
    self.m_tSkillShowMsg:reduceWait(BattleSkillType.CREATE_ASSISTED_MSG)
end

-------------------------------------私有方法模块--------------------------------------
