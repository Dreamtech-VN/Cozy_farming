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

	m_nPlayerCount = 0, 			--同步角色数量
	m_tPlayerId = nil, 				--用户id列表
	m_tCurPositionX = nil, 			--没飞行前的x坐标
	m_tCurPositionY = nil, 			--没飞行前的y坐标

	m_nGuaiCount = 0, 				--同步怪物数量
	m_tGuaiBattleId = nil, 		--怪物id列表
	m_tGuaiCurPositionX = nil, 		--怪物没飞行前的x坐标
	m_tGuaiCurPositionY = nil, 		--怪物没飞行前的y坐标

-------------------------------------处理逻辑使用的变量--------------------------------------
	m_tStepFunction = nil,			--步骤函数
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
}

-------------------------------------公有方法模块--------------------------------------
--local WZLog = doNone
--@brief	消息初始化函数
--@note		消息系统第一次调用process函数前调用
function BattleMsgPlayerShoot:init()
    self:_float2int2float()
	WZLog("BattleMsgPlayerShoot:init", self.m_nSpeedx, self.m_nSpeedy)
    --地图buff检测
    WBattleGlobal:getCurrent():checkHurtBuffTotem()
    
    --录像记录
    self:_recordedSingleShoot()
    
	if TeachGroup1.ISBATTLE_MYTURN ~= true  and SceneBattle:getBattleLoop():getBattleStatus() ~= BattleLoop.S_NORMAL then
		return
	end

    if TeachGroup1.ISBATTLE_MYTURN then
        TeachGroup1.ISSHOOT = true
    end

    WBattleGlobal:getCurrent():ClearHurt()
    WBattleGlobal:getCurrent().m_bIsCurTurnActed = true

	SceneBattle:getBattleLoop():setBattleStatus(BattleLoop.S_PLAYER_SHOOT)
    WBattleGlobal:getCurrent().m_tAttackRandomList = {}
    WBattleGlobal:getCurrent().m_tTargetRandomList = {}

	local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
	if hero == nil then
		WZLog("BattleMsgPlayerShoot:init", "can't find player:", self.m_nCurrentPlayerId)
		return
	end

    --穿透子弹
    self.m_tPenetrateList = {}
    self.m_tPenetrateValList = {}
    self.m_tPenetrateDisList = {}
    self.m_tPenetrateCritList = {}

    WBattleGlobal:getCurrent().m_tCurRoundAction = {round=WBattleGlobal:getCurrent().m_nTurnTimes, player=self.m_nCurrentPlayerId}

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
		table.insert(self.m_tStepFunction,self._showBigSkillNew)
		if flase and hero:getBigSkillType() == 1 then
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
        table.insert(self.m_tStepFunction,self._checkPetAttack)
        table.insert(self.m_tStepFunction,self._checkAllCollision)
		--table.insert(self.m_tStepFunction,self._zoomToHero)
	else
		table.insert(self.m_tStepFunction,self._playShootAnim)
		table.insert(self.m_tStepFunction,self._readyShoot)
		table.insert(self.m_tStepFunction,self._repeatShoot)
		table.insert(self.m_tStepFunction,self._shooting)
        table.insert(self.m_tStepFunction,self._waitForBulletAndHurt)
        table.insert(self.m_tStepFunction,self._checkPetAttack)
        table.insert(self.m_tStepFunction,self._checkAllCollision)
		--table.insert(self.m_tStepFunction,self._zoomToHero)
	end
    WBattleGlobal:getCurrent():setShowGameOver(false)

    if hero ~= nil and hero.m_bIsAddSpInCurTurn == false then
        hero.m_bIsAddSpInCurTurn = true
        local angerUp =  10
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
    if true or WBattleGlobal:getCurrent():isSingleStage() then
        local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
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
		return true
	end

	--WBattleGlobal:getCurrent():checkCheat()

	--更新子弹状态
	self:_updateBullet()

	--子弹跟随
    if WBattleGlobal:getCurrent().m_bIsGameOverTimer ~= true then
        self:_followBullet()
    else
        self:_zoomToHero()
    end

	--屏幕震动
	self:_updateScene()

	if #self.m_tStepFunction > 0 then
		local res = self.m_tStepFunction[1](self)
		if res == true or res == nil then
			table.remove(self.m_tStepFunction,1)
		end
		return false
	elseif self.m_nBuildBulletsSkillStatusCount > 0 then
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

        --self:_sendHurtProtocol(self.m_tHurtChara,self.m_tHurtValues)
        self.m_tHurtChara = nil
        self.m_tHurtValues = nil

        local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
        hero.m_nRotatePre = nil

        if hero.m_tBigSkillShootAnim then
            hero.m_tBigSkillShootAnim:getAnimNode():removeFromParentAndCleanup(true)
            hero.m_tBigSkillShootAnim = nil
            WZLog("BattleMsgPlayerShoot:done zero")
        end


        self:_checkPetAttack()
        if hero ~= nil then
            if hero and hero:getUseBigSkill() then
                GetElement(SceneBattle.m_root,"conBigSkill2_SceneBattle",WZUIContainer):setVisible(false)
                GetElement(WndBattleHud.m_root,"conBigSkill2Back_WndBattleHud",WZUIContainer):setVisible(false)
                GetElement(WndBattleHud.m_root,"imgBigSkill2Back_WndBattleHud",WZUIImage):setVisible(false)
            end
            WZLog("BattleMsgPlayerShoot:done two", hero:getAttTimes())
            hero:setUseBigSkill(false)

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
        return true
    end
    self.m_bIsAllFalse = isAllFalse
    self.m_tCheckList = {}
    
    return false
end

--@brief	播放射击动画
function BattleMsgPlayerShoot:_playShootAnim()
    WZLog("BattleMsgPlayerShoot:_playShootAnim")
	local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
	self.m_bCanFallDown = false
	hero:setMoveUpdatable(false)
    if hero.m_bIsReadyShoot == nil then
        hero:playReadyShootAnim()
    end
    --hero:addAppearAnimation()
	return true
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

	if isCanRepeatShoot then
		self.m_nTimeRemain = 0
		hero:setRunStatus(RunStatus.DEF_ST_REPEAT_SHOOT)
		self:_createBullet(hero:getAttScatterNum())
        self.m_nAttackedCount = self.m_nAttackedCount and self.m_nAttackedCount + 1 or 1
        WZLog("BattleMsgPlayerShoot:_readyShoot 3:", hero:getAttTimes(), self.m_nAttackedCount)

		if hero:getAttTimes()-self.m_nAttackedCount >= 0 then
            WZLog("BattleMsgPlayerShoot:_readyShoot three", hero:getAttTimes())
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

--@brief	播放重复射击动画
function BattleMsgPlayerShoot:_repeatShoot()
    WZLog("BattleMsgPlayerShoot:_repeatShoot")
	local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
    hero.m_bIsReadyShoot = nil

	if hero:getAttTimes()-self.m_nAttackedCount > 0 then
		if self.m_nTimeRemain > 3 then
			self.m_nTimeRemain = 0
			hero:setRunStatus(RunStatus.DEF_ST_REPEAT_SHOOT)
			self:_createBullet(hero:getAttScatterNum())
			self.m_nAttackedCount = self.m_nAttackedCount and self.m_nAttackedCount + 1 or 1
			if hero:getAttTimes()-self.m_nAttackedCount >= 0 then
                WZLog("BattleMsgPlayerShoot:_repeatShoot two", hero:getAttTimes())
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
    WZLog("BattleMsgPlayerShoot:_shooting")
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
        return BattleScreen:zoomToHero(hero:getBattleId() , hero:getMover():getMoverPosition(), nil, scale, speed)
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
    WZLog("BattleMsgPlayerShoot:_updateBullet one", #bullets)
	for i=#bullets,1,-1 do
		if bullets[i]:getStatus() == BulletStatus.DEF_ST_FLY then
            WZLog("BattleMsgPlayerShoot:_updateBullet pos",i)
            WZLog("BattleMsgPlayerShoot:_updateBullet pos",bullets[i]:getMover():getMoverPosition().x,bullets[i]:getMover():getMoverPosition().y)
            -- WZLog("BattleMsgPlayerShoot:_updateBullet posII",bullets[i]:getMover():getMoverPrePosition().x)
			bullets[i]:updatePosition()
			--碰撞检测
            local isCollision = false
            local penetrateMonster = nil
           
            --WZLog("NO_HOLE_ 1", bullets[i], bullets[i].m_tBullet)
            isCollision, _ = bullets[i]:checkCollision()

            --穿透弹处理begin
            if isCollision and WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId):getCanPenetrate() then
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

			if isCollision == true and penetrateMonster ~= nil then
                local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
				for i, v in pairs (penetrateMonster) do
					v:markHurt(1,hero,nil,nil,nil,0)
				end
			elseif isCollision == true then
                local charas, values, distance, critType, hurtRatios = bullets[i]:checkHurt(true)
                --WZLog("BattleMsgPlayerShoot:_updateBullet two-2 charas", Serialize(charas), "values", Serialize(values), Serialize(distance),Serialize(critType), Serialize(hurtRatios))

                local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
                

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

                    local charas, values, distance, critType,hurtRatios = bullets[i]:checkHurt()
                    self:_charaAddHurtValue(charas,values,hurtRatios)
                    WZLog("BattleMsgPlayerShoot:_updateBullet two-3.7")
                    self:_sendHurtProtocol(charas,values,distance,critType)
                	bullets[i]:markExplode(false)
                	if isSkillEffectTaked == false then
                        --bullets[i]:markExplode(true)
	                	self.m_nSkillStatusCount = self.m_nSkillStatusCount + 1

	                	if hero.m_nIsSpatter == true then
	                		self.m_nBuildBulletsSkillStatusCount = self.m_nBuildBulletsSkillStatusCount + 1
	                		WZLog("BattleMsgPlayerShoot:_updateBullet two-3.71")
	                	end

	                	local info = hero.m_tSkillTakeEffectCollionInfo
	                	hero.m_tSkillTakeEffectCollionInfo = nil
                        -- WBattleGlobal:getCurrent().m_bIsDoEffectAfterAttack = true
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
				            nil
                            --bullets[i]
				            )
	                end

                elseif hero.m_tHitTargets ~= nil and #hero.m_tHitTargets > 0 and hero.m_tSkillTakeEffectInfo ~= nil then
                	local isSkillEffectTaked = false
                	WZLog("BattleMsgPlayerShoot:_updateBullet two-3", #hero.m_tHitTargets, #hero.m_tSkillTakeEffectList)
                	if #hero.m_tHitTargets <= #hero.m_tSkillTakeEffectList then
                		isSkillEffectTaked = true
                	end

                    local charas, values, distance, critType,hurtRatios = bullets[i]:checkHurt()
                    self:_charaAddHurtValue(charas,values,hurtRatios)
                    WZLog("BattleMsgPlayerShoot:_updateBullet two-3.8")
                    self:_sendHurtProtocol(charas,values,distance,critType)
                	bullets[i]:markExplode(false)
                	if isSkillEffectTaked == false then
                        --bullets[i]:markExplode(true)
	                	self.m_nSkillStatusCount = self.m_nSkillStatusCount + 1

                        -- WBattleGlobal:getCurrent().m_bIsDoEffectAfterAttack = true
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
				            nil
                            --bullets[i]
				            )
	                end

	            else
	            	local charas,values,tDistance, tCritType,tHurtRatio = bullets[i]:checkHurt()
                	self:_charaAddHurtValue(charas,values,tHurtRatio)
                	WZLog("BattleMsgPlayerShoot:_updateBullet two-3.9")
					self:_sendHurtProtocol(charas,values,tDistance,tCritType)
					bullets[i]:markExplode(false)
                end

                WZLog("NO_HOLE_ 3", bullets[i], bullets[i].m_tBullet)
                bullets[i]:explode()
				WBattleGlobal:getCurrent():enableAllHeroFallDown()
				if not self.m_bCanFallDown then
					local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
					hero:setMoveUpdatable(false)
				end
                --屏幕震动
                self.m_nSpringCount = self.m_nSpringCount + 1
                if self.m_nSpringCount < 7 then
                    WZLog("BattleMsgPlayerShoot:_updateBullet two-4.1", self.m_nSpringCount)
                    math.randomseed(tostring(os.time()):reverse():sub(1, 6))
                    self:_setSceneSpring(BattleCommon:getPointTable(bullets[i]:getMover():getMoverPosition().x + math.random(-100,100), bullets[i]:getMover():getMoverPosition().y + 0))
                end
			end
		end
		--移除子弹
		if self:_canRemoveBullet(bullets[i], i) then
            if WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId):getCanPenetrate() and BattleCommon:tableLen(self.m_tPenetrateList) > 0 then

                self:_sendHurtProtocol(self.m_tPenetrateList,self.m_tPenetrateValList,self.m_tPenetrateDisList,self.m_tPenetrateCritList)
            end
            if bullets[i].m_bIsMark ~= true then
                bullets[i]:destroy()
            end
			WBattleGlobal:getCurrent():removeBulletByIndex(i)
            WZLog("BattleMsgPlayerShoot:_updateBullet two-4.2")
		end
	end
end

--@brief	对英雄添加受伤数字(除零)
--@param	charas:英雄列表
--@param	hurtValue:受伤数字
--@return	#1:需要发送协议的英雄列表
--@return	#2:需要发送协议的伤害列表
function BattleMsgPlayerShoot:_charaAddHurtValue(charas,hurtValue,hurtRatios)

	local newCharas = {}
	local newValue = {}
	local shootHero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
	for id,chara in pairs(charas) do
        WZLog("BattleMsgPlayerShoot:_charaAddHurtValue", tostring(id), tostring(chara.m_animPlayerShield), tostring(hurtValue[id]),tostring(hurtRatios[id]))
		chara:markHurt(hurtValue[id],shootHero,nil,nil,nil,hurtRatios[id])
		if hurtValue[id] ~= -1 and hurtValue[id] ~= 0 then
			newCharas[id] = chara
			newValue[id] = hurtValue[id]
		end
	end

    WZLog("BattleMsgPlayerShoot:_charaAddHurtValue", Serialize(newValue))
	return newCharas,newValue
end

--@brief	检查是否打中对方
function BattleMsgPlayerShoot:_checkHitEnemy(charas, bullet, values)
    WZLog("BattleMsgPlayerShoot:_checkHitEnemy")
    if charas ~= nil then
        for id,chara in pairs(charas) do
            local value = chara:hurtEffectHandle(values[id])
            if chara:getBattleId() == self.m_nCurrentPlayerId or value == 0 or chara.m_bOffHurt then
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
                if value < chara:getHp() and chara.getBoss == nil then
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

--@brief	发送受伤协议
--@param	charas:英雄列表
--@param	values:伤害列表
--@param	distance:距离列表
function BattleMsgPlayerShoot:_sendHurtProtocol(charas,values,distance,critType)
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
    WZLog("BattleMsgPlayerShoot:_sendHurtProtocol one", tostring(charas), tostring(self.m_nCurrentPlayerId), tostring(hero:isCanControl()), tostring(hero.m_bLoseNet))
	if charas == nil or not (hero:isCanControl() or hero.m_bLoseNet) then
		return
	end

    WZLog("BattleMsgPlayerShoot:_sendHurtProtocol two",tostring(charas),tostring(values),tostring(distance),tostring(critType))
	WBattleGlobal:getCurrent():sendHurtProtocol(self.m_nCurrentPlayerId,charas,values,distance,critType)

	--[[local hurtCount = 0
	local hurtIds = WZLuaVector_int_:create()
	local hurtValues = WZLuaVector_int_:create()
	local hurtGuaiCount = 0
	local hurtGuaiIds = WZLuaVector_int_:create()
	local hurtGuaiValues = WZLuaVector_int_:create()

	for id,chara in pairs(charas) do
		if chara:getType() == 0 then
			hurtIds:push(chara:getBattleId())
			hurtValues:push(values[id])
			hurtCount = hurtCount + 1
		elseif chara:getType() == 1 then
			hurtGuaiIds:push(chara:getBattleId())
			hurtGuaiValues:push(values[id])
			hurtGuaiCount = hurtGuaiCount + 1
		end
	end

	if hurtCount > 0 or hurtGuaiCount > 0 then
		ProtocolProcessorBattleInterface:send_BATTLE_Hurt(self.m_nBattleId, self.m_nCurrentPlayerId, hurtCount, hurtIds, hurtValues, 0, 0, hurtGuaiCount, hurtGuaiIds, hurtGuaiValues)
	end]]
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
		--if self:_getIsSceneSpring() == false then
		BattleScreen:followBullet(bullet:getMover():getMoverPosition(),self._followBullet_time_)
		--end
	elseif self.m_tFirstHitEnemy ~= nil and self.m_tFirstHitEnemy:getIsHero() and self.m_tFirstHitEnemy:getIsRepulse() then
		BattleScreen:followBullet(self.m_tFirstHitEnemy:getMover():getMoverPosition(),2)
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
function BattleMsgPlayerShoot:_createBullet(nScatterNum, isProcessMapEventBubble)
    WZLog("BattleMsgPlayerShoot:_createBullet zero",nScatterNum, self.m_nCurrentPlayerId, WBattleGlobal:getCurrent():getMyHero():getBattleId() )

    if self.m_nCurrentPlayerId == WBattleGlobal:getCurrent():getMyHero():getBattleId() then

    end

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
		WZLog("BattleMsgPlayerShoot:_createBullet",i,self.m_nStartX,self.m_nStartY,speedVec.x,speedVec.y)
		local bullet = WBattleGlobal:getCurrent():buildBullet(self.m_nCurrentPlayerId,startX,startY,speedVec.x,speedVec.y)
		if self.m_nLeftRight == 1 then
			bullet:getAnimation():setFlipY(true)
		end
        --[[
        if WBattleGlobal:getCurrent().m_tIsHighEndMachine == true then
            SceneBattle:getFrontLayer():addChild(bullet:getBackFire():getParent(),2)
        end
        ]]
		SceneBattle:getFrontLayer():addChild(bullet:getAnimation():getAnimNode(),3)

        bullet:getAnimation():play("0",true)
        
        local hero = WBattleGlobal:getCurrent():getCurrentCharacter()
        if hero:isHide() == true then
            if WBattleGlobal:getCurrent():isReplayGame() or WBattleGlobal:getCurrent():isMyTeam(hero:getBattleId()) then
                -- bullet:getAnimation():getAnimNode():setOpacity(51)
                bullet:setOpacity(51)
            else
                -- bullet:getAnimation():getAnimNode():setOpacity(0)
                bullet:setOpacity(0)
            end
            if WBattleGlobal:getCurrent().m_tIsHighEndMachine == true then
                bullet:getBackFire():setVisible(false)
            end
        end

		speedVec = BattleCommon:vectorWithAngle(speedVec,BattleConstants.g_fWB_SCATTER_ANGLE)
	end
end

--@brief	屏幕显示最大范围
function BattleMsgPlayerShoot:_ZoomOut()
    WZLog("BattleMsgBossMapSkill:_ZoomOut")
    if self.m_bIsZoom == false then
        self.m_bIsZoom = nil
        return true
    else
        return BattleScreen:zoomOut(nil,nil)
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
            if hero.m_nWeaponType == 0 then
                shopAnim:play(hero:getActionName(9), false)
            else
                shopAnim:play(hero:getActionName(11), false)
            end

            WZLog("BattleMsgPlayerShoot:_showBigSkillNew six", hero.m_nWeaponType)
            
            
            
            local scale = 1.7
            local x, y = 0.0,0
            if hero.m_bIsMonster == true then
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

        local msg = MsgManager:createMsg(BattleMsgPetShoot)
        msg.m_shootHero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
        msg.m_beShootedChara = self.m_tPetAttackEnemy
        msg.m_bIsReplayMsg = true
        MsgManager:pushBlockMsg(msg, 2)
    end
    return true
end 

--@brief	宠物是否攻击
--@return	#1:true,false
function BattleMsgPlayerShoot:_isPetAttack()
    WZLog("BattleMsgPlayerShoot:_isPetAttack one1")
	local shootHero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
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

    WZLog("BattleMsgPlayerShoot:_isPetAttack two", tostring(shootHero:getCamp()), tostring(self.m_tPetAttackEnemy:getCamp()), self.m_tPetAttackEnemy:getBattleId())
    if shootHero:getCamp() == self.m_tPetAttackEnemy:getCamp() then
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
    
    local count = hero:getAttTimes() * hero:getAttScatterNum()
    WZLog("BattleMsgPlayerShoot:_sendBattleShoot-2",self.m_nBattleId, self.m_nCurrentPlayerId, self.m_nSpeedx, self.m_nSpeedy, self.m_nLeftRight, self.m_nStartX, self.m_nStartY, nPlayerCount, tPlayerId, tCurPositionX, tCurPositionY,count)
    ProtocolProcessorBattleInterface:send_BATTLE_Shoot(self.m_nBattleId, self.m_nCurrentPlayerId, self.m_nSpeedx, self.m_nSpeedy, self.m_nLeftRight, self.m_nStartX, self.m_nStartY, nPlayerCount, tPlayerId, tCurPositionX, tCurPositionY, tCurPositionR, tCurPositionD, count)
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
                nPlayerCount = nPlayerCount + 1
            end
        end
    end

    local count = hero:getAttTimes() * hero:getAttScatterNum()
    WZLog("BattleMsgPlayerShoot:_sendBossBattleShoot-2",self.m_nBattleId, self.m_nCurrentPlayerId, self.m_nSpeedx, self.m_nSpeedy, self.m_nLeftRight, self.m_nStartX, self.m_nStartY, nPlayerCount, tPlayerId, tCurPositionX, tCurPositionY,count)

    ProtocolProcessorBattleInterface:send_BATTLE_Shoot(self.m_nBattleId, self.m_nCurrentPlayerId, self.m_nSpeedx, self.m_nSpeedy, self.m_nLeftRight, self.m_nStartX, self.m_nStartY, nPlayerCount, tPlayerId, tCurPositionX, tCurPositionY, tCurPositionR, tCurPositionD,count)
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