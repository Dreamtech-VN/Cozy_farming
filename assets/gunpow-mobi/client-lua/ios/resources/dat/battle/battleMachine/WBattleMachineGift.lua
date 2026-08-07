--WBattleMachineGift.lua
--@brief    场景机关
--@date     2016/07/06
--@note     礼物

WBattleMachineGift = {
    m_tAniFileIndex = nil,  --配置id
    m_tConfig = nil,    --配置
    m_nBattleId = nil,   --战场唯一id
    m_anim = nil,   --形象
    m_mover = nil,  --移动管理者
    m_tCollisionRang = nil, --碰撞区域
    m_bIsShowRang = false,  --是否显示碰撞区域
    m_tCollisionTable = nil,    --显示的碰撞框
    m_bAutoStandAction = true,  --自动切换待机
}

-------------------------------------公有方法模块Begin--------------------------------------

--@brief    以本表为模版创建一个新的表实例对象
--@return   新建的表实例对象
function WBattleMachineGift:new(battleId,templateId,camp,bronPos)
    WZLog("WBattleMachineGift:new",battleId,templateId,camp)
    -- WBattleGlobal:getCurrent():setBuildMonsterRecord(battleId,templateId)
    setmetatable(WBattleMachineGift,{__index = WCharacter})
    local tNewObj = {}
    setmetatable(tNewObj, { __index = WBattleMachineGift })
    tNewObj.m_nBattleId = battleId
    tNewObj.m_nPlayerId = templateId
    tNewObj.m_nCamp = camp
    
    tNewObj:parseMonsterData()
    tNewObj.m_bIsInCtb = false--不参与ctb轮转
    tNewObj.m_bOffHurt = true --不参与伤害计算
    tNewObj.m_bOffCollision = true --不参与子弹碰撞计算
    tNewObj.m_tSkillList = tNewObj.m_tSkillParam ~= -1 and tNewObj.m_tSkillParam[1] or {10410}
       
    tNewObj.m_bActiveAttack = false
    tNewObj.m_bPassiveAttack = false
    tNewObj.m_tActiveSkillList = {}
    tNewObj.m_tPassiveSkillList = {}
    tNewObj.m_tCollisionCharacters = {}
    tNewObj:addCollisionCharas(WBattleGlobal:getCurrent():getHeroList())
    --设置当前方向向左
    tNewObj.m_nCurDirect = 0

    tNewObj:_init()
    local firstPos = bronPos or {x = 900,y = 800}
    tNewObj:setPosition(Vector2:create(firstPos.x, firstPos.y + 250))
    
    return tNewObj
end

--@brief 读取怪物模板配置
function WBattleMachineGift:parseMonsterData()
    local monsterData =  BossData["id_"..self.m_nPlayerId]
    self.m_tAniFileIndex =  "machine_1006"

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
function WBattleMachineGift:getAniFileIndex()
    return self.m_tAniFileIndex
end

--@brief 道具刷新
function WBattleMachineGift:update(dt)
    if self:isDead() then
        self:updateDeadAct()
        return
    end

    WCharacter.update(self,dt)

    if self:getAnimation():isCurrentAnimationDone() == true and self.m_bAutoStandAction then
        self:getAnimation():play(self:getNormalAnimationName(), true)
    end

    self:checkCollision()
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
function WBattleMachineGift:checkCollision()
    local list = WBattleGlobal:getCurrent():getHeroList()
    for id,hero in pairs(list) do
        if not hero:isDead() then
            local pos = hero:getPosition()
            local animPos = self.m_anim:getPosition()
            local rangList = self:getCollisionRang()
            local collision = false
            for id,rang in pairs(rangList) do
                local rect = {x = animPos.x+rang.m_fXOffset - rang.m_fWidth*0.5,y = animPos.y+rang.m_fYOffset,w = rang.m_fWidth,h=rang.m_fHeight}
                local circle = {x = pos.x,y=pos.y,r = 20}
                if BattleCommon:rectCircleOverLap(rect,circle) then
                    collision = true
                end
            end

            if collision then
                self:doEffect(hero)
                break
            end
        end
    end
end


function WBattleMachineGift:doEffect(hero)
    if self.m_bEffectDone then
        return
    else
        self.m_bEffectDone = true
    end
    --@brief    事件处理
    local randomNum = WBattleGlobal:getCurrent():getBattleRandNum()
    local skillIndex = randomNum % #self.m_tSkillList + 1
    local skillId = self.m_tSkillList[skillIndex]
    

    local skillConfig = GDatatab_skill["id_"..skillId]
    if not skillConfig then 
        return
    end
    local targetList = BattleChooseMethod:chooseTarget(self,{[1]=skillConfig.choose,[2]=skillConfig.chooseParm[1],[3]=skillConfig.chooseParm[2]})
    --目标选择过滤 没目标 不需要执行
    if not targetList then
        return
    end
    local emptyTarget = true
    for i,v in pairs(targetList) do
        emptyTarget = false
    end
    if emptyTarget then
        return
    end
    WZLog("WBattleMachineGift:doEffect",skillId)
    -- skillId = 10409
    local targetIds = {}
    for i,v in pairs(targetList) do
        table.insert(targetIds,v:getBattleId())
    end
    if WBattleGlobal:getCurrent():isHostControl() then
        WZLog("WBattleMachineGift:doEffect send")
        ProtocolProcessorBattleInterface:send_BATTLE_SkillEquip(WBattleGlobal:getCurrent():getBattleId(), self.m_nBattleId, skillId,targetIds)
    end

    if skillId ~= 10410 and skillId ~= 10407 then
        self:makeHurt()
    end
    --冰冻
    if skillId == 10409 and WBattleGlobal:getCurrent():isMyTurn() then
        self.m_bIsEndCurRound = true
    end
    if skillId ~= 1408 then
        local msg = MsgManager:createMsg(BattleMsgBossMapSkill)
        msg.m_nId = nil --不发协议
        msg.m_tOwner = self
        msg.m_tSkillTypeList = {[1]=SkillTypeConfig.HIT_DO_EFFECT}
        msg.m_nSkillId = skillId
        msg.m_nTakeEffectType = TakeEffectType.USE
        msg.m_tCallBackFunc = {self.doSuicide,self}
        MsgManager:pushNonBlockMsg(msg)
    end
end

function WBattleMachineGift:makeHurt()
    local tHurtCharas, tHurtValues, tDistance, tCritType, tHurtRatios = BattleMethod:checkMeleeHurt(self,150)

    if BattleCommon:tableLen(tHurtCharas) > 0 then
        BattleMethod:charaAddHurtValue(self,tHurtCharas,tHurtValues,tHurtRatios)
        BattleMethod:sendHurtProtocol(self,tHurtCharas, tHurtValues, tDistance, tCritType)
        BattleMethod:addToHurtList(self,tHurtCharas)
    end
end

--@brief    初始化基础动画
function WBattleMachineGift:initAnim()
    WZLog("WBattleMachineGift:initAnim")
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

--出现动画
function WBattleMachineGift:playAppearAction()
    self:getAnimation():play(self:getAppearAnimationName(), false)
end

--@brief 设置碰撞
function WBattleMachineGift:setMover()
    --小怪Mover
    self.m_mover = WDMoveEntity:create(self:getAnimation():getAnimNode())
    self.m_mover:setAdjustChild(true)
    self.m_mover:retain()

    local center = Vector2:create(0,50)
    self.m_mover:setMoverCenter(center)
    self.m_mover:setMoverRadius(10)
end

--@brief    获取缩放系数
function WBattleMachineGift:getScale()
    return self.m_anim:getScale()
end

--@brief    设置缩放系数
function WBattleMachineGift:setScale(scale)
    self.m_anim:setScale(scale)
end


--@brief    获取移动控制对象
--@return   #1:WDMove移动控制对象
function WBattleMachineGift:getMover()
    return self.m_mover
end

--@brief 获取形象名字
function WBattleMachineGift:getAnimationName(index)
    return self.animNormal[index] or self.animNormal["standby"]
end

--@brief 获取形象
function WBattleMachineGift:getAnimation()
    return self.m_anim
end

function WBattleMachineGift:getAnimScale()
    return self:getConfig().scale and self:getConfig().scale or 1
end

--@brief    添加碰撞矩形
function WBattleMachineGift:changeRectCollision()
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
            WZLog("WBattleMachineGift:changeRectCollision two", info.width, info.height,info.x, info.y, scale)
        end
    end
end

--@brief    添加矩形碰撞范围
--@param    width,height:宽高
--@param    xOffset,yOffset:x,y偏移量
--@note     偏移量的参考点是character的中心点
function WBattleMachineGift:addRectCollision(width,height,xOffset,yOffset)
    if self.m_tCollisionRang == nil then
        self.m_tCollisionRang = {}
    end

    local tRang = CollisionRang:new()
    tRang.m_nType = 1
    tRang.m_fWidth = width
    tRang.m_fHeight = height
    tRang.m_fXOffset = xOffset
    tRang.m_fYOffset = yOffset
    table.insert(self.m_tCollisionRang,tRang)
end



--@brief 获取中心点
function WBattleMachineGift:getCenterPos()
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
function WBattleMachineGift:getPosition()
    if not self.m_anim then
        return GlobalMethod:ccp(0,0)
    end
    return self.m_anim:getPosition()
end

--@brief    设置当前的位置
--@param    tPos 当前位置
function WBattleMachineGift:setPosition(tPos)
    if self.m_mover ~= nil then
        self.m_mover:setMoverPosition(Vector2:create(tPos.x,tPos.y))
    end
    if self.m_anim ~= nil then
        self.m_anim:setPosition(Vector2:create(tPos.x,tPos.y))
    end
end

--@brief 
function WBattleMachineGift:setRotation(rota)
    if self.m_anim then
        self.m_anim:getAnimNode():setRotation(rota)
    end
end

--@brief 
function WBattleMachineGift:getRotation(rota)
    if self.m_anim then
        return self.m_anim:getAnimNode():getRotation()
    end
    return 0
end

--@brief 获取配置
function WBattleMachineGift:getConfig()
    if not self.m_tConfig then
        local config = BattleMachineConfig[self.m_tAniFileIndex]
        self.m_tConfig = config
        self.m_tbulletPosOffset = config.bulletPosOffset or {x=0,y=0}
    end
    
    return self.m_tConfig
end

--@brief    获取对象类型
--@return   #1:对象类型(0:player,1:guai)
function WBattleMachineGift:getType()
    return 100
end

--@brief    获取子弹碰撞半径
--@return   #1:子弹碰撞半径
function WBattleMachineGift:getRadiusForBulletCollision()
    return 0
end

--@brief    获得碰撞范围
--@return   #1:碰撞范围
function WBattleMachineGift:getCollisionRang()
    return self.m_tCollisionRang
end

--@brief 射击点
function WBattleMachineGift:getShootPos(target)
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
function WBattleMachineGift:getAutoStandAction()
    return self.m_bAutoStandAction
end

--@brief 设置自动切换待机动画
--@return
function WBattleMachineGift:setAutoStandAction(val)
    self.m_bAutoStandAction = val
end

--@brief    获取待机动画
function WBattleMachineGift:getAppearAnimationName()
    return self:getAnimationName("skill")
end

--@brief    获取待机动画
function WBattleMachineGift:getNormalAnimationName()
    return self:getAnimationName("standby")
end

--@brief    获取受伤动画
function WBattleMachineGift:getHurtAnimationName()
    return self:getAnimationName("hurt")
end

--@brief    获取死亡动画
function WBattleMachineGift:getDeadAnimationName()
    return self:getAnimationName("dead")
end

--@brief 设置死亡
function WBattleMachineGift:setDead(bDead, note)
    WZLog("WBattleMachineGift:setDead one", tostring(note))
    if self.m_bIsDead ~= bDead then
        self.m_bIsDead = bDead
    end

    if self.m_bIsDead then
        if WBattleGlobal:getCurrent():isSingleStage() then
            self:setServerDead(true)
        end
        WCharacter.clearAllBuff(self)
        self:getAnimation():play(self:getAnimationName("dead"),false)
    else
        self:getAnimation():play(self:getAnimationName("standby"),true)
    end
end

--@brief 自杀
function WBattleMachineGift:doSuicide()
    self:setDead(true,"doSelfKill")
    -- WBattleGlobal:getCurrent():setHoldMonsterRecord(self.m_nBattleId)
    if WBattleGlobal:getCurrent():isSingleStage() then
        self:setServerDead(true)
    else
        if WBattleGlobal:getCurrent():isHostControl() then
            ProtocolProcessorBattleInterface:send_BATTLE_OutOfScene(WBattleGlobal:getCurrent().m_tMakePairOk.battleId, self:getBattleId() ,WBattleGlobal:getCurrent():getCurrentCharacterId(), self:getType(), 1 )
        end
    end

    if self.m_bIsEndCurRound then
        if WBattleGlobal:getCurrent():isMyTurn() then
            WndBattleHud:resetSkill(true,"giftHide")
            WndBattleHud:resetItem(true)
            WBattleGlobal:getCurrent():endCurRound(WBattleGlobal:getCurrent():getMyBattleId(),"gift")
        end
    end
end

--@brief 获取死亡标记
function WBattleMachineGift:isDead()
    return self.m_bIsDead
end

--@brief 死亡过程
function WBattleMachineGift:updateDeadAct()
    if self:isServerDead() and self:getAnimation():isCurrentAnimationDone() == true then
        WZLog("WBattleMachineGift:updateDeadAct")
        WBattleGlobal:getCurrent():removeMachine(self.m_nBattleId)
    end
end
--@--brief wbattleglobal调用
function WBattleMachineGift:destroy()
    WZLog("WBattleMachineGift:destroy")
    if self:getAnimation():getAnimNode() then
        self:getAnimation():getAnimNode():removeFromParentAndCleanup(false)
        WZLog("WBattleMachineGift:release")
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
function WBattleMachineGift:getCenterPos()
   return self:getPetAttackPos()
end

function WBattleMachineGift:getPetAttackPos()
    local size = self:getConfig().animSize
    do
        local offsetH = size.height* 0.5
        return {x=self:getPosition().x,y=self:getPosition().y}
    end

end

-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------

--@brief    初始化对象
function WBattleMachineGift:_init()
    WCharacter._init(self)

    self:_setAnimConfig()
    self:initAnim()
    self.m_bIsShowRang = true
end

--@brief 解析动画名字
function WBattleMachineGift:_setAnimConfig()
    local animationInfo = self:getConfig()["animNormal"]
    self.animNormal = {}
    if animationInfo ~= nil then
        local animationInfoList = SplitStringWithSeparator(animationInfo, "|")
        for id, info in pairs(animationInfoList) do
            StringIntsertToTable(self.animNormal,info)
        end
    end
end

function WBattleMachineGift:_addBossName()
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
function WBattleMachineGift:getNameLayerOffset()
    return {x = 0, y = -10}
end

--@brief    获得人物名称信息的显示
--@return   #1, 人物名称信息的显示
function WBattleMachineGift:getPlayerNameIcon()
    return self.m_tBossName
end

--@brief    清理人物名称信息的显示
function WBattleMachineGift:clearPlayerNameIcon()
   if self.m_tBossName ~= nil then
        self.m_tBossName:destroy()
        self.m_tBossName = nil
    end
end

--@brief    添加人物碰撞列表
--@param    tCharas:人物碰撞列表
function WBattleMachineGift:addCollisionCharas(tCharas)
    if self.m_tCollisionCharacters == nil then
        self.m_tCollisionCharacters = {}
    end
    
    table.insert(self.m_tCollisionCharacters,tCharas)
end

-------------------------------------私有方法模块End----------------------------------------