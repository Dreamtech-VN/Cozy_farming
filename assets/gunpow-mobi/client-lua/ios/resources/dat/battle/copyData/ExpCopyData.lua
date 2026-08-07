--ExpCopyData.lua
--@brief    经验副本
--@date     2015/06/25
--@note     经验副本显示信息与胜利条件控制

ExpCopyData = {}

--@brief    以本表为模版创建一个新的表实例对象
--@return   新建的表实例对象
function ExpCopyData:new()
    setmetatable(ExpCopyData,{__index = BaseCopyData})
    local tNewObj = {}
    setmetatable(tNewObj, { __index = ExpCopyData })
    tNewObj:_init()
    tNewObj.m_killNumLab = nil   --杀死怪物数量显示文本
    tNewObj.m_killEliteNumLab = nil   --杀死怪物数量显示文本
    tNewObj.m_killBossNumLab = nil   --杀死怪物数量显示文本
    tNewObj.m_loseNumLab = nil      --丢失怪物
    tNewObj.m_totalExpLab = nil     --总经验

    tNewObj.m_killNum = 0       --杀死怪物数量
    tNewObj.m_killEliteNum = 0  --杀死精英怪物数量
    tNewObj.m_killBossNum = 0   --杀死boss怪物数量
    tNewObj.m_totalExpNum = 0   --总经验

    tNewObj.m_nRoundNum = 0
    tNewObj.m_nMaxRound = 6

    tNewObj.m_nAttackDistance = 100  ---怪物攻击距离
    tNewObj.m_nDefaultDistance = 400   --默认移动距离

    tNewObj.m_nSummonCount = 0
    tNewObj.m_nLostCount = 0
    tNewObj.m_tMapInfo = CopyTable(GDatatab_daily_map["id_"..WBattleGlobal:getCurrent().m_tMakePairOk.mapId])

    tNewObj.m_fightData = {fightData = {}}
    tNewObj.m_fightData.mapId = WBattleGlobal:getCurrent().m_tMakePairOk.mapId
    tNewObj.m_fightData.fightId = 2
    return tNewObj
end

--@brief    初始化对象
function ExpCopyData:_init()
    BaseCopyData._init(self)
    self:_initEvent()
end

--@brief 销毁
function ExpCopyData:destroy()
    WZLog("ExpCopyData:destroy")
    self:_removeEvent()
    if self.m_viewNode and self.m_viewNode:getParent() then
        self.m_viewNode:removeFromParentAndCleanup(true)
    end
    self.m_viewNode = nil
    self.m_killNumLab = nil   
    self.m_killEliteNumLab = nil   
    self.m_killBossNumLab = nil   
    self.m_killNum = nil       
    self.m_killEliteNum = nil  
    self.m_killBossNum = nil   
    self.m_fightData = nil
    self.m_loseNumLab = nil
end


--@brief 创建显示信息
--@return 显示面板
function ExpCopyData:getInfoView()
    WZLog("ExpCopyData:getInfoView")
    if not self.m_viewNode then
        self.m_viewNode = WndCopyExpInfoView:createElement()

        --self.m_viewNode:setRelativePositionLuaTo(1,0.88)

        self.m_killBossNumLab = GetElement(self.m_viewNode, "bossNum_WndCopperInfoView", WZUILabelTTF)
        self.m_killEliteNumLab = GetElement(self.m_viewNode, "eliteNum_WndCopperInfoView", WZUILabelTTF)
        self.m_killNumLab = GetElement(self.m_viewNode, "commonNum_WndCopperInfoView", WZUILabelTTF)
        self.m_loseNumLab = GetElement(self.m_viewNode, "txtFailNum_WndCopperInfoView", WZUILabelTTF)
        self.m_totalExpLab = GetElement(self.m_viewNode,"txtCurExp_WndCopperInfoView",WZUILabelTTF)
    end
    self:updateKillNum()
    return self.m_viewNode

end


--@brief 杀死怪物
function ExpCopyData:killMonster(monsterId,battleId,pos)
    local monsterData = BossData["id_"..monsterId]
    if not monsterData then
        return
    end
    local exp = 0
    if monsterData.type == MonsterType.COMMON then
        self.m_killNum = self.m_killNum + 1
        -- exp = self.m_tMapInfo.parameter3
    elseif monsterData.type == MonsterType.ELITE then
        self.m_killEliteNum = self.m_killEliteNum + 1
        -- exp = self.m_tMapInfo.parameter4
    elseif monsterData.type == MonsterType.BOSS then
        self.m_killBossNum = self.m_killBossNum + 1
        -- exp = self.m_tMapInfo.parameter5
    end
    --self.m_totalExpNum = self.m_totalExpNum + exp
    

    local dailyData = self.m_tMapInfo
    local pLevel = CacheCenter:getPlayerInfo().level

    -- 基础杀怪经验值
    local addBaseExp = 0
    addBaseExp = dailyData.parameter3 * self.m_killNum
    addBaseExp = addBaseExp + dailyData.parameter4 * self.m_killEliteNum
    addBaseExp = addBaseExp + dailyData.parameter5 * self.m_killBossNum

    local expData = GDatatab_player_upgrade["id_"..pLevel]
    local power = dailyData.pass_consume + dailyData.play_consume + 5
    local vigor = expData.vigor
    self.m_totalExpNum = math.floor(expData.exp*(expData.level_up/10000)*(addBaseExp/10000)*(power/expData.vigor)) + 1


    self:updateKillNum()
    --DelayCallFunction(self.createKillMonsterEffect, self,2,pos)
    --self:createKillMonsterEffect(pos)
end

function ExpCopyData:updateKillNum()
    self.m_killNumLab:setText(tostring(self.m_killNum))
    self.m_killEliteNumLab:setText(tostring(self.m_killEliteNum))
    self.m_killBossNumLab:setText(tostring(self.m_killBossNum))
    self.m_loseNumLab:setText(tostring(self.m_nLostCount).."/"..tostring(self.m_tMapInfo.parameter6))
    self.m_totalExpLab:setText(tostring(self.m_totalExpNum))
end

--@breif 创建杀怪特效
function ExpCopyData:createKillMonsterEffect(pos)
    pos = pos or BattleCommon:getPointTable(0,0)
    local element = WZUISystem:getInstance():createElement(string.format("conHurtType%d_HurtNumber",0))
    element:setLuaObjectIndex(self)
    if element ~= nil then
        GetElement(element,"txtHurtValue_HurtNumber",WZUILabelAtlasFont):setText("exp+1000")
        local conHurt = WZUIContainer:luaTo(element)
        conHurt:setAbsPosition(GlobalMethod:ccp(pos.x - 100,pos.y + 120))
        SceneBattle:getFrontLayer():addChild(conHurt,6)
    end
end

--@brief    伤害数字显示完成的回调
function ExpCopyData:_finishFlyingNum(element)
    element:removeFromParentAndCleanup(true)
end

--@brief 回合开始前准备
function ExpCopyData:readyStartRound()
    -- if self:checkIsEnd() ~= 0 then
    --     self:copyEnd()
    --     return
    -- end

    -- if not WBattleGlobal:getCurrent():isMyTurn() then
    --     self.m_tMoveEndList = {}
    --     self.m_tTargetPos = {}
    --     self.m_tMonsterList = {}
    --     self.m_tMonsterMoveList = {}
    --     self.m_nTotalMove = 0
    
    --     local hero  = WBattleGlobal:getCurrent():getMyHero()
    --     local targetPos = hero:getPosition()

    --     local list = WBattleGlobal:getCurrent():getGuaiList()
    --     for key,guai in pairs(list) do
    --         WZLog("ExpCopyData:readyStartRound")
    --         if guai.m_tBoss ~= nil and not guai:isInBuffState(EffectTypeConfig.LIMIT_MOVE) and not guai:isInBuffState(EffectTypeConfig.LIMIT_ALL_ACTION) and not guai:isDead() then
    --             local gPos = guai:getPosition()
    --             WZLog("ExpCopyData:readyStartRound II",BattleCommon:pointDis(gPos,targetPos),gPos.x,gPos.y,targetPos.x,targetPos.y)
    --             if BattleCommon:pointDis(gPos,targetPos) > self.m_nAttackDistance then
    --                 local tmpPos = targetPos
    --                 if gPos.x > targetPos.x and math.abs(gPos.y - targetPos.y) < self.m_nAttackDistance then
    --                     tmpPos = self:getMoveDistance(guai,targetPos)
    --                 else
    --                     tmpPos = self:getMoveDistance(guai,{x = 0,y = gPos.y})
    --                 end
    --                 self.m_tTargetPos[key] = tmpPos
    --                 self.m_tMonsterMoveList[key] = guai
    --                 self.m_nTotalMove = self.m_nTotalMove + 1
    --             end
    --             table.insert(self.m_tMonsterList,guai)
    --             --local pos = guai:getPosition()
    --             --guai:moveToPos(GlobalMethod:ccp(pos.x - 200,0))
    --         else
    --             if not self.m_nBossBattleId then
    --                 self.m_nBossBattleId = guai:getBattleId()
    --                 self.m_nBoss = guai
    --             end
    --         end
    --     end

    --     self.m_bMovePlayed = false
    --     self.m_bIsMoveEnd = false
    --     self.m_sProcessState = "move"
    --     self.m_nDeadCount = 0
    -- else
    --     self.m_sProcessState = "end"
    -- end
    -- WZLog("ExpCopyData:readyStartRound",self.m_sProcessState)
end

function ExpCopyData:processReadyStartRound(dt)
--     if self:checkIsEnd() ~= 0 then
--         self:copyEnd()
--         return true
--     end

--     if self.m_sProcessState == "move" then
--         if self:monsterListMove() then
--             self.m_sProcessState = "attack"
--             self:readyMonsterListMeleeAttack()
--         end
--         return false
--     elseif self.m_sProcessState == "attack" then
--         if self:monsterListMeleeAttack() then
--             self.m_sProcessState = "end"
--         end
--         return false
--     end
--     return true
-- end

-- function ExpCopyData:doneReadyStartRound()
--     if self:checkIsEnd() ~= 0 then
--         self:copyEnd()
--         return true
--     end
    
--     self:zoomTo(WBattleGlobal:getCurrent():getMyHero())
end

--@brief    计算应该移动的距离
function ExpCopyData:getMoveDistance(monster,targetPos)
    local cur_pos = monster:getPosition()
    local target_pos = targetPos
    local x1 = cur_pos.x
    local y1 = cur_pos.y
    local x2 = target_pos.x
    local y2 = target_pos.y
    if y1 - y2 == 0 then y2 = y2-1 end
    local k = (x1 - x2) / (y1 - y2)
    local d0 = BattleCommon:pointDis(cur_pos, target_pos)
    local d = d0 < self.m_nDefaultDistance and d0 or self.m_nDefaultDistance
    
    local y3
    if (x1 > x2 and y1 < y2) or (x1 < x2 and y1 < y2) then
        y3 = y1 + d / math.sqrt(k * k + 1)
    else
        y3 = y1 - d / math.sqrt(k * k + 1)
    end
    local x3 = x1 - k * (y1 - y3)
    local d1 = BattleCommon:pointDis(cur_pos, BattleCommon:getPointTable(x3, y3))
    --[[
    WZLog("ExpCopyData:getMoveDistance result", math.floor(x3), math.floor(y3))
    WZLog("ExpCopyData:getMoveDistance cur",  math.floor(x1), math.floor(y1))
    WZLog("ExpCopyData:getMoveDistance target", math.floor(x2), math.floor(y2))
    WZLog("ExpCopyData:getMoveDistance distance", math.floor(d0), math.floor(d1), math.floor(d), k)
    ]]
    return {x = x3, y = y3}
end

--@brief    小怪群移动
function ExpCopyData:monsterListMove()
    if not self.m_bMovePlayed then
        for id, monster in pairs (self.m_tMonsterMoveList) do
            monster:adjustDirect(self.m_tTargetPos[id])
            monster:getAnimation():play(monster:getAnimationName("move"), true)
        end
        self.m_bMovePlayed = true
    end
    local isFollow = true
    for id, monster in pairs (self.m_tMonsterMoveList) do

        local isMoveEnd = false
        for index, monsterMoveEndId in pairs (self.m_tMoveEndList) do
            if monster:getBattleId() == monsterMoveEndId then
                isMoveEnd = true
            end
        end

        if isMoveEnd == false then
            if monster:isDead() then
                self.m_nTotalMove = self.m_nTotalMove - 1
                self.m_tMonsterMoveList[id] = nil
            else
                if isFollow then
                    isFollow = false
                    self:followMonsterListMove(monster)
                end
                --monster:setPF(self.m_tOwner:getPF()-1)
                monster:setRunStatus(RunStatus.DEF_ST_MOVE)
                
                local cur_pos = monster.m_anim:getPosition()
                local target_pos = self.m_tTargetPos[id]
                
                if self.m_bIsMoveEnd == false then
                    monster:setMoveUpdatable(true)
                    monster:getMover():setMoveAcceleration(monster.m_tMoveSpeed.x,-1)
                end
                --达到可进行攻击的距离则移动结束
                if BattleCommon:checkCircleCollosion(cur_pos,self.m_nAttackDistance,target_pos,0) == true then
                    table.insert(self.m_tMoveEndList, monster:getBattleId())

                    monster:setMoveUpdatable(false)
                    monster:getMover():setMoveAcceleration(0,0)

                    monster:getAnimation():play(monster:getAnimationName("standby"), true)
                    
                    monster:setActFinished(true)
                    
                elseif math.abs(cur_pos.x - target_pos.x) < 15 then
                    table.insert(self.m_tMoveEndList, monster:getBattleId())

                    monster:getAnimation():play(monster:getAnimationName("standby"), true)
                    monster:setActFinished(true)
                end
            end
        end
    end

    --WZLog("ExpCopyData:monsterListMove three", self.m_nTotalMove, #self.m_tMoveEndList)
    if self.m_nTotalMove == #self.m_tMoveEndList then
        self.m_bIsMoveEnd = true

        return true
    end

    return false
end

--@brief    屏幕跟踪小怪
function ExpCopyData:followMonsterListMove(monster)
    if monster:isDead() then
        return
    end
    BattleScreen:followHero(monster:getMover():getMoverPosition())
    WZLog("BattleScreen:followHero 7")
end

--@brief    小怪准备攻击
function ExpCopyData:readyMonsterListMeleeAttack()
    WZLog("ExpCopyData:readyMonsterListMeleeAttack")

    for id, monster in pairs (self.m_tMonsterList) do
        if not monster:isDead() then
            local charas,values = self:checkMeleeHurt(monster)
            --WZLog("ExpCopyData:readyMonsterListMeleeAttack two", monster:getBattleId())
            if BattleCommon:tableLen(charas) > 0 then
                monster:adjustDirect(WBattleGlobal:getCurrent():getMyHero():getPosition())
                --WZLog("ExpCopyData:readyMonsterListMeleeAttack three", monster:getBattleId())
                monster:getAnimation():play(monster:getAnimationName("beat"), false)
            end
        else
            self.m_nDeadCount = self.m_nDeadCount + 1
        end
    end

    self.m_tAttackEndList = {}
end

--@brief    小怪攻击
function ExpCopyData:monsterListMeleeAttack()
    WZLog("ExpCopyData:monsterListMeleeAttack")

    for id, monster in pairs (self.m_tMonsterList) do
        if not monster:isDead() then
            local isAttackEnd = false
            for index, monsterAttackEndId in pairs (self.m_tAttackEndList) do
                if monster:getBattleId() == monsterAttackEndId then
                    isAttackEnd = true
                end
            end

            if isAttackEnd == false then
                local hero = monster
                local charas,values,distance,critTypes,hurtRatios = self:checkMeleeHurt(monster)
                local actionEnd = hero:getAnimation():isPlaying(hero:getAnimationName("standby")) or hero:getAnimation():isCurrentAnimationDone()
                if actionEnd  and BattleCommon:tableLen(charas) > 0 then
                    charas = self:charaAddHurtValue(charas,values,hurtRatios)

                    table.insert(self.m_tAttackEndList, monster:getBattleId())
                elseif BattleCommon:tableLen(charas) > 0 then
                    table.insert(self.m_tAttackEndList, monster:getBattleId())
                end
            end
        end
    end
    --WZLog("ExpCopyData:monsterListMeleeAttack III",#self.m_tMonsterList,#self.m_tAttackEndList,self.m_nDeadCount)
    if #self.m_tMonsterList - self.m_nDeadCount == #self.m_tAttackEndList then
        return true
    end

    return false
end

--@brief    检查近攻伤害
--@return   #1:受伤的人物列表
--@return   #2:受伤值
function ExpCopyData:checkMeleeHurt(monster)
    WZLog("ExpCopyData:checkMeleeHurt one")
    return BattleMethod:checkMeleeHurt(monster)
    -- local guai = monster
    -- local tHurtCharas = {}
    -- local tHurtValues = {}
    -- for i,charaList in pairs(guai.m_tCollisionCharacters) do
    --     for id,chara in pairs(charaList) do
    --         local guaiPos = guai:getMover():getMoverPosition()
    --         guaiPos = {x=guaiPos:getX(),y=guaiPos:getY()}
            
    --         local charaPos = chara:getCenterPos()
    --         charaPos = Vector2:create(charaPos.x,charaPos.y)
            
    --         local nCheckCharacterCollisionRadius = self.m_nAttackDistance

    --         WZLog("ExpCopyData:checkMeleeHurt two", nCheckCharacterCollisionRadius, tostring(BattleCommon:checkCircleCollosion(guaiPos,nCheckCharacterCollisionRadius * 1,charaPos,chara:getRadiusForHurt())))
    --         if not chara:isDead() and BattleCommon:checkCircleCollosion(guaiPos,nCheckCharacterCollisionRadius * 1,charaPos,chara:getRadiusForHurt()) == true then
    --             local hurtValue = self:getMeleeHurt(chara, monster)
    --             tHurtCharas[id] = chara
    --             tHurtValues[id] = hurtValue
    --         end
    --     end
    -- end
    -- return tHurtCharas,tHurtValues
end

--@brief    计算近攻伤害
--@return   #1：伤害
function ExpCopyData:getMeleeHurt(chara, monster)
    local guai = monster
    local guaiPos = guai:getMover():getMoverPosition()
    local charaPos = chara:getCenterPos()
    
    local hurt = 0
    if chara:getIsInvincible() > 0 then
        hurt = 1
    else
        hurt,recordRatio = BattleMethod:getMeleeHurt(chara, monster)
    end

    WZLog("ExpCopyData:getMeleeHurt", tostring(chara.m_nBuffInvincibleRound), hurt)
    return hurt,recordRatio
end

--@brief    对英雄添加受伤数字
--@param    charas:英雄列表
--@param    hurtValue:受伤数字
function ExpCopyData:charaAddHurtValue(charas,hurtValue,hurtRatios)
    WZLog("ExpCopyData:charaAddHurtValue one")
    return BattleMethod:charaAddHurtValue(self.m_tOwner,charas,hurtValue,hurtRatios)
    --[[
    local newCharas = {}
    local newValue = {}
    local shootHero = self.m_nBoss
    for id,chara in pairs(charas) do
        WZLog("ExpCopyData:charaAddHurtValue", tostring(id), tostring(chara.m_animPlayerShield), tostring(hurtValue[id]))
        chara:markHurt(hurtValue[id],shootHero)
        if hurtValue[id] > 0 then
            newCharas[id] = chara
            newValue[id] = hurtValue[id]
        end
    end

    WZLog("ExpCopyData:charaAddHurtValue", Serialize(newValue))
    return newCharas,newValue
    ]]
end

--@brief 新回合开始
function ExpCopyData:updateByTurn()
    --WZLog("ExpCopyData:updateByTurn",WBattleGlobal:getCurrent():getTurnTimes())
    if not WBattleGlobal:getCurrent():isMyTurn() then
        self.m_nRoundNum = self.m_nRoundNum + 1
    end
    if self:checkIsEnd() ~= 0 then
        self:copyEnd()
        return
    end
--[[
    if not WBattleGlobal:getCurrent():isMyTurn() then
        local list = WBattleGlobal:getCurrent():getGuaiList()
        for key,guai in pairs(list) do
            if guai.m_tBoss ~= nil then
                guai:setPF(guai:getMaxPF())
                local pos = guai:getPosition()
                guai:moveToPos(GlobalMethod:ccp(pos.x - 200,0))
            end
        end
    end
    ]]
end

--@brief 结束条件判断
--@return 1 胜利 2 失败
function ExpCopyData:checkIsEnd()
    if WBattleGlobal:getCurrent():checkIsHeroDead() then
        return 2
    end
    if self.m_nLostCount >= self.m_tMapInfo.parameter6 then
        return 2
    end

    local monsterAttEnd = false
    if WBattleGlobal:getCurrent():isMyTurn() then
        --玩家回合
        if self.m_nRoundNum >= self.m_nMaxRound then
            monsterAttEnd = true
        end
    else
        --怪物回合（最后一次出手回合 不能结算）
        if self.m_nRoundNum > self.m_nMaxRound then
            monsterAttEnd = true
        end
    end

    if monsterAttEnd then
        local list = WBattleGlobal:getCurrent():getGuaiList()
        for key,guai in pairs(list) do
            if guai.m_tBoss ~= nil  and not guai:isDead() then
                return 0
            end
        end
        return 1
    end
    return 0
end

--@brief 副本结束处理
function ExpCopyData:copyEnd()
    --已经处理过
    if self.m_bIsEnd then
        return
    end
    WBattleGlobal:getCurrent():setGameOver(true)
    -- MsgManager:clear()
    
    local lostCount = self.m_nSummonCount - self.m_killNum - self.m_killEliteNum - self.m_killBossNum
    -- body
    local isWin = self:checkIsEnd() == 1 and true or false
    table.insert(self.m_fightData.fightData,self.m_killNum)
    table.insert(self.m_fightData.fightData,self.m_killEliteNum)
    table.insert(self.m_fightData.fightData,self.m_killBossNum)
    table.insert(self.m_fightData.fightData,self.m_nLostCount)
    table.insert(self.m_fightData.fightData,self.m_nSummonCount)
    self.m_fightData.isWin = isWin
    -- WZLog("ExpCopyData:copyEnd",Serialize(self.m_fightData))
    -- WndDailyCopySettlement:showWindow(self.m_fightData)
    
    BaseCopyData.copyEnd(self)

    WBattleGlobal:getCurrent():setGameOver(true)
    local msg = MsgManager:createMsg(BattleMsgGameOver)
    msg.m_bWin = isWin
    msg.m_tSettlementData = self.m_fightData
    msg.m_bWin = isWin
    MsgManager:pushNonBlockMsg(msg)
end

-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块End----------------------------------------

--@brief 监听事件
function ExpCopyData:_initEvent()
    WZLog("ExpCopyData:_initEvent")
    GlobalGame:getBattleEventDispatcher():Add(BATTLE_EVENT_TYPE.MONSTER_CREATE, self._monsterCreateHandler,self)
    GlobalGame:getBattleEventDispatcher():Add(BATTLE_EVENT_TYPE.MONSTER_SUICIDE, self._monsterSuicideHandler,self)
end
--@brief 移除事件
function ExpCopyData:_removeEvent()
    WZLog("ExpCopyData:_removeEvent")
    GlobalGame:getBattleEventDispatcher():Remove(BATTLE_EVENT_TYPE.MONSTER_CREATE,self._monsterCreateHandler,self)
    GlobalGame:getBattleEventDispatcher():Remove(BATTLE_EVENT_TYPE.MONSTER_SUICIDE,self._monsterSuicideHandler,self)
end

--@brief 创建怪物回调
function ExpCopyData:_monsterCreateHandler()
  self.m_nSummonCount = self.m_nSummonCount + 1
end

--@brief 怪物自杀回调
function ExpCopyData:_monsterSuicideHandler()
  self.m_nLostCount = self.m_nLostCount + 1
  self.m_loseNumLab:setText(tostring(self.m_nLostCount).."/"..tostring(self.m_tMapInfo.parameter6))
end
