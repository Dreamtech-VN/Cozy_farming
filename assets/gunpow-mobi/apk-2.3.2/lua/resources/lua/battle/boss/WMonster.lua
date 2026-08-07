--WMonster.lua
--@brief	怪物数据表
--@date		2014/3/18
--@author	莫剑峰
--@note		怪物相关属性及操作

--@brief	怪物数据表
WMonster = {
    m_tBossName = nil,              --怪物的名称与血条
    m_tDialog = nil ,               --剧情对话框
    
    m_nAiType = 0,                  --攻击类型 0:会远近攻 1:只会远攻 2:只会近攻 3:不会攻击不会移动 4:着装
    m_sAniFileId = nil,             --动画ID
    m_nCurDirect = nil, 			--当前方向（0：左，1：右）
	m_tPosition = nil,				--怪的位置
	m_tMoveSpeed = nil, 			--小怪速度
	m_tGuaiName = nil, 				--boss的名称与血条
	m_bActFinished = nil, 			--行动是否完成
	m_bMovePlayed = nil, 			--移动动画是否已经播放
	m_bAttackPlayed = nil, 			--攻击动画是否已经播放
	m_bIsAddedInScene = nil, 		--是否被添加进当前场景
	m_tTargetPlayer = nil,			--目标玩家
	m_bPlayerHurt = nil, 			--是否有玩家受伤
	m_nHurtValue = nil, 			--玩家所受伤害
    m_nAttackArea = 0,               --小怪攻击范围
    m_bIsAtkAfterMove = false,      --是否移动完会攻击
    m_tCollisionCharacters = nil,   --需要检测攻击的角色
    m_bIsOutOfScene = false,		--是否在屏幕之外
    
    m_tAiScript = nil,              --怪物的AI
    m_nAiState = nil,               --怪物AI策略
    m_tDialogue = nil,              --对话文本
    m_bIsOldAnim = false,           --是否旧动画
    m_bIsFilpX = false,             --是否翻转
    m_nScale = 1,                   --放大

    m_tOwnedMonsterList = nil,      --持有的小怪
    m_bIsLeftFlip = false,          --动画是否需要在面向左边时翻转
    m_bIsSummon = nil,              --是否是召唤出来的
    m_bIsViolent = nil,             --是否是狂暴状态
    m_bIsAir = nil,                 --是否是空中状态
    m_bIsAirViolent = nil,          --是否是空中狂暴状态

    m_tAniFileId = nil,
    m_tAiType = nil,
    m_tDataId = nil,
    m_tState = nil,
    m_nInfoIndex = 0,

    m_nBulletId = nil,
    m_bActiveAttack = false,
    m_bPassiveAttack = false,
    m_tActiveSkillList = nil,
    m_tPassiveSkillList = nil,

    m_nAction_type = 1,   --1默认行动，2无Ctb行动 3,跟随行动
    m_nAiDisplaceType = 0,  --ai位移类型
    -- m_nSacrificeSkillId = nil,
    -- m_nBoomSkillId = nil,
    --m_fRectForBulletExplodeBomb = {x=300,y=300},
    m_tOwnerMsgMgr = nil,    --自身消息管理

    m_bIsCanMove = nil,     --能否移动

    m_bServerDead = nil,    --服务器死亡状态

    m_nBuffAnimState = 1,       --boss 自带buff状态（控制变身类）

    m_nDialogOffset = nil,  --对白偏移（无mover的对象）
    m_bDialogIsFilpX = nil,
}

--@brief	AI类型
MonsterAiType = {
    AI_RANGED_MELEE = 0,            --远程攻击和近身攻击
    AI_RANGED = 1,                  --远程攻击
    AI_MELEE = 2,                   --近身攻击
	AI_NO_ACTION = 3,               --没有动作
    AI_MELEE_SKY = 4,               --近身攻击_空中型
    AI_ROBOT = 5,                   --机器人远程
    AI_NO_ACTION_SKY = 6,           --空中无动作
}

MonsterActType = {
    NORMAL = 1, --正常行动
    FOLLOW = 2, --跟随行动
    FOLLOW_INDEPENDENT = 3,--跟随行动 独立ai
}

--@brief	AI动作类型
MonsterAiAction = {
	ACTION_MOVE = 1,                --移动
	ACTION_RAND = 2,                --随机动作
	ACTION_SHOOT = 3,               --射击
	ACTION_FLY = 4,                 --飞行
	ACTION_SKILL = 5,               --使用技能
	ACTION_ITEM = 6,                --使用道具
    ACTION_MOVE_MOSTER = 7,         --移动
    ACTION_SHOOT_MOSTER = 8,        --射击
    ACTION_MELEE_MOSTER = 9,        --近身攻击
}

--@brief    AI状态类型
MonsterState = {
    NORMAL = "animNormal",          --普通
    VIOLENT = "animViolent",        --狂暴
    AIR = "animAir",                --空中
    AIR_VIOLENT = "animAirViolent", --空中狂暴
}

--@brief	AI类型
DirectionType = {
    LEFT = 1,
    RIGHT = 0,
}

MonsterType = {
    COMMON = 1,--普通
    BOSS = 2,--boss
    ELITE = 3,--精英

    TORANDO = 101, --龙卷风
    TREAT_TOTEM = 102, --治疗图腾
    BUFF_TOTEM = 103, --攻击图腾
    FIRE_TOTEM = 104, --火焰图腾
    GUARDIAN_TOTEM = 105, --守护光环
    BLACK_HOLE = 106, --黑洞
    MARITIME1_TOTEM = 107, --鲛人大招海洋领域增益
    MARITIME2_TOTEM = 108, --鲛人大招海洋领域减益束缚
    MARITIME3_TOTEM = 109, --鲛人大招海洋领域减益扣血
    JIANGZIYA_TOTEM = 110, --姜子牙结界
    XUANZANG_TOTEM = 111, --玄奘佛光
    UMBRELLA1_TOTEM = 112, --执伞圣女 回血
    UMBRELLA2_TOTEM = 113, --执伞圣女 反击
    BOSS_PAO = 1001, --组队boss1 炮塔
    BOSS_GIFT = 1002, --组队boss5 礼物
    BOSS_LIGHT = 1003, --组队boss5 聚光灯
    BOSS_FIRE = 1004,   --组队boss6 火焰
    BOSS_CAGE = 1005,   --组队boss7 牢笼
    BOSS_LASER = 1006,  --组队boss7 激光 
    BOSS_MAGMA = 1007,  --组队boss8 岩浆 
    BOSS_POISON = 1008, --组队副本10 毒雾
    TREAT_ARRAY = 1009, --组队副本11 加血法阵

    TEAM_WAR_NPC = 10001, --公主
}

function WMonster:canSendHurtByType(monsterType)
    if monsterType == MonsterType.BOSS_GIFT or 
    monsterType == MonsterType.BOSS_CAGE or 
    monsterType == MonsterType.BOSS_MAGMA or
    monsterType == MonsterType.BOSS_LASER or
    monsterType == MonsterType.BOSS_POISON then
        return  true
    end
    return false
end
-------------------------------------公有方法模块--------------------------------------

--@brief	生成一个怪物
--@return	#1:怪物数据表
function WMonster:buildGuai(index, scale, isSummon, battleId)
    WZLog("-------00000000022222 = ",index,scale,isSummon,battleId)
    local boss = WMonster:new()

    boss.m_nInfoIndex = index
    boss.m_nScale = scale or 1
    boss.m_nAttackArea = 60
    boss.m_bIsSummon = isSummon
    boss.m_nBattleId = battleId

    --WZLog("WMonster:buildGuai one", boss.m_nAiType, boss.m_sAniFileId, tostring(boss.m_bIsLeftFlip), tostring(boss.animAirViolent["standby"]), tostring(boss.animAir["standby"]), tostring(boss.animViolent["standby"]))

    boss.m_tAniFileId = {}
    boss.m_tAiType = {}
    boss.m_tDataId = {}
    boss.m_tState = {}
    boss.m_tTransState = {}
    boss.m_tTransAnim = {}
    boss.m_bActiveAttack = false
    boss.m_bPassiveAttack = false
    boss.m_tActiveSkillList = {}
    boss.m_tPassiveSkillList = {}

    boss:setGuaiInfo(boss, index)
    boss:setTestValue()
    boss:trans(1)
    boss:initShopAnim()

    WBattleGlobal:getCurrent().m_tCharacterAttributeList[boss.m_nBattleId] = {battleId=boss.m_nBattleId, atk=boss.m_nAttack}
	--boss:setRadiusForBulletExplode(8)
    --设置怪物记录
    WBattleGlobal:getCurrent():setBuildMonsterRecord(boss.m_nBattleId,boss.m_nPlayerId)
    
    --设置当前方向向左
	boss.m_nCurDirect = 0
	--设置默认移动速度
	boss.m_tMoveSpeed = {x=-3.1, y=-1}
    
	--设置小怪信息
	--WBattleGlobal:getCurrent():setGuaiInfo(boss, boss.m_sAniFileId)
    
    boss:addCollisionCharas(WBattleGlobal:getCurrent():getHeroList())

    boss.m_nDebuffFrozenRound = 0
    boss.m_tOwnedMonsterList = {}
    --绑定AI
    boss:setAI(WNewMonsterAI:new(boss:getBattleId()))
    boss:getAI():setBoss(boss)
    boss:getAI():parseScript()
	return boss
end

--@brief    设置小怪数据
function WMonster:setGuaiInfo(monster, id)
    WZLog("WMonster:setGuaiInfo one", id,monster.m_nBattleId)
    -- --设置怪物记录
    -- WBattleGlobal:getCurrent():setBuildMonsterRecord(monster.m_nBattleId,id)

    local monsterData = BossData["id_"..id]
    -- monsterData.AniFileId = "boss_1008"
    --动画文件
    monster.m_sAniFileId = monsterData.AniFileId
    --数据表id
    monster.m_nPlayerId = monsterData.id--monsterData.guai_id
    --数据表索引id
    monster.m_nIndexId = monsterData.id
    --怪名字
    monster.m_sPlayerName = monsterData.name
    --怪等级
    --怪战斗加载界面需要的信息
    monster.m_tLoadingInfo = monsterData.loadingInfo    --Add By Tianxiang_Xu

    monster.m_nLevel = tonumber(monsterData.level)--GlobalGame:checkGlobalPlayerLevel(monsterData.level) 
    --怪物真实等级
    monster.m_nRealLevel = monsterData.level
    --行动类型
    monster.m_nAction_type = monsterData.action_type > 0 and monsterData.action_type or 1 
    --ai位移类型
    if monsterData.aiDisplaceType then
        monster.m_nAiDisplaceType = monsterData.aiDisplaceType 
    end
    -- --小怪牺牲技能
    -- if monsterData.sacrificeSkillId and monsterData.sacrificeSkillId > 0 then
    --     monster.m_nSacrificeSkillId = monsterData.sacrificeSkillId
    -- end
    -- --小怪自爆技能
    -- if monsterData.boomSkillId and monsterData.boomSkillId > 0 then
    --     monster.m_nBoomSkillId = monsterData.boomSkillId
    -- end
    if monsterData.offHurt and monsterData.offHurt == 1 then
        monster.m_bOffHurt = true
    end
    
    if monsterData.offRepulse and monsterData.offRepulse == 1 then
        monster.m_bOffRepulse = true
    end

    if monsterData.limit and monsterData.limit == 1 then
        monster.m_bOffFrozen = true
    end

    local scale = 1
    if monsterData.scale and monsterData.scale > 10 then
        scale = monsterData.scale/100
    end

    monster.m_nScale = scale or 1
    --怪阵型
    if monster.m_bIsSummon ~= true then 
        monster.m_nCamp = 1
    else
        monster.m_nCamp = -1
    end
    --怪maxHP
    --怪攻击力
    --世界boss等级
    if WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_WORLDBOSS then
        monster.m_nMaxHP = WBattleGlobal:getCurrent().m_tMakePairOk.guaiMaxHP[1]
        monster.m_nHP = WBattleGlobal:getCurrent().m_tMakePairOk.guaiNowHP[1]
        monster.m_nAttack = WBattleGlobal:getCurrent().m_tMakePairOk.guaiAtk[1]
        monster.m_nLevel = tonumber(WBattleGlobal:getCurrent().m_tMakePairOk.guaiLv[1])
        monster.m_nRealLevel = tonumber(WBattleGlobal:getCurrent().m_tMakePairOk.guaiLv[1])
    elseif WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_WORLDTEAMBOSS then
        if WBattleGlobal:getCurrent().m_tMakePairOk.guaiBattleId[1] == monster.m_nBattleId then
            monster.m_nMaxHP = WBattleGlobal:getCurrent().m_tMakePairOk.guaiMaxHP[1]
            monster.m_nHP = WBattleGlobal:getCurrent().m_tMakePairOk.guaiNowHP[1]
            monster.m_nAttack = WBattleGlobal:getCurrent().m_tMakePairOk.guaiAtk[1]
        else
            monster.m_nHP = monsterData.hp
            monster.m_nMaxHP = monsterData.hp
            monster.m_nAttack = monsterData.attack
        end
    elseif WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_COUPLE_HEGEMONY then
        if WBattleGlobal:getCurrent().m_tMakePairOk.guaiBattleId[1] == monster.m_nBattleId then
            monster.m_nMaxHP = WBattleGlobal:getCurrent().m_tMakePairOk.guaiMaxHP[1]
            monster.m_nHP = WBattleGlobal:getCurrent().m_tMakePairOk.guaiNowHP[1]
            monster.m_nAttack = WBattleGlobal:getCurrent().m_tMakePairOk.guaiAtk[1]
        else
            monster.m_nHP = monsterData.hp
            monster.m_nMaxHP = monsterData.hp
            monster.m_nAttack = monsterData.attack
        end
    else
        monster.m_nHP = monsterData.hp
        monster.m_nMaxHP = monsterData.hp
        monster.m_nAttack = monsterData.attack
    end

    --遗迹战斗
    if WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_REMAINSBOSS then
        WZLog("monster.m_nMaxHP", WBattleGlobal:getCurrent().m_tMakePairOk.guaiMaxHP[1] )
        WZLog("monster.m_nHP", WBattleGlobal:getCurrent().m_tMakePairOk.guaiNowHP[1] )
        WZLog("monster.m_nAttack", WBattleGlobal:getCurrent().m_tMakePairOk.guaiAtk[1] )
        WZLog("monster.m_nLevel", tonumber(WBattleGlobal:getCurrent().m_tMakePairOk.guaiLv[1]) )
        WZLog("monster.m_nRealLevel", tonumber(WBattleGlobal:getCurrent().m_tMakePairOk.guaiLv[1]) )

        monster.m_nMaxHP = WBattleGlobal:getCurrent().m_tMakePairOk.guaiMaxHP[1]
        monster.m_nHP = WBattleGlobal:getCurrent().m_tMakePairOk.guaiNowHP[1]
        monster.m_nAttack = WBattleGlobal:getCurrent().m_tMakePairOk.guaiAtk[1]
        monster.m_nLevel = tonumber(WBattleGlobal:getCurrent().m_tMakePairOk.guaiLv[1])
        monster.m_nRealLevel = tonumber(WBattleGlobal:getCurrent().m_tMakePairOk.guaiLv[1])
    end


    --公会怪物
    if WBattleGlobal:getCurrent():isGuildBossStage() then
        monster.m_nMaxHP = WBattleGlobal:getCurrent().m_tMakePairOk.guaiMaxHP[1]
        monster.m_nHP = WBattleGlobal:getCurrent().m_tMakePairOk.guaiNowHP[1]
        monster.m_nAttack = WBattleGlobal:getCurrent().m_tMakePairOk.guaiAtk[1]
    end

    monster.m_nHP_Encrypt = BattleCommon:intEncrypt(monster.m_nHP)
    monster.m_nAttack_Encrypt = BattleCommon:intEncrypt(monster.m_nAttack)
   
    --怪maxPF
    monster.m_nMaxPF = monsterData.tili
    --怪性别
    -- monster.m_nBoyOrGirl = monsterData.sex
    --怪MaxSP
    monster.m_nMaxSP = 0
    if self.m_sAniFileId == "boss_1011" then
        monster.m_nMaxSP = 100
    end
    --怪HP
    -- monster.m_nHP = monsterData.hp
    -- monster.m_nHP_Encrypt = BattleCommon:intEncrypt(monster.m_nHP)
    --怪PF
    monster.m_nPF = monster.m_nMaxPF
    monster.m_nPF_Encrypt = BattleCommon:intEncrypt(monster.m_nPF)
    --怪SP
    monster.m_nSP = 0
    monster.m_nSP_Encrypt = BattleCommon:intEncrypt(monster.m_nSP)
    -- --怪攻击力
    -- monster.m_nAttack = monsterData.attack
    -- monster.m_nAttack_Encrypt = BattleCommon:intEncrypt(monster.m_nAttack)
    --怪暴击倍率
    monster.m_nCriticalhitAttackRate = monsterData.crit
    monster.m_nCriticalhitAttackRate_Encrypt = BattleCommon:intEncrypt(monster.m_nCriticalhitAttackRate)
    --怪防御
    monster.m_nDefence = monsterData.defend
    monster.m_nDefence_Encrypt = BattleCommon:intEncrypt(monster.m_nDefence)
    --怪免伤
    monster.m_nInjuryFree = monsterData.injury_free
    monster.m_nInjuryFree_Encrypt = BattleCommon:intEncrypt(monster.m_nInjuryFree)
    --怪破防值
    monster.m_nWreckDefense = monsterData.wreck_defense
    monster.m_nWreckDefense_Encrypt = BattleCommon:intEncrypt(monster.m_nWreckDefense)
    --怪免暴
    monster.m_nReduceCrit = monsterData.reduce_crit
    monster.m_nReduceCrit_Encrypt = BattleCommon:intEncrypt(monster.m_nReduceCrit)
    --怪免坑
    monster.m_nReduceBury = monsterData.reduce_bury
    monster.m_nReduceBury_Encrypt = BattleCommon:intEncrypt(monster.m_nReduceBury)
    --怪大招类型
    monster.m_nBigSkillType = monsterData.bigSkillType
    --怪转生等级
   
    monster.m_nZSLevel = GlobalGame:checkGlobalPlayerZsleve(monsterData.level)

    --怪武器类型
    --monster.m_nWeaponType = monsterData.weapon_type
    --攻击相关
    monster:setAttPercent(100)
    monster:setAttTimes(1)
    monster:setAttScatterNum(1)
    monster:setCanFrozen(false)
    monster:setCanFollow(false)
    
    monster.m_nPower = monsterData.force
    monster.m_nArmor = monsterData.armor
    monster.m_nConstitution = 0
    monster.m_nAgility = monsterData.agility
    monster.m_nLucky = monsterData.luck
    --子弹爆破配置
    monster:setRadiusForBulletExplodeRate(monsterData.scope/100)
    monster.m_fRectForBulletExplodeBombRate = {x = monsterData.boom_scope[1][1]/100,y =monsterData.boom_scope[1][2]/100}

    local bombInfo = GDatatab_skill.id_1001.boom_scope[1]
    monster.m_fRectForBulletExplodeBomb = {x=bombInfo[1],y=bombInfo[2]}
    monster.m_fRadiusForBulletExplode = bombInfo.scope

    --怪物类型
    if monster.m_bIsSummon ~= true then 
        monster.m_nGuaiType = 2
    else
        monster.m_nGuaiType = 1
    end

    monster.m_nAttackArea = monsterData.attackArea * 1
    monster.m_tSkillItemList = monsterData.skill
    monster.m_nHitRate = monsterData.mzl
    monster.m_nPhysicalMax = monsterData.tili
    monster.m_tDialogue = monsterData.dialogue
    if tostring(monster.m_tDialogue) ~= "-1" then
        --monster.m_tDialogue = SplitStringWithSeparator(monster.m_tDialogue, "|")
    end

    -- if monsterData.suit_weapon ~= nil then
    --    monster.m_sWeaponName = SplitStringWithSeparator(monsterData.suit_weapon, "\"")[2]    --"
    -- end
   
    if not monster.m_bIsGuaiWithSuit then
        monster.m_tAiScript = {}
        local aiString = string.gsub(monsterData.guai_ai, " ", "")
        local aiList = SplitStringWithSeparator(aiString, ",")
        for i, aiId in pairs (aiList) do
            table.insert(monster.m_tAiScript,AiConfig["id_"..aiId] and AiConfig["id_"..aiId].peizhi)
        end
        monster.m_nAiState = 1
    else
        monster.m_tAiScript = -1
    end
    
    
    monster.m_tAniFileId = {[1]=MonsterConfig[string.gsub(monsterData.AniFileId,"-","_")] and MonsterConfig[string.gsub(monsterData.AniFileId,"-","_")].aniFileId or monsterData.AniFileId}
    monster.m_tAniFileIndex = monsterData.AniFileId
    monster.m_tAiType = {[1]=monsterData.attack_type,}
    monster.m_tDataId = {[1]=id}
    monster.m_tState = {[1]=monsterData.state,}
    monster.m_sAniFileId = monster.m_tAniFileId[1]

    monster.m_nAiType = monster.m_tAiType[1]
    monster.m_nBulletId = monsterData.bullet
    -- monster.m_bPenetrate = monsterData.penetrate == 1
    monster.m_sHeadId =  self.m_sAniFileId
    if monster.getMonsterConfig then
        monster.m_nBuffAnimOffsetX = monster:getMonsterConfig().buffAnimOffsetX
        monster.m_nBuffAnimOffsetY = monster:getMonsterConfig().buffAnimOffsetY
        monster.m_tbulletPosOffset = monster:getMonsterConfig().bulletPosOffset or {x=0,y=0}
        monster.m_bIsOldAnim = monster:getMonsterConfig().isSpine or false
    end
    monster.m_nFighting = monsterData.fighting

    local sExplode = "weapon1a" --tStrList.weapon
    if monsterData.broken ~= -1 then
        sExplode = monsterData.broken
    end

    if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS and WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_BOSSMAP_2 then
        local tempMapData = GDatatab_team_map["id_" .. WBattleGlobal:getCurrent().m_tMakePairOk.mapId]
        WZLog("WBattleGlobal:getCurrent().m_nBattleType", tempMapData.difficulty, tonumber(monsterData.level), WBattleGlobal:getCurrent().m_tMakePairOk.roomLevel)
        if tempMapData and tempMapData.difficulty == 4 and tonumber(monsterData.level) == -1 then 
            monster.m_nLevel = tonumber(WBattleGlobal:getCurrent().m_tMakePairOk.roomLevel)
            monster.m_nRealLevel = monster.m_nLevel
            local standardData = GDatatab_monster_standard["id_" .. monster.m_nLevel]
            monster.m_nHP = math.floor(monsterData.hp * standardData.hp/100)
            monster.m_nMaxHP = math.floor(monsterData.hp * standardData.hp/100)
            monster.m_nHP_Encrypt = BattleCommon:intEncrypt(monster.m_nHP)
            --攻击
            monster.m_nAttack = math.floor(monsterData.attack * standardData.attack/100)
            monster.m_nAttack_Encrypt = BattleCommon:intEncrypt(monster.m_nAttack)
            --怪暴击倍率
            monster.m_nCriticalhitAttackRate = math.floor(monsterData.crit * standardData.crit/100)
            monster.m_nCriticalhitAttackRate_Encrypt = BattleCommon:intEncrypt(monster.m_nCriticalhitAttackRate)
            --怪防御
            monster.m_nDefence = math.floor(monsterData.defend * standardData.defend/100)
            monster.m_nDefence_Encrypt = BattleCommon:intEncrypt(monster.m_nDefence)
            --怪免伤
            monster.m_nAgility = math.floor(monsterData.agility * standardData.agility/100)
            monster.m_nLucky = math.floor(monsterData.luck * standardData.luck/100)
            --怪免暴
            monster.m_nReduceCrit = math.floor(monsterData.reduce_crit * standardData.reduce_crit/100)
            monster.m_nReduceCrit_Encrypt = BattleCommon:intEncrypt(monster.m_nReduceCrit)
        end
    end
    
    local img = WeaponExplodeTexture[sExplode] or string.format("%sb",string.sub(sExplode,0,sExplode:len()-1))

    sExplode = RESOURCE_BULLET_EXPLODE..img..".png"
    monster.m_bulletCilcle = BattleUtil:getCircleImg(sExplode)
    monster.m_bulletCilcle:retain()

    WZLog("WMonster:setGuaiInfo two", self.m_sAniFileId, sExplode)

    if monster.m_tAniFileIndex ~= -1 then
        monster.m_bIsLeftFlip = monster.m_tAniFileIndex and monster:getMonsterConfig().animIsLeftFlip
        monster.m_tAnimPowerUpOffset = monster.m_tAniFileIndex and monster:getMonsterConfig().animPowerUpOffset or {x=0,y=0}
    end

    if monsterData.talk and monsterData.talk[1] ~= -1 then
        monster.m_nSklillTalkList = monsterData.talk --{{20000},{2000}}
    end

    monster.m_tSkillParam = monsterData.tSkillParam
    monster.m_nMonsterType = monsterData.type

    monster.m_nBeginMaxHp = monster.m_nMaxHP
    monster.suitConfig = monsterData.suitConfig
end

--@brief    获得配置
function WMonster:getMonsterConfig()
--    WZLog("WMonster:getMonsterConfig", self.m_tAniFileIndex)
    if not self.m_tMonsterConfig then
        self.m_tMonsterConfig = MonsterConfig[string.gsub(self.m_tAniFileIndex,"-","_")]
    end
    if not self.m_tMonsterConfig and WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_DOUBLETOWER_STAGE then 
        self.m_tMonsterConfig = MonsterConfig[string.gsub("boss_0010","-","_")]
    end
    if not self.m_tMonsterConfig and WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_ISLANDOWNER_STAGE then 
        self.m_tMonsterConfig = MonsterConfig[string.gsub("boss_0010","-","_")]
    end

    return self.m_tMonsterConfig
end

--@brief    获得ai策略
function WMonster:getAiScript()
    if self.m_tAiScript == -1 or self.m_tAiScript == nil then
        return nil
    end
    if self.m_tAiScript[self.m_nAiState] == nil then
        self.m_tAiScript[self.m_nAiState] = {}
    end
    return self.m_tAiScript[self.m_nAiState]
end

--@brief 设置ai策略下标
function WMonster:setAiState(value)
    WZLog("WMonster:setAiState",value)
    value = tonumber(value)
    if value > #self.m_tAiScript then
        value = #self.m_tAiScript
    end

    if value == self.m_nAiState then
        return 
    end

    self.m_nAiState = value
    self:getAI():changeAiState()
end


--@brief    变身
function WMonster:trans(index)

    local transPreIndex = -1
    for id, transState in pairs (self.m_tTransState) do
        if transState == true then
            transPreIndex = id
            self.m_tTransState[transPreIndex] = nil
        end
    end
    WZLog("WMonster:trans one", index, transPreIndex)
    self.m_tTransState[index] = true

    local pos = nil
    if transPreIndex ~= -1 then
        --self.m_headAnim:removeFromParentAndCleanup(true)
        --self.m_headAnim:release()
        self.m_mover:release()
        pos = self:getAnimation():getPosition()
    end

    --将Boss动画更换为变身后的动画
    self.m_sAniFileId = self.m_tAniFileId[index]
    self.m_nAiType = self.m_tAiType[index]
    self.m_nState = self.m_tState[index]
    self.m_bIsLeftFlip = self:getMonsterConfig().animIsLeftFlip
    self:setAnimConfig()

    if self.m_nAiType == MonsterAiType.AI_MELEE_SKY or self.m_nAiType == MonsterAiType.AI_NO_ACTION_SKY then
        self.m_bIsAir = true
        self.m_nState = 2
    end
    self:setMonsterState()
    self.m_tTransAnim[index] = self:initAnim()
    self.m_anim = self.m_tTransAnim[index]
    self:initAnimEffect()

    self:setMonsterState()
    self.m_tTransAnim[index] = self:initAnim()
    self.m_anim = self.m_tTransAnim[index]
    

    if transPreIndex ~= -1 then
        --将变身后的动画加入当前场景，并设置到正确位置
        SceneBattle:getFrontLayer():addChild(self.m_anim:getAnimNode())
        self:setPosition({x=pos.x,y=pos.y})
        if self:getMover() then
            WBattleGlobal:getCurrent().m_battleManager:addEntity(self:getMover())
        end

        if transPreIndex ~= index then
            --将Boss普通动画移除当前场景
            self.m_tTransAnim[transPreIndex]:getAnimNode():removeFromParentAndCleanup(true)
            self.m_tTransAnim[transPreIndex]:getAnimNode():release()
        end

        WZLog("WMonster:trans two", index, transPreIndex)
    end
end


--@brief    添加变身动画
function WMonster:addTransAnim()

    self.m_transAnim = BattleAnimation:createAnimation(IWCO_BOSS21)
    self.m_transAnim:setFlipX(true)
    self.m_transAnim:addAnimation("morph",{}, 0.05, true)

    local pos = self:getAnimation():getPosition()
    SceneBattle:getFrontLayer():addChild(self.m_transAnim:getAnimNode())
    self.m_transAnim:setPosition(Vector2:create(pos.x,pos.y))
    self.m_transAnim:play("morph", false)
end

--@brief 播放动作
function WMonster:play(actionName,isLoop)
    if self.m_anim then
        self.m_anim:play(actionName,isLoop)
    end
    if self.m_animEffect then
        self.m_animEffect:play(actionName,isLoop)
    end
end

--@brief    初始化基础动画
function WMonster:initAnim()
    WZLog("WMonster:initAnim",self.m_nScale,tostring(self.m_sAniFileId),self.m_nAiType, tostring(self:getMonsterConfig().armatureName))
    
    -- self.m_sAniFileId = "monster_0023"
    
    local anim = nil
    --初始化动画

    if self.m_bIsOldAnim == true then
        --动画控制对象
        anim = BattleAnimation:createAnimation(self:getMonsterConfig().armatureName or self.m_sAniFileId, false, "battle/monster")
        anim:getAnimNode():retain()
        anim:setScale(self.m_nScale)
    else
        --动画控制对象
        anim = BattleAnimation:createAnimation(self:getMonsterConfig().armatureName or self.m_sAniFileId, true)
        anim:getAnimNode():retain()
        anim:setScale(self.m_nScale)
        
    end
    if not self.m_bIsAir then
        --小怪Mover
        self.m_mover = WDMoveEntity:create(anim:getAnimNode())
        self.m_mover:setAdjustChild(true)
        self.m_mover:retain()

        local center = Vector2:create(0,50)
        self.m_mover:setMoverCenter(center)
        self.m_mover:setMoverRadius(10)
    end


    --添加头像
    self.m_headAnim = "battle/head/"..string.gsub( self.m_sHeadId,"-","_")..".png"
    return anim
end

--@brief 初始化特效
function WMonster:initAnimEffect()
    local animName = self:getMonsterConfig().armatureName or self.m_sAniFileId
    animName = animName .. "_effect"
    local path = "battle/monsterEffect"
    local file = path.."/"..animName .. ".json"
    WZLog("WMonster:initAnimEffect",file,WZFileUtil:isFileExist(file))
    if WZFileUtil:isFileExist(file) then
         local animEffect = BattleAnimation:createAnimation(animName, false,path)
        animEffect:getAnimNode():retain()
        animEffect:setScale(self.m_nScale)
        self.m_animEffect = animEffect

        self.m_anim:getAnimNode():addChild(animEffect:getAnimNode())
        animEffect:getAnimNode():setAnchorPoint(self:getSceneAnchorPoint())
        animEffect:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.5,0))
    end
end

--@brief    初始化基础动画
function WMonster:initShopAnim()
    if self.m_bIsOldAnim == true then
        --商城形象
        self.m_shopAnim = BattleAnimation:createAnimation(self:getMonsterConfig().armatureName or self.m_sAniFileId, false, "battle/monster")
        self.m_shopAnim:getAnimNode():retain()
    --    self.m_shopAnim:setScale(self.m_nScale)
    else
        --商城形象
        self.m_shopAnim = BattleAnimation:createAnimation(self:getMonsterConfig().armatureName or self.m_sAniFileId, true)
        self.m_shopAnim:getAnimNode():retain()
    --    self.m_shopAnim:setScale(self.m_nScale)
    end

end

--@brief	设置动画配置
function WMonster:setAnimConfig()

    local animType = {"animNormal", "animViolent", "animAir", "animAirViolent","shockScreenAni"}
    for id, animTypeName in pairs (animType) do
        local animationInfo = self:getMonsterConfig()[animTypeName]

        local animationName = {}
        if animationInfo ~= nil then
            local animationInfoList = SplitStringWithSeparator(animationInfo, "|")
            for id, info in pairs(animationInfoList) do
--                WZLog("WMonster:setAnimConfig two", id, info)
                StringIntsertToTable(animationName,info)
            end
        end
        self[animTypeName] = animationName
    end
end

--@brief	设置测试用数值
function WMonster:setTestValue()
    do return end

    if true or self.m_tTransState == nil or self.m_tAniFileId[2] == nil then
        if self.m_bIsSummon == true then
            if self.m_nInfoIndex == 1 then
                self.m_tAniFileId = {[1]="boss7",}
                self.m_tAiType = {[1]=MonsterAiType.AI_MELEE,}
                self.m_tDataId = {[1]=self:getId(),}
                self.m_tState = {[1]=MonsterState.NORMAL,}
                self.m_sAniFileId = self.m_tAniFileId[1]
                self.m_nAiType = self.m_tAiType[1]
            elseif self.m_nInfoIndex == 2 then
                self.m_tAniFileId = {[1]="boss7",}
                self.m_tAiType = {[1]=MonsterAiType.AI_RANGED_MELEE,}
                self.m_tDataId = {[1]=self:getId(),}
                self.m_tState = {[1]=MonsterState.NORMAL,}
                self.m_sAniFileId = self.m_tAniFileId[1]
                self.m_nAiType = self.m_tAiType[1]
            end
        elseif self.m_bIsSummon ~= true then
            self.m_tAniFileId = {[1]="boss2-1",}
            self.m_tAiType = {[1]=MonsterAiType.AI_RANGED_MELEE,}
            self.m_tDataId = {[1]=self:getId(),}
            self.m_sAniFileId = self.m_tAniFileId[1]
            self.m_tState = {[1]=MonsterState.NORMAL,}
            self.m_nAiType = self.m_tAiType[1]
        end
    end
end

--@brief	设置刚出现的属性值
function WMonster:setAppearAttribute(isTest)
    WZLog("WMonster:setAppearAttribute", self.m_sAniFileId, tostring(self.m_nState))
    if isTest == nil then
        self:setTestValue()
    end

    local state = "Normal"
    if self.m_nState == 1 then
        state = "Normal"
    elseif self.m_nState == 2 then
        state = "Air"
    else
        state = "Violent"
    end
    self:changeState("anim"..state)

    --[[
    if self:getPosition().x < 500 then
        WZLog("WMonster:setAppearAttribute two")
        if self.m_bIsOldAnim == true then
            self:getAnimation():setFlipX(false)
        else
            self:getAnimation():setFlipX(true)
        end
    end
    --]]
end

function WMonster:setMonsterState(stateName)
    if stateName == "animNormal" then
        self.m_bIsAirViolent = nil
        self.m_bIsAir = nil
        self.m_bIsViolent = nil
    elseif stateName == "animAirViolent" then
        self.m_bIsAirViolent = true
        self.m_bIsAir = true
        self.m_bIsViolent = true
    elseif stateName == "animAir" then
        self.m_bIsAirViolent = nil
        self.m_bIsAir = true
        self.m_bIsViolent = nil
    elseif stateName == "animViolent" then
        self.m_bIsAirViolent = nil
        self.m_bIsAir = nil
        self.m_bIsViolent = true
    end
end

--@brief	改变状态
function WMonster:changeState(stateName)
    WZLog("WMonster:changeState",stateName, tostring(self.m_bIsAir))
    local isAirPre = self.m_bIsAir
    if stateName == "animNormal" then
        self.m_bIsAirViolent = nil
        self.m_bIsAir = nil
        self.m_bIsViolent = nil
        self:setMoveUpdatable(true)
    elseif stateName == "animAirViolent" then
        self.m_bIsAirViolent = true
        self.m_bIsAir = true
        self.m_bIsViolent = true
        self:setMoveUpdatable(false)
    elseif stateName == "animAir" then
        self.m_bIsAirViolent = nil
        self.m_bIsAir = true
        self.m_bIsViolent = nil
        self:setMoveUpdatable(false)
    elseif stateName == "animViolent" then
        self.m_bIsAirViolent = nil
        self.m_bIsAir = nil
        self.m_bIsViolent = true
        self:setMoveUpdatable(true)
    end

    self:changeRectCollision()
    self:changeArmatureAnchorPoint()

    self:play(self:getAnimationName("standby"),true)
end

--@brief	改变骨骼瞄点
function WMonster:changeArmatureAnchorPoint()

    if (self:getAnimation():getAnimNode().getArmature ~= nil and self:getAnimation():getAnimNode():getArmature() ~= nil) then
        self:getAnimation():getAnimNode():getArmature():setAnchorPoint(GlobalMethod:ccp(0.5,self:getArmatureOffsetY() or 0.05))
        WZLog("WMonster:changeArmatureAnchorPoint two", tostring(self:getArmatureOffsetY()))
    end

end

--@brief	改变碰撞矩形
function WMonster:changeRectCollision()

    ---[[
    --添加碰撞矩形
    local size = self.m_anim:getAnimNode():getContentSize()
    local centerPos = self:getCenterPos()

    local rectCollisionConfig = self:getMonsterConfig().rectCollision

    if self.m_bIsAir == true then
        rectCollisionConfig = self:getMonsterConfig().rectCollisionAir or self:getMonsterConfig().rectCollision
    end

    self:clearCollisionRang()
    if rectCollisionConfig == nil then 
        self:addRectCollision(size.width * 0.7,size.height * 0.7,centerPos.x,centerPos.y)
        WZLog("WMonster:changeRectCollision one", self.m_sAniFileId)
    else
        for i, info in pairs (rectCollisionConfig)do
            self:addRectCollision(info.width * self.m_nScale, info.height * self.m_nScale,info.x * self.m_nScale, info.y * self.m_nScale)
            WZLog("WMonster:changeRectCollision two", self.m_sAniFileId, info.width, info.height,info.x, info.y, self.m_nScale)
        end
    end

    self:showCollisionRang(true)
    --]]


end

--@brief	获取骨骼瞄点偏移
function WMonster:getArmatureOffsetY()
    local offsetY = nil

    if self.m_bIsGuaiWithSuit == true then
        offsetY = 0
    else
        self.m_nArmatureOffsetY = self:getMonsterConfig().armatureOffsetY
        self.m_nArmatureOffsetYAir = self:getMonsterConfig().armatureOffsetYAir or self:getMonsterConfig().armatureOffsetY

        if self.m_bIsAir == nil then
            offsetY =  self.m_nArmatureOffsetY
        else
            offsetY =  self.m_nArmatureOffsetYAir
        end
        WZLog("WMonster:getArmatureOffsetY", self.m_sAniFileId, tostring(self.m_bIsAir), offsetY)
    end
    return offsetY
end

--@brief	是否可以控制该角色
--@return	#1:true：是，false：否
function WMonster:isCanControl()
    if WBattleGlobal:getCurrent():isSingleStage() then
        return true
    end
    
    local isCanControl = false

    -- if self:getBattleId() == WBattleGlobal:getCurrent():getMyBattleId() or self.m_bCanControl == true or (self.m_tBoss ~= nil and self.m_tBoss.m_bCanControl == true) then
    if WBattleGlobal:getCurrent():isHostControl() then
        isCanControl = true
        self.m_bCanControl = true
    end
    return isCanControl
end

function WMonster:isCurrentControl()
    -- if WBattleGlobal:getCurrent():isSingleStage() then
    --     return true
    -- end

    local battleId = self:getBattleId()
    if self:isFollowIndependent() then
        battleId = self.m_tBoss:getBattleId()
    end
    WZLog("WMonster:isCurrentControl",battleId,WBattleGlobal:getCurrent():getCurrentCharacterId(),self:getBattleId())
    if battleId == WBattleGlobal:getCurrent():getCurrentCharacterId() then
        return true
    end

    return false
end

--@brief	创建商城动画
function WMonster:createShopAnimation(isFlip)
    local anim = nil
    local conRole = nil
    if self.m_bIsOldAnim == true then
        anim = BattleAnimation:createAnimation(self:getMonsterConfig().armatureName or self.m_sAniFileId)
        anim:addAnimation(self:getAnimationName("standby"),{}, 0.2, true)
        anim:playTimes(self:getAnimationName("standby"),0)
        anim:getAnimNode():setFlipX(isFlip)
        WZLog("WMonster:createShopAnimation two", self.m_sAniFileId, isFlip)
        return anim:getAnimNode(), self.m_bIsOldAnim
    else
        anim = BattleAnimation:createAnimation(self:getMonsterConfig().armatureName or self.m_sAniFileId, true)
        anim:setScale(1.0)
        anim:getAnimNode():setFlipX(isFlip)
        WZLog("WMonster:createShopAnimation three", self.m_sAniFileId, isFlip, tostring(self:getMonsterConfig().armatureName), tostring(self.m_sAniFileId), tostring(anim))
        anim:setPosition(Vector2:create(53, 0))
        conRole = WZUIContainer:create()
        conRole:setUseAbsSize(true)
        conRole:setAbsContentSize(GlobalMethod:CCSize(106, 230))
        conRole:addChild(anim:getAnimNode())
        return conRole, self.m_bIsOldAnim
    end

end

--@brief	添加冰冻动画
function WMonster:addFrozenAnimation()
    WZLog("WMonster:addFrozenAnimation")
    if self.m_frozenAnim == nil then
        self.m_nDebuffFrozenRound = 3
        self.m_frozenAnim = BattleAnimation:createAnimation(WANI_IWCO_WORLDBOSS1)
        self.m_frozenAnim:addAnimation("freeze",{},0.1,true)
        self.m_frozenAnim:play("freeze",true)
        local size = self.m_anim:getAnimNode():getContentSize()
        self.m_frozenAnim:getAnimNode():setPosition(GlobalMethod:ccp(size.width*0.50,size.height*0.00))
        self.m_frozenAnim:getAnimNode():setScale(1.1)
        self.m_anim:getAnimNode():addChild(self.m_frozenAnim:getAnimNode(), 10)
    end
end

--@brief 同步血量
function WMonster:setHp(nHp)
    nHp = tonumber(nHp)
    if self:isDead() and nHp > 0 then
        WZLog("WMonster:resurrection")
        self:setDead(false)
        self.m_bIsShowDead = nil
    end
    WCharacter.setHp(self,nHp)
end

--@brief	设置是否死亡
function WMonster:setDead(bDead, note)
    WZLog("WMonster:setDead one", tostring(bDead), tostring(note))
    if self.m_bIsDead ~= bDead then
        self.m_bIsDead = bDead
    end
    if self.m_bIsDead then
        --触发击杀生效技能
        self:doKillEffect()
        --移除他的棋圣分身
        local subHeroList = WBattleGlobal:getCurrent():getSubHero(self.m_nBattleId)
        if subHeroList and #subHeroList > 0 then 
            local nCount = #subHeroList 
            for i = 1, nCount do
                WBattleGlobal:getCurrent():removeSoulHero(subHeroList[i]:getBattleId())
            end
        end
        BattleCtbManager:setDead(self:getBattleId() ,true)
        self.m_bIsDead = bDead
        self.m_bIsCanMove = nil
        self:setHp(0)
        WCharacter.clearAllBuff(self)
        if WBattleGlobal:getCurrent():isSingleStage() then
            self:setServerDead(true)
        end

        GlobalGame:getBattleEventDispatcher():Dispatch(BATTLE_EVENT_TYPE.MONSTER_DEAD,self)
        WZLog("WMonster:setDead two",WBattleGlobal:getCurrent():getCurrentCharacterId(),self:getBattleId(),self:isCanControl())
        if WBattleGlobal:getCurrent():getCurrentCharacterId() == self:getBattleId() and self:isCanControl() then
            WBattleGlobal:getCurrent():endCurRound(self:getBattleId(),100)
        end
    else
        self.m_bIsShowDead = nil
        self:removeDeadAnimation()
        self:getAnimation():getAnimNode():setVisible(true)
        self:play(self:getAnimationName("standby"), true)
        WZLog("WMonster:setDead two", tostring(self:getAnimation()))
    end
end

--@brief 自爆
function WMonster:setBoom(val)
    if self.m_bIsBoom == val then
        return
    end
    self.m_bIsCanMove = nil
    self.m_bIsBoom = val
    self:play(self:getAnimationName("boom"),false)

    if WBattleGlobal:getCurrent():isSingleStage() then
        self:setServerDead(true)
    else
        if self:isCanControl() then
            ProtocolProcessorBattleInterface:send_BATTLE_OutOfScene(WBattleGlobal:getCurrent().m_tMakePairOk.battleId, self:getBattleId() ,WBattleGlobal:getCurrent():getCurrentCharacterId())
        end
    end
end

--@brief 牺牲
function WMonster:setSacrifice(val)
    if self.m_bIsSacrifice == val then
        return
    end
    self.m_bIsCanMove = nil
    self.m_bIsSacrifice = val
    self:play(self:getAnimationName("sacrifice"),false)
    if WBattleGlobal:getCurrent():isSingleStage() then
        self:setServerDead(true)
    else
        if self:isCanControl() then
            ProtocolProcessorBattleInterface:send_BATTLE_OutOfScene(WBattleGlobal:getCurrent().m_tMakePairOk.battleId, self:getBattleId(), WBattleGlobal:getCurrent():getCurrentCharacterId())
        end
    end
end

--@brief 是否自爆
function WMonster:isSacrifice()
    return self.m_bIsSacrifice
end

--@brief 是否自爆
function WMonster:isBoom()
    return self.m_bIsBoom
end

--@brief	设置boss
function WMonster:setBoss(tBoss)
    self.m_tBoss = tBoss
end

--@brief 		获得某种近战小怪的领导
function WMonster:getMonsterLeader()
    local leader

    for index, monster in ipairs (self.m_tOwnedMonsterList) do
        if (monster.m_nAiType == MonsterAiType.AI_MELEE or monster.m_nAiType == MonsterAiType.AI_MELEE_SKY) and monster:isDead() ~= true and monster:getHp() > 0 then
            leader = monster
            break
        end
    end
    return leader
end


--@brief 		获得小怪列表
--@return		#1:小怪列表
--@note			提供boss重载,可返回空表
function WMonster:getChildCharaList()
    return self.m_tOwnedMonsterList
end

--@brief 获得更随独立ai小怪列表
function WMonster:getFollowIndependentMonsterList()
    local list = {}
    for index, monster in ipairs (self.m_tOwnedMonsterList) do
        if monster:isFollowIndependent() then
             table.insert(list, monster)
        end
    end
    return list
end

--@brief 获得更随（非独立ai）小怪列表
function WMonster:getFollowMonsterList()
    local list = {}
    for index, monster in ipairs (self.m_tOwnedMonsterList) do
        if monster:isFollowAct() then
             table.insert(list, monster)
        end
    end
    return list
end

--@brief	获取头像控制对象
--@return	#1:Animation动画控制对象
function WMonster:getHeadAnimation()
	return self.m_headAnim
end



--@brief	获取动画列表
function WMonster:getAnimationNameList()

    local list = {}
    local animType = {"animNormal", "animViolent", "animAir", "animAirViolent"}
    for id, animTypeName in pairs (animType) do
        for id, name in pairs (self[animTypeName]) do
            table.insert(list, name)
        end
    end
    return list
end

--@brief 获取震动屏幕系数
function WMonster:getShockScreenByAniName(name)
    return self.shockScreenAni and self.shockScreenAni[name] or nil
end

--@brief	获取动画
function WMonster:getAnimationName(index)
    if self.m_sAniFileId == "boss_1008" or  self.m_sAniFileId == "boss_1009" or self.m_sAniFileId == "boss_1010" or self.m_sAniFileId == "boss_1011" then
        return self:getAnimationNameByBuff(index)
    end
    if self.m_bIsAirViolent == true then
        return self.animAirViolent[index] or self.animAirViolent["standby"] or self.animNormal[index] or self.animNormal["standby"]
    elseif self.m_bIsAir == true then
        return self.animAir[index] or self.animAir["standby"] or self.animNormal[index] or self.animNormal["standby"]
    elseif self.m_bIsViolent == true then
        return self.animViolent[index] or self.animViolent["standby"] or self.animNormal[index] or self.animNormal["standby"]
    else
        return self.animNormal[index] or self.animNormal["standby"]
    end
end

--@特殊怪物获取名字
function WMonster:getAnimationNameByBuff(index)

    if index == "standby" or index == "dead" or index == "hurt" or index == "laser" or index == "run" or index == "sign" then
        index = index.."_"..self.m_nBuffAnimState
    end
    local isAddEnd = false
    
    if self.m_sAniFileId == "boss_1008" then
        if string.find(index,"shoot") or string.find(index,"flak") then
            isAddEnd = true
        end
    elseif self.m_sAniFileId == "boss_1009" then
        if string.find(index,"shoot") or string.find(index,"Atk") or string.find(index,"summon") then
            isAddEnd = true
        end
    elseif self.m_sAniFileId == "boss_1010" then
        if string.find(index,"shoot") then
            isAddEnd = true
        end
    elseif self.m_sAniFileId == "boss_1011" then
        if index == "move" then
            index = index.."_"..self.m_nBuffAnimState
        end
        if string.find(index,"shoot") or string.find(index,"pow") or string.find(index,"atk") or string.find(index,"tread") or string.find(index,"summon") then
            isAddEnd = true
        end
    end

    if isAddEnd then
        local endstr = "a"
        if self.m_nBuffAnimState == 2 then
            endstr = "b"
        elseif self.m_nBuffAnimState == 3 then
            endstr ="c"
        end
        index = index..endstr
    end
    -- WZLog("WMonster:getAnimationNameByBuff",self.m_nBuffAnimState,index)
    
    if self.m_sAniFileId == "boss_1010" or self.m_sAniFileId == "boss_1011" then
        return self.animNormal[index] or self.animNormal["standby_1"]
    end
    
    return self.animAir[index] or self.animAir["standby_1"]
end



--@brief	获取待机动画
function WMonster:getNormalAnimationName()
    return self:getAnimationName("standby")
end

--@brief	获取受伤动画
function WMonster:getHurtAnimationName()
    return self:getAnimationName("hurt")
end

--@brief	获取死亡动画
function WMonster:getDeadAnimationName()
    return self:getAnimationName("dead")
end

--@brief	显示受伤动画
function WMonster:showHurt()
    if self.m_bPenetrate == true then
        WZLog("WMonster:showHurt two")
        self.m_bIsHurt = false
        if self.m_bPassiveAttack ~= true then
            self.m_bPassiveAttack = true
        end
    elseif self.m_bPenetrate ~= true then
        local isShowHurtEnd =  WCharacter.showHurt(self)
        if isShowHurtEnd == true then
            self.m_bPassiveAttack = true
        end
    end
end


--@brief	添加人物碰撞列表
--@param	tCharas:人物碰撞列表
function WMonster:addCollisionCharas(tCharas)
    if self.m_tCollisionCharacters == nil then
        self.m_tCollisionCharacters = {}
    end
    
	table.insert(self.m_tCollisionCharacters,tCharas)
end

--@brief	开始行动
function WMonster:startRound()
    self.m_bPassiveAttack = false
    self.m_bIsCanMove = true
    WZLog("WMonster:startRound", WBattleGlobal:getCurrent():getCurrentCharacterId(), self:getBattleId(), self:getId())
	if WBattleGlobal:getCurrent():getCurrentCharacterId() == self:getBattleId() then
		self:getAI():startRound()
    elseif WBattleGlobal:getCurrent():getCurrentCharacterId() == -1 then
        for i, monster in pairs (self.m_tOwnedMonsterList) do
            --monster:getAI():startRound()
        end
	end

end

--@brief 更随独立ai小怪开始行动（仅仅单人副本适用，无法同步）
function WMonster:followIndependentStartRound()
    for i, monster in ipairs (self.m_tOwnedMonsterList) do
        if monster:isFollowIndependent() then
            monster:getAI():startRound()
            monster.m_bIsCanMove = true
        end
    end
end

--@brief 跟随小怪开始行动（组队副本，固定表现流程适用）
function WMonster:followStartRound()
    for i, monster in ipairs (self.m_tOwnedMonsterList) do
        if monster:isFollowAct() then
            monster:updateByTurn()
            monster:getAI():startRound()
            monster.m_bIsCanMove = true
        end
    end
end

--@breif 是否有跟随独立行动
function WMonster:hasFollowIndependentMonster()
    for i, monster in ipairs (self.m_tOwnedMonsterList) do
        if monster:isFollowIndependent() then
            return true
        end
    end
    return false
end

--@brief	结束行动
function WMonster:endRound()
	self:getAI():endRound()
end

--@brief	经过一回合后的英雄状态和属性更新
function WMonster:updateByTurn()

    WCharacter.updateByTurn(self)

    if self.m_nDebuffFrozenRound ~= nil and self.m_nDebuffFrozenRound > 0 then
        self.m_nDebuffFrozenRound = self.m_nDebuffFrozenRound - 1
    end
end

function WMonster:runOwnerMsg(dt)
    if self.m_tOwnerMsgMgr then
        self.m_tOwnerMsgMgr:update(dt)
    end
end

function WMonster:pushBlockMsg(msg)
    if self.m_tOwnerMsgMgr then
        self.m_tOwnerMsgMgr:pushBlockMsg(msg)
    end
end

function WMonster:pushNonBlockMsg(msg)
    if self.m_tOwnerMsgMgr then
        self.m_tOwnerMsgMgr:pushNonBlockMsg(msg)
    end
end

function WMonster:isSpecAnchorAnim()
    if self.m_sAniFileId == "boss_1002b" or self.m_sAniFileId == "boss_2001" then
        return true
    end
    return false
end

--@brief 血槽不参与排序
function WMonster:isOffSortName()
    if self.m_sAniFileId == "boss_1002b" then
        return true
    end
    return false
end

function WMonster:getSceneAnchorPoint()
    local bool = false
    if self:isSpecAnchorAnim() then
        return GlobalMethod:ccp(0.5,0.5)
    end
    return GlobalMethod:ccp(0.5,0.06)
end

--@brief	定时更新函数
--@param	dt:距离上一次调用的时间（秒）
--@note		由定时器调用
function WMonster:update(dt)
    if self:getAnimation() == nil then
        return nil
    end
    -- WZLog("WMonster:update",self:getBattleId(),self:getAnimation():getAnimNode():getAnimationName())
    self:setTestValue()
    self:updateDialogPos()

    WCharacter.update(self,dt)

    self:runOwnerMsg(dt)

    --检测与孩子的碰撞
    if not self:isDead() then 
        local isCollision, tempCharas = self:checkKidCollision()
        local childId = {}
        if isCollision then 
            for i, kid in pairs(tempCharas) do
                WZLog("WMonster:update", kid:getBattleId())
                kid:setDead(true, 18)
                table.insert(childId, kid:getBattleId())
            end
            if self:isCanControl() and GetTableLen(childId) > 0 then
                ProtocolProcessorBattleInterface:send_BATTLE_HitChild(WBattleGlobal:getCurrent().m_tMakePairOk.battleId, self:getBattleId(), TableToIntVector(childId))
            end
        end
    end

    --@warn:表演消息队列有移除对象的功能（多加一个限制处理）
    if self:getAnimation() == nil then
        return nil
    end
    
    --自爆处理
    if self:isBoom() then
        self:clearMonsterList()
        self:updateBoomAct()
        return
    end
    --牺牲处理
    if self:isSacrifice() then
        self:clearMonsterList()
        self:updateSacrificeAct()
        return
    end

    self:moveToPosUpdate()
    if not self:isDead() and self:getHp() > 0 then
        self:_addBossName()
    end
    
    --小怪血条和姓名
	if self.m_bIsAddedInScene then
		self:_addGuaiName()
	end

	--死亡处理
	-- if self:isDead() then
 --        if --[[self:getPlayerNameIcon().m_bIsHpActionDone ~= false and]] self.m_bIsShowDead == nil then
 --            SoundManager:playEffectSound(SoundDefine.E_S_MONSTER_DEAD)

 --            self:clearMonsterList()

 --            BattleCtbManager:setDead(self:getBattleId() ,true)
 --            self:getAnimation():play(self:getAnimationName("dead"),false)
 --            self:addDeadAnimation()
 --            self:clearAllBuff()
 --        end

	-- 	if self:getPlayerNameIcon().m_bIsHpActionDone ~= false and self:getAnimation():isPlaying(self:getAnimationName("dead")) == true and self:getAnimation():isCurrentAnimationDone() then
	-- 		self:_removeDeadGuai()
 --            if TeachGroup1.ISFIRSTBATTLE then
 --                SoundManager:playEffectSound("mly_dead.mp3")
 --            end
	-- 	end
 --        return nil
	-- end
    if self:isDead() then
        if self.m_bIsShowDead == nil then
            self.m_bIsShowDead = true
            self:play(self:getAnimationName("dead"),false)
            self:addDeadAnimation()
            SoundManager:playEffectSound(SoundDefine.E_S_MONSTER_DEAD)
             self.m_nDeadCountTime = 0
        end
        local deadTimeOut = false
        --死亡计时
        if self:isServerDead() and self.m_nDeadCountTime then
            self.m_nDeadCountTime = self.m_nDeadCountTime + dt
            if self.m_nDeadCountTime > 5 then
                deadTimeOut = true
                self.m_nDeadCountTime = nil
                if self:getPlayerNameIcon() then
                    self:getPlayerNameIcon().m_bIsHpActionDone = nil
                end
            end
        end
        WZLog("WMonster:update one", tostring(self:isServerDead()), tostring(self:getPlayerNameIcon()), tostring(self:getPlayerNameIcon() and self:getPlayerNameIcon().m_bIsHpActionDone), tostring(self:getAnimationName("dead")))
        if self:isServerDead() and (deadTimeOut or ((self:getPlayerNameIcon() == nil or self:getPlayerNameIcon().m_bIsHpActionDone ~= false) and self:getAnimation():isPlaying(self:getAnimationName("dead")) == true and self:getAnimation():isCurrentAnimationDone())) then
            self:clearMonsterList()
            --BattleCtbManager:setDead(self:getBattleId() ,true)
            self:clearAllBuff()
            self:_removeDeadGuai()
            if TeachGroup1.ISFIRSTBATTLE then
                SoundManager:playEffectSound("mly_dead.mp3")
            end
        end
        return nil
    end
    
    local isOutOfScene = self:checkIsOutOfScene()
	if isOutOfScene then
		if self:isOutOfScene()==false then
			-- if self:isCanControl() == true then
				if not self:isDead() and SceneBattle:getBattleLoop():getBattleStatus() ~= BattleLoop.S_PLAYER_FLY then
                    self:_postMonsterDropDeadEvent()
					ProtocolProcessorBattleInterface:send_BATTLE_OutOfScene(WBattleGlobal:getCurrent().m_tMakePairOk.battleId, self:getBattleId() ,WBattleGlobal:getCurrent():getCurrentCharacterId())
					if SceneBattle:getBattleLoop():getBattleStatus() ~= BattleLoop.S_PLAYER_SHOOT then
						WndBattleHud:setPassTurnBtnEnable(false)
						WndBattleHud:endTurn()

                        if self:isDead() ~= true then
                            self:setDead(true,17)
                        end
					end
				end
			-- end
		end
	end
	self.m_bIsOutOfScene = isOutOfScene
    
    ---[[
    
    if self:getAnimation():isCurrentAnimationDone() == true and self.m_bAutoStandAction then
        self:play(self:getNormalAnimationName(), true)
    end
    --]]


    -- self:updateTalkPos()

    self:getAI():run(dt)
end

function WMonster:updateDialogPos()
    if self.m_nDialogOffset and self.m_tDialogElement then
        local point = ccp(self:getPosition().x + self.m_nDialogOffset.x, self:getPosition().y + self.m_nDialogOffset.y)
        point = self:getAnimation():getAnimNode():getParent():convertToWorldSpace(point)
        point = SceneBattle:getInfoLayer():convertToNodeSpace(point)
        self.m_tDialogElement:setPosition(point)
    end
end

function WMonster:clearMonsterList()
    -- if self.m_bIsShowDead then 
    --     return
    -- end

    -- self.m_bIsShowDead = true
    if self.m_tBoss ~= nil then
        local boss = self.m_tBoss
        for id = #boss.m_tOwnedMonsterList, 1, -1 do
            WZLog("WMonster:setDead two", id, boss.m_tOwnedMonsterList[id]:getBattleId())
            if self:getBattleId() == boss.m_tOwnedMonsterList[id]:getBattleId() then
                WZLog("WMonster:setDead three", id)
                table.remove(boss.m_tOwnedMonsterList, id)
                break
            end
        end
    end
end

function WMonster:updateBoomAct()
   if self:getAnimation():isPlaying(self:getAnimationName("boom")) == true and self:getAnimation():isCurrentAnimationDone() then
        self:_removeDeadGuai()
    end
end

function WMonster:updateSacrificeAct()
   if self:getAnimation():isPlaying(self:getAnimationName("sacrifice")) == true and self:getAnimation():isCurrentAnimationDone() then
        self:_removeDeadGuai()
    end
end

--@brief	添加子弹跟踪动画
function WMonster:addFollowAnimation()
    --世界boss 不显示
    if WBattleGlobal:getCurrent():isWorldBossStage() then
        return
    end
    if self.m_followAnim == nil then
        self.m_followAnim = BattleAnimation:createAnimation("skills_zzd_sd",true)
        --self.m_anim:getAnimNode():addChild(self.m_followAnim:getAnimNode(),1000)
        -- local size = self.m_anim:getAnimNode():getContentSize()
        -- self.m_followAnim:getAnimNode():setPositionX(size.width*0.5)
        -- self.m_followAnim:getAnimNode():setPositionY(size.height* -0.2)
        local pos = self:getCenterPos()
        self.m_followAnim:setPosition(Vector2:create(pos.x,pos.y - 80))
        SceneBattle:getFrontLayer():addChild(self.m_followAnim:getAnimNode())
        self.m_followAnim:play("0",true)
    end
end

--@brief	销毁一个角色
function WMonster:destroy()
    if WBattleGlobal:getCurrent().m_battleManager ~= nil and self:getMover() then
        WBattleGlobal:getCurrent().m_battleManager:removeEntity(self:getMover())
    end
    self.m_tOwnerMsgMgr:clear()
    self.m_tOwnerMsgMgr = nil
	WCharacter.destroy(self)
    self:getAI():destroy()
    
    self:getAnimation():getAnimNode():release()
	self:getShopAnimation():release()
    --self.m_headAnim:release()
    if self.m_mover then
        self.m_mover:release()
	   self.m_mover = nil
    end
	self.m_anim = nil
    if self.m_animEffect then
        self.m_animEffect:getAnimNode():release()
        self.m_animEffect = nil
    end
	self.m_shopAnim = nil
    --self.m_headAnim = nil
    self.m_tSkills = nil
    self.m_tItems = nil

    self.m_bulletCilcle:release()
    self.m_bulletCilcle = nil

    if self.m_tGuaiName ~= nil then
        self.m_tGuaiName:destroy()
    end
    
end

--@brief	获取武器名字
--@return	#1:武器名字
function WMonster:getWeaponName()
    WZLog("WMonster:getWeaponName", self.m_sWeaponName)
    if self.m_sWeaponName ~= nil and self.m_sWeaponName ~= "-1" then
        return self.m_sWeaponName
    else
        self.m_sWeaponName = "weapon17a"
        WZLog("WMonster:getWeaponName two", "weapon17a")
        return "weapon17a"
    end
end

--@brief	获取武器名字
--@return	#1:武器名字
function WMonster:getExplodeAnimName()
    WZLog("WMonster:getExplodeAnimName", self.m_sExplodeAnimName)
    if self.m_sExplodeAnimName ~= nil and self.m_sExplodeAnimName ~= "-1" then
        return self.m_sExplodeAnimName
    else
        self.m_sExplodeAnimName = "weapon17a"
        WZLog("WMonster:getExplodeAnimName two", "weapon17a")
        return "weapon17a"
    end
end

--@brief	判断是否超出屏幕
function WMonster:isOutOfScene()
	return self.m_bIsOutOfScene
end

--@brief	检测是否超出屏幕
--@return	#1:是否超出屏幕
--@return	#2:是否纵向超出屏幕
function WMonster:checkIsOutOfScene()
    if self:getMover() == nil then
        return false, false
    end
	if SceneBattle:getFrontLayer() then
		local sceneSize = SceneBattle:getFrontLayerSize()
        local a = self:getMover():getMoverPosition()
        a = {x = a.x,y = a.y}
        
        --纵向超出屏幕
		if a.y < -50 then
			return true, true
            --横向超出屏幕
            elseif a.x < -50 or a.x > sceneSize.width + 50 then
            return true, false
		end
	end
	return false, false
end

--@brief 	设置人物当前的位置
--@param 	tPos 当前位置
function WMonster:setPosition(tPos)
    if (not tPos) or (not self.m_anim) then
        return
    end
	self.m_tPosition = tPos
    if self.m_mover then
	   self.m_mover:setMoverPosition(Vector2:create(tPos.x,tPos.y))
    end
	self.m_anim:setPosition(Vector2:create(tPos.x,tPos.y))
end

--@brief	经过一回合后的英雄状态和属性更新
function WMonster:updateByTurn()
	WCharacter.updateByTurn(self)

end

--@brief    调整动画位置
function WMonster:adjustAnimPos()
    local anchor = self:getAnimation():getAnimNode():getAnchorPoint()
    local size = self:getAnimation():getAnimNode():getContentSize()
    local heroCenter = CCPointMake(anchor.x*size.width,anchor.y*size.height)
    local ccArray = self:getAnimation():getAnimNode():getChildren()
    if ccArray and ccArray:count() > 0 then
        for i=0,ccArray:count()-1 do
            tolua.cast(ccArray:objectAtIndex(i),"CCNode"):setPosition(heroCenter.x,heroCenter.y)
        end
    end
end

--@brief 获得对话框位置
function WMonster:getAnimDialogPos()
    if not self.m_tDialogPos then
        local scale = self:getScale()
        local size = self:getMonsterConfig().animSize
        self.m_tDialogPos = BattleCommon:getPointTable(0.4*size.width* scale,0.75*size.height*scale)
    end
    return self.m_tDialogPos
end

--@brief 		小怪移动
--@param		nMoveCount:移动次数
--@param 		vnMoveStep:每次移动的方向
--@note			提供boss重载
function WMonster:receiveMove(nMoveCount, vnMoveStep, curPositionX, curPositionY)
    WZLog("WMonster:receiveMove")
	self:getAI():move()
    
end

--@brief 		boss远距离射击
--@param  		参数与parse_BOSSMAPBATTLE_OtherShoot返回相同
--@note			提供boss重载
function WMonster:receiveShoot(speedx, speedy, leftRight, startX, startY, playerCount, playerIds, curPositionX, curPositionY)
	WZLog("WMonster:receiveShoot")

end

--@brief 		创建小怪
--@param		guaiCount:小怪数量
--@param 		guaiBattleId:小怪战斗id
--@param		guaiId:小怪数据库id
--@param		guaiPositionX:小怪x位置
--@param		guaiPositionY:小怪y位置
--@note			提供boss重载
function WMonster:receiveBuildXiaoGuai(guaiBattleId, guaiId, guaiPositionX, guaiPositionY)
    local battleId = {}
    local devilOwnId = {}
    for i = 1, #guaiId do
        battleId[i] = guaiBattleId[i]
        if guaiBattleId[#guaiId + i] then 
            devilOwnId[i] = guaiBattleId[#guaiId + i]
        end
    end
    if self.guaiBattleId == nil then
        self.guaiBattleId = battleId
        self.guaiId = guaiId
        self.guaiPositionX = guaiPositionX
        self.guaiPositionY = guaiPositionY
        self.devilOwnId = devilOwnId
    else
        for i=1,#battleId do
            table.insert(self.guaiBattleId,battleId[i])
            table.insert(self.guaiId,guaiId[i])
            table.insert(self.guaiPositionX,guaiPositionX[i])
            table.insert(self.guaiPositionY,guaiPositionY[i])
            table.insert(self.devilOwnId,devilOwnId[i])
        end
    end
    WZLog("WMonster:receiveBuildXiaoGuai one", Serialize(guaiBattleId), Serialize(guaiId), Serialize(guaiPositionX), Serialize(guaiPositionY))
end

--@brief 		游戏结束
--@param  		参数与parse_BOSSMAPBATTLE_GameOver返回相同
--@note			提供boss重载
function WMonster:receiveGameOver(firstHurtPlayerId, winCamp, playerCount, playerIds, shootRate, totalHurt, killCount, beKilledCount, addExp, Exp, upgradeExp, nextUpgradeExp, star, eggCount, egg_playeId, egg_Item_Name, egg_item_icon, egg_ItemNum, pices)
    
end

--@brief 		某个英雄死了
--@param  		参数与parse_BOSSMAPBATTLE_SomeOneDead返回相同
--@note			提供boss重载
function WMonster:receiveSomeOneDead(deadPlayerCount, PlayerIds)
    -- WZLog("WMonster:receiveSomeOneDead one", self:getBattleId(), BattleCommon:tableLen(WBattleGlobal:getCurrent():getGuaiList()), deadPlayerCount, PlayerIds)
    for i,deadHero in pairs(PlayerIds) do
        WZLog("WMonster:receiveSomeOneDead two", i,deadHero)
    end

    -- WZLog("WMonster:receiveSomeOneDead six", BattleCommon:tableLen(WBattleGlobal:getCurrent():getGuaiList()))
end

--@brief	以本表为模版，WCharacter表为父表创建一个新的表实例对象
--@return	新建的表实例对象
function WMonster:new()
	setmetatable(WMonster,{__index = WCharacter})
	local tNewObj = {}
	setmetatable(tNewObj, {__index = WMonster})
	tNewObj:setType(CharacterType.TYPE_GUAI)
	tNewObj:_init()
    tNewObj.m_tOwnerMsgMgr = MsgManager:new()
	return tNewObj
end

--@brief 添加boss名称与血条
function WMonster:_addBossName()
    if self:getLevel() == -1 then
        return nil
    end
	if self.m_tBossName == nil then
		self.m_tBossName = BattleHeroName:create(self,SceneBattle:getInfoLayer(),false)
	end
end

--@brief 	获得人物名称信息的显示
--@return 	#1, 人物名称信息的显示
function WMonster:getPlayerNameIcon()
	return self.m_tBossName
end

--@brief    清理人物名称信息的显示
function WMonster:clearPlayerNameIcon()
   if self.m_tBossName ~= nil then
        self.m_tBossName:destroy()
        self.m_tBossName = nil
    end
end

--@brief	获取横向方向距离指点地点足够近的玩家
--@param	distance:距离
--@return   #1:距离内是否有玩家,#2,玩家数组
function WMonster:getHeroNearPos(distance, pos)
    local bIsHeroNearBoss = false
    local heroNearBossList = {}
    local tHeroList = WBattleGlobal:getCurrent():getHeroList()
    local isAwakeTeamCopy = WBattleGlobal:getCurrent():isAwakeTeamStage() or WBattleGlobal:getCurrent():isDoubleTowerStage() or WBattleGlobal:getCurrent():isHostChallengeStage()
    for i ,v in pairs(tHeroList) do
        local heroPos = v:getPosition()
        local bossPos = pos
        local isMyTeam = true 
        if isAwakeTeamCopy then 
            isMyTeam = WBattleGlobal:getCurrent():isMyTeam(v:getId())
        end
        if (not v:isDead() and v:getHp() > 0) and math.abs(heroPos.x - bossPos.x) <= distance and isMyTeam then
            bIsHeroNearBoss = true
            table.insert(heroNearBossList,v)
        end
    end

    return bIsHeroNearBoss, heroNearBossList
end

--@brief	获取横向方向距离BOSS足够近的玩家
--@param	nDistance:距离
--@return   #1:距离内是否有玩家,#2,玩家数组
function WMonster:getHeroNearBoss(nDistance)
    WZLog("WMonster:getHeroNearBoss")
    local bIsHeroNearBoss = false
    local heroNearBossList = {}
    local tHeroList = WBattleGlobal:getCurrent():getHeroList()
    local isAwakeTeamCopy = WBattleGlobal:getCurrent():isAwakeTeamStage() or WBattleGlobal:getCurrent():isDoubleTowerStage() or WBattleGlobal:getCurrent():isHostChallengeStage()
    for i ,v in pairs(tHeroList) do
        local heroPos = v:getPosition()
        local bossPos = self:getPosition()
        local isMyTeam = true
        if isAwakeTeamCopy then 
            isMyTeam = WBattleGlobal:getCurrent():isMyTeam(v:getId())
        end
        if (not v:isDead() and v:getHp() > 0) and math.abs(heroPos.x - bossPos.x) <= nDistance and isMyTeam then
            bIsHeroNearBoss = true
            table.insert(heroNearBossList,v)
        end
    end
    
	return bIsHeroNearBoss, heroNearBossList
    
end

--@brief	获得距离最近的玩家
function WMonster:getNearestPlayer()
    WZLog("WMonster:getNearestPlayer")
	local guaiPos = self:getAnimation():getPosition()
	local tPlayerList = WBattleGlobal:getCurrent():getHeroList()
	local nNearestIndex = GlobalGame.g_tPlayerInfo.nPlayerId
	local nNearestDis = 99999
    local isAwakeTeamCopy = WBattleGlobal:getCurrent():isAwakeTeamStage() or WBattleGlobal:getCurrent():isDoubleTowerStage() or WBattleGlobal:getCurrent():isHostChallengeStage()
	for i,player in pairs(tPlayerList) do
		local nDisToPlayer = math.abs(player:getAnimation():getPosition().x - guaiPos.x)
        local isMyTeam = true
        if isAwakeTeamCopy then 
            isMyTeam = WBattleGlobal:getCurrent():isMyTeam(player:getId())
        end
		if (not player:isDead() and player:getHp() > 0) and nDisToPlayer < nNearestDis and isMyTeam then
			nNearestDis = nDisToPlayer
			nNearestIndex = i
		end
	end
	self.m_tTargetPlayer = tPlayerList[nNearestIndex]
	return tPlayerList[nNearestIndex]
end

--@brief	获得距离最远的玩家
function WMonster:getFarestPlayer()
    WZLog("WMonster:getFarestPlayer")
	local guaiPos = self:getAnimation():getPosition()
	local tPlayerList = WBattleGlobal:getCurrent():getHeroList()
	local nFarestIndex = GlobalGame.g_tPlayerInfo.nPlayerId
	local nFarestDis = 0
    local isAwakeTeamCopy = WBattleGlobal:getCurrent():isAwakeTeamStage() or WBattleGlobal:getCurrent():isDoubleTowerStage() or WBattleGlobal:getCurrent():isHostChallengeStage()
	for i,player in pairs(tPlayerList) do
		local nDisToPlayer = math.abs(player:getAnimation():getPosition().x - guaiPos.x)
        local isMyTeam = true
        if isAwakeTeamCopy then 
            isMyTeam = WBattleGlobal:getCurrent():isMyTeam(player:getId())
        end
		if (not player:isDead() and player:getHp() > 0) and nDisToPlayer > nFarestDis and isMyTeam then
			nFarestDis = nDisToPlayer
			nFarestIndex = i
		end
	end
	self.m_tTargetPlayer = tPlayerList[nFarestIndex]
	return tPlayerList[nFarestIndex]
end

--@brief	获得随机的一个玩家
function WMonster:getRandomPlayer(hero)
    WZLog("WMonster:getRandomPlayer")
	--随机数
    local nTurnTimes = WBattleGlobal:getCurrent():getTurnTimes()
    local randNumIndex = nTurnTimes % 10 + 1
    local randNumList = WBattleGlobal:getCurrent().m_tBattleRand
    
    --目标英雄
    local tHeroList = WBattleGlobal:getCurrent():getHeroSortList()
	local nPlayerCount = 0
    local tPlayerIds = {}
    local isAwakeTeamCopy = WBattleGlobal:getCurrent():isAwakeTeamStage() or WBattleGlobal:getCurrent():isDoubleTowerStage() or WBattleGlobal:getCurrent():isHostChallengeStage()
    for i ,v in ipairs(tHeroList) do
        local isMyTeam = true
        if isAwakeTeamCopy then 
            isMyTeam = WBattleGlobal:getCurrent():isMyTeam(v:getId())
        end
        if not v:isDead() and v:getHp() > 0 and isMyTeam then
            nPlayerCount = nPlayerCount + 1        
            tPlayerIds[nPlayerCount] = v.m_nPlayerId
        end
    end
    
    local targetHeroId = tPlayerIds[randNumList[randNumIndex] % #tPlayerIds + 1]
    --针对心魔攻击，锁定本体
    if hero and hero:isInBuffState(EffectTypeConfig.LOCK_ITSELF) then 
        if hero:isDevilGuai() then 
            local devilOwnHero = WBattleGlobal:getCurrent():getHeroWithId()
            if utilsValueInTable(hero:getDevilOwnId(), tPlayerIds) then 
                targetHeroId = hero:getDevilOwnId()
            end
        end
    end
    self.m_tTargetPlayer = WBattleGlobal:getCurrent():getHeroWithId(targetHeroId)
    return self.m_tTargetPlayer
end

--@brief    获得随机的一个guai
function WMonster:getRandomGuai()
    WZLog("WMonster:getRandomGuai one")
    --随机数
    local nTurnTimes = WBattleGlobal:getCurrent():getTurnTimes()
    local randNumIndex = nTurnTimes % 10 + 1
    local randNumList = WBattleGlobal:getCurrent().m_tBattleRand
    
    --目标英雄
    local tHeroList = WBattleGlobal:getCurrent():getNoMachineGuaiSortList()
    local nPlayerCount = 0
    local tPlayerIds = {}
    for i ,v in ipairs(tHeroList) do
        if not v:isDead() and v:getHp() > 0 then
            nPlayerCount = nPlayerCount + 1        
            tPlayerIds[nPlayerCount] = v.m_nBattleId
        end
    end
    

    local targetHeroId = tPlayerIds[randNumList[randNumIndex] % #tPlayerIds + 1]
    WZLog("WMonster:getRandomGuai two", Serialize(tPlayerIds), "targetHeroId", targetHeroId)
    self.m_tTargetPlayer = WBattleGlobal:getCurrent():getGuaiWithId(targetHeroId)
    return self.m_tTargetPlayer
end

--@brief	获得HP最多的一个玩家
function WMonster:getHpMaxPlayer()
    WZLog("WMonster:getHpMaxPlayer")
    local tHeroList = WBattleGlobal:getCurrent():getHeroList()
    local hpMaxPlayer = nil
    local isAwakeTeamCopy = WBattleGlobal:getCurrent():isAwakeTeamStage() or WBattleGlobal:getCurrent():isDoubleTowerStage() or WBattleGlobal:getCurrent():isHostChallengeStage()
    for i ,v in pairs(tHeroList) do
        local isMyTeam = true
        if isAwakeTeamCopy then 
            isMyTeam = WBattleGlobal:getCurrent():isMyTeam(v:getId())
        end
        if (not v:isDead() and v:getHp() > 0) and (hpMaxPlayer == nil or v:getHp() > hpMaxPlayer:getHp()) and isMyTeam then
            hpMaxPlayer = v
        end
    end
    
    return hpMaxPlayer
end

--@brief	获得HP最少的一个玩家
function WMonster:getHpMinPlayer()
    WZLog("WMonster:getHpMinPlayer")
    local tHeroList = WBattleGlobal:getCurrent():getHeroList()
    local hpMinPlayer = nil
    local isAwakeTeamCopy = WBattleGlobal:getCurrent():isAwakeTeamStage() or WBattleGlobal:getCurrent():isDoubleTowerStage() or WBattleGlobal:getCurrent():isHostChallengeStage()
    for i ,v in pairs(tHeroList) do
        local isMyTeam = true
        if isAwakeTeamCopy then 
            isMyTeam = WBattleGlobal:getCurrent():isMyTeam(v:getId())
        end
        if (not v:isDead() and v:getHp() > 0) and (hpMinPlayer == nil or v:getHp() < hpMinPlayer:getHp()) and isMyTeam then
            hpMinPlayer = v
        end
    end
    
    return hpMinPlayer
end

--@brief	获得某区域是否存在玩家
--@return	#1:是否存在
--@return	#2:玩家列表
function WMonster:getPlayerWithArea(nLeftPointX, nRightPointX, nDownPointY,nUpPointY,isLog)
    if nLeftPointX == nil or nRightPointX == nil then
        return
    end
    
    local tHeroList = WBattleGlobal:getCurrent():getHeroSortList()
    local nPlayerCount = 0
    local tPlayers = {}
    local isHavePlayer = false
    local isAwakeTeamCopy = WBattleGlobal:getCurrent():isAwakeTeamStage() or WBattleGlobal:getCurrent():isDoubleTowerStage() or WBattleGlobal:getCurrent():isHostChallengeStage()

    for i ,v in ipairs(tHeroList) do
        if isLog then
        WZLog("WMonster:getPlayerWithAreaX one", v:getPosition().x, nLeftPointX, nRightPointX)
        WZLog("WMonster:getPlayerWithAreaY one", v:getPosition().y, nDownPointY, nUpPointY)
        end
        local isMyTeam = true
        if isAwakeTeamCopy then 
            isMyTeam = WBattleGlobal:getCurrent():isMyTeam(v:getId())
        end
        if not v:isDead() and v:getHp() > 0 and
            ((v:getPosition().x > nLeftPointX and v:getPosition().x < nRightPointX) and
            (v:getPosition().y < nUpPointY and v:getPosition().y > nDownPointY)) and isMyTeam then
            isHavePlayer = true
            nPlayerCount = nPlayerCount + 1
            table.insert(tPlayers,v)
            WZLog("WMonster:getPlayerWithAreaX ", v:getPosition().x, nLeftPointX, nRightPointX)
            WZLog("WMonster:getPlayerWithAreaY ", v:getPosition().y, nDownPointY, nUpPointY)
            --tPlayerIds[nPlayerCount] = v.m_nPlayerId

        end
    end
    return isHavePlayer, tPlayers
end

--@brief    获得全部怪
function WMonster:getAllMonsterBoss()
    WZLog("WMonster:getAllMonsterBoss")
    local tHeroList = WBattleGlobal:getCurrent():getGuaiList()
    local heroList = {}
    for i ,v in pairs(tHeroList) do
        if not v:isDead() and v:getHp() > 0 and v.m_tBoss == nil then
            table.insert(heroList, v)
        end
    end
    
    return heroList
end

--@brief    获得全部玩家
function WMonster:getAllPlayer()
    WZLog("WMonster:getAllPlayer")
    local tHeroList = WBattleGlobal:getCurrent():getHeroSortList()
    local heroList = {}
    for i ,v in ipairs(tHeroList) do
        if ((not v:isDead() and v:getHp() > 0)) then
            table.insert(heroList, v)
        end
    end
    
    return heroList
end

--@brief    获得x距离范围（根据条件 内外结合）的玩家
function WMonster:getDistanceXPlayer(centerPos,distance,operator,targetListMark)
    WZLog("WMonster:getDistanceXPlayer",operator)
    local tHeroList = WBattleGlobal:getCurrent():getHeroSortList()
    local heroList = {}
    for i ,v in ipairs(tHeroList) do
        if ((not v:isDead() and v:getHp() > 0)) then
            local pos = v:getPosition()
            local val = math.abs(pos.x - centerPos.x)
            if WMonsterAI:comparison(val, operator, distance) then
                table.insert(heroList, v)
            end
        end
    end
    if targetListMark == 3 then
        return heroList
    end
    return {heroList[1]}
end

--@brief    获得d距离范围（根据条件 内外结合）的玩家
--@param targetListMark 3全部玩家,4全部队友
function WMonster:getDistancePlayer(centerPos,distance,operator,targetListMark,campType)
    -- WZLog("WMonster:getDistancePlayer")
    local tHeroList = WBattleGlobal:getCurrent():getHeroSortList()
    local heroList = {}
    for i ,v in ipairs(tHeroList) do
        local inCheck = true
        if targetListMark == 4 then
            if v:getCamp() ~= campType then
                inCheck = false
            end
        end

        if inCheck and ((not v:isDead() and v:getHp() > 0)) then
            local pos = v:getPosition()
            local val = BattleCommon:pointDis(pos,centerPos)
            WZLog("WMonster:getDistancePlayer heroPos",pos.x,pos.y)
            WZLog("WMonster:getDistancePlayer ownerPos",centerPos.x,centerPos.y)
            WZLog("WMonster:getDistancePlayer param",val,distance,operator,targetListMark)
            if WMonsterAI:comparison(val, operator, distance) then
                table.insert(heroList, v)
            end
        end
    end
    
    if targetListMark == 3 or targetListMark == 4 then
        return heroList
    end
    return {heroList[1]}
end

--@brief    获得全部小孩
function WMonster:getAllKid()
    WZLog("WMonster:getAllKid")
    local tKidList = WBattleGlobal:getCurrent():getKidSortList()
    local kidList = {}
    for i ,v in ipairs(tKidList) do
        if not v:isDead() then
            table.insert(kidList, v)
        end
    end
    
    return kidList
end

--[[
--@brief        剧情对话
--@param		对话的内容
function WMonster:storyTalk(text, needZoomToBoss)
    
    local msg = MsgManager:createMsg(BattleMsgStoryTalk)
    msg.m_sTalkText = text          --文本内容
    msg.m_tPosOffset = GlobalMethod:ccp(20, 200) --位置偏移量
    msg.m_nMaxWidth = 300           --最大宽度
    msg.m_nScale = 1.5              --缩放大小
    msg.m_bNeedZoomToBoss = needZoomToBoss   --是否需要把屏幕移向boss
    msg.m_tOwner = self
    msg.m_tFollowObj = self:getAnimation():getAnimNode()
    msg.m_bIsUpdatePos = true
    WZLog("WMonster:storyTalk", tostring( msg.m_bIsUpdatePos))
    MsgManager:pushBlockMsg(msg)
end
--]]


--@brief    播放对话
function WMonster:talk(text)
    local nMaxWidth = 280           --最大宽度
    local nScale = 1.0              --缩放大小
    local tOwner = self
    local tFollowObj = self
    local bIsUpdatePos = true
    local nTime = 3
    local nDirection = CellDialog and CellDialog.DIR_LEFT --对话框的方向,默认为左
    local tPosOffset = nil --对话框的位置偏移
    
    local height = 70
    local width = 50
    
    if self.m_tCollisionRang ~= nil then
        height = self.m_tCollisionRang[1].m_fHeight * 0.7 + 30
        width = self.m_tCollisionRang[1].m_fWidth * 0.4 + 30
    elseif self.m_nAiType == MonsterAiType.AI_ROBOT then
        height = 70
        width = 50
    end

    if self:getPosition().x < 450 then
        nDirection = CellDialog.DIR_RIGHT
        tPosOffset = BattleCommon:getPointTable(width, height)   --位置偏移量
    elseif self:getPosition().x > 1200 then
        nDirection = CellDialog.DIR_LEFT
        tPosOffset = BattleCommon:getPointTable(-width, height)   --位置偏移量
    else
        if self.m_bIsFilpX == true then
            nDirection = CellDialog.DIR_LEFT
            tPosOffset = BattleCommon:getPointTable(-width, height)   --位置偏移量
        else
            nDirection = CellDialog.DIR_RIGHT
            tPosOffset = BattleCommon:getPointTable(width, height)   --位置偏移量
        end
    end
    local nameInfo = nil
    if self.m_bIsRelyNameInfo ~= nil and self.m_bIsRelyNameInfo == false then
        nameInfo = self:getAnimation():getAnimNode()
    elseif self:getPlayerNameIcon() ~= nil then
        nameInfo = self:getPlayerNameIcon().m_tNameLayer
    elseif self.m_tGuaiName ~= nil then
        nameInfo = self.m_tGuaiName.m_tNameLayer
    elseif self.m_tBossName ~= nil then
        nameInfo = self.m_tBossName.m_tNameLayer
    elseif self.m_tBossNameAndHP ~= nil then
        nameInfo = self.m_tBossNameAndHP.m_tNameLayer
    end
    if nameInfo == nil then
        nameInfo = self:getAnimation():getAnimNode()
        if self.m_bIsFilpX == true then
            nDirection = CellDialog.DIR_RIGHT
            tPosOffset = BattleCommon:getPointTable(width, height)   --位置偏移量
        else
            nDirection = CellDialog.DIR_LEFT
            tPosOffset = BattleCommon:getPointTable(-width, height)   --位置偏移量
        end
    end

    if self.m_nAiType == MonsterAiType.AI_MELEE_SKY then
        tPosOffset.x = tPosOffset.x - 450
    end
    self.m_tDialogElement, self.m_tTalkObj = CellDialog:addDialog(nameInfo, SceneBattle:getInfoLayer(), text, nDirection, nTime, nil, nil, tPosOffset.x, tPosOffset.y, nMaxWidth, nScale, nil, nil, bIsUpdatePos, tFollowObj,100,nil,nil,nil,nil,true)
    

    local isSpecBoss = false
    --组队副本9boss 对话框特殊处理
    if math.floor(WBattleGlobal:getCurrent().m_tMakePairOk.mapId / 100) == 210 or
       math.floor(WBattleGlobal:getCurrent().m_tMakePairOk.mapId / 100) == 202 then
        isSpecBoss = true
    end

    if not isSpecBoss and self.m_mover ~= nil and (self.m_nAiType == nil or self.m_nAiType ~= MonsterAiType.AI_MELEE_SKY ) then
        WZLog("BattleMsgBossMapSkill:_showDialog II",tPosOffset.x,tPosOffset.y)
        local node = TrackNode:create(self.m_tDialogElement)
        node:setPreAdd(Vector2:create(tPosOffset.x,tPosOffset.y))
        self.m_mover:addTrackNode(node)
    else
        self.m_nDialogOffset = tPosOffset
        local point = ccp(self:getPosition().x, self:getPosition().y)
        point = self:getAnimation():getAnimNode():getParent():convertToWorldSpace(point)
        point = SceneBattle:getInfoLayer():convertToNodeSpace(point)
        local pos = GlobalMethod:ccp(point.x + tPosOffset.x,point.y + tPosOffset.y)
        self.m_tDialogElement:setPosition(pos)
        self.m_bDialogIsFilpX = self.m_bIsFilpX
    end
end

-- --@brief    播放对话
-- function WMonster:talk(text, bubbleId)
--     if self:getAnimation() == nil or self:getAnimation():getAnimNode() == nil then
--         return
--     end

--     if self.m_tTalkElement then
--         self.m_tTalkElement:removeFromParentAndCleanup(true)
--         self.m_tTalkElement = nil
--         self.m_tTalkObj = nil
--     end

--     local dir = CellDialog.DIR_UP
--     local posOffset = BattleCommon:getPointTable(0, 0)

--     self.m_tTalkElement, self.m_tTalkObj = CellBattleDialog:addDialog(self:getAnimation():getAnimNode(), 
--         SceneBattle:getInfoLayer(), text, dir, 10, nil, nil, posOffset.x, posOffset.y, 280, 1, nil, nil, 
--         false, nil,100,nil,nil,nil,nil,nil,true,nil,bubbleId, self:getBattleId())

--     local point = self:updateTalkPos()
--     self.m_tTalkObj:updateTalkPos({x=self:getAnimation():getPosition().x,y=self:getAnimation():getPosition().y}, point)

--     local node = self.m_tTalkElement
--     --because need to higher than the name layer and ttf layer 
--     node:setZOrder(3)
--     --SceneBattle:getInfoLayer():addChild(node)

--     local time = 3
--     node:setScale(0.2)
--     node:setTag(self:getBattleId())
--     local act1=CCScaleTo:create(0.2,1)
--     local act2=CCDelayTime:create(time)
--     local act3=CCScaleTo:create(0.1,0.2)
--     local act4=CCCallFuncN:create(_talkEnd_WMonster)
--     local array = CCArray:create()
--     array:addObject(act1)
--     array:addObject(act2)
--     array:addObject(act3)
--     array:addObject(act4)
--     node:runAction(CCSequence:create(array))
-- end

-- --@brief    更新对话位置
-- function WMonster:updateTalkPos()
--     if self.m_tTalkElement then
--         local heroPos = self:getAnimation():getPosition()

--         local size = self.m_tTalkElement:getContentSize()

--         local offset = {x=0, y=80}

--         local point = SceneBattle:getFrontLayer():convertToWorldSpace(GlobalMethod:ccp(heroPos.x+offset.x,heroPos.y+offset.y))

--         --WZLog("WHero:updateTalkPos",heroPos.x, heroPos.y, point.x, point.y, size.width, size.height)
--         if point.x < size.width/2 + 20 then
--             point.x = size.width/2 + 20
--         end
--         if point.x > 1136 - (size.width/2) - 20 then
--             point.x = 1136 - (size.width/2) - 20
--         end

--         if point.y < 20 then
--             point.y = 20
--         end
--         if point.y > 640 - size.height - 20 then
--             point.y = 640 - size.height - 20
--         end
--         point = SceneBattle:getInfoLayer():convertToNodeSpace(point)

--         self.m_tTalkElement:setPosition(point.x,point.y)

--         return point
--     end
-- end

-- --@brief    对话结束回调
-- function _talkEnd_WMonster(sender)
--     local hero = WBattleGlobal:getCurrent():getCharacterWithId(sender:getTag())
--     if hero and hero.m_tTalkElement then
--         hero.m_tTalkElement:removeFromParentAndCleanup(true)
--         hero.m_tTalkElement = nil
--         hero.m_tTalkObj = nil
--     end
-- end

--@brief	获取箭头的位置
--@return	table,位置
function WMonster:getArrowPosition()
    --WZLog("WCharacter:getArrowPosition", self:getBattleId(), tostring(self:getAnimation():isFlipX()), self:getPosition().x)
    local tx,ty
    if self:getAnimation():isFlipX() == false then
        tx = self:getPosition().x + 0
    else
        tx = self:getPosition().x - 0
    end
    local scale = self:getScale()
    ty = self:getPosition().y + self:getMonsterConfig().animSize.height * scale + 55
    return {x = tx,y=ty}
end


--@brief    移动到目标点
--@param    point:目标点
function WMonster:moveToPos(pos)
    WZLog("WMonster:moveToPos")
    self.m_tMoveTargetPos = pos

    local cur_pos = self.m_anim:getPosition()
    self.m_tMoveTargetOffset = {x = cur_pos.x - pos.x, y = cur_pos.y - pos.y}
end

--@brief    移动到目标点刷新
function WMonster:moveToPosUpdate(dt)
    if not self.m_tMoveTargetPos then
        return
    end
    
    self:setPF(self:getPF()-1)
    self:setRunStatus(RunStatus.DEF_ST_MOVE)
    
    local cur_pos = self.m_anim:getPosition()
    local target_pos = self.m_tMoveTargetPos
    
    if  self.m_bIsAir == nil then
        self:getMover():setUpdatable(true)
        self:getMover():setMoveAcceleration(self.m_tMoveSpeed.x,-1)
    elseif self.m_bIsAir == true then
        local pos = {x = cur_pos.x - self.m_tMoveTargetOffset.x * dt, y = cur_pos.y - self.m_tMoveTargetOffset.y * dt}
        self:setPosition(pos)
    end
    
    if self.m_bIsAir == true and self.m_tDialog ~= nil and self.m_tDialog.m_tFollowObjOriginalPos ~= nil then
        local scale = 1
        if self.m_bIsAir == true then
            scale = 0.60
        end
        local moveDistance = BattleCommon:getPointTable((self:getPosition().x - self.m_tDialog.m_tFollowObjOriginalPos.x) * scale,(self:getPosition().y - self.m_tDialog.m_tFollowObjOriginalPos.y) * scale)
        self.m_tDialog.m_root:setPositionX(self.m_tDialog.m_tOriginalPos.x + moveDistance.x)
        self.m_tDialog.m_root:setPositionY(self.m_tDialog.m_tOriginalPos.y + moveDistance.y)
    end

    --移动结束
    local isEnd = self:getPF() <= 0 and true or false
    if not isEnd then
        if self.m_bIsAir == nil then
            isEnd = math.abs(cur_pos.x - self.m_tMoveTargetPos.x) < 5 and true or false
        elseif self.m_bIsAir == true then
            isEnd = BattleCommon:pointDis(cur_pos, self.m_tMoveTargetPos) < 5 and true or false
        end
    end

    if isEnd then
        self:getMover():setUpdatable(true)
        self:getMover():setMoveAcceleration(0,0)
        self:play(self:getAnimationName("standby"), true)

        self.m_tMoveTargetPos = nil
        self.m_tMoveTargetOffset = nil
    end
        

end

--@brief 设置小怪地图碰撞
function WMonster:setMapCollision(value)
    if value == true then
        if WBattleGlobal:getCurrent().m_battleManager ~= nil and self:getMover() then
            WBattleGlobal:getCurrent().m_battleManager:addEntity(self:getMover())
        end
    else
        if WBattleGlobal:getCurrent().m_battleManager ~= nil and self:getMover() then
            WBattleGlobal:getCurrent().m_battleManager:removeEntity(self:getMover())
        end
    end
end

--@brief	设置小怪移动速度
--@param 	tSpeed:下怪移动速度
function WMonster:setMoveSpeed(tSpeed)
	self.m_tMoveSpeed = tSpeed
end

--@brief	设置本回合行动是否完成标志
--@param	bActFinished:本回合行动是否完成的标志
function WMonster:setActFinished(bActFinished)
	self.m_bActFinished = bActFinished
end

--@brief	小怪是否已经行动完成
function WMonster:isActFinished()
	return self.m_bActFinished
end

--@brief 	设置小怪是否被添加进场景标识
--@param	bIsAddedInScene:小怪是否被添加进场景
function WMonster:setIsAddedInScene(bIsAddedInScene)
	self.m_bIsAddedInScene = bIsAddedInScene
end

--@brief	初始化小怪血条和名字
function WMonster:initGuaiName()
    if self:getLevel() == -1 then
        return nil
    end
	self.m_tGuaiName = BattleHeroName:create(self,SceneBattle:getInfoLayer(),false)
	self.m_tGuaiName:update()
end

--@brief	调整移动方向
function WMonster:adjustDirect(tPos)
    WZLog("WMonster:adjustDirect", self:getBattleId() , tostring(self.m_bIsLeftFlip), self:_shouldMoveLeft(tPos))
	if self:_shouldMoveLeft(tPos) then
		self.m_nCurDirect = 0
        if ((WBattleGlobal:getCurrent():isDoubleTowerStage() or WBattleGlobal:getCurrent():isHostChallengeStage()) and type(self.suitConfig) == "number" and self.suitConfig == 999) then
            if self.m_bIsLeftFlip == true then
                self:getAnimation():setFlipX(false)
                self.m_bIsFilpX = false
            else
                self:getAnimation():setFlipX(true)
                self.m_bIsFilpX = true
            end
        else
            if self.m_bIsLeftFlip == true then
                self:getAnimation():setFlipX(true)
                self.m_bIsFilpX = true
            else
                self:getAnimation():setFlipX(false)
                self.m_bIsFilpX = false
            end
        end
        if self.m_bIsAir == true then
            self.m_tMoveSpeed = {x=-2.1, y=-1}
        else
            self.m_tMoveSpeed = {x=-3.1 * 1.5, y=-1}
        end
    else
		self.m_nCurDirect = 1
        if ((WBattleGlobal:getCurrent():isDoubleTowerStage() or WBattleGlobal:getCurrent():isHostChallengeStage()) and type(self.suitConfig) == "number" and self.suitConfig == 999) then
            if self.m_bIsLeftFlip == true then
                self:getAnimation():setFlipX(true)
                self.m_bIsFilpX = true
            else
                self:getAnimation():setFlipX(false)
                self.m_bIsFilpX = false
            end
        else
            if self.m_bIsLeftFlip ~= true then
                self:getAnimation():setFlipX(true)
                self.m_bIsFilpX = true
            else
                self:getAnimation():setFlipX(false)
                self.m_bIsFilpX = false
            end
        end
        if self.m_bIsAir == true then
            self.m_tMoveSpeed = {x=2.1, y=-1}
        else
            self.m_tMoveSpeed = {x=3.1 * 1.5, y=-1}
        end
	end

    if self.m_bDialogIsFilpX ~= self.m_bIsFilpX then
        self.m_bDialogIsFilpX = self.m_bIsFilpX
        if self.m_nDialogOffset then
            self.m_nDialogOffset.x = -self.m_nDialogOffset.x
        end
        if self.m_tDialogElement and self.m_tDialog then
            self.m_tDialog:setDirBack()
        end
    end
end


--@brief	同步所有客户端
--@param	aiCtrlId:怪物所使用的策略识别码
function WMonster:sendAiProcol(aiCtrlId)
    WZLog("WMonsterAI:sendAiProcol")
    --同步ai前同步位置
    WBattleGlobal:getCurrent():sendBattleSynPosition()
    
    local battleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
    local playerOrGuai = 1
    local currentId = self:getBattleId()
    ProtocolProcessorBattleInterface:send_BATTLE_NearAttack(battleId, currentId, aiCtrlId )
end

--@brief        根据服务器传过来的参数使用大招
--@param        aiCtrlId:怪物所使用的策略识别码
--@note         提供boss重载
function WMonster:receiveNearAttack(aiCtrlId)
    WZLog("WMonster:receiveNearAttack one", aiCtrlId, self:getBattleId())
    if WBattleGlobal:getCurrent():isHostControl() then
        return
    end
    --添加本回合ai同步
    local msg = MsgManager:createMsg(BattleMsgSyncMonsterAi)
    msg.m_nCurrentPlayerId = self:getBattleId()
    msg.m_nAictrlId = aiCtrlId
    MsgManager:pushBlockMsg(msg)
    -- self:getAI():syncAiState(aiCtrlId)
    do 
        return
    end

    --技能同步
    local isSyncSkill = true
    if aiCtrlId <= 0 then 
        isSyncSkill = false 
    end

    if self:getAI().m_tBoss.m_nAiType == MonsterAiType.AI_MELEE or self:getAI().m_tBoss.m_nAiType == MonsterAiType.AI_MELEE_SKY then
        isSyncSkill = false
    end
    if self:getAI().m_tBoss:isFollowAct() then
        isSyncSkill = false
    end
    -- if aiCtrlId > 0 and (self:getAI().m_tBoss.m_tBoss == nil or (self:getAI().m_tBoss.m_nAiType ~= MonsterAiType.AI_MELEE and self:getAI().m_tBoss.m_nAiType ~= MonsterAiType.AI_MELEE_SKY) or (self:getAI().m_tBoss.m_tBoss ~= nil and self:getAI().m_tBoss.m_tBoss:getMonsterLeader():getBattleId() == self:getAI().m_tBoss:getBattleId() and self:getAI().m_bMoved ~= true)) then
    if isSyncSkill then
        local ai = self:getAI().m_tBoss:getAiScript()[aiCtrlId]
        WZLog("WMonster:receiveNearAttack two", aiCtrlId, self:getBattleId(), Serialize(ai))

        local action = ai.action
        local conditionList = ai.condition
        if action.actionType == AiActionConfig.SKILL then
            --过滤非同步技能（有固定流程自动触发）
            local skillId = action[1].actionParm1
            local skillConfig = GDatatab_skill["id_"..skillId]
            if skillConfig.isNotSync == 1 then
                return
            end
        end
        ai.isAction = true
        ai.actionCount = ai.actionCount + 1
        self:getAI():doAction(action.actionType, action, conditionList,nil, aiCtrlId)
    end

    if aiCtrlId <= 0 and not self.m_tBoss:isFollowAct() then
        WZLog("WMonster:receiveNearAttack three", self:getBattleId())
        if self:getAI().m_tBoss.m_nAiType == MonsterAiType.AI_MELEE or self:getAI().m_tBoss.m_nAiType == MonsterAiType.AI_MELEE_SKY then
            local moveMonsterList = {}
            local guai = WBattleGlobal:getCurrent():getGuaiWithId(self:getBattleId())
            table.insert(moveMonsterList, guai)

            if #moveMonsterList > 0 then
                self:getAI().m_nAiActionCount = self:getAI().m_nAiActionCount + 1

                self:getAI().m_bMoved = true
                self:getAI():castSkill(-1,
                    nil,
                    nil,
                    {[1]=SkillTypeConfig.MOVE, [2]=SkillTypeConfig.BEAT},
                    nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,nil,nil,nil,nil,nil,
                    nil,
                    nil,
                    moveMonsterList, nil
                )
                WBattleGlobal:getCurrent().m_bIsCurTurnActed = true

            else
                self:getAI().m_nAiActionCount = 100
            end
        else
            if self:getAI().m_tBoss.m_nBulletId ~= -1 then
                self:getAI().m_nAiActionCount = self:getAI().m_nAiActionCount + 1
                --[[
                self:getAI():castSkill(-1,
                    nil,
                    nil,
                    {[1]=SkillTypeConfig.SHOOT},

                    nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,nil,nil,nil,nil,nil,
                    nil,
                    nil,
                    nil,nil,
                    nil,nil,nil,nil,
                    nil,
                    self:getAI().m_tBoss.m_nBulletId)
                WBattleGlobal:getCurrent().m_bIsCurTurnActed = true
                ]]
                self:getAI():doAction(AiActionConfig.SKILL,{[1] = {actionParm1 = 20000}})
            else
                self:getAI().m_nAiActionCount = 100
            end
        end
    end
end

--@brief    发送移动协议
function WMonster:sendMoveProtocol()
    WZLog("WMonster:sendMoveProtocol")
    local battleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId      -- 战斗id
    local playerOrGuai = 1                                                  -- 0:player 1:guai
    local currentId = self:getBattleId()                                    -- 角色id
    local movecount = 1                                                     -- 移动的次数
    local movestep = {0}                                                    -- 每一次移动的方向（0：左，1：右）
    local curPositionX = self:getAnimation():getPosition().x                -- 没移动前的x坐标
    local curPositionY = self:getAnimation():getPosition().y                -- 没移动前的y坐标
    curPositionX = BattleCommon:float2int2float(curPositionX)
    curPositionY = BattleCommon:float2int2float(curPositionY)

    self:setPosition({x=curPositionX,y=curPositionYpos.y})
    
	ProtocolProcessorBattleInterface:send_BATTLE_PlayerMove(battleId, currentId, movecount, movestep, curPositionX, curPositionY)
end





-------------------------------------私有方法模块--------------------------------------
--@brief	移除死亡小怪
function WMonster:_removeDeadGuai()
    self:removeAngerAnimation()
    self:clearPlayerNameIcon()
    WBattleGlobal:getCurrent().m_tGuais[self:getBattleId()] = nil
	self:getAnimation():getAnimNode():removeFromParentAndCleanup(false)
	self:destroy()
end

--@brief	是否向左移动
function WMonster:_shouldMoveLeft(tPos)
	local player = self:getNearestPlayer()
    if not player then
        return false
    end
	local playerPos = player:getAnimation():getPosition()
    if tPos ~= nil then
        playerPos = tPos
    end
	local guaiPos = self:getAnimation():getPosition()
	if guaiPos.x - playerPos.x >= 0 then
		return true
	end
    
	return false
end

--@brief	是否进行攻击
function WMonster:_shouldAttack()
	local player = self:getNearestPlayer()
	local playerPos = player:getAnimation():getPosition()
	local guaiPos = self:getAnimation():getPosition()
	if math.abs(guaiPos.x - playerPos.x) < self. m_nAttackArea then
        WZLog("WMonster:_shouldAttack = true")
		return true
	end
    
    WZLog("WMonster:_shouldAttack = false")
	return false
end

--@brief 添加小怪名称与血条
function WMonster:_addGuaiName()
    if self:getLevel() == -1 then
        return nil
    end
	if self.m_tGuaiName == nil then
		self.m_tGuaiName = BattleHeroName:create(self,SceneBattle:getInfoLayer(),false)
    else
		self.m_tGuaiName:update()
	end
end

--@brief    获取中心位置
--@return   #1:中心位置
function WMonster:getCenterPos()
   return self:getPetAttackPos()
end

function WMonster:getPetAttackPos()
    -- local moverCenter = {x=0,y=0}
    -- if self:getMover() ~= nil then
    --     moverCenter.x = self:getMover():getMoverCenter().x
    --     moverCenter.y = self:getMover():getMoverCenter().y
    -- end
    -- local size = self:getMonsterConfig().animSize
    -- local heroCenter = CCPointMake(moverCenter.x + size.width, moverCenter.y + size.height)

    -- local toParentTranf = self:getAnimation():getAnimNode():nodeToParentTransform()
    -- heroCenter=CCPointApplyAffineTransform(heroCenter,toParentTranf)
    -- return heroCenter

    --==============
   
    local size = self:getMonsterConfig().animSize
    do
        local offsetH = size.height* 0.5 * self.m_nScale
        if self:isSpecAnchorAnim() then
            offsetH = 0
        end

        return {x=self:getPosition().x,y=self:getPosition().y + offsetH}
    end
    -- local heroCenter = CCPointMake(0.5*size.width, 0.5*size.height)
    -- local toParentTranf = self:getAnimation():getAnimNode():nodeToParentTransform()
    -- heroCenter=CCPointApplyAffineTransform(heroCenter,toParentTranf)


    -- WZLog("WMonster:getPetAttackPos",size.width, heroCenter.x,heroCenter.y, self:getPosition().x)
    -- return heroCenter

end

--@brief    获取缩放系数
function WMonster:getScale()
    return self:getAnimation():getAnimNode():getScaleY()
end

--@brief    设置缩放系数
function WMonster:setScale(scale)
    self.m_anim:setScale(scale)
end

--@brief 正常行动
function WMonster:isNormalAct()
    return self.m_nAction_type == MonsterActType.NORMAL
end

--@brief 跟随行动
function WMonster:isFollowAct()
    return self.m_nAction_type == MonsterActType.FOLLOW
end
--@breif 跟随独立行动
function WMonster:isFollowIndependent()
    return self.m_nAction_type == MonsterActType.FOLLOW_INDEPENDENT
end

--@brief 隐藏真实血槽数字
function WMonster:HideRealBloodView()
    if self.m_tBossName then
        self:setMaxHp(self.m_nHP)
        self.m_tBossName.m_hp:setPercentage(100)
    end
end

--@brief 显示真实血槽数字
function WMonster:showRealBloodView()
    if self.m_tBossName then
        self:setMaxHp(self.m_nBeginMaxHp)
        self.m_tBossName.m_hp:setPercentage(self.m_nHP/self.m_nMaxHP)
    end
end

--@brief    设置心魔怪数据
function WMonster:setDevilGuaiInfo(monster, id, battleId)
    WZLog("WMonster:setDevilGuaiInfo one", id)
    monster.m_bIsSummon = true
    monster.m_nBattleId = battleId
    -- --设置怪物记录
    --WBattleGlobal:getCurrent():setBuildMonsterRecord(monster.m_nBattleId,id)
    local makePairOk = WBattleGlobal:getCurrent().m_tMakePairOk
    local function getPlayerIndex(pId)
        -- body
        for i = 1, #makePairOk.playerId do
            if makePairOk.playerId[i] == pId then 
                return i
            end
        end
    end
    local index = getPlayerIndex(monster.m_nDevilOwnId)

    local monsterData = BossData["id_"..id]
    --动画文件
    monster.m_sAniFileId = monsterData.AniFileId
    --数据表id
    monster.m_nPlayerId = monster.m_nBattleId
    --数据表索引id
    monster.m_nIndexId = monster.m_nBattleId
    --怪名字
    monster.m_sPlayerName = makePairOk.playerName[index] .. LocalStrings.PRE_DEVIL_NAME
    monster.serverId = makePairOk.serverId[index]
    --怪等级
    --怪战斗加载界面需要的信息
    monster.m_tLoadingInfo = monsterData.loadingInfo    --Add By Tianxiang_Xu

    monster.m_nLevel = makePairOk.playerLevel[index]
    --怪物真实等级
    monster.m_nRealLevel = monster.m_nLevel
    --行动类型
    monster.m_nAction_type = monsterData.action_type > 0 and monsterData.action_type or 1 
    --ai位移类型
    if monsterData.aiDisplaceType then
        monster.m_nAiDisplaceType = monsterData.aiDisplaceType 
    end

    if monsterData.offHurt and monsterData.offHurt == 1 then
        monster.m_bOffHurt = true
    end
    
    if monsterData.offRepulse and monsterData.offRepulse == 1 then
        monster.m_bOffRepulse = true
    end

    if monsterData.limit and monsterData.limit == 1 then
        monster.m_bOffFrozen = true
    end

    local scale = 1
    if monsterData.scale and monsterData.scale > 10 then
        scale = monsterData.scale/100
    end

    monster.m_nScale = scale or 1
    --怪阵型
    if monster.m_bIsSummon ~= true then 
        monster.m_nCamp = 1
    else
        monster.m_nCamp = -1
    end
    --怪maxHP
    --怪攻击力
    monster.m_nHP = math.floor(makePairOk.maxHP[index] * monsterData.hp/100)
    monster.m_nMaxHP = monster.m_nHP
    monster.m_nAttack = makePairOk.attack[index]
    monster.m_nHP_Encrypt = BattleCommon:intEncrypt(monster.m_nHP)
    monster.m_nAttack_Encrypt = BattleCommon:intEncrypt(monster.m_nAttack)
   
    --怪maxPF
    monster.m_nMaxPF = makePairOk.maxPF[index]
    --怪性别
    -- monster.m_nBoyOrGirl = monsterData.sex
    --怪MaxSP
    monster.m_nMaxSP = makePairOk.maxSP[index]
    --怪PF
    monster.m_nPF = makePairOk.maxPF[index]
    monster.m_nPF_Encrypt = BattleCommon:intEncrypt(monster.m_nPF)
    --怪SP
    monster.m_nSP = 0
    monster.m_nSP_Encrypt = BattleCommon:intEncrypt(monster.m_nSP)
    
    --怪暴击倍率
    monster.m_nCriticalhitAttackRate = makePairOk.critRate[index]
    monster.m_nCriticalhitAttackRate_Encrypt = BattleCommon:intEncrypt(monster.m_nCriticalhitAttackRate)
    --怪防御
    monster.m_nDefence = makePairOk.defence[index]
    monster.m_nDefence_Encrypt = BattleCommon:intEncrypt(monster.m_nDefence)
    --怪免伤
    monster.m_nInjuryFree = makePairOk.injuryFree[index]
    monster.m_nInjuryFree_Encrypt = BattleCommon:intEncrypt(monster.m_nInjuryFree)
    --怪破防值
    monster.m_nWreckDefense = makePairOk.wreckDefense[index]
    monster.m_nWreckDefense_Encrypt = BattleCommon:intEncrypt(monster.m_nWreckDefense)
    --怪免暴
    monster.m_nReduceCrit = makePairOk.reduceCrit[index]
    monster.m_nReduceCrit_Encrypt = BattleCommon:intEncrypt(monster.m_nReduceCrit)
    --怪免坑
    monster.m_nReduceBury = monsterData.reduce_bury
    monster.m_nReduceBury_Encrypt = BattleCommon:intEncrypt(monster.m_nReduceBury)
    --怪大招类型
    monster.m_nBigSkillType = monsterData.m_nBigSkillType
    --怪转生等级
    monster.m_nZSLevel = GlobalGame:checkGlobalPlayerZsleve(monster.m_nLevel)

    --攻击相关
    monster:setAttPercent(100)
    monster:setAttTimes(1)
    monster:setAttScatterNum(1)
    monster:setCanFrozen(false)
    monster:setCanFollow(false)
    
    monster.m_nPower = makePairOk.power[index]
    monster.m_nArmor = makePairOk.armor[index]
    monster.m_nConstitution = makePairOk.constitution[index]
    monster.m_nAgility = makePairOk.agility[index]
    monster.m_nLucky = makePairOk.lucky[index]
    --子弹爆破配置
    monster:setRadiusForBulletExplodeRate(monsterData.scope/100)
    monster.m_fRectForBulletExplodeBombRate = {x = monsterData.boom_scope[1][1]/100,y =monsterData.boom_scope[1][2]/100}

    WZLog("WMonster:setDevilGuaiInfo three", monster.m_fRadiusForBulletExplode)
    --怪物类型
    if monster.m_bIsSummon ~= true then 
        monster.m_nGuaiType = 2
    else
        monster.m_nGuaiType = 1
    end

    monster.m_nAttackArea = monsterData.attackArea * 1
    monster.m_tSkillItemList = monsterData.skill
    monster.m_nHitRate = monsterData.mzl
    monster.m_nPhysicalMax = monsterData.tili
    monster.m_tDialogue = monsterData.dialogue
    if tostring(monster.m_tDialogue) ~= "-1" then
        --monster.m_tDialogue = SplitStringWithSeparator(monster.m_tDialogue, "|")
    end

    -- if monsterData.suit_weapon ~= nil then
    --    monster.m_sWeaponName = SplitStringWithSeparator(monsterData.suit_weapon, "\"")[2]    --"
    -- end
   
    -- if not monster.m_bIsGuaiWithSuit then
    --     monster.m_tAiScript = {}
    --     local aiString = string.gsub(monsterData.guai_ai, " ", "")
    --     local aiList = SplitStringWithSeparator(aiString, ",")
    --     for i, aiId in pairs (aiList) do
    --         table.insert(monster.m_tAiScript,AiConfig["id_"..aiId] and AiConfig["id_"..aiId].peizhi)
    --     end
    --     monster.m_nAiState = 1
    -- else
        monster.m_tAiScript = -1
    -- end
    
    
    monster.m_tAniFileId = {[1]=MonsterConfig[string.gsub(monsterData.AniFileId,"-","_")] and MonsterConfig[string.gsub(monsterData.AniFileId,"-","_")].aniFileId or monsterData.AniFileId}
    monster.m_tAniFileIndex = monsterData.AniFileId
    monster.m_tAiType = {[1]=monsterData.attack_type,}
    monster.m_tDataId = {[1]=id}
    monster.m_tState = {[1]=monsterData.state,}
    monster.m_sAniFileId = monster.m_tAniFileId[1]

    monster.m_nAiType = monster.m_tAiType[1]
    monster.m_nBulletId = monsterData.bullet
    -- monster.m_bPenetrate = monsterData.penetrate == 1
    monster.m_sHeadId =  self.m_sAniFileId
    if monster.getMonsterConfig then
        monster.m_nBuffAnimOffsetX = monster:getMonsterConfig().buffAnimOffsetX
        monster.m_nBuffAnimOffsetY = monster:getMonsterConfig().buffAnimOffsetY
        monster.m_tbulletPosOffset = monster:getMonsterConfig().bulletPosOffset or {x=0,y=0}
        monster.m_bIsOldAnim = monster:getMonsterConfig().isSpine or false
    end
    monster.m_nFighting = monsterData.fighting
    monster.professionId = makePairOk.professionId and makePairOk.professionId[index] or 0

    local sExplode = "weapon1a" --tStrList.weapon
    if monsterData.broken ~= -1 then
        sExplode = monsterData.broken
    end
    
    local img = WeaponExplodeTexture[sExplode] or string.format("%sb",string.sub(sExplode,0,sExplode:len()-1))

    sExplode = RESOURCE_BULLET_EXPLODE..img..".png"
    monster.m_bulletCilcle = BattleUtil:getCircleImg(sExplode)
    monster.m_bulletCilcle:retain()

    WZLog("WMonster:setDevilGuaiInfo two", self.m_sAniFileId, sExplode)

    if monster.m_tAniFileIndex ~= -1 then
        monster.m_bIsLeftFlip = monster.m_tAniFileIndex and monster:getMonsterConfig().animIsLeftFlip
        monster.m_tAnimPowerUpOffset = monster.m_tAniFileIndex and monster:getMonsterConfig().animPowerUpOffset or {x=0,y=0}
    end

    if monsterData.talk and monsterData.talk[1] ~= -1 then
        monster.m_nSklillTalkList = monsterData.talk --{{20000},{2000}}
    end

    monster.m_tSkillParam = monsterData.tSkillParam
    monster.m_nMonsterType = monsterData.type

    monster.m_nBeginMaxHp = monster.m_nMaxHP
    monster.suitConfig = monsterData.suitConfig
    WZLog("WMonster:setDevilGuaiInfo four", monster.m_fRadiusForBulletExplode)
    local playerName = BattleHeroName:create(monster, SceneBattle:getInfoLayer(), false)
    playerName:update()
    monster:setPlayerNameIcon(playerName)
    WBattleGlobal:getCurrent().m_tCharacterAttributeList[monster.m_nBattleId] = {battleId=monster.m_nBattleId, atk=monster.m_nAttack}
end

--@brief    怪变怪物的大小
function WMonster:changeScale(nScale)
    -- body
    self.m_nScale = nScale
    self:setScale(nScale)
    self:changeRectCollision()
end

--@brief    执行击杀生效
function WMonster:doKillEffect()
    -- body
    local hero = WBattleGlobal:getCurrent():getCurrentCharacter()
    if hero == nil or (hero:isDead() and hero:getId() ~= self:getId()) then 
        return 
    end
    --龙卷风、图腾等机关不算
    if self:getType() == 1 and self.m_nMonsterType > MonsterType.ELITE then return end 
    if hero:getCamp() and self:getCamp() and hero:getId() ~= self:getId() and hero:getCamp() == self:getCamp() then return end 

    local bExist = false
    if hero.m_tSkillTakeEffectKillList then 
        for i = 1, #hero.m_tSkillTakeEffectKillList do
            if hero.m_tSkillTakeEffectKillList[i] == self:getBattleId() then 
                bExist = true 
                break 
            end
        end

        if not bExist then 
            table.insert(hero.m_tSkillTakeEffectKillList, self:getBattleId())
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
                hero.m_tSkillTakeEffectKillInfo, TakeEffectType.KILL,
                nil
                --bullets[i]
                )
        end
    end
end

--@brief    发送玩家坑杀怪物的事件
function WMonster:_postMonsterDropDeadEvent()
    -- body
    if not WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_SINGLE) then return end 

    local mapId = WBattleGlobal:getCurrent().m_tMakePairOk.mapId
    if mapId == 10104 then 
        PostPlayerEvent:postEvent(PostPlayerEvent.event_threeLvMonsterDead)
    end
end

--@brief    获得随机的一个玩家
--@param    chooseType:1->友方；2->敌方
function WMonster:getGhostSkillTargetPlayer(hero, chooseType)
    WZLog("WMonster:getGhostSkillTargetPlayer")
    --随机数
    local nTurnTimes = WBattleGlobal:getCurrent():getTurnTimes()
    local randNumIndex = nTurnTimes % 10 + 1
    local randNumList = WBattleGlobal:getCurrent().m_tBattleRand
    
    --目标英雄
    local tHeroList = WBattleGlobal:getCurrent():getHeroSortList()
    local nPlayerCount = 0
    local tPlayerIds = {}
    for i ,v in ipairs(tHeroList) do
        if not v:isDead() and v:getHp() > 0 and chooseType == 1 then
            if WBattleGlobal:isSameTeam(hero:getBattleId(), v:getBattleId()) then
                nPlayerCount = nPlayerCount + 1        
                tPlayerIds[nPlayerCount] = v.m_nPlayerId
            end
        elseif not v:isDead() and v:getHp() > 0 and chooseType == 2 then
            if not WBattleGlobal:isSameTeam(hero:getBattleId(), v:getBattleId()) then
                nPlayerCount = nPlayerCount + 1        
                tPlayerIds[nPlayerCount] = v.m_nPlayerId
            end
        end
    end
    
    local targetHeroId = tPlayerIds[randNumList[randNumIndex] % #tPlayerIds + 1]

    return targetHeroId
end

--@brief    检测小孩碰撞
--@return   #1:true:撞了,false:没撞
--@return   #2:碰撞的人物列表
function WMonster:checkKidCollision()
--    WZLog("WMonster:checkHeroCollision", tostring(self:getMover()))
    local posList = {}
    local prePos = nil
    local curPos = nil 
    if self:getMover() then 
        curPos = self:getMover():getMoverPosition()
        if self:getMover():getMoverPrePosition() then
            prePos =  {x = self:getMover():getMoverPrePosition().x,y = self:getMover():getMoverPrePosition().y}
            --起点不可能为0
            if prePos.x == 0 or prePos.y == 0 then
                prePos = nil
            end
        end
        
        while prePos and math.abs(curPos.x - prePos.x) > 30 do
            local dir = 1
            if curPos.x < prePos.x then
                dir = -1
            end
            local tx = prePos.x + 30*dir
            local ty = prePos.y + math.abs(30/(curPos.x - prePos.x))*(curPos.y - prePos.y)
            local midPos = Vector2:create(tx,ty)
            table.insert(posList,midPos)

            prePos = {x = tx, y = ty}
        end
    else
        curPos = self:getPosition()
    end
    table.insert(posList,curPos)
    -- for i,v in pairs(posList) do
    --     WZLog("WMonster:checkHeroCollision List",v.x,v.y)
    -- end
    local tmpCharas = {}
    local isCollision = false
    for k,checkPos in ipairs(posList) do
        local isCollisionInList, collisionCharas = self:checkCollisionWithKidList(checkPos)
--        WZLog("WMonster:checkCollision three")

        if not isCollision then
            isCollision = isCollisionInList
        end

        AddTableToTable(tmpCharas, collisionCharas)

        if isCollision then
            -- self.m_mover:setMoverPosition(Vector2:create(checkPos.x,checkPos.y))
            -- WZLog("WMonster:checkCollision collosion",curPos.x)
           return isCollision, tmpCharas
        end
    end
    return false,{}
end

--@brief    检查小孩碰撞
--@param    pos:怪的位置
--@return   #1:true:撞了,false:没撞
--@return   #2:碰撞的人物列表
function WMonster:checkCollisionWithKidList(pos)
    local tmpCharas = {}
    local isCollision = false
    local tCollisionRang = self:getCollisionRang()
    if tCollisionRang then 
        for i, rang in pairs(tCollisionRang) do
            for id, kid in ipairs(WBattleGlobal:getCurrent():getKidSortList()) do
                WZLog("WMonster:checkCollisionWithKidList one", id, tostring(kid:isDead()), kid:getBattleId())
                if kid:getShootState() >= 0 and not kid:isDead() and kid:getCamp() ~= self:getCamp() then
                    local charaPos = kid:getPosition()
                    local collisionRang = kid:getCollisionRang()
                    WZLog("WMonster:checkCollisionWithKidList two", id, kid:getBattleId(), tostring(kid:isDead()), charaPos.x, charaPos.y, Serialize(rang))
                    local _isCollision = self:checkCollisionWithRang(pos, rang, charaPos, collisionRang)

                    if _isCollision then
                        WZLog("WMonster:checkCollisionWithKidList four")
                        tmpCharas[kid:getBattleId()] = kid
                        isCollision = true
                    end
                end
            end
        end
    end
    return isCollision, tmpCharas
end

--@brief    检查区域碰撞
--@param    rang:区域
--@return   #1:true:撞了,false:没撞
function WMonster:checkCollisionWithRang(pos, selfCollisionRang, charaPos, collisionRang)
    local dis = nil
    if collisionRang ~= nil then
        for i,rang in pairs(collisionRang) do
            if rang.m_nType == 1 then
                local rect = {x = charaPos.x+rang.m_fXOffset - rang.m_fWidth*0.5,y = charaPos.y+rang.m_fYOffset,w = rang.m_fWidth,h=rang.m_fHeight}
               
                local rectMonster = {x = pos.x + selfCollisionRang.m_fXOffset - selfCollisionRang.m_fWidth*0.5 ,y=pos.y+selfCollisionRang.m_fYOffset,w = selfCollisionRang.m_fWidth,h=selfCollisionRang.m_fHeight}
                local _isCollision = BattleCommon:checkRangCollisionWithRang(rect, rectMonster)
--                WZLog("WMonster:checkCollisionWithRang two", i)
                if _isCollision then
                   return true
                end
            end
        end
    end

    WZLog("WBullet:checkCollisionWithRang four")
    return false
end

--@brief    获得随机的一个队友玩家
--@param    buffSetType:buff的增益与损益类型
function WMonster:getRandomTeamPlayer(hero, buffSetType)
    local tTargetHeroList = {}
    
    --目标英雄
    local nPlayerCount = 0
    local tPlayerIds = {}
    
    local tHeroList = WBattleGlobal:getCurrent():getCharacterList(true)
    local battleId = hero:getBattleId()
    for i, chara in pairs(tHeroList) do
        local isMacth = false
        local tBattleId = chara:getBattleId()
        if buffSetType == 1 and chara:getHp() > 0 and not chara:isDead() and WBattleGlobal:getCurrent():isSameTeam(battleId, tBattleId) and chara:getCharaActionType() ~= 2 then
            isMacth = true
        elseif buffSetType == 0 and chara:getHp() > 0 and not chara:isDead() and not WBattleGlobal:getCurrent():isSameTeam(battleId, tBattleId) and chara:getCharaActionType() ~= 2 then
            isMacth = true
        end
        if isMacth then
            nPlayerCount = nPlayerCount + 1        
            table.insert(tTargetHeroList, chara)
        end
    end

    table.sort(tTargetHeroList, function (a, b)
            local battleIdA = a:getBattleId()
            local battleIdB = b:getBattleId()
            return battleIdA < battleIdB
        end
        )

    --随机数
    local random = BattleMethod:getRandomByIndex(battleId, 2)

    local targetHero = tTargetHeroList[random % nPlayerCount + 1]
    return {targetHero}
end