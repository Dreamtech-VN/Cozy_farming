--BattleMsgAssistedKidSkill.lua
--@brief    召唤孩子
--@date     2021/05/06
--@author   mbq

--@brief    消息数据表
BattleMsgAssistedKidSkill = {
    m_sName = "BattleMsgAssistedKidSkill",
    m_tOwner = nil,      --拥有者
    m_nSkillId = nil,    -- 使用的小孩技能Id
    m_tBornPos = nil,    --小孩出生点
    m_tConKid = nil,    
    m_nScale = 0,        --小孩的缩放值 
    m_nConstDistance = 300, --随机距离最大值
    m_tCircleArray = nil,   --法阵
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgAssistedKidSkill:init()
    WZLog("BattleMsgAssistedKidSkill:init")
    self.m_nDeltaTime = 0
    self.m_nScale = 0
    self.m_tStepList = {}

    self:initStep()
end

function BattleMsgAssistedKidSkill:initStep()
    table.insert(self.m_tStepList,{self.getKidBornPos})
    table.insert(self.m_tStepList,{self._requestKidBattleId})
    table.insert(self.m_tStepList,{self._waitKidId})
    table.insert(self.m_tStepList,{self.createKid})
    table.insert(self.m_tStepList,{self.scaleKidToNormal})
end

--brief     获取孩子的出生位置
function BattleMsgAssistedKidSkill:getKidBornPos()
    local ownPos = self.m_tOwner:getCenterPos()
    self.m_tBornPos = {}
    -- do 
    --     self.m_tBornPos.x = 400
    --     self.m_tBornPos.y = 650
    --     return true
    -- end
    local randList = WBattleGlobal:getCurrent().m_tBattleRand
    local tempDir = {{x = 1, y = 1}, {x = -1, y = 1}, {x = -1, y = -1}, {x = 1, y = -1}}
    local sceneSize = SceneBattle:getFrontLayerSize()
    local randomCount = #randList
    local firstRandomPos = nil 
    local function isOutOfScene(pt)
        -- body
        local outOfScene = false 
        if SceneBattle:getFrontLayer() then
            local a = pt
            a = {x = a.x,y = a.y}
            
            --纵向超出屏幕
            if a.y < 0 or a.y > sceneSize.height then
                outOfScene = true 
            end
            --横向超出屏幕
            if a.x < -10 or a.x > sceneSize.width then
                outOfScene = true 
            end
        end

        return outOfScene
    end
    for i = 1, randomCount do
        local random = randList[i] % 4 + 1
        local dir = tempDir[random]
        local randomAddX = randList[i] % self.m_nConstDistance
        local yRandomIndex = i % randomCount + 1
        for j = 1, randomCount do
            local randomAddY = randList[yRandomIndex] % self.m_nConstDistance
            
            local pos = {x = ownPos.x + randomAddX * dir.x, y = ownPos.y + randomAddY * dir.y}
            local outOfScene = isOutOfScene(pos) 
            local bIsColl = BattleCommon:checkPosCollision(pos, BattleMapManager.m_pixelByte)
            
            if not outOfScene and firstRandomPos == nil then 
                firstRandomPos = {x = pos.x, y = pos.y}
            end
            if not bIsColl and not outOfScene then
                self.m_tBornPos.x = pos.x
                self.m_tBornPos.y = pos.y
                return true  
            end
        end
    end
    --如果上面的还没有随机到出生点，继续下面的逻辑
    local tempPos = {x = firstRandomPos.x, y = firstRandomPos.y}
    local speedY = 3
    if tempPos.y > sceneSize.height/2 then 
        speedY = -3
    end
    --Y轴方向
    while self.m_tBornPos.x == nil do 
        tempPos.y = tempPos.y + speedY 
        local outOfScene = isOutOfScene(tempPos) 
        local bIsColl = BattleCommon:checkPosCollision(tempPos, BattleMapManager.m_pixelByte)
        if not bIsColl and not outOfScene then
            self.m_tBornPos.x = tempPos.x
            self.m_tBornPos.y = tempPos.y
            return true  
        end
    end
    --X轴方向
    local tempPos1 = {x = firstRandomPos.x, y = firstRandomPos.y}
    local speedX = 3
    if tempPos1.x > sceneSize.width/2 then 
        speedX = -3
    end
    while self.m_tBornPos.x == nil do 
        tempPos1.x = tempPos1.x + speedX 
        local outOfScene = isOutOfScene(tempPos1) 
        local bIsColl = BattleCommon:checkPosCollision(tempPos1, BattleMapManager.m_pixelByte)
        if not bIsColl and not outOfScene then
            self.m_tBornPos.x = tempPos1.x
            self.m_tBornPos.y = tempPos1.y
            return true  
        end
    end
    --还没有找到合适位置，则直接使用玩家当前的位置
    self.m_tBornPos.x = ownPos.x
    self.m_tBornPos.y = ownPos.y

    return true 
end

--brief     创建召唤孩子过程动画
function BattleMsgAssistedKidSkill:createKid()
    local anim = BattleAnimation:createAnimation("skill_magicCircle", false, "battle/skill")
    anim:setScale(0.5)
    anim:getAnimNode():play("animation", true)
    anim:setPosition(self.m_tBornPos)
    self.m_tCircleArray = anim
    SceneBattle:getFrontLayer():addChild(anim:getAnimNode())

    local kidBattleId = self:getOwner().kidBattleId
    if WBattleGlobal:getCurrent():isSingleStage() then 
        kidBattleId = WBattleGlobal:getCurrent():getBuildGuaiBattleId(true)
    end
    local kid = WBattleGlobal:getCurrent():buildKid(self.m_tOwner, self.m_nSkillId, kidBattleId)

    kid:getAnimation():getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5, 0.12)) 
    kid:getAnimation():setPosition(self.m_tBornPos)
    kid:setScale(self.m_nScale)
    self.m_tConKid = kid
    kid:getAnimation():play(kid:getActionName(23), true)
    SceneBattle:getFrontLayer():addChild(kid:getAnimation():getAnimNode())

    local playerName = BattleKidName:create(kid, SceneBattle:getInfoLayer(), true)
    kid:setPlayerNameIcon(playerName)
    playerName:update()
    --如果小孩所属玩家隐身，则小孩隐身
    kid:_showHero()

    return true 
end

--brief     放大到正常大小
function BattleMsgAssistedKidSkill:scaleKidToNormal(param1, param2, param3, dt)
    if self.m_tConKid == nil then return true end 
    WZLog("BattleMsgAssistedKidSkill:scaleKidToNormal", dt)
    local nNorScale = self.m_tConKid:getAnimScale()
    if self.m_nScale >= nNorScale then 
        if self.m_tCircleArray then 
            self.m_tCircleArray:getAnimNode():removeFromParentAndCleanup(true)
            self.m_tCircleArray = nil 
        end
        self.m_tConKid.m_nShootState = 0
        return true 
    else
        self.m_nScale = self.m_nScale + dt/2
        if self.m_nScale >= nNorScale then 
            self.m_nScale = nNorScale 
        end
        self.m_tConKid:setScale(self.m_nScale)
        return false 
    end
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgAssistedKidSkill:process(dt)
    --重连成功，而且正在等待怪物id
    if self.m_bIsWaitKidId and self.m_bIsReconnectDone then
        return true
    end

    if #self.m_tStepList > 0 then
        local res = self.m_tStepList[1][1](self,self.m_tStepList[1][2],self.m_tStepList[1][3],self.m_tStepList[1][4], dt)
        if res == true or res == nil then
            table.remove(self.m_tStepList,1)
        end
    end

    if #self.m_tStepList > 0 then
        return false
    end

    return true
end

--@brief 获得技能所有者
function BattleMsgAssistedKidSkill:getOwner()
    return self.m_tOwner
end

--@brief 获得owner坐标
function BattleMsgAssistedKidSkill:getOwnerPos()
    return self.m_tOwner:getPosition()
end


--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgAssistedKidSkill:done()
    WZLog("BattleMsgAssistedKidSkill:done")
end

--@brief 申请战斗id
function BattleMsgAssistedKidSkill:_requestKidBattleId()
    WZLog("BattleMsgAssistedKidSkill:_requestKidBattleId", tostring(self.m_tOwner:isCanControl()))
    if self.m_bIsSummon == nil then
        self.m_bIsSummon = true
        self.m_nBattleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
        self.m_nCurrentId = self.m_tOwner:getBattleId()

        if  self.m_tOwner:isCanControl() then
            WZLog("BattleMsgAssistedKidSkill:_requestKidBattleId two", self.m_nBattleId, self.m_nCurrentId)

            ProtocolProcessorBattleInterface:send_BATTLE_BuildChild(self.m_nBattleId, self.m_nCurrentId, self.m_tBornPos.x, self.m_tBornPos.y) 
        else
            self.m_bClientSummon = true
        end

        if WBattleGlobal:getCurrent():isSingleStage() then
            self.m_bIsSummon = nil
            return true
        end
    end
    --客机使用召唤技能，等待battleId过程，转为可以控制的主机，发送召唤申请
    if not WBattleGlobal:getCurrent():isSingleStage() and self.m_bClientSummon and self.m_tOwner:isCanControl() then
        self.m_bClientSummon = nil
        WZLog("BattleMsgAssistedKidSkill:_requestKidBattleId two", self.m_nBattleId, self.m_nCurrentId)

        ProtocolProcessorBattleInterface:send_BATTLE_BuildChild(self.m_nBattleId, self.m_nCurrentId, self.m_tBornPos.x, self.m_tBornPos.y)
    end

    if self.m_tOwner.kidBattleId ~= nil then  
        self.m_bIsSummon = nil
        return true
    else
        WZLog("BattleMsgAssistedKidSkill:_requestKidBattleId wait")
        return false
    end
end

--@brief 等待怪物id
function BattleMsgAssistedKidSkill:_waitKidId()
    if  WBattleGlobal:getCurrent():isSingleStage() then 
        return true
    end
    if  self.m_tOwner.kidBattleId == nil then 
        WZLog("BattleMsgAssistedKidSkill:_waitKidId wait")
        self.m_bIsWaitKidId = true
        return false
    end
    self.m_bIsWaitKidId = false
    return true
end

-------------------------------------私有方法模块--------------------------------------

