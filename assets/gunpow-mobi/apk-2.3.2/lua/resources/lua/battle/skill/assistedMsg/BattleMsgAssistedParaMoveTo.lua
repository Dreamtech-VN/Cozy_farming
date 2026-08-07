--BattleMsgAssistedParaMoveTo.lua
--@brief    抛物线移动
--@date     2015/9/18
--@author   mbq
--@note

--@brief    消息数据表
BattleMsgAssistedParaMoveTo = {
    m_sName = "BattleMsgAssistedParaMoveTo",
    m_tSkillShowMsg = nil,      --调用者（BattleMsgShow）
    m_tTargetPos = nil,         -- 目标位置
    m_nSpeed = nil,
    --内部控制变量
    m_nCoefA = nil, --a
    m_nCoefB = nil, --b
    m_nCoefC = nil, --c
    m_bIsBackFire = nil,
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgAssistedParaMoveTo:init()
    WZLog("BattleMsgAssistedParaMoveTo:init",tostring(self.m_bIsBackFire))
    self:getOwner():setMapCollision(false)
    self.m_nSpeed = self.m_nSpeed or 20
    local targetPos = self.m_tTargetPos
    local pos = self:getOwnerPos()
    local vx = pos.x < targetPos.x and pos.x or targetPos.x
    local vy = pos.y < targetPos.y and pos.y or targetPos.y
    local vertexPt = BattleCommon:getPointTable((vx + math.abs(targetPos.x - pos.x)/2),vy + 300)
    -- local vertexPt = BattleCommon:getPointTable(pos.x + (self.m_tTargetPos.x - pos.x)/2,self.m_tTargetPos.y + 300)
  
    local x1 = pos.x
    local x2 = self.m_tTargetPos.x
    local x3 = vertexPt.x

    local y1 = pos.y
    local y2 = self.m_tTargetPos.y
    local y3 = vertexPt.y

    self.m_nCoefB = ((y1 - y3) * (x1 * x1 - x2 * x2) - (y1 - y2) * (x1 * x1 - x3 * x3)) / ((x1 - x3) * (x1 * x1 - x2 * x2) - (x1 - x2) * (x1 * x1 - x3 * x3))
    self.m_nCoefA = ((y1 - y2) - self.m_nCoefB * (x1 - x2)) / (x1 * x1 - x2 * x2)
    self.m_nCoefC = y1 - self.m_nCoefA * x1 * x1 - self.m_nCoefB * x1
    if self.m_bIsBackFire then
        self:initMoveFire(self:getOwner())
    end
end

--@brief 添加拖尾
function BattleMsgAssistedParaMoveTo:initMoveFire(monster)
    local x = 110
    if monster.m_bIsFilpX then
        x = -110
    end
    self.m_tOffset = {x = x,y = 170}
    local backFire = WBulletBackFire:create(nil, BulletEffectId.BOSS2_MOVE)
    -- monster:getMover():addTrackNode(backFire:getTrackNode())
    -- backFire:getTrackNode():setAffterAdd(Vector2:create(x,170))

    SceneBattle:getFrontLayer():addChild(backFire:getElement():getParent(),2)
    monster.tmp_MoveFire = backFire
    backFire:getElement():retain()
end

--@brief 移除拖尾
function BattleMsgAssistedParaMoveTo:removeMoveFire(monster)
    if monster.tmp_MoveFire then
        --monster.tmp_MoveFire:getElement():release()
        -- monster:getMover():removeTrackNode(monster.tmp_MoveFire:getTrackNode())
        monster.tmp_MoveFire:removeElement()
        monster.tmp_MoveFire = nil
    end
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgAssistedParaMoveTo:process(dt)
    local curPos = self:getOwnerPos()
    local targetPos = self.m_tTargetPos
    -- WZLog("BattleMsgAssistedParaMoveTo:process",curPos.x,targetPos.x)
    
    if math.abs(targetPos.x - curPos.x) <= self.m_nSpeed then
        if targetPos.x > curPos.x then
            targetPos.x = targetPos.x - 1
        else
            targetPos.x = targetPos.x + 1
        end
        self:getOwner():setPosition(targetPos)
        return true
    end
    local tx = nil
    if targetPos.x > curPos.x then
        tx = curPos.x + self.m_nSpeed     
    else
        tx = curPos.x - self.m_nSpeed
    end
    local ty = self:getPosY(tx)
    local movePos = BattleCommon:getPointTable(tx,ty)
    self:getOwner():setPosition(movePos)
    self:zoomToHero()
    if self:getOwner().tmp_MoveFire then
        self:getOwner().tmp_MoveFire:getElement():setPosition(tx + self.m_tOffset.x,ty + self.m_tOffset.y)
    end
    return false
end

--@brief 获得位移过程 y坐标
function BattleMsgAssistedParaMoveTo:getPosY(posX)
    local posY = self.m_nCoefA * posX * posX + self.m_nCoefB * posX + self.m_nCoefC;
    return posY
end

--@brief 镜头控制
function BattleMsgAssistedParaMoveTo:isCanCtrlCamera()
    return self.m_tSkillShowMsg:isCanCtrlCamera()
end

--@brief 获得技能所有者
function BattleMsgAssistedParaMoveTo:getOwner()
    return self.m_tSkillShowMsg.m_tOwner
end

--@brief 获得owner坐标
function BattleMsgAssistedParaMoveTo:getOwnerPos()
    return self.m_tSkillShowMsg.m_tOwner:getPosition()
end

--@brief 镜头跟随
function BattleMsgAssistedParaMoveTo:zoomToHero()
    if not self:isCanCtrlCamera() then
        return
    end

    local hero = self:getOwner()
    BattleScreen:followHero(BattleCommon:getPointTable(hero:getPosition().x,hero:getPosition().y + 120))
    WZLog("BattleScreen:followHero 4")
end

function BattleMsgAssistedParaMoveTo:clearAction()
    self:removeMoveFire(self:getOwner())
    self:getOwner():setMapCollision(true)
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgAssistedParaMoveTo:done()
    WZLog("BattleMsgAssistedParaMoveTo:done")
    self:removeMoveFire(self:getOwner())
    self:getOwner():setMapCollision(true)
    self.m_tSkillShowMsg:reduceWait(BattleSkillType.CREATE_ASSISTED_MSG)
end

-------------------------------------私有方法模块--------------------------------------
