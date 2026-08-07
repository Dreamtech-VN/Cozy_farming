--WndYearPlayer.lua
--@brief	WndYearPlayer的UI模块
--@date		2022/04/21
--@author	XTX
--@note		年度玩家活动主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndYearPlayer:onEnter(element)
	self.m_root = element
	g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
	ProtocolProcessorFestivalActivity:regAll6()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
	GlobalGame:getGameEventDispathcer():Add(Independent_Activity.ActivityReddot, self.showRedDot, self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetTaskList,self._onGetTaskInfo,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetResult,self._onGetTaskResult,self)

	self:_adaptIphoneX()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndYearPlayer:onExit(element)
	g_bIsShowWndDressUp = true
    g_tTempItemForLaterShow = {}
	CacheCenter:unregisterUpatePlayerItemObserver(self)
	ProtocolProcessorFestivalActivity:unregAll6()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
	GlobalGame:getGameEventDispathcer():Remove(Independent_Activity.ActivityReddot, self.showRedDot, self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetTaskList,self._onGetTaskInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetResult,self._onGetTaskResult,self)

	if self.m_root then 
		self.m_root:disableSchedule()
		GetElement(self.m_root, "conSignUp_WndYearPlayer", WZUIContainer):disableSchedule()
	end

	self:_unInit()
	LoadNewActivityRes(false)
end

--@brief    onenter函数已执行
function WndYearPlayer:onEnterTransitionDidFinish(element)
	self:_initStaticText()
	self.m_root:enableSchedule("caculateTime", 1)
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7050, 7050)
end

--@brief    关闭窗口
function WndYearPlayer:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    --如果是自动弹出的活动界面
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮回调
function WndYearPlayer:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 
    WndSingleMapDesc:showInterface1(LocalStrings.YEARPLAYER_TEXT2) 
end

--@brief 	点击目标按钮回调
function WndYearPlayer:onClickTask(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if nTag == 1 then 
		self:_showTabContent(nTag)
	elseif nTag == 2 then
		self:_showTabContent(nTag)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 1, "")
	elseif nTag == 3 then
		self:_showTabContent(nTag)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, self.m_nCellCurIndex)
	elseif nTag == 4 then 
		WndShopRank:showInterface(25, self.m_nActivityId) 
	end
end

--@brief 	点击开启按钮回调
function WndYearPlayer:onClickFive(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if nTag == 1 then 
		self:onClickApply(element)
	elseif nTag == 2 then 
		self:onFashionRecommend(element)
	elseif nTag == 3 then 
		local nCostNum = self.m_tRefreshCost[2] + self.m_nRefreshCount * self.m_tRefreshCost[3]
		if not JudgeMoneyIsEnough(self.m_tRefreshCost[1], nCostNum, nil, nil, nil, nil, nil, nil, nil, self, self.sureToRefresh) then 
			return 
		end

		self:sureToRefresh()
	end
end

--@brief 	確定刷新
function WndYearPlayer:sureToRefresh()
	--body
	self.m_bNeedCleanTable = true 
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, "")
end

--@brief 	点击报名按钮回调
function WndYearPlayer:onClickApply(element)
	-- body
	--判断有没有报名
	if self.m_tMyFashionData.applyState > 1 then 
		MsgBoxManager:showTipBox(LocalStrings.CHARM_LIFT10)
		return
	end

	GetElement(self.m_root, "conSingUpAsk_WndYearPlayer", WZUIContainer):setVisible(true)
	self:_updateInputWordsNum(true)
end

--@brief 	确定报名
function WndYearPlayer:sureToApply()
	--body
	local tData = {}
	local txtInPut = self:getEditBoxInputContent()
	tData.declaration = txtInPut

	local strTemp = json.encode(tData)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 4, strTemp)
end

--@brief 	点击报名界面推荐按钮回调
function WndYearPlayer:onFashionRecommend(element)
	--判断是否已报名
	if self.m_tMyFashionData.applyState == 0 then 
		MsgBoxManager:showTipBox(LocalStrings.CHARM_LIFT22)
		return 
	end
	--判断有没有推荐
	if self.m_tMyFashionData.recommendTime > 0 then 
		MsgBoxManager:showTipBox(LocalStrings.CHARM_LIFT13)
		return
	end

	GetElement(self.m_root, "conRecommendAsk_WndYearPlayer", WZUIContainer):setVisible(true)
	local strFormat = string.gsub(LocalStrings.CHARM_LIFT20, "127,70,26", "255,255,255")
	local sContent = string.format(strFormat, self.m_fashionRecommendCost[2], GDatatab_item["id_" .. self.m_fashionRecommendCost[1]].icon, self.m_nFashionRecommendConfigTime)
	local ftxtRecommendCostAtt = GetElement(self.m_root, "ftxtRecommendCostAtt_WndYearPlayer", WZUIFreeTextBox)
	ftxtRecommendCostAtt:setShowText(sContent)
end

--@brief 	确定推荐
function WndYearPlayer:sureToRecommend()
	--body
	if not JudgeMoneyIsEnough(self.m_fashionRecommendCost[1], self.m_fashionRecommendCost[2], nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureUseDiamondToRecommend) then
		return 
	end
	self:sureUseDiamondToRecommend()
end

function WndYearPlayer:sureUseDiamondToRecommend()
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 5, "")
end

--@brief 	报名确认界面点击确认按钮回调
function WndYearPlayer:onClickSure(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nTag = element:getTag()
	if nTag == 1 then 
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
	    local nInputTextLen, spaceCnt = WndBag:_checkInputTxtLen(txtInPut)
	    local nWordLimit = self.m_nMaxWordsCount * 2
	    if nInputTextLen > nWordLimit then
	    	MsgBoxManager:showTipBox(LocalStrings.YEARPLAYER_TEXT1[16])
	    	return
	    end

	    if not JudgeMoneyIsEnough(self.m_signUpCost[1], self.m_signUpCost[2], nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureToApply) then 
	    	return 
	    end

	    self:sureToApply()
	elseif nTag == 2 then --确认推荐
		self:sureToRecommend()
	end
end

--@brief 	点击报名确认界面返回按钮回调
function  WndYearPlayer:onClickBack(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nTag = element:getTag()
	if nTag == 1 then 
		GetElement(self.m_root, "conSingUpAsk_WndYearPlayer", WZUIContainer):setVisible(false)
		local editCircle = GetElement(self.m_root, "editBoxInPutContent_WndYearPlayer", WZUIEditBox)
		editCircle:setText("")
	elseif nTag == 2 then 
		GetElement(self.m_root, "conPickAsk_WndYearPlayer", WZUIContainer):setVisible(false)
		self.m_tPickData = nil
		self.m_tPickCell = nil
	elseif nTag == 3 then 
		GetElement(self.m_root, "conRecommendAsk_WndYearPlayer", WZUIContainer):setVisible(false)
	end
end

--@brief 	点击pick按钮回调
function WndYearPlayer:clickPickCallBack(tCell, tData)
	-- body
	local limitCount = self:_getPickLimit()
	if limitCount ~= -1 and self.m_nPlayerDayPicCount >= limitCount then 
		MsgBoxManager:showConfirmBox(LocalStrings.YEARPLAYER_TEXT1[20], self, self.sureToRecharge)
		return 
	end
	local moneyList = CacheCenter:getMoneyList()
	local moneyNum = 0
	if self.m_tPickCostConfig[self.m_nCoinIndex][1] == 70 then 
		moneyNum = moneyList.ticket
	elseif self.m_tPickCostConfig[self.m_nCoinIndex][1] == 1 then 
		moneyNum = moneyList.blueDiamond
	end
	local nTempNum = math.floor(moneyNum/self.m_ncostCount)
	local limitCount = self:_getPickLimit()
	local nLeftCount = limitCount - self.m_nPlayerDayPicCount
	WZLog("WndYearPlayer:onClickCoin", nLeftCount, nTempNum)
	if nLeftCount > 0 and nTempNum > nLeftCount then 
		nTempNum = nLeftCount
	end
	self.m_nitemCount = nTempNum > 0 and nTempNum or 1
	
	self.m_tPickCell = tCell 
	self.m_tPickData = tData
	self.m_nNum = 1

	GetElement(self.m_root, "conPickAsk_WndYearPlayer", WZUIContainer):setVisible(true)
	GetElement(self.m_root,"useNum_WndYearPlayer",WZUILabelTTF):setText(self.m_nNum)
	self:updateCostCount()
end

--@brief 	投票界面点击pick
function WndYearPlayer:onClickSurePick()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local useNum = GetElement(self.m_root,"useNum_WndYearPlayer",WZUILabelTTF)
	local num = tonumber(useNum:getText())
	local costCount = num * self.m_ncostCount
	local basicData = GDatatab_item["id_" .. self.m_tCoinId[self.m_nCoinIndex]]
	local strAtt = string.format(LocalStrings.YEARPLAYER_TEXT1[18], costCount, basicData.icon, num)
	GetElement(self.m_root, "img9Bg_WndYearPlayer", WZUI9Image):setVisible(false)
	MsgBoxManager:showConfirmBox(strAtt, self, self.sureToPick, MSGBOXLEVEL_HIGH, nil, nil, nil, nil, self.cancelToPick) 
end

--@brief 	pick二次确认提醒界面
function WndYearPlayer:sureToPick(nId, nResType)
	GetElement(self.m_root, "img9Bg_WndYearPlayer", WZUI9Image):setVisible(true)
	if nResType == MSGBOXRESTYPE_CONFIRM then
		local useNum = GetElement(self.m_root,"useNum_WndYearPlayer",WZUILabelTTF)
		local num = tonumber(useNum:getText())
		local costCount = num * self.m_ncostCount
		if not JudgeMoneyIsEnough(self.m_tCoinId[self.m_nCoinIndex], costCount, nil, nil, nil, nil, nil, nil, nil, self, self.sureUseDiamondPick) then 
			return 
		end
		self:sureUseDiamondPick()
	end
end

--@brief 	前往充值
function WndYearPlayer:sureToRecharge(nId, nResType)
	if nResType == MSGBOXRESTYPE_CONFIRM then
		PassportSdkManager:gotoPaymentPage()
	end
end

--@brief 	二次确认提醒界面取消投票
function WndYearPlayer:cancelToPick()
	GetElement(self.m_root, "img9Bg_WndYearPlayer", WZUI9Image):setVisible(true)
end

--@brief 	点击切换货币回调
function WndYearPlayer:onClickCoin(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local nTag = element:getTag()
	self.m_nCoinIndex = nTag
	self.m_ncostCount = self.m_tPickCostConfig[self.m_nCoinIndex][2]
	local moneyList = CacheCenter:getMoneyList()
	local moneyNum = 0
	if self.m_tPickCostConfig[self.m_nCoinIndex][1] == 70 then 
		moneyNum = moneyList.ticket
	elseif self.m_tPickCostConfig[self.m_nCoinIndex][1] == 1 then 
		moneyNum = moneyList.blueDiamond
	end
	local nTempNum = math.floor(moneyNum/self.m_ncostCount)
	local limitCount = self:_getPickLimit()
	local nLeftCount = limitCount - self.m_nPlayerDayPicCount
	WZLog("WndYearPlayer:onClickCoin", nLeftCount, nTempNum)
	if nLeftCount > 0 and nTempNum > nLeftCount then 
		nTempNum = nLeftCount
	end
	self.m_nitemCount = nTempNum > 0 and nTempNum or 1
	self:updateCostCount()
end

--@brief 	确定投票
function WndYearPlayer:sureUseDiamondPick()
	local tData = {}
	local useNum = GetElement(self.m_root,"useNum_WndYearPlayer",WZUILabelTTF)
	local num = tonumber(useNum:getText())

	tData.playerId = self.m_tPickData.id
	tData.pickType = self.m_nCoinIndex - 1
	tData.times = num

	local strTemp = json.encode(tData)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 3, strTemp)
end

function WndYearPlayer:onBtnClickTab(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local index = tonumber(element:getTag())

	if index == self.m_nCellCurIndex then return end

	self.m_nCellCurIndex = index
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, self.m_nCellCurIndex)
end

--@brief 	点击查找按钮回调
function WndYearPlayer:onPlayerFind(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local editFind = GetElement(self.m_root, "editFind_WndYearPlayer", WZUIEditBox)
    local sTempContent = editFind:getText()
    if sTempContent == nil or sTempContent == "" or sTempContent == " " then
        MsgBoxManager:showTipBox(LocalStrings.MASTERINFO16)
        return 
    end
    if tonumber(sTempContent) == nil then
        MsgBoxManager:showTipBox(self.ID_MUST_BE_NUMBER)
        return
    end
    --查找是否有好友信息
    self.m_bIsFindFriend = true
    
    local tData = {}
    tData.playerId = tonumber(sTempContent)
    local strTemp = json.encode(tData)
    self.m_bNeedCleanTable = true 
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 6, strTemp)
end

--@brief 	点击取消查找按钮回调
function WndYearPlayer:onCancelFind(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	--清楚查找框的内容
    GetElement(self.m_root, "editFind_WndYearPlayer", WZUIEditBox):setText("")
    GetElement(self.m_root, "btnCancelFind_WndYearPlayer", WZUIButton):setVisible(false)
    --刷新列表
    if self.m_bIsFindFriend then
    	if self.m_bIsFindPlayer then 
    		self.m_bNeedCleanTable = true
		end
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 1, "")
    end
    self.m_bIsFindPlayer = false
end

--@brief    输入完成回调
function WndYearPlayer:onFinishInput(element)
    -- body
    element = WZUIEditBox:luaTo(element)
    local txt = element:getText()
    if txt ~= nil and txt ~= "" then
        GetElement(self.m_root, "btnCancelFind_WndYearPlayer", WZUIButton):setVisible(true)
    else
        GetElement(self.m_root, "btnCancelFind_WndYearPlayer", WZUIButton):setVisible(false)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndYearPlayer:_update()
	-- body
	self:_setFreeBtnText()
	self:showRedDot()
	self:_initActivityTime()
end

--@brief 	初始化静态文本
function WndYearPlayer:_initStaticText()
	GetElement(self.m_root, "txtBtnTask1_WndYearPlayer", WZUILabelTTF):setText(LocalStrings.YEARPLAYER_TEXT1[2])
	GetElement(self.m_root, "txtBtnTask1Sel_WndYearPlayer", WZUILabelTTF):setText(LocalStrings.YEARPLAYER_TEXT1[2])
	GetElement(self.m_root, "txtBtnTask3_WndYearPlayer", WZUILabelTTF):setText(LocalStrings.YEARPLAYER_TEXT1[3])
	GetElement(self.m_root, "txtBtnTask2_WndYearPlayer", WZUILabelTTF):setText(LocalStrings.YEARPLAYER_TEXT1[7])
	GetElement(self.m_root, "txtBtnTask2Sel_WndYearPlayer", WZUILabelTTF):setText(LocalStrings.YEARPLAYER_TEXT1[7])
	GetElement(self.m_root, "txtBtnTask4_WndYearPlayer", WZUILabelTTF):setText(LocalStrings.COMMUNITY_COMPETE_TEXT7)
	GetElement(self.m_root, "txtBtnTask4Sel_WndYearPlayer", WZUILabelTTF):setText(LocalStrings.COMMUNITY_COMPETE_TEXT7)
	GetElement(self.m_root, "txtBtnOpenOne_WndYearPlayer", WZUILabelTTF):setText(LocalStrings.COMMUNITY_COMPETE_TEXT7)
	GetElement(self.m_root, "txtBtnOpenFive_WndYearPlayer", WZUILabelTTF):setText(LocalStrings.SHOP_RECOMMEND)
	GetElement(self.m_root, "txtSignAtt_WndYearPlayer", WZUILabelTTF):setText(LocalStrings.YEARPLAYER_TEXT1[12])
	GetElement(self.m_root, "txtPick_WndYearPlayer", WZUILabelTTF):setText(LocalStrings.YEARPLAYER_TEXT1[5])
	GetElement(self.m_root, "txtPickAtt_WndYearPlayer", WZUILabelTTF):setText(LocalStrings.YEARPLAYER_TEXT1[11])
	GetElement(self.m_root, "txtBtnFresh_WndYearPlayer", WZUILabelTTF):setText(LocalStrings.REFRESH)
	GetElement(self.m_root, "title_1_WndYearPlayer", WZUILabelTTF):setText(LocalStrings.YEARPLAYER_TEXT1[9])
	GetElement(self.m_root, "title_2_WndYearPlayer", WZUILabelTTF):setText(LocalStrings.YEARPLAYER_TEXT1[10])
	GetElement(self.m_root, "title_1_Sel_WndYearPlayer", WZUILabelTTF):setText(LocalStrings.YEARPLAYER_TEXT1[9])
	GetElement(self.m_root, "title_2_Sel_WndYearPlayer", WZUILabelTTF):setText(LocalStrings.YEARPLAYER_TEXT1[10])
	
	local editBoxInPutContent = GetElement(self.m_root, "editBoxInPutContent_WndYearPlayer", WZUIEditBox)
	editBoxInPutContent:setPlaceHolder(LocalStrings.YEARPLAYER_TEXT1[13])
	GetElement(self.m_root, "editFind_WndYearPlayer", WZUIEditBox):setPlaceHolder(LocalStrings.TOUCH_TO_INPUT)
end

--@brief 	红点
function WndYearPlayer:showRedDot()
	-- body
	if self.m_root == nil then return end 

	local imgTaskRedDot = GetElement(self.m_root, "imgTaskRedDot_WndYearPlayer", WZUIImage)
	local imageDayRedPoint = GetElement(self.m_root, "imageDayRedPoint_WndYearPlayer", WZUIImage)
	local imageGrowupRedPoint = GetElement(self.m_root, "imageGrowupRedPoint_WndYearPlayer", WZUIImage)

	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[117050] or GlobalGame.g_tRedPointTypeList[127050]) then 
		imgTaskRedDot:setVisible(true)
	else
		imgTaskRedDot:setVisible(false)
	end

	if GlobalGame.g_tRedPointTypeList and GlobalGame.g_tRedPointTypeList[117050] then 
		imageGrowupRedPoint:setVisible(true)
	else
		imageGrowupRedPoint:setVisible(false)
	end
	if GlobalGame.g_tRedPointTypeList and GlobalGame.g_tRedPointTypeList[127050] then 
		imageDayRedPoint:setVisible(true)
	else
		imageDayRedPoint:setVisible(false)
	end

end


--@brief 	初始化活动时间
function WndYearPlayer:_initActivityTime()
	-- body
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndYearPlayer", WZUILabelTTF)
    if txtActivityTime then 
    	txtActivityTime:setText(LocalStrings.ACTIVITY_TIME_KEY .. ":" .. needDay_str)
    end
end

--@brief 	设置免费丢
function WndYearPlayer:_setFreeBtnText()
	local ftxtFreshCost = GetElement(self.m_root, "ftxtFreshCost_WndYearPlayer", WZUIFreeTextBox)
	local strFormat = [[<I Z="0.5" P="1">%s</I><T C="255,250,236" S="24" P="1" SC="0,108,3" SE="1" SS="4">%d</T>]]
	local basicData = GDatatab_item["id_" .. self.m_tRefreshCost[1]]
	local nCostNum = self.m_tRefreshCost[2] + self.m_nRefreshCount * self.m_tRefreshCost[3]
	ftxtFreshCost:setShowText(string.format(strFormat, basicData.icon, nCostNum))

	if self.m_nRefreshCount >= self.m_nSearchTimes then 
		GetElement(self.m_root, "btnFresh_WndYearPlayer", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.6,0.06))
		GetElement(self.m_root, "conFind_WndYearPlayer", WZUIContainer):setVisible(true)
	else
		GetElement(self.m_root, "btnFresh_WndYearPlayer", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.485,0.06))
		GetElement(self.m_root, "conFind_WndYearPlayer", WZUIContainer):setVisible(false)
	end
end

--@brief 	显示报名界面
function WndYearPlayer:_showMyFashionInfo()
	-- body
	local conSignupRole = GetElement(self.m_root, "conPlayer_WndYearPlayer", WZUIContainer)
	conSignupRole:removeAllChildrenWithCleanup(true)

	self.m_tMyRole = {} 
	local element, tNewObj = CellDressGoodSeat:createElement2()
	if element and tNewObj then 
		tNewObj:setData2(self.m_tMyFashionData, 0)
		conSignupRole:addChild(element)

		tNewObj:setGoodNumVisible(false)
		self.m_tMyRole = {element, tNewObj}
	end
--	self:_addDressSuit(self.m_root)
	self:_showLeftRecommendTime()
	if self.m_tMyFashionData.recommendTime > 0 then 
		GetElement(self.m_root, "conSignUp_WndYearPlayer", WZUIContainer):enableSchedule("_setTimeCaculate", 1)
	end
end

--@brief 	显示剩余推荐时间
function WndYearPlayer:_showLeftRecommendTime()
	-- body
	local ftxtLeftTime = GetElement(self.m_root, "ftxtLeftTime_WndYearPlayer", WZUIFreeTextBox)
	if self.m_tMyFashionData.recommendTime > 0 then 
		local sTime = returnToTimeFormat(self.m_tMyFashionData.recommendTime)
		local strFormat = [[<T C="255,236,193" S="20" P="1">%s</T><T C="229,105,22" S="20" P="1">%s</T>]]
		ftxtLeftTime:setShowText(string.format(strFormat, LocalStrings.CHARM_LIFT34, sTime))
	else
		local strFormat = [[<T C="255,236,193" S="20" P="1">%s</T>]]
		ftxtLeftTime:setShowText(string.format(strFormat, LocalStrings.YEARPLAYER_TEXT1[14]))
	end
end

--@brief 	显示时间倒计时
function WndYearPlayer:_setTimeCaculate()
	-- body
	if self.m_tMyFashionData.recommendTime > 0 then 
		self.m_tMyFashionData.recommendTime = self.m_tMyFashionData.recommendTime - 1
		self:_showLeftRecommendTime()
	else
		self.m_tMyFashionData.recommendState = 0
		if self.m_tMyRole then 
			self.m_tMyRole[2]:setData2(self.m_tMyFashionData, 0)
		end
		self:_showLeftRecommendTime()
		GetElement(self.m_root, "conSignUp_WndYearPlayer", WZUIContainer):disableSchedule()
	end
end

--@brief 	显示海选列表
function WndYearPlayer:_showRecommendList()
	local tbPlayerList = GetElement(self.m_root, "tbPlayerList_WndYearPlayer", WZUITableContainer)
	if self.m_bNeedCleanTable then 
		tbPlayerList:cleanTable()
		self.m_tCellPickList = {}
	end

	local conCommondList = GetElement(self.m_root, "conCommondList_WndYearPlayer", WZUIContainer)
	if self.m_tPlayerList == nil or #self.m_tPlayerList == 0 then 
		ShowPanelNullTip( conCommondList, LocalStrings.CHARM_LIFT31)
		return 
	end

	removeShowPanelNullTip(conCommondList)
	for i = 1, #self.m_tPlayerList do
		if self.m_bNeedCleanTable then 
			local element, tNewObj = CellPickItem:createElement()
			if element and tNewObj then 
				element:setTag(i - 1)
				tNewObj:setData(self.m_tPlayerList[i])
				if self.m_tPickData and self.m_tPickData.id == self.m_tPlayerList[i].id then 
					self.m_tPickData = self.m_tPlayerList[i]
					self.m_tPickCell = tNewObj
				end

				table.insert(self.m_tCellPickList, tNewObj)

				tbPlayerList:setCellElement(element)
			end
		else
			if self.m_tCellPickList and self.m_tCellPickList[i] then 
				self.m_tCellPickList[i]:updateData(self.m_tPlayerList[i])
			end
		end
	end

	self.m_bNeedCleanTable = false 
end

--@brief 	显示相应标签内容
function WndYearPlayer:_showTabContent(nTag)
	self.m_nTabIndex = nTag
	if nTag == 1 then 
		GetElement(self.m_root, "conSignUp_WndYearPlayer", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "conCommondList_WndYearPlayer", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "conTask_WndYearPlayer", WZUIContainer):setVisible(false)
		self:_showMyFashionInfo()
	elseif nTag == 2 then 
		GetElement(self.m_root, "conSignUp_WndYearPlayer", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "conCommondList_WndYearPlayer", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "conTask_WndYearPlayer", WZUIContainer):setVisible(false)
	elseif nTag == 3 then 
		GetElement(self.m_root, "conSignUp_WndYearPlayer", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "conCommondList_WndYearPlayer", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "conTask_WndYearPlayer", WZUIContainer):setVisible(true)
	end
end

--@brief 	iphoneX适配
function WndYearPlayer:_adaptIphoneX()
	if IsIphoneX() then
		GetElement(self.m_root, "conLeftMenu_WndYearPlayer", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.13,0.45))
	end
end

--@brief	取得编辑框内容的函数
--@return	 sTxtContent  输入内容
function WndYearPlayer:getEditBoxInputContent()
	if self.m_root == nil  then 
		WZLog("WndYearPlayer:setEditBoxInputContent(sTxtContent) ")
		return 
	end 
	
	local sTxtContent = nil 
	local editBoxInPutContent = self.m_root:getChildElement("editBoxInPutContent_WndYearPlayer")
	if editBoxInPutContent ~= nil then 
		editBoxInPutContent = WZUIEditBox:luaTo(editBoxInPutContent)
		if editBoxInPutContent ~= nil then 
			sTextContent = editBoxInPutContent:getText()
			return sTextContent
		end 
	end 
end 

--@brief    检测输入变化
function WndYearPlayer:onEditTextChange(element)
    -- body
    element = WZUIEditBox:luaTo(element)
    local txt = element:getText()

    self:_updateInputWordsNum()
end

--@brief    更新输入的字数
function WndYearPlayer:_updateInputWordsNum(bNil)
    --
    WZLog("WndYearPlayer:_updateInputWordsNum")
    local count = 0 
    if not bNil then 
	    local editCircle = GetElement(self.m_root, "editBoxInPutContent_WndYearPlayer", WZUIEditBox)
	    local txt = editCircle:getText()
	    count = GetWordCount(txt)
	end
    local txtCurInputNum = GetElement(self.m_root, "txtCurInputNum_WndYearPlayer", WZUILabelTTF)
    txtCurInputNum:setText(count .. "/" .. self.m_nMaxWordsCount)
end


--一次减十个
function WndYearPlayer:onMutiReduce(element)
	WZLog("WndYearPlayer:onMutiReduce")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nNum > 10 then
		self.m_nNum = self.m_nNum - 10
	elseif self.m_nNum > 1 then
		self.m_nNum = 1
	else
		MsgBoxManager:showTipBox(LocalStrings.CHESTMINNUM)
	end
	GetElement(self.m_root,"useNum_WndYearPlayer",WZUILabelTTF):setText(self.m_nNum)
	self:updateCostCount()
end

--一次减一个
function WndYearPlayer:onReduce(element)
	WZLog("WndYearPlayer:onReduce")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nNum - 1 >= 1 then
		self.m_nNum = self.m_nNum - 1
	else
		MsgBoxManager:showTipBox(LocalStrings.CHESTMINNUM)
	end
	GetElement(self.m_root,"useNum_WndYearPlayer",WZUILabelTTF):setText(self.m_nNum)
	self:updateCostCount()
end

--一次加一个
function WndYearPlayer:onAdd(element)
	WZLog("WndYearPlayer:onAdd")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local useNum = GetElement(self.m_root,"useNum_WndYearPlayer",WZUILabelTTF)
	local max = math.min(self.m_nitemCount, 100)
	if self.m_nNum + 1 <= max then
		self.m_nNum = self.m_nNum + 1
	else
		MsgBoxManager:showTipBox(LocalStrings.CHESTMAXNUM)
	end
	useNum:setText(self.m_nNum)
	self:updateCostCount()
end

--@brief	增加10个
function WndYearPlayer:onMutiAdd(element)
	WZLog("WndYearPlayer:onMutiAdd")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local max = math.min(self.m_nitemCount, 100)
	if self.m_nNum + 10 <= max then
		self.m_nNum = self.m_nNum + 10
	else
		MsgBoxManager:showTipBox(LocalStrings.CHESTMAXNUM)
		self.m_nNum = max
	end
	GetElement(self.m_root,"useNum_WndYearPlayer",WZUILabelTTF):setText(self.m_nNum)
	self:updateCostCount()
end

--更新购买价格
function WndYearPlayer:updateCostCount()
	WZLog("WndYearPlayer:updateCostCount")
	local useNum = GetElement(self.m_root,"useNum_WndYearPlayer",WZUILabelTTF)
	local num = tonumber(useNum:getText())
	local max = math.min(self.m_nitemCount, 100)
	if num > max then 
		num = max 
		self.m_nNum = num 
		GetElement(self.m_root,"useNum_WndYearPlayer",WZUILabelTTF):setText(num)
	end
	local ftxtPickCost = GetElement(self.m_root,"ftxtPickCost_WndYearPlayer",WZUIFreeTextBox)
	local costCount = num * self.m_ncostCount
	WZLog("WndYearPlayer:updateCostCount", costCount)
	local strFormat = [[<T S="20" C="255,236,193" P="1" SC="132,66,29" SS="4" SE="1">%s</T><I Z="0.5" P="1">%s</I><T S="20" C="255,236,193" P="1" SC="132,66,29" SS="4" SE="1">%d</T>]]
	local basicData = GDatatab_item["id_" .. self.m_tCoinId[self.m_nCoinIndex]]
	local strContent = string.format(strFormat, LocalStrings.PETUSE, basicData.icon, costCount)
	ftxtPickCost:setShowText(strContent)
end

--@brief 	显示任务内容
--@param 	nIndex:1日常，2成长
function WndYearPlayer:_showTaskContent(nIndex)
	local tbTaskList = GetElement(self.m_root,"tbTaskList_WndYearPlayer",WZUITableContainer)
	tbTaskList:cleanTable()
	self.m_tTaskItemCell = {}

	local tTaskData = nil 
	if nIndex == 1 then 
		tTaskData = self.m_tTaskDayData
	elseif nIndex == 2 then 
		tTaskData = self.m_tTaskGrowupData
	end
	local count = getnTableCount(tTaskData)
	taskTableSort(tTaskData)
	for i = 1, count do
		local element, tLuaObj = CellYearPlayerTask:createElement()
		self.m_tTaskItemCell[i] = tLuaObj
		element:setTag(i - 1)
		tLuaObj:setGiftBuyMessage(i, tTaskData[i])
		tbTaskList:setCellElement(element)
	end
end

--@brief 	显示的文案
function WndYearPlayer:_showTalk(pickAdd)
	local nCount = #LocalStrings.YEARPLAYER_TEXT3
	local tempRand = math.random(1, 10)
	local strIndex = math.fmod(tempRand, nCount) + 1
	
	MsgBoxManager:showTipBox((LocalStrings.YEARPLAYER_TEXT3[strIndex] or LocalStrings.YEARPLAYER_TEXT3[1]) .. "  " .. LocalStrings.YEARPLAYER_TEXT1[4] .. "+" .. pickAdd)
end

--@brief 	计时器
function WndYearPlayer:caculateTime(element, delta)
	if self.m_nTabIndex ~= 2 then return end 
	if self.m_bIsFindFriend then return end 

	self.m_nRefreshTime = self.m_nRefreshTime + delta
	if self.m_nRefreshTime >= 8 then 
		self.m_nRefreshTime = 0 
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 1, "")
	end
end
-------------------------------------私有方法模块End----------------------------------------
