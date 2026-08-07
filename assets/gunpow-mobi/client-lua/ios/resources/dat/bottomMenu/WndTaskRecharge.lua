--WndTaskRecharge.lua
--@brief	WndTaskRecharge的UI模块
--@date		2014/09/10
--@author	SuYuan
--@note		提升任务钻石不足弹窗


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndTaskRecharge:onEnter(element)
	self.m_root = element

	self:_setStaticText()
	
    --多语言版本界面适配
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndTaskRecharge:onExit(element)
	self:_unInit()
end

--@brief	点击取消按钮的响应方法
--@param	element:取消按钮绑定的UI节点引用
--@note		点击取消按钮的响应方法
function WndTaskRecharge:onCancel(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	点击确定按钮的响应方法
--@param	element:确定按钮绑定的UI节点引用
--@note		点击确定按钮的响应方法
function WndTaskRecharge:onOK(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    PassportSdkManager:gotoPaymentPage()
    WindowManager:removeWindow(self.m_root, self, true)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	设置界面上的静态文本
function WndTaskRecharge:_setStaticText()
    GetElement(self.m_root, "txtMsg_WndTaskRecharge", WZUILabelTTF):setText(LocalStrings.NEED_RECHARGE)
    GetElement(self.m_root, "txtCancel_WndTaskRecharge", WZUILabelTTF):setText(LocalStrings.CANCEL)
    GetElement(self.m_root, "txtOK_WndTaskRecharge", WZUILabelTTF):setText(LocalStrings.CONFIRM)
end

-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配模块Begin----------------------------------------

--@brief	英文适配函数
--@note		英文适配函数
function WndTaskRecharge:_adaptLanguage_en()
end

function WndTaskRecharge:_adaptLanguage_pt(  )
    GetElement(self.m_root, "txtMsg_WndTaskRecharge", WZUILabelTTF):setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    GetElement(self.m_root, "txtMsg_WndTaskRecharge", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,0.5))
    GetElement(self.m_root, "txtMsg_WndTaskRecharge", WZUILabelTTF):setDimensions(GlobalMethod:CCSize(540,0))
    GetElement(self.m_root, "txtCancel_WndTaskRecharge", WZUILabelTTF):setFontSize(22)
    GetElement(self.m_root, "txtOK_WndTaskRecharge", WZUILabelTTF):setFontSize(22)
end
-------------------------------------语言适配模块End----------------------------------------



