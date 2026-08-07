--BattleMsgGetProp.lua
--@brief	战斗相关消息
--@date		2017/11/14
--@author	莫剑峰
--@note		获得道具

--@brief	消息数据表
BattleMsgGetProp = {
    m_sName = "BattleMsgGetProp",

    m_tData = nil,
    m_nCount = 0,
    m_bIsProfessionSkill = false 
}

-------------------------------------公有方法模块--------------------------------------

--@brief	消息初始化函数
--@note		消息系统第一次调用process函数前调用
function BattleMsgGetProp:init()
    WZLog("BattleMsgGetProp:init one", Serialize(self.m_tData.playerIds), Serialize(self.m_tData.propsIds))

    for i,v in ipairs(self.m_tData.playerIds) do
        local playerId, propsId = v, self.m_tData.propsIds[i]
        if self.m_bIsProfessionSkill then 
            self:addProp_ProfessionSkillPath(playerId, propsId)
        else
            self:addProp(playerId, propsId)
        end
    end
end

--@brief    添加道具
function BattleMsgGetProp:addProp(playerId, propsId)
    
    if WBattleGlobal:getCurrent():getMyBattleId() == playerId then
        WZLog("BattleMsgGetProp:addProp", playerId, BattleMsgGetProp.m_nCount, Serialize(propsId))
        -- BattleMsgGetProp.m_nCount = BattleMsgGetProp.m_nCount + 1
        -- if BattleMsgGetProp.m_nCount % 2 == 0 then
        --     propsId = {[1]=61}
        -- end
        
        local ligth = {}
        local ids = CopyTable(WBattleGlobal:getCurrent().m_tMyProp_Beginning.id)
        ids = ids and ids or {}
        for i,v in ipairs(propsId) do
            local isExist = false
            local index = 0
            for k,u in ipairs(ids) do
                WZLog("BattleMsgGetProp:init two", v, u, index)
                if u == v then
                    isExist = true
                elseif index == 0 and u <= 0 then
                    index = k
                end
            end
            if isExist == false and index ~= 0 then
                ids[index] = v
                table.insert(ligth, index)
            end
        end

        local id={}
        local name={}
        local icon={}
        local lv={}
        local priceCostGold={}
        local desc={}
        local itemMainType={}
        local itemSubType={}
        local param1={}
        local param2={}
        local tireValue={}
        local consumePower={}
        local specialAttackType={}
        local specialAttackParam={}
        local effectId={}
        local coolSkillTime = {}
        local startCoolSkillTime = {}

        local index = 1
        local openCount = 0
        local closeCount = 0
        for i = index, #ids do
            local item = ids[i]
            local itemId = item <= 0 and item or item
            --itemId = 164

            WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_HitPropOK two_1", itemId)
            local itemInfo = {name = 0, icon = 0, lv = 0, desc = 0, type = 0, subType = 0, parm1 = 0, parm2 = 0, consume = 0, specialAttackType = 0, specialAttackParam = 0, effect_id = {{-1}},cooling_time = 0,start_time=0,}
            if itemId > 0 and GDatatab_skill["id_"..itemId] then
                table.insert(id,itemId)
                itemInfo = GDatatab_skill["id_"..itemId]
                table.insert(name,itemInfo.name)
                table.insert(icon,itemInfo.icon)
                table.insert(lv,itemInfo.lv_icon)
                table.insert(priceCostGold,0)
                table.insert(consumePower,itemInfo.consume)
                table.insert(specialAttackType,itemInfo.specialAttackType)
                table.insert(specialAttackParam,itemInfo.specialAttackParam)
                table.insert(effectId,itemInfo.effect_id[1][1])
                --挖坑赛飞行技能冷却时间+2000
                if itemId == 62 and WBattleGlobal:getCurrent():isDigGappingFighting() then 
                    table.insert(coolSkillTime, itemInfo.cooling_time + g_nAdditionCoolTime)
                else
                    table.insert(coolSkillTime, itemInfo.cooling_time)
                end
                table.insert(startCoolSkillTime,itemInfo.start_time)
                WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_HitPropOK two_2", itemId)
            elseif itemId == 0 then
                openCount = openCount + 1
            elseif itemId == -1 then
                closeCount = closeCount + 1
            end
        end

        WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_HitPropOK two_3", openCount, closeCount)
        for i = 1, openCount do
            table.insert(id,0)
            local itemInfo = {name = 0, icon = 0, lv = 0, desc = 0, type = 0, subType = 0, parm1 = 0, parm2 = 0, consume = 0, specialAttackType = 0, specialAttackParam = 0, effect_id = {{-1}},cooling_time = 0,start_time=0,}
            table.insert(name,itemInfo.name)
            table.insert(icon,itemInfo.icon)
            table.insert(lv,itemInfo.lv_icon)
            table.insert(priceCostGold,0)
            table.insert(consumePower,itemInfo.consume)
            table.insert(specialAttackType,itemInfo.specialAttackType)
            table.insert(specialAttackParam,itemInfo.specialAttackParam)
            table.insert(effectId,itemInfo.effect_id[1][1])
            table.insert(coolSkillTime,itemInfo.cooling_time)
            table.insert(startCoolSkillTime,itemInfo.start_time)
        end

        for i = 1, closeCount do
            table.insert(id,-1)
            local itemInfo = {name = 0, icon = 0, lv = 0, desc = 0, type = 0, subType = 0, parm1 = 0, parm2 = 0, consume = 0, specialAttackType = 0, specialAttackParam = 0, effect_id = {{-1}},cooling_time = 0,start_time=0,}
            table.insert(name,itemInfo.name)
            table.insert(icon,itemInfo.icon)
            table.insert(lv,itemInfo.lv_icon)
            table.insert(priceCostGold,0)
            table.insert(consumePower,itemInfo.consume)
            table.insert(specialAttackType,itemInfo.specialAttackType)
            table.insert(specialAttackParam,itemInfo.specialAttackParam)
            table.insert(effectId,itemInfo.effect_id[1][1])
            table.insert(coolSkillTime,itemInfo.cooling_time)
            table.insert(startCoolSkillTime,itemInfo.start_time)
        end

        WBattleGlobal:getCurrent().m_tMyProp_Beginning = {count=5, id=id, name=name, icon=icon, lv=lv, priceCostGold=priceCostGold, desc=desc, itemMainType=itemMainType, itemSubType=itemSubType, param1=param1, param2=param2, tireValue=tireValue, consumePower=consumePower, specialAttackType=specialAttackType, specialAttackParam=specialAttackParam, effectId=effectId, coolSkillTime=coolSkillTime, startCoolSkillTime=startCoolSkillTime}
        WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_HitPropOK three",Serialize(WBattleGlobal:getCurrent().m_tMyProp_Beginning))
        for i=1,5 do
            WndBattleHud.m_tUseItem[i] = 1
            WndBattleHud:getItemCostCell(i):setVisible(true)
        end
        
        local curRoundAction = WBattleGlobal:getCurrent().m_tCurRoundAction
        if curRoundAction and curRoundAction.round == WBattleGlobal:getCurrent().m_nTurnTimes or WBattleGlobal:getCurrent():isMyTurn() ~= true then
            WndBattleHud:resetItem(nil, true)
        else
            WndBattleHud:resetItem()
        end

        for i,v in ipairs(ligth) do
            local con, anim = WndBattleHud:getItemLigthCell(v)
            con:setVisible(true)
            anim:setAnimationName("props_effect")
        end
    else
        local hero = WBattleGlobal:getCurrent():getCharacterWithId(playerId)
        if hero then
            local ids = CopyTable(hero.m_tItems)
            ids = ids and ids or {}
            for i,v in ipairs(propsId) do
                local isExist = false
                local index = 0
                for k,u in ipairs(ids) do
                    if u == v then
                        isExist = true
                    elseif index == 0 and u <= 0 then
                        index = k
                    end
                end
                if isExist == false and index ~= 0 then
                    ids[index] = v
                end
            end
            hero.m_tItems = ids
            WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_HitPropOK four", hero:getBattleId() ,Serialize(hero.m_tItems))
        end
    end
end

--@brief    玩家触发职业技能，重新获得已使用过的某一道具逻辑
function BattleMsgGetProp:addProp_ProfessionSkillPath(playerId, propsId)
    
    if WBattleGlobal:getCurrent():getMyBattleId() == playerId then
        WZLog("BattleMsgGetProp:addProp_ProfessionSkillPath", playerId, Serialize(propsId))

        local ids = CopyTable(WBattleGlobal:getCurrent().m_tMyProp_Beginning.id)
        local isExist = false
        local index = 0
        local otherIndex = nil 
        for i, v in ipairs(propsId) do
            for k, u in ipairs(ids) do
                WZLog("BattleMsgGetProp:init two", v, u, index)
                if u == v then
                    if WndBattleHud.m_tUseItem[k] <= 0 then 
                        isExist = true
                        index = k
                        break 
                    end
                end
                if otherIndex == nil and WndBattleHud.m_tUseItem[k] <= 0 then 
                    otherIndex = k
                end
            end
            if isExist then
                WndBattleHud.m_tUseItem[index] = 1
                WndBattleHud:getItemCell(index):setVisible(true)
                WndBattleHud:getItemCostCell(index):setVisible(true)
            else
                if otherIndex then 
                    local tMyProp = WBattleGlobal:getCurrent().m_tMyProp_Beginning
                    tMyProp.id[otherIndex] = v
                    local itemInfo = {name = 0, icon = 0, lv = 0, desc = 0, type = 0, subType = 0, parm1 = 0, parm2 = 0, consume = 0, specialAttackType = 0, specialAttackParam = 0, effect_id = {{-1}},cooling_time = 0,start_time=0,}
                    if v > 0 and GDatatab_skill["id_"..v] then
                        itemInfo = GDatatab_skill["id_"..v]
                        tMyProp.name[otherIndex] = itemInfo.name
                        tMyProp.icon[otherIndex] = itemInfo.icon
                        tMyProp.lv[otherIndex] = itemInfo.lv_icon
                        tMyProp.priceCostGold[otherIndex] = 0
                        tMyProp.consumePower[otherIndex] = itemInfo.consume
                        tMyProp.specialAttackType[otherIndex] = itemInfo.specialAttackType
                        tMyProp.specialAttackParam[otherIndex] = itemInfo.specialAttackParam
                        tMyProp.effectId[otherIndex] = itemInfo.effect_id[1][1]
                        tMyProp.coolSkillTime[otherIndex] =  itemInfo.cooling_time
                        tMyProp.startCoolSkillTime[otherIndex] = itemInfo.start_time
                    end

                    WndBattleHud.m_tUseItem[index] = 1
                    WndBattleHud:getItemCell(index):setVisible(true)
                    WndBattleHud:getItemCostCell(index):setVisible(true)
                end
            end
        end
    else
        local hero = WBattleGlobal:getCurrent():getCharacterWithId(playerId)
        if hero then
            local ids = CopyTable(hero.m_tItems)
            ids = ids and ids or {}
            for i,v in ipairs(propsId) do
                local isExist = false
                local index = 0
                for k,u in ipairs(ids) do
                    if u == v then
                        isExist = true
                    elseif index == 0 and u <= 0 then
                        index = k
                    end
                end
                if isExist == false and index ~= 0 then
                    ids[index] = v
                end
            end
            hero.m_tItems = ids
            WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_HitPropOK four", hero:getBattleId() ,Serialize(hero.m_tItems))
        end
    end
end

--@brief	消息处理过程函数
--@return	#1,nil或true表示消息处理结束，否则返回false
--@note		未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgGetProp:process()
	WZLog("BattleMsgGetProp:process")
end

--@brief	消息处理完成函数
--@note		消息系统最后一次调用process函数后调用
function BattleMsgGetProp:done()
	WZLog("BattleMsgGetProp:done")
end

-------------------------------------私有方法模块--------------------------------------