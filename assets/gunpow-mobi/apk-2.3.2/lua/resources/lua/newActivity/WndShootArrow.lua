--WndShootArrow.lua
--@brief	WndShootArrow的UI模块
--@date		2021/06/22
--@author	XTX
--@note		射箭活动主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndShootArrow:onEnter(element)
	self.m_root = element

	g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
	ProtocolProcessorFestivalActivity:regAll6()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Add(ShootArrowEvent.ShootArrowEvent_TeamReward,self.opereteResultByType,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetInfo,self._onGetRewardResult,self)

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndShootArrow:onExit(element)
	g_bIsShowWndDressUp = true
    g_tTempItemForLaterShow = {}
	CacheCenter:unregisterUpatePlayerItemObserver(self)
	ProtocolProcessorFestivalActivity:unregAll()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Remove(ShootArrowEvent.ShootArrowEvent_TeamReward,self.opereteResultByType,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetInfo,self._onGetRewardResult,self)
	if self.m_root then 
		local conShooting = GetElement(self.m_root, "conShooting_WndShootArrow", WZUIContainer)
		conShooting:disableSchedule()

		local imgTeamRedDot = GetElement(self.m_root, "imgTeamRedDot_WndShootArrow", WZUIImage)
		local bHaveRed = GlobalGame.g_tRedPointTypeList[117020] or GlobalGame.g_tRedPointTypeList[127020] or GlobalGame.g_tRedPointTypeList[17020] or imgTeamRedDot:isVisible()
		GlobalGame.g_tRedPointList.redDot_7020 = bHaveRed
		SceneCity:setSceneMainIconRedPoint(ACTIVITY_SHOOT_ARROW, GlobalGame.g_tRedPointList.redDot_7020)
	end
	self:_unInit()
    ChangeChatChannel(g_nLastChannelId_ShootArrow)
	LoadNewActivityRes(false)
end

--@brief    onenter函数已执行
function WndShootArrow:onEnterTransitionDidFinish(element)
    WZLog("WndShootArrow:onEnterTransitionDidFinish")
    ChangeChatChannel(Chat_Channel_ShootArrow)

    GetElement(self.m_root, "txtShootOne_WndShootArrow", WZUILabelTTF):setText(string.format(LocalStrings.SHOOTARROW_TEXT9, 1))
    GetElement(self.m_root, "txtShootTen_WndShootArrow", WZUILabelTTF):setText(string.format(LocalStrings.SHOOTARROW_TEXT9, 10))
    self.m_nMessageIndex = 1
    self:showMessageList()
    self:showRedDot()

 	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7020, g_tGameActivityTypes.ACTIVITY_SHOOT_ARROW)
end

--@brief    关闭窗口
function WndShootArrow:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    --如果是自动弹出的活动界面
   WindowManager:removeWindow(self.m_root , self , true)
end

--@brief    点击规则按钮回调
function WndShootArrow:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 
    WndSingleMapDesc:showInterface1(LocalStrings.SHOOTARROW_TEXT1) 
end

--@brief 	点击发送弹幕按钮回调
function WndShootArrow:onClickSend(element)
	-- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	local edtInputWorld = GetElement(self.m_root, "edtInputWorld_WndShootArrow", WZUIEditBox)

	local content = edtInputWorld:getText()
    if content == nil or content=="" then
	   MsgBoxManager:showTipBox(LocalStrings.CHAT_MSG_CONTENT)
	   return
    end
    if not self:bSend(content) then
	    edtInputWorld:setText("")
	    return
	end


	if self.m_nTimes > 0 then
		MsgBoxManager:showTipBox(LocalStrings.CHAT_SENDMORE)
	else
		local tempTxt = self:getMaxSubString(content)
		WZLog("WndShootArrow:onClickSend = ",tempTxt)
		local tempStr, bHaveMask = CheckYellow(tempTxt)
	    if HaveLimitFace(tempStr) then 
			return 
		end

		tempTxt = WndChat:_addSpaceStr(tempStr)
		self.m_nTimes = self.m_nTimes + 5
		ProtocolProcessorGlobal:send_CHAT_SendMessage(CHANNEL_SHOOTARROW, 0, tempTxt, 0, 0)
		
    	self:putNewMessage(tempTxt)
        edtInputWorld:setText("")
	end
end

--@brief 	关闭表情框
function WndShootArrow:onClickCloseFaceBox(element)
	WZLog("WndShootArrow:onClickCloseFaceBox")
	local conFaceBox = GetElement(self.m_root,"conFaceBox_WndShootArrow",WZUIContainer)
	if not conFaceBox:isVisible() then return end
	conFaceBox:setVisible(false)
end

--弹出表情框
function WndShootArrow:onClickExpression(element)
	WZLog("WndShootArrow:onClickExpression")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local conFaceBox = GetElement(self.m_root,"conFaceBox_WndShootArrow",WZUIContainer)
	conFaceBox:setVisible(true)

	self:_createFaceBox()
end

--点击聊天表情回调
function WndShootArrow:onSelFace(index)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	local fackMask = WndChat.FACEIMASK[index]
	local curEditBox = GetElement(self.m_root, "edtInputWorld_WndShootArrow", WZUIEditBox)
	if curEditBox then
		local curText = curEditBox:getText()
	    if fackMask then
			curText = curText .. fackMask
			if ChineseStringLen(curText) > 24 then
				return
		    end
		    curEditBox:setText(curText)
	    end
	end
end

--编辑框待发送文字
function WndShootArrow:setEditBoxText(s_text)
	local curEditBox = GetElement(self.m_root, "edtInputWorld_WndShootArrow", WZUIEditBox)
	if curEditBox then
	    curEditBox:setText(s_text)
	end
end

--@brief 	点击切换关闭弹幕标签回调
function WndShootArrow:onCheckBarrage(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	self.m_bIsBarrageOpen = not self.m_bIsBarrageOpen

	GetElement(self.m_root, "conBarrage_WndShootArrow", WZUIContainer):setVisible(self.m_bIsBarrageOpen)
end

--@brief 	点击赛事目标按钮回调
function WndShootArrow:onClickTask(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	CellNewYearTask:showInterface(1, self.m_nActivityId)
end

--@brief 	点击赛事礼包按钮回调
function WndShootArrow:onClickGift(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_nGiftRewardNum >= 1 then
		--背包已满提示
	    if CacheCenter:getRemainAmount() <= 0 then
	        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
	        return
	    end
		ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(self.m_nActivityId, 2, 0)
	else
		if self.m_tContent.qfTimes then
			local tData = {}
			tData.txtTitle = LocalStrings.SHOOTARROW_TEXT4
			tData.nType = 2
			WndTips:show(element, self.m_root, 52, tData, GlobalMethod:ccp(50,80), true)
		end
	end
end

--@brief 	点击大奖预览按钮回调
function WndShootArrow:onClickBigReward(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local conRewardTips = GetElement(self.m_root, "conRewardTips_WndShootArrow", WZUIContainer)
	if not conRewardTips:isVisible() then 
		conRewardTips:setVisible(true)
		self:_createBigRewardPreview()
	else
		conRewardTips:setVisible(false)
	end
end

--@brief	点击物品弹出对应的tips
function WndShootArrow:onItemClick(tCell, tag, tData)
    if tData == nil then
       return
    end

    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root, WndShootArrow.m_root, 1, tData, false, nil, true)
end

--@brief 	点击触摸开始回调协议
function WndShootArrow:onTouchBegan(element, pt)
	-- body
	if not self:checkPointInBtn(pt) then 
		local conRewardTips = GetElement(self.m_root, "conRewardTips_WndShootArrow", WZUIContainer)
		if conRewardTips:isVisible() then 
			conRewardTips:setVisible(false)
		end
	end
end

--@brief 	点击组队按钮回调
function WndShootArrow:onCreateTeam(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if nTag == 1 then 
		WndShopRank:showInterface(12, self.m_nActivityId)
	elseif nTag == 2 then 
		WndShopRank:showInterface(10, self.m_nActivityId)
	elseif nTag == 3 then
		WndShopRank:showInterface(11, self.m_nActivityId) 
	end
end

--@brief 	点击射箭1次按钮回调
function WndShootArrow:onClickShoot(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nArrowNum = CacheCenter:getPlayerItemCountById(160110)
	local nTimes = element:getTag()
	if nArrowNum < nTimes then 
		MsgBoxManager:showTipBox(LocalStrings.SHOOTARROW_TEXT12)
		return 
	end
	--背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
	if self.m_bIsShooting then return end 
	self:setShootState(true)
	local tData = {}
	tData.arrowNum = nTimes
	local strJson = json.encode(tData)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 7, strJson)
end

--@brief 	点击领取组队专属奖励按钮回调
function WndShootArrow:onGetTeamReward(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	--背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
	if self.m_tTeamState.zdRewardStatus == 0 then 
		ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(self.m_nActivityId, 1, 0)
	end
end

--@brief 	射击动画播放完成回调
function WndShootArrow:finishShootCallback()
	-- body
	self:showRedDot()
	if self.m_tShootResult and self.m_tShootResult.result == 1 then 
		local tReward = json.decode(self.m_tShootResult.msg)
		local bIsHaveTen = false 
		for i = 1, #tReward.target do
			if tReward.target[i] == 10 then 
				bIsHaveTen = true 
				break 
			end
		end
		if (tReward.bigItemIds and #tReward.bigItemIds > 0) or bIsHaveTen then  
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 8, self.m_tShootResult.msg)
		end
	end
end

--@brief 	空方法
function WndShootArrow:afterCloseRewardShow()
	-- body
	if self.m_tShootResult then 
		local tReward = json.decode(self.m_tShootResult.msg)
		if tReward.bigItemIds and #tReward.bigItemIds > 0 then 
			local data = {}
			for i=1,#tReward.bigItemIds do
				local tab ={}
				tab.id = tReward.bigItemIds[i]
				tab.num = tReward.bigItemNums[i]
				data[i] = tab
			end
			
			WndBlindReward:showInterface(data, 1)
			WndBlindReward:setCallFunc(_G, pushEquipInList)
		end
	end
end

--@brief 	空方法
function WndShootArrow:afterRewardShow()
	-- body
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndShootArrow:_update()
	-- body
	self:_initActivityTime()
    self:showTeamReward()
    self:_updateArrowNum()
end

--@brief 	显示留言滚屏
function WndShootArrow:showMessageList()
	--body
	local conMessage = GetElement(self.m_root, "conBarrage_WndShootArrow", WZUIContainer)
	conMessage:enableSchedule("createMessage", 0.8)
end

--@brief 	创建留言
function WndShootArrow:createMessage(element, delta)
	-- body
	if self.m_nTimes ~= nil and self.m_nTimes > 0  then
		self.m_nTimes = self.m_nTimes - delta
	end

	if self.m_tMessages == nil or #self.m_tMessages == 0 then 
		return 
	end

	local nRadom = math.random(1, 100)
	local nRanPtY = nRadom/100
	local nRanColor = math.fmod(nRadom,4) + 1
	local txtMessage = createFreeTextBox(ToChangeFreeText(self.m_tMessages[self.m_nMessageIndex]), GlobalMethod:ccp(1, nRanPtY), GlobalMethod:ccp(0, 0.5), 500)
	txtMessage:setShowAll(true)
	element:addChild(txtMessage)
	table.remove(self.m_tMessages, 1)

	local moveTo = WZUIActionMoveTo:create()
    moveTo:setMoveX(-0.5)
    moveTo:setMoveY(nRanPtY)
    moveTo:setDuration(12)
    moveTo:setFinishLuaFunction("actionRemoveText")
    txtMessage:runUIAction(moveTo)
end

function WndShootArrow:actionRemoveText(element)
	-- body
	element:removeFromParentAndCleanup(true)
end

function WndShootArrow:_createFaceBox()
	WZLog("WndShootArrow:_createFaceBox")
	local freeFace = GetElement(self.m_root, "freeFace_WndShootArrow", WZUITableContainer)
	freeFace:cleanTable()

	local faceCount = GetTableLen(WndChat.FACEIMASK)
	for i=1, faceCount do
		local celElement,tCell = CellFaceItem:createElement()
		if celElement and tCell then
			celElement:setTag(i-1)
			freeFace:setCellElement(celElement)
			tCell:setFaceMessage(i)
			tCell:setItemClickFun(function(index)
				self:onSelFace(index)
			end)
		end
	end
end


--判断发送的内容是否能进行发送
function WndShootArrow:bSend(sMsgContent)
	WZLog("WndShootArrow:bSend")
	if sMsgContent == nil or sMsgContent == "" then return end
	local freeTextTemp = nil
	local maxWidth = 400
	freeTextTemp = GetElement(self.m_root,"freeTextTemp_WndShootArrow",WZUIFreeTextBox)
	local freeText = ToChangeFreeText(sMsgContent)
	freeTextTemp:setShowText(freeText)
	local freeTextTempSize = freeTextTemp:getContentSize()

	freeTextTemp:setShowText("")
	if freeTextTempSize.width >= maxWidth and freeTextTempSize.height < 30 then
		return false
	end

	if freeTextTempSize.height <= 71 then
		return true
	end
	
	return false
end

--@brief 	创建大奖预览
function WndShootArrow:_createBigRewardPreview()
	-- body
	local tbReward = GetElement(self.m_root, "tbReward_WndShootArrow", WZUITableContainer)
	tbReward:cleanTable()

	for i = 1, #self.m_tContent.bigRewards do
		local element, tNewObj = CellGoodItem:createElement()
		if element and tNewObj then 
			element:setTag(i - 1)
			element:setScale(0.85)
			tNewObj:setCellGoodLocalId(self.m_tContent.bigRewards[i][1], self.m_tContent.bigRewards[i][2], 17)
			tNewObj:setItemClickFun(self, self.onItemClick)
			tbReward:setCellElement(element)
		end
	end
end

--@brief	检查坐标点是否在VIP按钮范围内
--@param	pt:鼠标点击的世界坐标
--@return	在按钮范围内返回true,否则返回false
function WndShootArrow:checkPointInBtn(pt)
	WZLog("WndShootArrow:checkPointInBtn")
	if self.m_root == nil then return end
	local btn = GetElement(self.m_root, "conRewardTips_WndShootArrow", WZUIContainer)
	if btn == nil then return false end
	local btnSize = btn:getContentSize()
	--获得btn的世界坐标
	local ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
	if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
		return true
	else
		return false
	end 
end

--@brief 	刷新赛事礼包的信息
function WndShootArrow:showBagGiftInfo()
	-- body
	if self.m_nGiftRewardNum > 0 then 
		GetElement(self.m_root, "spineGift_WndShootArrow", WZUISpine):setVisible(true)
		GetElement(self.m_root, "imgGiftRed_WndShootArrow", WZUIImage):setVisible(true)
		GetElement(self.m_root, "txtGiftNum_WndShootArrow", WZUILabelTTF):setText(self.m_nGiftRewardNum)
	else
		GetElement(self.m_root, "spineGift_WndShootArrow", WZUISpine):setVisible(false)
		GetElement(self.m_root, "imgGiftRed_WndShootArrow", WZUIImage):setVisible(false)
	end
end

--@brief 	显示组队专属奖励
function WndShootArrow:showTeamReward()
	-- body
	local tbTeamReward = GetElement(self.m_root, "tbTeamReward_WndShootArrow", WZUITableContainer)
	tbTeamReward:cleanTable()

	for i = 1, #self.m_tContent.zdRewards do
		local element, tNewObj = CellGoodItem:createElement()
		if element and tNewObj then 
			element:setTag(i - 1)
			element:setScale(0.85)
			tNewObj:setCellGoodLocalId(self.m_tContent.zdRewards[i][1], self.m_tContent.zdRewards[i][2], 17)
			tNewObj:setItemClickFun(self, self.onItemClick)
			tbTeamReward:setCellElement(element)
		end
	end
end

--@brief 	更新组队状态和组队奖励状态
function WndShootArrow:_updateTeamInfo()
	-- body
	local imgDoneGet = GetElement(self.m_root, "imgDoneGet_WndShootArrow", WZUIImage)
	local btnGetReward = GetElement(self.m_root, "btnGetReward_WndShootArrow", WZUIButton)
	local imgTeamRedDot = GetElement(self.m_root, "imgTeamRedDot_WndShootArrow", WZUIImage)
	btnGetReward:setVisible(true)
	if self.m_tTeamState.zdStatus == 0 or self.m_tTeamState.zdRewardStatus == -1 then 
		btnGetReward:setTouchEnable(false)
		imgDoneGet:setVisible(false)
		imgTeamRedDot:setVisible(false)
	elseif self.m_tTeamState.zdRewardStatus == 0 then 
		btnGetReward:setTouchEnable(true)
		imgDoneGet:setVisible(false)
		imgTeamRedDot:setVisible(true)
	elseif self.m_tTeamState.zdRewardStatus == 1 then 
		btnGetReward:setVisible(false)
		imgDoneGet:setVisible(true)
		imgTeamRedDot:setVisible(false)
	end
	--赛事礼包信息
	self:showBagGiftInfo()
end

--@brief 	更新箭的数量
function WndShootArrow:_updateArrowNum()
	-- body
	local ftxtArrowNum = GetElement(self.m_root, "ftxtArrowNum_WndShootArrow", WZUIFreeTextBox)
	if ftxtArrowNum then 
		local sFormat = [[<I Z="1" P="1">ui/newActivity/common_sj_js.png</I><T C="255,255,255" S="20" P="1" SC="132,66,29" SS="4" SE="1">%d</T>]]
		local nArrowNum = CacheCenter:getPlayerItemCountById(160110)
		ftxtArrowNum:setShowText(string.format(sFormat, nArrowNum))
	end
end

--@brief 	初始化活动时间
function WndShootArrow:_initActivityTime()
	-- body
	GetElement(self.m_root, "edtInputWorld_WndShootArrow", WZUIEditBox):setPlaceHolder(LocalStrings.SHOOTARROW_TEXT13)
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndShootArrow", WZUILabelTTF)
    if txtActivityTime then 
    	txtActivityTime:setText(LocalStrings.ACTIVITY_TIME_KEY .. ":" .. needDay_str)
    end
end

--@brief 	红点
function WndShootArrow:showRedDot()
	-- body
	if self.m_root == nil then return end 

	local imgInviteRedDot = GetElement(self.m_root, "imgInviteRedDot_WndShootArrow", WZUIImage)
	local imgTaskRedDot = GetElement(self.m_root, "imgTaskRedDot_WndShootArrow", WZUIImage)

	if GlobalGame.g_tRedPointTypeList[117020] or GlobalGame.g_tRedPointTypeList[127020] then 
		imgTaskRedDot:setVisible(true)
	else
		imgTaskRedDot:setVisible(false)
	end

	if GlobalGame.g_tRedPointTypeList[17020] then 
		imgInviteRedDot:setVisible(true)
	else
		imgInviteRedDot:setVisible(false)
	end
end

--@brief 	显示射箭动画
function WndShootArrow:showShootingAction()
	-- body
	local conShooting = GetElement(self.m_root, "conShooting_WndShootArrow", WZUIContainer)
	conShooting:setVisible(true)
	local spineBow = GetElement(self.m_root, "spineBow_WndShootArrow", WZUISpine)
	if spineBow then 
		spineBow:play("wait2", false)
		conShooting:enableSchedule("playShootFinishAction", 0.4)
	end
end

--@brief 	显示射箭动画
function WndShootArrow:playShootFinishAction()
	-- body
	local conShooting = GetElement(self.m_root, "conShooting_WndShootArrow", WZUIContainer)
	conShooting:disableSchedule()
	local spineBow = GetElement(self.m_root, "spineBow_WndShootArrow", WZUISpine)
	if spineBow then 
		spineBow:play("wait3", false)
		conShooting:enableSchedule("showShootReward", 0.4)
	end
end

--@brief 	显示射箭奖励
function WndShootArrow:showShootReward()
	-- body
	local conShooting = GetElement(self.m_root, "conShooting_WndShootArrow", WZUIContainer)
	conShooting:disableSchedule()
	local spineBow = GetElement(self.m_root, "spineBow_WndShootArrow", WZUISpine)
	if spineBow then 
		spineBow:play("wait", false)
	end

	self:setShootState(false)
	if self.m_tShootResult and self.m_tShootResult.result == 1 then 
		local tReward = json.decode(self.m_tShootResult.msg)
		if #tReward.target == 1 then 
			MsgBoxManager:showTipBox(string.format(LocalStrings.SHOOTARROW_TEXT29[1], tReward.target[1]), nil, nil, nil, nil, nil, nil, nil, nil, {x=0.5, y=0.78})
		else
			local strCircle = ""
			for i = 1, #tReward.target do
				if i > 1 then 
					strCircle = strCircle .. ", "
				end
				strCircle = strCircle .. tostring(tReward.target[i])
			end
			MsgBoxManager:showTipBox(string.format(LocalStrings.SHOOTARROW_TEXT29[2], strCircle), nil, nil, nil, nil, nil, nil, nil, nil, {x=0.5, y=0.78})
		end
		WndRewardShow:showById(tReward.itemIds, tReward.itemNums)
		if tReward.bigItemIds and #tReward.bigItemIds > 0 then 
			WndRewardShow:closeCallBack(self, self.afterCloseRewardShow)
		else
			WndRewardShow:closeCallBack(self, self.afterCloseRewardShow, _G, pushEquipInList)
		end
		self:finishShootCallback()
	end
	conShooting:setVisible(false)
end
-------------------------------------私有方法模块End----------------------------------------

function WndShootArrow:_adaptLanguage_vn()
    GetElement(self.m_root, "txtShootOne_WndShootArrow", WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root, "txtShootTen_WndShootArrow", WZUILabelTTF):setScale(0.7)
end