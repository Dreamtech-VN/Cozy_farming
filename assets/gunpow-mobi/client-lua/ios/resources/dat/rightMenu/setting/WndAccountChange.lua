--WndGameAccountChange.lua
--@brief	WndGameAccountChange的UI模块
--@date		2015-11-09
--@author	binshao
--@note		绑定账号

-------------------------------------公有方法模块Begin--------------------------------------
--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndAccountChange:onEnter(element)
    WZLog("WndAccountChange:onEnter")
	self.m_root = element
    ProtocolProcessorAccount:regAll()
end

--@brief    弹窗动画完成后的回调
function WndAccountChange:actionCallback(element, data)
end

--@brief onEnter函数执行完成回调
function WndAccountChange:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndAccountChange:onExit(element)
    WZLog("WndAccountChange:onExit")
    ProtocolProcessorAccount:unregAll()
	self:_unInit()
end

--@brief关闭当前界面
function WndAccountChange:normalClose(  )
    WindowManager:removeWindow(self.m_root, self, true)
end

function WndAccountChange:showWndUI()
    local wnd = WndAccountChange:createElement()
    WindowManager:addWindow( wnd , WndAccountChange)
end

-- @brief  取消账号切换Btn的回调
function WndAccountChange:OnReturn(  )
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WindowManagerAni:createCloseAction(self.m_root,"normalClose",self)
end

-- @brief  确认账号切换Btn的回调
function WndAccountChange:OnBD( )
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local editA = GetElement(self.m_root,"editRegistAccount_WndAccountChange",WZUIEditBox)
    local editP1 = GetElement(self.m_root,"editRegistPass_WndAccountChange",WZUIEditBox)
    local editP2 = GetElement(self.m_root,"editRegistPassSure_WndAccountChange",WZUIEditBox)
    local editM = GetElement(self.m_root,"editRegistMail_WndAccountChange",WZUIEditBox)
    local txtAccount = editA:getText()
    local txtP1 = editP1:getText()
    local txtP2 = editP2:getText()
    local txtMail = editM:getText()

    if self:_checkAccount(txtAccount) and self:_checkPassword(txtP1) and
            self:_checkPassword(txtP2) and self:_confirmPassword() and self:_checkMail(txtMail) then
        WZLog("-------------------check name--------------------")
        local ipdAddr = ProjConfig:getIpdAddr()
        local url = ipdAddr.."/check?username="..txtAccount
        WZLog("url = ",url)
        IPDhttpServer:getAccountNameIsUsed(url)
    end
end

-- 绑定回调
function WndAccountChange:BDCallBack(data)
    local editA = GetElement(self.m_root,"editRegistAccount_WndAccountChange",WZUIEditBox)
    local editP1 = GetElement(self.m_root,"editRegistPass_WndAccountChange",WZUIEditBox)
    local editP2 = GetElement(self.m_root,"editRegistPassSure_WndAccountChange",WZUIEditBox)
    local editM = GetElement(self.m_root,"editRegistMail_WndAccountChange",WZUIEditBox)
    local txtAccount = editA:getText()
    local txtP1 = editP1:getText()
    local txtP2 = editP2:getText()
    --local txtMail = editM:getText()
    local txtMail = "10000@qq.com"

    WZLog("-----------------data.result------------",data.result)
    if data.result == 200 then
        WZLog("-------------------------200--------------------",txtAccount,txtP1,txtMail)
        ProtocolProcessorAccount:send_ACCOUNT_Register(txtAccount,txtP1,txtMail)
    else
        self:_closeLoadingBox()
        if  data.result == 400 then
            WZLog("-------------------------400--------------------")
            MsgBoxManager:showTipBox(LocalStrings.LOGIN_REGISTED, nil, nil, nil, nil)
        else
            WZLog("-------------------------other 200 400 --------------------")
            MsgBoxManager:showTipBox(LocalStrings.LOGIN_REGIST_FAIL, nil, nil, nil, nil)
        end
    end
end
-------------------------------------公有方法模块End----------------------------------------



-------------------------------------私有方法模块BEGIN----------------------------------------

-- 账号检测
function WndAccountChange:_checkAccount(txtAccount)
    -- 不能为空或者非字符串
    if type(txtAccount) ~= "string" or "" == txtAccount then
        MsgBoxManager:showTipBox(LocalStrings.PLEASE_INPUT_ACCOUNT, nil, nil, nil, nil)
        return false
    end
    if Regexp:isHasBlankChar(txtAccount) then
        MsgBoxManager:showTipBox(LocalStrings.NO_BLACKCHAR, nil, nil, nil, nil)
        return false
    end
    if string.len(txtAccount) < 6 or string.len(txtAccount) > 16 then
        MsgBoxManager:showTipBox(LocalStrings.ACCOUNT_LEN_ILLEGAL, nil, nil, nil, nil)
        return false
    end

    return true
end

-- 密码检测
function WndAccountChange:_checkPassword(txtPassword)
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
    if string.len(txtPassword) < 6 or string.len(txtPassword) > 12 then
        MsgBoxManager:showTipBox(LocalStrings.PSW_LEN_ILLEGAL, nil, nil, nil, nil)
        return false
    end
    return true
end

-- 密码核对函数
function WndAccountChange:_confirmPassword()
    local editP1 = GetElement(self.m_root,"editRegistPass_WndAccountChange",WZUIEditBox)
    local editP2 = GetElement(self.m_root,"editRegistPassSure_WndAccountChange",WZUIEditBox)
    local p1 = editP1:getText()
    local p2 = editP2:getText()
    if type(p1) ~= "string" or type(p2) ~= "string" or p1 ~= p2 then
        MsgBoxManager:showTipBox(LocalStrings.PSWCONFIRM_NOT_THE_SAME, nil, nil, nil, nil)
        return false
    end
    return true
end

-- 邮箱检测
function WndAccountChange:_checkMail(txtMail)
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

function WndAccountChange:registOK()
    WZLog("---------------OK--------------------")
    self:_closeLoadingBox()
    MsgBoxManager:showTipBox(LocalStrings.BD_ACCOUNT_OK, nil, nil, nil, nil)
    self:OnReturn(  )
    WndOwnCity:hideBinding()
end
-------------------------------------私有方法模块END----------------------------------------