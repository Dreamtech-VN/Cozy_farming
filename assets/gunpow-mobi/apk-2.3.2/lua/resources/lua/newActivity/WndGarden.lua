--WndGarden.lua
--@brief	WndGarden的UI模块
--@date		2022/04/12
--@author	XTX
--@note		小岛果园主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndGarden:onEnter(element)
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
function WndGarden:onExit(element)
	g_bIsShowWndDressUp = true
    g_tTempItemForLaterShow = {}
	CacheCenter:unregisterUpatePlayerItemObserver(self)
	ProtocolProcessorFestivalActivity:unregAll6()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
	GlobalGame:getGameEventDispathcer():Remove(Independent_Activity.ActivityReddot, self.showRedDot, self)
	if self.m_root then 
		local conOpenAct = GetElement(self.m_root, "conOpenAct_WndGarden", WZUIContainer)
		if conOpenAct then 
			conOpenAct:disableSchedule()
		end
		local spineOpen = GetElement(self.m_root, "spineOpen_WndGarden", WZUISpine)
		if spineOpen then 
			spineOpen:disableSchedule()
		end
	end

	self:_unInit()
	LoadNewActivityRes(false)
end

--@brief    onenter函数已执行
function WndGarden:onEnterTransitionDidFinish(element)
    WZLog("WndGarden:onEnterTransitionDidFinish")
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7047, 7047)
end

--@brief    关闭窗口
function WndGarden:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    --如果是自动弹出的活动界面
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮回调
function WndGarden:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 
    WndSingleMapDesc:showInterface1(LocalStrings.GARDEN_TEXT2) 
end

--@brief 	点击目标按钮回调
function WndGarden:onClickTask(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if nTag == 1 then 
		CellNewYearTask:showInterface(11, self.m_nActivityId)
	elseif nTag == 2 then
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 4, "")
	elseif nTag == 3 then 
		WndShopRank:showInterface(22, self.m_nActivityId) 
	end
end

--@brief 	点击大奖预览按钮回调
function WndGarden:onClickBigReward(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WndJoinReward:showInterface("", self.m_tBigRewardList[1], self.m_tBigRewardList[2], LocalStrings.GARDEN_TEXT1[17], nil, 2)
end

--@brief 	点击开启按钮回调
function WndGarden:onClickFive(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	--背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
    if self.m_bOpenState then return end 

	local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local freeCount = self.m_nCount == 0 and 1 or 0 
	if nTag - freeCount > nArrowNum then 
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
function WndGarden:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

--@brief 	点击赛事礼包按钮回调
function WndGarden:onClickGift(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_nGiftRewardNum >= 1 then
		--背包已满提示
	    if CacheCenter:getRemainAmount() <= 0 then
	        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
	        return
	    end
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 6, "")
	else
		local tData = {}
		tData.txtTitle = LocalStrings.GARDEN_TEXT1[22]
		tData.nType = 2
		WndTips:show(element, self.m_root, 52, tData, GlobalMethod:ccp(300,80), true)
	end
end

--@brief 	点击种植按钮回调
function WndGarden:onClickPlant(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local tData = {}
	tData.times = 1

	local stringData = json.encode(tData)

	self:setOpenState(true)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 3, stringData)
end

--@brief 	点击关闭水果店按钮回调
function WndGarden:onCloseStore(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	GetElement(self.m_root, "conStore_WndGarden", WZUIContainer):setVisible(false)
end

--@brief 	点击出售按钮回调
function WndGarden:onClickSell(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nStockNum <= 0 then 
		MsgBoxManager:showTipBox(LocalStrings.GARDEN_TEXT1[24])
		return 
	end
	--背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
	WndAuctionBuy:show(itemId, 1,costId,costCount,storeId,self, self.sellCallBack, self.m_nStockNum, 1)
end

--@brief 	出售回调
function WndGarden:sellCallBack(itemId, sellNum)
	local tData = {}
	tData.num = sellNum

	local stringData = json.encode(tData)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 5, stringData)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndGarden:_update()
	-- body
	self:_setFreeBtnText()
	self:showRedDot()
	self:_initActivityTime()
    self:_updateLightNum()
    self:showBagGiftInfo()
end

--@brief 	初始化静态文本
function WndGarden:_initStaticText()
	GetElement(self.m_root, "txtBigReward_WndGarden", WZUILabelTTF):setText(LocalStrings.GARDEN_TEXT1[17])
	GetElement(self.m_root, "txtBtnTask1_WndGarden", WZUILabelTTF):setText(LocalStrings.GARDEN_TEXT1[16])
	GetElement(self.m_root, "txtBtnTask2_WndGarden", WZUILabelTTF):setText(LocalStrings.GARDEN_TEXT1[3])
	GetElement(self.m_root, "txtBtnTask3_WndGarden", WZUILabelTTF):setText(LocalStrings.GARDEN_TEXT1[4])
	GetElement(self.m_root, "txtGiftReward_WndGarden", WZUILabelTTF):setText(LocalStrings.GARDEN_TEXT1[23])
	GetElement(self.m_root, "ftxtWelcome_WndGarden", WZUIFreeTextBox):setShowText(LocalStrings.GARDEN_TEXT1[18])
	GetElement(self.m_root, "txtBtnPlant_WndGarden", WZUILabelTTF):setText(LocalStrings.GARDEN_TEXT1[15])
	GetElement(self.m_root, "txtPlayer_WndGarden", WZUILabelTTF):setText(LocalStrings.GARDEN_TEXT1[19])
	GetElement(self.m_root, "txtStock_WndGarden", WZUILabelTTF):setText(LocalStrings.GARDEN_TEXT1[20])
	GetElement(self.m_root, "txtScore_WndGarden", WZUILabelTTF):setText(LocalStrings.GARDEN_TEXT1[21])

	self:_setSpineAni()
end

--@brief 	设置动画特效
function WndGarden:_setSpineAni()
	local spineOpen = GetElement(self.m_root, "spineOpen_WndGarden", WZUISpine)
	local spineWait = GetElement(self.m_root, "spineWait_WndGarden", WZUISpine)
	local spineFei = GetElement(self.m_root, "spineFei_WndGarden", WZUISpine)
	local spinePath = "activity/ui_xdly_shou"
	local existSpine = CheckEffectFile(spinePath)
	if not existSpine then 
		local _sIndex = "ui_xdly_shou"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7047, downloadInfo.url, downloadInfo.md5, _sIndex, "_setSpineAni", self)
        end
    else
		spineOpen:setFileJson(spinePath .. ".json")
		spineOpen:setFileAtlas(spinePath .. ".atlas")
	end
	local spinePath1 = "activity/ui_xdly_wait"
	local existSpine1 = CheckEffectFile(spinePath1)
	if not existSpine1 then 
		local _sIndex = "ui_xdly_wait"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7048, downloadInfo.url, downloadInfo.md5, _sIndex, "_setSpineAni", self)
        end
    else
		spineWait:setFileJson(spinePath1 .. ".json")
		spineWait:setFileAtlas(spinePath1 .. ".atlas")
	end

	local spinePath2 = "activity/ui_xdly_shifei"
	local existSpine2 = CheckEffectFile(spinePath2)
	if not existSpine1 then 
		local _sIndex = "ui_xdly_shifei"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7049, downloadInfo.url, downloadInfo.md5, _sIndex, "_setSpineAni", self)
        end
    else
		spineFei:setFileJson(spinePath2 .. ".json")
		spineFei:setFileAtlas(spinePath2 .. ".atlas")
	end
end

--@brief 	红点
function WndGarden:showRedDot()
	-- body
	if self.m_root == nil then return end 

	local imgTaskRedDot = GetElement(self.m_root, "imgTaskRedDot_WndGarden", WZUIImage)

	if GlobalGame.g_tRedPointTypeList[117047] or GlobalGame.g_tRedPointTypeList[127047] or GlobalGame.g_tRedPointTypeList[137047] then 
		imgTaskRedDot:setVisible(true)
	else
		imgTaskRedDot:setVisible(false)
	end
end

--@brief 	更新异火的数量
function WndGarden:_updateLightNum()
	-- body
	local ftxtLightNum = GetElement(self.m_root, "ftxtLightNum_WndGarden", WZUIFreeTextBox)
	local sFormat = [[<I Z="0.5" P="1">%s</I><T C="255,255,255" S="20" P="1" SC="132,66,29" SS="4" SE="1">%d</T>]]
	if ftxtLightNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
		ftxtLightNum:setShowText(string.format(sFormat, basicData.icon, nLightNum))
	end
end

--@brief 	初始化活动时间
function WndGarden:_initActivityTime()
	-- body
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndGarden", WZUILabelTTF)
    if txtActivityTime then 
    	txtActivityTime:setText(LocalStrings.ACTIVITY_TIME_KEY .. ":" .. needDay_str)
    end
end

--@brief 	显示开启动画
function WndGarden:showOpenAction()
	-- body
	--创建选中特效
	local spinePath = "activity/ui_xdly_shou"
	local existSpine = CheckEffectFile(spinePath)
	if not existSpine then 
		local _sIndex = "ui_xdly_shou"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7047, downloadInfo.url, downloadInfo.md5, _sIndex, "DownloadResourceCallback", _G)
        end
	end
	
	local conOpenAct = GetElement(self.m_root, "conOpenAct_WndGarden", WZUIContainer)
	local spineFei = GetElement(self.m_root, "spineFei_WndGarden", WZUISpine)
	local nSpineTime = 0.5
	if spineFei and self.m_nTreeState == 0 then 
		nSpineTime = 0.9
		spineFei:setVisible(true)
		spineFei:play("wait1", false)
		conOpenAct:enableSchedule("showShootReward", nSpineTime)
		return 
	end

	local spineOpen = GetElement(self.m_root, "spineOpen_WndGarden", WZUISpine)
	if spineOpen then 
		spineOpen:setVisible(true)
		if existSpine then 
			spineOpen:play("wait" .. (self.m_nTreeState + 1), false)
			
			spineOpen:enableSchedule("hideWaitAni", 0.005)
			conOpenAct:enableSchedule("showShootReward", nSpineTime)
		else
			self:showShootReward()
		end
	end
end

--@brief 	隐藏待机果树
function WndGarden:hideWaitAni()
	local spineOpen = GetElement(self.m_root, "spineOpen_WndGarden", WZUISpine)
	spineOpen:disableSchedule()

	GetElement(self.m_root, "spineWait_WndGarden", WZUISpine):setVisible(false)
end

--@brief 	显示开启奖励
function WndGarden:showShootReward()
	-- body
	local conOpenAct = GetElement(self.m_root, "conOpenAct_WndGarden", WZUIContainer)
	conOpenAct:disableSchedule()
	GetElement(self.m_root, "spineFei_WndGarden", WZUISpine):setVisible(false)
	self:_setFreeBtnText()

	if self.m_tOpenResult.nScore > 0 then 
		local strGoods = string.format(LocalStrings.GARDEN_TEXT1[27], self.m_tOpenResult.nScore)
		MsgBoxManager:showTipBox(strGoods, nil, nil, nil, nil, nil, nil, nil, nil, {x=0.5, y=0.78})
	end
	GetElement(self.m_root, "spineOpen_WndGarden", WZUISpine):setVisible(false)

	self:setOpenState(false)
	self:_afterCloseReward()
end

--@brief 	iphoneX适配
function WndGarden:_adaptIphoneX()
	if IsIphoneX() then
		GetElement(self.m_root, "conLeftMenu_WndGarden", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.922,0.45))
	end
end

--@brief 	设置免费丢
function WndGarden:_setFreeBtnText()
	local txtBtnOpenOne = GetElement(self.m_root, "txtBtnOpenOne_WndGarden", WZUILabelTTF)
	local txtBtnOpenFive = GetElement(self.m_root, "txtBtnOpenFive_WndGarden", WZUILabelTTF)
	if self.m_nCount == 0 then 
		if self.m_nTreeState < 1 then 
			txtBtnOpenOne:setText(LocalStrings.GARDEN_TEXT1[8])
			txtBtnOpenFive:setText(string.format(LocalStrings.GARDEN_TEXT1[7], 5))
		else
			txtBtnOpenOne:setText(LocalStrings.GARDEN_TEXT1[14])
			txtBtnOpenFive:setText(string.format(LocalStrings.GARDEN_TEXT1[13], 5))
		end
	else
		if self.m_nTreeState >= 1 then 
			txtBtnOpenOne:setText(string.format(LocalStrings.GARDEN_TEXT1[13], 1))
			txtBtnOpenFive:setText(string.format(LocalStrings.GARDEN_TEXT1[13], 5))
		else
			txtBtnOpenOne:setText(string.format(LocalStrings.GARDEN_TEXT1[7], 1))
			txtBtnOpenFive:setText(string.format(LocalStrings.GARDEN_TEXT1[7], 5))
		end
	end
	self:_showPlantTip()
	--果树的状态
	local imgTree = GetElement(self.m_root, "imgTree_WndGarden", WZUIImage)
	local ftxtWelcome = GetElement(self.m_root, "ftxtWelcome_WndGarden", WZUIFreeTextBox)
	ftxtWelcome:setVisible(false)
	local btnPlant = GetElement(self.m_root, "btnPlant_WndGarden", WZUIButton)
	btnPlant:setVisible(false)
	local conMid = GetElement(self.m_root, "conMid_WndGarden", WZUIContainer)
	local conLeftMenu = GetElement(self.m_root, "conLeftMenu_WndGarden", WZUIContainer)
	local conPlantTip = GetElement(self.m_root, "conPlantTip_WndGarden", WZUIContainer)
	conMid:setVisible(true)
	conLeftMenu:setVisible(true)
	conPlantTip:setVisible(true)
	if self.m_nTreeState == -1 then 
		conMid:setVisible(false)
		conLeftMenu:setVisible(false)
		conPlantTip:setVisible(false)
		ftxtWelcome:setVisible(true)
		btnPlant:setVisible(true)
		imgTree:setFile("ui/specialBg/hd_pic_xdgy_01.png")
	elseif self.m_nTreeState >= 0 then 
		imgTree:setFile("")
		self:_showTreeWaitAni()
	end
end

--@brief 	刷新赛事礼包的信息
function WndGarden:showBagGiftInfo()
	-- body
	if self.m_nGiftRewardNum > 0 then 
		GetElement(self.m_root, "imgGiftRed_WndGarden", WZUIImage):setVisible(true)
		GetElement(self.m_root, "txtGiftNum_WndGarden", WZUILabelTTF):setText(self.m_nGiftRewardNum)
	else
		GetElement(self.m_root, "imgGiftRed_WndGarden", WZUIImage):setVisible(false)
	end
end

--@brief 	显示商店经营人、库存、积分信息
function WndGarden:_showStore()
	-- body
	GetElement(self.m_root, "conStore_WndGarden", WZUIContainer):setVisible(true)
	GetElement(self.m_root, "txtPlayerName_WndGarden", WZUILabelTTF):setText(CacheCenter:getPlayerInfo().name)
	GetElement(self.m_root, "txtStockNum_WndGarden", WZUILabelTTF):setText(string.format(LocalStrings.GARDEN_TEXT1[30], self.m_nStockNum))
	GetElement(self.m_root, "txtScoreNum_WndGarden", WZUILabelTTF):setText(self.m_nScoreNum)
end

--@brief 	显示果树提示语
function WndGarden:_showPlantTip()
	local tipsIndex = 0
	if self.m_nTreeState <= 0 then
		tipsIndex = 1
	else
		tipsIndex = 2
	end
	if self.m_nLastIndex == tipsIndex then return end 

	self.m_nLastIndex = tipsIndex
	local txtPlantTip = GetElement(self.m_root, "txtPlantTip_WndGarden", WZUILabelTTF)
	local nCount = #LocalStrings.GARDEN_TEXT3[tipsIndex]
	local tempRand = math.random(1, 10)
	local strIndex = math.fmod(tempRand, nCount) + 1
	txtPlantTip:setText(LocalStrings.GARDEN_TEXT3[tipsIndex][strIndex])
end

--@brief 	显示果树待机动画
function WndGarden:_showTreeWaitAni()
	local spinePath = "activity/ui_xdly_wait"
	local existSpine = CheckEffectFile(spinePath)
	if not existSpine then 
		local _sIndex = "ui_xdly_wait"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7048, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadSpineCallback", WndGarden)
        end
	end

	local spineOpen = GetElement(self.m_root, "spineWait_WndGarden", WZUISpine)
	if self.m_nTreeState == -1 then return end 
	
	if spineOpen then 
		spineOpen:setVisible(true)
		GetElement(self.m_root, "spineOpen_WndGarden", WZUISpine):setVisible(false)
		if existSpine then 
			self.m_nLastTreeState = self.m_nTreeState
			spineOpen:play("wait" .. (self.m_nTreeState + 1), true)
		end
	end
end

function WndGarden:downloadSpineCallback(taskId,extraData,failed)
    WZLog("WndGarden:downloadSpineCallback",taskId,extraData,failed)
    self:_showTreeWaitAni()
end
-------------------------------------私有方法模块End----------------------------------------

function WndGarden:_adaptLanguage_vn()
	GetElement(self.m_root, "txtBtnOpenOne_WndGarden", WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root, "txtBtnOpenFive_WndGarden", WZUILabelTTF):setScale(0.7)

	GetElement(self.m_root, "txtGiftReward_WndGarden", WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root, "txtBtnTask1_WndGarden", WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root, "txtBtnTask2_WndGarden", WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root, "txtBtnTask3_WndGarden", WZUILabelTTF):setScale(0.8)

	GetElement(self.m_root, "txtPlayer_WndGarden", WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root, "txtStock_WndGarden", WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root, "txtScore_WndGarden", WZUILabelTTF):setScale(0.8)

	GetElement(self.m_root, "txtActivityTime_WndGarden", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.47,0.19))
	GetElement(self.m_root, "btnBigReward_WndGarden", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.74,0.19))
	GetElement(self.m_root, "btnTip_WndGarden", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.65,0.25))
end