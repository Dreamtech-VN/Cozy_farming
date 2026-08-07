--WndZongZi.lua
--@brief	WndZongZi的UI模块
--@date		2023/05/30
--@author	XTX
--@note		粽有不同活动主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndZongZi:onEnter(element)
	self.m_root = element

	g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
	ProtocolProcessorFestivalActivity:regAll6()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
	GlobalGame:getGameEventDispathcer():Add(Independent_Activity.ActivityReddot, self.showRedDot, self)
	GlobalGame:getGameEventDispathcer():Add(NewVipEvent.NewVipEvent_ChargeSuccessResult,self._onRechargeSuccessResult,self)

	self:_initStaticText()
	self:_adaptIphoneX()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndZongZi:onExit(element)
	g_bIsShowWndDressUp = true
    g_tTempItemForLaterShow = {}
	CacheCenter:unregisterUpatePlayerItemObserver(self)
	ProtocolProcessorFestivalActivity:unregAll6()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
	GlobalGame:getGameEventDispathcer():Remove(Independent_Activity.ActivityReddot, self.showRedDot, self)
	GlobalGame:getGameEventDispathcer():Remove(NewVipEvent.NewVipEvent_ChargeSuccessResult,self._onRechargeSuccessResult,self)

	self:_unInit()
	LoadNewActivityRes(false)
	ChangeChatChannel(g_nLastChannelId_ShootArrow)
end

--@brief    onenter函数已执行
function WndZongZi:onEnterTransitionDidFinish(element)
    WZLog("WndZongZi:onEnterTransitionDidFinish")
    ChangeChatChannel(Chat_Channel_ZongZi)
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7079, 7079)
end

--@brief    关闭窗口
function WndZongZi:onCloseClick(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    local nTag = element:getTag()
    if nTag == 2 then 
    	GetElement(self.m_root, "conInterface2_WndZongZi", WZUIContainer):setVisible(false)
    else
		WindowManager:removeWindow(self.m_root, self, true)
	end
end

--@brief    点击规则按钮回调
function WndZongZi:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 	
	WndSingleMapDesc:showInterface1(LocalStrings.ZONGZI_TEXT2) 
end

--@brief 	点击目标按钮回调
function WndZongZi:onClickTask(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if SystemTime:getServerTime() >= self.m_nEndTime then 
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END)
		WindowManager:removeWindow(self.m_root, self, true)
		return 
	end
	local nTag = element:getTag()
	if nTag == 1 then --超级应援物
		GetElement(self.m_root, "conInterface2_WndZongZi", WZUIContainer):setVisible(true)
		self:_createDayRewardList()
	elseif nTag == 2 then --每日应援物
		if self.m_tContent.dailyStatus == 0 then 
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, "")
		else
			local data = {}

		    data.scale = 0.4
		    local reward_id = {}
		    local reward_num = {}
		    for id, num in pairs(self.m_tContent.dailyMap) do
		        table.insert(reward_id,  tonumber(id))
		        table.insert(reward_num, tonumber(num))
		    end
		    data.title = LocalStrings.ZONGZI_TEXT1[15]
		    data.titleFontSize = 20
		    data.rewardIds = reward_id
		    data.rewardNums = reward_num
		    WndNewTipsReward:showInterface(self.m_root, element, data, true, GlobalMethod:ccp(0.58, 0.42))
		end
	elseif nTag == 3 then --惜败礼包
		local data = {}

	    data.scale = 0.4
	    local reward_id = {}
	    local reward_num = {}
	    local sBigReward = self.m_tContent.lostGift
		local array = SplitStringWithSeparator(sBigReward, "&")
		local nSex = CacheCenter:getPlayerInfo().sex
		for i = 1, #array do
			local string = string.sub(array[i], 2, -2) 
			local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
			local num = tonumber(SplitStringWithSeparator(string,",")[3])

			table.insert(reward_id,  id)
	        table.insert(reward_num, num)
		end
	    data.title = LocalStrings.ZONGZI_TEXT1[14]
	    data.titleFontSize = 20
	    data.rewardIds = reward_id
	    data.rewardNums = reward_num
	    WndNewTipsReward:showInterface(self.m_root, element, data, true, GlobalMethod:ccp(0.75, 0.55))
	elseif nTag == 4 then --胜利礼包
		local data = {}

	    data.scale = 0.4
	    local reward_id = {}
	    local reward_num = {}
	    local sBigReward = self.m_tContent.winGift
		local array = SplitStringWithSeparator(sBigReward, "&")
		local nSex = CacheCenter:getPlayerInfo().sex
		for i = 1, #array do
			local string = string.sub(array[i], 2, -2) 
			local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
			local num = tonumber(SplitStringWithSeparator(string,",")[3])

			table.insert(reward_id,  id)
	        table.insert(reward_num, num)
		end
	    data.title = LocalStrings.ZONGZI_TEXT1[13]
	    data.titleFontSize = 20
	    data.rewardIds = reward_id
	    data.rewardNums = reward_num
	    WndNewTipsReward:showInterface(self.m_root, element, data, true, GlobalMethod:ccp(0.75, 0.55))
	elseif nTag == 5 then --结算界面确认
		GetElement(self.m_root, "conTurnResult_WndZongZi", WZUIContainer):setVisible(false)
		self.m_tLastContent = CopyTable(self.m_tContent)
		self.m_nLastTurnCamp = nil 
		self.m_nWinCamp = nil 
	elseif nTag == 6 then --打Call榜
		WndShopRank:showInterface(53, self.m_nActivityId) 
	end
end

--@brief 	点击开启按钮回调
function WndZongZi:onClickFive(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if SystemTime:getServerTime() >= self.m_nEndTime then 
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END)
		WindowManager:removeWindow(self.m_root, self, true)
		return 
	end
	local nTag = element:getTag()
	if nTag == 5 then 
		if self.m_nAniType == 2 then 
			self.m_nAniType = 1
		else
			self.m_nAniType = 2
		end
		--	local btnFile = {"ui/activity/common_btn_52.png", "ui/activity/common_btn_51.png"}
		local btnFile = {"ui/newvip/common_btn_41.png", "ui/newvip/common_btn_42.png"}
		local btnWordsStrokeColor = {GlobalMethod:ccc3(163,74,20), GlobalMethod:ccc3(0,108,3)}
		local imgOpenBtn = GetElement(self.m_root, "imgOpenBtn_WndZongZi", WZUIImage)
		local txtBtnOpenOne = GetElement(self.m_root, "txtBtnOpenOne_WndZongZi", WZUILabelTTF)
		imgOpenBtn:setFile(btnFile[self.m_nAniType])
		txtBtnOpenOne:setStrokeColor(btnWordsStrokeColor[self.m_nAniType])
		-- if self.m_nAniType == 1 then 
		-- 	txtBtnOpenOne:setEnableStroke(false)
		-- else
		-- 	txtBtnOpenOne:setEnableStroke(true)
		-- end
		self:_setFreeBtnText()
		return 
	end
	--背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
    if self.m_bOpenState then return end 
    if self.m_nCalabashType == 0 then 
    	MsgBoxManager:showTipBox(LocalStrings.ZONGZI_TEXT1[16])
    	return 
    end

	local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local nTempTimes = nArrowNum
	local nTimes = nTag
	local freeCount = 0

	if self.m_nAniType == 2 then 
		nTag = 2
		nTimes = (nTempTimes + freeCount) >= self.m_nMaxLotteryCount and self.m_nMaxLotteryCount or nTempTimes > 0 and (nTempTimes + freeCount) or self.m_nMaxLotteryCount 
	end
	local nCostNum = nTimes	
	if nCostNum - freeCount > nArrowNum then 
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
function WndZongZi:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

--@brief 	点击切换浪板类型
function WndZongZi:onChooseTool(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	if SystemTime:getServerTime() >= self.m_nEndTime then 
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END)
		WindowManager:removeWindow(self.m_root, self, true)
		return 
	end
	local nTag = element:getTag()
	if self.m_bOpenState then return end 
	if self.m_nCalabashType > 0 then 
		self:_setSelCamp()
		MsgBoxManager:showTipBox(LocalStrings.ZONGZI_TEXT1[11])
		return 
	end 
	if self.m_nTempChooseType == nil or self.m_nTempChooseType ~= nTag then
		self.m_nTempChooseType = nTag
	end
	MsgBoxManager:showConfirmBox(string.format(LocalStrings.ZONGZI_TEXT1[17], LocalStrings.ZONGZI_TEXT1[4 + nTag]), self, self.sureToChoose, nil, nil, nil, nil, nil, self.cancelToChoose)
end

--@brief 	确认选择当前阵营
function WndZongZi:sureToChoose()
	local tData = {}
	tData.camp = self.m_nTempChooseType

	local stringData = json.encode(tData)

	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 1, stringData)
end

--@brief 	确认选择当前阵营
function WndZongZi:cancelToChoose()
	GetElement(self.m_root, "checkBox" .. self.m_nTempChooseType .. "_WndZongZi", WZUICheckBox):setCheckIndex(0)
	self.m_nTempChooseType = nil 
end

--@brief 	点击解锁按钮回调
function WndZongZi:onClickUnLock(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local DayEndTab = os.date("*t", self.m_nEndTime)
	local DayCurTab = os.date("*t", SystemTime:getServerTime())
	if DayEndTab.month == DayCurTab.month and DayEndTab.day == DayCurTab.day then 
		MsgBoxManager:showTipBox(LocalStrings.ZONGZI_TEXT1[12])
		return 
	end
	PostPlayerEvent:postEvent(PostPlayerEvent.event_clickPay)
    local sdkData = {}
    local vipData = GDatatab_recharge["id_" .. self.m_nRechargeId]
    WZLog("WndZongZi:onClickUnLock:")
    sdkData.id = self.m_nRechargeId
    sdkData.price = vipData.price
    sdkData.productName = tostring(vipData.name)
    sdkData.payCode = GetPayCodeIdByChannelId(vipData)
    sdkData.quantifier = LocalStrings.SHOP_IND
    sdkData.number = "1"
    sdkData.giftNumber = "0"
    sdkData.productDesc = tostring(vipData.name)

    PassportSdkManager:getOrderNum(sdkData)
end

--@brief 	点击目标按钮回调
function WndZongZi:onClickGift(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = self.m_nWinCamp
	WZLog("WndZongZi:onClickGift", nTag, self.m_nLastTurnCamp)
	if (nTag == 1 or nTag == 2) and self.m_nLastTurnCamp ~= nTag then --惜败礼包
		local data = {}

	    data.scale = 0.4
	    local reward_id = {}
	    local reward_num = {}
	    local sBigReward = self.m_tLastContent.lostGift
		local array = SplitStringWithSeparator(sBigReward, "&")
		local nSex = CacheCenter:getPlayerInfo().sex
		for i = 1, #array do
			local string = string.sub(array[i], 2, -2) 
			local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
			local num = tonumber(SplitStringWithSeparator(string,",")[3])

			table.insert(reward_id,  id)
	        table.insert(reward_num, num)
		end
	    data.title = LocalStrings.ZONGZI_TEXT1[14]
	    data.titleFontSize = 20
	    data.rewardIds = reward_id
	    data.rewardNums = reward_num
	    WndNewTipsReward:showInterface(self.m_root, element, data, true, GlobalMethod:ccp(0.65, 0.55))
	elseif self.m_nLastTurnCamp == nTag then --胜利礼包
		local data = {}

	    data.scale = 0.4
	    local reward_id = {}
	    local reward_num = {}
	    local sBigReward = self.m_tLastContent.winGift
		local array = SplitStringWithSeparator(sBigReward, "&")
		local nSex = CacheCenter:getPlayerInfo().sex
		for i = 1, #array do
			local string = string.sub(array[i], 2, -2) 
			local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
			local num = tonumber(SplitStringWithSeparator(string,",")[3])

			table.insert(reward_id,  id)
	        table.insert(reward_num, num)
		end
	    data.title = LocalStrings.ZONGZI_TEXT1[13]
	    data.titleFontSize = 20
	    data.rewardIds = reward_id
	    data.rewardNums = reward_num
	    WndNewTipsReward:showInterface(self.m_root, element, data, true, GlobalMethod:ccp(0.65, 0.55))
	elseif nTag == 3 then --平局礼包
		local data = {}

	    data.scale = 0.4
	    local reward_id = {}
	    local reward_num = {}
	    local sBigReward = self.m_tLastContent.drawGift
		local array = SplitStringWithSeparator(sBigReward, "&")
		local nSex = CacheCenter:getPlayerInfo().sex
		for i = 1, #array do
			local string = string.sub(array[i], 2, -2) 
			local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
			local num = tonumber(SplitStringWithSeparator(string,",")[3])

			table.insert(reward_id,  id)
	        table.insert(reward_num, num)
		end
	    data.title = LocalStrings.ZONGZI_TEXT1[28]
	    data.titleFontSize = 20
	    data.rewardIds = reward_id
	    data.rewardNums = reward_num
	    WndNewTipsReward:showInterface(self.m_root, element, data, true, GlobalMethod:ccp(0.65, 0.55))
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndZongZi:_update()
	-- body
	self:_setSelCamp()
	self:_setFreeBtnText()
	self:showRedDot()
	self:_initActivityTime()
    self:_updateLightNum()
    self:_initDynamicText()
    self:_setUnlockBtnState()
    self:_setDaylyBtnState()
    self:_showAgainstValue()
end

--@brief 	初始化静态文本
function WndZongZi:_initStaticText()
	GetElement(self.m_root, "txtBtnTask1_WndZongZi", WZUILabelTTF):setText(LocalStrings.ZONGZI_TEXT1[7])
	GetElement(self.m_root, "txtBtnTask2_WndZongZi", WZUILabelTTF):setText(LocalStrings.ZONGZI_TEXT1[29])
	GetElement(self.m_root, "txtWin_WndZongZi", WZUILabelTTF):setText(LocalStrings.ZONGZI_TEXT1[3])
	GetElement(self.m_root, "txtFail_WndZongZi", WZUILabelTTF):setText(LocalStrings.ZONGZI_TEXT1[4])
	GetElement(self.m_root, "txtCheck1_WndZongZi", WZUILabelTTF):setText(LocalStrings.ZONGZI_TEXT1[5])
	GetElement(self.m_root, "txtCheckSel1_WndZongZi", WZUILabelTTF):setText(LocalStrings.ZONGZI_TEXT1[5])
	GetElement(self.m_root, "txtCheck2_WndZongZi", WZUILabelTTF):setText(LocalStrings.ZONGZI_TEXT1[6])
	GetElement(self.m_root, "txtCheckSel2_WndZongZi", WZUILabelTTF):setText(LocalStrings.ZONGZI_TEXT1[6])
	GetElement(self.m_root, "txtDailyGift_WndZongZi", WZUILabelTTF):setText(LocalStrings.ZONGZI_TEXT1[9])
	GetElement(self.m_root, "txtCampName1_WndZongZi", WZUILabelTTF):setText(LocalStrings.ZONGZI_TEXT1[6])
	GetElement(self.m_root, "txtCampName2_WndZongZi", WZUILabelTTF):setText(LocalStrings.ZONGZI_TEXT1[5])
	GetElement(self.m_root, "txtProgress3_WndZongZi", WZUILabelTTF):setText(LocalStrings.ZONGZI_TEXT1[22])

	self:_setBallAni()
end

--@brief 	红点
function WndZongZi:showRedDot()
	-- body
	if self.m_root == nil then return end 

	local imgTaskRedDot = GetElement(self.m_root, "imgTaskRedDot_WndZongZi", WZUIImage)

	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[17079] or GlobalGame.g_tRedPointTypeList[27079]) then 
		imgTaskRedDot:setVisible(true)
	else
		imgTaskRedDot:setVisible(false)
	end
end

--@brief 	更新异火的数量
function WndZongZi:_updateLightNum()
	-- body
	local ftxtLightNum = GetElement(self.m_root, "ftxtLightNum_WndZongZi", WZUIFreeTextBox)
	local sFormat = [[<I Z="0.5" P="1">%s</I><T C="255,255,255" S="20" P="1" SC="132,66,29" SS="4" SE="1">%d</T>]]
	if ftxtLightNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
		ftxtLightNum:setShowText(string.format(sFormat, basicData.icon, nLightNum))
	end
end

--@brief 	初始化活动时间
function WndZongZi:_initActivityTime()
	-- body
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndZongZi", WZUILabelTTF)
    if txtActivityTime then 
    	txtActivityTime:setText(LocalStrings.PEOPLE_SHOP_TEXT1 .. needDay_str)
    end
end

--@brief 	显示开启动画
function WndZongZi:showOpenAction()
	-- body
	local spinePath = self.m_strEffectPath
	local existSpine = CheckEffectFile(spinePath)

	local spineOpen = GetElement(self.m_root, "spineOpen_WndZongZi", WZUISpine)
	if spineOpen then 
		if existSpine then 
			self:_setBowlingPlayAni(self.m_nCalabashType, false)
			spineOpen:enableSchedule("showShootReward", 0.9)
		else
			self:showShootReward()
		end
	end
end

--@brief 	显示开启奖励
function WndZongZi:showShootReward()
	-- body
	local spineOpen = GetElement(self.m_root, "spineOpen_WndZongZi", WZUISpine)
	spineOpen:disableSchedule()
	self:_setBowlingPlayAni(3, true)

	local strContent = ""
	if self.m_tOpenResult.addExp and self.m_tOpenResult.addExp > 0 then 
		strContent = strContent .. LocalStrings.ZONGZI_TEXT1[21] .. "+" .. self.m_tOpenResult.addExp 
	end

	if strContent ~= "" then 
		MsgBoxManager:showTipBox(strContent, nil, nil, nil, nil, nil, nil, nil, nil, GlobalMethod:ccp(0.5, 0.77))
	end

	self:setOpenState(false)
	self:_afterCloseReward()
end

--@brief 	iphoneX适配
function WndZongZi:_adaptIphoneX()
	if IsIphoneX() then
		GetElement(self.m_root, "conLeftMenu_WndZongZi", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.02,0))
		GetElement(self.m_root, "conRightMenu_WndZongZi", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.98,0))
	end
end

--@brief 	设置免费丢
function WndZongZi:_setFreeBtnText()
	local txtBtnOpenOne = GetElement(self.m_root, "txtBtnOpenOne_WndZongZi", WZUILabelTTF)

	local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local freeTimes = 0 
	local nTempTimes = nLightNum
	local nTimes = 0
	if self.m_nAniType == 1 then 
		txtBtnOpenOne:setText(string.format(LocalStrings.ZONGZI_TEXT1[8], 1))
	else
		nTimes = (nTempTimes + freeTimes) >= self.m_nMaxLotteryCount and self.m_nMaxLotteryCount or nTempTimes > 0 and (nTempTimes + freeTimes) or self.m_nMaxLotteryCount 
		txtBtnOpenOne:setText(string.format(LocalStrings.ZONGZI_TEXT1[8], nTimes))
	end
end

--@brief 	这只选中阵营
function WndZongZi:_setSelCamp()
	WZLog("WndZongZi:_setSelCamp", self.m_nCalabashType)
	if self.m_nCalabashType > 0 then 
		GetElement(self.m_root, "cbgTool_WndZongZi", WZUICheckBoxGroup):setCheckIndex(self.m_nCalabashType - 1)
	else
		GetElement(self.m_root, "checkBox1_WndZongZi", WZUICheckBox):setCheckIndex(0)
		GetElement(self.m_root, "checkBox2_WndZongZi", WZUICheckBox):setCheckIndex(0)
	end
end

--@brief 	初始化动态文本
function WndZongZi:_initDynamicText()
	
end

--@brief 	设置解锁按钮状态
function WndZongZi:_setUnlockBtnState()
	if self.m_nNeedUnLock == -1 then 
		GetElement(self.m_root, "btnLock_WndZongZi", WZUIButton):setVisible(true)
	else
		GetElement(self.m_root, "btnLock_WndZongZi", WZUIButton):setVisible(false)
	end
end

--@brief 	设置每日应援物按钮状态
function WndZongZi:_setDaylyBtnState()
	if self.m_tContent.dailyStatus == 0 then 
		GetElement(self.m_root, "imgDailyRedDot_WndZongZi", WZUIImage):setVisible(true)
	else
		GetElement(self.m_root, "imgDailyRedDot_WndZongZi", WZUIImage):setVisible(false)
	end
end


--@brief 	创建n天奖励列表
function WndZongZi:_createDayRewardList()
	local tbDailyReward = GetElement(self.m_root, "tbDailyReward_WndZongZi", WZUITableContainer)
	tbDailyReward:cleanTable()
	self.m_tCellDay = {}

	for i = 1, #self.m_tDayReward do
		local element, tNewObj = CellZongZiItem:createElement()
		if element and tNewObj then 
			element:setTag(i - 1)
			tNewObj:setData(self.m_tDayReward[i])

			tbDailyReward:setCellElement(element)

			table.insert(self.m_tCellDay, tNewObj)
		end
	end
end

--@brief 	显示对抗值
function WndZongZi:_showAgainstValue()
	local txtCampName1 = GetElement(self.m_root, "txtCampName1_WndZongZi", WZUILabelTTF)
	local txtCampName2 = GetElement(self.m_root, "txtCampName2_WndZongZi", WZUILabelTTF)
	local txtProgress = GetElement(self.m_root, "txtProgress_WndZongZi", WZUILabelTTF)
	local txtProgress1 = GetElement(self.m_root, "txtProgress1_WndZongZi", WZUILabelTTF)
	local txtProgress2 = GetElement(self.m_root, "txtProgress2_WndZongZi", WZUILabelTTF)
	local txtProgress3 = GetElement(self.m_root, "txtProgress3_WndZongZi", WZUILabelTTF)
	local prgValueA = GetElement(self.m_root, "prgValueA_WndZongZi", WZUIProgress)
	local prgValueB = GetElement(self.m_root, "prgValueB_WndZongZi", WZUIProgress)
	if self.m_nCalabashType == 0 then 
		txtCampName1:setVisible(false)
		txtCampName2:setVisible(false)
		txtProgress:setVisible(true)
		prgValueA:setVisible(false)
		txtProgress1:setVisible(false)
		txtProgress2:setVisible(false)
		txtProgress3:setVisible(true)
		txtProgress:setText((self.m_nSaltyValue + self.m_nSweetValue) .. "/" .. self.m_nAgainstValue)
		local nPercentage = ((self.m_nSaltyValue + self.m_nSweetValue) * 100/self.m_nAgainstValue)
		if nPercentage > 100 then 
			nPercentage = 100
		end
		prgValueB:setPercentage(nPercentage)
	else
		txtProgress:setVisible(false)
		prgValueA:setVisible(true)
		txtCampName1:setVisible(true)
		txtCampName2:setVisible(true)
		txtProgress1:setVisible(true)
		txtProgress2:setVisible(true)
		txtProgress3:setVisible(false)
		txtProgress1:setText(self.m_nSweetValue * 100/self.m_nAgainstValue .. "%")
		txtProgress2:setText(self.m_nSaltyValue * 100/self.m_nAgainstValue .. "%")
		prgValueA:setPercentage(self.m_nSaltyValue * 100/self.m_nAgainstValue)
		prgValueB:setPercentage(self.m_nSweetValue * 100/self.m_nAgainstValue)
	end
end

--@brief 	设置待机特效
function WndZongZi:_setBallAni()
	local spinePath = self.m_strEffectPath
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		local spineOpen = GetElement(self.m_root, "spineOpen_WndZongZi", WZUISpine)
		local spineWait = GetElement(self.m_root, "spineWait_WndZongZi", WZUISpine)
		if spineOpen then 
			spineOpen:setFileJson(spinePath .. ".json")
			spineOpen:setFileAtlas(spinePath .. ".atlas")
			self:_setBowlingPlayAni(3, true)
		end
		if spineWait then 
			spineWait:setFileJson(spinePath .. ".json")
			spineWait:setFileAtlas(spinePath .. ".atlas")
			spineWait:play("wait", true)
		end
	end
end

function WndZongZi:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndZongZi:downloadEffectCallback",taskId,extraData,failed)
    self:_setBallAni()
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndZongZi:_setBowlingPlayAni(aniIndex, bLoop)
	local spineOpen = GetElement(self.m_root, "spineOpen_WndZongZi", WZUISpine)
	aniIndex = aniIndex or 1
	WZLog("WndZongZi:_setBowlingPlayAni", aniIndex, bLoop)
	
	if spineOpen then 
		spineOpen:setVisible(true)
		spineOpen:play(self.m_tBallAniName[aniIndex], bLoop ~= nil and bLoop or true)
	end
end

--@brief 	显示本轮结算礼包
function WndZongZi:_showTurnResult()
	if self.m_nLastTurnCamp == nil or self.m_nLastTurnCamp == 0 or self.m_nWinCamp == nil or self.m_nWinCamp <= 0 then return end 

	GetElement(self.m_root, "conTurnResult_WndZongZi", WZUIContainer):setVisible(true)
	local txtGiftTitle = GetElement(self.m_root, "txtGiftTitle_WndZongZi", WZUILabelTTF)
	local imgGiftIcon = GetElement(self.m_root, "imgGiftIcon_WndZongZi", WZUIImage)
	if self.m_nLastTurnCamp == self.m_nWinCamp then
		imgGiftIcon:setFile("shopitems/hd_zqj_sllb.png")
		txtGiftTitle:setText(LocalStrings.ZONGZI_TEXT1[25])
	elseif self.m_nLastTurnCamp ~= self.m_nWinCamp and self.m_nWinCamp ~= 3 then 
		imgGiftIcon:setFile("shopitems/hd_zqj_sblb.png")
		txtGiftTitle:setText(LocalStrings.ZONGZI_TEXT1[26])
	elseif self.m_nWinCamp == 3 then 
		imgGiftIcon:setFile("shopitems/ybdz_yyw.png")
		txtGiftTitle:setText(LocalStrings.ZONGZI_TEXT1[27])
	end
end
-------------------------------------私有方法模块End----------------------------------------


function WndZongZi:_adaptLanguage_vn()
	GetElement(self.m_root,"txtBtnTask1_WndZongZi",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtWin_WndZongZi",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtFail_WndZongZi",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtBtnOpenOne_WndZongZi",WZUILabelTTF):setScale(0.8)
end