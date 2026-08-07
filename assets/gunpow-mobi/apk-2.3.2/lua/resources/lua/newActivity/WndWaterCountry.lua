--WndWaterCountry.lua
--@brief	WndWaterCountry的UI模块
--@date		2021/10/26
--@author	XTX
--@note		水之国度活动主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndWaterCountry:onEnter(element)
	self.m_root = element

	g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
	ProtocolProcessorFestivalActivity:regAll6()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)

	self:_initStaticText()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndWaterCountry:onExit(element)
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
function WndWaterCountry:onEnterTransitionDidFinish(element)
    WZLog("WndWaterCountry:onEnterTransitionDidFinish")
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7031, 7031)
    self:showRedDot()
end

--@brief    关闭窗口
function WndWaterCountry:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    --如果是自动弹出的活动界面
   WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮回调
function WndWaterCountry:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 
    WndSingleMapDesc:showInterface1(LocalStrings.WATERCOUNTRY_TEXT1) 
end

--@brief 	点击目标按钮回调
function WndWaterCountry:onClickTask(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if nTag == 1 then 
		CellNewYearTask:showInterface(2, self.m_nActivityId)
	elseif nTag == 2 then
		CellNewYearTask:showInterface(3, self.m_nActivityId)
	elseif nTag == 3 then 
		WndShopRank:showInterface(13, self.m_nActivityId) 
	end
end

--@brief 	点击大奖预览按钮回调
function WndWaterCountry:onClickBigReward(element)
	-- body
	local eleType = type(element)
	if eleType ~= "number" then 
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	end

	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 6, "")
end

--@brief	点击物品弹出对应的tips
function WndWaterCountry:onItemClick(tCell, tag, tData)
    if tData == nil then
       return
    end

    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root, WndWaterCountry.m_root, 1, tData, false, nil, true)
end

--@brief 	点击触摸开始回调协议
function WndWaterCountry:onTouchBegan(element, pt)
	-- body
	if not self:checkPointInBtn(pt, "conMyCodeList_WndWaterCountry") then 
		local conMyCodeList = GetElement(self.m_root, "conMyCodeList_WndWaterCountry", WZUIContainer)
		if conMyCodeList:isVisible() then 
			conMyCodeList:setVisible(false)
		end
	end
end

--@brief 	点击头像回调
function WndWaterCountry:onClickHead(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	WndCheckOther:show(nTag)
end

--@brief 	切换标签回调
function WndWaterCountry:onCheckTab(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local nTag = element:getTag()
	if self.m_nRTabIndex == nTag then return end 

	self.m_nRTabIndex = nTag 
	if self.m_nRTabIndex == 1 then 
		self:showCurBox()
	elseif self.m_nRTabIndex == 2 then 
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 5, "")
	end
end

--@brief 	点击查看按钮回调
function WndWaterCountry:onCheckMyCode(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 3, "")
end

--@brief 	点击开启按钮回调
function WndWaterCountry:onClickFive(element)
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
		SaveOperateTimes("WATERCOUNTRYACTIVITYID", self.m_nActivityId)
    	return 
    end

	local nArrowNum = CacheCenter:getPlayerItemCountById(160165)
	if nTag * self.m_nWaterType > nArrowNum then 
		local basicData = GDatatab_item["id_160165"]
		MsgBoxManager:showConfirmBox(string.format(LocalStrings.WATERCOUNTRY_TEXT4, basicData.name), self, self.goToBuy)
		return 
	end
    local tData = {}
	tData.times = nTag
	tData.type = self.m_nWaterType

	local stringData = json.encode(tData)

	self:setOpenState(true)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 4, stringData)
end

--@brief 	前往小推车购买
function WndWaterCountry:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

--@brief 	点击切换类型
function WndWaterCountry:onChangeType(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_nWaterType == 1 then 
		self.m_nWaterType = 2 
	elseif self.m_nWaterType == 2 then 
		self.m_nWaterType = 1
	end

	self:_showWaterType()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndWaterCountry:_update()
	-- body
	self:_initActivityTime()
    self:_updateArrowNum()
end

--@brief	检查坐标点是否在VIP按钮范围内
--@param	pt:鼠标点击的世界坐标
--@return	在按钮范围内返回true,否则返回false
function WndWaterCountry:checkPointInBtn(pt, nodeName)
	WZLog("WndWaterCountry:checkPointInBtn")
	if self.m_root == nil then return end
	local btn = GetElement(self.m_root, nodeName, WZUIContainer)
	if btn == nil then return false end
	local btnSize = btn:getContentSize()
	--获得btn的世界坐标
	local ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
	if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
		return true
	else
		return false
	end 
end

--@brief 	更新箭的数量
function WndWaterCountry:_updateArrowNum()
	-- body
	local ftxtArrowNum = GetElement(self.m_root, "ftxtWaterNum_WndWaterCountry", WZUIFreeTextBox)
	if ftxtArrowNum then 
		local basicData = GDatatab_item["id_160165"]
		local sFormat = [[<I Z="0.5" P="1">%s</I><T C="255,255,255" S="20" P="1" SC="0,112,202" SS="4" SE="1">%d</T>]]
		local nArrowNum = CacheCenter:getPlayerItemCountById(160165)
		ftxtArrowNum:setShowText(string.format(sFormat, basicData.icon, nArrowNum))
	end
end

--@brief 	初始化活动时间
function WndWaterCountry:_initActivityTime()
	-- body
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndWaterCountry", WZUILabelTTF)
    if txtActivityTime then 
    	txtActivityTime:setText(LocalStrings.ACTIVITY_TIME_KEY .. ":" .. needDay_str)
    end
end

--@brief 	红点
function WndWaterCountry:showRedDot()
	-- body
	if self.m_root == nil then return end 

	local imgTaskRedDot = GetElement(self.m_root, "imgTaskRedDot_WndWaterCountry", WZUIImage)
	local imgFinancialRedDot = GetElement(self.m_root, "imgFinancialRedDot_WndWaterCountry", WZUIImage)

	if GlobalGame.g_tRedPointTypeList[217031] or GlobalGame.g_tRedPointTypeList[227031] then 
		imgTaskRedDot:setVisible(true)
	else
		imgTaskRedDot:setVisible(false)
	end
	if GlobalGame.g_tRedPointTypeList[237031] then 
		imgFinancialRedDot:setVisible(true)
	else
		imgFinancialRedDot:setVisible(false)
	end
end

--@brief 	初始化静态文本
function WndWaterCountry:_initStaticText()
	GetElement(self.m_root, "txtBtnOpenOne_WndWaterCountry", WZUILabelTTF):setText(string.format(LocalStrings.CARD_TEXT39, 1))
	GetElement(self.m_root, "txtBtnOpenFive_WndWaterCountry", WZUILabelTTF):setText(string.format(LocalStrings.CARD_TEXT39, 5))
	GetElement(self.m_root, "txtBtnTask1_WndWaterCountry", WZUILabelTTF):setText(LocalStrings.WATERCOUNTRY_TEXT2[1])
	GetElement(self.m_root, "txtBtnTask2_WndWaterCountry", WZUILabelTTF):setText(LocalStrings.WATERCOUNTRY_TEXT2[2])
	GetElement(self.m_root, "txtBtnTask3_WndWaterCountry", WZUILabelTTF):setText(LocalStrings.RANKLIST_TITLE)
	GetElement(self.m_root, "txtRewardPro_WndWater", WZUILabelTTF):setText(LocalStrings.WATERCOUNTRY_TEXT2[8])
	GetElement(self.m_root, "txtTab1_WndWaterCountry", WZUILabelTTF):setText(LocalStrings.WATERCOUNTRY_TEXT2[3])
	GetElement(self.m_root, "txtTabSel1_WndWaterCountry", WZUILabelTTF):setText(LocalStrings.WATERCOUNTRY_TEXT2[3])
	GetElement(self.m_root, "txtTab2_WndWaterCountry", WZUILabelTTF):setText(LocalStrings.WATERCOUNTRY_TEXT2[4])
	GetElement(self.m_root, "txtTabSel2_WndWaterCountry", WZUILabelTTF):setText(LocalStrings.WATERCOUNTRY_TEXT2[4])
	GetElement(self.m_root, "txtMyCode_WndWaterCountry", WZUILabelTTF):setText(LocalStrings.WATERCOUNTRY_TEXT2[9])
	GetElement(self.m_root, "txtNullTip_WndWaterCountry", WZUILabelTTF):setText(LocalStrings.WATERCOUNTRY_TEXT2[14])

	GetElement(self.m_root, "imgStoneIcon_WndWaterCountry", WZUIImage):setFile("shopitems/hd_szgd_sfs.png")
	self:_setBallAni()

	self:_showWaterType()
end

--@brief 	显示当前宝藏列表
function WndWaterCountry:showCurBox()
	local tbRightList = GetElement(self.m_root, "tbRightList_WndWaterCountry", WZUITableContainer)
	tbRightList:cleanTable()
	tbRightList:setCellElementHeight(0.34)
	local conNullTip = GetElement(self.m_root, "conNullTip_WndWaterCountry", WZUIContainer)
	conNullTip:setVisible(false)

	for i = 1, #self.m_tPeriodBoxList do
		local element = WZUISystem:getInstance():createElement("cellPeriodItem")
		if element then 
			element:setVisible(true)
			GetElement(element, "txtPeriods_cellPeriodItem", WZUILabelTTF):setText(string.format(LocalStrings.WATERCOUNTRY_TEXT2[10], self.m_tPeriodBoxList[i].periodNum))
			GetElement(element, "txtBoxTypeName_cellPeriodItem", WZUILabelTTF):setText(self.m_tPeriodBoxList[i].periodName)
			local conItem = GetElement(element, "conItem_cellPeriodItem", WZUIContainer)
			conItem:removeAllChildrenWithCleanup(true)

			local celElement, tNewObj = CellGoodItem:createElement()
			if celElement and tNewObj then 
				celElement:setScale(0.72)
				tNewObj:setCellGoodLocalId(self.m_tPeriodBoxList[i].periodReward[1][1], self.m_tPeriodBoxList[i].periodReward[1][2], 4)
				tNewObj:setItemClickFun(self, self.onItemClick)

				conItem:addChild(celElement)
			end

			element:setTag(i - 1)
			tbRightList:setCellElement(element)

			if ProjConfig.LANGUAGE == "vn" then
				GetElement(element, "txtBoxTypeName_cellPeriodItem", WZUILabelTTF):setScale(0.8)
			end
		end
	end

	tbRightList:getMoveElement():setPositionY(tbRightList:getMinPosition().y)
end

--@brief 	显示夺宝回顾列表
function WndWaterCountry:showPeriodRecordList()
	local tbRightList = GetElement(self.m_root, "tbRightList_WndWaterCountry", WZUITableContainer)
	tbRightList:cleanTable()
	tbRightList:setCellElementHeight(0.44)
	local conNullTip = GetElement(self.m_root, "conNullTip_WndWaterCountry", WZUIContainer)
	if self.m_tPeriodRecordList == nil or #self.m_tPeriodRecordList == 0 then 
		conNullTip:setVisible(true)
		return 
	end
	conNullTip:setVisible(false)

	for i = 1, #self.m_tPeriodRecordList do
		local element, tNewObj = CellPeriodRecord:createElement()
		if element and tNewObj then 
			element:setTag(i - 1)
			tNewObj:setData(self.m_tPeriodRecordList[i])

			tbRightList:setCellElement(element)
		end
	end
end

--@brief 	显示我的水符石
function WndWaterCountry:showMyCode()
	local prgReward = GetElement(self.m_root, "prgReward_WndWaterCountry", WZUIProgress)
	prgReward:setPercentage(math.floor(100 * self.m_nCurCostNum / self.m_nTotalNum))

	local txtRewardPrg = GetElement(self.m_root, "txtRewardPrg_WndWaterCountry", WZUILabelTTF)
	if txtRewardPrg then 
		txtRewardPrg:setText(self.m_nCurCostNum .. "/" .. self.m_nTotalNum)
	end
end

--@brief 	展示我的水符石
function WndWaterCountry:showMyCodeList()
	local tbMyCode = GetElement(self.m_root, "tbMyCode_WndWaterCountry", WZUITableContainer)
	tbMyCode:cleanTable()
	local conMyCodeList = GetElement(self.m_root, "conMyCodeList_WndWaterCountry", WZUIContainer)
	conMyCodeList:setVisible(true)

	if self.m_tMyCodeList == nil or #self.m_tMyCodeList == 0 then 
		ShowPanelNullTip( conMyCodeList)
		return 
	end
	removeShowPanelNullTip(conMyCodeList)

	local nCount = math.ceil(#self.m_tMyCodeList/2)
	local sFormat = [[<T C="127,70,26" S="20" P="1">%s</T><T C="229,105,22" S="20" P="1">%s</T>]]
	for i = 1, nCount do
		local nIndex = (i - 1) * 2 + 1 
		local conTemp = WZUIContainer:create()
		conTemp:setAbsContentSize(GlobalMethod:CCSize(180, 30))
		conTemp:setUseAbsSize(true)
		
		local txtCodeWord = createLabel(LocalStrings.WATERCOUNTRY_TEXT2[12] .. ":", GlobalMethod:ccp(0.15,0.5), GlobalMethod:ccp(0,0.5), 20, GlobalMethod:ccc3(127,70,26))
		conTemp:addChild(txtCodeWord)
		local txtCode = createLabel(self.m_tMyCodeList[nIndex], GlobalMethod:ccp(1,0.5), GlobalMethod:ccp(0,0.5), 20, GlobalMethod:ccc3(229,105,22))
		txtCodeWord:addChild(txtCode)
		conTemp:setTag(nIndex - 1)
		tbMyCode:setCellElement(conTemp)
		nIndex = nIndex + 1
		if self.m_tMyCodeList[nIndex] then 
			local conTemp = WZUIContainer:create()
			conTemp:setAbsContentSize(GlobalMethod:CCSize(180, 30))
			conTemp:setUseAbsSize(true)

			local txtCodeWord = createLabel(LocalStrings.WATERCOUNTRY_TEXT2[12] .. ":", GlobalMethod:ccp(0.15,0.5), GlobalMethod:ccp(0,0.5), 20, GlobalMethod:ccc3(127,70,26))
			conTemp:addChild(txtCodeWord)
			local txtCode = createLabel(self.m_tMyCodeList[nIndex], GlobalMethod:ccp(1,0.5), GlobalMethod:ccp(0,0.5), 20, GlobalMethod:ccc3(229,105,22))
			txtCodeWord:addChild(txtCode)
			conTemp:setTag(nIndex - 1)
			tbMyCode:setCellElement(conTemp)
		end
	end
end

--@brief 	显示开启动画
function WndWaterCountry:showOpenAction()
	-- body
	local conOpenAct = GetElement(self.m_root, "conOpenAct_WndWaterCountry", WZUIContainer)
	conOpenAct:setVisible(true)
	local spineBow = GetElement(self.m_root, "spineOpen_WndWaterCountry", WZUISpine)
	if spineBow then 
		local spinePath = "activity/ui_common_sdsc_1"
		local existSpine = CheckEffectFile(spinePath)
		if existSpine then 
			spineBow:setFileAtlas(spinePath .. ".atlas")
			spineBow:setFileJson(spinePath .. ".json")
			spineBow:play("wait" .. self.m_nWaterType, false)
		else
			local _sIndex = "ui_common_sdsc_1"
	        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
	        if downloadInfo then 
	        	DownloadManager:addDownloadTask(14211,downloadInfo.url,downloadInfo.md5,_sIndex,"DownloadResourceCallback", _G)
	        end
		end
		conOpenAct:enableSchedule("showShootReward", 0.7)
	end
end

--@brief 	显示开启奖励
function WndWaterCountry:showShootReward()
	-- body
	local conOpenAct = GetElement(self.m_root, "conOpenAct_WndWaterCountry", WZUIContainer)
	conOpenAct:disableSchedule()

	self:setOpenState(false)
	WndRewardShow:showById(self.m_tOpenResult.itemIds, self.m_tOpenResult.itemNums)
	WndRewardShow:closeCallBack(self, self._afterCloseReward)
--	MsgBoxManager:showTipBox(string.format(LocalStrings.WATERCOUNTRY_TEXT5[4], #self.m_tOpenResult.bzms))

	conOpenAct:setVisible(false)
end

--@brief 	显示相应的宝石和特效
function WndWaterCountry:_showWaterType()
	local titlePath = {"ui/newActivity/common_pic_szgd_ssrs.png", "ui/newActivity/common_pic_szgd_sdsc.png"}
	local titlePath2 = {"ui/newActivity/common_pic_szgd_ssrs_1.png", "ui/newActivity/common_pic_szgd_sdsc_1.png"}
	local spineName1 = {"wait_1", "wait_4"}
	local spineName2 = {"wait_3", "wait_5"}
	local spinePosition1 = {GlobalMethod:ccp(0.489,0.32), GlobalMethod:ccp(0.5,0.33)}
	local spinePosition2 = {GlobalMethod:ccp(0.5,0.371), GlobalMethod:ccp(0.5,0.371)}
	GetElement(self.m_root, "img9Type_WndWaterCountry", WZUI9Image):setFile(titlePath[self.m_nWaterType])
	GetElement(self.m_root, "imgBase_WndWaterCountry", WZUIImage):setFile(titlePath2[self.m_nWaterType])
	local spineWater = GetElement(self.m_root, "spineWater_WndWaterCountry", WZUISpine)
	spineWater:setRelativePosition(spinePosition2[self.m_nWaterType])
	spineWater:setAnimationName(spineName2[self.m_nWaterType])
	local spineType = GetElement(self.m_root, "spineType_WndWaterCountry", WZUISpine)
	spineType:setRelativePosition(spinePosition1[self.m_nWaterType])
	spineType:setAnimationName(spineName1[self.m_nWaterType])

	GetElement(self.m_root, "txtTypeTitle_WndWaterCountry", WZUILabelTTF):setText(LocalStrings.WATERCOUNTRY_TEXT2[4 + self.m_nWaterType])
end

--@brief 	设置待机特效
function WndWaterCountry:_setBallAni()
	local spinePath = "activity/ui_common_szgd_jm"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		local spineWave = GetElement(self.m_root, "spineWave_WndWaterCountry", WZUISpine)
		local spineWater = GetElement(self.m_root, "spineWater_WndWaterCountry", WZUISpine)
		local spineType = GetElement(self.m_root, "spineType_WndWaterCountry", WZUISpine)
		if spineWave then 
			spineWave:setFileJson(spinePath .. ".json")
			spineWave:setFileAtlas(spinePath .. ".atlas")
			spineWave:play("wait_2", true)
		end
		if spineWater then 
			spineWater:setFileJson(spinePath .. ".json")
			spineWater:setFileAtlas(spinePath .. ".atlas")
		end
		if spineType then 
			spineType:setFileJson(spinePath .. ".json")
			spineType:setFileAtlas(spinePath .. ".atlas")
		end
	else
		local _sIndex = "ui_common_szgd_jm"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7031, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndWaterCountry)
        end
	end
end

function WndWaterCountry:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndWaterCountry:downloadEffectCallback",taskId,extraData,failed)
    self:_setBallAni()
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配begin----------------------------------------

function WndWaterCountry:_adaptLanguage_vn()
	for i = 1, 3 do
		local txtTab = GetElement(self.m_root, "txtTab" .. i .. "_WndWaterCountry", WZUILabelTTF)
		local txtTabSel = GetElement(self.m_root, "txtTabSel" .. i .. "_WndWaterCountry", WZUILabelTTF)
		if txtTab and txtTabSel then
			txtTab:setFontSize(16)
			txtTab:setDimensions(GlobalMethod:CCSize(80,0))
			txtTabSel:setFontSize(16)
			txtTabSel:setDimensions(GlobalMethod:CCSize(80,0))
		end
	end
end


-------------------------------------语言适配End----------------------------------------