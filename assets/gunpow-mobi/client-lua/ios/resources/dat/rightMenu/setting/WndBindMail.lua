--WndBindMail.lua
--@brief	WndBindMail的UI模块
--@date		2015-11-26
--@author	binshao
--@note		设置界面绑定邮箱

-------------------------------------公有方法模块Begin--------------------------------------
--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndBindMail:onEnter(element)
    WZLog("WndBindMail:onEnter")
	self.m_root = element
    ProtocolProcessorAccount:regAll()
end

--@brief    弹窗动画完成后的回调
function WndBindMail:actionCallback(element, data)
end

--@brief onEnter函数执行完成回调
function WndBindMail:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndBindMail:onExit(element)
    WZLog("WndBindMail:onExit")
    ProtocolProcessorAccount:unregAll()
	self:_unInit()
end

function WndBindMail:normalClose(  )
	WindowManager:removeWindow(self.m_root , WndBindMail , true)--关闭设置窗口
end

-- @brief  关闭修改密码界面Btn
function WndBindMail:onClose( )
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if self.m_root then
		WindowManagerAni:createCloseAction(self.m_root,"normalClose",self)
	end
end


function WndBindMail:onBind(  )
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
--    if g_isBindMail then
--        MsgBoxManager:showTipBox(LocalStrings.SETTING_BINDED_MAIL, nil, nil, nil, nil)
--        return
--    end

    local editPass = GetElement(self.m_root,"editPass_WndBindMail",WZUIEditBox)
    local editMail = GetElement(self.m_root,"editMail_WndBindMail",WZUIEditBox)
    local txtPass = editPass:getText()
    local txtMail = editMail:getText()
    if self:_checkPassword(txtPass) and self:_checkMail(txtMail) then
        WZLog("----------------555-----------------",txtPass,txtMail)
        self:_createLoadingBox()
        ProtocolProcessorAccount:send_ACCOUNT_SetEMail(txtPass, txtMail )
    end
end

function WndBindMail:bindCallBack(result)
    self:_closeLoadingBox()
    if result == 0 then
        MsgBoxManager:showTipBox(LocalStrings.SETTING_MAIL_BIND_SUCCESS, nil, nil, nil, nil)
        g_isBindMail = true
        WindowManagerAni:createCloseAction(self.m_root,"normalClose",self)
        WndSetting:modifyMailStateDesc()
    elseif result == -1 then
        MsgBoxManager:showTipBox(LocalStrings.SETTING_MAIL_BIND_FAIL, nil, nil, nil, nil)
    end
end


-- 密码检测
function WndBindMail:_checkPassword(txtPassword)
    if type(txtPassword) ~= "string" or "" == txtPassword then
        MsgBoxManager:showTipBox(LocalStrings.PLEASE_INPUT_PSW, nil, nil, nil, nil)
        return false
    end
    if Regexp:isHasBlankChar(txtPassword) then
        MsgBoxManager:showTipBox(LocalStrings.NO_BLACKCHAR, nil, nil, nil, nil)
        return false
    end
    if Regexp:isHasControlChar(txtPassword) then
        MsgBoxManager:showTipBox(LocalStrings.NO_CONTROLCHAR, nil, nil, nil, nil)
        return false
    end

    if string.len(txtPassword) < 6 or string.len(txtPassword) > 20 then
        MsgBoxManager:showTipBox(LocalStrings.PSW_LEN_ILLEGAL, nil, nil, nil, nil)
        return false
    end
    return true
end

-- 邮箱检测
function WndBindMail:_checkMail(txtMail)
    if type(txtMail) ~= "string" or "" == txtMail then
        MsgBoxManager:showTipBox(LocalStrings.PLEASE_INPUT_MAIL, nil, nil, nil, nil)
        return false
    end
    if not Regexp:isEmailAddress(txtMail) then
        MsgBoxManager:showTipBox(LocalStrings.PLEASE_INPUT_CORRECT_MAIL, nil, nil, nil, nil)
        return false
    end
    return true
end

-------------------------------------语言适配Begin----------------------------------------
function WndBindMail:_adaptLanguage_tr(  )
    local txtEmail = GetElement(self.m_root,"txtEmail_WndBindMail",WZUILabelTTF)
    txtEmail:setDimensions(GlobalMethod:CCSize(330,0))
    txtEmail:setRelativePosition(GlobalMethod:ccp(0,0.125))

    local txtPassword = GetElement(self.m_root,"txtPassword_WndBindMail",WZUILabelTTF)
    txtPassword:setDimensions(GlobalMethod:CCSize(330,0))
    txtPassword:setRelativePosition(GlobalMethod:ccp(0,0.125))

    GetElement(self.m_root,"txtName2_WndBindMail",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.46,0.77712))
end

function WndBindMail:_adaptLanguage_en(  )
    GetElement(self.m_root,"txtPassword_WndBindMail",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(-0.05,0.5))
end

function WndBindMail:_adaptLanguage_es(  )
    local txt1 = GetElement(self.m_root,"txt1_WndBindMail",WZUILabelTTF)
    txt1:setRelativePosition(GlobalMethod:ccp(0.31,0.77712))
    local txt2 = GetElement(self.m_root,"txtPassword_WndBindMail",WZUILabelTTF)
    txt2:setRelativePosition(GlobalMethod:ccp(-0.14,0.5))

    GetElement(self.m_root,"txtEmail_WndBindMail",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(-0.176471,0.5))
end

function WndBindMail:_adaptLanguage_pt(  )
    GetElement(self.m_root,"txtName2_WndBindMail",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.4,0.77712))
end
-------------------------------------语言适配End---------------------------------------