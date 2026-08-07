--WndCrazyGashapon.lua
--@brief	WndCrazyGashapon的UI模块
--@date		2022/09/13
--@author	yrd
--@note		疯狂扭蛋


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCrazyGashapon:onEnter(element)
	self.m_root = element

	g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
	ProtocolProcessorFestivalActivity:regAll6()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)

	self:_initStaticText()
	self:_setBallAni()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCrazyGashapon:onExit(element)
	g_bIsShowWndDressUp = true
    g_tTempItemForLaterShow = {}
	CacheCenter:unregisterUpatePlayerItemObserver(self)
	ProtocolProcessorFestivalActivity:unregAll6()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)

	self:_unInit()
	LoadNewActivityRes(false)
end

--@brief    onenter函数已执行
function WndCrazyGashapon:onEnterTransitionDidFinish(element)
    WZLog("WndCrazyGashapon:onEnterTransitionDidFinish")
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7057, 7057)
end

--@brief    点击关闭按钮
function WndCrazyGashapon:onClickClose(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击说明按钮
function WndCrazyGashapon:onClickRule(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSingleMapDesc:showInterface1(LocalStrings.CRAZY_GASHAPON_TEXT2)
end

--@brief 	初始化活动时间
function WndCrazyGashapon:_initActivityTime()
	local DayStartTab = os.date("*t", self.m_nStartTime)
	local DayEndTab = os.date("*t", self.m_nEndTime)

	local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
	local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndCrazyGashapon", WZUILabelTTF)
	if txtActivityTime then 
		txtActivityTime:setText(LocalStrings.ACTIVITY_TIME_KEY .. ":" .. needDay_str)
	end
end

--@brief 	点击目标按钮回调
function WndCrazyGashapon:onClickCheck(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if nTag == 1 then 
		CellNewYearTask:showInterface(17, self.m_nActivityId)
	elseif nTag == 2 then
		WndCrazyGashaponShake:showInterface(self.m_nActivityId)
	elseif nTag == 3 then 
		WndShopRank:showInterface(31, self.m_nActivityId) 
	end
end

--@brief 	点击大奖预览按钮回调
function WndCrazyGashapon:onClickBigReward(element)
	local eleType = type(element)
	if eleType ~= "number" then 
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	end

	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, "")
end

--@brief 	点击开启按钮回调
function WndCrazyGashapon:onClickFive(element)
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
		SaveOperateTimes("CRAZYGASHAPONACTIVITYID", self.m_nActivityId)
    	return 
    end

	local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local freeCount = 0
	local nTempTimes = nArrowNum
	freeCount = self.m_nCount > 0 and 1 or 0 
	local nTimes = nTag
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
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 3, stringData)
end

--@brief 	前往小推车购买
function WndCrazyGashapon:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief 	设置静态文本
function WndCrazyGashapon:_initStaticText()
	GetElement(self.m_root,"txtBtn1_1_WndCrazyGashapon",WZUILabelTTF):setText(LocalStrings.CRAZY_GASHAPON_TEXT1[2])
	GetElement(self.m_root,"txtBtn1_2_WndCrazyGashapon",WZUILabelTTF):setText(LocalStrings.CRAZY_GASHAPON_TEXT1[2])
	GetElement(self.m_root,"txtBtn2_1_WndCrazyGashapon",WZUILabelTTF):setText(LocalStrings.CRAZY_GASHAPON_TEXT1[3])
	GetElement(self.m_root,"txtBtn2_2_WndCrazyGashapon",WZUILabelTTF):setText(LocalStrings.CRAZY_GASHAPON_TEXT1[3])
	GetElement(self.m_root,"txtBtn3_1_WndCrazyGashapon",WZUILabelTTF):setText(LocalStrings.CRAZY_GASHAPON_TEXT1[4])
	GetElement(self.m_root,"txtBtn3_2_WndCrazyGashapon",WZUILabelTTF):setText(LocalStrings.CRAZY_GASHAPON_TEXT1[4])
end

--@brief 	刷新
function WndCrazyGashapon:_update()
	self:_setFreeBtnText()
	self:showRedDot()
	self:_initActivityTime()
	self:_updateLightNum()
	self:_updateDoubleProg()
	if self.m_bIsFirstIn then 
		self.m_bIsFirstIn = false 
		self:_setBowlingPlayAni(1, true)
	end
	-- self:showBagGiftInfo()
end

--@brief 	设置免费按钮文本
function WndCrazyGashapon:_setFreeBtnText()
	local txtGashapon1 = GetElement(self.m_root, "txtGashapon1_WndCrazyGashapon", WZUILabelTTF)
	local txtGashapon2 = GetElement(self.m_root, "txtGashapon2_WndCrazyGashapon", WZUILabelTTF)

	local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local freeTimes = self.m_nCount
	local nTempTimes = math.floor(nLightNum/self.m_tCostTimes)
	local nTimes = (nTempTimes + freeTimes) >= self.m_nMaxLotteryCount and self.m_nMaxLotteryCount or nTempTimes > 0 and (nTempTimes + freeTimes) or self.m_nMaxLotteryCount 
	txtGashapon2:setText(string.format(LocalStrings.CRAZY_GASHAPON_TEXT1[5], nTimes))

	local str1 = ""
	if freeTimes > 0 then
		str1 = LocalStrings.CRAZY_GASHAPON_TEXT1[12]
	else
		str1 = string.format(LocalStrings.CRAZY_GASHAPON_TEXT1[5], 1)
	end
	txtGashapon1:setText(str1)
end

--@brief 	红点
function WndCrazyGashapon:showRedDot()
	if self.m_root == nil then return end 

	local imgTaskRedDot = GetElement(self.m_root, "imgTaskRedDot_WndCrazyGashapon", WZUIImage)

	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[117057] or GlobalGame.g_tRedPointTypeList[127057]) then
		imgTaskRedDot:setVisible(true)
	else
		imgTaskRedDot:setVisible(false)
	end
end

--@brief 	更新货币的数量
function WndCrazyGashapon:_updateLightNum()
	if self.m_root == nil then return end

	local imgMoney = GetElement(self.m_root, "imgMoney_WndCrazyGashapon", WZUIImage)
	local txtMoney = GetElement(self.m_root, "txtMoney_WndCrazyGashapon", WZUILabelTTF)
	local nCostId = self.m_nCoinId
	local basicData = GDatatab_item["id_" .. nCostId]
	local nLightNum = CacheCenter:getPlayerItemCountById(nCostId)
	imgMoney:setFile(basicData.icon)
	txtMoney:setText(nLightNum)
end

--@brief 	更新翻倍文本
function WndCrazyGashapon:_updateDoubleProg()
	if self.m_root == nil then return end

	local txtDouble = GetElement(self.m_root, "txtDouble_WndCrazyGashapon", WZUILabelTTF)
	txtDouble:setText(self.m_tRewardCounts[2] .."/".. self.m_tFinishCondition[2])
	local progDouble = GetElement(self.m_root, "progDouble_WndCrazyGashapon", WZUIProgress)
	progDouble:setPercentage(self.m_tRewardCounts[2] / self.m_tFinishCondition[2] * 100)

	local txtGashapon4 = GetElement(self.m_root, "txtGashapon4_WndCrazyGashapon", WZUILabelTTF)
	txtGashapon4:setText(self.m_tRewardCounts[1] .. LocalStrings.SHOP_CISHU)

	local txtGashapon3 = GetElement(self.m_root,"txtGashapon3_WndCrazyGashapon",WZUILabelTTF)
	local number = self.m_tFinishCondition[4]
	if ProjConfig.LANGUAGE == "cn" then
		number = self:convertNum2chinese(number)
	end
	txtGashapon3:setText(string.format(LocalStrings.CRAZY_GASHAPON_TEXT1[6],number))
end

--@brief 	设置待机特效
function WndCrazyGashapon:_setBallAni()
	local spinePath = "activity/hd_pic_niudang"
	local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".json")
	if existSpine then 
		local spineOpen = GetElement(self.m_root, "spineOpen_WndCrazyGashapon", WZUISpine)
		if spineOpen then 
			spineOpen:setFileJson(spinePath .. ".json")
			spineOpen:setFileAtlas(spinePath .. ".atlas")
			self:_setBowlingPlayAni(1, true)
		end
	else
		local _sIndex = "hd_pic_niudang"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7057, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndCrazyGashapon)
        end
	end
end

function WndCrazyGashapon:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndCrazyGashapon:downloadEffectCallback",taskId,extraData,failed)
    self:_setBallAni()
end

--@brief 	显示开启动画
function WndCrazyGashapon:showOpenAction()
	--创建选中特效
	local spinePath = "activity/hd_pic_niudang"
	local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".json")
	if not existSpine then 
		local _sIndex = "hd_pic_niudang"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7057, downloadInfo.url, downloadInfo.md5, _sIndex, "DownloadResourceCallback", _G)
        end
	end

	local spineOpen = GetElement(self.m_root, "spineOpen_WndCrazyGashapon", WZUISpine)
	if spineOpen then 
		if existSpine then 
			self:_setBowlingPlayAni(2, false)
			spineOpen:enableSchedule("showShootReward", 1.2)
		else
			self:showShootReward()
		end
	end
end

--@brief 	显示开启奖励
function WndCrazyGashapon:showShootReward()
	local spineOpen = GetElement(self.m_root, "spineOpen_WndCrazyGashapon", WZUISpine)
	spineOpen:disableSchedule()
	self:_setBowlingPlayAni(1, true)

	--获得的时光券
	if self.m_tOpenResult.medalNum > 0 then 
		local strGoods = ""
		local basicData = GDatatab_item["id_"..self.m_nRewardCoinId1]
		strGoods = strGoods .. LocalStrings.GET .. basicData.name .. "*" .. self.m_tOpenResult.medalNum
		MsgBoxManager:showTipBox(strGoods, nil, nil, nil, nil, nil, nil, nil, nil, {x=0.5, y=0.78})
	end

	self:setOpenState(false)
	self:_afterCloseReward()
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndCrazyGashapon:_setBowlingPlayAni(aniIndex, bLoop)
	local spineOpen = GetElement(self.m_root, "spineOpen_WndCrazyGashapon", WZUISpine)
	aniIndex = aniIndex or 1
	WZLog("WndCrazyGashapon:_setBowlingPlayAni", aniIndex, bLoop)
	if spineOpen then 
		spineOpen:play(self.m_tAniAction[aniIndex], bLoop ~= nil and bLoop or true)
	end
end

-------------------------------------私有方法模块End----------------------------------------
