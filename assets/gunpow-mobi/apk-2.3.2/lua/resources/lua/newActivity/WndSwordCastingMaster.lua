--WndSwordCastingMaster.lua
--@brief	WndSwordCastingMaster的UI模块
--@date		2023/12/07
--@author	yrd
--@note		铸剑神匠


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSwordCastingMaster:onEnter(element)
	self.m_root = element

	g_bIsShowWndDressUp = false
	g_tTempItemForLaterShow = {}
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
	ProtocolProcessorFestivalActivity:regAll6()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
	GlobalGame:getGameEventDispathcer():Add(Independent_Activity.ActivityReddot, self.showRedDot, self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetResult,self._onGetTaskResult,self)

	self:_initStaticText()
	self:_updateCoinNum()

	self:_adaptIphoneX()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSwordCastingMaster:onExit(element)
	g_bIsShowWndDressUp = true
	g_tTempItemForLaterShow = {}
	CacheCenter:unregisterUpatePlayerItemObserver(self)
	ProtocolProcessorFestivalActivity:unregAll6()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
	GlobalGame:getGameEventDispathcer():Remove(Independent_Activity.ActivityReddot, self.showRedDot, self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetResult,self._onGetTaskResult,self)
	if self.m_root then 
		self.m_root:disableSchedule()
	end

	self:_unInit()
	ChangeChatChannel(g_nLastChannelId_ShootArrow)
	LoadNewActivityRes(false)
end

--@brief    onenter函数已执行
function WndSwordCastingMaster:onEnterTransitionDidFinish(element)
	self.m_root:enableSchedule("_caculateTime", 1)
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7105, 7105)
end

--@brief    点击关闭窗口按钮
function WndSwordCastingMaster:showInterface()
	LoadNewActivityRes(true)
	g_nLastChannelId_ShootArrow = GlobalGame.g_nCurrentUIChannelId
	local wnd = WndSwordCastingMaster:createElement()
	WindowManager:addWindow(wnd, WndSwordCastingMaster, false)
end

--@brief    点击关闭窗口按钮
function WndSwordCastingMaster:onClickClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	self:saveToolType()
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮
function WndSwordCastingMaster:onClickRule(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSingleMapDesc:showInterface(LocalStrings.CASTING_MASTER_ACTIVITY_TEXT2)
end

--@brief    初始化静态文本
function WndSwordCastingMaster:_initStaticText()
	self:getToolType()
	self:_showAnimal()

	GetElement(self.m_root,"txtOperateBtn1",WZUILabelTTF):setText(LocalStrings.CASTING_MASTER_ACTIVITY_TEXT1[4])
	GetElement(self.m_root,"txtOperateBtn2",WZUILabelTTF):setText(LocalStrings.CASTING_MASTER_ACTIVITY_TEXT1[5])
	GetElement(self.m_root,"txtOperateBtn3",WZUILabelTTF):setText(LocalStrings.CASTING_MASTER_ACTIVITY_TEXT1[6])
	GetElement(self.m_root,"txtOperateBtn4",WZUILabelTTF):setText(LocalStrings.CASTING_MASTER_ACTIVITY_TEXT1[22])

	GetElement(self.m_root, "txtTaskTitle", WZUILabelTTF):setText(LocalStrings.CASTING_MASTER_ACTIVITY_TEXT1[26])
	GetElement(self.m_root, "txtProgWord", WZUILabelTTF):setText(LocalStrings.CASTING_MASTER_ACTIVITY_TEXT1[25])
end

--@brief 	更新许愿币的数量
function WndSwordCastingMaster:_updateCoinNum()
	local sFormat = [[<I Z="0.4" P="1">%s</I><T C="255,236,193" S="20" P="1" SC="163,74,20" SS="4" SE="0">%d</T>]]
	local basicData = GDatatab_item["id_" .. self.m_nCoinId]
	local nNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	GetElement(self.m_root, "ftbOwnCoin", WZUIFreeTextBox):setShowText(string.format(sFormat, basicData.icon, nNum))
end

--@brief 	初始化活动时间
function WndSwordCastingMaster:_initActivityTime()
	local tStartDate = os.date("*t", self.m_nStartTime)
	local tEndDate = os.date("*t", self.m_nEndTime)
	local sDuration = string.format(LocalStrings.ACTIVITYTIME_FORMAT, tStartDate.month, tStartDate.day, tStartDate.hour, tStartDate.min, tEndDate.month, tEndDate.day, tEndDate.hour, tEndDate.min)
	GetElement(self.m_root, "txtActivityTime", WZUILabelTTF):setText(LocalStrings.PEOPLE_SHOP_TEXT1.. " "..sDuration)
end

--@brief 	红点
function WndSwordCastingMaster:showRedDot()
	if self.m_root == nil then return end 

	local imgBtnRedDot1 = GetElement(self.m_root, "imgBtnRedDot1", WZUIImage)
	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[227105] or GlobalGame.g_tRedPointTypeList[217105]) then 
		imgBtnRedDot1:setVisible(true)
	else
		imgBtnRedDot1:setVisible(false)
	end

	local imgBtnRedDot2 = GetElement(self.m_root, "imgBtnRedDot2", WZUIImage)
	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[237105]) then 
		imgBtnRedDot2:setVisible(true)
	else
		imgBtnRedDot2:setVisible(false)
	end
end

--@brief 	刷新"全民许愿"礼包的信息
function WndSwordCastingMaster:showBagGiftInfo()
	if self.m_nGiftRewardNum > 0 then 
		GetElement(self.m_root, "imgGiftRed", WZUIImage):setVisible(true)
		GetElement(self.m_root, "txtGiftNum", WZUILabelTTF):setText(self.m_nGiftRewardNum)
	else
		GetElement(self.m_root, "imgGiftRed", WZUIImage):setVisible(false)
	end
end

--@brief 	点击选择瓶子按钮回调
function WndSwordCastingMaster:onClickChooseTool(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nIndex = GetElement(self.m_root, "cbgTools", WZUICheckBoxGroup):getCheckIndex()
	if self.m_nDrawToolType == nIndex then
		return
	end

	self.m_nDrawToolType = nIndex
	self:updateDrawgBtn()
	self:_playAni(1, true)
	self:_playAnotherAni(0)
end


--@brief 	设置待机特效
function WndSwordCastingMaster:_showAnimal()
	local spinePath = "activity/hd_pic_zhujian"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then
		local spineBG = GetElement(self.m_root, "spineBG", WZUISpine)
		if spineBG then 
			spineBG:setFileJson(spinePath .. ".json")
			spineBG:setFileAtlas(spinePath .. ".atlas")
			spineBG:play("wait1_1", true)
		end

		local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
		if spineOpen then
			spineOpen:setFileJson(spinePath .. ".json") 
			spineOpen:setFileAtlas(spinePath .. ".atlas")
			self:_playAni(1, true)
		end
		local spineCopy = GetElement(self.m_root, "spineCopy", WZUISpine)
		if spineCopy then
			spineCopy:setFileJson(spinePath .. ".json") 
			spineCopy:setFileAtlas(spinePath .. ".atlas")
			self:_playAnotherAni(0)
		end
	else
		local _sIndex = "hd_pic_zhujian"
		local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
		if downloadInfo then 
			DownloadManager:addDownloadTask(7105, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndSwordCastingMaster)
		end
	end
end

function WndSwordCastingMaster:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndSwordCastingMaster:downloadEffectCallback",taskId,extraData,failed)
    self:_showAnimal()
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndSwordCastingMaster:_playAni(aniIndex, bLoop)
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
function WndSwordCastingMaster:_playAnotherAni(aniIndex, bLoop)
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
function WndSwordCastingMaster:showOpenAction()
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	local spinePath1 = "activity/hd_pic_zhujian"
	local existSpine1 = CheckEffectFile(spinePath1)
	if spineOpen then 
		if existSpine1 then
			local aniIndex = self.m_nAniType + 1 
			self:_playAnotherAni(aniIndex, false)
			spineOpen:enableSchedule("showShootBefore", 0)
		else
			self:showShootReward()
		end
	end
end

--@brief 	显示开启奖励 处理抽奖时人物人物会闪一下问题
function WndSwordCastingMaster:showShootBefore()
	self:_playAni(0)
	local nSeconds = 2
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	spineOpen:disableSchedule()
	spineOpen:enableSchedule("showShootReward", nSeconds)
end

--@brief 	显示开启奖励
function WndSwordCastingMaster:showShootReward()
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	spineOpen:disableSchedule()
	self:_playAni(1, true)
	self:_playAnotherAni(0)

	local strContent = ""
	if self.m_tOpenResult.addExp and self.m_tOpenResult.addExp > 0 then 
		strContent = strContent .. LocalStrings.CASTING_MASTER_ACTIVITY_TEXT1[23] .. "+" .. self.m_tOpenResult.addExp .. "    "
	end
	if self.m_tOpenResult.addCoin and self.m_tOpenResult.addCoin > 0 then 
		strContent = strContent .. LocalStrings.CASTING_MASTER_ACTIVITY_TEXT1[24] .. "+" .. self.m_tOpenResult.addCoin .. "    "
	end
	if self.m_tOpenResult.giftNum and self.m_tOpenResult.giftNum > 0 then 
		strContent = strContent .. LocalStrings.CASTING_MASTER_ACTIVITY_TEXT1[31] .. "+" .. self.m_tOpenResult.giftNum .. "    "
	end
	if strContent ~= "" then 
		MsgBoxManager:showTipBox(strContent, nil, nil, nil, nil, nil, nil, nil, nil, GlobalMethod:ccp(0.5, 0.77))
	end

	self:setOpenState(false)
	self:_afterCloseReward()
end

--@brief 	点击"自选奖励"按钮回调
function WndSwordCastingMaster:onClickChoosePrize(element)
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

--@brief 	更新许愿按钮
function WndSwordCastingMaster:updateDrawgBtn()
	for i=1, 2 do
		local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
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

		local strWordList = {{LocalStrings.CASTING_MASTER_ACTIVITY_TEXT1[2],LocalStrings.CASTING_MASTER_ACTIVITY_TEXT1[3]},{LocalStrings.CASTING_MASTER_ACTIVITY_TEXT1[30],LocalStrings.CASTING_MASTER_ACTIVITY_TEXT1[30]}}
		local txtUseTool = GetElement(self.m_root,"txtUseTool"..i,WZUILabelTTF)
		local strDraw = string.format(strWordList[self.m_nDrawToolType + 1][2], nTimes)
		if freeCount == 1 then
			if i == 1 then
				strDraw = strWordList[self.m_nDrawToolType + 1][1]
			elseif i == 2 then
				if nTempTimes == 0 then
					strDraw = string.format(strWordList[self.m_nDrawToolType + 1][2], self.m_tDrawNumList[i])
				end
			end
		end
		txtUseTool:setText(strDraw)
	end
end

--@brief 	点击许愿按钮回调
function WndSwordCastingMaster:onClickUseTool(element)
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
	local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
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
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		MsgBoxManager:showConfirmBox(string.format(LocalStrings.WATERCOUNTRY_TEXT4, basicData.name), self, self.goToBuy)
		return 
	end

	self:setOpenState(true)

	local tData = {}
	tData.times = self.m_tDrawNumList[nTag]
	tData.pool = self.m_nDrawToolType
	local stringData = json.encode(tData)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 3, stringData)
end

--@brief 	前往小推车购买
function WndSwordCastingMaster:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

--@brief 	点击按钮回调
function WndSwordCastingMaster:onClickOperateBtn(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nTag = element:getTag()
	if nTag == 1 then
		CellNewYearTask:showInterface(52, self.m_nActivityId)
	elseif nTag == 2 then
		WndShopRank:showInterface(73, self.m_nActivityId)
	elseif nTag == 3 then
		WndShopRank:showInterface(72, self.m_nActivityId)
	elseif nTag == 4 then
		WndDollMachineShop:showInterface(17, self.m_nActivityId)
	end
end

--@brief    显示奖励进度
function WndSwordCastingMaster:showRewardProgress()
	local nMaxScore = self.m_tContent.giftConfig[#self.m_tContent.giftConfig][1]
	local nScore = self.m_nScore % nMaxScore
	local nStage = #self.m_tContent.giftConfig
	for i=#self.m_tContent.giftConfig,1,-1 do
		if nScore < self.m_tContent.giftConfig[i][1] then
			nStage = i
		end
	end
	local prevVal = self.m_tContent.giftConfig[nStage-1] and self.m_tContent.giftConfig[nStage-1][1] or 0
	local nTatget = self.m_tContent.giftConfig[nStage][1] - prevVal
	local nProgress = nScore - prevVal
	local imgPath = {"ui/activityWords/text_hd_zjsj_z_00.png","ui/activityWords/text_hd_zjsj_y_00.png","ui/activityWords/text_hd_zjsj_f_00.png","ui/activityWords/text_hd_zjsj_l_00.png","ui/activityWords/text_hd_zjsj_d_00.png","ui/activityWords/text_hd_zjsj_t_00.png"}
	GetElement(self.m_root, "imgProgWord", WZUIImage):setFile(imgPath[nStage])
	GetElement(self.m_root, "txtRewardProg", WZUILabelTTF):setText(string.format("%s/%s", nProgress, nTatget))

	for i=1,6 do
		local conLv = GetElement(self.m_root,"conLv"..i,WZUIContainer)
		local imgLvBg = GetElement(conLv,"imgLvBg",WZUIImage)
		local imgLvWord = GetElement(conLv,"imgLvWord",WZUIImage)
		imgLvBg:setGrayRender(true)
		imgLvWord:setGrayRender(true)
		if i < nStage then
			imgLvBg:setGrayRender(false)
			imgLvWord:setGrayRender(false)
		end
	end
end

--@brief    显示任务进度
function WndSwordCastingMaster:showTaskProgress()
	local conDailyTask = GetElement(self.m_root, "conDailyTask", WZUIContainer)
	local taskInfo = GDatatab_new_activity_task["id_" .. self.m_nDkTaskId]
	if not taskInfo or self.m_nDkTaskStatus == 2 then
		conDailyTask:setVisible(false)
		return
	end

	GetElement(self.m_root, "ftbTaskDesc", WZUIFreeTextBox):setShowText(string.format(taskInfo.desc, self.m_nDkTaskProgress .. "/" .. self.m_nDkTaskTarget))

	local conDailyTask = GetElement(self.m_root, "conDailyTask", WZUIContainer)
	local btnTaskReceive = GetElement(self.m_root, "btnTaskReceive", WZUIButton)
	local txtTaskBtn1 = GetElement(self.m_root, "txtTaskBtn1", WZUILabelTTF)
	local txtTaskBtn2 = GetElement(self.m_root, "txtTaskBtn2", WZUILabelTTF)
	local txtTaskBtn3 = GetElement(self.m_root, "txtTaskBtn3", WZUILabelTTF)
	if self.m_nDkTaskStatus == -1 then
		conDailyTask:setVisible(true)
		btnTaskReceive:setTouchEnable(false)
		txtTaskBtn1:setText(LocalStrings.ACTIVE_BTN_GET)
		txtTaskBtn2:setText(LocalStrings.ACTIVE_BTN_GET)
		txtTaskBtn3:setText(LocalStrings.ACTIVE_BTN_GET)
	elseif self.m_nDkTaskStatus == 0 then
		conDailyTask:setVisible(true)
		btnTaskReceive:setTouchEnable(true)
		txtTaskBtn1:setText(LocalStrings.ACTIVE_BTN_GET)
		txtTaskBtn2:setText(LocalStrings.ACTIVE_BTN_GET)
		txtTaskBtn3:setText(LocalStrings.ACTIVE_BTN_GET)
	elseif self.m_nDkTaskStatus == 1 then
		conDailyTask:setVisible(true)
		btnTaskReceive:setTouchEnable(false)
		txtTaskBtn1:setText(LocalStrings.ACTIVE_GET)
		txtTaskBtn2:setText(LocalStrings.ACTIVE_GET)
		txtTaskBtn3:setText(LocalStrings.ACTIVE_GET)
	elseif self.m_nDkTaskStatus == 2 then
		conDailyTask:setVisible(false)
		btnTaskReceive:setTouchEnable(false)
		txtTaskBtn1:setText(LocalStrings.CASTING_MASTER_ACTIVITY_TEXT1[27])
		txtTaskBtn2:setText(LocalStrings.CASTING_MASTER_ACTIVITY_TEXT1[27])
		txtTaskBtn3:setText(LocalStrings.CASTING_MASTER_ACTIVITY_TEXT1[27])
	end

	local tcTaskReward = GetElement(self.m_root, "tcTaskReward", WZUITableContainer)
	tcTaskReward:cleanTable()
	for i=1,#taskInfo.reward do
		local celElement,tCell = CellGoodItem:createElement()
		celElement:setTag(i-1)
		celElement:setScale(0.65)
		tCell:setCellGoodLocalId(taskInfo.reward[i][1], taskInfo.reward[i][2], 17)
		tCell:setItemClickFun(self,self.onItemClick)
		tcTaskReward:setCellElement(celElement)
	end

	self:_caculateTime()
end

--@brief	点击物品弹出对应的tips
function WndSwordCastingMaster:onItemClick(tCell,tag,tData)
    if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData,false)
end

--brief    领取任务奖励
function WndSwordCastingMaster:onClickTaskReceive(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ReceiveTaskReward(self.m_nActivityId, self.m_nDkTaskId)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief 	iphoneX适配
function WndSwordCastingMaster:_adaptIphoneX()
	if IsIphoneX() then
	end
end

--@brief 	倒计时
function WndSwordCastingMaster:_caculateTime(element, delta)
	if self.m_nDkTaskRemainTime then 
		local nLeftTime = self.m_nDkTaskRemainTime - SystemTime:getServerTime()
		if nLeftTime >= 0 then 
			local ftxtLeftTime = GetElement(self.m_root, "ftxtLeftTime_WndSwordCastingMaster", WZUIFreeTextBox)
			if ftxtLeftTime then 
				local minutes = math.floor(nLeftTime/60)
			    local seconds = nLeftTime%60
				local strContent = string.format(LocalStrings.RELIC_TEXT_4, minutes, seconds)
				ftxtLeftTime:setShowText(strContent)
			end
		elseif nLeftTime == -1 then 
			self.m_nTimeCaculate = 0
			WZLog("WndSwordCastingMaster:_caculateTime 00")
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 1, "")
		else
			self.m_nTimeCaculate = self.m_nTimeCaculate + 1 
			if self.m_nTimeCaculate >= 60 then 
				self.m_nTimeCaculate = 0
				WZLog("WndSwordCastingMaster:_caculateTime 11")
				ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 1, "")
			end
		end
	end
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配模块Begin----------------------------------------

function WndSwordCastingMaster:_adaptLanguage_vn()
	GetElement(self.m_root,"txtUseTool1",WZUILabelTTF):setScale(0.85)
	GetElement(self.m_root,"txtUseTool2",WZUILabelTTF):setScale(0.85)
	GetElement(self.m_root,"txtOperateBtn1",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txtOperateBtn2",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txtOperateBtn3",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root, "txtProgWord", WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root, "ftbTaskDesc", WZUIFreeTextBox):setScale(0.7)
end

-------------------------------------语言适配模块End----------------------------------------

