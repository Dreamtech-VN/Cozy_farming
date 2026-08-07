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
function BattleMsgSkillEffect:addStep(skillType, param, isBuff, param2)
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
    elseif skillType == EffectTypeConfig.CHANGE_ATTRIBUTE_VALUE or skillType == EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT or skillType == EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT_HURT or skillType == EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT_HURT2 or skillType == EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT_HURT3 then
        table.insert(self.m_tStepFunction,{self._changeAttribute,param,skillType,isBuff,param2})
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
    elseif skillType == EffectTypeConfig.ENEMY_GATHER then
        table.insert(self.m_tStepFunction,{self._gatherTogether,param,skillType})
    elseif skillType == EffectTypeConfig.TWOSHOOT then
        table.insert(self.m_tStepFunction,{self._secondShoot})
    elseif skillType == EffectTypeConfig.SPATTER_TWO then
        table.insert(self.m_tStepFunction,{self._spatterTwo})
    elseif skillType == EffectTypeConfig.PET_CONTINUE_SHOOT then
        table.insert(self.m_tStepFunction,{self._changePetAtkTimes})
    elseif skillType == EffectTypeConfig.FIRE_TOTEM then
        self.m_bIsSummonMsg = true
--        table.insert(self.m_tStepFunction,{self._requestMonsterId})
        table.insert(self.m_tStepFunction,{self._waitMonsterId})
        table.insert(self.m_tStepFunction,{self._buildFireTotem})
    elseif skillType == EffectTypeConfig.RANDOM_SCATTER_SHOOT then
        table.insert(self.m_tStepFunction,{self._changeScatter,param})
    elseif skillType == EffectTypeConfig.GUARDIAN_TOTEM then
        self.m_bIsSummonMsg = true
--        table.insert(self.m_tStepFunction,{self._requestMonsterId})
        table.insert(self.m_tStepFunction,{self._waitMonsterId})
        table.insert(self.m_tStepFunction,{self._buildGuardianTotem})
    elseif skillType == EffectTypeConfig.ADD_RANDOMBUFF then
        table.insert(self.m_tStepFunction,{self._addRandomBuff})
    elseif skillType == EffectTypeConfig.BLACK_HOLE then
        self.m_bIsSummonMsg = true
        WZLog("EffectTypeConfig BLACK_HOLE", type(self.m_tOwnPlayerId))
--        table.insert(self.m_tStepFunction,{self._requestMonsterId})
        table.insert(self.m_tStepFunction,{self._waitMonsterId})
        table.insert(self.m_tStepFunction,{self._buildFireTotem, MonsterType.BLACK_HOLE})
    elseif skillType == EffectTypeConfig.DISPERSE_MONSTER_BY_TYPE then
        table.insert(self.m_tStepFunction,{self._disperseMonsterByType})
    elseif skillType == EffectTypeConfig.EXTRA_HP then
--        table.insert(self.m_tStepFunction,{self._setExtraHP, param})
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
    elseif effect == EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT_HURT or effect == EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT_HURT2 or effect == EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT_HURT3 then
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
    elseif effect == EffectTypeConfig.ENEMY_GATHER then
        WZLog("BattleMsgSkillEffect:_doEffect GATHER")
        self.m_nGatherDis = effectParm[5]
    elseif effect == EffectTypeConfig.TWOSHOOT then
       self.m_tTwoShootInfo = {pos=CopyTable(targetHeroList[1].m_tActiveAttackPos[1]),speed=CopyTable(targetHeroList[1].m_tActiveAttackSpeed[1]),count=effectParm[5],hurtSkillId=effectParm[6]} 
    elseif effect == EffectTypeConfig.SPATTER_TWO then
        local spatterTargetList = {}
        for i=1,#targetHeroList[1].m_tHitTargets do
            table.insert(spatterTargetList,(targetHeroList[1].m_tHitTargets[i]))
        end
        self.m_tSpatterTwoInfo = {activeAttackPos=CopyTable(targetHeroList[1].m_tActiveAttackPos[1]),spatterTargetList=spatterTargetList,count=#targetHeroList[1].m_tHitTargets,hurtSkillId=effectParm[5]}
    elseif effect == EffectTypeConfig.PET_CONTINUE_SHOOT then
        self.m_nPetAttackTimes = effectParm[5]
    elseif effect == EffectTypeConfig.FIRE_TOTEM then
        WZLog("BattleMsgSkillEffect:_doEffect EffectTypeConfig.FIRE_TOTEM",effectParm[5],effectParm[6],effectParm[7])
        local tmpBronPos = CopyTable(self.m_tOwner.m_tActiveAttackPos[1])
        local userAttack = self.m_tOwner:getAttack(true)--WBattleGlobal:getCurrent().m_tCharacterAttributeList[self.m_tOwner:getBattleId()] and WBattleGlobal:getCurrent().m_tCharacterAttributeList[self.m_tOwner:getBattleId()].atk

        self.m_tTreatTotemInfo = {battleId = self.m_tOwner:getBattleId() + 1000,templateId = effectParm[6],bronPos = tmpBronPos,charaId=targetHeroList[1]:getBattleId(), camp=targetHeroList[1]:getCamp(), userAttack = userAttack}
        self.m_tSummonMonsterId = {}
        self.m_tSummonMonsterBattleId = {}
        self.m_tSummonMonsterPositionX = {}
        self.m_tSummonMonsterPositionY = {}
        self.m_tOwner.m_tCursummonList = {}
        local count = effectParm[5]
        for i = 1,count,1 do
            local index = 5 + i
            local posIndex = 6 + count + (i - 1)*2
            local templateId = effectParm[index]
            WZLog("BattleMsgSkillEffect:_doEffect summon",index,posIndex)
            table.insert(self.m_tSummonMonsterId,templateId)
            table.insert(self.m_tSummonMonsterPositionX, tmpBronPos.x)
            table.insert(self.m_tSummonMonsterPositionY, tmpBronPos.y)
        end
    elseif effect == EffectTypeConfig.IGNORE_BUFF then
        WZLog("EffectTypeConfig.IGNORE_BUFF")
        local buffType = {}
        for i = 5, #effectParm do
            table.insert(buffType, effectParm[i])
        end
        local tempData = {type = effect, ignoreBuffType = buffType}
        self.m_tOwner:addImmunityPetSkill(self.m_nSkillId, tempData)
    elseif effect == EffectTypeConfig.CHANGE_WIND then
        if WBattleGlobal:getCurrent():isSingleStage() then 
            WndBattleHud:setWindData(self.m_nSkillId, effectParm)
        end
    elseif effect == EffectTypeConfig.GUARDIAN_TOTEM then
        WZLog("BattleMsgSkillEffect:_doEffect EffectTypeConfig.GUARDIAN_TOTEM",effectParm[5],effectParm[6],effectParm[7])
        local tmpBronPos = CopyTable(self.m_tOwner.m_tActiveAttackPos[1])
        local userAttack = self.m_tOwner:getAttack(true)--WBattleGlobal:getCurrent().m_tCharacterAttributeList[self.m_tOwner:getBattleId()] and WBattleGlobal:getCurrent().m_tCharacterAttributeList[self.m_tOwner:getBattleId()].atk

        self.m_tTreatTotemInfo = {battleId = self.m_tOwner:getBattleId() + 1000,templateId = effectParm[6],bronPos = tmpBronPos,charaId=targetHeroList[1]:getBattleId(), camp=targetHeroList[1]:getCamp(), userAttack = userAttack}
        self.m_tSummonMonsterId = {}
        self.m_tSummonMonsterBattleId = {}
        self.m_tSummonMonsterPositionX = {}
        self.m_tSummonMonsterPositionY = {}
        self.m_tOwner.m_tCursummonList = {}
        local count = effectParm[5]
        for i = 1,count,1 do
            local index = 5 + i
            local posIndex = 6 + count + (i - 1)*2
            local templateId = effectParm[index]
            WZLog("BattleMsgSkillEffect:_doEffect summon",index,posIndex)
            table.insert(self.m_tSummonMonsterId,templateId)
            table.insert(self.m_tSummonMonsterPositionX, tmpBronPos.x)
            table.insert(self.m_tSummonMonsterPositionY, tmpBronPos.y)
        end
    elseif effect == EffectTypeConfig.ADD_RANDOMBUFF then
        WZLog("BattleMsgSkillEffect:_doEffect seven-144")
        self.m_nAddBuffId = self.m_nAddBuffId or {}
        local buffId = BattleMethod:getRandomBuff(effectParm, self.m_tOwner:getBattleId())
        table.insert(self.m_nAddBuffId, buffId)
    elseif effect == EffectTypeConfig.FIX_WIND then
        if WBattleGlobal:getCurrent():isSingleStage() then 
            WndBattleHud:setWindData(self.m_nSkillId, effectParm)
        end
    elseif effect == EffectTypeConfig.DISPERSE_MONSTER_BY_TYPE then 
        WZLog("DISPERSE_MONSTER_BY_TYPE 00")
        self.m_tDisperseType = {}
        for i = 5, GetTableLen(effectParm) do
            table.insert(self.m_tDisperseType, effectParm[i])
        end
    elseif effect == EffectTypeConfig.EXTRA_HP then 
        self.m_nExtraHPValue = effectParm[5]
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
function BattleMsgSkillEffect:_changeAttribute(targetHeroList, skillType, isBuff ,param2)
    local tempChangeValueIndex = self.m_nChangeValueIndex
    local tempChangeValue = self.m_nChangeValue
    if skillType == EffectTypeConfig.CHANGE_ATTRIBUTE_VALUE and param2 and param2[1] and param2[2] then
        tempChangeValueIndex = param2[1]
        tempChangeValue = param2[2]
    end

    local tempChangeValueIndex2 = self.m_nChangePercentIndex
    local tempChangeValue2 = self.m_nChangePercent
    if skillType == EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT and param2 and param2[1] and param2[2] then
        tempChangeValueIndex2 = param2[1]
        tempChangeValue2 = param2[2]
    end

    WZLog("BattleMsgSkillEffect:_changeAttribute", targetHeroList, skillType, tostring(tempChangeValueIndex), tostring(tempChangeValueIndex2), tostring(tempChangeValue), tostring(tempChangeValue2))
    local Attribute = {}
    for i, v in pairs (AttributeConfig)do
        Attribute[v] = i
    end

    for i, hero in pairs (targetHeroList) do
        if isBuff == nil then
            if skillType == EffectTypeConfig.CHANGE_ATTRIBUTE_VALUE then
                if tempChangeValueIndex == AttributeConfig.HP then
                    local change = math.ceil(tempChangeValue) or 0
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

                elseif tempChangeValueIndex == AttributeConfig.PF then
                    WZLog("BattleMsgSkillEffect:_changeAttribute 2")
                    hero.m_nPF = hero.m_nPF + (tempChangeValue or 0)
                    hero:setPF(hero.m_nPF)
                elseif tempChangeValueIndex == AttributeConfig.SP then
                    WZLog("BattleMsgSkillEffect:_changeAttribute 3")
                    hero.m_nSP = hero.m_nSP + (tempChangeValue or 0)
                    hero:setSp(hero.m_nSP)
                else
                    hero.m_tAttributeChangeStateList["m_n"..Attribute[tempChangeValueIndex].."AddValue"] = {timeType=self.m_nChangeValueTimeType,timeValue=self.m_nChangeValueTimeValue,value=tempChangeValue}

                end

                if tempChangeValueIndex == AttributeConfig.BrokeRange then
                    WZLog("BattleMsgSkillEffect:_changeAttribute 7")
                    
                end
            elseif skillType == EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT then
                if tempChangeValueIndex2 == AttributeConfig.HP then
                    local change = math.ceil(hero:getMaxHp(true) * (tempChangeValue2 or 0)/10000)
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
                elseif tempChangeValueIndex2 == AttributeConfig.PF then
                    WZLog("BattleMsgSkillEffect:_changeAttribute 5")
                    hero.m_nPF = hero.m_nPF + (hero:getMaxPF(true) * (tempChangeValue2 or 0)/10000)
                elseif tempChangeValueIndex2 == AttributeConfig.SP then
                    WZLog("BattleMsgSkillEffect:_changeAttribute 6")
                    hero.m_nSP = hero.m_nSP + (100 * (tempChangeValue2 or 0)/10000)
                    hero:setSp(hero.m_nSP)
                else
                    hero.m_tAttributeChangeStateList["m_n"..Attribute[tempChangeValueIndex2].."AddPercent"] = {timeType=self.m_nChangeValueTimeType,timeValue=self.m_nChangeValueTimeValue,value=tempChangeValue2}
                    if self.m_tSkillConfig and self.m_tSkillConfig.skill_type == 4 then
                        hero:addImmunityPetSkill(self.m_nSkillId,{type = EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT, subType = tempChangeValueIndex2,param = tempChangeValue2})
                    end
                    WZLog("BattleMsgBossMapSkill:_changeAttribute 44", "m_n"..Attribute[tempChangeValueIndex2].."AddPercent", tempChangeValue2)
                end

                if tempChangeValueIndex == AttributeConfig.BrokeRange then
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
            elseif effect == EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT_HURT2 then
                if self.m_nChangeHurtPercentIndex == AttributeConfig.HP then
                    local value = self.m_tOwner.m_nCurRoundHurt2 > 0 and self.m_tOwner.m_nCurRoundHurt2 or 0--人物为宠物伤害，怪物为伤害总量
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
            elseif effect == EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT_HURT3 then
                if self.m_nChangeHurtPercentIndex == AttributeConfig.HP then
                    local value = self.m_tOwner.m_nCurRoundHurt3 > 0 and self.m_tOwner.m_nCurRoundHurt3 or 0--人物为宠物伤害，怪物为伤害总量
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
            local buffNew = BuffBody:new(buffInfo, hero, self.m_tOwner:getBattleId(), self.m_nSkillId)
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
                local immunizeList = WBattleGlobal:getCurrent():getImmunizeList()
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
            local petEquipImmunityAttr = hero:getPetEquipImmunityAttr(buffInfo.buff_type)
            if buffNew.m_nType == BuffType.SHAPE_NO_HOLE then
                hero:addImmunityPetSkill(self.m_nSkillId,{type = EffectTypeConfig.NO_HOLE})
                WZLog("BattleMsgBossMapSkill:_addBuff four", self.m_nSkillId)
            elseif offSkillId then
                BattlePetSkillManager:triggerPassiveSkillView(hero,offSkillId)
                offBuff = true
            elseif petEquipImmunityAttr > 0 then
                BattlePetSkillManager:triggerPetEquipSkillView(hero,petEquipImmunityAttr)
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

                        --解决多条1_1相同属性只读最后一个值问题
                        local param2 = nil
                        if effect == EffectTypeConfig.CHANGE_ATTRIBUTE_VALUE then
                            param2 = {}
                            param2[1] = self.m_nChangeValueIndex
                            param2[2] = self.m_nChangeValue
                        elseif effect == EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT then 
                            param2 = {}
                            param2[1] = self.m_nChangePercentIndex
                            param2[2] = self.m_nChangePercent
                        end

                        self:addStep(effect, {[1]=hero}, true, param2)
                    end
                end

                WndBattleHud:addBuffIcon(buffNew)
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
        --被动免疫
        if self.m_tOwner:getUseSkinBigSkill() and self.m_tOwner:getSkinBigSkill() == 3011 then 
            hero:setRepulse(self.m_nRepelFlyX/10, nil, self.m_tOwner:getFollowBulletSpeed())
        else
            local offSkillId = hero:getIsImmunityByPetSkill(1,skillType)
            if offSkillId then
                BattlePetSkillManager:triggerPassiveSkillView(hero,offSkillId)
            else
                local heroPos = hero:getAnimation():getPosition()
                if  heroPos.x > hurterPos.x then
                    WZLog("BattleMsgSkillEffect:_repelFly two", self.m_nRepelFlyX)
                    hero:setRepulse(self.m_nRepelFlyX/10, self.m_nRepelFlyY and self.m_nRepelFlyY/10 or nil)
                else
                    WZLog("BattleMsgSkillEffect:_repelFly three", self.m_nRepelFlyX)
                    hero:setRepulse(-1*self.m_nRepelFlyX/10, self.m_nRepelFlyY and self.m_nRepelFlyY/10 or nil)
                end
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
            for j=1, #self.m_tOwner.guaiId do
                if self.m_tSummonMonsterId[i] == self.m_tOwner.guaiId[j] then
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
    local devilOwnId = 0 
    if self.m_tOwner.guaiId ~= nil then 
        for j=1, #self.m_tOwner.guaiId do
            WZLog("BattleMsgSkillEffect:_getBattleIdBySummonIndex",v)
            if self.m_tSummonMonsterId[self.m_nSummonIndex] == self.m_tOwner.guaiId[j] then
                self.m_tSummonMonsterBattleId[self.m_nSummonIndex] = self.m_tOwner.guaiBattleId[j]
                devilOwnId = self.m_tOwner.devilOwnId[j] or 0
                table.remove(self.m_tOwner.guaiId, j)
                table.remove(self.m_tOwner.guaiBattleId, j)
                table.remove(self.m_tOwner.guaiPositionX, j)
                table.remove(self.m_tOwner.guaiPositionY, j)
                if self.m_tOwner.devilOwnId and self.m_tOwner.devilOwnId[j] then 
                    table.remove(self.m_tOwner.devilOwnId, j)
                end
                break
            end
        end
    end
    WZLog("BattleMsgSkillEffect:_getBattleIdBySummonIndex one---", self.m_nSummonIndex, #self.m_tSummonMonsterBattleId, #self.m_tSummonMonsterId, #self.m_tSummonMonsterPositionX, #self.m_tSummonMonsterPositionY)
    local battleId = self.m_tSummonMonsterBattleId[self.m_nSummonIndex] or -2
    WZLog("BattleMsgSkillEffect:_getBattleIdBySummonIndex two---",battleId,self.m_tSummonMonsterId[self.m_nSummonIndex])
    return battleId, devilOwnId
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
    local battleId, devilOwnId = self:_getBattleIdBySummonIndex()
    --单人副本创建小怪 为小怪添加battleId
    if WBattleGlobal:getCurrent():isSingleStage() and WBattleGlobal:getCurrent():getCopyData() then
        battleId = WBattleGlobal:getCurrent():getCopyData():getBuildGuaiIndex()
        WBattleGlobal:getCurrent():getCopyData():addBuildGuaiIndex()
    end
    local monster 
    WZLog("BattleMsgSkillEffect:_summonMonster", battleId, devilOwnId)
    if devilOwnId > 0 then 
        local monsterData = BossData["id_".. self.m_tSummonMonsterId[self.m_nSummonIndex]]
        if monsterData.AniFileId ~= -1 then  
            monster = WMonster:buildGuai(self.m_tSummonMonsterId[self.m_nSummonIndex],nil, true, battleId)
        else
            monster = WBattleGlobal:getCurrent():buildDevilGuai(devilOwnId, self.m_tSummonMonsterId[self.m_nSummonIndex], battleId)
            if monster then 
                monster.m_nDevilOwnId = devilOwnId
                WMonster:setDevilGuaiInfo(monster, self.m_tSummonMonsterId[self.m_nSummonIndex], battleId)
                WBattleGlobal:getCurrent().m_tGuais[battleId] = monster
            end
        end
    else
        monster = WMonster:buildGuai(self.m_tSummonMonsterId[self.m_nSummonIndex],nil, true, battleId)
    end
    --self:setGuaiInfo(monster, self.m_tSummonMonsterId[self.m_nSummonIndex])
    
    WZLog("BattleMsgSkillEffect:buildSummonMonster two", self.m_nSummonIndex, battleId, monster.m_sAniFileId, monster.m_nPlayerId, 
        monster.m_sPlayerName, monster.m_nLevel, monster.m_nRealLevel, monster.m_nCamp, monster.m_nMaxHP, 
        monster.m_nHP, monster.m_nPF, monster.m_nAttack, monster.m_nCriticalhitAttackRate, monster.m_nDefence, 
        monster.m_nInjuryFree, monster.m_nWreckDefense, monster.m_nReduceCrit, monster.m_nReduceBury, monster.m_nGuaiType)
    monster:setPosition(BattleCommon:getPointTable(self.m_tSummonMonsterPositionX[self.m_nSummonIndex],self.m_tSummonMonsterPositionY[self.m_nSummonIndex]))
    monster:getAnimation():getAnimNode():setAnchorPoint(monster:getSceneAnchorPoint())
    if WBattleGlobal:getCurrent():isSingleStage() or monster.m_nMonsterType ~= MonsterType.BOSS then
        if monster.setBoss then 
            monster:setBoss(self.m_tOwner)
            table.insert(self.m_tOwner.m_tOwnedMonsterList, monster)
        end
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
    elseif battleId > 0 and devilOwnId > 0 then 
        WZLog("BattleMsgSkillEffect:buildSummonMonster four", battleId, devilOwnId)
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

--@brief    将受伤的敌人向爆炸点聚拢一定距离
function BattleMsgSkillEffect:_gatherTogether(targetHeroList, skillType)
    WZLog("BattleMsgSkillEffect:_gatherTogether one", tostring(self.m_tOwner.m_bActiveAttack))
    
    for i, hero in pairs (targetHeroList) do
        --队友，地图不可爆破的模式没有聚拢效果
        --龙卷风，图腾，队友，地图不可爆破的模式没有聚拢效果
        if not WBattleGlobal:getCurrent():isSameTeam(hero:getId(), self.m_tOwner:getId()) and WBattleGlobal:getCurrent().m_bMapCanDigHole and (hero:getType() == 0 or hero:getType() == 1) and not hero:isDead() then 
            local heroPos = hero:getAnimation():getPosition()
            if self.m_tOwner.m_tActiveAttackPos ~= nil and #self.m_tOwner.m_tActiveAttackPos > 0 then 
                local attackDis = BattleCommon:pointDis(heroPos, self.m_tOwner.m_tActiveAttackPos[1])
                local tCurPos = {x = heroPos.x, y = heroPos.y}
                if attackDis <= self.m_nGatherDis then 
                    tCurPos = {x = self.m_tOwner.m_tActiveAttackPos[1].x, y = self.m_tOwner.m_tActiveAttackPos[1].y}
                else
                    local v = BattleCommon:pointSub(self.m_tOwner.m_tActiveAttackPos[1], heroPos)
                    local normalizeVec = BattleCommon:vectorNormalize(v)
                    local movePt = BattleCommon:pointMult(normalizeVec, self.m_nGatherDis)
                    tCurPos = BattleCommon:pointAdd(heroPos, movePt)
                end

                hero:setPosition(GlobalMethod:ccp(tCurPos.x, tCurPos.y))
            end
        end
    end
end

--@brief    普攻后碰撞触发的散射
function BattleMsgSkillEffect:_secondShoot()
    WZLog("BattleMsgSkillEffect:_secondShoot", self.m_tTwoShootInfo.count, self.m_tTwoShootInfo.hurtSkillId)
    if not self.m_bTwoShootInit then
        if self.m_tOwner:isCanControl() then
            ProtocolProcessorBattleInterface:send_BATTLE_SkillEquip(WBattleGlobal:getCurrent():getBattleId(), self.m_tOwner:getBattleId(), self.m_tTwoShootInfo.hurtSkillId)
        end
        
        local msg = MsgManager:createMsg(BattleMsgBossMapSkill)
        msg.m_nId = nil --不发协议
        msg.m_tOwner = self.m_tOwner
        msg.m_tSkillTypeList = {[1]=SkillTypeConfig.HIT_DO_EFFECT}
        msg.m_nSkillId = self.m_tTwoShootInfo.hurtSkillId
        msg.m_nTakeEffectType = TakeEffectType.USE
        msg.m_tSpatterAngle = self.m_tSpatterAngle
        msg.m_tCallBackFunc = {self._createBulletTwoShoot,self,self.m_tTwoShootInfo.count}
        MsgManager:pushNonBlockMsg(msg)

        self.m_bTwoShootDone = true
        self.m_bTwoShootInit = true
    end

    return self.m_bTwoShootDone
end

--@brief    创建散射射子弹
--@param    nScatterNum:溅射数量
function BattleMsgSkillEffect:_createBulletTwoShoot(nScatterNum)
    WZLog("BattleMsgSkillEffect:_createBulletTwoShoot")
    local msg = MsgManager:createMsg(BattleMsgSkillShow)
    msg.m_tOwner = self.m_tOwner
    msg.m_nSkillId = self.m_tTwoShootInfo.hurtSkillId
    msg.m_nTalkId = 0
    msg.m_tEndPos = self.m_tTwoShootInfo.pos
    msg.m_nScatterNum = nScatterNum
    MsgManager:pushNonBlockMsg(msg)

    self.m_bTwoShootDone = true
    return 
end

--@brief    普攻后碰撞触发的散射
function BattleMsgSkillEffect:_spatterTwo()
    WZLog("BattleMsgSkillEffect:_spatterTwo", self.m_tSpatterTwoInfo.count, self.m_tSpatterTwoInfo.hurtSkillId)
    if not self.m_bSpatterTwoInit then
        if self.m_tOwner:isCanControl() then
            ProtocolProcessorBattleInterface:send_BATTLE_SkillEquip(WBattleGlobal:getCurrent():getBattleId(), self.m_tOwner:getBattleId(), self.m_tSpatterTwoInfo.hurtSkillId)
        end
        
        local msg = MsgManager:createMsg(BattleMsgBossMapSkill)
        msg.m_nId = nil --不发协议
        msg.m_tOwner = self.m_tOwner
        msg.m_tSkillTypeList = {[1]=SkillTypeConfig.HIT_DO_EFFECT}
        msg.m_nSkillId = self.m_tSpatterTwoInfo.hurtSkillId
        msg.m_nTakeEffectType = TakeEffectType.USE
        msg.m_tSpatterAngle = self.m_tSpatterAngle
        msg.m_tCallBackFunc = {self._createBulletSpatterTwo,self,self.m_tSpatterTwoInfo.count}
        MsgManager:pushNonBlockMsg(msg)

        self.m_bSpatterTwoDone = true
        self.m_bSpatterTwoInit = true
    end

    return self.m_bSpatterTwoDone
end

--@brief    创建散射射子弹
--@param    nScatterNum:溅射数量
function BattleMsgSkillEffect:_createBulletSpatterTwo(nScatterNum)
    WZLog("BattleMsgSkillEffect:_createBulletSpatterTwo")
    local msg = MsgManager:createMsg(BattleMsgSkillShow)
    msg.m_tOwner = self.m_tOwner
    msg.m_nSkillId = self.m_tSpatterTwoInfo.hurtSkillId
    msg.m_nTalkId = 0
    msg.m_tActiveAttackPos = self.m_tSpatterTwoInfo.activeAttackPos
    msg.m_tSpatterTargetList = self.m_tSpatterTwoInfo.spatterTargetList
    msg.m_nScatterNum = nScatterNum
    MsgManager:pushNonBlockMsg(msg)

    self.m_bSpatterTwoDone = true
    return 
end

--@brief    改变宠物的攻击次数
function BattleMsgSkillEffect:_changePetAtkTimes()
    -- body
    local hero = self.m_tOwner
    
    hero.m_nPetAttackTimes = self.m_nPetAttackTimes
end

--@brief 申请战斗id
function BattleMsgSkillEffect:_requestMonsterId()
    WZLog("BattleMsgSkillEffect:_requestMonsterId", tostring(self.m_tOwner:isCanControl()))
    if not self.m_tSummonMonsterId then
         WZLog("BattleMsgSkillEffect:_requestMonsterId false")
        return true
    end

    if self.m_bIsSummon == nil then
        self.m_bIsSummon = true
        self.m_nBattleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
        self.m_nCurrentId = self.m_tOwner:getBattleId()


        if  self.m_tOwner:isCanControl() then
            WZLog("BattleMsgSkillEffect:_requestMonsterId two", self.m_nBattleId, self.m_nCurrentId, #self.m_tSummonMonsterId, #self.m_tSummonMonsterPositionX, self.m_tSummonMonsterPositionY)

            ProtocolProcessorBattleInterface:send_BATTLE_BuildGuai(self.m_nBattleId,  self.m_nCurrentId,
                                                                    self.m_tSummonMonsterId,
                                                                   self.m_tSummonMonsterPositionX, self.m_tSummonMonsterPositionY)
        else
            self.m_bClientSummon = true
        end

        if WBattleGlobal:getCurrent():isSingleStage() then
            self.m_bIsSummon = nil
            return true
        end
    end
    --客机使用召唤技能，等待battleId过程，转为可以控制的主机，发送召唤申请
    if not WBattleGlobal:getCurrent():isSingleStage() and self.m_bClientSummon and self.m_tOwner:isCanControl() then
        self.m_bClientSummon = nil
        WZLog("BattleMsgSkillEffect:_requestMonsterId two", self.m_nBattleId, self.m_nPlayerOrGuai, self.m_nCurrentId, #self.m_tSummonMonsterBattleId, #self.m_tSummonMonsterId, #self.m_tSummonMonsterPositionX, self.m_tSummonMonsterPositionY)

        ProtocolProcessorBattleInterface:send_BATTLE_BuildGuai(self.m_nBattleId,  self.m_nCurrentId,
                                                                self.m_tSummonMonsterId,
                                                               self.m_tSummonMonsterPositionX, self.m_tSummonMonsterPositionY)
    end

    if self.m_tOwner.guaiId ~= nil and #self.m_tOwner.guaiId > 0 then  
        self.m_bIsSummon = nil
        return true
    else
        WZLog("BattleMsgSkillEffect:_requestMonsterId wait")
        return false
    end
end

--@brief 创建火焰图腾
function BattleMsgSkillEffect:_buildFireTotem(monsterType)
    monsterType = monsterType or MonsterType.FIRE_TOTEM
    if not WBattleGlobal:getCurrent():isSingleStage() then
        --只创建一个 直接赋值
        for i=1,#self.m_tSummonMonsterId do
            for j=1, #self.m_tOwner.guaiId do
                if self.m_tSummonMonsterId[i] == self.m_tOwner.guaiId[j] then
                    self.m_tTreatTotemInfo.battleId = self.m_tOwner.guaiBattleId[j]
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
        self.m_tTreatTotemInfo.battleId = WBattleGlobal:getCurrent():getBuildGuaiBattleId(true)
    end
    WZLog("BattleMsgSkillEffect:_buildFireTotem", monsterType, Serialize(self.m_tTreatTotemInfo))
    local buffTotem = WBattleGlobal:getCurrent():buildMachine(monsterType, self.m_tTreatTotemInfo)
    SceneBattle:getFrontLayer():addChild(buffTotem.m_anim:getAnimNode())
end

--@brief 创建火焰图腾
function BattleMsgSkillEffect:_buildGuardianTotem()
    if not WBattleGlobal:getCurrent():isSingleStage() then
        --只创建一个 直接赋值
        for i=1,#self.m_tSummonMonsterId do
            for j=1, #self.m_tOwner.guaiId do
                if self.m_tSummonMonsterId[i] == self.m_tOwner.guaiId[j] then
                    self.m_tTreatTotemInfo.battleId = self.m_tOwner.guaiBattleId[j]
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
        self.m_tTreatTotemInfo.battleId = WBattleGlobal:getCurrent():getBuildGuaiBattleId(true)
    end
    WZLog("BattleMsgSkillEffect:_buildGuardianTotem", Serialize(self.m_tTreatTotemInfo))
    local buffTotem = WBattleGlobal:getCurrent():buildMachine(MonsterType.GUARDIAN_TOTEM,self.m_tTreatTotemInfo)
    SceneBattle:getFrontLayer():addChild(buffTotem.m_anim:getAnimNode())
end

--命运硬币加随机buff
function BattleMsgSkillEffect:_addRandomBuff()
    WZLog("BattleMsgSkillEffect:_addRandomBuff one", Serialize(self.m_nAddBuffId),self.m_tOwner:getBattleId(), self.m_nSkillId)

    for i, buffId in pairs (self.m_nAddBuffId) do
        local buffInfo = GDatatab_buff["id_"..buffId]
        local targetHeroList = WMonster:getRandomTeamPlayer(self.m_tOwner, buffInfo.onset_type)
        for id, hero in pairs (targetHeroList) do
            if hero:isDead() ~= true then
                if buffInfo.onset_type == 0 then 
                    BattleShowHeroUse:runUseAnim(hero, "devilCoin")
                else
                    BattleShowHeroUse:runUseAnim(hero, "angelCoin")
                end
                local buffNew = BuffBody:new(buffInfo, hero, self.m_tOwner:getBattleId(), self.m_nSkillId)
                local buffExistIndex = nil
                local buffExist = nil
                local offBuff = false
                local isShapeRecovery = false
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
                        table.insert(WBattleGlobal:getCurrent().m_tBuffAddSkillPlayerList, {actionTimes = hero.m_nActionTimes,round=round,playerId=hero:getBattleId(),buffId=buffId,userId=self.m_tOwner:getBattleId(),isMapBuff=buffNew.m_bIsMapBuff})
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
                        table.insert(WBattleGlobal:getCurrent().m_tBuffAddSkillPlayerList, {actionTimes = hero.m_nActionTimes,round=round,playerId=hero:getBattleId(),buffId=buffId,userId=self.m_tOwner:getBattleId(),isMapBuff=buffNew.m_bIsMapBuff})
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
                    local immunizeList = WBattleGlobal:getCurrent():getImmunizeList()
                    for id, effectParm in pairs (buffNew.m_nEffect) do
                        local effect = effectParm[3] .. "_" ..effectParm[4]
                        for id, effectType in pairs (immunizeList) do
                            if effect == effectType then
                                -- buffExist = buffNew
                                offBuff = true
                                WZLog("BattleMsgSkillEffect:_addRandomBuff offBuff", effectType)
                            end
                        end
                    end
                end

                if TeachGroup1.ISFIRSTBATTLE then
                    offBuff = true
                end

                --被动免疫
                local offSkillId = hero:getIsImmunityByPetSkill(0,buffInfo.buff_type)
                if buffNew.m_nType == BuffType.SHAPE_NO_HOLE then
                    hero:addImmunityPetSkill(self.m_nSkillId,{type = EffectTypeConfig.NO_HOLE})
                    WZLog("BattleMsgSkillEffect:_addRandomBuff four", self.m_nSkillId)
                elseif offSkillId then
                    BattlePetSkillManager:triggerPassiveSkillView(hero,offSkillId)
                    offBuff = true
                end

                WZLog("BattleMsgSkillEffect:_addRandomBuff two", hero:getBattleId(), tostring(offBuff))
                if not offBuff then
                    WZLog("BattleMsgSkillEffect:_addRandomBuff three-0", tostring(buffExistIndex), buffNew.m_nEffect)
                    
                    --添加buff叠加次数统计
                    if hero.m_tBuffAddTimes == nil then 
                        hero.m_tBuffAddTimes = {}
                    end
                    if hero.m_tBuffAddTimes[buffNew.m_nType] == nil then hero.m_tBuffAddTimes[buffNew.m_nType] = 0 end
                    WZLog("BattleMsgSkillEffect:_addRandomBuff three-1", hero.m_tBuffAddTimes[buffNew.m_nType], round)
                    if buffExistIndex and buffNew.m_nMaxAddNum > 1 then 
                        if hero.m_tBuffAddTimes[buffNew.m_nType] < buffNew.m_nMaxAddNum then
                            local round = WBattleGlobal:getCurrent().m_nTurnTimes
                            WBattleGlobal:getCurrent().m_tBuffAddSkillPlayerList = WBattleGlobal:getCurrent().m_tBuffAddSkillPlayerList or {}
                            table.insert(WBattleGlobal:getCurrent().m_tBuffAddSkillPlayerList, {actionTimes = hero.m_nActionTimes,round=round,playerId=hero:getBattleId(),buffId=buffId,userId=self.m_tOwner:getBattleId(),isMapBuff=buffNew.m_bIsMapBuff})
                            hero.m_tBuffAddTimes[buffNew.m_nType] = hero.m_tBuffAddTimes[buffNew.m_nType] + 1
                            tempSkillData = GDatatab_effect["id_" .. self.m_nSkillId]
                            local pos = hero:getAnimation():getPosition()
                            if hero.m_nHideOpecity == nil or hero.m_nHideOpecity ~= 0 then
                                BattleProfessionSkillManager:showUseName(BattleCommon:getPointTable(pos.x,pos.y + 85), tempSkillData.des, 2)
                            end

                            buffNew:addAnime()
                            if buffNew.m_nTimeIntervalValue == -1 then
                                for i,buffEffect in pairs (buffNew.m_nEffect) do
                                    self:_doEffectType(buffEffect,{[1]=hero},true)
                                    local effect = buffEffect[3] .. "_" ..buffEffect[4]
                                    self:addStep(effect, {[1]=hero}, true)
                                end
                            end

                            WndBattleHud:updateBuffAddTimes(buffNew)
                        end
                    else
                        local round = WBattleGlobal:getCurrent().m_nTurnTimes
                        WBattleGlobal:getCurrent().m_tBuffAddSkillPlayerList = WBattleGlobal:getCurrent().m_tBuffAddSkillPlayerList or {}
                        table.insert(WBattleGlobal:getCurrent().m_tBuffAddSkillPlayerList, {actionTimes = hero.m_nActionTimes,round=round,playerId=hero:getBattleId(),buffId=buffId,userId=self.m_tOwner:getBattleId(),isMapBuff=buffNew.m_bIsMapBuff})

                        if buffExistIndex then
                            buffExist:removeAnime()
                            hero.m_tBuffChangeStateList[buffExistIndex] = nil
                        end

                        if buffNew.m_nType == BuffType.SHAPE_RECOVERY and isShapeRecovery == false then
                            BattlePetSkillManager:triggerPassiveSkillView(hero,self.m_nSkillId)
                        end

                        if buffNew.m_nMaxAddNum > 1 then 
                            if hero.m_tBuffAddTimes[buffNew.m_nType] == nil then hero.m_tBuffAddTimes[buffNew.m_nType] = 0 end
                            hero.m_tBuffAddTimes[buffNew.m_nType] = hero.m_tBuffAddTimes[buffNew.m_nType] + 1
                            tempSkillData = GDatatab_effect["id_" .. self.m_nSkillId]
                            local pos = hero:getAnimation():getPosition()
                            if hero.m_nHideOpecity == nil or hero.m_nHideOpecity ~= 0 then
                                BattleProfessionSkillManager:showUseName(BattleCommon:getPointTable(pos.x,pos.y + 85), tempSkillData.des, 2)
                            end
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

                        WndBattleHud:addBuffIcon(buffNew)
                    end
                end
            end
        end
    end
end

--@brief    驱散指定类型的怪
function BattleMsgSkillEffect:_disperseMonsterByType()
    if self.m_tDisperseType == nil then return end 

    local targetMonsterList = {}
    local machineList = WBattleGlobal:getCurrent():getMachinesSortList()
    if machineList == nil or #machineList == 0 then return end 

    for i = 1, #machineList do
        if machineList[i]:isDead() ~= true and machineList[i].getMonsterType then 
            local monsterType = machineList[i]:getMonsterType()
            for j = 1, #self.m_tDisperseType do 
                if monsterType == self.m_tDisperseType[j] then 
                    table.insert(targetMonsterList, machineList[i])
                    break 
                end
            end
        end
    end

    for id, machine in pairs(targetMonsterList) do
        machine:doSuicide()
    end
end--@brief    设置额外生命
function BattleMsgSkillEffect:_setExtraHP(targetHeroList)
    if self.m_nExtraHPValue == nil then return end 

    for i, hero in pairs(targetHeroList) do
        local maxHP = hero:getMaxHp()
        local extraHp = math.ceil(maxHP * self.m_nExtraHPValue/10000)
        hero:setExtraHp(extraHp, true)
    end
end