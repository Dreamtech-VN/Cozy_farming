--WndTrampoline.lua
--@brief	WndTrampoline的UI模块
--@date		2023/06/16
--@author	XTX
--@note		欢乐蹦床活动主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndTrampoline:onEnter(element)
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
function WndTrampoline:onExit(element)
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
function WndTrampoline:onEnterTransitionDidFinish(element)
    WZLog("WndTrampoline:onEnterTransitionDidFinish")
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7081, 7081)
	self.m_root:enableSchedule("_caculateTime", 1)
end

--@brief    关闭窗口
function WndTrampoline:onCloseClick(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	self:savePoleType()
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮回调
function WndTrampoline:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 	
	WndSingleMapDesc:showInterface1(LocalStrings.TRAMPOLINE_TEXT2) 
end

--@brief 	点击目标按钮回调
function WndTrampoline:onClickTask(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if nTag == 1 then 
		CellNewYearTask:showInterface(29, self.m_nActivityId)
	elseif nTag == 2 then
		WndShopRank:showInterface(46, self.m_nActivityId) 
	elseif nTag == 3 then --商店
		WndDollMachineShop:showInterface(8, self.m_nActivityId)
	elseif nTag == 4 then --全民探索
		self:onClickGift(element)
	elseif nTag == 5 or nTag == 6 or nTag == 7 then --A礼包
		local tData = {}
		tData.txtTitle = LocalStrings.TRAMPOLINE_TEXT1[23]
		tData.nType = 2
		WndTips:show(element, self.m_root, 52, tData, GlobalMethod:ccp(20,100), true)
	end
end

--@brief 	点击大奖预览按钮回调
function WndTrampoline:onClickBigReward(element)
	-- body	
	local eleType = type(element)
	if eleType ~= "number" then 
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	end

	self.m_bIsOpenReward = true 
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 1, "")
end


--@brief 	点击开启按钮回调
function WndTrampoline:onClickFive(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

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
function WndTrampoline:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

--@brief 	点击切换浪板类型
function WndTrampoline:onChooseTool(element)
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
function WndTrampoline:_update()
	-- body
	self:_setFreeBtnText()
	self:showRedDot()
	self:_initActivityTime()
    self:_updateLightNum()
    self:showBagGiftInfo()
end

--@brief 	初始化静态文本
function WndTrampoline:_initStaticText()
	self:getPoleType()

	GetElement(self.m_root, "txtBtnTask1_WndTrampoline", WZUILabelTTF):setText(LocalStrings.TRAMPOLINE_TEXT1[2])
	GetElement(self.m_root, "txtBtnTask2_WndTrampoline", WZUILabelTTF):setText(LocalStrings.TRAMPOLINE_TEXT1[3])
	GetElement(self.m_root, "txtBtnTask3_WndTrampoline", WZUILabelTTF):setText(LocalStrings.TRAMPOLINE_TEXT1[5])
	GetElement(self.m_root, "txtBtnTask4_WndTrampoline", WZUILabelTTF):setText(LocalStrings.TRAMPOLINE_TEXT1[4])
	GetElement(self.m_root, "txtBigReward_WndTrampoline", WZUILabelTTF):setText(LocalStrings.WATERMELON_TEXT1[22])

	self:_setBallAni()
end

--@brief 	红点
function WndTrampoline:showRedDot()
	-- body
	if self.m_root == nil then return end 

	local imgTaskRedDot = GetElement(self.m_root, "imgTaskRedDot_WndTrampoline", WZUIImage)

	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[217081] or GlobalGame.g_tRedPointTypeList[227081] or GlobalGame.g_tRedPointTypeList[237081]) then 
		imgTaskRedDot:setVisible(true)
	else
		imgTaskRedDot:setVisible(false)
	end
end

--@brief 	更新异火的数量
function WndTrampoline:_updateLightNum()
	-- body
	local ftxtLightNum = GetElement(self.m_root, "ftxtLightNum_WndTrampoline", WZUIFreeTextBox)
	local sFormat = [[<I Z="0.5" P="1">%s</I><T C="255,236,193" S="20" P="1" SC="132,66,29" SS="4" SE="0">%d</T>]]
	if ftxtLightNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
		ftxtLightNum:setShowText(string.format(sFormat, basicData.icon, nLightNum))
	end
end

--@brief 	初始化活动时间
function WndTrampoline:_initActivityTime()
	-- body
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndTrampoline", WZUILabelTTF)
    if txtActivityTime then 
    	txtActivityTime:setText(needDay_str)
    end
end

--@brief 	显示开启动画
function WndTrampoline:showOpenAction()
	-- body
	local spineOpen = GetElement(self.m_root, "spineOpen_WndTrampoline", WZUISpine)
	local spinePath = "activity/hd_pic_renwu"
	local existSpine = CheckEffectFile(spinePath)

	if spineOpen then 
		if existSpine then 
			local aniIndex = self.m_nAniType + 1 
			self:_setBowlingPlayAni(aniIndex, false)
			local nSeconds = 0
			if self.m_nAniType == 1 then 
				nSeconds = 1
			else
				nSeconds = 2
			end
			spineOpen:enableSchedule("showShootReward", nSeconds)
		else
			self:showShootReward()
		end
	end
end

--@brief 	显示开启奖励
function WndTrampoline:showShootReward()
	-- body
	local spineOpen = GetElement(self.m_root, "spineOpen_WndTrampoline", WZUISpine)
	spineOpen:disableSchedule()
	self:_setBowlingPlayAni(1, true)

	local strContent = ""
	local nIndex = 0 
	if self.m_tOpenResult.addExp and self.m_tOpenResult.addExp > 0 then 
		strContent = strContent .. LocalStrings.TRAMPOLINE_TEXT1[20] .. "+" .. self.m_tOpenResult.addExp 
		nIndex = nIndex + 1
	end
	if self.m_tOpenResult.addNum and self.m_tOpenResult.addNum > 0 then 
		if nIndex > 0 then 
			strContent = strContent .. "  "
		end
		strContent = strContent .. LocalStrings.TRAMPOLINE_TEXT1[19] .. "+" .. self.m_tOpenResult.addNum 
	end

	if strContent ~= "" then 
		MsgBoxManager:showTipBox(strContent, nil, nil, nil, nil, nil, nil, nil, nil, GlobalMethod:ccp(0.5, 0.77))
	end

	self:setOpenState(false)
	self:_afterCloseReward()
end

--@brief 	iphoneX适配
function WndTrampoline:_adaptIphoneX()
	if IsIphoneX() then
		GetElement(self.m_root, "conLeftMenu_WndTrampoline", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.98,0))
		GetElement(self.m_root, "btnShop_WndTrampoline", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.07,0.3))
	end
end

--@brief 	设置免费丢
function WndTrampoline:_setFreeBtnText()
	local txtBtnOpenOne = GetElement(self.m_root, "txtBtnOpenOne_WndTrampoline", WZUILabelTTF)
	local txtBtnOpenFive = GetElement(self.m_root, "txtBtnOpenFive_WndTrampoline", WZUILabelTTF)

	local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local freeTimes = 0 
	local nTempTimes = math.floor(nLightNum/self.m_tCostByType[self.m_nCalabashType + 1])
	local nTimes = 0
	local strTemp = ""
	if self.m_nCalabashType == 0 then 
		strTemp = LocalStrings.TRAMPOLINE_TEXT1[7]
		if self.m_nCount > 0 then 
			freeTimes = 1
			txtBtnOpenOne:setText(LocalStrings.TRAMPOLINE_TEXT1[6])
		else
			txtBtnOpenOne:setText(string.format(strTemp, 1))
		end
	else
		strTemp = LocalStrings.TRAMPOLINE_TEXT1[8]
		txtBtnOpenOne:setText(string.format(strTemp, 1))
	end
	nTimes = (nTempTimes + freeTimes) >= self.m_nMaxLotteryCount and self.m_nMaxLotteryCount or nTempTimes > 0 and (nTempTimes + freeTimes) or self.m_nMaxLotteryCount 
	txtBtnOpenFive:setText(string.format(strTemp, nTimes))
end

--@brief 	设置待机特效
function WndTrampoline:_setBallAni()
	local spinePath = "activity/hd_pic_renwu"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		local spineOpen = GetElement(self.m_root, "spineOpen_WndTrampoline", WZUISpine)
		if spineOpen then 
			spineOpen:setFileJson(spinePath .. ".json")
			spineOpen:setFileAtlas(spinePath .. ".atlas")
			self:_setBowlingPlayAni(1, true)
		end
	else
		local _sIndex = "hd_pic_renwu"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7081, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndTrampoline)
        end
	end

	local spinePath2 = "activity/hd_pic_beijing"
	local existSpine2 = CheckEffectFile(spinePath2)
	if existSpine2 then 
		local spineWait = GetElement(self.m_root, "spineWait_WndTrampoline", WZUISpine)
		if spineWait then 
			spineWait:setFileJson(spinePath2 .. ".json")
			spineWait:setFileAtlas(spinePath2 .. ".atlas")
			spineWait:play("wait", true)
		end
	else
		local _sIndex = "hd_pic_beijing"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(70810, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndTrampoline)
        end
	end

	local spinePath3 = "activity/ui_bengchuang_lihe"
	local existSpine3 = CheckEffectFile(spinePath3)
	if existSpine3 then 
		local spineEffectA = GetElement(self.m_root, "spineEffectA_WndTrampoline", WZUISpine)
		local spineEffectB = GetElement(self.m_root, "spineEffectB_WndTrampoline", WZUISpine)
		local spineEffectS = GetElement(self.m_root, "spineEffectS_WndTrampoline", WZUISpine)
		if spineEffectA then 
			spineEffectA:setFileJson(spinePath3 .. ".json")
			spineEffectA:setFileAtlas(spinePath3 .. ".atlas")
			spineEffectA:play("wait1", true)
		end
		if spineEffectB then 
			spineEffectB:setFileJson(spinePath3 .. ".json")
			spineEffectB:setFileAtlas(spinePath3 .. ".atlas")
			spineEffectB:play("wait1", true)
		end
		if spineEffectS then 
			spineEffectS:setFileJson(spinePath3 .. ".json")
			spineEffectS:setFileAtlas(spinePath3 .. ".atlas")
			spineEffectS:play("wait1", true)
		end
	else
		local _sIndex = "ui_bengchuang_lihe"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(70811, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndTrampoline)
        end
	end
end

function WndTrampoline:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndTrampoline:downloadEffectCallback",taskId,extraData,failed)
    self:_setBallAni()
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndTrampoline:_setBowlingPlayAni(aniIndex, bLoop)
	local spineOpen = GetElement(self.m_root, "spineOpen_WndTrampoline", WZUISpine)
	aniIndex = aniIndex or 1
	WZLog("WndTrampoline:_setBowlingPlayAni", aniIndex, bLoop)

	if spineOpen then 
		spineOpen:play(self.m_tBallAniName[self.m_nCalabashType + 1][aniIndex], bLoop ~= nil and bLoop or true)
	end
end

--@brief 	点击全民探索按钮回调
function WndTrampoline:onClickGift(element)
	-- body
	if self.m_nGiftRewardNum >= 1 then
		--背包已满提示
	    if CacheCenter:getRemainAmount() <= 0 then
	        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
	        return
	    end
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 5, "")
	else
		local tData = {}
		tData.txtTitle = string.format(LocalStrings.TRAMPOLINE_TEXT1[9], self.m_nGiftRewardConfig)
		tData.nType = 2
		WndTips:show(element, self.m_root, 52, tData, GlobalMethod:ccp(20,100), true)
	end
end

--@brief 	刷新赛事礼包的信息
function WndTrampoline:showBagGiftInfo()
	-- body
	if self.m_nGiftRewardNum > 0 then 
		GetElement(self.m_root, "imgGiftRed_WndTrampoline", WZUIImage):setVisible(true)
		GetElement(self.m_root, "txtGiftNum_WndTrampoline", WZUILabelTTF):setText(self.m_nGiftRewardNum)
	else
		GetElement(self.m_root, "imgGiftRed_WndTrampoline", WZUIImage):setVisible(false)
	end
end

--@brief 	显示咖啡师的对话
--@param 	state:0没有触发礼包；1触发了礼包
function WndTrampoline:_showTalk(state)
	local conTalk = GetElement(self.m_root, "conTalk_WndTrampoline", WZUIContainer)
	conTalk:setVisible(true)

	local txtTalk = GetElement(self.m_root, "txtTalk_WndTrampoline", WZUILabelTTF)
	local tTalkList = LocalStrings.TRAMPOLINE_TEXT1[21 + state]
	local nCount = #tTalkList
	local tempRand = math.random(1, 10)
	local strIndex = math.fmod(tempRand, nCount) + 1
	if self.m_nLastTalkIndex == strIndex or self.m_nTalkGapping ~= nil then return end 
	self.m_nLastTalkIndex = strIndex
	self.m_nTalkGapping = 3
	txtTalk:setText(tTalkList[strIndex] or tTalkList[1])
end

--@brief 	计时器
function WndTrampoline:_caculateTime()
	-- body
	if self.m_nTalkGapping == nil then return end 

	if self.m_nTalkGapping > 0 then 
		self.m_nTalkGapping = self.m_nTalkGapping - 1
	else
		self.m_nTalkGapping = nil 
		self.m_nLastTalkIndex = 0
		GetElement(self.m_root, "conTalk_WndTrampoline", WZUIContainer):setVisible(false)
	end
end
-------------------------------------私有方法模块End----------------------------------------


function WndTrampoline:_adaptLanguage_vn()
	GetElement(self.m_root,"txtBtnOpenOne_WndTrampoline",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txtBtnOpenFive_WndTrampoline",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtBtnTask1_WndTrampoline",WZUILabelTTF):setScale(0.55)
	GetElement(self.m_root,"txtBtnTask2_WndTrampoline",WZUILabelTTF):setScale(0.65)
	GetElement(self.m_root,"txtBtnTask3_WndTrampoline",WZUILabelTTF):setScale(0.8)
end