--WndDeepSea.lua
--@brief	WndDeepSea的UI模块
--@date		2023/08/15
--@author	XTX
--@note		深海寻宝活动主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndDeepSea:onEnter(element)
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
function WndDeepSea:onExit(element)
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
function WndDeepSea:onEnterTransitionDidFinish(element)
    WZLog("WndDeepSea:onEnterTransitionDidFinish")
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7089, 7089)
end

--@brief    关闭窗口
function WndDeepSea:onCloseClick(element)
	local eleType = type(element)
	if eleType ~= "number" then 
    	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    end

	SaveActivityPoleType("DEEPSEA", self.m_nCalabashType)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮回调
function WndDeepSea:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 	
	WndSingleMapDesc:showInterface1(LocalStrings.DEEPSEA_TEXT2) 
end

--@brief 	点击目标按钮回调
function WndDeepSea:onClickTask(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if SystemTime:getServerTime() >= self.m_nEndTime then 
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END) 
		self:onCloseClick(0)
		return 
	end 

	local nTag = element:getTag()
	if nTag == 1 then 
		CellNewYearTask:showInterface(35, self.m_nActivityId)
	elseif nTag == 2 then
		WndDollMachineShop:showInterface(10, self.m_nActivityId)
	elseif nTag == 3 then 
		WndShopRank:showInterface(52, self.m_nActivityId) 
	end
end

--@brief 	点击大奖预览按钮回调
function WndDeepSea:onClickBigReward(element)
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

	self.m_bIsOpenReward = true 
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 1, "")
end


--@brief 	点击开启按钮回调
function WndDeepSea:onClickFive(element) 
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
    if self.m_bOpenState then MsgBoxManager:showTipBox(LocalStrings.DEEPSEA_TEXT1[19]) return end 
    if self.m_nChooseReward == 0 then 
    	self:onClickBigReward(0)

		self.m_nChooseReward = 1
		SaveOperateTimes("DEEPSEAACTIVITYID", self.m_nActivityId)
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
	tData.grade = self.m_nCalabashType

	local stringData = json.encode(tData)

	self:setOpenState(true)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 3, stringData)
end

--@brief 	前往小推车购买
function WndDeepSea:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

--@brief 	点击切换浪板类型
function WndDeepSea:onChooseTool(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local nTag = element:getTag()
	if self.m_bOpenState then 
		GetElement(self.m_root, "cbgTool_WndDeepSea", WZUICheckBoxGroup):setCheckIndex(self.m_nCalabashType)
		return 
	end 
	if self.m_nCalabashType == nTag then return end 

	self.m_nCalabashType = nTag
	self:_setFreeBtnText()
	self:_setModeBg()
end

--@brief	点击物品弹出对应的tips
function WndDeepSea:onItemClick(tCell,tag,tData)
    if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData,false)
end

--@brief 	点击等级奖励按钮回调、
function WndDeepSea:onClickLvReward(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	GetElement(self.m_root, "conLvReward_WndDeepSea", WZUIContainer):setVisible(true)
	self:_createLvRewardList()
end

--@brief 	关闭捕鼠奖励界面
function WndDeepSea:onCloseTip(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	GetElement(self.m_root, "conLvReward_WndDeepSea", WZUIContainer):setVisible(false)
	self:showRedDot()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndDeepSea:_update()
	-- body
	self:_setFreeBtnText()
	self:showRedDot()
	self:_initActivityTime()
    self:_updateLightNum()
end

--@brief 	初始化静态文本
function WndDeepSea:_initStaticText()
	self.m_nCalabashType = GetActivityPoleType("DEEPSEA")
	if self.m_nCalabashType ~= 0 then 
		GetElement(self.m_root, "cbgTool_WndDeepSea", WZUICheckBoxGroup):setCheckIndex(self.m_nCalabashType)
	end
	self:_setModeBg()

	GetElement(self.m_root, "txtBtnTask1_WndDeepSea", WZUILabelTTF):setText(LocalStrings.DEEPSEA_TEXT1[2])
	GetElement(self.m_root, "txtBtnTask2_WndDeepSea", WZUILabelTTF):setText(LocalStrings.DEEPSEA_TEXT1[8])
	GetElement(self.m_root, "txtBtnTask3_WndDeepSea", WZUILabelTTF):setText(LocalStrings.DEEPSEA_TEXT1[3])
	GetElement(self.m_root, "txtBigReward_WndDeepSea", WZUILabelTTF):setText(LocalStrings.WATERMELON_TEXT1[22])
	GetElement(self.m_root, "txtLvRewardT_WndDeepSea", WZUILabelTTF):setText(LocalStrings.DEEPSEA_TEXT1[15])
	GetElement(self.m_root, "txtActivityWord_WndDeepSea", WZUILabelTTF):setText(LocalStrings.ACTIVE_TIME .. ":")

	self:_setBallAni()
end

--@brief 	红点
function WndDeepSea:showRedDot()
	-- body
	if self.m_root == nil then return end 

	local imgTaskRedDot = GetElement(self.m_root, "imgTaskRedDot_WndDeepSea", WZUIImage)
	local imgExpReddot = GetElement(self.m_root, "imgExpReddot_WndDeepSea", WZUIImage)

	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[117089] or GlobalGame.g_tRedPointTypeList[127089]) then 
		imgTaskRedDot:setVisible(true)
	else
		imgTaskRedDot:setVisible(false)
	end

	local bHaveRedDot = false 
	if self.m_tLvRewardList then 
		for i = 1, #self.m_tLvRewardList do
			if self.m_tLvRewardList[i].status == 1 then 
				bHaveRedDot = true 
				break 
			end
		end
	end

	imgExpReddot:setVisible(bHaveRedDot)
end

--@brief 	更新异火的数量
function WndDeepSea:_updateLightNum()
	-- body
	local ftxtLightNum = GetElement(self.m_root, "ftxtLightNum_WndDeepSea", WZUIFreeTextBox)
	local sFormat = [[<I Z="0.45" P="1">%s</I><T C="255,255,255" S="18" P="1" SC="163,74,20" SS="4" SE="1">%d</T>]]
	if ftxtLightNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
		ftxtLightNum:setShowText(string.format(sFormat, basicData.icon, nLightNum))
	end
end

--@brief 	初始化活动时间
function WndDeepSea:_initActivityTime()
	-- body
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndDeepSea", WZUILabelTTF)
    if txtActivityTime then 
    	txtActivityTime:setText(needDay_str)
    end
end

--@brief 	显示开启动画
function WndDeepSea:showOpenAction()
	-- body
	local spineOpen = GetElement(self.m_root, "spineOpen_WndDeepSea", WZUISpine)
	local spinePath = "activity/hd_pic_haidijiem"
	local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".json")

	if spineOpen then 
		if existSpine then 
			self:_setBowlingPlayAni()
			self:showShootReward()
		else
			self:showShootReward()
			self:setOpenState(false)
		end
	end
end

--@brief 	显示开启奖励
function WndDeepSea:showShootReward()
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
		strContent = strContent .. LocalStrings.DEEPSEA_TEXT1[18] .. "+" .. self.m_tOpenResult.addExp
	end

	if strContent ~= "" then 
		MsgBoxManager:showTipBox(strContent, nil, nil, nil, nil, nil, nil, nil, nil, GlobalMethod:ccp(0.5, 0.77))
	end

	self:_afterCloseReward()
end

--@brief 	iphoneX适配
function WndDeepSea:_adaptIphoneX()
	if IsIphoneX() then
		GetElement(self.m_root, "btnShop_WndDeepSea", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.08,0.42))
	end
end

--@brief 	设置免费丢
function WndDeepSea:_setFreeBtnText()
	local txtBtnOpenOne = GetElement(self.m_root, "txtBtnOpenOne_WndDeepSea", WZUILabelTTF)
	local txtBtnOpenFive = GetElement(self.m_root, "txtBtnOpenFive_WndDeepSea", WZUILabelTTF)

	local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local freeTimes = 0 
	local nTempTimes = math.floor(nLightNum/self.m_tCostByType[self.m_nCalabashType + 1])
	local nTimes = 0

	local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local freeTimes = 0 
	local nTempTimes = math.floor(nLightNum/self.m_tCostByType[self.m_nCalabashType + 1])
	local nTimes = 0
	local strTemp = LocalStrings.DEEPSEA_TEXT1[7]
	if self.m_nCalabashType == 0 then 
		if self.m_nCount > 0 then 
			freeTimes = 1
			txtBtnOpenOne:setText(LocalStrings.DEEPSEA_TEXT1[6])
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
function WndDeepSea:_setBallAni()
	local spinePath = "activity/hd_pic_haidijiem"
	local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".json")
	if existSpine then 
		local spineOpen = GetElement(self.m_root, "spineOpen_WndDeepSea", WZUISpine)
		if spineOpen then 
			spineOpen:setFileJson(spinePath .. ".json")
			spineOpen:setFileAtlas(spinePath .. ".atlas")
			spineOpen:play("wait3", true)
		end
		local spineWait = GetElement(self.m_root, "spineWait_WndDeepSea", WZUISpine)
		if spineWait then 
			spineWait:setFileJson(spinePath .. ".json")
			spineWait:setFileAtlas(spinePath .. ".atlas")
			spineWait:play("wait", true)
		end
	else
		local _sIndex = "hd_pic_haidijiem"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7089, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndDeepSea)
        end
	end
end

function WndDeepSea:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndDeepSea:downloadEffectCallback",taskId,extraData,failed)
    self:_setBallAni()
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndDeepSea:_setBowlingPlayAni()
	local spineOpen = GetElement(self.m_root, "spineOpen_WndDeepSea", WZUISpine)
	local conOpenAct = GetElement(self.m_root, "conOpenAct_WndDeepSea", WZUIContainer)

	if self.m_nCalabashType == 1 then 
		spineOpen:setRelativePosition(GlobalMethod:ccp(1.2, 0.5))
		spineOpen:setVisible(true)
	end
	local posList = {0.5, 0.7, 0.3}
	local durationReduce = GetRandomNum(3, 6, 1)

	for i = 1, self.m_nAniType do
		local data = {}
		data.path = "activity/hd_pic_haidijiem"
		if self.m_nCalabashType == 1 then 
			data.play = "wait2"
		else
			data.play = "wait1"
		end
		data.ccp = GlobalMethod:ccp(1.2, posList[i])
		data.loop = true 

		local spineFish = createEffectSpine(conOpenAct, data)
		spineFish:setTag(10 + i)

		if i == self.m_nAniType then 
			if spineFish then 
				local moveTo = WZUIActionMoveTo:create()
				moveTo:setMoveX(-0.05)
				moveTo:setMoveY(posList[i])
				moveTo:setDuration((3.2-durationReduce[i]/10)*0.5)
				spineFish:runUIAction(moveTo)
			else
				self:finishMove()
			end
		else
			if spineFish then 
				local moveTo = WZUIActionMoveTo:create()
				moveTo:setMoveX(-0.05)
				moveTo:setMoveY(posList[i])
				moveTo:setDuration((3.2-durationReduce[i]/10)*0.5)
				spineFish:runUIAction(moveTo)
			end
		end
	end
	WZLog("WndDeepSea:_setBowlingPlayAni", aniIndex, bLoop)

	local moveTo = WZUIActionMoveTo:create()
	moveTo:setMoveX(-0.3)
	moveTo:setMoveY(0.5)
	moveTo:setDuration(1.8)
	moveTo:setFinishLuaFunction("finishMove")
	moveTo:setFinishLuaTable(self)
	spineOpen:runUIAction(moveTo)
end

--@brief 	鱼移出屏幕后，删除动画
function WndDeepSea:finishMove(element)
	local spineOpen = GetElement(self.m_root, "spineOpen_WndDeepSea", WZUISpine)
	spineOpen:setVisible(false)
	local conOpenAct = GetElement(self.m_root, "conOpenAct_WndDeepSea", WZUIContainer)
	for i = 1, self.m_nAniType do
		local spineFish = conOpenAct:getChildByTag(10 + i)
		if spineFish then 
			conOpenAct:removeChildByTag(10 + i, true)
		end
	end
	spineOpen:setRelativePosition(GlobalMethod:ccp(1.2, 0.5))
	self:setOpenState(false)
end

--@brief 	显示等级、经验
function WndDeepSea:_showLvAndExp()
	local txtLevel = GetElement(self.m_root, "txtLevel_WndDeepSea", WZUILabelTTF)
	local txtLvTitle = GetElement(self.m_root, "txtLvTitle_WndDeepSea", WZUILabelTTF)
	local txtExp = GetElement(self.m_root, "txtExp_WndDeepSea", WZUILabelTTF)
	local prgExp = GetElement(self.m_root, "prgExp_WndDeepSea", WZUIProgress)

	local tCurInfo, tNextInfo, nMaxLv = self:getCurLvInfo()
	local strLvTitle = LocalStrings.DEEPSEA_TEXT1[17][1]
	if tCurInfo then 
		strLvTitle = tCurInfo.name 
	end
	txtLevel:setText("")
	txtLvTitle:setText(strLvTitle)
	if tCurInfo and tCurInfo.lv >= nMaxLv then 
		txtExp:setText("Max")
	else
		txtExp:setText(self.m_nCurExp .. "/" .. tNextInfo.exp)
	end

	local nPercentage = math.floor(100 * self.m_nCurExp/tNextInfo.exp)
	if nPercentage > 100 then 
		nPercentage = 100
	end
	prgExp:setPercentage(nPercentage)
end

--@brief 	创建捕鼠奖励
function WndDeepSea:_createLvRewardList()
	local tbLvRewardList = GetElement(self.m_root, "tbLvRewardList_WndDeepSea", WZUITableContainer)
	tbLvRewardList:cleanTable()

	for i = 1, #self.m_tLvRewardList do
		local element, tNewObj = CellLvRewardItem:createElement()
		if element and tNewObj then
			element:setTag(i - 1)
			tNewObj:setData(self.m_tLvRewardList[i], 4)

			tbLvRewardList:setCellElement(element)
		end
	end
end

--@brief 	设置背景模式
function WndDeepSea:_setModeBg()
	if self.m_nCalabashType == 0 then 
		GetElement(self.m_root, "imgBg_WndDeepSea", WZUIImage):setFile("ui/common_bg/hd_pic_hdxb_bg_01.png")
		GetElement(self.m_root, "img9Red_WndDeepSea", WZUI9Image):setVisible(false)
	else
		GetElement(self.m_root, "imgBg_WndDeepSea", WZUIImage):setFile("ui/common_bg/hd_pic_hdxb_bg_03.png")
		GetElement(self.m_root, "img9Red_WndDeepSea", WZUI9Image):setVisible(true)
	end
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配模块Begin----------------------------------------

function WndDeepSea:_adaptLanguage_vn()
	GetElement(self.m_root,"txtLevel_WndDeepSea",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"btnBigReward_WndDeepSea",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.98,0.5))
end

-------------------------------------语言适配模块End----------------------------------------
