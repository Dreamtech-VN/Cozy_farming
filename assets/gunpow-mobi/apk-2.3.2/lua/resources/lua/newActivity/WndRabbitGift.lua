--WndRabbitGift.lua
--@brief    WndRabbitGift的UI模块
--@date     2025/08/05
--@author   yrd
--@note     福兔送礼活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief    进入场景时被调用的函数
--@param    element:表绑定的UI节点引用
--@note     在这里做场景进入前的准备工作
function WndRabbitGift:onEnter(element)
	self.m_root = element

	g_bIsShowWndDressUp = false
	g_tTempItemForLaterShow = {}
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
	ProtocolProcessorFestivalActivity:regAll6()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
	GlobalGame:getGameEventDispathcer():Add(Independent_Activity.ActivityReddot, self.showRedDot, self)

	self:_initStaticText()
	self:_updateCoinNum()

	self:_adaptIphoneX()

	AdaptLanguage(self)
end

--@brief    退出场景时被调用的函数
--@param    element:表绑定的UI节点引用
--@note     在这里做场景退出前的清理工作
function WndRabbitGift:onExit(element)
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
function WndRabbitGift:onEnterTransitionDidFinish(element)
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7170, 7170)
end

--@brief    点击关闭窗口按钮
function WndRabbitGift:showInterface()
	LoadNewActivityRes(true)
	local wnd = WndRabbitGift:createElement()
	WindowManager:addWindow(wnd, WndRabbitGift, false)
end

--@brief    点击关闭窗口按钮
function WndRabbitGift:onClickClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	SaveActivityPoleType("TOOLTYPE_7170", self.m_nDrawToolType)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮
function WndRabbitGift:onClickRule(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSingleMapDesc:showInterface(LocalStrings.RABBIT_GIFT_TEXT2)
end

--@brief    初始化静态文本
function WndRabbitGift:_initStaticText()
	self.m_nDrawToolType = GetActivityPoleType("TOOLTYPE_7170")
	if self.m_nDrawToolType ~= 0 then 
		GetElement(self.m_root, "cbgTools", WZUICheckBoxGroup):setCheckIndex(self.m_nDrawToolType)
	end
	self:_showAnimal()

	GetElement(self.m_root,"txtChoosePrize",WZUILabelTTF):setText(LocalStrings.WATERMELON_TEXT1[22])

	GetElement(self.m_root,"txtOperateBtn1",WZUILabelTTF):setText(LocalStrings.RABBIT_GIFT_TEXT1[4])
	GetElement(self.m_root,"txtOperateBtn2",WZUILabelTTF):setText(LocalStrings.RABBIT_GIFT_TEXT1[5])
	GetElement(self.m_root,"txtOperateBtn3",WZUILabelTTF):setText(LocalStrings.RABBIT_GIFT_TEXT1[6])
	GetElement(self.m_root,"txtTypeName",WZUILabelTTF):setText(LocalStrings.RABBIT_GIFT_TEXT1[7])

	self:_updateTips()
end

--@brief    更新提示
function WndRabbitGift:_updateTips()
	local tContentList = {LocalStrings.RABBIT_GIFT_TEXT1[17], LocalStrings.RABBIT_GIFT_TEXT1[21]}
	GetElement(self.m_root,"txtTips1",WZUILabelTTF):setText(tContentList[self.m_nDrawToolType + 1])
end

--@brief    更新许愿币的数量
function WndRabbitGift:_updateCoinNum()
	local sFormat = [[<I Z="0.4" P="1">%s</I><T C="255,236,193" S="20" P="1" SC="163,74,20" SS="4" SE="0">%d</T>]]
	local basicData = GDatatab_item["id_" .. self.m_nCoinId]
	local nNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	GetElement(self.m_root, "ftbOwnCoin", WZUIFreeTextBox):setShowText(string.format(sFormat, basicData.icon, nNum))
end

--@brief    初始化活动时间
function WndRabbitGift:_initActivityTime()
	local tStartDate = os.date("*t", self.m_nStartTime)
	local tEndDate = os.date("*t", self.m_nEndTime)
	local sDuration = string.format(LocalStrings.ACTIVITYTIME_FORMAT, tStartDate.month, tStartDate.day, tStartDate.hour, tStartDate.min, tEndDate.month, tEndDate.day, tEndDate.hour, tEndDate.min)
	GetElement(self.m_root, "txtActivityTime", WZUILabelTTF):setText(sDuration)
end

--@brief    红点
function WndRabbitGift:showRedDot()
	if self.m_root == nil then return end 

	local imgBtnRedDot2 = GetElement(self.m_root, "imgBtnRedDot2", WZUIImage)
	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[217170] or GlobalGame.g_tRedPointTypeList[227170] or GlobalGame.g_tRedPointTypeList[237170]) then 
		imgBtnRedDot2:setVisible(true)
	else
		imgBtnRedDot2:setVisible(false)
	end


	local imgBtnRedDot4 = GetElement(self.m_root, "imgBtnRedDot4", WZUIImage)
	if GlobalGame.g_tRedPointTypeList and GlobalGame.g_tRedPointTypeList[17170] then 
		imgBtnRedDot4:setVisible(true)
	else
		imgBtnRedDot4:setVisible(false)
	end
end


--@brief    点击积分宝箱回调
function WndRabbitGift:onClickScoreBox(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if self.m_tScoreConfig[nTag].status == 0 then 
		--背包已满提示
		if CacheCenter:getRemainAmount() <= 0 then
			MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
			return
		end
		local tData = {}
		tData.id = nTag - 1
		local strData = json.encode(tData)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 5, strData)
	else
		local tData = self.m_tScoreConfig[nTag]
		local data = {}

		data.scale = 0.4
		local reward_id = {}
		local reward_num = {}
		for i = 1, #tData.reward do
			table.insert(reward_id,  tData.reward[i][1])
			table.insert(reward_num, tData.reward[i][2])
		end
		data.cur_value = self.m_nCurScore
		data.totle_value = tData.scoreTarget
		data.rewardIds = reward_id
		data.rewardNums = reward_num
		data.origin = 887170
		local conLeftScore = GetElement(self.m_root, "conLeftScore", WZUIContainer)
		WndNewTipsReward:showInterface(conLeftScore, element, data, false, GlobalMethod:ccp(8.5, -0.1))
	end
end

--@brief    成熟度
function WndRabbitGift:_showProgress()
	local txtStepNum = GetElement(self.m_root, "txtStepNum", WZUILabelTTF)
	if txtStepNum then 
		txtStepNum:setText(self.m_nCurScore)
	end

	local prgExp = GetElement(self.m_root, "prgExp", WZUIProgress)
	local nCurNum = self.m_nCurScore
	if prgExp then 
		if nCurNum <= self.m_tScoreConfig[1].scoreTarget then 
			prgExp:setPercentage(math.floor(nCurNum * 17/self.m_tScoreConfig[1].scoreTarget))
		elseif nCurNum <= self.m_tScoreConfig[2].scoreTarget then 
			local nTempNum = self.m_tScoreConfig[2].scoreTarget - self.m_tScoreConfig[1].scoreTarget
			prgExp:setPercentage(17 + math.floor((nCurNum - self.m_tScoreConfig[1].scoreTarget) * 17/nTempNum))
		elseif nCurNum <= self.m_tScoreConfig[3].scoreTarget then 
			local nTempNum = self.m_tScoreConfig[3].scoreTarget - self.m_tScoreConfig[2].scoreTarget
			prgExp:setPercentage(34 + math.floor((nCurNum - self.m_tScoreConfig[2].scoreTarget) * 17/nTempNum))
		elseif nCurNum <= self.m_tScoreConfig[4].scoreTarget then 
			local nTempNum = self.m_tScoreConfig[4].scoreTarget - self.m_tScoreConfig[3].scoreTarget
			prgExp:setPercentage(51 + math.floor((nCurNum - self.m_tScoreConfig[3].scoreTarget) * 17/nTempNum))
		elseif nCurNum <= self.m_tScoreConfig[5].scoreTarget then 
			local nTempNum = self.m_tScoreConfig[5].scoreTarget - self.m_tScoreConfig[4].scoreTarget
			prgExp:setPercentage(68 + math.floor((nCurNum - self.m_tScoreConfig[4].scoreTarget) * 17/nTempNum))
		elseif nCurNum <= self.m_tScoreConfig[6].scoreTarget then 
			local nTempNum = self.m_tScoreConfig[6].scoreTarget - self.m_tScoreConfig[5].scoreTarget
			prgExp:setPercentage(85 + math.floor((nCurNum - self.m_tScoreConfig[5].scoreTarget) * 17/nTempNum))
		else
			prgExp:setPercentage(100)
		end
	end

	--步数
	for i = 1, 6 do
		if self.m_tScoreConfig[i].lastStatus == nil or self.m_tScoreConfig[i].lastStatus ~= self.m_tScoreConfig[i].status then 
			if self.m_tScoreConfig[i].status == 0 then 
				GetElement(self.m_root, "imgFlag" .. i, WZUIImage):setGrayRender(false)
				GetElement(self.m_root, "spineScoreBox" .. i, WZUISpine):setVisible(true)
				GetElement(self.m_root, "imgRec" .. i, WZUIImage):setVisible(false)
			elseif self.m_tScoreConfig[i].status == -1 then 
				GetElement(self.m_root, "imgFlag" .. i, WZUIImage):setGrayRender(true)
				GetElement(self.m_root, "spineScoreBox" .. i, WZUISpine):setVisible(false)
				GetElement(self.m_root, "imgRec" .. i, WZUIImage):setVisible(false)
			else
				GetElement(self.m_root, "imgFlag" .. i, WZUIImage):setGrayRender(false)
				GetElement(self.m_root, "spineScoreBox" .. i, WZUISpine):setVisible(false)
				GetElement(self.m_root, "imgRec" .. i, WZUIImage):setVisible(true)
			end

			self.m_tScoreConfig[i].lastStatus = self.m_tScoreConfig[i].status
		end
	end
end

--@brief    设置步数积分宝箱数量
function WndRabbitGift:_showStepScoreNum()
	for i = 1, 6 do
		local txtScore = GetElement(self.m_root, "txtScore" .. i, WZUILabelTTF)
		txtScore:setText(self.m_tScoreConfig[i].scoreTarget)
	end
end


--@brief    更新界面
function WndRabbitGift:updateUI()

end

--@brief    点击选择瓶子按钮回调
function WndRabbitGift:onClickChooseTool(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nIndex = GetElement(self.m_root, "cbgTools", WZUICheckBoxGroup):getCheckIndex()
	if self.m_nDrawToolType == nIndex then
		return
	end

	self.m_nDrawToolType = nIndex
	self:updateWishingBtn()
	self:_playAni(1, true)
	self:_playAnotherAni(0)
	self:showScore()
	self:_updateTips()
end

--@brief    更新许愿按钮
function WndRabbitGift:updateWishingBtn()
	for i=1, 2 do
		local txtUseTool = GetElement(self.m_root,"txtUseTool"..i,WZUILabelTTF)

		local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
		local nTempTimes = math.floor(nArrowNum/self.m_tCostByType[self.m_nDrawToolType + 1]) --可许愿次数
		local freeCount = 0 --免费次数
		if self.m_nDrawToolType == 0 then 
			freeCount = self.m_nCount > 0 and 1 or 0 
		end
		local nTimes = self.m_tDrawNumList[i]
		local nAllTimes = nTempTimes + freeCount --可许愿次数 + 免费次数
		if nAllTimes > 0 and nAllTimes < self.m_tDrawNumList[i] then
			nTimes = nAllTimes
		end
		if freeCount == 1 then
			if i == 1 then
				txtUseTool:setText(LocalStrings.RABBIT_GIFT_TEXT1[2])
			elseif i == 2 then
				if nTempTimes == 0 then
					txtUseTool:setText(string.format(LocalStrings.RABBIT_GIFT_TEXT1[3], self.m_tDrawNumList[i]))
				else
					txtUseTool:setText(string.format(LocalStrings.RABBIT_GIFT_TEXT1[3], nTimes))
				end
			end
		else
			txtUseTool:setText(string.format(LocalStrings.RABBIT_GIFT_TEXT1[3], nTimes))
		end
	end
end


--@brief    设置待机特效
function WndRabbitGift:_showAnimal()
	local spinePath = "activity/hd_pic_ftsl"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then
		local spineBG = GetElement(self.m_root, "spineBG", WZUISpine)
		if spineBG then 
			spineBG:setFileJson(spinePath .. ".json")
			spineBG:setFileAtlas(spinePath .. ".atlas")
			spineBG:play("wait3", true)
		end
		local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
		if spineOpen then
			spineOpen:setFileJson(spinePath .. ".json") 
			spineOpen:setFileAtlas(spinePath .. ".atlas")
			self:_playAni(1, true)
		end
		local spineCopy = GetElement(self.m_root, "spineCopy", WZUISpine)
		if spineCopy then
			spineCopy:setFileJson(spinePath .. ".json") 
			spineCopy:setFileAtlas(spinePath .. ".atlas")
			self:_playAnotherAni(0)
		end
	end


	local spinePath2 = "city/ui_main_iconeffect"
	local existSpine2 = CheckEffectFile(spinePath2)
	if existSpine2 then 
		for i = 1, 6 do
			local spineScoreBox = GetElement(self.m_root, "spineScoreBox" .. i, WZUISpine)
			if spineScoreBox then 
				spineScoreBox:setFileJson(spinePath2 .. ".json")
				spineScoreBox:setFileAtlas(spinePath2 .. ".atlas")
				spineScoreBox:play("animation", true)
			end
		end
	end
end

function WndRabbitGift:downloadEffectCallback(taskId,extraData,failed)
	WZLog("WndRabbitGift:downloadEffectCallback",taskId,extraData,failed)
	self:_showAnimal()
end

--@brief    设置播放的保龄球的动画
--@param    aniIndex:1待机；2击球
function WndRabbitGift:_playAni(aniIndex, bLoop)
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	aniIndex = aniIndex or 0
	if aniIndex == 0 then
		spineOpen:setVisible(false)
		return
	end
	spineOpen:setVisible(true)
	bLoop = bLoop == true and true or false

	if spineOpen then 
		spineOpen:play(self.m_tClipAniName[self.m_nDrawToolType + 1][aniIndex], bLoop)
	end
end

--@brief    设置播放的保龄球的动画
--@param    aniIndex:1待机；2击球
function WndRabbitGift:_playAnotherAni(aniIndex, bLoop)
	local spineCopy = GetElement(self.m_root, "spineCopy", WZUISpine)
	aniIndex = aniIndex or 0
	if aniIndex == 0 then
		spineCopy:setVisible(false)
		return
	end
	spineCopy:setVisible(true)
	bLoop = bLoop == true and true or false

	if spineCopy then 
		spineCopy:play(self.m_tClipAniName[self.m_nDrawToolType + 1][aniIndex], bLoop)
	end
end

--@brief    显示开启动画
function WndRabbitGift:showOpenAction()
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	local spinePath1 = "activity/hd_pic_ftsl"
	local existSpine1 = CheckEffectFile(spinePath1)
	if spineOpen then 
		if existSpine1 then
			local aniIndex = self.m_nAniType + 1 
			self:_playAnotherAni(aniIndex, false)
			-- local nSeconds = 2
			-- spineOpen:enableSchedule("showShootReward", nSeconds)
			spineOpen:enableSchedule("showShootBefore", 0)
		else
			self:showShootReward()
		end
	end
end

--@brief    显示开启奖励 处理抽奖时人物人物会闪一下问题
function WndRabbitGift:showShootBefore()
	self:_playAni(0)
	local nSeconds = 1.6
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	spineOpen:disableSchedule()
	spineOpen:enableSchedule("showShootReward", nSeconds)
end

--@brief    显示开启奖励
function WndRabbitGift:showShootReward()
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	spineOpen:disableSchedule()
	self:_playAni(1, true)
	self:_playAnotherAni(0)

	local strContent = ""
	if self.m_tOpenResult.score and self.m_tOpenResult.score > 0 then 
		strContent = strContent .. LocalStrings.RABBIT_GIFT_TEXT1[7] .. "+" .. self.m_tOpenResult.score .. "    "
	end
	if self.m_tOpenResult.shopNum and self.m_tOpenResult.shopNum > 0 then 
		strContent = strContent .. LocalStrings.RABBIT_GIFT_TEXT1[16] .. "+" .. self.m_tOpenResult.shopNum .. "    "
	end

	if strContent ~= "" then 
		MsgBoxManager:showTipBox(strContent, nil, nil, nil, nil, nil, nil, nil, nil, GlobalMethod:ccp(0.5, 0.77))
	end

	self:setOpenState(false)
	self:_afterCloseReward()
end



--@brief    点击"自选奖励"按钮回调
function WndRabbitGift:onClickChoosePrize(element)
	local eleType = type(element)
	if eleType ~= "number" then 
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	end

	self.m_bIsOpenReward = true

	self.m_tGetTimes = {}
	self.m_tBigRewardList = {}

	local tData = {pool = 0}
	local tData2 = {pool = 1}
	local strJson = json.encode(tData)
	local strJson2 = json.encode(tData2)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson2)
end

--@brief    点击许愿按钮回调
function WndRabbitGift:onClickUseTool(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	--背包已满提示
	if CacheCenter:getRemainAmount() <= 0 then
		MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
		return
	end
	if self.m_bOpenState then return end 

	if self.m_nChooseReward == 0 then 
		self:onClickChoosePrize(0)

		self.m_nChooseReward = 1
		SaveOperateTimes("OPERATETIMES_7170", self.m_nActivityId)
		return 
	end

	local nTag = element:getTag()
	local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local nTempTimes = math.floor(nArrowNum/self.m_tCostByType[self.m_nDrawToolType + 1]) --可许愿次数
	local freeCount = 0 --免费次数
	if self.m_nDrawToolType == 0 then 
		freeCount = self.m_nCount > 0 and 1 or 0 
	end
	self.m_nAniType = nTag
	local nTimes = self.m_tDrawNumList[nTag]
	local nAllTimes = nTempTimes + freeCount --可许愿次数 + 免费次数
	if nAllTimes > 0 and nAllTimes < self.m_tDrawNumList[nTag] then
		nTimes = nAllTimes
	end

	local nCostNum = nTimes * self.m_tCostByType[self.m_nDrawToolType + 1]
	if nCostNum - freeCount > nArrowNum or self.m_nAniType == 2 and nArrowNum == 0 then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		MsgBoxManager:showConfirmBox(string.format(LocalStrings.WATERCOUNTRY_TEXT4, basicData.name), self, self.goToBuy)
		return 
	end

	self:setOpenState(true)

	local tData = {}
	tData.times = self.m_tDrawNumList[nTag]
	tData.pool = self.m_nDrawToolType
	local stringData = json.encode(tData)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 3, stringData)
end

--@brief    前往小推车购买
function WndRabbitGift:goToBuy(nId, nResType)
	if nResType == MSGBOXRESTYPE_CONFIRM then
        -- WndActivityPropsGift:showInterface(self.m_nCoinId)
        WndApartmentAct:showInterface()
	end
end

--@brief    点击按钮回调
function WndRabbitGift:onClickOperateBtn(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nTag = element:getTag()
	if nTag == 1 then
		local otherData = {}
		otherData.type = 1
		otherData.strRankTitleName = LocalStrings.RABBIT_GIFT_TEXT1[4]
		otherData.strChangeTitle = LocalStrings.RABBIT_GIFT_TEXT1[10]
		otherData.strScoreTitle = LocalStrings.RABBIT_GIFT_TEXT1[11] .. ":"
		otherData.origin = 877170
		WndShopRank:showInterface(90, self.m_nActivityId, nil, nil, otherData)
	elseif nTag == 2 then
		local otherData = {}
		otherData.taskCount = 2
		otherData.tTaskTypeName = {LocalStrings.RABBIT_GIFT_TEXT1[12], LocalStrings.RABBIT_GIFT_TEXT1[13]}
		otherData.titleList = otherData.tTaskTypeName
		otherData.taskType = 1
		otherData.redPoint = {227170, 217170} --长线；日常；每天
		otherData.origin = 877170
		CellNewYearTask:showInterface(60, self.m_nActivityId, otherData)
	elseif nTag == 3 then
		local otherData = {}
		otherData.title = LocalStrings.RABBIT_GIFT_TEXT1[4]
		otherData.doType_get = 6
		otherData.doType_buy = 7
		otherData.showBuyReward = true 
		otherData.coinId = self.m_nCoinId2
		otherData.chipPt = GlobalMethod:ccp(0.034,0.95) 
		WndDollMachineShop:showInterface(90, self.m_nActivityId, otherData)
	elseif nTag == 4 then
		self.m_tGetTimes = {}
		self.m_tBigRewardList = {}

		local pool
		if self.m_nDrawToolType == 0 then
			pool = 2
		elseif self.m_nDrawToolType == 1 then
			pool = 3
		end
		local tData = {pool = pool}
		local strJson = json.encode(tData)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson)
	end
end

--@brief    显示"心愿奖励"自选奖励
function WndRabbitGift:showWishReward()
    local otherData = {}
    otherData.activityId = self.m_nActivityId
    otherData.chooseInfo = {strKey="RABBIT_GIFT_TEXT1", wordIndex=17, doType=4}
    otherData.changeRes = 2
    otherData.img9Bg = "ui/specialBg/hd_pic_ftsl_xyxz.png"
    otherData.titlePt = GlobalMethod:ccp(0.5,0.74)
    otherData.titleStroke = true
    otherData.titleColor = GlobalMethod:ccc3(255,246,219)
    otherData.titleStrokeColor = GlobalMethod:ccc3(132,66,29)
    otherData.tabRewardPt = GlobalMethod:ccp(0.5,0.41)
    otherData.btnClosePt = GlobalMethod:ccp(0.5,0.011)

    otherData.dividerFile = "ui/common/frame_fengexian_01.png"
    otherData.dividerSize = GlobalMethod:CCSize(454,3)
    otherData.dividerPt = GlobalMethod:ccp(0.5,0.133)

    otherData.titleArrowFile = "ui/newActivity/title_frame_73.png"
    otherData.titleArrowPt = {GlobalMethod:ccp(0.29,0.74),GlobalMethod:ccp(0.71,0.74)}
    otherData.titleArrowFilpX = {true,false}

    WndAthShop:showInterface("", self.m_tExReward, LocalStrings.RABBIT_GIFT_TEXT1[18], otherData)
end

--@brief    显示"心愿选择"积分
function WndRabbitGift:showScore()
	local nScore = self.m_nScoreList[self.m_nDrawToolType + 1]
	local strScore = string.format("%03d",nScore)
	for i = 1, 3 do
		local txtOtherScore = GetElement(self.m_root,"txtOtherScore"..i,WZUILabelTTF)
		txtOtherScore:setText(strScore:sub(i, i))
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief    iphoneX适配
function WndRabbitGift:_adaptIphoneX()
	if IsIphoneX() then
		GetElement(self.m_root,"conLeftScore",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.059,0.54))
		GetElement(self.m_root,"btnOperate1",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.927,0.091))
		GetElement(self.m_root,"btnOperate2",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.927,0.241))
		GetElement(self.m_root,"btnOperate3",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.927,0.391))
	end
end




-------------------------------------私有方法模块End----------------------------------------


---------------------------------------------语言适配Begin-----------------------------------

function WndRabbitGift:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txtOperateBtn1",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtOperateBtn2",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtOperateBtn3",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtUseTool1",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtUseTool2",WZUILabelTTF):setScale(0.8)
end

---------------------------------------------语言适配End--------------------------------------
