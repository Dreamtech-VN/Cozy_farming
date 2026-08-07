--BattleMsgSomeOneDead.lua
--@brief	人物死亡消息
--@date		2013/1/28
--@author	Zjh
--@note

--@brief	消息数据表
BattleMsgSomeOneDead = {
    m_sName = "BattleMsgSomeOneDead",
	m_nBattleId = nil,
	m_nPlayerId = nil,
	m_nDeadPlayerCount = nil,
	m_tPlayerIds = nil,
	m_bFirstBlood = nil,		--是否为首杀

	m_showMedalIdx = nil,		--勋章动画

	m_tStepFunction = nil,		--步骤函数
	m_nDeadGuaiCount = nil,
	m_tGuaiBattleIds = nil,
	m_bIsShow = nil,
}

-------------------------------------公有方法模块--------------------------------------

--@brief	消息初始化函数
--@note		消息系统第一次调用process函数前调用
function BattleMsgSomeOneDead:init()
	WZLog("BattleMsgSomeOneDead:init", self.m_nDeadPlayerCount)

	SoundManager:playEffectSound(SoundDefine.E_S_PLAYERDIE)

	self.m_nDeadPlayerCount = self.m_nDeadPlayerCount or 0

	local otherTeam = true 
	for i = 1 ,self.m_nDeadPlayerCount do
        WZLog("BattleMsgSomeOneDead:init", i, self.m_tPlayerIds[i], self.m_nPlayerId)
		if self.m_nPlayerId and WBattleGlobal:getCurrent():isSameTeam(self.m_tPlayerIds[i],self.m_nPlayerId) ~= true then
			otherTeam = false
		end
		
		local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_tPlayerIds[i])
		if self.m_tPlayerIds[i] == WBattleGlobal:getCurrent():getMyBattleId() then
			SoundManager:playEffectSound(SoundDefine.E_S_PLAYERDIE)
			if WBattleGlobal:getCurrent():isFog() then
				SceneBattle:getFogLayer2():setVisible(false)
			end
		else

			SoundManager:playEffectSound(SoundDefine.E_S_KILLPLAYER)
		end
		
		WZLog("BattleMsgSomeOneDead:init two",self.m_tPlayerIds[i],hero)
        if hero then
            if hero:isDead() ~= true then
                hero:setDead(true,11)
            end
            hero:setServerDead(true)
            if hero:getType()== 0 and hero:getAnimation():isPlaying(hero:getActionName(15)) == false then 
            	hero:getAnimation():play(hero:getActionName(15),false)
            end
        end
		if hero and hero:getType()== 0 and WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_NORMAL then
			if WBattleGlobal:getCurrent().m_tMakePairOk.battleMode ~= GlobalGame.g_tBattleMode.BATTLE_MODE_FH then

				local x,y = hero:getMover():getMoverPosition().x,hero:getMover():getMoverPosition().y
				local sceneSize = SceneBattle:getFrontLayerSize()
				--[[if x<0 then
					x = 60
				elseif x>=sceneSize.width then
					x = sceneSize.width - 60
				end
				if y<0 then
					y = 100
				end--]]

				local point = Vector2:create(x,y)
				hero:setPosition(point)
				hero:getMover():setMoverPosition(point)
				hero:getMover():setMoverPrePosition(point)
				hero:getMover():setMoverSpeed(Vector2:create(0,0))

			end
		end
	end

	if self.m_bFirstBlood then
		self.m_bFirstBlood = WBattleGlobal:getCurrent().m_tMakePairOk.playerCount > 2
		self.m_bFirstBlood = self.m_bFirstBlood and not otherTeam
	end
	self.m_tStepFunction = {}
	if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_NORMAL then
		if WBattleGlobal:getCurrent().m_tMakePairOk.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_FH then
			table.insert(self.m_tStepFunction,self._reborn)
		end
		if self.m_bFirstBlood then
			table.insert(self.m_tStepFunction,self._showFirstBlood)
			table.insert(self.m_tStepFunction,self._checkFirstBlood)
		end
	end
end

--@brief	消息处理过程函数
--@return	#1,nil或true表示消息处理结束，否则返回false
--@note		未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgSomeOneDead:process()
	--WZLog("BattleMsgSomeOneDead:process")

	if #self.m_tStepFunction > 0 then
		local res = self.m_tStepFunction[1](self)
		if res == true or res == nil then
			table.remove(self.m_tStepFunction,1)
		end
		return false
	else
		return true
	end
end

--@brief	消息处理完成函数
--@note		消息系统最后一次调用process函数后调用
function BattleMsgSomeOneDead:done()
	WZLog("BattleMsgSomeOneDead:done")
	--当前回合死亡玩家
	for i,deadHero in pairs(VectorToTable(self.m_tPlayerIds)) do
        if deadHero == WBattleGlobal:getCurrent():getCurrentCharacterId() and deadHero == WBattleGlobal:getCurrent():getMyBattleId() then
        	WBattleGlobal:getCurrent():endCurRound(WBattleGlobal:getCurrent():getMyBattleId(),"someOneDead")
        	break 
        end
    end
    if WBattleGlobal:getCurrent():isDoubleTowerStage() or WBattleGlobal:getCurrent():isHostChallengeStage() then
    	for i,deadHero in pairs(VectorToTable(self.m_tPlayerIds)) do
	        if deadHero == WBattleGlobal:getCurrent():getCurrentCharacterId() and deadHero ~= WBattleGlobal:getCurrent():getMyBattleId() then
	        	WBattleGlobal:getCurrent():endCurRound(WBattleGlobal:getCurrent():getCurrentCharacter():getBattleId(), "guaiDead")
	        	break 
	        end
	    end
	end

	--组队副本11，心魔死亡，改变boss的减伤buff
	local boss = nil
	local devilGuaiNum = 0
    for i,v in pairs(WBattleGlobal:getCurrent():getCharacterList(true)) do
        if v.m_nMonsterType == MonsterType.BOSS and not v:isDead() then
           boss = v
        elseif v:isDevilGuai() and not v:isDead() then 
        	devilGuaiNum = devilGuaiNum + 1
        end
    end
    if boss and boss:isCanControl() and not WBattleGlobal:getCurrent():isGameOver() then 
    	if devilGuaiNum == 1 and boss:isInBuffById(7019) then 
			ProtocolProcessorSceneBattle:send_BATTLE_BuffChange(WBattleGlobal:getCurrent():getBattleId(), boss:getBattleId(), 1, 7019, 0, {boss:getBattleId()})
			ProtocolProcessorBattleInterface:send_BATTLE_SkillEquip(WBattleGlobal:getCurrent():getBattleId(), boss:getBattleId(), 13079, {})
    	elseif devilGuaiNum == 0 and boss:isInBuffById(7020)then 
			ProtocolProcessorSceneBattle:send_BATTLE_BuffChange(WBattleGlobal:getCurrent():getBattleId(), boss:getBattleId(), 1, 7020, 0, {boss:getBattleId()})
			for id,buff in pairs (boss.m_tBuffChangeStateList) do
                if buff.m_nID == 7020 then
                    boss:removeBuffSpecialInfluence(buff)
                    buff:removeAnime()
                    boss.m_tBuffChangeStateList[id] = nil
                    WZLog("BattleMsgSomeOneDead:done one-2",buff.m_nID)
                    break
                end
            end
    	end
    end

	if not self.m_bIsShow then
		return
	end
	
	local playerId = self.m_nPlayerId
	local PlayerIds = self.m_tPlayerIds
	local firstBlood = self.m_bFirstBlood
	local killNum = self.m_nKillNum
	local beKillId = -1
    for i,deadHero in pairs(VectorToTable(PlayerIds)) do
        local hero = WBattleGlobal:getCurrent():getCharacterWithId(deadHero)
        if hero then
	        hero.m_bServerDead = true
	        WZLog("ProtocolProcessorSceneBossBattle:parse_BATTLE_SomeOneDead m_bServerDead", i,deadHero)
	        beKillId = deadHero
	    end
    end

    if beKillId ~= -1 then
	    local isKillPre = nil
	    local showKillCount = 0
	    local list = WBattleGlobal:getCurrent().m_tKillCountList
	    if firstBlood then
	        showKillCount = 1
	    else
	        for id, count in pairs (list) do
	            if id == playerId then
	                isKillPre = true
	                if count ~= killNum and killNum > 1 then
	                    list[playerId] = killNum
	                    showKillCount = killNum
	                end
	                break
	            end
	        end
	    end
	    if isKillPre == nil then
	        list[playerId] = killNum
	    end
	    if showKillCount > 1 or firstBlood then
	        WBattleGlobal:getCurrent():showKillAni(playerId, beKillId, showKillCount)
	    end
	end
end

-------------------------------------私有方法模块--------------------------------------
--@brief	检测复活
--@return	table:重生点
function BattleMsgSomeOneDead:_reborn()
	if self.m_showMedalIdx then
		if WndBattleHud:isRunningMedalAnim()==true then
			return false
		end
	else
		self.m_showMedalIdx = 0
	end

	WZLog("BattleMsgSomeOneDead:_reborn", self.m_showMedalIdx)
	for i = self.m_showMedalIdx + 1 ,self.m_nDeadPlayerCount do
		local hero =  WBattleGlobal:getCurrent():getHeroWithId(self.m_tPlayerIds[i])
		local isLeft = not WBattleGlobal:getCurrent():isMyTeam(self.m_tPlayerIds[i])--hero:getCamp() == 1
		local nIdx
		if WBattleGlobal:getCurrent():getLeftMedal() >= WBattleGlobal:getCurrent():getNeedMedal() or WBattleGlobal:getCurrent():getRightMedal() >= WBattleGlobal:getCurrent():getNeedMedal() then
			return true
		end
		--下标继续增加 否则进入死循环
		self.m_showMedalIdx = self.m_showMedalIdx + 1
		--非玩家对象死亡（如治疗图腾过滤）
		if not hero then
			return
		end

		if isLeft then
			if WBattleGlobal:getCurrent():addLeftMedal() == false then
				return true
			end
			nIdx = WBattleGlobal:getCurrent():getLeftMedal()
		else
			if WBattleGlobal:getCurrent():addRightMedal() == false then
				return true
			end
			nIdx = WBattleGlobal:getCurrent():getRightMedal()
		end
		
		local heroPos
		heroPos = hero:getAnimation():getPosition()
		heroPos = GlobalMethod:ccp(heroPos.x,heroPos.y)
		WndBattleHud:showMedal(heroPos,isLeft,nIdx)
		

		--需要等待协议返回(主机掉线同步)
		if not WBattleGlobal:getCurrent().m_tWaitForRebornPosList then
			WBattleGlobal:getCurrent().m_tWaitForRebornPosList = {}
		end
		table.insert(WBattleGlobal:getCurrent().m_tWaitForRebornPosList,self.m_tPlayerIds[i])

		local isCanControl = false
		for id, hero in pairs (WBattleGlobal:getCurrent():getCharacterList()) do
            if hero.m_bCanControl == true then
            	isCanControl = true
            	break
            end
        end

		if (hero:isCanControl() or isCanControl and hero.m_bLoseNet) and nIdx < WBattleGlobal:getCurrent():getNeedMedal() then
			BattleMsgSomeOneDead:send_BATTLE_RebornPosition(self.m_tPlayerIds[i])
			-- local PlayerIds = WZLuaVector_int_:create()
			-- PlayerIds:push(self.m_tPlayerIds[i])

			-- local pos = self:_getRebornPoint(heroPos.x)
			-- local xV = WZLuaVector_int_:create()
			-- local yV = WZLuaVector_int_:create()

			-- xV:push(pos.x)
			-- yV:push(pos.y)

			-- ProtocolProcessorBattleInterface:send_BATTLE_RebornPosition(self.m_nBattleId, self.m_nPlayerId, 1, PlayerIds, xV, yV )
		end
		return false
	end
	return true
end

--@brief	播放首杀动画
--@return	table:重生点
function BattleMsgSomeOneDead:_showFirstBlood()
	--WBattleGlobal:getCurrent():getHeroWithId(self.m_nPlayerId):playFirstBloodAnim()

	--SoundManager:playEffectSound(SoundDefine.E_S_FIRSTKILL)
	return true
end

--@brief	检测首杀动画是否结束
--@return	table:重生点
function BattleMsgSomeOneDead:_checkFirstBlood()
	local hero = WBattleGlobal:getCurrent():getHeroWithId(self.m_nPlayerId)
	if hero:isFirstBloodDone()==false then
		return false
	end
	hero:removeFirstBloodAnim()
	self.m_bShowFirstBlood = false
	return true
end

function BattleMsgSomeOneDead:removeRebornPosList(playerId)
	if not WBattleGlobal:getCurrent().m_tWaitForRebornPosList then
		return
	end
	for i = #WBattleGlobal:getCurrent().m_tWaitForRebornPosList,1,-1 do
		local id = WBattleGlobal:getCurrent().m_tWaitForRebornPosList[i]
		if id == playerId then
			table.remove(WBattleGlobal:getCurrent().m_tWaitForRebornPosList,i)
		end
	end
	if #WBattleGlobal:getCurrent().m_tWaitForRebornPosList == 0 then
		WBattleGlobal:getCurrent().m_tWaitForRebornPosList = nil
	end 
end

function BattleMsgSomeOneDead:send_BATTLE_RebornPosition(playerId)
	local hero = WBattleGlobal:getCurrent():getHeroWithId(playerId) 
	if not hero then
		BattleMsgSomeOneDead:removeRebornPosList(playerId)
		return 
	end

	local PlayerIds = WZLuaVector_int_:create()
	PlayerIds:push(playerId)

	local pos = BattleMsgSomeOneDead:getRebornPoint(hero:getPosition().x)
	local xV = WZLuaVector_int_:create()
	local yV = WZLuaVector_int_:create()
	xV:push(pos.x)
	yV:push(pos.y)
	local battleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
	local myPlayerId = WBattleGlobal:getCurrent():getMyBattleId()
	ProtocolProcessorBattleInterface:send_BATTLE_RebornPosition(battleId, myPlayerId, 1, PlayerIds, xV, yV )
end

--@brief	获取一个重生点
--@return	table:重生点
function BattleMsgSomeOneDead:getRebornPoint(posX)
    posX = posX or 0
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))
	local pos = {}
	local mover = WDMover:create()
	mover:retain()
	mover:setMoverRadius(50)
	local flag = true
	while flag do
		pos.x = math.random(0,1300) + 250
        if math.abs(pos.x - posX) > 100 then
            pos.y = SceneBattle:getFrontLayerSize().height
            local vec = Vector2(pos.x,pos.y)
            mover:setMoverPosition(vec)
            mover:setMoverPrePosition(vec)
            if BattleMapManager:checkCollision(mover,true)==false then
                for i=pos.y,0,-1 do
                    vec.y = vec.y - 1
                    mover:setMoverPosition(vec)
                    mover:setMoverPrePosition(vec)
                    if BattleMapManager:checkCollision(mover,true)==true then
                    	vec.x = vec.x - 1
                    	mover:setMoverPosition(vec)
                    	mover:setMoverPrePosition(vec)
                    	if BattleMapManager:checkCollision(mover,true)==true then
                    		vec.x = vec.x + 2
                    		mover:setMoverPosition(vec)
                    		mover:setMoverPrePosition(vec)
                    		if BattleMapManager:checkCollision(mover,true)==true then
                        		flag = false
                        		break
                        	end
                        end
                    end
                end
            end
        end
	end
	mover:release()
	return pos
end
