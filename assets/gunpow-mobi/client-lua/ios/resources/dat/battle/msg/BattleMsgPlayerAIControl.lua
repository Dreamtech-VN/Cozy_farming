--BattleMsgPlayerAIControl.lua
--@brief	战斗ai转移消息
--@date		2016/4/11
--@author	mjf
--@note

--@brief	消息数据表
BattleMsgPlayerAIControl = {
    m_sName = "BattleMsgPlayerAIControl",
    m_nCount = 0,		--人数
	m_nPlayerIds = 0, --角色id
}

-------------------------------------公有方法模块--------------------------------------

--@brief	消息初始化函数
--@note		消息系统第一次调用process函数前调用
function BattleMsgPlayerAIControl:init()
	WZLog("BattleMsgPlayerAIControl:init")

	local idcount = self.m_nCount
	local playerIds = self.m_nPlayerIds
	local currentPlayer = WBattleGlobal:getCurrent():getCurrentCharacter()
    if idcount ~= 0 then
    	--会变AI的玩法   掉线处理
        for i = 1, idcount do
            local hero = WBattleGlobal:getCurrent():getHeroWithId(playerIds[i])
            WZLog("BattleMsgPlayerAIControl:init two", playerIds[i])
            if hero == nil then
                WZLog("BattleMsgPlayerAIControl:init", "can't find player:", playerIds[i])
            else
	            if currentPlayer and currentPlayer:getType() == 0 and currentPlayer == hero and WBattleGlobal:getCurrent().m_bIsStartBattle and hero:isDead() ~= true then
	                local curRoundAction = WBattleGlobal:getCurrent().m_tCurRoundAction
	                WZLog("BattleMsgPlayerAIControl:init three", playerIds[i], tostring(curRoundAction and curRoundAction.round))
	                --当前回合没有行动过
                    if curRoundAction == nil or curRoundAction.round ~= WBattleGlobal:getCurrent().m_nTurnTimes then
                        WZLog("BattleMsgPlayerAIControl:init four", playerIds[i])
                        WBattleGlobal:getCurrent():endCurRound(playerIds[i],15,nil,nil)
                    end
	            end
            end
        end
    end

    --复活协议补发
    if WBattleGlobal:getCurrent().m_tWaitForRebornPosList and #WBattleGlobal:getCurrent().m_tWaitForRebornPosList > 0 then
        for i = 1,#WBattleGlobal:getCurrent().m_tWaitForRebornPosList do
            local playerId = WBattleGlobal:getCurrent().m_tWaitForRebornPosList[i]
            BattleMsgSomeOneDead:send_BATTLE_RebornPosition(playerId)
        end
    end
end

--@brief	消息处理过程函数
--@return	#1,nil或true表示消息处理结束，否则返回false
--@note		未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgPlayerAIControl:process()
	WZLog("BattleMsgPlayerAIControl:process")
end

--@brief	消息处理完成函数
--@note		消息系统最后一次调用process函数后调用
function BattleMsgPlayerAIControl:done()
	WZLog("BattleMsgPlayerAIControl:done")
end

-------------------------------------私有方法模块--------------------------------------
