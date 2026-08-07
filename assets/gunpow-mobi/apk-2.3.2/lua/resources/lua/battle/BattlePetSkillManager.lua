--BattlePetSkillManager.lua
--@date		2016/06/30
--@author	莫剑峰

BattlePetSkillManager =
{
    m_nState = 0,                   --运行状态
    m_nTriggerInitiativeCount = 0,  --触发的主动技能数量
    m_nTriggerPassiveCount = 0,     --触发的被动技能数量
    m_tInitiativeMsg = nil,         --使用主动技能的消息
    m_tPassiveMsg = nil,            --使用主动技能的消息
    m_tInitiativeShowList = nil,    --主动技能显示列表
    m_bInitiativeShowEnd = nil,     --主动技能图标是否显示完
    m_tPassiveShowEndList = nil,    --本回合显示过的技能图标列表
}

PetSkillState = 
{
    NULL = 0,
    INITIATIVE_START = 1,   --主动技能开始
    INITIATIVE_END = 2,     --主动技能结束
    PASSIVE_START = 3,      --被动技能开始
    PASSIVE_END = 4,        --被动技能结束
}
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	开始管理
function BattlePetSkillManager:start()
	WZLog("BattlePetSkillManager:start")
	self:_init()
end

--@brief	销毁
function BattlePetSkillManager:destroy()
	WZLog("BattlePetSkillManager:destroy")

    self.m_nState = PetSkillState.NULL
    self.m_nTriggerInitiativeCount = 0
    self.m_nTriggerPassiveCount = 0
    self.m_tInitiativeMsg = nil
    self.m_tPassiveMsg = nil
    self.m_tInitiativeShowList = nil
    self.m_bInitiativeShowEnd = nil

    self.m_tPassiveShowList = nil
    self.m_bPassiveShowEnd = nil
    self.m_tPassiveShowEndList = nil

    self.m_tPetEquipShowList = nil
    self.m_bPetEquipShowEnd = nil
    self.m_tPetEquipShowEndList = nil
end

--@brief    更新函数
function BattlePetSkillManager:update()

    -- WZLog("BattlePetSkillManager:update", tostring(self.m_tPassiveShowList and #self.m_tPassiveShowList), tostring(self.m_bPassiveShowEnd))
    if self.m_tInitiativeShowList and #self.m_tInitiativeShowList > 0 and self.m_bInitiativeShowEnd ~= false then
        local info = self.m_tInitiativeShowList[1]
        self.m_bInitiativeShowEnd = false
        self:createImage(info.name, info.icon, info.level, info.pos, 0)
        table.remove(self.m_tInitiativeShowList, 1)
    end

    if self.m_tPassiveShowList and #self.m_tPassiveShowList > 0 and self.m_bPassiveShowEnd ~= false then
        local info = self.m_tPassiveShowList[1]
        self.m_bPassiveShowEnd = false
        self:createImage(info.name, info.icon, info.level, info.pos, 1)
        table.remove(self.m_tPassiveShowList, 1)
    end

    if self.m_tPetEquipShowList and #self.m_tPetEquipShowList > 0 and self.m_bPetEquipShowEnd ~= false then
        local info = self.m_tPetEquipShowList[1]
        self.m_bPetEquipShowEnd = false
        self:createImage(info.name, info.icon, info.level, info.pos, 3)
        table.remove(self.m_tPetEquipShowList, 1)
    end
end

--@brief 触发技能
--@param type 1 被动 0 主动
--@return skillList
function BattlePetSkillManager:triggerPetSkill(hero,skillType, msg)
    local skillList = {}
    local petSkill = hero.m_tPetSkills
    local professionSkill = hero.m_tProfessionSkills
    if not petSkill and not professionSkill then
        return
    end
    WZLog("BattlePetSkillManager:triggerPetSkill",hero:getBattleId())
    local nPetShootIndex = msg and msg.m_nPetShootIndex and msg.m_nPetShootIndex or 1
    if petSkill then 
        for id,skillId in ipairs(petSkill.id) do
            local rate = petSkill.rate[id]
            --主动技能的触发概率改为职业二转的宠物主动技能触发概率
            if skillType == 0 and petSkill.itemSubType[id] == skillType then 
                rate = self:getActivePetSkillRate(rate, hero, msg)
            end
            local isTrigger = self:_getRandNum(hero:getBattleId() + nPetShootIndex - 1, id) <= rate

            WZLog("BattlePetSkillManager:triggerPetSkill two", id, skillId,petSkill.name[id], rate, nPetShootIndex)
            if petSkill.itemSubType[id] == skillType and isTrigger then
                local sub_type = BattlePetSkillManager:getPetSkillSubType(skillId) --获取宠物表-技能中的子类型，用于判断和宠物装备技能不同时生效
                table.insert(skillList, {hero=hero, skillId=skillId, name=petSkill.name[id], icon=petSkill.icon[id], level=petSkill.lv[id], petSkillSubType = sub_type or 0, idGroup = petSkill.idGroup[id]})
            end
        end
    end
    --职业中的宠物主动技能
    if professionSkill and skillType == 0 then 
        local petSkillIndex = 0 
        for id, skillId in ipairs(professionSkill.id) do
            local professionData = GDatatab_mage_Skill["id_" .. skillId]
            if professionData and professionData.type == 9 and professionData.node == 3 and type(professionData.attribute) == "number" then 
                local skillInfo = GDatatab_skill["id_".. professionData.attribute]
                if skillInfo ~= nil and skillInfo.skill_type == 4 then 
                    petSkillIndex = petSkillIndex + 1
                end
                if skillInfo ~= nil and skillInfo.skill_type == 4 and skillInfo.sub_type == skillType then
                    local rate = skillInfo.rate
                    --主动技能的触发概率改为职业二转的宠物主动技能触发概率
                    if skillType == 0 then 
                        rate = self:getActivePetSkillRate(rate, hero, msg)
                    end
                    local tempRandom = self:_getRandNum(hero:getBattleId() + nPetShootIndex - 1, petSkillIndex)
                    local randNumList = WBattleGlobal:getCurrent().m_tBattleRand
                    local nCount = #randNumList
                    local isTrigger = randNumList[tempRandom%nCount + 1] <= rate

                    WZLog("BattlePetSkillManager:triggerPetSkill four", id, skillId, professionSkill.name[id], rate, nPetShootIndex)
                    local effectData = GDatatab_effect["id_" .. skillInfo.effect_id[1][1]]
                    if isTrigger then
                        table.insert(skillList, {hero=hero, skillId=professionData.attribute, name=effectData.des, icon=skillInfo.icon, level=professionSkill.lv[id], petSkillSubType = 0, idGroup = skillInfo.id_group})
                    end
                end
            end
        end
    end

    return skillList
end

--@brief    触发主动技能
--@return   true:不触发技能 false:触发技能
function BattlePetSkillManager:triggerInitiativeSkill(hero, hero2, msg)
    WZLog("BattlePetSkillManager:triggerInitiativeSkill one", hero)
    if hero == nil or hero.m_tPetSkills == nil or hero2 == nil then
        return true
    end    

    local triggerSkillList
    if msg and (msg.m_bIsBeatBack == true or (msg.m_nPetShootIndex and msg.m_nPetShootIndex > 1)) then 
        triggerSkillList = BattlePetSkillManager:triggerBeatBackOrContinueAttackPetSkill(hero, 0, msg)
    --    WZLog("BattlePetSkillManager:triggerInitiativeSkill one_1", Serialize(triggerSkillList))
    else
        triggerSkillList =  BattlePetSkillManager:triggerPetSkill(hero,0, msg)
    --    WZLog("BattlePetSkillManager:triggerInitiativeSkill one_2", Serialize(triggerSkillList))
    end

    --宠物装备主动效果
    local petEquipEffectList = {}
    local tempPetEquipEffectList = {}
    local petEquipInitiativeEffect = hero:getPetEquipImmunityAttr(-2)

    if #triggerSkillList == 0 and #petEquipInitiativeEffect == 0 then
        return true
    end
    --宠物反击和连击，宠物装备主动效果随机一个生效，随机到宠物装备没有的效果，不生效
    if msg and (msg.m_bIsBeatBack == true or (msg.m_nPetShootIndex and msg.m_nPetShootIndex > 1)) and #petEquipInitiativeEffect > 0 then 
        local effectNum = PetEquipRandomEffect.INITIACTIVE_EFFECT_NUM  --目前主动效果数量，往后再加（需要维护）
        local battleRandom = WBattleGlobal:getCurrent().m_tBattleRand
        local nIndex = math.fmod(battleRandom[GetTableLen(battleRandom)], effectNum) + 1
        local propertyKey
        if nIndex == 1 then --取致命一击
            propertyKey = PetEquipRandomAttr.PETATTACK_FATAL_RATE
        elseif nIndex == 2 then --取吸血
            propertyKey = PetEquipRandomAttr.PETATTACK_SUCKBLOOD_RATE
        elseif nIndex == 3 then --取大力击飞
            propertyKey = PetEquipRandomAttr.PETATTACK_BLOWUP_RATE
        elseif nIndex == 4 then --取致盲一击
            propertyKey = PetEquipRandomAttr.PETATTACK_BLIND_RATE
        elseif nIndex == 5 then --取易伤
            propertyKey = PetEquipRandomAttr.PETATTACK_EASYHURT_RATE
        elseif nIndex == 6 then --取召喚火焰圈
            propertyKey = PetEquipRandomAttr.PETATTACK_SUMMONFIRE_RATE
        elseif nIndex == 7 then --取召喚黑洞
            propertyKey = PetEquipRandomAttr.PETATTACK_SUMMONBLACKHOLE_RATE
        elseif nIndex == 8 then --取召唤龙卷风
            propertyKey = PetEquipRandomAttr.PETATTACK_SUMMONTORNADO_RATE
        elseif nIndex == 9 then --取连锁一击
            propertyKey = PetEquipRandomAttr.PETATTACK_CHAIN_RATE
        elseif nIndex == 10 then --取镇定一击
            propertyKey = PetEquipRandomAttr.PETATTACK_CALM_RATE
        elseif nIndex == 11 then --取免坑祝福
            propertyKey = PetEquipRandomAttr.PETATTACK_NOPIT_RATE
        elseif nIndex == 12 then --取隐身祝福
            propertyKey = PetEquipRandomAttr.PETATTACK_HIDE_RATE
        elseif nIndex == 13 then --取反伤祝福
            propertyKey = PetEquipRandomAttr.PETATTACK_THORNS_RATE
        end
        --判断概率生效的宠物主动效果，是否有随机到的效果
        for i = 1, #petEquipInitiativeEffect do
            if petEquipInitiativeEffect[i].propertyKey == propertyKey then 
                table.insert(tempPetEquipEffectList, petEquipInitiativeEffect[i])
                break 
            end
        end
    else
        tempPetEquipEffectList = petEquipInitiativeEffect
    end
    if #triggerSkillList == 0 and #tempPetEquipEffectList == 0 then
        return true
    end

    self.m_nState = PetSkillState.INITIATIVE_START
    self.m_tInitiativeMsg = msg

    self.m_tInitiativeShowList = {}
    local countClearBuff, countClearBuffOk = 0,0
    for i,info in ipairs(triggerSkillList) do
        local skill = CopyTable(GDatatab_skill["id_"..info.skillId])
        local effect = CopyTable(GDatatab_effect["id_"..skill.effect_id[1][1]]).effect

        local isClearBuff = nil
        for i, effectParm in pairs (effect) do
            local effectType = effectParm[3] .. "_" ..effectParm[4]
            WZLog("BattlePetSkillManager:triggerInitiativeSkill two", effectType, effectParm[5])
            if effectType == EffectTypeConfig.CANCEL_BUFF_ASSIGN then
                isClearBuff = false
                countClearBuff = countClearBuff + 1
                local cancelBuffAssign = effectParm[5]
                for index, buff in pairs (hero2.m_tBuffChangeStateList) do 
                    if cancelBuffAssign == buff.m_nType then
                        isClearBuff = true
                        countClearBuffOk = countClearBuffOk + 1
                    end
                end
            end
        end

        local pos = hero:getPet():getAnimation():getPosition()
        WZLog("BattlePetSkillManager:triggerInitiativeSkill four", info.skillId, tostring(isClearBuff), pos.x, pos.y)
            
        if isClearBuff ~= false then
            table.insert(self.m_tInitiativeShowList, {name=info.name, icon=info.icon, level=info.level, pos={x=pos.x, y=pos.y + 30}})

            local msg = MsgManager:createMsg(BattleMsgBossMapSkill)
            msg.m_nId = info.skillId --不发协议
            msg.m_tOwner = info.hero
            msg.m_tSkillTypeList = {[1]=SkillTypeConfig.EFFECT}
            msg.m_nSkillId = info.skillId
            msg.m_nEffcetId = info.skillId
            msg.m_nTakeEffectType = TakeEffectType.USE
            msg.m_tCallBackFunc = {self.triggerInitiativeSkillCallback, self, {hero=hero, skillId=info.skillId}}
            MsgManager:pushNonBlockMsg(msg)
        end
    end

    --移除掉不能同时触发的
    WZLog("BattlePetSkillManager:triggerInitiativeSkill Ten0011", #tempPetEquipEffectList, #triggerSkillList)
    if tempPetEquipEffectList and #tempPetEquipEffectList > 0 then 
        if triggerSkillList and #triggerSkillList > 0 then 
            local tItem = {}
            local tPetskillType, tPetEquipSkillType = SplitItemString(CacheCenter:getGameParam().petskilltype)
            for j = 1, #tempPetEquipEffectList do
                local bIsClash = false 
                for k, info in pairs(triggerSkillList) do
                    for n = 1, #tPetskillType do
                        if tonumber(tPetskillType[n]) == info.idGroup and tonumber(tPetEquipSkillType[n]) == tempPetEquipEffectList[j].propertyKey then 
                            bIsClash = true 
                            break 
                        end 
                    end
                    if bIsClash then 
                        break 
                    end
                end
                if not bIsClash then 
                    table.insert(tItem, tempPetEquipEffectList[j])
                end
            end
            if #tItem > 0 then 
                petEquipEffectList = tItem
            end
        else
            petEquipEffectList = tempPetEquipEffectList
        end
    end

    --宠物装备主动效果
    local countClearBuffPetEquip, countClearBuffOkPetEquip = 0,0
    WZLog("BattlePetSkillManager:triggerInitiativeSkill Ten00", #petEquipEffectList)
    for i,info in ipairs(petEquipEffectList) do
        WZLog("BattlePetSkillManager:triggerInitiativeSkill Ten", info.effectId)
        local effectInfo = CopyTable(GDatatab_effect["id_"..info.effectId])
        local effect = effectInfo.effect

        local isClearBuff = nil
        for i, effectParm in pairs (effect) do
            local effectType = effectParm[3] .. "_" ..effectParm[4]
            WZLog("BattlePetSkillManager:triggerInitiativeSkill Ten1", effectType, effectParm[5])
            if effectType == EffectTypeConfig.CANCEL_BUFF_ASSIGN then
                isClearBuff = false
                countClearBuffPetEquip = countClearBuffPetEquip + 1
                local cancelBuffAssign = effectParm[5]
                for index, buff in pairs (hero2.m_tBuffChangeStateList) do 
                    if cancelBuffAssign == buff.m_nType then
                        isClearBuff = true
                        countClearBuffOkPetEquip = countClearBuffOkPetEquip + 1
                    end
                end
            end
        end
        if isClearBuff ~= false then
            local pos = hero:getPet():getAnimation():getPosition()
            if effect[1][1] == TakeEffectType.HIT then 
                hero.m_tPetEquipEffectTakeEffectInfo = hero.m_tPetEquipEffectTakeEffectInfo or {}
                table.insert(hero.m_tPetEquipEffectTakeEffectInfo, info.effectId)
                table.insert(self.m_tPetEquipShowList, {name=effectInfo.des, icon="", level=0, pos={x=pos.x, y=pos.y + 60}})
            else
                table.insert(self.m_tInitiativeShowList, {name= effectInfo.des, icon="", level=0, pos={x=pos.x, y=pos.y + 30}})
                local msg = MsgManager:createMsg(BattleMsgBossMapSkill)
                msg.m_nId = info.skillId --不发协议
                msg.m_tOwner = info.hero
                msg.m_tSkillTypeList = {[1]=SkillTypeConfig.BEHIT_DO_EFFECT}
                msg.m_nEffcetId = info.effectId
                msg.m_nTakeEffectType = effect[1][1]
                if hero2 then 
                    local pos2 = hero2:getPosition() --获取被攻击玩家的位置
                    msg.m_tPetEffectBornPos = {x=pos2.x, y=pos2.y}
                end
                msg.m_tCallBackFunc = {self.triggerInitiativeSkillCallback, self, {hero= info.hero, skillId=info.effectId}}
                MsgManager:pushNonBlockMsg(msg)
            end
        end
    end

    self.m_nTriggerInitiativeCount = #self.m_tInitiativeShowList
    if countClearBuff == #triggerSkillList and countClearBuffOk == 0 and countClearBuffPetEquip == #petEquipEffectList and countClearBuffOkPetEquip == 0 then
        return true
    end

    if self.m_nTriggerInitiativeCount == 0 then return true end 

    return false
end

--@brief    触发主动技能回调
function BattlePetSkillManager:triggerInitiativeSkillCallback(data)
    WZLog("BattlePetSkillManager:triggerInitiativeSkillCallback", data and data.hero:getBattleId(), data and data.skillId)
    self.m_nTriggerInitiativeCount = self.m_nTriggerInitiativeCount - 1
    if self.m_nTriggerInitiativeCount == 0 then
        self.m_nState = PetSkillState.INITIATIVE_END
        self.m_tInitiativeMsg:usePetSkillOkCallback()
        self.m_tInitiativeMsg = nil
    end
end

--@brief    触发被动技能
--@return   true:不触发技能 false:触发技能
function BattlePetSkillManager:triggerPassiveSkill(heroList)
    WZLog("BattlePetSkillManager:triggerPassiveSkill one", #heroList)
    self.m_tPassiveShowList = {}
    self.m_nState = PetSkillState.PASSIVE_START
    local tPetEquipSkillType, tPetskillType = SplitItemString(CacheCenter:getGameParam().petskilltype)
   
    local triggerSkillList = {}
    local petEquipEffectList = {}
    for i,hero in pairs(heroList) do
        local list = BattlePetSkillManager:triggerPetSkill(hero,1)
        if list then
            self.m_nTriggerPassiveCount = self.m_nTriggerPassiveCount + #list
            WZLog("BattlePetSkillManager:triggerPassiveSkill two",self.m_nTriggerPassiveCount, #list)
            table.insert(triggerSkillList,list)
        end
        --宠物装备被动效果
        local petEquipImmunityEffect = hero:getPetEquipImmunityAttr(-1)
        if petEquipImmunityEffect and #petEquipImmunityEffect > 0 then 
            --移除掉不能同时触发的
            if list and #list > 0 then 
                local tItem = {}
                for j = 1, #petEquipImmunityEffect do
                    local bIsClash = false 
                    for k, info in pairs(list) do
                        for n = 1, #tPetskillType do
                            if tonumber(tPetskillType[n]) == info.idGroup and tonumber(tPetEquipSkillType[n]) == petEquipImmunityEffect[j].propertyKey then 
                                bIsClash = true 
                                break 
                            end 
                        end
                        if bIsClash then 
                            break 
                        end
                    end
                    if not bIsClash then 
                        table.insert(tItem, petEquipImmunityEffect[j])
                    end
                end
                if #tItem > 0 then 
                    self.m_nTriggerPassiveCount = self.m_nTriggerPassiveCount + #tItem
                    table.insert(petEquipEffectList, tItem)
                end
            else
                self.m_nTriggerPassiveCount = self.m_nTriggerPassiveCount + #petEquipImmunityEffect
                table.insert(petEquipEffectList, petEquipImmunityEffect)
            end
        end
    end

    if self.m_nTriggerPassiveCount == 0 then
        self.m_nState = PetSkillState.PASSIVE_END
        return true
    end

    for i,list in ipairs(triggerSkillList) do
        for i,info in pairs(list) do
            WZLog("BattlePetSkillManager:triggerPassiveSkill four", info.skillId)
            local msg = MsgManager:createMsg(BattleMsgBossMapSkill)
            msg.m_nId = nil --不发协议
            msg.m_tOwner = info.hero
            msg.m_tSkillTypeList = {[1]=SkillTypeConfig.HIT_DO_EFFECT}
            msg.m_nSkillId = info.skillId
            msg.m_nTakeEffectType = TakeEffectType.USE
            msg.m_tCallBackFunc = {self.triggerPassiveSkillCallback, self, {hero=info.hero, skillId=info.skillId}}
            MsgManager:pushNonBlockMsg(msg)
        end
    end
    --宠物装备被动效果
    for i, list in ipairs(petEquipEffectList) do
        for j, info in pairs(list) do
            WZLog("BattlePetSkillManager:triggerPassiveSkill five", info.propertyKey, info.effectId)
            local msg = MsgManager:createMsg(BattleMsgBossMapSkill)
            msg.m_nId = nil --不发协议
            msg.m_tOwner = info.hero
            msg.m_tSkillTypeList = {[1]=SkillTypeConfig.BEHIT_DO_EFFECT}
            msg.m_nEffcetId = info.effectId
            msg.m_nTakeEffectType = TakeEffectType.USE
            msg.m_tCallBackFunc = {self.triggerPassiveSkillCallback, self, {hero=info.hero, skillId = info.effectId}}
            MsgManager:pushNonBlockMsg(msg)
        end
    end

    return false
end

--@brief    触发被动技能回调
function BattlePetSkillManager:triggerPassiveSkillCallback(data)
    WZLog("BattlePetSkillManager:triggerPassiveSkillCallback",self.m_nTriggerPassiveCount, data and data.hero:getBattleId(), data and data.skillId)
     self.m_nTriggerPassiveCount = self.m_nTriggerPassiveCount - 1
    if self.m_nTriggerPassiveCount == 0 then
        self.m_nState = PetSkillState.PASSIVE_END
        -- self.m_tPassiveMsg:usePetSkillOkCallback()
    end
end


--@brief 触发技能回调
function BattlePetSkillManager:triggerPassiveSkillView(hero,skillId, isFirst)
    if hero.m_nHideOpecity and hero.m_nHideOpecity == 0 then
        return
    end
    
    for id,info in ipairs(self.m_tPassiveShowEndList) do
        if skillId == info.skillId and isFirst == info.isFirst and hero:getBattleId() == info.hero then
            return
        end
    end

    local petSkill = hero.m_tPetSkills
    for id,petSkillId in ipairs(petSkill.id) do
        if petSkillId == skillId then
            local pos = hero:getPosition()
            WZLog("BattlePetSkillManager:triggerPassiveSkillView",hero:getBattleId(),pos.x,pos.y)
            table.insert(self.m_tPassiveShowList, {name=petSkill.name[id], icon=petSkill.icon[id], level=petSkill.lv[id], pos={x=pos.x, y=pos.y + 30}})
            table.insert(self.m_tPassiveShowEndList, {skillId=skillId, isFirst=isFirst, hero=hero:getBattleId()})
             -- WZLog("BattlePetSkillManager:triggerPassiveSkillView",#self.m_tPassiveShowList)
            -- self:createImage(petSkill.name[id], petSkill.icon[id], petSkill.lv[id], {x=hero:getPosition().x - 30 + 90 * (i-1), y=hero:getPosition().y + 100}, 1)
        end
    end
end

--@brief 触发技能回调
function BattlePetSkillManager:triggerPassiveSkillViewList(hero,list, isFirst)
    if hero.m_nHideOpecity and hero.m_nHideOpecity == 0 then
        return
    end
    local petSkill = hero.m_tPetSkills
    local isDisplay = false
    for i,skillId in ipairs(list) do
        isDisplay = false
        for id,info in ipairs(self.m_tPassiveShowEndList) do
            if skillId == info.skillId and isFirst == info.isFirst and hero:getBattleId() == info.hero then
                isDisplay = true
            end
        end

        WZLog("BattlePetSkillManager:triggerPassiveSkillViewList one", skillId, isDisplay)
        if isDisplay == false then
            for id,petSkillId in ipairs(petSkill.id) do
                if petSkillId == skillId then
                    local pos = hero:getPosition()
                    WZLog("BattlePetSkillManager:triggerPassiveSkillViewList two",skillId,hero:getBattleId(),pos.x,pos.y)
                    table.insert(self.m_tPassiveShowList, {name=petSkill.name[id], icon=petSkill.icon[id], level=petSkill.lv[id], pos={x=pos.x, y=pos.y + 30}})
                    table.insert(self.m_tPassiveShowEndList, {skillId=skillId, isFirst=isFirst, hero=hero:getBattleId()})
                end
            end
        end
    end
end


--@brief 触发宠物装备技能回调
function BattlePetSkillManager:triggerPetEquipSkillView(hero, nType, isFirst)
    if hero.m_nHideOpecity and hero.m_nHideOpecity == 0 then
        return
    end

    local skillName = ""
    for k,v in pairs(GDatatab_pet_random) do
        if v.type == tonumber(nType) then
            skillName = v.name
            break 
        end
    end

    for id,info in ipairs(self.m_tPetEquipShowEndList) do
        if nType == info.skillType and isFirst == info.isFirst and hero:getBattleId() == info.hero then
            return
        end
    end

    local pos = hero:getPosition()
    table.insert(self.m_tPetEquipShowList, {name=skillName, icon="", level=0, pos={x=pos.x, y=pos.y + 30}})
    table.insert(self.m_tPetEquipShowEndList, {skillType=nType, isFirst=isFirst, hero=hero:getBattleId()})
end

--@brief 被动技能触发结束
function BattlePetSkillManager:isTriggerPassiveSkill()
    return self.m_nState == PetSkillState.PASSIVE_END
end

--@brief 技能每回合更新
function BattlePetSkillManager:updateByTurn()
    self.m_tPassiveShowEndList = {}
    self.m_tPetEquipShowList = {}
    self.m_tPetEquipShowEndList = {}
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	初始化Manager
function BattlePetSkillManager:_init()
	self.m_tProtocolPool = {}
	self.m_tTurnRecordList = {}
    self.m_tPassiveShowEndList = {}
    self.m_tPetEquipShowEndList = {}
end

--@brief    创建技能图标
function BattlePetSkillManager:createImage(name, icon, level, pos, InitiativeOrPassive)
    WZLog("BattlePetSkillManager:createImage", name, icon, level, pos.x, pos.y, InitiativeOrPassive)
    self:showUseName(BattleCommon:getPointTable(pos.x,pos.y + 55), name, InitiativeOrPassive)
end

--@brief    道具出现
function BattlePetSkillManager:showImage(sprite, isCallBack, InitiativeOrPassive)

    local delayTime = 0.5
    local fadeTime = 0.5
    local action = WZUIActionSequence:create()
    action:setIsLoop(false)

    local actionDelay1 = WZUIActionDelayTime:create()
    actionDelay1:setDuration(delayTime)

    local actionFadeTo1 = WZUIActionFadeTo:create()
    actionFadeTo1:setOpacity(0)
    actionFadeTo1:setDuration(fadeTime)

    if isCallBack then
        if InitiativeOrPassive == 0 then
            actionFadeTo1:setFinishLuaFunction("actionInitiativeEnd")
        else
            actionFadeTo1:setFinishLuaFunction("InitiativeOrPassive")
        end
        actionFadeTo1:setFinishLuaTable(self)
    end

    action:setChildAction(actionDelay1)
    action:setChildAction(actionFadeTo1)
    WZUIImage:luaTo(sprite):runUIAction(action)
end

--@brief    道具出现回调
function BattlePetSkillManager:actionInitiativeEnd(element)
    WZLog("BattlePetSkillManager:actionInitiativeEnd")

    element:removeFromParentAndCleanup(true)
    self.m_bIconShowEnd = true

    if self.m_nTriggerInitiativeCount == 0 and self.m_bIconShowEnd == true then
        self.m_nState = PetSkillState.INITIATIVE_END
        self.m_tInitiativeMsg:usePetSkillOkCallback()
        self.m_tInitiativeMsg = nil
        self.m_bIconShowEnd = nil
    end
end

--@brief    道具出现回调
function BattlePetSkillManager:InitiativeOrPassive(element)
    WZLog("BattlePetSkillManager:InitiativeOrPassive")

    element:removeFromParentAndCleanup(true)
end

--@brief    显示使用道具技能的名字
--@param    heroPos:英雄位置
--@param    useName:显示名字
--@note
function BattlePetSkillManager:showUseName(heroPos,useName, InitiativeOrPassive)

    local ttf = WZUILabelTTF:create()
    ttf:setColor(GlobalMethod:ccc3(255,227,116))
    ttf:setFontSize(40)
    ttf:setText(useName)
    ttf:setBoldFont(true)
    ttf:setTouchEnable(false)
    ttf:setEnableStroke(true)
    ttf:setStrokeSize(3)
    ttf:setStrokeColor(GlobalMethod:ccc3(128, 54, 13))

    ---[[
    local action = WZUIActionSequence:create()
    action:setIsLoop(true)

    local actionScale = WZUIActionScaleTo:create()
    actionScale:setDuration(0)
    actionScale:setScaleX(0.5)
    actionScale:setScaleY(0.5)

    local actionScale1 = WZUIActionScaleTo:create()
    actionScale1:setDuration(0.1)
    actionScale1:setScaleX(1.5)
    actionScale1:setScaleY(1.5)

    local actionScale2 = WZUIActionScaleTo:create()
    actionScale2:setDuration(0.1)
    actionScale2:setScaleX(1)
    actionScale2:setScaleY(1)

    local actionDelay = WZUIActionDelayTime:create()
    actionDelay:setDuration(0.5)

    if InitiativeOrPassive == 0 then
        actionDelay:setFinishLuaFunction("actionPlayEffectInitiativeNext")
    elseif InitiativeOrPassive == 2 then
        actionDelay:setFinishLuaFunction("actionPlayEffectProfessionNext")
    elseif InitiativeOrPassive == 3 then
        actionDelay:setFinishLuaFunction("actionPlayEffectPetEquipNext")
    else
        actionDelay:setFinishLuaFunction("actionPlayEffectPassiveNext")
    end
    actionDelay:setFinishLuaTable(self)

    local dis = 0
    local actionSp = WZUIActionSpawn:create()
    local actionMoveTo = WZUIActionMoveToPosition:create()
    actionMoveTo:setPosition(GlobalMethod:ccp(heroPos.x,heroPos.y + dis+100))
    actionMoveTo:setDuration(0.5)

    local actionFadeTo = WZUIActionFadeTo:create()
    actionFadeTo:setOpacity(0)
    actionFadeTo:setDuration(0.5)
    if InitiativeOrPassive == 0 then
        actionFadeTo:setFinishLuaFunction("actionPlayEffectInitiativeEnd")
    elseif InitiativeOrPassive == 3 then
        actionFadeTo:setFinishLuaFunction("actionPlayEffectPetEquipEnd")
    else
        actionFadeTo:setFinishLuaFunction("actionPlayEffectPassiveEnd")
    end
    actionFadeTo:setFinishLuaTable(self)

    actionSp:setChildAction(actionMoveTo)
    actionSp:setChildAction(actionFadeTo)

    action:setChildAction(actionScale)
    action:setChildAction(actionScale1)
    action:setChildAction(actionScale2)
    action:setChildAction(actionDelay)
    action:setChildAction(actionSp)
    --]]
    SceneBattle:getFrontLayer():addChild(ttf,6)

    ttf:setPosition(heroPos.x,heroPos.y+ dis)
    ttf:runUIAction(action)

    return ttf
end

--@brief    道具出现文字回调
function BattlePetSkillManager:actionPlayEffectInitiativeNext(element)
    self.m_bInitiativeShowEnd = true
    WZLog("BattlePetSkillManager:actionPlayEffectInitiativeNext")
end

--@brief    道具出现文字回调
function BattlePetSkillManager:actionPlayEffectPassiveNext(element)
    self.m_bPassiveShowEnd = true
    WZLog("BattlePetSkillManager:actionPlayEffectPassiveNext")
end

--@brief    职业出现文字回调
function BattlePetSkillManager:actionPlayEffectProfessionNext(element)
    self.m_bPassiveShowEnd = true
    WZLog("BattlePetSkillManager:actionPlayEffectProfessionNext")
end

--@brief    宠物装备出现文字回调
function BattlePetSkillManager:actionPlayEffectPetEquipNext(element)
    self.m_bPetEquipShowEnd = true
    WZLog("BattlePetSkillManager:actionPlayEffectPetEquipNext")
end

--@brief    道具出现文字回调
function BattlePetSkillManager:actionPlayEffectInitiativeEnd(element)
    element:removeFromParentAndCleanup(true)
    --self.m_bInitiativeShowEnd = true
    WZLog("BattlePetSkillManager:actionPlayEffect")
end

--@brief    道具出现文字回调
function BattlePetSkillManager:actionPlayEffectPassiveEnd(element)
    element:removeFromParentAndCleanup(true)
    --self.m_bPassiveShowEnd = true
    WZLog("BattlePetSkillManager:actionPlayEffectPassiveEnd")
end

--@brief    宠物装备出现文字回调
function BattlePetSkillManager:actionPlayEffectPetEquipEnd(element)
    element:removeFromParentAndCleanup(true)
    --self.m_bPetEquipShowEnd = true
    WZLog("BattlePetSkillManager:actionPlayEffectPetEquipEnd")
end

--@brief    获取随机数
function BattlePetSkillManager:_getRandNum(battleId, index)
    local randNumIndex = battleId % 10 + 1
    local newIndex = index % 10 + 1
    local randNumList = WBattleGlobal:getCurrent().m_tBattleRand
    for i = 1,10 do
        if i == index then
            return randNumList[randNumIndex]
        end
        -- randNumIndex = randNumList[randNumIndex] % 10 + 1
        randNumIndex = randNumIndex + 1
        if randNumIndex > 10 then
            randNumIndex = 1
        end
    end
end

--@brief    获取宠物主动技能的触发概率
function BattlePetSkillManager:getActivePetSkillRate(rate, hero, msg)
    -- body
    local realRate = rate 
    if msg and msg.m_bIsBeatBack then return realRate end 

    if hero:getProfessionId() and hero:getProfessionId() > 0 and hero.m_tProfessionSkills then 
        for k = 1, hero.m_tProfessionSkills.count do
            if hero.m_tProfessionSkills.skill_type[k] == 10 then 
                local consumeCTB = hero:getCurrentRoundCtbConsume()
                local nTempValue = hero.m_tProfessionSkills.attribute[k][1][1]/100 + consumeCTB/(consumeCTB + hero.m_tProfessionSkills.attribute[k][1][2])
                realRate = math.floor(realRate * nTempValue)
                WZLog("BattlePetSkillManager:getActivePetSkillRate", realRate, consumeCTB)
                break 
            end
        end
    end

    return realRate
end

--@brief 触发反击和连击技能
--@param type 1 被动 0 主动
--@return skillList
function BattlePetSkillManager:triggerBeatBackOrContinueAttackPetSkill(hero,skillType, msg)
    local skillList = {}
    local petSkill = hero.m_tPetSkills
    local professionSkill = hero.m_tProfessionSkills
    if not petSkill and not professionSkill then
        return
    end
    WZLog("BattlePetSkillManager:triggerBeatBackOrContinueAttackPetSkill",hero:getBattleId())
    if petSkill then 
        for id,skillId in ipairs(petSkill.id) do
            if petSkill.itemSubType[id] == skillType then
                local rate = petSkill.rate[id]
                --主动技能的触发概率改为职业二转的宠物主动技能触发概率
                if skillType == 0 and petSkill.itemSubType[id] == skillType then 
                    rate = self:getActivePetSkillRate(rate, hero, msg)
                end
                WZLog("BattlePetSkillManager:triggerBeatBackOrContinueAttackPetSkill three", id, rate, skillId)
                local sub_type = BattlePetSkillManager:getPetSkillSubType(skillId) --获取宠物表-技能中的子类型，用于判断和宠物装备技能不同时生效
                table.insert(skillList, {hero=hero, skillId=skillId, name=petSkill.name[id], icon=petSkill.icon[id], level=petSkill.lv[id], rate = rate, petSkillSubType = sub_type or 0, idGroup = petSkill.idGroup[id]})
            end
        end
    end
    --职业中的宠物主动技能
    if professionSkill and skillType == 0 then 
        for id, skillId in ipairs(professionSkill.id) do
            local professionData = GDatatab_mage_Skill["id_" .. skillId]
            if professionData and professionData.type == 9 and professionData.node == 3 and type(professionData.attribute) == "number" then 
                local skillInfo = GDatatab_skill["id_".. professionData.attribute]
                if skillInfo ~= nil and skillInfo.skill_type == 4 and skillInfo.sub_type == skillType then
                    local rate = skillInfo.rate
                    WZLog("BattlePetSkillManager:triggerBeatBackOrContinueAttackPetSkill six", hero:getBattleId(), id, skillId, rate)
                    --主动技能的触发概率改为职业二转的宠物主动技能触发概率
                    if skillType == 0 then 
                        rate = self:getActivePetSkillRate(rate, hero, msg)
                    end
                    local effectData = GDatatab_effect["id_" .. skillInfo.effect_id[1][1]]
                    table.insert(skillList, {hero=hero, skillId=professionData.attribute, name=effectData.des, icon=skillInfo.icon, level=professionSkill.lv[id], rate = rate, petSkillSubType = 0, idGroup = skillInfo.id_group})
                end
            end
        end
    end

    local tTempSkillList = {}
    local skillNum = #skillList
    if skillNum <= 0 then return tTempSkillList end 

    local randNumList = WBattleGlobal:getCurrent().m_tBattleRand
    local skillIndex = randNumList[10] % skillNum + 1
    local randSkill = skillList[skillIndex]
    local randFirstNum = randNumList[1]
    WZLog("BattlePetSkillManager:triggerBeatBackOrContinueAttackPetSkill five", randSkill.skillId, randSkill.rate, skillIndex, randFirstNum)
    if randFirstNum <= randSkill.rate then 
        table.insert(tTempSkillList, randSkill)
    end

    return tTempSkillList
end

--@brief    获取宠物技能表相应技能的sub_type
function BattlePetSkillManager:getPetSkillSubType(skillId)
    for i, value in pairs(GDatatab_pet_skill_new) do
        if value.skill_id == skillId then 
            return value.sub_type
        end
    end

    return nil 
end
-------------------------------------私有方法模块End----------------------------------------
