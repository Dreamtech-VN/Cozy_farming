--BattleProfessionSkillManager.lua
--@date		2016/06/30
--@author	莫剑峰

BattleProfessionSkillManager =
{
    m_nState = 0,                   --运行状态
    m_nTriggerInitiativeCount = 0,  --触发的主动技能数量
    m_nTriggerPassiveCount = 0,     --触发的被动技能数量
    m_tInitiativeMsg = nil,         --使用主动技能的消息
    m_tPassiveMsg = nil,            --使用主动技能的消息
    m_tInitiativeShowList = nil,    --主动技能显示列表
    m_bInitiativeShowEnd = nil,     --主动技能图标是否显示完
}

ProfessionSkillState = 
{
    NULL = 0,
    INITIATIVE_START = 1,   --主动技能开始
    INITIATIVE_END = 2,     --主动技能结束
    PASSIVE_START = 3,      --被动技能开始
    PASSIVE_END = 4,        --被动技能结束
}
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	开始管理
function BattleProfessionSkillManager:start()
	WZLog("BattleProfessionSkillManager:start")
	self:_init()
end

--@brief	销毁
function BattleProfessionSkillManager:destroy()
	WZLog("BattleProfessionSkillManager:destroy")

    self.m_nState = ProfessionSkillState.NULL
    self.m_nTriggerInitiativeCount = 0
    self.m_nTriggerPassiveCount = 0
    self.m_tInitiativeMsg = nil
    self.m_tPassiveMsg = nil
    self.m_tInitiativeShowList = nil
    self.m_bInitiativeShowEnd = nil

    self.m_tPassiveShowList = nil
    self.m_bPassiveShowEnd = nil

end

--@brief    更新函数
function BattleProfessionSkillManager:update()

    -- WZLog("BattleProfessionSkillManager:update", tostring(self.m_tPassiveShowList and #self.m_tPassiveShowList), tostring(self.m_bPassiveShowEnd))
    if self.m_tInitiativeShowList and #self.m_tInitiativeShowList > 0 and self.m_bInitiativeShowEnd ~= false then
        local info = self.m_tInitiativeShowList[1]
        self.m_bInitiativeShowEnd = false
        self:createImage(info.name or "", info.icon, info.level, info.pos, 0)
        table.remove(self.m_tInitiativeShowList, 1)
    end

    if self.m_tPassiveShowList and #self.m_tPassiveShowList > 0 and self.m_bPassiveShowEnd ~= false then
        local info = self.m_tPassiveShowList[1]
        self.m_bPassiveShowEnd = false
        WZLog("BattleProfessionSkillManager:update one", Serialize(info))
        self:createImage(info.name or "", info.icon, info.level, info.pos, 1)
        table.remove(self.m_tPassiveShowList, 1)
    end
end

--@brief    触发被动技能回调
function BattleProfessionSkillManager:triggerPassiveSkillCallback(data)
    WZLog("BattleProfessionSkillManager:triggerPassiveSkillCallback",self.m_nTriggerPassiveCount, data and data.hero:getBattleId(), data and data.skillId)
     self.m_nTriggerPassiveCount = self.m_nTriggerPassiveCount - 1
    if self.m_nTriggerPassiveCount == 0 then
        self.m_nState = ProfessionSkillState.PASSIVE_END
        -- self.m_tPassiveMsg:usePetSkillOkCallback()
    end
end


--@brief 触发技能回调
function BattleProfessionSkillManager:triggerPassiveSkillView(hero, skillId, effectData)
    if hero.m_nHideOpecity and hero.m_nHideOpecity == 0 then
        return
    end

    if effectData then 
        local pos = hero:getPosition()
        WZLog("BattleProfessionSkillManager:triggerPassiveSkillView One",hero:getBattleId(),pos.x,pos.y)
        table.insert(self.m_tPassiveShowList, {name=effectData.name, icon="", level=0, pos={x=pos.x, y=pos.y + 30}, hero = hero})
    else
        local proSkill = hero.m_tProfessionSkills
        for id, proSkillId in ipairs(proSkill.id) do
            local tempData = GDatatab_mage_Skill["id_" .. proSkillId]
            if tempData and type(tempData.attribute) == "number" and tempData.attribute == skillId then
                local pos = hero:getPosition()
                WZLog("BattleProfessionSkillManager:triggerPassiveSkillView Two",hero:getBattleId(),pos.x,pos.y)
                table.insert(self.m_tPassiveShowList, {name=proSkill.name[id], icon=proSkill.icon[id], level=proSkill.lv[id], pos={x=pos.x, y=pos.y + 30}, hero = hero})
            end
        end
    end
end

--@brief 被动技能触发结束
function BattleProfessionSkillManager:isTriggerPassiveSkill()
    return self.m_nState == ProfessionSkillState.PASSIVE_END
end

--@brief 技能每回合更新
function BattleProfessionSkillManager:updateByTurn()
    
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	初始化Manager
function BattleProfessionSkillManager:_init()
	self.m_tProtocolPool = {}
	self.m_tTurnRecordList = {}
end

--@brief    创建技能图标
function BattleProfessionSkillManager:createImage(name, icon, level, pos, InitiativeOrPassive, hero)
    WZLog("BattleProfessionSkillManager:createImage", name, tostring(idGroup), icon, level, pos.x, pos.y, InitiativeOrPassive)
    self:showUseName(BattleCommon:getPointTable(pos.x,pos.y + 20), name, InitiativeOrPassive, hero)
end

--@brief    道具出现
function BattleProfessionSkillManager:showImage(sprite, isCallBack, InitiativeOrPassive)

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
function BattleProfessionSkillManager:actionInitiativeEnd(element)
    WZLog("BattleProfessionSkillManager:actionInitiativeEnd")

    element:removeFromParentAndCleanup(true)
    self.m_bIconShowEnd = true

    if self.m_nTriggerInitiativeCount == 0 and self.m_bIconShowEnd == true then
        self.m_nState = ProfessionSkillState.INITIATIVE_END
        self.m_tInitiativeMsg:usePetSkillOkCallback()
        self.m_tInitiativeMsg = nil
        self.m_bIconShowEnd = nil
    end
end

--@brief    道具出现回调
function BattleProfessionSkillManager:InitiativeOrPassive(element)
    WZLog("BattleProfessionSkillManager:InitiativeOrPassive")

    element:removeFromParentAndCleanup(true)
end

--@brief    显示使用道具技能的名字
--@param    heroPos:英雄位置
--@param    useName:显示名字
--@note
function BattleProfessionSkillManager:showUseName(heroPos, useName, InitiativeOrPassive, hero)
    local ttf = nil
    local nStart = string.find(useName, ".png")
    if nStart then 
        ttf = createImage(useName, nil, nil, true, GlobalMethod:ccp(0.5,0.5))
    else
        ttf = WZUILabelTTF:create()
        ttf:setColor(GlobalMethod:ccc3(255,227,116))
        ttf:setFontSize(40)
        ttf:setText(useName or "")
        ttf:setBoldFont(true)
        ttf:setTouchEnable(false)
        ttf:setEnableStroke(true)
        ttf:setStrokeSize(3)
        ttf:setStrokeColor(GlobalMethod:ccc3(128, 54, 13))
    end

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
    elseif InitiativeOrPassive == 1 then
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
    elseif InitiativeOrPassive == 1 then
        actionFadeTo:setFinishLuaFunction("actionPlayEffectPassiveEnd")
    else
        actionFadeTo:setFinishLuaFunction("actionPlayEffectEnd")
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
    if hero and hero.m_nHideOpecity and hero.m_nHideOpecity == 0 then 
        ttf:setVisible(false)
    end
    
    return ttf
end

--@brief    道具出现文字回调
function BattleProfessionSkillManager:actionPlayEffectInitiativeNext(element)
    self.m_bInitiativeShowEnd = true
    WZLog("BattleProfessionSkillManager:actionPlayEffectInitiativeNext")
end

--@brief    道具出现文字回调
function BattleProfessionSkillManager:actionPlayEffectPassiveNext(element)
    self.m_bPassiveShowEnd = true
    WZLog("BattleProfessionSkillManager:actionPlayEffectPassiveNext")
end

--@brief    道具出现文字回调
function BattleProfessionSkillManager:actionPlayEffectInitiativeEnd(element)
    element:removeFromParentAndCleanup(true)
    --self.m_bInitiativeShowEnd = true
    WZLog("BattleProfessionSkillManager:actionPlayEffect")
end

--@brief    道具出现文字回调
function BattleProfessionSkillManager:actionPlayEffectPassiveEnd(element)
    element:removeFromParentAndCleanup(true)
    --self.m_bPassiveShowEnd = true
    WZLog("BattleProfessionSkillManager:actionPlayEffectPassiveEnd")
end

--@brief    道具出现文字回调
function BattleProfessionSkillManager:actionPlayEffectEnd(element)
    element:removeFromParentAndCleanup(true)
    --self.m_bPassiveShowEnd = true
    WZLog("BattleProfessionSkillManager:actionPlayEffectEnd")
end

--@brief 获取职业被动技能
--@param type 1 被动 0 主动
--@return skillList
function BattleProfessionSkillManager:getProfessionPassiveSkill(hero,skillType)
    local skillList = {}
    local professionSkill = hero.m_tProfessionSkills
    if not professionSkill then
        return
    end
    WZLog("BattleProfessionSkillManager:triggerProfessionSkill",hero:getBattleId())
    --职业中的宠物被动技能
    if professionSkill and skillType == 1 then 
        for id, skillId in ipairs(professionSkill.id) do
            local professionData = GDatatab_mage_Skill["id_" .. skillId]
            if professionData and (professionData.type == 9 or professionData.type == 7) and type(professionData.attribute) == "number" then 
                local skillInfo = GDatatab_skill["id_".. professionData.attribute]
                if skillInfo ~= nil and ((skillInfo.skill_type == 4 and skillInfo.sub_type == skillType) or (skillInfo.skill_type ~= 4 and skillInfo.type == skillType)) then
                    local rate = skillInfo.rate
                    local isTrigger = self:_getProfessionRandNum(hero:getBattleId(), professionData.attribute) <= rate
                    if skillInfo.rate == -1 then 
                        isTrigger = true
                    end

                    WZLog("BattleProfessionSkillManager:getProfessionPassiveSkill four", id, skillId, professionSkill.name[id], self:_getProfessionRandNum(hero:getBattleId(), professionData.attribute), rate)
                    if isTrigger then
                        WZLog("BattleProfessionSkillManager:getProfessionPassiveSkill five", id)
                        if hero.m_tDoneProfessionPassiveSkill == nil then hero.m_tDoneProfessionPassiveSkill = {} end
                        table.insert(hero.m_tDoneProfessionPassiveSkill, skillId)
                        table.insert(skillList, {hero=hero, skillId=professionData.attribute, name=skillInfo.name, icon=skillInfo.icon, level=professionSkill.lv[id]})
                    end
                end
            end
        end
    end

    return skillList
end
--@brief 触发职业被动技能
--@param type 1 被动 0 主动
--@return skillList
function BattleProfessionSkillManager:triggerProfessionPassiveSkill(heroList)
    WZLog("BattleProfessionSkillManager:triggerProfessionPassiveSkill one", #heroList)
    self.m_tPassiveShowList = {}
    self.m_nState = ProfessionSkillState.PASSIVE_START
   
    local triggerSkillList = {}
    for i,hero in pairs(heroList) do
        local list = BattleProfessionSkillManager:getProfessionPassiveSkill(hero,1)
        if list then
            self.m_nTriggerPassiveCount = self.m_nTriggerPassiveCount + #list
            WZLog("BattleProfessionSkillManager:triggerProfessionPassiveSkill two",self.m_nTriggerPassiveCount, #list)
            table.insert(triggerSkillList,list)
        end
    end

    if self.m_nTriggerPassiveCount == 0 then
        self.m_nState = ProfessionSkillState.PASSIVE_END
        return true
    end

    for i,list in ipairs(triggerSkillList) do
        for i,info in pairs(list) do
            WZLog("BattleProfessionSkillManager:triggerProfessionPassiveSkill four", info.skillId)
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

    return false
end

--@brief    获取随机数
function BattleProfessionSkillManager:_getProfessionRandNum(battleId, skillId)
    local randNumIndex = math.abs((battleId + skillId) % 10 + 1)
    local randNumList = WBattleGlobal:getCurrent().m_tBattleRand
    local secIndex = math.abs((randNumList[randNumIndex] + battleId + skillId) % 10 + 1)

    return randNumList[secIndex]
end

--@brief 触发buff被动技能
--@param type 1 被动 0 主动
--@return skillList
function BattleProfessionSkillManager:triggerBuffPassiveSkill(heroList)
    WZLog("BattleProfessionSkillManager:triggerBuffPassiveSkill one", #heroList)
   
    local triggerSkillList = {}
    for i,hero in pairs(heroList) do
        if hero.m_tBuffAttributeChangeStateList and hero.m_tBuffAttributeChangeStateList[EffectTypeConfig.PROFESSION_SAVELIFE_PERCENT_TWO] and hero.m_tBuffAttributeChangeStateList[EffectTypeConfig.PROFESSION_SAVELIFE_PERCENT_TWO].type ~= nil then 
            WZLog("BattleProfessionSkillManager:triggerBuffPassiveSkill two")
            local tLeftHPValue = hero.m_tBuffAttributeChangeStateList[EffectTypeConfig.PROFESSION_SAVELIFE_PERCENT_TWO]
            local isTrigger = BattleProfessionSkillManager:_getProfessionRandNum(hero:getBattleId(), tLeftHPValue.buffId) <= tLeftHPValue.rate --使用buffId获取随机数判断概率触发
            WZLog("BattleProfessionSkillManager:triggerBuffPassiveSkill three", isTrigger)
            if isTrigger then 
                hero:addImmunityPetSkill(tLeftHPValue.buffId, tLeftHPValue)
            end
        end
    end

    return false
end
-------------------------------------私有方法模块End----------------------------------------
