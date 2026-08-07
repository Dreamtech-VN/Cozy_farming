--BattleMsgSkillEffect.lua
--@brief    技能表演效果
--@date     2015/08/01


--@brief    技能表演效果
BattleMsgSkillEffect = {
    m_sName = "BattleMsgSkillEffect",
     --外部赋值变量
    m_nEffectId = nil,         --效果id
    m_tTargetList = nil,       --技能目标
    m_tOwner = nil,            --使用者
    --内部控制变量
    m_tEffectTargetList = nil,     --效果配置
    m_tStepFunction = nil,         --处理步骤

}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgSkillEffect:init()
    WZLog("BattleMsgSkillEffect:init",self.m_nEffectId)
     --处理步骤
    self.m_tStepFunction = {}

    self:_getEffectConfig()
    self:_doSkillEffect()
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgSkillEffect:process()
    --重连成功，而且正在等待怪物id
    if self.m_bIsWaitMonsterId and self.m_bIsReconnectDone then
        return true
    end
    
    if #self.m_tStepFunction > 0 then
        local res = self.m_tStepFunction[1][1](self,self.m_tStepFunction[1][2],self.m_tStepFunction[1][3],self.m_tStepFunction[1][4])
        if res == true or res == nil then
            table.remove(self.m_tStepFunction,1)
        end
        return false
    end
    
    return true
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgSkillEffect:done()
    WZLog("BattleMsgSkillEffect:done")
    if self.m_tEffectDoneCB then
        self.m_tEffectDoneCB(self.m_nEffectCountIndex)
    end
end

--@brief    添加步骤
--@note     添加处理步骤
function BattleMsgSkillEffect:addStep(skillType, param, isBuff)
    WZLog("BattleMsgSkillEffect:addStep", skillType)
   if skillType == EffectTypeConfig.HURT or skillType == EffectTypeConfig.RECOVERY then
        if #param > 0 then
            table.insert(self.m_tStepFunction,{self._waitForSkillHurt,param})
        end
    elseif skillType == EffectTypeConfig.INVINCIBLE then
        --table.insert(self.m_tStepFunction,{self._Invincible,param})
        self:_Invincible(param)
    elseif skillType == EffectTypeConfig.CHANGE_HURT_VALUE or skillType == EffectTypeConfig.CHANGE_HURT_PERCENT or skillType == EffectTypeConfig.CHANGE_HURT_ADD_VALUE or skillType == EffectTypeConfig.CHANGE_HURT_MUL_PERCENT then
        --table.insert(self.m_tStepFunction,{self._ChangeHurt,param,skillType,isBuff})
        self:_ChangeHurt(param,skillType,isBuff)
    elseif skillType == EffectTypeConfig.CHANGE_BEHURT_VALUE or skillType == EffectTypeConfig.CHANGE_BEHURT_PERCENT or skillType == EffectTypeConfig.CHANGE_BEHURT_ADD_VALUE then
        --table.insert(self.m_tStepFunction,{self._ChangeBeHurt,param,skillType,isBuff})
        self:_ChangeBeHurt(param,skillType,isBuff)
    elseif skillType == EffectTypeConfig.CHANGE_CRIT_HURT_PERCENT or skillType == EffectTypeConfig.CHANGE_CRIT_HURT_ADD_VALUE then
        table.insert(self.m_tStepFunction,{self._ChangeCritHurt,param,skillType,isBuff})
    elseif skillType == EffectTypeConfig.CHANGE_BECRIT_HURT_PERCENT or skillType == EffectTypeConfig.CHANGE_BECRIT_HURT_ADD_VALUE then
        table.insert(self.m_tStepFunction,{self._ChangeBeCritHurt,param,skillType,isBuff})
    elseif skillType == EffectTypeConfig.CHANGE_RECOVERY_PERCENT then
        table.insert(self.m_tStepFunction,{self._ChangeRecovery,param,skillType,isBuff})
    elseif skillType == EffectTypeConfig.NO_HOLE then
        table.insert(self.m_tStepFunction,{self._NoHole,param,skillType,isBuff})
    elseif skillType == EffectTypeConfig.DEAD then
        table.insert(self.m_tStepFunction,{self._Dead,param})
    elseif skillType == EffectTypeConfig.TRANSFER then
        table.insert(self.m_tStepFunction,{self._Transer,param})
        table.insert(self.m_tStepFunction,{self._cameraFollowHero,param})
    elseif false and skillType == EffectTypeConfig.TRANSFER_MOVE then
        table.insert(self.m_tStepFunction,{self._TranserMove,param})
    elseif skillType == EffectTypeConfig.CHANGE_ATTRIBUTE_VALUE or skillType == EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT or skillType == EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT_HURT then
        table.insert(self.m_tStepFunction,{self._changeAttribute,param,skillType,isBuff})
    elseif skillType == EffectTypeConfig.TRANSFER_RANDOM_BORN then
        table.insert(self.m_tStepFunction,{self._transerRandomBorn,param})
    elseif skillType == EffectTypeConfig.LIMIT_ALL_ACTION then
        table.insert(self.m_tStepFunction,{self._frozen,param,isBuff})
    elseif skillType == EffectTypeConfig.REPEL_FLY or skillType == EffectTypeConfig.REPEL_FLY_BOSS then
        table.insert(self.m_tStepFunction,{self._repelFly,param,skillType})
    elseif skillType == EffectTypeConfig.HIDE then
        table.insert(self.m_tStepFunction,{self._hide,param,isBuff})
    elseif skillType == EffectTypeConfig.ADD_BUFF then
        table.insert(self.m_tStepFunction,{self._addBuff,param})
    elseif skillType == EffectTypeConfig.CANCEL_BUFF_ALL then
        table.insert(self.m_tStepFunction,{self._canelBuff,param})
    elseif skillType == EffectTypeConfig.CANCEL_BUFF_TYPE then
        table.insert(self.m_tStepFunction,{self._canelBuff,param})
    elseif skillType == EffectTypeConfig.CANCEL_BUFF_ID then
        table.insert(self.m_tStepFunction,{self._canelBuff,param})
    elseif skillType == EffectTypeConfig.SCATTER_SHOOT then
        table.insert(self.m_tStepFunction,{self._changeScatter,param})
    elseif skillType == EffectTypeConfig.TIMES_SHOOT then
        table.insert(self.m_tStepFunction,{self._changeAtkTimes,param})
    elseif skillType == EffectTypeConfig.TORNADO then
        if self.m_tTornadoInfo then
            --防止重连消息清理标记
            self.m_bIsSummonMsg = true
            self.m_tSkillShowMsg.m_bIsSummonMsg = true
            table.insert(self.m_tStepFunction,{self._waitMonsterId})
            table.insert(self.m_tStepFunction,{self._buildTornado})
        end
    elseif skillType == EffectTypeConfig.SPATTER then
        table.insert(self.m_tStepFunction,{self._spatter})
    elseif skillType == EffectTypeConfig.SUMMON then
        --防止重连消息清理标记
        self.m_bIsSummonMsg = true
        self.m_tSkillShowMsg.m_bIsSummonMsg = true
        table.insert(self.m_tStepFunction,{self._waitMonsterId})
        table.insert(self.m_tStepFunction,{self._summonMonster})
    elseif skillType == EffectTypeConfig.BOSS_LIGHT then
        table.insert(self.m_tStepFunction,{self._waitMonsterId})
        table.insert(self.m_tStepFunction,{self._buildBossLight})
    elseif skillType == EffectTypeConfig.BOSS_GIFT then
        table.insert(self.m_tStepFunction,{self._waitMonsterId})
        table.insert(self.m_tStepFunction,{self._buildBossGift})
    elseif skillType == EffectTypeConfig.TRANSFER_POSITION then
        table.insert(self.m_tStepFunction,{self._transferPositionStart,param})
        table.insert(self.m_tStepFunction,{self._waitForTransEffect})
        table.insert(self.m_tStepFunction,{self._transferPosition})
    end

end

-------------------------------------私有方法模块--------------------------------------

--@brief    获取技能效果表配置 
function BattleMsgSkillEffect:_getEffectData(id)
    return CopyTable(EffectConfig["id_"..id])
end

--@brief    获取效果配置
function BattleMsgSkillEffect:_getEffectConfig()
    WZLog("BattleMsgSkillEffect:_getSkillConfig", self.m_nSkillId,self.m_nEffectId)
    
    if self.m_nEffectId == -1 then
        self.m_tSkillEffectParm = {{0,4,-1,1}}
    else
        self.m_tSkillEffectParm = self:_getEffectData(self.m_nEffectId).effect
    end
end

--@brief    添加技能效果
function BattleMsgSkillEffect:_doSkillEffect()
    --WZLog("BattleMsgSkillEffect:_doSkillEffect",skillParm)
    local effect = self.m_tSkillEffectParm
    for i, skillParm in pairs (effect) do
        self:_doSkillEffectParser(skillParm,i)
    end
    return true
end

--@brief 技能效果解析
function BattleMsgSkillEffect:_doSkillEffectParser(skillParm,i,isMoment)
    i = i or 1
    local boss = self.m_tOwner
    while skillParm do
        local effectParm = skillParm--skillParm[1]
        local takeEffectParm = effectParm[1]
        --WZLog("BattleMsgSkillEffect:_doSkillEffectParser",i, boss:getId(), tostring(boss.m_nUseSkillState), tostring(takeEffectParm), Serialize(skillParm))
        
        local turnTime = WBattleGlobal:getCurrent().m_nTurnTimes
        local effect = effectParm[3] .. "_" ..effectParm[4]
        local targetParm = effectParm[2]

        effectParm.isTakeEffect = turnTime
        targetHeroList = self:_chooseEffectTarget(targetParm)
    
    
        local isEndEffect = self:_doEffectType(effectParm,targetHeroList,nil)
        if isEndEffect == "return" then
            return
        elseif isEndEffect == "break" then
            break
        end

        self:_doSkillEffectEnd(effect, targetHeroList)
            
        break
    end
end

--@brief    选择效果预先处理
function BattleMsgSkillEffect:_doEffectType(effectParm,targetHeroList,isBuff)
    WZLog("BattleMsgSkillEffect:_doEffectType", Serialize(effectParm))
    local isEndEffect = nil
    local boss = self.m_tOwner
    local effect = effectParm[3] .. "_" ..effectParm[4]
    if effect == EffectTypeConfig.CHANGE_ATTRIBUTE_VALUE then
        WZLog("BattleMsgSkillEffect:_doEffect seven-1", i)
        self.m_nChangeValueIndex = effectParm[5]
        self.m_nChangeValue = effectParm[6]
    elseif effect == EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT_HURT then
        WZLog("BattleMsgBossMapSkill:_doEffect seven-32", i)
        self.m_nChangeHurtPercentIndex = effectParm[5]
        self.m_nChangeHurtPercent = effectParm[6]
    elseif effect == EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT then
        WZLog("BattleMsgSkillEffect:_doEffect seven-2", i)
        self.m_nChangePercentIndex = effectParm[5]
        self.m_nChangePercent = effectParm[6]
    elseif effect == EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT_ATTACK then
        WZLog("BattleMsgBossMapSkill:_doEffect seven-2", i)
        self.m_nChangePercentIndexAttack = effectParm[5]
        self.m_nChangePercentAttack = effectParm[6]
    elseif effect == EffectTypeConfig.CHANGE_HURT_VALUE then
        WZLog("BattleMsgSkillEffect:_doEffect seven-5", i)
        self.m_nHurtChangeValue = effectParm[5]
    elseif effect == EffectTypeConfig.CHANGE_HURT_PERCENT then
        WZLog("BattleMsgSkillEffect:_doEffect seven-6", i)
        self.m_nHurtAddPercent = effectParm[5]
    elseif effect == EffectTypeConfig.CHANGE_HURT_ADD_VALUE then
        WZLog("BattleMsgSkillEffect:_doEffect seven-7", i)
        self.m_nHurtAddValue = effectParm[5]
    elseif effect == EffectTypeConfig.CHANGE_BEHURT_VALUE then
        WZLog("BattleMsgSkillEffect:_doEffect seven-8", i)
        self.m_nBeHurtChangeValue = effectParm[5]
    elseif effect == EffectTypeConfig.CHANGE_BEHURT_PERCENT then
        WZLog("BattleMsgSkillEffect:_doEffect seven-9", i)
        self.m_nBeHurtAddPercent = effectParm[5]
    elseif effect == EffectTypeConfig.CHANGE_BEHURT_ADD_VALUE then
        WZLog("BattleMsgSkillEffect:_doEffect seven-10", i)
        self.m_nBeHurtAddValue = effectParm[5]
    elseif effect == EffectTypeConfig.CHANGE_CRIT_HURT_PERCENT then
        WZLog("BattleMsgBossMapSkill:_doEffect seven-64", i)
        self.m_nCritHurtAddPercent = effectParm[5]
    elseif effect == EffectTypeConfig.CHANGE_BECRIT_HURT_PERCENT then
        WZLog("BattleMsgBossMapSkill:_doEffect seven-65", i)
        self.m_nBeCritHurtAddPercent = effectParm[5]
        elseif effect == EffectTypeConfig.CHANGE_CRIT_HURT_ADD_VALUE then
        WZLog("BattleMsgBossMapSkill:_doEffect seven-66", i)
        self.m_nCritHurtAddValue = effectParm[5]
    elseif effect == EffectTypeConfig.CHANGE_BECRIT_HURT_ADD_VALUE then
        WZLog("BattleMsgBossMapSkill:_doEffect seven-67", i)
        self.m_nBeCritHurtAddValue = effectParm[5]
    elseif effect == EffectTypeConfig.CHANGE_RECOVERY_PERCENT then
        WZLog("BattleMsgBossMapSkill:_doEffect seven-68", i)
        self.m_nRecoveryAddPercent = effectParm[5]
    elseif effect == EffectTypeConfig.NO_HOLE then
        WZLog("BattleMsgBossMapSkill:_doEffect seven-69", i)
        self.m_nNoHole = effectParm[5]
    elseif effect == EffectTypeConfig.CHANGE_HURT_MUL_PERCENT then
        WZLog("BattleMsgBossMapSkill:_doEffect seven-70", i)
        self.m_nHurtMulPercent = effectParm[5] / 100
    elseif effect == EffectTypeConfig.HIDE then
        WZLog("BattleMsgSkillEffect:_doEffect seven-11", i)
        self.m_nHideTurn = effectParm[5]
    elseif effect == EffectTypeConfig.LIMIT_ALL_ACTION then
        WZLog("BattleMsgSkillEffect:_doEffect seven-12", i)
        if boss.m_nUseSkillState == TakeEffectType.HIT then
            self.m_nDebuffFrozenRound = effectParm[5]
        end
    elseif effect == EffectTypeConfig.REPEL_FLY or effect == EffectTypeConfig.REPEL_FLY_BOSS then
        WZLog("BattleMsgSkillEffect:_doEffect seven-13", i)
        self.m_nRepelFlyX = effectParm[5]
        self.m_nRepelFlyY = effectParm[6]
    elseif effect == EffectTypeConfig.TRANSFER_MOVE then
        self.m_nTransferMoveDistance = effectParm[5]
    elseif effect == EffectTypeConfig.ADD_BUFF then
        WZLog("BattleMsgSkillEffect:_doEffect seven-14", i)
        self.m_nAddBuffId = effectParm[5]
    elseif effect == EffectTypeConfig.CANCEL_BUFF_ALL then
        WZLog("BattleMsgSkillEffect:_doEffect seven-14-1", i)
    elseif effect == EffectTypeConfig.CANCEL_BUFF_TYPE then
        WZLog("BattleMsgSkillEffect:_doEffect seven-14-2", i)
        self.m_nCancelBuffType = effectParm[5]
    elseif effect == EffectTypeConfig.CANCEL_BUFF_ID then
        WZLog("BattleMsgSkillEffect:_doEffect seven-14-3", i)
        self.m_nCancelBuffId = effectParm[5]
    elseif effect == EffectTypeConfig.HURT then
        WZLog("BattleMsgSkillEffect:_doSkillEffect four-1", i)
        self.m_nHurtType = effectParm[5] or HurtTypeConfig.CALCULATE
        self.m_nHurtIndex = effectParm[6]
    elseif effect == EffectTypeConfig.RECOVERY then
        WZLog("BattleMsgSkillEffect:_doSkillEffect four-2", i)
        self.m_nHurtType = effectParm[5] or HurtTypeConfig.CALCULATE_RESTORE
        self.m_nHurtIndex = effectParm[6]
    elseif effect == EffectTypeConfig.INVINCIBLE then
        WZLog("BattleMsgSkillEffect:_doSkillEffect six", i)
    elseif effect == EffectTypeConfig.TRANSFER then
        self.m_tTransferPos = {}
        for i = 1 , (#effectParm - 4) / 2 do
            table.insert(self.m_tTransferPos, BattleCommon:getPointTable(effectParm[5+(i-1)*2],effectParm[6+(i-1)*2]))
        end
    elseif effect == EffectTypeConfig.DEAD then
        self:addStep(effect, targetHeroList)
        isEndEffect = "return"
    elseif effect == EffectTypeConfig.TORNADO then
        if targetHeroList and #targetHeroList > 0 and targetHeroList[1].m_tActiveAttackPos[1] then
            -- WZLog("BattleMsgSkillEffect:_doEffect nine-2", targetHeroList[1]:getBattleId(), targetHeroList[1]:getCamp(), targetHeroList[1].m_tActiveAttackPos[1].x,targetHeroList[1].m_tActiveAttackPos[1].y)
            -- self.m_tTornadoInfo = {charaId=targetHeroList[1]:getBattleId(), camp=targetHeroList[1]:getCamp(), pos=CopyTable(targetHeroList[1].m_tActiveAttackPos[1])}
            self.m_tTornadoInfo = {battleId = self.m_tOwner:getBattleId() + 1000,templateId = effectParm[6], camp=targetHeroList[1]:getCamp(), bronPos=CopyTable(targetHeroList[1].m_tActiveAttackPos[1])}
            self.m_tSummonMonsterId = {}
            self.m_tSummonMonsterBattleId = {}
            self.m_tOwner.m_tCursummonList = {}
            local count = effectParm[5]
            for i = 1,count,1 do
                local index = 5 + i
                local posIndex = 6 + count + (i - 1)*2
                local templateId = effectParm[index]
                WZLog("BattleMsgSkillEffect:_doEffect summon",index,posIndex)
                table.insert(self.m_tSummonMonsterId,templateId)
            end
        end
    elseif effect == EffectTypeConfig.SPATTER then
        if targetHeroList and #targetHeroList > 0 and targetHeroList[1].m_tActiveAttackPos[1] then
            WZLog("BattleMsgSkillEffect:_doEffect nine-3")
            self.m_tSpatterInfo = {pos=CopyTable(targetHeroList[1].m_tActiveAttackPos[1]),speed=CopyTable(targetHeroList[1].m_tActiveAttackSpeed[1]),count=effectParm[5],hurtSkillId=effectParm[6]}
        end
    elseif effect == EffectTypeConfig.SUMMON or effect == EffectTypeConfig.BOSS_LIGHT or effect == EffectTypeConfig.BOSS_GIFT then
        self.m_tSummonMonsterId = {}
        self.m_tSummonMonsterPositionX = {}
        self.m_tSummonMonsterPositionY = {}
        self.m_tSummonMonsterBattleId = {}
        self.m_tOwner.m_tCursummonList = {}
        local count = effectParm[5]
        for i = 1,count,1 do
            local index = 5 + i
            local posIndex = 6 + count + (i - 1)*2
            local templateId = effectParm[index]
            local posX = effectParm[posIndex] or -25
            local posY = effectParm[posIndex + 1] or 500
            WZLog("BattleMsgSkillEffect:_doEffect summon",index,posIndex,posX,posY)
            table.insert(self.m_tSummonMonsterId,templateId)
            table.insert(self.m_tSummonMonsterPositionX,posX)
            table.insert(self.m_tSummonMonsterPositionY,posY)
        end
    elseif effectParm[3] == EffectTypeConfig.HURT_OFF_TARGET then
        for i,v in pairs(targetHeroList) do
            v.m_nHurtOffState = effectParm[4]
        end
     elseif effect == EffectTypeConfig.TRACK_SHOOT then
         WZLog("BattleMsgSkillEffect:_doEffect follow")
        self.m_tOwner:setCanFollow(true)
    end
    return isEndEffect
end

--@brief 技能效果解析结束
function BattleMsgSkillEffect:_doSkillEffectEnd(effectType,parms)
    WZLog("BattleMsgSkillEffect:_doSkillEffectEnd",effectType,#parms)
    self:addStep(effectType, parms)
end

--@brief    选择目标
--@param 触发类型 
function BattleMsgSkillEffect:_chooseEffectTarget(effectParm)
    local chooseTargetType = effectParm
    self.m_tEffectTargetList = {}
    if chooseTargetType == EffectTargetType.HIT_ROLE then
        self.m_tEffectTargetList = self.m_tOwner.m_tHitTargets or {}
    elseif chooseTargetType == EffectTargetType.MYSELF then
        table.insert(self.m_tEffectTargetList, self.m_tOwner)
    elseif chooseTargetType== EffectTargetType.MYTEAM then
        self.m_tEffectTargetList = self.m_tOwner:getMyTeam()
    elseif chooseTargetType == EffectTargetType.ENEMY then
        self.m_tEffectTargetList = self.m_tOwner:getMyEnemy()
    elseif chooseTargetType == EffectTargetType.SKLL_TO then
        return self.m_tTargetList or {}
    end
    WZLog("BattleMsgSkillEffect:_chooseEffectTarget",effectParm,#self.m_tEffectTargetList)
    return self.m_tEffectTargetList
end

--@brief    等待技能受伤
function BattleMsgSkillEffect:_waitForSkillHurt(targetHeroList)
    WZLog("BattleMsgSkillEffect:_waitForSkillHurt")
    BattleMethod:waitForSkillHurt(self.m_tOwner,targetHeroList)
    -- local hero = self.m_tOwner
    -- self.m_tOwner.m_bActiveAttack = true

    -- if self.m_tOwner.m_tHitTargets == nil then
    --     self.m_tOwner.m_tHitTargets = {}
    -- end
    -- for i,v in pairs(targetHeroList) do
    --     local isExist = false
    --     for j, u in pairs (self.m_tOwner.m_tHitTargets) do
    --         if v:getBattleId() == u:getBattleId() then
    --             isExist = true
    --         end
    --     end
    --     if  isExist == false then
    --         table.insert(self.m_tOwner.m_tHitTargets, v)
    --         WZLog("BattleMsgSkillEffect:_waitForSkillHurt one", v:getBattleId())
    --     end
    -- end


    -- local hero = self.m_tOwner
    
    -- WZLog("BattleMsgSkillEffect:_updateBullet two-4.1")
    -- local charas,values = self:_checkSkillHurt(targetHeroList)
    -- charas = self:_charaAddHurtValue(charas,values)
    -- BattleMethod:sendHurtProtocol(hero,charas, values)
    return true
end

--@brief    检查技能伤害
function BattleMsgSkillEffect:_checkSkillHurt(targetHeroList)
    WZLog("BattleMsgSkillEffect:_checkSkillHurt")
   return BattleMethod:checkSkillHurt(self.m_tOwner,targetHeroList)
end

--@brief    对英雄添加受伤数字
--@param    charas:英雄列表
--@param    hurtValue:受伤数字
function BattleMsgSkillEffect:_charaAddHurtValue(charas,hurtValue,hurtRatios)
    WZLog("BattleMsgSkillEffect:_charaAddHurtValue one")
    return BattleMethod:charaAddHurtValue(self.m_tOwner,charas,hurtValue,hurtRatios)
end

--@brief    无敌
function BattleMsgSkillEffect:_Invincible(targetHeroList)
    WZLog("BattleMsgSkillEffect:_Invincible")
    for i, hero in pairs (targetHeroList) do
        WZLog("BattleMsgSkillEffect:_Invincible two", hero:getBattleId())
        hero.m_tAttributeChangeStateList.m_nBuffInvincibleRound = 1
    end
end

--@brief    改变伤害
function BattleMsgSkillEffect:_ChangeHurt(targetHeroList, skillType, isBuff)
    WZLog("BattleMsgSkillEffect:_ChangeHurt")
    if isBuff == nil then
        for i, hero in pairs (targetHeroList) do
            WZLog("BattleMsgSkillEffect:_ChangeHurt two", hero:getBattleId(), skillType, tostring(self.m_nHurtChangeValue), tostring(self.m_nHurtAddPercent), tostring(self.m_nHurtAddValue))
            hero.m_nBuffPowerUpRound = 2

            if skillType == EffectTypeConfig.CHANGE_HURT_VALUE then
                hero:changeAttrListValue("m_nHurtChangeValue", self.m_nHurtChangeValue)
                --hero.m_tAttributeChangeStateList.m_nHurtChangeValue = {timeType=self.m_nHurtChangeValueTimeType,timeValue=self.m_nHurtChangeValueTimeValue,value=self.m_nHurtChangeValue}
            elseif skillType == EffectTypeConfig.CHANGE_HURT_PERCENT then
                hero:changeAttrListValue("m_nHurtAddPercent", self.m_nHurtAddPercent)
                --hero.m_tAttributeChangeStateList.m_nHurtAddPercent = {timeType=self.m_nHurtAddPercentTimeType,timeValue=self.m_nHurtAddPercentTimeValue,value=self.m_nHurtAddPercent}
                --幻化伤害减免
                if self.m_tSkillConfig and self.m_tSkillConfig.skill_type == 4 then
                    hero:addImmunityPetSkill(self.m_nSkillId,{type = EffectTypeConfig.CHANGE_HURT_PERCENT,param = self.m_nHurtAddPercent})
                end
            elseif skillType == EffectTypeConfig.CHANGE_HURT_ADD_VALUE then
                hero:changeAttrListValue("m_nHurtAddValue", self.m_nHurtAddValue)
                --hero.m_tAttributeChangeStateList.m_nHurtAddValue = {timeType=self.m_nHurtAddValueTimeType,timeValue=self.m_nHurtAddValueTimeValue,value=self.m_nHurtAddValue}
                --幻化伤害减免
                if self.m_tSkillConfig and self.m_tSkillConfig.skill_type == 4 then
                    hero:addImmunityPetSkill(self.m_nSkillId,{type = EffectTypeConfig.CHANGE_HURT_ADD_VALUE,param = self.m_nHurtAddValue})
                end
            elseif skillType == EffectTypeConfig.CHANGE_HURT_MUL_PERCENT then
                hero:changeAttrListValue("m_nHurtMulPercent", self.m_nHurtMulPercent)
                --hero.m_tAttributeChangeStateList.m_nHurtMulPercent = {timeType=self.m_nHurtAddPercentTimeType,timeValue=self.m_nHurtAddPercentTimeValue,value=self.m_nHurtMulPercent}
                --幻化伤害减免
                if self.m_tSkillConfig and self.m_tSkillConfig.skill_type == 4 then
                    hero:addImmunityPetSkill(self.m_nSkillId,{type = EffectTypeConfig.CHANGE_HURT_PERCENT,param = self.m_nHurtAddPercent})
                end
            end
        end
    end
end

--@brief    改变被动伤害
function BattleMsgSkillEffect:_ChangeBeHurt(targetHeroList, skillType, isBuff)
    WZLog("BattleMsgSkillEffect:_ChangeBeHurt", tostring(isBuff))
    if isBuff == nil then
        for i, hero in pairs (targetHeroList) do
            WZLog("BattleMsgSkillEffect:_ChangeBeHurt two", hero:getBattleId(), skillType, tostring(self.m_nBeHurtChangeValue), tostring(self.m_nBeHurtAddPercent), tostring(self.m_nBeHurtAddValue))

            if skillType == EffectTypeConfig.CHANGE_BEHURT_VALUE then
                hero:changeAttrListValue("m_nBeHurtChangeValue", self.m_nBeHurtChangeValue)
                --hero.m_tAttributeChangeStateList.m_nBeHurtChangeValue = {timeType=self.m_nBeHurtChangeValueTimeType,timeValue=self.m_nBeHurtChangeValueTimeValue,value=self.m_nBeHurtChangeValue}
            elseif skillType == EffectTypeConfig.CHANGE_BEHURT_PERCENT then
                hero:changeAttrListValue("m_nBeHurtAddPercent", self.m_nBeHurtAddPercent)
                --hero.m_tAttributeChangeStateList.m_nBeHurtAddPercent = {timeType=self.m_nBeHurtAddPercentTimeType,timeValue=self.m_nBeHurtAddPercentTimeValue,value=self.m_nBeHurtAddPercent}
                --宠物伤害减免
                if self.m_tSkillConfig and self.m_tSkillConfig.skill_type == 4 then
                    hero:addImmunityPetSkill(self.m_nSkillId,{type = EffectTypeConfig.CHANGE_BEHURT_PERCENT,param = self.m_nBeHurtAddPercent})
                end
            elseif skillType == EffectTypeConfig.CHANGE_BEHURT_ADD_VALUE then
                hero:changeAttrListValue("m_nBeHurtAddValue", self.m_nBeHurtAddValue)
                --hero.m_tAttributeChangeStateList.m_nBeHurtAddValue = {timeType=self.m_nBeHurtAddValueTimeType,timeValue=self.m_nBeHurtAddValueTimeValue,value=self.m_nBeHurtAddValue}
            end
        end
    end
end

--@brief    改变暴击伤害
function BattleMsgSkillEffect:_ChangeCritHurt(targetHeroList, skillType, isBuff)
    WZLog("BattleMsgBossMapSkill:_ChangeCritHurt")
    if isBuff == nil then
        for i, hero in pairs (targetHeroList) do
            WZLog("BattleMsgBossMapSkill:_ChangeCritHurt two", hero:getBattleId(), skillType, tostring(self.m_nCritHurtAddPercent))
            if skillType == EffectTypeConfig.CHANGE_CRIT_HURT_PERCENT then
                hero:changeAttrListValue("m_nCritHurtAddPercent", self.m_nCritHurtAddPercent)
                --hero.m_tAttributeChangeStateList.m_nCritHurtAddPercent = {value=self.m_nCritHurtAddPercent}
                --幻化伤害减免
                if self.m_tSkillConfig and self.m_tSkillConfig.skill_type == 4 then
                    hero:addImmunityPetSkill(self.m_nSkillId,{type = EffectTypeConfig.CHANGE_CRIT_HURT_PERCENT,param = self.m_nCritHurtAddPercent})
                end
            elseif skillType == EffectTypeConfig.CHANGE_CRIT_HURT_ADD_VALUE then
                hero:changeAttrListValue("m_nCritHurtAddValue", self.m_nCritHurtAddValue)
                --hero.m_tAttributeChangeStateList.m_nCritHurtAddValue = {value=self.m_nCritHurtAddValue}
                --幻化伤害减免
                if self.m_tSkillConfig and self.m_tSkillConfig.skill_type == 4 then
                    hero:addImmunityPetSkill(self.m_nSkillId,{type = EffectTypeConfig.CHANGE_CRIT_HURT_ADD_VALUE,param = self.m_nCritHurtAddValue})
                end
            end
        end
    end
end

--@brief    改变被暴击伤害
function BattleMsgSkillEffect:_ChangeBeCritHurt(targetHeroList, skillType, isBuff)
    WZLog("BattleMsgBossMapSkill:_ChangeCritHurt")
    if isBuff == nil then
        for i, hero in pairs (targetHeroList) do
            WZLog("BattleMsgBossMapSkill:_ChangeBeCritHurt two", hero:getBattleId(), skillType, tostring(self.m_nBeCritHurtAddPercent))
            if skillType == EffectTypeConfig.CHANGE_BECRIT_HURT_PERCENT then
                hero:changeAttrListValue("m_nBeCritHurtAddPercent", self.m_nBeCritHurtAddPercent)
                --hero.m_tAttributeChangeStateList.m_nBeCritHurtAddPercent = {value=self.m_nBeCritHurtAddPercent}
                --幻化伤害减免
                if self.m_tSkillConfig and self.m_tSkillConfig.skill_type == 4 then
                    hero:addImmunityPetSkill(self.m_nSkillId,{type = EffectTypeConfig.CHANGE_BECRIT_HURT_PERCENT,param = self.m_nBeCritHurtAddPercent})
                end
            elseif skillType == EffectTypeConfig.CHANGE_BECRIT_HURT_ADD_VALUE then
                hero:changeAttrListValue("m_nBeCritHurtAddValue", self.m_nBeCritHurtAddValue)
                --hero.m_tAttributeChangeStateList.m_nBeCritHurtAddValue = {value=self.m_nBeCritHurtAddValue}
                --幻化伤害减免
                if self.m_tSkillConfig and self.m_tSkillConfig.skill_type == 4 then
                    hero:addImmunityPetSkill(self.m_nSkillId,{type = EffectTypeConfig.CHANGE_BECRIT_HURT_ADD_VALUE,param = self.m_nBeCritHurtAddValue})
                end
            end
        end
    end
end

--@brief    改变回血加成
function BattleMsgSkillEffect:_ChangeRecovery(targetHeroList, skillType, isBuff)
    WZLog("BattleMsgBossMapSkill:_ChangeRecovery")
    if isBuff == nil then
        for i, hero in pairs (targetHeroList) do
            WZLog("BattleMsgBossMapSkill:_ChangeRecovery two", hero:getBattleId(), skillType, tostring(self.m_nRecoveryAddPercent))
            if skillType == EffectTypeConfig.CHANGE_RECOVERY_PERCENT then
                hero:changeAttrListValue("m_nRecoveryAddPercent", self.m_nRecoveryAddPercent)
                --hero.m_tAttributeChangeStateList.m_nRecoveryAddPercent = {value=self.m_nRecoveryAddPercent}
                --幻化伤害减免
                if self.m_tSkillConfig and self.m_tSkillConfig.skill_type == 4 then
                    hero:addImmunityPetSkill(self.m_nSkillId,{type = EffectTypeConfig.CHANGE_RECOVERY_PERCENT,param = self.m_nRecoveryAddPercent})
                end
            end
        end
    end
end

--@brief    免坑
function BattleMsgSkillEffect:_NoHole(targetHeroList, skillType, isBuff)
    WZLog("BattleMsgBossMapSkill:_NoHole")
    if isBuff == nil then
        WZLog("BattleMsgBossMapSkill:_NoHole two", hero:getBattleId(), skillType, tostring(self.m_nNoHole))
    end
end

--@brief    死亡
function BattleMsgSkillEffect:_Dead(targetHeroList)
    WZLog("BattleMsgSkillEffect:_Dead")
    for i, hero in pairs (targetHeroList) do
        WZLog("BattleMsgSkillEffect:_Dead two", hero:getBattleId())

        hero:setDead(true,13)
    end
end

--@brief    传送
function BattleMsgSkillEffect:_Transer(targetHeroList)
    WZLog("BattleMsgSkillEffect:_Transer")
     local heroList = {}
    for i,hero in pairs(targetHeroList) do
        if not hero.m_bOffRepulse then
            table.insert(heroList,hero)
        end
    end
    targetHeroList = heroList
    
    if self.m_bIsTranser == nil then 
        self.m_bIsTranser = true
        self.m_nShootDeltaTime = 0

        local randList = WBattleGlobal:getCurrent().m_tBattleRand

        for i, hero in pairs (targetHeroList) do
            
            local randIndex = (WBattleGlobal:getCurrent():getTurnTimes() + hero:getBattleId()) % 10 + 1
            local randValue = randList[randIndex] % #self.m_tTransferPos + 1
            WZLog("BattleMsgSkillEffect:_Transer two", hero:getBattleId(),#self.m_tTransferPos, randIndex, randValue)
            hero:setPosition(Vector2:create(self.m_tTransferPos[randValue].x,self.m_tTransferPos[randValue].y))
            if not hero.m_bIsAir then 
                hero:setMoveUpdatable(true)
            end
        end
    -- else
    --     local hero = targetHeroList[1]
    --     self.m_nShootDeltaTime = self.m_nShootDeltaTime + SceneBattle:getBattleLoop():getBattleDeltaTime()
    --     BattleScreen:zoomToHero(hero:getId() , hero:getPosition())
    --     if self.m_nShootDeltaTime >= 1.5 then
    --         return true
    --     end
    end
    -- return false
end

--@brief    吸引
function BattleMsgSkillEffect:_TranserMove(targetHeroList)
    WZLog("BattleMsgSkillEffect:_TranserMove")
    local boss = self.m_tOwner
    local targetPos = boss:getPosition()

    for i, hero in pairs (targetHeroList) do
        --WZLog("BattleMsgSkillEffect:_TranserMove two", hero:getBattleId(), self.m_nTransferMoveDistance)
        local heroPos = hero:getPosition()
        local result = heroPos.x > targetPos.x and targetPos.x + self.m_nTransferMoveDistance or targetPos.x - self.m_nTransferMoveDistance
        hero:setPosition(Vector2:create(result,heroPos.y))
        if not hero.m_bIsAir then
            hero:setMoveUpdatable(true)
        end
    end
    
    return true
end

--@brief 出身点传送
function BattleMsgSkillEffect:_transerRandomBorn(targetHeroList)
    local heroList = {}
    for i,hero in pairs(targetHeroList) do
        if not hero.m_bOffRepulse then
            table.insert(heroList,hero)
        end
    end
    targetHeroList = heroList

    local randList = WBattleGlobal:getCurrent().m_tBattleRand
    local bornPosList = WBattleGlobal:getCurrent().bornPosList
    local posList = {}
    for i = 1,#bornPosList do
        local pos = Vector2:create(bornPosList[i][1],bornPosList[i][2])
        for j,hero in pairs (targetHeroList) do
            if math.abs(pos.x - hero:getPosition().x) > 100 then
                table.insert(posList,pos)
            end
        end
    end

    local tmpHero = {}
    for i,hero in pairs(targetHeroList) do
        table.insert(tmpHero,hero)
    end
    local sortFunc = function(a, b) return b:getBattleId() < a:getBattleId() end
    table.sort(tmpHero,sortFunc)

    for i, hero in pairs (tmpHero) do
        local randIndex = (WBattleGlobal:getCurrent():getTurnTimes() + hero:getBattleId()) % 10 + 1
        local randValue = randList[randIndex] % #posList + 1
        WZLog("BattleMsgSkillEffect:_transerRandomBorn", hero:getBattleId(),#posList, randIndex, randValue)
        hero:setPosition(posList[randValue])
        if not hero.m_bIsAir then 
            hero:setMoveUpdatable(true)
        end
    end
end

--改变属性
function BattleMsgSkillEffect:_changeAttribute(targetHeroList, skillType, isBuff)
    WZLog("BattleMsgSkillEffect:_changeAttribute", targetHeroList, skillType, tostring(self.m_nChangeValueIndex), tostring(self.m_nChangePercentIndex), tostring(self.m_nChangeValue), tostring(self.m_nChangePercent))
    local Attribute = {}
    for i, v in pairs (AttributeConfig)do
        Attribute[v] = i
    end

    for i, hero in pairs (targetHeroList) do
        if isBuff == nil then
            if skillType == EffectTypeConfig.CHANGE_ATTRIBUTE_VALUE then
                if self.m_nChangeValueIndex == AttributeConfig.HP then
                    local change = math.ceil(self.m_nChangeValue) or 0
                    change = hero:hurtEffectHandle(change * -1)

                    if change < 0 then
                        local recoveryAddPercent = hero:getRecoveryAddPercent()
                        change = change * (1+recoveryAddPercent)

                        if recoveryAddPercent ~= 0 then
                            local offSkillId = hero:getIsImmunityByPetSkill(1,EffectTypeConfig.CHANGE_RECOVERY_PERCENT)
                            if offSkillId then
                                BattlePetSkillManager:triggerPassiveSkillView(hero,offSkillId, true)
                            end
                        end
                        WZLog("BattleMsgBossMapSkill:_changeAttribute 11", change, recoveryAddPercent)
                    end

                    if change * -1 + hero.m_nHP > hero.m_nMaxHP then
                        change = (hero.m_nMaxHP - hero.m_nHP) * -1
                    end
                    WZLog("BattleMsgSkillEffect:_changeAttribute 1", change)
                    local curHp = hero.m_nHP - change
                    hero:setHp(curHp)
                    --设置过程伤害记录
                    if math.abs(change) > 0 then
                        WBattleGlobal:getCurrent():setHpProRecord(hero:getBattleId(),-change)
                    end

                    if change < 0 and (hero:isHide() == true and WBattleGlobal:getCurrent():isMyTeam(hero:getBattleId()) or hero:isHide() ~= true) then
                        local pos = BattleCommon:getPointTable(hero:getPosition().x + 100,hero:getPosition().y + 50)
                        local element = WZUISystem:getInstance():createElement(string.format("conHurtType%d_HurtNumber",3))
                        element:setLuaObjectIndex(self)
                        if element ~= nil then
                            GetElement(element,"txtHurtValue_HurtNumber",WZUILabelAtlasFont):setText(change * -1)
                            local conHurt = WZUIContainer:luaTo(element)
                            conHurt:setAbsPosition(GlobalMethod:ccp(pos.x,pos.y))
                            SceneBattle:getFrontLayer():addChild(conHurt,6)
                        end
                    end

                elseif self.m_nChangeValueIndex == AttributeConfig.PF then
                    WZLog("BattleMsgSkillEffect:_changeAttribute 2")
                    hero.m_nPF = hero.m_nPF + (self.m_nChangeValue or 0)
                    hero:setPF(hero.m_nPF)
                elseif self.m_nChangeValueIndex == AttributeConfig.SP then
                    WZLog("BattleMsgSkillEffect:_changeAttribute 3")
                    hero.m_nSP = hero.m_nSP + (self.m_nChangeValue or 0)
                    hero:setSp(hero.m_nSP)
                else
                    hero.m_tAttributeChangeStateList["m_n"..Attribute[self.m_nChangeValueIndex].."AddValue"] = {timeType=self.m_nChangeValueTimeType,timeValue=self.m_nChangeValueTimeValue,value=self.m_nChangeValue}

                end

                if self.m_nChangeValueIndex == AttributeConfig.BrokeRange then
                    WZLog("BattleMsgSkillEffect:_changeAttribute 7")
                    
                end
            elseif skillType == EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT then
                if self.m_nChangePercentIndex == AttributeConfig.HP then
                    local change = math.ceil(hero:getMaxHp(true) * (self.m_nChangePercent or 0)/100)
                    change = hero:hurtEffectHandle(change * -1)

                    if change < 0 then
                        local recoveryAddPercent = hero:getRecoveryAddPercent()
                        change = change * (1+recoveryAddPercent)

                        if recoveryAddPercent ~= 0 then
                            local offSkillId = hero:getIsImmunityByPetSkill(1,EffectTypeConfig.CHANGE_RECOVERY_PERCENT)
                            if offSkillId then
                                BattlePetSkillManager:triggerPassiveSkillView(hero,offSkillId, true)
                            end
                        end
                        WZLog("BattleMsgBossMapSkill:_changeAttribute 11", change, recoveryAddPercent)
                    end

                    if change * -1 + hero.m_nHP > hero.m_nMaxHP then
                        change = (hero.m_nMaxHP - hero.m_nHP) * -1
                    end
                    WZLog("BattleMsgSkillEffect:_changeAttribute 4", change)
                    local curHp = hero.m_nHP - change
                    hero:setHp(curHp)
                    --设置过程伤害记录
                    if math.abs(change) > 0 then
                        WBattleGlobal:getCurrent():setHpProRecord(hero:getBattleId(),-change)
                    end

                    if change < 0 and (hero:isHide() == true and WBattleGlobal:getCurrent():isMyTeam(hero:getBattleId()) or hero:isHide() ~= true) then
                        local pos = BattleCommon:getPointTable(hero:getPosition().x + 100,hero:getPosition().y + 20)
                        local element = WZUISystem:getInstance():createElement(string.format("conHurtType%d_HurtNumber",3))
                        element:setLuaObjectIndex(self)
                        if element ~= nil then
                            GetElement(element,"txtHurtValue_HurtNumber",WZUILabelAtlasFont):setText(change * -1)
                            local conHurt = WZUIContainer:luaTo(element)
                            conHurt:setAbsPosition(GlobalMethod:ccp(pos.x,pos.y))
                            SceneBattle:getFrontLayer():addChild(conHurt,6)
                        end
                    end
                elseif self.m_nChangePercentIndex == AttributeConfig.PF then
                    WZLog("BattleMsgSkillEffect:_changeAttribute 5")
                    hero.m_nPF = hero.m_nPF + (hero:getMaxPF(true) * (self.m_nChangePercent or 0)/100)
                elseif self.m_nChangePercentIndex == AttributeConfig.SP then
                    WZLog("BattleMsgSkillEffect:_changeAttribute 6")
                    hero.m_nSP = hero.m_nSP + (100 * (self.m_nChangePercent or 0)/100)
                    hero:setSp(hero.m_nSP)
                else
                    hero.m_tAttributeChangeStateList["m_n"..Attribute[self.m_nChangePercentIndex].."AddPercent"] = {timeType=self.m_nChangeValueTimeType,timeValue=self.m_nChangeValueTimeValue,value=self.m_nChangePercent}
                    if self.m_tSkillConfig and self.m_tSkillConfig.skill_type == 4 then
                        hero:addImmunityPetSkill(self.m_nSkillId,{type = EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT, subType = self.m_nChangePercentIndex,param = self.m_nChangePercent})
                    end
                    WZLog("BattleMsgBossMapSkill:_changeAttribute 44", "m_n"..Attribute[self.m_nChangePercentIndex].."AddPercent", self.m_nChangePercent)
                end

                if self.m_nChangeValueIndex == AttributeConfig.BrokeRange then
                    WZLog("BattleMsgSkillEffect:_changeAttribute 8")
                    hero.m_bWeaponAtomicBomb = true
                end
            elseif skillType == EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT_HURT then
                if self.m_nChangeHurtPercentIndex == AttributeConfig.HP then
                    local value = self.m_tOwner.m_nCurRoundHurt > 0 and self.m_tOwner.m_nCurRoundHurt or 0--人物为宠物伤害，怪物为伤害总量
                    local change = math.ceil(value * (self.m_nChangeHurtPercent or 0)/100)
                    if change > 0 then
                        change = math.ceil(change)
                    else
                        change = math.floor(change)
                    end

                    change = hero:hurtEffectHandle(change * -1)

                    if change < 0 then
                        local recoveryAddPercent = hero:getRecoveryAddPercent()
                        change = change * (1+recoveryAddPercent)

                        if recoveryAddPercent ~= 0 then
                            local offSkillId = hero:getIsImmunityByPetSkill(1,EffectTypeConfig.CHANGE_RECOVERY_PERCENT)
                            if offSkillId then
                                BattlePetSkillManager:triggerPassiveSkillView(hero,offSkillId, true)
                            end
                        end
                        WZLog("BattleMsgBossMapSkill:_changeAttribute 11", change, recoveryAddPercent)
                    end

                    if change * -1 + hero.m_nHP > hero.m_nMaxHP then
                        change = (hero.m_nMaxHP - hero.m_nHP) * -1
                    end
                    WZLog("BattleMsgBossMapSkill:_changeAttribute 14", value, change)
                    local curHp = hero.m_nHP - change
                    hero:setHp(curHp)
                    --设置过程伤害记录
                    if math.abs(change) > 0 then
                        WBattleGlobal:getCurrent():setHpProRecord(hero:getBattleId(),-change)
                    end

                    if change < 0 and (hero:isHide() == true and WBattleGlobal:getCurrent():isMyTeam(hero:getBattleId()) or hero:isHide() ~= true) then
                        local pos = BattleCommon:getPointTable(hero:getPosition().x + 100,hero:getPosition().y + 20)
                        local element = WZUISystem:getInstance():createElement(string.format("conHurtType%d_HurtNumber",3))
                        element:setLuaObjectIndex(self)
                        if element ~= nil then
                            GetElement(element,"txtHurtValue_HurtNumber",WZUILabelAtlasFont):setText(change * -1)
                            local conHurt = WZUIContainer:luaTo(element)
                            conHurt:setAbsPosition(GlobalMethod:ccp(pos.x,pos.y))
                            SceneBattle:getFrontLayer():addChild(conHurt,6)
                        end
                    end
                end
            else
                    if self.m_nChangePercentIndexAttack == AttributeConfig.HP then
                    local change = math.ceil(self.m_tOwner:getAttack(true) * (self.m_nChangePercentAttack or 0)/100)
                    change = hero:hurtEffectHandle(change * -1)

                    if change < 0 then
                        local recoveryAddPercent = hero:getRecoveryAddPercent()
                        change = change * (1+recoveryAddPercent)

                        if recoveryAddPercent ~= 0 then
                            local offSkillId = hero:getIsImmunityByPetSkill(1,EffectTypeConfig.CHANGE_RECOVERY_PERCENT)
                            if offSkillId then
                                BattlePetSkillManager:triggerPassiveSkillView(hero,offSkillId, true)
                            end
                        end
                        WZLog("BattleMsgBossMapSkill:_changeAttribute 11", change, recoveryAddPercent)
                    end
                    if change * -1 + hero.m_nHP > hero.m_nMaxHP then
                        change = (hero.m_nMaxHP - hero.m_nHP) * -1
                    end
                    WZLog("BattleMsgBossMapSkill:_changeAttribute 4", change)
                    local curHp = hero.m_nHP - change
                    hero:setHp(curHp)
                    --设置过程伤害记录
                    if math.abs(change) > 0 then
                        WBattleGlobal:getCurrent():setHpProRecord(hero:getBattleId(),-change)
                    end

                    if change < 0 and (hero:isHide() == true and WBattleGlobal:getCurrent():isMyTeam(hero:getBattleId()) or hero:isHide() ~= true) then
                        local pos = BattleCommon:getPointTable(hero:getPosition().x + 100,hero:getPosition().y + 20)
                        local element = WZUISystem:getInstance():createElement(string.format("conHurtType%d_HurtNumber",3))
                        element:setLuaObjectIndex(self)
                        if element ~= nil then
                            GetElement(element,"txtHurtValue_HurtNumber",WZUILabelAtlasFont):setText(change * -1)
                            local conHurt = WZUIContainer:luaTo(element)
                            conHurt:setAbsPosition(GlobalMethod:ccp(pos.x,pos.y))
                            SceneBattle:getFrontLayer():addChild(conHurt,6)
                        end
                    end
                end
            end
        end
    end
end

--@brief	伤害数字显示完成的回调
function BattleMsgSkillEffect:_finishFlyingNum(element)
    WZLog("BattleMsgSkillEffect_finishFlyingNum", tostring(element))

    element:removeFromParentAndCleanup(true)
end

--@brief 移除buff
function BattleMsgSkillEffect:_canelBuff(targetHeroList)
   WZLog("BattleMsgSkillEffect:_canelBuff id", self.m_nCancelBuffId)
   WZLog("BattleMsgSkillEffect:_canelBuff type", self.m_nCancelBuffType)

    for id, hero in pairs (targetHeroList) do
        if hero:isDead() ~= true then
            for index, buff in pairs (hero.m_tBuffChangeStateList) do 
                local isClear = false
                if self.m_nCancelBuffId and self.m_nCancelBuffId == buff.m_nID then
                    isClear = true
                end
                if self.m_nCancelBuffType and self.m_nCancelBuffType == buff.m_nType then
                    isClear = true
                end
                if not self.m_nCancelBuffId and not self.m_nCancelBuffType then
                    isClear = true
                end
                if isClear then
                    hero:removeBuffSpecialInfluence(buff)
                    buff:removeAnime()
                    hero.m_tBuffChangeStateList[index] = nil
                end
            end
        end
    end
end

--加buff
function BattleMsgSkillEffect:_addBuff(targetHeroList)
    WZLog("BattleMsgSkillEffect:_addBuff one", self.m_nAddBuffId)
    if targetHeroList then
        WZLog("targetHeroList",#targetHeroList)
    end
    local buffInfo = GDatatab_buff["id_"..self.m_nAddBuffId]
    
    for id, hero in pairs (targetHeroList) do
        if hero:isDead() ~= true then
            local buffNew = BuffBody:new(buffInfo,hero,self.m_tOwner:getBattleId())
            local buffExistIndex = nil
            local buffExist = nil
            local offBuff = false
            for index, buff in pairs (hero.m_tBuffChangeStateList) do 
                if buff.m_nType == BuffType.SHAPE_RECOVERY and buffNew.m_nType == BuffType.SHAPE_RECOVERY then
                    isShapeRecovery = true
                    buff.m_nTimePassValueReal = 0
                    buff.m_nTakeEffectCountReal = 0
                    buff.m_nTimePassValue = 0
                    buff.m_nTakeEffectCount = 0
                    offBuff = true
                    local round = WBattleGlobal:getCurrent().m_nTurnTimes
                    WBattleGlobal:getCurrent().m_tBuffAddSkillPlayerList = WBattleGlobal:getCurrent().m_tBuffAddSkillPlayerList or {}
                    table.insert(WBattleGlobal:getCurrent().m_tBuffAddSkillPlayerList, {actionTimes = hero.m_nActionTimes,round=round,playerId=hero:getBattleId(),buffId=self.m_nAddBuffId,userId=self.m_tOwner:getBattleId(),isMapBuff=buffNew.m_bIsMapBuff})
                    table.insert(WBattleGlobal:getCurrent().m_tBuffInfoCurRound, {id=self.m_nAddBuffId, playerId=hero:getBattleId(), buffInfo=buffInfo})
                    break
                end

                if buff.m_nType == BuffType.SHAPE_NO_HOLE and buffNew.m_nType == BuffType.SHAPE_NO_HOLE then
                    isShapeRecovery = true
                    buff.m_nTimePassValueReal = 0
                    buff.m_nTakeEffectCountReal = 0
                    buff.m_nTimePassValue = 0
                    buff.m_nTakeEffectCount = 0
                    offBuff = true
                    local round = WBattleGlobal:getCurrent().m_nTurnTimes
                    WBattleGlobal:getCurrent().m_tBuffAddSkillPlayerList = WBattleGlobal:getCurrent().m_tBuffAddSkillPlayerList or {}
                    table.insert(WBattleGlobal:getCurrent().m_tBuffAddSkillPlayerList, {actionTimes = hero.m_nActionTimes,round=round,playerId=hero:getBattleId(),buffId=self.m_nAddBuffId,userId=self.m_tOwner:getBattleId(),isMapBuff=buffNew.m_bIsMapBuff})
                    table.insert(WBattleGlobal:getCurrent().m_tBuffInfoCurRound, {id=self.m_nAddBuffId, playerId=hero:getBattleId(), buffInfo=buffInfo})
                    break
                end
                if buffNew.m_nType == buff.m_nType then
                    buffExistIndex = index
                    buffExist = buff
                    if buffNew.m_nLv < buff.m_nLv then
                        offBuff = true
                    end
                    --break
                end
            end

            --免疫冰冻等
            
            if hero.m_bOffFrozen then
                local immunizeList = {EffectTypeConfig.LIMIT_MOVE, EffectTypeConfig.LIMIT_FLY, EffectTypeConfig.LIMIT_USE_SKILL, EffectTypeConfig.LIMIT_USE_ITEM, EffectTypeConfig.LIMIT_ALL_ACTION, EffectTypeConfig.LIMIT_VISIBLE}
                for id, effectParm in pairs (buffNew.m_nEffect) do
                    local effect = effectParm[3] .. "_" ..effectParm[4]
                    for id, effectType in pairs (immunizeList) do
                        if effect == effectType then
                            -- buffExist = buffNew
                            offBuff = true
                            WZLog("BattleMsgSkillEffect:_addBuff offBuff", effectType)
                            break
                        end
                    end
                end
            end

            --被动免疫
            local offSkillId = hero:getIsImmunityByPetSkill(0,buffInfo.buff_type)
            if buffNew.m_nType == BuffType.SHAPE_NO_HOLE then
                hero:addImmunityPetSkill(self.m_nSkillId,{type = EffectTypeConfig.NO_HOLE})
                WZLog("BattleMsgBossMapSkill:_addBuff four", self.m_nSkillId)
            elseif offSkillId then
                BattlePetSkillManager:triggerPassiveSkillView(hero,offSkillId)
                offBuff = true
            end

            if not offBuff then
                WZLog("BattleMsgSkillEffect:_addBuff three-0", buffNew.m_nEffect)

                local round = WBattleGlobal:getCurrent().m_nTurnTimes
                WBattleGlobal:getCurrent().m_tBuffAddSkillPlayerList = WBattleGlobal:getCurrent().m_tBuffAddSkillPlayerList or {}
                table.insert(WBattleGlobal:getCurrent().m_tBuffAddSkillPlayerList, {actionTimes = hero.m_nActionTimes,round=round,playerId=hero:getBattleId(),buffId=self.m_nAddBuffId,userId=self.m_tOwner:getBattleId(),isMapBuff=buffNew.m_bIsMapBuff})

                if buffExistIndex then
                    buffExist:removeAnime()
                    hero.m_tBuffChangeStateList[buffExistIndex] = nil
                end

                if buffNew.m_nType == BuffType.SHAPE_RECOVERY and isShapeRecovery == false then
                    BattlePetSkillManager:triggerPassiveSkillView(hero,self.m_nSkillId)
                end

                table.insert(hero.m_tBuffChangeStateList, buffNew)
                buffNew:addAnime()
                if buffNew.m_nTimeIntervalValue == -1 then
                    for i,buffEffect in pairs (buffNew.m_nEffect) do
                        self:_doEffectType(buffEffect,{[1]=hero},true)
                        local effect = buffEffect[3] .. "_" ..buffEffect[4]
                        self:addStep(effect, {[1]=hero}, true)
                    end
                end
            end
        end
    end
end

--@brief 镜头移动
function BattleMsgSkillEffect:_cameraFollowHero(targetHeroList)
    local hero = targetHeroList[1]
    if not hero or hero:isDead() or hero:getMover():isCollision() then
        return true
    end

    BattleScreen:followHero(hero:getPosition())
    return false
end

--击飞
function BattleMsgSkillEffect:_repelFly(targetHeroList,skillType)
    WZLog("BattleMsgSkillEffect:_repelFly one", tostring(self.m_tOwner.m_bActiveAttack))
    local hurterPos = self.m_tOwner:getPosition()
    if self.m_tOwner.m_tActiveAttackPos ~= nil and #self.m_tOwner.m_tActiveAttackPos > 0 then
        hurterPos = self.m_tOwner.m_tActiveAttackPos[1]
    end
    for i, hero in pairs (targetHeroList) do
        --被动免疫
        local offSkillId = hero:getIsImmunityByPetSkill(1,skillType)
        if offSkillId then
            BattlePetSkillManager:triggerPassiveSkillView(hero,offSkillId)
        else
            local heroPos = hero:getAnimation():getPosition()
            if  heroPos.x > hurterPos.x then
                WZLog("BattleMsgSkillEffect:_repelFly two", self.m_nRepelFlyX)
                hero:setRepulse(self.m_nRepelFlyX/10)
            else
                WZLog("BattleMsgSkillEffect:_repelFly three", self.m_nRepelFlyX)
                hero:setRepulse(-1*self.m_nRepelFlyX/10)
            end
        end
    end
end

--改变散射数
function BattleMsgSkillEffect:_changeScatter(targetHeroList)
    WZLog("BattleMsgSkillEffect:_changeScatter")
    for i, hero in pairs (targetHeroList) do
        hero.m_tAttributeChangeStateList.m_nAttScatterNum = {timeType=self.m_nAttScatterNumTimeType,timeValue=self.m_nAttScatterNumTimeValue,value=self.m_nAttScatterNum}
    end
end

--改变连射数
function BattleMsgSkillEffect:_changeAtkTimes(targetHeroList)
    WZLog("BattleMsgBossMapSkill:_changeAtkTimes", self.m_nAttTimes)
    for i, hero in pairs (targetHeroList) do
        WZLog("BattleMsgSkillEffect:_changeAtkTimes", hero:getBattleId(), self.m_nAttTimes)
        hero.m_tAttributeChangeStateList.m_nAttTimes = {timeType=self.m_nAttTimesTimeType,timeValue=self.m_nAttTimesTimeValue,value=self.m_nAttTimes}
    end
end

--冰冻
function BattleMsgSkillEffect:_frozen(targetHeroList)
    WZLog("BattleMsgSkillEffect:_frozen", tostring(self.m_tOwner.m_nUseSkillState))
    for i, hero in pairs (targetHeroList) do
        hero.m_tAttributeChangeStateList.m_nDebuffFrozenRound = {timeType=self.m_nDebuffFrozenRoundTimeType,timeValue=self.m_nDebuffFrozenRoundTimeValue,value=self.m_nDebuffFrozenRound}
    end
end

--隐身
function BattleMsgSkillEffect:_hide(targetHeroList, isBuff)
    WZLog("BattleMsgSkillEffect:_hide")
    for i, hero in pairs (targetHeroList) do
        local nPlayerId = hero:getBattleId()
        WZLog("BattleMsgSkillEffect:_hide one", nPlayerId, tostring(WBattleGlobal:getCurrent():isMyTeam(nPlayerId)))
        if isBuff == nil then
            hero.m_tAttributeChangeStateList.m_nHideTurn = {timeType=self.m_nHideTurnTimeType,timeValue=self.m_nHideTurnTimeValue,value=self.m_nHideTurn}
        end

        if WBattleGlobal:getCurrent():isMyTeam(nPlayerId) then
            opecity = 128
        else
            opecity = 0
        end

        hero:getAnimation():getAnimNode():setOpacity(opecity)
        if hero:getPlayerNameIcon() and opecity == 0 then
            hero:getPlayerNameIcon():setOpecity(opecity)
        end
        if hero:getPet() then
            hero:getPet():getAnimation():getAnimNode():setOpacity(opecity)
        end
        if hero.m_angerAnim then
            hero.m_angerAnim:getAnimNode():setOpacity(opecity)
        end

        if hero.m_angerAnim2 then
            hero.m_angerAnim2:getAnimNode():setOpacity(opecity)
        end

        if hero.m_frozenAnim ~= nil then
            hero.m_frozenAnim:getAnimNode():setOpacity(opecity)
        end

        if hero.m_tHurtAnim ~= nil then
            for i, v in pairs(hero.m_tHurtAnim) do
                v:getAnimNode():setOpacity(opecity)
            end
        end

        for id,buff in pairs (hero.m_tBuffChangeStateList) do
            if buff.m_tAnim then
                buff.m_tAnim:getAnimNode():setOpacity(opecity)
            end
        end
    end
end

--@brief    溅射
function BattleMsgSkillEffect:_spatter()
    if not self.m_tSpatterInfo then 
        return
    end
    WZLog("BattleMsgSkillEffect:_spatter", self.m_tSpatterInfo.count, self.m_tSpatterInfo.hurtSkillId)

    -- if self.m_tOwner:isCanControl() then
    --     ProtocolProcessorBattleInterface:send_BATTLE_SkillEquip(WBattleGlobal:getCurrent():getBattleId(), self.m_tOwner:getBattleId(), self.m_tSpatterInfo.hurtSkillId)
    -- end
    self:_createBulletSpatter(self.m_tSpatterInfo.count)

    local config = {actType = BattleSkillType.UPDATE_BULLET,isWait = 1}
    self.m_tSkillShowMsg:doAction(config,config.isWait)
end

--@brief    创建溅射子弹
--@param    nScatterNum:溅射数量
function BattleMsgSkillEffect:_createBulletSpatter(nScatterNum)
    if not self.m_tSpatterInfo then 
        return
    end
    local speedx, speedy, startX, startY, isCollision = self.m_tSpatterInfo.speed.x, self.m_tSpatterInfo.speed.y, self.m_tSpatterInfo.pos.x, self.m_tSpatterInfo.pos.y, self.m_tSpatterInfo.speed.isCollision
    local dire = 1
    -- if isCollision then
    --     dire = speedy < 0 and 1 or -1
    -- else
    --     dire = 1
    -- end
    local maxSpeed = math.max(speedx, speedy)
    speedx, speedy = 0,(math.abs(maxSpeed) < 20 and 20 * dire) or (math.abs(maxSpeed) < 25 and 25 * dire) or 30 * dire

    WZLog("BattleMsgSkillEffect:_createBulletSpatter two", nScatterNum,tostring(speedx),tostring(speedy), self.m_tSpatterInfo.speed.y, tostring(isCollision))

    local hero = self.m_tOwner
    if hero:getWeaponType() == 0 then
        SoundManager:playEffectSound(SoundDefine.E_S_SHOOT_1)
    else
        SoundManager:playEffectSound(SoundDefine.E_S_SHOOT_2)
    end

    local startAngle = 0
    --startAngle = -1 * BattleConstants.g_fWB_SCATTER_ANGLE * (math.floor(nScatterNum / 2) - (nScatterNum+1)%2/2)
    self.m_tSpatterAngle = WBattleGlobal:getCurrent():getCurSpatterAngle()
    local speedVec = BattleCommon:vectorWithAngle({x=speedx,y=speedy},startAngle)
    self.m_nSpatterIndex = 1
    self.m_tSpeedPt = {x=speedx,y=speedy}
    self:_showOtherSpatter()
    -- for i=1,nScatterNum do
    --     speedVec.x = tonumber(string.format("%.4f",speedVec.x))
    --     speedVec.y = tonumber(string.format("%.4f",speedVec.y))
    --     WZLog("BattleMsgSkillEffect:_createBulletSpatter three",i,startX,startY,speedVec.x,speedVec.y)
    --     -- local bullet = WBattleGlobal:getCurrent():buildBullet(self.m_tOwner:getBattleId(),startX,startY,speedVec.x,speedVec.y, true)
    --     local bulletInfo = BattleMethod:getBossBulletInfo(self.m_tOwner.m_nBulletId)
    --     local bulletAnim = BattleMethod:createBulletAnim(bulletInfo)

    --     local bullet = WBattleGlobal:getCurrent():buildBossBullet(bulletAnim,{x = startX,y = startY},speedVec,bulletInfo.m_tAcceleration,self.m_tOwner,bulletInfo.m_nBulletType,BulletEffectId.EFFECT_DEFAULT,BulletEffectId.EFFECT_DEFAULT,bulletInfo.m_bIsPenetrateMonster,bulletInfo.m_bIsPenetrateMap,true)
    --     bullet:setCheckCharacterCollisionRadius(bulletInfo.m_nCheckCharacterCollisionRadius)
    --     bullet:setAnimDefaultDirection(bulletInfo.m_nBulletAnimDefaultDirection)
    --     bullet:getAnimation():setFlipX(true)
    --     if speedx > 0 then
    --         bullet:getAnimation():setFlipY(true)
    --     end
    --     --[[
    --     if WBattleGlobal:getCurrent().m_tIsHighEndMachine == true then
    --         SceneBattle:getFrontLayer():addChild(bullet:getBackFire():getParent(),2)
    --     end
    --     ]]
    --     SceneBattle:getFrontLayer():addChild(bullet:getAnimation():getAnimNode(),3)
    --     bullet:getAnimation():play("0")

    --     -- local hero = WBattleGlobal:getCurrent():getCurrentCharacter()
    --     -- if hero:isHide() == true then
    --     --     bullet:getAnimation():getAnimNode():setOpacity(51)
    --     --     if WBattleGlobal:getCurrent().m_tIsHighEndMachine == true then
    --     --         bullet:getBackFire():setVisible(false)
    --     --     end
    --     -- end

    --     speedVec = BattleCommon:vectorWithAngle(speedVec,BattleConstants.g_fWB_SCATTER_ANGLE)
    -- end
end


--@brief    生成溅射弹
function BattleMsgSkillEffect:_showOtherSpatter(element, dt)
    -- body
    if self.m_nSpatterIndex > self.m_tSpatterInfo.count then 
        WZLog("BattleMsgSkillEffect:_showOtherSpatter 00000")
        if g_SpatterScheduleId then 
            CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(g_SpatterScheduleId)
            g_SpatterScheduleId = nil 
        end
        self.m_bSpatterDone = true
        return 
    else
        g_SpatterScheduleId = DelayCallFunction(self._showOtherSpatter, self, 0.2)
    end
    local startX, startY = self.m_tSpatterInfo.pos.x, self.m_tSpatterInfo.pos.y

    local speedVec = BattleCommon:vectorWithAngle(self.m_tSpeedPt, self.m_tSpatterAngle[self.m_nSpatterIndex])
    WZLog("BattleMsgSkillEffect:_createBulletSpatter three", type(self.m_tSpatterAngle), #self.m_tSpatterAngle, Serialize(self.m_tSpatterAngle))
    speedVec.x = tonumber(string.format("%.4f",speedVec.x))
    speedVec.y = tonumber(string.format("%.4f",speedVec.y))
    WZLog("BattleMsgSkillEffect:_showOtherSpatter", speedVec.x, speedVec.y)
    -- local bullet = WBattleGlobal:getCurrent():buildBullet(self.m_tOwner:getBattleId(),startX,startY,speedVec.x,speedVec.y, true)
    local bulletInfo = BattleMethod:getBossBulletInfo(self.m_tOwner.m_nBulletId)
    local bulletAnim = BattleMethod:createBulletAnim(bulletInfo)

    local bullet = WBattleGlobal:getCurrent():buildBossBullet(bulletAnim,{x = startX,y = startY},speedVec,bulletInfo.m_tAcceleration,self.m_tOwner,bulletInfo.m_nBulletType,BulletEffectId.EFFECT_DEFAULT,BulletEffectId.EFFECT_DEFAULT,bulletInfo.m_bIsPenetrateMonster,bulletInfo.m_bIsPenetrateMap,true)
    bullet:setCheckCharacterCollisionRadius(bulletInfo.m_nCheckCharacterCollisionRadius)
    bullet:setAnimDefaultDirection(bulletInfo.m_nBulletAnimDefaultDirection)
    bullet:getAnimation():setFlipX(true)
    if self.m_tSpeedPt.x > 0 then
        bullet:getAnimation():setFlipY(true)
    end
    --[[
    if WBattleGlobal:getCurrent().m_tIsHighEndMachine == true then
        SceneBattle:getFrontLayer():addChild(bullet:getBackFire():getParent(),2)
    end
    ]]
    SceneBattle:getFrontLayer():addChild(bullet:getAnimation():getAnimNode(),3)
    bullet:getAnimation():play("0")

    -- local hero = WBattleGlobal:getCurrent():getCurrentCharacter()
    -- if hero:isHide() == true then
    --     bullet:getAnimation():getAnimNode():setOpacity(51)
    --     if WBattleGlobal:getCurrent().m_tIsHighEndMachine == true then
    --         bullet:getBackFire():setVisible(false)
    --     end
    -- end

    self.m_nSpatterIndex = self.m_nSpatterIndex + 1
end

--@brief    生成龙卷风
function BattleMsgSkillEffect:_buildTornado()
    if not self.m_tTornadoInfo then
        return
    end
    WZLog("BattleMsgSkillEffect:_buildTornado", self.m_tTornadoInfo.camp,self.m_tTornadoInfo.templateId)
    if not WBattleGlobal:getCurrent():isSingleStage() then
        --只创建一个 直接赋值
        for i=1,#self.m_tSummonMonsterId do
             for j, v in pairs(self.m_tOwner.guaiId) do
                if self.m_tSummonMonsterId[i] == v then
                    self.m_tTornadoInfo.battleId = self.m_tOwner.guaiBattleId[j]
                    table.remove(self.m_tOwner.guaiId, j)
                    table.remove(self.m_tOwner.guaiBattleId, j)
                    table.remove(self.m_tOwner.guaiPositionX, j)
                    table.remove(self.m_tOwner.guaiPositionY, j)
                    break
                end
            end
        end
    else
        --单人副本创建小怪 为小怪添加battleId
        self.m_tTornadoInfo.battleId = WBattleGlobal:getCurrent():getBuildGuaiBattleId(true)
    end
    
    local tornado = WBattleGlobal:getCurrent():buildMachine(MonsterType.TORANDO,self.m_tTornadoInfo)
    SceneBattle:getFrontLayer():addChild(tornado.m_anim:getAnimNode())
    -- WZLog("BattleMsgSkillEffect:_buildTornado", self.m_tTornadoInfo.camp)

    -- if WBattleGlobal:getCurrent().m_tMapEvents == nil then
    --     WBattleGlobal:getCurrent().m_tMapEvents = {}
    -- end

    -- local chara = WBattleGlobal:getCurrent():getCharacterWithId(self.m_tTornadoInfo.charaId)
    -- chara:endTornado()

    -- local mapEvent = MapEnenvtTornado:buildEvent(1, "龙卷风", effect1, effect2, self.m_tTornadoInfo)
    -- if mapEvent ~= nil then
    --     table.insert(WBattleGlobal:getCurrent().m_tMapEvents, mapEvent)
    -- end

end

--@brief 等待怪物id
function BattleMsgSkillEffect:_waitMonsterId()
    if  WBattleGlobal:getCurrent():isSingleStage() then 
        return true
    end
    if  self.m_tOwner.guaiId == nil or #self.m_tOwner.guaiId == 0 then 
        WZLog("BattleMsgSkillEffect:_waitMonsterId wait")
        self.m_bIsWaitMonsterId = true
        self.m_tSkillShowMsg.m_bIsWaitMonsterId = true
        return false
    end
    self.m_bIsWaitMonsterId = false
    self.m_tSkillShowMsg.m_bIsWaitMonsterId = false
    return true
end

--@brief 获取怪物id
function BattleMsgSkillEffect:_getBattleIdBySummonIndex()
    if self.m_tOwner.guaiId ~= nil then 
        for j, v in pairs(self.m_tOwner.guaiId) do
            WZLog("BattleMsgSkillEffect:_getBattleIdBySummonIndex",v)
            if self.m_tSummonMonsterId[self.m_nSummonIndex] == v then
                self.m_tSummonMonsterBattleId[self.m_nSummonIndex] = self.m_tOwner.guaiBattleId[j]
                table.remove(self.m_tOwner.guaiId, j)
                table.remove(self.m_tOwner.guaiBattleId, j)
                table.remove(self.m_tOwner.guaiPositionX, j)
                table.remove(self.m_tOwner.guaiPositionY, j)
                break
            end
        end
    end
    WZLog("BattleMsgSkillEffect:_getBattleIdBySummonIndex one---", self.m_nSummonIndex, #self.m_tSummonMonsterBattleId, #self.m_tSummonMonsterId, #self.m_tSummonMonsterPositionX, #self.m_tSummonMonsterPositionY)
    local battleId = self.m_tSummonMonsterBattleId[self.m_nSummonIndex] or -2
    WZLog("BattleMsgSkillEffect:_getBattleIdBySummonIndex two---",battleId,self.m_tSummonMonsterId[self.m_nSummonIndex])
    return battleId
end

--@brief 创建普通怪物
function BattleMsgSkillEffect:_summonMonster()
    if not WBattleGlobal:getCurrent():isSingleStage() and not self.m_tOwner.guaiId == nil then 
        WZLog("BattleMsgSkillEffect:_summonMonster wait")
        return false
    end
    if not self.m_nSummonIndex then
        self.m_nSummonIndex = 1
    else
        self.m_nSummonIndex = self.m_nSummonIndex + 1
    end
   
    -- WZLog("BattleMsgSkillEffect:sendBuildSummonMonster one---", self.m_nSummonIndex, #self.m_tSummonMonsterBattleId, #self.m_tSummonMonsterId, #self.m_tSummonMonsterPositionX, #self.m_tSummonMonsterPositionY)
    local battleId = self:_getBattleIdBySummonIndex()
    --单人副本创建小怪 为小怪添加battleId
    if WBattleGlobal:getCurrent():isSingleStage() and WBattleGlobal:getCurrent():getCopyData() then
        battleId = WBattleGlobal:getCurrent():getCopyData():getBuildGuaiIndex()
        WBattleGlobal:getCurrent():getCopyData():addBuildGuaiIndex()
    end
    local monster = WMonster:buildGuai(self.m_tSummonMonsterId[self.m_nSummonIndex],nil, true, battleId)
    --self:setGuaiInfo(monster, self.m_tSummonMonsterId[self.m_nSummonIndex])
    
    WZLog("BattleMsgSkillEffect:buildSummonMonster two", self.m_nSummonIndex, battleId, monster.m_sAniFileId, monster.m_nPlayerId, 
        monster.m_sPlayerName, monster.m_nLevel, monster.m_nRealLevel, monster.m_nCamp, monster.m_nMaxHP, 
        monster.m_nHP, monster.m_nPF, monster.m_nAttack, monster.m_nCriticalhitAttackRate, monster.m_nDefence, 
        monster.m_nInjuryFree, monster.m_nWreckDefense, monster.m_nReduceCrit, monster.m_nReduceBury, monster.m_nGuaiType)
    monster:setPosition(BattleCommon:getPointTable(self.m_tSummonMonsterPositionX[self.m_nSummonIndex],self.m_tSummonMonsterPositionY[self.m_nSummonIndex]))
    monster:getAnimation():getAnimNode():setAnchorPoint(monster:getSceneAnchorPoint())
    if WBattleGlobal:getCurrent():isSingleStage() or monster.m_nMonsterType ~= MonsterType.BOSS then
        monster:setBoss(self.m_tOwner)
        table.insert(self.m_tOwner.m_tOwnedMonsterList, monster)
    end
    monsterPos = monster:getPosition()
    -- --加入场景
    -- if self.m_bSummonAuto then
    --     WBattleGlobal:getCurrent().m_tGuais[battleId] = monster
    --     SceneBattle:getFrontLayer():addChild(monster:getAnimation():getAnimNode())
    --     WBattleGlobal:getCurrent().m_battleManager:addEntity(monster:getMover())

    --     monster:setAppearAttribute()
    --     monster:getAnimation():play(monster:getAnimationName("standby"), true)
    -- end
    
    --添加ctb头像
    if battleId > 0 and not WBattleGlobal:getCurrent():isExpCopy() and monster:isNormalAct() then
        WZLog("BattleMsgSkillEffect:buildSummonMonster three", battleId)
        BattleCtbManager:addCellBattleCtb(battleId)
    else
        monster.m_bIsInCtb = false
    end
    
    -- --出现特效
    -- if self.m_bSummonEffectId then
    --     local effect  = BattleEffect:createAnimation(self.m_bSummonEffectId)
    --     monster:getAnimation():getAnimNode():addChild(effect:getAnimNode())
    -- end
    -- --调整方向
    -- if self.m_bSummonIsFilpX then
    --      if monster.m_bIsFilpX ~= true then
    --         monster:getAnimation():setFlipX(true)
    --         monster.m_bIsFilpX = true
    --     elseif monster.m_bIsFilpX == true then
    --         monster:getAnimation():setFlipX(false)
    --         monster.m_bIsFilpX = false
    --     end
    -- end
    table.insert(self.m_tOwner.m_tCursummonList,monster)
    GlobalGame:getBattleEventDispatcher():Dispatch(BATTLE_EVENT_TYPE.MONSTER_CREATE)
        
    --  --加入场景镜头拖动
    -- if self.m_nSummonIndex == 1 and self.m_bSummonAuto and monsterPos then
    --     local config = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = nil,param2 = nil,param3 = monsterPos}
    --     self:doAction(config,config.isWait)
    -- end
    if self.m_nSummonIndex == #self.m_tSummonMonsterId then
        return true
    else
        return false
    end
end

--@brief 生成聚光灯
function BattleMsgSkillEffect:_buildBossLight()
    WZLog("BattleMsgSkillEffect:_buildBossLight")
    if not self.m_nSummonIndex then
        self.m_nSummonIndex = 1
    else
        self.m_nSummonIndex = self.m_nSummonIndex + 1
    end
    local battleId = self:_getBattleIdBySummonIndex()
    WZLog("BattleMsgSkillEffect:_buildBossLight",self.m_nSummonIndex,battleId,self.m_tSummonMonsterId[self.m_nSummonIndex])
    local info = {}
    info.battleId = battleId
    info.templateId = self.m_tSummonMonsterId[self.m_nSummonIndex]
    info.camp = self.m_tOwner:getCamp()
    info.bronPos = BattleCommon:getPointTable(self.m_tSummonMonsterPositionX[self.m_nSummonIndex],self.m_tSummonMonsterPositionY[self.m_nSummonIndex])
    local bossLight = WBattleGlobal:getCurrent():buildMachine(MonsterType.BOSS_LIGHT,info)
    -- SceneBattle:getFrontLayer():addChild(bossLight.m_anim:getAnimNode())

    if self.m_nSummonIndex == #self.m_tSummonMonsterId then
        return true
    else
        return false
    end
end

--@brief 生成礼物
function BattleMsgSkillEffect:_buildBossGift()
    if not self.m_nSummonIndex then
        self.m_nSummonIndex = 1
    else
        self.m_nSummonIndex = self.m_nSummonIndex + 1
    end
    local battleId = self:_getBattleIdBySummonIndex()
    local info = {}
    info.battleId = battleId
    WZLog("BattleMsgSkillEffect:_buildBossGift",self.m_nSummonIndex,battleId,self.m_tSummonMonsterId[self.m_nSummonIndex])
    info.templateId = self.m_tSummonMonsterId[self.m_nSummonIndex]
    info.camp = self.m_tOwner:getCamp()
    info.bronPos = BattleCommon:getPointTable(self.m_tSummonMonsterPositionX[self.m_nSummonIndex],self.m_tSummonMonsterPositionY[self.m_nSummonIndex])
    local bossGift = WBattleGlobal:getCurrent():buildMachine(MonsterType.BOSS_GIFT,info)
    -- SceneBattle:getFrontLayer():addChild(bossGift.m_anim:getAnimNode())
    
    if self.m_nSummonIndex == #self.m_tSummonMonsterId then
        return true
    else
        return false
    end
end

--@brief    换位
function BattleMsgSkillEffect:_transferPositionStart(targetHeroList)
    WZLog("BattleMsgSkillEffect:_transferPositionStart")
    local list = {}
    for i, hero in pairs (targetHeroList) do
        if not hero.m_bOffFrozen and hero:getBattleId() ~= self.m_tOwner:getBattleId() and not hero:isDead() then
            table.insert(list,hero)
        end
    end
    if #list == 0 or self.m_tOwner:isDead() then
        return
    end
    local function sort(a,b)
        return a:getBattleId() < b:getBattleId()
    end
    table.sort(list,sort)
    local index = WBattleGlobal:getCurrent():getBattleRandNum() % #list + 1
    local hero = list[index]
    local effect  = BattleEffect:createAnimation(305)
    self.m_tOwner:getAnimation():getAnimNode():addChild(effect:getAnimNode())

    local effect2  = BattleEffect:createAnimation(305)
    hero:getAnimation():getAnimNode():addChild(effect2:getAnimNode())

    self.m_tTransferHero = hero
    self.m_nShootDeltaTime = 0
end

--@brief    换位
function BattleMsgSkillEffect:_waitForTransEffect()
    WZLog("BattleMsgSkillEffect:_waitForTransEffect")
    if not self.m_tTransferHero then
        return true
    end
    if not self.m_nShootDeltaTime then
        return true
    end
    self.m_nShootDeltaTime = self.m_nShootDeltaTime + SceneBattle:getBattleLoop():getBattleDeltaTime()
    if self.m_nShootDeltaTime >= 1 then
        return true
    end
    return false
end

--@brief    换位
function BattleMsgSkillEffect:_transferPosition()
    WZLog("BattleMsgSkillEffect:_transferPosition")
    if not self.m_tTransferHero then
        return true
    end
    local hero = self.m_tTransferHero
    local tx,ty,tro = hero:getPosition().x,hero:getPosition().y,hero:getAnimation():getRotate()
    local x,y,ro = self.m_tOwner:getPosition().x,self.m_tOwner:getPosition().y,self.m_tOwner:getAnimation():getRotate()
    hero:setPosition(GlobalMethod:ccp(x,y))
    hero:getAnimation():setRotate(ro)
    self.m_tOwner:setPosition(GlobalMethod:ccp(tx,ty))
    self.m_tOwner:getAnimation():setRotate(tro)
    if tx < x then
        self.m_tOwner:setLeftDirection(true)
        hero:setLeftDirection(false)
    else
        self.m_tOwner:setLeftDirection(false)
        hero:setLeftDirection(true)
    end
end

