--WndGongAndDrum.lua
--@brief	WndGongAndDrum的UI模块
--@date		2023/08/02
--@author	XTX
--@note		锣鼓喧天活动主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndGongAndDrum:onEnter(element)
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
function WndGongAndDrum:onExit(element)
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
function WndGongAndDrum:onEnterTransitionDidFinish(element)
    WZLog("WndGongAndDrum:onEnterTransitionDidFinish")
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7086, 7086)

	local tData = {pool = 3}
	local strJson = json.encode(tData)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7086, 2, strJson)
end

--@brief    关闭窗口
function WndGongAndDrum:onCloseClick(element)
	local eleType = type(element)
	if eleType ~= "number" then 
    	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    end

	self:savePoleType()
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮回调
function WndGongAndDrum:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 	
	WndSingleMapDesc:showInterface1(LocalStrings.GONGANDDRUM_TEXT2) 
end

--@brief 	点击目标按钮回调
function WndGongAndDrum:onClickTask(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if SystemTime:getServerTime() >= self.m_nEndTime then 
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END) 
		self:onCloseClick(0)
		return 
	end 

	local nTag = element:getTag()
	if nTag == 1 then 
		CellNewYearTask:showInterface(33, self.m_nActivityId)
	elseif nTag == 2 then
		self:onClickGift(element)
	elseif nTag == 3 then 
		WndShopRank:showInterface(50, self.m_nActivityId) 
	end
end

--@brief 	点击大奖预览按钮回调
function WndGongAndDrum:onClickBigReward(element)
	-- body	
	if SystemTime:getServerTime() >= self.m_nEndTime then 
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END) 
		self:onCloseClick(0)
		return 
	end 
	local eleType = type(element)
	local nTag = 0
	if eleType ~= "number" then 
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
		nTag = element:getTag()
	else
		nTag = element
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
function WndGongAndDrum:onClickFive(element)
	-- do WndGongAndDrum:_onGetOtherData(self.m_nActivityId, 3, 1, [[{"sItemIds":[1],"nItemNums":[20000],"giftItemNums":[1],"sItemNums":[1000],"itemIds":[61004],"playerItemIds":[195,196],"count":0,"nItemIds":[2],"itemNums":[1],"fItemIds":[3],"fItemNums":[300],"giftItemIds":[160487]}]])
	-- 	WndGongAndDrum:_onGetOtherData(self.m_nActivityId, 6, 1, [[{"itemIds":[61004],"playerItemIds":[195],"itemNums":[1]}]])
	-- 	return end 
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
		self:saveOperateTimes()
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
function WndGongAndDrum:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

--@brief 	点击切换浪板类型
function WndGongAndDrum:onChooseTool(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local nTag = element:getTag()
	if self.m_bOpenState then return end 
	if self.m_nCalabashType == nTag then return end 

	self.m_nCalabashType = nTag
	self:_setFreeBtnText()
	self:_setBowlingPlayAni(1, true)
end

--@brief 	点击赛事礼包按钮回调
function WndGongAndDrum:onClickGift(element)
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
		tData.txtTitle = string.format(LocalStrings.GONGANDDRUM_TEXT1[17], self.m_tContent.globalConfig[1])
		tData.nType = 2
		WndTips:show(element, self.m_root, 52, tData, GlobalMethod:ccp(70,80), true)
	end
end

--@brief	点击物品弹出对应的tips
function WndGongAndDrum:onItemClick(tCell,tag,tData)
    if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,WndGongAndDrum.m_root,1,tData,false)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndGongAndDrum:_update()
	-- body
	self:_setFreeBtnText()
	self:showRedDot()
	self:_initActivityTime()
    self:_updateLightNum()
end

--@brief 	初始化静态文本
function WndGongAndDrum:_initStaticText()
	self:getPoleType()

	GetElement(self.m_root, "txtBtnTask1_WndGongAndDrum", WZUILabelTTF):setText(LocalStrings.GONGANDDRUM_TEXT1[2])
	GetElement(self.m_root, "txtBtnTask2_WndGongAndDrum", WZUILabelTTF):setText(LocalStrings.GONGANDDRUM_TEXT1[4])
	GetElement(self.m_root, "txtBtnTask3_WndGongAndDrum", WZUILabelTTF):setText(LocalStrings.GONGANDDRUM_TEXT1[3])
	GetElement(self.m_root, "txtBigReward_WndGongAndDrum", WZUILabelTTF):setText(LocalStrings.WATERMELON_TEXT1[22])
	GetElement(self.m_root, "txtFiveTitle_WndGongAndDrum", WZUILabelTTF):setText(LocalStrings.GONGANDDRUM_TEXT1[5])
	GetElement(self.m_root, "txtFiveAtt_WndGongAndDrum", WZUILabelTTF):setText(LocalStrings.GONGANDDRUM_TEXT1[15])
	GetElement(self.m_root, "txtFiveRewardTitle_WndGongAndDrum", WZUILabelTTF):setText(LocalStrings.GONGANDDRUM_TEXT1[18])

	self:_setBallAni()
end

--@brief 	红点
function WndGongAndDrum:showRedDot()
	-- body
	if self.m_root == nil then return end 

	local imgTaskRedDot = GetElement(self.m_root, "imgTaskRedDot_WndGongAndDrum", WZUIImage)

	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[117086] or GlobalGame.g_tRedPointTypeList[127086]) then 
		imgTaskRedDot:setVisible(true)
	else
		imgTaskRedDot:setVisible(false)
	end
end

--@brief 	更新异火的数量
function WndGongAndDrum:_updateLightNum()
	-- body
	local ftxtLightNum = GetElement(self.m_root, "ftxtLightNum_WndGongAndDrum", WZUIFreeTextBox)
	local sFormat = [[<I Z="0.5" P="1">%s</I><T C="255,250,236" S="18" P="1" SC="132,66,29" SS="4" SE="1">%d</T>]]
	if ftxtLightNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
		ftxtLightNum:setShowText(string.format(sFormat, basicData.icon, nLightNum))
	end

	self:_showFiveKey()
end

--@brief 	初始化活动时间
function WndGongAndDrum:_initActivityTime()
	-- body
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndGongAndDrum", WZUILabelTTF)
    if txtActivityTime then 
    	txtActivityTime:setText(needDay_str)
    end
end

--@brief 	显示开启动画
function WndGongAndDrum:showOpenAction()
	-- body
	local spineOpen = GetElement(self.m_root, "spineOpen_WndGongAndDrum", WZUISpine)
	local spinePath = "activity/ui_lgxt"
	local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".json")

	if spineOpen then 
		if existSpine then 
			local aniIndex = self.m_nAniType + 1 
			self:_setBowlingPlayAni(aniIndex, false)
			local nSeconds = 3
			spineOpen:enableSchedule("showShootReward", nSeconds)
		else
			self:showShootReward()
		end
	end
end

--@brief 	显示开启奖励
function WndGongAndDrum:showShootReward()
	-- body
	local spineOpen = GetElement(self.m_root, "spineOpen_WndGongAndDrum", WZUISpine)
	spineOpen:disableSchedule()
	self:_setBowlingPlayAni(1, true)

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
	end

	if strContent ~= "" then 
		MsgBoxManager:showTipBox(strContent, nil, nil, nil, nil, nil, nil, nil, nil, GlobalMethod:ccp(0.5, 0.77))
	end

	self:setOpenState(false)
	self:_afterCloseReward()
end

--@brief 	iphoneX适配
function WndGongAndDrum:_adaptIphoneX()
	if IsIphoneX() then
		GetElement(self.m_root, "conLeftTitle_WndGongAndDrum", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.525,0.5))
	end
end

--@brief 	设置免费丢
function WndGongAndDrum:_setFreeBtnText()
	local txtBtnOpenOne = GetElement(self.m_root, "txtBtnOpenOne_WndGongAndDrum", WZUILabelTTF)
	local txtBtnOpenFive = GetElement(self.m_root, "txtBtnOpenFive_WndGongAndDrum", WZUILabelTTF)

	local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local freeTimes = 0 
	local nTempTimes = math.floor(nLightNum/self.m_tCostByType[self.m_nCalabashType + 1])
	local nTimes = 0

	local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local freeTimes = 0 
	local nTempTimes = math.floor(nLightNum/self.m_tCostByType[self.m_nCalabashType + 1])
	local nTimes = 0
	local strTemp = LocalStrings.GONGANDDRUM_TEXT1[7]
	if self.m_nCalabashType == 0 then 
		if self.m_nCount > 0 then 
			freeTimes = 1
			txtBtnOpenOne:setText(LocalStrings.GONGANDDRUM_TEXT1[6])
		else 
			txtBtnOpenOne:setText(string.format(strTemp, 1))
		end
	else
		txtBtnOpenOne:setText(string.format(strTemp, 1))
	end
	nTimes = (nTempTimes + freeTimes) >= self.m_nMaxLotteryCount and self.m_nMaxLotteryCount or nTempTimes > 0 and (nTempTimes + freeTimes) or self.m_nMaxLotteryCount 
	txtBtnOpenFive:setText(string.format(LocalStrings.GONGANDDRUM_TEXT1[8], nTimes))
end

--@brief 	设置待机特效
function WndGongAndDrum:_setBallAni()
	local spinePath = "activity/ui_lgxt"
	local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".json")
	if existSpine then 
		local spineOpen = GetElement(self.m_root, "spineOpen_WndGongAndDrum", WZUISpine)
		if spineOpen then 
			spineOpen:setFileJson(spinePath .. ".json")
			spineOpen:setFileAtlas(spinePath .. ".atlas")
			self:_setBowlingPlayAni(1, true)
		end
	else
		local _sIndex = "ui_lgxt"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7086, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndGongAndDrum)
        end
	end
end

function WndGongAndDrum:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndGongAndDrum:downloadEffectCallback",taskId,extraData,failed)
    self:_setBallAni()
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndGongAndDrum:_setBowlingPlayAni(aniIndex, bLoop)
	local spineOpen = GetElement(self.m_root, "spineOpen_WndGongAndDrum", WZUISpine)
	aniIndex = aniIndex or 1
	WZLog("WndGongAndDrum:_setBowlingPlayAni", aniIndex, bLoop)

	if spineOpen then 
		spineOpen:play(self.m_tBallAniName[self.m_nCalabashType + 1][aniIndex], bLoop ~= nil and bLoop or true)
	end
end

--@brief 	刷新赛事礼包的信息
function WndGongAndDrum:showBagGiftInfo()
	-- body
	if self.m_nGiftRewardNum > 0 then 
		GetElement(self.m_root, "imgGiftRed_WndGongAndDrum", WZUIImage):setVisible(true)
		GetElement(self.m_root, "txtGiftNum_WndGongAndDrum", WZUILabelTTF):setText(self.m_nGiftRewardNum)
	else
		GetElement(self.m_root, "imgGiftRed_WndGongAndDrum", WZUIImage):setVisible(false)
	end
end

--@brief 	显示五音
function WndGongAndDrum:_showFiveKey()
	if self.m_tCellFiveKey == nil then self.m_tCellFiveKey = {} end 

	for i = 1, 5 do
		local num = CacheCenter:getPlayerItemCountById(self.m_tItemList[i])
		if self.m_tCellFiveKey[i] == nil then 
			local conItem = GetElement(self.m_root, "conItem" .. i .. "_WndGongAndDrum", WZUIContainer)
			conItem:removeAllChildrenWithCleanup(true)
			local element, tNewObj = CellGoodItem:createElement()
			if element and tNewObj then 
				tNewObj:setCellGoodLocalId(self.m_tItemList[i], num, 15, true)
				tNewObj:setItemClickFun(self, self.onItemClick)
				conItem:addChild(element)
				if num <= 0 then 
					tNewObj:setGrayRender(true)
				end
				self.m_tCellFiveKey[i] = tNewObj
			end
		else
			self.m_tCellFiveKey[i]:setItemNumber(num)
			if num <= 0 then 
				self.m_tCellFiveKey[i]:setGrayRender(true)
			else
				self.m_tCellFiveKey[i]:setGrayRender(false)
			end
		end
	end
end

--@brief 	显示五音自选奖励
function WndGongAndDrum:_showFiveKeyReward()
	local tbFiveReward = GetElement(self.m_root, "tbFiveReward_WndGongAndDrum", WZUITableContainer)
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
function WndGongAndDrum:onClickItem2(tCell, tag, tData)
    WZLog("WndGongAndDrum:onClickItem2 ")
    if tData.chooseState and tData.chooseState == 0 then 
		local _, _, bIsSoldOut = WndJoinReward:getLimitData(tData.leftConfig.soldNum, tData.leftConfig.limitNum, tData.leftConfig.dailyLimit, tData.leftConfig.dailyBuyNum)
	    if bIsSoldOut then
	  	   	MsgBoxManager:showTipBox(string.format(LocalStrings.PLANETSEARCH_TEXT1[18], LocalStrings.GONGANDDRUM_TEXT1[18], tData.basicInfo.name, tData.lastTime))
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
function WndGongAndDrum:chooseReturn(tag, index, status)
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

function WndGongAndDrum:_adaptLanguage_vn()
	local txtBtnTask1 = GetElement(self.m_root, "txtBtnTask1_WndGongAndDrum", WZUILabelTTF)
	txtBtnTask1:setDimensions(GlobalMethod:CCSize(100,0))
	txtBtnTask1:setScale(0.8)
	local txtBtnTask2 = GetElement(self.m_root, "txtBtnTask2_WndGongAndDrum", WZUILabelTTF)
	txtBtnTask2:setDimensions(GlobalMethod:CCSize(100,0))
	txtBtnTask2:setScale(0.8)
	local txtBtnTask3 = GetElement(self.m_root, "txtBtnTask3_WndGongAndDrum", WZUILabelTTF)
	txtBtnTask3:setDimensions(GlobalMethod:CCSize(100,0))
	txtBtnTask3:setScale(0.8)

	GetElement(self.m_root, "txtFiveAtt_WndGongAndDrum", WZUILabelTTF):setFontSize(14)

	GetElement(self.m_root, "txtBtnOpenOne_WndGongAndDrum", WZUILabelTTF):setFontSize(22)
	GetElement(self.m_root, "txtBtnOpenFive_WndGongAndDrum", WZUILabelTTF):setFontSize(22)
end

-------------------------------------语言适配模块End----------------------------------------
