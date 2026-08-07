--WndSuggestion.lua
--@brief	WndSuggestion的UI模块
--@date		2014/01/14
--@author	liangguang_long
--@note		意见箱模块


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSuggestion:onEnter(element)
	--SoundManager:playBgMusic(SoundDefine.E_S_OPEN_WIN)
	self.m_root = element
	self:_setPlaceHolderAlignment(TEDIT_ENUM.ALIGNMENTUP)
	self:_policy()
	--	多语言版本文本
	self:_initMoreLanguage()
	self:_moreLanguageFor18()
	--语言包适配
	AdaptLanguage(self)
	self:_initSelectBox()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSuggestion:onExit(element)
	self:_unInit()
end

--@brief	关闭按钮回调函数
function WndSuggestion:onCloseClick()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_root == nil then
		return
	end
	--关闭意见箱窗口
	WindowManager:removeWindow( self.m_root , WndSuggestion , true )
	
end

--@brief	确定按钮回调函数
function WndSuggestion:onSureClick()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_root == nil then
		return
	end
	local txt = self:_getSuggestionTxt()
	if txt == nil or txt == "" then
		WZLog("发送失败:::",txt)
		MsgBoxManager:showTipBox( LocalStrings.INPUTDETAIL )
		return
	end
	local theme = ""
	local senderId = GlobalGame.g_tPlayerInfo.nPlayerId
	local receiverId = 0
	local receiverName = "" 
	local mailType = tonumber(self:_getSugType())
	local content = txt
	WZLog("mailType::::::::::::::::::::::::::::",mailType)
	ProtocolProcessorWndSetting:send_MAIL_SendMail( theme, senderId, receiverId, receiverName, mailType, content )
	--创建加载框
	self:createLoading()
end

--@brief	取消按钮回调函数
function WndSuggestion:onCancelClick()
	if self.m_root == nil then
		return
	end
	--关闭意见箱窗口
	WindowManager:removeWindow( self.m_root , WndSuggestion , true )
end

--@brief	发送意见成功回调函数
function WndSuggestion:sendSuggestionSuccess()
	if self.m_root == nil then
		return
	end
	local txt = LocalStrings.SEND .." ".. LocalStrings.SUCCESS
	MsgBoxManager:showTipBox( txt )
	--关闭加载框
	self:closeLoading()	
	--关闭意见箱窗口
	self:onCancelClick()
	
end

--@brief	开始按下回调函数
function WndSuggestion:onTouchBegin(element,pt)
	--WndSelectBox:hideMenu()
	local bPoint = WndSelectBox:pointMenu(pt,GlobalMethod:ccp(40,10))
	if bPoint == false then
		WndSelectBox:hideMenu()
	end
end

--@brief	打开回调
--@note     点击意见框按钮时，编辑框不可用
function WndSuggestion:openMenuBackFun()
	self:setEditTouch(false)--意见箱编辑框不可触摸
end

--@brief	关闭回调
--@note     编辑框可用
function WndSuggestion:closeMenuBackFun()
	self:setEditTouch(true)--意见箱编辑框可触摸
end



--@brief   创建加载框
function WndSuggestion:createLoading()
	self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end

--@brief   关闭加载框
function WndSuggestion:closeLoading()
	local nId = self.m_nLoadingId
	MsgBoxManager:stopLoadingBoxByMsgId(nId)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	获取EditBox文本内容
function WndSuggestion:_getSuggestionTxt()
	if self.m_root == nil then
		return
	end
	local editEnter = self.m_root:getChildElement("editEnter_WndSuggestion")
	if editEnter == nil then
		return
	end
	editEnter = WZUIEditBox:luaTo(editEnter)
	local txt = editEnter:getText()
	return txt
end

--@brief	加载单选框
function WndSuggestion:_initSelectBox()
	local txt = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtMailType_WndSuggestion"))
	local txtSize = txt:getContentSize()
	local lpSize = txt:getParentElement():getContentSize()
	local tData = {}
	tData.winSize = GlobalMethod:CCSize(240,50)
	local conSug = WZUIContainer:luaTo(self.m_root:getChildElement("conSug_WndSuggestion"))
	if ProjConfig.LANGUAGE == "en" then--英文包
	elseif ProjConfig.LANGUAGE == "cn" then --中文包
		tData.winSize = GlobalMethod:CCSize(180,50)
	elseif ProjConfig.LANGUAGE == "vn" then -- 越南语
	elseif ProjConfig.LANGUAGE == "hk" then --繁体包
		tData.winSize = GlobalMethod:CCSize(180,50)
	elseif ProjConfig.LANGUAGE == "pt" then --葡萄语包
		tData.winSize = GlobalMethod:CCSize(200,50)
	end
	local lpX = (tData.winSize.width - conSug:getContentSize().width)/2
	local x = (txtSize.width + 8 + lpX )/lpSize.width
	conSug:setRelativePosition(GlobalMethod:ccp(x,conSug:getRelativePosition().y))
	WndSelectBox:showInterface(conSug,GlobalMethod:CCSize(tData.winSize.width,100),tData)
	WndSelectBox:setMenuHeight(0.34)
	self:_setMenuData()
	WndSelectBox:updateMenu()--更新菜单
	WndSelectBox:setMenuOpenBackFun(self,self.openMenuBackFun)  --打开回调
	WndSelectBox:setMenuCloseBackFun(self,self.closeMenuBackFun)  --关闭回调
end

--@brief	获取意见类型
function WndSuggestion:_getSugType()

	local str = WndSelectBox:getCurSelectBoxText()
	WZLog("WndSuggestion:_getSugType::::::",str,LocalStrings.SUGGESTTYPE_QUESTIONASK)
	if str == nil or str == "" then
		return 1
	elseif str == LocalStrings.SUGGESTTYPE_SUGGEST then
		return 1
	elseif str == LocalStrings.SUGGESTTYPE_QUESTIONASK then
		return 8
	elseif str == LocalStrings.SUGGESTTYPE_PAYASK then
		return 9
	else 
		return 1
	end
	
end

--@brief	多语言版本文本
function WndSuggestion:_initMoreLanguage()
	if self.m_root == nil then
		return
	end
	--[[
	--确定按钮
	local txtSure = self.m_root:getChildElement("txtSure_WndSuggestion")
	if txtSure then
		txtSure = WZUIShadowTTF:luaTo(txtSure)
		txtSure:setText( LocalStrings.CONFIRM )
	end
	--]]
	--初始化提示语
	self:setPlace( LocalStrings.SUGGESTION_INIT )
	--意见类型
	local txtMailType_WndSuggestion = self.m_root:getChildElement("txtMailType_WndSuggestion")
	if txtMailType_WndSuggestion then
		txtMailType_WndSuggestion = WZUILabelTTF:luaTo(txtMailType_WndSuggestion)
		txtMailType_WndSuggestion:setText( LocalStrings.SUGGESTTYPE)
		txtMailType_WndSuggestion:setVisible(true)
	end
end

--@brief	多语言描边字
function WndSuggestion:_moreLanguageFor18()
	if self.m_root == nil then
		return
	end
	--确定
	local txtSure = self.m_root:getChildElement("txtSure_WndSuggestion")
	if txtSure then
		txtSure = WZUILabelTTF:luaTo(txtSure)
		txtSure:setText(LocalStrings.CONFIRM)
		txtSure:setVisible(true)
	end
end

--@brief	初始化提示语
function WndSuggestion:setPlace(desc)
	local editEnter = self.m_root:getChildElement("editEnter_WndSuggestion")
	if editEnter then
		editEnter = WZUIEditBox:luaTo(editEnter)
		editEnter:setPlaceHolder( desc )
	end
end

--@brief	意见编辑框是否可触摸
function WndSuggestion:setEditTouch(bTouch)
	local editEnter = self.m_root:getChildElement("editEnter_WndSuggestion")
	if editEnter then
		editEnter = WZUIEditBox:luaTo(editEnter)
		editEnter:setTouchEnable(bTouch)
	end
end

--@brief	编辑框默认提示语
function WndSuggestion:_setPlaceHolderAlignment(alignment)
	local editEnter = self.m_root:getChildElement("editEnter_WndSuggestion")
	if editEnter then
		editEnter = WZUIEditBox:luaTo(editEnter)
		editEnter:setVerticalPlaceHolderAlignment(alignment)
		editEnter:setVerticalAlignment(alignment)
	end
end




-------------------------------------私有方法模块End----------------------------------------
