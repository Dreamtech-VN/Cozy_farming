-- BattleMsgAssistedBoss10_4.lua
--@brief    毒雾上升
--@date     2016/10/18
--@note

--@brief    消息数据表
BattleMsgAssistedBoss10_4 = {
    m_sName = "BattleMsgAssistedBoss10_4.lua",
    m_tSkillShowMsg = nil,      --调用者（BattleMsgShow）
    m_bReset = nil,
    m_tTargetPos = nil,
    m_nTime = nil,
    m_tMachine = nil,
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgAssistedBoss10_4:init()
    WZLog("BattleMsgAssistedBoss10_4:init")
    local pos = {x = WBattleGlobal:getCurrent().m_tMonsterBornPos[2][1],y = WBattleGlobal:getCurrent().m_tMonsterBornPos[2][2] + WBattleMachineRoundStartCollisionHurt.m_nAnimaOffY}
    self.m_tMachine = nil
    for i,v in pairs(WBattleGlobal:getCurrent():getMachinesList()) do
        if v.m_nMonsterType == MonsterType.BOSS_POISON then
           self.m_tMachine = v
           break
        end
    end
    if not self.m_tMachine then
        return
    end
    local ownerPos = self.m_tMachine:getPosition()
    self.m_tTargetPos  = BattleCommon:getPointTable(pos.x,pos.y)
    WZLog("BattleMsgAssistedBoss10_4:init",ownerPos.y,pos.y)
    if ownerPos.y - pos.y < 1 then
        self.m_tTargetPos  = BattleCommon:getPointTable(pos.x,pos.y + 400)
    end
    self.m_nSpeed = (self.m_tTargetPos.y - ownerPos.y)/45
end



--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgAssistedBoss10_4:process(dt)
    if not self.m_tMachine then
        return
    end

    local ownerPos = self.m_tMachine:getPosition()
    if math.abs(self.m_tTargetPos.y - ownerPos.y) > math.abs(self.m_nSpeed) then
        self.m_tMachine:setPosition(GlobalMethod:ccp(ownerPos.x,ownerPos.y + self.m_nSpeed))
        return false
    else
        self.m_tMachine:setPosition(self.m_tTargetPos)
    end
    return true
end

function BattleMsgAssistedBoss10_4:playOwnerAnim(animName,isLoop)
    local monster = self:getOwner()
    monster:play(monster:getAnimationName(animName), isLoop)
end

--@brief 镜头控制
function BattleMsgAssistedBoss10_4:isCanCtrlCamera()
    return self.m_tSkillShowMsg:isCanCtrlCamera()
end

--@brief 获得技能所有者
function BattleMsgAssistedBoss10_4:getOwner()
    return self.m_tSkillShowMsg.m_tOwner
end

--@brief 获得owner坐标
function BattleMsgAssistedBoss10_4:getOwnerPos()
    return self.m_tSkillShowMsg.m_tOwner:getPosition()
end

--@brief 获得目标列表
function BattleMsgAssistedBoss10_4:getMsgTargetList()
    return self.m_tSkillShowMsg.m_tTargetList
end

--@brief 添加表演
function BattleMsgAssistedBoss10_4:msgDoAction(config)
    self.m_tSkillShowMsg:doAction(config,config.isWait)
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgAssistedBoss10_4:done()
    WZLog("BattleMsgAssistedBoss10_4:done")
    self.m_tSkillShowMsg:reduceWait(BattleSkillType.CREATE_ASSISTED_MSG)
end

-------------------------------------私有方法模块--------------------------------------
