--WBulletEffect.lua
--@brief	各种子弹特效表
--@date		2013/12/24
--@author	李光森
--@note
--[[
-------------------------------------子弹特效模版--------------------------------------
--@brief	特效
WEffect = {
	m_tBullet = nil,		--子弹基础表
}

-------------------------------------重载方法模块--------------------------------------

--@brief	生成一个子弹特效
--@param	tBullet:使用此效果的子弹
function WEffect:buildEffect(tBullet)
	local effect = {}
	setmetatable(effect, {__index=function( tTable,sKey )
		if WEffect[sKey] ~= nil then
			return WEffect[sKey]
		elseif tTable.m_tBullet ~= nil then
			return tTable.m_tBullet[sKey]
		else
			return nil
		end
	end})
	effect.m_tBullet = tBullet

	return effect
end

--@brief	检查伤害
--@return	#1:受伤的人物列表
--@return	#2:受伤值
function WEffect:checkHurt()
	return self.m_tBullet:checkHurt()
end

--@brief	更新位置
function WEffect:updatePosition()
	self.m_tBullet:updatePosition()
end

--@brief	子弹爆炸
function WEffect:explode()
    WZLog("explode 1")
	self.m_tBullet:explode()
end

--@brief	子弹挖坑
function WEffect:DigHole()
    WZLog("DigHole 1")
	self.m_tBullet:DigHole()
end

--@brief	子弹是否爆炸完毕
--@return	#1:true:是，false：否
function WEffect:explodeIsEnd()
	return self.m_tBullet:explodeIsEnd()
end

--@brief	获得原始子弹表
function WEffect:getBaseBullet()
	return self.m_tBullet.getBaseBullet and self.m_tBullet:getBaseBullet() or self.m_tBullet
end

-------------------------------------私有方法模块--------------------------------------
]]

-------------------------------------追踪特效表--------------------------------------

--@brief	追踪特效
WFollowEffect = {
	m_tBullet = nil,		--子弹基础表
	m_bIsTracking = nil,	--是否正在追踪
	m_followHero = nil,		--追踪的英雄
    m_nFlyLength = 0,       --已飞行的长度
    m_tPosPre = nil,        --上一帧的位置
}

-------------------------------------重载方法模块--------------------------------------

--@brief	生成一个子弹特效
--@param	tBullet:使用此效果的子弹
function WFollowEffect:buildEffect(tBullet)
    WZLog("WFollowEffect:buildEffect")
	local effect = {}
	setmetatable(effect, {__index=function( tTable,sKey )
		if WFollowEffect[sKey] ~= nil then
			return WFollowEffect[sKey]
		elseif tTable.m_tBullet ~= nil then
			return tTable.m_tBullet[sKey]
		else
			return nil
		end
	end})
	effect.m_tBullet = tBullet

    local destroyFunc = tBullet.destroy
    tBullet.destroy = function()
            destroyFunc(effect.m_tBullet)
            if effect.m_bIsTracking and effect.m_followHero ~= nil and effect.m_followHero.m_anim ~= nil then
            effect.m_followHero:removeFollowAnimation()
            effect.m_followHero = nil
            effect.m_bIsTracking = nil
            end
        end

	return effect
end

--@brief	检查伤害
--@return	#1:受伤的人物列表
--@return	#2:受伤值
function WFollowEffect:checkHurt()
	return self.m_tBullet:checkHurt()
end

--@brief	更新位置
function WFollowEffect:updatePosition()
	if self.m_bIsTracking == nil or self.m_bIsTracking == false then

        if self.m_tPosPre == nil then
            self.m_tPosPre = self.m_tBullet:getPosition()
            self.m_nFlyLength = 0
        else
            self.m_nFlyLength = self.m_nFlyLength + BattleCommon:pointDis(self.m_tPosPre, self.m_tBullet:getPosition())
        end
        --WZLog("WFollowEffect:updatePosition", self.m_tPosPre.x, self.m_tPosPre.y, self.m_tBullet:getPosition().x, self.m_tBullet:getPosition().y, self.m_nFlyLength, BattleCommon:pointDis(self.m_tPosPre, self.m_tBullet:getPosition()))
        self.m_tPosPre = self.m_tBullet:getPosition()

        if self.m_nFlyLength >= 350 then

            self:_checkTrack(WBattleGlobal:getCurrent():getCharacterList())
        end
	end
	self.m_tBullet:updatePosition()
end

--@brief	子弹爆炸
function WFollowEffect:explode()
    WZLog("explode 2")
	self.m_tBullet:explode()
	if self.m_bIsTracking and self.m_followHero ~= nil then
		self.m_followHero:removeFollowAnimation()
		self.m_followHero = nil
		self.m_bIsTracking = nil
	end
end

--@brief	子弹挖坑
function WFollowEffect:DigHole()
    WZLog("DigHole 2")
	self.m_tBullet:DigHole()
end

--@brief	子弹是否爆炸完毕
--@return	#1:true:是，false：否
function WFollowEffect:explodeIsEnd()
	return self.m_tBullet:explodeIsEnd()
end

--@brief	获得原始子弹表
function WFollowEffect:getBaseBullet()
	return self.m_tBullet.getBaseBullet and self.m_tBullet:getBaseBullet() or self.m_tBullet
end

-------------------------------------私有方法模块--------------------------------------
--@brief	检测追踪英雄
--@param	heros:英雄列表
--@return	#1:true:跟踪,false:不跟踪
function WFollowEffect:_checkTrack(heros)
	local minDis = INT32_MAX
	local vecSpeed = nil
	for id,hero in pairs(heros) do
		if self:_canTrack(hero) then
			local bulletPos = self:getMover():getMoverPosition()
			local heroPos = hero:getCenterPos()
            WZLog("_checkTrack pos",heroPos.x,heroPos.y)
			local dis = BattleCommon:pointDis(bulletPos,heroPos)
			if dis < BattleConstants.g_fWB_TRACK_DIS and dis < minDis then
                WZLog("_checkTrack 1", dis, BattleConstants.g_fWB_TRACK_DIS, minDis, bulletPos.x, bulletPos.y, heroPos.x, heroPos.y , self.m_tBullet.m__bid)
				self.m_followHero = hero
				minDis = dis
                if hero:getType() == 0 then
				    vecSpeed = BattleCommon:pointSub(BattleCommon:getPointTable(heroPos.x,heroPos.y + 20),bulletPos)
                else
                    vecSpeed = BattleCommon:pointSub(BattleCommon:getPointTable(heroPos.x,heroPos.y),bulletPos)
                end
			end
		end
	end

	if minDis < BattleConstants.g_fWB_TRACK_DIS then
        WZLog("_checkTrack 3", minDis, BattleConstants.g_fWB_TRACK_DIS)
		self.m_bIsTracking = true
		self.m_followHero:addFollowAnimation()
		local _,tSpeed = BattleCommon:vectorNormalize(vecSpeed)
		self:getMover():setMoverSpeed(Vector2:create(tSpeed.x*BattleConstants.g_fWB_TRACK_SPEED,tSpeed.y*BattleConstants.g_fWB_TRACK_SPEED))
		self:getMover():setMoverAcceleration(Vector2:create(0,0))
		return true
	else
		return false
	end
end

--@brief	检测英雄是否可以追踪
--@param	hero:被检测的英雄
--@return	#1:true:是，false:否
function WFollowEffect:_canTrack(hero)
	if hero:isDead() or hero.m_bOffHurt then
		return false
	elseif hero:getBattleId() == self:getOwnerChara():getBattleId() then
		return false

	elseif (WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_NORMAL and WBattleGlobal:getCurrent().m_tMakePairOk.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_LD) then
		return true
	else
		return hero:getCamp() ~= self:getOwnerChara():getCamp()
	end
end

-------------------------------------冰冻特效表--------------------------------------
--@brief	冰冻特效
WFrozenEffect = {
	m_tBullet = nil,		--子弹基础表
    m_bIsFrozen = nil,      --是否是冰冻弹
}

-------------------------------------重载方法模块--------------------------------------

--@brief	生成一个子弹特效
--@param	tBullet:使用此效果的子弹
function WFrozenEffect:buildEffect(tBullet)
	local effect = {}
	setmetatable(effect, {__index=function( tTable,sKey )
		if WFrozenEffect[sKey] ~= nil then
			return WFrozenEffect[sKey]
		elseif tTable.m_tBullet ~= nil then
			return tTable.m_tBullet[sKey]
		else
			return nil
		end
	end})
	effect.m_tBullet = tBullet
    effect.m_bIsFrozen = true

	--effect.m_tBullet:getAnimation():addAnimation("frozen2",{}, 0.1, true,IWCO_BATTLEEFFECT)
	return effect
end

--@brief	检查伤害
--@return	#1:受伤的人物列表
--@return	#2:受伤值
function WFrozenEffect:checkHurt()
	local tHurtCharas, tHurtValues, tDistance, tCritType, tHurtRatio = self.m_tBullet:checkHurt()

    --世界boss不发送冰冻协议
    local isWorldBossMap = false
    if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS and WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_WORLDBOSS then
        isWorldBossMap = true
    end

	local isHaveHero = false
	local vecIds = WZLuaVector_int_:create()
	for id,hero in pairs(tHurtCharas) do
        if tHurtValues[id] > 0 then
            --WZLog("WFrozenEffect:checkHurt", tHurtValues[id], id, hero:getBattleId())
            if isWorldBossMap == false then
                --tHurtValues[id] = 0
            end
            if  (((not isWorldBossMap) and hero:getIsHero()) or (isWorldBossMap and hero:getIsGuai()) or WBattleGlobal:getCurrent():isSingleStage() == true) then
                --hero:addFrozenAnimation()
                vecIds:push(id)
                isHaveHero = true
            end
        end
	end

	if isHaveHero and WBattleGlobal:getCurrent():getCurrentCharacter():isCanControl() and not isWorldBossMap then
		--ProtocolProcessorBattleInterface:send_BATTLE_BeFrozen(WBattleGlobal:getCurrent().m_tMakePairOk.battleId,self:getOwnerChara().m_nFrozenId ,vecIds)
	end

	return tHurtCharas, tHurtValues, tDistance, tCritType, tHurtRatio
end

--@brief	更新位置
function WFrozenEffect:updatePosition()
	self.m_tBullet:updatePosition()
end

--@brief	子弹爆炸
function WFrozenEffect:explode()
    WZLog("explode 3")
	self.m_tBullet:explode()
	--[[
	if self.m_tBullet.m_nCurStatus == BulletStatus.DEF_ST_EXPLODE then
        return
    end

	SoundManager:playEffectSound(SoundDefine.E_S_EXPLODE)
	self.m_tBullet.m_nCurStatus = BulletStatus.DEF_ST_EXPLODE
	if self.m_tBullet:getBackFire() ~= nil then
		self.m_tBullet:getBackFire():stopSystem()
	end

	self.m_tBullet.m_anim:getAnimNode():setVisible(false)

	self.m_tBullet.m_tExplodeElement:explode( { x = self.m_tBullet:getMover():getMoverPosition().x, y = self.m_tBullet:getMover():getMoverPosition().y} )

    self.m_tBullet:getAnimation():setScaleX(1.3)
    self.m_tBullet:getAnimation():setScaleY(1.3)
	self.m_tBullet:setStatus(BulletStatus.DEF_ST_EXPLODE)
	--self.m_tBullet:getAnimation():play("frozen2",false)]]
end

--@brief	子弹挖坑
function WFrozenEffect:DigHole()
    WZLog("DigHole 3")
	self.m_tBullet:DigHole()
end

--@brief	子弹是否爆炸完毕
--@return	#1:true:是，false：否
function WFrozenEffect:explodeIsEnd()
	return self.m_tBullet:explodeIsEnd()
end

--@brief	获得原始子弹表
function WFrozenEffect:getBaseBullet()
	return self.m_tBullet.getBaseBullet and self.m_tBullet:getBaseBullet() or self.m_tBullet
end
-------------------------------------私有方法模块--------------------------------------


-------------------------------------持续伤害特效表--------------------------------------
--@brief	持续伤害特效
WHurtEffect = {
	m_tBullet = nil,			--子弹基础表
	m_sAnimaName = nil,			--受伤动画名字
	m_nHurtValue = nil,			--受伤数字
	m_nLastRound = nil,			--受伤回合数
}

-------------------------------------公有方法模块--------------------------------------

--@brief	生成一个子弹特效
--@param	tBullet:使用此效果的子弹
function WHurtEffect:buildEffect(tBullet)
	local effect = {}
	setmetatable(effect, {__index=function( tTable,sKey )
		if WHurtEffect[sKey] ~= nil then
			return WHurtEffect[sKey]
		elseif tTable.m_tBullet ~= nil then
			return tTable.m_tBullet[sKey]
		else
			return nil
		end
	end})
	effect.m_tBullet=tBullet

	return effect
end

--@brief	设置特效信息
function WHurtEffect:setHurtEffectInfo(lastRound,hurtValue,sAnimName)
	self.m_nLastRound = lastRound
	self.m_nHurtValue = hurtValue
	self.m_sAnimaName = sAnimName
end

--@brief	检查伤害
--@return	#1:受伤的人物列表
--@return	#2:受伤值
function WHurtEffect:checkHurt()
	local tHurtCharas, tHurtValues, tDistance, tCritType, tHurtRatio = self.m_tBullet:checkHurt()

	for id,hero in pairs(tHurtCharas) do
        if tHurtValues[id] > 0 then
            WZLog("WHurtEffect:checkHurt one",id, tostring(hero.m_bIsImmunity), tostring(hero:getIsHero()), tostring(WBattleGlobal:getCurrent():isSingleStage()))
            if not hero.m_bIsImmunity and (hero:getIsHero() or (WBattleGlobal:getCurrent():isSingleStage())) then
                hero:setHurtHeroId(self.m_tBullet:getOwnerChara():getBattleId())
                if hero.m_tHurtAnim ~= nil then
                    if hero.m_tHurtAnim["butn"] ~= nil then
                        hero.m_tHurtAnim["butn"]:getAnimNode():removeFromParentAndCleanup(true)
                        hero.m_tHurtAnim["butn"] = nil
                    elseif hero.m_tHurtAnim["poison"] ~= nil then
                        hero.m_tHurtAnim["poison"]:getAnimNode():removeFromParentAndCleanup(true)
                        hero.m_tHurtAnim["poison"] = nil
                    elseif hero.m_tHurtAnim["ice"] ~= nil then
                        hero.m_tHurtAnim["ice"]:getAnimNode():removeFromParentAndCleanup(true)
                        hero.m_tHurtAnim["ice"] = nil
                    end
                end
                WZLog("WHurtEffect:checkHurt two")
                hero:addBuff("m_nDebuffHurtRound",self.m_nLastRound,nil,"m_nDebuffHurt",self.m_nHurtValue,nil,self.m_sAnimaName)
            end
        end
	end

	return tHurtCharas, tHurtValues, tDistance, tCritType, tHurtRatio
end

--@brief	更新位置
function WHurtEffect:updatePosition()
	self.m_tBullet:updatePosition()
end

--@brief	子弹爆炸
function WHurtEffect:explode()
    WZLog("explode 4")
	self.m_tBullet:explode()
end

--@brief	子弹挖坑
function WHurtEffect:DigHole()
    WZLog("DigHole 4")
	self.m_tBullet:DigHole()
end

--@brief	子弹是否爆炸完毕
--@return	#1:true:是，false：否
function WHurtEffect:explodeIsEnd()
	return self.m_tBullet:explodeIsEnd()
end

--@brief	获得原始子弹表
function WHurtEffect:getBaseBullet()
	return self.m_tBullet.getBaseBullet and self.m_tBullet:getBaseBullet() or self.m_tBullet
end
-------------------------------------私有方法模块--------------------------------------

-------------------------------------疲劳特效表--------------------------------------
--@brief	疲劳特效表
WTiredEffect = {
	m_tBullet = nil,			--子弹基础表
	m_sAnimaName = nil,			--动画名字
	m_nValue = nil,				--数字
	m_nLastRound = nil,			--回合数
}

-------------------------------------公有方法模块--------------------------------------

--@brief	生成一个子弹特效
--@param	tBullet:使用此效果的子弹
function WTiredEffect:buildEffect(tBullet)
	local effect = {}
	setmetatable(effect, {__index=function( tTable,sKey )
		if WTiredEffect[sKey] ~= nil then
			return WTiredEffect[sKey]
		elseif tTable.m_tBullet ~= nil then
			return tTable.m_tBullet[sKey]
		else
			return nil
		end
	end})
	effect.m_tBullet=tBullet

	return effect
end

--@brief	设置特效信息
function WTiredEffect:setTiredEffectInfo(lastRound,value,sAnimName)
	self.m_nLastRound = lastRound
	self.m_nValue = value
	self.m_sAnimaName = sAnimName
end

--@brief	检查伤害
--@return	#1:受伤的人物列表
--@return	#2:受伤值
function WTiredEffect:checkHurt()
	local tHurtCharas, tHurtValues, tDistance, tCritType, tHurtRatio = self.m_tBullet:checkHurt()

	for id,hero in pairs(tHurtCharas) do
        if tHurtValues[id] > 0 then
            if not hero.m_bIsImmunity and (hero:getIsHero() or (WBattleGlobal:getCurrent():isSingleStage())) then
                if hero.m_tHurtAnim ~= nil and hero.m_tHurtAnim[self.m_sAnimaName] ~= nil then
                    hero:addBuff("m_nDebuffTiredRound",self.m_nLastRound,nil,"m_nDebuffTired",self.m_nValue,nil,nil)
                else
                    hero:addBuff("m_nDebuffTiredRound",self.m_nLastRound,nil,"m_nDebuffTired",self.m_nValue,nil,self.m_sAnimaName)
                end
            end
        end
	end

	return tHurtCharas, tHurtValues, tDistance, tCritType, tHurtRatio
end

--@brief	更新位置
function WTiredEffect:updatePosition()
	self.m_tBullet:updatePosition()
end

--@brief	子弹爆炸
function WTiredEffect:explode()
    WZLog("explode 5")
	self.m_tBullet:explode()
end

--@brief	子弹挖坑
function WTiredEffect:DigHole()
    WZLog("DigHole 5")
	self.m_tBullet:DigHole()
end

--@brief	子弹是否爆炸完毕
--@return	#1:true:是，false：否
function WTiredEffect:explodeIsEnd()
	return self.m_tBullet:explodeIsEnd()
end

--@brief	获得原始子弹表
function WTiredEffect:getBaseBullet()
	return self.m_tBullet.getBaseBullet and self.m_tBullet:getBaseBullet() or self.m_tBullet
end
-------------------------------------私有方法模块--------------------------------------

-------------------------------------重力特效表--------------------------------------
--@brief	重力特效表
WFlyLockEffect = {
	m_tBullet = nil,			--子弹基础表
	m_sAnimaName = nil,			--动画名字
	m_nValue = nil,				--数字
	m_nLastRound = nil,			--回合数
}

-------------------------------------公有方法模块--------------------------------------

--@brief	生成一个子弹特效
--@param	tBullet:使用此效果的子弹
function WFlyLockEffect:buildEffect(tBullet)
	local effect = {}
	setmetatable(effect, {__index=function( tTable,sKey )
		if WFlyLockEffect[sKey] ~= nil then
			return WFlyLockEffect[sKey]
		elseif tTable.m_tBullet ~= nil then
			return tTable.m_tBullet[sKey]
		else
			return nil
		end
	end})
	effect.m_tBullet=tBullet

	return effect
end

--@brief	设置特效信息
function WFlyLockEffect:setFlyLockEffectInfo(lastRound,value,sAnimName)
	self.m_nLastRound = lastRound
	self.m_nValue = value
	self.m_sAnimaName = sAnimName
end

--@brief	检查伤害
--@return	#1:受伤的人物列表
--@return	#2:受伤值
function WFlyLockEffect:checkHurt()
	local tHurtCharas, tHurtValues, tDistance, tCritType, tHurtRatio = self.m_tBullet:checkHurt()

	for id,hero in pairs(tHurtCharas) do
        if tHurtValues[id] > 0 then
            if not hero.m_bIsImmunity and (hero:getIsHero() or (WBattleGlobal:getCurrent():isSingleStage())) then
                if hero.m_tHurtAnim ~= nil and hero.m_tHurtAnim[self.m_sAnimaName] ~= nil then
                    hero:addBuff("m_nDebuffFlyLockRound",self.m_nLastRound,nil,nil,nil,nil,nil)
                else
                    hero:addBuff("m_nDebuffFlyLockRound",self.m_nLastRound,nil,nil,nil,nil,self.m_sAnimaName)
                end
            end
        end
	end

	return tHurtCharas, tHurtValues, tDistance, tCritType, tHurtRatio
end

--@brief	更新位置
function WFlyLockEffect:updatePosition()
	self.m_tBullet:updatePosition()
end

--@brief	子弹爆炸
function WFlyLockEffect:explode()
    WZLog("explode 6")
	self.m_tBullet:explode()
end

--@brief	子弹挖坑
function WFlyLockEffect:DigHole()
    WZLog("DigHole 6")
	self.m_tBullet:DigHole()
end

--@brief	子弹是否爆炸完毕
--@return	#1:true:是，false：否
function WFlyLockEffect:explodeIsEnd()
	return self.m_tBullet:explodeIsEnd()
end

--@brief	获得原始子弹表
function WFlyLockEffect:getBaseBullet()
	return self.m_tBullet.getBaseBullet and self.m_tBullet:getBaseBullet() or self.m_tBullet
end
-------------------------------------私有方法模块--------------------------------------

-------------------------------------封印特效表--------------------------------------
--@brief	封印特效表
WSealEffect = {
	m_tBullet = nil,			--子弹基础表
	m_sAnimaName = nil,			--动画名字
	m_nValue = nil,				--数字
	m_nLastRound = nil,			--回合数
}

-------------------------------------公有方法模块--------------------------------------

--@brief	生成一个子弹特效
--@param	tBullet:使用此效果的子弹
function WSealEffect:buildEffect(tBullet)
	local effect = {}
	setmetatable(effect, {__index=function( tTable,sKey )
		if WSealEffect[sKey] ~= nil then
			return WSealEffect[sKey]
		elseif tTable.m_tBullet ~= nil then
			return tTable.m_tBullet[sKey]
		else
			return nil
		end
	end})
	effect.m_tBullet=tBullet

	return effect
end

--@brief	设置特效信息
function WSealEffect:setSealEffectInfo(lastRound,value,sAnimName)
	self.m_nLastRound = lastRound
	self.m_nValue = value
	self.m_sAnimaName = sAnimName
end

--@brief	检查伤害
--@return	#1:受伤的人物列表
--@return	#2:受伤值
function WSealEffect:checkHurt()
	local tHurtCharas, tHurtValues, tDistance, tCritType, tHurtRatio = self.m_tBullet:checkHurt()

	for id,hero in pairs(tHurtCharas) do
        if tHurtValues[id] > 0 then
            if not hero.m_bIsImmunity and (hero:getIsHero() or (WBattleGlobal:getCurrent():isSingleStage())) then
                if hero.m_tHurtAnim ~= nil and hero.m_tHurtAnim[self.m_sAnimaName] ~= nil then
                    hero:addBuff("m_nDebuffSealRound",self.m_nLastRound,nil,nil,nil,nil,nil)
                else
                    hero:addBuff("m_nDebuffSealRound",self.m_nLastRound,nil,nil,nil,nil,self.m_sAnimaName)
                end
            end
        end
	end

	return tHurtCharas, tHurtValues, tDistance, tCritType, tHurtRatio
end

--@brief	更新位置
function WSealEffect:updatePosition()
	self.m_tBullet:updatePosition()
end

--@brief	子弹爆炸
function WSealEffect:explode()
    WZLog("explode 7")
	self.m_tBullet:explode()
end

--@brief	子弹挖坑
function WSealEffect:DigHole()
    WZLog("DigHole 7")
	self.m_tBullet:DigHole()
end

--@brief	子弹是否爆炸完毕
--@return	#1:true:是，false：否
function WSealEffect:explodeIsEnd()
	return self.m_tBullet:explodeIsEnd()
end

--@brief	获得原始子弹表
function WSealEffect:getBaseBullet()
	return self.m_tBullet.getBaseBullet and self.m_tBullet:getBaseBullet() or self.m_tBullet
end
-------------------------------------私有方法模块--------------------------------------

-------------------------------------核弹特效表--------------------------------------
--@brief	核弹特效表
WAtomicBombEffect = {
	m_tBullet = nil,			--子弹基础表
}

-------------------------------------公有方法模块--------------------------------------

--@brief	生成一个子弹特效
--@param	tBullet:使用此效果的子弹
function WAtomicBombEffect:buildEffect(tBullet)
    WZLog("WAtomicBombEffect:buildEffect")
	local effect = {}
	setmetatable(effect, {__index=function( tTable,sKey )
		if WAtomicBombEffect[sKey] ~= nil then
			return WAtomicBombEffect[sKey]
		elseif tTable.m_tBullet ~= nil then
			return tTable.m_tBullet[sKey]
		else
			return nil
		end
	end})
	effect.m_tBullet=tBullet

	if effect:getBaseBullet().m_tExplodeElement then
		effect:getBaseBullet().m_tExplodeElement:removeElement()
		effect:getBaseBullet().m_tExplodeElement = nil
	end

    effect:getBaseBullet().m_tExplodeElement = WBulletExplodeElement:create( effect:getBaseBullet(), BulletEffectId.EFFECT_NBOMB)

	return effect
end

--@brief	检查伤害
--@return	#1:受伤的人物列表
--@return	#2:受伤值
function WAtomicBombEffect:checkHurt()
	return self.m_tBullet:checkHurt()
end

--@brief	更新位置
function WAtomicBombEffect:updatePosition()
	self.m_tBullet:updatePosition()
end

--@brief	子弹爆炸
function WAtomicBombEffect:explode()
    WZLog("explode 8")
	self.m_tBullet:explode()
end

--@brief	子弹挖坑
function WAtomicBombEffect:DigHole()
    WZLog("WAtomicBombEffect:DigHole one")
	if self:getOwnerChara():getCanDigHole() then
		local explodeCilcle = WBattleGlobal:getCurrent().m_tAtomExplode
		if explodeCilcle and explodeCilcle:count() > 1 then
            WZLog("WAtomicBombEffect:DigHole three")
			local breakCircle = tolua.cast(explodeCilcle:objectAtIndex(0),"WDMemoryImage")
			local breakCircleMark = tolua.cast(explodeCilcle:objectAtIndex(1),"WDMemoryImage")
			if not BattleMapManager:drawBroke(self.m_mover:getMoverPosition(),breakCircle,breakCircleMark,self:getOwnerChara():getRectForBulletExplodeBomb().x,self:getOwnerChara():getRectForBulletExplodeBomb().y) then
				WZLog("Atomic bomb terrain broke failed",self.m_mover:getMoverPosition().x,self.m_mover:getMoverPosition().y)
				return
			end
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
function WAtomicBombEffect:explodeIsEnd()
	return self.m_tBullet:explodeIsEnd()
end

--@brief	获得原始子弹表
function WAtomicBombEffect:getBaseBullet()
	return self.m_tBullet.getBaseBullet and self.m_tBullet:getBaseBullet() or self.m_tBullet
end
-------------------------------------私有方法模块--------------------------------------


-------------------------------------锁足特效表--------------------------------------
--@brief	锁足特效表
WMoveLockEffect = {
	m_tBullet = nil,			--子弹基础表
	m_sAnimaName = nil,			--动画名字
	m_nValue = nil,				--数字
	m_nLastRound = nil,			--回合数
}

-------------------------------------公有方法模块--------------------------------------

--@brief	生成一个子弹特效
--@param	tBullet:使用此效果的子弹
function WMoveLockEffect:buildEffect(tBullet)
	local effect = {}
	setmetatable(effect, {__index=function( tTable,sKey )
		if WMoveLockEffect[sKey] ~= nil then
			return WMoveLockEffect[sKey]
		elseif tTable.m_tBullet ~= nil then
			return tTable.m_tBullet[sKey]
		else
			return nil
		end
	end})
	effect.m_tBullet=tBullet

	return effect
end

--@brief	设置特效信息
function WMoveLockEffect:setMoveLockEffectInfo(lastRound,value,sAnimName)
	self.m_nLastRound = lastRound
	self.m_nValue = value
	self.m_sAnimaName = sAnimName
end

--@brief	检查伤害
--@return	#1:受伤的人物列表
--@return	#2:受伤值
function WMoveLockEffect:checkHurt()
	local tHurtCharas, tHurtValues, tDistance, tCritType, tHurtRatio = self.m_tBullet:checkHurt()

	for id,hero in pairs(tHurtCharas) do
        if tHurtValues[id] > 0 then
            if not hero.m_bIsImmunity and (hero:getIsHero() or (WBattleGlobal:getCurrent():isSingleStage())) then
                if hero.m_tHurtAnim ~= nil and hero.m_tHurtAnim[self.m_sAnimaName] ~= nil then
                    hero:addBuff("m_nDebuffMoveLockRound",self.m_nLastRound,nil,nil,nil,nil,nil)
                else
                    hero:addBuff("m_nDebuffMoveLockRound",self.m_nLastRound,nil,nil,nil,nil,self.m_sAnimaName)
                end
            end
        end
	end

	return tHurtCharas, tHurtValues, tDistance, tCritType, tHurtRatio
end

--@brief	更新位置
function WMoveLockEffect:updatePosition()
	self.m_tBullet:updatePosition()
end

--@brief	子弹爆炸
function WMoveLockEffect:explode()
    WZLog("explode 9")
	self.m_tBullet:explode()
end

--@brief	子弹挖坑
function WMoveLockEffect:DigHole()
    WZLog("DigHole 9")
	self.m_tBullet:DigHole()
end

--@brief	子弹是否爆炸完毕
--@return	#1:true:是，false：否
function WMoveLockEffect:explodeIsEnd()
	return self.m_tBullet:explodeIsEnd()
end

--@brief	获得原始子弹表
function WMoveLockEffect:getBaseBullet()
	return self.m_tBullet.getBaseBullet and self.m_tBullet:getBaseBullet() or self.m_tBullet
end
-------------------------------------私有方法模块--------------------------------------

-------------------------------------眩晕特效表--------------------------------------
--@brief	眩晕特效表
WVertigoEffect = {
	m_tBullet = nil,			--子弹基础表
	m_sAnimaName = nil,			--动画名字
	m_nValue = nil,				--数字
	m_nLastRound = nil,			--回合数
}

-------------------------------------公有方法模块--------------------------------------


--@brief	生成一个子弹特效
--@param	tBullet:使用此效果的子弹
function WVertigoEffect:buildEffect(tBullet)
	local effect = {}
	setmetatable(effect, {__index=function( tTable,sKey )
		if WVertigoEffect[sKey] ~= nil then
			return WVertigoEffect[sKey]
		elseif tTable.m_tBullet ~= nil then
			return tTable.m_tBullet[sKey]
		else
			return nil
		end
	end})
	effect.m_tBullet=tBullet

	return effect
end

--@brief	设置特效信息
function WVertigoEffect:setVertigoEffectInfo(lastRound,value,sAnimName)
	self.m_nLastRound = lastRound
	self.m_nValue = value
	self.m_sAnimaName = sAnimName
end

--@brief	检查伤害
--@return	#1:受伤的人物列表
--@return	#2:受伤值
function WVertigoEffect:checkHurt()
	local tHurtCharas, tHurtValues, tDistance, tCritType, tHurtRatio = self.m_tBullet:checkHurt()

	for id,hero in pairs(tHurtCharas) do
        if tHurtValues[id] > 0 then
            if not hero.m_bIsImmunity and (hero:getIsHero() or (WBattleGlobal:getCurrent():isSingleStage())) then
                if hero.m_tHurtAnim ~= nil and hero.m_tHurtAnim[self.m_sAnimaName] ~= nil then
                    hero:addBuff("m_nDebuffVertigoRound",self.m_nLastRound,nil,nil,nil,nil,nil)
                else
                    hero:addBuff("m_nDebuffVertigoRound",self.m_nLastRound,nil,nil,nil,nil,self.m_sAnimaName)
                end
            end
        end
	end

	return tHurtCharas, tHurtValues, tDistance, tCritType, tHurtRatio
end

--@brief	更新位置
function WVertigoEffect:updatePosition()
	self.m_tBullet:updatePosition()
end

--@brief	子弹爆炸
function WVertigoEffect:explode()
    WZLog("explode 10")
	self.m_tBullet:explode()
end

--@brief	子弹挖坑
function WVertigoEffect:DigHole()
    WZLog("DigHole 10")
	self.m_tBullet:DigHole()
end

--@brief	子弹是否爆炸完毕
--@return	#1:true:是，false：否
function WVertigoEffect:explodeIsEnd()
	return self.m_tBullet:explodeIsEnd()
end

--@brief	获得原始子弹表
function WVertigoEffect:getBaseBullet()
	return self.m_tBullet.getBaseBullet and self.m_tBullet:getBaseBullet() or self.m_tBullet
end
-------------------------------------私有方法模块--------------------------------------


-------------------------------------击退特效表--------------------------------------
--@brief	击退特效表
WRepulseEffect = {
	m_tBullet = nil,			--子弹基础表
	m_sAnimaName = nil,			--动画名字
	m_nValue = nil,				--数字
	m_nLastRound = nil,			--回合数
}

-------------------------------------公有方法模块--------------------------------------


--@brief	生成一个子弹特效
--@param	tBullet:使用此效果的子弹
function WRepulseEffect:buildEffect(tBullet)
	local effect = {}
	setmetatable(effect, {__index=function( tTable,sKey )
		if WRepulseEffect[sKey] ~= nil then
			return WRepulseEffect[sKey]
		elseif tTable.m_tBullet ~= nil then
			return tTable.m_tBullet[sKey]
		else
			return nil
		end
	end})
	effect.m_tBullet=tBullet

	if effect:getBaseBullet().m_tExplodeElement then
		effect:getBaseBullet().m_tExplodeElement:removeElement()
		effect:getBaseBullet().m_tExplodeElement = nil
	end

	return effect
end

--@brief	设置特效信息
function WRepulseEffect:setRepulseEffectInfo(lastRound,value,sAnimName)
	self.m_nLastRound = lastRound
	self.m_nValue = value
	self.m_sAnimaName = sAnimName
end

--@brief	检查伤害
--@return	#1:受伤的人物列表
--@return	#2:受伤值
function WRepulseEffect:checkHurt()
    WZLog("WRepulseEffect:checkHurt")
	local tHurtCharas, tHurtValues, tDistance, tCritType, tHurtRatio = self.m_tBullet:checkHurt()

	local bulletPos = self:getAnimation():getPosition()
	for id,hero in pairs(tHurtCharas) do
        if tHurtValues[id] > 0 then
            if not hero.m_bIsImmunity and (hero:getIsHero() or (WBattleGlobal:getCurrent():isSingleStage())) then
                local heroPos = hero:getAnimation():getPosition()
                if heroPos.x > bulletPos.x then
                    hero:setRepulse(math.floor(self.m_nValue/10))
                else
                    hero:setRepulse(math.ceil(-1*self.m_nValue/10))
                end
            end
        end
	end

	return tHurtCharas, tHurtValues, tDistance, tCritType, tHurtRatio
end

--@brief	更新位置
function WRepulseEffect:updatePosition()
	self.m_tBullet:updatePosition()
end

--@brief	子弹爆炸
function WRepulseEffect:explode()
    WZLog("explode 11")
	self.m_tBullet:explode()
end

--@brief	子弹挖坑
function WRepulseEffect:DigHole()
    WZLog("DigHole 11")
	self.m_tBullet:DigHole()
end

--@brief	子弹是否爆炸完毕
--@return	#1:true:是，false：否
function WRepulseEffect:explodeIsEnd()
	return self.m_tBullet:explodeIsEnd()
end

--@brief	获得原始子弹表
function WRepulseEffect:getBaseBullet()
	return self.m_tBullet.getBaseBullet and self.m_tBullet:getBaseBullet() or self.m_tBullet
end
-------------------------------------私有方法模块--------------------------------------

-------------------------------------免坑特效表--------------------------------------
--@brief	免坑特效表
WNoHoleEffect = {
	m_tBullet = nil,			--子弹基础表
	m_nRandNum = nil,			--随机数
	m_bNeedHole = nil,			--是否挖坑
}

-------------------------------------公有方法模块--------------------------------------


--@brief	生成一个子弹特效
--@param	tBullet:使用此效果的子弹
function WNoHoleEffect:buildEffect(tBullet)
    WZLog("WNoHoleEffect:buildEffect")
	local effect = {}
	setmetatable(effect, {__index=function( tTable,sKey )
		if WNoHoleEffect[sKey] ~= nil then
			return WNoHoleEffect[sKey]
		elseif tTable.m_tBullet ~= nil then
			return tTable.m_tBullet[sKey]
		else
			return nil
		end
	end})
	effect.m_tBullet=tBullet
	effect.m_bNeedHole = true

	return effect
end

--@brief	设置特效信息
function WNoHoleEffect:setNoHoleEffectInfo(nRandNum)
	self.m_nRandNum = nRandNum
end

--@brief	检查伤害
--@return	#1:受伤的人物列表
--@return	#2:受伤值
function WNoHoleEffect:checkHurt()
	local tHurtCharas, tHurtValues, tDistance, tCritType, tHurtRatio = self.m_tBullet:checkHurt()

	for id,hero in pairs(tHurtCharas) do
        if tHurtValues[id] >= 0 then
            if hero.m_tWeaponSkillType ~= nil then
                for i,nT in ipairs(hero.m_tWeaponSkillType) do
                    if nT == 17 then
                        local nRandNum = WBattleGlobal:getCurrent():getCurRandNum()
                        table.insert(WBattleGlobal:getCurrent().m_tTargetRandomList, {[1]=hero:getBattleId(), [2]=nT, [3]=WBattleGlobal:getCurrent().m_nRandNumIndex})
                        WZLog("WNoHoleEffect:checkHurt one", hero:getBattleId(), WBattleGlobal:getCurrent().m_nRandNumIndex,nRandNum,nT)
                        if nT == 17 and nRandNum < hero.m_tWeaponSkillChance[i] then
                            WZLog("WNoHoleEffect:checkHurt two")
                            self.m_bNeedHole = false
                            BattleShowHeroUse:showUseName(hero:getPosition(),hero.m_tWeaponSkillName[i],hero)
                            --break
                        end
                    end
                end
            end
        end
	end

	return tHurtCharas, tHurtValues, tDistance, tCritType, tHurtRatio
end

--@brief	更新位置
function WNoHoleEffect:updatePosition()
	self.m_tBullet:updatePosition()
end

--@brief	子弹爆炸
function WNoHoleEffect:explode()
    WZLog("explode 12")
	self.m_tBullet:explode(self.m_bNeedHole)
end

--@brief	挖坑
function WNoHoleEffect:DigHole()
    WZLog("DigHole 12")
	if self.m_bNeedHole then
		self.m_tBullet:DigHole()
	end
end

--@brief	子弹是否爆炸完毕
--@return	#1:true:是，false：否
function WNoHoleEffect:explodeIsEnd()
	return self.m_tBullet:explodeIsEnd()
end

--@brief	获得原始子弹表
function WNoHoleEffect:getBaseBullet()
	return self.m_tBullet.getBaseBullet and self.m_tBullet:getBaseBullet() or self.m_tBullet
end
-------------------------------------私有方法模块--------------------------------------

-------------------------------------吸收特效表--------------------------------------
--@brief	吸收特效表
WAbsorbEffect = {
	m_tBullet = nil,			--子弹基础表
	m_nRandNum = nil,			--随机数
    m_tImmunityHero = nil,			--免疫的英雄表
}

-------------------------------------公有方法模块--------------------------------------


--@brief	生成一个子弹特效
--@param	tBullet:使用此效果的子弹
function WAbsorbEffect:buildEffect(tBullet)
	local effect = {}
	setmetatable(effect, {__index=function( tTable,sKey )
		if WAbsorbEffect[sKey] ~= nil then
			return WAbsorbEffect[sKey]
		elseif tTable.m_tBullet ~= nil then
			return tTable.m_tBullet[sKey]
		else
			return nil
		end
	end})
	effect.m_tBullet=tBullet

	return effect
end

--@brief	设置特效信息
function WAbsorbEffect:setAbsorbEffectInfo(nRandNum)
	self.m_nRandNum = nRandNum
end

--@brief	检查伤害
--@return	#1:受伤的人物列表
--@return	#2:受伤值
function WAbsorbEffect:checkHurt()
	local tHurtCharas, tHurtValues, tDistance, tCritType, tHurtRatio = self.m_tBullet:checkHurt()

    local isAbsorb = false
    if self.m_tImmunityHero == nil then
        self.m_tImmunityHero = {}
    end

	for id,hero in pairs(tHurtCharas) do
        if tHurtValues[id] >= 0 then
            if hero.m_tWeaponSkillType ~= nil then
                for i,nT in ipairs(hero.m_tWeaponSkillType) do
                    if nT == 18 then
                        local nRandNum = WBattleGlobal:getCurrent():getCurRandNum()
                        table.insert(WBattleGlobal:getCurrent().m_tTargetRandomList, {[1]=hero:getBattleId(), [2]=nT, [3]=WBattleGlobal:getCurrent().m_nRandNumIndex})
                        WZLog("WAbsorbEffect:checkHurt ", hero:getBattleId(), WBattleGlobal:getCurrent().m_nRandNumIndex,nRandNum,nT)
                        if not hero.m_bIsImmunity and nT == 18 and nRandNum < hero.m_tWeaponSkillChance[i] then
                            isAbsorb = true
                            hero.m_bIsAbsorb = true
                            table.insert(self.m_tImmunityHero,hero)
                            tHurtValues[id] = 0
                            BattleShowHeroUse:showUseName(hero:getPosition(),hero.m_tWeaponSkillName[i],hero)
                            --break
                        end
                    end
                end

            end
        end
	end

	return tHurtCharas, tHurtValues, tDistance, tCritType, tHurtRatio
end

--@brief	更新位置
function WAbsorbEffect:updatePosition()
	self.m_tBullet:updatePosition()
end

--@brief	子弹爆炸
function WAbsorbEffect:explode()
    WZLog("explode 13")
	self.m_tBullet:explode()

    --[[
    if self.m_tImmunityHero ~= nil then
        for i,hero in pairs(self.m_tImmunityHero) do
            hero.m_bIsAbsorb = nil
        end
    end
    --]]
    self.m_tImmunityHero = nil
end

--@brief	子弹挖坑
function WAbsorbEffect:DigHole()
    WZLog("DigHole 13")
	self.m_tBullet:DigHole()
end

--@brief	子弹是否爆炸完毕
--@return	#1:true:是，false：否
function WAbsorbEffect:explodeIsEnd()
	return self.m_tBullet:explodeIsEnd()
end

--@brief	获得原始子弹表
function WAbsorbEffect:getBaseBullet()
	return self.m_tBullet.getBaseBullet and self.m_tBullet:getBaseBullet() or self.m_tBullet
end
-------------------------------------私有方法模块--------------------------------------


-------------------------------------免疫特效表--------------------------------------
--@brief	免疫特效表
WImmunityEffect = {
	m_tBullet = nil,			--子弹基础表
	m_nRandNum = nil,			--随机数
	m_tImmunityHero = nil,			--免疫的英雄表
}

-------------------------------------公有方法模块--------------------------------------


--@brief	生成一个子弹特效
--@param	tBullet:使用此效果的子弹
function WImmunityEffect:buildEffect(tBullet)
	local effect = {}
	setmetatable(effect, {__index=function( tTable,sKey )
		if WImmunityEffect[sKey] ~= nil then
			return WImmunityEffect[sKey]
		elseif tTable.m_tBullet ~= nil then
			return tTable.m_tBullet[sKey]
		else
			return nil
		end
	end})
	effect.m_tBullet=tBullet

	return effect
end

--@brief	设置特效信息
function WImmunityEffect:setImmunityEffectInfo(nRandNum)
	self.m_nRandNum = nRandNum
end

--@brief	检查伤害
--@return	#1:受伤的人物列表
--@return	#2:受伤值
function WImmunityEffect:checkHurt()
	local tHurtCharas, tHurtValues, tDistance, tCritType, tHurtRatio = self.m_tBullet:checkHurt()

	if self.m_tImmunityHero == nil then
		self.m_tImmunityHero = {}
	end

	for id,hero in pairs(tHurtCharas) do
        if tHurtValues[id] >= 0 then
            if hero.m_tWeaponSkillType ~= nil then
                for i,nT in ipairs(hero.m_tWeaponSkillType) do
                    if nT == 19 then
                        local nRandNum = WBattleGlobal:getCurrent():getCurRandNum()
                        table.insert(WBattleGlobal:getCurrent().m_tTargetRandomList, {[1]=hero:getBattleId(), [2]=nT, [3]=WBattleGlobal:getCurrent().m_nRandNumIndex})
                        WZLog("WImmunityEffect:checkHurt one", hero:getBattleId(), WBattleGlobal:getCurrent().m_nRandNumIndex,nRandNum,nT)
                        if nT == 19 and nRandNum < hero.m_tWeaponSkillChance[i] then
                            WZLog("WImmunityEffect:checkHurt two")
                            hero.m_bIsImmunity = true
                            tHurtValues[id]	= 0
                            table.insert(self.m_tImmunityHero,hero)
                            BattleShowHeroUse:showUseName(hero:getPosition(),hero.m_tWeaponSkillName[i],hero)
                            --break

                            hero:clearAllBuff()
                        end
                    end
                end
            end
        end
	end

	return tHurtCharas, tHurtValues, tDistance, tCritType, tHurtRatio
end

--@brief	更新位置
function WImmunityEffect:updatePosition()
	self.m_tBullet:updatePosition()
end

--@brief	子弹爆炸
function WImmunityEffect:explode()
    WZLog("explode 14")
	self.m_tBullet:explode()

    --[[
	if self.m_tImmunityHero ~= nil then
		for i,hero in pairs(self.m_tImmunityHero) do
			hero.m_bIsImmunity = nil
		end
	end
    --]]
	self.m_tImmunityHero = nil
end

--@brief	子弹挖坑
function WImmunityEffect:DigHole()
    WZLog("DigHole 14")
	self.m_tBullet:DigHole()
end

--@brief	子弹是否爆炸完毕
--@return	#1:true:是，false：否
function WImmunityEffect:explodeIsEnd()
	return self.m_tBullet:explodeIsEnd()
end

--@brief	获得原始子弹表
function WImmunityEffect:getBaseBullet()
	return self.m_tBullet.getBaseBullet and self.m_tBullet:getBaseBullet() or self.m_tBullet
end
-------------------------------------私有方法模块--------------------------------------

-------------------------------------WBulletBackFire--------------------------------------
WBulletBackFire =
{
	m_nId = nil,
	m_tElement = nil,
	m_tTrackNode = nil,
}

function WBulletBackFire:create(tPos,nId,name)
	local obj = {}
	setmetatable(obj, { __index = WBulletBackFire } )
	obj.m_nId = nId or BulletEffectId.EFFECT_DEFAULT
	obj:createElement(tPos,obj.m_nId,name)
	return obj
end

--@brief	创建后面的烟火
--@return	#1:后面的烟火
function WBulletBackFire:createElement(tPos,nId,name)
    WZLog("WBulletBackFire:createElement",nId, name)
    tPos = tPos or BattleCommon:getPointTable(0,0)
	local backFireName = ""
	local isNameSet = false
	local skillList = WBattleGlobal:getCurrent().m_tCurRoundSkillId
	if skillList and #skillList > 0 then
		for i,id in ipairs(skillList) do
			local skill = CopyTable(GDatatab_skill["id_"..id])
			WZLog("WBulletBackFire:createElement one", skill.skill_type)
			if skill.skill_type == 0 or skill.skill_type == -1 or skill.skill_type == 2 then
				WZLog("WBulletBackFire:createElement two", skill.skill_type, skill.jntw)
				if skill.jntw == -1 then

					local particleName = name
					if tostring(name) == "19" then
						particleName = "019"
					end

					if tostring(name) == "233" then
						particleName = ""
					end
					
					local isFileExist = false
					if name then
						backFireName = "battle/particle/bullet_" .. name .. "_tuowei.plist"
						isFileExist = WZFileUtil:isFileExist(backFireName)
					end
					if isFileExist ~= true and name then
						backFireName = "battle/particle/boss_bullet_" .. name .. "_tuowei.plist"
						isFileExist = WZFileUtil:isFileExist(backFireName)
					end
					if isFileExist ~= true then
						backFireName = "battle/particle/skill_baozha_tuowei_feidan.plist"
					end
					isNameSet = true
					WZLog("WBulletBackFire:createElement four", name, tostring(isTuoWei), backFireName)
				elseif skill.jntw ~= 0 then
					isNameSet = true
					backFireName = "battle/particle/" .. skill.jntw .. ".plist"
				end
				break
			end
		end
	end

	WZLog("WBulletBackFire:createElement three", isNameSet, backFireName)
	if isNameSet then

	elseif nId == BulletEffectId.EFFECT_DEFAULT then
		local isFileExist = false
		if name then
			backFireName = "battle/particle/bullet_" .. name .. "_tuowei.plist"
			isFileExist = WZFileUtil:isFileExist(backFireName)
		end
		if isFileExist ~= true and name then
			backFireName = "battle/particle/boss_bullet_" .. name .. "_tuowei.plist"
			isFileExist = WZFileUtil:isFileExist(backFireName)
		end
		if isFileExist ~= true then
			backFireName = "battle/particle/skill_baozha_tuowei_feidan.plist"
		end

    elseif nId == BulletEffectId.EFFECT_DEFAULT_THROW then
        backFireName = "battle/particle/skill_baozha_tuowei_touzhi.plist"
	elseif self.m_nId == BulletEffectId.EFFECT_BIGSKILL then
		backFireName = "battle/particle/power_lizi_huo.plist" --"battle/particle/dzzdlz_1.plist"
    elseif self.m_nId == BulletEffectId.EFFECT_BIGSKILL_2 then
        backFireName = "battle/particle/power_lizi_huo.plist" --"battle/particle/dzzdlz_1.plist"
    elseif self.m_nId == BulletEffectId.EFFECT_BIGSKILL_3 then
        backFireName = "battle/particle/power_lizi_huo.plist" --"battle/particle/dzzdlz_1.plist"
    elseif self.m_nId == BulletEffectId.EFFECT_BIGSKILL_4 then
        backFireName = "battle/particle/power_lizi_huo.plist" --"battle/particle/dzzdlz_1.plist"
	elseif nId == BulletEffectId.EFFECT_NBOMB  then
		backFireName = "battle/particle/skill_baozha_tuowei_feidan.plist"
	elseif nId == BulletEffectId.EFFECT_ADDTIMES then
		backFireName = "battle/particle/skill_ljtw_01.plist"
	elseif nId == BulletEffectId.EFFECT_DIVIDE then
		backFireName = "battle/particle/skill_baozha_tuowei_feidan.plist"
    elseif nId == BulletEffectId.EFFECT_DIVIDE_THROW then
        backFireName = "battle/particle/skill_baozha_tuowei_touzhi.plist"
	elseif nId == BulletEffectId.EFFECT_FROZEN then
		backFireName = "battle/particle/skills_bdtx_tuowei01.plist"
    elseif self.m_nId == BulletEffectId.EFFECT_FLY then
        backFireName = "battle/particle/skills_fei_01.plist"
    elseif self.m_nId == BulletEffectId.EFFECT_POISON then
        backFireName = "battle/particle/skills_zhongdutx_tuowei01.plist"
    elseif self.m_nId == BulletEffectId.EFFECT_SILENT then
        backFireName = "battle/particle/skills_chenmotx_tuowei01.plist"
    elseif self.m_nId == BulletEffectId.EFFECT_BIND then
        backFireName = "battle/particle/skills_shufutx_tuowei01.plist"
    elseif self.m_nId == BulletEffectId.EFFECT_MIST then
      	backFireName = "battle/particle/skill_zm_tuowei.plist"
    elseif self.m_nId == BulletEffectId.EFFECT_BIGSKILL_3 then
        backFireName = "battle/particle/skill_power2_tuowei.plist"
    elseif self.m_nId == BulletEffectId.EFFECT_BIGSKILL_4 then
        backFireName = "battle/particle/skill_power2red_tuowei.plist"
    elseif self.m_nId == BulletEffectId.EFFECT_CURE then
    	backFireName = "battle/particle/skill_zhiliaodan_tuowei.plist"
    --其他粒子效果
    elseif self.m_nId == BulletEffectId.BOSS2_MOVE then
        backFireName = "battle/particle/skills_zuduiboss2_fly_lizi.plist"
    elseif self.m_nId == BulletEffectId.BOSS2_WHEEL_MOVE then
        backFireName = "battle/particle/skills_zuduiboss2_zidan_lizi.plist"
    elseif self.m_nId == BulletEffectId.WORLD_BOSS1_ICE then
        backFireName = "battle/particle/SJboss_skill2_tuowei.plist"
    elseif self.m_nId == BulletEffectId.BOSS3_ATTACK then
        backFireName = "battle/particle/monsterskill_zuduiboss3_skill1_tuowei.plist"
    elseif self.m_nId == BulletEffectId.BOSS4_WIND then
        backFireName = "battle/particle/skills_cj_sjbs_01.plist"
    elseif self.m_nId == BulletEffectId.BOSS4_WIND1 then
        backFireName = "battle/particle/skills_cj_sjbs_02.plist"
    elseif self.m_nId == BulletEffectId.BOSS4_WIND2 then
        backFireName = "battle/particle/skills_cj_sjbs_03.plist"
    elseif self.m_nId == BulletEffectId.BOSS4_WIND3 then
        backFireName = "battle/particle/skills_cj_sjbs_04.plist"
    elseif self.m_nId == BulletEffectId.BOSS4_BULLET_FIRE then
        backFireName = "battle/particle/skill_boss4_zdtw_01.plist"
    elseif self.m_nId == BulletEffectId.BOSS6_BULLET_FIRE_A then
        backFireName = "battle/particle/boss_bullet_1006_tuowei.plist"
    elseif self.m_nId == BulletEffectId.BOSS6_BULLET_FIRE_B then
        backFireName = "battle/particle/boss_bullet_1007_tuowei.plist"
    elseif self.m_nId == BulletEffectId.BOSS8_SINGLE_BULLET_FIRE then
        backFireName = "battle/particle/boss_bullet_1008_tuowei.plist"
    --boss 子弹拖尾 读取配置(非id类型)
    elseif string.find(self.m_nId,"boss_") then
		backFireName = "battle/particle/"..self.m_nId..".plist"
    else
        backFireName = "battle/particle/skill_baozha_tuowei_feidan.plist"
	end

    backFire = CCParticleSystemQuad:create(backFireName)
	backFire:setDuration(kCCParticleDurationInfinity)
	backFire:retain()
    backFire:setPositionType(kCCPositionTypeRelative)
    backFire:setAutoRemoveOnFinish(true)
	backFire:setPositionX(tPos.x)
    backFire:setPositionY(tPos.y)

    local particle = CCParticleBatchNode:createWithTexture(backFire:getTexture())
    particle:addChild(backFire)

	self.m_tElement = backFire
	self.m_tTrackNode = TrackNode:create(backFire)
end

function WBulletBackFire:getElement()
	return self.m_tElement
end

function WBulletBackFire:getTrackNode()
	return self.m_tTrackNode
end

function WBulletBackFire:removeElement()
	if self.m_tElement ~= nil then
		self.m_tElement:stopSystem()
		self.m_tElement:release()
		self.m_tElement = nil
	end
	self.m_tTrackNode = nil
end
-------------------------------------WBulletExplodeElement--------------------------------------
WBulletExplodeElement = {
	m_nId = nil,
	m_tExplodeElement = nil,
	m_nType = nil,			--1骨骼动画，2WZUIContainer？
}

--文件是否存在
function WBulletExplodeElement:isFileExist(sAninName,bUseDragonBone,folder)
	if folder == nil and string.find(sAninName,"boss_") and string.find(sAninName,"_effect") then
        folder = "battle/monsterSkill"
    end
    if folder == nil then
		for index,config in ipairs (ArmaturesFolderConfig) do
	        for name,folderName in pairs (config) do
	            if string.sub(sAninName, 1, string.len(name)) == name then
	                folder = folderName
	            end
	        end
	        if folder ~= nil then
	            break
	        end
	    end
	end

    local file
    if bUseDragonBone == true then
    	file = folder.."/"..sAninName .. ".xml"
    else
    	file = folder.."/"..sAninName .. ".json"
    end

    local isFileExist = WZFileUtil:isFileExist(file)
    WZLog("WBulletExplodeElement:isFileExist",sAninName,tostring(bUseDragonBone),folder, tostring(isFileExist))

    return isFileExist
end

function WBulletExplodeElement:create(tBullet,nId)
	local obj = {}
	setmetatable(obj, { __index = WBulletExplodeElement } )
	obj.m_nId = nId or BulletEffectId.EFFECT_DEFAULT
	obj:createElement(tBullet)
	return obj
end

function WBulletExplodeElement:createElement(tBullet)
    local quality, qualityNot = WBattleGlobal:getImageQuality()
    local resName = "skill_baozha"
    local isArmature = false

	if self.m_nId == BulletEffectId.EFFECT_DEFAULT then
        resName = "skill_baozha"
        isArmature = false

    elseif self.m_nId == BulletEffectId.EFFECT_BIGSKILL then
        resName = "skill_power" --"skill_power_hit_01"
        isArmature = false

    elseif self.m_nId == BulletEffectId.EFFECT_BIGSKILL_2 then
        resName = "skill_power" --"skill_power_hit_01"
        isArmature = false

    elseif self.m_nId == BulletEffectId.EFFECT_BIGSKILL_3 then
        resName = "skill_power" --"skill_power2"
        isArmature = false

    elseif self.m_nId == BulletEffectId.EFFECT_BIGSKILL_4 then
        resName = "skill_power" --"skill_power2red"
        isArmature = false

	elseif self.m_nId == BulletEffectId.EFFECT_NBOMB then
		resName = "skill_hedan"
        isArmature = false

	elseif self.m_nId == BulletEffectId.EFFECT_ADDTIMES then
		resName = "skill_baozha"
        isArmature = false

	elseif self.m_nId == BulletEffectId.EFFECT_DIVIDE then
		resName = "skill_baozha"
        isArmature = false

	elseif self.m_nId == BulletEffectId.EFFECT_FROZEN then
		resName = "skill_bingdongdan"
        isArmature = false

	elseif self.m_nId == BulletEffectId.EFFECT_POUND then
		resName = "skill_chongjidan"
        isArmature = false

    elseif self.m_nId == BulletEffectId.EFFECT_POWER then
    	resName = "skill_weili"
        isArmature = false

    elseif self.m_nId == BulletEffectId.EFFECT_POISON then
		resName = "skill_zd_bp"
        isArmature = false

    elseif self.m_nId == BulletEffectId.EFFECT_SILENT then
    	resName = "skill_chenmo"
        isArmature = false

    elseif self.m_nId == BulletEffectId.EFFECT_BIND then
		resName = "skill_shufu"
        isArmature = false
    elseif self.m_nId == BulletEffectId.EFFECT_TORNADO then
    	resName = "skill_longjuandan"
        isArmature = false

    elseif self.m_nId == BulletEffectId.EFFECT_SPATTER then
    	resName = "skill_jianshedan"
        isArmature = false
    elseif self.m_nId == BulletEffectId.EFFECT_MIST then
        resName = "skill_zm"
        isArmature = false
    elseif self.m_nId == BulletEffectId.EFFECT_CURE then
    	resName = "skill_zhiliaodan"
    	isArmature = false
     elseif self.m_nId == BulletEffectId.EFFECT_ATTRACT then
    	resName = "skill_citie"
    	isArmature = false
    elseif self.m_nId == BulletEffectId.BOSS8_BULLET_BOOM then
        resName = "boss_1009_shoot_effect"
        isArmature = false
    elseif self.m_nId == BulletEffectId.EFFECT_TRANSFER_POS then
    	resName = "skill_huanwei"
    	isArmature = false
    --其他爆炸特效
    elseif self.m_nId == BulletEffectId.BOSS3_ATTACK then
        resName = "monsterskill_zuduiboss3_skill1_jz_01"
        isArmature = false

	end

    local path1, path2, path3 = resName .. quality, resName .. qualityNot, resName
    local path = (self:isFileExist(path1,isArmature) and path1) or (self:isFileExist(path2,isArmature) and path2) or (self:isFileExist(path3,isArmature) and path3)

    WZLog("WBulletExplodeElement:createElement one", quality, qualityNot, self.m_nId, path, path1, path2)

    self.m_sPath = path
    self.m_bIsArmature =isArmature
    self.m_tExplodeElement = BattleAnimation:createAnimation(path,isArmature)
    self.m_tExplodeElement:getAnimNode():retain()
    self.m_tExplodeElement:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0))
    self.m_nType = 1
end

function WBulletExplodeElement:explode(tPos)
    local index = 1
    math.randomseed(tostring(os.time()):reverse():sub(1, 6))
    index = math.floor(math.random(1.01,4.99))
	if self.m_nId == BulletEffectId.EFFECT_DEFAULT then

		self.m_tExplodeElement:getAnimNode():setUseAbsCoordinate(true)
		self.m_tExplodeElement:getAnimNode():setScale(1)
		self.m_tExplodeElement:getAnimNode():setAbsPosition(GlobalMethod:ccp(tPos.x + 0,tPos.y + 0))
        self.m_tExplodeElement:getAnimNode():setAnimationName("animation")
        self.m_tExplodeElement:getAnimNode():setLoop(false)
        SceneBattle:getFrontLayer():addChild(self.m_tExplodeElement:getAnimNode())
	elseif self.m_nId == BulletEffectId.EFFECT_BIGSKILL then

        self.m_tExplodeElement:getAnimNode():setUseAbsCoordinate(true)
        self.m_tExplodeElement:getAnimNode():setScale(1.0)
        self.m_tExplodeElement:getAnimNode():setAbsPosition(GlobalMethod:ccp(tPos.x-10,tPos.y + 0))
        self.m_tExplodeElement:getAnimNode():setAnimationName("hit"..index)
        self.m_tExplodeElement:getAnimNode():setLoop(false)
        SceneBattle:getFrontLayer():addChild(self.m_tExplodeElement:getAnimNode())
        --self.m_tExplodeElement:play("0",false)

    elseif self.m_nId == BulletEffectId.EFFECT_BIGSKILL_2 then

        self.m_tExplodeElement:getAnimNode():setUseAbsCoordinate(true)
        self.m_tExplodeElement:getAnimNode():setScale(1.0)
        self.m_tExplodeElement:getAnimNode():setAbsPosition(GlobalMethod:ccp(tPos.x-10,tPos.y + 0))
        self.m_tExplodeElement:getAnimNode():setAnimationName("hit"..index)
        self.m_tExplodeElement:getAnimNode():setLoop(false)
        SceneBattle:getFrontLayer():addChild(self.m_tExplodeElement:getAnimNode())
        --self.m_tExplodeElement:play("0",false)

    elseif self.m_nId == BulletEffectId.EFFECT_BIGSKILL_3 then

        self.m_tExplodeElement:getAnimNode():setUseAbsCoordinate(true)
        self.m_tExplodeElement:getAnimNode():setScale(1.0)
        self.m_tExplodeElement:getAnimNode():setAbsPosition(GlobalMethod:ccp(tPos.x-10,tPos.y + 0))
        self.m_tExplodeElement:getAnimNode():setAnimationName("hit"..index)
        self.m_tExplodeElement:getAnimNode():setLoop(false)
        SceneBattle:getFrontLayer():addChild(self.m_tExplodeElement:getAnimNode())
        --self.m_tExplodeElement:play("0",false)

    elseif self.m_nId == BulletEffectId.EFFECT_BIGSKILL_4 then

        self.m_tExplodeElement:getAnimNode():setUseAbsCoordinate(true)
        self.m_tExplodeElement:getAnimNode():setScale(1.0)
        self.m_tExplodeElement:getAnimNode():setAbsPosition(GlobalMethod:ccp(tPos.x-10,tPos.y + 0))
        self.m_tExplodeElement:getAnimNode():setAnimationName("hit"..index)
        self.m_tExplodeElement:getAnimNode():setLoop(false)
        SceneBattle:getFrontLayer():addChild(self.m_tExplodeElement:getAnimNode())
        --self.m_tExplodeElement:play("0",false)

	elseif self.m_nId == BulletEffectId.EFFECT_NBOMB then

		--self.m_tExplodeElement:setScale(2)
        --self.m_tExplodeElement:setUseAbsCoordinate(true)
        --self.m_tExplodeElement:setAbsPosition(GlobalMethod:ccp( tPos.x , tPos.y + 30))
        --SceneBattle:getFrontLayer():addChild(self.m_tExplodeElement)
		self.m_tExplodeElement:getAnimNode():setUseAbsCoordinate(true)
		self.m_tExplodeElement:getAnimNode():setScale(1)
        self.m_tExplodeElement:getAnimNode():setAbsPosition(GlobalMethod:ccp(tPos.x - 0,tPos.y + 0))
        self.m_tExplodeElement:getAnimNode():setAnimationName("animation")
        self.m_tExplodeElement:getAnimNode():setLoop(false)
        SceneBattle:getFrontLayer():addChild(self.m_tExplodeElement:getAnimNode())

	elseif self.m_nId == BulletEffectId.EFFECT_ADDTIMES then

		self.m_tExplodeElement:getAnimNode():setUseAbsCoordinate(true)
		self.m_tExplodeElement:getAnimNode():setScale(1)
        self.m_tExplodeElement:getAnimNode():setAbsPosition(GlobalMethod:ccp(tPos.x + 0,tPos.y + 0))
        self.m_tExplodeElement:getAnimNode():setAnimationName("animation")
        self.m_tExplodeElement:getAnimNode():setLoop(false)
        SceneBattle:getFrontLayer():addChild(self.m_tExplodeElement:getAnimNode())

	elseif self.m_nId == BulletEffectId.EFFECT_DIVIDE then

		self.m_tExplodeElement:getAnimNode():setUseAbsCoordinate(true)
		self.m_tExplodeElement:getAnimNode():setScale(1)
        self.m_tExplodeElement:getAnimNode():setAbsPosition(GlobalMethod:ccp(tPos.x + 0,tPos.y + 0))
        self.m_tExplodeElement:getAnimNode():setAnimationName("animation")
        self.m_tExplodeElement:getAnimNode():setLoop(false)
        SceneBattle:getFrontLayer():addChild(self.m_tExplodeElement:getAnimNode())

	elseif self.m_nId == BulletEffectId.EFFECT_FROZEN then

        self.m_tExplodeElement:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0))
        self.m_tExplodeElement:getAnimNode():setUseAbsCoordinate(true)
        self.m_tExplodeElement:getAnimNode():setScale(1.0)
        self.m_tExplodeElement:getAnimNode():setAbsPosition(GlobalMethod:ccp(tPos.x -0 ,tPos.y + 0))
        self.m_tExplodeElement:getAnimNode():setAnimationName("hit")
        self.m_tExplodeElement:getAnimNode():setLoop(false)

        SceneBattle:getFrontLayer():addChild(self.m_tExplodeElement:getAnimNode())

	elseif self.m_nId == BulletEffectId.EFFECT_POUND then

		self.m_tExplodeElement:getAnimNode():setUseAbsCoordinate(true)
		self.m_tExplodeElement:getAnimNode():setScale(1)
        self.m_tExplodeElement:getAnimNode():setAbsPosition(GlobalMethod:ccp(tPos.x + 0 ,tPos.y + 0))
        self.m_tExplodeElement:getAnimNode():setAnimationName("hit")
        self.m_tExplodeElement:getAnimNode():setLoop(false)
        SceneBattle:getFrontLayer():addChild(self.m_tExplodeElement:getAnimNode())
    elseif self.m_nId == BulletEffectId.EFFECT_POWER then

        self.m_tExplodeElement:getAnimNode():setUseAbsCoordinate(true)
        self.m_tExplodeElement:getAnimNode():setScale(1.0)
        self.m_tExplodeElement:getAnimNode():setAbsPosition(GlobalMethod:ccp(tPos.x + 0 ,tPos.y + 0))
        self.m_tExplodeElement:getAnimNode():setAnimationName("hit")
        self.m_tExplodeElement:getAnimNode():setLoop(false)
        SceneBattle:getFrontLayer():addChild(self.m_tExplodeElement:getAnimNode())
    elseif self.m_nId == BulletEffectId.EFFECT_POISON then

        self.m_tExplodeElement:getAnimNode():setUseAbsCoordinate(true)
        self.m_tExplodeElement:getAnimNode():setScale(1)
        self.m_tExplodeElement:getAnimNode():setAbsPosition(GlobalMethod:ccp(tPos.x-5,tPos.y + 0))
        self.m_tExplodeElement:getAnimNode():setAnimationName("hit")
        self.m_tExplodeElement:getAnimNode():setLoop(false)
        SceneBattle:getFrontLayer():addChild(self.m_tExplodeElement:getAnimNode())
    elseif self.m_nId == BulletEffectId.EFFECT_SILENT then

        self.m_tExplodeElement:getAnimNode():setUseAbsCoordinate(true)
        self.m_tExplodeElement:getAnimNode():setScale(1)
        self.m_tExplodeElement:getAnimNode():setAbsPosition(GlobalMethod:ccp(tPos.x ,tPos.y + 0))
        self.m_tExplodeElement:getAnimNode():setAnimationName("hit")
        self.m_tExplodeElement:getAnimNode():setLoop(false)
        SceneBattle:getFrontLayer():addChild(self.m_tExplodeElement:getAnimNode())
    elseif self.m_nId == BulletEffectId.EFFECT_BIND then

        self.m_tExplodeElement:getAnimNode():setUseAbsCoordinate(true)
        self.m_tExplodeElement:getAnimNode():setScale(1)
        self.m_tExplodeElement:getAnimNode():setAbsPosition(GlobalMethod:ccp(tPos.x ,tPos.y + 0))
        self.m_tExplodeElement:getAnimNode():setAnimationName("hit")
        self.m_tExplodeElement:getAnimNode():setLoop(false)
        SceneBattle:getFrontLayer():addChild(self.m_tExplodeElement:getAnimNode())

    elseif self.m_nId == BulletEffectId.EFFECT_TORNADO then

        self.m_tExplodeElement:getAnimNode():setUseAbsCoordinate(true)
        self.m_tExplodeElement:getAnimNode():setScale(1)
        self.m_tExplodeElement:getAnimNode():setAbsPosition(GlobalMethod:ccp(tPos.x ,tPos.y + 0))
        self.m_tExplodeElement:getAnimNode():setAnimationName("hit")
        self.m_tExplodeElement:getAnimNode():setLoop(false)
        SceneBattle:getFrontLayer():addChild(self.m_tExplodeElement:getAnimNode())

    elseif self.m_nId == BulletEffectId.EFFECT_SPATTER then

        self.m_tExplodeElement:getAnimNode():setUseAbsCoordinate(true)
        self.m_tExplodeElement:getAnimNode():setScale(1)
        self.m_tExplodeElement:getAnimNode():setAbsPosition(GlobalMethod:ccp(tPos.x ,tPos.y + 0))
        self.m_tExplodeElement:getAnimNode():setAnimationName("hit")
        self.m_tExplodeElement:getAnimNode():setLoop(false)
        SceneBattle:getFrontLayer():addChild(self.m_tExplodeElement:getAnimNode())
    elseif self.m_nId == BulletEffectId.EFFECT_MIST then
        self.m_tExplodeElement:getAnimNode():setUseAbsCoordinate(true)
        self.m_tExplodeElement:getAnimNode():setScale(1)
        self.m_tExplodeElement:getAnimNode():setAbsPosition(GlobalMethod:ccp(tPos.x ,tPos.y + 0))
        self.m_tExplodeElement:getAnimNode():setAnimationName("hit")
        self.m_tExplodeElement:getAnimNode():setLoop(false)
        SceneBattle:getFrontLayer():addChild(self.m_tExplodeElement:getAnimNode())
    elseif self.m_nId == BulletEffectId.BOSS3_ATTACK then
        self.m_tExplodeElement:getAnimNode():setUseAbsCoordinate(true)
        self.m_tExplodeElement:getAnimNode():setScale(1)
        self.m_tExplodeElement:getAnimNode():setAbsPosition(GlobalMethod:ccp(tPos.x ,tPos.y - 10))
        self.m_tExplodeElement:getAnimNode():setAnimationName("hit")
        self.m_tExplodeElement:getAnimNode():setLoop(false)
        SceneBattle:getFrontLayer():addChild(self.m_tExplodeElement:getAnimNode())
    elseif self.m_nId == BulletEffectId.BOSS8_BULLET_BOOM then
    	self.m_tExplodeElement:getAnimNode():setUseAbsCoordinate(true)
        self.m_tExplodeElement:getAnimNode():setScale(2)
        self.m_tExplodeElement:getAnimNode():setAbsPosition(GlobalMethod:ccp(tPos.x ,tPos.y - 10))
        SceneBattle:getFrontLayer():addChild(self.m_tExplodeElement:getAnimNode())
        self.m_tExplodeElement:play("wait",false)
    elseif self.m_nId == BulletEffectId.EFFECT_CURE then
        self.m_tExplodeElement:getAnimNode():setUseAbsCoordinate(true)
        self.m_tExplodeElement:getAnimNode():setScale(1.0)
        self.m_tExplodeElement:getAnimNode():setAbsPosition(GlobalMethod:ccp(tPos.x + 0 ,tPos.y + 0))
        self.m_tExplodeElement:getAnimNode():setAnimationName("hit")
        self.m_tExplodeElement:getAnimNode():setLoop(false)
        SceneBattle:getFrontLayer():addChild(self.m_tExplodeElement:getAnimNode())
    elseif self.m_nId == BulletEffectId.EFFECT_ATTRACT then
        self.m_tExplodeElement:getAnimNode():setUseAbsCoordinate(true)
        self.m_tExplodeElement:getAnimNode():setScale(1.0)
        self.m_tExplodeElement:getAnimNode():setAbsPosition(GlobalMethod:ccp(tPos.x + 0 ,tPos.y + 0))
        self.m_tExplodeElement:getAnimNode():setAnimationName("hit")
        self.m_tExplodeElement:getAnimNode():setLoop(false)
        SceneBattle:getFrontLayer():addChild(self.m_tExplodeElement:getAnimNode())
    elseif self.m_nId == BulletEffectId.EFFECT_TRANSFER_POS then
        self.m_tExplodeElement:getAnimNode():setUseAbsCoordinate(true)
        self.m_tExplodeElement:getAnimNode():setScale(1.0)
        self.m_tExplodeElement:getAnimNode():setAbsPosition(GlobalMethod:ccp(tPos.x + 0 ,tPos.y + 0))
        self.m_tExplodeElement:getAnimNode():setAnimationName("hit")
        self.m_tExplodeElement:getAnimNode():setLoop(false)
        SceneBattle:getFrontLayer():addChild(self.m_tExplodeElement:getAnimNode())
	else
        --其他爆炸特效
        self.m_tExplodeElement:getAnimNode():setUseAbsCoordinate(true)
        self.m_tExplodeElement:getAnimNode():setScale(1.7)
        self.m_tExplodeElement:getAnimNode():setAbsPosition(GlobalMethod:ccp(tPos.x ,tPos.y - 0))
        SceneBattle:getFrontLayer():addChild(self.m_tExplodeElement:getAnimNode())
        self.m_tExplodeElement:play("0",false)
	end

    WZLog("WBulletExplodeElement:explode end", index)
    BattleEffectManager:getInstance():addBulletEffect(self)

end

function WBulletExplodeElement:explodeIsEnd()
	if self.m_nType == 1 then
		if self.m_tExplodeElement and self.m_tExplodeElement:getAnimNode():getParent() then
			if self.m_tExplodeElement:isCurrentAnimationDone() then
                WZLog("WBulletExplodeElement:explodeIsEnd two")
                self:removeElement()
				return true
			end
			return false
        elseif self.m_tExplodeElement == nil then
            return true
		end
	end
	return nil
end

function WBulletExplodeElement:removeElement()
    WZLog("WBulletExplodeElement:removeElement 1")
	if self.m_tExplodeElement then

		local animNode
		if self.m_nType == 1 then
			animNode = self.m_tExplodeElement:getAnimNode()
		elseif self.m_nType == 2 then
			animNode = self.m_tExplodeElement
		end
        if self.m_tExplodeElement2 and  self.m_tExplodeElement2:isRunning() then
            if self.m_tExplodeElement2:getAnimNode():getParent() then
                self.m_tExplodeElement2:getAnimNode():removeFromParentAndCleanup(true)
            end
        end
        WZLog("WBulletExplodeElement:removeElement 2")
		if animNode:getParent() then
            WZLog("WBulletExplodeElement:removeElement 3")
			animNode:removeFromParentAndCleanup(true)
		end
		animNode:release()
		self.m_tExplodeElement = nil
        self.m_tExplodeElement2 = nil

	end
end
