--WndColdDrink.lua
--@brief	WndColdDrink的UI模块
--@date		2024/4/25
--@author	yrd
--@note		清凉冰饮活动主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndColdDrink:onEnter(element)
	self.m_root = element
	g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
	ProtocolProcessorFestivalActivity:regAll6()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
	GlobalGame:getGameEventDispathcer():Add(Independent_Activity.ActivityReddot, self.showRedDot, self)

	self:_initStaticText()
	self:_adaptIphoneX()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndColdDrink:onExit(element)
	g_bIsShowWndDressUp = true
    g_tTempItemForLaterShow = {}
	CacheCenter:unregisterUpatePlayerItemObserver(self)
	ProtocolProcessorFestivalActivity:unregAll6()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
	GlobalGame:getGameEventDispathcer():Remove(Independent_Activity.ActivityReddot, self.showRedDot, self)
	if self.m_root then 
		self.m_root:disableSchedule()
	end

	self:_unInit()
	LoadNewActivityRes(false)
end

--@brief    onenter函数已执行
function WndColdDrink:onEnterTransitionDidFinish(element)
    WZLog("WndColdDrink:onEnterTransitionDidFinish")
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7124, 7124)
end

--@brief    关闭窗口
function WndColdDrink:onCloseClick(element)
	local eleType = type(element)
	if eleType ~= "number" then 
    	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    end

	SaveActivityPoleType("POLETYPE_COLDDRINK", self.m_nCalabashType)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮回调
function WndColdDrink:onRuleClick(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSingleMapDesc:showInterface(LocalStrings.COLDDRINK_TEXT2)
end

--@brief 	点击目标按钮回调
function WndColdDrink:onClickTask(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if SystemTime:getServerTime() >= self.m_nEndTime then 
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END) 
		self:onCloseClick(0)
		return 
	end 

	local nTag = element:getTag()
	if nTag == 1 then 
		local otherData = {}
		otherData.taskCount = 3 --几个任务标签
		otherData.tTaskTypeName = {LocalStrings.COLDDRINK_TEXT1[9], LocalStrings.COLDDRINK_TEXT1[10], LocalStrings.COLDDRINK_TEXT1[11]}
		otherData.titleList = otherData.tTaskTypeName
		otherData.taskType = 1
		otherData.redPoint = {227124, 217124, 237124} --长线；日常；每天
		CellNewYearTask:showInterface(60, self.m_nActivityId, otherData)
	elseif nTag == 2 then
		local otherData = {}
		otherData.title = LocalStrings.COLDDRINK_TEXT1[8]
		otherData.doType_get = 7
		otherData.doType_buy = 8
		otherData.showBuyReward = true 
		otherData.coinId = self.m_nCoinId2
		otherData.chipPt = GlobalMethod:ccp(0.034,0.95) 
		WndDollMachineShop:showInterface(90, self.m_nActivityId, otherData)
	elseif nTag == 3 then
		local otherData = {}
		otherData.type = 1
		otherData.strRankTitleName = LocalStrings.COLDDRINK_TEXT1[3]
		otherData.strChangeTitle = LocalStrings.COLDDRINK_TEXT1[4]
		otherData.strScoreTitle = LocalStrings.COLDDRINK_TEXT1[5] .. ":"
		WndShopRank:showInterface(90, self.m_nActivityId, nil, nil, otherData)
	elseif nTag == 4 then
		if self.m_nGiftRewardNum >= 1 then
			if CacheCenter:getRemainAmount() <= 0 then --背包已满提示
				MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
				return
			end
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 5, "")
		else
			local tData = {}
			tData.txtTitle = string.format(LocalStrings.COLDDRINK_TEXT1[19], self.m_tContent.globalConfig[1])
			tData.nType = 2
			WndTips:show(element, self.m_root, 52, tData, GlobalMethod:ccp(300,80), true)
		end
	end
end

--@brief 	点击大奖预览按钮回调
function WndColdDrink:onClickBigReward(element)
	if SystemTime:getServerTime() >= self.m_nEndTime then 
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END) 
		self:onCloseClick(0)
		return 
	end 
	local eleType = type(element)
	if eleType ~= "number" then 
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	end

	self.m_tGetTimes = {}
	self.m_tBigRewardList = {}
	self.m_bIsOpenReward = true 
	local tData = {pool = 0}
	local tData2 = {pool = 1}
	local tData3 = {pool = 2}
	
	local strJson = json.encode(tData)
	local strJson2 = json.encode(tData2)
	local strJson3 = json.encode(tData3)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson2)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson3)
end


--@brief 	点击开启按钮回调
function WndColdDrink:onClickFive(element) 
	if SystemTime:getServerTime() >= self.m_nEndTime then 
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END) 
		self:onCloseClick(0)
		return 
	end 
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	--背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
    if self.m_bOpenState then
    	return
    end 
    if self.m_nChooseReward == 0 then 
    	self:onClickBigReward(0)

		self.m_nChooseReward = 1
		SaveOperateTimes("OPERATETIMES_COLDDRINK", self.m_nActivityId)
    	return 
    end

    self.m_nAniType = 1
	local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local nTempTimes = math.floor(nArrowNum/self.m_tCostByType[self.m_nCalabashType + 1])
	local nTimes = nTag
	local freeCount = 0
	if self.m_nCalabashType == 0 then 
		freeCount = self.m_nCount > 0 and 1 or 0 
	end
	if nTag == 5 then 
		self.m_nAniType = 2
		nTag = self.m_nMaxLotteryCount 
		nTimes = (nTempTimes + freeCount) >= self.m_nMaxLotteryCount and self.m_nMaxLotteryCount or nTempTimes > 0 and (nTempTimes + freeCount) or self.m_nMaxLotteryCount 
	end
	local nCostNum = nTimes
	nCostNum = nTimes * self.m_tCostByType[self.m_nCalabashType + 1]
	if nCostNum - freeCount > nArrowNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		MsgBoxManager:showConfirmBox(string.format(LocalStrings.WATERCOUNTRY_TEXT4, basicData.name), self, self.goToBuy)
		return 
	end

    local tData = {}
	tData.times = nTag
	tData.pool = self.m_nCalabashType

	local stringData = json.encode(tData)

	self:setOpenState(true)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 3, stringData)
end

--@brief 	前往小推车购买
function WndColdDrink:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        -- WndActivityPropsGift:showInterface(self.m_nCoinId)
        WndApartmentAct:showInterface()
    end
end

--@brief 	点击切换浪板类型
function WndColdDrink:onChooseTool(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local nTag = element:getTag()
	if self.m_bOpenState then 
		GetElement(self.m_root, "cbgTool_WndColdDrink", WZUICheckBoxGroup):setCheckIndex(self.m_nCalabashType)
		return 
	end 
	if self.m_nCalabashType == nTag then return end 

	self.m_nCalabashType = nTag
	self:_setFreeBtnText()
	local spineWait2 = GetElement(self.m_root, "spineWait2", WZUISpine)
	if spineWait2 then 
		spineWait2:play(self.m_tWaitAniName[self.m_nCalabashType + 1], true)
	end
end

--@brief	点击物品弹出对应的tips
function WndColdDrink:onItemClick(tCell,tag,tData)
    if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData,false)
end

--@brief 	点击等级奖励按钮回调、
function WndColdDrink:onClickLvReward(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	GetElement(self.m_root, "conLvReward_WndColdDrink", WZUIContainer):setVisible(true)
	self:_createLvRewardList()
end

--@brief 	关闭捕鼠奖励界面
function WndColdDrink:onCloseTip(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	GetElement(self.m_root, "conLvReward_WndColdDrink", WZUIContainer):setVisible(false)
	self:showRedDot()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndColdDrink:_update()
	-- body
	self:_setFreeBtnText()
	self:showRedDot()
	self:_initActivityTime()
    self:_updateLightNum()
end

--@brief 	初始化静态文本
function WndColdDrink:_initStaticText()
	self.m_nCalabashType = GetActivityPoleType("POLETYPE_COLDDRINK") or 0
	GetElement(self.m_root, "cbgTool_WndColdDrink", WZUICheckBoxGroup):setCheckIndex(self.m_nCalabashType)
	local spineWait2 = GetElement(self.m_root, "spineWait2", WZUISpine)
	if spineWait2 then 
		spineWait2:play(self.m_tWaitAniName[self.m_nCalabashType + 1], true)
	end

	GetElement(self.m_root, "txtOperateBtn1", WZUILabelTTF):setText(LocalStrings.COLDDRINK_TEXT1[2])
	GetElement(self.m_root, "txtOperateBtn2", WZUILabelTTF):setText(LocalStrings.COLDDRINK_TEXT1[8])
	GetElement(self.m_root, "txtOperateBtn3", WZUILabelTTF):setText(LocalStrings.COLDDRINK_TEXT1[3])
	GetElement(self.m_root, "txtOperateBtn4", WZUILabelTTF):setText(LocalStrings.COLDDRINK_TEXT1[23])
	GetElement(self.m_root, "txtBigReward_WndColdDrink", WZUILabelTTF):setText(LocalStrings.WATERMELON_TEXT1[22])
	GetElement(self.m_root, "txtLvRewardT_WndColdDrink", WZUILabelTTF):setText(LocalStrings.COLDDRINK_TEXT1[15])
	GetElement(self.m_root, "txtEggAtt_WndColdDrink", WZUILabelTTF):setText(LocalStrings.COLDDRINK_TEXT1[22])

	self:_setBallAni()
end

--@brief 	红点
function WndColdDrink:showRedDot()
	-- body
	if self.m_root == nil then return end 

	local imgTaskRedDot = GetElement(self.m_root, "imgTaskRedDot_WndColdDrink", WZUIImage)
	local imgExpReddot = GetElement(self.m_root, "imgExpReddot_WndColdDrink", WZUIImage)

	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[217124] or GlobalGame.g_tRedPointTypeList[227124] or GlobalGame.g_tRedPointTypeList[237124]) then 
		imgTaskRedDot:setVisible(true)
	else
		imgTaskRedDot:setVisible(false)
	end

	local bHaveRedDot = false 
	if self.m_tLvRewardList then 
		for i = 1, #self.m_tLvRewardList do
			if self.m_tLvRewardList[i].status == 1 then 
				bHaveRedDot = true 
				break 
			end
		end
	end

	imgExpReddot:setVisible(bHaveRedDot)
end

--@brief 	刷新全民礼包的红点
function WndColdDrink:showBagGiftInfo()
	if self.m_nGiftRewardNum > 0 then 
		GetElement(self.m_root, "imgGiftRed", WZUIImage):setVisible(true)
		GetElement(self.m_root, "txtGiftNum", WZUILabelTTF):setText(self.m_nGiftRewardNum)
	else
		GetElement(self.m_root, "imgGiftRed", WZUIImage):setVisible(false)
	end
end


--@brief 	更新异火的数量
function WndColdDrink:_updateLightNum()
	-- body
	local ftxtLightNum = GetElement(self.m_root, "ftxtLightNum_WndColdDrink", WZUIFreeTextBox)
	local sFormat = [[<I Z="0.4" P="1">%s</I><T C="255,255,255" S="16" P="1" SC="132,66,29" SS="4" SE="1">%d</T>]]
	if ftxtLightNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
		ftxtLightNum:setShowText(string.format(sFormat, basicData.icon, nLightNum))
	end
end

--@brief 	初始化活动时间
function WndColdDrink:_initActivityTime()
	-- body
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local strFormat = "%02d.%02d %02d:%02d - %02d.%02d %02d:%02d"
    local needDay_str = string.format(strFormat, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndColdDrink", WZUILabelTTF)
    if txtActivityTime then 
    	txtActivityTime:setText(needDay_str)
    end
end

--@brief 	显示开启动画
function WndColdDrink:showOpenAction()
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	local spinePath1 = "activity/hd_pic_bingying_s"
	local existSpine1 = WZDataFile:getInstance():checkFileExist(spinePath1 .. ".json")
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

--@brief 	显示开启奖励 处理抽奖时人物人物会闪一下问题
function WndColdDrink:showShootBefore()
	self:_playAni(0)
	local nSeconds = 2
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	spineOpen:disableSchedule()
	spineOpen:enableSchedule("showShootReward", nSeconds)
end

--@brief 	显示开启奖励
function WndColdDrink:showShootReward()
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	spineOpen:disableSchedule()
	self:_playAni(1, true)
	self:_playAnotherAni(0)

	local strContent = ""
	if self.m_tOpenResult.addExp and self.m_tOpenResult.addExp > 0 then 
		strContent = strContent .. LocalStrings.COLDDRINK_TEXT1[18] .. "+" .. self.m_tOpenResult.addExp .. "    "
	end
	if self.m_tOpenResult.addCoin and self.m_tOpenResult.addCoin > 0 then 
		strContent = strContent .. LocalStrings.COLDDRINK_TEXT1[24] .. "+" .. self.m_tOpenResult.addCoin .. " "
	end
	if strContent ~= "" then 
		MsgBoxManager:showTipBox(strContent, nil, nil, nil, nil, nil, nil, nil, nil, GlobalMethod:ccp(0.5, 0.77))
	end

	self:setOpenState(false)
	self:_afterCloseReward()
end

--@brief 	设置免费丢
function WndColdDrink:_setFreeBtnText()
	local txtBtnOpenOne = GetElement(self.m_root, "txtBtnOpenOne_WndColdDrink", WZUILabelTTF)
	local txtBtnOpenFive = GetElement(self.m_root, "txtBtnOpenFive_WndColdDrink", WZUILabelTTF)

	local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local freeTimes = 0 
	local nTempTimes = math.floor(nLightNum/self.m_tCostByType[self.m_nCalabashType + 1])
	local nTimes = 0

	local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local freeTimes = 0 
	local nTempTimes = math.floor(nLightNum/self.m_tCostByType[self.m_nCalabashType + 1])
	local nTimes = 0
	local strTemp = LocalStrings.COLDDRINK_TEXT1[7]
	if self.m_nCalabashType == 0 then 
		if self.m_nCount > 0 then 
			freeTimes = 1
			txtBtnOpenOne:setText(LocalStrings.COLDDRINK_TEXT1[6])
		else 
			txtBtnOpenOne:setText(string.format(strTemp, 1))
		end
	else
		txtBtnOpenOne:setText(string.format(strTemp, 1))
	end
	nTimes = (nTempTimes + freeTimes) >= self.m_nMaxLotteryCount and self.m_nMaxLotteryCount or nTempTimes > 0 and (nTempTimes + freeTimes) or self.m_nMaxLotteryCount 
	txtBtnOpenFive:setText(string.format(strTemp, nTimes))
end

--@brief 	设置待机特效
function WndColdDrink:_setBallAni()
	local spinePath = "activity/hd_pic_bingying_x"
	local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".json")
	if existSpine then 
		local spineWait = GetElement(self.m_root, "spineWait", WZUISpine)
		if spineWait then 
			spineWait:setFileJson(spinePath .. ".json")
			spineWait:setFileAtlas(spinePath .. ".atlas")
			spineWait:play("daiji1", true)
		end
	else
		local _sIndex = "hd_pic_bingying_x"
		local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
		if downloadInfo then 
			DownloadManager:addDownloadTask(7124, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndColdDrink)
		end
	end

	local spinePath = "activity/hd_pic_bingying_s"
	local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".json")
	if existSpine then 
		local spineWait2 = GetElement(self.m_root, "spineWait2", WZUISpine)
		if spineWait2 then 
			spineWait2:setFileJson(spinePath .. ".json")
			spineWait2:setFileAtlas(spinePath .. ".atlas")
		end
		local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
		if spineOpen then 
			spineOpen:setFileJson(spinePath .. ".json")
			spineOpen:setFileAtlas(spinePath .. ".atlas")
		end
		local spineCopy = GetElement(self.m_root, "spineCopy", WZUISpine)
		if spineCopy then 
			spineCopy:setFileJson(spinePath .. ".json")
			spineCopy:setFileAtlas(spinePath .. ".atlas")
		end
	else
		local _sIndex = "hd_pic_bingying_s"
		local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
		if downloadInfo then 
			DownloadManager:addDownloadTask(71240, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndColdDrink)
		end
	end
end

function WndColdDrink:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndColdDrink:downloadEffectCallback",taskId,extraData,failed)
    self:_setBallAni()
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndColdDrink:_playAni(aniIndex, bLoop)
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	aniIndex = aniIndex or 0
	if aniIndex == 0 then
		spineOpen:setVisible(false)
		return
	end
	spineOpen:setVisible(true)
	bLoop = bLoop == true and true or false

	if spineOpen then 
		spineOpen:play(self.m_tBallAniName[self.m_nCalabashType + 1][aniIndex], bLoop)
	end
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndColdDrink:_playAnotherAni(aniIndex, bLoop)
	local spineCopy = GetElement(self.m_root, "spineCopy", WZUISpine)
	aniIndex = aniIndex or 0
	if aniIndex == 0 then
		spineCopy:setVisible(false)
		return
	end
	spineCopy:setVisible(true)
	bLoop = bLoop == true and true or false

	if spineCopy then 
		spineCopy:play(self.m_tBallAniName[self.m_nCalabashType + 1][aniIndex], bLoop)
	end
end

--@brief 	显示等级、经验
function WndColdDrink:_showLvAndExp()
	local txtLevel = GetElement(self.m_root, "txtLevel_WndColdDrink", WZUILabelTTF)
	local txtLvTitle = GetElement(self.m_root, "txtLvTitle_WndColdDrink", WZUILabelTTF)
	local txtExp = GetElement(self.m_root, "txtExp_WndColdDrink", WZUILabelTTF)
	local prgExp = GetElement(self.m_root, "prgExp_WndColdDrink", WZUIProgress)

	local tCurInfo, tNextInfo, nMaxLv = self:getCurLvInfo()
	local strLvTitle = LocalStrings.COLDDRINK_TEXT1[17][1]
	local nCurLevel = 0 
	if tCurInfo then 
		nCurLevel = tCurInfo.lv
		strLvTitle = tCurInfo.name 
	end
	txtLevel:setText(LocalStrings.LV .. nCurLevel)
	txtLvTitle:setText(strLvTitle)
	if tCurInfo and tCurInfo.lv >= nMaxLv then 
		txtExp:setText("Max")
	else
		txtExp:setText(self.m_nCurExp .. "/" .. tNextInfo.exp)
	end

	local nPercentage = math.floor(100 * self.m_nCurExp/tNextInfo.exp)
	if nPercentage > 100 then 
		nPercentage = 100
	end
	prgExp:setPercentage(nPercentage)
end

--@brief 	创建捕鼠奖励
function WndColdDrink:_createLvRewardList()
	local tbLvRewardList = GetElement(self.m_root, "tbLvRewardList_WndColdDrink", WZUITableContainer)
	tbLvRewardList:cleanTable()

	local otherData = {}
	otherData.opType = 6
	otherData.strExp = LocalStrings.COLDDRINK_TEXT1[15]
	otherData.exp = self.m_nCurExp
	otherData.tipsRoot = self.m_root
	otherData.rewardType = 2 --奖励类型：1={{id,num},{id,num},...};2={{id,id,num},{id,id,num},...};0="[id,id,num]&[id,id,num]&..."

	for i = 1, #self.m_tLvRewardList do
		local element, tNewObj = CellLvRewardItem:createElement()
		if element and tNewObj then
			element:setTag(i - 1)
			tNewObj:setData(self.m_tLvRewardList[i], 10, otherData)

			tbLvRewardList:setCellElement(element)
		end
	end
end

--@brief 	计时器
function WndColdDrink:_caculateTime()
	local conPaitedEgg = GetElement(self.m_root, "conPaitedEgg_WndColdDrink", WZUIContainer)
	local ftbEggTips = GetElement(self.m_root, "ftbEggTips_WndColdDrink", WZUIFreeTextBox)
	local txtEggAtt = GetElement(self.m_root, "txtEggAtt_WndColdDrink", WZUILabelTTF)
	local txtEggTime = GetElement(self.m_root, "txtEggTime_WndColdDrink", WZUILabelTTF)
	local nLeftTime = self.m_nDoubleEndTime - SystemTime:getServerTime()
	if nLeftTime < 0 then
		ftbEggTips:setVisible(true)
		local strFormat = [[]]
		ftbEggTips:setShowText(string.format(LocalStrings.COLDDRINK_TEXT1[21], self.m_tContent.doubleConfig[1] - self.m_nDoubleNum))

		txtEggAtt:setVisible(false)
		txtEggTime:setVisible(false)

		conPaitedEgg:disableSchedule()
	else
		ftbEggTips:setVisible(false)

		txtEggAtt:setVisible(true)
		txtEggTime:setVisible(true)
		
		local txtEggTime = GetElement(self.m_root, "txtEggTime_WndColdDrink", WZUILabelTTF)
		txtEggTime:setText(LocalStrings.COLDDRINK_TEXT1[20] .. nLeftTime .. "S")
	end
end

--@brief 	设置倒计时
function WndColdDrink:_showPaintedEgg()
	self:_caculateTime()

	local conPaitedEgg = GetElement(self.m_root, "conPaitedEgg_WndColdDrink", WZUIContainer)
	local nLeftTime = self.m_nDoubleEndTime - SystemTime:getServerTime()
	if nLeftTime > 0 then
		conPaitedEgg:disableSchedule()
		conPaitedEgg:enableSchedule("_caculateTime", 1)
	end
end
-------------------------------------私有方法模块End----------------------------------------


--@brief 	iphoneX适配
function WndColdDrink:_adaptIphoneX()
	if IsIphoneX() then

	end
end


-------------------------------------语言适配Begin----------------------------------------

function WndColdDrink:_adaptLanguage_vn()
	GetElement(self.m_root, "txtActivityTime_WndColdDrink", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,0.94))
	GetElement(self.m_root, "txtBigReward_WndColdDrink", WZUILabelTTF):setScale(0.7)

	GetElement(self.m_root, "txtEggAtt_WndColdDrink", WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root, "txtEggTime_WndColdDrink", WZUILabelTTF):setScale(0.8)
	local ftbEggTips = GetElement(self.m_root, "ftbEggTips_WndColdDrink", WZUIFreeTextBox)
	ftbEggTips:setScale(0.7)
	ftbEggTips:setMaxWidth(150)

	local txtLvTitle = GetElement(self.m_root, "txtLvTitle_WndColdDrink", WZUILabelTTF)
	txtLvTitle:setScale(0.7)
	txtLvTitle:setDimensions(GlobalMethod:CCSize(100))

	GetElement(self.m_root, "txtBtnOpenOne_WndColdDrink", WZUILabelTTF):setFontSize(24)
	GetElement(self.m_root, "txtBtnOpenFive_WndColdDrink", WZUILabelTTF):setFontSize(24)
end

-------------------------------------语言适配End----------------------------------------