--BattleMsgScreenMoveCtrl.lua
--@brief	屏幕移动控制消息
--@date		2013/1/8
--@author	Zjh
--@note

--@brief	消息数据表
BattleMsgScreenMoveCtrl = {
    m_sName = "BattleMsgScreenMoveCtrl",
	--m_nTouchId
}

-------------------------------------公有方法模块--------------------------------------

--@brief	消息初始化函数
--@note		消息系统第一次调用process函数前调用
function BattleMsgScreenMoveCtrl:init()
	WZLog("BattleMsgScreenMoveCtrl:init")

	local loop = SceneBattle:getBattleLoop()
	local myHero = WBattleGlobal:getCurrent():getMyHero()
	if not (myHero and WBattleGlobal:getCurrent():isGhostStage() and myHero:isDead()) then 
		if loop:getBattleStatus() == BattleLoop.S_NORMAL then
			local touch = SceneBattle:getBattleTouch()
			if self.m_nTouchId == 1 or self.m_nTouchId == 2 then
				local point = touch:getTouchPoint(self.m_nTouchId)
				if point then
					--BattleMapManager:getFrontControl():beginScroll(SceneBattle:getFrontLayer():convertToNodeSpace(GlobalMethod:ccp(point.x,point.y)))
					loop:setBattleStatus(BattleLoop.S_SCREEN_MOVE)
				end
			end
		end
	end
end

--@brief	消息处理过程函数
--@return	#1,nil或true表示消息处理结束，否则返回false
--@note		未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgScreenMoveCtrl:process()
	--WZLog("BattleMsgScreenMoveCtrl:process")
	local touch = SceneBattle:getBattleTouch()
	local loop = SceneBattle:getBattleLoop()

	local myHero = WBattleGlobal:getCurrent():getMyHero()

	if not (myHero and WBattleGlobal:getCurrent():isGhostStage() and myHero:isDead()) then 
		if MsgManager:hasNewBlockMsg() then
			return true
		end
	end

	if loop:getBattleStatus() == BattleLoop.S_SCREEN_MOVE or (myHero and WBattleGlobal:getCurrent():isGhostStage() and myHero:isDead()) then
		if touch:getTouchStatus(1) ~= BattleTouch.TOUCH_NONE or touch:getTouchStatus(2) ~= BattleTouch.TOUCH_NONE then
			if self.m_nTouchId == 1 then
				if touch:getTouchStatus(1) ~= BattleTouch.TOUCH_NONE and touch:getTouchStatus(2) == BattleTouch.TOUCH_NONE then
					local msg = MsgManager:createMsg(BattleMsgScreenMove)
					msg.m_nTouchId = 1
					MsgManager:pushNonBlockMsg(msg)
					return false
				end
			elseif self.m_nTouchId == 2 then
				if touch:getTouchStatus(2) ~= BattleTouch.TOUCH_NONE and touch:getTouchStatus(1) == BattleTouch.TOUCH_NONE then
					local msg = MsgManager:createMsg(BattleMsgScreenMove)
					msg.m_nTouchId = 2
					MsgManager:pushNonBlockMsg(msg)
					return false
				end
			end
		end
	end

	return true
end

--@brief	消息处理完成函数
--@note		消息系统最后一次调用process函数后调用
function BattleMsgScreenMoveCtrl:done()
	WZLog("BattleMsgScreenMoveCtrl:done")
	local loop = SceneBattle:getBattleLoop()
	local myHero = WBattleGlobal:getCurrent():getMyHero()
	if not (myHero and WBattleGlobal:getCurrent():isGhostStage() and myHero:isDead()) then 
		if loop:getBattleStatus() == BattleLoop.S_SCREEN_MOVE then
			loop:setBattleStatus(BattleLoop.S_NORMAL)
			BattleMapManager:getFrontControl():endScroll()
			if WBattleGlobal:getCurrent():isFog() then
				BattleMapManager:getFogControl():endScroll()
			end
			WndBattleHud:setHudBtnOpacity()
		end
	else
		BattleMapManager:getFrontControl():endScroll()
		if WBattleGlobal:getCurrent():isFog() then
			BattleMapManager:getFogControl():endScroll()
		end
		WndBattleHud:setHudBtnOpacity()
	end
end

-------------------------------------私有方法模块--------------------------------------
