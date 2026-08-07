--WndBikeMatch.lua
--@brief	WndBikeMatch的UI模块
--@date		2023/09/27
--@author	XTX
--@note		自行车赛活动主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndBikeMatch:onEnter(element)
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
function WndBikeMatch:onExit(element)
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
function WndBikeMatch:onEnterTransitionDidFinish(element)
    WZLog("WndBikeMatch:onEnterTransitionDidFinish")
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7095, 7095)
end

--@brief    关闭窗口
function WndBikeMatch:onCloseClick(element)
	local eleType = type(element)
	if eleType ~= "number" then 
    	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    end

	SaveActivityPoleType("BIKEMATCH", self.m_nCalabashType)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮回调
function WndBikeMatch:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 	
	WndSingleMapDesc:showInterface1(LocalStrings.BIKEMATCH_TEXT2) 
end

--@brief 	点击目标按钮回调
function WndBikeMatch:onClickTask(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if SystemTime:getServerTime() >= self.m_nEndTime then 
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END) 
		self:onCloseClick(0)
		return 
	end 

	local nTag = element:getTag()
	if nTag == 1 then 
		CellNewYearTask:showInterface(42, self.m_nActivityId)
	elseif nTag == 3 then 
		WndShopRank:showInterface(60, self.m_nActivityId) 
	end
end

--@brief 	点击大奖预览按钮回调
function WndBikeMatch:onClickBigReward(element)
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
function WndBikeMatch:onClickFive(element) 
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
    if self.m_bOpenState then MsgBoxManager:showTipBox(LocalStrings.BIKEMATCH_TEXT1[17]) return end 
    if self.m_nChooseReward == 0 then 
    	self:onClickBigReward(0)

		self.m_nChooseReward = 1
		SaveOperateTimes("BIKEMATCHACTIVITYID", self.m_nActivityId)
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
		self.m_nAniType = 3
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
function WndBikeMatch:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

--@brief 	点击切换浪板类型
function WndBikeMatch:onChooseTool(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local nTag = element:getTag()
	if self.m_bOpenState then 
		GetElement(self.m_root, "cbgTool_WndBikeMatch", WZUICheckBoxGroup):setCheckIndex(self.m_nCalabashType)
		return 
	end 
	if self.m_nCalabashType == nTag then return end 

	self.m_nCalabashType = nTag
	self:_setFreeBtnText()
	self:_setWaitPlayAni(true)
end

--@brief	点击物品弹出对应的tips
function WndBikeMatch:onItemClick(tCell,tag,tData)
    if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData,false)
end

--@brief 	点击领取勋章
function WndBikeMatch:onClickMedal(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	local strMedal = string.sub(self.m_tContent.scoreRewards[nTag],2,-2) 
	local nSex = CacheCenter:getPlayerInfo().sex
	local itemId = SplitStringWithSeparator(strMedal, ",", nil, true)[nSex + 1]
	local itemNum = SplitStringWithSeparator(strMedal, ",", nil, true)[3]
	local tData = {id = itemId, lastTime=itemNum,basicInfo=CopyTable(GDatatab_item["id_" .. itemId])}
	WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(element, self.m_root, 1, tData, false, nil, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndBikeMatch:_update()
	-- body
	self:_setFreeBtnText()
	self:showRedDot()
	self:_initActivityTime()
    self:_updateLightNum()
end

--@brief 	初始化静态文本
function WndBikeMatch:_initStaticText()
	self.m_nCalabashType = GetActivityPoleType("BIKEMATCH")
	if self.m_nCalabashType ~= 0 then 
		GetElement(self.m_root, "cbgTool_WndBikeMatch", WZUICheckBoxGroup):setCheckIndex(self.m_nCalabashType)
	end

	GetElement(self.m_root, "txtBtnTask1_WndBikeMatch", WZUILabelTTF):setText(LocalStrings.BIKEMATCH_TEXT1[2])
	GetElement(self.m_root, "txtBtnTask3_WndBikeMatch", WZUILabelTTF):setText(LocalStrings.BIKEMATCH_TEXT1[3])
	GetElement(self.m_root, "txtBigReward_WndBikeMatch", WZUILabelTTF):setText(LocalStrings.WATERMELON_TEXT1[22])
	GetElement(self.m_root, "txtRideDisWord_WndBikeMatch", WZUILabelTTF):setText(LocalStrings.BIKEMATCH_TEXT1[9] .. ":")

	self:_setBallAni()
end

--@brief 	红点
function WndBikeMatch:showRedDot()
	-- body
	if self.m_root == nil then return end 

	local imgTaskRedDot = GetElement(self.m_root, "imgTaskRedDot_WndBikeMatch", WZUIImage)
	local imgTaskRedDot2 = GetElement(self.m_root, "imgTaskRedDot2_WndBikeMatch", WZUIImage)

	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[117095] or GlobalGame.g_tRedPointTypeList[127095]) then 
		imgTaskRedDot:setVisible(true)
	else
		imgTaskRedDot:setVisible(false)
	end
end

--@brief 	更新异火的数量
function WndBikeMatch:_updateLightNum()
	-- body
	local ftxtLightNum = GetElement(self.m_root, "ftxtLightNum_WndBikeMatch", WZUIFreeTextBox)
	local sFormat = [[<I Z="0.45" P="1">%s</I><T C="255,255,255" S="18" P="1" SC="163,74,20" SS="4" SE="1">%d</T>]]
	if ftxtLightNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
		ftxtLightNum:setShowText(string.format(sFormat, basicData.icon, nLightNum))
	end
end

--@brief 	初始化活动时间
function WndBikeMatch:_initActivityTime()
	-- body
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndBikeMatch", WZUILabelTTF)
    if txtActivityTime then 
    	txtActivityTime:setText(LocalStrings.ACTIVE_TIME .. ":" .. needDay_str)
    end
end

--@brief 	显示开启动画
function WndBikeMatch:showOpenAction()
	-- body
	local spineOpen = GetElement(self.m_root, "spineOpen_WndBikeMatch", WZUISpine)
	local spinePath = "activity/hd_pic_zxcbs"
	local existSpine = CheckEffectFile(spinePath)

	if spineOpen then 
		if existSpine then 
			self:_setBowlingPlayAni(2, false)
			self:showShootReward()
			spineOpen:enableSchedule("afterAni", 0.8)
		else
			self:showShootReward()
			self:setOpenState(false)
		end
	end
end

--@brief 	显示开启奖励
function WndBikeMatch:showShootReward()
	-- body
	local strContent = ""
	local nIndex = 0 
	if self.m_tOpenResult.addExp and self.m_tOpenResult.addExp > 0 then 
		strContent = strContent .. LocalStrings.BIKEMATCH_TEXT1[9] .. "+" .. self.m_tOpenResult.addExp
	end

	if strContent ~= "" then 
		MsgBoxManager:showTipBox(strContent, nil, nil, nil, nil, nil, nil, nil, nil, GlobalMethod:ccp(0.5, 0.77))
	end

	self:_afterCloseReward()
end

--@brief 	iphoneX适配
function WndBikeMatch:_adaptIphoneX()
	if IsIphoneX() then
		GetElement(self.m_root, "conLeftRect_WndBikeMatch", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.95,0.61))
	end
end

--@brief 	设置免费丢
function WndBikeMatch:_setFreeBtnText()
	local txtBtnOpenOne = GetElement(self.m_root, "txtBtnOpenOne_WndBikeMatch", WZUILabelTTF)
	local txtBtnOpenFive = GetElement(self.m_root, "txtBtnOpenFive_WndBikeMatch", WZUILabelTTF)

	local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local freeTimes = 0 
	local nTempTimes = math.floor(nLightNum/self.m_tCostByType[self.m_nCalabashType + 1])
	local nTimes = 0
	local strTemp = LocalStrings.BIKEMATCH_TEXT1[7]
	if self.m_nCalabashType == 0 then 
		if self.m_nCount > 0 then 
			freeTimes = 1
			txtBtnOpenOne:setText(LocalStrings.BIKEMATCH_TEXT1[6])
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
function WndBikeMatch:_setBallAni()
	local spinePath = "activity/hd_pic_zxcbs"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		local spineOpen = GetElement(self.m_root, "spineOpen_WndBikeMatch", WZUISpine)
		local spineWait = GetElement(self.m_root, "spineWait_WndBikeMatch", WZUISpine)
		if spineOpen then 
			spineOpen:setFileJson(spinePath .. ".json")
			spineOpen:setFileAtlas(spinePath .. ".atlas")
		end
		if spineWait then 
			spineWait:setFileJson(spinePath .. ".json")
			spineWait:setFileAtlas(spinePath .. ".atlas")
			self:_setWaitPlayAni(true)
		end
	end
end

function WndBikeMatch:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndBikeMatch:downloadEffectCallback",taskId,extraData,failed)
    self:_setBallAni()
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndBikeMatch:_setBowlingPlayAni(aniIndex, bLoop)
	local spineOpen = GetElement(self.m_root, "spineOpen_WndBikeMatch", WZUISpine)
	aniIndex = aniIndex or 1
	WZLog("WndBikeMatch:_setBowlingPlayAni", aniIndex, bLoop)

	if spineOpen then 
		spineOpen:setVisible(true)
		spineOpen:play(self.m_tBallAniName[self.m_nCalabashType + 1][aniIndex], bLoop ~= nil and bLoop or true)
	end
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndBikeMatch:_setWaitPlayAni(bLoop)
	local spineWait = GetElement(self.m_root, "spineWait_WndBikeMatch", WZUISpine)
	WZLog("WndBikeMatch:_setWaitPlayAni", bLoop)

	if spineWait then 
		spineWait:play(self.m_tBallAniName[self.m_nCalabashType + 1][1], bLoop ~= nil and bLoop or true)
	end
end

--@brief 	播放露营动画后
function WndBikeMatch:afterAni(element)
	local spineOpen = GetElement(self.m_root, "spineOpen_WndBikeMatch", WZUISpine)
	spineOpen:disableSchedule()
	spineOpen:setVisible(false)
	self:setOpenState(false)
end

--@brief 	显示圈数奖励
function WndBikeMatch:showCircleReward()
	local txtCircleName = GetElement(self.m_root, "txtCircleName_WndBikeMatch", WZUILabelTTF)
	if txtCircleName then 
		txtCircleName:setText(string.format(LocalStrings.BIKEMATCH_TEXT1[8], self.m_nCurCircle + 1 + self.m_nTurn * self.m_tMedalConfig[3]
))
	end
	local tbCircleReward = GetElement(self.m_root, "tbCircleReward_WndBikeMatch", WZUITableContainer)
	tbCircleReward:cleanTable()

	local nSex = CacheCenter:getPlayerInfo().sex
	for i = 1, #self.m_tRideCircleReward do
		local element, tNewObj = CellGoodItem:createElement()
		if element and tNewObj then
			element:setTag(i - 1)
			element:setScale(0.7)
			local itemId = self.m_tRideCircleReward[i][1+nSex]
			tNewObj:setCellGoodLocalId(itemId, self.m_tRideCircleReward[i][3], 17)
			tNewObj:setItemClickFun(self, self.onItemClick)
			tbCircleReward:setCellElement(element)
		end
	end
end

--@brief 	显示勋章
function WndBikeMatch:_showMedal()
	local txtCircle1 = GetElement(self.m_root, "txtCircle1_WndBikeMatch", WZUILabelTTF)
	local txtCircle2 = GetElement(self.m_root, "txtCircle2_WndBikeMatch", WZUILabelTTF)
	local txtCircle3 = GetElement(self.m_root, "txtCircle3_WndBikeMatch", WZUILabelTTF)
	local nCurCircle = self.m_nMedalCircle + self.m_nTurn * self.m_tMedalConfig[3]
	if txtCircle1 then 
		local nCircle = self.m_tMedalConfig[1] + self.m_nTurn * self.m_tMedalConfig[3]
		if nCurCircle >= self.m_tMedalConfig[1] + self.m_nTurn * self.m_tMedalConfig[3] then 
			nCircle = self.m_tMedalConfig[1] + (self.m_nTurn + 1) * self.m_tMedalConfig[3]
		end
		txtCircle1:setText(string.format(LocalStrings.BIKEMATCH_TEXT1[15], nCurCircle, nCircle))
	end

	if txtCircle2 then 
		local nCircle = self.m_tMedalConfig[2] + self.m_nTurn * self.m_tMedalConfig[3]
		if nCurCircle >= self.m_tMedalConfig[2] + self.m_nTurn * self.m_tMedalConfig[3] then 
			nCircle = self.m_tMedalConfig[2] + (self.m_nTurn + 1) * self.m_tMedalConfig[3]
		end
		txtCircle2:setText(string.format(LocalStrings.BIKEMATCH_TEXT1[15], nCurCircle, nCircle))
	end

	if txtCircle3 then 
		local nCircle = self.m_tMedalConfig[3] + self.m_nTurn * self.m_tMedalConfig[3]
		if nCurCircle >= self.m_tMedalConfig[3] + self.m_nTurn * self.m_tMedalConfig[3] then 
			nCircle = self.m_tMedalConfig[3] + (self.m_nTurn + 1) * self.m_tMedalConfig[3]
		end
		txtCircle3:setText(string.format(LocalStrings.BIKEMATCH_TEXT1[15], nCurCircle, nCircle))
	end
end

--@brief 	显示骑行距离
function WndBikeMatch:_showRideDis()
	local txtDis = GetElement(self.m_root, "txtDis_WndBikeMatch", WZUILabelTTF)
	local nCurCircleDis = self.m_nCurScore - (self.m_nTurn * self.m_tMedalConfig[3] + self.m_nCurCircle) * self.m_nTargetDis
	if txtDis then 
		txtDis:setText(nCurCircleDis .. "/" .. self.m_nTargetDis)
	end

	local nPercent = math.floor(nCurCircleDis/self.m_nTargetDis * 100)
	if nPercent > 100 then 
		nPercent = 100
	end
	GetElement(self.m_root, "prgRideDis_WndBikeMatch", WZUIProgress):setPercentage(nPercent)
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配模块Begin----------------------------------------

function WndBikeMatch:_adaptLanguage_vn()
	GetElement(self.m_root,"conCoin_WndBikeMatch",WZUIContainer):setRelativePosition(GlobalMethod:ccp(-0.08,0.5))
	GetElement(self.m_root,"btnBigReward_WndBikeMatch",WZUIButton):setRelativePosition(GlobalMethod:ccp(1.04,0.5))
	GetElement(self.m_root,"txtBtnTask1_WndBikeMatch",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtBtnTask3_WndBikeMatch",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtBtnOpenOne_WndBikeMatch",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtBtnOpenFive_WndBikeMatch",WZUILabelTTF):setScale(0.8)
end

-------------------------------------语言适配模块End----------------------------------------
