--WPetBullet.lua
--@brief	宠物子弹数据表
--@date		2013/12/24
--@author	李光森
--@note		宠物子弹的属性与控制

--@brief	子弹数据表
WPetBullet = {
	--子弹飞行数据
	m_tStartPos = nil,					--射击开始位置
	m_tStartSpeed = nil,				--射击速度
	m_tAcceleration = nil,				--子弹加速度
	m_nType = nil,						--子弹类型  0:投砸  1:射击  2:跟随地形  3:角度不变
	m_tTargetPos = nil,					--目标位置
	
	--状态
	m_nCurStatus = nil,					--当前状态

	--对象			
	m_mover = nil, 						--移动控制对象
	m_anim = nil, 						--动画控制对象
	m_ownerChara = nil,					--所属对象

	--碰撞列表
	m_tCollisionCharacters = nil,		--需要碰撞的人物列表
}

-------------------------------------公有方法模块--------------------------------------

--@brief	生成一个子弹
--@param	tPos:位置
--@param	tSpeed:速度
--@param	tAcceleration:加速度
--@param	tChara:子弹所属人物
--@param	nShootType:子弹类型 0:投砸  1:射击  2:跟随地形  3: 角度不变
--@param	targetPos:目标位置
function WPetBullet:buildBullet(tPos, tSpeed, tAcceleration, tChara, nShootType, targetPos)
	local bullet = {}
	setmetatable(bullet, {__index = self})

	bullet.m_tStartPos = tPos
	bullet.m_tTargetPos = targetPos
	bullet.m_tStartSpeed = tSpeed
	bullet.m_tAcceleration = tAcceleration
	bullet.m_ownerChara = tChara
	bullet.m_nType = nShootType or 1
	bullet.m_nCurStatus = BulletStatus.DEF_ST_FLY
	bullet.m_tCollisionCharacters = {}
	--2.0风格骨骼动画
    local petAnimId = nil
    if string.len(bullet.m_ownerChara:getPet().m_tPetInfo.petSkillId) == 1 then
        petAnimId = "000" .. bullet.m_ownerChara:getPet().m_tPetInfo.petSkillId
    elseif string.len(bullet.m_ownerChara:getPet().m_tPetInfo.petSkillId) == 2 then
        petAnimId = "00" .. bullet.m_ownerChara:getPet().m_tPetInfo.petSkillId
    end
    bullet.m_anim = BattleAnimation:createAnimation("pet"..petAnimId,true)
	bullet.m_anim:setPosition(tPos)
	if bullet.m_tStartSpeed.x < 0 and bullet.m_nType == 3 then
		bullet.m_anim:getAnimNode():setFlipX(true)
	end
	--bullet.m_anim:showAnchor(true)
	
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
function WPetBullet:addCollisionCharas(tCharas)
	table.insert(self.m_tCollisionCharacters,tCharas)
end

--@brief	设置子弹状态
--@param	nStatus:子弹状态
function WPetBullet:setStatus(nStatus)
	self.m_nCurStatus = nStatus
end

--@brief	获取子弹状态
--@return	#1：子弹状态
function WPetBullet:getStatus()
	return self.m_nCurStatus
end

--@brief	获取子弹飞行类型
--@return	#1：0:投掷 1:射击
function WPetBullet:getShootType()
	return self.m_nType
end

--@brief	销毁一个子弹
function WPetBullet:destroy()
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
function WPetBullet:getOwnerChara()
	return self.m_ownerChara
end

--@brief	获取移动控制对象
--@return	#1:WDMove移动控制对象
function WPetBullet:getMover()
	return self.m_mover
end

--@brief	获取动画控制对象
--@return	#1:BattleAnimation动画控制对象
function WPetBullet:getAnimation()
	return self.m_anim
end

--@brief	获取爆破半径
--@return	#1:爆破半径
function WPetBullet:getExplodeRadius()
	return self:getOwnerChara():getRadiusForBulletExplode()
end

--@brief	获取爆破纹理
--@return	#1:BreakCircleMark爆破纹理
function WPetBullet:getBreakCircle()
	if self:getOwnerChara():getBulletCilcle() and self:getOwnerChara():getBulletCilcle():count() > 0 then
		return tolua.cast(self:getOwnerChara():getBulletCilcle():objectAtIndex(0),"WDMemoryImage")
	else
		return nil
	end
end

--@brief	获取爆破圈
--@return	#1:BreakCircleMark爆破圈
function WPetBullet:getBreakCircleMark()
	if self:getOwnerChara():getBulletCilcle() and self:getOwnerChara():getBulletCilcle():count() > 1 then
		return tolua.cast(self:getOwnerChara():getBulletCilcle():objectAtIndex(1),"WDMemoryImage")
	else
		return nil
	end
end

--@brief	更新位置
function WPetBullet:updatePosition()
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
		--self.m_anim:getAnimNode():setFlipX(true)
		--[[if (angle >= -1*math.pi and angle < -0.5*math.pi) or (angle >= 0.5*math.pi and angle < math.pi) then
			self.m_anim:getAnimNode():setFlipX(true)
			if angle >= -1*math.pi and angle < -0.5*math.pi then
				self.m_anim:setRotate(BattleCommon:radiansToDegress(math.pi/2 + angle))
			else
				self.m_anim:setRotate(BattleCommon:radiansToDegress(angle - math.pi/2))
			end
		else]]
			--self.m_anim:getAnimNode():setFlipX(false)
			self.m_anim:setRotate(-1*BattleCommon:radiansToDegress(angle))
		--end
		
	--子弹跟随地形
	elseif self:getShootType() == 2 then
		local isCollision,newPos,tangent = BattleMapManager:checkCollision(self.m_mover)
		if isCollision then
			self.m_mover:setMoverPosition(newPos)
			self.m_anim:getAnimNode():setPosition(newPos.x,newPos.y)
		end
	--角度不变
	elseif self:getShootType() == 3 then
	end
end

--@brief	子弹停止
function WPetBullet:stop()
	--WZLog("WPetBullet:stop")
	self.m_mover:setMoverSpeed(Vector2:create(0,0))
	self.m_mover:setMoverAcceleration(Vector2:create(0,0))
end

--@brief	子弹爆炸
function WPetBullet:explode()
	--WZLog("WPetBullet:explode")
	SoundManager:playEffectSound(SoundDefine.E_S_EXPLODE)
	self.m_nCurStatus = BulletStatus.DEF_ST_EXPLODE

	if self.m_tExplodeElement == nil then
		self.m_anim:play("blasting",false)
	else
		self.m_anim:getAnimNode():setVisible(false)
		self.m_tExplodeElement:setUseAbsCoordinate(true)
		self.m_tExplodeElement:setAbsPosition(GlobalMethod:ccp(self:getMover():getMoverPosition().x,self:getMover():getMoverPosition().y))
		SceneBattle:getFrontLayer():addChild(self.m_tExplodeElement)
	end

	self:DigHole()
end

function WPetBullet:_XmlActionFinishCallback()
	self.m_nCurStatus = BulletStatus.DEF_ST_END_EXPLODE
	self.m_tExplodeElement:removeFromParentAndCleanup(false)
end

--@brief	挖坑
function WPetBullet:DigHole()
	if self:getOwnerChara():getCanDigHole() and BattleMapManager:drawBroke(self.m_mover:getMoverPosition(),self:getBreakCircle(),self:getBreakCircleMark()) == false then
		WZLog("terrain broke failed",self.m_mover:getMoverPosition().x,self.m_mover:getMoverPosition().y)
		return
	end
end

--@brief	子弹是否爆炸完毕
--@return	#1:true:是，false：否
function WPetBullet:explodeIsEnd()
	--WZLog("WPetBullet:explodeIsEnd")
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
function WPetBullet:checkOutOfScene()
	--WZLog("WPetBullet:checkOutOfScene")
	local size = self.m_anim:getAnimNode():getContentSize()
	local pos = self.m_mover:getMoverPosition()
	if pos.y + size.height < 0 then
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
function WPetBullet:checkCollision()
	--WZLog("WPetBullet:checkCollision")
	
	--地形碰撞
	local isCollision,cPos,cVec = BattleMapManager:checkCollision(self.m_mover,true,self:getBreakCircleMark())
	if isCollision then
		self.m_anim:getAnimNode():setPosition(cPos:getX(),cPos:getY())
		self.m_mover:setMoverPosition(cPos)

		self:stop()
		return isCollision,{}
	--英雄碰撞
	else
		local isHeroCollision,charaList = self:checkCharacterCollision()
		if isHeroCollision then
			self:stop()
		end
		return isHeroCollision,charaList
	end
end

--@brief	检测人物碰撞
--@return	#1:true:撞了,false:没撞
--@return	#2:碰撞的人物列表
function WPetBullet:checkCharacterCollision()
	--WZLog("WPetBullet:checkHeroCollision")
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

--@brief	检测是否穿越了玩家
--@return	#1:true:是,false:否
function WPetBullet:checkOutOfTarget()
	--WZLog("WPetBullet:checkOutOfScene")
	local res = false
	local curPos = self:getMover():getMoverPosition()
	--目标在左边
	if self.m_tStartPos.x > self.m_tTargetPos.x then
		if self.m_tTargetPos.x > curPos.x then
			res = true
		end
	--目标在右边
	else
		if self.m_tTargetPos.x < curPos.x then
			res = true
		end
	end

	--目标在上边
	if self.m_tStartPos.y < self.m_tTargetPos.y then
		if self.m_tTargetPos.y < curPos.y then
			res = true
		end
	--目标在下边
	else
		if self.m_tTargetPos.y > curPos.y then
			res = true
		end
	end
	return res
end

--@brief	检查人物碰撞
--@param	pos:子弹位置
--@param	raduis:子弹半径
--@param	charaList:人物列表
--@return	#1:true:撞了,false:没撞
--@return	#2:碰撞的人物列表
function WPetBullet:checkCollisionWithCharacterList(pos,raduis,charaList)
	local tmpCharas = {}
	local isCollision = false
	for id,chara in pairs(charaList) do
		if chara:getBattleId() ~= self:getOwnerChara():getBattleId() and not chara:isDead() then

			local charaPos = chara:getCenterPos()
			local charaRaidus = chara:getRadiusForBulletCollision()
			local collisionRang = chara:getCollisionRang()

			if (collisionRang ~= nil and self:checkCollisionWithRang(pos,raduis,charaPos,collisionRang)) or
			 (collisionRang == nil and BattleCommon:checkCircleCollosion(pos,raduis,charaPos,charaRaidus)) then
				WZLog("bullet chara collosion")
				isCollision = true
				tmpCharas[chara:getBattleId()] = chara
			end
		end
	end
	return isCollision,tmpCharas
end

--@brief	检查区域碰撞
--@param	rang:区域
--@return	#1:true:撞了,false:没撞
function WPetBullet:checkCollisionWithRang(pos,raduis,charaPos,collisionRang)
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
	return false
end

--@brief	检查伤害
--@return	#1:受伤的人物列表
--@return	#2:受伤值
function WPetBullet:checkHurt()
	local tHurtCharas = {}
	local tHurtValues = {}
	for i,charaList in pairs(self.m_tCollisionCharacters) do
		for id,chara in pairs(charaList) do
			if not chara:isDead() then
				local charaPos = chara:getCenterPos()
				charaPos = Vector2:create(charaPos.x,charaPos.y)
	
				if BattleCommon:checkCircleCollosion(self:getMover():getMoverPosition(),self:getExplodeRadius(),charaPos,chara:getRadiusForHurt()) == true then
					local hurtValue = self:getHurt(chara)
					tHurtCharas[chara:getBattleId()] = chara
					tHurtValues[chara:getBattleId()] = hurtValue
				end
			end
		end
	end
	return tHurtCharas,tHurtValues
end

--@brief	计算伤害
--@param	chara:英雄
--@return	#1：伤害
function WPetBullet:getHurt(chara)
	local bulletPos = self:getMover():getMoverPosition()
	local charaPos = chara:getCenterPos()
	local distance = BattleCommon:pointDis(bulletPos,charaPos)
	distance = distance - chara:getRadiusForHurt()
	distance = (distance > 0 and distance) or distance
	local hurt = self:calculateHurt(distance,self:getOwnerChara(),chara)
	return hurt
end

--@brief	根据距离、射击玩家、被射玩家计算出基础伤害值
--@return	#1：伤害
function WPetBullet:calculateHurt(distance,shootHero,targetHero)
    distance = math.floor(distance)
	local hurt = 0
	local attack = nil
	--大招
	if shootHero:getUseBigSkill() then
		attack = shootHero:getAttack()
	--非大招
	else
		attack = shootHero:getAttack()
	end

	--破防
	local wreckDefense = shootHero:getWreckDefense()
	--暴击率
	local critRate = shootHero:getCriticalhitAttackRate()
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

    s1 = (0.75 + 0.5 * (agility + 500) / (agility + lucky + 1000))

    s2 = defend * (1 - wreckDefense / (wreckDefense + 500)) / (2 * defend * (1 - wreckDefense / (wreckDefense + 500)) + 1200)
    s3 = 1 + (level - levelBeAtk) /  300
    s4 = 1 - 0.3 * injuryFree / (injuryFree + 1000)

    s5 = (1 - s2) * s3 * s4

    local attackCoefficient = attack
    if attack > 6000 then
        attackCoefficient = 6000
    end
    local coefficient = 10000 / (attackCoefficient + 10000)

    reduceAcctak = s0 * s1 * s5 * coefficient

    WZLog("WBossBullet:calculateHurt four","体质="..constitution,"敌体质="..constitutionBeAtk,"速度="..agility,"幸运="..lucky,s1,s2,s3,reduceAcctak)

    --暴击
    if WBattleGlobal:getCurrent().m_nIsCriticalHit == 1 then
        hurt = (1.2 + critRate / (critRate + targetHero:getCriticalhitAttackRate() + 1) * 0.15 + agility / (agility + lucky + 1) * 0.15) * (reduceAcctak)
       --非暴击
    else
        hurt = (reduceAcctak);
    end


	--伤害值在96%~104%之间浮动
	local randCount =0;

    if #WBattleGlobal:getCurrent().m_tBattleRand > 0 then			--随机数
		randCount = WBattleGlobal:getCurrent().m_tBattleRand[1] % 9
    else
		randCount = 4
	end

    hurt = hurt * (randCount + 96) * 0.01;

    if hurt < attack*0.1 then
        hurt = attack*0.1;
	end

	--道具攻击
	hurt = hurt * shootHero:getAttPercent() / 100
	
	if distance < shootHero:getRadiusForBulletExplode()*0.3 then
    elseif distance < shootHero:getRadiusForBulletExplode()*0.6 then
		hurt = hurt*0.7
    else
        hurt = hurt*0.3
	end
	
	--隐身伤害减半
	--if targetHero:isHide() then
	--	hurt = hurt * 0.5
	--end
	hurt = hurt * targetHero:getReduceHurt()

	--无敌状态
    if targetHero.m_nBuffInvincibleRound ~= nil and targetHero.m_nBuffInvincibleRound > 0 then
        hurt = 1
    end

	return math.floor(hurt)
end

-------------------------------------私有方法模块--------------------------------------
