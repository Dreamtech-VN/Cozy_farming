-- BattleMsgAssistedMountSkill.lua
--@brief    高射炮
--@date     2016/10/18
--@note

--@brief    消息数据表
BattleMsgAssistedMountSkill = {
    m_sName = "BattleMsgAssistedMountSkill",
    m_tOwner = nil,     
    m_tTargetPos = nil,
    m_tParticleTargetPos = nil, 
    m_tStartPos = nil,  --坐骑出生地
    m_nMountId = nil, 
    m_mountAni = nil, 
    m_nMovestepX = nil, 
    m_nMovestepY = nil, 
    m_nSkillId = nil,   --使用的坐骑技能Id
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgAssistedMountSkill:init()
    WZLog("BattleMsgAssistedMountSkill:init")

    self.m_tBulletList = {}
    self.m_tStepList = {}
    local battleSize = SceneBattle:getFrontLayerSize()
    local posX = battleSize.width
    if self.m_tTargetPos.x > battleSize.width/2 then 
        posX = -100
    end

    self.m_tStartPos = {x = posX, y = self.m_tTargetPos.y}
    self.m_mountAni = CreateRunMountNoPlayer(self.m_nMountId, "walk", true)
    self.m_mountAni:setScale(0.6)
    self.m_mountAni:setPosition(self.m_tStartPos)
    self.m_mountAni:play("walk", true)
    SceneBattle:getFrontLayer():addChild(self.m_mountAni:getAnimNode())

    self:initStep()
    self.m_nDelayTime = 0
end


function BattleMsgAssistedMountSkill:initStep()
    table.insert(self.m_tStepList,{self.moveToHero})
    table.insert(self.m_tStepList,{self.becomeToParticle})
    table.insert(self.m_tStepList,{self.flakShoot})
    table.insert(self.m_tStepList,{self.doSkillEffeect})
end

--@brief    召唤坐骑，移动到玩家身边
function BattleMsgAssistedMountSkill:moveToHero()
    -- body
    local stepX
    local stepY
    local addYRate 

    tStartPos = {x = self.m_mountAni:getPosition().x, y = self.m_mountAni:getPosition().y}
    self.m_nCurPositionX = self.m_mountAni:getPosition().x
    self.m_nCurPositionY = self.m_mountAni:getPosition().y

    local ptDis = math.sqrt((tStartPos.y - self.m_tTargetPos.y ) * (tStartPos.y - self.m_tTargetPos.y ) + (tStartPos.x - self.m_tTargetPos.x ) * (tStartPos.x - self.m_tTargetPos.x ))
    if ptDis >= BattleMsgPlayerMoveCtrl.MIN_ENABLEMOVE_DISTANCE then 
        if tStartPos.x < self.m_tTargetPos.x then
            self.m_nMovestepX = 0 
        else
           self. m_nMovestepX = 1 
        end
        if tStartPos.y < self.m_tTargetPos.y then
            self.m_nMovestepY = 0
        else
            self.m_nMovestepY = 1
        end

        addYRate = math.asin((self.m_tTargetPos.y - tStartPos.y) / ptDis)
        WZLog("moveToHero", addYRate)
        self.m_nAddYRate = addYRate

        local speed = 15
        local nCurPositionX, nCurPositionY
        if self.m_nMovestepX == 0 then --向右移动
            nCurPositionX = self.m_nCurPositionX + speed * math.cos(self.m_nAddYRate)
            if self.m_mountAni:isFlipX() == true then
                WZLog("self.m_mountAni:setFlipY(false)")
                self.m_mountAni:setFlipX(false)
            end
        elseif self.m_nMovestepX == 1 then --向左移动
            nCurPositionX = self.m_nCurPositionX - speed * math.cos(self.m_nAddYRate)
            if self.m_mountAni:isFlipX() == false then
                WZLog("self.m_mountAni:setFlipY(true)")
                self.m_mountAni:setFlipX(true)
            end
        end

        nCurPositionY = self.m_nCurPositionY + speed * math.sin(self.m_nAddYRate)

        self.m_mountAni:setPosition(Vector2:create(nCurPositionX, nCurPositionY))
        return false 
    else
        self.m_mountAni:play("wait", true)
        return true 
    end
end

--@brief    坐骑变成特效
function BattleMsgAssistedMountSkill:becomeToParticle()
    -- body
    self.m_nShootCount = 0
    local effectId = GDatatab_skill["id_" .. self.m_nSkillId].effect_id[1][1]
    local effectData = GDatatab_effect["id_" .. effectId]
    local takeType = effectData.effect[1][1]
    local effectParm = effectData.effect[1][2]
    WZLog("BattleMsgAssistedMountSkill:becomeToParticle", self.m_nSkillId, Serialize(effectData))
    local tTarget = self:_chooseEffectTarget(takeType,effectParm)
    self.m_tParticleTargetPos = {}
    local offsetX = 90
    if self.m_tTargetPos.x > BattleMapManager.m_nWidth * 0.5 then
        offsetX = offsetX * -1
    end
    local monsterPos = self.m_mountAni:getPosition()
    self.m_tStartPos = BattleCommon:getPointTable(monsterPos.x + offsetX,monsterPos.y + 40)
    local ownPos = self.m_tOwner:getCenterPos()
    local needTimes = 16

    if effectParm == EffectTargetType.CUR_BATTLE then
        self.m_nScatterNum = 1
        local pos = WndBattleHud:getWindPos()
        local speed = math.floor(math.abs(pos.x - self.m_tStartPos.x)/needTimes)
        self.m_tParticleTargetPos[1] = {x = pos.x, y = pos.y, speed = speed}
    else
        self.m_nScatterNum = #tTarget
        for i, hero in pairs(tTarget) do
            local pos = hero:getCenterPos()
            local speed = math.floor(math.abs(pos.x - self.m_tStartPos.x)/needTimes)
            self.m_tParticleTargetPos[i] = {x = pos.x, y = pos.y, speed = speed}
        end
    end


    self:initBulletData()
    self.m_mountAni:getAnimNode():removeFromParentAndCleanup(true)
    self.m_mountAni = nil
end

--@brief    获取一个随机的英雄
--@brief    选择目标
--@param 触发类型 
function BattleMsgAssistedMountSkill:_chooseEffectTarget(takeType,effectParm)
    local chooseTargetType = effectParm
    self.m_tTargetHeroList = {}

    if chooseTargetType == EffectTargetType.MYSELF then
        table.insert(self.m_tTargetHeroList, self.m_tOwner)
    end

    --区分命中目标
    local tHeroList = WBattleGlobal:getCurrent():getCharacterList()

    for i, chara in pairs(tHeroList) do
        local isMacth = false
        local battleId = self.m_tOwner:getBattleId()
        local tBattleId = chara:getBattleId()
        if chooseTargetType == EffectTargetType.HIT_ROLE then
            isMacth = true
        elseif chooseTargetType== EffectTargetType.MYTEAM then
            if chara:getHp() > 0 and not chara:isDead() and WBattleGlobal:getCurrent():isSameTeam(battleId,tBattleId) then
                isMacth = true
            end
        elseif chooseTargetType == EffectTargetType.ENEMY then
            if chara:getHp() > 0 and not chara:isDead() and not WBattleGlobal:getCurrent():isSameTeam(battleId,tBattleId) then
                isMacth = true
            end
        end
        if isMacth then
            table.insert(self.m_tTargetHeroList,chara)
        end
    end
   
    WZLog("BattleMsgAssistedMountSkill:_chooseEffectTarget", effectParm,#self.m_tTargetHeroList)
    return self.m_tTargetHeroList
end

function BattleMsgAssistedMountSkill:initBulletData()
    self.m_tParaDataList = {}
    for i = 1, #self.m_tParticleTargetPos do
        local paraData = self:getParaData(self.m_tStartPos,self.m_tParticleTargetPos[i],math.pow(-1,i) * (10 + 60*math.floor(i/2)))
        table.insert(self.m_tParaDataList,paraData)
    end
end


--@brief 初始化运动曲线参数
function BattleMsgAssistedMountSkill:getParaData(startPos,targetPos,dis)
    WZLog(" BattleMsgAssistedMountSkill:getParaData",dis)
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

function BattleMsgAssistedMountSkill:flakShoot()
    self.m_nShootCount = self.m_nShootCount + 1
    self:buildBullet(self.m_tParticleTargetPos[self.m_nShootCount])
    if self.m_nShootCount >= #self.m_tParaDataList then
        return true
    end
    return false
end


function BattleMsgAssistedMountSkill:buildBullet(targetPos)
    WZLog("BattleMsgAssistedMountSkill:buildBullet")
    local backFire = CCParticleSystemQuad:create("battle/particle/boss_bullet_0086_tuowei.plist")
    backFire:setDuration(kCCParticleDurationInfinity)
    backFire:retain()
    backFire:setPositionType(kCCPositionTypeRelative)
    backFire:setAutoRemoveOnFinish(true)
    backFire:setPosition(GlobalMethod:ccp(self.m_tStartPos.x,self.m_tStartPos.y))

    local particle = CCParticleBatchNode:createWithTexture(backFire:getTexture())
    particle:addChild(backFire)
    SceneBattle:getFrontLayer():addChild(particle,10)
    --backFire:release()

    local anim = BattleAnimation:createAnimation("boss_bullet_0086", true)
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
        end
    end
    anim:getAnimNode():setOpacity(0)

    local bullet = {}
    bullet.anim = anim
    bullet.backFire = backFire
    bullet.particle = particle
    bullet.pos = self.m_tStartPos
    bullet.index = self.m_nShootCount
    bullet.targetPos = targetPos
    table.insert(self.m_tBulletList,bullet)

    SoundManager:playEffectSound(SoundDefine.E_S_SHOOT_1)
end

function BattleMsgAssistedMountSkill:moveBullet(bullet,curPos)
    local prePos = bullet.pos
    local angle = BattleCommon:pointToAngle({x=curPos.x-prePos.x,y=curPos.y-prePos.y})
    local degress = -1*BattleCommon:radiansToDegress(angle)

    if angle and angle ~= 0 and degress and math.abs(degress) ~= 0 then
        if bullet.degress ~= degress then
            bullet.anim:setRotate(degress)
        end
    end
    bullet.anim:setPosition(curPos)
    bullet.backFire:setPosition(GlobalMethod:ccp(curPos.x,curPos.y))
    bullet.pos = curPos
    bullet.degress = degress
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgAssistedMountSkill:process(dt)
    if #self.m_tStepList > 0 then
        local res = self.m_tStepList[1][1](self,self.m_tStepList[1][2],self.m_tStepList[1][3],self.m_tStepList[1][4])
        if res == true or res == nil then
            table.remove(self.m_tStepList,1)
        end
    end
    if #self.m_tBulletList > 0 then
        self:updateBullet()
    end

    if #self.m_tStepList > 0 or #self.m_tBulletList > 0 then
        return false
    end
    return true
end

function BattleMsgAssistedMountSkill:updateBullet()
    for i = #self.m_tBulletList,1,-1 do
        local bullet = self.m_tBulletList[i]
        local curPos = bullet.pos
        local targetPos = bullet.targetPos

        if math.abs(targetPos.x - curPos.x) <= targetPos.speed then
            self:removeBullet(i)
            break
        end
        local tx = curPos.x
        if targetPos.x > curPos.x then
            tx = curPos.x + targetPos.speed
        else
            tx = curPos.x - targetPos.speed
        end
        local ty = self:getPosY(tx,self.m_tParaDataList[bullet.index])

        local tPos = BattleCommon:getPointTable(tx,ty)
        self:moveBullet(bullet,tPos)
        if self:checkCollision(curPos, targetPos) then
            self:removeBullet(i)
        end
    end
end

--@brief 获得位移过程 y坐标
function BattleMsgAssistedMountSkill:getPosY(posX,paraData)
    local posY = paraData[1] * posX * posX + paraData[2] * posX + paraData[3];
    return posY
end

function BattleMsgAssistedMountSkill:checkCollision(pos, targetPos)
    if BattleCommon:pointDis(pos, targetPos) < targetPos.speed then
        return true
    end

    return false
end

function BattleMsgAssistedMountSkill:removeBullet(index)
    local bullet = self.m_tBulletList[index]
    if bullet then
        -- local effect  = BattleEffect:createAnimation(1014)
        -- local pos =  bullet.pos 
        -- effect:setPosition(pos)
        -- SceneBattle:getFrontLayer():addChild(effect:getAnimNode(),10)
        
        bullet.anim:getAnimNode():removeFromParentAndCleanup(true)
        bullet.particle:removeFromParentAndCleanup(true)
        bullet.backFire:release()
        bullet = nil
    --    self:makeHurt(pos)
        table.remove(self.m_tBulletList,index)
        SoundManager:playEffectSound(SoundDefine.E_S_EXPLODE)
    end
end

function BattleMsgAssistedMountSkill:makeHurt(pos)
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
            WZLog("BattleMsgAssistedMountSkill:makeHurt one", target:getBattleId())
            table.insert(targetList,target)
        end
    end
    WZLog("BattleMsgAssistedMountSkill:makeHurt", #targetList)
    BattleMethod:waitForSkillHurt(self:getOwner(), targetList)
end

--@brief 获得技能所有者
function BattleMsgAssistedMountSkill:getOwner()
    return self.m_tOwner
end

--@brief 获得owner坐标
function BattleMsgAssistedMountSkill:getOwnerPos()
    return self.m_tOwner:getPosition()
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgAssistedMountSkill:done()
    WZLog("BattleMsgAssistedMountSkill:done")
    for i = #self.m_tBulletList,1,-1 do
        self:removeBullet(i)
    end
end

--@brief    检查区域碰撞
--@param    rang:区域
--@param    isOnlyCheck:只检查圆与矩形相交
--@return   #1:true:撞了,false:没撞
function BattleMsgAssistedMountSkill:checkCollisionWithRang(pos,raduis,charaPos,charaRaidus,collisionRang)
    local dis = nil
    if collisionRang ~= nil then
        for i,rang in pairs(collisionRang) do
            if rang.m_nType == 0 then
                local isColl = BattleCommon:checkCircleCollosion(pos,raduis,charaPos,charaRaidus)
                WZLog("BattleMsgAssistedMountSkill:checkCollisionWithRang one", i, tostring(isColl), pos.x, pos.y, charaPos.x, charaPos.y, raduis, charaRaidus)
                if isColl then
                    return true, dis
                end
            elseif rang.m_nType == 1 then
                local rect = {x = charaPos.x+rang.m_fXOffset - rang.m_fWidth*0.5,y = charaPos.y+rang.m_fYOffset,w = rang.m_fWidth,h=rang.m_fHeight}
                local circle = {x = pos.x,y=pos.y,r = raduis}
                local curdis = WBullet:distanceWithCircleAndRect(circle,rect)
                dis = 9999
                dis = math.min(curdis, dis)
                WZLog("BattleMsgAssistedMountSkill:checkCollisionWithRang two", i, curdis, dis,raduis)
                if dis <= raduis then
                   return true, dis
                end
            end
        end
    else
        local isColl = BattleCommon:checkCircleCollosion(pos,raduis,charaPos,charaRaidus)
        WZLog("BattleMsgAssistedMountSkill:checkCollisionWithRang three", tostring(isColl), dis)
        return isColl, dis
    end

    WZLog("BattleMsgAssistedMountSkill:checkCollisionWithRang four")
    return false, dis
end

--@brief    获取爆破半径
--@return   #1:爆破半径
function BattleMsgAssistedMountSkill:getExplodeRadius()
    return self:getOwner():getRadiusForBulletExplode()
end

--@brief    表演完成，执行技能效果
function BattleMsgAssistedMountSkill:doSkillEffeect()
    -- body
    if #self.m_tBulletList > 0 then return false end 

    local skillData = GDatatab_skill["id_" .. self.m_nSkillId]
    if skillData and skillData.id_group == 123 then 
        local msg = MsgManager:createMsg(BattleMsgBossMapSkill)
        msg.m_nId = self.m_nSkillId --不发协议
        msg.m_tOwner = self.m_tOwner
        msg.m_tSkillTypeList = {[1]=SkillTypeConfig.EFFECT}
        msg.m_nSkillId = self.m_nSkillId
        msg.m_nEffcetId = self.m_nSkillId
        msg.m_nTakeEffectType = TakeEffectType.USE
        msg.m_bIsReplayMsg = true --结束标记
        msg.m_tTargetPlayerId = nil
        msg.m_tOwnPlayerId = self.m_tOwner:getId()
        MsgManager:pushNonBlockMsg(msg)
    else
        local config = self:_getEffectData(skillData.effect_id[1][1])
        local tEffcetConfig = config.effect
        for i, skillParm in pairs (tEffcetConfig) do
            local effectParm = skillParm
            local effect = effectParm[3] .. "_" ..effectParm[4]
            if effect == EffectTypeConfig.ADD_BUFF then 
                local takeEffectParm = effectParm[1]
                local targetHeroList = self.m_tTargetHeroList
                for j, hero in pairs(targetHeroList) do
                    for id, buff in pairs (hero.m_tBuffChangeStateList) do
                        if buff.m_nSkillType == 7 and buff.m_tAnim and not buff.m_tAnim:getAnimNode():isVisible() then
                            buff.m_tAnim:getAnimNode():setVisible(true)
                        end
                        WZLog("BattleMsgAssistedMountSkill:doSkillEffeect", tostring(buff.m_tAnim))
                    end
                end
            end
        end
    end

    return true 
end

--@brief    获取技能效果表配置 
function BattleMsgAssistedMountSkill:_getEffectData(id)
    return CopyTable(GDatatab_effect["id_"..id])
end
-------------------------------------私有方法模块--------------------------------------
