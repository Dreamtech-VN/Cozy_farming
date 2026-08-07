--WndSeafarRoad.lua
--@brief	WndSeafarRoad的UI模块
--@date		2023/04/10
--@author	XTX
--@note		航海之路活动主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSeafarRoad:onEnter(element)
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
function WndSeafarRoad:onExit(element)
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
function WndSeafarRoad:onEnterTransitionDidFinish(element)
    WZLog("WndSeafarRoad:onEnterTransitionDidFinish")
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7072, 7072)
end

--@brief    关闭窗口
function WndSeafarRoad:onCloseClick(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    local nTag = element:getTag()
    if nTag == 2 then 
    	GetElement(self.m_root, "conSeaGod_WndSeafarRoad", WZUIContainer):setVisible(false)
    else 
	    --如果是自动弹出的活动界面
	    WindowManager:removeWindow(self.m_root, self, true)
	end
end

--@brief    点击规则按钮回调
function WndSeafarRoad:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 
    WndSingleMapDesc:showInterface1(LocalStrings.SEAFARROAD_TEXT2) 
end

--@brief 	点击目标按钮回调
function WndSeafarRoad:onClickTask(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if nTag == 1 then 
		CellNewYearTask:showInterface(25, self.m_nActivityId)
	elseif nTag == 2 then 
		WndShopRank:showInterface(42, self.m_nActivityId) 
	elseif nTag == 3 then --成神之路
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 5, "")
		GetElement(self.m_root, "conSeaGod_WndSeafarRoad", WZUIContainer):setVisible(true)
	elseif nTag == 4 then 
		self:onClickGift(element)
	end
end

--@brief 	点击大奖预览按钮回调
function WndSeafarRoad:onClickBigReward(element)
	-- body
	local eleType = type(element)
	if eleType ~= "number" then 
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	end

	self.m_tGetTimes = {}
	self.m_bIsOpenReward = true
	local tData = {pool = 1}
	local tData2 = {pool = 2}
	local strJson = json.encode(tData)
	local strJson2 = json.encode(tData2)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson2)
end

--@brief 	点击开启按钮回调
function WndSeafarRoad:onClickFive(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	--背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
    if self.m_bOpenState then return end 
    if self.m_nChooseReward == 0 then 
    	self:onClickBigReward(0)

		self.m_nChooseReward = 1
		SaveOperateTimes("SEAFARROADACTIVITYID", self.m_nActivityId)
    	return 
    end

	local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local nTempTimes = nArrowNum
	local nTimes = nTag
	local freeCount = 0
	if self.m_nPirate == 0 then 
		freeCount = self.m_nCount > 0 and 1 or 0 
	end
	if nTag == 5 then 
		nTag = self.m_nMaxLotteryCount 
		nTimes = (nTempTimes + freeCount) >= self.m_nMaxLotteryCount and self.m_nMaxLotteryCount or nTempTimes > 0 and (nTempTimes + freeCount) or self.m_nMaxLotteryCount 
	end
	local nCostNum = nTimes
	if nCostNum - freeCount > nArrowNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		MsgBoxManager:showConfirmBox(string.format(LocalStrings.WATERCOUNTRY_TEXT4, basicData.name), self, self.goToBuy)
		return 
	end

    local tData = {}
	tData.times = nTag

	local stringData = json.encode(tData)

	self:setOpenState(true)
	if self.m_nPirate == 1 then 
		self.m_bIsBeatPirate = true 
	end
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 3, stringData)
end

--@brief 	前往小推车购买
function WndSeafarRoad:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

--@brief 	点击赛事礼包按钮回调
function WndSeafarRoad:onClickGift(element)
	-- body
	if self.m_nGiftRewardNum >= 1 then
		--背包已满提示
	    if CacheCenter:getRemainAmount() <= 0 then
	        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
	        return
	    end
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 7, "")
	else
		local tData = {}
		tData.txtTitle = string.format(LocalStrings.SEAFARROAD_TEXT1[7], self.m_tContent.globalConfig[1])
		tData.nType = 2
		WndTips:show(element, self.m_root, 52, tData, GlobalMethod:ccp(50,80), true)
	end
end

--@brief 	点击积分宝箱回调
function WndSeafarRoad:onClickScoreBox(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if self.m_tScoreConfig[nTag].status == 0 then 
		--背包已满提示
	    if CacheCenter:getRemainAmount() <= 0 then
	        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
	        return
	    end
	    local tData = {}
	    tData.scoreType = nTag - 1
	    local strData = json.encode(tData)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 4, strData)
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
        local conLeftScore = GetElement(self.m_root, "conLeftScore_WndSeafarRoad", WZUIContainer)
        WndNewTipsReward:showInterface(conLeftScore, element, data, false, GlobalMethod:ccp(9.5, 0))
	end
end

--@brief 	点击步数宝箱回调
function WndSeafarRoad:onClickStepBox(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	
	local tData = self.m_tStepBoxConfig[nTag]
	local data = {}

    data.scale = 0.4
    local reward_id = {}
    local reward_num = {}
    for i = 1, #tData.rewardNor do
        table.insert(reward_id,  tData.rewardNor[i][1])
        table.insert(reward_num, tData.rewardNor[i][2])
    end
    if self.m_tIslandOccupyInfo and self.m_tIslandOccupyInfo[nTag].playerId ~= 0 then 
    	data.title = string.format(LocalStrings.SEAFARROAD_TEXT1[30], self.m_tIslandOccupyInfo[nTag].name)
    else
    	data.title = LocalStrings.SEAFARROAD_TEXT1[21]
    end
    data.titleFontSize = 18
    data.rewardIds = reward_id
    data.rewardNums = reward_num
    WndNewTipsReward:showInterface(self.m_root, element, data, true, GlobalMethod:ccp(0.61, 0.48))
end

--@brief 	点击传承按钮回调
function WndSeafarRoad:onClickInherit(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId2)
	if nLightNum >= 6 then 
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 6, "")
	end
end

--@brief 	点击占领文件头像回调
function WndSeafarRoad:onClickHead(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	WndCheckOther:show(self.m_tIslandOccupyInfo[nTag].playerId)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndSeafarRoad:_update()
	-- body
	self:_setFreeBtnText()
	self:showRedDot()
	self:_initActivityTime()
    self:_updateLightNum()
    self:_showStepScoreNum()
    self:_showPirate()
end

--@brief 	初始化静态文本
function WndSeafarRoad:_initStaticText()
	GetElement(self.m_root, "txtBtnTask1_WndSeafarRoad", WZUILabelTTF):setText(LocalStrings.SEAFARROAD_TEXT1[3])
	GetElement(self.m_root, "txtBtnTask2_WndSeafarRoad", WZUILabelTTF):setText(LocalStrings.SEAFARROAD_TEXT1[20])
	GetElement(self.m_root, "txtBtnTask3_WndSeafarRoad", WZUILabelTTF):setText(LocalStrings.SEAFARROAD_TEXT1[2])
	GetElement(self.m_root, "txtBtnTask4_WndSeafarRoad", WZUILabelTTF):setText(LocalStrings.SEAFARROAD_TEXT1[4])
	GetElement(self.m_root, "txtTypeName_WndSeafarRoad", WZUILabelTTF):setText(LocalStrings.SEAFARROAD_TEXT1[14])
	GetElement(self.m_root, "txtPirate_WndSeafarRoad", WZUILabelTTF):setText(LocalStrings.SEAFARROAD_TEXT1[23])
	GetElement(self.m_root, "txtStartDot_WndSeafarRoad", WZUILabelTTF):setText(LocalStrings.SEAFARROAD_TEXT1[24])
	GetElement(self.m_root, "txtEndDot_WndSeafarRoad", WZUILabelTTF):setText(LocalStrings.SEAFARROAD_TEXT1[25])
	GetElement(self.m_root, "txtStar_WndSeafarRoad", WZUILabelTTF):setText(LocalStrings.SEAFARROAD_TEXT1[18])
	GetElement(self.m_root, "txtInherit1_WndSeafarRoad", WZUILabelTTF):setText(LocalStrings.SEAFARROAD_TEXT1[26])
	GetElement(self.m_root, "txtInherit2_WndSeafarRoad", WZUILabelTTF):setText(LocalStrings.SEAFARROAD_TEXT1[26])
	GetElement(self.m_root, "txtInherit3_WndSeafarRoad", WZUILabelTTF):setText(LocalStrings.SEAFARROAD_TEXT1[26])
	GetElement(self.m_root, "txtStarAtt_WndSeafarRoad", WZUILabelTTF):setText(LocalStrings.SEAFARROAD_TEXT1[28])
	local imgCoinIcon = GetElement(self.m_root, "imgCoinIcon_WndSeafarRoad", WZUIImage)
	local coinInfo = GDatatab_item["id_" .. self.m_nCoinId2]
	imgCoinIcon:setFile(coinInfo.icon)

	self:_setBallAni()
end

--@brief 	红点
function WndSeafarRoad:showRedDot()
	-- body
	if self.m_root == nil then return end 

	local imgTaskRedDot = GetElement(self.m_root, "imgTaskRedDot_WndSeafarRoad", WZUIImage)

	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[217072] or GlobalGame.g_tRedPointTypeList[227072] or GlobalGame.g_tRedPointTypeList[237072]) then 
		imgTaskRedDot:setVisible(true)
	else
		imgTaskRedDot:setVisible(false)
	end
end

--@brief 	更新异火的数量
function WndSeafarRoad:_updateLightNum()
	-- body
	local ftxtLightNum = GetElement(self.m_root, "ftxtLightNum_WndSeafarRoad", WZUIFreeTextBox)
	local sFormat = [[<I Z="0.5" P="1">%s</I><T C="255,236,193" S="20" P="1" SC="132,66,29" SS="4" SE="0">%d</T>]]
	if ftxtLightNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
		ftxtLightNum:setShowText(string.format(sFormat, basicData.icon, nLightNum))
	end

	local txtCoinNum = GetElement(self.m_root, "txtCoinNum_WndSeafarRoad", WZUILabelTTF)
	local nCoinNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId2)
	txtCoinNum:setText(nCoinNum)
	local imgTaskRedDot2 = GetElement(self.m_root, "imgTaskRedDot2_WndSeafarRoad", WZUIImage)
	if nCoinNum >= 6 then
		imgTaskRedDot2:setVisible(true)
	else
		imgTaskRedDot2:setVisible(false)
	end
end

--@brief 	初始化活动时间
function WndSeafarRoad:_initActivityTime()
	-- body
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndSeafarRoad", WZUILabelTTF)
    if txtActivityTime then 
    	txtActivityTime:setText(LocalStrings.ACTIVITY_TIME_KEY .. ":" .. needDay_str)
    end
end

--@brief 	显示开启动画
function WndSeafarRoad:showOpenAction()
	-- body
	--创建选中特效
	local spinePath = "activity/hd_pic_chuan"
	local existSpine = CheckEffectFile(spinePath)
	if not existSpine then 
		local _sIndex = "hd_pic_chuan"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7065, downloadInfo.url, downloadInfo.md5, _sIndex, "DownloadResourceCallback", _G)
        end
	end
	if self.m_bIsBeatPirate then --击杀海盗
		local spinePath2 = "activity/hd_pic_chuangzhang"
		local existSpine2 = CheckEffectFile(spinePath)
		local spinePirate = GetElement(self.m_root, "spinePirate_WndSeafarRoad", WZUISpine)
		if spinePirate then 
			if existSpine2 then 
				self:_setBowlingPlayAni(2, true)
				self:_setBowlingPlayAni(3, false)
				spinePirate:enableSchedule("switchPirateAni", 0.5)
			else
				self:_setBowlingPlayAni(2, true)
				self:showShootReward()
			end
		end
	else
		local spineOpen = GetElement(self.m_root, "spineOpen_WndSeafarRoad", WZUISpine)
		if spineOpen then 
			if existSpine then 
				self:_setBowlingPlayAni(2, true)
			else
				self:showShootReward()
			end
		end
	end
end

--@brief 	切换海盗动作
function WndSeafarRoad:switchPirateAni()
	-- body
	if self.m_bIsBeatPirate then --击杀海盗
		local spinePirate = GetElement(self.m_root, "spinePirate_WndSeafarRoad", WZUISpine)
		spinePirate:disableSchedule()
		spinePirate:play("wait", true)

		self:_showPirate()
		self:_setFreeBtnText()
		self.m_bIsBeatPirate = false 
	end
end

--@brief 	显示开启奖励
function WndSeafarRoad:showShootReward()
	-- body
	if self.m_bIsBeatPirate then --击杀海盗
		local spinePirate = GetElement(self.m_root, "spinePirate_WndSeafarRoad", WZUISpine)
		spinePirate:disableSchedule()
		spinePirate:play("wait", true)

		self:_showPirate()
		self:_setFreeBtnText()
		self.m_bIsBeatPirate = false 
	end
	local strContent = ""
	if self.m_tOpenResult.addScore and self.m_tOpenResult.addScore > 0 then 
		strContent = strContent .. LocalStrings.SEAFARROAD_TEXT1[14] .. "+" .. self.m_tOpenResult.addScore .. "    "  
	end
	if self.m_tOpenResult.addStep and self.m_tOpenResult.addStep > 0 then 
		strContent = strContent .. LocalStrings.SEAFARROAD_TEXT1[16] .. "+" .. self.m_tOpenResult.addStep  
	end

	if strContent ~= "" then 
		MsgBoxManager:showTipBox(strContent, nil, nil, nil, nil, nil, nil, nil, nil, GlobalMethod:ccp(0.5, 0.77))
	end
	self:setOpenState(false)
	self:_afterCloseReward()
end

--@brief 	iphoneX适配
function WndSeafarRoad:_adaptIphoneX()
	if IsIphoneX() then
		GetElement(self.m_root, "conLeftScore_WndSeafarRoad", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.05,0.48))
		GetElement(self.m_root, "conLeftMenu_WndSeafarRoad", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.965,0.26))
	end
end

--@brief 	设置免费丢
function WndSeafarRoad:_setFreeBtnText()
	local txtBtnOpenOne = GetElement(self.m_root, "txtBtnOpenOne_WndSeafarRoad", WZUILabelTTF)
	local txtBtnOpenFive = GetElement(self.m_root, "txtBtnOpenFive_WndSeafarRoad", WZUILabelTTF)

	local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local freeTimes = 0 
	local nTempTimes = nLightNum
	local nTimes = 0
	local strContent = ""
	local imgBtnFive = GetElement(self.m_root, "imgBtnFive_WndSeafarRoad", WZUIImage)
	local nMileToTimes = self.m_nMaxLotteryCount
	local nLeftMiles = self.m_tContent.pirateConfig[1] - self.m_nPirateProgress
	if self.m_nPirate == 0 then 
		if self.m_nCount > 0 then 
			freeTimes = 1
			txtBtnOpenOne:setText(LocalStrings.SEAFARROAD_TEXT1[6])
		else
			txtBtnOpenOne:setText(string.format(LocalStrings.SEAFARROAD_TEXT1[5], 1))
		end
		strContent = LocalStrings.SEAFARROAD_TEXT1[5]
		imgBtnFive:setFile("ui/newvip/common_btn_42_1.png")
		txtBtnOpenFive:setStrokeColor(GlobalMethod:ccc3(0,108,3))

		nMileToTimes = math.ceil(nLeftMiles/self.m_nConstantOilToMile)
	else
		imgBtnFive:setFile("ui/common/common_btn_42_2.png")
		txtBtnOpenFive:setStrokeColor(GlobalMethod:ccc3(184,30,30))
		txtBtnOpenOne:setText(string.format(LocalStrings.SEAFARROAD_TEXT1[22], 1))
		strContent = LocalStrings.SEAFARROAD_TEXT1[22]

		nMileToTimes = math.ceil(self.m_nPirateHP/self.m_tContent.pirateConfig[3])
	end
	nTimes = (nTempTimes + freeTimes) >= self.m_nMaxLotteryCount and self.m_nMaxLotteryCount or nTempTimes > 0 and (nTempTimes + freeTimes) or self.m_nMaxLotteryCount 
	if nMileToTimes < nTimes then 
		nTimes = nMileToTimes 
	end

	txtBtnOpenFive:setText(string.format(strContent, nTimes))

	GetElement(self.m_root, "txtPirateAtt_WndSeafarRoad", WZUILabelTTF):setText(string.format(LocalStrings.SEAFARROAD_TEXT1[27], self.m_nTotalSeaMileTime, nLeftMiles))
end

--@brief 	设置待机特效
function WndSeafarRoad:_setBallAni()
	local spinePath1 = "activity/hd_pic_hanhaizhishen_02"
	local existSpine1 = CheckEffectFile(spinePath1)
	if existSpine1 then 
		local spineFish = GetElement(self.m_root, "spineFish_WndSeafarRoad", WZUISpine)
		if spineFish then 
			spineFish:setFileJson(spinePath1 .. ".json")
			spineFish:setFileAtlas(spinePath1 .. ".atlas")
			spineFish:play("wait", true)
		end
	else
		local _sIndex = "hd_pic_hanhaizhishen_02"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(70722, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndSeafarRoad)
        end
	end

	local spinePath2 = "activity/hd_pic_hanhaizhishen"
	local existSpine2 = CheckEffectFile(spinePath2)
	if existSpine2 then 
		local spineWait = GetElement(self.m_root, "spineWait_WndSeafarRoad", WZUISpine)
		if spineWait then 
			spineWait:setFileJson(spinePath2 .. ".json")
			spineWait:setFileAtlas(spinePath2 .. ".atlas")
			spineWait:play("wait", true)
		end
	else
		local _sIndex = "hd_pic_hanhaizhishen"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(70721, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndSeafarRoad)
        end
	end

	local spinePath3 = "activity/hd_pic_chuan"
	local existSpine3 = CheckEffectFile(spinePath3)
	if existSpine3 then 
		local spineOpen = GetElement(self.m_root, "spineOpen_WndSeafarRoad", WZUISpine)
		if spineOpen then 
			spineOpen:setFileJson(spinePath3 .. ".json")
			spineOpen:setFileAtlas(spinePath3 .. ".atlas")
			spineOpen:play("wait", true)
		end
	else
		local _sIndex = "hd_pic_chuan"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7072, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndSeafarRoad)
        end
	end

	local spinePath4 = "activity/hd_pic_chuangzhang"
	local existSpine4 = CheckEffectFile(spinePath4)
	if existSpine4 then 
		local spinePirate = GetElement(self.m_root, "spinePirate_WndSeafarRoad", WZUISpine)
		if spinePirate then 
			spinePirate:setFileJson(spinePath4 .. ".json")
			spinePirate:setFileAtlas(spinePath4 .. ".atlas")
			spinePirate:play("wait", true)
		end
	else
		local _sIndex = "hd_pic_chuangzhang"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(70723, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndSeafarRoad)
        end
	end
end

function WndSeafarRoad:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndSeafarRoad:downloadEffectCallback",taskId,extraData,failed)
    self:_setBallAni()
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndSeafarRoad:_setBowlingPlayAni(aniIndex, bLoop)
	local spineOpen = GetElement(self.m_root, "spineOpen_WndSeafarRoad", WZUISpine)
	aniIndex = aniIndex or 1
	WZLog("WndSeafarRoad:_setBowlingPlayAni", aniIndex, bLoop)

	local posCount = #self.m_tMovePos
	if aniIndex == 2 then 
		if self.m_nAniType > 0 then 
			local sequence = WZUIActionSequence:create()
			for i = 1, self.m_nAniType do
				local moveTo1 = WZUIActionMoveTo:create()
				moveTo1:setMoveX(self.m_tMovePos[self.m_nPosIndex + i][1])
				moveTo1:setMoveY(self.m_tMovePos[self.m_nPosIndex + i][2])
				moveTo1:setDuration(0.7)
				if i == self.m_nAniType then 
					if self.m_nPosIndex + i == 13 or self.m_nPosIndex + i == 82 then 
						moveTo1:setFinishLuaFunction("_roleTurnRightEnd")
					elseif self.m_nPosIndex + i == 56 then 
						moveTo1:setFinishLuaFunction("_roleTurnLeftEnd")
					elseif self.m_nPosIndex + i == posCount then 
						moveTo1:setFinishLuaFunction("_resetPos")
					else
						moveTo1:setFinishLuaFunction("_afterMove")
					end
				else
					if self.m_nPosIndex + i == 13 or self.m_nPosIndex + i == 82 then 
						moveTo1:setFinishLuaFunction("_roleTurnRight")
					elseif self.m_nPosIndex + i == 24 then 
						moveTo1:setFinishLuaFunction("_resetZorderOne")
					elseif self.m_nPosIndex + i == 56 then 
						moveTo1:setFinishLuaFunction("_roleTurnLeft")
					elseif self.m_nPosIndex + i == 59 then 
						moveTo1:setFinishLuaFunction("_resetZorderTwo")
					elseif self.m_nPosIndex + i == posCount then 
						moveTo1:setFinishLuaFunction("_resetPos")
					end
				end
				sequence:setChildAction(moveTo1)
				if self.m_nPosIndex + i == posCount then 
					break 
				end
			end

			self.m_nPosIndex = self.m_nPosIndex + self.m_nAniType
			spineOpen:runUIAction(sequence)
		else
			self:_afterMove()
		end
	elseif aniIndex == 3 then 
		local spinePirate = GetElement(self.m_root, "spinePirate_WndSeafarRoad", WZUISpine)
		spinePirate:play("wound", false)
	end
end

--@brief 	移动后回调
function WndSeafarRoad:_afterMove()
	if self.m_nPosIndex == 24 then 
		self:_resetZorderOne()
	elseif self.m_nPosIndex == 59 then 
		self:_resetZorderTwo()
	end
	self:showShootReward()
end
--@brief 	玩家转向左
function WndSeafarRoad:_roleTurnLeft()
	local spineOpen = GetElement(self.m_root, "spineOpen_WndSeafarRoad", WZUISpine)
	spineOpen:setFlipX(false)
end

--@brief 	玩家转向左
function WndSeafarRoad:_roleTurnLeftEnd()
	local spineOpen = GetElement(self.m_root, "spineOpen_WndSeafarRoad", WZUISpine)
	spineOpen:setFlipX(false)

	self:showShootReward()
end

--@brief 	玩家转向右
function WndSeafarRoad:_roleTurnRight()
	local spineOpen = GetElement(self.m_root, "spineOpen_WndSeafarRoad", WZUISpine)
	spineOpen:setFlipX(true)
end

--@brief 	玩家转向右
function WndSeafarRoad:_roleTurnRightEnd()
	local spineOpen = GetElement(self.m_root, "spineOpen_WndSeafarRoad", WZUISpine)
	spineOpen:setFlipX(true)

	self:showShootReward()
end

--@brief 	将玩家的位置重新设置到开始
function WndSeafarRoad:_resetPos()
	self.m_nPosIndex = 1
	local spineOpen = GetElement(self.m_root, "spineOpen_WndSeafarRoad", WZUISpine)
	spineOpen:setRelativePosition(GlobalMethod:ccp(self.m_tMovePos[self.m_nPosIndex][1], self.m_tMovePos[self.m_nPosIndex][2]))
	spineOpen:setFlipX(false)
	self:_resetZOrder(3, {0,0,0,0,0,0})

	self:showShootReward()
end

--@brief 	将玩家的位置重新设置到开始
function WndSeafarRoad:_resetZorderOne()
	self:_resetZOrder(2, {3,3,3,0,0,0})
end

--@brief 	将玩家的位置重新设置到开始
function WndSeafarRoad:_resetZorderTwo()
	self:_resetZOrder(2, {3,3,3,3,0,0})
end

--@brief 	重新设置层级关系
function WndSeafarRoad:_resetZOrder(wait0Order, tZorder)
	GetElement(self.m_root, "spineOpen_WndSeafarRoad", WZUISpine):setZOrder(wait0Order)
	for i = 1, #tZorder do
		GetElement(self.m_root, "imgIsland" .. i .. "_WndSeafarRoad", WZUIImage):setZOrder(tZorder[i])
	end
end

--@brief 	成熟度
function WndSeafarRoad:_showProgress()
	local txtStepNum = GetElement(self.m_root, "txtStepNum_WndSeafarRoad", WZUILabelTTF)
	if txtStepNum then 
		txtStepNum:setText(self.m_nCurScore)
	end

	local prgExp = GetElement(self.m_root, "prgExp_WndSeafarRoad", WZUIProgress)
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
    local closeBox = {"ui/common/common_icon_djbx1.png","ui/common/common_icon_lan1.png","ui/common/common_icon_zi1.png","ui/common/common_icon_huang1.png","ui/common/common_icon_zis1.png", "ui/common/common_icon_hong1.png"}
	local openBox = {"ui/common/common_icon_djbx2.png","ui/common/common_icon_lan2.png","ui/common/common_icon_zi2.png","ui/common/common_icon_huang2.png","ui/common/common_icon_zis2.png", "ui/common/common_icon_hong2.png"}
	local nullBox = {"ui/common/common_icon_djbx3.png","ui/common/common_icon_lan3.png","ui/common/common_icon_zi3.png","ui/common/common_icon_huang3.png","ui/common/common_icon_zis3.png", "ui/common/common_icon_hong3.png"}
    for i = 1, 6 do
    	local nCurStep = self.m_nCurStep
    	if nCurStep > self.m_tStepBoxConfig[i].stepTarget then 
    		nCurStep = self.m_tStepBoxConfig[i].stepTarget
    	end
    	
	    local imgStepBox = GetElement(self.m_root, "imgStepBox" .. i .. "_WndSeafarRoad", WZUIImage)
    	if self.m_tIslandOccupyInfo and self.m_tIslandOccupyInfo[i].playerId ~= 0 then 
	    	imgStepBox:setFile(nullBox[4])
	    else
	    	imgStepBox:setFile(closeBox[4])
	    end
	    local imgScoreBox = GetElement(self.m_root, "imgScoreBox" .. i .. "_WndSeafarRoad", WZUIImage)
	    if self.m_tScoreConfig[i].lastStatus == nil or self.m_tScoreConfig[i].lastStatus ~= self.m_tScoreConfig[i].status then 
	    	if self.m_tScoreConfig[i].status == 0 then 
	    		imgScoreBox:setFile(openBox[i])
	    		GetElement(self.m_root, "armScoreBox" .. i .. "_WndSeafarRoad", WZArmature):setVisible(true)
	    	elseif self.m_tScoreConfig[i].status == -1 then 
	    		imgScoreBox:setFile(closeBox[i])
	    		GetElement(self.m_root, "armScoreBox" .. i .. "_WndSeafarRoad", WZArmature):setVisible(false)
	    	elseif self.m_tScoreConfig[i].status == 1 then 
	    		imgScoreBox:setFile(nullBox[i])
	    		GetElement(self.m_root, "armScoreBox" .. i .. "_WndSeafarRoad", WZArmature):setVisible(false)
	    	end

	    	self.m_tScoreConfig[i].lastStatus = self.m_tScoreConfig[i].status
	    end
    end

    self:_setIslandStatus()
end

--@brief 	设置步数积分宝箱数量
function WndSeafarRoad:_showStepScoreNum()
	for i = 1, 6 do
		local txtScore = GetElement(self.m_root, "txtScore" .. i .. "_WndSeafarRoad", WZUILabelTTF)
		txtScore:setText(self.m_tScoreConfig[i].scoreTarget)
	end
end

--@brief 	刷新赛事礼包的信息
function WndSeafarRoad:showBagGiftInfo()
	-- body
	if self.m_nGiftRewardNum > 0 then 
		GetElement(self.m_root, "imgGiftRed_WndSeafarRoad", WZUIImage):setVisible(true)
		GetElement(self.m_root, "txtGiftNum_WndSeafarRoad", WZUILabelTTF):setText(self.m_nGiftRewardNum)
	else
		GetElement(self.m_root, "imgGiftRed_WndSeafarRoad", WZUIImage):setVisible(false)
	end
end

--@brief	显示海盗血量
function WndSeafarRoad:_showPirate()
	local conPirate = GetElement(self.m_root, "conPirate_WndSeafarRoad", WZUIContainer)
	if self.m_nPirate == 1 then 
		conPirate:setVisible(true)
		local prgPirateHP = GetElement(self.m_root, "prgPirateHP_WndSeafarRoad", WZUIProgress)
		local txtPirateHP = GetElement(self.m_root, "txtPirateHP_WndSeafarRoad", WZUILabelTTF)
		local nMaxHP = self.m_tContent.pirateConfig[2]
		txtPirateHP:setText(self.m_nPirateHP .. "/" .. nMaxHP)
		local nPercentage = math.floor(self.m_nPirateHP/nMaxHP * 100)
		prgPirateHP:setPercentage(nPercentage)
	else
		conPirate:setVisible(false)
	end
end

--@brief 	显示海神之印星级
function WndSeafarRoad:_ShowStar(nStar)
	if nStar then 
		local txtStarNum = GetElement(self.m_root, "txtStarNum_WndSeafarRoad", WZUILabelTTF)
		local imgSeaGodIcon = GetElement(self.m_root, "imgSeaGodIcon_WndSeafarRoad", WZUIImage)
		if nStar == 0 then 
			imgSeaGodIcon:setGrayRender(true)
			txtStarNum:setText(1)
		else
			imgSeaGodIcon:setGrayRender(false)
			txtStarNum:setText(nStar)
		end
	end

	local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId2)
	for i = 1, 6 do
		local imgMark = GetElement(self.m_root, "imgMark" .. i .. "_WndSeafarRoad", WZUIImage)
		if i <= nLightNum then 
			imgMark:setGrayRender(false)
		else
			imgMark:setGrayRender(true)
		end
	end

	local btnInherit = GetElement(self.m_root, "btnInherit_WndSeafarRoad", WZUIButton)
	if 6 > nLightNum then 
		btnInherit:setTouchEnable(false)
	else
		btnInherit:setTouchEnable(true)
	end
end

--@brief 	设置岛屿状态
function WndSeafarRoad:_setIslandStatus()
	for i = 1, 6 do
		local imgIsland = GetElement(self.m_root, "imgIsland" .. i .. "_WndSeafarRoad", WZUIImage)
		local imgOccupyFlag = GetElement(self.m_root, "imgOccupyFlag" .. i .. "_WndSeafarRoad", WZUIImage)
		local imgBoard = GetElement(self.m_root, "imgBoard" .. i .. "_WndSeafarRoad", WZUIImage)
		local txtTabNum = GetElement(imgBoard, "txtTabNum_WndSeafarRoad", WZUILabelTTF)
		local conHead = GetElement(self.m_root, "conHead" .. i .. "_WndSeafarRoad", WZUIContainer)
		if self.m_tIslandOccupyInfo and self.m_tIslandOccupyInfo[i].playerId ~= 0 then 
			local txtOccupyPlayer = GetElement(self.m_root, "txtOccupyPlayer" .. i .. "_WndSeafarRoad", WZUILabelTTF)
			local txtOccupyTimes = GetElement(self.m_root, "txtOccupyTimes" .. i .. "_WndSeafarRoad", WZUILabelTTF)
			txtOccupyPlayer:setText(self.m_tIslandOccupyInfo[i].name)
			if self.m_tIslandOccupyInfo[i].occupyTimes == 1 then 
				txtOccupyTimes:setText(LocalStrings.SEAFARROAD_TEXT1[29])
			else
				txtOccupyTimes:setText(string.format(LocalStrings.SEAFARROAD_TEXT1[15], self.m_tIslandOccupyInfo[i].occupyTimes))
			end
			imgIsland:setGrayRender(false)
			imgBoard:setGrayRender(false)
			imgOccupyFlag:setVisible(true)
			txtTabNum:setStrokeColor(GlobalMethod:ccc3(132,66,29))
			conHead:setVisible(true)
			local celElement = CellHead:show(conHead, self.m_tIslandOccupyInfo[i].headId, self.m_tIslandOccupyInfo[i].faceId, self.m_tIslandOccupyInfo[i].sex, nil, nil, self.m_tIslandOccupyInfo[i].vipLevel, self.m_tIslandOccupyInfo[i].headColor, nil, nil, nil, nil, self.m_tIslandOccupyInfo[i].headEffectId)
			celElement:setScale(0.85)
		else
			imgIsland:setGrayRender(true)
			imgBoard:setGrayRender(true)
			imgOccupyFlag:setVisible(false)
			conHead:setVisible(false)
			txtTabNum:setStrokeColor(GlobalMethod:ccc3(79,60,48))
		end
	end
end

--@brief 	初始化船位置
function WndSeafarRoad:_initBoardPos()
	local spineOpen = GetElement(self.m_root, "spineOpen_WndSeafarRoad", WZUISpine)
	if spineOpen then 
		spineOpen:setRelativePosition(GlobalMethod:ccp(self.m_tMovePos[self.m_nPosIndex][1], self.m_tMovePos[self.m_nPosIndex][2]))
		WZLog("WndSeafarRoad:_initStaticText", self.m_nPosIndex)
		if self.m_nPosIndex >= 13 and self.m_nPosIndex < 56 or self.m_nPosIndex >= 82 then 
			self:_roleTurnRight()
		end
		if self.m_nPosIndex >= 24 and self.m_nPosIndex < 60 then 
			self:_resetZOrder(2, {3,3,3,1,1,1})
		elseif self.m_nPosIndex >= 60 then 
			self:_resetZOrder(2, {3,3,3,3,1,1})
		end
	end
end
-------------------------------------私有方法模块End----------------------------------------


function WndSeafarRoad:_adaptLanguage_vn()
	GetElement(self.m_root,"txtBtnTask1_WndSeafarRoad",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtBtnTask2_WndSeafarRoad",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtBtnTask3_WndSeafarRoad",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtTypeName_WndSeafarRoad",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtBtnOpenOne_WndSeafarRoad",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtBtnOpenFive_WndSeafarRoad",WZUILabelTTF):setScale(0.7)
	local txtPirateAtt = GetElement(self.m_root,"txtPirateAtt_WndSeafarRoad",WZUILabelTTF)
	txtPirateAtt:setDimensions(GlobalMethod:CCSize(360,0))
	txtPirateAtt:setRelativePosition(GlobalMethod:ccp(0.5,0.145))
	txtPirateAtt:setFontSize(14)
end