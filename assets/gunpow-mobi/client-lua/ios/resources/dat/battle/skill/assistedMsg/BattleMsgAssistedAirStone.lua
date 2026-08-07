-- BattleMsgAssistedAirStone.lua
--@brief    天外陨石（龙爆）
--@date     2015/9/15
--@author   mbq
--@note

--@brief    消息数据表
BattleMsgAssistedAirStone = {
    m_sName = "BattleMsgAssistedAirStone",
    m_tSkillShowMsg = nil,      --调用者（BattleMsgShow）
    m_tTargetList = nil,
    m_tEffectList = nil,    
    m_tMoveStep = nil,
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgAssistedAirStone:init()
    WZLog("BattleMsgAssistedAirStone:init")
    self.m_tTargetList = {}
    self.m_tEffectList = {} 
    self.m_tMoveStep = {}
    self.m_tFireList = {}
    local list = self:getMsgTargetList()
    for i,target in pairs(list) do
        table.insert(self.m_tTargetList,target)

        local pos = target:getCenterPos()
        local tPos = BattleCommon:getPointTable(pos.x + 300,900)
        local effect = BattleEffect:createAnimation(1003)
        effect:play(0,true)
        effect:setPosition(tPos)
        self:initMoveFire(tPos)
        SceneBattle:getFrontLayer():addChild(effect:getAnimNode(),100)
        table.insert(self.m_tEffectList,effect)
        tPos = effect:getMovePosition()
        local rotation =  math.atan((tPos.y - pos.y)/(tPos.x - pos.x)) * 180 / math.pi
        effect:setRotation(-rotation)

        local stepPos = BattleCommon:getPointTable((pos.x - tPos.x)/10,(pos.y - tPos.y)/10)
        table.insert(self.m_tMoveStep,stepPos)
    end
end

--@brief 添加拖尾
function BattleMsgAssistedAirStone:initMoveFire(pos)
    local backFire = WBulletBackFire:create(nil, BulletEffectId.WORLD_BOSS1_ICE)
    SceneBattle:getFrontLayer():addChild(backFire:getElement():getParent(),100)
    backFire:getElement():setPosition(500,600)
    -- SceneBattle:getFrontLayer():addChild(backFire:getElement():getParent(),100)
    table.insert(self.m_tFireList,backFire)
    self.m_tPos = {x = 500,y=600}
end

--@brief 移除拖尾
function BattleMsgAssistedAirStone:removeMoveFire(index)
    local backFire = self.m_tFireList[index]
    if backFire then
        backFire:removeElement()
        backFire = nil
    end
    table.remove(self.m_tFireList,index)
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgAssistedAirStone:process(dt)
    local isLoop = self:updateEffect()
    return not isLoop
end

--@brief 位置刷新
function BattleMsgAssistedAirStone:updateEffect()
    local isLoop = false
    for i,stepPos in pairs(self.m_tMoveStep) do
        local target = self.m_tTargetList[i]
        local endPos = target:getCenterPos()
        
        local effect = self.m_tEffectList[i]
        local curPos = effect:getMovePosition()

        if BattleCommon:pointDis(endPos,curPos) <= BattleCommon:pointDis(stepPos,BattleCommon:getPointTable(0,0)) then
            -- effect:setPosition(endPos)
            self:stoneBoom(i,endPos)
        else
            local backFire = self.m_tFireList[i]
            local movePos = effect:getMovePosition()
            local tPos = BattleCommon:getPointTable(movePos.x + stepPos.x,movePos.y + stepPos.y)
            effect:setPosition(tPos)
            backFire:getElement():setPosition(tPos.x,tPos.y)
        end

        isLoop = true
    end
    return isLoop
end

function BattleMsgAssistedAirStone:stoneBoom(index,tPos)
    local target = self.m_tTargetList[index]
    local effect = self.m_tEffectList[index]
    if effect:getAnimNode():getParent() then
        effect:getAnimNode():removeFromParentAndCleanup(true)
    end
    self:removeMoveFire(index)
    local effectBoom  = BattleEffect:createAnimation(1004)
    effectBoom:setPosition(tPos)
    SceneBattle:getFrontLayer():addChild(effectBoom:getAnimNode(),100)

    self:hurtTarget(target)
    
    local config = {actType = BattleSkillType.SPRING, param1 = BattleSkillTargetType.OTHER,param2 = tPos}
    self:msgDoAction(config)
    
    table.remove(self.m_tMoveStep,index)
    table.remove(self.m_tTargetList,index)
    table.remove(self.m_tEffectList,index)

end

function BattleMsgAssistedAirStone:hurtTarget(target)
    local monster = self:getOwner()
    local tHurtCharas, tHurtValues, tDistance, tCritType, tHurtRatios = BattleMethod:checkMeleeHurtII(monster,target)
    if BattleCommon:tableLen(tHurtCharas) > 0 then
        BattleMethod:charaAddHurtValue(monster,tHurtCharas,tHurtValues,tHurtRatios)
        BattleMethod:sendHurtProtocol(monster,tHurtCharas, tHurtValues, tDistance, tCritType)
    end
end

--@brief 镜头控制
function BattleMsgAssistedAirStone:isCanCtrlCamera()
    return self.m_tSkillShowMsg:isCanCtrlCamera()
end

--@brief 获得技能所有者
function BattleMsgAssistedAirStone:getOwner()
    return self.m_tSkillShowMsg.m_tOwner
end

--@brief 获得owner坐标
function BattleMsgAssistedAirStone:getOwnerPos()
    return self.m_tSkillShowMsg.m_tOwner:getPosition()
end

--@brief 获得目标列表
function BattleMsgAssistedAirStone:getMsgTargetList()
    return self.m_tSkillShowMsg.m_tTargetList
end

--@brief 添加表演
function BattleMsgAssistedAirStone:msgDoAction(config)
    self.m_tSkillShowMsg:doAction(config,config.isWait)
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgAssistedAirStone:done()
    WZLog("BattleMsgAssistedAirStone:done")
    self.m_tSkillShowMsg:reduceWait(BattleSkillType.CREATE_ASSISTED_MSG)
end

-------------------------------------私有方法模块--------------------------------------
