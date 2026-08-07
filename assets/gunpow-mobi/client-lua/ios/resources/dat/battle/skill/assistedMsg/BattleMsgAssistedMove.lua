--BattleMsgAssistedMove.lua
--@brief    怪物移动
--@date     2015/9/15
--@author   mbq
--@note

--@brief    消息数据表
BattleMsgAssistedMove = {
    m_sName = "BattleMsgAssistedMove",
    m_tSkillShowMsg = nil,      --调用者（BattleMsgShow）
    --目标点
    m_tTargetPos = nil,
    m_bMovePlayed = nil,
    m_tAirMoveStep = nil,
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgAssistedMove:init()
    WZLog("BattleMsgAssistedMove:init",self:getOwner():isInBuffState(EffectTypeConfig.LIMIT_MOVE))
    if self:getOwner():isInBuffState(EffectTypeConfig.LIMIT_MOVE) or self:getOwner():isInBuffState(EffectTypeConfig.LIMIT_ALL_ACTION) then
        self:getOwner().m_bIsCanMove = nil
    end
    self:readyMonsterMove()
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgAssistedMove:process(dt)
    return self:monsterMove()
end

function BattleMsgAssistedMove:initMoveParam()
    local list = WBattleGlobal:getCurrent():getHeroSortList()
    local dis = nil
    local heroPos = nil
    for id, hero in ipairs(list) do
        if not hero:isDead() then
            local distance = BattleCommon:pointDis(hero:getPosition(),bossPos)
            if not dis then
                dis = distance
                heroPos = hero:getPosition()
            elseif dis > distance then
                dis = distance
                heroPos = hero:getPosition()
            end
        end
    end
    local offsetX = 150
    if self.m_tSkillShowMsg.m_tOwner:getPosition().x > heroPos.x then
        offsetX = 150
    else
        offsetX = -150
    end
    local moveStepPos =  BattleCommon:getPointTable(heroPos.x + offsetX,heroPos.y)
    local targetPos = BattleCommon:getPointTable(heroPos.x + offsetX,heroPos.y)
      
    self.m_tSkillShowMsg.m_tMoveParm = {}
    self.m_tSkillShowMsg.m_tMoveParm.moveStepPos = moveStepPos
    self.m_tSkillShowMsg.m_tMoveParm.targetPos = targetPos
end

--@brief    小怪准备移动
function BattleMsgAssistedMove:readyMonsterMove()
    if self.m_bIsNearPlayer then
        self:initMoveParam()
    end

    local moveParam = self:getMoveParam()
    
    WZLog("BattleMsgAssistedMove:readyMonsterMove",Serialize(moveParam))
    
    local targetPos = moveParam.targetPos
    local moveStepPos = moveParam.moveStepPos
    local monster = self:getOwner()
    local curpos = monster.m_anim:getPosition()
    -- monster:setPosition({x = curpos.x ,y = curpos.y + 2})
    self:checkTargetPos(curpos,targetPos,moveStepPos)
    self.m_tAirMoveStep = {x = self.m_tTargetPos.x - curpos.x, y = self.m_tTargetPos.y - curpos.y}
    --调整小怪移动方向
    monster:adjustDirect(self.m_tTargetPos)
end

--@brief 计算目标点坐标
function BattleMsgAssistedMove:checkTargetPos(curpos,targetPos,moveStepPos)
    if curpos.x > targetPos.x then
        targetPos = moveStepPos.x > targetPos.x and moveStepPos or targetPos
    else
        targetPos = moveStepPos.x < targetPos.x and moveStepPos or targetPos
    end

    local x1 = curpos.x
    local y1 = curpos.y
    local x2 = targetPos.x
    local y2 = targetPos.y
    local d = BattleCommon:pointDis(curpos, targetPos)
    
    if y1 - y2 == 0 then y2 = y2-1 end
    local k = (x1 - x2) / (y1 - y2)
    
    local y3
    if (x1 > x2 and y1 < y2) or (x1 < x2 and y1 < y2) then
        y3 = y1 + d / math.sqrt(k * k + 1)
    else
        y3 = y1 - d / math.sqrt(k * k + 1)
    end
    local x3 = x1 - k * (y1 - y3)
    
    self.m_tTargetPos =  {x = x3, y = y3}
end

--@brief    小怪移动
function BattleMsgAssistedMove:monsterMove()
    local moveEnd = false
    local monster = self:getOwner()
    if  monster:isDead() or  monster:isSacrifice() or  monster:isBoom() then
        return
    end
    WZLog("BattleMsgAssistedMove:monsterMove",monster.m_bIsCanMove)
    if not monster.m_bIsCanMove or WBattleGlobal:getCurrent():isGameOver() then
        monster:play(monster:getAnimationName("standby"), true)
        monster:setActFinished(true)
        return true
    end

    if not self.m_bMovePlayed then
        monster:play(monster:getAnimationName("move"), true)
        self.m_bMovePlayed = true
    end
    monster:setPF(monster:getPF()-1)
    monster:setRunStatus(RunStatus.DEF_ST_MOVE)
    local curpos = monster.m_anim:getPosition()
    local targetPos = self.m_tTargetPos
    if monster.m_bIsAir == true then
        if BattleCommon:pointDis(curpos, self.m_tTargetPos) < 15 then
            monster:setPosition(targetPos)
            moveEnd = true
        else
            local pos = {x = curpos.x + self.m_tAirMoveStep.x * 0.04, y = curpos.y + self.m_tAirMoveStep.y * 0.04}
            monster:setPosition(pos)
        end
    else
        if math.abs(curpos.x - targetPos.x) < 10 then
            moveEnd = true
        else
            monster:setPosition({x = curpos.x ,y = curpos.y + 2})
            monster:setMoveUpdatable(true)
            monster:getMover():setMoveAcceleration(monster.m_tMoveSpeed.x,0.2)
        end
    end
    --镜头跟随
    self:followMonsterListMove()
    if monster:getPF() <= 0 or moveEnd then
        monster:play(monster:getAnimationName("standby"), true)
        monster:setActFinished(true)
        return true
    end
    return false
end

--@brief    屏幕跟踪小怪
function BattleMsgAssistedMove:followMonsterListMove()
    if not self:isCanCtrlCamera() then
        return
    end
    WZLog("BattleScreen:followHero 3")
    BattleScreen:followHero(self:getOwner():getMover():getMoverPosition())
end

--@brief 镜头控制
function BattleMsgAssistedMove:isCanCtrlCamera()
    return self.m_tSkillShowMsg:isCanCtrlCamera()
end

--@brief 获得技能所有者
function BattleMsgAssistedMove:getOwner()
    return self.m_tSkillShowMsg.m_tOwner
end

--@brief 获得owner坐标
function BattleMsgAssistedMove:getOwnerPos()
    return self.m_tSkillShowMsg.m_tOwner:getPosition()
end

--@brief 获得移动参数
function BattleMsgAssistedMove:getMoveParam()
    return self.m_tSkillShowMsg.m_tMoveParm
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgAssistedMove:done()
    WZLog("BattleMsgAssistedMove:done")
    self:getOwner().m_bIsCanMove = nil
    --技能位移
    if self.m_bIsNearPlayer then
        self.m_tSkillShowMsg.m_tMoveParm = nil
    end
    self.m_tSkillShowMsg:reduceWait(BattleSkillType.CREATE_ASSISTED_MSG)
end

-------------------------------------私有方法模块--------------------------------------
