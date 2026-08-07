-- BattleMsgAssistedSkinBigSkill2.lua
--@brief    高射炮
--@date     2016/10/18
--@note

--@brief    消息数据表
BattleMsgAssistedSkinBigSkill2 = {
    m_sName = "BattleMsgAssistedSkinBigSkill2",
    m_tSkillShowMsg = nil,      --调用者（BattleMsgShow）
    m_tTargetPos = nil,
    m_tSpatterTargetList = nil,         --敌人列表
    m_sSkinMark = "0082", 
    m_nScatterNum = 6, 
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgAssistedSkinBigSkill2:init()
    WZLog("BattleMsgAssistedSkinBigSkill2:init")
   
    self.m_tBulletList = {}
    self.m_tStepList = {}
    local skinBigSkill = self:getOwner():getSkinBigSkill()
    local tempShapeData = WBattleGlobal:getCurrent():getSkinBigSkillShape(skinBigSkill)
    if tempShapeData then 
        self.m_sSkinMark = tostring(tempShapeData.bullet)
    end

    self.m_nScatterNum = self.m_tSkillShowMsg.m_nScatterNum

    --打击位置
    self.m_tTargetPos = {}
    self:getOwner().m_tSpatterPosList = {} --用来设置火焰弹
    for i=1,#self.m_tSpatterTargetList do
        if not self.m_tSpatterTargetList[i]:isDead() and self.m_tSpatterTargetList[i]:getHp() ~= 0 and not WBattleGlobal:getCurrent():isSameTeam(self:getOwner():getBattleId(),self.m_tSpatterTargetList[i]:getBattleId()) then
            table.insert(self.m_tTargetPos,self.m_tSpatterTargetList[i]:getPosition())
            table.insert(self:getOwner().m_tSpatterPosList, {x=self.m_tSpatterTargetList[i]:getPosition().x, y=self.m_tSpatterTargetList[i]:getPosition().y})
        end
    end

    self:initStep()
    self.m_nDelayTime = 0
    self.m_nShootCount = 0
    self.m_nShootDelay = 8 
end

function BattleMsgAssistedSkinBigSkill2:initStep()
    table.insert(self.m_tStepList,{self.cameraMove})
    table.insert(self.m_tStepList,{self.initBulletData})
    table.insert(self.m_tStepList,{self.flakShoot})
    table.insert(self.m_tStepList,{self.playEndShootAni})
end

function BattleMsgAssistedSkinBigSkill2:initBulletData()
    for i=1,#self.m_tTargetPos do
        self.m_tTargetPos[i] = BattleCommon:getPointTable(self.m_tTargetPos[i].x, self.m_tTargetPos[i].y + 40)
    end
    self.m_tParaDataList = self.m_tTargetPos

    self.m_tStartPos = self.m_tActiveAttackPos
    local bIsFlipX = self:getOwner().m_bExplodeFlipX
    if bIsFlipX then
        self.m_tStartPos = {x=self.m_tActiveAttackPos.x + 200,y=self.m_tActiveAttackPos.y+50}
    else
        self.m_tStartPos = {x=self.m_tActiveAttackPos.x - 200,y=self.m_tActiveAttackPos.y+50}
    end
    self:getOwner().m_bExplodeFlipX = nil

    self.m_nSpeed = 30
end


function BattleMsgAssistedSkinBigSkill2:flakShoot()
    if self.m_nShootDelay < 8 then
        self.m_nShootDelay = self.m_nShootDelay + 1
        return false
    end
    self.m_nShootDelay = 0

    for i=1,#self.m_tParaDataList do
        self.m_nShootCount = self.m_nShootCount + 1
        self:buildBullet()
    end
    return true
end


function BattleMsgAssistedSkinBigSkill2:buildBullet()
    WZLog("BattleMsgAssistedSkinBigSkill2:buildBullet")
    local backFire = CCParticleSystemQuad:create("battle/particle/boss_bullet_" .. self.m_sSkinMark .. "_tuowei.plist")
    backFire:setDuration(kCCParticleDurationInfinity)
    backFire:retain()
    backFire:setPositionType(kCCPositionTypeRelative)
    backFire:setAutoRemoveOnFinish(true)
    backFire:setPosition(GlobalMethod:ccp(self.m_tStartPos.x,self.m_tStartPos.y))

    local particle = CCParticleBatchNode:createWithTexture(backFire:getTexture())
    particle:addChild(backFire)
    SceneBattle:getFrontLayer():addChild(particle,10)
    --backFire:release()

    local anim = BattleAnimation:createAnimation("boss_bullet_" .. self.m_sSkinMark, true)
    anim:setPosition(self.m_tStartPos)
    anim:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    SceneBattle:getFrontLayer():addChild(anim:getAnimNode(),10)
    anim:setFlipX(true)
    if not self:getOwner().m_bIsFilpX then
        anim:setFlipY(true)
    end

    if self:getOwner():isHide() == true then
        local isShow = false
        if WBattleGlobal:getCurrent():isReplayGame() or WBattleGlobal:getCurrent():isMyTeam(self:getOwner():getBattleId()) then
            isShow = true
        end
        --在反隐范围内(玩家自己)
        local myHero = WBattleGlobal:getCurrent():getMyHero()
        if myHero.m_nHideViewDis and BattleCommon:pointDis(self:getOwner():getPosition(), myHero:getPosition()) <= myHero.m_nHideViewDis then
            isShow = true
        end
        if isShow then
            anim:getAnimNode():setOpacity(128)
        else
            backFire:setVisible(false)
            anim:getAnimNode():setOpacity(0)
        end
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

function BattleMsgAssistedSkinBigSkill2:moveBullet(bullet,curPos)
    local prePos = bullet.pos
    local angle = BattleCommon:pointToAngle({x=curPos.x-prePos.x,y=curPos.y-prePos.y})
    local degress = -1*BattleCommon:radiansToDegress(angle)

    if angle and angle ~= 0 and degress and math.abs(degress) ~= 0 then
        if bullet.degress ~= degress then
            bullet.anim:setRotate(degress)
        end
    end
    bullet.anim:setPosition(curPos)
    -- WZLog("BattleMsgAssistedSkinBigSkill2:moveBullet",tostring(bullet.backFire),tolua.type(bullet.backFire),tostring(curPos))
    bullet.backFire:setPosition(GlobalMethod:ccp(curPos.x,curPos.y))
    bullet.pos = curPos
    bullet.degress = degress
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgAssistedSkinBigSkill2:process(dt)
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

function BattleMsgAssistedSkinBigSkill2:updateBullet()
    for i = #self.m_tBulletList,1,-1 do
        local bullet = self.m_tBulletList[i]
        local curPos = bullet.pos
        local targetPos = self.m_tTargetPos[i]


        -- if math.abs(targetPos.x - curPos.x) <= self.m_nSpeed then
        --     self:removeBullet(i)
        --     break
        -- end

        -- 下一个位置
        local vec2 = BattleCommon:pointSub(targetPos,curPos)
        local radian = BattleCommon:pointToAngle(vec2)

        local tx = curPos.x + math.cos(radian) * self.m_nSpeed
        local ty = curPos.y + math.sin(radian) * self.m_nSpeed

        local tPos = BattleCommon:getPointTable(tx,ty)
        self:moveBullet(bullet,tPos)
        if self:checkCollision(curPos,targetPos,i) then
            self:removeBullet(i)
        end
    end
end

function BattleMsgAssistedSkinBigSkill2:checkCollision(sPos,ePos,bulletIndex)
    if BattleCommon:pointDis(sPos,ePos) < self.m_nSpeed then

        WZLog("BattleMsgAssistedSkinBigSkill2:checkCollision" )
        local hero = self:getOwner()
        if hero.m_tSkillTakeEffectCollionInfo2 ~= nil then

            hero.m_bActiveAttack2 = true

            local info = hero.m_tSkillTakeEffectCollionInfo2

            local bClear = true
            local tSkillInfo = GDatatab_skill["id_"..hero.m_tSkillTakeEffectCollionInfo2]
            local tEffectInfo = GDatatab_effect["id_"..tSkillInfo.effect_id[1][1]]
            for i=1,#tEffectInfo.effect do
                if tEffectInfo.effect[i][1] == TakeEffectType.COLLISION_TWO then
                    bClear = false
                    break
                end
            end
            if bClear then
                hero.m_tSkillTakeEffectCollionInfo2 = nil
            end

            local param1 = self.m_tBulletList[bulletIndex].index
            WBattleGlobal:getCurrent():setDoEffectAfterAttack(true,"shoot-1")
            WMonsterAI:castSkill(nil,
                nil,
                nil,
                {[1]=SkillTypeConfig.EFFECT},
                nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,nil,nil,nil,nil,nil,
                nil,
                nil,
                nil,nil,
                nil,nil,nil,nil,
                nil,
                nil,
                info, TakeEffectType.COLLISION_TWO,
                nil,
                nil,
                nil,
                nil,
                nil,
                nil,
                nil,
                param1
                )
        end


        return true
    end

    -- local list = WBattleGlobal:getCurrent():getCharacterList(true)
    -- for i,v in pairs(list) do
    --     local tPos = v:getPosition()
    --     if BattleCommon:pointDis(pos,tPos) < 50 or  BattleCommon:pointDis(pos,self.m_tTargetPos) < self.m_nSpeed then
    --     if BattleCommon:pointDis(pos,tPos) < 50 or  BattleCommon:pointDis(pos,self.m_tTargetPos) < self.m_nSpeed then
    --         return true
    --     end
    -- end

    return false
end

function BattleMsgAssistedSkinBigSkill2:removeBullet(index)
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

        --移除目标点
        table.remove(self.m_tTargetPos,index)
    end
end

function BattleMsgAssistedSkinBigSkill2:makeHurt(pos)
    local targetList = {}
    local list = WBattleGlobal:getCurrent():getCharacterList()
    for i,target in pairs(list) do
        local raduis = self:getExplodeRadius()
        local charaPos = target:getCenterPos()
        
        local collisionRang = target:getCollisionRang()
        if target:getType() ~= 0 and collisionRang ~= nil then
            charaPos = target:getPosition()
        end

        charaPos = Vector2:create(charaPos.x,charaPos.y)
        local charaRaidus = target:getRadiusForHurt()
        local collisionRang = target:getCollisionRang()
        --伤害判断
        local isColl, dis = self:checkCollisionWithRang(pos,raduis,charaPos,charaRaidus,collisionRang)
        local bOffHurt = target.m_bOffHurt or target:isInBuffState(EffectTypeConfig.IMMUNITY_ATTACK)
        if not target:isDead() and not bOffHurt and isColl then
            WZLog("BattleMsgAssistedSkinBigSkill2:makeHurt one", target:getBattleId())
            table.insert(targetList,target)
        end
    end
    WZLog("BattleMsgAssistedSkinBigSkill2:makeHurt", #targetList)
    BattleMethod:waitForSkillHurt(self:getOwner(), targetList)
end

--@brief    更新屏幕(主要是屏幕震动)
function BattleMsgAssistedSkinBigSkill2:updateScene()
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
function BattleMsgAssistedSkinBigSkill2:setSceneSpring(tPos)
    if self.m_tScreenSpring then
        return
    end
    self.m_tScreenSpring = {x=tPos.x,y=tPos.y}
    BattleScreen:setSpring(self.m_tScreenSpring)
end

function BattleMsgAssistedSkinBigSkill2:cameraMove()
    if self:getOwner():isHide() == true then
        return
    end
    return --BattleScreen:followHero(self:getOwnerPos())
end

--@brief 镜头控制
function BattleMsgAssistedSkinBigSkill2:isCanCtrlCamera()
    return self.m_tSkillShowMsg:isCanCtrlCamera()
end

--@brief 获得技能所有者
function BattleMsgAssistedSkinBigSkill2:getOwner()
    return self.m_tSkillShowMsg.m_tOwner
end

--@brief 获得owner坐标
function BattleMsgAssistedSkinBigSkill2:getOwnerPos()
    return self.m_tSkillShowMsg.m_tOwner:getPosition()
end

--@brief 获得目标列表
function BattleMsgAssistedSkinBigSkill2:getMsgTargetList()
    return self.m_tSkillShowMsg.m_tTargetList
end

--@brief 添加表演
function BattleMsgAssistedSkinBigSkill2:msgDoAction(config)
    self.m_tSkillShowMsg:doAction(config,config.isWait)
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgAssistedSkinBigSkill2:done()
    WZLog("BattleMsgAssistedSkinBigSkill2:done")
    for i = #self.m_tBulletList,1,-1 do
        self:removeBullet(i)
    end
  
    self.m_tSkillShowMsg:reduceWait(BattleSkillType.CREATE_ASSISTED_MSG)
end

--@brief    播放完成涉及动画
function BattleMsgAssistedSkinBigSkill2:playEndShootAni()
    -- body
    self:getOwner():getSkinBigSkillAnimation():play("attack_3", false)
    return true
end

--@brief    检查区域碰撞
--@param    rang:区域
--@param    isOnlyCheck:只检查圆与矩形相交
--@return   #1:true:撞了,false:没撞
function BattleMsgAssistedSkinBigSkill2:checkCollisionWithRang(pos,raduis,charaPos,charaRaidus,collisionRang)
    local dis = nil
    if collisionRang ~= nil then
        for i,rang in pairs(collisionRang) do
            if rang.m_nType == 0 then
                local isColl = BattleCommon:checkCircleCollosion(pos,raduis,charaPos,charaRaidus)
                WZLog("BattleMsgAssistedSkinBigSkill2:checkCollisionWithRang one", i, tostring(isColl), pos.x, pos.y, charaPos.x, charaPos.y, raduis, charaRaidus)
                if isColl then
                    return true, dis
                end
            elseif rang.m_nType == 1 then
                local rect = {x = charaPos.x+rang.m_fXOffset - rang.m_fWidth*0.5,y = charaPos.y+rang.m_fYOffset,w = rang.m_fWidth,h=rang.m_fHeight}
                local circle = {x = pos.x,y=pos.y,r = raduis}
                local curdis = WBullet:distanceWithCircleAndRect(circle,rect)
                dis = 9999
                dis = math.min(curdis, dis)
                WZLog("BattleMsgAssistedSkinBigSkill2:checkCollisionWithRang two", i, curdis, dis,raduis)
                if dis <= raduis then
                   return true, dis
                end
            end
        end
    else
        local isColl = BattleCommon:checkCircleCollosion(pos,raduis,charaPos,charaRaidus)
        WZLog("BattleMsgAssistedSkinBigSkill2:checkCollisionWithRang three", tostring(isColl), dis)
        return isColl, dis
    end

    WZLog("BattleMsgAssistedSkinBigSkill2:checkCollisionWithRang four")
    return false, dis
end

--@brief    获取爆破半径
--@return   #1:爆破半径
function BattleMsgAssistedSkinBigSkill2:getExplodeRadius()
    return self:getOwner():getRadiusForBulletExplode()
end
-------------------------------------私有方法模块--------------------------------------
