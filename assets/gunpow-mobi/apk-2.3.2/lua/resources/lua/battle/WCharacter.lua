--WCharacter.lua
--@brief	基础战斗对象数据表
--@date		2013/12/24
--@author	李光森
--@note		战斗对象普遍属性及操作

--@brief	碰撞区域描述表
CollisionRang = {
	m_nType = 0,						--0:圆碰撞，1:矩形碰撞
	m_fRadius = 0,						--半径
	m_fWidth = 0,
	m_fWidth = 0,						--高
	m_fXOffset = 0,						--x偏移量
	m_fYOffset = 0,						--y偏移量
}

function CollisionRang:new()
	local rang = {}
	setmetatable(rang, {__index = self})
	rang.m_nType = 0
	rang.m_fRadius = 0
	rang.m_fWidth = 0
	rang.m_fHeight = 0
	rang.m_fXOffset = 0
	rang.m_fYOffset = 0
	return rang
end

BuffType = {
    BLOOD = 2,  --流血
    FROZEN = 4, --冰冻
    HIDE = 5,   --隐身
    SHIELD = 6,   --魔法盾
    POISON = 20, --中毒
    SILENT = 7, --沉默
    BIND = 8,   --束缚
    PETSEAL = 9, --封印
    REFLECT = 21, --反射
    REVERSE = 22, --逆转,颠倒
    TORNADO = 23, --龙卷
    MIST = 24,  --迷雾
    HIDE_VIEW = 27, --反隐
    
    SHAPE_BECRIT_RATE = 29, --幻化被暴击概率
    SHAPE_CRIT_HURT = 30, --幻化暴击伤害
    SHAPE_BE_CRIT_HURT = 31, --幻化被暴击伤害
    SHAPE_RECOVERY_PERCENT = 32, --幻化加血加成
    SHAPE_NO_HOLE = 33, --幻化免坑
    SHAPE_HURT = 34, --幻化加伤
    SHAPE_BEHURT = 35, --幻化被加伤
    SHAPE_RECOVERY = 36, --幻化回血
    SHAPE_CRIT_RATE = 37, --幻化暴击概率
    FROZEN_BOSS = 100, --boss冰冻
    BLOOD_BOSS = 101, --boss中毒
    BUFF_NO_HOLE = 38, --免坑
    HURT_BUFF_TOTEM = 39, --攻击图腾buff
    FIRE_TOTEM = 40, --火焰buff
    GUARDIAN_TOTEM = 44, --守护光环
    VULNERABLE_BULLET = 45, --易伤弹易伤
    CHAIN_BUFF = 52,        --连锁buff
    MARITIME1_TOTEM = 53,        --召唤海洋领域增益
    MARITIME3_TOTEM = 54,        --召唤海洋领域减益扣血
    JIANGZIYA_TOTEM = 55,        --姜子牙
    UMBRELLA1_TOTEM = 56,         --执伞圣女 回血
    BANISH = 71,                   --放逐
    RECOVERY_BUFF_ARRAY = 1008, --法阵加血buff
}

BuffBody = {
	m_nID = 0,
	m_nLv = 0,
	m_nType = 0,
	m_nEffectType = 0, --0增益,1损益
	m_nTakeEffectType = 0, --0战斗内,1战斗外,2从外获得的内生效的
	m_nUpdateRuleSameLv = 0, --0增加,1覆盖,2叠加
	m_nUpdateRuleHighLv = 0,
	m_nCanRemove = 0, --是否驱散:0是,1否
	m_nTimeType = 0,
	m_nTimeValue = 0,
	m_nEffectId = 0,
	m_nEffect = {},

	m_nGetText = 0,
	m_nGetSound = 0,
	m_nIngAni = 0,
	m_nIngIcon = 0,
	m_nOutText = 0,
	m_nOutSound = 0,
    m_sAnimState = nil,
    m_tStartActions = nil,
    m_tActions = nil,
    m_bIsLoop = false,
    m_tUser = nil,
    m_nUserAttack = 0,
    m_bIsMapBuff = false,
    m_sName = "",
    m_sDesc = "",
    m_nVisible = 1,
}

function BuffBody:new(info, owner, user, skillId, duration)
	local buffBody = {}
	setmetatable(buffBody, {__index = self})
    buffBody.m_nTurnTime = WBattleGlobal:getCurrent().m_nTurnTimes
	buffBody.m_tOwner = owner
    buffBody.m_tUser = user
    buffBody.m_nUserAttack = WBattleGlobal:getCurrent().m_tCharacterAttributeList[user] and WBattleGlobal:getCurrent().m_tCharacterAttributeList[user].atk or info.buffAtk
	buffBody.m_nID = tonumber(info and info.id) or 0
	buffBody.m_nLv = tonumber(info and info.buff_level) or 0
	buffBody.m_nType = tonumber(info and info.buff_type) or 0
	buffBody.m_nEffectType = tonumber(info and info.onset_type) or 0 --0损益,1增益
	buffBody.m_nCanRemove = tonumber(info and info.disperse) or 0 --是否驱散:0是,1否
	buffBody.m_nTimeIntervalValue = tonumber(info and info.interval) or 0
	buffBody.m_nTimeDurationValue = duration or tonumber(info and info.duration) or 0
	buffBody.m_nTimePassValue = 0
	buffBody.m_nTimePassValueReal = 0
	buffBody.m_nTakeEffectCount = 0
	buffBody.m_nTakeEffectCountReal = 0
	buffBody.m_nEffectId = tonumber(info and info.effect_id) or 0
    buffBody.m_nSkillType = -1
    if skillId and skillId > 0 then 
        local tTempSkillData = GDatatab_skill["id_" .. skillId]
        if tTempSkillData then 
            buffBody.m_nSkillType = tTempSkillData.skill_type
        end
    end
    if info.effect_id > 0 then
	   local effectInfo = GDatatab_effect["id_"..buffBody.m_nEffectId].effect
	   buffBody.m_nEffect = effectInfo
	   WZLog("buffBody.m_nEffect = ", Serialize(buffBody.m_nEffect))
    else
        buffBody.m_nEffect = {}
    end

    
    buffBody.m_nVisible = info and info.visible or 0
    buffBody.m_sName = info and info.buff_name or ""
    buffBody.m_sDesc = info and info.buff_remark or ""
	buffBody.m_nGetText = info and info.x or 0
	buffBody.m_nGetSound = info and info.x or 0
	buffBody.m_nIngAni = info and info.buff_effect or 0
	buffBody.m_nIngIcon = info and info.buff_icon or 0
	buffBody.m_nOutText = info and info.x or 0
    buffBody.m_nOutSound = info and info.x or 0
    buffBody.m_bIsMapBuff = (info and info.isMapBuff and info.isMapBuff == 1) or false
	buffBody.m_nMaxAddNum = info and info.add_num or 1

    buffBody.m_nAddInCTBTime = BattleCtbManager.m_nTotalCTB_time
    WZLog("BuffBody:new", buffBody.m_tUser, buffBody.m_nUserAttack,buffBody.m_nAddInCTBTime)
    if tonumber(info and info.buff_type) then 
        local tempBuffInfo = GDatatab_buff["id_"..buffBody.m_nID]
        WZLog("BuffBody:new yyy", tempBuffInfo and tempBuffInfo.buff_type, info.buff_type)
        if tempBuffInfo == nil or tempBuffInfo.buff_type ~= info.buff_type or g_tHideBuffIdList == nil or #g_tHideBuffIdList ~= 34 or (utilsValueInTable(buffBody.m_nID, g_tHideBuffIdList) and (tempBuffInfo.buff_type ~= 5 or tempBuffInfo.buff_effect ~= 204)) then 
            --踢下线
            ProtocolProcessorSceneBattle:send_BATTLE_PlayerOffLine(WBattleGlobal:getCurrent():getBattleId(), 0)
        end
    end
	--buffBody:addAnime()
	return buffBody
end

function BuffBody:updateStateByAddBuff()
     --激光炮
    if self.m_tOwner.m_nMonsterType == MonsterType.BOSS_LASER then
        self.m_tOwner:updateStateByAddBuff()
    -- 副本4无敌效果
    elseif self.m_tOwner:getType() == 1 and self.m_nID == 7004 then
        if math.floor(WBattleGlobal:getCurrent().m_tMakePairOk.mapId / 100) == 204 then
            self.m_tOwner:HideRealBloodView()
        end
    --副本7 暴怒buff
    elseif self.m_tOwner:getType() == 1 and (self.m_nID == 7006 or self.m_nID == 7007) then
        if math.floor(WBattleGlobal:getCurrent().m_tMakePairOk.mapId / 100) == 208 then
            if self.m_nID == 7006 then
                self.m_tOwner.m_nBuffAnimState = 2
            else
                self.m_tOwner.m_nBuffAnimState = 3
            end
        end
        self.m_tOwner:getAnimation():play(self.m_tOwner:getNormalAnimationName(), true)
     --副本8 暴怒buff
    elseif self.m_tOwner:getType() == 1 and self.m_nID == 7009 then
        if math.floor(WBattleGlobal:getCurrent().m_tMakePairOk.mapId / 100) == 209 then
            self.m_tOwner.m_nBuffAnimState = 2
        end
        self.m_tOwner:getAnimation():play(self.m_tOwner:getNormalAnimationName(), true)
    --副本9 飞行buff
    elseif self.m_tOwner:getType() == 1 and self.m_nID == 9011 then
        if math.floor(WBattleGlobal:getCurrent().m_tMakePairOk.mapId / 100) == 210 then
            self.m_tOwner.m_nBuffAnimState = 2
        end
        self.m_tOwner:getAnimation():play(self.m_tOwner:getNormalAnimationName(), true)
        self.m_tOwner:setMapCollision(false)
        self.m_tOwner:getAnimation():getAnimNode():setRotation(0)
    --副本10 暴怒buff
    elseif self.m_tOwner:getType() == 1 and self.m_nID == 7015 then
        if math.floor(WBattleGlobal:getCurrent().m_tMakePairOk.mapId / 100) == 211 then
            self.m_tOwner.m_nBuffAnimState = 2
        end
        self.m_tOwner:getAnimation():play(self.m_tOwner:getNormalAnimationName(), true)
    end


end

function BuffBody:addAnime(isProceed)
    if self.m_bIsMapBuff then
        return
    end
    BattleBuffMethod:addBuffEffect(self.m_tOwner,self)

    self:updateStateByAddBuff()

	WZLog("BuffBody:addAnime-0",self.m_nIngAni)
    if self.m_nType == BuffType.MIST then
        --非单人副本怪物boss过滤致盲特效
        if self.m_tOwner:getType() == 1 and self.m_tOwner.m_nMonsterType == MonsterType.BOSS and WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS and not WBattleGlobal:getCurrent():isSingleStage() then
            return
        end

        if (not self.m_tOwner.m_mistMask) and self.m_tOwner:getBattleId() == WBattleGlobal:getCurrent():getMyBattleId() then
            -- self.m_tOwner.m_mistMask = WZUIContainer:create()
            -- self.m_tOwner.m_mistMask:setUseAbsCoordinate(true)
            -- -- self.m_tOwner:setUseAbsSize(true)
            -- -- self.m_tOwner:setAbsContentSize(CCSizeMake(500,120))
            -- local img = WZUIImage:create()
            -- img:setUseOriginSize(true)
            -- img:setFile("armatures/battle/skill/skill_zm_black_00.png")
            -- -- SceneBattle:getClipLayer():setStencil(self.m_tOwner.m_mistMask)
            -- self.m_tOwner.m_mistMask:addChild(img)
            -- img:setScale(10)
            -- SceneBattle:getInfoLayer():addChild(self.m_tOwner.m_mistMask,1000)
        end
   
        --self.m_tOwner:getAnimation():getAnimNode():addChild(anim:getAnimNode(),zOrder)

        --return
    end

    if self.m_nType == BuffType.PETSEAL then 
        if not self.m_tOwner:getPet() then 
            return 
        end
    end
	if self.m_nIngAni == -1 then return end
	local buffAnim = GDatatab_EffectInfoConfig["id_"..self.m_nIngAni]
    if not buffAnim then
        return
    end

    --isProceed = true
    if buffAnim.source ~= -1 and buffAnim.actions ~= -1 then
        local animName = buffAnim.source
        
        --扫描buff动画特殊处理
        if self.m_nType == BuffType.HIDE_VIEW then
            if not WBattleGlobal:getCurrent():isMyTeam(self.m_tOwner:getBattleId()) then
                animName  =animName .."2"
            end
        end

        local isNewAnime = (buffAnim.isArmature == 1)
        local x,y = self.m_tOwner:getAnimation():getAnimNode():getContentSize().width/2 + buffAnim.offsetX + (self.m_tOwner.m_nBuffAnimOffsetX or 0),buffAnim.offsetY + (self.m_tOwner.m_nBuffAnimOffsetY or 0)
        
        WZLog("BuffBody:addAnime-1", self.m_tOwner:getBattleId(), tostring(self.m_tOwner.m_nBuffAnimOffsetY), buffAnim.source, tostring(isNewAnime), tostring(isProceed),x,y)
        local anim = BattleAnimation:createAnimation(animName,isNewAnime)
        anim:getAnimNode():setScaleY(buffAnim.scaleX / 100)
        anim:getAnimNode():setScaleX(buffAnim.scaleY / 100)


        if isProceed == true then
            self:removeAnime()
        end

        if false and isNewAnime ~= true then
            anim:getAnimNode():setAbsPosition(GlobalMethod:ccp(x ,y))
            anim:getAnimNode():setAnimationName(buffAnim.actions)
            anim:getAnimNode():setLoop(buffAnim.isLoop == 1)
        end

        local zOrder = 0
        if self.m_nType == BuffType.POISON then
            zOrder = 1
        elseif self.m_nType == BuffType.BLOOD or self.m_nType == BuffType.BLOOD_BOSS then
            zOrder = 2
        elseif self.m_nType == BuffType.REFLECT then
            zOrder = 3
        elseif self.m_nType == BuffType.SHIELD then
            zOrder = 5
        elseif self.m_nType == BuffType.REVERSE then
            zOrder = 6
        elseif self.m_nType == BuffType.SILENT then
            zOrder = 7
        end
        -- if self.m_nType == BuffType.MIST then
        --     if not self.m_tOwner.m_mistMask then
        --         self.m_tOwner.m_mistMask = WZUIContainer:create()
        --         self.m_tOwner.m_mistMask:setUseAbsCoordinate(true)
        --         -- self.m_tOwner:setUseAbsSize(true)
        --         -- self.m_tOwner:setAbsContentSize(CCSizeMake(500,120))
        --         local img = WZUIImage:create()
        --         img:setUseOriginSize(true)
        --         img:setFile("armatures/battle/skill/skill_zm_black_00.png")
        --         -- SceneBattle:getClipLayer():setStencil(self.m_tOwner.m_mistMask)
        --         self.m_tOwner.m_mistMask:addChild(img)
        --         img:setScale(10)
        --         SceneBattle:getInfoLayer():addChild(self.m_tOwner.m_mistMask,1000)
        --     end
        --     -- SceneBattle:getClipLayer():addChild(anim:getAnimNode(),10)
        -- else
        --     self.m_tOwner:getAnimation():getAnimNode():addChild(anim:getAnimNode(),zOrder)
        -- end
        if self.m_nType == BuffType.PETSEAL then 
            self.m_tOwner:getPet():getAnimation():getAnimNode():addChild(anim:getAnimNode(),zOrder)
        else
            self.m_tOwner:getAnimation():getAnimNode():addChild(anim:getAnimNode(),zOrder)
        end

        --扫描加范围
        if self.m_nType == BuffType.HIDE_VIEW then
            local animRange = BattleAnimation:createAnimation(animName,isNewAnime)
            self.m_tOwner:getAnimation():getAnimNode():addChild(animRange:getAnimNode(),zOrder)
            animRange:play("fanwei_chuxian",false)
            local heroScale = BattleConstants.g_heroScale
            local scale = self.m_tOwner.m_nHideViewDis/500/heroScale
            animRange:getAnimNode():setScale(scale)
            self.m_tAnimRange = animRange
        end

        if true or isNewAnime then
            anim:getAnimNode():setPosition(GlobalMethod:ccp(x,y))
        end

        if self.m_tOwner:isHide() == true then
            local isShow = false
            if WBattleGlobal:getCurrent():isReplayGame() or WBattleGlobal:getCurrent():isMyTeam(self.m_tOwner:getBattleId()) then
                isShow = true
            end
            --在反隐范围内(玩家自己)
            local myHero = WBattleGlobal:getCurrent():getMyHero()
            if myHero.m_nHideViewDis and BattleCommon:pointDis(self.m_tOwner:getPosition(),myHero:getPosition()) <= myHero.m_nHideViewDis then
                isShow = true
            end
            if isShow then
                anim:getAnimNode():setOpacity(128)
                if self.m_tAnimRange then
                    self.m_tAnimRange:getAnimNode():setOpacity(128)
                end
            else
                anim:getAnimNode():setOpacity(0)
                if self.m_tAnimRange then
                    self.m_tAnimRange:getAnimNode():setOpacity(0)
                end
            end
        end
        self.m_tStartActions = buffAnim.start_actions
        self.m_tActions = buffAnim.actions
        self.m_bIsLoop = buffAnim.isLoop == 1
        if buffAnim.start_actions ~= -1 and isProceed == nil then
            self.m_sAnimState = "start"
            anim:play(buffAnim.start_actions,false)
        elseif true or isNewAnime then
            self.m_sAnimState = "proceed"
            anim:play(buffAnim.actions,buffAnim.isLoop == 1)
        end
        anim:getAnimNode():setPosition(GlobalMethod:ccp(x,y))
        self.m_tAnim = anim
        if self.m_nSkillType == 7 then 
            anim:getAnimNode():setVisible(false)
        end
    end

    --怪物对白
    if self.m_nType == BuffType.POISON then
        self.m_tOwner:showMonsterDialog300x(3004)
    elseif self.m_nType == BuffType.BLOOD then
        self.m_tOwner:showMonsterDialog300x(3005)
    end
end

function BuffBody:removeAnime()
	WZLog("BuffBody:removeAnime")
    WndBattleHud:removeBuffIcon(self)
    if self.m_tOwner.m_tBuffAddTimes and self.m_tOwner.m_tBuffAddTimes[self.m_nType] and self.m_tOwner.m_tBuffAddTimes[self.m_nType] > 0 then
        --叠加了多次就要执行移除多次效果
        for i = 1, self.m_tOwner.m_tBuffAddTimes[self.m_nType] do
            BattleBuffMethod:removeBuffEffect(self.m_tOwner,self)
        end
        self.m_tOwner.m_tBuffAddTimes[self.m_nType] = 0
    else
        BattleBuffMethod:removeBuffEffect(self.m_tOwner,self)
    end

    -- 回光返照buff到期使人物死亡
    if self.m_nType == 101001 then
        if self.m_nTimeDurationValue ~= -1 and self.m_nTimePassValue >= self.m_nTimeDurationValue then --buff时间到
            if WBattleGlobal:getCurrent():isSingleStage() then
                self.m_tOwner:setDead(true)
            end
        end
    end

    if self.m_tAnim and self.m_tAnim.getAnimNode and self.m_tAnim:getAnimNode().removeFromParentAndCleanup then
        self.m_tAnim:getAnimNode():removeFromParentAndCleanup(true)
        self.m_tAnim = nil
    end
    if self.m_nType == BuffType.MIST and self.m_tOwner.m_mistMask then
       -- SceneBattle:clearClipLayer()
       self.m_tOwner.m_mistMask:removeFromParentAndCleanup(true)
       self.m_tOwner.m_mistMask = nil
    end
    if self.m_tAnimRange and self.m_tAnimRange.getAnimNode and self.m_tAnimRange:getAnimNode().removeFromParentAndCleanup then
        self.m_tAnimRange:getAnimNode():removeFromParentAndCleanup(true)
        self.m_tAnimRange = nil
    end
end

--@brief	运行状态
RunStatus = {
	DEF_ST_NORMAL = 0, 					--待机
	DEF_ST_MOVE = 1, 					--移动
	DEF_ST_FLY = 2, 					--飞行
	DEF_ST_READY_SHOOT = 3, 			--准备射击
	DEF_ST_REPEAT_SHOOT = 4,			--循环射击
	DEF_ST_SHOOT = 5,					--射击完毕
	DEF_ST_NONE = -1, 					--空的状态,用于转换状态时
}

--@brief	对象类型
CharacterType = {
	TYPE_HERO = 0, 					--英雄
    TYPE_GUAI = 1,                  --怪物
	TYPE_KID = 2, 					--孩子
}
--@brief	临时状态
WCharacterTmpState = {
	READY_SKILL = "readySkill",
}

--@brief	角色数据表
WCharacter = {
	m_nCharaType = nil,					--对象类型(CharacterType)
	m_tAI = nil,						--使用的AI表
	m_bLoseNet = false, 				--玩家已经掉线
	m_nDt = 0, 							--时间保存，方便读取
	m_bIsInit = false, 					--是否已初始化
	m_bIsExist = nil,					--是否存在的标记
    m_bIsGuaiWithSuit = false,          --是否穿着装的怪物
    m_nGuaiType = nil,                  --怪物类型 1:小怪 2:boss
    
	--@brief 基本属性
	m_nRoomId = 0, 						--原来房间id
	m_nPlayerId = 0, 					--当前角色id
	m_nBattleId = 0, 					--对战id
	m_sPlayerName = "", 				--角色名称
	m_nLevel = 0, 						--角色等级
	m_nBoyOrGirl = 0, 					--男还是女
	m_nCamp = 0, 						--属于哪一方
	m_nCampPosition = 0,				--队伍排列
    professionId = 0,                   --职业
	
	m_nMaxSP = 0, 						--最大怒气值
	m_nCtrlType = 0, 					--控制类型 0:自己 1:别人 2:AI
	m_sTitle = "", 						--称号
	m_sCommunity = "", 					--公会名称
	m_nZSLevel = 0,						--转生等级
    m_nRealLevel = 0,                   --没经过转生换算的等级

    --@brief 技能改变属性
    m_bIsUseSkill = nil,
    m_nWeaponId = nil,
    m_fRadiusForBulletExplodeChange = nil,--子弹爆炸半径
    m_fRadiusForBulletExplode = 200,		--子弹爆炸半径
    m_fRadiusForBulletExplodeRate = 1,      --子弹爆炸半径系数

    m_fRectForBulletExplodeBombChange = nil,--子弹爆炸半径
    m_fRectForBulletExplodeBomb = {x=200,y=100},	--子弹爆炸半径
    m_fRectForBulletExplodeBombRate = {x = 1,y = 1}, --子弹爆炸半径系数

    m_tSkillCdList = nil,				--技能CD列表
    m_tItemCdList = nil,               --道具CD列表
    m_tAttributeChangeStateList = nil,
    m_tBuffAttributeChangeStateList = nil,
    m_tBuffChangeStateList = nil,
    m_nUseSkillState = nil,				--使用技能的状态
    m_tSkillTakeEffectList = nil,		--技能已生效的玩家列表
    m_tSkillTakeEffectInfo = nil,		--技能生效信息
    m_tSkillTakeEffectIndex = nil,

    m_nCriticalhitAttack = 0, 			--爆击攻击
    m_nReduceCrit = 0,					--免暴
    m_nCritProbability = 0,             --爆击攻击概率
    m_nReduceCritRate = 0,              --被暴击概率
    m_nHP = 0, 							--生命值
    m_nPF = 0, 							--体力
    m_nSP = 0, 							--怒气值
    
	m_nMaxHP_bak = 0,					--技能改变单位最大生命值时保存备用值
    m_nMaxHP = 0, 						--最大生命值
    m_nAttack = 0, 						--普通攻击力
    m_nDefence = 0, 					--防御力
    m_nCriticalhitAttackRate = 0, 		--爆击攻击倍率
    m_nReduceCritRate = 0,				--免暴
    m_nMaxPF = 0, 						--最大体力
    m_nSPChange = 0, 					--怒气值
    m_nBrokeRange = nil,				--爆破范围

    m_nMaxHPAddPercent = 0, 			--最大生命值
    m_nMaxHPAddValue = 0, 				--最大生命值
    
    m_nAttackAddPercent = 0, 			--普通攻击力
    m_nAttackAddValue = 0,              --普通攻击力
    
    m_nDefenceAddPercent = 0, 			--防御力
    m_nDefenceAddValue = 0, 			--防御力
    
    m_nCriticalhitAttackRateAddPercent = 0, --爆击攻击倍率
    m_nCriticalhitAttackRateAddValue = 0, 	--爆击攻击倍率
    
    m_nReduceCritRateAddPercent = 0,	--免暴
    m_nReduceCritRateAddValue = 0,		--免暴
    
    m_nMaxPFAddPercent = 0, 			--最大体力
    m_nMaxPFAddValue = 0, 				--最大体力
    
    m_nSPChangeAddPercent = 0, 			--怒气值
    m_nSPChangeAddValue = 0, 			--怒气值
    
    m_nBrokeRangeAddPercent = 0,		--爆破范围
    m_nBrokeRangeAddValue = 0,		--爆破范围

    m_nRepulseDis = nil,                --是否被击退

    m_nHurtChangeValue = 0,			--打出去的伤害改变
    m_nHurtAddPercent = 0,			--打出去的伤害改变
    m_nHurtAddValue = 0,				--打出去的伤害改变

    m_nHurtEnemyAddPercent = nil,       --打敌人的伤害改变
    m_nHurtTeammateAddPercent = nil,    --打对友的伤害改变

    m_nBeHurtChangeValue = 0,			--被打的伤害改变
    m_nBeHurtAddPercent = 0,			--被打的伤害改变
    m_nBeHurtAddValue = 0,			--被打的伤害改变

	m_nAttTimes = 1,					--攻击次数,正常为1
	m_nAttScatterNum = 1,				--散射子弹数,正常为1
	m_nHideTurn = 0,					--隐藏回合
	m_nBuffInvincibleRound = 0,		--无敌回合数
    m_nFreezeCTB = 0,
    m_nNowCTB = 0,
    m_nFateCritRate = 0,                --命运暴击概率（轮回审批共生技添加的新属性）192版本
    m_nFateCrit = 0,                    --命运暴击倍数（轮回审批共生技添加的新属性）
    m_nFate_Hurt_FZ = 0,                --命运伤害反转万分比（轮回审批共生技添加的新属性）

	--@brief 武力属性

	m_nCriticalhitAttackRate = 0, 		--暴击攻击倍率
	
    m_nPower = 0,                       --力量
    m_nArmor = 0,                       --护甲
    m_nFighting = 2000,                    --战斗力
    m_nWinRate = 50,                     --胜率
    m_nConstitution = 0,                --体质
    m_nAgility = 0,                     --敏捷
    m_nLucky = 0,                       --幸运
    m_nInspire = 0,                     --鼓舞
    m_nAddAttackValue = 0,

	m_nWreckDefense = 0,				--破防值
	m_nInjuryFree = 0,					--免伤
	
	m_nReduceBury = 0,					--免坑
	m_nBigSkillType = 0, 				--大招类型
    m_nAddCriticalHitProbability = 0,   --被动技能暴击

	m_fAttPercent = nil,				--攻击威力比例值,正常为100

	m_bCanFrozen = nil,					--是否带冰冻效果
	m_bCanFollow = nil,					--是否带追踪功能
    m_bCanPenetrate = nil,               --是否带穿透
	m_sTmpState = nil,              	--临时状态记录

	--@brief 基本动态属性

	
	
	m_bIsDead = false, 					--死了吗
	m_nHurtType = 0,					--0:普通，1:暴击，2:超暴击

	--@brief 宠物信息
	--[[{
		petId=nil,						--宠物ID(0:没有宠物)
		petProbability=nil, 			--宠物攻击概率
		petParam1=nil,      			--宠物参数1
		petParam2=nil,      			--宠物参数2
		petEffect=nil,					--宠物攻击特效名称
		petIcon=nil,					--宠物图标
		petType=nil,					--宠物类型
		petSkillId=nil,					--宠物技能ID
	}]]
	m_tPet = nil,						--宠物信息

	--@brief 状态控制
	m_nRunStatus = 0, 					--运行状态
	m_bIsMoved = false, 				--是否发生移动

	--@brief 道具技能状态相关
	m_bUseBigSkill = false, 			--是否使用大招
    
	m_nWaitFlyTime = 0,					--飞行禁用回合数
	m_bUseFly = false,					--是否使用了飞行（包括道具）
	m_bUseItemFly = false,				--是否使用了道具飞行
    m_bIsStopAnim = false,              --是否暂停所有人物动画（被冰冻）

	--@brief 界面控制属性
	m_mover = nil, 						--移动控制对象
	m_anim = nil,					 	--动画控制对象
	m_shopAnim = nil, 					--商城形象
	m_headAnim = nil, 					--头像形象
	m_followAnim = nil,					--跟踪动画
	m_frozenAnim = nil,					--冰冻动画
	m_angerAnim = nil,					--怒气动画
	m_tPlayerNameInfoIcon = nil, 		--人物信息图标

	--@brief 子弹相关
	m_nWeaponType = nil,				--武器类型
	m_sWeaponName = nil,				--武器名字
	m_bulletCilcle = nil, 				--子弹碰撞、爆炸相关
	m_fRadiusForBulletCollision = 0,	--英雄与子弹碰撞半径
	
	m_fRadiusForHurt = 0,				--受伤半径

	--@brief 伤害相关
	m_bIsHurt = nil,					--标记受伤状态
	m_nHurtStep = nil,					--受伤进行的步骤
	m_nFlyingNum = nil,					--正在飘的数字数量
	m_tHurtValue = nil,					--受伤数据表
	m_nBloodsuckingRate = nil,			--吸血比例(放大1万倍)

	--@brief 机器人相关
	m_nAiCtrlId = 0,					--使用的AI策略
	m_bCanControl = false,				--是否可控制

	--@brief 碰撞相关
	m_bIsShowRang = false,				--是否显示碰撞区域
	m_tCollisionRang = nil, 			--碰撞检测范围表
	m_tCollisionTable = nil,			--碰撞圈
    m_tSuperCritCollisionRange = nil,   --超暴击碰撞检测范围
    m_tSuperCritCollisionTable = nil,   --超暴击碰撞圈
	------------------------------------------------
	------------@brief 各种buff状态------------------
	------------------------------------------------
	m_bIsImmunity = nil,				--是否免疫所有buff
	m_tBuffUpdate=nil,					--Buff重置表([1]:回合数,[2]:回合重置值,[3]:改变的变量,[4]:变量重置值,[5]:使用的动画)
	--@brief 有害buff
	m_tHurtAnim = nil,					--正在显示的动画
	m_nHurtHeroId = nil,				--受伤协议发送的玩家id
	m_nDebuffHurt = nil,				--受伤害(毒素，冰冻，灼伤等)
	m_nDebuffHurtRound = nil,			--受伤害回合
	m_nDebuffTired = nil,				--体力上限降低
	m_nDebuffTiredRound = nil,			--体力上限降低回合
	m_nDebuffAttack = nil,				--攻击力降低
	m_nDebuffAttackRound = nil,			--攻击力降低回合
	m_nDebuffDefence = nil,				--防御力减低
	m_nDebuffDefenceRound = nil,		--防御力减低回合
	m_nDebuffSealRound = nil,			--封印回合(不能使用技能道具)
	m_nDebuffFlyLockRound = nil,		--飞行锁定回合
	m_nDebuffMoveLockRound = nil,		--移动锁定回合
	m_nDebuffFrozenRound = nil,			--被冰冻回合数
	m_nDebuffVertigoRound = nil,		--眩晕回合数
    m_bIsAbsorb = nil,                  --是否吸收
	
	--加密检验字段
	m_nHP_Encrypt = nil,
	m_nSP_Encrypt = nil,
	m_nPF_Encrypt = nil,
	
	m_nAttack_Encrypt = nil,
	m_nCriticalhitAttackRate_Encrypt = nil,
	m_nDefence_Encrypt = nil,
	
	m_nWreckDefense_Encrypt = nil,
	m_nInjuryFree_Encrypt = nil,
	m_nReduceCrit_Encrypt = nil,
	m_nReduceBury_Encrypt = nil,
    
    --计算命中率
    m_nShootCount = 0,       --攻击次数
    m_nHitCount = 0,         --命中次数
    m_nShootHurtTotal = 0,   --造成的合计伤害
    m_bIsAddSpInCurTurn = false,     --当前回合是否已经加过怒气
    m_nSkillHurt = 0,       --技能伤害值
    m_bIsSyncHp = 0,        --同步Hp

    m_nRemainUseItemCount = nil,    --剩余使用道具的次数
    m_nLastUseHideTurn = -1,        --最后一次使用隐藏的回合
    m_nLastUseFrozenTurn = -1,      --最后一次使用冰冻的回合
    m_nLastHitTargetTurn = -1,      --最后一次命中目标的回合
    m_tHitTargets = nil,            --命中的全部玩家
    m_tBulletHitTargets = nil,      --用来记录每个子弹分别打中的敌人
    m_tBulletHitTargetsHurts = nil, --用来记录每个子弹打中的敌人的伤害
    m_sSkillCombos="",              --技能组合

    m_bPlayerShief = false,         --副本3盾牌

    m_bIsViolent = nil,             --是否是狂暴状态
    m_bIsAir = nil,                 --是否是空中状态
    m_bIsAirViolent = nil,          --是否是空中狂暴状态

    
    m_tBuffInvincibleAnim = nil, --无敌动画

    m_nBuffPowerUpRound = nil,
    m_tBuffPowerUpAnim = nil,

    m_nReduceHurt = 1,					--减伤
    m_nBrokeRange = nil,				--爆破范围
    m_nReduceHurtCTB = 0,
    m_nUseSkillTime = 0,
    m_nUseItemTime = 0,
    m_nUseKMSkillTime = 0,

    m_tAttackPos = nil,                 --攻击点
    m_bIsPowerBomb = nil,
    m_bIsPoisonBomb = nil,
    m_bIsSilentBomb = nil,
    m_bIsBindBomb = nil,
    m_bIsTornadoBomb = nil,
    m_bIsSpatterBomb = nil,
    m_bIsMistBomb = nil,
    m_bIsCureBomb = nil,
    m_tIsTransferPosBomb = nil,
    m_tIsEasyHurtBomb = nil,
    m_bIsRepulse = nil,
    m_bIsInCtb = true,                   ---ctb计算
    m_bIsDeadHurt = nil,
    m_nHPPre = 0,

    m_tMachine = nil,                   --机关列表（暂时1个）
    m_bIsUseHide = false,                 --当回合是否使用隐身
    m_bIsShowDead = nil,
    m_bOffHurt = nil,       --免伤害
    m_bOffRepulse = nil,    --免击飞
    m_bOffCollision = nil,  --免子弹碰撞
    m_bAutoStandAction = true,      --自动切换待机动画

    m_nAttackRound = 0,     --攻击回合

    m_nSklillTalkList = nil,    --技能说话

    m_nMyTurnCount = 0,
    m_nRevivalTime = 0,
    m_nRebornTurn = -1,

    m_nActionTimes = 0,     --行动数
    m_nDeadRound = -1,

    m_nRecordRatio = 1,    --伤害比率
    m_nIsSpatter = nil,	--是否溅射
    m_nBigSkillNumber = nil,

    m_mistMask = nil,
    serverId = 0,

    m_bPetActiveAttack = nil,           --是否宠物攻击了
    m_tPetSkillTakeEffectInfo = nil,       --宠物技能生效信息
    m_bIsCrit = nil,    --是否暴击
    m_tImmunityBuffList = nil,  --免疫buff类型列表
    m_bShowOffSkill = nil,  --减伤提示

    m_nCurRoundHurt = 0,    --伤害总量（本回合）
    m_nCurRoundHurt2 = 0,    --伤害总量（本回合）阿波罗皮肤大招吸血效果有用到
    m_nCurRoundHurt3 = 0,    --伤害总量（本回合）共生录技能不是灵药吸血效果有用到
    m_bTornadoReflect = false,  --龙卷风标记
    m_drawNode = nil,
    m_nHurtOffState = -1,   --伤害排除队列状态值
    m_bIsCaptain = false,   --是否队长

    m_nHideViewDis = nil,   --反隐距离
    m_nHideOpecity = nil,   --隐身显示透明度
    m_nAttractBulletDis = nil, --吸引

    m_sShootSoundName = nil, --射击音效
    m_sExplodeSoundName = nil, --爆破音效
    m_nStopByTornado = 0, --是否被龙卷风限制移动
    m_nBeHurtTypeProfession = nil, --受伤类型：1->克制；2->被敌
    m_nBigSkinSkillType = 0,                --皮肤大招类型
    m_bUseSkinBigSkill = false,     --是否使用皮肤大招
    m_nBlastEffect = 0,                 --攻击特效

    m_nHurtRoundNum = 0,     --击中目标回合数（用于计算命中率）
    m_nMaxRoundHurt = 0,     --最高伤害值
    m_nUseItemTimes = 0,     --使用道具次数
    m_nCurRoundHurtTotal = 0,--造成的回合合计伤害
    m_bIsHitEnemy = false,   --是否命中敌人
    m_tUsedSkillAndItemList = {}, --战斗中使用的技能道具
    m_tKillEnemySkill = {},  --杀死对手的技能Id
    m_nDevilOwnId = nil,     --心魔所属玩家Id
    m_tSkillTakeEffectKillList = nil,       --
    m_tSkillTakeEffectKillInfo = nil,       --
    m_tSkillTakeEffectKillIndex = nil,
    m_nCurRoundCtbConsume = 0,  --当前回合消耗的ctb
    m_nPetAttackTimes = nil,      --宠物连击次数
    m_tBringInItems = nil,        --玩家带进战斗的道具

    m_tSkillTakeEffectEndRoundList = nil,       --
    m_tSkillTakeEffectSuperCritList = nil,
    m_tSkillHappenTimes = nil,  
    m_tBuffAddTimes = nil, 
    m_nPetShootIndex = 1,       --宠物攻击次数索引，宠物第几次攻击
    m_nHitSuperCritRectIndex = 0, --被碰撞到了超暴击区域1->碰到了；0->没有触碰到
    m_nRunPetBeatBackTimes = 0,   --宠物触发反击的次数
    m_tPetBeatBackMsgList = nil,     --宠物反击消息数据保存
    m_nSuperCritCount = 0,        --超暴击次数
    
    m_nPlayerInjuredNumber = 0, --玩家受击次数
    m_nPlayerTurnNumber = 0, --玩家自己回合数
    m_tKMSkillCdList = nil,   --辅助技能CD列表
    m_nUsePoint = 0,            --当前回合已经使用的ctb

    m_tAbsorbAttributeList = {},     --吸收的属性列表(吸收的属性用来变成伤害万分比用的)
    m_tKillEnemyKidSkill = {},  --杀死对手的小孩技能Id
    m_nRoundKillMonsterNum = 0, --回合击杀的怪物数量（不包括buff、skillHurt）
    m_nMaxRoundKillMonsterNum = 0, --回合击杀的怪物最大数量（不包括buff、skillHurt）
    m_bIsCalmBomb = nil, --是否使用镇定弹
    m_tPetEquipEffectTakeEffectInfo = nil,       --宠物装备效果属性生效信息
    m_bIsSpeedBomb = nil, --是否使用加速
    m_nExtraHP = 0,       --额外生命
    m_nExtraHP_Encrypt = nil, 
    m_nMaxExtraHP = 0,       --当前最大额外生命
}

--@brief    分身对象子类型
CharacterSubType = {
    SUBTYPE_SOUL = 1,                  --灵魂分身
    SUBTYPE_WCHESS = 2,                  --棋圣-白子分身
    SUBTYPE_BCHESS = 3,                   --棋圣-黑子分身
}
-------------------------------------公有方法模块--------------------------------------

--@brief	初始化对象
function WCharacter:_init()
	self.m_bIsExist = true
	self:_initAttributeChangeState()
end

--@brief	初始化对象
function WCharacter:_initAttributeChangeState()
	self.m_tSkillCdList = {}
    self.m_tItemCdList = {}
    self.m_tKMSkillCdList = {}
	self.m_tBuffChangeStateList = {}
    self.m_tBuffAttributeChangeStateList = {}
    self.m_tKMSkillCdList = {}

	self.m_tAttributeChangeStateList = {}
	self.m_tAttributeChangeStateList.m_nMaxHPAddPercent = nil 			--最大生命值
    self.m_tAttributeChangeStateList.m_nMaxHPAddValue = nil 				--最大生命值
    
    self.m_tAttributeChangeStateList.m_nAttackAddPercent = nil 			--普通攻击力
    self.m_tAttributeChangeStateList.m_nAttackAddValue = nil              --普通攻击力
    
    self.m_tAttributeChangeStateList.m_nDefenceAddPercent = nil 			--防御力
    self.m_tAttributeChangeStateList.m_nDefenceAddValue = nil 			--防御力
    
    self.m_tAttributeChangeStateList.m_nCriticalhitAttackRateAddPercent = nil --爆击攻击倍率
    self.m_tAttributeChangeStateList.m_nCriticalhitAttackRateAddValue = nil 	--爆击攻击倍率
    
    self.m_tAttributeChangeStateList.m_nReduceCritRateAddPercent = nil	--免暴
    self.m_tAttributeChangeStateList.m_nReduceCritRateAddValue = nil		--免暴
    
    self.m_tAttributeChangeStateList.m_nMaxPFAddPercent = nil 			--最大体力
    self.m_tAttributeChangeStateList.m_nMaxPFAddValue = nil 				--最大体力
    
    self.m_tAttributeChangeStateList.m_nSPChangeAddPercent = nil 			--怒气值
    self.m_tAttributeChangeStateList.m_nSPChangeAddValue = nil 			--怒气值
    
    self.m_tAttributeChangeStateList.m_nBrokeRangeAddPercent = nil		--爆破范围
    self.m_tAttributeChangeStateList.m_nBrokeRangeAddValue = nil		--爆破范围

    self.m_tAttributeChangeStateList.m_nHurtChangeValue = nil			--打出去的伤害改变
    self.m_tAttributeChangeStateList.m_nHurtAddPercent = nil			--打出去的伤害改变
    self.m_tAttributeChangeStateList.m_nHurtAddValue = nil				--打出去的伤害改变

    self.m_tAttributeChangeStateList.m_nHurtEnemyAddPercent = nil       --打敌人的伤害改变
    self.m_tAttributeChangeStateList.m_nHurtTeammateAddPercent = nil    --打对友的伤害改变

    self.m_tAttributeChangeStateList.m_nBeHurtChangeValue = nil			--被打的伤害改变
    self.m_tAttributeChangeStateList.m_nBeHurtAddPercent = nil			--被打的伤害改变
    self.m_tAttributeChangeStateList.m_nBeHurtAddValue = nil			--被打的伤害改变

	self.m_tAttributeChangeStateList.m_nAttTimes = nil					--攻击次数正常为1
	self.m_tAttributeChangeStateList.m_nAttScatterNum = nil				--散射子弹数正常为1
	self.m_tAttributeChangeStateList.m_nHideTurn = nil					--隐藏回合
	self.m_tAttributeChangeStateList.m_nBuffInvincibleRound = nil		--无敌回合数
	self.m_tAttributeChangeStateList.m_nDebuffFrozenRound = nil
    self.m_tAttributeChangeStateList.m_nPetCritValue = nil              --宠物暴击倍数
    self.m_tAttributeChangeStateList.m_nFateCritRateAddValue = nil              --命运暴击概率（轮回审批共生技添加的新属性）192版本
    self.m_tAttributeChangeStateList.m_nFateCritAddValue = nil                  --命运暴击倍数（轮回审批共生技添加的新属性）
    self.m_tAttributeChangeStateList.m_nFate_Hurt_FZAddValue = nil              --命运伤害反转万分比（轮回审批共生技添加的新属性）

    self.m_tAttributeChangeStateList.m_nPointLineValue = nil            --拉线加成

    self.m_tAbsorbAttributeList = {}

    self.m_nWeaponId = nil
    self.m_fRadiusForBulletExplodeChange = nil
    self.m_fRadiusForBulletExplode = 200
    self.m_fRadiusForBulletExplodeRate = 1

    self.m_fRectForBulletExplodeBombChange = nil
    self.m_fRectForBulletExplodeBomb = {x=200,y=100}
    self.m_fRectForBulletExplodeBombRate = {x = 1,y = 1}

    self.m_nAttackRound = 0
    self.m_tMachine = {}
    self.m_nSklillTalkList = {}

    self.m_nActionTimes = 0 
    self.m_nRecordRatio = 1  ---战斗记录
    self.m_bShowOffSkill = false

    self.m_nCurRoundHurt = 0
    self.m_nCurRoundHurt2 = 0
    self.m_nCurRoundHurt3 = 0
    self.m_bTornadoReflect = false

    self.m_nHurtOffState = -1
    self.m_nHideViewDis = nil
    self.m_nHideOpecity = nil
    self.m_nAttractBulletDis = nil
end

--@brief	普通动画名字
function WCharacter:getNormalAnimationName()
	return self:getActionName(23)
end

--@brief	受伤动画名字
function WCharacter:getHurtAnimationName()
    local name = self:getActionName(17)
    ---[[
    if self:getType() == 0 and self.m_tHurtValue and self.m_tHurtValue.isPetHurt then
        name = self:getActionName(18)
    end

    WZLog("WCharacter:getHurtAnimationName", name)
    --]]
    return name
end

--@brief	死亡动画名字
function WCharacter:getDeadAnimationName()
	return self:getActionName(15)
end

--@brief    设置ctb
function WCharacter:setCtb(ctb)
    self.m_tCtb = ctb
end

--@brief    设置Bigctb
function WCharacter:setBigCtb(ctb)
    self.m_tBigCtb = ctb
end

--@brief 是否无敌
function WCharacter:getIsInvincible()
    local isInvincible = self:isInBuffState(EffectTypeConfig.INVINCIBLE,true)
    return isInvincible
end

--@brief 改变临时的吸取属性变化
function WCharacter:changeAbsorbAttributeList(key, value)
    WZLog("WCharacter:changeAbsorbAttributeList", key, value, tostring(self.m_tAbsorbAttributeList[key]))
    if self.m_tAbsorbAttributeList == nil then
        self.m_tAbsorbAttributeList = {}
    end
    if self.m_tAbsorbAttributeList[key] then
        self.m_tAbsorbAttributeList[key] = self.m_tAbsorbAttributeList[key] + value
    else
        self.m_tAbsorbAttributeList[key] = value
    end
    WZLog("WCharacter:changeAbsorbAttributeList", self.m_tAbsorbAttributeList[key])
end

--@brief 改变临时的属性变化
function WCharacter:changeAttrListValue(key, value)
    WZLog("WCharacter:changeAttrListValue0", key, value, tostring(self.m_tAttributeChangeStateList[key]))
    if self.m_tAttributeChangeStateList[key] then
        if key == "m_nHurtMulPercent" then
            self.m_tAttributeChangeStateList[key].value = self.m_tAttributeChangeStateList[key].value * value
        else
            self.m_tAttributeChangeStateList[key].value = self.m_tAttributeChangeStateList[key].value + value
        end
    else
        self.m_tAttributeChangeStateList[key] = {value=value}
    end
    WZLog("WCharacter:changeAttrListValue1", self.m_tAttributeChangeStateList[key].value)
end

--@brief	检测无敌
function WCharacter:checkInvincible()
	if self.m_nBuffInvincibleRound ~= nil and self.m_nBuffInvincibleRound > 0 then
		if self.m_tBuffInvincibleAnim == nil then
			WZLog("WHero:checkInvincible one")	
			local anim = BattleAnimation:createAnimation(IWCO_MONSTEREFFICIENTS)	
			anim:addAnimation("boss3Efficient4",{}, 0.1, true)
			anim:play("boss3Efficient4",true)
			local hpos = self:getPosition()
			anim:setPosition(CCPointMake(48,25))
			self:getAnimation():getAnimNode():addChild(anim:getAnimNode())
			self.m_tBuffInvincibleAnim = anim
		end
	else
		if self.m_tBuffInvincibleAnim ~= nil then
			WZLog("WHero:checkInvincible two")
			self.m_tBuffInvincibleAnim:getAnimNode():removeFromParentAndCleanup(true)
			self.m_tBuffInvincibleAnim = nil
		end
	end
end

--@brief	检测加攻
function WCharacter:checkPowerUp()
	if self.m_tAnimPowerUpOffset ~= nil and self.m_nBuffPowerUpRound ~= nil and self.m_nBuffPowerUpRound > 0 then
		if self.m_tBuffPowerUpAnim == nil then
			WZLog("WHero:checkPowerUp one")	
			local anim = BattleAnimation:createAnimation(IWCO_MONSTEREFFICIENTS)	
			anim:addAnimation("boss3Efficient5",{}, 0.1, true)
			anim:play("boss3Efficient5",true)
			local hpos = self:getPosition()
			anim:setPosition(self.m_tAnimPowerUpOffset)
			self:getAnimation():getAnimNode():addChild(anim:getAnimNode())
			self.m_tBuffPowerUpAnim = anim
		end
	else
		if self.m_tBuffPowerUpAnim ~= nil then
			WZLog("WHero:checkPowerUp two")
			self.m_tBuffPowerUpAnim:getAnimNode():removeFromParentAndCleanup(true)
			self.m_tBuffPowerUpAnim = nil
		end
	end
end

--@brief	获取动画
function WCharacter:getAnimationName(index)
	if index == "standby" then
		return self:getActionName(23)
	elseif index == "hurt" then
		return "injured"
	elseif index == "dead" then
		return self:getActionName(15)
	end
end

--@brief	检测状态变化
function WCharacter:checkStateChange()
	self:checkInvincible()
	self:checkPowerUp()

end

--@brief    隐身
function WCharacter:hide(isView)
    WZLog("WCharacter:hide one")
    local hero = self
    local opecity = 255
    if WBattleGlobal:getCurrent():isReplayGame() or (WBattleGlobal:getCurrent():isMyTeam(hero.m_nBattleId) and not hero:isDead() and hero:getHp() > 0) then
        opecity = 128
    else
        opecity = 0
    end
    if isView then
        opecity = 128
    end

    local myHero = WBattleGlobal:getCurrent():getMyHero() 
    if opecity == 0 and WBattleGlobal:getCurrent().m_tMakePairOk.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_GS and myHero.m_nCamp == 1 then 
        opecity = 128
    end

    if WBattleGlobal:getCurrent():getCurrentCharacterId() == self:getBattleId() then
        BattleShowHeroUse:removeHeroUse()
    end
    if self.m_nHideOpecity == opecity then
        return
    else
        self.m_nHideOpecity = opecity
    end
    hero:getAnimation():getAnimNode():setOpacity(opecity)
    if hero:getPlayerNameIcon() and opecity == 0 then
        hero:getPlayerNameIcon():setOpecity(opecity)
    end
    if hero:getPet() then
        hero:getPet():getAnimation():setOpacity(opecity)
        if opecity == 0 and hero:getPet().m_tBackFire then
            hero:getPet().m_tBackFire:setVisible(false)
        end
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

    if opecity == 0 and hero.m_tDialog ~= nil then
        hero.m_tDialog:removeDialog()
        hero.m_tDialog = nil
    end

    for id,buff in pairs (hero.m_tBuffChangeStateList) do
        if buff.m_tAnim then
            buff.m_tAnim:getAnimNode():setOpacity(opecity)
        end
        if buff.m_tAnimRange then
            buff.m_tAnimRange:getAnimNode():setOpacity(opecity)
        end
        WZLog("WCharacter:hide two", tostring(buff.m_tAnim),tostring(buff.m_tAnimRange))
    end
    --幽灵目标选中框
    local spineMark = self:getAnimation():getAnimNode():getChildByTag(1011)
    if spineMark then
        spineMark = WZUISpine:luaTo(spineMark)
        spineMark:setOpacity(opecity)
    end
    if hero.getSkinBigSkillAnimation and hero:getSkinBigSkillAnimation() then 
        hero:getSkinBigSkillAnimation():getAnimNode():setOpacity(opecity)
    end

    --该玩家的棋圣分结束隐藏
    local subHeroList = WBattleGlobal:getCurrent():getSubHero(self:getBattleId())
    for i = 1, #subHeroList do
        subHeroList[i]:getAnimation():getAnimNode():setOpacity(opecity)
        if subHeroList[i]:getPlayerNameIcon() and opecity == 0 then
            subHeroList[i]:getPlayerNameIcon():setOpecity(opecity)
        end
    end
end

--@brief ctb刷新
function WCharacter:updateByCTBProcess(dt,updateCTB_time)
    -- body
end

--@brief	定时更新函数
--@param	dt:距离上一次调用的时间（秒）
--@note		由定时器调用
function WCharacter:update(dt)
    if self.m_deadAnim ~= nil and self.m_deadAnim:isPlaying("0") == true and self.m_deadAnim:isCurrentAnimationDone() == true then
        self.m_deadAnim:getAnimNode():removeFromParentAndCleanup(true)
        self.m_deadAnim = nil
    end
    --击退
    self:updateRepulseDis()

    local staticPos = self:getStaticPos()
    if staticPos.x ~= -1 and (self.m_tLogStaticPos == nil or (staticPos.x ~= self.m_tLogStaticPos.x and staticPos.y ~= self.m_tLogStaticPos.y)) then
        self.m_tLogStaticPos = {x=staticPos.x,y=staticPos.y}
        --WZLog("WCharacter:update zero-0",self:getBattleId(),staticPos.x,staticPos.y, self:getAnimation():getRotate(), self:getPosition().x, self:getPosition().y)
    end

    --下落镜头跟随
    if self:isDead() ~= true and self:getMover() and WBattleGlobal:getCurrent().m_bIsZoomToHero ~= true and WBattleGlobal:getCurrent():getTurnTimes() > 0 then
        if (WBattleGlobal:getCurrent().m_nCurrentPlayerId == self:getBattleId() or self.m_nRebornTurn == WBattleGlobal:getCurrent():getTurnTimes()) and self:getMover():getMoverSpeed().y < -8 then
            local follow = true
            if self:isHide() and not WBattleGlobal:getCurrent():isReplayGame() and not WBattleGlobal:getCurrent():isMyTeam(self:getBattleId()) then
                follow = false
            end
            if follow then
                BattleScreen:followHero(self:getMover():getMoverPosition())
                WZLog("BattleScreen:followHero 2")
            end
        end
    end

    --WZLog("WCharacter:update zero-1",tostring(self:isInBuffState(EffectTypeConfig.LIMIT_ALL_ACTION)),tostring(self:isInBuffState(EffectTypeConfig.LIMIT_MOVE)),tostring(self:isInBuffState(EffectTypeConfig.LIMIT_FLY)),tostring(self:isInBuffState(EffectTypeConfig.LIMIT_USE_SKILL)),tostring(self:isInBuffState(EffectTypeConfig.LIMIT_USE_ITEM)))

    for id,buff in pairs (self.m_tBuffChangeStateList) do
        --WZLog("WCharacter:update zero", tostring(buff.m_sAnimState), tostring(buff.m_tAnim), tostring(buff.m_tAnim and buff.m_tAnim:isCurrentAnimationDone()), tostring(buff.m_tActions), tostring(buff.m_bIsLoop))
        if buff.m_nType == BuffType.MIST and self.m_mistMask then
            local maskPos = self:getMistMaskPost()
            self.m_mistMask:setPosition(maskPos.x,maskPos.y)
            break            
        end
        local buffAnim = GDatatab_EffectInfoConfig["id_"..buff.m_nIngAni]

		if buffAnim ~= nil then
            local x,y = self:getAnimation():getAnimNode():getContentSize().width/2 + buffAnim.offsetX + (self.m_nBuffAnimOffsetX or 0),buffAnim.offsetY + (self.m_nBuffAnimOffsetY or 0)
            -- if buff.m_nType == BuffType.MIST and self.m_mistMask then
            --     local maskPos = self:getMistMaskPost()
            --     self.m_mistMask:setPosition(maskPos.x,maskPos.y)
            --     local size = SceneBattle:getInfoLayer():getContentSize()
            --     x = size.width * 0.5
            --     y = size.height * 1
            -- end

            --WZLog("BuffBody:addAnime-2", x,y)
            if buff.m_tAnim ~= nil and buff.m_bIsSetPos == nil and buffAnim.isArmature == 1 then
                buff.m_bIsSetPos = true
                buff.m_tAnim:getAnimNode():setPosition(GlobalMethod:ccp(x,y))
                --buff.m_tAnim:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.5,0.0))
                WZLog("BuffBody:addAnime-3", x,y)
            elseif buff.m_tAnim ~= nil and buff.m_bIsSetPos == nil and buffAnim.isArmature ~= 1 then
                buff.m_bIsSetPos = true

                --反隐buff start动画起始位置偏移处理（后续有类似 改成配表设计）
                if buff.m_nType == BuffType.HIDE_VIEW then
                    y = y - 150
                end
                buff.m_tAnim:getAnimNode():setAbsPosition(GlobalMethod:ccp(x ,y))
                WZLog("BuffBody:addAnime-4",buff.m_nType,x,y)
            end
            if buff.m_tAnim ~= nil and buff.m_sAnimState ~= nil and buff.m_sAnimState == "start" and buff.m_tAnim:isCurrentAnimationDone() == true then
                --WZLog("WCharacter:update zero-2",buff.m_tActions,x,y)
                if buff.m_tActions ~= "nil" then
                    buff.m_tAnim:play(buff.m_tActions,true)
                    buff.m_sAnimState = "proceed"
                    buff.m_tAnim:getAnimNode():setPosition(GlobalMethod:ccp(x,y))
                elseif buff.m_tAnim:getAnimNode():isVisible() == true then
                    buff.m_tAnim:getAnimNode():setVisible(false)
                    self:hide()
                end

                if buff.m_tAnimRange then
                    buff.m_tAnimRange:play("fanwei",false)
                end

            end
		end
    end
    
	if self:getMarkHurt() then
		self:showHurt()
	end
    
    self:updateFrozenAnimation()
	if  self.m_bIsShowRang and ProjConfig.DEBUG == 1 then
		local charaPos = self:getPosition()
        local tCharaPos = self:getCenterPos()
		if self.m_tCollisionTable == nil then
			self.m_tCollisionTable = {}

			for i,tRang in pairs(self.m_tCollisionRang) do
				if tRang.m_nType == 0 then
    				self.m_tCollisionTable[i] = BattleAnimation:addCircle({x = tCharaPos.x + tRang.m_fXOffset - tRang.m_fRadius*0.5, y = tCharaPos.y+tRang.m_fYOffset} ,tRang.m_fRadius,{r = 1,g = 1,b = 1,a = 1},SceneBattle:getFrontLayer())
				elseif tRang.m_nType == 1 then
    				self.m_tCollisionTable[i] = BattleAnimation:addRect({x = charaPos.x, y = charaPos.y,w = tRang.m_fWidth,h=tRang.m_fHeight},{r = 1,g = 1,b = 1,a = 1},SceneBattle:getFrontLayer())
				end
			end

		end

		for i,tRang in pairs(self.m_tCollisionRang) do
			if tRang.m_nType == 0 then
				self.m_tCollisionTable[i]:setPosition(tCharaPos.x + tRang.m_fXOffset - tRang.m_fRadius*0.5, tCharaPos.y + tRang.m_fYOffset)
			elseif tRang.m_nType == 1 then
				self.m_tCollisionTable[i]:setPosition(charaPos.x + tRang.m_fXOffset - tRang.m_fWidth*0.5, charaPos.y + tRang.m_fYOffset)
			end
		end

        if self.m_tSuperCritCollisionTable == nil then 
            self.m_tSuperCritCollisionTable = {}

            if self.m_tSuperCritCollisionRange then 
                for i,tRang in pairs(self.m_tSuperCritCollisionRange) do
                    if tRang.m_nType == 1 then
                        self.m_tSuperCritCollisionTable[i] = BattleAnimation:addRect({x = charaPos.x, y = charaPos.y,w = tRang.m_fWidth,h=tRang.m_fHeight},{r = 1,g = 1,b = 1,a = 1},SceneBattle:getFrontLayer())
                    end
                end
            end
        end

        if self.m_tSuperCritCollisionRange then 
            for i,tRang in pairs(self.m_tSuperCritCollisionRange) do
                if tRang.m_nType == 1 then
                    self.m_tSuperCritCollisionTable[i]:setPosition(charaPos.x + tRang.m_fXOffset - tRang.m_fWidth*0.5, charaPos.y + tRang.m_fYOffset + tRang.m_fHeight)
                end
            end
        end
	end
end


function WCharacter:getMistMaskPost()
    local pos = self:getPosition()
    -- local point = CCAutoPoint:create(pos.x,pos.y)

    -- point = CCPointApplyAffineTransformAuto(point,self:getAnimation():getAnimNode():getParent():nodeToWorldTransformAuto())
    -- point = CCPointApplyAffineTransformAuto(point,SceneBattle:getInfoLayer():worldToNodeTransformAuto())
    local point = SceneBattle:getFrontLayer():convertToWorldSpace(GlobalMethod:ccp(pos.x,pos.y))
    point = SceneBattle:getInfoLayer():convertToNodeSpace(point)
    return point
end

function WCharacter:updateRepulseDis()
    if self.m_nRepulseDis ~= nil  then
        WZLog("WCharacter:updateRepulseDis",self:getMover():isCollision())
        if not self:isDead() and self:getMover():isCollision() == false then
            --超出屏幕
            local size = self:getAnimation():getAnimNode():getContentSize()
            local pos = self:getPosition()
            local sceneSize = SceneBattle:getFrontLayerSize()
            if pos.x + size.width*0.5 >= sceneSize.width then
                self:setPosition(GlobalMethod:ccp(sceneSize.width - size.width*0.5,pos.y))
                self:removeRepulse()
            elseif pos.x - size.width*0.5 <= 0 then
                self:setPosition(GlobalMethod:ccp(size.width*0.5,pos.y))
                self:removeRepulse()
            end
        else
           self:removeRepulse()
        end
        BattleScreen:followHero(self:getMover():getMoverPosition())
        WZLog("BattleScreen:followHero 5")
    end
end

--@brief	销毁一个角色
function WCharacter:destroy()
    WZLog("WCharacter:destroy")
    -- GlobalGame:getBattleEventDispatcher():Dispatch(BATTLE_EVENT_TYPE.MONSTER_DEAD,self)

	self.m_bIsShowRang = false
	self.m_tCollisionRang = nil
	self.m_tCollisionTable = nil
    self.m_tSuperCritCollisionRange = nil 
    self.m_tSuperCritCollisionTable = nil 
	self.m_tHurtValue = nil
	if self.m_tHurtAnim ~= nil then
		for name,anim in pairs(self.m_tHurtAnim) do
			anim:getAnimNode():removeFromParentAndCleanup(true)
			anim = nil
		end
	end
	self.m_tHurtAnim = nil
	self.m_tBuffUpdate = nil
	self.m_bIsExist = nil
    
    self.m_nShootCount = 0
    self.m_nHitCount = 0
    self.m_nShootHurtTotal = 0
    m_bIsAddSpInCurTurn = false

    self.m_nHP_Encrypt = nil
    self.m_nSP_Encrypt = nil
    self.m_nPF_Encrypt = nil
    self.m_nExtraHP_Encrypt = nil

    self.m_nAttack_Encrypt = nil
    self.m_nCriticalhitAttackRate_Encrypt = nil
    self.m_nDefence_Encrypt = nil

    self.m_nWreckDefense_Encrypt = nil
    self.m_nInjuryFree_Encrypt = nil
    self.m_nReduceCrit_Encrypt = nil
    self.m_nReduceBury_Encrypt = nil

    self.m_nSkillHurt = 0
    
    self.m_nRemainUseItemCount = nil
    self.m_nLastUseHideTurn = -1
    self.m_nLastUseFrozenTurn = -1
    self.m_nLastHitTargetTurn = -1
    self.m_tHitTargets = nil
    self.m_tBulletHitTargets = nil
    self.m_tBulletHitTargetsHurts = nil
    self.m_sSkillCombos=""
    self.m_bIsDeadHurt = nil
    self.m_tMachine = nil
    self.m_nHideViewDis = nil
    self.m_nHideOpecity = nil
    self.m_nAttractBulletDis = nil

    self:removeDeadAnimation()
end

--@brief	是否还存在
--@return	#1:true,false
function WCharacter:getIsExist()
	return self.m_bIsExist or false
end

--@brief	设置对象类型
--@param	type:对象类型
function WCharacter:setType(type)
	self.m_nCharaType = type
end

--@brief	设置ai表
--@param	tAi:ai表
function WCharacter:setAI(tAi)
	self.m_tAI = tAi
end

--@brief	获取ai表
--@return	#1:ai表
function WCharacter:getAI()
	return self.m_tAI
end

--@brief	获取对象类型
--@return	#1:对象类型(0:player,1:guai)
function WCharacter:getType()
	return self.m_nCharaType
end

--@brief	获取是否英雄
--@return	#1:true，false
function WCharacter:getIsHero()
	return self.m_nCharaType == CharacterType.TYPE_HERO
end

--@brief	获取是否怪物
--@return	#1:true，false
function WCharacter:getIsGuai()
	return self.m_nCharaType == CharacterType.TYPE_GUAI
end

--@brief    获得是否被击退
--@return   #1:true,false
function WCharacter:getIsRepulse()
    if self.m_nRepulseDis ~= nil and self.m_nRepulseDis ~= 0 then
        return true
    else
        return false
    end
end

--@brief    设置击退
--@param    repulse:击退距离(正右负左)
--@param    paramSpeed:击退速度，不为空，repulse无效
function WCharacter:setRepulse(repulse, repulseY, paramSpeed)
    --do return end
    if self.m_bOffRepulse then
        return
    end

    --WZLog("WCharacter:setRepulse", repulse)

    local pos = self:getAnimation():getPosition()
    
    local endPos =  GlobalMethod:ccp(pos.x,pos.y + BattleMsgPlayerReadyFly.SHOOT_Y_OFFSET)
    
    if BattleCommon:checkPosCollision(endPos,BattleMapManager.m_pixelByte) then
        return
    end
    self:setPosition(Vector2:create(pos.x,pos.y + BattleMsgPlayerReadyFly.SHOOT_Y_OFFSET))

    self.m_nRepulseDis = repulse
    local speed
    repulseY = repulseY or 15
    if paramSpeed then 
        speed = Vector2:create(paramSpeed.x,paramSpeed.y)
    else
        if math.abs(repulse) > 0 and math.abs(repulse) < 10 then
            repulse = repulse * 10/math.abs(repulse)
        elseif math.abs(repulse) == 0 then 
            repulse = 0
        end
        if math.abs(repulse) > 50 then
            repulse = repulse * 50/math.abs(repulse)
        end

        local dx = math.floor(repulse)
        speed = Vector2:create(dx,repulseY)
    end

    self:setRunStatus(RunStatus.DEF_ST_FLY)
    self:getMover():setMoverSpeed(speed)
    self:getMover():setFly(true)
    if not self.m_bIsAir then
        self:setMoveUpdatable(true)
    end
end

--@brief    设置击退
--@param    repulse:击退距离(正右负左)
function WCharacter:removeRepulse()
    WZLog("WCharacter:removeRepulse")
    self.m_nRepulseDis = nil
    self:getMover():setFly(false)
    self:getMover():setMoverSpeed(Vector2:create(0,0))
    self:setMoveUpdatable(true)
    self:setRunStatus(RunStatus.DEF_ST_NORMAL)
end

--@brief    获得是否被击退
--@return   #1:true,false
function WCharacter:getIsRepulse()
    if self.m_nRepulseDis ~= nil and self.m_nRepulseDis ~= 0 then
        return true
    else
        return false
    end
end

--@return 属性值
function WCharacter:setMaxHp(value)
	self.m_nMaxHP = value
end



--@brief 颠倒伤害
function WCharacter:getHurtReverse(hurt, tShootHero)
    hurt = math.ceil(hurt)
    local hurtReverse = 0
    local isInBuffState, effect = self:isInBuffState(EffectTypeConfig.REVERSE,true)
    local probability = 0
    local hurtAdd = 0
    local fateCritRate = 0
    if tShootHero and tShootHero.getFateCritRate then 
        fateCritRate = tShootHero:getFateCritRate(true)
    end

    if hurt <= 0 then
        hurtReverse = hurt
    elseif fateCritRate > 0 then --触发了轮回审判共生技，无视命运骰子效果
        if not tShootHero:isFateCrit() then 
            hurtAdd = tShootHero:getFate_Hurt_FZ(true)
        --    WZLog("WCharacter:getHurtReverse 000", hurtAdd)
            hurtReverse = math.ceil(hurt * (hurtAdd /10000)) * -1
        else
            hurtReverse = hurt 
        end
    elseif isInBuffState then
        probability = effect[5]
        hurtAdd = effect[6]
        if probability* 100 >= WBattleGlobal:getCurrent().m_tBattleRand[1] then
            hurtReverse = hurt * -1
        else
            hurtReverse = hurt + math.ceil(hurt * (hurtAdd /100))
        end
    else
        hurtReverse = hurt
    end

    WZLog("WCharacter:getHurtReverse", tostring(isInBuffState),hurtReverse, hurt, probability, WBattleGlobal:getCurrent().m_tBattleRand[1], hurtAdd)
    return hurtReverse,hurtAdd/100
end

--@brief 颠倒伤害附加比例
function WCharacter:getHurtReverseRatio()
    local hurtReverse = 0
    local hurtAdd = 0
    local isInBuffState, effect = self:isInBuffState(EffectTypeConfig.REVERSE,true)
    local probability = 0
    if isInBuffState then
        probability = effect[5]
        hurtAdd = effect[6]
    end
    return hurtAdd/100
end


--@brief	获取受伤类型
--@return	#1:0:普通，1:暴击，2:超暴击
function WCharacter:getHurtType()
	return self.m_nHurtType
end

--@brief	设置受伤类型
--@param	bType:受伤类型(0:普通，1:暴击，2:超暴击)
function WCharacter:setHurtType(bType)
	self.m_nHurtType = bType
end

--@brief	获取是否被暴击
function WCharacter:getIsCriticalHit()
	return self.m_nHurtType ~= 0
end





--@return 属性值
function WCharacter:getHp(isTotal)
    return self.m_nHP
end

--@return 属性值
function WCharacter:getPF(isTotal)
    return self.m_nPF
end

--@brief    获得怒气
--@return   当前怒气
function WCharacter:getSp()
    return self.m_nSP
end

--@return 获取吸取的属性值
function WCharacter:getAbsorbAttributeValue(key)
    return self.m_tAbsorbAttributeList[key] or 0
end

--@return 属性值(固定伤害)
function WCharacter:getHurtChangeValue()
    local value = nil
    if self.m_tAttributeChangeStateList.m_nHurtChangeValue ~= nil then
        return self.m_tAttributeChangeStateList.m_nHurtChangeValue.value
    end
    value = BattleBuffMethod:getBuffValue(self,EffectTypeConfig.CHANGE_HURT_VALUE)
    return value
end

--@return 属性值(固定伤害)
function WCharacter:getBeHurtChangeValue()
    local value = nil
    if self.m_tAttributeChangeStateList.m_nBeHurtChangeValue ~= nil then
        return self.m_tAttributeChangeStateList.m_nBeHurtChangeValue.value
    end
    value = BattleBuffMethod:getBuffValue(self,EffectTypeConfig.CHANGE_HURT_VALUE)
    return value
end

--@return 属性值
function WCharacter:getHurtAddPercent(targetHero)
    local value = nil
    if self.m_tAttributeChangeStateList.m_nHurtAddPercent ~= nil then
        value = self.m_tAttributeChangeStateList.m_nHurtAddPercent.value / 10000
    end
    value = value or 0
    value = value + BattleBuffMethod:getBuffValue(self,EffectTypeConfig.CHANGE_HURT_PERCENT)
    --职业伤害加成
    if targetHero then 
        if targetHero:getProfessionId() > 0 and self.m_tProfessionSkills then 
            for i = 1, self.m_tProfessionSkills.count do
                if self.m_tProfessionSkills.skill_type[i] == 1 and type(self.m_tProfessionSkills.attribute[i]) == "table" and self.m_tProfessionSkills.attribute[i][1][1] == targetHero:getProfessionId() and self.m_tProfessionSkills.node[i] == 5 then 
                    value = value + self.m_tProfessionSkills.attribute[i][1][2]/10000
                    WZLog("WCharacter:getHurtAddPercent" .. " targetHero:" .. targetHero:getId() .. "shootHeroId:" .. self.m_nPlayerId .. "value:" .. self.m_tProfessionSkills.attribute[i][1][2])
                    break 
                end
            end
        end
    end
    return value
end

--@return 属性值
function WCharacter:getHurtMulPercent()
    local value = nil
    if self.m_tAttributeChangeStateList.m_nHurtMulPercent ~= nil then
        value = self.m_tAttributeChangeStateList.m_nHurtMulPercent.value
    end
    value = value or 1
    value = value * BattleBuffMethod:getBuffValue(self,EffectTypeConfig.CHANGE_HURT_MUL_PERCENT)
    
    return value
end

--@return 属性值
function WCharacter:getHurtAddValue()
    local value = nil
    if self.m_tAttributeChangeStateList.m_nHurtAddValue ~= nil then
        value = self.m_tAttributeChangeStateList.m_nHurtAddValue.value
    end

    value = value or 0
    value = value + BattleBuffMethod:getBuffValue(self,EffectTypeConfig.CHANGE_HURT_ADD_VALUE)

    return value
end

--@brief    获取阵营伤害乘积比率
function WCharacter:getCampHurtAddPercent(targetHero)
    local value = nil

    if WBattleGlobal:getCurrent():isSameTeam(self:getBattleId(),targetHero:getBattleId()) then --对友方
        WZLog("WCharacter:getCampHurtAddPercent1",self.m_tAttributeChangeStateList.m_nHurtTeammateAddPercent)
        if self.m_tAttributeChangeStateList.m_nHurtTeammateAddPercent ~= nil then
            value = self.m_tAttributeChangeStateList.m_nHurtTeammateAddPercent.value / 10000
        end
        value = value or 0
        value = value + BattleBuffMethod:getBuffValue(self,EffectTypeConfig.CHANGE_HURT_TO_TEAMMATE)
    else --对敌方
        WZLog("WCharacter:getCampHurtAddPercent2",self.m_tAttributeChangeStateList.m_nHurtEnemyAddPercent)
        if self.m_tAttributeChangeStateList.m_nHurtEnemyAddPercent ~= nil then
            value = self.m_tAttributeChangeStateList.m_nHurtEnemyAddPercent.value / 10000
        end
        value = value or 0
        value = value + BattleBuffMethod:getBuffValue(self,EffectTypeConfig.CHANGE_HURT_TO_ENEMY)
    end

    return value
end

--@return 属性值
function WCharacter:getBeHurtAddPercent(shootHero)
    local value = nil
    if self.m_tAttributeChangeStateList.m_nBeHurtAddPercent ~= nil then
        value = self.m_tAttributeChangeStateList.m_nBeHurtAddPercent.value / 100
    end
    value = value or 0
    value = value + BattleBuffMethod:getBuffValue(self,EffectTypeConfig.CHANGE_BEHURT_PERCENT)
    --职业伤害
    if shootHero then 
        if shootHero:getProfessionId() > 0 and self.m_tProfessionSkills then 
            for i = 1, self.m_tProfessionSkills.count do
                if self.m_tProfessionSkills.skill_type[i] == 1 and type(self.m_tProfessionSkills.attribute[i]) == "table" and self.m_tProfessionSkills.attribute[i][1][1] == shootHero:getProfessionId() and self.m_tProfessionSkills.node[i] == 0 then 
                    value = value + self.m_tProfessionSkills.attribute[i][1][2]/10000
                    WZLog("WCharacter:getBeHurtAddPercent" .. " shootHeroId:" .. shootHero:getId() .. "targetHeroId:" .. self.m_nPlayerId .. "value:" .. self.m_tProfessionSkills.attribute[i][1][2])
                    break 
                end
            end
        end
    end

    --减伤 不能超过-1 否则变为加血
    if value and value < -1 then
        value = -1
    end

    return value
end

--@return 属性值
function WCharacter:getBeHurtAddValue(hurtMax)
    local value = nil
    if self.m_tAttributeChangeStateList.m_nBeHurtAddValue ~= nil then
        value = self.m_tAttributeChangeStateList.m_nBeHurtAddValue.value
    end
    value = value or 0
    value = value + BattleBuffMethod:getBuffValue(self,EffectTypeConfig.CHANGE_BEHURT_ADD_VALUE)
    return value
end


--@return 属性值
function WCharacter:getMaxHp(isTotal)
    if isTotal == true then
        value = self:getAttributeTotal("m_nMaxHP",AttributeConfig.MaxHP)
        return value
    else
        return self.m_nMaxHP
    end
end

--@brief    获取暴击概率
function WCharacter:getCritProbability(isTotal)
    --return BattleBuffMethod:getBuffValue(self,EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT, AttributeConfig.CriticalhitAttackRate)

    if isTotal == true then
        value = self:getAttributeTotal("m_nCritProbability",AttributeConfig.CritProbability)
        WZLog("WCharacter:getCritProbability", value)
        return value
    else
        return self.m_nCriticalhitAttackRate
    end

end

--@brief    获取被暴击概率
function WCharacter:getBeCritRate(isTotal)
    --return BattleBuffMethod:getBuffValue(self,EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT, AttributeConfig.ReduceCritRate)
    if isTotal == true then
        value = self:getAttributeTotal("m_nReduceCritRate",AttributeConfig.ReduceCritRate)
        return value
    else
        return self.m_nCriticalhitAttackRate
    end
end

--@brief    获取暴击伤害万分比
function WCharacter:getCritHurtAddPercent()
    --return BattleBuffMethod:getBuffValue(self,EffectTypeConfig.CHANGE_CRIT_HURT_PERCENT)
    local value = nil
    if self.m_tAttributeChangeStateList.m_nCritHurtAddPercent ~= nil then
        value = self.m_tAttributeChangeStateList.m_nCritHurtAddPercent.value / 10000
    end
    value = value or 0
    value = value + BattleBuffMethod:getBuffValue(self,EffectTypeConfig.CHANGE_CRIT_HURT_PERCENT)
    
    return value
end

--@brief    获取被暴击伤害万分比
function WCharacter:getBeCritHurtAddPercent()
    --return BattleBuffMethod:getBuffValue(self,EffectTypeConfig.CHANGE_BECRIT_HURT_PERCENT)
    local value = nil
    if self.m_tAttributeChangeStateList.m_nBeCritHurtAddPercent ~= nil then
        value = self.m_tAttributeChangeStateList.m_nBeCritHurtAddPercent.value / 10000
    end
    value = value or 0
    value = value + BattleBuffMethod:getBuffValue(self,EffectTypeConfig.CHANGE_BECRIT_HURT_PERCENT)
    
    return value
end

--@brief    获取暴击伤害附加值
function WCharacter:getCritHurtAddValue()
    --return BattleBuffMethod:getBuffValue(self,EffectTypeConfig.CHANGE_CRIT_HURT_PERCENT)
    local value = nil
    if self.m_tAttributeChangeStateList.m_nCritHurtAddValue ~= nil then
        value = self.m_tAttributeChangeStateList.m_nCritHurtAddValue.value
    end
    value = value or 0
    value = value + BattleBuffMethod:getBuffValue(self,EffectTypeConfig.CHANGE_CRIT_HURT_ADD_VALUE)
    
    return value
end

--@brief    获取被暴击伤害附加值
function WCharacter:getBeCritHurtAddValue()
    --return BattleBuffMethod:getBuffValue(self,EffectTypeConfig.CHANGE_BECRIT_HURT_PERCENT)
    local value = nil
    if self.m_tAttributeChangeStateList.m_nBeCritHurtAddValue ~= nil then
        value = self.m_tAttributeChangeStateList.m_nBeCritHurtAddValue.value
    end
    value = value or 0
    value = value + BattleBuffMethod:getBuffValue(self,EffectTypeConfig.CHANGE_BECRIT_HURT_ADD_VALUE)
    
    return value
end

--@brief    获取受到治疗效果万分比
function WCharacter:getRecoveryAddPercent()
    --return BattleBuffMethod:getBuffValue(self,EffectTypeConfig.CHANGE_RECOVERY_PERCENT)
    local value = nil
    if self.m_tAttributeChangeStateList.m_nRecoveryAddPercent ~= nil then
        value = self.m_tAttributeChangeStateList.m_nRecoveryAddPercent.value / 10000
    end
    value = value or 0
    value = value + BattleBuffMethod:getBuffValue(self,EffectTypeConfig.CHANGE_RECOVERY_PERCENT)
    
    return value
end

--@brief    是否免坑
function WCharacter:getIsNoHole()
    return self:isInBuffState(EffectTypeConfig.NO_HOLE)
end

--@brief    获取攻击力
--@return   #1:攻击力
function WCharacter:getAttack(isTotal)
    if isTotal == true then
        value = self:getAttributeTotal("m_nAttack",AttributeConfig.Attack)
        return value
    else
        WZLog("WCharacter:getAttack", self.m_nAttack)
        return self.m_nAttack
    end
end

--@return 属性值
function WCharacter:getDefence(isTotal)
    if isTotal == true then
        value = self:getAttributeTotal("m_nDefence",AttributeConfig.Defence)
        return value
    else
        return self.m_nDefence
    end
end

--@return 属性值(暴击率)
function WCharacter:getCriticalhitAttackRate(isTotal)
    if isTotal == true then
        value = self:getAttributeTotal("m_nCriticalhitAttackRate",AttributeConfig.CriticalhitAttackRate)
        return value
    else
        return self.m_nCriticalhitAttackRate
    end
end

--@return 属性值
function WCharacter:getReduceCritRate(isTotal)
    if isTotal == true then
        value = self:getAttributeTotal("m_nReduceCritRate",AttributeConfig.ReduceCritRate)
        return value
    else
        return self.m_nReduceCritRate
    end
end

--@brief    获得人物最大体力
--@return   #1,人物最大体力
function WCharacter:getMaxPF(isTotal)
    if isTotal == true then
        value = self:getAttributeTotal("m_nMaxPF",AttributeConfig.MaxPF)
        return value
    else
        return self.m_nMaxPF
    end
end

--@return 属性值
function WCharacter:getSPChange(isTotal)
    if isTotal == true then
        value = self:getAttributeTotal("m_nSPChange",AttributeConfig.SPChange)
        return value
    else
        return self.m_nSPChange
    end
end

--@brief	获取破防值
--@return	#1:破防值
function WCharacter:getWreckDefense(isTotal)
    if isTotal == true then
        value = self:getAttributeTotal("m_nWreckDefense",AttributeConfig.WreckDefense)
        return value
    else
        return self.m_nWreckDefense
    end
end

--@brief	获取免伤
--@return	#1:免伤
function WCharacter:getInjuryFree(isTotal)
    if isTotal == true then
        value = self:getAttributeTotal("m_nInjuryFree",AttributeConfig.InjuryFree)
        return value
    else
        return self.m_nInjuryFree
    end
end

--@brief	获取免暴
--@return	#1:免暴
function WCharacter:getReduceCrit(isTotal)
    if isTotal == true then
        value = self:getAttributeTotal("m_nReduceCrit",AttributeConfig.ReduceCrit)
        return value
    else
        return self.m_nReduceCrit
    end
end

--@return 属性值(力量)
function WCharacter:getPower(isTotal)
    if isTotal == true then
        value = self:getAttributeTotal("m_nPower",AttributeConfig.Power)
        return value
    else
        return self.m_nPower
    end
end

--@return 属性值(护甲)
function WCharacter:getArmor(isTotal)
    if isTotal == true then
        value = self:getAttributeTotal("m_nArmor",AttributeConfig.Armor)
        return value
    else
        return self.m_nArmor
    end
end

--@return 属性值(体质)
function WCharacter:getConstitution(isTotal)
    if isTotal == true then
        value = self:getAttributeTotal("m_nConstitution",AttributeConfig.Constitution)
        return value
    else
        return self.m_nConstitution
    end
end

--@return 属性值(敏捷)
function WCharacter:getAgility(isTotal)
    if isTotal == true then
        value = self:getAttributeTotal("m_nAgility",AttributeConfig.Agility)
        return value
    else
        return self.m_nAgility
    end
end

--@return 属性值(幸运)
function WCharacter:getLucky(isTotal)
    if isTotal == true then
        value = self:getAttributeTotal("m_nLucky",AttributeConfig.Lucky)
        return value
    else
        return self.m_nLucky
    end
end

--@return 属性值
function WCharacter:getBrokeRange(isTotal)
    if isTotal == true then
        value = self:getAttributeTotal("m_nBrokeRange",AttributeConfig.BrokeRange)
        return value
    else
        return self.m_nBrokeRange
    end
end

--@brief    获取宠物暴击百分比
--@return   宠物暴击百分比
function WCharacter:getPetCrit()
    local value = self.m_tAttributeChangeStateList.m_nPetCritValue and self.m_tAttributeChangeStateList.m_nPetCritValue.value or 0
    WZLog("WCharacter:getPetCrit", value, tostring(self.m_tAttributeChangeStateList.m_nPetCritValue and self.m_tAttributeChangeStateList.m_nPetCritValue.value))
    return value
end

--@brief    获取攻击次数
--@return   攻击次数
function WCharacter:getAttTimes()
    local times = self.m_tAttributeChangeStateList.m_nAttTimes and self.m_tAttributeChangeStateList.m_nAttTimes.value or self.m_nAttTimes
    WZLog("WCharacter:getAttTimes", times, tostring(self.m_tAttributeChangeStateList.m_nAttTimes and self.m_tAttributeChangeStateList.m_nAttTimes.value), self.m_nAttTimes)
    times = times < 1 and 1 or times 
    return times
end


--@brief    获取散射子弹数
--@return   散射子弹数
function WCharacter:getAttScatterNum()
    local times =  self.m_tAttributeChangeStateList.m_nAttScatterNum and self.m_tAttributeChangeStateList.m_nAttScatterNum.value or self.m_nAttScatterNum
    times = times < 1 and 1 or times 
    return times
end

--@brief 获得属性值
--@param 属性变量名
--@param 属性类型
function WCharacter:getAttributeTotal(valName,attriType)
    local value,base = self[valName],self[valName]
    local tAddPercent = self.m_tAttributeChangeStateList[valName.."AddPercent"]
    local tvalueAddValue = self.m_tAttributeChangeStateList[valName.."AddValue"]

    if tAddPercent ~= nil then
        value = value + base * tAddPercent.value
    end
    if tvalueAddValue ~= nil then
        value = value + tvalueAddValue.value
    end
    local buffPre = BattleBuffMethod:getBuffValue(self,EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT,attriType)
    local buffVal = BattleBuffMethod:getBuffValue(self,EffectTypeConfig.CHANGE_ATTRIBUTE_VALUE,attriType)
    value = value + base * buffPre + buffVal
    WZLog("WCharacter:getAttributeTotal", valName, self:getBattleId(), value, "AddPercent", Serialize(tAddPercent), "AddValue", Serialize(tvalueAddValue))
    return value
end

--@brief	获取免坑
--@return	#1:免坑
function WCharacter:getReduceBury()
	return self.m_nReduceBury
end

--@brief    获取幸运暴击概率
--@return   #1:幸运暴击概率
function WCharacter:getFateCritRate(isTotal)
    if isTotal == true then
        local value = self:getAttributeTotal("m_nFateCritRate", AttributeConfig.FateCritRate)
        return value
    else
        WZLog("WCharacter:getFateCritRate", self.m_nFateCritRate)
        return self.m_nFateCritRate
    end
end

--@brief    获取命运暴击倍数
--@return   #1:命运暴击倍数
function WCharacter:getFateCrit(isTotal)
    if isTotal == true then
        local value = self:getAttributeTotal("m_nFateCrit", AttributeConfig.FateCrit)
        return value
    else
        WZLog("WCharacter:getFateCrit", self.m_nFateCrit)
        return self.m_nFateCrit
    end
end

--@brief    获取命运伤害反转万分比
--@return   #1:命运伤害反转万分比
function WCharacter:getFate_Hurt_FZ(isTotal)
    if isTotal == true then
        local value = self:getAttributeTotal("m_nFate_Hurt_FZ", AttributeConfig.Fate_Hurt_FZ)
        return value
    else
        WZLog("WCharacter:getFate_Hurt_FZ", self.m_nFate_Hurt_FZ)
        return self.m_nFate_Hurt_FZ
    end
end

--@brief	获取大招类型
--@return	#1:大招类型
function WCharacter:getBigSkillType()
	return self.m_nBigSkillType
end

--@brief	设置id
--@param	nId:id
function WCharacter:setId(nId)
	self.m_nPlayerId = nId
end

--@brief	获取英雄id
--@return	#1:id
function WCharacter:getId()
	return self.m_nPlayerId
end

--@brief	设置英雄战斗id
--@param	nbattleId:战斗id
function WCharacter:setBattleId(nbattleId)
	self.m_nBattleId = nbattleId
end

--@brief	获取英雄战斗id
--@return	#1:id
function WCharacter:getBattleId()
	return self.m_nBattleId
end

--@brief	获取英雄所在房间id
--@return	#1:id
function WCharacter:getRoomId()
	return self.m_nRoomId
end

--@brief	获取武器类型
--@return	#1:武器类型
function WCharacter:getWeaponType()
	return self.m_nWeaponType
end

--@brief	设置武器名字
--@param	sName:武器名字
function WCharacter:setWeaponName(sName)
	self.m_sWeaponName = sName
end

--@brief	获取武器名字
--@return	#1:武器名字
function WCharacter:getWeaponName()
	return self.m_sWeaponName
end

--@brief    设置武器射击音效名字
function WCharacter:setShootSoundName(sName)
    self.m_sShootSoundName = sName
end

--@brief    获取武器射击音效名字
function WCharacter:getShootSoundName()
    return self.m_sShootSoundName
end

--@brief    设置武器爆破音效名字
function WCharacter:setExplodeSoundName(sName)
    self.m_sExplodeSoundName = sName
end

--@brief    获取武器爆破音效名字
function WCharacter:getExplodeSoundName()
    return self.m_sExplodeSoundName
end

--@brief	设置转生等级
--@param	zsLevel:转生等级
function WCharacter:setZSLevel(zsLevel)
	self.m_nZSLevel = zsLevel
end

--@brief	获取转生等级
--@return	#1:转生等级
function WCharacter:getZSLevel()
	return self.m_nZSLevel
end

--@brief    记录临时状态值
function WCharacter:setTmpState(stateName)
    self.m_sTmpState = stateName
end

--@brief    获取临时状态值
function WCharacter:getTmpState(stateName)
    return self.m_sTmpState
end

--@brief	获取子弹碰撞半径
--@return	#1:子弹碰撞半径
function WCharacter:getRadiusForBulletCollision()
	return self.m_fRadiusForBulletCollision
end

--@brief	获取受伤半径
--@return	#1:受伤半径
function WCharacter:getRadiusForHurt()
	return self.m_fRadiusForHurt
end

--@brief	是否可以控制该角色
--@return	#1:true：是，false：否
function WCharacter:isCanControl()

    if WBattleGlobal:getCurrent():isAudience() or WBattleGlobal:getCurrent():isReplayGame() then
        return false
    end
    
    if WBattleGlobal:getCurrent():isSingleStage() then
        return true
    end

    if (self:isDevilGuai() or self:getIsSoulHero()) and WBattleGlobal:getCurrent():isHostControl() then 
        return true
    end
	return self:getBattleId() == WBattleGlobal:getCurrent():getMyBattleId() or self.m_bCanControl == true
end

--@brief	判断该角色是否为机器人
--@return	#1:true：是，false：否
function WCharacter:isRobot()
    local isRobot = self:getBattleId() ~= WBattleGlobal:getCurrent():getMyBattleId() and (self.m_bCanControl == true or self:isDevilGuai() and WBattleGlobal:getCurrent():isHostControl())
	return isRobot
end

--@brief	设置宠物
--@param	tPet:Pet表
function WCharacter:setPet(tPet)
	self.m_tPet = tPet
end

--@brief	获取宠物
--@return	#1:宠物表
function WCharacter:getPet()
	return self.m_tPet
end

--@return 获取我的队友
function WCharacter:getMyTeam()
	local tHeroList = WBattleGlobal:getCurrent():getCharacterList()

	local nPlayerCount = 0
    local tPlayerIds = {}
    for i ,v in pairs(tHeroList) do
    if v:getHp() > 0 and not v:isDead() and v.m_bLoseNet ~= true and WBattleGlobal:getCurrent():isSameTeam(self.m_nBattleId,v.m_nBattleId) == true then
        	nPlayerCount = nPlayerCount + 1        
            tPlayerIds[nPlayerCount] = v
       	end
    end

    return tPlayerIds
end

--@return 获取我的敌人
function WCharacter:getMyEnemy()
	local tHeroList = WBattleGlobal:getCurrent():getCharacterList()

	local nPlayerCount = 0
    local tPlayerIds = {}
    for i ,v in pairs(tHeroList) do
        if v:getHp() > 0 and not v:isDead() and v.m_bLoseNet ~= true and WBattleGlobal:getCurrent():isSameTeam(self.m_nBattleId,v.m_nBattleId) ~= true then
        	nPlayerCount = nPlayerCount + 1        
            tPlayerIds[nPlayerCount] = v
       	end
    end

    return tPlayerIds
end

--@brief	获取中心位置
--@return	#1:中心位置
function WCharacter:getCenterPos()
    local size = self:getAnimation():getAnimNode():getContentSize()

    do
        return {x=self:getPosition().x,y=self:getPosition().y + size.height * 0.3 - 10}
    end

	local moverCenter = {x=0,y=0}
	if self:getMover() ~= nil then
		moverCenter.x = self:getMover():getMoverCenter().x
		moverCenter.y = self:getMover():getMoverCenter().y
	end
	local anchor = self:getAnimation():getAnimNode():getAnchorPoint()

	local heroCenter = CCPointMake(moverCenter.x + anchor.x*size.width, moverCenter.y + anchor.y*size.height)

	local toParentTranf = self:getAnimation():getAnimNode():nodeToParentTransform()
	heroCenter=CCPointApplyAffineTransform(heroCenter,toParentTranf)
	return heroCenter
end


--@brief	获取静止位置
--@return	#1:静止位置
function WCharacter:getStaticPos()
    local curPos = self:getCenterPos()
    if self.m_tStaticPosPro == nil then
        self.m_tStaticPosPro = {x=-1,y=-1}
        self.m_tStaticPos = {x=-1,y=-1}
    end

    if self.m_tStaticPosPro.x == curPos.x and self.m_tStaticPosPro.y == curPos.y then
        self.m_tStaticPos = {x=curPos.x,y=curPos.y}
    end

    self.m_tStaticPosPro = {x=curPos.x,y=curPos.y}

    return self.m_tStaticPos
end

--@brief    获取动画容器
function WCharacter:getAnimNode()
    if self.getAnimation() and self.getAnimation():getAnimNode() then
        return self.getAnimation():getAnimNode()
    end
    return nil
end

--@brief	获取动画中心位置
--@return	#1:动画中心位置
function WCharacter:getAnimationCenterPos()
    if self:getAnimation() == nil or self:getAnimation():getAnimNode() == nil then
        return(GlobalMethod:ccp(0,0))
    end
	local size = self:getAnimation():getAnimNode():getContentSize()
	local heroCenter = CCPointMake(0.5*size.width, 0.5*size.height)
    if not self:getAnimation().m_bUseDragonBone then
        heroCenter = CCPointMake(0.5 * size.width, 0.75 * size.height)
    end
	local toParentTranf = self:getAnimation():getAnimNode():nodeToParentTransform()
	heroCenter=CCPointApplyAffineTransform(heroCenter,toParentTranf)
    
	return heroCenter
end

function WCharacter:getPetAttackPos()
   return self:getAnimationCenterPos()
end

--@brief    获取攻击中点坐标
--@return   #1:攻击中点坐标
function WCharacter:getAttackPos()
    local pos = self.m_tAttackPos or self:getAnimationCenterPos()
    return self.m_tAttackPos or self:getAnimationCenterPos()
end

--@brief    设置攻击中点坐标
function WCharacter:setAttackPos(pos)
    self.m_tAttackPos = pos
end

--@brief	获取子弹半径
--@return	#1:子弹半径
function WCharacter:getRadiusForBulletExplode()
    local exScale = 1
    if self.m_nWeaponId and GDatatab_item[self.m_nWeaponId] then
        local props = GDatatab_item[self.m_nWeaponId].property
        for _,data in pairs(props) do
            local propKey = 1
            local propVal = 0
            if type(data) == "table" then
                propKey = data[1]
                propVal = data[2]
            end
            if tonumber(propKey) == tonumber(PRO_RANGE) then
                exScale = propVal/100
            end
        end
    end

    exScale = exScale * self.m_fRadiusForBulletExplodeRate

    if self:getUseSkinBigSkill() and self:getSkinBigSkill() == 3033 then --守护光环特殊处理
        exScale = 0.7
    end

    local attrPer = BattleBuffMethod:getBuffValue(self,EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT, AttributeConfig.BrokeRange)
    WZLog("WCharacter:getRadiusForBulletExplode", tostring(self.m_fRadiusForBulletExplodeChange), tostring(self.m_fRadiusForBulletExplode), self.m_fRadiusForBulletExplodeRate, exScale, attrPer)
    if self.m_fRadiusForBulletExplodeChange then
        return math.ceil(self.m_fRadiusForBulletExplodeChange * exScale * (1+attrPer))
    else
        return math.ceil(self.m_fRadiusForBulletExplode * exScale * (1+attrPer))
    end
end

--@brief	设置子弹范围
--@param	radius:子弹
function WCharacter:setRadiusForBulletExplode(radius)
	self.m_fRadiusForBulletExplode = radius
end

--@brief    设置子弹范围系数
--@param    radius:子弹
function WCharacter:setRadiusForBulletExplodeRate(rate)
    self.m_fRadiusForBulletExplodeRate = rate
end

--@brief	获取子弹爆破半径
--@return	#1:子弹爆破半径
function WCharacter:getRectForBulletExplodeBomb(skillId)
    local scaleW = 1
    local scaleH = 1
    -- if self.m_nWeaponId and GDatatab_item[self.m_nWeaponId] then
        -- local scaleInfo = GDatatab_item[self.m_nWeaponId].explodeScale
        -- if scaleInfo and scaleInfo ~= -1 then
            -- scaleW = scaleInfo[1][1]/100
            -- scaleH = scaleInfo[1][2]/100
        -- end
    -- end
    if self.m_nWeaponId then
        local nWeaponId = string.gsub(self.m_nWeaponId,"id_","")
        local tmpScaleW,tmpScaleH = BattleCommon:readWeaponExplodeScale(nWeaponId)
        if tmpScaleW and tmpScaleH then 
            scaleW = tmpScaleW/100
            scaleH = tmpScaleH/100
        end
    end
    scaleW = scaleW * self.m_fRectForBulletExplodeBombRate.x
    scaleH = scaleH * self.m_fRectForBulletExplodeBombRate.y
    --
    local addPercent = BattleBuffMethod:getBuffValue(self,EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT, AttributeConfig.BlowUpRange)
    WZLog("WCharacter:getRectForBulletExplodeBomb", addPercent)
    scaleW = scaleW * (1 + addPercent)
    scaleH = scaleH * (1 + addPercent)

    local explodeBomb = nil
    local digHoleDirection = 0
    if skillId and skillId > -1 then
        local skillInfo = GDatatab_skill["id_"..skillId]
        local isChangeType = type(skillInfo.boom_scope)
        digHoleDirection = skillInfo.direction
        if isChangeType == "table" then
            explodeBomb = {x=skillInfo.boom_scope[1][1] * scaleW,y=skillInfo.boom_scope[1][2]*scaleH, digHoleDir = digHoleDirection}
        else
            explodeBomb = {x = self.m_fRectForBulletExplodeBomb.x * scaleW, y = self.m_fRectForBulletExplodeBomb.y*scaleH, digHoleDir = digHoleDirection}
        end
        WZLog("WCharacter:getRectForBulletExplodeBomb one", tostring(isChangeType), explodeBomb.x, explodeBomb.y)
    elseif self.m_fRectForBulletExplodeBombChange then
        explodeBomb = {x = self.m_fRectForBulletExplodeBombChange.x * scaleW, y = self.m_fRectForBulletExplodeBombChange.y*scaleH, digHoleDir = self.m_fRectForBulletExplodeBombChange.digHoleDir}
    else
        explodeBomb = {x = self.m_fRectForBulletExplodeBomb.x * scaleW, y = self.m_fRectForBulletExplodeBomb.y*scaleH, digHoleDir = digHoleDirection}
    end

    WZLog("WCharacter:getRectForBulletExplodeBomb two", tostring(self.m_fRectForBulletExplodeBombChange), tostring(self.m_fRectForBulletExplodeBomb), explodeBomb.x , explodeBomb.y)
    return explodeBomb
end

--@brief	设置子弹伤害范围
--@param	radius:子弹伤害
function WCharacter:setRectForBulletExplodeBomb(rect)
    self.m_fRectForBulletExplodeBomb = rect
end


--@brief	获取子弹爆破
--@return	#1:子弹爆破
function WCharacter:getBulletCilcle()
	return self.m_bulletCilcle
end

--@brief	获取运行状态
--@return	运行状态
function WCharacter:getRunStatus()
	return self.m_nRunStatus
end

--@brief	设置运行状态
--@param	nRunStatus:运行状态
function WCharacter:setRunStatus(nRunStatus)
	self.m_nRunStatus = nRunStatus
end

--@brief	获取移动控制对象
--@return	#1:WDMove移动控制对象
function WCharacter:getMover()
	return self.m_mover
end

--@brief	获取箭头的位置
--@return	table,位置
function WCharacter:getArrowPosition()
    --WZLog("WCharacter:getArrowPosition", self:getBattleId(), tostring(self:getAnimation():isFlipX()), self:getPosition().x)
    local tx,ty
    if self:getAnimation():isFlipX() == false then
        tx = self:getPosition().x + 0
    else
        tx = self:getPosition().x -12
    end
    ty = self:getPosition().y + self:getAnimation():getAnimNode():getContentSize().height + 35
	return {x = tx,y=ty}
end


--@brief	判断是否被冰冻
function WCharacter:getIsFrozen()
    local isFrozen = false
    for id,buff in pairs (self.m_tBuffChangeStateList) do
        if buff.m_nType == BuffType.FROZEN or buff.m_nType == BuffType.FROZEN_BOSS then
            isFrozen = true
        end
    end

	return isFrozen
end

--@brief	添加冰冻动画
function WCharacter:addFrozenAnimation()
	if self.m_frozenAnim == nil then
		self.m_frozenAnim = BattleAnimation:createAnimation(IWCO_BATTLEEFFECT)
		self.m_frozenAnim:addAnimation("frozen3",{},0.1,true)
		self.m_frozenAnim:play("frozen3",true)
		local size = self.m_anim:getAnimNode():getContentSize()
		self.m_frozenAnim:getAnimNode():setPosition(GlobalMethod:ccp(size.width*0.5,size.height*0.1))
		self.m_anim:getAnimNode():addChild(self.m_frozenAnim:getAnimNode())
	end
end

--@brief	添加死亡动画
function WCharacter:addDeadAnimation()
    if self.m_deadAnim == nil then
        self.m_deadAnim = BattleAnimation:createAnimation("skill_gwsw_hd", false)
        --self.m_deadAnim:getAnimNode():setUseAbsCoordinate(true)
        self.m_deadAnim:getAnimNode():setScale(1)
        local size = self.m_anim:getAnimNode():getContentSize()

        self.m_anim:getAnimNode():addChild(self.m_deadAnim:getAnimNode())
        self.m_deadAnim:getAnimNode():setPosition(GlobalMethod:ccp(size.width*0.5,size.height*0.3 + 50))
        self.m_deadAnim:play("hit",false)
        -- self.m_deadAnim:getAnimNode():setAbsPosition(GlobalMethod:ccp(size.width*0.5,size.height*0.2+ 200))
        -- self.m_deadAnim:getAnimNode():setAnimationName("0")
        -- self.m_deadAnim:getAnimNode():setLoop(false)
        -- self.m_anim:getAnimNode():addChild(self.m_deadAnim:getAnimNode())
    end
end

--@brief	移除死亡动画
function WCharacter:removeDeadAnimation()
    if self.m_deadAnim ~= nil then
        self.m_deadAnim:getAnimNode():removeFromParentAndCleanup(true)
        self.m_deadAnim = nil
    end
end

--@brief    冰冻动画
function WCharacter:updateFrozenAnimation()
    --冰冻状态
    local bIsFrozen = false 
    for index, buff in pairs (self.m_tBuffChangeStateList) do 
        if buff.m_nType == BuffType.FROZEN or buff.m_nType == BuffType.FROZEN_BOSS then
            bIsFrozen = true
        end
    end
    if bIsFrozen and self.m_bIsStopAnim == false then
        self.m_bIsStopAnim = true
        -- if self:getType() == 0 then
            self:getAnimation():pause()
        -- end 
    elseif bIsFrozen == false and self.m_bIsStopAnim then
        self.m_bIsStopAnim = false
        -- if self:getType() == 0 then
            self:getAnimation():resume()
            self:getAnimation():play(self:getNormalAnimationName(),true)
        -- end 
    end
end

--@brief    添加冰冻动画
function WCharacter:addFrozenAnimation2()
    if self.m_frozenAnim == nil then

    end
end

--@brief	移除冰冻动画
function WCharacter:removeFrozenAnimation()
    WZLog("WCharacter:removeFrozenAnimation", tostring(self.m_frozenAnim))
	if self.m_frozenAnim ~= nil then
		self.m_frozenAnim:getAnimNode():removeFromParentAndCleanup(true)
		self.m_frozenAnim = nil
	end
end

--@brief	添加怒气动画
function WCharacter:addAngerAnimation()
	if self.m_angerAnim == nil then

	end
end

--@brief	移除怒气动画
function WCharacter:removeAngerAnimation()
	if self.m_angerAnim ~= nil then
		self.m_angerAnim:getAnimNode():removeFromParentAndCleanup(true)
		self.m_angerAnim = nil
	end
end

--@brief    添加子弹跟踪动画
function WCharacter:addFollowAnimation()
    if self.m_followAnim == nil then
        self.m_followAnim = BattleAnimation:createAnimation("skills_zzd_sd",true)
        self.m_anim:getAnimNode():addChild(self.m_followAnim:getAnimNode())
        self.m_followAnim:play("0",true)
        local size = self.m_anim:getAnimNode():getContentSize()
        self.m_followAnim:getAnimNode():setPositionX(size.width*0.7)
        self.m_followAnim:getAnimNode():setPositionY(size.height*0.0)
    end
end

--@brief    移除子弹跟踪动画
function WCharacter:removeFollowAnimation()
    if self.m_followAnim ~= nil then
        self.m_followAnim:getAnimNode():removeFromParentAndCleanup(true)
        self.m_followAnim = nil
    end
end

--@brief	获取动画控制对象
--@return	#1:BattleAnimation动画控制对象
function WCharacter:getAnimation()
	return self.m_anim
end

--@brief	获取头像控制对象
--@return	#1:Animation动画控制对象
function WCharacter:getHeadAnimation()
	if self.m_headAnim then
		return self.m_headAnim:getAnimNode()
	else
		return nil
	end
end

--@brief	获取商城动画控制对象
--@return	#1:Animation动画控制对象
function WCharacter:getShopAnimation()
	return self.m_shopAnim:getAnimNode()
end

--@brief	获取胜利动画控制对象
--@return	#1:Animation动画控制对象
function WCharacter:getWinAnimation()
	hero.m_shopAnim:playTimes("room",0)
	return self.m_shopAnim:getAnimNode()
end

--@brief	获取失败动画控制对象
--@return	#1:Animation动画控制对象
function WCharacter:getLoseAnimation()
	hero.m_shopAnim:playTimes("lose",0)
	return self.m_shopAnim:getAnimNode()
end

--@brief	移动角色
--@param	nSpeedX:X速度
--@param	nSpeedY:Y速度
--@param	nAccX:X加速度
--@param	nAccY:Y加速度
--@return	#1:移动过程中是否与地图发生碰撞
function WCharacter:move(tSpeed, tAcceleration)
	WZLog("WCharacter:move")
	--设置初始速度及加速度
	if tSpeed ~= nil then
		--WZLog("WCharacter:move speed", tSpeed.x,tSpeed.y)
		self.m_mover:setMoverSpeed(Vector2:create(tSpeed.x,tSpeed.y))
	end
	if tAcceleration ~= nil then
		--WZLog("WCharacter:move acceleration", tAcceleration.x,tAcceleration.y)
		self.m_mover:setMoverAcceleration(Vector2:create(tAcceleration.x,tAcceleration.y))
	end

	--WZLog("WCharacter:move updatePostion", self.m_mover:getMoverAcceleration().x, self.m_mover:getMoverAcceleration().y)
	--更新角色位置
	self.m_mover:updatePostion()

	--判断碰撞并校正角色位置
	local isCollision,newPos,tangent = BattleMapManager:checkCollision(self.m_mover)
	if isCollision == true then
		self.m_mover:setMoverPosition(newPos)
		self.m_mover:setMoverRotate(BattleCommon:pointToAngle(tangent))
		self.m_mover:setMoverSpeed(Vector2:create(0,0))
	end

	--将位置信息同步到角色动画
	local posX,posY = self.m_anim:getAnimNode():getPosition()
	if BattleCommon:pointDis(self.m_mover:getMoverPosition(),{x = posX,y = posY}) > 1 then
		local vec2 = self.m_mover:getMoverPosition()
		self:setPosition(vec2)
		self.m_anim:getAnimNode():setRotation(BattleCommon:radiansToDegress(self.m_mover:getMoverRotate()))
	end

	self.m_bIsMoved = true
	return isCollision
end

--@brief	显示受伤动画
--@return 	#1:true,动画结束，false,动画还在进行中
function WCharacter:showHurt()
    --WZLog("WCharacter:showHurt")
	local standAnim = self:getNormalAnimationName()
	local hurtAnim = self:getHurtAnimationName()

	--是否可以开始播放受伤动画
	if self.m_nHurtStep == 0 then
        if self.m_nHurtRemain ~= true and #self:getHurtValueList() > 0 then
            self.m_nHurtRemain = true
        end

		if standAnim ~= nil and hurtAnim ~= nil then
            WZLog("WCharacter:showHurt 0", standAnim, hurtAnim, tostring(not self:getAnimation():isPlaying(standAnim)), tostring(not self:getAnimation():isPlaying(hurtAnim)))
			if (not self:getIsFrozen()) and (not self:getAnimation():isPlaying(standAnim)) and (not self:getAnimation():isPlaying(hurtAnim)) then
                WZLog("WCharacter:showHurt 1")
				return false
			else
				self.m_nHurtStep = 1
			end
		else
			self.m_nHurtStep = 1
		end
	--开始受伤
	else
		if self:getHurtValueList() == nil then
			--self.m_bIsHurt = false
            self:setMarkHurt(false,2)
            WZLog("WCharacter:showHurt 2")
			return true
		end
		--播放受伤动画和添加受伤数字
		if #self:getHurtValueList() > 0 then
            if self:isHide() then
                --self:endHide()
                --组队副本11Boss隐身，受到非buff伤害，结束隐身
                if self:isInBuffById(9013) and not self.m_tHurtValue.isSkillHurt and not self.m_tHurtValue.isBuffHurt then 
                    self:endHide()
                end
            end
            WZLog("WCharacter:showHurt 3", self.m_tHurtValue[1])
			self:_addHurtValue()
			self:_setRemainHP()
            
            if self:getHp() <= 0 and self.m_bIsDeadHurt == nil and self:isDead() ~= true then
            	self.m_bIsDeadHurt = true
            	if (self.m_bIsOldAnim == nil or self.m_bIsOldAnim == true) and self.m_tHurtValue[1] > 0 then
	                self:getAnimation():play(hurtAnim,false)
	            elseif self.m_bIsOldAnim == false and self:getAnimation():isPlaying(hurtAnim) == false and self.m_tHurtValue[1] > 0 then
	                self:getAnimation():play(hurtAnim,false)
	            end
            elseif self:getHp() > 0 then
	            if (self.m_bIsOldAnim == nil or self.m_bIsOldAnim == true) and self.m_tHurtValue[1] > 0 then
	                self:getAnimation():play(hurtAnim,false)
	            elseif self.m_bIsOldAnim == false and self:getAnimation():isPlaying(hurtAnim) == false and self.m_tHurtValue[1] > 0 then
	                self:getAnimation():play(hurtAnim,false)
	            end
	        end
            self:_doPercentThorns()
			if WBattleGlobal:getCurrent():getCurrentCharacter():getUseBigSkill() == true then
			end
			self:clearHurtValueList()
		end
		
		--受伤动画是否播放完毕
		if self:getIsFrozen() or self:getAnimation():isPlaying(hurtAnim) then
            --WZLog("WCharacter:showHurt X33",self:getAnimation():isCurrentAnimationDone(),self:getType(),self:getBattleId())
            local isDead = false
            if self:getIsFrozen() and self:getHp() <= 0 then
                isDead = true
            end
            if (self:getType() == 0 or self.m_bIsGuaiWithSuit)and (self:getAnimation():isCurrentAnimationDone() and self:getHp() <= 0  and WBattleGlobal:getCurrent():getCurrentCharacter():getBattleId() ~= self:getBattleId()) then
                isDead = true
            end
            if isDead then
                if WBattleGlobal:getCurrent():isSingleStage() and self:isDead() ~= true then
                    self:setDead(true,4)
                end
            elseif self:getIsFrozen() or (self:getAnimation():isCurrentAnimationDone()) then
                self:getAnimation():play(standAnim, true)
			else
                WZLog("WCharacter:showHurt 4")
				return false
			end
		end

		--等待受伤数字消失
		if not self:_isHurtNumAnimEnd() then
            WZLog("WCharacter:showHurt 5")
			return false
		end

		self:setHurtType(0)
		--self.m_bIsHurt = false
        self:setMarkHurt(false,6)
		self.m_nHurtStep = nil
		self.m_nFlyingNum = nil
		self.m_tHurtValue = nil
        self.m_nHurtRemain = nil
        self.m_nBeHurtTypeProfession = nil 
		--受伤动画完成回调函数
		self:endHurtAnimationCallback()
        WZLog("WCharacter:showHurt 6")
        -- --单人副本怪物死亡
        -- if WBattleGlobal:getCurrent():isSingleStage() then
        --     if self:getHp() == 0 and self:getType() ~= 0 then
        --         self:setDead(true,5)
        --     end
        -- end
        WZLog("WCharacter:showHurt 7")
		return true
	end
    WZLog("WCharacter:showHurt 8")
	return true
end

--@brief	受伤动画完成回调函数
--@note		供子类重载
function WCharacter:endHurtAnimationCallback()
end

--@brief 返回血量
--@param value < 0 加血
function WCharacter:getRealHpVal(value)
    if not value then
        return 0
    end
    
    if value >= 0 then
        return value
    end
    
    local recordValue = value
    if self:getHp() - recordValue > self:getMaxHp() then
        recordValue = -1 * (self:getMaxHp()  - self:getHp()) 
    end
    return recordValue
end

--@brief 伤害过滤
function WCharacter:isNeedOffHurt(shooter)
    if self.m_bOffHurt then
        return true
    end
    if shooter and shooter.m_nHurtOffState ~= -1 then
        WZLog("WCharacter:isNeedOffHurt", shooter.m_nHurtOffState)
        if shooter.m_nHurtOffState == EffectTargetType.HIT_ROLE then
            return true
        end

        if shooter.m_nHurtOffState == EffectTargetType.MYSELF and shooter:getBattleId() == self:getBattleId() then
            return true
        end

        if shooter.m_nHurtOffState == EffectTargetType.MYTEAM and WBattleGlobal:getCurrent():isSameTeam(shooter:getBattleId(),self:getBattleId()) then
            return true
        end

        if shooter.m_nHurtOffState == EffectTargetType.ENEMY and not WBattleGlobal:getCurrent():isSameTeam(shooter:getBattleId(),self:getBattleId()) then
            return true
        end
    end

    return false
end

--@brief 伤害效果处理（固定伤害 反转伤害）
function WCharacter:hurtEffectHandle(hurt, bIsThorns, tShootHero)
    if not bIsThorns then
        hurt = self:getHurtReverse(hurt, tShootHero)
    end

    WZLog("WCharacter:hurtEffectHandle", hurt, tostring(self:getIsInvincible()))
    if hurt < 0 then
        return hurt
    end
    --无敌
    if self:getIsInvincible() or self.m_bPlayerShief == true then
        return 1
    end
    --固定伤害
    if self:getBeHurtChangeValue() and self:getBeHurtChangeValue() > 0 then
        return self:getBeHurtChangeValue()
    end
    return hurt
end


--@brief	标记显示受伤
--@param	nHurtValue:受伤的值
--@param    tShootHero:攻击的英雄
--@param    isTransHurt:是否转移的伤害
--@param    skinSectionTotalHurt:皮肤大招分段总伤害
--@param    superCritMark:本次攻击是否超暴击  1触发超暴击，0没有触发
--@param    beatBackPetOwnerId:反击宠物所属玩家Id
--@param	isPetContinueAttack:是否宠物连击造成的伤害
--@param    bAddRoundHurt:是否已经计算过了
--@note		tShootHero:主要用于重写此接口的函数的扩展
function WCharacter:markHurt(nHurtValue,tShootHero,isSkillHurt,isPetHurt,isBuffHurt,hurtRatio, isTransHurt, skinSectionTotalHurt, superCritMark, beatBackPetOwnerId, isPetContinueAttack, bAddRoundHurt)
    local offHurt = self:isNeedOffHurt(tShootHero,nHurtValue)
    
    --当前回合伤害记录(单独伤--治疗弹使用 ,全部伤害--吸血)
    if nHurtValue ~= -1 and not isPetHurt and not isBuffHurt and not bAddRoundHurt then
        if tShootHero:getType() == 0 or tShootHero.m_nMonsterType == MonsterType.BUFF_TOTEM or tShootHero.m_nMonsterType == MonsterType.TREAT_TOTEM or tShootHero.m_nMonsterType == MonsterType.TREAT_ARRAY then
            self:addRoundHurt(nHurtValue)--人物治疗弹
        else
            tShootHero:addRoundHurt(nHurtValue) --怪物吸血
        end
    end

    --当前回合伤害记录,玩家吸血
    if nHurtValue ~= -1 and not isPetHurt and not isBuffHurt and not bAddRoundHurt then
        if tShootHero and not WBattleGlobal:getCurrent():isSameTeam(tShootHero:getBattleId(),self:getBattleId()) then
            tShootHero:addRoundHurt2(nHurtValue) --打敌人,自己加血
        end
        tShootHero:addRoundHurt3(nHurtValue) --打任何人,自己加血
    end

    WZLog("WCharacter:markHurt offHurt", nHurtValue, tostring(offHurt), self.m_nPlayerId, self:getType())

    if self:getType() == 1 and self.m_bIsGuaiWithSuit ~= true and nHurtValue > 0 and math.random(1,10) >=8 then
        if not self:getIsKid() and not self:getIsSubHero() then 
            local sound = getSoundByAttackType(2, self:getMonsterConfig().armatureName or self.m_sAniFileId or "")
            if sound then
                SoundManager:playEffectSound(sound)
            end
        end
    end
    --计算出手者的命中率
    if tShootHero ~= self and tShootHero ~= nil and tShootHero.m_bIsHitEnemy == false and nHurtValue ~= -1 then 
        tShootHero.m_bIsHitEnemy = true
        tShootHero:addHitTargetTimes()
    end

    --冰冻解除
    if nHurtValue ~= -1 and not isBuffHurt and not isPetHurt then
        if WBattleGlobal:getCurrent():isArenaPWStage() or WBattleGlobal:getCurrent():isArenaZLSStage() then
            if self.showAttackFace then
                self:showAttackFace(false)
            end
        end
    
        self:clearFrozenByHurt(tShootHero)

        if not self.m_bShowOffSkill then
            self.m_bShowOffSkill = true
            --被动免疫
            local offSkillList = self:getIsImmunityListByPetSkill(1,EffectTypeConfig.CHANGE_BEHURT_PERCENT)
            local offSkillList1 = self:getIsImmunityListByPetSkill(1,EffectTypeConfig.CHANGE_BEHURT_ADD_VALUE)
            local offSkillList2 = self:getIsImmunityListByPetSkill(2,EffectTypeConfig.CHANGE_BEHURT_PERCENT)
            for i,v in ipairs(offSkillList1) do
                table.insert(offSkillList,v)
            end
            WZLog("WCharacter:markHurt 111111",Serialize(offSkillList), #offSkillList2)
            if #offSkillList > 0 then
                BattlePetSkillManager:triggerPassiveSkillViewList(self,offSkillList)
            end
            if offSkillList2 and #offSkillList2 > 0 then 
                for i = 1, #offSkillList2 do
                    BattlePetSkillManager:triggerPetEquipSkillView(self, offSkillList2[i])
                end
            end
        end
    end
    --伤害过滤
    if offHurt then
        --触发暴击逻辑
        if tShootHero then 
            tShootHero:runSuperCritFunc(superCritMark)
        end
        return
    end

    --伤害转换
    nHurtValue = self:hurtEffectHandle(nHurtValue, nil, tShootHero)
    --添加天赋buff处理
    if tShootHero == nil or (tShootHero and tShootHero:getBattleId() ~= self:getBattleId()) then 
        nHurtValue = self:hurtInbornHandle(nHurtValue)
        --处理职业宠物反击技能
        if tShootHero and not isSkillHurt and not isPetHurt and not isBuffHurt and not isTransHurt and nHurtValue > 0 then 
            self:professionPetBackShootHandle(tShootHero, nHurtValue)
        end
    end

    --技能效果可以杀死玩家
    isSkillHurt = false
    local recordValue = self:getRealHpVal(nHurtValue)

    WZLog("WCharacter:markHurt", nHurtValue, tostring(tShootHero), tostring(isSkillHurt), tostring(isPetHurt))
	if nHurtValue ~= -1 and nHurtValue ~= 0 then
        if tShootHero and not WBattleGlobal:getCurrent():isSameTeam(tShootHero:getBattleId(),self:getBattleId()) then
            if nHurtValue > 0 then
                tShootHero.m_nShootHurtTotal = tShootHero.m_nShootHurtTotal + math.abs(nHurtValue)
                tShootHero.m_nCurRoundHurtTotal = tShootHero.m_nCurRoundHurtTotal + math.abs(nHurtValue)

                if tShootHero.m_nMaxRoundHurt < tShootHero.m_nCurRoundHurtTotal then 
                    tShootHero.m_nMaxRoundHurt = tShootHero.m_nCurRoundHurtTotal
                end
                GlobalGame:getBattleEventDispatcher():Dispatch(BATTLE_EVENT_TYPE.CHARACTER_MAX_HURT)
            end
        end

        if WBattleGlobal:getCurrent():isSingleStage() then
            --设置过程伤害记录
            if not isPetHurt and not isBuffHurt then
                --如果是皮肤大招的分段伤害，这里要加上处理，防止单人副本使用皮肤大招后校验不通过
                if tShootHero ~= nil and tShootHero:getUseSkinBigSkill() and (tShootHero:getSkinBigSkill() == 3009 or tShootHero:getSkinBigSkill() == 3010 or tShootHero:getSkinBigSkill() == 3012 or tShootHero:getSkinBigSkill() == 3013 or tShootHero:getSkinBigSkill() == 3020 or tShootHero:getSkinBigSkill() == 3021 or tShootHero:getSkinBigSkill() == 3022) then
                    if skinSectionTotalHurt then 
                        local recordValue1 = self:getRealHpVal(skinSectionTotalHurt)
                        WBattleGlobal:getCurrent():setHpProRecord(self:getBattleId(),-recordValue1,tShootHero,hurtRatio)
                    end
                else
                    WBattleGlobal:getCurrent():setHpProRecord(self:getBattleId(),-recordValue,tShootHero,hurtRatio)
                end
            end

            if isPetHurt then
                if beatBackPetOwnerId then 
                    WBattleGlobal:getCurrent():setPetHpProRecord(beatBackPetOwnerId,-recordValue,hurtRatio)
                elseif isPetContinueAttack then 
                    WBattleGlobal:getCurrent():setPetHpProRecord(self:getBattleId(),-recordValue,hurtRatio, isPetContinueAttack)
                else
                    WBattleGlobal:getCurrent():setPetHpProRecord(self:getBattleId(),-recordValue,hurtRatio)
                end
            end

            if isBuffHurt then
                WBattleGlobal:getCurrent():setBuffHurt(self:getBattleId(),id,-recordValue)
            end
            
            if tShootHero ~= nil and tShootHero:getBattleId() == self:getBattleId() and nHurtValue >= self:getHp() and not tShootHero:getIsKid() and not tShootHero:getIsSubHero() then
                nHurtValue = self:getHp() - 1
            end
            
            if self:getType() == 1 and not self:getIsKid() and tShootHero and tShootHero:getType() == 0 and not self:getIsSubHero() then 
                self:_postPlayerHitMonsterEvent()
            end
        end

        if nHurtValue < 0 then
            local recoveryAddPercent = self:getRecoveryAddPercent()
            nHurtValue = nHurtValue * (1+recoveryAddPercent)

            if recoveryAddPercent ~= 0 then
                local offSkillId = self:getIsImmunityByPetSkill(1,EffectTypeConfig.CHANGE_RECOVERY_PERCENT)
                if offSkillId then
                    BattlePetSkillManager:triggerPassiveSkillView(self,offSkillId, false)
                end
            end
            WZLog("WCharacter:markHurt 11", nHurtValue, recoveryAddPercent)
        end

        if tShootHero ~= self and tShootHero ~= nil and nHurtValue > 0 and self:getType() ~= 1 then
            local angerUp = math.ceil(nHurtValue / tShootHero.m_nAttack * 15)
            if WBattleGlobal:getCurrent():isDigGappingFighting() then 
                angerUp = angerUp * GlobalGame.g_nSpAddTimes
            end
            --计算怒气加成
            angerUp = BattleMethod:getSpAddValue(self, angerUp)
            if (self:getSp() + angerUp) >= 100 then
                self:setSp(100)
            else
                self:setSp(self:getSp() + angerUp)
            end
        end

        --职业伤害类型
        if tShootHero ~= self and tShootHero ~= nil and tShootHero:getProfessionId() > 0 and self:getProfessionId() > 0 and not isPetHurt and not isBuffHurt then
            self:setProfessionHurtType(tShootHero)
        end

        --触发超暴击逻辑
        if tShootHero then 
            tShootHero:runSuperCritFunc(superCritMark, nHurtValue)
        end
		--self.m_bIsHurt = true
        WZLog("WCharacter:showHurt Z")
        self:setMarkHurt(true,"z")
		if self.m_nFlyingNum == nil then
			self.m_nFlyingNum = 0
		end
		if self.m_nHurtStep == nil then
			self.m_nHurtStep = 0
		end
		if self.m_tHurtValue == nil then
			self.m_tHurtValue = {}
		end
        
        table.insert(self.m_tHurtValue, nHurtValue)

        if isSkillHurt then
            self.m_tHurtValue.isSkillHurt = true
        end

        if isPetHurt then
            self.m_tHurtValue.isPetHurt = true
            if beatBackPetOwnerId then 
                self.m_tHurtValue.beatBackPetOwnerId = beatBackPetOwnerId
            end
        end

        if isBuffHurt then
            self.m_tHurtValue.isBuffHurt = true
        end

        if isTransHurt then
            self.m_tHurtValue.isTransHurt = true
        end
        --反伤盾反伤
        if tShootHero ~= self and tShootHero ~= nil and nHurtValue > 0 and not isBuffHurt and not isTransHurt and (not isPetHurt or isPetHurt and not beatBackPetOwnerId) then
            self.m_tHurtValue.bDoPercentThorns = true
            self.m_tHurtValue.tShootHero = tShootHero
        end

        if tShootHero and tShootHero:getIsKid() then
            self.m_tHurtValue.isKidHurt = true
            self.m_tHurtValue.kidSkillId = tShootHero:getSkillId()
            self.m_tHurtValue.m_nOwnPlayerId = tShootHero:getOwnerPlayerId()
        elseif tShootHero and tShootHero:getIsSubHero() then 
            self.m_tHurtValue.isSoulHeroHurt = true
            self.m_tHurtValue.kidSkillId = tShootHero:getSkillId()
            self.m_tHurtValue.m_nOwnPlayerId = tShootHero:getOwnerPlayerId()
        end

--        WZLog("WCharacter:markHurt three", Serialize(self.m_tHurtValue))
        
        if tShootHero ~= nil and tShootHero:getType() == 0 then
            local idWhoSend = tShootHero:getBattleId()
            if self:getAI() ~= nil and self:getAI().m_tAiInterface ~= nil then
                if self:getAI().m_tAiInterface.m_tThreatList[idWhoSend] == nil then
                    self:getAI().m_tAiInterface.m_tThreatList[idWhoSend] = nHurtValue
                else
                    self:getAI().m_tAiInterface.m_tThreatList[idWhoSend] = self:getAI().m_tAiInterface.m_tThreatList[idWhoSend] + nHurtValue
                end
                WZLog("WCharacter:markHurt m_tThreatList", nHurtValue, self:getBattleId(), tShootHero:getBattleId())
            end
        end
	end
end

--@brief    处理傀儡师皮肤大招-傀儡链界,连锁buff伤害
function WCharacter:getSettlementHurt(nHurtValue,tShootHero,isSkillHurt,isPetHurt,isBuffHurt,hurtRatio, isTransHurt, skinSectionTotalHurt, superCritMark, beatBackPetOwnerId, isPetContinueAttack)
    --伤害转换
    nHurtValue = self:hurtEffectHandle(nHurtValue)
    --添加天赋buff处理
    if tShootHero == nil or (tShootHero and tShootHero:getBattleId() ~= self:getBattleId()) then 
        nHurtValue = self:hurtInbornHandle(nHurtValue)
    end
    if nHurtValue ~= -1 and nHurtValue ~= 0 then
        if WBattleGlobal:getCurrent():isSingleStage() then
            if tShootHero ~= nil and tShootHero:getBattleId() == self:getBattleId() and nHurtValue >= self:getHp() and not tShootHero:getIsKid() and not tShootHero:getIsSubHero() then
                nHurtValue = self:getHp() - 1
            end
        end
    end
    return nHurtValue
end

--@brief 宠物伤害
function WCharacter:addPetHurt(value)
    self.m_nShootHurtTotal = self.m_nShootHurtTotal + value
    self.m_nCurRoundHurtTotal = self.m_nCurRoundHurtTotal + value

    if self.m_nMaxRoundHurt < self.m_nCurRoundHurtTotal then 
        self.m_nMaxRoundHurt = self.m_nCurRoundHurtTotal
    end
    GlobalGame:getBattleEventDispatcher():Dispatch(BATTLE_EVENT_TYPE.CHARACTER_MAX_HURT)
end

--@brief 设置服务器死亡
function WCharacter:setServerDead(val)
    WZLog("WCharacter:setServerDead")
    self.m_bServerDead = val
end

--@brief 获得服务器死亡状态
function WCharacter:isServerDead(val)
    return self.m_bServerDead
end

--@brief	是否死亡
function WCharacter:isDead()
	-- WZLog("WCharacter:isDead")
    return self.m_bIsDead
end

--@brief	设置是否死亡
function WCharacter:setDead(bDead)
    WZLog("WCharacter:setDead",tostring(bDead))
    if self.m_bIsDead == bDead then
        return
    end
	self.m_bIsDead = bDead
	if bDead then
		self:setHp(0)
		self:getAnimation():play(self:getDeadAnimationName(),true)
		self:removeAngerAnimation()
        self:addDeadAnimation()

		self:clearAllBuff()
	end

    if self.m_bIsDead then
        self:showMonsterDialog300x(3001)
    end
end

--@breif 解冻
function WCharacter:clearFrozenByHurt(shootHero)
    if self:getIsFrozen() then
        for id,buff in pairs (self.m_tBuffChangeStateList) do
            if (buff.m_nType == BuffType.FROZEN or buff.m_nType == BuffType.FROZEN_BOSS) and (buff.m_nTurnTime ~= WBattleGlobal:getCurrent().m_nTurnTimes) then
                WZLog("WCharacter:clearFrozenByHurt")
                buff:removeAnime()
                self.m_tBuffChangeStateList[id] = nil
            end
        end
    end
end

--@brief   添加机关
function WCharacter:addMachine(machine)
    table.insert(self.m_tMachine,machine)
end
--@brief 获得机关
function WCharacter:getMachine(index)
    if self.m_tMachine then
        index = index or 1
        return self.m_tMachine[index]
    end
end


--@brief	获得受伤值
function WCharacter:getHurtValueList()
	return self.m_tHurtValue
end

--@brief	清空伤害数字
function WCharacter:clearHurtValueList()
	self.m_tHurtValue = {}
end

--@brief	从前面移除受伤值
function WCharacter:popFrontHurtValue()
	if #self.m_tHurtValue >= 1 then
		table.remove(self.m_tHurtValue,1)
	end
end

--@brief	设置伤害标记
--@param	bIsHurt：true：受伤，false：不受伤
function WCharacter:setMarkHurt(bIsHurt,note)
    WZLog("WCharacter:setMarkHurt",bIsHurt,note)
	self.m_bIsHurt = bIsHurt
end

--@brief	获得伤害标记
--@param	bIsHurt：true：受伤，false：不受伤
function WCharacter:getMarkHurt()
	return self.m_bIsHurt
end

--@brief 	设置人物等级
--@param 	level:等级
function WCharacter:setLevel(level)
	self.m_nLevel = level
end

--@brief 	获得人物等级
--@return 	#1, 返回人物当前等级
function WCharacter:getLevel()
	return self.m_nLevel
end

--@brief 	设置人物名称
--@param 	name:人物名称
function WCharacter:setPlayerName(name)
	self.m_sPlayerName = name
end

--@brief 	获得人物名称
--@return 	#1, 返回人物名称
function WCharacter:getPlayerName()
	return self.m_sPlayerName
end

--@brief 	设置英雄属于那一方
--@param 	camp:那一方
function WCharacter:setCamp(camp)
	self.m_nCamp = camp
end

--@brief 	获得英雄属于那一方
--@return 	返回英雄属于那一方
function WCharacter:getCamp()
	return self.m_nCamp
end

--@brief 	设置英雄排列
--@param 	campPos:排列
function WCharacter:setCampPosition(campPos)
	self.m_nCampPosition = campPos
end

--@brief 	获得英雄排列
--@return 	#1:返回英雄排列
function WCharacter:getCampPosition()
	return self.m_nCampPosition
end

--@brief 	获得英雄当前的位置
--@return 	#1, 返回当前的位置
function WCharacter:getPosition()
    if not self.m_anim then
        return GlobalMethod:ccp(0,0)
    end
	return self.m_anim:getPosition()
end

--@brief 	设置人物当前的位置
--@param 	tPos 当前位置
function WCharacter:setPosition(tPos)
	if self.m_mover ~= nil then
		self.m_mover:setMoverPosition(Vector2:create(tPos.x,tPos.y))
	end
	if self.m_anim ~= nil then
		self.m_anim:setPosition(Vector2:create(tPos.x,tPos.y))
	end
	if self.m_tPlayerNameInfoIcon ~= nil then
		self.m_tPlayerNameInfoIcon:updatePosition()
	end
    if self.m_drawNode ~= nil then 
        self.m_drawNode:setPosition(Vector2:create(tPos.x,tPos.y))
    end
end

--@brief	返回当前用户的称号
--@return 	#1,当前用户的称号
function WCharacter:getTitle()
	return self.m_sTitle
end

--@brief 	设置人物名称信息的显示
--@param 	tIcon 人物名称信息的显示
function WCharacter:setPlayerNameIcon(tIcon)
	self.m_tPlayerNameInfoIcon = tIcon
end

--@brief 	获得人物名称信息的显示
--@retrun 	#1, 人物名称信息的显示
function WCharacter:getPlayerNameIcon()
	return self.m_tPlayerNameInfoIcon
end

--@brief 	设置血量
--@param 	nHp 当前血量
function WCharacter:setHp(nHp)
    nHp = tonumber(nHp)
    if self.m_nHP == nHp then
        return
    end
    --[[
    if self.m_bIsSyncHp ~= 3 then
        return
    end
    --]]
    WZLog("WCharacter:setHp",self:getBattleId(), self.m_nHP, nHp)
    --nHp = nHp > self:getMaxHp() and self:getMaxHp() or nHp
    if self:getPlayerNameIcon() then
        self:getPlayerNameIcon().m_bIsHpActionDone = false
    end
	WBattleGlobal:getCurrent():checkIsCheat(self.m_nHP,self.m_nHP_Encrypt,4)
    self.m_nHPPre = self.m_nHP
	self.m_nHP = nHp
    self.m_nMarkHp = self.m_nHP
	self.m_nHP_Encrypt = BattleCommon:intEncrypt(self.m_nHP)
	if self.m_tPlayerNameInfoIcon ~= nil then
		--self.m_tPlayerNameInfoIcon:updateHp()
	end
	if self:getType() == 0 or self.m_nAiType ~= nil then
		WndBattleHud:updatePlayerHP(self:getBattleId())
	end
    GlobalGame:getBattleEventDispatcher():Dispatch(BATTLE_EVENT_TYPE.CHARACTER_CHANGE_HP,self)

    self:showMonsterDialog300x(3002)
end

--@brief 	设置怒气
--@param 	nSp 当前怒气
function WCharacter:setSp(nSp)
    nSp = nSp < 0 and 0 or nSp
	WBattleGlobal:getCurrent():checkIsCheat(self.m_nSP,self.m_nSP_Encrypt,5)
	self.m_nSP = nSp
	self.m_nSP_Encrypt = BattleCommon:intEncrypt(self.m_nSP)
	WndBattleHud:updatePlayerSp(self:getBattleId())
	if nSp >= 100 then
		self:addAngerAnimation()
	else
		--self:removeAngerAnimation()
	end
end

--@brief 	设置体力
--@param 	nPF 当前体力
function WCharacter:setPF(nPF)
    -- WZLog("WCharacter:setPF", self.m_nPF)
	WBattleGlobal:getCurrent():checkIsCheat(self.m_nPF,self.m_nPF_Encrypt,6)
	self.m_nPF = nPF
	self.m_nPF_Encrypt = BattleCommon:intEncrypt(self.m_nPF)
	WndBattleHud:updatePlayerPF(self:getBattleId())
end

--@brief 	设置英雄是否用大招
--@param 	bUseBigSkill 是否使用大招
function WCharacter:setUseBigSkill(bUseBigSkill)
	self.m_bUseBigSkill = bUseBigSkill
end

--@brief 	判断英雄是否用大招
--@return 	英雄是否使用大招
function WCharacter:getUseBigSkill()
	return self.m_bUseBigSkill
end

--@brief    设置英雄是否用皮肤大招
--@param    bUseSkinBigSkill 是否使用皮肤大招
function WCharacter:setUseSkinBigSkill(bUseSkinBigSkill)
    self.m_bUseSkinBigSkill = bUseSkinBigSkill
end

--@brief    判断英雄是否用皮肤大招
--@return   英雄是否使用皮肤大招
function WCharacter:getUseSkinBigSkill()
    return self.m_bUseSkinBigSkill
end

--@brief    获取英雄皮肤大招
function WCharacter:getSkinBigSkill()
    -- body
    return self.m_nBigSkinSkillType
end

--@brief    获取攻击特效爆炸效果
function WCharacter:getBlastEffect()
    return self.m_nBlastEffect
end

--@brief	CTB速率
function WCharacter:getCTBSpeed()
    local speed = (0.5 + 0.5 * self.m_nAgility / (self.m_nAgility + 1000)) * 2000

    local newSpeed = speed
    --buff速度属性改变对ctb速率的影响
    local attrVal = BattleBuffMethod:getBuffValue(self,EffectTypeConfig.CHANGE_ATTRIBUTE_VALUE,AttributeConfig.Agility)
    local attrPer = BattleBuffMethod:getBuffValue(self,EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT,AttributeConfig.Agility)
    newSpeed = newSpeed + attrVal
    newSpeed = newSpeed + (speed * attrPer)

    WZLog("WCharacter:getCTBSpeed", self.m_nAgility,speed,newSpeed,attrVal,attrPer)

    return newSpeed
end

function WCharacter:getFighting()
    return self.m_nFighting
end

function WCharacter:getFreezeCTB()
    local value = 0
    for id,buff in pairs (self.m_tBuffChangeStateList) do
        if buff.m_nType == BuffType.FROZEN or buff.m_nType == BuffType.FROZEN_BOSS or buff.m_nType == BuffType.BANISH then
            self.m_nFreezeCTB = buff.m_nTimeDurationValue - buff.m_nTimePassValue
            if self.m_nFreezeCTB > value then
                value = self.m_nFreezeCTB
            end
        end
    end
    WZLog("WCharacter:getFreezeCTB", self.m_nFreezeCTB)
    return value
end

--@brief	经过一回合后的英雄状态和属性更新
function WCharacter:updateByTurn()
    WZLog("WCharacter:updateByTurn", self:getBattleId())
	--大招状态重置
	self:setUseBigSkill(false)
    self:setUseSkinBigSkill(false)
	--更新体力
	self:setPF(self:getMaxPF())

	--Fly
	self.m_bUseFly = false
	self.m_bUseItemFly = false

	local myHero = WBattleGlobal:getCurrent():getMyHero()
	if self.m_nWaitFlyTime > 0 then
		self.m_nWaitFlyTime = self.m_nWaitFlyTime - 1
	end
	if WBattleGlobal:getCurrent():getMyHero() then
		local myHero = WBattleGlobal:getCurrent():getMyHero()
		if self:getBattleId() == myHero:getBattleId() then
            --回合数增加
            self.m_nAttackRound = self.m_nAttackRound + 1
            if self.m_nWaitFlyTime <= 0 then
                if self:isInBuffState(EffectTypeConfig.LIMIT_FLY) or
                    self:isInBuffState(EffectTypeConfig.LIMIT_ONLY_TIMES_SHOOT) or
                    self:isInBuffState(EffectTypeConfig.LIMIT_ONLY_TIMES_SHOOT_MOVE) or
                    self:isInBuffState(EffectTypeConfig.LIMIT_ONLY_SCATTER_TIMES_SHOOT) then
                        WndBattleHud:setMyFlyEnable(false)
                elseif self.m_nDebuffFlyLockRound==nil then
                    WndBattleHud:setMyFlyEnable(true)
                else
                    WndBattleHud:setMyFlyEnable(false)
                end
            end
		end
	end

	--计算玩家自己的回合
    if WBattleGlobal:getCurrent():getCurrentCharacterId() == self:getBattleId() then
        self.m_nPlayerTurnNumber = self.m_nPlayerTurnNumber + 1
    end

	self:setAttPercent(100)
	self:setCanFrozen(false)
	self:setCanFollow(false)
    self:setCanPenetrate(false)
	--世界boss相关
    self.m_nBuffInvincibleRound = nil

    if self.m_nBuffPowerUpRound ~= nil and self.m_nBuffPowerUpRound > 0 then
		self.m_nBuffPowerUpRound = self.m_nBuffPowerUpRound - 1
	end
    self.m_bIsAbsorb = nil
	self:updateBuff()
    self:buffAction()
    self.m_bIsAddSpInCurTurn = false

    self.m_tHitTargets = nil
    self.m_tBulletHitTargets = nil
    self.m_tBulletHitTargetsHurts = nil
    self.m_bWeaponAtomicBomb = nil
    self.m_nWeaponRepulseDis = nil
    self.m_nUseSkillState = nil
    self.m_tSkillTakeEffectList = nil
    self.m_tSkillTakeEffectInfo = nil
    self.m_tSkillTakeEffectIndex = nil
    self.m_tSkillTakeEffectCollionList = nil
    self.m_tSkillTakeEffectCollionInfo = nil
    self.m_tSkillTakeEffectCollionInfo2 = nil
    self.m_tSkillTakeEffectCollionIndex = nil
    self.m_tPetSkillTakeEffectInfo = nil
    self.m_fRadiusForBulletExplodeChange = nil
    self.m_tSkillTakeEffectAfterBleedInfo = nil --触发类型17(流血后)生效的技能id

    self.m_fRectForBulletExplodeBombChange = nil
    self.m_bIsUseSkill = nil
    self.m_bActiveAttack = false
    self.m_bActiveAttack2 = false                           --发射溅射子弹,哪吒大招有用到
    self.m_bIsPowerBomb = nil
    self.m_bIsPoisonBomb = nil
    self.m_bIsSilentBomb = nil
    self.m_bIsBindBomb = nil
    self.m_bIsTornadoBomb = nil
    self.m_bIsSpatterBomb = nil
    self.m_bIsMistBomb = nil
    self.m_bIsCureBomb = nil
    self.m_tIsTransferPosBomb = nil
    self.m_tIsEasyHurtBomb = nil
    self.m_bIsRepulse = nil
    self.m_bIsReadyShoot = nil
    self.m_bIsUseHide = false
    self.m_nSkillHurt = 0
    self.m_nActionTimes = 0
    self.m_nRecordRatio = 1 --战斗记录
    self:updateAttributeChangeStateByTurn()
    self:updateAbsorbAttributeStateByTurn()

    self.m_bPetActiveAttack = nil
    self.m_tActiveAttackPos = {}

    self.m_tSpatterPosList = {}           --溅射出来的子弹打击位置列表 哪吒大招有用到
    self.m_nSpatterPosIndex = 1           --溅射出来的子弹打击位置索引 哪吒大招有用到

    self.m_tActiveAttackSpeed = {}
    self.m_nIsSpatter = nil
    self.m_bIsCrit = nil
    self.m_tImmunityBuffList = {}
    self.m_tImmunityBuffList2 = {}
    self.m_tImmunityBuffList3 = {}
    self.m_bTornadoReflect = false
    if self.m_nMaxRoundHurt < self.m_nCurRoundHurtTotal then 
        self.m_nMaxRoundHurt = self.m_nCurRoundHurtTotal
        GlobalGame:getBattleEventDispatcher():Dispatch(BATTLE_EVENT_TYPE.CHARACTER_MAX_HURT)
    end
    self.m_nCurRoundHurtTotal = 0
    self.m_bIsHitEnemy = false
    self.m_tSkillTakeEffectKillList = nil
    self.m_tSkillTakeEffectKillInfo = nil
    self.m_tSkillTakeEffectKillIndex = nil
    self.m_nCurRoundCtbConsume = 0
    self.m_nPetAttackTimes = nil
    self.m_nPetShootIndex = 1  
    self.m_nHitSuperCritRectIndex = 0
    self.m_nRunPetBeatBackTimes = 0
    self.m_tPetBeatBackMsgList = nil 
    self.m_nSuperCritCount = 0

    self.m_tSkillTakeEffectEndRoundList = nil   
    self.m_tSkillTakeEffectSuperCritList = nil 
    g_nSuperCritHappenMark = -1
    self.m_nUsePoint = 0
    self.m_nRoundKillMonsterNum = 0
    self.m_bIsCalmBomb = nil 
    self.m_bIsSpeedBomb = nil 
    self.m_tPetEquipEffectTakeEffectInfo = nil 

    --召唤怪数据
    self.guaiBattleId = {}
    self.guaiId = {}
    self.guaiPositionX = {}
    self.guaiPositionY = {}
    self.devilOwnId = {}
    self.m_bIsDoShoot = false 
end

--@brief	每回合更新属性状态
function WCharacter:updateAttributeChangeStateByTurn()
	if self.m_tAttributeChangeStateList == nil then
		return
	end

	self.m_tAttributeChangeStateList = {}
    self.m_nCurRoundHurt = 0
    self.m_nCurRoundHurt2 = 0
    self.m_nCurRoundHurt3 = 0
    self.m_nHurtOffState = -1
end

--@brief    每回合更新吸取属性状态
function WCharacter:updateAbsorbAttributeStateByTurn()
    if self.m_tAbsorbAttributeList == nil then
        return
    end

    self.m_tAbsorbAttributeList = {}
end

function WCharacter:updateBuffByCTB(dt, updateCTB_time)
    local updateCtbValue = BattleCtbManager.m_tUpdateCtbValue and BattleCtbManager.m_tUpdateCtbValue[self:getBattleId()] or BattleCtbManager.m_nUpdateCTB_time
    WZLog("WCharacter:updateBuffByCTB zero", self:getBattleId(), self:getCTBSpeed(), updateCTB_time, BattleCtbManager.m_nUpdateCTB_time, BattleCtbManager.m_tUpdateCtbValue and BattleCtbManager.m_tUpdateCtbValue[self:getBattleId()])
    local bStopOtherBuff, _, buffTypeList = self:isInBuffState(EffectTypeConfig.LIMIT_STOP_CTB_BUFF)
    if dt ~= nil then
        for id,buff in pairs (self.m_tBuffChangeStateList) do
            --除了放逐等有LIMIT_STOP_CTB_BUFF效果的buff，其他停掉
            if not bStopOtherBuff or (bStopOtherBuff and utilsValueInTable(buff.m_nType, buffTypeList)) then 
                buff.m_nTimePassValue = buff.m_nTimePassValue + BattleCtbManager.SECOND_PER_CTB * dt
                WZLog("WCharacter:updateBuffByCTB one-1", self:getBattleId(), id, tostring(buff.m_nType), buff.m_nTimePassValue , buff.m_nTimeDurationValue, buff.m_nTimeIntervalValue)
                if updateCTB_time > updateCtbValue then
                    WZLog("WCharacter:updateBuffByCTB one-2", buff.m_nTimePassValue, (updateCTB_time - updateCtbValue) , updateCtbValue)
                    buff.m_nTimePassValue = buff.m_nTimePassValue - (updateCTB_time - updateCtbValue)
                end

                local count = math.floor(buff.m_nTimePassValue / buff.m_nTimeIntervalValue)
                local totalCount = math.floor(buff.m_nTimeDurationValue / buff.m_nTimeIntervalValue)
                if count > totalCount then
                    count = totalCount
                end
                local count2 = count - math.floor(buff.m_nTakeEffectCount)
                if buff.m_nTimeIntervalValue > -1 and count > buff.m_nTakeEffectCount and buff.m_nTakeEffectCount <= totalCount then
                    buff.m_nTakeEffectCount = buff.m_nTakeEffectCount + count2
                    if buff.m_nType == BuffType.BLOOD or buff.m_nType == BuffType.POISON or buff.m_nType == BuffType.BLOOD_BOSS or buff.m_nType == BuffType.SHAPE_RECOVERY or buff.m_nType == BuffType.RECOVERY_BUFF_ARRAY or buff.m_nType == BuffType.FIRE_TOTEM or buff.m_nType == BuffType.GUARDIAN_TOTEM or buff.m_nType == BuffType.MARITIME1_TOTEM or buff.m_nType == BuffType.MARITIME2_TOTEM or buff.m_nType == BuffType.MARITIME3_TOTEM or buff.m_nType == BuffType.JIANGZIYA_TOTEM or buff.m_nType == BuffType.UMBRELLA1_TOTEM or buff.m_nType == BuffType.THORNS_AURA_TOTEM then
                        for i=1, count2, 1 do
                            WZLog("WCharacter:updateBuffByCTB three-6", id, tostring(buff.m_nType), buff.m_nTakeEffectCountReal, buff.m_nTakeEffectCount, i, totalCount, count, count2)
                            BattleMethod:doBuffEffect(self,buff)
                        end
                    end
                    WZLog("WCharacter:updateBuffByCTB two-3", self:getBattleId(), id, tostring(buff.m_nTakeEffectCount), count, count2, buff.m_nTimeIntervalValue)
                    
                end

                WndBattleHud:updateBuffIcon(buff)

                if buff.m_nTimeDurationValue ~= -1 and buff.m_nTimePassValue >= buff.m_nTimeDurationValue then
                    WZLog("WCharacter:updateBuffByCTB three-3", self:getBattleId(), id, buff.m_nType)
                    self:removeBuffSpecialInfluence(buff)
                    buff:removeAnime()
                    self.m_tBuffChangeStateList[id] = nil
                end
            end
        end
    else
        for id,buff in pairs (self.m_tBuffChangeStateList) do
            if buff then
                --除了放逐等有LIMIT_STOP_CTB_BUFF效果的buff，其他停掉
                if not bStopOtherBuff or (bStopOtherBuff and utilsValueInTable(buff.m_nType, buffTypeList)) then 
                    buff.m_nTimePassValueReal = buff.m_nTimePassValueReal + updateCtbValue
                    if buff.m_nTimePassValueReal > buff.m_nTimeDurationValue then
                        buff.m_nTimePassValueReal = buff.m_nTimeDurationValue
                    end
                    WZLog("WCharacter:updateBuffByCTB three-1", self:getBattleId(), id, buff.m_nTimePassValueReal, self:getCTBSpeed())
                    buff.m_nTimePassValue = buff.m_nTimePassValueReal

                    if buff.m_nTimeIntervalValue > -1 then
                        buff.m_nTakeEffectCountReal = math.floor(buff.m_nTimePassValueReal / buff.m_nTimeIntervalValue)
                        
                        if buff.m_nType == BuffType.BLOOD or buff.m_nType == BuffType.POISON or buff.m_nType == BuffType.BLOOD_BOSS or buff.m_nType == BuffType.SHAPE_RECOVERY or buff.m_nType == BuffType.FIRE_TOTEM or buff.m_nType == BuffType.GUARDIAN_TOTEM or buff.m_nType == BuffType.MARITIME1_TOTEM or buff.m_nType == BuffType.MARITIME2_TOTEM or buff.m_nType == BuffType.MARITIME3_TOTEM or buff.m_nType == BuffType.JIANGZIYA_TOTEM or buff.m_nType == BuffType.UMBRELLA1_TOTEM or buff.m_nType == BuffType.THORNS_AURA_TOTEM then
                            for i=1, math.floor(buff.m_nTakeEffectCountReal) - math.floor(buff.m_nTakeEffectCount), 1 do
                                WZLog("WCharacter:updateBuffByCTB three-5", buff.m_nTakeEffectCountReal, buff.m_nTakeEffectCount, i)
                                BattleMethod:doBuffEffect(self,buff)
                            end
                        end

                        buff.m_nTakeEffectCount = buff.m_nTakeEffectCountReal
                        WZLog("WCharacter:updateBuffByCTB three-2", self:getBattleId(), id, tostring(buff.m_nTakeEffectCount))
                        
                    end

                    WndBattleHud:updateBuffIcon(buff)

                    if WBattleGlobal:getCurrent().m_nStartRoundPlayerId == self:getBattleId() then
                        if buff.m_nType == BuffType.FROZEN or buff.m_nType == BuffType.FROZEN_BOSS then
                            WZLog("WCharacter:updateBuffByCTB three-7")
                            buff:removeAnime()
                            self.m_tBuffChangeStateList[id] = nil
                        end
                    end

                    if buff.m_nTimeDurationValue ~= -1 and buff.m_nTimePassValue >= buff.m_nTimeDurationValue then
                        WZLog("WCharacter:updateBuffByCTB three-4", self:getBattleId(), id, buff.m_nType)
                        self:removeBuffSpecialInfluence(buff)
                        buff:removeAnime()
                        self.m_tBuffChangeStateList[id] = nil
                    end
                end
            end
        end
    end
end

--@brief   Buff无敌处理
function WCharacter:getBuffHurtNum(value)
    if not value or self:getIsInvincible() then
        return 1 
    end
    return value
end

--@brief	结束龙卷风Buff
function WCharacter:endTornado()
    WZLog("WCharacter:endTornado",WBattleGlobal:getCurrent().m_tMapEvents and BattleCommon:tableLen(WBattleGlobal:getCurrent().m_tMapEvents))
    if WBattleGlobal:getCurrent().m_tMapEvents ~= nil and BattleCommon:tableLen(WBattleGlobal:getCurrent().m_tMapEvents) > 0 then
        for i, v in pairs (WBattleGlobal:getCurrent().m_tMapEvents) do
            local event = WBattleGlobal:getCurrent().m_tMapEvents[i]
            if event and event.m_nCharaId == self:getBattleId() then
                event:destroy()
                WBattleGlobal:getCurrent().m_tMapEvents[i] = nil
            end
        end
    end
end

--@brief    获取是否处于buff状态
function WCharacter:isInBuffState(index, isLog)
--    if isLog then WZLog("WCharacter:isInBuffState one", self.m_nBattleId, index , #self.m_tBuffChangeStateList) end

    local parmLiSt = {}
    local buffTypeList = {}
    for id,buff in pairs (self.m_tBuffChangeStateList) do
        for id, effectParm in pairs (buff.m_nEffect) do
            local effect = effectParm[3] .. "_" ..effectParm[4]
--            if isLog then WZLog("WCharacter:isInBuffState two", self.m_nBattleId, index, effect) end
            if effect == index then
                --return true, effectParm
                table.insert(parmLiSt, effectParm)
                if not utilsValueInTable(buff.m_nType, buffTypeList) then 
                    table.insert(buffTypeList, buff.m_nType)
                end
            end
        end
    end
    if #parmLiSt > 0 then
        if parmLiSt[1][5] then
            table.sort(parmLiSt,function(a,b) return a[5]>b[5] end)
        end
--        if isLog then WZLog("WCharacter:isInBuffState three", self.m_nBattleId) end
        return true, parmLiSt[1], buffTypeList
    else
--        if isLog then WZLog("WCharacter:isInBuffState four", self.m_nBattleId) end
        return false
    end
end

--@brief    判断是否幻化回血
function WCharacter:getIsShapeRecovery()
    local isShapeRecovery = false
    for id,buff in pairs (self.m_tBuffChangeStateList) do
        if buff.m_nType == BuffType.SHAPE_RECOVERY then
            isShapeRecovery = true
        end
    end

    return isShapeRecovery
end

--@brief    获取攻击图腾等级
function WCharacter:getHurtBuffTotemInfo()
    for id,buff in pairs (self.m_tBuffChangeStateList) do
        if buff.m_nType == BuffType.HURT_BUFF_TOTEM then
            return buff.m_nID,buff.m_nLv, buff.m_tUser
        end
    end
    return 0,0,0
end

--@brief    获取加血法阵等级
function WCharacter:getBuffTreatArrayInfo()
    for id,buff in pairs (self.m_tBuffChangeStateList) do
        if buff.m_nType == BuffType.RECOVERY_BUFF_ARRAY then
            return buff.m_nID,buff.m_nLv
        end
    end
    return 0,0
end

--@brief    是否存在制定buffId
function WCharacter:isInBuffById(buffId)
    for id,buff in pairs (self.m_tBuffChangeStateList) do
        if buff.m_nID == buffId then
            return true
        end
    end
    return false
end

--@brief    是否存在指定buff
function WCharacter:isInBuffByType(buffType)
    local bIsInBuff = false
    for id,buff in pairs (self.m_tBuffChangeStateList) do
        if buff.m_nType == buffType then
            bIsInBuff = true
            break
        end
    end
    return bIsInBuff
end

--@brief	获取冰冻状态
function WCharacter:getFrozenState()
    local isFrozen, remainTime = nil, 0
    for id,buff in pairs (self.m_tBuffChangeStateList) do
        if buff.m_nType == BuffType.FROZEN or buff.m_nType == BuffType.FROZEN_BOSS then
            isFrozen = true
            local time = buff.m_nTimeDurationValue - buff.m_nTimePassValue
            if remainTime < time then
                remainTime = time
            end
        end
    end
    return isFrozen,remainTime
end

--@brief	经过一回合后的英雄状态和属性更新ByCTB
function WCharacter:updateByCTB()
    self:updateAttributeChangeStateByTurn()
    self:updateAbsorbAttributeStateByTurn()
    self.m_tImmunityBuffList = {}
    self.m_tImmunityBuffList2 = {}
    self.m_tImmunityBuffList3 = {}
    self.m_bShowOffSkill = false
    self.m_nHitSuperCritRectIndex = 0
    self.m_nCurRoundCtbConsume = 0
    self.m_tPetSkillTakeEffectInfo = nil
    self.m_tPetEquipEffectTakeEffectInfo = nil 
	--WZLog("WCharacter:updateByCTB", BattleCtbManager.m_nUpdateCTB_time, tostring(self.m_tAttributeChangeStateList))
	if BattleCtbManager.m_nUpdateCTB_time == 0 then
		return
	end

	if self.m_tSkillCdList ~= nil then
		for id, skill in pairs(self.m_tSkillCdList) do
			self.m_tSkillCdList[id] = self.m_tSkillCdList[id] - BattleCtbManager.m_nUpdateCTB_time
            self.m_tSkillCdList[id] = self.m_tSkillCdList[id] <= 0 and 0 or self.m_tSkillCdList[id]
            
            WZLog("WCharacter:updateByCTB one-1", id, skill, self.m_tSkillCdList[id], BattleCtbManager.m_nUpdateCTB_time)
            
			if self.m_tSkillCdList[id] <= 0 and not WBattleGlobal:getCurrent():isAudience() then
				WZLog("WCharacter:updateByCTB one-2")
				self.m_tSkillCdList[id] = nil
			end
		end
	end

    if self.m_tItemCdList ~= nil then
        for id, skill in pairs(self.m_tItemCdList) do
            self.m_tItemCdList[id] = self.m_tItemCdList[id] - BattleCtbManager.m_nUpdateCTB_time
            self.m_tItemCdList[id] = self.m_tItemCdList[id] <= 0 and 0 or self.m_tItemCdList[id]
            
            WZLog("WCharacter:updateByCTB one-3", id, skill, self.m_tItemCdList[id], BattleCtbManager.m_nUpdateCTB_time)
            
            if self.m_tItemCdList[id] <= 0 and not WBattleGlobal:getCurrent():isAudience() then
                WZLog("WCharacter:updateByCTB one-4")
                self.m_tItemCdList[id] = nil
            end
        end
    end

    if self.m_tKMSkillCdList ~= nil then
        for id, skill in pairs(self.m_tKMSkillCdList) do
            self.m_tKMSkillCdList[id] = self.m_tKMSkillCdList[id] - BattleCtbManager.m_nUpdateCTB_time
            self.m_tKMSkillCdList[id] = self.m_tKMSkillCdList[id] <= 0 and 0 or self.m_tKMSkillCdList[id]
            
            WZLog("WCharacter:updateByCTB one-3", id, skill, self.m_tKMSkillCdList[id], BattleCtbManager.m_nUpdateCTB_time)
            
            if self.m_tKMSkillCdList[id] <= 0 and not WBattleGlobal:getCurrent():isAudience() then
                WZLog("WCharacter:updateByCTB one-4")
                self.m_tKMSkillCdList[id] = nil
            end
        end
    end
end


--@brief	设置受伤时发送协议的id
function WCharacter:setHurtHeroId(nId)
	self.m_nHurtHeroId = nId
end

--@brief	添加一个buff
--@param	sBuffRound,roundValue,resetRoundValue,sBuffValue,buffValue,resetBuffValue,sAnimName:([1]:回合数变量名,[2]:回合数,[3]:回合重置值,[4]:改变的变量的名字,[5]:变量值,[6]:变量重置值,[7]:使用的动画)
function WCharacter:addBuff(sBuffRound,roundValue,resetRoundValue,sBuffValue,buffValue,resetBuffValue,sAnimName)
	if self[sBuffRound] == resetRoundValue then
		if self.m_tBuffUpdate == nil then
			self.m_tBuffUpdate = {}
		end
		table.insert(self.m_tBuffUpdate,{sBuffRound,resetRoundValue,sBuffValue,resetBuffValue,sAnimName})
	end

	if sBuffRound ~= nil then
		self[sBuffRound] = roundValue
	end

	if sBuffValue ~= nil then
		self[sBuffValue] = buffValue
	end

	if sAnimName ~= nil then
		if self.m_tHurtAnim == nil then
			self.m_tHurtAnim = {}
		end
		if self.m_tHurtAnim[sAnimName] == nil then
			local size = self:getAnimation():getAnimNode():getContentSize()
			self.m_tHurtAnim[sAnimName] = BattleAnimation:createAnimation(IWCO_BATTLEEFFECT)
			self.m_tHurtAnim[sAnimName]:addAnimation(sAnimName,{},0.2,true)
			self.m_tHurtAnim[sAnimName]:play(sAnimName,true)
			local anchor = self:getAnimation():getAnimNode():getAnchorPoint()
			local size = self:getAnimation():getAnimNode():getContentSize()
			local heroCenter = CCPointMake(anchor.x*size.width,anchor.y*size.height)
			self.m_tHurtAnim[sAnimName]:setPosition({x=heroCenter.x,y=heroCenter.y})
			self:getAnimation():getAnimNode():addChild(self.m_tHurtAnim[sAnimName]:getAnimNode())
		end
	end
end

--@brief	各种特效产生作用
function WCharacter:buffAction()
	--持续伤害
	if self.m_nDebuffHurtRound ~= nil and self.m_nDebuffHurtRound > 0 then
    	self:markHurt(self.m_nDebuffHurt, nil, true)

        if WBattleGlobal:getCurrent():isSingleStage() then

            local myHero = WBattleGlobal:getCurrent():getMyHero()
            local guaiList = WBattleGlobal:getCurrent():getGuaiList()
            local turnTimes = WBattleGlobal:getCurrent().m_nTurnTimes
            local record = WBattleGlobal:getCurrent().m_tBattleRecord[turnTimes]

            if myHero:getBattleId() == self:getBattleId() then
                record.playerSkillHurt = self.m_nDebuffHurt
            else
                local index = 0
                for i, v in pairs(guaiList) do
                    index = index + 1
                    if v:getBattleId() == self:getBattleId() then
                        record.guaiSkillHurt[index] = self.m_nDebuffHurt
                    end
                end
            end
        end

    	if self.m_nHurtHeroId ~= nil then
    		WBattleGlobal:getCurrent():sendHurtProtocol(self.m_nHurtHeroId,{[self:getBattleId()]=self},{[self:getBattleId()]=self.m_nDebuffHurt})
    	else
    		WBattleGlobal:getCurrent():sendHurtProtocol(self:getBattleId(),{[self:getBattleId()]=self},{[self:getBattleId()]=self.m_nDebuffHurt})
    	end

    end
    --疲劳
    if self.m_nDebuffTiredRound ~= nil and self.m_nDebuffTiredRound > 0 then
    	self:setPF(self:getMaxPF()+self.m_nDebuffTired)
    end
end

--@brief	各种buff更新
function WCharacter:updateBuff()
	if self.m_tBuffUpdate ~= nil then
		for i=#self.m_tBuffUpdate,1,-1 do
			local buff = self.m_tBuffUpdate[i]
			self[buff[1]] = self[buff[1]] - 1

			if self[buff[1]] <= 0 then
				if self[buff[1]] ~= buff[2] then
					self[buff[1]] = buff[2]
				end
				if self[buff[3]] ~= buff[4] then
					self[buff[3]] = buff[4]
				end
				--buff动画
				if self.m_tHurtAnim ~= nil and buff[5] ~= nil and self.m_tHurtAnim[buff[5]] ~= nil then
					self.m_tHurtAnim[buff[5]]:getAnimNode():removeFromParentAndCleanup(true)
					self.m_tHurtAnim[buff[5]] = nil
				end
				table.remove(self.m_tBuffUpdate,i)
			end
		end
		if #self.m_tBuffUpdate <= 0 then
			self.m_tBuffUpdate = nil
		end
	end
end

--@brief	清除各种buff
function WCharacter:clearAllBuff()
    for id,buff in pairs (self.m_tBuffChangeStateList) do
        self:removeBuffSpecialInfluence(buff)
        buff:removeAnime()
        self.m_tBuffChangeStateList[id] = nil
    end
end

--@brief	设置攻击威力比例值
--@param	fAttPercent,攻击威力比例值
function WCharacter:setAttPercent(fAttPercent)
	self.m_fAttPercent = fAttPercent
end

--@brief	获取攻击威力比例值
--@return	攻击威力比例值
function WCharacter:getAttPercent()
	return self.m_fAttPercent
end

--@brief	设置攻击次数
--@param	nAttTimes,攻击次数
function WCharacter:setAttTimes(nAttTimes,note)
    if nAttTimes ~= 1 then
        WZLog("WCharacter:setAttTimes", nAttTimes, tostring(note), self:getBattleId())
    end
	self.m_nAttTimes = nAttTimes
end

--@brief	设置散射子弹数
--@param	nAttScatterNum,散射子弹数
function WCharacter:setAttScatterNum(nAttScatterNum)
	self.m_nAttScatterNum = nAttScatterNum
end

--@brief	设置是否带冰冻效果
--@param	bCanFrozen,是否带冰冻效果
function WCharacter:setCanFrozen(bCanFrozen)
	self.m_bCanFrozen = bCanFrozen
end

--@brief	获取是否带冰冻效果
--@return	#1:true:是，false:否
function WCharacter:getCanFrozen()
	return self.m_bCanFrozen
end

--@brief	获取是否可以挖坑
--@return	#1:true:是，false:否
function WCharacter:getCanDigHole()
	return self:getLevel() >= GlobalGame.g_tPlayerInfo.nBlastLevel
end

--@brief	设置是否带追踪功能
--@param	bCanFollow,是否带追踪功能
function WCharacter:setCanFollow(bCanFollow)
	self.m_bCanFollow = bCanFollow
end

--@brief	获取是否带追踪功能
--@return	#1:true:是，false:否
function WCharacter:getCanFollow()
	return self.m_bCanFollow
end

--@brief    设置是否带穿透
--@param    bCanFollow,是否带穿透
function WCharacter:setCanPenetrate(bPenetrate)
    self.m_bCanPenetrate = bPenetrate
end

--@brief    获取是否带穿透
--@return   #1:true:是，false:否
function WCharacter:getCanPenetrate()
    return self.m_bCanPenetrate
end

--@brief 		播放准备射击动画
function WCharacter:playReadyShootAnim()
	if self:getUseBigSkill() then
		if self.m_nWeaponType == 0 then
			self:getAnimation():play(self:getActionName(9),false)
		else
			self:getAnimation():play(self:getActionName(11),false)
		end
	else
		if self.m_nWeaponType == 0 then
			self:getAnimation():play(self:getActionName(6),false)
		else
			self:getAnimation():play(self:getActionName(4),false)
		end
	end
end

--@brief 	播放正在射击动画
--@param	repeatTimes:重复次数(nil,0:不重复)
function WCharacter:playRepeatShootAnim(RepeatTimes)
	repeatTimes = repeatTimes or 0
	if self:getUseBigSkill() then
		if self.m_nWeaponType == 0 then
			self:getAnimation():play(self:getActionName(10),false)
		else
			self:getAnimation():play(self:getActionName(8),false)
		end
	else
		if self.m_nWeaponType == 0 then
			self:getAnimation():play(self:getActionName(7),false)
		else
			self:getAnimation():play(self:getActionName(5),false)
		end
	end
end

--@brief 	播放射击完毕动画
function WCharacter:playEndShootAnim()
	if self:getUseBigSkill() then
		if self.m_nWeaponType == 0 then
			self:getAnimation():play(self:getActionName(3),false)
		else
			self:getAnimation():play(self:getActionName(1),false)
		end
	else
		if self.m_nWeaponType == 0 then
			self:getAnimation():play(self:getActionName(2),false)
		else
			self:getAnimation():play(self:getActionName(1),false)
		end
	end
end

--@brief	检测角色是否在空中
--@return	#1:true,false
function WCharacter:isInAir()
	local prePos = self:getMover():getMoverPrePosition()
	local curPos = self:getMover():getMoverPosition()
	if math.abs(curPos.y - prePos.y) < 1 then
		return false
	else
		return true
	end
end

--@brief	检测移动碰撞
function WCharacter:checkCollision()
	local vec2 = Vector2:create(self:getMover():getMoverAcceleration().x,self:getMover():getMoverAcceleration().y+BattleConstants.g_nGravity.y)
	self:getMover():setMoverAcceleration(vec2)
	local bIsCollision = self:move()
	self.m_mover:setMoverSpeed(Vector2:create(0,self.m_mover:getMoverSpeed().y))
	vec2 = Vector2:create(self:getMover():getMoverAcceleration().x,self:getMover():getMoverAcceleration().y-BattleConstants.g_nGravity.y)
	self:getMover():setMoverAcceleration(vec2)
	return bIsCollision
end

--@brief	检测飞行碰撞
function WCharacter:checkCollisionInFly()
	--WZLog("WCharacter:checkCollisionInFly", self:getMover():getMoverSpeed().x, self:getMover():getMoverSpeed().y)
	local vec2 = Vector2:create(self:getMover():getMoverAcceleration().x,self:getMover():getMoverAcceleration().y+BattleConstants.g_nFlyGravity.y)
	self:getMover():setMoverAcceleration(vec2)
	local bIsCollision = self:move()
	vec2 = Vector2:create(self:getMover():getMoverAcceleration().x,self:getMover():getMoverAcceleration().y-BattleConstants.g_nFlyGravity.y)
	self:getMover():setMoverAcceleration(vec2)
	--WZLog("WCharacter:checkCollisionInFly2", self:getMover():getMoverSpeed().x, self:getMover():getMoverSpeed().y)
	return bIsCollision
end

--@brief	设置是否使用飞行
--@param	bUseFly,是否使用飞行
function WCharacter:setUseFly(bUseFly)
	self.m_bUseFly = bUseFly
end

--@brief	判断是否使用飞行
--@return	是否使用飞行
function WCharacter:isUseFly()
	return self.m_bUseFly
end

--@brief	设置是否使用道具飞行
--@param	bUseItemFly,是否使用道具飞行
function WCharacter:setUseItemFly(bUseItemFly)
	self.m_bUseItemFly = bUseItemFly
end

--@brief	判断是否使用了飞行道具
--@return	是否使用了飞行道具
function WCharacter:isUseItemFly()
	return self.m_bUseItemFly
end

--@brief	设置飞行禁用回合数
--@param	nWaitTime,飞行禁用回合数
function WCharacter:setWaitFlyTime(nWaitTime)
	self.m_nWaitFlyTime = math.max(self.m_nWaitFlyTime,nWaitTime)
end

--@brief	判断是否允许使用飞行
--@return	是否允许使用飞行
function WCharacter:canUseFly()
	return self.m_nWaitFlyTime <=0
end

--@brief	隐藏/显示碰撞区域
--@param	bIsShow:是否显示
function WCharacter:showCollisionRang(bIsShow)
	self.m_bIsShowRang = bIsShow
end

--@brief	清除碰撞区域
function WCharacter:clearCollisionRang()
	self.m_tCollisionRang = nil
    self.m_tSuperCritCollisionRange = nil 
	if self.m_tCollisionTable ~= nil then
		for i,tTable in pairs(self.m_tCollisionTable) do
			tTable:removeFromParentAndCleanup(true)
		end
	end
    if self.m_tSuperCritCollisionTable ~= nil then 
        for i, tTable in pairs(self.m_tSuperCritCollisionTable) do
            tTable:removeFromParentAndCleanup(true)
        end
    end
	self.m_tCollisionTable = nil
    self.m_tSuperCritCollisionTable = nil 
end

--@brief	获得碰撞范围
--@return 	#1:碰撞范围
function WCharacter:getCollisionRang()
    return self.m_tCollisionRang
end

--@brief    获得超暴击碰撞范围
--@return   #1:碰撞范围
function WCharacter:getSuperCritCollisionRang()
    --body
    return self.m_tSuperCritCollisionRange
end

--@brief	判断是否隐藏
function WCharacter:isHide()
    local isHide = false
    for id,buff in pairs (self.m_tBuffChangeStateList) do
        if buff.m_nType == 5 then
            isHide = true
        end
    end
	return isHide or self.m_bIsUseHide
end

--@brief    判断是否致盲
function WCharacter:isFog()
    local isHide = false
    for id,buff in pairs (self.m_tBuffChangeStateList) do
        if buff.m_nType == 24 then
            isHide = true
        end
    end
    return isHide
end

--@brief	结束隐藏
function WCharacter:endHide()
	self.m_nHideTurn = 0
    self.m_nHideOpecity = nil
    if self:getType() == 1 and self.m_bIsGuaiWithSuit == true  then
        BattleHeroUse:endHide(self:getBattleId())
    else
        BattleHeroUse:endHide(self:getBattleId())
    end
end

--@brief	改变隐藏回合
--@param 	nChangeTurnTime 增加或减少的隐藏回合数
function WCharacter:changeHideTurn(nChangeTurnTime)
	self.m_nHideTurn = self.m_nHideTurn + nChangeTurnTime
	if self.m_nHideTurn < 0 then
		self.m_nHideTurn = 0
	end
end

--@brief	重新设置隐藏回合
--@param 	nTurnTime 隐藏回合数
function WCharacter:setNewHideTurn(nTurnTime)
	self.m_nHideTurn = math.max(self.m_nHideTurn,nTurnTime)
end

--@brief	添加圆形碰撞范围
--@param 	radius:半径
--@param 	xOffset,yOffset:x,y偏移量
--@note		偏移量的参考点是character的中心点
function WCharacter:addCircleCollision(radius,xOffset,yOffset)
	if self.m_tCollisionRang == nil then
		self.m_tCollisionRang = {}
	end

	local tRang = CollisionRang:new()
	tRang.m_nType = 0
	tRang.m_fRadius = radius
	tRang.m_fXOffset = xOffset
	tRang.m_fYOffset = yOffset
	table.insert(self.m_tCollisionRang,tRang)

    --触发超暴击碰撞区域
    if self.m_tSuperCritCollisionRange == nil then 
        self.m_tSuperCritCollisionRange = {}
    end

    local tCritRang = CollisionRang:new()
    tCritRang.m_nType = 1
    tCritRang.m_fWidth = radius * 3
    tCritRang.m_fHeight = radius / 2
    tCritRang.m_fXOffset = 0
    tCritRang.m_fYOffset = radius * 3

    table.insert(self.m_tSuperCritCollisionRange, tCritRang)
end

--@brief	添加矩形碰撞范围
--@param 	width,height:宽高
--@param 	xOffset,yOffset:x,y偏移量
--@note		偏移量的参考点是character的中心点
function WCharacter:addRectCollision(width,height,xOffset,yOffset)
	if self.m_tCollisionRang == nil then
		self.m_tCollisionRang = {}
	end

	local tRang = CollisionRang:new()
	tRang.m_nType = 1
	tRang.m_fWidth = width 
	tRang.m_fHeight = height
	tRang.m_fXOffset = xOffset
	tRang.m_fYOffset = yOffset
	table.insert(self.m_tCollisionRang,tRang)

    --触发超暴击碰撞区域
    if self.m_tSuperCritCollisionRange == nil then 
        self.m_tSuperCritCollisionRange = {}
    end

    local tCritRang = CollisionRang:new()
    tCritRang.m_nType = 1
    tCritRang.m_fWidth = width * 1.5
    tCritRang.m_fHeight = width / 4
    tCritRang.m_fXOffset = xOffset
    tCritRang.m_fYOffset = yOffset + height + 50

    table.insert(self.m_tSuperCritCollisionRange, tCritRang)
end

--@brief	
--@return	
function WCharacter:getReduceHurt()
	return 1
end

--@brief 
function WCharacter:getNameLayerOffset()
    return {x = 0, y = 0}
end

--@brief    检测是否超出屏幕
--@return   #1:是否超出屏幕
--@return   #2:是否纵向超出屏幕
function WCharacter:checkIsOutOfScene()
    if self:getMover() == nil then
        return false, false
    end
    if SceneBattle:getFrontLayer() then
        local sceneSize = SceneBattle:getFrontLayerSize()
        local a = self:getMover():getMoverPosition()
        a = {x = a.x,y = a.y}
        
        --纵向超出屏幕
        if a.y < -100 or a.y > 10000 then
            return true, true
        --横向超出屏幕
        elseif a.x < -100 or a.x > sceneSize.width + 100 then
            return true, false
        end
    end
    return false, false
end

----------------------------------------------------------副本专用-------------------------------------------------
--@brief		开始行动
function WCharacter:startRound()
end

--@brief 		获得小怪列表
--@return		#1:小怪列表
--@note			提供boss重载,可返回空表
function WCharacter:getChildCharaList()
	return {}
end

--@brief 		根据id获得小怪
--@param		id:小怪id
--@return		#1:小怪表
--@note			提供boss重载,可返回空
function WCharacter:getChildCharaWithId(id)
	return nil
end

--@brief 		boss近距离攻击
--@param		leftRight : 1：左 0：右（向左还是向右）
--@note			提供boss重载
function WCharacter:receiveNearAttack(leftRight)
end

--@brief 		boss远距离射击
--@param  		参数与parse_BOSSMAPBATTLE_OtherShoot返回相同
--@note			提供boss重载
function WCharacter:receiveShoot(speedx, speedy, leftRight, startX, startY, playerCount, playerIds, curPositionX, curPositionY)
end

--@brief 		boss移动
--@param		nMoveCount:移动次数
--@param 		vnMoveStep:每次移动的方向
--@note			提供boss重载
function WCharacter:receiveMove(nMoveCount, vnMoveStep, curPositionX, curPositionY)
end

--@brief 		boss变身
--@param		nGuaiOldId:变身前Id
--@param 		nGuaiNewId:变身后Id
--@note			提供boss重载
function WCharacter:receiveBossChange(nGuaiOldId, nGuaiNewId)
end

--@brief 		创建小怪
--@param		guaiCount:小怪数量
--@param 		guaiBattleId:小怪战斗id
--@param		guaiId:小怪数据库id
--@param		guaiPositionX:小怪x位置
--@param		guaiPositionY:小怪y位置
--@note			提供boss重载
function WCharacter:receiveBuildXiaoGuai(guaiBattleId, guaiId, guaiPositionX, guaiPositionY)
end

--@brief 		游戏结束
--@param  		参数与parse_BOSSMAPBATTLE_GameOver返回相同
--@note			提供boss重载
function WCharacter:receiveGameOver(firstHurtPlayerId, winCamp, playerCount, playerIds, shootRate, totalHurt, killCount, beKilledCount, addExp, Exp, upgradeExp, nextUpgradeExp, star, eggCount, egg_playeId, egg_Item_Name, egg_item_icon, egg_ItemNum, pices)
end

--@brief 		某个角色死了
--@param  		参数与parse_BOSSMAPBATTLE_SomeOneDead返回相同
--@note			提供boss重载
function WCharacter:receiveSomeOneDead(deadPlayerCount, PlayerIds)
end

--@brief 		某个角色掉线
--@param  		参数与parse_BOSSMAPBATTLE_PlayerLose返回相同
--@note			提供boss重载
function WCharacter:receivePlayerLose(battleId, PlayerId)
end

--@brief 		某个角色重生
--@param  		参数与parse_BOSSMAPBATTLE_PlayerReborn返回相同
--@note			提供boss重载
function WCharacter:receivePlayerReborn(playercount, PlayerIds, postionX, postionY, guaicount, guaiBattleIds, guaipostionX, guaipostionY)
end

--@brief	删除buff特殊影响
function WCharacter:removeBuffSpecialInfluence(buff)
    if buff.m_nType == BuffType.HIDE then
        self:endHide()
    elseif buff.m_nType == BuffType.TORNADO then
        self:endTornado()
    end
    -- 副本死无敌效果清楚
    if self:getType() == 1 and buff.m_nID == 7004 then
        if math.floor(WBattleGlobal:getCurrent().m_tMakePairOk.mapId / 100) == 204 then
            self:showRealBloodView()
        end
    end
end

------------------------------------------------------------------------------------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function WCharacter:new()
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
-------------------------------------私有方法模块--------------------------------------
--@brief	添加受伤的数字
function WCharacter:_addHurtValue()

    --do return end
--    self.m_nHurtType = self.m_nHurtType == 2 and 1 or self.m_nHurtType

	local vPos = self:getAnimation():getPosition()
	--for i,value in pairs(self.m_tHurtValue) do
    local isBuffHurt = self.m_tHurtValue.isBuffHurt
    local nTimeInterval = self.m_tHurtValue.timeInterval

    for i = 1, #self.m_tHurtValue do
        value = self.m_tHurtValue[i]
        local hurtType = self.m_nHurtType
        if self.m_nHurtType ~= 2 then 
            if value < 100 then
                hurtType = 0
            end
        end

        if value < 0 then
            hurtType = 3
        end
        WZLog("WCharacter:_addHurtValue", value, hurtType)
        if hurtType ~= 3 then
            --触发龙胆赵云buff转移伤害,只扣1点血
            if self.m_tHurtValue.bDoPercentThorns then
                local bFlag = true
                local attacker = self.m_tHurtValue.tShootHero
                if attacker and (attacker:getType() == CharacterType.TYPE_KID or attacker:getIsSubHero()) then 
                    bFlag = false
                end
                --如果触发了命运回血，不进行职业反伤
                local fateCritRate = 0
                if attacker and attacker.getFateCritRate then 
                    fateCritRate = attacker:getFateCritRate(true)
                end
                if fateCritRate > 0 then
                    if not attacker:isFateCrit() then 
                        bFlag = false
                    end
                end
                if bFlag == true then
                    if self:getBattleId() ~= WBattleGlobal:getCurrent():getCurrentCharacterId() and self.m_tHurtValue[i] > 0 and not attacker:isDead() and (attacker.isBoom == nil or not attacker:isBoom()) then
                        if self:isTriggerZhaoYunBuff() then
                            if value > 1 then
                                value = 1
                            end
                        end
                    end
                end
            end
        end

        WZLog("WCharacter:_addHurtValue_One", value, hurtType)

		self.m_nFlyingNum = self.m_nFlyingNum + 1

        local name = string.format("conHurtType%d_HurtNumber",hurtType)
		local element = WZUISystem:getInstance():createElement(name)
		element:setLuaObjectIndex(self)
		if element ~= nil then
            if self.m_nHurtType == 2 and hurtType == 3 then 
                local imgSuperCritWord = GetElement(element, "imgSuperCritWord_HurtNumber", WZUIImage)
                if imgSuperCritWord then 
                    imgSuperCritWord:setVisible(true)
                end
            end
            GetElement(element,"txtHurtValue_HurtNumber",WZUILabelAtlasFont):setText(value)
			local conHurt = WZUIContainer:luaTo(element)

            local nHurtType = self:getProfessionHurtType()
            if nHurtType and nHurtType > 0 then 
                local pathProfessionHurt = {"ui/common/common_icon_kezhi.png", "ui/common/common_icon_beidi.png"}

                local imgProfessionHurt = createImage(pathProfessionHurt[nHurtType], GlobalMethod:ccp(1.1, 1.2), nil, true)
                local txtHurtValue = GetElement(element,"txtHurtValue_HurtNumber",WZUILabelAtlasFont)
                txtHurtValue:addChild(imgProfessionHurt, 1)

                self.m_nBeHurtTypeProfession = nil 
            elseif self.m_tHurtValue.isTransHurt then 
                local txtTransHurt = createLabel(LocalStrings.TRANS_HURT,GlobalMethod:ccp(0.44, 0.53),GlobalMethod:ccp(0.5,0.5),28,GlobalMethod:ccc3(255,227,116))
                if txtTransHurt then 
                    txtTransHurt:setEnableStroke(true)
                    txtTransHurt:setStrokeColor(GlobalMethod:ccc3(127,70,26))
                    txtTransHurt:setStrokeSize(2)
                    local txtHurtValue = GetElement(element,"txtHurtValue_HurtNumber",WZUILabelAtlasFont)
                    txtHurtValue:getParent():addChild(txtTransHurt, 1)
                end
            end

            local pos
            if WBattleGlobal:getCurrent().m_nAttackedCount and WBattleGlobal:getCurrent().m_nAttackedCount > 1 or #self.m_tHurtValue > 1 then
                pos = {x=vPos.x + math.random(200) - 80,y=vPos.y + math.random(80) + 62}
            else
                pos = {x=vPos.x + math.random(50) - 25,y=vPos.y + 52}
            end
            WZLog("WCharacter:_addHurtValue", value, hurtType, self.m_nHurtType, name)
			conHurt:setAbsPosition(GlobalMethod:ccp(pos.x,pos.y))
			SceneBattle:getFrontLayer():addChild(conHurt,1000)

            if isBuffHurt and self.m_nHideOpecity and self.m_nHideOpecity == 0 and value < 0 and self:getIsShapeRecovery() then
                conHurt:setVisible(false)
            end

            if not isBuffHurt and value > 0 then
                --傀儡师皮肤大招-傀儡链界,连锁buff
                local nSettlementHurt = value
                local chara = self
                if nSettlementHurt > 0 then
                    if chara:isInBuffByType(BuffType.CHAIN_BUFF) then
                        local tCharacterList = WBattleGlobal:getCurrent():getCharacterList()
                        for _, character in pairs(tCharacterList) do
                            if character:getBattleId() ~= chara:getBattleId() and character:getHp() > 0 and not character:isDead() and character:isInBuffByType(BuffType.CHAIN_BUFF) then
                                local buffTimes = character.m_tBuffAddTimes[BuffType.CHAIN_BUFF]
                                local bInBuff, tEffectParm = character:isInBuffState(EffectTypeConfig.CHAIN_OTHER_TWO)
                                local nTmpHurt = math.ceil(nSettlementHurt * tEffectParm[5] / 100)

                                local pos = BattleCommon:getPointTable(character:getPosition().x + 100,character:getPosition().y + 20)
                                local element = WZUISystem:getInstance():createElement(string.format("conHurtType%d_HurtNumber",0))
                                element:setLuaObjectIndex(self)
                                if element ~= nil then
                                    GetElement(element,"txtHurtValue_HurtNumber",WZUILabelAtlasFont):setText(nTmpHurt * -1)
                                    local conHurt = WZUIContainer:luaTo(element)
                                    conHurt:setAbsPosition(GlobalMethod:ccp(pos.x,pos.y))
                                    SceneBattle:getFrontLayer():addChild(conHurt,6)

                                    local curHp = character.m_nHP - nTmpHurt
                                    character:setHp(curHp)
                                end
                            end
                        end
                    end
                end
            end
		end
	end
end

--@brief	根据hurtlist设置剩余hp
function WCharacter:_setRemainHP()

	local remainHP = self:getHp()
    local oldHp = remainHP
    local oldExtraHP = 0 
    local remainExtraHP = 0 
    if self:getExtraHPBuff() then 
        remainExtraHP = self:getExtraHp()
        oldExtraHP = remainExtraHP
        if remainExtraHP > 0 then 
            for i = 1, #self.m_tHurtValue do
                value = self.m_tHurtValue[i]
                if value > 0 then 
                    if remainExtraHP >= value then 
                        remainExtraHP = remainExtraHP - value
                    else
                        remainHP = remainHP + remainExtraHP - value
                        remainExtraHP = 0
                    end
                else
                    remainHP = remainHP - value
                end
            end
        end
        self:setExtraHp(remainExtraHP)
    else
        for i = 1, #self.m_tHurtValue do
            value = self.m_tHurtValue[i]
            remainHP = remainHP - value
        end
    end


    remainHP = remainHP > self:getMaxHp() and self:getMaxHp() or remainHP
    WZLog("WCharacter:_setRemainHP two", oldHp, remainHP, tostring(self.m_tHurtValue.isPetHurt), self:getIsFrozen())

    local bIsPetHurt = self.m_tHurtValue.isPetHurt
    if self.m_tHurtValue.isPetHurt then
        self.m_tHurtValue.isPetHurt = nil
    end

    if oldHp <= 0 then
        return
    end

    if remainHP <= 0 then
        if WBattleGlobal:getCurrent():getCurrentCharacter():getBattleId() == self:getBattleId() and (not self.m_tHurtValue.isBuffHurt) and (not bIsPetHurt) and (not self.m_tHurtValue.isKidHurt) and (not self.m_tHurtValue.isSoulHeroHurt) then
            remainHP = 1
        else
            remainHP = 0
        end
    end
    self:setHp(remainHP)
     if remainHP <= 0 and self:isDead() ~= true then
        self:setDead(true,6)

        local currentPlayer = WBattleGlobal:getCurrent():getCharacterWithId(WBattleGlobal:getCurrent().m_nStartRoundPlayerId) or WBattleGlobal:getCurrent():getCurrentCharacter()
        WZLog("WCharacter:_setRemainHP three-1", self:getBattleId(), tostring(WBattleGlobal:getCurrent().m_nStartRoundPlayerId), tostring(currentPlayer and currentPlayer:getBattleId()), tostring(WBattleGlobal:getCurrent().m_bIsStartBattle), tostring(self.m_tHurtValue.isBuffHurt))

        if currentPlayer and currentPlayer:getBattleId() == self:getBattleId() and WBattleGlobal:getCurrent().m_bIsStartBattle and self.m_tHurtValue.isBuffHurt then
            local curRoundAction = WBattleGlobal:getCurrent().m_tCurRoundAction
            WZLog("WCharacter:_setRemainHP three-2", self:getBattleId(), tostring(curRoundAction and curRoundAction.round))
        end
    end
    if WBattleGlobal:getCurrent():isSingleStage() then
        if remainHP == 0 then
            local pos = self:getPosition()
            WBattleGlobal:getCurrent():killMonster(self:getId(),self:getBattleId(),GlobalMethod:ccp(pos.x,pos.y))
            --self:setDead(true)
            WZLog("WCharacter:_setRemainHP three_3", type(self.m_tHurtValue.isSkillHurt), type(bIsPetHurt), type(self.m_tHurtValue.isBuffHurt), WBattleGlobal:getCurrent().m_nSkillBeUseCurRound)
            if not self.m_tHurtValue.isSkillHurt and not bIsPetHurt and not self.m_tHurtValue.isBuffHurt then 
                WZLog("WCharacter:_setRemainHP three_4", WBattleGlobal:getCurrent().m_nSkillBeUseCurRound)
                local chara = WBattleGlobal:getCurrent():getCurrentCharacter()
                if self:getType() == 1 and chara:getType() ~= 1 and WBattleGlobal:getCurrent().m_nSkillBeUseCurRound and not self.m_tHurtValue.isKidHurt then 
                    chara:recordKillEnemySkills(WBattleGlobal:getCurrent().m_nSkillBeUseCurRound)
                elseif self:getType() == 1 and self.m_tHurtValue.isKidHurt then 
                    local charaKidOwner = WBattleGlobal:getCurrent():getCharacterWithId(self.m_tHurtValue.m_nOwnPlayerId)
                    if charaKidOwner then 
                        charaKidOwner:recordKillEnemyKidSkills(self.m_tHurtValue.kidSkillId)
                    end
                end
            end
            if not self.m_tHurtValue.isSkillHurt and not self.m_tHurtValue.isBuffHurt then 
                local chara = WBattleGlobal:getCurrent():getCurrentCharacter()

                if self:getType() == 1 and chara:getType() ~= 1 and not self.m_tHurtValue.isKidHurt then 
                    chara:setRoundKillMonsterNum()
                elseif self:getType() == 1 and self.m_tHurtValue.isKidHurt then 
                    local charaKidOwner = WBattleGlobal:getCurrent():getCharacterWithId(self.m_tHurtValue.m_nOwnPlayerId)
                    if charaKidOwner then 
                        charaKidOwner:setRoundKillMonsterNum()
                    end
                elseif self:getType() == 1 and isPetHurt and self.m_tHurtValue.beatBackPetOwnerId then 
                    local charaPetOwner = WBattleGlobal:getCurrent():getCharacterWithId(self.m_tHurtValue.beatBackPetOwnerId)
                    if charaPetOwner then 
                        charaPetOwner:setRoundKillMonsterNum()
                    end
                end
            end
        end
    end
    GlobalGame:getBattleEventDispatcher():Dispatch(BATTLE_EVENT_TYPE.CHARACTER_HURT,self,oldHp + oldExtraHP - remainHP - remainExtraHP)
    --WZLog("WCharacter:_setRemainHP three", self:getHp())

    --受击
    if self.m_tHurtValue then
        if not self.m_tHurtValue.isBuffHurt then
            for i, v in pairs (self.m_tHurtValue) do
                if type(v) == "number" then
                    self.m_nPlayerInjuredNumber = self.m_nPlayerInjuredNumber + 1
                end
            end
        end
    end
    self:showMonsterDialog300x(3003)

end



--@brief	判断受伤数字是否结束
--@return	#1:true,false
function WCharacter:_isHurtNumAnimEnd()
	return self.m_nFlyingNum <= 0 or self.m_nFlyingNum == nil
end

--@brief	伤害数字显示完成的回调
function WCharacter:_finishFlyingNum(element)
    WZLog("_finishFlyingNum", tostring(element))
	--local hero = WBattleGlobal:getCurrent():getCharacterWithId(heroID)
	element:removeFromParentAndCleanup(true)
	if self.m_nFlyingNum >= 1 then
		self.m_nFlyingNum = self.m_nFlyingNum - 1
	end
end

--@brief
--@return
function WCharacter:getReduceHurt()
    return self.m_nReduceHurt
end

--@brief
--@return
function WCharacter:setReduceHurt(nReduceHurt)
    self.m_nReduceHurt = nReduceHurt
end

--@brief
--@return
function WCharacter:getAutoStandAction()
    return self.m_bAutoStandAction
end

--@brief 设置自动切换待机动画
--@return
function WCharacter:setAutoStandAction(val)
    self.m_bAutoStandAction = val
end

--@brief 设置mover碰撞
function WCharacter:setMoveUpdatable(val)
    --飞行不设置碰撞ture
    if val and self.m_bIsAir then
        return
    end
    if self.m_mover then
        self.m_mover:setUpdatable(true)
    end
end
--@brief 获取被子弹攻击的目标点
function WCharacter:getShootTargetPos()
    local eOffset = GlobalMethod:ccp(self.m_anim:getAnimNode():getContentSize().width * 0, self.m_anim:getAnimNode():getContentSize().height * 0.3)
    local sPos = self.m_tStartPos
    local ePos = GlobalMethod:ccp(self:getPosition().x + eOffset.x,self:getPosition().y + eOffset.y)
    return ePos
end

--@brief 获得攻击回合
function WCharacter:getAttackRound()
    return self.m_nAttackRound
end

--@brief 获得玩家自己回合数
function WCharacter:getPlayerTurnNumber()
    return self.m_nPlayerTurnNumber
end

--@brief    获得是否超暴击
--@return   #1:true,false
function WCharacter:getCanSuperHit()
    return self.m_nSkillfull == 10000
end


--@brief 宠物免疫效果或buff
--@param effectType 0:buff 1:效果
--@param effectParam buff类型 或效果类型
function WCharacter:getIsImmunityByPetSkill(effectType,effectParam, effectParam2)
    if not self.m_tImmunityBuffList then
        return nil
    end

    for _,data in pairs(self.m_tImmunityBuffList) do
        local skillId = data.skillId
        local effectData = data.effectData
        WZLog("WCharacter:getIsImmunityByPetSkill",effectType,effectParam,tostring(effectParam2),effectData.type,effectData.param)
        --WCharacter:getIsImmunityByPetSkill       1          13_1          nil 
        --buff免疫
        if effectType == 0 and effectData.type == EffectTypeConfig.IMMUNITY_BUFF_ASSIGN and effectParam == effectData.param then
            return skillId
        end
        --效果免疫或减伤
        if effectType == 1 then
            if effectData.type == EffectTypeConfig.IMMUNITY_EFFECT_ASSIGN then
                if effectParam == effectData.param then
                    return skillId
                end
            elseif effectData.type == EffectTypeConfig.CHANGE_ATTRIBUTE_VALUE or effectData.type == EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT then
                if effectData.subType and effectParam2 == effectData.subType then
                    return skillId
                end
            else
                --减伤
                if effectData.type == effectParam then
                    if effectParam == EffectTypeConfig.CHANGE_BEHURT_PERCENT then 
                        if (effectData == nil or effectData and effectData.subType == nil) then --减伤百分比添加屏蔽到宠物装备减伤
                            return skillId, effectData
                        end
                    else
                        return skillId, effectData
                    end
                end
            end
        elseif effectType == 2 then --宠物装备减伤
            --减伤
            if effectData.type == effectParam and effectData and effectData.subType and effectData.subType == 1 then
                return effectData.propertyKey, effectData
            end
        end
    end

    return nil
end

--@brief 宠物免疫效果或buffList
--@param effectType 0:buff 1:效果
--@param effectParam buff类型 或效果类型
function WCharacter:getIsImmunityListByPetSkill(effectType,effectParam, effectParam2)
    local list = {}
    if not self.m_tImmunityBuffList then
        return list
    end

    for _,data in pairs(self.m_tImmunityBuffList) do
        local skillId = data.skillId
        local effectData = data.effectData
        WZLog("WCharacter:getIsImmunityByPetSkill",effectType,effectParam,tostring(effectParam2),effectData.type,effectData.param)
        --WCharacter:getIsImmunityByPetSkill       1          13_1          nil 
        --buff免疫
        if effectType == 0 and effectData.type == EffectTypeConfig.IMMUNITY_BUFF_ASSIGN and effectParam == effectData.param then
            table.insert(list, skillId)
        end
        --效果免疫或减伤
        if effectType == 1 then
            if effectData.type == EffectTypeConfig.IMMUNITY_EFFECT_ASSIGN then
                if effectParam == effectData.param then
                    table.insert(list, skillId)
                end
            elseif effectData.type == EffectTypeConfig.CHANGE_ATTRIBUTE_VALUE or effectData.type == EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT then
                if effectData.subType and effectParam2 == effectData.subType then
                    table.insert(list, skillId)
                end
            else
                --减伤
                if effectData.type == effectParam then
                    if effectParam == EffectTypeConfig.CHANGE_BEHURT_PERCENT then 
                        if (effectData == nil or effectData and effectData.subType == nil) then --减伤百分比添加屏蔽到宠物装备减伤
                            table.insert(list, skillId)
                        end
                    else
                        table.insert(list, skillId)
                    end
                end
            end
        elseif effectType == 2 then --宠物装备减伤
            --减伤
            if effectData.type == effectParam and effectData and effectData.subType and effectData.subType == 1 then
                table.insert(list, effectData.propertyKey)
            end
        end
    end
    
    return list
end

--@brief 添加宠物被动技能效果
--@param skillId 宠物技能id
--@param effectData = {type = xxx,param = xxxx} 免疫参数
function WCharacter:addImmunityPetSkill(skillId,effectData)
    WZLog("WCharacter:addImmunityPetSkill", skillId, Serialize(effectData))
    table.insert(self.m_tImmunityBuffList,{skillId = skillId,effectData = effectData})
end

function WCharacter:addRoundHurt(value)
    self.m_nCurRoundHurt = self.m_nCurRoundHurt + value
    WZLog("WCharacter:addRoundHurt",self.m_nCurRoundHurt)
end

--@brief    打出的伤害,用来处理技能吸血用,打敌人才加血 阿波罗皮肤大招有用到
function WCharacter:addRoundHurt2(value)
    self.m_nCurRoundHurt2 = self.m_nCurRoundHurt2 + value
end

--@brief    打出的伤害,用来处理技能吸血用,打任何人都加血 共生录不死灵药有用到
function WCharacter:addRoundHurt3(value)
    self.m_nCurRoundHurt3 = self.m_nCurRoundHurt3 + value
end

--@brief 读取怪物模板配置
function WCharacter:parseMonsterData()
    local monsterData =  BossData["id_"..self.m_nPlayerId]

    --数据表索引id
    self.m_nIndexId = monsterData.id
    --怪名字
    self.m_sPlayerName = monsterData.name
    --怪等级
    self.m_nLevel = tonumber(monsterData.level)--GlobalGame:checkGlobalPlayerLevel(monsterData.level) 
    --怪物真实等级
    self.m_nRealLevel = monsterData.level
    --行动类型
    self.m_nAction_type = monsterData.action_type > 0 and monsterData.action_type or 1 
    if monsterData.offHurt and monsterData.offHurt == 1 then
        self.m_bOffHurt = true
    end
    
    if monsterData.offRepulse and monsterData.offRepulse == 1 then
        self.m_bOffRepulse = true
    end

    if monsterData.limit and monsterData.limit == 1 then
        self.m_bOffFrozen = true
    end

    local scale = 1
    if monsterData.scale and monsterData.scale > 10 then
        scale = monsterData.scale/100
    end

    self.m_nScale = scale or 1
    --怪maxHP
    --怪攻击力
    --世界boss等级
  
    self.m_nHP = monsterData.hp
    self.m_nMaxHP = monsterData.hp
    self.m_nAttack = monsterData.attack
   
    --怪maxPF
    self.m_nMaxPF = monsterData.tili
    --怪性别
    -- monster.m_nBoyOrGirl = monsterData.sex
    --怪MaxSP
    self.m_nMaxSP = 0
    --怪HP
    -- monster.m_nHP = monsterData.hp
    -- monster.m_nHP_Encrypt = BattleCommon:intEncrypt(monster.m_nHP)
    --怪PF
    self.m_nPF = 100
    --怪SP
    self.m_nSP = 0
    -- --怪攻击力
    -- monster.m_nAttack = monsterData.attack
    -- monster.m_nAttack_Encrypt = BattleCommon:intEncrypt(monster.m_nAttack)
    --怪暴击倍率
    self.m_nCriticalhitAttackRate = monsterData.crit
    --怪防御
    self.m_nDefence = monsterData.defend
    --怪免伤
    self.m_nInjuryFree = monsterData.injury_free
    --怪破防值
    self.m_nWreckDefense = monsterData.wreck_defense
    --怪免暴
    self.m_nReduceCrit = monsterData.reduce_crit
    --怪免坑
    self.m_nReduceBury = monsterData.reduce_bury
    --怪大招类型
    self.m_nBigSkillType = monsterData.bigSkillType
    --怪转生等级
   
    self.m_nZSLevel = GlobalGame:checkGlobalPlayerZsleve(monsterData.level)

    --怪武器类型
    --monster.m_nWeaponType = monsterData.weapon_type
    --攻击相关
    self:setAttPercent(100)
    self:setAttTimes(1)
    self:setAttScatterNum(1)
    self:setCanFrozen(false)
    self:setCanFollow(false)
    self:setCanPenetrate(false)
    
    self.m_nPower = monsterData.force
    self.m_nArmor = monsterData.armor
    self.m_nConstitution = 0
    self.m_nAgility = monsterData.agility
    self.m_nLucky = monsterData.luck
    --子弹爆破配置
    self:setRadiusForBulletExplodeRate(monsterData.scope/100)
    self.m_fRectForBulletExplodeBombRate = {x = monsterData.boom_scope[1][1]/100,y =monsterData.boom_scope[1][2]/100}

    local bombInfo = GDatatab_skill.id_1001.boom_scope[1]
    self.m_fRectForBulletExplodeBomb = {x=bombInfo[1],y=bombInfo[2]}
    self.m_fRadiusForBulletExplode = bombInfo.scope

    --怪物类型
    self.m_nGuaiType = 1

    self.m_nAttackArea = monsterData.attackArea * 1
    self.m_tSkillItemList = monsterData.skill
    self.m_nHitRate = monsterData.mzl
    self.m_nPhysicalMax = monsterData.tili
    self.m_tDialogue = monsterData.dialogue
    self.m_tAiScript = -1
    
    self.m_nAiType = 6
    self.m_nBulletId = monsterData.bullet
    self.m_bPenetrate = monsterData.penetrate == 1
    self.m_sHeadId = self.m_sAniFileId
    self.m_nBuffAnimOffsetX = self:getConfig().buffAnimOffsetX
    self.m_nBuffAnimOffsetY = self:getConfig().buffAnimOffsetY
    self.m_tbulletPosOffset = self:getConfig().bulletPosOffset or {x=0,y=0}
    self.m_bIsOldAnim = self:getConfig().isSpine or false
    self.m_nFighting = monsterData.fighting
    self.m_tSkillParam = monsterData.tSkillParam
    self.m_nMonsterType = monsterData.type
end

--@brief 正常行动
function WCharacter:isNormalAct()
    if not self.m_nAction_type then
        return true
    end
    return self.m_nAction_type == MonsterActType.NORMAL
end

--@brief 跟随行动
function WCharacter:isFollowAct()
    if not self.m_nAction_type then
        return false
    end
    return self.m_nAction_type == MonsterActType.FOLLOW
end
--@breif 跟随独立行动
function WCharacter:isFollowIndependent()
    if not self.m_nAction_type then
        return false
    end
    return self.m_nAction_type == MonsterActType.FOLLOW_INDEPENDENT
end

--@brief 血槽不参与排序
function WCharacter:isOffSortName()
    return false
end

--@brief 播放动作
function WCharacter:play(actionName,isLoop)
    if self.m_anim then
        self.m_anim:play(actionName,isLoop)
    end
end

--@brief    获取动作名
function WCharacter:getActionName(id)
    local info = GDatatab_shape_animation["id_" .. id]
    local name

    if false and self.m_bIsMonster then
        name = info.monster_act
    else
        name = info.human_act
    end
    return name
end

--@brief 设置方向
function WCharacter:setLeftDirection(isLeft)
--    WZLog("setLeftDirection",tostring(isLeft),self:getType(),tostring(self:getAnimation():isFlipX()),tostring(self.m_bIsFilpX))
    if isLeft then
        --设置为朝右方向
        if self:getType() == 0 or self.m_bIsGuaiWithSuit or (WBattleGlobal:getCurrent():isDoubleTowerStage() and type(self.suitConfig) == "number" and self.suitConfig == 999) then
            if self:getAnimation():isFlipX() == true then
                self:getAnimation():setFlipX(false)
            end
        else
            if self.m_bIsFilpX == false then
                self.m_bIsFilpX = true
                self:getAnimation():setFlipX(true)
            end
        end
    else
        --设置为朝左方向
        if self:getType() == 0 or self.m_bIsGuaiWithSuit or (WBattleGlobal:getCurrent():isDoubleTowerStage() and type(self.suitConfig) == "number" and self.suitConfig == 999)then
            if self:getAnimation():isFlipX() == false then
                self:getAnimation():setFlipX(true)
            end
        else
            if self.m_bIsFilpX == true then
                self.m_bIsFilpX = false
                self:getAnimation():setFlipX(false)
            end
        end
    end
end

--@brief 瞄准线范围
function WCharacter:getAddPointLineVisibleRange()
    if not self.m_tAttributeChangeStateList.m_nPointLineValue then
        return 0,0
    end
    local result = self.m_tAttributeChangeStateList.m_nPointLineValue
    return result.range,result.rangeY
end
--@brief 瞄准线总数
function WCharacter:getAddPointLineCount()
    if not self.m_tAttributeChangeStateList.m_nPointLineValue then
        return 0
    end
    return self.m_tAttributeChangeStateList.m_nPointLineValue.count
end

--@brief    设置当前ctb
function WCharacter:setNowCtb(nNowCtb)
    -- body
    self.m_nNowCTB = nNowCtb

    local MAX_CTB = BattleCtbManager.MAX_CTB
    if self.m_nNowCTB > MAX_CTB then 
        self.m_nNowCTB = MAX_CTB
    end

--    BattleCtbManager:setCtb(self:getBattleId(), self.m_nNowCTB, true)
end

--@brief    获取当前的Ctb
--@param    nCharactorId : 
function WCharacter:getNowCtb(nCharactorId)
    -- body
    return BattleCtbManager:getCtb(nCharactorId)
end

--@brief    添加幽灵技能作用目标瞄准特效
function WCharacter:setTargetMark(bVisible)
    -- body
    WZLog("WCharacter:setTargetMark")
    local spineMark = self:getAnimation():getAnimNode():getChildByTag(1011)
    if spineMark and not bVisible then 
        spineMark:removeFromParentAndCleanup(true)
        return 
    end 
    WZLog("WCharacter:setTargetMark")
    
    spineMark = WZUISpine:create()
    spineMark:setTouchEnable(false)
    spineMark:setFileJson("battle/ui/ui_miaozhun.json")
    spineMark:setFileAtlas("battle/ui/ui_miaozhun.atlas")
    spineMark:play("ui_miaozhun_1", false) 
    spineMark:setScale(1.1)
    spineMark:setUseOriginSize(true)
    spineMark:setRelativePosition(GlobalMethod:ccp(0.55, 1.15))
    spineMark:setVisible(bVisible or false)

    spineMark:setTag(1011)
    if self.m_nHideOpecity then 
        spineMark:setOpacity(self.m_nHideOpecity)
    end
    self:getAnimation():getAnimNode():addChild(spineMark)
end

--@brief    设置龙卷风限制移动参数
--@param    bIndex : 0->左右都可以移动；1->不可以向左移动；2->不能向右移动
function WCharacter:setStopMoveByTornado(bIndex)
    -- body
    self.m_nStopByTornado = bIndex
end

--@brief    获取职业Id
function WCharacter:getProfessionId()
    -- body
    return self.professionId or 0
end

--@brief    设置受伤类型
function WCharacter:setProfessionHurtType(shootHero)
    -- body
    if self.professionId <= 0 then return end 
    if shootHero and shootHero.m_tProfessionSkills and self.m_nBeHurtTypeProfession == nil then 
        for i = 1, shootHero.m_tProfessionSkills.count do
            if shootHero.m_tProfessionSkills.skill_type[i] == 1 and shootHero.m_tProfessionSkills.attribute[i][1][1] == self.professionId and shootHero.m_tProfessionSkills.node[i] == 5 then 
                self.m_nBeHurtTypeProfession = 1
                break 
            end
        end
        if self.m_nBeHurtTypeProfession == nil then 
            for i = 1, self.m_tProfessionSkills.count do
                if self.m_tProfessionSkills.skill_type[i] == 1 and self.m_tProfessionSkills.attribute[i][1][1] == shootHero:getProfessionId() and self.m_tProfessionSkills.node[i] == 0 then 
                    self.m_nBeHurtTypeProfession = 2
                    break 
                end
            end
        end
    end
end

--@brief    获取职业受伤类型
function WCharacter:getProfessionHurtType()
    -- body
    return self.m_nBeHurtTypeProfession
end

--@brief    增加使用道具的次数
function WCharacter:addUseItemTimes()
    self.m_nUseItemTimes = self.m_nUseItemTimes + 1
    WZLog("WCharacter:addUseItemTimes",self.m_nUseItemTimes)
    GlobalGame:getBattleEventDispatcher():Dispatch(BATTLE_EVENT_TYPE.CHARACTER_USEITEM_TIMES)
end

--@brief    增加命中的次数
function WCharacter:addHitTargetTimes()
    self.m_nHurtRoundNum = self.m_nHurtRoundNum + 1
    WZLog("WCharacter:addHitTargetTimes",self.m_nHurtRoundNum)
    GlobalGame:getBattleEventDispatcher():Dispatch(BATTLE_EVENT_TYPE.CHARACTER_HIT_RATE)
end

--@brief    记录战斗中使用的技能和道具
--@param    id: 使用的技能或道具Id
function WCharacter:recordUsedSkillsAndItems(id)
    -- body
    if self.m_tUsedSkillAndItemList == nil then self.m_tUsedSkillAndItemList = {} end

    if not utilsValueInTable(id, self.m_tUsedSkillAndItemList) then 
        table.insert(self.m_tUsedSkillAndItemList, id)
    end

    --辅助技能不派发事件
    local skillData = GDatatab_skill["id_" .. id]
    if skillData and (skillData.skill_type == 6 or skillData.skill_type == 7) then return end 
    GlobalGame:getBattleEventDispatcher():Dispatch(BATTLE_EVENT_TYPE.CHARACTER_NOTUSE)
end

--@brief    记录战斗中杀死对手的技能
--@param    id: 使用的技能Id
function WCharacter:recordKillEnemySkills(id)
    -- body
    if self.m_tKillEnemySkill == nil then self.m_tKillEnemySkill = {} end

    if not utilsValueInTable(id, self.m_tKillEnemySkill) then 
        table.insert(self.m_tKillEnemySkill, id)
    end

    --辅助技能不派发事件
    local skillData = GDatatab_skill["id_" .. id]
    if skillData and (skillData.skill_type == 6 or skillData.skill_type == 7) then return end 

    GlobalGame:getBattleEventDispatcher():Dispatch(BATTLE_EVENT_TYPE.CHARACTER_USE_KILL)
end

--@brief    记录战斗中杀死对手的小孩技能
--@param    id: 使用的技能Id
function WCharacter:recordKillEnemyKidSkills(id)
    -- body
    if id == nil or id <= 0 then return end 
    --辅助技能不派发事件
    local skillData = GDatatab_skill["id_" .. id]
    if skillData and skillData.skill_type ~= 6 then return end 

    if self.m_tKillEnemyKidSkill == nil then self.m_tKillEnemyKidSkill = {} end

    if not utilsValueInTable(id, self.m_tKillEnemyKidSkill) then 
        table.insert(self.m_tKillEnemyKidSkill, id)
    end

    GlobalGame:getBattleEventDispatcher():Dispatch(BATTLE_EVENT_TYPE.CHARACTER_USEKID_KILL)
end

--@brief    获取最大伤害
function WCharacter:getMaxHurt()
    -- body
    return self.m_nMaxRoundHurt
end

--@brief    获取命中率
function WCharacter:getHitRate()
    -- body
    return math.floor(self.m_nHurtRoundNum/self:getAttackRound() * 100)
end

--@brief    获取使用道具次数
function WCharacter:getUseItemTimes()
    -- body
    return self.m_nUseItemTimes
end

--@brief    获取使用过的技能道具列表
function WCharacter:getUseSkillAndItemList()
    -- body
    return self.m_tUsedSkillAndItemList
end

--@brief    获取杀死敌人的技能Id列表
function WCharacter:getKillEnemySkills()
    -- body
    return self.m_tKillEnemySkill
end

--@brief    获取本体Id
function WCharacter:getDevilOwnId()
    -- body
    return self.m_nDevilOwnId
end

--@brief    获取是否是心魔
function WCharacter:isDevilGuai()
    -- body
    if self:getDevilOwnId() and self:getDevilOwnId() > 0 then 
        return true 
    end

    return false 
end

--@brief    设置飞行速度
--@param    speed:加速度
function WCharacter:setFollowBulletSpeed(speed)
    WZLog("WCharacter:setFollowBulletFly", speed.x, speed.y)
    self.m_tRepulseSpeed = speed
end

--@brief    获取飞行速度
--@param    speed:加速度
function WCharacter:getFollowBulletSpeed()
    return self.m_tRepulseSpeed
end

--@brief    获取当前回合消耗的ctb
function WCharacter:getCurrentRoundCtbConsume()
    -- body
    return self.m_nCurRoundCtbConsume or 0
end

--@brief    判断是否封印宠物
function WCharacter:isPetSeal()
    local isSeal = false
    for id,buff in pairs (self.m_tBuffChangeStateList) do
        if buff.m_nType == BuffType.PETSEAL then
            isSeal = true
        end
    end
    return isSeal 
end

--@brief    获取宠物连击次数
function WCharacter:getPetAttackTimes()
    -- body
    return self.m_nPetAttackTimes
end

--@brief    如果收到致命伤害，判断会不会触发保命
function WCharacter:_isActiveSaveLifeSkill(nHurt)
    -- body
    local nCurHp = self:getHp()

    WZLog("WCharacter:_isActiveInbornSkill", nCurHp, nHurt, self:getId())
    if nHurt > 0 and nHurt >= nCurHp then 
        local skillId, effectData = self:getIsImmunityByPetSkill(1, EffectTypeConfig.PROFESSION_SAVELIFE_PERCENT_TWO)
        WZLog("WCharacter:_isActiveInbornSkill one", type(skillId))
        local tTempData = nil  
        if skillId == nil then 
            skillId, effectData = self:getIsImmunityByPetSkill(1, EffectTypeConfig.PROFESSION_SAVELIFE)
            WZLog("WCharacter:_isActiveInbornSkill two", type(skillId))
            if skillId == nil then 
                skillId, effectData = self:getIsImmunityByPetSkill(1, EffectTypeConfig.PROFESSION_SAVELIFE_PERCENT)
            end
        else
            tTempData = effectData  
        end
        if skillId then 
            if self.m_tSkillHappenTimes == nil then 
                self.m_tSkillHappenTimes = {}
            end
            if self.m_tSkillHappenTimes[skillId] == nil then self.m_tSkillHappenTimes[skillId] = 0 end
            if self.m_tSkillHappenTimes[skillId] >= effectData.maxTimes then return end 
            self.m_tSkillHappenTimes[skillId] = self.m_tSkillHappenTimes[skillId] + 1
            WZLog("WCharacter:_isActiveInbornSkill 222", skillId, nTimes)
            BattleProfessionSkillManager:triggerPassiveSkillView(self, skillId, tTempData)
            return effectData
        end
    end

    return nil 
end

--@brief    致命伤害处理
function WCharacter:hurtInbornHandle(hurt)
    -- body
    --判断是否会触发天赋坚韧
    local effectData = self:_isActiveSaveLifeSkill(hurt)
    WZLog("WCharacter:hurtInbornHandle hhhh", type(effectData) ~= "nil" and effectData or "nil")
    if effectData then
        if effectData.type == EffectTypeConfig.PROFESSION_SAVELIFE then    --保留一点生命
            return self:getHp() - effectData.hp
        elseif effectData.type == EffectTypeConfig.PROFESSION_SAVELIFE_PERCENT or effectData.type == EffectTypeConfig.PROFESSION_SAVELIFE_PERCENT_TWO then    --保留最大生命的百分比
            return self:getHp() - math.floor(self:getMaxHp() * effectData.hp/100)
        end
    end

    return hurt 
end

--@brief    使用道具时候触发获得一个使用过的道具
function WCharacter:isActiveGetPropItemSkill(itemId)
    -- body
    if itemId == nil or itemId <= 0 then return end 
    
    local skillId, effectData = self:getIsImmunityByPetSkill(1, EffectTypeConfig.PROFESSION_RANDOM_ITEMPROP)
    local skillItemInfo = GDatatab_skill["id_" .. itemId]
    if skillItemInfo then
        if self:isDead() or skillId == nil or skillItemInfo.skill_type ~= 1 then 
            return 
        end 
    end
    if not utilsValueInTable(itemId, self.m_tBringInItems) then return end 
    --获取使用过的道具
    local usedItemList = {}
    for i = 1, #self.m_tUsedSkillAndItemList do
        local tempItemInfo = GDatatab_skill["id_" .. self.m_tUsedSkillAndItemList[i]]
        if utilsValueInTable(self.m_tUsedSkillAndItemList[i], self.m_tBringInItems) and tempItemInfo and tempItemInfo.skill_type == 1 and tempItemInfo.sub_type ~= 125 then 
            table.insert(usedItemList, self.m_tUsedSkillAndItemList[i])
        end 
    end
    if usedItemList == nil or #usedItemList == 0 then return end

    local itemCount = #usedItemList
    local randNumList = WBattleGlobal:getCurrent().m_tBattleRand
    local rate = (effectData.proRatioSecond * itemCount + effectData.proRatioFirst) * 100
    local randomIndex = math.abs(self:getBattleId() % 10 + 1)
    WZLog("WCharacter:isActiveGetPropItemSkill", #usedItemList, rate, randNumList[randomIndex])
    if rate >= randNumList[randomIndex] then 
        if self.m_tSkillHappenTimes == nil then 
            self.m_tSkillHappenTimes = {}
        end
        if self.m_tSkillHappenTimes[skillId] == nil then self.m_tSkillHappenTimes[skillId] = 0 end
        if self.m_tSkillHappenTimes[skillId] >= effectData.maxTimes then return end 

        local itemIndex = randNumList[randomIndex] % itemCount
        local generateItem = usedItemList[itemIndex + 1]
        local pos = self:getAnimation():getPosition()
        if self.m_nHideOpecity == nil or self.m_nHideOpecity ~= 0 then
            BattleProfessionSkillManager:showUseName(BattleCommon:getPointTable(pos.x,pos.y + 85), effectData.name, 2)
        end
        WZLog("WCharacter:isActiveGetPropItemSkill", self.m_tSkillHappenTimes[skillId], generateItem, Serialize(usedItemList))
        self.m_tSkillHappenTimes[skillId] = self.m_tSkillHappenTimes[skillId] + 1

        local msg = MsgManager:createMsg(BattleMsgGetProp)
        msg.m_tData = {playerIds={self:getBattleId()}, propsIds={{generateItem}}}
        if not WBattleGlobal:getCurrent():isEscapeBattle() then
            msg.m_bIsProfessionSkill = true
        end
        MsgManager:pushNonBlockMsg(msg)
    end
end

--@brief    职业宠物反击处理
function WCharacter:professionPetBackShootHandle(tShootHero, hurt)
    -- body
    --如果是队友造成的伤害，则宠物不会宠物反击技能
    if WBattleGlobal:getCurrent():isSameTeam(self:getBattleId(), tShootHero:getBattleId()) then return end 
    --如果是分身造成的伤害，则不触发宠物反击技能
    if tShootHero:getIsSubHero() then return end 
    --如果玩家没有携带宠物或宠物被封印或本回合已经触发过一次，则无法触发宠物反击技能
    if self:getPet() == nil or (self:isPetSeal() and not self:isInIngoreBuff(BuffType.PETSEAL)) or self.m_nRunPetBeatBackTimes > 0 then return end 
    --判断是否会触发宠物反击
    local skillId, effectData = self:getIsImmunityByPetSkill(1, EffectTypeConfig.PROFESSION_PET_BEATBACK)
    WZLog("WCharacter:professionPetBackShootHandle hhhh", tostring(skillId))
    if skillId then
        if tShootHero.m_tPetBeatBackMsgList == nil then 
            tShootHero.m_tPetBeatBackMsgList = {}
        end
        local skillData = GDatatab_skill["id_" .. skillId]
        local effectInfo = GDatatab_effect["id_" .. skillData.effect_id[1][1]]
        local tempMsgData = {} 
        tempMsgData.shootHero = self
        tempMsgData.beShootedChara = tShootHero
        tempMsgData.skillName = skillData.name
        tempMsgData.skillIcon = skillData.icon 

        table.insert(tShootHero.m_tPetBeatBackMsgList, tempMsgData)
    end

    return hurt 
end

--@brief    超暴击条件满足，触发超暴击逻辑
function WCharacter:runSuperCritFunc(superCritMark, hurtValue)
    -- body
    if superCritMark and superCritMark == 1 then
        if self.m_tSkillTakeEffectSuperCritList == nil then return end  
        for i = 1, #self.m_tSkillTakeEffectSuperCritList do
            local skillInfo = GDatatab_skill["id_" .. self.m_tSkillTakeEffectSuperCritList[i]]
            local effectInfo = GDatatab_effect["id_" .. skillInfo.effect_id[1][1]]
            if effectInfo then 
                local bAddHurtPercent = false 
                for j, effect in pairs(effectInfo.effect) do
                    local effectParam = effect[3] .. "_" .. effect[4]
                    if effectParam == EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT_HURT or effectParam == EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT_HURT2 or effectParam == EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT_HURT3 then 
                        bAddHurtPercent = true 
                        break 
                    end
                end
                if bAddHurtPercent then 
                    WZLog("WCharacter:runSuperCritFunc", hurtValue)
                    WMonsterAI:castSkill(nil,
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
                        skillInfo.id, TakeEffectType.SUPERCRIT,
                        nil,nil,nil,nil,
                        nil,
                        nil,
                        hurtValue
                        )
                end
            end
        end
    end
end

--@brief    获取火焰图腾等级
function WCharacter:getFireTotemInfo()
    for id,buff in pairs (self.m_tBuffChangeStateList) do
        if buff.m_nType == BuffType.FIRE_TOTEM then
            return buff.m_nID,buff.m_nLv,buff.m_tUser
        end
    end
    return 0,0,0
end

--@brief    获取守护光环等级
function WCharacter:getGuardianTotemInfo()
    for id,buff in pairs (self.m_tBuffChangeStateList) do
        if buff.m_nType == BuffType.GUARDIAN_TOTEM then
            return buff.m_nID,buff.m_nLv,buff.m_tUser
        end
    end
    return 0,0,0
end

--@brief    根据类型获取buff信息
function WCharacter:getBuffInfoByType(buffType)
    for id,buff in pairs (self.m_tBuffChangeStateList) do
        if buff.m_nType == buffType then
            return buff.m_nID,buff.m_nLv,buff.m_tUser
        end
    end
    return 0,0,0
end

--@brief    根据id获取buff信息
function WCharacter:getBuffInfoById(buffId)
    for id,buff in pairs (self.m_tBuffChangeStateList) do
        if buff.m_nID == buffId then
            return buff.m_nID,buff.m_nLv,buff.m_tUser
        end
    end
    return 0,0,0
end

--@brief    获取触碰超暴击标记
function WCharacter:getCollisionSuperCritMark()
    -- body
    return self.m_nHitSuperCritRectIndex
end

--@brief    获取触碰超暴击标记
function WCharacter:setCollisionSuperCritMark(mark)
    -- body
    self.m_nHitSuperCritRectIndex = mark 
end

--@brief    判断是否有霸体盾
function WCharacter:isInBaTi()
    local isBaTi = false
    local buffNew = nil 
    for id,buff in pairs (self.m_tBuffChangeStateList) do
        if buff.m_nType == 42 or buff.m_nType == BuffType.GUARDIAN_TOTEM then --44守护光环
            isBaTi = true
            buffNew = buff
            break 
        end
    end
    return isBaTi, buffNew
end

--@brief    发送玩家命中怪物事件
function WCharacter:_postPlayerHitMonsterEvent()
    -- body
    if not WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_SINGLE) then return end 

    local mapId = WBattleGlobal:getCurrent().m_tMakePairOk.mapId
    if mapId ~= 10102 then return end 

    PostPlayerEvent:postEvent(PostPlayerEvent.event_oneLvHitMonster)
end

--@brief    发送玩家命中怪物事件
--@param    buffType : 玩家无视的buff类型
function WCharacter:isInIngoreBuff(buffType)
    -- body
    if buffType == nil then return false end 

    local skillId, effectData = self:getIsImmunityByPetSkill(1, EffectTypeConfig.IGNORE_BUFF)
    if effectData == nil then return false end 
    if effectData.ignoreBuffType == nil then return end 

    for i = 1, #effectData.ignoreBuffType do
        if effectData.ignoreBuffType[i] == buffType then 
            return true
        end
    end

    return false 
end

--@brief    显示怪物对白300x-怪物状态
--@param    nType:3001死亡,3002血量,3003受击,3004中毒,3005流血
function WCharacter:showMonsterDialog300x(nType)
    if self:getType() == CharacterType.TYPE_GUAI or self:getType() == CharacterType.TYPE_HERO and self.m_bIsGuaiWithSuit == true then
        local tMonsterInfo = GDatatab_monster["id_"..self:getId()]
        if tMonsterInfo then
            local tempTalk = tMonsterInfo.talk
            if tempTalk and tempTalk[1] and tempTalk[1][1] and tempTalk[1][1] ~= -1 then
                for i=1, #tempTalk[1] do
                    local tStoryTalk = GDatatab_talk["id_"..tempTalk[1][i]]
                    if tStoryTalk and tempTalk[2] and tempTalk[2][i] and tempTalk[3] and tempTalk[3][i] then
                        if tempTalk[2][i] == nType then
                            if tempTalk[2][i] == 3002 then
                                if self.m_nHPPre/self.m_nMaxHP*100 > tempTalk[3][i] and self.m_nHP/self.m_nMaxHP*100 <= tempTalk[3][i] then
                                    self:talk(tStoryTalk.talk)
                                end
                            elseif tempTalk[2][i] == 3003 then
                                if self.m_nPlayerInjuredNumber == tempTalk[3][i] then
                                    self:talk(tStoryTalk.talk)
                                end
                            else
                                self:talk(tStoryTalk.talk)
                            end
                        end
                    end
                end
            end
        end
    end
end

--@brief    获取职业二转状态
function WCharacter:getIsProfessionSecondTurn()
    -- body
    local bIsSecondTurn = false 
    if self.m_tProfessionSkills then 
        for i = 1, #self.m_tProfessionSkills.profession do
            if self.m_tProfessionSkills.profession[i] >= 201 then
                bIsSecondTurn = true
                break
            end
        end
    end
    
    return bIsSecondTurn
end

--@brief        创建小孩
--@param        childCombatId:小孩战斗id
--@param        skillId:小孩技能Id
--@param        positionX:小孩x位置
--@param        positionY:小孩y位置
function WCharacter:receiveBuildKid(childCombatId, skillId, positionX, positionY)
end

--@brief    获取是否是小孩
function WCharacter:getIsKid()
    -- body
    return self.m_bIsKid or false 
end

--@brief    计算回合击杀怪物数量
function WCharacter:setRoundKillMonsterNum()
    self.m_nRoundKillMonsterNum = self.m_nRoundKillMonsterNum + 1
    if self.m_nMaxRoundKillMonsterNum < self.m_nRoundKillMonsterNum then 
        self.m_nMaxRoundKillMonsterNum = self.m_nRoundKillMonsterNum

        GlobalGame:getBattleEventDispatcher():Dispatch(BATTLE_EVENT_TYPE.ROUND_KILL_MONSTERNUM)
    end
end

--@brief    获取回合同时击杀怪物数量
function WCharacter:getMaxKillMonsterNum()
    return self.m_nMaxRoundKillMonsterNum
end

--@brief    获取怪物攻击类型
function WCharacter:getCharaActionType()
    return self.m_nAction_type or 1
end

--@brief    获取随机数
function WCharacter:_getRandNum(battleId, nType)
    local battleRand = WBattleGlobal:getCurrent().m_tBattleRand
    local randomIndex = math.abs((battleId + nType + battleRand[1]) % 10)
    local i = math.abs((battleRand[randomIndex + 1] + battleId + nType) % 10)
    return battleRand[i + 1]
end

--@brief    获取宠物装备免疫属性
--@param    buff_type : -1被动效果；-2主动效果
function WCharacter:getPetEquipImmunityAttr(buff_type)
    local nPropertyKey = -1
    if buff_type == -1 or buff_type == -2 then 
        nPropertyKey = {}
    end
    if self.m_tPetEquipAttr then
        for i=1,#self.m_tPetEquipAttr do
            local extPropertyKey = tonumber(self.m_tPetEquipAttr[i].extPropertyKey)
            local extPropertyValue = tonumber(self.m_tPetEquipAttr[i].extPropertyValue)
            if extPropertyKey == PetEquipRandomAttr.IMMUNEBUFF_POISON_RATE and buff_type == 20 then --中毒buff
                if self:_getRandNum(self:getBattleId(), extPropertyKey) <= extPropertyValue then
                    nPropertyKey = extPropertyKey
                end
            elseif extPropertyKey == PetEquipRandomAttr.IMMUNEBUFF_BLEED_RATE and buff_type == 2 then --流血buff
                if self:_getRandNum(self:getBattleId(), extPropertyKey) <= extPropertyValue then
                    nPropertyKey = extPropertyKey
                end
            elseif extPropertyKey == PetEquipRandomAttr.IMMUNEBUFF_FROZEN_RATE and buff_type == 4 then --免疫冰冻,不免疫boss冰冻
                if self:_getRandNum(self:getBattleId(), extPropertyKey) <= extPropertyValue then
                    nPropertyKey = extPropertyKey
                end
            elseif extPropertyKey == PetEquipRandomAttr.IMMUNEBUFF_SILENT_RATE and buff_type == 7 then --免疫沉默
                if self:_getRandNum(self:getBattleId(), extPropertyKey) <= extPropertyValue then
                    nPropertyKey = extPropertyKey
                end
            elseif buff_type == -1 then --被动效果
                local effectId = nil 
                if extPropertyKey == PetEquipRandomAttr.IMMUNEBUFF_REDUCEHURT_RATE then --减免伤害
                    effectId = PetEquipRandomEffect.EFFECT_REDUCEHURT_ID
                end
                if effectId then 
                    if self:_getRandNum(self:getBattleId(), extPropertyKey) <= extPropertyValue then
                        local tItem = {propertyKey = extPropertyKey, effectId = effectId, hero = self}
                        table.insert(nPropertyKey, tItem)
                    end
                end
            elseif buff_type == -2 then --主动属性技能效果
                local effectId = nil 
                if extPropertyKey == PetEquipRandomAttr.PETATTACK_FATAL_RATE then 
                    effectId = PetEquipRandomEffect.EFFECT_FATAL_ID
                elseif extPropertyKey == PetEquipRandomAttr.PETATTACK_SUCKBLOOD_RATE then 
                    effectId = PetEquipRandomEffect.EFFECT_SUCKBLOOD_ID
                elseif extPropertyKey == PetEquipRandomAttr.PETATTACK_BLOWUP_RATE then 
                    effectId = PetEquipRandomEffect.EFFECT_BLOWUP_ID
                elseif extPropertyKey == PetEquipRandomAttr.PETATTACK_BLIND_RATE then 
                    effectId = PetEquipRandomEffect.EFFECT_BLIND_ID
                elseif extPropertyKey == PetEquipRandomAttr.PETATTACK_EASYHURT_RATE then 
                    effectId = PetEquipRandomEffect.EFFECT_EASYHURT_ID
                elseif extPropertyKey == PetEquipRandomAttr.PETATTACK_SUMMONFIRE_RATE then 
                    effectId = PetEquipRandomEffect.EFFECT_CALLFIRE_ID
                elseif extPropertyKey == PetEquipRandomAttr.PETATTACK_SUMMONBLACKHOLE_RATE then 
                    effectId = PetEquipRandomEffect.EFFECT_CALLBLACKHOLE_ID
                elseif extPropertyKey == PetEquipRandomAttr.PETATTACK_SUMMONTORNADO_RATE then 
                    effectId = PetEquipRandomEffect.EFFECT_CALLTORNADO_ID
                elseif extPropertyKey == PetEquipRandomAttr.PETATTACK_CHAIN_RATE then 
                    effectId = PetEquipRandomEffect.EFFECT_CHAIN_ID
                elseif extPropertyKey == PetEquipRandomAttr.PETATTACK_CALM_RATE then 
                    effectId = PetEquipRandomEffect.EFFECT_CALM_ID
                elseif extPropertyKey == PetEquipRandomAttr.PETATTACK_NOPIT_RATE then 
                    effectId = PetEquipRandomEffect.EFFECT_NOPIT_ID
                elseif extPropertyKey == PetEquipRandomAttr.PETATTACK_HIDE_RATE then 
                    effectId = PetEquipRandomEffect.EFFECT_HIDE_ID
                elseif extPropertyKey == PetEquipRandomAttr.PETATTACK_THORNS_RATE then 
                    effectId = PetEquipRandomEffect.EFFECT_THORNS_ID
                end

                if effectId and self:_getRandNum(self:getBattleId(), extPropertyKey) <= extPropertyValue then
                    local tItem = {propertyKey = extPropertyKey, effectId = effectId, hero = self}
                    WZLog("WCharacter:getPetEquipImmunityAttr", tItem.propertyKey, tItem.effectId)
                    table.insert(nPropertyKey, tItem)
                end
            end
        end
    end
    return nPropertyKey
end

--@brief    获取镇定弹Buff
function WCharacter:getWeakBuff()
    for id,buff in pairs (self.m_tBuffChangeStateList) do
        if buff.m_nType == 48 then
            return buff
        end
    end
    return nil 
end

--@brief    获取反伤盾Buff
function WCharacter:getThornsBuff()
    for id,buff in pairs (self.m_tBuffChangeStateList) do
        if buff.m_nType == 49 then
            return buff
        end
    end
    return nil 
end

--@brief    获取肾上腺素Buff
function WCharacter:getExtraHPBuff()
    for id,buff in pairs (self.m_tBuffChangeStateList) do
        if buff.m_nType == 58 then
            return buff
        end
    end
    return nil 
end

--@brief    获取赵云反伤Buff
function WCharacter:getThornsRandomBuff()
    for id,buff in pairs (self.m_tBuffChangeStateList) do
        if buff.m_nType == 61 then
            return buff
        end
    end
    return nil 
end

--@brief    进行反伤盾反伤检测
function WCharacter:_doPercentThorns()
    local bDoPercentThorns = self.m_tHurtValue.bDoPercentThorns
    local tShootHero = self.m_tHurtValue.tShootHero
    if bDoPercentThorns then 
        for i = 1, #self.m_tHurtValue do
            value = self.m_tHurtValue[i]
            BattleMethod:checkReflectThorns(tShootHero, {self}, {value}, WBattleGlobal:getCurrent():getCurrentCharacterId())
        end
    end
end

--@brief    设置额外血量
--@param    nHp 当前额外血量
function WCharacter:setExtraHp(nHp, bSet)
    nHp = tonumber(nHp)
    if self.m_nExtraHP == nHp then
        return
    end
    WZLog("WCharacter:setExtraHp one",self:getId(), self.m_nExtraHP, nHp)
    
    self.m_nExtraHP = nHp
    self.m_nExtraHP_Encrypt = BattleCommon:intEncrypt(self.m_nExtraHP)
    
    if self:getType() == 0 or self.m_nAiType ~= nil then 
        WndBattleHud:updatePlayerHP(self:getBattleId(), bSet)
    end

    GlobalGame:getBattleEventDispatcher():Dispatch(BATTLE_EVENT_TYPE.CHARACTER_CHANGE_HP,self)
end

--@brief    获得人物当前额外血量
--@return   #1,人物当前额外血量
function WCharacter:getExtraHp()
    return self.m_nExtraHP
end

--@brief    获取是否是灵魂分身
function WCharacter:getIsSoulHero()
    -- body
    return self.m_bIsSoulHero or false 
end

--@brief    玩家是否概率命中命运暴击
function WCharacter:isFateCrit()
    local fateCritRate = self:getFateCritRate(true)
    WZLog("WCharacter:isFateCrit 000", fateCritRate)
    if fateCritRate <= 0 then 
        return false 
    end

    local randomList = WBattleGlobal:getCurrent().m_tBattleRand
    if randomList == nil or #randomList < 10 then 
        return false 
    end

    local ranLen = #randomList 
    local index1 = math.fmod((randomList[1] + fateCritRate), ranLen) + 1
    WZLog("WCharacter:isFateCrit 111", index1)
    local index2 = math.fmod((self:getBattleId() + randomList[index1]), ranLen) + 1
    WZLog("WCharacter:isFateCrit 111", index2, randomList[index2], fateCritRate)
    if randomList[index2] <= fateCritRate then 
        return true  
    end

    return false 
end

--@brief    是否是分身
function WCharacter:getIsSubHero()
    return self.m_bIsSubHero or false 
end

--@brief    被打的玩家是否触发龙胆赵云大招反伤buff
function WCharacter:isTriggerZhaoYunBuff()
    local weakBuff = self:getThornsRandomBuff()
    if weakBuff then
        local effectInfo = GDatatab_effect["id_" .. weakBuff.m_nEffectId]
        local randNumList = WBattleGlobal:getCurrent().m_tBattleRand
        local randIndex = (randNumList[7] + self:getBattleId()) % #randNumList + 1

        for j,effectParm in pairs(effectInfo.effect) do
            local effect = effectParm[3] .. "_" .. effectParm[4]
            if effect == EffectTypeConfig.THORNS_PERCENT_RANDOM and randNumList[randIndex] <= effectParm[6] then -- 触发概率
                return true
            end
        end
    end
    return false
end

--@brief    获得人物当前累加的最大额外血量
--@return   #1,人物当前最大额外血量（叠加的）
function WCharacter:getMaxExtraHp()
    return self.m_nMaxExtraHP
end

--@brief    累加的最大额外血量
--@param    param:配置的万分比
--@param    bIsAdd:true=添加；false=移除
--@return   #1,人物当前最大额外血量（叠加的）
function WCharacter:changeMaxExtraHp(param, bIsAdd)
    if self.m_nMaxExtraHP == nil then self.m_nMaxExtraHP = 0 end 

    local addValue = math.ceil(self.m_nMaxHP * param/10000)
    if bIsAdd then 
        self.m_nMaxExtraHP = self.m_nMaxExtraHP + addValue
    else
        self.m_nMaxExtraHP = self.m_nMaxExtraHP - addValue
    end

    if self.m_nMaxExtraHP < 0 then self.m_nMaxExtraHP = 0 end 
    if self.m_nExtraHP > self.m_nMaxExtraHP then 
        self.m_nExtraHP = self.m_nMaxExtraHP
    end
    self:setExtraHp(self.m_nExtraHP, true)
end