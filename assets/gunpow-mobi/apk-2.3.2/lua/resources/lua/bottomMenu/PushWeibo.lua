--PushWeibo.lua
--@brief	设置SDK管理
--@date		2014/03/25
--@author	liangguang_long
--@note		

PushWeibo = {
	SceneName = nil,
}

function PushWeibo:showWeibo(tCell)
	if tCell == nil then
		WZLog("tCell::PushWeibo:showWeibo::::",tCell)
		return
	end
	WZLog("input weibo")
	bShowWeibo = nil
	local sName = tCell:getName()
	PushWeibo.SceneName = sName
	local checkWindows = PushWeibo:checkWindows()
	if checkWindows == nil or checkWindows == false or GlobalGame.tPushWeibo == nil then
		return
	end
	if nil == GlobalGame.m_nSchedule then
		GlobalGame.m_nSchedule = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(PushWeibo.scheduleWeibo,0.2, false)
	end	
end

function PushWeibo.scheduleWeibo(t)
	WZLog("PushWeibo.scheduleWeibo1",t,GlobalGame.m_nSchedule)
	CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(GlobalGame.m_nSchedule)
	GlobalGame.m_nSchedule = nil
	WndWeibo:setShowWeibo(200000000)
end

--@brief	检查打开的窗口
function PushWeibo:checkWindows()
	local sName = PushWeibo.SceneName
	if tostring(sName) == "ScenceBattleSettlment" then   --战斗结算
		WZLog("enter::ScenceBattleSettlment::::",tostring(sName))
		return false
	elseif tostring(sName) == "SceneThrowingEggs" then
		WZLog("enter::SceneThrowingEggs:::",tostring(sName))
		return false
	elseif tostring(sName) == "SceneMyCommunity" then
		WZLog("enter::SceneMyCommunity:::",tostring(sName))
		return false
	elseif tostring(sName) == "SceneBattle" then
		WZLog("enter::SceneBattle:::",tostring(sName))
		return false
	elseif tostring(sName) == "SceneBattleLoading" then
		return false
	else
		return true
	end
end

-------------------------------------公有方法模块Begin--------------------------------------

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------







