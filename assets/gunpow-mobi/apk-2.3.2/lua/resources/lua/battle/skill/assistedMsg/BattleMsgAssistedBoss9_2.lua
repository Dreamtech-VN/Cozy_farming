-- BattleMsgAssistedBoss9_2.lua
--@brief    高射炮
--@date     2016/10/18
--@note

--@brief    消息数据表
BattleMsgAssistedBoss9_2 = {
    m_sName = "BattleMsgAssistedBoss9_2.lua",
    m_tSkillShowMsg = nil,      --调用者（BattleMsgShow）
    m_tTargetList = nil,
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgAssistedBoss9_2:init()
    WZLog("BattleMsgAssistedBoss9_2:init")
   
    self.m_bShootEnd = false
    self.m_tBulletList = {}
    self.m_tStepList = {}
    
    
    local hero = self:getMsgTargetList()[1] or WMonster:getRandomPlayer()
    local heroPos = hero:getPosition()
    self.m_tTargetPos = BattleCommon:getPointTable(heroPos.x,heroPos.y)
    
    self:initStep()
    self.m_nDelayTime = 0
    self.m_nShootCount = 0
    self.m_nShootDelay = 5 
end


function BattleMsgAssistedBoss9_2:initStep()
    table.insert(self.m_tStepList,{self.bossMove})
    table.insert(self.m_tStepList,{self.cameraMove})
    table.insert(self.m_tStepList,{self.initBulletData})
    table.insert(self.m_tStepList,{self.flakReadyShoot})
    table.insert(self.m_tStepList,{self.waitForAction})
    table.insert(self.m_tStepList,{self.flakShoot})
    table.insert(self.m_tStepList,{self.waitForAction})
    table.insert(self.m_tStepList,{self.shootEnd})
end


function BattleMsgAssistedBoss9_2:bossMove()
    local targetPos = GlobalMethod:ccp(self.m_tTargetPos.x,self.m_tTargetPos.y + 100)
    if targetPos.x < BattleMapManager.m_nWidth * 0.5 then
        targetPos.x = targetPos.x + 500
    else
        targetPos.x = targetPos.x - 500
    end
    WZLog("BattleMsgAssistedBoss9_2:bossMove",targetPos.x)
    if not TeachGroup1.ISFIRSTBATTLE then 
        self:getOwner():setPosition(targetPos)
    end
    self:getOwner():adjustDirect(GlobalMethod:ccp(self.m_tTargetPos.x,self.m_tTargetPos.y))
end


function BattleMsgAssistedBoss9_2:initBulletData()
    local offsetX = 90
    if self.m_tTargetPos.x < BattleMapManager.m_nWidth * 0.5 then
        offsetX = offsetX * -1
    end
    local monsterPos = self:getOwnerPos()
    self.m_tStartPos = BattleCommon:getPointTable(monsterPos.x + offsetX,monsterPos.y + 40)
    
    self.m_nSpeed = 15
    self.m_tParaDataList = {}
    for i = 1,6 do
        local paraData = self:getParaData(self.m_tStartPos,self.m_tTargetPos,math.pow(-1,i) * (10 + 60*math.floor(i/2)))
        table.insert(self.m_tParaDataList,paraData)
    end
end


--@brief 初始化运动曲线参数
function BattleMsgAssistedBoss9_2:getParaData(startPos,targetPos,dis)
    WZLog(" BattleMsgAssistedBoss9_2:getParaData",dis)
    local pos = startPos
    local vx = pos.x < targetPos.x and pos.x or targetPos.x
    local vy = pos.y < targetPos.y and pos.y or targetPos.y
    vy = vy + math.abs(targetPos.y - pos.y)
    local dx =  math.abs(targetPos.x - pos.x) * 2/3
    if pos.x > targetPos.x then
        dx = math.abs(targetPos.x - pos.x) * 1/3
    end

    local vertexPt = BattleCommon:getPointTable(vx + dx,vy + dis)
  
    local x1 = pos.x
    local x2 = targetPos.x
    local x3 = vertexPt.x

    local y1 = pos.y
    local y2 = targetPos.y
    local y3 = vertexPt.y

    local coefB = ((y1 - y3) * (x1 * x1 - x2 * x2) - (y1 - y2) * (x1 * x1 - x3 * x3)) / ((x1 - x3) * (x1 * x1 - x2 * x2) - (x1 - x2) * (x1 * x1 - x3 * x3))
    local coefA = ((y1 - y2) - coefB * (x1 - x2)) / (x1 * x1 - x2 * x2)
    local coefC = y1 - coefA * x1 * x1 - coefB * x1

    return {coefA,coefB,coefC}
end

function BattleMsgAssistedBoss9_2:shootEnd()
    self:playOwnerAnim("flak_3",false)
    self.m_bShootEnd = true
end

function BattleMsgAssistedBoss9_2:waitForAction()
   local monster = self:getOwner()
    -- WZLog("BattleMsgSkillShow:playAnimation",hero:getAnimation():isPlaying(hero:getAnimationName("standby")),hero:getAnimation():isCurrentAnimationDone())
    if monster:getAnimation():isPlaying(monster:getAnimationName("standby")) or monster:getAnimation():isCurrentAnimationDone() == true then
        return true
    end
    return false
end

function BattleMsgAssistedBoss9_2:flakReadyShoot()
    self:playOwnerAnim("flak_1",false)
end

function BattleMsgAssistedBoss9_2:flakShoot()
    if self.m_nShootDelay < 5 then
        self.m_nShootDelay = self.m_nShootDelay + 1
        return false
    end
    self.m_nShootDelay = 0
    self:playOwnerAnim("flak_2",false)
    self.m_nShootCount = self.m_nShootCount + 1
    self:buildBullet()
    if self.m_nShootCount >= #self.m_tParaDataList then
        return true
    end
    return false
end


function BattleMsgAssistedBoss9_2:buildBullet()
    WZLog("BattleMsgAssistedBoss9_2:buildBullet")
    local backFire = CCParticleSystemQuad:create("battle/particle/skill_baozha_tuowei_feidan.plist")
    backFire:setDuration(kCCParticleDurationInfinity)
    backFire:retain()
    backFire:setPositionType(kCCPositionTypeRelative)
    backFire:setAutoRemoveOnFinish(true)
    backFire:setPosition(GlobalMethod:ccp(self.m_tStartPos.x,self.m_tStartPos.y))

    local particle = CCParticleBatchNode:createWithTexture(backFire:getTexture())
    particle:addChild(backFire)
    SceneBattle:getFrontLayer():addChild(particle,10)
    --backFire:release()

    local anim = BattleAnimation:createAnimation("boss_bullet_1010", true)
    anim:setPosition(self.m_tStartPos)
    anim:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    SceneBattle:getFrontLayer():addChild(anim:getAnimNode(),10)
    anim:setFlipX(true)
    if not self:getOwner().m_bIsFilpX then
        anim:setFlipY(true)
    end

    local bullet = {}
    bullet.anim = anim
    bullet.backFire = backFire
    bullet.particle = particle
    bullet.pos = self.m_tStartPos
    bullet.index = self.m_nShootCount
    table.insert(self.m_tBulletList,bullet)

    SoundManager:playEffectSound(SoundDefine.E_S_SHOOT_1)
end

function BattleMsgAssistedBoss9_2:moveBullet(bullet,curPos)
    local prePos = bullet.pos
    local angle = BattleCommon:pointToAngle({x=curPos.x-prePos.x,y=curPos.y-prePos.y})
    local degress = -1*BattleCommon:radiansToDegress(angle)

    if angle and angle ~= 0 and degress and math.abs(degress) ~= 0 then
        if bullet.degress ~= degress then
            bullet.anim:setRotate(degress)
        end
    end
    bullet.anim:setPosition(curPos)
    -- WZLog("BattleMsgAssistedBoss9_2:moveBullet",tostring(bullet.backFire),tolua.type(bullet.backFire),tostring(curPos))
    bullet.backFire:setPosition(GlobalMethod:ccp(curPos.x,curPos.y))
    bullet.pos = curPos
    bullet.degress = degress
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgAssistedBoss9_2:process(dt)
    if #self.m_tStepList > 0 then
        local res = self.m_tStepList[1][1](self,self.m_tStepList[1][2],self.m_tStepList[1][3],self.m_tStepList[1][4])
        if res == true or res == nil then
            table.remove(self.m_tStepList,1)
        end
    end
    if #self.m_tBulletList > 0 then
        self:updateBullet()
    end
    
    local isSpring = self:updateScene()

    if #self.m_tStepList > 0 or #self.m_tBulletList > 0 or isSpring then
        return false
    end
    return true
end

function BattleMsgAssistedBoss9_2:updateBullet()
    for i = #self.m_tBulletList,1,-1 do
        local bullet = self.m_tBulletList[i]
        local curPos = bullet.pos
        local targetPos = self.m_tTargetPos

        if math.abs(targetPos.x - curPos.x) <= self.m_nSpeed then
            self:removeBullet(i)
            break
        end
        local tx = curPos.x
        if targetPos.x > curPos.x then
            tx = curPos.x + self.m_nSpeed
        else
            tx = curPos.x - self.m_nSpeed
        end
        local ty = self:getPosY(tx,self.m_tParaDataList[bullet.index])

        local tPos = BattleCommon:getPointTable(tx,ty)
        self:moveBullet(bullet,tPos)
        if self:checkCollision(curPos) then
            self:removeBullet(i)
        end
    end
end

--@brief 获得位移过程 y坐标
function BattleMsgAssistedBoss9_2:getPosY(posX,paraData)
    local posY = paraData[1] * posX * posX + paraData[2] * posX + paraData[3];
    return posY
end

function BattleMsgAssistedBoss9_2:checkCollision(pos)
    local list = WBattleGlobal:getCurrent():getCharacterList(true)
    for i,v in pairs(list) do
        local tPos = v:getPosition()
        if BattleCommon:pointDis(pos,tPos) < 50 or  BattleCommon:pointDis(pos,self.m_tTargetPos) < self.m_nSpeed then
            return true
        end
    end

    return false
end

function BattleMsgAssistedBoss9_2:removeBullet(index)
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

function BattleMsgAssistedBoss9_2:makeHurt(pos)
    local targetList = {}
    local list = WBattleGlobal:getCurrent():getHeroSortList()
    for i,target in pairs(list) do
        if not target:isDead() and BattleCommon:pointDis(pos,target:getPosition()) < 200 then
            table.insert(targetList,target)
        end
    end
    BattleMethod:waitForSkillHurt(self:getOwner(),targetList)
end

--@brief    更新屏幕(主要是屏幕震动)
function BattleMsgAssistedBoss9_2:updateScene()
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
function BattleMsgAssistedBoss9_2:setSceneSpring(tPos)
    if self.m_tScreenSpring then
        return
    end
    self.m_tScreenSpring = {x=tPos.x,y=tPos.y}
    BattleScreen:setSpring(self.m_tScreenSpring)
end

function BattleMsgAssistedBoss9_2:cameraMove()
    if self:getOwner():isHide() == true then
        return
    end
    return BattleScreen:followHero(self:getOwnerPos())
end

function BattleMsgAssistedBoss9_2:playOwnerAnim(animName,isLoop)
    local monster = self:getOwner()
    monster:play(monster:getAnimationName(animName), isLoop)
end

--@brief 镜头控制
function BattleMsgAssistedBoss9_2:isCanCtrlCamera()
    return self.m_tSkillShowMsg:isCanCtrlCamera()
end

--@brief 获得技能所有者
function BattleMsgAssistedBoss9_2:getOwner()
    return self.m_tSkillShowMsg.m_tOwner
end

--@brief 获得owner坐标
function BattleMsgAssistedBoss9_2:getOwnerPos()
    return self.m_tSkillShowMsg.m_tOwner:getPosition()
end

--@brief 获得目标列表
function BattleMsgAssistedBoss9_2:getMsgTargetList()
    return self.m_tSkillShowMsg.m_tTargetList
end

--@brief 添加表演
function BattleMsgAssistedBoss9_2:msgDoAction(config)
    self.m_tSkillShowMsg:doAction(config,config.isWait)
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgAssistedBoss9_2:done()
    WZLog("BattleMsgAssistedBoss9_2:done")
    for i = #self.m_tBulletList,1,-1 do
        self:removeBullet(i)
    end
  
    self.m_tSkillShowMsg:reduceWait(BattleSkillType.CREATE_ASSISTED_MSG)
end

-------------------------------------私有方法模块--------------------------------------
