--WndAlchemy.lua
--@brief	WndAlchemy的UI模块
--@date		2022/02/08
--@author	XTX
--@note		丹道修真活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndAlchemy:onEnter(element)
	self.m_root = element

	g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
	ProtocolProcessorFestivalActivity:regAll6()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self) 

	self:_initStaticText()
	self:_adaptIphoneX()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndAlchemy:onExit(element)
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
function WndAlchemy:onEnterTransitionDidFinish(element)
    WZLog("WndAlchemy:onEnterTransitionDidFinish")
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7036, 7036)
end

--@brief    关闭窗口
function WndAlchemy:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    --如果是自动弹出的活动界面
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮回调
function WndAlchemy:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 
    WndSingleMapDesc:showInterface1(LocalStrings.ALCHEMY_TEXT2) 
end

--@brief 	点击目标按钮回调
function WndAlchemy:onClickTask(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if nTag == 1 then 
		CellNewYearTask:showInterface(8, self.m_nActivityId)
	elseif nTag == 2 then
		WndAlchemySmelt:showInterface(self.m_nActivityId, self.m_tContent.make5PEDCost, self.m_tContent.make9CSDCost)
	elseif nTag == 3 then 
		WndShopRank:showInterface(18, self.m_nActivityId) 
	end
end

--@brief 	点击大奖预览按钮回调
function WndAlchemy:onClickBigReward(element)
	-- body
	local eleType = type(element)
	local nTag = 0
	if eleType ~= "number" then 
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
		nTag = element:getTag()
	else
		nTag = element
	end
	WZLog("WndAlchemy:onClickBigReward nTag:", nTag)

	local otherData = {}
	otherData.winType = 1
	
	if self.m_tBigRewardList ~= nil then
		self.m_bIsOpenReward = true
		self.m_nRecvRewardsPool = {}
		--pool	: int 大奖类型 2:三品破厄丹 3：五品长生丹 4：五品破厄丹 5:九品长生丹,
		--丹道修真doType = 3获取大奖信息
		if nTag == 2 then
			--WndAlchemySmelt:onClickSort点击跳转来的 显示聚炼的五品破厄和九品长生
			local tData3 = {pool = 4}
			local strJson3 = json.encode(tData3)
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 3, strJson3)
			local tData5 = {pool = 5}
			local strJson5 = json.encode(tData5)
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 3, strJson5)
		else
			local tData2 = {pool = 2}
			local strJson2 = json.encode(tData2)
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 3, strJson2)			
			local tData4 = {pool = 3}
			local strJson4 = json.encode(tData4)
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 3, strJson4)
		end
	end
end

--@brief 	点击开启按钮回调
function WndAlchemy:onClickFive(element)
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
		SaveOperateTimes("ALCHEMYACTIVITYID", self.m_nActivityId)
    	return 
    end

	local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local nArrowNum2 = 0--CacheCenter:getPlayerItemCountById(self.m_nCoinId2)
	local nArrowNum = nArrowNum + nArrowNum2
	if nTag > nArrowNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		MsgBoxManager:showConfirmBox(string.format(LocalStrings.WATERCOUNTRY_TEXT4, basicData.name), self, self.goToBuy)
		return 
	end
    local tData = {}
	tData.times = nTag

	local stringData = json.encode(tData)

	self:setOpenState(true)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 1, stringData)
end

--@brief 	前往小推车购买
function WndAlchemy:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndAlchemy:_update()
	-- body
	self:showRedDot()
	self:_initActivityTime()
    self:_updateLightNum()
end

--@brief 	初始化静态文本
function WndAlchemy:_initStaticText()
	GetElement(self.m_root, "txtBtnOpenOne_WndAlchemy", WZUILabelTTF):setText(string.format(LocalStrings.ALCHEMY_TEXT1[7], 1))
	GetElement(self.m_root, "txtBtnOpenFive_WndAlchemy", WZUILabelTTF):setText(string.format(LocalStrings.ALCHEMY_TEXT1[7], 5))
	GetElement(self.m_root, "txtBigReward_WndAlchemy", WZUILabelTTF):setText(LocalStrings.ALCHEMY_TEXT1[5])
	GetElement(self.m_root, "txtBtnTask1_WndAlchemy", WZUILabelTTF):setText(LocalStrings.ALCHEMY_TEXT1[2])
	GetElement(self.m_root, "txtBtnTask2_WndAlchemy", WZUILabelTTF):setText(LocalStrings.ALCHEMY_TEXT1[3])
	GetElement(self.m_root, "txtBtnTask3_WndAlchemy", WZUILabelTTF):setText(LocalStrings.ALCHEMY_TEXT1[4])

	self:_setBallAni()
end

--@brief 	红点
function WndAlchemy:showRedDot()
	-- body
	if self.m_root == nil then return end 

	local imgTaskRedDot = GetElement(self.m_root, "imgTaskRedDot_WndAlchemy", WZUIImage)
	local imgCardRedDot = GetElement(self.m_root, "imgCardRedDot_WndAlchemy", WZUIImage)

	if GlobalGame.g_tRedPointTypeList[117036] or GlobalGame.g_tRedPointTypeList[127036] then 
		imgTaskRedDot:setVisible(true)
	else
		imgTaskRedDot:setVisible(false)
	end

	local num1 = CacheCenter:getPlayerItemCountById(160203)
	local num2 = CacheCenter:getPlayerItemCountById(160205)
	if self.m_tContent then 
		if num1 >= self.m_tContent.make5PEDCost or num2 >= self.m_tContent.make9CSDCost then 
			GlobalGame.g_tRedPointTypeList[27036] = true 
		else
			GlobalGame.g_tRedPointTypeList[27036] = false 
		end
	end
	if GlobalGame.g_tRedPointTypeList[27036] then 
		imgCardRedDot:setVisible(true)
	else
		imgCardRedDot:setVisible(false)
	end
end

--@brief 	更新异火的数量
function WndAlchemy:_updateLightNum()
	-- body
	local ftxtLightNum = GetElement(self.m_root, "ftxtLightNum_WndAlchemy", WZUIFreeTextBox)
	local sFormat = [[<I Z="0.5" P="1">%s</I><T C="255,255,255" S="20" P="1" SC="132,66,29" SS="4" SE="1">%d</T>]]
	if ftxtLightNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
		ftxtLightNum:setShowText(string.format(sFormat, basicData.icon, nLightNum))
	end
end

--@brief 	初始化活动时间
function WndAlchemy:_initActivityTime()
	-- body
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndAlchemy", WZUILabelTTF)
    if txtActivityTime then 
    	txtActivityTime:setText(LocalStrings.ACTIVITY_TIME_KEY .. ":" .. needDay_str)
    end
end

--@brief 	显示开启动画
function WndAlchemy:showOpenAction()
	-- body
	local spineOpen = GetElement(self.m_root, "spineOpen_WndAlchemy", WZUISpine)
	spineOpen:setVisible(true)
	if spineOpen then 
		local spinePath = "activity/ui_liandan"
		local existSpine = CheckEffectFile(spinePath)
		if existSpine then 
			spineOpen:setFileAtlas(spinePath .. ".atlas")
			spineOpen:setFileJson(spinePath .. ".json")
			spineOpen:play("wait", false)
		else
			local _sIndex = "ui_liandan"
	        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
	        if downloadInfo then 
	        	DownloadManager:addDownloadTask(14209,downloadInfo.url,downloadInfo.md5,_sIndex,"DownloadResourceCallback", _G)
	        end
		end
		spineOpen:enableSchedule("showShootReward", 0.5)
	end
end

--@brief 	显示开启奖励
function WndAlchemy:showShootReward()
	-- body
	local spineOpen = GetElement(self.m_root, "spineOpen_WndAlchemy", WZUISpine)
	spineOpen:disableSchedule()
	spineOpen:setVisible(false)

	self:setOpenState(false)

	local strContent = LocalStrings.ALCHEMY_TEXT1[26]
	for i = 1, #self.m_tOpenResult.alchemyReward do
		local basicData = GDatatab_item["id_" .. self.m_tOpenResult.alchemyReward[i][1]]
		local strTemp = basicData.name .. "*" .. self.m_tOpenResult.alchemyReward[i][2]
		if i > 1 then 
			strContent = strContent .. ","
		end
		strContent = strContent .. strTemp
	end
	MsgBoxManager:showTipBox(strContent, nil, nil, nil, nil, nil, nil, nil, nil, {x=0.5, y=0.78})
	self:_afterCloseReward()
end

--@brief 	iphoneX适配
function WndAlchemy:_adaptIphoneX()
	if IsIphoneX() then
		GetElement(self.m_root, "conLeftMenu_WndAlchemy", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.07,0.23))
	end
end

--@brief 	设置待机特效
function WndAlchemy:_setBallAni()
	local spinePath = "activity/ui_daiji"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		local spineWait = GetElement(self.m_root, "spineWait_WndAlchemy", WZUISpine)
		if spineWait then 
			spineWait:setFileJson(spinePath .. ".json")
			spineWait:setFileAtlas(spinePath .. ".atlas")
			spineWait:play("wait", true)
		end
	else
		local _sIndex = "ui_daiji"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7036, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndAlchemy)
        end
	end
end

function WndAlchemy:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndAlchemy:downloadEffectCallback",taskId,extraData,failed)
    self:_setBallAni()
end
-------------------------------------私有方法模块End----------------------------------------



-------------------------------------语言适配begin----------------------------------------
function WndAlchemy:_adaptLanguage_vn()
	GetElement(self.m_root, "txtBtnTask1_WndAlchemy", WZUILabelTTF):setFontSize(16)
	GetElement(self.m_root, "txtBtnTask2_WndAlchemy", WZUILabelTTF):setFontSize(12)
	GetElement(self.m_root, "txtBtnTask3_WndAlchemy", WZUILabelTTF):setFontSize(16)

	GetElement(self.m_root, "txtActivityTime_WndAlchemy", WZUILabelTTF):setFontSize(16)

	GetElement(self.m_root, "txtBtnOpenOne_WndAlchemy", WZUILabelTTF):setFontSize(20)
	GetElement(self.m_root, "txtBtnOpenFive_WndAlchemy", WZUILabelTTF):setFontSize(20)
end

-------------------------------------语言适配End----------------------------------------