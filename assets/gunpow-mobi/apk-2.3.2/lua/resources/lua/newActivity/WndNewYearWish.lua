--WndNewYearWish.lua
--@brief	WndNewYearWish的UI模块
--@date		2021/12/09
--@author	XTX
--@note		新年愿望活动主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndNewYearWish:onEnter(element)
	self.m_root = element

	g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
	ProtocolProcessorFestivalActivity:regAll6()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)

	self:_initStaticText()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndNewYearWish:onExit(element)
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
function WndNewYearWish:onEnterTransitionDidFinish(element)
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7033, 7033)
    self:showRedDot()
end

--@brief    关闭窗口
function WndNewYearWish:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    --如果是自动弹出的活动界面
   WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮回调
function WndNewYearWish:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 
    WndSingleMapDesc:showInterface1(LocalStrings.NEWYEARWISH_TEXT2) 
end

--@brief 	点击目标按钮回调
function WndNewYearWish:onClickTask(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if nTag == 1 then 
		CellNewYearTask:showInterface(6, self.m_nActivityId)
	elseif nTag == 2 then
		WndHouseInvite:showInterface(3, self.m_nActivityId)
	elseif nTag == 3 then 
		WndShopRank:showInterface(16, self.m_nActivityId) 
	end
end

--@brief 	点击大奖预览按钮回调
function WndNewYearWish:onClickBigReward(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WndJoinReward:showInterface("", self.m_tBigRewardList[1], self.m_tBigRewardList[2], LocalStrings.TREASURE_TEXT7, nil, 2)
end

--@brief 	点击开启按钮回调
function WndNewYearWish:onClickFive(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	local nTimes = 1 
	if nTag == 0 then 
		nTimes = 6
	end
	--背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
    if self.m_bOpenState then return end 

	local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local nArrowNum2 = CacheCenter:getPlayerItemCountById(self.m_nCoinId2)
	local nArrowNum = nArrowNum + nArrowNum2
	if nTimes > nArrowNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		MsgBoxManager:showConfirmBox(string.format(LocalStrings.WATERCOUNTRY_TEXT4, basicData.name), self, self.goToBuy)
		return 
	end
    local tData = {}
	tData.wishTheme = nTag

	local stringData = json.encode(tData)

	self:setOpenState(true)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 1, stringData)
end

--@brief 	前往小推车购买
function WndNewYearWish:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

--@brief 	点击选中许愿卡
function WndNewYearWish:onClickCard(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local nTag = element:getTag()
	for i = 1, 6 do
		local cbCard = GetElement(self.m_root, "cbCard" .. i .. "_WndNewYearWish", WZUICheckBox)
		local btnWish = GetElement(self.m_root, "btnWish" .. i .. "_WndNewYearWish", WZUIButton)
		if i ~= nTag then 
			cbCard:setCheckIndex(0)
			btnWish:setVisible(false)
		end
	end

	local checkIndex = GetElement(self.m_root, "cbCard" .. nTag .. "_WndNewYearWish", WZUICheckBox):getCheckIndex()
	if checkIndex == 1 then 
		GetElement(self.m_root, "btnWish" .. nTag .. "_WndNewYearWish", WZUIButton):setVisible(true)
	else
		GetElement(self.m_root, "btnWish" .. nTag .. "_WndNewYearWish", WZUIButton):setVisible(false)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndNewYearWish:_update()
	-- body
	self:_initActivityTime()
    self:_updateLightNum()
end

--@brief 	初始化静态文本
function WndNewYearWish:_initStaticText()
	GetElement(self.m_root, "txtBtnOpenFive_WndNewYearWish", WZUILabelTTF):setText(LocalStrings.NEWYEARWISH_TEXT1[8])
	GetElement(self.m_root, "txtBtnTask1_WndNewYearWish", WZUILabelTTF):setText(LocalStrings.NEWYEARWISH_TEXT1[2])
	GetElement(self.m_root, "txtBtnTask2_WndNewYearWish", WZUILabelTTF):setText(LocalStrings.NEWYEARWISH_TEXT1[4])
	GetElement(self.m_root, "txtBtnTask3_WndNewYearWish", WZUILabelTTF):setText(LocalStrings.NEWYEARWISH_TEXT1[5])
	GetElement(self.m_root, "txtBtnTaskSel1_WndNewYearWish", WZUILabelTTF):setText(LocalStrings.NEWYEARWISH_TEXT1[2])
	GetElement(self.m_root, "txtBtnTaskSel2_WndNewYearWish", WZUILabelTTF):setText(LocalStrings.NEWYEARWISH_TEXT1[4])
	GetElement(self.m_root, "txtBtnTaskSel3_WndNewYearWish", WZUILabelTTF):setText(LocalStrings.NEWYEARWISH_TEXT1[5])

	for i = 1, 6 do
		local txtCard = GetElement(self.m_root, "txtCard" .. i .. "_WndfNewYearWish", WZUILabelTTF)
		local txtCardSel = GetElement(self.m_root, "txtCardSel" .. i .. "_WndfNewYearWish", WZUILabelTTF)
		if txtCard and txtCardSel then 
			local strContent = ""
			for j = 1, #LocalStrings.NEWYEARWISH_TEXT3[i] do
				strContent = strContent.. " " .. LocalStrings.NEWYEARWISH_TEXT3[i][j]
			end
			txtCard:setText(strContent)
			txtCardSel:setText(strContent)
		end
	end

	self:_setBallAni()
end

--@brief 	红点
function WndNewYearWish:showRedDot()
	-- body
	if self.m_root == nil then return end 

	local imgTaskRedDot = GetElement(self.m_root, "imgTaskRedDot_WndNewYearWish", WZUIImage)
	local imgCardRedDot = GetElement(self.m_root, "imgCardRedDot_WndNewYearWish", WZUIImage)

	if GlobalGame.g_tRedPointTypeList[117033] or GlobalGame.g_tRedPointTypeList[127033] then 
		imgTaskRedDot:setVisible(true)
	else
		imgTaskRedDot:setVisible(false)
	end
	if GlobalGame.g_tRedPointTypeList[27033] then 
		imgCardRedDot:setVisible(true)
	else
		imgCardRedDot:setVisible(false)
	end
end

--@brief 	更新灯火的数量
function WndNewYearWish:_updateLightNum()
	-- body
	local ftxtLightNum = GetElement(self.m_root, "ftxtLightNum_WndNewYearWish", WZUIFreeTextBox)
	local ftxtLightNum1 = GetElement(self.m_root, "ftxtLightNum1_WndNewYearWish", WZUIFreeTextBox)
	local sFormat = [[<I Z="0.5" P="1">%s</I><T C="255,255,255" S="20" P="1" SC="132,66,29" SS="4" SE="1">%d</T>]]
	if ftxtLightNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
		ftxtLightNum:setShowText(string.format(sFormat, basicData.icon, nLightNum))
	end
	if ftxtLightNum1 then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId2]
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId2)
		ftxtLightNum1:setShowText(string.format(sFormat, basicData.icon, nLightNum))
	end
end

--@brief 	初始化活动时间
function WndNewYearWish:_initActivityTime()
	-- body
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndNewYearWish", WZUILabelTTF)
    if txtActivityTime then 
    	txtActivityTime:setText(LocalStrings.ACTIVITY_TIME_KEY .. ":" .. needDay_str)
    end
end

--@brief 	显示开启动画
function WndNewYearWish:showOpenAction()
	-- body
	self:showShootReward()
end

--@brief 	显示开启奖励
function WndNewYearWish:showShootReward()
	-- body
	self:setOpenState(false)
	WZLog("WndNewYearWish:showShootReward", Serialize(self.m_tOpenResult.itemIds), Serialize(self.m_tOpenResult.itemNums))
	WndRewardShow:showById(self.m_tOpenResult.itemIds, self.m_tOpenResult.itemNums)
	WndRewardShow:closeCallBack(self, self._afterCloseReward)
	if self.m_tOpenResult.sGetWords ~= "" then 
		MsgBoxManager:showTipBox(string.format(LocalStrings.NEWYEARWISH_TEXT1[7], self.m_tOpenResult.sGetWords), nil, nil, nil, nil, nil, nil, nil, nil, GlobalMethod:ccp(0.5, 0.77))
	end
end

--@brief 	设置待机特效
function WndNewYearWish:_setBallAni()
	local spinePath = "activity/ui_common_xnyw"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		for i = 1, 6 do
			local spineSel = GetElement(self.m_root, "spineSel" .. i .. "_WndNewYearWish", WZUISpine)
			if spineSel then 
				spineSel:setFileJson(spinePath .. ".json")
				spineSel:setFileAtlas(spinePath .. ".atlas")
				spineSel:play("wait4", true)
			end
		end
	else
		local _sIndex = "ui_common_xnyw"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7033, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndNewYearWish)
        end
	end
end

function WndNewYearWish:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndNewYearWish:downloadEffectCallback",taskId,extraData,failed)
    self:_setBallAni()
end


-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配begin----------------------------------------

function WndNewYearWish:_adaptLanguage_vn()
	for i = 1, 6 do
		local txtCard = GetElement(self.m_root, "txtCard" .. i .. "_WndfNewYearWish", WZUILabelTTF)
		local txtCardSel = GetElement(self.m_root, "txtCardSel" .. i .. "_WndfNewYearWish", WZUILabelTTF)
		if txtCard and txtCardSel then
			txtCard:setFontSize(18)
			txtCardSel:setFontSize(18)
		end
	end
	for i = 1, 3 do
		local txtBtnTask = GetElement(self.m_root, "txtBtnTask" .. i .. "_WndNewYearWish", WZUILabelTTF)
		local txtBtnTaskSel = GetElement(self.m_root, "txtBtnTaskSel" .. i .. "_WndNewYearWish", WZUILabelTTF)
		if txtBtnTask and txtBtnTaskSel then
			txtBtnTask:setFontSize(14)
			txtBtnTaskSel:setFontSize(14)
		end
	end
end


-------------------------------------语言适配End----------------------------------------