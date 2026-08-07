--WndSecretTower.lua
--@brief	WndSecretTower的UI模块
--@date		2022/07/21
--@author	XTX
--@note		秘境闯塔活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSecretTower:onEnter(element)
	self.m_root = element

	g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
	ProtocolProcessorFestivalActivity:regAll6()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
	GlobalGame:getGameEventDispathcer():Add(Independent_Activity.ActivityReddot, self.showRedDot, self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetRankResult,self._onRankResult,self)

	self:_initStaticText()
	self:_adaptIphoneX()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSecretTower:onExit(element)
	g_bIsShowWndDressUp = true
    g_tTempItemForLaterShow = {}
	CacheCenter:unregisterUpatePlayerItemObserver(self)
	ProtocolProcessorFestivalActivity:unregAll6()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
	GlobalGame:getGameEventDispathcer():Remove(Independent_Activity.ActivityReddot, self.showRedDot, self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetRankResult,self._onRankResult,self)

	self:_unInit()
	LoadNewActivityRes(false)
end

--@brief    onenter函数已执行
function WndSecretTower:onEnterTransitionDidFinish(element)
    WZLog("WndSecretTower:onEnterTransitionDidFinish")
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7052, 7052)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7052, 4, "")
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(g_cityExtenInfo.activity7052, 1)
end

--@brief    关闭窗口
function WndSecretTower:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    --如果是自动弹出的活动界面
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮回调
function WndSecretTower:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 
    WndSingleMapDesc:showInterface1(LocalStrings.SECRETTOWER_TEXT2) 
end

--@brief 	点击目标按钮回调
function WndSecretTower:onClickTask(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if nTag == 1 then 
		CellNewYearTask:showInterface(15, self.m_nActivityId)
	elseif nTag == 2 then
		WndHouseInvite:showInterface(4, self.m_nActivityId)
	elseif nTag == 3 then 
		WndShopRank:showInterface(28, self.m_nActivityId) 
	end
end

--@brief 	点击大奖预览按钮回调
function WndSecretTower:onClickBigReward(element)
	-- body
	local eleType = type(element)
	if eleType ~= "number" then 
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	end

	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, "")
end

--@brief 	点击开启按钮回调
function WndSecretTower:onClickFive(element)
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
		SaveOperateTimes("SECRETTOWERACTIVITYID", self.m_nActivityId)
    	return 
    end

	local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local nTempTimes = nArrowNum
	local freeCount = self.m_nCount > 0 and 1 or 0 
	local nTimes = nTag
	if nTag == 5 then 
		nTag = self.m_nMaxOpTimes 
		nTimes = nTempTimes >= self.m_nMaxOpTimes and self.m_nMaxOpTimes or nTempTimes > 0 and nTempTimes + freeCount or self.m_nMaxOpTimes 
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
function WndSecretTower:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

--@brief 	点击赛事礼包按钮回调
function WndSecretTower:onClickGift(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nTag = element:getTag()
	if nTag == 1 then 
		if self.m_nLiveGiftNum >= 1 then
			--背包已满提示
		    if CacheCenter:getRemainAmount() <= 0 then
		        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
		        return
		    end
			local tData = {}
			tData.eventType = nTag - 1
			local stringData = json.encode(tData)

			self:setOpenState(true)
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 7, stringData)
		else
			local tData = {}
			tData.txtTitle = string.format(LocalStrings.SECRETTOWER_TEXT1[16], self.m_tBraveCostConfig[4])
			tData.nType = 2
			WndTips:show(element, self.m_root, 52, tData, GlobalMethod:ccp(50,80), true)
		end
	elseif nTag == 2 then 
		if self.m_nDeadGiftNum >= 1 then
			--背包已满提示
		    if CacheCenter:getRemainAmount() <= 0 then
		        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
		        return
		    end
			local tData = {}
			tData.eventType = nTag - 1
			local stringData = json.encode(tData)

			self:setOpenState(true)
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 7, stringData)
		else
			local tData = {}
			tData.txtTitle = string.format(LocalStrings.SECRETTOWER_TEXT1[17], self.m_tBraveCostConfig[5])
			tData.nType = 2
			WndTips:show(element, self.m_root, 52, tData, GlobalMethod:ccp(50,80), true)
		end
	end
end

--@brief 	点击物品回调
function WndSecretTower:onClickItem(tCell,tag,tData)
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root, self.m_root,1,tData,false,nil,true)
end

--@brief 	点击玩家头像回调
function WndSecretTower:onClickHead(element)
	if self.m_tTopPlayerInfo == nil then return end 

	WndCheckOther:show(self.m_tTopPlayerInfo.id)
end

--@brief 	领取生门奖励
function WndSecretTower:onGetLive(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	GetElement(self.m_root, "conLive_WndSecretTower", WZUIContainer):setVisible(false)

	local tReward = {}
	table.insert(tReward, CopyTable(self.m_tLiveReward))
	self.m_tLiveReward = nil 
	WndHoraryBigReward:showInterface(17, tReward)
end

--@brief 	死门选项
function WndSecretTower:onDeadChoose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	local tData = {}
	tData.choose = nTag - 1
	local stringData = json.encode(tData)

	self:setOpenState(true)
	if nTag == 1 then --无视死门
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 6, stringData)
	elseif nTag == 2 then --氪金勇闯
		local ownNum = CacheCenter:getPlayerItemCountById(self.m_tBraveCostConfig[2])
		if ownNum < self.m_tBraveCostConfig[3] then 
			local basicData = GDatatab_item["id_" .. self.m_tBraveCostConfig[2]]
			MsgBoxManager:showConfirmBox(string.format(LocalStrings.WATERCOUNTRY_TEXT4, basicData.name), self, self.goToBuy)
			return 
		end
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 6, stringData)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndSecretTower:_update()
	-- body
	self:_setFreeBtnText()
	self:showRedDot()
	self:_initActivityTime()
    self:_updateLightNum()
    self:_showTopPlayer()
end

--@brief 	更新当前塔层和奖励
function WndSecretTower:_updateCurTowerData()
	if self.m_nLastShowFloor ~= self.m_nCurFloor then 
		self.m_nLastShowFloor = self.m_nCurFloor
    	self:_showCurTowerReward()
    end
	self:_showTowerValue()
    self:showGiftInfo()
end

--@brief 	初始化静态文本
function WndSecretTower:_initStaticText()
	GetElement(self.m_root, "txtBtnTask1_WndSecretTower", WZUILabelTTF):setText(LocalStrings.SECRETTOWER_TEXT1[2])
	GetElement(self.m_root, "txtBtnTask3_WndSecretTower", WZUILabelTTF):setText(LocalStrings.SECRETTOWER_TEXT1[3])
	GetElement(self.m_root, "txtBtnTask2_WndSecretTower", WZUILabelTTF):setText(LocalStrings.SECRETTOWER_TEXT1[11])
	GetElement(self.m_root, "txtBigReward_WndSecretTower", WZUILabelTTF):setText(LocalStrings.SECRETTOWER_TEXT1[15])
	GetElement(self.m_root, "txtActivityTimeW_WndSecretTower", WZUILabelTTF):setText(LocalStrings.ACTIVITY_TIME_KEY)
	GetElement(self.m_root, "txtFloorReward_WndSecretTower", WZUILabelTTF):setText(LocalStrings.SECRETTOWER_TEXT1[12])
	GetElement(self.m_root, "txtNextFloor_WndSecretTower", WZUILabelTTF):setText(LocalStrings.SECRETTOWER_TEXT1[13])
	GetElement(self.m_root, "txtLiveTitle_WndSecretTower", WZUILabelTTF):setText(LocalStrings.SECRETTOWER_TEXT1[20])
	GetElement(self.m_root, "txtDeadTitle_WndSecretTower", WZUILabelTTF):setText(LocalStrings.SECRETTOWER_TEXT1[21])
	GetElement(self.m_root, "txtBrave_WndSecretTower", WZUILabelTTF):setText(LocalStrings.SECRETTOWER_TEXT1[23])
	GetElement(self.m_root, "txtIgnore_WndSecretTower", WZUILabelTTF):setText(LocalStrings.SECRETTOWER_TEXT1[22])

	self:_setTowerAni()
end

--@brief 	红点
function WndSecretTower:showRedDot()
	-- body
	if self.m_root == nil then return end 

	local imgTaskRedDot = GetElement(self.m_root, "imgTaskRedDot_WndSecretTower", WZUIImage)

	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[117052] or GlobalGame.g_tRedPointTypeList[127052]) then 
		imgTaskRedDot:setVisible(true)
	else
		imgTaskRedDot:setVisible(false)
	end
end

--@brief 	更新异火的数量
function WndSecretTower:_updateLightNum()
	-- body
	local ftxtLightNum = GetElement(self.m_root, "ftxtLightNum_WndSecretTower", WZUIFreeTextBox)
	local sFormat = [[<I Z="0.5" P="1">%s</I><T C="255,255,255" S="20" P="1" SC="132,66,29" SS="4" SE="1">%d</T>]]
	if ftxtLightNum then 
		local nCostId = self.m_nCoinId
		
		local basicData = GDatatab_item["id_" .. nCostId]
		local nLightNum = CacheCenter:getPlayerItemCountById(nCostId)
		ftxtLightNum:setShowText(string.format(sFormat, basicData.icon, nLightNum))
	end
end

--@brief 	初始化活动时间
function WndSecretTower:_initActivityTime()
	-- body
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndSecretTower", WZUILabelTTF)
    if txtActivityTime then 
    	txtActivityTime:setText(needDay_str)
    end
end

--@brief 	显示开启动画
function WndSecretTower:showOpenAction()
	-- body
	--创建选中特效
	local spinePath = "activity/hd_pic_mjct_ta"
	local existSpine = CheckEffectFile(spinePath)
	if not existSpine then 
		local _sIndex = "hd_pic_mjct_ta"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7052, downloadInfo.url, downloadInfo.md5, _sIndex, "DownloadResourceCallback", _G)
        end
	end

	local spineOpen = GetElement(self.m_root, "spineOpen_WndSecretTower", WZUISpine)
	if spineOpen then 
		if existSpine then 
			self:_setTowerPlayAni(2, false)
			local nDelayTime = 1.2
			spineOpen:enableSchedule("showShootReward", nDelayTime)
		else
			self:showShootReward()
		end
	end
end

--@brief 	显示开启奖励
function WndSecretTower:showShootReward()
	-- body
	local spineOpen = GetElement(self.m_root, "spineOpen_WndSecretTower", WZUISpine)
	spineOpen:disableSchedule()
	self:_setTowerPlayAni(1, true)

	self:_afterCloseReward()
	self:setOpenState(false)
end

--@brief 	iphoneX适配
function WndSecretTower:_adaptIphoneX()
	if IsIphoneX() then
		GetElement(self.m_root, "imgActivityTitle_WndSecretTower", WZUIImage):setRelativePosition(GlobalMethod:ccp(0.085,0.578))
	end
end

--@brief 	设置免费丢
function WndSecretTower:_setFreeBtnText()
	local txtBtnOpenOne = GetElement(self.m_root, "txtBtnOpenOne_WndSecretTower", WZUILabelTTF)
	local txtBtnOpenFive = GetElement(self.m_root, "txtBtnOpenFive_WndSecretTower", WZUILabelTTF)
	local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)

	local nTempTimes = nLightNum
	local nTimes = 0
	local freeCount = self.m_nCount > 0 and 1 or 0 
	if self.m_nCount > 0 then 
		txtBtnOpenOne:setText(LocalStrings.SECRETTOWER_TEXT1[6])
	else
		txtBtnOpenOne:setText(string.format(LocalStrings.SECRETTOWER_TEXT1[5], 1))
	end
	nTimes = nTempTimes >= self.m_nMaxOpTimes and self.m_nMaxOpTimes or nTempTimes > 0 and nTempTimes + freeCount or self.m_nMaxOpTimes 
	txtBtnOpenFive:setText(string.format(LocalStrings.SECRETTOWER_TEXT1[5], nTimes))
end

--@brief 	刷新生死门礼包的信息
function WndSecretTower:showGiftInfo()
	-- body
	if self.m_nLiveGiftNum > 0 then 
		GetElement(self.m_root, "imgLiveGiftRed_WndSecretTower", WZUIImage):setVisible(true)
		GetElement(self.m_root, "txtLiveGiftNum_WndSecretTower", WZUILabelTTF):setText(self.m_nLiveGiftNum)
	else
		GetElement(self.m_root, "imgLiveGiftRed_WndSecretTower", WZUIImage):setVisible(false)
	end

	if self.m_nDeadGiftNum > 0 then 
		GetElement(self.m_root, "imgDeadGiftRed_WndSecretTower", WZUIImage):setVisible(true)
		GetElement(self.m_root, "txtDeadGiftNum_WndSecretTower", WZUILabelTTF):setText(self.m_nDeadGiftNum)
	else
		GetElement(self.m_root, "imgDeadGiftRed_WndSecretTower", WZUIImage):setVisible(false)
	end
end

--@brief 	闯塔值，当前进度
function WndSecretTower:_showTowerValue()
	local prgTowerValue = GetElement(self.m_root, "prgTowerValue_WndSecretTower", WZUIProgress)
	local txtCurValue = GetElement(self.m_root, "txtCurValue_WndSecretTower", WZUILabelTTF)
	local txtCurFloor = GetElement(self.m_root, "txtCurFloor_WndSecretTower", WZUILabelTTF)

	txtCurFloor:setText(string.format(LocalStrings.SECRETTOWER_TEXT1[18], self.m_nCurFloor))
	txtCurValue:setText(self.m_nCurTowerValue .. "/" .. self.m_nFullTowerValue)
	local nPercent = math.floor(100 * self.m_nCurTowerValue / self.m_nFullTowerValue)
	if nPercent > 100 then 
		nPercent = 100 
	end
	prgTowerValue:setPercentage(nPercent)
end

--@brief 	显示当前塔层奖励
function WndSecretTower:_showCurTowerReward()
	local tbRightList = GetElement(self.m_root, "tbRightList_WndSecretTower", WZUITableContainer)
	tbRightList:cleanTable()

	for i = 1, #self.m_tFloorRewards do
		local element, tNewObj = CellGoodItem:createElement()
		if element and tNewObj then 
			element:setTag(i -1)
			element:setScale(0.7)
			tNewObj:setCellGoodLocalId(self.m_tFloorRewards[i][1], self.m_tFloorRewards[i][2], 17)
			tNewObj:setItemClickFun(self, self.onClickItem)

			tbRightList:setCellElement(element)
		end
	end
end

--@brief 	显示最高层玩家的头像
function WndSecretTower:_showTopPlayer()
	if self.m_tTopPlayerInfo == nil then return end 

	GetElement(self.m_root, "conTopPlayer_WndSecretTower", WZUIContainer):setVisible(true)
	local pInfo = self.m_tTopPlayerInfo 
	local conHead = GetElement(self.m_root, "conHead_WndSecretTower", WZUIContainer)
	CellHead:show(conHead, pInfo.headId, pInfo.faceId, pInfo.sex, nil, nil, pInfo.vipLevel, pInfo.headColor, nil, nil, nil, nil, pInfo.headEffectId)

	local txtPlayerName = GetElement(self.m_root, "txtPlayerName_WndSecretTower", WZUILabelTTF)
	txtPlayerName:setText(pInfo.name)
	GetElement(self.m_root, "txtPlayerFloor_WndSecretTower", WZUILabelTTF):setText(string.format(LocalStrings.SECRETTOWER_TEXT1[19], pInfo.floorNum))
	if CacheCenter:getPlayerInfo().serverId ~= pInfo.serverId then 
		GetElement(self.m_root, "imgKuafu_WndSecretTower", WZUIImage):setVisible(true)
		txtPlayerName:setRelativePosition(GlobalMethod:ccp(0.52, 0.67))
	else
		GetElement(self.m_root, "imgKuafu_WndSecretTower", WZUIImage):setVisible(false)
		txtPlayerName:setRelativePosition(GlobalMethod:ccp(0.42, 0.67))
	end
end

--@brief 	显示触发生门奖励界面
function WndSecretTower:_showLiveReward()
	GetElement(self.m_root, "conLive_WndSecretTower", WZUIContainer):setVisible(true)
	local nCount = #self.m_tLiveReward
	local tbLiveReward = GetElement(self.m_root, "tbLiveReward_WndSecretTower", WZUITableContainer)
	local conLiveReward = GetElement(self.m_root, "conLiveReward_WndSecretTower", WZUIContainer)
	if nCount <= 5 then 
		tbLiveReward:setVisible(false)
		conLiveReward:setVisible(true)
		conLiveReward:removeAllChildrenWithCleanup(true)

		local nPadding = 0.2
		local nStartPos = 0.5 - (nCount - 1) / 2 * nPadding
		WZLog("WndSecretTower:_showLiveReward", Serialize(self.m_tLiveReward))
		for i = 1, nCount do
			local element, tNewObj = CellGoodItem:createElement()
			if element and tNewObj then 
				tNewObj:setCellGoodLocalId(self.m_tLiveReward[i].itemId, self.m_tLiveReward[i].itemNum, 17)
				tNewObj:setItemClickFun(self, self.onClickItem)
				element:setRelativePosition(GlobalMethod:ccp(nStartPos + (i - 1)*nPadding, 0.5))

				conLiveReward:addChild(element)
			end
		end
	else
		tbLiveReward:setVisible(true)
		conLiveReward:setVisible(false)
		tbLiveReward:cleanTable()

		for i = 1, nCount do
			local element, tNewObj = CellGoodItem:createElement()
			if element and tNewObj then 
				element:setTag(i - 1)
				tNewObj:setCellGoodLocalId(self.m_tLiveReward[i].itemId, self.m_tLiveReward[i].itemNum, 17)
				tNewObj:setItemClickFun(self, self.onClickItem)

				tbLiveReward:setCellElement(element)
			end
		end
	end
end

--@brief 	显示触发死门情况
function WndSecretTower:_showDeadSituation()
	GetElement(self.m_root, "conDead_WndSecretTower", WZUIContainer):setVisible(true)
	
	local ftxtDeadDesc = GetElement(self.m_root, "ftxtDeadDesc_WndSecretTower", WZUIFreeTextBox)
	local basicData = GDatatab_item["id_" .. self.m_tBraveCostConfig[2]]
	local strContent = string.format(LocalStrings.SECRETTOWER_TEXT1[24], self.m_tBraveCostConfig[1], self.m_tBraveCostConfig[3], basicData.icon)
	ftxtDeadDesc:setShowText(strContent)
end

--@brief 	设置待机特效
function WndSecretTower:_setTowerAni()
	local spinePath = "activity/hd_pic_mjct_ta"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		local spineOpen = GetElement(self.m_root, "spineOpen_WndSecretTower", WZUISpine)
		if spineOpen then 
			spineOpen:setFileJson(spinePath .. ".json")
			spineOpen:setFileAtlas(spinePath .. ".atlas")
		end
	else
		local _sIndex = "hd_pic_mjct_ta"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7052, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndSecretTower)
        end
	end

	local spinePath2 = "activity/hd_pic_mjct_daiji"
	local existSpine2 = CheckEffectFile(spinePath2)
	if existSpine2 then 
		local spineWait = GetElement(self.m_root, "spineWait_WndSecretTower", WZUISpine)
		if spineWait then 
			spineWait:setFileJson(spinePath2 .. ".json")
			spineWait:setFileAtlas(spinePath2 .. ".atlas")
			spineWait:play("wait", true)
		end
	else
		local _sIndex = "hd_pic_mjct_daiji"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(70521, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndSecretTower)
        end
	end
end

function WndSecretTower:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndSecretTower:downloadEffectCallback",taskId,extraData,failed)
    if failed == 0 then 
    	self:_setTowerAni()
    end
end

--@brief 	设置播放
--@param 	aniIndex:1待机；2闯塔
function WndSecretTower:_setTowerPlayAni(aniIndex, bLoop)
	local spineOpen = GetElement(self.m_root, "spineOpen_WndSecretTower", WZUISpine)
	aniIndex = aniIndex or 1
	if spineOpen then 
		if aniIndex == 1 then 
			spineOpen:play("wait2", bLoop ~= nil and bLoop or true)
		else
			spineOpen:play("wait", bLoop ~= nil and bLoop or true)
		end
	end
end

--@brief 	检测八卦方位入口红点
function WndSecretTower:_checkEightRedDot()
	if self.m_tEightTaskData == nil then return end 

	local bIsRedDot = false   
	for i = 1, #self.m_tEightTaskData do
		bIsRedDot = true  
		for j = 1, #self.m_tEightTaskData[i].cost do
			local nOwnNum = CacheCenter:getPlayerItemCountById(self.m_tEightTaskData[i].cost[j][1])
			if nOwnNum < self.m_tEightTaskData[i].cost[j][2] then 
				bIsRedDot = false  
				break 
			end
		end

		if bIsRedDot then 
			break 
		end
	end

	local imgFinancialRedDot = GetElement(self.m_root, "imgFinancialRedDot_WndSecretTower", WZUIImage)
	imgFinancialRedDot:setVisible(bIsRedDot)
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配begin----------------------------------------

function WndSecretTower:_adaptLanguage_vn( )
    local txtBtnTask1 = GetElement(self.m_root, "txtBtnTask1_WndSecretTower", WZUILabelTTF)
    txtBtnTask1:setFontSize(12)
    txtBtnTask1:setDimensions(GlobalMethod:CCSize(80,0))
    local txtBtnTask2 = GetElement(self.m_root, "txtBtnTask2_WndSecretTower", WZUILabelTTF)
    txtBtnTask2:setFontSize(12)
    txtBtnTask2:setDimensions(GlobalMethod:CCSize(80,0))
    local txtBtnTask3 = GetElement(self.m_root, "txtBtnTask3_WndSecretTower", WZUILabelTTF)
    txtBtnTask3:setFontSize(12)
    txtBtnTask3:setDimensions(GlobalMethod:CCSize(80,0))

    GetElement(self.m_root, "txtNextFloor_WndSecretTower", WZUILabelTTF):setFontSize(14)

    GetElement(self.m_root, "txtBtnOpenOne_WndSecretTower", WZUILabelTTF):setFontSize(20)
    GetElement(self.m_root, "txtBtnOpenFive_WndSecretTower", WZUILabelTTF):setFontSize(20)

	GetElement(self.m_root, "txtIgnore_WndSecretTower", WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root, "txtBrave_WndSecretTower", WZUILabelTTF):setFontSize(14)
end

-------------------------------------语言适配end----------------------------------------
