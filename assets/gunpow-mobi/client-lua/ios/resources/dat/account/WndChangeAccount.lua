--WndChangeAccount.lua
--@brief	WndChangeAccount的UI模块
--@date		2014/01/23
--@author	SuYuan
--@note		切换账号窗口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndChangeAccount:onEnter(element)
	self.m_root = element
	
	--设置控件静态文本
	self:_setUIStaticText()
	--语言包适配
	AdaptLanguage(self)
	--描边字多语言版本文本
	self:_moreLanguageForStroke()

	--切换账号后切换到小岛
	ChangeChatChannel(Chat_Channel_Island)
end

--@brief onEnter函数执行完成回调
function WndChangeAccount:onEnterTransitionDidFinish(element)
--弹窗动画
WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
end

--@brief    弹窗动画完成后的回调
function WndChangeAccount:actionCallback(element,data)

end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndChangeAccount:onExit(element)
	self:_unInit()
end

--@brief	关闭按钮被按下时调用的函数
--@param	element:关闭按钮的UI节点引用
--@note		在这里做关闭按钮被按下时的响应操作
function WndChangeAccount:onClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManagerAni:createCloseAction(self.m_root,"actionCallback_close",self)
	--WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    弹窗动画完成后的回调
function WndChangeAccount:actionCallback_close(element,data)
WindowManager:removeWindow(self.m_root , self , true)
end

--@brief	确定按钮被按下时调用的函数
--@param	element:确定按钮的UI节点引用
--@note		在这里做确定按钮被按下时的响应操作
function WndChangeAccount:onOK(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	IPDConnector.g_nNetConnectFlag  = NET_FLAG_1 
	-- 
	-- 	ProtocolProcessorAccount:send_ACCOUNT_Verification(self.m_sAccount, self.m_sPassword)
	-- 	self:startLoading()
	-- 
    
	if self:_checkAccount() and self:_checkPassword() then
    	--连IPD 不加载资源
		WZLog("WndChangeAccount",self.m_sAccount,self.m_sPassword)
		self:startLoading()
		IPDConnector:connectIPDServer(self.m_sAccount,self.m_sPassword,true)
	end
    --重新设置本地账号


end


-- function  WndChangeAccount:changeok( )
-- 	local data = WZDataFile:getInstance():getUserData()
-- 	if data ~= nil then
-- 		if self.m_sAccount ~= nil and self.m_sPassword ~= nil then
-- 			data:setStringValue("AccountData", "account", self.m_sAccount)
-- 			data:setStringValue("AccountData", "password", self.m_sPassword)
-- 			data:flush()
-- 		end
-- 	end
-- end

--@brief	返回账号密码验证结果时的回调函数
--@param	nResult:账号密码验证结果
--@note		返回账号密码验证结果时的回调函数
function WndChangeAccount:cbVerificationResult(nResult)
	if 0 == nResult then
		local data = WZDataFile:getInstance():getUserData()
		if data ~= nil then
			data:setStringValue("AccountData", "account", self.m_sAccount)
			data:setStringValue("AccountData", "password", self.m_sPassword)
			data:flush()
		end
		--NetManager:closeConnect()

        GlobalGame:reset()
        CacheCenter:reset() 
        
        PrefetchCache:reset()
        
        WndChat:chatrelease()

        WndCurrentChat:releaseRoot()
        --SceneLogin:startLogin()s
		local frame = WZUISystem:getInstance():createElement("splash")
		replaceScene(frame)
      
		--NetManager:connectServer(IPDConnector:getGameServerIP(), IPDConnector:getGameServerPort(), SceneLogin.connectCallback, SceneLogin)
        
	elseif 1 == nResult then
		self:stopLoading()
		MsgBoxManager:showTipBox(LocalStrings.VERIFICATION_FAILED, nil, nil, nil, nil)
	end
end

--@brief	账号编辑框编辑开始时被调用的函数
--@param	element:账号编辑框的UI节点引用
--@note		在这里做相应的事件响应操作
function WndChangeAccount:onEditAccountBegin(element)
	local txtAccountDefaultText= self.m_root:getChildElement("txtAccountDefaultText_WndChangeAccount")
	if txtAccountDefaultText ~= nil then
		WZUILabelTTF:luaTo(txtAccountDefaultText):setText("")
	end
	WZLog("WndChangeAccount:onEditAccountBegin")
end

--@brief	账号编辑框编辑结束时被调用的函数
--@param	element:账号编辑框的UI节点引用
--@note		在这里做相应的事件响应操作
function WndChangeAccount:onEditAccountEnd(element)
	local editAccount = WZUIEditBox:luaTo(element)
	WZLog("WndChangeAccount:onEditAccountEnd")
	if editAccount ~= nil then
		local sAccount = editAccount:getText()
		if sAccount == "" then
			local txtAccountDefaultText = self.m_root:getChildElement("txtAccountDefaultText_WndChangeAccount")
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
function WndChangeAccount:onEditPswBegin(element)
	local txtPswDefaultText= self.m_root:getChildElement("txtPswDefaultText_WndChangeAccount")
	WZLog("WndChangeAccount:onEditPswBegin")
	if txtPswDefaultText ~= nil then
		WZUILabelTTF:luaTo(txtPswDefaultText):setText("")
	end
end

--@brief	密码编辑框编辑结束时被调用的函数
--@param	element:密码编辑框的UI节点引用
--@note		在这里做相应的事件响应操作
function WndChangeAccount:onEditPswEnd(element)
	local editPsw = WZUIEditBox:luaTo(element)
	WZLog("WndChangeAccount:onEditPswEnd")
	if editPsw ~= nil then
		local sPsw = editPsw:getText()
		if sPsw == "" then
			local txtPswDefaultText = self.m_root:getChildElement("txtPswDefaultText_WndChangeAccount")
			if txtPswDefaultText ~= nil then
				WZUILabelTTF:luaTo(txtPswDefaultText):setText(LocalStrings.CLICK_INPUT_PASSWORD)
			end		
		end
		self.m_sPassword = sPsw
	end
end

--@brief	开始加载
--@note 	显示加载对话框
function WndChangeAccount:startLoading()
	self.m_nLoadingBoxID = MsgBoxManager:showLoadingBox(60)
end

--@brief	停止加载
--@note 	关闭加载对话框
function WndChangeAccount:stopLoading()
	if self.m_nLoadingBoxID ~= nil then
		MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingBoxID)
		self.m_nLoadingBoxID = nil
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	设置控件静态文本
--@note		设置控件静态文本
function WndChangeAccount:_setUIStaticText()
	--[[
	local stxtOK = self.m_root:getChildElement("stxtOK_WndChangeAccount")
	if stxtOK ~= nil then
		WZUIShadowTTF:luaTo(stxtOK):setText(LocalStrings.CONFIRM)
	end
	]]
	local txtAccountDefaultText = self.m_root:getChildElement("txtAccountDefaultText_WndChangeAccount")
	if txtAccountDefaultText ~= nil then
		WZUILabelTTF:luaTo(txtAccountDefaultText):setText(LocalStrings.CLICK_INPUT_ACCOUNT)
	end
	local txtPswDefaultText = self.m_root:getChildElement("txtPswDefaultText_WndChangeAccount")
	if txtPswDefaultText ~= nil then
		WZUILabelTTF:luaTo(txtPswDefaultText):setText(LocalStrings.CLICK_INPUT_PASSWORD)
	end
	local txtAccount = self.m_root:getChildElement("txtAccount_WndChangeAccount")
	if txtAccount ~= nil then
		WZUIFreeTextBox:luaTo(txtAccount):setShowText(LocalStrings.ACCOUNT)
	end
	local txtPsw = self.m_root:getChildElement("txtPsw_WndChangeAccount")
	if txtPsw ~= nil then
		WZUIFreeTextBox:luaTo(txtPsw):setShowText(LocalStrings.PASSWORD)
	end
end

--@brief	账号检测函数
--@return	#1:账号是否符合要求
--@note		检测账号是否符合要求
function WndChangeAccount:_checkAccount()
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
	return true
end

--@brief	密码检测函数
--@return	#1:密码是否符合要求
--@note		检测密码是否符合要求
function WndChangeAccount:_checkPassword()
	WZLog("WndChangeAccount:_checkPassword",self.m_sPassword,type(self.m_sPassword))
	if type(self.m_sPassword) ~= "string" or "" == self.m_sPassword then
		MsgBoxManager:showTipBox(LocalStrings.PLEASE_INPUT_PSW, nil, nil, nil, nil)
		return false
	end

	return true
end

--@brief	描边字多语言版本文本
function WndChangeAccount:_moreLanguageForStroke()
	if self.m_root == nil then
		return
	end
	local txtSure = self.m_root:getChildElement("txtBtnSure_WndChangeAccount")
	if txtSure then
		txtSure = WZUILabelTTF:luaTo(txtSure)
		txtSure:setText( LocalStrings.CONFIRM)
	end
end

-------------------------------------私有方法模块End----------------------------------------





