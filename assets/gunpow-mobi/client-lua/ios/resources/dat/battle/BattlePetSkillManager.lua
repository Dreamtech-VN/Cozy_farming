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
end

--@brief 触发技能
--@param type 1 被动 0 主动
--@return skillList
function BattlePetSkillManager:triggerPetSkill(hero,skillType)
    local skillList = {}
    local petSkill = hero.m_tPetSkills
    if not petSkill then
        return
    end
    WZLog("BattlePetSkillManager:triggerPetSkill",hero:getBattleId())
    for id,skillId in ipairs(petSkill.id) do
        local rate = petSkill.rate[id]
        local isTrigger = self:_getRandNum(hero:getBattleId(),id) < rate

        WZLog("BattlePetSkillManager:triggerPetSkill two", id, skillId,petSkill.name[id], self:_getRandNum(hero:getBattleId(),id), rate)
        if petSkill.itemSubType[id] == skillType and isTrigger then
            WZLog("BattlePetSkillManager:triggerPetSkill three", id)
            table.insert(skillList, {hero=hero, skillId=skillId, name=petSkill.name[id], icon=petSkill.icon[id], level=petSkill.lv[id]})
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

    local triggerSkillList =  BattlePetSkillManager:triggerPetSkill(hero,0)
    

    if #triggerSkillList == 0 then
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

    self.m_nTriggerInitiativeCount = #self.m_tInitiativeShowList
    if countClearBuff == #triggerSkillList and countClearBuffOk == 0 then
        return true
    end

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
   
    local triggerSkillList = {}
    for i,hero in pairs(heroList) do
        local list = BattlePetSkillManager:triggerPetSkill(hero,1)
        if list then
            self.m_nTriggerPassiveCount = self.m_nTriggerPassiveCount + #list
            WZLog("BattlePetSkillManager:triggerPassiveSkill two",self.m_nTriggerPassiveCount, #list)
            table.insert(triggerSkillList,list)
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

    -- self.m_tPassiveMsg = msg

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

--@brief 被动技能触发结束
function BattlePetSkillManager:isTriggerPassiveSkill()
    return self.m_nState == PetSkillState.PASSIVE_END
end

--@brief 技能每回合更新
function BattlePetSkillManager:updateByTurn()
    self.m_tPassiveShowEndList = {}
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	初始化Manager
function BattlePetSkillManager:_init()
	self.m_tProtocolPool = {}
	self.m_tTurnRecordList = {}
    self.m_tPassiveShowEndList = {}
end

--@brief    创建技能图标
function BattlePetSkillManager:createImage(name, icon, level, pos, InitiativeOrPassive)
    WZLog("BattlePetSkillManager:createImage", name, icon, level, pos.x, pos.y, InitiativeOrPassive)
    self:showUseName(BattleCommon:getPointTable(pos.x,pos.y + 55), name, InitiativeOrPassive)

    -- local bg = WZUIImage:create()
    -- bg:setFile("ui/common/common_icon_jinengkuang.png")
    -- bg:setUseOriginSize(true)

    -- local sprite = WZUIImage:create()
    -- sprite:setFile("image/"..icon)
    -- sprite:setUseOriginSize(true)

    -- SceneBattle:getFrontLayer():addChild(bg)
    -- bg:addChild(sprite,1,1)

    -- local lvIcon = level
    -- if lvIcon and lvIcon ~= "" then
    --     local x,y = 0.7,0.2

    --     local lv = WZUIImage:create()
    --     lv:setUseOriginSize(true)
    --     lv:setFile(lvIcon)
    --     lv:setRelativePositionLuaTo(x,y)
    --     bg:addChild(lv,2,2)
    -- end

    -- bg:setPositionX(pos.x)
    -- bg:setPositionY(pos.y)
    
    -- self:showImage(bg:getChildByTag(1))
    -- self:showImage(bg:getChildByTag(2))
    -- self:showImage(bg, true, InitiativeOrPassive)
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

--@brief    获取随机数
function BattlePetSkillManager:_getRandNum(battleId,index)
    local randNumIndex = battleId % 10 + 1
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

-------------------------------------私有方法模块End----------------------------------------
