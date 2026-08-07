--WndModifyPassword.lua
--@brief	WndModifyPassword的UI模块
--@date		2015-11-28
--@author	binshao
--@note	    修改密码


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndModifyPassword:onEnter(element)
    WZLog("WndModifyPassword:onEnter")
	self.m_root = element
    AdaptLanguage(self)
    ProtocolProcessorAccount:regAll()
    AdaptLanguage(self)
end

--@brief    弹窗动画完成后的回调
function WndModifyPassword:actionCallback(element, data)
end

--@brief onEnter函数执行完成回调
function WndModifyPassword:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndModifyPassword:onExit(element)
    WZLog("WndModifyPassword:onExit")
    ProtocolProcessorAccount:unregAll()
	self:_unInit()
end

function WndModifyPassword:normalClose(  )
    WindowManager:removeWindow(self.m_root , WndModifyPassword , true)
end


-- @brief  关闭找回密码Btn回调
function WndModifyPassword:onClose( )
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    WindowManagerAni:createCloseAction(self.m_root,"normalClose",self)
end

-- 修改密码
function WndModifyPassword:onModify( )
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local editOldP = GetElement(self.m_root,"editOldP_WndModifyPassword",WZUIEditBox)
    local editNewP = GetElement(self.m_root,"editNewP_WndModifyPassword",WZUIEditBox)
    local editConfirmP = GetElement(self.m_root,"editSureP_WndModifyPassword",WZUIEditBox)
    local userName = g_tAccountData.accountName
    local oldP = editOldP:getText()         -- 旧密码
    local newP = editNewP:getText()         -- 新密码
    local confirmP = editConfirmP:getText() -- 确认密码
    if self:_checkPassword(oldP) and self:_checkPassword(newP) and self:_checkPassword(confirmP) and self:_confirmPassword(newP,confirmP) then
        self:_createLoadingBox()
        self:modifyPassword(userName,oldP,newP)
        ProtocolProcessorAccount:send_ACCOUNT_ModifyPassword(oldP, newP )
        WZLog("--------------modify info---------------",userName,oldP,newP,confirmP)
    end
end

-- 通过HTTP协议修改密码
function WndModifyPassword:modifyPassword(userName,password,newPassword)
    local ipdAddr = ProjConfig:getIpdAddr()
    local sign = WZDeviceInfo:md5Generate(userName..password..newPassword.."gz!y^d&zh*wyd")
    local data = {sign = sign, username = userName,password = password,newpassword = newPassword}
    local vBytes = WGameCmUtil:EnCrypt(json.encode(data), ENCRYPT_KEY)
    local sData = WGameCmUtil:transformBytesToString(vBytes)
    local url = ipdAddr.."/modifyPassword?data="..sData
    WZLog("url = ",url)
    IPDhttpServer:modifyPassword(url)
end
-------------------------------------公有方法模块End--------------------------------------


-- -----------------------------------私有方法模块Begin--------------------------------------
-- 修改密码回调
function WndModifyPassword:modifyPasswordCallBack(data)
    self:_closeLoadingBox()
    WZLog("-----------------modifyPasswordCallBackResult------------",data.result)
    if data.result == 200 then
        MsgBoxManager:showTipBox(LocalStrings.CHANGE_PSW_SUCCESS, nil, nil, nil, nil)
        WindowManagerAni:createCloseAction(self.m_root,"normalClose",self)
    elseif data.result == 400 then
        MsgBoxManager:showTipBox(LocalStrings.ACCOUNT_NOT_EXIST, nil, nil, nil, nil)
    else
        MsgBoxManager:showTipBox(LocalStrings.PASSWORD_ERROR, nil, nil, nil, nil)
    end
end

-- 密码检测
function WndModifyPassword:_checkPassword(txtPassword)
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

-- 密码核对函数
function WndModifyPassword:_confirmPassword(password1,password2)
    if type(password1) ~= "string" or type(password2) ~= "string" or password1 ~= password2 then
        MsgBoxManager:showTipBox(LocalStrings.PSWCONFIRM_NOT_THE_SAME, nil, nil, nil, nil)
        return false
    end
    return true
end
-------------------------------------私有方法模块End----------------------------------------
function WndModifyPassword:_adaptLanguage_en(  )
    GetElement(self.m_root,"txtPswO_WndModifyPassword",WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root,"txtPsw_WndModifyPassword",WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root,"txtPswS_WndModifyPassword",WZUILabelTTF):setFontSize(18)
end

------------------------------------语言适配Begin--------------------------------------------
function WndModifyPassword:_adaptLanguage_en(  )
    GetElement(self.m_root,"txtNewPsw_WndModifyPassword",WZUILabelTTF):setFontSize(20)
end

function WndModifyPassword:_adaptLanguage_th(  )
    GetElement(self.m_root,"txtConfirm_WndModifyPassword",WZUILabelTTF):setFontSize(20)
end

function WndModifyPassword:_adaptLanguage_es(  )
    local txtNewPsw = GetElement(self.m_root,"txtNewPsw_WndModifyPassword",WZUILabelTTF)
    txtNewPsw:setDimensions(GlobalMethod:CCSize(100,0))

    local txtConfirm = GetElement(self.m_root,"txtConfirm_WndModifyPassword",WZUILabelTTF)
    txtConfirm:setDimensions(GlobalMethod:CCSize(150,0))
end

function WndModifyPassword:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txtConfirm_WndModifyPassword",WZUILabelTTF):setFontSize(16)
    GetElement(self.m_root,"txtNewPsw_WndModifyPassword",WZUILabelTTF):setFontSize(20)
end

function WndModifyPassword:_adaptLanguage_tr(  )
    local txtOldP = GetElement(self.m_root,"txtOldP_WndModifyPassword",WZUILabelTTF)
    txtOldP:setFontSize(16)

    -- local txtNewPsw = GetElement(self.m_root,"txtNewPsw_WndModifyPassword",WZUILabelTTF)
    -- txtNewPsw:setFontSize(16)

    local txtSureP = GetElement(self.m_root,"txtSureP_WndModifyPassword",WZUILabelTTF)
    txtSureP:setFontSize(16)

    GetElement(self.m_root,"txtNewP_WndModifyPassword",WZUILabelTTF):setFontSize(16)
end