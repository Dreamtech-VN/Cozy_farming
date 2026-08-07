--WndCommunityPopContent.lua
--@brief	WndCommunityPopContent的UI模块
--@date		2013/12/28
--@author	林庆凯
--@note		修改外部公告，修改内部宣言，战况，群发邮件共用的弹出框


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCommunityPopContent:onEnter(element)
	self.m_root = element
	self:_policy()
	--静态初始化UI文字
	self:_initUiStaticText()
	self:_setPlaceHolderAlignment(TEDIT_ENUM.ALIGNMENTUP)
	--多语言描边字
	self:_moreLanguageForStroke()
	WindowManagerAni:createAction(element,true)
	--编辑框内容对齐方式
    self:_setPlaceHolderAlignment(TEDIT_ENUM.ALIGNMENTUP)
    --多语言版本界面适配
    AdaptLanguage(self)

end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCommunityPopContent:onExit(element)
	self:_unInit()
end

function WndCommunityPopContent:onActionCallBack()
	if self.m_root ~= nil then 
		WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
	end 
end

function WndCommunityPopContent:onCloseActionCallback()
	WindowManager:removeWindow(self.m_root, WndCommunityPopContent, true)
end

--@brief	关闭场景时被调用的函数
--@param	element:表绑定的UI节点引用
function WndCommunityPopContent:onCloswWindowBtn(element)
	if self.m_root ~= nil then 
		--音效
		SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
		WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
	end 
end 

--*****************************修改内部公告，外部公会窗口公有函数BEGIN********************************
--@brief	修改宣言，群发邮件按钮
--@param	element:表绑定的UI节点引用
function WndCommunityPopContent:onClickSureBtn(element)
	WZLog("WndCommunityPopContent:onClickSureBtn(element)")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local txtInPut = self:getEditBoxInputContent()
	if txtInPut == nil or txtInPut == "" then 
		MsgBoxManager:showTipBox(LocalStrings.INPUTDETAIL .. "!") 
		return 
	end 
	local _, isMingan = CheckYellow(txtInPut)
    if isMingan then
        MsgBoxManager:showTipBox(LocalStrings.NON_COMPLIANT)
        return false
    end
	--判断是否是外部宣言内容界面
	if self.nCurWindowTag == 1 then 
		--ProtocolProcessorSceneCommunity:send_COMMUNITY_ModifyDeclaration(self.m_nCommunityId,txtInPut)
		ProtocolProcessorSceneCommunity:send_GUILD_EditGuildDesc(txtInPut )
		WindowManager:removeWindow(self.m_root, WndCommunityPopContent, true)
	--判断是否是内部公告内容界面
	elseif self.nCurWindowTag == 2 then 
		--ProtocolProcessorSceneCommunity:send_COMMUNITY_ModifyNotice(self.m_nCommunityId,txtInPut)
	--判断是否是群发会员邮件界面
	elseif self.nCurWindowTag == 3 then 
		ProtocolProcessorSceneCommunity:send_GUILD_SendGuildMail(txtInPut )
		WindowManager:removeWindow(self.m_root, WndCommunityPopContent, true)
	end 
end 

--@brief	点击取消按钮时被调用的函数
--@param	element:表绑定的UI节点引用
function WndCommunityPopContent:onClickCancelBtn(element)
	self:onCloswWindowBtn()
end 

--@brief	设置公告标题被调用的函数
--@param	nImg: 0为不显示,1为公会宣言，2不用，3群发邮件
function WndCommunityPopContent:setImgTitle(nImg)
	if self.m_root == nil then 
		WZLog("WndCommunityPopContent:setImgTitle(nImg) self.m_root is nil ")
	end 
	
	if 0 == nImg  then     	 --不显示
	
	elseif 1 == nImg then    --外部宣言
		GetElement(self.m_root, "ttfTitle_WndCommunityPopContent", WZUILabelTTF):setText(string.sub(LocalStrings.COMMUNITYINFO58,1,-2))
		GetElement(self.m_root, "txtDeclareLenAtt_WndCommunityPopContent", WZUILabelTTF):setText(LocalStrings.COMMUNITY_DECLARElEN_ATT)
	elseif 2 == nImg then    --公告内容
	
	elseif 3 == nImg then    --群发邮件内容
		GetElement(self.m_root, "txtDeclareLenAtt_WndCommunityPopContent", WZUILabelTTF):setText("")
		GetElement(self.m_root, "ttfTitle_WndCommunityPopContent", WZUILabelTTF):setText(LocalStrings.COMMUNITY5)
		GetElement(self.m_root, "txtSure_WndCommunityPopContent", WZUILabelTTF):setText(LocalStrings.SEND)
	end 
end 

--@brief	设置敌对公会按钮是否可见的函数
--@param  nVisable  是否可见 
function WndCommunityPopContent:setEnemyCommunityBtnIsVisible(nVisable)
	if self.m_root == nil then 
		WZLog(" WndCommunityPopContent:setEnemyCommunityBtnIsVisible(nVisable) self.m_root is nil ")
		return 
	end 
	local btnSetEnemyCommunity = self.m_root:getChildElement("btnSetEnemyCommunity_WndCommunityPopContent")
	if btnSetEnemyCommunity ~= nil then 
		btnSetEnemyCommunity = WZUIButton:luaTo(btnSetEnemyCommunity)
		if btnSetEnemyCommunity ~= nil then 
			btnSetEnemyCommunity:setVisible(nVisable)
		end 
	end 
end 

--@brief	设置敌对公会按钮是否可使用的函数
--@param   bIsCanUse  是否可使用 
function WndCommunityPopContent:setEnemyCommunityBtnIsCanUse(bIsCanUse)
	if self.m_root == nil then 
		WZLog("WndCommunityPopContent:setEnemyCommunityBtnIsCanUse(bIsCanUse) self.m_root is nil")
		return 
	end 
	local btnSetEnemyCommunity = self.m_root:getChildElement("btnSetEnemyCommunity_WndCommunityPopContent")
	if btnSetEnemyCommunity ~= nil then 
		btnSetEnemyCommunity = WZUIButton:luaTo(btnSetEnemyCommunity)
		if btnSetEnemyCommunity ~= nil then 
			btnSetEnemyCommunity:setTouchEnable(bIsCanUse)
		end 
	end 
end 

--@brief	设置确定取消按钮是否可见的函数
--@param  nVisable  是否可见 
function WndCommunityPopContent:setSureOrCancelBtnVisible(nVisable)
	if self.m_root == nil then 
		WZLog("  WndCommunityPopContent:setSureOrCancelBtnVisible(nVisable) self.m_root is nil ")
		return 
	end 
	local conBtnSureAndNot = self.m_root:getChildElement("conBtnSureAndNot_WndCommunityPopContent")
	if conBtnSureAndNot ~= nil then 
		conBtnSureAndNot = WZUIContainer:luaTo(conBtnSureAndNot)
		if conBtnSureAndNot ~= nil then 
			conBtnSureAndNot:setVisible(nVisable)
		end 
	end 
end 

--@brief	设置内部公告内容和外部宣言文本内容的函数
--@param  sTextContent  文本内容
function WndCommunityPopContent:setTxtCommunityContent(sTextContent)
	if self.m_root == nil then 
		WZLog(" WndCommunityPopContent:txtContent_WndCommunityPopContent(sTextContent)")
		return 
	end 
	local txtContent = self.m_root:getChildElement("txtContent_WndCommunityPopContent")
	if txtContent ~= nil then 
		txtContent = WZUILabelTTF:luaTo(txtContent)
		if txtContent ~= nil then 
			txtContent:setText(sTextContent)
			txtContent:setVisible(true)
		end 
	end 
end 

--@brief 设置编辑框是否移除函数
--@param bDesdroy  是否移除
function WndCommunityPopContent:setInputContentEditBoxDestroy(bDesdroy)
	if self.m_root == nil or bDesdroy == nil then 
		WZLog("WndCommunityPopContent:setInputContentEditBoxDestroy(bDesdroy) self.m_root or bTouch is nil ")
		return 
	end 

	local editBoxInPutContent = self.m_root:getChildElement("editBoxInPutContent_WndCommunityPopContent")
	if editBoxInPutContent ~= nil then 
		editBoxInPutContent = WZUIEditBox:luaTo(editBoxInPutContent)
		if editBoxInPutContent ~= nil then 
			editBoxInPutContent:removeFromParentAndCleanup(bDesdroy)
		end 
	end 
end 



--@brief 设置编辑框是否可触摸的函数
--@param bTouch  是否可触摸
function WndCommunityPopContent:setInputContentEditBoxIsTouch(bTouch)
	if self.m_root == nil or bTouch == nil then 
		WZLog("WndCommunityPopContent:setInputContentEditBox(bTouch) self.m_root or bTouch is nil ")
		return 
	end 

	local editBoxInPutContent = self.m_root:getChildElement("editBoxInPutContent_WndCommunityPopContent")
	if editBoxInPutContent ~= nil then 
		editBoxInPutContent = WZUIEditBox:luaTo(editBoxInPutContent)
		if editBoxInPutContent ~= nil then 
			--设置触摸
			editBoxInPutContent:setTouchEnable(bTouch)     
		end 
	end 
end 


--@brief	设置编辑框内容的函数
--@param 	sTxtContent  输入内容
--@param 	nRed   红色
--@param 	nGreen 绿色
--@param 	nBlue  蓝色
function WndCommunityPopContent:setEditBoxInputContent(sTxtContent,nRed,nGreen,nBlue)
	if self.m_root == nil or sTxtContent == nil then 
		WZLog("WndCommunityPopContent:setEditBoxInputContent(sTxtContent) ")
		return 
	end 
	local editBoxInPutContent = self.m_root:getChildElement("editBoxInPutContent_WndCommunityPopContent")
	if nRed ~= nil and nGreen ~= nil and nBlue ~= nil then 
		WZLog("&&&&&&&&&&&&&&&&&&&&& nRed,nGreen,nBlue",nRed,nGreen,nBlue)
		WZUIEditBox:luaTo(editBoxInPutContent):setFontColor(GlobalMethod:ccc3(nRed,nGreen,nBlue))
	end 
	if editBoxInPutContent ~= nil then 
		WZUIEditBox:luaTo(editBoxInPutContent):setText(sTxtContent)     
		WZUIEditBox:luaTo(editBoxInPutContent):setTouchEnable(true)
	end 
	
end 


--@brief	设置编辑框内容的函数
--@param 	sTxtContent  输入内容
--@param 	nRed   红色
--@param 	nGreen 绿色
--@param 	nBlue  蓝色
function WndCommunityPopContent:setEditBoxPlaceHolder(sTxtContent)
	if self.m_root == nil or sTxtContent == nil then 
		WZLog("WndCommunityPopContent:setEditBoxInputContent(sTxtContent) ")
		return 
	end 
	if self.m_root == nil or sTxtContent == nil then 
		WZLog("WndCommunityPopContent:setEditBoxInputContent(sTxtContent) ")
	return 
	end 
	local editBoxInPutContent = self.m_root:getChildElement("editBoxInPutContent_WndCommunityPopContent")
	if editBoxInPutContent ~= nil then   
		WZUIEditBox:luaTo(editBoxInPutContent):setPlaceHolder(sTxtContent)
		WZUIEditBox:luaTo(editBoxInPutContent):setTouchEnable(true)
	end 
end 






--@brief	取得编辑框内容的函数
--@return	 sTxtContent  输入内容
function WndCommunityPopContent:getEditBoxInputContent()
	if self.m_root == nil  then 
		WZLog("WndCommunityPopContent:setEditBoxInputContent(sTxtContent) ")
		return 
	end 
	
	local sTxtContent = nil 
	local editBoxInPutContent = self.m_root:getChildElement("editBoxInPutContent_WndCommunityPopContent")
	if editBoxInPutContent ~= nil then 
		editBoxInPutContent = WZUIEditBox:luaTo(editBoxInPutContent)
		if editBoxInPutContent ~= nil then 
			sTextContent = editBoxInPutContent:getText()
			return sTextContent
		end 
	end 
end 


--*****************************修改内部公告，外部公会窗口公有函数END********************************




-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


--*****************************设置战斗情况相关的函数START********************************

--@brief 设置战况里边的内容
function WndCommunityPopContent:_setBattleSituationContent()
	if self.m_root == nil or self.tBattleSituationList == nil then 
		WZLog("WndCommunityPopContent:setBattleSituationContent() self.m_root is nil ")
		return 
	end 
	
	local freeconBattleSituation = self.m_root:getChildElement("freeconBattleSituation_WndCommunityPopContent")
	if freeconBattleSituation ~= nil then 
		freeconBattleSituation = WZUIFreeListContainer:luaTo(freeconBattleSituation)
		freeconBattleSituation:removeAll()
		freeconBattleSituation:setMoveElementPositionUpdatePolicy(0) 
		if freeconBattleSituation ~= nil then 

		end 
	end 
end 

--*****************************设置战斗情况相关的函数END********************************



--@brief静态初始化UI文字
function WndCommunityPopContent:_initUiStaticText()
	if self.m_root == nil then 
		WZLog("WndCommunityPopContent:_initUiStaticText() self.m_root is nil")
		return 
	end 
end 
--@brief 	多语言描边字
function WndCommunityPopContent:_moreLanguageForStroke()
	if self.m_root == nil  then
		return
	end

	--确定
	local txtSure = self.m_root:getChildElement("txtSure_WndCommunityPopContent")
	if txtSure then
		txtSure = WZUILabelTTF:luaTo(txtSure)
		txtSure:setText(LocalStrings.CONFIRM)
		txtSure:setVisible(true)
	end
	--取消
	local txtCancel = self.m_root:getChildElement("txtCancel_WndCommunityPopContent")
	if txtCancel then
		txtCancel = WZUILabelTTF:luaTo(txtCancel)
		txtCancel:setText(LocalStrings.CANCEL)
		txtCancel:setVisible(true)
	end
end

--@brief	编辑框默认提示语
function WndCommunityPopContent:_setPlaceHolderAlignment(alignment)
	alignment = alignment or 0
	local editSignature = self.m_root:getChildElement("editSignature_WndCommunityPopContent")
	if editSignature then
		editSignature = WZUIEditBox:luaTo(editSignature)
		editSignature:setVerticalPlaceHolderAlignment(alignment)
	end
end

--@brief	编辑框默认提示语
--@brief	编辑框默认提示语
function WndCommunityPopContent:_setPlaceHolderAlignment(alignment)
	local editBoxInPutContent = self.m_root:getChildElement("editBoxInPutContent_WndCommunityPopContent")
	if editBoxInPutContent then
		editBoxInPutContent = WZUIEditBox:luaTo(editBoxInPutContent)
		editBoxInPutContent:setVerticalPlaceHolderAlignment(alignment)
		editBoxInPutContent:setVerticalAlignment(alignment)
	end
end
-------------------------------------私有方法模块End----------------------------------------
------------------------------------语言适配模块Begin----------------------------------------

--@brief	葡语适配函数
--@return	无
--@note		备注
function WndCommunityPopContent:_adaptLanguage_ug( )
	GetElement(self.m_root, "txtSure_WndCommunityPopContent", WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root, "txtDeclareLenAtt_WndCommunityPopContent", WZUILabelTTF):setDimensions(GlobalMethod:CCSize(440))
end
