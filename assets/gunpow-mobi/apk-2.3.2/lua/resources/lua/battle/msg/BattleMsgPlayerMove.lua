--BattleMsgPlayerMove.lua
--@brief	战斗相关消息
--@date		2013/12/31
--@author	李俊鸿
--@note		角色移动

--@brief	消息数据表
BattleMsgPlayerMove = {
    m_sName = "BattleMsgPlayerMove",
	m_nBattleId = 0, --战斗id
	m_nPlayerId = 0, --角色id(发给哪个的)
	m_nCurrentPlayerId = 0, --角色id(当前在操作的角色）
	m_nMovecount = 0, --移动的次数
	m_tMovestep = nil, --每一次移动X的方向（1：左，0：右）
	m_nCurPositionX = 0, --没移动前的x坐标
	m_nCurPositionY = 0, --没移动前的y坐标
	m_nMoveSpeed = 6 * 0.8, 	 --移动速度
	m_nSpeed = nil, 

	m_nProcess = 0,		--消息队列中正在处理的消息数
}

-------------------------------------公有方法模块--------------------------------------

--@brief	消息初始化函数
--@note		消息系统第一次调用process函数前调用
function BattleMsgPlayerMove:init()
    if WBattleGlobal:getCurrent():canRecordGame() then
        --录像记录
        local replayParam = {}
        replayParam.m_nBattleId = self.m_nBattleId
        replayParam.m_nCurrentPlayerId = self.m_nCurrentPlayerId
        replayParam.m_nMovecount = self.m_nMovecount
        replayParam.m_tMovestep = self.m_tMovestep
        replayParam.m_nCurPositionX = self.m_nCurPositionX
        replayParam.m_nCurPositionY = self.m_nCurPositionY
       

        BattleMsgReplayGameRecord:setPlayerMove(replayParam)
    end

    local localPlayerPos = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId):getPosition()

	BattleMsgPlayerMove.m_nProcess = BattleMsgPlayerMove.m_nProcess + 1
	
	local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
	if hero == nil then
		WZLog("BattleMsgPlayerMove:init", "can't find player:", self.m_nCurrentPlayerId)
		return
	end

	--受状态限制
	if hero:isInBuffState(EffectTypeConfig.LIMIT_MOVE) or 
		hero:isInBuffState(EffectTypeConfig.LIMIT_ONLY_TIMES_SHOOT) or
		hero:isInBuffState(EffectTypeConfig.LIMIT_ONLY_SCATTER_TIMES_SHOOT) then
		return
	end

	self.m_nSpeed = 6 * 0.8 + WBattleGlobal:getCurrent():getBattleRandNum()

    local offset = BattleCommon:getPointTable(0,2)
    if self.m_nCurrentPlayerId == WBattleGlobal:getCurrent():getMyBattleId() and (not WBattleGlobal:getCurrent():isAudience() or not WBattleGlobal:getCurrent():isReplayGame()) then
        self.m_nCurPositionX = hero:getMover():getMoverPosition().x
        self.m_nCurPositionY = hero:getMover():getMoverPosition().y
        self.m_nCurPositionX = BattleCommon:float2int2float(self.m_nCurPositionX)
        self.m_nCurPositionY = BattleCommon:float2int2float(self.m_nCurPositionY)
    
        hero:setPosition(Vector2:create(self.m_nCurPositionX + offset.x,self.m_nCurPositionY + offset.y))
    else
        hero:setPosition(Vector2:create(self.m_nCurPositionX + offset.x,self.m_nCurPositionY + offset.y))
    end

    WZLog("BattleMsgPlayerMove:init", self.m_nCurPositionX, self.m_nCurPositionY, localPlayerPos.x, localPlayerPos.y, BattleMsgPlayerMove.m_nProcess)
	if self.m_nCurrentPlayerId == WBattleGlobal:getCurrent():getMyBattleId() and (not WBattleGlobal:getCurrent():isAudience() or not WBattleGlobal:getCurrent():isReplayGame()) then
		ProtocolProcessorBattleInterface:send_BATTLE_PlayerMove(self.m_nBattleId, self.m_nCurrentPlayerId, self.m_nMovecount, self.m_tMovestep, self.m_nCurPositionX, self.m_nCurPositionY, self.m_nMoveSpeed * 10, hero:getPF())
    elseif WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS and hero:isCanControl() and hero:getIsGuai() then
        ProtocolProcessorBattleInterface:send_BATTLE_PlayerMove(self.m_nBattleId, self.m_nCurrentPlayerId, self.m_nMovecount, self.m_tMovestep, self.m_nCurPositionX, self.m_nCurPositionY, self.m_nMoveSpeed * 10, hero:getPF())
	end
end

--@brief	消息处理过程函数
--@return	#1,nil或true表示消息处理结束，否则返回false
--@note		未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgPlayerMove:process()
	WZLog("BattleMsgPlayerMove:process zero", self.m_nMovecount, self.m_tMovestep[1], BattleMsgPlayerMove.m_nProcess)
	if BattleMsgPlayerMove.m_nProcess ~= 1 then
		return false
	end

    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)

	if hero == nil then
		WZLog("BattleMsgPlayerMove:process", "can't find player:", self.m_nCurrentPlayerId)
		return
	elseif hero.m_bIsMoved == true then
		WZLog("BattleMsgPlayerMove:process", "player has been moved:", self.m_nCurrentPlayerId)
		return
	end

	--受状态限制
	if hero:isInBuffState(EffectTypeConfig.LIMIT_MOVE) or 
		hero:isInBuffState(EffectTypeConfig.LIMIT_ONLY_TIMES_SHOOT) or
		hero:isInBuffState(EffectTypeConfig.LIMIT_ONLY_SCATTER_TIMES_SHOOT) then
		return
	end

	
    if hero == WBattleGlobal:getCurrent():getMyHero() and hero.m_bIsGuaiWithSuit ~= true and hero:getPF() <=0 then
        return
    end

	if self.m_nMovecount > 0 then
		hero:setRunStatus(RunStatus.DEF_ST_MOVE)
		hero:setMoveUpdatable(true)
        if hero == WBattleGlobal:getCurrent():getMyHero() and hero.m_bIsGuaiWithSuit ~= true then

            --WZLog("BattleMsgPlayerMove:process", hero:getPF())

        end
		if hero:getAnimation():isPlaying(hero:getActionName(21)) == false or hero:getAnimation():isCurrentAnimationDone() == true then
			hero:getAnimation():play(hero:getActionName(21), false)
		end

		if (hero.m_nStopByTornado == 1 and self.m_tMovestep[1] == 1) or (hero.m_nStopByTornado == 2 and self.m_tMovestep[1] == 0) then 
			WZLog("BattleMsgPlayerMove:process 4444444", hero.m_nStopByTornado, hero:getAnimation():isFlipX(), self.m_tMovestep[1], self.m_nMovecount)
			self.m_nMovecount = self.m_nMovecount - 1
			table.remove(self.m_tMovestep ,1)

			return
		end

        if hero.m_tDialog ~= nil and hero.m_tDialog.m_tFollowObjOriginalPos ~= nil then
            
            local moveDistance = BattleCommon:getPointTable(hero:getPosition().x - hero.m_tDialog.m_tFollowObjOriginalPos.x,hero:getPosition().y - hero.m_tDialog.m_tFollowObjOriginalPos.y)
            
            hero.m_tDialog.m_root:setPositionX(hero.m_tDialog.m_tOriginalPos.x + moveDistance.x)
            hero.m_tDialog.m_root:setPositionY(hero.m_tDialog.m_tOriginalPos.y + moveDistance.y)
        end

		if self.m_tMovestep[1] == 0 then --向右移动
			hero:getMover():setMoveAcceleration(self.m_nSpeed - WBattleGlobal:getCurrent():getBattleRandNum() ,0.2)
			--hero:getMover():setMoverAcceleration(Vector2:create(3,0))
			WZLog("BattleMsgPlayerMove:process one-1", hero:getPosition().x, hero:getPosition().y, hero:getMover():getMoverAcceleration().x, hero:getMover():getMoverAcceleration().y)
			if hero:getAnimation():isFlipX() == true then
				WZLog("hero:getAnimation():setFlipY(false)")
				hero:getAnimation():setFlipX(false)
				if hero:getSkinBigSkillAnimation() then 
                    hero:getSkinBigSkillAnimation():getAnimNode():setFlipX(false)
                end
			end
		elseif self.m_tMovestep[1] == 1 then --向左移动
			hero:getMover():setMoveAcceleration(-1 * (self.m_nSpeed - WBattleGlobal:getCurrent():getBattleRandNum()),0.2)
			--hero:getMover():setMoverAcceleration(Vector2:create(-3,0))
			WZLog("BattleMsgPlayerMove:process one -2", hero:getPosition().x, hero:getPosition().y, hero:getMover():getMoverAcceleration().x, hero:getMover():getMoverAcceleration().y)
			if hero:getAnimation():isFlipX() == false then
				WZLog("hero:getAnimation():setFlipY(true)")
				hero:getAnimation():setFlipX(true)
				if hero:getSkinBigSkillAnimation() then 
                    hero:getSkinBigSkillAnimation():getAnimNode():setFlipX(true)
                end
			end
		end

		--hero:getMover():checkCollision()
		--hero:getMover():setMoveAcceleration(0,0)
		--hero:getMover():setMoverAcceleration(Vector2:create(0,hero:getMover():getMoverAcceleration().y))
		self.m_nMovecount = self.m_nMovecount - 1
		table.remove(self.m_tMovestep ,1)

		WBattleGlobal:getCurrent():cleanMyFog(hero)
	end

	if self.m_nMovecount > 0 then
		return false
	end

	return true
end

--@brief	消息处理完成函数
--@note		消息系统最后一次调用process函数后调用
function BattleMsgPlayerMove:done()
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)

	BattleMsgPlayerMove.m_nProcess = BattleMsgPlayerMove.m_nProcess - 1

    WZLog("BattleMsgPlayerMove:done", BattleMsgPlayerMove.m_nProcess)

    if WBattleGlobal:getCurrent():isFlyCopy() then
        local monster 
        for i,guai in pairs(WBattleGlobal:getCurrent():getGuaiList()) do
            monster = guai
            break
        end
        local dis = BattleCommon:pointDis(monster:getPosition(), WBattleGlobal:getCurrent():getMyHero():getPosition())
        if dis < 80 then
            monster:getAI():doAction(AiActionConfig.SKILL,{[1] = {actionParm1 = 80003}},nil,nil,nil,nil,nil,true)
            WZLog("BattleMsgPlayerMove:done zero")
        end
    end

    --场景buff
    WBattleGlobal:getCurrent():allTotemCheck()
end

-------------------------------------私有方法模块--------------------------------------
