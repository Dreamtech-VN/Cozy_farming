--WndSummerSurf.lua
--@brief	WndSummerSurf的UI模块
--@date		2023/05/04
--@author	XTX
--@note		夏日冲浪活动界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSummerSurf:onEnter(element)
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

	self:_initStaticText()
	self:_adaptIphoneX()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSummerSurf:onExit(element)
	g_bIsShowWndDressUp = true
    g_tTempItemForLaterShow = {}
	CacheCenter:unregisterUpatePlayerItemObserver(self)
	ProtocolProcessorFestivalActivity:unregAll6()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
	GlobalGame:getGameEventDispathcer():Remove(Independent_Activity.ActivityReddot, self.showRedDot, self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetTaskList,self._onGetTaskInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetResult,self._onGetTaskResult,self)

	self:_unInit()
	LoadNewActivityRes(false)
end


--@brief    onenter函数已执行
function WndSummerSurf:onEnterTransitionDidFinish(element)
    WZLog("WndSummerSurf:onEnterTransitionDidFinish")
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7076, 7076)
end

--@brief    关闭窗口
function WndSummerSurf:onCloseClick(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    --如果是自动弹出的活动界面
    local nTag = element:getTag()
    if nTag == 2 then 
    	GetElement(self.m_root, "conWellChess_WndSummerSurf", WZUIContainer):setVisible(false)
    else
    	self:savePoleType()
    	WindowManager:removeWindow(self.m_root, self, true)
    end
end

--@brief    点击规则按钮回调
function WndSummerSurf:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 
    WndSingleMapDesc:showInterface1(LocalStrings.SUMMERSURF_TEXT2) 
end

--@brief 	点击目标按钮回调
function WndSummerSurf:onClickTask(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if nTag == 1 then 
		CellNewYearTask:showInterface(27, self.m_nActivityId)
	elseif nTag == 2 then
		WndShopRank:showInterface(44, self.m_nActivityId) 
	elseif nTag == 3 then 
		if self.m_tLoginGiftData.status == 0 then 
			--背包已满提示
		    if CacheCenter:getRemainAmount() <= 0 then
		        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
		        return
		    end

		    ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 6, "")
		else
			local tData = self.m_tLoginGiftData
			local data = {}

	        data.scale = 0.4
	        data.title = LocalStrings.SUMMERSURF_TEXT1[21]
	    	data.titleFontSize = 18
	        data.rewardIds = tData.ids
	        data.rewardNums = tData.nums
	        local conLeftMenu = GetElement(self.m_root, "conLeftMenu_WndSummerSurf", WZUIContainer)
	        WndNewTipsReward:showInterface(self.m_root, element, data, true, GlobalMethod:ccp(0.56, 0.54))
		end
	elseif nTag == 4 then --井字棋
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 4)
	end
end

--@brief 	点击大奖预览按钮回调
function WndSummerSurf:onClickBigReward(element)
	-- body	
	local eleType = type(element)
	if eleType ~= "number" then 
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	end

	self.m_tGetTimes = {}

	local tData = {}
	tData.type = 2 
	local strJson = json.encode(tData)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 7, strJson)

	local tData2 = {}
	tData2.type = 3 
	local strJson2 = json.encode(tData2)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 7, strJson2)
end


--@brief 	点击开启按钮回调
function WndSummerSurf:onClickFive(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
--	do WndSummerSurf:_onGetOtherData(self.m_nActivityId, 4, 1, [[{"reward":{"0":{"55201":1,"5603":6,"165025":2,"20007":5,"105":5,"172073":1,"79":400,"20016":1,"82":30,"1075":1,"83":22,"853":1,"21143":1,"119":44,"26":100,"75005":1,"55005":1,"127":1},"1":{"2548":1},"2":{"1":10000},"3":{"2":2000000}},"freeTimes":0}]]) return end 
	local nTag = element:getTag()
	--背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
    if self.m_bOpenState then return end 

    if self.m_nChooseReward == 0 then 
    	self:onClickBigReward(nTag)

		self.m_nChooseReward = 1
		self:saveOperateTimes()
    	return 
    end

	local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local nTempTimes = math.floor(nArrowNum/self.m_tCostByType[self.m_nCalabashType + 1])
	local nTimes = nTag
	local freeCount = 0
	if self.m_nCalabashType == 0 then 
		freeCount = self.m_nCount > 0 and 1 or 0 
	end
	self.m_nAniType = 1
	if nTag == 5 then 
		self.m_nAniType = 2
		nTag = 2 
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
	tData.type = self.m_nCalabashType + 4

	local stringData = json.encode(tData)

	self:setOpenState(true)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 4, stringData)
end

--@brief 	前往小推车购买
function WndSummerSurf:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

--@brief 	点击切换浪板类型
function WndSummerSurf:onChooseTool(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local nTag = element:getTag()
	if self.m_bOpenState then return end 
	if self.m_nCalabashType == nTag then return end 

	self.m_nCalabashType = nTag
	self:_setFreeBtnText()
	self:_setBowlingPlayAni(1, true)
end

--@brief 	点击棋子按钮回调
function WndSummerSurf:onClickChess(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local nTag = element:getTag()
	local status = self.m_tWellChessData[nTag]
	if status == 0 and self.m_nSelChess ~= nTag then 
		self.m_nSelChess = nTag
		element = WZUIButton:luaTo(element)
		local rpt = element:getRelativePosition()
		local imgSelChess = GetElement(self.m_root, "imgSelChess_WndSummerSurf", WZUIImage)
		imgSelChess:setRelativePosition(rpt)
		imgSelChess:setVisible(true)
	elseif status ~= 0 then 

	end
end

--@brief 	点击积分宝箱回调
function WndSummerSurf:onClickScoreBox(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if self.m_tWellChessConfig[nTag].status == 1 then 
		--背包已满提示
	    if CacheCenter:getRemainAmount() <= 0 then
	        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
	        return
	    end

	    ProtocolProcessorFestivalActivity:send_ACTIVITY2_ReceiveTaskReward(self.m_tWellChessConfig[nTag].activityId, self.m_tWellChessConfig[nTag].id)
	else
		local tData = self.m_tWellChessConfig[nTag]
		local data = {}

        data.scale = 0.4
        data.cur_value = self.m_nWinTimes
        data.totle_value = tData.target
        data.rewardIds = tData.ids
        data.rewardNums = tData.nums
        local conLeftScore = GetElement(self.m_root, "conChessContent_WndSummerSurf", WZUIContainer)
        WndNewTipsReward:showInterface(conLeftScore, element, data, false, GlobalMethod:ccp(0.4, 0.11))
	end
end

--@brief 	翻开贝壳按钮回调
function WndSummerSurf:onClickFlip(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local status = self.m_tWellChessData[self.m_nSelChess]
	if status == 0 then 
		local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId2)
		if nArrowNum == 0 then 
			WndFastGetItems:show(self.m_nCoinId2, 1)
			return 
		end
		self:setOpenState(true)
		local tData = {}
		tData.index = self.m_nSelChess - 1
		local stringData = json.encode(tData)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 1, stringData)
	else
		MsgBoxManager:showTipBox(LocalStrings.SUMMERSURF_TEXT1[22])
	end 
end

--@brief 	点击兑换隐藏道具回调
function WndSummerSurf:clickSureExchange(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nLightNum = CacheCenter:getPlayerItemCountById(self.m_tOpenResult.exchange[1])
	if nLightNum < self.m_tOpenResult.exchange[2] then 
		local basicData = GDatatab_item["id_" .. self.m_tOpenResult.exchange[1]]
		MsgBoxManager:showTipBox(string.format(LocalStrings.CARD_COUNT1, basicData.name))
		return 
	end
	local tData = {}
	tData.type = 2
	local stringData = json.encode(tData)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, stringData)
end

--@brief 	点击取消兑换隐藏道具回调
function WndSummerSurf:cancelExchangeItem(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	local tData = {}
	tData.type = 1
	local stringData = json.encode(tData)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, stringData)
end

--@brief 	点击物品回调
function WndSummerSurf:onClickItem(tCell,tag,tData)
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root, self.m_root,1,tData,false,nil,true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndSummerSurf:_update()
	-- body
	self:_setFreeBtnText()
	self:showRedDot()
	self:_initActivityTime()
    self:_updateLightNum()
end

--@brief 	初始化静态文本
function WndSummerSurf:_initStaticText()
	self:getPoleType()

	GetElement(self.m_root, "txtBtnTask1_WndSummerSurf", WZUILabelTTF):setText(LocalStrings.SUMMERSURF_TEXT1[3])
	GetElement(self.m_root, "txtBtnTask2_WndSummerSurf", WZUILabelTTF):setText(LocalStrings.SUMMERSURF_TEXT1[2])
	GetElement(self.m_root, "txtBtnTask3_WndSummerSurf", WZUILabelTTF):setText(LocalStrings.SUMMERSURF_TEXT1[19])
	GetElement(self.m_root, "txtBtnTask4_WndSummerSurf", WZUILabelTTF):setText(LocalStrings.SUMMERSURF_TEXT1[20])
	GetElement(self.m_root, "txtItemAtt_WndSummerSurf", WZUILabelTTF):setText(LocalStrings.SUMMERSURF_TEXT1[18])
	GetElement(self.m_root, "txtFlip_WndSummerSurf", WZUILabelTTF):setText(LocalStrings.SUMMERSURF_TEXT1[13])
	
	self:_setBallAni()
end

--@brief 	红点
function WndSummerSurf:showRedDot()
	-- body
	if self.m_root == nil then return end 

	local imgTaskRedDot = GetElement(self.m_root, "imgTaskRedDot_WndSummerSurf", WZUIImage)
	local imgChessRedDot = GetElement(self.m_root, "imgChessRedDot_WndSummerSurf", WZUIImage)

	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[217076] or GlobalGame.g_tRedPointTypeList[227076]) then 
		imgTaskRedDot:setVisible(true)
	else
		imgTaskRedDot:setVisible(false)
	end

	if GlobalGame.g_tRedPointTypeList and GlobalGame.g_tRedPointTypeList[247076] then 
		imgChessRedDot:setVisible(true)
	else
		imgChessRedDot:setVisible(false)
	end

	if self.m_tLoginGiftData and self.m_tLoginGiftData.status == 0 then 
		GetElement(self.m_root, "imgCardRedDot_WndSummerSurf", WZUIImage):setVisible(true)
	else
		GetElement(self.m_root, "imgCardRedDot_WndSummerSurf", WZUIImage):setVisible(false)
	end
end

--@brief 	更新异火的数量
function WndSummerSurf:_updateLightNum()
	-- body
	local ftxtLightNum = GetElement(self.m_root, "ftxtLightNum_WndSummerSurf", WZUIFreeTextBox)
	local sFormat = [[<I Z="0.5" P="1">%s</I><T C="255,236,193" S="20" P="1" SC="132,66,29" SS="4" SE="0">%d</T>]]
	if ftxtLightNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
		ftxtLightNum:setShowText(string.format(sFormat, basicData.icon, nLightNum))
	end
	local ftxtPearlNum = GetElement(self.m_root, "ftxtPearlNum_WndSummerSurf", WZUIFreeTextBox)
	if ftxtPearlNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId2]
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId2)
		ftxtPearlNum:setShowText(string.format(sFormat, basicData.icon, nLightNum))
	end
end

--@brief 	初始化活动时间
function WndSummerSurf:_initActivityTime()
	-- body
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndSummerSurf", WZUILabelTTF)
    if txtActivityTime then 
    	txtActivityTime:setText(LocalStrings.ACTIVITY_TIME_KEY .. ":" .. needDay_str)
    end
end

--@brief 	显示开启动画
function WndSummerSurf:showOpenAction()
	-- body
	--创建选中特效
	local spinePath = "activity/hd_pic_xiarichongl"
	local existSpine = CheckEffectFile(spinePath)
	if not existSpine then 
		local _sIndex = "hd_pic_xiarichongl"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7076, downloadInfo.url, downloadInfo.md5, _sIndex, "DownloadResourceCallback", _G)
        end
	end

	local spineOpen = GetElement(self.m_root, "spineOpen_WndSummerSurf", WZUISpine)
	if self.m_nAniType == 1 then 

	end
	if spineOpen then 
		if existSpine then 
			local aniIndex = self.m_nAniType + 1 
			self:_setBowlingPlayAni(aniIndex, false)
			spineOpen:enableSchedule("showShootReward", 0.6)
		else
			self:showShootReward()
		end
	end
end

--@brief 	显示开启奖励
function WndSummerSurf:showShootReward()
	-- body
	local spineOpen = GetElement(self.m_root, "spineOpen_WndSummerSurf", WZUISpine)
	spineOpen:disableSchedule()
	self:_setBowlingPlayAni(1, true)

	self:setOpenState(false)
	self:_afterCloseReward()
end

--@brief 	iphoneX适配
function WndSummerSurf:_adaptIphoneX()
	if IsIphoneX() then
		GetElement(self.m_root, "conLeftMenu_WndSummerSurf", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.98,0.25))
		GetElement(self.m_root, "btnWellChess_WndSummerSurf", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.08,0.45))
	end
end

--@brief 	设置免费丢
function WndSummerSurf:_setFreeBtnText()
	local txtBtnOpenOne = GetElement(self.m_root, "txtBtnOpenOne_WndSummerSurf", WZUILabelTTF)
	local txtBtnOpenFive = GetElement(self.m_root, "txtBtnOpenFive_WndSummerSurf", WZUILabelTTF)

	local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local freeTimes = 0 
	local nTempTimes = math.floor(nLightNum/self.m_tCostByType[self.m_nCalabashType + 1])
	local nTimes = 0
	if self.m_nCount > 0 and self.m_nCalabashType == 0 then 
		freeTimes = 1
		txtBtnOpenOne:setText(LocalStrings.SUMMERSURF_TEXT1[6])
	else
		txtBtnOpenOne:setText(string.format(LocalStrings.SUMMERSURF_TEXT1[5], 1))
	end
	nTimes = (nTempTimes + freeTimes) >= self.m_nMaxLotteryCount and self.m_nMaxLotteryCount or nTempTimes > 0 and (nTempTimes + freeTimes) or self.m_nMaxLotteryCount 

	txtBtnOpenFive:setText(string.format(LocalStrings.SUMMERSURF_TEXT1[5], nTimes))
end

--@brief 	设置待机特效
function WndSummerSurf:_setBallAni()
	local spinePath = "activity/hd_pic_xiarichongl"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		local spineOpen = GetElement(self.m_root, "spineOpen_WndSummerSurf", WZUISpine)
		if spineOpen then 
			spineOpen:setFileJson(spinePath .. ".json")
			spineOpen:setFileAtlas(spinePath .. ".atlas")
			self:_setBowlingPlayAni(1, true)
		end
	else
		local _sIndex = "hd_pic_xiarichongl"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7076, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndSummerSurf)
        end
	end
end

function WndSummerSurf:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndSummerSurf:downloadEffectCallback",taskId,extraData,failed)
    self:_setBallAni()
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndSummerSurf:_setBowlingPlayAni(aniIndex, bLoop)
	local spineOpen = GetElement(self.m_root, "spineOpen_WndSummerSurf", WZUISpine)
	aniIndex = aniIndex or 1
	WZLog("WndSummerSurf:_setBowlingPlayAni", aniIndex, bLoop)

	if spineOpen then 
		spineOpen:setVisible(true)
		spineOpen:play(self.m_tBallAniName[self.m_nCalabashType + 1][aniIndex], bLoop ~= nil and bLoop or true)
	end
end

--@brief 	显示井字棋界面
function WndSummerSurf:_showWellChess()
	GetElement(self.m_root, "conWellChess_WndSummerSurf", WZUIContainer):setVisible(true)
	self:_showStepScoreNum()
	self:_showProgress()
	self:_showWellChessStatus()
end

--@brief 	设置步数积分宝箱数量
function WndSummerSurf:_showStepScoreNum()
	for i = 1, 5 do
		local txtScore = GetElement(self.m_root, "txtScore" .. i .. "_WndSummerSurf", WZUILabelTTF)
		txtScore:setText(self.m_tWellChessConfig[i].target)
	end
end

--@brief 	成熟度
function WndSummerSurf:_showProgress()
	local txtWinTimes = GetElement(self.m_root, "txtWinTimes_WndSummerSurf", WZUILabelTTF)
	if txtWinTimes then 
		txtWinTimes:setText(LocalStrings.SUMMERSURF_TEXT1[16] .. ":" .. self.m_nWinTimes)
	end

	local prgExp = GetElement(self.m_root, "prgExp_WndSummerSurf", WZUIProgress)
	local nCurNum = self.m_nWinTimes
    if prgExp then 
        if nCurNum <= self.m_tWellChessConfig[1].target then 
            prgExp:setPercentage(math.floor(nCurNum * 20/self.m_tWellChessConfig[1].target))
        elseif nCurNum <= self.m_tWellChessConfig[2].target then 
            local nTempNum = self.m_tWellChessConfig[2].target - self.m_tWellChessConfig[1].target
            prgExp:setPercentage(20 + math.floor((nCurNum - self.m_tWellChessConfig[1].target) * 20/nTempNum))
        elseif nCurNum <= self.m_tWellChessConfig[3].target then 
            local nTempNum = self.m_tWellChessConfig[3].target - self.m_tWellChessConfig[2].target
            prgExp:setPercentage(40 + math.floor((nCurNum - self.m_tWellChessConfig[2].target) * 20/nTempNum))
        elseif nCurNum <= self.m_tWellChessConfig[4].target then 
            local nTempNum = self.m_tWellChessConfig[4].target - self.m_tWellChessConfig[3].target
            prgExp:setPercentage(60 + math.floor((nCurNum - self.m_tWellChessConfig[3].target) * 20/nTempNum))
        elseif nCurNum <= self.m_tWellChessConfig[5].target then 
            local nTempNum = self.m_tWellChessConfig[5].target - self.m_tWellChessConfig[4].target
            prgExp:setPercentage(80 + math.floor((nCurNum - self.m_tWellChessConfig[4].target) * 20/nTempNum))
        else
            prgExp:setPercentage(100)
        end
    end

    --步数
    local closeBox = {"ui/common/common_icon_lan1.png","ui/common/common_icon_zi1.png","ui/common/common_icon_huang1.png","ui/common/common_icon_zis1.png", "ui/common/common_icon_hong1.png"}
	local openBox = {"ui/common/common_icon_lan2.png","ui/common/common_icon_zi2.png","ui/common/common_icon_huang2.png","ui/common/common_icon_zis2.png", "ui/common/common_icon_hong2.png"}
	local nullBox = {"ui/common/common_icon_lan3.png","ui/common/common_icon_zi3.png","ui/common/common_icon_huang3.png","ui/common/common_icon_zis3.png", "ui/common/common_icon_hong3.png"}
    for i = 1, 5 do
	    local imgScoreBox = GetElement(self.m_root, "imgScoreBox" .. i .. "_WndSummerSurf", WZUIImage)
	    if self.m_tWellChessConfig[i].lastStatus == nil or self.m_tWellChessConfig[i].lastStatus ~= self.m_tWellChessConfig[i].status then 
	    	if self.m_tWellChessConfig[i].status == 1 then 
	    		imgScoreBox:setFile(openBox[i])
	    		GetElement(self.m_root, "armScoreBox" .. i .. "_WndSummerSurf", WZArmature):setVisible(true)
	    	elseif self.m_tWellChessConfig[i].status == 0 then 
	    		imgScoreBox:setFile(closeBox[i])
	    		GetElement(self.m_root, "armScoreBox" .. i .. "_WndSummerSurf", WZArmature):setVisible(false)
	    	elseif self.m_tWellChessConfig[i].status == 2 then 
	    		imgScoreBox:setFile(nullBox[i])
	    		GetElement(self.m_root, "armScoreBox" .. i .. "_WndSummerSurf", WZArmature):setVisible(false)
	    	end

	    	self.m_tWellChessConfig[i].lastStatus = self.m_tWellChessConfig[i].status
	    end
    end
end

--@brief	显示井字棋棋子状态
function WndSummerSurf:_showWellChessStatus()
	local tChessFile = {"ui/newActivity/hd_pic_xrcl_stjzq_bk.png", "ui/newActivity/hd_pic_xrcl_stjzq_o.png", "ui/newActivity/hd_pic_xrcl_stjzq_x.png", ""}
	for i = 1, #self.m_tWellChessData do
		local btnWellChess = GetElement(self.m_root, "btnWellChess" .. i .. "_WndSummerSurf", WZUIButton)
		local imgChessMark = GetElement(btnWellChess, "imgChessMark_WndSummerSurf", WZUIImage)
		if imgChessMark then 
			imgChessMark:setFile(tChessFile[(self.m_tWellChessData[i] * (-1)) + 1])
		end
	end

	local status = self.m_tWellChessData[self.m_nSelChess]
	local imgSelChess = GetElement(self.m_root, "imgSelChess_WndSummerSurf", WZUIImage)
	if status == nil or status ~= 0 then 
		imgSelChess:setVisible(false)
	else
		local btnWellChess = GetElement(self.m_root, "btnWellChess" .. self.m_nSelChess .. "_WndSummerSurf", WZUIButton)
		local rpt = btnWellChess:getRelativePosition()
		imgSelChess:setRelativePosition(rpt)
		imgSelChess:setVisible(true)
	end

	--隐藏奖励
	local conFlipItem = GetElement(self.m_root, "conFlipItem_WndSummerSurf", WZUIContainer)
	conFlipItem:removeAllChildrenWithCleanup(true)
	local tData = self.m_tHideReward[1]
	local element, tNewObj = CellGoodItem:createElement()
	if element and tNewObj then 
		element:setScale(0.6)
		tNewObj:setCellGoodLocalId(tData[1], tData[2], 17)
		tNewObj:setItemClickFun(self, self.onClickItem)

		conFlipItem:addChild(element)
	end
end
-------------------------------------私有方法模块End----------------------------------------


function WndSummerSurf:_adaptLanguage_vn()
	GetElement(self.m_root, "txtBtnTask1_WndSummerSurf", WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root, "txtBtnTask2_WndSummerSurf", WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root, "txtBtnTask3_WndSummerSurf", WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root, "txtBtnOpenOne_WndSummerSurf", WZUILabelTTF):setScale(0.65)
	GetElement(self.m_root, "txtBtnOpenFive_WndSummerSurf", WZUILabelTTF):setScale(0.65)

	GetElement(self.m_root, "txtItemAtt_WndSummerSurf", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(-0.1,0.5))
end