--WndGolfball.lua
--@brief	WndGolfball的UI模块
--@date		2023/06/30
--@author	XTX
--@note		高尔夫活动主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndGolfball:onEnter(element)
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
function WndGolfball:onExit(element)
	g_bIsShowWndDressUp = true
    g_tTempItemForLaterShow = {}
	CacheCenter:unregisterUpatePlayerItemObserver(self)
	ProtocolProcessorFestivalActivity:unregAll6()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
	GlobalGame:getGameEventDispathcer():Remove(Independent_Activity.ActivityReddot, self.showRedDot, self)
	if self.m_root then 
		self.m_root:disableSchedule()
	end

	self:_unInit()
	LoadNewActivityRes(false)
end

--@brief    onenter函数已执行
function WndGolfball:onEnterTransitionDidFinish(element)
    WZLog("WndGolfball:onEnterTransitionDidFinish")
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7082, 7082)
	self.m_root:enableSchedule("_caculateTime", 1)
end

--@brief    关闭窗口
function WndGolfball:onCloseClick(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	self:savePoleType()
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮回调
function WndGolfball:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 	
	WndSingleMapDesc:showInterface1(LocalStrings.GOLFBALL_TEXT2) 
end

--@brief 	点击目标按钮回调
function WndGolfball:onClickTask(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if nTag == 1 then 
		CellNewYearTask:showInterface(30, self.m_nActivityId)
	elseif nTag == 2 then
		WndHouseInvite:showInterface(7, self.m_nActivityId)
	elseif nTag == 3 then 
		WndShopRank:showInterface(47, self.m_nActivityId) 
	end
end

--@brief 	点击大奖预览按钮回调
function WndGolfball:onClickBigReward(element)
	-- body	
	local eleType = type(element)
	if eleType ~= "number" then 
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	end

	self.m_bIsOpenReward = true 
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 1, "")
end


--@brief 	点击开启按钮回调
function WndGolfball:onClickFive(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if nTag == 5 then 
		if self.m_nAniType == 2 then 
			self.m_nAniType = 1
		else
			self.m_nAniType = 2
		end
		local btnFile = {"ui/newvip/common_btn_41_1.png", "ui/newvip/common_btn_42_1.png"}
		local btnWordsStrokeColor = {GlobalMethod:ccc3(163,74,20), GlobalMethod:ccc3(0,108,3)}
		local imgOpenBtn = GetElement(self.m_root, "imgOpenOneBtn_WndGolfball", WZUIImage)
		local txtBtnOpenOne = GetElement(self.m_root, "txtBtnOpenOne_WndGolfball", WZUILabelTTF)
		imgOpenBtn:setFile(btnFile[self.m_nAniType])
		txtBtnOpenOne:setStrokeColor(btnWordsStrokeColor[self.m_nAniType])
		self:_setFreeBtnText()
		return 
	end
	--背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
    if self.m_bOpenState then return end 

    if self.m_nChooseReward == 0 then 
    	self:onClickBigReward(nTag)

		self.m_nChooseReward = 1
		self:saveOperateTimes()
    	return 
    end

	local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local nTempTimes = math.floor(nArrowNum/self.m_tCostByType[self.m_nCalabashType + 1])
	local nTimes = nTag
	local freeCount = 0
	if self.m_nCalabashType == 0 then 
		freeCount = self.m_nCount > 0 and 1 or 0 
	end
	if self.m_nAniType == 2 then 
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
function WndGolfball:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

--@brief 	点击切换浪板类型
function WndGolfball:onChooseTool(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local nTag = element:getTag()
	if self.m_bOpenState then return end 
	if self.m_nCalabashType == nTag then return end 

	self.m_nCalabashType = nTag
	self:_setFreeBtnText()
	self:_setBowlingPlayAni(1, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndGolfball:_update()
	-- body
	self:_setFreeBtnText()
	self:showRedDot()
	self:_initActivityTime()
    self:_updateLightNum()
end

--@brief 	初始化静态文本
function WndGolfball:_initStaticText()
	self:getPoleType()

	GetElement(self.m_root, "txtBtnTask1_WndGolfball", WZUILabelTTF):setText(LocalStrings.GOLFBALL_TEXT1[2])
	GetElement(self.m_root, "txtBtnTask2_WndGolfball", WZUILabelTTF):setText(LocalStrings.GOLFBALL_TEXT1[4])
	GetElement(self.m_root, "txtBtnTask3_WndGolfball", WZUILabelTTF):setText(LocalStrings.GOLFBALL_TEXT1[3])
	GetElement(self.m_root, "txtBigReward_WndGolfball", WZUILabelTTF):setText(LocalStrings.WATERMELON_TEXT1[22])

	self:_setBallAni()
end

--@brief 	红点
function WndGolfball:showRedDot()
	-- body
	if self.m_root == nil then return end 

	local imgTaskRedDot = GetElement(self.m_root, "imgTaskRedDot_WndGolfball", WZUIImage)
	local imgNoteRedDot = GetElement(self.m_root, "imgNoteRedDot_WndGolfball", WZUIImage)

	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[217082] or GlobalGame.g_tRedPointTypeList[227082] or GlobalGame.g_tRedPointTypeList[237082]) then 
		imgTaskRedDot:setVisible(true)
	else
		imgTaskRedDot:setVisible(false)
	end

	if GlobalGame.g_tRedPointTypeList and GlobalGame.g_tRedPointTypeList[17082] then 
		imgNoteRedDot:setVisible(true)
	else
		imgNoteRedDot:setVisible(false)
	end
end

--@brief 	更新异火的数量
function WndGolfball:_updateLightNum()
	-- body
	local ftxtLightNum = GetElement(self.m_root, "ftxtLightNum_WndGolfball", WZUIFreeTextBox)
	local sFormat = [[<I Z="0.5" P="1">%s</I><T C="255,236,193" S="20" P="1" SC="132,66,29" SS="4" SE="1">%d</T>]]
	if ftxtLightNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
		ftxtLightNum:setShowText(string.format(sFormat, basicData.icon, nLightNum))
	end
end

--@brief 	初始化活动时间
function WndGolfball:_initActivityTime()
	-- body
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndGolfball", WZUILabelTTF)
    if txtActivityTime then 
    	txtActivityTime:setText(needDay_str)
    end
end

--@brief 	显示开启动画
function WndGolfball:showOpenAction()
	-- body
	local spineOpen = GetElement(self.m_root, "spineOpen_WndGolfball", WZUISpine)
	local spinePath = "activity/hd_pic_gaoerfu"
	local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".json")

	if spineOpen then 
		if existSpine then 
			local aniIndex = self.m_nAniType + 1 
			self:_setBowlingPlayAni(aniIndex, false)
			local nSeconds = 1.2
			spineOpen:enableSchedule("showShootReward", nSeconds)
		else
			self:showShootReward()
		end
	end
end

--@brief 	显示开启奖励
function WndGolfball:showShootReward()
	-- body
	local spineOpen = GetElement(self.m_root, "spineOpen_WndGolfball", WZUISpine)
	spineOpen:disableSchedule()
	self:_setBowlingPlayAni(1, true)

	local strContent = ""
	local nIndex = 0 
	if self.m_tOpenResult.addExp and self.m_tOpenResult.addExp > 0 then 
		strContent = strContent .. LocalStrings.GOLFBALL_TEXT1[19] .. "+" .. self.m_tOpenResult.addExp 
		nIndex = nIndex + 1
	end

	if strContent ~= "" then 
		MsgBoxManager:showTipBox(strContent, nil, nil, nil, nil, nil, nil, nil, nil, GlobalMethod:ccp(0.5, 0.77))
	end

	self:setOpenState(false)
	self:_afterCloseReward()
end

--@brief 	iphoneX适配
function WndGolfball:_adaptIphoneX()
	if IsIphoneX() then
		GetElement(self.m_root, "conLeftMenu_WndGolfball", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.98,0))
	end
end

--@brief 	设置免费丢
function WndGolfball:_setFreeBtnText()
	local txtBtnOpenOne = GetElement(self.m_root, "txtBtnOpenOne_WndGolfball", WZUILabelTTF)

	local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local freeTimes = 0 
	local nTempTimes = math.floor(nLightNum/self.m_tCostByType[self.m_nCalabashType + 1])
	local nTimes = 0
	if self.m_nAniType == 1 then 
		if self.m_nCount > 0 and self.m_nCalabashType == 0 then 
			freeTimes = 1
			txtBtnOpenOne:setText(LocalStrings.GOLFBALL_TEXT1[6])
		else
			txtBtnOpenOne:setText(string.format(LocalStrings.GOLFBALL_TEXT1[7], 1))
		end
	else
		nTimes = (nTempTimes + freeTimes) >= self.m_nMaxLotteryCount and self.m_nMaxLotteryCount or nTempTimes > 0 and (nTempTimes + freeTimes) or self.m_nMaxLotteryCount 
		txtBtnOpenOne:setText(string.format(LocalStrings.GOLFBALL_TEXT1[7], nTimes))
	end
end

--@brief 	设置待机特效
function WndGolfball:_setBallAni()
	local spinePath = "activity/hd_pic_gaoerfu"
	local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".json")
	if existSpine then 
		local spineOpen = GetElement(self.m_root, "spineOpen_WndGolfball", WZUISpine)
		if spineOpen then 
			spineOpen:setFileJson(spinePath .. ".json")
			spineOpen:setFileAtlas(spinePath .. ".atlas")
			self:_setBowlingPlayAni(1, true)
		end
	else
		local _sIndex = "hd_pic_gaoerfu"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7082, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndGolfball)
        end
	end

	local spinePath2 = "activity/hd_pic_gaoerfubj"
	local existSpine2 = WZDataFile:getInstance():checkFileExist(spinePath2 .. ".json")
	if existSpine2 then 
		local spineWait = GetElement(self.m_root, "spineWait_WndGolfball", WZUISpine)
		if spineWait then 
			spineWait:setFileJson(spinePath2 .. ".json")
			spineWait:setFileAtlas(spinePath2 .. ".atlas")
			spineWait:play("wait", true)
		end
	else
		local _sIndex = "hd_pic_gaoerfubj"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(70820, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndGolfball)
        end
	end
end

function WndGolfball:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndGolfball:downloadEffectCallback",taskId,extraData,failed)
    self:_setBallAni()
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndGolfball:_setBowlingPlayAni(aniIndex, bLoop)
	local spineOpen = GetElement(self.m_root, "spineOpen_WndGolfball", WZUISpine)
	aniIndex = aniIndex or 1
	WZLog("WndGolfball:_setBowlingPlayAni", aniIndex, bLoop)

	if spineOpen then 
		spineOpen:play(self.m_tBallAniName[self.m_nCalabashType + 1][aniIndex], bLoop ~= nil and bLoop or true)
	end
end
--@brief 	显示咖啡师的对话
--@param 	state:0没有触发礼包；1触发了礼包
function WndGolfball:_showTalk(state)
	local conTalk = GetElement(self.m_root, "conTalk_WndGolfball", WZUIContainer)
	conTalk:setVisible(true)

	local txtTalk = GetElement(self.m_root, "txtTalk_WndGolfball", WZUILabelTTF)
	local tTalkList = LocalStrings.GOLFBALL_TEXT1[21 + state]
	local nCount = #tTalkList
	local tempRand = math.random(1, 10)
	local strIndex = math.fmod(tempRand, nCount) + 1
	if self.m_nLastTalkIndex == strIndex or self.m_nTalkGapping ~= nil then return end 
	self.m_nLastTalkIndex = strIndex
	self.m_nTalkGapping = 3
	txtTalk:setText(tTalkList[strIndex] or tTalkList[1])
end

--@brief 	计时器
function WndGolfball:_caculateTime()
	-- body
	if self.m_nTalkGapping == nil then return end 

	if self.m_nTalkGapping > 0 then 
		self.m_nTalkGapping = self.m_nTalkGapping - 1
	else
		self.m_nTalkGapping = nil 
		self.m_nLastTalkIndex = 0
		GetElement(self.m_root, "conTalk_WndGolfball", WZUIContainer):setVisible(false)
	end
end




-------------------------------------私有方法模块End----------------------------------------


function WndGolfball:_adaptLanguage_vn()
	GetElement(self.m_root,"txtBtnOpenOne_WndGolfball",WZUILabelTTF):setScale(0.65)
	GetElement(self.m_root,"txtBtnTask1_WndGolfball",WZUILabelTTF):setScale(0.8)
end