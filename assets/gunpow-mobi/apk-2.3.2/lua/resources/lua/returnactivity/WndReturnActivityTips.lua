--WndReturnActivityTips.lua
--@brief	WndReturnActivityTips的UI模块
--@date		2021/05/25
--@author	hyx
--@note		回归活动弹窗


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndReturnActivityTips:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndReturnActivityTips:onExit(element)
	GlobalGame.g_autoReturnActivity = false
	self:_unInit()
end
--打开界面
function WndReturnActivityTips:showInterface()   
	local returnTips = WndReturnActivityTips:createElement()
	if returnTips ~= nil then
	    WindowManager:addWindow(returnTips,WndReturnActivityTips,nil,false)
	end
end
function WndReturnActivityTips:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndReturnActivityTips:actionCallback()

end

function WndReturnActivityTips:onBtnClose()
	ProtocolProcessorGlobal:unregProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_ActivityDoOk, "ProtocolProcessorGlobal:parse_ACTIVITY2_ActivityDoOk", "iiiis")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
	WndReturnActivityMain:showInterface()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
