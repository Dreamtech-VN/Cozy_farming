--BattleMsgAssistedFlywheelAttack.lua
--@brief    创建飞轮攻击
--@date     2015/09/15
--@author   mbq

--@brief    消息数据表
BattleMsgAssistedFlywheelAttack = {
    m_sName = "BattleMsgAssistedFlywheelAttack",
    m_tSkillShowMsg = nil,      --调用者（BattleMsgShow）

    m_tFlywheelList = nil,
    m_nActCount = nil,  --行动计数
    m_nActDeltaTime = nil,    --行动延迟
    m_tTargetPos = nil, --目标位置
    m_tMoveInfoList = nil,  --运动控制结构列表
    m_bStopCarmer = nil,
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgAssistedFlywheelAttack:init()
    WZLog("BattleMsgAssistedFlywheelAttack:init")
    self.m_tFlywheelList = {}
    for i =1,#self:getOwner().m_tOwnedMonsterList do
        table.insert(self.m_tFlywheelList,self:getOwner().m_tOwnedMonsterList[i])
    end
    self.m_nActCount = 0
    self.m_nActDeltaTime = 0
    self.m_tTargetPos = self:getTarget():getAttackPos()
    self.m_tMoveInfoList = {}
    for i = 1,#self.m_tFlywheelList do
        local wheel = self.m_tFlywheelList[i]
        local curPos = wheel:getPosition()
        local pos = BattleCommon:getPointTable((self.m_tTargetPos.x - curPos.x)/30,(self.m_tTargetPos.y - curPos.y)/30)
        table.insert(self.m_tMoveInfoList,pos)

        self:initMoveFire(wheel)
    end
end

--@brief 添加拖尾
function BattleMsgAssistedFlywheelAttack:initMoveFire(wheel)
    local backFire = WBulletBackFire:create(nil, BulletEffectId.BOSS2_WHEEL_MOVE)
    
    -- wheel:getMover():addTrackNode(backFire:getTrackNode())
    SceneBattle:getFrontLayer():addChild(backFire:getElement():getParent(),2)
    wheel.tmp_MoveFire = backFire
    backFire:getElement():retain()
    self:updateFire(wheel)
end

--@brief 移除拖尾
function BattleMsgAssistedFlywheelAttack:removeMoveFire(wheel)
    if wheel.tmp_MoveFire then
        wheel.tmp_MoveFire:getElement():release()
        -- wheel:getMover():removeTrackNode(wheel.tmp_MoveFire:getTrackNode())
        wheel.tmp_MoveFire:removeElement()
        wheel.tmp_MoveFire = nil
    end
end

function BattleMsgAssistedFlywheelAttack:updateFire(wheel)
    local pos = wheel:getPosition()
    local tPos = BattleCommon:getPointTable(pos.x,pos.y)
    wheel.tmp_MoveFire:getElement():setPosition(tPos.x,tPos.y)
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgAssistedFlywheelAttack:process(dt)
    local isDone = true
    if self.m_nActCount < #self.m_tFlywheelList then
        self.m_nActDeltaTime = self.m_nActDeltaTime + SceneBattle:getBattleLoop():getBattleDeltaTime()
        if self.m_nActDeltaTime > 0.2 or #self.m_tFlywheelList == 0 then
            self.m_nActCount = self.m_nActCount + 1
        end
    end

    if #self.m_tFlywheelList > 0 then
        self:updateFlywheelPos()
        isDone = false
    end
    return isDone
end

--@brief 飞轮移动到目标点
function BattleMsgAssistedFlywheelAttack:updateFlywheelPos()
    for i = #self.m_tFlywheelList,1,-1 do
        if i <= self.m_nActCount then
            local wheel = self.m_tFlywheelList[i]
            local moveInfo = self.m_tMoveInfoList[i]
            local tx = moveInfo.x
            local ty = moveInfo.y
            local curPos = wheel:getPosition()
            local targetPos = self.m_tTargetPos
            local dis = BattleCommon:pointDis(curPos,targetPos)
            local tDis = BattleCommon:pointDis(moveInfo,{x = 0,y = 0})

            if dis <= tDis then
                table.remove(self.m_tFlywheelList,i)
                table.remove(self.m_tMoveInfoList,i)
                self:removeMoveFire(wheel)
                self:createBoomEffect(wheel)
                wheel:setPosition(targetPos)
                wheel:setBoom(true)
                self:wheelHurt(wheel)
                self.m_bStopCarmer = true
            else
                local pos = BattleCommon:getPointTable(curPos.x + tx,curPos.y + ty)
                wheel:setPosition(pos)
                self:updateFire(wheel)
                self:followFlywheel(pos)
            end
        end
    end
end

--@brief 创建爆破效果
function BattleMsgAssistedFlywheelAttack:createBoomEffect(wheel)
    local effect  = BattleEffect:createAnimation(1002)
    wheel:getAnimation():getAnimNode():addChild(effect:getAnimNode())
end

--@brief 跟随飞轮
function BattleMsgAssistedFlywheelAttack:followFlywheel(pos)
    if self.m_bStopCarmer then
        return
    end
    if self._followFlyWheel_time_ == nil then
        self._followFlyWheel_time_ = 0
        else
        self._followFlyWheel_time_ = self._followFlyWheel_time_ + SceneBattle:getBattleLoop():getBattleDeltaTime()
    end
    BattleScreen:followBullet(pos,self._followFlyWheel_time_)
end

--@brief 爆炸伤害
function BattleMsgAssistedFlywheelAttack:wheelHurt(wheel)
    local tHurtCharas, tHurtValues, tDistance, tCritType, tHurtRatios = self:checkMeleeHurt(wheel)
    if BattleCommon:tableLen(tHurtCharas) > 0 then
        BattleMethod:charaAddHurtValue(wheel,tHurtCharas,tHurtValues,tHurtRatios)
        BattleMethod:sendHurtProtocol(wheel,tHurtCharas, tHurtValues, tDistance, tCritType, true)
    end
end

--@brief    检查近攻伤害
--@return   #1:受伤的人物列表
--@return   #2:受伤值
function BattleMsgAssistedFlywheelAttack:checkMeleeHurt(monster)
    return BattleMethod:checkMeleeHurt(monster)
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgAssistedFlywheelAttack:done()
   self.m_tSkillShowMsg:reduceWait(BattleSkillType.CREATE_ASSISTED_MSG)
end


--@brief 获得技能所有者
function BattleMsgAssistedFlywheelAttack:getOwner()
    return self.m_tSkillShowMsg.m_tOwner
end

--@brief 获得技能目标
function BattleMsgAssistedFlywheelAttack:getTarget()
    WZLog("BattleMsgAssistedFlywheelAttack:done")
    return self.m_tSkillShowMsg.m_tTargetList[1]
end
-------------------------------------私有方法模块--------------------------------------
