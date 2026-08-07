--BattleMsgAddBuff.lua
--@brief	战斗相关消息
--@date		2016/6/30
--@author	莫剑峰
--@note		加buff

--@brief	消息数据表
BattleMsgAddBuff = {
    m_sName = "BattleMsgAddBuff",

    m_tData = nil,
}

-------------------------------------公有方法模块--------------------------------------

--@brief	消息初始化函数
--@note		消息系统第一次调用process函数前调用
function BattleMsgAddBuff:init()
	WZLog("BattleMsgAddBuff:init")

    local hero = WBattleGlobal:getCurrent():getCurrentHero()
    WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_OtherSkillEquip",playerId , item_id, tostring(hero and hero:isCanControl()), tostring(WBattleGlobal:getCurrent():isAudience()))
    local round = WBattleGlobal:getCurrent().m_nTurnTimes

    if self.m_tData.useType == 0 then
        WZLog("BattleMsgAddBuff:add buff")
        WBattleGlobal:getCurrent().m_nBuffAddRound = round

        WBattleGlobal:getCurrent().m_nBuffAddId = buffId

        WBattleGlobal:getCurrent().m_tBuffAddPlayerList = WBattleGlobal:getCurrent().m_tBuffAddPlayerList or {}

        table.insert(WBattleGlobal:getCurrent().m_tBuffAddPlayerList, {round=round,playerId=self.m_tData.playerId,buffId=self.m_tData.buffId,userId=self.m_tData.userId})
    else
        WZLog("BattleMsgAddBuff:remove buff")
        if WBattleGlobal:getCurrent().m_tBuffAddPlayerList then
            local index = nil
            for i, buffPlayer in pairs (WBattleGlobal:getCurrent().m_tBuffAddPlayerList) do
                if buffPlayer.round == round and buffPlayer.buffId == self.m_tData.buffId and buffPlayer.playerId == self.m_tData.playerId then
                    index = i
                    break
                end
            end
            if index then
                table.remove(WBattleGlobal:getCurrent().m_tBuffAddPlayerList,index)
            end
        end
    end

end

--@brief	消息处理过程函数
--@return	#1,nil或true表示消息处理结束，否则返回false
--@note		未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgAddBuff:process()
	WZLog("BattleMsgAddBuff:process")
end

--@brief	消息处理完成函数
--@note		消息系统最后一次调用process函数后调用
function BattleMsgAddBuff:done()
	WZLog("BattleMsgAddBuff:done")
end

-------------------------------------私有方法模块--------------------------------------