--WndRegister.lua
--@brief	SceneRegister的UI模块
--@date		2013/12/11
--@author	SuYuan
--@note		登陆窗口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndRegister:onEnter(element)
	self.m_root = element

	--多语言版本界面适配
    AdaptLanguage(self)

    WZLog("dfafasdf",Serialize(GlobalGame.g_tButtonInfo))
    for v,k in ipairs(GlobalGame.g_tButtonInfo.buttonId) do
    	WZLog("dfd",k)
    	if k == 30 then
    		--转生 等级符合 显示

    		WZLog("fffff",Serialize(k),GlobalGame.g_tPlayerInfo.nZsleve,GlobalGame.g_tPlayerInfo.nLevel)
    		if (GlobalGame.g_tPlayerInfo.nZsleve ~= nil and GlobalGame.g_tPlayerInfo.nZsleve > 0 ) or GlobalGame.g_tPlayerInfo.nLevel >= GlobalGame.g_tButtonInfo.buttonStatus3Level[v] then
        	   GetElement(self.m_root,"editInviteCode_bg_Register",WZUI9Image):setVisible(true)
        	   GetElement(self.m_root,"editInviteCode_Register",WZUIEditBox):setVisible(true)
        	   GetElement(self.m_root,"txtInviteCodeDefaultText_Register",WZUILabelTTF):setVisible(true)
        	   GetElement(self.m_root,"txtInviteCode_Register",WZUIFreeTextBox):setVisible(true)
        	else
        	   GetElement(self.m_root,"editInviteCode_bg_Register",WZUI9Image):setVisible(false)
        	   GetElement(self.m_root,"editInviteCode_Register",WZUIEditBox):setVisible(false)
        	   GetElement(self.m_root,"txtInviteCodeDefaultText_Register",WZUILabelTTF):setVisible(false)
        	   GetElement(self.m_root,"txtInviteCode_Register",WZUIFreeTextBox):setVisible(false)
        	end
        	break
    	end
    end
end

function WndRegister:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAction(self.m_root,false,"actionCallback",self)
end

function WndRegister:actionCallback( ... )
     --设置控件文本
	self:_setUIStaticText()
	
	--初始化编辑框数据
	self:_initEidtBoxData()
	
	--初始化邀请码
	self.m_sInviteCode = ""
	
	--描边字多语言版本文本
	self:_moreLanguageForStroke()
	
	--语言适配
	AdaptLanguage(self)

	--注册账号后切换到小岛
	ChangeChatChannel(Chat_Channel_Island)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndRegister:onExit(element)
	self:_unInit()
end

--@brief	关闭按钮按下时被调用的函数
--@param	element:按钮的UI节点引用
--@note		在这里做相应的按钮响应操作
function WndRegister:onBtnCloseClicked(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	

	WindowManagerAni:createCloseAction(self.m_root,"oncloseani",self)
end

function WndRegister:oncloseani()
	self:closeWindow()
end

--@brief	确定按钮按下时被调用的函数
--@param	element:按钮的UI节点引用
--@note		在这里做相应的按钮响应操作
function WndRegister:onBtnOKClicked(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	if self:checkAccount() and self:checkPassword() and self:confirmPassword() and self:checkMail() then
		ProtocolProcessorAccount:send_ACCOUNT_Register(self.m_sAccount, self.m_sPassword, WZDeviceInfo:appVersion(), WGameCmUtil:GetDeviceModel(), 0, self.m_sMail, self.m_sInviteCode)--WGameCmUtil:getAppVersion()
        WZLog("WndRegister:onBtnOKClicked=",WZDeviceInfo:appVersion())
		WndRegister:startLoading()
	end
end

--@brief	账号编辑框编辑开始时被调用的函数
--@param	element:账号编辑框的UI节点引用
--@note		在这里做相应的事件响应操作
function WndRegister:onEditAccountBegin(element)
	local txtAccountDefaultText = self.m_root:getChildElement("txtAccountDefaultText_Register")
	if txtAccountDefaultText ~= nil then
		WZUILabelTTF:luaTo(txtAccountDefaultText):setText("")
	end
	local accountHighligh = GetElement(self.m_root, "accountHighligh_wndRegister", WZArmature)
	if accountHighligh ~= nil then
		accountHighligh:setVisible(false)
	end
end

--@brief	账号编辑框编辑结束时被调用的函数
--@param	element:账号编辑框的UI节点引用
--@note		在这里做相应的事件响应操作
function WndRegister:onEditAccountEnd(element)
	local editAccount = WZUIEditBox:luaTo(element)
	if editAccount ~= nil then
		if editAccount:getText() == "" then
			local txtAccountDefaultText = self.m_root:getChildElement("txtAccountDefaultText_Register")
			if txtAccountDefaultText ~= nil then
				WZUILabelTTF:luaTo(txtAccountDefaultText):setText(LocalStrings.CLICK_INPUT_ACCOUNT)
			end
		end
	end
end

--@brief	账号编辑框文本改变时被调用的函数
--@param	element:账号编辑框的UI节点引用
--@note		在这里做相应的事件响应操作
function WndRegister:onEditAccountTextChanged(element)
	local editAccount = WZUIEditBox:luaTo(element)
	if editAccount ~= nil then
		self.m_sAccount = editAccount:getText()
		editAccount:setFontSize(15)
	end
end

--@brief	密码编辑框编辑开始时被调用的函数
--@param	element:账号编辑框的UI节点引用
--@note		在这里做相应的事件响应操作
function WndRegister:onEditPasswordBegin(element)
	local txtPasswordDefaultText = self.m_root:getChildElement("txtPasswordDefaultText_Register")
	if txtPasswordDefaultText ~= nil then
		WZUILabelTTF:luaTo(txtPasswordDefaultText):setText("")
	end
	
	local passwordHighligh = GetElement(self.m_root, "passwordHighligh_wndRegister", WZArmature)
	if passwordHighligh ~= nil then
		passwordHighligh:setVisible(false)
	end
end

--@brief	密码编辑框编辑结束时被调用的函数
--@param	element:账号编辑框的UI节点引用
--@note		在这里做相应的事件响应操作
function WndRegister:onEditPasswordEnd(element)
	local editPassword = WZUIEditBox:luaTo(element)
	if editPassword ~= nil then
		if editPassword:getText() == "" then
			local txtPasswordDefaultText = self.m_root:getChildElement("txtPasswordDefaultText_Register")
			if txtPasswordDefaultText ~= nil then
				WZUILabelTTF:luaTo(txtPasswordDefaultText):setText(LocalStrings.CLICK_INPUT_PASSWORD)
			end
		end
	end
end

--@brief	密码编辑框文本改变时被调用的函数
--@param	element:账号编辑框的UI节点引用
--@note		在这里做相应的事件响应操作
function WndRegister:onEditPasswordTextChanged(element)
	local editPassword = WZUIEditBox:luaTo(element)
	if editPassword ~= nil then
		self.m_sPassword = editPassword:getText()
	end
end

--@brief	密码确认编辑框编辑开始时被调用的函数
--@param	element:账号编辑框的UI节点引用
--@note		在这里做相应的事件响应操作
function WndRegister:onEditPswConfirmBegin(element)
	local txtPswConfirmDefaultText = self.m_root:getChildElement("txtPswConfirmDefaultText_Register")
	if txtPswConfirmDefaultText ~= nil then
		WZUILabelTTF:luaTo(txtPswConfirmDefaultText):setText("")
	end
	
	local passwordRetryHighligh = GetElement(self.m_root, "passwordRetryHighligh_wndRegister", WZArmature)
	if passwordRetryHighligh ~= nil then
		passwordRetryHighligh:setVisible(false)
	end
end

--@brief	密码确认编辑框编辑结束时被调用的函数
--@param	element:账号编辑框的UI节点引用
--@note		在这里做相应的事件响应操作
function WndRegister:onEditPswConfirmEnd(element)
	local editPswConfirm = WZUIEditBox:luaTo(element)
	if editPswConfirm ~= nil then
		if editPswConfirm:getText() == "" then
			local txtPswConfirmDefaultText = self.m_root:getChildElement("txtPswConfirmDefaultText_Register")
			if txtPswConfirmDefaultText ~= nil then
				WZUILabelTTF:luaTo(txtPswConfirmDefaultText):setText(LocalStrings.CLICK_INPUT_PASSWORD)
			end
		end
	end
end

--@brief	密码确认编辑框文本改变时被调用的函数
--@param	element:账号编辑框的UI节点引用
--@note		在这里做相应的事件响应操作
function WndRegister:onEditPswConfirmTextChanged(element)
	local editPswConfirm = WZUIEditBox:luaTo(element)
	if editPswConfirm ~= nil then
		self.m_sPswConfirm = editPswConfirm:getText()
	end
end

--@brief	邮箱编辑框编辑开始时被调用的函数
--@param	element:账号编辑框的UI节点引用
--@note		在这里做相应的事件响应操作
function WndRegister:onEditMailBegin(element)
	local txtMailDefaultText= self.m_root:getChildElement("txtMailDefaultText_Register")
	if txtMailDefaultText ~= nil then
		WZUILabelTTF:luaTo(txtMailDefaultText):setText("")
	end
	
	local email = GetElement(self.m_root, "email_wndRegister", WZArmature)
	if email ~= nil then
		email:setVisible(false)
	end
end

--@brief	邮箱编辑框编辑结束时被调用的函数
--@param	element:账号编辑框的UI节点引用
--@note		在这里做相应的事件响应操作
function WndRegister:onEditMailEnd(element)
	local editMail = WZUIEditBox:luaTo(element)
	print("------------- editMail: ", editMail)
	if editMail ~= nil then
		if editMail:getText() == "" then
			local txtMailDefaultText = self.m_root:getChildElement("txtMailDefaultText_Register")
			if txtMailDefaultText ~= nil then
				WZUILabelTTF:luaTo(txtMailDefaultText):setText(LocalStrings.CLICK_INPUT_MAIL)
			end
		end
		editMail:setFontSize(15)
		print("------------- editMail:setFontSize(15)")
	end
end

--@brief	邮箱编辑框文本改变时被调用的函数
--@param	element:账号编辑框的UI节点引用
--@note		在这里做相应的事件响应操作
function WndRegister:onEditMailTextChanged(element)
	local editMail = WZUIEditBox:luaTo(element)
	if editMail ~= nil then
		self.m_sMail = editMail:getText()
		editMail:setFontSize(15)
	end
end

--@brief	邀请码编辑框编辑开始时被调用的函数
--@param	element:账号编辑框的UI节点引用
--@note		在这里做相应的事件响应操作
function WndRegister:onEditInviteCodeBegin(element)
	local txtInviteCodeDefaultText = self.m_root:getChildElement("txtInviteCodeDefaultText_Register")
	if txtInviteCodeDefaultText ~= nil then
		WZUILabelTTF:luaTo(txtInviteCodeDefaultText):setText("")
	end
end

--@brief	邀请码编辑框编辑结束时被调用的函数
--@param	element:账号编辑框的UI节点引用
--@note		在这里做相应的事件响应操作
function WndRegister:onEditInviteCodeEnd(element)
	local editInviteCode = WZUIEditBox:luaTo(element)
	if editInviteCode ~= nil then
		if editInviteCode:getText() == "" then
			local txtInviteCodeDefaultText = self.m_root:getChildElement("txtInviteCodeDefaultText_Register")
			if txtInviteCodeDefaultText ~= nil then
				WZUILabelTTF:luaTo(txtInviteCodeDefaultText):setText(LocalStrings.CLICK_INPUT_INVITECODE)
			end
		end
	end
end

--@brief	邀请码编辑框文本改变时被调用的函数
--@param	element:账号编辑框的UI节点引用
--@note		在这里做相应的事件响应操作
function WndRegister:onEditInviteCodeTextChanged(element)
	local editInviteCode = WZUIEditBox:luaTo(element)
	if editInviteCode ~= nil then
		self.m_sInviteCode = editInviteCode:getText()
	end
end

--@brief	存储注册的账号信息
--@note		将注册的账号信息存储到本地
function WndRegister:saveRegisteredAccount()
	WndRegister:stopLoading()
	WndSetting:closeSetting()--关闭设置窗口
	local data = WZDataFile:getInstance():getUserData()
	WZLog("data::acount:::",data,self.m_sAccount,self.m_sPassword)
	if data ~= nil then
		data:setStringValue("AccountData", "account", self.m_sAccount)
		data:setStringValue("AccountData", "password", self.m_sPassword)
		data:flush()
	end
	WndRegister:closeWindow()
end

--@brief	关闭窗口
--@note		关闭注册窗口
function WndRegister:closeWindow()
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	设置窗口中的EditBox是否可触摸
--@param	bFlag:窗口中EditBox是否可触摸的标志
--@note		根据参数bFlag设置窗口中的EditBox是否可触摸
function WndRegister:setWindowTouchEnable(bFlag)
	local editAccount = self.m_root:getChildElement("editAccount_Register")
	if editAccount ~= nil then
		WZUIEditBox:luaTo(editAccount):setTouchEnable(bFlag)
	end
	local editPassword = self.m_root:getChildElement("editPassword_Register")
	if editPassword ~= nil then
		WZUIEditBox:luaTo(editPassword):setTouchEnable(bFlag)
	end
	local editPswConfirm = self.m_root:getChildElement("editPswConfirm_Register")
	if editPswConfirm ~= nil then
		WZUIEditBox:luaTo(editPswConfirm):setTouchEnable(bFlag)
	end
	local editMail = self.m_root:getChildElement("editMail_Register")
	if editMail ~= nil then
		WZUIEditBox:luaTo(editMail):setTouchEnable(bFlag)
	end
	local editInviteCode = self.m_root:getChildElement("editInviteCode_Register")
	if editInviteCode ~= nil then
		WZUIEditBox:luaTo(editInviteCode):setTouchEnable(bFlag)
	end
end

--@brief	设置窗口中的EditBox是否可触摸
--@param	bFlag:窗口中EditBox是否可触摸的标志
--@note		根据参数bFlag设置窗口中的EditBox是否可触摸
function WndRegister:activeStateDidChanged(bFlag)
	self:setWindowTouchEnable(bFlag)
end

--@brief	开始加载
--@note 	显示加载对话框
function WndRegister:startLoading()
	self.m_nLoadingBoxID = MsgBoxManager:showLoadingBox(60)
end

--@brief	停止加载
--@note 	关闭加载对话框
function WndRegister:stopLoading()
	if self.m_nLoadingBoxID ~= nil then
		MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingBoxID)
		self.m_nLoadingBoxID = nil
	end
end

--@brief	查看协议回调
function WndRegister:onGoToProtocol(element)
	WZPush:openURL("http://www.dandandao.com/count?cid=33")
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	设置控件静态文本
--@note		设置控件静态文本
function WndRegister:_setUIStaticText()
	local txtAccountDefaultText = self.m_root:getChildElement("txtAccountDefaultText_Register")
	if txtAccountDefaultText ~= nil then
		WZUILabelTTF:luaTo(txtAccountDefaultText):setText(LocalStrings.CLICK_INPUT_ACCOUNT)
	end
	local txtPasswordDefaultText = self.m_root:getChildElement("txtPasswordDefaultText_Register")
	if txtPasswordDefaultText ~= nil then
		WZUILabelTTF:luaTo(txtPasswordDefaultText):setText(LocalStrings.CLICK_INPUT_PASSWORD)
	end
	local txtPswConfirmDefaultText = self.m_root:getChildElement("txtPswConfirmDefaultText_Register")
	if txtPswConfirmDefaultText ~= nil then
		WZUILabelTTF:luaTo(txtPswConfirmDefaultText):setText(LocalStrings.CLICK_INPUT_PASSWORD)
	end
	local txtMailDefaultText = self.m_root:getChildElement("txtMailDefaultText_Register")
	if txtMailDefaultText ~= nil then
		WZUILabelTTF:luaTo(txtMailDefaultText):setText(LocalStrings.CLICK_INPUT_MAIL)
	end
	local txtInviteCodeDefaultText = self.m_root:getChildElement("txtInviteCodeDefaultText_Register")
	if txtInviteCodeDefaultText ~= nil then
		WZUILabelTTF:luaTo(txtInviteCodeDefaultText):setText(LocalStrings.CLICK_INPUT_INVITECODE)
	end
	local txtAccount = self.m_root:getChildElement("txtAccount_Register")
	if txtAccount ~= nil then
		WZUIFreeTextBox:luaTo(txtAccount):setShowText(LocalStrings.ACCOUNT)
	end
	local txtPassword = self.m_root:getChildElement("txtPassword_Register")
	if txtPassword ~= nil then
		WZUIFreeTextBox:luaTo(txtPassword):setShowText(LocalStrings.PASSWORD)
	end
	local txtPswConfirm = self.m_root:getChildElement("txtPswConfirm_Register")
	if txtPswConfirm ~= nil then
		WZUIFreeTextBox:luaTo(txtPswConfirm):setShowText(LocalStrings.PSW_CONFIRM)
	end
	local txtMail = self.m_root:getChildElement("txtMail_Register")
	if txtMail ~= nil then
		WZUIFreeTextBox:luaTo(txtMail):setShowText(LocalStrings.MAIL)
	end
	local txtInviteCode = self.m_root:getChildElement("txtInviteCode_Register")
	if txtInviteCode ~= nil then
		WZUIFreeTextBox:luaTo(txtInviteCode):setShowText(LocalStrings.INVITE_CODE)
	end
	local txtTip = self.m_root:getChildElement("txtTip_Register")
	if txtTip ~= nil then
		WZUIFreeTextBox:luaTo(txtTip):setShowText(LocalStrings.STAR_MEANS_ESSENTIAL)
	end
	--[[
	local stxtRegister = self.m_root:getChildElement("stxtRegister_WndRegister")
	if stxtRegister ~= nil then
		WZUIShadowTTF:luaTo(stxtRegister):setText(LocalStrings.CONFIRM)
	end
	]]
	
	local txtAccountTip = self.m_root:getChildElement("txtAccountTip_WndRegister")
	if txtAccountTip ~= nil then
		WZUILabelTTF:luaTo(txtAccountTip):setText(LocalStrings.TIP_INPUT_ACCOUNT)
	end
	local txtPasswordTip = self.m_root:getChildElement("txtPasswordTip_WndRegister")
	if txtPasswordTip ~= nil then
		WZUILabelTTF:luaTo(txtPasswordTip):setText(LocalStrings.TIP_INPUT_PASSWORD)
	end
	local txtPasswoerConfirmTip = self.m_root:getChildElement("txtPasswoerConfirmTip_WndRegister")
	if txtPasswoerConfirmTip ~= nil then
		WZUILabelTTF:luaTo(txtPasswoerConfirmTip):setText(LocalStrings.TIP_INPUT_PASSWORD_CONFIRM)
	end
	local txtMailTip = self.m_root:getChildElement("txtMailTip_WndRegister")
	if txtMailTip ~= nil then
		WZUILabelTTF:luaTo(txtMailTip):setText(LocalStrings.TIP_INPUT_MAIL)
	end
	local txtInviteCodeTip = self.m_root:getChildElement("txtInviteCodeTip_WndRegister")
	if txtInviteCodeTip ~= nil then
		WZUILabelTTF:luaTo(txtInviteCodeTip):setText(LocalStrings.TIP_INPUT_INVITECODE)
	end
end

--@brief	初始化编辑框数据
--@note		初始化编辑框数据
function WndRegister:_initEidtBoxData()
	local editAccount = self.m_root:getChildElement("editAccount_Register")
	if editAccount ~= nil then
		WZUIEditBox:luaTo(editAccount):setText("")
	end
	local editPassword = self.m_root:getChildElement("editPassword_Register")
	if editPassword ~= nil then
		WZUIEditBox:luaTo(editPassword):setText("")
	end
	local editPswConfirm = self.m_root:getChildElement("editPswConfirm_Register")
	if editPswConfirm ~= nil then
		WZUIEditBox:luaTo(editPswConfirm):setText("")
	end
	local editMail = self.m_root:getChildElement("editMail_Register")
	if editMail ~= nil then
		WZUIEditBox:luaTo(editMail):setText("")
	end
	local editInviteCode = self.m_root:getChildElement("editInviteCode_Register")
	if editInviteCode ~= nil then
		WZUIEditBox:luaTo(editInviteCode):setText("")
	end
end

--@brief	账号检测函数
--@return	#1:账号是否符合要求
--@note		检测账号是否符合要求
function WndRegister:checkAccount()
	if type(self.m_sAccount) ~= "string" or "" == self.m_sAccount then
		MsgBoxManager:showTipBox(LocalStrings.PLEASE_INPUT_ACCOUNT, nil, nil, nil, nil)
		local accountHighligh = GetElement(self.m_root, "accountHighligh_wndRegister", WZArmature)
		if accountHighligh ~= nil then
			accountHighligh:setVisible(true)
		end
		return false
	end
	
	if not Regexp:isLettersAndNumbers(self.m_sAccount) then
		MsgBoxManager:showTipBox(LocalStrings.ONLY_NUM_AND_LETTER, nil, nil, nil, nil)
		local accountHighligh = GetElement(self.m_root, "accountHighligh_wndRegister", WZArmature)
		if accountHighligh ~= nil then
			accountHighligh:setVisible(true)
		end
		return false
	end
	
	if string.len(self.m_sAccount) < 6 or string.len(self.m_sAccount) > 16 then
		MsgBoxManager:showTipBox(LocalStrings.ACCOUNT_LEN_ILLEGAL, nil, nil, nil, nil)
		local accountHighligh = GetElement(self.m_root, "accountHighligh_wndRegister", WZArmature)
		if accountHighligh ~= nil then
			accountHighligh:setVisible(true)
		end
		return false
	end
	
		
	return true
end

--@brief	密码检测函数
--@return	#1:密码是否符合要求
--@note		检测密码是否符合要求
function WndRegister:checkPassword()
	if type(self.m_sPassword) ~= "string" or "" == self.m_sPassword then
		MsgBoxManager:showTipBox(LocalStrings.PLEASE_INPUT_PSW, nil, nil, nil, nil)
		local passwordHighligh = GetElement(self.m_root, "passwordHighligh_wndRegister", WZArmature)
		if passwordHighligh ~= nil then
			passwordHighligh:setVisible(true)
		end
		return false
	end

	if Regexp:isHasBlankChar(self.m_sPassword) then
        MsgBoxManager:showTipBox(LocalStrings.NO_BLACKCHAR, nil, nil, nil, nil)
		return false
    end
    
    if Regexp:isHasControlChar(self.m_sPassword) then
        MsgBoxManager:showTipBox(LocalStrings.NO_CONTROLCHAR, nil, nil, nil, nil)
		return false
    end
	
	if string.len(self.m_sPassword) < 6 or string.len(self.m_sPassword) > 12 then
		MsgBoxManager:showTipBox(LocalStrings.PSW_LEN_ILLEGAL, nil, nil, nil, nil)
		local passwordHighligh = GetElement(self.m_root, "passwordHighligh_wndRegister", WZArmature)
		if passwordHighligh ~= nil then
			passwordHighligh:setVisible(true)
		end
		return false
	end
	
	return true
end

--@brief	密码核对函数
--@return	#1:两次输入的密码是否一致
--@note		检测两次输入的密码是否一致
function WndRegister:confirmPassword()
	if type(self.m_sPassword) ~= "string" or type(self.m_sPswConfirm) ~= "string" or self.m_sPassword ~= self.m_sPswConfirm then
		MsgBoxManager:showTipBox(LocalStrings.PSWCONFIRM_NOT_THE_SAME, nil, nil, nil, nil)
		local passwordRetryHighligh = GetElement(self.m_root, "passwordRetryHighligh_wndRegister", WZArmature)
		if passwordRetryHighligh ~= nil then
			passwordRetryHighligh:setVisible(true)
		end
		return false
	end
	
	return true
end

--@brief	邮箱检测函数
--@return	#1:邮箱是否符合要求
--@note		检测邮箱是否符合要求
function WndRegister:checkMail()
	if type(self.m_sMail) ~= "string" or "" == self.m_sMail then
		MsgBoxManager:showTipBox(LocalStrings.PLEASE_INPUT_MAIL, nil, nil, nil, nil)
		local email = GetElement(self.m_root, "email_wndRegister", WZArmature)
		if email ~= nil then
			email:setVisible(true)
		end
		return false
	end
	
	if not Regexp:isEmailAddress(self.m_sMail) then
		MsgBoxManager:showTipBox(LocalStrings.PLEASE_INPUT_CORRECT_MAIL, nil, nil, nil, nil)
		local email = GetElement(self.m_root, "email_wndRegister", WZArmature)
		if email ~= nil then
			email:setVisible(true)
		end
		return false
	end
	
	return true
end

--@brief	描边字多语言版本文本
function WndRegister:_moreLanguageForStroke()
	if self.m_root == nil then
		return
	end
	local txtSure = self.m_root:getChildElement("txtBtnSure_WndRegister")
	if txtSure then
		txtSure = WZUILabelTTF:luaTo(txtSure)
		txtSure:setText( LocalStrings.CONFIRM )
	end
	local txt1 = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtGoTo1_WndRegister"))
	local txt2 = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtGoTo2_WndRegister"))
	txt1:setText(LocalStrings.GOTOPROTOCOL)
	txt2:setText(LocalStrings.GOTOPROTOCOL)
	local w = (txt1:getContentSize().width-10)/txt1:getParentElement():getContentSize().width
	WZUIImage:luaTo(self.m_root:getChildElement("imgLine1_WndRegister")):setRelativeSize(GlobalMethod:CCSize(w,0.05))
	WZUIImage:luaTo(self.m_root:getChildElement("imgLine2_WndRegister")):setRelativeSize(GlobalMethod:CCSize(w,0.05))
	self:_showAgreement()--显示查看协议按钮
end

--@brief	显示查看协议按钮
function WndRegister:_showAgreement()
	local bShow = false
	WZLog("ProjConfig.userAgreement",ProjConfig.userAgreement,type(ProjConfig.userAgreement))
	if ProjConfig.userAgreement == "1" then
		bShow = true
	elseif ProjConfig.LANGUAGE ~= "cn" then
		bShow = false
	end
	local btnAgreement = WZUIButton:luaTo(self.m_root:getChildElement("btnAgreement_WndRegister"))
	btnAgreement:setVisible(bShow)
end

-------------------------------------私有方法模块End----------------------------------------
-------------------------------------多语言适配模块Begin------------------------------------
--@brief  越南语适配函数
--@return 无
--@note   备注
function WndRegister:_adaptLanguage_vn()
	--最底部提示标签
	local txtTip = self.m_root:getChildElement("txtTip_Register")
	txtTip:setMaxWidth(400)
	txtTip:setRelativePosition(GlobalMethod:ccp(0.48097,0.19))
    --账号提示
	local txtAccountTip = self.m_root:getChildElement("txtAccountTip_WndRegister")
	txtAccountTip:setFontSize(16)
    --密码提示
	local txtPasswordTip = self.m_root:getChildElement("txtPasswordTip_WndRegister")
	txtPasswordTip:setFontSize(16)
	-- txtPasswordTip:setDimensions(GlobalMethod:CCSize(200,0))
    --确认密码提示
	local txtPasswoerConfirmTip = self.m_root:getChildElement("txtPasswoerConfirmTip_WndRegister")
	txtPasswoerConfirmTip:setFontSize(16)
    --邮件格式提示
	local txtMailTip = self.m_root:getChildElement("txtMailTip_WndRegister")
	txtMialTip:setFontSize(16)


end



