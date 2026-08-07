--BattleMsgAssistedWeddedBossCOrder.lua
--@brief    夫妻命令行动
--@date     2015/9/15
--@author   mbq
--@note

--@brief    消息数据表
BattleMsgAssistedWeddedBossCOrder = {
    m_sName = "BattleMsgAssistedWeddedBossCOrder",
    m_tSkillShowMsg = nil,      --调用者（BattleMsgShow）
    m_tFollowList = nil,    --跟随怪物行动
    m_nHitDistance = nil,   --攻击碰撞
    m_tTargetPos = nil,
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgAssistedWeddedBossCOrder:init()
    WZLog("BattleMsgAssistedWeddedBossCOrder:init")
    self.m_nBoomDistance = 100
    self.m_tTargetPos = BattleCommon:getPointTable(1865,0)
    local owner = self:getOwner()
    --重置小怪状态
    owner:followStartRound()
    self.m_tFollowList = owner:getFollowMonsterList()
    for i,monster in pairs(self.m_tFollowList) do
        -- if not monster.m_nSacrificeSkillId then
        --     monster.m_nSacrificeSkillId = 20000
        -- end
        
        monster:setPF(70)
        monster:getAI():doAction(AiActionConfig.MOVE_NEW,{[1] = {actionParm1 = 400,actionParm2 = 0,actionParm3 = self.m_tTargetPos.x,actionParm4 = self.m_tTargetPos.y}},nil,nil,nil,nil,nil,true)
    end
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgAssistedWeddedBossCOrder:process(dt)
    if WBattleGlobal:getCurrent():isGameOver() then
        return true
    end
    local msgCount = 0
    for i = #self.m_tFollowList,1,-1 do
        local monster = self.m_tFollowList[i]
        local pos = monster:getPosition()
        local list = WBattleGlobal:getCurrent():getCharacterList(true)
        for k,hero in ipairs(list) do
            if not hero:isDead() and monster:getBattleId() ~= hero:getBattleId() then
                local tmpPos = hero:getPosition()
                if BattleCommon:pointDis(tmpPos,pos) < self.m_nBoomDistance then
                    self:monsterUseSkill(monster,i)
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
    
    WZLog("BattleMsgAssistedWeddedBossCOrder:process II",msgCount)
    
    if msgCount > 0 then
        return false
    else
        return true
    end
end

--@小怪 使用技能
function BattleMsgAssistedWeddedBossCOrder:monsterUseSkill(monster,i)
    WZLog("BattleMsgAssistedWeddedBossCOrder:monsterUseSkill")
    table.remove(self.m_tFollowList,i)
    monster.m_bIsCanMove = nil
    --怪物技能附加参数 第一位自爆技能id
    monster:addCollisionCharas(WBattleGlobal:getCurrent():getGuaiList())
    monster:getAI():doAction(AiActionConfig.SKILL,{[1] = {actionParm1 = monster.m_tSkillParam[1][1]}},nil,nil,nil,nil,nil,true)
end


--@brief 镜头控制
function BattleMsgAssistedWeddedBossCOrder:isCanCtrlCamera()
    return self.m_tSkillShowMsg:isCanCtrlCamera()
end

--@brief 获得技能所有者
function BattleMsgAssistedWeddedBossCOrder:getOwner()
    return self.m_tSkillShowMsg.m_tOwner
end

--@brief 获得owner坐标
function BattleMsgAssistedWeddedBossCOrder:getOwnerPos()
    return self.m_tSkillShowMsg.m_tOwner:getPosition()
end

--@brief 获得目标列表
function BattleMsgAssistedWeddedBossCOrder:getMsgTargetList()
    return self.m_tSkillShowMsg.m_tTargetList
end

function BattleMsgAssistedWeddedBossCOrder:msgDoAction(config)
    self.m_tSkillShowMsg:doAction(config)
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgAssistedWeddedBossCOrder:done()
    WZLog("BattleMsgAssistedWeddedBossCOrder:done")
    self.m_tSkillShowMsg:reduceWait(BattleSkillType.CREATE_ASSISTED_MSG)
end

-------------------------------------私有方法模块--------------------------------------
