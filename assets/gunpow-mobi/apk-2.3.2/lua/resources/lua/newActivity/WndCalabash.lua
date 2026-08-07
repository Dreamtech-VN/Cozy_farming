--WndCalabash.lua
--@brief	WndCalabash的UI模块
--@date		2023/02/01
--@author	XTX
--@note		葫芦娃活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCalabash:onEnter(element)
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
function WndCalabash:onExit(element)
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
function WndCalabash:onEnterTransitionDidFinish(element)
    WZLog("WndCalabash:onEnterTransitionDidFinish")
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7063, 7063)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7063, 6, "")
end

--@brief    关闭窗口
function WndCalabash:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    self:savePoleType()
    --如果是自动弹出的活动界面
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮回调
function WndCalabash:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 
    WndSingleMapDesc:showInterface1(LocalStrings.CALABASH_TEXT2) 
end

--@brief 	点击目标按钮回调
function WndCalabash:onClickTask(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if nTag == 1 then 
		CellNewYearTask:showInterface(22, self.m_nActivityId)
	elseif nTag == 2 then --图鉴
		WndCalabashLibrary:showInterface(self.m_nActivityId)
	elseif nTag == 3 then 
		WndShopRank:showInterface(39, self.m_nActivityId) 
	elseif nTag == 4 then 
		WndDollMachineShop:showInterface(7, self.m_nActivityId)
	end
end

--@brief 	点击大奖预览按钮回调
function WndCalabash:onClickBigReward(element)
	-- body
	local eleType = type(element)
	if eleType ~= "number" then 
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	end

	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, "")
end

--@brief 	点击开启按钮回调
function WndCalabash:onClickFive(element)
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
		SaveOperateTimes("CALABASHACTIVITYID", self.m_nActivityId)
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
	tData.grade = self.m_tCalabashIds[self.m_nCalabashType + 1]

	local stringData = json.encode(tData)

	self:setOpenState(true)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 3, stringData)
end

--@brief 	前往小推车购买
function WndCalabash:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

--@brief 	点击切换葫芦类型
function WndCalabash:onChooseTool(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local nTag = element:getTag()
	if self.m_nCalabashType == nTag then return end 

	self.m_nCalabashType = nTag
	self:_showProgress()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndCalabash:_update()
	-- body
	self:_setFreeBtnText()
	self:showRedDot()
	self:_initActivityTime()
    self:_updateLightNum()
    self:_showProgress()
end

--@brief 	初始化静态文本
function WndCalabash:_initStaticText()
	self:getPoleType()

	GetElement(self.m_root, "txtBtnTask1_WndCalabash", WZUILabelTTF):setText(LocalStrings.CALABASH_TEXT1[3])
	GetElement(self.m_root, "txtBtnTask2_WndCalabash", WZUILabelTTF):setText(LocalStrings.CALABASH_TEXT1[2])
	GetElement(self.m_root, "txtBtnTask3_WndCalabash", WZUILabelTTF):setText(LocalStrings.ACTIVITY_TEXT6)
	GetElement(self.m_root, "txtBtnTask4_WndCalabash", WZUILabelTTF):setText(LocalStrings.CALABASH_TEXT1[4])
	for i = 1, 7 do
		GetElement(self.m_root, "txtChooseAtt" .. i .. "_WndCalabash", WZUILabelTTF):setText(LocalStrings.CALABASH_TEXT1[18])
	end
	
	self:_setBallAni()
end

--@brief 	红点
function WndCalabash:showRedDot()
	-- body
	if self.m_root == nil then return end 

	local imgTaskRedDot = GetElement(self.m_root, "imgTaskRedDot_WndCalabash", WZUIImage)

	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[217063] or GlobalGame.g_tRedPointTypeList[227063] or GlobalGame.g_tRedPointTypeList[237063]) then 
		imgTaskRedDot:setVisible(true)
	else
		imgTaskRedDot:setVisible(false)
	end
end

--@brief 	更新异火的数量
function WndCalabash:_updateLightNum()
	-- body
	local ftxtLightNum = GetElement(self.m_root, "ftxtLightNum_WndCalabash", WZUIFreeTextBox)
	local sFormat = [[<I Z="0.5" P="1">%s</I><T C="255,236,193" S="20" P="1" SC="132,66,29" SS="4" SE="0">%d</T>]]
	if ftxtLightNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
		ftxtLightNum:setShowText(string.format(sFormat, basicData.icon, nLightNum))
	end
end

--@brief 	初始化活动时间
function WndCalabash:_initActivityTime()
	-- body
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndCalabash", WZUILabelTTF)
    if txtActivityTime then 
    	txtActivityTime:setText(LocalStrings.ACTIVITY_TIME_KEY .. ":" .. needDay_str)
    end
end

--@brief 	显示开启动画
function WndCalabash:showOpenAction()
	-- body
	--创建选中特效
	local spinePath = "activity/ui_hl_jiaoshui"
	local existSpine = CheckEffectFile(spinePath)
	if not existSpine then 
		local _sIndex = "ui_hl_jiaoshui"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7063, downloadInfo.url, downloadInfo.md5, _sIndex, "DownloadResourceCallback", _G)
        end
	end

	local spineOpen = GetElement(self.m_root, "spineOpen_WndCalabash", WZUISpine)
	if self.m_nAniType == 1 then 

	end
	if spineOpen then 
		if existSpine then 
			self:_setBowlingPlayAni(1, false)
			spineOpen:enableSchedule("showShootReward", 0.6)
		else
			self:showShootReward()
		end
	end
end

--@brief 	显示开启奖励
function WndCalabash:showShootReward()
	-- body
	local spineOpen = GetElement(self.m_root, "spineOpen_WndCalabash", WZUISpine)
	local spineOpen2 = GetElement(self.m_root, "spineOpen2_WndCalabash", WZUISpine)
	spineOpen:setVisible(false)
	spineOpen2:setVisible(false)
	spineOpen:disableSchedule()

	self:setOpenState(false)
	self:_afterCloseReward()
end

--@brief 	iphoneX适配
function WndCalabash:_adaptIphoneX()
	if IsIphoneX() then
		GetElement(self.m_root, "conLeftMenu_WndCalabash", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.935,0.154069))
	end
end

--@brief 	设置免费丢
function WndCalabash:_setFreeBtnText()
	local txtBtnOpenOne = GetElement(self.m_root, "txtBtnOpenOne_WndCalabash", WZUILabelTTF)
	local txtBtnOpenFive = GetElement(self.m_root, "txtBtnOpenFive_WndCalabash", WZUILabelTTF)

	local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local freeTimes = 0 
	local nTempTimes = nLightNum
	local nTimes = 0
	if self.m_nCount > 0 then 
		freeTimes = 1
		txtBtnOpenOne:setText(LocalStrings.CALABASH_TEXT1[6])
	else
		txtBtnOpenOne:setText(string.format(LocalStrings.CALABASH_TEXT1[5], 1))
	end
	nTimes = (nTempTimes + freeTimes) >= self.m_nMaxLotteryCount and self.m_nMaxLotteryCount or nTempTimes > 0 and (nTempTimes + freeTimes) or self.m_nMaxLotteryCount 

	txtBtnOpenFive:setText(string.format(LocalStrings.CALABASH_TEXT1[5], nTimes))
end

--@brief 	设置待机特效
function WndCalabash:_setBallAni()
	local spinePath = "activity/ui_hl_jiaoshui"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		local spineOpen = GetElement(self.m_root, "spineOpen_WndCalabash", WZUISpine)
		if spineOpen then 
			spineOpen:setFileJson(spinePath .. ".json")
			spineOpen:setFileAtlas(spinePath .. ".atlas")
		end
	else
		local _sIndex = "ui_hl_jiaoshui"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7063, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndCalabash)
        end
	end

	local spinePath = "activity/ui_hl_jiaoshui"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		local spineOpen2 = GetElement(self.m_root, "spineOpen2_WndCalabash", WZUISpine)
		if spineOpen2 then 
			spineOpen2:setFileJson(spinePath .. ".json")
			spineOpen2:setFileAtlas(spinePath .. ".atlas")
		end
	else
		local _sIndex = "ui_hl_jiaoshui"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7063, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndCalabash)
        end
	end

	local spinePath = "activity/hd_pic_hulv"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		local spineWait = GetElement(self.m_root, "spineWait_WndCalabash", WZUISpine)
		if spineWait then 
			spineWait:setFileJson(spinePath .. ".json")
			spineWait:setFileAtlas(spinePath .. ".atlas")
			spineWait:play("wait", true)
		end
	else
		local _sIndex = "hd_pic_hulv"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(70631, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndCalabash)
        end
	end
end

function WndCalabash:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndCalabash:downloadEffectCallback",taskId,extraData,failed)
    self:_setBallAni()
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndCalabash:_setBowlingPlayAni(aniIndex, bLoop)
	local spineOpen = GetElement(self.m_root, "spineOpen_WndCalabash", WZUISpine)
	local spineOpen2 = GetElement(self.m_root, "spineOpen2_WndCalabash", WZUISpine)
	aniIndex = aniIndex or 1
	WZLog("WndCalabash:_setBowlingPlayAni", aniIndex, bLoop)
	if self.m_nAniType == 1 then 
		if spineOpen2 then 
			spineOpen2:setVisible(true)
			spineOpen2:play(self.m_tBallAniName[aniIndex], bLoop ~= nil and bLoop or true)
		end
	else
		if spineOpen2 then 
			spineOpen2:setVisible(true)
			spineOpen2:play(self.m_tBallAniName[aniIndex], bLoop ~= nil and bLoop or true)
		end
		if spineOpen then 
			spineOpen:setVisible(true)
			spineOpen:play(self.m_tBallAniName[aniIndex], bLoop ~= nil and bLoop or true)
		end
	end
end

--@brief 	成熟度
function WndCalabash:_showProgress()
	local txtTypeName = GetElement(self.m_root, "txtTypeName_WndCalabash", WZUILabelTTF)
	if txtTypeName then 
		txtTypeName:setText(LocalStrings.CALABASH_TEXT1[7][self.m_nCalabashType + 1])
	end

	local txtExp = GetElement(self.m_root, "txtExp_WndCalabash", WZUILabelTTF)
	if txtExp then 
		txtExp:setText(LocalStrings.CALABASH_TEXT1[16] .. ":" .. self.m_tCurExp[self.m_nCalabashType+1] .. "/" .. self.m_tExpConfig[self.m_nCalabashType+1])
	end

	local prgExp = GetElement(self.m_root, "prgExp_WndCalabash", WZUIProgress)
	local nPercentage = math.floor(100 * self.m_tCurExp[self.m_nCalabashType+1]/self.m_tExpConfig[self.m_nCalabashType+1])
	if nPercentage > 100 then 
		nPercentage = 100
	end
	prgExp:setPercentage(nPercentage)
end

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin----------------------------------------

function WndCalabash:_adaptLanguage_vn()
	GetElement(self.m_root, "conCoin_WndCalabash", WZUIContainer):setRelativePosition(GlobalMethod:ccp(-0.01,0.5))
	GetElement(self.m_root, "btnBigReward_WndCalabash", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.932,0.5))
	GetElement(self.m_root, "btnTip_WndCalabash", WZUIButton):setRelativePosition(GlobalMethod:ccp(1.062,0.5))
	GetElement(self.m_root, "txtBtnOpenOne_WndCalabash", WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root, "txtBtnOpenFive_WndCalabash", WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root, "txtBtnTask2_WndCalabash", WZUILabelTTF):setDimensions(GlobalMethod:CCSize(120,0))
end

-------------------------------------语言适配End----------------------------------------
