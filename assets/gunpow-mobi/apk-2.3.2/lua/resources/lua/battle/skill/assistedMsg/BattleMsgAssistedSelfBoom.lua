--BattleMsgAssistedSelfBoom.lua
--@brief    技能表现辅助消息模板表
--@date     2015/9/15
--@author   mbq
--@note

--@brief    消息数据表
BattleMsgAssistedSelfBoom = {
    m_sName = "BattleMsgAssistedSelfBoom",
    m_tSkillShowMsg = nil,      --调用者（BattleMsgShow）
    --自爆参数
    m_nBoomDistance = nil,  --自爆范围参数
    m_nBoomFlashId = nil,  --自爆特效
    m_nDelay = nil,
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgAssistedSelfBoom:init()
    WZLog("BattleMsgAssistedSelfBoom:init")
    if not self.m_nBoomDistance then
        self.m_nBoomDistance = 100
    end
    if not self.m_nBoomFlashId or self.m_nBoomFlashId <= 0 then
        self.m_nBoomFlashId = 1009
    end

    local monster = self:getOwner()
    self:createBoomEffect(monster)
    monster:setBoom(true)
    -- monster:setAutoStandAction(false)
    -- monster:play(monster:getAnimationName("boom"),false)
    if self.m_bHurt then
        WZLog("BattleMsgAssistedSelfBoom",self.m_bHurt)
        self:boomHurt(monster)
    end
    self.m_nDelay = 0
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgAssistedSelfBoom:process(dt)
    WZLog("BattleMsgAssistedSelfBoom",self.m_bHurt)
    self.m_nDelay = self.m_nDelay + 1
    if self.m_nDelay < 30 then
        return false
    end
    return true
end

--@brief 创建爆破效果
function BattleMsgAssistedSelfBoom:createBoomEffect(monster)
    local effect  = BattleEffect:createAnimation(self.m_nBoomFlashId)
    effect:setPosition(monster:getPosition())
    SceneBattle:getFrontLayer():addChild(effect:getAnimNode(),10)
    -- monster:getAnimation():getAnimNode():addChild(effect:getAnimNode())
end

--@brief 爆炸伤害
function BattleMsgAssistedSelfBoom:boomHurt(monster)
    local tHurtCharas, tHurtValues, tDistance, tCritType, tHurtRatios = BattleMethod:checkMeleeHurt(monster,self.m_nBoomDistance)

    if BattleCommon:tableLen(tHurtCharas) > 0 then
        BattleMethod:charaAddHurtValue(monster,tHurtCharas,tHurtValues,tHurtRatios)
        BattleMethod:sendHurtProtocol(monster,tHurtCharas, tHurtValues, tDistance, tCritType, true)
        BattleMethod:addToHurtList(monster,tHurtCharas)
    end
end

--@brief 镜头控制
function BattleMsgAssistedSelfBoom:isCanCtrlCamera()
    return self.m_tSkillShowMsg:isCanCtrlCamera()
end

--@brief 获得技能所有者
function BattleMsgAssistedSelfBoom:getOwner()
    return self.m_tSkillShowMsg.m_tOwner
end

--@brief 获得owner坐标
function BattleMsgAssistedSelfBoom:getOwnerPos()
    return self.m_tSkillShowMsg.m_tOwner:getPosition()
end

--@brief 获得目标列表
function BattleMsgAssistedSelfBoom:getMsgTargetList()
    return self.m_tSkillShowMsg.m_tTargetList
end

function BattleMsgAssistedSelfBoom:msgDoAction(config)
    self.m_tSkillShowMsg:doAction(config)
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgAssistedSelfBoom:done()
   WZLog("BattleMsgAssistedSelfBoom:done")
   self.m_tSkillShowMsg:reduceWait(BattleSkillType.CREATE_ASSISTED_MSG)
end

-------------------------------------私有方法模块--------------------------------------
