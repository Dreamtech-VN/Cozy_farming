--BattleBuffMethod.lua
--@date		2016/10/20
--@note		buff解析方法集
BattleBuffMethod =
{
	m_tAttribute = nil,
}

-------------------------------------公有方法模块Begin--------------------------------------

function BattleBuffMethod:create()
	WZLog("BattleBuffMethod:create")

end

function BattleBuffMethod:initAttribute()
	if self.m_tAttribute then
		return
	end
	self.m_tAttribute = {}
    for i, v in pairs (AttributeConfig)do
        self.m_tAttribute[v] = i
    end
end

function BattleBuffMethod:addBuffEffect(hero,buff)
    WZLog("BattleBuffMethod:addBuffEffect1",buff.m_nID)
	BattleBuffMethod:initAttribute()
	for id, effectParm in pairs (buff.m_nEffect) do
        local effectType = effectParm[3] .. "_" ..effectParm[4]
        WZLog("BattleBuffMethod:addBuffEffect2",effectType, effectParm[5], effectParm[6])
        --伤害改变
        if effectType == EffectTypeConfig.CHANGE_HURT_VALUE or
            effectType == EffectTypeConfig.CHANGE_BEHURT_VALUE then
            if not hero.m_tBuffAttributeChangeStateList[effectType] then
                hero.m_tBuffAttributeChangeStateList[effectType] = {}
            end
            hero.m_tBuffAttributeChangeStateList[effectType][buff.m_nID] = effectParm[5]
        elseif effectType == EffectTypeConfig.CHANGE_HURT_PERCENT or
            effectType == EffectTypeConfig.CHANGE_HURT_ADD_VALUE or
            effectType == EffectTypeConfig.CHANGE_BEHURT_PERCENT or
            effectType == EffectTypeConfig.CHANGE_BEHURT_ADD_VALUE or
            effectType == EffectTypeConfig.CHANGE_RECOVERY_PERCENT or
            effectType == EffectTypeConfig.CHANGE_CRIT_HURT_PERCENT or
            effectType == EffectTypeConfig.CHANGE_BECRIT_HURT_PERCENT then
            hero.m_tBuffAttributeChangeStateList[effectType] = BattleBuffMethod:getAddValue(hero.m_tBuffAttributeChangeStateList[effectType],effectParm[5])

        --属性值 值改变
        elseif effectType == EffectTypeConfig.CHANGE_ATTRIBUTE_VALUE or
            effectType == EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT then
        	if effectParm[5] == AttributeConfig.HP then
            elseif effectParm[5] == AttributeConfig.PF then
            elseif effectParm[5] == AttributeConfig.SP then
            else
                if not hero.m_tBuffAttributeChangeStateList[effectType] then
                    hero.m_tBuffAttributeChangeStateList[effectType] = {}
                end
                hero.m_tBuffAttributeChangeStateList[effectType][effectParm[5]] = BattleBuffMethod:getAddValue(hero.m_tBuffAttributeChangeStateList[effectType][effectParm[5]],effectParm[6])
                WZLog("BattleBuffMethod:addBuffEffect3",hero.m_tBuffAttributeChangeStateList[effectType][effectParm[5]])
            end
        --反隐身
        elseif effectType == EffectTypeConfig.HIDE_VIEW then
            WZLog("BattleBuffMethod:addBuffEffect4 hideView",effectParm[5])
            hero.m_nHideViewDis = effectParm[5]
        --磁铁
        elseif effectType == EffectTypeConfig.ATTRACT_BULLET then
            hero.m_nAttractBulletDis = effectParm[5]
        elseif effectType == EffectTypeConfig.CHANGE_HURT_MUL_PERCENT then
            hero.m_tBuffAttributeChangeStateList[effectType] = BattleBuffMethod:getMulValue(hero.m_tBuffAttributeChangeStateList[effectType],effectParm[5]/100)
        elseif effectType == EffectTypeConfig.CHANGE_HURT_TO_ENEMY then
            hero.m_tBuffAttributeChangeStateList[effectType] = BattleBuffMethod:getAddValue(hero.m_tBuffAttributeChangeStateList[effectType],effectParm[5])
        elseif effectType == EffectTypeConfig.CHANGE_HURT_TO_TEAMMATE then
            hero.m_tBuffAttributeChangeStateList[effectType] = BattleBuffMethod:getAddValue(hero.m_tBuffAttributeChangeStateList[effectType],effectParm[5])
        elseif effectType == EffectTypeConfig.CANCEL_BUFF_TYPE then
            if hero:isDead() ~= true then
                for index, herobuff in pairs (hero.m_tBuffChangeStateList) do 
                    local isClear = false
                    if herobuff.m_nEffectType == effectParm[5] and herobuff.m_nCanRemove == 0 then --9_2需要判断buff表disperse字段
                        isClear = true
                    end
                    if isClear then
                        hero:removeBuffSpecialInfluence(herobuff)
                        herobuff:removeAnime()
                        hero.m_tBuffChangeStateList[index] = nil
                    end
                end
            end
        elseif effectType == EffectTypeConfig.EXTRA_HP then
            hero:changeMaxExtraHp(effectParm[5], true)
        elseif effectType == EffectTypeConfig.PROFESSION_SAVELIFE_PERCENT_TWO then --受到致命一击再生的buff
            hero.m_tBuffAttributeChangeStateList[effectType] = {name=buff.m_sName, type=effectType, hp=effectParm[5], maxTimes=effectParm[6], rate= effectParm[7], buffId = buff.m_nID, skillId = buff.skillId}
        end
    end
end

function BattleBuffMethod:removeBuffEffect(hero,buff)
    WZLog("BattleBuffMethod:removeBuffEffect",buff.m_nID)
	BattleBuffMethod:initAttribute()
    
    for id, effectParm in pairs (buff.m_nEffect) do
        local effectType = effectParm[3] .. "_" ..effectParm[4]
        --伤害改变
        if effectType == EffectTypeConfig.CHANGE_HURT_VALUE or
            effectType == EffectTypeConfig.CHANGE_BEHURT_VALUE then
            if not hero.m_tBuffAttributeChangeStateList[effectType] then
                hero.m_tBuffAttributeChangeStateList[effectType] = {}
            end
            hero.m_tBuffAttributeChangeStateList[effectType][buff.m_nID] = nil
        elseif effectType == EffectTypeConfig.CHANGE_HURT_PERCENT or
            effectType == EffectTypeConfig.CHANGE_HURT_ADD_VALUE or
            effectType == EffectTypeConfig.CHANGE_BEHURT_PERCENT or
            effectType == EffectTypeConfig.CHANGE_BEHURT_ADD_VALUE or
            effectType == EffectTypeConfig.CHANGE_RECOVERY_PERCENT or
            effectType == EffectTypeConfig.CHANGE_CRIT_HURT_PERCENT or
            effectType == EffectTypeConfig.CHANGE_BECRIT_HURT_PERCENT then
            hero.m_tBuffAttributeChangeStateList[effectType] = BattleBuffMethod:getCutValue(hero.m_tBuffAttributeChangeStateList[effectType],effectParm[5])

        --属性值 值改变
        elseif effectType == EffectTypeConfig.CHANGE_ATTRIBUTE_VALUE or
            effectType == EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT then
            if effectParm[5] == AttributeConfig.HP then
            elseif effectParm[5] == AttributeConfig.PF then
            elseif effectParm[5] == AttributeConfig.SP then
            else
                if not hero.m_tBuffAttributeChangeStateList[effectType] then
                    hero.m_tBuffAttributeChangeStateList[effectType] = {}
                end
                hero.m_tBuffAttributeChangeStateList[effectType][effectParm[5]] = BattleBuffMethod:getCutValue(hero.m_tBuffAttributeChangeStateList[effectType][effectParm[5]],effectParm[6])
            end

        --反隐身
        elseif effectType == EffectTypeConfig.HIDE_VIEW then
            hero.m_nHideViewDis = nil
            WBattleGlobal:getCurrent():endHideView()
        --磁铁
        elseif effectType == EffectTypeConfig.ATTRACT_BULLET then
            hero.m_nAttractBulletDis = nil
        elseif effectType == EffectTypeConfig.CHANGE_HURT_MUL_PERCENT then
            hero.m_tBuffAttributeChangeStateList[effectType] = BattleBuffMethod:getDivValue(hero.m_tBuffAttributeChangeStateList[effectType],effectParm[5]/100)
        elseif effectType == EffectTypeConfig.CHANGE_HURT_TO_ENEMY then
            hero.m_tBuffAttributeChangeStateList[effectType] = BattleBuffMethod:getCutValue(hero.m_tBuffAttributeChangeStateList[effectType],effectParm[5])
        elseif effectType == EffectTypeConfig.CHANGE_HURT_TO_TEAMMATE then
            hero.m_tBuffAttributeChangeStateList[effectType] = BattleBuffMethod:getCutValue(hero.m_tBuffAttributeChangeStateList[effectType],effectParm[5])
        elseif effectType == EffectTypeConfig.EXTRA_HP then
            hero:changeMaxExtraHp(effectParm[5], false)
        elseif effectType == EffectTypeConfig.PROFESSION_SAVELIFE_PERCENT_TWO then --受到致命一击再生的buff
            hero.m_tBuffAttributeChangeStateList[effectType] = {}
        end
    end
end

--@param base 基础值
--@param value 变动参数
function BattleBuffMethod:getAddValue(base,value)
	base = base or 0
	base = base + value
	return base
end

function BattleBuffMethod:getCutValue(base,value)
	base = base or 0
	base = base - value
	return base
end

function BattleBuffMethod:getMulValue(base,value)
    base = base or 1
    base = base * value
    return base
end

function BattleBuffMethod:getDivValue(base,value)
    base = base or 1
    base = base / value
    return base
end

--@brief buff属性加成获得
--@param hero 玩家
--@param index 属性键值
function BattleBuffMethod:getBuffValue(hero,effectType,param)
    --属性值
    if effectType == EffectTypeConfig.CHANGE_ATTRIBUTE_VALUE then
        if hero.m_tBuffAttributeChangeStateList[effectType] then
            return hero.m_tBuffAttributeChangeStateList[effectType][param] and hero.m_tBuffAttributeChangeStateList[effectType][param] or 0
        else
            return 0
        end
    end
    --属性百分比
    if effectType == EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT then
        if hero.m_tBuffAttributeChangeStateList[effectType] then
            return hero.m_tBuffAttributeChangeStateList[effectType][param] and hero.m_tBuffAttributeChangeStateList[effectType][param] / 10000 or 0
        else
            return 0
        end
    end
    --固定伤害值
    if effectType == EffectTypeConfig.CHANGE_HURT_VALUE or
        effectType == EffectTypeConfig.CHANGE_BEHURT_VALUE then
        if hero.m_tBuffAttributeChangeStateList[effectType] then
            for buffId,value in pairs(hero.m_tBuffAttributeChangeStateList[effectType]) do
                return value
            end
        else
            return nil
        end
    end
    --百分比
    if effectType == EffectTypeConfig.CHANGE_HURT_PERCENT then 
        return hero.m_tBuffAttributeChangeStateList[effectType] and hero.m_tBuffAttributeChangeStateList[effectType]/10000 or 0
    end 
    if effectType == EffectTypeConfig.CHANGE_BEHURT_PERCENT then
        return hero.m_tBuffAttributeChangeStateList[effectType] and hero.m_tBuffAttributeChangeStateList[effectType]/100 or 0
    end
    --百分比
    if effectType == EffectTypeConfig.CHANGE_HURT_MUL_PERCENT then
        return hero.m_tBuffAttributeChangeStateList[effectType] and hero.m_tBuffAttributeChangeStateList[effectType] or 1
    end
    --万分比
    if effectType == EffectTypeConfig.CHANGE_RECOVERY_PERCENT or
        effectType == EffectTypeConfig.CHANGE_CRIT_HURT_PERCENT or
        effectType == EffectTypeConfig.CHANGE_BECRIT_HURT_PERCENT then
        return hero.m_tBuffAttributeChangeStateList[effectType] and hero.m_tBuffAttributeChangeStateList[effectType]/10000 or 0
    end
    --万分比
    if effectType == EffectTypeConfig.CHANGE_HURT_TO_ENEMY or
       effectType == EffectTypeConfig.CHANGE_HURT_TO_TEAMMATE then 
        return hero.m_tBuffAttributeChangeStateList[effectType] and hero.m_tBuffAttributeChangeStateList[effectType]/10000 or 0
    end 
    return hero.m_tBuffAttributeChangeStateList[effectType] and hero.m_tBuffAttributeChangeStateList[effectType] or 0
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
