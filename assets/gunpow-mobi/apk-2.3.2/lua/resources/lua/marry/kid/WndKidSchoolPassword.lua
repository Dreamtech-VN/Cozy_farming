--WndKidSchoolPassword.lua
--@brief	WndKidSchoolPassword的UI模块
--@date		2021/04/23
--@author	yrd
--@note		孩子学校密码


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndKidSchoolPassword:onEnter(element)
	WZLog("WndKidSchoolPassword:onEnter")
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndKidSchoolPassword:onExit(element)
	self:_unInit()
end

--@brief    点击关闭按钮回调
function WndKidSchoolPassword:onClickClose(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    界面加载完成回调
function WndKidSchoolPassword:onEnterTransitionDidFinish(element)
	self:_initStaticText()
    self:updateUI()
end

--@brief    初始化静态文本
function WndKidSchoolPassword:_initStaticText()
	local editPassword = GetElement(self.m_root,"editPassword_WndKidSchoolPassword",WZUIEditBox)
	editPassword:setPlaceHolder(LocalStrings.CLICK_INPUT_PASSWORD)
end

--@brief    更新界面
function WndKidSchoolPassword:updateUI(element)
    GetElement(self.m_root,"txtSchoolName_WndKidSchoolPassword",WZUILabelTTF):setText(self.m_nSchoolName)
end

--@brief    点击确认按钮回调
function WndKidSchoolPassword:onClickConfirm(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local editPassword = GetElement(self.m_root,"editPassword_WndKidSchoolPassword",WZUIEditBox)
    local txtPassword = editPassword:getText()

    -- 空或者不是字符串
    if type(txtPassword) ~= "string" or "" == txtPassword then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT146)
        return
    end
    
	ProtocolProcessorKidSchool:send_SCHOOL_ApplySchool(self.m_nSchoolId, txtPassword)
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
