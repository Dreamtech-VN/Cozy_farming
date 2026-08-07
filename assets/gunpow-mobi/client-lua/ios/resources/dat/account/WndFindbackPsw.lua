--WndFindbackPsw.lua
--@brief	WndFindbackPsw的UI模块
--@date		2014/01/23
--@author	SuYuan
--@note		找回密码窗口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFindbackPsw:onEnter(element)
	self.m_root = element
	
	--设置控件静态文本
	self:_setUIStaticText()
	--语言包适配
	AdaptLanguage(self)
	--描边字多语言版本文本
	self:_moreLanguageForStroke()
end

--@brief onEnter函数执行完成回调
function WndFindbackPsw:onEnterTransitionDidFinish(element)
    --弹窗动画
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
end

--@brief    弹窗动画完成后的回调
function WndFindbackPsw:actionCallback(element,data)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFindbackPsw:onExit(element)
	self:_unInit()
end

--@brief	关闭按钮被按下时调用的函数
--@param	element:关闭按钮的UI节点引用
--@note		在这里做关闭按钮被按下时的响应操作
function WndFindbackPsw:onClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManagerAni:createCloseAction(self.m_root,"actionCallback_close",self)
	--WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    弹窗动画完成后的回调
function WndFindbackPsw:actionCallback_close(element,data)
    WindowManager:removeWindow(self.m_root , self , true)
end


--@brief	确定按钮被按下时调用的函数
--@param	element:确定按钮的UI节点引用
--@note		在这里做确定按钮被按下时的响应操作
function WndFindbackPsw:onOK(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	if self:_checkMail() then
		ProtocolProcessorAccount:send_ACCOUNT_FindPassword(self.m_sMail)
	end
end

--@brief	邮箱编辑框编辑开始时被调用的函数
--@param	element:账号编辑框的UI节点引用
--@note		在这里做相应的事件响应操作
function WndFindbackPsw:onEditMailBegin(element)
	local txtMailDefaultText= self.m_root:getChildElement("txtMailDefaultText_WndFindbackPsw")
	if txtMailDefaultText ~= nil then
		WZUILabelTTF:luaTo(txtMailDefaultText):setText("")
	end
end

--@brief	邮箱编辑框编辑结束时被调用的函数
--@param	element:账号编辑框的UI节点引用
--@note		在这里做相应的事件响应操作
function WndFindbackPsw:onEditMailEnd(element)
	local editMail = WZUIEditBox:luaTo(element)
	if editMail ~= nil then
		local sMail = editMail:getText()
		if sMail == "" then
			local txtMailDefaultText = self.m_root:getChildElement("txtMailDefaultText_WndFindbackPsw")
			if txtMailDefaultText ~= nil then
				WZUILabelTTF:luaTo(txtMailDefaultText):setText(LocalStrings.CLICK_INPUT_MAIL)
			end		
		end
		self.m_sMail = sMail
	end
end

--@brief	找回密码成功后的回调函数
--@note		找回密码成功后的回调函数
function WndFindbackPsw:cbFindbackPswSuccess()
	MsgBoxManager:showTipBox(LocalStrings.EMAIL_SENDED, nil, nil, nil, nil)
	WindowManager:removeWindow(self.m_root, self, true)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	设置控件静态文本
--@note		设置控件静态文本
function WndFindbackPsw:_setUIStaticText()
	--[[
	local stxtOK = self.m_root:getChildElement("stxtOK_WndFindbackPsw")
	if stxtOK ~= nil then
		WZUIShadowTTF:luaTo(stxtOK):setText(LocalStrings.CONFIRM)
	end
	]]
	local txtTip = self.m_root:getChildElement("txtTip_WndFindbackPsw")
	if txtTip ~= nil then
		WZUILabelTTF:luaTo(txtTip):setText(LocalStrings.FINDBACK_PSW_TIP)
	end
	local txtMailDefaultText = self.m_root:getChildElement("txtMailDefaultText_WndFindbackPsw")
	if txtMailDefaultText ~= nil then
		WZUILabelTTF:luaTo(txtMailDefaultText):setText(LocalStrings.CLICK_INPUT_MAIL)
	end
end

--@brief	邮箱检测函数
--@return	#1:邮箱是否符合要求
--@note		检测邮箱是否符合要求
function WndFindbackPsw:_checkMail()
	if type(self.m_sMail) ~= "string" or "" == self.m_sMail then
		MsgBoxManager:showTipBox(LocalStrings.PLEASE_INPUT_MAIL, nil, nil, nil, nil)
		return false
	end
	
	if not Regexp:isEmailAddress(self.m_sMail) then
		MsgBoxManager:showTipBox(LocalStrings.PLEASE_INPUT_CORRECT_MAIL, nil, nil, nil, nil)
		return false
	end
	
	return true
end

--@brief	描边字多语言版本文本
function WndFindbackPsw:_moreLanguageForStroke()
	if self.m_root == nil then
		return
	end
	local txtSure = self.m_root:getChildElement("txtBtnSure_WndFindbackPsw")
	if txtSure then
		txtSure = WZUILabelTTF:luaTo(txtSure)
		txtSure:setText( LocalStrings.CONFIRM)
	end
end

-------------------------------------私有方法模块End----------------------------------------




