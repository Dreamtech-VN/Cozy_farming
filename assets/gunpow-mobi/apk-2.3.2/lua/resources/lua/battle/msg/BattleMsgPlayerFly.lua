--BattleMsgPlayerFly.lua
--@brief	战斗相关消息
--@date		2013/12/31
--@author	李俊鸿
--@note		角色飞行

--@brief	消息数据表
BattleMsgPlayerFly = {
    m_sName = "BattleMsgPlayerFly",
	m_nBattleId = 0, --战斗id
	m_nPlayerId = 0, --角色id(发给哪个的)
	m_nCurrentPlayerId = 0, --角色id(当前在操作的角色）
	m_nSpeedx = 0, --飞行速度
	m_nSpeedy = 0, --飞行速度
	m_nLeftRight = 0, --1：左 0：右（向左还是向右）
	m_nIsEquip = 0, --是否道具飞行（0否1是）
	m_nStartX = 0, --飞行初始位置
	m_nStartY = 0, --飞行初始位置

	m_nPlayerCount = 0, 			--同步角色数量
	m_tPlayerId = nil, 				--用户id列表
	m_tCurPositionX = nil, 			--没飞行前的x坐标
	m_tCurPositionY = nil, 			--没飞行前的y坐标

	m_nGuaiCount = 0, 				--同步怪物数量
	m_tGuaiBattleId = nil, 		--怪物id列表
	m_tGuaiCurPositionX = nil, 		--怪物没飞行前的x坐标
	m_tGuaiCurPositionY = nil, 		--怪物没飞行前的y坐标
	--
	m_nFlickerTime = 0,		--播放闪烁时长
	m_bOutOfScene = false,	--是否飞出屏幕

	--
	SHOW_FLICKER_TIME = 0.6,
	m_bIsCollisionPre = false,
	m_bIsCollision = false,
}

-------------------------------------公有方法模块--------------------------------------

--@brief	消息初始化函数
--@note		消息系统第一次调用process函数前调用
function BattleMsgPlayerFly:init()
	self:_float2int2float()
    --录像记录
    self:_recordedSingleFly()

	WZLog("BattleMsgPlayerFly:init",self.m_nSpeedx,self.m_nSpeedy,self.m_nStartX,self.m_nStartY)

	if TeachGroup1.ISBATTLE_MYTURN ~= true and SceneBattle:getBattleLoop():getBattleStatus() ~= BattleLoop.S_NORMAL then
		return
	end

    if TeachGroup1.ISBATTLE_MYTURN then
    	WZLog("BattleMsgPlayerFly:init teach")
        TeachGroup1.ISFLY = true
    end

    WBattleGlobal:getCurrent().m_bIsCurTurnActed = true
	SceneBattle:getBattleLoop():setBattleStatus(BattleLoop.S_PLAYER_FLY)
    Teach:setVisible(false,4)
	local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
	if hero == nil then
		WZLog("BattleMsgPlayerFly:init", "can't find player:", self.m_nCurrentPlayerId)
		return
	end

    WBattleGlobal:getCurrent().m_tCurRoundAction = {round=WBattleGlobal:getCurrent().m_nTurnTimes, player=self.m_nCurrentPlayerId}

	WndBattleHud:setPassTurnBtnEnable(false)
	WndBattleHud:endTurnTime()

	--录像或直播  只同步坐标
    local isSpecBattle = false
    if WBattleGlobal:getCurrent():isAudience() or WBattleGlobal:getCurrent():isReplayGame() then
        isSpecBattle = true
    end

	if self.m_nCurrentPlayerId == WBattleGlobal:getCurrent():getMyBattleId() and not isSpecBattle then
		self:_sendBattleFly()
    elseif WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS and hero:isCanControl() and not isSpecBattle and hero:getIsGuai() then
    	self:_sendBossBattleFly()
	else
		self:_syncBattleFly()
	end
	
	--check start Position 
	
	local mover = WDMover:create()
	mover:retain()
	mover:setMoverPrePosition(Vector2:create(self.m_nStartX,self.m_nStartY))
	mover:setMoverPosition(Vector2:create(self.m_nStartX,self.m_nStartY))
	mover:setMoverSpeed(Vector2:create(0,0))
	mover:setMoverAcceleration(Vector2:create(0,0))
	local isCollision,newPos,tangent = BattleMapManager:checkCollision(mover)
	if isCollision then
		WZLog("start Position isCollision")
        if hero.m_bIsOldAnim == nil or hero.m_bIsOldAnim == true then
            hero:getAnimation():play(hero:getActionName(14),false)
        else
            hero:getAnimation():play("6",false)
        end
	else
		hero:setRunStatus(RunStatus.DEF_ST_FLY)
		hero:setPosition(Vector2:create(self.m_nStartX,self.m_nStartY))
		--hero:getMover():setMoverCollisionType(BattleConstants.g_nE_COLLISION_CIRCLE)
		hero:getMover():setMoverSpeed(Vector2:create(self.m_nSpeedx,self.m_nSpeedy))
		hero:getMover():setFly(true)
		hero:setMoveUpdatable(true)

        if hero.m_bIsOldAnim == nil or hero.m_bIsOldAnim == true then
            hero:getAnimation():play(hero:getActionName(14),true)
        else
            hero:getAnimation():play("6",true)
        end
	end

    if hero.m_angerAnim then
        hero.m_angerAnim:getAnimNode():setPositionX(70)
        hero.m_angerAnim:getAnimNode():setPositionY(280)
        WZLog("BattleMsgPlayerFly:init three")
    end
	mover:release()


    local tPos = BattleCommon:getPointTable(self.m_nStartX - 10,self.m_nStartY + 30)
    self.m_backFire = WBulletBackFire:create(tPos, BulletEffectId.EFFECT_FLY)

	if hero:isInBuffState(EffectTypeConfig.HIDE,true) ~= true then
		self.m_bHaveEffect = true
        WZLog("BattleMsgPlayerFly:init four")
        self.m_backFire:getElement():retain()
		hero:getMover():addTrackNode(self.m_backFire:getTrackNode())
		SceneBattle:getFrontLayer():addChild(self.m_backFire:getElement():getParent(),2)
	end

	hero:getAnimation():setRotate(0)
	hero:getMover():setMoverRotate(0)
	
	WZLog("BattleMsgPlayerFly:init two", tostring(self.m_backFire), tPos.x, tPos.y, hero:getMover():getMoverPosition().x, hero:getMover():getMoverPosition().y)
    if hero.m_bIsOldAnim ~= nil and hero.m_bIsOldAnim == false then
        if self.m_nLeftRight == 0 then
            hero:getAnimation():setFlipX(false)
        elseif self.m_nLeftRight == 1  then
            hero:getAnimation():setFlipX(true)
        end
    else
        if self.m_nLeftRight == 0 and hero:getAnimation():isFlipX() == true then
            hero:getAnimation():setFlipX(false)
            elseif self.m_nLeftRight == 1 and hero:getAnimation():isFlipX() == false then
            hero:getAnimation():setFlipX(true)
        end
    end
	
	
	SoundManager:playEffectSound(SoundDefine.E_S_FLY)

    WBattleGlobal.m_bHideArrow = true
end

--@brief	消息处理过程函数
--@return	#1,nil或true表示消息处理结束，否则返回false
--@note		未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgPlayerFly:process()
	if TeachGroup1.ISBATTLE_MYTURN ~= true and SceneBattle:getBattleLoop():getBattleStatus() ~= BattleLoop.S_PLAYER_FLY then
		return true
	end
	if self.m_bOutOfScene == true then
		self.m_nFlickerTime = self.m_nFlickerTime + SceneBattle:getBattleLoop():getBattleDeltaTime()
		if self.m_nFlickerTime > BattleMsgPlayerFly.SHOW_FLICKER_TIME then
			return true
		end
		return false
	end
	local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)

    if hero == nil or hero:isDead() == true then
		WZLog("BattleMsgPlayerFly:process", "can't find player:", self.m_nCurrentPlayerId, tostring(hero:isDead()))
		return true
	end

	if hero:getIsFrozen() then
		return true
	end
	
	
	local isFly = hero:getMover():isFly()
	

	-- local isCurrentAnimationDone = hero:getAnimation():isCurrentAnimationDone()
	-- if isFly == false then
	-- 	if isCurrentAnimationDone == true then
	-- 		WZLog("BattleMsgPlayerFly:process two-00")
	-- 	end
	-- 	WZLog("BattleMsgPlayerFly:process two-0")
	-- 	return isCurrentAnimationDone
	-- end
    
	--WZLog("BattleMsgPlayerFly:process", hero:getMover():getMoverSpeed().x, hero:getMover():getMoverSpeed().y, hero:getMover():getMoverPosition().x, hero:getMover():getMoverPosition().y)
	hero:setRunStatus(RunStatus.DEF_ST_FLY)

	--self.m_bIsCollisionPre = self.m_bIsCollision
	local isCollision = hero:getMover():isCollision()
	--self.m_bIsCollision = isCollision
	WZLog("BattleMsgPlayerFly:process one", tostring(self.m_bIsCollisionPre), tostring(isCollision), tostring(isFly), tostring(isCurrentAnimationDone), hero:getMover():getMoverPosition().x, hero:getMover():getMoverPosition().y)
	if isCollision == false or self.m_bIsCollisionPre == false then
		local sceneSize = SceneBattle:getFrontLayerSize()
		if self.m_bIsCollisionPre == false and (hero:getMover():getMoverPosition().x < -100 or hero:getMover():getMoverPosition().x > sceneSize.width + 100 or hero:getMover():getMoverPosition().y < -100) then
			WZLog("BattleMsgPlayerFly:done two-1")
			local oldPointX = self.m_nStartX
			local oldPointY = self.m_nStartY
			for i=1,#self.m_tPlayerId do
				if self.m_tPlayerId[i] == self.m_nCurrentPlayerId then
					oldPointX = self.m_tCurPositionX[i]
					oldPointY = self.m_tCurPositionY[i]
				end
			end
			local oldPoint = Vector2:create(oldPointX,oldPointY)
            hero:getMover():setFly(false)
			hero:setPosition(oldPoint)
			hero:getMover():setMoverPosition(oldPoint)
			hero:getMover():setMoverPrePosition(oldPoint)
			hero:getMover():setMoverSpeed(Vector2:create(0,0))
            hero:setMoveUpdatable(true)
            if self.m_backFire and self.m_bHaveEffect then
                
                --self.m_backFire:getElement():release()
                hero:getMover():removeTrackNode(self.m_backFire:getTrackNode())
                self.m_backFire:removeElement()
                self.m_backFire = nil
            end
			BattleMapManager:getFrontControl():centerOnPointWithAction(hero:getMover():getMoverPosition(),0,0.1)
			if WBattleGlobal:getCurrent():isFog() then
				BattleMapManager:getFogControl():centerOnPointWithAction(hero:getMover():getMoverPosition(),0,0.1)
			end
			self.m_bOutOfScene = true
            if hero:isHide() ~= true then
                self:_showFlicker()
            end
			
            if hero.m_bIsOldAnim == nil or hero.m_bIsOldAnim == true then
                hero:getAnimation():play(hero:getActionName(23),true)
            else
                hero:getAnimation():play("0",true)
            end

            if hero.m_angerAnim then
                hero.m_angerAnim:getAnimNode():setPositionX(90)
                hero.m_angerAnim:getAnimNode():setPositionY(230)
            end
            if isCollision then
				self.m_bIsCollisionPre = true
			end

			WBattleGlobal:getCurrent():cleanMyFog(hero)
			return false
		elseif self.m_bIsCollisionPre == true and hero:getMover():getMoverPosition().x < -100 or hero:getMover():getMoverPosition().x > sceneSize.width + 100 or hero:getMover():getMoverPosition().y < -100 then
			WZLog("BattleMsgPlayerFly:process two-2")
			if isCollision then
				self.m_bIsCollisionPre = true
			end

			WBattleGlobal:getCurrent():cleanMyFog(hero)
		elseif isCollision == true then
			WZLog("BattleMsgPlayerFly:process two-3")
			if hero.m_bIsOldAnim == nil or hero.m_bIsOldAnim == true then
		        hero:getAnimation():play(hero:getActionName(23),true)
		    else
		        hero:getAnimation():play("0",true)
		    end
			hero:getMover():setFly(false)
			hero:getAnimation():setRotate(0)
			hero:setMoveUpdatable(true)
			local follow = true
            if hero:isHide() and (not WBattleGlobal:getCurrent():isReplayGame() or not WBattleGlobal:getCurrent():isMyTeam(hero:getBattleId())) then
                follow = false
            end
            if follow then
                BattleScreen:followHero(hero:getMover():getMoverPosition())
                
            end
            if isCollision then
				self.m_bIsCollisionPre = true
			end

			WBattleGlobal:getCurrent():cleanMyFog(hero)
			return false
		else
			WZLog("BattleMsgPlayerFly:process two-4")
            local follow = true
            if hero:isHide() and (not WBattleGlobal:getCurrent():isReplayGame() or not WBattleGlobal:getCurrent():isMyTeam(hero:getBattleId())) then
                follow = false
            end
            if follow then
                BattleScreen:followHero(hero:getMover():getMoverPosition())
                
            end
            if isCollision then
				self.m_bIsCollisionPre = true
			end
			WBattleGlobal:getCurrent():cleanMyFog(hero)
			return false
		end
	end

	
	WZLog("BattleMsgPlayerFly:process three")
	if hero.m_bIsOldAnim == nil or hero.m_bIsOldAnim == true then
        hero:getAnimation():play(hero:getActionName(23),true)
    else
        hero:getAnimation():play("0",true)
    end

    if hero.m_angerAnim then
        hero.m_angerAnim:getAnimNode():setPositionX(90)
        hero.m_angerAnim:getAnimNode():setPositionY(230)
    end

    if isFly == true then
	    hero:getMover():setFly(false)
		hero:getAnimation():setRotate(0)
		hero:setMoveUpdatable(true)
	end

	WBattleGlobal:getCurrent():cleanMyFog(hero)

	--受伤 
	local isHurt, hurtOne = WBattleGlobal:getCurrent():IsAnyOneHurt()
	if isHurt then
		return false
	end
	return true
end

--@brief	消息处理完成函数
--@note		消息系统最后一次调用process函数后调用
function BattleMsgPlayerFly:done()
	WZLog("BattleMsgPlayerFly:done")
    if TeachGroup1.ISBATTLE_MYTURN then
        TeachGroup1.ISFLY = nil
    end


    WBattleGlobal.m_bHideArrow = nil
	if SceneBattle:getBattleLoop():getBattleStatus() ==  BattleLoop.S_PLAYER_FLY then
		SceneBattle:getBattleLoop():setBattleStatus(BattleLoop.S_NORMAL)
	end
	local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
	--hero:getMover():setMoverCollisionType(BattleConstants.g_nE_COLLISION_POINT)
	hero:getMover():setFly(false)

    if hero.m_bIsOldAnim == nil or hero.m_bIsOldAnim == true then
        hero:getAnimation():play(hero:getActionName(23),true)
    else
        hero:getAnimation():play("0",true)
    end

    if hero.m_angerAnim then
        hero.m_angerAnim:getAnimNode():setPositionX(90)
        hero.m_angerAnim:getAnimNode():setPositionY(230)
    end

    if self.m_backFire and self.m_bHaveEffect then
        WZLog("BattleMsgPlayerFly:done two-2")
        --self.m_backFire:getElement():release()
        hero:getMover():removeTrackNode(self.m_backFire:getTrackNode())
        self.m_backFire:removeElement()
        self.m_backFire = nil
    end
    WBattleGlobal:getCurrent():endCurRound(WBattleGlobal:getCurrent():getMyBattleId(),6,nil,nil,true)
	
	WndBattleHud:setHudBtnOpacity()
	--飞行当做命中了，增加命中次数
    hero:addHitTargetTimes()
end

--@brief	消息清理函数
function BattleMsgPlayerFly:clearAction()
	WZLog("BattleMsgPlayerFly:clearAction", self.m_backFire, self.m_bHaveEffect)
	local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
	if hero and self.m_backFire and self.m_bHaveEffect then
        hero:getMover():removeTrackNode(self.m_backFire:getTrackNode())
        self.m_backFire:removeElement()
        self.m_backFire = nil
    end
end
-------------------------------------私有方法模块--------------------------------------

function BattleMsgPlayerFly:_showFlicker()
	local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
	self.m_nFlickerTime = 0
	
	local times = 6
	local nTime = BattleMsgPlayerFly.SHOW_FLICKER_TIME / times
	local array = CCArray:create()
	for i=1,times do
		local opacity = (i%2 == 1) and 0 or 255
		local act=CCFadeTo:create(nTime,opacity)
		array:addObject(act)
	end
	hero:getAnimation():getAnimNode():runAction(CCSequence:create(array))
end

--@brief 录像记录
function BattleMsgPlayerFly:_recordedSingleFly()
    --录像记录
    WBattleGlobal:getCurrent():replayRecordSinglePos()
    
    if WBattleGlobal:getCurrent():canRecordGame() then
        local replayParam = {}
        replayParam.m_nBattleId = self.m_nBattleId
        replayParam.m_nPlayerId = self.m_nPlayerId
        replayParam.m_nCurrentPlayerId = self.m_nCurrentPlayerId
        replayParam.m_nSpeedx = self.m_nSpeedx
        replayParam.m_nSpeedy = self.m_nSpeedy
        replayParam.m_nIsEquip = self.m_nIsEquip
        replayParam.m_nLeftRight = self.m_nLeftRight
        replayParam.m_nStartX = self.m_nStartX
        replayParam.m_nStartY = self.m_nStartY
        
        BattleMsgReplayGameRecord:setPlayerFly(replayParam)
    end
end

--@brief 发送位置同步
function BattleMsgPlayerFly:_sendBattleFly()
	WZLog("BattleMsgPlayerFly:_sendBattleFly")
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
    local nPlayerCount = 0
	self.m_tPlayerId = {}
	self.m_tCurPositionX = {}
	self.m_tCurPositionY = {}
	for id, player in pairs(WBattleGlobal:getCurrent().m_tHeros) do
		table.insert(self.m_tPlayerId, id)
		table.insert(self.m_tCurPositionX, player:getMover():getMoverPosition().x)
		table.insert(self.m_tCurPositionY, player:getMover():getMoverPosition().y)
		nPlayerCount = nPlayerCount + 1
	end

	if WBattleGlobal:getCurrent():getGuaiList() ~= nil then
		for id,guai in pairs(WBattleGlobal:getCurrent():getGuaiList()) do
			table.insert(self.m_tPlayerId, id)
			table.insert(self.m_tCurPositionX, guai:getAnimation():getPosition().x)
			table.insert(self.m_tCurPositionY, guai:getAnimation():getPosition().y)
			nPlayerCount = nPlayerCount + 1
		end
	end
	ProtocolProcessorBattleInterface:send_BATTLE_Fly(self.m_nBattleId, self.m_nCurrentPlayerId, self.m_nSpeedx, self.m_nSpeedy, self.m_nLeftRight, self.m_nIsEquip, self.m_nStartX, self.m_nStartY, nPlayerCount, self.m_tPlayerId, self.m_tCurPositionX, self.m_tCurPositionY)
end

--@brief 发送位置同步（副本战）
function BattleMsgPlayerFly:_sendBossBattleFly()
	WZLog("BattleMsgPlayerFly:_sendBossBattleFly")
	local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
	local nPlayerCount = 0
	self.m_tPlayerId = {}
	self.m_tCurPositionX = {}
	self.m_tCurPositionY = {}
	for id, player in pairs(WBattleGlobal:getCurrent().m_tHeros) do
		table.insert(self.m_tPlayerId, id)
		table.insert(self.m_tCurPositionX, player:getMover():getMoverPosition().x)
		table.insert(self.m_tCurPositionY, player:getMover():getMoverPosition().y)
		nPlayerCount = nPlayerCount + 1
	end
    if WBattleGlobal:getCurrent():getGuaiList() ~= nil then
        for id,guai in pairs(WBattleGlobal:getCurrent():getGuaiList()) do
            table.insert(self.m_tPlayerId, id)
            table.insert(self.m_tCurPositionX, guai:getAnimation():getPosition().x)
            table.insert(self.m_tCurPositionY, guai:getAnimation():getPosition().y)
            nPlayerCount = nPlayerCount + 1
        end
    end
	ProtocolProcessorBattleInterface:send_BATTLE_Fly(self.m_nBattleId, self.m_nCurrentPlayerId, self.m_nSpeedx, self.m_nSpeedy, self.m_nLeftRight, self.m_nIsEquip, self.m_nStartX, self.m_nStartY, nPlayerCount, self.m_tPlayerId, self.m_tCurPositionX, self.m_tCurPositionY)
end

--@brief 同步位置
function BattleMsgPlayerFly:_syncBattleFly()
	WZLog("BattleMsgPlayerFly:_syncBattleFly")
    for i=1, self.m_nPlayerCount do
		if self.m_tPlayerId[i]~= WBattleGlobal:getCurrent():getCurrentCharacterId() then
			local _hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_tPlayerId[i])
			local pos = _hero:getPosition()

			if not _hero:isDead() and (math.abs(pos.x - self.m_tCurPositionX[i]) >= 10 or math.abs(pos.y - self.m_tCurPositionY[i]) >= 10) then 
			else
				if _hero:getMover() then
					_hero:getMover():setMoverSpeed(Vector2:create(0,0))
					_hero:setPosition({x = self.m_tCurPositionX[i] , y = self.m_tCurPositionY[i] } )
					_hero:getMover():setMoverPrePosition( Vector2:create( self.m_tCurPositionX[i] , self.m_tCurPositionY[i]) )
				end
			end
		end
	end
    for i=1, self.m_nGuaiCount do
		if self.m_tGuaiBattleId[i]~= WBattleGlobal:getCurrent():getCurrentCharacterId() then
			local _guai = WBattleGlobal:getCurrent():getGuaiWithId(self.m_tGuaiBattleId[i])
			local pos = _guai:getPosition()
			WZLog("BattleMsgPlayerFly:_syncBattleFly-2",tostring(self.m_tGuaiBattleId[i]),tostring(_guai),self.m_tGuaiCurPositionX[i],self.m_tGuaiCurPositionY[i])
			if not _guai:isDead() and (math.abs(pos.x - self.m_tGuaiCurPositionX[i]) >= 10 or math.abs(pos.y - self.m_tGuaiCurPositionY[i]) >= 10) then 
			else
				_guai:setPosition({x = self.m_tGuaiCurPositionX[i] , y = self.m_tGuaiCurPositionY[i] } )
				if _guai:getMover() then
					_guai:getMover():setMoverSpeed(Vector2:create(0,0))
					_guai:getMover():setMoverPrePosition( Vector2:create( self.m_tGuaiCurPositionX[i] , self.m_tGuaiCurPositionY[i]) )
				end
			end
		end
	end
end

--@brief 数值转换
function BattleMsgPlayerFly:_float2int2float()
    WZLog("BattleMsgPlayerFly:float2int2float")
    self.m_nSpeedx = BattleCommon:float2int2float(self.m_nSpeedx)
    self.m_nSpeedy = BattleCommon:float2int2float(self.m_nSpeedy)
    self.m_nStartX = BattleCommon:float2int2float(self.m_nStartX)
    self.m_nStartY = BattleCommon:float2int2float(self.m_nStartY)

    for id, player in pairs(WBattleGlobal:getCurrent():getHeroList()) do
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