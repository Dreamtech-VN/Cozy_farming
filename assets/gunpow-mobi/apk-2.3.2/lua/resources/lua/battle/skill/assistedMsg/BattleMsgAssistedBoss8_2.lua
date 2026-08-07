-- BattleMsgAssistedBoss8_2.lua
--@brief    岩浆爆破
--@date     2016/7/6
--@note

--@brief    消息数据表
BattleMsgAssistedBoss8_2 = {
    m_sName = "BattleMsgAssistedBoss8_2",
    m_tSkillShowMsg = nil,      --调用者（BattleMsgShow）
    m_tTargetList = nil,
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgAssistedBoss8_2:init()
    WZLog("BattleMsgAssistedBoss8_2:init")

    self.m_tPosList = {BattleCommon:getPointTable(1500,400),BattleCommon:getPointTable(1200,400),
    BattleCommon:getPointTable(900,400),BattleCommon:getPointTable(600,400),
    -- BattleCommon:getPointTable(600,400),BattleCommon:getPointTable(400,400),
    BattleCommon:getPointTable(300,400),BattleCommon:getPointTable(0,400)}

    self.m_nEffectCount = #self.m_tPosList
    self.m_nHurtDis = 150

    self.m_tTime = 0
    self.m_tDelay = 1
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgAssistedBoss8_2:process(dt)
    self.m_tTime = self.m_tTime + dt
    if self.m_tTime > 0.3 then
        self.m_tTime = self.m_tTime  - 0.3
        self:createEffect()
    end
    if self.m_nEffectCount > 0 then
        return false
    end

    self.m_tDelay = self.m_tDelay - dt
    
    if self.m_tDelay > 0 then
        return false
    end

    return true
end

function BattleMsgAssistedBoss8_2:createEffect()
    local index = #self.m_tPosList - self.m_nEffectCount + 1
    if index <= 0 or index > #self.m_tPosList then
        return
    end
    local pos = self.m_tPosList[index]
    local effect = BattleEffect:createAnimation(1016)
    WZLog("BattleMsgAssistedBoss8_2:createEffect",index)
    effect:setPosition(pos)
    effect:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0))
    SceneBattle:getFrontLayer():addChild(effect:getAnimNode(),10)
    SoundManager:playEffectSound(SoundDefine.E_S_EXPLODE)

    self:makeHurt(pos)

    self.m_nEffectCount = self.m_nEffectCount - 1
end

function BattleMsgAssistedBoss8_2:makeHurt(pos)
    local targetList = {}
    local list = WBattleGlobal:getCurrent():getHeroList()
    for i,target in pairs(list) do
        if not target:isDead() and math.abs(pos.x - target:getPosition().x) <= self.m_nHurtDis then
            table.insert(targetList,target)
        end
    end
    BattleMethod:waitForSkillHurt(self:getOwner(),targetList)
end

--@brief 镜头控制
function BattleMsgAssistedBoss8_2:isCanCtrlCamera()
    return self.m_tSkillShowMsg:isCanCtrlCamera()
end

--@brief 获得技能所有者
function BattleMsgAssistedBoss8_2:getOwner()
    return self.m_tSkillShowMsg.m_tOwner
end

--@brief 获得owner坐标
function BattleMsgAssistedBoss8_2:getOwnerPos()
    return self.m_tSkillShowMsg.m_tOwner:getPosition()
end

--@brief 获得目标列表
function BattleMsgAssistedBoss8_2:getMsgTargetList()
    return self.m_tSkillShowMsg.m_tTargetList
end

--@brief 添加表演
function BattleMsgAssistedBoss8_2:msgDoAction(config)
    self.m_tSkillShowMsg:doAction(config,config.isWait)
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgAssistedBoss8_2:done()
    WZLog("BattleMsgAssistedBoss8_2:done")
    self.m_tSkillShowMsg:reduceWait(BattleSkillType.CREATE_ASSISTED_MSG)
end

-------------------------------------私有方法模块--------------------------------------
