--WBattleMachineXuanZang.lua
--@brief    场景机关
--@date     2015/04/06
--@note     玄奘大招

WBattleMachineXuanZang = {
    m_tAniFileIndex = nil,  --配置id
    m_tConfig = nil,    --配置
    m_nBattleId = nil,   --战场唯一id
    m_bCheckHurt = nil,  --检查伤害
    m_anim = nil,   --形象
    m_mover = nil,  --移动管理者
    m_tCollisionRang = nil, --碰撞区域
    m_bIsShowRang = false,  --是否显示碰撞区域
    m_tCollisionTable = nil,    --显示的碰撞框
    m_bAutoStandAction = true,  --自动切换待机

    m_nTimeDurationValue = nil, --持续时间
    m_nTimePassValue = nil, --存在时间（间隔累加计算）
    m_nTimePassValueReal = nil, --每回合结束 存在时间 （总ctb换算）
}

-------------------------------------公有方法模块Begin--------------------------------------

--@brief    以本表为模版创建一个新的表实例对象
--@return   新建的表实例对象
function WBattleMachineXuanZang:new(battleId,templateId,camp,bronPos)
    WZLog("WBattleMachineXuanZang:new",battleId,templateId,camp,skillId,interval,duration)
    -- WBattleGlobal:getCurrent():setBuildMonsterRecord(battleId,templateId)
    setmetatable(WBattleMachineXuanZang,{__index = WCharacter})
    local tNewObj = {}
    setmetatable(tNewObj, { __index = WBattleMachineXuanZang })
    tNewObj.m_nBattleId = battleId
    tNewObj.m_nPlayerId = templateId
    tNewObj.m_nCamp = camp
    
    tNewObj:parseMonsterData()
    tNewObj.m_bIsInCtb = false--不参与ctb轮转
    tNewObj.m_bOffHurt = true --不参与伤害计算
    tNewObj.m_bOffCollision = true --不参与子弹碰撞计算
    tNewObj.m_nTimeDurationValue = tNewObj.m_tSkillParam ~= -1 and tNewObj.m_tSkillParam[1][1] or 10000
    tNewObj.m_nTimePassValue = 0
    tNewObj.m_nTimePassValueReal = 0
       
    tNewObj.m_bActiveAttack = false
    tNewObj.m_bPassiveAttack = false
    tNewObj.m_tActiveSkillList = {}
    tNewObj.m_tPassiveSkillList = {}
    --设置当前方向向左
    tNewObj.m_nCurDirect = 0

    tNewObj:_init()
    local firstPos = bronPos or {x = 900,y = 800}
    firstPos.y = firstPos.y - 200 --策划需求龙卷风的位置要偏下一下
    tNewObj:setPosition(Vector2:create(firstPos.x, firstPos.y + 250))
    
    return tNewObj
end

--@brief 读取怪物模板配置
function WBattleMachineXuanZang:parseMonsterData()
    local monsterData =  BossData["id_"..self.m_nPlayerId]
    if self.m_nCamp ~= WBattleGlobal:getCurrent():getMyHero():getCamp() then
         self.m_tAniFileIndex =  "machine_1019"
    else
        self.m_tAniFileIndex =  "machine_1019"
    end

    --数据表索引id
    self.m_nIndexId = monsterData.id
    --怪名字
    self.m_sPlayerName = monsterData.name
    --怪等级
    self.m_nLevel = tonumber(monsterData.level)--GlobalGame:checkGlobalPlayerLevel(monsterData.level) 
    --怪物真实等级
    self.m_nRealLevel = monsterData.level
    --行动类型
    self.m_nAction_type = monsterData.action_type > 0 and monsterData.action_type or 1 
    if monsterData.offHurt and monsterData.offHurt == 1 then
        self.m_bOffHurt = true
    end
    
    if monsterData.offRepulse and monsterData.offRepulse == 1 then
        self.m_bOffRepulse = true
    end

    if monsterData.limit and monsterData.limit == 1 then
        self.m_bOffFrozen = true
    end

    local scale = 1
    if monsterData.scale and monsterData.scale > 10 then
        scale = monsterData.scale/100
    end

    self.m_nScale = scale or 1
    --怪maxHP
    --怪攻击力
    --世界boss等级
  
    self.m_nHP = monsterData.hp
    self.m_nMaxHP = monsterData.hp
    self.m_nAttack = monsterData.attack
   
    --怪maxPF
    self.m_nMaxPF = monsterData.tili
    --怪性别
    -- monster.m_nBoyOrGirl = monsterData.sex
    --怪MaxSP
    self.m_nMaxSP = 0
    --怪HP
    -- monster.m_nHP = monsterData.hp
    -- monster.m_nHP_Encrypt = BattleCommon:intEncrypt(monster.m_nHP)
    --怪PF
    self.m_nPF = 100
    --怪SP
    self.m_nSP = 0
    -- --怪攻击力
    -- monster.m_nAttack = monsterData.attack
    -- monster.m_nAttack_Encrypt = BattleCommon:intEncrypt(monster.m_nAttack)
    --怪暴击倍率
    self.m_nCriticalhitAttackRate = monsterData.crit
    --怪防御
    self.m_nDefence = monsterData.defend
    --怪免伤
    self.m_nInjuryFree = monsterData.injury_free
    --怪破防值
    self.m_nWreckDefense = monsterData.wreck_defense
    --怪免暴
    self.m_nReduceCrit = monsterData.reduce_crit
    --怪免坑
    self.m_nReduceBury = monsterData.reduce_bury
    --怪大招类型
    self.m_nBigSkillType = monsterData.bigSkillType
    --怪转生等级
   
    self.m_nZSLevel = GlobalGame:checkGlobalPlayerZsleve(monsterData.level)

    --怪武器类型
    --monster.m_nWeaponType = monsterData.weapon_type
    --攻击相关
    self:setAttPercent(100)
    self:setAttTimes(1)
    self:setAttScatterNum(1)
    self:setCanFrozen(false)
    self:setCanFollow(false)
    
    self.m_nPower = monsterData.force
    self.m_nArmor = monsterData.armor
    self.m_nConstitution = 0
    self.m_nAgility = monsterData.agility
    self.m_nLucky = monsterData.luck
    --子弹爆破配置
    self:setRadiusForBulletExplodeRate(monsterData.scope/100)
    self.m_fRectForBulletExplodeBombRate = {x = monsterData.boom_scope[1][1]/100,y =monsterData.boom_scope[1][2]/100}

    local bombInfo = GDatatab_skill.id_1001.boom_scope[1]
    self.m_fRectForBulletExplodeBomb = {x=bombInfo[1],y=bombInfo[2]}
    self.m_fRadiusForBulletExplode = bombInfo.scope

    --怪物类型
    self.m_nGuaiType = 1

    self.m_nAttackArea = monsterData.attackArea * 1
    self.m_tSkillItemList = monsterData.skill
    self.m_nHitRate = monsterData.mzl
    self.m_nPhysicalMax = monsterData.tili
    self.m_tDialogue = monsterData.dialogue
    self.m_tAiScript = -1
    
    self.m_nAiType = 6
    self.m_nBulletId = monsterData.bullet
    self.m_bPenetrate = monsterData.penetrate == 1
    self.m_sHeadId = self.m_sAniFileId
    self.m_nBuffAnimOffsetX = self:getConfig().buffAnimOffsetX
    self.m_nBuffAnimOffsetY = self:getConfig().buffAnimOffsetY
    self.m_tbulletPosOffset = self:getConfig().bulletPosOffset or {x=0,y=0}
    self.m_bIsOldAnim = self:getConfig().isSpine or false
    self.m_nFighting = monsterData.fighting
    self.m_tSkillParam = monsterData.tSkillParam
    self.m_nMonsterType = monsterData.type
end

--@brief 获得配置id
function WBattleMachineXuanZang:getAniFileIndex()
    return self.m_tAniFileIndex
end

--@brief 道具刷新
function WBattleMachineXuanZang:update(dt)
    if self:isDead() then
        self:updateDeadAct()
        return
    end

    WCharacter.update(self,dt)

    if self:getAnimation():isCurrentAnimationDone() == true and self.m_bAutoStandAction then
        self:getAnimation():play(self:getNormalAnimationName(), true)
    end

    self:checkCollision()
    self:checkCharaCollision()
    -- if not self:isDead() and self:getHp() > 0 then
    --     self:_addBossName()
    -- end
    
end

--@brief    检查碰撞
--@param    pos:位置
--@param    raduis:半径
--@param    charaList:列表
--@return   #1:true:撞了,false:没撞
--@return   #2:碰撞的人物列表
function WBattleMachineXuanZang:checkCollision()
    --检测与子弹的碰撞
    local bullets = WBattleGlobal:getCurrent():getBulletsList()

    if bullets == nil or #bullets == 0 then
        bullets = WBattleGlobal:getCurrent():getBossBulletsList()
    end

    if bullets == nil or #bullets == 0 then
        return
    end

    for id,bullet in pairs(bullets) do
        --无视龙卷风判定
        local offTornado = true
        if BattleMethod:canReflectBullet(bullet,self:getBattleId(),2) then
            offTornado = false
        end

        if not offTornado and bullet.m_ownerChara:getCamp() ~= self.m_nCamp then
            local animPos = self.m_anim:getPosition()
            local rangList = self:getCollisionRang()
            local bulletPos = bullet.m_mover:getMoverPosition()
            local circle = {x = bulletPos.x,y=bulletPos.y,r = 2}
            local collision = false
            for id,rang in pairs(rangList) do
                -- local rect = {x = animPos.x+rang.m_fXOffset - rang.m_fWidth*0.5,y = animPos.y+rang.m_fYOffset,w = rang.m_fWidth,h=rang.m_fHeight}
                local rect = {x = animPos.x, y = animPos.y, r = rang.m_fRadius}
                local circle = {x = bulletPos.x,y=bulletPos.y,r = 2}
                -- if BattleCommon:rectCircleOverLap(rect,circle) then
                if BattleCommon:checkCircleCollosion(animPos, rect.r, bulletPos, circle.r) then
                    collision = true
                end
            end
            if collision then
                self:doEffect(bullet)
                bullet:addReflectList(self:getBattleId(),2)
            end
        end
    end
end

function WBattleMachineXuanZang:checkCharaCollision()
    local list = WBattleGlobal:getCurrent():getCharacterList(true)
    for i,hero in pairs(list) do
--        WZLog("WBattleMachineXuanZang:checkCharaCollision",hero:getBattleId(),tostring(hero.m_bOffFrozen),tostring(hero.m_bTornadoReflect))
        hero:setStopMoveByTornado(0)
        if not hero:isDead() then
            if not hero.m_bOffFrozen and not hero.m_bTornadoReflect and hero:getCamp() ~= self.m_nCamp then
                local animPos = self.m_anim:getPosition()
                local rangList = self:getCollisionRang()
                local heroPos = hero:getPosition()
                local collision = false
                for id,rang in pairs(rangList) do
                    -- local rect = {x = animPos.x+rang.m_fXOffset - rang.m_fWidth*0.5,y = animPos.y+rang.m_fYOffset,w = rang.m_fWidth,h=rang.m_fHeight}
                    local rect = {x = animPos.x, y = animPos.y, r = rang.m_fRadius}
                    local circle = {x = heroPos.x,y=heroPos.y,r = 10}
                    -- if BattleCommon:rectCircleOverLap(rect,circle) then
                    if BattleCommon:checkCircleCollosion(animPos, rect.r, heroPos, circle.r) then
                        collision = true
                    end
                end
                if collision then
                    self:doCharaEffect(hero)
                end
            end
        end
    end
end

--@brief ctb刷新
function WBattleMachineXuanZang:updateBuffByCTB(dt, updateCTB_time)
    if self:isDead() then
        return
    end
    
    WCharacter.updateBuffByCTB(self,dt,updateCTB_time)
    if dt ~= nil then
        --持续时间计数
        self.m_nTimePassValue = self.m_nTimePassValue + BattleCtbManager.SECOND_PER_CTB * dt
        if updateCTB_time > BattleCtbManager.m_nUpdateCTB_time then
            self.m_nTimePassValue = self.m_nTimePassValue - (updateCTB_time - BattleCtbManager.m_nUpdateCTB_time)
        end

        if self.m_nTimeDurationValue ~= -1 and self.m_nTimePassValue >= self.m_nTimeDurationValue then
            self:doSuicide()
        end
    else
        --真实时间换算
        self.m_nTimePassValueReal = self.m_nTimePassValueReal + BattleCtbManager.m_nUpdateCTB_time
        self.m_nTimePassValue = self.m_nTimePassValueReal
    end
end

function WBattleMachineXuanZang:doEffect(bullet)
    --@brief    事件处理
    local wind = WBattleGlobal:getCurrent():getWindLevel().x

    WZLog("WBattleMachineXuanZang:doEffect three", tostring(bullet), tostring(bullet:getIsExist()))
    if bullet:getIsExist() == true then --and bullet.m_bIsProcessMapEvent == false and bullet.m_bIsCollisionMapEvent == true then
        local reflectData = {pos=self:getCenterPos()}
        bullet.m_bIsAllCollision = true
        bullet:reflect(reflectData)
    end
end

function WBattleMachineXuanZang:doCharaEffect(hero)
    --@brief    事件处理
    if SceneBattle:getBattleLoop():getBattleStatus() ==  BattleLoop.S_PLAYER_FLY then
        --飞行碰撞
        hero.m_bTornadoReflect = true
        local wind = WBattleGlobal:getCurrent():getWindLevel().x
        if hero.m_mover then
            local moverSpeed = {x=hero.m_mover:getMoverSpeed().x, y=hero.m_mover:getMoverSpeed().y}
            local moverPos = {x=hero.m_mover:getMoverPosition().x, y=hero.m_mover:getMoverPosition().y}
            local windDirection = -1.0

            local changeSpeed = {x = moverSpeed.x * (windDirection + wind * 0), y = moverSpeed.y * -1.0}

            hero.m_mover:setMoverSpeed(Vector2:create(changeSpeed.x, changeSpeed.y))
       end
       WZLog("WBattleMachineXuanZang:doCharaEffect-one")
    else
        local offset = 320
        local animPos = self.m_anim:getPosition()
        local heroPos = hero:getPosition()
        if animPos.x > heroPos.x then
            hero:setStopMoveByTornado(2)
            local targetPos = GlobalMethod:ccp(animPos.x - offset,heroPos.y + 5)
            if not BattleCommon:checkPosCollision(targetPos,BattleMapManager.m_pixelByte) then
                local outOfScene = false 
                if SceneBattle:getFrontLayer() then
                    local sceneSize = SceneBattle:getFrontLayerSize()
                    local a = hero:getMover():getMoverPosition()
                    a = {x = a.x,y = a.y}
                    
                    --纵向超出屏幕
                    if animPos.x - offset < 5 or animPos.x - offset > sceneSize.width - 5 then
                        WZLog("WBattleMachineXuanZang:doCharaEffect one", animPos.x - offset)
                        outOfScene = true
                    end
                end
                if not outOfScene then 
                    hero:setPosition(GlobalMethod:ccp(animPos.x - offset,heroPos.y))
                end
            end
        else
            hero:setStopMoveByTornado(1)
            local targetPos = GlobalMethod:ccp(animPos.x + offset,heroPos.y + 5)
            if not BattleCommon:checkPosCollision(targetPos,BattleMapManager.m_pixelByte) then
                local outOfScene = false 
                if SceneBattle:getFrontLayer() then
                    local sceneSize = SceneBattle:getFrontLayerSize()
                    local a = hero:getMover():getMoverPosition()
                    a = {x = a.x,y = a.y}
                    
                    --纵向超出屏幕
                    if animPos.x + offset < 5 or animPos.x + offset > sceneSize.width - 5 then
                        WZLog("WBattleMachineXuanZang:doCharaEffect two", animPos.x + offset)
                        outOfScene = true
                    end
                end
                if not outOfScene then 
                    hero:setPosition(GlobalMethod:ccp(animPos.x + offset,heroPos.y))
                end
            end
        end
        hero:setMoveUpdatable(true)
        WZLog("WBattleMachineXuanZang:doCharaEffect-two")
    end
end

--@brief    初始化基础动画
function WBattleMachineXuanZang:initAnim()
    WZLog("WBattleMachineXuanZang:initAnim")
    local scale = self:getAnimScale()
    local anim = nil
    --初始化动画
    local isSpine = self:getConfig().isSpine or false

    if isSpine then
        --动画控制对象
        anim = BattleAnimation:createAnimation(self:getConfig().aniFileId or self.m_tAniFileIndex, false,"battle/monster")
    else
        --动画控制对象
        anim = BattleAnimation:createAnimation(self:getConfig().aniFileId or self.m_tAniFileIndex, true)
    end
    --动画控制对象
    anim:getAnimNode():retain()
    anim:setScale(scale)

    self.m_anim = anim  
    
    if self:getConfig().isMapCollision == true then
        self:setMover()
    end
    self:changeRectCollision()

    self:getAnimation():play(self:getAnimationName("skill"),false)
end

--@brief 设置碰撞
function WBattleMachineXuanZang:setMover()
    --小怪Mover
    self.m_mover = WDMoveEntity:create(self:getAnimation():getAnimNode())
    self.m_mover:setAdjustChild(true)
    self.m_mover:retain()

    local center = Vector2:create(0,50)
    self.m_mover:setMoverCenter(center)
    self.m_mover:setMoverRadius(10)
end

--@brief    获取缩放系数
function WBattleMachineXuanZang:getScale()
    return self.m_anim:getScale()
end

--@brief    设置缩放系数
function WBattleMachineXuanZang:setScale(scale)
    self.m_anim:setScale(scale)
end


--@brief    获取移动控制对象
--@return   #1:WDMove移动控制对象
function WBattleMachineXuanZang:getMover()
    return self.m_mover
end

--@brief 获取形象名字
function WBattleMachineXuanZang:getAnimationName(index)
    return self.animNormal[index] or self.animNormal["standby"]
end

--@brief 获取形象
function WBattleMachineXuanZang:getAnimation()
    return self.m_anim
end

function WBattleMachineXuanZang:getAnimScale()
    return self:getConfig().scale and self:getConfig().scale or 1
end

--@brief    添加碰撞矩形
function WBattleMachineXuanZang:changeRectCollision()
    local rectCollisionConfig = self:getConfig().rectCollision
    if not rectCollisionConfig then
        return
    end

    local size = self.m_anim:getAnimNode():getContentSize()
    local centerPos = self:getCenterPos()

    local config = self:getConfig()
    local scale = self:getAnimScale()
    if rectCollisionConfig then 
        for i, info in pairs (rectCollisionConfig)do
            self:addRectCollision(info.width * scale, info.height * scale,info.x * scale, info.y * scale)
            WZLog("WBattleMachineXuanZang:changeRectCollision two", info.width, info.height,info.x, info.y, scale)
        end
    end
end

--@brief    添加矩形碰撞范围
--@param    width,height:宽高
--@param    xOffset,yOffset:x,y偏移量
--@note     偏移量的参考点是character的中心点
function WBattleMachineXuanZang:addRectCollision(width,height,xOffset,yOffset)
    if self.m_tCollisionRang == nil then
        self.m_tCollisionRang = {}
    end

    -- local tRang = CollisionRang:new()
    -- tRang.m_nType = 1
    -- tRang.m_fWidth = width
    -- tRang.m_fHeight = height
    -- tRang.m_fXOffset = xOffset
    -- tRang.m_fYOffset = yOffset
    -- table.insert(self.m_tCollisionRang,tRang)

    local tRang = CollisionRang:new()
    tRang.m_nType = 0
    tRang.m_fRadius = width/2
    -- tRang.m_fWidth = width
    -- tRang.m_fHeight = height
    tRang.m_fXOffset = xOffset
    tRang.m_fYOffset = yOffset
    table.insert(self.m_tCollisionRang,tRang)
end



--@brief 获取中心点
function WBattleMachineXuanZang:getCenterPos()
    local moverCenter = {x=0,y=0}
    if self:getMover() ~= nil then
        moverCenter.x = self:getMover():getMoverCenter().x
        moverCenter.y = self:getMover():getMoverCenter().y
    end
    local anchor = self:getAnimation():getAnimNode():getAnchorPoint()
    local size = self:getAnimation():getAnimNode():getContentSize()
    local heroCenter = CCPointMake(moverCenter.x + anchor.x*size.width, moverCenter.y + anchor.y*size.height)

    local toParentTranf = self:getAnimation():getAnimNode():nodeToParentTransform()
    heroCenter=CCPointApplyAffineTransform(heroCenter,toParentTranf)
    return heroCenter
end

--@brief    获得当前的位置
--@return   #1, 返回当前的位置
function WBattleMachineXuanZang:getPosition()
    if not self.m_anim then
        return GlobalMethod:ccp(0,0)
    end
    return self.m_anim:getPosition()
end

--@brief    设置当前的位置
--@param    tPos 当前位置
function WBattleMachineXuanZang:setPosition(tPos)
    if self.m_mover ~= nil then
        self.m_mover:setMoverPosition(Vector2:create(tPos.x,tPos.y))
    end
    if self.m_anim ~= nil then
        self.m_anim:setPosition(Vector2:create(tPos.x,tPos.y))
    end
end

--@brief 
function WBattleMachineXuanZang:setRotation(rota)
    if self.m_anim then
        self.m_anim:getAnimNode():setRotation(rota)
    end
end

--@brief 
function WBattleMachineXuanZang:getRotation(rota)
    if self.m_anim then
        return self.m_anim:getAnimNode():getRotation()
    end
    return 0
end

--@brief 获取配置
function WBattleMachineXuanZang:getConfig()
    if not self.m_tConfig then
        local config = BattleMachineConfig[self.m_tAniFileIndex]
        self.m_tConfig = config
        self.m_tbulletPosOffset = config.bulletPosOffset or {x=0,y=0}
    end
    
    return self.m_tConfig
end

--@brief    获取对象类型
--@return   #1:对象类型(0:player,1:guai)
function WBattleMachineXuanZang:getType()
    return 100
end

--@brief    获取子弹碰撞半径
--@return   #1:子弹碰撞半径
function WBattleMachineXuanZang:getRadiusForBulletCollision()
    return 0
end

--@brief    获得碰撞范围
--@return   #1:碰撞范围
function WBattleMachineXuanZang:getCollisionRang()
    return self.m_tCollisionRang
end

--@brief 射击点
function WBattleMachineXuanZang:getShootPos(target)
    local targetHero = target

    local eOffset = BattleCommon:getPointTable(target.m_anim:getAnimNode():getContentSize().width * 0, target.m_anim:getAnimNode():getContentSize().height * 0.3)
    local sPos = BattleCommon:getPointTable(self:getPosition().x, self:getPosition().y + 10)
    local ePos = BattleCommon:getPointTable(target:getPosition().x + eOffset.x,target:getPosition().y + eOffset.y)

    --炮弹发射位置和角度修正
    if ePos.x <= sPos.x then
        sPos = BattleCommon:getShootPos(true, self)
    else
        sPos = BattleCommon:getShootPos(false, self)
    end

    return sPos,ePos
end

--@brief
--@return
function WBattleMachineXuanZang:getAutoStandAction()
    return self.m_bAutoStandAction
end

--@brief 设置自动切换待机动画
--@return
function WBattleMachineXuanZang:setAutoStandAction(val)
    self.m_bAutoStandAction = val
end

--@brief    获取待机动画
function WBattleMachineXuanZang:getNormalAnimationName()
    return self:getAnimationName("standby")
end

--@brief    获取受伤动画
function WBattleMachineXuanZang:getHurtAnimationName()
    return self:getAnimationName("hurt")
end

--@brief    获取死亡动画
function WBattleMachineXuanZang:getDeadAnimationName()
    return self:getAnimationName("dead")
end

--@brief 设置死亡
function WBattleMachineXuanZang:setDead(bDead, note)
    WZLog("WBattleMachineXuanZang:setDead one", tostring(note))
    if self.m_bIsDead ~= bDead then
        self.m_bIsDead = bDead
    end

    if self.m_bIsDead then
        if WBattleGlobal:getCurrent():isSingleStage() then
            self:setServerDead(true)
            self:getAnimation():play(self:getAnimationName("dead"),false)
        end
        WCharacter.clearAllBuff(self)
    else
        self:getAnimation():play(self:getAnimationName("standby"),true)
    end
end

--@brief 自杀
function WBattleMachineXuanZang:doSuicide()
    self:setDead(true,"doSelfKill")
    -- WBattleGlobal:getCurrent():setHoldMonsterRecord(self.m_nBattleId)
    if WBattleGlobal:getCurrent():isSingleStage() then
        self:setServerDead(true)
    else
        if WBattleGlobal:getCurrent():isHostControl() then
            ProtocolProcessorBattleInterface:send_BATTLE_OutOfScene(WBattleGlobal:getCurrent().m_tMakePairOk.battleId, self:getBattleId() ,WBattleGlobal:getCurrent():getCurrentCharacterId())
        end
    end
end

--@brief 获取死亡标记
function WBattleMachineXuanZang:isDead()
    return self.m_bIsDead
end

--@brief 死亡过程
function WBattleMachineXuanZang:updateDeadAct()
    local bIsDead = self:isServerDead()

--    WZLog("WBattleMachineXuanZang:updateDeadAct 00000", type(bIsDead), bIsDead)
    if self:isServerDead() then
        WZLog("WBattleMachineXuanZang:updateDeadAct")
        WBattleGlobal:getCurrent():removeMachine(self.m_nBattleId)
    end
end
--@--brief wbattleglobal调用
function WBattleMachineXuanZang:destroy()
    WZLog("WBattleMachineXuanZang:destroy")
    if self:getAnimation():getAnimNode() then
        self:getAnimation():getAnimNode():removeFromParentAndCleanup(false)
        WZLog("WBattleMachineXuanZang:release")
        self:getAnimation():getAnimNode():release()
    end

    if WBattleGlobal:getCurrent().m_battleManager ~= nil and  self.m_mover then
        WBattleGlobal:getCurrent().m_battleManager:removeEntity(self.m_mover)
    end

    if self.m_mover then
        self.m_mover:release()
        self.m_mover = nil
    end

    self:clearPlayerNameIcon()
    self.m_tAniFileIndex = nil
    self.m_tConfig = nil
    self.m_nBattleId = nil
    self.m_anim = nil
    self.m_tOwner = nil
    self.m_mover = nil
    self.m_tCollisionRang = nil
    self.m_bIsShowRang = nil
    self.m_tCollisionTable = nil
end


--@brief    获取中心位置
--@return   #1:中心位置
function WBattleMachineXuanZang:getCenterPos()
   return self:getPetAttackPos()
end

function WBattleMachineXuanZang:getPetAttackPos()
    local size = self:getConfig().animSize
    do
        local offsetH = size.height* 0.5
        return {x=self:getPosition().x,y=self:getPosition().y}
    end

end

--@brief    获取怪物类型
function WBattleMachineXuanZang:getMonsterType()
    return self.m_nMonsterType
end
-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------

--@brief    初始化对象
function WBattleMachineXuanZang:_init()
    WCharacter._init(self)

    self:_setAnimConfig()
    self:initAnim()
    self.m_bIsShowRang = true
end

--@brief 解析动画名字
function WBattleMachineXuanZang:_setAnimConfig()
    local animationInfo = self:getConfig()["animNormal"]
    self.animNormal = {}
    if animationInfo ~= nil then
        local animationInfoList = SplitStringWithSeparator(animationInfo, "|")
        for id, info in pairs(animationInfoList) do
            StringIntsertToTable(self.animNormal,info)
        end
    end
end

function WBattleMachineXuanZang:_addBossName()
    if self:getLevel() == -1 then
        return nil
    end
    if self.m_tBossName == nil then
        local bSameCamp = self.m_nCamp == WBattleGlobal:getCurrent():getMyHero():getCamp()
        self.m_tBossName = BattleHeroName:create(self,SceneBattle:getInfoLayer(),bSameCamp)
        self.m_tBossName.m_nameLabel:setVisible(false)
    end
    if self.m_tBossName then
        self.m_tBossName:update()
    end
end

--@brief 
function WBattleMachineXuanZang:getNameLayerOffset()
    return {x = 0, y = -10}
end

--@brief    获得人物名称信息的显示
--@return   #1, 人物名称信息的显示
function WBattleMachineXuanZang:getPlayerNameIcon()
    return self.m_tBossName
end

--@brief    清理人物名称信息的显示
function WBattleMachineXuanZang:clearPlayerNameIcon()
   if self.m_tBossName ~= nil then
        self.m_tBossName:destroy()
        self.m_tBossName = nil
    end
end

-------------------------------------私有方法模块End----------------------------------------