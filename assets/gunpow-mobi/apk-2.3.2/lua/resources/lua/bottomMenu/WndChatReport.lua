--WndChatReport.lua
--@brief	WndChatReport的UI模块
--@date		2019/08/13
--@author	Tianxiang_Xu
--@note		聊天举报


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndChatReport:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndChatReport:onExit(element)
	self:_unInit()
end

--@brief 	界面加载完成
function WndChatReport:onEnterTransitionDidFinish(element)
	--body
	WndChat:stopFrashMsgList()
	
	GetElement(self.m_root, "editSign_WndChatReport", WZUIEditBox):setPlaceHolder(LocalStrings.CHAT_REPORT_TEXT5)

	self:_update()
end

--@brief 	选择原因
function WndChatReport:onClickBox(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local nTag = element:getTag()
	self.m_nIndexSel = nTag
	WZLog("WndChatReport:onClickBox", nTag)
	if nTag == 4 then 
		local editSign = GetElement(self.m_root, "editSign_WndChatReport", WZUIEditBox)
		editSign:setTouchEnable(true)
	else
		GetElement(self.m_root, "editSign_WndChatReport", WZUIEditBox):setTouchEnable(false)
	end
end

--@brief 	点击确定
function WndChatReport:onClickSure(element)
	--body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_nIndexSel == nil then 
		MsgBoxManager:showTipBox(LocalStrings.CHAT_REPORT_TEXT7)
		return 
	end
	local editSign = GetElement(self.m_root, "editSign_WndChatReport", WZUIEditBox)
	local explain
	if editSign then 
		explain = editSign:getText()
	end
	WZLog("WndChatReport:onClickSure", tostring(explain))
	ProtocolProcessorGlobal:send_CHAT_ChatReport(self.m_tData.playerId, self.m_nIndexSel + 1, self.m_tData.content, explain or "")
end

--@brief 	点击取消按钮
function WndChatReport:onCLickCancel(element)
	--body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	self:closeReportWin()
end

--@brief 	关闭举报窗口
function WndChatReport:closeReportWin()
	-- body
	if self.m_root then 
		self.m_root:removeFromParentAndCleanup(true)
	end

	WndChat:stopFrashMsgList()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndChatReport:_update()
	-- body
	for i = 1, 5 do
		local txtCheck = GetElement(self.m_root, "txtCheck" .. i .. "_WndChatReport", WZUILabelTTF)
		local txtCheckSel = GetElement(self.m_root, "txtCheckSel" .. i .. "_WndChatReport", WZUILabelTTF)

		txtCheck:setText(LocalStrings.CHAT_REPORT_TEXT4[i])
		txtCheckSel:setText(LocalStrings.CHAT_REPORT_TEXT4[i])
	end
	--
	local txtReportedPlayer = GetElement(self.m_root, "txtReportedPlayer_WndChatReport", WZUILabelTTF)
	if txtReportedPlayer then 
		txtReportedPlayer:setText(string.format(LocalStrings.CHAT_REPORT_TEXT3, self.m_tData.playerName))
	end
end




-------------------------------------私有方法模块End----------------------------------------
