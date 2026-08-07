--WndChessActivities.lua
--@brief	WndChessActivities的UI模块
--@date		2023/08/16
--@author	yrd
--@note		弈仙棋


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndChessActivities:onEnter(element)
	self.m_root = element

	g_bIsShowWndDressUp = false
	g_tTempItemForLaterShow = {}
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
	ProtocolProcessorFestivalActivity:regAll6()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
	GlobalGame:getGameEventDispathcer():Add(Independent_Activity.ActivityReddot, self.showRedDot, self)

	self:_initStaticText()
	self:_updateCoinNum()

	self:showResidualPage(false)

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndChessActivities:onExit(element)
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
function WndChessActivities:onEnterTransitionDidFinish(element)
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7088, 7088)
end

--@brief    点击关闭窗口按钮
function WndChessActivities:showInterface()
	LoadNewActivityRes(true)
	local wnd = WndChessActivities:createElement()
	WindowManager:addWindow(wnd, WndChessActivities, false)
end

--@brief    点击关闭窗口按钮
function WndChessActivities:onClickClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	self:saveToolType()
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮
function WndChessActivities:onClickRule(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSingleMapDesc:showInterface(LocalStrings.CHESS_ACTIVITY_TEXT2)
end

--@brief    初始化静态文本
function WndChessActivities:_initStaticText()
	self:getToolType()
	self:_showAnimal()
	self:showRedDot()

	GetElement(self.m_root,"txtChoosePrize",WZUILabelTTF):setText(LocalStrings.WATERMELON_TEXT1[22])

	GetElement(self.m_root,"txtOperateBtn1",WZUILabelTTF):setText(LocalStrings.CHESS_ACTIVITY_TEXT1[4])
	GetElement(self.m_root,"txtOperateBtn2",WZUILabelTTF):setText(LocalStrings.CHESS_ACTIVITY_TEXT1[5])
	GetElement(self.m_root,"txtOperateBtn3",WZUILabelTTF):setText(LocalStrings.CHESS_ACTIVITY_TEXT1[6])
	GetElement(self.m_root,"txtOperateBtn4",WZUILabelTTF):setText(LocalStrings.CHESS_ACTIVITY_TEXT1[15])

	GetElement(self.m_root,"txtTool1_1",WZUILabelTTF):setText(LocalStrings.CHESS_ACTIVITY_TEXT1[16])
	GetElement(self.m_root,"txtTool1_2",WZUILabelTTF):setText(LocalStrings.CHESS_ACTIVITY_TEXT1[16])
	GetElement(self.m_root,"txtTool2_1",WZUILabelTTF):setText(LocalStrings.CHESS_ACTIVITY_TEXT1[17])
	GetElement(self.m_root,"txtTool2_2",WZUILabelTTF):setText(LocalStrings.CHESS_ACTIVITY_TEXT1[17])

	GetElement(self.m_root,"txtPageWord1_ConChessPage",WZUILabelTTF):setText(LocalStrings.CHESS_ACTIVITY_TEXT1[21])
	GetElement(self.m_root,"txtPageWord2_ConChessPage",WZUILabelTTF):setText(LocalStrings.CHESS_ACTIVITY_TEXT1[22])
	GetElement(self.m_root,"txtPageWord3_ConChessPage",WZUILabelTTF):setText(LocalStrings.CHESS_ACTIVITY_TEXT1[23])
	GetElement(self.m_root,"txtPageWord4_ConChessPage",WZUILabelTTF):setText(LocalStrings.CHESS_ACTIVITY_TEXT1[24])
	GetElement(self.m_root,"txtPageWord5_ConChessPage",WZUILabelTTF):setText(LocalStrings.CHESS_ACTIVITY_TEXT1[25])

end

--@brief 	更新许愿币的数量
function WndChessActivities:_updateCoinNum()
	local sFormat = [[<I Z="0.4" P="1">%s</I><T C="255,236,193" S="20" P="1" SC="163,74,20" SS="4" SE="0">%d</T>]]
	local basicData = GDatatab_item["id_" .. self.m_nCoinId1]
	local nNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId1)
	GetElement(self.m_root, "ftbOwnCoin", WZUIFreeTextBox):setShowText(string.format(sFormat, basicData.icon, nNum))

	local basicData = GDatatab_item["id_" .. self.m_nCoinId2]
	local nNum2 = CacheCenter:getPlayerItemCountById(self.m_nCoinId2)
	GetElement(self.m_root, "ftbOwnPageCoin", WZUIFreeTextBox):setShowText(string.format(sFormat, basicData.icon, nNum2))

	-- 红点
	local imgBtnRedDot4 = GetElement(self.m_root, "imgBtnRedDot4", WZUIImage)
	imgBtnRedDot4:setVisible(false)
	if nNum2 > 0 then
		imgBtnRedDot4:setVisible(true)
	end
end

--@brief 	初始化活动时间
function WndChessActivities:_initActivityTime()
	local tStartDate = os.date("*t", self.m_nStartTime)
	local tEndDate = os.date("*t", self.m_nEndTime)
	local sDuration = string.format(LocalStrings.ACTIVITYTIME_FORMAT, tStartDate.month, tStartDate.day, tStartDate.hour, tStartDate.min, tEndDate.month, tEndDate.day, tEndDate.hour, tEndDate.min)
	GetElement(self.m_root, "txtAcitvityTime", WZUILabelTTF):setText(LocalStrings.PEOPLE_SHOP_TEXT1.. " "..sDuration)
end

--@brief 	红点
function WndChessActivities:showRedDot()
	if self.m_root == nil then return end 

	local imgBtnRedDot1 = GetElement(self.m_root, "imgBtnRedDot1", WZUIImage)
	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[217088] or GlobalGame.g_tRedPointTypeList[227088] or GlobalGame.g_tRedPointTypeList[237088]) then 
		imgBtnRedDot1:setVisible(true)
	else
		imgBtnRedDot1:setVisible(false)
	end
end

--@brief 	刷新赛事礼包的信息
function WndChessActivities:showBagGiftInfo()
	if self.m_nGiftRewardNum > 0 then 
		GetElement(self.m_root, "imgBtnRedDot2", WZUIImage):setVisible(true)
		GetElement(self.m_root, "txtBtnRedDot2", WZUILabelTTF):setText(self.m_nGiftRewardNum)
	else
		GetElement(self.m_root, "imgBtnRedDot2", WZUIImage):setVisible(false)
	end
end


--@brief 	点击选择瓶子按钮回调
function WndChessActivities:onClickChooseTool(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nIndex = GetElement(self.m_root, "cbgTools", WZUICheckBoxGroup):getCheckIndex()
	if self.m_nDrawToolType == nIndex then
		return
	end

	self.m_nDrawToolType = nIndex
	self:updateDrawgBtn()
	self:_playAni(0, false)
	self:_playAnotherAni(1, true)
end

--@brief 	更新许愿按钮
function WndChessActivities:updateDrawgBtn()
	for i=1, 2 do
		local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId1)
		local nTempTimes = math.floor(nArrowNum/self.m_tCostByType[self.m_nDrawToolType + 1]) --可许愿次数
		local freeCount = 0 --免费次数
		if self.m_nDrawToolType == 0 then 
			freeCount = self.m_nCount > 0 and 1 or 0 
		end
		local nTimes = self.m_tDrawNumList[i]
		local nAllTimes = nTempTimes + freeCount --可许愿次数 + 免费次数
		if nAllTimes > 0 and nAllTimes < self.m_tDrawNumList[i] then
			nTimes = nAllTimes
		end

		local txtUseTool = GetElement(self.m_root,"txtUseTool"..i,WZUILabelTTF)
		local strDraw = string.format(LocalStrings.CHESS_ACTIVITY_TEXT1[3], nTimes)
		if freeCount == 1 then
			if i == 1 then
				strDraw = LocalStrings.CHESS_ACTIVITY_TEXT1[2]
			elseif i == 2 then
				if nTempTimes == 0 then
					strDraw = string.format(LocalStrings.CHESS_ACTIVITY_TEXT1[3], self.m_tDrawNumList[i])
				end
			end
		end
		txtUseTool:setText(strDraw)
	end
end


--@brief 	设置待机特效
function WndChessActivities:_showAnimal()
	local spinePath = "activity/hd_pic_yxrenwu"
	local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".json")
	if existSpine then
		local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
		if spineOpen then
			spineOpen:setFileJson(spinePath .. ".json") 
			spineOpen:setFileAtlas(spinePath .. ".atlas")
			self:_playAni(0, false)
		end

		local spineCopy = GetElement(self.m_root, "spineCopy", WZUISpine)
		if spineCopy then
			spineCopy:setFileJson(spinePath .. ".json") 
			spineCopy:setFileAtlas(spinePath .. ".atlas")
			self:_playAnotherAni(1, true)
		end
	else
		local _sIndex = "hd_pic_yxrenwu"
		local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
		if downloadInfo then 
			DownloadManager:addDownloadTask(7088, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndChessActivities)
		end
	end

	local spinePath2 = "activity/hd_pic_yixianpang"
	local existSpine2 = WZDataFile:getInstance():checkFileExist(spinePath2 .. ".json")
	if existSpine2 then
		local spineBG = GetElement(self.m_root, "spineBg", WZUISpine)
		if spineBG then 
			spineBG:setFileJson(spinePath2 .. ".json")
			spineBG:setFileAtlas(spinePath2 .. ".atlas")
			spineBG:play("wait", true)
		end
	else
		local _sIndex = "hd_pic_yixianpang"
		local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
		if downloadInfo then 
			DownloadManager:addDownloadTask(70880, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndChessActivities)
		end
	end
end

function WndChessActivities:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndChessActivities:downloadEffectCallback",taskId,extraData,failed)
    self:_showAnimal()
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndChessActivities:_playAni(aniIndex, bLoop)
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	aniIndex = aniIndex or 0
	if aniIndex == 0 then
		spineOpen:setVisible(false)
		return
	end
	spineOpen:setVisible(true)
	bLoop = bLoop == true and true or false

	if spineOpen then 
		spineOpen:play(self.m_tClipAniName[self.m_nDrawToolType + 1][aniIndex], bLoop)
	end
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndChessActivities:_playAnotherAni(aniIndex, bLoop)
	local spineCopy = GetElement(self.m_root, "spineCopy", WZUISpine)
	aniIndex = aniIndex or 0
	if aniIndex == 0 then
		spineCopy:setVisible(false)
		return
	end
	spineCopy:setVisible(true)
	bLoop = bLoop == true and true or false

	if spineCopy then 
		spineCopy:play(self.m_tClipAniName[self.m_nDrawToolType + 1][aniIndex], bLoop)
	end
end

--@brief 	显示开启动画
function WndChessActivities:showOpenAction()
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)

	local spinePath1 = "activity/hd_pic_yxrenwu"
	local existSpine1 = WZDataFile:getInstance():checkFileExist(spinePath1 .. ".json")

	if spineOpen then 
		if existSpine1 then
			local aniIndex = self.m_nAniType + 1 
			self:_playAni(aniIndex, false)
			-- self:_playAnotherAni(0, false)
			-- local nSeconds = 60/DEFAULT_FPS
			-- spineOpen:enableSchedule("showShootReward", nSeconds)
			local nSeconds = 0
			spineOpen:enableSchedule("showShootBefore", nSeconds)
		else
			self:showShootReward()
		end
	end
end

--@brief 	显示开启奖励 处理抽奖时人物人物会闪一下问题
function WndChessActivities:showShootBefore()
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	self:_playAnotherAni(0, false)
	local nSeconds = 60/DEFAULT_FPS
	spineOpen:disableSchedule()
	spineOpen:enableSchedule("showShootReward", nSeconds)
end

--@brief 	显示开启奖励
function WndChessActivities:showShootReward()
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	spineOpen:disableSchedule()
	self:_playAni(0, false)
	self:_playAnotherAni(1, true)

	local strContent = ""
	if self.m_tOpenResult.addExp and self.m_tOpenResult.addExp > 0 then 
		strContent = strContent .. LocalStrings.CHESS_ACTIVITY_TEXT1[11] .. "+" .. self.m_tOpenResult.addExp .. "    "  
	end
	if self.m_tOpenResult.addScore and self.m_tOpenResult.addScore > 0 then 
		strContent = strContent .. LocalStrings.CHESS_ACTIVITY_TEXT1[27] .. "+" .. self.m_tOpenResult.addScore .. "    "  
	end
	if strContent ~= "" then 
		MsgBoxManager:showTipBox(strContent, nil, nil, nil, nil, nil, nil, nil, nil, GlobalMethod:ccp(0.5, 0.77))
	end

	self:setOpenState(false)
	self:_afterCloseReward()
end



--@brief 	点击"自选奖励"按钮回调
function WndChessActivities:onClickChoosePrize(element)
	local eleType = type(element)
	if eleType ~= "number" then 
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	end

	self.m_bIsOpenReward = true 

	self.m_tGetTimes = {}
	self.m_tBigRewardList = {}

	local tData1 = {pool = 0}
	local tData2 = {pool = 1}
	local tData3 = {pool = 2}
	local strJson1 = json.encode(tData1)
	local strJson2 = json.encode(tData2)
	local strJson3 = json.encode(tData3)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson1)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson2)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson3)
end

--@brief 	点击许愿按钮回调
function WndChessActivities:onClickUseTool(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	--背包已满提示
	if CacheCenter:getRemainAmount() <= 0 then
		MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
		return
	end
	if self.m_bOpenState then return end 

	if self.m_nChooseReward == 0 then 
		self:onClickChoosePrize(0)

		self.m_nChooseReward = 1
		self:saveOperateTimes()
		return 
	end

	local nTag = element:getTag()
	local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId1)
	local nTempTimes = math.floor(nArrowNum/self.m_tCostByType[self.m_nDrawToolType + 1]) --可许愿次数
	local freeCount = 0 --免费次数
	if self.m_nDrawToolType == 0 then 
		freeCount = self.m_nCount > 0 and 1 or 0 
	end
	self.m_nAniType = nTag
	local nTimes = self.m_tDrawNumList[nTag]
	local nAllTimes = nTempTimes + freeCount --可许愿次数 + 免费次数
	if nAllTimes > 0 and nAllTimes < self.m_tDrawNumList[nTag] then
		nTimes = nAllTimes
	end

	local nCostNum = nTimes * self.m_tCostByType[self.m_nDrawToolType + 1]
	if nCostNum - freeCount > nArrowNum or self.m_nAniType == 2 and nArrowNum == 0 then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId1]
		MsgBoxManager:showConfirmBox(string.format(LocalStrings.WATERCOUNTRY_TEXT4, basicData.name), self, self.goToBuy)
		return 
	end

	self.m_nTempTimes = nTimes

	self:setOpenState(true)

	local tData = {}
	tData.times = self.m_tDrawNumList[nTag]
	tData.pool = self.m_nDrawToolType
	local stringData = json.encode(tData)

	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 3, stringData)
end

--@brief 	前往小推车购买
function WndChessActivities:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

--@brief 	点击按钮回调
function WndChessActivities:onClickOperateBtn(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nTag = element:getTag()
	if nTag == 1 then
		CellNewYearTask:showInterface(36, self.m_nActivityId)
	elseif nTag == 2 then --全服奖励
		if self.m_nGiftRewardNum >= 1 then
			if CacheCenter:getRemainAmount() <= 0 then --背包已满提示
				MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
				return
			end
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 5, "")
		else
			local tData = {}
			tData.txtTitle = string.format(LocalStrings.CHESS_ACTIVITY_TEXT1[10], self.m_tContent.globalConfig[1])
			tData.nType = 2
			WndTips:show(element, self.m_root, 52, tData, GlobalMethod:ccp(70,80), true)
		end
	elseif nTag == 3 then
		WndShopRank:showInterface(54, self.m_nActivityId)
	elseif nTag == 4 then
		self:showResidualPage(true)
		self:setOpenPageState(false)

		local tData = {pool = 3}
		local strJson = json.encode(tData)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7088, 2, strJson)
	end
end



--@brief 	显示残页界面
function WndChessActivities:showResidualPage(bShow)
	GetElement(self.m_root,"conChessPage",WZUIContainer):setVisible(bShow)
end

--@brief 	点击关闭残页按钮回调
function WndChessActivities:onClickPageClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self:showResidualPage(false)
	self:setOpenPageState(false)
end


--@brief 	显示五音自选奖励
function WndChessActivities:_showFiveKeyReward()
	local tcReward = GetElement(self.m_root, "tcReward_ConChessPage", WZUITableContainer)
	tcReward:cleanTable()

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
			celElement:setScale(0.75)
			tcReward:setCellElement(celElement)
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
function WndChessActivities:onClickItem2(tCell, tag, tData)
    WZLog("WndChessActivities:onClickItem2 ")
    if tData.chooseState and tData.chooseState == 0 then 
		local _, _, bIsSoldOut = WndJoinReward:getLimitData(tData.leftConfig.soldNum, tData.leftConfig.limitNum, tData.leftConfig.dailyLimit, tData.leftConfig.dailyBuyNum)
	    if bIsSoldOut then
	  	   	MsgBoxManager:showTipBox(string.format(LocalStrings.PLANETSEARCH_TEXT1[18], LocalStrings.CHESS_ACTIVITY_TEXT1[26], tData.basicInfo.name, tData.lastTime))
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
function WndChessActivities:chooseReturn(tag, index, status)
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

--@brief	点击物品弹出对应的tips
function WndChessActivities:onItemClick(tCell,tag,tData)
    if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,WndChessActivities.m_root,1,tData,false)
end

--@brief 	更新许愿按钮
function WndChessActivities:updatePageDrawgBtn()
	local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId2)
	local nTempTimes = math.floor(nArrowNum/self.m_tCostByType[3]) --可许愿次数
	local nTimes = math.min(nTempTimes, 20)
	nTimes = math.max(nTimes, 1)

	local txtDraw = GetElement(self.m_root,"txtDraw_ConChessPage",WZUILabelTTF)
	local strDraw = string.format(LocalStrings.CHESS_ACTIVITY_TEXT1[20], nTimes)
	txtDraw:setText(strDraw)
end

--@brief 	显示额外奖励
function WndChessActivities:onPageItemClick(tCell,tag,tData)
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root, self.m_root, 1, tData, false, nil, true)
end

--@brief 	点击编写棋谱按钮回调
function WndChessActivities:onClickPageDraw(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if CacheCenter:getRemainAmount() <= 0 then --背包已满提示
		MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
		return
	end

    if self.m_bOpenPageState then return end

	local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId2)
	if nArrowNum <= 0 then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId2]
		MsgBoxManager:showTipBox(LocalStrings.CHESS_ACTIVITY_TEXT1[18])
		return 
	end

	self:setOpenPageState(true)

	local tData = {}
	tData.times = 20
	local stringData = json.encode(tData)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 6, stringData)
end

--@brief 	显示残页进度
function WndChessActivities:showPageProgress()
	local nNum = self.m_nGiftNum % self.m_tContent.giftConfig[#self.m_tContent.giftConfig]
	for i=1,#self.m_tContent.giftConfig do
		local txtPage = GetElement(self.m_root,"txtPage"..i.."_ConChessPage",WZUILabelTTF)
		local nSupNum = self.m_tContent.giftConfig[i]
		if self.m_tContent.giftConfig[i-1] then
			nSupNum = nSupNum - self.m_tContent.giftConfig[i-1]
		end
		local nProgress = math.min(nNum, nSupNum)
		nProgress = math.max(nProgress, 0)
		txtPage:setText(nProgress.."/"..nSupNum)
		nNum = nNum - nSupNum

		local imgPage = GetElement(self.m_root,"imgPage"..i.."_ConChessPage",WZUIImage)
		if nProgress > 0 then
			imgPage:setVisible(true)
		else
			imgPage:setVisible(false)
		end
	end
end

--@brief 	显示开启奖励
function WndChessActivities:showShootPageReward()
	self:setOpenPageState(false)
	self:_afterClosePageReward()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配模块Begin----------------------------------------

function WndChessActivities:_adaptLanguage_vn()
	GetElement(self.m_root,"txtTool1_1",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtTool1_2",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtTool2_1",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtTool2_2",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtUseTool1",WZUILabelTTF):setScale(0.9)
	GetElement(self.m_root,"txtUseTool2",WZUILabelTTF):setScale(0.9)
	GetElement(self.m_root,"txtPageWord1_ConChessPage",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txtPageWord2_ConChessPage",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txtPageWord3_ConChessPage",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txtPageWord4_ConChessPage",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txtPageWord5_ConChessPage",WZUILabelTTF):setScale(0.62)
end

-------------------------------------语言适配模块End----------------------------------------
