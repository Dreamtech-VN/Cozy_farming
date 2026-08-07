--BattleMsgAssistedFlywheelBuild.lua
--@brief    创建飞轮
--@date     2015/09/15
--@author   mbq

--@brief    消息数据表
BattleMsgAssistedFlywheelBuild = {
    m_sName = "BattleMsgAssistedFlywheelBuild",
    m_tSkillShowMsg = nil,      --调用者（BattleMsgShow）
    --目标点
    m_tBornPosTab = nil,
    m_nBuildCount = nil,
    m_nBuildDeltaTime = nil,
    m_tFlywheelList = nil,
    m_tMoveInfoList = nil,
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgAssistedFlywheelBuild:init()
    WZLog("BattleMsgAssistedFlywheelBuild:init")
    local pos = self:getOwnerPos()
    local flix = 1
    if pos.x < 500 then
        flix = -1
    end
    self.m_tBornPosTab = {}
    table.insert(self.m_tBornPosTab,{x = pos.x - 216 * flix,y = pos.y - 237 + 50})
    table.insert(self.m_tBornPosTab,{x = pos.x - 602 * flix,y = pos.y - 48 + 50})
    table.insert(self.m_tBornPosTab,{x = pos.x - 376 * flix,y = pos.y - 42 + 50})
    table.insert(self.m_tBornPosTab,{x = pos.x - 544 * flix,y = pos.y + 160 + 50})
    -- local random = math.random(1,3)
    -- local random = BattleAiCheck:getCurRandNum()/10000
    -- if random < 0.35 then
    --     table.insert(self.m_tBornPosTab,{x = pos.x - 638 * flix,y = pos.y - 202 + 50})
    -- elseif random < 0.7 then
    --     table.insert(self.m_tBornPosTab,{x = pos.x - 510 * flix,y = pos.y - 250 + 50})
    -- else
        table.insert(self.m_tBornPosTab,{x = pos.x - 280 * flix,y = pos.y + 194 + 50})
    -- end

    self.m_nBuildCount = 1
    self.m_nBuildDeltaTime = 0
    self.m_tFlywheelList = {}
    self.m_tMoveInfoList = {}
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgAssistedFlywheelBuild:process(dt)
    local isDone = true
    if self.m_nBuildCount <= #self:getOwner().m_tOwnedMonsterList then
        self.m_nBuildDeltaTime = self.m_nBuildDeltaTime + SceneBattle:getBattleLoop():getBattleDeltaTime()
        if self.m_nBuildDeltaTime > 0.4 or #self.m_tFlywheelList == 0 then
            self:buildFlywheel()
            self.m_nBuildCount = self.m_nBuildCount + 1
        end
        isDone = false
    end

    -- if #self.m_tFlywheelList > 0 then
    --     self:updateFlywheelPos()
    --     isDone = false
    -- end

    return isDone
end

--@brief 获得技能所有者
function BattleMsgAssistedFlywheelBuild:getOwner()
    return self.m_tSkillShowMsg.m_tOwner
end

--@brief 获得owner坐标
function BattleMsgAssistedFlywheelBuild:getOwnerPos()
    return self.m_tSkillShowMsg.m_tOwner:getPosition()
end

--@brief 创建飞轮
function BattleMsgAssistedFlywheelBuild:buildFlywheel()
    WZLog("BattleMsgAssistedFlywheelBuild:buildFlywheel", self.m_nBuildCount)
    local wheel = self:getOwner().m_tOwnedMonsterList[self.m_nBuildCount]
    local pos = self.m_tBornPosTab[self.m_nBuildCount]
    wheel:setPosition(pos)
    SceneBattle:getFrontLayer():addChild(wheel:getAnimation():getAnimNode(),5)
    self.m_tSkillShowMsg:playSound("feilun")
    WBattleGlobal:getCurrent().m_tGuais[wheel:getBattleId()] = wheel
    if wheel:getMover() then
        WBattleGlobal:getCurrent().m_battleManager:addEntity(wheel:getMover())
    end
    wheel:setAppearAttribute()
    wheel:play(wheel:getAnimationName("standby"), true)
    self:createBornEffect(wheel)
    table.insert(self.m_tFlywheelList,wheel)
end

--@brief 创建效果
function BattleMsgAssistedFlywheelBuild:createBornEffect(wheel)
    local effect  = BattleEffect:createAnimation(1001)
    wheel:getAnimation():getAnimNode():addChild(effect:getAnimNode())
end

--@brief 飞轮移动到目标点
function BattleMsgAssistedFlywheelBuild:updateFlywheelPos()
    for i = #self.m_tFlywheelList,1,-1 do
        local wheel = self.m_tFlywheelList[i]
        local targetPos = self.m_tBornPosTab[i]
        local curPos = wheel:getPosition()
        local curScale = wheel:getScale()
        
        local moveInfo = self.m_tMoveInfoList[i]
        if not moveInfo then 
            moveInfo = {}
            moveInfo.pos = BattleCommon:getPointTable((targetPos.x - curPos.x)/30,(targetPos.y - curPos.y)/30)
            moveInfo.scale = (1 - curScale)/30
            table.insert(self.m_tMoveInfoList,moveInfo)
        end

        local dis = BattleCommon:pointDis(curPos,targetPos)
        local tDis = BattleCommon:pointDis(moveInfo.pos,{x = 0,y = 0})
        if dis <= tDis then
            wheel:setPosition(targetPos)
            wheel:setScale(1)
            table.remove(self.m_tFlywheelList,i)
            table.remove(self.m_tMoveInfoList,i)
            table.remove(self.m_tBornPosTab,i)
        else
            local tx = moveInfo.pos.x
            local ty = moveInfo.pos.y
            local tScale = moveInfo.scale
            wheel:setPosition(BattleCommon:getPointTable(curPos.x + tx,curPos.y + ty))
            wheel:setScale(curScale + tScale)
        end
    end
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgAssistedFlywheelBuild:done()
    WZLog("BattleMsgAssistedFlywheelBuild:done")
    self.m_tSkillShowMsg:reduceWait(BattleSkillType.CREATE_ASSISTED_MSG)
end

-------------------------------------私有方法模块--------------------------------------

