--BattleMsgSkillLoop.lua
--@brief    表演阶段结束判断
--@date     2015/08/01
--BattleMsgSkillShow = {}
function BattleMsgSkillShow:skillLoop(dt)
    if self.m_tSkillLoopList and #self.m_tSkillLoopList > 0 then
        for i = #self.m_tSkillLoopList,1,-1 do
            local actType = self.m_tSkillLoopList[i]
            if actType == BattleSkillType.PLAY or actType == BattleSkillType.PLAY_MACHINE or actType == BattleSkillType.PLAY_STEP then
                self:updateForAnimation(dt,actType)
            elseif actType == BattleSkillType.MONSTER_SHOOT_ANIMA_LOOP then
                self:updateForShootAnimation(dt,actType)
            elseif actType == BattleSkillType.DELAY then
                self:updateForDelay(dt)
            -- elseif actType == BattleSkillType.SPRING then
            --     self:updateForSpring(dt)
            elseif actType == BattleSkillType.CAMERA then
                self:updateForCamera(dt)
            elseif actType == BattleSkillType.MONSTER_SHOOT or actType == BattleSkillType.MONSTER_BOSS_GUN_SHOOT then
                self:updateBullet(dt,actType)
            elseif actType == BattleSkillType.REPEAT_SHOOT then
                self:repeatShoot(dt)
            elseif actType == BattleSkillType.UPDATE_BULLET then
                self:updateBullet(dt,actType)
            elseif actType == BattleSkillType.FOLLOW_BULLET then
                self:followBullet(dt)
            elseif actType == BattleSkillType.SUMMON_SEND then
                self:sendBuildSummonMonster(dt)
            elseif actType == BattleSkillType.SUMMON_BUILD then
                self:buildSummonMonsterLoop(dt)
            elseif actType == BattleSkillType.MONSTER_BOSS_GUN_ROTATION or actType == BattleSkillType.MONSTER_BOSS_GUN_ROTATION_RESET then
                self:updateRotationBossGun(dt,actType)
            elseif actType == BattleSkillType.MOVE_DISTANCE then
                self:updateMoveDistance(dt,actType)
            end
        end
    end

    if self.m_tScreenSpring ~= nil then
        self:updateForSpring(dt)
    end
end

--@brief 相对位置移动
function BattleMsgSkillShow:updateMoveDistance(dt,actType)
   if not self.m_tMoveDistance then
        self:reduceWait(actType)
        return
    end
    local hero = self:getActor()
    local pos = hero:getPosition()
    local speed = self.m_tMoveDistance.speed
    WZLog("BattleMsgSkillShow:updateMoveDistance",pos.x,pos.y)
    if self.m_tMoveDistance.isMoveX then
        hero:setPosition(GlobalMethod:ccp(pos.x + speed,pos.y))
    else
         hero:setPosition(GlobalMethod:ccp(pos.x,pos.y + speed))
    end
    self.m_tMoveDistance.distance = self.m_tMoveDistance.distance - speed
    if math.abs(speed) > math.abs(self.m_tMoveDistance.distance) then
        hero:setPosition(GlobalMethod:ccp(pos.x + speed + self.m_tMoveDistance.distance,pos.y))
        self.m_tMoveDistance = nil
        self:reduceWait(actType)
    end
end

--@brief 动作播放刷新
function BattleMsgSkillShow:updateForAnimation(dt,actType)
    local hero = self:getActor()
    -- WZLog("BattleMsgSkillShow:playAnimation",hero:getAnimation():isPlaying(hero:getAnimationName("standby")),hero:getAnimation():isCurrentAnimationDone())
    if hero:getAnimation():isPlaying(hero:getAnimationName("standby")) or hero:getAnimation():isCurrentAnimationDone() == true then
        self:reduceWait(actType)
    end
end

--@brief 射击动作刷新
function BattleMsgSkillShow:updateForShootAnimation(dt,actType)
    local hero = self:getActor()
    if hero:getAnimation():isPlaying(hero:getAnimationName("standby")) or hero:getAnimation():isCurrentAnimationDone() == true then
        self:reduceWait(actType)
        self:playAnimation(self.m_sShootEndAnimName)
        hero:setAutoStandAction(true)
    end
end

--@brief 延时刷新
function BattleMsgSkillShow:updateForDelay(dt)
    if self.m_nLoopTime then
        self.m_nLoopDt = self.m_nLoopDt + dt
        if self.m_nLoopDt * 1000 >= self.m_nLoopTime then
            self.m_nLoopTime = nil
            if self.m_tDelayCall then 
                self.m_tDelayCall(self)
            end
            self:reduceWait(BattleSkillType.DELAY)
        end
    end
end

--@brief 震屏播放刷新
function BattleMsgSkillShow:updateForSpring(dt)
    if self.m_tScreenSpring ~= nil then
        if BattleScreen:screenSpring() == true then
            self.m_tScreenSpring = nil
        end
    end
end

--@brief 镜头移动刷新
function BattleMsgSkillShow:updateForCamera(dt)
    --WZLog("BattleMsgSkillShow:updateForCamera",self.m_tCameraPlayer)
    if not self:isCanCtrlCamera() then
        self:reduceWait(BattleSkillType.CAMERA)
        return
    end
    local cameraEnd = false
    WZLog("BattleScreen:followHero 11")
    cameraEnd = BattleScreen:followHero(self.m_tCameraPos)
    if cameraEnd then
        self:reduceWait(BattleSkillType.CAMERA)
    end
end

--@brief    更新子弹状态
function BattleMsgSkillShow:updateBullet(dt,actType)
    -- WZLog("BattleMsgSkillShow:updateBullet")
    
    local bullets = WBattleGlobal:getCurrent():getBossBulletsList()
    
    -- WZLog("BattleMsgSkillShow:updateBullet #bullets = "..#bullets, tostring(self.m_bIsPenetrateMap), tostring(self.m_bIsNeedHurt))
    for i=#bullets,1,-1 do
        if bullets[i]:getOwnerChara():getBattleId() == self.m_tOwner:getBattleId() then
            if bullets[i]:getStatus() == BossBulletStatus.DEF_ST_FLY then
                -- WZLog("BattleMsgSkillShow:updateBullet BossBulletStatus.DEF_ST_FLY-1", bullets[i]:getPosition().x, bullets[i]:getPosition().y, bullets[i].m_mover:getMoverPosition().x, bullets[i].m_mover:getMoverPosition().y)
                bullets[i]:updatePosition()
                -- WZLog("BattleMsgSkillShow:updateBullet BossBulletStatus.DEF_ST_FLY-2", bullets[i]:getPosition().x, bullets[i]:getPosition().y, bullets[i].m_mover:getMoverPosition().x, bullets[i].m_mover:getMoverPosition().y)
                -- WZLog("BattleMsgSkillShow:_updateBullet pos",i)
                -- WZLog("BattleMsgSkillShow:_updateBullet pos",bullets[i]:getMover():getMoverPosition().x,bullets[i]:getMover():getMoverPosition().y)
                --碰撞检测
                local isCollision = false
                
                isCollision = bullets[i]:checkCollision()
                -- WZLog("BattleMsgSkillShow:updateBullet two-4.00", tostring(isCollision), tostring(self.m_bIsPenetrateMap))

                if isCollision then
                    -- local charas,values = self:checkHurt(bullets[i])
                    -- local charas,values,tDistance,tCritType = bullets[i]:checkHurt(true)
                    -- WZLog("BattleMsgSkillShow:updateBullet two-4.01", tostring(isCollision), tostring(self.m_bIsPenetrateMap), tostring(self.m_bIsNeedHurt), type(self.m_bIsNeedHurt))

                    local hero = self.m_tOwner
                    if self.m_bIsNeedHurt == true then
                        -- WZLog("BattleMsgSkillShow:updateBullet two-4.1")
                        -- local charas,values = self:checkHurt(bullets[i])
                        local tHurtCharas, tHurtValues, tDistance, tCritType, tHurtRatios = bullets[i]:checkHurt()
                        self:charaAddHurtValue(tHurtCharas,tHurtValues,tHurtRatios)
                        self:sendHurtProtocol(tHurtCharas, tHurtValues, tDistance, tCritType)
                        bullets[i]:markExplode(false)
                    end

                    if self.m_bIsNeedExplode == true then
                        bullets[i]:explode()
                        bullets[i].m_nCurStatus = BossBulletStatus.DEF_ST_EXPLODE
                    else
                        SoundManager:playEffectSound(SoundDefine.E_S_EXPLODE)
                        bullets[i].m_nCurStatus = BossBulletStatus.DEF_ST_EXPLODE
                    end

                    if bullets[i].m_bIsMark ~= true then
                        --self:setSceneSpring(bullets[i]:getMover():getMoverPosition())
                        local config = {actType = BattleSkillType.SPRING, param1 = BattleSkillTargetType.OTHER,param2 = bullets[i]:getMover():getMoverPosition()}
                        self:doAction(config)
                    end

                    --飞出屏外
                -- elseif bullets[i]:checkOutOfScene() then
                --     bullets[i]:destroy()
                --     WBattleGlobal:getCurrent():removeBossBulletByIndex(i)
                --     self:checkMonsterShootEnd(actType)
                end
            -- elseif bullets[i]:getStatus() == BossBulletStatus.DEF_ST_EXPLODE or bullets[i]:getStatus() == BulletStatus.DEF_ST_END_EXPLODE then
            --     WZLog("BattleMsgSkillShow:updateBullet BossBulletStatus.DEF_ST_EXPLODE")
            --     --是否爆炸完毕
            --     local explodeName = "0"
            --     if bullets[i]:explodeIsEnd(explodeName) or self.m_bIsNeedExplode == false then
            --         WZLog("BattleMsgSkillShow:updateBullet explodeIsEnd()")

            --         bullets[i]:destroy()
            --         WBattleGlobal:getCurrent():removeBossBulletByIndex(i)
            --         self:checkMonsterShootEnd(actType)
            --     end
            end

            --移除子弹
            if self:_canRemoveBullet(bullets[i], i) then
                if bullets[i].m_bIsMark ~= true then
                    bullets[i]:destroy()
                end
                WBattleGlobal:getCurrent():removeBossBulletByIndex(i)
                self:checkMonsterShootEnd(actType)
                -- WZLog("BattleMsgSkillShow:_updateBullet two-4.2")
            end
        end
    end
end

--@brief    是否可以移除子弹
--@param    tBullet:检测的子弹
--@return   #1:true,false
function BattleMsgSkillShow:_canRemoveBullet(tBullet, index)
    --WZLog("BattleMsgPlayerShoot:_canRemoveBullet zero", index)
    --飞出屏外
    if tBullet:checkOutOfScene() then
        -- WZLog("BattleMsgSkillShow:_canRemoveBullet one", index)
        return true
    end
    --爆炸动画播放完毕
    if tBullet:explodeIsEnd() then
        -- WZLog("BattleMsgSkillShow:_canRemoveBullet two", index)
        return true
    end
    --再次确认是否爆炸完毕
    if tBullet:getStatus() == BulletStatus.DEF_ST_END_EXPLODE then
        -- WZLog("BattleMsgSkillShow:_canRemoveBullet three", index)
        return true
    end

    if tBullet.m_bIsMark == true and tBullet:getStatus() == BulletStatus.DEF_ST_EXPLODE then
        -- WZLog("BattleMsgSkillShow:_canRemoveBullet four", index)
        return true
    end
    return false
end

--@brief    屏幕跟踪子弹
function BattleMsgSkillShow:followBullet()
    -- WZLog("BattleMsgSkillShow:followBullet",self.m_tOwner:getBattleId())
    if self.m_tOwner:isHide() == true then
        return
    end
    
    if self.m_tScreenSpring or not self:isCanCtrlCamera() then
        return
    end
    local bullets = WBattleGlobal:getCurrent():getBossBulletByBattleId(self.m_tOwner:getBattleId())
    local bullet = bullets[1]
    if bullet ~= nil then
        if self._followBullet_time_ == nil then
            self._followBullet_time_ = 0
            else
            self._followBullet_time_ = self._followBullet_time_ + SceneBattle:getBattleLoop():getBattleDeltaTime()
        end
        BattleScreen:followBullet(bullet:getMover():getMoverPosition(),self._followBullet_time_)
    end
end

--@brief 子弹爆破结束
function BattleMsgSkillShow:checkMonsterShootEnd(actType)
    for i = #self.m_tSkillLoopList,1,-1 do
        local actType = self.m_tSkillLoopList[i]
        if actType == BattleSkillType.REPEAT_SHOOT then
            return
        end
    end
    
    local bullets = WBattleGlobal:getCurrent():getBossBulletByBattleId(self.m_tOwner:getBattleId())
    if #bullets <= 0 then
        self:reduceWait(actType)
        self:reduceWait(BattleSkillType.FOLLOW_BULLET)
        if not self.m_tOwner:isDead() then
            self.m_tOwner:setMoveUpdatable(true)
        end
        return
    end
end

--@brief    射击子弹
function BattleMsgSkillShow:repeatShoot()
    WZLog("BattleMsgSkillShow:repeatShoot",self.m_sShootAnimName,self.m_nShootDeltaTime)
    
    -- self.m_nShootDeltaTime = self.m_nShootDeltaTime + SceneBattle:getBattleLoop():getBattleDeltaTime()
    self.m_nShootDeltaTime = self.m_nShootDeltaTime + 1
    
    local hero = self.m_tOwner

    if self.m_nAttTimes <= 0 then
        hero:setRunStatus(RunStatus.DEF_ST_SHOOT)
        
        self:repeatShootEnd()
    end
    
    local isCanRepeatShoot = false
    
    --是否能射击另一个子弹
    -- if #WBattleGlobal:getCurrent():getBossBulletsList() <= 0 then
    --     isCanRepeatShoot = true
    -- elseif self.m_nShootDeltaTime >= self.m_nEveryBulletShootDeltaTime * 30 then
    if self.m_nShootDeltaTime == 1 then
        if self.m_sShootAnimName then
            self:playAnimation(self.m_sShootAnimName)
        end
    end
    if self.m_nShootDeltaTime == 4 then
        isCanRepeatShoot = true
    end

     if self.m_nShootDeltaTime >= self.m_nEveryBulletShootDeltaTime * 30 then
        self.m_nShootDeltaTime = 0
    end
    
    if isCanRepeatShoot then
        -- if self.m_sShootAnimName then
        --     self:playAnimation(self.m_sShootAnimName)
        -- end
        -- self.m_nShootDeltaTime = 0
        
        if math.random(1,10) >=8 then
            local sound = getSoundByAttackType(1, hero:getMonsterConfig().armatureName or hero.m_sAniFileId or "", tostring(self.m_bIsCreateBullet))
            WZLog("BattleMsgSkillShow:repeatShoot two", self.m_nAttTimes, hero:getMonsterConfig().armatureName or hero.m_sAniFileId, tostring(sound))
            if sound and self.m_bIsCreateBullet == nil then
                SoundManager:playEffectSound(sound)
            end
        end
        self.m_bIsCreateBullet = true
        self:createBullet()
        if self.m_nAttTimes <=  1 then
            hero:setRunStatus(RunStatus.DEF_ST_SHOOT)
            
            self.m_nAttTimes = self.m_nAttTimes - 1
            
            self:repeatShootEnd()
        else
            hero:setRunStatus(RunStatus.DEF_ST_REPEAT_SHOOT)
            
            self.m_nAttTimes = self.m_nAttTimes - 1
        end

    else
        hero:setRunStatus(RunStatus.DEF_ST_REPEAT_SHOOT)
    end
end

--@brief 射击结束
function BattleMsgSkillShow:repeatShootEnd()
    WZLog("BattleMsgSkillShow:repeatShootEnd")
    -- 后续动作
    if self.m_sShootNextAct then
        local hero = self:getActor()
        hero:setAutoStandAction(true)
        hero:play(hero:getAnimationName(self.m_sShootNextAct),false)
        self.m_sShootNextAct = nil
    end
    if self.m_sShootEndAnimName then
        local config = {actType = BattleSkillType.MONSTER_SHOOT_ANIMA_LOOP}
        self:doAction(config,true)
        -- local hero = self:getActor()
        -- hero:setAutoStandAction(true)
        -- hero:play(hero:getAnimationName(self.m_sShootEndAnimName),false)
        -- self.m_sShootEndAnimName = nil
    end

    self:reduceWait(BattleSkillType.REPEAT_SHOOT)
    local config = {actType = BattleSkillType.FOLLOW_BULLET,isWait = 1}
    self:doAction(config)
end

--@brief    发送生成小怪协议
function BattleMsgSkillShow:sendBuildSummonMonster(dt)
    WZLog("BattleMsgSkillShow:sendBuildSummonMonster", tostring(self.m_tOwner:isCanControl()))
    if self.m_bIsSummon == nil then
        self.m_bIsSummon = true

        --获取小怪ID(每帧执行一次)
        self.m_tSummonMonsterBattleId = {}
        self.m_tSummonMonsterId = {}
        self.m_tSummonMonsterPositionX = {}
        self.m_tSummonMonsterPositionY = {}

        local monsterPosList = {}
        local summonCount = 0
        for i, v in pairs(self.m_tSummonMonsterList) do
            v.summonedCount = 0
            for j, u in pairs(WBattleGlobal:getCurrent():getGuaiList()) do
                local inLive = true
                
                if u:isServerDead() then
                    inLive = false
                end

                if inLive and u:getId() == v.id then
                    v.summonedCount = v.summonedCount + 1
                    table.insert(monsterPosList,u:getPosition())
                end
            end
            v.shouldCount = math.min(v.count, v.maxCount - v.summonedCount)
            summonCount = summonCount + v.shouldCount
        end


        self.m_nBattleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
        self.m_nPlayerOrGuai = 1
        self.m_nCurrentId = self.m_tOwner:getBattleId()

        for id, summonMonster in pairs(self.m_tSummonMonsterList) do
            local clearPos = false
            for i=1,summonMonster.shouldCount do
                --移除不合规定的点
                if not clearPos then
                    for k = 1, #monsterPosList do
                        local pos = monsterPosList[k]
                        
                        for j = #summonMonster.posX,1,-1 do
                            if #summonMonster.posX > 1 and summonMonster.posX[j] and summonMonster.posY[j] then
                                local tPos = BattleCommon:getPointTable(summonMonster.posX[j],summonMonster.posY[j])
                                if BattleCommon:pointDis(pos,tPos) < 100 then
                                    table.remove(summonMonster.posX, j)
                                    table.remove(summonMonster.posY, j)
                                    --WZLog("BattleMsgSkillShow:sendBuildSummonMonster II", j)
                                end
                            end
                        end
                    end
                    clearPos = true
                end

                table.insert(self.m_tSummonMonsterBattleId,i)
                table.insert(self.m_tSummonMonsterId,summonMonster.id)
                table.insert(self.m_tSummonMonsterPositionX,summonMonster.posX[i] or summonMonster.posX[1] + (i-1) * 150)
                table.insert(self.m_tSummonMonsterPositionY,summonMonster.posY[i] or summonMonster.posY[1])
            end
        end

        if  #self.m_tSummonMonsterBattleId > 0 and self.m_tOwner:isCanControl() then
            -- WZLog("BattleMsgSkillShow:sendBuildSummonMonster two", self.m_nBattleId, self.m_nPlayerOrGuai, self.m_nCurrentId, #self.m_tSummonMonsterBattleId, #self.m_tSummonMonsterId, #self.m_tSummonMonsterPositionX, self.m_tSummonMonsterPositionY)

            ProtocolProcessorBattleInterface:send_BATTLE_BuildGuai(self.m_nBattleId,  self.m_nCurrentId,
                                                                    self.m_tSummonMonsterId,
                                                                   self.m_tSummonMonsterPositionX, self.m_tSummonMonsterPositionY)
        else
            self.m_bClientSummon = true
        end
        WZLog("BattleMsgSkillShow:sendBuildSummonMonster two", self.m_nBattleId, self.m_nPlayerOrGuai, self.m_nCurrentId, #self.m_tSummonMonsterBattleId, #self.m_tSummonMonsterId, #self.m_tSummonMonsterPositionX, self.m_tSummonMonsterPositionY)
        if WBattleGlobal:getCurrent():isSingleStage() then
            self:sendSummonEnd()
        end
    end
    
    --客机使用召唤技能，等待battleId过程，转为可以控制的主机，发送召唤申请
    if not WBattleGlobal:getCurrent():isSingleStage() and self.m_bClientSummon and self.m_tOwner:isCanControl() then
        self.m_bClientSummon = nil
        WZLog("BattleMsgSkillShow:sendBuildSummonMonster two", self.m_nBattleId, self.m_nPlayerOrGuai, self.m_nCurrentId, #self.m_tSummonMonsterBattleId, #self.m_tSummonMonsterId, #self.m_tSummonMonsterPositionX, self.m_tSummonMonsterPositionY)

        ProtocolProcessorBattleInterface:send_BATTLE_BuildGuai(self.m_nBattleId,  self.m_nCurrentId,
                                                                self.m_tSummonMonsterId,
                                                               self.m_tSummonMonsterPositionX, self.m_tSummonMonsterPositionY)
    end

    if self.m_tOwner.guaiId ~= nil and #self.m_tOwner.guaiId > 0 then 
        WZLog("BattleMsgSkillShow:sendBuildSummonMonster II", #self.m_tOwner.guaiId)
        for j, v in pairs(self.m_tOwner.guaiId) do
            WZLog("BattleMsgSkillShow:sendBuildSummonMonster IV", v)
        end
        self:sendSummonEnd()
    end
end

--@brief 创建怪物
function BattleMsgSkillShow:buildSummonMonsterLoop(dt)
    local monsterPos = nil
    -- for i=1,#self.m_tSummonMonsterId do

        if self.m_tOwner.guaiId ~= nil then 
            for j, v in pairs(self.m_tOwner.guaiId) do
                WZLog("BattleMsgSkillShow:buildSummonMonsterLoop",v)
                -- WZLog("BattleMsgSkillShow:buildSummonMonster zero-1", self.m_tSummonMonsterId[self.m_nSummonIndex], v, self.m_tSummonMonsterPositionX[self.m_nSummonIndex],self.m_tOwner.guaiPositionX[self.m_nSummonIndex])
                if self.m_tSummonMonsterId[self.m_nSummonIndex] == v then
                    self.m_tSummonMonsterBattleId[self.m_nSummonIndex] = self.m_tOwner.guaiBattleId[j]
                    table.remove(self.m_tOwner.guaiId, j)
                    table.remove(self.m_tOwner.guaiBattleId, j)
                    table.remove(self.m_tOwner.guaiPositionX, j)
                    table.remove(self.m_tOwner.guaiPositionY, j)
                    -- WZLog("BattleMsgSkillShow:buildSummonMonster zero-2",self.m_nSummonIndex,j,self.m_tSummonMonsterBattleId[self.m_nSummonIndex])
                    break
                end
            end
        end
        WZLog("BattleMsgSkillShow:sendBuildSummonMonster one---", self.m_nSummonIndex, #self.m_tSummonMonsterBattleId, #self.m_tSummonMonsterId, #self.m_tSummonMonsterPositionX, self.m_tSummonMonsterPositionY)
        local battleId = self.m_tSummonMonsterBattleId[self.m_nSummonIndex] or -2
        --单人副本创建小怪 为小怪添加battleId
        if WBattleGlobal:getCurrent():isSingleStage() and WBattleGlobal:getCurrent():getCopyData() then
            battleId = WBattleGlobal:getCurrent():getCopyData():getBuildGuaiIndex()
            WBattleGlobal:getCurrent():getCopyData():addBuildGuaiIndex()
        end
        local monster = WMonster:buildGuai(self.m_tSummonMonsterId[self.m_nSummonIndex],nil, true, battleId)
        --self:setGuaiInfo(monster, self.m_tSummonMonsterId[self.m_nSummonIndex])
        
        WZLog("BattleMsgSkillShow:buildSummonMonster two", self.m_nSummonIndex, battleId, monster.m_sAniFileId, monster.m_nPlayerId, 
            monster.m_sPlayerName, monster.m_nLevel, monster.m_nRealLevel, monster.m_nCamp, monster.m_nMaxHP, 
            monster.m_nHP, monster.m_nPF, monster.m_nAttack, monster.m_nCriticalhitAttackRate, monster.m_nDefence, 
            monster.m_nInjuryFree, monster.m_nWreckDefense, monster.m_nReduceCrit, monster.m_nReduceBury, monster.m_nGuaiType)
        monster:setPosition(BattleCommon:getPointTable(self.m_tSummonMonsterPositionX[self.m_nSummonIndex],self.m_tSummonMonsterPositionY[self.m_nSummonIndex]))
        monster:setBoss(self.m_tOwner)
        monster:getAnimation():getAnimNode():setAnchorPoint(monster:getSceneAnchorPoint())
        table.insert(self.m_tOwner.m_tOwnedMonsterList, monster)
        monsterPos = monster:getPosition()
        --加入场景
        if self.m_bSummonAuto then
            WBattleGlobal:getCurrent().m_tGuais[battleId] = monster
            SceneBattle:getFrontLayer():addChild(monster:getAnimation():getAnimNode())
            if monster:getMover() then
                WBattleGlobal:getCurrent().m_battleManager:addEntity(monster:getMover())
            end

            monster:setAppearAttribute()
            monster:play(monster:getAnimationName("standby"), true)
        end
        
        table.insert(self.m_tSummonList, monster)
        --添加ctb头像
        if battleId > 0 and not WBattleGlobal:getCurrent():isExpCopy() and monster:isNormalAct() then
            WZLog("BattleMsgSkillShow:buildSummonMonster three", battleId)
            BattleCtbManager:addCellBattleCtb(battleId)
        else
            monster.m_bIsInCtb = false
        end
        
        --出现特效
        if self.m_bSummonEffectId then
            local effect  = BattleEffect:createAnimation(self.m_bSummonEffectId)
            monster:getAnimation():getAnimNode():addChild(effect:getAnimNode())
        end
        --调整方向
        if self.m_bSummonIsFilpX then
             if monster.m_bIsFilpX ~= true then
                monster:getAnimation():setFlipX(true)
                monster.m_bIsFilpX = true
            elseif monster.m_bIsFilpX == true then
                monster:getAnimation():setFlipX(false)
                monster.m_bIsFilpX = false
            end
        end

        GlobalGame:getBattleEventDispatcher():Dispatch(BATTLE_EVENT_TYPE.MONSTER_CREATE)
    -- end
    if self.m_nSummonIndex == #self.m_tSummonMonsterId then
        self:reduceWait(BattleSkillType.SUMMON_BUILD)
    end
     --加入场景镜头拖动
    if self.m_nSummonIndex == 1 and self.m_bSummonAuto and monsterPos then
        local config = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = nil,param2 = nil,param3 = monsterPos}
        self:doAction(config,config.isWait)
    end
    self.m_nSummonIndex = self.m_nSummonIndex + 1
end

--@brief 调整炮台角度
function BattleMsgSkillShow:updateRotationBossGun(dt,actType)
    local gun = self.m_tOwner:getMachine()
    local rotation =  gun:getRotation()
    --WZLog("updateRotationBossGun",actType,rotation,self.m_nShootRotation)
    if math.abs(rotation - self.m_nShootRotation) < 3 then
        gun:setRotation(self.m_nShootRotation)
        self:reduceWait(actType)
    else
        if rotation < self.m_nShootRotation then
            gun:setRotation(rotation + 2)
        else
            gun:setRotation(rotation - 2)
        end
    end 
end

--@brief 召唤协议发送结束
function BattleMsgSkillShow:sendSummonEnd()
    self.m_bClientSummon = nil
    --移除loop
    self:reduceWait(BattleSkillType.SUMMON_SEND)
    --移除表演节点
    self:reduceWait(BattleSkillType.SUMMON)
    self:reduceWait(BattleSkillType.SUMMON_II)
    --[[
    local pos = BattleCommon:getPointTable(self.m_tSummonMonsterPositionX[1],self.m_tSummonMonsterPositionX[1])
    local config = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = nil,param2 = nil,param3 = pos}
    self:doAction(config)
    ]]
    --local config = {actType = BattleSkillType.SUMMON_BUILD}
    --self:doAction(config)
    return
end
