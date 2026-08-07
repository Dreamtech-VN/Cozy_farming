--BattleMsgAiDisplacement.lua
--@brief    战斗位移AI
--@date     2015/10/24
--@note     AI控制
--@brief    消息数据表

BattleMsgAiDisplacement = {
    m_tOwner = nil,     --调用者
    m_tTarget = nil,    --目标
    m_bLimitFly = nil,  --限制飞行
    m_bInMove = nil,    --移动中
    m_tStepFunction = nil,  --步骤
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgAiDisplacement:init()
    WZLog("BattleMsgAiDisplacement:init")
    if not self.m_tTarget then
        self.m_tTarget = WMonster:getRandomPlayer()
    end
    if not self.m_tTarget then
        return
    end
    self.m_tStepFunction = {}
    -- self:checkMove()
    self.m_tOwner.m_bIsCanMove = false
    self:initStep()
end

--@brief 检测命中
function BattleMsgAiDisplacement:checkHitTarget()
    local sPos = self.m_tOwner:getCenterPos()
    local ePos = self.m_tTarget:getCenterPos()
    local isAtkSucceed,speed = BattleAiCheck:adjustAngle(sPos,ePos)
    return isAtkSucceed,speed
end

--@brief 检测位移步骤
function BattleMsgAiDisplacement:initStep()
    local curPos = self.m_tOwner:getPosition()
    local targetPos = self.m_tTarget:getPosition()
    local dis = BattleCommon:pointDis(curPos,targetPos)
    local canHit = self:checkHitTarget()

    if not self.m_bLimitFly and canHit and BattleAiCheck:getCurRandNum()%100 < 25 and BattleCommon:pointDis(curPos,targetPos) > 600 then
        table.insert(self.m_tStepFunction,{self.checkFly,false,true})
        return
    end
    if dis <= 120 then
        table.insert(self.m_tStepFunction,{self.checkMove})
        table.insert(self.m_tStepFunction,{self.updateMove})
        return
    end
    
    if not canHit then
        table.insert(self.m_tStepFunction,{self.checkMove})
        table.insert(self.m_tStepFunction,{self.updateMove})
        table.insert(self.m_tStepFunction,{self.checkFly,true})
    end
end

--@brief 检测移动
function BattleMsgAiDisplacement:checkMove()
    local curPos = self.m_tOwner:getPosition()
    local targetPos = self.m_tTarget:getPosition()
    local direct = -1 --往左移动
    --远离目标
    if curPos.x > SceneBattle:getFrontLayerSize().width/2 then
        direct = -1
    else
        direct = 1
    end
    if math.abs(curPos.x - SceneBattle:getFrontLayerSize().width/2) < 200 then
        direct = -direct
    end

    local endPos = self:getMoveEndPos(direct)
    if endPos then
        local moveDis = endPos.x - curPos.x
        if math.abs(moveDis) > 10 then
            self:doMove(moveDis)
        end
    end
    return true
end

--@brief 执行移动
function BattleMsgAiDisplacement:doMove(moveDis)
    self.m_tOwner.m_bIsCanMove = true
    self.m_tOwner:getAI():doAction(AiActionConfig.MOVE_NEW,
        {[1] = {actionParm1 = moveDis,actionParm2 = 0,actionParm3 = self.m_tOwner:getPosition().x + moveDis,actionParm4 = 0}},
        nil, nil,nil, true)
end
--@brief 获得能移动的位置
function BattleMsgAiDisplacement:getMoveEndPos(direct)
    local hero = self.m_tOwner
    local sPos = hero:getMover():getMoverPosition()
    local moveEndPos = nil
    local acceleration = BattleConstants.g_nGravity

    local movetime = 80--每次移动步数
    local count = 1 --移动尝试次数
    local posEnd = nil--单次尝试可移动目标点
    local canMove = false
    while canMove ~= true and count < 80/5 do
        count = count + 1
        WZLog("BattleMsgAiDisplacement:getMoveEndPos compare",direct,movetime)
        local speed = {x=math.abs(hero.m_tMoveSpeed.x)*direct,y=0.2}
        canMove, posEnd =BattleCommon:checkMoveCollision(sPos,movetime,speed,acceleration,BattleMapManager.m_pixelByte)
        if canMove == true then
            moveEndPos = posEnd
        end
        movetime = movetime - 5
    end
    if moveEndPos then
        if moveEndPos.x < 100 then
            moveEndPos.x = 100
        elseif moveEndPos.x > SceneBattle:getFrontLayerSize().width - 100 then
            moveEndPos.x = SceneBattle:getFrontLayerSize().width - 100
        end
        WZLog("BattleMsgAiDisplacement:getMoveEndPos end",moveEndPos.x,moveEndPos.y)
    end
    WZLog("BattleMsgAiDisplacement:getMoveEndPos start",sPos.x,sPos.y)
    return moveEndPos
end

--@brief 检测飞行
function BattleMsgAiDisplacement:checkFly(isCheck,isToHero)
    if self.m_bLimitFly then
        return true
    end
    if not isCheck then
        self:doFly(isToHero)
        return true
    end
    local canFly = true
    local sPos = self.m_tOwner:getPosition()
    local ePos = self.m_tTarget:getPosition()
    if BattleCommon:pointDis(sPos,ePos) > 200 and not self:checkHitTarget() then
        self:doFly()
    end
    return true
end

--@brief 执行飞行
function BattleMsgAiDisplacement:doFly(isToHero)
    local hero = self.m_tOwner
    
    local aimHero = self.m_tTarget
    local sPos = {x = hero:getPosition().x, y = hero:getPosition().y + 20}
    local ePos = nil--aimHero:getPosition()
    if isToHero then
        --飞到玩家附近
        ePos = {x = aimHero:getPosition().x,y = aimHero:getPosition().y}
        if sPos.x < ePos.x then
            ePos.x = ePos.x - 100 
        else
            ePos.x = ePos.x + 100
        end
        if ePos.x < 100 then
            ePos.x = 100
        elseif ePos.x > SceneBattle:getFrontLayerSize().width - 100 then
            ePos.x = SceneBattle:getFrontLayerSize().width - 100
        end
    else
        local direct = -1
        if sPos.x < SceneBattle:getFrontLayerSize().width/2 then
            direct = 1
        end
        local offsetX = 200
        local offsetY = 600
        if sPos.y > 300 then
            if sPos.y <= 600 then
                offsetX = 250
                offsetY = 400
            elseif sPos.y <= 900 then
                offsetX = 300
                offsetY = 200
            else
                offsetX = 400
                offsetY = 100
            end
        end
        ePos = {x = sPos.x + offsetX * direct,y = sPos.y + offsetY}
    end
    local isAtkSucceed,speed = BattleAiCheck:adjustAngle(sPos,ePos)
    
    hero.m_mover:setMoverSpeed(Vector2:create(3,-1))
    

    self.m_tOwner:getAI():doAction(AiActionConfig.FLY,{[1] = {actionParm1 = sPos.x,actionParm2 = sPos.y,actionParm3 = speed.x,actionParm4 = speed.y}})
    self.m_tOwner:getAI():aiAllDone()
end


--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgAiDisplacement:process(dt)
    if not self.m_tTarget then
        return true
    end

    if #self.m_tStepFunction > 0 then
        local res = self.m_tStepFunction[1][1](self,self.m_tStepFunction[1][2],self.m_tStepFunction[1][3],self.m_tStepFunction[1][4])
        if res == true or res == nil then
            table.remove(self.m_tStepFunction,1)
        end
        return false
    end

    return true
end

--@brief 移动
function BattleMsgAiDisplacement:updateMove()
    -- WZLog("BattleMsgAiDisplacement:updateMove",self.m_tOwner.m_bIsCanMove)
    if self.m_tOwner.m_bIsCanMove == true then
        return false
    end
    return true
end


--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgAiDisplacement:done()
    WZLog("BattleMsgAiDisplacement:done")
    self.m_tOwner:getAI().m_bAiDisplacementDone = true
end

-------------------------------------私有方法模块--------------------------------------

