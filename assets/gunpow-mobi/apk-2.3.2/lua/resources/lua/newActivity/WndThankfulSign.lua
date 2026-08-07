--WndThankfulSign.lua
--@brief	WndThankfulSign的UI模块
--@date		2023/02/28
--@author	XTX
--@note		感恩打卡活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndThankfulSign:onEnter(element)
	self.m_root = element

	g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
	ProtocolProcessorFestivalActivity:regAll6()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetInfo,self._onGetTaskResult,self)
	self:_initStaticText()
	self:_showUI()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndThankfulSign:onExit(element)
	g_bIsShowWndDressUp = true
    g_tTempItemForLaterShow = {}
	ProtocolProcessorFestivalActivity:unregAll6()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetInfo,self._onGetTaskResult,self)

	self:_unInit()
	LoadNewActivityRes(false)
end

--@brief    onenter函数已执行
function WndThankfulSign:onEnterTransitionDidFinish(element)
    WZLog("WndThankfulSign:onEnterTransitionDidFinish")
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7067, 7067)
end

--@brief    关闭窗口
function WndThankfulSign:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    GlobalGame.g_autoThankfulSign = false 
    local bIsCheck = false 
    if self.m_tMsgData ~= nil then 
        self.m_tMsgData.nStatus = MSGBOXSTATUS_DONE
        bIsCheck = true
    end
    --如果是自动弹出的活动界面
    WindowManager:removeWindow(self.m_root, self, true)
    --继续检测后续弹窗
    if bIsCheck then 
    	SceneCity:aloneActivityWinCheck()
    end
end

--@brief 	点击继续按钮回调
function WndThankfulSign:onClickContinue(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	self.m_nInterfaceIndex = 2
	self:_showUI()
end

--@brief 	点击复选框回调
function WndThankfulSign:onClickCheckBox(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local cbAtt = GetElement(self.m_root, "cbAtt_WndThankfulSign", WZUICheckBox)
	local nValue = cbAtt:getCheckIndex()
	self:saveAutoActivity(nValue)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	初始化静态文本
function WndThankfulSign:_initStaticText()
	GetElement(self.m_root, "txtCheckBox_WndThankfulSign", WZUILabelTTF):setText(LocalStrings.SPRINGOUTING_TEXT1[20])
	GetElement(self.m_root, "txtCheckBoxSel_WndThankfulSign", WZUILabelTTF):setText(LocalStrings.SPRINGOUTING_TEXT1[20])
	GetElement(self.m_root, "txtActivityTimeWord1_WndThankfulSign", WZUILabelTTF):setText(LocalStrings.ACTIVE_TIME)

	local cbAtt = GetElement(self.m_root, "cbAtt_WndThankfulSign", WZUICheckBox)
	local nValue = self:getAutoActivity()
	cbAtt:setCheckIndex(nValue)
end

--@brief 界面显示
function WndThankfulSign:_showUI()
	for i = 1, 2 do
		GetElement(self.m_root, "conContent" .. i .. "_WndThankfulSign", WZUIContainer):setVisible(i == self.m_nInterfaceIndex)
	end
end

--@brief 	初始化活动时间
function WndThankfulSign:_initActivityTime()
	-- body
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local timeFormat = "%02d.%02d-%02d.%02d"
    local needDay_str = string.format(timeFormat, DayStartTab.month, DayStartTab.day, DayEndTab.month, DayEndTab.day)
    local txtActivityTime1 = GetElement(self.m_root, "txtActivityTime1_WndThankfulSign", WZUILabelTTF)
    if txtActivityTime1 then 
    	txtActivityTime1:setText(needDay_str)
    end
end

--@brief 	刷新
function WndThankfulSign:_update()
	-- body
	self:_initActivityTime()

	local tbList = GetElement(self.m_root, "tbList_WndThankfulSign", WZUITableContainer)
	tbList:cleanTable()
	self.m_tCellItem = {}
	local nLeftDays = self.m_nLeftDays
	local nTotalDays = self:getTotalDays()
	local nCurDayIndex = nTotalDays - nLeftDays

	for i = 1, #self.m_tRewardList do
		local element, tNewObj = CellThankfulSignItem:createElement()
		if element and tNewObj then 
			element:setTag(i - 1)
			tNewObj:setData(self.m_tRewardList[i])

			tbList:setCellElement(element)
			table.insert(self.m_tCellItem, tNewObj)
		end
	end

	local cellWidth = 192
	if nCurDayIndex > 3 then 
		local nCurPositionX = tbList:getMaxPosition().x - (nCurDayIndex - 3) * cellWidth
		if nCurPositionX < tbList:getMinPosition().x then 
			nCurPositionX = tbList:getMinPosition().x
		end
		tbList:getMoveElement():setPositionX(nCurPositionX)
	end
end
-------------------------------------私有方法模块End----------------------------------------
