--WndWorshipGod.lua
--@brief	WndWorshipGod的UI模块
--@date		2022/12/27
--@author	XTX
--@note		拜财神活动界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndWorshipGod:onEnter(element)
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
function WndWorshipGod:onExit(element)
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
function WndWorshipGod:onEnterTransitionDidFinish(element)
    WZLog("WndWorshipGod:onEnterTransitionDidFinish")
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7062, 7062)
end

--@brief    关闭窗口
function WndWorshipGod:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    --如果是自动弹出的活动界面
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮回调
function WndWorshipGod:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 
    WndSingleMapDesc:showInterface1(LocalStrings.WORSHIPGOD_TEXT2) 
end

--@brief 	点击目标按钮回调
function WndWorshipGod:onClickTask(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if nTag == 1 then 
		CellNewYearTask:showInterface(21, self.m_nActivityId)
	elseif nTag == 2 then
		WndShopRank:showInterface(37, self.m_nActivityId) 
	elseif nTag == 3 then --紅包雨
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId3)
		if nLightNum <= 0 then 
			MsgBoxManager:showTipBox(LocalStrings.WORSHIPGOD_TEXT1[20])
		else
			if WndChallengeLevel.m_root == nil then 
				WndChallengeLevel:showInterface(3, nLightNum, 0, self.m_tRedPackConfig, self.m_nActivityId)
			end
		end
	elseif nTag == 4 then --招財進寶
		WndBringTreasure:showInterface(self.m_nActivityId)
	end
end

--@brief 	点击大奖预览按钮回调
function WndWorshipGod:onClickBigReward(element)
	-- body
	local eleType = type(element)
	if eleType ~= "number" then 
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	end

	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, "")
end

--@brief 	点击开启按钮回调
function WndWorshipGod:onClickFive(element)
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
		SaveOperateTimes("WORSHIPGODACTIVITYID", self.m_nActivityId)
    	return 
    end

	local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local nTempTimes = nArrowNum
	local nTimes = nTag
	local freeCount = 0
	freeCount = self.m_nCount > 0 and 1 or 0 
	self.m_nAniType = 2
	if nTag == 5 then 
		self.m_nAniType = 3
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
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 3, stringData)
end

--@brief 	前往小推车购买
function WndWorshipGod:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

--@brief	设置是否显示烟花
function WndWorshipGod:onSetting()
	WZLog("WndWorshipGod:onSetting")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local selCheckBox = GetElement(self.m_root,"checkBox_WndWorshipGod",WZUICheckBox)
	SETSHOWREDPACKRAIN = selCheckBox:getCheckIndex()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndWorshipGod:_update()
	-- body
	self:_setFreeBtnText()
	self:showRedDot()
	self:_initActivityTime()
    self:_updateLightNum()
    self:_showLeftRedPackNum()
end

--@brief 	初始化静态文本
function WndWorshipGod:_initStaticText()
	GetElement(self.m_root, "txtBigReward_WndWorshipGod", WZUILabelTTF):setText(LocalStrings.WORSHIPGOD_TEXT1[3])
	GetElement(self.m_root, "txtBtnTask1_WndWorshipGod", WZUILabelTTF):setText(LocalStrings.WORSHIPGOD_TEXT1[1])
	GetElement(self.m_root, "txtBtnTask1Sel_WndWorshipGod", WZUILabelTTF):setText(LocalStrings.WORSHIPGOD_TEXT1[1])
	GetElement(self.m_root, "txtBtnTask2_WndWorshipGod", WZUILabelTTF):setText(LocalStrings.WORSHIPGOD_TEXT1[6])
	GetElement(self.m_root, "txtBtnTask2Sel_WndWorshipGod", WZUILabelTTF):setText(LocalStrings.WORSHIPGOD_TEXT1[6])
	GetElement(self.m_root, "txtRedRain_WndWorshipGod", WZUILabelTTF):setText(LocalStrings.WORSHIPGOD_TEXT1[15])
	GetElement(self.m_root, "txtSetting_WndWorshipGod", WZUILabelTTF):setText(LocalStrings.WORSHIPGOD_TEXT1[21])
	GetElement(self.m_root, "txtSettingSel_WndWorshipGod", WZUILabelTTF):setText(LocalStrings.WORSHIPGOD_TEXT1[21])
	GetElement(self.m_root,"checkBox_WndWorshipGod",WZUICheckBox):setCheckIndex(SETSHOWREDPACKRAIN)

	self:_setBallAni()
end

--@brief 	红点
function WndWorshipGod:showRedDot()
	-- body
	if self.m_root == nil then return end 

	local imgTaskRedDot = GetElement(self.m_root, "imgTaskRedDot_WndWorshipGod", WZUIImage)

	if GlobalGame.g_tRedPointTypeList[217062] or GlobalGame.g_tRedPointTypeList[227062] or GlobalGame.g_tRedPointTypeList[237062] then 
		imgTaskRedDot:setVisible(true)
	else
		imgTaskRedDot:setVisible(false)
	end
end

--@brief 	更新异火的数量
function WndWorshipGod:_updateLightNum()
	-- body
	local ftxtLightNum = GetElement(self.m_root, "ftxtLightNum_WndWorshipGod", WZUIFreeTextBox)
	local sFormat = [[<I Z="0.5" P="1">%s</I><T C="255,236,193" S="20" P="1" SC="132,66,29" SS="4" SE="0">%d</T>]]
	if ftxtLightNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
		ftxtLightNum:setShowText(string.format(sFormat, basicData.icon, nLightNum))
	end
end

--@brief 	初始化活动时间
function WndWorshipGod:_initActivityTime()
	-- body
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndWorshipGod", WZUILabelTTF)
    local txtActivityTimeW = GetElement(self.m_root, "txtActivityTimeW_WndWorshipGod", WZUILabelTTF)
    	txtActivityTimeW:setText(LocalStrings.ACTIVITY_TIME_KEY)
    if txtActivityTime then 
    	txtActivityTime:setText(needDay_str)
    end
end

--@brief 	显示开启动画
function WndWorshipGod:showOpenAction()
	-- body
	--创建选中特效
	local spinePath = "activity/hd_pic_caisheng"
	local existSpine = CheckEffectFile(spinePath)
	if not existSpine then 
		local _sIndex = "hd_pic_caisheng"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7062, downloadInfo.url, downloadInfo.md5, _sIndex, "DownloadResourceCallback", _G)
        end
	end

	local spineOpen = GetElement(self.m_root, "spineOpen_WndWorshipGod", WZUISpine)
	if spineOpen then 
		if existSpine then 
			self:_setBowlingPlayAni(self.m_nAniType, false)
			spineOpen:enableSchedule("showShootReward", 1.2)
		else
			self:showShootReward()
		end
	end
end

--@brief 	显示开启奖励
function WndWorshipGod:showShootReward()
	-- body
	local spineOpen = GetElement(self.m_root, "spineOpen_WndWorshipGod", WZUISpine)
	spineOpen:disableSchedule()
	self:_setBowlingPlayAni(1, true)

	self:setOpenState(false)
	self:_afterCloseReward()
end

--@brief 	iphoneX适配
function WndWorshipGod:_adaptIphoneX()
	if IsIphoneX() then
		
	end
end

--@brief 	设置免费丢
function WndWorshipGod:_setFreeBtnText()
	local txtBtnOpenOne = GetElement(self.m_root, "txtBtnOpenOne_WndWorshipGod", WZUILabelTTF)
	local txtBtnOpenFive = GetElement(self.m_root, "txtBtnOpenFive_WndWorshipGod", WZUILabelTTF)

	local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local freeTimes = 0 
	local nTempTimes = nLightNum
	local nTimes = 0
	if self.m_nCount > 0 then 
		freeTimes = 1
		txtBtnOpenOne:setText(LocalStrings.WORSHIPGOD_TEXT1[13])
	else
		txtBtnOpenOne:setText(string.format(LocalStrings.WORSHIPGOD_TEXT1[5], 1))
	end
	nTimes = (nTempTimes + freeTimes) >= self.m_nMaxLotteryCount and self.m_nMaxLotteryCount or nTempTimes > 0 and (nTempTimes + freeTimes) or self.m_nMaxLotteryCount 

	txtBtnOpenFive:setText(string.format(LocalStrings.WORSHIPGOD_TEXT1[5], nTimes))
end

--@brief 	设置待机特效
function WndWorshipGod:_setBallAni()
	local spinePath = "activity/hd_pic_caisheng"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		local spineOpen = GetElement(self.m_root, "spineOpen_WndWorshipGod", WZUISpine)
		if spineOpen then 
			spineOpen:setFileJson(spinePath .. ".json")
			spineOpen:setFileAtlas(spinePath .. ".atlas")
			self:_setBowlingPlayAni(1, true)
		end
	else
		local _sIndex = "hd_pic_caisheng"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7062, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndWorshipGod)
        end
	end
end

function WndWorshipGod:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndWorshipGod:downloadEffectCallback",taskId,extraData,failed)
    self:_setBallAni()
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndWorshipGod:_setBowlingPlayAni(aniIndex, bLoop)
	local spineOpen = GetElement(self.m_root, "spineOpen_WndWorshipGod", WZUISpine)
	aniIndex = aniIndex or 1
	WZLog("WndWorshipGod:_setBowlingPlayAni", aniIndex, bLoop)
	if spineOpen then 
		spineOpen:play(self.m_tBallAniName[aniIndex], bLoop ~= nil and bLoop or true)
	end
end

--@brief 	显示红包剩余次数
function WndWorshipGod:_showLeftRedPackNum()
	local txtRedPackNum = GetElement(self.m_root, "txtRedPackNum_WndWorshipGod", WZUILabelTTF)
	if txtRedPackNum then 
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId3)
		txtRedPackNum:setText(nLightNum)
	end
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配模块Begin----------------------------------------

function WndWorshipGod:_adaptLanguage_vn()
	GetElement(self.m_root, "txtSetting_WndWorshipGod", WZUILabelTTF):setFontSize(12)
	GetElement(self.m_root, "txtSettingSel_WndWorshipGod", WZUILabelTTF):setFontSize(12)
	GetElement(self.m_root, "txtActivityTime_WndWorshipGod", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.181,0.59))

	GetElement(self.m_root, "txtBtnOpenOne_WndWorshipGod", WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root, "txtBtnOpenFive_WndWorshipGod", WZUILabelTTF):setFontSize(18)
end

-------------------------------------语言适配模块End----------------------------------------

