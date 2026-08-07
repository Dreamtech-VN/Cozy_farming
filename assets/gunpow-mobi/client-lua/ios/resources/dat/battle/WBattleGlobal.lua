--WBattleGlobal.lua
--@brief	全局战斗管理表
--@date		2014/1/7
--@author	李俊鸿
--@note		管理所有当前战斗角色及战斗状态

--@brief	战斗管理数据表
WBattleGlobal = {
	m_tMakePairOk = { --战斗匹配信息
		battleId=nil,     			roomId=nil,
		battleMode=nil,   			playerName=nil,
		battleMap=nil,    			playerLevel=nil,
		playerCount=nil,  			boyOrGirl=nil,
		playerId=nil,     			suit_head=nil,
		camp=nil,                   suit_face=nil,
		maxHP=nil,                  suit_body=nil,
		maxPF=nil,                  suit_weapon=nil,
		maxSP=nil,                  weapon_type=nil,
		attack=nil,                 defenfce=nil,
		bigSkillAttack=nil,         bigSkillType=nil,
		critRate=nil,               explodeRadius=nil,
		specialAttackParam=nil,     item_id=nil,
		playerBuffCount=nil,        item_used=nil,
		buffType=nil,               item_img=nil,
		buffParam1=nil,             item_name=nil,
		buffParam2=nil,             item_desc=nil,
		buffParam3=nil,             item_type=nil,
		player_suit_wing=nil,       item_subType=nil,
		player_title=nil,           item_param1=nil,
		player_community=nil,       item_param2=nil,
		weaponSkillPlayerId=nil,    item_ConsumePower=nil,
		weaponSkillName=nil,        specialAttackType=nil,
		weaponSkillType=nil,        wreckDefense=nil,
		weaponSkillChance=nil,      reduceCrit=nil,
		weaponSkillParam1=nil,      reduceBury=nil,
		weaponSkillParam2=nil,      zsleve=nil,
		beEnemyCommunity=nil,       skillful=nil,
		injuryFree=nil,             petId=nil,
		petProbability=nil,         petIcon=nil,
		petParam1=nil,              petType=nil,
		petParam2=nil,              petSkillId=nil,
		petEffect=nil,				serverName=nil,				
		selfId=nil,                 guai_sp=nil,
		petVersion=nil,             petParam3=nil,
        fighting=nil,               winRate=nil,
        robotSkill=nil,
        power=nil,                  armor=nil,
        constitution=nil,           agility=nil,
        lucky=nil,
		--boss扩展
		bossMapName=nil,            guai_pf=nil,
		map_icon=nil,               guai_defend=nil,
		posX=nil,                   guai_attack=nil,
		posY=nil,                   guai_attackArea=nil,
		guaiCount=nil,              guai_criticalRate=nil,
		guaiBattleId=nil,           guai_bigSkillType=nil,
		guaiId=nil,                 guai_explode=nil,
		guaiPosX=nil,               guai_broken=nil,
		guaiPosY=nil,               guai_AniFileId=nil,
		guai_name=nil,              guai_could_build_guai=nil,
		guai_camp=nil,              guai_build_guai_id=nil,
		guai_sex=nil,               idcount=nil,
		guai_suit_head=nil,         build_guai_id_list=nil,
		guai_suit_face=nil,         difficulty=nil,
		guai_suit_body=nil,         guai_injuryFree=nil,
		guai_suit_weapon=nil,       guai_wreckDefense=nil,
		guai_weapon_type=nil,       guai_reduceCrit=nil,
		guai_type=nil,              guai_reduceBury=nil,
		guai_level=nil,             skillHurt=nil,
		guai_attacktype=nil,		guai_hp=nil,
        guai_ai=nil,                guai_dialogue=nil,
        tournamentLevel = nil,      petSkill=nil,
        colour = nil,               bodyColour=nil,
        isCaptain = nil,            schedule=nil,
	},
	m_tSkillList = {
		itemSubType=nil,			param1=nil,
		name=nil,                   param2=nil,
		icon=nil,                   tireValue=nil,
		priceCostGold=nil,          consumePower=nil,
		desc=nil,                   specialAttackType=nil,
		itemMainType=nil,           specialAttackParam=nil,
		damageRange=nil,			coolSkillTime=nil,
	},
	m_tPropList = {
		itemSubType=nil,			param1=nil,
		name=nil,                   param2=nil,
		icon=nil,                   tireValue=nil,
		priceCostGold=nil,          consumePower=nil,
		desc=nil,                   specialAttackType=nil,
		itemMainType=nil,           specialAttackParam=nil,
		damageRange=nil,			coolSkillTime=nil,
	},
	m_tMySkill_Beginning = {
		count=nil,                  itemSubType=nil,
		id=nil,                     param1=nil,
		name=nil,                   param2=nil,
		icon=nil,                   tireValue=nil,
		priceCostGold=nil,          consumePower=nil,
		desc=nil,                   specialAttackType=nil,
		itemMainType=nil,           specialAttackParam=nil,
		damageRange=nil,			coolSkillTime=nil,
	},
	m_tMyProp_Beginning = {
		count=nil,                  itemSubType=nil,
		id=nil,                     param1=nil,
		name=nil,                   param2=nil,
		icon=nil,                   tireValue=nil,
		priceCostGold=nil,          consumePower=nil,
		desc=nil,                   specialAttackType=nil,
		itemMainType=nil,           specialAttackParam=nil,
		damageRange=nil,			coolSkillTime=nil,
	},
	m_tHeros = {}, 				--战斗角色列表
	m_tExitHeros = {}, 			--逃跑战斗角色列表
	m_tGuais = {}, 				--战斗怪物列表
	m_bIsRequestingId = false,	--是否正在申请id
	m_tGuaiBattleId = {},		--服务器返回的小怪的battleId
	m_tGuaisTemplate = {},		--小怪模版
	m_tBullets = {}, 			--子弹列表
	m_tBossBullets = {}, 		--Boss子弹列表
	m_CurrentPlayerArrow = nil, --当前操作的角色指示箭头

	m_tWind = {x=0,y=0},		--风力
	m_nCurrentPlayerId = nil,	--当前玩家id
	m_nIsCriticalHit = nil,		--是否暴击(1是0否)
	m_tAttackRate = nil,		--攻击比率
	m_nIsNewRound = nil,		--是否新回合(1是0否)
	m_tBattleRand = nil,		--游戏随机数
	m_nBattleType = nil,		--战斗类型(BattleConstants.g_nBATTLE_TYPE_NORMAL:普通战斗,BattleConstants.g_nBATTLE_TYPE_BOSS:副本战斗)

	m_nTurnTimes = 0,			--第几回合
    m_nRecordRound = 0,         --第几回合（战斗记录）
	m_bWaitNextRound = false,	--是否等待新的回合

	m_nReference = 0,			--引用计数
	
	--大招动画
	m_tBigSkill_1 = nil,
	m_tBigSkill_2 = nil,
	m_tBigSkill_3 = nil,
	m_tBigSkill_4 = nil,
	
	--复活相关
	m_nLeftMedal = nil,
	m_nRightMedal = nil,
	m_nNeedMedal = nil,

	--心跳协议
	m_fShakeHands = nil,
	
	--战斗结束标志
	m_bGameOver = false,

	--战斗移动管理
	m_battleManager = nil,

    m_worldBossMaxHp = 0,   --世界boss总血量
	
	--加密数据
	m_nTurnTimes_Encrypt = nil,
	skillHurt_Encrypt = nil,
    
    m_bHideArrow = nil,

    --单人副本
    m_tCleanConditionList = nil,            --通关条件
    m_bIsCleanWithGuaiDestroy = false,      --胜利条件是否杀死敌
    m_bIsCleanWithHoleGuai = false,         --胜利条件是否坑杀敌人
    m_tGuaiDestroyList = nil,               --需要杀死的敌人的ID列表
    m_tHoleGuaiList = nil,                  --需要坑杀的怪的ID列表
    m_bIsSingleChallengeGameOver = false,   --单人副本是否结束
    m_tUseSkillItemInCurTurnList = nil,     --在当前回合使用的技能道具
    m_tSingleActivityMemberList = nil,      --单人副本的能动的成员列表
    m_nSingleActivityMemberIndex = nil,     --单人副本的能动的成员列表索引
    m_tDataCheckList = nil,                 --检测作弊
    m_tBattleRecord = nil,                  --战斗过程记录
    m_tBuildMonsterRecord = nil,            --创建怪物记录
    m_tHoleMonsterRecord = nil,
    m_nIsEndCurThisTurnWithDead = nil,      --是否因玩家死亡而发送结束当前回合

    m_nServiceMode = nil,                   --模式是跨服还是本服
    m_bShowGameOver = nil,                  --是否可以显示游戏结束
    m_nRandNumIndex = 0,                    --当前随机数下标

    m_tAttackRandomList = nil,              --攻击者所用的被动技能随机数数组
    m_tTargetRandomList = nil,              --被攻击者所用的被动技能随机数数组
    
    m_bIsCurTurnActed = nil,                --本回合是否已经行动过
    m_nWBoss3ShieldRound = nil,             --boss3盾牌存在回合
    m_tAtomExplode = nil,                   --核弹爆炸控件
    
    m_nBuildGuaiIndex = 0,                  --生成怪的序号

    m_tAiSkillCombos = nil,                 --AI技能组合

    m_tIsHighEndMachine = false,            --是否高端机
    m_tMapEvents = nil,                     --地图事件
    m_nMeteoriteAttackTurn = 0,             --陨石袭击回合数
    m_nMeteoriteAttackHurt = 0,             --陨石袭击伤害
    m_nMeteoriteAttackerId = 0,             --陨石袭击者的ID
    m_nMeteoriteAttack = 0,                 --陨石袭击

    m_nSendEndMsgTurn = 0,                  --已发送过结束回合消息的回合数
    m_tSendEndMsgPlayer = nil,              --已发送过结束回合消息的玩家
    m_nDeadHeroId = 0,                      --死亡的英雄的Id

    m_nEndCurRoundBattleId = nil,           --回合结束战斗id记录

    m_copyData = nil,                       --副本控制数据
    m_bIsZoomToHero = nil ,
    m_tTakeSkillBulletList = nil,

    m_isQuickCopyTest = nil,                --快速副本测试

    m_bIsGameOverTimer = nil,
    m_nGameOverTimer = nil,
    m_tGameOverAnim = nil,
    m_tGameOverMsg = nil,
    m_bIsDoGameOverMsg = nil,
    m_bIsDoEffectAfterAttack = nil,
    m_tBuffAddSkillPlayerList = nil,
    m_tAIControlList = nil,
    m_nTreasureRound = -1,
    m_tTreasureAppearList = nil,
    m_tTreasureCatchIdList = nil,
    m_nTreasureCountMax = 0,
    m_bIsStartBattle = nil,
    m_tCurRoundAction = nil,
    m_nStartRoundTimes = 1,
    m_bIsWin = nil,

    m_nHostBattleId = nil,      --主机id
    m_tKillCountList = nil,
    m_nShowKillTime = -1,
    m_nReceivePassRound = nil,  --客机收到pass的回合
    m_nShowNetLostTime = -1,
    m_nShowNetLost = nil,
    m_lastGCTime = 0,           --上一次垃圾回收时间
    m_tRoundInfoList = nil,
    m_nRelinkLoading = -1,
    m_nComeBackBattleId = -1,
    m_nScale = 0,   --人物操作范围倍数

    m_bMapCanDigHole = true, --地图爆破
    m_tCharacterAttributeList = nil, --角色的属性列表(包括已死亡的)
    m_nNetLoading = -1,

    m_bSendCurRoundInfo = -1,
    m_nSendCurRoundInfoTimer = -1,
    m_bSendCurRoundInfoOk = -1,
    m_bSendCurRoundInfoLisk = nil,
    m_nShowNetTipType = -1,
    m_nShowNetTipId = -1,
    m_bIsAudience = nil,    --是否是观众
    m_tCurRoundSkillId = nil, --当前回合使用的技能Id
    m_nAwakeSkillId = nil,   --觉醒技能id
    m_nPetAttackHurtCurRound = nil, --当前回合的宠物伤害

    m_nLaserGunState = nil, --副本7激光状态
    m_nMyRemainHp = -1,

    m_nFlyCopyIndex = 2;
    m_tReceiveDeadPlayerId = nil,

    m_tWaitForRebornPosList = nil,  --等待复活
    m_bIsWaitSynchronousBattle = nil,   --等待重连
    m_nCheckNoHoleIndex = 1,    --检查免坑index
    m_nBulletId = 1,
    m_bIsWindTeach = nil, --是否风力教学
    m_bIsChapterOneTeach = nil, --是否第一章教学
    m_bIsBossAndChapterOneTeach = nil, --新手BOss和第一关教学
    m_bIsFirstPvpTeach = nil, --是否竞技教学
    m_bIsHoleTeach = nil, --是否掉坑教学
    m_bIsCopyTeach = nil, --是否组队副本教学
    m_bIsFog = nil,    --是否迷雾
    m_bIsErosion = nil,    --是否地图侵蚀
    m_tErosionData = nil,   --侵蚀参数
    m_tFogData = nil,   --清雾参数
    m_bIsCanUseAwakeSkill = true, --是否可以使用觉醒技能
    m_tMyGhostSkill_Beginning = {
        count=nil,                  itemSubType=nil,
        id=nil,                     param1=nil,
        name=nil,                   param2=nil,
        icon=nil,                   tireValue=nil,
        priceCostGold=nil,          consumePower=nil,
        desc=nil,                   specialAttackType=nil,
        itemMainType=nil,           specialAttackParam=nil,
        damageRange=nil,            coolSkillTime=nil,
        skillUniqueId = nil,        choose = nil,
    },
    m_tPlayerBornPt = nil,  --玩家出生点
    m_bIsGhost = false,     --是否开启幽灵模式
    m_monsterHero = nil,    --怪兽模式-怪兽形象
    m_tSpatterAngle = nil,  --当前溅射弹角度列表
}

local g_battleGlobal = nil

SingleChallengeCleanCondition = {
    TYPE_GUAI_DESTROY = 1,  --敌全灭
    TYPE_HOLE_GUAI = 2,  --坑杀敌人
    
}

-------------------------------------公有方法模块--------------------------------------

--@brief	获取当前战斗管理对象
--@return	#1:WBattleGlobal战斗管理对象
function WBattleGlobal:getCurrent()
	if not g_battleGlobal then
		WBattleGlobal:_init()
        BattleMsgPlayerReadyShoot.isRun = nil
        BattleMsgPlayerReadyFly.isRun = nil
        BattleMsgPlayerMoveCtrl.isRun = nil
        BattleMsgPlayerMove.m_nProcess = 0
	end
	return g_battleGlobal
end

--@brief	销毁当前战斗管理对象
function WBattleGlobal:destroy()
    if WBattleGlobal:getCurrent():isReplayGame() then
        NetManager:resetDeltaTime()
    end

    WZLog("WBattleGlobal:destroy zero", self.m_nReference)
    self.m_bIsReplayGame = nil
	self.m_nReference = self.m_nReference - 1
	if self.m_nReference <=0 then
        if WBattleGlobal:getCurrent().m_nNetLoading ~= -1 then
            MsgBoxManager:stopLoadingBoxByMsgId(WBattleGlobal:getCurrent().m_nNetLoading)
            WBattleGlobal:getCurrent().m_nNetLoading = -1
        end

		if self:story() ~= false then
			GlobalGame:setIfInBattle(false)
		end
        GlobalGame.g_lastRoomNumber = nil
        GlobalGame.g_lastRoomSeat = nil

        if BattleMsgPlayerMove ~= nil then
            BattleMsgPlayerMove.m_nProcess = 0
        end

		--英雄
		for id,hero in pairs(self.m_tHeros) do
			if hero and hero:getIsExist() then
				hero:destroy()
			end
		end
		self.m_tHeros = nil

		--逃跑英雄
		for id,hero in pairs(self.m_tExitHeros) do
			if hero and hero:getIsExist() then
				hero:destroy()
			end
		end
		self.m_tExitHeros = nil

		--怪物
		for id,guai in pairs(self.m_tGuais) do
			if guai and guai:getIsExist() then
				guai:destroy()
			end
		end
		self.m_tGuais = nil

		--子弹
		for i,bullet in pairs(self.m_tBullets) do
			if bullet and bullet:getIsExist() then
				bullet:destroy()
			end
		end
		self.m_tBullets = nil

		--boss子弹
		for i,bullet in pairs(self.m_tBossBullets) do
			if bullet and bullet:getIsExist() then
				bullet:destroy()
			end
		end
		self.m_tBossBullets = nil

        for i,machine in pairs(self.m_tMachines) do
            if machine then
                machine:destroy()
            end
        end
        self.m_tMachines = nil

        if self.m_tAtomExplode ~= nil and self.m_tAtomExplode.release ~= nil then
            self.m_tAtomExplode:release()
        end

        --地图事件
        if self.m_tMapEvents ~= nil and #self.m_tMapEvents > 0  then
            for i, event in pairs(self.m_tMapEvents) do
                event:destroy()
            end
        end

        if SceneBattle:getBattlePointsLine() then
            WZLog("WBattleGlobal:destroy one-1")
            SceneBattle:getBattlePointsLine():destroy()
            SceneBattle.m_pointsLine = nil
        end

        if WndBattleHud.m_tLine then
            WZLog("WBattleGlobal:destroy one-2")
            WndBattleHud.m_tLine:destroy()
            WndBattleHud.m_tLine = nil
        end

        if BattleMsgTeachStep4.m_tLine then
            WZLog("WBattleGlobal:destroy one-3")
            BattleMsgTeachStep4.m_tLine:destroy()
            BattleMsgTeachStep4.m_tLine = nil
        end

		self.m_nReference = 0

		if self.m_battleManager then
			self.m_battleManager:release()
		end
		self.m_battleManager = nil

        BattleEffectManager:getInstance():destroy()

        --副本信息
        if self.m_copyData then
            self.m_copyData:destroy()
            self.m_copyData = nil
        end
		
        --单人副本
        self.m_tCleanConditionList = nil
        self.m_bIsCleanWithGuaiDestroy = false
        self.m_bIsCleanWithHoleGuai = false
        self.m_tGuaiDestroyList = nil
        self.m_tHoleGuaiList = nil
        self.m_bIsSingleChallengeGameOver = false
        self.m_tUseSkillItemInCurTurnList = nil
        self.m_tSingleActivityMemberList = nil
        self.m_nSingleActivityMemberIndex = nil
        self.m_tDataCheckList = nil
        self.m_tBattleRecord = nil
        self.m_tBuildMonsterRecord = nil
        self.m_tHoleMonsterRecord = nil
        self.m_nTurnTimes_Encrypt = nil
        self.skillHurt_Encrypt = nil

        self.m_nServiceMode = nil
        self.m_nRandNumIndex = 0
        self.m_tAttackRandomList = nil
        self.m_tTargetRandomList = nil
        self.m_bIsCurTurnActed = nil
        self.m_nWBoss3ShieldRound = nil

        self.m_tAtomExplode = nil
        self.m_nBuildGuaiIndex = 0
        self.m_tAiSkillCombos = nil
        self.m_tIsHighEndMachine = false

        self.m_tMapEvents = nil
        self.m_nMeteoriteAttackTurn = 0
        self.m_nMeteoriteAttackHurt = 0
        self.m_nMeteoriteAttackerId = 0

        self.m_nSendEndMsgTurn = 0
        self.m_tSendEndMsgPlayer = nil
        self.m_nDeadHeroId = 0

        self.m_bIsGameOverTimer = nil
        self.m_nGameOverTimer = nil
        self.m_tGameOverAnim = nil
        self.m_tGameOverMsg = nil
        self.m_bIsDoGameOverMsg = nil
        self.m_bIsDoEffectAfterAttack = nil
        self.m_tAIControlList = nil
        self.m_nTreasureRound = -1
    	self.m_tTreasureAppearList = nil
        self.m_tTreasureCatchIdList = nil
        self.m_nTreasureCountMax = 0
        self.m_bIsStartBattle = nil
        self.m_tCurRoundAction = nil
        self.m_nStartRoundTimes = 1
        self.m_nHostBattleId = nil
        self.m_nMonsterRequestId = nil
        self.m_nHeroRequestId = nil

        self.m_tKillCountList = nil
        self.m_nShowKillTime = -1
        self.m_nShowNetLostTime = -1
        self.m_nShowNetLost = nil
        self.m_tRoundInfoList = nil
        self.m_nRelinkLoading = -1
        self.m_nComeBackBattleId = -1
        self.m_nScale = 0
        self.m_tCharacterAttributeList = nil
        self.m_nNetLoading = -1
        self.m_bSendCurRoundInfo = -1
        self.m_nSendCurRoundInfoTimer = -1
        self.m_bSendCurRoundInfoOk = -1
        self.m_bSendCurRoundInfoLisk = nil
        self.m_nShowNetTipType = -1
        self.m_nShowNetTipId = -1
        self.m_bIsAudience = nil
        self.m_tCurRoundSkillId = nil
        self.m_nPetAttackHurtCurRound = nil
        self.m_nMyRemainHp = -1
        self.m_nFlyCopyIndex = 2

        self.m_nLaserGunState = nil
        self.m_tReceiveDeadPlayerId = nil

        self.m_tWaitForRebornPosList = nil
        self.m_bIsWaitSynchronousBattle = nil
        self.m_nCheckNoHoleIndex = 1
        self.m_nBulletId = 1
        self.m_bIsWindTeach = nil
        self.m_bIsChapterOneTeach = nil
        self.m_bIsBossAndChapterOneTeach = nil
        self.m_bIsFirstPvpTeach = nil
        self.m_bIsHoleTeach = nil
        self.m_bIsCopyTeach = nil
        self.m_bIsFog = nil
        self.m_bIsErosion = nil

        self.m_nAwakeSkillId = nil
        self.m_bIsCanUseAwakeSkill = nil 

        if self.m_tErosionData then
            self.m_tErosionData.bulletCilcle:release()
            self.m_tErosionData.bulletCilcle = nil
            self.m_tErosionData = nil
        end

        if self.m_tFogData then
            self.m_tFogData.bulletCilcle:release()
            self.m_tFogData.bulletCilcle = nil
            self.m_tFogData = nil
        end

        BattleAudienceManager:destroy()
        BattlePetSkillManager:destroy()

		g_battleGlobal = nil
        TeachGroup1.ISBATTLE = nil
        TeachGroup1.ISBATTLE_MYTURN = false
        BattleMsgPlayerReadyShoot.isRun = nil
        BattleMsgPlayerReadyFly.isRun = nil
        BattleMsgPlayerMoveCtrl.isRun = nil

	end
end

--@brief 是否逃杀
function WBattleGlobal:isEscapeBattle()
    if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_NORMAL and 
        WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_QS then
        return true
    end
    return false
end

--@brief 地图侵蚀
function WBattleGlobal:isErosion()
    local isErosion = self.m_bIsErosion

    if isErosion == nil then
        if false or WBattleGlobal:getCurrent():isEscapeBattle() then
            isErosion = true
            self.m_bIsErosion = true
            WZLog("WBattleGlobal:isErosion", isErosion)
        else
            isErosion = false
            self.m_bIsErosion = false
        end
    end
    return isErosion
end

--@brief 迷雾
function WBattleGlobal:isFog()
    local isFog = self.m_bIsFog

    if isFog == nil then
        if false or WBattleGlobal:getCurrent():isEscapeBattle() then
            isFog = true
            self.m_bIsFog = true
            WZLog("WBattleGlobal:isFog", isFog)
        else
            isFog = false
            self.m_bIsFog = false
        end
    end
    return isFog
end

--@brief    初始化地图侵蚀
function WBattleGlobal:initMapErosion(dir)
    WZLog("WBattleGlobal:initMapErosion", self:isErosion())
    if self:isErosion() then
        self.m_tErosionData = {}
        local img = "weapon9999b"
        -- if not BattleMapManager:isNew() then
        --     img = "weapon9999b"
        -- end
        self.m_tErosionData.bulletCilcle = BattleUtil:getCircleImg(RESOURCE_BULLET_EXPLODE..img..".png")
        self.m_tErosionData.bulletCilcle:retain()
        self.m_tErosionData.breakCircle = tolua.cast(self.m_tErosionData.bulletCilcle:objectAtIndex(0),"WDMemoryImage")
        self.m_tErosionData.breakCircleMark = tolua.cast(self.m_tErosionData.bulletCilcle:objectAtIndex(1),"WDMemoryImage")
        self.m_tErosionData.erosionX, self.m_tErosionData.erosionY, self.m_tErosionData.erosionWidth, 
        self.m_tErosionData.erosionHeight = 0, 900, 350, 10000

        self.m_tErosionData.dir = dir or WBattleGlobal:getCurrent().m_tBattleRand[1] % 3 --WBattleGlobal:getCurrent().m_tMakePairOk.playerId[2] % 2
        self.m_tErosionData.count = 0
        self.m_tErosionData.totalTime = tonumber(CacheCenter:getGameParam().greatEscapeBattleTime)
        self.m_tErosionData.actionTime = 15
        self.m_tErosionData.erosionXChange = (2304 / (self.m_tErosionData.totalTime * 60 / self.m_tErosionData.actionTime)) / 2
        self.m_tErosionData.erosionWidth = math.abs(self.m_tErosionData.erosionXChange) / (193 / 350) * 1.2 * 2
        
        WZLog("WBattleGlobal:initMapErosion two", self.m_tErosionData.dir, self.m_tErosionData.totalTime, self.m_tErosionData.erosionXChange, self.m_tErosionData.erosionWidth)
        --self.m_tErosionData.dir = 2
        local poisonFog= SceneBattle:getPoisonFog()
        if self.m_tErosionData.dir == 1 then
            self.m_tErosionData.erosionX = 2300
            self.m_tErosionData.erosionXChange = self.m_tErosionData.erosionXChange * -1

            poisonFog:setScaleX(poisonFog:getScaleX() * -1)
            local x, y = poisonFog:getAbsPosition().x, poisonFog:getAbsPosition().y
            poisonFog:setAbsPosition(GlobalMethod:ccp(2404, y))
        elseif self.m_tErosionData.dir == 0 then
            local x, y = poisonFog:getAbsPosition().x, poisonFog:getAbsPosition().y
            poisonFog:setAbsPosition(GlobalMethod:ccp(-100, y))
        else
            local x, y = poisonFog:getAbsPosition().x, poisonFog:getAbsPosition().y
            poisonFog:setAbsPosition(GlobalMethod:ccp(-100, y))

            local poisonFog2 = SceneBattle:getPoisonFog2()
            poisonFog2:setVisible(true)
            poisonFog2:setScaleX(poisonFog2:getScaleX() * -1)
            x, y = poisonFog2:getAbsPosition().x, poisonFog2:getAbsPosition().y
            poisonFog2:setAbsPosition(GlobalMethod:ccp(2404, y))

            self.m_tErosionData.erosionXChange = self.m_tErosionData.erosionXChange / 2
            self.m_tErosionData.erosionWidth = self.m_tErosionData.erosionWidth / 2
            self.m_tErosionData.erosionX2 = 2300
            self.m_tErosionData.erosionXChange2 = self.m_tErosionData.erosionXChange * -1
        end
        --SceneBattle:getFogLayer2():setVisible(false)
        SceneBattle:getPoisonFog():setVisible(true)
    end
end

--@brief    进行地图侵蚀
function WBattleGlobal:doMapErosion(count, dir)
    WZLog("WBattleGlobal:doMapErosion one", self:isErosion(), count)
    if self.m_tErosionData == nil then
        self:initMapErosion(dir)
    end
    count = count or 1
    if self:isErosion() and self.m_tErosionData then
        self.m_tErosionData.count = self.m_tErosionData.count + count
        local x, y, width, height, breakCircle, breakCircleMark = self.m_tErosionData.erosionX, self.m_tErosionData.erosionY, 
        self.m_tErosionData.erosionWidth, self.m_tErosionData.erosionHeight, self.m_tErosionData.breakCircle, self.m_tErosionData.breakCircleMark
        local poisonFog= SceneBattle:getPoisonFog()
        local poisonFog2= SceneBattle:getPoisonFog2()
        
        for i=1,count do
            BattleMapManager:drawBroke(Vector2:create(self.m_tErosionData.erosionX, y), breakCircle, breakCircleMark, width, height, true)
            -- if self:isFog() then
            --     BattleMapManager:fogDrawBroke(Vector2:create(self.m_tErosionData.erosionX, y), breakCircle, breakCircleMark, width, height, true)
            -- end
            self.m_tErosionData.erosionX = self.m_tErosionData.erosionX + self.m_tErosionData.erosionXChange
            local x, y = poisonFog:getAbsPosition().x, poisonFog:getAbsPosition().y
            poisonFog:setAbsPosition(GlobalMethod:ccp(x + self.m_tErosionData.erosionXChange, y))
            WZLog("WBattleGlobal:doMapErosion two", x, y, width, height, self.m_tErosionData.erosionX, self.m_tErosionData.erosionXChange, self.m_tErosionData.erosionWidth)
        
            if self.m_tErosionData.dir == 2 then
                BattleMapManager:drawBroke(Vector2:create(self.m_tErosionData.erosionX2, y), breakCircle, breakCircleMark, width, height, true)
                -- if self:isFog() then
                --     BattleMapManager:fogDrawBroke(Vector2:create(self.m_tErosionData.erosionX2, y), breakCircle, breakCircleMark, width, height, true)
                -- end
                self.m_tErosionData.erosionX2 = self.m_tErosionData.erosionX2 + self.m_tErosionData.erosionXChange2
                local x, y = poisonFog2:getAbsPosition().x, poisonFog2:getAbsPosition().y
                poisonFog2:setAbsPosition(GlobalMethod:ccp(x + self.m_tErosionData.erosionXChange2, y))
                WZLog("WBattleGlobal:doMapErosion three", x, y, width, height, self.m_tErosionData.erosionX2, self.m_tErosionData.erosionXChange2, self.m_tErosionData.erosionWidth2)
            end
        end
    end
end

--@brief    初始化清除雾
function WBattleGlobal:initCleanFog()
    WZLog("WBattleGlobal:initCleanFog one", self:isFog())
    if self:isFog() then
        self.m_tFogData = {}
        self.m_tFogData.posList = {}
        self.m_tFogData.posList[1] = {}
        self.m_tFogData.posList[2] = {}
        self.m_tFogData.posList[3] = {}
        local img = "weapon0b"
        if not BattleMapManager:isNew() then
            img = "weapon9999b"
        end
        self.m_tFogData.bulletCilcle = BattleUtil:getCircleImg(RESOURCE_BULLET_EXPLODE..img..".png")
        self.m_tFogData.bulletCilcle:retain()
        self.m_tFogData.breakCircle = tolua.cast(self.m_tFogData.bulletCilcle:objectAtIndex(0),"WDMemoryImage")
        self.m_tFogData.breakCircleMark = tolua.cast(self.m_tFogData.bulletCilcle:objectAtIndex(1),"WDMemoryImage")
        self.m_tFogData.erosionWidth, self.m_tFogData.erosionHeight, self.m_tFogData.erosionDis = {}, {}, {}

        local visualRange = tonumber(CacheCenter:getGameParam().visualRange) / 100
        visualRange = visualRange < 0.5 and 0.5 or visualRange
        --visualRange = 4
        self.m_tFogData.visualRange = visualRange
        WZLog("WBattleGlobal:initCleanFog two", CacheCenter:getGameParam().visualRange , visualRange)

        table.insert(self.m_tFogData.erosionWidth, 700 * visualRange)--nil)--
        table.insert(self.m_tFogData.erosionHeight,700 * visualRange)--
        table.insert(self.m_tFogData.erosionDis, 100/2)

        table.insert(self.m_tFogData.erosionWidth, visualRange ~= 1 and 350 * visualRange or 350)
        table.insert(self.m_tFogData.erosionHeight, visualRange ~= 1 and 350 * visualRange or 300)
        table.insert(self.m_tFogData.erosionDis, 100/2)

        table.insert(self.m_tFogData.erosionWidth, 350 * 1 * visualRange)
        table.insert(self.m_tFogData.erosionHeight, 350 * 1 * visualRange)
        table.insert(self.m_tFogData.erosionDis, 100/2)
    end
end

--@brief    清除雾
function WBattleGlobal:doCleanFog(x, y, cleanType, width, height, must)
    --WZLog("WBattleGlobal:doCleanFog one", self:isFog(), cleanType, x, y)
    if self:isFog() and self.m_tFogData and x > 0 and x < 2304 and y > 0 and y < 1800 then
        x, y = x/2, y/2
        width = width and width/2 or 700*self.m_tFogData.visualRange/2
        height = height and height/2 or 700*self.m_tFogData.visualRange/2
        local point0 = {x=x,y=y}
        local list = self.m_tFogData.posList[cleanType]
        local dis0 = self.m_tFogData.erosionDis[cleanType]
        local count = #list
        local countMax = 50
        if must == nil and count > 0 then
            local checkCount = count > countMax and countMax or count
            for i=checkCount, 1, -1 do
                local point = list[i]
                if math.abs(point.x - point0.x) > dis0 or math.abs(point.y - point0.y) > dis0  then
                    
                else
                    local dis = BattleCommon:pointDis(point,point0)
                    --WZLog("WBattleGlobal:doCleanFog two", i, dis, count, point.x, point.y, cleanType)
                    if dis < dis0 then
                        return
                    end
                end
            end
        end

        if must == nil then 
            table.insert(self.m_tFogData.posList[cleanType], {x=x, y=y, width=width, height=height})
        end

        local breakCircle, breakCircleMark
        width, height, breakCircle, breakCircleMark = width or self.m_tFogData.erosionWidth[cleanType], height or self.m_tFogData.erosionHeight[cleanType], 
        self.m_tFogData.breakCircle, self.m_tFogData.breakCircleMark
        WZLog("WBattleGlobal:doCleanFog three", x, y, width, height)
        BattleMapManager:fogDrawBroke(Vector2:create(x, y), breakCircle, breakCircleMark, width, height, true, true)
    end
end

--@brief    清除自身雾
function WBattleGlobal:cleanMyFog(hero, cleanType, offsetx, offsety, isMust)
     if not WBattleGlobal:getCurrent():isEscapeBattle() then
        return
    end
    --do return end
    if hero == WBattleGlobal:getCurrent():getMyHero() and (SceneBattle:getBattleLoop():getCount() % 5 == 0 or isMust) then
        cleanType = cleanType or 1
        offsetx = offsetx or 0
        offsety = offsety or 35
        local x, y = hero:getPosition().x, hero:getPosition().y
        WBattleGlobal:getCurrent():doCleanFog(x + offsetx, y + offsety, cleanType)
    end
end

--@brief    清除自身子弹雾
function WBattleGlobal:cleanMyBulletFog(bullet, cleanType, offsetx, offsety, width, height)
    --do return end
    if not WBattleGlobal:getCurrent():isEscapeBattle() then
        return
    end
    local isMyHero = bullet:getOwnerChara() == WBattleGlobal:getCurrent():getMyHero()
    WZLog("WBattleGlobal:cleanMyBulletFog", isMyHero)
    if isMyHero and (SceneBattle:getBattleLoop():getCount() % 3 == 0 or cleanType == 3) then
        cleanType = cleanType or 1
        offsetx = offsetx or 0
        offsety = offsety or 0
        width = width and width + 100 or 700*self.m_tFogData.visualRange/1.8
        height = height and height + 100 or 700*self.m_tFogData.visualRange/2.7
        local x, y = bullet:getPosition().x, bullet:getPosition().y
        WBattleGlobal:getCurrent():doCleanFog(x + offsetx, y + offsety, cleanType, width, height)
    end
end

--@brief 退出战斗场景时剧情对话
function WBattleGlobal:story()
    WZLog("WBattleGlobal:story")
    GlobalGame.m_nMapId = WBattleGlobal:getCurrent().m_tMakePairOk.mapId
    local result = nil
    if GDatatab_story_talk and WndTeachTalk:IsNoExist() and WBattleGlobal:getCurrent().m_bIsWin then
        for i ,v in pairs (GDatatab_story_talk) do
            if type(v.triggerWay) == "table" then
                WZLog("WBattleGlobal:story one",i,v.triggerWay[1][1],v.triggerWay[1][2],v.triggerWay[1][3],WBattleGlobal:getCurrent().m_tMakePairOk.mapId, tostring(WndTeachTalk:isStoryFinish(v.storyId)))
                if v.triggerWay[1][1] == TRIGGER_BATTLE_LEAVE and WndTeachTalk:isStoryFinish(v.storyId) ~= true and ((v.triggerWay[1][2] == COPYTYPE_SINGLE and WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_SINGLE) and v.triggerWay[1][3] == WBattleGlobal:getCurrent().m_tMakePairOk.mapId)
                or (v.triggerWay[1][2] == COPYTYPE_DAILY and WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_DAILY) and v.triggerWay[1][3] == WBattleGlobal:getCurrent().m_tMakePairOk.mapId)
                or (v.triggerWay[1][2] == COPYTYPE_TOWER and WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_TOWER) and v.triggerWay[1][3] == WBattleGlobal:getCurrent().m_tMakePairOk.mapId)
                or (v.triggerWay[1][2] == 4 and WBattleGlobal:getCurrent():isSingleStage() ~= true and WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS and v.triggerWay[1][3] == WBattleGlobal:getCurrent().m_tMakePairOk.mapId)
                ) then
                    WZLog("WBattleGlobal:story two")
                    result = false

                    GlobalGame.m_nStoryId = v.storyId

                    --CreateStoryTalkGroup(v.storyId, nil, nil, nil, nil, true)
                    break
                end
            end
        end
    end

    if WBattleGlobal:getCurrent().m_bIsWin then
        for i ,v in pairs (GDatatab_story_talk) do
            if type(v.triggerWay) == "table" then
                WZLog("WBattleGlobal:story three",i,v.triggerWay[1][1],v.triggerWay[1][2],v.triggerWay[1][3],WBattleGlobal:getCurrent().m_tMakePairOk.mapId, v.storyId)
                if (v.triggerWay[1][1] == TRIGGER_BATTLE_LEAVE) and ((v.triggerWay[1][2] == COPYTYPE_SINGLE and WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_SINGLE) and v.triggerWay[1][3] == WBattleGlobal:getCurrent().m_tMakePairOk.mapId)
                or (v.triggerWay[1][2] == COPYTYPE_DAILY and WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_DAILY) and v.triggerWay[1][3] == WBattleGlobal:getCurrent().m_tMakePairOk.mapId)
                or (v.triggerWay[1][2] == COPYTYPE_TOWER and WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_TOWER) and v.triggerWay[1][3] == WBattleGlobal:getCurrent().m_tMakePairOk.mapId)
                or (v.triggerWay[1][2] == 4 and WBattleGlobal:getCurrent():isSingleStage() ~= true and WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS and v.triggerWay[1][3] == WBattleGlobal:getCurrent().m_tMakePairOk.mapId)
                ) then
                    WZLog("WBattleGlobal:story four")
                    WndTeachTalk:setStoryFinish(v.storyId)
                end
            end
        end
    end
    return result
end

--@brief        根据服务器传过来的参数生成宝箱
--@param		所有宝箱信息
function WBattleGlobal:buildTreasure(idList, catchIdList)
	--idList = {2,6}

	self.m_nTreasureCountMax = #idList
	local left, right, up , down = BattleMapManager.m_nWidth/6,BattleMapManager.m_nWidth*(5/6),BattleMapManager.m_nHeight*(3/4),BattleMapManager.m_nHeight/3

	local id = {}
    local catchId = {}
	local nType = {}
    local effectId = {}
	local name = {}
	local icon = {}
    local lv = {}
	local posX = {}
	local posY = {}
	for i = 1,#idList do
		local prop = GDatatab_props["id_"..idList[i]]
		local skillId = 0
        local skillEffectId = 0
		local skillIcon = ""
        local skillLv = ""
        local skillName = ""
		for j, skillInfo in pairs (GDatatab_skill) do
			if skillInfo.id == prop.relation_id then
				skillId = skillInfo.id
				skillIcon = skillInfo.icon
                skillLv = skillInfo.lv_icon
                skillEffectId = skillInfo.effect_id[1][1]
                skillName = skillInfo.name
				break
			end
		end

		local randNumber1, randNumber2 = 0, 0
        local count = i
        local x1
        local y1
        while true do
            if WBattleGlobal:getCurrent().m_tBattleRand and #WBattleGlobal:getCurrent().m_tBattleRand > 0 then
                randNumber1 = WBattleGlobal:getCurrent().m_tBattleRand[count]
                randNumber2 = WBattleGlobal:getCurrent().m_tBattleRand[count+2 % 10 + 1]
            end

            local interval = math.abs(right - left)
            local interval2 = math.abs(up - down)
            x1 = left + randNumber1 % interval
            y1 = down + randNumber2 % interval2

            local length = 0

            if posX[1] then
                length = BattleCommon:pointDis(BattleCommon:getPointTable(x1, y1),BattleCommon:getPointTable(posX[1], posY[1]))
            end
            WZLog("WBattleGlobal:buildTreasure one",i, idList[i], left, right, up , down, interval, x1, y1, posX[1], posY[1], length)

            if count >= 7 or length > 94 or posX[1] == nil then
                break
            end
            count = count + 1
        end

        table.insert(catchId, catchIdList[i])
		table.insert(id, prop.id)
		table.insert(nType, skillId)
        table.insert(effectId, skillEffectId)
		table.insert(name, skillName)
		table.insert(icon, skillIcon)
        table.insert(lv, skillLv)
		table.insert(posX, x1)
		table.insert(posY, y1)
	end

    if self.m_tTreasureList ~= nil then
        for i, v in pairs (self.m_tTreasureList) do
            WZLog("WBattleGlobal:buildTreasure two", i, tostring(v.m_tSprite), tostring(v.m_sName))
            if v.m_tSprite ~= nil then
                v.m_tSprite:setVisible(false)
                v:destroy()
            end
        end
    end

	self.m_tTreasureList = {}
    self.m_tTreasureInfo = {}
    self.m_tTreasureInfo.id = id
    self.m_tTreasureInfo.effectType = nType
    self.m_tTreasureInfo.effectId = effectId
    self.m_tTreasureInfo.name = name
    self.m_tTreasureInfo.icon = icon
    self.m_tTreasureInfo.lv = lv
    self.m_tTreasureInfo.posX = posX
    self.m_tTreasureInfo.posY = posY

    local num = 1
    local pos = {}
    for i,v in ipairs(self.m_tTreasureInfo.id) do
        num = i
        local treasure = WTreasure:buildTreasure(self.m_tTreasureInfo.icon[num],self.m_tTreasureInfo.lv[num])
        treasure.m_nCatchId = catchId[num]
        treasure.m_nId = self.m_tTreasureInfo.id[num]
        treasure.m_nType = self.m_tTreasureInfo.effectType[num]
        treasure.m_nEffectId = self.m_tTreasureInfo.effectType[num]
        treasure.m_sName = self.m_tTreasureInfo.name[num]
        treasure.m_sIcon = self.m_tTreasureInfo.icon[num]
        treasure.m_sLv = self.m_tTreasureInfo.lv[num]

        pos = BattleCommon:getPointTable(self.m_tTreasureInfo.posX[num], self.m_tTreasureInfo.posY[num])
        treasure:setPosition(pos)

        WZLog("WTreasure:buildTreasure",treasure.m_sName,treasure.m_nId,treasure.m_nType,treasure.m_sIcon)
        table.insert(self.m_tTreasureList, treasure)
    end
end

--@brief        根据服务器传过来的参数生成宝箱
--@param        所有宝箱信息
function WBattleGlobal:buildErosionTreasure(idList, catchIdList, posList)
    --[[
    idList = {2,6}
    catchIdList = {1,2}
    --]]

    self.m_nTreasureCountMax = #idList
    local left, right, up , down = BattleMapManager.m_nWidth/6,BattleMapManager.m_nWidth*(5/6),
    BattleMapManager.m_nHeight*(3/4),BattleMapManager.m_nHeight/3
    if self.m_tErosionData.dir == 0 then
        local ex = self.m_tErosionData.erosionX + 33
        left = BattleMapManager.m_nWidth/6 > ex and BattleMapManager.m_nWidth/6 or ex
    else
        local ex = self.m_tErosionData.erosionX - 33
        right = BattleMapManager.m_nWidth*(5/6) < ex and BattleMapManager.m_nWidth*(5/6) or ex
    end

    local id = {}
    local catchId = {}
    local nType = {}
    local effectId = {}
    local name = {}
    local icon = {}
    local lv = {}
    local posX = {}
    local posY = {}
    for i = 1,#idList do
        local isExist = false
        if self.m_tTreasureList then
            for k,v in ipairs(self.m_tTreasureList) do
                if v.m_nCatchId == catchIdList[i] then
                    isExist = true
                end
            end
        end

        if isExist == false then

            local randNumber1, randNumber2 = 0, 0
            local count = i
            local x1
            local y1
            while true do
                if WBattleGlobal:getCurrent().m_tBattleRand and #WBattleGlobal:getCurrent().m_tBattleRand > 0 then
                    randNumber1 = WBattleGlobal:getCurrent().m_tBattleRand[count]
                    randNumber2 = WBattleGlobal:getCurrent().m_tBattleRand[(count+2) % 10 + 1]
                end

                local interval = math.abs(right - left)
                local interval2 = math.abs(up - down)
                x1 = left + randNumber1 % interval
                y1 = down + randNumber2 % interval2

                local length = 0
                local pos = BattleCommon:getPointTable(x1, y1)
                for j,v in ipairs(posX) do
                    length = BattleCommon:pointDis(pos, BattleCommon:getPointTable(v, posY[j]))
                    if length > 47 then
                        break
                    end
                end
                WZLog("WBattleGlobal:buildErosionTreasure one",i, count, length, #posX, "id", idList[i], left, right, up , down, interval, x1, y1, posX[1], posY[1], length)

                if count >= 7 or length > 47 or #posX == 0 then
                    break
                end
                count = count + 1
            end

            table.insert(catchId, catchIdList[i])
            table.insert(posX, x1)
            table.insert(posY, y1)
        end
    end

    self.m_tTreasureList = self.m_tTreasureList or {}
    local num = 1
    local pos = {}
    for i,v in ipairs(catchId) do
        num = i
        local treasure = WTreasure:buildTreasure()
        treasure.m_nCatchId = catchId[num]
        treasure.m_nId = 0--id[num]
        treasure.m_nType = 0--nType[num]
        treasure.m_nEffectId = 0--nType[num]
        treasure.m_sName = LocalStrings.ESCAPE_TREASURE or ""--name[num]
        treasure.m_sIcon = ""--icon[num]
        treasure.m_sLv = ""--lv[num]

        pos = BattleCommon:getPointTable(posX[num], posY[num])
        treasure:setPosition(pos)

        WZLog("WTreasure:buildErosionTreasure two", self.m_nTreasureCountMax,treasure.m_sName,treasure.m_nId,treasure.m_nType,treasure.m_sIcon)
        table.insert(self.m_tTreasureList, treasure)
    end
end

--@brief        根据服务器传过来的参数生成宝箱
--@param        所有宝箱信息
function WBattleGlobal:synchronousBuildErosionTreasure(idList, catchIdList, posList)
    self.m_nTreasureCountMax = #catchIdList

    if self.m_tTreasureList ~= nil then
        for i, v in ipairs (self.m_tTreasureList) do
            WZLog("WBattleGlobal:synchronousBuildErosionTreasure one", i, tostring(v.m_tSprite), tostring(v.m_sName))
            if v.m_tSprite ~= nil then
                v.m_tSprite:setVisible(false)
                v:destroy()
            end
        end
    end

    self.m_tTreasureList = {}
    local num = 1
    local pos = {}
    for i,v in ipairs(catchIdList) do
        num = i
        local treasure = WTreasure:buildTreasure()
        treasure.m_nCatchId = catchIdList[num]
        treasure.m_nId = 0--id[num]
        treasure.m_nType = 0--nType[num]
        treasure.m_nEffectId = 0--nType[num]
        treasure.m_sName = LocalStrings.ESCAPE_TREASURE or ""--name[num]
        treasure.m_sIcon = ""--icon[num]
        treasure.m_sLv = ""--lv[num]

        pos = BattleCommon:getPointTable(posList[num].x, posList[num].y)
        treasure:setPosition(pos)

        WZLog("WTreasure:synchronousBuildErosionTreasure two", self.m_nTreasureCountMax,posList[num].x,posList[num].y)
        table.insert(self.m_tTreasureList, treasure)
    end

end

--@brief        删除宝箱
function WBattleGlobal:destroyErosionTreasure(catchId)
    if self.m_tTreasureList ~= nil then
        for i, v in ipairs (self.m_tTreasureList) do
            WZLog("WBattleGlobal:destroyErosionTreasure one", i, tostring(v.m_tSprite), tostring(v.m_nCatchId), catchId)
            if v.m_tSprite ~= nil and v.m_nCatchId == catchId then
                v.m_tSprite:setVisible(false)
                v:destroy()
                return
            end
        end
    end
end

--@brief        生成宝箱
--@param        所有宝箱信息
function WBattleGlobal:buildBossTreasure(idList,tRect)
    if not idList or #idList == 0 then
        return
    end
    
    local rect = tRect or {x = 500,y = 1335,w = 1200,h = 750}
    
    local left, right, up , down = rect.x, rect.y, rect.w, rect.h


    self.m_nTreasureCountMax = #idList

    local posX = {}
    local posY = {}
    for i = 1,#idList do
        local randNumber1, randNumber2 = 0, 0
        local count = i
        local x1
        local y1
        while true do
            if WBattleGlobal:getCurrent().m_tBattleRand and #WBattleGlobal:getCurrent().m_tBattleRand > 0 then
                randNumber1 = WBattleGlobal:getCurrent().m_tBattleRand[count] and WBattleGlobal:getCurrent().m_tBattleRand[count] or math.random(9999)
                randNumber2 = WBattleGlobal:getCurrent().m_tBattleRand[count+2] and WBattleGlobal:getCurrent().m_tBattleRand[count + 2] or math.random(9999)
            end

            local interval = math.abs(right - left)
            local interval2 = math.abs(up - down)
            x1 = left + randNumber1 % interval
            y1 = down + randNumber2 % interval2

            local length = 0

            if posX[1] then
                length = BattleCommon:pointDis(BattleCommon:getPointTable(x1, y1),BattleCommon:getPointTable(posX[1], posY[1]))
            end
            WZLog("WBattleGlobal:buildTreasure one",i, idList[i], left, right, up , down, interval, x1, y1, posX[1], posY[1], length)

            if  length > 94 or posX[1] == nil then
                break
            end
            count = count + 1
        end
        table.insert(posX, x1)
        table.insert(posY, y1)
    end

    if self.m_tTreasureList ~= nil then
        for i, v in pairs (self.m_tTreasureList) do
            WZLog("WBattleGlobal:buildTreasure two", i, tostring(v.m_tSprite), tostring(v.m_sName))
            if v.m_tSprite ~= nil then
                v.m_tSprite:setVisible(false)
                v:destroy()
            end
        end
    end

    self.m_tTreasureList = {}

    local num = 1
    local pos = {}
    for i,v in ipairs(idList) do
        num = i
        local treasure = WBossTreasure:buildTreasure(v)

        pos = BattleCommon:getPointTable(posX[i], posY[i])
        treasure:setPosition(pos)
        WZLog("WTreasure:buildBossTreasure",treasure.m_sName,treasure.m_nId,treasure.m_nType,treasure.m_sIcon)
        table.insert(self.m_tTreasureList, treasure)
    end
end

--@brief ai数据重置
function WBattleGlobal:resetAIData()
    local chara = WBattleGlobal:getCurrent():getCurrentCharacter()
    
    for id,guai in pairs(WBattleGlobal:getCurrent():getGuaiList()) do
        if guai:getAI() == nil then
            guai:setAI(WNewMonsterAI:new(guai:getBattleId()))
            -- guai.m_bIsGuaiWithSuit = true
            -- guai.m_nAiType = MonsterAiType.AI_ROBOT
        end
        
        if guai.m_bIsGuaiWithSuit == true then
            if chara:getBattleId() == guai:getBattleId() then
                guai:getAI():startRound()
            end
        else
            guai:startRound()
        end
    end
    WZLog("WBattleGlobal:resetAIData", type(chara), chara:isRobot(), chara:getIsHero())
    if chara ~= nil and chara:isRobot() and chara:getIsHero() then
        if chara:getAI() == nil then
            chara:setAI( BattleAiCtrl:new( chara:getId() ) )
        end
        chara:getAI():startRound()
    end
end

--@brief	开始新的回合
function WBattleGlobal:startNewRound()
    self.m_bIsStartBattle = true
    WZLog("WBattleGlobal:startNewRound zero")
    if WBattleGlobal:getCurrent().m_nTurnTimes == 0 then
        self:setGuildSkill()
    end
    
    --组队副本秒杀
    -- for i,v in pairs(WBattleGlobal:getCurrent():getBossList()) do
    --     if v.m_nMonsterType == MonsterType.BOSS then
    --         v:setSacrifice(true)
    --     end
    -- end

    WndBattleHud.m_nUsePoint = 0
    BattleMsgPlayerMoveCtrl.m_nCurPositionX = nil
    BattleMsgPlayerMoveCtrl.m_nCurPositionY = nil
    WBattleGlobal:getCurrent():setDoEffectAfterAttack(nil,"startNewRound")
    self.m_tCurRoundSkillId = {}
	if self.m_tMakePairOk.skillHurt then
		if self.skillHurt_Encrypt then
			for i=1,#self.m_tMakePairOk.skillHurt do
                self:checkIsCheat(self.m_tMakePairOk.skillHurt[i],self.skillHurt_Encrypt[i],1)
			end
		else
			self.skillHurt_Encrypt = {}
			for i=1,#self.m_tMakePairOk.skillHurt do
				self.skillHurt_Encrypt[i] = BattleCommon:intEncrypt(self.m_tMakePairOk.skillHurt[i])
			end
		end
	end
	
	self:checkIsCheat(self.m_nTurnTimes,self.m_nTurnTimes_Encrypt,2)
	self.m_nTurnTimes = self.m_nTurnTimes + 1
	self.m_nTurnTimes_Encrypt = BattleCommon:intEncrypt(self.m_nTurnTimes)
	if true or self:isNewRound() then
		--self:checkIsCheat(self.m_nTurnTimes,self.m_nTurnTimes_Encrypt,2)
		--self.m_nTurnTimes = self.m_nTurnTimes + 1
		--self.m_nTurnTimes_Encrypt = BattleCommon:intEncrypt(self.m_nTurnTimes)

        if WBattleGlobal:getCurrent():isSingleStage() then
            self.m_nRecordRound = self.m_nRecordRound + 1
            if self.m_copyData then
                self.m_copyData:updateByTurn()
            end
            
            self.m_nIsEndCurThisTurnWithDead = nil
            -- local turnTimes = WBattleGlobal:getCurrent().m_nTurnTimes
            -- local myHero = WBattleGlobal:getCurrent():getMyHero()
            -- local guaiList = WBattleGlobal:getCurrent():getGuaiList()
            -- local guaiHpList = {}
            -- local guaiSkillHurtList = {}
            -- local guaiIsHoleList = {}
            -- local guaiIsBigSkillList = {}
            -- local guaiHurtWithPetList = {}
            -- local guaiHurtWithPlayerList = {}
            -- local guaiHurtWithGuaiList = {}
            -- for i, v in pairs(guaiList) do
            --     table.insert(guaiHpList, v:getHp())
            --     table.insert(guaiIsHoleList, false)
            --     table.insert(guaiSkillHurtList, 0)
            --     table.insert(guaiIsBigSkillList, false)
            --     table.insert(guaiHurtWithPetList, 0)
            --     table.insert(guaiHurtWithPlayerList, 0)
            --     table.insert(guaiHurtWithGuaiList, 0)
            -- end
            -- if turnTimes > 1 and WBattleGlobal:getCurrent().m_tBattleRecord[turnTimes - 1] ~= nil then
            --     local recordPre = WBattleGlobal:getCurrent().m_tBattleRecord[turnTimes - 1]
            --     recordPre.pf = 100 - myHero:getPF()
            --     recordPre.playerHp = myHero:getHp()
            --     recordPre.guaiHp = guaiHpList

            -- end

            -- WBattleGlobal:getCurrent().m_tBattleRecord[turnTimes] = {}
            -- WZLog("WBattleGlobal:startNewRound record-0",tostring(WBattleGlobal:getCurrent().m_tBattleRecord.myTurnCount or 0), tostring(self:isMyTurn() == true and 1 or 0))
            -- WBattleGlobal:getCurrent().m_tBattleRecord.myTurnCount = (WBattleGlobal:getCurrent().m_tBattleRecord.myTurnCount or 0) + (self:isMyTurn() == true and 1 or 0)
            -- local record = WBattleGlobal:getCurrent().m_tBattleRecord[turnTimes]
            -- record.turn = turnTimes
            -- record.isMyturn = self:isMyTurn()
            -- record.skillProp = {}
            -- record.bulletCount = 0
            -- record.pf = 0
            -- record.playerHp = myHero:getHp()
            -- record.playerHurt = 0
            -- record.guaiHp = guaiHpList
            -- record.guaiIsHole = guaiIsHoleList
            -- record.playerSkillHurt = 0
            -- record.guaiSkillHurt = guaiSkillHurtList
            -- record.bulletHitCount = 0
            -- record.isCritical = 0
            -- record.isPlayerBigSkill = false
            -- record.isGuaiBigSkill = guaiIsBigSkillList
            -- record.guaiHurtWithPet = guaiHurtWithPetList
            -- record.guaiHurtWithPlayer = guaiHurtWithPlayerList
            -- record.guaiHurtWithGuai = guaiHurtWithGuaiList

            -- WZLog("WBattleGlobal:startNewRound record-1", self.m_nTurnTimes, record.isMyturn,WBattleGlobal:getCurrent().m_tBattleRecord.myTurnCount, json.encode(WBattleGlobal:getCurrent().m_tBattleRecord))

            --战斗记录
            self:setCtbBeingRecord()
            self:setPlayerIdRecord()

        end

	end


	if self:getCurrentCharacter() ~= nil then
		self:getCurrentCharacter():updateByTurn()
	end

    for id, character in pairs (self:getCharacterList()) do
        character:updateByCTB()
        character.m_nRecordRatio = 1 
    end

    BattlePetSkillManager:updateByTurn()
	BattleHeroUse:update()
    self.m_bIsCurTurnActed = nil
    self.m_nCheckNoHoleIndex = 1

    for id,hero in pairs (WBattleGlobal:getCurrent():getHeroList()) do
        if hero:getUseBigSkill() == true then
            hero:removeAngerAnimation()
        end
    end

    Teach:isStartTeach("WBattleGlobal:startNewRound")

    --WZLog("WBattleGlobal:startNewRound zero", tostring(self.m_nTurnTimes), tostring(GlobalGame.g_isOpenMapEvent), tostring(self:isNewRound()), tostring(WBattleGlobal:getCurrent():getBattleType()), tostring(BattleConstants.g_nBATTLE_TYPE_NORMAL), tostring(WBattleGlobal:getCurrent():getCurrentCharacter():isCanControl()))
    --地图事件
    local isLocalMapEvent = true
    if isLocalMapEvent and self.m_nTurnTimes > 1 and GlobalGame.g_isOpenMapEvent == true and self:isNewRound() and WBattleGlobal:getCurrent():getBattleType() == BattleConstants.g_nBATTLE_TYPE_NORMAL and WBattleGlobal:getCurrent():getCurrentCharacter():isCanControl() then
        ProtocolProcessorSceneBattle:send_BATTLE_GetEventInfo(WBattleGlobal:getCurrent().m_tMakePairOk.battleId)

    elseif (not isLocalMapEvent) and self:isNewRound() then
    
        local weatherId, name, effect1, effect2 = 2, "", -1, 0
        --地图事件
        if WBattleGlobal:getCurrent().m_tMapEvents ~= nil and #WBattleGlobal:getCurrent().m_tMapEvents > 0  then
            for i, event in pairs(WBattleGlobal:getCurrent().m_tMapEvents) do
                event:destroy()
            end
        end
        WBattleGlobal:getCurrent().m_tMapEvents = nil

        if WBattleGlobal:getCurrent().m_tMapEvents == nil then
            WBattleGlobal:getCurrent().m_tMapEvents = {}
        end
        
        if weatherId == MapEnenvtTornado.ID then
            local mapEvent = MapEnenvtTornado:buildEvent(weatherId, name, effect1, effect2)
            if mapEvent ~= nil then
                table.insert(WBattleGlobal:getCurrent().m_tMapEvents, mapEvent)
            end
        elseif weatherId == MapEnenvtLava.ID then
            local mapEvent = MapEnenvtLava:buildEvent(weatherId, name, effect1, effect2)
            if mapEvent ~= nil then
                table.insert(WBattleGlobal:getCurrent().m_tMapEvents, mapEvent)
            end

        elseif weatherId == MapEnenvtMeteorite.ID then
            local mapEvent = MapEnenvtMeteorite:buildEvent(weatherId, name, effect1, effect2)
            if mapEvent ~= nil then
                table.insert(WBattleGlobal:getCurrent().m_tMapEvents, mapEvent)
            end
        elseif weatherId == MapEnenvtBubble.ID then
            local mapEvent = MapEnenvtBubble:buildEvent(weatherId, name, effect1, effect2)
            if mapEvent ~= nil then
                table.insert(WBattleGlobal:getCurrent().m_tMapEvents, mapEvent)
            end
        end

        --清除地图事件状态
        if WBattleGlobal:getCurrent().m_tMapEvents ~= nil and #WBattleGlobal:getCurrent().m_tMapEvents > 0  then
            for i, event in pairs(WBattleGlobal:getCurrent().m_tMapEvents) do
                event:clearState()
            end
        end

    end

    self.m_nSkillBeUseCurRound = nil
    self.m_tExplodeInfoCurRound = {}
    self.m_tBuffInfoCurRound = {}
    self.m_nPetAttackHurtCurRound = nil
    self.m_tReceiveDeadPlayerId = nil

    GlobalGame:getBattleEventDispatcher():Dispatch(BATTLE_EVENT_TYPE.PALYER_ATT_ROUND_UPDATE)
    if AutoRunBattleConst.AUTO_RUN_BATTLE then
        local msg = MsgManager:createMsg(BattleMsgAutoRunRound)
        MsgManager:pushBlockMsg(msg)
    end

    if WBattleGlobal:getCurrent().m_nMyRemainHp == -1 then
        WBattleGlobal:getCurrent().m_nMyRemainHp = WBattleGlobal:getCurrent():getMyHero():getMaxHp()
    end
    -- GlobalGame:getGameEventDispathcer():Dispatch("BattleRound_Change")
    --self:buildTreasure()
  
    self:battleMachineStartRound()
    --场景buff
    self:checkHurtBuffTotem()
end

--@brief 机关道具回合开始逻辑
function WBattleGlobal:battleMachineStartRound()
    for id, character in pairs (self:getMachinesList()) do
        if character.m_nMonsterType == MonsterType.BOSS_FIRE or character.m_nMonsterType == MonsterType.BOSS_CAGE 
            or character.m_nMonsterType == MonsterType.BOSS_MAGMA  or character.m_nMonsterType == MonsterType.BOSS_POISON then
            character:checkCollision()
        end
    end

    --检查副本5聚光灯逻辑
    self:checkMachineLight()
end

--@brief 检查图腾碰撞
function WBattleGlobal:checkHurtBuffTotem()
    WZLog("WBattleGlobal:checkHurtBuffTotem")
    local buffList = {}
    local heroList = {}

    for id, character in pairs (self:getCharacterList()) do
        if not character:isDead() then
            local totemId,totemLv = character:getHurtBuffTotemInfo()
            if totemId > 0 then
                heroList[character:getBattleId()] ={buffId = totemId,buffLv = totemLv}
            end
        end
    end

    for id, character in pairs (self:getMachinesList()) do
        if not character:isDead() and character.m_nMonsterType == MonsterType.BUFF_TOTEM then
            local list = character:checkBuffTotemCollison()
            local buffId,buffLv = character:getBuffInfo()
            for _,hero in ipairs(list) do
                if not buffList[hero:getBattleId()] or buffList[hero:getBattleId()].buffLv < buffLv then
                    buffList[hero:getBattleId()] = {buffId = buffId,buffLv = buffLv}
                end
            end
        end
    end
    local offList = {}
    for id, info in pairs(heroList) do
        local tInfo = buffList[id]
        local off = true
        if tInfo and info.buffLv <= tInfo.buffLv then
            off = false
        end
        if off then
            offList[id] = info
        end
        
    end
    if GetTableLen(offList) > 0 then
         self:removeBuffTotemEffect(offList)
    end

    local addList = {}
    for id,info in pairs(buffList) do
        local tInfo = heroList[id]
        local add = true
        if tInfo and info.buffLv == tInfo.buffLv then
            add = false
        end
        if add then
            addList[id] = info
        end
    end

    if GetTableLen(addList) > 0 then
        self:addBuffTotemEffect(addList)
    end

end

--@brief 添加buff图腾影响
function WBattleGlobal:removeBuffTotemEffect(infoList)
    local list = self:getMachinesSortList()
    if #list <= 0 then
        return
    end
    local userId = list[1]:getBattleId()

    for id,info in pairs(infoList) do
        WZLog("WBattleGlobal:removeBuffTotemEffect",id,info.buffId)
        local hero = self:getCharacterWithId(id)
        self:removeHeroBuffById(userId,hero,info.buffId)
    end
end

--@brief 移除buff图腾影响
function WBattleGlobal:addBuffTotemEffect(infoList)
    local list = self:getMachinesSortList()
    if #list <= 0 then
        return
    end
    local userId = list[1]:getBattleId()

    for id,info in pairs(infoList) do
        WZLog("WBattleGlobal:addBuffTotemEffect",id,info.buffId)
        self:addBuff({self:getCharacterWithId(id)},info.buffId,userId)
        if WBattleGlobal:getCurrent():isHostControl() then
            ProtocolProcessorSceneBattle:send_BATTLE_BuffChange(WBattleGlobal:getCurrent():getBattleId(), userId, 0, info.buffId, {id})
        end
    end
end

function WBattleGlobal:removeHeroBuffById(userId,hero,buffId)
    if hero and not hero:isDead() then
        for id,buff in pairs (hero.m_tBuffChangeStateList) do
            if buff.m_nID == buffId then
                hero:removeBuffSpecialInfluence(buff)
                buff:removeAnime()
                hero.m_tBuffChangeStateList[id] = nil
                break
            end
        end

        if WBattleGlobal:getCurrent():isHostControl() then
            ProtocolProcessorSceneBattle:send_BATTLE_BuffChange(WBattleGlobal:getCurrent():getBattleId(), userId, 1, buffId, {hero:getBattleId()})
        end
    end
end

--=====================================个人副本关键点记录begin========================================================
--@brief    获取当前ctb记录
function WBattleGlobal:getCurrentRecord()
    if not WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent():isReplayGame() then
        return 
    end
    WZLog("WBattleGlobal:getCurrentRecord",self.m_nTurnTimes)
    local totalRecord = WBattleGlobal:getCurrent().m_tBattleRecord
    
    if not totalRecord[self.m_nRecordRound] then
        totalRecord[self.m_nRecordRound] = {}
    end
    return totalRecord[self.m_nRecordRound]
end

--@brief    获取当前伤害记录
function WBattleGlobal:getCurrentHurtRecord(battleId)
    if not WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent():isReplayGame() then
        return 
    end
    --机关类 不作伤害检验
    if self.m_tMachines[battleId] then
        return nil
    end

    local record = self:getCurrentRecord()
    if not record.hurtRecord then
        record.hurtRecord = {}
    end
    if not record.hurtRecord[battleId] then
        record.hurtRecord[battleId] = {}
    end

    return record.hurtRecord[battleId]
end

--@brief    设置开始ctb,hp
--@ ctbBeginRecord = {battleId:nowCTB , ...}
--@ hpBeginRecord = {battleId:nowHp , ...}
function WBattleGlobal:setCtbBeingRecord()
    if not WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent():isReplayGame() then
        return
    end

    local record = self:getCurrentRecord()
   
    local hero = self:getCurrentHero()
    if hero then
        record.ctbBeginRecord = hero.m_nNowCTB
        WZLog("WBattleGlobal:setCtbBeingRecord",hero:getBattleId())
    else
        record.ctbBeginRecord = 10000
    end
end

--@brief    设置结束ctb,hp
--@ ctbEndRecord = {battleId:nowCTB , ...}
--@ hpEndRecord = {battleId:nowHp , ...}
function WBattleGlobal:setCtbEndRecord()
    if not WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent():isReplayGame() then
        return
    end

    local record = self:getCurrentRecord()
    
    local hero = self:getCurrentHero()
    if hero then
        if not record.ctbEndRecord then
            record.ctbEndRecord = hero.m_nNowCTB
            WZLog("WBattleGlobal:setCtbEndRecord",hero:getBattleId())
        end
    else
        record.ctbEndRecord = 6000
    end
    -- WZLog("WBattleGlobal:setCtbEndRecord",hero.m_nNowCTB,record.ctbEndRecord)
end

--@brief    设置过程ctb
--@ ctbProRecord = {battleId:costCtb , ...}
function WBattleGlobal:setCtbProRecord(battleId,costCtb)
    if not WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent():isReplayGame() then
        return
    end

    local record = self:getCurrentRecord()
    
    local hero = self:getCurrentHero()
    if hero then
        if hero:getBattleId() == battleId then
            if not record.ctbCostRecord then
                record.ctbCostRecord = costCtb
            else
                record.ctbCostRecord = record.ctbCostRecord + costCtb
            end
        end
    else
        record.ctbCostRecord = 0
    end
end

--@brief    设置过程hp
--@ hpProRecord = {battleId:hurtHp , ...}
function WBattleGlobal:setHpProRecord(battleId,hurtHp,tShootHero,hitRatio)
    if not WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent():isReplayGame() then
        return
    end
    WZLog("WBattleGlobal:hitRatio",tostring(battleId),tostring(hitRatio),tostring(hurtHp))
    local hurtRecord = self:getCurrentHurtRecord(battleId)
    if not hurtRecord then
        return
    end

    if not hurtRecord.playerAdd then
        hurtRecord.playerAdd = 0
    end
    if not hurtRecord.playerHurts then
        hurtRecord.playerHurts = {}
    end
    -- if not hurtRecord.scores then
    --     hurtRecord.scores = 0
    -- end
    if hurtHp < 0 then
        -- hurtRecord.scores = hurtRecord.scores + 1
        
        local shooter = tShootHero or self:getCurrentCharacter()
        local shootId = shooter:getBattleId()
        local hurtRatio = hitRatio and hitRatio * 100 or 100
        -- local hero = self:getCharacterWithId(battleId)
        -- if hero then
        --     -- local beHurtRatio = hero:getBeHurtAddPercent() and (100 + hero:getBeHurtAddPercent() * 100) or 100
        --     -- hurtRatio = shooter.m_nRecordRatio * beHurtRatio
        --     hurtRatio = shooter.m_nRecordRatio
        -- end
        local hurter = WBattleGlobal:getCurrent():getCharacterWithId(battleId)
        local reverRatio = hurter and hurter:getHurtReverseRatio()  or 0
        WZLog("WBattleGlobal:hurtRatio-3",reverRatio)
        hurtRatio = hurtRatio*(1 + reverRatio)
        local hurtInfo = {}
        hurtInfo.shootId = shootId
        hurtInfo.hurtHp = hurtHp or 0
        hurtInfo.hurtRatio = hurtRatio or 100
        --计算固定伤害
        local hurtAdd = 0
        hurtAdd = hurtAdd + (shooter:getHurtAddValue() or 0)
        hurtAdd = hurtAdd + (hurter:getBeHurtAddValue() or 0)
        if WBullet:getHurtType(shooter,hurter) > 0  then
            hurtAdd = hurtAdd + (shooter:getCritHurtAddValue() or 0)
            hurtAdd = hurtAdd + (hurter:getBeCritHurtAddValue() or 0)
        end 
       
        --固定伤害加上反转加成
        hurtInfo.hurtAdd = hurtAdd *(1 + reverRatio)
        table.insert(hurtRecord.playerHurts,hurtInfo)
    elseif hurtHp > 0 then
        hurtRecord.playerAdd = hurtRecord.playerAdd + hurtHp
    end

    WBattleGlobal:getCurrent():setMyRemainHp(battleId,hurtHp)
end

function WBattleGlobal:setMyRemainHp(battleId,hp)
    if battleId == WBattleGlobal:getCurrent():getMyBattleId() then
        WBattleGlobal:getCurrent().m_nMyRemainHp = WBattleGlobal:getCurrent().m_nMyRemainHp + hp
        if WBattleGlobal:getCurrent().m_nMyRemainHp < 1 then
            WBattleGlobal:getCurrent().m_nMyRemainHp = 1
        elseif WBattleGlobal:getCurrent().m_nMyRemainHp > WBattleGlobal:getCurrent():getMyHero():getMaxHp() then
            WBattleGlobal:getCurrent().m_nMyRemainHp = WBattleGlobal:getCurrent():getMyHero():getMaxHp()
        end
        WZLog("WBattleGlobal:setMyRemainHp",WBattleGlobal:getCurrent().m_nMyRemainHp)
    end
end

--@brief    设置过程hp
--@ petHpProRecord = {battleId:hurtHp , ...}
function WBattleGlobal:setPetHpProRecord(battleId,hurtHp,hurtRatio)
    WZLog("setPetHpProRecord",battleId,hurtHp,hurtRatio)
    if not WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent():isReplayGame() then
        return
    end

    local hurtRecord = self:getCurrentHurtRecord(battleId)
    if not hurtRecord then
        return
    end

    if not hurtRecord.petHurt then
        hurtRecord.petHurt = 0
        hurtRecord.petRatio = hurtRatio * 100
    end
    hurtRecord.petHurt = hurtRecord.petHurt + hurtHp

    WBattleGlobal:getCurrent():setMyRemainHp(battleId,hurtHp)
end

--@brief    设置buff伤害记录
--@ buffHurtRecord = {battleId = {buffId:hurt , ...} , ...}
function WBattleGlobal:setBuffHurt(battleId,buffId,hurt)
     if not WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent():isReplayGame() then
        return
     end
     --反转伤害加血
     -- if hurt > 0 then
     --    WZLog("WBattleGlobal:setBuffHurt-one",hurt)
     --    self:setHpProRecord(battleId,hurt)
     --    return
     -- end
     local hurtRecord = self:getCurrentHurtRecord(battleId)
     if not hurtRecord then
         return
     end

     if not hurtRecord.buffHurt then
         hurtRecord.buffHurt = 0
     end
     hurtRecord.buffHurt = hurtRecord.buffHurt + hurt
     WZLog("WBattleGlobal:setBuffHurt-two",hurtRecord.buffHurt)
     WBattleGlobal:getCurrent():setMyRemainHp(battleId,hurt)
end

--@brief    设置伤害暴击,伤害附加
--@ hpProRecord = {battleId:hurtHp , ...}
function WBattleGlobal:setHitParamRecord(critRate,addHurt)
     if not WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent():isReplayGame() then
        return
    end

    local record = self:getCurrentRecord()
    if not record.critRate then
        record.critRate = critRate
    end
    if not record.addHurt then
        record.addHurt = addHurt or 0
    end
end

--@brief 设置生成怪物记录
function WBattleGlobal:setBuildMonsterRecord(battleId,id)
     if not WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent():isReplayGame() then
        return
    end

    if not self.m_tBuildMonsterRecord then
        self.m_tBuildMonsterRecord = {}
    end
    self.m_tBuildMonsterRecord[battleId] = id
end

--@brief 设置坑杀怪物记录
--@ holeMonsterRecord
function WBattleGlobal:setHoldMonsterRecord(battleId)
    if not WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent():isReplayGame() then
        return
    end

     if not self.m_tHoleMonsterRecord then
        self.m_tHoleMonsterRecord = {}
    end
    
    if not self.m_tHoleMonsterRecord[self.m_nRecordRound] then
        self.m_tHoleMonsterRecord[self.m_nRecordRound] = {}
    end
    table.insert(self.m_tHoleMonsterRecord[self.m_nRecordRound],battleId)
end

--@brief    设置操作玩家id记录
--@ currentPlayer = battleId
function WBattleGlobal:setPlayerIdRecord()
    if not WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent():isReplayGame() then
        return
    end

   local record = self:getCurrentRecord()
   record.currentPlayer = self.m_nCurrentPlayerId
end

--@brief 设置战斗对象使用技能
-- skills = {skillId , ...}
function WBattleGlobal:setSkillIdRecord(skillId)
     if not WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent():isReplayGame() then
        return
    end
    local skillInfo = GDatatab_skill["id_"..skillId]
    if not skillInfo then
        return
    end

    local effectList = skillInfo.effect_id[1]
    local atkTimes = 1
    local atkNum = 1
    local atkAddNum = 0
    local isChange = false
    for i,v in pairs(effectList) do 
        if v ~= -1 then
            local effectParm = EffectConfig["id_"..v].effect
            for k,effectInfo in pairs(effectParm) do 
                local effectType = effectInfo[3] .. "_" .. effectInfo[4]
                if effectType == EffectTypeConfig.SCATTER_SHOOT then
                    atkNum = effectInfo[5]
                    isChange = true
                end
                if effectType == EffectTypeConfig.TIMES_SHOOT then
                    atkTimes = effectInfo[5]
                    isChange = true
                end
                if effectType == EffectTypeConfig.SPATTER then
                    atkAddNum = effectInfo[5]
                    isChange = true
                end
            end
        end
    end
    if isChange then
        self:setBulletConfigNum(atkNum*atkTimes + atkAddNum)
    end
end


--@brief 设置炸弹数量
--@ bulletsConfig = bulletNum
function WBattleGlobal:setBulletConfigNum(bulletNum)
    if not WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent():isReplayGame() then
        return
    end

    local record = self:getCurrentRecord()
    record.bulletsConfig = bulletNum 
end

--@brief 设置炸弹数量
--@ bullets = bulletNum
function WBattleGlobal:setBulletNum(bulletNum)
    if not WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent():isReplayGame() then
        return
    end

    local record = self:getCurrentRecord()
    if not record.bullets then
        record.bullets = 0
    end
    record.bullets = record.bullets + bulletNum
end

--=====================================个人副本关键点记录end========================================================
--@brief 
--加buff
function WBattleGlobal:addBuff(targetHeroList,buffId,userId,buffAtk)
    WZLog("WBattleGlobal:addBuff one", buffId,userId)
    
    --do return end
    local buffInfo = GDatatab_buff["id_"..buffId]
    buffInfo.buffAtk = buffAtk or 0
    local buffAdd = nil
    for id, hero in pairs (targetHeroList) do
        if hero:isDead() ~= true then
            local buffNew = BuffBody:new(buffInfo,hero, userId)
            local buffExistIndex = nil
            local buffExist = nil
            local isNext = false
            for index, buff in pairs (hero.m_tBuffChangeStateList) do 
                if buffNew.m_nType == buff.m_nType then
                    --buff存在 分两种情况 1不用替换(不用替换直接跳出) 2替换
                    if buffNew.m_nLv < buff.m_nLv or (buffNew.m_nLv == buff.m_nLv and buffNew.m_nTurnTime == buff.m_nTurnTime) then
                        isNext = true
                        break
                    else
                        buffExistIndex = index
                        buffExist = buff
                        break
                    end
                end
            end
            if not isNext then
                --免疫冰冻等
                local offBuff = false
                if hero.m_bOffFrozen then
                    local immunizeList = {EffectTypeConfig.LIMIT_MOVE, EffectTypeConfig.LIMIT_FLY, EffectTypeConfig.LIMIT_USE_SKILL, EffectTypeConfig.LIMIT_USE_ITEM, EffectTypeConfig.LIMIT_ALL_ACTION, EffectTypeConfig.LIMIT_VISIBLE}
                    for id, effectParm in pairs (buffNew.m_nEffect) do
                        local effect = effectParm[3] .. "_" ..effectParm[4]
                        for id, effectType in pairs (immunizeList) do
                            if effect == effectType then
                                -- buffExist = buffNew
                                offBuff = true
                                WZLog("WBattleGlobal:addBuff offBuff", effectType)
                            end
                        end
                    end
                end

                if TeachGroup1.ISFIRSTBATTLE then
                    offBuff = true
                end

                if not offBuff then
                    WZLog("WBattleGlobal:addBuff three-0", tostring(buffExistIndex), buffNew.m_nEffect)
                    if buffExistIndex then
                        table.remove(hero.m_tBuffChangeStateList, buffExistIndex)
                        buffExist:removeAnime()
                    end
                    buffNew:addAnime()
                    table.insert(hero.m_tBuffChangeStateList, buffNew)
                    buffAdd = buffNew
                end
            end
        end
    end
    return buffAdd
end

--@brief	设置公会技能
function WBattleGlobal:setGuildSkill()
    WZLog("WBattleGlobal:setGuildSkill zero")
    do return end
    local playerInfo = CacheCenter:getPlayerInfo()
    local buff = playerInfo.buff
    local hero = WBattleGlobal:getCurrent():getMyHero()

    hero.m_nTreatAddition = 0
    hero.m_nMoveRate = 100
    if buff == nil or buff == "" then
        return
    else
        local buffTable = json.decode(buff)
        WZLog("WBattleGlobal:setGuildSkill two", tostring(buffTable), buff)
        if buffTable ~= nil then
            for i=1,#buffTable do
                local buffCode = buffTable[i].buffCode
                WZLog("WBattleGlobal:setGuildSkill three", tostring(buffCode))
                if buffCode == "ctreat" then
                    hero.m_nTreatAddition = hero.m_nTreatAddition + buffTable[i].quantity
                    WZLog("WBattleGlobal:setGuildSkill four", tostring(buffTable[i]), hero.m_nTreatAddition)
                elseif buffCode == "cpowerlow" then
                    hero.m_nMoveRate = hero.m_nMoveRate + buffTable[i].quantity
                    WZLog("WBattleGlobal:setGuildSkill five", tostring(buffTable[i]), hero.m_nMoveRate)
                end
            end
        end
    end

end

--@brief 是否录像
function WBattleGlobal:isReplayGame()
    -- WZLog("WBattleGlobal:isReplayGame",tostring(WBattleGlobal:getCurrent().m_bIsReplayGame))
   return WBattleGlobal:getCurrent().m_bIsReplayGame
end

function WBattleGlobal:canRecordGame()
    if not WBattleGlobal:getCurrent().m_bIsReplayGame and WBattleGlobal:getCurrent():isSingleStage() then
        return true
    else
        return false
    end
end

--@brief 是否观众
function WBattleGlobal:isAudience()
    -- WZLog("WBattleGlobal:m_bIsAudience",tostring(WBattleGlobal:getCurrent().m_bIsAudience))
   return WBattleGlobal:getCurrent().m_bIsAudience
end

--@brief 是否公会战
function WBattleGlobal:isGuildWarStage()
    local battleType = WBattleGlobal:getCurrent().m_nBattleType
    local battleChannle = WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle
    if battleType == BattleConstants.g_nBATTLE_TYPE_NORMAL then
        if battleChannle == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_GZ then
            return true
        end
    end
    return false
end

--@brief 是否竞技经验相关副本
function WBattleGlobal:isArenaStage()
    local battleType = WBattleGlobal:getCurrent().m_nBattleType
    local battleChannle = WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle
    local battleMode = WBattleGlobal:getCurrent().m_tMakePairOk.battleMode
    if battleType == BattleConstants.g_nBATTLE_TYPE_NORMAL then
        if battleChannle == GlobalGame.g_tRoomChannel.BATTLE_MODE_JJ or
        battleChannle == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL or
        battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_LD then 
            return true
        end
    end
    return false
end

function WBattleGlobal:isArenaPWStage()
    local battleType = WBattleGlobal:getCurrent().m_nBattleType
    local battleChannel = WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle
    
    if battleType == BattleConstants.g_nBATTLE_TYPE_NORMAL then
        return battleChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_PW
    end
    return false

end

--@brief 是否公会副本
function WBattleGlobal:isGuildBossStage()
    if self.m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS and self:getBattleMode() == BattleConstants.g_tBossBattleMode.MODEL_GUILD_STATE then
        return true
    end
    return false
end

--@brief	是否正在玩单人副本
function WBattleGlobal:isSingleStage(mode)
    WZLog("WBattleGlobal:isSingleStage", self.m_nBattleType, self:getBattleMode())
    local battleMode = WBattleGlobal:getCurrent().battleMode
    local isSingle = self:getBattleMode() == BattleConstants.g_tBossBattleMode.MODE_SINGLE_STAGE or  self:getBattleMode() == BattleConstants.g_tBossBattleMode.MODE_NORMAL_HARD or self:getBattleMode() == BattleConstants.g_tBossBattleMode.MODE_NORMAL_TABOO
    local isDaily =  self:getBattleMode() == BattleConstants.g_tBossBattleMode.MODE_DAILY_STAGE 
    local isTower =  self:getBattleMode() == BattleConstants.g_tBossBattleMode.MODE_TOWER_STAGE
    local isTrain =  self:getBattleMode() == BattleConstants.g_tBossBattleMode.MODE_TRAIN_STAGE

    if self.m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS and (isSingle or isDaily or isTower or isTrain) then
        if mode == nil then
        	return true
        elseif mode == COPYTYPE_SINGLE and isSingle then
        	return true
        elseif mode == COPYTYPE_DAILY and isDaily then
        	return true
        elseif mode == COPYTYPE_TOWER and isTower then
        	return true
        elseif mode == COPYTYPE_TRAIN and isTrain then
            return true
        end

    end
    return false
end

--@brief 是否组队副本
function WBattleGlobal:isTeamStage()
    if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS and WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_BOSSMAP_2 then
        return true
    end
    return false
end

--@brief 是否世界Boss副本
function WBattleGlobal:isWorldBossStage()
    if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS and WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_WORLDBOSS then
        return true
    end
    return false
end

--@brief    是否可以激活幽灵模式
function WBattleGlobal:isGhostStage()
    -- body
    do return WBattleGlobal:getCurrent().m_bIsGhost end
    local battleType = WBattleGlobal:getCurrent().m_nBattleType
    local battleChannle = WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle
    local battleMode = WBattleGlobal:getCurrent().m_tMakePairOk.battleMode

    local sGhostConfig = CacheCenter:getGameParam().ghostConfig 
    local tGhostConfig = json.decode(sGhostConfig)
    local bOpenGhostMode = false 

    if tGhostConfig.openMode == nil or tGhostConfig.openMode == "" or tGhostConfig.openMode == "-1" then 
        return bOpenGhostMode
    end

    local array = SplitStringWithSeparator(tGhostConfig.openMode,"&")
    if battleType == BattleConstants.g_nBATTLE_TYPE_NORMAL then
        for i = 1, #array do
            local string = string.sub(array[i],2,-2) 
            local tData = SplitStringWithSeparator(string,",", nil, true)
            WZLog("WBattleGlobal:isGhostStage 0000", Serialize(tData))
            if tData[1] == battleChannle then 
                if tData[2] == 0 then 
                    bOpenGhostMode = true
                    break 
                else
                    for i = 2, #tData do
                        if tData[i] == battleMode then 
                            bOpenGhostMode = true
                            break
                        end
                    end
                end
            end
            if bOpenGhostMode then 
                break 
            end
        end
    end

    WZLog("WBattleGlobal:isGhostStage", bOpenGhostMode)
    return bOpenGhostMode
end

--@brief    是否英雄塔副本
function WBattleGlobal:isHeroTowerStage()
    local battleChannle = WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle
    if battleChannle == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YXT then
        return true
    end
    return false
end
    
--@brief	设置单人副本过关条件
--@param	nCleanType:触发类型,
--@param	tIdList:参数1,
function WBattleGlobal:setCleanCondition(nCleanType, tIdList)
    if self.m_tCleanConditionList == nil then
        self.m_tCleanConditionList = {}
    end
    
    table.insert(self.m_tCleanConditionList, {nCleanType, tIdList})
    
    if nCleanType == SingleChallengeCleanCondition.TYPE_GUAI_DESTROY then
        self.m_bIsCleanWithGuaiDestroy = true
        self.m_tGuaiDestroyList =  tIdList
    elseif nCleanType == SingleChallengeCleanCondition.TYPE_HOLE_GUAI then
        self.m_bIsCleanWithHoleGuai = true
        self.m_tHoleGuaiList =  tIdList
    end
end

--@brief	获取技能伤害数组元素
--@param	index:索引,
--@return	#1:值或nil
function WBattleGlobal:getSkillHurt(index)
    local value = nil
    if #WBattleGlobal:getCurrent().m_tMakePairOk.skillHurt == 0 then
        return value
    elseif WBattleGlobal:getCurrent().m_tMakePairOk.skillHurt[index] == -1 then
        return value
    else
        value = WBattleGlobal:getCurrent().m_tMakePairOk.skillHurt[index]
        return value
    end
end

--@brief	根据RoomMakePairOk消息创建一个新角色
--@param	reg:RoomMakePairOk消息数据结构
--@param	nIndex:玩家数据在消息中的索引位置
--@param    bMonster: 怪兽模式-怪兽形象
--@return	#1:创建的角色表
function WBattleGlobal:buildHero(reg, nIndex, bMonster)
    --WZLog("WBattleGlobal:buildHero one", reg.maxHP[nIndex], reg.playerLevel[nIndex], reg.zsleve[nIndex])


    --local id = 84
    --reg.suit_head[nIndex] = [[bhead = "bhead]]..id..[["]]
    --reg.suit_body[nIndex] = [[bbody = "bbody]]..id..[["]]
    --if id > 40 then id = 1 end
    --reg.suit_face[nIndex] = [[bface = "bface]]..id..[["]]
    WZLog("WBattleGlobal:buildHero two", (reg.serverId and reg.serverId[nIndex] or CacheCenter:getPlayerInfo() and CacheCenter:getPlayerInfo().serverId), reg.playerName[nIndex], reg.playerSex[nIndex], reg.headId[nIndex], reg.faceId[nIndex], reg.bodyId[nIndex], reg.weaponId[nIndex], reg.wingId[nIndex])

    local suit_head, suit_face, suit_body, suit_weapon, suit_wing
	
	
	
	local suit_info = {}
	
	if reg.headId[nIndex] == 0 then 
		if reg.playerSex[nIndex] == 0 then 
			suit_info.head = "id_4903"
		else
			suit_info.head = "id_4906"
		end 
	else
		suit_info.head = "id_"..reg.headId[nIndex]
	end 
	
	if reg.faceId[nIndex] > 0 then 
		suit_info.face = "id_"..reg.faceId[nIndex]
	else
		if reg.playerSex[nIndex] == 0 then 
			suit_info.face = "id_4902"
		else
			suit_info.face = "id_4905"
		end 
	end 

    if bMonster then 
        if reg.playerSex[nIndex] == 0 then 
            suit_info.body = "id_4901"
        else
            suit_info.body = "id_4904"
        end 
        suit_info.monster = -reg.monsterId
    else
    	if reg.bodyId[nIndex] > 0 then 
    		suit_info.body = "id_"..reg.bodyId[nIndex]
            suit_info.monster = 0
    	else
    		if reg.playerSex[nIndex] == 0 then 
    			suit_info.body = "id_4901"
    		else
    			suit_info.body = "id_4904"
    		end 
            if WBattleGlobal:getCurrent():isHeroTowerStage() then 
                suit_info.monster = 0
            else
                suit_info.monster = reg.bodyId[nIndex]
            end
    	end 
    end
    suit_info.bMonsterMode = bMonster
	
	if  reg.weaponId[nIndex] > 0 then 
		suit_info.weapon = "id_"..reg.weaponId[nIndex]
	else 
		suit_info.weapon = "id_4900"
	end 
	
	
	if reg.wingId[nIndex] ~= 0 then 
		suit_info.wing = "id_"..reg.wingId[nIndex]
	else 
		suit_info.wing = ""
	end 

    suit_info.colour = reg.colour and reg.colour[nIndex] or 0
    suit_info.bodyColour = reg.bodyColour and reg.bodyColour[nIndex] or 0

    suit_info.footId = reg.footmark and reg.footmark[nIndex] or 0

   -- if reg.headId[nIndex] ~= 0 then
     --   suit_head = GDatatab_item["id_"..reg.headId[nIndex]].animation_index_code
   -- else

        suit_head = [[bhead = "bhead8"]]
   --end

   -- if reg.faceId[nIndex] ~= 0 then
     --   suit_face = GDatatab_item["id_"..reg.faceId[nIndex]].animation_index_code
   -- else
        suit_face = [[bface = "bface8"]]
   -- end

   -- if reg.bodyId[nIndex] ~= 0 then
     --   suit_body = GDatatab_item["id_"..reg.bodyId[nIndex]].animation_index_code
   -- else
        suit_body = [[bbody = "bbody8"]]
   -- end

    --suit_weapon = GDatatab_item["id_"..reg.weaponId[nIndex]].animation_index_code
       suit_weapon = string.gsub(GDatatab_item["id_"..reg.weaponId[nIndex]].weaponblastinganimation,"c","a")
   -- if reg.wingId[nIndex] ~= 0 then
   --     suit_wing = GDatatab_item["id_"..reg.wingId[nIndex]].animation_index_code
   -- else
   --     suit_wing = nil
   -- end

    WZLog("WBattleGlobal:buildHero three", reg.attack[nIndex], tostring(suit_head), tostring(suit_face), tostring(suit_body), tostring(suit_weapon), tostring(suit_wing))
	local tEquipList = {}
	StringIntsertToTable(tEquipList,suit_head)
	StringIntsertToTable(tEquipList,suit_face)
	StringIntsertToTable(tEquipList,suit_body)
	StringIntsertToTable(tEquipList,suit_weapon)
	StringIntsertToTable(tEquipList,suit_wing)

    local weapon = GDatatab_item["id_"..reg.weaponId[nIndex]] or {animation_index_code=1,sub_type=1}
	local hero = WHero:buildHero(tEquipList, reg.playerSex[nIndex], suit_info)
    --英雄武器类型
    --hero.m_nWeaponType = GDatatab_item["id_"..reg.weaponId[nIndex]].sub_type
    hero.suit_info = suit_info
    hero.m_nTournamentLevel = reg.tournamentLevel and reg.tournamentLevel[nIndex]

	--英雄id
	hero.m_nPlayerId = reg.playerId[nIndex]
	--英雄战斗id
	hero.m_nBattleId = reg.playerId[nIndex]

    if WBattleGlobal:getCurrent().m_tAIControlList then
        for i, id in pairs (WBattleGlobal:getCurrent().m_tAIControlList) do
            if id == hero.m_nBattleId then
                hero.m_bCanControl = true
                hero.m_nAiCtrlId = 1
                hero:buildAiCombination()
                WZLog("WBattleGlobal:buildHero five", id)
                break
            end

        end
    end

	--英雄名字
	hero.m_sPlayerName = reg.playerName[nIndex]
	--英雄等级
	hero.m_nLevel = GlobalGame:checkGlobalPlayerLevel(reg.playerLevel[nIndex])
    --英雄真实等级
    hero.m_nRealLevel = reg.playerLevel[nIndex]
	--英雄性别
	hero.m_nBoyOrGirl = reg.playerSex[nIndex]
	--英雄阵型
	hero.m_nCamp = (reg.playerCamp and reg.playerCamp[nIndex]) or 0
	--英雄阵型位置
	hero.m_nCampPosition = 0
	--英雄最大HP
	hero.m_nMaxHP = reg.maxHP[nIndex]
    hero.m_nHPPre = hero.m_nMaxHP
	--英雄最大PF
	hero.m_nMaxPF = reg.maxPF[nIndex]
	--英雄最大SP
	hero.m_nMaxSP = reg.maxSP[nIndex]
	--英雄HP
	hero.m_nHP = reg.maxHP[nIndex]
	hero.m_nHP_Encrypt = BattleCommon:intEncrypt(hero.m_nHP)
	--英雄PF
	hero.m_nPF = reg.maxPF[nIndex]
	hero.m_nPF_Encrypt = BattleCommon:intEncrypt(hero.m_nPF)
	--英雄SP
	hero.m_nSP = 0
	hero.m_nSP_Encrypt = BattleCommon:intEncrypt(hero.m_nSP)
	--英雄称号
	hero.m_sTitle = reg.playerTitle[nIndex]
	--英雄公会
	hero.m_sCommunity = reg.playerCommunity and reg.playerCommunity[nIndex]
	--英雄攻击力
	hero.m_nAttack = reg.attack[nIndex]
	hero.m_nAttack_Encrypt = BattleCommon:intEncrypt(hero.m_nAttack)
	--英雄暴击倍率
	hero.m_nCriticalhitAttackRate = reg.critRate[nIndex]
	hero.m_nCriticalhitAttackRate_Encrypt = BattleCommon:intEncrypt(hero.m_nCriticalhitAttackRate)
	--英雄防御
	hero.m_nDefence = reg.defence[nIndex]
	hero.m_nDefence_Encrypt = BattleCommon:intEncrypt(hero.m_nDefence)
	--英雄免伤
	hero.m_nInjuryFree = reg.injuryFree[nIndex]
	hero.m_nInjuryFree_Encrypt = BattleCommon:intEncrypt(hero.m_nInjuryFree)
	--英雄破防
	hero.m_nWreckDefense = reg.wreckDefense[nIndex]
	hero.m_nWreckDefense_Encrypt = BattleCommon:intEncrypt(hero.m_nWreckDefense)
	--英雄免暴
	hero.m_nReduceCrit = reg.reduceCrit[nIndex]
	hero.m_nReduceCrit_Encrypt = BattleCommon:intEncrypt(hero.m_nReduceCrit)
	--英雄免坑
	hero.m_nReduceBury = 0
	hero.m_nReduceBury_Encrypt = BattleCommon:intEncrypt(hero.m_nReduceBury)
	--英雄大招类型
	hero.m_nBigSkillType = GDatatab_item["id_"..reg.weaponId[nIndex]].power_skill
	--英雄转生等级
	hero.m_nZSLevel = GlobalGame:checkGlobalPlayerZsleve(reg.playerLevel[nIndex])

	--武器熟练度
	hero.m_nSkillfull = 0
	hero.m_nSkillfull_Encrypt = BattleCommon:intEncrypt(hero.m_nSkillfull)

    hero.m_nPower = reg.power[nIndex]
    hero.m_nArmor = reg.armor[nIndex]
    
    hero.m_nConstitution = reg.constitution[nIndex]
    hero.m_nAgility = reg.agility[nIndex]
    hero.m_nLucky = reg.lucky[nIndex]
    if reg.inspire then
        hero.m_nInspire = reg.inspire[nIndex]
    end

    hero.serverId = reg.serverId and reg.serverId[nIndex] or CacheCenter:getPlayerInfo() and CacheCenter:getPlayerInfo().serverId or 0
    hero.teamId = reg.teamId and reg.teamId[nIndex] or 0
    hero.teamName = reg.teamName and reg.teamName[nIndex] or ""
    hero.teamUrl = reg.url and reg.url[nIndex] or ""
    hero.m_bIsCaptain = reg.isCaptain and reg.isCaptain[nIndex] or false

    --Add By Tianxiang_Xu
    --排位赛相关数据
    if reg.battleTimes ~= nil then
        hero.m_nBattleTimes = reg.battleTimes[nIndex]
    end
    if reg.winTimes ~= nil then
        hero.m_nWinTimes = reg.winTimes[nIndex]
    end
    if reg.streakTimes ~= nil then
        hero.m_nStreakTimes = reg.streakTimes[nIndex]
    end
    if reg.segmentLevel ~= nil then
        hero.m_nSegmentLevel = reg.segmentLevel[nIndex]
    end
    --End Add 

    if reg.fighting ~= nil and reg.fighting[nIndex] ~= nil then
        hero.m_nFighting = reg.fighting[nIndex]
        hero.m_nWinRate = reg.winRate[nIndex]
        if self.m_tAiSkillCombos == nil then
            self.m_tAiSkillCombos = SplitAiStringWithSeparator(reg.robotSkill or "-1")
        end
        --WZLog("WBattleGlobal:buildHero two", hero.m_nPlayerId, hero.m_nFighting, hero.m_nWinRate, reg.robotSkill)
    end

    if reg.petId[nIndex] ~= "" and type(reg.petId[nIndex]) ~= "number" then
        local petInfo = reg.petId[nIndex]
        local petSkill = reg.petSkillId[nIndex]
        local petParam = reg.petParam[nIndex]
        local petLevel = reg.petLevel and reg.petLevel[nIndex] or 0


        local pet = {
            petId=petInfo,			petProbability=nil,
            petParam1=petParam,		petParam2=nil,
            petEffect=nil,		petIcon=nil,
            petType=nil,			petSkillId=nil,
            petParam3=nil,          petLevel=petLevel,
        }

        if petInfo then
            --英雄宠物
            hero:setPet(WPet:create(hero,pet))
            hero.m_nAttackPet = 100
            WZLog("WBattleGlobal:buildHero six", petLevel, hero.m_nAttackPet, tostring(petParam))
        end

    end
    if bMonster then 
        hero.m_bOffFrozen = true
        self.m_monsterHero = hero
    else
	   self.m_tHeros[hero.m_nPlayerId] = hero
    end
    WBattleGlobal:getCurrent().m_tCharacterAttributeList[hero.m_nBattleId] = {battleId=hero.m_nBattleId, atk=hero.m_nAttack}
	--设置被动技能
	--self:setWeaponSkill(hero)

	return hero
end

--@brief	根据RoomMakePairOk消息创建一个着装的新怪物
--@param	reg:RoomMakePairOk消息数据结构
--@param	nIndex:玩家数据在消息中的索引位置
--@return	#1:创建的怪物表
function WBattleGlobal:buildGuaiWithSuit(reg, nIndex, index)
    WZLog("WBattleGlobal:buildGuaiWithSuit", nIndex, index, tostring(reg.guaiBattleId[index]))
    local monsterData = BossData["id_"..nIndex]
    
 --    local suit_head, suit_face, suit_body, suit_weapon, suit_wing

 --    suit_head = monsterData.suit_head
 --    suit_face = monsterData.suit_face
 --    suit_body = monsterData.suit_body
 --    suit_weapon = monsterData.suit_weapon or [[weapon = "weapon17a"]]
 --    suit_wing = nil

 --    local tEquipList = {}
 --    StringIntsertToTable(tEquipList,suit_head)
 --    StringIntsertToTable(tEquipList,suit_face)
 --    StringIntsertToTable(tEquipList,suit_body)
 --    StringIntsertToTable(tEquipList,suit_weapon)
 --    StringIntsertToTable(tEquipList,suit_wing)
	
	-- local suit_info = {}
	-- suit_info.head = "id_4903"
	-- suit_info.face = "id_4902"
	-- suit_info.body = "id_4901"
	-- suit_info.weapon = "id_4900"
	-- suit_info.wing = ""
	-- local hero = WHero:buildHero(tEquipList,0,suit_info)    --性别, 武器类型

 --    hero.m_bIsGuaiWithSuit = true
 --    hero:setType(CharacterType.TYPE_GUAI)
 --    hero.m_nAiType = MonsterAiType.AI_ROBOT
 --    hero:setAI(BattleAiCtrl:new(reg.guaiBattleId[index]))
 --    hero:getAI():setHero(hero)
    --============================================================
    
    local suit_info = {}
    local suitConfig = {}
    if monsterData.suitConfig and monsterData.suitConfig ~= -1 then
        suitConfig.sex = monsterData.suitConfig[1][1]
        suitConfig.headId = monsterData.suitConfig[1][2]
        suitConfig.faceId = monsterData.suitConfig[1][3]
        suitConfig.bodyId = monsterData.suitConfig[1][4]
        suitConfig.weaponId = monsterData.suitConfig[1][5]
        suitConfig.wingId = monsterData.suitConfig[1][6]
        -- suitConfig.robotSkill = monsterData.suitConfig[2]
        suitConfig.robotSkill = GDatatab_item["id_"..suitConfig.weaponId].power_skill[1]
        suitConfig.robotItem = monsterData.suitConfig[2]
    else
        suitConfig.sex = 0
        suitConfig.headId = 4903
        suitConfig.faceId = 4902
        suitConfig.bodyId = 4901
        suitConfig.weaponId = 4900
        suitConfig.wingId = 0
        suitConfig.robotSkill = {-1}
        suitConfig.robotItem = {-1}
    end
    
    suit_info.head = "id_"..suitConfig.headId
    suit_info.face = "id_"..suitConfig.faceId
    suit_info.body = "id_"..suitConfig.bodyId
    suit_info.weapon = "id_"..suitConfig.weaponId
    
    
    if suitConfig.wingId ~= 0 then 
        suit_info.wing = "id_"..suitConfig.wingId
    else 
        suit_info.wing = ""
    end 

    local suit_head, suit_face, suit_body, suit_weapon, suit_wing
    suit_head = [[bhead = "bhead8"]]
    suit_face = [[bface = "bface8"]]
    suit_body = [[bbody = "bbody8"]]
    suit_weapon = string.gsub(GDatatab_item["id_"..suitConfig.weaponId].weaponblastinganimation,"c","a")

    WZLog("WBattleGlobal:buildGuaiWithSuit three", tostring(suit_head), tostring(suit_face), tostring(suit_body), tostring(suit_weapon), tostring(suit_wing))
    local tEquipList = {}
    StringIntsertToTable(tEquipList,suit_head)
    StringIntsertToTable(tEquipList,suit_face)
    StringIntsertToTable(tEquipList,suit_body)
    StringIntsertToTable(tEquipList,suit_weapon)
    StringIntsertToTable(tEquipList,suit_wing)

    local weapon = GDatatab_item["id_"..suitConfig.weaponId] or {animation_index_code=1,sub_type=1}
    local hero = WHero:buildHero(tEquipList,suitConfig.sex,suit_info)
    --英雄武器类型
    hero.m_nWeaponType = GDatatab_item["id_"..suitConfig.weaponId].sub_type
    hero.suit_info = suit_info
    hero.m_bIsGuaiWithSuit = true
    hero:setType(CharacterType.TYPE_GUAI)
    hero.m_nAiType = MonsterAiType.AI_ROBOT
    hero:setAI(BattleAiCtrl:new(reg.guaiBattleId[index]))
    hero:getAI():setHero(hero)
    hero:buildGuaidAiCombination(suitConfig.robotSkill,suitConfig.robotItem)
    return hero
end

--@brief	根据RoomMakePairOk消息创建一个新怪物
--@param	reg:RoomMakePairOk消息数据结构
--@param	nIndex:玩家数据在消息中的索引位置
--@return	#1:创建的怪物表
function WBattleGlobal:buildGuai(reg, nIndex, index)
    WZLog("WBattleGlobal:buildGuai one", nIndex, index)
	local guai = nil
	if reg.guaiBattleId[nIndex] == -1 then
		WZLog("WBattleGlobal:buildGuai two-1")
		guai = {}
		setmetatable(guai,{__index=WCharacter})
		table.insert(self.m_tGuaisTemplate,guai)
        self:setGuaiInfo(guai,nil,nIndex)
    --着装的AI脚本控制的小怪
    elseif WBattleGlobal:getCurrent():isSingleStage() then
        WZLog("WBattleGlobal:buildGuai two-2")
        local monsterData = BossData["id_"..nIndex]
        if monsterData.AniFileId == -1 then
            guai = self:buildGuaiWithSuit(reg, nIndex, index)
            if guai then
                guai.m_nBattleId = reg.guaiBattleId[index]
                WMonster:setGuaiInfo(guai, nIndex)
            end
        else
            local guaiTable = WMonster
            guai = (guaiTable and guaiTable:buildGuai(self.m_tMakePairOk.guaiId[index],BossData["id_"..nIndex].scale,false,self.m_tMakePairOk.guaiBattleId[index])) or nil
        end
        
        if guai then
			self.m_tGuais[reg.guaiBattleId[index]] = guai
		end
        self.m_nBuildGuaiIndex = self.m_nBuildGuaiIndex + 1
        guai.m_nBuildGuaiIndex = self.m_nBuildGuaiIndex
    --无着装的AI脚本控制的小怪
    elseif reg.guaiBattleId[nIndex] ~= -1 then
        local monsterData = BossData["id_"..nIndex]
        if monsterData.type == MonsterType.BOSS_CAGE or monsterData.type == MonsterType.BOSS_LASER 
            or monsterData.type == MonsterType.BOSS_MAGMA or monsterData.type == MonsterType.BOSS_POISON then
            local battleId = self.m_tMakePairOk.guaiBattleId[index]
            local templateId = self.m_tMakePairOk.guaiId[index]
            local camp =  -1
            local pos = {x = 0,y = 0}
            local monster_data = SceneBattleLoading.m_tMapInfo.monster
            for index,guaiInfo in pairs(monster_data) do
                if templateId == guaiInfo[1] then
                    pos = GlobalMethod:ccp(guaiInfo[2],guaiInfo[3])
                    table.remove(monster_data,index)
                    break
                end
            end
            local param = {battleId = battleId,templateId = templateId,camp = camp,bronPos = pos}
            WBattleGlobal:getCurrent():buildMachine(monsterData.type,param)
        else
        	WZLog("WBattleGlobal:buildGuai two-3", index, tostring(self.m_tMakePairOk.guaiId[index]), tostring(BossData["id_"..nIndex]), tostring(self.m_tMakePairOk.guaiBattleId[index]))
            local guaiTable = WMonster
            guai = (guaiTable and guaiTable:buildGuai(self.m_tMakePairOk.guaiId[index],BossData["id_"..nIndex].scale,false,self.m_tMakePairOk.guaiBattleId[index])) or nil
            --guai = (guaiTable and guaiTable:buildGuai(1,1,false,self.m_tMakePairOk.guaiBattleId[nIndex])) or nil
        end
        if guai then
			self.m_tGuais[reg.guaiBattleId[index]] = guai
            guai.m_nBuildGuaiIndex = self.m_nBuildGuaiIndex
		end
        self.m_nBuildGuaiIndex = self.m_nBuildGuaiIndex + 1
	else
		WZLog("WBattleGlobal:buildGuai two-4")
		local guaiTable = GuaiIDToTable[reg.guai_AniFileId[nIndex]]
		guai = (_G[guaiTable] and _G[guaiTable]:buildGuai()) or nil
        
        if guai then
			self.m_tGuais[reg.guaiBattleId[nIndex]] = guai
		end
        self.m_nBuildGuaiIndex = self.m_nBuildGuaiIndex + 1
        guai.m_nBuildGuaiIndex = self.m_nBuildGuaiIndex
	end

	if guai then
		--self:setGuaiInfo(guai,nil,nIndex)
		local monster = guai
		WZLog("WBattleGlobal:buildGuai three", monster.m_sAniFileId, monster.m_nPlayerId, 
            monster.m_sPlayerName, monster.m_nLevel, monster.m_nRealLevel, monster.m_nCamp, monster.m_nMaxHP, 
            monster.m_nHP, monster.m_nPF, monster.m_nAttack, monster.m_nCriticalhitAttackRate, monster.m_nDefence, 
            monster.m_nInjuryFree, monster.m_nWreckDefense, monster.m_nReduceCrit, monster.m_nReduceBury, monster.m_nGuaiType)
    else
        WZLog("WBattleGlobal:buildGuai nil", nIndex)
	end
    GlobalGame:getBattleEventDispatcher():Dispatch(BATTLE_EVENT_TYPE.MONSTER_CREATE)
    --属性记录
    if guai then
        WBattleGlobal:getCurrent().m_tCharacterAttributeList[guai.m_nBattleId] = {battleId=guai.m_nBattleId, atk=guai.m_nAttack}
         --设置怪物记录
    WBattleGlobal:getCurrent():setBuildMonsterRecord(guai.m_nBattleId,guai.m_nPlayerId)
    end
	return guai
end

--@brief	设置怪物的战斗信息
--@param	tGuai:怪物数据表
--@param	sAniFileId:怪物识别码,例：IWCO_BOSS或"boss"
--@param	nIndex:数据所在下标,如不知道就传nil
--@note		第2和第3参数只需传其中一个即可
function WBattleGlobal:setGuaiInfo( tGuai, sAniFileId, nIndex )
    do return end
    --WZLog("WBattleGlobal:setGuaiInfo", tostring(sAniFileId),tostring(nIndex), tostring(self.m_tMakePairOk.guaiId[nIndex] ),tostring(self.m_tMakePairOk.guaiBattleId[nIndex]),tostring(self.m_tMakePairOk.guai_name[nIndex]), tostring(self.m_tMakePairOk.guai_camp[nIndex]))
	if nIndex == nil then
		for i=1,self.m_tMakePairOk.guaiCount do
            WZLog("self.m_tMakePairOk.guai_AniFileId[i]", self.m_tMakePairOk.guai_AniFileId[i], i)
			if self.m_tMakePairOk.guai_AniFileId[i] == sAniFileId then
				nIndex = i
				break
			end
		end
		if nIndex == nil then
			WZLog("could not find guai info with fileId:",sAniFileId)
			return
		end
	end

    --动画文件
    tGuai.m_sAniFileId = self.m_tMakePairOk.guai_AniFileId[nIndex]
	--数据表id
	tGuai.m_nPlayerId = self.m_tMakePairOk.guaiId[nIndex]
	--战斗id
	tGuai.m_nBattleId = self.m_tMakePairOk.guaiBattleId[nIndex]
	--怪名字
	tGuai.m_sPlayerName = self.m_tMakePairOk.guai_name[nIndex]
	--怪等级
	tGuai.m_nLevel = GlobalGame:checkGlobalPlayerLevel(self.m_tMakePairOk.guai_level[nIndex]) 
    --怪物真实等级
	tGuai.m_nRealLevel = self.m_tMakePairOk.guai_level[nIndex]
	--怪阵型
	tGuai.m_nCamp = self.m_tMakePairOk.guai_camp[nIndex]
	--怪maxHP
    if WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_WORLDBOSS then
        tGuai.m_nMaxHP = WBattleGlobal:getCurrent().m_tMakePairOk.guaiMaxHP[nIndex]
    elseif WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_WORLDTEAMBOSS then
        tGuai.m_nMaxHP = WBattleGlobal:getCurrent().m_tMakePairOk.guaiMaxHP[nIndex]
    else
        tGuai.m_nMaxHP = self.m_tMakePairOk.guaiNowHP[nIndex]
    end
	
	--怪maxPF
	tGuai.m_nMaxPF = self.m_tMakePairOk.guai_pf[nIndex]
	--怪性别
	tGuai.m_nBoyOrGirl = self.m_tMakePairOk.guai_sex[nIndex]
	--怪MaxSP
	tGuai.m_nMaxSP = 0
	--怪HP
	tGuai.m_nHP = self.m_tMakePairOk.guaiNowHP[nIndex]
	tGuai.m_nHP_Encrypt = BattleCommon:intEncrypt(tGuai.m_nHP)
	--怪PF
	tGuai.m_nPF = self.m_tMakePairOk.guai_pf[nIndex]
	tGuai.m_nPF_Encrypt = BattleCommon:intEncrypt(tGuai.m_nPF)
	--怪SP
	tGuai.m_nSP = 0
	tGuai.m_nSP_Encrypt = BattleCommon:intEncrypt(tGuai.m_nSP)
	--怪攻击力
	tGuai.m_nAttack = self.m_tMakePairOk.guai_attack[nIndex]
	tGuai.m_nAttack_Encrypt = BattleCommon:intEncrypt(tGuai.m_nAttack)
	--怪攻击范围
	--tGuai.m_fRadiusForBulletExplode = guai_attackArea[nIndex]
	--怪暴击倍率
	tGuai.m_nCriticalhitAttackRate = self.m_tMakePairOk.guai_criticalRate[nIndex]
	tGuai.m_nCriticalhitAttackRate_Encrypt = BattleCommon:intEncrypt(tGuai.m_nCriticalhitAttackRate)
	--怪防御
	tGuai.m_nDefence = self.m_tMakePairOk.guai_defend[nIndex]
	tGuai.m_nDefence_Encrypt = BattleCommon:intEncrypt(tGuai.m_nDefence)
	--怪免伤
	tGuai.m_nInjuryFree = self.m_tMakePairOk.guai_injuryFree[nIndex]
	tGuai.m_nInjuryFree_Encrypt = BattleCommon:intEncrypt(tGuai.m_nInjuryFree)
	--怪破防值
	tGuai.m_nWreckDefense = self.m_tMakePairOk.guai_wreckDefense[nIndex]
	tGuai.m_nWreckDefense_Encrypt = BattleCommon:intEncrypt(tGuai.m_nWreckDefense)
	--怪免暴
	tGuai.m_nReduceCrit = self.m_tMakePairOk.guai_reduceCrit[nIndex]
	tGuai.m_nReduceCrit_Encrypt = BattleCommon:intEncrypt(tGuai.m_nReduceCrit)
	--怪免坑
	tGuai.m_nReduceBury = self.m_tMakePairOk.guai_reduceBury[nIndex]
	tGuai.m_nReduceBury_Encrypt = BattleCommon:intEncrypt(tGuai.m_nReduceBury)
	--怪大招类型
	tGuai.m_nBigSkillType = self.m_tMakePairOk.guai_bigSkillType[nIndex]
	--怪转生等级
	tGuai.m_nZSLevel = GlobalGame:checkGlobalPlayerZsleve(self.m_tMakePairOk.guai_level[nIndex])
	--if GlobalGame.checkGlobalPlayerZsleve(self.m_tMakePairOk.guai_level[nIndex]) then
	--	tGuai.m_nZSLevel = 1
	--end
	--怪武器类型
	tGuai.m_nWeaponType = self.m_tMakePairOk.guai_weapon_type[nIndex]
	--攻击相关
	tGuai:setAttPercent(100)
	tGuai:setAttTimes(1)
	tGuai:setAttScatterNum(1)
	tGuai:setCanFrozen(false)
	tGuai:setCanFollow(false)
    
    tGuai.m_nPower = 0
    tGuai.m_nArmor = 0
    tGuai.m_nConstitution = 0
    tGuai.m_nAgility = 0
    tGuai.m_nLucky = 0
    
    --怪物类型
    tGuai.m_nGuaiType = self.m_tMakePairOk.guai_type[nIndex]
    
    if tGuai:getAI() ~= nil then
        tGuai:getAI().m_nCharacterId = tGuai.m_nBattleId
    end

    --ai控制相关
    if self.m_tMakePairOk.guai_ai ~= nil and self.m_tMakePairOk.guai_ai[nIndex] ~= nil then
        
        --攻击范围
        local rate = 1.75
        if tGuai.m_nAiType == MonsterAiType.AI_RANGED then            
            rate = 4.0
        end
        
        tGuai.m_nAttackArea = self.m_tMakePairOk.guai_attackArea[nIndex] * rate
        --怪武器名称
        if tGuai.m_sWeaponName == nil then
            tGuai.m_sWeaponName = SplitStringWithSeparator(self.m_tMakePairOk.guai_suit_weapon[nIndex], "\"")[2]
        end
        --"
        --WZLog("ai控制相关: ", tostring(self.m_tMakePairOk.guai_ai[nIndex]), tostring(self.m_tMakePairOk.guai_dialogue[nIndex]), self.m_tMakePairOk.guaiBattleId[nIndex], tostring( tGuai.m_sWeaponName), tostring(self.m_tMakePairOk.guai_suit_weapon[nIndex]), self.m_tMakePairOk.guai_injuryFree[nIndex], tostring(tGuai.m_nAiType == MonsterAiType.AI_RANGED))
        
        if tGuai.m_bIsGuaiWithSuit ~= true then
            --tGuai.m_tAiScript = self.m_tMakePairOk.guai_ai[nIndex]
        else
            if BossData ~= nil then
                local id = self.m_tMakePairOk.guai_dataId[nIndex]
                for i,v in pairs (BossData) do
                    if id == v.guai_id then
                        tGuai.m_nDataId = v.id
                    end
                end

                --tGuai.m_tAiScript = BossData["id_"..tGuai.m_nDataId].guai_ai
                tGuai.m_tSkillItemList = BossData["id_"..tGuai.m_nDataId].skill
                tGuai.m_nHitRate = BossData["id_"..tGuai.m_nDataId].mzl
                tGuai.m_nPhysicalMax = BossData["id_"..tGuai.m_nDataId].tili
                --WZLog("BossData two", "id_"..tGuai.m_nDataId, tGuai.m_nPhysicalMax, tGuai.m_tAiScript, tGuai.m_tSkillItemList)
            end
        end
        tGuai.m_tDialogue = self.m_tMakePairOk.guai_dialogue[nIndex]
        WZLog("BossData three", tGuai.m_tDialogue)
        
        if tGuai.m_tDialogue ~= "-1" then
            tGuai.m_tDialogue = SplitStringWithSeparator(tGuai.m_tDialogue, "|")
        end
        
        if tGuai.m_tAiScript ~= nil and tGuai.m_tAiScript ~= "-1" then
            --tGuai.m_tAiScript = SplitAiStringWithSeparator(tGuai.m_tAiScript)
            --tGuai:getAI():setAiInterface()
        end
    end
end

--@brief	创建一个新的子弹"
--@param	nPlayerId:子弹所属玩家的ID
--@param	nStartX:子弹开始位置
--@param	nStartY:子弹开始位置
--@param	fSpeedX:子弹速度
--@param	fSpeedY:子弹速度
--@return	#1:创建的子弹表
function WBattleGlobal:buildBullet(nPlayerId,nStartX,nStartY,fSpeedX,fSpeedY,isSpatter)
	local hero = nil

    if nPlayerId ~= nil then
        hero = self:getCharacterWithId(nPlayerId)
    else
        hero = self:getCurrentCharacter()
    end

	if hero == nil then
		WZLog("WBattleGlobal:buildBullet hero not found ID:",nPlayerId)
		return nil
	end

	local accele = {x=WBattleGlobal:getCurrent():getWind().x+BattleConstants.g_nFlyGravity.x,y=WBattleGlobal:getCurrent():getWind().x+BattleConstants.g_nFlyGravity.y}
	local isPenetrateMap = WBattleGlobal:getCurrent():isPenetrateMapCopy()
    if hero:getCanPenetrate() then
        isPenetrateMap = true
    end    
    local bullet = WBullet:buildBullet({x=nStartX,y=nStartY},{x=fSpeedX,y=fSpeedY},accele,hero,isPenetrateMap,isSpatter)

	if bullet == nil then
		WZLog("WBattleGlobal:buildBullet bullet build failed!! player ID:",nPlayerId)
		return nil
	end

	bullet:addCollisionCharas(WBattleGlobal:getCurrent():getHeroSortList())
	bullet:addCollisionCharas(WBattleGlobal:getCurrent():getGuaiSortList())
    bullet:addCollisionCharas(WBattleGlobal:getCurrent():getMachinesSortList())
    WZLog("WBattleGlobal:buildBullet one", #WBattleGlobal:getCurrent():getGuaiList(true))

	-------------------------------------后添加的效果会先作用,依次往前作用--------------------------------------

    -- if self.m_nBattleType == BattleConstants.g_nBATTLE_TYPE_NORMAL or (self.m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS and self.battleMode == BattleConstants.g_tBossBattleMode.MODE_SINGLE_STAGE) then
    --     --免坑,截断挖坑
    --     bullet = WNoHoleEffect:buildEffect(bullet)
    --     bullet:setNoHoleEffectInfo(self:getBattleRandNum())

    --     --免疫,截断伤害和各种buff
    --     bullet = WImmunityEffect:buildEffect(bullet)
    --     bullet:setImmunityEffectInfo(self:getBattleRandNum())
    -- end

    --核弹,截断子弹爆炸
    WZLog("WBattleGlobal:buildBullet", tostring(hero.m_bWeaponAtomicBomb))
    if hero.m_bWeaponAtomicBomb then
        bullet = WAtomicBombEffect:buildEffect(bullet)
    end

	--冰冻效果,截断子弹爆炸
    WZLog("WFrozenEffect:buildEffect one",tostring(hero:getCanFrozen()), tostring(WBattleGlobal:getCurrent().m_nBattleType), tostring(WBattleGlobal:getCurrent().battleMode))
	if hero:getCanFrozen() then
        WZLog("WFrozenEffect:buildEffect")
		bullet = WFrozenEffect:buildEffect(bullet)
	end

	--追踪效果,不进行任何截断
	if hero:getCanFollow() then
		bullet = WFollowEffect:buildEffect(bullet)
	end

	--各种持续伤害(毒素,冰冻,灼伤等),不进行任何截断
	if hero.m_nWeaponHurtRound ~= nil then
		bullet = WHurtEffect:buildEffect(bullet)
		bullet:setHurtEffectInfo(hero.m_nWeaponHurtRound+1,hero.m_nWeaponHurt,hero.m_sHurtAnimName)
	end

	--疲劳效果,不进行任何截断
	if hero.m_nWeaponTiredRound ~= nil then
		bullet = WTiredEffect:buildEffect(bullet)
		bullet:setTiredEffectInfo(hero.m_nWeaponTiredRound+1,hero.m_nWeaponTired,hero.m_sHurtAnimName)
	end

	--重力,不进行任何截断
	if hero.m_nWeaponFlyLockRound ~= nil then
		bullet = WFlyLockEffect:buildEffect(bullet)
		bullet:setFlyLockEffectInfo(hero.m_nWeaponFlyLockRound+1,nil,hero.m_sHurtAnimName)
	end

	--封印,不进行任何截断
	if hero.m_nWeaponSealRound ~= nil then
		bullet = WSealEffect:buildEffect(bullet)
		bullet:setSealEffectInfo(hero.m_nWeaponSealRound+1,nil,hero.m_sHurtAnimName)
	end

	--锁足,不进行任何截断
	if hero.m_nWeaponMoveLockRound ~= nil then
		bullet = WMoveLockEffect:buildEffect(bullet)
		bullet:setMoveLockEffectInfo(hero.m_nWeaponMoveLockRound+1,nil,hero.m_sHurtAnimName)
	end

	--眩晕,不进行任何截断
	if hero.m_nWeaponVertigoRound ~= nil then
		bullet = WVertigoEffect:buildEffect(bullet)
		bullet:setVertigoEffectInfo(hero.m_nWeaponVertigoRound+1,nil,hero.m_sHurtAnimName)
	end

	--击退,不进行任何截断
	if hero.m_nWeaponRepulseDis ~= nil then
		bullet:setRepulseEffectInfo(nil,hero.m_nWeaponRepulseDis,nil)
	end

    -- if self.m_nBattleType == BattleConstants.g_nBATTLE_TYPE_NORMAL or (self.m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS and self.battleMode == BattleConstants.g_tBossBattleMode.MODE_SINGLE_STAGE) then
    --     --吸收,无伤害
    --     bullet = WAbsorbEffect:buildEffect(bullet)
    --     bullet:setAbsorbEffectInfo(self:getBattleRandNum())
    -- end

	table.insert(self.m_tBullets,bullet)

    if nPlayerId and nPlayerId == self:getCurrentCharacterId() then
        self:setBulletNum(1)
    end

	return bullet
end

--@brief	创建一个新的子弹"
--@param	nPlayerId:子弹所属玩家的ID
--@param	nStartX:子弹开始位置
--@param	nStartY:子弹开始位置
--@param	fSpeedX:子弹速度
--@param	fSpeedY:子弹速度
--@return	#1:创建的子弹表
function WBattleGlobal:buildBulletTeach(nPlayerId,nStartX,nStartY,fSpeedX,fSpeedY,isSpatter)
	local hero = nil

    if nPlayerId ~= nil then
        hero = self:getCharacterWithId(nPlayerId)
    else
        hero = self:getCurrentCharacter()
    end

	if hero == nil then
		WZLog("WBattleGlobal:buildBulletTeach hero not found ID:",nPlayerId)
		return nil
	end

	local accele = {x=WBattleGlobal:getCurrent():getWind().x+BattleConstants.g_nFlyGravity.x,y=WBattleGlobal:getCurrent():getWind().x+BattleConstants.g_nFlyGravity.y}

    local bullet = WBulletTeach:buildBullet({x=nStartX,y=nStartY},{x=fSpeedX,y=fSpeedY},accele,hero,false,isSpatter)

	if bullet == nil then
		WZLog("WBattleGlobal:buildBulletTeach bullet build failed!! player ID:",nPlayerId)
		return nil
	end

	

	self.m_tBulletTeachs = self.m_tBulletTeachs or {}
	table.insert(self.m_tBulletTeachs,bullet)

    -- if nPlayerId and nPlayerId == self:getCurrentCharacterId() then
    --     self:setBulletNum(1)
    -- end

	return bullet
end
--@brief	生成一个boss子弹
--@param	bulletAnim:子弹的动画
--@param	tPos:位置
--@param	tSpeed:速度
--@param	tAcceleration:加速度
--@param	tChara:子弹所属人物
--@param	nType:子弹类型 0:投砸  1:射击  2:跟随地形
--@param	bUseNewExplodeAnimation:是否使用新爆炸动画
function WBattleGlobal:buildBossBullet(bulletAnim, tPos, tSpeed, tAcceleration, tChara, nType, fireType, boomType,isPenetrateMonster,isPenetrateMap,isSpatter)
    if tChara:getCanPenetrate() then
        isPenetrateMap = true
    end
	local bullet = WBossBullet:buildBullet(bulletAnim, tPos, tSpeed, tAcceleration, tChara, nType, fireType, boomType,isPenetrateMap,isSpatter)

	if bullet == nil then
		WZLog("WBattleGlobal:buildBossBullet bullet build failed!! chara ID:",tChara:getId())
		return nil
	end

	bullet:addCollisionCharas(WBattleGlobal:getCurrent():getHeroSortList())
    bullet:addCollisionCharas(WBattleGlobal:getCurrent():getMachinesSortList())
    if not isPenetrateMonster then
        bullet:addCollisionCharas(WBattleGlobal:getCurrent():getGuaiSortList())
    end
    
    local hero = self:getCurrentCharacter()
    --追踪效果,不进行任何截断
    if hero:getCanFollow() then
        bullet = WFollowEffect:buildEffect(bullet)
    end

	table.insert(self.m_tBossBullets,bullet)

    if tChara.getBattleId and tChara:getBattleId() == self:getCurrentCharacterId() then
        self:setBulletNum(1)
    end

	return bullet
end

--@brief 创建机关
function WBattleGlobal:buildMachine(machineType,param)
    WZLog("WBattleGlobal:buildMachine",tostring(machineType),tostring(param))
    local machine = nil
    --组队boss1炮台等 无需伤害 buff 同步
    if machineType == MonsterType.BOSS_PAO then
        WZLog("WBattleGlobal:buildMachine-2",param.aniFileIndex)

        machine = WBattleMachine:new(param.aniFileIndex,param.owner)
        machine.m_nBattleId = WBattleGlobal:getCurrent():getBuildGuaiBattleId(false)
        param.owner:addMachine(machine)
        self.m_tMachines[machine.m_nBattleId] = machine
    end
    --组队boss6火焰 无需伤害 buff 同步
    if machineType == MonsterType.BOSS_FIRE then
        WZLog("WBattleGlobal:buildMachine-2",param.aniFileIndex)

        machine = WBattleMachineFire:new(WBattleGlobal:getCurrent():getBuildGuaiBattleId(false),37,param.camp,param.bronPos)
        machine.m_nBattleId = WBattleGlobal:getCurrent():getBuildGuaiBattleId(false)
        self.m_tMachines[machine.m_nBattleId] = machine
    end

    --治疗图腾等 需要伤害 buff同步 固定行动逻辑（ctb行动 或其他）
    if machineType == MonsterType.TREAT_TOTEM then
        machine  = WBattleMachineTreatTotem:new(param.battleId,param.templateId,param.camp,param.bronPos)

        self.m_tMachines[machine.m_nBattleId] = machine
    end

    if machineType == MonsterType.BUFF_TOTEM then
        machine  = WBattleMachineBuffTotem:new(param.battleId,param.templateId,param.camp,param.bronPos)
        self.m_tMachines[machine.m_nBattleId] = machine
    end

    --龙卷风
    if machineType == MonsterType.TORANDO then
        machine = WBattleMachineTornado:new(param.battleId,param.templateId,param.camp,param.bronPos)
        self.m_tMachines[machine.m_nBattleId] = machine
     end
    --boss5 礼物
    if machineType == MonsterType.BOSS_GIFT then
        machine = WBattleMachineGift:new(param.battleId,param.templateId,param.camp,param.bronPos)
        self.m_tMachines[machine.m_nBattleId] = machine
     end

    if machineType == MonsterType.BOSS_LIGHT then
        machine = WBattleMachineLight:new(param.battleId,param.templateId,param.camp,param.bronPos)
        self.m_tMachines[machine.m_nBattleId] = machine
    end
    --回合开始碰撞伤害道具
    if machineType == MonsterType.BOSS_CAGE or  machineType == MonsterType.BOSS_MAGMA or machineType == MonsterType.BOSS_POISON then
        machine = WBattleMachineRoundStartCollisionHurt:new(machineType,param.battleId,param.templateId,param.camp,param.bronPos)
        self.m_tMachines[machine.m_nBattleId] = machine
    end

    if machineType == MonsterType.BOSS_LASER then
        local laserType = WBattleGlobal:getCurrent().m_nLaserGunState
        WBattleGlobal:getCurrent().m_nLaserGunState = WBattleGlobal:getCurrent().m_nLaserGunState + 1
        if WBattleGlobal:getCurrent().m_nLaserGunState > 4 then
            WBattleGlobal:getCurrent().m_nLaserGunState = 1
        end
        machine = WBattleMachineLaserGun:new(param.battleId,param.templateId,param.camp,param.bronPos,laserType)
        self.m_tMachines[machine.m_nBattleId] = machine
    end
    
    return machine
end


--@brief 移除机关
function WBattleGlobal:removeMachine(battleId)
    for i,v in pairs(self.m_tMachines) do
        local machine = v
        if machine.m_nBattleId == battleId then
            machine:destroy()
            self.m_tMachines[battleId] = nil
            break
        end
    end
end

--@brief	创建一个子弹爆炸的控件
--@param	tBullet:子弹的表
--@param	sWeaponName:使用的武器名字
--@return	#1:爆炸控件
function WBattleGlobal:buildWeaponExplodeElement(tBullet,sWeaponName)
    --[[
	local sElementName = WeaponExplodeAnimation[sWeaponName]
    WZLog("WBattleGlobal:buildWeaponExplodeElement", tostring(tBullet), tostring(sWeaponName), tostring(sElementName))
	if sElementName ~= nil then
		local element = WZUISystem:getInstance():createElement(sElementName)
        if tBullet ~= nil then
            element:setLuaObjectIndex(tBullet)
        end
		return element
	end
    --]]
	return nil
end

--@brief	设置武器技能
function WBattleGlobal:setWeaponSkill(tHero)

    for i,v in pairs(self.m_tMakePairOk.weaponSkillType) do
        WZLog("WBattleGlobal:setWeaponSkill one",i, v, self.m_tMakePairOk.weaponSkillName[i])
    end

    for i,v in pairs(self.m_tMakePairOk.weaponSkillParam1) do
        WZLog("WBattleGlobal:setWeaponSkill two",i, v, self.m_tMakePairOk.weaponSkillParam2[i])
    end

    for i,v in pairs(self.m_tMakePairOk.weaponSkillPlayerId) do
        WZLog("WBattleGlobal:setWeaponSkill three",i, v)
    end

	for i,id in pairs(self.m_tMakePairOk.weaponSkillPlayerId) do
		if id == tHero:getBattleId() then

        WZLog("WBattleGlobal:setWeaponSkill", i,id, tHero:getId(), self.m_tMakePairOk.weaponSkillType[i], self.m_tMakePairOk.weaponSkillParam1[i], self.m_tMakePairOk.weaponSkillParam2[i])

			table.insert(tHero.m_tWeaponSkillName,self.m_tMakePairOk.weaponSkillName[i])
			table.insert(tHero.m_tWeaponSkillType,self.m_tMakePairOk.weaponSkillType[i])
			table.insert(tHero.m_tWeaponSkillChance,self.m_tMakePairOk.weaponSkillChance[i])
			table.insert(tHero.m_tWeaponSkillParam1,self.m_tMakePairOk.weaponSkillParam1[i])
			table.insert(tHero.m_tWeaponSkillParam2,self.m_tMakePairOk.weaponSkillParam2[i])
		end
	end
end

--@brief	单人副本英雄是否被坑杀函数
--@note		单人副本英雄是否被坑杀
function WBattleGlobal:checkIsHeroHole()

    local _,isHeroHole = WBattleGlobal:getCurrent():getMyHero():checkIsOutOfScene()
    if self.m_bIsSingleChallengeGameOver == false and (WBattleGlobal:getCurrent():getMyHero():getHp() <= 0  or (isHeroHole and SceneBattle:getBattleLoop():getBattleStatus() ~= BattleLoop.S_PLAYER_FLY))then
        self.m_bIsSingleChallengeGameOver = true
        WBattleGlobal:getCurrent():getMyHero():setDead(true,14)
        WZLog("检测英雄是否死亡 ", deadGuaiCount, BattleCommon:tableLen(self:getGuaiList()))
        self:singleStageEnd(false)
    end
end

--@brief    单人副本英雄是否死亡
function WBattleGlobal:checkIsHeroDead()
    if WBattleGlobal:getCurrent():getMyHero():isDead() then
        return true
    end

    local _,isHeroHole = WBattleGlobal:getCurrent():getMyHero():checkIsOutOfScene()
    if WBattleGlobal:getCurrent():getMyHero():getHp() <= 0  or (isHeroHole and SceneBattle:getBattleLoop():getBattleStatus() ~= BattleLoop.S_PLAYER_FLY)then
        WBattleGlobal:getCurrent():getMyHero():setDead(true,15)
       return true
    end
    return false
end

--@brief	单人副本结束函数
--@param	isWin:是否胜利
--@note		单人副本结束
function WBattleGlobal:singleStageEnd(isWin)
    self:setGameOver(true)
    if isWin then
        isWin = self:checkSingleHardBattle()
    end
    -- local myHero = WBattleGlobal:getCurrent():getMyHero()
    -- local recordPre = WBattleGlobal:getCurrent().m_tBattleRecord[self.m_nTurnTimes]
    -- local guaiList = WBattleGlobal:getCurrent():getGuaiList()
    -- local guaiHpList = {}
    -- for i, v in pairs(guaiList) do
    --     table.insert(guaiHpList, v:getHp())
    -- end
    -- if WBattleGlobal:getCurrent().m_tBattleRecord[self.m_nTurnTimes - 1] ~= nil then
    --     recordPre.pf = 100 - myHero:getPF()
    --     recordPre.playerHp = myHero:getHp()
    --     recordPre.guaiHp = guaiHpList
    -- end
    ----json.encode效率很低
    -- WZLog("WBattleGlobal:singleStageEnd record", self.m_nTurnTimes, myHero:getHp(), myHero:getMaxHp(), WBattleGlobal:getCurrent().m_tBattleRecord.myTurnCount, json.encode(WBattleGlobal:getCurrent().m_tBattleRecord))
    if isWin == true then

    --ProtocolProcessorSingleMap:send_SINGLEMAP_ChallengeSuccess(self.m_tMakePairOk.pointId,"true")

        --[[
        DelayCallFunction(function()
            ProtocolProcessorSingleMap:send_SINGLEMAP_ChallengeSuccess(self.m_tMakePairOk.mapId, "", self.m_tMakePairOk.mapType)
            end, nil, 1)
        --]]
        local msg = MsgManager:createMsg(BattleMsgGameOver)
        msg.m_bWin = true
        MsgManager:pushNonBlockMsg(msg)
    else
        local msg = MsgManager:createMsg(BattleMsgGameOver)
        msg.m_bWin = false
        MsgManager:pushNonBlockMsg(msg)
    end
     self:showOsTime("singleStageEnd end")
end

function WBattleGlobal:checkSingleHardBattle()
    local isWin = true
    if GlobalGame.g_nSingleCopyType == 3 then
        local mapInfo = CopyTable(GDatatab_single_map["id_"..WBattleGlobal:getCurrent().m_tMakePairOk.mapId])
        if mapInfo then
            local hero  = WBattleGlobal:getCurrent():getMyHero()
            if mapInfo.pass_hp == -1 then
                local attRound = hero:getAttackRound()
                if attRound > mapInfo.pass_round then
                    isWin = false
                end
            else
                local curHp = WBattleGlobal:getCurrent().m_nMyRemainHp
                local maxHp = hero:getMaxHp()
                local prec = math.ceil(curHp * 100/maxHp)
                if prec < mapInfo.pass_hp then
                    isWin = false
                end
            end
        end
    end
    return isWin
end

--@brief	定时更新函数
--@param	dt:距离上一次调用的时间（秒）
--@note		由定时器调用
function WBattleGlobal:updateNameInfoIcon(dt)
    BattleHeroName:releaseTransform()
    local nameList = {}
    for i, v in pairs(self:getCharacterList()) do
        if v:getPlayerNameIcon() ~= nil then
            if v:getType() == 0 and v:getPlayerNameIcon().m_hp:getPercentage() > 0 then
                v:getPlayerNameIcon():update()
            else
                v:getPlayerNameIcon():update()
            end
            if not v:getPlayerNameIcon().m_bIsOffSort then
                table.insert(nameList,v:getPlayerNameIcon())
            end
        end
    end
    
    -- if #nameList == 0 then
    --     return
    -- end
    
    -- --按x位置排序
    -- local sortFunc = function(a, b) return  a.m_curPos.x <  b.m_curPos.x end
    -- table.sort(nameList,sortFunc)
    -- local minDis = 120/2 
    -- local needAdjust = true

    -- --间距少于 misDis 进行位置调整
    -- local overlapList = {}
    -- -- for i = 1,#nameList do
    -- --     WZLog("WBattleGlobal:updateNameInfoIcon-zero",i,nameList[i].m_curPos.x)
    -- -- end
    -- for i = 1,#nameList - 1 do
    --     local posX1,posY1 = nameList[i].m_curPos.x, nameList[i].m_curPos.y
    --     local posX2,posY2 = nameList[i + 1].m_curPos.x, nameList[i + 1].m_curPos.y
        
    --     if math.abs(posY2 - posY1) < 100 then
    --         if posX2 - posX1 < minDis then
    --             --上一个重叠队列存在 存放上一个队列中
    --             if i > 1 and overlapList[i - 1] then
    --                 overlapList[i - 1][i] = i
    --                 overlapList[i - 1][i + 1] = i + 1
    --             else
    --                 --新建重叠一个位置对立
    --                 overlapList[i] = {}
    --                 overlapList[i][i] = i
    --                 overlapList[i][i + 1] = i + 1
    --             end    
    --         end
    --     end
    -- end
    -- -- WZLog("WBattleGlobal:updateNameInfoIcon-one",BattleCommon:tableLen(overlapList))
    -- if BattleCommon:tableLen(overlapList) > 0 then
    --     --有发生重叠队列 坐标位置重新设置
    --     for _,list in pairs(overlapList) do
    --         local tmpList = {}
    --         for _,v in pairs(list) do
    --             table.insert(tmpList,v)
    --         end 
    --         local sortFunc = function(a, b) return a < b end
    --         table.sort(tmpList,sortFunc)

    --         local totalLen = (#tmpList - 1) * (minDis + 10) --总间距
    --         local sx = nameList[tmpList[1]].m_curPos.x
    --         local ex = nameList[#tmpList].m_curPos.x
    --         local posLen = ex - sx
    --         local startPosX = sx - (totalLen - posLen)/2 
    --         for i = 1,#tmpList do
    --             local tx = startPosX + (i - 1)*(minDis + 10)
    --             nameList[tmpList[i]]:getNameNode():setPositionX(tx)
    --             nameList[tmpList[i]].m_curPos.x = tx
    --             -- WZLog("WBattleGlobal:updateNameInfoIcon-two",tmpList[i],tx)
    --         end
    --     end
    --     --位置重设成功 新坐标继续进入检验
    -- end
end

--@brief	单人副本定时更新函数
--@param	dt:距离上一次调用的时间（秒）
--@note		由定时器调用
function WBattleGlobal:updateSingleMap(dt)
    --WZLog("WBattleGlobal:updateSingleMap", tostring(TeachGroup1.ISBATTLE))
    if TeachGroup1.ISBATTLE then
        return
    end

    --单人副本检测通关与否
    if WBattleGlobal:getCurrent():isReplayGame() then
        for id, guai in pairs(self:getCharacterList()) do
            if guai:isDead() == false then
                local _,isHole = guai:checkIsOutOfScene()
                if isHole == true and SceneBattle:getBattleLoop():getBattleStatus() ~= BattleLoop.S_PLAYER_FLY then
                    guai:setDead(true,1)
                end
            end
        end
    end
    if not WBattleGlobal:getCurrent():isSingleStage() or WBattleGlobal:getCurrent():isReplayGame() then
        return
    end

    local myHero = WBattleGlobal:getCurrent():getMyHero()

    if myHero == nil then
        return
    end

    --WZLog("WBattleGlobal:updateSingleMap", tostring(self.m_copyData))
    if self.m_copyData then
        local result = self.m_copyData:checkIsEnd()
        if not self.m_copyData.m_bIsEnd and result ~= 0 then
           self:setGameOver(true)
           self.m_copyData:copyEnd()
        end
        return
    end
    -- 秒过副本秘籍
    -- if WBattleGlobal:getCurrent().m_nTurnTimes > 1 then
    --     for id, guai in pairs(self:getGuaiList()) do
    --         if not guai:isDead() then
    --             self:setHoldMonsterRecord(guai:getBattleId())
    --             --设置坑杀怪物
    --             guai:setDead(true,1)
    --         end
    --     end
    -- end

    --检测英雄是否死亡
    if self:getCurrentCharacterId() ~= myHero:getId() then
        self:checkIsHeroHole()
    end

    --检测怪是否被杀
    if self.m_bIsSingleChallengeGameOver == false and self.m_tGuaiDestroyList ~= nil and #self.m_tGuaiDestroyList >= 1 then
        for id, guai in pairs(self:getGuaiList()) do
            for i, v in pairs(self.m_tGuaiDestroyList) do
                --WZLog("self.m_tDestroyGuaiList", v, guai:getId())
                if guai:getId() == v then
                    if guai:isDead() == true or guai:getHp() <= 0 then
                        WZLog("self.m_tDestroyGuaiList ok", v, guai:getId())
                        table.remove(self.m_tHoleGuaiList, i)
                    end
                end
            end
        end
    elseif self.m_tGuaiDestroyList ~= nil and #self.m_tGuaiDestroyList == 0 then
        WZLog("检测怪是否被杀 ", deadGuaiCount, BattleCommon:tableLen(self:getGuaiList()))
        self:singleStageEnd(true)
    end
    
    --检测怪是否被坑杀
    if self.m_bIsSingleChallengeGameOver == false then
        local index = 0
        -- local turnTimes = WBattleGlobal:getCurrent().m_nTurnTimes
        -- local record = WBattleGlobal:getCurrent().m_tBattleRecord[turnTimes]
        -- if not record then
        --     return
        -- end

        for id, guai in pairs(self:getGuaiList()) do
            index = index + 1
            local _,isHole = guai:checkIsOutOfScene()
            if isHole == true and SceneBattle:getBattleLoop():getBattleStatus() ~= BattleLoop.S_PLAYER_FLY then
                if guai:isDead() == false then
                    -- record.guaiIsHole[index] = true
                    self:setHoldMonsterRecord(guai:getBattleId())
                    --设置坑杀怪物
                    guai:setDead(true,1)
                    WBattleGlobal:getCurrent().m_nSingleActivityMemberIndex = WBattleGlobal:getCurrent().m_nSingleActivityMemberIndex + 1

                    if self:getCurrentCharacterId() == guai:getBattleId() then
                        WBattleGlobal:getCurrent():endCurRound(WBattleGlobal:getCurrent():getMyBattleId(),100)
                    end
                end
            end
            if self.m_tHoleGuaiList ~= nil then
                for i, v in pairs(self.m_tHoleGuaiList) do
                    WZLog("self.m_tHoleGuaiList", v, guai:getId())
                    if guai:getId() == v then                            
                        if self.m_tHoleGuaiList ~= nil and #self.m_tHoleGuaiList >= 1 then
                            WZLog("self.m_tHoleGuaiList ok", v, guai:getId())
                            table.remove(self.m_tHoleGuaiList, i)
                        end
                    end
                end
            end
        end
    elseif self.m_tHoleGuaiList ~= nil and #self.m_tHoleGuaiList == 0 then
        WZLog("检测怪是否被坑杀 ", deadGuaiCount, BattleCommon:tableLen(self:getGuaiList()))
        self.m_bIsSingleChallengeGameOver = true
        self:singleStageEnd(true)
    end
    
    --检测怪是否全灭
    local isAllMonsterDead = false
    local deadGuaiCount = 0
    for id, guai in pairs(self:getGuaiList()) do
        --WZLog("检测怪是否全灭", id)
        if guai:isDead() == false and guai:getHp() <= 0 then
            guai:setDead(true,2)
            WBattleGlobal:getCurrent().m_nSingleActivityMemberIndex = WBattleGlobal:getCurrent().m_nSingleActivityMemberIndex + 1
        end
        if guai:getHp() <= 0 or guai:getCamp() == self:getMyHero():getCamp() then
            deadGuaiCount = deadGuaiCount + 1
        end
    end
    if self.m_bIsSingleChallengeGameOver == false and  (BattleCommon:tableLen(self:getGuaiList()) == 0 or deadGuaiCount >= BattleCommon:tableLen(self:getGuaiList()))then
        WZLog("检测怪是否全灭 ", deadGuaiCount, BattleCommon:tableLen(self:getGuaiList()))
        self.m_bIsSingleChallengeGameOver = true
        if self.m_bIsCleanWithGuaiDestroy == true or self.m_tCleanConditionList == nil then
            self:singleStageEnd(true)
        else
            self:singleStageEnd(false)
        end
    end
    --检测英雄是否死亡
    if self:getCurrentCharacterId() == myHero:getId() then
        self:checkIsHeroHole()
    end
end

function WBattleGlobal:checkEnemyDead()
    -- body
end

function WBattleGlobal:testCopyEnd(isWin)
    isWin = isWin and true or false
    if self.m_copyData and not self.m_copyData.m_bIsEnd then
       self:setGameOver(true)
       self.m_copyData:copyEnd()
       return
    end
    self.m_bIsSingleChallengeGameOver = true
    self:singleStageEnd(isWin)
end

--@brief 间隔时间输出（毫秒）
function WBattleGlobal:showOsTime(flag)
    local curTime = math.floor(WZThread:getUTickCount()/1000)
    if self.m_nOsTime then
        WZLog("WBattleGlobal:showOsTime",flag,curTime - self.m_nOsTime)
    end
    self.m_nOsTime = curTime
end

--@brief 首杀消失
function WBattleGlobal:removeKillAnim()
    WZLog("WBattleGlobal:removeKillAnim")
    GetElement(WndBattleHud.m_root,"conKill_WndBattleHud"):setVisible(false)
    GetElement(WndBattleHud.m_root,"conKill2_WndBattleHud"):setVisible(false)
    if self.m_tKillHead then
        self.m_tKillHead:getAnimNode():removeFromParentAndCleanup(true)
        self.m_tKillHead2:getAnimNode():removeFromParentAndCleanup(true)
        self.m_tKillHead = nil
        self.m_tKillHead2 = nil
        self.m_tKillAnim:getAnimNode():removeFromParentAndCleanup(true)
        self.m_tKillAnim = nil
    end
    if self.m_tKillAnim2 then
        self.m_tKillAnim2:getAnimNode():removeFromParentAndCleanup(true)
        self.m_tKillAnim2 = nil
    end

end

--@brief 首杀消失定时器
function WBattleGlobal:updateRemoveKillAnim()
    if self.m_nShowKillTime > 0 and os.time() - self.m_nShowKillTime > 4 then
        self.m_nShowKillTime = -1

        local con1 = GetElement(WndBattleHud.m_root,"imgFigure_WndBattleHud",WZUIImage)
        local con2 = GetElement(WndBattleHud.m_root,"imgFigure2_WndBattleHud",WZUIImage)
        local con3 = GetElement(WndBattleHud.m_root,"imgFigureBg_WndBattleHud",WZUIImage)
        local con4 = GetElement(WndBattleHud.m_root,"imgFigureBg2_WndBattleHud",WZUIImage)
        local con5 = self.m_tKillHead:getAnimNode()
        local con6 = self.m_tKillHead2:getAnimNode()
        local con7 = GetElement(WndBattleHud.m_root,"imgNumKillBg_WndBattleHud",WZUIImage)
        local con8 = GetElement(WndBattleHud.m_root,"imgNumKill_WndBattleHud",WZUIImage)

        ---[[
        local time = 0.5
        local actionSeq = WZUIActionSequence:create()
        local action1 = WZUIActionFadeTo:create()
        action1:setDuration(time)
        action1:setOpacity(0)
        actionSeq:setChildAction(action1)
        con1:runUIAction(actionSeq)

        local actionSeq = WZUIActionSequence:create()
        local action1 = WZUIActionFadeTo:create()
        action1:setDuration(time)
        action1:setOpacity(0)
        actionSeq:setChildAction(action1)
        con2:runUIAction(actionSeq)

        local actionSeq = WZUIActionSequence:create()
        local action1 = WZUIActionFadeTo:create()
        action1:setDuration(time)
        action1:setOpacity(0)
        actionSeq:setChildAction(action1)
        con3:runUIAction(actionSeq)

        local actionSeq = WZUIActionSequence:create()
        local action1 = WZUIActionFadeTo:create()
        action1:setDuration(time)
        action1:setOpacity(0)
        actionSeq:setChildAction(action1)
        con4:runUIAction(actionSeq)

        local actionSeq = WZUIActionSequence:create()
        local action1 = WZUIActionFadeTo:create()
        action1:setDuration(time)
        action1:setOpacity(0)
        actionSeq:setChildAction(action1)
        con5:runUIAction(actionSeq)

        local actionSeq = WZUIActionSequence:create()
        local action1 = WZUIActionFadeTo:create()
        action1:setDuration(time)
        action1:setOpacity(0)
        actionSeq:setChildAction(action1)
        con6:runUIAction(actionSeq)

        local actionSeq = WZUIActionSequence:create()
        local action1 = WZUIActionFadeTo:create()
        action1:setDuration(time)
        action1:setOpacity(0)
        actionSeq:setChildAction(action1)
        con7:runUIAction(actionSeq)

        local actionSeq = WZUIActionSequence:create()
        local action1 = WZUIActionFadeTo:create()
        action1:setDuration(time)
        action1:setOpacity(0)
        action1:setFinishLuaFunction("removeKillAnim")
        action1:setFinishLuaTable(self)
        actionSeq:setChildAction(action1)
        con8:runUIAction(actionSeq)
        --]]
    end
end

--@brief	操作范围更新函数
function WBattleGlobal:updateTouchCircle()
    if self:getMyHero() == nil then
        return
    end

    local pos = self:getMyHero():getPosition()
    local width = BattleMapManager.m_nWidth

    local distanceX = math.abs(pos.x - width) > pos.x and pos.x or math.abs(pos.x - width)
    local distanceY = pos.y
    local scale = WBattleGlobal:getCurrent().m_nScale
    --WZLog("WBattleGlobal:updateTouchCircle",distanceX,distanceY,scale,width,pos.x,pos.y)
    if (distanceX <= BattleConstants.g_nEdgeValue1 or distanceY <= BattleConstants.g_nEdgeValue1) and scale ~= 2 then
        WndBattleHud:onScale(nil,nil,nil,1)
    elseif ((distanceX > BattleConstants.g_nEdgeValue1 and distanceX <= BattleConstants.g_nEdgeValue2) or (distanceY > BattleConstants.g_nEdgeValue1 and distanceY <= BattleConstants.g_nEdgeValue2)) and scale ~= 1 then
        WndBattleHud:onScale(nil,nil,nil,0)
    end
end

function WBattleGlobal:addLight()
    if not WBattleGlobal:getCurrent():isReplayGame() and WBattleGlobal:getCurrent().m_tTouchCircle == nil then
        --创建角色指示光圈
        if TeachGroup1.ISBATTLE ~= true then
            self.m_nScale = WndBattleHud:getScaleData()
        end
        WZLog("WBattleGlobal:addLight", self.m_nScale)
        local myhero = WBattleGlobal:getCurrent():getMyHero()
        local anim = BattleAnimation:createAnimation("battle_hud",false, "battle/ui")
        anim:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0))

        if false and myhero.m_bIsMonster then
            --anim:getAnimNode():setPosition(300,75)
            if myhero.m_nMonsterId == 4 then
                anim:getAnimNode():setRelativePositionLuaTo(0.2,0.5)
            else
                anim:getAnimNode():setRelativePositionLuaTo(0.4,0.5)
            end
        else
            anim:getAnimNode():setRelativePositionLuaTo(0.5,0.7)
        end
        anim:getAnimNode():setAnimationName("animation")
        anim:getAnimNode():setLoop(true)
        --

        if WBattleGlobal:getCurrent():isFog() then
            SceneBattle:getInfoLayer2():addChild(anim:getAnimNode(),0)
            anim:getAnimNode():setUseAbsCoordinate(true)
            anim:getAnimNode():setTouchEnable(false)
            anim:setScale(300/680)
            WBattleGlobal:getCurrent().m_tTouchCircle = anim
            if TeachGroup1.ISBATTLE ~= true then
                WndBattleHud:onScale(nil, nil, nil, WndBattleHud:getScaleData(),true)
            end
        else
            myhero:getAnimation():getAnimNode():addChild(anim:getAnimNode())
            anim:setScale(300/680)
            WBattleGlobal:getCurrent().m_tTouchCircle = anim
        end

        WndBattleHud:updateScaleBtnShow()
    elseif WBattleGlobal:getCurrent().m_tTouchCircle then
        local scalef = SceneBattle:getFrontLayer():getScale()
        local scaleMonsterMode = 1
        if WBattleGlobal:getCurrent().m_tMakePairOk.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_GS and WBattleGlobal:getCurrent():getMyHero().m_nCamp == 1 then
            scaleMonsterMode = 2
        end
        if WBattleGlobal:getCurrent():isFog() then
            if WBattleGlobal:getCurrent().m_nScale == 1 then
                WBattleGlobal:getCurrent().m_tTouchCircle:setScale(
                (300 + BattleConstants.g_nTouchDistance * 2 * WBattleGlobal:getCurrent().m_nScale)/680 / 2.5 / 0.6 * scalef/scaleMonsterMode)
            elseif WBattleGlobal:getCurrent().m_nScale == 1 then
                WBattleGlobal:getCurrent().m_tTouchCircle:setScale(
                (300 + BattleConstants.g_nTouchDistance * 2 * WBattleGlobal:getCurrent().m_nScale)/680 / 3.3 / 0.6 * scalef/scaleMonsterMode)
            end
            local heroPos = WBattleGlobal:getCurrent():getMyHero():getAnimation():getPosition()
            local pos = SceneBattle:getFrontLayer():convertToWorldSpaceAuto(CCAutoPoint:create(heroPos.x,heroPos.y+35))
            pos = SceneBattle:getInfoLayer2():convertToNodeSpaceAuto(pos)
            pos = GlobalMethod:ccp(pos.x, pos.y)

            WBattleGlobal:getCurrent().m_tTouchCircle:getAnimNode():setAbsPosition(pos)
        else
            WBattleGlobal:getCurrent().m_tTouchCircle:setScale((300 + BattleConstants.g_nTouchDistance * 2 * WBattleGlobal:getCurrent().m_nScale)/680/scaleMonsterMode)
             if WBattleGlobal:getCurrent().m_nScale == 1 then
                WBattleGlobal:getCurrent().m_tTouchCircle:getAnimNode():setOpacity(150)
                WBattleGlobal:getCurrent().m_tTouchCircle:getAnimNode():setRelativePositionLuaTo(0.5,0.7)
            else
                WBattleGlobal:getCurrent().m_tTouchCircle:getAnimNode():setOpacity(255)
                WBattleGlobal:getCurrent().m_tTouchCircle:getAnimNode():setRelativePositionLuaTo(0.5,0.7)
            end
        end

       
    end
end

--@brief	定时更新函数
--@param	dt:距离上一次调用的时间（秒）
--@note		由定时器调用
function WBattleGlobal:update(dt)
    self:addLight()
    self:updateNameInfoIcon(dt)
	if self.m_battleManager ~= nil then
		--self.m_battleManager:update()
	end

    --self:updateTouchCircle()
    self:updateRemoveKillAnim()

    if WndBattleHud.m_nShowBigCtb then
        local dtTime = SceneBattle:getBattleLoop():getBattleDeltaTime()
        WndBattleHud.m_nShowBigCtb = WndBattleHud.m_nShowBigCtb + dtTime
        --WZLog("WndBattleHud:updateTurnTime one", WndBattleHud.m_nShowBigCtb, dtTime)
        if WndBattleHud.m_nShowBigCtb >= 2 then
            WndBattleHud.m_nShowBigCtb = nil
            BattleCtbManager:showBigCtb(false)
            if WndBattleHud.m_tMedalList and #WndBattleHud.m_tMedalList > 0 then
                for i, medal in pairs(WndBattleHud.m_tMedalList) do
                    medal:setVisible(true)
                end
            end
        end
    end

    -- if WBattleGlobal:getCurrent().m_nTreasureRound == WBattleGlobal:getCurrent().m_nTurnTimes then
    -- 	WBattleGlobal:getCurrent():buildTreasure(WBattleGlobal:getCurrent().m_tTreasureAppearList)
    -- 	WBattleGlobal:getCurrent().m_tTreasureAppearList = nil
    -- 	WBattleGlobal:getCurrent().m_nTreasureRound = -1
    -- end
    --update每个宝箱的状态
    if self.m_tTreasureList ~= nil then
        for i, v in pairs(self.m_tTreasureList) do
            if v.m_tSprite ~= nil then
                if #self.m_tTreasureList <= self.m_nTreasureCountMax then
                    v:update(dt)
                end
            else
                table.remove(self.m_tTreasureList, i)
            end
        end
    end

    --更新单人副本
    self:updateSingleMap(dt)

    --更新地图事件
    if self.m_tMapEvents ~= nil and #self.m_tMapEvents > 0  then
        for i, event in pairs(self.m_tMapEvents) do
            event:update(dt)
        end
    end

    --[[
    if SceneBattle.m_nMapEventShow > 0 and SceneBattle.m_bRunTurnShow ~= true then
        SceneBattle:mapEvenShow(SceneBattle.m_nMapEventShow)
    end
    --]]

	--更新英雄
	for id, hero in pairs(self.m_tHeros) do
		if hero:getIsExist() then
			hero:update(dt)
		end
	end

	--更新怪物
	for id, guai in pairs(self:getGuaiList()) do
		if guai:getIsExist() then
			guai:update(dt)
		end
	end

    --更新机关
    for id,machine in pairs(self:getMachinesList()) do
        --WZLog("updateMachine",machine:getPosition().x,machine:getPosition().y)
        machine:update(dt)
    end
	


	--更新指示箭头位置
	local currentPlayer = self:getCurrentCharacter()
    --WZLog("WBattleGlobal:update arrow one",tostring(currentPlayer), tostring(self.m_CurrentPlayerArrow), tostring(self.m_bHideArrow), tostring(currentPlayer:getType()))
    if self.m_CurrentPlayerArrow then
        if currentPlayer ~= nil and (self.m_bHideArrow == nil or currentPlayer:getType() == 0) then
            if WBattleGlobal:getCurrent():isReplayGame() or currentPlayer:isHide()==false or self:isMyTeam(currentPlayer:getBattleId()) then
    			self.m_CurrentPlayerArrow:setPosition(currentPlayer:getArrowPosition().x,currentPlayer:getArrowPosition().y)
    			self.m_CurrentPlayerArrow:setVisible(true)
                --WZLog("WBattleGlobal:update arrow  two",currentPlayer:getArrowPosition().x, currentPlayer:getArrowPosition().y)
    		else
    			self.m_CurrentPlayerArrow:setVisible(false)
    		end
    	else
    		self.m_CurrentPlayerArrow:setVisible(false)
    	end
    end
    
	--更新AI
	if currentPlayer ~= nil and currentPlayer:getAI() and currentPlayer:getType() == 0 then
		currentPlayer:getAI():run(dt)
	end

	-- --发送心跳协议
	-- if self.m_fShakeHands == nil then 
 --        self.m_fShakeHands = 0;
 --    end 
	-- if os.time() - self.m_fShakeHands > BattleConstants.g_fShakeHandsTime and NetManager.g_bConnectFailed ~= true then
	-- 	self.m_fShakeHands = os.time()
 --        WZLog("send battle handshake")
 --        ProtocolProcessorBattleInterface:send_SYSTEM_BattleShakeHands(self.m_tMakePairOk.battleId)
	-- end

    if WBattleGlobal:getCurrent():isAudience() then
        BattleAudienceManager:update()
    end

    BattlePetSkillManager:update()

    if not WBattleGlobal:getCurrent():isAudience() and not WBattleGlobal:getCurrent():isReplayGame() and (not WBattleGlobal:getCurrent():isSingleStage()) and WBattleGlobal:getCurrent().m_nRelinkLoading == -1 and self:isGameOver() ~= true then
        self:updateNetTip()
    end

    WBattleGlobal:getCurrent():updateHideView()

    if WBattleGlobal:getCurrent():isGhostStage() then 
        WndBattleHud:pickGhostSkillUpdate(dt)
    end
end

--@brief 聚光灯逻辑检测
function WBattleGlobal:checkMachineLight()
    local isCheck = false
    if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS then
        if WBattleGlobal:getCurrent().m_tMakePairOk.mapId == 20501 or WBattleGlobal:getCurrent().m_tMakePairOk.mapId == 20502 or WBattleGlobal:getCurrent().m_tMakePairOk.mapId == 20503 then
            isCheck = true
        end
    end
    if not isCheck then
        return
    end

    local list = {}
    local mainLight = nil
    for i,v in pairs(WBattleGlobal:getCurrent():getMachinesList()) do
        if v.m_nMonsterType == MonsterType.BOSS_LIGHT then
            table.insert(list,v)
        end
    end
    if #list == 0 then
        return
    end
    local collsionCount = 0
    local heroCount = 0
    for i,v in pairs(WBattleGlobal:getCurrent():getHeroList()) do
        if not v:isDead() and not v.m_bLoseNet then
            heroCount = heroCount + 1
        end
    end

    for i,v in pairs(list) do
        if not mainLight then
            mainLight = v
        end
        collsionCount = collsionCount + v:checkCollision()
    end
    if heroCount == collsionCount then
        mainLight:doEffect()
    end
end

--@brief    更新网络提示内容
function WBattleGlobal:updateNetTipContent(content, type)
    --WZLog("WBattleGlobal:updateNetTipContent one", WBattleGlobal:getCurrent().m_nNetLoading, tostring(content))
    if WBattleGlobal:getCurrent().m_nNetLoading == -1 then
        WBattleGlobal:getCurrent().m_nNetLoading = MsgBoxManager:showLoadingBox(9999999,nil,nil,nil,nil,nil,content)
    else
        local isNoSwallowTouch = nil 
        if type == 2 then
            isNoSwallowTouch = true
        end
        local id = MsgBoxManager:showLoadingBox(9999999,nil,nil,nil,nil,nil,content,nil,isNoSwallowTouch)
        if id then
            WZLog("WBattleGlobal:updateNetTipContent two", id)
            MsgBoxManager:stopLoadingBoxByMsgId(WBattleGlobal:getCurrent().m_nNetLoading)
            WBattleGlobal:getCurrent().m_nNetLoading = id
        end
    end

end

--@brief    更新网络提示函数
function WBattleGlobal:updateNetTip()
    if self.m_bSendCurRoundInfo == -1 then 
        if WBattleGlobal:getCurrent().m_nNetLoading ~= -1 then
            MsgBoxManager:stopLoadingBoxByMsgId(WBattleGlobal:getCurrent().m_nNetLoading)
            WBattleGlobal:getCurrent().m_nNetLoading = -1
        end
        return 
    end
    local isMyturn = self:isMyTurn()
    --WZLog("WBattleGlobal:updateNetTip_one", tostring(isMyturn))

    if self.m_nSendCurRoundInfoTimer == -1 then
        self.m_nSendCurRoundInfoTimer = os.time()
        WZLog("WBattleGlobal:updateNetTip zero")
    elseif os.time() - self.m_nSendCurRoundInfoTimer >= 7 then
        local content = LocalStrings.WIFFTP1

        local count = #WBattleGlobal:getCurrent().m_bSendCurRoundInfoLisk
        WZLog("WBattleGlobal:updateNetTip one", count, WBattleGlobal:getCurrent().m_bSendCurRoundInfoOk)
        if WBattleGlobal:getCurrent().m_bSendCurRoundInfoOk == -1 then
            if self.m_nShowNetTipType ~= 1 then
                content = LocalStrings.WIFFTP1
                self:updateNetTipContent(content,1)
                self.m_nShowNetTipType = 1
            end
        elseif WBattleGlobal:getCurrent().m_bSendCurRoundInfoOk ~= -1 then
            local isExist = false
            for index, id in pairs (WBattleGlobal:getCurrent().m_bSendCurRoundInfoLisk) do
                if self.m_nShowNetTipId == id then
                    isExist = true
                end
            end

            WZLog("WBattleGlobal:updateNetTip two", tostring(isExist))
            if isExist == false then
                for i, v in pairs (self:getHeroList()) do
                    if v:getBattleId() ~= self:getMyHero():getBattleId() then
                        local isReceive = false
                        for index, id in pairs (WBattleGlobal:getCurrent().m_bSendCurRoundInfoLisk) do
                            if id == v:getBattleId() then
                                isReceive = true
                            end
                        end
                        WZLog("WBattleGlobal:updateNetTip three", v:getBattleId(), tostring((not v:isCanControl())), tostring(isReceive))
                        if (not v:isCanControl()) and isReceive == false then
                            content = string.format(LocalStrings.WIFFTP2, v.m_sPlayerName)
                            self:updateNetTipContent(content,2)
                            self.m_nShowNetTipType = 2
                            self.m_nShowNetTipId = v:getBattleId()
                            break
                        end
                    end
                end
            end
        end
    end
end

--@brief	获取小怪id
--@param	nCount:申请的数量
--@return	#1:小怪id列表
function WBattleGlobal:requestGuaiBattleId(nCount)
	local tBattleId = nil
	if nCount <= #self.m_tGuaiBattleId then
		tBattleId = {}
		for i=1,nCount do
			table.insert(tBattleId,self.m_tGuaiBattleId[1])
			table.remove(self.m_tGuaiBattleId,1)
		end
	end

	if self.m_bIsRequestingId == false then
		local nTmpCount = (nCount <= 10 and 10) or nCount
		if #self.m_tGuaiBattleId < nTmpCount then
			self.m_bIsRequestingId = true
			--ProtocolProcessorBattleInterface:send_BATTLE_RequestGuaiBattleId(self.m_tMakePairOk.battleId, nTmpCount )
		end
	end

	return tBattleId
end

--@brief	是否有角色受伤(包括英雄和怪物)
--@return	#1:true,false
function WBattleGlobal:IsAnyOneHurt()
	for key,hero in pairs(self:getHeroList()) do
		if hero:getMarkHurt() and not hero:isDead() and hero:getHp() > 0 then
            return true , hero:getBattleId()
		end
	end
	for key,guai in pairs(self:getGuaiList()) do
		if guai:getMarkHurt() and not guai:isDead() and guai:getHp() > 0 then
			return true, guai:getBattleId()
		end
	end
	return false
end

--@brief	清理伤害标记
function WBattleGlobal:ClearHurt()
    local list = WBattleGlobal:getCurrent():getCharacterList()
    for id, combat in pairs (list) do
        combat.m_bIsHurt = false
    end
end

--@brief	是否有英雄在空中(不包括怪物)
--@return	#1:true,false
function WBattleGlobal:IsAnyHeroInAir()
	for key,hero in pairs(self:getHeroList()) do
		if not hero:isDead() and hero:isInAir() and not hero:isOutOfScene() then
			return true
		end
	end
	return false
end

--@brief	是否有怪物在空中
--@return	#1:true,false
function WBattleGlobal:IsAnyGuaiInAir()
	for key,guai in pairs(self:getGuaiList()) do
		if guai:isInAir() then
			return true
		end
	end
	return false
end

--@brief	发送受伤协议(带吸血效果)
--@param	idWhoSend:谁发送的
--@param	charas:受伤英雄列表
--@param	values:受伤值
--@param	isPetAttack:是否宠物攻击
function WBattleGlobal:sendHurtProtocol(idWhoSend,charas,values,distance,critType,isPetAttack,hurtParm)
    local senderChara = self:getCharacterWithId(idWhoSend)
    local canSendMonster = false
    canSendMonster = WMonster:canSendHurtByType(senderChara.m_nMonsterType)
    
	if not canSendMonster and not (senderChara:isCanControl() or senderChara.m_bLoseNet) then
		return
	end
	local hurtCount = 0
	local hurtIds = WZLuaVector_int_:create()
	local hurtValues = WZLuaVector_int_:create()
	local hurtGuaiCount = 0
	local hurtGuaiIds = WZLuaVector_int_:create()
	local hurtGuaiValues = WZLuaVector_int_:create()

    local tDistance = WZLuaVector_int_:create()
    local tCritType = WZLuaVector_int_:create()
    local invincibleRound = WZLuaVector_int_:create()
    local defend = WZLuaVector_int_:create()
    local injuryFree = WZLuaVector_int_:create()
    local isHide = WZLuaVector_bool_:create()

    local hurtType = 0
    WZLog("WBattleGlobal:sendHurtProtocol zero", tostring(isPetAttack), tostring(distance))
    if isPetAttack ~= nil and isPetAttack == true then
        hurtType = -2
    elseif distance == nil then

    end

    local attack = senderChara:getAttack()
    local wreckDefense = senderChara:getWreckDefense()
    local critRate = senderChara:getCriticalhitAttackRate()
    local attackPercent = senderChara:getAttPercent()
    local radiusForBulletExplode = senderChara:getRadiusForBulletExplode()
    local addAttackValue = senderChara.m_nAddAttackValue
    local petAttackPercent = 0
    if senderChara:getPet() ~= nil then
        petAttackPercent = senderChara:getPet().m_tPetInfo.petParam1
    end

    local bigSkillType = senderChara:getBigSkillType()
    if senderChara:getUseBigSkill() ~= true then
        bigSkillType = -1
    end
    local attackTimes = senderChara:getAttTimes()
    local scatterCount = senderChara:getAttScatterNum()
    local wind = self:getWindLevel()
    local pf = senderChara:getPF()
    local sp = senderChara:getSp()
    local hurtFloat = 4
    if #WBattleGlobal:getCurrent().m_tBattleRand > 0 then			--随机数
        hurtFloat = WBattleGlobal:getCurrent().m_tBattleRand[1] % 9
    end

    local targetRandom  = WBattleGlobal:getCurrent().m_tTargetRandomList
    local attackerRandom = WBattleGlobal:getCurrent().m_tAttackRandomList

    local ttargetRandom = WZLuaVector_int_:create()
    local tattackerRandom = WZLuaVector_int_:create()

	for id,chara in pairs(charas) do

        invincibleRound:push(0)
        defend:push(chara:getDefence())
        injuryFree:push(chara:getInjuryFree())
        isHide:push(chara:isHide())
        if (isPetAttack ~= nil and isPetAttack == true) or distance == nil  then
            tDistance:push(0)
            tCritType:push(0)
        else
            tDistance:push(distance[id])
            tCritType:push(critType[id])
        end
        local playerId = chara:getBattleId()

			hurtIds:push(chara:getBattleId())
			hurtValues:push(values[id])
			hurtCount = hurtCount + 1

        local tHurtIds = VectorToTable(hurtIds)
        local tHurtValues = VectorToTable(hurtValues)
        local ttDistance = VectorToTable(tDistance)
        local ttCritType = VectorToTable(tCritType)
        --WZLog("WBattleGlobal:sendHurtProtocol_zero1", hurtType, hurtCount, tostring(tHurtIds[hurtCount]), tostring(tHurtValues[hurtCount]), tostring(ttDistance[hurtCount]), tostring(ttCritType[hurtCount]))
        WZLog("WBattleGlobal:sendHurtProtocol_zero2", Serialize(tHurtIds), Serialize(tHurtValues), Serialize(ttDistance))
        local isHaveSkill = false
        if targetRandom ~= nil then
            local isS1EqualS2 = false
            if chara.m_tWeaponSkillType ~= nil and chara.m_tWeaponSkillType[1] ~= nil and chara.m_tWeaponSkillType[2] ~= nil and chara.m_tWeaponSkillType[1] == chara.m_tWeaponSkillType[2] then
                isS1EqualS2 = true
            end
            for i = 1, 2 do
                local isExist = false
                isHaveSkill = false
                for j, v in pairs(targetRandom) do
                    if id == v[1] then
                        if isS1EqualS2 == false then
                            if chara.m_tWeaponSkillType ~= nil and chara.m_tWeaponSkillType[i] == v[2] then
                                ttargetRandom:push(v[3] - 1)
                                isHaveSkill = i
                                --WZLog("WBattleGlobal:sendHurtProtocol three-1", id, i, j, tostring( chara.m_tWeaponSkillType[i]), tostring(v[3] - 1), #chara.m_tWeaponSkillType)
                            end
                        else
                            if isExist == false and i == 1 and chara.m_tWeaponSkillType ~= nil and chara.m_tWeaponSkillType[i] == v[2] then
                                isExist = true
                                ttargetRandom:push(v[3] - 1)
                                isHaveSkill = i
                                --WZLog("WBattleGlobal:sendHurtProtocol three-2", id, i, j, tostring( chara.m_tWeaponSkillType[i]), tostring(v[3] - 1), #chara.m_tWeaponSkillType)
                            elseif isExist == false and i == 2 and chara.m_tWeaponSkillType[i] == v[2] then
                                isExist = true
                            elseif isExist == true and i == 2 and chara.m_tWeaponSkillType[i] == v[2] then
                                isExist = true
                                ttargetRandom:push(v[3] - 1)
                                isHaveSkill = i
                                --WZLog("WBattleGlobal:sendHurtProtocol three-3", id, i, j, tostring( chara.m_tWeaponSkillType[i]), tostring(v[3] - 1), #chara.m_tWeaponSkillType)
                            end
                        end
                    end
                end
                if isHaveSkill == false then
                    ttargetRandom:push(-1)
                    --WZLog("WBattleGlobal:sendHurtProtocol four", i,  tostring( chara.m_tWeaponSkillType[i]))
                end
            end
        else
            for i = 1, 2 do
                ttargetRandom:push(-1)
            end
        end

        --伤害来自被动技能
        if distance == nil then
            if chara.m_tHurtAnim ~= nil and (isPetAttack == nil or isPetAttack == false) then
                if chara.m_tHurtAnim["butn"] ~= nil then
                    hurtType = 4
                elseif chara.m_tHurtAnim["poison"] ~= nil then
                    hurtType = 12
                elseif chara.m_tHurtAnim["ice"] ~= nil then
                    hurtType = 13
                end
            end
        end
	end

    WBattleGlobal:getCurrent().m_tTargetRandomList = {}

    local isHaveSkill = false
    if attackerRandom ~= nil then
        for i = 1, 2 do
            isHaveSkill = false
            for j, v in pairs(attackerRandom) do
                if senderChara.m_tWeaponSkillType[i] == v[2] then
                    tattackerRandom:push(v[3] - 1)
                    isHaveSkill = i
                    --WZLog("WBattleGlobal:sendHurtProtocol five", i, j, tostring( senderChara.m_tWeaponSkillType[i]), v[2], tostring(v[3] - 1), #senderChara.m_tWeaponSkillType)
                end
            end
            if isHaveSkill == false then
                tattackerRandom:push(-1)
                --WZLog("WBattleGlobal:sendHurtProtocol six", i,tostring( senderChara.m_tWeaponSkillType[i]))
            end
        end
    else
        for i = 1, 2 do
            tattackerRandom:push(-1)
        end
    end

	local returnBloodRate = senderChara.m_nBloodsuckingRate or 0
    local attackIndex = nil
    local bossBeFrozen = nil

	if true or hurtCount > 0 or hurtGuaiCount > 0 then
        if WBattleGlobal:getCurrent().m_nBattleType ~= BattleConstants.g_nBATTLE_TYPE_BOSS then
            attackIndex = nil
            bossBeFrozen = nil
        elseif isPetAttack == true then
            hurtType = -2
            attackIndex = -1
            bossBeFrozen = false
        else
            hurtType = 0
            attackIndex = 0
            bossBeFrozen = false
        end

        if hurtParm  ~= nil then
            hurtType = hurtParm
        end
           ProtocolProcessorBattleInterface:send_BATTLE_Hurt(self.m_tMakePairOk.battleId, idWhoSend, hurtIds, hurtValues, tDistance)
	end
end

--@brief	开启玩家下落检测
function WBattleGlobal:enableAllHeroFallDown()
	for id,hero in pairs(self:getHeroList()) do
		hero:setMoveUpdatable(true)
	end
end

--@brief	获取自己房间ID
--@return	#1:战斗类型
function WBattleGlobal:getMyRoomId()
	return self:getMyHero():getRoomId()
end

--@brief	获取战斗类型
--@param	type:战斗类型
function WBattleGlobal:setBattleType(type)
	self.m_nBattleType = type
end

--@brief	获取战斗类型
--@return	#1:战斗类型
function WBattleGlobal:getBattleType()
	return self.m_nBattleType
end

--@brief	获取子弹列表
--@return	#1:子弹列表
function WBattleGlobal:getBulletsList()
	return self.m_tBullets
end

--@brief	通过表下标获取子弹
--@param	nIndex:表下标
--@return	#1:子弹
function WBattleGlobal:getBulletByIndex(nIndex)
	return self.m_tBullets[nIndex]
end

--@brief	通过表下标移除子弹
--@param	nIndex:表下标
function WBattleGlobal:removeBulletByIndex(nIndex)
	if nIndex <= #self.m_tBullets then
		table.remove(self.m_tBullets,nIndex)
	end
end

--@brief	清空子弹列表
function WBattleGlobal:clearBulletsList()
    if self.m_tBullets then
        for i,bullet in pairs(self.m_tBullets) do
            if bullet and bullet:getIsExist() then
                bullet:destroy()
            end
        end
    end
	self.m_tBullets = {}
end

--@brief	获取子弹列表
--@return	#1:子弹列表
function WBattleGlobal:getBossBulletsList()
	return self.m_tBossBullets
end

--@brief 获取机关
function WBattleGlobal:getMachinesList()
    return self.m_tMachines
end

--@brief 获取机关对象列表 （按id排序）
--@return #1:角色对象列表
function WBattleGlobal:getMachinesSortList()
    local list = {}
    for id,hero in pairs(self.m_tMachines) do
        table.insert(list,hero)
    end
    local sortFunc = function(a, b) return b:getBattleId() < a:getBattleId() end
    table.sort(list,sortFunc)
    return list
end

--@brief	通过表下标获取子弹
--@param	nIndex:表下标
--@return	#1:子弹
function WBattleGlobal:getBossBulletByIndex(nIndex)
	return self.m_tBossBullets[nIndex]
end

--@brief    通过表下标获取子弹
--@param    nIndex:表下标
--@return   #1:子弹
function WBattleGlobal:getBossBulletByBattleId(battleId)
    local list = {}
    for i,bullet in pairs(self.m_tBossBullets) do
        if bullet:getOwnerChara():getBattleId() == battleId then
            table.insert(list,bullet)
        end
    end
    return list
end

--@brief	通过表下标移除子弹
--@param	nIndex:表下标
function WBattleGlobal:removeBossBulletByIndex(nIndex)
	if nIndex <= #self.m_tBossBullets then
		table.remove(self.m_tBossBullets,nIndex)
	end
end

--@brief	清空子弹列表
function WBattleGlobal:clearBossBulletsList()
    if self.m_tBossBullets then
        for i,bullet in pairs(self.m_tBossBullets) do
            if bullet and bullet:getIsExist() then
                bullet:destroy()
            end
        end
    end
	self.m_tBossBullets = {}
end

--@brief	获取角色对象列表
--@return	#1:角色对象列表
function WBattleGlobal:getHeroList()
	return self.m_tHeros
end

--@brief 获取角色对象列表 （按id排序）
--@return #1:角色对象列表
function WBattleGlobal:getHeroSortList()
    local list = {}
    for id,hero in pairs(self.m_tHeros) do
        table.insert(list,hero)
    end
    local sortFunc = function(a, b) return b:getBattleId() < a:getBattleId() end
    table.sort(list,sortFunc)
    return list
end

--@brief 获取怪物对象列表 （按id排序）
--@return #1:角色对象列表
function WBattleGlobal:getGuaiSortList()
    local list = {}
    for id,hero in pairs(WBattleGlobal:getCurrent():getGuaiList()) do
        table.insert(list,hero)
    end
    local sortFunc = function(a, b) return b:getBattleId() < a:getBattleId() end
    table.sort(list,sortFunc)
    return list
end

--@brief 获取非机器怪物对象列表 （按id排序）
--@return #1:角色对象列表
function WBattleGlobal:getNoMachineGuaiSortList()
    local list = {}
    for id,hero in pairs(WBattleGlobal:getCurrent():getGuaiList()) do
        if hero:getType() == 1 then
            table.insert(list,hero)
        end
    end
    local sortFunc = function(a, b) return b:getBattleId() < a:getBattleId() end
    table.sort(list,sortFunc)
    return list
end

--@brief	玩家逃跑
--@param	nId:逃跑玩家id
function WBattleGlobal:setHeroExitWithId(nId)
    WZLog("WBattleGlobal:setHeroExitWithId", nId)
	for id,hero in pairs(self.m_tHeros) do
		if id == nId then
            WZLog("WBattleGlobal:setHeroExitWithId two", nId)
			self.m_tExitHeros[id] = hero
			hero:setHp(0)
			if hero:getAnimation():getAnimNode() then
				hero:getAnimation():getAnimNode():setVisible(false)
			end
			if hero:getPlayerNameIcon() then				
				hero:getPlayerNameIcon():destroy()
				hero:setPlayerNameIcon(nil)
			end
			if hero:getPet() then
				if hero:getPet():getAnimation() then
					hero:getPet():getAnimation():getAnimNode():setVisible(false)
				end
				hero:setPet(nil)
			end
			hero:setDead(true,3)
		end
	end
end

--@brief	通过ID获取角色对象
--@param	nId:角色ID
--@return	#1:查找到的角色对象,或不存在则返回nil
function WBattleGlobal:getHeroWithId(nId)
	return self.m_tHeros[nId] or self.m_tExitHeros[nId]
end

--@brief	获取自己的角色对象id
--@return	#1:角色对象表
function WBattleGlobal:getMyBattleId()
	return self.m_tMakePairOk.selfId or GlobalGame.g_tPlayerInfo.nPlayerId
end

--@brief	获取自己的角色对象
--@return	#1:角色对象表
function WBattleGlobal:getMyHero()
	return self.m_tHeros[self:getMyBattleId()]
end

--@brief	随机获取英雄
--@param	count:英雄数量
--@return	#1:英雄数组
function WBattleGlobal:getRandHero(count)
	local tHeros = {}
	
	for id,hero in pairs(self.m_tHeros) do
		if not hero:isDead() then
			table.insert(tHeros, hero)
		end
	end
	
	while #tHeros > count do
		local i = math.random(1, #tHeros)
		table.remove(tHeros, i)
	end
	
	return tHeros
end

--@brief	随机获取一个敌方英雄
--@param	nPlayerId,我方英雄的ID
--@return	#1:一个敌方英雄
--@note		若不存在返回nil
function WBattleGlobal:getOneOtherTeamHero(nPlayerId)
	
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))
	
	local tHeros = {}
	
	for id,hero in pairs(self.m_tHeros) do
		if not hero:isDead() and not self:isSameTeam(nPlayerId,hero:getId()) then
			table.insert(tHeros, hero)
		end
	end
	
	while #tHeros > 1 do
		local i = math.random(1, #tHeros)
		table.remove(tHeros, i)
	end
	
	return tHeros[1]
end
--@brief	获取队友英雄
--@param	nPlayerId,我方英雄的ID
--@return	#1:一个敌方英雄
--@note		若不存在返回nil
function WBattleGlobal:myOtherTeamHeroId(nPlayerId)
	local tHeros = {}
	for id,hero in pairs(self.m_tHeros) do

		if self:isSameTeam(nPlayerId,hero:getId()) == false and hero:isRobot() == false then
			table.insert(tHeros, hero:getId())
		end
	end
    if #tHeros <= 0 then
        tHeros = nil
    end
	return tHeros
end

--@brief    是否竞技教学
function WBattleGlobal:isFirstPvp()
    local isFirstPvp = self.m_bIsFirstPvpTeach

    if TeachGroup1:isTeach() and isFirstPvp == nil then
        local isEndTeach, teachStep = TeachGroup1:isTeachFinish(20)
        local isSingle = self:isSingleStage()

        if isEndTeach == true or CacheCenter:getPlayerInfo().level > 8 or isSingle then
            isFirstPvp =  false
            self.m_bIsFirstPvpTeach = false
            WZLog("WBattleGlobal:isHoleTeach one", isFirstPvp, isEndTeach)
            return isFirstPvp
        end
        isFirstPvp = true
        self.m_bIsFirstPvpTeach = true
        WZLog("WBattleGlobal:isHoleTeach two", isFirstPvp, isEndTeach)
    end
    
    return isFirstPvp
end

--@brief 掉坑引导
function WBattleGlobal:isHoleTeach()
    local isHoleTeach = self.m_bIsHoleTeach

    if TeachGroup1:isTeach() and isHoleTeach == nil then
        local mapId = self.m_tMakePairOk.mapId
        if mapId == 10206 then
            local isEndTeach, step = TeachGroup1:isTeachFinish(51)
            if isEndTeach ~= true then
                isHoleTeach = true
                self.m_bIsHoleTeach = true
            else
                isHoleTeach = false
                self.m_bIsHoleTeach = false
            end
            WZLog("WBattleGlobal:isHoleTeach", isHoleTeach, mapId, isEndTeach)
        else
            isHoleTeach = false
            self.m_bIsHoleTeach = false
        end
    end
    return isHoleTeach
end

--@brief 组队副本引导
function WBattleGlobal:isCopyTeach()
    local isCopyTeach = self.m_bIsCopyTeach

    if TeachGroup1:isTeach() and isCopyTeach == nil then
        local mapId = self.m_tMakePairOk.mapId
        if mapId == 20101 and (not WBattleGlobal:getCurrent():isSingleStage()) then
            local isEndTeach, step = TeachGroup1:isTeachFinish(15)
            if isEndTeach ~= true then
                isCopyTeach = true
                self.m_bIsCopyTeach = true
            else
                isCopyTeach = false
                self.m_bIsCopyTeach = false
            end
            WZLog("WBattleGlobal:isCopyTeach", isCopyTeach, mapId, isEndTeach)
        else
            isCopyTeach = false
            self.m_bIsCopyTeach = false
        end
    end
    return isCopyTeach
end

--@brief	获取当前回合的角色对象
--@return	#1:角色对象表
function WBattleGlobal:getCurrentHero()
    return self:getCharacterWithId(self.m_nCurrentPlayerId)
end

--@brief	获取怪物对象列表
--@return	#1:怪对象列表
function WBattleGlobal:getBossList()
	return self.m_tGuais
end

--@brief    获取Boss对象列表(除小怪)
--@return   #1:Boss对象列表
function WBattleGlobal:getBossArray()
    local guaiList = {}
    for id,boss in pairs(self.m_tGuais) do
        if not boss.m_tBoss then
            table.insert(guaiList,boss)
        end
    end
    return guaiList
end

--@brief	获取怪物对象列表(boss和小怪)
--@return	#1:怪物对象列表
function WBattleGlobal:getGuaiList(note)
	local guaiList = {}
	for id,boss in pairs(self.m_tGuais) do
        if note ~= nil then
            WZLog("WBattleGlobal:getGuaiList", note, boss:getBattleId(), tostring(boss))
        end
		guaiList[boss:getBattleId()] = boss
		local xiaoGuai = boss:getChildCharaList()
		if xiaoGuai then
			for i,guai in pairs(xiaoGuai) do
				guaiList[guai:getBattleId()] = guai
			end
		end
	end
	return guaiList
end

--@brief	是否有角色受伤(包括英雄和怪物)
--@return	#1:true,false
function WBattleGlobal:getCharacterList(exceptMachines)
    local characterList = {}
    for key,hero in pairs(self:getHeroList()) do
        table.insert(characterList, hero)
    end
    for key,guai in pairs(self:getGuaiList()) do
        table.insert(characterList, guai)
    end
    if not exceptMachines then
        for key,machine in pairs(self:getMachinesList()) do
            -- if machine.m_bOffHurt then
                table.insert(characterList, machine)
            -- end
        end
    end
    return characterList
end

--@brief	通过ID获取怪物对象
--@param	nId:怪物ID
--@return	#1:查找到的怪物对象,或不存在则返回nil
function WBattleGlobal:getGuaiWithId(nBattleId)
	return self:getGuaiList()[nBattleId]
end

--@brief	获取当前回合的怪物对象
--@return	#1:怪物对象表
function WBattleGlobal:getCurrentGuai()
	return self:getCharacterWithId(self.m_nCurrentPlayerId)
end

--@brief	获取当前回合的控制对象
--@param	nId:ID
--@return	#1:控制对象表
function WBattleGlobal:getCharacterWithId(nId)
    if nId == nil then
        return nil
    end
	if self.m_tHeros[nId] ~= nil then
		return self.m_tHeros[nId]
	elseif self.m_tGuais[nId] then
		return self:getGuaiWithId(nId)
    else
        return self.m_tMachines[nId]
	end
end

--@brief	获取当前战斗角色id
--@return	#1:当前战斗角色id
function WBattleGlobal:getCurrentCharacterId()
	return self.m_nCurrentPlayerId
end

--@brief	获取当前回合的控制对象
--@return	#1:控制对象表
function WBattleGlobal:getCurrentCharacter()
	return self:getCharacterWithId(self.m_nCurrentPlayerId) or WBattleGlobal:getCurrent():getMyHero()
end

--@brief	是否轮到自己
--@return	#1:true:是,false：否
function WBattleGlobal:isMyTurn()
    return self.m_nCurrentPlayerId == self:getMyBattleId()
end

--@brief	设置当前回合的风力等级
--@param	tWind:风力等级
--@param    nWindSkillId : 使用的风向药剂道具Id
function WBattleGlobal:setWindLevel(tWind, nWindSkillId)
    WZLog("WBattleGlobal:setWindLevel", tostring(self.m_tWind), tostring(self.m_tWind.x), tostring(tWind))

    if TeachGroup1.ISBATTLE then
        tWind = 0
    end
	if self.m_tWind ~= nil then
		if type(tWind) == "table" then
			self.m_tWind = tWind
		elseif type(tWind) == "number" then
            self.m_tWind = {x=tWind, y=0}
		end
        WndBattleHud:setWindLevel(self.m_tWind, nWindSkillId)
        if self.m_battleManager ~= nil then
        	self.m_battleManager:setWind(WBattleGlobal:getCurrent():getWind().x, WBattleGlobal:getCurrent():getWind().y)
        end
	end
end

--@brief	获取当前回合的风力等级
--@return	#1:风力等级表
function WBattleGlobal:getWindLevel()
	return self.m_tWind
end

--@brief	获取当前回合的风力加速度
--@return	#1:风力加速度表
function WBattleGlobal:getWind()
	local wind = BattleCommon:windLevelToAcceleration(self.m_tWind)
    
    --WZLog("WBattleGlobal:getWind", wind)
    return wind
end

--@brief	判断是否是新回合
--@return	是否是新回合
function WBattleGlobal:isNewRound()
	return (self.m_nIsNewRound == 1)
end

--@brief	判断某个英雄是不是自己队
--@param	nPlayerId:英雄Id
--@return	是不是自己队
function WBattleGlobal:isMyTeam(nPlayerId)
	return self:isSameTeam(WBattleGlobal:getCurrent():getMyHero():getId(),nPlayerId)
end

--@brief	判断两个英雄是不是同一队
--@param	nPlayerId1:英雄Id
--@param	nPlayerId2:英雄Id
--@return	是不是同一队
function WBattleGlobal:isSameTeam(nPlayerId1,nPlayerId2)
    --WZLog("WBattleGlobal:isSameTeam", nPlayerId1, nPlayerId2)
	if nPlayerId1 == nPlayerId2 then
		return true
	end
	if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_NORMAL and WBattleGlobal:getCurrent().m_tMakePairOk.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_LD then
		return false
    elseif WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS then
		local hero1 = WBattleGlobal:getCurrent():getHeroWithId(nPlayerId1)
        local hero2 = WBattleGlobal:getCurrent():getHeroWithId(nPlayerId2)
        if hero1 == nil then
            hero1 = WBattleGlobal:getCurrent():getCharacterWithId(nPlayerId1)
        end
        if hero2 == nil then
            hero2 = WBattleGlobal:getCurrent():getCharacterWithId(nPlayerId2)
        end
        if hero1 == nil or hero2 == nil then
            return false
        end
        return hero1:getCamp() == hero2:getCamp()
	else
        if not WBattleGlobal:getCurrent():getHeroWithId(nPlayerId1) or not WBattleGlobal:getCurrent():getHeroWithId(nPlayerId2) then
            return false
        end
		return WBattleGlobal:getCurrent():getHeroWithId(nPlayerId1):getCamp() == WBattleGlobal:getCurrent():getHeroWithId(nPlayerId2):getCamp()
	end
end

--@brief	获取战斗模式类型
--@return	战斗模式
function WBattleGlobal:getBattleMode()
	return self.m_tMakePairOk.battleMode
end

--@brief	获取战斗ID
--@return	战斗ID
function WBattleGlobal:getBattleId()
	return self.m_tMakePairOk.battleId
end

--@brief	获取道具属性表
--@param	道具ID
--@return	道具属性表
function WBattleGlobal:getItemById(itemId)
	return self.m_tPropList[itemId]
end

--@brief	获取技能属性表
--@param	技能ID
--@return	技能属性表
function WBattleGlobal:getSkillById(skillId)
	return self.m_tSkillList[skillId]
end

--@brief	获取战斗随机数
--@return	#1:随机数
function WBattleGlobal:getBattleRandNum()
    WZLog("WBattleGlobal:getBattleRandNum",self:getTurnTimes())
	local num = #self.m_tBattleRand
	if num > 0 then
		return self.m_tBattleRand[(self:getTurnTimes() % num) + 1]
	end
	return 0
end

--@brief	获取当前随机数
function WBattleGlobal:getCurRandNum(index)
    local randNum
    if index == nil then
        self.m_nRandNumIndex = (self.m_nTurnTimes) % 10 + 1
        randNum = WBattleGlobal:getCurrent().m_tBattleRand[self.m_nRandNumIndex]
    else
        self.m_nRandNumIndex = index
        randNum = WBattleGlobal:getCurrent().m_tBattleRand[self.m_nRandNumIndex]
    end
    WZLog("WBattleGlobal:getCurRandNum", self.m_nRandNumIndex)
    return randNum
end

--@brief	获取当前是第几回合
--@return	第几回合
function WBattleGlobal:getTurnTimes()
	return self.m_nTurnTimes
end

--@brief	设置是否等待新的回合
--@param	bWaitNextRound,是否等待新的回合
function WBattleGlobal:setWaitNextRound(bWaitNextRound, note)
    WZLog("WBattleGlobal:setWaitNextRound", note , tostring(bWaitNextRound))
	self.m_bWaitNextRound = bWaitNextRound
end

--@brief	获取是否等待新的回合
--@return	是否等待新的回合
function WBattleGlobal:isWaitNextRound()
	return self.m_bWaitNextRound
end

--@brief	增加引用计数
function WBattleGlobal:retain()
	self.m_nReference = self.m_nReference + 1
end

--@brief	创建大招动画
function WBattleGlobal:addBigSkillAnim()
	
	local bigSkillContainer = GetElement(SceneBattle:getTopInfoLayer(),"conBigSkill_SceneBattle")
	self.m_tBigSkill_1 = BattleAnimation:createAnimation("kill01",true)
	self.m_tBigSkill_1:getAnimNode():setUseOriginSize(true)
	self.m_tBigSkill_1:getAnimNode():setVisible(false)
	bigSkillContainer:addChild(self.m_tBigSkill_1:getAnimNode())
	
	self.m_tBigSkill_2 = BattleAnimation:createAnimation("kill02",true)
	self.m_tBigSkill_2:getAnimNode():setUseOriginSize(true)
	self.m_tBigSkill_2:getAnimNode():setVisible(false)
	bigSkillContainer:addChild(self.m_tBigSkill_2:getAnimNode())
	
	self.m_tBigSkill_3 = BattleAnimation:createAnimation("kill03",true)
	self.m_tBigSkill_3:getAnimNode():setUseOriginSize(true)
	self.m_tBigSkill_3:getAnimNode():setVisible(false)
	bigSkillContainer:addChild(self.m_tBigSkill_3:getAnimNode())
	
	self.m_tBigSkill_4 = BattleAnimation:createAnimation("kill04",true)
	self.m_tBigSkill_4:getAnimNode():setUseOriginSize(true)
	self.m_tBigSkill_4:getAnimNode():setVisible(false)
	bigSkillContainer:addChild(self.m_tBigSkill_4:getAnimNode())
end

--@brief	清除大招动画
function WBattleGlobal:cleanBigSkillAnim()
	
	if self.m_tBigSkill_1 then
		self.m_tBigSkill_1:getAnimNode():removeFromParentAndCleanup(true)
		self.m_tBigSkill_1 = nil
	end
	if self.m_tBigSkill_2 then
		self.m_tBigSkill_2:getAnimNode():removeFromParentAndCleanup(true)
		self.m_tBigSkill_2 = nil
	end
	if self.m_tBigSkill_3 then
		self.m_tBigSkill_3:getAnimNode():removeFromParentAndCleanup(true)
		self.m_tBigSkill_3 = nil
	end
	if self.m_tBigSkill_4 then
		self.m_tBigSkill_4:getAnimNode():removeFromParentAndCleanup(true)
		self.m_tBigSkill_4 = nil
	end
end

--@brief	获取大招动画
--@param	nId,大招动画ID
function WBattleGlobal:getBigSkillAnim(nId)
	
	if nId == 1 then
		return self.m_tBigSkill_1
	elseif nId == 2 then
		return self.m_tBigSkill_2
	elseif nId == 3 then
		return self.m_tBigSkill_3
	elseif nId == 4 then
		return self.m_tBigSkill_4
	end
	return nil
end

--@brief	获取左边勋章数
--@return	左边勋章数
function WBattleGlobal:getLeftMedal()
	
	return self.m_nLeftMedal
	
end

--@brief	获取右边勋章数
--@return	右边勋章数
function WBattleGlobal:getRightMedal()
	
	return self.m_nRightMedal
	
end

--@brief	获取战斗胜利所需勋章数
--@return	战斗胜利所需勋章数
function WBattleGlobal:getNeedMedal()
	
	return self.m_nNeedMedal
	
end

--@brief	增加左边勋章数
--@return	bool,是否成功
function WBattleGlobal:addLeftMedal()
	
	if self.m_nLeftMedal < self.m_nNeedMedal then
		self.m_nLeftMedal = self.m_nLeftMedal + 1
		return true
	end
	return false
end

--@brief	增加右边勋章数
--@return	bool,是否成功
function WBattleGlobal:addRightMedal()
	
	if self.m_nRightMedal < self.m_nNeedMedal then
		self.m_nRightMedal = self.m_nRightMedal + 1
		return true
	end
	return false
end

--@brief    设置左边勋章数
function WBattleGlobal:setLeftMedal(count)
    self.m_nLeftMedal = count
    if count >= 1 then
        for i=1,count do
            WndBattleHud:showMedal2(tPlayerPos,true,i)
        end
    end
end

--@brief    设置右边勋章数
function WBattleGlobal:setRightMedal(count)
    self.m_nRightMedal = count
    if count >= 1 then
        for i=1,count do
            WndBattleHud:showMedal2(tPlayerPos,false,i)
        end
    end
end


--@brief	判断是否战斗结束
--@return	是否战斗结束
function WBattleGlobal:isGameOver()
	return self.m_bGameOver
end

--@brief	设置是否战斗结束
--@param	bGameOver,是否战斗结束
function WBattleGlobal:setGameOver(bGameOver)
    if self.m_bGameOver == bGameOver then
        return
    end
	self.m_bGameOver = bGameOver
    WBattleGlobal:getCurrent():setCtbEndRecord()
end

--@brief	检验数据是否被改动/作弊
--@param	nOriginValue,原数据
--@param	nEncryptValue,加密数据
--@return	bool,是否被改动
function WBattleGlobal:checkIsCheat(nOriginValue,nEncryptValue,note)
    do return false end
end

--@brief	检测作弊
--@return	bool,是否作弊
function WBattleGlobal:checkCheat()
    do return end
	local cheat =false
	for _,hero in pairs(self.m_tHeros) do
		--WZLog("hero",hero:getId())
	
		cheat = cheat or self:checkIsCheat(hero.m_nHP,hero.m_nHP_Encrypt,23)
		--WZLog("HP check",cheat)
		cheat = cheat or self:checkIsCheat(hero.m_nSP,hero.m_nSP_Encrypt,24)
		--WZLog("SP check",cheat)
		cheat = cheat or self:checkIsCheat(hero.m_nPF,hero.m_nPF_Encrypt,25)
		--WZLog("PF check",cheat)
		
		cheat = cheat or self:checkIsCheat(hero.m_nAttack,hero.m_nAttack_Encrypt,26)
		--WZLog("m_nAttack check",cheat)
		cheat = cheat or self:checkIsCheat(hero.m_nBigSkillAttack,hero.m_nBigSkillAttack_Encrypt,27)
		--WZLog("m_nBigSkillAttack check",cheat)
		cheat = cheat or self:checkIsCheat(hero.m_nCriticalhitAttackRate,hero.m_nCriticalhitAttackRate_Encrypt,28)
		--WZLog("m_nCriticalhitAttackRate check",cheat)
		cheat = cheat or self:checkIsCheat(hero.m_nDefence,hero.m_nDefence_Encrypt,29)
		--WZLog("m_nDefence check",cheat)
		
		cheat = cheat or self:checkIsCheat(hero.m_nAttScatterNum,hero.m_nAttScatterNum_Encrypt,30)
		--WZLog("m_nAttScatterNum check",cheat)
		cheat = cheat or self:checkIsCheat(hero.m_nAttTimes,hero.m_nAttTimes_Encrypt,31)
		--WZLog("m_nAttTimes check",cheat)
		cheat = cheat or self:checkIsCheat(hero.m_fAttPercent,hero.m_fAttPercent_Encrypt,32)
		--WZLog("m_fAttPercent check",cheat)
		
		cheat = cheat or self:checkIsCheat(hero.m_nAddAttackValue,hero.m_nAddAttackValue_Encrypt,33)
		--WZLog("m_nAddAttackValue check",cheat)
		cheat = cheat or self:checkIsCheat(hero.m_fRadiusForBulletExplode,hero.m_fRadiusForBulletExplode_Encrypt,34)
		--WZLog("m_fRadiusForBulletExplode check",cheat)
		cheat = cheat or self:checkIsCheat(hero.m_nHideTurn,hero.m_nHideTurn_Encrypt,35)
		--WZLog("m_nHideTurn check",cheat)
		cheat = cheat or self:checkIsCheat(hero.m_nSkillfull,hero.m_nSkillfull_Encrypt,36)
		--WZLog("m_nSkillfull check",cheat)
		
		cheat = cheat or self:checkIsCheat(hero.m_nWreckDefense,hero.m_nWreckDefense_Encrypt,37)
		--WZLog("m_nWreckDefense check",cheat)
		cheat = cheat or self:checkIsCheat(hero.m_nInjuryFree,hero.m_nInjuryFree_Encrypt,38)
		--WZLog("m_nInjuryFree check",cheat)
		cheat = cheat or self:checkIsCheat(hero.m_nReduceCrit,hero.m_nReduceCrit_Encrypt,39)
		--WZLog("m_nReduceCrit check",cheat)
		cheat = cheat or self:checkIsCheat(hero.m_nReduceBury,hero.m_nReduceBury_Encrypt,40)
		--WZLog("m_nReduceBury check",cheat)
	end
	for _,guai in pairs(self:getGuaiList()) do
		--WZLog("guai")
	
		cheat = cheat or self:checkIsCheat(guai.m_nHP,guai.m_nHP_Encrypt,41)
		--WZLog("HP check",cheat)
		cheat = cheat or self:checkIsCheat(guai.m_nSP,guai.m_nSP_Encrypt,42)
		--WZLog("SP check",cheat)
		cheat = cheat or self:checkIsCheat(guai.m_nPF,guai.m_nPF_Encrypt,43)
		--WZLog("PF check",cheat)
		
		cheat = cheat or self:checkIsCheat(guai.m_nAttack,guai.m_nAttack_Encrypt,44)
		--WZLog("m_nAttack check",cheat)
		cheat = cheat or self:checkIsCheat(guai.m_nCriticalhitAttackRate,guai.m_nCriticalhitAttackRate_Encrypt,45)
		--WZLog("m_nCriticalhitAttackRate check",cheat)
		cheat = cheat or self:checkIsCheat(guai.m_nDefence,guai.m_nDefence_Encrypt,46)
		--WZLog("m_nDefence check",cheat)
		
		cheat = cheat or self:checkIsCheat(guai.m_nWreckDefense,guai.m_nWreckDefense_Encrypt,47)
		--WZLog("m_nWreckDefense check",cheat)
		cheat = cheat or self:checkIsCheat(guai.m_nInjuryFree,guai.m_nInjuryFree_Encrypt,48)
		--WZLog("m_nInjuryFree check",cheat)
		cheat = cheat or self:checkIsCheat(guai.m_nReduceCrit,guai.m_nReduceCrit_Encrypt,49)
		--WZLog("m_nReduceCrit check",cheat)
		cheat = cheat or self:checkIsCheat(guai.m_nReduceBury,guai.m_nReduceBury_Encrypt,50)
		--WZLog("m_nReduceBury check",cheat)
		
	end
	
	if self.m_tMakePairOk.skillHurt and self.skillHurt_Encrypt then
		for i=1,#self.m_tMakePairOk.skillHurt do
			self:checkIsCheat(self.m_tMakePairOk.skillHurt[i],self.skillHurt_Encrypt[i],3)
		end
	end
	
	--WZLog("RoundTimes check",cheat,51)
	cheat = cheat or self:checkIsCheat(self.m_nTurnTimes,self.m_nTurnTimes_Encrypt)
	--WZLog("TurnTimes check",cheat,52)
	cheat = cheat or self:checkIsCheat(math.ceil(WndBattleHud.m_nTurnTime),WndBattleHud.m_nTurnTime_Encrypt)
	--WZLog("hudTurnTime check",cheat,53)
	
	return cheat
end

function WBattleGlobal:setShowGameOver(bValue)
    if bVale ~= nil then
        self.m_bShowGameOver = bVale
    end
end

function WBattleGlobal:canShowGameOver()
    return self.m_bShowGameOver
end

--@brief  单人副本点击异常提示触发的函数
--@param  nType，按钮类型，关闭，取消，确定
--@param  nId，按钮id
function WBattleGlobal:clickSureBack(nId,nType)
    WZLog("WBattleGlobal:clickSureBack")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    SceneBattle:leftBattle()
end

--@brief	检测机器性能
--@note		检测是否需要开启粒子效果
function WBattleGlobal:isHighEndMachine()

    local isHighEndMachine = true

    --安卓平台
    if PlatformInfo:getCurrentPlatform() == PlatformInfo.type.PLATFORM_ANDROID then 
        --[[
        local adapter = WydPlAdapterManager:sharedWydPlAdapterManager():createAdapter("org/cocos2dx/hellolua/DandandaoUtils")
        if adapter == nil then
            return false
        end

		local curCpuFreq = tonumber(adapter:callMethodByNameReturn("getCurCpuFreq","")) / 1024
		local CPUPlatform = adapter:callMethodByNameReturn("getCPUPlatform","")
		local totalMemory = tonumber(adapter:callMethodByNameReturn("getTotalMemory","")) / 1024
		local visibleSize = CCDirector:sharedDirector():getVisibleSize()

        WydPlAdapterManager:sharedWydPlAdapterManager():destroyAdapter(adapter:getId())

		if visibleSize.width <= 480 or visibleSize.height <= 320 then
			if totalMemory >= 512 then
				--CPU型号是"蜂鸟"或是NVIDIA制
				if CPUPlatform == "s5pc110" or CPUPlatform == "tegra" then
					if curCpuFreq >= 1024 then
						isHighEndMachine = true
					else
						isHighEndMachine = false
					end
				else
					if curCpuFreq >= 800 then
						isHighEndMachine = true
					else
						isHighEndMachine = false
					end
				end
			else
				isHighEndMachine = false
			end
		else
			if totalMemory >= 512 then
				--CPU型号是"蜂鸟"或是NVIDIA制
				if CPUPlatform == "s5pc110" or CPUPlatform == "tegra" then
					if curCpuFreq > 1024 then
						isHighEndMachine = true
					else
						isHighEndMachine = false
					end
				else
					if curCpuFreq >= 1024 then
						WZLog("xiaomi2S isHighEndMachine")
						isHighEndMachine = true
					else
						isHighEndMachine = false
					end
				end
			else
				isHighEndMachine = false
			end
		end
        ]]
        isHighEndMachine = true
        if checkIsBadMachine() then
            isHighEndMachine = false
        end
	else
		local systemName = WZDeviceInfo:systemName()
		
		local unUseParticileList = {}
		table.insert(unUseParticileList,"iPhone1,1")
		table.insert(unUseParticileList,"iPhone1,2")
		table.insert(unUseParticileList,"iPhone2,1")
		table.insert(unUseParticileList,"iPhone3,1")
		table.insert(unUseParticileList,"iPhone3,3")
		table.insert(unUseParticileList,"iPod1,1")
		table.insert(unUseParticileList,"iPod2,1")
		table.insert(unUseParticileList,"iPod3,1")
		table.insert(unUseParticileList,"iPod4,1")
		
		for i, sysName in pairs(unUseParticileList) do
			if systemName == sysName then
				isHighEndMachine = false
				break
			end
		end
		
		WZLog("WBattleGlobal:isHighEndMachine isHighEndMachine : "..tostring(isHighEndMachine).." systemName : "..systemName)
	end

    self.m_tIsHighEndMachine = isHighEndMachine
end

--@brief	本回合本人是否已经发过结束回合的消息
--@return	#1:true,false
function WBattleGlobal:isCurTurnHaveSendEndMsg()
    do 
        return false
    end

    local isSend = false
    local turnTimes = self:getTurnTimes()
    local myHero = WBattleGlobal:getCurrent():getMyHero()
    local curHero = WBattleGlobal:getCurrent():getCurrentHero()

    WZLog("WBattleGlobal:isCurTurnHaveSendEndMsg",turnTimes, self.m_nSendEndMsgTurn)
    if self.m_nSendEndMsgTurn >= turnTimes and myHero == self.m_tSendEndMsgPlayer then
        isSend = true
    end

    return isSend
end

--@brief 初始化copyData
function WBattleGlobal:initCopyData()
    local mode =  COPYTYPE_DAILY -- COPYTYPE_SINGLE --

    if not self.m_copyData then 
        if WBattleGlobal:getCurrent():isCopperCopy() then
            self.m_copyData = CopperCopyDataII:new()
        elseif WBattleGlobal:getCurrent():isExpCopy() then
            self.m_copyData = ExpCopyData:new()
        elseif WBattleGlobal:getCurrent():isPetCopy() then
            self.m_copyData = PetCopyData:new()
        end
    end
end
--@brief 金币副本
function WBattleGlobal:isCopperCopy()
    if WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_DAILY) and WBattleGlobal:getCurrent().m_tMakePairOk.section == DAILY_COPY_TYPE.COPPER then
        return true
    end
    return false
end
--@brief 经验副本
function WBattleGlobal:isExpCopy()
    if WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_DAILY) and WBattleGlobal:getCurrent().m_tMakePairOk.section == DAILY_COPY_TYPE.EXP then
        return true
    end
    return false
end

--@brief 经验副本
function WBattleGlobal:isPetCopy()
    if WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_DAILY) and WBattleGlobal:getCurrent().m_tMakePairOk.section == DAILY_COPY_TYPE.PET then
        return true
    end
    return false
end

--@brief 飞行训练
function WBattleGlobal:isFlyCopy()
    if WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_TRAIN) and WBattleGlobal:getCurrent().m_tMakePairOk.section == TRAIN_COPY_TYPE.FLY then
        return true
    end
    return false
end

--@brief 风力训练
function WBattleGlobal:isWindCopy()
    if WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_TRAIN) and WBattleGlobal:getCurrent().m_tMakePairOk.section == TRAIN_COPY_TYPE.WIND then
        return true
    end
    return false
end

--@brief 挖坑训练
function WBattleGlobal:isHoleCopy()
    if WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_TRAIN) and WBattleGlobal:getCurrent().m_tMakePairOk.section == TRAIN_COPY_TYPE.HOLE then
        return true
    end
    return false
end

--@brief 高抛训练
function WBattleGlobal:isThrowCopy()
    if WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_TRAIN) and WBattleGlobal:getCurrent().m_tMakePairOk.section == TRAIN_COPY_TYPE.THROW then
        return true
    end
    return false
end

--@brief 子弹穿透地图
function WBattleGlobal:isPenetrateMapCopy()
    --[[
    if WBattleGlobal:getCurrent():isCopperCopy() then
        return true
    end
    --]]
    return false
end

--@brief 获取副本信息
--@return copyData
function WBattleGlobal:getCopyData()
    return self.m_copyData
end

--@brief 玩家杀死怪物
function WBattleGlobal:killMonster(monsterId,battleId,pos)
    --WZLog("WBattleGlobal:killMonster",monsterId,pos.x,pos.y)
    if self.m_copyData then
        self.m_copyData:killMonster(monsterId,battleId,pos)
    end
end

--@brief 结束回合
function WBattleGlobal:endCurRound(battleId,noteId, isForce, isNotEndCurRound,isOnlyEndCurRound)
    WZLog("WBattleGlobal:endCurRound one", battleId, noteId, tostring(self.m_nEndCurRoundBattleId), WBattleGlobal:getCurrent().m_tMakePairOk.battleId, tostring(WBattleGlobal:getCurrent():isGameOver()))
    if (self.m_nEndCurRoundBattleId == WBattleGlobal:getCurrent().m_tMakePairOk.battleId and isForce == nil) or WBattleGlobal:getCurrent():isGameOver() then
        return
    end

    self.m_nEndCurRoundBattleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId

    WBattleGlobal:getCurrent().m_bIsCurTurnActed = true

    if not isOnlyEndCurRound then
        WZLog("WBattleGlobal:endCurRound two")
        local msg = MsgManager:createMsg(BattleMsgPass)
        msg.m_nBattleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
        msg.m_nPlayerId = battleId
        --msg.m_nPlayerOrGuai = hero:getType()
        MsgManager:pushBlockMsg(msg)

        WndBattleHud:endTurnTime()

        if WBattleGlobal:getCurrent():canRecordGame() then
            --录像记录
            local replayParam = {}
            replayParam.m_nBattleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
            replayParam.m_nPlayerId = battleId
            BattleMsgReplayGameRecord:setPlayerPass(replayParam)
        end
    end

    if isNotEndCurRound ~= true then
        WZLog("WBattleGlobal:endCurRound three")
        local msg = MsgManager:createMsg(BattleMsgEndCurRound)
        msg.m_nBattleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
        msg.m_nPlayerId = WBattleGlobal:getCurrent():getMyHero():getId()
        msg.m_nCurrentPlayerId = WBattleGlobal:getCurrent():getMyHero():getId()
        --msg.m_nPlayerOrGuai = hero:getType()
        msg.note = noteId and noteId or 1
        MsgManager:pushBlockMsg(msg)
    end
end

--爆炸图画质
function WBattleGlobal:getImageQuality()
    if WBattleGlobal.m_sImageQuality == nil then
        if WZDeviceInfo:getTotalMemory()/(1024*1024) < 1000 then
            WBattleGlobal.m_sImageQuality = "_sd"
        else
            WBattleGlobal.m_sImageQuality = "_hd"
        end

        WBattleGlobal.m_sImageQualityNot = (WBattleGlobal.m_sImageQuality == "_sd" and "_hd") or (WBattleGlobal.m_sImageQuality == "_hd" and "_sd")
    end

    return WBattleGlobal.m_sImageQuality, WBattleGlobal.m_sImageQualityNot
end

--主机控制
function WBattleGlobal:isHostControl()
    if g_battleGlobal.m_nHostBattleId then
    -- if g_battleGlobal.m_nHostBattleId and g_battleGlobal.m_nHostBattleId == g_battleGlobal:getMyBattleId() then
        return true
    end
    return false
end

--@brief 首杀效果
function WBattleGlobal:showKillAni(playerId, beKillId, showKillCount)

    self:removeKillAnim()

    if showKillCount == 1 then
        SoundManager:playEffectSound(SoundDefine.E_S_FIRSTKILL)
    else
        SoundManager:playEffectSound(SoundDefine.E_S_KILL_EFFECT)
    end

    self.m_nShowKillTime = os.time()
    if self.m_tKillHead then
        self.m_tKillHead:getAnimNode():removeFromParentAndCleanup(true)
        self.m_tKillHead2:getAnimNode():removeFromParentAndCleanup(true)
        self.m_tKillHead = nil
        self.m_tKillHead2 = nil
        self.m_tKillAnim:getAnimNode():removeFromParentAndCleanup(true)
        self.m_tKillAnim = nil
    end
    if self.m_tKillAnim2 then
        self.m_tKillAnim2:getAnimNode():removeFromParentAndCleanup(true)
        self.m_tKillAnim2 = nil
    end



    if self:isMyTeam(playerId) then
        GetElement(WndBattleHud.m_root,"imgFigureBg_WndBattleHud",WZUIImage):setFile("ui/combat/battle_icon_datouxianglan.png")
        GetElement(WndBattleHud.m_root,"imgFigureBg2_WndBattleHud",WZUIImage):setFile("ui/combat/battle_icon_datouxianghong.png")
    else
        GetElement(WndBattleHud.m_root,"imgFigureBg_WndBattleHud",WZUIImage):setFile("ui/combat/battle_icon_datouxianghong.png")
        GetElement(WndBattleHud.m_root,"imgFigureBg2_WndBattleHud",WZUIImage):setFile("ui/combat/battle_icon_datouxianglan.png")
    end
    GetElement(WndBattleHud.m_root,"conKill_WndBattleHud"):setVisible(true)

    local con1 = GetElement(WndBattleHud.m_root,"imgFigure_WndBattleHud",WZUIImage)
    con1:stopAllActions()
    con1:setOpacity(255)
    local con2 = GetElement(WndBattleHud.m_root,"imgFigure2_WndBattleHud",WZUIImage)
    con2:stopAllActions()
    con2:setOpacity(255)
    local con3 = GetElement(WndBattleHud.m_root,"imgFigureBg_WndBattleHud",WZUIImage)
    con3:stopAllActions()
    con3:setOpacity(255)
    local con4 = GetElement(WndBattleHud.m_root,"imgFigureBg2_WndBattleHud",WZUIImage)
    con4:stopAllActions()
    con4:setOpacity(255)
    local con7 = GetElement(WndBattleHud.m_root,"imgNumKillBg_WndBattleHud",WZUIImage)
    con7:stopAllActions()
    con7:setOpacity(255)
    local con8 = GetElement(WndBattleHud.m_root,"imgNumKill_WndBattleHud",WZUIImage)
    con8:stopAllActions()
    con8:setOpacity(255)


    local hero = WBattleGlobal:getCurrent():getCharacterWithId(playerId)
    local head = hero:getKillHeadAnimation()
    self.m_tKillHead = head
    GetElement(WndBattleHud.m_root,"imgFigure_WndBattleHud",WZUIImage):addChild(head:getAnimNode())
    head:getAnimNode():setScale(0.45)
    head:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    head:setPosition(Vector2:create(0,12))

    local hero = WBattleGlobal:getCurrent():getCharacterWithId(beKillId)
    local head = hero:getKillHeadAnimation()
    self.m_tKillHead2 = head
    GetElement(WndBattleHud.m_root,"imgFigure2_WndBattleHud",WZUIImage):addChild(head:getAnimNode())
    head:getAnimNode():setScale(0.45)
    head:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    head:setPosition(Vector2:create(0,12))

    local name = "first"
    local numName = "shousha"
    if showKillCount == 1 then
        name = "first"
        numName = "shousha"
    elseif showKillCount == 2 then
        name = showKillCount .. "kill"
        numName = "shuangsha"
    elseif showKillCount == 3 then
        name = showKillCount .. "kill"
        numName = "sansha"
    elseif showKillCount == 4 then
        name = showKillCount .. "kill"
        numName = "sisha"
    elseif showKillCount == 5 then
        name = showKillCount .. "kill"
        numName = "wusha"
    end

    GetElement(WndBattleHud.m_root,"imgNumKill_WndBattleHud",WZUIImage):setFile("ui/common/common_icon_".. numName ..".png")

    local y = 0.77
    local anim = BattleAnimation:createAnimation("ui_jishatishi",false, "battle/ui")
    self.m_tKillAnim = anim
    anim:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    anim:getAnimNode():setRelativePositionLuaTo(0.5,y)
    anim:getAnimNode():setAnimationName(name)
    anim:getAnimNode():setLoop(false)

    local layer = GetElement(WndBattleHud.m_root,"conKillAnim_WndBattleHud",WZUIContainer)
    layer:addChild(anim:getAnimNode(),1)

    if showKillCount == 1 or showKillCount == 5 then
        GetElement(WndBattleHud.m_root,"conKill2_WndBattleHud"):setVisible(true)
        local anim = BattleAnimation:createAnimation("ui_jishatishi",false, "battle/ui")
        anim:getAnimNode():setRelativePositionLuaTo(0.5,0.5)
        anim:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        anim:getAnimNode():setAnimationName("kuang")
        anim:getAnimNode():setLoop(false)
        self.m_tKillAnim2 = anim
        local layer = GetElement(WndBattleHud.m_root,"conKillAnim2_WndBattleHud",WZUIContainer)
        layer:addChild(anim:getAnimNode(),1)

        local width = FigureSceneManager:getInstance().m_nScreenWidth
        if width < 900 then
            anim:setScaleY(1.28)
        elseif width > 1100 then
            anim:setScaleX(1.4)
        end
    else
        GetElement(WndBattleHud.m_root,"conKill2_WndBattleHud"):setVisible(false)
    end

    WZLog("WBattleGlobal:showKillAni", self.m_nTurnTimes, showKillCount, FigureSceneManager:getInstance().m_nScreenWidth)
end

--@brief 设置射击技能效果状态
function WBattleGlobal:setDoEffectAfterAttack(val,note)
    WZLog("WBattleGlobal:setDoEffectAfterAttack",tostring(val),note)
    self.m_bIsDoEffectAfterAttack = val
end

--@brief 同步战斗对象位置(地图广播)
function WBattleGlobal:sendBattleSynPosition()
    local battleIds = {}
    local posX = {}
    local posY = {}
    for id,chara in pairs(self:getCharacterList()) do
        if not chara:isDead() then
            local pos = chara:getPosition()
            local x = BattleCommon:float2int2float(pos.x)
            local y = BattleCommon:float2int2float(pos.y)
            local r = BattleCommon:float2int2float(chara:getAnimation():getRotate())
            chara:setPosition({x = x , y = y } )
            chara:getAnimation():setRotate(r)

            table.insert(battleIds,chara:getBattleId())
            table.insert(posX,x)
            table.insert(posY,y)
        end
    end

    ProtocolProcessorBattleInterface:send_BOSSMAPBATTLE_SynPosition(self.m_tMakePairOk.battleId, battleIds, posX, posY)
end

--@brief 同步战斗对象位置
function WBattleGlobal:updateBattleSynPosition(battleIds, posX, posY)
    if not WBattleGlobal:getCurrent():isHostControl() then
        for i,v in pairs(battleIds) do
            chara = self:getCharacterWithId(battleIds[i])
            if chara then
                chara:setPosition({x = posX[i], y = posY[i]})
            end
        end
    end
end

--@brief 申请怪物id
function WBattleGlobal:getBuildGuaiBattleId(isHero)
    if not self.m_nMonsterRequestId then
        self.m_nMonsterRequestId = -10000
    end
    if not self.m_nHeroRequestId then
        self.m_nHeroRequestId = self:getMyBattleId() + 10000
    end
    if isHero then
        self.m_nHeroRequestId = self.m_nHeroRequestId + 1
        return self.m_nHeroRequestId
    else
        self.m_nMonsterRequestId = self.m_nMonsterRequestId - 1
        return self.m_nMonsterRequestId
    end
    -- body
end

--@brief 开局添加BUFF
function WBattleGlobal:addFirstBuff()
    --WBattleGlobal:getCurrent().m_tMakePairOk.buffId = {1148, 1149, 1150, 1151, 1152, 1153}
    WZLog("WBattleGlobal:addFirstBuff1", type(WBattleGlobal:getCurrent().m_tMakePairOk.buffId[1]), WBattleGlobal:getCurrent().m_tMakePairOk.buffId[1])
    for i,v in ipairs(WBattleGlobal:getCurrent().m_tMakePairOk.buffId) do
        local playerId = WBattleGlobal:getCurrent().m_tMakePairOk.playerId[i]
        local hero = self:getCharacterWithId(playerId)
        if hero and v ~= 0 then
            WZLog("WBattleGlobal:addFirstBuff2")
            local buff = WBattleGlobal:addBuff({hero},v,playerId,0)
        end
    end

    if self:isHoleCopy() then
        for i,v in pairs(self:getCharacterList()) do
            local buff = WBattleGlobal:addBuff({v},7004,v:getBattleId(),0)
        end

    end

end

--@brief 掉线重连同步信息
function WBattleGlobal:synchronousBattleInfo(
    playerIds, dataIds, masterIds, camp, hp, sp, CTB, propIds, postionX, postionY, angle, face, 
    buffCount, buffId, buffPassCtb, buffUserId,
    explodePlayerId, explodeSkillId, explodePosNum, explodePosX, explodePosY, finishPercent, roundNum, killCount, 
    onlineStatus, battleInfo)

    if WBattleGlobal:getCurrent().m_nRelinkLoading ~= -1 then
        MsgBoxManager:stopLoadingBoxByMsgId(WBattleGlobal:getCurrent().m_nRelinkLoading)
        WBattleGlobal:getCurrent().m_nRelinkLoading = -1
    end

    WBattleGlobal:getCurrent().m_bSendCurRoundInfo = -1
    WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle = nil
    SceneBattle:getBattleLoop():setBattleStatus(BattleLoop.S_NORMAL)
    WBattleGlobal:getCurrent().m_tBuffAddSkillPlayerList = {}
    WBattleGlobal:getCurrent().m_tBuffAddPlayerList = {}
    BattlePetSkillManager.m_nState = PetSkillState.PASSIVE_END
    self.m_nSendCurRoundInfoTimer = os.time()

    WBattleGlobal:getCurrent().m_nTurnTimes = roundNum - 1
    local isBoss4 = false--副本4特殊处理(满血,打乱头像)
    local mapId = WBattleGlobal:getCurrent().m_tMakePairOk.mapId
    if math.floor(mapId / 100) == 204 then
        for id, playerId in ipairs (playerIds) do
            if masterIds[id] > 0 and hp[id] > 0 then
                isBoss4 = true
                break
            end
        end
    end

    local playerId = WBattleGlobal:getCurrent():getMyHero():getBattleId()
    local pos = WBattleGlobal:getCurrent():getCharacterWithId(playerId):getPosition()

    -- local monsterId = 0
    -- for id, hero in pairs (WBattleGlobal:getCurrent():getCharacterList()) do
    --     if hero:getBattleId() ~= playerId then
    --         monsterId = hero:getBattleId()
    --     end
    -- end

    -- local monsterDataId = WBattleGlobal:getCurrent():getCharacterWithId(monsterId):getId()
    -- local monsterPos = WBattleGlobal:getCurrent():getCharacterWithId(monsterId):getPosition()

    WZLog("WBattleGlobal:synchronousBattleInfo zero", tostring(isBoss4), mapId, WBattleGlobal:getCurrent().m_nTurnTimes)
    
    --生成怪物
    for id, playerId in ipairs (playerIds) do
        local isExist = false
        for i, hero in pairs (WBattleGlobal:getCurrent():getCharacterList()) do
            if hero:getBattleId() == playerId then
                isExist = true
            end
        end

        WZLog("WBattleGlobal:synchronousBattleInfo eigth-0", id, tostring(isExist))
        if isExist == false and hp[id] > 0 then
            if BossData["id_"..dataIds[id]] == nil then
                MsgBoxManager:showConfirmBox(LocalStrings.BATTLE_RECONNECT_FAIL, SceneBattle, SceneBattle.leftBattle, MSGBOXLEVEL_NORMAL, nil, true)
            end
            
            local masterId =  masterIds[id]
            local master = masterId > 0 and WBattleGlobal:getCurrent():getCharacterWithId(masterId) or nil
            local scale = BossData["id_"..dataIds[id]].scale
            local battleId = playerIds[id]
            local campId = camp[id] --阵营
            
            WZLog("WBattleGlobal:synchronousBattleInfo eigth-1", tostring(master), dataIds[id], scale, battleId)

            local monsterType = BossData["id_"..dataIds[id]].type
            if monsterType == MonsterType.TORANDO then
                --龙卷风
                local machine = WBattleGlobal:getCurrent():buildMachine(MonsterType.TORANDO,{battleId = battleId,templateId = dataIds[id],camp = campId})
                SceneBattle:getFrontLayer():addChild(machine.m_anim:getAnimNode())
            elseif monsterType == MonsterType.TREAT_TOTEM or monsterType == MonsterType.BUFF_TOTEM then
                --治疗图腾 攻击图腾
                local machine = WBattleGlobal:getCurrent():buildMachine(monsterType,{battleId = battleId,templateId = dataIds[id],camp = campId})
                SceneBattle:getFrontLayer():addChild(machine.m_anim:getAnimNode())
            elseif monsterType == MonsterType.BOSS_GIFT then
                --boss礼物
                local machine = WBattleGlobal:getCurrent():buildMachine(MonsterType.BOSS_GIFT,{battleId = battleId,templateId = dataIds[id],camp = campId})
                SceneBattle:getFrontLayer():addChild(machine.m_anim:getAnimNode())
                if machine:getMover() then
                    WBattleGlobal:getCurrent().m_battleManager:addEntity(machine:getMover())
                end
            elseif monsterType == MonsterType.BOSS_LIGHT then
                --boss聚光灯
                local machine = WBattleGlobal:getCurrent():buildMachine(MonsterType.BOSS_LIGHT,{battleId = battleId,templateId = dataIds[id],camp = campId})
                SceneBattle:getFrontLayer():addChild(machine.m_anim:getAnimNode())
            else
                local monster = WMonster:buildGuai(dataIds[id], scale, master ~= nil, playerIds[id])
                
                if master then
                    monster:setBoss(master)
                    table.insert(master.m_tOwnedMonsterList, monster)
                end

                monster:getAnimation():getAnimNode():setAnchorPoint(monster:getSceneAnchorPoint())
                WBattleGlobal:getCurrent().m_tGuais[monster:getBattleId()] = monster
                SceneBattle:getFrontLayer():addChild(monster:getAnimation():getAnimNode())
                if monster:getMover() then
                    WBattleGlobal:getCurrent().m_battleManager:addEntity(monster:getMover())
                end

                monster:setAppearAttribute()
                monster:getAnimation():play(monster:getAnimationName("standby"), true)
                if monster.m_bIsFilpX ~= true then
                    monster:getAnimation():setFlipX(true)
                    monster.m_bIsFilpX = true
                elseif monster.m_bIsFilpX == true then
                    monster:getAnimation():setFlipX(false)
                    monster.m_bIsFilpX = false
                end
                            
                --添加ctb头像
                if battleId > 0 and monster:isNormalAct() then
                    BattleCtbManager:addCellBattleCtb(battleId)
                end
            end
        end

    end

    if isBoss4 then
        BattleCtbManager:randomTag()
    end

    if not WBattleGlobal:getCurrent():isAudience() then
        MsgBoxManager:showTipBox(LocalStrings.BATTLE_RELINK_OK,nil,nil,nil,nil,nil,nil,nil,true)
    end

    local list = WBattleGlobal:getCurrent():getCharacterList()
    --设置属性
    -- local boss4 = nil
    local isCommonBoss4 = true
    local myId = WBattleGlobal:getCurrent():getMyHero():getBattleId()
    for id, playerId in ipairs (playerIds) do
        for i, hero in pairs (list) do
            if hero:getBattleId() == playerId then
                WZLog("WBattleGlobal:synchronousBattleInfo one", i, hero:getBattleId(), tostring(hero:isDead()), hero:getHp(), hp[id], hero:getSp() ,sp[id] )

                if hp[id] > 0 and hero:isDead() == true then
                    hero:setDead(false)
                    hero:setServerDead(false)
                end

                --在线状况
                if playerId ~= myId then
                    if onlineStatus[id] == 0 then
                        BattleCtbManager:setExit(playerId, false, false)
                        hero.m_bLoseNet = false
                    elseif onlineStatus[id] == 1 and hero:isDead() ~= true then
                        BattleCtbManager:setExit(playerId, true, false)
                        hero.m_bLoseNet = true
                    elseif onlineStatus[id] == 2 and hero:isDead() ~= true then
                        BattleCtbManager:setExit(playerId, true, true)
                        hero.m_bLoseNet = true
                        WBattleGlobal:getCurrent():setHeroExitWithId(playerId)
                    end
                else
                    hero.m_bLoseNet = false
                end
                hero:setRunStatus(RunStatus.DEF_ST_NORMAL)
                -- --副本4 boss记录
                -- if isBoss4 then
                --     if hero:getType() == 1 and dataIds[id] > 0 and masterIds[id] ~= 0 then
                --         isCommonBoss4 = false
                --     else
                --         boss4 = hero
                --     end
                -- end
               
                hero:setHp(hp[id])

                hero:setSp(sp[id], true)
                hero:setPosition({x=postionX[id],y=postionY[id]})

                local isOutOfScene,_ = hero:checkIsOutOfScene()
                --掉坑处理
            --    if playerId == WBattleGlobal:getCurrent():getMyBattleId() and hero:isServerDead() == false and isOutOfScene then
                if hero:isServerDead() == false and isOutOfScene then
                    ProtocolProcessorBattleInterface:send_BATTLE_OutOfScene(WBattleGlobal:getCurrent().m_tMakePairOk.battleId, hero:getBattleId() ,hero.m_nPlayerId, hero:getType(), WBattleGlobal:getCurrent():getCurrentCharacter():getType() )   
                end

                hero:getAnimation():setRotate(angle[id])
                hero:getAnimation():setFlipX(face[id] == 1 and true or false)
                BattleCtbManager:setCtb(playerId,CTB[id],true)
                if hp[id] == 0 then
                    hero:setDead(true)
                    hero:setServerDead(true)
                else
                    hero:getAnimation():play(hero:getNormalAnimationName(), true)
                end
                break
            end
        end
    end
    --副本4血槽处理
    -- if isBoss4 and boss4:getHp() > 0 then
    --     if not isCommonBoss4 and not boss4.m_nMaxHP_bak then
    --         boss4.m_nMaxHP_bak = boss4:getMaxHp()
    --         boss4:setMaxHp(boss4:getHp())
    --     else
    --         if boss4.m_nMaxHP_bak then
    --             boss4:setMaxHp(boss4.m_nMaxHP_bak)
    --             boss4.m_nMaxHP_bak = nil
    --         end
    --     end
    -- end

    --增减buff
    local list = WBattleGlobal:getCurrent():getCharacterList()
    for i, hero in pairs (list) do
        hero:updateByTurn()
        for id, playerId in ipairs (playerIds) do
            if hero:getBattleId() == playerId and hero:isDead() ~= true then
                local buffList = {}
                table.insert(buffList, {buffId=-1, buffPassCtb=-1, buffUserId=-1})
                local indexBuffId = 1
                for index = 1, id -1 do
                    indexBuffId = indexBuffId + buffCount[index]
                end

                for index = indexBuffId, indexBuffId + buffCount[id] - 1 do
                    table.insert(buffList, {buffId=buffId[index], buffPassCtb=buffPassCtb[index], buffUserId=buffUserId[index]})
                end
                WZLog("WBattleGlobal:synchronousBattleInfo three", i, id, indexBuffId, #hero.m_tBuffChangeStateList, "\n", Serialize(buffList))

                
                for index, buffPlayer in pairs (buffList) do
                    local isExist = false
                    for id = #hero.m_tBuffChangeStateList, 1, -1 do
                        local buff = hero.m_tBuffChangeStateList[id]
                        WZLog("WBattleGlobal:synchronousBattleInfo four-0", tostring(buff))
                        if buff then
                            if buff.m_nID == buffPlayer.buffId then
                                WZLog("WBattleGlobal:synchronousBattleInfo four-1",buff.m_nID, buff.m_nTimeDurationValue, buff.m_nTimePassValue, buff.m_nTimePassValueReal, buffPlayer.buffPassCtb)
                                buff.m_nTimePassValue = buff.m_nTimeDurationValue - buffPlayer.buffPassCtb
                                buff.m_nTimePassValueReal = buff.m_nTimeDurationValue - buffPlayer.buffPassCtb
                                buff.m_nTakeEffectCount = math.floor(buff.m_nTimePassValueReal / buff.m_nTimeIntervalValue)
                                buff.m_nTakeEffectCountReal = buff.m_nTakeEffectCount
                                isExist = true
                                break
                            else
                                local isExist2 = false
                                for index2, buffPlayer2 in pairs (buffList) do
                                    if buff.m_nID == buffPlayer2.buffId then
                                        isExist2 = true
                                        WZLog("WBattleGlobal:synchronousBattleInfo four-2",buff.m_nID)
                                    end
                                end

                                --删buff
                                if isExist2 == false then
                                    WZLog("WBattleGlobal:synchronousBattleInfo four-3",buff.m_nID)
                                    hero:removeBuffSpecialInfluence(buff)
                                    buff:removeAnime()
                                    hero.m_tBuffChangeStateList[id] = nil
                                end
                            end
                        end
                    end

                    --加buff
                    if isExist == false and buffPlayer.buffId > 0 then
                        local tmpIndex = 1
                        for id, playerId in ipairs (playerIds) do
                            if buffPlayer.buffUserId == playerId then
                                tmpIndex = id
                            end
                        end

                        local templateId = dataIds[tmpIndex];
                        local buffAtk = BossData["id_"..templateId] and BossData["id_"..templateId].attack or 0
                        WZLog("WBattleGlobal:synchronousBattleInfo four-4",buffPlayer.buffId, buffPlayer.buffUserId, buffPlayer.buffPassCtb)
                        local buff = WBattleGlobal:addBuff({hero},buffPlayer.buffId,buffPlayer.buffUserId,buffAtk)
                        if buff then
                            buff.m_nTimePassValue = buff.m_nTimeDurationValue - buffPlayer.buffPassCtb
                            buff.m_nTimePassValueReal = buff.m_nTimeDurationValue - buffPlayer.buffPassCtb
                            buff.m_nTakeEffectCount = math.floor(buff.m_nTimePassValueReal / buff.m_nTimeIntervalValue)
                            buff.m_nTakeEffectCountReal = buff.m_nTakeEffectCount
                        end
                    end
                end
            end
        end
    end

    --地图爆炸
    if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_NORMAL then
        --地图复原
        BattleMapManager:reload()
        
        local startIndex = 0
        for i, playerId in ipairs (explodePlayerId) do
            if i > 1 then
                startIndex = startIndex + explodePosNum[i-1]
            end
            for id=1,explodePosNum[i] do
                local hero = WBattleGlobal:getCurrent():getCharacterWithId(playerId)
                if hero then
                    local pos = {x=explodePosX[startIndex+id],y=explodePosY[startIndex+id]}
                    local breakCircle = tolua.cast(hero:getBulletCilcle():objectAtIndex(0),"WDMemoryImage")
                    local breakCircleMark = tolua.cast(hero:getBulletCilcle():objectAtIndex(1),"WDMemoryImage")
                    local rect = hero:getRectForBulletExplodeBomb(explodeSkillId[i])
                    WZLog("WBattleGlobal:synchronousBattleInfo seven", i, id, playerId, explodeSkillId[i], explodePosNum[i], pos.x, pos.y, rect.x, rect.y)
                    BattleMapManager:drawBroke(Vector2:create(pos.x, pos.y), breakCircle, breakCircleMark, rect.x, rect.y)
                end
            end
        end
    end

    --被杀次数
    if killCount then
        if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_NORMAL and WBattleGlobal:getCurrent().m_tMakePairOk.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_FH then
            local ourCount, enemyCount = 0,0
            local list = WBattleGlobal:getCurrent():getCharacterList()
            for i, hero in pairs (list) do
                for id, playerId in ipairs (playerIds) do
                    if hero:getBattleId() == playerId then
                        if self:isMyTeam(playerId) then
                            ourCount = ourCount + killCount[id]
                            WZLog("WBattleGlobal:synchronousBattleInfo nine-1", playerId, killCount[i])
                        else
                            enemyCount = enemyCount + killCount[id]
                            WZLog("WBattleGlobal:synchronousBattleInfo nine-2", playerId, killCount[i])
                        end
                    end
                end
            end
            WZLog("WBattleGlobal:synchronousBattleInfo nine-3", ourCount, enemyCount)
            self:setLeftMedal(enemyCount)
            self:setRightMedal(ourCount)
        end
    end

    --绝地冒险
    if self:isEscapeBattle() then
        --清雾
        if self:isFog() and self.m_tFogData then
            for cleanType=1,3 do
                local list = self.m_tFogData.posList[cleanType]
                WZLog("WBattleGlobal:synchronousBattleInfo ten-1", cleanType, #list)
                for i,info in ipairs(list) do
                    WZLog("WBattleGlobal:synchronousBattleInfo ten-2", info.x, info.y, info.width, info.height)
                    self:doCleanFog(info.x*2, info.y*2, cleanType, info.width*2, info.height*2, true)
                end
            end
        end

        WZLog("WBattleGlobal:synchronousBattleInfo ten-3", type(battleInfo), battleInfo)
        battleInfo = json.decode(battleInfo)

        --获得道具
        if battleInfo.escapeBattle then
            --propsIds 二维数组
            local list = {}
            for i,info in ipairs(propIds) do
                local propInfo = SplitStringWithSeparator(info, "|", nil, true)
                table.insert(list, propInfo)
            end
            local msg = MsgManager:createMsg(BattleMsgGetProp)
            msg.m_tData = {playerIds=playerIds,propsIds=list}
            MsgManager:pushNonBlockMsg(msg)
        end
        
        --毒雾
        if battleInfo.escapeBattle and self:isErosion() then
            local poisonFog= SceneBattle:getPoisonFog()
            if battleInfo.escapeBattle.erosionDir == 1 then
                self.m_tErosionData.erosionX = 2300
                if poisonFog:getScaleX() > 0 then
                    poisonFog:setScaleX(poisonFog:getScaleX() * -1)
                end
                local x, y = poisonFog:getAbsPosition().x, poisonFog:getAbsPosition().y
                poisonFog:setAbsPosition(GlobalMethod:ccp(2404, y))
            elseif battleInfo.escapeBattle.erosionDir == 0 then
                self.m_tErosionData.erosionX = 0
                local x, y = poisonFog:getAbsPosition().x, poisonFog:getAbsPosition().y
                poisonFog:setAbsPosition(GlobalMethod:ccp(-100, y))
            else
                self.m_tErosionData.erosionX = 0
                self.m_tErosionData.erosionX2 = 2300
                local x, y = poisonFog:getAbsPosition().x, poisonFog:getAbsPosition().y
                poisonFog:setAbsPosition(GlobalMethod:ccp(-100, y))

                local poisonFog2 = SceneBattle:getPoisonFog2()
                poisonFog2:setVisible(true)
                if poisonFog2:getScaleX() > 0 then
                    poisonFog2:setScaleX(poisonFog2:getScaleX() * -1)
                end
                x, y = poisonFog2:getAbsPosition().x, poisonFog2:getAbsPosition().y
                poisonFog2:setAbsPosition(GlobalMethod:ccp(2404, y))
                --SceneBattle:getFogLayer2():setVisible(false)
            end
            self.m_tErosionData.count = 0
            self:doMapErosion(battleInfo.escapeBattle.erosionCount, battleInfo.escapeBattle.erosionDir)
        end

        --宝箱
        if battleInfo.escapeBattle then
            self:synchronousBuildErosionTreasure(battleInfo.escapeBattle.treasureIdList, 
                battleInfo.escapeBattle.treasureCatchIdIdList, battleInfo.escapeBattle.treasurePosList)
        end
    end

    if WBattleGlobal:getCurrent():isAudience() then
        for i,hero in pairs(WBattleGlobal:getCurrent():getHeroList()) do
            WBattleGlobal:getCurrent().m_battleManager:addEntity(hero:getMover())
        end
    end
end
--@brief 获取自己的武器是否具有某些技能
function WBattleGlobal:isMyWeaponHaveSkill(skillType)
    local isMyWeaponHaveSkill = false
    for i ,skillId in pairs (WBattleGlobal:getCurrent().m_tMySkill_Beginning.id) do
        local skillInfo = GDatatab_skill["id_"..skillId]
        if skillInfo.sub_type == skillType then
            isMyWeaponHaveSkill = true
            break
        end
    end
    WZLog("WBattleGlobal:isMyWeaponHaveSkill", tostring(isMyWeaponHaveSkill), skillType)
    return isMyWeaponHaveSkill
end

--@brief  lua垃圾回收
function WBattleGlobal:collectGarbage()
    self.m_lastGCTime = os.time()
    collectgarbage("collect")
	collectgarbage("stop")
end

--@brief   检查是否需要垃圾回收
--@param   nDelt 垃圾回收时间间隔
function WBattleGlobal:checkCollectGarbage(nDelt)
    if os.time() - self.m_lastGCTime > nDelt then 
        self:collectGarbage()
    end
end

--@brief  是否正在重连
function WBattleGlobal:isRelink()
    return WBattleGlobal:getCurrent().m_nRelinkLoading ~= -1
end

--@brief 聊天
function WBattleGlobal:battleTalk(playerId, text, bubbleId)
    if SceneBattle.m_root == nil then return end
    
    local list = WBattleGlobal:getCurrent():getHeroList()
    if list then
        for id,hero in pairs (list) do
            if hero:getBattleId() == playerId then
                hero:talk(text, bubbleId)
            end
        end
    end
end

--@breif 记录位置
function WBattleGlobal:replayRecordSinglePos()
        if WBattleGlobal:getCurrent():canRecordGame() then
        --录像记录
        
        local nPlayerCount = 0
        local tPlayerId = {}
        local tCurPositionX = {}
        local tCurPositionY = {}
        local tCurPositionR = {}
        local tCurPositionD = {}
        for id, player in pairs(WBattleGlobal:getCurrent():getHeroList()) do
            table.insert(tPlayerId, id)
            table.insert(tCurPositionX, player:getAnimation():getPosition().x)
            table.insert(tCurPositionY, player:getAnimation():getPosition().y)
            table.insert(tCurPositionR, player:getAnimation():getRotate())
            table.insert(tCurPositionD, player:getAnimation():isFlipX() and 1 or 0)
            nPlayerCount = nPlayerCount + 1
        end

        if WBattleGlobal:getCurrent():getGuaiList() ~= nil then
            for id,guai in pairs(WBattleGlobal:getCurrent():getGuaiList()) do
                if id ~= -1 then
                    table.insert(tPlayerId,id)
                    table.insert(tCurPositionX, guai:getAnimation():getPosition().x)
                    table.insert(tCurPositionY, guai:getAnimation():getPosition().y)
                    nPlayerCount = nPlayerCount + 1
                end
            end
        end
        replayParam = {}
        replayParam.nPlayerCount = nPlayerCount
        replayParam.tPlayerId = tPlayerId
        replayParam.tCurPositionX = tCurPositionX
        replayParam.tCurPositionY = tCurPositionY
        replayParam.tCurPositionR = tCurPositionR
        replayParam.tCurPositionD = tCurPositionD
        BattleMsgReplayGameRecord:setBattlePos(replayParam)
    end
end

--@brief 宠物技能使用
function WBattleGlobal:petSkillUse()
    local list = {}
    for i,hero in pairs(WBattleGlobal:getCurrent():getHeroList()) do
        if not hero:isDead() then
            table.insert(list,hero)
        end
    end
    BattlePetSkillManager:triggerPassiveSkill(list)
end

--@brief 刷新隐身
function WBattleGlobal:updateHideView()
    --@brief检测隐身状态
    local list = WBattleGlobal:getCurrent():getCharacterList()
    
    local myTeamList = {}
    local enemyList = {}
    --玩家自己队伍
    for i,v in pairs(list) do
        if v:isDead() ~= true then
            if v:getCamp() == WBattleGlobal:getCurrent():getMyHero():getCamp() then
                if v.m_nHideViewDis then
                    table.insert(myTeamList,v)
                end
            else
                if v:isHide() then
                    table.insert(enemyList,v)
                end
            end
        end
    end

    if #myTeamList == 0 or #enemyList == 0 then
        return
    end
    local indexList = {}
    for i,hero in pairs(myTeamList) do
        for k = 1,#enemyList do
            local enemy = enemyList[k]
            if BattleCommon:pointDis(hero:getPosition(),enemy:getPosition()) <= hero.m_nHideViewDis then
                indexList[k] = true
            end
        end
    end

    for i = 1,#enemyList do
        local enemy = enemyList[i]
        if indexList[i] then
            enemy:hide(true)
        else
            enemy:hide(false)
        end
    end
end

--@brief 风力引导
function WBattleGlobal:isWindTeach()
    local isWindTeach = self.m_bIsWindTeach

    if TeachGroup1:isTeach() and isWindTeach == nil then
        local mapId = self.m_tMakePairOk.mapId
        if mapId == 10301 or mapId == 10302 then
            local isEndTeach46, step46 = TeachGroup1:isTeachFinish(46)
            local isEndTeach47, step47 = TeachGroup1:isTeachFinish(47)
            if mapId == 10301 and isEndTeach46 ~= true or mapId == 10302 and isEndTeach47 ~= true then
                isWindTeach = true
                self.m_bIsWindTeach = true
            else
                isWindTeach = false
                self.m_bIsWindTeach = false
            end
            WZLog("WBattleGlobal:isWindTeach", isWindTeach, mapId, isEndTeach46, isEndTeach47)
        end
    end
    return isWindTeach
end

--@brief 第一章引导
function WBattleGlobal:isChapterOneTeach()
    local isChapterOneTeach = self.m_bIsChapterOneTeach

    if TeachGroup1:isTeach() and isChapterOneTeach == nil then
        local mapId = self.m_tMakePairOk.mapId
        if (mapId == 10102 or mapId == 10103 or mapId == 10104 or mapId == 10105) and CacheCenter:getPlayerInfo().level <= 5 then
            isChapterOneTeach = true
            self.m_bIsChapterOneTeach = true
        else
            isChapterOneTeach = false
            self.m_bIsChapterOneTeach = false
        end
        WZLog("WBattleGlobal:isChapterOneTeach", isChapterOneTeach, mapId, CacheCenter:getPlayerInfo().level)
    end
    return isChapterOneTeach
end

--@brief 新手boss和第一章第一关引导
function WBattleGlobal:isBossAndChapterOneTeach()
    local isBossAndChapterOneTeach = self.m_bIsBossAndChapterOneTeach

    if TeachGroup1:isTeach() and isBossAndChapterOneTeach == nil then
        local mapId = self.m_tMakePairOk.mapId
        if (mapId == 9999 or mapId == 10101) and CacheCenter:getPlayerInfo().level <= 1 then
            isBossAndChapterOneTeach = true
            self.m_bIsBossAndChapterOneTeach = true
        else
            isBossAndChapterOneTeach = false
            self.m_bIsBossAndChapterOneTeach = false
        end
        WZLog("WBattleGlobal:isBossAndChapterOneTeach", isBossAndChapterOneTeach, mapId, CacheCenter:getPlayerInfo().level)
    end
    return isBossAndChapterOneTeach
end

--@brief 结束隐藏
function WBattleGlobal:endHideView()
    local list = WBattleGlobal:getCurrent():getCharacterList()
    for i,v in pairs(list) do
        if v:getCamp() ~= WBattleGlobal:getCurrent():getMyHero():getCamp() and v:isHide() then
            v:hide()
        end
    end
end

--@brief 添加已发送掉坑对象状态记录
function WBattleGlobal:addSendOutSceneRecord(battleId)
    local myhero = WBattleGlobal:getCurrent():getMyHero()
    if not myhero.m_tSendOutOfScene then
       myhero.m_tSendOutOfScene = {}
    end
    table.insert(myhero.m_tSendOutOfScene,battleId)
end

--@brief 移除已发送掉坑对象状态记录
function WBattleGlobal:removeSendOutSceneRecord(battleId)
    local myhero = WBattleGlobal:getCurrent():getMyHero()
    if myhero.m_tSendOutOfScene then
        for i = #myhero.m_tSendOutOfScene, 1, -1 do
            local sendId = myhero.m_tSendOutOfScene[i]
            if battleId == sendId then
                table.remove(myhero.m_tSendOutOfScene,i)
            end
        end
    end
end

--@brief 已发送掉坑对象状态
function WBattleGlobal:inSendOutSceneRecord(battleId)
    local myhero = WBattleGlobal:getCurrent():getMyHero()
    if myhero.m_tSendOutOfScene then
        for i, v in pairs (myhero.m_tSendOutOfScene) do
            if v == battleId then
                return true
            end
        end
    end
    return false
end

--@brief    获取英雄的怪物形象
function WBattleGlobal:getHeroMonster()
    -- body
    return self.m_monsterHero
end

--@brief    通过ID设置角色对象
--@param    nId:角色ID
--@return   #1:查找到的角色对象,或不存在则返回nil
function WBattleGlobal:setHeroWithId(nId, hero)
    self.m_tHeros[nId] = hero
end

--@brief    设置当前溅射弹角度列表
function WBattleGlobal:setCurSpatterAngle(tSpatterAngle)
    -- body
    for i = 1, #tSpatterAngle do
    --    if tSpatterAngle[i] > 90 then 
            tSpatterAngle[i] = 90 - tSpatterAngle[i] 
    --    end
    end
    self.m_tSpatterAngle = tSpatterAngle
end

--@brief    获取保存的溅射弹角度
function WBattleGlobal:getCurSpatterAngle()
    -- body
    return self.m_tSpatterAngle
end
-------------------------------------私有方法模块--------------------------------------

--@brief	战斗管理对象初始化函数
--@return	#1:战斗管理对象表
function WBattleGlobal:_init()
	g_battleGlobal = {}
	setmetatable(g_battleGlobal, {__index = WBattleGlobal})
	g_battleGlobal.m_fShakeHands = 0
	g_battleGlobal.m_tHeros = {}
	g_battleGlobal.m_tExitHeros = {}
	g_battleGlobal.m_tGuais = {}
	g_battleGlobal.m_tGuaiBattleId = {}
	g_battleGlobal.m_tGuaisTemplate = {}
	g_battleGlobal.m_tBullets = {}
	g_battleGlobal.m_tBossBullets = {}
    g_battleGlobal.m_tMachines = {}
	g_battleGlobal.m_tWind = {x=0,y=0}
	g_battleGlobal.m_nTurnTimes = 0
    g_battleGlobal.m_nRecordRound = 0
	g_battleGlobal.m_bWaitNextRound = false
	g_battleGlobal.m_nReference = 1
    g_battleGlobal.m_bShowGameOver = true
    g_battleGlobal.m_nMachineBattleId = 1
    g_battleGlobal.m_tKillCountList = {}
    g_battleGlobal.m_nShowKillTime = -1
    g_battleGlobal.m_nShowNetLostTime= -1
    g_battleGlobal.m_nShowNetLost = nil
    g_battleGlobal.m_lastGCTime = os.time()
    g_battleGlobal.m_tRoundInfoList = {}
    g_battleGlobal.m_nRelinkLoading = -1
    g_battleGlobal.m_nComeBackBattleId = -1
    g_battleGlobal.m_nScale = 0
    g_battleGlobal.m_tCharacterAttributeList = {}
    g_battleGlobal.m_nNetLoading = -1
    g_battleGlobal.m_bSendCurRoundInfo = -1
    g_battleGlobal.m_nSendCurRoundInfoTimer = -1
    g_battleGlobal.m_bSendCurRoundInfoOk = -1
    g_battleGlobal.m_bSendCurRoundInfoLisk = {}
    g_battleGlobal.m_nShowNetTipType = -1
    g_battleGlobal.m_nShowNetTipId = -1
    g_battleGlobal.m_bIsAudience = nil
    g_battleGlobal.m_nLaserGunState = 1
    g_battleGlobal.m_nMyRemainHp = -1
    g_battleGlobal.m_tWaitForRebornPosList = nil

    g_battleGlobal.m_nAwakeSkillId = nil
    g_battleGlobal.m_bIsCanUseAwakeSkill = true

    if ProjConfig.DEBUG == 1 then
        -- g_battleGlobal.m_isQuickCopyTest = true
	end
	LoadBattleConfig()
	return g_battleGlobal
end
