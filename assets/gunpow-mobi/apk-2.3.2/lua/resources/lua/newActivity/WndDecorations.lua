--WndDecorations.lua
--@brief	WndDecorations的UI模块
--@date		2021/11/16
--@author	XTX
--@note		张灯结彩活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndDecorations:onEnter(element)
	self.m_root = element

	g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
	ProtocolProcessorFestivalActivity:regAll6()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)

	self:_initStaticText()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndDecorations:onExit(element)
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
function WndDecorations:onEnterTransitionDidFinish(element)
    WZLog("WndDecorations:onEnterTransitionDidFinish")
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7030, 7030)
    self:showRedDot()
end

--@brief    关闭窗口
function WndDecorations:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    --如果是自动弹出的活动界面
   WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮回调
function WndDecorations:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 
    WndSingleMapDesc:showInterface1(LocalStrings.DECORATIONS_TEXT3) 
end

--@brief 	点击目标按钮回调
function WndDecorations:onClickTask(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if nTag == 1 then 
		CellNewYearTask:showInterface(4, self.m_nActivityId)
	elseif nTag == 2 then
		WndHouseInvite:showInterface(2, self.m_nActivityId)
	elseif nTag == 3 then 
		WndShopRank:showInterface(14, self.m_nActivityId) 
	end
end

--@brief 	点击大奖预览按钮回调
function WndDecorations:onClickBigReward(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WndJoinReward:showInterface("", self.m_tBigRewardList[1], self.m_tBigRewardList[2], LocalStrings.TREASURE_TEXT7, nil, 2)
end

--@brief 	点击开启按钮回调
function WndDecorations:onClickFive(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	--背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
    if self.m_bOpenState then return end 

	local nArrowNum = CacheCenter:getPlayerItemCountById(160166)
	if nTag > nArrowNum then 
		local basicData = GDatatab_item["id_160166"]
		MsgBoxManager:showConfirmBox(string.format(LocalStrings.WATERCOUNTRY_TEXT4, basicData.name), self, self.goToBuy)
		return 
	end
    local tData = {}
	tData.times = nTag
	tData.optType = 1
	tData.costCardNum = 0

	local stringData = json.encode(tData)

	self:setOpenState(true)
	self.m_nLastLightState = self.m_tContent.lightStates
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 1, stringData)
end

--@brief 	前往小推车购买
function WndDecorations:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndDecorations:_update()
	-- body
	self:_initActivityTime()
    self:_updateLightNum()
    self:showLightState()
end

--@brief 	初始化静态文本
function WndDecorations:_initStaticText()
	GetElement(self.m_root, "txtBtnOpenOne_WndDecorations", WZUILabelTTF):setText(string.format(LocalStrings.DECORATIONS_TEXT1[2], 1))
	GetElement(self.m_root, "txtBtnOpenFive_WndDecorations", WZUILabelTTF):setText(string.format(LocalStrings.DECORATIONS_TEXT1[2], 5))
	GetElement(self.m_root, "txtBtnTask1_WndDecorations", WZUILabelTTF):setText(LocalStrings.TASK_UINAME)
	GetElement(self.m_root, "txtBtnTask2_WndDecorations", WZUILabelTTF):setText(LocalStrings.DECORATIONS_TEXT1[3])
	GetElement(self.m_root, "txtBtnTask3_WndDecorations", WZUILabelTTF):setText(LocalStrings.RANKLIST_TITLE)

	self:_setBallAni()
end

--@brief 	红点
function WndDecorations:showRedDot()
	-- body
	if self.m_root == nil then return end 

	local imgTaskRedDot = GetElement(self.m_root, "imgTaskRedDot_WndDecorations", WZUIImage)
	local imgCardRedDot = GetElement(self.m_root, "imgCardRedDot_WndDecorations", WZUIImage)

	if GlobalGame.g_tRedPointTypeList[117030] or GlobalGame.g_tRedPointTypeList[127030] then 
		imgTaskRedDot:setVisible(true)
	else
		imgTaskRedDot:setVisible(false)
	end
	if GlobalGame.g_tRedPointTypeList[27030] then 
		imgCardRedDot:setVisible(true)
	else
		imgCardRedDot:setVisible(false)
	end
end

--@brief 	更新灯火的数量
function WndDecorations:_updateLightNum()
	-- body
	local ftxtLightNum = GetElement(self.m_root, "ftxtLightNum_WndDecorations", WZUIFreeTextBox)
	if ftxtLightNum then 
		local basicData = GDatatab_item["id_160166"]
		local sFormat = [[<I Z="0.5" P="1">%s</I><T C="255,255,255" S="20" P="1" SC="132,66,29" SS="4" SE="1">%d</T>]]
		local nLightNum = CacheCenter:getPlayerItemCountById(160166)
		ftxtLightNum:setShowText(string.format(sFormat, basicData.icon, nLightNum))
	end
end

--@brief 	初始化活动时间
function WndDecorations:_initActivityTime()
	-- body
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndDecorations", WZUILabelTTF)
    if txtActivityTime then 
    	txtActivityTime:setText(LocalStrings.ACTIVITY_TIME_KEY .. ":" .. needDay_str)
    end
end

--@brief 	显示开启动画
function WndDecorations:showOpenAction()
	-- body
	local conOpenAct = GetElement(self.m_root, "conOpenAct_WndDecorations", WZUIContainer)
	conOpenAct:setVisible(true)
	local tLastBit = WndCheckOther:_NumberToBits(self.m_nLastLightState, 6)
	local tCurBit = WndCheckOther:_NumberToBits(self.m_tContent.lightStates, 6)
	for i = 1, 6 do
		local spineBow = GetElement(self.m_root, "spineOpen" .. i .. "_WndDecorations", WZUISpine)
		if spineBow and tLastBit[i] ~= tCurBit[i] and tCurBit[i] == 1 then 
			spineBow:setVisible(true)
			spineBow:play("wait3", false)
		elseif spineBow and tLastBit[i] ~= tCurBit[i] and tCurBit[i] == 0 then 
			spineBow:setVisible(true)
			spineBow:play("wait4", false)
		end
	end
	conOpenAct:enableSchedule("showShootReward", 0.7)
end

--@brief 	显示开启奖励
function WndDecorations:showShootReward()
	-- body
	local conOpenAct = GetElement(self.m_root, "conOpenAct_WndDecorations", WZUIContainer)
	conOpenAct:disableSchedule()
	for i = 1, 6 do
		local spineBow = GetElement(self.m_root, "spineOpen" .. i .. "_WndDecorations", WZUISpine)
		spineBow:setVisible(false)
	end
	self:showLightState()

	self:setOpenState(false)
	WndRewardShow:showById(self.m_tOpenResult.itemIds, self.m_tOpenResult.itemNums)
	WndRewardShow:closeCallBack(self, self._afterCloseReward)
	if self.m_tOpenResult.congratCardNum > 0 then 
		MsgBoxManager:showTipBox(string.format(LocalStrings.DECORATIONS_TEXT1[4], self.m_tOpenResult.congratCardNum), nil, nil, nil, nil, nil, nil, nil, nil, GlobalMethod:ccp(0.5, 0.77))
	end

	conOpenAct:setVisible(false)
end

--@brief 	设置显示灯笼点亮
function WndDecorations:showLightState()
	-- body
	local tBit = WndCheckOther:_NumberToBits(self.m_tContent.lightStates, 6)

	for i = 1, 6 do
		local imgLight = GetElement(self.m_root, "imgLight" .. i .. "_WndDecorations", WZUIImage)
		if imgLight then 
			if tBit[i] == 0 then 
				imgLight:setFile("ui/newActivity/hd_pic_zdjc_zc.png")
			else
				imgLight:setFile("ui/newActivity/hd_pic_zdjc_dl.png")
			end
		end
	end
end

--@brief 	设置待机特效
function WndDecorations:_setBallAni()
	local spinePath = "activity/ui_common_zdjc"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		for i = 1, 6 do
			local spineOpen = GetElement(self.m_root, "spineOpen" .. i .. "_WndDecorations", WZUISpine)
			if spineOpen then 
				spineOpen:setFileJson(spinePath .. ".json")
				spineOpen:setFileAtlas(spinePath .. ".atlas")
			end
		end
	else
		local _sIndex = "ui_common_zdjc"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7030, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndDecorations)
        end
	end
end

function WndDecorations:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndDecorations:downloadEffectCallback",taskId,extraData,failed)
    self:_setBallAni()
end
-------------------------------------私有方法模块End----------------------------------------
