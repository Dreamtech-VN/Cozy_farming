--BuffAnimManager.lua
--@date		2015/06/1
--@author	莫剑峰

BuffAnimManager =
{


}

-------------------------------------公有方法模块Begin--------------------------------------

function BuffAnimManager:create()
	WZLog("BuffAnimManager:create")

end

function BuffAnimManager:update()
	--WZLog("BuffAnimManager:update")
	self:checkPowerUp()
	self:checkDefenseUp()
end

--@brief	检测加攻
function BuffAnimManager:checkPowerUp()
	do return end
	for id, hero in pairs (WBattleGlobal:getCurrent():getCharacterList()) do
		local stateList = hero.m_tAttributeChangeStateList
		local isAttributeChange = hero:getAttack(true) > hero:getAttack()
		local isHurtAddPercentChange = stateList.m_nHurtAddPercent and stateList.m_nHurtAddPercent.value and stateList.m_nHurtAddPercent.value > 0		
		local isHurtAddValueChange = stateList.m_nHurtAddValue and stateList.m_nHurtAddValue.value and stateList.m_nHurtAddValue.value > 0
		local isBuff = false
		if hero.m_tBuffChangeStateList ~= nil then
			for id,buff in pairs (hero.m_tBuffChangeStateList) do
				for id, effectParm in pairs (buff.m_nEffect) do
	                local effect = effectParm[3] .. "_" ..effectParm[4]
	                local effectValue = nil
	                if effect == EffectTypeConfig.CHANGE_HURT_VALUE then
	                	effectValue = effectParm[5]
	                elseif effect == EffectTypeConfig.CHANGE_HURT_PERCENT then
	                	effectValue = effectParm[5]
	                elseif effect == EffectTypeConfig.CHANGE_HURT_ADD_VALUE then
	                	effectValue = effectParm[5]
	                end
	                if effectValue and effectValue > 0 then
	                	isBuff = true
	                end
	            end
			end
		end
		--WZLog("BuffAnimManager:checkPowerUp one", hero:getBattleId(), tostring(isAttributeChange), tostring(isHurtAddPercentChange), tostring(isHurtAddValueChange))
		if isAttributeChange or isHurtAddPercentChange or isHurtAddValueChange or isBuff then
			--WZLog("BuffAnimManager:checkPowerUp two", hero:getBattleId(), tostring(isAttributeChange), tostring(isHurtAddPercentChange), tostring(isHurtAddValueChange))
			if hero.m_tBuffPowerUpAnim == nil then
				hero.m_tBuffPowerUpAnim = 0
				WZLog("BuffAnimManager:checkPowerUp three", hero:getBattleId())
				local anim = BattleAnimation:createAnimation(IWCO_MONSTEREFFICIENTS)	
				anim:addAnimation("boss3Efficient5",{}, 0.1, true)
				anim:play("boss3Efficient5",true)
				anim:getAnimNode():setScaleY(0.6)
				anim:getAnimNode():setScaleX(0.8)
				local hpos = hero:getPosition()
				anim:setPosition(hero.m_tAnimPowerUpOffset or BattleCommon:getPointTable(110,50))
				hero:getAnimation():getAnimNode():addChild(anim:getAnimNode())
				hero.m_tBuffPowerUpAnim = anim
			end
		else
			if hero.m_tBuffPowerUpAnim ~= nil then
				WZLog("BuffAnimManager:checkPowerUp two", hero:getBattleId())
				hero.m_tBuffPowerUpAnim:getAnimNode():removeFromParentAndCleanup(true)
				hero.m_tBuffPowerUpAnim = nil
			end
		end
	end
end

--@brief	检测加防
function BuffAnimManager:checkDefenseUp()
	--do return end
	for id, hero in pairs (WBattleGlobal:getCurrent():getCharacterList()) do
		local stateList = hero.m_tAttributeChangeStateList
		local isAttributeChange = hero:getDefence(true) > hero:getDefence()
		local isHurtAddPercentChange = stateList.m_nBeHurtAddPercent and stateList.m_nBeHurtAddPercent.value and stateList.m_nBeHurtAddPercent.value ~= 0		
		local isHurtAddValueChange = stateList.m_nBeHurtAddValue and stateList.m_nBeHurtAddValue.value and stateList.m_nBeHurtAddValue.value ~= 0
		local buffInfo = nil
		if hero.m_tBuffChangeStateList ~= nil then
			for id,buff in pairs (hero.m_tBuffChangeStateList) do
				for id, effectParm in pairs (buff.m_nEffect) do
	                local effect = effectParm[3] .. "_" ..effectParm[4]
	                local effectValue = nil
	                if effect == EffectTypeConfig.CHANGE_BEHURT_VALUE then
	                	effectValue = effectParm[5]
	                elseif effect == EffectTypeConfig.CHANGE_BEHURT_PERCENT then
	                	effectValue = effectParm[5]
	                elseif effect == EffectTypeConfig.CHANGE_BEHURT_ADD_VALUE then
	                	effectValue = effectParm[5]
	                end
	                if effectValue and effectValue <= 0 then
	                	buffInfo = buff
	                end
	            end
			end
		end
		--WZLog("BuffAnimManager:checkPowerUp one", hero:getBattleId(), tostring(isAttributeChange), tostring(isHurtAddPercentChange), tostring(isHurtAddValueChange))
		if buffInfo then
			if hero.m_tBuffDefenseAnim == nil then
                local buffAnim = GDatatab_EffectInfoConfig["id_"..buffInfo.m_nIngAni]

				WZLog("BuffAnimManager:checkDefenseUp three", hero:getBattleId(), buffInfo.buff_effect)
				local anim = BattleAnimation:createAnimation(buffAnim.source,true)
				anim:getAnimNode():setScaleY(buffAnim.scaleX)
				anim:getAnimNode():setScaleX(buffAnim.scaleY)
				hero:getAnimation():getAnimNode():setUseAbsCoordinate(true)
				hero:getAnimation():getAnimNode():addChild(anim:getAnimNode())
				anim:setPosition(BattleCommon:getPointTable(hero:getAnimation():getAnimNode():getContentSize().width/2 + buffAnim.offsetX,buffAnim.offsetY))
				anim:play(buffAnim.actions,true)
				hero.m_tBuffDefenseAnim = anim
			end
		else
			if hero.m_tBuffDefenseAnim ~= nil then
				WZLog("BuffAnimManager:checkDefenseUp two", hero:getBattleId())
				hero.m_tBuffDefenseAnim:getAnimNode():removeFromParentAndCleanup(true)
				hero.m_tBuffDefenseAnim = nil
			end
		end
	end
end

function BuffAnimManager:new()
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
