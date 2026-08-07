--WBulletOther.lua
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
WBulletOther = {
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

----------------------------公有方法模块--------------------------------------
local __bid = 0
--@brief	生成一个子弹
--@param	tPos:位置
--@param	tSpeed:速度
--@param	tAcceleration:加速度
--@param	tChara:子弹所属人物
function WBulletOther:buildBullet(tPos, tSpeed, tAcceleration, tChara, isPenetrateMap, isSpatter)
	local bullet = {}
	setmetatable(bullet, {__index = self})

    bullet.m_bIsSpatter = isSpatter
	bullet.m_tStartPos = tPos
	bullet.m_tStartSpeed = tSpeed
	bullet.m_tAcceleration = tAcceleration
	bullet.m_ownerChara = tChara
	bullet.m_nType = 0
	bullet.m_nCurStatus = BulletStatus.DEF_ST_FLY
    bullet.m_bIsPenetrateMap = isPenetrateMap 
	bullet.m_tCollisionCharacters = {}
    bullet.m_tCollisionMachines = {}
	bullet.m_nCheckCharacter = 0

    --足球活动踢的球
	local strWeapon = 262 --267 

    bullet.m_anim = BattleAnimation:createAnimation("bullet_"..strWeapon,true)
    bullet.m_anim:getAnimNode():retain()
    bullet.m_anim:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0.5))

	bullet.m_anim:setPosition(tPos)
	--初始角度
	local angle = BattleCommon:pointToAngle(tSpeed)
	bullet.m_anim:setRotate(-1*BattleCommon:radiansToDegress(angle))
	WZLog("WBulletOther:buildBullet", strWeapon, bullet.m_tStartSpeed.x, bullet.m_tStartSpeed.y)

    WZLog("WBulletOther:buildBullet one", tostring(isBigSkill), tostring(bigSkillNumber))
    local type = BulletEffectId.EFFECT_DEFAULT
	-- bullet.m_tExplodeElement = WBulletExplodeElement:create(bullet)
	bullet.m_backFire = WBulletBackFire:create(tPos, type)

    if true then
        bullet.m_mover = WDMover:create()
        bullet.m_mover:retain()
        bullet.m_mover:setMoverPosition(Vector2:create(bullet.m_tStartPos.x,bullet.m_tStartPos.y))
        bullet.m_mover:setMoverSpeed(Vector2:create(bullet.m_tStartSpeed.x,bullet.m_tStartSpeed.y))
        bullet.m_mover:setMoverAcceleration(Vector2:create(bullet.m_tAcceleration.x,bullet.m_tAcceleration.y))
    end
    WZLog("WBulletOther_buildBullet_end_3", strWeapon, bullet.m_tStartSpeed.x, bullet.m_tStartSpeed.y, bullet.m_mover:getMoverSpeed().x, bullet.m_mover:getMoverSpeed().y, bullet.m_mover:getMoverAcceleration().x, bullet.m_mover:getMoverAcceleration().y)
    
    if bullet.m_mover.setEnableRotate then
        bullet.m_mover:setEnableRotate(false)
    end
    bullet.m_bIsExist = true

	bullet.m_tAnimSize = bullet:getAnimation():getAnimNode():getContentSize()
	bullet.m_tAnimSize = {width=bullet.m_tAnimSize.width,height=bullet.m_tAnimSize.height}

	bullet.m_nCollisionRadius = 4
    bullet.m__bid = __bid
    __bid = __bid + 1

    local scale = 1
    bullet.m_anim:setScale(0.7 * scale)

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
function WBulletOther:createBackFire(tPos,nId)
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
function WBulletOther:addCollisionCharas(tCharas)
	table.insert(self.m_tCollisionCharacters,tCharas)
end

--@brief	设置子弹状态
--@param	nStatus:子弹状态
function WBulletOther:setStatus(nStatus)
	self.m_nCurStatus = nStatus
end

--@brief	获取子弹状态
--@return	#1：子弹状态
function WBulletOther:getStatus()
	return self.m_nCurStatus
end

--@brief	获取子弹飞行类型
--@return	#1：0:投掷 1:射击
function WBulletOther:getShootType()
	return self.m_nType
end

--@brief	销毁一个子弹
function WBulletOther:destroy()
	WZLog("WBulletOther:destroy 0", tostring(self:getIsExist()))
	if not self:getIsExist() then
		return
	end

    WZLog("WBulletOther:destroy 2")
	--移动管理
	if self.m_backFire then
		self.m_backFire:removeElement()
		self.m_backFire = nil
	end
	WZLog("WBulletOther:destroy 01")
	self.m_mover:release()
	self.m_mover = nil

    WZLog("WBulletOther:destroy 1")
	if self.m_anim ~= nil then
		if self.m_anim:getAnimNode():getParent() ~= nil then
			self.m_anim:getAnimNode():removeFromParentAndCleanup(true)
		end
		self.m_anim:getAnimNode():release()
		self.m_anim = nil
	end

    for id,heroList in pairs(self.m_tCollisionCharacters) do
        for i,hero in pairs(heroList) do
            --WZLog("WBulletOther:destroy two",i, tostring(hero.m_bIsImmunity))
            if hero.m_bIsImmunity == true then
                --WZLog("WBulletOther:destroy three",i)

            end
            hero.m_bIsAbsorb = nil
            hero.m_bIsImmunity = nil
        end
    end
	self.m_tCollisionCharacters = nil
    self.m_tCollisionMachines = nil

     WZLog("WBulletOther:destroy 3")
    if self.m_tHigherThanMapLabel ~= nil then
    	if self.m_tHigherThanMapLabel:getParent() ~= nil then
       		self.m_tHigherThanMapLabel:removeFromParentAndCleanup(true)
       	end
       	self.m_tHigherThanMapLabel = nil
    end

     WZLog("WBulletOther:destroy 4")
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
function WBulletOther:getIsExist()
	return self.m_bIsExist or false
end

--@brief	获取发射子弹的玩家
--@return	#1:发射子弹的玩家
function WBulletOther:getOwnerChara()
	return self.m_ownerChara
end

--@brief	获取移动控制对象
--@return	#1:WDMove移动控制对象
function WBulletOther:getMover()
	return self.m_mover
end

--@brief	获取动画控制对象
--@return	#1:BattleAnimation动画控制对象
function WBulletOther:getAnimation()
	return self.m_anim
end

--@brief	获得动画大小
function WBulletOther:getAnimSize()
	return self.m_tAnimSize
end

--@brief	获得后面的烟火
--@return	#1:后面的烟火
function WBulletOther:getBackFire()
	return self.m_backFire:getElement()
end

--@brief	获取爆破半径
--@return	#1:爆破半径
function WBulletOther:getExplodeRadius()
	return self:getOwnerChara():getRadiusForBulletExplode()
end

--@brief	获取爆破纹理
--@return	#1:BreakCircleMark爆破纹理
function WBulletOther:getBreakCircle()
	if self:getOwnerChara():getBulletCilcle() and self:getOwnerChara():getBulletCilcle():count() > 0 then
		return tolua.cast(self:getOwnerChara():getBulletCilcle():objectAtIndex(0),"WDMemoryImage")
	else
		return nil
	end
end

--@brief	获取爆破圈
--@return	#1:BreakCircleMark爆破圈
function WBulletOther:getBreakCircleMark()
	if self:getOwnerChara():getBulletCilcle() and self:getOwnerChara():getBulletCilcle():count() > 1 then
		return tolua.cast(self:getOwnerChara():getBulletCilcle():objectAtIndex(1),"WDMemoryImage")
	else
		return nil
	end
end

--@brief	获取位置
function WBulletOther:getPosition()
    return self:getAnimation():getPosition()
end

--@brief	更新位置
function WBulletOther:updatePosition()

    local vec2 = self.m_mover:getMoverPosition()
    local speed = self.m_mover:getMoverSpeed()
    local acceleration = self.m_mover:getMoverAcceleration()
    WZLog("WBulletOther:updatePosition zero",vec2.x,vec2.y,speed.x,speed.y,acceleration.x,acceleration.y)

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
    self:updateRotation()

end

--@brief    更新位置
function WBulletOther:updatePositionII()
    WZLog("WBulletOther:updatePositionII")
    self.m_mover:updatePostion()
    local vec2 = self.m_mover:getMoverPosition()
    self.m_anim:setPosition(vec2)
    self:getBackFire():setPosition(vec2.x,vec2.y)
    self:updateRotation()
    

end
--@brief 更新旋转角度
function WBulletOther:updateRotation()
   local speed = self.m_mover:getMoverSpeed()
    if self:getShootType() == BulletType.THROW then
        --WZLog("WBossBullet:updatePosition 1",self.m_anim:getRotate(), speed:getX())
        if speed:getX() > 0 then
            self.m_anim:setRotate(self.m_anim:getRotate() + 14)
        else
            self.m_anim:setRotate(self.m_anim:getRotate() - 14)
        end    
    end
end

--@brief	子弹停止
function WBulletOther:stop()
	WZLog("WBulletOther:stop")
	self.m_mover:setMoverSpeed(Vector2:create(0,0))
	self.m_mover:setMoverAcceleration(Vector2:create(0,0))
end

--@brief	子弹爆炸
function WBulletOther:markExplode(isMark)
	
	self.m_bIsMark = isMark
	if isMark == true then
		self.m_nCurStatus = BulletStatus.DEF_ST_EXPLODE
	end
end

--@brief	子弹爆炸
function WBulletOther:explode(isNeedDigHole)
	WZLog("WBulletOther:explode", tostring(isNeedDigHole), tostring(self.m_bIsMark))

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
function WBulletOther:_XmlActionFinishCallback()
	WZLog("WBulletOther:_XmlActionFinishCallback",self)
	self.m_nCurStatus = BulletStatus.DEF_ST_END_EXPLODE
end

--@brief	挖坑
function WBulletOther:DigHole()

end

--@brief	子弹是否爆炸完毕
--@return	#1:true:是，false：否
function WBulletOther:explodeIsEnd()
	if self.m_nCurStatus == BulletStatus.DEF_ST_EXPLODE then
        return true
    end
    
	return false
end

--@brief	检测是否超出屏外
--@return	#1:true:是,false:否
function WBulletOther:checkOutOfScene()
	local size = self:getAnimSize()
	local pos = self.m_mover:getMoverPosition()
    --WZLog("WBulletOther:checkOutOfScene", tostring(pos.y + size.height < 0), tostring(pos.x + size.width < 0))
	if pos.y + size.height < 0 then
		return true
	end
    if pos.y + size.height > 5000 then
        return true
    end
	if pos.x + size.width < 0 then
		return true
	end
	if pos.x - size.width > 5000 then
		return true
	end
	return false
end

--@brief	检测碰撞
--@param	heros:英雄列表
--@return	#1:true:撞了,false:没撞
--@return	#2:英雄列表
function WBulletOther:checkCollision()

end

--@计算圆与矩形的距离
function WBulletOther:distanceWithCircleAndRect(circle, rect)
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
    WZLog("WBulletOther:distanceWithCircleAndRect",dis,x,y,x1,x2,y1,y2)
    return dis
end
-------------------------------------私有方法模块--------------------------------------
