--WndExistAccountLoginTip.lua
--@brief	WndExistAccountLoginTip的UI模块
--@date		2014/01/24
--@author	SuYuan
--@note		已有账号登录提示窗口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndExistAccountLoginTip:onEnter(element)
	self.m_root = element
	
	--设置控件静态文本
	self:_setUIStaticText()

    --多语言版本界面适配
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndExistAccountLoginTip:onExit(element)
	self:_unInit()
end

--@brief	重新注册按钮被按下时调用的函数
--@param	element:重新注册按钮的UI节点引用
--@note		在这里做重新注册按钮被按下时的响应操作
function WndExistAccountLoginTip:onRegisterAgain(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	WindowManager:removeWindow(self.m_root, self, true)
	WndExistAccount:closeWindow()
    --SceneLogin:startLogin()
   local accountName = WGameCmUtil:GetUDID()


	local data = WZDataFile:getInstance():getUserData()
	if nil == data then
		WZLog("WZDataFile is nil")
		return
	end
	
	--本地账号设置为空  用uid去当账号密码
	data:setStringValue("AccountData", "account", "")
	data:setStringValue("AccountData", "password", "")
	data:flush()

    WZLog("WndExistAccountLoginTip:onRegisterAgain",accountName,passWord)
	--IPDConnector:connectIPDServer(accountName,accountName)
	g_passportwrongstate = nil
	local frame = WZUISystem:getInstance():createElement("splash")
	replaceScene(frame)
	
	--NetManager:connectServer(IPDConnector:getGameServerIP(), IPDConnector:getGameServerPort(), SceneLogin.connectCallback, SceneLogin)
end

--@brief	重新输入按钮被按下时调用的函数
--@param	element:重新输入按钮的UI节点引用
--@note		在这里做重新输入按钮被按下时的响应操作
function WndExistAccountLoginTip:onLoginAgain(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if not WindowManager:ifWindowExist(WndExistAccount) then
		local wndExistAccount = WndExistAccount:createElement()
        if wndExistAccount ~= nil then
        	WindowManager:addWindow(wndExistAccount, WndExistAccount)
        end
	end

	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	设置错误提示文本
--@param	sErrorTip:错误提示
--@note		设置错误提示文本
function WndExistAccountLoginTip:setErrorTipText(sErrorTip)
	local txtTip = self.m_root:getChildElement("txtTip_WndExistAccountLoginTip")
	if txtTip ~= nil then
		WZUILabelTTF:luaTo(txtTip):setText(sErrorTip)
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	设置控件静态文本
--@note		设置控件静态文本
function WndExistAccountLoginTip:_setUIStaticText()
	--描边字
	local txtRegisterAgain = self.m_root:getChildElement("txtRegisterAgain_WndExistAccountLoginTip")
	if txtRegisterAgain ~= nil then
		WZUILabelTTF:luaTo(txtRegisterAgain):setText(LocalStrings.REGISTER_AGAIN)
	end
	local txtLoginAgain = self.m_root:getChildElement("txtLoginAgain_WndExistAccountLoginTip")
	if txtLoginAgain ~= nil then
		WZUILabelTTF:luaTo(txtLoginAgain):setText(LocalStrings.LOGIN_AGAIN)
	end
end

-------------------------------------私有方法模块End----------------------------------------
-------------------------------------语言适配模块Begin----------------------------------------
--@brief	葡语适配函数
--@note		葡语适配函数
function WndExistAccountLoginTip:_adaptLanguage_pt()
	local txtRegisterAgain = self.m_root:getChildElement("txtRegisterAgain_WndExistAccountLoginTip")
	if txtRegisterAgain ~= nil then
		WZUILabelTTF:luaTo(txtRegisterAgain):setFontSize(20)
		WZUILabelTTF:luaTo(txtRegisterAgain):setDimensions(GlobalMethod:CCSize(120,0))
	end

	local txtLoginAgain = self.m_root:getChildElement("txtLoginAgain_WndExistAccountLoginTip")
	if txtLoginAgain ~= nil then
		WZUILabelTTF:luaTo(txtLoginAgain):setFontSize(20)
		WZUILabelTTF:luaTo(txtLoginAgain):setDimensions(GlobalMethod:CCSize(120,0))
	end
end

-------------------------------------语言适配模块End----------------------------------------



