--WndSetCircle.lua
--@brief	WndSetCircle的UI模块
--@date		2022/03/24
--@author	XTX
--@note		套圈圈活动主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSetCircle:onEnter(element)
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
function WndSetCircle:onExit(element)
	g_bIsShowWndDressUp = true
    g_tTempItemForLaterShow = {}
	CacheCenter:unregisterUpatePlayerItemObserver(self)
	ProtocolProcessorFestivalActivity:unregAll6()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
	GlobalGame:getGameEventDispathcer():Remove(Independent_Activity.ActivityReddot, self.showRedDot, self)

	if self.m_root then 
		local conOpenAct = GetElement(self.m_root, "conOpenAct_WndSetCircle", WZUIContainer)
		conOpenAct:disableSchedule()
	end

	self:_unInit()
	LoadNewActivityRes(false)
end

--@brief    onenter函数已执行
function WndSetCircle:onEnterTransitionDidFinish(element)
    WZLog("WndSetCircle:onEnterTransitionDidFinish")
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7046, 7046)
end

--@brief    关闭窗口
function WndSetCircle:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    --如果是自动弹出的活动界面
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮回调
function WndSetCircle:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 
    WndSingleMapDesc:showInterface1(LocalStrings.SETCIRCLE_TEXT2) 
end

--@brief 	点击目标按钮回调
function WndSetCircle:onClickTask(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if nTag == 1 then 
		CellNewYearTask:showInterface(10, self.m_nActivityId)
	elseif nTag == 2 then
		WndDollMachineShop:showInterface(4, self.m_nActivityId)
	elseif nTag == 3 then 
		WndShopRank:showInterface(21, self.m_nActivityId) 
	end
end

--@brief 	点击大奖预览按钮回调
function WndSetCircle:onClickBigReward(element)
	-- body
	local eleType = type(element)
	if eleType ~= "number" then 
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	end

	local otherData = {}
	otherData.winType = 1
	if self.m_tBigRewardList ~= nil then
		self.m_bIsOpenReward = true 
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, "")
	end
end

--@brief 	点击开启按钮回调
function WndSetCircle:onClickFive(element)
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
		SaveOperateTimes("SETCIRCLEACTIVITYID", self.m_nActivityId)
    	return 
    end

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
function WndSetCircle:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndSetCircle:_update()
	-- body
	self:_setFreeBtnText()
	self:showRedDot()
	self:_initActivityTime()
    self:_updateLightNum()
end

--@brief 	初始化静态文本
function WndSetCircle:_initStaticText()
	GetElement(self.m_root, "txtBtnOpenFive_WndSetCircle", WZUILabelTTF):setText(string.format(LocalStrings.SETCIRCLE_TEXT1[7], 5))
	GetElement(self.m_root, "txtBigReward_WndSetCircle", WZUILabelTTF):setText(LocalStrings.TREASURE_TEXT7)
	GetElement(self.m_root, "txtBtnTask1_WndSetCircle", WZUILabelTTF):setText(LocalStrings.SETCIRCLE_TEXT1[11])
	GetElement(self.m_root, "txtBtnTask2_WndSetCircle", WZUILabelTTF):setText(LocalStrings.SETCIRCLE_TEXT1[3])
	GetElement(self.m_root, "txtBtnTask3_WndSetCircle", WZUILabelTTF):setText(LocalStrings.RANKLIST_TITLE)
	self:_setWaitingEffect()
	self:_setDollSpine()
end

--@brief 	红点
function WndSetCircle:showRedDot()
	-- body
	if self.m_root == nil then return end 

	local imgTaskRedDot = GetElement(self.m_root, "imgTaskRedDot_WndSetCircle", WZUIImage)

	if GlobalGame.g_tRedPointTypeList[117046] or GlobalGame.g_tRedPointTypeList[127046] or GlobalGame.g_tRedPointTypeList[137046] then 
		imgTaskRedDot:setVisible(true)
	else
		imgTaskRedDot:setVisible(false)
	end
end

--@brief 	更新异火的数量
function WndSetCircle:_updateLightNum()
	-- body
	local ftxtLightNum = GetElement(self.m_root, "ftxtLightNum_WndSetCircle", WZUIFreeTextBox)
	local sFormat = [[<I Z="0.5" P="1">%s</I><T C="255,255,255" S="20" P="1" SC="132,66,29" SS="4" SE="1">%d</T>]]
	if ftxtLightNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
		ftxtLightNum:setShowText(string.format(sFormat, basicData.icon, nLightNum))
	end
end

--@brief 	初始化活动时间
function WndSetCircle:_initActivityTime()
	-- body
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndSetCircle", WZUILabelTTF)
    if txtActivityTime then 
    	txtActivityTime:setText(LocalStrings.ACTIVITY_TIME_KEY .. ":" .. needDay_str)
    end
end

--@brief 	显示开启动画
function WndSetCircle:showOpenAction()
	-- body
	--创建选中特效
	local spinePath = "activity/ui_tqq_xz"
	local existSpine = CheckEffectFile(spinePath)
	if not existSpine then 
		local _sIndex = "ui_tqq_xz"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7047, downloadInfo.url, downloadInfo.md5, _sIndex, "DownloadResourceCallback", _G)
        end
	end
	for i = 1, #self.m_tOpenResult.rewardType do
		if existSpine then 
			for j = 1, #self.m_tArrayEffectPos do
				local conChooseSpine = GetElement(self.m_root, "conChooseSpine" .. j .. "_WndSetCircle", WZUIContainer)
				local bFind = false 
				for key, pos in pairs(self.m_tArrayEffectPos[j]) do
					if tonumber(key) == self.m_tOpenResult.rewardType[i] then 
						bFind = true 
						local data = {}
						data.path = spinePath
						data.play = "wait1"
						data.loop = true
						data.ccp = GlobalMethod:ccp(pos[1], pos[2])
						createEffectSpine(conChooseSpine, data)
						break 
					end
				end
				if bFind then break end 
			end
		end
		local spineOpen = GetElement(self.m_root, "spineOpen" .. self.m_tOpenResult.rewardType[i] .. "_WndSetCircle", WZUISpine)
		if spineOpen then 
			spineOpen:play("wait_2", false)
		end
		if i == #self.m_tOpenResult.rewardType then 
			local conOpenAct = GetElement(self.m_root, "conOpenAct_WndSetCircle", WZUIContainer)
			conOpenAct:enableSchedule("showShootReward", 0.8)
		end
	end
end

--@brief 	显示开启奖励
function WndSetCircle:showShootReward()
	-- body
	local conOpenAct = GetElement(self.m_root, "conOpenAct_WndSetCircle", WZUIContainer)
	conOpenAct:disableSchedule()

	if #self.m_tOpenResult.dropDoll > 0 or self.m_tOpenResult.nScore > 0 then 
		local strGoods = ""
		for i = 1, #self.m_tOpenResult.dropDoll do
			local basicData = GDatatab_item["id_" .. self.m_tOpenResult.dropDoll[i][1]]
			if basicData then 
				if i > 1 then 
					strGoods = strGoods .. ", "
				end
				strGoods = strGoods .. basicData.name .. "*" .. self.m_tOpenResult.dropDoll[i][2]
			end
		end
		if self.m_tOpenResult.nScore > 0 then 
			if strGoods ~= "" then 
				strGoods = strGoods .. ", "
			end
			strGoods = strGoods .. LocalStrings.INTEGRATION .. "+" .. self.m_tOpenResult.nScore
		end
		local strContent = LocalStrings.CRAZY_DOUBLING_TEXT8 .. strGoods
		MsgBoxManager:showTipBox(strContent, nil, nil, nil, nil, nil, nil, nil, nil, {x=0.5, y=0.78})
	end

	self:setOpenState(false)
	self:_afterCloseReward()
end

--@brief 	iphoneX适配
function WndSetCircle:_adaptIphoneX()
	if IsIphoneX() then
		GetElement(self.m_root, "conLeftMenu_WndSetCircle", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.09,0.45))
	end
end

--@brief 	设置免费丢
function WndSetCircle:_setFreeBtnText()
	local txtBtnOpenOne = GetElement(self.m_root, "txtBtnOpenOne_WndSetCircle", WZUILabelTTF)

	if self.m_nCount == 0 then 
		txtBtnOpenOne:setText(LocalStrings.SETCIRCLE_TEXT1[8])
	else
		txtBtnOpenOne:setText(string.format(LocalStrings.SETCIRCLE_TEXT1[7], 1))
	end
end

--@brief 	设置待机特效
function WndSetCircle:_setWaitingEffect()
	local spinePath = "activity/ui_tqq_sg"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		for i = 1, 9 do 
			local spineWait = GetElement(self.m_root, "spineWait" .. i .. "_WndSetCircle", WZUISpine)
			if spineWait then 
				spineWait:setFileJson(spinePath .. ".json")
				spineWait:setFileAtlas(spinePath .. ".atlas")
				spineWait:play("wait1", true)
			end
		end
	else
		local _sIndex = "ui_tqq_sg"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7046, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndSetCircle)
        end
	end
end

function WndSetCircle:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndSetCircle:downloadEffectCallback",taskId,extraData,failed)
    self:_setWaitingEffect()
end

--@brief 	设置待机动画
function WndSetCircle:_setDollSpine()
	for i = 1, 9 do 
		local spinePath = "activity/" .. self.m_tSpineName[i]
		local existSpine = CheckEffectFile(spinePath)
		if existSpine then 
			local spineOpen = GetElement(self.m_root, "spineOpen" .. i .. "_WndSetCircle", WZUISpine)
			if spineOpen then 
				spineOpen:setFileJson(spinePath .. ".json")
				spineOpen:setFileAtlas(spinePath .. ".atlas")
				spineOpen:play("wait_1", true)
			end
		else
			local _sIndex = self.m_tSpineName[i]
	        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
	        if downloadInfo then 
	        	DownloadManager:addDownloadTask(7046 + i, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadSpineCallback", WndSetCircle)
	        end
		end
	end
end

function WndSetCircle:downloadSpineCallback(taskId,extraData,failed)
    WZLog("WndSetCircle:downloadSpineCallback",taskId,extraData,failed)
    self:_setDollSpine()
end

--@brief 	关闭奖励界面，移除选中特效
function WndSetCircle:_cleanEffect()
	for i = 1, 3 do
		local conChooseSpine = GetElement(self.m_root, "conChooseSpine" .. i .. "_WndSetCircle", WZUIContainer)
		if conChooseSpine then 
			conChooseSpine:removeAllChildrenWithCleanup(true)
		end
	end
	--恢复待机动作
	for i = 1, #self.m_tOpenResult.rewardType do
		local spineOpen = GetElement(self.m_root, "spineOpen" .. self.m_tOpenResult.rewardType[i] .. "_WndSetCircle", WZUISpine)
		if spineOpen then 
			spineOpen:play("wait_1", true)
		end
	end
end
-------------------------------------私有方法模块End----------------------------------------


function WndSetCircle:_adaptLanguage_vn()
	local txtBtnTask1 = GetElement(self.m_root, "txtBtnTask1_WndSetCircle", WZUILabelTTF)
	txtBtnTask1:setScale(0.8)
	txtBtnTask1:setDimensions(GlobalMethod:CCSize(120,0))
	local txtBtnTask2 = GetElement(self.m_root, "txtBtnTask2_WndSetCircle", WZUILabelTTF)
	txtBtnTask2:setScale(0.8)
	txtBtnTask2:setDimensions(GlobalMethod:CCSize(120,0))
	local txtBtnTask3 = GetElement(self.m_root, "txtBtnTask3_WndSetCircle", WZUILabelTTF)
	txtBtnTask3:setScale(0.8)
	txtBtnTask3:setDimensions(GlobalMethod:CCSize(120,0))
	GetElement(self.m_root, "txtActivityTime_WndSetCircle", WZUILabelTTF):setScale(0.85)
	GetElement(self.m_root, "txtBtnOpenOne_WndSetCircle", WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root, "txtBtnOpenFive_WndSetCircle", WZUILabelTTF):setScale(0.8)
end