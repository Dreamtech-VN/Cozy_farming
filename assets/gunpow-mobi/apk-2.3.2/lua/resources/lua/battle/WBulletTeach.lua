--WBulletTeach.lua
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
WBulletTeach = {
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
	m_tExplodeElement = nil,			--爆炸动画

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
    m_bIsSpatter = nil, --是否是溅射出来的子弹

    m_bIsAllCollision = nil, --默认不碰撞自己
}

-- BulletEffectId = {
-- 	EFFECT_DEFAULT		= 0,   --默认
-- 	EFFECT_NBOMB		= 1,   --核弹
-- 	EFFECT_ADDTIMES		= 2,   --连发
-- 	EFFECT_DIVIDE	 	= 3,    --散弹
-- 	EFFECT_FROZEN 		= 4,   --冰冻
-- 	EFFECT_POUND		= 5,    --冲击
--     EFFECT_BIGSKILL		= 6,    --大招
--     EFFECT_BIGSKILL_2	= 7,    --大招
--     EFFECT_POWER		= 8,    --威力
--     EFFECT_FLY          = 9,  --人物飞行拖尾
--     EFFECT_POISON       = 10,   --中毒
--     EFFECT_SILENT       = 11,   --沉默
--     EFFECT_BIND         = 12,   --束缚
--     EFFECT_BIGSKILL_3	= 13,   --大招
--     EFFECT_BIGSKILL_4	= 14,   --大招

--     EFFECT_DEFAULT_THROW	= 15,   --默认
--     EFFECT_NBOMB_THROW		= 16,   --核弹(未有资源)
--     EFFECT_DIVIDE_THROW	 	= 17,   --散弹(拖尾)
--     EFFECT_TORNADO          = 18,   --龙卷
--     EFFECT_SPATTER          = 19,   --溅射
--     EFFECT_MIST             = 20,   --烟雾（爆破）

--     BOSS2_MOVE = 1001,      --组队boss2 跳跃拖尾
--     BOSS2_WHEEL_MOVE = 1002,--组队boss2 飞轮拖尾
--     BOSS3_ATTACK = 1003,    --组队boss3 子弹
--     WORLD_BOSS1_ICE = 2003, --世界boss1 冰块拖尾
--     BOSS4_WIND = 4001, 		--组队boss4 狂风暴雪
--     BOSS4_WIND1 = 4002, 	--组队boss4 狂风暴雪
--     BOSS4_WIND2 = 4003, 		--组队boss4 狂风暴雪
--     BOSS4_WIND3 = 4004, 	--组队boss4 狂风暴雪
-- }
-------------------------------------公有方法模块--------------------------------------
local __bid = 0
--@brief	生成一个子弹
--@param	tPos:位置
--@param	tSpeed:速度
--@param	tAcceleration:加速度
--@param	tChara:子弹所属人物
function WBulletTeach:buildBullet(tPos, tSpeed, tAcceleration, tChara, isPenetrateMap, isSpatter)
	local bullet = {}
	setmetatable(bullet, {__index = self})

    bullet.m_bIsSpatter = isSpatter
	bullet.m_tStartPos = tPos
	bullet.m_tStartSpeed = tSpeed
	bullet.m_tAcceleration = tAcceleration
	bullet.m_ownerChara = tChara
	bullet.m_nType = bullet.m_ownerChara:getWeaponType()
	bullet.m_nCurStatus = BulletStatus.DEF_ST_FLY
    bullet.m_bIsPenetrateMap = isPenetrateMap 
	bullet.m_tCollisionCharacters = {}
    bullet.m_tCollisionMachines = {}
	bullet.m_nCheckCharacter = 0

	local strWeapon = bullet.m_ownerChara:getWeaponName()

    local isBigSkill , bigSkillNumber = bullet.m_ownerChara:getUseBigSkill() 
    if false and isBigSkill then
        if bullet.m_ownerChara:getBigSkillType() == 1 then
            if bigSkillNumber <= 2 then
                bullet.m_anim = BattleAnimation:createAnimation("bullet_bigskill_1",true)
            else
                bullet.m_anim = BattleAnimation:createAnimation("bullet_bigskill_2",true)
            end
        elseif bullet.m_ownerChara:getBigSkillType() == 0 then
            bullet.m_anim = BattleAnimation:createAnimation("skill_power2_zidan",true)
        elseif bullet.m_ownerChara:getBigSkillType() == 2 then
            bullet.m_anim = BattleAnimation:createAnimation("skill_power2red_zidan",true)
            WZLog("WBulletTeach:buildBullet 222")
        end
    else
        --strWeapon = "002"
        bullet.m_anim = BattleAnimation:createAnimation("bullet_"..strWeapon,true)

        WZLog("WBulletTeach:buildBullet 111", "bullet_"..strWeapon)
    end
    bullet.m_anim:getAnimNode():retain()
    bullet.m_anim:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0.5))

	bullet.m_anim:setPosition(tPos)
	--初始角度
	local angle = BattleCommon:pointToAngle(tSpeed)
	bullet.m_anim:setRotate(-1*BattleCommon:radiansToDegress(angle))
	WZLog("WBulletTeach:buildBullet", strWeapon, bullet.m_tStartSpeed.x, bullet.m_tStartSpeed.y)

    WZLog("WBulletTeach:buildBullet one", tostring(isBigSkill), tostring(bigSkillNumber))
    if isBigSkill == true then
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
	elseif tChara:getCanFrozen() then
		bullet.m_tExplodeElement = WBulletExplodeElement:create(bullet,BulletEffectId.EFFECT_FROZEN)
		bullet.m_backFire = WBulletBackFire:create(tPos,BulletEffectId.EFFECT_FROZEN)
	elseif tChara:getAttTimes() > 1 then
		bullet.m_tExplodeElement = WBulletExplodeElement:create(bullet, BulletEffectId.EFFECT_ADDTIMES )
		bullet.m_backFire = WBulletBackFire:create( tPos , BulletEffectId.EFFECT_ADDTIMES )
	elseif tChara:getAttScatterNum() > 1 then
        local type = BulletEffectId.EFFECT_DIVIDE
        if bullet.m_nType == BulletType.THROW then
            type = BulletEffectId.EFFECT_DIVIDE_THROW
        end
		bullet.m_tExplodeElement = WBulletExplodeElement:create(bullet, BulletEffectId.EFFECT_DIVIDE )
		bullet.m_backFire = WBulletBackFire:create( tPos , type )
    elseif tChara.m_bIsPowerBomb == true then
        bullet.m_tExplodeElement = WBulletExplodeElement:create(bullet, BulletEffectId.EFFECT_POWER )
        bullet.m_backFire = WBulletBackFire:create(tPos)
    elseif tChara.m_bIsRepulse ~= nil then
        bullet.m_tExplodeElement = WBulletExplodeElement:create(bullet, BulletEffectId.EFFECT_POUND )
        bullet.m_backFire = WBulletBackFire:create(tPos)
    elseif tChara.m_bIsPoisonBomb == true then
        bullet.m_tExplodeElement = WBulletExplodeElement:create(bullet, BulletEffectId.EFFECT_POISON )
        bullet.m_backFire = WBulletBackFire:create(tPos, BulletEffectId.EFFECT_POISON)
    elseif tChara.m_bIsSilentBomb == true then
        bullet.m_tExplodeElement = WBulletExplodeElement:create(bullet, BulletEffectId.EFFECT_SILENT )
        bullet.m_backFire = WBulletBackFire:create(tPos, BulletEffectId.EFFECT_SILENT)
    elseif tChara.m_bIsBindBomb == true then
        bullet.m_tExplodeElement = WBulletExplodeElement:create(bullet, BulletEffectId.EFFECT_BIND )
        bullet.m_backFire = WBulletBackFire:create(tPos, BulletEffectId.EFFECT_BIND)
    elseif tChara.m_bIsTornadoBomb == true then
        bullet.m_tExplodeElement = WBulletExplodeElement:create(bullet, BulletEffectId.EFFECT_TORNADO )
        bullet.m_backFire = WBulletBackFire:create(tPos, BulletEffectId.EFFECT_TORNADO)
    elseif tChara.m_bIsSpatterBomb == true then
        bullet.m_tExplodeElement = WBulletExplodeElement:create(bullet, BulletEffectId.EFFECT_SPATTER )
        bullet.m_backFire = WBulletBackFire:create(tPos, BulletEffectId.EFFECT_SPATTER)
    elseif tChara.m_bIsMistBomb == true then
        bullet.m_tExplodeElement = WBulletExplodeElement:create(bullet, BulletEffectId.EFFECT_MIST )
        bullet.m_backFire = WBulletBackFire:create(tPos, BulletEffectId.EFFECT_FROZEN)
	else
        local type = BulletEffectId.EFFECT_DEFAULT
        if bullet.m_nType == BulletType.THROW then
            type = BulletEffectId.EFFECT_DEFAULT_THROW
        end
		bullet.m_tExplodeElement = WBulletExplodeElement:create(bullet)
		bullet.m_backFire = WBulletBackFire:create(tPos, type)
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

        if true then
            bullet.m_mover = WDMover:create()
            bullet.m_mover:retain()
            bullet.m_mover:setMoverPosition(Vector2:create(bullet.m_tStartPos.x,bullet.m_tStartPos.y))
            bullet.m_mover:setMoverSpeed(Vector2:create(bullet.m_tStartSpeed.x,bullet.m_tStartSpeed.y))
            bullet.m_mover:setMoverAcceleration(Vector2:create(bullet.m_tAcceleration.x,bullet.m_tAcceleration.y))

        else
            bullet.m_mover = WDMoveEntity:create(bullet.m_anim:getAnimNode())
            bullet.m_mover:retain()
            bullet.m_mover:setNormal(true)
            bullet.m_mover:setBreakCircleMark(bullet:getBreakCircleMark())
            bullet.m_mover:setMoverCollisionType(BattleConstants.g_nE_COLLISION_CIRCLE)
            bullet.m_mover:setMoverRadius(bullet.m_anim:getAnimNode():getContentSize().width * 0.25)
            bullet.m_mover:setMoverPosition(Vector2:create(bullet.m_tStartPos.x,bullet.m_tStartPos.y))
            bullet.m_mover:setMoverSpeed(Vector2:create(bullet.m_tStartSpeed.x,bullet.m_tStartSpeed.y))
            bullet.m_mover:setMoverAcceleration(Vector2:create(bullet.m_tAcceleration.x,bullet.m_tAcceleration.y))
            bullet.m_mover:setFly(true)

            --移动管理
            if WBattleGlobal:getCurrent().m_battleManager ~= nil and not bullet.m_bIsPenetrateMap then
                WBattleGlobal:getCurrent().m_battleManager:addEntity(bullet.m_mover)
            end

        end
        WZLog("WBulletTeach_buildBullet_end_3", strWeapon, bullet.m_tStartSpeed.x, bullet.m_tStartSpeed.y, bullet.m_mover:getMoverSpeed().x, bullet.m_mover:getMoverSpeed().y, bullet.m_mover:getMoverAcceleration().x, bullet.m_mover:getMoverAcceleration().y)
        
        if bullet.m_mover.setEnableRotate then
            bullet.m_mover:setEnableRotate(false)
        end
        --local track = TrackNode:create(bullet.m_backFire:getElement())
        --track:setPreAdd(Vector2:create(60,60))
        --track:setTrackFlip(true)
        --bullet.m_mover:addTrackNode(bullet.m_backFire:getTrackNode())

        bullet.m_bIsExist = true

        
    -- end


	bullet.m_tAnimSize = bullet:getAnimation():getAnimNode():getContentSize()
	bullet.m_tAnimSize = {width=bullet.m_tAnimSize.width,height=bullet.m_tAnimSize.height}

	bullet.m_nCollisionRadius = 4
    bullet.m__bid = __bid
    __bid = __bid + 1
	

    local scale = 0.5
    if false and ((bullet.m_ownerChara:getBigSkillType() == 0 or bullet.m_ownerChara:getBigSkillType() == 2 or TeachGroup1.ISBATTLE) and bullet.m_ownerChara:getUseBigSkill()) then
        WZLog("WBulletTeach:buildBullet end")
        bullet.m_anim:setScale(1.0 * scale)

    else
        bullet.m_anim:setScale(0.7 * scale)
    end

    if TeachGroup1.ISBATTLE and bullet.m_ownerChara:getUseBigSkill() then
        WZLog("WBulletTeach:buildBullet end-2")
        bullet.m_anim:setScale(1.2 * scale)
    end

    bullet.m_bIsCollisionMapEvent = false
    bullet.m_bIsProcessMapEvent = false
    bullet.m_bIsProcessMapEventBubble = false

    bullet.m_tIsReflectInitList = nil
    bullet.m_tIsReflectPreList = nil
    bullet.m_tIsReflectList = nil

	return bullet
end

--@brief	创建后面的烟火
--@return	#1:后面的烟火
function WBulletTeach:createBackFire(tPos,nId)
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
function WBulletTeach:addCollisionCharas(tCharas)
	table.insert(self.m_tCollisionCharacters,tCharas)
end

--@brief 添加道具碰撞
function WBulletTeach:addCollisionMachines(tMachines)
    self.m_tCollisionMachines = tMachines
end

--@brief	设置子弹状态
--@param	nStatus:子弹状态
function WBulletTeach:setStatus(nStatus)
	self.m_nCurStatus = nStatus
end

--@brief	获取子弹状态
--@return	#1：子弹状态
function WBulletTeach:getStatus()
	return self.m_nCurStatus
end

--@brief	获取子弹飞行类型
--@return	#1：0:投掷 1:射击
function WBulletTeach:getShootType()
	return self.m_nType
end

--@brief	销毁一个子弹
function WBulletTeach:destroy()
	WZLog("WBulletTeach:destroy 0", tostring(self:getIsExist()))
	if not self:getIsExist() then
		return
	end

    self:setCharMoveUpdatable()
    
    WZLog("WBulletTeach:destroy 2")
    -- if self.m_tExplodeElement then
    --     self.m_tExplodeElement:removeElement()
    -- end
	--移动管理
	if self.m_backFire then
		self.m_backFire:removeElement()
		self.m_backFire = nil
	end
	WZLog("WBulletTeach:destroy 01")

    WZLog("WBulletTeach:destroy 02")
	self.m_mover:release()
	self.m_mover = nil

    WZLog("WBulletTeach:destroy 1")
	if self.m_anim ~= nil then
		if self.m_anim:getAnimNode():getParent() ~= nil then
			self.m_anim:getAnimNode():removeFromParentAndCleanup(true)
		end
		self.m_anim:getAnimNode():release()
		self.m_anim = nil
	end

    for id,heroList in pairs(self.m_tCollisionCharacters) do
        for i,hero in pairs(heroList) do
            --WZLog("WBulletTeach:destroy two",i, tostring(hero.m_bIsImmunity))
            if hero.m_bIsImmunity == true then
                --WZLog("WBulletTeach:destroy three",i)

            end
            hero.m_bIsAbsorb = nil
            hero.m_bIsImmunity = nil
        end
    end
	self.m_tCollisionCharacters = nil
    self.m_tCollisionMachines = nil

     WZLog("WBulletTeach:destroy 3")
    if self.m_tHigherThanMapLabel ~= nil then
    	if self.m_tHigherThanMapLabel:getParent() ~= nil then
       		self.m_tHigherThanMapLabel:removeFromParentAndCleanup(true)
       	end
       	self.m_tHigherThanMapLabel = nil
    end

     WZLog("WBulletTeach:destroy 4")
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


end

--@brief	是否还存在
--@return	#1:true,false
function WBulletTeach:getIsExist()
	return self.m_bIsExist or false
end

--@brief	获取发射子弹的玩家
--@return	#1:发射子弹的玩家
function WBulletTeach:getOwnerChara()
	return self.m_ownerChara
end

--@brief	获取移动控制对象
--@return	#1:WDMove移动控制对象
function WBulletTeach:getMover()
	return self.m_mover
end

--@brief	获取动画控制对象
--@return	#1:BattleAnimation动画控制对象
function WBulletTeach:getAnimation()
	return self.m_anim
end

--@brief	获得动画大小
function WBulletTeach:getAnimSize()
	return self.m_tAnimSize
end

--@brief	获得后面的烟火
--@return	#1:后面的烟火
function WBulletTeach:getBackFire()
	return self.m_backFire:getElement()
end

--@brief	获取爆破半径
--@return	#1:爆破半径
function WBulletTeach:getExplodeRadius()
	return self:getOwnerChara():getRadiusForBulletExplode()
end

--@brief	获取爆破纹理
--@return	#1:BreakCircleMark爆破纹理
function WBulletTeach:getBreakCircle()
	if self:getOwnerChara():getBulletCilcle() and self:getOwnerChara():getBulletCilcle():count() > 0 then
		return tolua.cast(self:getOwnerChara():getBulletCilcle():objectAtIndex(0),"WDMemoryImage")
	else
		return nil
	end
end

--@brief	获取爆破圈
--@return	#1:BreakCircleMark爆破圈
function WBulletTeach:getBreakCircleMark()
	if self:getOwnerChara():getBulletCilcle() and self:getOwnerChara():getBulletCilcle():count() > 1 then
		return tolua.cast(self:getOwnerChara():getBulletCilcle():objectAtIndex(1),"WDMemoryImage")
	else
		return nil
	end
end

--@brief	获取位置
function WBulletTeach:getPosition()
    return self:getAnimation():getPosition()
end

--@brief	更新位置
function WBulletTeach:updatePosition()

    local vec2 = self.m_mover:getMoverPosition()
    local speed = self.m_mover:getMoverSpeed()
    local acceleration = self.m_mover:getMoverAcceleration()
    WZLog("WBulletTeach:updatePosition zero",vec2.x,vec2.y,speed.x,speed.y,acceleration.x,acceleration.y)

    -- self.m_tExplodeElement:explodeIsEnd()
    if self.m_bIsPenetrateMap then
        self:updatePositionII()
        return
    end

    self.m_mover:updatePostion()
    local vec2 = self.m_mover:getMoverPosition()
    self.m_anim:setPosition(vec2)

    local vec2 = self.m_mover:getMoverPosition()
    self:getBackFire():setPosition(vec2.x,vec2.y)
    local hero = WBattleGlobal:getCurrent():getCurrentCharacter()
    --隐身处理
    if hero:isHide() == true then
        local curPos = self.m_mover:getMoverPosition()
        local startPos = self.m_tStartPos
        local distance = BattleCommon:pointDis(curPos, startPos)
        --WZLog("WBulletTeach:updatePosition zero",curPos.x,curPos.y,startPos.x,startPos.y,distance)
        if distance >= 100 then
            local opacity = self:getAnimation():getAnimNode():getOpacity()
            local changeOpacityDistance = nil
            if self.m_changeOpacityPos ~= nil then
                --WZLog("WBulletTeach:updatePosition one", opacity, tostring(self.m_bIsAppear), distance, tostring(self.m_changeOpacityPos.x),tostring(self.m_changeOpacityPos.y))

                changeOpacityDistance = BattleCommon:pointDis(curPos, self.m_changeOpacityPos)
            else
                --WZLog("WBulletTeach:updatePosition two", opacity, tostring(self.m_bIsAppear), distance, tostring(self.m_changeOpacityPos))
            end

            if self.m_bIsAppear == nil then
                --WZLog("WBulletTeach:updatePosition three")
                self.m_bIsAppear = true

                if WBattleGlobal:getCurrent().m_tIsHighEndMachine == true then
                    self:getBackFire():setVisible(true)

                    local startColor = self:getBackFire():getStartColor()
                    local endColor = self:getBackFire():getEndColor()
                    self:getBackFire():setStartColor(ccc4f(startColor.r,startColor.g,startColor.b,0.5))
                    self:getBackFire():setEndColor(ccc4f(endColor.r,endColor.g,endColor.b,1))
                end

                self.m_changeOpacityPos = {}
                self.m_changeOpacityPos.x = curPos.x
                self.m_changeOpacityPos.y = curPos.y
            elseif changeOpacityDistance ~= nil and changeOpacityDistance >= 30 and opacity < 255 then
                self.m_changeOpacityPos.x = curPos.x
                self.m_changeOpacityPos.y = curPos.y
                local opacityChange = opacity + 25
                if opacityChange > 255 then
                    opacityChange = 255
                end
                self:getAnimation():getAnimNode():setOpacity(opacityChange)
            end

        end
    end
    -- if self.m_ownerChara:getType() == 0 then
    -- 	--转起来
    -- 	local speed = self.m_mover:getMoverSpeed()

    --     -- WZLog("WBulletTeach:updatePosition four", self:getShootType(), self.m_nCurStatus, self.m_anim:getRotate())
    -- 	if self:getShootType() == BulletType.THROW and self.m_ownerChara:getUseBigSkill() ~= true then
    --         if self.m_nCurStatus ~= BulletStatus.DEF_ST_EXPLODE then
    --             if speed:getX() > 0 then
    --                 self.m_anim:setRotate(self.m_anim:getRotate() + 14)
    --             else
    --                 self.m_anim:setRotate(self.m_anim:getRotate() - 14)
    --             end
    --         end
    -- 	--根据前一个位置计算角度
    -- 	elseif self:getShootType() == BulletType.THROW_II or self:getShootType() == BulletType.LINE or self.m_ownerChara:getUseBigSkill() then
    --         if --[[self.m_nCurStatus ~= BulletStatus.DEF_ST_EXPLODE and ]] self.m_mover then
    --             local curPos = self.m_mover:getMoverPosition()
    --             local prePos = self.m_mover:getMoverPrePosition()
    --             local angle = BattleCommon:pointToAngle({x=curPos.x-prePos.x,y=curPos.y-prePos.y})
    --             self.m_anim:setRotate(-1*BattleCommon:radiansToDegress(angle))
    --         end
    -- 	end
    -- else
        self:updateRotation()
    -- end

    --显示高度
    self:showHeight()
end

--@brief    更新位置
function WBulletTeach:updatePositionII()
    WZLog("WBulletTeach:updatePositionII")
    self.m_mover:updatePostion()
    local vec2 = self.m_mover:getMoverPosition()
    self.m_anim:setPosition(vec2)
    self:getBackFire():setPosition(vec2.x,vec2.y)
    self:updateRotation()
    
    --显示高度
    self:showHeight()

end
--@brief 更新旋转角度
function WBulletTeach:updateRotation()
   local speed = self.m_mover:getMoverSpeed()
    if self:getShootType() == BulletType.THROW and self.m_ownerChara:getUseBigSkill() ~= true then
        --WZLog("WBossBullet:updatePosition 1",self.m_anim:getRotate(), speed:getX())
        if speed:getX() > 0 then
            self.m_anim:setRotate(self.m_anim:getRotate() + 14)
        else
            self.m_anim:setRotate(self.m_anim:getRotate() - 14)
        end    
    --根据前一个位置计算角度
    elseif self:getShootType() == BulletType.THROW_II or self:getShootType() == BulletType.LINE or self.m_ownerChara:getUseBigSkill() then
        local curPos = self.m_mover:getMoverPosition()
        local prePos = self.m_mover:getMoverPrePosition()
        --WZLog("WBulletTeach:updateRotation",BattleCommon:pointToAngle({x=curPos.x-prePos.x,y=curPos.y-prePos.y}))
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
function WBulletTeach:stop()
	WZLog("WBulletTeach:stop")
	--do return end
    --self.m_anim:getAnimNode():setVisible(false)

    if self:getOwnerChara().m_tActiveAttackSpeed == nil or #self:getOwnerChara().m_tActiveAttackSpeed == 0 then
        local speed = self:getMover():getCollisionSpeed()
        local speed2 = self:getMover():getMoverSpeed()
        if speed.x == 0 and speed.y == 0 then
            speed = {x=speed2.x, y=speed2.y}
        end
        WZLog("WBulletTeach:stop two",speed.x,speed.y,speed2.x,speed2.y)
        self:getOwnerChara().m_tActiveAttackSpeed = {}
        table.insert(self:getOwnerChara().m_tActiveAttackSpeed, {x=speed.x, y=speed.y, isCollision = speed2.x == 0 and speed2.y == 0})

    end

	self.m_mover:setMoverSpeed(Vector2:create(0,0))
	self.m_mover:setMoverAcceleration(Vector2:create(0,0))
end

--@brief	子弹爆炸
function WBulletTeach:markExplode(isMark)
	
	self.m_bIsMark = isMark
	if isMark == true then
		self.m_nCurStatus = BulletStatus.DEF_ST_EXPLODE
	end
end

--@brief	子弹爆炸
function WBulletTeach:explode(isNeedDigHole)
	WZLog("WBulletTeach:explode", tostring(isNeedDigHole), tostring(self.m_bIsMark))

    if self.m_nCurStatus == BulletStatus.DEF_ST_EXPLODE and self.m_bIsMark ~= true then
        return
    end

    if self.m_nType == 0 then
        SoundManager:playEffectSound(SoundDefine.E_S_EXPLODE_1)
    else
        SoundManager:playEffectSound(SoundDefine.E_S_EXPLODE_2)
    end
	self.m_nCurStatus = BulletStatus.DEF_ST_EXPLODE
	if self:getBackFire() ~= nil then
		self:getBackFire():stopSystem()
	end

	self.m_anim:getAnimNode():setVisible(false)

	self.m_tExplodeElement:explode( { x = self:getMover():getMoverPosition().x, y = self:getMover():getMoverPosition().y} )

    if not self.m_bIsPenetrateMap and isNeedDigHole ~= false then
        self:DigHole()
    end
end

--@brief	子弹爆炸结束
function WBulletTeach:_XmlActionFinishCallback()
	WZLog("WBulletTeach:_XmlActionFinishCallback",self)
	self.m_nCurStatus = BulletStatus.DEF_ST_END_EXPLODE
end

--@brief	挖坑
function WBulletTeach:DigHole()
    	WZLog("WBulletTeach:DigHole 0", self:getOwnerChara():getRectForBulletExplodeBomb().x, self:getOwnerChara():getRectForBulletExplodeBomb().y, tostring(self:getBreakCircle()), tostring(self:getBreakCircleMark()), self.m_mover:getMoverPosition().x, self.m_mover:getMoverPosition().y)
	if self:getOwnerChara():getCanDigHole() and (self:getOwnerChara():getRectForBulletExplodeBomb().x > 0 or self:getOwnerChara():getRectForBulletExplodeBomb().y > 0) then
		if BattleMapManager:drawBroke(self.m_mover:getMoverPosition(),self:getBreakCircle(),self:getBreakCircleMark(),self:getOwnerChara():getRectForBulletExplodeBomb().x,self:getOwnerChara():getRectForBulletExplodeBomb().y) == false then
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

--@brief	子弹是否爆炸完毕
--@return	#1:true:是，false：否
function WBulletTeach:explodeIsEnd()
	-- if self.m_nCurStatus == BulletStatus.DEF_ST_END_EXPLODE then
 --        WZLog("WBulletTeach:explodeIsEnd 1")
	-- 	return true
	-- end

	-- if self.m_tExplodeElement:explodeIsEnd() then
 --        WZLog("WBulletTeach:explodeIsEnd 2")
	-- 	return true
	-- end
	if self.m_nCurStatus == BulletStatus.DEF_ST_EXPLODE then
        return true
    end
    
	return false
end

--@brief	检测是否超出屏外
--@return	#1:true:是,false:否
function WBulletTeach:checkOutOfScene()
	local size = self:getAnimSize()
	local pos = self.m_mover:getMoverPosition()
    WZLog("WBulletTeach:checkOutOfScene", tostring(pos.y + size.height < 0), tostring(pos.x + size.width < 0), tostring(pos.x - size.width > SceneBattle:getFrontLayerSize().width), pos.y, size.height, pos.x, size.width, SceneBattle:getFrontLayerSize().width, SceneBattle:getFrontLayerSize().height)
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
function WBulletTeach:checkCollision()
	-- WZLog("WBulletTeach:checkCollision")

    --溅射子弹一开始不与人物检测碰撞
    local isSpatterNocheckCollision = nil
    if self.m_bIsSpatter and BattleCommon:pointDis(self.m_tStartPos, self:getPosition()) < 100 then
        WZLog("WBulletTeach:checkCollision two", self, tostring(self.m_bIsSpatter), BattleCommon:pointDis(self.m_tStartPos, self:getPosition()))
        isSpatterNocheckCollision = true
    end

	--地形碰撞
	--local isCollision,cPos,cVec = BattleMapManager:checkCollision(self.m_mover,true,self:getBreakCircleMark())
    if self.m_tCollisionMachines and #self.m_tCollisionMachines then
        for i,machine in pairs(self.m_tCollisionMachines) do
            local pos = self:getMover():getMoverPosition()
            local radius = self.m_nCollisionRadius
            local collisionRang = machine:getCollisionRang()
            local charaPos = machine:getPosition()
            local charaRaidus = machine:getRadiusForBulletCollision()

            if self:checkCollisionWithRang(pos,radius,charaPos,charaRaidus,collisionRang) then
               WZLog("WBulletTeach:checkCollision three-1", self, tostring(self.m_bIsSpatter))
               self:stop()
               return true
            end
        end
    end

	if self.m_mover:isCollision() then
		--self.m_anim:getAnimNode():setPosition(cPos:getX(),cPos:getY())
		--self.m_mover:setMoverPosition(cPos)
        WZLog("WBulletTeach:checkCollision three-2", self, tostring(self.m_bIsSpatter))
		self:stop()
		return true
	--英雄碰撞
	else
        if isSpatterNocheckCollision == true then
            return false
        end

        -- if self.m_nCheckCharacter == 1 then
        --     self.m_nCheckCharacter = 0
        --     return false
        -- end
        -- self.m_nCheckCharacter = 1
		local isHeroCollision,charaList,isReflect = self:checkCharacterCollision()
        if self.m_tIsReflectList then
            for i,v in pairs (self.m_tIsReflectList) do
                if v then
                    isReflect = v
                    break
                end
            end
        end
        if isReflect then
            self:reflect(isReflect)
            return false, nil
        end

		if isHeroCollision then
			local isPenetrateList = {}
			local penetrateMonsterList = {}
			for i,v in pairs(charaList) do
				if v.m_bPenetrate == true then
					isPenetrateList[i] = true
					table.insert(penetrateMonsterList, v)
				end
			end
			if BattleCommon:tableLen(isPenetrateList) < BattleCommon:tableLen(charaList) then
                WZLog("WBulletTeach:checkCollision three-3", self, tostring(self.m_bIsSpatter))
				self:stop()
			else
				return isHeroCollision, penetrateMonsterList
			end
		end
		return isHeroCollision, nil
	end
end

--@brief	子弹反射
function WBulletTeach:reflect(reflectData)
    local charaPos = reflectData.pos
    local bulletPos = self.m_mover:getMoverPosition()
    local bulletSpeed = self.m_mover:getMoverSpeed()

    local r = BattleCommon:reflectVector(charaPos,bulletPos,bulletSpeed)
    self.m_mover:setMoverSpeed(Vector2:create(r.x,r.y))
end

--@brief	检测人物碰撞
--@return	#1:true:撞了,false:没撞
--@return	#2:碰撞的人物列表
function WBulletTeach:checkCharacterCollision()
	--WZLog("WBulletTeach:checkHeroCollision")
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
    --     WZLog("WBulletTeach:checkHeroCollision List",v.x,v.y)
    -- end
	local tmpCharas = {}
	local isCollision = false
    for k,checkPos in pairs(posList) do
    	for i,charaList in pairs(self.m_tCollisionCharacters) do
         
    		-- local isCollisionInList,collisionCharas = self:checkCollisionWithCharacterList(self:getMover():getMoverPosition(),self.m_nCollisionRadius,charaList)
            local isCollisionInList,collisionCharas,isReflect = self:checkCollisionWithCharacterList(checkPos,self.m_nCollisionRadius,charaList)
            if isReflect then
                --反射
                self.m_bIsAllCollision = true 
                return false,{},isReflect
            end

    		if not isCollision then
    			isCollision = isCollisionInList
    		end

    		AddTableToTable(tmpCharas,collisionCharas)
    	end

        if isCollision then
            -- self.m_mover:setMoverPosition(Vector2:create(checkPos.x,checkPos.y))
            -- WZLog("WBulletTeach:checkCollision collosion",curPos.x)

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
function WBulletTeach:checkCollisionWithCharacterList(pos,raduis,charaList)
	local tmpCharas = {}
	local isCollision = false
    local isReflect = false
	for id,chara in pairs(charaList) do
        WZLog("WBulletTeach:checkCollisionWithCharacterList one", id, tostring(chara:isDead()))
		if not chara:isDead() then
            if self.m_bIsAllCollision or id ~= self:getOwnerChara():getBattleId() then
                local charaPos = chara:getCenterPos()
                local charaRaidus = chara:getRadiusForBulletCollision()
                WZLog("WBulletTeach:checkCollisionWithCharacterList two", id, tostring(chara:isDead()), charaPos.x, charaPos.y, charaRaidus)
    			local collisionRang = chara:getCollisionRang()
                if collisionRang ~= nil then
                    charaPos = chara:getPosition()
                end
                local _isCollision = self:checkCollisionWithRang(pos,raduis,charaPos,charaRaidus,collisionRang)

    			if _isCollision then
    				WZLog("Bullet:checkCollisionWithCharacterList three")
    				tmpCharas[id] = chara
                    isCollision = true
    			end
            end
		end

        if not chara:isDead() then
            local charaPos = chara:getCenterPos()
            isReflect = WBulletTeach.checkCollisionWithReflect(self,pos,raduis,charaPos,chara)
        end
	end
	return isCollision,tmpCharas,isReflect
end

--@brief	检查反射区域碰撞
function WBulletTeach:checkCollisionWithReflect(pos,raduis,charaPos,chara)

    local isReflect = false

    local isInBuffState, effect = chara:isInBuffState(EffectTypeConfig.REFLECT,true)
    WZLog("WBulletTeach:checkCollisionWithReflect one", tostring(isInBuffState))
    if isInBuffState then
        local charaRaidus = effect[5] or 60
        WZLog("WBulletTeach:checkCollisionWithReflect two", pos.x,pos.y,charaPos.x,charaPos.y,raduis,charaRaidus)
        if BattleCommon:checkCircleCollosion(pos,raduis,charaPos,charaRaidus) then
            WZLog("WBulletTeach:checkCollisionWithReflect three-0")
            isReflect = {pos=charaPos}
        end
    end

    if self.m_tIsReflectInitList == nil then
        self.m_tIsReflectInitList = {}
        self.m_tIsReflectPreList = {}
        self.m_tIsReflectList = {}
        WZLog("WBulletTeach:checkCollisionWithReflect three-1")
    end
    local index = chara.m_nBattleId
    local isReflectInit

    WZLog("WBulletTeach:checkCollisionWithReflect three-2", tostring(self.m_tIsReflectInitList[index]), tostring(self.m_tIsReflectPreList[index]), tostring(self.m_tIsReflectList[index]))
    if self.m_tIsReflectInitList[index] == nil or self.m_tIsReflectInitList[index] == true then
        if isReflect then
            self.m_tIsReflectInitList[index] = true
            isReflectInit = false
            WZLog("WBulletTeach:checkCollisionWithReflect four-1", index)
        else
            self.m_tIsReflectInitList[index] = false
            WZLog("WBulletTeach:checkCollisionWithReflect four-2", index)
        end
    end

    if self.m_tIsReflectPreList[index] == true then
        if isReflect then
            self.m_tIsReflectPreList[index] = true
            isReflect = false
            WZLog("WBulletTeach:checkCollisionWithReflect five-1", index)
        else
            self.m_tIsReflectPreList[index] = false
            WZLog("WBulletTeach:checkCollisionWithReflect five-2", index)
        end
    end

    if self.m_tIsReflectPreList[index] == false then
        if isReflect then
            self.m_tIsReflectPreList[index] = true
            WZLog("WBulletTeach:checkCollisionWithReflect five-3", index)
        else
            self.m_tIsReflectPreList[index] = false
            WZLog("WBulletTeach:checkCollisionWithReflect five-4", index)
        end
    end

    if self.m_tIsReflectPreList[index] == nil then
        if isReflect then
            self.m_tIsReflectPreList[index] = true
            WZLog("WBulletTeach:checkCollisionWithReflect five-5", index)
        else
            self.m_tIsReflectPreList[index] = false
            WZLog("WBulletTeach:checkCollisionWithReflect five-6", index)
        end
    end

    if isReflectInit == false then
        isReflect = false
    end
    self.m_tIsReflectList[index] = isReflect
    WZLog("WBulletTeach:checkCollisionWithReflect six", index, tostring(isReflect))
    return isReflect
end

--@brief	检查区域碰撞
--@param	rang:区域
--@return	#1:true:撞了,false:没撞
function WBulletTeach:checkCollisionWithRang(pos,raduis,charaPos,charaRaidus,collisionRang)
    local dis = nil
	if collisionRang ~= nil then
		for i,rang in pairs(collisionRang) do
			if rang.m_nType == 0 then
				local tmpCharaPos = Vector2:create(charaPos.x + rang.m_fXOffset,charaPos.y + rang.m_fYOffset)
				if BattleCommon:checkCircleCollosion(pos,raduis,tmpCharaPos,rang.m_fRadius) then
					return true, dis
				end
			elseif rang.m_nType == 1 then
                
				local rect = {x = charaPos.x+rang.m_fXOffset - rang.m_fWidth*0.5,y = charaPos.y+rang.m_fYOffset,w = rang.m_fWidth,h=rang.m_fHeight}
				local circle = {x = pos.x,y=pos.y,r = raduis}
                local curdis = self:distanceWithCircleAndRect(circle,rect)
                dis = 9999
                dis = math.min(curdis, dis)
                WZLog("WBulletTeach:checkCollisionWithRang", i, curdis, dis,raduis)
				if BattleCommon:rectCircleOverLap(rect,circle) then
					return true, dis
				end
			end
		end
	else
		return BattleCommon:checkCircleCollosion(pos,raduis,charaPos,charaRaidus), dis
	end
	return false, dis
end

--@计算圆与矩形的距离
function WBulletTeach:distanceWithCircleAndRect(circle, rect)
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
        dis = math.min(x1-x,y-y2)
    elseif x<=x1 and y<=y1 then
        dis = math.min(x1-x,y1-y)
    elseif x>=x2 and y>=y2 then
        dis = math.min(x-x2,y-y2)
    elseif x>=x2 and y<=y1 then
        dis = math.min(x-x2,y1-y)
    end
    WZLog("WBulletTeach:distanceWithCircleAndRect",dis,x,y,x1,x2,y1,y2)
    return dis
end

--@brief	检查伤害
--@return	#1:受伤的人物列表
--@return	#2:受伤值
function WBulletTeach:checkHurt(isNotcalculate)
    WZLog("WBulletTeach:checkHurt zero", tostring(self.m_tCheckHurtWithSkillPos))
	local tHurtCharas = {}
	local tHurtValues = {}
    local tDistance = {}
    local tCritType = {}
    local tHurtRatio = {}
    if self.m_tCheckHurtWithSkillPos == nil then
        self.m_tCheckHurtWithSkillPos = {x=self:getMover():getMoverPosition().x,y=self:getMover():getMoverPosition().y}

        self.m_tCheckHurtWithSkillCharaPos = {}
        for i,charaList in pairs(self.m_tCollisionCharacters) do
            for id,chara in pairs(charaList) do
                if not chara:isDead() then
                    self.m_tCheckHurtWithSkillCharaPos[id] = {x=chara:getCenterPos().x,y=chara:getCenterPos().y}
                end
            end
        end
        WZLog("WBulletTeach:checkHurt one", tostring(self.m_tCheckHurtWithSkillPos.x), tostring(self.m_tCheckHurtWithSkillPos.y))
    end

	for i,charaList in pairs(self.m_tCollisionCharacters) do
		for id,chara in pairs(charaList) do
			if not chara:isDead() then

                if chara:getMover() ~= nil and chara:getMover().setUpdatable ~= nil  and chara.m_bIsAir == nil then
                    chara:setMoveUpdatable(true)
                    WZLog("chara:setMoveUpdatable 1")
                end

				local pos = self.m_tCheckHurtWithSkillPos or self:getMover():getMoverPosition()
				local raduis = self:getExplodeRadius()
				local charaPos = self.m_tCheckHurtWithSkillCharaPos and self.m_tCheckHurtWithSkillCharaPos[id] or chara:getCenterPos()
                
                local collisionRang = chara:getCollisionRang()
                if collisionRang ~= nil then
                    charaPos = chara:getPosition()
                end

				charaPos = Vector2:create(charaPos.x,charaPos.y)
				local charaRaidus = chara:getRadiusForHurt()
				local collisionRang = chara:getCollisionRang()

                local isColl, dis = self:checkCollisionWithRang(pos,raduis,charaPos,charaRaidus,collisionRang)
				if isColl then
                    self.m_bIsHurtPlayer = true
					local hurtValue, distance, critType,recordRatio = self:getHurt(chara, false, dis,id,isNotcalculate)
					tHurtCharas[id] = chara
					tHurtValues[id] = hurtValue
                    tDistance[id] = distance
                    tCritType[id] = critType
                    tHurtRatio[id] = recordRatio
                else
                    local hurtValue, distance, critType,recordRatio = self:getHurt(chara,true,nil,id,isNotcalculate)
                    tHurtCharas[id] = chara
                    tHurtValues[id] = -1
                    tDistance[id] = distance
                    tCritType[id] = critType
                    tHurtRatio[id] = recordRatio
				end
                WZLog("WBulletTeach:checkHurt two-1", id, tostring(pos.x), tostring(pos.y), tostring(charaPos.x), tostring(charaPos.y), tostring(self.m_tCheckHurtWithSkillCharaPos and self.m_tCheckHurtWithSkillCharaPos[id] and self.m_tCheckHurtWithSkillCharaPos[id].x), tostring(self.m_tCheckHurtWithSkillCharaPos and self.m_tCheckHurtWithSkillCharaPos[id] and self.m_tCheckHurtWithSkillCharaPos[id].y), tostring(raduis), tostring(charaRaidus), tostring(collisionRang), self:checkCollisionWithRang(pos,raduis,charaPos,charaRaidus,collisionRang))
                WZLog("WBulletTeach:checkHurt two-2", id, tostring(tHurtValues[id]), tostring(tDistance[id]), tostring(tCritType[id]),tostring(tHurtRatio[id]))
			end
		end
	end

    local turnTimes = WBattleGlobal:getCurrent().m_nTurnTimes

    self:getOwnerChara().m_bActiveAttack = true
    if self:getMover():getMoverPosition() then
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
        WZLog("WBulletTeach:checkHurt three-0",j ,u:getBattleId(),u.m_sPlayerName)
    end

    WZLog("WBulletTeach:checkHurt three-1", Serialize(tHurtValues), Serialize(tDistance),Serialize(tHurtRatio))
	return tHurtCharas, tHurtValues, tDistance, tCritType, tHurtRatio
end

--@brief	计算伤害
--@param	chara:英雄
--@return	#1：伤害,#2：距离
function WBulletTeach:getHurt(chara,isNoHurt, dis,id,isNotcalculate)
	local bulletPos = self.m_tCheckHurtWithSkillPos or self:getMover():getMoverPosition()
	local charaPos = self.m_tCheckHurtWithSkillCharaPos and id and self.m_tCheckHurtWithSkillCharaPos[id] or chara:getAnimationCenterPos()
	local distance = BattleCommon:pointDis(bulletPos,charaPos)
	distance = distance - chara:getRadiusForHurt()
	distance = (distance > 0 and distance) or 0
    distance = math.floor(distance)
    local distanceCheck = math.floor(dis or distance)
	local hurt, critType,recordRatio = -1, 0,0
    if isNoHurt == nil or isNoHurt == false then
        hurt, critType, distanceCheck,recordRatio = self:calculateHurt(distanceCheck,self:getOwnerChara(),chara,nil,isNotcalculate)
    end
    WZLog("WBulletTeach:getHurt ", hurt, distance, distanceCheck, tostring(dis), tostring(isNoHurt))
	return hurt, distanceCheck, critType, recordRatio
end

--@brief	根据距离、射击玩家、被射玩家计算出基础伤害值
--@param4   宠物攻击系数
--@return	#1：伤害
function WBulletTeach:calculateHurt(distance,shootHero,targetHero,petCoef,isNotcalculate)
    if targetHero:getIsInvincible() or targetHero.m_bPlayerShief == true then
        WZLog("WBulletTeach:calculateHurt zero1-1")
        return 1, targetHero:getHurtType(), distance
    end

    if targetHero:getBeHurtChangeValue() then
        WZLog("WBulletTeach:calculateHurt zero1-2")
        return math.floor(targetHero:getBeHurtChangeValue()), targetHero:getHurtType(), distance
    end
    if not petCoef then
        if shootHero:getHurtChangeValue() then
            WZLog("WBulletTeach:calculateHurt zero1-3")
            return math.floor(shootHero:getHurtChangeValue()), targetHero:getHurtType(), distance
        end
    end

    local hurt = 0
    local attack = nil
    if petCoef then
        attack = shootHero:getAttack(false)
    else
        attack = shootHero:getAttack()
    end
    --破防
    local wreckDefense = shootHero:getWreckDefense()
    --暴击倍率
    local critRate = shootHero:getCriticalhitAttackRate() + shootHero.m_nAddCriticalHitProbability
    local critRateBeAtk = targetHero:getCriticalhitAttackRate() + targetHero.m_nAddCriticalHitProbability
    --对方防御
    local defend = targetHero:getDefence()
    --力量
    local power = shootHero.m_nPower
    --护甲
    local armor = targetHero.m_nArmor
    --体质
    local constitution = shootHero.m_nConstitution
    local constitutionBeAtk = targetHero.m_nConstitution
    --敏捷
    local agility = shootHero.m_nAgility
    --幸运
    local lucky = targetHero.m_nLucky
    --免伤
    local injuryFree = targetHero:getInjuryFree()
    --等级
    local level = shootHero.m_nRealLevel
    local levelBeAtk = targetHero.m_nRealLevel

    --减伤
    local reduceAcctak = 0

    local s1, s2, s3, s4, s5, s0 = 0, 0, 0, 0, 0, 0

    s0 = attack * (0.75 + 0.5 * (power + 500) / (power + armor + 1000)) * (0.85 + 0.3 * (constitution + 500) / (constitution + constitutionBeAtk + 1000))

    s2 = defend * (1 - wreckDefense / (wreckDefense + 2500)) / (1.5 * defend * (1 - wreckDefense / (wreckDefense + 2500)) + 5000)
    s3 = 1 + (level - levelBeAtk) /  300
    s4 = 1 - 0.3 * injuryFree / (injuryFree + 2500)

    s5 = (1 - s2) * s3 * s4

    local attackRate = WBattleGlobal:getCurrent().m_tAttackRate
    if shootHero.isNormalAct and not shootHero:isNormalAct() then
        attackRate = 100
    end
    
    reduceAcctak = s0 * s5 * (attackRate / 100)
    local distancePercent = 1
    --WZLog("WBulletTeach:calculateHurt ZERO-2",hurt, distance, shootHero:getRadiusForBulletExplode()*0.3, shootHero:getRadiusForBulletExplode()*0.6)
    if distance >= shootHero:getRadiusForBulletExplode()*0.6 then
        reduceAcctak = reduceAcctak*0.3
        distancePercent = 0.3
        --WZLog("WBulletTeach:calculateHurt ZERO1-two")
    elseif distance >= shootHero:getRadiusForBulletExplode()*0.3 then
        reduceAcctak = reduceAcctak*0.7
        distancePercent = 0.7
        --WZLog("WBulletTeach:calculateHurt ZERO1-three")
    end

    --WZLog("WBulletTeach:calculateHurt ZERO-0", s0, s1, s2, s3, s4, s5)
    --WZLog("WBulletTeach:calculateHurt four","体质="..constitution,"敌体质="..constitutionBeAtk,"敏捷="..agility,"幸运="..lucky, "暴击="..critRate, "敌暴击="..critRateBeAtk, "力量="..power, "护甲="..armor, "level="..level, "levelBeAtk="..levelBeAtk,s0,s1,s2,s3,s4,s5,reduceAcctak)

    --WZLog("WBulletTeach:calculateHurt ZERO-3",hurt, tostring(shootHero:getHurtAddPercent(targetHero)), tostring(targetHero:getBeHurtAddPercent(shootHero)))
    local hurtRatio = shootHero:getHurtAddPercent(targetHero) or 0
    --世界Boss鼓舞
    if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS and WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_WORLDBOSS and shootHero:getId() == WBattleGlobal:getCurrent():getMyHero():getId() then
        hurtRatio = hurtRatio + (GlobalGame.g_nWorldBossInspire/10000)
    end
    local hurtRatio3 = 1
    if not petCoef then
        reduceAcctak = reduceAcctak * (1 + hurtRatio)
        --192版本-命运暴击伤害比率
        if shootHero:isFateCrit() then 
            local fateCrit = shootHero:getFateCrit(true)
            hurtRatio3 = fateCrit/10000
            reduceAcctak = reduceAcctak * hurtRatio3
        end
    end
    --WZLog("WBulletTeach:calculateHurt four ", GlobalGame.g_nWorldBossInspire,tostring(WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_WORLDBOSS))

    reduceAcctak = reduceAcctak + reduceAcctak * (targetHero:getBeHurtAddPercent(shootHero) or 0)

    local hurtType, critRateA, randNumber = self:getHurtType(shootHero,targetHero)
    --暴击
    if not petCoef and TeachGroup1.ISBATTLE == nil then
        targetHero:setHurtType(hurtType)
        if targetHero:getIsCriticalHit() then
            -- if WBattleGlobal:getCurrent():isSingleStage() then
            --     local myHero = WBattleGlobal:getCurrent():getMyHero()
            --     local guaiList = WBattleGlobal:getCurrent():getGuaiList()
            --     local turnTimes = WBattleGlobal:getCurrent().m_nTurnTimes
            --     local record = WBattleGlobal:getCurrent().m_tBattleRecord[turnTimes]

            --     if myHero:getId() == shootHero:getId() then
            --         record.isCritical = 1
            --     end
            -- end

            hurt = (1.2 + critRate / (critRate + critRateBeAtk + 1) * 0.3) * (reduceAcctak)

        else
        --非暴击
            hurt =  (reduceAcctak);
        end
    else
        hurt =  (reduceAcctak);
    end
    --校验
    local recordRatio = 1
    if not petCoef then
        hurt = hurt + (shootHero:getHurtAddValue() or 0)
        --校验
        recordRatio = 1 + hurtRatio
        if not petCoef then
            recordRatio = recordRatio * hurtRatio3
        end
        -- WZLog("WBulletTeach recordRatio",recordRatio)
        if targetHero:getIsCriticalHit() then
            recordRatio = recordRatio * (1.2 + critRate / (critRate + critRateBeAtk + 1) * 0.3)
        end
        -- WZLog("WBulletTeach recordRatio",recordRatio)
        recordRatio = recordRatio * distancePercent * (1 + (targetHero:getBeHurtAddPercent(shootHero) or 0))

        local tmp,reverseAdd = targetHero:getHurtReverse(hurt)
        recordRatio = recordRatio * (1 + reverseAdd)
        -- WBattleGlobal:getCurrent():setHitParamRecord(recordRatio*100,shootHero:getHurtAddValue())
        -- if shootHero then
        --     shootHero.m_nRecordRatio = recordRatio * distancePercent
            -- shootHero.m_nRecordDistance = distancePercent
        -- end
        -- WZLog("WBulletTeach recordRatio",recordRatio)
    end
    --WZLog("WBulletTeach:calculateHurt ZERO-4",hurt, targetHero:getBeHurtAddPercent(shootHero) or 0, shootHero:getHurtAddValue() or 0)


    hurt = hurt + (targetHero:getBeHurtAddValue() or 0)
    if petCoef then
        hurt = hurt * petCoef
    end
    --WZLog("WBulletTeach:calculateHurt ZERO-5",hurt, targetHero:getBeHurtAddValue() or 0)


    --WZLog("WBulletTeach:calculateHurt id = "..shootHero:getId().."attack = "..attack.."力量 = "..shootHero.m_nPower.."护甲 = "..targetHero.m_nArmor.."defend = "..defend.."破防 = "..wreckDefense.."免伤 = "..targetHero:getInjuryFree().."level = "..targetHero.m_nLevel.."hurt = "..hurt.."浮动值"..attackRate )

    --WZLog("WBulletTeach:calculateHurt two", tostring(self:getHurtType(shootHero,targetHero)), tostring(shootHero:getAttPercent()), tostring(distance), tostring(shootHero:getRadiusForBulletExplode()))

    --WZLog("WBulletTeach:calculateHurt three", tostring(shootHero.m_nHurtAddPercent), tostring(shootHero.m_nHurtAddValue), tostring(shootHero.m_nHurtChangeValue), tostring(targetHero:isHide()), tostring(shootHero.m_nAddAttackValue), tostring(targetHero.m_nBuffInvincibleRound),self.m_nLavaAttackHurtUp,tostring(self.m_bIsProcessMapEvent), tostring(self))

    if isNotcalculate == nil then
        WZLog("WBulletTeach:calculateHurt end \nhurt",hurt ,"\nhurtRatio", shootHero:getHurtAddPercent(targetHero) and shootHero:getHurtAddPercent(targetHero) + 1 or 1,
            "\nbHurtRatio", targetHero:getBeHurtAddPercent(shootHero) and targetHero:getBeHurtAddPercent(shootHero) + 1 or 1,
            "\n攻击方暴击", critRate,"\n攻击方速度", agility,"\n被攻击方幸运", targetHero.m_nLucky,
            "\n被攻击方免爆", targetHero:getReduceCrit(),"\ncritRate",critRateA,"\nrandNumber",randNumber,"\n被攻击方暴击", critRateBeAtk,
            "\n暴击伤害比率", (1.2 + critRate / (critRate + critRateBeAtk + 1) * 0.3),
            "\n攻击方爆破范围", shootHero:getRadiusForBulletExplode(),"\n爆炸距离", distance,
            "\n攻击方攻击", attack,"\n攻击方力量", power,"\n攻击方体质", constitution,
            "\n攻击方速度", agility,"\n攻击方破防", wreckDefense,"\n攻击方等级", level,
            "\n被攻击方护甲", armor,"\n被攻击方体质", constitutionBeAtk,"\n被攻击方幸运", lucky,
            "\n被攻击方防御", defend,"\n被攻击方等级", levelBeAtk,"\n被攻击方免伤", injuryFree,
            "\n被攻击方暴击", critRateBeAtk,"\n伤害浮动", attackRate,"\n爆炸范围百分比伤害", distancePercent,
            "\nhurtAppend", shootHero:getHurtAddValue() or 0,"\nbhurtAppend", targetHero:getBeHurtAddValue() or 0,
            "\n宠物资质比率", petCoef or 0)
    end

    --反转伤害
    hurt = targetHero:getHurtReverse(hurt)
    return math.ceil(hurt), targetHero:getHurtType(), distance,recordRatio
end

--@brief	获取受伤类型
--@param	shootHero:射击的英雄
--@param	targetHero:目标英雄
--@return	#1:0:普通，1:暴击，2:超暴击
function WBulletTeach:getHurtType(shootHero,targetHero)
    --WZLog("WBulletTeach:getHurtType", WBattleGlobal:getCurrent().m_nIsCriticalHit, tostring( shootHero:getCanSuperHit()), shootHero.m_nSkillfull, targetHero:getReduceCrit())

    local hurtType = 0
    if true then
        --速度
        local agility = shootHero.m_nAgility
        --幸运
        local lucky = targetHero.m_nLucky
        --暴击
        local crit = shootHero.m_nCriticalhitAttackRate + shootHero.m_nAddCriticalHitProbability
        --免爆
        local reduceCrit = targetHero:getReduceCrit()

        local critRate = (0.5 + 0.5 * (crit - reduceCrit + 1) / (crit + reduceCrit + 1)) * 10000

        local randNumber = 10000
        if #WBattleGlobal:getCurrent().m_tBattleRand > 0 then
            randNumber = WBattleGlobal:getCurrent().m_tBattleRand[1] + 1
        end

        if randNumber <= critRate and shootHero:getCanSuperHit() then
            hurtType = 2
        elseif randNumber <= critRate then
            hurtType = 1
        else
            hurtType = 0
        end
        --WZLog("WBulletTeach:getHurtType ONE",crit,reduceCrit)
        --WZLog("WBulletTeach:getHurtType \ncritRate",critRate,"\nrandNumber",randNumber)
        return hurtType, critRate, randNumber
    end


end

--@brief	检测是否超过地图的高度
--@return	#1:超出的高度
function WBulletTeach:checkHigherThanMap()
	--WZLog("WBulletTeach:checkHigherThanMap")
	local size = self:getAnimSize()
	local pos = self.m_mover:getMoverPosition()

	local height =  pos.y - size.height - SceneBattle:getFrontLayerSize().height

    --WZLog("WBulletTeach:checkHigherThanMap height = "..height.." pos.y = "..pos.y.." SceneBattle:getFrontLayer():getContentSize().height = "..SceneBattle:getFrontLayer():getContentSize().height)
    if height < 0 then
        height = 0
    end

	return height / 10.0
end

--@brief	显示子弹高度
function WBulletTeach:showHeight()
	--WZLog("WBulletTeach:showHeight")

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

function WBulletTeach:setCharMoveUpdatable()
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
-------------------------------------私有方法模块--------------------------------------
