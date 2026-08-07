--TeachBullet.lua
--@brief	子弹数据表
--@date		2013/3/3
--@author	Zjh
--@note		子弹的属性与控制

--[[
--@brief	运行状态
BulletStatus = {
	DEF_ST_FLY = 0, --飞行
	DEF_ST_EXPLODE = 1, --爆炸
	DEF_ST_END_EXPLODE = 2, --爆炸完毕
	DEF_ST_NONE = -1, --空的状态,用于转换状态时
}
--]]
--@brief	子弹数据表
TeachBullet = {
	--子弹飞行数据
	m_tStartPos = nil,					--射击开始位置
	m_tStartSpeed = nil,				--射击速度
	m_tAcceleration = nil,				--子弹加速度
	m_nType = nil,						--子弹类型  0:投砸  1:射击

	--对象
	m_mover = nil, 						--移动控制对象
	m_anim = nil, 						--动画控制对象
	m_ownerChara = nil,					--所属对象

	--状态
	m_nCurStatus = nil,					--当前状态

	--碰撞列表
	m_tCollisionCharacters = nil,		--需要碰撞的人物列表

	--爆炸相关(暂时)
	m_tExplodeElement = nil,			--爆炸动画
}

-------------------------------------公有方法模块--------------------------------------

--@brief	生成一个子弹
--@param	tPos:位置
--@param	tSpeed:速度
--@param	tAcceleration:加速度
--@param	tChara:子弹所属人物
function TeachBullet:buildBullet(tPos, tSpeed, tAcceleration, tChara)
	local bullet = {}
	setmetatable(bullet, {__index = self})

	bullet.m_tStartPos = tPos
	bullet.m_tStartSpeed = tSpeed
	bullet.m_tAcceleration = tAcceleration
	bullet.m_ownerChara = tChara
	bullet.m_nType = bullet.m_ownerChara:getWeaponType()
	bullet.m_nCurStatus = BulletStatus.DEF_ST_FLY
	bullet.m_tCollisionCharacters = {}

	local strWeapon = bullet.m_ownerChara:getWeaponName()
	bullet.m_anim = BattleAnimation:createAnimation(IWCO_BATTLEEFFICIENTS)
	bullet.m_anim:addAnimation("fly1",{weapon=strWeapon},0.1,false)
	bullet.m_anim:addAnimation("fly2",{weapon=strWeapon},0.1,false)
	bullet.m_anim:setPosition(tPos)

	--新爆破效果
	bullet.m_tExplodeElement = TeachBattle:buildWeaponExplodeElement(bullet,strWeapon)
	if bullet.m_tExplodeElement ~= nil then
		bullet.m_tExplodeElement:retain()
	--旧爆破效果
	else
		bullet.m_anim:addAnimation("blasting",{weapon=string.format("%sc",string.sub(strWeapon,0,strWeapon:len()-1))},0.1,false)
	end

	bullet.m_mover = WDMover:create()
	bullet.m_mover:retain()
	bullet.m_mover:setMoverCollisionType(BattleConstants.g_nE_COLLISION_CIRCLE)
	bullet.m_mover:setMoverRadius(bullet.m_anim:getAnimNode():getContentSize().width * 0.25)
	bullet.m_mover:setMoverPosition(Vector2:create(bullet.m_tStartPos.x,bullet.m_tStartPos.y))
	bullet.m_mover:setMoverSpeed(Vector2:create(bullet.m_tStartSpeed.x,bullet.m_tStartSpeed.y))
	bullet.m_mover:setMoverAcceleration(Vector2:create(bullet.m_tAcceleration.x,bullet.m_tAcceleration.y))

	return bullet
end

--@brief	添加人物碰撞列表
--@param	tCharas:人物碰撞列表
function TeachBullet:addCollisionCharas(tCharas)
	table.insert(self.m_tCollisionCharacters,tCharas)
end

--@brief	设置子弹状态
--@param	nStatus:子弹状态
function TeachBullet:setStatus(nStatus)
	self.m_nCurStatus = nStatus
end

--@brief	获取子弹状态
--@return	#1：子弹状态
function TeachBullet:getStatus()
	return self.m_nCurStatus
end

--@brief	获取子弹飞行类型
--@return	#1：0:投掷 1:射击
function TeachBullet:getShootType()
	return self.m_nType
end

--@brief	销毁一个子弹
function TeachBullet:destroy()
	self.m_mover:release()
	self.m_anim:getAnimNode():removeFromParentAndCleanup(true)
	if self.m_tExplodeElement ~= nil then
		self.m_tExplodeElement:release()
	end
	self.m_tExplodeElement = nil
	self.m_mover = nil
	self.m_anim = nil
	self.m_tCollisionCharacters = nil
end

--@brief	获取发射子弹的玩家
--@return	#1:发射子弹的玩家
function TeachBullet:getOwnerChara()
	return self.m_ownerChara
end

--@brief	获取移动控制对象
--@return	#1:WDMove移动控制对象
function TeachBullet:getMover()
	return self.m_mover
end

--@brief	获取动画控制对象
--@return	#1:BattleAnimation动画控制对象
function TeachBullet:getAnimation()
	return self.m_anim
end


--@brief	更新位置
function TeachBullet:updatePosition()
	self.m_mover:updatePostion()
	local curPos = self.m_mover:getMoverPosition()
	self.m_anim:getAnimNode():setPosition(curPos:getX(),curPos:getY())

	--转起来
	local speed = self.m_mover:getMoverSpeed()
	if self:getShootType() == 0 then
		if speed:getX() > 0 then
			self.m_anim:setRotate(self.m_anim:getRotate() + 14)
		else
			self.m_anim:setRotate(self.m_anim:getRotate() - 14)
		end
	--根据前一个位置计算角度
	elseif self:getShootType() == 1 then
		local prePos = self.m_mover:getMoverPrePosition()
		local angle = BattleCommon:pointToAngle({x=curPos.x-prePos.x,y=curPos.y-prePos.y})
		self.m_anim:setRotate(-1*BattleCommon:radiansToDegress(angle))
	end
end

--@brief	子弹停止
function TeachBullet:stop()
	WZLog("TeachBullet:stop")
	self.m_mover:setMoverSpeed(Vector2:create(0,0))
	self.m_mover:setMoverAcceleration(Vector2:create(0,0))
end

--@brief	子弹爆炸
function TeachBullet:explode()
	WZLog("TeachBullet:explode one")
	SoundManager:playEffectSound(SoundDefine.E_S_EXPLODE)
	self.m_nCurStatus = BulletStatus.DEF_ST_EXPLODE

	if self.m_tExplodeElement == nil then
		self.m_anim:play("blasting",false)
        WZLog("TeachBullet:explode two")
	else
		self.m_anim:getAnimNode():setVisible(false)
		self.m_tExplodeElement:setUseAbsCoordinate(true)

        if self.m_ownerChara:getId() == TeachBattle:getBoss():getId() then
            self.m_tExplodeElement:setAbsPosition(GlobalMethod:ccp(self:getMover():getMoverPosition().x + 30,self:getMover():getMoverPosition().y + 30))
        else
            self.m_tExplodeElement:setAbsPosition(GlobalMethod:ccp(self:getMover():getMoverPosition().x,self:getMover():getMoverPosition().y))
        end
		SceneTeachBattle:getFrontLayer():addChild(self.m_tExplodeElement)
        WZLog("TeachBullet:explode three")
	end

    self:DigHole()
end

--@brief	挖坑
function TeachBullet:DigHole()
    --WZLog("DigHole 0", tostring(BattleMapManager:drawBroke(self.m_mover:getMoverPosition(),self:getBreakCircle(),self:getBreakCircleMark())))
	if BattleMapManager:drawBroke(self.m_mover:getMoverPosition(),self:getBreakCircle(),self:getBreakCircleMark()) == false then
		WZLog("terrain broke failed",self.m_mover:getMoverPosition().x,self.m_mover:getMoverPosition().y)
		return
	end
end

--@brief	获取爆破纹理
--@return	#1:BreakCircleMark爆破纹理
function TeachBullet:getBreakCircle()
	if self:getOwnerChara():getBulletCilcle() and self:getOwnerChara():getBulletCilcle():count() > 0 then
		return tolua.cast(self:getOwnerChara():getBulletCilcle():objectAtIndex(0),"WDMemoryImage")
	else
		return nil
	end
end

--@brief	获取爆破圈
--@return	#1:BreakCircleMark爆破圈
function TeachBullet:getBreakCircleMark()
	if self:getOwnerChara():getBulletCilcle() and self:getOwnerChara():getBulletCilcle():count() > 1 then
		return tolua.cast(self:getOwnerChara():getBulletCilcle():objectAtIndex(1),"WDMemoryImage")
	else
		return nil
	end
end

function TeachBullet:_XmlActionFinishCallback()
	self.m_nCurStatus = BulletStatus.DEF_ST_END_EXPLODE
	self.m_tExplodeElement:removeFromParentAndCleanup(false)
end

--@brief	子弹是否爆炸完毕
--@return	#1:true:是，false：否
function TeachBullet:explodeIsEnd()
	WZLog("TeachBullet:explodeIsEnd")
	if self.m_nCurStatus == BulletStatus.DEF_ST_END_EXPLODE then
		return true
	end

	if self.m_anim:isPlaying("blasting") and self.m_anim:isCurrentAnimationDone() then
		self.m_nCurStatus = BulletStatus.DEF_ST_END_EXPLODE
		return true
	end
	return false
end


--@brief	检测是否超出屏外
--@return	#1:true:是,false:否
function TeachBullet:checkOutOfScene()
	WZLog("TeachBullet:checkOutOfScene")
	local size = self.m_anim:getAnimNode():getContentSize()
	local pos = self.m_mover:getMoverPosition()
	if pos.y + size.height < 0 then
		return true
	end
	if pos.x + size.width < 0 then
		return true
	end
	if pos.x - size.width > SceneTeachBattle:getFrontLayer():getContentSize().width then
		return true
	end
	return false
end


--@brief	检测碰撞
--@param	heros:英雄列表
--@return	#1:true:撞了,false:没撞
--@return	#2:英雄列表
function TeachBullet:checkCollision()
	WZLog("TeachBullet:checkCollision")


	local isHeroCollision,charaList = self:checkCharacterCollision()
	if isHeroCollision then
		self:stop()
	end
	return isHeroCollision,charaList

end

--@brief	检测人物碰撞
--@return	#1:true:撞了,false:没撞
--@return	#2:碰撞的人物列表
function TeachBullet:checkCharacterCollision()
	WZLog("TeachBullet:checkHeroCollision")
	local tmpCharas = {}
	local isCollision = false
	for i,charaList in pairs(self.m_tCollisionCharacters) do
		local isCollisionInList,collisionCharas = self:checkCollisionWithCharacterList(self:getMover():getMoverPosition(),2,charaList)

		if not isCollision then
			isCollision = isCollisionInList
		end

		AddTableToTable(tmpCharas,collisionCharas)
	end
	return isCollision,tmpCharas
end

--@brief	检查人物碰撞
--@param	pos:子弹位置
--@param	raduis:子弹半径
--@param	charaList:人物列表
--@return	#1:true:撞了,false:没撞
--@return	#2:碰撞的人物列表
function TeachBullet:checkCollisionWithCharacterList(pos,raduis,charaList)
    WZLog("TeachBullet:checkCollisionWithCharacterList one")
	local tmpCharas = {}
	local isCollision = false
	for id,chara in pairs(charaList) do
        WZLog("TeachBullet:checkCollisionWithCharacterList two",id, self:getOwnerChara():getId(), tostring(chara:isDead()))
		if id ~= self:getOwnerChara():getId() and not chara:isDead() then
			local charaPos = chara:getCenterPos()
			local collisionRang = chara:getCollisionRang()
            WZLog("TeachBullet:checkCollisionWithCharacterList three", id, pos.x, pos.y, raduis, charaPos.x, charaPos.y, collisionRang)
			if self:checkCollisionWithRang(pos,raduis,charaPos,collisionRang) then
				WZLog("bullet chara collosion")
				isCollision = true
				tmpCharas[id] = chara
			end
		end
	end
	return isCollision,tmpCharas
end

--@brief	检查区域碰撞
--@param	rang:区域
--@return	#1:true:撞了,false:没撞
function TeachBullet:checkCollisionWithRang(pos,raduis,charaPos,collisionRang)
	if collisionRang ~= nil then
		for i,rang in pairs(collisionRang) do
			if rang.m_nType == 0 then
				local tmpCharaPos = Vector2:create(charaPos.x + rang.m_fXOffset,charaPos.y + rang.m_fYOffset)
				if BattleCommon:checkCircleCollosion(pos,raduis,tmpCharaPos,rang.m_fRadius) then
					return true
				end
			elseif rang.m_nType == 1 then

				local rect = {x = charaPos.x+rang.m_fXOffset - rang.m_fWidth*0.5,y = charaPos.y+rang.m_fYOffset - rang.m_fHeight*0.5,w = rang.m_fWidth,h=rang.m_fHeight}
				local circle = {x = pos.x,y=pos.y,r = raduis}

				if BattleCommon:rectCircleOverLap(rect,circle) then
					return true
				end
			end
		end
	end
	return false
end

--@brief	检查伤害
--@return	#1:受伤的人物列表
--@return	#2:受伤值
function TeachBullet:checkHurt()
	local tHurtCharas = {}
	local tHurtValues = {}
	for i,charaList in pairs(self.m_tCollisionCharacters) do
		for id,chara in pairs(charaList) do
			if not chara:isDead() then
				local hurtValue = self:getHurt(chara)
				tHurtCharas[id] = chara
				tHurtValues[id] = hurtValue
			end
		end
	end
	return tHurtCharas,tHurtValues
end

--@brief	计算伤害
--@param	chara:英雄
--@return	#1：伤害
function TeachBullet:getHurt(chara)
	return self:getOwnerChara():getAttack()
end

-------------------------------------私有方法模块--------------------------------------
