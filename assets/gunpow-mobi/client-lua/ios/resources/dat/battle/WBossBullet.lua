--WBossBullet.lua
--@brief	Boss子弹数据表
--@date		2013/12/24
--@author	李光森
--@note		Boss子弹的属性与控制

--@brief	运行状态
BossBulletStatus = {
	DEF_ST_FLY = 0, --飞行
	DEF_ST_EXPLODE = 1, --爆炸
	DEF_ST_NONE = -1, --空的状态,用于转换状态时
}

BulletType = {
    THROW = 0,      --抛出（自转）
    THROW_II = 1,   --抛出（带角度调整）
    LINE = 2,   --直线射击
    FLOOR = 3, -- 贴地板    
}

--@brief	子弹数据表
WBossBullet = {
	--子弹飞行数据
	m_tStartPos = nil,					--射击开始位置
	m_tStartSpeed = nil,				--射击速度
	m_tAcceleration = nil,				--子弹加速度
	m_nType = nil,						--子弹类型  0:投砸 1:投砸 2:射击  3:跟随地形

	--对象
	m_mover = nil, 						--移动控制对象
	m_anim = nil, 						--动画控制对象
	m_ownerChara = nil,					--所属对象

	--存在标记
	m_bIsExist = nil,					--是否存在的标记
	
	--状态
	m_nCurStatus = nil,					--当前状态

	--碰撞列表
	m_tCollisionCharacters = nil,		--需要碰撞的人物列表
    m_nCollisionRadius = nil,           --碰撞半径

	--爆炸相关(暂时)
	m_tExplodeElement = nil,			--爆炸动画
    
    --碰撞半径
    m_nCheckCharacterCollisionRadius = 0,   --与人物碰撞时检测的半径
    
    --动画的默认方向
    m_nAnimDefaultDirection = 0,            --子弹的动画的默认方向 0:向右 , 1:向左
    
    --超出地图的高度
    m_tHigherThanMapLabel = nil,        --显示超出地图的高度的label

    --受伤害玩家列表
    m_tHurtHeros = nil,               --受伤害玩家列表
    
    m_bIsNoRotate = false,              --是否不旋转
    m_bIsMark = nil,

    m_nBulletId = nil,                   --子弹表id
    m_tIsReflectPreList = nil, --上一帧是否在反射区域
    m_tIsReflectInitList = nil, --初始是否在反射区域
    m_tIsReflectList = nil, --当前是否在反射区域
    m_bIsCollisionMapEvent = nil,       --是否与地图事件发生碰撞
    m_bIsProcessMapEvent = nil,         --是否处理了地图事件
    m_bIsSpatter = nil, --是否是溅射出来的子弹
}

-------------------------------------公有方法模块--------------------------------------

--@brief	生成一个子弹
--@param	bulletAnim:子弹的动画
--@param	tPos:位置
--@param	tSpeed:速度
--@param	tAcceleration:加速度
--@param	tChara:子弹所属人物
--@param	nType:子弹类型 0:投砸  1:射击  2:跟随地形
--@param	fireType:拖尾
--@param    boomType:爆破
function WBossBullet:buildBullet(bulletAnim,tPos, tSpeed, tAcceleration, tChara, nType, fireType,boomType,isPenetrateMap,isSpatter)
    WZLog("WBossBullet:buildBullet", nType,tostring(isPenetrateMap))
	local bullet = {}
	setmetatable(bullet, {__index = self})
    setmetatable(WBossBullet, {__index = WBullet})

    --溅射子弹 开始默认穿透地图
    if isSpatter then
           bullet.m_bIsSpatterPenetrateMap = isPenetrateMap
        isPenetrateMap = true
    end
    
    bullet.m_bIsSpatter = isSpatter
	bullet.m_tStartPos = tPos
	bullet.m_tStartSpeed = tSpeed
	bullet.m_tAcceleration = tAcceleration
	bullet.m_ownerChara = tChara
	bullet.m_nType = nType
	bullet.m_nCurStatus = BossBulletStatus.DEF_ST_FLY
	bullet.m_tCollisionCharacters = {}
    bullet.m_nCheckCharacterCollisionRadius = 2
    bullet.m_bIsPenetrateMap = isPenetrateMap 
    bullet.m_tHurtHeros = {}

	bullet.m_anim = bulletAnim
	bullet.m_anim:setPosition(tPos)

	
	-- if bullet.m_bIsPenetrateMap then
 --        bullet.m_mover = WDMover:create()
 --        bullet.m_mover:retain()
 --        bullet.m_mover:setMoverPosition(Vector2:create(bullet.m_tStartPos.x,bullet.m_tStartPos.y))
 --        bullet.m_mover:setMoverSpeed(Vector2:create(bullet.m_tStartSpeed.x,bullet.m_tStartSpeed.y))
 --        bullet.m_mover:setMoverAcceleration(Vector2:create(bullet.m_tAcceleration.x,bullet.m_tAcceleration.y))
 --        bullet.m_bIsExist = true
 --    else
        bullet.m_mover = WDMoveEntity:create(bullet.m_anim:getAnimNode())
        bullet.m_mover:retain()
        bullet.m_mover:setNormal(true)
        bullet.m_mover:setBreakCircleMark(bullet:getBreakCircleMark())
        bullet.m_mover:setMoverCollisionType(BattleConstants.g_nE_COLLISION_CIRCLE)
        bullet.m_mover:setMoverRadius(1)
        bullet.m_mover:setMoverPosition(Vector2:create(bullet.m_tStartPos.x,bullet.m_tStartPos.y))
        bullet.m_mover:setMoverSpeed(Vector2:create(bullet.m_tStartSpeed.x,bullet.m_tStartSpeed.y))
        bullet.m_mover:setMoverAcceleration(Vector2:create(bullet.m_tAcceleration.x,bullet.m_tAcceleration.y))
        --直线子弹
        if bullet.m_nType == BulletType.LINE then
            local acceleration = BattleCommon:pointAdd(BattleConstants.g_nFlyGravity,WBattleGlobal:getCurrent():getWind())
            bullet.m_mover:setFlyAcceleration(-acceleration.x,-acceleration.y)
        end
        bullet.m_mover:setFly(true)
        bullet.m_mover:setEnableRotate(false)
      
        bullet.m_bIsExist = true

        --移动管理
        if WBattleGlobal:getCurrent().m_battleManager ~= nil and not bullet.m_bIsPenetrateMap then
            WBattleGlobal:getCurrent().m_battleManager:addEntity(bullet.m_mover)
        end
    -- end

    bullet.m_backFire = WBulletBackFire:create(tPos,fireType)
    if WBattleGlobal:getCurrent().m_tIsHighEndMachine == true then
        SceneBattle:getFrontLayer():addChild(bullet:getBackFire():getParent(),0)
    end
    bullet.m_tExplodeElement = WBulletExplodeElement:create(bullet,boomType)

	
    bullet.m_nCollisionRadius = 4
    bullet.m_bIsCollisionMapEvent = false
    bullet.m_bIsProcessMapEvent = false

    bullet.m_tIsReflectInitList = nil
    bullet.m_tIsReflectPreList = nil
    bullet.m_tIsReflectList = nil
    
    bullet.m_tAllReflectList = {}

    bullet.m_bOffTracking = nil --是否免除磁铁追踪检查
    bullet.m_nLiftTime = 0 --存在时间

	return bullet
end

--@brief	添加人物碰撞列表
--@param	tCharas:人物碰撞列表
function WBossBullet:addCollisionCharas(tCharas)
	table.insert(self.m_tCollisionCharacters,tCharas)
end

--@brief	更新位置
function WBossBullet:updatePosition()
    WBullet.updatePosition(self)
end

--@brief    更新位置
function WBossBullet:updatePositionII()
    WBullet.updatePositionII(self)
end
--@brief    更新旋转角度
function WBossBullet:updateRotation()
    WBullet.updateRotation(self)
end

--@brief	设置子弹状态
--@param	nStatus:子弹状态
function WBossBullet:setStatus(nStatus)
	self.m_nCurStatus = nStatus
end

--@brief	获取子弹状态
--@return	#1：子弹状态
function WBossBullet:getStatus()
	return self.m_nCurStatus
end

--@brief	获取子弹飞行类型
--@return	#1：0:投掷 1:投射，1:射击 2:跟随地形
function WBossBullet:getShootType()
	return self.m_nType
end

--@brief	销毁一个子弹
function WBossBullet:destroy()
	if not self:getIsExist() then
		return
	end

    WBullet.setCharMoveUpdatable(self)

    WZLog("WBossBullet:destroy")
    if self.m_backFire then
        self.m_backFire:removeElement()
        self.m_backFire = nil
    end

    if WBattleGlobal:getCurrent().m_battleManager ~= nil and not self.m_bIsPenetrateMap then
        WBattleGlobal:getCurrent().m_battleManager:removeEntity(self.m_mover)
    end
	self.m_mover:release()
	self.m_mover = nil
	
	if self.m_anim ~= nil then
		if self.m_anim:getAnimNode():getParent() ~= nil then
			self.m_anim:getAnimNode():removeFromParentAndCleanup(true)
		end
        --怪物子弹没有retain()
		--self.m_anim:getAnimNode():release()
		self.m_anim = nil
	end

    -- if self.m_tExplodeElement then
    --     self.m_tExplodeElement:removeElement()
    --     self.m_tExplodeElement = nil
    -- end
    --[[
	if self.m_tExplodeElement ~= nil then
		if self.m_tExplodeElement:getParent() ~= nil then
			self.m_tExplodeElement:removeFromParentAndCleanup(true)
		end
		self.m_tExplodeElement:release()
		self.m_tExplodeElement = nil
	end
    --]]
	self.m_tCollisionCharacters = nil
    
    if self.m_tHigherThanMapLabel ~= nil then
    	if self.m_tHigherThanMapLabel:getParent() ~= nil then
       		self.m_tHigherThanMapLabel:removeFromParentAndCleanup(true)
       	end
       	self.m_tHigherThanMapLabel = nil
    end

    self.m_bIsNoRotate = false
    self.m_bIsSpatter = nil
    self.m_bIsExist = nil
end

--@brief	是否还存在
--@return	#1:true,false
function WBossBullet:getIsExist()
	return self.m_bIsExist or false
end

--@brief	获取发射子弹的玩家
--@return	#1:发射子弹的玩家
function WBossBullet:getOwnerChara()
	return self.m_ownerChara
end

--@brief	获取移动控制对象
--@return	#1:WDMove移动控制对象
function WBossBullet:getMover()
	return self.m_mover
end

--@brief	获取动画控制对象
--@return	#1:BattleAnimation动画控制对象
function WBossBullet:getAnimation()
	return self.m_anim
end

--@brief    获得后面的烟火
--@return   #1:后面的烟火
function WBossBullet:getBackFire()
    return self.m_backFire:getElement()
end

--@brief	子弹停止
function WBossBullet:stop()
	WZLog("WBossBullet:stop")
	self.m_mover:setMoverSpeed(Vector2:create(0,0))
	self.m_mover:setMoverAcceleration(Vector2:create(0,0))
end

--@brief	子弹爆炸
function WBossBullet:markExplode(isMark)
	self.m_bIsMark = isMark
end

--@brief	子弹爆炸
function WBossBullet:explode(explodeAnimName)
	WZLog("WBossBullet:explode")
    WBullet.explode(self,true)
 --    SoundManager:playEffectSound(SoundDefine.E_S_EXPLODE)
	-- self.m_nCurStatus = BossBulletStatus.DEF_ST_EXPLODE
	-- if self.m_tExplodeElement ~= nil then
 --        WZLog("WBossBullet:explode 1")
	-- 	self.m_anim:getAnimNode():setVisible(false)

 --        --[[
	-- 	self.m_tExplodeElement:setUseAbsCoordinate(true)
	-- 	self.m_tExplodeElement:setAbsPosition(GlobalMethod:ccp(self:getMover():getMoverPosition().x,self:getMover():getMoverPosition().y))
	-- 	SceneBattle:getFrontLayer():addChild(self.m_tExplodeElement)
 --        --]]
 --        WZLog("WBossBullet:explode",self:getMover():getMoverPosition().x,self:getMover():getMoverPosition().y)
 --        self.m_tExplodeElement:explode( { x = self:getMover():getMoverPosition().x, y = self:getMover():getMoverPosition().y} )
 --        self.m_anim:play("0",false)
	-- else
 --        WZLog("WBossBullet:explode 2")
	-- 	explodeAnimName = explodeAnimName or "blasting"
	-- 	self.m_anim:play(explodeAnimName,false)
	-- end

 --    if not self.m_bIsPenetrateMap then
 --        self:DigHole()
 --    end
end

function WBossBullet:_XmlActionFinishCallback()
	self.m_nCurStatus = BulletStatus.DEF_ST_END_EXPLODE
	if self.m_tExplodeElement ~= nil then
		self.m_tExplodeElement:removeFromParentAndCleanup(true)
	end
end

--@brief	子弹是否爆炸完毕
--@return	#1:true:是，false：否
function WBossBullet:explodeIsEnd(explodeAnimName)
	WZLog("WBossBullet:explodeIsEnd")
    return WBullet.explodeIsEnd(self)
	-- if self.m_nCurStatus == BulletStatus.DEF_ST_END_EXPLODE then
	-- 	return true
	-- end

 --    if self.m_tExplodeElement and self.m_tExplodeElement:explodeIsEnd() then
 --        return true
 --    end

	-- explodeAnimName = explodeAnimName or "blasting"
 --    WZLog("WBossBullet:explodeIsEnd", explodeAnimName, tostring(self.m_anim:isPlaying(explodeAnimName)), tostring(self.m_anim:isCurrentAnimationDone()))
	-- if self.m_anim:isPlaying(explodeAnimName) == true and self.m_anim:isCurrentAnimationDone() == true then
	-- 	self.m_nCurStatus = BulletStatus.DEF_ST_END_EXPLODE
	-- 	return true
	-- else
	-- 	return false
	-- end

end

--@brief	获取爆破半径
--@return	#1:爆破半径
function WBossBullet:getExplodeRadius()
	return self:getOwnerChara():getRadiusForBulletExplode()
end

--@brief	检测是否超出屏外
--@return	#1:true:是,false:否
function WBossBullet:checkOutOfScene()
	WZLog("WBossBullet:checkOutOfScene")
	local size = self.m_anim:getAnimNode():getContentSize()
	local pos = self.m_mover:getMoverPosition()
	if pos.y + size.height < 0 then
		return true
	end
    if pos.y + size.height > 3500 then
        return true
    end
	if pos.x + size.width < 0 then
		return true
	end
	if pos.x - size.width > SceneBattle:getFrontLayer():getContentSize().width then
		return true
	end
	return false
end

--@brief	检测碰撞
--@return	#1:true:撞了,false:没撞
function WBossBullet:checkCollision()
	-- WZLog("WBossBullet:checkCollision xxx",self.m_mover:isCollision())
	return WBullet.checkCollision(self)
	--地形碰撞
	-- if self.m_mover:isCollision() then
 --        self:stop()
 --        return true
	-- --英雄碰撞
	-- else

 --        --溅射子弹一开始不与人物检测碰撞
 --        local isSpatterNocheckCollision = nil
 --        if self.m_bIsSpatter and BattleCommon:pointDis(self.m_tStartPos, self:getPosition()) < 100 then
 --            WZLog("WBossBullet:checkCollision two", self, tostring(self.m_bIsSpatter), BattleCommon:pointDis(self.m_tStartPos, self:getPosition()))
 --            isSpatterNocheckCollision = true
 --        end

 --        if isSpatterNocheckCollision == true then
 --            return false
 --        end

	-- 	local isHeroCollision,charaList,isReflect = self:checkCharacterCollision()
 --        isReflect = false
 --        if self.m_tIsReflectList then
 --            for i,v in pairs (self.m_tIsReflectList) do
 --                charaBattleId = i
 --                if v and BattleMethod:canReflectBullet(self,charaBattleId,1) then
 --                    WBullet.addReflectList(self,charaBattleId,1)
 --                    isReflect = v
 --                    break
 --                end
 --            end
 --        end
 --        if isReflect then
 --                --反射
 --                self.m_bIsAllCollision = true 
 --                WBullet.reflect(self,isReflect)
 --                return false, nil
 --        end
	-- 	if isHeroCollision then
	-- 		self:stop()
	-- 	end
	-- 	return isHeroCollision
	-- end
end

--@brief	检测地形碰撞
--@return	#1:true:撞了,false:没撞
function WBossBullet:checkTerrainCollision()
	WZLog("WBossBullet:checkTerrainCollision")
	
	--地形碰撞
	local isCollision,cPos,cVec = BattleMapManager:checkCollision(self.m_mover)
	if isCollision then
		self.m_anim:getAnimNode():setPosition(cPos:getX(),cPos:getY())
		self.m_mover:setMoverPosition(cPos)
		return true
	end
	return false
end

--@brief	检测人物碰撞
--@return	#1:true:撞了,false:没撞
--@return	#2:碰撞的人物列表
function WBossBullet:checkCharacterCollision()
	WZLog("WBossBullet:checkCharacterCollision")
    return WBullet.checkCharacterCollision(self)
	-- local tmpCharas = {}
	-- local isCollision = false
	-- for i,charaList in pairs(self.m_tCollisionCharacters) do
	-- 	for id,chara in pairs(charaList) do

 --            if not chara:isDead() then

 --                if chara:getMover() ~= nil and chara:getMover().setUpdatable ~= nil then
 --                    chara:setMoveUpdatable(true)
 --                end
 --            end
	-- 		if id ~= self:getOwnerChara():getBattleId() then
	-- 			local bulletPos = self:getMover():getMoverPosition()
	-- 			bulletPos = {x=bulletPos:getX(),y=bulletPos:getY()}
				
	-- 			local charaPos = chara:getCenterPos()
	-- 			charaPos = Vector2:create(charaPos.x,charaPos.y)
	-- 			WZLog("WBossBullet:checkHeroCollision", tostring(BattleCommon:checkCircleCollosion(bulletPos,self.m_nCheckCharacterCollisionRadius,charaPos,chara:getRadiusForBulletCollision())), bulletPos.x, bulletPos.y, charaPos.x, charaPos.y, self.m_nCheckCharacterCollisionRadius, chara:getRadiusForBulletCollision())
	-- 			if not chara:isDead() and BattleCommon:checkCircleCollosion(bulletPos,self.m_nCheckCharacterCollisionRadius,charaPos,chara:getRadiusForBulletCollision()) then
	-- 				if self.m_tHurtHeros[id] == nil then
	-- 					WZLog("bullet chara collosion")
	-- 					isCollision = true
	-- 					tmpCharas[id] = chara
	-- 					self.m_tHurtHeros[id] = chara
	-- 				end
	-- 			end
	-- 		end
	-- 	end
	-- end

	-- return isCollision,tmpCharas
end

--@brief    检查人物碰撞
--@param    pos:子弹位置
--@param    raduis:子弹半径
--@param    charaList:人物列表
--@return   #1:true:撞了,false:没撞
--@return   #2:碰撞的人物列表
function WBossBullet:checkCollisionWithCharacterList(pos,raduis,charaList)
   return WBullet.checkCollisionWithCharacterList(self,pos,raduis,charaList)
end

--@brief	检查伤害
--@return	#1:受伤的人物列表
--@return	#2:受伤值
function WBossBullet:checkHurt()
	-- local tHurtCharas = {}
	-- local tHurtValues = {}
	-- for i,charaList in pairs(self.m_tCollisionCharacters) do
	-- 	for id,chara in pairs(charaList) do
	-- 		if not chara:isDead() then

	-- 			local pos = self:getMover():getMoverPosition()
	-- 			local raduis = self:getExplodeRadius()
	-- 			local charaPos = chara:getCenterPos()
	-- 			charaPos = Vector2:create(charaPos.x,charaPos.y)
	-- 			local charaRaidus = chara:getRadiusForHurt()
	-- 			local collisionRang = chara:getCollisionRang()
	
	-- 			if self:checkCollisionWithRang(pos,raduis,charaPos,charaRaidus,collisionRang) then
	-- 				local hurtValue = self:getHurt(chara)
	-- 				tHurtCharas[id] = chara
	-- 				tHurtValues[id] = hurtValue
	-- 			end
	-- 		end
	-- 	end
	-- end

    WZLog("WBossBullet:checkHurt")
	-- return tHurtCharas,tHurtValues
    return WBullet.checkHurt(self)
end

--@brief	检查区域碰撞
--@param	rang:区域
--@return	#1:true:撞了,false:没撞
function WBossBullet:checkCollisionWithRang(pos,raduis,charaPos,charaRaidus,collisionRang)
    return WBullet.checkCollisionWithRang(self,pos,raduis,charaPos,charaRaidus,collisionRang)
	-- if collisionRang ~= nil then
	-- 	for i,rang in pairs(collisionRang) do
	-- 		if rang.m_nType == 0 then
	-- 			local tmpCharaPos = Vector2:create(charaPos.x + rang.m_fXOffset,charaPos.y + rang.m_fYOffset)
	-- 			if BattleCommon:checkCircleCollosion(pos,raduis,tmpCharaPos,rang.m_fRadius) then
	-- 				return true
	-- 			end
	-- 		elseif rang.m_nType == 1 then
	
	-- 			local rect = {x = charaPos.x+rang.m_fXOffset - rang.m_fWidth*0.5,y = charaPos.y+rang.m_fYOffset - rang.m_fHeight*0.5,w = rang.m_fWidth,h=rang.m_fHeight}
	-- 			local circle = {x = pos.x,y=pos.y,r = raduis}
	
	-- 			if BattleCommon:rectCircleOverLap(rect,circle) then
	-- 				return true
	-- 			end
	-- 		end
	-- 	end
	-- else
	-- 	return BattleCommon:checkCircleCollosion(pos,raduis,charaPos,charaRaidus)
	-- end
	-- return false
end

--@brief	计算伤害
--@param	chara:英雄
--@return	#1：伤害
function WBossBullet:getHurt(chara)
	-- local bulletPos = self:getMover():getMoverPosition()
	-- local charaPos = chara:getCenterPos()
	-- local distance = BattleCommon:pointDis(bulletPos,charaPos)
	-- distance = distance - chara:getRadiusForHurt()
	-- distance = (distance > 0 and distance) or distance
	-- local hurt = self:calculateHurt(distance,self:getOwnerChara(),chara)
	-- return hurt
    return WBullet.getHurt(self,chara)
end

--@brief	根据距离、射击玩家、被射玩家计算出基础伤害值
--@return	#1：伤害
function WBossBullet:calculateHurt(distance,shootHero,targetHero)
    return WBullet.calculateHurt(self,distance,shootHero,targetHero)
end

function WBossBullet:getHurtType(shootHero,targetHero)
    return WBullet.getHurtType(self,shootHero,targetHero)
end

--@brief	设置子弹与人物碰撞时检测的半径
--@param	nRadius:子弹半径
function WBossBullet:setCheckCharacterCollisionRadius(nRadius)
	self.m_nCheckCharacterCollisionRadius = nRadius
end

--@brief	设置子弹的动画的默认方向
--@param	nDirection:子弹方向
function WBossBullet:setAnimDefaultDirection(nDirection)
	self.m_nAnimDefaultDirection = nDirection
end

--@brief	检测是否超过地图的高度
--@return	#1:超出的高度
function WBossBullet:checkHigherThanMap()
	WZLog("WBossBullet:checkHigherThanMap")
	local size = self.m_anim:getAnimNode():getContentSize()
	local pos = self.m_mover:getMoverPosition()
    
	local height =  pos.y - size.height - SceneBattle:getFrontLayer():getContentSize().height
    
    if height < 0 then
        height = 0
    end
    
	return height / 10.0
end

--@brief	显示子弹高度
function WBossBullet:showHeight()
	WZLog("WBossBullet:showHeight")
    
    local curPos = self.m_mover:getMoverPosition()
	local height = self:checkHigherThanMap()
    if height > 0 then
        
        --检查是否已经有其它炮弹的Label显示在地图上,只能有一个label显示出来
        local isLabelInMap = false
        local bullets = WBattleGlobal:getCurrent():getBossBulletsList()
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
            local posY = SceneBattle:getFrontLayer():getContentSize().height - self.m_tHigherThanMapLabel:getContentSize().height
            
            --修正X坐标
            local labelWidth = self.m_tHigherThanMapLabel:getContentSize().width
            local mapWidth = SceneBattle:getFrontLayer():getContentSize().width
            if posX < labelWidth then
                posX = labelWidth
            elseif posX > mapWidth - labelWidth then
                posX = mapWidth -  labelWidth
            end
            
            --坐标转换成世界坐标
            local point = SceneBattle:getFrontLayer():convertToWorldSpace(GlobalMethod:ccp(posX,posY))
            point = SceneBattle:getInfoLayer():convertToNodeSpace(point)
            
            local text = LocalStrings.BULLET_HEIGHT
            text = string.format(text, height)
            
            --更新高度和位置
            self.m_tHigherThanMapLabel:setText(text)
            self.m_tHigherThanMapLabel:setPositionX(point.x)
            self.m_tHigherThanMapLabel:setPositionY(point.y)
        end
    else
        if self.m_tHigherThanMapLabel ~= nil then
            self.m_tHigherThanMapLabel:setVisible(false)
        end
    end
end

--@brief	获取位置
function WBossBullet:getPosition()
    return self:getAnimation():getPosition()
end

--@brief	挖坑
function WBossBullet:DigHole()
    WBullet.DigHole(self)
-- 	WZLog("WBossBullet:DigHole 0", self:getOwnerChara():getRectForBulletExplodeBomb().x, self:getOwnerChara():getRectForBulletExplodeBomb().y, tostring(self:getBreakCircle()), tostring(self:getBreakCircleMark()), self.m_mover:getMoverPosition().x, self.m_mover:getMoverPosition().y)

--     if (self:getOwnerChara():getRectForBulletExplodeBomb().x > 0 or self:getOwnerChara():getRectForBulletExplodeBomb().y > 0) then
-- 		if BattleMapManager:drawBroke(self.m_mover:getMoverPosition(),self:getBreakCircle(),self:getBreakCircleMark(),self:getOwnerChara():getRectForBulletExplodeBomb().x,self:getOwnerChara():getRectForBulletExplodeBomb().y) == false then
-- 			WZLog("terrain broke failed",self.m_mover:getMoverPosition().x,self.m_mover:getMoverPosition().y)
-- 			return
--         else
--             WZLog("WBossBullet:DigHole 1")
-- 		end
-- 	end
end

--@brief	获取爆破纹理
--@return	#1:BreakCircleMark爆破纹理
function WBossBullet:getBreakCircle()
	if self:getOwnerChara():getBulletCilcle() and self:getOwnerChara():getBulletCilcle():count() > 0 then
		return tolua.cast(self:getOwnerChara():getBulletCilcle():objectAtIndex(0),"WDMemoryImage")
	else
		return nil
	end
end

--@brief	获取爆破圈
--@return	#1:BreakCircleMark爆破圈
function WBossBullet:getBreakCircleMark()
	if self:getOwnerChara():getBulletCilcle() and self:getOwnerChara():getBulletCilcle():count() > 1 then
		return tolua.cast(self:getOwnerChara():getBulletCilcle():objectAtIndex(1),"WDMemoryImage")
	else
		return nil
	end
end

--@计算圆与矩形的距离
function WBossBullet:distanceWithCircleAndRect(circle, rect)
    WZLog("WBossBullet:distanceWithCircleAndRect")
    return WBullet.distanceWithCircleAndRect(self,circle,rect)
end

-------------------------------------私有方法模块--------------------------------------
