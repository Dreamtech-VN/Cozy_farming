--WSubHero.lua
--@brief    皮肤大招-灵魂宿主-灵魂分身
--@date     2024/04/11
--@note     皮肤大招-灵魂宿主-灵魂分身

WSubHero = {
    m_nBattleId = nil,   --战场唯一id
    m_anim = nil,   --形象
    m_tOwner = nil, --拥有者
    m_mover = nil,  --移动管理者
    m_tCollisionRang = nil, --碰撞区域
    m_bIsShowRang = false,  --是否显示碰撞区域
    m_tCollisionTable = nil,    --显示的碰撞框
    m_bAutoStandAction = true,  --自动切换待机
    m_sPlayerName = nil,    --灵魂分身名字
    m_bIsDead = nil, --死亡标记
    m_nTimePassValue = nil,
    m_nTimeDurationValue = nil,
    m_nTimePassValueReal = nil,
    m_nShootState = -1,         --灵魂分身是射击状态：0CD时间未满；1：蓄力好了；2已射击
    m_bulletCilcle = nil,               --子弹碰撞、爆炸相关
    m_bIsSoulHero = false,
    m_nOwnerPlayerId = nil,     --灵魂分身拥有者的玩家Id
    m_tOwnerBuffAttributeChangeStateList = nil, --用于保存创建这一刻，灵魂宿主本身的buff属性
    m_tOwnerAttributeChangeStateList = nil, --用于保存创建这一刻，灵魂宿主本身的效果属性
    m_tHurtData = {}, --射击后保存击中玩家的受伤数据
    m_nSubType = nil,     --分身子类型1=灵魂分身；2=棋圣-黑子分身；3=棋圣-白子分身
    m_bIsSubHero = true,  --是否是分身
}

-------------------------------------公有方法模块Begin--------------------------------------

--@brief    以本表为模版创建一个新的表实例对象
--@return   新建的表实例对象
function WSubHero:new(owner, shapeId, monsterId)
    setmetatable(WSubHero,{__index = WHero})
    local tNewObj = {}
    setmetatable(tNewObj, { __index = WSubHero })
    
    tNewObj.m_tOwner = owner
    tNewObj.m_nShapeId = monsterId 
    tNewObj.m_nMonsterId = shapeId
    tNewObj:_init()
    
    return tNewObj
end

--@brief    创建分身
--@param    monsterId:召唤的怪物Id
--@param    shapeId:皮肤大招的皮肤Id
function WSubHero:buildHero(owner, monsterId, shapeId)
    -- body
    local subHero = WSubHero:new(owner, shapeId, monsterId)
    local monsterData = BossData["id_" .. monsterId]

    subHero.m_nShootState = -1 
    subHero.m_nTimePassValue = 0
    subHero.m_nTimeDurationValue = monsterData and monsterData.tSkillParam[1][1] or 6000
    subHero.m_nTimePassValueReal = 0
    subHero.m_nLevel = owner.m_nLevel
    subHero.m_nRealLevel = owner.m_nLevel
    subHero.m_nAddBuffId = monsterData and monsterData.tSkillParam[1][2] or nil 
    subHero.m_nMonsterType = monsterData.type
    subHero.m_bIsCanDisperse = monsterData.is_call  --201版本，用于筛选可驱散的所有召唤物，等于1是可驱散
    subHero.m_nAction_type = monsterData.action_type > 0 and monsterData.action_type or 1 --205版本修复前后端伤害浮动不一致的问题

    subHero.m_nAttack = owner.m_nAttack          --攻击
    subHero.m_nDefence = owner.m_nDefence        --防御
    subHero.m_nPower = owner.m_nPower            --力量
    subHero.m_nAgility = owner.m_nAgility        --敏捷
    subHero.m_nWreckDefense = owner.m_nWreckDefense --破防
    subHero.m_nConstitution = owner.m_nConstitution --体质
    subHero.m_nCriticalhitAttackRate = owner.m_nCriticalhitAttackRate --暴击
    subHero.m_nLucky = owner.m_nLucky              --幸运
    subHero.m_nInjuryFree = owner.m_nInjuryFree    --免伤
    subHero.m_nArmor = owner.m_nArmor              --护甲
    subHero.m_nReduceCritRate = owner.m_nReduceCritRate --免爆
    subHero.m_nBrokeRange = owner.m_nBrokeRange
    subHero.m_nPF = owner.m_nPF
    subHero.m_nSP = owner.m_nSP
    subHero.m_tOwnerBuffAttributeChangeStateList = CopyTable(owner.m_tBuffAttributeChangeStateList)
    subHero.m_tOwnerAttributeChangeStateList = CopyTable(owner.m_tAttributeChangeStateList)
    WZLog("WSubHero:buildHero", Serialize(subHero.m_tOwnerBuffAttributeChangeStateList), Serialize(subHero.m_tOwnerAttributeChangeStateList))
    subHero.professionId = owner:getProfessionId()
    subHero.m_nBeHurtTypeProfession = owner:getProfessionHurtType()
    --继承玩家的职业技能，剔除掉本回合玩家已经生效的被动技能
    local professionSkill = owner.m_tProfessionSkills
    if not professionSkill then 
        subHero.m_tProfessionSkills = {}
    else
        local tempSkills = CopyTable(professionSkill)
        for i = 1, #owner.m_tDoneProfessionPassiveSkill do
            for j = 1, #tempSkills.id do
                if owner.m_tDoneProfessionPassiveSkill[i] == tempSkills[j] then 
                    table.remove(tempSkills.id, j)
                    table.remove(tempSkills.name, j)
                    table.remove(tempSkills.icon, j)
                    table.remove(tempSkills.lv, j)
                    table.remove(tempSkills.skill_type, j)
                    table.remove(tempSkills.node, j)
                    table.remove(tempSkills.attribute, j)
                    table.remove(tempSkills.profession, j)

                    break 
                end
            end
        end

        subHero.m_tProfessionSkills = tempSkills
    end

    subHero.m_bIsSoulHero = false 
    subHero.m_bIsSubHero = true 

    subHero.m_nHP = owner:getHp()
    subHero.m_nMaxHP = owner:getMaxHp()

    subHero.m_sPlayerName = monsterData.name
    subHero.m_nOwnerPlayerId = owner:getBattleId()

    subHero:updateByTurn()
    subHero.m_tBuffAttributeChangeStateList = CopyTable(owner.m_tBuffAttributeChangeStateList)
    subHero.m_tAttributeChangeStateList = CopyTable(owner.m_tAttributeChangeStateList)

    return subHero
end

--@brief    回合更新数据
function WSubHero:updateByTurn()
    WHero.updateByTurn(self)

    self.m_tHurtData = {}
end

--@brief    刷新
function WSubHero:update(dt)
    if self:getAnimation() == nil then
        return nil
    end
--    WZLog("WSubHero:update")
    WCharacter.update(self, dt)

    if self:isDead() then
        if self.m_bIsShowDead == nil then
            self.m_bIsShowDead = true
             self.m_nDeadCountTime = 0
        end
        local deadTimeOut = false
        --死亡计时
        if self:isServerDead() and self.m_nDeadCountTime then
            self.m_nDeadCountTime = self.m_nDeadCountTime + dt
            if self.m_nDeadCountTime > 1 then
                deadTimeOut = true
                self.m_nDeadCountTime = nil
            end
        end
        WZLog("WSubHero:update one", tostring(self:isServerDead()), tostring(self:getPlayerNameIcon()), tostring(self:getPlayerNameIcon() and self:getPlayerNameIcon().m_bIsHpActionDone), tostring(self:getAnimationName("dead")))
        if self:isServerDead() and deadTimeOut then
            self:clearAllBuff()
            self:_removeDeadGuai()
        end
        return nil
    end
end

--@brief ctb刷新
function WSubHero:updateBuffByCTB(dt, updateCTB_time)
    if self:isDead() then
        return
    end
    
    WCharacter.updateBuffByCTB(self, dt, updateCTB_time)
    if dt ~= nil then
        --持续时间计数
        self.m_nTimePassValue = self.m_nTimePassValue + BattleCtbManager.SECOND_PER_CTB * dt
        if updateCTB_time > BattleCtbManager.m_nUpdateCTB_time then
            self.m_nTimePassValue = self.m_nTimePassValue - (updateCTB_time - BattleCtbManager.m_nUpdateCTB_time)
        end
        WZLog("WSubHero:updateBuffByCTB one", self.m_nTimePassValue)
        if self.m_nTimePassValue >= self.m_nTimeDurationValue then
            self.m_nTimePassValue = self.m_nTimeDurationValue
            self:doSuicide()
        end
    else
        --真实时间换算
        self.m_nTimePassValueReal = self.m_nTimePassValueReal + BattleCtbManager.m_nUpdateCTB_time
        self.m_nTimePassValue = self.m_nTimePassValueReal
        WZLog("WSubHero:updateBuffByCTB two", self.m_nTimePassValue)
        if self.m_nTimePassValue >= self.m_nTimeDurationValue then
            self.m_nTimePassValue = self.m_nTimeDurationValue
            if not self:isDead() then 
                self:doSuicide()
            end
        end
    end

    self:getPlayerNameIcon():update()
end

--@brief ctb刷新
function WSubHero:updateCtb()

end

--@brief    使用技能道具
--@param    hero:使用技能道具的玩家
--@param    useId:技能或道具Id
function WSubHero:doKidUseSkillAndItem(hero, useId, useType)
    WZLog("WSubHero:doKidUseSkillAndItem", self:getBattleId(), useId)
    if useType == BattleHeroUse.USE_SKILL_SUB then --技能
        self.m_bIsUseSkill = true
        BattleHeroUse:heroUse(self:getBattleId(), BattleHeroUse.USE_SKILL_OR_ITEM, useId)
    elseif useType == BattleHeroUse.USE_ITEM_SUB then --道具
        local targetId = {}
        local targetHero = self:getRandomTeamPlayer()
        if targetHero then 
            WZLog("WSubHero:doKidUseSkillAndItem One", targetHero:getBattleId(), useId)
            BattleHeroUse:heroUse(self:getBattleId(), BattleHeroUse.USE_SKILL_OR_ITEM, useId, nil, nil, nil, {targetHero:getBattleId()}, nil, nil, true)
        end
    end
end

--@brief    初始化基础动画
function WSubHero:initAnim()
    WZLog("WSubHero:initAnim", self.m_nShapeId)
    local scale = self:getAnimScale()
    local kidInfo = self:getOwner()
    local suit_info = self:getOwner().m_tSuitInfo
    self.m_nBoyOrGirl = self.m_tOwner:getHeroInfo()
    local monsterData = BossData["id_" .. self.m_nShapeId]
    if monsterData.type == 117 then --暗影分身
        local suit_info = self.m_tOwner.m_tSuitInfo
        self.m_tPlayerBodyInfo = self.m_tOwner.m_tPlayerBodyInfo
        self.m_tSuitInfo = suit_info
        self.m_bIsMonster = suit_info.monster and suit_info.monster < 0

        WZLog("WHero:buildHero zero", tostring(self.m_bIsMonster), suit_info.monster)
        if self.m_bIsMonster then 
            local shapeId = 0 - suit_info.monster
            local skins = GDatatab_shape_skins["id_" .. shapeId]
            local mosterName = skins.animation
            local file = "battle/monster/" .. mosterName
            local bExist = CheckEffectFile(file)
            if not bExist then 
                self.m_bIsMonster = false 
            end
        end
        if self.m_bIsMonster ~= true then
            self.m_anim = YDPlayerAnimation:createAnimation(self.m_nBoyOrGirl == 0, false)
            self.m_anim:getAnimNode():retain()
            self.m_anim:setHead(GDatatab_item[suit_info.head].animation_index_code, suit_info.colour or 0)
            self.m_anim:setFace(GDatatab_item[suit_info.face].animation_index_code)
            self.m_anim:setBody(GDatatab_item[suit_info.body].animation_index_code)
            self.m_anim:setBodyRanSe(suit_info.bodyColour or 0)
            if suit_info.wing ~= "" then 
                self.m_anim:setWing(GDatatab_item[suit_info.wing].animation_index_code)
            end

            WZLog("WHero:buildHero one", suit_info.colour, suit_info.bodyColour, suit_info.weapon, GDatatab_item[suit_info.weapon].animation_index_code)
            if GDatatab_item[suit_info.weapon].sub_type == 0 then 
                self.m_anim:setWeaponBomb(GDatatab_item[suit_info.weapon].animation_index_code)
            else 
                self.m_anim:setWeaponGun(GDatatab_item[suit_info.weapon].animation_index_code)
            end 
        else
            self.m_nMonsterId = 0 - suit_info.monster
            self.m_anim = YDPlayerAnimation:createAnimation(self.m_nBoyOrGirl == 0,false,true)
            self.m_anim:setMonsterId(self.m_nMonsterId)
            self.m_anim:getAnimNode():retain()
        end

        local quality = 0
        quality = GDatatab_item[suit_info.head].quality > quality and GDatatab_item[suit_info.head].quality or quality
        quality = GDatatab_item[suit_info.face].quality > quality and GDatatab_item[suit_info.face].quality or quality
        quality = GDatatab_item[suit_info.body].quality > quality and GDatatab_item[suit_info.head].quality or quality
        self.m_nQuality = 5 - quality
        --self.m_anim:setWeaponGun(weapon.animation_index_code)

        --商城形象
        if self.m_bIsMonster ~= true then
            self.m_shopAnim = YDPlayerAnimation:createAnimation(self.m_nBoyOrGirl == 0, false)

            self.m_shopAnim:getAnimNode():retain()
            self.m_shopAnim:setHead(GDatatab_item[suit_info.head].animation_index_code, suit_info.colour or 0)
            self.m_shopAnim:setFace(GDatatab_item[suit_info.face].animation_index_code)
            self.m_shopAnim:setBody(GDatatab_item[suit_info.body].animation_index_code)
            self.m_shopAnim:setBodyRanSe(suit_info.bodyColour or 0)
            if suit_info.wing ~= "" then 
                self.m_shopAnim:setWing(GDatatab_item[suit_info.wing].animation_index_code)
            end 
            if GDatatab_item[suit_info.weapon].sub_type == 0 then 
                self.m_shopAnim:setWeaponBomb(GDatatab_item[suit_info.weapon].animation_index_code)
            else 
                self.m_shopAnim:setWeaponGun(GDatatab_item[suit_info.weapon].animation_index_code)
            end
        else
            self.m_shopAnim = YDPlayerAnimation:createAnimation(self.m_nBoyOrGirl == 0,false,true)
            self.m_shopAnim:setMonsterId(self.m_nMonsterId)
            self.m_shopAnim:getAnimNode():retain()
        end
    else
        self.m_bIsMonster = true 
        self.m_anim = YDPlayerAnimation:createAnimation(self.m_nBoyOrGirl == 0,false,true)
        self.m_anim:setMonsterId(self.m_nMonsterId, monsterData.AniFileId)
        self.m_anim:getAnimNode():retain()

        WZLog("WSubHero:initAnim one_00", self.m_nShapeId, monsterData.AniFileId)
        self.m_shopAnim = YDPlayerAnimation:createAnimation(self.m_nBoyOrGirl == 0,false,true)
        self.m_shopAnim:setMonsterId(self.m_nMonsterId, monsterData.AniFileId)
        self.m_shopAnim:getAnimNode():retain()
    end

    WZLog("WSubHero:initAnim one", suit_info.weapon, GDatatab_item[suit_info.weapon].animation_index_code)
    if GDatatab_item[suit_info.weapon].sub_type == 0 then 
        self.m_anim:setWeaponBomb(GDatatab_item[suit_info.weapon].animation_index_code)
    else 
        self.m_anim:setWeaponGun(GDatatab_item[suit_info.weapon].animation_index_code)
    end
    self.m_nWeaponId = suit_info.weapon
    self.m_nWeaponType = GDatatab_item[suit_info.weapon].sub_type
    self.m_sWeaponName = GDatatab_item[suit_info.weapon].animation_index_code
    if self.m_bIsMonster then 
        self.m_nWeaponType = GDatatab_shape_skins["id_" .. self.m_nMonsterId].attack_type
        self.m_sWeaponName = GDatatab_shape_skins["id_" .. self.m_nMonsterId].bullet
    end
    --小孩子弹弹坑
    local _, tStrList = self:getOwner():getHeroInfo()
    local sExplode = tStrList.weapon
    local img = WeaponExplodeTexture[sExplode] or string.format("%sb",string.sub(sExplode,0,sExplode:len()-1))

    sExplode = RESOURCE_BULLET_EXPLODE..img..".png"
    self.m_bulletCilcle = BattleUtil:getCircleImg(sExplode)
    self.m_bulletCilcle:retain()

    --碰撞半径
    local radius = 32
    if suit_info.bMonsterMode then 
        radius = 60
    end
    self.m_fRadiusForBulletCollision = radius
    self.m_fRadiusForHurt = radius

    --初始化被动技能
    self.m_tWeaponSkillName = {}
    self.m_tWeaponSkillType = {}
    self.m_tWeaponSkillChance = {}
    self.m_tWeaponSkillParam1 = {}
    self.m_tWeaponSkillParam2 = {}
    
    if WBattleGlobal:getCurrent():isSingleStage() then
        self.m_nDebuffFrozenRound = 0
    end
    
    self.m_anim:setScale(BattleConstants.g_heroScale)
    if suit_info.bMonsterMode then 
        self.m_anim:setScale(BattleConstants.g_heroScale * 2)
    end

    self.m_tActiveSkillList = {}

    local bombInfo = GDatatab_skill.id_1001.boom_scope[1]
    self.m_fRectForBulletExplodeBomb = {x=bombInfo[1],y=bombInfo[2]}
    self.m_fRadiusForBulletExplode = GDatatab_skill.id_1001.scope
    
    self:setMover()
    -- self:changeRectCollision()

    self:getAnimation():play(self:getAnimationName(23),true)
end

--@brief 设置碰撞
function WSubHero:setMover()
    --小怪Mover
    self.m_mover = WDMoveEntity:create(self:getAnimation():getAnimNode())
    self.m_mover:setAdjustChild(true)
    self.m_mover:retain()

    local center = Vector2:create(0,50)
    self.m_mover:setMoverCenter(center)
    self.m_mover:setMoverRadius(10)
end

--@brief    获取缩放系数
function WSubHero:getScale()
    return self.m_anim:getScale()
end

--@brief    设置缩放系数
function WSubHero:setScale(scale)
    self.m_anim:setScale(scale)
end


--@brief    获取移动控制对象
--@return   #1:WDMove移动控制对象
function WSubHero:getMover()
    return self.m_mover
end

--@brief 获取形象
function WSubHero:getAnimation()
    return self.m_anim
end

function WSubHero:getAnimScale()
    return 0.7
end

--@brief    添加碰撞矩形
function WSubHero:changeRectCollision()
    local scale = self:getAnimScale()
    local rectCollision = {[1]={width=60,height=120,x=0,y=0}}

    for i, info in pairs (rectCollision)do
        self:addRectCollision(info.width * scale, info.height * scale,info.x * scale, info.y * scale)
        WZLog("WSubHero:changeRectCollision two", info.width, info.height,info.x, info.y, scale)
    end
end

--@brief    添加矩形碰撞范围
--@param    width,height:宽高
--@param    xOffset,yOffset:x,y偏移量
--@note     偏移量的参考点是character的中心点
function WSubHero:addRectCollision(width,height,xOffset,yOffset)
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
function WSubHero:getCenterPos()
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
function WSubHero:getPosition()
    if not self.m_anim then
        return GlobalMethod:ccp(0,0)
    end
    return self.m_anim:getPosition()
end

--@brief    设置当前的位置
--@param    tPos 当前位置
function WSubHero:setPosition(tPos)
    if self.m_mover ~= nil then
        self.m_mover:setMoverPosition(Vector2:create(tPos.x,tPos.y))
    end
    if self.m_anim ~= nil then
        self.m_anim:setPosition(Vector2:create(tPos.x,tPos.y))
    end
    if self.m_tPlayerNameInfoIcon ~= nil then
        self.m_tPlayerNameInfoIcon:updatePosition()
    end
end

--@brief 
function WSubHero:setRotation(rota)
    if self.m_anim then
        self.m_anim:getAnimNode():setRotation(rota)
    end
end

--@brief 
function WSubHero:getRotation(rota)
    if self.m_anim then
        return self.m_anim:getAnimNode():getRotation()
    end
    return 0
end

--@brief 获取拥有者
function WSubHero:getOwner()
    return self.m_tOwner
end

--@brief    获取子弹碰撞半径
--@return   #1:子弹碰撞半径
function WSubHero:getRadiusForBulletCollision()
    return 0
end

--@brief    获得碰撞范围
--@return   #1:碰撞范围
function WSubHero:getCollisionRang()
    return self.m_tCollisionRang
end

--@brief 射击点
function WSubHero:getShootPos(target)
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
function WSubHero:getAutoStandAction()
    return self.m_bAutoStandAction
end

--@brief 设置自动切换待机动画
--@return
function WSubHero:setAutoStandAction(val)
    self.m_bAutoStandAction = val
end

--@brief 获取死亡标记
function WSubHero:isDead()
    return self.m_bIsDead
end

--@brief 死亡过程
function WSubHero:updateDeadAct()
    
end

function WSubHero:destroy()
    WZLog("WSubHero:destroy")
    if self:getAnimation():getAnimNode() then
        WZLog("WSubHero:release")
        self:getAnimation():getAnimNode():removeFromParentAndCleanup(false)
        self:getAnimation():getAnimNode():release()
    end
    if self:getPlayerNameIcon() then 
        self:getPlayerNameIcon():destroy()
    end

    if WBattleGlobal:getCurrent().m_battleManager ~= nil and  self.m_mover then
        WBattleGlobal:getCurrent().m_battleManager:removeEntity(self.m_mover)
    end

    if self.m_mover then
        self.m_mover:release()
        self.m_mover = nil
    end

    self.m_bulletCilcle:release()
    self.m_bulletCilcle = nil

    self.m_nBattleId = nil
    self.m_anim = nil
    self.m_tOwner = nil
    self.m_mover = nil
    self.m_tCollisionRang = nil
    self.m_bIsShowRang = nil
    self.m_tCollisionTable = nil
    self.m_tHurtData = nil
    self.m_tOwnerBuffAttributeChangeStateList = nil
    self.m_tOwnerAttributeChangeStateList = nil
end

--@brief    检测是否超出屏幕
--@return   #1:是否超出屏幕
--@return   #2:是否纵向超出屏幕
function WSubHero:checkIsOutOfScene(pos)
    if self:getMover() == nil then
        return false, false
    end
    if SceneBattle:getFrontLayer() then
        local sceneSize = SceneBattle:getFrontLayerSize()
        local a = pos or self:getMover():getMoverPosition()
        a = {x = a.x,y = a.y}
        
        --纵向超出屏幕
        if a.y < -20 then
            return true, true
            --横向超出屏幕
            elseif a.x < -20 or a.x > sceneSize.width + 20 then
            return true, false
        end
    end
    return false, false
end

--@brief    获得人物名称
--@return   #1, 返回人物名称
function WSubHero:getPlayerName()
    return self.m_sPlayerName
end

--@brief    获取孩子的总蓄力时间
function WSubHero:getKidMaxCDTime()
    -- body
    return self.m_nTimeDurationValue
end

--@brief    获取孩子的当前蓄力时间
function WSubHero:getKidCurCDTime()
    -- body
    return math.floor(self.m_nTimePassValue)
end

--@brief    皮肤近身攻击后，显示形象
function WSubHero:_showHero()
    -- body
    WZLog("WSubHero:_showHero")

    if self:getOwner().m_nHideOpecity then 
        self:getAnimation():getAnimNode():setOpacity(self:getOwner().m_nHideOpecity)
        if self:getPlayerNameIcon() then 
            self:getPlayerNameIcon():setOpecity(self:getOwner().m_nHideOpecity)
        end
    else
        self:getAnimation():getAnimNode():setOpacity(255)
        if self:getPlayerNameIcon() then 
            self:getPlayerNameIcon():setOpecity(255)
        end
    end

    return true
end

--@brief    设置人物名称信息的显示
--@param    tIcon 人物名称信息的显示
function WSubHero:setPlayerNameIcon(tIcon)
    self.m_tPlayerNameInfoIcon = tIcon
    WZLog("self.m_mover:addTrackNode(node)")
end

--@brief 同步血量
function WSubHero:setHp(nHp)
    nHp = tonumber(nHp)
    if self:isDead() and nHp > 0 then
        WZLog("WSubHero:resurrection")
        self:setDead(false)
        self.m_bIsShowDead = nil
    end
    WCharacter.setHp(self, nHp)
end

--@brief    设置是否死亡
function WSubHero:setDead(bDead, note)
    WZLog("WSubHero:setDead one", tostring(bDead), tostring(note))
    if self.m_bIsDead ~= bDead then
        self.m_bIsDead = bDead
    end
    if self.m_bIsDead then
        self.m_bIsDead = bDead
        self:setHp(0)
        WCharacter.clearAllBuff(self)
        self:setServerDead(true)
    else
        self.m_bIsShowDead = nil
        self:removeDeadAnimation()
        self:getAnimation():getAnimNode():setVisible(true)
        self:getAnimation():play(self:getActionName(23), true)
        WZLog("WSubHero:setDead two", tostring(self:getAnimation()))
    end
end

--@brief    获取武器类型
--@return   #1:武器类型
function WSubHero:getWeaponType()
    return self.m_nWeaponType
end

--@brief    获取武器名字
--@return   #1:武器名字
function WSubHero:getWeaponName()
    return self.m_sWeaponName
end

--@brief    获取子弹爆破
--@return   #1:子弹爆破
function WSubHero:getBulletCilcle()
    return self.m_bulletCilcle
end

--@brief    是否可以控制该角色
--@return   #1:true：是，false：否
function WSubHero:isCanControl()
    if WBattleGlobal:getCurrent():isSingleStage() then
        return true
    end
    
    local isCanControl = false

    if WBattleGlobal:getCurrent():isHostControl() then
        isCanControl = true
        self.m_bCanControl = true
    end
    return isCanControl
end

--@brief    获取爆击攻击倍数
--@return   #1:爆击攻击倍数
function WSubHero:getCriticalhitAttackRate()
    return self.m_nCriticalhitAttackRate
end

--@brief    将召唤那一刻，原玩家的一些属性变数拷过来
function WSubHero:copyOwnerAttributeChangeStateList()
    self.m_tBuffAttributeChangeStateList = CopyTable(self.m_tOwnerBuffAttributeChangeStateList) 
--    WZLog("WSubHero:copyOwnerAttributeChangeStateList", Serialize(self.m_tBuffAttributeChangeStateList))
    self.m_tAttributeChangeStateList = CopyTable(self.m_tOwnerAttributeChangeStateList)
end
-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------

--@brief    初始化对象
function WSubHero:_init()
    WCharacter._init(self)
    self:initAnim()
end

--@brief        播放准备射击动画
function WSubHero:playReadyShootAnim()
    WZLog("WSubHero:playReadyShootAnim", self.m_nWeaponType)
    if self.m_nWeaponType == 0 then
        self:getAnimation():play(self:getActionName(6),false)
    else
        self:getAnimation():play(self:getActionName(4),false)
    end
end

--@brief    播放正在射击动画
--@param    repeatTimes:重复次数(nil,0:不重复)
function WSubHero:playRepeatShootAnim(RepeatTimes)
    repeatTimes = repeatTimes or 0
    WZLog("WSubHero:playRepeatShootAnim", self.m_nWeaponType)
    if self.m_nWeaponType == 0 then
        self:getAnimation():play(self:getActionName(7),false)
    else
        self:getAnimation():play(self:getActionName(5),false)
    end
end

--@brief    播放射击完毕动画
function WSubHero:playEndShootAnim()
    WZLog("WSubHero:playEndShootAnim", self.m_nWeaponType)
    if self.m_nWeaponType == 0 then
        self:getAnimation():play(self:getActionName(2),false)
    else
        self:getAnimation():play(self:getActionName(1),false)
    end
end

--@brief    获得随机的一个对方阵营玩家
function WSubHero:getRandomEnemyPlayer()
    WZLog("WSubHero:getRandomEnemyPlayer")
    --随机数
    local nTurnTimes = WBattleGlobal:getCurrent():getTurnTimes()
    local randNumIndex = nTurnTimes % 10 + 1
    local randNumList = WBattleGlobal:getCurrent().m_tBattleRand
    
    --目标英雄
    local tHeroList = WBattleGlobal:getCurrent():getHeroSortList()
    local nPlayerCount = 0
    local tPlayerIds = {}
    for i ,v in ipairs(tHeroList) do
        if not v:isDead() and v:getHp() > 0 and v:getBattleId() ~= self:getOwner():getBattleId() and WBattleGlobal:getCurrent():isSameTeam(v:getBattleId(), self:getOwner():getBattleId()) ~= true then
            nPlayerCount = nPlayerCount + 1        
            tPlayerIds[nPlayerCount] = v.m_nPlayerId
        end
    end
    
    local targetHero = nil 
    if #tPlayerIds > 0 then 
        local targetHeroId = tPlayerIds[randNumList[randNumIndex] % #tPlayerIds + 1]
        targetHero = WBattleGlobal:getCurrent():getHeroWithId(targetHeroId)
    else
         targetHero = WMonster:getRandomGuai()
    end
    return targetHero
end

--@brief    获得随机的一个对方阵营玩家
function WSubHero:getRandomTeamPlayer()
    WZLog("WSubHero:getRandomEnemyPlayer")
    local tTargetHeroList = {}
    --随机数
    local nTurnTimes = WBattleGlobal:getCurrent():getTurnTimes() --当前回合数
    local randNumIndex = nTurnTimes % 10 + 1  --前端下标1开始
    local randNumList = WBattleGlobal:getCurrent().m_tBattleRand --回合的随机数
    
    --取同阵营的玩家（除了玩家本身）
    local tHeroList = WBattleGlobal:getCurrent():getCharacterList(true)
    local nPlayerCount = 0
    local tPlayerIds = {}
    for i ,v in ipairs(tHeroList) do
        if not v:isDead() and v:getHp() > 0 and WBattleGlobal:getCurrent():isSameTeam(v:getBattleId(), self:getOwner():getBattleId()) == true and self:getOwner():getBattleId() ~= v:getBattleId() then
            table.insert(tTargetHeroList, v)
        end
    end
    --玩家battleId升序排序
    table.sort(tTargetHeroList, function (a, b)
            local battleIdA = a:getBattleId()
            local battleIdB = b:getBattleId()
            return battleIdA < battleIdB
        end
        )
    --取下表randNumIndex的随机数 与 取到的友方玩家数量求余，取到友方玩家的下标
    local targetHero = tTargetHeroList[randNumList[randNumIndex] % #tTargetHeroList + 1]
    
    return targetHero
end

--@brief    移除死亡小怪
function WSubHero:_removeDeadGuai()
    self:clearPlayerNameIcon()
    WBattleGlobal:getCurrent().m_tSoulHeros[self:getBattleId()] = nil
    self:getAnimation():getAnimNode():removeFromParentAndCleanup(false)
    self:destroy()
end

--@brief    清理人物名称信息的显示
function WSubHero:clearPlayerNameIcon()
   if self.m_tPlayerNameInfoIcon ~= nil then
        self.m_tPlayerNameInfoIcon:destroy()
        self.m_tPlayerNameInfoIcon = nil
    end
end

--@brief    获取小孩的射击状态
function WSubHero:getShootState()
    -- body
    return self.m_nShootState
end

--@brief    分身射击
function WSubHero:soulHeroTakeShoot()
    if WBattleGlobal:getCurrent():isHostControl() or WBattleGlobal:getCurrent():isSingleStage() then
        local hero = self
        local nShootOffset = self:_shootOffset()
        local aimHero = hero:getRandomEnemyPlayer()
        if aimHero == nil then
            WZLog("No aimHero,use myHero instead")
            aimHero = WBattleGlobal:getCurrent():getMyHero()
        end
        
        local sPos,ePos = self:getCompareBulletPos(aimHero)
        local face = 0
        if ePos.x <= sPos.x then
            face = 1
        else
            face = 0
        end
        local isAtkSucceed,speed = BattleAiCheck:adjustAngle(sPos,ePos)

        if WBattleGlobal:getCurrent():isSingleStage() then 
            local msg = MsgManager:createMsg(BattleMsgPlayerShoot)
            msg.m_nBattleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
            msg.m_nPlayerId = self:getBattleId()
            msg.m_nCurrentPlayerId = self:getBattleId()
            msg.m_nSpeedx = math.ceil(speed.x)
            msg.m_nSpeedy = math.ceil(speed.y)
            msg.m_nLeftRight = face
            msg.m_nStartX = sPos.x
            msg.m_nStartY = sPos.y
            MsgManager:pushNonBlockMsg(msg)

            return true
        end

        local nBattleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
        local nPlayerId = self:getBattleId()
        local nPlayerCount = 0
        local tPlayerId = {}
        local tCurPositionX = {}
        local tCurPositionY = {}
        local tCurPositionR = {}
        local tCurPositionD = {}
        for id, player in pairs(WBattleGlobal:getCurrent().m_tHeros) do
            table.insert(tPlayerId, id)
            local x = BattleCommon:float2int2float(player:getMover():getMoverPosition().x)
            local y = BattleCommon:float2int2float(player:getMover():getMoverPosition().y)
            local r = BattleCommon:float2int2float(player:getAnimation():getRotate())
            table.insert(tCurPositionX, x)
            table.insert(tCurPositionY, y)
            table.insert(tCurPositionR, r)
            table.insert(tCurPositionD, player:getAnimation():isFlipX() and 1 or 0)
            nPlayerCount = nPlayerCount + 1

            player:setPosition(Vector2:create(x, y))
            player:getAnimation():setRotate(r)
        end
        WBattleGlobal:getCurrent().m_tAttackRandomList = {}
        WBattleGlobal:getCurrent().m_tTargetRandomList = {}

        local count = hero:getAttTimes() * hero:getAttScatterNum()
        WZLog("WSubHero:soulHeroTakeShoot two", nPlayerCount, Serialize(tCurPositionX), Serialize(tCurPositionY), Serialize(tCurPositionR), Serialize(tCurPositionD))
        ProtocolProcessorBattleInterface:send_BATTLE_Shoot(nBattleId, nPlayerId, BattleCommon:float2int2float(speed.x), BattleCommon:float2int2float(speed.y), face, sPos.x, sPos.y, nPlayerCount, tPlayerId, tCurPositionX, tCurPositionY, tCurPositionR, tCurPositionD, count )
    end

    return true 
end

--@brief    获取当前随机数
function WSubHero:getCurRandNum(offset)
    if offset == nil then
        offset = 0
    end
    self.m_nRandNumIndex = (WBattleGlobal:getCurrent():getTurnTimes() + math.abs(self:getBattleId())) % 10 + 1

    self.m_tRandNumList = WBattleGlobal:getCurrent().m_tBattleRand
    self.m_nRandNumIndex = (self.m_nRandNumIndex + math.abs(self:getBattleId()) + offset) % 10 + 1
    self.m_nCurRandNum = self.m_tRandNumList[self.m_nRandNumIndex]

    return self.m_nCurRandNum
end

--@brief    AI命中偏移
function WSubHero:_shootOffset()
    WZLog("WSubHero:_shootOffset one")
    local offset = 0
    local pm = 1
    local rand = self:getCurRandNum()
    if rand % 2 == 1 then
        pm = -1
    end

    local probability = 1
    
    if rand / 10000 > probability then
        offset = 100 * pm
    end

    WZLog("WSubHero:_shootOffset two", offset, rand)
    return offset
end

--@brief    获得英雄属于那一方
--@return   返回英雄属于那一方
function WSubHero:getCamp()
    return self.m_nCamp
end

--@brief    获取是否是灵魂分身
function WSubHero:getIsSoulHero()
    -- body
    return self.m_bIsSoulHero
end

--@brief    获取小孩技能Id
function WSubHero:getSkillId()
    -- body
    return WBattleGlobal:getCurrent():getUseWeaponSkillId()
end

--@brief    获取分身拥有者的Id
function WSubHero:getOwnerPlayerId()
    -- body
    return self.m_nOwnerPlayerId
end

--@brief 自杀
function WSubHero:doSuicide()
    self:setDead(true,"doSelfKill")

    if WBattleGlobal:getCurrent():isSingleStage() then
        self:setServerDead(true)
    else
        if WBattleGlobal:getCurrent():isHostControl() then
            ProtocolProcessorBattleInterface:send_BATTLE_OutOfScene(WBattleGlobal:getCurrent().m_tMakePairOk.battleId, self:getBattleId(), WBattleGlobal:getCurrent():getCurrentCharacterId())
        end
    end
end

--@brief    计算直线射击
--@return   发射速度
function WSubHero:shootLine(targetHero)
    local hero = self

    local eOffset = BattleCommon:getPointTable(targetHero.m_anim:getAnimNode():getContentSize().width * 0, targetHero.m_anim:getAnimNode():getContentSize().height * 0.35)
    local sPos = BattleCommon:getPointTable(hero:getPosition().x, hero:getPosition().y)
    local ePos = BattleCommon:getPointTable(targetHero:getPosition().x + eOffset.x,targetHero:getPosition().y + eOffset.y)
    local angle
    local face

    local power = 5
    local scale = 2
    if shootPower ~= nil then
        scale = shootPower
    end
    local speed = {}

    if ePos.x <= sPos.x then
        face = 1
        sPos = BattleCommon:getShootPos(true, hero)
    else
        face = 0
        sPos = BattleCommon:getShootPos(false, hero)
    end

    if face == 1 then
        speed.x = -1 * scale
    else
        speed.x = scale
    end

    --斜率公式
    if (ePos.x - sPos.x == 0) then
        speed.x = 0
        speed.y = 10
    elseif (ePos.y - sPos.y == 0) then
        if (ePos.x - sPos.x >= 0) then
            speed.x = 10
        else
            speed.x = -10
        end
        speed.y = 5
    else
        speed.y = (speed.x) / ((ePos.x - sPos.x) / (ePos.y - sPos.y))
    end
    if false and (ePos.y - sPos.y > 500 or math.abs(speed.y) > 3.3) then
        speed.x = speed.x * 1
        speed.y = speed.y * 1
    else
        speed.x = speed.x * power
        speed.y = speed.y * power
    end

    WZLog("WSubHero:shootLine", speed.x, speed.y, ePos.x, ePos.y, sPos.x, sPos.y, power)
    return speed
end

--@brief    设置分身子类型
function WSubHero:setSubType(subType)
    self.m_nSubType = subType
end

--@brief    获取分身子类型
function WSubHero:getSubType()
    return self.m_nSubType
end

--@brief    是否是分身
function WSubHero:getIsSubHero()
    return self.m_bIsSubHero
end

--@brief    获得子弹计算相关点
--@return   startPos,endpos (startPos 由self.m_tStartPos记录)
function WSubHero:getCompareBulletPos(targetHero)
    local hero = self
    
    local summonPos = nil
    
    local eOffset = BattleCommon:getPointTable(targetHero.m_anim:getAnimNode():getContentSize().width * 0, targetHero.m_anim:getAnimNode():getContentSize().height * 0.3)
    local sPos = {x = self:getPosition().x, y = self:getPosition().y + 10}
    local ePos = summonPos or self.m_tEndPos or BattleCommon:getPointTable(targetHero:getPosition().x + eOffset.x,targetHero:getPosition().y + eOffset.y)
    
    --炮弹发射位置和角度修正
    if ePos.x <= sPos.x then
        sPos = BattleCommon:getMonsterShootPos(true, hero)
    else
        sPos = BattleCommon:getMonsterShootPos(false, hero)
    end
    self.m_tStartPos = sPos
    WZLog("WSubHero:getCompareBulletPos",self.m_tStartPos.x,self.m_tStartPos.y)
    if WBattleGlobal:getCurrent():isSingleStage() then
        local rate = self.m_nHitRate and self.m_nHitRate > 0 and self.m_nHitRate or 100
        local hitPercentage = BattleAiCheck:getCurRandNum()%100
        if hitPercentage > rate then
            local ePosOriX = ePos.x
            ePos = BattleCommon:getPointTable(ePos.x + 100 * (hitPercentage > 85 and 1 or -1), ePos.y)
        end
    end
    return sPos,ePos
end
-------------------------------------私有方法模块End----------------------------------------