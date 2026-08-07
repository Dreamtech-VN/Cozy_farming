--CellCircleComment.lua
--@brief	CellCircleComment的UI模块
--@date		2020/07/10
--@author	XTX
--@note		个人对朋友圈的评论


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCircleComment:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCircleComment:onExit(element)
	self:_unInit()
end

--@brief 	点击删除按钮回调
function CellCircleComment:onClickDelete(element)
	--body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	MsgBoxManager:showConfirmBox(LocalStrings.FRIENDCIRCLE_TEXT31, self, self.sureToDelComment)
end

--@brief 	确定删除该条评论
function CellCircleComment:sureToDelComment()
	-- body
	ProtocolProcessorWndFriends:send_FRIENTD_DelComment(self.m_tData.id, self.m_tCommentData.commentId)
end

--@brief 	点击查看点赞玩家按钮回调
function CellCircleComment:onClickGoodPlayer(element)
	--body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	
	WndGiveGoodPlayer:showInterface(self.m_tData.id)
end

--@brief 	点击更多按钮回调
function CellCircleComment:onClickMore(element)
	--body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	
	GetElement(self.m_root, "conExtended_CellCircleComment", WZUIContainer):setVisible(true)
	GetElement(self.m_root, "btnMore_CellCircleComment", WZUIButton):setVisible(false)
	if self.m_tExtendCallBack then 
		self.m_tExtendCallBack[2](self.m_tExtendCallBack[1], self.m_tData)
	end
end

--@brief 	加载
function CellCircleComment:onLoadData(element)
	-- body
	local celElement = WZUISystem:getInstance():createElement("CellCircleComment")
	self.m_root:addChild(celElement)

	self.m_bIsLoaded = true
	self:_update()
end

--@brief 	点击评论按钮回调
function CellCircleComment:onClickComment(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	
	local bIsFriend = CacheCenter:judgeIsContainsById(self.m_tData.playerId)
	if self.m_tData.playerId ~= CacheCenter:getPlayerInfo().id and not bIsFriend and self.m_tData.commentState == 1 then 
		MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT14)
		return 
	end

	self.m_bIsStartComment = not self.m_bIsStartComment
	self:_showCommentState()
	if self.m_tCellBeingComment then 
		self.m_tCellBeingComment[2](self.m_tCellBeingComment[1], self)
	end
end

--@brief 	点击举报按钮回调
function CellCircleComment:onClickReport(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	
	WndCircleReport:showInterface(self.m_tData.id)
end

--@brief 	点击返回按钮回调
function CellCircleComment:onClickCommentBack(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	
	self.m_bIsStartComment = not self.m_bIsStartComment
	self:_showCommentState()
end

--@brief 	点击发布评论按钮回调
function CellCircleComment:onClickSubmitComment(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	if judgeWetherForbid() then return end 

	local bIsFriend = CacheCenter:judgeIsContainsById(self.m_tData.playerId)
	if self.m_tData.playerId ~= CacheCenter:getPlayerInfo().id and not bIsFriend and self.m_tData.commentState == 1 then 
		MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT14)
		return 
	end
	
	local editComment = GetElement(self.m_root, "editComment_CellCircleComment", WZUIEditBox)
	local txtText = editComment:getText()

	if txtText == nil or GetWordCount(txtText) == 0 then 
		MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT17)
		return 
	end

	local tempStr, bHaveMask = CheckYellow(txtText)
    if bHaveMask then 
    	MsgBoxManager:showTipBox(LocalStrings.NON_COMPLIANT)
    	return 
    end

	ProtocolProcessorWndFriends:send_FRIENTD_CommentFriendCircle(self.m_tData.id, self.m_tData.playerId, self.m_tCommentData.commentId, tempStr)
end

--@brief 	点击表情按钮回调
function CellCircleComment:onClickFace(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	
end

--@brief 	评论成功后，返回正常界面，清掉输入框内容
function CellCircleComment:resetCommentInterface()
	-- body
	if self.m_bIsLoaded == false then return end 

	GetElement(self.m_root, "editComment_CellCircleComment", WZUIEditBox):setText("")
	self.m_bIsStartComment = not self.m_bIsStartComment
	self:_showCommentState()
end

--@brief 	点击上一页按钮回调
function CellCircleComment:onClickPageUp(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	if self.m_nCurPage == 1 then 
		MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT36)
		return
	end

	local nLastPage = self.m_nCurPage
	self.m_nCurPage = self.m_nCurPage - 1
	self:_showCommentPage()
	if self.m_tExtendCallBack then 
		self.m_tExtendCallBack[4](self.m_tExtendCallBack[1], self.m_tData, self.m_nCurPage, nLastPage, self.m_nTotalPage)
	end
end

--@brief 	点击下一页按钮回调
function CellCircleComment:onClickPageDown(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	if self.m_nCurPage == self.m_nTotalPage then 
		MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT35)
		return
	end

	local nLastPage = self.m_nCurPage
	self.m_nCurPage = self.m_nCurPage + 1
	self:_showCommentPage()
	if self.m_tExtendCallBack then 
		self.m_tExtendCallBack[4](self.m_tExtendCallBack[1], self.m_tData, self.m_nCurPage, nLastPage, self.m_nTotalPage)
	end
end

--@brief 	点击收缩按钮回调
function CellCircleComment:onClickLess(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	GetElement(self.m_root, "conExtended_CellCircleComment", WZUIContainer):setVisible(false)
	GetElement(self.m_root, "btnMore_CellCircleComment", WZUIButton):setVisible(true)
	if self.m_tExtendCallBack then 
		self.m_tExtendCallBack[3](self.m_tExtendCallBack[1], self.m_tData, self.m_nCurPage, self.m_nTotalPage)
	end

	self.m_nCurPage = 1
	self:_showCommentPage()
end

--@brief 	点击首页按钮回调
function CellCircleComment:onClickFirstPage(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	
	if self.m_nCurPage == 1 then 
		MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT36)
		return 
	end

	local nLastPage = self.m_nCurPage
	self.m_nCurPage = 1
	self:_showCommentPage()
	if self.m_tExtendCallBack then 
		self.m_tExtendCallBack[4](self.m_tExtendCallBack[1], self.m_tData, self.m_nCurPage, nLastPage, self.m_nTotalPage)
	end
end

--@brief 	点击末页按钮回调
function CellCircleComment:onClickLastPage(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	if self.m_nCurPage == self.m_nTotalPage then 
		MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT35)
		return 
	end

	local nLastPage = self.m_nCurPage
	self.m_nCurPage = self.m_nTotalPage
	self:_showCommentPage()
	if self.m_tExtendCallBack then 
		self.m_tExtendCallBack[4](self.m_tExtendCallBack[1], self.m_tData, self.m_nCurPage, nLastPage, self.m_nTotalPage)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function CellCircleComment:_update()
	-- body
	if self.m_nType == 1 then 
		local giveGoodNameNum = tonumber(CacheCenter:getGameParam().giveShow) or 3
		GetElement(self.m_root, "btnGiveGoodPlayer_CellCircleComment", WZUIButton):setVisible(true)
		GetElement(self.m_root, "imgHeartIcon_CellCircleComment", WZUIImage):setVisible(true)
		GetElement(self.m_root, "btnReComment_CellCircleComment", WZUIButton):setVisible(false)
		local ftxtMessage = GetElement(self.m_root, "ftxtMessage_CellCircleComment", WZUIFreeTextBox)
		local nIndex = 0
		local sFormat = [[<T C="225,109,22" S="20" P="1" SC="128,54,13" SS="4" SE="0">%s</T>]]
		local sPlayerName = ""
		for i = 1, #self.m_tData.goodNameList do
			sPlayerName = sPlayerName .. self.m_tData.goodNameList[i]
			nIndex = nIndex + 1
			if nIndex >= giveGoodNameNum or nIndex >= self.m_tData.goodNum then 
				break 
			end
			sPlayerName = sPlayerName .. ","
		end
		ftxtMessage:setShowText(string.format(sFormat, sPlayerName))
	elseif self.m_nType == 2 then 
		if self.m_tCommentData.commentPlayerId == CacheCenter:getPlayerInfo().id then 
			GetElement(self.m_root, "btnDelete_CellCircleComment", WZUIButton):setVisible(true)
			GetElement(self.m_root, "btnReComment_CellCircleComment", WZUIButton):setVisible(false)
		else
			if self.m_tData.playerId == CacheCenter:getPlayerInfo().id then 
				GetElement(self.m_root, "btnDelete_CellCircleComment", WZUIButton):setVisible(true)
			end
			GetElement(self.m_root, "btnReComment_CellCircleComment", WZUIButton):setVisible(true)
		end
		--设置输入框提示语
		local editComment = GetElement(self.m_root, "editComment_CellCircleComment", WZUIEditBox)
		if editComment then 
			editComment:setPlaceHolder(LocalStrings.FRIENDCIRCLE_TEXT26 .. " " .. self.m_tCommentData.commentPlayerName)
		end
		local ftxtMessage = GetElement(self.m_root, "ftxtMessage_CellCircleComment", WZUIFreeTextBox)
		local sFormat = [[<T C="225,109,22" S="20" P="1" SC="128,54,13" SS="4" SE="0">%s:</T>]]
		local sFormatTwo = [[<T C="225,109,22" S="20" P="1" SC="128,54,13" SS="4" SE="0">%s</T><T C="127,70,26" S="20" P="1" SC="128,54,13" SS="4" SE="0"> %s </T><T C="225,109,22" S="20" P="1" SC="128,54,13" SS="4" SE="0">%s:</T>]]
		local sFormatThree = [[<T C="127,70,26" S="20" P="1" SC="128,54,13" SS="4" SE="0">%s</T>]]
		local sContent = ""
		if self.m_tCommentData.beCommentedPlayerId <= 0 then 
			sContent = string.format(sFormat, self.m_tCommentData.commentPlayerName)
		else
			sContent = string.format(sFormatTwo, self.m_tCommentData.commentPlayerName, LocalStrings.FRIENDCIRCLE_TEXT26, self.m_tCommentData.beCommentedPlayerName)
		end
		local message = string.format(sFormatThree, self.m_tCommentData.commentMsg)
		sContent = sContent .. message
		ftxtMessage:setShowText(sContent)
	elseif self.m_nType == 3 then 
		local conBg = GetElement(self.m_root, "conBg_CellCircleComment", WZUIContainer)
		local conNormal = GetElement(self.m_root, "conNormal_CellCircleComment", WZUIContainer)
		local btnMore = GetElement(self.m_root, "btnMore_CellCircleComment", WZUIButton)
		if conBg then 
			conBg:setAbsContentSize(GlobalMethod:CCSize(730, 30))
			conNormal:setAbsContentSize(GlobalMethod:CCSize(730, 30))
			btnMore:setAbsContentSize(GlobalMethod:CCSize(45, 30))
			conBg:updateRelativeSize()
			conNormal:updateRelativeSize()
			btnMore:updateRelativeSize()
		end

		--页数
		self:_showCommentPage()

		GetElement(self.m_root, "btnMore_CellCircleComment", WZUIButton):setVisible(true)
		GetElement(self.m_root, "btnReComment_CellCircleComment", WZUIButton):setVisible(false)
	end
end

--@brief 	切换评论界面
function CellCircleComment:_showCommentState()
	--body
	if self.m_tCellBeingComment and not self.m_bIsStartComment then 
		self.m_tCellBeingComment[3](self.m_tCellBeingComment[1])
	end
	GetElement(self.m_root, "conNormal_CellCircleComment", WZUIContainer):setVisible(not self.m_bIsStartComment)
	GetElement(self.m_root, "conCommentSel_CellCircleComment", WZUIContainer):setVisible(self.m_bIsStartComment)
end

--@brief 	显示评论页数
function CellCircleComment:_showCommentPage()
	-- body
	local txtCurPage = GetElement(self.m_root, "txtCurPage_CellCircleComment", WZUILabelTTF)
	if txtCurPage then 
		txtCurPage:setText(self.m_nCurPage .. "-" .. self.m_nTotalPage)
	end
end
-------------------------------------私有方法模块End----------------------------------------
