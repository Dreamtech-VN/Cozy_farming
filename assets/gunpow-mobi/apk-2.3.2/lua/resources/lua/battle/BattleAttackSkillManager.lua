--BattleAttackSkillManager.lua
--@date		2016/06/30
--@author	莫剑峰
--@note     共生录技能管理

BattleAttackSkillManager =
{
}

-------------------------------------公有方法模块Begin--------------------------------------


--@brief 触发技能
--@param type 1 被动 0 主动
--@return skillList
function BattleAttackSkillManager:triggerAttackSkill(hero, skillType)
    local skillList = {}
    local tAttackSkills = hero.m_tAttackSkills
    WZLog("BattleAttackSkillManager:triggerAttackSkill",hero:getBattleId(),tAttackSkills)

    if tAttackSkills then
        for index,skillId in ipairs(tAttackSkills.id) do
            local rate = tAttackSkills.rate[index]
            local randomNum = self:_getRandNum(hero:getBattleId(), skillId)

            local isTrigger = randomNum <= rate

            WZLog("BattleAttackSkillManager:triggerAttackSkill two", index, skillId, skillType,tAttackSkills.itemSubType[index], randomNum, rate)
            if tAttackSkills.itemSubType[index] == skillType and isTrigger then
                WZLog("BattleAttackSkillManager:triggerAttackSkill three", index)
                table.insert(skillList, {hero=hero, skillId=skillId, name=tAttackSkills.name[index], icon=tAttackSkills.icon[index], level=tAttackSkills.lv[index]})
            end
        end
    end

    return skillList
end

--@brief 获取触发的普攻技能id
function BattleAttackSkillManager:getAttackSkillBullet()
    local tCurRoundSkillId = WBattleGlobal:getCurrent().m_tCurRoundSkillId
    if tCurRoundSkillId then
        for i=1,#tCurRoundSkillId do
            local skillInfo = GDatatab_skill["id_"..tCurRoundSkillId[i]]
            if skillInfo.skill_type == 11 then
                for k,v in pairs(GDatatab_shape_group) do
                    local nextSkillId = v.skill_id
                    while nextSkillId ~= -1 do
                        if nextSkillId == skillInfo.id then
                            return v.bullet
                        end
                        tempSkillInfo = GDatatab_skill["id_"..nextSkillId]
                        nextSkillId = tempSkillInfo.upgrade_id
                    end
                end
            end
        end
    end

    return nil
end


--@brief    触发主动技能
--@return   true:不触发技能 false:触发技能
function BattleAttackSkillManager:triggerInitiativeSkill(hero)
    WZLog("BattleAttackSkillManager:triggerInitiativeSkill one", hero)
    if hero == nil or hero.m_tAttackSkills == nil then
        return
    end

    --使用过其他技能不触发
    local tCurRoundSkillId = CopyTable(WBattleGlobal:getCurrent().m_tCurRoundSkillId)
    for i=#tCurRoundSkillId,1,-1 do
        local tSkillData = GDatatab_skill["id_"..tCurRoundSkillId[i]]
        if tSkillData.skill_type == 5 then
            table.remove(tCurRoundSkillId,i)
        end
    end
    if #tCurRoundSkillId ~= 0 then
        return
    end

    local triggerSkillList = BattleAttackSkillManager:triggerAttackSkill(hero, 0)

    if #triggerSkillList == 0 then
        return
    end

    for i,info in ipairs(triggerSkillList) do
        local skill = CopyTable(GDatatab_skill["id_"..info.skillId])
        local effect = CopyTable(GDatatab_effect["id_"..skill.effect_id[1][1]]).effect

        --单人副本,生成溅射弹角度 技能天崩
        if skill and skill.id_group == 2003 and WBattleGlobal:getCurrent():isSingleStage() then
            local effectData = GDatatab_effect["id_" .. skill.effect_id[1][1]]
            local tSpatterAngle = GetRandomNum(effectData.effect[1][5], 110, 70)
            WBattleGlobal:getCurrent():setCurSpatterAngle(tSpatterAngle)
        end
        --使用技能
        if BattleHeroUse:heroUse(hero:getBattleId(), BattleHeroUse.USE_ATTACK_SKILL, info.skillId) then
            --单人副本,设置风向参数 技能芭蕉扇
            if skill and skill.id_group == 2005 and WBattleGlobal:getCurrent():isSingleStage() then 
                local effectData = GDatatab_effect["id_" .. skill.effect_id[1][1]]
                WndBattleHud.m_nWindSkillId = info.skillId
                WndBattleHud.m_nWindSkillBuffTime = effectData.effect[1][7]
            end
        end
    end
end

-- -------------------------------------公有方法模块End----------------------------------------


-- -------------------------------------私有方法模块Begin--------------------------------------


--@brief    获取随机数
function BattleAttackSkillManager:_getRandNum(battleId, skillId)
    local battleRand = WBattleGlobal:getCurrent().m_tBattleRand
    local randomIndex = math.abs((battleId + skillId) % 10)
    local i = math.abs((battleRand[randomIndex + 1] + battleId + skillId) % 10)
    return battleRand[i + 1]
end

-------------------------------------私有方法模块End----------------------------------------
