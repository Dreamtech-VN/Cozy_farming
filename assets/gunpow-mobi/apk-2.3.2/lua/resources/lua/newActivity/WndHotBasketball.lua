--WndHotBasketball.lua
--@brief	WndHotBasketball的UI模块
--@date		2023/09/01
--@author	XTX
--@note		热血篮球活动主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndHotBasketball:onEnter(element)
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
function WndHotBasketball:onExit(element)
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
function WndHotBasketball:onEnterTransitionDidFinish(element)
    WZLog("WndHotBasketball:onEnterTransitionDidFinish")
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7091, 7091)
end

--@brief    关闭窗口
function WndHotBasketball:onCloseClick(element)
	local eleType = type(element)
	if eleType ~= "number" then 
    	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    end

	SaveActivityPoleType("HOTBASKETBALL", self.m_nCalabashType)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮回调
function WndHotBasketball:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 	
 	WndFourStarRuleDesc:showInterface(LocalStrings.HOTBASKETBALL_TEXT2)
end

--@brief 	点击目标按钮回调
function WndHotBasketball:onClickTask(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if SystemTime:getServerTime() >= self.m_nEndTime then 
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END) 
		self:onCloseClick(0)
		return 
	end 

	local nTag = element:getTag()
	if nTag == 1 then 
		CellNewYearTask:showInterface(37, self.m_nActivityId)
	elseif nTag == 2 then
		WndDollMachineShop:showInterface(11, self.m_nActivityId)
	elseif nTag == 3 then 
		WndShopRank:showInterface(55, self.m_nActivityId) 
	end
end

--@brief 	点击大奖预览按钮回调
function WndHotBasketball:onClickBigReward(element)
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
function WndHotBasketball:onClickFive(element) 
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
    if self.m_bOpenState then MsgBoxManager:showTipBox(LocalStrings.HOTBASKETBALL_TEXT1[19]) return end 
    if self.m_nChooseReward == 0 then 
    	self:onClickBigReward(0)

		self.m_nChooseReward = 1
		SaveOperateTimes("HOTBASKETBALLACTIVITYID", self.m_nActivityId)
    	return 
    end

    self.m_nAniType = 1
	local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local nTempTimes = math.floor(nArrowNum/self.m_tCostByType[self.m_nCalabashType + 1])
	local nTimes = nTag
	local freeCount = 0
	if self.m_nCalabashType == 0 then 
		freeCount = self.m_nCount > 0 and 1 or 0 
	end
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
function WndHotBasketball:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

--@brief 	点击切换浪板类型
function WndHotBasketball:onChooseTool(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local nTag = element:getTag()
	if self.m_bOpenState then 
		GetElement(self.m_root, "cbgTool_WndHotBasketball", WZUICheckBoxGroup):setCheckIndex(self.m_nCalabashType)
		return 
	end 
	if self.m_nCalabashType == nTag then return end 

	self.m_nCalabashType = nTag
	self:_setFreeBtnText()
	local spineWait = GetElement(self.m_root, "spineWait_WndHotBasketball", WZUISpine)
	if spineWait then 
		spineWait:play(self.m_tBallAniName[self.m_nCalabashType + 1][1], true)
	end
end

--@brief	点击物品弹出对应的tips
function WndHotBasketball:onItemClick(tCell,tag,tData)
    if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData,false)
end

--@brief 	点击等级奖励按钮回调、
function WndHotBasketball:onClickLvReward(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	GetElement(self.m_root, "conLvReward_WndHotBasketball", WZUIContainer):setVisible(true)
	self:_createLvRewardList()
end

--@brief 	关闭捕鼠奖励界面
function WndHotBasketball:onCloseTip(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	GetElement(self.m_root, "conLvReward_WndHotBasketball", WZUIContainer):setVisible(false)
	self:showRedDot()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndHotBasketball:_update()
	-- body
	self:_setFreeBtnText()
	self:showRedDot()
	self:_initActivityTime()
    self:_updateLightNum()
end

--@brief 	初始化静态文本
function WndHotBasketball:_initStaticText()
	self.m_nCalabashType = GetActivityPoleType("HOTBASKETBALL")
	if self.m_nCalabashType ~= 0 then 
		GetElement(self.m_root, "cbgTool_WndHotBasketball", WZUICheckBoxGroup):setCheckIndex(self.m_nCalabashType)
	end

	GetElement(self.m_root, "txtBtnTask1_WndHotBasketball", WZUILabelTTF):setText(LocalStrings.HOTBASKETBALL_TEXT1[2])
	GetElement(self.m_root, "txtBtnTask2_WndHotBasketball", WZUILabelTTF):setText(LocalStrings.HOTBASKETBALL_TEXT1[8])
	GetElement(self.m_root, "txtBtnTask3_WndHotBasketball", WZUILabelTTF):setText(LocalStrings.HOTBASKETBALL_TEXT1[3])
	GetElement(self.m_root, "txtBigReward_WndHotBasketball", WZUILabelTTF):setText(LocalStrings.WATERMELON_TEXT1[22])
	GetElement(self.m_root, "txtLvRewardT_WndHotBasketball", WZUILabelTTF):setText(LocalStrings.HOTBASKETBALL_TEXT1[15])
	GetElement(self.m_root, "txtEggAtt_WndHotBasketball", WZUILabelTTF):setText(LocalStrings.HOTBASKETBALL_TEXT1[22])
	GetElement(self.m_root, "txtTab1_WndHotBasketball", WZUILabelTTF):setText(LocalStrings.HOTBASKETBALL_TEXT1[4])
	GetElement(self.m_root, "txtTabSel1_WndHotBasketball", WZUILabelTTF):setText(LocalStrings.HOTBASKETBALL_TEXT1[4])
	GetElement(self.m_root, "txtTab2_WndHotBasketball", WZUILabelTTF):setText(LocalStrings.HOTBASKETBALL_TEXT1[5])
	GetElement(self.m_root, "txtTabSel2_WndHotBasketball", WZUILabelTTF):setText(LocalStrings.HOTBASKETBALL_TEXT1[5])

	self:_setBallAni()
end

--@brief 	红点
function WndHotBasketball:showRedDot()
	-- body
	if self.m_root == nil then return end 

	local imgTaskRedDot = GetElement(self.m_root, "imgTaskRedDot_WndHotBasketball", WZUIImage)
	local imgExpReddot = GetElement(self.m_root, "imgExpReddot_WndHotBasketball", WZUIImage)

	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[117091] or GlobalGame.g_tRedPointTypeList[127091]) then 
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
function WndHotBasketball:_updateLightNum()
	-- body
	local ftxtLightNum = GetElement(self.m_root, "ftxtLightNum_WndHotBasketball", WZUIFreeTextBox)
	local sFormat = [[<I Z="0.45" P="1">%s</I><T C="255,255,255" S="18" P="1" SC="0,112,202" SS="4" SE="1">%d</T>]]
	if ftxtLightNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
		ftxtLightNum:setShowText(string.format(sFormat, basicData.icon, nLightNum))
	end
end

--@brief 	初始化活动时间
function WndHotBasketball:_initActivityTime()
	-- body
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndHotBasketball", WZUILabelTTF)
    if txtActivityTime then 
    	txtActivityTime:setText(needDay_str)
    end
end

--@brief 	显示开启动画
function WndHotBasketball:showOpenAction()
	-- body
	local spineOpen = GetElement(self.m_root, "spineOpen_WndHotBasketball", WZUISpine)
	local spinePath = "activity/hd_pic_rexuelanqiu"
	local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".json")

	if spineOpen then 
		if existSpine then 
			local aniIndex = 1
			if self.m_tOpenResult.addExp and self.m_tOpenResult.addExp > 0 then 
				aniIndex = 3 + self.m_nAniType
			else
				aniIndex = 1 + self.m_nAniType
			end
			self:_setBowlingPlayAni(aniIndex, false)
			self:showShootReward()
			spineOpen:enableSchedule("afterAni", 2.5)
		else
			self:showShootReward()
			self:setOpenState(false)
		end
	end
end

--@brief 	显示开启奖励
function WndHotBasketball:showShootReward()
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
		strContent = strContent .. LocalStrings.HOTBASKETBALL_TEXT1[18] .. "+" .. self.m_tOpenResult.addExp
	end

	if strContent ~= "" then 
		MsgBoxManager:showTipBox(strContent, nil, nil, nil, nil, nil, nil, nil, nil, GlobalMethod:ccp(0.5, 0.77))
	end

	self:_afterCloseReward()
end

--@brief 	播放露营动画后
function WndHotBasketball:afterAni(element)
	local spineOpen = GetElement(self.m_root, "spineOpen_WndHotBasketball", WZUISpine)
	spineOpen:disableSchedule()
	spineOpen:setVisible(false)
	self:setOpenState(false)
end

--@brief 	iphoneX适配
function WndHotBasketball:_adaptIphoneX()
	if IsIphoneX() then
		GetElement(self.m_root, "conT_WndHotBasketball", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.05,1))
		GetElement(self.m_root, "conLeftMenu_WndHotBasketball", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.95,0))
	end
end

--@brief 	设置免费丢
function WndHotBasketball:_setFreeBtnText()
	local txtBtnOpenOne = GetElement(self.m_root, "txtBtnOpenOne_WndHotBasketball", WZUILabelTTF)
	local txtBtnOpenFive = GetElement(self.m_root, "txtBtnOpenFive_WndHotBasketball", WZUILabelTTF)

	local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local freeTimes = 0 
	local nTempTimes = math.floor(nLightNum/self.m_tCostByType[self.m_nCalabashType + 1])
	local nTimes = 0

	local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local freeTimes = 0 
	local nTempTimes = math.floor(nLightNum/self.m_tCostByType[self.m_nCalabashType + 1])
	local nTimes = 0
	local strTemp = LocalStrings.HOTBASKETBALL_TEXT1[7]
	if self.m_nCalabashType == 0 then 
		if self.m_nCount > 0 then 
			freeTimes = 1
			txtBtnOpenOne:setText(LocalStrings.HOTBASKETBALL_TEXT1[6])
		else 
			txtBtnOpenOne:setText(string.format(strTemp, 1))
		end
	else
		txtBtnOpenOne:setText(string.format(strTemp, 1))
	end
	nTimes = (nTempTimes + freeTimes) >= self.m_nMaxLotteryCount and self.m_nMaxLotteryCount or nTempTimes > 0 and (nTempTimes + freeTimes) or self.m_nMaxLotteryCount 
	txtBtnOpenFive:setText(string.format(strTemp, nTimes))
end

--@brief 	设置待机特效
function WndHotBasketball:_setBallAni()
	local spinePath = "activity/hd_pic_rexuelanqiu"
	local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".json")
	if existSpine then 
		local spineOpen = GetElement(self.m_root, "spineOpen_WndHotBasketball", WZUISpine)
		local spineWait = GetElement(self.m_root, "spineWait_WndHotBasketball", WZUISpine)
		if spineOpen then 
			spineOpen:setFileJson(spinePath .. ".json")
			spineOpen:setFileAtlas(spinePath .. ".atlas")
		end
		if spineWait then 
			spineWait:setFileJson(spinePath .. ".json")
			spineWait:setFileAtlas(spinePath .. ".atlas")
			spineWait:play(self.m_tBallAniName[self.m_nCalabashType + 1][1], true)
		end
	else
		local _sIndex = "hd_pic_rexuelanqiu"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7091, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndHotBasketball)
        end
	end
end

function WndHotBasketball:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndHotBasketball:downloadEffectCallback",taskId,extraData,failed)
    self:_setBallAni()
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndHotBasketball:_setBowlingPlayAni(aniIndex, bLoop)
	local spineOpen = GetElement(self.m_root, "spineOpen_WndHotBasketball", WZUISpine)
	aniIndex = aniIndex or 1
	WZLog("WndHotBasketball:_setBowlingPlayAni", aniIndex, bLoop)

	if spineOpen then 
		spineOpen:setVisible(true)
		spineOpen:play(self.m_tBallAniName[self.m_nCalabashType + 1][aniIndex], bLoop ~= nil and bLoop or true)
	end
end

--@brief 	显示等级、经验
function WndHotBasketball:_showLvAndExp()
	local txtLevel = GetElement(self.m_root, "txtLevel_WndHotBasketball", WZUILabelTTF)
	local txtLvTitle = GetElement(self.m_root, "txtLvTitle_WndHotBasketball", WZUILabelTTF)
	local txtExp = GetElement(self.m_root, "txtExp_WndHotBasketball", WZUILabelTTF)
	local prgExp = GetElement(self.m_root, "prgExp_WndHotBasketball", WZUIProgress)

	local tCurInfo, tNextInfo, nMaxLv = self:getCurLvInfo()
	local strLvTitle = LocalStrings.HOTBASKETBALL_TEXT1[17][1]
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
function WndHotBasketball:_createLvRewardList()
	local tbLvRewardList = GetElement(self.m_root, "tbLvRewardList_WndHotBasketball", WZUITableContainer)
	tbLvRewardList:cleanTable()

	for i = 1, #self.m_tLvRewardList do
		local element, tNewObj = CellLvRewardItem:createElement()
		if element and tNewObj then
			element:setTag(i - 1)
			tNewObj:setData(self.m_tLvRewardList[i], 5)

			tbLvRewardList:setCellElement(element)
		end
	end
end

--@brief 	计时器
function WndHotBasketball:_caculateTime()
	-- body
	if self.m_nPaintedEggTime > 0 then 
		self.m_nPaintedEggTime = self.m_nPaintedEggTime - 1
		local txtEggTime = GetElement(self.m_root, "txtEggTime_WndHotBasketball", WZUILabelTTF)
		txtEggTime:setText(LocalStrings.HOTBASKETBALL_TEXT1[20] .. self.m_nPaintedEggTime .. "S")
		if self.m_nPaintedEggTime == 0 then 
			GetElement(self.m_root, "conPaitedEgg_WndHotBasketball", WZUIContainer):setVisible(false)
		end
	end
end

--@brief 	设置倒计时
function WndHotBasketball:_showPaintedEgg()
	if self.m_nPaintedEggTimesLeft >= 0 and self.m_nPaintedTimeLimit > self.m_nPaintedEggTimesLeft then 
		local txtEggTime = GetElement(self.m_root, "txtEggTime_WndHotBasketball", WZUILabelTTF)
		txtEggTime:setText(string.format(LocalStrings.HOTBASKETBALL_TEXT1[21], self.m_nPaintedEggTimesLeft))
		GetElement(self.m_root, "conPaitedEgg_WndHotBasketball", WZUIContainer):setVisible(true)
		return 
	end
	if self.m_nPaintedEggTime > 0 then 
		local txtEggTime = GetElement(self.m_root, "txtEggTime_WndHotBasketball", WZUILabelTTF)
		txtEggTime:setText(LocalStrings.HOTBASKETBALL_TEXT1[20] .. self.m_nPaintedEggTime .. "S")
		GetElement(self.m_root, "conPaitedEgg_WndHotBasketball", WZUIContainer):setVisible(true)
	else
		GetElement(self.m_root, "conPaitedEgg_WndHotBasketball", WZUIContainer):setVisible(false)
	end
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配模块Begin----------------------------------------

function WndHotBasketball:_adaptLanguage_vn()
	local txtBtnTask1 = GetElement(self.m_root,"txtBtnTask1_WndHotBasketball",WZUILabelTTF)
	txtBtnTask1:setScale(0.7)
	txtBtnTask1:setDimensions(GlobalMethod:CCSize(120,0))
	local txtBtnTask2 = GetElement(self.m_root,"txtBtnTask2_WndHotBasketball",WZUILabelTTF)
	txtBtnTask2:setScale(0.7)
	txtBtnTask2:setDimensions(GlobalMethod:CCSize(120,0))
	local txtBtnTask3 = GetElement(self.m_root,"txtBtnTask3_WndHotBasketball",WZUILabelTTF)
	txtBtnTask3:setScale(0.7)
	txtBtnTask3:setDimensions(GlobalMethod:CCSize(120,0))

	GetElement(self.m_root,"txtBtnOpenOne_WndHotBasketball",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtBtnOpenFive_WndHotBasketball",WZUILabelTTF):setScale(0.7)

	GetElement(self.m_root,"txtTab1_WndHotBasketball",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtTabSel1_WndHotBasketball",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtTab2_WndHotBasketball",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtTabSel2_WndHotBasketball",WZUILabelTTF):setScale(0.7)

	local txtEggTime = GetElement(self.m_root, "txtEggTime_WndHotBasketball", WZUILabelTTF)
	txtEggTime:setScale(0.7)
	txtEggTime:setDimensions(GlobalMethod:CCSize(280,0))

	GetElement(self.m_root,"txtLevel_WndHotBasketball",WZUILabelTTF):setScale(0.6)
end

-------------------------------------语言适配模块End----------------------------------------
