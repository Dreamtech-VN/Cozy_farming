--WndGopherBall.lua
--@brief	WndGopherBall的UI模块
--@date		2022/10/31
--@author	XTX
--@note		全垒打活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndGopherBall:onEnter(element)
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
function WndGopherBall:onExit(element)
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
function WndGopherBall:onEnterTransitionDidFinish(element)
    WZLog("WndGopherBall:onEnterTransitionDidFinish")
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7059, 7059)
end

--@brief    关闭窗口
function WndGopherBall:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    --如果是自动弹出的活动界面
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮回调
function WndGopherBall:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 
    WndSingleMapDesc:showInterface1(LocalStrings.GOPHERBALL_TEXT2) 
end

--@brief 	点击目标按钮回调
function WndGopherBall:onClickTask(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if nTag == 1 then 
		CellNewYearTask:showInterface(19, self.m_nActivityId)
	elseif nTag == 3 then 
		WndShopRank:showInterface(33, self.m_nActivityId) 
	end
end

--@brief 	点击大奖预览按钮回调
function WndGopherBall:onClickBigReward(element)
	-- body
	local eleType = type(element)
	if eleType ~= "number" then 
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	end
	
	if self.m_tBigRewardList ~= nil then
		self.m_bIsOpenReward = true 
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, "")
	end
end

--@brief 	点击开启按钮回调
function WndGopherBall:onClickFive(element)
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
		SaveOperateTimes("GOPHERBALLACTIVITYID", self.m_nActivityId)
    	return 
    end

	local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local freeCount = 0
	local nTempTimes = nArrowNum
	freeCount = self.m_nCount > 0 and 1 or 0 
	local nTimes = nTag
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
function WndGopherBall:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

--@brief 	点击赛事礼包按钮回调
function WndGopherBall:onClickGift(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_nGiftRewardNum >= 1 then
		--背包已满提示
	    if CacheCenter:getRemainAmount() <= 0 then
	        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
	        return
	    end
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 4, "")
	else
		local tData = {}
		tData.txtTitle = string.format(LocalStrings.GOPHERBALL_TEXT1[15], self.m_tContent.globalDayConfig[1])
		tData.nType = 2
		WndTips:show(element, self.m_root, 52, tData, GlobalMethod:ccp(50,80), true)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndGopherBall:_update()
	-- body
	self:_setFreeBtnText()
	self:showRedDot()
	self:_initActivityTime()
    self:_updateLightNum()
    self:showBagGiftInfo()
    self:_showRedBall()
end

--@brief 	初始化静态文本
function WndGopherBall:_initStaticText()
	GetElement(self.m_root, "txtTask1_WndGopherBall", WZUILabelTTF):setText(LocalStrings.GOPHERBALL_TEXT1[2])
	GetElement(self.m_root, "txtTaskSel1_WndGopherBall", WZUILabelTTF):setText(LocalStrings.GOPHERBALL_TEXT1[2])
	GetElement(self.m_root, "txtTask3_WndGopherBall", WZUILabelTTF):setText(LocalStrings.ACTIVITY_TEXT6)
	GetElement(self.m_root, "txtTaskSel3_WndGopherBall", WZUILabelTTF):setText(LocalStrings.ACTIVITY_TEXT6)
	GetElement(self.m_root, "txtGiftName_WndGopherBall", WZUILabelTTF):setText(LocalStrings.GOPHERBALL_TEXT1[8])

	self:_setBallAni()
end

--@brief 	红点
function WndGopherBall:showRedDot()
	-- body
	if self.m_root == nil then return end 

	local imgTaskRedDot = GetElement(self.m_root, "imgTaskRedDot_WndGopherBall", WZUIImage)

	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[117059] or GlobalGame.g_tRedPointTypeList[127059]) then 
		imgTaskRedDot:setVisible(true)
	else
		imgTaskRedDot:setVisible(false)
	end
end

--@brief 	更新异火的数量
function WndGopherBall:_updateLightNum()
	-- body
	local ftxtLightNum = GetElement(self.m_root, "ftxtArrowNum_WndGopherBall", WZUIFreeTextBox)
	local sFormat = [[<I Z="0.5" P="1">%s</I><T C="255,255,255" S="20" P="1" SC="132,66,29" SS="4" SE="1">%d</T>]]
	if ftxtLightNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
		ftxtLightNum:setShowText(string.format(sFormat, basicData.icon, nLightNum))
	end
end

--@brief 	初始化活动时间
function WndGopherBall:_initActivityTime()
	-- body
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndGopherBall", WZUILabelTTF)
    if txtActivityTime then 
    	txtActivityTime:setText(LocalStrings.ACTIVITY_TIME_KEY .. ":" .. needDay_str)
    end
end

--@brief 	显示开启动画
function WndGopherBall:showOpenAction()
	-- body
	--创建选中特效
	local spinePath = "activity/qld_bangqiu"
	local existSpine = CheckEffectFile(spinePath)
	if not existSpine then 
		local _sIndex = "qld_bangqiu"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7059, downloadInfo.url, downloadInfo.md5, _sIndex, "DownloadResourceCallback", _G)
        end
	end

	local spineOpen = GetElement(self.m_root, "spineOpen_WndGopherBall", WZUISpine)
	if spineOpen then 
		if existSpine then 
			local delayTime = 0.8
			self:_showTalk()
			if self.m_nAniType == 3 then 
				delayTime = 0.95
			end
			self:_setBowlingPlayAni(self.m_nAniType, false)
			spineOpen:enableSchedule("showShootReward", delayTime)
		else
			self:showShootReward()
		end
	end
end

--@brief 	显示开启奖励
function WndGopherBall:showShootReward()
	-- body
	WZLog("WndGopherBall:showShootReward")
	local spineOpen = GetElement(self.m_root, "spineOpen_WndGopherBall", WZUISpine)
	spineOpen:disableSchedule()
	self:_setBowlingPlayAni(1, true)

	self:setOpenState(false)
	self:_afterCloseReward()
end

--@brief 	iphoneX适配
function WndGopherBall:_adaptIphoneX()
	if IsIphoneX() then
		GetElement(self.m_root, "conLeftMenu_WndGopherBall", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.045,0.2))
	end
end

--@brief 	设置免费丢
function WndGopherBall:_setFreeBtnText()
	local txtBtnOpenOne = GetElement(self.m_root, "txtBtnOpenOne_WndGopherBall", WZUILabelTTF)
	local txtBtnOpenFive = GetElement(self.m_root, "txtBtnOpenFive_WndGopherBall", WZUILabelTTF)
	local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)

	local nTempTimes = nLightNum
	local nTimes = 0
	local freeCount = self.m_nCount > 0 and 1 or 0 
	if self.m_nCount > 0 then 
		txtBtnOpenOne:setText(LocalStrings.GOPHERBALL_TEXT1[7])
	else
		txtBtnOpenOne:setText(string.format(LocalStrings.GOPHERBALL_TEXT1[5], 1))
	end
	nTimes = nTempTimes >= self.m_nMaxLotteryCount and self.m_nMaxLotteryCount or nTempTimes > 0 and nTempTimes + freeCount or self.m_nMaxLotteryCount 
	txtBtnOpenFive:setText(string.format(LocalStrings.GOPHERBALL_TEXT1[5], nTimes))
end

--@brief 	显示咖啡师的对话
function WndGopherBall:_showTalk()
	local conTalk = GetElement(self.m_root, "conTalk_WndGopherBall", WZUIContainer)
	conTalk:setVisible(true)

	local txtTalk = GetElement(self.m_root, "txtTalk_WndGopherBall", WZUILabelTTF)
	local nCount = #LocalStrings.GOPHERBALL_TEXT1[16]
	local tempRand = math.random(1, 10)
	local strIndex = math.fmod(tempRand, nCount) + 1
	if self.m_nLastTalkIndex == strIndex or self.m_nTalkGapping ~= nil then return end 
	self.m_nLastTalkIndex = strIndex
	self.m_nTalkGapping = 5
	txtTalk:setText(LocalStrings.GOPHERBALL_TEXT1[16][strIndex] or LocalStrings.GOPHERBALL_TEXT1[16][1])
end

--@brief 	计时器
function WndGopherBall:_caculateTime()
	-- body
	if self.m_nTalkGapping == nil then return end 

	if self.m_nTalkGapping > 0 then 
		self.m_nTalkGapping = self.m_nTalkGapping - 1
	else
		self.m_nTalkGapping = nil 
		self.m_nLastTalkIndex = 0
		GetElement(self.m_root, "conTalk_WndGopherBall", WZUIContainer):setVisible(false)
	end
end

--@brief 	刷新赛事礼包的信息
function WndGopherBall:showBagGiftInfo()
	-- body
	if self.m_nGiftRewardNum > 0 then 
		GetElement(self.m_root, "spineGift_WndGopherBall", WZUISpine):setVisible(true)
		GetElement(self.m_root, "imgGiftRed_WndGopherBall", WZUIImage):setVisible(true)
		GetElement(self.m_root, "txtGiftNum_WndGopherBall", WZUILabelTTF):setText(self.m_nGiftRewardNum)
	else
		GetElement(self.m_root, "spineGift_WndGopherBall", WZUISpine):setVisible(false)
		GetElement(self.m_root, "imgGiftRed_WndGopherBall", WZUIImage):setVisible(false)
	end
end

--@brief 	显示跑垒
function WndGopherBall:_showRedBall()
	if self.m_tRedBallData == nil then return end 

	if self.m_nPosIndex ~= self.m_tRedBallData[1] then 
		for i = 1, 4 do
			local imgRedBall = GetElement(self.m_root, "imgRedBall" .. i - 1 .. "_WndGopherBall", WZUIImage)
			imgRedBall:setVisible(i - 1 == self.m_tRedBallData[1])
			local imgLine = GetElement(self.m_root, "imgLine" .. i - 1 .. "_WndGopherBall", WZUIImage)
			if self.m_tRedBallData[1] == 0 then 
				imgLine:setFile("ui/newActivity/hd_pic_qld_dt_bx.png")
			else
				if i - 1 <= self.m_tRedBallData[1] - 1 then 
					imgLine:setFile("ui/newActivity/hd_pic_qld_dt_hx.png")
				else
					imgLine:setFile("ui/newActivity/hd_pic_qld_dt_bx.png")
				end
			end
		end

		self.m_nPosIndex = self.m_tRedBallData[1]
	end
end

--@brief 	设置待机特效
function WndGopherBall:_setBallAni()
	local spinePath = "activity/qld_bangqiu"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		local spineOpen = GetElement(self.m_root, "spineOpen_WndGopherBall", WZUISpine)
		if spineOpen then 
			spineOpen:setFileJson(spinePath .. ".json")
			spineOpen:setFileAtlas(spinePath .. ".atlas")

			self:_setBowlingPlayAni(1, true)
		end
	else
		local _sIndex = "qld_bangqiu"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7059, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndGopherBall)
        end
	end
end

function WndGopherBall:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndGopherBall:downloadEffectCallback",taskId,extraData,failed)
    self:_setBallAni()
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndGopherBall:_setBowlingPlayAni(aniIndex, bLoop)
	local spineOpen = GetElement(self.m_root, "spineOpen_WndGopherBall", WZUISpine)
	aniIndex = aniIndex or 1
	WZLog("WndGopherBall:_setBowlingPlayAni", aniIndex, bLoop)
	if spineOpen then 
		spineOpen:play(self.m_tBallAniName[aniIndex], bLoop ~= nil and bLoop or true)
	end
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin----------------------------------------

function WndGopherBall:_adaptLanguage_vn()
	local txtTask1 = GetElement(self.m_root, "txtTask1_WndGopherBall", WZUILabelTTF)
	txtTask1:setFontSize(14)
	txtTask1:setDimensions(GlobalMethod:CCSize(80,0))
	local txtTaskSel1 = GetElement(self.m_root, "txtTaskSel1_WndGopherBall", WZUILabelTTF)
	txtTaskSel1:setFontSize(14)
	txtTaskSel1:setDimensions(GlobalMethod:CCSize(80,0))

	local txtBtnOpenOne = GetElement(self.m_root, "txtBtnOpenOne_WndGopherBall", WZUILabelTTF)
	txtBtnOpenOne:setFontSize(16)
	local txtBtnOpenFive = GetElement(self.m_root, "txtBtnOpenFive_WndGopherBall", WZUILabelTTF)
	txtBtnOpenFive:setFontSize(16)

	local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndGopherBall", WZUILabelTTF)
	txtActivityTime:setFontSize(18)
end

-------------------------------------语言适配End----------------------------------------
