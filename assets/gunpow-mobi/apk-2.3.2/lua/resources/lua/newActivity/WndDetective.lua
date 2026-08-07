--WndDetective.lua
--@brief	WndDetective的UI模块
--@date		2023/07/17
--@author	XTX
--@note		备课侦探所活动主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndDetective:onEnter(element)
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
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndDetective:onExit(element)
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
function WndDetective:onEnterTransitionDidFinish(element)
    WZLog("WndDetective:onEnterTransitionDidFinish")
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7084, 7084)
	self.m_root:enableSchedule("_caculateTime", 1)
end

--@brief    关闭窗口
function WndDetective:onCloseClick(element)
	local eleType = type(element)
	if eleType ~= "number" then 
    	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    end

	self:savePoleType()
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮回调
function WndDetective:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 	
	WndSingleMapDesc:showInterface1(LocalStrings.DETECTIVE_TEXT2) 
end

--@brief 	点击目标按钮回调
function WndDetective:onClickTask(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if SystemTime:getServerTime() >= self.m_nEndTime then 
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END) 
		self:onCloseClick(0)
		return 
	end 

	local nTag = element:getTag()
	if nTag == 1 then 
		CellNewYearTask:showInterface(32, self.m_nActivityId)
	elseif nTag == 2 then
		WndHouseInvite:showInterface(8, self.m_nActivityId, 1)
	elseif nTag == 3 then 
		WndShopRank:showInterface(49, self.m_nActivityId) 
	end
end

--@brief 	点击大奖预览按钮回调
function WndDetective:onClickBigReward(element)
	-- body	
	if SystemTime:getServerTime() >= self.m_nEndTime then 
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END) 
		self:onCloseClick(0)
		return 
	end 
	local eleType = type(element)
	local nTag = 0
	if eleType ~= "number" then 
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
		nTag = element:getTag()
	else
		nTag = element
	end

	self.m_tGetTimes = {}
	self.m_tBigRewardList = {}
	self.m_bIsOpenReward = true 
	local tData = {pool = 0}
	local tData2 = {pool = 1}
	if nTag == 2 then 
		tData = {pool = 2}
		tData2 = {pool = 3}
	end
	local strJson = json.encode(tData)
	local strJson2 = json.encode(tData2)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson2)
end


--@brief 	点击开启按钮回调
function WndDetective:onClickFive(element)
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
    if self.m_bOpenState then return end 
    if self.m_nChooseReward == 0 then 
    	self:onClickBigReward(0)

		self.m_nChooseReward = 1
		self:saveOperateTimes()
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
function WndDetective:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

--@brief 	点击切换浪板类型
function WndDetective:onChooseTool(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local nTag = element:getTag()
	if self.m_bOpenState then return end 
	if self.m_nCalabashType == nTag then return end 

	self.m_nCalabashType = nTag
	self:_setFreeBtnText()
	self:_setBowlingPlayAni(1, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndDetective:_update()
	-- body
	self:_setFreeBtnText()
	self:showRedDot()
	self:_initActivityTime()
    self:_updateLightNum()
end

--@brief 	初始化静态文本
function WndDetective:_initStaticText()
	self:getPoleType()

	GetElement(self.m_root, "txtBtnTask1_WndDetective", WZUILabelTTF):setText(LocalStrings.DETECTIVE_TEXT1[2])
	GetElement(self.m_root, "txtBtnTask2_WndDetective", WZUILabelTTF):setText(LocalStrings.DETECTIVE_TEXT1[4])
	GetElement(self.m_root, "txtBtnTask3_WndDetective", WZUILabelTTF):setText(LocalStrings.DETECTIVE_TEXT1[3])
	GetElement(self.m_root, "txtBigReward_WndDetective", WZUILabelTTF):setText(LocalStrings.WATERMELON_TEXT1[22])

	self:_setBallAni()
end

--@brief 	红点
function WndDetective:showRedDot()
	-- body
	if self.m_root == nil then return end 

	local imgTaskRedDot = GetElement(self.m_root, "imgTaskRedDot_WndDetective", WZUIImage)

	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[117084] or GlobalGame.g_tRedPointTypeList[127084]) then 
		imgTaskRedDot:setVisible(true)
	else
		imgTaskRedDot:setVisible(false)
	end

	self:showRedDotTwo()
end

--@brief 	红点
function WndDetective:showRedDotTwo()
	-- body
	if self.m_root == nil then return end 

	local imgNoteRedDot = GetElement(self.m_root, "imgNoteRedDot_WndDetective", WZUIImage)

	local bRedNote = false 
	for i = 1, #self.m_tIdCostList do
		local num = CacheCenter:getPlayerItemCountById(self.m_tIdCostList[i])
		if num >= self.m_tContent.mergeConfig[i][1] then 
			bRedNote = true 
			break 
		end
	end

	imgNoteRedDot:setVisible(bRedNote)
end

--@brief 	更新异火的数量
function WndDetective:_updateLightNum()
	-- body
	local ftxtLightNum = GetElement(self.m_root, "ftxtLightNum_WndDetective", WZUIFreeTextBox)
	local sFormat = [[<I Z="0.5" P="1">%s</I><T C="255,250,236" S="18" P="1" SC="132,66,29" SS="4" SE="1">%d</T>]]
	if ftxtLightNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
		ftxtLightNum:setShowText(string.format(sFormat, basicData.icon, nLightNum))
	end
end

--@brief 	初始化活动时间
function WndDetective:_initActivityTime()
	-- body
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndDetective", WZUILabelTTF)
    if txtActivityTime then 
    	txtActivityTime:setText(needDay_str)
    end
end

--@brief 	显示开启动画
function WndDetective:showOpenAction()
	-- body
	local spineOpen = GetElement(self.m_root, "spineOpen_WndDetective", WZUISpine)
	local spinePath = "activity/hd_pic_bknan"
	local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".json")

	if spineOpen then 
		if existSpine then 
			local aniIndex = self.m_nAniType + 1 
			self:_setBowlingPlayAni(aniIndex, false)
			local nSeconds = 1.2
			spineOpen:enableSchedule("showShootReward", nSeconds)
		else
			self:showShootReward()
		end
	end
end

--@brief 	显示开启奖励
function WndDetective:showShootReward()
	-- body
	local spineOpen = GetElement(self.m_root, "spineOpen_WndDetective", WZUISpine)
	spineOpen:disableSchedule()
	self:_setBowlingPlayAni(1, true)

	local strContent = ""
	local nIndex = 0 
	if self.m_tOpenResult.otherRewards and #self.m_tOpenResult.otherRewards > 0 then 
		for i = 1, #self.m_tOpenResult.otherRewards do
			if i == 1 then 
				strContent = strContent .. LocalStrings.CRAZY_DOUBLING_TEXT8 .. " "
			else
				strContent = strContent .. ", "
			end
			local basicData = GDatatab_item["id_" .. self.m_tOpenResult.otherRewards[i][1]]
			strContent = strContent .. basicData.name .. "*" .. self.m_tOpenResult.otherRewards[i][2]
		end
	end

	if strContent ~= "" then 
		MsgBoxManager:showTipBox(strContent, nil, nil, nil, nil, nil, nil, nil, nil, GlobalMethod:ccp(0.5, 0.77))
	end

	self:setOpenState(false)
	self:_afterCloseReward()
end

--@brief 	iphoneX适配
function WndDetective:_adaptIphoneX()
	if IsIphoneX() then
		GetElement(self.m_root, "conLeftMenu_WndDetective", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.98,0))
	end
end

--@brief 	设置免费丢
function WndDetective:_setFreeBtnText()
	local txtBtnOpenOne = GetElement(self.m_root, "txtBtnOpenOne_WndDetective", WZUILabelTTF)
	local txtBtnOpenFive = GetElement(self.m_root, "txtBtnOpenFive_WndDetective", WZUILabelTTF)

	local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local freeTimes = 0 
	local nTempTimes = math.floor(nLightNum/self.m_tCostByType[self.m_nCalabashType + 1])
	local nTimes = 0

	local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local freeTimes = 0 
	local nTempTimes = math.floor(nLightNum/self.m_tCostByType[self.m_nCalabashType + 1])
	local nTimes = 0
	local strTemp = LocalStrings.DETECTIVE_TEXT1[7]
	if self.m_nCalabashType == 0 then 
		if self.m_nCount > 0 then 
			freeTimes = 1
			txtBtnOpenOne:setText(LocalStrings.DETECTIVE_TEXT1[6])
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
function WndDetective:_setBallAni()
	local spinePath = "activity/hd_pic_bknan"
	local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".json")
	if existSpine then 
		local spineOpen = GetElement(self.m_root, "spineOpen_WndDetective", WZUISpine)
		if spineOpen then 
			spineOpen:setFileJson(spinePath .. ".json")
			spineOpen:setFileAtlas(spinePath .. ".atlas")
			self:_setBowlingPlayAni(1, true)
		end
	else
		local _sIndex = "hd_pic_bknan"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7084, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndDetective)
        end
	end

	local spinePath2 = "activity/hd_pic_bkbj"
	local existSpine2 = WZDataFile:getInstance():checkFileExist(spinePath2 .. ".json")
	if existSpine2 then 
		local spineWait = GetElement(self.m_root, "spineWait_WndDetective", WZUISpine)
		if spineWait then 
			spineWait:setFileJson(spinePath2 .. ".json")
			spineWait:setFileAtlas(spinePath2 .. ".atlas")
			spineWait:play("wait", true)
		end
	else
		local _sIndex = "hd_pic_bkbj"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(70840, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndDetective)
        end
	end
end

function WndDetective:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndDetective:downloadEffectCallback",taskId,extraData,failed)
    self:_setBallAni()
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndDetective:_setBowlingPlayAni(aniIndex, bLoop)
	local spineOpen = GetElement(self.m_root, "spineOpen_WndDetective", WZUISpine)
	aniIndex = aniIndex or 1
	WZLog("WndDetective:_setBowlingPlayAni", aniIndex, bLoop)

	if spineOpen then 
		spineOpen:play(self.m_tBallAniName[self.m_nCalabashType + 1][aniIndex], bLoop ~= nil and bLoop or true)
	end
end
--@brief 	显示咖啡师的对话
--@param 	state:0没有触发礼包；1触发了礼包
function WndDetective:_showTalk(state)
	local conTalk = GetElement(self.m_root, "conTalk_WndDetective", WZUIContainer)
	conTalk:setVisible(true)

	local txtTalk = GetElement(self.m_root, "txtTalk_WndDetective", WZUILabelTTF)
	local tTalkList = LocalStrings.DETECTIVE_TEXT1[17]
	local nCount = #tTalkList
	local tempRand = math.random(1, 10)
	local strIndex = math.fmod(tempRand, nCount) + 1
	if self.m_nLastTalkIndex == strIndex or self.m_nTalkGapping ~= nil then return end 
	self.m_nLastTalkIndex = strIndex
	self.m_nTalkGapping = 3
	txtTalk:setText(tTalkList[strIndex] or tTalkList[1])
end

--@brief 	计时器
function WndDetective:_caculateTime()
	-- body
	if self.m_nTalkGapping == nil then return end 

	if self.m_nTalkGapping > 0 then 
		self.m_nTalkGapping = self.m_nTalkGapping - 1
	else
		self.m_nTalkGapping = nil 
		self.m_nLastTalkIndex = 0
		GetElement(self.m_root, "conTalk_WndDetective", WZUIContainer):setVisible(false)
	end
end




-------------------------------------私有方法模块End----------------------------------------
