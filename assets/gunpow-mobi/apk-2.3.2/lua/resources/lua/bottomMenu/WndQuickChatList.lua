--WndQuickChatList.lua
--@brief	WndQuickChatList的UI模块
--@date		2021/05/19
--@author	XTX
--@note		快捷发言界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndQuickChatList:onEnter(element)
	self.m_root = element
	CacheCenter:registerUpatePlayerInfoObserver(self)--注册人物
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndQuickChatList:onExit(element)
	g_nQuickChatDefaultIndex = self.m_nSelTab
	CacheCenter:unregisterUpatePlayerInfoObserver(self)
	self:_unInit()
end


--@brief	创建窗口动画
function WndQuickChatList:onEnterTransitionDidFinish(element)
	local txtTitle = GetElement(self.m_root, "txtTitle_WndQuickChatList", WZUILabelTTF)
	if self.m_nType == 2 then 
		if txtTitle then 
			txtTitle:setTextKey("QUICKCHAT_TEXT1")
		end
	end
	if g_nQuickChatDefaultIndex ~= nil then 
		self.m_nSelTab = g_nQuickChatDefaultIndex
	end
	GetElement(self.m_root, "cbgChannel_WndQuickChatList", WZUICheckBoxGroup):setCheckIndex(self.m_nSelTab - 1)
    self:setData()
end

--@brief	单击关闭按钮时被调用的函数
--@note	关闭后返回主界面
function WndQuickChatList:onClickClose(element)
	WZLog("单击关闭按钮")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	WindowManager:removeWindow(self.m_root , WndQuickChatList , true)
end

--@brief 	点击标签回调
function WndQuickChatList:onClickTab(element)
	-- body
	local nTag = element:getTag()
	if nTag == self.m_nSelTab then return end 

	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	self.m_nSelTab = nTag 
	self:_showAllList()
end
--@brief 	修改快捷发言内容
function WndQuickChatList:onClickEdit(element)
	-- body
	local nTag = element:getTag()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WndEditBox:showInterface(4, LocalStrings.QUICKCHAT_TEXT7, LocalStrings.QUICKCHAT_TEXT8, nil, nil, self.changeChatText, self, nTag)
end

--@brief 	确认修改回调
function WndQuickChatList:changeChatText(content, ...)
	local param = {...}
	WZLog("WndQuickChatList:changeChatText", content, Serialize(param))

	ProtocolProcessorWndSetting:send_PLAYER2_ChangePlayerChatshortcut( self.m_nSelTab, param[1] - 1, content)
end

--@brief 	发送快捷聊天
function WndQuickChatList:onClickSendMsg(element)
	-- body
	local nTag = element:getTag()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local channel = CHANNEL_CURRENT
	if self.m_nSelTab == 2 then 
		channel = CHANNEL_TEAM
	end
	local chatList = self.m_tAllChatList[self.m_nSelTab]
	if chatList[nTag] == nil or chatList[nTag] == "" or chatList[nTag] == "null" or chatList[nTag] == " " then 
		MsgBoxManager:showTipBox(LocalStrings.QUICKCHAT_TEXT6)
		return 
	end
	if HaveLimitFace(chatList[nTag]) then 
		return 
	end
	WndChat:sendChatByChannel(channel, chatList[nTag])
	WindowManager:removeWindow(self.m_root , WndQuickChatList , true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	显示
function WndQuickChatList:_showAllList()
	-- body
	local tbList = GetElement(self.m_root, "tbList_WndQuickChatList", WZUITableContainer)
	tbList:cleanTable()
	local chatList = self.m_tAllChatList[self.m_nSelTab]

	for i = 1, #chatList do
		local element = WZUISystem:getInstance():createElement("CellQuickChat")
		if element then 
			element:setVisible(true)
			element:setTag(i - 1)
			local txtContent = GetElement(element, "txtContent_WndQuickChatList", WZUILabelTTF)
			if txtContent then 
				if chatList[i] == "" or chatList[i] == " " or chatList[i] == "null" then 
					txtContent:setText("")
				else
					txtContent:setText(chatList[i])
				end
			end
			local btnEdit = GetElement(element, "btnEdit_WndQuickChatList", WZUIButton)
			local btnSendMsg = GetElement(element, "btnSendMsg_WndQuickChatList", WZUIButton)
			if btnEdit then 
				btnEdit:setTag(i)
				if self.m_nType == 1 then 
					btnEdit:setVisible(true)
				end
			end
			if btnSendMsg then 
				btnSendMsg:setTag(i)
				if self.m_nType == 2 then 
					btnSendMsg:setVisible(true)
				end
			end

			tbList:setCellElement(element)
		end
	end
end




-------------------------------------私有方法模块End----------------------------------------
