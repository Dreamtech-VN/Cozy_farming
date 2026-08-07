--BattleMsgAssistedMeleeHurt.lua
--@brief    近身攻击
--@date     2015/11/14
--@author   mbq
--@note

--@brief    消息数据表
BattleMsgAssistedMeleeHurt = {
    m_sName = "BattleMsgAssistedMeleeHurt",
    m_tSkillShowMsg = nil,      --调用者（BattleMsgShow）
    
    m_nDelay = nil,
    m_bLimitHit = nil
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgAssistedMeleeHurt:init()
    WZLog("BattleMsgAssistedMeleeHurt:init")

    if self:getOwner():isInBuffState(EffectTypeConfig.LIMIT_ALL_ACTION) then
        self.m_bLimitHit = true
    else
        local monster = self:getOwner()
        monster:setAutoStandAction(false)
        monster:play(self:getAttackBeginActionName(),false)
        self.m_sStep = "attack"
        self.m_nDelay = 10

        local tHurtCharas, tHurtValues, tDistance, tCritType, tHurtRatios = BattleMethod:checkMeleeHurt(monster,monster.m_nAttackArea)
        if BattleCommon:tableLen(tHurtCharas) > 0 then
            local chara = nil
            for i,v in pairs(tHurtCharas) do
                chara = v
                break
            end

            if chara:getPosition().x > monster:getPosition().x then
                monster:getAnimation():setFlipX(true)
                monster.m_bIsFilpX = true
            else
                monster:getAnimation():setFlipX(false)
                monster.m_bIsFilpX = false
            end
        end
    end
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgAssistedMeleeHurt:process(dt)
    if self.m_bLimitHit then
        return true
    end

    if self.m_sStep == "attack" then
        local monster = self:getOwner()
        if monster:getAnimation():isPlaying(monster:getAnimationName("standby")) or monster:getAnimation():isCurrentAnimationDone() == true then
            self.m_sStep = "hurt"
            monster:setAutoStandAction(true)
            monster:play(self:getAttackEndActionName(),false)
            self:boomHurt(monster)
        end
        return false
    elseif self.m_sStep == "hurt" then
        self.m_nDelay = self.m_nDelay - 1
        if self.m_nDelay < 0 then
            return true
        end
        return false
    end
    return true
end


--@brief 爆炸伤害
function BattleMsgAssistedMeleeHurt:boomHurt(monster)
    local tHurtCharas, tHurtValues, tDistance, tCritType, tHurtRatios = BattleMethod:checkMeleeHurt(monster,monster.m_nAttackArea)
    if BattleCommon:tableLen(tHurtCharas) > 0 then
        BattleMethod:charaAddHurtValue(monster,tHurtCharas,tHurtValues,tHurtRatios)
        BattleMethod:sendHurtProtocol(monster,tHurtCharas, tHurtValues, tDistance, tCritType)
        BattleMethod:addToHurtList(monster,tHurtCharas)
    end
    
end

--@brief 攻击动作1
function BattleMsgAssistedMeleeHurt:getAttackBeginActionName()
    local monster = self:getOwner()
    if monster:getAnimationName("atk_1") then
        return monster:getAnimationName("atk_1")
    end
    return monster:getAnimationName("shoot_1") and monster:getAnimationName("shoot_1") or monster:getAnimationName("standby")
end

--@brief 攻击动作2
function BattleMsgAssistedMeleeHurt:getAttackEndActionName()
    local monster = self:getOwner()
    if monster:getAnimationName("atk_2") then
        return monster:getAnimationName("atk_2")
    end
    return monster:getAnimationName("shoot_3") and monster:getAnimationName("shoot_3") or monster:getAnimationName("standby")
end

--@brief 镜头控制
function BattleMsgAssistedMeleeHurt:isCanCtrlCamera()
    return self.m_tSkillShowMsg:isCanCtrlCamera()
end

--@brief 获得技能所有者
function BattleMsgAssistedMeleeHurt:getOwner()
    return self.m_tSkillShowMsg.m_tOwner
end

--@brief 获得owner坐标
function BattleMsgAssistedMeleeHurt:getOwnerPos()
    return self.m_tSkillShowMsg.m_tOwner:getPosition()
end

--@brief 获得目标列表
function BattleMsgAssistedMeleeHurt:getMsgTargetList()
    return self.m_tSkillShowMsg.m_tTargetList
end

function BattleMsgAssistedMeleeHurt:msgDoAction(config)
    self.m_tSkillShowMsg:doAction(config)
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgAssistedMeleeHurt:done()
   WZLog("BattleMsgAssistedMeleeHurt:done")
   self.m_tSkillShowMsg:reduceWait(BattleSkillType.CREATE_ASSISTED_MSG)
end

-------------------------------------私有方法模块--------------------------------------
