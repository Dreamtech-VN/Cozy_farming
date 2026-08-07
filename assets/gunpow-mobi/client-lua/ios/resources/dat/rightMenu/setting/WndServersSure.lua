--WndServersSure.lua
--@brief	WndServersSure的UI模块
--@date		2015/04/30
--@author	binshao
--@note		选择服务器确认框


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndServersSure:onEnter(element)
    WZLog("WndServersSure:onEnter")

	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndServersSure:onExit(element)
    WZLog("WndServersSure:onExit")
	self:_unInit()
end

function WndServersSure:onBtnCloseClick( element )
	WZLog("WndServersSure:onBtnCloseClick---------------------:")
	-- 播放点击btn声音
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	if self.m_root then
		WindowManager:removeWindow(self.m_root , WndServersSure , true)--关闭设置窗口
	end
end
-------------------------------------私有方法模块End----------------------------------------
