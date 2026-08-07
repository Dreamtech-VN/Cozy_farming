--BattleMsgGhostMove.lua
--@brief	战斗相关消息
--@date		2013/12/31
--@author	李俊鸿
--@note		角色移动

--@brief	消息数据表
BattleMsgGhostMove = {
    m_sName = "BattleMsgGhostMove",
	m_nBattleId = 0, --战斗id
	m_nPlayerId = 0, --角色id(发给哪个的)
	m_nCurrentPlayerId = 0, --角色id(当前在操作的角色）
	m_nMovecount = 0, --移动的次数
	m_tMovestep = nil, --每一次移动的方向（1：左，0：右）
	m_nCurPositionX = 0, --没移动前的x坐标
	m_nCurPositionY = 0, --没移动前的y坐标
	m_tMovestepY = nil, --每一次移动Y的方向（1：下，0：上）
	m_nAddYRate = nil, 	--角度
	
	m_nProcess = 0,		--消息队列中正在处理的消息数
}

-------------------------------------公有方法模块--------------------------------------

--@brief	消息初始化函数
--@note		消息系统第一次调用process函数前调用
function BattleMsgGhostMove:init()
    if WBattleGlobal:getCurrent():canRecordGame() then
        --录像记录
        local replayParam = {}
        replayParam.m_nBattleId = self.m_nBattleId
        replayParam.m_nCurrentPlayerId = self.m_nCurrentPlayerId
        replayParam.m_nMovecount = self.m_nMovecount
        replayParam.m_tMovestep = self.m_tMovestep
        replayParam.m_tMovestepY = self.m_tMovestepY
        replayParam.m_nCurPositionX = self.m_nCurPositionX
        replayParam.m_nCurPositionY = self.m_nCurPositionY
        replayParam.m_nAddYRate = self.m_nAddYRate

        BattleMsgReplayGameRecord:setPlayerMove(replayParam)
    end

    local localPlayerPos = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId):getPosition()

	BattleMsgGhostMove.m_nProcess = BattleMsgGhostMove.m_nProcess + 1
	
	local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
	if hero == nil then
		WZLog("BattleMsgGhostMove:init", "can't find player:", self.m_nCurrentPlayerId)
		return
	end

    local offset = BattleCommon:getPointTable(0,2)
    if hero:isCanControl() and (not WBattleGlobal:getCurrent():isAudience() or not WBattleGlobal:getCurrent():isReplayGame()) then
        self.m_nCurPositionX = hero:getMover():getMoverPosition().x
        self.m_nCurPositionY = hero:getMover():getMoverPosition().y
        self.m_nCurPositionX = BattleCommon:float2int2float(self.m_nCurPositionX)
        self.m_nCurPositionY = BattleCommon:float2int2float(self.m_nCurPositionY)

        hero:setPosition(Vector2:create(self.m_nCurPositionX + offset.x,self.m_nCurPositionY + offset.y))
    else
        hero:setPosition(Vector2:create(self.m_nCurPositionX + offset.x,self.m_nCurPositionY + offset.y))
    end

    WZLog("BattleMsgGhostMove:init", self.m_nCurPositionX, self.m_nCurPositionY, localPlayerPos.x, localPlayerPos.y, BattleMsgGhostMove.m_nProcess)

	if hero:isCanControl() and (not WBattleGlobal:getCurrent():isAudience() or not WBattleGlobal:getCurrent():isReplayGame()) then
		local addYRate = BattleUtil:float2int(self.m_nAddYRate)
		self.m_nAddYRate = BattleUtil:int2float(addYRate)
		ProtocolProcessorSceneBattle:send_BATTLE_GhostMove(self.m_nBattleId, self.m_nCurrentPlayerId, self.m_nMovecount, self.m_tMovestep, self.m_nCurPositionX, self.m_nCurPositionY, self.m_tMovestepY, BattleUtil:float2int(self.m_nAddYRate))
	end
end

--@brief	消息处理过程函数
--@return	#1,nil或true表示消息处理结束，否则返回false
--@note		未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgGhostMove:process()
	WZLog("BattleMsgGhostMove:process zero", self.m_nMovecount, self.m_tMovestep[1], BattleMsgGhostMove.m_nProcess, self.m_tMovestepY[1], self.m_nAddYRate)

    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)

	if self.m_nMovecount > 0 then
		-- hero:setRunStatus(RunStatus.DEF_ST_MOVE)
		-- hero:setMoveUpdatable(true)

        local speed = 15
        local nCurPositionX, nCurPositionY
		if self.m_tMovestep[1] == 0 then --向右移动
			nCurPositionX = self.m_nCurPositionX + speed * math.cos(self.m_nAddYRate)
			if hero:getAnimation():isFlipX() == true then
				WZLog("hero:getAnimation():setFlipY(false)")
				hero:getAnimation():setFlipX(false)
			end
		elseif self.m_tMovestep[1] == 1 then --向左移动
			nCurPositionX = self.m_nCurPositionX - speed * math.cos(self.m_nAddYRate)
			if hero:getAnimation():isFlipX() == false then
				WZLog("hero:getAnimation():setFlipY(true)")
				hero:getAnimation():setFlipX(true)
			end
		end

		nCurPositionY = self.m_nCurPositionY + speed * math.sin(self.m_nAddYRate)

		hero:setPosition(Vector2:create(nCurPositionX, nCurPositionY))

		self.m_nMovecount = self.m_nMovecount - 1
		table.remove(self.m_tMovestep ,1)
		table.remove(self.m_tMovestepY ,1)

		WBattleGlobal:getCurrent():cleanMyFog(hero)
	end

	if self.m_nMovecount > 0 then
		return false
	end

	return true
end

--@brief	消息处理完成函数
--@note		消息系统最后一次调用process函数后调用
function BattleMsgGhostMove:done()
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)

	BattleMsgGhostMove.m_nProcess = BattleMsgGhostMove.m_nProcess - 1

    WZLog("BattleMsgGhostMove:done", BattleMsgGhostMove.m_nProcess)
end

-------------------------------------私有方法模块--------------------------------------
