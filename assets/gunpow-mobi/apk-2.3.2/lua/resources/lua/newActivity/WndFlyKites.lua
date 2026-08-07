--WndFlyKites.lua
--@brief	WndFlyKites的UI模块
--@date		2023/09/07
--@author	yrd
--@note		放风筝活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFlyKites:onEnter(element)
	self.m_root = element

	g_bIsShowWndDressUp = false
	g_tTempItemForLaterShow = {}
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
	ProtocolProcessorFestivalActivity:regAll6()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
	GlobalGame:getGameEventDispathcer():Add(Independent_Activity.ActivityReddot, self.showRedDot, self)

	self:_adaptIphoneX()
	self:_initStaticText()
	self:_updateCoinNum()

	GetElement(self.m_root,"conCityMain",WZUIContainer):setVisible(false)

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFlyKites:onExit(element)
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
function WndFlyKites:onEnterTransitionDidFinish(element)
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7092, 7092)
end

--@brief    点击关闭窗口按钮
function WndFlyKites:showInterface()
	LoadNewActivityRes(true)
	local wnd = WndFlyKites:createElement()
	WindowManager:addWindow(wnd, WndFlyKites, false)
end

--@brief    点击关闭窗口按钮
function WndFlyKites:onClickClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	self:saveToolType()
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮
function WndFlyKites:onClickRule(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSingleMapDesc:showInterface(LocalStrings.FLYKITES_TEXT2)
end

--@brief    初始化静态文本
function WndFlyKites:_initStaticText()
	self:getToolType()
	self:_showAnimal()
	self:showRedDot()

	GetElement(self.m_root,"txtChoosePrize",WZUILabelTTF):setText(LocalStrings.WATERMELON_TEXT1[22])

	GetElement(self.m_root,"txtOperateBtn1",WZUILabelTTF):setText(LocalStrings.FLYKITES_TEXT1[4])
	GetElement(self.m_root,"txtOperateBtn3",WZUILabelTTF):setText(LocalStrings.FLYKITES_TEXT1[6])
	GetElement(self.m_root,"txtOperateBtn4",WZUILabelTTF):setText(LocalStrings.FLYKITES_TEXT1[5])

	GetElement(self.m_root,"txtTypeName",WZUILabelTTF):setText(LocalStrings.FLYKITES_TEXT1[19] .. ":")

	GetElement(self.m_root, "txtTalk", WZUILabelTTF):setText(LocalStrings.FLYKITES_TEXT1[27])
end

--@brief 	更新许愿币的数量
function WndFlyKites:_updateCoinNum()
	local sFormat = [[<I Z="0.4" P="1">%s</I><T C="255,236,193" S="20" P="1" SC="163,74,20" SS="4" SE="0">%d</T>]]
	local basicData = GDatatab_item["id_" .. self.m_nCoinId1]
	local nNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId1)
	GetElement(self.m_root, "ftbOwnCoin", WZUIFreeTextBox):setShowText(string.format(sFormat, basicData.icon, nNum))
end

--@brief 	初始化活动时间
function WndFlyKites:_initActivityTime()
	local tStartDate = os.date("*t", self.m_nStartTime)
	local tEndDate = os.date("*t", self.m_nEndTime)
	local sDuration = string.format(LocalStrings.ACTIVITYTIME_FORMAT, tStartDate.month, tStartDate.day, tStartDate.hour, tStartDate.min, tEndDate.month, tEndDate.day, tEndDate.hour, tEndDate.min)
	GetElement(self.m_root, "txtAcitvityTime", WZUILabelTTF):setText(LocalStrings.PEOPLE_SHOP_TEXT1.. " "..sDuration)
end

--@brief 	红点
function WndFlyKites:showRedDot()
	if self.m_root == nil then return end 

	local imgBtnRedDot1 = GetElement(self.m_root, "imgBtnRedDot1", WZUIImage)
	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[217092] or GlobalGame.g_tRedPointTypeList[227092] or GlobalGame.g_tRedPointTypeList[237092]) then 
		imgBtnRedDot1:setVisible(true)
	else
		imgBtnRedDot1:setVisible(false)
	end
end

--@brief 	显示旅行脚印红点
function WndFlyKites:showRedDot4()
	local bRedDot4 = false
	if self.m_tCityRewardStatus then
		for i=1,#self.m_tCityRewardStatus do
			if self.m_tCityRewardStatus[i][1] > self.m_tCityRewardStatus[i][2] then
				bRedDot4 = true
			end
		end
	end
	GetElement(self.m_root,"imgBtnRedDot4",WZUIImage):setVisible(bRedDot4)
end

--@brief 	刷新赛事礼包的信息
function WndFlyKites:showBagGiftInfo()
	if self.m_nGiftRewardNum > 0 then 
		GetElement(self.m_root, "imgBtnRedDot2", WZUIImage):setVisible(true)
		GetElement(self.m_root, "txtBtnRedDot2", WZUILabelTTF):setText(self.m_nGiftRewardNum)
	else
		GetElement(self.m_root, "imgBtnRedDot2", WZUIImage):setVisible(false)
	end
end


--@brief 	点击选择瓶子按钮回调
function WndFlyKites:onClickChooseTool(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nIndex = GetElement(self.m_root, "cbgTools", WZUICheckBoxGroup):getCheckIndex()
	if self.m_nDrawToolType == nIndex then
		return
	end

	self.m_nDrawToolType = nIndex
	self:updateDrawgBtn()
	self:_playAni(1, true)
end

--@brief 	点击选择数量按钮回调
function WndFlyKites:onClickSwitchNum(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	self.m_nDrawNumType = self.m_nDrawNumType % 2 + 1

	self:updateDrawgBtn()
end

--@brief 	更新许愿按钮
function WndFlyKites:updateDrawgBtn()
	local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId1)
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

	local txtUseTool = GetElement(self.m_root,"txtUseTool1",WZUILabelTTF)
	local strDraw = string.format(LocalStrings.FLYKITES_TEXT1[3], nTimes)
	if freeCount == 1 then
		if self.m_nDrawNumType == 1 then
			strDraw = LocalStrings.FLYKITES_TEXT1[2]
		elseif self.m_nDrawNumType == 2 then
			if nTempTimes == 0 then
				strDraw = string.format(LocalStrings.FLYKITES_TEXT1[3], self.m_tDrawNumList[self.m_nDrawNumType])
			end
		end
	end
	txtUseTool:setText(strDraw)
end


--@brief 	设置待机特效
function WndFlyKites:_showAnimal()
	local spinePath = "activity/hd_pic_fengzheng"
	local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".json")
	if existSpine then
		local spineBG = GetElement(self.m_root, "spineBg", WZUISpine)
		if spineBG then 
			spineBG:setFileJson(spinePath .. ".json")
			spineBG:setFileAtlas(spinePath .. ".atlas")
			spineBG:play("wait", true)
		end

		local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
		if spineOpen then
			spineOpen:setFileJson(spinePath .. ".json") 
			spineOpen:setFileAtlas(spinePath .. ".atlas")
			self:_playAni(0, false)
		end

		local spineCopy = GetElement(self.m_root, "spineCopy", WZUISpine)
		if spineCopy then
			spineCopy:setFileJson(spinePath .. ".json") 
			spineCopy:setFileAtlas(spinePath .. ".atlas")
			self:_playOtherAni(0, false)
		end
	else
		local _sIndex = "hd_pic_fengzheng"
		local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
		if downloadInfo then 
			DownloadManager:addDownloadTask(7092, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndFlyKites)
		end
	end

	local spinePath2 = "activity/ui_tq_lihe"
	local existSpine2 = WZDataFile:getInstance():checkFileExist(spinePath2 .. ".json")
	if existSpine2 then 
		for i = 1, 6 do
			local spineScoreBox = GetElement(self.m_root, "spineScoreBox" .. i, WZUISpine)
			if spineScoreBox then 
				spineScoreBox:setFileJson(spinePath2 .. ".json")
				spineScoreBox:setFileAtlas(spinePath2 .. ".atlas")
			end
		end
	else
		local _sIndex = "ui_tq_lihe"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(70921, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndFlyKites)
        end
	end
end

function WndFlyKites:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndFlyKites:downloadEffectCallback",taskId,extraData,failed)
    self:_showAnimal()
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndFlyKites:_playAni(aniIndex, bLoop)
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

--@brief 	显示开启动画
function WndFlyKites:showOpenAction()
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)

	local spinePath1 = "activity/hd_pic_fengzheng"
	local existSpine1 = WZDataFile:getInstance():checkFileExist(spinePath1 .. ".json")

	if spineOpen then 
		if existSpine1 then
			local aniIndex = self.m_nAniType + 1 
			self:_playAni(aniIndex, false)
			local nSeconds = 50/DEFAULT_FPS
			spineOpen:enableSchedule("showShootReward", nSeconds)
		else
			self:showShootReward()
		end
	end
end

--@brief 	显示开启奖励
function WndFlyKites:showShootReward()
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	spineOpen:disableSchedule()
	self:_playAni(1, true)

	local strContent = ""
	if self.m_tOpenResult.addScore and self.m_tOpenResult.addScore > 0 then
		strContent = strContent .. LocalStrings.FLYKITES_TEXT1[19] .. "+" .. self.m_tOpenResult.addScore .. "    "
	end
	if strContent ~= "" then
		MsgBoxManager:showTipBox(strContent, nil, nil, nil, nil, nil, nil, nil, nil, GlobalMethod:ccp(0.5, 0.77))
	end

	self:setOpenState(false)
	self:_afterCloseReward()
end


--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndFlyKites:_playOtherAni(aniIndex, bLoop)
	local spineCopy = GetElement(self.m_root, "spineCopy", WZUISpine)
	aniIndex = aniIndex or 0
	if aniIndex == 0 then
		spineCopy:setVisible(false)
		return
	end
	spineCopy:setVisible(true)
	bLoop = bLoop == true and true or false

	if spineCopy then
		spineCopy:play(self.m_tClipAniOtherName[self.m_nTravelBtnStatus][aniIndex], bLoop)
	end
end

--@brief 	显示开启动画
function WndFlyKites:showShootPageReward()
	local spineCopy = GetElement(self.m_root, "spineCopy", WZUISpine)

	local spinePath1 = "activity/hd_pic_fengzheng"
	local existSpine1 = WZDataFile:getInstance():checkFileExist(spinePath1 .. ".json")

	if spineCopy then 
		if existSpine1 then
			self:_playOtherAni(2, false)
			local nSeconds = 50/DEFAULT_FPS
			spineCopy:enableSchedule("showShootOtherReward", nSeconds)
		else
			self:showShootOtherReward()
		end
	end
end

--@brief 	显示开启奖励
function WndFlyKites:showShootOtherReward()
	local spineCopy = GetElement(self.m_root, "spineCopy", WZUISpine)
	spineCopy:disableSchedule()
	self:_playOtherAni(3, true)

	local strContent = ""
	if self.m_tOpenResult.tourCityNum and self.m_tOpenResult.tourCityNum > 0 then
		strContent = strContent .. LocalStrings.FLYKITES_TEXT1[23] .. "+" .. self.m_tOpenResult.tourCityNum .. "    "
	end
	if strContent ~= "" then
		MsgBoxManager:showTipBox(strContent, nil, nil, nil, nil, nil, nil, nil, nil, GlobalMethod:ccp(0.5, 0.77))
	end

	self:setOpenPageState(false)
	self:_afterClosePageReward()
end



--@brief 	点击"自选奖励"按钮回调
function WndFlyKites:onClickChoosePrize(element)
	local eleType = type(element)
	if eleType ~= "number" then 
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	end

	self.m_bIsOpenReward = true 

	self.m_tGetTimes = {}
	self.m_tBigRewardList = {}

	local tData1 = {pool = 0}
	local tData2 = {pool = 1}
	local tData3 = {pool = 2}
	local strJson1 = json.encode(tData1)
	local strJson2 = json.encode(tData2)
	local strJson3 = json.encode(tData3)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson1)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson2)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson3)
end

--@brief 	点击许愿按钮回调
function WndFlyKites:onClickUseTool(element)
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
		self:saveOperateTimes()
		return 
	end

	local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId1)
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
	if nCostNum - freeCount > nArrowNum or self.m_nAniType == 2 and nArrowNum == 0 then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId1]
		MsgBoxManager:showConfirmBox(string.format(LocalStrings.WATERCOUNTRY_TEXT4, basicData.name), self, self.goToBuy)
		return 
	end

	self.m_nTempTimes = nTimes

	self:setOpenState(true)

	local tData = {}
	tData.times = self.m_tDrawNumList[self.m_nDrawNumType]
	tData.pool = self.m_nDrawToolType
	local stringData = json.encode(tData)

	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 3, stringData)
end

--@brief 	前往小推车购买
function WndFlyKites:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

--@brief 	点击按钮回调
function WndFlyKites:onClickOperateBtn(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nTag = element:getTag()
	if nTag == 1 then
		CellNewYearTask:showInterface(39, self.m_nActivityId)
	elseif nTag == 2 then --旅行奖励
		if self.m_nGiftRewardNum >= 1 then
			if CacheCenter:getRemainAmount() <= 0 then --背包已满提示
				MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
				return
			end

			ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 8, "")
		else
			MsgBoxManager:showTipBox(LocalStrings.FLYKITES_TEXT1[14])
		end
	elseif nTag == 3 then
		WndShopRank:showInterface(57, self.m_nActivityId)
	elseif nTag == 4 then
		GetElement(self.m_root,"conCityMain",WZUIContainer):setVisible(true)
	elseif nTag == 5 then -- 开始旅行 加速旅行
		if CacheCenter:getRemainAmount() <= 0 then --背包已满提示
			MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
			return
		end

		if self.m_nTourTime[1] == 0 then
			self.m_nTravelBtnStatus = 1
		else
			self.m_nTravelBtnStatus = 2
		end

		if self.m_nTravelBtnStatus == 1 then
			if self.m_tContent.tourConfig[1] ~= -1 and self.m_nTourNum >= self.m_tContent.tourConfig[1] then
				MsgBoxManager:showTipBox(LocalStrings.FLYKITES_TEXT1[25])
				return
			end
		elseif self.m_nTravelBtnStatus == 2 then
			if self.m_tContent.speedConfig[1] ~= -1 and self.m_nSpeedNum >= self.m_tContent.speedConfig[1] then
				MsgBoxManager:showTipBox(LocalStrings.FLYKITES_TEXT1[28])
				return
			end
		end

		local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId1)
		if self.m_nTravelBtnStatus == 1 and nArrowNum < self.m_nFinishCondition[3] or self.m_nTravelBtnStatus == 2 and nArrowNum < self.m_nFinishCondition[4] then 
			local basicData = GDatatab_item["id_" .. self.m_nCoinId1]
			MsgBoxManager:showConfirmBox(string.format(LocalStrings.WATERCOUNTRY_TEXT4, basicData.name), self, self.goToBuy)
			return
		end

		self:setOpenPageState(true)

		local tData = {}
		tData.id = self.m_nTravelBtnStatus
		local stringData = json.encode(tData)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 7, stringData)
	end
end

--@brief 	成熟度
function WndFlyKites:_showProgress()
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
			if self.m_tScoreConfig[i].status == -1 then
				GetElement(self.m_root, "spineScoreBox" .. i, WZUISpine):play("wait" .. i, true)
				GetElement(self.m_root, "imgScoreYlq" .. i, WZUIImage):setVisible(false)
			elseif self.m_tScoreConfig[i].status == 0 then 
				GetElement(self.m_root, "spineScoreBox" .. i, WZUISpine):play("wait1_" .. i, true)
				GetElement(self.m_root, "imgScoreYlq" .. i, WZUIImage):setVisible(false)
			elseif self.m_tScoreConfig[i].status == 1 then
				GetElement(self.m_root, "spineScoreBox" .. i, WZUISpine):play("wait" .. i, true)
				GetElement(self.m_root, "imgScoreYlq" .. i, WZUIImage):setVisible(true)
			end

	    	self.m_tScoreConfig[i].lastStatus = self.m_tScoreConfig[i].status
	    end
    end
end

--@brief 	设置步数积分宝箱数量
function WndFlyKites:_showStepScoreNum()
	for i = 1, 6 do
		local txtScore = GetElement(self.m_root, "txtScore"..i, WZUILabelTTF)
		txtScore:setText(self.m_tScoreConfig[i].scoreTarget)
	end
end

--@brief 	点击积分宝箱回调
function WndFlyKites:onClickScoreBox(element)
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
        local conLeftScore = GetElement(self.m_root, "conLeftScore", WZUIContainer)
        WndNewTipsReward:showInterface(conLeftScore, element, data, false, GlobalMethod:ccp(8.7, 0.2))
	end
end


--@brief 	点击打开旅行足迹界面
function WndFlyKites:onClickCityClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	GetElement(self.m_root,"conCityMain",WZUIContainer):setVisible(false)
end

--@brief 	点击打开旅行足迹界面
function WndFlyKites:updateCityFoot()
	if not self.m_tCityRewardStatus and not self.m_tContent then
		return
	end

	self.m_tCityObj = {}
	local tbCity = GetElement(self.m_root,"tbCity_WndFlyKites",WZUITableContainer)
	tbCity:cleanTable()
	for i=1,#self.m_tContent.cityConfig do
		local tData = {}
		tData.m_nIndex = i
		tData.activityId = self.m_nActivityId
		tData.cityScore = self.m_tCityScore
		tData.cityConfig = self.m_tContent.cityConfig[i]
		tData.cityRewards = self.m_tContent.cityRewards[i]
		tData.cityRewardStatus = self.m_tCityRewardStatus[i]
		tData.cityNamesConfig = self.m_tContent.cityNamesConfig[i]

		local element,tNewObj = CellFlyKites:createElement()
		element:setTag(i-1)
		tNewObj:setData(tData)
		tbCity:setCellElement(element)

		table.insert(self.m_tCityObj, tNewObj)
	end
end

--@brief 	点击打开风筝旅行信息
function WndFlyKites:updateTravelInfo()
	local txtOperateTime = GetElement(self.m_root,"txtOperateTime",WZUILabelTTF)
	txtOperateTime:disableSchedule()
	txtOperateTime:enableSchedule("_updateTravelTimeSchedule",1)

	if self.m_nTourTime[1] == 0 then --未旅行
		GetElement(self.m_root,"btnOperate5",WZUIButton):setTouchEnable(true)
		GetElement(self.m_root,"txtOperateBtn5_1",WZUILabelTTF):setText(LocalStrings.FLYKITES_TEXT1[15])
		GetElement(self.m_root,"txtOperateBtn5_2",WZUILabelTTF):setText(LocalStrings.FLYKITES_TEXT1[15])
		GetElement(self.m_root,"txtOperateBtn5_3",WZUILabelTTF):setText(LocalStrings.FLYKITES_TEXT1[15])
	else
		if self.m_tContent.speedConfig[1] ~= -1 and self.m_nSpeedNum >= self.m_tContent.speedConfig[1] then --已达加速
			GetElement(self.m_root,"btnOperate5",WZUIButton):setTouchEnable(false)
			GetElement(self.m_root,"txtOperateBtn5_1",WZUILabelTTF):setText(LocalStrings.FLYKITES_TEXT1[21])
			GetElement(self.m_root,"txtOperateBtn5_2",WZUILabelTTF):setText(LocalStrings.FLYKITES_TEXT1[21])
			GetElement(self.m_root,"txtOperateBtn5_3",WZUILabelTTF):setText(LocalStrings.FLYKITES_TEXT1[21])
		else
			GetElement(self.m_root,"btnOperate5",WZUIButton):setTouchEnable(true)
			GetElement(self.m_root,"txtOperateBtn5_1",WZUILabelTTF):setText(LocalStrings.FLYKITES_TEXT1[20])
			GetElement(self.m_root,"txtOperateBtn5_2",WZUILabelTTF):setText(LocalStrings.FLYKITES_TEXT1[20])
			GetElement(self.m_root,"txtOperateBtn5_3",WZUILabelTTF):setText(LocalStrings.FLYKITES_TEXT1[20])
		end
	end

	--特效
	if self.m_bOpenPageState ~= true then
		if self.m_nTourTime[1] ~= 0 then
			if self.m_nTourTime[2] <= 0 then
				self.m_nTravelBtnStatus = 1
			else
				self.m_nTravelBtnStatus = 2
			end
			self:_playOtherAni(3, true)
		else
			self:_playOtherAni(0, false)
		end
	end

end

--@brief 	旅行加速计时器
function WndFlyKites:_updateTravelTimeSchedule(element)
	local txtOperateTime = GetElement(self.m_root,"txtOperateTime",WZUILabelTTF)
	txtOperateTime:setText("")

	local conTalk = GetElement(self.m_root, "conTalk", WZUIContainer)
	conTalk:setVisible(false)
	if self.m_nTourTime[1] ~= 0 then
		local nTimes1 = math.floor(self.m_tContent.tourConfig[2] - (SystemTime:getServerTime() - self.m_nTourTime[1]) - self.m_nTourTime[2] + 0.5)
		local nTimes2 = math.ceil(nTimes1 / 60)
		local hours = math.floor(nTimes2/60)
		local minutes = math.floor(nTimes2 % 60)
		local strTime1 = hours..LocalStrings.HOUR..minutes..LocalStrings.MINUTE
		if hours == 0 then
			strTime1 = minutes..LocalStrings.MINUTE
		end

		local speedCount = math.floor(self.m_nTourTime[2] / (self.m_tContent.tourConfig[2] * self.m_tContent.speedConfig[2] / 100) + 0.5) --加速次数
		local nRewardCD = math.floor(self.m_tContent.tourConfig[4] * (1 - self.m_tContent.speedConfig[2] / 100 * speedCount) + 0.5)
		local nTimes3 = nTimes1 % nRewardCD
		local nTimes4 = math.ceil(nTimes3 / 60)
		local hours = math.floor(nTimes4/60)
		local minutes = math.floor(nTimes4 % 60)
		local strTime2 = string.format(LocalStrings.FLYKITES_TEXT1[26], hours..LocalStrings.HOUR..minutes..LocalStrings.MINUTE)
		if hours == 0 then
			strTime2 = string.format(LocalStrings.FLYKITES_TEXT1[26], minutes..LocalStrings.MINUTE)
		end

		txtOperateTime:setText(LocalStrings.FLYKITES_TEXT1[24]..":"..strTime1.."("..strTime2..")")

		if self.m_nTourTime[2] ~= 0 then
			conTalk:setVisible(true)
		end

		--刷新奖励数量
		if nTimes3 == 0 then
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 1, "")
		end
	end
end

function WndFlyKites:onClickCityBg()
	WndItemInfo:onCloseClick()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


function WndFlyKites:_adaptIphoneX()
	if IsIphoneX() then
		GetElement(self.m_root, "conLeftScore", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.07,0.46))
	end
end



-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配模块Begin----------------------------------------

function WndFlyKites:_adaptLanguage_vn()
	GetElement(self.m_root,"txtUseTool1",WZUILabelTTF):setScale(0.75)
	GetElement(self.m_root,"txtOperateBtn5_1",WZUILabelTTF):setScale(0.75)
	GetElement(self.m_root,"txtOperateBtn5_2",WZUILabelTTF):setScale(0.75)
	GetElement(self.m_root,"txtOperateBtn5_3",WZUILabelTTF):setScale(0.75)
end

-------------------------------------语言适配模块End----------------------------------------

