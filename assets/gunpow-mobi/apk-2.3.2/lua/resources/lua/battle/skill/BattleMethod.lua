--BattleMethod.lua
--@brief    战斗公用方法定义
--@date     2015/08/14
--@note     定义全局战斗公用方法

BattleMethod =
{
}

--========================================子弹Begin=======================================================================
--@brief 可以反射子弹
--@param bullet 子弹
--@param charaId 反射盾或龙卷风 拥有者id
--@param reflectType 反射类型 1-反射盾 2-龙卷风
function BattleMethod:canReflectBullet(bullet,charaId,reflectType)
    WZLog("BattleMethod:canReflect",reflectType)
    local canReflect = true
    --副本怪物过滤（boss子弹不反弹）
    if not WBattleGlobal:getCurrent():isSingleStage() and not WBattleGlobal:getCurrent():isDoubleTowerStage() then
        if bullet.m_ownerChara:getType() ~= 0 and bullet.m_ownerChara.m_tBoss == nil and not bullet.m_ownerChara:getIsKid() and not bullet.m_ownerChara:getIsSubHero() then
            canReflect = false
        end

        --组队副本4
        if math.floor(WBattleGlobal:getCurrent().m_tMakePairOk.mapId / 100) == 204 then
            canReflect = false
        end

        --组队觉醒难度镜像玩家子弹免疫龙卷风
        if WBattleGlobal:getCurrent():isTeamStage() then 
            local difficulty = GDatatab_team_map["id_" .. WBattleGlobal:getCurrent().m_tMakePairOk.mapId].difficulty
            if difficulty == 4 and bullet.m_ownerChara.m_nCamp == 1 and reflectType == 2 and bullet.m_ownerChara:getType() == 0 then 
                canReflect = false
            end
        end
        --心魔怪子弹免疫龙卷风
        if bullet.m_ownerChara:isDevilGuai() and reflectType == 2 then 
            canReflect = false 
        end

        --怪兽模式
        if WBattleGlobal:getCurrent().m_tMakePairOk.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_GS and bullet.m_ownerChara.m_nCamp == 1 and reflectType == 2 then
            canReflect = false
        end
    end
    --皮肤大招-花木兰免疫龙卷风和反射盾
    if bullet.m_bIsSkinBigSkill and bullet.m_nSkinBigSkill == 3061 then 
        canReflect = false 
    end

    if canReflect and bullet:checkCanReflect(charaId,reflectType) then
        return true
    end
    return false
end
--@biref 获取怪物子弹数据
--@param bulletId 子弹数据表id
--@param bulletAtk 子弹攻击力
--@return bulletInfo 子弹数据结构
function BattleMethod:getBossBulletInfo(bulletId)
    local result = {}
    local bulletInfo = BulletInfoConfig["id_"..bulletId]
    if not bulletInfo then
        return result
    end

    local bulletAnimMainName = bulletInfo.bulletAnimMainName
    local bulletAnimFlyName = bulletInfo.bulletAnimFlyName
    local bulletAnimScale = bulletInfo.bulletAnimScale / 100
    local bulletType = bulletInfo.bulletType
    local checkCharacterCollisionRadius = bulletInfo.checkCharacterCollisionRadius
    local isPenetrateMap = bulletInfo.isPenetrateMap == 1
    local attTimes = bulletInfo.attTimes
    local isIgnoreDef = bulletInfo.isIgnoreDef == 1
    local bulletAnimDefaultDirection = bulletInfo.bulletAnimDefaultDirection
    local isNeedExplode = bulletInfo.isNeedExplode == 1
    local isNeedHurt = bulletInfo.isNeedHurt == 1
    local scatterNum = bulletInfo.scatterNum
    local fireType = bulletInfo.fireType or -1
    local boomType = bulletInfo.boomType or -1
    local offset = {x=0, y=0}
    if bulletInfo.offsetX ~= 0 or bulletInfo.offsetY ~= 0 then
        offset =  {x=bulletInfo.offsetX, y=bulletInfo.offsetY}
    end
    

    result.m_bIsOldBulletAnim = false
    
    result.m_sBulletAnimMainName = bulletAnimMainName
    result.m_sBulletAnimFlyName = bulletAnimFlyName
    result.m_sWeaponName = weaponName
    result.m_tWeaponAnim = {weapon=result.m_sWeaponName}
    result.m_nBulletAnimScale = bulletAnimScale
    result.m_nBulletType = bulletType
    result.m_nCheckCharacterCollisionRadius = checkCharacterCollisionRadius
    result.m_bIsPenetrateMap = isPenetrateMap
    result.m_nAttTimes = attTimes
    result.m_bIsIgnoreDef = isIgnoreDef
    result.m_bBulletAnimFlipX = bulletAnimDefaultDirection == DirectionType.LEFT
    result.m_bIsNeedExplode = isNeedExplode
    result.m_nBulletAnimDefaultDirection = bulletAnimDefaultDirection
    -- result.m_nEveryBulletShootDeltaTime =  0.15
    result.m_bIsNeedHurt = isNeedHurt
    result.m_nScatterNum = scatterNum
    result.m_tOffset = offset
    result.m_nFireType = fireType
    result.m_nBoomType = boomType
    --穿透怪物
    result.m_bIsPenetrateMonster = bulletInfo.isPenetrateMonster == 1 and true or false
    
    if bulletType ~= BulletType.LINE then
        result.m_tAcceleration = acceleration or {x=WBattleGlobal:getCurrent():getWind().x+BattleConstants.g_nFlyGravity.x,y=WBattleGlobal:getCurrent():getWind().y+BattleConstants.g_nFlyGravity.y}
    else
        result.m_tAcceleration = {x=0,y=0}
    end

    return result
end

--@brief    创建子弹动画
function BattleMethod:createBulletAnim(bulletInfo)
    local bullet = nil
   
    bullet = BattleAnimation:createAnimation(bulletInfo.m_sBulletAnimMainName, true)
    
    bullet:setScale(bulletInfo.m_nBulletAnimScale)
    
    if bulletInfo.m_sBulletAnimExplodeWeaponName ~= "" then
        bullet:addAnimation("blasting",{weapon=bulletInfo.m_sBulletAnimExplodeWeaponName}, 0.1, true,IWCO_BATTLEEFFICIENTS)
    end
    
    return bullet
end

--@brief    计算伤害(怪物子弹)
--@return   #1：伤害(废弃莫用)
function BattleMethod:getHurt(attacker,chara,isIgnoreDef)
    WZLog("BattleMethod:getHurt")
    local bullet = WBattleGlobal:getCurrent():getBossBulletByIndex(1)
    local bulletPos = bullet:getMover():getMoverPosition()
    local charaPos = chara:getCenterPos()
    
    local hurt = 0
    local tHurtCharas, tHurtValues, tDistance, tCritType, tHurtRatio
    if chara:getIsInvincible() then
        hurt = 1
    elseif isIgnoreDef == true then
        hurt = attacker.m_nAttack
    else
        local AttackOriginal = attacker:getAttack(true)
       
        WZLog("BattleMethod:getHurt AttackOriginal = "..AttackOriginal.." self.m_nAttack = "..attacker.m_nAttack)
        tHurtCharas, tHurtValues, tDistance, tCritType, tHurtRatio = WBossBullet:calculateHurt(0,attacker,chara)
    end
    
    return tHurtCharas, tHurtValues, tDistance, tCritType, tHurtRatio
end

--@brief    发送受伤协议（子弹伤害）
function BattleMethod:sendHurtProtocol(attacker, charas, values,distance,critType,noProDefense)
    WZLog("BattleMethod:sendHurtProtocol one",tostring(WBattleGlobal:getCurrent():isHostControl()),tostring(charas))
    if not WBattleGlobal:getCurrent():isHostControl() then
        --针对3016,3017皮肤大招的时候没有发送伤害协议的问题
        if attacker:getType() ~= 0 or attacker:isRobot() then 
            --检测职业反伤
            if charas then 
                BattleMethod:checkProfessionThorns(attacker, charas, values, attacker:getBattleId(), noProDefense)
            end
            return
        end
    end
    if charas == nil then
        return
    end
    local battleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
    local hero = attacker
    --检测职业反伤
    BattleMethod:checkProfessionThorns(attacker, charas, values, hero:getBattleId(), noProDefense)

    if attacker:getType() == 0 then
        WZLog("BattleMethod:sendHurtProtocol two-1", tostring(charas), tostring(hero:getBattleId()), tostring(hero:isCanControl()), tostring(hero.m_bLoseNet))
        if charas == nil or not (hero:isCanControl() or hero.m_bLoseNet) then
            return
        end

        WZLog("BattleMethod:sendHurtProtocol two-2",tostring(charas),tostring(values),tostring(distance),tostring(critType))
        WBattleGlobal:getCurrent():sendHurtProtocol(hero:getBattleId(),charas,values,distance,critType)
        --发送心魔伤害
        self:sendDevilTransHurt(attacker, charas, values,distance,critType)
    else
        nCurrentId = attacker:getBattleId()
        WBattleGlobal:getCurrent():sendHurtProtocol(nCurrentId,charas,values,distance,critType)
        --发送心魔伤害
        self:sendDevilTransHurt(attacker, charas, values,distance,critType)
    end

end
--========================================子弹End=========================================================================

--@brief    计算近攻伤害
--@return   #1：伤害
function BattleMethod:getMeleeHurt(chara, monster)
    local guai = monster
    local guaiPos = guai:getMover() and guai:getMover():getMoverPosition() or guai:getPosition()
    local charaPos = chara:getCenterPos()
    
    local hurt = 0
    if chara:getIsInvincible() then
        hurt = 1
    else
        hurt, critType, distanceCheck,recordRatio = WBossBullet:calculateHurt(0,monster,chara)
    end
    WZLog("BattleMethod:getMeleeHurt", tostring(chara.m_nBuffInvincibleRound), hurt)

    return hurt, critType, distanceCheck, recordRatio
end

--@brief    检查近攻伤害
--@return   #1:受伤的人物列表
--@return   #2:受伤值
function BattleMethod:checkMeleeHurt(monster,radius)
    WZLog("BattleMethod:checkMeleeHurt one")
    local guai = monster
    local tHurtCharas = {}
    local tHurtValues = {}
    local tHurtRatios = {}
    local tCritType = {}
    local tDistance = {}
    for i,charaList in pairs(guai.m_tCollisionCharacters) do
        for id,chara in pairs(charaList) do
            --玩家身上是否有免攻击效果
            local bOffCollision = chara:isInBuffState(EffectTypeConfig.IMMUNITY_ATTACK)
            if id ~= guai:getBattleId() and not bOffCollision then
                local guaiPos = guai:getMover() and guai:getMover():getMoverPosition() or guai:getPosition()
                guaiPos = {x=guaiPos.x,y=guaiPos.y}
                
                local charaPos = chara:getCenterPos()
                charaPos = Vector2:create(charaPos.x,charaPos.y)
                
                local nCheckCharacterCollisionRadius = radius and radius or guai.m_nAttackArea --guai.m_anim:getAnimNode():getContentSize().width * 1
                local isCollision = false
                if chara:getType() == 0 or chara.m_bIsGuaiWithSuit then
                    isCollision = BattleCommon:checkCircleCollosion(guaiPos,nCheckCharacterCollisionRadius * 1,charaPos,chara:getRadiusForHurt())
                    WZLog("BattleMethod:checkMeleeHurt two", nCheckCharacterCollisionRadius, tostring(BattleCommon:checkCircleCollosion(guaiPos,nCheckCharacterCollisionRadius * 1,charaPos,chara:getRadiusForHurt())))
                else
                    WZLog("BattleMethod:checkMeleeHurt two-2")
                    local collisionRang = chara:getCollisionRang()
                    charaPos = chara:getPosition()
                    isCollision =  WBullet:checkCollisionWithRang(guaiPos,nCheckCharacterCollisionRadius,charaPos,30,collisionRang,true)
                end
                if not chara:isDead() and chara:getHp() > 0 and isCollision then
                    local hurt, critType, distanceCheck, recordRatio = BattleMethod:getMeleeHurt(chara, monster)
                    tHurtCharas[id] = chara
                    tHurtValues[id] = hurt
                    tHurtRatios[id] = recordRatio
                    tCritType[id] = critType
                    tDistance[id] = distanceCheck
                end
            end
        end
    end
    return tHurtCharas, tHurtValues, tDistance, tCritType, tHurtRatios
end

--@brief    检查近攻伤害
--@return   #1:受伤的人物列表
--@return   #2:受伤值
function BattleMethod:checkMeleeHurtII(monster,chara)
    WZLog("BattleMethod:checkMeleeHurt one")
    local tHurtCharas = {}
    local tHurtValues = {}
    local tHurtRatios = {}
    local tCritType = {}
    local tDistance = {}
    local id = chara:getBattleId()

    if not chara:isDead() and chara:getHp() > 0 then
        --玩家身上是否有免攻击效果
        local bOffCollision = chara:isInBuffState(EffectTypeConfig.IMMUNITY_ATTACK)
        if not bOffCollision then 
            local hurt, critType, distanceCheck, recordRatio = BattleMethod:getMeleeHurt(chara, monster)
            tHurtCharas[id] = chara
            tHurtValues[id] = hurt
            tHurtRatios[id] = recordRatio
            tCritType[id] = critType
            tDistance[id] = distanceCheck
        end
    end
    return tHurtCharas, tHurtValues, tDistance, tCritType, tHurtRatios
end

--@brief    对英雄添加受伤数字
--@param    charas:英雄列表
--@param    hurtValue:受伤数字
function BattleMethod:charaAddHurtValue(attacker,charas,hurtValue,hurtRatios)
    WZLog("BattleMethod:charaAddHurtValue one")

    local newCharas = {}
    local newValue = {}
    local shootHero = attacker
    for id,chara in pairs(charas) do
        --WZLog("BattleMsgPlayerShoot:charaAddHurtValue", tostring(id), tostring(chara.m_animPlayerShield), tostring(hurtValue[id]))
        chara:markHurt(hurtValue[id],attacker,nil,nil,nil,hurtRatios[id])
        if hurtValue[id] ~= -1 and hurtValue[id] ~= 0 then
            newCharas[id] = chara
            newValue[id] = hurtValue[id]
        end
        if hurtValue[id] ~= nil and hurtValue[id] > 0 then 
            --添加心魔伤害转移
            if chara:isInBuffState(EffectTypeConfig.HURT_TRANS) and chara:isDevilGuai() and shootHero:getBattleId() ~= chara:getDevilOwnId() then
                local devilOwnHero = WBattleGlobal:getCurrent():getCharacterWithId(chara:getDevilOwnId())
                if not devilOwnHero:isDead() then 
                    devilOwnHero:markHurt(hurtValue[id],attacker,nil,nil,nil,hurtRatios[id], true)
                end
            end
        end
    end

    WZLog("BattleMethod:charaAddHurtValue", Serialize(newValue))
    return newCharas,newValue
end


--@brief  等待技能受伤
function BattleMethod:waitForSkillHurt(attacker,targetHeroList)
    WZLog("BattleMethod:waitForSkillHurt")
   
    self:addToHurtList(attacker,targetHeroList)

    local tHurtCharas, tHurtValues, tDistance, tCritType, tHurtRatios = self:checkSkillHurt(attacker,targetHeroList)
    self:charaAddHurtValue(attacker,tHurtCharas,tHurtValues,tHurtRatios)
    self:sendHurtProtocol(attacker,tHurtCharas, tHurtValues, tDistance, tCritType)
    return true
end

--@brief    检查怪物技能伤害
function BattleMethod:checkSkillHurt(attacker,targetList)
    local tHurtCharas = {}
    local tHurtValues = {}
    local tHurtRatios = {}
    local tCritType = {}
    local tDistance = {}
    for id, targetHero in pairs(targetList) do
        --被放逐不受攻击状态
        local bOffCollision = targetHero:isInBuffState(EffectTypeConfig.IMMUNITY_ATTACK)
        if not bOffCollision then 
            local hurt = 0
            hurt, critType, distanceCheck,recordRatio = WBossBullet:calculateHurt(0,attacker,targetHero)

            tHurtCharas[id] = targetHero
            tHurtValues[id] = hurt
            tHurtRatios[id] = recordRatio
            tCritType[id] = critType
            tDistance[id] = distanceCheck
        end
    end

    return tHurtCharas, tHurtValues, tDistance, tCritType, tHurtRatios
end


--@brief  记录攻击目标
function BattleMethod:addToHurtList(attacker,targetList)
    attacker.m_bActiveAttack = true
    if attacker.m_tHitTargets == nil then
        attacker.m_tHitTargets = {}
    end
    for i,v in pairs(targetList) do
        local isExist = false
        for j, u in pairs (attacker.m_tHitTargets) do
            if v:getBattleId() == u:getBattleId() then
                isExist = true
            end
        end
        --被放逐不受攻击状态
        local bOffCollision = v:isInBuffState(EffectTypeConfig.IMMUNITY_ATTACK)
        if  isExist == false and not bOffCollision then
            table.insert(attacker.m_tHitTargets, v)
            WZLog("BattleMsgSkillEffect:addToHurtList one", v:getBattleId())
        end
    end
end

--@brief 处理buff效果
function BattleMethod:doBuffEffect(target,buff)
    for id, effectParm in pairs (buff.m_nEffect) do
        local effect = effectParm[3] .. "_" ..effectParm[4]
        if effect == EffectTypeConfig.CHANGE_ATTRIBUTE_VALUE then
            if effectParm[5] == 1 then
                local hurtNum = effectParm[6]
                -- hurtNum = target:doBuffEffect(-hurtNum)
                -- hurtNum = target:getBuffHurtNum(hurtNum)
                target:markHurt(-hurtNum, nil, nil,nil,true)
                --buff伤害记录
                -- local recordHp = target:getRealHpVal(hurtNum)
                -- WBattleGlobal:getCurrent():setBuffHurt(target:getBattleId(),id,-recordHp)
                --心魔伤害传递
                local hurtValue = -hurtNum
                if hurtValue > 0 then 
                    --添加心魔伤害转移
                    if target:isInBuffState(EffectTypeConfig.HURT_TRANS) and target:isDevilGuai() and buff.m_tUser and buff.m_tUser ~= target:getDevilOwnId() then
                        local devilOwnHero = WBattleGlobal:getCurrent():getCharacterWithId(target:getDevilOwnId())
                        if not devilOwnHero:isDead() then 
                            devilOwnHero:markHurt(hurtValue, nil, nil, nil, true, nil, true)
                        end
                    end
                end
                WZLog("BattleMethod:doBuffEffect one", hurtNum)
            end
        elseif effect == EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT then
            if effectParm[5] == 1 then
                local hurtNum = target:getMaxHp(true) * effectParm[6]/10000
                if hurtNum > 0 then
                    hurtNum = math.ceil(hurtNum)
                elseif hurtNum < 0 then
                    hurtNum = math.floor(hurtNum)
                end
                -- hurtNum = target:doBuffEffect(-hurtNum)
                -- hurtNum = target:getBuffHurtNum(hurtNum)
                target:markHurt(-hurtNum,nil,nil,nil,true)
                --buff伤害记录
                -- local recordHp = target:getRealHpVal(hurtNum)
                -- WBattleGlobal:getCurrent():setBuffHurt(target:getBattleId(),id,-recordHp)
                --心魔伤害传递
                local hurtValue = -hurtNum
                if hurtValue > 0 then 
                    --添加心魔伤害转移
                    if target:isInBuffState(EffectTypeConfig.HURT_TRANS) and target:isDevilGuai() and buff.m_tUser and buff.m_tUser ~= target:getDevilOwnId() then
                        local devilOwnHero = WBattleGlobal:getCurrent():getCharacterWithId(target:getDevilOwnId())
                        if not devilOwnHero:isDead() then 
                            devilOwnHero:markHurt(hurtValue, nil, nil, nil, true, nil, true)
                        end
                    end
                end
                WZLog("BattleMethod:doBuffEffect two", hurtNum, target:getMaxHp(true), effectParm[6])
            end
        elseif effect == EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT_ATTACK then
            if effectParm[5] == 1 then
                local hurtNum = buff.m_nUserAttack * effectParm[6]/100
                if hurtNum > 0 then
                    hurtNum = math.ceil(hurtNum)
                elseif hurtNum < 0 then
                    hurtNum = math.floor(hurtNum)
                end
                -- hurtNum = target:doBuffEffect(-hurtNum)
                -- hurtNum = target:getBuffHurtNum(hurtNum)
                target:markHurt(-hurtNum,nil,nil,nil,true)
                --buff伤害记录
                -- local recordHp = target:getRealHpVal(hurtNum)
                -- WBattleGlobal:getCurrent():setBuffHurt(target:getBattleId(),id,-recordHp)
                --心魔伤害传递
                local hurtValue = -hurtNum
                if hurtValue > 0 then 
                    --添加心魔伤害转移
                    if target:isInBuffState(EffectTypeConfig.HURT_TRANS) and target:isDevilGuai() and buff.m_tUser and buff.m_tUser ~= target:getDevilOwnId() then
                        local devilOwnHero = WBattleGlobal:getCurrent():getCharacterWithId(target:getDevilOwnId())
                        if not devilOwnHero:isDead() then 
                            devilOwnHero:markHurt(hurtValue, nil, nil, nil, true, nil, true)
                        end
                    end
                end
                WZLog("BattleMethod:doBuffEffect three", hurtNum, buff.m_nUserAttack, effectParm[6])
            end
        end
    end
end

--@brief    发送心魔伤害
function BattleMethod:sendDevilTransHurt(attacker, charas, values,distance,critType)
    -- body
    local tempCharas = {}
    local tempValues = {}
    local tempDistance = distance ~= nil and {} or nil 
    local tempCritType = critType ~= nil and {} or nil 

    local hero = attacker
    for id, chara in pairs(charas) do
        if values[id] ~= nil and values[id] > 0 then 
            --添加心魔伤害转移
            if chara:isInBuffState(EffectTypeConfig.HURT_TRANS) and chara:isDevilGuai() and hero:getBattleId() ~= chara:getDevilOwnId() then
                local devilOwnHero = WBattleGlobal:getCurrent():getCharacterWithId(chara:getDevilOwnId())
                if not devilOwnHero:isDead() then 
                    tempCharas[id] = devilOwnHero
                    tempValues[id] = values[id]
                    if distance and distance[id] then 
                        tempDistance[id] = distance[id]
                    end
                    if critType and critType[id] then 
                        tempCritType[id] = critType[id]
                    end
                end
            end
        end
    end
    if #tempCharas > 0 then 
        WBattleGlobal:getCurrent():sendHurtProtocol(hero:getBattleId(),tempCharas,tempValues,tempDistance,tempCritType)
    end
end


--@brief    检查触发职业反伤
function BattleMethod:checkProfessionThorns(attacker, charas, values, currentPlayerId, noProDefense)
    -- body
    if attacker and (attacker:getType() == CharacterType.TYPE_KID or attacker:getIsSubHero()) then 
        return 
    end
    --192版本-命运暴击伤害比率
    local fateCritRate = 0
    if attacker and attacker.getFateCritRate then 
        fateCritRate = attacker:getFateCritRate(true)
    end
    if fateCritRate > 0 then 
        --如果触发了命运回血，不进行职业反伤
        if not attacker:isFateCrit() then 
            return 
        end
    end
    for i,chara in pairs(charas) do
        local skillId = chara:getIsImmunityByPetSkill(1, EffectTypeConfig.THORNS)
        if skillId then 
            local skillInfo = GDatatab_skill["id_" .. skillId]
            if chara:getBattleId() ~= currentPlayerId and values[i] > 0 and skillInfo and noProDefense == nil then
                WZLog("BattleMethod:checkProfessionThorns two-5.3", i)
                local pos = chara:getAnimation():getPosition()
                local effectInfo = GDatatab_effect["id_" .. skillInfo.effect_id[1][1]]
                if chara.m_nHideOpecity == nil or chara.m_nHideOpecity ~= 0 then
                    BattleProfessionSkillManager:showUseName(BattleCommon:getPointTable(pos.x,pos.y + 85), skillInfo.name, 2)
                end
                WMonsterAI:castSkill(nil,
                    nil,
                    nil,
                    {[1]=SkillTypeConfig.BEHIT_DO_EFFECT},
                    nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,nil,nil,nil,nil,nil,
                    nil,
                    nil,
                    nil,nil,
                    nil,nil,nil,nil,
                    nil,
                    nil,
                    skillInfo.effect_id[1][1], TakeEffectType.INJURED,
                    nil,nil,nil,nil,
                    chara,
                    attacker
                    )
            end
        end
    end
end

--@brief    获取随机的buff
function BattleMethod:getRandomBuff(param, playerId)
    -- body
    local buffId = nil 
    local random = BattleMethod:getRandomByIndex(playerId, 1)
    local nActTotalRate = 0 
    local nCount = (#param - 4)/2
    local nIndex = 0
    local buffList = {}
    for i = 1, nCount do
        nIndex = 4 + (i - 1) * 2 + 1
        if math.fmod(nIndex, 2) == 1 and param[nIndex] then 
            nActTotalRate = nActTotalRate + param[nIndex]
        end
        nIndex = 4 + (i - 1) * 2 + 2
        if param[nIndex] then 
            local tItem = {}
            tItem[1] = nActTotalRate
            tItem[2] = param[nIndex]
            table.insert(buffList, tItem)
        end
    end

    random = random * nActTotalRate/10000

    table.sort(buffList, function (a, b)
            return a[1] < b[1]
        end)

    for i = 1, #buffList do
        if random < buffList[i][1] and buffId == nil then 
            buffId = buffList[i][2]
            break 
        end
    end

    WZLog("BattleMethod:getRandomBuff", random, nActTotalRate, Serialize(WBattleGlobal:getCurrent().m_tBattleRand))

    return buffId
end

--@brief    获取随机的buff
function BattleMethod:getRandomBuffTwo(param, playerId)
    -- body
    local buffId = nil 
    local tRandomList = WBattleGlobal:getCurrent().m_tBattleRand
    local random = BattleMethod:getRandomByIndex(playerId, math.abs(playerId)%#tRandomList+1)
    local nActTotalRate = 0 
    local nCount = (#param - 4)/2
    local nIndex = 0
    local buffList = {}
    for i = 1, nCount do
        nIndex = 4 + (i - 1) * 2 + 1
        if math.fmod(nIndex, 2) == 1 and param[nIndex] then 
            nActTotalRate = nActTotalRate + param[nIndex]
        end
        nIndex = 4 + (i - 1) * 2 + 2
        if param[nIndex] then 
            local tItem = {}
            tItem[1] = nActTotalRate
            tItem[2] = param[nIndex]
            table.insert(buffList, tItem)
        end
    end

    random = random * nActTotalRate/10000

    table.sort(buffList, function (a, b)
            return a[1] < b[1]
        end)

    for i = 1, #buffList do
        if random < buffList[i][1] and buffId == nil then 
            buffId = buffList[i][2]
            break 
        end
    end

    WZLog("BattleMethod:getRandomBuff", random, nActTotalRate, Serialize(WBattleGlobal:getCurrent().m_tBattleRand))

    return buffId
end

function BattleMethod:getRandomByIndex(playerId, nIndex)
    local tRandomList = WBattleGlobal:getCurrent().m_tBattleRand
    local num = #tRandomList
    local randomIndex = (tRandomList[nIndex] + playerId) % num
    local random = tRandomList[randomIndex + 1]
    
    WZLog("BattleMethod:getRandomByIndex", randomIndex, random)
    return random
end

--@brief    获取加成后的怒气增量
function BattleMethod:getSpAddValue(hero, angerUp)
    local weakBuff = hero:getWeakBuff()
    local nTempValue = angerUp
    if weakBuff and weakBuff.m_nEffect and #weakBuff.m_nEffect > 0 then 
        nTempValue = math.ceil(nTempValue * (1 + weakBuff.m_nEffect[1][5]/100))
    end

    return nTempValue
end

--@brief    检查反伤盾反伤
function BattleMethod:checkReflectThorns(attacker, charas, values, currentPlayerId)
    -- body
    if attacker and (attacker:getType() == CharacterType.TYPE_KID or attacker:getIsSubHero()) then 
        return 
    end
    --192版本-命运暴击伤害比率
    local fateCritRate = 0
    if attacker and attacker.getFateCritRate then 
        fateCritRate = attacker:getFateCritRate(true)
    end
    if fateCritRate > 0 then 
        --如果触发了命运回血，不进行职业反伤
        if not attacker:isFateCrit() then 
            return 
        end
    end

    --龙胆赵云反伤buff 如果触发了大招反伤buff就不再触发其他反伤buff,这里会return出去
    for i,chara in pairs(charas) do
        WZLog("BattleMethod:checkReflectThorns-2", chara:getBattleId(), currentPlayerId)
        if chara:getBattleId() ~= currentPlayerId and values[i] > 0 and not attacker:isDead() and (attacker.isBoom == nil or not attacker:isBoom()) then
            local weakBuff = chara:getThornsRandomBuff()
            WZLog("BattleMethod:checkReflectThorns-2 111", tostring(weakBuff))
            if weakBuff then 
                WZLog("BattleMethod:checkReflectThorns-2 two-5.3", i, attacker:getBattleId())
                local pos = chara:getAnimation():getPosition()
                local effectInfo = GDatatab_effect["id_" .. weakBuff.m_nEffectId]
                if chara:isTriggerZhaoYunBuff() then --触发赵云反伤buff就不能再触发其他反伤buff
                    if chara.m_nHideOpecity == nil or chara.m_nHideOpecity ~= 0 then
                        BattleProfessionSkillManager:showUseName(BattleCommon:getPointTable(pos.x,pos.y + 85), effectInfo.des, 2)
                    end
                    WMonsterAI:castSkill(nil,
                        nil,
                        nil,
                        {[1]=SkillTypeConfig.BEHIT_DO_EFFECT},
                        nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,nil,nil,nil,nil,nil,
                        nil,
                        nil,
                        nil,nil,
                        nil,nil,nil,nil,
                        nil,
                        nil,
                        weakBuff.m_nEffectId, TakeEffectType.INJURED,
                        nil,nil,nil,nil,
                        chara,
                        attacker,
                        nil,
                        values[i]
                        )
                end
            end
        end
    end
    
    for i,chara in pairs(charas) do
        WZLog("BattleMethod:checkReflectThorns", chara:getBattleId(), currentPlayerId)
        if chara:getBattleId() ~= currentPlayerId and values[i] > 0 and not attacker:isDead() and (attacker.isBoom == nil or not attacker:isBoom()) then
            local weakBuff = chara:getThornsBuff()
            WZLog("BattleMethod:checkReflectThorns 111", tostring(weakBuff))
            if weakBuff then 
                WZLog("BattleMethod:checkReflectThorns two-5.3", i, attacker:getBattleId())
                local pos = chara:getAnimation():getPosition()
                local effectInfo = GDatatab_effect["id_" .. weakBuff.m_nEffectId]
                if chara.m_nHideOpecity == nil or chara.m_nHideOpecity ~= 0 then
                    BattleProfessionSkillManager:showUseName(BattleCommon:getPointTable(pos.x,pos.y + 85), effectInfo.des, 2)
                end
                WMonsterAI:castSkill(nil,
                    nil,
                    nil,
                    {[1]=SkillTypeConfig.BEHIT_DO_EFFECT},
                    nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,nil,nil,nil,nil,nil,
                    nil,
                    nil,
                    nil,nil,
                    nil,nil,nil,nil,
                    nil,
                    nil,
                    weakBuff.m_nEffectId, TakeEffectType.INJURED,
                    nil,nil,nil,nil,
                    chara,
                    attacker,
                    nil,
                    values[i]
                    )
            end
        end
    end
end