--BattleMsgAiControlChange.lua
--@brief    ai控制权转移
--@date     2016/04/19
--@note     怪物ai控制权（要等技能同步消息处理结束）

--@brief    消息数据表
BattleMsgAiControlChange = {
    m_sName = "BattleMsgAiControlChange",
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgAiControlChange:init()
    WZLog("BattleMsgAiControlChange:init")
    local currentPlayer = WBattleGlobal:getCurrent():getCurrentCharacter()
    WBattleGlobal:getCurrent().m_nHostBattleId = self.m_nbattleId
    if currentPlayer and currentPlayer:getType() == 1 then
        currentPlayer:getAI():aiCtrlChange()
    end
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgAiControlChange:process()
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgAiControlChange:done()
end

-------------------------------------私有方法模块--------------------------------------
