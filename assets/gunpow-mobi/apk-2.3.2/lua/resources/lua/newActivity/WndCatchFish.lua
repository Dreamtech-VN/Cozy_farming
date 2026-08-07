--WndCatchFish.lua
--@brief	WndCatchFish的UI模块
--@date		2023/09/27
--@author	XTX
--@note		捕鱼大王活动主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCatchFish:onEnter(element)
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
function WndCatchFish:onExit(element)
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
function WndCatchFish:onEnterTransitionDidFinish(element)
    WZLog("WndCatchFish:onEnterTransitionDidFinish")
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7094, 7094)
end

--@brief    关闭窗口
function WndCatchFish:onCloseClick(element)
	local eleType = type(element)
	if eleType ~= "number" then 
    	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    end

	SaveActivityPoleType("CATCHFISH", self.m_nCalabashType)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮回调
function WndCatchFish:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 	
    local otherInfo = {imgBg="ui/common/frame_tc_xiao_lan.png", imgClose = "ui/newvip/common_top_btn_guanbi_lan.png"}
 	WndFourStarRuleDesc:showInterface(LocalStrings.CATCHFISH_TEXT2, nil, otherInfo)
end

--@brief 	点击目标按钮回调
function WndCatchFish:onClickTask(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if SystemTime:getServerTime() >= self.m_nEndTime then 
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END) 
		self:onCloseClick(0)
		return 
	end 

	local nTag = element:getTag()
	if nTag == 1 then 
		CellNewYearTask:showInterface(41, self.m_nActivityId)
	elseif nTag == 2 then
		WndHouseInvite:showInterface(11, self.m_nActivityId)
	elseif nTag == 3 then 
		WndShopRank:showInterface(59, self.m_nActivityId) 
	end
end

--@brief 	点击大奖预览按钮回调
function WndCatchFish:onClickBigReward(element)
	-- body	
	if SystemTime:getServerTime() >= self.m_nEndTime then 
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END) 
		self:onCloseClick(0)
		return 
	end 
	local eleType = type(element)
	if eleType ~= "number" then 
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	end

	self.m_tGetTimes = {}
	self.m_tBigRewardList = {}
	self.m_bIsOpenReward = true 
	local tData = {pool = 0}
	local tData2 = {pool = 1}
	local tData3 = {pool = 2}
	
	local strJson = json.encode(tData)
	local strJson2 = json.encode(tData2)
	local strJson3 = json.encode(tData3)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson2)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson3)
end


--@brief 	点击开启按钮回调
function WndCatchFish:onClickFive(element) 
	if SystemTime:getServerTime() >= self.m_nEndTime then 
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END) 
		self:onCloseClick(0)
		return 
	end 
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	--背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
    if self.m_bOpenState then MsgBoxManager:showTipBox(LocalStrings.CATCHFISH_TEXT1[19]) return end 
    if self.m_nChooseReward == 0 then 
    	self:onClickBigReward(0)

		self.m_nChooseReward = 1
		SaveOperateTimes("CATCHFISHACTIVITYID", self.m_nActivityId)
    	return 
    end

    self.m_nAniType = 1
	local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local nTempTimes = math.floor(nArrowNum/self.m_tCostByType[self.m_nCalabashType + 1])
	local nTimes = nTag
	local freeCount = 0
	if self.m_nCalabashType == 0 then 
		if self.m_nPirate == 0 then 
			freeCount = self.m_nCount > 0 and 1 or 0 
		end
	end

	local useTimes = nTimes 
	if nTag == 5 then 
		self.m_nAniType = 2
		nTag = self.m_nMaxLotteryCount 
		nTimes = (nTempTimes + freeCount) >= self.m_nMaxLotteryCount and self.m_nMaxLotteryCount or nTempTimes > 0 and (nTempTimes + freeCount) or self.m_nMaxLotteryCount 
		local nLeftTimes = self.m_tContent.rareFishConfig[1] - self.m_nPirateProgress
		local nMileToTimes = self.m_nMaxLotteryCount
		if self.m_nPirate == 0 then 
			nMileToTimes = math.ceil(nLeftTimes/self.m_tCostByType[self.m_nCalabashType + 1])
		else
			nMileToTimes = math.ceil(self.m_nPirateHP/self.m_tContent.rareFishConfig[5] * self.m_tContent.rareFishConfig[4]/self.m_tCostByType[self.m_nCalabashType + 1])
		end
		useTimes = nTimes > nMileToTimes and nMileToTimes or nTimes
	end
	local nCostNum = useTimes * self.m_tCostByType[self.m_nCalabashType + 1]
	if nCostNum - freeCount > nArrowNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		MsgBoxManager:showConfirmBox(string.format(LocalStrings.WATERCOUNTRY_TEXT4, basicData.name), self, self.goToBuy)
		return 
	end

    local tData = {}
	tData.times = useTimes
	tData.pool = self.m_nCalabashType

	local stringData = json.encode(tData)

	self:setOpenState(true)
	self.m_bIsAppear = false 
	if self.m_nPirate == 1 then 
		self.m_bIsCatchShark = true 
	else
		self.m_bIsCatchShark = false 
	end
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 3, stringData)
end

--@brief 	前往小推车购买
function WndCatchFish:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

--@brief 	点击切换浪板类型
function WndCatchFish:onChooseTool(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local nTag = element:getTag()
	if self.m_bOpenState then 
		GetElement(self.m_root, "cbgTool_WndCatchFish", WZUICheckBoxGroup):setCheckIndex(self.m_nCalabashType)
		return 
	end 
	if self.m_nCalabashType == nTag then return end 

	GetElement(self.m_root, "spineFish" .. (self.m_nCalabashType + 1) .. "_WndCatchFish", WZUISpine):setVisible(false)

	self.m_nCalabashType = nTag
	GetElement(self.m_root, "spineFish" .. (self.m_nCalabashType + 1) .. "_WndCatchFish", WZUISpine):setVisible(true)
	self:_setFreeBtnText()
	self:_setGunPlayAni(1, true)
end

--@brief	点击物品弹出对应的tips
function WndCatchFish:onItemClick(tCell,tag,tData)
    if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData,false)
end

--@brief 	点击等级奖励按钮回调、
function WndCatchFish:onClickLvReward(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	GetElement(self.m_root, "conLvReward_WndCatchFish", WZUIContainer):setVisible(true)
	self:_createLvRewardList()
end

--@brief 	关闭捕鼠奖励界面
function WndCatchFish:onCloseTip(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	GetElement(self.m_root, "conLvReward_WndCatchFish", WZUIContainer):setVisible(false)
	self:showRedDot()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndCatchFish:_update()
	-- body
	self:_setFreeBtnText()
	self:showRedDot()
	self:_initActivityTime()
    self:_updateLightNum()
end

--@brief 	初始化静态文本
function WndCatchFish:_initStaticText()
	self.m_nCalabashType = GetActivityPoleType("CATCHFISH")
	if self.m_nCalabashType ~= 0 then 
		GetElement(self.m_root, "cbgTool_WndCatchFish", WZUICheckBoxGroup):setCheckIndex(self.m_nCalabashType)
	end
	GetElement(self.m_root, "spineFish" .. (self.m_nCalabashType + 1) .. "_WndCatchFish", WZUISpine):setVisible(true)

	GetElement(self.m_root, "txtBtnTask1_WndCatchFish", WZUILabelTTF):setText(LocalStrings.CATCHFISH_TEXT1[2])
	GetElement(self.m_root, "txtBtnTask2_WndCatchFish", WZUILabelTTF):setText(LocalStrings.CATCHFISH_TEXT1[8])
	GetElement(self.m_root, "txtBtnTask3_WndCatchFish", WZUILabelTTF):setText(LocalStrings.CATCHFISH_TEXT1[3])
	GetElement(self.m_root, "txtBigReward_WndCatchFish", WZUILabelTTF):setText(LocalStrings.CATCHFISH_TEXT1[22])
	GetElement(self.m_root, "txtLvRewardT_WndCatchFish", WZUILabelTTF):setText(LocalStrings.CATCHFISH_TEXT1[15])
	GetElement(self.m_root, "txtActivityWord_WndCatchFish", WZUILabelTTF):setText(LocalStrings.ACTIVE_TIME .. ":")
	GetElement(self.m_root, "txtFishName_WndCatchFish", WZUILabelTTF):setText(LocalStrings.CATCHFISH_TEXT1[24])
	GetElement(self.m_root, "txtPirate_WndCatchFish", WZUILabelTTF):setText(LocalStrings.CATCHFISH_TEXT1[25])

	self:_setBallAni()
end

--@brief 	红点
function WndCatchFish:showRedDot()
	-- body
	if self.m_root == nil then return end 

	local imgTaskRedDot = GetElement(self.m_root, "imgTaskRedDot_WndCatchFish", WZUIImage)
	local imgExpReddot = GetElement(self.m_root, "imgExpReddot_WndCatchFish", WZUIImage)
	local imgLibraryRedDot = GetElement(self.m_root, "imgLibraryRedDot_WndCatchFish", WZUIImage)

	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[117094] or GlobalGame.g_tRedPointTypeList[127094]) then 
		imgTaskRedDot:setVisible(true)
	else
		imgTaskRedDot:setVisible(false)
	end

	local bHaveRedDot = false 
	if self.m_tLvRewardList then 
		for i = 1, #self.m_tLvRewardList do
			if self.m_tLvRewardList[i].status == 1 then 
				bHaveRedDot = true 
				break 
			end
		end
	end

	imgExpReddot:setVisible(bHaveRedDot)
	--图鉴红点
	bHaveRedDot = false 
	if self.m_tLibraryData then 
		for i = 1, #self.m_tLibraryData do
			if self.m_tLibraryData[i].status == 1 then 
				bHaveRedDot = true 
				break 
			end
		end
	end

	imgLibraryRedDot:setVisible(bHaveRedDot)
end

--@brief 	更新异火的数量
function WndCatchFish:_updateLightNum()
	-- body
	local ftxtLightNum = GetElement(self.m_root, "ftxtLightNum_WndCatchFish", WZUIFreeTextBox)
	local sFormat = [[<I Z="0.45" P="1">%s</I><T C="255,255,255" S="18" P="1" SC="163,74,20" SS="4" SE="1">%d</T>]]
	if ftxtLightNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
		ftxtLightNum:setShowText(string.format(sFormat, basicData.icon, nLightNum))
	end
end

--@brief 	初始化活动时间
function WndCatchFish:_initActivityTime()
	-- body
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndCatchFish", WZUILabelTTF)
    if txtActivityTime then 
    	txtActivityTime:setText(needDay_str)
    end
end

--@brief 	显示开启动画
function WndCatchFish:showOpenAction()
	-- body
	local spineOpen = GetElement(self.m_root, "spineOpen_WndCatchFish", WZUISpine)
	local spineWait3 = GetElement(self.m_root, "spineWait3_WndCatchFish", WZUISpine)
	local spinePath = "activity/hp_pic_xiaoyu"
	local existSpine = CheckEffectFile(spinePath)
	if spineOpen then 
		if existSpine then 
			self:_setBowlingPlayAni(2, false)
			spineOpen:enableSchedule("afterAni", 0.8)
			self:_setNetPlayAni(self.m_nAniType, false)
			if self.m_nPirate == 1 then 
				local spinePirate = GetElement(self.m_root, "spinePirate_WndCatchFish", WZUISpine)
				spinePirate:enableSchedule("afterAniWhale", 0.8)
				self:_setWhalePlayAni(2, false)
			end
			spineWait3:enableSchedule("waitHide", 0.08)
		else
			self:showShootReward()
			self:setOpenState(false)
		end
	end
end

--@brief 	显示开启奖励
function WndCatchFish:showShootReward()
	-- body
	local strContent = ""
	local nIndex = 0 
	if self.m_tOpenResult.otherRewards and #self.m_tOpenResult.otherRewards > 0 then 
		for i = 1, #self.m_tOpenResult.otherRewards do
			if i == 1 then 
				strContent = strContent .. LocalStrings.CRAZY_DOUBLING_TEXT8 .. " "
			else
				strContent = strContent .. ", "
			end
			local basicData = GDatatab_item["id_" .. self.m_tOpenResult.otherRewards[i][1]]
			strContent = strContent .. basicData.name .. "*" .. self.m_tOpenResult.otherRewards[i][2]
		end
		nIndex = nIndex + 1
	end
	if self.m_tOpenResult.addExp and self.m_tOpenResult.addExp > 0 then 
		if nIndex > 0 then 
			strContent = strContent .. " "
		end
		strContent = strContent .. LocalStrings.CATCHFISH_TEXT1[18] .. "+" .. self.m_tOpenResult.addExp
	end

	if strContent ~= "" then 
		MsgBoxManager:showTipBox(strContent, nil, nil, nil, nil, nil, nil, nil, nil, GlobalMethod:ccp(0.5, 0.77))
	end

	self:_afterCloseReward()
	--如果鲨鱼出现和被捕捉，延迟鲨鱼的出现和消失
	if self.m_bIsAppear then 
		self.m_bIsAppear = false
		self:_showPirate()
	end
end

--@brief 	iphoneX适配
function WndCatchFish:_adaptIphoneX()
	if IsIphoneX() then
		GetElement(self.m_root, "btnShop_WndCatchFish", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.08,0.42))
		GetElement(self.m_root, "conLeftMenu_WndCatchFish", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.97,0))
	end
end

--@brief 	设置免费丢
function WndCatchFish:_setFreeBtnText()
	local txtBtnOpenOne = GetElement(self.m_root, "txtBtnOpenOne_WndCatchFish", WZUILabelTTF)
	local txtBtnOpenFive = GetElement(self.m_root, "txtBtnOpenFive_WndCatchFish", WZUILabelTTF)

	local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local freeTimes = 0 
	local nTempTimes = math.floor(nLightNum/self.m_tCostByType[self.m_nCalabashType + 1])
	local nTimes = 0
	local strTemp = LocalStrings.CATCHFISH_TEXT1[7]
	local nLeftTimes = self.m_tContent.rareFishConfig[1] - self.m_nPirateProgress
	local nMileToTimes = self.m_nMaxLotteryCount
	if self.m_nPirate == 0 then 
		if self.m_nCalabashType == 0 then 
			if self.m_nCount > 0 then 
				freeTimes = 1
				txtBtnOpenOne:setText(LocalStrings.CATCHFISH_TEXT1[6])
			else 
				txtBtnOpenOne:setText(string.format(strTemp, 1))
			end
		else
			txtBtnOpenOne:setText(string.format(strTemp, 1))
		end
		nMileToTimes = math.ceil(nLeftTimes/self.m_tCostByType[self.m_nCalabashType + 1])
	else
		nMileToTimes = math.ceil(self.m_nPirateHP/self.m_tContent.rareFishConfig[5] * self.m_tContent.rareFishConfig[4]/self.m_tCostByType[self.m_nCalabashType + 1])
	end
	nTimes = (nTempTimes + freeTimes) >= self.m_nMaxLotteryCount and self.m_nMaxLotteryCount or nTempTimes > 0 and (nTempTimes + freeTimes) or self.m_nMaxLotteryCount 
	if nMileToTimes < nTimes then 
		nTimes = nMileToTimes 
	end

	txtBtnOpenFive:setText(string.format(strTemp, nTimes))

	GetElement(self.m_root, "txtPirateAtt_WndCatchFish", WZUILabelTTF):setText(string.format(LocalStrings.CATCHFISH_TEXT1[26], nLeftTimes))
end

--@brief 	设置待机特效
function WndCatchFish:_setBallAni()
	local spinePath = "activity/hp_pic_xiaoyu"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		local spineOpen = GetElement(self.m_root, "spineOpen_WndCatchFish", WZUISpine)
		local spinePirate = GetElement(self.m_root, "spinePirate_WndCatchFish", WZUISpine)
		local spineFish1 = GetElement(self.m_root, "spineFish1_WndCatchFish", WZUISpine)
		local spineFish2 = GetElement(self.m_root, "spineFish2_WndCatchFish", WZUISpine)
		local spineNet = GetElement(self.m_root, "spineNet_WndCatchFish", WZUISpine)
		local spineWait3 = GetElement(self.m_root, "spineWait3_WndCatchFish", WZUISpine)
		if spineOpen then 
			spineOpen:setFileJson(spinePath .. ".json")
			spineOpen:setFileAtlas(spinePath .. ".atlas")
		end
		if spineWait3 then 
			spineWait3:setFileJson(spinePath .. ".json")
			spineWait3:setFileAtlas(spinePath .. ".atlas")
			self:_setGunPlayAni(1, true)
		end
		if spineNet then 
			spineNet:setFileJson(spinePath .. ".json")
			spineNet:setFileAtlas(spinePath .. ".atlas")
		end
		if spinePirate then 
			spinePirate:setFileJson(spinePath .. ".json")
			spinePirate:setFileAtlas(spinePath .. ".atlas")
			self:_setWhalePlayAni(1, true)
		end
		if spineFish1 then 
			spineFish1:setFileJson(spinePath .. ".json")
			spineFish1:setFileAtlas(spinePath .. ".atlas")
			spineFish1:play("wait1", true)
		end
		if spineFish2 then 
			spineFish2:setFileJson(spinePath .. ".json")
			spineFish2:setFileAtlas(spinePath .. ".atlas")
			spineFish2:play("wait2", true)
		end
	else
		local _sIndex = "hp_pic_xiaoyu"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7094, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndCatchFish)
        end
	end

	spinePath = "activity/hp_pic_beijing"
	existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		local spineWait = GetElement(self.m_root, "spineWait_WndCatchFish", WZUISpine)
		if spineWait then 
			spineWait:setFileJson(spinePath .. ".json")
			spineWait:setFileAtlas(spinePath .. ".atlas")
			spineWait:play("wait", true)
		end
	end
	spinePath = "activity/hp_pic_qianjing"
	existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		local spineWait2 = GetElement(self.m_root, "spineWait2_WndCatchFish", WZUISpine)
		if spineWait2 then 
			spineWait2:setFileJson(spinePath .. ".json")
			spineWait2:setFileAtlas(spinePath .. ".atlas")
			spineWait2:play("wait", true)
		end
	end
end

function WndCatchFish:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndCatchFish:downloadEffectCallback",taskId,extraData,failed)
    self:_setBallAni()
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndCatchFish:_setBowlingPlayAni(aniIndex, bLoop)
	local spineOpen = GetElement(self.m_root, "spineOpen_WndCatchFish", WZUISpine)
	aniIndex = aniIndex or 1
	WZLog("WndCatchFish:_setBowlingPlayAni", aniIndex, bLoop)

	if spineOpen then
		spineOpen:setVisible(true) 
		spineOpen:play(self.m_tBallAniName[self.m_nCalabashType + 1][aniIndex], bLoop ~= nil and bLoop or true)
	end
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndCatchFish:_setGunPlayAni(aniIndex, bLoop)
	local spineWait3 = GetElement(self.m_root, "spineWait3_WndCatchFish", WZUISpine)
	aniIndex = aniIndex or 1
	WZLog("WndCatchFish:_setGunPlayAni", aniIndex, bLoop)

	if spineWait3 then 
		spineWait3:setVisible(true)
		spineWait3:play(self.m_tBallAniName[self.m_nCalabashType + 1][aniIndex], bLoop ~= nil and bLoop or true)
	end
end

--@brief 	设置播放的鲸鱼的动画
function WndCatchFish:_setWhalePlayAni(aniIndex, bLoop)
	local spinePirate = GetElement(self.m_root, "spinePirate_WndCatchFish", WZUISpine)
	aniIndex = aniIndex or 1
	WZLog("WndCatchFish:_setWhalePlayAni", aniIndex, bLoop)

	if spinePirate then 
		spinePirate:play(self.m_tBallAniName2[aniIndex], bLoop ~= nil and bLoop or true)
	end
end

--@brief 	设置播放的渔网的动画
function WndCatchFish:_setNetPlayAni(aniIndex, bLoop)
	local spineNet = GetElement(self.m_root, "spineNet_WndCatchFish", WZUISpine)
	aniIndex = aniIndex or 1
	WZLog("WndCatchFish:_setNetPlayAni", aniIndex, bLoop)

	if spineNet then 
		spineNet:setVisible(true)
		spineNet:play(self.m_tBallAniName3[aniIndex], bLoop ~= nil and bLoop or true)
	end
end

--@brief 	鱼移出屏幕后，删除动画
function WndCatchFish:afterAni(element)
	local spineOpen = GetElement(self.m_root, "spineOpen_WndCatchFish", WZUISpine)
	local spineWait3 = GetElement(self.m_root, "spineWait3_WndCatchFish", WZUISpine)
	spineOpen:disableSchedule()
	local spineNet = GetElement(self.m_root, "spineNet_WndCatchFish", WZUISpine)
	spineNet:setVisible(false)
	spineWait3:setVisible(true)
	spineOpen:setVisible(false)

	self:showShootReward()
	self:setOpenState(false)
end

--@brief 	播放露营动画后
function WndCatchFish:waitHide(element)
	local spineWait3 = GetElement(self.m_root, "spineWait3_WndCatchFish", WZUISpine)
	spineWait3:disableSchedule()
	spineWait3:setVisible(false)
end

--@brief 	鱼移出屏幕后，删除动画
function WndCatchFish:afterAniWhale(element)
	local spinePirate = GetElement(self.m_root, "spinePirate_WndCatchFish", WZUISpine)
	spinePirate:disableSchedule()
	self:_setWhalePlayAni(1, true)

	self:setOpenState(false)
end

--@brief 	显示等级、经验
function WndCatchFish:_showLvAndExp()
	local txtLevel = GetElement(self.m_root, "txtLevel_WndCatchFish", WZUILabelTTF)
	local txtLvTitle = GetElement(self.m_root, "txtLvTitle_WndCatchFish", WZUILabelTTF)
	local txtExp = GetElement(self.m_root, "txtExp_WndCatchFish", WZUILabelTTF)
	local prgExp = GetElement(self.m_root, "prgExp_WndCatchFish", WZUIProgress)

	local tCurInfo, tNextInfo, nMaxLv = self:getCurLvInfo()
	local strLvTitle = LocalStrings.CATCHFISH_TEXT1[17][1]
	local nCurLevel = 0 
	if tCurInfo then 
		nCurLevel = tCurInfo.lv
		strLvTitle = tCurInfo.name 
	end
	txtLevel:setText(LocalStrings.LV .. nCurLevel)
	txtLvTitle:setText(strLvTitle)
	if tCurInfo and tCurInfo.lv >= nMaxLv then 
		txtExp:setText("Max")
	else
		txtExp:setText(self.m_nCurExp .. "/" .. tNextInfo.exp)
	end

	local nPercentage = math.floor(100 * self.m_nCurExp/tNextInfo.exp)
	if nPercentage > 100 then 
		nPercentage = 100
	end
	prgExp:setPercentage(nPercentage)
end

--@brief 	创建捕鼠奖励
function WndCatchFish:_createLvRewardList()
	local tbLvRewardList = GetElement(self.m_root, "tbLvRewardList_WndCatchFish", WZUITableContainer)
	tbLvRewardList:cleanTable()

	for i = 1, #self.m_tLvRewardList do
		local element, tNewObj = CellLvRewardItem:createElement()
		if element and tNewObj then
			element:setTag(i - 1)
			tNewObj:setData(self.m_tLvRewardList[i], 6)

			tbLvRewardList:setCellElement(element)
		end
	end
end

--@brief	显示鲨鱼血量
function WndCatchFish:_showPirate()
	local conPirate = GetElement(self.m_root, "conPirate_WndCatchFish", WZUIContainer)
	if self.m_nPirate == 1 then 
		conPirate:setVisible(true)
		GetElement(self.m_root, "spineFish1_WndCatchFish", WZUISpine):setVisible(false)
		GetElement(self.m_root, "spineFish2_WndCatchFish", WZUISpine):setVisible(false)
		local prgPirateHP = GetElement(self.m_root, "prgPirateHP_WndCatchFish", WZUIProgress)
		local txtPirateHP = GetElement(self.m_root, "txtPirateHP_WndCatchFish", WZUILabelTTF)
		local nMaxHP = self.m_tContent.rareFishConfig[2]
		txtPirateHP:setText(self.m_nPirateHP .. "/" .. nMaxHP)
		local nPercentage = math.floor(self.m_nPirateHP/nMaxHP * 100)
		prgPirateHP:setPercentage(nPercentage)
	else
		conPirate:setVisible(false)
		GetElement(self.m_root, "spineFish" .. (self.m_nCalabashType + 1) .. "_WndCatchFish", WZUISpine):setVisible(true)
	end
end

-------------------------------------私有方法模块End----------------------------------------

--------------------------------------语言适配Begin-----------------------------------------

function WndCatchFish:_adaptLanguage_vn(  )
	GetElement(self.m_root, "btnBigReward_WndCatchFish", WZUIButton):setRelativePosition(GlobalMethod:ccp(1.15,0.5))
	GetElement(self.m_root, "txtBtnTask1_WndCatchFish", WZUILabelTTF):setScale(0.75)
	GetElement(self.m_root, "txtBtnTask2_WndCatchFish", WZUILabelTTF):setScale(0.75)
	GetElement(self.m_root, "txtBtnTask3_WndCatchFish", WZUILabelTTF):setScale(0.75)
	GetElement(self.m_root, "txtLevel_WndCatchFish", WZUILabelTTF):setScale(0.65)
	GetElement(self.m_root, "txtBtnOpenOne_WndCatchFish", WZUILabelTTF):setScale(0.75)
	GetElement(self.m_root, "txtBtnOpenFive_WndCatchFish", WZUILabelTTF):setScale(0.75)
end

---------------------------------------语言适配End------------------------------------------
