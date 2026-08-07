--WndEightYear.lua
--@brief	WndEightYear的UI模块
--@date		2024/03/29
--@author	XTX
--@note		8周年庆典活动主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndEightYear:onEnter(element)
	self.m_root = element

	g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
	ProtocolProcessorFestivalActivity:regAll6()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
	GlobalGame:getGameEventDispathcer():Add(Independent_Activity.ActivityReddot, self.showRedDot, self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetTaskList,self._onGetTaskInfo,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetResult,self._onGetTaskResult,self)

	self:_initStaticText()
	self:_adaptIphoneX()
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndEightYear:onExit(element)
	g_bIsShowWndDressUp = true
    g_tTempItemForLaterShow = {}
	CacheCenter:unregisterUpatePlayerItemObserver(self)
	ProtocolProcessorFestivalActivity:unregAll6()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
	GlobalGame:getGameEventDispathcer():Remove(Independent_Activity.ActivityReddot, self.showRedDot, self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetTaskList,self._onGetTaskInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetResult,self._onGetTaskResult,self)

	self:_unInit()

	LoadNewActivityRes(false)
end

--@brief    onenter函数已执行
function WndEightYear:onEnterTransitionDidFinish(element)
    WZLog("WndEightYear:onEnterTransitionDidFinish")
    self:createLeftBtn()
end

--@brief    关闭窗口
function WndEightYear:onCloseClick(element)
	local nType = type(element)
	local nTag = 0
	if nType ~= "number" then 
	    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	    nTag = element:getTag()
	else
		nTag = element
	end
    if nTag == 2 then 
    	GetElement(self.m_root, "conOrderInfo_WndEightYear", WZUIContainer):setVisible(false)
    elseif nTag == 3 then 
    	GetElement(self.m_root, "conOtherOrder_WndEightYear", WZUIContainer):setVisible(false)
    elseif nTag == 4 then 
    	GetElement(self.m_root, "conPay_WndEightYear", WZUIContainer):setVisible(false)
    else
    	if self.m_root then 
			WindowManager:removeWindow(self.m_root, self, true)
		end
	end
end

--@brief    点击规则按钮回调
function WndEightYear:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 	

    WndFourStarRuleDesc:showInterface(LocalStrings.EIGHTYEAR_TEXT2)
end

--@brief 	点击目标按钮回调
function WndEightYear:onClickTask(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if SystemTime:getServerTime() >= self.m_nEndTime then 
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END) 
		return 
	end 

	local nTag = element:getTag()
	if nTag == 1 then 
		local otherData = {}
		otherData.taskCount = 2 --几个任务标签
		otherData.tTaskTypeName = {LocalStrings.EIGHTYEAR_TEXT1[18], LocalStrings.EIGHTYEAR_TEXT1[19]} --任务标签名字
		otherData.taskTitle = LocalStrings.EIGHTYEAR_TEXT1[3]
		otherData.taskType = 2
		otherData.redPoint = {117120, 127120} --长线；日常；每天
		otherData.img9Bg = "ui/common/frame_tc_xiao_zi.png"
		otherData.imgBtnClose = "ui/common/common_top_btn_guanbi_zi.png"
		otherData.normal = "ui/activity/common_btn_40.png"
		otherData.select = "ui/activity/common_btn_39.png"
		otherData.itemImg9Bg = "ui/common/frame_lieb_03.png"
		otherData.itemImg9Title = "ui/activity/title_frame_10.png"
		otherData.origin = 807120

		CellNewYearTask:showInterface(60, self.m_nActivityId, otherData)
	elseif nTag == 2 then --全服礼包
		self:onClickGift(element)
	elseif nTag == 3 then 
		local otherData = {}
		otherData.type = 1
		otherData.strRankTitleName = LocalStrings.EIGHTYEAR_TEXT1[8]
		otherData.strCountLabel = string.format(LocalStrings.NEWYEAR_TEXT15,100)
		otherData.strChangeTitle = LocalStrings.EIGHTYEAR_TEXT1[36]
		otherData.strScoreTitle = LocalStrings.EIGHTYEAR_TEXT1[36] .. ":"
		otherData.rankBg = "ui/common/frame_tc_xiao_zi.png"
		otherData.titleBgImg = "ui/common/frame_12_1.png"
		otherData.imgBtnClose = "ui/common/common_top_btn_guanbi_zi.png"
		otherData.scoreTitleColor = GlobalMethod:ccc3(255,236,193)
		otherData.myRankColor = GlobalMethod:ccc3(255,255,255)
		otherData.myScoreColor = GlobalMethod:ccc3(255,255,255)
		otherData.countLabelColor = GlobalMethod:ccc3(255,255,255)
		otherData.rankTitleColor = GlobalMethod:ccc3(255,236,193)

		WndShopRank:showInterface(90, self.m_nActivityId, nil, nil, otherData) 
	elseif nTag == 4 then --拼单信息
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, "")
	elseif nTag == 5 then --拼单大神
		local otherData = {}
		otherData.type = 1
		otherData.strRankTitleName = LocalStrings.EIGHTYEAR_TEXT1[13]
		otherData.strCountLabel = string.format(LocalStrings.NEWYEAR_TEXT15,100)
		otherData.strChangeTitle = LocalStrings.EIGHTYEAR_TEXT1[29]
		otherData.strScoreTitle = LocalStrings.EIGHTYEAR_TEXT1[29] .. ":"
		otherData.rankBg = "ui/common/frame_tc_xiao_zi.png"
		otherData.titleBgImg = "ui/common/frame_12_1.png"
		otherData.imgBtnClose = "ui/common/common_top_btn_guanbi_zi.png"
		otherData.scoreTitleColor = GlobalMethod:ccc3(255,236,193)
		otherData.myRankColor = GlobalMethod:ccc3(255,255,255)
		otherData.myScoreColor = GlobalMethod:ccc3(255,255,255)
		otherData.countLabelColor = GlobalMethod:ccc3(255,255,255)
		otherData.rankTitleColor = GlobalMethod:ccc3(255,236,193)

		WndShopRank:showInterface(90, self.m_nActivityId, nil, nil, otherData) 
	elseif nTag == 6 then --刷新
		if self.m_nFreshTimes >= self.m_tContent.costConfig[4] then 
			MsgBoxManager:showTipBox(LocalStrings.HEROTOWER_TEXT16)
			return 
		end
		local nCostNum = self.m_tContent.costConfig[2] + self.m_nFreshTimes * self.m_tContent.costConfig[3]
		if not JudgeMoneyIsEnough(self.m_tContent.costConfig[1], nCostNum, nil, nil, nil, nil, nil, nil, nil, self, self.sureUseDiamondInstead) then 
			return 
		end

		self:sureUseDiamondInstead()
	end
end

--@brief    确认用钻石代替礼券开启卡套回调
function WndEightYear:sureUseDiamondInstead()
    -- body
    --发送打开卡套协议
    ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 5, "")
end

--@brief 	点击大奖预览按钮回调
function WndEightYear:onClickBigReward(element)
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
function WndEightYear:onClickFive(element) 
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
    if self.m_bOpenState then return end 
    if self.m_nChooseReward == 0 then 
    	self:onClickBigReward(0)

		self.m_nChooseReward = 1
		SaveOperateTimes("EIGHTYEARACTIVITYID", self.m_nActivityId)
    	return 
    end

	local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local nTempTimes = math.floor(nArrowNum/self.m_tCostByType[self.m_nCalabashType + 1])
	local nTimes = nTag
	local freeCount = 0
	if self.m_nCalabashType == 0 then 
		freeCount = self.m_nCount > 0 and 1 or 0 
	end

	local useTimes = nTimes 
	self.m_nAniType = 1
	if nTag == 5 then 
		self.m_nAniType = 2
		nTimes = (nTempTimes + freeCount) >= self.m_nMaxLotteryCount and self.m_nMaxLotteryCount or nTempTimes > 0 and (nTempTimes + freeCount) or self.m_nMaxLotteryCount 
		
		useTimes = nTimes 
	end
	local nCostNum = useTimes * self.m_tCostByType[self.m_nCalabashType + 1]
	if nCostNum - freeCount > nArrowNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		MsgBoxManager:showConfirmBox(string.format(LocalStrings.WATERCOUNTRY_TEXT4, basicData.name), self, self.goToBuy)
		return 
	end

    local tData = {}
	tData.times = useTimes

	local stringData = json.encode(tData)

	self:setOpenState(true)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 3, stringData)
end

--@brief 	前往小推车购买
function WndEightYear:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        -- WndActivityPropsGift:showInterface(self.m_nCoinId)
        WndApartmentAct:showInterface()
    end
end

--@brief	点击物品弹出对应的tips
function WndEightYear:onItemClick(tCell,tag,tData)
    if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData,false)
end

--@brief	点击物品弹出对应的tips
function WndEightYear:onClickItem(element)
    WndItemInfo:onCloseClick()

    local nTag = element:getTag()
    local goodData = self.m_tGoodsData[nTag + (self.m_nPageIndex - 1) * 2]
    local conGoods = GetElement(self.m_root, "conGoods" .. nTag .. "_conActivity4")
    local tData = {basicInfo = GDatatab_item["id_" .. goodData.itemId], lastNum = goodData.itemNum}
   	WndItemInfo:showInfo(conGoods, self.m_root, 1, tData, false)
end

--@brief 	点击全民采茶按钮回调
function WndEightYear:onClickGift(element)
	-- body
	if self.m_nGiftRewardNum >= 1 then
		--背包已满提示
	    if CacheCenter:getRemainAmount() <= 0 then
	        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
	        return
	    end
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 5, "")
	else
		local tData = {}
		tData.txtTitle = string.format(LocalStrings.EIGHTYEAR_TEXT1[33], self.m_nGiftRewardConfig)
		tData.nType = 2
		WndTips:show(element, self.m_root, 52, tData, GlobalMethod:ccp(200,80), true)
	end
end

--@brief	减少1个
function WndEightYear:onReduce(element)
	WZLog("WndEightYear:onReduce")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nNum - 1 >= 1 then
		self.m_nNum = self.m_nNum - 1
	else
		MsgBoxManager:showTipBox(LocalStrings.CHESTMINNUM)
	end
	GetElement(self.m_root,"useNum_conActivity2",WZUILabelTTF):setText(self.m_nNum)
	self:_showMakeCost()
end

--@brief	增加1个
function WndEightYear:onAdd(element)
	WZLog("WndEightYear:onAdd")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	self.m_nNum = self.m_nNum + 1
	
	if self.m_nNum == 0 then self.m_nNum = 1 end
	GetElement(self.m_root,"useNum_conActivity2",WZUILabelTTF):setText(self.m_nNum)
	self:_showMakeCost()
end

--@brief 	点击开始制作按钮回调
function WndEightYear:onClickMake(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local tData = {}
	tData.times = self.m_nNum

	local stringData = json.encode(tData)

	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, stringData)
end

--@brief 	点击切换活动类型
function WndEightYear:onClickTab(element)
	local nType = type(element)
	local nTag = 1
	if nType ~= "number" then 
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
		nTag = element:getTag()
	else
		nTag = element
	end

	local nActivityId = self.m_tActivityList[nTag]
	for i = 1, #self.m_tTempList do
		if nActivityId == self.m_tTempList[i] then 
			GetElement(self.m_root, "conActivity" .. i .. "_WndEightYear", WZUIContainer):setVisible(true)
		else
			GetElement(self.m_root, "conActivity" .. i .. "_WndEightYear", WZUIContainer):setVisible(false)
		end
	end

	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo["activity" .. self.m_tActivityList[nTag]], self.m_tActivityList[nTag])
end

--@brief 	点击翻页按钮回调
function WndEightYear:onPagePre(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_nPageIndex > 1 then 
		self.m_nPageIndex = self.m_nPageIndex - 1
	else
		self.m_nPageIndex = self.m_nAllPage
	end
	self:_showGoods()
end

--@brief 	点击翻页按钮回调
function WndEightYear:onPageNext(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_nPageIndex < self.m_nAllPage then 
		self.m_nPageIndex = self.m_nPageIndex + 1
	else
		self.m_nPageIndex = 1
	end
	self:_showGoods()
end

--@brief 	点击参与拼单按钮回调
function WndEightYear:onClickBuy(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	WZLog("WndEightYear:onClickBuy", nTag)
	if nTag == 1 then --参与拼单
		WZLog("WndEightYear:onClickBuy", Serialize(self.m_tBuyData))
		if not JudgeMoneyIsEnough(self.m_tBuyData.costId, self.m_tBuyData.discountPrice) then 
			return 
		end
		local tData = {}
		tData.orderId = self.m_tBuyData.orderId
		
		local stringData = json.encode(tData)

		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 4, stringData)
	elseif nTag == 2 then --支付界面支付
		local tData = {}
		tData.id = self.m_tBuyData.id
		tData.buyType = 0

		local stringData = json.encode(tData)

		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 3, stringData)
	end
end

--@brief 	参与拼单界面点击头像回调
function WndEightYear:onClickHead(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WndCheckOther:show(self.m_tBuyData.masterPlayerId)
end

--@brief 	发起拼单按钮回调
function WndEightYear:onClickBuild(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 	
 	local nTag = element:getTag()
 	local nIndex = math.floor(nTag/10)
 	local nBtnIndex = math.fmod(nTag, 10)
 	local tItemData = self.m_tGoodsData[nIndex + (self.m_nPageIndex - 1) * 2]
	local orderCount = #tItemData.orderInfo
	WZLog("WndEightYear:onClickBuild", nBtnIndex, tItemData.activityId, tItemData.id)
	local ownNum = CacheCenter:getPlayerItemCountById(tItemData.costId)
	if nBtnIndex == 1 then --直接购买
		if not JudgeMoneyIsEnough(tItemData.costId, tItemData.price) then 
			return 
		end
		local tData = {}
		tData.id = tItemData.id
		tData.buyType = 1

		local stringData = json.encode(tData)

		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(tItemData.activityId, 3, stringData)
	elseif nBtnIndex == 2 then --发起拼单
		if not self:_judgeHaveNotFinishOrder(tItemData) then --每个玩家每种商品，只能有一个未完成的拼单
			MsgBoxManager:showTipBox(LocalStrings.EIGHTYEAR_TEXT1[37])
			return 
		end
		if orderCount >= self.m_tContent.goodsConfig[2] then 
			MsgBoxManager:showTipBox(LocalStrings.EIGHTYEAR_TEXT1[38])
			return 
		end
		if not JudgeMoneyIsEnough(tItemData.costId, tItemData.discountPrice) then 
			return 
		end
		WndEightYear:_showPay(tItemData)
	elseif nBtnIndex == 3 then --立即发起多人拼单
		if orderCount >= self.m_tContent.goodsConfig[2] then 
			MsgBoxManager:showTipBox(LocalStrings.EIGHTYEAR_TEXT1[38])
			return 
		end
		if not JudgeMoneyIsEnough(tItemData.costId, tItemData.discountPrice) then 
			return 
		end
		WndEightYear:_showPay(tItemData)
	end
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndEightYear:_update()
	-- body
	self:_setFreeBtnText()
	self:showRedDot()
	self:_initActivityTime()
    self:_updateLightNum()
    self:showBagGiftInfo()
end

--@brief 	初始化静态文本
function WndEightYear:_initStaticText()
	GetElement(self.m_root, "txtBtnTask1_WndEightYear", WZUILabelTTF):setText(LocalStrings.EIGHTYEAR_TEXT1[3])
	GetElement(self.m_root, "txtBtnTask2_WndEightYear", WZUILabelTTF):setText(LocalStrings.EIGHTYEAR_TEXT1[7])
	GetElement(self.m_root, "txtBtnTask3_WndEightYear", WZUILabelTTF):setText(LocalStrings.EIGHTYEAR_TEXT1[8])
	GetElement(self.m_root, "txtBigReward_WndEightYear", WZUILabelTTF):setText(LocalStrings.WATERMELON_TEXT1[22])

	GetElement(self.m_root, "txtOrder_conActivity4", WZUILabelTTF):setText(LocalStrings.EIGHTYEAR_TEXT1[12])
	GetElement(self.m_root, "txtOrderGod_conActivity4", WZUILabelTTF):setText(LocalStrings.EIGHTYEAR_TEXT1[13])

	GetElement(self.m_root, "txtMaterial_conActivity2", WZUILabelTTF):setText(LocalStrings.EIGHTYEAR_TEXT1[6])
	GetElement(self.m_root, "useNum_conActivity2", WZUILabelTTF):setText(self.m_nNum)
	GetElement(self.m_root, "imgIcon_conActivity2", WZUIImage):setFile(GDatatab_item["id_" .. self.m_nCoinId3].icon)
	GetElement(self.m_root, "txtMake1_WndEightYear", WZUILabelTTF):setText(LocalStrings.EIGHTYEAR_TEXT1[5])
	GetElement(self.m_root, "txtMake2_WndEightYear", WZUILabelTTF):setText(LocalStrings.EIGHTYEAR_TEXT1[5])
	GetElement(self.m_root, "txtMake3_WndEightYear", WZUILabelTTF):setText(LocalStrings.EIGHTYEAR_TEXT1[5])

	GetElement(self.m_root, "txtTitle_conOrderInfo", WZUILabelTTF):setText(LocalStrings.EIGHTYEAR_TEXT1[23])
	GetElement(self.m_root, "txtHost_conOtherOrder", WZUILabelTTF):setText(LocalStrings.EIGHTYEAR_TEXT1[28])

	self.m_imgArrow = GetElement(self.m_root, "imgArrow_WndEightYear", WZUIImage)
	self.m_imgCircleArrow = GetElement(self.m_root, "imgCircleArrow_WndEightYear", WZUIImage)

	local imgIcon = GetElement(self.m_root,"imgIcon_conActivity2",WZUIImage)
	local icon = GDatatab_item["id_" .. self.m_nCoinId3].icon
	imgIcon:setFile(icon)

	self:_setBallAni()
end

--@brief 	红点
function WndEightYear:showRedDot()
	-- body
	if self.m_root == nil then return end 

	local imgTaskRedDot = GetElement(self.m_root, "imgTaskRedDot_WndEightYear", WZUIImage)

	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[117120] or GlobalGame.g_tRedPointTypeList[127120]) then 
		imgTaskRedDot:setVisible(true)
	else
		imgTaskRedDot:setVisible(false)
	end

	for i = 1, #self.m_tActivityList do
		local imgLeftRed = GetElement(self.m_root, "imgLeftRed" .. i .. "_WndEightYear", WZUIImage)
		if GlobalGame.g_tRedPointTypeList and GlobalGame.g_tRedPointTypeList[self.m_tActivityList[i]] then 
			imgLeftRed:setVisible(true)
		else
			imgLeftRed:setVisible(false)
		end
	end
end

--@brief 	更新异火的数量
function WndEightYear:_updateLightNum()
	-- body
	local ftxtLightNum = GetElement(self.m_root, "ftxtLightNum_WndEightYear", WZUIFreeTextBox)
	local sFormat = [[<I Z="0.45" P="1">%s</I><T C="255,255,255" S="18" P="1" SC="163,74,20" SS="4" SE="0">%d</T>]]
	if ftxtLightNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
		ftxtLightNum:setShowText(string.format(sFormat, basicData.icon, nLightNum))
	end

	local txtOwn = GetElement(self.m_root, "txtOwn_conActivity2", WZUILabelTTF)
	if txtOwn then 
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId3)
		txtOwn:setText(nLightNum)
		self:_updateExchangeBtnState(nLightNum)
	end
	local txtOwn1 = GetElement(self.m_root, "txtOwn1_conActivity2", WZUILabelTTF)
	if txtOwn1 then 
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId2)
		txtOwn1:setText(LocalStrings.OWN .. ":" .. nLightNum)
	end
	local txtOwn2 = GetElement(self.m_root, "txtOwn2_conActivity2", WZUILabelTTF)
	if txtOwn2 then 
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId4)
		txtOwn2:setText(LocalStrings.OWN .. ":" .. nLightNum)
	end

	local ftxtLightNum2 = GetElement(self.m_root, "ftxtLightNum2_WndEightYear", WZUIFreeTextBox)
	if ftxtLightNum2 then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId5]
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId5)
		ftxtLightNum2:setShowText(string.format(sFormat, basicData.icon, nLightNum))
	end

end

--@brief 	初始化活动时间
function WndEightYear:_initActivityTime()
	-- body
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndEightYear", WZUILabelTTF)
    if txtActivityTime then 
    	txtActivityTime:setText(needDay_str)
    end
end

--@brief 	显示开启动画
function WndEightYear:showOpenAction()
	-- body
	local spineOpen = GetElement(self.m_root, "spineOpen_WndEightYear", WZUISpine)
	local spineWaitOpen = GetElement(self.m_root, "spineWaitOpen_WndEightYear", WZUISpine)
	local spinePath = "activity/hd_pic_dghd"
	local existSpine = CheckEffectFile(spinePath)
	
	if spineOpen then 
		if existSpine then 
			self:_setBowlingPlayAni(self.m_nAniType + 1, false)
			spineWaitOpen:enableSchedule("waitHide", 0.03)
			spineOpen:enableSchedule("afterAni", 1.5)
		else
			self:showShootReward()
			self:setOpenState(false)
		end
	end
end

--@brief 	显示开启奖励
function WndEightYear:showShootReward()
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
		strContent = strContent .. LocalStrings.CATHOUSE_TEXT1[9] .. "+" .. self.m_tOpenResult.addExp
	end

	if strContent ~= "" then 
		MsgBoxManager:showTipBox(strContent, nil, nil, nil, nil, nil, nil, nil, nil, GlobalMethod:ccp(0.5, 0.77))
	end

	self:_afterCloseReward()
end

--@brief 	iphoneX适配
function WndEightYear:_adaptIphoneX()
	if IsIphoneX() then
		GetElement(self.m_root, "conLeftScore_WndEightYear", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.055,0.58))
	end
end

--@brief 	设置免费丢
function WndEightYear:_setFreeBtnText()
	local txtBtnOpenOne = GetElement(self.m_root, "txtBtnOpenOne_WndEightYear", WZUILabelTTF)
	local txtBtnOpenFive = GetElement(self.m_root, "txtBtnOpenFive_WndEightYear", WZUILabelTTF)

	local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local freeTimes = 0 
	local nTempTimes = math.floor(nLightNum/self.m_tCostByType[self.m_nCalabashType + 1])
	local nTimes = 0
	local strTemp = LocalStrings.EIGHTYEAR_TEXT1[10]
	local nMileToTimes = self.m_nMaxLotteryCount

	if self.m_nCalabashType == 0 then 
		if self.m_nCount > 0 then 
			freeTimes = 1
			txtBtnOpenOne:setText(LocalStrings.EIGHTYEAR_TEXT1[9])
		else 
			txtBtnOpenOne:setText(string.format(strTemp, 1))
		end
	else
		strTemp = LocalStrings.EIGHTYEAR_TEXT1[10]
		txtBtnOpenOne:setText(string.format(strTemp, 1))
	end

	nTimes = (nTempTimes + freeTimes) >= self.m_nMaxLotteryCount and self.m_nMaxLotteryCount or nTempTimes > 0 and (nTempTimes + freeTimes) or self.m_nMaxLotteryCount 

	txtBtnOpenFive:setText(string.format(strTemp, nTimes))

end

--@brief 	设置待机特效
function WndEightYear:_setBallAni()
	local spinePath = "activity/hd_pic_dghd"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		local spineOpen = GetElement(self.m_root, "spineOpen_WndEightYear", WZUISpine)
		local spineWaitOpen = GetElement(self.m_root, "spineWaitOpen_WndEightYear", WZUISpine)
		local spineWait = GetElement(self.m_root, "spineWait_WndEightYear", WZUISpine)
		local spineWaitOut = GetElement(self.m_root, "spineWaitOut_WndEightYear", WZUISpine)
		local spineWaitCD = GetElement(self.m_root, "spineWaitCD_WndEightYear", WZUISpine)
		local spineWaitFW = GetElement(self.m_root, "spineWaitFW_WndEightYear", WZUISpine)
		if spineOpen then 
			spineOpen:setFileJson(spinePath .. ".json")
			spineOpen:setFileAtlas(spinePath .. ".atlas")
		end
		if spineWaitOpen then 
			spineWaitOpen:setFileJson(spinePath .. ".json")
			spineWaitOpen:setFileAtlas(spinePath .. ".atlas")
			self:_setBowlingPlayAni(1, true)
		end
		if spineWait then 
			spineWait:setFileJson(spinePath .. ".json")
			spineWait:setFileAtlas(spinePath .. ".atlas")
			spineWait:play("wait_insioe", true)
		end
		if spineWaitOut then 
			spineWaitOut:setFileJson(spinePath .. ".json")
			spineWaitOut:setFileAtlas(spinePath .. ".atlas")
			spineWaitOut:play("wait_outsioe", true)
		end
		if spineWaitCD then 
			spineWaitCD:setFileJson(spinePath .. ".json")
			spineWaitCD:setFileAtlas(spinePath .. ".atlas")
			spineWaitCD:play("wait_EX", true)
		end
		if spineWaitFW then 
			spineWaitFW:setFileJson(spinePath .. ".json")
			spineWaitFW:setFileAtlas(spinePath .. ".atlas")
			spineWaitFW:play("wait_EX2", true)
		end
	end
end

function WndEightYear:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndEightYear:downloadEffectCallback",taskId,extraData,failed)
    self:_setBallAni()
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndEightYear:_setBowlingPlayAni(aniIndex, bLoop)
	local spineOpen = GetElement(self.m_root, "spineOpen_WndEightYear", WZUISpine)
	local spineWaitOpen = GetElement(self.m_root, "spineWaitOpen_WndEightYear", WZUISpine)
	aniIndex = aniIndex or 1
	WZLog("WndEightYear:_setBowlingPlayAni", aniIndex, bLoop)

	if spineOpen then
		if aniIndex == 1 then 
			spineWaitOpen:setVisible(true)
			spineWaitOpen:play(self.m_tBallAniName[self.m_nCalabashType + 1][aniIndex], bLoop ~= nil and bLoop or true)
		else
			spineOpen:setVisible(true) 
			spineOpen:play(self.m_tBallAniName[self.m_nCalabashType + 1][aniIndex], bLoop ~= nil and bLoop or true)
		end
	end
end

--@brief 	鱼移出屏幕后，删除动画
function WndEightYear:afterAni(element)
	local spineWaitOpen = GetElement(self.m_root, "spineWaitOpen_WndEightYear", WZUISpine)
	element:disableSchedule()
	element:setVisible(false)
	spineWaitOpen:setVisible(true)

	self:showShootReward()
	self:setOpenState(false)
end

--@brief 	播放露营动画后
function WndEightYear:waitHide(element)
	local spineWaitOpen = GetElement(self.m_root, "spineWaitOpen_WndEightYear", WZUISpine)
	spineWaitOpen:disableSchedule()
	spineWaitOpen:setVisible(false)
end

--@brief 	刷新赛事礼包的信息
function WndEightYear:showBagGiftInfo()
	-- body
	if self.m_nGiftRewardNum > 0 then 
		GetElement(self.m_root, "imgReddotNum_WndEightYear", WZUIImage):setVisible(true)
		GetElement(self.m_root, "txtGiftNum_WndEightYear", WZUILabelTTF):setText(self.m_nGiftRewardNum)
	else
		GetElement(self.m_root, "txtGiftNum_WndEightYear", WZUILabelTTF):setText("0")
		GetElement(self.m_root, "imgReddotNum_WndEightYear", WZUIImage):setVisible(false)
	end
end

--@brief 	显示左边活动列表
function WndEightYear:createLeftBtn()
	self.m_tActivityList = {}
	local tTempTitle1 = {}
	local tTempTitle2 = {}
	for i = 1, #self.m_tTempList do
		local isTempOpen = g_cityExtenInfo ~= nil and g_cityExtenInfo["activity" .. self.m_tTempList[i]] ~= nil and g_cityExtenInfo["activity" .. self.m_tTempList[i]] ~= 0
		if isTempOpen then
			table.insert(self.m_tActivityList, self.m_tTempList[i])
			table.insert(tTempTitle1, LocalStrings.EIGHTYEAR_TEXT1[34][i])
			table.insert(tTempTitle2, LocalStrings.EIGHTYEAR_TEXT1[35][i])
		end
	end

	for i = 1, #self.m_tActivityList do
		GetElement(self.m_root, "checkBox" .. i .. "_WndEightYear", WZUICheckBox):setVisible(true)
		GetElement(self.m_root, "txtCheckBox" .. i .. "0_WndEightYear", WZUILabelTTF):setText(tTempTitle1[i])
		GetElement(self.m_root, "txtCheckBox" .. i .. "1_WndEightYear", WZUILabelTTF):setText(tTempTitle2[i])
		GetElement(self.m_root, "txtCheckBox" .. i .. "0Sel_WndEightYear", WZUILabelTTF):setText(tTempTitle1[i])
		GetElement(self.m_root, "txtCheckBox" .. i .. "1Sel_WndEightYear", WZUILabelTTF):setText(tTempTitle2[i])
	end

	self:showRedDot()

	self:onClickTab(1)
end

--@brief 	显示周年庆典任务
function WndEightYear:_showYearTask()
	self:_initActivityTime()

	local tbTaskList = GetElement(self.m_root, "tbTaskList_WndEightYear", WZUITableContainer)
	tbTaskList:cleanTable()

	self.m_tDayTaskItemCell = {}
	local count = getnTableCount(self.m_tTaskData)
	taskTableSort(self.m_tTaskData)

	for i = 1, count do
		local element, tLuaObj = CellEightYearTaskItem:createElement()
		if element and tLuaObj then 
			element:setTag(i - 1)
			element:setVisible(true)
			self.m_tDayTaskItemCell[i] = tLuaObj
			tLuaObj:setGiftBuyMessage(i, self.m_tTaskData[i])
			tbTaskList:setCellElement(element)
		end
	end
end

--@brief 	显示制作蛋糕
function WndEightYear:_showMakeCake()
	for i = 1, #self.m_tMakeCost do
		local conMaterial = GetElement(self.m_root, "conMaterial" .. i .. "_conActivity2", WZUIContainer)
		local txtMaterialName = GetElement(self.m_root, "txtMaterialName" .. i .. "_conActivity2", WZUILabelTTF)
		txtMaterialName:setText(GDatatab_item["id_" .. self.m_tMakeCost[i][1]].name)

		local element, tNewObj = CellGoodItem:createElement()
		if element and tNewObj then 
			tNewObj:setCellGoodLocalId(self.m_tMakeCost[i][1], self.m_tMakeCost[i][2], 15)
			tNewObj:setItemClickFun(self, self.onItemClick)
			element:setScale(0.7)

			conMaterial:addChild(element)
		end
	end

	self:_showMakeCost()
	self:_updateLightNum()
end

--@brief 	显示制作消耗
function WndEightYear:_showMakeCost()
	local btnMake = GetElement(self.m_root, "btnMake_WndEightYear", WZUIButton)

	local bIsCanMake = true 
	for i = 1, #self.m_tMakeCost do
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_tMakeCost[i][1])
		local costNum = self.m_nNum * self.m_tMakeCost[i][2]

		if nLightNum < costNum then 
			WZLog("WndEightYear:_showMakeCost", nLightNum, self.m_nNum, self.m_tMakeCost[i][1], self.m_tMakeCost[i][2])
			bIsCanMake = false 
			break
		end
	end

	btnMake:setTouchEnable(bIsCanMake)
end

--@brief 	显示制作蛋糕-兑换列表
function WndEightYear:_showExchangeList()
	local tbExchangeList = GetElement(self.m_root, "tbExchangeList_conActivity2", WZUITableContainer)
	tbExchangeList:cleanTable()
	self.m_tCellExchange = {}

	for i = 1, #self.m_tLibraryData do
		local element, tNewObj = CellEightYearExchange:createElement()
		if element and tNewObj then 
			element:setVisible(true)
			element:setTag(i - 1)
			tNewObj:setData(self.m_tLibraryData[i])

			tbExchangeList:setCellElement(element)

			table.insert(self.m_tCellExchange, tNewObj)
		end
	end
end

--@brief 	刷新兑换按钮状态
function WndEightYear:_updateExchangeBtnState(ownNum)
	if self.m_nActivityId == g_cityExtenInfo.activity7122 and self.m_tCellExchange then 
		for i = 1, #self.m_tCellExchange do
			self.m_tCellExchange[i]:updateBtnState(ownNum)
		end
	end
end

--@brief 	显示刷新消耗
function WndEightYear:_showFreshBtn()
	local ftxtOrderFresh = GetElement(self.m_root, "ftxtOrderFresh_conActivity4", WZUIFreeTextBox)
	local basicInfo = GDatatab_item["id_" .. self.m_tContent.costConfig[1]]
	local sFormat = [[<I Z="0.5" P="1">%s</I><T C="255,250,236" S="20" P="1" SC="163,74,20" SS="4" SE="1">%d</T><T C="255,250,236" S="20" P="1" SC="163,74,20" SS="4" SE="1">%s</T>]]
	local nCostNum = self.m_tContent.costConfig[2] + self.m_nFreshTimes * self.m_tContent.costConfig[3]
	local strContent = string.format(sFormat, basicInfo.icon, nCostNum, LocalStrings.REFRESH)
	ftxtOrderFresh:setShowText(strContent)
end

--@brief 	显示拼单界面
function WndEightYear:_showGoodsList()
	local nTotalCount = #self.m_tGoodsData
	self.m_nAllPage = math.ceil(nTotalCount/2)
	if self.m_nPageIndex == nil then 
		self.m_nPageIndex = 1 
	end
--	WZLog("WndEightYear:_showGoodsList", Serialize(self.m_tGoodsData))
	self:_showGoods()
end

--@brief 	显示商品
function WndEightYear:_showGoods()
	for i = 1, 2 do
		local conGoods = GetElement(self.m_root, "conGoods" .. i .. "_conActivity4", WZUIContainer)

		local goodsData = self.m_tGoodsData[i + (self.m_nPageIndex - 1) * 2]
		if goodsData then 
			self:setItemMessage(conGoods, goodsData)
		end
	end

	self:_showPage()
end

function WndEightYear:setItemMessage(parentNode, data)
	--0=不可领取|1=可领取|2=已领取
	self:_setGoodsStaticText(parentNode)
	
	local btnBuy = GetElement(parentNode,"btnBuy_CellEightYearGoods",WZUIButton)
	local btnLaunch = GetElement(parentNode,"btnLaunch_CellEightYearGoods",WZUIButton)
	local btnBuild = GetElement(parentNode,"btnBuild_CellEightYearGoods",WZUIButton)
	local conHead = GetElement(parentNode, "conHead_CellEightYearGoods", WZUIContainer)
	local orderCount = #data.orderInfo
	if orderCount > 0 then 
		btnBuy:setVisible(true)
		btnLaunch:setVisible(true)
		conHead:setVisible(false)
		btnBuild:setVisible(false)
	elseif orderCount == 0 then 
		btnBuy:setVisible(false)
		btnLaunch:setVisible(false)
		btnBuild:setVisible(true)
		conHead:setVisible(true)
	end
	GetElement(parentNode,"imgGoodsIcon_CellEightYearGoods",WZUIImage):setFile(GDatatab_item["id_" .. data.itemId].icon)
	GetElement(parentNode,"txtHavedLaunch_CellEightYearGoods",WZUILabelTTF):setText(string.format(LocalStrings.EIGHTYEAR_TEXT1[11], data.times))
	local ownNum = CacheCenter:getPlayerItemCountById(data.costId)
	GetElement(parentNode,"txtBuyPrice_CellEightYearGoods",WZUILabelTTF):setText(data.price)
	GetElement(parentNode,"txtLaunchPrice_CellEightYearGoods",WZUILabelTTF):setText(data.discountPrice)
	GetElement(parentNode,"txtNum_CellEightYearGoods",WZUILabelTTF):setText("X" .. data.itemNum)
	
	local tbOrderList = GetElement(parentNode, "tbOrderList_CellEightYearGoods", WZUITableContainer)
	tbOrderList:cleanTable()

	WZLog("WndEightYear:setItemMessage 11", orderCount)
	if orderCount > 0 then 
		for i = 1, orderCount do
			local element, tNewObj = CellEightYearOrder:createElement()
			if element and tNewObj then 
				element:setTag(i - 1)
				tNewObj:setData(data.orderInfo[i], data)

		        tbOrderList:setCellElement(element)
			end
		end
	end
end

--@brief 	设置静态文本
function WndEightYear:_setGoodsStaticText(parentNode)
	GetElement(parentNode, "txtBuy_CellEightYearGoods", WZUILabelTTF):setText(LocalStrings.EIGHTYEAR_TEXT1[16])
	GetElement(parentNode, "txtLaunch_CellEightYearGoods", WZUILabelTTF):setText(LocalStrings.EIGHTYEAR_TEXT1[15])
	GetElement(parentNode, "txtBuild_CellEightYearGoods", WZUILabelTTF):setText(LocalStrings.EIGHTYEAR_TEXT1[17])

	WZLog("WndEightYear:_setGoodsStaticText")
	local conHead = GetElement(parentNode, "conHead_CellEightYearGoods", WZUIContainer)
	local headEffectId = CacheCenter:getPlayerHeadEffectItemId()
	local sex = CacheCenter:getPlayerInfo().sex
	local headColor, bodyColor= CacheCenter:getHeadAndBodyColor()
	local tEquip = CacheCenter:getEquipedDecorationList()
	local headId, faceId = nil, nil
	for i = 1, #tEquip do
		local nEquipId = tEquip[i]
		if nEquipId ~= nil then
			if type(nEquipId) == "table" then nEquipId = nEquipId.id end
		    local tEquipData = GetItemLocalData(nEquipId)

		    if tEquipData then
		        local maintype = tEquipData.main_type
		        local subtype = tEquipData.sub_type
		        if maintype == 5 and subtype == 1 then --物品是否是脸谱
		            faceId = (tEquipData.animation_index_code)
		        elseif maintype == 5 and subtype == 0 then -- 物品是否是头部 
		            headId = (tEquipData.animation_index_code)
		        end
		    end
		end
    end

    local gameParam = CacheCenter:getGameParam()
    if sex == 0 then
        if headId == nil then headId = GDatatab_item["id_"..(gameParam.defaultManHeadId or 4903)].animation_index_code end
        if faceId == nil then faceId = GDatatab_item["id_"..(gameParam.defaultManFaceId or  4902)].animation_index_code end
    else
        if headId == nil then headId = GDatatab_item["id_"..(gameParam.defaultWomanHeadId or 4906)].animation_index_code end
        if faceId == nil then faceId = GDatatab_item["id_"..(gameParam.defaultWomanFaceId or 4905)].animation_index_code end
    end
	CellHead:show(conHead, headId, faceId, sex,nil,nil, CacheCenter:getPlayerInfo().vipLevel, headColor, nil, nil,nil, nil, headEffectId)
end

--@brief 	显示当前页码
function WndEightYear:_showPage()
	local txtPage = GetElement(self.m_root, "txtPage_conActivity4", WZUILabelTTF)
	if txtPage then 
		txtPage:setText(self.m_nPageIndex .. "/" .. self.m_nAllPage)
	end
end

--@brief 	刷新图鉴
function WndEightYear:updateCatchFishLibrary(id, status, buyNum, dayBuyNum)
	if self.m_root == nil then return end 

	for i = 1, #self.m_tCellExchange do
		local tData = self.m_tCellExchange[i]:getData()
		if tData and tData.id == id then 
			tData.status = status 
			tData.buyNum = buyNum 
			if tData.dayBuyNum then 
				tData.dayBuyNum = dayBuyNum
			end
			self.m_tCellExchange[i]:resetData(tData)
		end
	end
end

--@brief 	显示其他玩家拼单
function WndEightYear:_showOtherOrder(tData, goodData)
	GetElement(self.m_root, "conOtherOrder_WndEightYear", WZUIContainer):setVisible(true)

	local txtTitle = GetElement(self.m_root, "txtTitle_conOtherOrder", WZUILabelTTF)
	local ftxtAtt = GetElement(self.m_root, "ftxtAtt_conOtherOrder", WZUIFreeTextBox)
	local ftxtBtn = GetElement(self.m_root, "ftxtBtn_conOtherOrder", WZUIFreeTextBox)
	local conHead = GetElement(self.m_root, "conHead1_conOtherOrder", WZUIContainer)
	self.m_tBuyData = tData

	txtTitle:setText(string.format(LocalStrings.EIGHTYEAR_TEXT1[26], tData.playerName))
	ftxtAtt:setShowText(LocalStrings.EIGHTYEAR_TEXT1[27])

	CellHead:show(conHead, tData.headId, tData.faceId, tData.sex, nil, nil, tData.vipLevel, tData.headColor, nil, nil, nil, nil, tData.headEffectId)

	local sFormat = [[<I Z="0.5" P="1">%s</I><T C="157,83,42" S="18" P="1" SC="163,74,20" SS="4" SE="0">%d</T><T C="132,66,29" S="18" P="1" SC="163,74,20" SS="4" SE="0">%s</T>]]
	local strContent = string.format(sFormat, GDatatab_item["id_" .. goodData.costId].icon, goodData.discountPrice, LocalStrings.EIGHTYEAR_TEXT1[25])
	ftxtBtn:setShowText(strContent)
end

--@brief 	显示支付界面
function WndEightYear:_showPay(tData)
	GetElement(self.m_root, "conPay_WndEightYear", WZUIContainer):setVisible(true)
	local ftxtBtn = GetElement(self.m_root, "ftxtBtn_conPay", WZUIFreeTextBox)
	self.m_tBuyData = tData

	local conItem = GetElement(self.m_root, "conItem_conPay", WZUIContainer)
	local element, tNewObj = CellGoodItem:createElement()
	if element and tNewObj then 
		tNewObj:setCellGoodLocalId(tData.itemId, tData.itemNum, 17)
		tNewObj:setItemClickFun(self, self.onItemClick)

		conItem:addChild(element)
	end

	local sFormat = [[<I Z="0.5" P="1">%s</I><T C="157,83,42" S="18" P="1" SC="163,74,20" SS="4" SE="0">%d</T><T C="132,66,29" S="18" P="1" SC="163,74,20" SS="4" SE="0">%s</T>]]
	local strContent = string.format(sFormat, GDatatab_item["id_" .. tData.costId].icon, tData.discountPrice, LocalStrings.EIGHTYEAR_TEXT1[24])
	ftxtBtn:setShowText(strContent)
end

--@brief 	刷新拼单界面
function WndEightYear:_updateOrder()
	self:_updateLightNum()
end

--@brief 	显示拼单列表
function WndEightYear:_showMyOrderList()
	GetElement(self.m_root, "conOrderInfo_WndEightYear", WZUIContainer):setVisible(true)

	local tbMyOrderList = GetElement(self.m_root, "tbMyOrderList_conOrderInfo", WZUITableContainer)
	tbMyOrderList:cleanTable()

	for i = 1, #self.m_tMyOrderData do
		local element, tNewObj = CellEightYearOrderItem:createElement()
		if element and tNewObj then 
			element:setVisible(true)
			element:setTag(i - 1)
			tNewObj:setData(self.m_tMyOrderData[i])

			tbMyOrderList:setCellElement(element)
		end
	end
end
-------------------------------------私有方法模块End----------------------------------------

--@brief	越南适配
function WndEightYear:_adaptLanguage_vn()
	for i = 1, 4 do
		local txtCheckBox0Nor = GetElement(self.m_root, "txtCheckBox" .. i .. "0_WndEightYear", WZUILabelTTF)
		txtCheckBox0Nor:setFontSize(18)
		txtCheckBox0Nor:setDimensions(GlobalMethod:CCSize(100,0))
		local txtCheckBox1Nor = GetElement(self.m_root, "txtCheckBox" .. i .. "1_WndEightYear", WZUILabelTTF)
		txtCheckBox1Nor:setFontSize(18)
		txtCheckBox1Nor:setDimensions(GlobalMethod:CCSize(100,0))
		local txtCheckBox0Sel = GetElement(self.m_root, "txtCheckBox" .. i .. "0Sel_WndEightYear", WZUILabelTTF)
		txtCheckBox0Sel:setFontSize(18)
		txtCheckBox0Sel:setDimensions(GlobalMethod:CCSize(100,0))
		local txtCheckBox1Sel = GetElement(self.m_root, "txtCheckBox" .. i .. "1Sel_WndEightYear", WZUILabelTTF)
		txtCheckBox1Sel:setFontSize(18)
		txtCheckBox1Sel:setDimensions(GlobalMethod:CCSize(100,0))
	end

	local txtBtnOpenOne = GetElement(self.m_root, "txtBtnOpenOne_WndEightYear", WZUILabelTTF)
	txtBtnOpenOne:setFontSize(18)
	local txtBtnOpenFive = GetElement(self.m_root, "txtBtnOpenFive_WndEightYear", WZUILabelTTF)
	txtBtnOpenFive:setFontSize(18)


	local conGoods1 = GetElement(self.m_root, "conGoods1_conActivity4", WZUIContainer)
	local txtBuild = GetElement(conGoods1, "txtBuild_CellEightYearGoods", WZUILabelTTF)
	txtBuild:setDimensions(GlobalMethod:CCSize(120,0))
	local conGoods2 = GetElement(self.m_root, "conGoods2_conActivity4", WZUIContainer)
	local txtBuild = GetElement(conGoods2, "txtBuild_CellEightYearGoods", WZUILabelTTF)
	txtBuild:setDimensions(GlobalMethod:CCSize(120,0))

	GetElement(self.m_root, "txtTitle_conOrderInfo", WZUILabelTTF):setFontSize(16)
	GetElement(self.m_root, "ftxtBtn_conPay", WZUIFreeTextBox):setScale(0.8)
end