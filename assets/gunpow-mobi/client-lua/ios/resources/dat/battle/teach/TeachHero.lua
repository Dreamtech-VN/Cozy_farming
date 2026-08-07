--TeachHero.lua
--@brief	教学角色数据表
--@date		2013/2/25
--@author	Zjh
--@note		角色相关属性及操作


--@brief	角色数据表
TeachHero = {

	--@brief 基本动态属性
	m_nHP = 0, 							--生命值
	m_nSP = 0, 							--怒气值
	m_nPF = 0, 							--体力
	
	m_sPlayerName = "", 				--角色名称

	--@brief 道具技能状态相关
	m_bUseBigSkill = false, 			--是否使用大招

	--@brief 界面控制属性
	m_mover = nil, 						--移动控制对象
	m_anim = nil,					 	--动画控制对象
	m_angerAnim = nil,					--怒气动画
	m_shopAnim = nil, 					--商城形象

	--@brief 子弹相关
	m_nWeaponType = nil,				--武器类型
	m_sWeaponName = nil,				--武器名字
	
	m_nBigSkillType	= nil,
	
	m_nPlayerId = nil,

	m_nAttack = nil,					--攻击力
	m_nAttTimes = 1,					--攻击次数,正常为1
	m_nAttScatterNum = 1,				--散射子弹数,正常为1
	
	--@brief 伤害相关
	m_bIsHurt = nil,					--标记受伤状态
	m_nFlyingNum = nil,					--正在飘的数字数量
	m_tHurtValue = nil,					--受伤数据表
}

-------------------------------------公有方法模块--------------------------------------

--@brief	生成一个角色
--@param	tStrList:动画穿着描述表
--@param	nBoyOrGirl:男还是女，1:男，0:女
--@param	nWeaponType:攻击方式， 0:投掷 1:射击
--@return	#1:角色数据表
function TeachHero:buildHero(tStrList, nBoyOrGirl, nWeaponType)
	local hero = TeachHero:new()

	hero.m_mover = WDMover:create()
	hero.m_mover:retain()

	local center = Vector2:create(0,20)
	hero.m_mover:setMoverCenter(center)
	hero.m_mover:setMoverRadius(10)
    hero.m_nBoyOrGirl = nBoyOrGirl

	if nBoyOrGirl == 0 then
		hero.m_anim = BattleAnimation:createAnimation(IWCO_BATTLEBOY)
	else
		hero.m_anim = BattleAnimation:createAnimation(IWCO_BATTLEGIRL)
	end
	--hero.m_anim:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0))
	--hero.m_anim:getAnimNode():setIsShowAchorPoint(true)
	hero.m_anim:getAnimNode():retain()
	hero.m_anim:addAnimation("standby1",tStrList, 0.2, false)
	hero.m_anim:addAnimation("standby2",tStrList, 0.2, false)
	hero.m_anim:addAnimation("standby3",tStrList, 0.2, false)
	hero.m_anim:addAnimation("itemskill",tStrList, 0.2, false)
	hero.m_anim:addAnimation("move",tStrList, 0.1, false)

	if nWeaponType == 0 then
		hero.m_anim:addAnimation("attackstart1-t",tStrList, 0.1, false)
		hero.m_anim:addAnimation("attackstart1-t2",tStrList, 0.1, false)
		hero.m_anim:addAnimation("attack1-t",tStrList, 0.1, false)

		hero.m_anim:addAnimation("attackstart2-t",tStrList, 0.1, false)
		hero.m_anim:addAnimation("attackstart2-t2",tStrList, 0.1, false)
		hero.m_anim:addAnimation("attack2-t",tStrList, 0.1, false)
	else
		hero.m_anim:addAnimation("attackstart1-s",tStrList, 0.1, false)
		hero.m_anim:addAnimation("attackstart1-s2",tStrList, 0.1, false)
		hero.m_anim:addAnimation("attack1-s",tStrList, 0.1, false)

		hero.m_anim:addAnimation("attackstart2-s",tStrList, 0.1, false)
		hero.m_anim:addAnimation("attackstart2-s2",tStrList, 0.1, false)
		hero.m_anim:addAnimation("attack2-s",tStrList, 0.1, false)
	end

	if tStrList["wing"] == nil then
		tStrList["effects"] = "fly1"
	end
	hero.m_anim:addAnimation("fly",tStrList, 0.1, false)
	tStrList["effects"] = nil

	hero.m_anim:addAnimation("injured",tStrList, 0.2, true,IWCO_BATTLEEFFECT)
	
	local tShopList = CopyTable(tStrList)
	--商城形象
	if nBoyOrGirl == 0 then
		hero.m_shopAnim = BattleAnimation:createAnimation(IWCO_SHOPBOY)
	else
		hero.m_shopAnim = BattleAnimation:createAnimation(IWCO_SHOPGIRL)
	end
	hero.m_shopAnim:getAnimNode():retain()
	hero.m_shopAnim:addAnimation("room",tShopList, 0.2, false)
	tShopList.bface = "bface"
	hero.m_shopAnim:addAnimation("lose",tShopList, 0.2, false)
	hero.m_shopAnim:playTimes("room",0)

    --子弹
	hero.m_nWeaponType = nWeaponType
	hero.m_sWeaponName = tStrList.weapon

	local sExplode = tStrList.weapon
	sExplode = string.format("%sb",string.sub(sExplode,0,sExplode:len()-1))
	sExplode = RESOURCE_BULLET_EXPLODE..sExplode..".png"
	hero.m_bulletCilcle = BattleUtil:getCircleImg(sExplode)
	hero.m_bulletCilcle:retain()
    
    hero.m_fRadiusForBulletCollision = hero.m_anim:getAnimNode():getContentSize().width * 0.4
        hero.m_fRadiusForHurt = hero.m_anim:getAnimNode():getContentSize().width * 0.65

	return hero
end

--@brief	定时更新函数
--@param	dt:距离上一次调用的时间（秒）
--@note		由定时器调用
function TeachHero:update(dt)
	if self:getMarkHurt() then
		self:showHurt()
	end
	
	if self:getAnimation():isPlaying("standby1") == false then
		if self:getAnimation():isCurrentAnimationDone() == true then
			self:getAnimation():play("standby1", true)
		end
	end
	
    self:updateFaceAnimation()
end

--@brief	销毁一个角色
function TeachHero:destroy()

	self.m_shopAnim:getAnimNode():release()
	self.m_shopAnim = nil
	self.m_anim:getAnimNode():release()
	self.m_anim = nil
	self.m_mover:release()
    
    self.m_bulletCilcle:release()
	self.m_bulletCilcle = nil

end

--@brief 	设置人物名称
--@param 	name:人物名称
function TeachHero:setPlayerName(name)
	self.m_sPlayerName = name
end

--@brief 	获得人物名称
--@return 	#1, 返回人物名称
function TeachHero:getPlayerName()
	return self.m_sPlayerName
end

--@brief	获取商城动画控制对象
--@return	#1:Animation动画控制对象
function TeachHero:getShopAnimation()
	return self.m_shopAnim:getAnimNode()
end

--@brief	获取攻击力
--@return	#1:攻击力
function TeachHero:getAttack()
	return self.m_nAttack
end

--@brief	获取攻击力
--@param	nAttack:攻击力
function TeachHero:setAttack(nAttack)
	self.m_nAttack = nAttack
end

--@brief	获取大招类型
--@return	#1:大招类型
function TeachHero:getBigSkillType()
	return self.m_nBigSkillType
end

--@brief	获取英雄id
--@return	#1:武器类型
function TeachHero:getId()
	return self.m_nPlayerId
end

--@brief	获取武器类型
--@return	#1:武器类型
function TeachHero:getWeaponType()
	return self.m_nWeaponType
end

--@brief	获取武器名字
--@return	#1:武器名字
function TeachHero:getWeaponName()
	return self.m_sWeaponName
end

--@brief	获取移动控制对象
--@return	#1:WDMove移动控制对象
function TeachHero:getMover()
	return self.m_mover
end

--@brief	添加怒气动画
function TeachHero:addAngerAnimation()
	if self.m_angerAnim == nil then
		self.m_angerAnim = BattleAnimation:createAnimation(IWCO_BATTLEEFFECT)
		self.m_angerAnim:addAnimation("anger1",{},0.1,true)
		self.m_angerAnim:play("anger1",true)
		local anchor = self:getAnimation():getAnimNode():getAnchorPoint()
		local size = self:getAnimation():getAnimNode():getContentSize()
		local heroCenter = CCPointMake(anchor.x*size.width,anchor.y*size.height)
		self.m_angerAnim:getAnimNode():setPosition(GlobalMethod:ccp(heroCenter.x + 10,heroCenter.y + 10))
		self.m_angerAnim:setZOrder(-1)
		self.m_anim:getAnimNode():addChild(self.m_angerAnim:getAnimNode())
	end
end

--@brief	移除怒气动画
function TeachHero:removeAngerAnimation()
	if self.m_angerAnim ~= nil then
		self.m_angerAnim:getAnimNode():removeFromParentAndCleanup(true)
		self.m_angerAnim = nil
	end
end

--@brief	获取动画控制对象
--@return	#1:BattleAnimation动画控制对象
function TeachHero:getAnimation()
	return self.m_anim
end

--@brief 	获得英雄当前的位置
--@return 	#1, 返回当前的位置
function TeachHero:getPosition()
	return self.m_anim:getPosition()
end

--@brief 	设置人物当前的位置
--@param 	tPos 当前位置
function TeachHero:setPosition(tPos)
	self.m_mover:setMoverPosition(Vector2:create(tPos.x,tPos.y))
	self.m_anim:setPosition(Vector2:create(tPos.x,tPos.y))
end

--@brief 	获得人物最大血量
--@return 	#1,人物最大血量
function TeachHero:getMaxHp()
	return self.m_nMaxHP
end

--@brief 	获得人物当前血量
--@return 	#1,人物当前血量
function TeachHero:getHp()
	return self.m_nHP
end

--@brief 	获得人物最大体力
--@return 	#1,人物最大体力
function TeachHero:getMaxPF()
	return self.m_nMaxPF
end

--@brief 	获得人物当前体力
--@return 	#1,人物当前体力
function TeachHero:getPF()
	return self.m_nPF
end

--@brief 	获得怒气
--@return 	当前怒气
function TeachHero:getSp()
	return self.m_nSP
end

--@brief 	设置血量
--@param 	nHp 当前血量
function TeachHero:setHp(nHp)
	self.m_nHP = nHp
	WndTeachBattleHud:updatePlayerHP(self:getId())
end

--@brief 	设置怒气
--@param 	nSp 当前怒气
function TeachHero:setSp(nSp)
	self.m_nSP = nSp
	WndTeachBattleHud:updatePlayerSp(self:getId())
	if nSp >= 100 then
		self:addAngerAnimation()
	else
		self:removeAngerAnimation()
	end
end

--@brief 	设置体力
--@param 	nPF 当前体力
function TeachHero:setPF(nPF)
	self.m_nPF = nPF
	WndTeachBattleHud:updatePlayerPF(self:getId())
end

--@brief 	设置英雄是否用大招
--@param 	bUseBigSkill 是否使用大招
function TeachHero:setUseBigSkill(bUseBigSkill)
	self.m_bUseBigSkill = bUseBigSkill
end

--@brief 	判断英雄是否用大招
--@return 	英雄是否使用大招
function TeachHero:getUseBigSkill()
	return self.m_bUseBigSkill
end

--@brief	经过一回合后的英雄状态和属性更新
function TeachHero:updateByTurn()
	--大招状态重置
	self:setUseBigSkill(false)
	--更新体力
	self:setPF(self:getMaxPF())

	self:setAttTimes(1)
	self:setAttScatterNum(1)
end


--@brief	设置攻击次数
--@param	nAttTimes,攻击次数
function TeachHero:setAttTimes(nAttTimes)
	self.m_nAttTimes = nAttTimes
end

--@brief	获取攻击次数
--@return	攻击次数
function TeachHero:getAttTimes()
	return self.m_nAttTimes
end

--@brief	设置散射子弹数
--@param	nAttScatterNum,散射子弹数
function TeachHero:setAttScatterNum(nAttScatterNum)
	self.m_nAttScatterNum = nAttScatterNum
end

--@brief	获取散射子弹数
--@return	散射子弹数
function TeachHero:getAttScatterNum()
	return self.m_nAttScatterNum
end


--@brief 		播放准备射击动画
function TeachHero:playReadyShootAnim()
	if self:getUseBigSkill() then
		if self.m_nWeaponType == 0 then
			self:getAnimation():play("attackstart2-t",false)
		else
			self:getAnimation():play("attackstart2-s",false)
		end
	else
		if self.m_nWeaponType == 0 then
			self:getAnimation():play("attackstart1-t",false)
		else
			self:getAnimation():play("attackstart1-s",false)
		end
	end
end

--@brief 	播放正在射击动画
--@param	repeatTimes:重复次数(nil,0:不重复)
function TeachHero:playRepeatShootAnim(RepeatTimes)
	repeatTimes = repeatTimes or 0
	if self:getUseBigSkill() then
		if self.m_nWeaponType == 0 then
			self:getAnimation():playTimes("attackstart2-t2",RepeatTimes)
		else
			self:getAnimation():playTimes("attackstart2-s2",RepeatTimes)
		end
	else
		if self.m_nWeaponType == 0 then
			self:getAnimation():playTimes("attackstart1-t2",RepeatTimes)
		else
			self:getAnimation():playTimes("attackstart1-s2",RepeatTimes)
		end
	end
end

--@brief 	播放射击完毕动画
function TeachHero:playEndShootAnim()
	if self:getUseBigSkill() then
		if self.m_nWeaponType == 0 then
			self:getAnimation():play("attack2-t",false)
		else
			self:getAnimation():play("attack2-s",false)
		end
	else
		if self.m_nWeaponType == 0 then
			self:getAnimation():play("attack1-t",false)
		else
			self:getAnimation():play("attack1-s",false)
		end
	end
end

--@brief	检测飞行碰撞
function TeachHero:checkCollisionInFly()
	--WZLog("TeachHero:checkCollisionInFly", self:getMover():getMoverSpeed().x, self:getMover():getMoverSpeed().y)
	local vec2 = Vector2:create(self:getMover():getMoverAcceleration().x,self:getMover():getMoverAcceleration().y+BattleConstants.g_nFlyGravity.y)
	self:getMover():setMoverAcceleration(vec2)
	local bIsCollision = self:move()
	vec2 = Vector2:create(self:getMover():getMoverAcceleration().x,self:getMover():getMoverAcceleration().y-BattleConstants.g_nFlyGravity.y)
	self:getMover():setMoverAcceleration(vec2)
	--WZLog("TeachHero:checkCollisionInFly2", self:getMover():getMoverSpeed().x, self:getMover():getMoverSpeed().y)
	return bIsCollision
end

--@brief	移动角色
--@param	nSpeedX:X速度
--@param	nSpeedY:Y速度
--@param	nAccX:X加速度
--@param	nAccY:Y加速度
--@return	#1:移动过程中是否与地图发生碰撞
function TeachHero:move(tSpeed, tAcceleration)
	--WZLog("WHero:move")
	--设置初始速度及加速度
	if tSpeed ~= nil then
		--WZLog("WHero:move speed", tSpeed.x,tSpeed.y)
		self.m_mover:setMoverSpeed(Vector2:create(tSpeed.x,tSpeed.y))
	end
	if tAcceleration ~= nil then
		--WZLog("WHero:move acceleration", tAcceleration.x,tAcceleration.y)
		self.m_mover:setMoverAcceleration(Vector2:create(tAcceleration.x,tAcceleration.y))
	end

	--WZLog("WHero:move updatePostion", self.m_mover:getMoverAcceleration().x, self.m_mover:getMoverAcceleration().y)
	--更新角色位置
	self.m_mover:updatePostion()

	--判断碰撞并校正角色位置
	local isCollision,newPos,tangent = BattleMapManager:checkCollision(self.m_mover)
	if isCollision == true then
		self.m_mover:setMoverPosition(newPos)
		self.m_mover:setMoverRotate(BattleCommon:pointToAngle(tangent))
		self.m_mover:setMoverSpeed(Vector2:create(0,0))
	end

	--将位置信息同步到角色动画
	local posX,posY = self.m_anim:getAnimNode():getPosition()
	if BattleCommon:pointDis(self.m_mover:getMoverPosition(),{x = posX,y = posY}) > 1 then
		local vec2 = self.m_mover:getMoverPosition()
		self:setPosition(vec2)
		self.m_anim:getAnimNode():setRotation(BattleCommon:radiansToDegress(self.m_mover:getMoverRotate()))
	end

	return isCollision
end

--@brief	显示受伤动画
--@param	standAnim:站立动画,可赋空
--@param	hurtAnim:受伤动画,可赋空
--@return 	#1:true,动画结束，false,动画还在进行中
function TeachHero:showHurt()
	if not self.m_bIsHurt then
		return true
	end

	local standAnim = "standby1"
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
function TeachHero:markHurt(nHurtValue)
	self.m_bIsHurt = true
	self.m_nFlyingNum = 0
	if not self.m_tHurtValue then
		self.m_tHurtValue = {}
	end
	table.insert(self.m_tHurtValue, nHurtValue)
end


--@brief	获得受伤值
function TeachHero:getHurtValueList()
	return self.m_tHurtValue
end

--@brief	清空伤害数字
function TeachHero:clearHurtValueList()
	self.m_tHurtValue = {}
end

--@brief	从前面移除受伤值
function TeachHero:popFrontHurtValue()
	if #self.m_tHurtValue >= 1 then
		table.remove(self.m_tHurtValue,1)
	end
end

--@brief	设置伤害标记
--@param	bIsHurt：true：受伤，false：不受伤
function TeachHero:setMarkHurt(bIsHurt)
	self.m_bIsHurt = bIsHurt
end

--@brief	获得伤害标记
--@param	bIsHurt：true：受伤，false：不受伤
function TeachHero:getMarkHurt()
	return self.m_bIsHurt
end

--@brief	播放表情动画
--@param	nFaceId:表情Id
function TeachHero:playFaceAnimation(nFaceId)
    if nFaceId == -1 then
        return
    end
    if nFaceId == 23 then
        nFaceId = 25
    end

	if self.m_faceAnim then
		self.m_faceAnim:getAnimNode():removeFromParentAndCleanup(true)
		self.m_faceAnim = nil
	end

	self.m_faceAnim = BattleAnimation:createAnimation(IWCO_BATTLEFACE)
	self.m_faceAnim:addAnimation("face"..nFaceId,{}, 0.2, true)
	self.m_faceAnim:play("face"..nFaceId,true)

	self:updateFaceAnimation()

	local node = self.m_faceAnim:getAnimNode()
	SceneTeachBattle:getInfoLayer():addChild(node)

	node:setScale(0.2)
	node:setTag(self:getId())
	local act1=CCScaleTo:create(0.2,1)
    local act2=CCDelayTime:create(2.1)
	local act3=CCScaleTo:create(0.2,0.2)
	local act4=CCCallFuncN:create(_playFaceAnimationEnd_TeachHero)
	local array = CCArray:create()
	array:addObject(act1)
	array:addObject(act2)
	array:addObject(act3)
    array:addObject(act4)
	node:runAction(CCSequence:create(array))
end

--@brief	更新表情动画位置
--@note
function TeachHero:updateFaceAnimation()
	if self.m_faceAnim then
		local heroPos = self:getAnimation():getPosition()

        if self.m_tFacePosOffset == nil then
            self.m_tFacePosOffset = GlobalMethod:ccp(0,0)
        end

        local pos = self.m_tFacePosOffset

		local point = SceneTeachBattle:getFrontLayer():convertToWorldSpace(GlobalMethod:ccp(heroPos.x - 50 + pos.x,heroPos.y + 100 + pos.y))

		local size = self.m_faceAnim:getAnimNode():getContentSize()

        WZLog("TeachHero:updateFaceAnimation one", pos.x, pos.y, point.x, point.y, size.width, size.height)
		if point.x < size.width/2 then
			point.x = size.width/2
            WZLog("TeachHero:updateFaceAnimation two", point.x, point.y)
		end
		if point.x > 960 - size.width/2 then
			point.x = 960 - size.width/2
            WZLog("TeachHero:updateFaceAnimation three", point.x, point.y)
		end
		if point.y < size.height/2 then
			point.y = size.height/2
            WZLog("TeachHero:updateFaceAnimation four", point.x, point.y)
		end
		if point.y > 640 - size.height/2 then
			point.y = 640 - size.height/2
            WZLog("TeachHero:updateFaceAnimation five", point.x, point.y)
		end

		point = SceneTeachBattle:getInfoLayer():convertToNodeSpace(point)

		self.m_faceAnim:setPosition(GlobalMethod:ccp(point.x,point.y))
	end
end

--@brief	播放表情动画结束回调
--@param	sender:动画对象
--@note		原生回调只能回调全局函数，暂用
function _playFaceAnimationEnd_TeachHero(sender)
	local hero = TeachBattle.m_tMyHero
	if hero and hero.m_faceAnim then
		hero.m_faceAnim:getAnimNode():removeFromParentAndCleanup(true)
		hero.m_faceAnim = nil
        hero.m_tFacePosOffset = GlobalMethod:ccp(0,0)
	end
end

--@brief	获取子弹爆破
--@return	#1:子弹爆破
function TeachHero:getBulletCilcle()
	return self.m_bulletCilcle
end

--@brief	获取形象
--@return	#1:形象
function TeachHero:getIcon()
    WZLog("TeachHero:getIcon", self.m_nBoyOrGirl)
    if self.m_nBoyOrGirl == 0 then
        return "boy_01"
    else
        return "girl_01"
    end
end

--@brief	以本表为模版，TeachHero表为父表创建一个新的表实例对象
--@return	新建的表实例对象
function TeachHero:new()
    --[[
	local tNewObj = {}
	setmetatable(tNewObj, {__index = TeachHero})
	return tNewObj
    --]]
    
    setmetatable(TeachHero,{__index = WCharacter})
	local tNewObj = {}
	setmetatable(tNewObj, {__index = TeachHero})
	tNewObj:setType(CharacterType.TYPE_HERO)
	tNewObj:_init()
	return tNewObj
end
-------------------------------------私有方法模块--------------------------------------

--@brief	添加受伤的数字
function TeachHero:_addHurtValue()
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
function TeachHero:_setRemainHP()
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
function TeachHero:_isHurtNumAnimEnd()
	return self.m_nFlyingNum <= 0 or self.m_nFlyingNum == nil
end

--@brief	伤害数字显示完成的回调
function TeachHero:_finishFlyingNum(element)
	element:removeFromParentAndCleanup(true)
	if self.m_nFlyingNum >= 1 then
		self.m_nFlyingNum = self.m_nFlyingNum - 1
	end
end
