--WndPvpRankLog.lua
--@brief	WndPvpRankLog的UI模块
--@date		2015-11-13
--@author	binshao
--@note		排位赛战绩日志

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPvpRankLog:onEnter(element)
	self.m_root = element
end

----@brief onEnter函数执行完成回调
function WndPvpRankLog:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
end

----@brief    弹窗动画完成后的回调
function WndPvpRankLog:actionCallback(element, data)
    WZLog("----------------getLog---------------------")
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPvpRankLog:onExit(element)
	self:_unInit()
end

--@brief	点击关闭按钮时被调用的函数
--@param	element:按钮绑定的UI节点引用
function WndPvpRankLog:OnClose(element)
    WZLog("WndPvpRankLog:onClose")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManagerAni:createCloseAction(self.m_root, "onActionCallBack", self)
end

--@brief	动画播完后的回调
function WndPvpRankLog:onActionCallBack()
	WindowManager:removeWindow(self.m_root, self, true)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    更新界面
function WndPvpRankLog:_update()
    local noLog = #self.data == 0 and true or false
    local con = GetElement(self.m_root, "conNoLog_WndPvpRankList", WZUIContainer)
    con:setVisible(noLog)

    local tab = GetElement(self.m_root, "tabLog_WndPvpRankList", WZUITableContainer)
    tab:cleanTable()
    for i = 1, #self.data do
        local cell,tcell = CellPvpRankLog:createElement()
        cell:setTag(i - 1)
        tab:setCellElement(cell)
        tcell:setData(self.data[i])
    end
end
-------------------------------------私有方法模块End----------------------------------------