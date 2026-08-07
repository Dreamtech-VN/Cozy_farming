--BattleAiCtrlHelper.lua
--@brief	机器人的Ai辅助数据表
--@date		2014/8/15
--@author	莫剑峰
--@note

--@brief	机器人的Ai辅助数据表
BattleAiCtrlHelper = {
    m_tHero = nil,                      --所属英雄
    m_tAtkTargetList = nil,             --选择目标列表
    m_tTargetPlayer = nil,              --目标玩家
    m_bIsUsedBlood = nil,
}

-------------------------------------公有方法模块--------------------------------------
--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function BattleAiCtrlHelper:new()
    WZLog("BattleAiCtrlHelper:new")
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self

    tNewObj.m_tAtkTargetList = {}
    
	return tNewObj
end

--@brief	销毁Ai辅助
function BattleAiCtrlHelper:destroy()
    WZLog("BattleAiCtrlHelper:destroy")
    self.m_tHero = nil
    self.m_tAtkTargetList = nil
    self.m_tTargetPlayer = nil
    self.m_bIsUsedBlood = nil

end

--@brief	设置英雄
function BattleAiCtrlHelper:setHero(hero)
    self.m_tHero = hero
    self.m_tHero.m_nRemainUseItemCount = 3
    --self.m_tHero:buildAiCombination()
end

--@brief	获取AI所属英雄
function BattleAiCtrlHelper:getHero()
    return self.m_tHero
end

--@brief	获取目标玩家
function BattleAiCtrlHelper:getTargetPlayer()

    local hero = self:getHero()
    
    if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS and hero:getIsGuai() ~= true then
        self.m_tTargetPlayer = WMonster:getRandomGuai()
    else
        self.m_tTargetPlayer = WMonster:getRandomPlayer()
    end

    if self.m_tTargetPlayer == nil then
        return
    end

    if WBattleGlobal:getCurrent().m_tMakePairOk.fighting == nil or WBattleGlobal:getCurrent().m_tMakePairOk.fighting[1] == nil then
        WZLog("BattleAiCtrlHelper:getTargetPlayer one",self.m_tTargetPlayer:getBattleId())
        return self.m_tTargetPlayer
    end

    --随机数
    local nTurnTimes = WBattleGlobal:getCurrent():getTurnTimes()
    local randNumIndex = nTurnTimes % 10 + 1
    local randNumList = WBattleGlobal:getCurrent().m_tBattleRand


    --目标英雄
    local tHeroList = WBattleGlobal:getCurrent():getHeroSortList()
    local nPlayerCount = 0
    local tPlayerIds = {}
    local tScore = {}
    local priorId = nil
    for i ,v in ipairs(tHeroList) do
        if not v:isDead() and WBattleGlobal:getCurrent():isSameTeam(v:getBattleId(),hero:getBattleId()) ~= true then
            nPlayerCount = nPlayerCount + 1
            tPlayerIds[nPlayerCount] = v.m_nPlayerId
            if not priorId and v:getHp() / v:getMaxHp() < 0.2 then
                priorId = v.m_nPlayerId
                break
            end

            --[[
            tScore[nPlayerCount] = 0

            local s1,s2,s3,s4,s5,s6 = 0,0,0,0,0,0
            s1 = hero:getLevel() / v:getLevel()
            s2 = 2 * hero.m_nFighting / v.m_nFighting
            s3 = hero.m_nWinRate / (v.m_nWinRate + 1000)
            s4 = 1 / (v:getHp() / v:getMaxHp() + 0.05)
            s5 = 720 / (math.abs(BattleCommon:pointDis(v:getPosition(), hero:getPosition())) + 72)

            if v.m_tHitTargets ~= nil then
                for j, u in pairs(v.m_tHitTargets) do
                    if u[1] == nTurnTimes - 1 and u[2] == hero:getBattleId() then
                        s6 = 5
                    end
                end
            end

            tScore[nPlayerCount] = s1 + s2 + s3 + s4 + s5 + s6
            WZLog("BattleAiCtrlHelper:getTargetPlayer two",v.m_nPlayerId,tScore[nPlayerCount],s1,s2,s3,s4,s5,s6)
            --]]
        end
    end
    local randomNum = randNumList[randNumIndex] % nPlayerCount + 1
    local targetHeroId = nil
    if priorId then 
        targetHeroId = priorId
    else
        local randomNum = randNumList[randNumIndex] % nPlayerCount + 1
        targetHeroId = tPlayerIds[randomNum]
    end
    --[[
    local index, maxScore = 1, 0
    for i ,v in pairs(tScore) do
        if v >= maxScore then
            index = i
            maxScore = v
        end
    end

    local targetHeroId = tPlayerIds[index]
    --]]

    self.m_tTargetPlayer = WBattleGlobal:getCurrent():getHeroWithId(targetHeroId)


    --WZLog("BattleAiCtrlHelper:getTargetPlayer zero",self.m_tTargetPlayer:getBattleId())
    return self.m_tTargetPlayer
end

--@brief	获取AI是否需要移动
--@return	1:是否需要移动
function BattleAiCtrlHelper:isNeedMove()
    local isNeedMove = 0
    local distance = math.abs(self:getHero():getPosition().x -  self.m_tTargetPlayer:getPosition().x)
    local distanceMove = 100 - distance --self:getHero().m_fRadiusForBulletExplode + self:getHero():getRadiusForHurt() - distance

    if distanceMove > 0 and self:getHero().m_nDebuffMoveLockRound==nil then
        isNeedMove = 1
    end

    if self:getHero():getPosition().x >= self.m_tTargetPlayer:getPosition().x then
        distanceMove = self:getHero():getPosition().x + distanceMove
    else
        distanceMove = self:getHero():getPosition().x - distanceMove
    end

    WZLog("BattleAiCtrlHelper:isNeedMove",isNeedMove, self:getHero().m_fRadiusForBulletExplode, self:getHero():getRadiusForHurt(), distance, distanceMove)
    return isNeedMove, { x=distanceMove, y=0}
end

--@brief	获取AI需要移动的距离
--@return	需移动的距离
function BattleAiCtrlHelper:getMoveDistance(direction)
    local isNeedMove = false
    local distance = math.abs(self:getHero():getPosition().x -  self.m_tTargetPlayer:getPosition().x)
    local distanceMove = self:getHero().m_fRadiusForBulletExplode + self:getHero():getRadiusForHurt() + 40 - distance
    if direction == 0 then  --移向右边
        if self:getHero():getPosition().x >= self.m_tTargetPlayer:getPosition().x then
            distanceMove = math.abs(distanceMove)
        else
            distanceMove = math.abs(distanceMove) + self:getHero().m_fRadiusForBulletExplode
        end
    elseif direction == 1 then  --移向左边
        if self:getHero():getPosition().x < self.m_tTargetPlayer:getPosition().x then
            distanceMove = math.abs(distanceMove)
        else
            distanceMove = math.abs(distanceMove) + self:getHero().m_fRadiusForBulletExplode
        end
    end

    WZLog("BattleAiCtrlHelper:getMoveDistance", self:getHero().m_fRadiusForBulletExplode, distance, distanceMove, direction, self:getHero():getPosition().x, self.m_tTargetPlayer:getPosition().x, self:getHero():getRadiusForHurt())
    return distanceMove
end

--@brief    判断AI是否能够采取的技能行动
function BattleAiCtrlHelper:isCanUseSkill(id)
    WZLog("BattleAiCtrlHelper:isCanUseSkill one", id)
    if not id or id == -1 then
        return false
    end

    local isCanUse = false

    local hero = self:getHero()
    if not hero.m_tSkills then
        return false
    end

    local isHaveSkill = false
    for i,v in pairs (hero.m_tSkills) do
        WZLog("BattleAiCtrlHelper:isCanUseSkill two-1", i, id, v)
        if id == v then
            isHaveSkill = true
            break
        end
    end

    local isCd = false
    for i,v in pairs(hero.m_tSkillCdList) do
        WZLog("BattleAiCtrlHelper:isCanUseSkill two-2", i, id, v)
        if i == id and v > 0 then
            isCd = true
            break
        end
    end

    if isHaveSkill == false or hero.m_nDebuffSealRound ~= nil or isCd == true then
        return false
    end
    isCanUse = isHaveSkill
    WZLog("BattleAiCtrlHelper:isCanUseSkill three", tostring(isCanUse))
    return isCanUse
end

--@brief    判断AI是否能够采取的道具行动
function BattleAiCtrlHelper:isCanUseItem(id)
    WZLog("BattleAiCtrlHelper:isCanUseItem one", id)
    if not id or id == -1 then
        return false
    end
    local isCanUse = false

    local hero = self:getHero()
    local isHaveItem = false
    if not hero.m_tItems then
        return false
    end
    for i,v in pairs (hero.m_tItems) do
        WZLog("BattleAiCtrlHelper:isCanUseItem two", i, id, v)
        if id == v then
            isHaveItem = true
            break
        end
    end

    local isCd = false
    for i,v in pairs(hero.m_tItemCdList) do
        WZLog("BattleAiCtrlHelper:isCanUseItem two-2", i, id, v)
        if i == id and v > 0 then
            isCd = true
            break
        end
    end

    if isHaveItem == false or hero.m_nDebuffSealRound ~= nil or isCd == true then
        WZLog("BattleAiCtrlHelper:isCanUseItem three", tostring(isCanUse), tostring(isHaveItem))
        isCanUse = false
        return false
    end

    isCanUse = isHaveItem
    
    if not WBattleGlobal:getCurrent():getItemById(id) then
        return false
    end

    WZLog("BattleAiCtrlHelper:isCanUseItem four", tostring(isCanUse), WBattleGlobal:getCurrent():getItemById(id).consumePower)
    return isCanUse
end

--@brief    判断AI采取的技能道具行动
--@return	选择的道具编号
function BattleAiCtrlHelper:getUseItemAction()
    local itemId,itemId2 = -1,-1

    local hero = self:getHero()
    if hero.m_nRemainUseItemCount <= 0 then
        return itemId
    end
    local random = hero:getAI():getCurRandNum()
    WZLog("BattleAiCtrlHelper:getUseItemAction one", hero:getBattleId(),hero:getHp(), hero:getMaxHp(), hero:getPF(), random)
    --[[
    if self.m_bIsUsedBlood ~= true and hero:getHp() < hero:getMaxHp() * 0.5 then
        WZLog("BattleAiCtrlHelper:getUseItemAction two")
        itemId = BattleHeroUse.ITEM_BLOOD
        self.m_bIsUsedBlood = true
    end
    --]]
    if #hero.m_tItems > 0 then
        itemId = hero.m_tItems[1]
    end
    if itemId == BattleHeroUse.ITEM_FLY then
        itemId,itemId2 = -1,-1
    end
    WZLog("BattleAiCtrlHelper:getUseItemAction zero", itemId)
    return itemId,itemId2
end

--@brief    设置技能组合
function BattleAiCtrlHelper:setSkillCombos()
    do return end

    local hero = self:getHero()
    hero.m_tSkills = {}
    hero.m_tItems = {}

    --机器人
    if hero.m_tSkillItemList == nil then

        --技能
        local combos = WBattleGlobal:getCurrent().m_tAiSkillCombos
        WZLog("BattleAiCtrlHelper:setSkillCombos one", combos)
        if combos == nil or #combos == 0 or type(combos[1]) == "string" then
            combos = SplitAiStringWithSeparator("(3,18,6),(2,18,7),(2,4,7),(18,7,5)")
        end

        index = math.random(1, #combos)
        for i, v in pairs (combos[index]) do
            WZLog("BattleAiCtrlHelper:setSkillCombos two", tonumber(v))
            table.insert(hero.m_tSkills, tonumber(v))
        end

        --道具
        if hero.m_nRealLevel <= 20 then
            hero.m_nHitRate = 60
            table.insert(hero.m_tItems, BattleHeroUse.ITEM_ANGER)
        elseif hero.m_nRealLevel <= 30 then
            hero.m_nHitRate = 70
            table.insert(hero.m_tItems, BattleHeroUse.ITEM_ANGER)
            table.insert(hero.m_tItems, BattleHeroUse.ITEM_FOLLOW)
        else
            hero.m_nHitRate = 80
            table.insert(hero.m_tItems, BattleHeroUse.ITEM_ANGER)
            table.insert(hero.m_tItems, BattleHeroUse.ITEM_ANGER)
            table.insert(hero.m_tItems, BattleHeroUse.ITEM_BLOOD)
        end

    elseif hero.m_tSkillItemList ~= "-1" and hero.m_tSkillItemList ~= "" then
    --单人副本

        local combos = hero.m_tSkillItemList
        WZLog("BattleAiCtrlHelper:setSkillCombos one1", combos)
        combos = SplitAiStringWithSeparator(combos)

        for i, v in pairs (combos[1]) do
            WZLog("BattleAiCtrlHelper:setSkillCombos two1", tonumber(v))
            table.insert(hero.m_tSkills, tonumber(v))
        end

        for i, v in pairs (combos[2]) do
            WZLog("BattleAiCtrlHelper:setSkillCombos two2", tonumber(v))
            table.insert(hero.m_tItems, tonumber(v))
        end

    end
    WZLog("BattleAiCtrlHelper:setSkillCombos zero", combos)
end

--@brief	计算直线射击
--@return   发射速度
function BattleAiCtrlHelper:shootLine(shootPower)
    local hero = self.m_tHero

    local targetHero = self.m_tHero:getAI().m_tTargetPlayer

    local eOffset = BattleCommon:getPointTable(targetHero.m_anim:getAnimNode():getContentSize().width * 0, targetHero.m_anim:getAnimNode():getContentSize().height * 0.3)
    local sPos = BattleCommon:getPointTable(hero:getPosition().x, hero:getPosition().y)
    local ePos = BattleCommon:getPointTable(targetHero:getPosition().x + eOffset.x,targetHero:getPosition().y + eOffset.y)
    local angle
    local face

    local power = 5
    local scale = 2
    if shootPower ~= nil then
        scale = shootPower
    end
    local speed = {}

    if ePos.x <= sPos.x then
        face = 1
    else
        face = 0
    end

    if face == 1 then
        speed.x = -1 * scale
    else
        speed.x = scale
    end

    --斜率公式
    if (ePos.x - sPos.x == 0) then
        speed.x = 0
        speed.y = 10
    elseif (ePos.y - sPos.y == 0) then
        if (ePos.x - sPos.x >= 0) then
            speed.x = 10
        else
            speed.x = -10
        end
        speed.y = 5
    else
        speed.y = (speed.x) / ((ePos.x - sPos.x) / (ePos.y - sPos.y))
    end
    if false and (ePos.y - sPos.y > 500 or math.abs(speed.y) > 3.3) then
        speed.x = speed.x * 1
        speed.y = speed.y * 1
    else
        speed.x = speed.x * power
        speed.y = speed.y * power
    end

    WZLog("BattleAiCtrlHelper:shootLine", speed.x, speed.y, ePos.x, ePos.y, sPos.x, sPos.y, power)
    return speed
end

-------------------------------------私有方法模块--------------------------------------
