--WndThrowPot.lua
--@brief	WndThrowPot的UI模块
--@date		2023/09/27
--@author	XTX
--@note		投壶活动主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndThrowPot:onEnter(element)
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
function WndThrowPot:onExit(element)
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
function WndThrowPot:onEnterTransitionDidFinish(element)
    WZLog("WndThrowPot:onEnterTransitionDidFinish")
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7093, 7093)
	self.m_root:enableSchedule("_caculateTime", 1)
end

--@brief    关闭窗口
function WndThrowPot:onCloseClick(element)
	local eleType = type(element)
	if eleType ~= "number" then 
    	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    end

	SaveActivityPoleType("THROWPOT", self.m_nCalabashType)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮回调
function WndThrowPot:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 	
	WndSingleMapDesc:showInterface1(LocalStrings.THROWPOT_TEXT2) 
end

--@brief 	点击目标按钮回调
function WndThrowPot:onClickTask(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if SystemTime:getServerTime() >= self.m_nEndTime then 
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END) 
		self:onCloseClick(0)
		return 
	end 

	local nTag = element:getTag()
	if nTag == 1 then 
		CellNewYearTask:showInterface(40, self.m_nActivityId)
	elseif nTag == 2 then
		WndDollMachineShop:showInterface(12, self.m_nActivityId)
	elseif nTag == 3 then 
		WndShopRank:showInterface(58, self.m_nActivityId) 
	end
end

--@brief 	点击大奖预览按钮回调
function WndThrowPot:onClickBigReward(element)
	-- body	
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
function WndThrowPot:onClickFive(element) 
	if SystemTime:getServerTime() >= self.m_nEndTime then 
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END) 
		self:onCloseClick(0)
		return 
	end 
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_bOpenState then MsgBoxManager:showTipBox(LocalStrings.THROWPOT_TEXT1[15]) return end 
	local nTag = element:getTag()
	if nTag == 5 then 
		if self.m_nAniType == 2 then 
			self.m_nAniType = 1
		else
			self.m_nAniType = 2
		end
		local btnFile = {"ui/newvip/common_btn_41_1.png", "ui/newvip/common_btn_42_1.png"}
		local btnWordsStrokeColor = {GlobalMethod:ccc3(163,74,20), GlobalMethod:ccc3(0,108,3)}
		local imgOpenBtn = GetElement(self.m_root, "imgOpenOneBtn_WndThrowPot", WZUIImage)
		local txtBtnOpenOne = GetElement(self.m_root, "txtBtnOpenOne_WndThrowPot", WZUILabelTTF)
		imgOpenBtn:setFile(btnFile[self.m_nAniType])
		txtBtnOpenOne:setStrokeColor(btnWordsStrokeColor[self.m_nAniType])
		self:_setFreeBtnText()
		return 
	end
	--背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
    if self.m_nChooseReward == 0 then 
    	self:onClickBigReward(0)

		self.m_nChooseReward = 1
		SaveOperateTimes("THROWPOTACTIVITYID", self.m_nActivityId)
    	return 
    end

	local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local nTempTimes = math.floor(nArrowNum/self.m_tCostByType[self.m_nCalabashType + 1])
	local nTimes = nTag
	local freeCount = 0
	if self.m_nCalabashType == 0 then 
		freeCount = self.m_nCount > 0 and 1 or 0 
	end
	if self.m_nAniType == 2 then 
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
function WndThrowPot:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

--@brief 	点击切换浪板类型
function WndThrowPot:onChooseTool(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local nTag = element:getTag()
	if self.m_bOpenState then 
		GetElement(self.m_root, "cbgTool_WndThrowPot", WZUICheckBoxGroup):setCheckIndex(self.m_nCalabashType)
		return 
	end 
	if self.m_nCalabashType == nTag then return end 

	self.m_nCalabashType = nTag
	self:_setFreeBtnText()
	self:_modeName()
	self:_setWaitPlayAni(1, true)
end

--@brief	点击物品弹出对应的tips
function WndThrowPot:onItemClick(tCell,tag,tData)
    if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData,false)
end

--@brief 	点击积分宝箱回调
function WndThrowPot:onClickScoreBox(element)
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
        local conLeftScore = GetElement(self.m_root, "conLeftScore_WndThrowPot", WZUIContainer)
        WndNewTipsReward:showInterface(conLeftScore, element, data, false, GlobalMethod:ccp(8.5, -0.05))
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndThrowPot:_update()
	-- body
	self:_setFreeBtnText()
	self:showRedDot()
	self:_initActivityTime()
    self:_updateLightNum()
    self:_showStepScoreNum()
end

--@brief 	初始化静态文本
function WndThrowPot:_initStaticText()
	self.m_nCalabashType = GetActivityPoleType("THROWPOT")
	if self.m_nCalabashType ~= 0 then 
		GetElement(self.m_root, "cbgTool_WndThrowPot", WZUICheckBoxGroup):setCheckIndex(self.m_nCalabashType)
	end
	self:_modeName()

	GetElement(self.m_root, "txtBtnTask1_WndThrowPot", WZUILabelTTF):setText(LocalStrings.THROWPOT_TEXT1[2])
	GetElement(self.m_root, "txtBtnTask2_WndThrowPot", WZUILabelTTF):setText(LocalStrings.THROWPOT_TEXT1[8])
	GetElement(self.m_root, "txtBtnTask3_WndThrowPot", WZUILabelTTF):setText(LocalStrings.THROWPOT_TEXT1[3])
	GetElement(self.m_root, "txtBigReward_WndThrowPot", WZUILabelTTF):setText(LocalStrings.WATERMELON_TEXT1[22])
	GetElement(self.m_root, "txtTypeName_WndThrowPot", WZUILabelTTF):setText(LocalStrings.THROWPOT_TEXT1[9] .. ":")

	self:_setBallAni()
end

--@brief 	红点
function WndThrowPot:showRedDot()
	-- body
	if self.m_root == nil then return end 

	local imgTaskRedDot = GetElement(self.m_root, "imgTaskRedDot_WndThrowPot", WZUIImage)

	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[117093] or GlobalGame.g_tRedPointTypeList[127093]) then 
		imgTaskRedDot:setVisible(true)
	else
		imgTaskRedDot:setVisible(false)
	end
end

--@brief 	更新异火的数量
function WndThrowPot:_updateLightNum()
	-- body
	local ftxtLightNum = GetElement(self.m_root, "ftxtLightNum_WndThrowPot", WZUIFreeTextBox)
	local sFormat = [[<I Z="0.45" P="1">%s</I><T C="255,255,255" S="18" P="1" SC="163,74,20" SS="4" SE="1">%d</T>]]
	if ftxtLightNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
		ftxtLightNum:setShowText(string.format(sFormat, basicData.icon, nLightNum))
	end
end

--@brief 	初始化活动时间
function WndThrowPot:_initActivityTime()
	-- body
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndThrowPot", WZUILabelTTF)
    if txtActivityTime then 
    	txtActivityTime:setText(LocalStrings.ACTIVE_TIME .. ":" .. needDay_str)
    end
end

--@brief 	显示开启动画
function WndThrowPot:showOpenAction()
	-- body
	local spineOpen = GetElement(self.m_root, "spineOpen_WndThrowPot", WZUISpine)
	local spineWait1 = GetElement(self.m_root, "spineWait1_WndThrowPot", WZUISpine)
	local spinePath = "activity/hd_pic_touhu"
	local existSpine = CheckEffectFile(spinePath)

	if spineOpen then 
		if existSpine then 
			if self.m_nAniType == 2 then 
				self:_setBowlingPlayAni(4, false)
				self:_showTalk(1)
			else
				if self.m_tOpenResult.bIsThrowIn then 
					self:_setBowlingPlayAni(2, false)
					self:_showTalk(1)
				else
					self:_setBowlingPlayAni(3, false)
					self:_showTalk(0)
				end
			end
			spineWait1:enableSchedule("waitHide", 0.1)
			spineOpen:enableSchedule("afterAni", 1.6)
		else
			self:showShootReward()
			self:setOpenState(false)
		end
	end
end

--@brief 	显示开启奖励
function WndThrowPot:showShootReward()
	-- body
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
		nIndex = nIndex + 1
	end
	if self.m_tOpenResult.addExp and self.m_tOpenResult.addExp > 0 then 
		if nIndex > 0 then 
			strContent = strContent .. " "
		end
		strContent = strContent .. LocalStrings.THROWPOT_TEXT1[9] .. "+" .. self.m_tOpenResult.addExp
	end

	if strContent ~= "" then 
		MsgBoxManager:showTipBox(strContent, nil, nil, nil, nil, nil, nil, nil, nil, GlobalMethod:ccp(0.5, 0.77))
	end

	self:_afterCloseReward()
end

--@brief 	iphoneX适配
function WndThrowPot:_adaptIphoneX()
	if IsIphoneX() then
		GetElement(self.m_root, "conLeftScore_WndThrowPot", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.07,0.58))
	end
end

--@brief 	设置免费丢
function WndThrowPot:_setFreeBtnText()
	local txtBtnOpenOne = GetElement(self.m_root, "txtBtnOpenOne_WndThrowPot", WZUILabelTTF)

	local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local freeTimes = 0 
	local nTempTimes = math.floor(nLightNum/self.m_tCostByType[self.m_nCalabashType + 1])
	local nTimes = 0
	if self.m_nAniType == 1 then 
		if self.m_nCount > 0 and self.m_nCalabashType == 0 then 
			freeTimes = 1
			txtBtnOpenOne:setText(LocalStrings.THROWPOT_TEXT1[6])
		else
			txtBtnOpenOne:setText(string.format(LocalStrings.THROWPOT_TEXT1[7], 1))
		end
	else
		nTimes = (nTempTimes + freeTimes) >= self.m_nMaxLotteryCount and self.m_nMaxLotteryCount or nTempTimes > 0 and (nTempTimes + freeTimes) or self.m_nMaxLotteryCount 
		txtBtnOpenOne:setText(string.format(LocalStrings.THROWPOT_TEXT1[7], nTimes))
	end
end

--@brief 	设置待机特效
function WndThrowPot:_setBallAni()
	local spinePath = "activity/hd_pic_touhu"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		local spineOpen = GetElement(self.m_root, "spineOpen_WndThrowPot", WZUISpine)
		local spineWait = GetElement(self.m_root, "spineWait_WndThrowPot", WZUISpine)
		local spineWait1 = GetElement(self.m_root, "spineWait1_WndThrowPot", WZUISpine)
		if spineOpen then 
			spineOpen:setFileJson(spinePath .. ".json")
			spineOpen:setFileAtlas(spinePath .. ".atlas")
		end
		if spineWait1 then 
			spineWait1:setFileJson(spinePath .. ".json")
			spineWait1:setFileAtlas(spinePath .. ".atlas")
			self:_setWaitPlayAni(1, true)
		end
		if spineWait then 
			spineWait:setFileJson(spinePath .. ".json")
			spineWait:setFileAtlas(spinePath .. ".atlas")
			spineWait:play("wait", true)
		end
	else
		local _sIndex = "hd_pic_touhu"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7093, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndThrowPot)
        end
	end

	local spinePath2 = "activity/ui_tq_lihe"
	local existSpine2 = CheckEffectFile(spinePath2)
	if existSpine2 then 
		for i = 1, 6 do
			local spineScoreBox = GetElement(self.m_root, "spineScoreBox" .. i .. "_WndThrowPot", WZUISpine)
			local spineStepBox = GetElement(self.m_root, "spineStepBox" .. i .. "_WndThrowPot", WZUISpine)
			if spineScoreBox then 
				spineScoreBox:setFileJson(spinePath2 .. ".json")
				spineScoreBox:setFileAtlas(spinePath2 .. ".atlas")
			end
			if spineStepBox then 
				spineStepBox:setFileJson(spinePath2 .. ".json")
				spineStepBox:setFileAtlas(spinePath2 .. ".atlas")
			end
		end
	else
		local _sIndex = "ui_tq_lihe"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(70931, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndThrowPot)
        end
	end
end

function WndThrowPot:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndThrowPot:downloadEffectCallback",taskId,extraData,failed)
    self:_setBallAni()
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndThrowPot:_setBowlingPlayAni(aniIndex, bLoop)
	local spineOpen = GetElement(self.m_root, "spineOpen_WndThrowPot", WZUISpine)
	aniIndex = aniIndex or 1
	WZLog("WndThrowPot:_setBowlingPlayAni", aniIndex, bLoop)

	if spineOpen then 
		spineOpen:setVisible(true)
		spineOpen:play(self.m_tBallAniName[self.m_nCalabashType + 1][aniIndex], bLoop ~= nil and bLoop or true)
	end
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndThrowPot:_setWaitPlayAni(aniIndex, bLoop)
	local spineWait1 = GetElement(self.m_root, "spineWait1_WndThrowPot", WZUISpine)
	aniIndex = aniIndex or 1
	WZLog("WndThrowPot:_setBowlingPlayAni", aniIndex, bLoop)

	if spineWait1 then 
		spineWait1:setVisible(true)
		spineWait1:play(self.m_tBallAniName[self.m_nCalabashType + 1][aniIndex], bLoop ~= nil and bLoop or true)
	end
end

--@brief 	播放露营动画后
function WndThrowPot:waitHide(element)
	local spineWait1 = GetElement(self.m_root, "spineWait1_WndThrowPot", WZUISpine)
	spineWait1:disableSchedule()
	spineWait1:setVisible(false)
end

--@brief 	播放露营动画后
function WndThrowPot:afterAni(element)
	local spineOpen = GetElement(self.m_root, "spineOpen_WndThrowPot", WZUISpine)
	spineOpen:disableSchedule()
	self:_setWaitPlayAni(1, true)
	spineOpen:setVisible(false)
	self:showShootReward()
	self:setOpenState(false)
end

--@brief 	成熟度
function WndThrowPot:_showProgress()
	local txtStepNum = GetElement(self.m_root, "txtStepNum_WndThrowPot", WZUILabelTTF)
	if txtStepNum then 
		txtStepNum:setText(self.m_nCurScore)
	end

	local prgExp = GetElement(self.m_root, "prgExp_WndThrowPot", WZUIProgress)
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
	    		GetElement(self.m_root, "spineScoreBox" .. i .. "_WndThrowPot", WZUISpine):play("wait1_" .. i, true)
	    	else
	    		GetElement(self.m_root, "spineScoreBox" .. i .. "_WndThrowPot", WZUISpine):play("wait" .. i, true)
	    		if self.m_tScoreConfig[i].status == 1 then 
	    			GetElement(self.m_root, "imgRec" .. i .. "_WndThrowPot", WZUIImage):setVisible(true)
	    		end
	    	end

	    	self.m_tScoreConfig[i].lastStatus = self.m_tScoreConfig[i].status
	    end
    end
end

--@brief 	设置步数积分宝箱数量
function WndThrowPot:_showStepScoreNum()
	for i = 1, 6 do
		local txtScore = GetElement(self.m_root, "txtScore" .. i .. "_WndThrowPot", WZUILabelTTF)
		txtScore:setText(self.m_tScoreConfig[i].scoreTarget)
	end
end

--@brief 	选择的模式名字
function WndThrowPot:_modeName()
	local txtModeName = GetElement(self.m_root, "txtModeName_WndThrowPot", WZUILabelTTF)
	if txtModeName then 
		txtModeName:setText(LocalStrings.THROWPOT_TEXT1[4 + self.m_nCalabashType])
	end
end

--@brief 	显示咖啡师的对话
--@param 	state:0没有触发礼包；1触发了礼包
function WndThrowPot:_showTalk(state)
	local conTalk = GetElement(self.m_root, "conTalk_WndThrowPot", WZUIContainer)
	conTalk:setVisible(true)

	local txtTalk = GetElement(self.m_root, "txtTalk_WndThrowPot", WZUILabelTTF)
	local tTalkList = LocalStrings.THROWPOT_TEXT1[17 + state]
	local nCount = #tTalkList
	local tempRand = math.random(1, 10)
	local strIndex = math.fmod(tempRand, nCount) + 1
	if self.m_nLastTalkIndex == strIndex or self.m_nTalkGapping ~= nil then return end 
	self.m_nLastTalkIndex = strIndex
	self.m_nTalkGapping = 3
	txtTalk:setText(tTalkList[strIndex] or tTalkList[1])
end

--@brief 	计时器
function WndThrowPot:_caculateTime()
	-- body
	if self.m_nTalkGapping == nil then return end 

	if self.m_nTalkGapping > 0 then 
		self.m_nTalkGapping = self.m_nTalkGapping - 1
	else
		self.m_nTalkGapping = nil 
		self.m_nLastTalkIndex = 0
		GetElement(self.m_root, "conTalk_WndThrowPot", WZUIContainer):setVisible(false)
	end
end

-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配模块Begin----------------------------------------

function WndThrowPot:_adaptLanguage_vn()
	GetElement(self.m_root,"conCoin_WndThrowPot",WZUIContainer):setRelativePosition(GlobalMethod:ccp(-0.08,0.5))
	GetElement(self.m_root,"btnBigReward_WndThrowPot",WZUIButton):setRelativePosition(GlobalMethod:ccp(1.04,0.5))
	GetElement(self.m_root,"txtTypeName_WndThrowPot",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtBtnOpenOne_WndThrowPot",WZUILabelTTF):setScale(0.7)
	local txtBtnTask1 = GetElement(self.m_root,"txtBtnTask1_WndThrowPot",WZUILabelTTF)
	txtBtnTask1:setScale(0.6)
	txtBtnTask1:setDimensions(GlobalMethod:CCSize(100,0))
	local txtBtnTask2 = GetElement(self.m_root,"txtBtnTask2_WndThrowPot",WZUILabelTTF)
	txtBtnTask2:setScale(0.6)
	txtBtnTask2:setDimensions(GlobalMethod:CCSize(100,0))
	local txtBtnTask3 = GetElement(self.m_root,"txtBtnTask3_WndThrowPot",WZUILabelTTF)
	txtBtnTask3:setScale(0.6)
	txtBtnTask3:setDimensions(GlobalMethod:CCSize(100,0))
end

-------------------------------------语言适配模块End----------------------------------------

