--WndFootballShootingData.lua
--@brief	WndFootballShooting的数据模块
--@date		2024/07/26
--@author	yrd
--@note		射门大战


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFootballShooting:onEnter(element)
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
function WndFootballShooting:onExit(element)
	g_bIsShowWndDressUp = true
	g_tTempItemForLaterShow = {}
	CacheCenter:unregisterUpatePlayerItemObserver(self)
	ProtocolProcessorFestivalActivity:unregAll6()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
	GlobalGame:getGameEventDispathcer():Remove(Independent_Activity.ActivityReddot, self.showRedDot, self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetResult,self._onGetTaskResult,self)

	self:_unInit()
	LoadNewActivityRes(false)
end

--@brief    onenter函数已执行
function WndFootballShooting:onEnterTransitionDidFinish(element)
	local conDailyTask = GetElement(self.m_root,"conDailyTask",WZUIContainer)
	conDailyTask:enableSchedule("_caculateTime", 1)

	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7133, 7133)
end

--@brief    点击关闭窗口按钮
function WndFootballShooting:showInterface()
	LoadNewActivityRes(true)
	local wnd = WndFootballShooting:createElement()
	WindowManager:addWindow(wnd, WndFootballShooting, false)
end

--@brief    点击关闭窗口按钮
function WndFootballShooting:onClickClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	SaveActivityPoleType("TOOLTYPE_FOOTBALLSHOOTING", self.m_nDrawToolType)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮
function WndFootballShooting:onClickRule(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSingleMapDesc:showInterface(LocalStrings.FOOTBALL_SHOOT_TEXT2)
end

--@brief    初始化静态文本
function WndFootballShooting:_initStaticText()
	self.m_nDrawToolType = GetActivityPoleType("TOOLTYPE_FOOTBALLSHOOTING")
	if self.m_nDrawToolType ~= 0 then 
		GetElement(self.m_root, "cbgTools", WZUICheckBoxGroup):setCheckIndex(self.m_nDrawToolType)
	end

	self:_showAnimal()

	GetElement(self.m_root,"txtChoosePrize",WZUILabelTTF):setText(LocalStrings.WATERMELON_TEXT1[22])

	GetElement(self.m_root,"txtOperateBtn1",WZUILabelTTF):setText(LocalStrings.FOOTBALL_SHOOT_TEXT1[4])
	GetElement(self.m_root,"txtOperateBtn2",WZUILabelTTF):setText(LocalStrings.FOOTBALL_SHOOT_TEXT1[5])
	GetElement(self.m_root,"txtOperateBtn3",WZUILabelTTF):setText(LocalStrings.FOOTBALL_SHOOT_TEXT1[6])
	GetElement(self.m_root,"txtTypeName",WZUILabelTTF):setText(LocalStrings.FOOTBALL_SHOOT_TEXT1[10])
	GetElement(self.m_root, "txtTaskTitle", WZUILabelTTF):setText(LocalStrings.FOOTBALL_SHOOT_TEXT1[13])
end

--@brief 	更新许愿币的数量
function WndFootballShooting:_updateCoinNum()
	local sFormat = [[<I Z="0.4" P="1">%s</I><T C="255,236,193" S="20" P="1" SC="163,74,20" SS="4" SE="0">%d</T>]]
	local basicData = GDatatab_item["id_" .. self.m_nCoinId]
	local nNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	GetElement(self.m_root, "ftbOwnCoin", WZUIFreeTextBox):setShowText(string.format(sFormat, basicData.icon, nNum))
end

--@brief 	初始化活动时间
function WndFootballShooting:_initActivityTime()
	local tStartDate = os.date("*t", self.m_nStartTime)
	local tEndDate = os.date("*t", self.m_nEndTime)
	local sDuration = string.format(LocalStrings.ACTIVITYTIME_FORMAT, tStartDate.month, tStartDate.day, tStartDate.hour, tStartDate.min, tEndDate.month, tEndDate.day, tEndDate.hour, tEndDate.min)
	GetElement(self.m_root, "txtActivityTime", WZUILabelTTF):setText(sDuration)
end

--@brief 	红点
function WndFootballShooting:showRedDot()
	if self.m_root == nil then return end 

	local imgBtnRedDot2 = GetElement(self.m_root, "imgBtnRedDot2", WZUIImage)
	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[117133] or GlobalGame.g_tRedPointTypeList[127133]) then 
		imgBtnRedDot2:setVisible(true)
	else
		imgBtnRedDot2:setVisible(false)
	end
end

--@brief 	刷新全民礼包的红点
function WndFootballShooting:showBagGiftInfo()
	if self.m_nGiftRewardNum > 0 then 
		GetElement(self.m_root, "imgGiftRed", WZUIImage):setVisible(true)
		GetElement(self.m_root, "txtGiftNum", WZUILabelTTF):setText(self.m_nGiftRewardNum)
	else
		GetElement(self.m_root, "imgGiftRed", WZUIImage):setVisible(false)
	end
end

--@brief 	刷新点球礼包的红点
function WndFootballShooting:showPenaltyGiftInfo()
	local cost = self.m_tContent.giftConfig[1]
	local num = math.floor(self.m_nGiftTimes / cost)
	if num > 0 then 
		GetElement(self.m_root, "imgGiftRed4", WZUIImage):setVisible(true)
		GetElement(self.m_root, "txtGiftNum4", WZUILabelTTF):setText(num)
	else
		GetElement(self.m_root, "imgGiftRed4", WZUIImage):setVisible(false)
	end

	local num1 = self.m_nGiftTimes % cost
	GetElement(self.m_root, "txtOperateBtn4", WZUILabelTTF):setText(num1.."/"..cost)
end


--@brief 	更新界面
function WndFootballShooting:updateUI()

end

--@brief 	点击选择瓶子按钮回调
function WndFootballShooting:onClickChooseTool(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nIndex = GetElement(self.m_root, "cbgTools", WZUICheckBoxGroup):getCheckIndex()
	if self.m_nDrawToolType == nIndex then
		return
	end

	self.m_nDrawToolType = nIndex
	self:updateWishingBtn()
	self:_playAni(1, true)
	self:_playAnotherAni(0)

	self:showGoal()
end

--@brief 	显示球门情况
function WndFootballShooting:showGoal()
	local imgPath = {"ui/specialBg/common_smdz_qk_pt.png", "ui/specialBg/common_smdz_qk_hj.png"}
	local imgGoal = GetElement(self.m_root,"imgGoal",WZUIImage)
	imgGoal:setFile(imgPath[self.m_nDrawToolType+1])

	local imgPath = {"ui/newActivity/common_smdz_di_pt.png", "ui/newActivity/common_smdz_di_hj.png"}
	for i=1,12 do
		local conGoal = GetElement(self.m_root,"conGoal"..i,WZUIContainer)
		local imgScore = GetElement(conGoal,"imgScore",WZUIImage)
		imgScore:setFile(imgPath[self.m_nDrawToolType+1])
	end
	
	local ratio = self.m_tContent.scoreMultipleConfig[self.m_nDrawToolType+1]
	for i=1,12 do
		local conGoal = GetElement(self.m_root,"conGoal"..i,WZUIContainer)
		local lafScore = GetElement(conGoal,"lafScore", WZUILabelTTF)
		lafScore:setText(self.m_tBaseScore[i] * ratio)
	end

	for i=1,5 do
		local tImgPath = {"ui/newActivity/common_smdz_qiu1.png","ui/newActivity/common_smdz_qiu2.png"}
		local imgBall = GetElement(self.m_root,"imgBall"..i,WZUIImage)
		local spineBall = GetElement(imgBall,"spineBall",WZUISpine)
		imgBall:setFile(tImgPath[self.m_nDrawToolType+1])
		spineBall:setVisible(self.m_nDrawToolType==1)
	end
end

--@brief 	更新许愿按钮
function WndFootballShooting:updateWishingBtn()
	for i=1, 2 do
		local txtUseTool = GetElement(self.m_root,"txtUseTool"..i,WZUILabelTTF)

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
		if freeCount == 1 then
			if i == 1 then
				txtUseTool:setText(LocalStrings.FOOTBALL_SHOOT_TEXT1[2])
			elseif i == 2 then
				if nTempTimes == 0 then
					txtUseTool:setText(string.format(LocalStrings.FOOTBALL_SHOOT_TEXT1[3], self.m_tDrawNumList[i]))
				else
					txtUseTool:setText(string.format(LocalStrings.FOOTBALL_SHOOT_TEXT1[3], nTimes))
				end
			end
		else
			txtUseTool:setText(string.format(LocalStrings.FOOTBALL_SHOOT_TEXT1[3], nTimes))
		end
	end
end


--@brief 	设置待机特效
function WndFootballShooting:_showAnimal()
	local spinePath = "activity/hd_pic_smdz"
	local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".json")
	if existSpine then
		local spineBG = GetElement(self.m_root, "spineBG", WZUISpine)
		if spineBG then 
			spineBG:setFileJson(spinePath .. ".json")
			spineBG:setFileAtlas(spinePath .. ".atlas")
			spineBG:play("wait_3", true)
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

		for i=1,5 do
			local imgBall = GetElement(self.m_root,"imgBall"..i,WZUIImage)
			local spineBall = GetElement(imgBall,"spineBall",WZUISpine)
			spineBall:setFileJson(spinePath .. ".json") 
			spineBall:setFileAtlas(spinePath .. ".atlas")
			spineBall:play("wait_2", true)
		end
	else
		local _sIndex = "hd_pic_smdz"
		local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
		if downloadInfo then 
			DownloadManager:addDownloadTask(7133, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndFootballShooting)
		end
	end

	local spinePath3 = "city/ui_main_iconeffect"
	local existSpine3 = WZDataFile:getInstance():checkFileExist(spinePath3 .. ".json")
	if existSpine3 then 
		existSpine3 = WZDataFile:getInstance():checkFileExist(spinePath3 .. ".atlas")
	end
	if existSpine3 then
		for i = 1, 6 do
			local spineScoreBox = GetElement(self.m_root, "spineScoreBox" .. i, WZUISpine)
			if spineScoreBox then 
				spineScoreBox:setFileJson(spinePath3 .. ".json")
				spineScoreBox:setFileAtlas(spinePath3 .. ".atlas")
				spineScoreBox:play("animation", true)
			end
		end
	end
end

function WndFootballShooting:downloadEffectCallback(taskId,extraData,failed)
	WZLog("WndFootballShooting:downloadEffectCallback",taskId,extraData,failed)
	self:_showAnimal()
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndFootballShooting:_playAni(aniIndex, bLoop)
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
function WndFootballShooting:_playAnotherAni(aniIndex, bLoop)
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
function WndFootballShooting:showOpenAction()
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	local spinePath1 = "activity/hd_pic_smdz"
	local existSpine1 = WZDataFile:getInstance():checkFileExist(spinePath1 .. ".json")
	if spineOpen then 
		if existSpine1 then
			local aniIndex = self.m_nAniType + 1 
			self:_playAnotherAni(aniIndex, false)
			-- local nSeconds = 2
			-- spineOpen:enableSchedule("showShootReward", nSeconds)
			spineOpen:enableSchedule("showShootBefore", 0)
		else
			self:showShootReward()
		end
	end
end

--@brief 	显示开启奖励 处理抽奖时人物人物会闪一下问题
function WndFootballShooting:showShootBefore()
	self:_playAni(0)
	local nSeconds = 0.4
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	spineOpen:disableSchedule()
	spineOpen:enableSchedule("showShootAnimation", nSeconds)
end

--@brief 	显示开启奖励
function WndFootballShooting:showShootAnimation()
	-- self:_playAni(1, true)
	-- self:_playAnotherAni(0)

	local nSeconds = 0.8
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	spineOpen:disableSchedule()
	spineOpen:enableSchedule("showShootReward", nSeconds)


	local tScoreCount = {} --分数出现的次数
	for i=1,#self.m_tGiftScore do
		if tScoreCount[self.m_tGiftScore[i]] == nil then
			tScoreCount[self.m_tGiftScore[i]] = 0
		end
		tScoreCount[self.m_tGiftScore[i]] = tScoreCount[self.m_tGiftScore[i]] + 1
	end
	self.m_tShootIndex = {} --存放要射门的位置
	local tShootCount = {1,5} --根据类型判断踢球次数
	local curNum = 0
	while curNum < tShootCount[self.m_nAniType] do
		for k,v in pairs(tScoreCount) do
			table.insert(self.m_tShootIndex, k)
			tScoreCount[k] = tScoreCount[k] - 1
			if tScoreCount[k] == 0 then
				tScoreCount[k] = nil
			end
			curNum = curNum + 1
			if curNum >= tShootCount[self.m_nAniType] then
				break
			end
		end
	end

	for i=1,5 do
		local imgBall = GetElement(self.m_root,"imgBall"..i,WZUIImage)
		imgBall:setVisible(false)
	end
	self.m_tRotationDirection = {}
	for i=1,#self.m_tShootIndex do
		self.m_tRotationDirection[i] = math.random(0, 1) * 2 - 1
	end
	for i=1,#self.m_tShootIndex do
		local conFootball = GetElement(self.m_root,"conFootball",WZUIContainer)
		local conGoalList = GetElement(self.m_root,"conGoalList",WZUIContainer)

		local imgBall = GetElement(self.m_root,"imgBall"..i,WZUIImage)
		local ballPtX, ballPtY = imgBall:getPosition()
		local ballWorldPt = conFootball:convertToWorldSpace(GlobalMethod:ccp(ballPtX, ballPtY))
		local ballPos = conFootball:convertToNodeSpace(GlobalMethod:ccp(ballWorldPt.x, ballWorldPt.y))
		imgBall:setVisible(true)
		imgBall:enableSchedule("updateBallFlyAction")

		local rand = math.random(1,#self.m_tScoreIndex[self.m_tShootIndex[i]])
		local nIndex = self.m_tScoreIndex[self.m_tShootIndex[i]][rand]
		local conGoal = GetElement(self.m_root,"conGoal"..nIndex,WZUIContainer)
		local goalPtX, goalPtY = conGoal:getPosition()
		local goalWorldPt = conGoalList:convertToWorldSpace(GlobalMethod:ccp(goalPtX, goalPtY))
		local goalPos = conFootball:convertToNodeSpace(GlobalMethod:ccp(goalWorldPt.x, goalWorldPt.y))

		local vec = BattleCommon:pointSub(goalPos, ballPos)
		local tPer = self:getPerpendicularVector(vec)
		if #tPer > 0 then
			local arrayAni = CCArray:create()

			local tValue1 = {1, 0.9, 0.7, 0.7, 0.9, 1, 1, 0.9, 0.7, 0.7, 0.9, 1}
			local tOffset1 = {130, 150, 180, 180, 150, 130, 130, 150, 180, 180, 150, 130}
			local tDirection1 = {2, 2, 2, 1, 1, 1, 2, 2, 2, 1, 1, 1}
			local midPoint =  BattleCommon:pointAdd(ballPos, BattleCommon:pointMult(BattleCommon:pointSub(goalPos, ballPos), tValue1[nIndex]))
			local offset = tOffset1[nIndex]
			local tmpIndex = tDirection1[nIndex]

			local configInfo = ccBezierConfig()
			local cpX = midPoint.x + tPer[tmpIndex].x * offset
			local cpY = midPoint.y + tPer[tmpIndex].y * offset
			configInfo.controlPoint_1 = GlobalMethod:ccp(cpX, cpY)
			configInfo.controlPoint_2 = GlobalMethod:ccp(cpX, cpY)
			configInfo.endPosition = GlobalMethod:ccp(goalPos.x, goalPos.y)
			local moveTo = CCBezierTo:create(0.5, configInfo)
			arrayAni:addObject(moveTo)

			-- local moveTo = CCMoveTo:create(0, GlobalMethod:ccp(ballPtX, ballPtY))
			-- arrayAni:addObject(moveTo)

			local callfunc = CCCallFunc:create(function()
				imgBall:disableSchedule()
				imgBall:setRotation(0)
			end)
			arrayAni:addObject(callfunc)

			local delay = CCDelayTime:create(0.1)
			arrayAni:addObject(delay)

			local callfunc = CCCallFunc:create(function()
				imgBall:disableSchedule()
				imgBall:setRelativePosition(GlobalMethod:ccp(0.5,0.21))
				imgBall:setRotation(0)
				imgBall:setScale(1)
				imgBall:setShowAll(true)
			end)
			arrayAni:addObject(callfunc)

			local sequence = CCSequence:create(arrayAni)
			imgBall:runAction(sequence)
		end
	end

end

--@brief 	显示球旋转
function WndFootballShooting:updateBallFlyAction(element)
	local angularSpeed = 30
	local tag = element:getTag()
	local rotation = element:getRotation()
	rotation = (rotation + angularSpeed * self.m_tRotationDirection[tag]) % 360
	element:setRotation(rotation)

	local nChangeScale = 0.015
	element:setScale(element:getScale() - nChangeScale)
end

--@brief 	显示开启奖励
function WndFootballShooting:showShootReward()
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	spineOpen:disableSchedule()
	self:_playAni(1, true)
	self:_playAnotherAni(0)

	local strContent = ""
	if self.m_tOpenResult.addExp and self.m_tOpenResult.addExp > 0 then 
		strContent = strContent .. LocalStrings.FOOTBALL_SHOOT_TEXT1[10] .. "+" .. self.m_tOpenResult.addExp .. "    "
	end
	if strContent ~= "" then 
		MsgBoxManager:showTipBox(strContent, nil, nil, nil, nil, nil, nil, nil, nil, GlobalMethod:ccp(0.5, 0.77))
	end

	self:setOpenState(false)
	self:_afterCloseReward()
end



--@brief 	点击"自选奖励"按钮回调
function WndFootballShooting:onClickChoosePrize(element)
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
function WndFootballShooting:onClickUseTool(element)
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
		SaveOperateTimes("OPERATETIMES_FOOTBALLSHOOTING", self.m_nActivityId)
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
function WndFootballShooting:goToBuy(nId, nResType)
	if nResType == MSGBOXRESTYPE_CONFIRM then
		WndActivityPropsGift:showInterface(self.m_nCoinId)
	end
end

--@brief 	点击按钮回调
function WndFootballShooting:onClickOperateBtn(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nTag = element:getTag()
	if nTag == 1 then
		self:onClickGift(element)
	elseif nTag == 2 then
		local otherData = {}
		otherData.taskCount = 2 --几个任务标签
		otherData.tTaskTypeName = {LocalStrings.FOOTBALL_SHOOT_TEXT1[11], LocalStrings.FOOTBALL_SHOOT_TEXT1[12]} --任务标签名字
		otherData.titleList = otherData.tTaskTypeName
		otherData.taskType = 2
		otherData.redPoint = {117133, 127133} --长线；日常；每天
		CellNewYearTask:showInterface(60, self.m_nActivityId, otherData)
	elseif nTag == 3 then
		local otherData = {}
		otherData.type = 1
		otherData.strRankTitleName = LocalStrings.FOOTBALL_SHOOT_TEXT1[6]
		otherData.strChangeTitle = LocalStrings.FOOTBALL_SHOOT_TEXT1[15]
		otherData.strScoreTitle = LocalStrings.FOOTBALL_SHOOT_TEXT1[16] .. ":"
		WndShopRank:showInterface(90, self.m_nActivityId, nil, nil, otherData) 
	elseif nTag == 4 then
		self:onClickGift2(element)
	end
end

--@brief 	点击赛事礼包按钮回调
function WndFootballShooting:onClickGift(element)
	if self.m_nGiftRewardNum > 0 then
		--背包已满提示
		if CacheCenter:getRemainAmount() <= 0 then
			MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
			return
		end
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 5, "")
	else
		local tData = {}
		tData.txtTitle = string.format(LocalStrings.FOOTBALL_SHOOT_TEXT1[14], self.m_tContent.globalConfig[1])
		tData.nType = 2
		WndTips:show(element, self.m_root, 52, tData, GlobalMethod:ccp(70,80), true)
	end
end

--@brief 	点击赛事礼包按钮回调
function WndFootballShooting:onClickGift2(element)
	local cost = self.m_tContent.giftConfig[1]
	local num = math.floor(self.m_nGiftTimes / cost)
	if num > 0 then 
		--背包已满提示
		if CacheCenter:getRemainAmount() <= 0 then
			MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
			return
		end
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 7, "")
	else
		MsgBoxManager:showTipBox(LocalStrings.FOOTBALL_SHOOT_TEXT1[17])
	end
end

--@brief 	成熟度
function WndFootballShooting:_showProgress()
	local txtStepNum = GetElement(self.m_root, "txtStepNum", WZUILabelTTF)
	if txtStepNum then 
		txtStepNum:setText(self.m_nCurScore)
	end

	local prgExp = GetElement(self.m_root, "prgExp", WZUIProgress)
	local nCurNum = self.m_nCurScore
	if prgExp then
		if nCurNum <= self.m_tScoreConfig[1].scoreTarget then 
			prgExp:setPercentage(math.floor(nCurNum * 17/self.m_tScoreConfig[1].scoreTarget))
		elseif nCurNum <= self.m_tScoreConfig[2].scoreTarget then 
			local nTempNum = self.m_tScoreConfig[2].scoreTarget - self.m_tScoreConfig[1].scoreTarget
			prgExp:setPercentage(17 + math.floor((nCurNum - self.m_tScoreConfig[1].scoreTarget) * 17/nTempNum))
		elseif nCurNum <= self.m_tScoreConfig[3].scoreTarget then 
			local nTempNum = self.m_tScoreConfig[3].scoreTarget - self.m_tScoreConfig[2].scoreTarget
			prgExp:setPercentage(34 + math.floor((nCurNum - self.m_tScoreConfig[2].scoreTarget) * 17/nTempNum))
		elseif nCurNum <= self.m_tScoreConfig[4].scoreTarget then 
			local nTempNum = self.m_tScoreConfig[4].scoreTarget - self.m_tScoreConfig[3].scoreTarget
			prgExp:setPercentage(51 + math.floor((nCurNum - self.m_tScoreConfig[3].scoreTarget) * 17/nTempNum))
		elseif nCurNum <= self.m_tScoreConfig[5].scoreTarget then 
			local nTempNum = self.m_tScoreConfig[5].scoreTarget - self.m_tScoreConfig[4].scoreTarget
			prgExp:setPercentage(68 + math.floor((nCurNum - self.m_tScoreConfig[4].scoreTarget) * 17/nTempNum))
		elseif nCurNum <= self.m_tScoreConfig[6].scoreTarget then 
			local nTempNum = self.m_tScoreConfig[6].scoreTarget - self.m_tScoreConfig[5].scoreTarget
			prgExp:setPercentage(85 + math.floor((nCurNum - self.m_tScoreConfig[5].scoreTarget) * 17/nTempNum))
		else
			prgExp:setPercentage(100)
		end
	end

	--步数
	for i = 1, 6 do
		if self.m_tScoreConfig[i].lastStatus == nil or self.m_tScoreConfig[i].lastStatus ~= self.m_tScoreConfig[i].status then
			local imgScoreBox = GetElement(self.m_root, "imgScoreBox" .. i, WZUIImage)
			local spineScoreBox = GetElement(self.m_root, "spineScoreBox" .. i, WZUISpine)
			local imgScoreYlq = GetElement(self.m_root, "imgScoreYlq" .. i, WZUIImage)
			if self.m_tScoreConfig[i].status == -1 then
				imgScoreBox:setGrayRender(true)
				spineScoreBox:setVisible(false)
				imgScoreYlq:setVisible(false)
			elseif self.m_tScoreConfig[i].status == 0 then 
				imgScoreBox:setGrayRender(false)
				spineScoreBox:setVisible(true)
				imgScoreYlq:setVisible(false)
			elseif self.m_tScoreConfig[i].status == 1 then
				imgScoreBox:setGrayRender(false)
				spineScoreBox:setVisible(false)
				imgScoreYlq:setVisible(true)
			end

			self.m_tScoreConfig[i].lastStatus = self.m_tScoreConfig[i].status
		end
	end
end

--@brief 	设置步数积分宝箱数量
function WndFootballShooting:_showStepScoreNum()
	for i = 1, 6 do
		local txtScore = GetElement(self.m_root, "txtScore"..i, WZUILabelTTF)
		txtScore:setText(self.m_tScoreConfig[i].scoreTarget)
	end
end

--@brief 	点击积分宝箱回调
function WndFootballShooting:onClickScoreBox(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if self.m_tScoreConfig[nTag].status == 0 then 
		--背包已满提示
		if CacheCenter:getRemainAmount() <= 0 then
			MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
			return
		end
		local tData = {}
		tData.id = nTag - 1
		local strData = json.encode(tData)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 6, strData)
	else
		local tData = self.m_tScoreConfig[nTag]
		local data = {}

		data.scale = 0.4
		local reward_id = {}
		local reward_num = {}
		for i = 1, #tData.reward do
			table.insert(reward_id,  tData.reward[i][1])
			table.insert(reward_num, tData.reward[i][2])
		end
		data.cur_value = self.m_nCurScore
		data.totle_value = tData.scoreTarget
		data.rewardIds = reward_id
		data.rewardNums = reward_num
		local conLeftScore = GetElement(self.m_root, "conLeftScore", WZUIContainer)
		WndNewTipsReward:showInterface(conLeftScore, element, data, false, GlobalMethod:ccp(8.7, 0.2))
	end
end

--@brief 	显示定时任务
function WndFootballShooting:showDsTask()
	if self.m_tDsTask == nil then
		return
	end

	local conDailyTask = GetElement(self.m_root, "conDailyTask", WZUIContainer)
	local taskInfo = GDatatab_new_activity_task["id_" .. self.m_tDsTask.dsTaskId]

	local nDsTaskProgress = math.min(self.m_tDsTask.dsTaskProgress, self.m_tDsTask.dsTaskTarget)
	GetElement(self.m_root, "ftbTaskDesc", WZUIFreeTextBox):setShowText(string.format(taskInfo.desc, nDsTaskProgress .. "/" .. self.m_tDsTask.dsTaskTarget))

	local conDailyTask = GetElement(self.m_root, "conDailyTask", WZUIContainer)
	local btnTaskReceive = GetElement(self.m_root, "btnTaskReceive", WZUIButton)
	local txtTaskBtn1 = GetElement(self.m_root, "txtTaskBtn1", WZUILabelTTF)
	local txtTaskBtn2 = GetElement(self.m_root, "txtTaskBtn2", WZUILabelTTF)
	local txtTaskBtn3 = GetElement(self.m_root, "txtTaskBtn3", WZUILabelTTF)
	if self.m_tDsTask.dsTaskStatus == -1 then
		conDailyTask:setVisible(true)
		btnTaskReceive:setTouchEnable(false)
		txtTaskBtn1:setText(LocalStrings.ACTIVE_BTN_GET)
		txtTaskBtn2:setText(LocalStrings.ACTIVE_BTN_GET)
		txtTaskBtn3:setText(LocalStrings.ACTIVE_BTN_GET)
	elseif self.m_tDsTask.dsTaskStatus == 0 then
		conDailyTask:setVisible(true)
		btnTaskReceive:setTouchEnable(true)
		txtTaskBtn1:setText(LocalStrings.ACTIVE_BTN_GET)
		txtTaskBtn2:setText(LocalStrings.ACTIVE_BTN_GET)
		txtTaskBtn3:setText(LocalStrings.ACTIVE_BTN_GET)
	elseif self.m_tDsTask.dsTaskStatus == 1 then
		conDailyTask:setVisible(true)
		btnTaskReceive:setTouchEnable(false)
		txtTaskBtn1:setText(LocalStrings.ACTIVE_GET)
		txtTaskBtn2:setText(LocalStrings.ACTIVE_GET)
		txtTaskBtn3:setText(LocalStrings.ACTIVE_GET)
	end

	local flcTaskRewards = GetElement(self.m_root, "flcTaskRewards", WZUIFreeListContainer)
	flcTaskRewards:removeAll()
	for i=1,#taskInfo.reward do
		local celElement,tCell = CellGoodItem:createElement()
		celElement = WZUIContainer:luaTo(celElement)
		celElement:setTag(i-1)
		celElement:setScale(0.7)
		tCell:setCellGoodLocalId(taskInfo.reward[i][1], taskInfo.reward[i][2], 17)
		tCell:setItemClickFun(self,self.onItemClick)
		flcTaskRewards:pushBack(celElement)
	end
	flcTaskRewards:getMoveElement():setPositionX(flcTaskRewards:getMaxPosition().x)

	self:_caculateTime()
end

--@brief 	倒计时
function WndFootballShooting:_caculateTime(element, delta)
	local nServerTime = SystemTime:getServerTime()

	local conDailyTask = GetElement(self.m_root, "conDailyTask", WZUIContainer)
	conDailyTask:setVisible(false)

	if self.m_tDsTask == nil then
		if nServerTime % 60 == 0 then
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 1, "")
		end
		return
	end
	
	if self.m_tDsTask then
		if nServerTime >= self.m_tDsTask.dsTaskStartTime and nServerTime <= self.m_tDsTask.dsTaskEndTime then
			conDailyTask:setVisible(true)
		elseif nServerTime <= self.m_tDsTask.dsTaskEndTime + 1 then
			self.m_tDsTask = nil
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 1, "")
			return
		end

		local nLeftTime = self.m_tDsTask.dsTaskEndTime - SystemTime:getServerTime()
		if nLeftTime >= 0 then 
			local txtLeftTime = GetElement(self.m_root, "txtLeftTime", WZUILabelTTF)
			if txtLeftTime then 
				local hour = math.floor(nLeftTime/3600)
				local minute = math.floor(nLeftTime%3600/60)
				local second = nLeftTime%60
				local strFormat = "%d:%02d:%02d"
				txtLeftTime:setText(string.format(strFormat, hour, minute, second))
			end
		end
	end
end

--@brief	点击物品弹出对应的tips
function WndFootballShooting:onItemClick(tCell,tag,tData)
	if tData == nil then
	   return
	end
	WndItemInfo:onCloseClick()
	WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData,false)
end

--brief    领取任务奖励
function WndFootballShooting:onClickTaskReceive(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ReceiveTaskReward(self.m_nActivityId, self.m_tDsTask.dsTaskId)
end

--@brief    获得垂直于tPoint的单位向量列表
function WndFootballShooting:getPerpendicularVector(tPoint)
	local tPointList = {}
	if tPoint.x == 0 and tPoint.y == 0 then
	elseif tPoint.y == 0 then
		table.insert(tPointList,BattleCommon:getPointTable(0,1))
		table.insert(tPointList,BattleCommon:getPointTable(0,-1))
	else
		local tempPointX = 1 --随机的值
		local pointLen,newPoint = BattleCommon:vectorNormalize(BattleCommon:getPointTable(tempPointX,(-tPoint.x*tempPointX/tPoint.y)))
		table.insert(tPointList,newPoint)
		table.insert(tPointList,BattleCommon:pointMult(newPoint,-1))
	end
	return tPointList
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief 	iphoneX适配
function WndFootballShooting:_adaptIphoneX()
	if IsIphoneX() then
		GetElement(self.m_root,"conLeftScore",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.07,0.578))
		GetElement(self.m_root,"conDailyTask",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.877,0.542))
	end
end




-------------------------------------私有方法模块End----------------------------------------
-------------------------------------语言适配begin----------------------------------------
function WndFootballShooting:_adaptLanguage_vn()
	GetElement(self.m_root, "txtTypeName", WZUILabelTTF):setFontSize(14)
	GetElement(self.m_root, "txtChoosePrize", WZUILabelTTF):setFontSize(14)
	GetElement(self.m_root, "txtUseTool1", WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root, "txtUseTool2", WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root, "ftbTaskDesc", WZUIFreeTextBox):setScale(0.8)
	for i = 1, 3 do
		GetElement(self.m_root, "txtOperateBtn" .. i, WZUILabelTTF):setFontSize(16)
		GetElement(self.m_root, "txtOperateBtn" .. i, WZUILabelTTF):setDimensions(GlobalMethod:CCSize(120,0))
	end
end
-------------------------------------语言适配End----------------------------------------

