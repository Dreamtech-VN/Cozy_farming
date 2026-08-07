--CellCircleOfFriend.lua
--@brief	CellCircleOfFriend的UI模块
--@date		2020/07/02
--@author	XTX
--@note		朋友圈Cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCircleOfFriend:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCircleOfFriend:onExit(element)
	self:_unInit()
end

--@brief 	加载
function CellCircleOfFriend:onLoadData(element)
	-- body
	local celElement = WZUISystem:getInstance():createElement("CellCircleOfFriend")
	self.m_root:addChild(celElement)

	self.m_bIsLoaded = true

	self:_update()
end

--@brief 	点击添加好友按钮回调
function CellCircleOfFriend:onClickAddFriend(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local tData = {self.m_tData.playerId}
	ProtocolProcessorWndFriends:send_FRIEND_AddFriend(TableToIntVector(tData))
end

--@brief 	点击头像回调
function CellCircleOfFriend:onClickHead(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	WndCheckOther:show(self.m_tData.playerId)
end

--@brief 	点击点赞按钮回调
function CellCircleOfFriend:onClickHeart(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local bIsGiveGood = WndFriends:wetherGiveGood(self.m_tData)
	if bIsGiveGood then 
		ProtocolProcessorWndFriends:send_FRIENTD_DelLikeFriendCircle(self.m_tData.id)
	else
		ProtocolProcessorWndFriends:send_FRIENTD_LikeFriendCircle(self.m_tData.id)
	end
end

--@brief 	点击评论按钮回调
function CellCircleOfFriend:onClickComment(element)
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
function CellCircleOfFriend:onClickReport(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	
	WndCircleReport:showInterface(self.m_tData.id)
end

--@brief 	点击返回按钮回调
function CellCircleOfFriend:onClickCommentBack(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	
	self.m_bIsStartComment = not self.m_bIsStartComment
	self:_showCommentState()
end

--@brief 	点击发布评论按钮回调
function CellCircleOfFriend:onClickSubmitComment(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	if judgeWetherForbid() then return end 

	local bIsFriend = CacheCenter:judgeIsContainsById(self.m_tData.playerId)
	if self.m_tData.playerId ~= CacheCenter:getPlayerInfo().id and not bIsFriend and self.m_tData.commentState == 1 then 
		MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT14)
		return 
	end
	
	local editComment = GetElement(self.m_root, "editComment_CellCircleOfFriend", WZUIEditBox)
	local txtText = editComment:getText()

	if txtText == nil or GetWordCount(txtText) == 0 then 
		MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT17)
		return 
	end

    --存在空格就不能发送
    if checkBlankSpace(txtText) then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT147)
        return
    end

	local txtContent, bHaveMask = CheckYellow(txtText)
    if bHaveMask then 
    	MsgBoxManager:showTipBox(LocalStrings.NON_COMPLIANT)
    	return 
    end

	ProtocolProcessorWndFriends:send_FRIENTD_CommentFriendCircle(self.m_tData.id, self.m_tData.playerId, 0, txtContent)
end

--@brief 	点击表情按钮回调
function CellCircleOfFriend:onClickFace(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	
end

--@brief 	点击删除按钮回调
function CellCircleOfFriend:onClickDeleteCircle(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	MsgBoxManager:showConfirmBox(LocalStrings.FRIENDCIRCLE_TEXT22, self, self.sureToDeleteCircle)
end

--@brief 	确认删除回调
function CellCircleOfFriend:sureToDeleteCircle()
	-- body
	ProtocolProcessorWndFriends:send_FRIENTD_DelFriendCircle(self.m_tData.id)
end

--@brief 	自己心情设置是否允许非好友评论
function CellCircleOfFriend:setCommentState(commentState)
	-- body
	self.m_tData.commentState = commentState
	if self.m_bIsLoaded == false then return end 

	local checkBoxForbid = GetElement(self.m_root, "checkBoxForbid_CellCircleFriend", WZUICheckBox)
	if checkBoxForbid:isVisible() then 
		checkBoxForbid:setCheckIndex(self.m_tData.commentState)
	end
end

--@brief    点击非好友不让评论复选框回调
function CellCircleOfFriend:onClickForbid(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

    if self.m_tData.commentState == 1 then 
        self.m_tData.commentState = 0 
    else
        self.m_tData.commentState = 1
    end

    ProtocolProcessorWndFriends:send_FRIENTD_SetFriendCircle(self.m_tData.id)
end

--@brief 	评论成功后，返回正常界面，清掉输入框内容
function CellCircleOfFriend:resetCommentInterface()
	-- body
	if self.m_bIsLoaded == false then return end 

	GetElement(self.m_root, "editComment_CellCircleOfFriend", WZUIEditBox):setText("")
	self.m_bIsStartComment = not self.m_bIsStartComment
	self:_showCommentState()
end

--@brief 	点击置顶和取消置顶回调
function CellCircleOfFriend:onClickTop(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_tData.setTopMark == 0 then 
    	ProtocolProcessorWndFriends:send_FRIEND_MoodTop(self.m_tData.id)
    else
    	ProtocolProcessorWndFriends:send_FRIEND_MoodTop(-1)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function CellCircleOfFriend:_update()
	-- body
	local conTop = GetElement(self.m_root, "conTop_CellCircleOfFriend", WZUIContainer)
	if self.m_tData.picNum <= 0 then 
		conTop:setAbsContentSize(GlobalMethod:CCSize(920, 165))
		conTop:updateRelativeSize()
	end
	self:_showHeadAndName()
	self:_showTimeAndMessage()
	self:showGoodNumAndCommentNum()
	self:_showCommentState()
	self:_showPhoto()
	self:setCommentState(self.m_tData.commentState)
	self:_setEditBoxPlaceHolder()
	self:_showSetTopBtn()
end

--@brief 	显示头像、名字
function CellCircleOfFriend:_showHeadAndName()
	-- body
	local conHead = GetElement(self.m_root, "conHead_CellCircleOfFriend", WZUIContainer)
	local celElement = CellHead:show(conHead, self.m_tData.headId, self.m_tData.faceId, self.m_tData.sex, nil, nil, self.m_tData.vipLevel, self.m_tData.headColor, nil, nil, nil, nil, self.m_tData.headEffectId)

	--名字
	local txtPlayerName = GetElement(self.m_root, "txtPlayerName_CellCircleOfFriend", WZUILabelTTF)
	if txtPlayerName then 
		txtPlayerName:setText(self.m_tData.playerName)
	end
	--关系
	local txtRelative = GetElement(self.m_root, "txtRelative_CellCircleOfFriend", WZUILabelTTF)
	if self.m_tData.playerId ~= CacheCenter:getPlayerInfo().id then 
		local bIsFriend = CacheCenter:judgeIsContainsById(self.m_tData.playerId)
		if bIsFriend then 
			if self.m_nTab == FRIENDCIRCLE_INDEX then 
				txtRelative:setText("")
			else
				txtRelative:setText("(" .. LocalStrings.FRIEND .. ")")
			end
		else
			txtRelative:setText("")
			GetElement(self.m_root, "btnAddFriend_CellCircleOfFriend", WZUIButton):setVisible(true)			
		end
	else
		GetElement(self.m_root, "conReport_CellCircleOfFriend", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "conDelete_CellCircleOfFriend", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "checkBoxForbid_CellCircleFriend", WZUICheckBox):setVisible(true)
	end
	--qq大厅蓝钻年费图标
    SetQQHallBlueIcon(self.m_root, self.m_tData.qqHallData, {"imgQQBlue_CellCircleOfFriend", "imgQQYear_CellCircleOfFriend"}, {"txtPlayerName_CellCircleOfFriend"}, {WZUILabelTTF}, 0.03)
end

--@brief 	显示心情和发布时间
function CellCircleOfFriend:_showTimeAndMessage()
	-- body
	local txtMessage = GetElement(self.m_root, "txtMessage_CellCircleOfFriend", WZUILabelTTF)
	if txtMessage then 
		txtMessage:setText(self.m_tData.message)
	end
	--发布时间
	local txtCreateDate = GetElement(self.m_root, "txtCreateDate_CellCircleOfFriend", WZUILabelTTF)
	local nSeconds = SystemTime:getServerTime() - self.m_tData.createTime
	if nSeconds < 0 then 
		nSeconds = 0 
	end
	if nSeconds <= 3 * 60 then 
		txtCreateDate:setText(LocalStrings.JUST_NOW)
	else
		local sCreateDate = os.date("*t", self.m_tData.createTime)
		local timeFormat = "%02d-%02d %02d:%02d:%02d"
        txtCreateDate:setText(string.format(timeFormat, sCreateDate.month, sCreateDate.day, sCreateDate.hour, sCreateDate.min, sCreateDate.sec))
	end
end

--@brief 	设置点赞和评论次数
function CellCircleOfFriend:showGoodNumAndCommentNum()
	-- body
	if not self.m_bIsLoaded then return end 
	if self.m_root == nil then return end 

	local txtHeartNum = GetElement(self.m_root, "txtHeartNum_CellCircleOfFriend", WZUILabelTTF)
	local txtCommentNum = GetElement(self.m_root, "txtCommentNum_CellCircleOfFriend", WZUILabelTTF)
	
	txtHeartNum:setText(self.m_tData.goodNum)
	txtCommentNum:setText(self.m_tData.commentNum)

	local imgHeart = GetElement(self.m_root, "imgHeart_CellCircleOfFriend", WZUIImage)
	local bIsGiveGood = WndFriends:wetherGiveGood(self.m_tData)
	imgHeart:setGrayRender(not bIsGiveGood)
end

--@brief 	切换评论界面
function CellCircleOfFriend:_showCommentState()
	--body
	if self.m_tCellBeingComment and not self.m_bIsStartComment then 
		self.m_tCellBeingComment[3](self.m_tCellBeingComment[1])
	end
	GetElement(self.m_root, "conNormal_CellCircleOfFriend", WZUIContainer):setVisible(not self.m_bIsStartComment)
	GetElement(self.m_root, "conCommentSel_CellCircleOfFriend", WZUIContainer):setVisible(self.m_bIsStartComment)
end

--@brief 	设置图片
function CellCircleOfFriend:_showPhoto()
	-- body
	local conPhoto = GetElement(self.m_root, "conPhoto_CellCircleOfFriend", WZUIContainer)
	WZLog("CellCircleOfFriend:_showPhoto", self.m_tData.picNum, self.m_tData.picStatus, Serialize(self.m_tData.photoUrl))
	if self.m_tData.picNum == 0 then 
		conPhoto:setAbsContentSize(GlobalMethod:CCSize(730,2))
		conPhoto:updateRelativeSize()
	else
		for i = 1, self.m_tData.picNum do
			local conPhoto = GetElement(self.m_root, "conPhoto" .. i .. "_CellCircleOfFriend", WZUIContainer)
			conPhoto:setVisible(true)
			conPhoto:removeAllChildrenWithCleanup(true)

			local celElement,tCell = CellSpacePhoto:createElement()
			tCell.m_nIndex = i
			celElement:setTag(i-1)    --从0开始设置Tag值
			celElement:setScale(1)
			tCell:setPlayerId(self.m_tData.playerId)
			tCell:setType(self.m_nPhotoType)
			conPhoto:addChild(celElement)
			tCell:update(self.m_tData, i)
		end
	end
end

--@brief 	设置输入框提示语
function CellCircleOfFriend:_setEditBoxPlaceHolder()
	-- body
	--设置输入框提示语
	local editComment = GetElement(self.m_root, "editComment_CellCircleOfFriend", WZUIEditBox)
	if editComment then 
		editComment:setPlaceHolder(LocalStrings.FRIENDCIRCLE_TEXT32)
	end
end

--@brief 	显示置顶按钮
function CellCircleOfFriend:_showSetTopBtn()
	WZLog("CellCircleOfFriend:_showSetTopBtn", WndFriends:getCheckIndex())
	if (WndFriends.m_root and WndFriends:getCheckIndex() == MYCIRCLE_INDEX) or (WndCircleOfFriend.m_root and WndCircleOfFriend.m_nPlayerId == CacheCenter:getPlayerInfo().id) then 
		GetElement(self.m_root, "btnTopSet_CellCircleOfFriend", WZUIButton):setVisible(true)
		if self.m_tData.setTopMark == 0 then 
			GetElement(self.m_root, "imgSetTop_CellCircleOfFriend", WZUIImage):setFile("ui/common/common_lt_zd.png")
		else
			GetElement(self.m_root, "imgSetTop_CellCircleOfFriend", WZUIImage):setFile("ui/chat/common_lt_gb.png")
		end
	end
end
-------------------------------------私有方法模块End----------------------------------------
