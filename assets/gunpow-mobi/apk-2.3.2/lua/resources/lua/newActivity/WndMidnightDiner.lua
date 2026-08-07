--WndMidnightDiner.lua
--@brief	WndMidnightDiner的UI模块
--@date		2022/10/08
--@author	XTX
--@note		深夜食堂活动主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMidnightDiner:onEnter(element)
	self.m_root = element

	g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
	ProtocolProcessorFestivalActivity:regAll6()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
	GlobalGame:getGameEventDispathcer():Add(Independent_Activity.ActivityReddot, self.showRedDot, self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetResult,self._onGetNewYearTaskGetResult,self)

	self:_initStaticText()
	self:_adaptIphoneX()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMidnightDiner:onExit(element)
	g_bIsShowWndDressUp = true
    g_tTempItemForLaterShow = {}
	CacheCenter:unregisterUpatePlayerItemObserver(self)
	ProtocolProcessorFestivalActivity:unregAll6()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
	GlobalGame:getGameEventDispathcer():Remove(Independent_Activity.ActivityReddot, self.showRedDot, self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetResult,self._onGetNewYearTaskGetResult,self)

	self:_unInit()
	LoadNewActivityRes(false)
end

--@brief    onenter函数已执行
function WndMidnightDiner:onEnterTransitionDidFinish(element)
    WZLog("WndMidnightDiner:onEnterTransitionDidFinish")
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7058, 7058)
end

--@brief    关闭窗口
function WndMidnightDiner:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    self:savePoleType()
    --如果是自动弹出的活动界面
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮回调
function WndMidnightDiner:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 
    WndSingleMapDesc:showInterface1(LocalStrings.MIDNIGHTDINER_TEXT2) 
end

--@brief 	点击目标按钮回调
function WndMidnightDiner:onClickTask(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if nTag == 1 then 
		CellNewYearTask:showInterface(18, self.m_nActivityId)
	elseif nTag == 2 then
		WndHouseInvite:showInterface(5, self.m_nActivityId)
	elseif nTag == 3 then 
		WndShopRank:showInterface(32, self.m_nActivityId) 
	end
end

--@brief 	点击大奖预览按钮回调
function WndMidnightDiner:onClickBigReward(element)
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
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 10, strJson)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 10, strJson2)
end

--@brief 	点击开启按钮回调
function WndMidnightDiner:onClickFive(element)
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
		SaveOperateTimes("MIDNIGHTDINERACTIVITYID", self.m_nActivityId)
    	return 
    end

	local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local freeCount = 0
	local nTempTimes = nArrowNum
	if self.m_nPoleType == 0 then
		freeCount = self.m_nCount > 0 and 1 or 0 
	else
		freeCount = 0
	end
	nTempTimes = math.floor(nArrowNum/self.m_tGlovesCost[self.m_nPoleType + 1])
	local nTimes = nTag
	if nTag == 5 then 
		nTag = self.m_nMaxLotteryCount 
		nTimes = (nTempTimes + freeCount) >= self.m_nMaxLotteryCount and self.m_nMaxLotteryCount or nTempTimes > 0 and (nTempTimes + freeCount) or self.m_nMaxLotteryCount 
	end
	local nCostNum = nTimes * self.m_tGlovesCost[self.m_nPoleType + 1]
	if nCostNum - freeCount > nArrowNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		MsgBoxManager:showConfirmBox(string.format(LocalStrings.WATERCOUNTRY_TEXT4, basicData.name), self, self.goToBuy)
		return 
	end

    local tData = {}
	tData.times = nTag
	tData.dkType = self.m_nPoleType

	local stringData = json.encode(tData)

	self:setOpenState(true)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 6, stringData)
end

--@brief 	前往小推车购买
function WndMidnightDiner:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

--@brief 	点击切换场地等级回调
function WndMidnightDiner:onChooseTool(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local nTag = element:getTag()
	self.m_nPoleType = nTag
	self:_setFreeBtnText()
	if not self.m_bOpenState then 
		self:_setBowlingPlayAni(1, true)
	end
end

--@brief	点击物品弹出对应的tips
function WndMidnightDiner:onItemClick(tCell, tag, tData)
    if tData == nil then
       return
    end

    if self.m_tRandomTaskInfo and self.m_tRandomTaskInfo.status == 0 then 
    	self:setOpenState(true)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ReceiveTaskReward(self.m_nActivityId, self.m_tRandomTaskInfo.id)
    	return 
    end

    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root, WndMidnightDiner.m_root, 1, tData, false, nil, true)
end

--@brief 	点击赛事礼包按钮回调
function WndMidnightDiner:onClickGift(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_nGiftRewardNum >= 1 then
		--背包已满提示
	    if CacheCenter:getRemainAmount() <= 0 then
	        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
	        return
	    end
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 9, "")
	else
		local tData = {}
		tData.txtTitle = LocalStrings.MIDNIGHTDINER_TEXT1[24]
		tData.nType = 2
		WndTips:show(element, self.m_root, 52, tData, GlobalMethod:ccp(50,80), true)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndMidnightDiner:_update()
	-- body
	self:_setFreeBtnText()
	self:showRedDot()
	self:_initActivityTime()
    self:_updateLightNum()
    self:showBagGiftInfo()
end

--@brief 	初始化静态文本
function WndMidnightDiner:_initStaticText()
	self:getPoleType()
	self.m_root:enableSchedule("_caculateTime", 1)
	GetElement(self.m_root, "txtTask1_WndMidnightDiner", WZUILabelTTF):setText(LocalStrings.MIDNIGHTDINER_TEXT1[2])
	GetElement(self.m_root, "txtTaskSel1_WndMidnightDiner", WZUILabelTTF):setText(LocalStrings.MIDNIGHTDINER_TEXT1[2])
	GetElement(self.m_root, "txtTask2_WndMidnightDiner", WZUILabelTTF):setText(LocalStrings.MIDNIGHTDINER_TEXT1[13])
	GetElement(self.m_root, "txtTaskSel2_WndMidnightDiner", WZUILabelTTF):setText(LocalStrings.MIDNIGHTDINER_TEXT1[13])
	GetElement(self.m_root, "txtTask3_WndMidnightDiner", WZUILabelTTF):setText(LocalStrings.MIDNIGHTDINER_TEXT1[3])
	GetElement(self.m_root, "txtTaskSel3_WndMidnightDiner", WZUILabelTTF):setText(LocalStrings.MIDNIGHTDINER_TEXT1[3])

	GetElement(self.m_root, "txtTool1_WndMidnightDiner", WZUILabelTTF):setText(LocalStrings.MIDNIGHTDINER_TEXT1[14])
	GetElement(self.m_root, "txtTool1Sel_WndMidnightDiner", WZUILabelTTF):setText(LocalStrings.MIDNIGHTDINER_TEXT1[14])
	GetElement(self.m_root, "txtTool2_WndMidnightDiner", WZUILabelTTF):setText(LocalStrings.MIDNIGHTDINER_TEXT1[15])
	GetElement(self.m_root, "txtTool2Sel_WndMidnightDiner", WZUILabelTTF):setText(LocalStrings.MIDNIGHTDINER_TEXT1[15])
	GetElement(self.m_root, "txtTool3_WndMidnightDiner", WZUILabelTTF):setText(LocalStrings.MIDNIGHTDINER_TEXT1[16])
	GetElement(self.m_root, "txtTool3Sel_WndMidnightDiner", WZUILabelTTF):setText(LocalStrings.MIDNIGHTDINER_TEXT1[16])
	GetElement(self.m_root, "txtRandomTaskTitle_WndMidnightDiner", WZUILabelTTF):setText(LocalStrings.MIDNIGHTDINER_TEXT1[2])
	self.m_conTeamReward = GetElement(self.m_root, "conTeamReward_WndMidnightDiner", WZUIContainer)

	self:_setBallAni()
end

--@brief 	红点
function WndMidnightDiner:showRedDot()
	-- body
	if self.m_root == nil then return end 

	local imgTaskRedDot = GetElement(self.m_root, "imgTaskRedDot_WndMidnightDiner", WZUIImage)
	local imgInviteRedDot = GetElement(self.m_root, "imgInviteRedDot_WndMidnightDiner", WZUIImage)

	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[217058] or GlobalGame.g_tRedPointTypeList[227058] or GlobalGame.g_tRedPointTypeList[237058]) then 
		imgTaskRedDot:setVisible(true)
	else
		imgTaskRedDot:setVisible(false)
	end

	if GlobalGame.g_tRedPointTypeList and GlobalGame.g_tRedPointTypeList[17058] then 
		imgInviteRedDot:setVisible(true)
	else
		imgInviteRedDot:setVisible(false)
	end
end

--@brief 	更新异火的数量
function WndMidnightDiner:_updateLightNum()
	-- body
	local ftxtLightNum = GetElement(self.m_root, "ftxtArrowNum_WndMidnightDiner", WZUIFreeTextBox)
	local sFormat = [[<I Z="0.5" P="1">%s</I><T C="255,255,255" S="20" P="1" SC="132,66,29" SS="4" SE="1">%d</T>]]
	if ftxtLightNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
		ftxtLightNum:setShowText(string.format(sFormat, basicData.icon, nLightNum))
	end
end

--@brief 	初始化活动时间
function WndMidnightDiner:_initActivityTime()
	-- body
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndMidnightDiner", WZUILabelTTF)
    if txtActivityTime then 
    	txtActivityTime:setText(LocalStrings.ACTIVITY_TIME_KEY .. ":" .. needDay_str)
    end
end

--@brief 	显示开启动画
function WndMidnightDiner:showOpenAction()
	-- body
	--创建选中特效
	local spinePath = "activity/common_pic_shitang"
	local existSpine = CheckEffectFile(spinePath)
	if not existSpine then 
		local _sIndex = "common_pic_shitang"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7058, downloadInfo.url, downloadInfo.md5, _sIndex, "DownloadResourceCallback", _G)
        end
	end

	local spineOpen = GetElement(self.m_root, "spineOpen_WndMidnightDiner", WZUISpine)
	if spineOpen then 
		if existSpine then 
			self:_setBowlingPlayAni_Two(2, false)
			local delayTime = 1
			if self.m_nPoleType == 1 then 
				delayTime = 0.7
			elseif self.m_nPoleType == 2 then 
				delayTime = 0.5
			end
			spineOpen:enableSchedule("showShootReward", delayTime)
		else
			self:showShootReward()
		end
	end
end

--@brief 	显示开启奖励
function WndMidnightDiner:showShootReward()
	-- body
	WZLog("WndMidnightDiner:showShootReward")
	local spineOpen = GetElement(self.m_root, "spineOpen_WndMidnightDiner", WZUISpine)
	spineOpen:disableSchedule()
	self:_setBowlingPlayAni_Two(1, true)

	self:setOpenState(false)
	self:_afterCloseReward()
end

--@brief 	iphoneX适配
function WndMidnightDiner:_adaptIphoneX()
	if IsIphoneX() then
		GetElement(self.m_root, "conLeftMenu_WndMidnightDiner", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.045,1))
	end
end

--@brief 	设置免费丢
function WndMidnightDiner:_setFreeBtnText()
	local txtBtnOpenOne = GetElement(self.m_root, "txtBtnOpenOne_WndMidnightDiner", WZUILabelTTF)
	local txtBtnOpenFive = GetElement(self.m_root, "txtBtnOpenFive_WndMidnightDiner", WZUILabelTTF)

	local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local freeTimes = 0 
	local nTempTimes = math.floor(nLightNum/self.m_tGlovesCost[self.m_nPoleType + 1])
	local nTimes = 0
	if self.m_nCount > 0 and self.m_nPoleType == 0 then 
		freeTimes = 1
		txtBtnOpenOne:setText(LocalStrings.MIDNIGHTDINER_TEXT1[7])
		nTimes = (nTempTimes + freeTimes) >= self.m_nMaxLotteryCount and self.m_nMaxLotteryCount or nTempTimes > 0 and (nTempTimes + freeTimes) or self.m_nMaxLotteryCount 
	else
		if self.m_nPoleType == 0 then 
			nTimes = (nTempTimes + freeTimes) >= self.m_nMaxLotteryCount and self.m_nMaxLotteryCount or nTempTimes > 0 and (nTempTimes + freeTimes) or self.m_nMaxLotteryCount 
			txtBtnOpenOne:setText(string.format(LocalStrings.MIDNIGHTDINER_TEXT1[5], 1))
		else
			nTimes = nTempTimes >= self.m_nMaxLotteryCount and self.m_nMaxLotteryCount or nTempTimes > 0 and nTempTimes or self.m_nMaxLotteryCount 
			txtBtnOpenOne:setText(string.format(LocalStrings.MIDNIGHTDINER_TEXT1[6], 1))
		end
	end

	if self.m_nPoleType == 0 then 
		txtBtnOpenFive:setText(string.format(LocalStrings.MIDNIGHTDINER_TEXT1[5], nTimes))
	else
		txtBtnOpenFive:setText(string.format(LocalStrings.MIDNIGHTDINER_TEXT1[6], nTimes))
	end
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndMidnightDiner:_setBowlingPlayAni(aniIndex, bLoop)
	local spineOpen = GetElement(self.m_root, "spineOpen_WndMidnightDiner", WZUISpine)
	local imgFood = GetElement(self.m_root, "imgFood_WndMidnightDiner", WZUIImage)
	aniIndex = aniIndex or 1
	WZLog("WndMidnightDiner:_setBowlingPlayAni", self.m_nPoleType, aniIndex, bLoop, self.m_tBallAniName[self.m_nPoleType + 1][3])
	if aniIndex == 1 then 
		imgFood:setRelativePosition(GlobalMethod:ccp(0.505, self.m_tBallAniName[self.m_nPoleType + 1][3]))
		imgFood:setFile(self.m_tBallAniName[self.m_nPoleType + 1][aniIndex])
		spineOpen:setVisible(false)
	else
		if spineOpen then 
			spineOpen:setVisible(true)
			spineOpen:play(self.m_tBallAniName[self.m_nPoleType + 1][aniIndex], bLoop ~= nil and bLoop or true)
		end
		imgFood:setVisible(false)
	end
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndMidnightDiner:_setBowlingPlayAni_Two(aniIndex, bLoop)
	local spineOpen = GetElement(self.m_root, "spineOpen_WndMidnightDiner", WZUISpine)
	local imgFood = GetElement(self.m_root, "imgFood_WndMidnightDiner", WZUIImage)
	aniIndex = aniIndex or 1
	WZLog("WndMidnightDiner:_setBowlingPlayAni_Two", self.m_nPoleType, aniIndex, bLoop)
	if aniIndex == 1 then 
		imgFood:setVisible(true)
		spineOpen:setVisible(false)
	else
		if spineOpen then 
			spineOpen:setVisible(true)
			spineOpen:play(self.m_tBallAniName[self.m_nPoleType + 1][aniIndex], bLoop ~= nil and bLoop or true)
		end
		imgFood:setVisible(false)
	end
end

--@brief 	显示深夜打卡随机任务
function WndMidnightDiner:_showRandomTask()
	if self.m_tRandomTaskInfo == nil then return end 
	
	if self.m_nRandomTaskEndTime <= 0 or self.m_nRandomTaskEndTime <= SystemTime:getServerTime() then 
		self.m_conTeamReward:setVisible(false)
		return 
	end

	local configInfo = GDatatab_new_activity_task["id_" .. self.m_tRandomTaskInfo.id]
	if configInfo then 
		self.m_conTeamReward:setVisible(true)
		local ftxtTaskDesc = GetElement(self.m_root, "ftxtTaskDesc_WndMidnightDiner", WZUIFreeTextBox)
		local nRealProgress = self.m_tRandomTaskInfo.progress > self.m_tRandomTaskInfo.target and self.m_tRandomTaskInfo.target or self.m_tRandomTaskInfo.progress
		local strContent = string.format(configInfo.desc, nRealProgress .. "/" .. self.m_tRandomTaskInfo.target)
		ftxtTaskDesc:setShowText(strContent)

		if self.m_bIsNeedRefresh then 
			self.m_bIsNeedRefresh = false 
			local tbTeamReward = GetElement(self.m_root, "tbTeamReward_WndMidnightDiner", WZUITableContainer)
			tbTeamReward:cleanTable()

			for i = 1, #configInfo.reward do
				local element, tNewObj = CellGoodItem:createElement()
				if element and tNewObj then 
					element:setTag(i - 1)
					element:setScale(0.75)
					tNewObj:setCellGoodLocalId(configInfo.reward[i][1], configInfo.reward[i][2], 17)
					tNewObj:setItemClickFun(self, self.onItemClick)
					tbTeamReward:setCellElement(element)

					if self.m_tRandomTaskInfo.status == 0 then 
						local spine = WZUISpine:create()
					   	spine:setTouchEnable(false)
					   	spine:setFileJson("ui/ui_common_JJLQ.json")
					   	spine:setFileAtlas("ui/ui_common_JJLQ.atlas")
					   	spine:setUseOriginSize(true)
					   	spine:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
						spine:play("wait_1",true)
					   	element:addChild(spine,1)
					end
				end
			end
		end

		if self.m_tRandomTaskInfo.status == 1 then 
			GetElement(self.m_conTeamReward, "imgDone_WndMidnightDiner", WZUIImage):setVisible(true)
		else
			GetElement(self.m_conTeamReward, "imgDone_WndMidnightDiner", WZUIImage):setVisible(false)
		end
		local txtLeftTime = GetElement(self.m_root, "txtLeftTime_WndMidnightDiner", WZUILabelTTF)
		local nSeconds = self.m_nRandomTaskEndTime - SystemTime:getServerTime()
		local strTime = returnToTimeFormat(nSeconds)
		txtLeftTime:setText(strTime)
	end
end

--@brief 	计时器
function WndMidnightDiner:_caculateTime()
	if self.m_conTeamReward and self.m_conTeamReward:isVisible() then 
		if self.m_nRandomTaskEndTime > 0 and self.m_nRandomTaskEndTime > SystemTime:getServerTime() then 
			local txtLeftTime = GetElement(self.m_root, "txtLeftTime_WndMidnightDiner", WZUILabelTTF)
			local nSeconds = self.m_nRandomTaskEndTime - SystemTime:getServerTime()
			local strTime = returnToTimeFormat(nSeconds)
			txtLeftTime:setText(strTime)
		else
			self.m_conTeamReward:setVisible(false)
		end
	end

	self.m_nRefreshTime = self.m_nRefreshTime + 1 
	if self.m_nRefreshTime >= 10 then 
		self.m_nRefreshTime = 0
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 7, "")
	end
end

--@brief 	刷新赛事礼包的信息
function WndMidnightDiner:showBagGiftInfo()
	-- body
	if self.m_nGiftRewardNum > 0 then 
		GetElement(self.m_root, "spineGift_WndMidnightDiner", WZUISpine):setVisible(true)
		GetElement(self.m_root, "imgGiftRed_WndMidnightDiner", WZUIImage):setVisible(true)
		GetElement(self.m_root, "txtGiftNum_WndMidnightDiner", WZUILabelTTF):setText(self.m_nGiftRewardNum)
	else
		GetElement(self.m_root, "spineGift_WndMidnightDiner", WZUISpine):setVisible(false)
		GetElement(self.m_root, "imgGiftRed_WndMidnightDiner", WZUIImage):setVisible(false)
	end
end

--@brief 	设置待机特效
function WndMidnightDiner:_setBallAni()
	local spinePath = "activity/common_pic_shitang"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		local spineOpen = GetElement(self.m_root, "spineOpen_WndMidnightDiner", WZUISpine)
		local spineGift = GetElement(self.m_root, "spineGift_WndMidnightDiner", WZUISpine)
		local spineLight = GetElement(self.m_root, "spineLight_WndMidnightDiner", WZUISpine)
		if spineOpen then 
			spineOpen:setFileJson(spinePath .. ".json")
			spineOpen:setFileAtlas(spinePath .. ".atlas")
			self:_setBowlingPlayAni(1, true)
		end
		if spineGift then 
			spineGift:setFileJson(spinePath .. ".json")
			spineGift:setFileAtlas(spinePath .. ".atlas")
			spineGift:play("wait5", true)
		end
		if spineLight then 
			spineLight:setFileJson(spinePath .. ".json")
			spineLight:setFileAtlas(spinePath .. ".atlas")
			spineLight:play("wait", true)
		end
	else
		local _sIndex = "common_pic_shitang"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7055, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndMidnightDiner)
        end
	end
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配Begin----------------------------------------

function WndMidnightDiner:_adaptLanguage_vn()
	GetElement(self.m_root, "txtActivityTime_WndMidnightDiner", WZUILabelTTF):setFontSize(16)

	for i=1,3 do
		local txtTask = GetElement(self.m_root, "txtTask"..i.."_WndMidnightDiner", WZUILabelTTF)
		txtTask:setFontSize(14)
		txtTask:setDimensions(GlobalMethod:CCSize(50,0))
		local txtTaskSel = GetElement(self.m_root, "txtTaskSel"..i.."_WndMidnightDiner", WZUILabelTTF)
		txtTaskSel:setFontSize(14)
		txtTaskSel:setDimensions(GlobalMethod:CCSize(50,0))
	end
end

-------------------------------------语言适配End----------------------------------------
