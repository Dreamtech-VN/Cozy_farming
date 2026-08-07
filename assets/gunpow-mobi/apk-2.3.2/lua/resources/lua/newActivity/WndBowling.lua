--WndBowling.lua
--@brief	WndBowling的UI模块
--@date		2022/04/21
--@author	XTX
--@note		保龄球活动主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndBowling:onEnter(element)
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
	self.m_root:enableSchedule("_caculateTime", 1)

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndBowling:onExit(element)
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
function WndBowling:onEnterTransitionDidFinish(element)
    WZLog("WndBowling:onEnterTransitionDidFinish")
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7049, 7049)
end

--@brief    关闭窗口
function WndBowling:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    --如果是自动弹出的活动界面
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮回调
function WndBowling:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 
    WndSingleMapDesc:showInterface1(LocalStrings.BOWLING_TEXT2) 
end

--@brief 	点击目标按钮回调
function WndBowling:onClickTask(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if nTag == 1 then 
		CellNewYearTask:showInterface(13, self.m_nActivityId)
	elseif nTag == 2 then
		WndDollMachineShop:showInterface(5, self.m_nActivityId)
	elseif nTag == 3 then 
		WndShopRank:showInterface(24, self.m_nActivityId) 
	end
end

--@brief 	点击大奖预览按钮回调
function WndBowling:onClickBigReward(element)
	-- body
	local eleType = type(element)
	if eleType ~= "number" then 
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	end

	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, "")
end

--@brief 	点击开启按钮回调
function WndBowling:onClickFive(element)
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
		SaveOperateTimes("BOWLINGACTIVITYID", self.m_nActivityId)
    	return 
    end

	self:_showTalk()
	local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local freeCount = 0
	local nTempTimes = nArrowNum
	if self.m_nBowlType == 0 then
		freeCount = self.m_nCount > 0 and 1 or 0 
	else
		nTempTimes = math.floor(nArrowNum/2)
	end
	local nTimes = nTag
	if nTag == 5 then 
		nTag = 20 
		nTimes = (nTempTimes + freeCount) >= 20 and 20 or nTempTimes > 0 and (nTempTimes + freeCount) or 20 
	end
	local nCostNum = nTimes
	if self.m_nBowlType == 1 then
		nCostNum = nTimes * self.m_nHighTypeCostTimes
	end
	if nCostNum - freeCount > nArrowNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		MsgBoxManager:showConfirmBox(string.format(LocalStrings.WATERCOUNTRY_TEXT4, basicData.name), self, self.goToBuy)
		return 
	end
    local tData = {}
	tData.times = nTag
	tData.grade = self.m_nBowlType

	local stringData = json.encode(tData)

	self:setOpenState(true)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 3, stringData)
end

--@brief 	前往小推车购买
function WndBowling:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

--@brief 	点击切换场地等级回调
function WndBowling:onChooseTool(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local nTag = element:getTag()
	self.m_nBowlType = nTag
	self:_setFreeBtnText()
	if not self.m_bOpenState then 
		self:_setBowlingPlayAni(1, true)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndBowling:_update()
	-- body
	self:_setFreeBtnText()
	self:showRedDot()
	self:_initActivityTime()
    self:_updateLightNum()
end

--@brief 	初始化静态文本
function WndBowling:_initStaticText()
--	GetElement(self.m_root, "txtBigReward_WndBowling", WZUILabelTTF):setText(LocalStrings.BOWLING_TEXT1[7])
	GetElement(self.m_root, "txtBtnTask1_WndBowling", WZUILabelTTF):setText(LocalStrings.BOWLING_TEXT1[2])
	GetElement(self.m_root, "txtBtnTask3_WndBowling", WZUILabelTTF):setText(LocalStrings.BOWLING_TEXT1[3])
	GetElement(self.m_root, "txtBtnTask2_WndBowling", WZUILabelTTF):setText(LocalStrings.BOWLING_TEXT1[11])
	GetElement(self.m_root, "txtJuniorPlace_WndBowling", WZUILabelTTF):setText(LocalStrings.BOWLING_TEXT1[13])
	GetElement(self.m_root, "txtJuniorPlaceSel_WndBowling", WZUILabelTTF):setText(LocalStrings.BOWLING_TEXT1[13])
	GetElement(self.m_root, "txtSeniorPlace_WndBowling", WZUILabelTTF):setText(LocalStrings.BOWLING_TEXT1[14])
	GetElement(self.m_root, "txtSeniorPlaceSel_WndBowling", WZUILabelTTF):setText(LocalStrings.BOWLING_TEXT1[14])
	GetElement(self.m_root, "txtEggAtt_WndBowling", WZUILabelTTF):setText(LocalStrings.BOWLING_TEXT1[17])

	self:_setBallAni()
end

--@brief 	红点
function WndBowling:showRedDot()
	-- body
	if self.m_root == nil then return end 

	local imgTaskRedDot = GetElement(self.m_root, "imgTaskRedDot_WndBowling", WZUIImage)

	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[117049] or GlobalGame.g_tRedPointTypeList[127049]) then 
		imgTaskRedDot:setVisible(true)
	else
		imgTaskRedDot:setVisible(false)
	end
end

--@brief 	更新异火的数量
function WndBowling:_updateLightNum()
	-- body
	local ftxtLightNum = GetElement(self.m_root, "ftxtLightNum_WndBowling", WZUIFreeTextBox)
	local sFormat = [[<I Z="0.5" P="1">%s</I><T C="255,255,255" S="20" P="1" SC="132,66,29" SS="4" SE="1">%d</T>]]
	if ftxtLightNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
		ftxtLightNum:setShowText(string.format(sFormat, basicData.icon, nLightNum))
	end
end

--@brief 	初始化活动时间
function WndBowling:_initActivityTime()
	-- body
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndBowling", WZUILabelTTF)
    if txtActivityTime then 
    	txtActivityTime:setText(LocalStrings.ACTIVITY_TIME_KEY .. ":" .. needDay_str)
    end
end

--@brief 	显示开启动画
function WndBowling:showOpenAction()
	-- body
	--创建选中特效
	local spinePath = "activity/ui_activity_ddblq"
	local existSpine = CheckEffectFile(spinePath)
	if not existSpine then 
		local _sIndex = "ui_activity_ddblq"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7050, downloadInfo.url, downloadInfo.md5, _sIndex, "DownloadResourceCallback", _G)
        end
	end

	local spineOpen = GetElement(self.m_root, "spineOpen_WndBowling", WZUISpine)
	if spineOpen then 
		if existSpine then 
			self:_setBowlingPlayAni(2, false)
			spineOpen:enableSchedule("showShootReward", 1)
		else
			self:showShootReward()
		end
	end
end

--@brief 	显示开启奖励
function WndBowling:showShootReward()
	-- body
	local spineOpen = GetElement(self.m_root, "spineOpen_WndBowling", WZUISpine)
	spineOpen:disableSchedule()
	self:_setBowlingPlayAni(1, true)

	local strGoods = ""
	--击中多少球
	if #self.m_tOpenResult.target == 1 then 
		strGoods = string.format(LocalStrings.BOWLING_TEXT1[15], self.m_tOpenResult.target[1])
	else
		local strCircle = ""
		for i = 1, #self.m_tOpenResult.target do
			if i > 1 then 
				strCircle = strCircle .. ", "
			end
			strCircle = strCircle .. tostring(self.m_tOpenResult.target[i])
		end
		strGoods = string.format(LocalStrings.BOWLING_TEXT1[16], strCircle)
	end
	--获得的勋章
	if self.m_tOpenResult.medalNum > 0 then 
		if strGoods ~= "" then 
			strGoods = strGoods .. ", "
		end
		local basicData = GDatatab_item["id_160259"]
		strGoods = strGoods .. LocalStrings.GET .. basicData.name .. "*" .. self.m_tOpenResult.medalNum
	end
	--获得的积分
	if self.m_tOpenResult.nScore > 0 then 
		if strGoods ~= "" then 
			strGoods = strGoods .. ", "
		end
		strGoods = strGoods .. LocalStrings.INTEGRATION .. "+" .. self.m_tOpenResult.nScore
	end
	MsgBoxManager:showTipBox(strGoods, nil, nil, nil, nil, nil, nil, nil, nil, {x=0.5, y=0.78})

	self:setOpenState(false)
	self:_afterCloseReward()
end

--@brief 	iphoneX适配
function WndBowling:_adaptIphoneX()
	if IsIphoneX() then
		GetElement(self.m_root, "conLeftMenu_WndBowling", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.13,0.45))
	end
end

--@brief 	设置免费丢
function WndBowling:_setFreeBtnText()
	local txtBtnOpenOne = GetElement(self.m_root, "txtBtnOpenOne_WndBowling", WZUILabelTTF)
	local txtBtnOpenFive = GetElement(self.m_root, "txtBtnOpenFive_WndBowling", WZUILabelTTF)
	local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local freeTimes = 0 
	local nTempTimes = nLightNum
	local nTimes = 0
	if self.m_nCount > 0 then 
		if self.m_nBowlType == 0 then 
			freeTimes = 1
			txtBtnOpenOne:setText(LocalStrings.BOWLING_TEXT1[6])
			nTimes = (nTempTimes + freeTimes) >= 20 and 20 or nTempTimes > 0 and (nTempTimes + freeTimes) or 20 
		else
			nTempTimes = math.floor(nLightNum/self.m_nHighTypeCostTimes)
			txtBtnOpenOne:setText(string.format(LocalStrings.BOWLING_TEXT1[5], 1))
			nTimes = nTempTimes >= 20 and 20 or nTempTimes > 0 and nTempTimes or 20 
		end
	else
		if self.m_nBowlType == 0 then 
			nTimes = (nTempTimes + freeTimes) >= 20 and 20 or nTempTimes > 0 and (nTempTimes + freeTimes) or 20 
		else
			nTempTimes = math.floor(nLightNum/self.m_nHighTypeCostTimes)
			nTimes = nTempTimes >= 20 and 20 or nTempTimes > 0 and nTempTimes or 20 
		end
		txtBtnOpenOne:setText(string.format(LocalStrings.BOWLING_TEXT1[5], 1))
	end
	txtBtnOpenFive:setText(string.format(LocalStrings.BOWLING_TEXT1[5], nTimes))
end

--@brief 	显示咖啡师的对话
function WndBowling:_showTalk()
	local conTalk = GetElement(self.m_root, "conTalk_WndBowling", WZUIContainer)
	conTalk:setVisible(true)

	local txtTalk = GetElement(self.m_root, "txtTalk_WndBowling", WZUILabelTTF)
	local nCount = #LocalStrings.BOWLING_TEXT3
	local tempRand = math.random(1, 10)
	local strIndex = math.fmod(tempRand, nCount) + 1
	if self.m_nLastTalkIndex == strIndex or self.m_nTalkGapping ~= nil then return end 
	self.m_nLastTalkIndex = strIndex
	self.m_nTalkGapping = 5
	txtTalk:setText(LocalStrings.BOWLING_TEXT3[strIndex] or LocalStrings.BOWLING_TEXT3[1])
end

--@brief 	计时器
function WndBowling:_caculateTime()
	-- body
	self.m_nRefreshTime = self.m_nRefreshTime + 1
	if self.m_nRefreshTime >= 8 then 
		self.m_nRefreshTime = 0
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 1, "")
	end
	if self.m_nPaintedEggTime > 0 then 
		self.m_nPaintedEggTime = self.m_nPaintedEggTime - 1
		local txtEggTime = GetElement(self.m_root, "txtEggTime_WndBowling", WZUILabelTTF)
		txtEggTime:setText(LocalStrings.BOWLING_TEXT1[18] .. self.m_nPaintedEggTime .. "S")
		if self.m_nPaintedEggTime == 0 then 
			self.m_PaintedTimeAniIndex = 0
			self:_setBowlingPlayAni()
			GetElement(self.m_root, "conPaitedEgg_WndBowling", WZUIContainer):setVisible(false)
		end
	end
	if self.m_nTalkGapping == nil then return end 

	if self.m_nTalkGapping > 0 then 
		self.m_nTalkGapping = self.m_nTalkGapping - 1
	else
		self.m_nTalkGapping = nil 
		self.m_nLastTalkIndex = 0
		GetElement(self.m_root, "conTalk_WndBowling", WZUIContainer):setVisible(false)
	end
end

--@brief 	设置彩蛋倒计时
function WndBowling:_showPaintedEgg()
	if self.m_nPaintedEggTimesLeft >= 0 and self.m_nPaintedTimeLimit > self.m_nPaintedEggTimesLeft then 
		local txtEggTime = GetElement(self.m_root, "txtEggTime_WndBowling", WZUILabelTTF)
		txtEggTime:setText(string.format(LocalStrings.BOWLING_TEXT1[19], self.m_nPaintedEggTimesLeft))
		GetElement(self.m_root, "conPaitedEgg_WndBowling", WZUIContainer):setVisible(true)
		return 
	end
	if self.m_nPaintedEggTime > 0 then 
		local bIsSwitchAni = false 
		if self.m_PaintedTimeAniIndex == 0 and not self.m_bOpenState then --当初次进入彩蛋时刻，且不是处于抽奖阶段，将保龄球的动画切换为彩蛋待机动画
			bIsSwitchAni = true 
		end
		self.m_PaintedTimeAniIndex = 2
		if bIsSwitchAni then 
			self:_setBowlingPlayAni()
		end
		local txtEggTime = GetElement(self.m_root, "txtEggTime_WndBowling", WZUILabelTTF)
		txtEggTime:setText(LocalStrings.BOWLING_TEXT1[18] .. self.m_nPaintedEggTime .. "S")
		GetElement(self.m_root, "conPaitedEgg_WndBowling", WZUIContainer):setVisible(true)
	else
		GetElement(self.m_root, "conPaitedEgg_WndBowling", WZUIContainer):setVisible(false)
	end
end

--@brief 	设置待机特效
function WndBowling:_setBallAni()
	local spinePath = "activity/ui_activity_ddblq"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		local spineOpen = GetElement(self.m_root, "spineOpen_WndBowling", WZUISpine)
		if spineOpen then 
			spineOpen:setFileJson(spinePath .. ".json")
			spineOpen:setFileAtlas(spinePath .. ".atlas")
		end
	else
		local _sIndex = "ui_activity_ddblq"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7050, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndBowling)
        end
	end
end

function WndBowling:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndBowling:downloadEffectCallback",taskId,extraData,failed)
    self:_setBallAni()
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndBowling:_setBowlingPlayAni(aniIndex, bLoop)
	local spineOpen = GetElement(self.m_root, "spineOpen_WndBowling", WZUISpine)
	aniIndex = aniIndex or 1
	WZLog("WndBowling:_setBowlingPlayAni", self.m_nBowlType, self.m_PaintedTimeAniIndex, aniIndex, bLoop)
	if spineOpen then 
		spineOpen:play(self.m_tBallAniName[self.m_nBowlType + 1][aniIndex + self.m_PaintedTimeAniIndex], bLoop ~= nil and bLoop or true)
	end
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配begin----------------------------------------

function WndBowling:_adaptLanguage_vn( )
    GetElement(self.m_root, "txtBtnOpenOne_WndBowling", WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root, "txtBtnOpenFive_WndBowling", WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root,"txtTalk_WndBowling",WZUILabelTTF):setScale(0.7)

	GetElement(self.m_root, "txtJuniorPlace_WndBowling", WZUILabelTTF):setFontSize(14)
	GetElement(self.m_root, "txtJuniorPlaceSel_WndBowling", WZUILabelTTF):setFontSize(14)
	GetElement(self.m_root, "txtSeniorPlace_WndBowling", WZUILabelTTF):setFontSize(14)
	GetElement(self.m_root, "txtSeniorPlaceSel_WndBowling", WZUILabelTTF):setFontSize(14)
end

-------------------------------------语言适配end----------------------------------------
