--WBullet.lua
--@brief	子弹数据表
--@date		2013/12/24
--@author	李光森
--@note		子弹的属性与控制

--@brief	运行状态
BulletStatus = {
	DEF_ST_FLY = 0, --飞行
	DEF_ST_EXPLODE = 1, --爆炸
	DEF_ST_END_EXPLODE = 2, --爆炸完毕
	DEF_ST_NONE = -1, --空的状态,用于转换状态时
}

--@brief	子弹数据表
WBullet = {
	--子弹飞行数据
	m_tStartPos = nil,					--射击开始位置
	m_tStartSpeed = nil,				--射击速度
	m_tAcceleration = nil,				--子弹加速度
	m_nType = nil,						--子弹类型  0:投砸 1:投砸(角度矫正) 2:射击  3:跟随地形
	m_tAnimSize = nil,					--纪录动画大小

	--存在标记
	m_bIsExist = nil,					--是否存在的标记

	--对象
	m_mover = nil, 						--移动控制对象
	m_anim = nil, 						--动画控制对象
	m_ownerChara = nil,					--所属对象
	m_backFire = nil,					--后面的烟火

	--状态
	m_nCurStatus = nil,					--当前状态

	--碰撞列表
	m_tCollisionCharacters = nil,		--需要碰撞的人物列表
	m_nCollisionRadius = nil,			--碰撞半径

	--爆炸相关(暂时)
    m_tExplodeElement = nil,            --爆炸动画
    m_tExplodeElement2 = nil,           --爆炸动画2(针对皮肤大招)
    m_tExplodeElement3 = nil,           --爆炸动画3(攻击特效)

    --超出地图的高度
    m_tHigherThanMapLabel = nil,        --显示超出地图的高度的label

    --碰撞范围
    m_tCollisionTable = nil,
    m_nCheckCharacter = nil,
    m_changeOpacityPos = nil,           --要改变透明度的位置

    m_bIsCollisionMapEvent = nil,       --是否与地图事件发生碰撞
    m_bIsProcessMapEvent = nil,         --是否处理了地图事件
    m_bIsProcessMapEventBubble = nil,   --是否处理了地图事件_魔幻泡泡
    m_nLavaAttackHurtUp = 0,            --熔岩柱伤害提升

    m_bIsHurtPlayer = nil,              --是否打中玩家
    m_bIsMark = nil,
    m_bIsPenetrateMap = nil,            --地图穿透
    m_tCheckHurtWithSkillPos = nil,
    m_tCheckHurtWithSkillCharaPos = nil,
    m_tIsReflectPreList = nil, --上一帧是否在反射区域
    m_tIsReflectInitList = nil, --初始是否在反射区域
    m_tIsReflectList = nil, --当前是否在反射区域

    m_tAllReflectList = nil,--所有的反弹列表

    m_bIsSpatter = nil, --是否是溅射出来的子弹

    m_bIsAllCollision = nil, --默认不碰撞自己
    m_nBulletIndex = 1,      --子弹索引
    m_bIsCloseShoot = nil,   --皮肤近身攻击表演
    m_tAllInfluenceBlackHoleList = nil,--所有已计算的黑洞列表，防止重复计算
    m_bIsIgnoreBlackHole = false, --是否忽略黑洞影弹响
}

BulletEffectId = {
	EFFECT_DEFAULT		= 0,   --默认
	EFFECT_NBOMB		= 1,   --核弹
	EFFECT_ADDTIMES		= 2,   --连发
	EFFECT_DIVIDE	 	= 3,    --散弹
	EFFECT_FROZEN 		= 4,   --冰冻
	EFFECT_POUND		= 5,    --冲击
    EFFECT_BIGSKILL		= 6,    --大招
    EFFECT_BIGSKILL_2	= 7,    --大招
    EFFECT_POWER		= 8,    --威力
    EFFECT_FLY          = 9,  --人物飞行拖尾
    EFFECT_POISON       = 10,   --中毒
    EFFECT_SILENT       = 11,   --沉默
    EFFECT_BIND         = 12,   --束缚
    EFFECT_BIGSKILL_3	= 13,   --大招
    EFFECT_BIGSKILL_4   = 14,   --大招
    EFFECT_BIGSKILL_5   = 24,   --皮肤大招
    EFFECT_BIGSKILL_6   = 25,   --皮肤大招
    EFFECT_SKIN_CLOSEATTACK	= 26,   --皮肤近身攻击
    EFFECT_ATTACK_EXPLOSION = 28,   --攻击特效

    EFFECT_DEFAULT_THROW	= 15,   --默认
    EFFECT_NBOMB_THROW		= 16,   --核弹(未有资源)
    EFFECT_DIVIDE_THROW	 	= 17,   --散弹(拖尾)
    EFFECT_TORNADO          = 18,   --龙卷
    EFFECT_SPATTER          = 19,   --溅射
    EFFECT_MIST             = 20,   --烟雾（爆破）
    EFFECT_CURE             = 21,   --治疗弹 （拖尾 爆破）
    EFFECT_ATTRACT          = 22,   --磁铁弹 爆破
    EFFECT_TRANSFER_POS     = 23,   --换位弹
    EFFECT_EASY_HURT        = 27,   --易伤弹
    EFFECT_CALM             = 29,   --镇定弹
    EFFECT_SPEED             = 30,   --加速弹
    EFFECT_SEYBAO           = 33,   --善恶有报弹
    
    BOSS2_MOVE = 1001,      --组队boss2 跳跃拖尾
    BOSS2_WHEEL_MOVE = 1002,--组队boss2 飞轮拖尾
    BOSS3_ATTACK = 1003,    --组队boss3 子弹
    WORLD_BOSS1_ICE = 2003, --世界boss1 冰块拖尾
    BOSS4_WIND = 4001, 		--组队boss4 狂风暴雪
    BOSS4_WIND1 = 4002, 	--组队boss4 狂风暴雪
    BOSS4_WIND2 = 4003, 		--组队boss4 狂风暴雪
    BOSS4_WIND3 = 4004, 	--组队boss4 狂风暴雪
    BOSS4_BULLET_FIRE = 4005,   --组队boss4 子弹拖尾
    BOSS6_BULLET_FIRE_A = 6001,   --组队boss6 子弹拖尾
    BOSS6_BULLET_FIRE_B = 6002,   --组队boss6 子弹拖尾

    BOSS8_BULLET_BOOM = 8001,   --组队副本8 子弹爆破

    BOSS8_SINGLE_BULLET_FIRE = 20001 , --单人boss8
}
-------------------------------------公有方法模块--------------------------------------
local __bid = 0
--@brief	生成一个子弹
--@param	tPos:位置
--@param	tSpeed:速度
--@param	tAcceleration:加速度
--@param    tChara:子弹所属人物
--@param    bulletIndex:子弹索引
--@param	isCloseShoot:幻化玩家代替子弹飞过去近身攻击
function WBullet:buildBullet(tPos, tSpeed, tAcceleration, tChara, isPenetrateMap, isSpatter, bulletIndex, isCloseShoot)
	local bullet = {}
	setmetatable(bullet, {__index = self})

    --溅射子弹 开始默认穿透地图
    if isSpatter then
        bullet.m_bIsSpatterPenetrateMap = isPenetrateMap
        isPenetrateMap = true
    end
    WZLog("WBullet:buildBullet hehe", tostring(isCloseShoot), tostring(bulletIndex))
    bullet.m_nId = WBattleGlobal:getCurrent().m_nBulletId
    WBattleGlobal:getCurrent().m_nBulletId = WBattleGlobal:getCurrent().m_nBulletId + 1

    bullet.m_bIsSpatter = isSpatter
    bullet.m_bIsCloseShoot = isCloseShoot
	bullet.m_tStartPos = tPos
	bullet.m_tStartSpeed = tSpeed
	bullet.m_tAcceleration = tAcceleration
	bullet.m_ownerChara = tChara
	bullet.m_nType = bullet.m_ownerChara:getWeaponType()
	bullet.m_nCurStatus = BulletStatus.DEF_ST_FLY
    bullet.m_bIsPenetrateMap = isPenetrateMap 
	bullet.m_tCollisionCharacters = {}
    -- bullet.m_tCollisionMachines = {}
	bullet.m_nCheckCharacter = 0
    bullet.m_nBulletIndex = bulletIndex or 1

	local strWeapon = bullet.m_ownerChara:getWeaponName()

    local isBigSkill , bigSkillNumber = bullet.m_ownerChara:getUseBigSkill()
    local bIsSkinBigSkill = bullet.m_ownerChara:getUseSkinBigSkill()
    bullet.m_bIsSkinBigSkill = bIsSkinBigSkill
    local skinBigSkill = bullet.m_ownerChara:getSkinBigSkill()
    bullet.m_nSkinBigSkill = skinBigSkill
    local bIsContinue = true 
    if isBigSkill and bIsSkinBigSkill then
        -- if bullet.m_ownerChara:getBigSkillType() == 1 then
        --     if bigSkillNumber <= 2 then
        --         bullet.m_anim = BattleAnimation:createAnimation("bullet_bigskill_1",true)
        --     else
        --         bullet.m_anim = BattleAnimation:createAnimation("bullet_bigskill_2",true)
        --     end
        -- elseif bullet.m_ownerChara:getBigSkillType() == 0 then
        --     bullet.m_anim = BattleAnimation:createAnimation("skill_power2_zidan",true)
        -- elseif bullet.m_ownerChara:getBigSkillType() == 2 then
        --     bullet.m_anim = BattleAnimation:createAnimation("skill_power2red_zidan",true)
        --     WZLog("WBullet:buildBullet 222")
        -- end
        local tempShapeData = WBattleGlobal:getCurrent():getSkinBigSkillShape(skinBigSkill)
        if tempShapeData.id == 1130 then
            local name = "boss_0128_attack_01"
            bullet.m_anim = BattleAnimation:createAnimation(name, false, "battle/monster")
            bullet.m_anim:getAnimNode():setAnimationName("attack_zidan")
            bullet.m_anim:getAnimNode():setLoop(true)
            bullet.m_anim:getAnimNode():setFlipX(tChara:getAnimation():isFlipX())
        elseif WBattleGlobal:getCurrent().m_bIsCurRoundFirstBullet then
            WBattleGlobal:getCurrent().m_bIsCurRoundFirstBullet = false 
            if tempShapeData.id == 1092 or tempShapeData.id == 1093 or tempShapeData.id == 1099 or tempShapeData.id == 1105 or tempShapeData.id == 1106 or tempShapeData.id == 1119 or tempShapeData.id == 1121 or tempShapeData.id == 1127 then 
                local weaponType = tempShapeData.bullet_prefix
                local name = "boss_bullet_"..tempShapeData.bullet
                bullet.m_anim = BattleAnimation:createAnimation(name,true)
                if weaponType == 1 then
                    bullet:getAnimation():setFlipX(true)
                elseif weaponType == 2 then
                    bullet:getAnimation():setFlipX(true)
                end
            elseif tempShapeData.id == 1111 then
                bullet.m_anim = BattleAnimation:createAnimation("boss_bullet_0117_B",true,"battle/bullet")
                local weaponType = tempShapeData.bullet_prefix
                if weaponType == 1 then
                    bullet:getAnimation():setFlipX(true)
                elseif weaponType == 2 then
                    bullet:getAnimation():setFlipX(true)
                end
            else
                local name = tempShapeData.animation
                if tempShapeData.id == 1118 or tempShapeData.id == 1134 then
                    name = tempShapeData.animation .. "_attack02"
                elseif tempShapeData.id == 1133 then
                    name = tempShapeData.animation .. "_attack_02"
                end
                bullet.m_anim = BattleAnimation:createAnimation(name, false)
                if tempShapeData.id == 1065 or tempShapeData.id == 1066 or tempShapeData.id == 1085 or tempShapeData.id == 1086 or tempShapeData.id == 1087 or tempShapeData.id == 1088 or tempShapeData.id == 1089 or tempShapeData.id == 1095 then 
                    bullet.m_anim:getAnimNode():setAnimationName("attack_1")
                elseif tempShapeData.id == 1098 or tempShapeData.id == 1104 or tempShapeData.id == 1109 or tempShapeData.id == 1133 or tempShapeData.id == 1134 then 
                    bullet.m_anim:getAnimNode():setAnimationName("attack_2")
                elseif tempShapeData.id == 1113 or tempShapeData.id == 1114 then 
                    bullet.m_anim:getAnimNode():setAnimationName("attack_loop")
                elseif tempShapeData.id == 1118 then
                    bullet.m_anim:getAnimNode():setAnimationName("shoot_1")
                else
                    bullet.m_anim:getAnimNode():setAnimationName("wait")
                end
                if tempShapeData.id == 1133 or tempShapeData.id == 1134 then 
                    bullet.m_anim:getAnimNode():setLoop(true)
                else
                    bullet.m_anim:getAnimNode():setLoop(false)
                end
            end
        elseif tempShapeData.id == 1092 or tempShapeData.id == 1093 or tempShapeData.id == 1099 or tempShapeData.id == 1105 or tempShapeData.id == 1121 or tempShapeData.id == 1127 then 
            local weaponType = tempShapeData.bullet_prefix
            local name = "boss_bullet_"..tempShapeData.bullet
            bullet.m_anim = BattleAnimation:createAnimation(name,true)
            if weaponType == 1 then
                bullet:getAnimation():setFlipX(true)
            elseif weaponType == 2 then
                bullet:getAnimation():setFlipX(true)
            end
        elseif tempShapeData.id == 1134 then 
            local name = tempShapeData.animation
            if tempShapeData.id == 1134 then
                name = tempShapeData.animation .. "_attack02"
            end
            bullet.m_anim = BattleAnimation:createAnimation(name, false)
            if tempShapeData.id == 1134 then 
                bullet.m_anim:getAnimNode():setAnimationName("attack_2")
            end
            if tempShapeData.id == 1134 then 
                bullet.m_anim:getAnimNode():setLoop(true)
            else
                bullet.m_anim:getAnimNode():setLoop(false)
            end
        else
            bullet.m_anim = BattleAnimation:createAnimation(tempShapeData.animation, false)
            bullet.m_anim:getAnimNode():setAnimationName("wait")
            bullet.m_anim:getAnimNode():setLoop(false)
            bullet.m_anim:setOpacity(0)
        end

        local tempShapeList = {1066, 1079, 1080, 1081, 1082, 1083, 1084, 1087, 1088, 1089, 1090, 1091, 1094, 1095, 1096, 1097, 1100, 1101, 1102, 1103, 1107, 1108, 1109, 1110, 1112, 1115, 1117, 1120, 1122, 1123, 1124, 1125, 1126, 1128, 1129, 1132, 1137}
        if utilsValueInTable(tempShapeData.id, tempShapeList) then 
            bullet.m_anim:setOpacity(0)
        end 
    else
        local attackSkillBullet = BattleAttackSkillManager:getAttackSkillBullet()
        local bIsSkillBulletFileExist = false 
        if attackSkillBullet then 
            bIsSkillBulletFileExist = CheckEffectFile("battle/atkEffect/" .. attackSkillBullet) 
        end
        if bIsSkillBulletFileExist then --触发普攻技能修改子弹
            bullet.m_anim = BattleAnimation:createAnimation(attackSkillBullet,false,"battle/atkEffect")
            bullet.m_anim:getAnimNode():setAnimationName("wait")
            bullet.m_anim:getAnimNode():setLoop(true)
        else
            --strWeapon = "002"
            if bullet.m_bIsCloseShoot then 
                local tempShapeData = GDatatab_shape_skins["id_" .. bullet.m_ownerChara.m_nMonsterId]
                if tempShapeData then 
                    bullet.m_anim = BattleAnimation:createAnimation(tempShapeData.animation, false)
                    bullet.m_anim:getAnimNode():setAnimationName("shoot_1")

                    bullet.m_anim:getAnimNode():setLoop(false)
                    bIsContinue = false 
                end
            end

            if bIsContinue then 
                local name = "bullet_"..strWeapon
                if bullet.m_ownerChara.m_bIsMonster then
                    local ntype = GDatatab_shape_skins["id_" .. bullet.m_ownerChara.m_nMonsterId].bullet_prefix
                    if ntype then
                        if ntype == 0 then
                            name = "bullet_"..strWeapon
                        elseif ntype == 1 then
                            name = "boss_bullet_"..strWeapon
                        elseif ntype == 2 then
                            name = "monster_bullet_"..strWeapon
                        end
                    end
                end

                bullet.m_anim = BattleAnimation:createAnimation(name,true)

                if bullet.m_ownerChara.m_bIsMonster then
                    local ntype = GDatatab_shape_skins["id_" .. bullet.m_ownerChara.m_nMonsterId].bullet_prefix
                    if ntype then
                        if ntype == 1 then
                            bullet:getAnimation():setFlipX(true)
                        elseif ntype == 2 then
                            bullet:getAnimation():setFlipX(true)
                        end
                    end
                end

                WZLog("WBullet:buildBullet 111", strWeapon, name)
            end
        end
    end
    bullet.m_anim:getAnimNode():retain()
    bullet.m_anim:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0.5))

	bullet.m_anim:setPosition(tPos)
	--初始角度
	local angle = BattleCommon:pointToAngle(tSpeed)
	bullet.m_anim:setRotate(-1*BattleCommon:radiansToDegress(angle))
	WZLog("WBullet:buildBullet", strWeapon, angle)

    WZLog("WBullet:buildBullet one", tostring(isBigSkill), tostring(bigSkillNumber),tostring(tChara.m_bIsCureBomb), bIsSkinBigSkill)
    
    if isBigSkill == true then
        bullet.m_backFire = WBulletBackFire:create( tPos , BulletEffectId.EFFECT_BIGSKILL, strWeapon )
        if bIsSkinBigSkill then 
            local tempShapeData = WBattleGlobal:getCurrent():getSkinBigSkillShape(skinBigSkill)

            bullet.m_tExplodeElement = WBulletExplodeElement:create(bullet, BulletEffectId.EFFECT_BIGSKILL_5, tempShapeData)
            if tempShapeData.id ~= 1092 and tempShapeData.id ~= 1093 and tempShapeData.id ~= 1098 and tempShapeData.id ~= 1099 and tempShapeData.id ~= 1104 and tempShapeData.id ~= 1105 and tempShapeData.id ~= 1106 and tempShapeData.id ~= 1119 and tempShapeData.id ~= 1121 and tempShapeData.id ~= 1127 and tempShapeData.id ~= 1134 then 
                bullet.m_backFire:getElement():setVisible(false)
                bullet.m_anim:setRotate(0)
            elseif tempShapeData.id == 1098 or tempShapeData.id == 1104 or tempShapeData.id == 1130 then 
                g_nCollisionIndex = 1
                bullet.m_anim:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
                bullet.m_backFire:getElement():setVisible(false)
                local nDegress = BattleCommon:radiansToDegress(angle)
                WZLog("WBullet:buildBullet angle", nDegress)
                if math.abs(nDegress) <= 90 then 
                    nDegress = (-1) * nDegress
                else
                    if nDegress > 90 then 
                        nDegress = 180 - nDegress
                    elseif nDegress < -90 then 
                        nDegress = -180 - nDegress
                    end
                end
                bullet.m_anim:setRotate(nDegress)

                -- local tCenter2 = {x = tPos.x, y = tPos.y}
                -- local nRadius = tChara:getRadiusForBulletExplode()
                -- for i = 1, 20 do
                --     local _, tSpeedNor = BattleCommon:vectorNormalize(tSpeed)

                --     BattleAnimation:addCircle(tCenter2, nRadius, nil, SceneBattle:getFrontLayer())
                --     tCenter2.x = tCenter2.x + 80 * tSpeedNor.x
                --     tCenter2.y = tCenter2.y + 80 * tSpeedNor.y
                -- end
                -- local rect2 = {}
                -- local _, tSpeedNor = BattleCommon:vectorNormalize(tSpeed)
                -- rect2.w = 2000
                -- rect2.h = 100 
                -- rect2.x = tPos.x 
                -- rect2.y = tPos.y - rect2.h/2

                -- BattleAnimation:addRect({x = rect2.x, y = rect2.y,w = rect2.w,h=rect2.h}, {r = 1,g = 1,b = 1,a = 1}, SceneBattle:getFrontLayer())
            end
            if bullet.m_nBulletIndex == tChara:getAttTimes() and (tempShapeData.id == 1065 or tempShapeData.id == 1066 or tempShapeData.id == 1087 or tempShapeData.id == 1088 or tempShapeData.id == 1089 or tempShapeData.id == 1096 or tempShapeData.id == 1097 or tempShapeData.id == 1100 or tempShapeData.id == 1127) then 
                local tempEffectId = BulletEffectId.EFFECT_BIGSKILL_5
                if tempShapeData.id == 1087 or tempShapeData.id == 1088 or tempShapeData.id == 1089 or tempShapeData.id == 1096 or tempShapeData.id == 1097 or tempShapeData.id == 1100 then 
                    tempEffectId = BulletEffectId.EFFECT_BIGSKILL_6
                end
                bullet.m_tExplodeElement2 = WBulletExplodeElement:create(bullet, tempEffectId, tempShapeData)
                local bValue = tChara:getAnimation():isFlipX()
                local bulletIndex = bullet.m_nBulletIndex
                if math.fmod(bulletIndex, 2) == 0 then 
                    bullet.m_tExplodeElement2.m_tExplodeElement:getAnimNode():setFlipX(bValue)
                else
                    bullet.m_tExplodeElement2.m_tExplodeElement:getAnimNode():setFlipX(not bValue)
                end
            end
        else
            bullet.m_tExplodeElement = WBulletExplodeElement:create(bullet, BulletEffectId.EFFECT_BIGSKILL )
        end
        --[[
        if bullet.m_ownerChara:getBigSkillType() == 1 then
            if bigSkillNumber <= 2 then
                bullet.m_tExplodeElement = WBulletExplodeElement:create(bullet, BulletEffectId.EFFECT_BIGSKILL )
                bullet.m_backFire = WBulletBackFire:create( tPos , BulletEffectId.EFFECT_BIGSKILL )
            else
                bullet.m_tExplodeElement = WBulletExplodeElement:create(bullet, BulletEffectId.EFFECT_BIGSKILL_2 )
                bullet.m_backFire = WBulletBackFire:create( tPos , BulletEffectId.EFFECT_BIGSKILL_2 )
            end
        elseif bullet.m_ownerChara:getBigSkillType() == 0 then
            bullet.m_tExplodeElement = WBulletExplodeElement:create(bullet, BulletEffectId.EFFECT_BIGSKILL_3 )
            bullet.m_backFire = WBulletBackFire:create( tPos , BulletEffectId.EFFECT_BIGSKILL_3 )
        elseif bullet.m_ownerChara:getBigSkillType() == 2 then
            bullet.m_tExplodeElement = WBulletExplodeElement:create(bullet, BulletEffectId.EFFECT_BIGSKILL_4 )
            bullet.m_backFire = WBulletBackFire:create( tPos , BulletEffectId.EFFECT_BIGSKILL_4 )
        end
        --]]
	elseif tChara:getCanFrozen() then
		bullet.m_tExplodeElement = WBulletExplodeElement:create(bullet,BulletEffectId.EFFECT_FROZEN)
		bullet.m_backFire = WBulletBackFire:create(tPos,BulletEffectId.EFFECT_FROZEN,strWeapon)
	elseif tChara:getAttTimes() > 1 then
		bullet.m_tExplodeElement = WBulletExplodeElement:create(bullet, BulletEffectId.EFFECT_ADDTIMES )
		bullet.m_backFire = WBulletBackFire:create( tPos , BulletEffectId.EFFECT_ADDTIMES,strWeapon )
	elseif tChara:getAttScatterNum() > 1 then
        local type = BulletEffectId.EFFECT_DIVIDE
        if bullet.m_nType == BulletType.THROW then
            type = BulletEffectId.EFFECT_DIVIDE_THROW
        end
		bullet.m_tExplodeElement = WBulletExplodeElement:create(bullet, BulletEffectId.EFFECT_DIVIDE )
		bullet.m_backFire = WBulletBackFire:create( tPos , type, strWeapon )
    elseif tChara.m_bIsPowerBomb == true then
        bullet.m_tExplodeElement = WBulletExplodeElement:create(bullet, BulletEffectId.EFFECT_POWER )
        bullet.m_backFire = WBulletBackFire:create(tPos,nil,strWeapon)
    elseif tChara.m_bIsRepulse ~= nil then
        bullet.m_tExplodeElement = WBulletExplodeElement:create(bullet, BulletEffectId.EFFECT_POUND )
        bullet.m_backFire = WBulletBackFire:create(tPos,nil,strWeapon)
    elseif tChara.m_bIsPoisonBomb == true then
        bullet.m_tExplodeElement = WBulletExplodeElement:create(bullet, BulletEffectId.EFFECT_POISON )
        bullet.m_backFire = WBulletBackFire:create(tPos, BulletEffectId.EFFECT_POISON,strWeapon)
    elseif tChara.m_bIsSilentBomb == true then
        bullet.m_tExplodeElement = WBulletExplodeElement:create(bullet, BulletEffectId.EFFECT_SILENT )
        bullet.m_backFire = WBulletBackFire:create(tPos, BulletEffectId.EFFECT_SILENT,strWeapon)
    elseif tChara.m_bIsBindBomb == true then
        bullet.m_tExplodeElement = WBulletExplodeElement:create(bullet, BulletEffectId.EFFECT_BIND )
        bullet.m_backFire = WBulletBackFire:create(tPos, BulletEffectId.EFFECT_BIND,strWeapon)
    elseif tChara.m_bIsTornadoBomb == true then
        bullet.m_tExplodeElement = WBulletExplodeElement:create(bullet, BulletEffectId.EFFECT_TORNADO )
        bullet.m_backFire = WBulletBackFire:create(tPos, BulletEffectId.EFFECT_TORNADO,strWeapon)
    elseif tChara.m_bIsSpatterBomb == true then
        bullet.m_tExplodeElement = WBulletExplodeElement:create(bullet, BulletEffectId.EFFECT_SPATTER )
        bullet.m_backFire = WBulletBackFire:create(tPos, BulletEffectId.EFFECT_SPATTER,strWeapon)
    elseif tChara.m_bIsMistBomb == true then
        bullet.m_tExplodeElement = WBulletExplodeElement:create(bullet, BulletEffectId.EFFECT_MIST )
        bullet.m_backFire = WBulletBackFire:create(tPos, BulletEffectId.EFFECT_MIST,strWeapon)
    elseif tChara.m_bIsCureBomb == true then
        bullet.m_tExplodeElement = WBulletExplodeElement:create(bullet, BulletEffectId.EFFECT_CURE )
        bullet.m_backFire = WBulletBackFire:create(tPos, BulletEffectId.EFFECT_CURE,strWeapon)
	elseif tChara.m_tIsTransferPosBomb == true then
        bullet.m_tExplodeElement = WBulletExplodeElement:create(bullet, BulletEffectId.EFFECT_TRANSFER_POS)
        bullet.m_backFire = WBulletBackFire:create(tPos, BulletEffectId.EFFECT_TRANSFER_POS,strWeapon)
    elseif tChara.m_tIsEasyHurtBomb == true then
        bullet.m_tExplodeElement = WBulletExplodeElement:create(bullet, BulletEffectId.EFFECT_EASY_HURT)
        bullet.m_backFire = WBulletBackFire:create(tPos, BulletEffectId.EFFECT_EASY_HURT,strWeapon)
    elseif tChara.m_bIsCalmBomb == true then
        bullet.m_tExplodeElement = WBulletExplodeElement:create(bullet, BulletEffectId.EFFECT_CALM)
        bullet.m_backFire = WBulletBackFire:create(tPos, BulletEffectId.EFFECT_CALM,strWeapon)
    elseif tChara.m_bIsSpeedBomb == true then
        bullet.m_tExplodeElement = WBulletExplodeElement:create(bullet, BulletEffectId.EFFECT_SPEED)
        bullet.m_backFire = WBulletBackFire:create(tPos, BulletEffectId.EFFECT_SPEED,strWeapon)
    elseif tChara.m_nUseWeaponSkillSubType and tChara.m_nUseWeaponSkillSubType == SkillTableTypeConfig.SEYBAO then
        bullet.m_tExplodeElement = WBulletExplodeElement:create(bullet, BulletEffectId.EFFECT_SEYBAO)
        bullet.m_backFire = WBulletBackFire:create(tPos, BulletEffectId.EFFECT_SEYBAO, strWeapon)
    else
        local type = BulletEffectId.EFFECT_DEFAULT
        if bullet.m_nType == BulletType.THROW then
            type = BulletEffectId.EFFECT_DEFAULT_THROW
        end
		bullet.m_tExplodeElement = WBulletExplodeElement:create(bullet)
		bullet.m_backFire = WBulletBackFire:create(tPos, type,strWeapon)
	end
    --皮肤近身攻击处理
    if not bIsContinue then 
        if bullet.m_backFire then
            bullet.m_backFire:getElement():setVisible(false)
        end

        local tempShapeData = GDatatab_shape_skins["id_" .. bullet.m_ownerChara.m_nMonsterId]
        bullet.m_tExplodeElement2 = WBulletExplodeElement:create(bullet, BulletEffectId.EFFECT_SKIN_CLOSEATTACK, tempShapeData)
        bullet.m_anim:setRotate(0)
    end

    
    --攻击特效
    local nExplodeId = bullet.m_ownerChara:getBlastEffect()
    local tExplodeItemData = GDatatab_item["id_"..nExplodeId]
    if tExplodeItemData then
        local tCurRoundSkillId = WBattleGlobal:getCurrent().m_tCurRoundSkillId
        local nSpecialEffect = 2
        for i=1,#tCurRoundSkillId do
            local tSkillData = GDatatab_skill["id_"..tCurRoundSkillId[i]]
            if tSkillData.skill_type ~= 5 then
                if tSkillData.skill_type == 2 then
                    nSpecialEffect = tSkillData.special_effect
                    break
                elseif tSkillData.skill_type == 0 then
                    nSpecialEffect = tSkillData.special_effect
                end
            end
        end
        local folder = "battle/atkEffect/" .. tExplodeItemData.animation_index_code
        local existSpine = CheckEffectFile(folder)
        if existSpine then 
            if nSpecialEffect == 0 then --只显示特殊爆炸
                bullet.m_tExplodeElement3 = WBulletExplodeElement:create(bullet,BulletEffectId.EFFECT_ATTACK_EXPLOSION,tExplodeItemData)
                if bullet.m_tExplodeElement then
                    bullet.m_tExplodeElement.m_tExplodeElement:getAnimNode():setOpacity(0)
                end
            elseif nSpecialEffect == 1 then --只显示技能爆炸
            elseif nSpecialEffect == 2 then --叠加显示(技能在上)
                bullet.m_tExplodeElement3 = WBulletExplodeElement:create(bullet,BulletEffectId.EFFECT_ATTACK_EXPLOSION,tExplodeItemData)
                local nExplodeEle = bullet.m_tExplodeElement or bullet.m_tExplodeElement2
                bullet.m_tExplodeElement3.m_tExplodeElement:getAnimNode():setZOrder(nExplodeEle.m_tExplodeElement:getAnimNode():getZOrder() - 1)
            elseif nSpecialEffect == 3 then --叠加显示(技能在下)
                bullet.m_tExplodeElement3 = WBulletExplodeElement:create(bullet,BulletEffectId.EFFECT_ATTACK_EXPLOSION,tExplodeItemData)
                local nExplodeEle = bullet.m_tExplodeElement or bullet.m_tExplodeElement2
                bullet.m_tExplodeElement3.m_tExplodeElement:getAnimNode():setZOrder(nExplodeEle.m_tExplodeElement:getAnimNode():getZOrder() + 1)
            end
        end
    end

    -- if bullet.m_bIsPenetrateMap then
    --     bullet.m_mover = WDMover:create()
    --     bullet.m_mover:retain()
    --     bullet.m_mover:setMoverPosition(Vector2:create(bullet.m_tStartPos.x,bullet.m_tStartPos.y))
    --     bullet.m_mover:setMoverSpeed(Vector2:create(bullet.m_tStartSpeed.x,bullet.m_tStartSpeed.y))
    --     bullet.m_mover:setMoverAcceleration(Vector2:create(bullet.m_tAcceleration.x,bullet.m_tAcceleration.y))
    --     bullet.m_anim:getAnimNode():addChild(bullet.m_backFire)
    --     bullet.m_bIsExist = true
    -- else
        bullet.m_mover = WDMoveEntity:create(bullet.m_anim:getAnimNode())
        bullet.m_mover:retain()
        bullet.m_mover:setNormal(true)
        bullet.m_mover:setBreakCircleMark(bullet:getBreakCircleMark())
        bullet.m_mover:setMoverCollisionType(BattleConstants.g_nE_COLLISION_CIRCLE)
        bullet.m_mover:setMoverRadius(1)
        bullet.m_mover:setMoverPosition(Vector2:create(bullet.m_tStartPos.x,bullet.m_tStartPos.y))
        bullet.m_mover:setMoverSpeed(Vector2:create(bullet.m_tStartSpeed.x,bullet.m_tStartSpeed.y))
        bullet.m_mover:setMoverAcceleration(Vector2:create(bullet.m_tAcceleration.x,bullet.m_tAcceleration.y))
        bullet.m_mover:setFly(true)
        if bullet.m_mover.setEnableRotate then
            bullet.m_mover:setEnableRotate(false)
        end

        --宇航员子弹处理 子弹轨迹需要直线下落,不受风力影响
        if bullet.m_bIsSkinBigSkill and (bullet.m_nSkinBigSkill == 3030 or bullet.m_nSkinBigSkill == 3046 or bullet.m_nSkinBigSkill == 3054) then 
            local windX, windY = WBattleGlobal:getCurrent():getWind().x, WBattleGlobal:getCurrent():getWind().y
            if isPenetrateMap == true then
                if bullet.m_nSkinBigSkill == 3054 then 
                    bullet.m_mover:setFlyAcceleration(0, BattleConstants.g_nFlyGravity.y)
                    bullet.m_mover:setMoverAcceleration(Vector2:create(0, bullet.m_tAcceleration.y))
                else
                    bullet.m_mover:setFlyAcceleration(0, BattleConstants.g_nFlyGravity.y)
                    bullet.m_mover:setMoverAcceleration(Vector2:create(0, bullet.m_tAcceleration.y))
                end
            else
                bullet.m_mover:setFlyAcceleration(- windX, -windY +BattleConstants.g_nFlyGravity.y)
                bullet.m_mover:setMoverAcceleration(Vector2:create(- windX, -windY +bullet.m_tAcceleration.y))
            end
        end

        WZLog("WBullet:buildBullet two", bullet.m_anim:getAnimNode():getContentSize().width * 0.25)
        --local track = TrackNode:create(bullet.m_backFire:getElement())
        --track:setPreAdd(Vector2:create(60,60))
        --track:setTrackFlip(true)
        --bullet.m_mover:addTrackNode(bullet.m_backFire:getTrackNode())

        bullet.m_bIsExist = true

        --移动管理
        if WBattleGlobal:getCurrent().m_battleManager ~= nil and not bullet.m_bIsPenetrateMap then
            WBattleGlobal:getCurrent().m_battleManager:addEntity(bullet.m_mover)
        end
    -- end

    if WBattleGlobal:getCurrent().m_tIsHighEndMachine == true then
        SceneBattle:getFrontLayer():addChild(bullet:getBackFire():getParent(),0)
    end


	bullet.m_tAnimSize = bullet:getAnimation():getAnimNode():getContentSize()
	bullet.m_tAnimSize = {width=bullet.m_tAnimSize.width,height=bullet.m_tAnimSize.height}

	bullet.m_nCollisionRadius = 4
    if tChara:getCanPenetrate() then
        bullet.m_nCollisionRadius = 10
    end

    bullet.m__bid = __bid
    __bid = __bid + 1
    
    if isBigSkill and not bIsSkinBigSkill then
        bullet.m_bigSkillAnim = BattleAnimation:createAnimation("bullet_power1",FALSE)
        bullet.m_bigSkillAnim:getAnimNode():retain()
        bullet.m_bigSkillAnim:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0))

        bullet.m_anim:getAnimNode():addChild(bullet.m_bigSkillAnim:getAnimNode(),4)
        bullet.m_bigSkillAnim:play("1", true)

        local hero = WBattleGlobal:getCurrent():getCurrentCharacter()
        if not WBattleGlobal:getCurrent():isReplayGame() or hero:isHide() ~= true or WBattleGlobal:getCurrent():isMyTeam(hero:getBattleId()) then
            bullet.m_bigSkillAnim:getAnimNode():setVisible(true)
        else
            bullet.m_bigSkillAnim:getAnimNode():setVisible(false)
        end
    end

    if false and ((bullet.m_ownerChara:getBigSkillType() == 0 or bullet.m_ownerChara:getBigSkillType() == 2 or TeachGroup1.ISBATTLE) and bullet.m_ownerChara:getUseBigSkill()) then
        WZLog("WBullet:buildBullet end")
        bullet.m_anim:setScale(1.0)
    else
        bullet.m_anim:setScale(0.7)
    end

    if isBigSkill and bIsSkinBigSkill then
        local tempShapeData = WBattleGlobal:getCurrent():getSkinBigSkillShape(skinBigSkill)
        if tempShapeData.id == 1065 or tempShapeData.id == 1066 or tempShapeData.id == 1085 or tempShapeData.id == 1086 or tempShapeData.id == 1087 or tempShapeData.id == 1088 or tempShapeData.id == 1089 or tempShapeData.id == 1095 or tempShapeData.id == 1113 or tempShapeData.id == 1114 or tempShapeData.id == 1130 then 
            bullet.m_anim:setScale(0.8)
        elseif tempShapeData.id == 1092 or tempShapeData.id == 1093 or tempShapeData.id == 1111 or tempShapeData.id == 1116 or tempShapeData.id == 1118 or tempShapeData.id == 1119 or tempShapeData.id == 1127 then
            bullet.m_anim:setScale(1)
        elseif tempShapeData.id == 1099 or tempShapeData.id == 1134 then 
            bullet.m_anim:setScale(0.7)
        elseif tempShapeData.id == 1105 or tempShapeData.id == 1106 then
            bullet.m_anim:setScale(2.2)
            if bullet.m_bIsSpatter == true then
                bullet.m_anim:setScale(0.4)
            end
        elseif tempShapeData.id == 1098 or tempShapeData.id == 1104 or tempShapeData.id == 1109 then 
            bullet:stop()
        else
            bullet.m_anim:setScale(0.4)
        end
    elseif not bIsContinue then 
        bullet.m_anim:setScale(BattleConstants.g_heroScale)
        bullet.m_ownerChara:getAnimation():getAnimNode():setOpacity(0)
    end

    if TeachGroup1.ISBATTLE and bullet.m_ownerChara:getUseBigSkill() then
        WZLog("WBullet:buildBullet end-2")
        bullet.m_anim:setScale(1.2)
    end

    bullet.m_bIsCollisionMapEvent = false
    bullet.m_bIsProcessMapEvent = false
    bullet.m_bIsProcessMapEventBubble = false

    bullet.m_tIsReflectInitList = nil
    bullet.m_tIsReflectPreList = nil
    bullet.m_tIsReflectList = nil

    bullet.m_tAllReflectList = {}
    bullet.m_tAllInfluenceBlackHoleList = {}

    bullet.m_bOffTracking = nil --是否免除磁铁追踪检查
    bullet.m_nLiftTime = 0 --存在时间
	return bullet
end

--@brief	创建后面的烟火
--@return	#1:后面的烟火
function WBullet:createBackFire(tPos,nId)
	nId = nId or BulletEffectId.EFFECT_DEFAULT

	local backFire
	if nId == BulletEffectId.EFFECT_DEFAULT then
		backFire = CCParticleSystemQuad:create("particle_texture.plist")
	elseif nId == BulletEffectId.EFFECT_NBOMB  then
		backFire = CCParticleSystemQuad:create("particle_texture.plist")
	elseif nId == BulletEffectId.EFFECT_ADDTIMES then
		backFire = CCParticleSystemQuad:create("particle_texture.plist")
	elseif nId == BulletEffectId.EFFECT_DIVIDE then
		backFire = CCParticleSystemQuad:create("particle_texture.plist")
	elseif nId == BulletEffectId.EFFECT_FROZEN then
		backFire = CCParticleSystemQuad:create("skills_bdtx_tuowei01.plist")
	end
	backFire:setDuration(kCCParticleDurationInfinity)
--	backFire:retain()
    backFire:setPositionType(kCCPositionTypeRelative)
    backFire:setAutoRemoveOnFinish(true)
	backFire:setPosition(tPos.x,tPos.y)

    local particle = CCParticleBatchNode:createWithTexture(backFire:getTexture())
    particle:addChild(backFire)
	return backFire
end

--@brief	添加人物碰撞列表
--@param	tCharas:人物碰撞列表
function WBullet:addCollisionCharas(tCharas)
	table.insert(self.m_tCollisionCharacters,tCharas)
end

-- --@brief 添加道具碰撞
-- function WBullet:addCollisionMachines(tMachines)
--     self.m_tCollisionMachines = tMachines
-- end

--@brief	设置子弹状态
--@param	nStatus:子弹状态
function WBullet:setStatus(nStatus)
	self.m_nCurStatus = nStatus
end

--@brief	获取子弹状态
--@return	#1：子弹状态
function WBullet:getStatus()
	return self.m_nCurStatus
end

--@brief 设置透明度
function WBullet:setOpacity(opacity)
    if self.m_nOpacity == opacity then
        return
    end

    if self.m_bIsSkinBigSkill then 
        local tempOpacity = self:getAnimation():getAnimNode():getOpacity()
        local tempShapeData = WBattleGlobal:getCurrent():getSkinBigSkillShape(self.m_nSkinBigSkill)
        local tempShapeList= {1066, 1079, 1080, 1081, 1082, 1083, 1084, 1087, 1088, 1089, 1090, 1091, 1095, 1094, 1122, 1096, 1097, 1100, 1101, 1112, 1114, 1120, 1122, 1132}
        if utilsValueInTable(tempShapeData.id, tempShapeList) then 
            self.m_nOpacity = 0
            self:getAnimation():getAnimNode():setOpacity(0)
        else
            if tempOpacity ~= 0 then 
                self.m_nOpacity = opacity
                self:getAnimation():getAnimNode():setOpacity(opacity)
            end
        end
    else
        self.m_nOpacity = opacity
        self:getAnimation():getAnimNode():setOpacity(opacity)
    end
end

--@brief	获取子弹飞行类型
--@return	#1：0:投掷 1:射击
function WBullet:getShootType()
	return self.m_nType
end

--@brief	销毁一个子弹
function WBullet:destroy()
	WZLog("WBullet:destroy 0", tostring(self:getIsExist()))
	if not self:getIsExist() then
		return
	end

    if self.m_bIsSpatter and self.index ~= nil then 
        WZLog("WBullet:destroy HHHH", self.index)
    end

    self:setCharMoveUpdatable()
    
    WZLog("WBullet:destroy 2")
    -- if self.m_tExplodeElement then
    --     self.m_tExplodeElement:removeElement()
    -- end
	--移动管理
	if self.m_backFire then
		self.m_backFire:removeElement()
		self.m_backFire = nil
	end

    if self.m_bigSkillAnim then
        if self.m_bigSkillAnim:getAnimNode():getParent() ~= nil then
            self.m_bigSkillAnim:getAnimNode():removeFromParentAndCleanup(true)
        end
        self.m_bigSkillAnim:getAnimNode():release()
        self.m_bigSkillAnim = nil
    end
	WZLog("WBullet:destroy 01")
	if WBattleGlobal:getCurrent().m_battleManager ~= nil and not self.m_bIsPenetrateMap then
		WBattleGlobal:getCurrent().m_battleManager:removeEntity(self.m_mover)
	end
    WZLog("WBullet:destroy 02")
	self.m_mover:release()
	self.m_mover = nil

    WZLog("WBullet:destroy 1")
	if self.m_anim ~= nil then
		if self.m_anim:getAnimNode():getParent() ~= nil then
			self.m_anim:getAnimNode():removeFromParentAndCleanup(true)
		end
		self.m_anim:getAnimNode():release()
		self.m_anim = nil
	end

    for id,heroList in pairs(self.m_tCollisionCharacters) do
        for i,hero in pairs(heroList) do
            --WZLog("WBullet:destroy two",i, tostring(hero.m_bIsImmunity))
            if hero.m_bIsImmunity == true then
                --WZLog("WBullet:destroy three",i)

            end
            hero.m_bIsAbsorb = nil
            hero.m_bIsImmunity = nil
        end
    end
	self.m_tCollisionCharacters = nil
    -- self.m_tCollisionMachines = nil

     WZLog("WBullet:destroy 3")
    if self.m_tHigherThanMapLabel ~= nil then
    	if self.m_tHigherThanMapLabel:getParent() ~= nil then
       		self.m_tHigherThanMapLabel:removeFromParentAndCleanup(true)
       	end
       	self.m_tHigherThanMapLabel = nil
    end

     WZLog("WBullet:destroy 4")
    --碰撞范围
    if self.m_tCollisionTable ~= nil then
    	for i,collisionTable in pairs(self.m_tCollisionTable) do
    		collisionTable:removeFromParentAndCleanup(true)
    	end
    	self.m_tCollisionTable = nil
    end

    self.m_changeOpacityPos = nil
    self.m_bIsCollisionMapEvent = nil
    self.m_bIsProcessMapEvent = nil
    self.m_bIsProcessMapEventBubble = nil
    self.m_nLavaAttackHurtUp = 0

    self.m_bIsHurtPlayer = nil

    self.m_tCheckHurtWithSkillPos = nil
    self.m_tCheckHurtWithSkillCharaPos = nil
    self.m_bIsSpatter = nil
    self.m_bIsCloseShoot = nil 
    self.m_bIsIgnoreBlackHole = nil

    self.m_bIsExist = false
end

--@brief	是否还存在
--@return	#1:true,false
function WBullet:getIsExist()
	return self.m_bIsExist or false
end

--@brief	获取发射子弹的玩家
--@return	#1:发射子弹的玩家
function WBullet:getOwnerChara()
	return self.m_ownerChara
end

--@brief	获取移动控制对象
--@return	#1:WDMove移动控制对象
function WBullet:getMover()
	return self.m_mover
end

--@brief	获取动画控制对象
--@return	#1:BattleAnimation动画控制对象
function WBullet:getAnimation()
	return self.m_anim
end

--@brief	获得动画大小
function WBullet:getAnimSize()
	return self.m_tAnimSize
end

--@brief	获得后面的烟火
--@return	#1:后面的烟火
function WBullet:getBackFire()
	return self.m_backFire:getElement()
end

--@brief	获取爆破半径
--@return	#1:爆破半径
function WBullet:getExplodeRadius()
    if self:getOwnerChara():getCanPenetrate() then
        return 10
    end
	return self:getOwnerChara():getRadiusForBulletExplode()
end

--@brief	获取爆破纹理
--@return	#1:BreakCircleMark爆破纹理
function WBullet:getBreakCircle()
	if self:getOwnerChara():getBulletCilcle() and self:getOwnerChara():getBulletCilcle():count() > 0 then
		return tolua.cast(self:getOwnerChara():getBulletCilcle():objectAtIndex(0),"WDMemoryImage")
	else
		return nil
	end
end

--@brief	获取爆破圈
--@return	#1:BreakCircleMark爆破圈
function WBullet:getBreakCircleMark()
	if self:getOwnerChara():getBulletCilcle() and self:getOwnerChara():getBulletCilcle():count() > 1 then
		return tolua.cast(self:getOwnerChara():getBulletCilcle():objectAtIndex(1),"WDMemoryImage")
	else
		return nil
	end
end

--@brief	获取位置
function WBullet:getPosition()
    return self:getAnimation():getPosition()
end

--@brief 刷新透明度
function WBullet:updateOpacity()
    local hero = WBattleGlobal:getCurrent():getMyHero()
    local hideViewDis = hero.m_nHideViewDis
    --不带反隐buff 子弹非隐身对象
    if not hideViewDis or not self.m_ownerChara:isHide() then
        return
    end
    --队伍相同
    if WBattleGlobal:getCurrent():isMyTeam(self.m_ownerChara:getBattleId()) then
        return
    end

    local pos = WBattleGlobal:getCurrent():getMyHero():getPosition()
    if BattleCommon:pointDis(pos,self:getPosition()) < hideViewDis then
        self:setOpacity(51)
    else
        self:setOpacity(0)
    end
end

--@brief	更新位置
function WBullet:updatePosition()
    self.m_nLiftTime = self.m_nLiftTime + 1
    -- self.m_tExplodeElement:explodeIsEnd()
    self:updateOpacity()
    -- if ProjConfig.DEBUG == 1 and self.m_bIsSkinBigSkill then
    --     local vec3 = self.m_mover:getMoverPosition()
    --     BattleAnimation:addCircle({x = vec3.x, y = vec3.y}, self.m_nCollisionRadius,{r = 1,g = 1,b = 1,a = 1}, SceneBattle:getFrontLayer())
    -- end
    
    if self.m_bIsPenetrateMap then
        --溅射子弹 地图碰撞检测
        if self.m_bIsSpatter then
            if self.m_nLiftTime > BattleConstants.g_fWB_SPATTER_PROTECT_TIME  then
                --非穿透地图溅射
                if not self.m_bIsSpatterPenetrateMap then
                    local collosion = self:checkMapCollision()
                    if collosion then
                        return
                    end
                end
            end
        end
        self:updatePositionII()
        return
    end
    local vec2 = self.m_mover:getMoverPosition()
    self:getBackFire():setPosition(vec2.x,vec2.y)
  
    self:updateRotation()

    self:showHeight()

    WBattleGlobal:getCurrent():cleanMyBulletFog(self:getPosition(), self:getOwnerChara(), 2)

end

--@brief    更新位置
function WBullet:updatePositionII()
    WZLog("WBullet:updatePositionII")
    self.m_mover:updatePostion()
    local vec2 = self.m_mover:getMoverPosition()
    self.m_anim:setPosition(vec2)
    self:getBackFire():setPosition(vec2.x,vec2.y)
    self:updateRotation()
    --显示高度
    self:showHeight()

end

--@brief 地图碰撞检测
function WBullet:checkMapCollision()
    WZLog("WBullet:checkMapCollision")
    return BattleMapManager:checkCollision(self.m_mover,true,self:getBreakCircleMark())
end

--@brief    检测追踪英雄
--@param    heros:英雄列表
--@return   #1:true:跟踪,false:不跟踪
function WBullet:checkTrack()
    if self.m_bOffTracking or self.m_bIsTracking then
        return
    end
    local heros = {}

    for i,v in pairs(WBattleGlobal:getCurrent():getCharacterList()) do
        if v:getBattleId() ~= self.m_ownerChara:getBattleId() and v.m_nAttractBulletDis then
            table.insert(heros,v)
        end
    end
    if #heros == 0 then
        --场上没有带磁铁效果的对象
        self.m_bOffTracking = true
        return
    end
   
    local minDis = INT32_MAX
    local vecSpeed = nil
    for id,hero in pairs(heros) do
        local bulletPos = self:getMover():getMoverPosition()
        local heroPos = hero:getCenterPos()
        local dis = BattleCommon:pointDis(bulletPos,heroPos)
        --复合吸引条件 并且距离最近
        if dis < hero.m_nAttractBulletDis and dis < minDis then
            minDis = dis
            if hero:getType() == 0 then
                vecSpeed = BattleCommon:pointSub(BattleCommon:getPointTable(heroPos.x,heroPos.y + 20),bulletPos)
            else
                vecSpeed = BattleCommon:pointSub(BattleCommon:getPointTable(heroPos.x,heroPos.y),bulletPos)
            end
        end
    end

    if vecSpeed then
        self.m_bIsTracking = true
        local _,tSpeed = BattleCommon:vectorNormalize(vecSpeed)
        self:getMover():setMoverSpeed(Vector2:create(tSpeed.x*BattleConstants.g_fWB_TRACK_SPEED,tSpeed.y*BattleConstants.g_fWB_TRACK_SPEED))
        self:getMover():setMoverAcceleration(Vector2:create(0,0))
    end
end

--@brief 设置起始角度
function WBullet:setStartRotation(speed)
    local angle = BattleCommon:pointToAngle(speed)
    local degress = -1*BattleCommon:radiansToDegress(angle)   
    WZLog("WBullet:setStartRotation",degress)
    if (not self.m_bIsSkinBigSkill and not self.m_bIsCloseShoot) or (self.m_bIsSkinBigSkill and (self.m_nSkinBigSkill == 3016 or self.m_nSkinBigSkill == 3017 or self.m_nSkinBigSkill == 3030 or self.m_nSkinBigSkill == 3032 or self.m_nSkinBigSkill == 3037 or self.m_nSkinBigSkill == 3045 or self.m_nSkinBigSkill == 3058)) then 
        self.m_anim:setRotate(degress)
    end
end
--@brief 更新旋转角度
function WBullet:updateRotation()
    local attackSkillBullet = BattleAttackSkillManager:getAttackSkillBullet() --触发普攻技能
    local bIsSkillBulletFileExist = false 
    if attackSkillBullet then 
        bIsSkillBulletFileExist = CheckEffectFile("battle/atkEffect/" .. attackSkillBullet) 
    end
    if self.m_bIsCloseShoot and not bIsSkillBulletFileExist then return end 

    local speed = self.m_mover:getMoverSpeed()
    if self:getShootType() == BulletType.THROW and self.m_ownerChara:getUseBigSkill() ~= true and bIsSkillBulletFileExist == false then
        WZLog("WBossBullet:updatePosition 1",self.m_anim:getRotate(), speed:getX())
        if speed:getX() > 0 then
            self.m_anim:setRotate(self.m_anim:getRotate() + 14)
        else
            self.m_anim:setRotate(self.m_anim:getRotate() - 14)
        end    
    --根据前一个位置计算角度
    elseif self:getShootType() == BulletType.THROW_II or self:getShootType() == BulletType.LINE or self.m_ownerChara:getUseBigSkill() or bIsSkillBulletFileExist then
        if self.m_bIsSkinBigSkill then 
            if self.m_nSkinBigSkill ~= 3016 and self.m_nSkinBigSkill ~= 3017 and self.m_nSkinBigSkill ~= 3030 and self.m_nSkinBigSkill ~= 3032 and self.m_nSkinBigSkill ~= 3037 and self.m_nSkinBigSkill ~= 3045 and self.m_nSkinBigSkill ~= 3058 and self.m_nSkinBigSkill ~= 3062 then 
                return 
            end
        end 

        local curPos = self.m_mover:getMoverPosition()
        local prePos = self.m_mover:getMoverPrePosition()
        if prePos.x == 0 and prePos.y == 0 then
            return
        end
--        WZLog("WBullet:updateRotation",BattleCommon:pointToAngle({x=curPos.x-prePos.x,y=curPos.y-prePos.y}))
        local angle = BattleCommon:pointToAngle({x=curPos.x-prePos.x,y=curPos.y-prePos.y})
        local degress = -1*BattleCommon:radiansToDegress(angle)

        if angle and angle ~= 0 and degress and math.abs(degress) ~= 0 then
            self.degressPre = degress
            self.m_anim:setRotate(degress)
            --print("WBossBullet:updatePosition 2-10")
        elseif self.degressPre then
            --self.m_anim:setRotate(self.degressPre)
            --print("WBossBullet:updatePosition 2-11")
        end

        self.anglePre = angle
        --print("WBossBullet:updatePosition 2-2",curPos.x, curPos.y, prePos.x, prePos.y, tostring(angle), tostring(degress))

    --子弹跟随地形
    elseif self:getShootType() == BulletType.FLOOR then
        local isCollision,newPos,tangent = BattleMapManager:checkCollision(self.m_mover)
            --WZLog("WBossBullet:updatePosition 4", tostring(isCollision), tostring(tangent),vec2.x, vec2.y, newPos.x, newPos.y)
        if isCollision then
            self.m_mover:setMoverPosition(newPos)
            self.m_anim:getAnimNode():setPosition(newPos.x,newPos.y)
        end
    end
end

--@brief	子弹停止
function WBullet:stop()
	WZLog("WBullet:stop")
	--do return end
    --self.m_anim:getAnimNode():setVisible(false)

    if self:getOwnerChara().m_tActiveAttackSpeed == nil or #self:getOwnerChara().m_tActiveAttackSpeed == 0 then
        local speed = self:getMover():getCollisionSpeed()
        local speed2 = self:getMover():getMoverSpeed()
        if speed.x == 0 and speed.y == 0 then
            speed = {x=speed2.x, y=speed2.y}
        end
        WZLog("WBullet:stop two",speed.x,speed.y,speed2.x,speed2.y)
        self:getOwnerChara().m_tActiveAttackSpeed = {}
        table.insert(self:getOwnerChara().m_tActiveAttackSpeed, {x=speed.x, y=speed.y, isCollision = speed2.x == 0 and speed2.y == 0})

    end

	self.m_mover:setMoverSpeed(Vector2:create(0,0))
    local windX, windY = WBattleGlobal:getCurrent():getWind().x, WBattleGlobal:getCurrent():getWind().y
    self.m_mover:setFlyAcceleration(- windX, -windY -BattleConstants.g_nFlyGravity.y)
    self.m_mover:setMoverAcceleration(Vector2:create(- windX, -windY -self.m_tAcceleration.y))
end

--@brief	子弹爆炸
function WBullet:markExplode(isMark)
	
	self.m_bIsMark = isMark
	if isMark == true then
		self.m_nCurStatus = BulletStatus.DEF_ST_EXPLODE
	end
end

--@brief	子弹爆炸
function WBullet:explode(isNeedDigHole)
    WZLog("NO_HOLE_ 4", self)
	WZLog("WBullet:explode", self.m_nId, tostring(self.m_ownerChara:getExplodeSoundName()), tostring(self.m_bIsNoHole), self, tostring(isNeedDigHole), tostring(self.m_bIsMark))

    self.m_bIsExplode = true
    if self.m_nCurStatus == BulletStatus.DEF_ST_EXPLODE and self.m_bIsMark ~= true then
        return
    end

    if self.m_ownerChara:getExplodeSoundName() then
        SoundManager:playEffectSound(self.m_ownerChara:getExplodeSoundName())
    elseif self.m_nType == 0 then
        SoundManager:playEffectSound(SoundDefine.E_S_EXPLODE_1)
    else
        SoundManager:playEffectSound(SoundDefine.E_S_EXPLODE_2)
    end
	self.m_nCurStatus = BulletStatus.DEF_ST_EXPLODE
	if self:getBackFire() ~= nil then
		self:getBackFire():stopSystem()
	end
    --某些皮肤大招爆炸时候，镜头微调
    if self.m_bIsSkinBigSkill then
        if self.m_nSkinBigSkill == 3013 then 
            WZLog("WBullet:explode two 3013")
            local tempPos = self:getMover():getMoverPosition()
            tempPos.y = tempPos.y + 680
            BattleScreen:followBullet(tempPos, 2)
        elseif self.m_nSkinBigSkill == 3046 then 
            WZLog("WBullet:explode two 3046")
            local tempPos = self:getMover():getMoverPosition()
            tempPos.y = tempPos.y - 1100
            BattleScreen:followBullet(tempPos, 2)
        end
    end

	self.m_anim:getAnimNode():setVisible(false)

    local x = self:getMover():getMoverPosition().x
    local y = self:getMover():getMoverPosition().y
    self.m_tExplodeElement:explode( {x=x, y=y} )
    if self.m_tExplodeElement2 then 
        if self.m_bIsSkinBigSkill and self.m_nSkinBigSkill == 3011 then 
            DelayCallFunction(self.m_tExplodeElement2.explode, self.m_tExplodeElement2, 0.5, {x=x, y=y} )
        else
	        self.m_tExplodeElement2:explode( {x=x, y=y} )
        end
    end
    if self.m_tExplodeElement3 then 
        self.m_tExplodeElement3:explode( {x=x, y=y} )
    end
    if ProjConfig.DEBUG == 1 and self.m_bIsSkinBigSkill then
        BattleAnimation:addCircle({x = x, y = y} ,self:getExplodeRadius(),{r = 1,g = 1,b = 1,a = 1},SceneBattle:getFrontLayer())
    end
    local realPenetrateMap = false
    if self.m_bIsSpatter then
        realPenetrateMap = self.m_bIsSpatterPenetrateMap
    else
        realPenetrateMap = self.m_bIsPenetrateMap
    end
    if not realPenetrateMap and isNeedDigHole ~= false and WBattleGlobal:getCurrent().m_bMapCanDigHole and self.m_bIsNoHole == nil then
        --皮肤大招挖坑限制
        if self.m_bIsSkinBigSkill then 
            if self.m_nBulletIndex ~= self.m_ownerChara:getAttTimes() and (self.m_nSkinBigSkill ~= 3024 and self.m_nSkinBigSkill ~= 3048 and self.m_nSkinBigSkill ~= 3058 and self.m_nSkinBigSkill ~= 3062) then
                return 
            elseif self.m_nSkinBigSkill == 3023 then 
                self:DigHole_Continue()
                return 
            elseif self.m_nSkinBigSkill == 3029 then 
                self:DigHoleByCount(7)
                return
            elseif self.m_nSkinBigSkill == 3035 then 
                self:DigHoleByCount(7,1)
                return
            elseif self.m_nSkinBigSkill == 3033 or self.m_nSkinBigSkill == 3052 or self.m_nSkinBigSkill == 3053 or self.m_nSkinBigSkill == 3056 or self.m_nSkinBigSkill == 3057 then 
                return 
            end 
        end
        self:DigHole()
    elseif self.m_bIsNoHole == nil then
        table.insert(WBattleGlobal:getCurrent().m_tExplodeInfoCurRound, {id=self:getOwnerChara():getBattleId(), skillId=WBattleGlobal:getCurrent().m_nSkillBeUseCurRound or -1, x=x, y=y, explodeDirection = 0})
    end
end

--@brief	子弹爆炸结束
function WBullet:_XmlActionFinishCallback()
	WZLog("WBullet:_XmlActionFinishCallback",self)
	self.m_nCurStatus = BulletStatus.DEF_ST_END_EXPLODE
end

--@brief	挖坑
function WBullet:DigHole()
    WZLog("WBullet:DigHole 0", self:getOwnerChara():getRectForBulletExplodeBomb().x, self:getOwnerChara():getRectForBulletExplodeBomb().y, tostring(self:getBreakCircle()), tostring(self:getBreakCircleMark()), self.m_mover:getMoverPosition().x, self.m_mover:getMoverPosition().y)
    --挖坑的方向
    local digHoleDir = self:getOwnerChara():getRectForBulletExplodeBomb().digHoleDir
    if digHoleDir and digHoleDir == 5 then 
        if self.m_mover:getMoverPosition().x <= self:getOwnerChara():getPosition().x then 
            digHoleDir = 3
        else
            digHoleDir = 4
        end
    end

    table.insert(WBattleGlobal:getCurrent().m_tExplodeInfoCurRound, {id=self:getOwnerChara():getBattleId(), skillId=WBattleGlobal:getCurrent().m_nSkillBeUseCurRound or -1, x=self.m_mover:getMoverPosition().x, y=self.m_mover:getMoverPosition().y,width=self:getOwnerChara():getRectForBulletExplodeBomb().x,height=self:getOwnerChara():getRectForBulletExplodeBomb().y, explodeDirection = digHoleDir})
    if self:getOwnerChara():getCanDigHole() and (self:getOwnerChara():getRectForBulletExplodeBomb().x > 0 or self:getOwnerChara():getRectForBulletExplodeBomb().y > 0) then
        if WBattleGlobal:getCurrent():isFog() then
            WBattleGlobal:getCurrent():cleanMyBulletFog(self:getPosition(), self:getOwnerChara(), 3, 0, 0, self:getOwnerChara():getRectForBulletExplodeBomb().x, self:getOwnerChara():getRectForBulletExplodeBomb().y)
        end
        if BattleMapManager:drawBroke(self.m_mover:getMoverPosition(),self:getBreakCircle(),self:getBreakCircleMark(),self:getOwnerChara():getRectForBulletExplodeBomb().x,self:getOwnerChara():getRectForBulletExplodeBomb().y, nil, digHoleDir) == false then
			WZLog("terrain broke failed",self.m_mover:getMoverPosition().x,self.m_mover:getMoverPosition().y)
			return
		end

        if WBattleGlobal:getCurrent().m_tIsHighEndMachine == true then
            local msg = MsgManager:createMsg(BattleMsgBulletParticleEffect)
            msg.m_tStartPos = {x=self.m_mover:getMoverPosition().x,y=self.m_mover:getMoverPosition().y}
            msg.m_tStartSpeed = {x=self.m_mover:getCollisionSpeed().x,y=self.m_mover:getCollisionSpeed().y}
            MsgManager:pushNonBlockMsg(msg)
        end
	end
end

--@brief    仅仅是挖坑
function WBullet:DigHoleOnly()
    if WBattleGlobal:getCurrent().m_bMapCanDigHole and self.m_bIsNoHole == nil then
        self:DigHole()
    end
end

--@brief	子弹是否爆炸完毕
--@return	#1:true:是，false：否
function WBullet:explodeIsEnd()
	-- if self.m_nCurStatus == BulletStatus.DEF_ST_END_EXPLODE then
 --        WZLog("WBullet:explodeIsEnd 1")
	-- 	return true
	-- end

	-- if self.m_tExplodeElement:explodeIsEnd() then
 --        WZLog("WBullet:explodeIsEnd 2")
	-- 	return true
	-- end
	if self.m_nCurStatus == BulletStatus.DEF_ST_EXPLODE then
        return true
    end
    
	return false
end

--@brief	检测是否超出屏外
--@return	#1:true:是,false:否
function WBullet:checkOutOfScene()
	local size = self:getAnimSize()
	local pos = self.m_mover:getMoverPosition()
    WZLog("WBullet:checkOutOfScene", tostring(pos.y + size.height < 0), tostring(pos.x + size.width < 0), tostring(pos.x - size.width > SceneBattle:getFrontLayerSize().width), pos.y, size.height, pos.x, size.width, SceneBattle:getFrontLayerSize().width, SceneBattle:getFrontLayerSize().height)
	if pos.y + size.height < 0 then
		return true
	end
    if pos.y + size.height > 5000 then
        return true
    end
	if pos.x + size.width < 0 then
		return true
	end
	if pos.x - size.width > SceneBattle:getFrontLayerSize().width then
		return true
	end
	return false
end

--@brief	检测碰撞
--@param	heros:英雄列表
--@return	#1:true:撞了,false:没撞
--@return	#2:英雄列表
function WBullet:checkCollision()
	-- WZLog("WBullet:checkCollision")

    --溅射子弹一开始不与人物检测碰撞
    -- local isSpatterNocheckCollision = nil
    -- if self.m_bIsSpatter and BattleCommon:pointDis(self.m_tStartPos, self:getPosition()) < 100 then
    --     WZLog("WBullet:checkCollision two", self, tostring(self.m_bIsSpatter), BattleCommon:pointDis(self.m_tStartPos, self:getPosition()))
    --     isSpatterNocheckCollision = true
    -- end
    WZLog("WBullet:checkCollision()")
    --处于溅射弹保护时间
    if self.m_bIsSpatter then
        if self.m_nLiftTime <= BattleConstants.g_fWB_SPATTER_PROTECT_TIME then
            return false,nil
        else
            --不再穿透地图(超过保护时间 非穿透地图溅射)
            if not self.m_bIsSpatterPenetrateMap then
                local collosion = self:checkMapCollision()
                if collosion then
                    return collosion,nil
                end
            end
            return self:checkCharacterCollision()
        end
    end

    --穿透地图碰撞检测
    if self.m_bIsPenetrateMap or self.m_bIsSpatterPenetrateMap then
        if self.m_ownerChara and self.m_ownerChara:getIsSubHero() then --为不影响原来逻辑，只添加对灵魂分身/棋圣分身子弹的判断
            local isHeroCollision,charaList,isReflect = self:checkCharacterCollision()
            local charaBattleId
            isReflect = false

            WZLog("WBullet:checkCollision Two", tostring(self.m_tIsReflectList), Serialize(self.m_tIsReflectList and self.m_tIsReflectList or {}))
            if self.m_tIsReflectList then
    --        WZLog("WBullet:checkCollision four-2", #self.m_tIsReflectList)
                for i,v in pairs (self.m_tIsReflectList) do
                    charaBattleId = i
    --                WZLog("WBullet:checkCollision four-3", charaBattleId, tostring(v))
                    if v and BattleMethod:canReflectBullet(self,charaBattleId,1) then
                        self:addReflectList(charaBattleId,1)
                        charaBattleId = i
                        isReflect = v
                        break
                    end
                end
            end
            if isReflect then
                --反射
                self.m_bIsAllCollision = true 
                self:reflect(isReflect)
                return false, nil
            end
        end
        return self:checkCharacterCollision()
    end
	
	if self.m_mover:isCollision() then
		--self.m_anim:getAnimNode():setPosition(cPos:getX(),cPos:getY())
		--self.m_mover:setMoverPosition(cPos)
        WZLog("WBullet:checkCollision three-2", self, tostring(self.m_bIsSpatter))
		self:stop()
		return true
	--英雄碰撞
	else
        -- if isSpatterNocheckCollision == true then
        --     return false
        -- end

        -- if self.m_nCheckCharacter == 1 then
        --     self.m_nCheckCharacter = 0
        --     return false
        -- end
        -- self.m_nCheckCharacter = 1
		local isHeroCollision,charaList,isReflect = self:checkCharacterCollision()
        local charaBattleId
        isReflect = false

        WZLog("WBullet:checkCollision four-1", tostring(self.m_tIsReflectList), Serialize(self.m_tIsReflectList and self.m_tIsReflectList or {}))
        if self.m_tIsReflectList then
--        WZLog("WBullet:checkCollision four-2", #self.m_tIsReflectList)
            for i,v in pairs (self.m_tIsReflectList) do
                charaBattleId = i
--                WZLog("WBullet:checkCollision four-3", charaBattleId, tostring(v))
                if v and BattleMethod:canReflectBullet(self,charaBattleId,1) then
                    self:addReflectList(charaBattleId,1)
                    charaBattleId = i
                    isReflect = v
                    break
                end
            end
        end
        if isReflect then
            --反射
            self.m_bIsAllCollision = true 
            self:reflect(isReflect)
            return false, nil
        end

		if isHeroCollision then
			local isPenetrateList = {}
			local penetrateMonsterList = {}
			-- for i,v in pairs(charaList) do
			-- 	if v.m_bPenetrate == true then
			-- 		isPenetrateList[i] = true
			-- 		table.insert(penetrateMonsterList, v)
			-- 	end
			-- end
			-- if BattleCommon:tableLen(isPenetrateList) < BattleCommon:tableLen(charaList) then
   --              WZLog("WBullet:checkCollision three-3", self, tostring(self.m_bIsSpatter))
			-- 	self:stop()
			-- else
				return isHeroCollision, penetrateMonsterList
			-- end
		end
		return isHeroCollision, nil
	end
end

--@brief	子弹反射
function WBullet:reflect(reflectData)
    local charaPos = reflectData.pos
    local bulletPos = self.m_mover:getMoverPosition()
    local bulletSpeed = self.m_mover:getMoverSpeed()

    local r = BattleCommon:reflectVector(charaPos,bulletPos,bulletSpeed)
    self.m_mover:setMoverSpeed(Vector2:create(r.x,r.y))
end

--@brief	检测人物碰撞
--@return	#1:true:撞了,false:没撞
--@return	#2:碰撞的人物列表
function WBullet:checkCharacterCollision()
	--WZLog("WBullet:checkHeroCollision")
    local curPos = self:getMover():getMoverPosition()
    local posList = {}
    local prePos = nil
    if self:getMover():getMoverPrePosition() then
        prePos =  {x = self:getMover():getMoverPrePosition().x,y = self:getMover():getMoverPrePosition().y}
        --起点不可能为0
        if prePos.x == 0 or prePos.y == 0 then
            prePos = nil
        end
    end
    
    while prePos and math.abs(curPos.x - prePos.x) > 30 do
        local dir = 1
        if curPos.x < prePos.x then
            dir = -1
        end
        local tx = prePos.x + 30*dir
        local ty = prePos.y + math.abs(30/(curPos.x - prePos.x))*(curPos.y - prePos.y)
        local midPos = Vector2:create(tx,ty)
        table.insert(posList,midPos)

        prePos = {x = tx, y = ty}
    end
    table.insert(posList,curPos)
    -- for i,v in pairs(posList) do
    --     WZLog("WBullet:checkHeroCollision List",v.x,v.y)
    -- end
	local tmpCharas = {}
	local isCollision = false
    for k,checkPos in ipairs(posList) do
    	for i,charaList in ipairs(self.m_tCollisionCharacters) do

            local isCollisionInList,collisionCharas,isReflect = self:checkCollisionWithCharacterList(checkPos,self.m_nCollisionRadius,charaList)
--            WZLog("WBullet:checkCollision three", tostring(isReflect))
            if isReflect then
                return false,{},isReflect
            end

    		if not isCollision then
    			isCollision = isCollisionInList
    		end

    		AddTableToTable(tmpCharas,collisionCharas)
    	end

        if isCollision then
            -- self.m_mover:setMoverPosition(Vector2:create(checkPos.x,checkPos.y))
            -- WZLog("WBullet:checkCollision collosion",curPos.x)

    	   return isCollision,tmpCharas
        end
    end
    return false,{}
end

--@brief	检查人物碰撞
--@param	pos:子弹位置
--@param	raduis:子弹半径
--@param	charaList:人物列表
--@return	#1:true:撞了,false:没撞
--@return	#2:碰撞的人物列表
function WBullet:checkCollisionWithCharacterList(pos,raduis,charaList)
	local tmpCharas = {}
	local isCollision = false
    local isReflect = false
	for id,chara in ipairs(charaList) do
    --    WZLog("WBullet:checkCollisionWithCharacterList one", id, tostring(chara:isDead()), chara:getBattleId())
        local bOffCollision = chara.m_bOffCollision or chara:isInBuffState(EffectTypeConfig.IMMUNITY_ATTACK)
        if not chara:isDead() and not bOffCollision then
            if self.m_bIsAllCollision or chara:getBattleId() ~= self:getOwnerChara():getBattleId() then
                local charaPos = chara:getCenterPos()
                local charaRaidus = chara:getRadiusForBulletCollision()
                local collisionRang = chara:getCollisionRang()
                if chara:getType() == 1 and collisionRang ~= nil and not chara.m_bIsGuaiWithSuit then
                    charaPos = chara:getPosition()
                end

--                WZLog("WBullet:checkCollisionWithCharacterList two", id, chara:getBattleId(), tostring(chara:isDead()), charaPos.x, charaPos.y, charaRaidus)
                local _isCollision = self:checkCollisionWithRang(pos,raduis,charaPos,charaRaidus,collisionRang,true)

    			if _isCollision then
    				WZLog("Bullet:checkCollisionWithCharacterList four", isNoHole)
    				tmpCharas[chara:getBattleId()] = chara
                    isCollision = true
    			end
            end
		end

        if not chara:isDead() then
            local charaPos = chara:getCenterPos()
            isReflect = WBullet.checkCollisionWithReflect(self,pos,raduis,charaPos,chara)
            if isReflect then
                break
            end
        end

        --检测是否碰撞到超暴击区域
        if not chara:isDead() and chara:getSuperCritCollisionRang() and chara:getCollisionSuperCritMark() ~= 1 and self.m_ownerChara ~= nil and self.m_ownerChara.m_tSkillTakeEffectSuperCritList ~= nil then 
            local charaPos = chara:getCenterPos()
            local charaRaidus = chara:getRadiusForBulletCollision()
            local collisionRang = chara:getSuperCritCollisionRang()
            if chara:getType() == 1 and collisionRang ~= nil and not chara.m_bIsGuaiWithSuit then
                charaPos = chara:getPosition()
            end

--            WZLog("WBullet:checkCollisionWithCharacterList five", id, chara:getBattleId(), tostring(chara:isDead()), charaPos.x, charaPos.y, charaRaidus)
            local _isCollision = self:checkCollisionWithRang(pos,raduis,charaPos,charaRaidus,collisionRang,true)

            if _isCollision then
                chara:setCollisionSuperCritMark(1)
            end
        end
	end
	return isCollision,tmpCharas,isReflect
end

--@brief	检查反射区域碰撞
function WBullet:checkCollisionWithReflect(pos,raduis,charaPos,chara)

    local isReflect = false
    local isInBuffState, effect = chara:isInBuffState(EffectTypeConfig.REFLECT,true)
    WZLog("WBullet:checkCollisionWithReflect one", tostring(isInBuffState))
    if isInBuffState then
        local charaRaidus = effect[5] or 60
        WZLog("WBullet:checkCollisionWithReflect two", pos.x,pos.y,charaPos.x,charaPos.y,raduis,charaRaidus)
        if BattleCommon:checkCircleCollosion(pos,raduis,charaPos,charaRaidus) then
            WZLog("WBullet:checkCollisionWithReflect three-0")
            isReflect = {pos=charaPos}
        end
    end

    if self.m_tIsReflectInitList == nil then
        self.m_tIsReflectInitList = {}
        self.m_tIsReflectPreList = {}
        self.m_tIsReflectList = {}
    end
    local index = chara.m_nBattleId
    local isReflectInit

    WZLog("WBullet:checkCollisionWithReflect three-2", tostring(self.m_tIsReflectInitList[index]), tostring(self.m_tIsReflectPreList[index]), tostring(self.m_tIsReflectList[index]))
    if self.m_tIsReflectInitList[index] == nil or self.m_tIsReflectInitList[index] == true then
        if isReflect then
            self.m_tIsReflectInitList[index] = true
            isReflectInit = false
        else
            self.m_tIsReflectInitList[index] = false
        end
    end

    if self.m_tIsReflectPreList[index] == true then
        if isReflect then
            self.m_tIsReflectPreList[index] = true
            isReflect = false
        else
            self.m_tIsReflectPreList[index] = false
        end
    end

    if self.m_tIsReflectPreList[index] == false then
        if isReflect then
            self.m_tIsReflectPreList[index] = true
        else
            self.m_tIsReflectPreList[index] = false
        end
    end

    if self.m_tIsReflectPreList[index] == nil then
        if isReflect then
            self.m_tIsReflectPreList[index] = true
        else
            self.m_tIsReflectPreList[index] = false
        end
    end

    if isReflectInit == false then
        isReflect = false
    end
    self.m_tIsReflectList[index] = isReflect
    WZLog("WBullet:checkCollisionWithReflect six", tostring(isReflect), index)
    return isReflect
end

--@brief	检查区域碰撞
--@param	rang:区域
--@param    isOnlyCheck:只检查圆与矩形相交
--@return	#1:true:撞了,false:没撞
function WBullet:checkCollisionWithRang(pos,raduis,charaPos,charaRaidus,collisionRang,isOnlyCheck)
    local dis = nil
	if collisionRang ~= nil then
		for i,rang in pairs(collisionRang) do
			if rang.m_nType == 0 then
				-- local tmpCharaPos = Vector2:create(charaPos.x + rang.m_fXOffset,charaPos.y + rang.m_fYOffset)
                local isColl = false
                if self.m_bIsSkinBigSkill and (self.m_nSkinBigSkill == 3023) then 
                    isColl, dis = BattleCommon:checkCircleCollisionWithSkewRect(charaPos, charaRaidus, self.m_tStartPos, self.m_tStartSpeed, raduis)
                elseif self.m_bIsSkinBigSkill and (self.m_nSkinBigSkill == 3029 or self.m_nSkinBigSkill == 3035) then
                    local bulletCount = 7
                    isColl, dis = BattleCommon:checkCircleCollisionWithSkewRect2(charaPos, charaRaidus, self.m_tStartPos, self.m_tStartSpeed, raduis, bulletCount)
                else
                    isColl = BattleCommon:checkCircleCollosion(pos,raduis,charaPos,charaRaidus)
                end
                WZLog("WBullet:checkCollisionWithRang one", i, tostring(isColl), tostring(dis), pos.x, pos.y, charaPos.x, charaPos.y, raduis, charaRaidus)
                if isColl then
                    return true, dis
                end
			elseif rang.m_nType == 1 then
				local rect = {x = charaPos.x+rang.m_fXOffset - rang.m_fWidth*0.5,y = charaPos.y+rang.m_fYOffset,w = rang.m_fWidth,h=rang.m_fHeight}
                if self.m_bIsSkinBigSkill and (self.m_nSkinBigSkill == 3023) then 
                    local isColl, dis = BattleCommon:checkRectCollisionWithSkewRect(rect, self.m_tStartPos, self.m_tStartSpeed, raduis)
                    WZLog("WBullet:checkCollisionWithRang two-1", isColl, dis)
                    if isColl then 
                        return true, dis
                    end
                elseif self.m_bIsSkinBigSkill and (self.m_nSkinBigSkill == 3029 or self.m_nSkinBigSkill == 3035) then 
                    local bulletCount = 7
                    local isColl, dis = BattleCommon:checkRectCollisionWithSkewRect2(rect, self.m_tStartPos, self.m_tStartSpeed, raduis, bulletCount)
                    WZLog("WBullet:checkCollisionWithRang two-2", isColl, dis)
                    if isColl then 
                        return true, dis
                    end
                else
    				local circle = {x = pos.x,y=pos.y,r = raduis}
                    local curdis = self:distanceWithCircleAndRect(circle,rect)
                    dis = 9999
                    dis = math.min(curdis, dis)
                    WZLog("WBullet:checkCollisionWithRang two", i, curdis, dis,raduis)
                    if isOnlyCheck then
                        if BattleCommon:rectCircleOverLap(rect,circle) then
                            return true ,dis
                        end
                    else
                        if dis <= raduis then
    					   return true, dis
                        end
    				end
                end
			end
		end
	else
        local isColl = false 
        if self.m_bIsSkinBigSkill and (self.m_nSkinBigSkill == 3023) then 
            isColl, dis = BattleCommon:checkCircleCollisionWithSkewRect(charaPos, charaRaidus, self.m_tStartPos, self.m_tStartSpeed, raduis)
        elseif self.m_bIsSkinBigSkill and (self.m_nSkinBigSkill == 3029 or self.m_nSkinBigSkill == 3035) then 
            local bulletCount = 7
            isColl, dis = BattleCommon:checkCircleCollisionWithSkewRect2(charaPos, charaRaidus, self.m_tStartPos, self.m_tStartSpeed, raduis, bulletCount)
        else
            isColl = BattleCommon:checkCircleCollosion(pos,raduis,charaPos,charaRaidus)
        end
        WZLog("WBullet:checkCollisionWithRang three", tostring(isColl), dis)
		return isColl, dis
	end

    WZLog("WBullet:checkCollisionWithRang four")
	return false, dis
end

--@计算圆与矩形的距离
--@ 矩形四边区域 绝对值
--@ 矩形四角位置，点与角点距离
function WBullet:distanceWithCircleAndRect(circle, rect)
    local dis = 0
    local x=circle.x
    local y=circle.y
    local x1=rect.x
    local x2=rect.x+rect.w
    local y1=rect.y
    local y2=rect.y+rect.h

    if x>=x1 and x<=x2 and y>=y1 and y<=y2 then
        dis = 0
    elseif x>=x1 and x<=x2 and y>=y2 then
        dis = y-y2
    elseif x>=x1 and x<=x2 and y<=y1 then
        dis = y1-y
    elseif y>=y1 and y<=y2 and x<=x1 then
        dis = x1-x
    elseif y>=y1 and y<=y2 and x>=x2 then
        dis = x-x2
    elseif x<=x1 and y>=y2 then
        dis = BattleCommon:pointDis({x = x,y = y},{x = x1, y = y2})-- math.min(x1-x,y-y2)
    elseif x<=x1 and y<=y1 then
        dis = BattleCommon:pointDis({x = x,y = y},{x = x1, y = y1})-- math.min(x1-x,y1-y)
    elseif x>=x2 and y>=y2 then
        dis = BattleCommon:pointDis({x = x,y = y},{x = x2, y = y2})-- math.min(x-x2,y-y2)
    elseif x>=x2 and y<=y1 then
        dis = BattleCommon:pointDis({x = x,y = y},{x = x2, y = y1})-- math.min(x-x2,y1-y)
    end
--    WZLog("WBullet:distanceWithCircleAndRect",dis,x,y,x1,x2,y1,y2)
    return dis
end

--@brief	检查伤害
--@param    checkSuperCrit: true时才执行检测是否超暴击
--@return	#1:受伤的人物列表
--@return	#2:受伤值
function WBullet:checkHurt(isNotcalculate, checkSuperCrit)
    WZLog("WBullet:checkHurt zero", tostring(self.m_tCheckHurtWithSkillPos), tostring(isNotcalculate), tostring(checkSuperCrit))
	local tHurtCharas = {}
	local tHurtValues = {}
    local tDistance = {}
    local tCritType = {}
    local tHurtRatio = {}
    local tSuperCritType = {}   --超暴击状态：0未击中超暴击区域，1击中超暴击区域
    if self.m_tCheckHurtWithSkillPos == nil then
        self.m_tCheckHurtWithSkillPos = {x=self:getMover():getMoverPosition().x,y=self:getMover():getMoverPosition().y}

        self.m_tCheckHurtWithSkillCharaPos = {}
        for i,charaList in ipairs(self.m_tCollisionCharacters) do
            for id,chara in ipairs(charaList) do
                if not chara:isDead() then
                    self.m_tCheckHurtWithSkillCharaPos[chara:getBattleId()] = {x=chara:getCenterPos().x,y=chara:getCenterPos().y}
                end
            end
        end
        WZLog("WBullet:checkHurt one", tostring(self.m_tCheckHurtWithSkillPos.x), tostring(self.m_tCheckHurtWithSkillPos.y))
    end
    local totalHurt = 0
	for i,charaList in ipairs(self.m_tCollisionCharacters) do
        for k = 1, #charaList do
            local chara = charaList[k]
            local bOffHurt = chara.m_bOffHurt or chara:isInBuffState(EffectTypeConfig.IMMUNITY_ATTACK)
            if not chara:isDead() and not bOffHurt then
                local id = chara:getBattleId()
                if chara:getMover() ~= nil and chara:getMover().setUpdatable ~= nil  and chara.m_bIsAir == nil then
                    chara:setMoveUpdatable(true)
                    WZLog("chara:setMoveUpdatable 1")
                end

				local pos = self.m_tCheckHurtWithSkillPos or self:getMover():getMoverPosition()
				local raduis = self:getExplodeRadius()
				local charaPos = self.m_tCheckHurtWithSkillCharaPos and self.m_tCheckHurtWithSkillCharaPos[id] or chara:getCenterPos()
                
                local collisionRang = chara:getCollisionRang()
                if chara:getType() ~= 0 and collisionRang ~= nil then
                    charaPos = chara:getPosition()
                end

				charaPos = Vector2:create(charaPos.x,charaPos.y)
				local charaRaidus = chara:getRadiusForHurt()
				local collisionRang = chara:getCollisionRang()
                --伤害判断
                local isColl, dis = self:checkCollisionWithRang(pos,raduis,charaPos,charaRaidus,collisionRang)
                WZLog("checkHurt:=====", self.m_nId, tostring(isNotcalculate), chara:getBattleId(), tostring(isColl),tostring(dis),charaPos.x,charaPos.y)
				if isColl then
                    self.m_bIsHurtPlayer = true
                    --先检测超暴击状态，再计算本次攻击伤害
                    local superCritMark = 0
                    if checkSuperCrit and not self.m_ownerChara:getIsSubHero() then --防止重复检测触发 --灵魂/棋圣 分身的子弹不触发超暴击
                        local superCritDis = self:getHurtDistance(chara,isNoHurt, dis,id,isNotcalculate)
                        local tempMark = chara:getCollisionSuperCritMark()
                        if tempMark == 1 and superCritDis == 0 then 
                            WZLog("WBullet:checkHurt superCrit")
                            superCritMark = 1
                            --暴击增加伤害成长的必须在计算伤害前完成添加，恢复行动值的也放在这里触发
                            self:runSuperCritFunc(superCritMark)
                        end
                        tSuperCritType[id] = superCritMark
                    end
                    local hurtValue, distance, critType,recordRatio = self:getHurt(chara, false, dis,id,isNotcalculate, superCritMark)
                    tHurtCharas[id] = chara
                    tHurtValues[id] = hurtValue
                    tDistance[id] = distance
                    tCritType[id] = critType
                    tHurtRatio[id] = recordRatio
                    totalHurt = totalHurt + hurtValue

                    local isNoHole, pram = chara:getIsNoHole()
                    if (not isNotcalculate) and isNoHole and self.m_bIsNoHole == nil then
                        pram = pram[5]
                        local index = WBattleGlobal:getCurrent().m_nCheckNoHoleIndex
                        local rand = WBattleGlobal:getCurrent().m_tBattleRand[index]
                        if rand < pram then
                            self.m_bIsNoHole = true
                            if self.m_tBullet then
                                self.m_tBullet.m_bIsNoHole = true
                                if self.m_tBullet.m_tBullet then
                                    self.m_tBullet.m_tBullet.m_bIsNoHole = true
                                end
                            end

                            local offSkillId = chara:getIsImmunityByPetSkill(1,EffectTypeConfig.NO_HOLE)
                            if offSkillId then
                                BattlePetSkillManager:triggerPassiveSkillView(chara,offSkillId)
                            end
                        end

                        WZLog("NO_HOLE_ 2", self.m_nId, self, self.m_tBullet)
                        WZLog("WBullet:checkHurt two-0", self.m_nId, chara:getBattleId(), tostring(self.m_bIsNoHole), pram, rand, index)
                        index = index + 1
                        if index > 10 then
                            index = 1
                        end
                        WBattleGlobal:getCurrent().m_nCheckNoHoleIndex = index
                    end

                else
                    local hurtValue, distance, critType,recordRatio = self:getHurt(chara,true,nil,id,isNotcalculate)
                    tHurtCharas[id] = chara
                    tHurtValues[id] = -1
                    tDistance[id] = distance
                    tCritType[id] = critType
                    tHurtRatio[id] = recordRatio
				end
                WZLog("WBullet:checkHurt two-1", id, tostring(pos.x), tostring(pos.y), tostring(charaPos.x), tostring(charaPos.y), tostring(self.m_tCheckHurtWithSkillCharaPos and self.m_tCheckHurtWithSkillCharaPos[id] and self.m_tCheckHurtWithSkillCharaPos[id].x), tostring(self.m_tCheckHurtWithSkillCharaPos and self.m_tCheckHurtWithSkillCharaPos[id] and self.m_tCheckHurtWithSkillCharaPos[id].y), tostring(raduis), tostring(charaRaidus), tostring(collisionRang))
                WZLog("WBullet:checkHurt two-2", id, tostring(tHurtValues[id]), tostring(tDistance[id]), tostring(tCritType[id]),tostring(tHurtRatio[id]))
			end
		end
	end
    -- if self.m_ownerChara then 
    --     self.m_ownerChara:addRoundHurt(totalHurt)
    -- end

    local turnTimes = WBattleGlobal:getCurrent().m_nTurnTimes
--    WZLog("KKKKKKKKKKKKKKKKKKKKK", self:getOwnerChara():getBattleId())
    self:getOwnerChara().m_bActiveAttack = true
    if (self.m_bIsBossBullet == true or isNotcalculate == true) and self:getMover():getMoverPosition() then
        local pos = self:getMover():getMoverPosition()
        local speed = self:getMover():getMoverSpeed()
        table.insert(self:getOwnerChara().m_tActiveAttackPos, {x=pos.x, y=pos.y})

        self:getOwnerChara().m_tActiveAttackSpeed = self:getOwnerChara().m_tActiveAttackSpeed or {}
        table.insert(self:getOwnerChara().m_tActiveAttackSpeed, {x=speed.x, y=speed.y, isCollision = false})
    end

    if self:getOwnerChara().m_tHitTargets == nil then
        self:getOwnerChara().m_tHitTargets = {}
    end
    for i,v in pairs(tHurtCharas) do
    	local isExist = false
    	for j, u in pairs (self:getOwnerChara().m_tHitTargets) do
    		if v:getBattleId() == u:getBattleId() then
    			isExist = true
    		end
    	end
        if tHurtValues[i] ~= -1 and isExist == false then
            table.insert(self:getOwnerChara().m_tHitTargets, v)
        end
    end

    for j, u in pairs (self:getOwnerChara().m_tHitTargets) do
        WZLog("WBullet:checkHurt three-0",j ,u:getBattleId(),u.m_sPlayerName)
    end

    -- 记录每颗子弹打中的人 处女座皮肤大招回血效果需要对每个子弹作区分
    local nScatterNum = self:getOwnerChara():getAttTimes() * self:getOwnerChara():getAttScatterNum()
    WZLog("WBullet:checkHurt four", nScatterNum)
    if self:getOwnerChara().m_tBulletHitTargets == nil then
        self:getOwnerChara().m_tBulletHitTargets = {}
        self:getOwnerChara().m_tBulletHitTargetsHurts = {}
        for i=1,nScatterNum do
           self:getOwnerChara().m_tBulletHitTargets[i] = {}
           self:getOwnerChara().m_tBulletHitTargetsHurts[i] = {}
        end
    end
    if self:getOwnerChara().m_tBulletHitTargets[self.m_nBulletIndex] then
        for i,v in pairs(tHurtCharas) do
            local isExist = false
            for j, u in pairs (self:getOwnerChara().m_tBulletHitTargets[self.m_nBulletIndex]) do
                if v:getBattleId() == u:getBattleId() then
                    isExist = true
                end
            end
            if tHurtValues[i] ~= -1 and isExist == false then
                table.insert(self:getOwnerChara().m_tBulletHitTargets[self.m_nBulletIndex], v)
                table.insert(self:getOwnerChara().m_tBulletHitTargetsHurts[self.m_nBulletIndex], tHurtValues[i])
            end
        end
    end


    WZLog("WBullet:checkHurt three-1", Serialize(tHurtValues), Serialize(tDistance),Serialize(tHurtRatio))
	return tHurtCharas, tHurtValues, tDistance, tCritType, tHurtRatio, tSuperCritType
end

--@brief    获取子弹击中的敌人
--@param    tHitTargets:击中的敌人列表
function WBullet:getHitTargets()
    local tHitTargets = {}

    local isNotcalculate = true
    local tHurtCharas = {}
    local tHurtValues = {}
    if self.m_tCheckHurtWithSkillPos == nil then
        self.m_tCheckHurtWithSkillPos = {x=self:getMover():getMoverPosition().x,y=self:getMover():getMoverPosition().y}

        self.m_tCheckHurtWithSkillCharaPos = {}
        for i,charaList in ipairs(self.m_tCollisionCharacters) do
            for id,chara in ipairs(charaList) do
                if not chara:isDead() then
                    self.m_tCheckHurtWithSkillCharaPos[chara:getBattleId()] = {x=chara:getCenterPos().x,y=chara:getCenterPos().y}
                end
            end
        end
    end
    for i,charaList in ipairs(self.m_tCollisionCharacters) do
        for id,chara in ipairs(charaList) do
            local bOffHurt = chara.m_bOffHurt or chara:isInBuffState(EffectTypeConfig.IMMUNITY_ATTACK)
            if not chara:isDead() and not bOffHurt then
                id = chara:getBattleId()
                if chara:getMover() ~= nil and chara:getMover().setUpdatable ~= nil  and chara.m_bIsAir == nil then
                    chara:setMoveUpdatable(true)
                end

                local pos = self.m_tCheckHurtWithSkillPos or self:getMover():getMoverPosition()
                local raduis = self:getExplodeRadius()
                local charaPos = self.m_tCheckHurtWithSkillCharaPos and self.m_tCheckHurtWithSkillCharaPos[id] or chara:getCenterPos()
                
                local collisionRang = chara:getCollisionRang()
                if chara:getType() ~= 0 and collisionRang ~= nil then
                    charaPos = chara:getPosition()
                end

                charaPos = Vector2:create(charaPos.x,charaPos.y)
                local charaRaidus = chara:getRadiusForHurt()
                local collisionRang = chara:getCollisionRang()
                --伤害判断
                local isColl, dis = self:checkCollisionWithRang(pos,raduis,charaPos,charaRaidus,collisionRang)
                if isColl then
                    local hurtValue, distance, critType,recordRatio = self:getHurt(chara, false, dis,id,isNotcalculate)
                    tHurtCharas[id] = chara
                    tHurtValues[id] = hurtValue
                else
                    local hurtValue, distance, critType,recordRatio = self:getHurt(chara,true,nil,id,isNotcalculate)
                    tHurtCharas[id] = chara
                    tHurtValues[id] = -1
                end
            end
        end
    end

    for i,v in pairs(tHurtCharas) do
        local isExist = false
        for j, u in pairs (tHitTargets) do
            if v:getBattleId() == u:getBattleId() then
                isExist = true
            end
        end
        if tHurtValues[i] ~= -1 and isExist == false then
            table.insert(tHitTargets, v)
        end
    end

    for i,j in pairs (tHitTargets) do
        WZLog("WBullet:getHitTargets",i ,j:getBattleId(), j.m_sPlayerName)
    end
    return tHitTargets
end


--@brief	计算伤害
--@param	chara:英雄
--@return	#1：伤害,#2：距离
function WBullet:getHurt(chara,isNoHurt, dis,id,isNotcalculate, superCritMark)
	local bulletPos = self.m_tCheckHurtWithSkillPos or self:getMover():getMoverPosition()
	local charaPos = self.m_tCheckHurtWithSkillCharaPos and id and self.m_tCheckHurtWithSkillCharaPos[id] or chara:getAnimationCenterPos()
	local distance = BattleCommon:pointDis(bulletPos,charaPos)
	distance = distance - chara:getRadiusForHurt()
    local distance0 = distance
    if chara:getType() == 1 and not chara.m_bIsGuaiWithSuit then
        -- WZLog("getMonsterDistance========================")
        local raduis = self:getExplodeRadius()
        local charaRaidus = chara:getRadiusForHurt()
        local collisionRang = chara:getCollisionRang()
        local charaPos = chara:getPosition()
        local isColl, dis = self:checkCollisionWithRang(bulletPos,raduis,charaPos,charaRaidus,collisionRang)
        distance = dis
        -- WZLog("getMonsterDistance2========================",chara:getPosition().x,chara:getPosition().y,distance)
    end
    distance = distance == nil and distance0 or distance
	distance = (distance > 0 and distance) or 0
    distance = math.floor(distance)
    local distanceCheck = math.floor(dis or distance)
	local hurt, critType,recordRatio = -1, 0,0
    if isNoHurt == nil or isNoHurt == false then
        hurt, critType, distanceCheck,recordRatio = self:calculateHurt(distanceCheck,self:getOwnerChara(),chara,nil,isNotcalculate, nil, superCritMark)
    end
    WZLog("WBullet:getHurt ", chara:getBattleId(), hurt, distance, distanceCheck, tostring(dis), tostring(isNoHurt), bulletPos.x, bulletPos.y, charaPos.x, charaPos.y)
	return hurt, distanceCheck, critType, recordRatio
end

--@brief	根据距离、射击玩家、被射玩家计算出基础伤害值
--@param4   宠物攻击系数
--@return	#1：伤害
function WBullet:calculateHurt(distance,shootHero,targetHero,petCoef,isNotcalculate, isPetCrit, superCritMark)
    WZLog("WBullet:calculateHurt zero0", tostring(isPetCrit))
    -- if targetHero:getIsInvincible() or targetHero.m_bPlayerShief == true then
    --     WZLog("WBullet:calculateHurt zero1-1")
    --     return 1, targetHero:getHurtType(), distance
    -- end

    -- if targetHero:getBeHurtChangeValue() then
    --     WZLog("WBullet:calculateHurt zero1-2")
    --     return math.floor(targetHero:getBeHurtChangeValue()), targetHero:getHurtType(), distance
    -- end
    if not petCoef then
        if shootHero:getHurtChangeValue() then
            WZLog("WBullet:calculateHurt zero1-3")
            return math.floor(shootHero:getHurtChangeValue()), targetHero:getHurtType(), distance
        end
    end

    local hurt = 0
    local attack = nil
    attack = shootHero:getAttack(true)
    --破防
    local wreckDefense = shootHero:getWreckDefense(true)
    --暴击倍率
    local critRate = shootHero:getCriticalhitAttackRate(true) + shootHero.m_nAddCriticalHitProbability
    local critRateBeAtk = targetHero:getCriticalhitAttackRate(true) + targetHero.m_nAddCriticalHitProbability
    --对方防御
    local defend = targetHero:getDefence(true)
    --力量
    local power = shootHero:getPower(true)
    --护甲
    local armor = targetHero:getArmor(true)
    --体质
    local constitution = shootHero:getConstitution(true)
    local constitutionBeAtk = targetHero:getConstitution(true)
    --敏捷
    local agility = shootHero:getAgility(true)
    --幸运
    local lucky = targetHero:getLucky(true)
    --免伤
    local injuryFree = targetHero:getInjuryFree(true)
    --等级
    local level = shootHero.m_nRealLevel
    local levelBeAtk = targetHero.m_nRealLevel

    --减伤
    local reduceAcctak = 0

    local s1, s2, s3, s4, s5, s0 = 0, 0, 0, 0, 0, 0

    s0 = attack * (0.75 + 0.5 * (power + 500) / (power + armor + 1000)) * (0.85 + 0.3 * (constitution + 500) / (constitution + constitutionBeAtk + 1000))

    s2 = defend * (1 - wreckDefense / (wreckDefense + 2500)) / (1.0 * defend * (1 - wreckDefense / (wreckDefense + 2500)) + 5000)
    s3 = 1 + (level - levelBeAtk) /  300
    s4 = 1 - 0.3 * injuryFree / (injuryFree + 2500)

    s5 = (1 - s2) * s3 * s4

    local attackRate = WBattleGlobal:getCurrent().m_tAttackRate
    if shootHero.isNormalAct and not shootHero:isNormalAct() then
        attackRate = 100
    end
    
    reduceAcctak = s0 * s5 * (attackRate / 100)
    local distancePercent = 1
    --WZLog("WBullet:calculateHurt ZERO-2",hurt, distance, shootHero:getRadiusForBulletExplode()*0.3, shootHero:getRadiusForBulletExplode()*0.6)
    if distance > shootHero:getRadiusForBulletExplode() then
        WZLog("WBullet:calculateHurt zero1-4")
        return -1, targetHero:getHurtType(), distance
    elseif distance >= shootHero:getRadiusForBulletExplode()*0.6 then
        reduceAcctak = reduceAcctak*0.3
        distancePercent = 0.3
        --WZLog("WBullet:calculateHurt ZERO1-two")
    elseif distance >= shootHero:getRadiusForBulletExplode()*0.3 then
        reduceAcctak = reduceAcctak*0.7
        distancePercent = 0.7
        --WZLog("WBullet:calculateHurt ZERO1-three")
    end

    --WZLog("WBullet:calculateHurt ZERO-0", s0, s1, s2, s3, s4, s5)
    --WZLog("WBullet:calculateHurt four","体质="..constitution,"敌体质="..constitutionBeAtk,"敏捷="..agility,"幸运="..lucky, "暴击="..critRate, "敌暴击="..critRateBeAtk, "力量="..power, "护甲="..armor, "level="..level, "levelBeAtk="..levelBeAtk,s0,s1,s2,s3,s4,s5,reduceAcctak)

    local hurtRatio = shootHero:getHurtAddPercent(targetHero) or 0
    local hurtRatio2 = shootHero:getHurtMulPercent() or 1
    WZLog("WBullet:calculateHurt ZERO-3",hurt, hurtRatio, hurtRatio2,s2,s4)
    
    local hurtRatio3 = 1
    if not petCoef then
        reduceAcctak = reduceAcctak * (1 + hurtRatio) * hurtRatio2

        --192版本-命运暴击伤害比率
        if shootHero:isFateCrit() then 
            local fateCrit = shootHero:getFateCrit(true)
            WZLog("WBullet:calculateHurt ZERO-3-1", fateCrit)
            hurtRatio3 = fateCrit/10000
            reduceAcctak = reduceAcctak * hurtRatio3
        end
    end

    reduceAcctak = reduceAcctak + reduceAcctak * (targetHero:getBeHurtAddPercent(shootHero) or 0)

    -- 魅惑buff修改伤害比率
    local campHurtRatio = shootHero:getCampHurtAddPercent(targetHero)
    reduceAcctak = reduceAcctak * (1 + campHurtRatio)

    local hurtType, critRateA, randNumber = self:getHurtType(shootHero,targetHero, isPetCrit, superCritMark)
    if isPetCrit then
        targetHero:setHurtType(1)
        WZLog("WBullet:calculateHurt one", hurtType)
    end
    --玩家暴击
    if not petCoef and TeachGroup1.ISBATTLE == nil then
        targetHero:setHurtType(hurtType)
        if targetHero:getIsCriticalHit() then

            local critHurtAddPercent = shootHero:getCritHurtAddPercent()
            local beCritHurtAddPercent = targetHero:getBeCritHurtAddPercent()
            local critHurtAddValue = shootHero:getCritHurtAddValue()
            local beCritHurtAddValue = targetHero:getBeCritHurtAddValue()
            local critHurtAdd = 0
            if not petCoef then
                critHurtAdd = critHurtAddPercent + beCritHurtAddPercent
            end

            hurt = (1.2 + critRate / (critRate + critRateBeAtk + 1) * 0.3 + critHurtAdd) * (reduceAcctak)
            hurt = hurt < 0 and 0 or hurt

            if not petCoef then
                hurt = hurt + critHurtAddValue
                hurt = hurt + beCritHurtAddValue

                if critHurtAddPercent ~= 0 then
                    local offSkillId = shootHero:getIsImmunityByPetSkill(1,EffectTypeConfig.CHANGE_CRIT_HURT_PERCENT)
                    if offSkillId then
                        BattlePetSkillManager:triggerPassiveSkillView(shootHero,offSkillId)
                    end
                end

                if beCritHurtAddPercent ~= 0 then
                    local offSkillId = targetHero:getIsImmunityByPetSkill(1,EffectTypeConfig.CHANGE_BECRIT_HURT_PERCENT)
                    if offSkillId then
                        BattlePetSkillManager:triggerPassiveSkillView(targetHero,offSkillId)
                    end
                end

                if critHurtAddValue ~= 0 then
                    local offSkillId = shootHero:getIsImmunityByPetSkill(1,EffectTypeConfig.CHANGE_CRIT_HURT_ADD_VALUE)
                    if offSkillId then
                        BattlePetSkillManager:triggerPassiveSkillView(shootHero,offSkillId)
                    end
                end

                if beCritHurtAddValue ~= 0 then
                    local offSkillId = targetHero:getIsImmunityByPetSkill(1,EffectTypeConfig.CHANGE_BECRIT_HURT_ADD_VALUE)
                    if offSkillId then
                        BattlePetSkillManager:triggerPassiveSkillView(targetHero,offSkillId)
                    end
                end
            end
            WZLog("WBullet:calculateHurt two", critHurtAddPercent, beCritHurtAddPercent, critHurtAddValue, beCritHurtAddValue)
        else
        --非暴击
            hurt =  (reduceAcctak);
        end
    else
        hurt =  (reduceAcctak);
    end
   
    --宠物攻击比率 （包含暴击 宠物资质）
    if petCoef then
        hurt = hurt * petCoef
    end
    
    --己方 固定伤害（宠物排除）
    if not petCoef then
        hurt = hurt + (shootHero:getHurtAddValue() or 0)

        if shootHero:getHurtAddValue() and shootHero:getHurtAddValue() ~= 0 then
            local offSkillId = shootHero:getIsImmunityByPetSkill(1,EffectTypeConfig.CHANGE_HURT_PERCENT)
            offSkillId = offSkillId or shootHero:getIsImmunityByPetSkill(1,EffectTypeConfig.CHANGE_HURT_ADD_VALUE)
            if offSkillId then
                BattlePetSkillManager:triggerPassiveSkillView(shootHero,offSkillId)
            end
        end

        if shootHero:getHurtMulPercent() and shootHero:getHurtMulPercent() ~=0 then
            local offSkillId = shootHero:getIsImmunityByPetSkill(1,EffectTypeConfig.CHANGE_HURT_MUL_PERCENT)
            if offSkillId then
                BattlePetSkillManager:triggerPassiveSkillView(shootHero,offSkillId)
            end
        end
    end
    --WZLog("WBullet:calculateHurt ZERO-4",hurt, targetHero:getBeHurtAddPercent(shootHero) or 0, shootHero:getHurtAddValue() or 0)

    --敌方 固定伤害
    hurt = hurt + (targetHero:getBeHurtAddValue(hurt) or 0)
    
    if hurt < 1 then
        hurt = 1
    end
    --WZLog("WBullet:calculateHurt ZERO-5",hurt, targetHero:getBeHurtAddValue() or 0)

--    MsgBoxManager:showTipBox("爆炸范围" .. shootHero:getRadiusForBulletExplode())
    if isNotcalculate == nil then
        WZLog("WBullet:calculateHurt end", "shootHeroID", shootHero:getBattleId(), "targetHeroId", targetHero:getBattleId(),
            "\nhurt",hurt ,
            "\ndistance", distance,
            "\nexplodeRadius", shootHero:getRadiusForBulletExplode(),
            "\nhurtRatio", shootHero:getHurtAddPercent(targetHero) and shootHero:getHurtAddPercent(targetHero) + 1 or 1,
            "\nhurtRatioB", shootHero:getHurtMulPercent(),
            "\nbHurtRatio", targetHero:getBeHurtAddPercent(shootHero) and targetHero:getBeHurtAddPercent(shootHero) + 1 or 1,
            "\n攻击方暴击", critRate,
            "\n攻击方敏捷", agility,
            "\n被攻击方幸运", targetHero:getLucky(true),
            "\n被攻击方免爆", targetHero:getReduceCrit(true),
            "\ncritRateAdd",shootHero:getCritProbability(true),
            "\nbeCritRateAdd",targetHero:getBeCritRate(true),
            "\n最终暴击率",critRateA,
            "\nrandNumber",randNumber,
            "\ncritHurtRate",shootHero:getCritHurtAddPercent(),
            "\nBeCritHurtRate",targetHero:getBeCritHurtAddPercent(),
            "\ncritHurtAdd",shootHero:getCritHurtAddValue(),
            "\nBeCritHurtAdd",targetHero:getBeCritHurtAddValue(),
            "\n攻击方暴击", critRate,
            "\n被攻击方暴击", critRateBeAtk,
            "\n暴击伤害比率", (1.2 + critRate / (critRate + critRateBeAtk + 1) * 0.3),
            "\n世界boss鼓舞",
            "\n攻击方爆破范围", shootHero:getRadiusForBulletExplode(),
            "\n爆炸距离", distance,
            "\n攻击方攻击", attack,
            "\n攻击方力量", power,
            "\n攻击方体质", constitution,
            "\n攻击方敏捷", agility,
            "\n攻击方破防", wreckDefense,
            "\n攻击方等级", level,
            "\n被攻击方护甲", armor,
            "\n被攻击方体质", constitutionBeAtk,
            "\n被攻击方幸运", lucky,
            "\n被攻击方防御", defend,
            "\n被攻击方等级", levelBeAtk,
            "\n被攻击方免伤", injuryFree,
            "\n被攻击方暴击", critRateBeAtk,
            "\n伤害浮动", attackRate,
            "\n爆炸范围百分比伤害", distancePercent,
            "\nhurtAppend", shootHero:getHurtAddValue() or 0,
            "\nbhurtAppend", targetHero:getBeHurtAddValue() or 0,
            "\n宠物资质比率", petCoef or 0,
            "\n是否暴击", targetHero:getHurtType(),
            "\nhurtRatio3", hurtRatio3
            )
    end
    
    --校验
    local recordRatio = 1
    if not petCoef then
        recordRatio = (1 + hurtRatio)
        if not petCoef then
            recordRatio = recordRatio * hurtRatio2 * hurtRatio3
        end
        -- WZLog("WBullet recordRatio-1",recordRatio)
        local critHurtAddPercent = shootHero:getCritHurtAddPercent()
        local beCritHurtAddPercent = targetHero:getBeCritHurtAddPercent()
        
        local critHurtAdd = 0
        if not petCoef then
            critHurtAdd = critHurtAddPercent + beCritHurtAddPercent
        end

        if targetHero:getIsCriticalHit() then
            recordRatio = recordRatio * (1.2 + critRate / (critRate + critRateBeAtk + 1) * 0.3 + critHurtAdd)
        end

        -- WZLog("WBullet recordRatio-2",recordRatio)
        recordRatio = recordRatio * distancePercent * (1 + (targetHero:getBeHurtAddPercent(shootHero) or 0))

        -- 魅惑buff修改伤害比率
        recordRatio = recordRatio * (1 + campHurtRatio)

        -- WZLog("WBullet recordRatio-3",recordRatio)
        recordRatio = recordRatio * (attackRate/100)
        if hurt ~= 0 then
            recordRatio = recordRatio * math.ceil(hurt)/hurt
        end
        if hurt < 1 then
            hurt = 1
        end
       
        -- WZLog("WBullet recordRatio-6",recordRatio)
    end

    -- WZLog("WBullet:calculateHurt four ", GlobalGame.g_nWorldBossInspire,tostring(WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_WORLDBOSS))
    --世界Boss鼓舞
    if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS and WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_WORLDBOSS and shootHero:getId() == WBattleGlobal:getCurrent():getMyHero():getId() then
        hurt = hurt * (1 + GlobalGame.g_nWorldBossInspire/10000)
        WZLog("WBullet:calculateHurt four worldBoss", GlobalGame.g_nWorldBossInspire/10000, math.ceil(hurt))
    else
        if shootHero.m_nInspire and shootHero.m_nInspire > 0 then
            hurt = hurt * (1 + shootHero.m_nInspire/10000)
            WZLog("WBullet:calculateHurt four inspire", shootHero.m_nInspire/10000, math.ceil(hurt))
        end
    end
    
    return math.ceil(hurt), targetHero:getHurtType(), distance,recordRatio
end

--@brief	获取受伤类型
--@param	shootHero:射击的英雄
--@param	targetHero:目标英雄
--@return	#1:0:普通，1:暴击，2:超暴击
function WBullet:getHurtType(shootHero,targetHero,isPetCrit, superCritMark)
    WZLog("WBullet:getHurtType", isPetCrit)

    local hurtType = 0
    if true then
        --速度
        local agility = shootHero.m_nAgility
        --幸运
        local lucky = targetHero.m_nLucky
        --暴击
        local crit = shootHero.m_nCriticalhitAttackRate
        --免爆
        local reduceCrit = targetHero:getReduceCrit()

        --暴击概率
        local critProbability = shootHero:getCritProbability(true)
        --免暴击概率
        local beCritRate = targetHero:getBeCritRate(true)

        local critRate = (0.5 + 0.5 * (crit - reduceCrit + 1) / (crit + reduceCrit + 1)) * 10000 + critProbability + beCritRate

        if critProbability ~= 0 then
            local offSkillId = shootHero:getIsImmunityByPetSkill(1,EffectTypeConfig.CHANGE_ATTRIBUTE_VALUE, AttributeConfig.CritProbability)
            offSkillId = offSkillId or shootHero:getIsImmunityByPetSkill(1,EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT, AttributeConfig.CritProbability)
            if offSkillId then
                BattlePetSkillManager:triggerPassiveSkillView(shootHero,offSkillId)
            end
        end

        if beCritRate ~= 0 then
            local offSkillId = targetHero:getIsImmunityByPetSkill(1,EffectTypeConfig.CHANGE_ATTRIBUTE_VALUE, AttributeConfig.ReduceCritRate)
            offSkillId = offSkillId or targetHero:getIsImmunityByPetSkill(1,EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT, AttributeConfig.ReduceCritRate)
            if offSkillId then
                BattlePetSkillManager:triggerPassiveSkillView(targetHero,offSkillId)
            end
        end

        local randNumber = 10000
        if #WBattleGlobal:getCurrent().m_tBattleRand > 0 then
            randNumber = WBattleGlobal:getCurrent().m_tBattleRand[1] + 1
        end

        if superCritMark and superCritMark == 1 then
            hurtType = 2
        elseif randNumber <= critRate or isPetCrit then
            hurtType = 1
        else
            hurtType = 0
        end
        WZLog("WBullet:getHurtType one", crit, reduceCrit, critProbability, beCritRate)
        WZLog("WBullet:getHurtType two critRate",critRate,"\nrandNumber",randNumber)
        return hurtType, critRate, randNumber
    end


end

--@brief	检测是否超过地图的高度
--@return	#1:超出的高度
function WBullet:checkHigherThanMap()
	--WZLog("WBullet:checkHigherThanMap")
	local size = self:getAnimSize()
	local pos = self.m_mover:getMoverPosition()

	local height =  pos.y - size.height - SceneBattle:getFrontLayerSize().height

    --WZLog("WBullet:checkHigherThanMap height = "..height.." pos.y = "..pos.y.." SceneBattle:getFrontLayer():getContentSize().height = "..SceneBattle:getFrontLayer():getContentSize().height)
    if height < 0 then
        height = 0
    end

	return height / 10.0
end

--@brief	显示子弹高度
function WBullet:showHeight()
	--WZLog("WBullet:showHeight")

    local curPos = self.m_mover:getMoverPosition()
	local height = self:checkHigherThanMap()
    if height > 0 then

        --检查是否已经有其它炮弹的Label显示在地图上,只能有一个label显示出来
        local isLabelInMap = false
        local bullets = WBattleGlobal:getCurrent():getBulletsList()
        for id, bullet in pairs(bullets) do
            if bullet.m_tHigherThanMapLabel ~= nil then
                isLabelInMap = true
            end
        end

        if not isLabelInMap then
            --初始化Label
            local ttf = WZUILabelTTF:create()
            ttf:setColor(GlobalMethod:ccc3(255,255,255))
            ttf:setFontSize(30)

            self.m_tHigherThanMapLabel = ttf
            SceneBattle:getTopInfoLayer():addChild(self.m_tHigherThanMapLabel)
        end

        if self.m_tHigherThanMapLabel ~= nil then
            local posX = curPos.x
            local posY = SceneBattle:getFrontLayerSize().height - self.m_tHigherThanMapLabel:getContentSize().height

            --修正X坐标
            local labelWidth = self.m_tHigherThanMapLabel:getContentSize().width
            local mapWidth = SceneBattle:getFrontLayerSize().width
            if posX < labelWidth then
                posX = labelWidth
            elseif posX > mapWidth - labelWidth then
                posX = mapWidth -  labelWidth
            end

            --坐标转换成世界坐标
            local point = SceneBattle:getFrontLayer():convertToWorldSpaceAuto(CCAutoPoint:create(posX,posY))
            point = SceneBattle:getInfoLayer():convertToNodeSpaceAuto(point)

            local text = LocalStrings.BULLET_HEIGHT
            text = string.format(text, height)

            --更新高度和位置
            self.m_tHigherThanMapLabel:setText(text)
            self.m_tHigherThanMapLabel:setPosition(point.x,point.y)
        end
    else
        if self.m_tHigherThanMapLabel ~= nil then
            self.m_tHigherThanMapLabel:setVisible(false)
        end
    end
end

function WBullet:setCharMoveUpdatable()
    local charaList = WBattleGlobal:getCurrent():getCharacterList()
    for id,chara in pairs(charaList) do
        if not chara:isDead() then
            if chara:getMover() ~= nil and chara:getMover().setUpdatable ~= nil  and chara.m_bIsAir == nil then
                chara:setMoveUpdatable(true)
                WZLog("chara:setMoveUpdatable 2")
            end
        end
    end
end

--@brief 插入反弹队列
--@param type 1-反射盾,2-龙卷风
function WBullet:addReflectList(battleId,type)
    local flag = tostring(battleId).."_"..tostring(type)
    table.insert(self.m_tAllReflectList,flag)
end

--@brief 检查反弹队列最后一个判断是否可以反弹
function WBullet:checkCanReflect(battleId,type)
    WZLog("WBullet:checkCanReflect-1",#self.m_tAllReflectList)
    if #self.m_tAllReflectList == 0 then
        return true
    end

    if #self.m_tAllReflectList > 5 then
        return false
    end

    local flag = tostring(battleId).."_"..tostring(type)
    local flagLast = self.m_tAllReflectList[#self.m_tAllReflectList]
    WZLog("WBullet:checkCanReflect-2",flag,flagLast)
    if flag ~= flagLast then
        return true
    end
    return false
end

--@brief    设置子弹索引
function WBullet:setBulletIndex(nIndex)
    -- body
    self.m_nBulletIndex = nIndex
end

--@brief    获取子弹索引
function WBullet:getBulletIndex()
    -- body
    return self.m_nBulletIndex
end

--@brief    获取爆炸标记
function WBullet:getMarkExplode()
    -- body
    return self.m_bIsMark
end

--@brief    获取爆炸标记
function WBullet:isStartExplode()
    -- body
    return self.m_nCurStatus == BulletStatus.DEF_ST_EXPLODE
end

--@brief    检测子弹是否击中角色的超暴击区域
function WBullet:checkCollisionSuperCritArea(chara, pos, raduis, charaPos, charaRaidus, collisionRang)
    --body
    if self.m_ownerChara == nil or self.m_ownerChara.m_tSkillTakeEffectSuperCritList == nil then return 0 end  

    local superCritMark = 0 
    if collisionRang ~= nil then
        for i,rang in pairs(collisionRang) do
            if rang.m_nType == 0 then
                local centerpos = chara:getCenterPos()
                local topMidPos = {x = centerpos.x, y = centerpos.y + charaRaidus*0.5}
                local circle = {x = pos.x,y=pos.y,r = raduis}

                local curdis = BattleCommon:pointDis(circle, topMidPos)
                WZLog("WBullet:checkCollisionSuperCritArea one", curdis, charaRaidus, raduis, charaRaidus * 0.5 + raduis/5)
                if curdis <= charaRaidus * 0.5 + raduis/5 then 
                    superCritMark = 1
                    break 
                end
            elseif rang.m_nType == 1 then
                local rect = {x = charaPos.x+rang.m_fXOffset - rang.m_fWidth*0.5,y = charaPos.y+rang.m_fYOffset,w = rang.m_fWidth,h=rang.m_fHeight}
                -- local topMidPos = {x = charaPos.x+rang.m_fXOffset, y = rect.y + rect.h}
                local circle = {x = pos.x,y=pos.y,r = raduis}
                -- local curdis = BattleCommon:pointDis(circle, topMidPos)
                -- WZLog("WBullet:checkCollisionSuperCritArea two", curdis, rect.w, raduis, rect.w * 0.5 + raduis/5)
                -- WZLog("WBullet:checkCollisionSuperCritArea three", pos.x, pos.y, charaPos.x, charaPos.y, rang.m_fXOffset, rang.m_fYOffset, rang.m_fWidth, rang.m_fHeight)
                if circle.x >= rect.x + rang.m_fWidth/4 and circle.x <= rect.x + rang.m_fWidth - rang.m_fWidth/4 and circle.y >= rect.y + rang.m_fHeight - 10 and circle.y <= rect.y + rang.m_fHeight + 10 then 
                    superCritMark = 1
                    break 
                end
            end
        end
    else
        local centerpos = chara:getCenterPos()
        local topMidPos = {x = centerpos.x, y = centerpos.y + charaRaidus*0.5}
        local circle = {x = pos.x,y=pos.y,r = raduis}

        local curdis = BattleCommon:pointDis(circle, topMidPos)
        WZLog("WBullet:checkCollisionSuperCritArea two", curdis, charaRaidus, raduis, charaRaidus * 0.5 + raduis/5)
        if curdis <= charaRaidus * 0.5 + raduis/5 then 
            superCritMark = 1
        end
    end
    
    return superCritMark
end

--@brief    超暴击条件满足，触发超暴击逻辑
function WBullet:runSuperCritFunc(superCritMark)
    -- body
    if superCritMark == 1 then
        if self.m_ownerChara == nil or self.m_ownerChara.m_tSkillTakeEffectSuperCritList == nil then return end  
        for i = 1, #self.m_ownerChara.m_tSkillTakeEffectSuperCritList do
            local skillInfo = GDatatab_skill["id_" .. self.m_ownerChara.m_tSkillTakeEffectSuperCritList[i]]
            local effectInfo = GDatatab_effect["id_" .. skillInfo.effect_id[1][1]]
            if effectInfo then 
                local bAddHurtPercent = false 
                for j, effect in pairs(effectInfo.effect) do
                    local effectParam = effect[3] .. "_" .. effect[4]
                    if effectParam == EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT_HURT or effectParam == EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT_HURT2 or effectParam == EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT_HURT3 then 
                        bAddHurtPercent = true 
                    elseif effectParam == EffectTypeConfig.CHANGE_HURT_PERCENT then 
                        bAddHurtPercent = true 
                        if self.m_ownerChara.m_nSuperCritCount and self.m_ownerChara.m_nSuperCritCount <= 0 then 
                            g_nSuperCritHappenMark = 0
                            self.m_ownerChara.m_nSuperCritCount = self.m_ownerChara.m_nSuperCritCount + 1
                            self.m_ownerChara:changeAttrListValue("m_nHurtAddPercent", effect[5])
                        end
                    elseif effectParam == EffectTypeConfig.CHANGE_ATTRIBUTE_VALUE then 
                        local Attribute = {}
                        for i, v in pairs (AttributeConfig)do
                            Attribute[v] = i
                        end
                        self.m_ownerChara:changeAttrListValue("m_n"..Attribute[effect[5]].."AddValue", effect[6])
                    end
                end

                if not bAddHurtPercent then 
                    WZLog("WBullet:runSuperCritFunc", effectParam)
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
                        skillInfo.id, TakeEffectType.SUPERCRIT,
                        nil,nil,nil,nil
                        )
                end
            end
        end
    end
end

--@brief    计算距离
--@param    chara:英雄
--@return   距离
function WBullet:getHurtDistance(chara,isNoHurt, dis,id,isNotcalculate)
    local bulletPos = self.m_tCheckHurtWithSkillPos or self:getMover():getMoverPosition()
    local charaPos = self.m_tCheckHurtWithSkillCharaPos and id and self.m_tCheckHurtWithSkillCharaPos[id] or chara:getAnimationCenterPos()
    local distance = BattleCommon:pointDis(bulletPos,charaPos)
    distance = distance - chara:getRadiusForHurt()
    local distance0 = distance
    if chara:getType() == 1 and not chara.m_bIsGuaiWithSuit then
        -- WZLog("getMonsterDistance========================")
        local raduis = self:getExplodeRadius()
        local charaRaidus = chara:getRadiusForHurt()
        local collisionRang = chara:getCollisionRang()
        local charaPos = chara:getPosition()
        local isColl, dis = self:checkCollisionWithRang(bulletPos,raduis,charaPos,charaRaidus,collisionRang)
        distance = dis
        -- WZLog("getMonsterDistance2========================",chara:getPosition().x,chara:getPosition().y,distance)
    end
    distance = distance == nil and distance0 or distance
    distance = (distance > 0 and distance) or 0
    distance = math.floor(distance)
    local distanceCheck = math.floor(dis or distance)

    return distanceCheck
end

--@brief    连续挖坑
function WBullet:DigHole_Continue()
    WZLog("WBullet:DigHole_Continue 0", self:getOwnerChara():getRectForBulletExplodeBomb().x, self:getOwnerChara():getRectForBulletExplodeBomb().y, tostring(self:getBreakCircle()), tostring(self:getBreakCircleMark()), self.m_mover:getMoverPosition().x, self.m_mover:getMoverPosition().y)
    --挖坑的方向
    local digHoleDir = self:getOwnerChara():getRectForBulletExplodeBomb().digHoleDir
    if digHoleDir and digHoleDir == 5 then 
        if self.m_mover:getMoverPosition().x <= self:getOwnerChara():getPosition().x then 
            digHoleDir = 3
        else
            digHoleDir = 4
        end
    end

    local digHoleX = self.m_mover:getMoverPosition().x
    local digHoleY = self.m_mover:getMoverPosition().y
    local size = SceneBattle:getFrontLayer():getContentSize()
    local _, tSpeed = BattleCommon:vectorNormalize(self.m_tStartSpeed)
    local nDigHoleCount = 20
    if math.abs(tSpeed.x) >= math.abs(tSpeed.y) then 
        if tSpeed.x > 0 then 
            nDigHoleCount = math.ceil((size.width - digHoleX)/(tSpeed.x*BattleConstants.g_fWB_CONTINUE_DIGHOLE_DIS)) + 1
        else
            nDigHoleCount = math.ceil(digHoleX/(math.abs(tSpeed.x)*BattleConstants.g_fWB_CONTINUE_DIGHOLE_DIS)) + 1
        end
    else
        if tSpeed.y > 0 then 
            nDigHoleCount = math.ceil((size.height - digHoleY)/(tSpeed.y*BattleConstants.g_fWB_CONTINUE_DIGHOLE_DIS)) + 1
        else
            nDigHoleCount = math.ceil(digHoleY/(math.abs(tSpeed.y)*BattleConstants.g_fWB_CONTINUE_DIGHOLE_DIS)) + 1
        end
    end

    for i = 1, nDigHoleCount do
        table.insert(WBattleGlobal:getCurrent().m_tExplodeInfoCurRound, {id=self:getOwnerChara():getBattleId(), skillId=WBattleGlobal:getCurrent().m_nSkillBeUseCurRound or -1, x=digHoleX, y=digHoleY,width=self:getOwnerChara():getRectForBulletExplodeBomb().x,height=self:getOwnerChara():getRectForBulletExplodeBomb().y, explodeDirection = digHoleDir})
        if self:getOwnerChara():getCanDigHole() and (self:getOwnerChara():getRectForBulletExplodeBomb().x > 0 or self:getOwnerChara():getRectForBulletExplodeBomb().y > 0) then
            if WBattleGlobal:getCurrent():isFog() then
                WBattleGlobal:getCurrent():cleanMyBulletFog({x = digHoleX, y = digHoleY}, self:getOwnerChara(), 3, 0, 0, self:getOwnerChara():getRectForBulletExplodeBomb().x, self:getOwnerChara():getRectForBulletExplodeBomb().y)
            end
            WZLog("WBullet:DigHole_Continue", digHoleX, digHoleY, nDigHoleCount)
            if BattleMapManager:drawBroke(Vector2:create(digHoleX, digHoleY), self:getBreakCircle(),self:getBreakCircleMark(),self:getOwnerChara():getRectForBulletExplodeBomb().x,self:getOwnerChara():getRectForBulletExplodeBomb().y, nil, digHoleDir) == false then
                WZLog("terrain broke failed", digHoleX, digHoleY)
                return
            end
        end
        if digHoleX < 0 or digHoleY < 0 or digHoleX > size.width or digHoleY > size.height then 
            break 
        end

        digHoleX = digHoleX + tSpeed.x*BattleConstants.g_fWB_CONTINUE_DIGHOLE_DIS
        digHoleY = digHoleY + tSpeed.y*BattleConstants.g_fWB_CONTINUE_DIGHOLE_DIS
    end
end

--@brief    根据数量连续挖坑
--@param    nCount:挖坑数
--@param    nNotDig:前几个不挖坑,可为空,默认是0
function WBullet:DigHoleByCount(nCount,nNotDig)
    WZLog("WBullet:DigHoleByCount 0", self:getOwnerChara():getRectForBulletExplodeBomb().x, self:getOwnerChara():getRectForBulletExplodeBomb().y, tostring(self:getBreakCircle()), tostring(self:getBreakCircleMark()), self.m_mover:getMoverPosition().x, self.m_mover:getMoverPosition().y)
    --挖坑的方向
    local digHoleDir = self:getOwnerChara():getRectForBulletExplodeBomb().digHoleDir
    if digHoleDir and digHoleDir == 5 then 
        if self.m_mover:getMoverPosition().x <= self:getOwnerChara():getPosition().x then 
            digHoleDir = 3
        else
            digHoleDir = 4
        end
    end

    local digHoleX = self.m_mover:getMoverPosition().x
    local digHoleY = self.m_mover:getMoverPosition().y
    local size = SceneBattle:getFrontLayer():getContentSize()
    local _, tSpeed = BattleCommon:vectorNormalize(self.m_tStartSpeed)
    local nDigHoleCount = nCount or 1
    nNotDig = nNotDig or 0

    for i = 1, nDigHoleCount do
        if i > nNotDig then
            table.insert(WBattleGlobal:getCurrent().m_tExplodeInfoCurRound, {id=self:getOwnerChara():getBattleId(), skillId=WBattleGlobal:getCurrent().m_nSkillBeUseCurRound or -1, x=digHoleX, y=digHoleY,width=self:getOwnerChara():getRectForBulletExplodeBomb().x,height=self:getOwnerChara():getRectForBulletExplodeBomb().y, explodeDirection = digHoleDir})
            if self:getOwnerChara():getCanDigHole() and (self:getOwnerChara():getRectForBulletExplodeBomb().x > 0 or self:getOwnerChara():getRectForBulletExplodeBomb().y > 0) then
                if WBattleGlobal:getCurrent():isFog() then
                    WBattleGlobal:getCurrent():cleanMyBulletFog({x = digHoleX, y = digHoleY}, self:getOwnerChara(), 3, 0, 0, self:getOwnerChara():getRectForBulletExplodeBomb().x, self:getOwnerChara():getRectForBulletExplodeBomb().y)
                end
                WZLog("WBullet:DigHoleByCount", digHoleX, digHoleY, nDigHoleCount)
                if BattleMapManager:drawBroke(Vector2:create(digHoleX, digHoleY), self:getBreakCircle(),self:getBreakCircleMark(),self:getOwnerChara():getRectForBulletExplodeBomb().x,self:getOwnerChara():getRectForBulletExplodeBomb().y, nil, digHoleDir) == false then
                    WZLog("terrain broke failed", digHoleX, digHoleY)
                    return
                end
            end
        end
        if digHoleX < 0 or digHoleY < 0 or digHoleX > size.width or digHoleY > size.height then 
            break 
        end

        digHoleX = digHoleX + tSpeed.x*BattleConstants.g_fWB_CONTINUE_DIGHOLE_DIS
        digHoleY = digHoleY + tSpeed.y*BattleConstants.g_fWB_CONTINUE_DIGHOLE_DIS
    end
end

--@brief 插入已计算影响队列
function WBullet:addInfluenceList(battleId)
    table.insert(self.m_tAllInfluenceBlackHoleList, battleId)
end

--@brief    检测是否已经添加过，防止重复影响计算引力
function WBullet:checkCanInfluence(battleId)
    WZLog("WBullet:checkCanReflect-1",#self.m_tAllInfluenceBlackHoleList)
    if #self.m_tAllInfluenceBlackHoleList == 0 then
        return true
    end

    if not utilsValueInTable(battleId, self.m_tAllInfluenceBlackHoleList) then 
        return true 
    end
    
    return false
end

--@brief    获取子弹是否溅射子弹
function WBullet:getIsSpatter()
    return self.m_bIsSpatter
end

--@brief    获取子弹是否忽略黑洞弹
function WBullet:getIsIgnoreBlackHole()
    return self.m_bIsIgnoreBlackHole
end
-------------------------------------私有方法模块--------------------------------------
