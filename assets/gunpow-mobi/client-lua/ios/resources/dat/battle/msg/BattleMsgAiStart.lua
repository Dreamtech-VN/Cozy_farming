--BattleMsgAiStart.lua
--@brief    ai控制权转移
--@date     2016/09/17
--@note     怪物ai控制权（要等技能同步消息处理结束）

--@brief    消息数据表
BattleMsgAiStart = {
    m_sName = "BattleMsgAiStart",
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgAiStart:init()
    WZLog("BattleMsgAiStart:init")
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgAiStart:process()
	if self:waitMonsterClear() then
		return false
	end
	return true
end

--@brief 等待怪物移除
function BattleMsgAiStart:waitMonsterClear()
	local list = WBattleGlobal:getCurrent():getGuaiList()
	for id,monster in pairs(list) do
		if monster.m_bServerDead then
			return true
		end
	end
	return false
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgAiStart:done()
	WZLog("BattleMsgAiStart:done")
	--ai启动重置
    WBattleGlobal:getCurrent():resetAIData()
end

-------------------------------------私有方法模块--------------------------------------
