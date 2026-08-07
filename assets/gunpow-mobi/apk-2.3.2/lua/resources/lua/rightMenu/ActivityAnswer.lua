--ActivityAnswer.lua
--@brief	ActivityAnswer的UI模块
--@date		2020/09/22
--@author	hyx
--@note		活动界面-趣味答题


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function ActivityAnswer:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function ActivityAnswer:onExit(element)
	self:_unInit()
end

--@brief    显示窗口
function ActivityAnswer:showWindow( )

	--活动时间
    local txtActivityTime = GetElement(self.m_root, "activityTxt", WZUILabelTTF)
    if txtActivityTime then
        txtActivityTime:setText(LocalStrings.ACTIVE_TIME .. ":")
    end
    --具体日期
    local txtTimeValue = GetElement(self.m_root, "activityTime", WZUILabelTTF)
    if txtTimeValue then
        txtTimeValue:setText(SystemTime:getTimeConverLocal(self.startTime).."-"..SystemTime:getTimeConverLocal(self.endTime))
    end
end
function ActivityAnswer:onBtnClickGotoAnswer()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndNationalAnswer:showInterface()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
