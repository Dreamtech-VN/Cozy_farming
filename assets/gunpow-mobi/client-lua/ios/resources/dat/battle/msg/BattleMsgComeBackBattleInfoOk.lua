--BattleMsgComeBackBattleInfoOk.lua
--@brief    掉线重连同步信息
--@date     2016/04/19
--@note     掉线重连同步信息

--@brief    消息数据表
BattleMsgComeBackBattleInfoOk = {
    m_sName = "BattleMsgComeBackBattleInfoOk",
    m_nPlayerId = nil,
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgComeBackBattleInfoOk:init()
    WBattleGlobal:getCurrent().m_nComeBackBattleId = -1
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nPlayerId)
    WZLog("BattleMsgComeBackBattleInfoOk:init", tostring(hero.m_bLoseNet))
	if hero.m_bLoseNet == true then
	    hero.m_bLoseNet = false
	    BattleCtbManager:setExit(self.m_nPlayerId, false)
	    MsgBoxManager:showTipBox(string.format(LocalStrings.BATTLE_OTHER_RELINK_OK,hero.m_sPlayerName),nil,nil,nil,nil,nil,nil,nil,true)
	end
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgComeBackBattleInfoOk:process()
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgComeBackBattleInfoOk:done()
end

-------------------------------------私有方法模块--------------------------------------
