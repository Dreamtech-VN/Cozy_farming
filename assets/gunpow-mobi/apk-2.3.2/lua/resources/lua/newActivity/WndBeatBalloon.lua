--WndBeatBalloon.lua
--@brief	WndBeatBalloon的UI模块
--@date		2023/03/17
--@author	XTX
--@note		打气球活动主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndBeatBalloon:onEnter(element)
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
function WndBeatBalloon:onExit(element)
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
function WndBeatBalloon:onEnterTransitionDidFinish(element)
    WZLog("WndBeatBalloon:onEnterTransitionDidFinish")
    self:_createShootLine()
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7070, 7070)
end

--@brief    关闭窗口
function WndBeatBalloon:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    --如果是自动弹出的活动界面
   WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮回调
function WndBeatBalloon:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 
    WndSingleMapDesc:showInterface1(LocalStrings.BEATBALLOON_TEXT2) 
end

--@brief 	点击目标按钮回调
function WndBeatBalloon:onClickTask(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if nTag == 1 then 
		CellNewYearTask:showInterface(24, self.m_nActivityId)
	elseif nTag == 3 then 
		WndShopRank:showInterface(41, self.m_nActivityId) 
	end
end

--@brief 	点击大奖预览按钮回调
function WndBeatBalloon:onClickBigReward(element)
	-- body
	local eleType = type(element)
	if eleType ~= "number" then 
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	end

	self.m_tGetTimes = {}
	self.m_bIsOpenReward = true
	local tData = {pool = 1}
	local tData2 = {pool = 2}
	local strJson = json.encode(tData)
	local strJson2 = json.encode(tData2)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson2)
end

--@brief 	点击开启按钮回调
function WndBeatBalloon:onClickFive(element)
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
		SaveOperateTimes("BEATBALLOONACTIVITYID", self.m_nActivityId)
    	return 
    end

	local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local nLeftBalloonCount = self:_getBalloonNum()
	local nTempTimes = nArrowNum
	local nTimes = nTag
	local freeCount = 0
	freeCount = self.m_nCount > 0 and 1 or 0 
	local qqPos = self.m_nSelBalloonIndex
	if self.m_nCalabashType == 1 then 
		freeCount = 0 
	end
	if self.m_nAniType == 2 then 
		qqPos = -1
		nTag = self.m_nMaxLotteryCount 
		nTempTimes = math.floor(nArrowNum/self.m_tCostNumConfig[self.m_nCalabashType + 1])
		nTimes = (nTempTimes + freeCount) >= self.m_nMaxLotteryCount and self.m_nMaxLotteryCount or nTempTimes > 0 and (nTempTimes + freeCount) or self.m_nMaxLotteryCount 
		nTimes = nTimes > nLeftBalloonCount and nLeftBalloonCount or nTimes
	end
	local nCostNum = nTimes * self.m_tCostNumConfig[self.m_nCalabashType + 1]
	if nCostNum - freeCount > nArrowNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		MsgBoxManager:showConfirmBox(string.format(LocalStrings.WATERCOUNTRY_TEXT4, basicData.name), self, self.goToBuy)
		return 
	end

    local tData = {}
	tData.times = nTag
	tData.pool = self.m_nCalabashType
	tData.qqPos = qqPos

	local stringData = json.encode(tData)

	self:setOpenState(true)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 3, stringData)
end

--@brief 	点击变换按钮次数会调
function WndBeatBalloon:onClickChange(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_nAniType == 1 then 
		self.m_nAniType = 2
	elseif self.m_nAniType == 2 then 
		self.m_nAniType = 1
	end

	self:_setFreeBtnText()
end

--@brief 	前往小推车购买
function WndBeatBalloon:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

--@brief 	点击切换葫芦类型
function WndBeatBalloon:onChooseTool(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local nTag = element:getTag()
	if self.m_nCalabashType == nTag then return end 

	self.m_nCalabashType = nTag
	self:_setFreeBtnText()
	self:_setBowlingPlayAni(1, true)
end

--@brief 	点击选中要打得气球
function WndBeatBalloon:onClickBalloon(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if self.m_nSelBalloonIndex == nTag - 1 then return end 
	self.m_nSelBalloonIndex = nTag - 1
	local point = {x=0, y=0}
	point.x, point.y = element:getPosition()
	WZLog("WndBeatBalloon:onClickBalloon", point.x, point.y)
	local image = WZUIImage:create()		--创建图片
	image:setFile("ui/common/common_icon_xqz_1.png") 					--图片路径
	image:setPosition(point.x, point.y)			--图片相对位置
	image:setUseAbsCoordinate(true)
	image:setUseOriginSize(true)			--图片原始大小
	local node = self:getFrontLayer()
	node:addChild(image, 5)
	local nPointCount = self.m_tPointCount[nTag]
	local imgPot = GetElement(self.m_root, "imgPot_WndBeatBalloon", WZUIImage)
	local pointStart = {x=0, y=0}
	pointStart.x, pointStart.y = imgPot:getPosition()
	if self.m_tLine then
    	self.m_tLine:setTouchOk(point)
    	self.m_tLine:setTouchMove(element, pointStart, nPointCount)
	end
end

--@brief 	领取特殊任务回调
function WndBeatBalloon:onGetTeamReward(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local taskData = self.m_tSpecialTask[1]
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ReceiveTaskReward(taskData.activityId, taskData.id)
end

--@brief	点击物品弹出对应的tips
function WndBeatBalloon:onItemClick(tCell, tag, tData)
    if tData == nil then
       return
    end

    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root, self.m_root, 1, tData, false, nil, true)
end

--@brief    获取前景Layer
function WndBeatBalloon:getFrontLayer()
    if self.m_root then
        local layer = GetElement(self.m_root, "conForBalloon_WndBeatBalloon", WZUIContainer)
        return layer
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndBeatBalloon:_update()
	-- body
	self:_setFreeBtnText()
	self:showRedDot()
	self:_initActivityTime()
    self:_updateLightNum()
    self:_showBalloon()
end

--@brief 	初始化静态文本
function WndBeatBalloon:_initStaticText()
--	self:getPoleType()

	GetElement(self.m_root, "txtBtnTask1_WndBeatBalloon", WZUILabelTTF):setText(LocalStrings.BEATBALLOON_TEXT1[3])
	GetElement(self.m_root, "txtBtnTask3_WndBeatBalloon", WZUILabelTTF):setText(LocalStrings.ACTIVITY_TEXT6)
	GetElement(self.m_root, "txtSpecialTaskTitle_WndBeatBalloon", WZUILabelTTF):setText(LocalStrings.BEATBALLOON_TEXT1[4])

	self:_setBallAni()
	self:_setBowlingPlayAni(1, true)
end

--@brief 	红点
function WndBeatBalloon:showRedDot()
	-- body
	if self.m_root == nil then return end 

	local imgTaskRedDot = GetElement(self.m_root, "imgTaskRedDot_WndBeatBalloon", WZUIImage)

	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[217070] or GlobalGame.g_tRedPointTypeList[227070] or GlobalGame.g_tRedPointTypeList[237070]) then 
		imgTaskRedDot:setVisible(true)
	else
		imgTaskRedDot:setVisible(false)
	end
end

--@brief 	更新异火的数量
function WndBeatBalloon:_updateLightNum()
	-- body
	local ftxtLightNum = GetElement(self.m_root, "ftxtLightNum_WndBeatBalloon", WZUIFreeTextBox)
	local sFormat = [[<I Z="0.5" P="1">%s</I><T C="255,236,193" S="20" P="1" SC="132,66,29" SS="4" SE="0">%d</T>]]
	if ftxtLightNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
		ftxtLightNum:setShowText(string.format(sFormat, basicData.icon, nLightNum))
	end
end

--@brief 	初始化活动时间
function WndBeatBalloon:_initActivityTime()
	-- body
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndBeatBalloon", WZUILabelTTF)
    if txtActivityTime then 
    	txtActivityTime:setText(LocalStrings.ACTIVITY_TIME_KEY .. ":" .. needDay_str)
    end
end

--@brief 	显示开启动画
function WndBeatBalloon:showOpenAction()
	-- body
	--创建选中特效
	local spinePath = "activity/ui_hl_jiaoshui"
	local existSpine = CheckEffectFile(spinePath)
	if not existSpine then 
		local _sIndex = "ui_hl_jiaoshui"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7070, downloadInfo.url, downloadInfo.md5, _sIndex, "DownloadResourceCallback", _G)
        end
	end
	local spineOpen = GetElement(self.m_root, "spineOpen_WndBeatBalloon", WZUISpine)
	if spineOpen then 
		if existSpine then 
			local nAniIndex = 2
			if self.m_nAniType == 1 then 
				if self.m_tOpenResult.shootPos and self.m_tOpenResult.shootPos[1] > 18 then 
					nAniIndex = 3
				elseif self.m_tOpenResult.shootPos and self.m_tOpenResult.shootPos[1] < 12 then 
					nAniIndex = 4
				end
			end
			self:_setBowlingPlayAni(nAniIndex, false)
			spineOpen:enableSchedule("showReadyShoot", 0.4)
		else
			self:showReadyShoot()
		end
	end
end

--@brief 	显示开启奖励
function WndBeatBalloon:showReadyShoot()
	-- body
	local spineOpen = GetElement(self.m_root, "spineOpen_WndBeatBalloon", WZUISpine)
	spineOpen:disableSchedule()
	self:_setBowlingPlayAni(1, true)
	for i = 1, #self.m_tOpenResult.shootPos do
		local nIndex = self.m_tOpenResult.shootPos[i] + 1
		local imgBalloon = GetElement(self.m_root, "imgBalloon" .. nIndex .. "_WndBeatBalloon", WZUIImage)
		local conLine = GetElement(self.m_root, "conLine" .. nIndex .. "_WndBeatBalloon", WZUIContainer)

		local data = {path = self.m_tBombEffect[self.m_nCalabashType + 1], play = "wait1", zOrder = 2}
		local bombEffect = imgBalloon:getChildByTag(22)
		if not bombEffect then 
			bombEffect = createEffectSpine(imgBalloon, data)
			if bombEffect then 
				bombEffect:setTag(22)
			end
		else
			bombEffect = WZUISpine:luaTo(bombEffect)
			bombEffect:setVisible(true)
			local fileAtlas = bombEffect:getFileAtlas()
			local newFile = data.path .. ".atlas"
			if newFile ~= fileAtlas then 
				bombEffect:setFileJson("")
				bombEffect:setFileAtlas("")
				bombEffect:setFileJson(data.path .. ".json")
				bombEffect:setFileAtlas(data.path .. ".atlas")
			end
			bombEffect:play("wait1", false)
		end
		imgBalloon:setFile("")
		conLine:setVisible(false)
		local bombEffectSu = imgBalloon:getChildByTag(23)
		if bombEffectSu then 
			bombEffectSu:setVisible(false)
		end
		if i == #self.m_tOpenResult.shootPos then 
			if bombEffect then 
				spineOpen:enableSchedule("showShootReward", 0.25)
			else
				self:showShootReward()
			end
		end
	end
end

--@brief 	显示开启奖励
function WndBeatBalloon:showShootReward()
	-- body
	local spineOpen = GetElement(self.m_root, "spineOpen_WndBeatBalloon", WZUISpine)
	spineOpen:disableSchedule()
	--移除创建的特效
	for i = 1, #self.m_tOpenResult.shootPos do
		local nIndex = self.m_tOpenResult.shootPos[i] + 1
		local imgBalloon = GetElement(self.m_root, "imgBalloon" .. nIndex .. "_WndBeatBalloon", WZUIImage)
		local bombEffect = imgBalloon:getChildByTag(22)
		if bombEffect then 
			bombEffect:setVisible(false)
		end
	end
	self:_showBalloon()

	local strContent = ""
	if self.m_tOpenResult.addScore > 0 then 
		strContent = strContent .. LocalStrings.BEATBALLOON_TEXT1[14] .. "+" .. self.m_tOpenResult.addScore
		MsgBoxManager:showTipBox(strContent, nil, nil, nil, nil, nil, nil, nil, nil, GlobalMethod:ccp(0.5, 0.77))
	end
	
	self:setOpenState(false)
	self:_afterCloseReward()
end

--@brief 	iphoneX适配
function WndBeatBalloon:_adaptIphoneX()
	if IsIphoneX() then
	--	GetElement(self.m_root, "conLeftMenu_WndBeatBalloon", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.935,0.154069))
	end
end

--@brief 	设置免费丢
function WndBeatBalloon:_setFreeBtnText()
	local txtBtnOpenOne = GetElement(self.m_root, "txtBtnOpenOne_WndBeatBalloon", WZUILabelTTF)

	local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local freeTimes = 0 
	local nTempTimes = nLightNum
	local nTimes = 0
	local nLeftBalloonCount = self:_getBalloonNum()
	if self.m_nAniType == 1 then 
		if self.m_nCalabashType == 0 then 
			if self.m_nCount > 0 then 
				freeTimes = 1
				txtBtnOpenOne:setText(LocalStrings.BEATBALLOON_TEXT1[6])
			else
				txtBtnOpenOne:setText(string.format(LocalStrings.BEATBALLOON_TEXT1[5], 1))
			end
		elseif self.m_nCalabashType == 1 then 
			txtBtnOpenOne:setText(string.format(LocalStrings.BEATBALLOON_TEXT1[5], 1))
		end
	elseif self.m_nAniType == 2 then 
		nTempTimes = math.floor(nLightNum/self.m_tCostNumConfig[self.m_nCalabashType + 1])
		nTimes = (nTempTimes + freeTimes) >= self.m_nMaxLotteryCount and self.m_nMaxLotteryCount or nTempTimes > 0 and (nTempTimes + freeTimes) or self.m_nMaxLotteryCount 
		nTimes = nTimes > nLeftBalloonCount and nLeftBalloonCount or nTimes

		txtBtnOpenOne:setText(string.format(LocalStrings.BEATBALLOON_TEXT1[5], nTimes))
	end
	local txtSurprisedAtt = GetElement(self.m_root, "txtSurprisedAtt_WndBeatBalloon", WZUILabelTTF)
	if txtSurprisedAtt then 
		local nLeftNum = self.m_nSurprisedBalloon - self.m_nCurProcress
		txtSurprisedAtt:setText(string.format(LocalStrings.BEATBALLOON_TEXT1[7], nLeftNum))
	end
end

--@brief 	设置待机特效
function WndBeatBalloon:_setBallAni()
	local spinePath = "activity/hd_pic_daqiqiu"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		local spineOpen = GetElement(self.m_root, "spineOpen_WndBeatBalloon", WZUISpine)
		if spineOpen then 
			spineOpen:setFileJson(spinePath .. ".json")
			spineOpen:setFileAtlas(spinePath .. ".atlas")
		end
	end

	local spinePath2 = "activity/ui_dqq_rw"
	local existSpine2 = CheckEffectFile(spinePath2)
	if existSpine2 then 
		local spineTask = GetElement(self.m_root, "spineTask_WndBeatBalloon", WZUISpine)
		if spineTask then 
			spineTask:setFileJson(spinePath2 .. ".json")
			spineTask:setFileAtlas(spinePath2 .. ".atlas")
			spineTask:play("wait1", true)
		end
	end

	local spinePath3 = "activity/hd_pic_daqiqiu2"
	local existSpine3 = CheckEffectFile(spinePath3)
	if existSpine3 then 
		local spineGrassL = GetElement(self.m_root, "spineGrassL_WndBeatBalloon", WZUISpine)
		if spineGrassL then 
			spineGrassL:setFileJson(spinePath3 .. ".json")
			spineGrassL:setFileAtlas(spinePath3 .. ".atlas")
			spineGrassL:play("wait1", true)
		end
	end

	local spinePath4 = "activity/hd_pic_daqiqiu3"
	local existSpine4 = CheckEffectFile(spinePath4)
	if existSpine4 then 
		local spineGrassR = GetElement(self.m_root, "spineGrassR_WndBeatBalloon", WZUISpine)
		if spineGrassR then 
			spineGrassR:setFileJson(spinePath4 .. ".json")
			spineGrassR:setFileAtlas(spinePath4 .. ".atlas")
			spineGrassR:play("wait1", true)
		end
	end
end

function WndBeatBalloon:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndBeatBalloon:downloadEffectCallback",taskId,extraData,failed)
    self:_setBallAni()
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndBeatBalloon:_setBowlingPlayAni(aniIndex, bLoop)
	local spineOpen = GetElement(self.m_root, "spineOpen_WndBeatBalloon", WZUISpine)
	
	aniIndex = aniIndex or 1
	WZLog("WndBeatBalloon:_setBowlingPlayAni", aniIndex, bLoop)
	
	if spineOpen then 
		spineOpen:setVisible(true)
		spineOpen:play(self.m_tBallAniName[self.m_nCalabashType + 1][aniIndex], bLoop ~= nil and bLoop or true)
	end
end

--@brief 	显示气球
function WndBeatBalloon:_showBalloon()
	for i = 1, #self.m_tBalloonData do
		local imgBalloon = GetElement(self.m_root, "imgBalloon" .. i .. "_WndBeatBalloon", WZUIImage)
		local conLine = GetElement(self.m_root, "conLine" .. i .. "_WndBeatBalloon", WZUIContainer)
		local img9Line = GetElement(self.m_root, "img9Line" .. i .. "_WndBeatBalloon", WZUI9Image)
		if self.m_tBalloonData[i] == -1 then 
			imgBalloon:setFile("")
			conLine:setVisible(false)
		else
			conLine:setVisible(true)
			imgBalloon:setFile(self.m_tBalloonColor[self.m_tBalloonData[i] + 1])
			local data = {path = "activity/ui_dqq_qq", play = "wait1", zOrder = 1, loop = true}
			local bombEffectSu = imgBalloon:getChildByTag(23)
			if self.m_tBalloonData[i] == 0 then 
				if not bombEffectSu then 
					bombEffectSu = createEffectSpine(imgBalloon, data)
					if bombEffectSu then 
						bombEffectSu:setTag(23)
					end
				else
					bombEffectSu:setVisible(true)
				end
				img9Line:setFile("ui/newActivity/common_dqq_x_h.png")
			else
				img9Line:setFile("ui/newActivity/common_dqq_x_b.png")
			end
		end
	end
end

--@brief 	生成瞄准线
function WndBeatBalloon:_createShootLine()
	local conForBalloon = self:getFrontLayer()
	self.m_tLine = BattleOtherPointsLine:create(conForBalloon, 6, nil, nil, nil, nil, nil, nil, GlobalMethod:ccp(568,100), self)
end

--@brief 	显示特殊任务
function WndBeatBalloon:showSpecialTask()
	local taskData = self.m_tSpecialTask[1]

	local ftxtSpecialTaskDesc = GetElement(self.m_root, "ftxtSpecialTaskDesc_WndBeatBalloon", WZUIFreeTextBox)
	ftxtSpecialTaskDesc:setShowText(taskData.desc)
	local tbTeamReward = GetElement(self.m_root, "tbTeamReward_WndBeatBalloon", WZUITableContainer)
	tbTeamReward:cleanTable()

	for i = 1, #taskData.ids do
		local element, tNewObj = CellGoodItem:createElement()
		if element and tNewObj then 
			element:setTag(i - 1)
			element:setScale(0.8)
			tNewObj:setCellGoodLocalId(taskData.ids[i], taskData.nums[i], 17)
			tNewObj:setItemClickFun(self, self.onItemClick)
			tbTeamReward:setCellElement(element)
		end
	end

	local btnGetReward = GetElement(self.m_root, "btnGetReward_WndBeatBalloon", WZUIButton)
	local spineTask = GetElement(self.m_root, "spineTask_WndBeatBalloon", WZUISpine)
	if taskData.status == 1 then 
		btnGetReward:setTouchEnable(true)
		spineTask:setVisible(true)
	else
		btnGetReward:setTouchEnable(false)
		spineTask:setVisible(false)
	end
end

-------------------------------------私有方法模块End----------------------------------------


function WndBeatBalloon:_adaptLanguage_vn()
	local ftxtSpecialTaskDesc = GetElement(self.m_root, "ftxtSpecialTaskDesc_WndBeatBalloon", WZUIFreeTextBox)
	ftxtSpecialTaskDesc:setMaxWidth(315)
	ftxtSpecialTaskDesc:setScale(0.7)

	local txtSurprisedAtt = GetElement(self.m_root, "txtSurprisedAtt_WndBeatBalloon", WZUILabelTTF)
	txtSurprisedAtt:setDimensions(GlobalMethod:CCSize(300,0))
	txtSurprisedAtt:setRelativePosition(GlobalMethod:ccp(0.15,0.9))

	GetElement(self.m_root, "txtBtnOpenOne_WndBeatBalloon", WZUILabelTTF):setScale(0.8)

	GetElement(self.m_root, "txtBtnTask1_WndBeatBalloon", WZUILabelTTF):setDimensions(GlobalMethod:CCSize(120,0))
end