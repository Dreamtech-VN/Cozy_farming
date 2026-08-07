-- BattleMsgAssistedBoss10_3.lua
--@brief    召唤
--@date     2016/11/23
--@note

--@brief    消息数据表
BattleMsgAssistedBoss10_3 = {
    m_sName = "BattleMsgAssistedBoss10_3",
    m_tSkillShowMsg = nil,      --调用者（BattleMsgShow）
    m_tTargetList = nil,
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgAssistedBoss10_3:init()
    WZLog("BattleMsgAssistedBoss10_3:init")
    
    local bornPosList = {GlobalMethod:ccp(104,473),GlobalMethod:ccp(1683,510)}
    local index = WBattleGlobal:getCurrent():getCurRandNum() % #bornPosList + 1
    self.m_tTargetPos = bornPosList[index]

    self.m_tStepState  = 1
    
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgAssistedBoss10_3:process(dt)
    if self.m_tStepState == 1 then
        self:cameraMove()
        return false
    elseif self.m_tStepState == 2 then
        self:build()
        return false
    end
    return true
end

function BattleMsgAssistedBoss10_3:cameraMove()
    local result = BattleScreen:followHero(BattleCommon:getPointTable(self.m_tTargetPos.x,self.m_tTargetPos.y))
    if result then
        self.m_tStepState = 2
    end
end

function BattleMsgAssistedBoss10_3:build()
    local list = {}
    for i,v in pairs(self:getOwner().m_tCursummonList) do
        table.insert(list,v)
    end
    local sortFunc = function(a, b) return b:getBattleId() < a:getBattleId() end
    table.sort(list,sortFunc)
    for i,monster in ipairs(list) do
        monster:setPosition(self.m_tTargetPos)

        WBattleGlobal:getCurrent().m_tGuais[monster:getBattleId()] = monster
        SceneBattle:getFrontLayer():addChild(monster:getAnimation():getAnimNode())
        if monster:getMover() then
            WBattleGlobal:getCurrent().m_battleManager:addEntity(monster:getMover())
        end

        monster:setAppearAttribute()
        monster:play(monster:getAnimationName("standby"), true)
        if self:getOwnerPos().x > monster:getPosition().x then
            if monster.m_bIsFilpX ~= true then
                monster:getAnimation():setFlipX(true)
                monster.m_bIsFilpX = true
            end
        end

        local effect  = BattleEffect:createAnimation(1019)
        monster:getAnimation():getAnimNode():addChild(effect:getAnimNode())
    end

    self.m_tStepState = 3
end

--@brief 镜头控制
function BattleMsgAssistedBoss10_3:isCanCtrlCamera()
    return self.m_tSkillShowMsg:isCanCtrlCamera()
end

--@brief 获得技能所有者
function BattleMsgAssistedBoss10_3:getOwner()
    return self.m_tSkillShowMsg.m_tOwner
end

--@brief 获得owner坐标
function BattleMsgAssistedBoss10_3:getOwnerPos()
    return self.m_tSkillShowMsg.m_tOwner:getPosition()
end

--@brief 获得目标列表
function BattleMsgAssistedBoss10_3:getMsgTargetList()
    return self.m_tSkillShowMsg.m_tTargetList
end

--@brief 添加表演
function BattleMsgAssistedBoss10_3:msgDoAction(config)
    self.m_tSkillShowMsg:doAction(config,config.isWait)
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgAssistedBoss10_3:done()
    WZLog("BattleMsgAssistedBoss10_3:done")
    self.m_tSkillShowMsg:reduceWait(BattleSkillType.CREATE_ASSISTED_MSG)
end

-------------------------------------私有方法模块--------------------------------------
