--WndSpringOuting.lua
--@brief	WndSpringOuting的UI模块
--@date		2023/02/23
--@author	XTX
--@note		春游踏青活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSpringOuting:onEnter(element)
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
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSpringOuting:onExit(element)
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
function WndSpringOuting:onEnterTransitionDidFinish(element)
    WZLog("WndSpringOuting:onEnterTransitionDidFinish")
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7065, 7065)
end

--@brief    关闭窗口
function WndSpringOuting:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    self:saveAutoActivity(nValue)
    --如果是自动弹出的活动界面
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮回调
function WndSpringOuting:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 
    WndSingleMapDesc:showInterface1(LocalStrings.SPRINGOUTING_TEXT2) 
end

--@brief 	点击目标按钮回调
function WndSpringOuting:onClickTask(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if nTag == 1 then 
		CellNewYearTask:showInterface(23, self.m_nActivityId)
	elseif nTag == 2 then 
		WndShopRank:showInterface(40, self.m_nActivityId) 
	elseif nTag == 4 then 
		self:onClickGift(element)
	end
end

--@brief 	点击大奖预览按钮回调
function WndSpringOuting:onClickBigReward(element)
	-- body
	local eleType = type(element)
	if eleType ~= "number" then 
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	end

	if self.m_tBigRewardList ~= nil then
		self.m_bIsOpenReward = true
		self.m_nRecvRewardsPool = {}
		local tData = {pool = 1}
		local strJson = json.encode(tData)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson)
		local tData2 = {pool = 2}
		local strJson2 = json.encode(tData2)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson2)
	end
end

--@brief 	点击开启按钮回调
function WndSpringOuting:onClickFive(element)
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
		SaveOperateTimes("SPRINGOUTINGACTIVITYID", self.m_nActivityId)
    	return 
    end

	local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local nTempTimes = nArrowNum
	local nTimes = nTag
	local freeCount = 0
	freeCount = self.m_nCount > 0 and 1 or 0 
	self.m_nAniType = 1
	if nTag == 5 then 
		self.m_nAniType = 2
		nTag = self.m_nMaxLotteryCount 
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
function WndSpringOuting:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

--@brief 	点击赛事礼包按钮回调
function WndSpringOuting:onClickGift(element)
	-- body
	if self.m_nGiftRewardNum >= 1 then
		--背包已满提示
	    if CacheCenter:getRemainAmount() <= 0 then
	        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
	        return
	    end
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 6, "")
	else
		local tData = {}
		tData.txtTitle = string.format(LocalStrings.SPRINGOUTING_TEXT1[7], self.m_tContent.globalConfig[1])
		tData.nType = 2
		WndTips:show(element, self.m_root, 52, tData, GlobalMethod:ccp(50,80), true)
	end
end

--@brief 	点击积分宝箱回调
function WndSpringOuting:onClickScoreBox(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if self.m_tScoreConfig[nTag].status == 0 then 
		--背包已满提示
	    if CacheCenter:getRemainAmount() <= 0 then
	        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
	        return
	    end
	    local tData = {}
	    tData.scoreType = nTag - 1
	    local strData = json.encode(tData)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 4, strData)
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
        local conLeftScore = GetElement(self.m_root, "conLeftScore_WndSpringOuting", WZUIContainer)
        WndNewTipsReward:showInterface(conLeftScore, element, data, false, GlobalMethod:ccp(9.5, 0.11))
	end
end

--@brief 	点击步数宝箱回调
function WndSpringOuting:onClickStepBox(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if self.m_tStepBoxConfig[nTag].status == 0 then 
		--背包已满提示
	    if CacheCenter:getRemainAmount() <= 0 then
	        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
	        return
	    end
	    local tData = {}
	    tData.giftType = nTag - 1
	    local strData = json.encode(tData)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 5, strData)
	else
		local tData = self.m_tStepBoxConfig[nTag]
		local data = {}

        data.scale = 0.4
        local reward_id = {}
        local reward_num = {}
        for i = 1, #tData.reward do
            table.insert(reward_id,  tData.reward[i][1])
            table.insert(reward_num, tData.reward[i][2])
        end
        data.cur_value = self.m_nCurStep
        data.totle_value = tData.stepTarget
        data.rewardIds = reward_id
        data.rewardNums = reward_num
        WndNewTipsReward:showInterface(self.m_root, element, data, true, GlobalMethod:ccp(0.61, 0.38))
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndSpringOuting:_update()
	-- body
	self:_setFreeBtnText()
	self:showRedDot()
	self:_initActivityTime()
    self:_updateLightNum()
    self:_showStepScoreNum()
end

--@brief 	初始化静态文本
function WndSpringOuting:_initStaticText()
	self:getAutoActivity()
	GetElement(self.m_root, "txtBtnTask1_WndSpringOuting", WZUILabelTTF):setText(LocalStrings.SPRINGOUTING_TEXT1[3])
	GetElement(self.m_root, "txtBtnTask3_WndSpringOuting", WZUILabelTTF):setText(LocalStrings.SPRINGOUTING_TEXT1[2])
	GetElement(self.m_root, "txtBtnTask4_WndSpringOuting", WZUILabelTTF):setText(LocalStrings.SPRINGOUTING_TEXT1[4])
	GetElement(self.m_root, "txtTypeName_WndSpringOuting", WZUILabelTTF):setText(LocalStrings.SPRINGOUTING_TEXT1[14])
	
	self:_setBallAni()
	local spineOpen = GetElement(self.m_root, "spineOpen_WndSpringOuting", WZUISpine)
	if spineOpen then 
		spineOpen:setRelativePosition(GlobalMethod:ccp(self.m_tMovePos[self.m_nPosIndex][1], self.m_tMovePos[self.m_nPosIndex][2]))
		WZLog("WndSpringOuting:_initStaticText", self.m_nPosIndex)
		if self.m_nPosIndex >= 28 and self.m_nPosIndex < 56 then 
			self:_roleTurnLeft()
			if self.m_nPosIndex >= 31 then 
				self:_resetZOrder(3, 2)
			end
		end
	end
end

--@brief 	红点
function WndSpringOuting:showRedDot()
	-- body
	if self.m_root == nil then return end 

	local imgTaskRedDot = GetElement(self.m_root, "imgTaskRedDot_WndSpringOuting", WZUIImage)

	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[217065] or GlobalGame.g_tRedPointTypeList[227065] or GlobalGame.g_tRedPointTypeList[237065]) then 
		imgTaskRedDot:setVisible(true)
	else
		imgTaskRedDot:setVisible(false)
	end
end

--@brief 	更新异火的数量
function WndSpringOuting:_updateLightNum()
	-- body
	local ftxtLightNum = GetElement(self.m_root, "ftxtLightNum_WndSpringOuting", WZUIFreeTextBox)
	local sFormat = [[<I Z="0.5" P="1">%s</I><T C="255,236,193" S="20" P="1" SC="132,66,29" SS="4" SE="0">%d</T>]]
	if ftxtLightNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
		ftxtLightNum:setShowText(string.format(sFormat, basicData.icon, nLightNum))
	end
end

--@brief 	初始化活动时间
function WndSpringOuting:_initActivityTime()
	-- body
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndSpringOuting", WZUILabelTTF)
    if txtActivityTime then 
    	txtActivityTime:setText(LocalStrings.ACTIVITY_TIME_KEY .. ":" .. needDay_str)
    end
end

--@brief 	显示开启动画
function WndSpringOuting:showOpenAction()
	-- body
	--创建选中特效
	local spinePath = "activity/ui_tq_nanzhu"
	local existSpine = CheckEffectFile(spinePath)
	if not existSpine then 
		local _sIndex = "ui_tq_nanzhu"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7065, downloadInfo.url, downloadInfo.md5, _sIndex, "DownloadResourceCallback", _G)
        end
	end

	local spineOpen = GetElement(self.m_root, "spineOpen_WndSpringOuting", WZUISpine)
	if spineOpen then 
		if existSpine then 
			self:_setBowlingPlayAni(2, true)
		else
			self:showShootReward()
		end
	end
end

--@brief 	显示开启奖励
function WndSpringOuting:showShootReward()
	-- body
	self:_setBowlingPlayAni(1, true)

	local strContent = ""
	if self.m_tOpenResult.addScore > 0 then 
		strContent = strContent .. LocalStrings.SPRINGOUTING_TEXT1[14] .. "+" .. self.m_tOpenResult.addScore .. "    "  
	end
	if self.m_tOpenResult.addStep > 0 then 
		strContent = strContent .. LocalStrings.SPRINGOUTING_TEXT1[18] .. "+" .. self.m_tOpenResult.addStep  
	end

	if strContent ~= "" then 
		MsgBoxManager:showTipBox(strContent, nil, nil, nil, nil, nil, nil, nil, nil, GlobalMethod:ccp(0.5, 0.77))
	end
	self:setOpenState(false)
	self:_afterCloseReward()
end

--@brief 	iphoneX适配
function WndSpringOuting:_adaptIphoneX()
	if IsIphoneX() then
		GetElement(self.m_root, "conLeftScore_WndSpringOuting", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.05,0.53))
		GetElement(self.m_root, "conLeftMenu_WndSpringOuting", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.92,0.29))
	end
end

--@brief 	设置免费丢
function WndSpringOuting:_setFreeBtnText()
	local txtBtnOpenOne = GetElement(self.m_root, "txtBtnOpenOne_WndSpringOuting", WZUILabelTTF)
	local txtBtnOpenFive = GetElement(self.m_root, "txtBtnOpenFive_WndSpringOuting", WZUILabelTTF)

	local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local freeTimes = 0 
	local nTempTimes = nLightNum
	local nTimes = 0
	if self.m_nCount > 0 then 
		freeTimes = 1
		txtBtnOpenOne:setText(LocalStrings.SPRINGOUTING_TEXT1[6])
	else
		txtBtnOpenOne:setText(string.format(LocalStrings.SPRINGOUTING_TEXT1[5], 1))
	end
	nTimes = (nTempTimes + freeTimes) >= self.m_nMaxLotteryCount and self.m_nMaxLotteryCount or nTempTimes > 0 and (nTempTimes + freeTimes) or self.m_nMaxLotteryCount 

	txtBtnOpenFive:setText(string.format(LocalStrings.SPRINGOUTING_TEXT1[5], nTimes))
end

--@brief 	设置待机特效
function WndSpringOuting:_setBallAni()
	local spinePath = "activity/ui_tq_chunyou_1"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		local spineWait0 = GetElement(self.m_root, "spineWait0_WndSpringOuting", WZUISpine)
		if spineWait0 then 
			spineWait0:setFileJson(spinePath .. ".json")
			spineWait0:setFileAtlas(spinePath .. ".atlas")
			spineWait0:play("wait", true)
		end
	else
		local _sIndex = "ui_tq_chunyou_1"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7065, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndSpringOuting)
        end
	end

	local spinePath2 = "activity/ui_tq_lihe"
	local existSpine2 = CheckEffectFile(spinePath2)
	if existSpine2 then 
		for i = 1, 6 do
			local spineScoreBox = GetElement(self.m_root, "spineScoreBox" .. i .. "_WndSpringOuting", WZUISpine)
			local spineStepBox = GetElement(self.m_root, "spineStepBox" .. i .. "_WndSpringOuting", WZUISpine)
			if spineScoreBox then 
				spineScoreBox:setFileJson(spinePath2 .. ".json")
				spineScoreBox:setFileAtlas(spinePath2 .. ".atlas")
			end
			if spineStepBox then 
				spineStepBox:setFileJson(spinePath2 .. ".json")
				spineStepBox:setFileAtlas(spinePath2 .. ".atlas")
			end
		end
	else
		local _sIndex = "ui_tq_lihe"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(70651, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndSpringOuting)
        end
	end

	local spinePath3 = "activity/ui_tq_nanzhu"
	local existSpine3 = CheckEffectFile(spinePath3)
	if existSpine3 then 
		local spineOpen = GetElement(self.m_root, "spineOpen_WndSpringOuting", WZUISpine)
		if spineOpen then 
			spineOpen:setFileJson(spinePath3 .. ".json")
			spineOpen:setFileAtlas(spinePath3 .. ".atlas")
			spineOpen:play("wait", true)
		end
	else
		local _sIndex = "ui_tq_nanzhu"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7065, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndSpringOuting)
        end
	end

	local spinePath4 = "activity/ui_tq_chunyou_2"
	local existSpine4 = CheckEffectFile(spinePath4)
	if existSpine4 then 
		local spineWait1 = GetElement(self.m_root, "spineWait1_WndSpringOuting", WZUISpine)
		if spineWait1 then 
			spineWait1:setFileJson(spinePath4 .. ".json")
			spineWait1:setFileAtlas(spinePath4 .. ".atlas")
			spineWait1:play("wait", true)
		end
	else
		local _sIndex = "ui_tq_chunyou_2"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7065, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndSpringOuting)
        end
	end
end

function WndSpringOuting:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndSpringOuting:downloadEffectCallback",taskId,extraData,failed)
    self:_setBallAni()
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndSpringOuting:_setBowlingPlayAni(aniIndex, bLoop)
	local spineOpen = GetElement(self.m_root, "spineOpen_WndSpringOuting", WZUISpine)
	aniIndex = aniIndex or 1
	WZLog("WndSpringOuting:_setBowlingPlayAni", aniIndex, bLoop)

	if spineOpen then 
		spineOpen:play(self.m_tBallAniName[aniIndex], bLoop ~= nil and bLoop or true)
	end

	local posCount = #self.m_tMovePos
	if aniIndex == 2 then 
		local sequence = WZUIActionSequence:create()
		for i = 1, self.m_nAniType do
			local moveTo1 = WZUIActionMoveTo:create()
			moveTo1:setMoveX(self.m_tMovePos[self.m_nPosIndex + i][1])
			moveTo1:setMoveY(self.m_tMovePos[self.m_nPosIndex + i][2])
			moveTo1:setDuration(0.7)
			if i == self.m_nAniType then 
				if self.m_nPosIndex + i == 28 then 
					moveTo1:setFinishLuaFunction("_roleTurnLeftEnd")
				elseif self.m_nPosIndex + i == 56 then 
					moveTo1:setFinishLuaFunction("_roleTurnRightEnd")
				elseif self.m_nPosIndex + i == posCount then 
					moveTo1:setFinishLuaFunction("_resetPos")
				else
					moveTo1:setFinishLuaFunction("_afterMove")
				end
			else
				if self.m_nPosIndex + i == 28 then 
					moveTo1:setFinishLuaFunction("_roleTurnLeft")
				elseif self.m_nPosIndex + i == 56 then 
					moveTo1:setFinishLuaFunction("_roleTurnRight")
				elseif self.m_nPosIndex + i == posCount then 
					moveTo1:setFinishLuaFunction("_resetPos")
				end
			end
			sequence:setChildAction(moveTo1)
			if self.m_nPosIndex + i == 31 then --重新设置层级
				local functionAni = WZUIActionCallLuaFunction:create()
	    		functionAni:setLuaFunction("_resetZOrderOne")
				sequence:setChildAction(functionAni)
	    	end
			if self.m_nPosIndex + i == posCount then 
				break 
			end
		end

		self.m_nPosIndex = self.m_nPosIndex + self.m_nAniType
		spineOpen:runUIAction(sequence)
	end
end

--@brief 	移动后回调
function WndSpringOuting:_afterMove()
	self:showShootReward()
end
--@brief 	玩家转向左
function WndSpringOuting:_roleTurnLeft()
	local spineOpen = GetElement(self.m_root, "spineOpen_WndSpringOuting", WZUISpine)
	spineOpen:setFlipX(true)
end

--@brief 	玩家转向左
function WndSpringOuting:_roleTurnLeftEnd()
	local spineOpen = GetElement(self.m_root, "spineOpen_WndSpringOuting", WZUISpine)
	spineOpen:setFlipX(true)

	self:showShootReward()
end

--@brief 	玩家转向右
function WndSpringOuting:_roleTurnRight()
	local spineOpen = GetElement(self.m_root, "spineOpen_WndSpringOuting", WZUISpine)
	spineOpen:setFlipX(false)

	self:_resetZOrder(1, 1)
end

--@brief 	玩家转向右
function WndSpringOuting:_roleTurnRightEnd()
	local spineOpen = GetElement(self.m_root, "spineOpen_WndSpringOuting", WZUISpine)
	spineOpen:setFlipX(false)

	self:_resetZOrder(1, 1)
	self:showShootReward()
end

--@brief 	将玩家的位置重新设置到开始
function WndSpringOuting:_resetPos()
	self.m_nPosIndex = 1
	local spineOpen = GetElement(self.m_root, "spineOpen_WndSpringOuting", WZUISpine)
	spineOpen:setRelativePosition(GlobalMethod:ccp(self.m_tMovePos[self.m_nPosIndex][1], self.m_tMovePos[self.m_nPosIndex][2]))

	self:showShootReward()
end

--@brief 	重新设置层级关系
function WndSpringOuting:_resetZOrderOne()
	GetElement(self.m_root, "spineWait0_WndSpringOuting", WZUISpine):setZOrder(3)
	GetElement(self.m_root, "spineOpen_WndSpringOuting", WZUISpine):setZOrder(2)
end

--@brief 	重新设置层级关系
function WndSpringOuting:_resetZOrder(wait0Order, openOrser)
	GetElement(self.m_root, "spineWait0_WndSpringOuting", WZUISpine):setZOrder(wait0Order)
	GetElement(self.m_root, "spineOpen_WndSpringOuting", WZUISpine):setZOrder(openOrser)
end

--@brief 	成熟度
function WndSpringOuting:_showProgress()
	local txtStepNum = GetElement(self.m_root, "txtStepNum_WndSpringOuting", WZUILabelTTF)
	if txtStepNum then 
		txtStepNum:setText(self.m_nCurScore)
	end

	local prgExp = GetElement(self.m_root, "prgExp_WndSpringOuting", WZUIProgress)
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
    	local nCurStep = self.m_nCurStep
    	if nCurStep > self.m_tStepBoxConfig[i].stepTarget then 
    		nCurStep = self.m_tStepBoxConfig[i].stepTarget
    	end
    	GetElement(self.m_root, "txtStep" .. i .. "_WndSpringOuting", WZUILabelTTF):setText(LocalStrings.SPRINGOUTING_TEXT1[18] .. ":" .. nCurStep .. "/" .. self.m_tStepBoxConfig[i].stepTarget)
    	if self.m_tStepBoxConfig[i].lastStatus == nil or self.m_tStepBoxConfig[i].lastStatus ~= self.m_tStepBoxConfig[i].status then 
	    	if self.m_tStepBoxConfig[i].status == 0 then 
	    		GetElement(self.m_root, "spineStepBox" .. i .. "_WndSpringOuting", WZUISpine):play("wait1_" .. i, true)
	    	else
	    		GetElement(self.m_root, "spineStepBox" .. i .. "_WndSpringOuting", WZUISpine):play("wait" .. i, true)
	    	end

	    	self.m_tStepBoxConfig[i].lastStatus = self.m_tStepBoxConfig[i].status
	    end
	    if self.m_tScoreConfig[i].lastStatus == nil or self.m_tScoreConfig[i].lastStatus ~= self.m_tScoreConfig[i].status then 
	    	if self.m_tScoreConfig[i].status == 0 then 
	    		GetElement(self.m_root, "spineScoreBox" .. i .. "_WndSpringOuting", WZUISpine):play("wait1_" .. i, true)
	    	else
	    		GetElement(self.m_root, "spineScoreBox" .. i .. "_WndSpringOuting", WZUISpine):play("wait" .. i, true)
	    	end

	    	self.m_tScoreConfig[i].lastStatus = self.m_tScoreConfig[i].status
	    end
    end


end

--@brief 	设置步数积分宝箱数量
function WndSpringOuting:_showStepScoreNum()
	for i = 1, 6 do
		local txtScore = GetElement(self.m_root, "txtScore" .. i .. "_WndSpringOuting", WZUILabelTTF)
		txtScore:setText(self.m_tScoreConfig[i].scoreTarget)
	end
end

--@brief 	刷新赛事礼包的信息
function WndSpringOuting:showBagGiftInfo()
	-- body
	if self.m_nGiftRewardNum > 0 then 
		GetElement(self.m_root, "imgGiftRed_WndSpringOuting", WZUIImage):setVisible(true)
		GetElement(self.m_root, "txtGiftNum_WndSpringOuting", WZUILabelTTF):setText(self.m_nGiftRewardNum)
	else
		GetElement(self.m_root, "imgGiftRed_WndSpringOuting", WZUIImage):setVisible(false)
	end
end
-------------------------------------私有方法模块End----------------------------------------
