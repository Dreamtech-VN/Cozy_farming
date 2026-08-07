--WBattleMachineLight.lua
--@brief    场景机关
--@date     2016/07/06
--@note     聚光灯

WBattleMachineLight = {
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
function WBattleMachineLight:new(battleId,templateId,camp,bronPos)
    WZLog("WBattleMachineLight:new",battleId,templateId,camp)
    -- WBattleGlobal:getCurrent():setBuildMonsterRecord(battleId,templateId)
    setmetatable(WBattleMachineLight,{__index = WCharacter})
    local tNewObj = {}
    setmetatable(tNewObj, { __index = WBattleMachineLight })
    tNewObj.m_nBattleId = battleId
    tNewObj.m_nPlayerId = templateId
    tNewObj.m_nCamp = camp
    
    tNewObj:parseMonsterData()
    tNewObj.m_bIsInCtb = false--不参与ctb轮转
    tNewObj.m_bOffHurt = true --不参与伤害计算
    tNewObj.m_bOffCollision = true --不参与子弹碰撞计算

    tNewObj.m_nLightIndex = tNewObj.m_tSkillParam ~= -1 and tNewObj.m_tSkillParam[1][1] or 1
       
    tNewObj.m_bActiveAttack = false
    tNewObj.m_bPassiveAttack = false
    tNewObj.m_tActiveSkillList = {}
    tNewObj.m_tPassiveSkillList = {}
    --设置当前方向向左
    tNewObj.m_nCurDirect = 0

    tNewObj:_init()
    local firstPos = bronPos or {x = 900,y = 800}
    tNewObj:setPosition(Vector2:create(firstPos.x, firstPos.y + 250))
    
    return tNewObj
end

--@brief 读取怪物模板配置
function WBattleMachineLight:parseMonsterData()
    local monsterData =  BossData["id_"..self.m_nPlayerId]
    self.m_tAniFileIndex =  "machine_1007"

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
function WBattleMachineLight:getAniFileIndex()
    return self.m_tAniFileIndex
end

--@brief 道具刷新
function WBattleMachineLight:update(dt)
    if self:isDead() then
        self:updateDeadAct()
        return
    end

    WCharacter.update(self,dt)

    if self:getAnimation():isCurrentAnimationDone() == true and self.m_bAutoStandAction then
        self:getAnimation():play(self:getNormalAnimationName(), true)
    end

    -- self:checkCollision()
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
function WBattleMachineLight:checkCollision()
    local list = WBattleGlobal:getCurrent():getHeroList()
    local collision = 0
    for id,hero in pairs(list) do
        if not hero:isDead() and not hero.m_bLoseNet and hero:getCamp() == 0 then
            local pos = hero:getPosition()
            local animPos = self.m_anim:getPosition()
            local rangList = self:getCollisionRang()
            for id,rang in pairs(rangList) do
                local rect = {x = animPos.x+rang.m_fXOffset - rang.m_fWidth*0.5,y = animPos.y+rang.m_fYOffset,w = rang.m_fWidth,h=rang.m_fHeight}
                local circle = {x = pos.x,y=pos.y,r = 20}
                if BattleCommon:rectCircleOverLap(rect,circle) then
                    collision = collision + 1
                end
            end
        end
    end
    return collision
end


function WBattleMachineLight:doEffect()
    local boss = WBattleGlobal:getCurrent():getBossArray()[1]
    if boss then
        --去除
        local msg = MsgManager:createMsg(BattleMsgBossMapSkill)
        msg.m_nId = nil --不发协议
        msg.m_tOwner = boss
        msg.m_tSkillTypeList = {[1]=SkillTypeConfig.HIT_DO_EFFECT}
        msg.m_nSkillId = 10411
        msg.m_nTakeEffectType = TakeEffectType.USE
        MsgManager:pushNonBlockMsg(msg)
        if WBattleGlobal:getCurrent():isHostControl() then
            WZLog("WBattleMachineLight:doEffect",boss:getBattleId())
            ProtocolProcessorBattleInterface:send_BATTLE_SkillEquip(WBattleGlobal:getCurrent():getBattleId(), boss:getBattleId(), 10411 ,{})
        end
    end
    --清理聚关灯
    for i,v in pairs (WBattleGlobal:getCurrent():getMachinesList()) do
        if v.m_nMonsterType == MonsterType.BOSS_LIGHT then
            v:doSuicide()
        end
    end
end

--@brief    初始化基础动画
function WBattleMachineLight:initAnim()
    WZLog("WBattleMachineLight:initAnim")
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

    --self:getAnimation():play(self:getAppearAnimationName(), false)
end

--出现动画
function WBattleMachineLight:playAppearAction()
    self:getAnimation():play(self:getAppearAnimationName(), false)
end

--@brief 设置碰撞
function WBattleMachineLight:setMover()
    --小怪Mover
    self.m_mover = WDMoveEntity:create(self:getAnimation():getAnimNode())
    self.m_mover:setAdjustChild(true)
    self.m_mover:retain()

    local center = Vector2:create(0,50)
    self.m_mover:setMoverCenter(center)
    self.m_mover:setMoverRadius(10)
end

--@brief    获取缩放系数
function WBattleMachineLight:getScale()
    return self.m_anim:getScale()
end

--@brief    设置缩放系数
function WBattleMachineLight:setScale(scale)
    self.m_anim:setScale(scale)
end


--@brief    获取移动控制对象
--@return   #1:WDMove移动控制对象
function WBattleMachineLight:getMover()
    return self.m_mover
end

--@brief 获取形象名字
function WBattleMachineLight:getAnimationName(index)
    return self.animNormal[index] or self.animNormal["standby"]
end

--@brief 获取形象
function WBattleMachineLight:getAnimation()
    return self.m_anim
end

function WBattleMachineLight:getAnimScale()
    return self:getConfig().scale and self:getConfig().scale or 1
end

--@brief    添加碰撞矩形
function WBattleMachineLight:changeRectCollision()
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
            WZLog("WBattleMachineLight:changeRectCollision two", info.width, info.height,info.x, info.y, scale)
        end
    end
end

--@brief    添加矩形碰撞范围
--@param    width,height:宽高
--@param    xOffset,yOffset:x,y偏移量
--@note     偏移量的参考点是character的中心点
function WBattleMachineLight:addRectCollision(width,height,xOffset,yOffset)
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
function WBattleMachineLight:getCenterPos()
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
function WBattleMachineLight:getPosition()
    if not self.m_anim then
        return GlobalMethod:ccp(0,0)
    end
    return self.m_anim:getPosition()
end

--@brief    设置当前的位置
--@param    tPos 当前位置
function WBattleMachineLight:setPosition(tPos)
    if self.m_mover ~= nil then
        self.m_mover:setMoverPosition(Vector2:create(tPos.x,tPos.y))
    end
    if self.m_anim ~= nil then
        self.m_anim:setPosition(Vector2:create(tPos.x,tPos.y))
    end
end

--@brief 
function WBattleMachineLight:setRotation(rota)
    if self.m_anim then
        self.m_anim:getAnimNode():setRotation(rota)
    end
end

--@brief 
function WBattleMachineLight:getRotation(rota)
    if self.m_anim then
        return self.m_anim:getAnimNode():getRotation()
    end
    return 0
end

--@brief 获取配置
function WBattleMachineLight:getConfig()
    if not self.m_tConfig then
        local config = BattleMachineConfig[self.m_tAniFileIndex]
        self.m_tConfig = config
        self.m_tbulletPosOffset = config.bulletPosOffset or {x=0,y=0}
    end
    
    return self.m_tConfig
end

--@brief    获取对象类型
--@return   #1:对象类型(0:player,1:guai)
function WBattleMachineLight:getType()
    return 100
end

--@brief    获取子弹碰撞半径
--@return   #1:子弹碰撞半径
function WBattleMachineLight:getRadiusForBulletCollision()
    return 0
end

--@brief    获得碰撞范围
--@return   #1:碰撞范围
function WBattleMachineLight:getCollisionRang()
    return self.m_tCollisionRang
end

--@brief 射击点
function WBattleMachineLight:getShootPos(target)
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
function WBattleMachineLight:getAutoStandAction()
    return self.m_bAutoStandAction
end

--@brief 设置自动切换待机动画
--@return
function WBattleMachineLight:setAutoStandAction(val)
    self.m_bAutoStandAction = val
end

--@brief    获取待机动画
function WBattleMachineLight:getAppearAnimationName()
    return self:getAnimationName("skill"..self.m_nLightIndex)
end

--@brief    获取待机动画
function WBattleMachineLight:getNormalAnimationName()
    return self:getAnimationName("standby"..self.m_nLightIndex)
end

--@brief    获取受伤动画
function WBattleMachineLight:getHurtAnimationName()
    return self:getAnimationName("hurt"..self.m_nLightIndex)
end

--@brief    获取死亡动画
function WBattleMachineLight:getDeadAnimationName()
    return self:getAnimationName("dead"..self.m_nLightIndex)
end

--@brief 设置死亡
function WBattleMachineLight:setDead(bDead, note)
    WZLog("WBattleMachineLight:setDead one", tostring(note))
    if self.m_bIsDead ~= bDead then
        self.m_bIsDead = bDead
    end

    if self.m_bIsDead then
        if WBattleGlobal:getCurrent():isSingleStage() then
            self:setServerDead(true)
        end
        WCharacter.clearAllBuff(self)
        self:getAnimation():play(self:getDeadAnimationName(),false)
    else
        self:getAnimation():play(self:getNormalAnimationName(),true)
    end
end

--@brief 自杀
function WBattleMachineLight:doSuicide()
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
function WBattleMachineLight:isDead()
    return self.m_bIsDead
end

--@brief 死亡过程
function WBattleMachineLight:updateDeadAct()
    if self:isServerDead() and self:getAnimation():isCurrentAnimationDone() == true then
        WZLog("WBattleMachineLight:updateDeadAct")
        WBattleGlobal:getCurrent():removeMachine(self.m_nBattleId)
    end
end
--@--brief wbattleglobal调用
function WBattleMachineLight:destroy()
    WZLog("WBattleMachineLight:destroy")
    if self:getAnimation():getAnimNode() then
        self:getAnimation():getAnimNode():removeFromParentAndCleanup(false)
        WZLog("WBattleMachineLight:release")
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
function WBattleMachineLight:getCenterPos()
   return self:getPetAttackPos()
end

function WBattleMachineLight:getPetAttackPos()
    local size = self:getConfig().animSize
    do
        local offsetH = size.height* 0.5
        return {x=self:getPosition().x,y=self:getPosition().y}
    end

end

-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------

--@brief    初始化对象
function WBattleMachineLight:_init()
    WCharacter._init(self)

    self:_setAnimConfig()
    self:initAnim()
    self.m_bIsShowRang = true
end

--@brief 解析动画名字
function WBattleMachineLight:_setAnimConfig()
    local animationInfo = self:getConfig()["animNormal"]
    self.animNormal = {}
    if animationInfo ~= nil then
        local animationInfoList = SplitStringWithSeparator(animationInfo, "|")
        for id, info in pairs(animationInfoList) do
            StringIntsertToTable(self.animNormal,info)
        end
    end
end

function WBattleMachineLight:_addBossName()
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
function WBattleMachineLight:getNameLayerOffset()
    return {x = 0, y = -10}
end

--@brief    获得人物名称信息的显示
--@return   #1, 人物名称信息的显示
function WBattleMachineLight:getPlayerNameIcon()
    return self.m_tBossName
end

--@brief    清理人物名称信息的显示
function WBattleMachineLight:clearPlayerNameIcon()
   if self.m_tBossName ~= nil then
        self.m_tBossName:destroy()
        self.m_tBossName = nil
    end
end

-------------------------------------私有方法模块End----------------------------------------