--WndExistAccount.lua
--@brief	WndExistAccount的UI模块
--@date		2014/01/24
--@author	SuYuan
--@note		已有账号窗口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndExistAccount:onEnter(element)
	self.m_root = element
	
	--设置控件静态文本
	self:_setUIStaticText()

	--多语言版本界面适配
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndExistAccount:onExit(element)
	self:_unInit()
end

--@brief	关闭按钮被按下时调用的函数
--@param	element:关闭按钮的UI节点引用
--@note		在这里做关闭按钮被按下时的响应操作
function WndExistAccount:onClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WZLog("hehe",self.m_tag)
	
	if g_passportwrongstate ~= nil then
	    local wndExistAccountLoginTip = WndExistAccountLoginTip:createElement()
		if wndExistAccountLoginTip ~= nil then
			WindowManager:addWindow(wndExistAccountLoginTip, WndExistAccountLoginTip)
			WndExistAccountLoginTip:setErrorTipText(LocalStrings.VERIFICATION_FAILED)
		end
		IPDConnector.g_bIpdConnectOk = false
    end
	WindowManager:removeWindow(self.m_root, self, true)
    

end

--@brief	确定按钮被按下时调用的函数
--@param	element:确定按钮的UI节点引用
--@note		在这里做确定按钮被按下时的响应操作
function WndExistAccount:onOK(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	if self:_checkAccount() and self:_checkPassword() then
		-- local data = WZDataFile:getInstance():getUserData()
		-- if data ~= nil then
		-- 	data:setStringValue("AccountData", "account", self.m_sAccount)
		-- 	data:setStringValue("AccountData", "password", self.m_sPassword)
		-- 	data:flush()
		-- end
        --SceneLogin:startLogin()
		--NetManager:connectServer(IPDConnector:getGameServerIP(), IPDConnector:getGameServerPort(), SceneLogin.connectCallback, SceneLogin)
        IPDConnector:connectIPDServer(self.m_sAccount,self.m_sPassword,true)
		self:startLoading()
	end
end

--@brief	返回账号密码验证结果时的回调函数
--@param	sErrorInfo:账号密码验证结果
--@note		返回账号密码验证结果时的回调函数
function WndExistAccount:cbExistAccountLoginFailed(sErrorInfo)
	self:stopLoading()

	local data = WZDataFile:getInstance():getUserData()
	if data ~= nil then
		data:setStringValue("AccountData", "account", "")
		data:setStringValue("AccountData", "password", "")
		data:flush()
	end
	
	local wndExistAccountLoginTip = WndExistAccountLoginTip:createElement()
	if wndExistAccountLoginTip ~= nil then
		WindowManager:addWindow(wndExistAccountLoginTip, WndExistAccountLoginTip)
		WndExistAccountLoginTip:setErrorTipText(sErrorInfo)
	end
end

--@brief	账号编辑框编辑开始时被调用的函数
--@param	element:账号编辑框的UI节点引用
--@note		在这里做相应的事件响应操作
function WndExistAccount:onEditAccountBegin(element)
	local txtAccountDefaultText= self.m_root:getChildElement("txtAccountDefaultText_WndExistAccount")
	if txtAccountDefaultText ~= nil then
		WZUILabelTTF:luaTo(txtAccountDefaultText):setText("")
	end
end

--@brief	账号编辑框编辑结束时被调用的函数
--@param	element:账号编辑框的UI节点引用
--@note		在这里做相应的事件响应操作
function WndExistAccount:onEditAccountEnd(element)
	local editAccount = WZUIEditBox:luaTo(element)
	if editAccount ~= nil then
		local sAccount = editAccount:getText()
		if sAccount == "" then
			local txtAccountDefaultText = self.m_root:getChildElement("txtAccountDefaultText_WndExistAccount")
			if txtAccountDefaultText ~= nil then
				WZUILabelTTF:luaTo(txtAccountDefaultText):setText(LocalStrings.CLICK_INPUT_ACCOUNT)
			end		
		end
		self.m_sAccount = sAccount
	end
end

--@brief	密码编辑框编辑开始时被调用的函数
--@param	element:密码编辑框的UI节点引用
--@note		在这里做相应的事件响应操作
function WndExistAccount:onEditPswBegin(element)
	local txtPswDefaultText= self.m_root:getChildElement("txtPswDefaultText_WndExistAccount")
	if txtPswDefaultText ~= nil then
		WZUILabelTTF:luaTo(txtPswDefaultText):setText("")
	end
end

--@brief	密码编辑框编辑结束时被调用的函数
--@param	element:密码编辑框的UI节点引用
--@note		在这里做相应的事件响应操作
function WndExistAccount:onEditPswEnd(element)
	local editPsw = WZUIEditBox:luaTo(element)
	if editPsw ~= nil then
		local sPsw = editPsw:getText()
		if sPsw == "" then
			local txtPswDefaultText = self.m_root:getChildElement("txtPswDefaultText_WndExistAccount")
			if txtPswDefaultText ~= nil then
				WZUILabelTTF:luaTo(txtPswDefaultText):setText(LocalStrings.CLICK_INPUT_PASSWORD)
			end		
		end
		self.m_sPassword = sPsw
	end
end

--@brief	关闭已有账号窗口
--@note 	提供给外部，用来关闭已有账号窗口
function WndExistAccount:closeWindow()
	if self.m_root ~= nil then
		WindowManager:removeWindow(self.m_root, self, true)
	end
end

--@brief	开始加载
--@note 	显示加载对话框
function WndExistAccount:startLoading()
	self.m_nLoadingBoxID = MsgBoxManager:showLoadingBox(60)
end

--@brief	停止加载
--@note 	关闭加载对话框
function WndExistAccount:stopLoading()
	if self.m_nLoadingBoxID ~= nil then
		MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingBoxID)
		self.m_nLoadingBoxID = nil
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	设置控件静态文本
--@note		设置控件静态文本
function WndExistAccount:_setUIStaticText()
	--描边字
	local txtOk = self.m_root:getChildElement("txtOk_WndExistAccount")
	if txtOk ~= nil then
		WZUILabelTTF:luaTo(txtOk):setText(LocalStrings.CONFIRM)
	end
	
	local txtAccountDefaultText = self.m_root:getChildElement("txtAccountDefaultText_WndExistAccount")
	if txtAccountDefaultText ~= nil then
		WZUILabelTTF:luaTo(txtAccountDefaultText):setText(LocalStrings.CLICK_INPUT_ACCOUNT)
	end
	local txtPswDefaultText = self.m_root:getChildElement("txtPswDefaultText_WndExistAccount")
	if txtPswDefaultText ~= nil then
		WZUILabelTTF:luaTo(txtPswDefaultText):setText(LocalStrings.CLICK_INPUT_PASSWORD)
	end
	local txtAccount = self.m_root:getChildElement("txtAccount_WndExistAccount")
	if txtAccount ~= nil then
		WZUILabelTTF:luaTo(txtAccount):setText(LocalStrings.WND_EXISTACCOUNT_ACCOUNT)
	end
	local txtPsw = self.m_root:getChildElement("txtPsw_WndExistAccount")
	if txtPsw ~= nil then
		WZUILabelTTF:luaTo(txtPsw):setText(LocalStrings.WND_EXISTACCOUNT_PASSWORD)
	end
end

--@brief	账号检测函数
--@return	#1:账号是否符合要求
--@note		检测账号是否符合要求
function WndExistAccount:_checkAccount()
	if type(self.m_sAccount) ~= "string" or "" == self.m_sAccount then
		MsgBoxManager:showTipBox(LocalStrings.PLEASE_INPUT_ACCOUNT, nil, nil, nil, nil)
		return false
	end
	--[[
	if not Regexp:isLettersAndNumbers(self.m_sAccount) then
		MsgBoxManager:showTipBox(LocalStrings.ONLY_NUM_AND_LETTER, nil, nil, nil, nil)
		return false
	end
	]]
	--[[
	if string.len(self.m_sAccount) < 3 or string.len(self.m_sAccount) > 16 then
		MsgBoxManager:showTipBox(LocalStrings.ACCOUNT_LEN_ILLEGAL, nil, nil, nil, nil)
		return false
	end
	]]
	return true
end

--@brief	密码检测函数
--@return	#1:密码是否符合要求
--@note		检测密码是否符合要求
function WndExistAccount:_checkPassword()
	if type(self.m_sPassword) ~= "string" or "" == self.m_sPassword then
		MsgBoxManager:showTipBox(LocalStrings.PLEASE_INPUT_PSW, nil, nil, nil, nil)
		return false
	end
	--[[
	if not Regexp:isLettersAndNumbers(self.m_sPassword) then
		MsgBoxManager:showTipBox(LocalStrings.ONLY_NUM_AND_LETTER, nil, nil, nil, nil)
		return false
	end
	]]
	--[[
	if string.len(self.m_sPassword) < 6 or string.len(self.m_sPassword) > 32 then
		MsgBoxManager:showTipBox(LocalStrings.PSW_LEN_ILLEGAL, nil, nil, nil, nil)
		return false
	end
	]]
	return true
end
-------------------------------------私有方法模块End----------------------------------------
-------------------------------------语言适配模块Begin----------------------------------------
--@brief	葡语适配函数
--@note		葡语适配函数
function WndExistAccount:_adaptLanguage_pt()
	local txtOk = self.m_root:getChildElement("txtOk_WndExistAccount")
	if txtOk ~= nil then
		WZUILabelTTF:luaTo(txtOk):setFontSize(26)
		--WZUILabelTTF:luaTo(txtStartGame):setRelativePosition(GlobalMethod:ccp(0.49,0.51))
	end
end

-------------------------------------语言适配模块End----------------------------------------




