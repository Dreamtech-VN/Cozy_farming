--BattleMsgAssistedNearAttackOrder.lua
--@brief    集体行动
--@date     2015/11/14
--@author   mbq
--@note

--@brief    消息数据表
BattleMsgAssistedNearAttackOrder = {
    m_sName = "BattleMsgAssistedNearAttackOrder",
    m_tSkillShowMsg = nil,      --调用者（BattleMsgShow）
    m_tFollowList = nil,    --跟随怪物行动
    m_tHero = nil,
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgAssistedNearAttackOrder:init()
    WZLog("BattleMsgAssistedNearAttackOrder:init")
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
            local targetPos = nil
            local distance = 10000
            local  heroList =  WBattleGlobal:getCurrent():getHeroSortList()
            local pos = monster:getPosition()

            for i,v in ipairs(heroList) do
                if not v:isDead() and distance > BattleCommon:pointDis(pos,v:getPosition()) then
                    local tmpDis = BattleCommon:pointDis(pos,v:getPosition())
                    local bIsNear = false
                    if distance then
                        if distance > tmpDis then
                            bIsNear = true
                        end
                    else
                        bIsNear = true
                    end

                    if bIsNear then
                        distance = tmpDis
                        targetPos = v:getPosition()
                    end
                end
            end
            if targetPos then
                local moveDis = 300
                if targetPos.x < pos.x then
                    moveDis = moveDis * -1
                end
                monster:getAI():doAction(AiActionConfig.MOVE_NEW,{[1] = {actionParm1 = moveDis,actionParm2 = 0,actionParm3 = targetPos.x,actionParm4 = targetPos.y}},nil,nil,nil,nil,nil,true)
            end
        end
    end
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgAssistedNearAttackOrder:process(dt)
    if WBattleGlobal:getCurrent():isGameOver() then
        return true
    end
    local msgCount = 0
    for i = #self.m_tFollowList,1,-1 do
        local monster = self.m_tFollowList[i]
        local pos = monster:getPosition()
       
        if self:canHitHero(monster) then
            self:doHitHero(monster,i)
        end
    end

    local list = self:getOwner():getFollowMonsterList()
    for i,v in pairs(list) do
        if v.m_tOwnerMsgMgr and #v.m_tOwnerMsgMgr.m_tBlockMsgList > 0 then
            msgCount = msgCount + 1
        end
    end
    
    WZLog("BattleMsgAssistedNearAttackOrder:process II",msgCount)
    
    if msgCount > 0 then
        return false
    else
        return true
    end
end

--@小怪 能否攻击玩家
function BattleMsgAssistedNearAttackOrder:canHitHero(monster)
    local guaiPos = monster:getMover():getMoverPosition()
    guaiPos = {x=guaiPos:getX(),y=guaiPos:getY()}
    
    for i,chara in ipairs(WBattleGlobal:getCurrent():getHeroSortList()) do
        local charaPos = chara:getCenterPos()
        charaPos = Vector2:create(charaPos.x,charaPos.y)
        if BattleCommon:checkCircleCollosion(guaiPos,monster.m_nAttackArea,charaPos,chara:getRadiusForHurt()) then
            return true
        end
    end
    return false
end

--@boss 攻击玩家
function BattleMsgAssistedNearAttackOrder:doHitHero(monster,i)
    table.remove(self.m_tFollowList,i)
    monster.m_bIsCanMove = nil
    monster:getAI():doAction(AiActionConfig.SKILL,{[1] = {actionParm1 = 19999}},nil,nil,nil,nil,nil,true)
end

function BattleMsgAssistedNearAttackOrder:setMonsterDead(monster,i)
    table.remove(self.m_tFollowList,i)
    monster:getAI():doAction(AiActionConfig.SUICIDE,nil,nil,nil,nil,nil,nil,true)
end

--@brief 镜头控制
function BattleMsgAssistedNearAttackOrder:isCanCtrlCamera()
    return self.m_tSkillShowMsg:isCanCtrlCamera()
end

--@brief 获得技能所有者
function BattleMsgAssistedNearAttackOrder:getOwner()
    return self.m_tSkillShowMsg.m_tOwner
end

--@brief 获得owner坐标
function BattleMsgAssistedNearAttackOrder:getOwnerPos()
    return self.m_tSkillShowMsg.m_tOwner:getPosition()
end

--@brief 获得目标列表
function BattleMsgAssistedNearAttackOrder:getMsgTargetList()
    return self.m_tSkillShowMsg.m_tTargetList
end

function BattleMsgAssistedNearAttackOrder:msgDoAction(config)
    self.m_tSkillShowMsg:doAction(config)
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgAssistedNearAttackOrder:done()
    WZLog("BattleMsgAssistedNearAttackOrder:done")
    self.m_tSkillShowMsg:reduceWait(BattleSkillType.CREATE_ASSISTED_MSG)
end

-------------------------------------私有方法模块--------------------------------------
