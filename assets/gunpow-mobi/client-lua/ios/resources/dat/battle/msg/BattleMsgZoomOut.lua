--BattleMsgZoomOut.lua
--@brief	屏幕最小化消息
--@date		2013/2/19
--@author	Zjh
--@note

--@brief	消息数据表
BattleMsgZoomOut = {
    m_sName = "BattleMsgZoomOut",
	m_tCenterPos, 	--镜头对准的中心位置，默认场景中间
	m_tOffset,		--偏移位置
}

-------------------------------------公有方法模块--------------------------------------

--@brief	消息初始化函数
--@note		消息系统第一次调用process函数前调用
function BattleMsgZoomOut:init()
	WZLog("BattleMsgZoomOut:init")
	local loop = SceneBattle:getBattleLoop()

	if loop:getBattleStatus() == BattleLoop.S_NORMAL then
		loop:setBattleStatus(BattleLoop.S_ZOOM_OUT)
		BattleScreen:resetZoomOut()
	end
end

--@brief	消息处理过程函数
--@return	#1,nil或true表示消息处理结束，否则返回false
--@note		未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgZoomOut:process()
	--WZLog("BattleMsgZoomOut:process")
	
	local loop = SceneBattle:getBattleLoop()
	
	if loop:getBattleStatus() == BattleLoop.S_ZOOM_OUT then
		return BattleScreen:zoomOut(self.m_tCenterPos,self.m_tOffset)
	end

	return true
end

--@brief	消息处理完成函数
--@note		消息系统最后一次调用process函数后调用
function BattleMsgZoomOut:done()
	WZLog("BattleMsgZoomOut:done")
	local loop = SceneBattle:getBattleLoop()

	if loop:getBattleStatus() == BattleLoop.S_ZOOM_OUT then
		loop:setBattleStatus(BattleLoop.S_NORMAL)
	end
end

-------------------------------------私有方法模块--------------------------------------
