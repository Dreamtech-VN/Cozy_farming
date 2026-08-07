--WndBossHall.lua
--@brief	WndBossHall的UI模块
--@date		2024/11/05
--@author	XTX
--@note		游戏内边玩边下进度窗口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndBossHall:onEnter(element)
	self.m_root = element

	GlobalGame:getGameEventDispathcer():Add(DownloadEvent.DownloadFinish,self._downloadFinish,self)
	AdaptLanguage(self)
end

--@brief onEnter函数执行完成回调
function WndBossHall:onEnterTransitionDidFinish(element)
    --弹窗动画
    --设置静态UI文本
	self:_setStaticUiText()

	self:_update()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndBossHall:onExit(element)
	GlobalGame:getGameEventDispathcer():Remove(DownloadEvent.DownloadFinish,self._downloadFinish,self)

	self:_unInit()
end


--@brief	关闭按钮点击时被调用的函数
--@param	element:表绑定的UI节点引用
function WndBossHall:onCloseWindowBtn(element)
	if self.m_root ~= nil then 
		--音效
		SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
        
        self:onCloseActionCallback()
	end 
end 
--@brief	退出场景时被调用的函数
function WndBossHall:onCloseActionCallback()
    WZLog("WndBossHall:onCloseActionCallback")
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	开始副本按钮点击时被调用的函数
--@param	element:表绑定的UI节点引用
function WndBossHall:onStartCopyBtn(element)
	--音效
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	if ProjConfig.DressAniDownloadConfig_All and ProjConfig.DressAniDownloadConfig_All ~= "" then
        DownloadManager:downloadResCheckAll()
        GlobalGame.g_bIsDownloadingResCheckAll = true

        self:_update()

        SceneCity:clickDownloadCallback()
    end
end 


--@brief	查找房间按钮点击时被调用的函数
--@param	element:表绑定的UI节点引用
function WndBossHall:onFindRoomBtn(element)
	WZLog("WndBossHall:onFindRoomBtn(element)")
	--音效
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
        
    self:onCloseActionCallback()
end 

--@brief	稍后按钮点击时的回调函数
function WndBossHall:onQuickJoinBtn(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
        
    self:onCloseActionCallback()
end 
-------------------------------------公有方法模块End----------------------------------------




-------------------------------------私有方法模块Begin--------------------------------------

--@brief	更新表格内容的函数
function WndBossHall:_update()
	if self.m_root == nil then 
		WZLog("WndBossHall:_update() self.m_root is nil ")
		return 
	end 

	if GlobalGame.g_bIsDownloadingResCheckAll == false then 
		GetElement(self.m_root, "conState1_WndBossHall", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "conState2_WndBossHall", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "btnStartDownload_WndBossHall", WZUIButton):setVisible(true)
		GetElement(self.m_root, "btnQuickJoin_WndBossHall", WZUIButton):setVisible(true)
		GetElement(self.m_root, "btnFindRoom_WndBossHall", WZUIButton):setVisible(false)

		self:_setDynamicUiText1()
	else
		GetElement(self.m_root, "conState1_WndBossHall", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "conState2_WndBossHall", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "btnStartDownload_WndBossHall", WZUIButton):setVisible(false)
		GetElement(self.m_root, "btnQuickJoin_WndBossHall", WZUIButton):setVisible(false)
		GetElement(self.m_root, "btnFindRoom_WndBossHall", WZUIButton):setVisible(true)

		self:_setDynamicUiText2()
	end
end 


--@brief 设置静态UI文本
function WndBossHall:_setStaticUiText()
	if self.m_root == nil then 
		WZLog(" WndBossHall:_setStaticUiText() self.m_root is nil ")
		return 
	end 
	
	--描边字
	local txtTitle = self.m_root:getChildElement("txtTitle_WndBossHall")
	if txtTitle ~= nil then 
		WZUILabelTTF:luaTo(txtTitle):setText(LocalStrings.OTHER_UI_TEXT[2])
	end 

	local txtDownloadAtt = self.m_root:getChildElement("txtDownloadAtt_WndBossHall")
	if txtDownloadAtt ~= nil then 
		WZUILabelTTF:luaTo(txtDownloadAtt):setText(LocalStrings.OTHER_UI_TEXT[4])
	end 

	local txtTips1 = self.m_root:getChildElement("txtTips1_WndBossHall")
	if txtTips1 ~= nil then 
		WZUILabelTTF:luaTo(txtTips1):setText(LocalStrings.OTHER_UI_TEXT[7])
	end 

	local txtStartCopy = self.m_root:getChildElement("txtStartCopy_WndBossHall")
	if txtStartCopy ~= nil then 
		WZUILabelTTF:luaTo(txtStartCopy):setText(LocalStrings.OTHER_UI_TEXT[3])
	end 
	local txtFindRoom = self.m_root:getChildElement("txtFindRoom_WndBossHall")
	if txtFindRoom ~= nil then 
		WZUILabelTTF:luaTo(txtFindRoom):setText(LocalStrings.OTHER_UI_TEXT[6])
	end 
	--
	local txtQuickJoin = self.m_root:getChildElement("txtQuickJoin_WndBossHall")
	if txtQuickJoin ~= nil then 
		WZUILabelTTF:luaTo(txtQuickJoin):setText(LocalStrings.OTHER_UI_TEXT[5])
	end 
end 

--@brief 设置动态UI文本
function WndBossHall:_setDynamicUiText1()
	local totalSize, downloadSize = DownloadManager:getTotalResSize()
	local txtDownloadSize = GetElement(self.m_root, "txtDownloadSize_WndBossHall", WZUILabelTTF)
	if txtDownloadSize then
		local nLeftSize = totalSize - downloadSize
		txtDownloadSize:setText(LocalStrings.OTHER_UI_TEXT[8] .. nLeftSize .. "MB")
	end
end

--@brief 设置动态UI文本
function WndBossHall:_setDynamicUiText2()
	local totalSize, downloadSize = DownloadManager:getTotalResSize()
	local txtTips2 = GetElement(self.m_root, "txtTips2_WndBossHall", WZUILabelTTF)
	if txtTips2 then
		txtTips2:setText(LocalStrings.DOWNLOAD_RESOURCE .. downloadSize .. "/" .. totalSize .. "MB")
	end
	local prgDownload = GetElement(self.m_root, "prgDownload_WndBossHall", WZUIProgress)
	if prgDownload then 
		prgDownload:setPercentage(math.floor(downloadSize/totalSize *100))
	end

	if totalSize == downloadSize then 
		local txtFindRoom = self.m_root:getChildElement("txtFindRoom_WndBossHall")
		if txtFindRoom ~= nil then 
			WZUILabelTTF:luaTo(txtFindRoom):setText(LocalStrings.MASTERINFO65)
		end 

		txtTips2:setText(LocalStrings.OTHER_UI_TEXT[2] .. LocalStrings.MASTERINFO65)
	end
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配器模块Begin--------------------------------------
function WndBossHall:_adaptLanguage_vn(  )
	local txtDownloadAtt = self.m_root:getChildElement("txtDownloadAtt_WndBossHall")
	if txtDownloadAtt ~= nil then 
		WZUILabelTTF:luaTo(txtDownloadAtt):setFontSize(20)
	end 
end
-------------------------------------语言适配器模块End----------------------------------------
