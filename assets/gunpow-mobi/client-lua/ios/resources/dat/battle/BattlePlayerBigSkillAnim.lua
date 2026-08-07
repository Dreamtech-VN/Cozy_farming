--BattlePlayerBigSkillAnim.lua
--@brief	玩家大招动画功能
--@date		2013/2/17
--@author	Zjh
--@note

BattlePlayerBigSkillAnim = {
	m_tHero = nil,
	m_bigSkillContainer = nil,	--大招容器
	m_psq = nil,		--粒子容器
	m_tAnims = nil,		--存放正在播放的动画
	TOTAL_STEP = 4,		--总共的步骤数
	m_nShowTime = nil,	--动画播放的时间

	m_tHasShow = nil,	--索引对应该步骤的动画是否已经播放/播过，没有为nil
	m_nStep = nil,		--已完成的步骤数

	m_bIsTeach = nil,   --是否是教学
	m_bIsBoss = nil,   --是否是boss
	m_bIsFlip = nil,
	m_tOffset = nil,

	m_nOriginScale = nil,
}

-------------------------------------公有方法模块--------------------------------------

--@brief	获取SceneBattle
--@return	tBattle: SceneBattle
function BattlePlayerBigSkillAnim:getBattle()
	if SceneBattle.m_root then
		return SceneBattle
	elseif SceneTeachBattle.m_root then
		return SceneTeachBattle
	end
	return SceneBattle
end

--@brief	初始化函数
--@param	tHero,玩家WHero
--@note
function BattlePlayerBigSkillAnim:readyShow(tHero, isTeach, isBoss, isFlip, offset)
	WZLog("BattlePlayerBigSkillAnim:readyShow")
    self.m_bIsTeach = isTeach
    self.m_bIsBoss = isBoss
    self.m_bIsFlip = isFlip
    self.m_tOffset = offset or {x=0,y=0}
	self.m_tHero = tHero

	self.m_bigSkillContainer = WZUIContainer:create()

	local bg = WZUIImage:create()
	bg:setFile("ui/common/common_black_bg.png")
	bg:setOpacity(0)
	bg:setScale(2)
	self.m_bigSkillContainer:addChild(bg)

	BattlePlayerBigSkillAnim:getBattle():getTopInfoLayer():addChild(self.m_bigSkillContainer)
	self.m_bigSkillContainer:setZOrder(10)

	local actionFadeTo = WZUIActionFadeTo:create()
	actionFadeTo:setOpacity(190)
	actionFadeTo:setDuration(1.3)

	bg:runUIAction(actionFadeTo)

	self.m_tAnims = {}

	self.m_nShowTime = 0

	self.m_tHasShow = {}

	self.m_nStep = 0

	self.m_nOriginScale = BattlePlayerBigSkillAnim:getBattle():getFrontLayer():getScale()

	SoundManager:playEffectSound(SoundDefine.E_S_BIGSKILL)
end

--@brief	处理过程函数
--@return	#1,nil或true表示处理结束，否则返回false
--@note		未处理结束的process函数需要再次被调用，直到处理结束
function BattlePlayerBigSkillAnim:process()
	--WZLog("BattlePlayerBigSkillAnim:process")

	if self.m_nStep >= BattlePlayerBigSkillAnim.TOTAL_STEP then
		if self.m_bigSkillContainer then
			self.m_bigSkillContainer:removeFromParentAndCleanup(true)
			self.m_bigSkillContainer = nil

			if self.m_tHero.m_nBoyOrGirl == 0 then
				SoundManager:playEffectSound(getSoundByType(12))
			else
				SoundManager:playEffectSound(getSoundByType(7))
			end
		end
		local heroPos = self.m_tHero:getAnimation():getPosition()
		return BattleMapManager:getFrontControl():zoomToScaleAndPointQuickly(self.m_nOriginScale,heroPos)
		--return true
	end
	if #self.m_tAnims > 0 then
		for i = #self.m_tAnims,1,-1 do
			if self.m_tAnims[i]:isCurrentAnimationDone() then
				self:_cleanPsq()
				self.m_tAnims[i]:getAnimNode():removeFromParentAndCleanup(true)
				table.remove(self.m_tAnims,i)
				self.m_nStep = self.m_nStep + 1
			end
		end
		self.m_nShowTime = self.m_nShowTime + BattlePlayerBigSkillAnim:getBattle():getBattleLoop():getBattleDeltaTime()
		if self.m_nShowTime > 0.5 and self.m_tHasShow[2]==nil then

			self:_cleanPsq()
			self:_addStep(2)

		elseif self.m_nShowTime > 0.5 + 0.4 and self.m_tHasShow[3]==nil then

			self:_addStep(3)
		end
	else
		local step = self.m_nStep + 1
		self:_addStep(step)
	end

	if self.m_nStep < 1 then
		local heroPos = self.m_tHero:getAnimation():getPosition()
		BattleMapManager:getFrontControl():zoomToScaleAndPointQuickly(BattleMapManager:getFrontControl():getZoomInInit(),heroPos)
		self:_adjustStep1()
	end

	return false
end

-------------------------------------私有方法模块--------------------------------------
--@brief	创建步骤操作
--@param	nStep,步骤
function BattlePlayerBigSkillAnim:_addStep(nStep)
	if nStep == 1 then
		self:_step1()
		self:_addPsq()
		self.m_tHasShow[1] = true
	elseif nStep == 2 then
		self:_step2()
		self.m_tHasShow[2] = true
	elseif nStep == 3 then
		self:_step3()
		self:_addBigHead()
		self:_step4()
		self.m_tHasShow[3] = true
		self.m_tHasShow[4] = true
	end
end

function BattlePlayerBigSkillAnim:_adjustStep1()

	if self.m_psq then
		local hero = self.m_tHero

		local heroPos = hero:getAnimation():getPosition()

		local point = BattlePlayerBigSkillAnim:getBattle():getFrontLayer():convertToWorldSpaceAuto(CCAutoPoint:create(heroPos.x,heroPos.y))

		point = BattlePlayerBigSkillAnim:getBattle():getTopInfoLayer():convertToNodeSpaceAuto(point)

		if self.m_tAnims[1] then
			self.m_tAnims[1]:getAnimNode():setRelativePosition(GlobalMethod:ccp( (point.x - 30) /960 , (point.y-40) /640 ))
		end

		self.m_psq:setRelativePosition(GlobalMethod:ccp( (point.x - 0) /960 , (point.y-0) /640 ))
	end
end


--@brief	动画步骤1
--@note		闪电动画 + 蓄气粒子
function BattlePlayerBigSkillAnim:_step1()
	--local hero = self.m_tHero

	--local heroPos = hero:getAnimation():getPosition()

	--local point = BattlePlayerBigSkillAnim:getBattle():getFrontLayer():convertToWorldSpaceAuto(CCAutoPoint:create(heroPos.x,heroPos.y))

	--point = BattlePlayerBigSkillAnim:getBattle():getTopInfoLayer():convertToNodeSpaceAuto(point)

	local anim
	anim = BattleAnimation:createAnimation("kill01",true)
	--anim:getAnimNode():setRelativePosition(GlobalMethod:ccp( (point.x - 30) /960 , (point.y-40) /640 ))
	anim:getAnimNode():setUseOriginSize(true)
	self.m_bigSkillContainer:addChild(anim:getAnimNode())
	anim:play("0",false)
	anim:getAnimNode():setTag(1)

	table.insert(self.m_tAnims,1,anim)

end

--@brief	增加蓄气粒子
function BattlePlayerBigSkillAnim:_addPsq()

	--local hero = self.m_tHero

	--local heroPos = hero:getAnimation():getPosition()

	--local point = BattlePlayerBigSkillAnim:getBattle():getFrontLayer():convertToWorldSpaceAuto(CCAutoPoint:create(heroPos.x,heroPos.y))

	--point = BattlePlayerBigSkillAnim:getBattle():getTopInfoLayer():convertToNodeSpaceAuto(point)

	self.m_psq = WZUISystem:getInstance():createElement("con_specialattackeffect")
	self.m_psq:setScale(0.7)
	--self.m_psq:setRelativePosition(GlobalMethod:ccp( (point.x - 0) /960 , (point.y-0) /640 ))
	self.m_bigSkillContainer:addChild(self.m_psq)

end

--@brief	动画步骤2
--@note
function BattlePlayerBigSkillAnim:_step2()

	local anim = BattleAnimation:createAnimation("kill02",true)
	anim:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.5,-0.2))
	anim:getAnimNode():setUseOriginSize(true)
	self.m_bigSkillContainer:addChild(anim:getAnimNode())
	anim:play("0",false)
	anim:getAnimNode():setTag(2)

	table.insert(self.m_tAnims,1,anim)
end

--@brief	动画步骤3
--@note
function BattlePlayerBigSkillAnim:_step3()

	local anim = BattleAnimation:createAnimation("kill03",true)
	anim:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.3,0.4))
	anim:getAnimNode():setUseOriginSize(true)
	self.m_bigSkillContainer:addChild(anim:getAnimNode())
	anim:play("0",false)
	anim:getAnimNode():setTag(3)

	table.insert(self.m_tAnims,1,anim)
end

--@brief	增加人物大头
--@note
function BattlePlayerBigSkillAnim:_addBigHead()
    WZLog("BattlePlayerBigSkillAnim:_addBigHead one")
    local isAniForShop = true
    if self.m_bIsTeach == true or self.m_bIsBoss == true then
        isAniForShop = false
    end
    local scissorCon = WZUIScissorContainer:create()
	local hero = self.m_tHero
    local heroAnim
    local isOldAnim = true
    if isAniForShop == true then
        heroAnim = AnimationManager:createRoleForShop(hero.m_nBoyOrGirl,hero.m_tPlayerBodyInfo,"room")
    elseif self.m_bIsTeach == true then
        heroAnim = hero:getShopAnimation()
    elseif self.m_bIsBoss == true then
        heroAnim, isOldAnim = hero:createShopAnimation(self.m_bIsFlip)
    end


	self.m_bigSkillContainer:addChild(scissorCon)
	scissorCon:setRelativePosition(GlobalMethod:ccp(0.5,0.57))
	local height = 350
	local scale = 2.25
	local y = height/2 - 80 - scale * heroAnim:getContentSize().height/2
	scissorCon:setContentSize(GlobalMethod:CCSize(1136,height))
	heroAnim:setScale(scale)

    if isAniForShop == true then
        heroAnim:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        heroAnim:setRelativePosition(GlobalMethod:ccp(1.0 + self.m_tOffset.x,0.3 + self.m_tOffset.x))
    elseif isOldAnim ~= true then
        heroAnim:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        heroAnim:setRelativePosition(GlobalMethod:ccp(1.0 + self.m_tOffset.x,0.05 + self.m_tOffset.x))
    else
        heroAnim:setPosition( 1.5*1136 + self.m_tOffset.x, y  + self.m_tOffset.y)
    end
	scissorCon:addChild(heroAnim)

    if isAniForShop == true then
        WZLog("BattlePlayerBigSkillAnim:_addBigHead two")
        local moveTo0 = WZUIActionMoveTo:create()
        moveTo0:setMoveX(0.7)
        moveTo0:setMoveY(0.3)
        moveTo0:setDuration(0.25)

        local moveTo1 = WZUIActionMoveTo:create()
        moveTo1:setMoveX(0.5)
        moveTo1:setMoveY(0.3)
        moveTo1:setDuration(0.78)

        local moveTo2 = WZUIActionMoveTo:create()
        moveTo2:setMoveX(-0.5)
        moveTo2:setMoveY(0.3)
        moveTo2:setDuration(0.21)

        local sequence = WZUIActionSequence:create()
        sequence:setChildAction(moveTo0)
        sequence:setChildAction(moveTo1)
        sequence:setChildAction(moveTo2)

        heroAnim:runUIAction(sequence)
    elseif isOldAnim ~= true then
        WZLog("BattlePlayerBigSkillAnim:_addBigHead three", self.m_tOffset.x, self.m_tOffset.y)

        local moveY = 0.05
        local moveTo0 = WZUIActionMoveTo:create()
        moveTo0:setMoveX(0.7)
        moveTo0:setMoveY(moveY)
        moveTo0:setDuration(0.25)

        local moveTo1 = WZUIActionMoveTo:create()
        moveTo1:setMoveX(0.5)
        moveTo1:setMoveY(moveY)
        moveTo1:setDuration(0.78)

        local moveTo2 = WZUIActionMoveTo:create()
        moveTo2:setMoveX(-0.5)
        moveTo2:setMoveY(moveY)
        moveTo2:setDuration(0.21)

        local sequence = WZUIActionSequence:create()
        sequence:setChildAction(moveTo0)
        sequence:setChildAction(moveTo1)
        sequence:setChildAction(moveTo2)

        heroAnim:runUIAction(sequence)
    else
        WZLog("BattlePlayerBigSkillAnim:_addBigHead four")
        local act1=CCMoveTo:create(0.25,GlobalMethod:ccp(0.7*1136,y))
        local act2=CCMoveTo:create(0.78,GlobalMethod:ccp(0.5*1136,y))
        local act3=CCMoveTo:create(0.21,GlobalMethod:ccp(-0.5*1136,y))
        local array = CCArray:create()
        array:addObject(act1)
        array:addObject(act2)
        array:addObject(act3)
        heroAnim:runAction(CCSequence:create(array))
    end
end

--@brief	动画步骤4
--@note
function BattlePlayerBigSkillAnim:_step4()

	local anim = BattleAnimation:createAnimation("kill04",true)
	anim:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.6,0.28))
	anim:getAnimNode():setUseOriginSize(true)
	self.m_bigSkillContainer:addChild(anim:getAnimNode())
	anim:play("0",false)
	anim:getAnimNode():setTag(4)

	table.insert(self.m_tAnims,1,anim)
end

--@brief	清除蓄气粒子
function BattlePlayerBigSkillAnim:_cleanPsq()
	if self.m_psq then
		self.m_psq:removeFromParentAndCleanup(true)
		self.m_psq = nil
	end
end


--------------------------------------------------------------------------
--[[
BattlePlayerBigSkill =
{
	m_tHero = nil,

	m_tStepFunction = nil,		--步骤函数
	m_tStepFunctionTable = nil,	--步骤函数Table

	m_bigSkillContainer = nil,
	m_nOriginScale = nil,

	m_NowAnim = nil,
	m_tempAnim = nil,
	m_bActionDone = nil,
	
	m_nHurtDt = nil,
	m_nHurtTimes = nil,
	
	m_bHurtSuccess = nil
}

function BattlePlayerBigSkill:clear()
	self.m_bigSkillContainer = nil
	self.m_NowAnim = nil
	self.m_tempAnim = nil
	self.m_bActionDone = nil
	self.m_nHurtDt = nil
	self.m_bHurtSuccess = false
end

--@brief	初始化函数
--@note		第一次调用process函数前调用
function BattlePlayerBigSkill:initBigSkill(tHero)
	
	self:clear()
	
	self.m_tHero = tHero
	self.m_nOriginScale = BattlePlayerBigSkillAnim:getBattle():getFrontLayer():getScale()

	self.m_nHurtTimes = 0
	self.m_tStepFunction = {}
	self.m_tStepFunctionTable = {}

	table.insert(self.m_tStepFunction,self._initStep1)
	table.insert(self.m_tStepFunctionTable,self)
	table.insert(self.m_tStepFunction,self._step1)
	table.insert(self.m_tStepFunctionTable,self)
	table.insert(self.m_tStepFunction,self._step11)
	table.insert(self.m_tStepFunctionTable,self)
	table.insert(self.m_tStepFunction,self._step12)
	table.insert(self.m_tStepFunctionTable,self)
	table.insert(self.m_tStepFunction,self._step2)
	table.insert(self.m_tStepFunctionTable,self)
	table.insert(self.m_tStepFunction,self._initStep3)
	table.insert(self.m_tStepFunctionTable,self)
	table.insert(self.m_tStepFunction,self._step3)
	table.insert(self.m_tStepFunctionTable,self)
	table.insert(self.m_tStepFunction,self._waitHurt)
	table.insert(self.m_tStepFunctionTable,self)
	table.insert(self.m_tStepFunction,self._step4)
	table.insert(self.m_tStepFunctionTable,self)
end

--@brief	消息处理过程函数
--@return	#1,nil或true表示消息处理结束，否则返回false
--@note		未处理结束消息的process函数将会再次被调用，直到处理结束
function BattlePlayerBigSkill:process()
	WZLog("BattlePlayerBigSkill:process")
	if #self.m_tStepFunction > 0 then
		local res = self.m_tStepFunction[1](self.m_tStepFunctionTable[1])
		if res == true or res == nil then
			table.remove(self.m_tStepFunction,1)
			table.remove(self.m_tStepFunctionTable,1)
		end
		return false
	else
		return true
	end
end

function BattlePlayerBigSkill:_initStep1()
	self.m_bigSkillContainer = WZUIScissorContainer:create()
	self.m_bigSkillContainer:setRelativeSizeLuaTo(2,480/SceneBattle:getTopInfoLayer():getContentSize().height)
	
	local bg = WZUIImage:create()
	bg:setFile("ui/common/common_black_bg.png")
	self.m_bigSkillContainer:addChild(bg)

	SceneBattle:getTopInfoLayer():addChild(self.m_bigSkillContainer)
	self.m_bigSkillContainer:setZOrder(10)

	local oldAnchor = {x = 0.5, y =0.5}
	local newAnchor = {x = 0.7, y =0.4}
	local oldPos = {x = self.m_bigSkillContainer:getPositionX() ,y = self.m_bigSkillContainer:getPositionY()}
	local newPos = {}
	local childSize = self.m_bigSkillContainer:getContentSize()
	self.m_bigSkillContainer:setAnchorPointLuaTo( newAnchor.x , newAnchor.y )
	newPos.x = oldPos.x + (newAnchor.x - oldAnchor.x)*childSize.width 
	newPos.y = oldPos.y + (newAnchor.y - oldAnchor.y)*childSize.height 
	self.m_bigSkillContainer:setPosition( newPos.x , newPos.y )
	
	local action = WZUIActionMoveTo:create()
    action:setMoveX(0.5)
    action:setMoveY(-0.7)
    action:setDuration(0.2)
	action:setFinishLuaFunction("_actionDone")
	action:setFinishLuaTable(self)
	
	local anim = BattleAnimation:createAnimation("combatboy_skill_dz",true)
	anim:getAnimNode():setUseOriginSize(true)
	self.m_bigSkillContainer:addChild(anim:getAnimNode())
	anim:getAnimNode():setZOrder(5)
	anim:getAnimNode():setRelativePositionLuaTo(-0.1,-0.7)
	anim:getAnimNode():setScale(4)
	anim:getAnimNode():runUIAction(action)
	
	self.m_tempAnim = anim
	self.m_bActionDone = false
end

function BattlePlayerBigSkill:_actionDone(element)
	self.m_bActionDone = true
	
	local delayTime = WZUIActionDelayTime:create()
    delayTime:setDuration(0.6)
	delayTime:setFinishLuaFunction("_delayTimeDone")
	delayTime:setFinishLuaTable(self)
	element:runUIAction(delayTime)
end

function BattlePlayerBigSkill:_delayTimeDone()
	self.m_tempAnim:play("0",false)
	self.m_tempAnim = nil
end

function BattlePlayerBigSkill:_step1()
	return self.m_bActionDone
end

function BattlePlayerBigSkill:_step11()
	local anim = BattleAnimation:createAnimation("skills_dzbj_03",true)
	anim:getAnimNode():setUseOriginSize(true)
	anim:getAnimNode():setScale(2.5)
	anim:getAnimNode():setAnchorPointLuaTo(0.5,0.5)
	anim:getAnimNode():setRelativePositionLuaTo(0.5,0.5)
	self.m_bigSkillContainer:addChild(anim:getAnimNode())
	anim:getAnimNode():setZOrder(0)
	anim:play("0",false)
	
	local anim = BattleAnimation:createAnimation("skills_dzgx_03",true)
	anim:getAnimNode():setUseOriginSize(true)
	anim:getAnimNode():setScale(2.5)
	anim:getAnimNode():setAnchorPointLuaTo(0.5,0.5)
	anim:getAnimNode():setRelativePositionLuaTo(0.5,0.5)
	self.m_bigSkillContainer:addChild(anim:getAnimNode())
	anim:getAnimNode():setZOrder(10)
	anim:play("0",false)
	self.m_NowAnim = anim
	
	SoundManager:playEffectSound(SoundDefine.E_S_BIGSKILL_BEGIN)
end

function BattlePlayerBigSkill:_step12()

	if self.m_NowAnim then
		--local pos = self.m_NowAnim:getPosition()
		--BattleMapManager:getFrontControl():zoomToScaleAndPointQuickly(BattleMapManager:getFrontControl():getZoomInInit(), pos)

		if self.m_NowAnim:isCurrentAnimationDone() then
			self.m_NowAnim:getAnimNode():removeFromParentAndCleanup(true)
			self.m_NowAnim = nil

			self.m_bigSkillContainer:removeFromParentAndCleanup(true)
			self.m_bigSkillContainer = nil
			return true
		end
	end
	return false
end

function BattlePlayerBigSkill:_step2()

	local heroPos = self.m_tHero:getAnimation():getPosition()
	return BattleMapManager:getFrontControl():zoomToScaleAndPointQuickly(BattleMapManager:getFrontControl():getZoomOutInit(), heroPos)
end

function BattlePlayerBigSkill:_initStep3()
	self.m_bigSkillContainer = WZUIContainer:create()
	--self.m_bigSkillContainer:setUseAbsSize(true)
	--self.m_bigSkillContainer:setAbsContentSize(GlobalMethod:CCSize(1136,800))
	self.m_bigSkillContainer:setZOrder(6)
	SceneBattle:getFrontLayer():addChild(self.m_bigSkillContainer)
	self.m_bigSkillContainer:setPosition(BattleMapManager:getFrontControl():getCurScreenCenter().x,BattleMapManager:getFrontControl():getCurScreenCenter().y)
	local bg = WZUIImage:create()
	bg:setFile("ui/common/common_black_bg.png")
	bg:setOpacity(190)
	self.m_bigSkillContainer:addChild(bg)

	local anim = BattleAnimation:createAnimation("skills_dz_05",true)
	anim:getAnimNode():setUseOriginSize(false)
	anim:getAnimNode():setUseOriginSizeProportion(true)
	anim:getAnimNode():setAnchorPointLuaTo(0,0.5)
	anim:getAnimNode():setRelativePositionLuaTo(0.04,0.5)
	self.m_bigSkillContainer:addChild(anim:getAnimNode())
	anim:play("0",false)
	self.m_NowAnim = anim
	
	SoundManager:playEffectSound(SoundDefine.E_S_BIGSKILL_SHOOTING)
	
	self.m_nHurtDt = 0.5		--触发第一次受伤
end

function BattlePlayerBigSkill:_step3()
	local dt = SceneBattle:getBattleLoop():getBattleDeltaTime()
	
	self.m_nHurtDt = self.m_nHurtDt + dt
	if self.m_nHurtDt > 0.5 then
		if self.m_nHurtTimes < 5 then
			self.m_nHurtTimes =  self.m_nHurtTimes + 1
			self:_makeHurt()
			self.m_nHurtDt = 0
		end
	end
	if self.m_NowAnim then
		if self.m_NowAnim:isCurrentAnimationDone() then
			self.m_NowAnim:getAnimNode():removeFromParentAndCleanup(true)
			self.m_NowAnim = nil

			self.m_bigSkillContainer:removeFromParentAndCleanup(true)
			self.m_bigSkillContainer = nil
			return true
		end
	end
	
	return false
end

function BattlePlayerBigSkill:_makeHurt()
	local contentSizeHeight = 180
	for i,v in pairs(WBattleGlobal:getCurrent():getHeroList()) do
		if WBattleGlobal:getCurrent():isSameTeam(v:getBattleId() , self.m_tHero:getBattleId() ) == false then
			local y1 = v:getAnimation():getPosition().y - v:getAnimation():getAnimNode():getContentSize().height / 2
			local y2 = v:getAnimation():getPosition().y + v:getAnimation():getAnimNode():getContentSize().height / 2
			local heroPos = self.m_tHero:getAnimation():getPosition()
			if y1 <= heroPos.y + contentSizeHeight and y2>= heroPos.y - contentSizeHeight then
				local hurt, critType, distance = WBullet:calculateHurt(0,self.m_tHero,v)
				v:markHurt(hurt)
				WBattleGlobal:getCurrent():sendHurtProtocol(self.m_tHero:getBattleId(),{[v:getBattleId()]=v},{[v:getBattleId()]=hurt},{[v:getBattleId()]=distance},{[v:getBattleId()]=critType})
				self.m_bHurtSuccess = true
			end
		end
		v:getAnimation():getAnimNode():setZOrder(10)
	end
end

function BattlePlayerBigSkill:_waitHurt()
	local isHurt, hurtOne = WBattleGlobal:getCurrent():IsAnyOneHurt()
	return not isHurt
end

function BattlePlayerBigSkill:_step4()
	for i,v in pairs(WBattleGlobal:getCurrent():getHeroList()) do
		v:getAnimation():getAnimNode():setZOrder(0)
	end
	local heroPos = self.m_tHero:getAnimation():getPosition()
	return BattleMapManager:getFrontControl():zoomToScaleAndPointQuickly( self.m_nOriginScale , heroPos)
end
]]