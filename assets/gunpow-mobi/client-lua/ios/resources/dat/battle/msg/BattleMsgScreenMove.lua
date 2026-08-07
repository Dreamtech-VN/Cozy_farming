--BattleMsgScreenMove.lua
--@brief	屏幕移动消息
--@date		2013/1/8
--@author	Zjh
--@note

--@brief	消息数据表
BattleMsgScreenMove = {
    m_sName = "BattleMsgScreenMove",
	--m_nTouchId
}

-------------------------------------公有方法模块--------------------------------------

--@brief	消息初始化函数
--@note		消息系统第一次调用process函数前调用
function BattleMsgScreenMove:init()
	--WZLog("BattleMsgScreenMove:init", countScreenMove)

end

--@brief	消息处理过程函数
--@return	#1,nil或true表示消息处理结束，否则返回false
--@note		未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgScreenMove:process()
	local loop = SceneBattle:getBattleLoop()
	local touch = SceneBattle:getBattleTouch()
	local myHero = WBattleGlobal:getCurrent():getMyHero()

	if loop:getBattleStatus() == BattleLoop.S_SCREEN_MOVE or (myHero and WBattleGlobal:getCurrent():isGhostStage() and myHero:isDead()) then
		if self.m_nTouchId == 1 then
            --WZLog("BattleMsgScreenMove:process one", touch:getTouchPoint(1).x,touch:getTouchPoint(1).y)

            if touch:getTouchPoint(2) ~= nil then
                --WZLog("BattleMsgScreenMove:process three", touch:getTouchPoint(2).x,touch:getTouchPoint(2).y)
            end
            if touch:getTouchPoint(1) ~= nil then 
	            BattleMapManager:getFrontControl():moveScroll(SceneBattle:getFrontLayer():convertToNodeSpaceAuto(CCAutoPoint:create(touch:getTouchPoint(1).x,touch:getTouchPoint(1).y)))
				if WBattleGlobal:getCurrent():isFog() then
					BattleMapManager:getFogControl():moveScroll(SceneBattle:getFrontLayer():convertToNodeSpaceAuto(CCAutoPoint:create(touch:getTouchPoint(1).x,touch:getTouchPoint(1).y)))
				end
			end
		elseif self.m_nTouchId == 2 then
            --WZLog("BattleMsgScreenMove:process two",touch:getTouchPoint(2).x,touch:getTouchPoint(2).y, touch:getTouchPoint(1).x,touch:getTouchPoint(1).y)
			BattleMapManager:getFrontControl():moveScroll(SceneBattle:getFrontLayer():convertToNodeSpaceAuto(CCAutoPoint:create(touch:getTouchPoint(2).x,touch:getTouchPoint(2).y)))
			if WBattleGlobal:getCurrent():isFog() then
				BattleMapManager:getFogControl():moveScroll(SceneBattle:getFrontLayer():convertToNodeSpaceAuto(CCAutoPoint:create(touch:getTouchPoint(2).x,touch:getTouchPoint(2).y)))
			end
		end
	end

	return true
end

--@brief	消息处理完成函数
--@note		消息系统最后一次调用process函数后调用
function BattleMsgScreenMove:done()
	--WZLog("BattleMsgScreenMove:done")
end

-------------------------------------私有方法模块--------------------------------------
