--WndPlanetSearch.lua
--@brief	WndPlanetSearch的UI模块
--@date		2023/05/23
--@author	XTX
--@note		行星探索活动主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPlanetSearch:onEnter(element)
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
function WndPlanetSearch:onExit(element)
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
function WndPlanetSearch:onEnterTransitionDidFinish(element)
    WZLog("WndPlanetSearch:onEnterTransitionDidFinish")
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7077, 7077)
end

--@brief    关闭窗口
function WndPlanetSearch:onCloseClick(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    local nTag = element:getTag()
    if nTag == 2 then 
    	GetElement(self.m_root, "conRule_WndPlanetSearch", WZUIContainer):setVisible(false)
    else
		self:savePoleType()
		WindowManager:removeWindow(self.m_root, self, true)
	end
end

--@brief    点击规则按钮回调
function WndPlanetSearch:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 	
	--	更新滚动容器内部布局函数
	GetElement(self.m_root, "conRule_WndPlanetSearch", WZUIContainer):setVisible(true)
	self:_upMoveContainerLayer1()
end

--@brief 	点击目标按钮回调
function WndPlanetSearch:onClickTask(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if nTag == 1 then 
		CellNewYearTask:showInterface(28, self.m_nActivityId)
	elseif nTag == 2 then
		WndShopRank:showInterface(45, self.m_nActivityId) 
	elseif nTag == 4 then --全民探索
		self:onClickGift(element)
	end
end

--@brief 	点击大奖预览按钮回调
function WndPlanetSearch:onClickBigReward(element)
	-- body	
	local eleType = type(element)
	if eleType ~= "number" then 
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	end

	self.m_bIsOpenReward = true 
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 1, "")
end


--@brief 	点击开启按钮回调
function WndPlanetSearch:onClickFive(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if nTag == 5 then 
		if self.m_nAniType == 2 then 
			self.m_nAniType = 1
		else
			self.m_nAniType = 2
		end
		local btnFile = {"ui/newActivity/common_btn_xxts_01.png", "ui/newActivity/common_btn_xxts_02.png"}
		local btnWordsStrokeColor = {GlobalMethod:ccc3(0,112,202), GlobalMethod:ccc3(163,74,20)}
		local imgOpenBtn = GetElement(self.m_root, "imgOpenBtn_WndPlanetSearch", WZUIImage)
		local txtBtnOpenOne = GetElement(self.m_root, "txtBtnOpenOne_WndPlanetSearch", WZUILabelTTF)
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
function WndPlanetSearch:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

--@brief 	点击切换浪板类型
function WndPlanetSearch:onChooseTool(element)
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
function WndPlanetSearch:_update()
	-- body
	self:_setFreeBtnText()
	self:showRedDot()
	self:_initActivityTime()
    self:_updateLightNum()
    self:showBagGiftInfo()
end

--@brief 	初始化静态文本
function WndPlanetSearch:_initStaticText()
	self:getPoleType()

	GetElement(self.m_root, "txtBtnTask1_WndPlanetSearch", WZUILabelTTF):setText(LocalStrings.PLANETSEARCH_TEXT1[2])
	GetElement(self.m_root, "txtBtnTask2_WndPlanetSearch", WZUILabelTTF):setText(LocalStrings.PLANETSEARCH_TEXT1[3])
	GetElement(self.m_root, "txtBigReward_WndPlanetSearch", WZUILabelTTF):setText(LocalStrings.TREASURE_TEXT7)
	for i = 1, 9 do
		GetElement(self.m_root, "txtPlanetName" .. i .. "_WndPlanetSearch", WZUILabelTTF):setText(LocalStrings.PLANETSEARCH_TEXT1[15][i])
	end
	GetElement(self.m_root, "txtDesc1_WndPlanetSearch", WZUIFreeTextBox):setShowText(LocalStrings.PLANETSEARCH_TEXT2)
	GetElement(self.m_root, "txtCheck1_WndPlanetSearch", WZUILabelTTF):setText(LocalStrings.PLANETSEARCH_TEXT1[16])
	GetElement(self.m_root, "txtCheck2_WndPlanetSearch", WZUILabelTTF):setText(LocalStrings.PLANETSEARCH_TEXT1[17])

	self:_setBallAni()
end

--@brief 	红点
function WndPlanetSearch:showRedDot()
	-- body
	if self.m_root == nil then return end 

	local imgTaskRedDot = GetElement(self.m_root, "imgTaskRedDot_WndPlanetSearch", WZUIImage)

	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[117077] or GlobalGame.g_tRedPointTypeList[127077]) then 
		imgTaskRedDot:setVisible(true)
	else
		imgTaskRedDot:setVisible(false)
	end
end

--@brief 	更新异火的数量
function WndPlanetSearch:_updateLightNum()
	-- body
	local ftxtLightNum = GetElement(self.m_root, "ftxtLightNum_WndPlanetSearch", WZUIFreeTextBox)
	local sFormat = [[<I Z="0.5" P="1">%s</I><T C="255,236,193" S="20" P="1" SC="132,66,29" SS="4" SE="0">%d</T>]]
	if ftxtLightNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
		ftxtLightNum:setShowText(string.format(sFormat, basicData.icon, nLightNum))
	end
end

--@brief 	初始化活动时间
function WndPlanetSearch:_initActivityTime()
	-- body
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndPlanetSearch", WZUILabelTTF)
    if txtActivityTime then 
    	txtActivityTime:setText(needDay_str)
    end
end

--@brief 	显示开启动画
function WndPlanetSearch:showOpenAction()
	-- body
	local spineOpen = GetElement(self.m_root, "spineOpen_WndPlanetSearch", WZUISpine)

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
function WndPlanetSearch:showShootReward()
	-- body
	local spineOpen = GetElement(self.m_root, "spineOpen_WndPlanetSearch", WZUISpine)
	spineOpen:disableSchedule()
	self:_setBowlingPlayAni(1, true)

	local strContent = ""
	if self.m_tOpenResult.addExp and self.m_tOpenResult.addExp > 0 then 
		strContent = strContent .. LocalStrings.PLANETSEARCH_TEXT1[14] .. "+" .. self.m_tOpenResult.addExp 
	end

	if strContent ~= "" then 
		MsgBoxManager:showTipBox(strContent, nil, nil, nil, nil, nil, nil, nil, nil, GlobalMethod:ccp(0.5, 0.77))
	end

	self:setOpenState(false)
	self:_afterCloseReward()
end

--@brief 	iphoneX适配
function WndPlanetSearch:_adaptIphoneX()
	if IsIphoneX() then
		GetElement(self.m_root, "conLeftMenu_WndPlanetSearch", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.98,0.11))
		GetElement(self.m_root, "btnWellChess_WndPlanetSearch", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.08,0.45))
	end
end

--@brief 	设置免费丢
function WndPlanetSearch:_setFreeBtnText()
	local txtBtnOpenOne = GetElement(self.m_root, "txtBtnOpenOne_WndPlanetSearch", WZUILabelTTF)

	local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local freeTimes = 0 
	local nTempTimes = math.floor(nLightNum/self.m_tCostByType[self.m_nCalabashType + 1])
	local nTimes = 0
	if self.m_nAniType == 1 then 
		if self.m_nCount > 0 and self.m_nCalabashType == 0 then 
			freeTimes = 1
			txtBtnOpenOne:setText(LocalStrings.PLANETSEARCH_TEXT1[6])
		else
			txtBtnOpenOne:setText(string.format(LocalStrings.PLANETSEARCH_TEXT1[5], 1))
		end
	else
		nTimes = (nTempTimes + freeTimes) >= self.m_nMaxLotteryCount and self.m_nMaxLotteryCount or nTempTimes > 0 and (nTempTimes + freeTimes) or self.m_nMaxLotteryCount 
		txtBtnOpenOne:setText(string.format(LocalStrings.PLANETSEARCH_TEXT1[5], nTimes))
	end
end

--@brief 	设置待机特效
function WndPlanetSearch:_setBallAni()
	local spinePath = "activity/hd_pic_xingxing"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		local spineOpen = GetElement(self.m_root, "spineOpen_WndPlanetSearch", WZUISpine)
		if spineOpen then 
			spineOpen:setFileJson(spinePath .. ".json")
			spineOpen:setFileAtlas(spinePath .. ".atlas")
			self:_setBowlingPlayAni(1, true)
		end
	else
		local _sIndex = "hd_pic_xingxing"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7077, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndPlanetSearch)
        end
	end
end

function WndPlanetSearch:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndPlanetSearch:downloadEffectCallback",taskId,extraData,failed)
    self:_setBallAni()
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndPlanetSearch:_setBowlingPlayAni(aniIndex, bLoop)
	local spineOpen = GetElement(self.m_root, "spineOpen_WndPlanetSearch", WZUISpine)
	aniIndex = aniIndex or 1
	WZLog("WndPlanetSearch:_setBowlingPlayAni", aniIndex, bLoop)

	if spineOpen then 
		spineOpen:play(self.m_tBallAniName[self.m_nCalabashType + 1][aniIndex], bLoop ~= nil and bLoop or true)
	end
end

--@brief 	点击全民探索按钮回调
function WndPlanetSearch:onClickGift(element)
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
		tData.txtTitle = string.format(LocalStrings.PLANETSEARCH_TEXT1[13], self.m_nGiftRewardConfig)
		tData.nType = 2
		WndTips:show(element, self.m_root, 52, tData, GlobalMethod:ccp(350,80), true)
	end
end

--@brief 	刷新赛事礼包的信息
function WndPlanetSearch:showBagGiftInfo()
	-- body
	if self.m_nGiftRewardNum > 0 then 
		GetElement(self.m_root, "imgGiftRed_WndPlanetSearch", WZUIImage):setVisible(true)
		GetElement(self.m_root, "txtGiftNum_WndPlanetSearch", WZUILabelTTF):setText(self.m_nGiftRewardNum)
	else
		GetElement(self.m_root, "imgGiftRed_WndPlanetSearch", WZUIImage):setVisible(false)
	end
end

--@brief  	更新滚动容器内部布局函数
function WndPlanetSearch:_upMoveContainerLayer1()
	WZLog("self:_upMoveContainerLayer()")
	if self.m_root == nil then
		return
	end
	--获取规则说明内容文本的大小
	local txtExplanation = GetElement(self.m_root, "txtDesc1_WndPlanetSearch", WZUIFreeTextBox)
	local txtSize = txtExplanation:getContentSize()	
	txtExplanation:setAnchorPoint(ccp(0,1))
	txtExplanation:setPositionY(txtSize.height-5)
--
	
	local rollconExplanation = self.m_root:getChildElement("rollconExplanation_WndPlanetSearch")
	if rollconExplanation == nil then 
		return
	end
	rollconExplanation = WZUIMoveContainer:luaTo(rollconExplanation)
	local rollSize = rollconExplanation:getContentSize()
	--更改滚动容器Element的大小
	local moveElement = rollconExplanation:getMoveElement()
	local size = moveElement:getRelativeSize()
	moveElement:setRelativeSize( CCSize(1 , txtSize.height / rollSize.height ) )
	--moveElement:setContentSize(txtSize)
	rollconExplanation:UpdateInsidePosition()  --更新滚动容器内部布局
	moveElement:setPositionY(rollconExplanation:getMinPosition().y)
	WZLog("滚动容器大小",rollSize.width,rollSize.height)
end
-------------------------------------私有方法模块End----------------------------------------
