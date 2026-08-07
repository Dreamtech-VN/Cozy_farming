--WndDressGive.lua
--@brief	WndDressGive的UI模块
--@date		2022/08/16
--@author	XTX
--@note		时装惠送活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndDressGive:onEnter(element)
	self.m_root = element

	g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
	ProtocolProcessorFestivalActivity:regAll6()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)

end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndDressGive:onExit(element)
	g_bIsShowWndDressUp = true
    g_tTempItemForLaterShow = {}
	ProtocolProcessorFestivalActivity:unregAll6()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)

	self:_unInit()
	LoadNewActivityRes(true)
end

--@brief    onenter函数已执行
function WndDressGive:onEnterTransitionDidFinish(element)
    WZLog("WndDressGive:onEnterTransitionDidFinish")
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7056, 7056)
end

--@brief    关闭窗口
function WndDressGive:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    --如果是自动弹出的活动界面
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮回调
function WndDressGive:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 
    WndSingleMapDesc:showInterface1(LocalStrings.DRESSGIVE_TEXT2) 
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndDressGive:_update()
	-- body
	self:_initActivityTime()
	self:_showList()
end

--@brief 	初始化活动时间
function WndDressGive:_initActivityTime()
	-- body
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndDressGive", WZUILabelTTF)
    if txtActivityTime then 
    	txtActivityTime:setText(LocalStrings.ACTIVITY_TIME_KEY .. ":" .. needDay_str)
		if ProjConfig.LANGUAGE == "vn" then
			txtActivityTime:setText(needDay_str)
		end
    end
end

--@brief 	显示列表
function WndDressGive:_showList()
	local tbList = GetElement(self.m_root, "tbList_WndDressGive", WZUITableContainer)
	tbList:cleanTable()
	self.m_tCellItem = {}

	for i = 1, #self.m_tData do
		local element, tNewObj = CellDressGiveItem:createElement()
		if element and tNewObj then 
			element:setVisible(true)
			element:setTag(i - 1)
			tNewObj:setData(self.m_tData[i], i)
			tbList:setCellElement(element)

			table.insert(self.m_tCellItem, tNewObj)
		end
	end
end
-------------------------------------私有方法模块End----------------------------------------
