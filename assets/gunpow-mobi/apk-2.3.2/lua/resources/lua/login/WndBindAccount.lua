--WndBindAccount.lua
--@brief	WndBindAccount的UI模块
--@date		2015-11-09
--@author	binshao
--@note		绑定账号

-------------------------------------公有方法模块Begin--------------------------------------
--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndBindAccount:onEnter(element)
    WZLog("WndBindAccount:onEnter")
	self.m_root = element
    ProtocolProcessorAccount:regAll()
    --语言适配
    AdaptLanguage(self)
end

--@brief    弹窗动画完成后的回调
function WndBindAccount:actionCallback(element, data)
end

--@brief onEnter函数执行完成回调
function WndBindAccount:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)

end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndBindAccount:onExit(element)
    WZLog("WndBindAccount:onExit")
    ProtocolProcessorAccount:unregAll()
	self:_unInit()
end

--@brief关闭当前界面
function WndBindAccount:normalClose(  )
    WindowManager:removeWindow(self.m_root, self, true)
end

function WndBindAccount:showWndUI()
    local wnd = WndBindAccount:createElement()
    WindowManager:addWindow( wnd , WndBindAccount)
end

-- @brief  取消账号切换Btn的回调
function WndBindAccount:OnReturn(  )
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    WindowManagerAni:createCloseAction(self.m_root,"normalClose",self)
end

-- @brief  绑定操作，优先判断用户名是否可用，再继续绑定账号
function WndBindAccount:OnBD( )
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local editA = GetElement(self.m_root,"editRegistAccount_WndBindAccount",WZUIEditBox)
    local editP1 = GetElement(self.m_root,"editRegistPass_WndBindAccount",WZUIEditBox)
    local editP2 = GetElement(self.m_root,"editRegistPassSure_WndBindAccount",WZUIEditBox)
    local editM = GetElement(self.m_root,"editRegistMail_WndBindAccount",WZUIEditBox)
    local txtAccount = editA:getText()
    local txtP1 = editP1:getText()
    local txtP2 = editP2:getText()
    local txtMail = editM:getText()

    if self:_checkAccount(txtAccount) and self:_checkPassword(txtP1) and
            self:_checkPassword(txtP2) and self:_confirmPassword() and self:_checkMail(txtMail) then
        WZLog("-------------------check name--------------------")
        self:_createLoadingBox()
        local ipdAddr = ProjConfig:getIpdAddr()
        local url = ipdAddr.."/check?username="..txtAccount
        WZLog("url = ",url)
        IPDhttpServer:getAccountNameIsUsed(url)
    end
end

-- 判断用户名是否可用回调
function WndBindAccount:nameJudgeCallBack(data)
    WZLog("-----------------nameJudgeCallBack------------",data.result)
    if data.result == 200 then
        local editA = GetElement(self.m_root,"editRegistAccount_WndBindAccount",WZUIEditBox)
        local editP1 = GetElement(self.m_root,"editRegistPass_WndBindAccount",WZUIEditBox)
        local editP2 = GetElement(self.m_root,"editRegistPassSure_WndBindAccount",WZUIEditBox)
        local editM = GetElement(self.m_root,"editRegistMail_WndBindAccount",WZUIEditBox)
        local txtAccount = editA:getText()
        local txtP1 = editP1:getText()
        local txtP2 = editP2:getText()
        local txtMail = editM:getText()

        -- 如果登陆在主城，就哦组协议，否则就走HTTP协议
        if WndOwnCity and WndOwnCity.m_root then
            ProtocolProcessorAccount:send_ACCOUNT_Register(txtAccount,txtP1,txtMail)
        else
            -- HTTP协议
            local ipdAddr = ProjConfig:getIpdAddr()
            local channelId = ProjConfig:getChannelId()
            local uId = WGameCmUtil:GetUDID()
            local name = txtAccount
            local password = txtP1
            local sign = WZDeviceInfo:md5Generate(uId..name..password..channelId.."gz!y^d&zh*wyd")
            local data = {sign = sign, id = uId, username = name, email = txtMail, channel = channelId,password = password}
            local vBytes = WGameCmUtil:EnCrypt(json.encode(data), ENCRYPT_KEY)
            local sData = WGameCmUtil:transformBytesToString(vBytes)
            local url = ipdAddr.."/register?data="..sData
            WZLog("url = ",url)
            IPDhttpServer:bindAccount(url)
        end
    else
        self:_closeLoadingBox()
        if  data.result == 400 then
            MsgBoxManager:showTipBox(LocalStrings.LOGIN_REGISTED, nil, nil, nil, nil)
        else
            MsgBoxManager:showTipBox(LocalStrings.LOGIN_REGIST_FAIL, nil, nil, nil, nil)
        end
    end
end

-- Http协议回调
function WndBindAccount:bindAccountCallBack(data)
    self:_closeLoadingBox()
    WZLog("-----------------bindAccountCallBack------------",data.result)
    if data.result == 200 then
        g_isRegist = true
        -- 需要重新登录
        local editA = GetElement(self.m_root,"editRegistAccount_WndBindAccount",WZUIEditBox)
        local txtAccount = editA:getText()
        WndLoginSelect:bindAccountCallBack(txtAccount)
        MsgBoxManager:showTipBox(LocalStrings.BD_ACCOUNT_OK, nil, nil, nil, nil)
        WindowManagerAni:createCloseAction(self.m_root,"normalClose",self)
    elseif data.result == 400 then
        MsgBoxManager:showTipBox(LocalStrings.LOGIN_REGISTED, nil, nil, nil, nil)
    else
        MsgBoxManager:showTipBox(LocalStrings.LOGIN_REGIST_FAIL, nil, nil, nil, nil)
    end
end

-- 协议回调
function WndBindAccount:registOK()
    WZLog("---------------OK--------------------")
    self:_closeLoadingBox()
    g_isRegist = true
    MsgBoxManager:showTipBox(LocalStrings.BD_ACCOUNT_OK, nil, nil, nil, nil)
    WindowManagerAni:createCloseAction(self.m_root,"normalClose",self)
    WndOwnCity:hideBinding()
end
-------------------------------------公有方法模块End----------------------------------------



-------------------------------------私有方法模块BEGIN----------------------------------------

-- 账号检测
function WndBindAccount:_checkAccount(txtAccount)
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
function WndBindAccount:_checkPassword(txtPassword)
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
function WndBindAccount:_confirmPassword()
    local editP1 = GetElement(self.m_root,"editRegistPass_WndBindAccount",WZUIEditBox)
    local editP2 = GetElement(self.m_root,"editRegistPassSure_WndBindAccount",WZUIEditBox)
    local p1 = editP1:getText()
    local p2 = editP2:getText()
    if type(p1) ~= "string" or type(p2) ~= "string" or p1 ~= p2 then
        MsgBoxManager:showTipBox(LocalStrings.PSWCONFIRM_NOT_THE_SAME, nil, nil, nil, nil)
        return false
    end
    return true
end

-- 邮箱检测
function WndBindAccount:_checkMail(txtMail)
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

-------------------------------------私有方法模块END----------------------------------------

-------------------------------------语言适配Begin--------------------------------------------
--@brief 越南适配函数
function WndBindAccount:_adaptLanguage_vn()
    local txt1 = GetElement(self.m_root, "txt1_WndBindAccount", WZUILabelTTF)
    txt1:setRelativePosition(GlobalMethod:ccp(-0.236842,0.5))

    local txt2 = GetElement(self.m_root, "txt2_WndBindAccount", WZUILabelTTF)
    txt2:setFontSize(18)
    txt2:setRelativePosition(GlobalMethod:ccp(0.28421,0.5))

    local txt3 = GetElement(self.m_root, "txt3_WndBindAccount", WZUILabelTTF)
    txt3:setFontSize(18)

    local txt4 = GetElement(self.m_root, "txt4_WndBindAccount", WZUILabelTTF)
    txt4:setFontSize(18)

    local txt6 = GetElement(self.m_root, "txt6_WndBindAccount", WZUILabelTTF)
    txt6:setFontSize(18)
end

function WndBindAccount:_adaptLanguage_en(  )
    local txt1 = GetElement(self.m_root, "txt1_WndBindAccount", WZUILabelTTF)
    txt1:setFontSize(15)
    txt1:setRelativePosition(GlobalMethod:ccp(-0.17,0.5))
    local txt7 = GetElement(self.m_root, "txt7_WndBindAccount", WZUILabelTTF)
    txt7:setRelativePosition(GlobalMethod:ccp(-0.13,0.5))
end

function WndBindAccount:_adaptLanguage_pt(  )
    local txt1 = GetElement(self.m_root, "txt1_WndBindAccount", WZUILabelTTF)
    txt1:setFontSize(15)
    txt1:setRelativePosition(GlobalMethod:ccp(-0.17,0.5))
    local txt7 = GetElement(self.m_root, "txt7_WndBindAccount", WZUILabelTTF)
    txt7:setRelativePosition(GlobalMethod:ccp(-0.13,0.5))
end

function WndBindAccount:_adaptLanguage_tr(  )
    GetElement(self.m_root, "txt7_WndBindAccount", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(-0.2,0.5))
end
-------------------------------------私有方法模块END----------------------------------------

function WndBindAccount:_adaptLanguage_es(  )
    local txt1 = GetElement(self.m_root,"txt1_WndBindAccount",WZUILabelTTF)
    txt1:setRelativePosition(GlobalMethod:ccp(-0.364661,0.5))
    GetElement(self.m_root,"txt3_WndBindAccount",WZUILabelTTF):setFontSize(22)
    local txt2 = GetElement(self.m_root,"txt2_WndBindAccount",WZUILabelTTF)
    txt2:setDimensions(GlobalMethod:CCSize(150,0))
    txt2:setFontSize(20)
    local txt7 = GetElement(self.m_root,"txt7_WndBindAccount",WZUILabelTTF)
    txt7:setRelativePosition(GlobalMethod:ccp(-0.210526,0.5))
end
-------------------------------------语言适配End----------------------------------------------