--WndWatermelon.lua
--@brief	WndWatermelon的UI模块
--@date		2022/06/24
--@author	XTX
--@note		夏日西瓜活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndWatermelon:onEnter(element)
	self.m_root = element

	g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
	ProtocolProcessorFestivalActivity:regAll6()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)

	self:_initStaticText()
	self:_adaptIphoneX()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndWatermelon:onExit(element)
	g_bIsShowWndDressUp = true
    g_tTempItemForLaterShow = {}
	CacheCenter:unregisterUpatePlayerItemObserver(self)
	ProtocolProcessorFestivalActivity:unregAll6()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)

	self:_unInit()
	LoadNewActivityRes(false)
end

--@brief    onenter函数已执行
function WndWatermelon:onEnterTransitionDidFinish(element)
    WZLog("WndWatermelon:onEnterTransitionDidFinish")
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7051, 7051)
end

--@brief    关闭窗口
function WndWatermelon:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    --如果是自动弹出的活动界面
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮回调
function WndWatermelon:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 
    WndSingleMapDesc:showInterface1(LocalStrings.WATERMELON_TEXT2) 
end

--@brief 	点击目标按钮回调
function WndWatermelon:onClickTask(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if nTag == 1 then 
		CellNewYearTask:showInterface(14, self.m_nActivityId)
	elseif nTag == 2 then
		WndWatermelonShake:showInterface(self.m_nActivityId)
	elseif nTag == 3 then 
		WndShopRank:showInterface(27, self.m_nActivityId) 
	end
end

--@brief 	点击大奖预览按钮回调
function WndWatermelon:onClickBigReward(element)
	-- body
	local eleType = type(element)
	if eleType ~= "number" then 
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	end

	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, "")
end

--@brief 	点击开启按钮回调
function WndWatermelon:onClickFive(element)
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
		SaveOperateTimes("WATERMELONACTIVITYID", self.m_nActivityId)
    	return 
    end

	local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local nTempTimes = nArrowNum
	local nCostTimes = self.m_tCostTimes[self.m_nWatermelonType + 1]--抽奖一次相应需要消耗的卷数
	if self.m_nWatermelonType == 0 then 
		nTempTimes = math.floor(nArrowNum/nCostTimes)
	elseif self.m_nWatermelonType == 2 then
		nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId2)
		nTempTimes = nArrowNum
	end
	local nTimes = nTag
	if nTag == 5 then 
		nTag = 20 
		nTimes = nTempTimes >= 20 and 20 or nTempTimes > 0 and nTempTimes or 20 
	end
	local nCostNum = nTimes
	if self.m_nWatermelonType == 0 then
		nCostNum = nTimes * nCostTimes
	end
	if nCostNum > nArrowNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		if self.m_nWatermelonType == 2 then
			basicData = GDatatab_item["id_" .. self.m_nCoinId2]
			MsgBoxManager:showTipBox(string.format(LocalStrings.CARD_COUNT1, basicData.name))
			return 
		end
		MsgBoxManager:showConfirmBox(string.format(LocalStrings.WATERCOUNTRY_TEXT4, basicData.name), self, self.goToBuy)
		return 
	end
    local tData = {}
	tData.times = nTag
	tData.grade = self.m_nWatermelonType

	local stringData = json.encode(tData)

	self:setOpenState(true)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 3, stringData)
end

--@brief 	前往小推车购买
function WndWatermelon:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

--@brief 	点击切换场地等级回调
function WndWatermelon:onChooseTool(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local nTag = element:getTag()
	self.m_nWatermelonType = nTag
	self:_setFreeBtnText()
	if not self.m_bOpenState then 
		self:_updateLightNum()
		self:_setBowlingPlayAni(1, true)
	end
end

--@brief 	点击赛事礼包按钮回调
function WndWatermelon:onClickGift(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_nGiftRewardNum >= 1 then
		--背包已满提示
	    if CacheCenter:getRemainAmount() <= 0 then
	        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
	        return
	    end
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 6, "")
	else
		local tData = {}
		tData.txtTitle = LocalStrings.WATERMELON_TEXT1[21]
		tData.nType = 2
		WndTips:show(element, self.m_root, 52, tData, GlobalMethod:ccp(50,80), true)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndWatermelon:_update()
	-- body
	self:_setFreeBtnText()
	self:showRedDot()
	self:_initActivityTime()
    self:_updateLightNum()
    if self.m_bIsFirstIn then 
		self.m_bIsFirstIn = false 
		self:_setBowlingPlayAni(1, true)
	end
	self:showBagGiftInfo()
end

--@brief 	初始化静态文本
function WndWatermelon:_initStaticText()
	GetElement(self.m_root, "txtBtnTask1_WndWatermelon", WZUILabelTTF):setText(LocalStrings.WATERMELON_TEXT1[2])
	GetElement(self.m_root, "txtBtnTask3_WndWatermelon", WZUILabelTTF):setText(LocalStrings.WATERMELON_TEXT1[3])
	GetElement(self.m_root, "txtBtnTask2_WndWatermelon", WZUILabelTTF):setText(LocalStrings.WATERMELON_TEXT1[15])

	GetElement(self.m_root, "txtWatermelon1_WndWatermelon", WZUILabelTTF):setText(LocalStrings.WATERMELON_TEXT1[11])
	GetElement(self.m_root, "txtWatermelon1Sel_WndWatermelon", WZUILabelTTF):setText(LocalStrings.WATERMELON_TEXT1[11])
	GetElement(self.m_root, "txtWatermelon2_WndWatermelon", WZUILabelTTF):setText(LocalStrings.WATERMELON_TEXT1[12])
	GetElement(self.m_root, "txtWatermelon2Sel_WndWatermelon", WZUILabelTTF):setText(LocalStrings.WATERMELON_TEXT1[12])
	GetElement(self.m_root, "txtWatermelon3_WndWatermelon", WZUILabelTTF):setText(LocalStrings.WATERMELON_TEXT1[13])
	GetElement(self.m_root, "txtWatermelon3Sel_WndWatermelon", WZUILabelTTF):setText(LocalStrings.WATERMELON_TEXT1[13])

	GetElement(self.m_root, "txtYearBigReward_WndWatermelon", WZUILabelTTF):setText(LocalStrings.WATERMELON_TEXT1[14])
	GetElement(self.m_root, "txtChooseAtt1_WndWatermelon", WZUILabelTTF):setText(LocalStrings.WATERMELON_TEXT1[10])
	GetElement(self.m_root, "txtChooseAtt2_WndWatermelon", WZUILabelTTF):setText(LocalStrings.WATERMELON_TEXT1[10])
	GetElement(self.m_root, "txtChooseAtt3_WndWatermelon", WZUILabelTTF):setText(LocalStrings.WATERMELON_TEXT1[10])

	self:_setBallAni()
end

--@brief 	红点
function WndWatermelon:showRedDot()
	-- body
	if self.m_root == nil then return end 

	local imgTaskRedDot = GetElement(self.m_root, "imgTaskRedDot_WndWatermelon", WZUIImage)

	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[117051] or GlobalGame.g_tRedPointTypeList[127051]) then 
		imgTaskRedDot:setVisible(true)
	else
		imgTaskRedDot:setVisible(false)
	end
end

--@brief 	更新异火的数量
function WndWatermelon:_updateLightNum()
	-- body
	local ftxtLightNum = GetElement(self.m_root, "ftxtLightNum_WndWatermelon", WZUIFreeTextBox)
	local sFormat = [[<I Z="0.5" P="1">%s</I><T C="255,255,255" S="20" P="1" SC="132,66,29" SS="4" SE="1">%d</T>]]
	if ftxtLightNum then 
		local nCostId = self.m_nCoinId
		if self.m_nWatermelonType == 2 then 
			nCostId = self.m_nCoinId2
		end
		local basicData = GDatatab_item["id_" .. nCostId]
		local nLightNum = CacheCenter:getPlayerItemCountById(nCostId)
		ftxtLightNum:setShowText(string.format(sFormat, basicData.icon, nLightNum))
	end
end

--@brief 	初始化活动时间
function WndWatermelon:_initActivityTime()
	-- body
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndWatermelon", WZUILabelTTF)
    if txtActivityTime then 
    	txtActivityTime:setText(LocalStrings.ACTIVITY_TIME_KEY .. ":" .. needDay_str)
    end
end

--@brief 	显示开启动画
function WndWatermelon:showOpenAction()
	-- body
	--创建选中特效
	local spinePath = "activity/UI_xigua_1"
	local existSpine = CheckEffectFile(spinePath)
	if not existSpine then 
		local _sIndex = "UI_xigua_1"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7051, downloadInfo.url, downloadInfo.md5, _sIndex, "DownloadResourceCallback", _G)
        end
	end

	local spineOpen = GetElement(self.m_root, "spineOpen_WndWatermelon", WZUISpine)
	if spineOpen then 
		if existSpine then 
			self:_setBowlingPlayAni(2, false)
			local nDelayTime = 1.2
			if self.m_nWatermelonType == 0 then 
				nDelayTime = 2.8
			elseif self.m_nWatermelonType == 2 then 
				nDelayTime = 1.8
			end
			spineOpen:enableSchedule("showShootReward", nDelayTime)
		else
			self:showShootReward()
		end
	end
end

--@brief 	显示开启奖励
function WndWatermelon:showShootReward()
	-- body
	local spineOpen = GetElement(self.m_root, "spineOpen_WndWatermelon", WZUISpine)
	spineOpen:disableSchedule()
	self:_setBowlingPlayAni(1, true)

	local strGoods = ""
	--击中多少球
	if self.m_tOpenResult.medalNum > 0 then 
		local basicData = GDatatab_item["id_160278"]
		strGoods = LocalStrings.CRAZY_DOUBLING_TEXT8 .. basicData.name .. "*" .. self.m_tOpenResult.medalNum
		MsgBoxManager:showTipBox(strGoods, nil, nil, nil, nil, nil, nil, nil, nil, {x=0.5, y=0.78})
	end
	
	WndRewardShow:showById(self.m_tOpenResult.normalRewards.itemIds,self.m_tOpenResult.normalRewards.itemNums)
	WndRewardShow:closeCallBack(self, self._afterCloseReward)
	self:setOpenState(false)
end

--@brief 	iphoneX适配
function WndWatermelon:_adaptIphoneX()
	if IsIphoneX() then
		GetElement(self.m_root, "conLeftMenu_WndWatermelon", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.08,0.45))
	end
end

--@brief 	设置免费丢
function WndWatermelon:_setFreeBtnText()
	local txtBtnOpenOne = GetElement(self.m_root, "txtBtnOpenOne_WndWatermelon", WZUILabelTTF)
	local txtBtnOpenFive = GetElement(self.m_root, "txtBtnOpenFive_WndWatermelon", WZUILabelTTF)
	local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)

	local nTempTimes = nLightNum
	local nTimes = 0
	local strContent = nil 
	local nCostTimes = self.m_tCostTimes[self.m_nWatermelonType + 1]--抽奖一次相应需要消耗的卷数
	if self.m_nWatermelonType == 1 then 
		strContent = LocalStrings.WATERMELON_TEXT1[7]
		nTimes = nTempTimes >= 20 and 20 or nTempTimes > 0 and nTempTimes or 20 
	elseif self.m_nWatermelonType == 0 then 
		strContent = LocalStrings.WATERMELON_TEXT1[6]
		nTempTimes = math.floor(nLightNum/nCostTimes)
		nTimes = nTempTimes >= 20 and 20 or nTempTimes > 0 and nTempTimes or 20 
	else
		strContent = LocalStrings.WATERMELON_TEXT1[5]
		nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId2)
		nTempTimes = nLightNum
		nTimes = nTempTimes >= 20 and 20 or nTempTimes > 0 and nTempTimes or 20 
	end
	txtBtnOpenOne:setText(string.format(strContent, 1))
	txtBtnOpenFive:setText(string.format(strContent, nTimes))
end

--@brief 	设置待机特效
function WndWatermelon:_setBallAni()
	local spinePath = "activity/UI_xigua_1"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		local spineOpen = GetElement(self.m_root, "spineOpen_WndWatermelon", WZUISpine)
		if spineOpen then 
			spineOpen:setFileJson(spinePath .. ".json")
			spineOpen:setFileAtlas(spinePath .. ".atlas")
		end
	else
		local _sIndex = "UI_xigua_1"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7051, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndWatermelon)
        end
	end
end

function WndWatermelon:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndWatermelon:downloadEffectCallback",taskId,extraData,failed)
    self:_setBallAni()
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndWatermelon:_setBowlingPlayAni(aniIndex, bLoop)
	local spineOpen = GetElement(self.m_root, "spineOpen_WndWatermelon", WZUISpine)
	aniIndex = aniIndex or 1
	WZLog("WndWatermelon:_setBowlingPlayAni", self.m_nWatermelonType, self.m_PaintedTimeAniIndex, aniIndex, bLoop)
	if spineOpen then 
		spineOpen:play(self.m_tAniAction[aniIndex][self.m_nWatermelonType + 1], bLoop ~= nil and bLoop or true)
	end
end

--@brief 	刷新赛事礼包的信息
function WndWatermelon:showBagGiftInfo()
	-- body
	if self.m_nGiftRewardNum > 0 then 
		GetElement(self.m_root, "imgGiftRed_WndWatermelon", WZUIImage):setVisible(true)
		GetElement(self.m_root, "txtGiftNum_WndWatermelon", WZUILabelTTF):setText(self.m_nGiftRewardNum)
	else
		GetElement(self.m_root, "imgGiftRed_WndWatermelon", WZUIImage):setVisible(false)
	end
end


-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配Begin----------------------------------------

function WndWatermelon:_adaptLanguage_vn()
	GetElement(self.m_root, "txtYearBigReward_WndWatermelon", WZUILabelTTF):setScale(0.7)
	local txtBtnTask1 = GetElement(self.m_root, "txtBtnTask1_WndWatermelon", WZUILabelTTF)
	txtBtnTask1:setDimensions(GlobalMethod:CCSize(140,0))
	txtBtnTask1:setScale(0.6)
	local txtBtnTask2 = GetElement(self.m_root, "txtBtnTask2_WndWatermelon", WZUILabelTTF)
	txtBtnTask2:setDimensions(GlobalMethod:CCSize(140,0))
	txtBtnTask2:setScale(0.6)
	local txtBtnTask3 = GetElement(self.m_root, "txtBtnTask3_WndWatermelon", WZUILabelTTF)
	txtBtnTask3:setDimensions(GlobalMethod:CCSize(140,0))
	txtBtnTask3:setScale(0.6)

	GetElement(self.m_root,"btnBigReward_WndWatermelon",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.95,0.5))
	GetElement(self.m_root,"btnTip_WndWatermelon",WZUIButton):setRelativePosition(GlobalMethod:ccp(1.124,0.5))
end

-------------------------------------语言适配End----------------------------------------


