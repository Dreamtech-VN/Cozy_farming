--WndSevenYear.lua
--@brief	WndSevenYear的UI模块
--@date		2023/05/23
--@author	XTX
--@note		七周年签到活动主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSevenYear:onEnter(element)
	self.m_root = element

	g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
	ProtocolProcessorFestivalActivity:regAll6()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
	self:_initStaticText()
	self:_showUI()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSevenYear:onExit(element)
	g_bIsShowWndDressUp = true
    g_tTempItemForLaterShow = {}
	ProtocolProcessorFestivalActivity:unregAll6()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)

	self:_unInit()
	LoadNewActivityRes(false)
end


--@brief    onenter函数已执行
function WndSevenYear:onEnterTransitionDidFinish(element)
    WZLog("WndSevenYear:onEnterTransitionDidFinish")
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7078, 7078)
end

--@brief    关闭窗口
function WndSevenYear:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    GlobalGame.g_autoSevenYear = false 
    local bIsCheck = false 
    if self.m_tMsgData ~= nil then 
        self.m_tMsgData.nStatus = MSGBOXSTATUS_DONE
        bIsCheck = true
    end
    local value = "F"
    if self.m_nSignDays == #self.m_tRewardList then 
    	value = "T"
    end
    self:saveHavedSignDays(value)
    --如果是自动弹出的活动界面
    WindowManager:removeWindow(self.m_root, self, true)
    --继续检测后续弹窗
    if bIsCheck then 
    	SceneCity:aloneActivityWinCheck()
    end
end

--@brief 	点击继续按钮回调
function WndSevenYear:onClickContinue(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	self.m_nInterfaceIndex = 2
	self:_showUI()
end

--@brief 	点击复选框回调
function WndSevenYear:onClickCheckBox(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local cbAtt = GetElement(self.m_root, "cbAtt_WndSevenYear", WZUICheckBox)
	local nValue = cbAtt:getCheckIndex()
	self:saveAutoActivity(nValue)
end

--@brief    点击规则按钮回调
function WndSevenYear:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 
    WndSingleMapDesc:showInterface1(LocalStrings.SEVENYEAR_TEXT2) 
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	初始化静态文本
function WndSevenYear:_initStaticText()
	GetElement(self.m_root, "txtCheckBox_WndSevenYear", WZUILabelTTF):setText(LocalStrings.SPRINGOUTING_TEXT1[20])
	GetElement(self.m_root, "txtCheckBoxSel_WndSevenYear", WZUILabelTTF):setText(LocalStrings.SPRINGOUTING_TEXT1[20])

	local cbAtt = GetElement(self.m_root, "cbAtt_WndSevenYear", WZUICheckBox)
	local nValue = self:getAutoActivity()
	cbAtt:setCheckIndex(nValue)
end

--@brief 界面显示
function WndSevenYear:_showUI()
	for i = 1, 2 do
		GetElement(self.m_root, "conContent" .. i .. "_WndSevenYear", WZUIContainer):setVisible(i == self.m_nInterfaceIndex)
	end
end

--@brief 	初始化活动时间
function WndSevenYear:_initActivityTime()
	-- body
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local timeFormat = "%02d.%02d-%02d.%02d"
    local needDay_str = string.format(timeFormat, DayStartTab.month, DayStartTab.day, DayEndTab.month, DayEndTab.day)
    local txtActivityTime1 = GetElement(self.m_root, "txtActivityTime1_WndSevenYear", WZUILabelTTF)
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndSevenYear", WZUILabelTTF)
    if txtActivityTime1 then 
    	txtActivityTime1:setText(LocalStrings.PEOPLE_SHOP_TEXT1 .. needDay_str)
    end
    if txtActivityTime then 
    	txtActivityTime:setText(LocalStrings.PEOPLE_SHOP_TEXT1 .. needDay_str)
    end
end

--@brief 	刷新
function WndSevenYear:_update()
	-- body
	local conList = GetElement(self.m_root, "conList_WndSevenYear", WZUIContainer)
	conList:removeAllChildrenWithCleanup(true)

	self.m_tCellItem = {}
	local nPaddingX = 0.255
	local nPaddingY = 0.5
	local nStartX = 0.12
	local nStartY = 0.74

	WZLog("WndSevenYear:_update", Serialize(self.m_tRewardList))
	for i = 1, #self.m_tRewardList do
		local element, tNewObj = nil, nil 
		local nType = 1
		if i == 7 then 
			element, tNewObj = CellSevenYearSignItem:createElement(GlobalMethod:CCSize(228,418))
			element:setRelativePosition(GlobalMethod:ccp(0.885, 0.49))
			nType = 2
		else
			element, tNewObj = CellSevenYearSignItem:createElement()

			local nParam = math.floor((i - 1)/3)
			local nPosX = nStartX + ((i - nParam * 3) - 1) * nPaddingX
			local nPosY = nStartY - math.floor((i - 1)/3) * nPaddingY
			element:setRelativePosition(GlobalMethod:ccp(nPosX, nPosY))
		end
		if element and tNewObj then 
			element:setTag(i - 1)
			conList:addChild(element)
			tNewObj:setData(self.m_tRewardList[i], nType)
			tNewObj:loadData()

			table.insert(self.m_tCellItem, tNewObj)
		end
	end
end

--@brief 	显示头像框
function WndSevenYear:_showEffect()
	if self.m_nShowItemId == nil then return end 

	local txtItemName = GetElement(self.m_root, "txtItemName_WndSevenYear", WZUILabelTTF)
	local conItem = GetElement(self.m_root, "conItem_WndSevenYear", WZUIContainer)
	conItem:removeAllChildrenWithCleanup(true)
	local basicInfo = GDatatab_item["id_" .. self.m_nShowItemId]
	txtItemName:setText(basicInfo.name)
	if basicInfo and basicInfo.value > 0 then
		local effectFile = "checkother/ui_playerhead_effect" .. basicInfo.value
		local existSpine = CheckEffectFile(effectFile)
		local tData = {}
		if existSpine then 
			tData.path = effectFile
			tData.play = "wait_1"  --动作的play
			tData.loop = true

			--调整头像特效框大小位置
			local nScale = 1
			local nPosX = 0.5
			local nPosY = 0.5
			if basicInfo.power_skill ~= -1 then
				local tmpScale = 1
				tmpScale = math.floor(tmpScale*10)/10
				if tmpScale == 1.2 then
					nScale = basicInfo.power_skill[1][7]
					nPosX = basicInfo.power_skill[1][8]
					nPosY = basicInfo.power_skill[1][9]
				else
					nScale = basicInfo.power_skill[1][1]
					nPosX = basicInfo.power_skill[1][2]
					nPosY = basicInfo.power_skill[1][3]
				end
			end
			tData.ccp = GlobalMethod:ccp(nPosX,nPosY)
			local headEffect = createEffectSpine(conItem, tData)
			headEffect:setScale(nScale * 1.2)
		end
	end
end

-------------------------------------私有方法模块End----------------------------------------
