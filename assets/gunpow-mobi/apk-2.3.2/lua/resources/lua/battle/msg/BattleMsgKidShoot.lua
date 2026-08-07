--BattleMsgKidShoot.lua
--@brief	玩家射击消息
--@date		2013/1/8
--@author	李光森
--@note

--@brief	消息数据表
BattleMsgKidShoot = {
    m_sName = "BattleMsgKidShoot",
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
    m_tPetAttackEnemy = nil,        --宠物攻击敌人
    m_tFrozenEnemy = nil,           --冰冻敌人
    m_nSpringCount = 0,
    m_nWaitDeltaTime = 0,
    --穿透子弹计算    
    m_tPenetrateList = nil,
    m_tPenetrateValList = nil,
    m_tPenetrateDisList = nil,
    m_tPenetrateCritList = nil,
    m_tCheckList = {},
    m_bIsAllFalse = nil,
    m_nLastScale = 0,           --原镜头大小
    m_nBulletIndex = 1,         --子弹索引
}

-------------------------------------公有方法模块--------------------------------------
--local WZLog = doNone
--@brief	消息初始化函数
--@note		消息系统第一次调用process函数前调用
function BattleMsgKidShoot:init()
    self:_float2int2float()
	WZLog("BattleMsgKidShoot:init", self.m_nSpeedx, self.m_nSpeedy)
    --地图buff检测
    WBattleGlobal:getCurrent():checkHurtBuffTotem(MonsterType.BUFF_TOTEM)
    
    --录像记录
    self:_recordedSingleShoot()

    WBattleGlobal:getCurrent():ClearHurt()
    WBattleGlobal:getCurrent().m_bIsCurTurnActed = true

    WBattleGlobal:getCurrent().m_tAttackRandomList = {}
    WBattleGlobal:getCurrent().m_tTargetRandomList = {}

	local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
	if hero == nil then
		WZLog("BattleMsgKidShoot:init", "can't find player:", self.m_nCurrentPlayerId)
		return
	end

    hero.m_tActiveAttackPos = {}
    --穿透子弹
    self.m_tPenetrateList = {}
    self.m_tPenetrateValList = {}
    self.m_tPenetrateDisList = {}
    self.m_tPenetrateCritList = {}

    self.m_nBulletIndex = 1 
    self.m_nLastScale = BattleScreen:getBattle():getFrontLayer():getScale()

	hero:setRunStatus(RunStatus.DEF_ST_READY_SHOOT)

    local myHero = WBattleGlobal:getCurrent():getMyHero()
    if self.m_nCurrentPlayerId == myHero:getBattleId() and not WBattleGlobal:getCurrent():isAudience() then
        myHero.m_nShootCount = myHero.m_nShootCount + hero:getAttTimes() * hero:getAttScatterNum()
    end

	if self.m_nLeftRight == 1 then
		hero:getAnimation():setFlipX(true)
	else
		hero:getAnimation():setFlipX(false)
	end
    WZLog("BattleMsgKidShoot:init", tostring(hero:getAnimation():isFlipX()))

	local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)

    local isCanControl = false
    if hero:isCanControl() == true and hero:getBattleId() ~= WBattleGlobal:getCurrent():getMyHero():getBattleId() then
        isCanControl = true
        WZLog("BattleMsgKidShoot:init one")
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
	table.insert(self.m_tStepFunction,self._playShootAnim)
	table.insert(self.m_tStepFunction,self._readyShoot)
	table.insert(self.m_tStepFunction,self._repeatShoot)
	table.insert(self.m_tStepFunction,self._shooting)
    table.insert(self.m_tStepFunction,self._waitForBulletAndHurt)
    table.insert(self.m_tStepFunction,self._checkAllCollision)
    table.insert(self.m_tStepFunction,self._setKidDead)

    WBattleGlobal:getCurrent():setShowGameOver(false)
end

--@brief	消息处理过程函数
--@return	#1,nil或true表示消息处理结束，否则返回false
--@note		未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgKidShoot:process()
	WZLog("BattleMsgKidShoot:process zero")
    if true or WBattleGlobal:getCurrent():isSingleStage() then
        local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
        if hero == nil then
            return true
        end

        WZLog("BattleMsgKidShoot:process one", tostring(hero:isDead()), tostring(#WBattleGlobal:getCurrent():getBulletsListByChara(self.m_nCurrentPlayerId)), tostring(SceneBattle:getBattleLoop():getBattleStatus()),self.m_nBuildBulletsSkillStatusCount)
        if (hero:isDead() == true or hero.m_bLoseNet == true) and (#WBattleGlobal:getCurrent():getBulletsListByChara(self.m_nCurrentPlayerId) <= 0 and self.m_nBuildBulletsSkillStatusCount <= 0) then
            WZLog("BattleMsgKidShoot:process two-1")
            return true
        end
    end

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
    elseif WBattleGlobal:getCurrent():getBulletsListByChara(self.m_nCurrentPlayerId) ~= nil and #WBattleGlobal:getCurrent():getBulletsListByChara(self.m_nCurrentPlayerId) > 0 then 
        return false 
	else
		WZLog("BattleMsgKidShoot:process two-3")
		return true
	end

	WZLog("BattleMsgKidShoot:process two-4")
	return true
end

--@brief	消息处理完成函数
--@note		消息系统最后一次调用process函数后调用
function BattleMsgKidShoot:done()
    if self.m_bIsDone ~= true then
        local loop = SceneBattle:getBattleLoop()
        WZLog("BattleMsgKidShoot:done", os.time(), loop:getBattleStatus(), BattleLoop.S_PLAYER_SHOOT)
        WBattleGlobal:getCurrent():setShowGameOver(true)

        if TeachGroup1.ISBATTLE_MYTURN ~= true and loop:getBattleStatus() == BattleLoop.S_PLAYER_SHOOT then
            loop:setBattleStatus(BattleLoop.S_NORMAL)
        else
            --return
        end

        WBattleGlobal:getCurrent().m_bIsZoomToHero = false
        WBattleGlobal:getCurrent().m_nAttackedCount = 1
        
        self.m_tHurtChara = nil
        self.m_tHurtValues = nil

        local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
        hero.m_nRotatePre = nil

        if hero ~= nil then
            hero:setAttTimes(0,2)
        end

        self:_removeTheKid()
        self.m_bIsDone = true
    end

    local bullets = WBattleGlobal:getCurrent():getBulletsListByChara(self.m_nCurrentPlayerId)
    for i=#bullets,1,-1 do
        --移除子弹
        bullets[i]:destroy()
        WBattleGlobal:getCurrent():removeBulletById(bullets[i].m_nId)
        WZLog("BattleMsgKidShoot:_updateBullet two-4.3", bullets[i].m_nId)
    end
    if self.m_nSkillStatusCount == 0 then
	    WZLog("sendMsg BattleMsgEndCurRound: 7")
    elseif self.m_nSkillStatusCount == -1 then
        WZLog("BattleMsgKidShoot:done three")
    else
        WZLog("BattleMsgKidShoot:done four", self.m_nSkillStatusCount)
        return false
	end
end


-------------------------------------私有方法模块--------------------------------------
--@brief    检查全部人是否着地或掉坑或死亡
function BattleMsgKidShoot:_checkAllCollision()
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
function BattleMsgKidShoot:_playShootAnim()
    WZLog("BattleMsgKidShoot:_playShootAnim")
	local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
	self.m_bCanFallDown = false
	hero:setMoveUpdatable(false)
    if hero.m_bIsReadyShoot == nil then
        hero:playReadyShootAnim()
    end
	return true
end

--@brief	播放准备射击动画
function BattleMsgKidShoot:_readyShoot()
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)

    WZLog("BattleMsgKidShoot:_readyShoot 0:", hero:getAttTimes(), self.m_nAttackedCount)
    self.m_nShootDeltaTime = self.m_nShootDeltaTime + 1

    local isCanRepeatShoot = false

    --是否能跳转到射击子弹
    if self.m_nReadyToShootDeltaTime ~= 0 and self.m_nShootDeltaTime >= self.m_nReadyToShootDeltaTime * 30 then
        WZLog("BattleMsgKidShoot:_readyShoot 1:", self.m_nShootDeltaTime)
        isCanRepeatShoot = true
    elseif hero:getAnimation():isCurrentAnimationDone() == true or hero:getAnimation():isPlaying(hero:getActionName(23)) then
        WZLog("BattleMsgKidShoot:_readyShoot 2:", self.m_nShootDeltaTime)
        isCanRepeatShoot = true
    end

	if isCanRepeatShoot then
		self.m_nTimeRemain = 0
		hero:setRunStatus(RunStatus.DEF_ST_REPEAT_SHOOT)
		self:_createBullet(hero:getAttScatterNum())
        self.m_nAttackedCount = self.m_nAttackedCount and self.m_nAttackedCount + 1 or 1
        WZLog("BattleMsgKidShoot:_readyShoot 3:", hero:getAttTimes(), self.m_nAttackedCount)

		if hero:getAttTimes()-self.m_nAttackedCount >= 0 then
            WZLog("BattleMsgKidShoot:_readyShoot three", hero:getAttTimes())
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
function BattleMsgKidShoot:_repeatShoot()
    WZLog("BattleMsgKidShoot:_repeatShoot")
	local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
    hero.m_bIsReadyShoot = nil
    local nLeftTimes = 3

	if hero:getAttTimes()-self.m_nAttackedCount > 0 then
		if self.m_nTimeRemain > nLeftTimes then
			self.m_nTimeRemain = 0
			hero:setRunStatus(RunStatus.DEF_ST_REPEAT_SHOOT)
			self:_createBullet(hero:getAttScatterNum())
			self.m_nAttackedCount = self.m_nAttackedCount and self.m_nAttackedCount + 1 or 1
			if hero:getAttTimes()-self.m_nAttackedCount >= 0 then
                WZLog("BattleMsgKidShoot:_repeatShoot two", hero:getAttTimes())
				hero:playRepeatShootAnim(1)
			end
		else
			self.m_nTimeRemain = self.m_nTimeRemain + 1
			hero:setRunStatus(RunStatus.DEF_ST_REPEAT_SHOOT)
		end
		return false
	elseif hero:getIsFrozen() or (hero:getAnimation():isCurrentAnimationDone() == true and hero:getAnimation():isPlaying(hero:getActionName(23)) ~= true) or hero:getAnimation():isPlaying(hero:getActionName(23)) == true then
		self.m_nTimeRemain = 0
        WZLog("BattleMsgKidShoot:_repeatShoot three")
		-- hero:setRunStatus(RunStatus.DEF_ST_SHOOT)
		hero:playEndShootAnim()
		return true
    elseif hero:getAnimation():isCurrentAnimationDone() ~= true then
        return false
	end
end

--@brief	播放正在射击动画
function BattleMsgKidShoot:_shooting()
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
	--self:_followBullet()
	self.m_bCanFallDown = true
    if hero:getAnimation():isCurrentAnimationDone() == true or hero:getAnimation():isPlaying(hero:getActionName(23)) or hero:isInBuffState(EffectTypeConfig.LIMIT_ALL_ACTION) then
        WZLog("BattleMsgKidShoot:_shooting two", tostring(hero:isInBuffState(EffectTypeConfig.LIMIT_ALL_ACTION)))
		hero:setMoveUpdatable(true)
		hero:setRunStatus(RunStatus.DEF_ST_NORMAL)
		hero:getAnimation():play(hero:getActionName(23),true)
		return true
	else
		-- hero:setRunStatus(RunStatus.DEF_ST_SHOOT)
		return false
	end
end

--@brief	等待子弹消失和英雄受伤
function BattleMsgKidShoot:_waitForBulletAndHurt()
    WZLog("BattleMsgKidShoot:_waitForBulletAndHurt", tostring(self:_waitForBullet()), tostring(self:_waitForHurtNum()))

    self.m_nWaitDeltaTime = self.m_nWaitDeltaTime + SceneBattle:getBattleLoop():getBattleDeltaTime()

	if self:_waitForBullet() and self:_waitForHurtNum() then
		BattleScreen:resetZoomToHero()
        WZLog("BattleMsgKidShoot:_waitForBulletAndHurt two", os.time())
		return true
	else
		return false
	end
end

--@brief	等待子弹消失
function BattleMsgKidShoot:_waitForBullet()
    local isHaveBullet = self:_isHaveBullet()
    WZLog("BattleMsgKidShoot:_waitForBullet", tostring(isHaveBullet), self.m_nWaitDeltaTime)
	--self:_followBullet()
	if isHaveBullet == false and self.m_nWaitDeltaTime > 0 then
		return true
	else
		return false
	end
end

--@brief	等待伤害数字消失
function BattleMsgKidShoot:_waitForHurtNum()
	local isHurt, hurtOne = WBattleGlobal:getCurrent():IsAnyOneHurt()
    WZLog("BattleMsgKidShoot:_waitForHurtNum", tostring(hurtOne), tostring(not isHurt))
	return not isHurt
end

--@brief    屏幕初始化
function BattleMsgKidShoot:_resetZoomToHero()
    WZLog("BattleMsgKidShoot")
    BattleScreen:resetZoomToHero()
    return true
end

--@brief    最小化屏幕
function BattleMsgKidShoot:_ZoomOut()
    WZLog("BattleMsgKidShoot:_ZoomOut")
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
    local heroPt = hero:getAnimation():getPosition()
    return BattleScreen:zoomOut(heroPt, nil)
end

--@brief	屏幕移向英雄
function BattleMsgKidShoot:_zoomToHero()
    if WBattleGlobal:getCurrent():isGameOver() then
        return true
    end
    
    WZLog("BattleMsgKidShoot:_zoomToHero one", WBattleGlobal:getCurrent().m_tGameOverHero and WBattleGlobal:getCurrent().m_tGameOverHero:getBattleId())
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
		WZLog("BattleMsgKidShoot:_zoomToHero two")
	end
    
	if hero ~= nil then
        return BattleScreen:zoomToHero(hero:getBattleId(), hero:getMover():getMoverPosition(), nil, scale, speed)
    else
        return true
    end
end

--@brief	更新子弹状态
function BattleMsgKidShoot:_updateBullet()
	local bullets = WBattleGlobal:getCurrent():getBulletsListByChara(self.m_nCurrentPlayerId)
    WZLog("BattleMsgKidShoot:_updateBullet one")
	for i=#bullets,1,-1 do
		if bullets[i]:getStatus() == BulletStatus.DEF_ST_FLY then
            WZLog("BattleMsgKidShoot:_updateBullet pos",i)
            WZLog("BattleMsgKidShoot:_updateBullet pos",bullets[i]:getMover():getMoverPosition().x,bullets[i]:getMover():getMoverPosition().y)
            -- WZLog("BattleMsgKidShoot:_updateBullet posII",bullets[i]:getMover():getMoverPrePosition().x)
			bullets[i]:updatePosition()
			--碰撞检测
            local isCollision = false
           
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
                        WZLog("BattleMsgKidShoot:_updateBullet collisonChara")
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
            if isCollision == true then
                local charas, values, distance, critType, hurtRatios, superCritMark = bullets[i]:checkHurt(true)
                --WZLog("BattleMsgKidShoot:_updateBullet two-2 charas", Serialize(charas), "values", Serialize(values), Serialize(distance),Serialize(critType), Serialize(hurtRatios))

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
                WZLog("BattleMsgKidShoot:_attackCheck",tostring(hero.m_tActiveAttackPos and #hero.m_tActiveAttackPos or 0))
                WZLog("BattleMsgKidShoot:_attackCheck",tostring(hero.m_tSkillTakeEffectCollionInfo),tostring(hero.m_tSkillTakeEffectInfo))
				if hero.m_tActiveAttackPos ~= nil and #hero.m_tActiveAttackPos > 0 and hero.m_tSkillTakeEffectCollionInfo ~= nil then
					local isSkillEffectTaked = false

                    local charas, values, distance, critType,hurtRatios, superCritMark= bullets[i]:checkHurt(nil, true)
                    self:_charaAddHurtValue(charas,values,hurtRatios, superCritMark)
                    WZLog("BattleMsgKidShoot:_updateBullet two-3.7")
                    self:_sendHurtProtocol(charas,values,distance,critType, superCritMark)
                	bullets[i]:markExplode(false)
                    --检测职业反伤
                    BattleMethod:checkProfessionThorns(hero, charas, values, hero:getBattleId())
                	if isSkillEffectTaked == false then
                        --bullets[i]:markExplode(true)
	                	self.m_nSkillStatusCount = self.m_nSkillStatusCount + 1

	                	if hero.m_nIsSpatter == true then
	                		self.m_nBuildBulletsSkillStatusCount = self.m_nBuildBulletsSkillStatusCount + 1
	                		WZLog("BattleMsgKidShoot:_updateBullet two-3.71")
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
                            hero
				            )
	                end

                elseif hero.m_tHitTargets ~= nil and #hero.m_tHitTargets > 0 and hero.m_tSkillTakeEffectInfo ~= nil then
                	local isSkillEffectTaked = false
                	WZLog("BattleMsgKidShoot:_updateBullet two-3", #hero.m_tHitTargets, #hero.m_tSkillTakeEffectList)
                	if #hero.m_tHitTargets <= #hero.m_tSkillTakeEffectList then
                		isSkillEffectTaked = true
                	end

                    local charas, values, distance, critType, hurtRatios, superCritMark= bullets[i]:checkHurt(nil, true)
                    self:_charaAddHurtValue(charas,values,hurtRatios, superCritMark)
                    WZLog("BattleMsgKidShoot:_updateBullet two-3.8")
                    self:_sendHurtProtocol(charas,values,distance,critType, superCritMark)
                	bullets[i]:markExplode(false)
                    --检测职业反伤
                    BattleMethod:checkProfessionThorns(hero, charas, values, hero:getBattleId())
                	if isSkillEffectTaked == false then
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
                            hero
				            )
	                end
	            else
	            	local charas,values,tDistance, tCritType,tHurtRatio, superCritMark= bullets[i]:checkHurt(nil, true)
                	self:_charaAddHurtValue(charas,values,tHurtRatio, superCritMark)
                	WZLog("BattleMsgKidShoot:_updateBullet two-3.9")
					self:_sendHurtProtocol(charas,values,tDistance,tCritType, superCritMark)
					bullets[i]:markExplode(false)
                    --检测职业反伤
                    BattleMethod:checkProfessionThorns(hero, charas, values, hero:getBattleId())
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
                    WZLog("BattleMsgKidShoot:_updateBullet two-4.1", self.m_nSpringCount)
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
			WBattleGlobal:getCurrent():removeBulletById(bullets[i].m_nId)
            WZLog("BattleMsgKidShoot:_updateBullet two-4.2", bullets[i].m_nId)
		end
	end
end

--@brief	对英雄添加受伤数字(除零)
--@param	charas:英雄列表
--@param	hurtValue:受伤数字
--@return	#1:需要发送协议的英雄列表
--@return	#2:需要发送协议的伤害列表
function BattleMsgKidShoot:_charaAddHurtValue(charas,hurtValue,hurtRatios, superCritMark)
	local newCharas = {}
	local newValue = {}
	local shootHero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)

	for id,chara in pairs(charas) do
        WZLog("BattleMsgKidShoot:_charaAddHurtValue", tostring(id), tostring(chara.m_animPlayerShield), tostring(hurtValue[id]),tostring(hurtRatios[id]), superCritMark and tostring(superCritMark[id]) or "nil")
        local nTempSuperCritMark = superCritMark and superCritMark[id] and superCritMark[id] or 0
        self:_createHurtWords(hurtValue[id], chara, shootHero, hurtRatios[id], nil, nTempSuperCritMark)
		if hurtValue[id] ~= -1 and hurtValue[id] ~= 0 then
			newCharas[id] = chara
			newValue[id] = hurtValue[id]
		end
	end

    WZLog("BattleMsgKidShoot:_charaAddHurtValue", Serialize(newValue))
	return newCharas,newValue
end

--@brief 动态标记受伤
function BattleMsgKidShoot:_createHurtWords(hurtValue, chara, shootHero, hurtRatios, totalHurt, superCritMark)
    -- body
    chara:markHurt(hurtValue, shootHero,nil,nil,nil,hurtRatios, nil, totalHurt, superCritMark)
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
function BattleMsgKidShoot:_checkHitEnemy(charas, bullet, values)
    WZLog("BattleMsgKidShoot:_checkHitEnemy")
    if charas ~= nil then
        for id,chara in pairs(charas) do
            local value = chara:hurtEffectHandle(values[id])
            local bOffHurt = chara.m_bOffHurt or chara:isInBuffState(EffectTypeConfig.IMMUNITY_ATTACK)
            if chara:getBattleId() == self.m_nCurrentPlayerId or value == 0 or bOffHurt then
                WZLog("BattleMsgKidShoot:_checkHitEnemy no hit")
                if bullet.m_bIsFrozen ~= nil and bullet.m_bIsHurtPlayer == true then
                    --self.m_tFrozenEnemy = self.m_tFrozenEnemy or chara
                end
            elseif (WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_NORMAL and
             WBattleGlobal:getCurrent().m_tMakePairOk.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_LD) and
              value > 0 then
                self.m_tFirstHitEnemy = self.m_tFirstHitEnemy or chara
                WZLog("BattleMsgKidShoot:_checkHitEnemy hit1", value, chara:getBattleId(), WBattleGlobal:getCurrent():getCurrentCharacter():getBattleId())
            elseif chara:getCamp() ~= WBattleGlobal:getCurrent():getCurrentCharacter():getCamp() and value > 0 then
                WZLog("BattleMsgKidShoot:_checkHitEnemy hit2", value, chara:getHp(), chara:getBattleId(), WBattleGlobal:getCurrent():getCurrentCharacter():getBattleId())
                self.m_tFirstHitEnemy = self.m_tFirstHitEnemy or chara
            end
        end
    end
end


--@brief	是否可以移除子弹
--@param	tBullet:检测的子弹
--@return	#1:true,false
function BattleMsgKidShoot:_canRemoveBullet(tBullet, index)
    --WZLog("BattleMsgKidShoot:_canRemoveBullet zero", index)
	--飞出屏外
	if tBullet:checkOutOfScene() then
        WZLog("BattleMsgKidShoot:_canRemoveBullet one", index)
		return true
	end
	--爆炸动画播放完毕
	if tBullet:explodeIsEnd() then
        WZLog("BattleMsgKidShoot:_canRemoveBullet two", index)
		return true
	end
	--再次确认是否爆炸完毕
	if tBullet:getStatus() == BulletStatus.DEF_ST_END_EXPLODE then
        WZLog("BattleMsgKidShoot:_canRemoveBullet three", index)
		return true
	end

	if tBullet.m_bIsMark == true and tBullet:getStatus() == BulletStatus.DEF_ST_EXPLODE then
        WZLog("BattleMsgKidShoot:_canRemoveBullet four", index)
		return true
	end
	return false
end

--@brief	更新屏幕(主要是屏幕震动)
function BattleMsgKidShoot:_updateScene()
    WZLog("BattleMsgKidShoot:_updateScene 1")
	if self.m_tScreenSpring ~= nil then
        WZLog("BattleMsgKidShoot:_updateScene 2",self.m_tScreenSpring.x, self.m_tScreenSpring.y)
		BattleScreen:setSpring(self.m_tScreenSpring)
		if BattleScreen:screenSpring() == true then
            WZLog("BattleMsgKidShoot:_updateScene 3")
			self.m_tScreenSpring = nil
		end
	end
end

--@brief	设置屏幕震动
--@param	tPos:震动时的位置
function BattleMsgKidShoot:_setSceneSpring(tPos)
    WZLog("BattleMsgKidShoot:_setSceneSpring",tPos.x,tPos.y)
	self.m_tScreenSpring = {x=tPos.x,y=tPos.y}
end

--@brief	判断是否屏幕震动
--@return	＃1:true/false
function BattleMsgKidShoot:_getIsSceneSpring()
    WZLog("BattleMsgKidShoot:_getIsSceneSpring")
	return self.m_tScreenSpring ~= nil
end

--@brief	纪录发送受伤协议的参数
function BattleMsgKidShoot:_addHurtHeroAndValue(charas,values)
    WZLog("BattleMsgKidShoot:_addHurtHeroAndValue")
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
function BattleMsgKidShoot:_sendHurtProtocol(charas,values,distance,critType, superCritMark)
    local hero = self:getOwner()
    WZLog("BattleMsgKidShoot:_sendHurtProtocol one", tostring(charas), tostring(self.m_nCurrentPlayerId), tostring(hero:isCanControl()), tostring(hero.m_bLoseNet), hero:getBattleId())
    if charas == nil or not (hero:isCanControl() or hero.m_bLoseNet) then
        return
    end

    WZLog("BattleMsgKidShoot:_sendHurtProtocol two",tostring(charas),tostring(values),tostring(distance),tostring(critType))
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
function BattleMsgKidShoot:_followBullet()
	local bullet = WBattleGlobal:getCurrent():getBulletByIndex(1)
    WZLog("BattleMsgKidShoot:_followBullet",tostring(bullet))
	if bullet ~= nil then
		if self._followBullet_time_ == nil then
			self._followBullet_time_ = 0
		else
			self._followBullet_time_ = self._followBullet_time_ + SceneBattle:getBattleLoop():getBattleDeltaTime()
		end
		--if self:_getIsSceneSpring() == false then
        local tempPos = bullet:getMover():getMoverPosition()
		BattleScreen:followBullet(tempPos,self._followBullet_time_)
		--end
	elseif self.m_tFirstHitEnemy ~= nil and self.m_tFirstHitEnemy:getIsHero() and self.m_tFirstHitEnemy:getIsRepulse() then
		BattleScreen:followBullet(self.m_tFirstHitEnemy:getMover():getMoverPosition(),2)
	end
end

--@brief	是否还有子弹
--@return	#1：true：是，false：否
function BattleMsgKidShoot:_isHaveBullet()
	local bullet = WBattleGlobal:getCurrent():getBulletByIndex(1)
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
    WZLog("BattleMsgKidShoot:_isHaveBullet zero", tostring(bullet), tostring(WBattleGlobal:getCurrent().m_bIsDoEffectAfterAttack), tostring(bullet and bullet.m_bIsExplode), tostring(hero and hero.m_tSkillTakeEffectCollionInfo), tostring(hero and hero.m_tSkillTakeEffectInfo))
	if WBattleGlobal:getCurrent():getBulletByIndex(2) == nil and bullet and bullet.m_bIsExplode and hero.m_tSkillTakeEffectCollionInfo == nil and hero.m_tSkillTakeEffectInfo == nil and WBattleGlobal:getCurrent().m_bIsDoEffectAfterAttack ~= true then
        WZLog("BattleMsgKidShoot:_isHaveBullet two")
        return false
    end

    if bullet ~= nil or WBattleGlobal:getCurrent().m_bIsDoEffectAfterAttack == true then
        WZLog("BattleMsgKidShoot:_isHaveBullet one")
		return true
	end
    
	return false
end

--@brief	创建子弹
--@param	nScatterNum:散射数量
function BattleMsgKidShoot:_createBullet(nScatterNum, isProcessMapEventBubble)
    WZLog("BattleMsgKidShoot:_createBullet zero",nScatterNum, self.m_nCurrentPlayerId, WBattleGlobal:getCurrent():getMyHero():getBattleId() )

    local speedx, speedy, startX, startY = self.m_nSpeedx, self.m_nSpeedy, self.m_nStartX, self.m_nStartY

    if isProcessMapEventBubble == true then
        speedx, speedy, startX, startY = self.m_nBubbleAtkSpeedX, self.m_nBubbleAtkSpeedY, self.m_nBubbleAtkStartX, self.m_nBubbleAtkStartY
        WZLog("BattleMsgKidShoot:_createBullet two",tostring(speedx),tostring(speedy),tostring(self.m_nBubbleAtkStartX),tostring(self.m_nBubbleAtkStartY))
    end

    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
    WZLog("BattleMsgKidShoot:_createBullet three", tostring(hero:getShootSoundName()))
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
		WZLog("BattleMsgKidShoot:_createBullet",i,self.m_nStartX,self.m_nStartY,speedVec.x,speedVec.y)
		local bullet = WBattleGlobal:getCurrent():buildBullet(self.m_nCurrentPlayerId, startX, startY, speedVec.x, speedVec.y, nil, self.m_nBulletIndex)
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
        
        local owner = hero:getOwner()
        WZLog("BattleMsgKidShoot:_createBullet four", owner:isHide())
        if owner:isHide() == true then
            if WBattleGlobal:getCurrent():isReplayGame() or WBattleGlobal:getCurrent():isMyTeam(owner:getBattleId()) then
                bullet:setOpacity(51)
                WZLog("BattleMsgKidShoot:_createBullet five")
            else
                WZLog("BattleMsgKidShoot:_createBullet sex")
                bullet:setOpacity(0)
            end
            WZLog("BattleMsgKidShoot:_createBullet seven", WBattleGlobal:getCurrent().m_tIsHighEndMachine)
            if WBattleGlobal:getCurrent().m_tIsHighEndMachine == true then
                bullet:getBackFire():setVisible(false)
            end
        end

		speedVec = BattleCommon:vectorWithAngle(speedVec,BattleConstants.g_fWB_SCATTER_ANGLE)

        self.m_nBulletIndex = self.m_nBulletIndex + 1
	end
end

--@brief	屏幕显示最大范围
function BattleMsgKidShoot:_ZoomToOrigin()
    WZLog("BattleMsgKidShoot:_ZoomToOrigin")
    if WBattleGlobal:getCurrent():isGameOver() then
        return true
    end
    
    WZLog("BattleMsgKidShoot:_ZoomToOrigin one", WBattleGlobal:getCurrent().m_tGameOverHero and WBattleGlobal:getCurrent().m_tGameOverHero:getBattleId())
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
        WZLog("BattleMsgKidShoot:_ZoomToOrigin two")
    end
    
    if hero ~= nil then
        return BattleScreen:zoomToHero(hero:getBattleId(), hero:getMover():getMoverPosition(), nil, scale, speed)
    else
        return true
    end
end

--@brief 录像记录
function BattleMsgKidShoot:_recordedSingleShoot()
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
function BattleMsgKidShoot:_sendBattleShoot()
    WZLog("BattleMsgKidShoot:_sendBattleShoot")
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
        -- WZLog("BattleMsgKidShoot:_sendBattlePos",id,player:getAnimation():getPosition().x,player:getAnimation():getPosition().y)
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
    WZLog("BattleMsgKidShoot:_sendBattleShoot-2",self.m_nBattleId, self.m_nCurrentPlayerId, self.m_nSpeedx, self.m_nSpeedy, self.m_nLeftRight, self.m_nStartX, self.m_nStartY, nPlayerCount, tPlayerId, tCurPositionX, tCurPositionY,count)
    ProtocolProcessorBattleInterface:send_BATTLE_Shoot(self.m_nBattleId, self.m_nCurrentPlayerId, self.m_nSpeedx, self.m_nSpeedy, self.m_nLeftRight, self.m_nStartX, self.m_nStartY, nPlayerCount, tPlayerId, tCurPositionX, tCurPositionY, tCurPositionR, tCurPositionD, count)
end

--@brief 发送位置同步（副本战）
function BattleMsgKidShoot:_sendBossBattleShoot()
    WZLog("BattleMsgKidShoot:_sendBossBattleShoot")
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

    local count = hero:getAttTimes() * hero:getAttScatterNum()
    WZLog("BattleMsgKidShoot:_sendBossBattleShoot-2",self.m_nBattleId, self.m_nCurrentPlayerId, self.m_nSpeedx, self.m_nSpeedy, self.m_nLeftRight, self.m_nStartX, self.m_nStartY, nPlayerCount, tPlayerId, tCurPositionX, tCurPositionY,count)

    ProtocolProcessorBattleInterface:send_BATTLE_Shoot(self.m_nBattleId, self.m_nCurrentPlayerId, self.m_nSpeedx, self.m_nSpeedy, self.m_nLeftRight, self.m_nStartX, self.m_nStartY, nPlayerCount, tPlayerId, tCurPositionX, tCurPositionY, tCurPositionR, tCurPositionD,count)
end

--@brief 同步位置
function BattleMsgKidShoot:_syncBattleShoot()
    WZLog("BattleMsgKidShoot:_syncBattleShoot",self.m_nPlayerCount)
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

            WZLog("BattleMsgKidShoot:_syncBattleShoot-2",self.m_tPlayerId[i], pos.x,self.m_tCurPositionX[i], pos.y, self.m_tCurPositionY[i], rotate, self.m_tCurPositionR[i], flip, self.m_tCurPositionD[i])
        end
    end
end

--@brief 数值转换
function BattleMsgKidShoot:_float2int2float()
    WZLog("BattleMsgKidShoot:_float2int2float zero")
    self.m_nSpeedx = BattleCommon:float2int2float(self.m_nSpeedx)
    self.m_nSpeedy = BattleCommon:float2int2float(self.m_nSpeedy)
    self.m_nStartX = BattleCommon:float2int2float(self.m_nStartX)
    self.m_nStartY = BattleCommon:float2int2float(self.m_nStartY)

    for id, player in pairs(WBattleGlobal:getCurrent():getHeroList()) do
        local x = BattleCommon:float2int2float(player:getAnimation():getPosition().x)
        local y = BattleCommon:float2int2float(player:getAnimation():getPosition().y)
        local r = BattleCommon:float2int2float(player:getAnimation():getRotate())

        WZLog("BattleMsgKidShoot:_float2int2float one", player:getAnimation():getPosition().x, player:getAnimation():getPosition().y, "x, y", x, y)
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

--@brief    获取小孩的父母
function BattleMsgKidShoot:getOwner()
    -- body
    return self.m_tOwner
end

--@brief    孩子出完手，移除小孩
function BattleMsgKidShoot:_removeTheKid()
    -- body
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
    hero:_removeDeadGuai()

    return true 
end

--@brief    孩子出完手,设置孩子死亡
function BattleMsgKidShoot:_setKidDead()
    -- body
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
    if not hero:isDead() then 
        hero:setDead(true, 20)
    end

    return true 
end

