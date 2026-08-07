--BattleMsgReadyStartRound.lua
--@brief    战斗相关消息
--@date     2015/7/29
--@author   mb
--@note     回合开始前准备

--@brief    消息数据表
BattleMsgReadyStartRound = {
   m_sName = "BattleMsgReadyStartRound",
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgReadyStartRound:init()
    WZLog("BattleMsgReadyStartRound:init")
    if WBattleGlobal:getCurrent():getCopyData() then
        WBattleGlobal:getCurrent():getCopyData():readyStartRound()
    end
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgReadyStartRound:process(dt)
     if WBattleGlobal:getCurrent():getCopyData() then
        return WBattleGlobal:getCurrent():getCopyData():processReadyStartRound(dt)
    end
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgReadyStartRound:done()
    WZLog("BattleMsgReadyStartRound:done")
    if WBattleGlobal:getCurrent():getCopyData() then
        WBattleGlobal:getCurrent():getCopyData():doneReadyStartRound()
    end
end

-------------------------------------私有方法模块--------------------------------------
