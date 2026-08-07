--BattleMsgPlayerShoot.lua
--@brief	玩家射击消息
--@date		2013/1/8
--@author	李光森
--@note

--@brief	消息数据表
BattleMsgPlayerShoot = {
    m_sName = "BattleMsgPlayerShoot",
	m_nBattleId = 0,	 			--战斗id
	m_nPlayerId = 0, 				--角色id(发给哪个的)
	m_nCurrentPlayerId = 0, 		--角色id(当前在操作的角色）
	m_nSpeedx = 0, 					--发射速度
	m_nSpeedy = 0, 					--发射速度
	m_nLeftRight = 0, 				--1：左 0：右（向左还是向右）
	m_nStartX = 0, 					--发射初始位置
	m_nStartY = 0, 					--发射初始位置
    m_nEndX = 0,                    --发射终点位置 宇航员大招需要用到
    m_nEndY = 0,                    --发射终点位置 宇航员大招需要用到

	m_nPlayerCount = 0, 			--同步角色数量
	m_tPlayerId = nil, 				--用户id列表
	m_tCurPositionX = nil, 			--没飞行前的x坐标
	m_tCurPositionY = nil, 			--没飞行前的y坐标

	m_nGuaiCount = 0, 				--同步怪物数量
	m_tGuaiBattleId = nil, 		--怪物id列表
	m_tGuaiCurPositionX = nil, 		--怪物没飞行前的x坐标
	m_tGuaiCurPositionY = nil, 		--怪物没飞行前的y坐标

-------------------------------------处理逻辑使用的变量--------------------------------------
    m_tStepFunction = {},           --步骤函数
	m_tScreenSpring = nil,			--屏幕是否在震动
	m_tFirstHitEnemy = nil,			--打中对方的英雄
	m_tHurtChara = nil,				--纪录受伤英雄
	m_tHurtValues = nil,			--纪录受伤值
	m_nTimeRemain = nil,			--射击剩余时间
	m_bCanFallDown = nil,			--射击的玩家是否可以下落

    m_nShootDeltaTime = 0,   --发炮间隔时间
    m_nReadyToShootDeltaTime = 0,   --从做发炮准备动作到正式发炮的间隔时间, 默认为等待到动画结束就发炮
    m_tNoPetAttack = nil,           --是否宠物攻击
    m_tPetAttackEnemy = nil,        --宠物攻击敌人
    m_tFrozenEnemy = nil,           --冰冻敌人
    m_nBigSkillState = 1,
    m_nSpringCount = 0,
    m_nWaitDeltaTime = 0,
    m_bIsPetShoot = nil,
    m_nBigSkillNumber = nil,
    --穿透子弹计算    
    m_tPenetrateList = nil,
    m_tPenetrateValList = nil,
    m_tPenetrateDisList = nil,
    m_tPenetrateCritList = nil,
    m_tCheckList = {},
    m_bIsAllFalse = nil,
    m_bIsUseSkinBigSkill = false,    --是否使用皮肤大招
    m_nSkinBigSkillType = 0,    --皮肤大招Id
    m_nLastScale = 0,           --原镜头大小
    m_nBulletIndex = 1,         --子弹索引
    m_tSubRoleElement = nil,    --保存皮肤大招分身
    m_tBulletStartPos = nil,    --某些皮肤大招子弹初始坐标
    m_nCurTimerScale = 1,       
    m_nBulletAniReplica = nil,     --子弹动画复制体
    m_nPlaySkinBigSKillAttackAni = 0, --播放攻击动画延迟
    m_nSkinSkillBeforeAttackDelayed = 0, --皮肤大招攻击前动画延迟
    m_nIsSkinGroupBullet = false,       --是否使用共生录子弹
    m_nBulletEndX = nil, 
    m_nBulletEndY = nil, 
    m_bIsTurnDir = false,       --是否已經转向
    --穿透子弹向上过程中的伤害计算    
    m_tUpPenetrateList = nil,
    m_tUpPenetrateValList = nil,
    m_tUpPenetrateDisList = nil,
    m_tUpPenetrateCritList = nil,
    --穿透子弹向下过程中的伤害计算    
    m_tDownPenetrateList = nil,
    m_tDownPenetrateValList = nil,
    m_tDownPenetrateDisList = nil,
    m_tDownPenetrateCritList = nil,
    m_nChooseTarget = nil,     --皮肤大招选择的目标
    m_tSkillOwner = nil,        --技能效果所属的玩家(棋圣黑分身攻击触发集中生效再触发子技能时（如溅射等），保证所属为分身，而不是当前回合的玩家)
}

g_nCollisionIndex = 0    --是否首次子弹碰撞 0还未有碰撞；1首次碰撞；2首次碰撞特殊处理完成
-------------------------------------公有方法模块--------------------------------------
--local WZLog = doNone
--@brief	消息初始化函数
--@note		消息系统第一次调用process函数前调用
function BattleMsgPlayerShoot:init()
    self:_float2int2float()
    WZLog("BattleMsgPlayerShoot:init Zero", self.m_nSpeedx, self.m_nSpeedy, self.m_nCurrentPlayerId)
    --地图buff检测
    WBattleGlobal:getCurrent():checkHurtBuffTotem(MonsterType.BUFF_TOTEM)
    
    --录像记录
    self:_recordedSingleShoot()
    
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
    if TeachGroup1.ISBATTLE_MYTURN ~= true and SceneBattle:getBattleLoop():getBattleStatus() ~= BattleLoop.S_NORMAL then
        if not (hero and hero:getIsSubHero()) then 
            return
        end
    end

    if TeachGroup1.ISBATTLE_MYTURN then
        TeachGroup1.ISSHOOT = true
    end

    WBattleGlobal:getCurrent():ClearHurt()
    if not hero:getIsSubHero() then 
        WBattleGlobal:getCurrent().m_bIsCurTurnActed = true
        WBattleGlobal:getCurrent().m_bIsCurRoundFirstBullet = true
        hero.m_bIsDoShoot = true 
    end

	SceneBattle:getBattleLoop():setBattleStatus(BattleLoop.S_PLAYER_SHOOT)
    WBattleGlobal:getCurrent().m_tAttackRandomList = {}
    WBattleGlobal:getCurrent().m_tTargetRandomList = {}

	if hero == nil then
		WZLog("BattleMsgPlayerShoot:init", "can't find player:", self.m_nCurrentPlayerId)
		return
	end
    --用于灵魂分身
    if WBattleGlobal:getCurrent().m_tCurRoundSoulHeroShootId and #WBattleGlobal:getCurrent().m_tCurRoundSoulHeroShootId > 0 and utilsValueInTable(self.m_nCurrentPlayerId, WBattleGlobal:getCurrent().m_tCurRoundSoulHeroShootId) then 
        for i = 1, #WBattleGlobal:getCurrent().m_tCurRoundSoulHeroShootId do
            if WBattleGlobal:getCurrent().m_tCurRoundSoulHeroShootId[i] == self.m_nCurrentPlayerId then 
                table.remove(WBattleGlobal:getCurrent().m_tCurRoundSoulHeroShootId, i)
                break 
            end
        end
    end
    --维护分身出手计数
    self.m_tSkillOwner = nil 
    if hero:getIsSubHero() then 
        if hero:getSubType() == CharacterSubType.SUBTYPE_BCHESS then 
            WBattleGlobal:getCurrent().m_nCurRoundSubHeroShootCount = WBattleGlobal:getCurrent().m_nCurRoundSubHeroShootCount - 1
        end
        self.m_tSkillOwner = hero
    end

    --穿透子弹
    self.m_tPenetrateList = {}
    self.m_tPenetrateValList = {}
    self.m_tPenetrateDisList = {}
    self.m_tPenetrateCritList = {}
    self.m_tUpPenetrateList = {}
    self.m_tUpPenetrateValList = {}
    self.m_tUpPenetrateDisList = {}
    self.m_tUpPenetrateCritList = {}
    self.m_tDownPenetrateList = {}
    self.m_tDownPenetrateValList = {}
    self.m_tDownPenetrateDisList = {}
    self.m_tDownPenetrateCritList = {}
    g_nCollisionIndex = 0 
    self.m_nBulletIndex = 1 
    self.m_tSubRoleElement = nil 
    self.m_bIsTurnDir = false 
    self.m_nLastScale = BattleScreen:getBattle():getFrontLayer():getScale()
    self:_postPlayerShootEvent()
    self.m_nCurTimerScale = CCDirector:sharedDirector():getScheduler():getTimeScale()
    WBattleGlobal:getCurrent().m_nCurTimerScale = self.m_nCurTimerScale
    self.m_nPlaySkinBigSKillAttackAni = 0
    self.m_nSkinSkillBeforeAttackDelayed = 0
    local attackSkillBullet = BattleAttackSkillManager:getAttackSkillBullet()
    self.m_nIsSkinGroupBullet = false 
    if attackSkillBullet then 
        self.m_nIsSkinGroupBullet = CheckEffectFile("battle/atkEffect/" .. attackSkillBullet) 
    end

    WBattleGlobal:getCurrent().m_tCurRoundAction = {round=WBattleGlobal:getCurrent().m_nTurnTimes, player=self.m_nCurrentPlayerId}

    self.m_bIsUseSkinBigSkill = hero:getUseSkinBigSkill()
    self.m_nSkinBigSkillType = hero:getSkinBigSkill()
    if hero:getUseBigSkill() == true then
        hero:removeAngerAnimation()
    end

	hero:setRunStatus(RunStatus.DEF_ST_READY_SHOOT)

    local myHero = WBattleGlobal:getCurrent():getMyHero()
    if self.m_nCurrentPlayerId == myHero:getBattleId() and not WBattleGlobal:getCurrent():isAudience() then
        myHero.m_nShootCount = myHero.m_nShootCount + hero:getAttTimes() * hero:getAttScatterNum()
    end

    -- if WBattleGlobal:getCurrent():isSingleStage() and self.m_nCurrentPlayerId == myHero:getBattleId() then
        -- local turnTimes = WBattleGlobal:getCurrent().m_nTurnTimes
        -- local record = WBattleGlobal:getCurrent().m_tBattleRecord[turnTimes]
        -- record.bulletCount = hero:getAttTimes() * hero:getAttScatterNum()
    -- end
    -- if WBattleGlobal:getCurrent():isSingleStage() then
    --     WBattleGlobal:getCurrent():setBulletNum(hero:getAttTimes() * hero:getAttScatterNum())
    -- end

	if self.m_nLeftRight == 1 then
		hero:getAnimation():setFlipX(true)
	else
		hero:getAnimation():setFlipX(false)
	end
    WZLog("BattleMsgPlayerShoot:init", tostring(hero:getAnimation():isFlipX()))

	WndBattleHud:setPassTurnBtnEnable(false)
	WndBattleHud:endTurnTime()

	if not hero:getUseBigSkill() then
		--hero:useWeaponSkill()
	end

	local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)

    local isCanControl = false
    if hero:isCanControl() == true and hero:getBattleId() ~= WBattleGlobal:getCurrent():getMyHero():getBattleId() then
        isCanControl = true
        WZLog("BattleMsgPlayerShoot:init one")
    end

    WZLog("BattleMsgPlayerShoot:init two",self.m_nPlayerId, tostring(hero), tostring(hero and hero.m_bIsUseSkill), tostring(isCanControl))
    if (hero == nil or hero.m_bIsUseSkill == nil) then
        if isCanControl == true or self.m_nCurrentPlayerId == WBattleGlobal:getCurrent():getMyBattleId() then
            hero:setUseSkillId(1001)
            ProtocolProcessorBattleInterface:send_BATTLE_SkillEquip(WBattleGlobal:getCurrent():getBattleId(), self.m_nCurrentPlayerId, 1001 )
        end
		BattleCtbManager:addCtb(self.m_nCurrentPlayerId,BattleCtbManager.SHOOT_CTB)
    end
    --录像或直播  只同步坐标
    local isSpecBattle = false
    if WBattleGlobal:getCurrent():isAudience() or WBattleGlobal:getCurrent():isReplayGame() then
        isSpecBattle = true
    end
	--协议发送
	if self.m_nCurrentPlayerId == WBattleGlobal:getCurrent():getMyBattleId() and not isSpecBattle then
		self:_sendBattleShoot()
    elseif WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS and hero:isCanControl() and not isSpecBattle and hero:getIsGuai() then
        self:_sendBossBattleShoot()
	else
       self:_syncBattleShoot()
	end

	self.m_tStepFunction = {}
	if hero and hero:getUseBigSkill() then
        if self.m_bIsUseSkinBigSkill then
		    table.insert(self.m_tStepFunction,self._showSkinBigSkillNew)
            if self.m_nSkinBigSkillType == 3005 then 
                table.insert(self.m_tStepFunction,self._showSkinHero)
                table.insert(self.m_tStepFunction,self._ZoomOut)
                table.insert(self.m_tStepFunction,self._hideSkinHero)
                table.insert(self.m_tStepFunction,self._createSubRoleToAttack)
                table.insert(self.m_tStepFunction,self._readyCloseShoot)
            elseif self.m_nSkinBigSkillType == 3016 or self.m_nSkinBigSkillType == 3017 then 
                table.insert(self.m_tStepFunction,self._showSkinHero)
                table.insert(self.m_tStepFunction,self._ZoomOut)
                table.insert(self.m_tStepFunction,self._readyShoot)
                table.insert(self.m_tStepFunction,self._playShootAnim)
                table.insert(self.m_tStepFunction,self._repeatShoot)
            elseif self.m_nSkinBigSkillType == 3042 then
                table.insert(self.m_tStepFunction,self._playShootAnim)
                table.insert(self.m_tStepFunction,self._showSkinHero)
                table.insert(self.m_tStepFunction,self._ZoomOut)
                -- table.insert(self.m_tStepFunction,self._hideSkinHero)
                table.insert(self.m_tStepFunction,self._createSubRoleToAttack)
                table.insert(self.m_tStepFunction,self._readyCloseShoot)
            elseif self.m_nSkinBigSkillType == 3047 or self.m_nSkinBigSkillType == 3050 or self.m_nSkinBigSkillType == 3060 then
                table.insert(self.m_tStepFunction,self._playShootAnim)
                table.insert(self.m_tStepFunction,self._showSkinHero)
                table.insert(self.m_tStepFunction,self._ZoomOut)
                table.insert(self.m_tStepFunction,self._createSubRoleToAttack)
                table.insert(self.m_tStepFunction,self._readyCloseShoot)
            elseif self.m_nSkinBigSkillType == 3058 then
                table.insert(self.m_tStepFunction,self._playShootAnim)
                table.insert(self.m_tStepFunction,self._showSkinHero)
                table.insert(self.m_tStepFunction,self._ZoomOut)
                table.insert(self.m_tStepFunction,self._prePlayShootAni)
                table.insert(self.m_tStepFunction,self._readyShoot)
            else
                if self.m_nSkinBigSkillType ~= 3044 then
                    table.insert(self.m_tStepFunction,self._playShootAnim)
                end
                table.insert(self.m_tStepFunction,self._showSkinHero)
                local tTempList = {3007, 3008, 3012, 3013, 3016, 3017, 3019, 3023, 3025, 3026, 3027, 3028, 3029, 3030, 3033, 3034, 3035, 3036, 3037, 3038, 3044, 3045, 3046, 3049, 3051, 3052, 3053, 3054, 3056, 3057, 3059, 3061, 3063, 3064, 3065}
                if self.m_nSkinBigSkillType == 3006 then 
                    table.insert(self.m_tStepFunction,self._ZoomOut)
                    table.insert(self.m_tStepFunction,self._readyCloseShoot)
                elseif utilsValueInTable(self.m_nSkinBigSkillType, tTempList) then
                    table.insert(self.m_tStepFunction,self._ZoomOut)
                elseif self.m_nSkinBigSkillType >= 3020 and self.m_nSkinBigSkillType <= 3022 then 
                    table.insert(self.m_tStepFunction,self._zoomToHeroMax)
                elseif self.m_nSkinBigSkillType == 3024 or self.m_nSkinBigSkillType == 3048 or self.m_nSkinBigSkillType == 3062 then 
                    table.insert(self.m_tStepFunction,self._ZoomOut)
                    table.insert(self.m_tStepFunction,self.getSkinBigSkillBulletPos)
                else
                    table.insert(self.m_tStepFunction,self._resetZoomToHero)
                    table.insert(self.m_tStepFunction,self._zoomToHero)
                end
                if self.m_nSkinBigSkillType == 3003 or (self.m_nSkinBigSkillType >= 3009 and self.m_nSkinBigSkillType <= 3013) or self.m_nSkinBigSkillType == 3023 or self.m_nSkinBigSkillType == 3029 or self.m_nSkinBigSkillType == 3040 or self.m_nSkinBigSkillType == 3043 or self.m_nSkinBigSkillType == 3041 then 
                    table.insert(self.m_tStepFunction,self._hideSkinHero)
                end
                if self.m_nSkinBigSkillType == 3032 or self.m_nSkinBigSkillType == 3033 or self.m_nSkinBigSkillType == 3037 or self.m_nSkinBigSkillType == 3045 or self.m_nSkinBigSkillType == 3049 or self.m_nSkinBigSkillType == 3052 then 
                    table.insert(self.m_tStepFunction,self._prePlayShootAni)
                end
                if self.m_nSkinBigSkillType == 3064 then 
                    table.insert(self.m_tStepFunction,self._createSubRoleToAttack)
                elseif self.m_nSkinBigSkillType == 3065 then 
                    table.insert(self.m_tStepFunction,self._createSubRoleToAttack)
                end
                if self.m_nSkinBigSkillType ~= 3006 and self.m_nSkinBigSkillType ~= 3059 then 
                    table.insert(self.m_tStepFunction,self._readyShoot)
                    table.insert(self.m_tStepFunction,self._repeatShoot)
                end
            end
            table.insert(self.m_tStepFunction,self._shooting)
            if self.m_nSkinBigSkillType == 3059 then 
                table.insert(self.m_tStepFunction,self._createSubRoleToAttack)
                table.insert(self.m_tStepFunction,self._waitMonsterId)
                table.insert(self.m_tStepFunction,self._buildSubSoul)
                table.insert(self.m_tStepFunction,self._resumeNormalTimer)
            else
                if self.m_nSkinBigSkillType == 3065 then 
                    table.insert(self.m_tStepFunction,self._waitMonsterId)
                    table.insert(self.m_tStepFunction,self._showAttackHero)
                    table.insert(self.m_tStepFunction,self._buildSubChess)
                end
                table.insert(self.m_tStepFunction,self._waitForBulletAndHurt)
                table.insert(self.m_tStepFunction,self._TriggerAfterBleedSkillEffect)
                table.insert(self.m_tStepFunction,self._resumeNormalTimer)
                if self.m_nSkinBigSkillType ~= 3011 and self.m_nSkinBigSkillType ~= 3016 and self.m_nSkinBigSkillType ~= 3017 and self.m_nSkinBigSkillType ~= 3024 and self.m_nSkinBigSkillType ~= 3027 and self.m_nSkinBigSkillType ~= 3048 and self.m_nSkinBigSkillType ~= 3062 and self.m_nSkinBigSkillType ~= 3065 then 
                    table.insert(self.m_tStepFunction,self._showAttackHero)
                end
                table.insert(self.m_tStepFunction,self.checkIsHavePetBeatBack)
                table.insert(self.m_tStepFunction,self._checkPetAttack)
                table.insert(self.m_tStepFunction,self._checkAllCollision)
                if self.m_nSkinBigSkillType == 3016 or self.m_nSkinBigSkillType == 3017 then 
                    table.insert(self.m_tStepFunction,self._checkHaveShowMsg)
                end
                if self.m_nSkinBigSkillType == 3011 or self.m_nSkinBigSkillType == 3016 or self.m_nSkinBigSkillType == 3017 or self.m_nSkinBigSkillType == 3024 or self.m_nSkinBigSkillType == 3048 or self.m_nSkinBigSkillType == 3062 then 
                    table.insert(self.m_tStepFunction,self._showAttackHero)
                end
            end
            table.insert(self.m_tStepFunction,self._ZoomToOrigin)
        else
            table.insert(self.m_tStepFunction,self._showBigSkillNew)
    		if false and hero:getBigSkillType() == 1 then
                table.insert(self.m_tStepFunction,self._playShootAnim)
                table.insert(self.m_tStepFunction,self._repeatBigSkillShootAnim)
                table.insert(self.m_tStepFunction,self._repeatBigSkillShoot)
            else
                table.insert(self.m_tStepFunction,self._playShootAnim)
                table.insert(self.m_tStepFunction,self._readyShoot)
                table.insert(self.m_tStepFunction,self._repeatShoot)
            end
            table.insert(self.m_tStepFunction,self._shooting)
            table.insert(self.m_tStepFunction,self._waitForBulletAndHurt)
            table.insert(self.m_tStepFunction,self._TriggerAfterBleedSkillEffect)
            table.insert(self.m_tStepFunction,self.checkIsHavePetBeatBack)
            table.insert(self.m_tStepFunction,self._checkPetAttack)
            table.insert(self.m_tStepFunction,self._checkAllCollision)
    		--table.insert(self.m_tStepFunction,self._zoomToHero)
        end
	else
		table.insert(self.m_tStepFunction,self._playShootAnim)
		table.insert(self.m_tStepFunction,self._readyShoot)
		table.insert(self.m_tStepFunction,self._repeatShoot)
		table.insert(self.m_tStepFunction,self._shooting)
        table.insert(self.m_tStepFunction,self._waitForBulletAndHurt)
        table.insert(self.m_tStepFunction,self._TriggerAfterBleedSkillEffect)
        table.insert(self.m_tStepFunction,self._showHero)
        table.insert(self.m_tStepFunction,self.checkIsHavePetBeatBack)
        table.insert(self.m_tStepFunction,self._checkPetAttack)
        table.insert(self.m_tStepFunction,self._checkAllCollision)
		--table.insert(self.m_tStepFunction,self._zoomToHero)
	end
    WBattleGlobal:getCurrent():setShowGameOver(false)

    if hero ~= nil and hero.m_bIsAddSpInCurTurn == false then
        hero.m_bIsAddSpInCurTurn = true
        local angerUp =  10
        if WBattleGlobal:getCurrent():isDigGappingFighting() then 
            angerUp = angerUp * GlobalGame.g_nSpAddTimes
        end
        --计算怒气加成
        angerUp = BattleMethod:getSpAddValue(hero, angerUp)
        if (hero:getSp() + angerUp) >= 100 then
            hero:setSp(100)
        else
            hero:setSp(hero:getSp() + angerUp)
        end
    end
end

--@brief	消息处理过程函数
--@return	#1,nil或true表示消息处理结束，否则返回false
--@note		未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgPlayerShoot:process()
    WZLog("BattleMsgPlayerShoot:process zero")
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
    if true or WBattleGlobal:getCurrent():isSingleStage() then
        if hero == nil then
            return true
        end
        local _,isHole = hero:checkIsOutOfScene()
        WZLog("BattleMsgPlayerShoot:process one", tostring(isHole), tostring(hero:isDead()), tostring(#WBattleGlobal:getCurrent():getBulletsList()), tostring(SceneBattle:getBattleLoop():getBattleStatus()),self.m_nBuildBulletsSkillStatusCount)
        if (isHole == true and hero:isDead() == true or hero.m_bLoseNet == true) and (#WBattleGlobal:getCurrent():getBulletsList() <= 0 and self.m_nBuildBulletsSkillStatusCount <= 0) then
            WZLog("BattleMsgPlayerShoot:process two-1")
            return true
        end
    end

    if TeachGroup1.ISBATTLE_MYTURN ~= true and SceneBattle:getBattleLoop():getBattleStatus() ~= BattleLoop.S_PLAYER_SHOOT then
        WZLog("BattleMsgPlayerShoot:process two-2")
        if not hero:getIsSubHero() then 
            return true
        end
    end

	--WBattleGlobal:getCurrent():checkCheat()
    --检测移除皮肤大招分身
    self:removeSubRoleElement()
	--更新子弹状态
	self:_updateBullet()

	--子弹跟随
    if WBattleGlobal:getCurrent().m_bIsGameOverTimer ~= true then
        self:_followBullet()
    else
        self:_zoomToHero()
    end

    --调整表演子弹的角度
    self:_adjustReplicaSchedule()

	--屏幕震动
	self:_updateScene()

	if #self.m_tStepFunction > 0 then
		local res = self.m_tStepFunction[1](self)
		if res == true or res == nil then
			table.remove(self.m_tStepFunction,1)
		end
		return false
	elseif self.m_nBuildBulletsSkillStatusCount > 0 then
        WZLog("BattleMsgPlayerShoot:process two-5")
		return false
    elseif WBattleGlobal:getCurrent():getBulletsList() ~= nil and #WBattleGlobal:getCurrent():getBulletsList() > 0 then 
        WZLog("BattleMsgPlayerShoot:process two-6")
        return false 
    elseif self.m_nReplicaLastPt ~= nil then --等待皮肤大招展示播放完
        return false
	else
		WZLog("BattleMsgPlayerShoot:process two-3")
		return true
	end

	WZLog("BattleMsgPlayerShoot:process two-4")
	return true
end

--@brief	消息处理完成函数
--@note		消息系统最后一次调用process函数后调用
function BattleMsgPlayerShoot:done()
    if self.m_bIsDone ~= true then
        local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
        local loop = SceneBattle:getBattleLoop()
        WZLog("BattleMsgPlayerShoot:done", os.time(), loop:getBattleStatus(), BattleLoop.S_PLAYER_SHOOT)
        WBattleGlobal:getCurrent():setShowGameOver(true)

        if TeachGroup1.ISBATTLE_MYTURN ~= true and loop:getBattleStatus() == BattleLoop.S_PLAYER_SHOOT then
            loop:setBattleStatus(BattleLoop.S_NORMAL)
        else
            --return
        end

        WBattleGlobal:getCurrent().m_bIsZoomToHero = false
        WBattleGlobal:getCurrent().m_nAttackedCount = 1
        Teach:setVisible(false,52)

        self.m_tHurtChara = nil
        self.m_tHurtValues = nil

        if hero then 
            hero.m_nRotatePre = nil

            if hero.m_tBigSkillShootAnim then
                hero.m_tBigSkillShootAnim:getAnimNode():removeFromParentAndCleanup(true)
                hero.m_tBigSkillShootAnim = nil
                WZLog("BattleMsgPlayerShoot:done zero")
            end
        end


        self:_checkPetAttack()
        if hero ~= nil then
            if hero and hero:getUseBigSkill() then
                GetElement(SceneBattle.m_root,"conBigSkill2_SceneBattle",WZUIContainer):setVisible(false)
                GetElement(WndBattleHud.m_root,"conBigSkill2Back_WndBattleHud",WZUIContainer):setVisible(false)
                GetElement(WndBattleHud.m_root,"imgBigSkill2Back_WndBattleHud",WZUIImage):setVisible(false)
            end
            WZLog("BattleMsgPlayerShoot:done two", hero:getAttTimes(), self.m_nCurrentPlayerId)
            hero:setUseBigSkill(false)
            hero:setUseSkinBigSkill(false)

            hero.m_nBigSkillNumber = 0
            hero:setAttTimes(0,2)

            --播放子弹发射后表情
            if self.m_bIsPetShoot ~= true then
                local bHitEnemy = (self.m_tFirstHitEnemy or self.m_tFrozenEnemy) and true or false
                if TeachGroup1.ISBATTLE_MYTURN then
                    bHitEnemy = true
                end

                WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId):showAttackFace(bHitEnemy)
                if bHitEnemy then
                    WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId):getAnimation():play("standby3",false)
                end
            end
        end

        self.m_bIsDone = true
    end

    if TeachGroup1.ISBATTLE_MYTURN then
        TeachGroup1.ISSHOOT = nil
    end

    local bullets = WBattleGlobal:getCurrent():getBulletsList()
    for i=#bullets,1,-1 do
        --移除子弹
        bullets[i]:destroy()
        WBattleGlobal:getCurrent():removeBulletByIndex(i)
        WZLog("BattleMsgPlayerShoot:_updateBullet two-4.3")
    end

    if self.m_bIsPetShoot == true then
        return true
    elseif self.m_nSkillStatusCount == 0 then
	    WZLog("sendMsg BattleMsgEndCurRound: 7")
		--回合结束
        WBattleGlobal:getCurrent():endCurRound(WBattleGlobal:getCurrent():getMyBattleId(),7,nil,nil,true)
    elseif self.m_nSkillStatusCount == -1 then
        WZLog("BattleMsgPlayerShoot:done three")
    else
        WZLog("BattleMsgPlayerShoot:done four", self.m_nSkillStatusCount)
        return false
	end
end


-------------------------------------私有方法模块--------------------------------------
--@brief    检查全部人是否着地或掉坑或死亡
function BattleMsgPlayerShoot:_checkAllCollision()
    WZLog("BattleMsgPlayerShoot:_checkAllCollision")
    for i,hero in pairs(WBattleGlobal:getCurrent():getHeroList()) do
        local _,isHole = hero:checkIsOutOfScene()
        if hero:isDead() ~= true and isHole ~= true and hero:getMover():isCollision() ~= true then
            table.insert(self.m_tCheckList, false)
        else
            table.insert(self.m_tCheckList, true)
        end
    end

    local isAllFalse = true
    for i,v in ipairs(self.m_tCheckList) do
        if v == false then
            isAllFalse = false
        end
    end

    if self.m_bIsAllFalse and isAllFalse then
        GlobalGame:getBattleEventDispatcher():Dispatch(BATTLE_EVENT_TYPE.CHARACTER_HIT_RATE)
        WZLog("BattleMsgPlayerShoot:_checkAllCollision One")
        return true
    end
    self.m_bIsAllFalse = isAllFalse
    self.m_tCheckList = {}
    
    return false
end

--@brief	播放射击动画
function BattleMsgPlayerShoot:_playShootAnim()
    WZLog("BattleMsgPlayerShoot:_playShootAnim")
    if self.m_bIsUseSkinBigSkill and (self.m_nSkinBigSkillType == 3046 or self.m_nSkinBigSkillType == 3050) then
        if self.m_nSkinSkillBeforeAttackDelayed == 0 then
            local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
            self.m_bCanFallDown = false
            hero:setMoveUpdatable(false)
            if hero.m_bIsReadyShoot == nil then
                hero:playReadyShootAnim()
            end
        end

        local nTime = 0
        if self.m_nSkinBigSkillType == 3046 then
            nTime = 52
        elseif self.m_nSkinBigSkillType == 3050 then
            nTime = 30
        end
        if self.m_nSkinSkillBeforeAttackDelayed > nTime then
            return true 
        end

        self.m_nSkinSkillBeforeAttackDelayed = self.m_nSkinSkillBeforeAttackDelayed + 1
        return false
    else
        local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
        self.m_bCanFallDown = false
        hero:setMoveUpdatable(false)
        if hero.m_bIsReadyShoot == nil then
            hero:playReadyShootAnim()
        end

        --hero:addAppearAnimation()
        return true
    end

end

--@brief	播放准备射击动画
function BattleMsgPlayerShoot:_readyShoot()
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)

    WZLog("BattleMsgPlayerShoot:_readyShoot 0:", hero:getAttTimes(), self.m_nAttackedCount)
    --self.m_nReadyToShootDeltaTime = 0.04
    -- self.m_nShootDeltaTime = self.m_nShootDeltaTime + SceneBattle:getBattleLoop():getBattleDeltaTime()
    self.m_nShootDeltaTime = self.m_nShootDeltaTime + 1

    local isCanRepeatShoot = false

    --是否能跳转到射击子弹
    if self.m_nReadyToShootDeltaTime ~= 0 and self.m_nShootDeltaTime >= self.m_nReadyToShootDeltaTime * 30 then
        WZLog("BattleMsgPlayerShoot:_readyShoot 1:", self.m_nShootDeltaTime)
        isCanRepeatShoot = true
    elseif hero:getAnimation():isCurrentAnimationDone() == true or hero:getAnimation():isPlaying(hero:getActionName(23)) then
        WZLog("BattleMsgPlayerShoot:_readyShoot 2:", self.m_nShootDeltaTime)
        isCanRepeatShoot = true
    end

    local nAttackTimes = hero:getAttTimes()
    local nAttScatterNum = hero:getAttScatterNum()
    if self.m_bIsUseSkinBigSkill and (self.m_nSkinBigSkillType == 3024 or self.m_nSkinBigSkillType == 3048 or self.m_nSkinBigSkillType == 3062) then 
        nAttackTimes = hero:getAttScatterNum()
        nAttScatterNum = 1
    end
	if isCanRepeatShoot then
		self.m_nTimeRemain = 0
		hero:setRunStatus(RunStatus.DEF_ST_REPEAT_SHOOT)
        self.m_nAttackedCount = self.m_nAttackedCount and self.m_nAttackedCount + 1 or 1
        self:_createBullet(nAttScatterNum, nil, hero:isUseSkinAttack())
        WZLog("BattleMsgPlayerShoot:_readyShoot 3:", nAttackTimes, self.m_nAttackedCount)

		if nAttackTimes - self.m_nAttackedCount >= 0 then
            WZLog("BattleMsgPlayerShoot:_readyShoot three", hero:getAttTimes())
            WBattleGlobal:getCurrent().m_nAttackedCount = hero:getAttTimes()
            if not self.m_bIsUseSkinBigSkill or (self.m_bIsUseSkinBigSkill and self.m_nSkinBigSkillType ~= 3032 and self.m_nSkinBigSkillType ~= 3033 and self.m_nSkinBigSkillType ~= 3046 and self.m_nSkinBigSkillType ~= 3052 and self.m_nSkinBigSkillType ~= 3056 and self.m_nSkinBigSkillType ~= 3057) then
			    hero:playRepeatShootAnim(1)
            end
		end
		self:_repeatShoot()
		return true
	else
		hero:setRunStatus(RunStatus.DEF_ST_READY_SHOOT)
		return false
	end
end

--@brief	播放重复射击动画
function BattleMsgPlayerShoot:_repeatShoot()
    WZLog("BattleMsgPlayerShoot:_repeatShoot")
	local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
    hero.m_bIsReadyShoot = nil
    local nLeftTimes = 3
    if self.m_bIsUseSkinBigSkill then 
        nLeftTimes = 25
    end
    local nAttackTimes = hero:getAttTimes()
    local nAttScatterNum = hero:getAttScatterNum()
    if self.m_bIsUseSkinBigSkill and (self.m_nSkinBigSkillType == 3024 or self.m_nSkinBigSkillType == 3048 or self.m_nSkinBigSkillType == 3062) then 
        nLeftTimes = 3
        nAttackTimes = hero:getAttScatterNum()
        nAttScatterNum = 1
    end
	if nAttackTimes - self.m_nAttackedCount > 0 then
		if self.m_nTimeRemain > nLeftTimes then
			self.m_nTimeRemain = 0
			hero:setRunStatus(RunStatus.DEF_ST_REPEAT_SHOOT)
			self.m_nAttackedCount = self.m_nAttackedCount and self.m_nAttackedCount + 1 or 1
            self:_createBullet(nAttScatterNum)
			if nAttackTimes - self.m_nAttackedCount >= 0 then
                WZLog("BattleMsgPlayerShoot:_repeatShoot two", nAttackTimes)
				hero:playRepeatShootAnim(1)
			end
		else
			self.m_nTimeRemain = self.m_nTimeRemain + 1
			hero:setRunStatus(RunStatus.DEF_ST_REPEAT_SHOOT)
		end
		return false
	elseif hero:getIsFrozen() or (hero:getAnimation():isCurrentAnimationDone() == true and hero:getAnimation():isPlaying(hero:getActionName(23)) ~= true) or hero:getAnimation():isPlaying(hero:getActionName(23)) == true then
		self.m_nTimeRemain = 0
		-- hero:setRunStatus(RunStatus.DEF_ST_SHOOT)
		hero:playEndShootAnim()
		return true
    elseif hero:getAnimation():isCurrentAnimationDone() ~= true then
        return false
	end
end

--@brief	播放正在射击动画
function BattleMsgPlayerShoot:_shooting()
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
	--self:_followBullet()
	self.m_bCanFallDown = true
	if hero:getAnimation():isCurrentAnimationDone() == true or hero:getAnimation():isPlaying(hero:getActionName(23)) or hero:isInBuffState(EffectTypeConfig.LIMIT_ALL_ACTION) then
        WZLog("BattleMsgPlayerShoot:_shooting two", tostring(hero:getAnimation():isCurrentAnimationDone()), tostring(hero:isInBuffState(EffectTypeConfig.LIMIT_ALL_ACTION)))
		hero:setMoveUpdatable(true)
		if TeachGroup1.ISFIRSTBATTLE and hero:getUseBigSkill() then
            WZLog("BattleMsgPlayerReadyShoot:process XX",hero.m_nRotatePre)
        	hero:getAnimation():setRotate(-8)
            hero.m_nRotatePre = nil
        end
		hero:setRunStatus(RunStatus.DEF_ST_NORMAL)
		hero:getAnimation():play(hero:getActionName(23),true)
		return true
	else
		-- hero:setRunStatus(RunStatus.DEF_ST_SHOOT)
		return false
	end
end

--@brief    触发流血后生效的技能效果 (生效类型:TakeEffectType.AFTER_BLEED=17)
function BattleMsgPlayerShoot:_TriggerAfterBleedSkillEffect()
    local hero = WBattleGlobal:getCurrent():getCurrentCharacter()
    if hero.m_tSkillTakeEffectAfterBleedInfo then
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
            hero.m_tSkillTakeEffectAfterBleedInfo, TakeEffectType.AFTER_BLEED,
            nil,
            nil,
            nil,
            nil,
            self.m_tSkillOwner
            )
    end

    return true
end

--@brief	等待子弹消失和英雄受伤
function BattleMsgPlayerShoot:_waitForBulletAndHurt()
    WZLog("BattleMsgPlayerShoot:_waitForBulletAndHurt", tostring(self:_waitForBullet()), tostring(self:_waitForHurtNum()), tostring(self:_isPetAttack()), tostring(self.m_bIsPetShoot))

    self.m_nWaitDeltaTime = self.m_nWaitDeltaTime + SceneBattle:getBattleLoop():getBattleDeltaTime()

	if self:_waitForBullet() and (self:_waitForHurtNum() or self:_isPetAttack() and self.m_bIsPetShoot ~= true) then
		BattleScreen:resetZoomToHero()
        WZLog("BattleMsgPlayerShoot:_waitForBulletAndHurt two", os.time())
		return true
	else
		return false
	end
end

--@brief	等待子弹消失
function BattleMsgPlayerShoot:_waitForBullet()
    local isHaveBullet = self:_isHaveBullet()
    WZLog("BattleMsgPlayerShoot:_waitForBullet", tostring(isHaveBullet), self.m_nWaitDeltaTime)
	--self:_followBullet()
	if isHaveBullet == false and self.m_nWaitDeltaTime > 0 then
		return true
	else
		return false
	end
end

--@brief	等待伤害数字消失
function BattleMsgPlayerShoot:_waitForHurtNum()
	local isHurt, hurtOne = WBattleGlobal:getCurrent():IsAnyOneHurt()
    WZLog("BattleMsgPlayerShoot:_waitForHurtNum", tostring(hurtOne), tostring(not isHurt))
	return not isHurt
end

--@brief    屏幕初始化
function BattleMsgPlayerShoot:_resetZoomToHero()
    WZLog("BattleMsgPlayerShoot")
    BattleScreen:resetZoomToHero()
    return true
end

--@brief    最小化屏幕
function BattleMsgPlayerShoot:_ZoomOut()
    WZLog("BattleMsgPlayerShoot:_ZoomOut")
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
    local heroPt = hero:getAnimation():getPosition()
    return BattleScreen:zoomOut(heroPt, nil)
end

--@brief	屏幕移向英雄
function BattleMsgPlayerShoot:_zoomToHero()
    if WBattleGlobal:getCurrent():isGameOver() then
        return true
    end
    
    WZLog("BattleMsgPlayerShoot:_zoomToHero one", WBattleGlobal:getCurrent().m_tGameOverHero and WBattleGlobal:getCurrent().m_tGameOverHero:getBattleId())
    WZLog("BattleMsgPlayerShoot:_zoomToHero m_bIsPetShoot",self.m_bIsPetShoot)
    WBattleGlobal:getCurrent().m_bIsZoomToHero = true
    WBattleGlobal:getCurrent():setShowGameOver(true)

    local hero, scale, speed
    if WBattleGlobal:getCurrent().m_bIsGameOverTimer ~= true then
	    hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
        if self.m_bIsUseSkinBigSkill then 
            scale = 0.85
            speed = 1
        end
	else
		hero = WBattleGlobal:getCurrent().m_tGameOverHero
		scale = 1.2
		speed = 1
		WZLog("BattleMsgPlayerShoot:_zoomToHero two")
	end
    
    if self.m_bIsPetShoot ~= nil and self.m_bIsPetShoot == true then 
        WBattleGlobal:getCurrent().m_bIsZoomToHero = false
        return true
    end
    
	if hero ~= nil then
        return BattleScreen:zoomToHero(hero:getBattleId(), hero:getMover():getMoverPosition(), nil, scale, speed)
    else
        return true
    end
end

--@brief	更新子弹状态
function BattleMsgPlayerShoot:_updateBullet()
    -- for i,v in pairs(WBattleGlobal:getCurrent():getCharacterList()) do
    --     WZLog("BattleMsgPlayerShoot:_updateBullet-check",v:getBattleId(),v:getPosition().x,v:getPosition().y)
    -- end
    local bullets = WBattleGlobal:getCurrent():getBulletsList()
    WZLog("BattleMsgPlayerShoot:_updateBullet one", #bullets, g_nCollisionIndex)

    if g_nCollisionIndex == 1 then
        for i=#bullets,1,-1 do
            -- self.m_nIsSkinGroupBullet为触发普攻技能
            if self.m_nIsSkinGroupBullet or bullets[i].m_bIsCloseShoot and bullets[i]:getAnimation():isCurrentAnimationDone() == true then 
                g_nCollisionIndex = 2
                break 
            elseif (self.m_nSkinBigSkillType == 3023 or self.m_nSkinBigSkillType == 3029) and self.m_bIsUseSkinBigSkill and bullets[i]:getAnimation():isCurrentAnimationDone() == true then 
                g_nCollisionIndex = 2
                break 
            end
        end
    end
    -- if self.m_bIsUseSkinBigSkill and self.m_nSkinBigSkillType == 3054 and g_nCollisionIndex == 2 then 
    --     if bullets[1] and bullets[1].m_bIsSpatter then 
    --         bullets[i]:stop()
    --         return
    --     end
    -- end
    if self.m_bIsUseSkinBigSkill and self.m_nSkinBigSkillType == 3054 and g_nCollisionIndex == 1 then 
        self:dealWithBigSkinSkill(self.m_nSkinBigSkillType, bullets[1])
    elseif self.m_bIsUseSkinBigSkill and self.m_nSkinBigSkillType == 3061 and g_nCollisionIndex == 1 then 
        self:dealWithBigSkinSkill(self.m_nSkinBigSkillType, bullets[1])
    end
    if g_nCollisionIndex == 1 then return end 

    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
    for i=#bullets,1,-1 do
        if not hero:getIsSubHero() or hero:getIsSubHero() and bullets[i].m_ownerChara:getBattleId() == self.m_nCurrentPlayerId then --如果是分身的子弹，需要是对应的玩家的Id对象调用才生效
            if bullets[i]:getStatus() == BulletStatus.DEF_ST_FLY then
                WZLog("BattleMsgPlayerShoot:_updateBullet pos",i,bullets[i]:getMover():getMoverPosition().x,bullets[i]:getMover():getMoverPosition().y)
                WZLog("BattleMsgPlayerShoot:_updateBullet posII",bullets[i]:getMover():getMoverPrePosition().x,bullets[i]:getMover():getMoverPrePosition().y)
                bullets[i]:updatePosition()
                --碰撞检测
                local isCollision = false
                local penetrateMonster = nil
               
                --WZLog("NO_HOLE_ 1", bullets[i], bullets[i].m_tBullet)
                isCollision, _ = bullets[i]:checkCollision()

                
                if self.m_bIsUseSkinBigSkill then
                    if (self.m_nSkinBigSkillType == 3030 or self.m_nSkinBigSkillType == 3046) and bullets[i].m_bIsSpatter ~= true then --(宇航员,鬼新娘)大招到达目标点附近就爆炸
                        if bullets[i]:getPosition().y <= self.m_nEndY then
                            WZLog("大招爆炸")
                            isCollision = true
                            bullets[i].m_bIsSpatterPenetrateMap = false
                            bullets[i].m_bIsPenetrateMap = false
                            bullets[i]:addCollisionCharas(WBattleGlobal:getCurrent():getHeroSortList())
                            bullets[i]:addCollisionCharas(WBattleGlobal:getCurrent():getGuaiSortList())
                            bullets[i]:addCollisionCharas(WBattleGlobal:getCurrent():getMachinesSortList())
                            bullets[i]:addCollisionCharas(WBattleGlobal:getCurrent():getKidSortList())
                        end
                    elseif self.m_nSkinBigSkillType == 3033 or self.m_nSkinBigSkillType == 3035 or self.m_nSkinBigSkillType == 3036 or self.m_nSkinBigSkillType == 3044 or self.m_nSkinBigSkillType == 3051 or self.m_nSkinBigSkillType == 3052 or self.m_nSkinBigSkillType == 3053 or self.m_nSkinBigSkillType == 3056 or self.m_nSkinBigSkillType == 3057 or self.m_nSkinBigSkillType == 3063 or self.m_nSkinBigSkillType == 3064 or self.m_nSkinBigSkillType == 3065 then
                        isCollision = true
                    end
                end

                --穿透弹处理begin
                if isCollision and hero:getCanPenetrate() then
                    isCollision = false
                    -- local charas, values, distance, critType, hurtRatios = bullets[i]:checkHurt(true)
                    local _,collisonChara = bullets[i]:checkCharacterCollision()
                    for j,chara in pairs(collisonChara) do
                        local isExit = true
                        for k,tv in pairs(self.m_tPenetrateList) do
                            if tv:getBattleId() == chara:getBattleId() then
                                isExit = false
                            end
                        end

                        if isExit then
                            WZLog("BattleMsgPlayerShoot:_updateBullet collisonChara")
                            local index = chara:getBattleId()
                            local hurt,hurtType, distance,recordRatio = WBullet:calculateHurt(0,bullets[i]:getOwnerChara(),chara,nil)
                            self:_charaAddHurtValue({index=chara},{index=hurt},{index=recordRatio})
                            local effectBoom  = BattleEffect:createAnimation(310)
                            effectBoom:setPosition(bullets[i]:getMover():getMoverPosition())
                            SceneBattle:getFrontLayer():addChild(effectBoom:getAnimNode(),100)
                            
                            self.m_tPenetrateList[index] = chara
                            self.m_tPenetrateValList[index] = hurt
                            self.m_tPenetrateDisList[index] = 0
                            self.m_tPenetrateCritList[index] = hurtType

                            self:_checkHitEnemy({index=chara}, bullets[i], {index=hurt})
                        end
                    end
                end
                --穿透弹处理end  
                if isCollision == true and g_nCollisionIndex == 0 and self.m_bIsUseSkinBigSkill then 
                    g_nCollisionIndex = 1
                    bullets[i]:stop()
                    self:_showSkinSlipAttackAni(bullets[i])
                    if g_nCollisionIndex == 1 then 
                        return 
                    end
                end
                if isCollision == true and g_nCollisionIndex == 0 and bullets[i].m_bIsCloseShoot then 
                    g_nCollisionIndex = 1 
                    bullets[i]:stop()
                    return 
                end
                if g_nCollisionIndex == 2 and isCollision == false then 
                    if self.m_nSkinBigSkillType == 3001 or self.m_nSkinBigSkillType == 3014 or self.m_nSkinBigSkillType == 3015 or self.m_nSkinBigSkillType == 3023 or self.m_nSkinBigSkillType == 3029 or self.m_nSkinBigSkillType == 3034 or self.m_nSkinBigSkillType == 3035 or self.m_nSkinBigSkillType == 3038 or self.m_nSkinBigSkillType == 3043 or self.m_nSkinBigSkillType == 3049 or bullets[i].m_bIsCloseShoot or self.m_nSkinBigSkillType == 3054 or self.m_nSkinBigSkillType == 3068 or self.m_nSkinBigSkillType == 3069 then 
                        isCollision = true 
                        WZLog("出错啦。。。。。。")
                    end
                end

                if isCollision == true and penetrateMonster ~= nil then
                    for i, v in pairs (penetrateMonster) do
                        v:markHurt(1,hero,nil,nil,nil,0)
                    end
                elseif isCollision == true then
                    -- 击中敌人到产生伤害之间产生效果
                    local tHitTargets = bullets[i]:getHitTargets()
                    if tHitTargets ~= nil and #tHitTargets > 0 and hero.m_tSkillTakeEffectInfo ~= nil then
                        local isSkillEffectTaked = false
                        if #tHitTargets <= #hero.m_tSkillTakeEffectList then
                            isSkillEffectTaked = true
                        end
                        if isSkillEffectTaked == false then
                            self:_canelBuff(tHitTargets)
                        end
                    end

                    WZLog("checkHurtcheckHurtcheckHurtcheckHurt")
                    local charas, values, distance, critType, hurtRatios, superCritMark = bullets[i]:checkHurt(true)
                    WZLog("checkHurtcheckHurtcheckHurtcheckHurt000")
                    --WZLog("BattleMsgPlayerShoot:_updateBullet two-2 charas", Serialize(charas), "values", Serialize(values), Serialize(distance),Serialize(critType), Serialize(hurtRatios))

                    local myHero = WBattleGlobal:getCurrent():getMyHero()

                    --处理地图事件
                    if bullets[i].m_bIsProcessMapEventBubble == true then

                        self.m_nBubbleAtkSpeedX = bullets[i].m_nBubbleAtkSpeedX
                        self.m_nBubbleAtkSpeedY = bullets[i].m_nBubbleAtkSpeedY

                        if bullets[i].m_nBubbleAtkSpeedX >= 0 then
                            self.m_nBubbleAtkStartX = bullets[i]:getPosition().x + 50
                        else
                            self.m_nBubbleAtkStartX = bullets[i]:getPosition().x - 50
                        end
                        self.m_nBubbleAtkStartY = bullets[i]:getPosition().y + 50
                        self:_createBullet(1,true)

                        bullets[i].m_bIsProcessMapEventBubble = nil
                    end

                    self:_checkHitEnemy(charas, bullets[i], values)
                    WZLog("BattleMsgPlayerShoot:_attackCheck",tostring(hero.m_tActiveAttackPos and #hero.m_tActiveAttackPos or 0))
                    WZLog("BattleMsgPlayerShoot:_attackCheck",tostring(hero.m_tSkillTakeEffectCollionInfo),tostring(hero.m_tSkillTakeEffectInfo))
                    if hero.m_tActiveAttackPos ~= nil and #hero.m_tActiveAttackPos > 0 and hero.m_tSkillTakeEffectCollionInfo ~= nil then
                        local isSkillEffectTaked = false

                        if self.m_bIsUseSkinBigSkill and self.m_nSkinBigSkillType == 3054 and not bullets[i]:getIsSpatter() then --如果是3054皮肤大招的穿透子弹，不发送爆破伤害，通过穿透伤害发送
                            bullets[i]:markExplode(false)
                        else
                            WZLog("BattleMsgPlayerShoot:_updateBullet two-3.7")
                            local charas, values, distance, critType,hurtRatios, superCritMark= bullets[i]:checkHurt(nil, true)
                            self:_charaAddHurtValue(charas,values,hurtRatios, superCritMark)
                        --    self:_saveSoulHeroHurtData(charas, values, distance, critType, superCritMark)
                            self:_sendHurtProtocol(charas,values,distance,critType, superCritMark)
                            bullets[i]:markExplode(false)
                            --检测职业反伤
                            BattleMethod:checkProfessionThorns(hero, charas, values, hero:getBattleId())
                            --检测反伤盾反伤
        --                    BattleMethod:checkReflectThorns(hero, charas, values, hero:getBattleId())
                        end
                        if isSkillEffectTaked == false then
                            --bullets[i]:markExplode(true)
                            self.m_nSkillStatusCount = self.m_nSkillStatusCount + 1

                            if hero.m_nIsSpatter == true then
                                self.m_nBuildBulletsSkillStatusCount = self.m_nBuildBulletsSkillStatusCount + 1
                                WZLog("BattleMsgPlayerShoot:_updateBullet two-3.71")
                            end
                            if hero:getUseSkinBigSkill() and hero:getSkinBigSkill() == 3011 then 
                                hero:setFollowBulletSpeed(bullets[i].m_tStartSpeed)
                            end

                            local info = hero.m_tSkillTakeEffectCollionInfo
                            hero.m_tSkillTakeEffectCollionInfo = nil
                            WBattleGlobal:getCurrent():setDoEffectAfterAttack(true,"shoot-1")
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
                                info, TakeEffectType.COLLISION,
                                nil,
                                nil,
                                nil,
                                nil,
                                self.m_tSkillOwner
                                )
                        end
                    elseif hero.m_tHitTargets ~= nil and #hero.m_tHitTargets > 0 and hero.m_tSkillTakeEffectInfo ~= nil then
                        local isSkillEffectTaked = false
                        WZLog("BattleMsgPlayerShoot:_updateBullet two-3", #hero.m_tHitTargets, #hero.m_tSkillTakeEffectList)
                        for id, tempChara in pairs(hero.m_tHitTargets) do
                        end

                        if #hero.m_tHitTargets <= #hero.m_tSkillTakeEffectList then
                            isSkillEffectTaked = true
                        end

                        local charas, values, distance, critType, hurtRatios, superCritMark = bullets[i]:checkHurt(nil, true)
                        self:_charaAddHurtValue(charas,values,hurtRatios, superCritMark)
                   
                        WZLog("BattleMsgPlayerShoot:_updateBullet two-3.8")
                    --    self:_saveSoulHeroHurtData(charas, values, distance, critType, superCritMark)
                        self:_sendHurtProtocol(charas,values,distance,critType, superCritMark)
                        bullets[i]:markExplode(false)
                        --检测职业反伤
                        BattleMethod:checkProfessionThorns(hero, charas, values, hero:getBattleId())
                        --检测反伤盾反伤
                    --    BattleMethod:checkReflectThorns(hero, charas, values, hero:getBattleId())
                        if isSkillEffectTaked == false then
                            --bullets[i]:markExplode(true)
                            self.m_nSkillStatusCount = self.m_nSkillStatusCount + 1

                            WBattleGlobal:getCurrent():setDoEffectAfterAttack(true,"shoot-2")
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
                                hero.m_tSkillTakeEffectInfo, TakeEffectType.HIT,
                                nil,
                                nil,
                                nil,
                                nil,
                                self.m_tSkillOwner,
                                nil,
                                nil,
                                bullets[i].m_nBulletIndex
                                )

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
                                hero.m_tSkillTakeEffectInfo, TakeEffectType.HIT_ENEMY,
                                nil,
                                nil,
                                nil,
                                nil,
                                self.m_tSkillOwner,
                                nil,
                                nil,
                                bullets[i].m_nBulletIndex
                                )
    	                end
                        --子弹击中生效的，不受isSkillEffectTaked这个条件限制
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
                            hero.m_tSkillTakeEffectInfo, TakeEffectType.BULLET_HIT,
                            nil,
                            nil,
                            nil,
                            nil,
                            self.m_tSkillOwner,
                            nil,
                            nil,
                            bullets[i].m_nBulletIndex
                            )
    	            else
    	            	local charas,values,tDistance, tCritType,tHurtRatio, superCritMark= bullets[i]:checkHurt(nil, true)
                    	self:_charaAddHurtValue(charas,values,tHurtRatio, superCritMark)
                    	WZLog("BattleMsgPlayerShoot:_updateBullet two-3.9")
    					self:_sendHurtProtocol(charas,values,tDistance,tCritType, superCritMark)
    					bullets[i]:markExplode(false)
                        --检测职业反伤
                        BattleMethod:checkProfessionThorns(hero, charas, values, hero:getBattleId())
                        --检测反伤盾反伤
                    --    BattleMethod:checkReflectThorns(hero, charas, values, hero:getBattleId())
                    end

                    WZLog("NO_HOLE_ 3", bullets[i], bullets[i].m_tBullet)
                    bullets[i]:explode()
                    WBattleGlobal:getCurrent():enableAllHeroFallDown()
                    if not self.m_bCanFallDown then
                        hero:setMoveUpdatable(false)
                    end
                    --屏幕震动
                    self.m_nSpringCount = self.m_nSpringCount + 1
                    if self.m_nSpringCount < 7 then
                        WZLog("BattleMsgPlayerShoot:_updateBullet two-4.1", self.m_nSpringCount)
                        if self.m_bIsUseSkinBigSkill then --皮肤大招触发伤害的一刻才震屏
                        else
                            math.randomseed(tostring(os.time()):reverse():sub(1, 6))
                            self:_setSceneSpring(BattleCommon:getPointTable(bullets[i]:getMover():getMoverPosition().x + math.random(-100,100), bullets[i]:getMover():getMoverPosition().y + 0))
                        end
                    end
                end
            end
        end
        --移除子弹
        local bCanDo = not hero:getIsSubHero() or hero:getIsSubHero() and bullets[i].m_ownerChara:getBattleId() == self.m_nCurrentPlayerId --如果是分身的子弹，需要是对应的玩家的Id对象调用才生效
        if self:_canRemoveBullet(bullets[i], i) and bCanDo then
            WZLog("BattleMsgPlayerShoot:_updateBullet two-4.4", BattleCommon:tableLen(self.m_tPenetrateList))
            if hero:getCanPenetrate() and BattleCommon:tableLen(self.m_tPenetrateList) > 0 then
            --    WZLog("BattleMsgPlayerShoot:_updateBullet two-4.4.0")
                self:_sendHurtProtocolMul(tPenetrateList, tPenetrateValList, tPenetrateDisList, tPenetrateCritList)
                self.m_tUpPenetrateList = nil 
                self.m_tUpPenetrateValList = nil 
                self.m_tUpPenetrateDisList = nil 
                self.m_tUpPenetrateCritList = nil 
                self.m_tDownPenetrateList = nil 
                self.m_tDownPenetrateValList = nil 
                self.m_tDownPenetrateDisList = nil 
                self.m_tDownPenetrateCritList = nil 
            end
            WZLog("BattleMsgPlayerShoot:_updateBullet two-4.5", BattleCommon:tableLen(self.m_tUpPenetrateList), BattleCommon:tableLen(self.m_tDownPenetrateList))
            if BattleCommon:tableLen(self.m_tUpPenetrateList) > 0 or BattleCommon:tableLen(self.m_tDownPenetrateList) > 0 then 
                local tPenetrateList = {}
                local tPenetrateValList = {}
                local tPenetrateDisList = {}
                local tPenetrateCritList = {}
                if BattleCommon:tableLen(self.m_tUpPenetrateList) > 0 then 
                    for index, value in pairs(self.m_tUpPenetrateList) do
                        table.insert(tPenetrateList, value)
                        table.insert(tPenetrateValList, self.m_tUpPenetrateValList[index])
                        table.insert(tPenetrateDisList, self.m_tUpPenetrateDisList[index])
                        table.insert(tPenetrateCritList, self.m_tUpPenetrateCritList[index])
                    end
                end
                if BattleCommon:tableLen(self.m_tDownPenetrateList) > 0 then 
                    for index, value in pairs(self.m_tDownPenetrateList) do
                        table.insert(tPenetrateList, value)
                        table.insert(tPenetrateValList, self.m_tDownPenetrateValList[index])
                        table.insert(tPenetrateDisList, self.m_tDownPenetrateDisList[index])
                        table.insert(tPenetrateCritList, self.m_tDownPenetrateCritList[index])
                    end
                end
                WZLog("BattleMsgPlayerShoot:_updateBullet two-4.4.0")
                self:_sendHurtProtocolMul(tPenetrateList, tPenetrateValList, tPenetrateDisList, tPenetrateCritList)
                self.m_tUpPenetrateList = nil 
                self.m_tUpPenetrateValList = nil 
                self.m_tUpPenetrateDisList = nil 
                self.m_tUpPenetrateCritList = nil 
                self.m_tDownPenetrateList = nil 
                self.m_tDownPenetrateValList = nil 
                self.m_tDownPenetrateDisList = nil 
                self.m_tDownPenetrateCritList = nil 
            end
            WZLog("BattleMsgPlayerShoot:_updateBullet two-4.3", bullets[i].m_bIsMark)
            if bullets[i].m_bIsMark ~= true then
                bullets[i]:destroy()
            end
            WBattleGlobal:getCurrent():removeBulletByIndex(i)
            WZLog("BattleMsgPlayerShoot:_updateBullet two-4.2")
        end
    end
end

--------------------生效类型15Start--------------------
--@brief    获取技能表配置
function BattleMsgPlayerShoot:_getSkillData(id)
    return CopyTable(GDatatab_skill["id_"..id])
end

--@brief    获取技能效果表配置 
function BattleMsgPlayerShoot:_getEffectData(id)
    local chara = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
    if chara:getType() == 0 then
        return CopyTable(GDatatab_effect["id_"..id])
    else
        return CopyTable(EffectConfig["id_"..id])
    end
end

--@brief    击中敌人到产生伤害之间产生效果
function BattleMsgPlayerShoot:_canelBuff(tHitTargets)
    local chara = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
    local skillInfo = self:_getSkillData(chara.m_tSkillTakeEffectInfo)
    local config = self:_getEffectData(skillInfo.effect_id[1][1])
    local effect = config.effect

    for i, effectParm in pairs (effect) do
        local takeEffectParm = effectParm[1]
        local targetParm = effectParm[2]
        local sEffect = effectParm[3] .. "_" ..effectParm[4]
        if takeEffectParm == TakeEffectType.BETWEEN_ATTACK_HURT then
            -- 选择目标
            local targetHeroList = {}
            for _, hero in pairs (tHitTargets) do
                if targetParm == EffectTargetType.ENEMY then
                    if hero:getHp() > 0 and not hero:isDead() and not WBattleGlobal:getCurrent():isSameTeam(chara:getBattleId(),hero:getBattleId()) then
                        table.insert(targetHeroList, hero)
                    end
                end
            end

            --移除buff
            local nCancelBuffId = nil
            local nCancelBuffType = nil
            local nCancelBuffAssign = nil
            if sEffect == EffectTypeConfig.CANCEL_BUFF_ID then
                nCancelBuffId = effectParm[5]
            elseif sEffect == EffectTypeConfig.CANCEL_BUFF_TYPE then
                nCancelBuffType = effectParm[5]
            elseif sEffect == EffectTypeConfig.CANCEL_BUFF_ASSIGN then
                nCancelBuffAssign = effectParm[5]
            end
            for id, hero in pairs (targetHeroList) do
                if hero:getHp() > 0 and not hero:isDead() then
                    for index, buff in pairs (hero.m_tBuffChangeStateList) do 
                        local isClear = false
                        if nCancelBuffId and nCancelBuffId == buff.m_nID then
                            isClear = true
                        end
                        if nCancelBuffType and nCancelBuffType == buff.m_nEffectType and buff.m_nCanRemove == 0 then --9_2需要判断buff表disperse字段
                            isClear = true
                        end
                        if nCancelBuffAssign and nCancelBuffAssign == buff.m_nType then
                            isClear = true
                        end
                        if not nCancelBuffId and not nCancelBuffType and not nCancelBuffAssign and buff.m_nCanRemove == 0 then --9_1需要判断buff表disperse字段
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
    end
end
--------------------生效类型15End--------------------

--@brief	对英雄添加受伤数字(除零)
--@param	charas:英雄列表
--@param	hurtValue:受伤数字
--@return	#1:需要发送协议的英雄列表
--@return	#2:需要发送协议的伤害列表
function BattleMsgPlayerShoot:_charaAddHurtValue(charas,hurtValue,hurtRatios, superCritMark)

	local newCharas = {}
	local newValue = {}
	local shootHero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
    local nTimeInterval = 0.33
    if shootHero.m_nBoyOrGirl == 1 then
        nTimeInterval = 0.25
    end 
    local lastHurtTimes = 5     --最后一个伤害的计算系数
	for id,chara in pairs(charas) do
        WZLog("BattleMsgPlayerShoot:_charaAddHurtValue", tostring(id), tostring(chara.m_animPlayerShield), tostring(hurtValue[id]),tostring(hurtRatios[id]), superCritMark and tostring(superCritMark[id]) or "nil")
        local skinBigSkillSectionHurtIndex = 0 
        local nWaitTimes = 0
        local nSectionNum = 4
        if shootHero ~= nil and shootHero:getUseSkinBigSkill() and (shootHero:getSkinBigSkill() == 3009 or shootHero:getSkinBigSkill() == 3010 or shootHero:getSkinBigSkill() == 3012 or shootHero:getSkinBigSkill() == 3013 or shootHero:getSkinBigSkill() == 3020 or shootHero:getSkinBigSkill() == 3021) then
            skinBigSkillSectionHurtIndex = 1
            if shootHero:getSkinBigSkill() == 3012 or shootHero:getSkinBigSkill() == 3013 then 
                lastHurtTimes = 4
            end
            --播放伤害额外等待时间
            if shootHero:getSkinBigSkill() == 3020 then 
                nWaitTimes = 0.8
                lastHurtTimes = 2.5
            elseif shootHero:getSkinBigSkill() == 3021 then 
                nSectionNum = 3
                lastHurtTimes = 2.8
            -- elseif shootHero:getSkinBigSkill() == 3022 then 
            --     nSectionNum = 2
            --     lastHurtTimes = 3
            end
        elseif shootHero ~= nil and shootHero:getUseSkinBigSkill() and (shootHero:getSkinBigSkill() == 3011 or shootHero:getSkinBigSkill() == 3025 or shootHero:getSkinBigSkill() == 3063 or shootHero:getSkinBigSkill() == 3064) then 
            skinBigSkillSectionHurtIndex = 2
            if shootHero:getSkinBigSkill() == 3011 then 
                nWaitTimes = 0.5
            elseif shootHero:getSkinBigSkill() == 3025 then 
                nWaitTimes = 1
            elseif shootHero:getSkinBigSkill() == 3063 then 
                nWaitTimes = 1.2
            end
        elseif shootHero ~= nil and shootHero:getUseSkinBigSkill() and shootHero:getSkinBigSkill() == 3022 then 
            skinBigSkillSectionHurtIndex = 3
            lastHurtTimes = 3
        end
        local nTempSuperCritMark = superCritMark and superCritMark[id] and superCritMark[id] or 0
        if skinBigSkillSectionHurtIndex == 1 then 
            local nTempTotal = 0
            for i = 1, nSectionNum - 1 do
                local nTempHurt = 0
                if hurtValue[id] > 0 then 
                    nTempHurt = math.floor(hurtValue[id] * 0.2)
                else
                    nTempHurt = math.ceil(hurtValue[id] * 0.2)
                end

                nTempTotal = nTempTotal + nTempHurt 

                DelayCallFunction(self._createHurtWords, self, nWaitTimes + nTimeInterval * (i - 1), nTempHurt, chara, shootHero, hurtRatios[id], i == 1 and hurtValue[id] or nil, nTempSuperCritMark)
            end
            DelayCallFunction(self._createHurtWords, self, nWaitTimes + nTimeInterval * lastHurtTimes, hurtValue[id] - nTempTotal, chara, shootHero, hurtRatios[id], nil, nTempSuperCritMark)
        elseif skinBigSkillSectionHurtIndex == 2 then 
            DelayCallFunction(self._createHurtWords, self, nWaitTimes, hurtValue[id], chara, shootHero, hurtRatios[id], nil, nTempSuperCritMark)
        elseif skinBigSkillSectionHurtIndex == 3 then 
            local bAddRoundHurt = false --标记已经加个回合伤害值了，在markHurt中就不要重复加了

            if shootHero ~= nil and shootHero:getUseSkinBigSkill() and shootHero:getSkinBigSkill() == 3022 then 
                if hurtValue[id] ~= -1 and WBattleGlobal:getCurrent():isSameTeam(shootHero:getBattleId(),chara:getBattleId()) then
                    chara:addRoundHurt(hurtValue[id])
                end
            end
            DelayCallFunction(self._createHurtWords, self, nTimeInterval * lastHurtTimes, hurtValue[id], chara, shootHero, hurtRatios[id], hurtValue[id], nTempSuperCritMark, bAddRoundHurt)
        else
            self:_createHurtWords(hurtValue[id], chara, shootHero, hurtRatios[id], nil, nTempSuperCritMark)
        end
		if hurtValue[id] ~= -1 and hurtValue[id] ~= 0 then
			newCharas[id] = chara
			newValue[id] = hurtValue[id]
		end
	end

    WZLog("BattleMsgPlayerShoot:_charaAddHurtValue", Serialize(newValue))
	return newCharas,newValue
end

--@brief 动态标记受伤
function BattleMsgPlayerShoot:_createHurtWords(hurtValue, chara, shootHero, hurtRatios, totalHurt, superCritMark, bAddRoundHurt)
    -- body
    chara:markHurt(hurtValue, shootHero,nil,nil,nil,hurtRatios, nil, totalHurt, superCritMark, nil, nil, bAddRoundHurt)
    --皮肤大招触发伤害的一刻才震屏
    if self.m_bIsUseSkinBigSkill then
        math.randomseed(tostring(os.time()):reverse():sub(1, 6))
        self:_setSceneSpring(BattleCommon:getPointTable(chara:getPosition().x + math.random(-100,100), chara:getPosition().y + 0))
    end

    if hurtValue ~= nil and hurtValue > 0 then 
        --添加心魔伤害转移
        if chara:isInBuffState(EffectTypeConfig.HURT_TRANS) and chara:isDevilGuai() and shootHero:getBattleId() ~= chara:getDevilOwnId() then
            local devilOwnHero = WBattleGlobal:getCurrent():getCharacterWithId(chara:getDevilOwnId())
            if not devilOwnHero:isDead() then 
                devilOwnHero:markHurt(hurtValue,shootHero,nil,nil,nil,hurtRatios, true)
            end
        end
    end
end

--@brief    检查是否打中对方
function BattleMsgPlayerShoot:_checkHitEnemy(charas, bullet, values)
    WZLog("BattleMsgPlayerShoot:_checkHitEnemy")
    if charas ~= nil then
        for id,chara in pairs(charas) do
            local value = chara:hurtEffectHandle(values[id], nil, WBattleGlobal:getCurrent():getCurrentCharacter())
            local bOffHurt = chara.m_bOffHurt or chara:isInBuffState(EffectTypeConfig.IMMUNITY_ATTACK)
            if chara:getBattleId() == self.m_nCurrentPlayerId or value == 0 or bOffHurt then
                WZLog("BattleMsgPlayerShoot:_checkHitEnemy no hit")
                if bullet.m_bIsFrozen ~= nil and bullet.m_bIsHurtPlayer == true then
                    --self.m_tFrozenEnemy = self.m_tFrozenEnemy or chara
                end
            elseif (WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_NORMAL and
             WBattleGlobal:getCurrent().m_tMakePairOk.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_LD) and
              value > 0 then
                self.m_tFirstHitEnemy = self.m_tFirstHitEnemy or chara
                if chara.getBoss == nil then
                    self.m_tPetAttackEnemy = self.m_tPetAttackEnemy or chara
                end
                WZLog("BattleMsgPlayerShoot:_checkHitEnemy hit1", value, chara:getBattleId(), WBattleGlobal:getCurrent():getCurrentCharacter():getBattleId())
            elseif chara:getCamp() ~= WBattleGlobal:getCurrent():getCurrentCharacter():getCamp() and value > 0 then
                WZLog("BattleMsgPlayerShoot:_checkHitEnemy hit2", value, chara:getHp(), chara:getBattleId(), WBattleGlobal:getCurrent():getCurrentCharacter():getBattleId())
                --WZLuaLog:BattleMsgPlayerShoot:_checkHitEnemy hit2 6351    13416   1979295 1979294 
                self.m_tFirstHitEnemy = self.m_tFirstHitEnemy or chara
                if value < (chara:getHp() + chara:getExtraHp()) and chara.getBoss == nil then
                    self.m_tPetAttackEnemy = self.m_tPetAttackEnemy or chara
                    WZLog("BattleMsgPlayerShoot:_checkHitEnemy hit3")
                elseif self.m_tPetAttackEnemy == chara then
                    self.m_tNoPetAttack = true
                    WZLog("BattleMsgPlayerShoot:_checkHitEnemy hit4")
                end
            end
        end
    end
end


--@brief	是否可以移除子弹
--@param	tBullet:检测的子弹
--@return	#1:true,false
function BattleMsgPlayerShoot:_canRemoveBullet(tBullet, index)
    --WZLog("BattleMsgPlayerShoot:_canRemoveBullet zero", index)
	--飞出屏外
	if tBullet:checkOutOfScene() then
        WZLog("BattleMsgPlayerShoot:_canRemoveBullet one", index)
		return true
	end
	--爆炸动画播放完毕
	if tBullet:explodeIsEnd() then
        WZLog("BattleMsgPlayerShoot:_canRemoveBullet two", index)
		return true
	end
	--再次确认是否爆炸完毕
	if tBullet:getStatus() == BulletStatus.DEF_ST_END_EXPLODE then
        WZLog("BattleMsgPlayerShoot:_canRemoveBullet three", index)
		return true
	end

	if tBullet.m_bIsMark == true and tBullet:getStatus() == BulletStatus.DEF_ST_EXPLODE then
        WZLog("BattleMsgPlayerShoot:_canRemoveBullet four", index)
		return true
	end
	return false
end

--@brief	更新屏幕(主要是屏幕震动)
function BattleMsgPlayerShoot:_updateScene()
    WZLog("BattleMsgPlayerShoot:_updateScene 1")
	if self.m_tScreenSpring ~= nil then
        WZLog("BattleMsgPlayerShoot:_updateScene 2",self.m_tScreenSpring.x, self.m_tScreenSpring.y)
		BattleScreen:setSpring(self.m_tScreenSpring)
		if BattleScreen:screenSpring() == true then
            WZLog("BattleMsgPlayerShoot:_updateScene 3")
			self.m_tScreenSpring = nil
		end
	end
end

--@brief	设置屏幕震动
--@param	tPos:震动时的位置
function BattleMsgPlayerShoot:_setSceneSpring(tPos)
    WZLog("BattleMsgPlayerShoot:_setSceneSpring",tPos.x,tPos.y)
	self.m_tScreenSpring = {x=tPos.x,y=tPos.y}
end

--@brief	判断是否屏幕震动
--@return	＃1:true/false
function BattleMsgPlayerShoot:_getIsSceneSpring()
    WZLog("BattleMsgPlayerShoot:_getIsSceneSpring")
	return self.m_tScreenSpring ~= nil
end

--@brief	纪录发送受伤协议的参数
function BattleMsgPlayerShoot:_addHurtHeroAndValue(charas,values)
    WZLog("BattleMsgPlayerShoot:_addHurtHeroAndValue")
	if self.m_tHurtChara == nil then
		self.m_tHurtChara = {}
	end
	if self.m_tHurtValues == nil then
		self.m_tHurtValues = {}
	end
	for id,chara in pairs(charas) do
		if self.m_tHurtChara[id] == nil then
			self.m_tHurtChara[id] = chara
		end
		if self.m_tHurtValues[id] == nil then
			self.m_tHurtValues[id] = values[id]
		else
			self.m_tHurtValues[id] = self.m_tHurtValues[id] + values[id]
		end
	end
end

--@brief    发送受伤协议
--@param    charas:英雄列表
--@param    values:伤害列表
--@param    distance:距离列表
--@param    superCritMark:超暴击状态
function BattleMsgPlayerShoot:_sendHurtProtocol(charas,values,distance,critType, superCritMark)
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
    WZLog("BattleMsgPlayerShoot:_sendHurtProtocol one", tostring(charas), tostring(self.m_nCurrentPlayerId), tostring(hero:isCanControl()), tostring(hero.m_bLoseNet))
    if charas == nil or not (hero:isCanControl() or hero.m_bLoseNet) then
        return
    end

    WZLog("BattleMsgPlayerShoot:_sendHurtProtocol two",tostring(charas),tostring(values),tostring(distance),tostring(critType))
    WBattleGlobal:getCurrent():sendHurtProtocol(self.m_nCurrentPlayerId,charas,values,distance,critType, nil, nil, superCritMark)

    local tempCharas = {}
    local tempValues = {}
    local tempDistance = distance ~= nil and {} or nil 
    local tempCritType = critType ~= nil and {} or nil 

    for id, chara in pairs(charas) do
        if values[id] ~= nil and values[id] > 0 then 
            --添加心魔伤害转移
            if chara:isInBuffState(EffectTypeConfig.HURT_TRANS) and chara:isDevilGuai() and hero:getBattleId() ~= chara:getDevilOwnId() then
                local devilOwnHero = WBattleGlobal:getCurrent():getCharacterWithId(chara:getDevilOwnId())
                if not devilOwnHero:isDead() then 
                    tempCharas[id] = devilOwnHero
                    tempValues[id] = values[id]
                    if distance and distance[id] then 
                        tempDistance[id] = distance[id]
                    end
                    if critType and critType[id] then 
                        tempCritType[id] = critType[id]
                    end
                end
            end
        end
    end

    if #tempCharas > 0 then 
        WBattleGlobal:getCurrent():sendHurtProtocol(self.m_nCurrentPlayerId,tempCharas,tempValues,tempDistance,tempCritType)
    end
end

--@brief	屏幕跟踪子弹
function BattleMsgPlayerShoot:_followBullet()
	local bullet = WBattleGlobal:getCurrent():getBulletByIndex(1)
    WZLog("BattleMsgPlayerShoot:_followBullet",tostring(bullet))
	if bullet ~= nil then
		if self._followBullet_time_ == nil then
			self._followBullet_time_ = 0
		else
			self._followBullet_time_ = self._followBullet_time_ + SceneBattle:getBattleLoop():getBattleDeltaTime()
		end
		-- --if self:_getIsSceneSpring() == false then
  --       local tempPos = bullet:getMover():getMoverPosition()
		-- BattleScreen:followBullet(tempPos,self._followBullet_time_)
		-- --end

        if self.m_bIsUseSkinBigSkill and self.m_nSkinBigSkillType == 3028 then
            if self.m_nBulletAniReplica and self.m_nBulletAniReplica:getAnimNode() and self.m_nBulletAniReplica:getAnimNode():getParent() then
                BattleScreen:followBullet(self.m_nBulletAniReplica:getPosition())
            else
                local tempPos = bullet:getMover():getMoverPosition()
                BattleScreen:followBullet(tempPos,self._followBullet_time_)
            end
        elseif self.m_bIsUseSkinBigSkill and self.m_nSkinBigSkillType == 3048 then --镜头不跟随子弹

        else
            local tempPos = bullet:getMover():getMoverPosition()
            BattleScreen:followBullet(tempPos,self._followBullet_time_)
        end
	elseif self.m_tFirstHitEnemy ~= nil and self.m_tFirstHitEnemy:getIsHero() and self.m_tFirstHitEnemy:getIsRepulse() then
        if not (self.m_bIsUseSkinBigSkill and self.m_nSkinBigSkillType == 3013 and self.m_nSkinBigSkillType == 3028) then 
		    BattleScreen:followBullet(self.m_tFirstHitEnemy:getMover():getMoverPosition(),2)
        end
	end
end

--@brief	是否还有子弹
--@return	#1：true：是，false：否
function BattleMsgPlayerShoot:_isHaveBullet()
	local bullet = WBattleGlobal:getCurrent():getBulletByIndex(1)
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
    WZLog("BattleMsgPlayerShoot:_isHaveBullet zero", tostring(bullet), tostring(WBattleGlobal:getCurrent().m_bIsDoEffectAfterAttack), tostring(bullet and bullet.m_bIsExplode), tostring(hero and hero.m_tSkillTakeEffectCollionInfo), tostring(hero and hero.m_tSkillTakeEffectInfo))
	if WBattleGlobal:getCurrent():getBulletByIndex(2) == nil and bullet and bullet.m_bIsExplode and hero.m_tSkillTakeEffectCollionInfo == nil and hero.m_tSkillTakeEffectInfo == nil and WBattleGlobal:getCurrent().m_bIsDoEffectAfterAttack ~= true then
        WZLog("BattleMsgPlayerShoot:_isHaveBullet two")
        return false
    end

    if bullet ~= nil or WBattleGlobal:getCurrent().m_bIsDoEffectAfterAttack == true then
        WZLog("BattleMsgPlayerShoot:_isHaveBullet one")
		return true
	end
    
	return false
end

--@brief	创建子弹
--@param	nScatterNum:散射数量
function BattleMsgPlayerShoot:_createBullet(nScatterNum, isProcessMapEventBubble, isCloseShoot)
    WZLog("BattleMsgPlayerShoot:_createBullet zero",nScatterNum, self.m_nCurrentPlayerId, WBattleGlobal:getCurrent():getMyHero():getBattleId() )

    local speedx, speedy, startX, startY = self.m_nSpeedx, self.m_nSpeedy, self.m_nStartX, self.m_nStartY

    if isProcessMapEventBubble == true then
        speedx, speedy, startX, startY = self.m_nBubbleAtkSpeedX, self.m_nBubbleAtkSpeedY, self.m_nBubbleAtkStartX, self.m_nBubbleAtkStartY
        WZLog("BattleMsgPlayerShoot:_createBullet two",tostring(speedx),tostring(speedy),tostring(self.m_nBubbleAtkStartX),tostring(self.m_nBubbleAtkStartY))
    end
    

    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
    WZLog("BattleMsgPlayerShoot:_createBullet three", tostring(hero:getShootSoundName()));
    if hero:getShootSoundName() then
        SoundManager:playEffectSound(hero:getShootSoundName())
    elseif hero:getWeaponType() == 0 then
        SoundManager:playEffectSound(SoundDefine.E_S_SHOOT_1)
    else
        SoundManager:playEffectSound(SoundDefine.E_S_SHOOT_2)
    end

	local startAngle = 0
	startAngle = -1 * BattleConstants.g_fWB_SCATTER_ANGLE * (math.floor(nScatterNum / 2) - (nScatterNum+1)%2/2)
	local speedVec = BattleCommon:vectorWithAngle({x=speedx,y=speedy},startAngle)
	for i=1,nScatterNum do
		speedVec.x = tonumber(string.format("%.4f",speedVec.x))
		speedVec.y = tonumber(string.format("%.4f",speedVec.y))
        if self.m_tBulletStartPos then 
            startX = self.m_tBulletStartPos[self.m_nAttackedCount].x
            startY = self.m_tBulletStartPos[self.m_nAttackedCount].y
            speedVec.x = self.m_tBulletStartPos[self.m_nAttackedCount].speedX
            speedVec.y = self.m_tBulletStartPos[self.m_nAttackedCount].speedY
        end

        if self.m_bIsUseSkinBigSkill and self.m_nSkinBigSkillType == 3054 then 
            g_nCollisionIndex = 1
            speedVec.x = 0
            speedVec.y = 70
        elseif self.m_bIsUseSkinBigSkill and self.m_nSkinBigSkillType == 3061 then 
            g_nCollisionIndex = 1
            speedVec.x = -50
            speedVec.y = 0
            --靠近哪边就从哪边开始横推
            local battleSize = SceneBattle:getFrontLayerSize()
            local posX = battleSize.width
            self.m_nLeftRight = 1
            if self.m_nStartX < battleSize.width/2 then 
                posX = 0
                self.m_nLeftRight = 0
                speedVec.x = 50
            end
            startX = posX 
            startY = self.m_nStartY 
        end
		WZLog("BattleMsgPlayerShoot:_createBullet",i,self.m_nStartX,self.m_nStartY,speedVec.x,speedVec.y, self.m_nLeftRight)
		local bullet = WBattleGlobal:getCurrent():buildBullet(self.m_nCurrentPlayerId, startX, startY, speedVec.x, speedVec.y, nil, self.m_nBulletIndex, isCloseShoot)
        if self.m_nLeftRight == 1 and self.m_nSkinBigSkillType ~= 3062 then
            if self.m_bIsUseSkinBigSkill or bullet.m_bIsCloseShoot then 
    			bullet:getAnimation():setFlipX(true)
                if self.m_nSkinBigSkillType == 3037 or self.m_nSkinBigSkillType == 3045 then
                    bullet:getAnimation():setFlipY(true)
                end
            else
                bullet:getAnimation():setFlipY(true)
            end
		end
        if self.m_bIsUseSkinBigSkill and self.m_nSkinBigSkillType == 3061 and bullet then 
            bullet.m_mover:setMoverSpeed(Vector2:create(speedVec.x,0))
            local windX, windY = WBattleGlobal:getCurrent():getWind().x, WBattleGlobal:getCurrent():getWind().y
            bullet.m_mover:setFlyAcceleration(- windX, 0)
            bullet.m_mover:setMoverAcceleration(Vector2:create(0, 0))
        end
        --[[
        if WBattleGlobal:getCurrent().m_tIsHighEndMachine == true then
            SceneBattle:getFrontLayer():addChild(bullet:getBackFire():getParent(),2)
        end
        ]]
		SceneBattle:getFrontLayer():addChild(bullet:getAnimation():getAnimNode(),3)

        if self.m_nSkinBigSkillType ~= 3046 then
            bullet:getAnimation():play("0",true)
        end
        
        local hero = WBattleGlobal:getCurrent():getCurrentCharacter()
        WZLog("BattleMsgPlayerShoot:_createBullet four", hero:isHide())
        if hero:isHide() == true then
            if WBattleGlobal:getCurrent():isReplayGame() or WBattleGlobal:getCurrent():isMyTeam(hero:getBattleId()) then
                -- bullet:getAnimation():getAnimNode():setOpacity(51)
                bullet:setOpacity(51)
                WZLog("BattleMsgPlayerShoot:_createBullet five")
            else
                -- bullet:getAnimation():getAnimNode():setOpacity(0)
                WZLog("BattleMsgPlayerShoot:_createBullet sex")
                bullet:setOpacity(0)
            end
            WZLog("BattleMsgPlayerShoot:_createBullet seven", WBattleGlobal:getCurrent().m_tIsHighEndMachine)
            if WBattleGlobal:getCurrent().m_tIsHighEndMachine == true then
                bullet:getBackFire():setVisible(false)
            end
        end

		speedVec = BattleCommon:vectorWithAngle(speedVec,BattleConstants.g_fWB_SCATTER_ANGLE)

        self.m_nBulletIndex = self.m_nBulletIndex + 1
	end
end

--@brief    创建近身子弹
--@nate     某些皮肤大招，直接在敌方位置创建子弹
--@param    enemyChara: 敌人
--@param    nScatterNum:散射数量
function BattleMsgPlayerShoot:_createCloseBullet(nScatterNum, enemyChara)
    WZLog("BattleMsgPlayerShoot:_createCloseBullet zero",nScatterNum, self.m_nCurrentPlayerId, WBattleGlobal:getCurrent():getMyHero():getBattleId() )

    if self.m_nCurrentPlayerId == WBattleGlobal:getCurrent():getMyHero():getBattleId() then

    end
    local enemyPos = enemyChara:getCenterPos()

    local speedx, speedy, startX, startY = self.m_nSpeedx, self.m_nSpeedy, enemyPos.x, enemyPos.y

    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
    WZLog("BattleMsgPlayerShoot:_createCloseBullet three", tostring(hero:getShootSoundName()))
    if hero:getShootSoundName() then
        SoundManager:playEffectSound(hero:getShootSoundName())
    elseif hero:getWeaponType() == 0 then
        SoundManager:playEffectSound(SoundDefine.E_S_SHOOT_1)
    else
        SoundManager:playEffectSound(SoundDefine.E_S_SHOOT_2)
    end

    local startAngle = 0
    startAngle = -1 * BattleConstants.g_fWB_SCATTER_ANGLE * (math.floor(nScatterNum / 2) - (nScatterNum+1)%2/2)
    local speedVec = BattleCommon:vectorWithAngle({x=speedx,y=speedy},startAngle)
    for i = 1, nScatterNum do
        speedVec.x = tonumber(string.format("%.4f",speedVec.x))
        speedVec.y = tonumber(string.format("%.4f",speedVec.y))
        WZLog("BattleMsgPlayerShoot:_createCloseBullet",i,speedVec.x,speedVec.y)
        local bullet = WBattleGlobal:getCurrent():buildBullet(self.m_nCurrentPlayerId, startX, startY, speedVec.x, speedVec.y, nil, self.m_nBulletIndex)
        bullet:stop()
        if self.m_nLeftRight == 1 then
            if self.m_bIsUseSkinBigSkill then 
                bullet:getAnimation():setFlipX(true)
            else
                bullet:getAnimation():setFlipY(true)
            end
        end
        --[[
        if WBattleGlobal:getCurrent().m_tIsHighEndMachine == true then
            SceneBattle:getFrontLayer():addChild(bullet:getBackFire():getParent(),2)
        end
        ]]
        SceneBattle:getFrontLayer():addChild(bullet:getAnimation():getAnimNode(),3)

        bullet:getAnimation():play("0",true)
        
        local hero = WBattleGlobal:getCurrent():getCurrentCharacter()
        WZLog("BattleMsgPlayerShoot:_createCloseBullet four", hero:isHide())
        if hero:isHide() == true then
            if WBattleGlobal:getCurrent():isReplayGame() or WBattleGlobal:getCurrent():isMyTeam(hero:getBattleId()) then
                -- bullet:getAnimation():getAnimNode():setOpacity(51)
                bullet:setOpacity(51)
                WZLog("BattleMsgPlayerShoot:_createCloseBullet five")
            else
                -- bullet:getAnimation():getAnimNode():setOpacity(0)
                WZLog("BattleMsgPlayerShoot:_createCloseBullet sex")
                bullet:setOpacity(0)
            end
            WZLog("BattleMsgPlayerShoot:_createCloseBullet seven", WBattleGlobal:getCurrent().m_tIsHighEndMachine)
            if WBattleGlobal:getCurrent().m_tIsHighEndMachine == true then
                bullet:getBackFire():setVisible(false)
            end
        end

        speedVec = BattleCommon:vectorWithAngle(speedVec,BattleConstants.g_fWB_SCATTER_ANGLE)

        if self.m_nSkinBigSkillType == 3050 then
            self.m_nBulletIndex = self.m_nBulletIndex + 1
        else
            self.m_nBulletIndex = 1
        end
    end
end

--@brief    播放准备射击动画
function BattleMsgPlayerShoot:_readyCloseShoot()
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)

    WZLog("BattleMsgPlayerShoot:_readyCloseShoot 0:", hero:getAttTimes(), self.m_nAttackedCount)
    self.m_nShootDeltaTime = self.m_nShootDeltaTime + 1

    local isCanRepeatShoot = false

    --是否能跳转到射击子弹
    if self.m_nReadyToShootDeltaTime ~= 0 and self.m_nShootDeltaTime >= self.m_nReadyToShootDeltaTime * 30 then
        WZLog("BattleMsgPlayerShoot:_readyCloseShoot 1:", self.m_nShootDeltaTime)
        isCanRepeatShoot = true
    elseif hero:getAnimation():isCurrentAnimationDone() == true or hero:getAnimation():isPlaying(hero:getActionName(23)) then
        WZLog("BattleMsgPlayerShoot:_readyCloseShoot 2:", self.m_nShootDeltaTime)
        isCanRepeatShoot = true
    end

    --获取可攻击的敌人
    local tTarget = WBattleGlobal:getCurrent():getSomeSkinBigSkillTarget(hero)

    if isCanRepeatShoot then
        self.m_nTimeRemain = 0
        hero:setRunStatus(RunStatus.DEF_ST_REPEAT_SHOOT)
        WBattleGlobal:getCurrent():setBulletConfigNum(#tTarget)
        for i = 1, #tTarget do
            self:_createCloseBullet(1, tTarget[i])
        end
        self.m_nAttackedCount = self.m_nAttackedCount and self.m_nAttackedCount + 1 or 1
        WZLog("BattleMsgPlayerShoot:_readyCloseShoot 3:", hero:getAttTimes(), self.m_nAttackedCount)

        if hero:getAttTimes()-self.m_nAttackedCount >= 0 then
            WZLog("BattleMsgPlayerShoot:_readyCloseShoot three", hero:getAttTimes())
            WBattleGlobal:getCurrent().m_nAttackedCount = hero:getAttTimes()
            hero:playRepeatShootAnim(1)
        end
        self:_repeatShoot()
        return true
    else
        hero:setRunStatus(RunStatus.DEF_ST_READY_SHOOT)
        return false
    end
end

--@brief	屏幕显示最大范围
function BattleMsgPlayerShoot:_ZoomToOrigin()
    WZLog("BattleMsgBossMapSkill:_ZoomToOrigin")
    if WBattleGlobal:getCurrent():isGameOver() then
        return true
    end
    
    WZLog("BattleMsgPlayerShoot:_ZoomToOrigin one", WBattleGlobal:getCurrent().m_tGameOverHero and WBattleGlobal:getCurrent().m_tGameOverHero:getBattleId())
    WZLog("BattleMsgPlayerShoot:_ZoomToOrigin m_bIsPetShoot",self.m_bIsPetShoot)
    WBattleGlobal:getCurrent().m_bIsZoomToHero = true
    WBattleGlobal:getCurrent():setShowGameOver(true)

    local hero, scale, speed
    if WBattleGlobal:getCurrent().m_bIsGameOverTimer ~= true then
        hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
        if self.m_bIsUseSkinBigSkill then 
            scale = self.m_nLastScale
            speed = 1
        end
    else
        hero = WBattleGlobal:getCurrent().m_tGameOverHero
        scale = 1.2
        speed = 1
        WZLog("BattleMsgPlayerShoot:_ZoomToOrigin two")
    end
    
    if hero ~= nil then
        return BattleScreen:zoomToHero(hero:getBattleId(), hero:getMover():getMoverPosition(), nil, scale, speed)
    else
        return true
    end
end

--@brief    创建大招动画
function BattleMsgPlayerShoot:_showBigSkillNew()
    WZLog("BattleMsgPlayerShoot:_showBigSkillNew zero",self.m_nBigSkillState)
    --BattlePlayerBigSkillAnim:readyShow(WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId))
    
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
    if  self.m_nBigSkillState % 2 == 0 and self.m_tBigSkillAnim1 and self.m_tBigSkillAnim1:isCurrentAnimationDone() == true then
        self.m_nBigSkillState = self.m_nBigSkillState + 1
        self.m_tBigSkillAnim1:getAnimNode():removeFromParentAndCleanup(true)
        self.m_tBigSkillAnim1 = nil
        if self.m_tBigSkillAnim2 then
            self.m_tBigSkillAnim2:getAnimNode():removeFromParentAndCleanup(true)
            self.m_tBigSkillAnim2 = nil
        end
        if self.m_tBigSkillAnim3 then
            self.m_tBigSkillAnim3:getAnimNode():removeFromParentAndCleanup(true)
            self.m_tBigSkillAnim3 = nil
        end

    end

    if self.m_nBigSkillState == 1 then
        WZLog("BattleMsgPlayerShoot:_showBigSkillNew one",self.m_nBigSkillState)
        self.m_nBigSkillState = 2

        if hero.m_nBoyOrGirl == 0 then
            SoundManager:playEffectSound(getSoundByType(12))
        else
            SoundManager:playEffectSound(getSoundByType(7))
        end

        local myHero = WBattleGlobal:getCurrent():getMyHero()
        --hero.m_nRotatePre = tonumber(hero:getAnimation():getRotate())
        if self.m_nCurrentPlayerId ~= myHero:getBattleId() then
            if hero.m_bIsSetBigGun == nil then
                hero.m_bIsSetBigGun = true
                --[[
                if hero:getBigSkillType() == 2 then
                    hero:getAnimation():setWeaponBigSkill(3)
                elseif hero:getBigSkillType() == 0 then
                    hero:getAnimation():setWeaponBigSkill(2)
                else
                    hero:getAnimation():setGunBigSkill()
                end
                --]]
            end

            local speedX,speedY = self.m_nSpeedx, self.m_nSpeedy
            local angle = BattleCommon:pointToAngle(BattleCommon:getPointTable(speedX,speedY)) * -10
            if speedX < 0 then
                angle = BattleCommon:pointToAngle(BattleCommon:getPointTable(-speedX,speedY)) * 10
            end
            --hero:getAnimation():setRotate(hero.m_nRotatePre)
        end

        local scene = WndBattleHud
        GetElement(SceneBattle.m_root,"conBigSkill2_SceneBattle",WZUIContainer):setVisible(true)
        GetElement(scene.m_root,"conBigSkill2Back_WndBattleHud",WZUIContainer):setVisible(true)
        GetElement(scene.m_root,"imgBigSkill2Back_WndBattleHud",WZUIImage):setVisible(true)

        SoundManager:playEffectSound(SoundDefine.E_S_BIGSKILL)
        local isFashion = true

        if hero.m_nBoyOrGirl == 0 and hero.m_bIsMonster ~= true then
            if hero.m_tSuitInfo.head == "id_4903" and hero.m_tSuitInfo.face == "id_4902" and 
                hero.m_tSuitInfo.body == "id_4901" then
                isFashion = false
            end
        elseif hero.m_bIsMonster ~= true then
            if hero.m_tSuitInfo.head == "id_4906" and hero.m_tSuitInfo.face == "id_4905" and 
                hero.m_tSuitInfo.body == "id_4904" then
                isFashion = false
            end
        end
        
        if isFashion then
            local anim = BattleAnimation:createAnimation("skill_power_shuaping_b",false)
            anim:getAnimNode():setAnimationName("wait")
            anim:getAnimNode():setLoop(false)
            SceneBattle:getBigSkillLayer():addChild(anim:getAnimNode(),1)
            anim:setScale(1)
            anim:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0.05))
            self.m_tBigSkillAnim1 = anim

            local anim2 = BattleAnimation:createAnimation("skill_power_shuaping_a",false)
            anim2:getAnimNode():setAnimationName("wait")
            anim2:getAnimNode():setLoop(false)
            SceneBattle:getBigSkillLayer():addChild(anim2:getAnimNode(),1)
            anim2:setScale(1)
            anim2:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0.05))
            self.m_tBigSkillAnim2 = anim2

            local shopAnim = hero.m_shopAnim
            if hero.m_bIsMonster == true then
                shopAnim = YDPlayerAnimation:createAnimation(hero.m_nBoyOrGirl == 0,false,true)
                shopAnim:setMonsterId(hero.m_nMonsterId)
                shopAnim:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0))
                shopAnim:getAnimNode():setScale(0.84)
            end
            SceneBattle:getBigSkillLayer():addChild(shopAnim:getAnimNode(),2)

            ---[[
            if hero.m_bIsMonster == true then
                if math.abs(hero.m_nMonsterId) == 187 then 
                    shopAnim:play("attack_loop", true)
                else
                    if hero.m_nWeaponType == 0 then
                        shopAnim:play(hero:getActionName(9), false)
                    else
                        shopAnim:play(hero:getActionName(11), false)
                    end
                end
            else
                if hero.m_nWeaponType == 0 then
                    shopAnim:play(hero:getActionName(9), false)
                else
                    shopAnim:play(hero:getActionName(11), false)
                end
            end

            WZLog("BattleMsgPlayerShoot:_showBigSkillNew six", hero.m_nWeaponType)
            
            local scale = 1.7
            local x, y = 0.0,0
            if hero.m_bIsMonster == true or self.m_bIsUseSkinBigSkill then
                scale = 1.3
                x, y = 0.0,0.3
            end
            
            shopAnim:getAnimNode():setRelativePositionLuaTo(x, y)
            shopAnim:getAnimNode():setScaleX(scale * -1)
            shopAnim:getAnimNode():setScaleY(scale * 1)

            local act0=CCFadeTo:create(0,0)
            local array1 = CCArray:create()
            array1:addObject(CCFadeTo:create(0.33,255))
            array1:addObject(CCMoveBy:create(0.33,GlobalMethod:ccp(480,0)))
            local action = CCSpawn:create(array1)

            local act1=CCMoveBy:create(0.83,GlobalMethod:ccp(200,0))

            local array2 = CCArray:create()
            array2:addObject(CCFadeTo:create(0.12,10))
            array2:addObject(CCMoveBy:create(0.33,GlobalMethod:ccp(480,0)))
            local action1 = CCSpawn:create(array2)

            local array = CCArray:create()
            array:addObject(act0)
            array:addObject(action)
            array:addObject(act1)
            array:addObject(action1)
            array:addObject(CCCallFunc:create(function()
                shopAnim:getAnimNode():removeFromParentAndCleanup(false)
            end))
            shopAnim:getAnimNode():runAction(CCSequence:create(array))
            --]]
        else
            local anim = BattleAnimation:createAnimation("skill_power_shuaping",false)
            anim:getAnimNode():setRelativePositionLuaTo(0.5,1.0)
            if hero.m_nBoyOrGirl == 0 then
                anim:getAnimNode():setAnimationName("nan")
                --anim:play("nan",false)
            else
                anim:getAnimNode():setAnimationName("nv")
                --anim:play("nv",false)
            end
            anim:getAnimNode():setLoop(false)
            SceneBattle:getBigSkillLayer():addChild(anim:getAnimNode(),1)
            anim:setScale(1)
            anim:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
            self.m_tBigSkillAnim1 = anim

        end

    elseif self.m_nBigSkillState == 3 then
        WZLog("BattleMsgPlayerShoot:_showBigSkillNew two",self.m_nBigSkillState)
        self.m_nBigSkillState = 5

        --[[
        local anim = BattleAnimation:createAnimation("skill_power_fire_01",true)
        hero:getAnimation():getAnimNode():addChild(anim:getAnimNode(),1)
        anim:setPosition(BattleCommon:getPointTable(hero:getAnimation():getAnimNode():getContentSize().width/2 - 15, hero:getAnimation():getAnimNode():getContentSize().height/2 - 90))
        anim:play("0",false)
        anim:setScale(1)
        anim:getAnimNode().m_tMsg = self
        self.m_tBigSkillAnim1 = anim
        --]]

    elseif self.m_nBigSkillState == 5 then
        WZLog("BattleMsgPlayerShoot:_showBigSkillNew three",self.m_nBigSkillState)
        self.m_nBigSkillState = 7

        self.m_bCanFallDown = false
        hero:setMoveUpdatable(false)
        
        --hero:playReadyShootAnim()
    elseif self.m_nBigSkillState == 7 then
        WZLog("BattleMsgPlayerShoot:_showBigSkillNew four",self.m_nBigSkillState)
        self.m_nBigSkillState = 8

        return true
    end
    return false
end

--@brief	播放重复射击动画
function BattleMsgPlayerShoot:_repeatBigSkillShootAnim()

    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
    WZLog("BattleMsgPlayerShoot:_repeatBigSkillShootAnim",hero:getPosition().x,hero:getPosition().y)

    hero:setRunStatus(RunStatus.DEF_ST_REPEAT_SHOOT)
	hero:playRepeatShootAnim(1)

	self.m_nShootDeltaTime = 1
	self.m_nBigSkillNumber = 1
	return true
end

--@brief	重复射击
function BattleMsgPlayerShoot:_repeatBigSkillShoot()
	local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
	
	if self.m_nShootDeltaTime >= 0.8 * 30 and self.m_nBigSkillNumber <= 2 then
		self.m_nShootDeltaTime = 0
		hero.m_nBigSkillNumber = self.m_nBigSkillNumber
		self.m_nBigSkillNumber = self.m_nBigSkillNumber + 1
		self:_createBullet(hero:getAttScatterNum())

	---[[
	elseif self.m_nBigSkillNumber == 3 then
		self.m_nShootDeltaTime = 0
		hero:playBigSkillShootAnim()
		hero.m_nBigSkillNumber = self.m_nBigSkillNumber
		self.m_nBigSkillNumber = self.m_nBigSkillNumber + 1
		
	elseif self.m_nBigSkillNumber == 4 and self.m_nShootDeltaTime >= 1.6 * 30 then
		self:_createBullet(hero:getAttScatterNum())
	--]]
		if self.m_nBigSkillNumber > 2 then
			hero.m_bIsReadyShoot = nil
			return true
		end
	end
	-- self.m_nShootDeltaTime = self.m_nShootDeltaTime + SceneBattle:getBattleLoop():getBattleDeltaTime()
    self.m_nShootDeltaTime = self.m_nShootDeltaTime + 1

	return false
end

function BattleMsgPlayerShoot:_checkPetAttack()
    local isPetAttack = self:_isPetAttack()
    WZLog("BattleMsgPlayerShoot:_checkPetAttack one", isPetAttack, tostring(self.m_bIsPetShoot))
    if isPetAttack and self.m_bIsPetShoot ~= true then
        self.m_bIsReplayMsg = nil

        self.m_bIsPetShoot = true

        local shootHero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
        local nAttackTimes = shootHero.m_nPetAttackTimes or 1
        --宠物触发连击
        WZLog("BattleMsgPlayerShoot:_checkPetAttack two", type(shootHero.m_nPetAttackTimes))
        if shootHero.m_nPetAttackTimes then 
            local skillId = shootHero:getIsImmunityByPetSkill(1, EffectTypeConfig.PET_CONTINUE_SHOOT)
            local skillData = GDatatab_skill["id_" .. skillId]
            local effectInfo = GDatatab_effect["id_" .. skillData.effect_id[1][1]]
            local pos = self.m_tPetAttackEnemy:getAnimation():getPosition()
            BattlePetSkillManager:createImage(skillData.name, skillData.icon, nil, BattleCommon:getPointTable(pos.x,pos.y + 85), 2)
        end
        for i = 1, nAttackTimes do
            if i > 1 then 
                shootHero.m_nPetShootIndex = shootHero.m_nPetShootIndex + 1
            end
            local msg = MsgManager:createMsg(BattleMsgPetShoot)
            msg.m_shootHero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
            msg.m_beShootedChara = self.m_tPetAttackEnemy
            msg.m_bIsReplayMsg = true
            msg.m_nPetShootIndex = shootHero.m_nPetShootIndex
            MsgManager:pushBlockMsg(msg, 2+(i-1))
        end
    end
    return true
end 

--@brief	宠物是否攻击
--@return	#1:true,false
function BattleMsgPlayerShoot:_isPetAttack()
    WZLog("BattleMsgPlayerShoot:_isPetAttack one1")
	local shootHero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
    if not shootHero then 
        return false 
    end
    if self.m_tNoPetAttack == true then
        WZLog("BattleMsgPlayerShoot:_isPetAttack one2")
        return false
    end
	if shootHero:getPet() == nil then
        WZLog("BattleMsgPlayerShoot:_isPetAttack one3")
		return false
	end
	if self.m_tPetAttackEnemy == nil then
        WZLog("BattleMsgPlayerShoot:_isPetAttack one4")
		return false
	end
	if self.m_tPetAttackEnemy:getHp() <= 0 then
        WZLog("BattleMsgPlayerShoot:_isPetAttack one5", self.m_tPetAttackEnemy:getHp())
		return false
	end
	if self.m_tPetAttackEnemy:getIsFrozen() then
		--return false
	end
	if self.m_tPetAttackEnemy:getAnimation() == nil then
        WZLog("BattleMsgPlayerShoot:_isPetAttack one6")
		return false
	end
    if self.m_tPetAttackEnemy:isInBuffState(EffectTypeConfig.IMMUNITY_ATTACK) or shootHero:isInBuffState(EffectTypeConfig.IMMUNITY_ATTACK) then --身上有攻击不到的效果
        return false
    end
    WZLog("BattleMsgPlayerShoot:_isPetAttack two", tostring(shootHero:getCamp()), tostring(self.m_tPetAttackEnemy:getCamp()), self.m_tPetAttackEnemy:getBattleId())
    if shootHero:getCamp() == self.m_tPetAttackEnemy:getCamp() then
        return false
    end
    --宠物是否被封印
    if shootHero:isPetSeal() and not shootHero:isInIngoreBuff(BuffType.PETSEAL) then 
        return false 
    end

    do return true end

    return true
end

--@brief 录像记录
function BattleMsgPlayerShoot:_recordedSingleShoot()
    --录像记录
    WBattleGlobal:getCurrent():replayRecordSinglePos()

    if WBattleGlobal:getCurrent():canRecordGame() then
        --录像记录
        local replayParam = {}
        replayParam.m_nBattleId = self.m_nBattleId
        replayParam.m_nPlayerId = self.m_nPlayerId
        replayParam.m_nCurrentPlayerId = self.m_nCurrentPlayerId
        replayParam.m_nSpeedx = self.m_nSpeedx
        replayParam.m_nSpeedy = self.m_nSpeedy
        replayParam.m_nLeftRight = self.m_nLeftRight
        replayParam.m_nStartX = self.m_nStartX
        replayParam.m_nStartY = self.m_nStartY
        
        BattleMsgReplayGameRecord:setPlayerShoot(replayParam)
    end
end

--@brief 发送位置同步
function BattleMsgPlayerShoot:_sendBattleShoot()
    WZLog("BattleMsgPlayerShoot:_sendBattleShoot")
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
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
        -- WZLog("BattleMsgPlayerShoot:_sendBattlePos",id,player:getAnimation():getPosition().x,player:getAnimation():getPosition().y)
    end
    local nGuaiCount = 0
    local tGuaiId = {}
    local tGuaiCurPositionX = {}
    local tGuaiCurPositionY = {}
    if WBattleGlobal:getCurrent():getGuaiList() ~= nil then
        for id,guai in pairs(WBattleGlobal:getCurrent():getGuaiList()) do
            if id ~= -1 and guai:getAnimation() ~= nil then
                table.insert(tGuaiId,id)
                table.insert(tGuaiCurPositionX, guai:getAnimation():getPosition().x)
                table.insert(tGuaiCurPositionY, guai:getAnimation():getPosition().y)
                nGuaiCount = nGuaiCount + 1
            end
        end
    end
    
    local nStartX, nStartY = self.m_nStartX, self.m_nStartY
    -- 对于特定皮肤(宇航员,鬼新娘)大招特殊处理 发送的startX,startY为子弹爆炸位置,接收时再做处理
    if self.m_bIsUseSkinBigSkill and (self.m_nSkinBigSkillType == 3030 or self.m_nSkinBigSkillType == 3046 or self.m_nSkinBigSkillType == 3059 or self.m_nSkinBigSkillType == 3063 or self.m_nSkinBigSkillType == 3064) then
        nStartX, nStartY = self.m_nEndX, self.m_nEndY
    elseif self.m_bIsUseSkinBigSkill and self.m_nSkinBigSkillType == 3054 then
        nStartX, nStartY = self.m_nBulletEndX, self.m_nBulletEndY
    elseif self.m_bIsUseSkinBigSkill and self.m_nSkinBigSkillType == 3061 then
        nStartX, nStartY = self.m_nStartX, self.m_nStartY
    end

    local count = hero:getAttTimes() * hero:getAttScatterNum()
    WZLog("BattleMsgPlayerShoot:_sendBattleShoot-2",self.m_nBattleId, self.m_nCurrentPlayerId, self.m_nSpeedx, self.m_nSpeedy, self.m_nLeftRight, nStartX, nStartY, nPlayerCount, tPlayerId, tCurPositionX, tCurPositionY,count)
    ProtocolProcessorBattleInterface:send_BATTLE_Shoot(self.m_nBattleId, self.m_nCurrentPlayerId, self.m_nSpeedx, self.m_nSpeedy, self.m_nLeftRight, nStartX, nStartY, nPlayerCount, tPlayerId, tCurPositionX, tCurPositionY, tCurPositionR, tCurPositionD, count, BattlePointsLine:getCount())
end

--@brief 发送位置同步（副本战）
function BattleMsgPlayerShoot:_sendBossBattleShoot()
    WZLog("BattleMsgPlayerShoot:_sendBossBattleShoot")
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
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
                table.insert(tCurPositionR, guai:getAnimation():getRotate())
                table.insert(tCurPositionD, guai:getAnimation():isFlipX() and 1 or 0)
                nPlayerCount = nPlayerCount + 1
            end
        end
    end
    
    local nStartX, nStartY = self.m_nStartX, self.m_nStartY
    -- 对于特定皮肤(宇航员,鬼新娘)大招特殊处理 发送的startX,startY为子弹爆炸位置,接收时再做处理
    if self.m_bIsUseSkinBigSkill and (self.m_nSkinBigSkillType == 3030 or self.m_nSkinBigSkillType == 3046 or self.m_nSkinBigSkillType == 3059 or self.m_nSkinBigSkillType == 3063 or self.m_nSkinBigSkillType == 3064) then
        nStartX, nStartY = self.m_nEndX, self.m_nEndY
    elseif self.m_bIsUseSkinBigSkill and (self.m_nSkinBigSkillType == 3054) then
        nStartX, nStartY = self.m_nBulletEndX, self.m_nBulletEndY
    elseif self.m_bIsUseSkinBigSkill and (self.m_nSkinBigSkillType == 3061) then
        nStartX, nStartY = self.m_nStartX, self.m_nStartY
    end

    local count = hero:getAttTimes() * hero:getAttScatterNum()
    WZLog("BattleMsgPlayerShoot:_sendBossBattleShoot-2",self.m_nBattleId, self.m_nCurrentPlayerId, self.m_nSpeedx, self.m_nSpeedy, self.m_nLeftRight, nStartX, nStartY, nPlayerCount, tPlayerId, tCurPositionX, tCurPositionY,count)
    ProtocolProcessorBattleInterface:send_BATTLE_Shoot(self.m_nBattleId, self.m_nCurrentPlayerId, self.m_nSpeedx, self.m_nSpeedy, self.m_nLeftRight, nStartX, nStartY, nPlayerCount, tPlayerId, tCurPositionX, tCurPositionY, tCurPositionR, tCurPositionD,count, 0)
end

--@brief 同步位置
function BattleMsgPlayerShoot:_syncBattleShoot()
    WZLog("BattleMsgPlayerShoot:_syncBattleShoot",self.m_nPlayerCount)
    for i=1, self.m_nPlayerCount do
        if true then
            local _hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_tPlayerId[i])
            local pos = _hero:getPosition()
            local rotate = _hero:getAnimation():getRotate()
            local flip = _hero:getAnimation():isFlipX() and 1 or 0

            if not _hero:isDead() and (math.abs(pos.x - self.m_tCurPositionX[i]) >= 10 or math.abs(pos.y - self.m_tCurPositionY[i]) >= 10) then 
            else
                _hero:setPosition({x = self.m_tCurPositionX[i] , y = self.m_tCurPositionY[i] } )
                if _hero:getMover() then
                    _hero:getMover():setMoverSpeed(Vector2:create(0,0))
                    _hero:getMover():setMoverPrePosition( Vector2:create( self.m_tCurPositionX[i] , self.m_tCurPositionY[i]) )
                end
                _hero:getAnimation():setRotate(self.m_tCurPositionR[i])
                _hero:getAnimation():setFlipX(self.m_tCurPositionD[i] == 1 and true or false)
            end

            WZLog("BattleMsgPlayerShoot:_syncBattleShoot-2",self.m_tPlayerId[i], pos.x,self.m_tCurPositionX[i], pos.y, self.m_tCurPositionY[i], rotate, self.m_tCurPositionR[i], flip, self.m_tCurPositionD[i])
        end
    end
end

--@brief 数值转换
function BattleMsgPlayerShoot:_float2int2float()
    WZLog("BattleMsgPlayerShoot:_float2int2float zero")
    self.m_nSpeedx = BattleCommon:float2int2float(self.m_nSpeedx)
    self.m_nSpeedy = BattleCommon:float2int2float(self.m_nSpeedy)
    self.m_nStartX = BattleCommon:float2int2float(self.m_nStartX)
    self.m_nStartY = BattleCommon:float2int2float(self.m_nStartY)

    for id, player in pairs(WBattleGlobal:getCurrent():getHeroList()) do
        local x = BattleCommon:float2int2float(player:getAnimation():getPosition().x)
        local y = BattleCommon:float2int2float(player:getAnimation():getPosition().y)
        local r = BattleCommon:float2int2float(player:getAnimation():getRotate())

        WZLog("BattleMsgPlayerShoot:_float2int2float one", player:getAnimation():getPosition().x, player:getAnimation():getPosition().y, "x, y", x, y)
        player:setPosition({x = x, y = y})
        if player.getMover and player:getMover() then
            player:getMover():setMoverSpeed(Vector2:create(0,0))
            player:getMover():setMoverPrePosition(Vector2:create(x , y))
        end
        player:getAnimation():setRotate(r)
    end

    if WBattleGlobal:getCurrent():getGuaiList() ~= nil then
        for id,player in pairs(WBattleGlobal:getCurrent():getGuaiList()) do
            local x = BattleCommon:float2int2float(player:getAnimation():getPosition().x)
            local y = BattleCommon:float2int2float(player:getAnimation():getPosition().y)
            local r = BattleCommon:float2int2float(player:getAnimation():getRotate())

            player:setPosition({x = x, y = y})
            if player.getMover and player:getMover() then
                player:getMover():setMoverSpeed(Vector2:create(0,0))
                player:getMover():setMoverPrePosition(Vector2:create(x , y))
            end
            player:getAnimation():setRotate(r)
        end
    end
end

--@brief    皮肤大招攻击后，英雄
function BattleMsgPlayerShoot:_showSkinHero()
    -- body
    WZLog("BattleMsgPlayerShoot:_showSkinHero")
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)

    if hero:getSkinBigSkillAnimation() and self.m_bIsUseSkinBigSkill then 
        local tempShapeData = WBattleGlobal:getCurrent():getSkinBigSkillShape(self.m_nSkinBigSkillType)
        if tempShapeData.id == 1079 or tempShapeData.id == 1080 then 
            if hero.m_nHideOpecity then 
                hero:getSkinBigSkillAnimation():getAnimNode():setOpacity(hero.m_nHideOpecity)
            else
                hero:getSkinBigSkillAnimation():getAnimNode():setOpacity(255)
            end
        else
            if hero.m_nHideOpecity then 
                hero:getSkinBigSkillAnimation():getAnimNode():setOpacity(hero.m_nHideOpecity)
            else
                hero:getSkinBigSkillAnimation():getAnimNode():setOpacity(255)
            end
        end

        return true
    end

    return true
end

--@brief    皮肤大招攻击后，隐藏皮肤形象
function BattleMsgPlayerShoot:_hideSkinHero()
    -- body
    WZLog("BattleMsgPlayerShoot:_hideSkinHero")
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)

    hero:getSkinBigSkillAnimation():getAnimNode():setOpacity(0)

    return true
end

--@brief    皮肤大招攻击结束后，显示英雄
function BattleMsgPlayerShoot:_showAttackHero()
    -- body
    WZLog("BattleMsgPlayerShoot:_showAttackHero")
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)

    return hero:_showAttackHero() 
end

--@brief    播放皮肤大招闪现动画
function BattleMsgPlayerShoot:_showSkinSlipAttackAni(bullet)
    -- body
    if self.m_nSkinBigSkillType == 3001 then 
        local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
        local bulletPt = bullet:getPosition()
        local array = CCArray:create()
        local move = CCMoveTo:create(0.25, GlobalMethod:ccp(bulletPt.x, bulletPt.y))
        array:addObject(move)
        array:addObject(CCCallFunc:create(stopSkinSlipAttack))
        hero:getSkinBigSkillAnimation():play("attack_2", false)
        hero:getSkinBigSkillAnimation():getAnimNode():runAction(CCSequence:create(array))
    elseif self.m_nSkinBigSkillType == 3014 or self.m_nSkinBigSkillType == 3015 then 
        local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
        local bulletPt = bullet:getPosition()
        local heroPos = hero:getPosition()
        local array = CCArray:create()
        local move = CCMoveTo:create(0.25, GlobalMethod:ccp(heroPos.x + (bulletPt.x - heroPos.x)/2, bulletPt.y + 100))
        array:addObject(move)
        array:addObject(CCCallFunc:create(stopSkinSlipAttackTwo))
        local moveEnd = CCMoveTo:create(0.25, GlobalMethod:ccp(bulletPt.x, bulletPt.y))
        array:addObject(moveEnd)
        array:addObject(CCCallFunc:create(stopSkinSlipAttack))
        hero:getSkinBigSkillAnimation():play("attack_1", false)
        hero:getSkinBigSkillAnimation():getAnimNode():runAction(CCSequence:create(array))
    elseif self.m_nSkinBigSkillType == 3002 or self.m_nSkinBigSkillType == 3005 then 
        local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
        hero:getSkinBigSkillAnimation():getAnimNode():setVisible(false)
        
        g_nCollisionIndex = 2 
    elseif self.m_nSkinBigSkillType == 3028 then
        local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
        local heroPos = hero:getPosition()
        local bulletPt = bullet:getPosition()
        local bFacingLeft = true   --是否朝向左边
        if bulletPt.x - heroPos.x >= 0 then
            bFacingLeft = false
        end
        hero:getSkinBigSkillAnimation():getAnimNode():setFlipX(bFacingLeft)
        hero:getSkinBigSkillAnimation():play("attack_2", false)
        --第12帧为暗黑元素attack_2动作放技能前摇结束
        local nEndTime = 12/DEFAULT_FPS
        DelayCallFunction(self.creatSkinBulletAni,self,nEndTime,bullet)
    elseif self.m_nSkinBigSkillType == 3027 then
        local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
        local heroPos = hero:getPosition()
        local bulletPt = bullet:getPosition()
        local array = CCArray:create()
        local OffsetX = 250
        local bFacingLeft = true   --是否朝向左边
        if bulletPt.x - heroPos.x >= 0 then
            OffsetX = -250
            bFacingLeft = false
        end
        hero:getSkinBigSkillAnimation():getAnimNode():setFlipX(bFacingLeft)
        local move = CCMoveTo:create(0.25, GlobalMethod:ccp(bulletPt.x + OffsetX, bulletPt.y))
        array:addObject(move)
        array:addObject(CCCallFunc:create(function()
            hero:getSkinBigSkillAnimation():play("attack_2", false)
        end))
        array:addObject(CCDelayTime:create(25/DEFAULT_FPS)) --25帧左右放出火焰
        array:addObject(CCCallFunc:create(function()
            g_nCollisionIndex = 2 
        end))
        array:addObject(CCDelayTime:create(17/DEFAULT_FPS)) --17帧左右attack_2动作播放结束
        array:addObject(CCCallFunc:create(function()
            hero:getSkinBigSkillAnimation():play("wait", true)
        end))
        hero:getSkinBigSkillAnimation():play("attack_1", false)
        hero:getSkinBigSkillAnimation():getAnimNode():runAction(CCSequence:create(array))
    elseif self.m_nSkinBigSkillType == 3034 then
        local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
        local heroPos = hero:getPosition()
        local bulletPt = bullet:getPosition()
        local bFacingLeft = true   --是否朝向左边
        if bulletPt.x - heroPos.x >= 0 then
            bFacingLeft = false
        end
        hero:getSkinBigSkillAnimation():getAnimNode():setFlipX(bFacingLeft)

        local skinBigSkill = bullet.m_ownerChara:getSkinBigSkill()
        local tempShapeData = WBattleGlobal:getCurrent():getSkinBigSkillShape(skinBigSkill)
        local name = "boss_"..tempShapeData.bullet.."_attack2"
        local nBulletAniReplica = BattleAnimation:createAnimation(name,false)
        nBulletAniReplica:getAnimNode():setScale(1)
        nBulletAniReplica:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        nBulletAniReplica:getAnimNode():setUseAbsCoordinate(true)
        nBulletAniReplica:getAnimNode():setAbsPosition(ccp(bulletPt.x, bulletPt.y+200))
        nBulletAniReplica:getAnimNode():setAnimationName("attack")
        nBulletAniReplica:getAnimNode():setLoop(false)
        SceneBattle:getFrontLayer():addChild(nBulletAniReplica:getAnimNode())

        --第36帧为水龙attack动作结束
        local nEndTime = 30/DEFAULT_FPS
        DelayCallFunction(function ()
            if nBulletAniReplica and nBulletAniReplica:getAnimNode() and nBulletAniReplica:getAnimNode():getParent() then
                -- if nBulletAniReplica:isCurrentAnimationDone() then
                    local animNode = nBulletAniReplica:getAnimNode()
                    WZLog("BattleMsgPlayerShoot:_removeBulletAniReplica 1-3034")
                    if animNode:getParent() then
                        WZLog("BattleMsgPlayerShoot:_removeBulletAniReplica 2-3034")
                        animNode:removeFromParentAndCleanup(true)
                    end
                    nBulletAniReplica = nil
                -- end
            end

            g_nCollisionIndex = 2
        end, nil, nEndTime)
    elseif self.m_nSkinBigSkillType == 3035 then
        local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
        local heroPos = hero:getPosition()
        local bulletPt = bullet:getPosition()
        local bFacingLeft = true   --是否朝向左边
        if bulletPt.x - heroPos.x >= 0 then
            bFacingLeft = false
        end
        hero:getSkinBigSkillAnimation():getAnimNode():setFlipX(bFacingLeft)
        hero:getSkinBigSkillAnimation():play("attack_2", false)
        local nEndTime = 10/DEFAULT_FPS
        DelayCallFunction(self.creatSkinBulletAni1109,self,nEndTime,bullet)
    elseif self.m_nSkinBigSkillType == 3036 then
        self:showSkinBigSkillAction3036(bullet)
    elseif self.m_nSkinBigSkillType == 3040 then --牛魔王
        local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
        local heroPos = hero:getPosition()
        local bulletPt = bullet:getPosition()
        local array = CCArray:create()
        local bFacingLeft = true   --是否朝向左边
        local OffsetX = 250
        local OffsetY = 200
        if bulletPt.x - heroPos.x >= 0 then
            bFacingLeft = false
            OffsetX = -250
        end
        hero:getSkinBigSkillAnimation():getAnimNode():setFlipX(bFacingLeft)

        local skinBigSkill = bullet.m_ownerChara:getSkinBigSkill()
        local tempShapeData = WBattleGlobal:getCurrent():getSkinBigSkillShape(skinBigSkill)
        local name = "boss_"..tempShapeData.bullet
        self.m_nBulletAniReplica = BattleAnimation:createAnimation(name,false)
        self.m_nBulletAniReplica:getAnimNode():setFlipX(bFacingLeft)
        self.m_nBulletAniReplica:getAnimNode():setScale(1)
        self.m_nBulletAniReplica:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        self.m_nBulletAniReplica:getAnimNode():setUseAbsCoordinate(true)
        self.m_nBulletAniReplica:getAnimNode():setAbsPosition(ccp(bulletPt.x + OffsetX, bulletPt.y + OffsetY))
        SceneBattle:getFrontLayer():addChild(self.m_nBulletAniReplica:getAnimNode())

        bullet:getAnimation():getAnimNode():setVisible(false)

        array:addObject(CCCallFunc:create(function()
            self.m_nBulletAniReplica:play("attack_2", false)
        end))
        array:addObject(CCDelayTime:create(13/DEFAULT_FPS))
        array:addObject(CCCallFunc:create(function()
            g_nCollisionIndex = 2
        end))
        array:addObject(CCCallFunc:create(function()
            self.m_nBulletAniReplica:play("attack_3", false)
        end))
        array:addObject(CCDelayTime:create(10/DEFAULT_FPS))
        array:addObject(CCCallFunc:create(function()
            self.m_nBulletAniReplica:getAnimNode():setVisible(false)
        end))
        array:addObject(CCCallFunc:create(function()
            if self.m_nBulletAniReplica and self.m_nBulletAniReplica:getAnimNode() and self.m_nBulletAniReplica:getAnimNode():getParent() then
                local animNode = self.m_nBulletAniReplica:getAnimNode()
                WZLog("BattleMsgPlayerShoot:_removeBulletAniReplica 1-3040")
                if animNode:getParent() then
                    WZLog("BattleMsgPlayerShoot:_removeBulletAniReplica 2-3040")
                    animNode:removeFromParentAndCleanup(true)
                end
                self.m_nBulletAniReplica = nil
            end
        end))
        self.m_nBulletAniReplica:getAnimNode():runAction(CCSequence:create(array))
    elseif self.m_nSkinBigSkillType == 3043 then --般若
        self:showSkinBigSkillAction3043(bullet)
    elseif self.m_nSkinBigSkillType == 3044 then --双生梦境
        local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
        local heroPos = hero:getPosition()
        local bulletPt = bullet:getPosition()
        local array = CCArray:create()
        local OffsetX = 130
        local bFacingLeft = true   --是否朝向左边
        if bulletPt.x - heroPos.x >= 0 then
            OffsetX = -130
            bFacingLeft = false
        end
        hero:getSkinBigSkillAnimation():getAnimNode():setFlipX(bFacingLeft)
        local move = CCMoveTo:create(0, GlobalMethod:ccp(bulletPt.x + OffsetX, bulletPt.y))
        array:addObject(move)
        array:addObject(CCCallFunc:create(function()
            hero:getSkinBigSkillAnimation():play("attack_1", false)
        end))
        array:addObject(CCDelayTime:create(18/DEFAULT_FPS))
        array:addObject(CCCallFunc:create(function()
            hero:getSkinBigSkillAnimation():play("attack_2", false)
        end))
        array:addObject(CCDelayTime:create(18/DEFAULT_FPS))
        array:addObject(CCCallFunc:create(function()
            g_nCollisionIndex = 2 
        end))
        array:addObject(CCCallFunc:create(function()
            hero:getSkinBigSkillAnimation():play("wait", true)
        end))
        hero:getSkinBigSkillAnimation():getAnimNode():runAction(CCSequence:create(array))
    elseif self.m_nSkinBigSkillType == 3047 then 
        self:showSkinBigSkillAction3047()
    elseif self.m_nSkinBigSkillType == 3049 then 
        self:showSkinBigSkillAction3049(bullet)
    elseif self.m_nSkinBigSkillType == 3051 then 
        self:showSkinBigSkillAction3051(bullet)
    elseif self.m_nSkinBigSkillType == 3053 then
        self:showSkinBigSkillAction3053(bullet)
    else
        g_nCollisionIndex = 2 
    end
end

--@brief    皮肤大招:姜子牙
function BattleMsgPlayerShoot:showSkinBigSkillAction3053(bullet)
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
    local heroPos = hero:getPosition()
    local bulletPt = bullet:getPosition()
    --人物朝向
    local bFacingLeft = true   --是否朝向左边
    if bulletPt.x - heroPos.x >= 0 then
        bFacingLeft = false
    end
    hero:getSkinBigSkillAnimation():getAnimNode():setFlipX(bFacingLeft)
    --创建武器动画
    local skinBigSkill = bullet.m_ownerChara:getSkinBigSkill()
    local tempShapeData = WBattleGlobal:getCurrent():getSkinBigSkillShape(skinBigSkill)
    local name = "boss_"..tempShapeData.bullet.."_attack03"
    self.m_nBulletAniReplica = BattleAnimation:createAnimation(name,false)
    self.m_nBulletAniReplica:getAnimNode():setScale(1)
    self.m_nBulletAniReplica:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    self.m_nBulletAniReplica:getAnimNode():setUseAbsCoordinate(true)
    self.m_nBulletAniReplica:getAnimNode():setAbsPosition(ccp(heroPos.x, heroPos.y + 340))
    self.m_nBulletAniReplica:getAnimNode():setAnimationName("attack_4")
    self.m_nBulletAniReplica:getAnimNode():setLoop(true)
    SceneBattle:getFrontLayer():addChild(self.m_nBulletAniReplica:getAnimNode())

    --设置武器角度
    self.m_nReplicaLastPt = self.m_nBulletAniReplica:getAnimNode():getRelativePosition() --前一个坐标

    if self.m_nBulletAniReplica and self.m_nBulletAniReplica:getAnimNode() and self.m_nBulletAniReplica:getAnimNode():getParent() then
        if heroPos.x > bulletPt.x then
            self.m_nBulletAniReplica:getAnimNode():setFlipY(true)
        else
            self.m_nBulletAniReplica:getAnimNode():setFlipY(false)
        end
    end

    --子弹展示
    local arrayAni = CCArray:create()

    arrayAni:addObject(CCDelayTime:create(10/DEFAULT_FPS))

    local moveTo1 = CCMoveTo:create(0.5, GlobalMethod:ccp(bulletPt.x, bulletPt.y + 50))
    arrayAni:addObject(moveTo1)

    arrayAni:addObject(CCCallFunc:create(function()
        g_nCollisionIndex = 2
    end))

    arrayAni:addObject(CCCallFunc:create(function()
        if self.m_nBulletAniReplica and self.m_nBulletAniReplica:getAnimNode() and self.m_nBulletAniReplica:getAnimNode():getParent() then
            local animNode = self.m_nBulletAniReplica:getAnimNode()
            WZLog("BattleMsgPlayerShoot:_removeBulletAniReplica 1-3053")
            if animNode:getParent() then
                WZLog("BattleMsgPlayerShoot:_removeBulletAniReplica 2-3053")
                animNode:removeFromParentAndCleanup(true)
            end
            self.m_nReplicaLastPt = nil
            self.m_nBulletAniReplica = nil
        end
    end))

    local sequence = CCSequence:create(arrayAni)
    self.m_nBulletAniReplica:getAnimNode():runAction(sequence)

    --人物展示
    local arrayAni2 = CCArray:create()
    arrayAni2:addObject(CCCallFunc:create(function()
        hero:getSkinBigSkillAnimation():play("attack_2", false)
    end))

    arrayAni2:addObject(CCDelayTime:create(20/DEFAULT_FPS))

    arrayAni2:addObject(CCCallFunc:create(function()
        hero:getSkinBigSkillAnimation():play("attack_3", false)
    end))

    arrayAni2:addObject(CCDelayTime:create(20/DEFAULT_FPS))

    arrayAni2:addObject(CCCallFunc:create(function()
        hero:getSkinBigSkillAnimation():play("wait", true)
    end))
    
    local sequence2 = CCSequence:create(arrayAni2)
    hero:getSkinBigSkillAnimation():getAnimNode():runAction(sequence2)
end

--@brief    皮肤大招:傀儡师
function BattleMsgPlayerShoot:showSkinBigSkillAction3051(bullet)
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
    local heroPos = hero:getPosition()
    local bulletPt = bullet:getPosition()
    --人物朝向
    local OffsetX = 200
    local bFacingLeft = true   --是否朝向左边
    if bulletPt.x - heroPos.x >= 0 then
        OffsetX = OffsetX * -1
        bFacingLeft = false
    end
    hero:getSkinBigSkillAnimation():getAnimNode():setVisible(false)
    --创建武器动画
    local skinBigSkill = bullet.m_ownerChara:getSkinBigSkill()
    local tempShapeData = WBattleGlobal:getCurrent():getSkinBigSkillShape(skinBigSkill)
    local name = "boss_"..tempShapeData.bullet
    self.m_nBulletAniReplica = BattleAnimation:createAnimation(name,false)
    self.m_nBulletAniReplica:getAnimNode():setScale(0.7)
    self.m_nBulletAniReplica:getAnimNode():setUseAbsCoordinate(true)
    self.m_nBulletAniReplica:getAnimNode():setAbsPosition(ccp(heroPos.x, heroPos.y))
    SceneBattle:getFrontLayer():addChild(self.m_nBulletAniReplica:getAnimNode())

    --开始动作
    local arrayAni = CCArray:create()
    arrayAni:addObject(CCCallFunc:create(function()
        self.m_nBulletAniReplica:getAnimNode():setFlipX(bFacingLeft)
        self.m_nBulletAniReplica:getAnimNode():setAbsPosition(ccp(bulletPt.x + OffsetX, bulletPt.y + 160))
        self.m_nBulletAniReplica:getAnimNode():play("attack_1", false)
    end))
    arrayAni:addObject(CCDelayTime:create(14/DEFAULT_FPS))
    arrayAni:addObject(CCCallFunc:create(function()
        self.m_nBulletAniReplica:getAnimNode():play("attack_2", false)
    end))
    arrayAni:addObject(CCDelayTime:create(16/DEFAULT_FPS))
    arrayAni:addObject(CCCallFunc:create(function()
        g_nCollisionIndex = 2
        self.m_nBulletAniReplica:getAnimNode():play("attack_3", false)
    end))
    arrayAni:addObject(CCDelayTime:create(16/DEFAULT_FPS))
    arrayAni:addObject(CCCallFunc:create(function()
        if self.m_nBulletAniReplica and self.m_nBulletAniReplica:getAnimNode() and self.m_nBulletAniReplica:getAnimNode():getParent() then
            local animNode = self.m_nBulletAniReplica:getAnimNode()
            WZLog("BattleMsgPlayerShoot:_removeBulletAniReplica 1-3051")
            if animNode:getParent() then
                WZLog("BattleMsgPlayerShoot:_removeBulletAniReplica 2-3051")
                animNode:removeFromParentAndCleanup(true)
            end
            self.m_nBulletAniReplica = nil
        end
    end))
    local sequence = CCSequence:create(arrayAni)
    self.m_nBulletAniReplica:getAnimNode():runAction(sequence)
end

--@brief    皮肤大招:盖亚公主
function BattleMsgPlayerShoot:showSkinBigSkillAction3049(bullet)
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
    local heroPos = hero:getPosition()
    local bulletPt = bullet:getPosition()
    local array = CCArray:create()
    local bFacingLeft = true   --是否朝向左边
    local OffsetY = 450
    if bulletPt.x - heroPos.x >= 0 then
        bFacingLeft = false
    end
    hero:getSkinBigSkillAnimation():getAnimNode():setFlipX(bFacingLeft)

    local skinBigSkill = bullet.m_ownerChara:getSkinBigSkill()
    local tempShapeData = WBattleGlobal:getCurrent():getSkinBigSkillShape(skinBigSkill)
    local name = "boss_"..tempShapeData.bullet.."_attack"
    self.m_nBulletAniReplica = BattleAnimation:createAnimation(name,false)
    self.m_nBulletAniReplica:getAnimNode():setFlipX(bFacingLeft)
    self.m_nBulletAniReplica:getAnimNode():setScale(1)
    self.m_nBulletAniReplica:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    self.m_nBulletAniReplica:getAnimNode():setUseAbsCoordinate(true)
    self.m_nBulletAniReplica:getAnimNode():setAbsPosition(ccp(bulletPt.x, bulletPt.y + OffsetY))
    SceneBattle:getFrontLayer():addChild(self.m_nBulletAniReplica:getAnimNode())

    array:addObject(CCCallFunc:create(function()
        self.m_nBulletAniReplica:play("attack2", false)
    end))

    array:addObject(CCCallFunc:create(function()
        hero:getSkinBigSkillAnimation():play("attack_2", false)
    end))
    array:addObject(CCDelayTime:create(6/DEFAULT_FPS)) --人物attack_2播放完
    array:addObject(CCCallFunc:create(function()
        hero:getSkinBigSkillAnimation():play("attack_3", false)
    end))
    array:addObject(CCDelayTime:create(6/DEFAULT_FPS)) --子弹attack2播放完
    array:addObject(CCCallFunc:create(function()
        g_nCollisionIndex = 2
    end))
    array:addObject(CCCallFunc:create(function()
        if self.m_nBulletAniReplica and self.m_nBulletAniReplica:getAnimNode() and self.m_nBulletAniReplica:getAnimNode():getParent() then
            local animNode = self.m_nBulletAniReplica:getAnimNode()
            WZLog("BattleMsgPlayerShoot:_removeBulletAniReplica 1-3049")
            if animNode:getParent() then
                WZLog("BattleMsgPlayerShoot:_removeBulletAniReplica 2-3049")
                animNode:removeFromParentAndCleanup(true)
            end
            self.m_nBulletAniReplica = nil
        end
    end))
    self.m_nBulletAniReplica:getAnimNode():runAction(CCSequence:create(array))
end

--@brief    皮肤大招:李白
function BattleMsgPlayerShoot:showSkinBigSkillAction3047()
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
    local tTarget = WBattleGlobal:getCurrent():getSomeSkinBigSkillTarget(hero)

    for i = 1, #tTarget do
        local targetPt = tTarget[i]:getPosition()

        local skinBigSkill = hero:getSkinBigSkill()
        local tempShapeData = WBattleGlobal:getCurrent():getSkinBigSkillShape(skinBigSkill)
        local strAnimation = tempShapeData.animation.."_attack"

        local nBulletAniReplica = BattleAnimation:createAnimation(strAnimation,false)
        nBulletAniReplica:getAnimNode():setScale(1)
        nBulletAniReplica:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        nBulletAniReplica:getAnimNode():setUseAbsCoordinate(true)
        nBulletAniReplica:getAnimNode():setAbsPosition(ccp(targetPt.x, targetPt.y+200))
        nBulletAniReplica:getAnimNode():setAnimationName("attack2")
        nBulletAniReplica:getAnimNode():setLoop(false)
        SceneBattle:getFrontLayer():addChild(nBulletAniReplica:getAnimNode())

        local array = CCArray:create()
        array:addObject(CCDelayTime:create(30/DEFAULT_FPS))
        array:addObject(CCCallFunc:create(function()
            if nBulletAniReplica and nBulletAniReplica:getAnimNode() and nBulletAniReplica:getAnimNode():getParent() then
                local animNode = nBulletAniReplica:getAnimNode()
                WZLog("BattleMsgPlayerShoot:_removeBulletAniReplica 1-3073")
                if animNode:getParent() then
                    WZLog("BattleMsgPlayerShoot:_removeBulletAniReplica 2-3073")
                    animNode:removeFromParentAndCleanup(true)
                end
                nBulletAniReplica = nil
            end
            g_nCollisionIndex = 2
        end))
        hero:getSkinBigSkillAnimation():getAnimNode():runAction(CCSequence:create(array))
    end
end

--@brief    皮肤大招:不死金乌
function BattleMsgPlayerShoot:showSkinBigSkillAction3036(bullet)
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
    local heroPos = hero:getPosition()
    local bulletPt = bullet:getPosition()
    --人物朝向
    local bFacingLeft = true   --是否朝向左边
    if bulletPt.x - heroPos.x >= 0 then
        bFacingLeft = false
    end
    hero:getSkinBigSkillAnimation():getAnimNode():setFlipX(bFacingLeft)
    --创建武器动画
    local skinBigSkill = bullet.m_ownerChara:getSkinBigSkill()
    local tempShapeData = WBattleGlobal:getCurrent():getSkinBigSkillShape(skinBigSkill)
    local name = "boss_"..tempShapeData.bullet.."_attack2"
    self.m_nBulletAniReplica = BattleAnimation:createAnimation(name,false)
    self.m_nBulletAniReplica:getAnimNode():setScale(1)
    self.m_nBulletAniReplica:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    self.m_nBulletAniReplica:getAnimNode():setUseAbsCoordinate(true)
    self.m_nBulletAniReplica:getAnimNode():setAbsPosition(ccp(heroPos.x, heroPos.y+200))
    self.m_nBulletAniReplica:getAnimNode():setAnimationName("attack_2")
    self.m_nBulletAniReplica:getAnimNode():setLoop(false)
    SceneBattle:getFrontLayer():addChild(self.m_nBulletAniReplica:getAnimNode())

    --设置武器角度
    self.m_nReplicaLastPt = self.m_nBulletAniReplica:getAnimNode():getRelativePosition() --前一个坐标

    --计算曲线控制点偏移
    local nOffset = 100
    local nGo1x,nGo1y = 0,0
    local nGo2x,nGo2y = 0,0
    local nBack1x,nBack1y = 0,0
    local nBack2x,nBack2y = 0,0
    local tPoint = BattleCommon:pointSub(bulletPt,heroPos)
    local pointList = BattleMsgPlayerShoot:getPerpendicularVector(tPoint)
    if tPoint.x == 0 and tPoint.y == 0 then
        nGo1x = 0
        nGo1y = 0
        nGo2x = 0
        nGo2y = 0
        nBack1x = 0
        nBack1y = 0
        nBack2x = 0
        nBack2y = 0
    elseif tPoint.x ~= 0 and tPoint.y == 0 then
        nGo1x = 0
        nGo1y = -nOffset
        nGo2x = 0
        nGo2y = -nOffset
        nBack1x = 0
        nBack1y = nOffset
        nBack2x = 0
        nBack2y = nOffset
    elseif tPoint.x == 0 and tPoint.y ~= 0 then
        nGo1x = bFacingLeft and -nOffset or nOffset
        nGo1y = 0
        nGo2x = bFacingLeft and -nOffset or nOffset
        nGo2y = 0
        nBack1x = bFacingLeft and nOffset or -nOffset
        nBack1y = 0
        nBack2x = bFacingLeft and nOffset or -nOffset
        nBack2y = 0
    elseif tPoint.x > 0 and tPoint.y > 0 or tPoint.x < 0 and tPoint.y < 0 then
        for i=1,#pointList do
            if pointList[i].x > 0 and pointList[i].y < 0 then
                nGo1x = pointList[i].x * nOffset
                nGo1y = pointList[i].y * nOffset
                nGo2x = pointList[i].x * nOffset
                nGo2y = pointList[i].y * nOffset
            elseif pointList[i].x < 0 and pointList[i].y > 0 then
                nBack1x = pointList[i].x * nOffset
                nBack1y = pointList[i].y * nOffset
                nBack2x = pointList[i].x * nOffset
                nBack2y = pointList[i].y * nOffset
            end
        end
    elseif tPoint.x < 0 and tPoint.y > 0 or tPoint.x > 0 and tPoint.y < 0 then
        for i=1,#pointList do
            if pointList[i].x < 0 and pointList[i].y < 0 then
                nGo1x = pointList[i].x * nOffset
                nGo1y = pointList[i].y * nOffset
                nGo2x = pointList[i].x * nOffset
                nGo2y = pointList[i].y * nOffset
            elseif pointList[i].x > 0 and pointList[i].y > 0 then
                nBack1x = pointList[i].x * nOffset
                nBack1y = pointList[i].y * nOffset
                nBack2x = pointList[i].x * nOffset
                nBack2y = pointList[i].y * nOffset
            end
        end
    end

    --开始动作
    local arrayAni = CCArray:create()

    --武器翻转
    arrayAni:addObject(CCCallFunc:create(function()
        if self.m_nBulletAniReplica and self.m_nBulletAniReplica:getAnimNode() and self.m_nBulletAniReplica:getAnimNode():getParent() then
            if heroPos.x > bulletPt.x then
                self.m_nBulletAniReplica:getAnimNode():setFlipY(true)
            else
                self.m_nBulletAniReplica:getAnimNode():setFlipY(false)
            end
        end
    end))

    --武器飞出去
    local configInfo = ccBezierConfig()
    configInfo.endPosition = GlobalMethod:ccp(bulletPt.x,bulletPt.y)
    configInfo.controlPoint_1 = GlobalMethod:ccp(heroPos.x+nGo1x,heroPos.y+nGo1y)
    configInfo.controlPoint_2 = GlobalMethod:ccp(bulletPt.x+nGo2x,bulletPt.y+nGo2y)
    local moveTo1 = CCBezierTo:create(0.5, configInfo)
    arrayAni:addObject(moveTo1)

    --爆炸
    arrayAni:addObject(CCCallFunc:create(function()
        g_nCollisionIndex = 2
    end))

    --武器翻转
    arrayAni:addObject(CCCallFunc:create(function()
        if self.m_nBulletAniReplica and self.m_nBulletAniReplica:getAnimNode() and self.m_nBulletAniReplica:getAnimNode():getParent() then
            if heroPos.x > bulletPt.x then
                self.m_nBulletAniReplica:getAnimNode():setFlipY(false)
            else
                self.m_nBulletAniReplica:getAnimNode():setFlipY(true)
            end
        end
    end))

    --武器飞回来
    local configInfo = ccBezierConfig()
    configInfo.endPosition = GlobalMethod:ccp(heroPos.x,heroPos.y)
    configInfo.controlPoint_1 = GlobalMethod:ccp(bulletPt.x+nBack1x,bulletPt.y+nBack1y)
    configInfo.controlPoint_2 = GlobalMethod:ccp(heroPos.x+nBack2x,heroPos.y+nBack2y)
    local moveTo2 = CCBezierTo:create(0.5, configInfo)
    arrayAni:addObject(moveTo2)

    --移除武器动画
    arrayAni:addObject(CCCallFunc:create(function()
        if self.m_nBulletAniReplica and self.m_nBulletAniReplica:getAnimNode() and self.m_nBulletAniReplica:getAnimNode():getParent() then
            local animNode = self.m_nBulletAniReplica:getAnimNode()
            WZLog("BattleMsgPlayerShoot:_removeBulletAniReplica 1-3036")
            if animNode:getParent() then
                WZLog("BattleMsgPlayerShoot:_removeBulletAniReplica 2-3036")
                animNode:removeFromParentAndCleanup(true)
            end
            self.m_nReplicaLastPt = nil
            self.m_nBulletAniReplica = nil
        end
    end))

    local sequence = CCSequence:create(arrayAni)
    self.m_nBulletAniReplica:getAnimNode():runAction(sequence)
end

--@brief    皮肤大招:般若
function BattleMsgPlayerShoot:showSkinBigSkillAction3043(bullet)
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
    local heroPos = hero:getPosition()
    local bulletPt = bullet:getPosition()
    local array = CCArray:create()
    local bFacingLeft = true   --是否朝向左边
    local OffsetX = 250
    if bulletPt.x - heroPos.x >= 0 then
        bFacingLeft = false
        OffsetX = -250
    end
    hero:getSkinBigSkillAnimation():getAnimNode():setFlipX(bFacingLeft)

    local skinBigSkill = bullet.m_ownerChara:getSkinBigSkill()
    local tempShapeData = WBattleGlobal:getCurrent():getSkinBigSkillShape(skinBigSkill)
    local name = "boss_"..tempShapeData.bullet
    self.m_nBulletAniReplica = BattleAnimation:createAnimation(name,false)
    self.m_nBulletAniReplica:getAnimNode():setFlipX(bFacingLeft)
    self.m_nBulletAniReplica:getAnimNode():setScale(1)
    self.m_nBulletAniReplica:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    self.m_nBulletAniReplica:getAnimNode():setUseAbsCoordinate(true)
    self.m_nBulletAniReplica:getAnimNode():setAbsPosition(ccp(bulletPt.x + OffsetX, bulletPt.y))
    SceneBattle:getFrontLayer():addChild(self.m_nBulletAniReplica:getAnimNode())

    bullet:getAnimation():getAnimNode():setVisible(false)

    array:addObject(CCCallFunc:create(function()
        self.m_nBulletAniReplica:play("attack_2", false)
    end))
    array:addObject(CCDelayTime:create(13/DEFAULT_FPS))
    array:addObject(CCCallFunc:create(function()
        g_nCollisionIndex = 2
    end))
    array:addObject(CCCallFunc:create(function()
        self.m_nBulletAniReplica:play("attack_3", false)
    end))
    array:addObject(CCDelayTime:create(10/DEFAULT_FPS))
    array:addObject(CCCallFunc:create(function()
        self.m_nBulletAniReplica:getAnimNode():setVisible(false)
    end))
    array:addObject(CCCallFunc:create(function()
        if self.m_nBulletAniReplica and self.m_nBulletAniReplica:getAnimNode() and self.m_nBulletAniReplica:getAnimNode():getParent() then
            local animNode = self.m_nBulletAniReplica:getAnimNode()
            WZLog("BattleMsgPlayerShoot:_removeBulletAniReplica 1-3043")
            if animNode:getParent() then
                WZLog("BattleMsgPlayerShoot:_removeBulletAniReplica 2-3043")
                animNode:removeFromParentAndCleanup(true)
            end
            self.m_nBulletAniReplica = nil
        end
    end))
    self.m_nBulletAniReplica:getAnimNode():runAction(CCSequence:create(array))
end

--@brief    获得垂直于tPoint的单位向量列表
function BattleMsgPlayerShoot:getPerpendicularVector(tPoint)
    local tPointList = {}
    if tPoint.x == 0 and tPoint.y == 0 then
    elseif tPoint.y == 0 then
        table.insert(tPointList,BattleCommon:getPointTable(0,1))
        table.insert(tPointList,BattleCommon:getPointTable(0,-1))
    else
        local tempPointX = 1 --随机的值
        local pointLen,newPoint = BattleCommon:vectorNormalize(BattleCommon:getPointTable(tempPointX,(-tPoint.x*tempPointX/tPoint.y)))
        table.insert(tPointList,newPoint)
        table.insert(tPointList,BattleCommon:pointMult(newPoint,-1))
    end
    return tPointList
end

--@brief    调整子弹角度
function BattleMsgPlayerShoot:_adjustReplicaSchedule()
    if self.m_nReplicaLastPt and self.m_nBulletAniReplica and self.m_nBulletAniReplica:getAnimNode() and self.m_nBulletAniReplica:getAnimNode():getParent() then
        local animNode = self.m_nBulletAniReplica:getAnimNode()
        local tPoint1 = animNode:getRelativePosition()
        local tPoint2 = self.m_nReplicaLastPt
        local radian = BattleCommon:pointToAngle(BattleCommon:pointSub(tPoint1,tPoint2))
        local angle = radian * 180 / math.pi
        animNode:setRotation(-angle)
        self.m_nReplicaLastPt = animNode:getRelativePosition()
    end
end

--@brief    净空法师皮肤大招创建子弹动画
function BattleMsgPlayerShoot:creatSkinBulletAni1109(bullet)
    local nAttackTime = 0.25 --攻击持续时间
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
    local nStartX, nStartY = hero:getPosition().x ,hero:getPosition().y
    local nEndX, nEndY = bullet:getPosition().x, bullet:getPosition().y
    -- 计算出最后一个弹坑位置
    local digHoleX = bullet.m_mover:getMoverPosition().x
    local digHoleY = bullet.m_mover:getMoverPosition().y
    local _, tSpeed = BattleCommon:vectorNormalize(bullet.m_tStartSpeed)
    nEndX = digHoleX + tSpeed.x*BattleConstants.g_fWB_CONTINUE_DIGHOLE_DIS * 7
    nEndY = digHoleY + tSpeed.y*BattleConstants.g_fWB_CONTINUE_DIGHOLE_DIS * 7

    local angle = BattleCommon:pointToAngle({x=nStartX-nEndX,y=nStartY-nEndY})
    local degress = -1*BattleCommon:radiansToDegress(angle)
    local skinBigSkill = bullet.m_ownerChara:getSkinBigSkill()
    local tempShapeData = WBattleGlobal:getCurrent():getSkinBigSkillShape(skinBigSkill)
    local name = "boss_"..tempShapeData.bullet.."_attack2"
    self.m_nBulletAniReplica = BattleAnimation:createAnimation(name,false)
    self.m_nBulletAniReplica:getAnimNode():setScale(1)
    self.m_nBulletAniReplica:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    self.m_nBulletAniReplica:getAnimNode():setUseAbsCoordinate(true)
    self.m_nBulletAniReplica:getAnimNode():setAbsPosition(ccp(nStartX, nStartY))
    self.m_nBulletAniReplica:getAnimNode():setAnimationName("attack_2")
    self.m_nBulletAniReplica:getAnimNode():setLoop(true)
    SceneBattle:getFrontLayer():addChild(self.m_nBulletAniReplica:getAnimNode())

    self.m_nBulletAniReplica:setRotate(degress)
    if nStartX - nEndX > 0 then
        self.m_nBulletAniReplica:getAnimNode():setFlipX(true)
        self.m_nBulletAniReplica:getAnimNode():setFlipY(false)
    else
        self.m_nBulletAniReplica:getAnimNode():setFlipX(true)
        self.m_nBulletAniReplica:getAnimNode():setFlipY(true)
    end

    local array = CCArray:create()
    local move = CCMoveTo:create(nAttackTime, GlobalMethod:ccp(nEndX, nEndY))
    local callfunc = CCCallFunc:create(function ()
        if self.m_nBulletAniReplica and self.m_nBulletAniReplica:getAnimNode() and self.m_nBulletAniReplica:getAnimNode():getParent() then
            -- if self.m_nBulletAniReplica:isCurrentAnimationDone() then
                local animNode = self.m_nBulletAniReplica:getAnimNode()
                WZLog("BattleMsgPlayerShoot:_removeBulletAniReplica 1")
                if animNode:getParent() then
                    WZLog("BattleMsgPlayerShoot:_removeBulletAniReplica 2")
                    animNode:removeFromParentAndCleanup(true)
                end
                self.m_nBulletAniReplica = nil
            -- end
        end

        g_nCollisionIndex = 2
    end)
    array:addObject(move)
    array:addObject(callfunc)
    self.m_nBulletAniReplica:getAnimNode():runAction(CCSequence:create(array))
end

--@brief    暗黑元素皮肤大招创建子弹动画
function BattleMsgPlayerShoot:creatSkinBulletAni(bullet)
    local nAttackTime = 0.25 --攻击持续时间
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
    local nStartX, nStartY = hero:getPosition().x ,hero:getPosition().y + 450
    local nEndX, nEndY = bullet:getPosition().x, bullet:getPosition().y
    local angle = BattleCommon:pointToAngle({x=nStartX-nEndX,y=nStartY-nEndY})
    local degress = -1*BattleCommon:radiansToDegress(angle)
    local skinBigSkill = bullet.m_ownerChara:getSkinBigSkill()
    local tempShapeData = WBattleGlobal:getCurrent():getSkinBigSkillShape(skinBigSkill)
    local name = "boss_bullet_"..tempShapeData.bullet

    self.m_nBulletAniReplica = BattleAnimation:createAnimation(name,true)
    local weaponType = tempShapeData.bullet_prefix
    if weaponType == 1 then
        self.m_nBulletAniReplica:getAnimNode():setFlipX(true)
    elseif weaponType == 2 then
        self.m_nBulletAniReplica:getAnimNode():setFlipX(true)
    end
    if nEndX - nStartX > 0 then --判断朝向
        self.m_nBulletAniReplica:getAnimNode():setFlipY(true)
    else
        self.m_nBulletAniReplica:getAnimNode():setFlipY(false)
    end
    self.m_nBulletAniReplica:getAnimNode():setScale(4.1)
    self.m_nBulletAniReplica:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    self.m_nBulletAniReplica:getAnimNode():setUseAbsCoordinate(true)
    self.m_nBulletAniReplica:getAnimNode():setAbsPosition(ccp(nStartX, nStartY))
    SceneBattle:getFrontLayer():addChild(self.m_nBulletAniReplica:getAnimNode())

    self.m_nBulletAniReplica:setRotate(degress)
    self.m_nBulletAniReplica:play("0",true)

    local array = CCArray:create()
    local move = CCMoveTo:create(nAttackTime, GlobalMethod:ccp(nEndX, nEndY))
    local callfunc = CCCallFunc:create(function ()
        if self.m_nBulletAniReplica and self.m_nBulletAniReplica:getAnimNode() and self.m_nBulletAniReplica:getAnimNode():getParent() then
            -- if self.m_nBulletAniReplica:isCurrentAnimationDone() then
                local animNode = self.m_nBulletAniReplica:getAnimNode()
                WZLog("BattleMsgPlayerShoot:_removeBulletAniReplica 1")
                if animNode:getParent() then
                    WZLog("BattleMsgPlayerShoot:_removeBulletAniReplica 2")
                    animNode:removeFromParentAndCleanup(true)
                end
                self.m_nBulletAniReplica = nil
            -- end
        end

        g_nCollisionIndex = 2
    end)
    array:addObject(move)
    array:addObject(callfunc)
    self.m_nBulletAniReplica:getAnimNode():runAction(CCSequence:create(array))
end

--@brief    斩鬼之雷
function stopSkinSlipAttack()
    -- body
    WZLog("stopSkinSlipAttack")
    local hero = WBattleGlobal:getCurrent():getCurrentHero()
    hero:getSkinBigSkillAnimation():getAnimNode():setVisible(false)
    
    g_nCollisionIndex = 2
end
--@brief    布里茨/安娜露皮肤大招
function stopSkinSlipAttackTwo()
    -- body
    WZLog("stopSkinSlipAttack")
    local hero = WBattleGlobal:getCurrent():getCurrentHero()
    hero:getSkinBigSkillAnimation():play("attack_2", false)
end

--@brief    一些皮肤大招需创建分身近身攻击
function BattleMsgPlayerShoot:_createSubRoleToAttack()
    -- body
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
    local tTarget = WBattleGlobal:getCurrent():getSomeSkinBigSkillTarget(hero)
    local skinBigSkill = hero:getSkinBigSkill()
    local tempShapeData = WBattleGlobal:getCurrent():getSkinBigSkillShape(skinBigSkill)
    local bValue = hero:getAnimation():isFlipX()
    if self.m_tSubRoleElement == nil then 
        self.m_tSubRoleElement = {}
        self.m_nSubRollAttackIndex = 0 
        self.m_nWaitFrameNum = 15   --等待的帧数
        if tempShapeData.id == 1131 then 
            local strAnimation = tempShapeData.animation .. "_attack_2"
            local subRoleElement = BattleAnimation:createAnimation(strAnimation, false)
            subRoleElement:getAnimNode():setUseAbsCoordinate(true)
            subRoleElement:getAnimNode():setScale(0.8)
            subRoleElement:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0.5))

            subRoleElement:getAnimNode():setAbsPosition(GlobalMethod:ccp(self.m_nEndX - 50, self.m_nEndY))
            local strAnimationName = "boss_0134_attack"
            subRoleElement:getAnimNode():setAnimationName(strAnimationName)
            subRoleElement:getAnimNode():setLoop(false)
            SceneBattle:getFrontLayer():addChild(subRoleElement:getAnimNode())

            table.insert(self.m_tSubRoleElement, subRoleElement)
            return false 
        elseif tempShapeData.id == 1136 then 
            local strAnimation = tempShapeData.animation .. "_attack02"
            local subRoleElement = BattleAnimation:createAnimation(strAnimation, false)
            subRoleElement:getAnimNode():setUseAbsCoordinate(true)
            subRoleElement:getAnimNode():setScale(0.8)
            subRoleElement:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0.5))

            subRoleElement:getAnimNode():setAbsPosition(GlobalMethod:ccp(self.m_nEndX, self.m_nEndY - 130))
            local strAnimationName = "attack"
            subRoleElement:getAnimNode():setAnimationName(strAnimationName)
            subRoleElement:getAnimNode():setLoop(false)
            SceneBattle:getFrontLayer():addChild(subRoleElement:getAnimNode())

            table.insert(self.m_tSubRoleElement, subRoleElement)
            return false 
        elseif tempShapeData.id == 1137 then 
            self.m_nWaitFrameNum = 2   --等待的帧数
            local strAnimation = tempShapeData.animation .. "_attack3_3"
            local subRoleElement = BattleAnimation:createAnimation(strAnimation, false)
            subRoleElement:getAnimNode():setUseAbsCoordinate(true)
            subRoleElement:getAnimNode():setScale(0.4)
            subRoleElement:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0.5))

            subRoleElement:getAnimNode():setAbsPosition(GlobalMethod:ccp(self.m_nStartX, self.m_nStartY+180))
            local strAnimationName = "attack"
            subRoleElement:getAnimNode():setAnimationName(strAnimationName)
            subRoleElement:getAnimNode():setLoop(false)
            SceneBattle:getFrontLayer():addChild(subRoleElement:getAnimNode())

            table.insert(self.m_tSubRoleElement, subRoleElement)
            return false 
        end

        for i = 1, #tTarget do
            local strAnimation = tempShapeData.animation
            if tempShapeData.id == 1120 or tempShapeData.id == 1123 then
                strAnimation = tempShapeData.animation .. "_attack"
            elseif tempShapeData.id == 1132 then
                strAnimation = tempShapeData.animation .. "_attack02"
            end
            local subRoleElement = BattleAnimation:createAnimation(strAnimation, false)
            subRoleElement:getAnimNode():setUseAbsCoordinate(true)
            subRoleElement:getAnimNode():setScale(0.8)
            subRoleElement:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0))
            local tPos = tTarget[i]:getPosition()
            if bValue then 
                if tempShapeData.id == 1081 then 
                    subRoleElement:getAnimNode():setAbsPosition(GlobalMethod:ccp(tPos.x + 150,tPos.y - 50))
                elseif tempShapeData.id == 1115 then 
                    subRoleElement:getAnimNode():setAbsPosition(GlobalMethod:ccp(tPos.x + 600,tPos.y))
                elseif tempShapeData.id == 1123 then 
                    subRoleElement:getAnimNode():setAbsPosition(GlobalMethod:ccp(tPos.x + 10, tPos.y + 150))
                elseif tempShapeData.id == 1132 then 
                    subRoleElement:getAnimNode():setAbsPosition(GlobalMethod:ccp(tPos.x + 130, tPos.y + 30))
                else
                    subRoleElement:getAnimNode():setAbsPosition(GlobalMethod:ccp(tPos.x + 20,tPos.y + 0))
                end
            else
                if tempShapeData.id == 1081 then 
                    subRoleElement:getAnimNode():setAbsPosition(GlobalMethod:ccp(tPos.x - 150,tPos.y - 50))
                elseif tempShapeData.id == 1115 then 
                    subRoleElement:getAnimNode():setAbsPosition(GlobalMethod:ccp(tPos.x - 600,tPos.y))
                elseif tempShapeData.id == 1123 then 
                    subRoleElement:getAnimNode():setAbsPosition(GlobalMethod:ccp(tPos.x - 10, tPos.y + 150))
                elseif tempShapeData.id == 1132 then 
                    subRoleElement:getAnimNode():setAbsPosition(GlobalMethod:ccp(tPos.x - 130, tPos.y + 30))
                else
                    subRoleElement:getAnimNode():setAbsPosition(GlobalMethod:ccp(tPos.x - 20,tPos.y + 0))
                end
            end
            
            subRoleElement:getAnimNode():setFlipX(bValue)
            local strAnimationName = "attack"
            if tempShapeData.id == 1115 then
                strAnimationName = "attack_4"
            elseif tempShapeData.id == 1120 then
                strAnimationName = "attack_2"
            elseif tempShapeData.id == 1123 then
                strAnimationName = "wait_2"
                subRoleElement:getAnimNode():setScale(1.5)
            elseif tempShapeData.id == 1132 then
                strAnimationName = "shoot_1"
                self.m_nWaitFrameNum = 20
            end
            subRoleElement:getAnimNode():setAnimationName(strAnimationName)
            subRoleElement:getAnimNode():setLoop(false)
            SceneBattle:getFrontLayer():addChild(subRoleElement:getAnimNode())

            table.insert(self.m_tSubRoleElement, subRoleElement)
        end

        return false 
    else
        if self.m_nSubRollAttackIndex > self.m_nWaitFrameNum then 
            return true 
        else
            self.m_nSubRollAttackIndex = self.m_nSubRollAttackIndex + 1
            return false 
        end
    end
end

--@brief    一些皮肤大招需创建分身近身攻击2
function BattleMsgPlayerShoot:_createSubRoleToAttack2()
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
    local tTarget = WBattleGlobal:getCurrent():getSomeSkinBigSkillTarget(hero)
    local skinBigSkill = hero:getSkinBigSkill()
    local tempShapeData = WBattleGlobal:getCurrent():getSkinBigSkillShape(skinBigSkill)
    local bValue = hero:getAnimation():isFlipX()
    if self.m_tSubRoleElement == nil then 
        self.m_tSubRoleElement = {}
        self.m_nSubRollAttackIndex = 0 

        for i = 1, #tTarget do
            local subRoleElement = BattleAnimation:createAnimation(tempShapeData.animation, false)
            subRoleElement:getAnimNode():setUseAbsCoordinate(true)
            subRoleElement:getAnimNode():setScale(0.8)
            subRoleElement:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0))
            local tPos = tTarget[i]:getPosition()
            if bValue then 
                if tempShapeData.id == 1115 then 
                    subRoleElement:getAnimNode():setAbsPosition(GlobalMethod:ccp(tPos.x + 600,tPos.y))
                else
                    subRoleElement:getAnimNode():setAbsPosition(GlobalMethod:ccp(tPos.x + 20,tPos.y + 0))
                end
            else
                if tempShapeData.id == 1115 then 
                    subRoleElement:getAnimNode():setAbsPosition(GlobalMethod:ccp(tPos.x - 600,tPos.y))
                else
                    subRoleElement:getAnimNode():setAbsPosition(GlobalMethod:ccp(tPos.x - 20,tPos.y + 0))
                end
            end
            subRoleElement:getAnimNode():setAnimationName(strAnimationName)
            subRoleElement:getAnimNode():setLoop(false)
            SceneBattle:getFrontLayer():addChild(subRoleElement:getAnimNode())

            table.insert(self.m_tSubRoleElement, subRoleElement)
        end

        return false 
    else
        if self.m_nSubRollAttackIndex > 15 then 
            return true 
        else
            self.m_nSubRollAttackIndex = self.m_nSubRollAttackIndex + 1
            return false 
        end
    end
end

--@brief    移除创建的分身
function BattleMsgPlayerShoot:removeSubRoleElement()
    WZLog("BattleMsgPlayerShoot:removeSubRoleElement 1")
    if self.m_tSubRoleElement == nil or #self.m_tSubRoleElement == 0 then return end 
    for i = 1, #self.m_tSubRoleElement do
        local subRole = self.m_tSubRoleElement[i]
        if subRole and subRole:getAnimNode():getParent() then

            -- 某些皮肤大招动画无法判断isCurrentAnimationDone,比如1120皮肤boss_0122_attack动画attack2动作,直接移除
            local tempShapeId = nil
            local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
            if hero and hero:getUseBigSkill() then
                if self.m_bIsUseSkinBigSkill then
                    local skinBigSkill = hero:getSkinBigSkill()
                    local tempShapeData = WBattleGlobal:getCurrent():getSkinBigSkillShape(skinBigSkill)
                    if tempShapeData.id then
                        tempShapeId = tempShapeData.id
                    end
                end
            end

            if subRole:isCurrentAnimationDone() or tempShapeId == 1120 then
                local animNode
                animNode = subRole:getAnimNode()
                WZLog("BattleMsgPlayerShoot:removeSubRoleElement 2")
                if animNode:getParent() then
                    WZLog("BattleMsgPlayerShoot:removeSubRoleElement 3")
                    animNode:removeFromParentAndCleanup(true)
                end
                self.m_tSubRoleElement[i] = nil
            end
        end
    end
end

--@brief    检测是否存在表演信息
function BattleMsgPlayerShoot:_checkHaveShowMsg()
    -- body
    if MsgManager:isInShowNonBlockMsg() then 
        return false 
    end

    return true 
end

--@brief    屏幕移向英雄,拉倒最大
function BattleMsgPlayerShoot:_zoomToHeroMax()
    if WBattleGlobal:getCurrent():isGameOver() then
        return true
    end
    
    WZLog("BattleMsgPlayerShoot:_zoomToHero one", WBattleGlobal:getCurrent().m_tGameOverHero and WBattleGlobal:getCurrent().m_tGameOverHero:getBattleId())
    WZLog("BattleMsgPlayerShoot:_zoomToHero m_bIsPetShoot",self.m_bIsPetShoot)
    WBattleGlobal:getCurrent().m_bIsZoomToHero = true
    WBattleGlobal:getCurrent():setShowGameOver(true)

    local hero, scale, speed
    if WBattleGlobal:getCurrent().m_bIsGameOverTimer ~= true then
        hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
        if self.m_bIsUseSkinBigSkill then 
            scale = 1
            speed = 1
        end
    else
        hero = WBattleGlobal:getCurrent().m_tGameOverHero
        scale = 1.2
        speed = 1
        WZLog("BattleMsgPlayerShoot:_zoomToHero two")
    end
    
    if self.m_bIsPetShoot ~= nil and self.m_bIsPetShoot == true then 
        WBattleGlobal:getCurrent().m_bIsZoomToHero = false
        return true
    end
    
    if hero ~= nil then
        return BattleScreen:zoomToHero(hero:getBattleId(), hero:getMover():getMoverPosition(), nil, scale, speed)
    else
        return true
    end
end

--@brief    皮肤近身攻击后，显示形象
function BattleMsgPlayerShoot:_showHero()
    -- body
    WZLog("BattleMsgPlayerShoot:_showHero")
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)

    return hero:_showHero()
end

--@brief    发送玩家出手的事件
function BattleMsgPlayerShoot:_postPlayerShootEvent()
    -- body
    if not WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_SINGLE) then return end 
    local myHero = WBattleGlobal:getCurrent():getMyHero()
    if self.m_nCurrentPlayerId ~= myHero:getBattleId() then return end 

    local mapId = WBattleGlobal:getCurrent().m_tMakePairOk.mapId
    if mapId == 10102 then 
        PostPlayerEvent:postEvent(PostPlayerEvent.event_oneLvPlayerShoot)
    elseif mapId == 10103 then 
        PostPlayerEvent:postEvent(PostPlayerEvent.event_twoLvPlayerShoot)
    end
end

--@brief    检查是否有触发宠物反击
function BattleMsgPlayerShoot:checkIsHavePetBeatBack()
    -- body
    --199针对放逐添加的逻辑，等玩家添加完buff再检查宠物攻击和反击
    if MsgManager:isInShowNonBlockMsg("BattleMsgBossMapSkill") then 
        return false 
    end
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
    if hero == nil then return end 

    if hero.m_tPetBeatBackMsgList then 
        for i = 1, #hero.m_tPetBeatBackMsgList do
            local tempMsgData = hero.m_tPetBeatBackMsgList[i]
            --宠物反击条件：要反击的玩家没死&玩家没有被放逐&被反击的玩家也没有被放逐
            if not tempMsgData.shootHero:isDead() and not tempMsgData.shootHero:isInBuffState(EffectTypeConfig.IMMUNITY_ATTACK) and not tempMsgData.beShootedChara:isInBuffState(EffectTypeConfig.IMMUNITY_ATTACK) and (not tempMsgData.shootHero:isPetSeal() or tempMsgData.shootHero:isInIngoreBuff(BuffType.PETSEAL)) and tempMsgData.shootHero.m_nRunPetBeatBackTimes <= 0 then 
                local pos = tempMsgData.shootHero:getAnimation():getPosition()
                BattlePetSkillManager:createImage(tempMsgData.skillName, tempMsgData.skillIcon, nil, BattleCommon:getPointTable(pos.x,pos.y + 85), 2)
                tempMsgData.shootHero.m_nRunPetBeatBackTimes = tempMsgData.shootHero.m_nRunPetBeatBackTimes + 1

                local msg = MsgManager:createMsg(BattleMsgPetBeatbackShoot)
                msg.m_shootHero = tempMsgData.shootHero
                msg.m_beShootedChara = tempMsgData.beShootedChara
                msg.m_bIsReplayMsg = true
                MsgManager:pushNonBlockMsg(msg)
            end
        end
    end

    return true
end

--@brief    获取 天野美美 皮肤大招 子弹的出生点和速度
function BattleMsgPlayerShoot:getSkinBigSkillBulletPos()
    -- body
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
    local nScatterNum = hero:getAttScatterNum()
    self.m_tBulletStartPos = {}

    local fSize = SceneBattle:getFrontLayer():getContentSize()
    local randomList = WBattleGlobal:getCurrent().m_tBattleRand
    for i = 1, nScatterNum do
        local tPos = {}
        if i <= 10 then 
            tPos.x = randomList[i] % fSize.width 
            tPos.y = fSize.height + randomList[i] % 700
            tPos.speedY = BattleConstants.g_nFlyGravity.y - (randomList[i] % 8)
        else
            local random = randomList[math.floor(i/10)] + randomList[i%10 + 1]
            tPos.x = random % fSize.width
            tPos.y = fSize.height + random % 700
            tPos.speedY = BattleConstants.g_nFlyGravity.y - (random % 8)
        end
        tPos.speedX = 0

        table.insert(self.m_tBulletStartPos, tPos)
    end

    return true 
end

--@brief    播放准备射击动画
function BattleMsgPlayerShoot:_showShoot()
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)

    WZLog("BattleMsgPlayerShoot:_showShoot 0:", hero:getAttTimes(), self.m_nAttackedCount)
    self.m_nShootDeltaTime = self.m_nShootDeltaTime + 1

    local isCanRepeatShoot = false

    --是否能跳转到射击子弹
    if self.m_nReadyToShootDeltaTime ~= 0 and self.m_nShootDeltaTime >= self.m_nReadyToShootDeltaTime * 30 then
        WZLog("BattleMsgPlayerShoot:_showShoot 1:", self.m_nShootDeltaTime)
        isCanRepeatShoot = true
    elseif hero:getAnimation():isCurrentAnimationDone() == true or hero:getAnimation():isPlaying(hero:getActionName(23)) then
        WZLog("BattleMsgPlayerShoot:_showShoot 2:", self.m_nShootDeltaTime)
        isCanRepeatShoot = true
    end

    if isCanRepeatShoot then
        self.m_nTimeRemain = 0
        hero:setRunStatus(RunStatus.DEF_ST_REPEAT_SHOOT)
        self.m_nAttackedCount = self.m_nAttackedCount and self.m_nAttackedCount + 1 or 1
        WZLog("BattleMsgPlayerShoot:_showShoot 3:", hero:getAttTimes(), self.m_nAttackedCount)

        if hero:getAttTimes()-self.m_nAttackedCount >= 0 then
            WZLog("BattleMsgPlayerShoot:_showShoot three", hero:getAttTimes())
            WBattleGlobal:getCurrent().m_nAttackedCount = hero:getAttTimes()
            hero:getSkinBigSkillAnimation():play("attack_2", false)
        end
        return true
    else
        hero:setRunStatus(RunStatus.DEF_ST_READY_SHOOT)
        return false
    end
end

--@brief    播放准备射击动画
function BattleMsgPlayerShoot:_finishShoot()
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)

    WZLog("BattleMsgPlayerShoot:_finishShoot 0:", hero:getAttTimes(), self.m_nAttackedCount)

    if hero:getAnimation():isCurrentAnimationDone() == true then
        return true
    else
        return false
    end
end

--@brief    创建皮肤大招动画
function BattleMsgPlayerShoot:_showSkinBigSkillNew()
    --BattlePlayerBigSkillAnim:readyShow(WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId))
    WZLog("BattleMsgPlayerShoot:_showSkinBigSkillNew zero", self.m_nBigSkillState, self.m_nCurTimerScale)
    CCDirector:sharedDirector():getScheduler():setTimeScale(0.7)
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
    if  self.m_nBigSkillState % 2 == 0 and self.m_tBigSkillAnim1 and self.m_tBigSkillAnim1:isCurrentAnimationDone() == true then
        self.m_nBigSkillState = self.m_nBigSkillState + 1
        self.m_tBigSkillAnim1:getAnimNode():removeFromParentAndCleanup(true)
        self.m_tBigSkillAnim1 = nil
        if self.m_tBigSkillAnim2 then
            self.m_tBigSkillAnim2:getAnimNode():removeFromParentAndCleanup(true)
            self.m_tBigSkillAnim2 = nil
        end
    end

    if self.m_nBigSkillState == 1 then
        WZLog("BattleMsgPlayerShoot:_showSkinBigSkillNew one",self.m_nBigSkillState)
        self.m_nBigSkillState = 2

        if hero.m_nBoyOrGirl == 0 then
            SoundManager:playEffectSound(getSoundByType(12))
        else
            SoundManager:playEffectSound(getSoundByType(7))
        end

        local myHero = WBattleGlobal:getCurrent():getMyHero()
        if self.m_nCurrentPlayerId ~= myHero:getBattleId() then
            if hero.m_bIsSetBigGun == nil then
                hero.m_bIsSetBigGun = true
            end

            local speedX,speedY = self.m_nSpeedx, self.m_nSpeedy
            local angle = BattleCommon:pointToAngle(BattleCommon:getPointTable(speedX,speedY)) * -10
            if speedX < 0 then
                angle = BattleCommon:pointToAngle(BattleCommon:getPointTable(-speedX,speedY)) * 10
            end
        end

        local scene = WndBattleHud
        GetElement(SceneBattle.m_root,"conBigSkill2_SceneBattle",WZUIContainer):setVisible(true)
        local conBigSkill4 = GetElement(scene.m_root,"conBigSkill4_SceneBattle",WZUIContainer)
        GetElement(scene.m_root,"conBigSkill2Back_WndBattleHud",WZUIContainer):setVisible(true)
        GetElement(scene.m_root,"imgBigSkill2Back_WndBattleHud",WZUIImage):setVisible(true)

        SoundManager:playEffectSound(SoundDefine.E_S_BIGSKILL)
        
        local anim = BattleAnimation:createAnimation("skill_power_BG", false, "battle/ui")
        anim:getAnimNode():setAnimationName("nan")
        anim:getAnimNode():setLoop(false)
        conBigSkill4:addChild(anim:getAnimNode(),0)
        anim:setScale(1)
        anim:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0))
        anim:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.5,0.5))
        self.m_tBigSkillAnim2 = anim

        local anim1 = BattleAnimation:createAnimation("skill_power_FG", false, "battle/ui")
        anim1:getAnimNode():setAnimationName("nan")
        anim1:getAnimNode():setLoop(false)
        SceneBattle:getBigSkillLayer():addChild(anim1:getAnimNode(),2)
        anim1:setScale(1)
        anim1:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0))
        anim1:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.703,0.5))
        self.m_tBigSkillAnim1 = anim1

        local tempShapeData = WBattleGlobal:getCurrent():getSkinBigSkillShape(self.m_nSkinBigSkillType)

        local bonePlayer = "player"
        local bonePlayerBig = "player2"
        local pathL = "battle/monster/" .. tempShapeData.animation
        
        local tmp2 = SkeletonAnimation:createWithFile(pathL .. ".json", pathL .. ".atlas", 1)
        anim:getAnimNode():bindSlot(bonePlayerBig, tmp2)
        if self.m_nSkinBigSkillType == 3006 then 
            tmp2:play("attack", false)
        elseif self.m_nSkinBigSkillType == 3038 then 
            tmp2:play("attack_loop", true)
        elseif self.m_nSkinBigSkillType == 3040 then 
            tmp2:play("wait", true)
        else
            tmp2:play("attack_1", false)
        end

        local tmp = SkeletonAnimation:createWithFile(pathL .. ".json", pathL .. ".atlas", 1)
        anim1:getAnimNode():bindSlot(bonePlayer, tmp)
        if self.m_nSkinBigSkillType == 3006 then 
            tmp:play("attack", false)
        elseif self.m_nSkinBigSkillType == 3012 or self.m_nSkinBigSkillType == 3013 or self.m_nSkinBigSkillType == 3014 or self.m_nSkinBigSkillType == 3015 then 
            tmp:play("attack_1", false)
        elseif self.m_nSkinBigSkillType == 3028 or self.m_nSkinBigSkillType == 3038 or self.m_nSkinBigSkillType == 3045 or self.m_nSkinBigSkillType == 3049 or self.m_nSkinBigSkillType == 3053 or self.m_nSkinBigSkillType == 3058 then 
            tmp:play("attack_loop", true)
        elseif self.m_nSkinBigSkillType == 3040 then 
            tmp:play("shoot_1", true)
        elseif self.m_nSkinBigSkillType == 3056 then 
            tmp:play("attack_3", false)
        else
            tmp:play("attack_2", false)
        end

        --创建皮肤大招名字
        local skillData = GDatatab_skill["id_" .. self.m_nSkinBigSkillType]
        if skillData and skillData.image ~= -1 then 
            local imgSkillName = createImage("ui/combat/" .. skillData.image .. ".png", GlobalMethod:ccp(-0.1, 0.2), nil, true)
            imgSkillName:setZOrder(1)
            imgSkillName:setFlipX(true)
            imgSkillName:setScale(0.5)
            tmp:addChild(imgSkillName)
        end


        WZLog("BattleMsgPlayerShoot:_showSkinBigSkillNew six", hero.m_nWeaponType)
          
        -- local scale = 1.7
        -- local x, y = 0.0, 0.3
        -- if self.m_nSkinBigSkillType == 3024 then 
        --     x, y = 0.0, 0
        -- end
        -- shopAnim:getAnimNode():setRelativePositionLuaTo(x, y)
        -- shopAnim:getAnimNode():setScaleX(scale * -1)
        -- shopAnim:getAnimNode():setScaleY(scale * 1)

        -- local act0=CCFadeTo:create(0,0)
        -- local array1 = CCArray:create()
        -- array1:addObject(CCFadeTo:create(0.33,255))
        -- array1:addObject(CCMoveBy:create(0.33,GlobalMethod:ccp(480,0)))
        -- local action = CCSpawn:create(array1)

        -- local act1=CCMoveBy:create(0.83,GlobalMethod:ccp(200,0))

        -- local array2 = CCArray:create()
        -- array2:addObject(CCFadeTo:create(0.12,10))
        -- array2:addObject(CCMoveBy:create(0.33,GlobalMethod:ccp(480,0)))
        -- local action1 = CCSpawn:create(array2)

        -- local array = CCArray:create()
        -- array:addObject(act0)
        -- array:addObject(action)
        -- array:addObject(act1)
        -- array:addObject(action1)
        -- array:addObject(CCCallFunc:create(function()
        --     shopAnim:getAnimNode():removeFromParentAndCleanup(false)
        -- end))
        -- shopAnim:getAnimNode():runAction(CCSequence:create(array))
    elseif self.m_nBigSkillState == 3 then
        WZLog("BattleMsgPlayerShoot:_showSkinBigSkillNew two",self.m_nBigSkillState)
        self.m_nBigSkillState = 5
    elseif self.m_nBigSkillState == 5 then
        WZLog("BattleMsgPlayerShoot:_showSkinBigSkillNew three",self.m_nBigSkillState)
        self.m_nBigSkillState = 7

        self.m_bCanFallDown = false
        hero:setMoveUpdatable(false)
    elseif self.m_nBigSkillState == 7 then
        WZLog("BattleMsgPlayerShoot:_showSkinBigSkillNew four",self.m_nBigSkillState)
        self.m_nBigSkillState = 8

        return true
    end

    return false
end

--@brief    恢复正常速度
function BattleMsgPlayerShoot:_resumeNormalTimer()
    -- body
    WZLog("BattleMsgPlayerShoot:_resumeNormalTimer", tostring(self.m_nCurTimerScale))
    if self.m_nCurTimerScale then 
        CCDirector:sharedDirector():getScheduler():setTimeScale(self.m_nCurTimerScale)
    else
        CCDirector:sharedDirector():getScheduler():setTimeScale(1)
    end

    return true 
end

--@brief    提前播放射击动画
function BattleMsgPlayerShoot:_prePlayShootAni()
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
    if self.m_nPlaySkinBigSKillAttackAni == 0 then 
        hero:playRepeatShootAnim(1) 
    end
    if self.m_nPlaySkinBigSKillAttackAni > 11 then 
        return true 
    end

    self.m_nPlaySkinBigSKillAttackAni = self.m_nPlaySkinBigSKillAttackAni + 1 
    return false 
end

--@brief    发送受伤协议
--@param    charas:英雄列表
--@param    values:伤害列表
--@param    distance:距离列表
--@param    superCritMark:超暴击状态
--@note     一发子弹一个玩家允许受多次伤害
function BattleMsgPlayerShoot:_sendHurtProtocolMul(charas, values, distance, critType, superCritMark)
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
    WZLog("BattleMsgPlayerShoot:_sendHurtProtocolMul one", tostring(charas), tostring(self.m_nCurrentPlayerId), tostring(hero:isCanControl()), tostring(hero.m_bLoseNet))
    if charas == nil or not (hero:isCanControl() or hero.m_bLoseNet) then
        return
    end

    WZLog("BattleMsgPlayerShoot:_sendHurtProtocolMul two",tostring(charas),tostring(values),tostring(distance),tostring(critType))
    WBattleGlobal:getCurrent():sendHurtProtocolMul(self.m_nCurrentPlayerId,charas,values,distance,critType, nil, nil, superCritMark)

    local tempCharas = {}
    local tempValues = {}
    local tempDistance = distance ~= nil and {} or nil 
    local tempCritType = critType ~= nil and {} or nil 

    for i = 1, BattleCommon:tableLen(charas) do
        local chara = charas[i]
        if values[i] ~= nil and values[i] > 0 then 
            --添加心魔伤害转移
            if chara:isInBuffState(EffectTypeConfig.HURT_TRANS) and chara:isDevilGuai() and hero:getBattleId() ~= chara:getDevilOwnId() then
                local devilOwnHero = WBattleGlobal:getCurrent():getCharacterWithId(chara:getDevilOwnId())
                if not devilOwnHero:isDead() then 
                    tempCharas[i] = devilOwnHero
                    tempValues[i] = values[i]
                    if distance and distance[i] then 
                        tempDistance[i] = distance[i]
                    end
                    if critType and critType[i] then 
                        tempCritType[i] = critType[i]
                    end
                end
            end
        end
    end

    if #tempCharas > 0 then 
        WBattleGlobal:getCurrent():sendHurtProtocolMul(self.m_nCurrentPlayerId,tempCharas,tempValues,tempDistance,tempCritType)
    end
end

--@brief 等待怪物id
function BattleMsgPlayerShoot:_waitMonsterId()
    if self.m_nSkinBigSkillType ~= 3065 then 
        if self.m_tSubRoleElement and #self.m_tSubRoleElement > 0 then 
            for i = 1, #self.m_tSubRoleElement do
                local subRole = self.m_tSubRoleElement[i]
                if subRole and subRole:getAnimNode():getParent() then
                    if subRole:isCurrentAnimationDone() then
                        local animNode
                        animNode = subRole:getAnimNode()
                        if animNode:getParent() then
                            animNode:removeFromParentAndCleanup(true)
                        end
                        self.m_tSubRoleElement[i] = nil
                    end
                end
            end
            return false 
        end
    end
    if WBattleGlobal:getCurrent():isSingleStage() then 
        return true
    end

    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
    if hero.guaiId == nil or #hero.guaiId == 0 then 
        WZLog("BattleMsgPlayerShoot:_waitMonsterId wait")
        return false
    end

    return true
end

--@brief    显示创建灵魂分身
function BattleMsgPlayerShoot:_buildSubSoul()
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
    hero.m_bActiveAttack = true
    local soulHeroConfig = hero:getSoulHeroConfig()
    if not soulHeroConfig then return false end 

    local skinBigSkill = hero:getSkinBigSkill()
    local tempShapeData = WBattleGlobal:getCurrent():getSkinBigSkillShape(skinBigSkill)
    for i = 1, soulHeroConfig.callNum do  
        local soulHeroBattleId = nil 
        if WBattleGlobal:getCurrent():isSingleStage() then 
            soulHeroBattleId = WBattleGlobal:getCurrent():getBuildGuaiBattleId(true)
        else
            soulHeroBattleId = hero.guaiBattleId[i]
        end
        local soulHero = WBattleGlobal:getCurrent():buildSoulHero(hero, soulHeroConfig.monsterIds[i], soulHeroBattleId, tempShapeData.id)
        soulHero:getAnimation():getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.4, 0.8)) 
        WZLog("BattleMsgPlayerShoot:_buildSubSoul", self.m_nEndX, self.m_nEndY)
        soulHero:getAnimation():setPosition(GlobalMethod:ccp(self.m_nEndX, self.m_nEndY))
        soulHero:getAnimation():play(soulHero:getActionName(23), true)
        SceneBattle:getFrontLayer():addChild(soulHero:getAnimation():getAnimNode())

        local playerName = BattleKidName:create(soulHero, SceneBattle:getInfoLayer(), true)
        soulHero:setPlayerNameIcon(playerName)
        playerName:update()
    end

    return true 
end

--@brief    处理花木兰皮肤大招
--@param    nSkinBigSkillType:皮肤大招技能
--@param    bullet:子弹
function BattleMsgPlayerShoot:dealWithBigSkinSkill(nSkinBigSkillType, bullet)
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
    local curPos = bullet:getMover():getMoverPosition()
    if nSkinBigSkillType == 3054 and bullet then  
        local prePos = bullet:getMover():getMoverPrePosition()
        if self.m_bIsTurnDir and curPos.y < self.m_nBulletEndY + bullet:getExplodeRadius()  then --位置矫正
            bullet:getMover():setMoverPosition(Vector2:create(curPos.x, self.m_nBulletEndY + bullet:getExplodeRadius()))
            g_nCollisionIndex = 2
        end
        bullet:DigHoleOnly()
        if curPos.y <= prePos.y and not self.m_bIsTurnDir then --子弹转向往下掉
            self.m_bIsTurnDir = true 
            bullet:getAnimation():setRotate(90)
            bullet:getMover():setMoverPosition(Vector2:create(self.m_nBulletEndX, curPos.y))
        end
        bullet:updatePosition()
        local isCollision, _ = bullet:checkCollision()
        if isCollision then
            isCollision = false
            local _,collisonChara = bullet:checkCharacterCollision()
            for j,chara in pairs(collisonChara) do
                local isExit = true
                if self.m_bIsTurnDir == false then 
                    for k,tv in pairs(self.m_tUpPenetrateList) do
                        if tv:getBattleId() == chara:getBattleId() then
                            isExit = false
                        end
                    end

                    if isExit then
                        local index = chara:getBattleId()
                        local hurt,hurtType, distance,recordRatio = WBullet:calculateHurt(0,bullet:getOwnerChara(),chara,nil)
                        self:_charaAddHurtValue({index=chara},{index=hurt},{index=recordRatio})
                        local effectBoom  = BattleEffect:createAnimation(310)
                        effectBoom:setPosition(bullet:getMover():getMoverPosition())
                        SceneBattle:getFrontLayer():addChild(effectBoom:getAnimNode(),100)
                        
                        self.m_tUpPenetrateList[index] = chara
                        self.m_tUpPenetrateValList[index] = hurt
                        self.m_tUpPenetrateDisList[index] = 0
                        self.m_tUpPenetrateCritList[index] = hurtType

                        self:_checkHitEnemy({index=chara}, bullet, {index=hurt})
                    end
                elseif self.m_bIsTurnDir then 
                    for k,tv in pairs(self.m_tDownPenetrateList) do
                        if tv:getBattleId() == chara:getBattleId() then
                            isExit = false
                        end
                    end

                    if isExit then
                        local index = chara:getBattleId()
                        local hurt,hurtType, distance,recordRatio = WBullet:calculateHurt(0,bullet:getOwnerChara(),chara,nil)
                        self:_charaAddHurtValue({index=chara},{index=hurt},{index=recordRatio})
                        local effectBoom  = BattleEffect:createAnimation(310)
                        effectBoom:setPosition(bullet:getMover():getMoverPosition())
                        SceneBattle:getFrontLayer():addChild(effectBoom:getAnimNode(),100)
                        
                        self.m_tDownPenetrateList[index] = chara
                        self.m_tDownPenetrateValList[index] = hurt
                        self.m_tDownPenetrateDisList[index] = 0
                        self.m_tDownPenetrateCritList[index] = hurtType

                        self:_checkHitEnemy({index=chara}, bullet, {index=hurt})
                    end
                end
            end
        end
    elseif nSkinBigSkillType == 3061 and bullet then 
        --子弹超出屏幕后自爆
        local battleSize = SceneBattle:getFrontLayerSize()
        self.m_nLeftRight = 1
        if self.m_nStartX < battleSize.width/2 then 
            self.m_nLeftRight = 0
        end
        if self.m_nLeftRight == 1 and curPos.x < -60 or self.m_nLeftRight == 0 and curPos.x > battleSize.width + 60 then --位置矫正
            g_nCollisionIndex = 2
        end
        if #bullet:getOwnerChara().m_tActiveAttackPos == 0 then 
            local pos = bullet:getMover():getMoverPosition()
            table.insert(bullet:getOwnerChara().m_tActiveAttackPos, {x=pos.x, y=pos.y})
        end
        --检测与玩家碰撞
        local isCollision, _ = bullet:checkCollision()
        if isCollision then
            isCollision = false
            local _, collisonChara = bullet:checkCharacterCollision()
            local tempTarget = {}
            for j, chara in pairs(collisonChara) do
                local isExit = true
                
                for k,tv in pairs(self.m_tUpPenetrateList) do
                    if tv:getBattleId() == chara:getBattleId() then
                        isExit = false
                    end
                end

                if isExit then
                    WZLog("BattleMsgPlayerShoot:_updateBullet collisonChara 3061")
                    local index = chara:getBattleId()
                    local hurt,hurtType, distance,recordRatio = WBullet:calculateHurt(0, bullet:getOwnerChara(), chara, nil)
                    self:_charaAddHurtValue({index=chara},{index=hurt},{index=recordRatio})
                    local effectBoom  = BattleEffect:createAnimation(310)
                    effectBoom:setPosition(bullet:getMover():getMoverPosition())
                    SceneBattle:getFrontLayer():addChild(effectBoom:getAnimNode(),100)
                    --检测职业反伤
                    BattleMethod:checkProfessionThorns(hero, {chara}, {hurt}, hero:getBattleId())
                    
                    self.m_tUpPenetrateList[index] = chara
                    self.m_tUpPenetrateValList[index] = hurt
                    self.m_tUpPenetrateDisList[index] = 0
                    self.m_tUpPenetrateCritList[index] = hurtType

                    self:_checkHitEnemy({index=chara}, bullet, {index=hurt})

                end
                WZLog("BattleMsgPlayerShoot:_updateBullet three-3061", chara:getBattleId(), chara:getIsRepulse())
                if chara:getIsRepulse() == false then 
                    table.insert(tempTarget, chara)
                end
            end
            --执行击中生效效果
            WZLog("BattleMsgPlayerShoot:_updateBullet two-3061", tostring(hero.m_tSkillTakeEffectInfo), #tempTarget)
            if #tempTarget > 0 and hero.m_tSkillTakeEffectInfo ~= nil then 
                WBattleGlobal:getCurrent():setDoEffectAfterAttack(true,"shoot-2")
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
                    hero.m_tSkillTakeEffectInfo, TakeEffectType.HIT,
                    nil,
                    nil,
                    nil,
                    nil,
                    self.m_tSkillOwner,
                    tempTarget,
                    nil,
                    bullet.m_nBulletIndex
                    )
            end
        end
        bullet:DigHoleOnly()
        bullet:updatePosition()
    end
end

--@brief    显示创建棋子分身
function BattleMsgPlayerShoot:_buildSubChess()
    if self.m_nSkinBigSkillType == 3065 then 
        if self.m_tSubRoleElement and #self.m_tSubRoleElement > 0 then 
            for i = 1, #self.m_tSubRoleElement do
                local subRole = self.m_tSubRoleElement[i]
                if subRole and subRole:getAnimNode():getParent() then
                    if subRole:isCurrentAnimationDone() then
                        local animNode
                        animNode = subRole:getAnimNode()
                        if animNode:getParent() then
                            animNode:removeFromParentAndCleanup(true)
                        end
                        self.m_tSubRoleElement[i] = nil
                    end
                end
            end
            return false 
        end
    end
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
    local targetHero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nChooseTarget) --选择的召唤目标
    local subHeroConfig = hero:getSoulHeroConfig()
    if not subHeroConfig then return false end 
    --召唤之前，先移除掉之前召唤的（如果有）
    local subHeroList = WBattleGlobal:getCurrent():getSubHero(self.m_nChooseTarget)
    if subHeroList and GetTableLen(subHeroList) > 0 then 
        local nCount = GetTableLen(subHeroList)
        for i = 1, nCount do
            WZLog("BattleMsgPlayerShoot:_buildSubChess One", subHeroList[i]:getBattleId())
            WBattleGlobal:getCurrent():removeSoulHero(subHeroList[i]:getBattleId())
        end
    end
    WZLog("BattleMsgPlayerShoot:_buildSubChess", self.m_nCurrentPlayerId, self.m_nChooseTarget, type(targetHero))
    local skinBigSkill = hero:getSkinBigSkill()
    local tempShapeData = WBattleGlobal:getCurrent():getSkinBigSkillShape(skinBigSkill)
    for i = 1, subHeroConfig.callNum do  
        local subHeroBattleId = nil 
        if WBattleGlobal:getCurrent():isSingleStage() then 
            subHeroBattleId = WBattleGlobal:getCurrent():getBuildGuaiBattleId(true)
        else
            subHeroBattleId = hero.guaiBattleId[i]
        end
        local subHero = WBattleGlobal:getCurrent():buildSubHero(targetHero, subHeroConfig.monsterIds[i], subHeroBattleId, tempShapeData.id)
        subHero:getAnimation():getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.4, 0.8)) 
        WZLog("BattleMsgPlayerShoot:_buildSubChess", self.m_nEndX, self.m_nEndY)
        if subHero:getSubType() == CharacterSubType.SUBTYPE_BCHESS then 
            subHero:getAnimation():setPosition(GlobalMethod:ccp(targetHero:getPosition().x - 50, targetHero:getPosition().y + 100))
        elseif subHero:getSubType() == CharacterSubType.SUBTYPE_WCHESS then 
            subHero:getAnimation():setPosition(GlobalMethod:ccp(targetHero:getPosition().x + 50, targetHero:getPosition().y + 100))
        end
--        subHero:getAnimation():getAnimNode():setRelativePosition(GlobalMethod:ccp(i - 1, 1))
        subHero:getAnimation():play(subHero:getActionName(23), true)
        SceneBattle:getFrontLayer():addChild(subHero:getAnimation():getAnimNode())
--        targetHero:getAnimation():getAnimNode():addChild(subHero:getAnimation():getAnimNode(), 1)

        local playerName = BattleKidName:create(subHero, SceneBattle:getInfoLayer(), true)
        subHero:setPlayerNameIcon(playerName)
        playerName:update()
    end

    return true 
end

--@brief    临时保存分身的伤害数据，防止多分身同时出手，伤害数据错乱
-- function BattleMsgPlayerShoot:_saveSoulHeroHurtData(charas, values, distance, critType, superCritMark)
--     local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
--     if hero:getIsSoulHero() then 
--         hero.m_tHurtData = {charas = charas, values = values, distance = distance, critType = critType, superCritMark = superCritMark}
--     end
-- end