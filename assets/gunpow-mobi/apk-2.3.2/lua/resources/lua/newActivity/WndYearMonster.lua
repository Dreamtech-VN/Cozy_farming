--WndYearMonster.lua
--@brief	WndYearMonster的UI模块
--@date		2021/12/09
--@author	XTX
--@note		年兽大作战活动主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndYearMonster:onEnter(element)
	self.m_root = element
	g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
	ProtocolProcessorFestivalActivity:regAll6()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)

	self.m_root:enableSchedule("timeCaculate", 1)
	self:_initStaticText()

	self:_adaptIphoneX()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndYearMonster:onExit(element)
	g_bIsShowWndDressUp = true
    g_tTempItemForLaterShow = {}
	CacheCenter:unregisterUpatePlayerItemObserver(self)
	ProtocolProcessorFestivalActivity:unregAll6()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
	if self.m_root then 
		self.m_root:disableSchedule()
	end

	self:_unInit()
	LoadNewActivityRes(false)
end
--@brief    onenter函数已执行
function WndYearMonster:onEnterTransitionDidFinish(element)
    WZLog("WndYearMonster:onEnterTransitionDidFinish")
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7035, 7035)
    self:showRedDot()
end

--@brief    关闭窗口
function WndYearMonster:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    --如果是自动弹出的活动界面
   WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮回调
function WndYearMonster:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 
    WndSingleMapDesc:showInterface1(LocalStrings.YEARMONSTER_TEXT2) 
end

--@brief 	点击目标按钮回调
function WndYearMonster:onClickTask(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if nTag == 1 then 
		CellNewYearTask:showInterface(5, self.m_nActivityId)
	elseif nTag == 2 then
		WndDollMachineShop:showInterface(2, self.m_nActivityId)
	elseif nTag == 3 then 
		WndShopRank:showInterface(15, self.m_nActivityId) 
	end
end

--@brief 	点击大奖预览按钮回调
function WndYearMonster:onClickBigReward(element)
	-- body
	local eleType = type(element)
	if eleType ~= "number" then 
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	end

	local otherData = {}
	otherData.winType = 1
	otherData.activityId = self.m_nActivityId
	otherData.chooseInfo = {strKey=LocalStrings.YEARMONSTER_TEXT1[1] .. LocalStrings.ACTIVITY_TEXT19, doType=8}
	WndJoinReward:showInterface("", self.m_tBigRewardList[1], self.m_tBigRewardList[2], LocalStrings.TREASURE_TEXT7, nil, 2, otherData, 2)
end

--@brief 	点击开启按钮回调
function WndYearMonster:onClickFive(element)
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
		SaveOperateTimes("YEARMONSTERACTIVITYID", self.m_nActivityId)
    	return 
    end

	local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	if nTag > nArrowNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		MsgBoxManager:showConfirmBox(string.format(LocalStrings.WATERCOUNTRY_TEXT4, basicData.name), self, self.goToBuy)
		return 
	end
    local tData = {}
	tData.times = nTag
	tData.version = self.m_nMonsterIndex

	local stringData = json.encode(tData)

	self:setOpenState(true)
	self.m_nUpdateInterval = 0 
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 3, stringData)
end

--@brief 	前往小推车购买
function WndYearMonster:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

--@brief 	点击赛事礼包按钮回调
function WndYearMonster:onClickGift(element)
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
		tData.txtTitle = LocalStrings.YEARMONSTER_TEXT1[8]
		tData.nType = 2
		WndTips:show(element, self.m_root, 52, tData, GlobalMethod:ccp(50,80), true)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndYearMonster:_update()
	-- body
	self:_initActivityTime()
    self:_updateLightNum()
end

--@brief 	初始化静态文本
function WndYearMonster:_initStaticText()
	self.m_nUpdateInterval = 0 

	GetElement(self.m_root, "txtBtnOpenOne_WndYearMonster", WZUILabelTTF):setText(string.format(LocalStrings.YEARMONSTER_TEXT1[7], 1))
	GetElement(self.m_root, "txtBtnOpenFive_WndYearMonster", WZUILabelTTF):setText(string.format(LocalStrings.YEARMONSTER_TEXT1[7], 5))
	GetElement(self.m_root, "txtBtnTask1_WndYearMonster", WZUILabelTTF):setText(LocalStrings.YEARMONSTER_TEXT1[2])
	GetElement(self.m_root, "txtBtnTask2_WndYearMonster", WZUILabelTTF):setText(LocalStrings.YEARMONSTER_TEXT1[3])
	GetElement(self.m_root, "txtBtnTask3_WndYearMonster", WZUILabelTTF):setText(LocalStrings.YEARMONSTER_TEXT1[4])
	GetElement(self.m_root, "txtBtnTaskSel1_WndYearMonster", WZUILabelTTF):setText(LocalStrings.YEARMONSTER_TEXT1[2])
	GetElement(self.m_root, "txtBtnTaskSel2_WndYearMonster", WZUILabelTTF):setText(LocalStrings.YEARMONSTER_TEXT1[3])
	GetElement(self.m_root, "txtBtnTaskSel3_WndYearMonster", WZUILabelTTF):setText(LocalStrings.YEARMONSTER_TEXT1[4])
	GetElement(self.m_root, "txtYearBigReward_WndYearMonster", WZUILabelTTF):setText(LocalStrings.YEARMONSTER_TEXT1[5])
	GetElement(self.m_root, "txtHpWord_WndYearMonster", WZUILabelTTF):setText(LocalStrings.YEARMONSTER_TEXT1[6])
end

--@brief 	红点
function WndYearMonster:showRedDot()
	-- body
	if self.m_root == nil then return end 

	local imgTaskRedDot = GetElement(self.m_root, "imgTaskRedDot_WndYearMonster", WZUIImage)
	local imgCardRedDot = GetElement(self.m_root, "imgCardRedDot_WndYearMonster", WZUIImage)

	if GlobalGame.g_tRedPointTypeList[117035] or GlobalGame.g_tRedPointTypeList[127035] then 
		imgTaskRedDot:setVisible(true)
	else
		imgTaskRedDot:setVisible(false)
	end
	if GlobalGame.g_tRedPointTypeList[27035] then 
		imgCardRedDot:setVisible(true)
	else
		imgCardRedDot:setVisible(false)
	end
end

--@brief 	更新灯火的数量
function WndYearMonster:_updateLightNum()
	-- body
	local ftxtLightNum = GetElement(self.m_root, "ftxtLightNum_WndYearMonster", WZUIFreeTextBox)
	if ftxtLightNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		local sFormat = [[<I Z="0.5" P="1">%s</I><T C="255,255,255" S="20" P="1" SC="132,66,29" SS="4" SE="1">%d</T>]]
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
		ftxtLightNum:setShowText(string.format(sFormat, basicData.icon, nLightNum))
	end
end

--@brief 	初始化活动时间
function WndYearMonster:_initActivityTime()
	-- body
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndYearMonster", WZUILabelTTF)
    if txtActivityTime then 
    	txtActivityTime:setText(LocalStrings.ACTIVITY_TIME_KEY .. ":" .. needDay_str)
    end
end

--@brief 	刷新赛事礼包的信息
function WndYearMonster:showBagGiftInfo()
	-- body
	if self.m_nGiftRewardNum > 0 then 
		GetElement(self.m_root, "spineGift_WndYearMonster", WZUISpine):setVisible(true)
		GetElement(self.m_root, "imgGiftRed_WndYearMonster", WZUIImage):setVisible(true)
		GetElement(self.m_root, "txtGiftNum_WndYearMonster", WZUILabelTTF):setText(self.m_nGiftRewardNum)
	else
		GetElement(self.m_root, "spineGift_WndYearMonster", WZUISpine):setVisible(false)
		GetElement(self.m_root, "imgGiftRed_WndYearMonster", WZUIImage):setVisible(false)
	end
end

--@brief 	更新年兽血量
function WndYearMonster:_updateMonsterBlood()
	local prgHp = GetElement(self.m_root, "prgHp_WndYearMonster", WZUIProgress)
	local txtHpValue = GetElement(self.m_root, "txtHpValue_WndYearMonster", WZUILabelTTF)

	local nPercentage = math.floor(100 * self.m_nCurHp/self.m_nMaxHp)
	prgHp:setPercentage(nPercentage)
	txtHpValue:setText(self.m_nCurHp .. "/" .. self.m_nMaxHp)
end

--@brief 	显示开启动画
function WndYearMonster:showOpenAction()
	-- body
	local conOpenAct = GetElement(self.m_root, "conOpenAct_WndYearMonster", WZUIContainer)
	conOpenAct:setVisible(true)
	local spineBow = GetElement(self.m_root, "spineOpen_WndYearMonster", WZUISpine)
	if spineBow then 
		spineBow:play("attack", false)
		conOpenAct:enableSchedule("showShootReward", 0.7)
	end
end

--@brief 	显示开启奖励
function WndYearMonster:showShootReward()
	-- body
	local conOpenAct = GetElement(self.m_root, "conOpenAct_WndYearMonster", WZUIContainer)
	conOpenAct:disableSchedule()

	local spineBow = GetElement(self.m_root, "spineOpen_WndYearMonster", WZUISpine)
	spineBow:play("wait", true)
	self:setOpenState(false)
	WndRewardShow:showById(self.m_tOpenResult.itemIds, self.m_tOpenResult.itemNums)
	WndRewardShow:closeCallBack(self, self._afterCloseReward)
	if self.m_tOpenResult.ysqNum > 0 then 
		local name = GDatatab_item["id_" .. 160186].name
		MsgBoxManager:showTipBox(string.format(LocalStrings.YEARMONSTER_TEXT1[11], name, self.m_tOpenResult.ysqNum), nil, nil, nil, nil, nil, nil, nil, nil, {x=0.5, y=0.78})
	end
end

--@brief 	更新年兽类型
function WndYearMonster:updateMonsterType()
	local imgType = GetElement(self.m_root, "imgType_WndYearMonster", WZUIImage)
	imgType:setFile(self.m_tMonsterType[self.m_nMonsterType])

	local txtMonsterIndex = GetElement(self.m_root, "txtMonsterIndex_WndYearMonster", WZUILabelTTF)
	txtMonsterIndex:setText(string.format(LocalStrings.YEARMONSTER_TEXT1[10], self.m_nMonsterIndex))

	if self.m_nLastMonsterType ~= self.m_nMonsterType then 
		local spineBow = GetElement(self.m_root, "spineOpen_WndYearMonster", WZUISpine)
		spineBow:setFileAtlas("")
		spineBow:setFileJson("")
		local pathName = "activity/" .. self.m_tMonsterTypeAni[self.m_nMonsterType]
		local existSpine = CheckEffectFile(pathName)
		if not existSpine then 
			local _sIndex = self.m_tMonsterTypeAni[self.m_nMonsterType]
	        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
	        if downloadInfo then 
	        	DownloadManager:addDownloadTask(14006, downloadInfo.url, downloadInfo.md5, _sIndex, "DownloadResourceCallback", _G)
	        end

			return 
		end
		spineBow:setFileAtlas(pathName .. ".atlas")
		spineBow:setFileJson(pathName .. ".json")
		spineBow:play("wait", true)
	end
end

--@brief 	计时器
function WndYearMonster:timeCaculate()
	self.m_nUpdateInterval = self.m_nUpdateInterval + 1

	if self.m_nUpdateInterval >= 10 then 
		self:setUpdateInterval()
	end
end

--@brief 	iphoneX适配
function WndYearMonster:_adaptIphoneX()
	if IsIphoneX() then
		GetElement(self.m_root, "conLeftMenu_WndYearMonster", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.08,0.54))
	end
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配begin----------------------------------------

function WndYearMonster:_adaptLanguage_vn()
	for i = 1, 3 do
		local txtBtnTask = GetElement(self.m_root, "txtBtnTask" .. i .. "_WndYearMonster", WZUILabelTTF)
		local txtBtnTaskSel = GetElement(self.m_root, "txtBtnTaskSel" .. i .. "_WndYearMonster", WZUILabelTTF)
		if txtBtnTask and txtBtnTaskSel then
			txtBtnTask:setFontSize(16)
			txtBtnTask:setDimensions(GlobalMethod:CCSize(80,0))
			txtBtnTaskSel:setFontSize(16)
			txtBtnTaskSel:setDimensions(GlobalMethod:CCSize(80,0))
		end
	end
end


-------------------------------------语言适配End----------------------------------------