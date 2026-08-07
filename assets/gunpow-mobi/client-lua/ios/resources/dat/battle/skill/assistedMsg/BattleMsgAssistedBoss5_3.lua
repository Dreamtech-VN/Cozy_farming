-- BattleMsgAssistedBoss5_3.lua
--@brief    深情演绎
--@date     2016/7/6
--@note

--@brief    消息数据表
BattleMsgAssistedBoss5_3 = {
    m_sName = "BattleMsgAssistedBoss5_3.lua",
    m_tSkillShowMsg = nil,      --调用者（BattleMsgShow）
    m_tTargetList = nil,
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgAssistedBoss5_3:init()
    WZLog("BattleMsgAssistedBoss5_3:init")

    local backFire1 = CCParticleSystemQuad:create("battle/particle/boss1005_conjure1_lizi1.plist")
    backFire1:setDuration(kCCParticleDurationInfinity)
    backFire1:retain()
    backFire1:setPositionType(kCCPositionTypeRelative)
    backFire1:setAutoRemoveOnFinish(true)
    backFire1:setPosition(1500,1000)

    self.particle1 = CCParticleBatchNode:createWithTexture(backFire1:getTexture())
    self.particle1:addChild(backFire1)
    SceneBattle:getFrontLayer():addChild(self.particle1)
    backFire1:release()

    local backFire2 = CCParticleSystemQuad:create("battle/particle/boss1005_conjure1_lizi2.plist")
    backFire2:setDuration(kCCParticleDurationInfinity)
    backFire2:retain()
    backFire2:setPositionType(kCCPositionTypeRelative)
    backFire2:setAutoRemoveOnFinish(true)
    backFire2:setPosition(1500,1000)

    self.particle2 = CCParticleBatchNode:createWithTexture(backFire2:getTexture())
    self.particle2:addChild(backFire2)
    SceneBattle:getFrontLayer():addChild(self.particle2)
    backFire2:release()

    self.m_nDelayTime = 0
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgAssistedBoss5_3:process(dt)
    self.m_nDelayTime = self.m_nDelayTime + dt
    if self.m_nDelayTime < 3 then
        return false
    end
    return true
end

--@brief 镜头控制
function BattleMsgAssistedBoss5_3:isCanCtrlCamera()
    return self.m_tSkillShowMsg:isCanCtrlCamera()
end

--@brief 获得技能所有者
function BattleMsgAssistedBoss5_3:getOwner()
    return self.m_tSkillShowMsg.m_tOwner
end

--@brief 获得owner坐标
function BattleMsgAssistedBoss5_3:getOwnerPos()
    return self.m_tSkillShowMsg.m_tOwner:getPosition()
end

--@brief 获得目标列表
function BattleMsgAssistedBoss5_3:getMsgTargetList()
    return self.m_tSkillShowMsg.m_tTargetList
end

--@brief 添加表演
function BattleMsgAssistedBoss5_3:msgDoAction(config)
    self.m_tSkillShowMsg:doAction(config,config.isWait)
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgAssistedBoss5_3:done()
    WZLog("BattleMsgAssistedBoss5_3:done")
    --删除粒子
    if self.particle1 then
        self.particle1:removeFromParentAndCleanup(true)
        self.particle1 = nil
    end
    if self.particle2 then
        self.particle2:removeFromParentAndCleanup(true)
        self.particle2 = nil
    end
    self.m_tSkillShowMsg:reduceWait(BattleSkillType.CREATE_ASSISTED_MSG)
end

-------------------------------------私有方法模块--------------------------------------
