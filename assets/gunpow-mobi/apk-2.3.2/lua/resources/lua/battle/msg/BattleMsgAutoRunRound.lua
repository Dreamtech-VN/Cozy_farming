--BattleMsgAutoRunRound.lua
--@brief    自动战斗启动
--@date     2013/12/31
--@note     自动战斗回合开始

--@brief    消息数据表
BattleMsgAutoRunRound = {
    m_sName = "BattleMsgAutoRunRound",
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgAutoRunRound:init()
    WZLog("BattleMsgAutoRunRound:init")
    self.m_nTickTime = 20
    if WBattleGlobal:getCurrent():isMyTurn() then
    	self.m_nWaitSeconds = 0 
    else
    	self.m_nWaitSeconds = 5 
    end
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgAutoRunRound:process(dt)
    self.m_nTickTime = self.m_nTickTime - 1
    self.m_nWaitSeconds = self.m_nWaitSeconds + dt
    if self.m_nTickTime > 0 then
        return false
    end
    if GlobalGame.g_bIsAutoFightOpen and self.m_nWaitSeconds < 2 then 
    	return false
    end

    return true
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgAutoRunRound:done()
    GlobalGame:getGameEventDispathcer():Dispatch("BattleRound_Change")
end

-------------------------------------私有方法模块--------------------------------------
