--WndBilliardBall.lua
--@brief	WndBilliardBall的UI模块
--@date		2022/08/16
--@author	XTX
--@note		台无止境活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndBilliardBall:onEnter(element)
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
function WndBilliardBall:onExit(element)
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
function WndBilliardBall:onEnterTransitionDidFinish(element)
    WZLog("WndBilliardBall:onEnterTransitionDidFinish")
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7055, 7055)
end

--@brief    关闭窗口
function WndBilliardBall:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    self:savePoleType()
    --如果是自动弹出的活动界面
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮回调
function WndBilliardBall:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 
    WndSingleMapDesc:showInterface1(LocalStrings.BILLIARDBALL_TEXT2) 
end

--@brief 	点击目标按钮回调
function WndBilliardBall:onClickTask(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if nTag == 1 then 
		CellNewYearTask:showInterface(16, self.m_nActivityId)
	elseif nTag == 2 then
		WndDollMachineShop:showInterface(6, self.m_nActivityId)
	elseif nTag == 3 then 
		WndShopRank:showInterface(30, self.m_nActivityId) 
	end
end

--@brief 	点击大奖预览按钮回调
function WndBilliardBall:onClickBigReward(element)
	-- body
	local eleType = type(element)
	if eleType ~= "number" then 
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	end

	if self.m_tBigRewardList ~= nil then
		self.m_bIsOpenReward = true 
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, "")
	end
	-- WndJoinReward:showInterface("", self.m_tBigRewardList[1], self.m_tBigRewardList[2], LocalStrings.TREASURE_TEXT7, nil, 2)
end

--@brief 	点击开启按钮回调
function WndBilliardBall:onClickFive(element)
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
		SaveOperateTimes("BILLIARBALLACTIVITYID", self.m_nActivityId)
    	return 
    end

	local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local freeCount = 0
	local nTempTimes = nArrowNum
	if self.m_nPoleType == 0 then
		freeCount = self.m_nCount > 0 and 1 or 0 
	else
		freeCount = 0
	end
	nTempTimes = math.floor(nArrowNum/self.m_tGlovesCost[self.m_nPoleType + 1])
	local nTimes = nTag
	if nTag == 5 then 
		nTag = self.m_nMaxLotteryCount 
		nTimes = (nTempTimes + freeCount) >= self.m_nMaxLotteryCount and self.m_nMaxLotteryCount or nTempTimes > 0 and (nTempTimes + freeCount) or self.m_nMaxLotteryCount 
	end
	local nCostNum = nTimes * self.m_tGlovesCost[self.m_nPoleType + 1]
	if nCostNum - freeCount > nArrowNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		MsgBoxManager:showConfirmBox(string.format(LocalStrings.WATERCOUNTRY_TEXT4, basicData.name), self, self.goToBuy)
		return 
	end

    local tData = {}
	tData.times = nTag
	tData.grade = self.m_nPoleType

	local stringData = json.encode(tData)

	self:setOpenState(true)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 3, stringData)
end

--@brief 	前往小推车购买
function WndBilliardBall:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

--@brief 	点击切换场地等级回调
function WndBilliardBall:onChooseTool(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local nTag = element:getTag()
	self.m_nPoleType = nTag
	self:_setFreeBtnText()
	if not self.m_bOpenState then 
		self:_setBowlingPlayAni(1, true)
	end
end

--@brief 	点击等级奖励按钮回调、
function WndBilliardBall:onClickLvReward(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	GetElement(self.m_root, "conLvReward_WndBilliardBall", WZUIContainer):setVisible(true)
	self:_createLvRewardList()
end

--@brief 	关闭捕鼠奖励界面
function WndBilliardBall:onCloseTip(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	GetElement(self.m_root, "conLvReward_WndBilliardBall", WZUIContainer):setVisible(false)
	local bIsReddot = false 
	for i = 1, #self.m_tLvRewardList do
		if self.m_tLvRewardList[i].status == 1 then 
			bIsReddot = true 
			break 
		end
	end
	GlobalGame.g_tRedPointTypeList[47037] = bIsReddot 
	self:showRedDot()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndBilliardBall:_update()
	-- body
	self:_setFreeBtnText()
	self:showRedDot()
	self:_initActivityTime()
    self:_updateLightNum()
end

--@brief 	初始化静态文本
function WndBilliardBall:_initStaticText()
	self:getPoleType()
	GetElement(self.m_root, "txtBtnTask1_WndBilliardBall", WZUILabelTTF):setText(LocalStrings.BILLIARDBALL_TEXT1[2])
	GetElement(self.m_root, "txtBtnTask3_WndBilliardBall", WZUILabelTTF):setText(LocalStrings.BILLIARDBALL_TEXT1[3])
	GetElement(self.m_root, "txtBtnTask2_WndBilliardBall", WZUILabelTTF):setText(LocalStrings.BILLIARDBALL_TEXT1[10])
	GetElement(self.m_root, "txtBigReward_WndBilliardBall", WZUILabelTTF):setText(LocalStrings.TREASURE_TEXT7)
	GetElement(self.m_root, "txtLvRewardT_WndBilliardBall", WZUILabelTTF):setText(LocalStrings.BILLIARDBALL_TEXT1[11])

	self:_setBallAni()
end

--@brief 	红点
function WndBilliardBall:showRedDot()
	-- body
	if self.m_root == nil then return end 

	local imgTaskRedDot = GetElement(self.m_root, "imgTaskRedDot_WndBilliardBall", WZUIImage)
	local imgExpReddot = GetElement(self.m_root, "imgExpReddot_WndBilliardBall", WZUIImage)

	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[117055] or GlobalGame.g_tRedPointTypeList[127055] or GlobalGame.g_tRedPointTypeList[137055]) then 
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
end

--@brief 	更新异火的数量
function WndBilliardBall:_updateLightNum()
	-- body
	local ftxtLightNum = GetElement(self.m_root, "ftxtLightNum_WndBilliardBall", WZUIFreeTextBox)
	local sFormat = [[<I Z="0.5" P="1">%s</I><T C="255,255,255" S="20" P="1" SC="132,66,29" SS="4" SE="1">%d</T>]]
	CCNodePropertySetter:setValue(ftxtLightNum, "skewY", -6)
	if ftxtLightNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
		ftxtLightNum:setShowText(string.format(sFormat, basicData.icon, nLightNum))
	end
end

--@brief 	初始化活动时间
function WndBilliardBall:_initActivityTime()
	-- body
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndBilliardBall", WZUILabelTTF)
    CCNodePropertySetter:setValue(txtActivityTime, "skewY", -10)
    if txtActivityTime then 
    	txtActivityTime:setText(LocalStrings.ACTIVITY_TIME_KEY .. ":" .. needDay_str)
    end
end

--@brief 	显示开启动画
function WndBilliardBall:showOpenAction()
	-- body
	--创建选中特效
	local spinePath = "activity/hd_pic_qiugandz"
	local existSpine = CheckEffectFile(spinePath)
	if not existSpine then 
		local _sIndex = "hd_pic_qiugandz"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7055, downloadInfo.url, downloadInfo.md5, _sIndex, "DownloadResourceCallback", _G)
        end
	end

	local spineOpen = GetElement(self.m_root, "spineOpen_WndBilliardBall", WZUISpine)
	if spineOpen then 
		if existSpine then 
			self:_setBowlingPlayAni(2, false)
			spineOpen:enableSchedule("showShootReward", 1.2)
		else
			self:showShootReward()
		end
	end
end

--@brief 	显示开启奖励
function WndBilliardBall:showShootReward()
	-- body
	local spineOpen = GetElement(self.m_root, "spineOpen_WndBilliardBall", WZUISpine)
	spineOpen:disableSchedule()
	self:_setBowlingPlayAni(1, true)

	local strGoods = ""
	--获得的勋章
	if self.m_tOpenResult.medalNum > 0 then 
		if strGoods ~= "" then 
			strGoods = strGoods .. ", "
		end
		local basicData = GDatatab_item["id_171420"]
		strGoods = strGoods .. LocalStrings.GET .. basicData.name .. "*" .. self.m_tOpenResult.medalNum
		MsgBoxManager:showTipBox(strGoods, nil, nil, nil, nil, nil, nil, nil, nil, {x=0.5, y=0.78})
	end

	self:setOpenState(false)
	self:_afterCloseReward()
end

--@brief 	iphoneX适配
function WndBilliardBall:_adaptIphoneX()
	if IsIphoneX() then
	--	GetElement(self.m_root, "conLeftMenu_WndBilliardBall", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.13,0.45))
	end
end

--@brief 	设置免费丢
function WndBilliardBall:_setFreeBtnText()
	local txtBtnOpenOne = GetElement(self.m_root, "txtBtnOpenOne_WndBilliardBall", WZUILabelTTF)
	local txtBtnOpenFive = GetElement(self.m_root, "txtBtnOpenFive_WndBilliardBall", WZUILabelTTF)

	local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local freeTimes = 0 
	local nTempTimes = nLightNum
	local nTimes = 0
	if self.m_nCount > 0 and self.m_nPoleType == 0 then 
		freeTimes = 1
		txtBtnOpenOne:setText(LocalStrings.BILLIARDBALL_TEXT1[6])
		nTimes = (nTempTimes + freeTimes) >= self.m_nMaxLotteryCount and self.m_nMaxLotteryCount or nTempTimes > 0 and (nTempTimes + freeTimes) or self.m_nMaxLotteryCount 
	else
		if self.m_nPoleType == 0 then 
			nTimes = (nTempTimes + freeTimes) >= self.m_nMaxLotteryCount and self.m_nMaxLotteryCount or nTempTimes > 0 and (nTempTimes + freeTimes) or self.m_nMaxLotteryCount 
		else
			nTempTimes = math.floor(nLightNum/self.m_tGlovesCost[self.m_nPoleType + 1])
			nTimes = nTempTimes >= self.m_nMaxLotteryCount and self.m_nMaxLotteryCount or nTempTimes > 0 and nTempTimes or self.m_nMaxLotteryCount 
		end
		txtBtnOpenOne:setText(string.format(LocalStrings.BILLIARDBALL_TEXT1[5], 1))
	end
	if nTimes >= self.m_nMaxLotteryCount then 
		txtBtnOpenFive:setText(LocalStrings.BILLIARDBALL_TEXT1[9])
	else
		txtBtnOpenFive:setText(string.format(LocalStrings.BILLIARDBALL_TEXT1[5], nTimes))
	end
end

--@brief 	显示等级、经验
function WndBilliardBall:_showLvAndExp()
	local txtLevel = GetElement(self.m_root, "txtLevel_WndBilliardBall", WZUILabelTTF)
	local txtLvTitle = GetElement(self.m_root, "txtLvTitle_WndBilliardBall", WZUILabelTTF)
	local txtExp = GetElement(self.m_root, "txtExp_WndBilliardBall", WZUILabelTTF)
	local prgExp = GetElement(self.m_root, "prgExp_WndBilliardBall", WZUIProgress)

	local tCurInfo, tNextInfo, nMaxLv = self:getCurLvInfo()
	local strLvTitle = self.m_tContent.lvTitle[1]
	if tCurInfo then 
		strLvTitle = tCurInfo.name 
	end
	txtLevel:setText(LocalStrings.LV .. self.m_nCurLevel)
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
function WndBilliardBall:_createLvRewardList()
	local tbLvRewardList = GetElement(self.m_root, "tbLvRewardList_WndBilliardBall", WZUITableContainer)
	tbLvRewardList:cleanTable()

	for i = 1, #self.m_tLvRewardList do
		local element, tNewObj = CellLvRewardItem:createElement()
		if element and tNewObj then
			element:setTag(i - 1)
			tNewObj:setData(self.m_tLvRewardList[i], 1)

			tbLvRewardList:setCellElement(element)
		end
	end
end

--@brief 	设置待机特效
function WndBilliardBall:_setBallAni()
	local spinePath = "activity/hd_pic_qiugandz"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		local spineOpen = GetElement(self.m_root, "spineOpen_WndBilliardBall", WZUISpine)
		if spineOpen then 
			spineOpen:setFileJson(spinePath .. ".json")
			spineOpen:setFileAtlas(spinePath .. ".atlas")
			self:_setBowlingPlayAni(1, true)
		end
	else
		local _sIndex = "hd_pic_qiugandz"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7055, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndBilliardBall)
        end
	end
end

function WndBilliardBall:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndBilliardBall:downloadEffectCallback",taskId,extraData,failed)
    self:_setBallAni()
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndBilliardBall:_setBowlingPlayAni(aniIndex, bLoop)
	local spineOpen = GetElement(self.m_root, "spineOpen_WndBilliardBall", WZUISpine)
	aniIndex = aniIndex or 1
	WZLog("WndBilliardBall:_setBowlingPlayAni", self.m_nPoleType, aniIndex, bLoop)
	if spineOpen then 
		spineOpen:play(self.m_tBallAniName[self.m_nPoleType + 1][aniIndex], bLoop ~= nil and bLoop or true)
	end
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配begin----------------------------------------

function WndBilliardBall:_adaptLanguage_vn()
	GetElement(self.m_root, "txtBtnOpenOne_WndBilliardBall", WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root, "txtBtnOpenFive_WndBilliardBall", WZUILabelTTF):setFontSize(18)

	GetElement(self.m_root, "txtBigReward_WndBilliardBall", WZUILabelTTF):setFontSize(14)
end

-------------------------------------语言适配end----------------------------------------
