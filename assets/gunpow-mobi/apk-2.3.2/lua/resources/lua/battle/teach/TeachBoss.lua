--TeachBoss.lua
--@brief	教学boss
--@date		2013/2/25
--@author	Zjh
--@note		教学boss


--@brief	boss数据表
TeachBoss = {
	m_anim = nil,
	m_shopAnim = nil,
	m_nMaxHP = nil,
	m_nHP = nil,
	m_sName = nil,
	m_nId = nil,
	m_tCollisionRang = nil,
	--WBoss5
	m_specialEffect = nil,		--特效
	m_lightWarn = nil,			--技能光柱
	m_warnMark = nil,			--技能位置提示
	m_fireEffect = nil,			--龙息技能光柱
	m_sceneFire = nil,			--全屏燃烧
	
	m_nSkillStep = nil,
	m_nCurStatus = nil, 
	
	--@brief 伤害相关
	m_bIsHurt = nil,					--标记受伤状态
	m_nFlyingNum = nil,					--正在飘的数字数量
	m_tHurtValue = nil,					--受伤数据表
}

--@brief	boss5特效表
TeachBoss = {
	DEF_SE_LX_WARNING = 1,		--龙息提示光柱特效，由2部分组成，斜上45度
	DEF_SE_LX_CAST = 2,			--龙息技能光柱，由2部分组成，斜上45度
	DEF_SE_RYLH_WARNING = 3,	--熔岩烈火提示光柱特效，由2部分组成，斜下45度
	DEF_SE_RYLH_CAST = 4,		--熔岩烈火技能光柱，由2部分组成，斜下45度
	--DEF_SE_AIR = 5,				--空气效果，boss起飞.降落至地面.与近攻时放的特效
	DEF_SE_FIRE = 6,			--发动龙息与发动熔岩烈火技能时放在嘴前的特效
	DEF_SE_RYLH_SCENE = 7,		--熔岩烈火全屏特效
	DEF_SE_DEATH = 8,			--死亡的光
}
-------------------------------------公有方法模块--------------------------------------

--@brief	生成一个怪物
--@return	#1:怪物数据表
function TeachBoss:buildGuai()
	local boss = TeachBoss:new()

	boss.m_anim = BattleAnimation:createAnimation(IWCO_BOSS5)
	boss.m_anim:getAnimNode():retain()
	boss.m_anim:addAnimation("stand",{}, 0.2, true)	--待机
	boss.m_anim:addAnimation("stand2",{}, 0.2, true)	--起飞状态
	boss.m_anim:addAnimation("stand3",{}, 0.2, true)	--飞行空中状态
	boss.m_anim:addAnimation("stand4",{}, 0.2, true)	--降落至地面状态
	boss.m_anim:addAnimation("attack1",{}, 0.2, true)	--发动龙息技能提示 (循环)
	boss.m_anim:addAnimation("attack2",{}, 0.2, true)	--发动龙息技能攻击范围内的玩家
	boss.m_anim:addAnimation("attack3",{}, 0.2, true)	--发动熔岩烈火技能提示状态
	boss.m_anim:addAnimation("attack4",{}, 0.2, true)	--发动熔岩烈火技能，火焰燃烧状态
	boss.m_anim:addAnimation("attack5",{}, 0.2, true)	--召唤黑龙护卫
	boss.m_anim:addAnimation("attack6",{}, 0.2, true)	--近身攻击状态
	boss.m_anim:addAnimation("attack7",{}, 0.2, true)	--发动龙息技能提示（前动作)
	boss.m_anim:addAnimation("injured",{}, 0.2, true)	--被攻击状态
	boss.m_anim:addAnimation("injured2",{}, 0.2, true)	--飞行空中状态被打中状态
	boss.m_anim:addAnimation("die",{}, 0.2, true)		--死亡状态
	boss.m_anim:addAnimation("die2",{}, 0.2, true)		--空中死亡状态
	boss.m_anim:setFlipX(true)

	--商城形象
	boss.m_shopAnim = BattleAnimation:createAnimation(IWCO_BOSS5)
	boss.m_shopAnim:getAnimNode():retain()
	boss.m_shopAnim:addAnimation("stand",{}, 0.2, true)
	boss.m_shopAnim:playTimes("stand",0)

	boss.m_shopAnim:getAnimNode():setScale(0.6)
	boss.m_shopAnim:getAnimNode():setFlipX(true)

	return boss
end

--@brief 	获取BossId
function TeachBoss:getId()
	return self.m_nId
end

--@brief 	判断是否死亡
function TeachBoss:isDead()
	return self.m_nHP <= 0
end

function TeachBoss:update()
	
	if self:getMarkHurt() then
		self:showHurt()
	end
	
	if self.m_anim:isPlaying("injured") and self.m_anim:isCurrentAnimationDone() then
		self.m_anim:play("stand",true)
	end
end
--@brief	获取中心位置
--@return	#1:中心位置
function TeachBoss:getCenterPos()
	local moverCenter = {x=0,y=0}
	local heroCenter = CCPointMake(moverCenter.x+self:getAnimation():getAnimNode():getAnchorPoint().x*self:getAnimation():getAnimNode():getContentSize().width,moverCenter.y+self:getAnimation():getAnimNode():getAnchorPoint().y*self:getAnimation():getAnimNode():getContentSize().height)
			
	local toParentTranf = self:getAnimation():getAnimNode():nodeToParentTransform()
	heroCenter=CCPointApplyAffineTransform(heroCenter,toParentTranf)
	return heroCenter
end

--@brief	获得碰撞范围
--@return 	#1:碰撞范围
function TeachBoss:getCollisionRang()
	return self.m_tCollisionRang
end

--@brief	添加矩形碰撞范围
--@param 	width,height:宽高
--@param 	xOffset,yOffset:x,y偏移量
--@note		偏移量的参考点是character的中心点
function TeachBoss:addRectCollision(width,height,xOffset,yOffset)
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

--@brief 	设置人物当前的位置
--@param 	tPos 当前位置
function TeachBoss:setPosition(tPos)
	self.m_anim:setPosition(GlobalMethod:ccp(tPos.x,tPos.y))
end

--@brief 	获得英雄当前的位置
--@return 	#1, 返回当前的位置
function TeachBoss:getPosition()
	return self.m_anim:getPosition()
end

--@brief	销毁一个角色
function TeachBoss:destroy()
	if self.m_anim then
		self.m_anim:getAnimNode():release()
		self.m_anim = nil
	end

	if self.m_shopAnim then
		self.m_shopAnim:getAnimNode():release()
		self.m_shopAnim = nil
	end
	self.m_tCollisionRang = nil
end


--@brief	获取商城动画控制对象
--@return	#1:Animation动画控制对象
function TeachBoss:getShopAnimation()
	return self.m_shopAnim:getAnimNode()
end


--@brief	获取动画控制对象
--@return	#1:BattleAnimation动画控制对象
function TeachBoss:getAnimation()
	return self.m_anim
end


--@brief 	设置血量
--@param 	nHp 当前血量
function TeachBoss:setHp(nHp)
	self.m_nHP = nHp
	WndTeachBattleHud:updateBossHP()
end

--@brief 	获取头像路径
--@return 	头像路径
function TeachBoss:getHeadPath()
	return "image/ui/main/bossMap/guaiicon/boss5.png"
end

--@brief 	获得人物当前血量
--@return 	#1,人物当前血量
function TeachBoss:getHp()
	return self.m_nHP
end

--@brief 	获得人物最大血量
--@return 	#1,人物最大血量
function TeachBoss:getMaxHp()
	return self.m_nMaxHP
end

--@brief 	设置人物名称
--@param 	name:人物名称
function TeachBoss:setName(name)
	self.m_sName = name
end

--@brief 	获得人物名称
--@return 	#1, 返回人物名称
function TeachBoss:getName()
	return self.m_sName
end

------动画相关
function TeachBoss:createBoss5Anim()
	if self.m_specialEffect == nil then
		self.m_specialEffect = BattleAnimation:createAnimation(IWCO_MONSTEREFFICIENTS)
		self.m_specialEffect:addAnimation("boss5Efficient3",{}, 0.1, true)	--boss起飞.降落至地面.与近攻时放的特效
		self.m_specialEffect:addAnimation("boss5Efficient5",{}, 0.1, true)	--boss发动龙息与发动熔岩烈火技能时放在嘴前的特效
		self.m_specialEffect:addAnimation("boss5Efficient6",{}, 0.1, true)	--boss死亡里的光
		self.m_specialEffect:getAnimNode():setVisible(false)
		SceneTeachBattle:getFrontLayer():addChild(self.m_specialEffect:getAnimNode())
		--self.m_specialEffect:getAnimNode():setIsShowAchorPoint(true)
	end

	if self.m_lightWarn == nil then
		self.m_lightWarn = BattleAnimation:createAnimation(IWCO_MONSTEREFFICIENTS)
		self.m_lightWarn:addAnimation("boss5Efficient1",{}, 0.1, true)	--发动龙息与发动熔岩烈火技能提示状态(圆火柱)
		self.m_lightWarn:addAnimation("boss5Efficient7",{}, 0.1, true)	--发动龙息与发动熔岩烈火技能提示状态(宽火柱)
		self.m_lightWarn:getAnimNode():setVisible(false)
		SceneTeachBattle:getFrontLayer():addChild(self.m_lightWarn:getAnimNode())
	end

	if self.m_warnMark == nil then
		self.m_warnMark = CCSprite:create()
		local array = CCArray:create()
		array:addObject(CCSprite:create("common/animation/boss/boss5_mark.png"):displayFrame())
		array:addObject(CCSprite:create():displayFrame())
		array:addObject(CCSprite:create("common/animation/boss/boss5_mark1.png"):displayFrame())
		array:addObject(CCSprite:create():displayFrame())
		local anim = CCAnimation:createWithSpriteFrames(array, 0.4)
		local action =  CCRepeatForever:create(CCAnimate:create(anim))
		self.m_warnMark:setVisible(false)
		self.m_warnMark:runAction(action)
		SceneTeachBattle:getFrontLayer():addChild(self.m_warnMark)
	end

	if self.m_fireEffect == nil then
		self.m_fireEffect = BattleAnimation:createAnimation(IWCO_MONSTEREFFICIENTS)
		self.m_fireEffect:addAnimation("boss5Efficient8",{}, 0.1, true)	--发动龙息技能(宽火柱)
		self.m_fireEffect:getAnimNode():setVisible(false)
		SceneTeachBattle:getFrontLayer():addChild(self.m_fireEffect:getAnimNode())
	end

	if self.m_sceneFire == nil then
		self.m_sceneFire = {}
		for i = 1, 7 do
			self.m_sceneFire[i] = BattleAnimation:createAnimation(IWCO_MONSTEREFFICIENTS)
			self.m_sceneFire[i]:addAnimation("boss5Efficient4",{}, 0.1, true)	--boss发动熔岩烈火技能的特效。（需要程序平铺放满场景)
			self.m_sceneFire[i]:getAnimNode():setVisible(false)
			SceneTeachBattle:getFrontLayer():addChild(self.m_sceneFire[i]:getAnimNode())
			--self.m_sceneFire[i]:getAnimNode():setIsShowAchorPoint(true)
		end
	end

end

--@brief	显示特效
--@param	effect：特效ID
function TeachBoss:showSpecialEffect(effect)
	if effect == TeachBoss.DEF_SE_FIRE then
		--发动龙息与发动熔岩烈火技能时放在嘴前的特效
		local boss_size = self.m_anim:getAnimNode():getContentSize()
		local startPos = self.m_anim:getAnimNode():convertToWorldSpace(GlobalMethod:ccp(boss_size.width*0.4,boss_size.height*0.8))
		self.m_specialEffect:play("boss5Efficient5", true)
		self.m_specialEffect:getAnimNode():setPosition(SceneTeachBattle:getFrontLayer():convertToNodeSpace(startPos))
		self.m_specialEffect:getAnimNode():setVisible(true)
	elseif effect == TeachBoss.DEF_SE_DEATH then
		local boss_size = self.m_anim:getAnimNode():getContentSize()
		local startPos = self.m_anim:getAnimNode():convertToWorldSpace(GlobalMethod:ccp(boss_size.width*0.5,boss_size.height*0.4))
		self.m_specialEffect:play("boss5Efficient6", false)
		self.m_specialEffect:getAnimNode():setPosition(SceneTeachBattle:getFrontLayer():convertToNodeSpace(startPos))
		self.m_specialEffect:getAnimNode():setVisible(true)
	end
end

--@brief	显示空气效果
--@param	posX,posY:播放位置
function TeachBoss:showAirEffect(posX,posY)
	
	local startPos = self.m_anim:getAnimNode():convertToWorldSpace(GlobalMethod:ccp(posX,posY))
	self.m_specialEffect:play("boss5Efficient3", false)
	self.m_specialEffect:getAnimNode():setPosition(SceneTeachBattle:getFrontLayer():convertToNodeSpace(startPos))
	self.m_specialEffect:getAnimNode():setVisible(true)

end

function TeachBoss:isShowSpecialEffectDone()
	if self.m_specialEffect:isCurrentAnimationDone() then
		self.m_specialEffect:getAnimNode():setVisible(false)
		return true
	end
	return false
end

--@brief	显示技能光柱
--@param	effect：特效ID
function TeachBoss:showWarnEffect(effect)
	local boss_size = self.m_anim:getAnimNode():getContentSize()
	local startPos = self.m_anim:getAnimNode():convertToWorldSpace(GlobalMethod:ccp(boss_size.width*0.4,boss_size.height*0.8))
	self.m_lightWarn:getAnimNode():setScaleX(1)
	self.m_lightWarn:getAnimNode():setScaleY(1)

	if effect == TeachBoss.DEF_SE_LX_WARNING then
		--龙息提示光柱特效，由2部分组成，斜上45度
		self.m_lightWarn:play("boss5Efficient1", false)
		self.m_lightWarn:getAnimNode():setRotation(45)
	elseif effect == TeachBoss.DEF_SE_LX_CAST then
		--龙息技能光柱，由2部分组成，斜上45度
		self.m_lightWarn:play("boss5Efficient7", false)
		self.m_lightWarn:getAnimNode():setRotation(45)
	elseif effect == TeachBoss.DEF_SE_RYLH_WARNING then
		--熔岩烈火提示光柱特效，由2部分组成，斜下45度
		self.m_lightWarn:play("boss5Efficient1", false)
		self.m_lightWarn:getAnimNode():setRotation(-45)
	elseif effect == TeachBoss.DEF_SE_RYLH_CAST then
		--熔岩烈火技能光柱，由2部分组成，斜下45度
		self.m_lightWarn:play("boss5Efficient7", false)
		self.m_lightWarn:getAnimNode():setRotation(-45)
	end

	self.m_lightWarn:getAnimNode():setPosition(SceneTeachBattle:getFrontLayer():convertToNodeSpace(startPos))
	self.m_lightWarn:getAnimNode():runAction(CCScaleTo:create(0.1, 10, 1))
	self.m_lightWarn:getAnimNode():setVisible(true)
end

--@brief	显示技能位置提示
function TeachBoss:showWarnMarks(effect)
	if effect == WBoss5Status.DEF_ST_LX_WARNING then
		local hero = TeachBattle:getMyHero()
		local pos = hero:getPosition()
		self.m_warnMark:setScaleX(10)
		self.m_warnMark:setScaleY(100)
		self.m_warnMark:setPosition(GlobalMethod:ccp(pos.x,pos.y))
	elseif effect == WBoss5Status.DEF_ST_RYLH_WARNING then
		local pos = self:getPosition()
		self.m_warnMark:setScaleX(100)
		self.m_warnMark:setScaleY(10)
		self.m_warnMark:setPosition(GlobalMethod:ccp(pos.x,pos.y-400))
	end
	self.m_warnMark:setVisible(true)
end

--@brief	显示龙息技能光柱
function TeachBoss:showFireEffect()
	--龙息技能光柱，从天而降
	local startPos = GlobalMethod:ccp(self.m_warnMark:getPositionX(), 1500)
	self.m_fireEffect:getAnimNode():setScaleX(1)
	self.m_fireEffect:getAnimNode():setScaleY(1)
	self.m_fireEffect:play("boss5Efficient8", true)
	self.m_fireEffect:getAnimNode():setPosition(startPos)
	self.m_fireEffect:getAnimNode():setRotation(-90)
	local array = CCArray:create()
	array:addObject(CCScaleTo:create(1.5, 10, 1))
	array:addObject(CCCallFunc:create(_stopFireEffect_TeachBoss))
	self.m_fireEffect:getAnimNode():runAction(CCSequence:create(array))
	self.m_fireEffect:getAnimNode():setVisible(true)
end

--@brief	显示全屏燃烧
function TeachBoss:showSceneFire()
	local size = self.m_sceneFire[1]:getAnimNode():getContentSize()
	local startPos = GlobalMethod:ccp(0, size.height/3)
	for i,sceneFire in ipairs(self.m_sceneFire) do
		sceneFire:playTimes("boss5Efficient4", 3)
		sceneFire:getAnimNode():setPosition(startPos)
		sceneFire:getAnimNode():setVisible(true)
		startPos.x = startPos.x + size.width - 1
	end
end

--@brief	龙息技能光柱结束
function _stopFireEffect_TeachBoss(sender)
	TeachBattle:getBoss().m_nSkillStep = 3
end

--@brief	飞行结束
function _onFlyStoped_TeachBoss(sender)
	TeachBattle:getBoss().m_nSkillStep = 2
end

--@brief	落地结束
function _onLandStoped_TeachBoss(sender)
	TeachBattle:getBoss().m_nSkillStep = 1
end


function TeachBoss:process()
	local boss = self
	
	if boss.m_nCurStatus == WBoss5Status.DEF_ST_LX_WARNING then
		--发动龙息技能提示动画
		if boss.m_nSkillStep == 0 then
			boss.m_anim:play("attack7", false)
			boss.m_nSkillStep = 1
		elseif boss.m_nSkillStep == 1 then
			if boss.m_anim:isCurrentAnimationDone() then
				boss:showWarnEffect(TeachBoss.DEF_SE_LX_WARNING)
				boss:showSpecialEffect(TeachBoss.DEF_SE_FIRE)
				boss.m_anim:play("attack1", true)
				boss.m_nSkillStep = 2
			end
		elseif boss.m_nSkillStep == 2 then
			if boss.m_lightWarn:isCurrentAnimationDone() then
				boss.m_anim:play("stand", true)
				boss:showWarnMarks(WBoss5Status.DEF_ST_LX_WARNING)
				boss.m_lightWarn:getAnimNode():setVisible(false)
				boss.m_specialEffect:getAnimNode():setVisible(false)
				boss.m_nSkillStep = -1
				return true
			end
		end
	elseif boss.m_nCurStatus == WBoss5Status.DEF_ST_LX_CAST then
		--发动龙息技能攻击动画
		if boss.m_nSkillStep == 0 then
			boss.m_warnMark:setVisible(false)
			boss.m_anim:play("attack7", false)
			boss.m_nSkillStep = 1
		elseif boss.m_nSkillStep == 1 then
			if boss.m_anim:isCurrentAnimationDone() then
				boss:showWarnEffect(TeachBoss.DEF_SE_LX_CAST)
				boss:showSpecialEffect(TeachBoss.DEF_SE_FIRE)
				boss.m_anim:play("attack2", true)
				boss.m_nSkillStep = 2
			end
		elseif boss.m_nSkillStep == 2 then
			if boss.m_lightWarn:isCurrentAnimationDone() then
				boss.m_anim:play("stand", true)
				boss:showFireEffect()
				boss.m_lightWarn:getAnimNode():setVisible(false)
				boss.m_specialEffect:getAnimNode():setVisible(false)
				boss.m_nSkillStep = -1
			end
		elseif boss.m_nSkillStep == 3 then
			boss.m_fireEffect:getAnimNode():setVisible(false)
			boss.m_nSkillStep = -1
			return true
		end
	elseif boss.m_nCurStatus == WBoss5Status.DEF_ST_RYLH_WARNING then
		--发动熔岩烈火技能提示动画
		if boss.m_nSkillStep == 0 then
			boss:showAirEffect(450,-50)
			boss.m_anim:play("stand2", false)
			boss.m_nSkillStep = 1
		elseif boss.m_nSkillStep == 1 then
			if boss.m_anim:isCurrentAnimationDone() then
				local pos = boss.m_anim:getPosition()
				local array = CCArray:create()
				array:addObject(CCMoveTo:create(3.0,GlobalMethod:ccp(pos.x,pos.y+400)))
				array:addObject(CCCallFunc:create(_onFlyStoped_TeachBoss))
				boss.m_specialEffect:getAnimNode():setVisible(false)
				boss.m_anim:play("stand3", true)
				boss.m_anim:getAnimNode():runAction(CCSequence:create(array))
				boss.m_nSkillStep = -1
			end
		elseif boss.m_nSkillStep == 2 then
			boss:showWarnEffect(TeachBoss.DEF_SE_RYLH_WARNING)
			boss:showSpecialEffect(TeachBoss.DEF_SE_FIRE)
			boss.m_anim:play("attack3", false)
			boss.m_nSkillStep = 3
		elseif boss.m_nSkillStep == 3 then
			if boss.m_lightWarn:isCurrentAnimationDone() then
				boss.m_anim:play("stand3", true)
				boss:showWarnMarks(WBoss5Status.DEF_ST_RYLH_WARNING)
				boss.m_lightWarn:getAnimNode():setVisible(false)
				boss.m_specialEffect:getAnimNode():setVisible(false)
				boss.m_nSkillStep = -1
				return true
			end
		end
	elseif boss.m_nCurStatus == WBoss5Status.DEF_ST_RYLH_CAST then
		--发动熔岩烈火技能，火焰燃烧动画
		if boss.m_nSkillStep == 0 then
			boss.m_warnMark:setVisible(false)
			boss:showWarnEffect(TeachBoss.DEF_SE_RYLH_CAST)
			boss:showSpecialEffect(TeachBoss.DEF_SE_FIRE)
			boss.m_anim:play("attack4", true)
			boss.m_nSkillStep = 1
		elseif boss.m_nSkillStep == 1 then
			if boss.m_lightWarn:isCurrentAnimationDone() then
				boss.m_anim:play("stand3", true)
				boss:showSceneFire()
				boss.m_lightWarn:getAnimNode():setVisible(false)
				boss.m_specialEffect:getAnimNode():setVisible(false)
				boss.m_nSkillStep = 2
			end
		elseif boss.m_nSkillStep == 2 then
			if boss.m_sceneFire[1]:isCurrentAnimationDone() then
				for i,sceneFire in ipairs(boss.m_sceneFire) do
					sceneFire:getAnimNode():setVisible(false)
				end
				boss.m_nSkillStep = -1
				return true
			end
		end
	elseif boss.m_nCurStatus == WBoss5Status.DEF_ST_RYLH_LAND then
		--熔岩烈火技能完了落地
		if boss.m_nSkillStep == 0 then
			local pos = boss.m_anim:getPosition()
			local array = CCArray:create()
			array:addObject(CCMoveTo:create(3.0,GlobalMethod:ccp(pos.x,pos.y-400)))
			array:addObject(CCCallFunc:create(_onLandStoped_TeachBoss))
			boss.m_anim:play("stand3", true)
			boss.m_anim:getAnimNode():runAction(CCSequence:create(array))
			boss.m_nSkillStep = -1
		elseif boss.m_nSkillStep == 1 then
			boss.m_anim:play("stand4", false)
			boss.m_nSkillStep = 2
		elseif boss.m_nSkillStep == 2 then
			boss.m_specialEffect:getAnimNode():setVisible(false)
			boss:showAirEffect(550,100)
			boss.m_nSkillStep = 3
		elseif boss.m_nSkillStep == 3 then
			return self:isShowSpecialEffectDone()
		end
	end
	
	return false
end


--@brief	显示受伤动画
--@param	standAnim:站立动画,可赋空
--@param	hurtAnim:受伤动画,可赋空
--@return 	#1:true,动画结束，false,动画还在进行中
function TeachBoss:showHurt()
	if not self.m_bIsHurt then
		return true
	end

	local standAnim = "stand"
	local hurtAnim = "injured"

	--是否可以开始播放受伤动画
	if standAnim ~= nil and hurtAnim ~= nil then
		if not self:getAnimation():isPlaying(standAnim) and not self:getAnimation():isPlaying(hurtAnim) then
			return false
		end
	end

	--开始受伤
	if #self:getHurtValueList() > 0 then
		self:_addHurtValue()
		self:_setRemainHP()
		if hurtAnim ~= nil then
			self:getAnimation():play(hurtAnim,2)
		end
		self:clearHurtValueList()
		return false
	end

	--等待受伤数字消失
	if not self:_isHurtNumAnimEnd() then
		return false
	end

	--受伤动画是否播放完毕
	if hurtAnim ~= nil then
		if self:getAnimation():isPlaying(hurtAnim) and self:getAnimation():isCurrentAnimationDone() then
			if standAnim~=nil then
				self:getAnimation():play(standAnim, true)
			end
			return false
		end
	end


	self.m_bIsHurt = false
	return true
end

--@brief	标记显示受伤
--@param	nHurtValue:受伤的值
function TeachBoss:markHurt(nHurtValue)
	self.m_bIsHurt = true
	self.m_nFlyingNum = 0
	if not self.m_tHurtValue then
		self.m_tHurtValue = {}
	end
	table.insert(self.m_tHurtValue, nHurtValue)
end


--@brief	获得受伤值
function TeachBoss:getHurtValueList()
	return self.m_tHurtValue
end

--@brief	清空伤害数字
function TeachBoss:clearHurtValueList()
	self.m_tHurtValue = {}
end

--@brief	从前面移除受伤值
function TeachBoss:popFrontHurtValue()
	if #self.m_tHurtValue >= 1 then
		table.remove(self.m_tHurtValue,1)
	end
end

--@brief	设置伤害标记
--@param	bIsHurt：true：受伤，false：不受伤
function TeachBoss:setMarkHurt(bIsHurt)
	self.m_bIsHurt = bIsHurt
end

--@brief	获得伤害标记
--@param	bIsHurt：true：受伤，false：不受伤
function TeachBoss:getMarkHurt()
	return self.m_bIsHurt
end

--@brief	以本表为模版，WCharacter表为父表创建一个新的表实例对象
--@return	新建的表实例对象
function TeachBoss:new()
	local tNewObj = {}
	setmetatable(tNewObj, {__index = TeachBoss})
	return tNewObj
end

-------------------------------------私有方法模块--------------------------------------

--@brief	添加受伤的数字
function TeachBoss:_addHurtValue()
	local vPos = self:getAnimation():getPosition()
	for i,value in pairs(self.m_tHurtValue) do
		self.m_nFlyingNum = self.m_nFlyingNum + 1

		local minus = WZUIImage:create()
		minus:setFile("common/num/battle_hud_hit_normal.png")
		minus:setUseOriginSize(true)
		minus:setAnchorPoint(GlobalMethod:ccp(1,0.5))

		local hurtValue = WZUILabelAtlasFont:create()
		hurtValue:setCharMapFileName("common/num/battle_hud_hit_normal_num.png")
		hurtValue:setWidth(22)
		hurtValue:setHeight(27)
		hurtValue:setText(value)
		hurtValue:setUseOriginSize(true)
		hurtValue:setAnchorPoint(GlobalMethod:ccp(0,0.5))

		local pos = {x=vPos.x + math.random(50) - 25,y=vPos.y + 12}
		local conHurt = WZUIContainer:create()
		conHurt:setUseAbsSize(true)
		conHurt:setUseAbsCoordinate(true)
		conHurt:addChild(hurtValue)
		conHurt:addChild(minus)
		conHurt:setAbsPosition(GlobalMethod:ccp(pos.x,pos.y))

		local fadeOutA = WZUIActionContainerFadeFromTo:create()
		fadeOutA:setOpacityFrom(255)
		fadeOutA:setOpacityTo(0)
		fadeOutA:setDuration(2)

		local moveTo = WZUIActionMoveTo:create()
		moveTo:setMoveX( (pos.x) / SceneTeachBattle:getFrontLayer():getContentSize().width)
		moveTo:setMoveY((pos.y + 50 ) / SceneTeachBattle:getFrontLayer():getContentSize().height)
		moveTo:setDuration(2)

		local spawn = WZUIActionSpawn:create()
		spawn:setFinishLuaTable(self)
		spawn:setFinishLuaFunction("_finishFlyingNum")
		spawn:setChildAction(fadeOutA)
		spawn:setChildAction(moveTo)

		SceneTeachBattle:getFrontLayer():addChild(conHurt)
		conHurt:runUIAction(spawn)
	end
end

--@brief	根据hurtlist设置剩余hp
function TeachBoss:_setRemainHP()
	local remainHP = self:getHp()
	for i,value in pairs(self.m_tHurtValue) do
		remainHP = remainHP - value
	end
	if remainHP < 0 then
		remainHP = 0
	end
	self:setHp(remainHP)
end

--@brief	判断受伤数字是否结束
--@return	#1:true,false
function TeachBoss:_isHurtNumAnimEnd()
	return self.m_nFlyingNum <= 0 or self.m_nFlyingNum == nil
end

--@brief	伤害数字显示完成的回调
function TeachBoss:_finishFlyingNum(element)
	element:removeFromParentAndCleanup(true)
	if self.m_nFlyingNum >= 1 then
		self.m_nFlyingNum = self.m_nFlyingNum - 1
	end
end