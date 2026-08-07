--WndLoginQueue.lua
--@brief	WndLoginQueue的UI模块
--@date		2016-3-16
--@author	binshao
--@note		登录排队

-------------------------------------公有方法模块Begin--------------------------------------
--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndLoginQueue:onEnter(element)
    WZLog("WndLoginQueue:onEnter")
	self.m_root = element
end

--@brief    弹窗动画完成后的回调
function WndLoginQueue:actionCallback(element, data)
end

--@brief onEnter函数执行完成回调
function WndLoginQueue:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
     PostPlayerEvent:postEvent(PostPlayerEvent.event_openQueueUI)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndLoginQueue:onExit(element)
    WZLog("WndLoginQueue:onExit")
	self:_unInit()
end

--@brief关闭当前界面
function WndLoginQueue:onExitQueue(  )
    WndLoginSelect:cancelQueue()
    WindowManager:removeWindow(self.m_root, self, true)
end

function WndLoginQueue:showWndUI(playerCnt)
    if not self.m_root then
        local wnd = WndLoginQueue:createElement()
        WindowManager:addWindow( wnd , WndLoginQueue)
    end
    self:_update(playerCnt)
end

function WndLoginQueue:_update(playerCnt)
    local name = IPDhttpServer:getCurServerName()
    local time = self:waitTime(playerCnt)
    local info = {name,playerCnt,time }
    local str = {LocalStrings.LOGIN_QUEUE1,LocalStrings.LOGIN_QUEUE2,LocalStrings.LOGIN_QUEUE3}
    for i = 1, 3 do
        local txt = GetElement(self.m_root,"ftb"..i.."_WndLoginQueue",WZUIFreeTextBox)
        txt:setShowText(string.format(str[i],info[i]))
    end
end

function WndLoginQueue:waitTime(playerCnt)
    local playerCnt = tonumber(playerCnt)
    local min = math.ceil(playerCnt/20)
    if min > 60 then
        local hour = math.floor(min/60)
        local min = min - hour*60
        local str = hour..LocalStrings.HOUR1..min..LocalStrings.MINUTE1
        return str
    else
        local str = min..LocalStrings.MINUTE1
        return str
    end
end
-------------------------------------公有方法模块End----------------------------------------



-------------------------------------私有方法模块BEGIN----------------------------------------
-------------------------------------私有方法模块END----------------------------------------