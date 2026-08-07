--WndHVOrderFirst.lua
--@brief	WndHVOrderFirst的UI模块
--@date		2023/01/03
--@author	XTX
--@note		鲜花订单历届榜首界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndHVOrderFirst:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndHVOrderFirst:onExit(element)
	self:_unInit()
end

--@brief    onenter函数已执行
function WndHVOrderFirst:onEnterTransitionDidFinish(element)
    WZLog("WndHVOrderFirst:onEnterTransitionDidFinish")
    GetElement(self.m_root, "txtTitle_WndHVOrderFirst", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT3[4])
	ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_GetFlowerTycoonHistoryRanks()
end

--@brief    关闭窗口
function WndHVOrderFirst:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    --如果是自动弹出的活动界面
    WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
