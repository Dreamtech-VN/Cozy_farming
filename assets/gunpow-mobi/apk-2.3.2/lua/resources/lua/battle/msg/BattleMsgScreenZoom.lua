--BattleMsgScreenZoom.lua
--@brief	屏幕放缩消息
--@date		2013/1/14
--@author	Zjh
--@note

--@brief	消息数据表
BattleMsgScreenZoom = {
    m_sName = "BattleMsgScreenZoom",
}

-------------------------------------公有方法模块--------------------------------------

--@brief	消息初始化函数
--@note		消息系统第一次调用process函数前调用
function BattleMsgScreenZoom:init()
	WZLog("BattleMsgScreenZoom:init")
end

--@brief	消息处理过程函数
--@return	#1,nil或true表示消息处理结束，否则返回false
--@note		未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgScreenZoom:process()
	WZLog("BattleMsgScreenZoom:process")
	local loop = SceneBattle:getBattleLoop()
	local touch = SceneBattle:getBattleTouch()
	
	if loop:getBattleStatus() == BattleLoop.S_SCREEN_ZOOM then
		BattleMapManager:getFrontControl():moveZoom(touch:getTouchPoint(1),touch:getTouchPoint(2))
		if WBattleGlobal:getCurrent():isFog() then
			BattleMapManager:getFogControl():moveZoom(touch:getTouchPoint(1),touch:getTouchPoint(2))
		end
	end

	return true
end

--@brief	消息处理完成函数
--@note		消息系统最后一次调用process函数后调用
function BattleMsgScreenZoom:done()
	WZLog("BattleMsgScreenZoom:done")
end

-------------------------------------私有方法模块--------------------------------------
