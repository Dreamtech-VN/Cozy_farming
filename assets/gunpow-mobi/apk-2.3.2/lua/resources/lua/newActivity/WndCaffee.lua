--WndCaffee.lua
--@brief	WndCaffee的UI模块
--@date		2022/04/21
--@author	XTX
--@note		咖啡大师活动主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCaffee:onEnter(element)
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
function WndCaffee:onExit(element)
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
function WndCaffee:onEnterTransitionDidFinish(element)
    WZLog("WndCaffee:onEnterTransitionDidFinish")
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7048, 7048)
end

--@brief    关闭窗口
function WndCaffee:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    --如果是自动弹出的活动界面
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮回调
function WndCaffee:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 
    WndSingleMapDesc:showInterface1(LocalStrings.CAFFEE_TEXT2) 
end

--@brief 	点击目标按钮回调
function WndCaffee:onClickTask(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if nTag == 1 then 
		CellNewYearTask:showInterface(12, self.m_nActivityId)
	elseif nTag == 2 then 
		WndShopRank:showInterface(23, self.m_nActivityId) 
	end
end

--@brief 	点击大奖预览按钮回调
function WndCaffee:onClickBigReward(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local otherData = {}
	otherData.winType = 1
	WndJoinReward:showInterface("", self.m_tBigRewardList[1], self.m_tBigRewardList[2], LocalStrings.TREASURE_TEXT7, nil, 2, otherData)
end

--@brief 	点击开启按钮回调
function WndCaffee:onClickFive(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	--背包已满提示
	WZLog("WndCaffee:onClickFive", self.m_bIsGrind)
	if not self.m_bIsGrind then --冲泡才判断背包是否已满
	    if CacheCenter:getRemainAmount() <= 0 then
	        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
	        return
	    end
	    if self.m_bOpenState then return end 

		local nArrowNum = self.m_nTimes
		local freeCount = self.m_nCount == 0 and 1 or 0 
		local nTimes = nTag
		if nTag == 5 then 
			nTag = 20 
			nTimes = (self.m_nTimes + freeCount) >= 20 and 20 or self.m_nTimes > 0 and (self.m_nTimes + freeCount) or 20 
		end
		WZLog("WndCaffee:onClickFive", nTimes,freeCount, nArrowNum)
		if nTimes - freeCount > nArrowNum then 
			self.m_bIsGrind = true --设置为研磨状态
			MsgBoxManager:showTipBox(LocalStrings.CAFFEE_TEXT1[16], nil, self, self._setFreeBtnText)
			return 
		end
	    local tData = {}
		tData.times = nTag

		local stringData = json.encode(tData)

		self:setOpenState(true)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 3, stringData)
	else
		if self.m_bOpenState then return end 
		local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
		if nArrowNum <= 0 then 
			local basicData = GDatatab_item["id_" .. self.m_nCoinId]
			MsgBoxManager:showConfirmBox(string.format(LocalStrings.WATERCOUNTRY_TEXT4, basicData.name), self, self.goToBuy)
			return 
		end
	    local tData = {}
	    if nTag == 5 then 
	    	tData.times = 0
	    else
			tData.times = nTag
		end

		local stringData = json.encode(tData)

		self:setOpenState(true)
		self:_showTalk()
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, stringData)
	end
end

--@brief 	前往小推车购买
function WndCaffee:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

--@brief 	点击冲泡按钮回调
--@note 	切换为冲泡按钮
function WndCaffee:onClickPlant(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_bIsGrind and self.m_nTimes <= 0 and self.m_nCount > 0 then 
		MsgBoxManager:showTipBox(LocalStrings.CAFFEE_TEXT1[12])
		return 
	end	

	self.m_bIsGrind = not self.m_bIsGrind --设置为冲泡状态
	WZLog("WndCaffee:onClickPlant", self.m_bIsGrind)
	self:_setFreeBtnText()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndCaffee:_update()
	-- body
	self:_setFreeBtnText()
	self:showRedDot()
	self:_initActivityTime()
    self:_updateLightNum()
    self:_showLeftTimes()
end

--@brief 	初始化静态文本
function WndCaffee:_initStaticText()
	GetElement(self.m_root, "txtBigReward_WndCaffee", WZUILabelTTF):setText(LocalStrings.TREASURE_TEXT7)
	GetElement(self.m_root, "txtBtnTask1_WndCaffee", WZUILabelTTF):setText(LocalStrings.CAFFEE_TEXT1[2])
	GetElement(self.m_root, "txtBtnTask2_WndCaffee", WZUILabelTTF):setText(LocalStrings.CAFFEE_TEXT1[3])
	GetElement(self.m_root, "txtBtnOpenFive_WndCaffee", WZUILabelTTF):setText(LocalStrings.CAFFEE_TEXT1[5])
	local img9Desk = GetElement(self.m_root, "img9Desk_WndCaffee", WZUI9Image)
	local resolutionSize = CCEGLView:sharedOpenGLView():getDesignResolutionSize()
	local screenSize = CCEGLView:sharedOpenGLView():getFrameSize()
	local nScaleX = screenSize.width / resolutionSize.width
    local nScaleY = screenSize.height / resolutionSize.height
    if nScaleY < nScaleX then 
    	img9Desk:setScaleX(resolutionSize.height / screenSize.height * nScaleX)
    end

	self:_setManEffect()
end

--@brief 	红点
function WndCaffee:showRedDot()
	-- body
	if self.m_root == nil then return end 

	local imgTaskRedDot = GetElement(self.m_root, "imgTaskRedDot_WndCaffee", WZUIImage)

	if GlobalGame.g_tRedPointTypeList[117048] or GlobalGame.g_tRedPointTypeList[127048] then 
		imgTaskRedDot:setVisible(true)
	else
		imgTaskRedDot:setVisible(false)
	end
end

--@brief 	更新异火的数量
function WndCaffee:_updateLightNum()
	-- body
	local txtLightNum = GetElement(self.m_root, "txtLightNum_WndCaffee", WZUILabelTTF)
	local imgCoin = GetElement(self.m_root, "imgCoin_WndCaffee", WZUIImage)
	if txtLightNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
		txtLightNum:setText(nLightNum)
		imgCoin:setFile(basicData.icon)

		if nLightNum > 0 or self.m_nTimes > 0 or self.m_nCount == 0 then 
			GetElement(self.m_root, "spineSwitch_WndCaffee", WZUISpine):setVisible(true)
		else
			GetElement(self.m_root, "spineSwitch_WndCaffee", WZUISpine):setVisible(false)
		end
	end
end

--@brief 	初始化活动时间
function WndCaffee:_initActivityTime()
	-- body
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndCaffee", WZUILabelTTF)
    if txtActivityTime then 
    	txtActivityTime:setText(LocalStrings.ACTIVITY_TIME_KEY .. ":" .. needDay_str)
    end
end

--@brief 	显示开启动画
function WndCaffee:showOpenAction()
	-- body
	--创建选中特效
	local spinePath = "activity/FX_coffee"
	local existSpine = CheckEffectFile(spinePath)
	if not existSpine then 
		local _sIndex = "FX_coffee"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7049, downloadInfo.url, downloadInfo.md5, _sIndex, "DownloadResourceCallback", _G)
        end
	end

	local spineOpen = GetElement(self.m_root, "spineOpen_WndCaffee", WZUISpine)
	if spineOpen then 
		spineOpen:setVisible(true)
		if existSpine then 
			spineOpen:setFileAtlas(spinePath .. ".atlas")
			spineOpen:setFileJson(spinePath .. ".json")
			spineOpen:play("wait", false)
			local conOpenAct = GetElement(self.m_root, "conOpenAct_WndCaffee", WZUIContainer)
			conOpenAct:enableSchedule("showShootReward", 1.5)
		else
			self:showShootReward()
		end
	end
end

--@brief 	显示开启奖励
function WndCaffee:showShootReward()
	-- body
	local conOpenAct = GetElement(self.m_root, "conOpenAct_WndCaffee", WZUIContainer)
	conOpenAct:disableSchedule()
	GetElement(self.m_root, "spineOpen_WndCaffee", WZUISpine):setVisible(false)

	if self.m_tOpenResult.nScore and self.m_tOpenResult.nScore > 0 then 
		local strGoods = LocalStrings.CAFFEE_TEXT1[4] .. "+" .. self.m_tOpenResult.nScore
		MsgBoxManager:showTipBox(strGoods, nil, nil, nil, nil, nil, nil, nil, nil, {x=0.5, y=0.78})
	end

	self:setOpenState(false)
	self:_afterCloseReward()
end

--@brief 	显示研磨动画
function WndCaffee:showGrindAction()
	-- body
	--创建选中特效
	local spinePath = "activity/ui_master"
	local existSpine = CheckEffectFile(spinePath)
	if not existSpine then 
		local _sIndex = "ui_master"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(70491, downloadInfo.url, downloadInfo.md5, _sIndex, "DownloadResourceCallback", _G)
        end
	end

	local spineMan = GetElement(self.m_root, "spineMan_WndCaffee", WZUISpine)
	local spineManWait = GetElement(self.m_root, "spineManWait_WndCaffee", WZUISpine)
	if spineMan then 
		spineMan:setVisible(true)
		if existSpine then 
			spineMan:setLoop(false)
			spineMan:setAnimationName("wait_2")
			spineMan:enableSchedule("afterGrind", 2.1)
			spineManWait:setVisible(false)
		else
			self:afterGrind()
		end
	end
end

--@brief 	研磨后更新数据
function WndCaffee:afterGrind()
	local spineMan = GetElement(self.m_root, "spineMan_WndCaffee", WZUISpine)
	spineMan:disableSchedule()
	GetElement(self.m_root, "spineManWait_WndCaffee", WZUISpine):setVisible(true)
	spineMan:setVisible(false)

	MsgBoxManager:showTipBox(LocalStrings.CAFFEE_TEXT1[15])
	self:setOpenState(false)
	self:_showLeftTimes()
end

--@brief 	iphoneX适配
function WndCaffee:_adaptIphoneX()
	if IsIphoneX() then
		GetElement(self.m_root, "conLeftMenu_WndCaffee", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.05,0.62))
	end
end

--@brief 	设置免费研磨
function WndCaffee:_setFreeBtnText()
	local txtBtnOpenOne = GetElement(self.m_root, "txtBtnOpenOne_WndCaffee", WZUILabelTTF)
	local txtBtnOpenOther = GetElement(self.m_root, "txtBtnOpenOther_WndCaffee", WZUILabelTTF)
	if self.m_bIsGrind then 
		txtBtnOpenOne:setText(string.format(LocalStrings.CAFFEE_TEXT1[11], 1))
		txtBtnOpenOther:setText(LocalStrings.CAFFEE_TEXT1[14])
	else
		local freeTimes = 0 
		if self.m_nCount == 0 then 
			freeTimes = 1
			txtBtnOpenOne:setText(LocalStrings.CAFFEE_TEXT1[6])
		else
			txtBtnOpenOne:setText(string.format(LocalStrings.CAFFEE_TEXT1[13], 1))
		end

		local nTimes = (self.m_nTimes + freeTimes) >= 20 and 20 or self.m_nTimes > 0 and (self.m_nTimes + freeTimes) or 20 
		txtBtnOpenOther:setText(string.format(LocalStrings.CAFFEE_TEXT1[13], nTimes))
	end
	if self.m_bIsGrind then 
		GetElement(self.m_root, "txtBtnOpenFive_WndCaffee", WZUILabelTTF):setText(LocalStrings.CAFFEE_TEXT1[5])
	else
		GetElement(self.m_root, "txtBtnOpenFive_WndCaffee", WZUILabelTTF):setText(LocalStrings.CAFFEE_TEXT1[17])
	end
end

--@brief 	显示冲泡次数
function WndCaffee:_showLeftTimes()
	-- body
	GetElement(self.m_root, "txtTimes_WndCaffee", WZUILabelTTF):setText(self.m_nTimes)
	local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	if nLightNum > 0 or self.m_nTimes > 0 or self.m_nCount == 0 then 
		GetElement(self.m_root, "spineSwitch_WndCaffee", WZUISpine):setVisible(true)
	else
		GetElement(self.m_root, "spineSwitch_WndCaffee", WZUISpine):setVisible(false)
	end
end

--@brief 	显示咖啡师的对话
function WndCaffee:_showTalk()
	local conTalk = GetElement(self.m_root, "conTalk_WndCaffee", WZUIContainer)
	conTalk:setVisible(true)

	local txtTalk = GetElement(self.m_root, "txtTalk_WndCaffee", WZUILabelTTF)
	local nCount = #LocalStrings.CAFFEE_TEXT3
	local tempRand = math.random(1, 10)
	local strIndex = math.fmod(tempRand, nCount) + 1
	if self.m_nLastTalkIndex == strIndex or self.m_nTalkGapping ~= nil then return end 
	self.m_nLastTalkIndex = strIndex
	self.m_nTalkGapping = 5
	txtTalk:setText(LocalStrings.CAFFEE_TEXT3[strIndex] or LocalStrings.CAFFEE_TEXT3[1])
end

--@brief 	计时器
function WndCaffee:_caculateTime()
	-- body
	if self.m_nTalkGapping == nil then return end 

	if self.m_nTalkGapping > 0 then 
		self.m_nTalkGapping = self.m_nTalkGapping - 1
	else
		self.m_nTalkGapping = nil 
		self.m_nLastTalkIndex = 0
		GetElement(self.m_root, "conTalk_WndCaffee", WZUIContainer):setVisible(false)
	end
end

--@brief 	设置待机特效
function WndCaffee:_setManEffect()
	local spinePath = "activity/ui_master"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		local spineMan = GetElement(self.m_root, "spineMan_WndCaffee", WZUISpine)
		local spineManWait = GetElement(self.m_root, "spineManWait_WndCaffee", WZUISpine)
		if spineMan then 
			spineMan:setFileJson(spinePath .. ".json")
			spineMan:setFileAtlas(spinePath .. ".atlas")
		end
		if spineManWait then
			spineManWait:setFileJson(spinePath .. ".json")
			spineManWait:setFileAtlas(spinePath .. ".atlas")
			spineManWait:play("wait_1", true)
		end
	else
		local _sIndex = "ui_master"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(70491, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndCaffee)
        end
	end
end

function WndCaffee:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndCaffee:downloadEffectCallback",taskId,extraData,failed)
    self:_setManEffect()
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配begin----------------------------------------

function WndCaffee:_adaptLanguage_vn( )
    local txtBtnTask1 = GetElement(self.m_root, "txtBtnTask1_WndCaffee", WZUILabelTTF)
    txtBtnTask1:setFontSize(14)
    -- txtBtnTask1:setDimensions(GlobalMethod:CCSize(80,0))
    local txtBtnTask2 = GetElement(self.m_root, "txtBtnTask2_WndCaffee", WZUILabelTTF)
    txtBtnTask2:setFontSize(14)
    -- txtBtnTask2:setDimensions(GlobalMethod:CCSize(80,0))
    local txtBigReward = GetElement(self.m_root, "txtBigReward_WndCaffee", WZUILabelTTF)
    txtBigReward:setFontSize(14)
    -- txtBigReward:setDimensions(GlobalMethod:CCSize(80,0))

    GetElement(self.m_root, "txtTalk_WndCaffee", WZUILabelTTF):setScale(0.7)

    GetElement(self.m_root, "txtBtnOpenOne_WndCaffee", WZUILabelTTF):setFontSize(20)
    GetElement(self.m_root, "txtBtnOpenFive_WndCaffee", WZUILabelTTF):setFontSize(20)
end

-------------------------------------语言适配end----------------------------------------
