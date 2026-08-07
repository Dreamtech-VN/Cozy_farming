--BattleMsgPlayerExit.lua
--@brief	战斗逃跑消息
--@date		2013/3/11
--@author	Zjh
--@note

--@brief	消息数据表
BattleMsgPlayerExit = {
    m_sName = "BattleMsgPlayerExit",
	m_nBattleId = 0, --战斗id
	m_nPlayerId = 0, --角色id
}

-------------------------------------公有方法模块--------------------------------------

--@brief	消息初始化函数
--@note		消息系统第一次调用process函数前调用
function BattleMsgPlayerExit:init()
	WZLog("BattleMsgPlayerExit:init", tostring(self.m_bIsQuit))

	if self.m_nPlayerId == WBattleGlobal:getCurrent():getCurrentCharacterId() then
		local currentPlayer = WBattleGlobal:getCurrent():getCurrentCharacter()

	    if currentPlayer and currentPlayer:getType() == 0 and WBattleGlobal:getCurrent().m_bIsStartBattle and currentPlayer:isDead() ~= true then
	        local curRoundAction = WBattleGlobal:getCurrent().m_tCurRoundAction

	        --不会变AI的玩法   掉线处理
	    	local curRoundAction = WBattleGlobal:getCurrent().m_tCurRoundAction
	    	--当前回合没有行动过
	        if curRoundAction == nil or curRoundAction.round ~= WBattleGlobal:getCurrent().m_nTurnTimes then
	            WZLog("SceneBattleLoading:receiveAIControlCommon four", self.m_nPlayerId)
	            WBattleGlobal:getCurrent():endCurRound(self.m_nPlayerId,15,nil,nil,true)
	        end
    	end
    end

    if WBattleGlobal:getCurrent().m_nComeBackBattleId ~= self.m_nPlayerId then
	    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nPlayerId)
	    if hero and hero:isDead() ~= true then
	        BattleCtbManager:setExit(self.m_nPlayerId, true, self.m_bIsQuit)
	    end
	    if hero then
	    	hero.m_bLoseNet = true
		end
	end
end

--@brief	消息处理过程函数
--@return	#1,nil或true表示消息处理结束，否则返回false
--@note		未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgPlayerExit:process()
	WZLog("BattleMsgPlayerExit:process")
	if not WBattleGlobal:getCurrent():isAudience() and not WBattleGlobal:getCurrent():isReplayGame() and self.m_nPlayerId == WBattleGlobal:getCurrent():getMyBattleId() then
		MsgBoxManager:showConfirmBox(LocalStrings.BATTLE_RECONNECT_FAIL, SceneBattle, SceneBattle.leftBattle, MSGBOXLEVEL_NORMAL, nil, true)
	end

    if self.m_bIsQuit then
        WBattleGlobal:getCurrent():setHeroExitWithId(self.m_nPlayerId)
    end
end

--@brief	消息处理完成函数
--@note		消息系统最后一次调用process函数后调用
function BattleMsgPlayerExit:done()
	WZLog("BattleMsgPlayerExit:done")
end

-------------------------------------私有方法模块--------------------------------------
