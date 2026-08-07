-- BattleMsgAssistedBoss7_1.lua
--@brief    高射炮
--@date     2016/10/18
--@note

--@brief    消息数据表
BattleMsgAssistedBoss7_1 = {
    m_sName = "BattleMsgAssistedBoss7_1.lua",
    m_tSkillShowMsg = nil,      --调用者（BattleMsgShow）
    m_tTargetList = nil,
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgAssistedBoss7_1:init()
    WZLog("BattleMsgAssistedBoss7_1:init")
   
    self.m_nStep = 1
    self.m_bShootEnd = false
    self.m_tBulletList = {}
    self.m_tStepList = {}
    self.m_tTargetPos = BattleCommon:getPointTable(1500,1800)
    local monsterPos = self:getOwnerPos()
    self.m_tStartPos = BattleCommon:getPointTable(monsterPos.x - 80,monsterPos.y + 300)
    self.m_tStepPos = BattleCommon:getPointTable((self.m_tTargetPos.x - monsterPos.x)/15,(self.m_tTargetPos.y - monsterPos.y)/15)

    self.m_nStartY = 1800
    self.m_nEndY = 600
    self.m_tStartPosList = {BattleCommon:getPointTable(700,self.m_nStartY),BattleCommon:getPointTable(900,self.m_nStartY),BattleCommon:getPointTable(1100,self.m_nStartY),BattleCommon:getPointTable(1300,self.m_nStartY),BattleCommon:getPointTable(1500,self.m_nStartY)}
    self.m_tEndPosList = {BattleCommon:getPointTable(500,self.m_nEndY),BattleCommon:getPointTable(700,self.m_nEndY),BattleCommon:getPointTable(900,self.m_nEndY),BattleCommon:getPointTable(1100,self.m_nEndY),BattleCommon:getPointTable(1300,self.m_nEndY)}
    self.m_tStepPosList = {}
    for i = 1,5 do
        local startPos = self.m_tStartPosList[i]
        local endPos = self.m_tEndPosList[i]
        local stepPos = BattleCommon:getPointTable((endPos.x - startPos.x)/20,(endPos.y - startPos.y)/20)
        table.insert(self.m_tStepPosList,stepPos)
        WZLog("BattleMsgAssistedBoss7_1:init",stepPos.x,stepPos.y)
    end
    self:initStep()
    self:playOwnerAnim("flak_1",false)
    self.m_nDelayTime = 0
end

function BattleMsgAssistedBoss7_1:initStep()
    table.insert(self.m_tStepList,{self.flakReadyShoot})
    table.insert(self.m_tStepList,{self.waitForAction})
    table.insert(self.m_tStepList,{self.flakShoot})
    table.insert(self.m_tStepList,{self.waitForAction})
    table.insert(self.m_tStepList,{self.flakShoot})
    table.insert(self.m_tStepList,{self.waitForAction})
    table.insert(self.m_tStepList,{self.flakShoot})
    table.insert(self.m_tStepList,{self.waitForAction})
    table.insert(self.m_tStepList,{self.flakShoot})
    table.insert(self.m_tStepList,{self.waitForAction})
    table.insert(self.m_tStepList,{self.flakShoot})
    table.insert(self.m_tStepList,{self.cameraMove})
    table.insert(self.m_tStepList,{self.shootEnd})
end

function BattleMsgAssistedBoss7_1:shootEnd()
    self.m_bShootEnd = true
end

function BattleMsgAssistedBoss7_1:waitForAction()
   local monster = self:getOwner()
    -- WZLog("BattleMsgSkillShow:playAnimation",hero:getAnimation():isPlaying(hero:getAnimationName("standby")),hero:getAnimation():isCurrentAnimationDone())
    if monster:getAnimation():isPlaying(monster:getAnimationName("standby")) or monster:getAnimation():isCurrentAnimationDone() == true then
        return true
    end
    return false
end

function BattleMsgAssistedBoss7_1:flakReadyShoot()
    self:playOwnerAnim("flak_1",false)
end

function BattleMsgAssistedBoss7_1:flakShoot()
    self:playOwnerAnim("flak_2",false)
    self:buildBullet()
end


function BattleMsgAssistedBoss7_1:buildBullet()
    WZLog("BattleMsgAssistedBoss7_1:buildBullet")
    local backFire = CCParticleSystemQuad:create("battle/particle/skill_baozha_tuowei_feidan.plist")
    backFire:setDuration(kCCParticleDurationInfinity)
    backFire:retain()
    backFire:setPositionType(kCCPositionTypeRelative)
    backFire:setAutoRemoveOnFinish(true)
    backFire:setPosition(GlobalMethod:ccp(self.m_tStartPos.x,self.m_tStartPos.y))

    local particle = CCParticleBatchNode:createWithTexture(backFire:getTexture())
    particle:addChild(backFire)
    SceneBattle:getFrontLayer():addChild(particle)
    --backFire:release()

    local anim = BattleAnimation:createAnimation("boss_bullet_1008", true)
    anim:setPosition(self.m_tStartPos)
    anim:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    SceneBattle:getFrontLayer():addChild(anim:getAnimNode())

    local bullet = {}
    bullet.anim = anim
    bullet.backFire = backFire
    bullet.particle = particle
    bullet.pos = self.m_tStartPos
    bullet.downCount = #self.m_tBulletList * 10
    table.insert(self.m_tBulletList,bullet)

    SoundManager:playEffectSound(SoundDefine.E_S_SHOOT_1)
end

function BattleMsgAssistedBoss7_1:moveBullet(bullet,curPos)
    local prePos = bullet.pos
    local angle = BattleCommon:pointToAngle({x=curPos.x-prePos.x,y=curPos.y-prePos.y})
    local degress = -1*BattleCommon:radiansToDegress(angle)

    if angle and angle ~= 0 and degress and math.abs(degress) ~= 0 then
        if bullet.degress ~= degress then
            bullet.anim:setRotate(degress)
        end
    end
    bullet.anim:setPosition(curPos)
    -- WZLog("BattleMsgAssistedBoss7_1:moveBullet",tostring(bullet.backFire),tolua.type(bullet.backFire),tostring(curPos))
    bullet.backFire:setPosition(GlobalMethod:ccp(curPos.x,curPos.y))
    bullet.pos = curPos
    bullet.degress = degress
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgAssistedBoss7_1:process(dt)
    if #self.m_tStepList > 0 then
        local res = self.m_tStepList[1][1](self,self.m_tStepList[1][2],self.m_tStepList[1][3],self.m_tStepList[1][4])
        if res == true or res == nil then
            table.remove(self.m_tStepList,1)
        end
    end
    if self.m_nStep == 1 and #self.m_tBulletList > 0 then
        self:updateUpBullet()
    end
    if self.m_nStep == 2 and #self.m_tBulletList > 0 then
        self:updateDownBullet()
    end
    local isSpring = self:updateScene()

    if #self.m_tStepList > 0 or #self.m_tBulletList > 0 or isSpring then
        return false
    end
    return true
end

function BattleMsgAssistedBoss7_1:updateUpBullet()
    local actionDoneNum = 0
    for i,bullet in pairs(self.m_tBulletList) do
        if not  bullet.actionDone then
            actionDoneNum = actionDoneNum + 1
            if bullet.pos.x < self.m_tTargetPos.x and bullet.pos.y > self.m_tTargetPos.y then
                bullet.actionDone = true
            else
                local curPos = bullet.pos
                local tPos = BattleCommon:getPointTable(curPos.x + self.m_tStepPos.x,curPos.y + self.m_tStepPos.y)
                self:moveBullet(bullet,tPos)
            end
        end
    end
    if actionDoneNum == 0 and self.m_bShootEnd then
        self.m_nStep = 2
        for i = 1,#self.m_tBulletList do
            local bullet = self.m_tBulletList[i]
            local pos = BattleCommon:getPointTable(self.m_tStartPosList[i].x,self.m_tStartPosList[i].y)
            bullet.index = i
            bullet.stepPos = BattleCommon:getPointTable(self.m_tStepPosList[i].x,self.m_tStepPosList[i].y)
            self:moveBullet(bullet,pos)
            WZLog("BattleMsgAssistedBoss7_1:updateUpBullet",bullet.index,pos.x,pos.y)
        end
    end
end

function BattleMsgAssistedBoss7_1:updateDownBullet()
    for i = #self.m_tBulletList,1,-1 do
        local bullet = self.m_tBulletList[i]
        if not bullet.canDown then
            bullet.downCount = bullet.downCount - 1
            if bullet.downCount < 0 then
                bullet.canDown = true
            end
            WZLog("BattleMsgAssistedBoss7_1:updateDownBullet",bullet.index,bullet.pos.x,bullet.pos.y)
        else
            local curPos = bullet.pos
            local stepPos = bullet.stepPos
            local tPos = BattleCommon:getPointTable(curPos.x + stepPos.x,curPos.y + stepPos.y)
            self:moveBullet(bullet,tPos)
            if self:checkCollision(curPos) then
                self:removeBullet(i)
            end
        end
    end
end

function BattleMsgAssistedBoss7_1:checkCollision(pos)
    local list = WBattleGlobal:getCurrent():getCharacterList(true)
    for i,v in pairs(list) do
        local tPos = v:getPosition()
        if BattleCommon:pointDis(pos,tPos) < 50 or pos.y < self.m_nEndY then
            return true
        end
    end

    return false
end

function BattleMsgAssistedBoss7_1:removeBullet(index)
    local bullet = self.m_tBulletList[index]
    if bullet then

        local effect  = BattleEffect:createAnimation(1014)
        local pos =  bullet.pos 
        effect:setPosition(pos)
        SceneBattle:getFrontLayer():addChild(effect:getAnimNode(),10)
        self:setSceneSpring(pos)
        
        bullet.anim:getAnimNode():removeFromParentAndCleanup(true)
        bullet.particle:removeFromParentAndCleanup(true)
        bullet.backFire:release()
        bullet = nil
        self:makeHurt(pos)
        table.remove(self.m_tBulletList,index)
        SoundManager:playEffectSound(SoundDefine.E_S_EXPLODE)
        -- table.remove(self.m_tStepList,index)
    end
end

function BattleMsgAssistedBoss7_1:makeHurt(pos)
    local targetList = {}
    local list = WBattleGlobal:getCurrent():getCharacterList()
    for i,target in pairs(list) do
        if not target:isDead() and BattleCommon:pointDis(pos,target:getPosition()) < 200 then
            table.insert(targetList,target)
        end
    end
    BattleMethod:waitForSkillHurt(self:getOwner(),targetList)
end

--@brief    更新屏幕(主要是屏幕震动)
function BattleMsgAssistedBoss7_1:updateScene()
    if self.m_tScreenSpring ~= nil then
        if BattleScreen:screenSpring() == true then
            self.m_tScreenSpring = nil
        end
        return true
    end
    return false
end

--@brief    设置屏幕震动
--@param    tPos:震动时的位置
function BattleMsgAssistedBoss7_1:setSceneSpring(tPos)
    if self.m_tScreenSpring then
        return
    end
    self.m_tScreenSpring = {x=tPos.x,y=tPos.y}
    BattleScreen:setSpring(self.m_tScreenSpring)
end

function BattleMsgAssistedBoss7_1:cameraMove()
    return BattleScreen:followHero(BattleCommon:getPointTable(880,900))
end

function BattleMsgAssistedBoss7_1:playOwnerAnim(animName,isLoop)
    local monster = self:getOwner()
    monster:play(monster:getAnimationName(animName), isLoop)
end

--@brief 镜头控制
function BattleMsgAssistedBoss7_1:isCanCtrlCamera()
    return self.m_tSkillShowMsg:isCanCtrlCamera()
end

--@brief 获得技能所有者
function BattleMsgAssistedBoss7_1:getOwner()
    return self.m_tSkillShowMsg.m_tOwner
end

--@brief 获得owner坐标
function BattleMsgAssistedBoss7_1:getOwnerPos()
    return self.m_tSkillShowMsg.m_tOwner:getPosition()
end

--@brief 获得目标列表
function BattleMsgAssistedBoss7_1:getMsgTargetList()
    return self.m_tSkillShowMsg.m_tTargetList
end

--@brief 添加表演
function BattleMsgAssistedBoss7_1:msgDoAction(config)
    self.m_tSkillShowMsg:doAction(config,config.isWait)
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgAssistedBoss7_1:done()
    WZLog("BattleMsgAssistedBoss7_1:done")
    --删除粒子
    if self.particle1 then
        self.particle1:removeFromParentAndCleanup(true)
        self.particle1 = nil
    end
  
    self.m_tSkillShowMsg:reduceWait(BattleSkillType.CREATE_ASSISTED_MSG)
end

-------------------------------------私有方法模块--------------------------------------
