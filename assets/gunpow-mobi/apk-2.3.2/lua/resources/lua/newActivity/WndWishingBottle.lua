--WndWishingBottle.lua
--@brief	WndWishingBottle的UI模块
--@date		2023/06/30
--@author	yrd
--@note		许愿瓶活动主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndWishingBottle:onEnter(element)
	self.m_root = element

	g_bIsShowWndDressUp = false
	g_tTempItemForLaterShow = {}
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
	ProtocolProcessorFestivalActivity:regAll6()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
	GlobalGame:getGameEventDispathcer():Add(Independent_Activity.ActivityReddot, self.showRedDot, self)

	self:_initStaticText()
	self:_updateCoin1Num()
	self:showRedDot()
	self:_adaptIphoneX()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndWishingBottle:onExit(element)
	g_bIsShowWndDressUp = true
	g_tTempItemForLaterShow = {}
	CacheCenter:unregisterUpatePlayerItemObserver(self)
	ProtocolProcessorFestivalActivity:unregAll6()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
	GlobalGame:getGameEventDispathcer():Remove(Independent_Activity.ActivityReddot, self.showRedDot, self)

	self:_unInit()
	LoadNewActivityRes(false)
end

--@brief    onenter函数已执行
function WndWishingBottle:onEnterTransitionDidFinish(element)
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7083, 7083)
	local conTalk = GetElement(self.m_root,"conTalk_WndWishingBottle",WZUIContainer)
	conTalk:enableSchedule("_caculateTime", 1)
end

--@brief    点击关闭窗口按钮
function WndWishingBottle:showInterface()
	LoadNewActivityRes(true)
	local wnd = WndWishingBottle:createElement()
	WindowManager:addWindow(wnd, WndWishingBottle, false)
end

--@brief    点击关闭窗口按钮
function WndWishingBottle:onClickClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	self:savePoleType()
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮
function WndWishingBottle:onClickRule(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSingleMapDesc:showInterface(LocalStrings.WISHING_BOTTLE_TEXT2)
end

--@brief    初始化静态文本
function WndWishingBottle:_initStaticText()
	self:getPoleType()
	self:_setBallAni()

	GetElement(self.m_root,"txtChoosePrize_WndWishingBottle",WZUILabelTTF):setText(LocalStrings.WATERMELON_TEXT1[22])
	GetElement(self.m_root,"txtPointsWord_WndWishingBottle",WZUILabelTTF):setText(LocalStrings.WISHING_BOTTLE_TEXT1[2])

	GetElement(self.m_root,"txtBtn1_WndWishingBottle",WZUILabelTTF):setText(LocalStrings.WISHING_BOTTLE_TEXT1[5])
	GetElement(self.m_root,"txtBtn2_WndWishingBottle",WZUILabelTTF):setText(LocalStrings.WISHING_BOTTLE_TEXT1[6])
	GetElement(self.m_root,"txtBtn3_WndWishingBottle",WZUILabelTTF):setText(LocalStrings.WISHING_BOTTLE_TEXT1[7])
	GetElement(self.m_root,"txtBtn4_WndWishingBottle",WZUILabelTTF):setText(LocalStrings.WISHING_BOTTLE_TEXT1[8])
end

--@brief 	更新界面
function WndWishingBottle:updateUI()
	self:updateWishingBtn()
end

--@brief 	红点
function WndWishingBottle:showRedDot()
	if self.m_root == nil then return end 

	local imgTaskRedDot = GetElement(self.m_root, "imgTaskRedDot_WndWishingBottle", WZUIImage)
	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[217083] or GlobalGame.g_tRedPointTypeList[227083] or GlobalGame.g_tRedPointTypeList[237083]) then 
		imgTaskRedDot:setVisible(true)
	else
		imgTaskRedDot:setVisible(false)
	end
end

--@brief 	更新许愿币的数量
function WndWishingBottle:_updateCoin1Num()
	local sFormat = [[<I Z="0.4" P="1">%s</I><T C="255,236,193" S="20" P="1" SC="163,74,20" SS="4" SE="0">%d</T>]]
	local basicData = GDatatab_item["id_" .. self.m_nCoin1Id]
	local nNum = CacheCenter:getPlayerItemCountById(self.m_nCoin1Id)
	GetElement(self.m_root, "ftbOwnCoin", WZUIFreeTextBox):setShowText(string.format(sFormat, basicData.icon, nNum))
end

--@brief 	初始化活动时间
function WndWishingBottle:_initActivityTime()
	local tStartDate = os.date("*t", self.m_nStartTime)
	local tEndDate = os.date("*t", self.m_nEndTime)
	local sDuration = string.format(LocalStrings.ACTIVITYTIME_FORMAT, tStartDate.month, tStartDate.day, tStartDate.hour, tStartDate.min, tEndDate.month, tEndDate.day, tEndDate.hour, tEndDate.min)
	GetElement(self.m_root, "txtAcitvityTime", WZUILabelTTF):setText(sDuration)
end

--@brief 	更新积分进度
function WndWishingBottle:updatePointsProgress()
	GetElement(self.m_root,"txtPointsValue_WndWishingBottle",WZUILabelTTF):setText(self.m_nGiftProgress)

	local nMaxMeetIndex = 0 --已达成最大的那个积分条件下标
	for i=1,#self.m_tGiftConfig do
		if self.m_nGiftProgress >= self.m_tGiftConfig[i] then
			nMaxMeetIndex = i
		end
	end
	local tmpProgressValue = 0
	if nMaxMeetIndex == 0 then
		tmpProgressValue = 0
	elseif nMaxMeetIndex == #self.m_tGiftConfig then
		tmpProgressValue = 100
	else
		tmpProgressValue = (nMaxMeetIndex / #self.m_tGiftConfig + (self.m_nGiftProgress - self.m_tGiftConfig[nMaxMeetIndex]) / (self.m_tGiftConfig[nMaxMeetIndex + 1] - self.m_tGiftConfig[nMaxMeetIndex]) / #self.m_tGiftConfig ) * 100
	end
	local progPoints = GetElement(self.m_root,"progPoints_WndWishingBottle",WZUIProgress)
	progPoints:setPercentage(tmpProgressValue)

	self.m_tGiftBtn = {}
	local conPointsList = GetElement(self.m_root,"conPointsList_WndWishingBottle",WZUIContainer)
	conPointsList:removeAllChildrenWithCleanup(true)
	for i=1,#self.m_tGiftConfig do
		-- local nBtnPtY = self.m_tGiftConfig[i]/self.m_tGiftConfig[#self.m_tGiftConfig]
		local nBtnPtY = i/#self.m_tGiftConfig
		local btnItem = WZUIButton:create()
		btnItem:setAnchorPoint(GlobalMethod:ccp(0.5,0.1))
		btnItem:setTag(i)
		btnItem:setUseAbsSize(true)
		btnItem:setAbsContentSize(GlobalMethod:CCSize(48,48))
		btnItem:setRelativePosition(GlobalMethod:ccp(0.5,nBtnPtY))
		btnItem:setLuaActionName("Normal")
		btnItem:setLuaDoneFunctionName("onClickPointsItem")
		conPointsList:addChild(btnItem)

		local imgBtn = WZUIImage:create()
		local imagepath = string.format("shopitems/cytq_lh_%02d.png",i)
		imgBtn:setFile(imagepath)
		btnItem:addChild(imgBtn)

		local txtBtn = WZUILabelTTF:create()
		txtBtn:setFontSize(18)
		txtBtn:setColor(GlobalMethod:ccc3(255,236,193))
		txtBtn:setEnableStroke(true)
		txtBtn:setStrokeColor(GlobalMethod:ccc3(163,74,20))
		txtBtn:setStrokeSize(4)
		txtBtn:setText(self.m_tGiftConfig[i])
		txtBtn:setRelativePosition(GlobalMethod:ccp(0.5,0.2))
		btnItem:addChild(txtBtn)

		local imgYlq = WZUIImage:create()
		imgYlq:setFile("ui/newActivity/commom_icon_ylq.png")
		imgYlq:setUseOriginSize(true)
		imgYlq:setTouchSwallow(false)
		imgYlq:setScale(0.5)
		btnItem:addChild(imgYlq)

		local imgRedDot = WZUIImage:create()
		imgRedDot:setFile("ui/common/common_icon_xiaodianzhui.png")
		imgRedDot:setUseOriginSize(true)
		imgRedDot:setTouchSwallow(false)
		imgRedDot:setScale(0.7)
		imgRedDot:setRelativePosition(GlobalMethod:ccp(0.8,0.8))
		btnItem:addChild(imgRedDot)

		if self.m_tGiftRewardStatus[i] == 0 then --未完成
			imgBtn:setGrayRender(true)
			imgYlq:setVisible(false)
			imgRedDot:setVisible(false)
		elseif self.m_tGiftRewardStatus[i] == 1 then --完成未领取
			imgBtn:setGrayRender(false)
			imgYlq:setVisible(false)
			imgRedDot:setVisible(true)
		elseif self.m_tGiftRewardStatus[i] == 2 then --完成已领取
			imgBtn:setGrayRender(true)
			imgYlq:setVisible(true)
			imgRedDot:setVisible(false)
		end

		self.m_tGiftBtn[i] = self.m_tGiftBtn
	end
end

--@brief 	点击积分进度中的盒子
function WndWishingBottle:onClickPointsItem(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nTag = element:getTag()

	if self.m_tGiftRewardStatus[nTag] == 1 then
		--背包已满提示
		if CacheCenter:getRemainAmount() <= 0 then
			MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
			return
		end
		--领取宝箱奖励
		local tData = {}
		tData.giftType = nTag - 1
		local stringData = json.encode(tData)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 7, stringData)
	else
		--弹宝箱tips
		local rewardData = {}
		rewardData.nType = 6
		rewardData.strartNum = self.m_nGiftProgress
		rewardData.endNum = self.m_tGiftConfig[nTag]
		rewardData.icon = {}
		rewardData.id = {}
		rewardData.num = {}
		local sex = CacheCenter:getPlayerInfo().sex
		local array = SplitStringWithSeparator(self.m_tGiftRewards[nTag], "&")
		for i = 1, #array do
			local str = string.sub(array[i], 2, -2)
			local id = tonumber(SplitStringWithSeparator(str,",")[sex + 1])
			local num = tonumber(SplitStringWithSeparator(str,",")[3])
			local icon = GDatatab_item["id_" .. id].icon
			table.insert(rewardData.icon, icon)
			table.insert(rewardData.id, id)
			table.insert(rewardData.num, num)
		end
		WndTips:show(element, self.m_root, 3, rewardData, GlobalMethod:ccp(300,30))
		WndTips.m_root:setShowAll(true)
	end
end

--@brief 	更新选中的瓶子
function WndWishingBottle:updateChooseBottle()
	GetElement(self.m_root, "cbgTool_WndWishingBottle", WZUICheckBoxGroup):setCheckIndex(self.m_nDrawToolType)
end

--@brief 	刷新"全民许愿"礼包的信息
function WndWishingBottle:showBagGiftInfo()
	if self.m_nGiftRewardNum > 0 then 
		GetElement(self.m_root, "imgBtn4RedDot_WndWishingBottle", WZUIImage):setVisible(true)
		GetElement(self.m_root, "imgBtn4GiftNum_WndWishingBottle", WZUILabelTTF):setText(self.m_nGiftRewardNum)
	else
		GetElement(self.m_root, "imgBtn4RedDot_WndWishingBottle", WZUIImage):setVisible(false)
	end
end

--@brief 	点击"自选奖励"按钮回调
function WndWishingBottle:onClickChoosePrize(element)
	local eleType = type(element)
	if eleType ~= "number" then 
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	end

	self.m_bIsOpenReward = true 

	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 1, "")
end

--@brief 	点击选择瓶子按钮回调
function WndWishingBottle:onClickChooseTool(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nIndex = GetElement(self.m_root, "cbgTool_WndWishingBottle", WZUICheckBoxGroup):getCheckIndex()
	if self.m_nDrawToolType == nIndex then
		return
	end

	self.m_nDrawToolType = nIndex
	self:updateWishingBtn()
end

--@brief 	点击切换许愿次数按钮回调
function WndWishingBottle:onClickSwitchNum(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	self.m_nDrawNumType = self.m_nDrawNumType % #self.m_tDrawNumList + 1
	self:updateWishingBtn()
end

--@brief 	更新许愿按钮
function WndWishingBottle:updateWishingBtn()
	local imgStartWishing = GetElement(self.m_root,"imgStartWishing_WndWishingBottle",WZUIImage)
	local txtStartWishing = GetElement(self.m_root,"txtStartWishing_WndWishingBottle",WZUILabelTTF)
	if self.m_nDrawNumType == 1 then
		imgStartWishing:setFile("ui/newActivity/common_btn_hlbc_01.png")
		txtStartWishing:setStrokeColor(ccc3(198,43,85))
		if self.m_nDrawToolType == 0 and self.m_nCount > 0 then --免费许愿
			txtStartWishing:setText(LocalStrings.WISHING_BOTTLE_TEXT1[3])
		else --许愿n次
			txtStartWishing:setText(string.format(LocalStrings.WISHING_BOTTLE_TEXT1[4], self.m_tDrawNumList[self.m_nDrawNumType]))
		end
	elseif self.m_nDrawNumType == 2 then
		imgStartWishing:setFile("ui/newActivity/common_btn_hlbc_02.png")
		txtStartWishing:setStrokeColor(ccc3(62,88,210))

		local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoin1Id)
		local nTempTimes = math.floor(nArrowNum/self.m_tCostByType[self.m_nDrawToolType + 1]) --可许愿次数
		local freeCount = 0 --免费次数
		if self.m_nDrawToolType == 0 then 
			freeCount = self.m_nCount > 0 and 1 or 0 
		end
		local nTimes = self.m_tDrawNumList[self.m_nDrawNumType]
		local nAllTimes = nTempTimes + freeCount --可许愿次数 + 免费次数
		if nAllTimes > 0 and nAllTimes < self.m_tDrawNumList[self.m_nDrawNumType] then
			nTimes = nAllTimes
		end
		txtStartWishing:setText(string.format(LocalStrings.WISHING_BOTTLE_TEXT1[4], nTimes))
	end
end

--@brief 	点击许愿按钮回调
function WndWishingBottle:onClickWishing(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	--背包已满提示
	if CacheCenter:getRemainAmount() <= 0 then
		MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
		return
	end
	if self.m_bOpenState then return end 

	if self.m_nChooseReward == 0 then 
		self:onClickChoosePrize(self.m_nDrawNumType)

		self.m_nChooseReward = 1
		self:saveOperateTimes()
		return 
	end

	local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoin1Id)
	local nTempTimes = math.floor(nArrowNum/self.m_tCostByType[self.m_nDrawToolType + 1]) --可许愿次数
	local freeCount = 0 --免费次数
	if self.m_nDrawToolType == 0 then 
		freeCount = self.m_nCount > 0 and 1 or 0 
	end
	self.m_nAniType = self.m_nDrawNumType
	local nTimes = self.m_tDrawNumList[self.m_nDrawNumType]
	local nAllTimes = nTempTimes + freeCount --可许愿次数 + 免费次数
	if nAllTimes > 0 and nAllTimes < self.m_tDrawNumList[self.m_nDrawNumType] then
		nTimes = nAllTimes
	end
	local nCostNum = nTimes * self.m_tCostByType[self.m_nDrawToolType + 1]

	if nCostNum - freeCount > nArrowNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoin1Id]
		MsgBoxManager:showConfirmBox(string.format(LocalStrings.WATERCOUNTRY_TEXT4, basicData.name), self, self.goToBuy)
		return 
	end

	local tData = {}
	tData.times = self.m_tDrawNumList[self.m_nDrawNumType]
	tData.grade = self.m_nDrawToolType

	local stringData = json.encode(tData)

	self:setOpenState(true)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 3, stringData)
end

--@brief 	前往小推车购买
function WndWishingBottle:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

--@brief 	点击"许愿日记"按钮回调
function WndWishingBottle:onClickLogs(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	CellNewYearTask:showInterface(31, self.m_nActivityId)
end

--@brief 	点击"心愿商店"按钮回调
function WndWishingBottle:onClickStore(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndDollMachineShop:showInterface(9, self.m_nActivityId)
end

--@brief 	点击"许愿榜"按钮回调
function WndWishingBottle:onClickRank(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndShopRank:showInterface(48, self.m_nActivityId)
end

--@brief 	点击"全民许愿"按钮回调
function WndWishingBottle:onClickWholePeople(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nGiftRewardNum >= 1 then
		--背包已满提示
		if CacheCenter:getRemainAmount() <= 0 then
			MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
			return
		end
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 6, "")
	else
		local tData = {}
		tData.txtTitle = string.format(LocalStrings.WISHING_BOTTLE_TEXT1[15], self.m_nGiftRewardConfig)
		tData.nType = 2
		WndTips:show(element, self.m_root, 52, tData, GlobalMethod:ccp(20,100), true)
	end
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndWishingBottle:_setBowlingPlayAni(aniIndex, bLoop)
	local spineOpen = GetElement(self.m_root, "spineOpen_WndWishingBottle", WZUISpine)
	aniIndex = aniIndex or 1

	if spineOpen then 
		spineOpen:play(self.m_tBallAniName[self.m_nDrawToolType + 1][aniIndex], bLoop == nil and bLoop or false)
	end
end

--@brief 	显示开启动画
function WndWishingBottle:showOpenAction()
	local spineOpen = GetElement(self.m_root, "spineOpen_WndWishingBottle", WZUISpine)
	local spinePath = "activity/ui_activity_xyp_1"
	local existSpine = CheckEffectFile(spinePath)

	if spineOpen then 
		if existSpine then 
			local aniIndex = self.m_nAniType + 1 
			self:_setBowlingPlayAni(aniIndex, false)
			local nSeconds = 2
			spineOpen:enableSchedule("showShootReward", nSeconds)
		else
			self:showShootReward()
		end
	end
end

--@brief 	显示开启奖励
function WndWishingBottle:showShootReward()
	local spineOpen = GetElement(self.m_root, "spineOpen_WndWishingBottle", WZUISpine)
	spineOpen:disableSchedule()
	self:_setBowlingPlayAni(1, false)

	local strContent = ""
	local nIndex = 0 
	if self.m_tOpenResult.addExp and self.m_tOpenResult.addExp > 0 then 
		strContent = strContent .. LocalStrings.WISHING_BOTTLE_TEXT1[2] .. "+" .. self.m_tOpenResult.addExp 
		nIndex = nIndex + 1
	end
	if self.m_tOpenResult.addNum and self.m_tOpenResult.addNum > 0 then 
		if nIndex > 0 then 
			strContent = strContent .. "  "
		end
		strContent = strContent .. LocalStrings.WISHING_BOTTLE_TEXT1[19] .. "+" .. self.m_tOpenResult.addNum 
	end

	if strContent ~= "" then 
		MsgBoxManager:showTipBox(strContent, nil, nil, nil, nil, nil, nil, nil, nil, GlobalMethod:ccp(0.5, 0.77))
	end

	self:setOpenState(false)
	self:_afterCloseReward()
end

--@brief 	设置待机特效
function WndWishingBottle:_setBallAni()
	local spinePath = "activity/ui_activity_xyp_1"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		local spineOpen = GetElement(self.m_root, "spineOpen_WndWishingBottle", WZUISpine)
		if spineOpen then 
			spineOpen:setFileJson(spinePath .. ".json")
			spineOpen:setFileAtlas(spinePath .. ".atlas")
			self:_setBowlingPlayAni(1, false)
		end
	else
		local _sIndex = "ui_activity_xyp_1"
		local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
		if downloadInfo then 
			DownloadManager:addDownloadTask(7083, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndWishingBottle)
		end
	end

	--背景
	local spinePath2 = "activity/ui_activity_xyp"
	local existSpine2 = CheckEffectFile(spinePath2)
	if existSpine2 then 
		local spineBG = GetElement(self.m_root, "spineBG_WndWishingBottle", WZUISpine)
		if spineBG then 
			spineBG:setFileJson(spinePath2 .. ".json")
			spineBG:setFileAtlas(spinePath2 .. ".atlas")
			spineBG:play("wait", true)
		end
	else
		local _sIndex = "ui_activity_xyp"
		local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
		if downloadInfo then 
			DownloadManager:addDownloadTask(70830, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndWishingBottle)
		end
	end
end

function WndWishingBottle:downloadEffectCallback(taskId,extraData,failed)
	WZLog("WndWishingBottle:downloadEffectCallback",taskId,extraData,failed)
	self:_setBallAni()
end

--@brief 	显示许愿语
function WndWishingBottle:_showTalk()
	local conTalk = GetElement(self.m_root, "conTalk_WndWishingBottle", WZUIContainer)
	conTalk:setVisible(true)

	local txtTalk = GetElement(self.m_root, "txtTalk_WndWishingBottle", WZUILabelTTF)
	local tTalkList = LocalStrings.WISHING_BOTTLE_TEXT3
	local nCount = #tTalkList
	local tempRand = math.random(1, 10)
	local strIndex = math.fmod(tempRand, nCount) + 1
	-- if self.m_nLastTalkIndex == strIndex or self.m_nTalkGapping ~= nil then return end 
	self.m_nLastTalkIndex = strIndex
	self.m_nTalkGapping = 3
	txtTalk:setText(tTalkList[strIndex] or tTalkList[1])

	local minW = 140
	local minH = 65
	local fontSize = txtTalk:getContentSize()
	local nIntervalW = 90
	local nWidth = math.max(minW, (fontSize.width + nIntervalW))
	local nHeight = minH
	conTalk:setAbsContentSize(GlobalMethod:CCSize(nWidth, nHeight))
	conTalk:updateRelativeSize()
end

--@brief 	计时器
function WndWishingBottle:_caculateTime()
	if self.m_nTalkGapping == nil then return end 

	if self.m_nTalkGapping > 0 then 
		self.m_nTalkGapping = self.m_nTalkGapping - 1
	else
		self.m_nTalkGapping = nil 
		self.m_nLastTalkIndex = 0
		GetElement(self.m_root, "conTalk_WndWishingBottle", WZUIContainer):setVisible(false)
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


--@brief 	iphoneX适配
function WndWishingBottle:_adaptIphoneX()
	if IsIphoneX() then
		GetElement(self.m_root, "conPointsBox_WndWishingBottle", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.06,0.46))
		GetElement(self.m_root, "btn1_WndWishingBottle", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.93,0.555))
		GetElement(self.m_root, "btn2_WndWishingBottle", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.93,0.42))
		GetElement(self.m_root, "btn3_WndWishingBottle", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.93,0.285))
		GetElement(self.m_root, "btn4_WndWishingBottle", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.93,0.11))
	end
end



-------------------------------------私有方法模块End----------------------------------------


function WndWishingBottle:_adaptLanguage_vn()
	GetElement(self.m_root,"txtPointsWord_WndWishingBottle",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtStartWishing_WndWishingBottle",WZUILabelTTF):setScale(0.65)
	GetElement(self.m_root,"txtBtn1_WndWishingBottle",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtBtn2_WndWishingBottle",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtBtn3_WndWishingBottle",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtBtn4_WndWishingBottle",WZUILabelTTF):setScale(0.7)
end