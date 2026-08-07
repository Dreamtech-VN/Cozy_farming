--BattleMsgPetBeatbackShoot.lua
--@brief	玩家宠物射击消息
--@date		2013/1/8
--@author	李光森
--@note

--@brief	消息数据表
BattleMsgPetBeatbackShoot = {
    m_sName = "BattleMsgPetBeatbackShoot",
	m_shootHero = nil,				--宠物攻击所属英雄
	m_beShootedChara = nil,			--被宠物攻击的英雄
    m_bIsAtk = nil,                 --是否攻击了
    m_bIsBeatBack = true, 			--是否宠物反击

-------------------------------------处理逻辑使用的变量--------------------------------------
	m_tStepFunction = nil,			--步骤函数
	m_tPetBullet = nil,				--宠物子弹
	m_nLeftOrRigth = nil,			--0:左边，1:右边
	m_nOldOpacity = nil,			--透明度(隐藏专用)
    m_nShootDeltaTime = 0,

    m_bIsUsePetSkill = nil,			--使用宠物技能标志
    m_bIsUsePetSkillOk = false,		--使用宠物技能成功标志
    m_tCheckList = {},
    m_bIsAllFalse = nil,
    m_nPetShootIndex = nil, 		--标记连击索引
}

g_nPetBackShootAcctionFlag = -1			--CCAcction状态标记(-1:空状态,0:有状态,>0:id)

-------------------------------------公有方法模块--------------------------------------

--@brief	消息初始化函数
--@note		消息系统第一次调用process函数前调用
function BattleMsgPetBeatbackShoot:init()
	WZLog("BattleMsgPetBeatbackShoot:init")
	if self.m_beShootedChara:getAnimation() == nil then
		return
	end
	if SceneBattle:getBattleLoop():getBattleStatus() ~= BattleLoop.S_NORMAL then
		--return
	end
	SceneBattle:getBattleLoop():setBattleStatus(BattleLoop.S_PET_SHOOT)

	g_nPetBackShootAcctionFlag = -1

    self.m_tPet = self.m_shootHero:getPet()
    if self.m_tPet == nil then
        return
    end
	self.m_tPetBullet = {}
	self.m_tStepFunction = {}
	local tPet = self.m_shootHero:getPet()
    WZLog("===tPet:getPetType()===",tPet:getPetType())
	if (not (self.m_beShootedChara:getHp() <= 0 or self.m_beShootedChara:isDead())) and tPet ~= nil then
		if true or tPet:getPetType() == PetAttackType.Type_Melee then
            if self.m_shootHero:isHide() then
                table.insert(self.m_tStepFunction,self._runToTarget)
                table.insert(self.m_tStepFunction,self._petSkill)
                table.insert(self.m_tStepFunction,self._playAttackAnim)
                table.insert(self.m_tStepFunction,self._endAttackAnim)
                table.insert(self.m_tStepFunction,self._appear)
                table.insert(self.m_tStepFunction,self._waitEndAppear)
                table.insert(self.m_tStepFunction,self._checkAllCollision)
            else
                table.insert(self.m_tStepFunction,self._playReadyDisappearAnim)
                table.insert(self.m_tStepFunction,self._runToTarget)
                table.insert(self.m_tStepFunction,self._petSkill)
                table.insert(self.m_tStepFunction,self._playAttackAnim)
                table.insert(self.m_tStepFunction,self._endAttackAnim)
                table.insert(self.m_tStepFunction,self._disappear)
                table.insert(self.m_tStepFunction,self._resetZoomToHero)
                --table.insert(self.m_tStepFunction,self._zoomToHero)
                table.insert(self.m_tStepFunction,self._appear)
                table.insert(self.m_tStepFunction,self._waitEndAppear)
                table.insert(self.m_tStepFunction,self._checkAllCollision)
            end
		elseif tPet:getPetType() == PetAttackType.Type_Plane then
			--table.insert(self.m_tStepFunction,self._playBufferAnim)
			table.insert(self.m_tStepFunction,self._playReadyDisappearAnim)
			table.insert(self.m_tStepFunction,self._readyDropDomb)
			table.insert(self.m_tStepFunction,self._playAttackAnim)
			table.insert(self.m_tStepFunction,self._dropADomb)
			table.insert(self.m_tStepFunction,self._endDropDomb)
			table.insert(self.m_tStepFunction,self._waitForBulletAndHurt)
			--table.insert(self.m_tStepFunction,self._disappear)
			table.insert(self.m_tStepFunction,self._resetZoomToHero)
			table.insert(self.m_tStepFunction,self._zoomToHero)
			table.insert(self.m_tStepFunction,self._appear)
			table.insert(self.m_tStepFunction,self._waitEndAppear)
			table.insert(self.m_tStepFunction,self._checkAllCollision)
		elseif tPet:getPetType() == PetAttackType.Type_Shoot then
			--table.insert(self.m_tStepFunction,self._playAttackAnim)
			--table.insert(self.m_tStepFunction,self._createBullet)
			--table.insert(self.m_tStepFunction,self._waitForBulletAndHurt)
			--table.insert(self.m_tStepFunction,self._resetZoomToHero)
			--table.insert(self.m_tStepFunction,self._zoomToHero)
            --table.insert(self.m_tStepFunction,self._playBufferAnim)
			table.insert(self.m_tStepFunction,self._playReadyDisappearAnim)
			table.insert(self.m_tStepFunction,self._runToTarget)
			table.insert(self.m_tStepFunction,self._playAttackAnim)
			table.insert(self.m_tStepFunction,self._endAttackAnim)
			table.insert(self.m_tStepFunction,self._disappear)
			table.insert(self.m_tStepFunction,self._resetZoomToHero)
			table.insert(self.m_tStepFunction,self._zoomToHero)
			table.insert(self.m_tStepFunction,self._appear)
			table.insert(self.m_tStepFunction,self._waitEndAppear)
			table.insert(self.m_tStepFunction,self._checkAllCollision)
		end
	end

	if self.m_shootHero:getAnimation():getPosition().x <= self.m_beShootedChara:getAnimation():getPosition().x then
		self.m_nLeftOrRigth = 0
	else
		self.m_nLeftOrRigth = 1
	end

    if tPet ~= nil then
        self.m_nOldOpacity = tPet:getAnimation():getAnimNode():getOpacity()
        tPet:setStatus(PetStatus.DEF_ST_ATTACK)
        tPet:setTrackable(false)
    end
end

--@brief	消息处理过程函数
--@return	#1,nil或true表示消息处理结束，否则返回false
--@note		未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgPetBeatbackShoot:process()
	WZLog("BattleMsgPetBeatbackShoot:process0")
    if self.m_tPet == nil then
    	WZLog("BattleMsgPetBeatbackShoot:process1")
        return true
    end
	if self.m_beShootedChara:getAnimation() == nil and self.m_bIsAtk ~= true then
		WZLog("BattleMsgPetBeatbackShoot:process2")
		return true
	end

    if self.m_beShootedChara.m_nRevivalTime == WBattleGlobal:getCurrent().m_nTurnTimes then
    	WZLog("BattleMsgPetBeatbackShoot:process3")
        return true
    end

	if SceneBattle:getBattleLoop():getBattleStatus() ~= BattleLoop.S_PET_SHOOT then
		WZLog("BattleMsgPetBeatbackShoot:process4")
		return true
	end

	if self.m_shootHero:isOutOfScene() then
		WZLog("BattleMsgPetBeatbackShoot:process5")
		return true
	end

	if self.m_shootHero:isDead() or self.m_beShootedChara:isDead() then
		WZLog("BattleMsgPetBeatbackShoot:process8")
		return true
	end

	local receiveDeadPlayerIdList = WBattleGlobal:getCurrent().m_tReceiveDeadPlayerId
	if receiveDeadPlayerIdList then
		WZLog("BattleMsgPetBeatbackShoot:process6")
		for i,v in pairs(receiveDeadPlayerIdList) do
			if self.m_beShootedChara:getBattleId() == v then
				WZLog("BattleMsgPetBeatbackShoot:process7")
				return true
			end
		end
		
	end

	--更新子弹状态
	self:_updateBullet()

	--子弹跟随
	self:_followBullet()

	if #self.m_tStepFunction > 0 then
		local res = self.m_tStepFunction[1](self)
		if res == true or res == nil then
			table.remove(self.m_tStepFunction,1)
		end
		return false
	else
		return true
	end

	return true
end

--@brief	消息处理完成函数
--@note		消息系统最后一次调用process函数后调用
function BattleMsgPetBeatbackShoot:done()
	WZLog("BattleMsgPetBeatbackShoot:done")
    WZLog("sendMsg BattleMsgEndCurRound: 7.1")
    --回合结束
    if not MsgManager:isInShowActionMsg() and not MsgManager:isInShowNonBlockMsg() then --防止正在处理宠物攻击时候，反击结束，修改状态造成正常的宠物攻击操作中断
	    WBattleGlobal:getCurrent():endCurRound(WBattleGlobal:getCurrent():getMyBattleId(),7.1,nil,nil,true)

		local loop = SceneBattle:getBattleLoop()
		if loop:getBattleStatus() == BattleLoop.S_PET_SHOOT then
			loop:setBattleStatus(BattleLoop.S_NORMAL)
		end
	end

	local tPet = self.m_shootHero:getPet()
    if tPet ~= nil and self.m_nOldOpacity then
        tPet:getAnimation():setOpacity(self.m_nOldOpacity)
        tPet:setStatus(PetStatus.DEF_ST_NORMAL)
        tPet:setTrackable(true)

        --播放子弹发射后表情
        --if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_NORMAL then
            self.m_shootHero:showAttackFace(true)
            self.m_shootHero:getAnimation():play("standby3",false)
        --end
    end


end

--@brief	宠物技能回调
function BattleMsgPetBeatbackShoot:usePetSkillOkCallback()
	WZLog("BattleMsgPetBeatbackShoot:usePetSkillOkCallback")
	self.m_bIsUsePetSkillOk = true
end
-------------------------------------私有方法模块--------------------------------------
--@brief    检查全部人是否着地或掉坑或死亡
function BattleMsgPetBeatbackShoot:_checkAllCollision()
    for i,hero in pairs(WBattleGlobal:getCurrent():getHeroList()) do
        local _,isHole = hero:checkIsOutOfScene()
        if hero:isDead() ~= true and isHole ~= true and hero:getMover():isCollision() ~= true then
            table.insert(self.m_tCheckList, false)
        else
        	table.insert(self.m_tCheckList, true)
        end
    end

    local isAllFalse = true
    for i,v in ipairs(self.m_tCheckList) do
    	if v == false then
    		isAllFalse = false
    	end
    end

    if self.m_bIsAllFalse and isAllFalse then
    	return true
    end
    self.m_bIsAllFalse = isAllFalse
    self.m_tCheckList = {}
    
    return false
end

--@brief	宠物技能
function BattleMsgPetBeatbackShoot:_petSkill()
	if not self.m_bIsUsePetSkill then
		WZLog("BattleMsgPetBeatbackShoot:_petSkill")
		local tPet = self.m_shootHero:getPet()
		tPet:getAnimation():getAnimNode():setOpacity(255)

		self.m_bIsUsePetSkill = true
		local hero = self.m_shootHero
		return BattlePetSkillManager:triggerInitiativeSkill(hero, self.m_beShootedChara, self) 
	end

	return self.m_bIsUsePetSkillOk
end



--@brief	消失完成回调
function EndDisppearBackShoot(sender)
	g_nPetBackShootAcctionFlag = -1
end

--@brief	出现完成回调
function EndAppearBackShoot(sender)
	g_nPetBackShootAcctionFlag = -1
end

--@brief	投弹回调
function DropBombBackShoot(sender)
	WZLog("DropBombBackShoot")
	local tTable = g_nPetBackShootAcctionFlag

	local posShoot = tTable.m_shootHero:getPet():getAnimation():getPosition()
	local posBeShoot = nil
	if tTable.m_beShootedChara:getIsHero() then
		posBeShoot = tTable.m_beShootedChara:getCenterPos()
	else
		posBeShoot = tTable.m_beShootedChara:getAnimationCenterPos()
	end
	local speed = {x=posBeShoot.x-posShoot.x,y=posBeShoot.y-posShoot.y}
	local _,nor = BattleCommon:vectorNormalize(speed)
	speed = {x=nor.x,y=nor.y}
	local bullet = WPetBullet:buildBullet({x=posShoot.x,y=posShoot.y}, speed, {x=0,y=-0.3}, tTable.m_shootHero, 3, {x=posBeShoot.x,y=posBeShoot.y})
	table.insert(tTable.m_tPetBullet,bullet)
	bullet:addCollisionCharas({[tTable.m_beShootedChara:getBattleId()]=tTable.m_beShootedChara})
	SceneBattle:getFrontLayer():addChild(bullet:getAnimation():getAnimNode())
	if bullet:getAnimation():isDragonBone() then
		bullet:getAnimation():play("4",true)
	else
		bullet:getAnimation():play("bomb",true)
	end
end

--@brief	投弹完成回调
function EndDropBombBackShoot(sender)
	g_nPetBackShootAcctionFlag = -1
end
--[[--@brief	延迟播放受伤动画
function DelayStartHurt()
	local chara = WBattleGlobal:getCurrent():getCharacterWithId(g_nPetBackShootAcctionFlag)

	if chara then
		local hurtValue = 200
		chara:markHurt(hurtValue)

		local cKey = chara:getBattleId()
		self:_sendHurtProtocol({[cKey]=chara},{[cKey]=hurtValue})
	end
	g_nPetBackShootAcctionFlag = -1
end]]

--@brief	准备投弹
function BattleMsgPetBeatbackShoot:_readyDropDomb()
	WZLog("_readyDropDomb")
	local targetPos = self.m_beShootedChara:getAnimationCenterPos()

	if self.m_nLeftOrRigth == 0 then
		local startPostion = { x=targetPos.x - 300, y=targetPos.y + 200 }
		self.m_shootHero:getPet():getAnimation():setFlipX(false)
		self.m_shootHero:getPet():getAnimation():setPosition(startPostion)
	else
		local startPostion = { x=targetPos.x + 300, y=targetPos.y + 200 }
		self.m_shootHero:getPet():getAnimation():setFlipX(true)
		self.m_shootHero:getPet():getAnimation():setPosition(startPostion)
	end
	return true
end

--@brief	投弹
function BattleMsgPetBeatbackShoot:_dropADomb()
	WZLog("_dropADomb")
	local array = CCArray:create()
	if self.m_nLeftOrRigth == 0 then
		self.m_shootHero:getPet():getAnimation():getAnimNode():runAction(CCMoveBy:create(0.6,GlobalMethod:ccp(600,0)))
	elseif self.m_nLeftOrRigth == 1 then
		self.m_shootHero:getPet():getAnimation():getAnimNode():runAction(CCMoveBy:create(0.6,GlobalMethod:ccp(-600,0)))
	end
	array:addObject(CCFadeIn:create(0.08))
	array:addObject(CCDelayTime:create(0.1))
	array:addObject(CCCallFuncN:create(DropBombBackShoot))
	array:addObject(CCDelayTime:create(0.1))
	array:addObject(CCFadeOut:create(0.08))
	array:addObject(CCCallFuncN:create(EndDropBombBackShoot))
	g_nPetBackShootAcctionFlag = self
	self.m_shootHero:getPet():getAnimation():getAnimNode():runAction(CCSequence:create(array))
	return true
end

--@brief	完成投弹
function BattleMsgPetBeatbackShoot:_endDropDomb()
WZLog("_endDropDomb")
	return g_nPetBackShootAcctionFlag == -1
end

--@brief	播放缓冲动画
function BattleMsgPetBeatbackShoot:_playBufferAnim()
	WZLog("_playBufferAnim")
    self.m_shootHero:getPet():getAnimation():play(self.m_shootHero:getPet():getPetAtkAnimName(),false)
	return true
end
--@brief	播放准备消失动画
function BattleMsgPetBeatbackShoot:_playReadyDisappearAnim()
    if self.m_beShootedChara.m_nRepulseDis == nil or self.m_beShootedChara.m_nRepulseDis == 0 then
        if g_nPetBackShootAcctionFlag == -1 then
                g_nPetBackShootAcctionFlag = 0
                local array = CCArray:create()
                array:addObject(CCFadeOut:create(0.07))
                array:addObject(CCCallFuncN:create(EndDisppearBackShoot))
                self.m_shootHero:getPet():getAnimation():getAnimNode():runAction(CCSequence:create(array))
                return true
        end
    else
        WZLog("BattleMsgPetBeatbackShoot:_playReadyDisappearAnim", self.m_beShootedChara:getBattleId(), tostring(self.m_beShootedChara:isDead()), self.m_beShootedChara.m_nRepulseDis)
    end
	return false
end
--@brief	消失
function BattleMsgPetBeatbackShoot:_disappear()
	if g_nPetBackShootAcctionFlag == -1 then
		if self.m_shootHero:getPet():getAnimation():isCurrentAnimationDone() then

			g_nPetBackShootAcctionFlag = 0
			local array = CCArray:create()
			array:addObject(CCFadeOut:create(0.1))
			array:addObject(CCCallFuncN:create(EndDisppearBackShoot))
			self.m_shootHero:getPet():getAnimation():getAnimNode():runAction(CCSequence:create(array))
			return true
		end
	end
	return false
end

--@brief	屏幕移到目标上
function BattleMsgPetBeatbackShoot:_runToTarget()

	if g_nPetBackShootAcctionFlag == -1 then
		local zoom = true --BattleScreen:followHero(self.m_beShootedChara:getAnimation():getPosition())
            WZLog("BattleScreen:followHero 8")
		if zoom then
			local pos = self.m_beShootedChara:getPetAttackPos()
            local offset = 80
            if self.m_tPet.m_bIsRange == 1 then
                offset = 170
            end

			if self.m_nLeftOrRigth == 0 then
				self.m_shootHero:getPet():getAnimation():setFlipX(false)
				self.m_shootHero:getPet():getAnimation():setPosition({x=pos.x - offset,y=pos.y+ 10})
			else
				self.m_shootHero:getPet():getAnimation():setFlipX(true)
				self.m_shootHero:getPet():getAnimation():setPosition({x=pos.x + offset,y=pos.y+ 10})
			end
		end
		return zoom
	end
	return false
end

--[[--@brief	播放射击动画
function BattleMsgPetBeatbackShoot:_targetMarkHurt()
	g_nPetBackShootAcctionFlag = self.m_beShootedChara:getBattleId()
	local array = CCArray:create()
	array:addObject(CCDelayTime:create(0.4))
	array:addObject(CCCallFuncN:create(DelayStartHurt))
	self.m_beShootedChara:getAnimation():getAnimNode():runAction(CCSequence:create(array))
	return true
end]]

function BattleMsgPetBeatbackShoot:_endAttackAnim()
    self.m_nShootDeltaTime = self.m_nShootDeltaTime + SceneBattle:getBattleLoop():getBattleDeltaTime()
    WZLog("_endAttackAnim", self.m_nShootDeltaTime)
    if self.m_bIsPlaySound == nil and self.m_nShootDeltaTime > 0.5 then
        self.m_bIsPlaySound = true
        local tPet = self.m_shootHero:getPet()
        WZLog("_endAttackAnim 1", self.m_nShootDeltaTime, tPet.m_sAtkSound)
        SoundManager:playEffectSound(tPet.m_sAtkSound or SoundDefine.E_S_SHOOT_PET)
    end

    if self.m_shootHero:getPet().m_bIsAtk then
        self.m_shootHero:getPet().m_bIsAtk = nil
        local chara = self.m_beShootedChara
        local hurtValue,petRatio = self:_getHurtValue()
        if hurtValue ~= nil and hurtValue > 0 then
	        chara:markHurt(hurtValue,nil,nil,true,nil,petRatio, nil, nil, nil, self.m_shootHero:getBattleId())
	        self.m_shootHero:addPetHurt(hurtValue)
	        self:_sendHurtProtocol({[chara:getBattleId()]=chara}, {[chara:getBattleId()]=hurtValue})
	        --心魔收到伤害转移到本体
	        if chara:isInBuffState(EffectTypeConfig.HURT_TRANS) then 
	        	if chara:isDevilGuai() and self.m_shootHero:getBattleId() ~= chara:getDevilOwnId() then 
	        		local devilOwnHero = WBattleGlobal:getCurrent():getCharacterWithId(chara:getDevilOwnId())
	        		if not devilOwnHero:isDead() then 
	        			devilOwnHero:markHurt(hurtValue,nil,nil,true,nil,petRatio, true)
	        			self:_sendHurtProtocol({[devilOwnHero:getBattleId()]=devilOwnHero}, {[devilOwnHero:getBattleId()]=hurtValue})
	        		end
	        	end
	        end
        end
        WZLog("_endAttackAnim 2")
        self.m_bIsAtk = true

        if self.m_bIsPlaySound == nil then
	        self.m_bIsPlaySound = true
	        local tPet = self.m_shootHero:getPet()
	        SoundManager:playEffectSound(tPet.m_sAtkSound or SoundDefine.E_S_SHOOT_PET)
	    end
        return true
    end

	if self.m_shootHero:getPet():getAnimation():isCurrentAnimationDone() then
        if self.m_bIsAtk ~= true then
            local chara = self.m_beShootedChara
            local hurtValue,petRatio = self:_getHurtValue()
            if hurtValue ~= nil and hurtValue > 0 then
                chara:markHurt(hurtValue,nil,nil,true,nil,petRatio, nil, nil, nil, self.m_shootHero:getBattleId())
                self.m_shootHero:addPetHurt(hurtValue)
                self:_sendHurtProtocol({[chara:getBattleId()]=chara}, {[chara:getBattleId()]=hurtValue})
		        --心魔收到伤害转移到本体
		        if chara:isInBuffState(EffectTypeConfig.HURT_TRANS) then 
		        	if chara:isDevilGuai() and self.m_shootHero:getBattleId() ~= chara:getDevilOwnId() then 
		        		local devilOwnHero = WBattleGlobal:getCurrent():getCharacterWithId(chara:getDevilOwnId())
		        		if not devilOwnHero:isDead() then 
		        			devilOwnHero:markHurt(hurtValue,nil,nil,true,nil,petRatio, true)
		        			self:_sendHurtProtocol({[devilOwnHero:getBattleId()]=devilOwnHero}, {[devilOwnHero:getBattleId()]=hurtValue})
		        		end
		        	end
		        end
            end
            WZLog("_endAttackAnim 3")
            self.m_bIsAtk = true
        end
		return true
	end
	return false
end

--@brief	出现
function BattleMsgPetBeatbackShoot:_appear()
	WZLog("_appear")
	g_nPetBackShootAcctionFlag = 0
	local array = CCArray:create()
	array:addObject(CCFadeIn:create(0.1))
	array:addObject(CCCallFuncN:create(EndAppearBackShoot))
	self.m_shootHero:getPet():getAnimation():getAnimNode():runAction(CCSequence:create(array))
	return true
end

--@brief	等待出现完毕
function BattleMsgPetBeatbackShoot:_waitEndAppear()
	WZLog("_waitEndAppear")
	return g_nPetBackShootAcctionFlag == -1
end

--@brief	更新子弹状态
function BattleMsgPetBeatbackShoot:_updateBullet()
	local bullets = self.m_tPetBullet
	for i=#bullets,1,-1 do
		bullets[i]:updatePosition()

		if bullets[i]:checkOutOfScene() then
			bullets[i]:getAnimation():getAnimNode():removeFromParentAndCleanup(true)
			table.remove(bullets,i)
		else
			local isColl,charas = bullets[i]:checkCharacterCollision()
			if isColl then
				for id,chara in pairs(charas) do
					local hurtValue = self:_getHurtValue()
					if hurtValue ~= nil and hurtValue > 0 then
						chara:markHurt(hurtValue)
						self:_sendHurtProtocol({[chara:getBattleId()]=chara},{[chara:getBattleId()]=hurtValue})
				        --心魔收到伤害转移到本体
				        if chara:isInBuffState(EffectTypeConfig.HURT_TRANS) then 
				        	if chara:isDevilGuai() and self.m_shootHero:getBattleId() ~= chara:getDevilOwnId() then 
				        		local devilOwnHero = WBattleGlobal:getCurrent():getCharacterWithId(chara:getDevilOwnId())
				        		if not devilOwnHero:isDead() then 
				        			devilOwnHero:markHurt(hurtValue, nil, nil, nil, nil, nil, true)
				        			self:_sendHurtProtocol({[devilOwnHero:getBattleId()]=devilOwnHero},{[devilOwnHero:getBattleId()]=hurtValue})
				        		end
				        	end
				        end
					end
				end
				bullets[i]:getAnimation():getAnimNode():removeFromParentAndCleanup(true)
				table.remove(bullets,i)
			elseif bullets[i]:checkOutOfTarget() then
				local hurtValue = self:_getHurtValue()
				if hurtValue ~= nil and hurtValue > 0 then
					self.m_beShootedChara:markHurt(hurtValue)
					self:_sendHurtProtocol({[self.m_beShootedChara:getBattleId()]=self.m_beShootedChara},{[self.m_beShootedChara:getBattleId()]=hurtValue})
					--心魔收到伤害转移到本体
			        if self.m_beShootedChara:isInBuffState(EffectTypeConfig.HURT_TRANS) then 
			        	if self.m_beShootedChara:isDevilGuai() and self.m_shootHero:getBattleId() ~= self.m_beShootedChara:getDevilOwnId() then 
			        		local devilOwnHero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_beShootedChara:getDevilOwnId())
			        		if not devilOwnHero:isDead() then 
			        			devilOwnHero:markHurt(hurtValue, nil, nil, nil, nil, nil, true)
			        			self:_sendHurtProtocol({[devilOwnHero:getBattleId()]=devilOwnHero},{[devilOwnHero:getBattleId()]=hurtValue})
			        		end
			        	end
			        end
				end
				bullets[i]:getAnimation():getAnimNode():removeFromParentAndCleanup(true)
				table.remove(bullets,i)
			end
		end
	end
end

--@brief	更新子弹状态
--@return	#1:返回伤害数值
function BattleMsgPetBeatbackShoot:_getHurtValue()
	local chara = self.m_beShootedChara
	local hurtValue,petRatio = self:calculateHurt(chara,self.m_shootHero:getPet().m_tPetInfo.petParam1 / 10000)
    WZLog("BattleMsgPetBeatbackShoot:_getHurtValue", tostring(self.m_shootHero:getPet().m_tPetInfo.petParam1), hurtValue, self.m_shootHero.m_nAttackPet)

	return hurtValue,petRatio
end

--@brief	屏幕跟踪子弹
function BattleMsgPetBeatbackShoot:_followBullet()
	local bullet = self.m_tPetBullet[1]
	if bullet ~= nil then
		BattleScreen:followBullet(bullet:getMover():getMoverPosition(),1)
	end
end

--@brief	播放射击动画
function BattleMsgPetBeatbackShoot:_playAttackAnim()
	if g_nPetBackShootAcctionFlag == -1 then
		local tPet = self.m_shootHero:getPet()
        --SoundManager:playEffectSound(tPet.m_sAtkSound or SoundDefine.E_S_SHOOT_PET)
		tPet:getAnimation():play(tPet:getPetAtkAnimName(),false)
		local effectAnim = tPet:getAnimation():getEffectAnim()
		WZLog("BattleMsgPetBeatbackShoot:_playAttackAnim", tostring(effectAnim))
		if effectAnim then
			effectAnim:play(tPet:getPetAtkAnimName(),false)
		end
		return true
	end
	return false
end

--@brief	创建子弹
function BattleMsgPetBeatbackShoot:_createBullet()
	WZLog("_createBullet")
	if self.m_shootHero:getPet():getAnimation():isCurrentAnimationDone() then
        self.m_shootHero:getPet():getAnimation():play(self.m_shootHero:getPet():getPetWaitAnimName(),true)

		local leftOrRight = self.m_shootHero:getAnimation():isFlipX()
		leftOrRight = leftOrRight and -1 or 1

		local posShoot = self.m_shootHero:getPet():getAnimationCenterPos()
		local sizePet = self.m_shootHero:getPet():getAnimation():getAnimNode():getContentSize()
		posShoot = {x=posShoot.x + leftOrRight * sizePet.width * 0.5,y=posShoot.y}

		local posBeShoot = nil
		if self.m_beShootedChara:getIsHero() then
			posBeShoot = self.m_beShootedChara:getCenterPos()
		else
			posBeShoot = self.m_beShootedChara:getAnimationCenterPos()
		end

		local speed = {x=posBeShoot.x-posShoot.x,y=posBeShoot.y-posShoot.y}
		local _,nor = BattleCommon:vectorNormalize(speed)
		speed = {x=nor.x * BattleConstants.g_fWB_PET_SHOOT_SPEED,y=nor.y * BattleConstants.g_fWB_PET_SHOOT_SPEED}

		local bullet = WPetBullet:buildBullet({x=posShoot.x,y=posShoot.y}, speed, {x=0,y=0}, self.m_shootHero, 3, {x=posBeShoot.x,y=posBeShoot.y})
		table.insert(self.m_tPetBullet,bullet)
		bullet:addCollisionCharas({[self.m_beShootedChara:getBattleId()]=self.m_beShootedChara})
		SceneBattle:getFrontLayer():addChild(bullet:getAnimation():getAnimNode())
		if bullet:getAnimation():isDragonBone() then
			bullet:getAnimation():play("4",true)
		else
			bullet:getAnimation():play("bomb",true)
		end

		return true
	end
	return false
end

--@brief	等待子弹飞行和英雄受伤
function BattleMsgPetBeatbackShoot:_waitForBulletAndHurt()
	WZLog("_waitForBulletAndHurt")
	if #self.m_tPetBullet <= 0 and not WBattleGlobal:getCurrent():IsAnyOneHurt() then
		return true
	end
	return false
end

--@brief	屏幕初始化
function BattleMsgPetBeatbackShoot:_resetZoomToHero()
	WZLog("_resetZoomToHero")
	BattleScreen:resetZoomToHero()
	return true
end

--@brief	屏幕移向英雄
function BattleMsgPetBeatbackShoot:_zoomToHero()
    WZLog("BattleMsgPetBeatbackShoot:_zoomToHero")
	local res = BattleScreen:zoomToHero(self.m_shootHero:getBattleId() , self.m_shootHero:getAnimation():getPosition())
	if res then
		self.m_shootHero:getPet():setTrackable(true)
		self.m_shootHero:getPet():setStatus(PetStatus.DEF_ST_NORMAL)
	end
	
	return res
end

--@brief	发送受伤协议
--@param	charas:英雄列表
--@param	values:伤害列表
function BattleMsgPetBeatbackShoot:_sendHurtProtocol(charas,values)
	
	if self.m_shootHero ~= nil and self.m_shootHero:getType() ~= 1 then
		local angerUp = 0

		-- 宠物攻击时获得怒气
		for i=1,#self.m_shootHero.m_tPetEquipAttr do
			local extPropertyKey = tonumber(self.m_shootHero.m_tPetEquipAttr[i].extPropertyKey)
			local extPropertyValue = tonumber(self.m_shootHero.m_tPetEquipAttr[i].extPropertyValue)
			if tonumber(extPropertyKey) == PetEquipRandomAttr.PET_ATK_ADD_SP then --tab_pet_random表type字段值
				angerUp = angerUp + extPropertyValue
			end
		end

        if WBattleGlobal:getCurrent():isDigGappingFighting() then 
            angerUp = angerUp * GlobalGame.g_nSpAddTimes
        end
        --计算怒气加成
        angerUp = BattleMethod:getSpAddValue(self.m_shootHero, angerUp)
		if (self.m_shootHero:getSp() + angerUp) >= 100 then
			self.m_shootHero:setSp(100)
		elseif (self.m_shootHero:getSp() + angerUp) <= 0 then
			self.m_shootHero:setSp(0)
		else
			self.m_shootHero:setSp(self.m_shootHero:getSp() + angerUp)
		end
	end

	local hero = self.m_beShootedChara
	if hero ~= nil and hero:getType() ~= 1 then
        local angerUp = 0

        -- 宠物攻击时减少敌人怒气
		for i=1,#self.m_shootHero.m_tPetEquipAttr do
			local extPropertyKey = tonumber(self.m_shootHero.m_tPetEquipAttr[i].extPropertyKey)
			local extPropertyValue = tonumber(self.m_shootHero.m_tPetEquipAttr[i].extPropertyValue)
			if tonumber(extPropertyKey) == PetEquipRandomAttr.PET_ATK_SUB_SP then --tab_pet_random表type字段值
				angerUp = angerUp - extPropertyValue
			end
		end

        if (hero:getSp() + angerUp) >= 100 then
            hero:setSp(100)
        elseif (hero:getSp() + angerUp) <= 0 then
            hero:setSp(0)
        else
            hero:setSp(hero:getSp() + angerUp)
        end
    end

	if charas == nil or not self.m_shootHero:isCanControl() then
		return
	end

	local hurtCount = 0
	local hurtIds = WZLuaVector_int_:create()
	local hurtValues = WZLuaVector_int_:create()

	for id,chara in pairs(charas) do
        hurtIds:push(chara:getBattleId())
        hurtValues:push(values[id])
        hurtCount = hurtCount + 1
	end

	if hurtCount > 0 then
		ProtocolProcessorBattleInterface:send_BATTLE_PetCounterAttack(WBattleGlobal:getCurrent().m_tMakePairOk.battleId, self.m_shootHero:getBattleId(),hurtIds:get(0),hurtValues:get(0))
	end
end

function BattleMsgPetBeatbackShoot:getHurtType(shootHero,targetHero)
    return WBullet.getHurtType(self,shootHero,targetHero)
end

--@brief	根据距离、射击玩家、被射玩家计算出基础伤害值
--@return	#1：伤害
function BattleMsgPetBeatbackShoot:calculateHurt(targetHero,petCoef)
	WZLog("BattleMsgPetBeatbackShoot:calculateHurt", petCoef,self.m_shootHero:getPetCrit(), self.m_shootHero.m_tPetSkillTakeEffectInfo and Serialize(self.m_shootHero.m_tPetSkillTakeEffectInfo))
    local petRatio = petCoef * (1 + self.m_shootHero:getPetCrit()/100)
	local hurt = WBullet.calculateHurt(self,0,self.m_shootHero,targetHero,petRatio, nil, self.m_shootHero:getPetCrit() ~= 0)
	
	WBattleGlobal:getCurrent().m_nPetAttackHurtCurRound = hurt
	local hero = self.m_shootHero	
	hero.m_bPetActiveAttack = true
	hero.m_tPetAttackHero = targetHero
	if hero.m_tPetSkillTakeEffectInfo ~= nil then
		WZLog("BattleMsgPetBeatbackShoot:calculateHurt two", Serialize(hero.m_tPetSkillTakeEffectInfo))
		for i,v in ipairs(hero.m_tPetSkillTakeEffectInfo) do
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
            v, TakeEffectType.HIT,
            nil,
            nil,
            true
            )
		end
    	
   	end

	local tempPetRatio = (1 + self.m_shootHero:getPetCrit()/100) * (1 + (targetHero:getBeHurtAddPercent(self.m_shootHero) or 0)) * (1 + self.m_shootHero:getCampHurtAddPercent(targetHero))

	return hurt, tempPetRatio
end
