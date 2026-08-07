--WndFlyUpFirst.lua
--@brief	WndFlyUpFirst的UI模块
--@date		2022/12/07
--@author	XTX
--@note		飞升仙界-榜首界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFlyUpFirst:onEnter(element)
	self.m_root = element

	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFlyUpFirst:onExit(element)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)

	self:_unInit()
end

--@brief    onenter函数已执行
function WndFlyUpFirst:onEnterTransitionDidFinish(element)
    WZLog("WndFlyUpFirst:onEnterTransitionDidFinish")
    GetElement(self.m_root, "txtTitle_WndFlyUpFirst", WZUILabelTTF):setText(LocalStrings.BEINGIMMORTAL_TEXT1[16])
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, "")
end

--@brief    关闭窗口
function WndFlyUpFirst:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    --如果是自动弹出的活动界面
    WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
