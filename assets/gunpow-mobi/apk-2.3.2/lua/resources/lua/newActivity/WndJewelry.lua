--WndJewelry.lua
--@brief	WndJewelry的UI模块
--@date		2024/01/16
--@author	XTX
--@note		首饰大师活动主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndJewelry:onEnter(element)
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
function WndJewelry:onExit(element)
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
function WndJewelry:onEnterTransitionDidFinish(element)
    WZLog("WndJewelry:onEnterTransitionDidFinish")
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7111, 7111)

	local tData = {pool = 3}
	local strJson = json.encode(tData)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7111, 2, strJson)
end

--@brief    关闭窗口
function WndJewelry:onCloseClick(element)
	local eleType = type(element)
	if eleType ~= "number" then 
    	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    end

	SaveActivityPoleType("JEWELRY", self.m_nCalabashType)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮回调
function WndJewelry:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 	
    WndSingleMapDesc:showInterface(LocalStrings.JEWELRY_TEXT2)
end

--@brief 	点击目标按钮回调
function WndJewelry:onClickTask(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if SystemTime:getServerTime() >= self.m_nEndTime then 
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END) 
		self:onCloseClick(0)
		return 
	end 

	local nTag = element:getTag()
	if nTag == 1 then 
		local otherData = {}
		otherData.taskCount = 2 --几个任务标签
		otherData.tTaskTypeName = {LocalStrings.JEWELRY_TEXT1[10], LocalStrings.JEWELRY_TEXT1[11]} --任务标签名字
		otherData.taskTitle = LocalStrings.JEWELRY_TEXT1[2]
		otherData.taskType = 2
		otherData.redPoint = {117111, 127111} --长线；日常；每天
		CellNewYearTask:showInterface(60, self.m_nActivityId, otherData)
	elseif nTag == 3 then 
		local otherData = {}
		otherData.type = 1
		otherData.strRankTitleName = LocalStrings.JEWELRY_TEXT1[3]
		otherData.strCountLabel = string.format(LocalStrings.NEWYEAR_TEXT15,100)
		otherData.strChangeTitle = LocalStrings.JEWELRY_TEXT1[18]
		otherData.strScoreTitle = LocalStrings.JEWELRY_TEXT1[18] .. ":"

		WndShopRank:showInterface(90, self.m_nActivityId, nil, nil, otherData) 
	elseif nTag == 4 then --全民采茶
		self:onClickGift(element)
	end
end

--@brief 	点击大奖预览按钮回调
function WndJewelry:onClickBigReward(element)
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
function WndJewelry:onClickFive(element) 
	if SystemTime:getServerTime() >= self.m_nEndTime then 
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END) 
		self:onCloseClick(0)
		return 
	end 
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if nTag == 5 then 
		if self.m_nAniType == 2 then 
			self.m_nAniType = 1
		else
			self.m_nAniType = 2
		end
		local btnFile = {"ui/activity/common_btn_51.png", "ui/activity/common_btn_52.png"}
		local btnWordsStrokeColor = {GlobalMethod:ccc3(163,74,20), GlobalMethod:ccc3(255,255,255)}
		local imgOpenBtn = GetElement(self.m_root, "imgOpenOneBtn_WndJewelry", WZUIImage)
		local txtBtnOpenOne = GetElement(self.m_root, "txtBtnOpenOne_WndJewelry", WZUILabelTTF)
		imgOpenBtn:setFile(btnFile[self.m_nAniType])
		txtBtnOpenOne:setColor(btnWordsStrokeColor[self.m_nAniType])
		self:_setFreeBtnText()
		return 
	end
	--背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
    if self.m_bOpenState then MsgBoxManager:showTipBox(LocalStrings.JEWELRY_TEXT1[19]) return end 
    if self.m_nChooseReward == 0 then 
    	self:onClickBigReward(0)

		self.m_nChooseReward = 1
		SaveOperateTimes("JEWELRYACTIVITYID", self.m_nActivityId)
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
	if self.m_nAniType == 2 then 
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
	tData.pool = self.m_nCalabashType

	local stringData = json.encode(tData)

	self:setOpenState(true)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 3, stringData)
end

--@brief 	前往小推车购买
function WndJewelry:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

--@brief 	点击切换浪板类型
function WndJewelry:onChooseTool(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local nTag = element:getTag()
	if self.m_bOpenState then 
		GetElement(self.m_root, "cbgTool_WndJewelry", WZUICheckBoxGroup):setCheckIndex(self.m_nCalabashType)
		return 
	end 
	if self.m_nCalabashType == nTag then return end 

	self.m_nCalabashType = nTag
	self:_setFreeBtnText()
	self:_setBowlingPlayAni(1, true)
end

--@brief	点击物品弹出对应的tips
function WndJewelry:onItemClick(tCell,tag,tData)
    if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData,false)
end

--@brief 	关闭捕鼠奖励界面
function WndJewelry:onCloseTip(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	GetElement(self.m_root, "conLvReward_WndJewelry", WZUIContainer):setVisible(false)
	self:showRedDot()
end

--@brief 	点击全民采茶按钮回调
function WndJewelry:onClickGift(element)
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
		tData.txtTitle = string.format(LocalStrings.JEWELRY_TEXT1[9], self.m_nGiftRewardConfig)
		tData.nType = 2
		WndTips:show(element, self.m_root, 52, tData, GlobalMethod:ccp(200,80), true)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndJewelry:_update()
	-- body
	self:_setFreeBtnText()
	self:showRedDot()
	self:_initActivityTime()
    self:_updateLightNum()
    self:showBagGiftInfo()
    self:_showFiveKey()
end

--@brief 	初始化静态文本
function WndJewelry:_initStaticText()
	self.m_nCalabashType = GetActivityPoleType("JEWELRY")
	if self.m_nCalabashType ~= 0 then 
		GetElement(self.m_root, "cbgTool_WndJewelry", WZUICheckBoxGroup):setCheckIndex(self.m_nCalabashType)
	end

	GetElement(self.m_root, "txtBtnTask1_WndJewelry", WZUILabelTTF):setText(LocalStrings.JEWELRY_TEXT1[2])
	GetElement(self.m_root, "txtFiveTitle_WndJewelry", WZUILabelTTF):setText(LocalStrings.JEWELRY_TEXT1[8])
	GetElement(self.m_root, "txtBtnTask3_WndJewelry", WZUILabelTTF):setText(LocalStrings.JEWELRY_TEXT1[3])
	GetElement(self.m_root, "txtBtnTask4_WndJewelry", WZUILabelTTF):setText(LocalStrings.JEWELRY_TEXT1[22])
	GetElement(self.m_root, "txtBigReward_WndJewelry", WZUILabelTTF):setText(LocalStrings.WATERMELON_TEXT1[22])
	GetElement(self.m_root, "txtActivityWord_WndJewelry", WZUILabelTTF):setText(LocalStrings.ACTIVE_TIME .. ":")
	GetElement(self.m_root, "txtFiveAtt_WndJewelry", WZUILabelTTF):setText(LocalStrings.JEWELRY_TEXT1[17])
	GetElement(self.m_root, "txtFiveRewardTitle_WndJewelry", WZUILabelTTF):setText(LocalStrings.JEWELRY_TEXT1[15])

	self:_setBallAni()
end

--@brief 	红点
function WndJewelry:showRedDot()
	-- body
	if self.m_root == nil then return end 

	local imgTaskRedDot = GetElement(self.m_root, "imgTaskRedDot_WndJewelry", WZUIImage)

	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[117111] or GlobalGame.g_tRedPointTypeList[127111]) then 
		imgTaskRedDot:setVisible(true)
	else
		imgTaskRedDot:setVisible(false)
	end
end

--@brief 	更新异火的数量
function WndJewelry:_updateLightNum()
	-- body
	local ftxtLightNum = GetElement(self.m_root, "ftxtLightNum_WndJewelry", WZUIFreeTextBox)
	local sFormat = [[<I Z="0.45" P="1">%s</I><T C="255,255,255" S="18" P="1" SC="163,74,20" SS="4" SE="1">%d</T>]]
	if ftxtLightNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
		ftxtLightNum:setShowText(string.format(sFormat, basicData.icon, nLightNum))
	end
end

--@brief 	初始化活动时间
function WndJewelry:_initActivityTime()
	-- body
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndJewelry", WZUILabelTTF)
    if txtActivityTime then 
    	txtActivityTime:setText(needDay_str)
    end
end

--@brief 	显示开启动画
function WndJewelry:showOpenAction()
	-- body
	local spineOpen = GetElement(self.m_root, "spineOpen_WndJewelry", WZUISpine)
	local spinePath = "activity/hd_pic_shoushidashi"
	local existSpine = CheckEffectFile(spinePath)
	
	if spineOpen then 
		if existSpine then 
			self:_setBowlingPlayAni(self.m_nAniType + 1, false)
			spineOpen:enableSchedule("afterAni", 1.3)
		else
			self:showShootReward()
			self:setOpenState(false)
		end
	end
end

--@brief 	显示开启奖励
function WndJewelry:showShootReward()
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
		strContent = strContent .. LocalStrings.JEWELRY_TEXT1[18] .. "+" .. self.m_tOpenResult.addExp
	end

	if strContent ~= "" then 
		MsgBoxManager:showTipBox(strContent, nil, nil, nil, nil, nil, nil, nil, nil, GlobalMethod:ccp(0.5, 0.77))
	end

	self:_showFiveKey()
	self:_afterCloseReward()
end

--@brief 	iphoneX适配
function WndJewelry:_adaptIphoneX()
	if IsIphoneX() then
		GetElement(self.m_root, "conLeftMenu_WndJewelry", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.97,0))
		GetElement(self.m_root, "conFiveKey_WndJewelry", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.96,0.494))
	end
end

--@brief 	设置免费丢
function WndJewelry:_setFreeBtnText()
	local txtBtnOpenOne = GetElement(self.m_root, "txtBtnOpenOne_WndJewelry", WZUILabelTTF)

	local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local freeTimes = 0 
	local nTempTimes = math.floor(nLightNum/self.m_tCostByType[self.m_nCalabashType + 1])
	local nTimes = 0
	local strTemp = LocalStrings.JEWELRY_TEXT1[7]
	local nMileToTimes = self.m_nMaxLotteryCount

	if self.m_nAniType == 1 then 
		if self.m_nCalabashType == 0 then 
			if self.m_nCount > 0 then 
				freeTimes = 1
				txtBtnOpenOne:setText(LocalStrings.JEWELRY_TEXT1[6])
			else 
				txtBtnOpenOne:setText(string.format(strTemp, 1))
			end
		else
			txtBtnOpenOne:setText(string.format(strTemp, 1))
		end
	else
		nTimes = (nTempTimes + freeTimes) >= self.m_nMaxLotteryCount and self.m_nMaxLotteryCount or nTempTimes > 0 and (nTempTimes + freeTimes) or self.m_nMaxLotteryCount 

		txtBtnOpenOne:setText(string.format(strTemp, nTimes))
	end
end

--@brief 	设置待机特效
function WndJewelry:_setBallAni()
	local spinePath = "activity/hd_pic_shoushidashi"
	local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".json")
	if existSpine then 
		existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".atlas")
	end
	if existSpine then 
		local spineOpen = GetElement(self.m_root, "spineOpen_WndJewelry", WZUISpine)
		if spineOpen then 
			spineOpen:setFileJson(spinePath .. ".json")
			spineOpen:setFileAtlas(spinePath .. ".atlas")
			self:_setBowlingPlayAni(1, true)
		end
		local spineWait = GetElement(self.m_root, "spineWait_WndJewelry", WZUISpine)
		if spineWait then 
			spineWait:setFileJson(spinePath .. ".json")
			spineWait:setFileAtlas(spinePath .. ".atlas")
			spineWait:play("wait_effects", true)
		end
	end
end

function WndJewelry:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndJewelry:downloadEffectCallback",taskId,extraData,failed)
    self:_setBallAni()
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndJewelry:_setBowlingPlayAni(aniIndex, bLoop)
	local spineOpen = GetElement(self.m_root, "spineOpen_WndJewelry", WZUISpine)
	aniIndex = aniIndex or 1
	WZLog("WndJewelry:_setBowlingPlayAni", aniIndex, bLoop)

	if spineOpen then
		spineOpen:setVisible(true) 
		spineOpen:play(self.m_tBallAniName[self.m_nCalabashType + 1][aniIndex], bLoop ~= nil and bLoop or true)
	end
end

--@brief 	鱼移出屏幕后，删除动画
function WndJewelry:afterAni(element)
	local spineOpen = GetElement(self.m_root, "spineOpen_WndJewelry", WZUISpine)
	spineOpen:disableSchedule()
	self:_setBowlingPlayAni(1, true)

	self:showShootReward()
	self:setOpenState(false)
end

--@brief 	刷新赛事礼包的信息
function WndJewelry:showBagGiftInfo()
	-- body
	if self.m_nGiftRewardNum > 0 then 
		GetElement(self.m_root, "imgGiftRed_WndJewelry", WZUIImage):setVisible(true)
		GetElement(self.m_root, "txtGiftNum_WndJewelry", WZUILabelTTF):setText(self.m_nGiftRewardNum)
	else
		GetElement(self.m_root, "imgGiftRed_WndJewelry", WZUIImage):setVisible(false)
	end
end

--@brief 	显示五音
function WndJewelry:_showFiveKey()
	if self.m_tCellFiveKey == nil then self.m_tCellFiveKey = {} end 

	local makingId = nil 
	for i = 1, 5 do
		local num = CacheCenter:getPlayerItemCountById(self.m_tItemList[i])
		local conItem = GetElement(self.m_root, "conItem" .. i .. "_WndJewelry", WZUIContainer)
		local imgGet = GetElement(conItem, "imgGet_WndJewelry", WZUIImage)
		if self.m_tCellFiveKey[i] == nil then 
			if conItem:getChildByTag(88) then 
				conItem:removeChildByTag(88, true)
			end
			local element, tNewObj = CellGoodItem:createElement()
			if element and tNewObj then 
				tNewObj:setCellGoodLocalId(self.m_tItemList[i], num, 15, true)
				tNewObj:setItemClickFun(self, self.onItemClick)
				element:setTag(88)
				conItem:addChild(element)
				if num <= 0 then 
					tNewObj:setGrayRender(true)
					tNewObj:setGoodItemCount("")
					imgGet:setVisible(false)
					if makingId == nil then 
						makingId = self.m_tItemList[i]
						tNewObj:setGrayRender(false)
					end
				else
					tNewObj:setItemNumber(num)
					imgGet:setVisible(true)
				end
				self.m_tCellFiveKey[i] = tNewObj
			end
		else
			if num <= 0 then 
				self.m_tCellFiveKey[i]:setGrayRender(true)
				self.m_tCellFiveKey[i]:setGoodItemCount("")
				imgGet:setVisible(false)
				if makingId == nil then 
					makingId = self.m_tItemList[i]
					self.m_tCellFiveKey[i]:setGrayRender(false)
				end
			else
				self.m_tCellFiveKey[i]:setItemNumber(num)
				self.m_tCellFiveKey[i]:setGrayRender(false)
				imgGet:setVisible(true)
			end
		end
	end
	local imgMakingJewelry = GetElement(self.m_root, "imgMakingJewelry_WndJewelry", WZUIImage)
	if imgMakingJewelry then 
		if makingId == nil then makingId = self.m_tItemList[1] end 
		local basicData = GDatatab_item["id_" .. makingId]
		imgMakingJewelry:setFile(basicData.icon)
	end
end

--@brief 	显示五音自选奖励
function WndJewelry:_showFiveKeyReward()
	local tbFiveReward = GetElement(self.m_root, "tbFiveReward_WndJewelry", WZUITableContainer)
	tbFiveReward:cleanTable()

	local reward_ids = self.m_tFiveKeyReward.reward_ids1
	local reward_nums = self.m_tFiveKeyReward.reward_nums1
	local tTempData = self.m_tFiveKeyReward
	for i = 1, #reward_ids do
		local tabItem = GDatatab_item["id_".. reward_ids[i]]
		local itemInfo = {id = tabItem.id, name=tabItem.name,icon=tabItem.icon,lastTime=reward_nums[i],quality=tabItem.quality,basicInfo=CopyTable(tabItem), index = i}
		local bVisibleLimit = false
		local strLimit = "" 
		if tTempData.leftConfig then 
			itemInfo.leftConfig = tTempData.leftConfig[i]
			bVisibleLimit, strLimit = WndJoinReward:getLimitData(itemInfo.leftConfig.soldNum, itemInfo.leftConfig.limitNum, itemInfo.leftConfig.dailyLimit, itemInfo.leftConfig.dailyBuyNum)
		end
		if tTempData.chooseState then 
			itemInfo.chooseState = tTempData.chooseState[i]
		end
		if tTempData.pool then 
			itemInfo.pool = tTempData.pool
		end
		local nType = 17 
		if tTempData.type then 
			nType = tTempData.type
			itemInfo.rootNode = self.m_root
		end
		local celElement,tCell = CellGoodItem:createElement()
		if celElement and tCell then
			tCell:setCellGoodItem(itemInfo, nType)
			celElement:setTag(i-1)
			celElement:setScale(0.8)
			tbFiveReward:setCellElement(celElement)
			if ProjConfig.LANGUAGE == "vn" then
				tTempData.chooseState = nil
			end
			if tTempData.chooseState then 
				tCell:setItemClickFun(self,self.onClickItem2)
			else
				tCell:setItemClickFun(self,self.onItemClick)
			end
			if bVisibleLimit then 
				tCell:_addNumLimit(strLimit)
			end
			if itemInfo.chooseState and itemInfo.chooseState == 1 then 
				tCell:setItemSelState(true)
			end
		end
	end
end

--@brief    点击奖励回调
function WndJewelry:onClickItem2(tCell, tag, tData)
    WZLog("WndJewelry:onClickItem2 ")
    if tData.chooseState and tData.chooseState == 0 then 
		local _, _, bIsSoldOut = WndJoinReward:getLimitData(tData.leftConfig.soldNum, tData.leftConfig.limitNum, tData.leftConfig.dailyLimit, tData.leftConfig.dailyBuyNum)
	    if bIsSoldOut then
	  	   	MsgBoxManager:showTipBox(string.format(LocalStrings.PLANETSEARCH_TEXT1[18], LocalStrings.JEWELRY_TEXT1[15], tData.basicInfo.name, tData.lastTime))
	  	   	return
	  	else
	  		self.m_tClickCell = tCell 
	  		local tTempData = {}
	  		local doType = 4
			tTempData.id = tData.index - 1
			tTempData.pool = tData.pool
	  		
			local stringData = json.encode(tTempData)
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, doType, stringData)
	   end
    elseif tData.chooseState and tData.chooseState == 1 then 
		self.m_tClickCell = tCell 
		local tTempData = {}
		local doType = 4
		tTempData.id = tData.index - 1
		tTempData.pool = tData.pool
			
		local stringData = json.encode(tTempData)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, doType, stringData)
		tCell:setItemSelState(false)
    end
end

--@brief 	选择奖励返回
function WndJewelry:chooseReturn(tag, index, status)
	if self.m_root == nil then return end 

	local tTempData = self.m_tFiveKeyReward
	tTempData.chooseState[index] = status
	self.m_tClickCell:updateChooseStateData(status)
	if status == 0 then 
		self.m_tClickCell:setItemSelState(false)
	elseif status == 1 then 
		self.m_tClickCell:setItemSelState(true)
	end
end


-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配模块Begin----------------------------------------

function WndJewelry:_adaptLanguage_vn()
	GetElement(self.m_root, "txtActivityWord_WndJewelry", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.18,0.5))
	GetElement(self.m_root, "txtBtnOpenOne_WndJewelry", WZUILabelTTF):setFontSize(22)
	local txtFiveAtt = GetElement(self.m_root, "txtFiveAtt_WndJewelry", WZUILabelTTF)
	txtFiveAtt:setScale(0.65)
	txtFiveAtt:setDimensions(GlobalMethod:CCSize(360))
	GetElement(self.m_root, "txtBtnTask1_WndJewelry", WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root, "txtBtnTask3_WndJewelry", WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root, "txtBtnTask4_WndJewelry", WZUILabelTTF):setScale(0.8)
end

-------------------------------------语言适配模块End----------------------------------------

