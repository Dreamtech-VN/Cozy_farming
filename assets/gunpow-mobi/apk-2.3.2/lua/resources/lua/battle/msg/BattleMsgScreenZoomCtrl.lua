--BattleMsgScreenZoomCtrl.lua
--@brief	屏幕放缩控制消息
--@date		2013/1/14
--@author	Zjh
--@note

--@brief	消息数据表
BattleMsgScreenZoomCtrl = {
    m_sName = "BattleMsgScreenZoomCtrl",

}

-------------------------------------公有方法模块--------------------------------------

--@brief	消息初始化函数
--@note		消息系统第一次调用process函数前调用
function BattleMsgScreenZoomCtrl:init()
	WZLog("BattleMsgScreenZoomCtrl:init")

	local loop = SceneBattle:getBattleLoop()

	if loop:getBattleStatus() == BattleLoop.S_NORMAL then
		loop:setBattleStatus(BattleLoop.S_SCREEN_ZOOM)
		local touch = SceneBattle:getBattleTouch()
        if touch:getTouchPoint(1) ~= nil and touch:getTouchPoint(2) ~= nil then
            BattleMapManager:getFrontControl():beginZoom(touch:getTouchPoint(1),touch:getTouchPoint(2))
            if WBattleGlobal:getCurrent():isFog() then
            	BattleMapManager:getFogControl():beginZoom(touch:getTouchPoint(1),touch:getTouchPoint(2))
        	end
        end
	end

    hero = WBattleGlobal:getCurrent():getCurrentCharacter()
    if hero.m_bIsReadyShoot == true then
        hero.m_bIsReadyShoot = nil
        hero:playEndShootAnim()
    end
end

--@brief	消息处理过程函数
--@return	#1,nil或true表示消息处理结束，否则返回false
--@note		未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgScreenZoomCtrl:process()
	--WZLog("BattleMsgScreenZoomCtrl:process")
	local touch = SceneBattle:getBattleTouch()
	local loop = SceneBattle:getBattleLoop()

	if MsgManager:hasNewBlockMsg() then
		return true
	end

	if loop:getBattleStatus() == BattleLoop.S_SCREEN_ZOOM then
		if touch:getTouchPoint(1) ~= nil and touch:getTouchPoint(2) ~= nil and touch:getTouchStatus(1) == BattleTouch.TOUCH_HOLD and touch:getTouchStatus(2) == BattleTouch.TOUCH_HOLD then
			local msg = MsgManager:createMsg(BattleMsgScreenZoom)
			MsgManager:pushNonBlockMsg(msg)
			return false
		end
	end

	return true
end

--@brief	消息处理完成函数
--@note		消息系统最后一次调用process函数后调用
function BattleMsgScreenZoomCtrl:done()
	WZLog("BattleMsgScreenZoomCtrl:done")
	local loop = SceneBattle:getBattleLoop()
	local touch = SceneBattle:getBattleTouch()
    loop:setBattleStatus(BattleLoop.S_NORMAL)
	if loop:getBattleStatus() == BattleLoop.S_SCREEN_ZOOM and touch:getTouchPoint(1) ~= nil and touch:getTouchPoint(2) ~= nil then
		BattleMapManager:getFrontControl():endZoom(touch:getTouchPoint(1),touch:getTouchPoint(2))
		if WBattleGlobal:getCurrent():isFog() then
			BattleMapManager:getFogControl():endZoom(touch:getTouchPoint(1),touch:getTouchPoint(2))
		end
		WndBattleHud:setHudBtnOpacity()
	end
end

-------------------------------------私有方法模块--------------------------------------
