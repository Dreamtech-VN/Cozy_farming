--WndCrazyDoubling.lua
--@brief	WndCrazyDoubling的UI模块
--@date		2020/07/30
--@author	yrd
--@note		疯狂翻倍


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCrazyDoubling:onEnter(element)
	self.m_root = element
	--@brief	复用的操作协议（ACTIVITY2_ActivityDoOk = 108）
	ProtocolProcessorFestivalActivity:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_ActivityDoOk, "ProtocolProcessorFestivalActivity:parse_ACTIVITY2_ActivityDoOk", "iiiis")
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)

end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCrazyDoubling:onExit(element)
	self.m_root:disableSchedule()
	--@brief	复用的操作协议（ACTIVITY2_ActivityDoOk = 108）
	ProtocolProcessorFestivalActivity:unregProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_ActivityDoOk, "ProtocolProcessorFestivalActivity:parse_ACTIVITY2_ActivityDoOk", "iiiis")
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)

	self:_unInit()
	if WZFileUtil:isFileExist("pack/taboo/pack_taboo_0.plist") then
        CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("pack/taboo/pack_taboo_0.plist")
    end
	if WZFileUtil:isFileExist("pack/taboo/pack_taboo_1.plist") then
        CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("pack/taboo/pack_taboo_1.plist")
    end
end

--@brief 	界面加载完成回调
function WndCrazyDoubling:onEnterTransitionDidFinish(element)
end

--@brief 	显示
function WndCrazyDoubling:showWindow()
	self:_refreshActivity()
	self:_initUIText()
	self:updateTask()
	self:showDiceByTask()
end

--@brief 	倒计时
function WndCrazyDoubling:_refreshActivity()
    self.m_root:enableSchedule("_refreshCountDown", 1)
end

function WndCrazyDoubling:_refreshCountDown(element)
	self.nDayCountDown = self.nDayCountDown - 1
	if self.nDayCountDown <= 0 then
		self:sendProtocolActivityInfo()
	end
end

--@brief 	初始化界面
function WndCrazyDoubling:updateTask()
	GetElement(self.m_root,"ftbDesc_WndCrazyDoubling",WZUIFreeTextBox):setShowText(LocalStrings.CRAZY_DOUBLING_TEXT9)

	local tabconTask = GetElement(self.m_root,"tabconTask_WndCrazyDoubling",WZUITableContainer)
	tabconTask:cleanTable()
	self.m_tTaskObj = {}
    for i = 1, #self.m_tTaskData do
        local cell,tcell = CellCrazyDoubling:createElement()
        cell:setTag(i-1)
        tabconTask:setCellElement(cell)
        tcell:setData(self.m_tTaskData[i])
        tcell:setClickCallback(self,self.onSelectTask)
        --红点
        tcell:showRedDot(self.m_tTaskData[i].taskStatus == 0)

        self.m_tTaskObj[i] = tcell
        tcell:showSelectionBox(false)
    end
    self.m_tTaskObj[self.m_nSelIndex]:showSelectionBox(true)

    self:updateBtnStatus()
end

--@brief 	选择任务回调
function WndCrazyDoubling:onSelectTask(tag)
	for i=1,5 do
    	self.m_tTaskObj[i]:showSelectionBox(false)
	end
	self.m_nSelIndex = tag
    self.m_tTaskObj[self.m_nSelIndex]:showSelectionBox(true)

    self:updateBtnStatus()
    self:showDiceByTask()
end

--@brief 	刷新按钮状态
function WndCrazyDoubling:updateBtnStatus()
	local btnReceive = GetElement(self.m_root,"btnReceive_WndCrazyDoubling",WZUIButton)
	local btnDoubling = GetElement(self.m_root,"btnDoubling_WndCrazyDoubling",WZUIButton)

	local taskStatus = self.m_tTaskData[self.m_nSelIndex].taskStatus
	local taskCurDoubling = self.m_tTaskData[self.m_nSelIndex].taskCurDoubling --已翻倍次数
	local taskTatolDoubling = self.m_tTaskData[self.m_nSelIndex].taskTatolDoubling --总翻倍次数
	if taskStatus == 0 then
		btnReceive:setTouchEnable(true)
	else
		btnReceive:setTouchEnable(false)
	end
	if taskStatus ~= -1 and taskCurDoubling < taskTatolDoubling then
		btnDoubling:setTouchEnable(true)
	else
		btnDoubling:setTouchEnable(false)
	end
end

--@brief 	点击奖励的弹窗
function WndCrazyDoubling:addTips(luaTable,tag,tData)
	WndItemInfo:showInfo(luaTable.m_root,self.m_root,1,tData, false)
end

--@brief 	显示一个任务翻过的骰子点数
--@param	nIndex:第几个任务
function WndCrazyDoubling:showDiceByTask()
	local nPointNum = self.m_tDicePoints[self.m_nSelIndex][1]+self.m_tDicePoints[self.m_nSelIndex][2]+self.m_tDicePoints[self.m_nSelIndex][3]
	--如果没有翻倍过,点数就默认显示1
	if self.m_tTaskData[self.m_nSelIndex].taskCurDoubling == 0 then
		nPointNum = 1
	end
	GetElement(self.m_root,"txtBuyTimes_WndCrazyDoubling",WZUILabelTTF):setText(nPointNum)
	self:updateDice(self.m_tDicePoints[self.m_nSelIndex][1],self.m_tDicePoints[self.m_nSelIndex][2],self.m_tDicePoints[self.m_nSelIndex][3])
end

--@brief 	刷新骰子
--@param	first,second,third表示3个骰子点数 值取1~6
function WndCrazyDoubling:updateDice(first,second,third)
	local imgDice1 = GetElement(self.m_root,"imgDice1_WndCrazyDoubling",WZUIImage)
	local imgDice2 = GetElement(self.m_root,"imgDice2_WndCrazyDoubling",WZUIImage)
	local imgDice3 = GetElement(self.m_root,"imgDice3_WndCrazyDoubling",WZUIImage)
	local spineDice1 = GetElement(self.m_root,"spineDice1_SceneTabooBattle",WZUISpine)
	local spineDice2 = GetElement(self.m_root,"spineDice2_SceneTabooBattle",WZUISpine)
	local spineDice3 = GetElement(self.m_root,"spineDice3_SceneTabooBattle",WZUISpine)

	if first == 0 then
		spineDice1:setVisible(true)
		imgDice1:setVisible(false)
	else
		spineDice1:setVisible(false)
		imgDice1:setVisible(true)
		imgDice1:setFile("ui/taboo/common_icon_shaizi0"..first..".png")
	end

	if second == 0 then
		spineDice2:setVisible(true)
		imgDice2:setVisible(false)
	else
		spineDice2:setVisible(false)
		imgDice2:setVisible(true)
		imgDice2:setFile("ui/taboo/common_icon_shaizi0"..second..".png")
	end

	if third == 0 then
		spineDice3:setVisible(true)
		imgDice3:setVisible(false)
	else
		spineDice3:setVisible(false)
		imgDice3:setVisible(true)
		imgDice3:setFile("ui/taboo/common_icon_shaizi0"..third..".png")
	end
end

--@brief 	领取奖励
function WndCrazyDoubling:onClickReceive(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	-- MsgBoxManager:showConfirmCancelBox(LocalStrings.CRAZY_DOUBLING_TEXT6, self,self.sureToReceive, nil, nil)

	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(self.m_activityId, self.m_nSelIndex-1)
end

function WndCrazyDoubling:sureToReceive(nId,nType)
	if nType == MSGBOXRESTYPE_CONFIRM then
		ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(self.m_activityId, self.m_nSelIndex-1)
	end
end

--@brief 	翻倍奖励
function WndCrazyDoubling:onClickDoubling(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local crazyDoubleCost = CacheCenter:getGameParam().crazyDoubleCost
	local strCrazyDoubleCost = string.sub(crazyDoubleCost,2,-2)
	local arrCrazyDoubleCost = SplitStringWithSeparator(strCrazyDoubleCost, ",", nil, true)

	local count = CacheCenter:getPlayerItemCountById(arrCrazyDoubleCost[1])
	if count < arrCrazyDoubleCost[2] then
		local basicData = GDatatab_item["id_" .. arrCrazyDoubleCost[1]]
		MsgBoxManager:showTipBox(string.format(LocalStrings.CARD_COUNT1, basicData.name))
		return
	end
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_CrazyDouble(self.m_nSelIndex)
end

function WndCrazyDoubling:playDiceAni()
	local conDice = GetElement(self.m_root,"conDice_WndCrazyDoubling",WZUIContainer)
	self.nDiceCountDown = 0
    conDice:enableSchedule("_animationCountDown", 0.25)
end

function WndCrazyDoubling:_animationCountDown(element,dt)
	local conDice = GetElement(self.m_root,"conDice_WndCrazyDoubling",WZUIContainer)
	local dtTime = math.ceil(dt) --等于1
	self.nDiceCountDown = self.nDiceCountDown + dtTime

	if self.nDiceCountDown >= 4 then
		self:updateDice(self.tDice[1],self.tDice[2],self.tDice[3])
		local num = self.tDice[1]+self.tDice[2]+self.tDice[3]
		WndDoublingReward:showInterface(self.tItemId, self.nItemNum, num)
		conDice:disableSchedule()
	elseif self.nDiceCountDown >= 3 then
		self:updateDice(self.tDice[1],self.tDice[2],0)
	elseif self.nDiceCountDown >= 2 then
		self:updateDice(self.tDice[1],0,0)
	else
		self:updateDice(0,0,0)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


--@brief 	初始化UI文本
function WndCrazyDoubling:_initUIText()
	local crazyDoubleCost = CacheCenter:getGameParam().crazyDoubleCost
	local strCrazyDoubleCost = string.sub(crazyDoubleCost,2,-2)
	local arrCrazyDoubleCost = SplitStringWithSeparator(strCrazyDoubleCost, ",", nil, true)
	local basicData = GDatatab_item["id_" .. arrCrazyDoubleCost[1]]
	local strFormat = [[<I Z="0.5" P="1">%s</I><T C="255,250,236" S="24" P="1" SC="0,108,3" SS="4" SE="1">%s</T>]]
	local ftbDoubling1 = GetElement(self.m_root, "ftbDoubling1_WndCrazyDoubling", WZUIFreeTextBox)
	local ftbDoubling2 = GetElement(self.m_root, "ftbDoubling2_WndCrazyDoubling", WZUIFreeTextBox)
	local ftbDoubling3 = GetElement(self.m_root, "ftbDoubling3_WndCrazyDoubling", WZUIFreeTextBox)
	ftbDoubling1:setShowText(string.format(strFormat, basicData.icon, arrCrazyDoubleCost[2]))
	ftbDoubling2:setShowText(string.format(strFormat, basicData.icon, arrCrazyDoubleCost[2]))
	ftbDoubling3:setShowText(string.format(strFormat, basicData.icon, arrCrazyDoubleCost[2]))
	-- body
	local txtTimeWords = GetElement(self.m_root, "txtTimeWords_WndCrazyDoubling", WZUILabelTTF)
	if txtTimeWords then 
		txtTimeWords:setText(LocalStrings.ACTIVITY_TIME_KEY .. ":")
	end
	--活动时间
	local DayStartTab = os.date("*t", self.m_startTime)
    local DayEndTab = os.date("*t", self.m_endTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtTimeValue = GetElement(self.m_root, "txtTimeValue_WndCrazyDoubling", WZUILabelTTF)
    if txtTimeValue then 
    	txtTimeValue:setText(needDay_str)
    end
end


-------------------------------------私有方法模块End----------------------------------------
