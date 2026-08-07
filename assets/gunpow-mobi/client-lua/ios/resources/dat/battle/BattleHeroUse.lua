--BattleHeroUse.lua
--@brief    英雄使用道具技能管理
--@date     2014/01/23
--@author   Zjh
--@note		包括道具技能等使用

BattleHeroUse = {
	--ENUM
	--使用类型
	USE_SKILL = 1,
	USE_ITEM = 2,
	USE_BIGSKILL = 3,
	USE_FLY = 4,
	USE_SKILL_OR_ITEM = 5,		--技能/道具通用
	USE_TREASURE = 6,			--世界BOSS宝箱
	
	USE_SKILL_SUB = 7,			--技能
	USE_ITEM_SUB  = 8,			--道具
    USE_CTB = 9,                --使用ctb技能
    USE_GHOSTSKILL = 10,        --使用幽灵技能



    --TREASURE
    TREASURE_ATTACKUP_60 = 1,   --攻击+60%
    TREASURE_ATTACKUP_30 = 2,   --攻击+30%
    TREASURE_BLOOD = 3,         --恢复800点血
    TREASURE_INVINCIBLE = 4,    --无敌
    TREASURE_GOLDUP_100 = 5,    --金币+100
    TREASURE_GOLDUP_60 = 6,     --金币+60
    TREASURE_FROZEN = 7,        --冰冻BOSS
    TREASURE_ANGER = 8,         --怒气+50%
	
	--SKILL_SUB
	SKILL_SUB_ADDTIMES = 0,
	SKILL_SUB_DIVIDE = 1,
	SKILL_SUB_ATTACKUP = 2,
	
	SKILL_SUB_FROZEN = 3,
	SKILL_SUB_NBOMB = 4,
	SKILL_SUB_POUND = 5,
	
	--ITEM_SUB
	ITEM_SUB_ANGER = 7,
	ITEM_SUB_HIDE = 33,
	ITEM_SUB_HIDET = 35,
	ITEM_SUB_BLOOD = 0,
	ITEM_SUB_BLOODT = 1,
	ITEM_SUB_INVINCIBLE = 2,
	ITEM_SUB_FLY = 6,

    ITEM_FLY = 61,

    FLY_SKILL_ID = 62,

    ATK_SKILL_ID = 1001,
    PASS_SKILL_ID = 1002,

    BIG_SKILL_ID_START = 2010,
    BIG_SKILL_ID_END = 2004,

    HIDE_SKILL_ID_START = 33,
    HIDE_SKILL_ID_END = 121,

    HIDET_SKILL_ID_START = 35,
    HIDET_SKILL_ID_END = 141,

    ANGER_SKILL_ID_START = 31,
    ANGER_SKILL_ID_END = 101,

    BLOOD_SKILL_ID_START = 32,
    BLOOD_SKILL_ID_END = 111,
    BLOODT_SKILL_ID_START = 34,
    BLOODT_SKILL_ID_END = 131,

    BIG_SKILL_TYPE_I_ID_START = 2010,
    BIG_SKILL_TYPE_II_ID_START = 2020,
    BIG_SKILL_TYPE_III_ID_START = 2030,
    BIG_SKILL_TYPE_IV_ID_START = 3000,

    TEAM_BOSS_ITEM_A = 70005,
    TEAM_BOSS_ITEM_B = 70006,
    TEAM_BOSS_ITEM_C = 70007,
}

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	增加一个英雄使用
--@param	playerId:英雄Id
--@param	useType:使用类型
--@param	useId:道具或技能ID，其他则不需要填
--@param	bNotShowCell：是否不显示道具Cell
--@param    targetId : 技能的作用对象
--@param    ghostSkillId : 幽灵技能的唯一Id
--@param    ownPlayerId : 幽灵技能的释放者Id
--@return	bool,是否成功使用
--@note
function BattleHeroUse:heroUse(playerId,useType,useId,bNotShowCell,isTreasure,isFirst, targetId, ghostSkillId, ownPlayerId)

    local hero = WBattleGlobal:getCurrent():getCharacterWithId(playerId)

    WZLog("BattleHeroUse:heroUse one", tostring(WBattleGlobal:getCurrent():isAudience()), tostring(TeachGroup1.ISSKILL), tostring(hero:isCanControl()), tostring(playerId), tostring(useType), tostring(useId), tostring(bNotShowCell))
	if hero == nil then
		return false
	end

    -- if hero.m_nIsSpatter == true and useId >= 93 and useId <= 97 then
    --     return false
    -- end

    local myHero = WBattleGlobal:getCurrent():getMyHero()

	---[[

    if useType == BattleHeroUse.USE_BIGSKILL then
        if hero:getSp() < 100 then
            return
        end

        useId = hero.m_nBigSkillType
        WZLog("BattleHeroUse:heroUse one-1", useId)
    elseif useType == BattleHeroUse.USE_FLY then
        useId = BattleHeroUse.FLY_SKILL_ID
        WZLog("BattleHeroUse:heroUse one-2", useId)
    elseif useType == BattleHeroUse.USE_CTB then 
        if not WBattleGlobal:isReplayGame() and not WBattleGlobal:isAudience() then 
            useId = WBattleGlobal.getCurrent().m_nAwakeSkillId
        end
    end

    if useId >= BattleHeroUse.BIG_SKILL_TYPE_I_ID_START and useId < BattleHeroUse.BIG_SKILL_TYPE_IV_ID_START then
        useType = BattleHeroUse.USE_BIGSKILL
        WZLog("BattleHeroUse:heroUse one-3", useId)
    elseif useId == BattleHeroUse.FLY_SKILL_ID then
        useType = BattleHeroUse.USE_FLY
        WZLog("BattleHeroUse:heroUse one-4", useId)
    elseif useId == WBattleGlobal.getCurrent().m_nAwakeSkillId then
        useType = BattleHeroUse.USE_CTB
    end

     --战斗记录
    if WBattleGlobal:getCurrent():isSingleStage() and useId ~= nil then
       WBattleGlobal:getCurrent():setSkillIdRecord(useId)
    end

    if WBattleGlobal:getCurrent():canRecordGame() then
        --录像记录
        local replayParam = {}
        replayParam.playerId = playerId
        replayParam.useType = useType
        replayParam.useId = useId
        replayParam.bNotShowCell = bNotShowCell or false
        replayParam.isTreasure = isTreasure or false
        
        BattleMsgReplayGameRecord:setPlayerUse(replayParam)
    end
    

    if useId == BattleHeroUse.ATK_SKILL_ID or useId == BattleHeroUse.PASS_SKILL_ID then
        return false
    end
	--]]

	--道具效果处理
	if useType == BattleHeroUse.USE_BIGSKILL  then

		--if hero:getUseBigSkill()==false and hero:getId() == myHero:getId() then--and hero:getSp() >= 100 then
		if (hero:getUseBigSkill()==false and (hero:getSp() >= 100 or hero:getBattleId() ~= myHero:getBattleId() or WBattleGlobal:getCurrent():isAudience())) then
            WZLog("BattleHeroUse:heroUse USE_BIGSKILL")

            WBattleGlobal:getCurrent().m_nSkillBeUseCurRound = useId
            if WBattleGlobal:getCurrent():isSingleStage() then

                -- local guaiList = WBattleGlobal:getCurrent():getGuaiList()
                -- local turnTimes = WBattleGlobal:getCurrent().m_nTurnTimes
                -- local record = WBattleGlobal:getCurrent().m_tBattleRecord[turnTimes]

                -- if myHero:getId() == playerId then
                --     record.isPlayerBigSkill = true
                -- else
                --     local index = 0
                --     for i, v in pairs(guaiList) do
                --         index = index + 1
                --         if v:getId() == playerId then
                --             record.isGuaiBigSkill[index] = true
                --         end
                --     end
                -- end
            end
            SoundManager:playEffectSound(SoundDefine.E_S_CHOOSE_SKILL)

			hero:setUseBigSkill(true)

			hero:setSp(0)
            hero:addUseSkillTime(1)

		else
			return false
		end
    elseif useType == BattleHeroUse.USE_FLY then
        if hero:canUseFly() then
            hero:addUseSkillTime(1)
            BattleHeroUse:useFly(playerId)
            SoundManager:playEffectSound(SoundDefine.E_S_CHOOSE_SKILL)
        else
            return false
        end
	elseif useType == BattleHeroUse.USE_CTB then
        WndBattleHud:useMySkill(useId)
	else
        WZLog("BattleHeroUse:heroUse two",tostring(hero:isHide()))
		local useThing
		if useType == BattleHeroUse.USE_ITEM or useType == BattleHeroUse.USE_SKILL_OR_ITEM then
			useThing = WBattleGlobal:getCurrent():getItemById(useId)
            WZLog("BattleHeroUse:heroUse two-1",tostring(useThing))
			if useThing then
                if hero.m_nRemainUseItemCount ~= nil and hero.m_nRemainUseItemCount <= 0 then
                    return false
                elseif hero.m_nRemainUseItemCount ~= nil and hero.m_nRemainUseItemCount > 0 then
                    hero.m_nRemainUseItemCount = hero.m_nRemainUseItemCount - 1
                end

				useType = BattleHeroUse.USE_ITEM

			end
		end
		if useType == BattleHeroUse.USE_SKILL or useType == BattleHeroUse.USE_SKILL_OR_ITEM then
			useThing = WBattleGlobal:getCurrent():getSkillById(useId)
            WZLog("BattleHeroUse:heroUse two-2",tostring(useThing))
			if useThing then
				useType = BattleHeroUse.USE_SKILL
			end
		end
        if useType == BattleHeroUse.USE_GHOSTSKILL then 
            useThing = WBattleGlobal:getCurrent():getItemById(useId)
        end

		if useThing then
            WZLog("BattleHeroUse:heroUse three")
			if useType == BattleHeroUse.USE_SKILL then
				if hero:getUseSkillTime() >= 1 and isTreasure ~= true then
                    WZLog("BattleHeroUse:heroUse four")
					return false
				end

                WBattleGlobal:getCurrent().m_nSkillBeUseCurRound = useId
				hero:addUseSkillTime(1)

                if WBattleGlobal:getCurrent():isAudience() then
                    WndBattleHud:useMySkill(useId)
                end
			elseif  useType == BattleHeroUse.USE_ITEM then
				if hero:getUseItemTime() >= 1 and isTreasure ~= true then--or hero:getUseSkillTime() >= 1 then
                    WZLog("BattleHeroUse:heroUse five")
                    return false
				end
				hero:addUseItemTime(1)
                
                if useId == 61 then
                    hero:addUseSkillTime(1)
                end
            elseif useType == BattleHeroUse.USE_GHOSTSKILL then 
			end


			
            -- if WBattleGlobal:getCurrent():isSingleStage() and useId ~= nil then
            --     if myHero:getId() == playerId then
            --         local turnTimes = WBattleGlobal:getCurrent().m_nTurnTimes
            --         local record = WBattleGlobal:getCurrent().m_tBattleRecord[turnTimes]
            --         table.insert(record.skillProp, useId)
            --     end
            -- end


            if isTreasure ~= true and useType == BattleHeroUse.USE_SKILL then
                SoundManager:playEffectSound(SoundDefine.E_S_CHOOSE_SKILL)
            elseif isTreasure ~= true then
                SoundManager:playEffectSound(SoundDefine.E_S_CHOOSE_ITEM)
            end
		else
			WZLog("no such item/skill", tostring(BattleCommon:tableLen(WBattleGlobal:getCurrent().m_tSkillList)), tostring(useType), tostring(useId))
			return false
		end
	end

    if useId ~= nil then
        if (useId == BattleHeroUse.HIDE_SKILL_ID_START or (useId >= BattleHeroUse.HIDE_SKILL_ID_END and useId <= BattleHeroUse.HIDE_SKILL_ID_END + 3)) or (useId == BattleHeroUse.HIDET_SKILL_ID_START or (useId >= BattleHeroUse.HIDET_SKILL_ID_END and useId <= BattleHeroUse.HIDET_SKILL_ID_END + 3)) then
            --hero.m_bIsUseHide = true
        end
        if hero:isCanControl() and isTreasure ~= true then
            WZLog("HUHUHUHUHUUHU", type(ghostSkillId), ghostSkillId)
            ProtocolProcessorBattleInterface:send_BATTLE_SkillEquip(WBattleGlobal:getCurrent():getBattleId(), hero:getBattleId(), useId, targetId, nil, ghostSkillId)
            --93 1002
            -- ProtocolProcessorBattleInterface:send_BATTLE_SkillEquip(WBattleGlobal:getCurrent():getBattleId(), hero:getBattleId(), 93)
        end

        local skill = WBattleGlobal:getCurrent():getSkillById(useId)
        if skill == nil then
            skill = WBattleGlobal:getCurrent():getItemById(useId)
        end
        if useId == WBattleGlobal.getCurrent().m_nAwakeSkillId then
            skill = CopyTable(GDatatab_skill["id_" .. useId])
            local effectData = CopyTable(GDatatab_effect["id_" .. skill.effect_id[1][1]])
            skill.consumePower = -effectData.effect[1][5]

            WZLog("BattleHeroUse:heroUse ten", skill.consumePower)
        end

        if useId ~= BattleHeroUse.ATK_SKILL_ID and useId ~= BattleHeroUse.PASS_SKILL_ID then

            local useType = TakeEffectType.USE
            if isTreasure then
                useType = TakeEffectType.TREASURE
                --BattleCtbManager:addCtb(hero:getBattleId(),skill.consumePower)
            else
                if not hero:isDead() then 
                    useType = TakeEffectType.USE
                    BattleCtbManager:addCtb(hero:getBattleId(),skill.consumePower)
                end
            end
            if hero:getAI() then
                hero:getAI().m_bIsUseSkill = true
            end

            if TeachGroup1.ISSKILL then
                 WMonsterAI:castSkill(useId,
                     nil,
                     nil,
                     {[1]=SkillTypeConfig.EFFECT},
                     nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,nil,nil,nil,nil,nil,
                     nil,
                     nil,
                     nil,nil,
                     nil,nil,nil,nil,
                     nil,
                     nil,
                     useId, useType,
                     nil,
                     nil,
                     nil,
                     true
                     )
            else
                local skillData = GDatatab_skill["id_" .. useId]

                local msg = MsgManager:createMsg(BattleMsgBossMapSkill)
                msg.m_nId = useId --不发协议
                msg.m_tOwner = hero
                msg.m_tSkillTypeList = {[1]=SkillTypeConfig.EFFECT}
                msg.m_nSkillId = useId
                msg.m_nEffcetId = useId
                msg.m_nTakeEffectType = useType
                msg.m_bIsReplayMsg = true --结束标记
                msg.m_tTargetPlayerId = targetId
                msg.m_tOwnPlayerId = ownPlayerId
                if skillData and skillData.skill_type == 9 and isTreasure then 
                --    WZLog("PPPPPPPPPPPPPPPPP 0000")
                    MsgManager:pushNonBlockMsg(msg)
                else
                    if isTreasure then
                    --    WZLog("PPPPPPPPPPPPPPPPP 1111")
                        MsgManager:pushNonBlockMsg(msg)
                    else
                        WBattleGlobal:getCurrent().m_tCurRoundSkillId = WBattleGlobal:getCurrent().m_tCurRoundSkillId or {}
                        table.insert(WBattleGlobal:getCurrent().m_tCurRoundSkillId, useId)
                        MsgManager:pushBlockMsg(msg,isFirst and 2 or nil)
                    end
                end
            end

        end
        --return true
    end

    if TeachGroup1.ISBATTLE_MYTURN or ( hero:getHp() > 0 and not hero:isDead() and ( hero:isHide()==false or WBattleGlobal:getCurrent():isMyTeam(playerId) or WBattleGlobal:getCurrent():isReplayGame())) then
		BattleShowHeroUse:addHeroUse(playerId,useType,useId,bNotShowCell)
	else
		BattleShowHeroUse:removeHeroUse()
	end

	return true
end

--@brief	更新英雄使用
--@note		每回合调用
function BattleHeroUse:update()
	BattleShowHeroUse:removeHeroUse()
end

--@brief	清除英雄使用相关内存
function BattleHeroUse:clear()

	BattleShowHeroUse.m_tUseAnim = nil
end

--@brief	使用隐藏
--@param	nPlayerId,隐藏的玩家ID
--@param	nHideTime,隐藏的回合数
function BattleHeroUse:useHide(nPlayerId,nHideTime)
    WZLog("BattleHeroUse:useHide")
    do return end
	local hero = WBattleGlobal:getCurrent():getCharacterWithId(nPlayerId)
	hero:setNewHideTurn(nHideTime)
	if WBattleGlobal:getCurrent():isMyTeam(nPlayerId) then
		hero:getAnimation():getAnimNode():setOpacity(128)
		if hero:getPet() then
			hero:getPet():getAnimation():getAnimNode():setOpacity(128)
		end
		if hero.m_angerAnim then
			hero.m_angerAnim:getAnimNode():setOpacity(128)
		end

        if hero.m_frozenAnim ~= nil then
            hero.m_frozenAnim:getAnimNode():setOpacity(128)
        end

        if hero.m_tHurtAnim ~= nil then
            for i, v in pairs(hero.m_tHurtAnim) do
                v:getAnimNode():setOpacity(128)
            end
        end
	else
		hero:getAnimation():getAnimNode():setOpacity(0)
        if hero:getPlayerNameIcon() then
            hero:getPlayerNameIcon():setOpecity(0)
        end
		if hero:getPet() then
			hero:getPet():getAnimation():getAnimNode():setOpacity(0)
			-- hero:getPet():getAnimation():getAnimNode():setVisible(false)
		end
		if hero.m_angerAnim then
			hero.m_angerAnim:getAnimNode():setOpacity(0)
		end

        if hero.m_frozenAnim ~= nil then
            hero.m_frozenAnim:getAnimNode():setOpacity(0)
        end

        if hero.m_tHurtAnim ~= nil then
            for i, v in pairs(hero.m_tHurtAnim) do
                v:getAnimNode():setOpacity(0)
            end
        end
	end
end

--@brief	结束隐藏
--@param	nPlayerId,隐藏的玩家ID
function BattleHeroUse:endHide(nPlayerId)
	local hero = WBattleGlobal:getCurrent():getCharacterWithId(nPlayerId)
	hero:getAnimation():getAnimNode():setOpacity(255)
	if hero:getPlayerNameIcon() then
        hero:getPlayerNameIcon():setOpecity(255)
    end
	if hero:getPet() then
		hero:getPet():getAnimation():getAnimNode():setOpacity(255)
        if hero:getPet().m_tBackFire then
            hero:getPet().m_tBackFire:setVisible(true)
        end
		-- hero:getPet():getAnimation():getAnimNode():setVisible(true)
	end
	if hero.m_angerAnim then
		hero.m_angerAnim:getAnimNode():setOpacity(255)
	end

    if hero.m_tHurtAnim ~= nil then
        for i, v in pairs(hero.m_tHurtAnim) do
            v:getAnimNode():setOpacity(255)
        end
    end

    for id,buff in pairs (hero.m_tBuffChangeStateList) do
        if buff.m_tAnim then
            buff.m_tAnim:getAnimNode():setOpacity(255)
        end
        if buff.m_tAnimRange then
            buff.m_tAnimRange:getAnimNode():setOpacity(255)
        end
    end
    --幽灵目标选中框
    local spineMark = hero:getAnimation():getAnimNode():getChildByTag(1011)
    if spineMark then
        spineMark = WZUISpine:luaTo(spineMark)
        spineMark:setOpacity(255)
    end
end


--@brief	使用飞行
function BattleHeroUse:useFly(nPlayerId)
	local hero = WBattleGlobal:getCurrent():getCharacterWithId(nPlayerId)
	hero:setUseFly(true)
	hero:setWaitFlyTime(1)
end

--@brief	使用道具飞行
function BattleHeroUse:useItemFly(nPlayerId)
	local hero = WBattleGlobal:getCurrent():getCharacterWithId(nPlayerId)
	hero:setUseFly(true)
	hero:setUseItemFly(true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------



-------------------------------------私有方法模块End----------------------------------------
