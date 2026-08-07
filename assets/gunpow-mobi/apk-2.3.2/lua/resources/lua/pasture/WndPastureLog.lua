--WndPastureLog.lua
--@brief	WndPastureLog的UI模块
--@date		2021/04/17
--@author	hyx
--@note		牧场日记


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPastureLog:onEnter(element)
	self.m_root = element
	self:register()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPastureLog:onExit(element)
	self:unregister()
	self:_unInit()
end
function WndPastureLog:register()
	GlobalGame:getGameEventDispathcer():Add(PastureEvent.PastureEvent_GetPastureLogs,self._onGetPastureLogsInfo,self)
end
function WndPastureLog:unregister()
	GlobalGame:getGameEventDispathcer():Remove(PastureEvent.PastureEvent_GetPastureLogs,self._onGetPastureLogsInfo,self)
end
--打开界面
function WndPastureLog:showInterface()   
	local wndLog = WndPastureLog:createElement()
	if wndLog ~= nil then
	    WindowManager:addWindow(wndLog,WndPastureLog,nil,false)
	end
end
function WndPastureLog:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndPastureLog:actionCallback()
	ProtocolProcessorFamily:send_MOUNTSPASTURE_GetPastureLogs()
end

function WndPastureLog:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndPastureLog:_onGetPastureLogsInfo(optType,operateTime,operatorName,mountsLevel,mountsId)
	local logFreeListContainer = GetElement(self.m_root,"logFreeListContainer",WZUIFreeListContainer)
	logFreeListContainer:removeAll()
	if next(optType) == nil then
		ShowPanelNullTip( logFreeListContainer, LocalStrings.CHARM_RESULT)
		return
	end
	local data = self:setCellLogData(optType,operateTime,operatorName,mountsLevel,mountsId)
	for i = 1, #data do
		local element, tLuaObj = PastureLogItem:createElement()
		logFreeListContainer:pushBack(WZUIContainer:luaTo(element))
		logFreeListContainer:getMoveElement():setPositionY(logFreeListContainer:getMinPosition().y)
		tLuaObj:setLogsData(data[i])
	end
end


-------------------------------------私有方法模块End----------------------------------------
