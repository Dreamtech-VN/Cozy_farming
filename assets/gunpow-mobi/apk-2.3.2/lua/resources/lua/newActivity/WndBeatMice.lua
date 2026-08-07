--WndBeatMice.lua
--@brief	WndBeatMice的UI模块
--@date		2022/03/03
--@author	XTX
--@note		欢乐地鼠活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndBeatMice:onEnter(element)
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
function WndBeatMice:onExit(element)
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
function WndBeatMice:onEnterTransitionDidFinish(element)
    WZLog("WndBeatMice:onEnterTransitionDidFinish")
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7037, 7037)
end

--@brief    关闭窗口
function WndBeatMice:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    --如果是自动弹出的活动界面
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮回调
function WndBeatMice:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 
    WndSingleMapDesc:showInterface1(LocalStrings.BEATMICE_TEXT2) 
end

--@brief 	点击目标按钮回调
function WndBeatMice:onClickTask(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if nTag == 1 then 
		CellNewYearTask:showInterface(9, self.m_nActivityId)
	elseif nTag == 2 then
		WndDollMachineShop:showInterface(3, self.m_nActivityId)
	elseif nTag == 3 then 
		WndShopRank:showInterface(19, self.m_nActivityId) 
	end
end

--@brief 	点击大奖预览按钮回调
function WndBeatMice:onClickBigReward(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WndJoinReward:showInterface("", self.m_tBigRewardList[1], self.m_tBigRewardList[2], LocalStrings.BEATMICE_TEXT1[5], nil, 2)
end

--@brief 	点击开启按钮回调
function WndBeatMice:onClickFive(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	--背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
    if self.m_bOpenState then return end 

	local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local nArrowNum = nArrowNum 
	if nTag > nArrowNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		MsgBoxManager:showConfirmBox(string.format(LocalStrings.WATERCOUNTRY_TEXT4, basicData.name), self, self.goToBuy)
		return 
	end
    local tData = {}
	tData.times = nTag

	local stringData = json.encode(tData)

	self:setOpenState(true)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 1, stringData)
end

--@brief 	前往小推车购买
function WndBeatMice:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

--@brief 	点击等级奖励按钮回调、
function WndBeatMice:onClickLvReward(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 5, "")
end

--@brief 	关闭捕鼠奖励界面
function WndBeatMice:onCloseTip(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	GetElement(self.m_root, "conLvReward_WndBeatMice", WZUIContainer):setVisible(false)
	local bIsReddot = false 
	for i = 1, #self.m_tLvRewardList do
		if self.m_tLvRewardList[i].status == 1 then 
			bIsReddot = true 
			break 
		end
	end
	GlobalGame.g_tRedPointTypeList[47037] = bIsReddot 
	self:showRedDot()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndBeatMice:_update()
	-- body
	self:showRedDot()
	self:_initActivityTime()
    self:_updateLightNum()
    self:_showLvAndExp()
    self:_showMice(1)
end

--@brief 	初始化静态文本
function WndBeatMice:_initStaticText()
	GetElement(self.m_root, "txtBtnOpenOne_WndBeatMice", WZUILabelTTF):setText(string.format(LocalStrings.BEATMICE_TEXT1[7], 1))
	GetElement(self.m_root, "txtBtnOpenFive_WndBeatMice", WZUILabelTTF):setText(string.format(LocalStrings.BEATMICE_TEXT1[7], 5))
	GetElement(self.m_root, "txtBigReward_WndBeatMice", WZUILabelTTF):setText(LocalStrings.BEATMICE_TEXT1[5])
	GetElement(self.m_root, "txtBtnTask1_WndBeatMice", WZUILabelTTF):setText(LocalStrings.BEATMICE_TEXT1[2])
	GetElement(self.m_root, "txtBtnTask2_WndBeatMice", WZUILabelTTF):setText(LocalStrings.BEATMICE_TEXT1[3])
	GetElement(self.m_root, "txtBtnTask3_WndBeatMice", WZUILabelTTF):setText(LocalStrings.BEATMICE_TEXT1[4])
	GetElement(self.m_root, "txtLvRewardT_WndBeatMice", WZUILabelTTF):setText(LocalStrings.BEATMICE_TEXT1[8])
end

--@brief 	红点
function WndBeatMice:showRedDot()
	-- body
	if self.m_root == nil then return end 

	local imgTaskRedDot = GetElement(self.m_root, "imgTaskRedDot_WndBeatMice", WZUIImage)
	local imgExpReddot = GetElement(self.m_root, "imgExpReddot_WndBeatMice", WZUIImage)

	if GlobalGame.g_tRedPointTypeList[117037] or GlobalGame.g_tRedPointTypeList[127037] or GlobalGame.g_tRedPointTypeList[137037] then 
		imgTaskRedDot:setVisible(true)
	else
		imgTaskRedDot:setVisible(false)
	end

	if GlobalGame.g_tRedPointTypeList[47037] then 
		imgExpReddot:setVisible(true)
	else
		imgExpReddot:setVisible(false)
	end
end

--@brief 	更新异火的数量
function WndBeatMice:_updateLightNum()
	-- body
	local ftxtLightNum = GetElement(self.m_root, "ftxtLightNum_WndBeatMice", WZUIFreeTextBox)
	local sFormat = [[<I Z="0.5" P="1">%s</I><T C="255,255,255" S="20" P="1" SC="132,66,29" SS="4" SE="1">%d</T>]]
	if ftxtLightNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
		ftxtLightNum:setShowText(string.format(sFormat, basicData.icon, nLightNum))
	end
end

--@brief 	初始化活动时间
function WndBeatMice:_initActivityTime()
	-- body
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndBeatMice", WZUILabelTTF)
    if txtActivityTime then 
    	txtActivityTime:setText(LocalStrings.ACTIVITY_TIME_KEY .. ":" .. needDay_str)
    end
end

--@brief 	显示开启动画
function WndBeatMice:showOpenAction()
	-- body
	self:_showMice(2)
end

--@brief 	显示开启奖励
function WndBeatMice:showShootReward()
	-- body
	if self.m_tOpenResult.dropCornNum > 0 then 
		local basicData = GDatatab_item["id_" .. self.m_nDropCoinId]
		local strContent = string.format(LocalStrings.YEARMONSTER_TEXT1[11], basicData.name, self.m_tOpenResult.dropCornNum)
		MsgBoxManager:showTipBox(strContent, nil, nil, nil, nil, nil, nil, nil, nil, {x=0.5, y=0.78})
	end
	self:_afterCloseReward()
end

--@brief 	iphoneX适配
function WndBeatMice:_adaptIphoneX()
	if IsIphoneX() then
		GetElement(self.m_root, "conLeftMenu_WndBeatMice", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.13,0.45))
	end
end

--@brief 	显示等级、经验
function WndBeatMice:_showLvAndExp()
	local txtLevel = GetElement(self.m_root, "txtLevel_WndBeatMice", WZUILabelTTF)
	local txtLvTitle = GetElement(self.m_root, "txtLvTitle_WndBeatMice", WZUILabelTTF)
	local txtExp = GetElement(self.m_root, "txtExp_WndBeatMice", WZUILabelTTF)
	local prgExp = GetElement(self.m_root, "prgExp_WndBeatMice", WZUIProgress)

	local tCurInfo, tNextInfo, nMaxLv = self:getCurLvInfo()
	local nCurLevel = 0 
	local strLvTitle = ""
	if tCurInfo then 
		nCurLevel = tCurInfo.lv
		strLvTitle = tCurInfo.name 
	end
	txtLevel:setText(LocalStrings.LV .. nCurLevel)
	txtLvTitle:setText(strLvTitle)
	if tCurInfo.lv >= nMaxLv then 
		txtExp:setText("Max")
	else
		txtExp:setText(self.m_nCurExp .. "/" .. tNextInfo.exp)
	end

	local nPercentage = math.floor(100 * self.m_nCurExp/tNextInfo.exp)
	if nPercentage > 100 then 
		nPercentage = 100
	end
	prgExp:setPercentage(nPercentage)
end

--@brief 	创建捕鼠奖励
function WndBeatMice:_createLvRewardList()
	local tbLvRewardList = GetElement(self.m_root, "tbLvRewardList_WndBeatMice", WZUITableContainer)
	tbLvRewardList:cleanTable()

	for i = 1, #self.m_tLvRewardList do
		local element, tNewObj = CellLvRewardItem:createElement()
		if element and tNewObj then
			element:setTag(i - 1)
			tNewObj:setData(self.m_tLvRewardList[i])

			tbLvRewardList:setCellElement(element)
		end
	end
end

--@brief 	显示地鼠
function WndBeatMice:_showMice(nIndex)
	if nIndex == 1 then --地鼠显示、间隔刷新地鼠位置
		for i = 1, 10 do
			local conHole = GetElement(self.m_root, "conHole" .. i .. "_WndBeatMice", WZUIContainer)
			local spineOpen = GetElement(conHole, "spineOpen_WndBeatMice", WZUISpine)
			spineOpen:setFileJson("")
			spineOpen:setFileAtlas("")
			spineOpen:setAnimationName("")
			spineOpen:setRelativePosition(GlobalMethod:ccp(0.5, 0.04))
		end

		for i = 1, #self.m_tMiceList do
			local conHole = GetElement(self.m_root, "conHole" .. self.m_tMiceList[i][1] .. "_WndBeatMice", WZUIContainer)
			local spineOpen = GetElement(conHole, "spineOpen_WndBeatMice", WZUISpine)
			local fileName = self.m_tMiceSpineFile[self.m_tMiceList[i][2]]
			local existSpine = CheckEffectFile(fileName)
			local actionIndex = self.m_tMiceList[i][3] or 1
			if existSpine then 
				spineOpen:setFileJson(fileName .. ".json")
				spineOpen:setFileAtlas(fileName .. ".atlas")
				spineOpen:play("wait_" .. actionIndex, true)
			end
		end
	elseif nIndex == 2 then --打地鼠后动画表演
		local conOpenAct = GetElement(self.m_root, "conOpenAct_WndBeatMice", WZUIContainer)
		for i = 1, self.m_tOpenResult.times do
			local spineBeatEffect = GetElement(self.m_root, "spineBeatEffect" .. self.m_tMiceList[i][1] .. "_WndBeatMice", WZUISpine)
			local fileName = "activity/ui_dishu_dds"
			local existSpine = CheckEffectFile(fileName)
			--打地鼠特效
			if existSpine then 
				spineBeatEffect:setVisible(true)
				spineBeatEffect:setFileJson(fileName .. ".json")
				spineBeatEffect:setFileAtlas(fileName .. ".atlas")
				spineBeatEffect:play("wait1", false)
				spineBeatEffect:enableSchedule("hideBeatEffect", 0.6)
			end
		end
		for i = 1, self.m_tOpenResult.times do
			local conHole = GetElement(self.m_root, "conHole" .. self.m_tMiceList[i][1] .. "_WndBeatMice", WZUIContainer)
			local spineOpen = GetElement(conHole, "spineOpen_WndBeatMice", WZUISpine)
			local fileName = self.m_tMiceSpineFile[self.m_tMiceList[i][2]]
			local existSpine = CheckEffectFile(fileName)
			local actionIndex = self.m_tMiceList[i][3] or 1
			if existSpine then 
				spineOpen:setFileJson(fileName .. ".json")
				spineOpen:setFileAtlas(fileName .. ".atlas")
				spineOpen:play("wound_" .. actionIndex, false)
			end
			--地鼠掉坑动画
			local moveTo = WZUIActionMoveTo:create()
		    moveTo:setMoveX(0.5)
		    moveTo:setMoveY(-0.99)
		    moveTo:setDuration(0.3)
		    if i == self.m_tOpenResult.times then 
		    	moveTo:setFinishLuaFunction("buildNewMice")
		    end
		    spineOpen:runUIAction(moveTo)
		end
	elseif nIndex == 3 then 
		if self.m_tOpenResult.times == 5 then 
			for i = 1, 10 do
				local conHole = GetElement(self.m_root, "conHole" .. i .. "_WndBeatMice", WZUIContainer)
				local spineOpen = GetElement(conHole, "spineOpen_WndBeatMice", WZUISpine)
				spineOpen:setFileJson("")
				spineOpen:setFileAtlas("")
				spineOpen:setAnimationName("")
				spineOpen:setRelativePosition(GlobalMethod:ccp(0.5, -0.99))
			end
			self:_setMiceList()
			for i = 1, self.m_tOpenResult.times do
				local conHole = GetElement(self.m_root, "conHole" .. self.m_tMiceList[i][1] .. "_WndBeatMice", WZUIContainer)
				local spineOpen = GetElement(conHole, "spineOpen_WndBeatMice", WZUISpine)
				local fileName = self.m_tMiceSpineFile[self.m_tMiceList[i][2]]
				local existSpine = CheckEffectFile(fileName)
				local actionIndex = self.m_tMiceList[i][3] or 1
				if existSpine then 
					spineOpen:setFileJson(fileName .. ".json")
					spineOpen:setFileAtlas(fileName .. ".atlas")
					spineOpen:play("wait_" .. actionIndex, true)
				end
				--地鼠掉坑动画
				local moveTo = WZUIActionMoveTo:create()
			    moveTo:setMoveX(0.5)
			    moveTo:setMoveY(0.04)
			    moveTo:setDuration(0.3)
			    if i == self.m_tOpenResult.times then 
			    	moveTo:setFinishLuaFunction("buildNewMiceFinish")
			    end
			    spineOpen:runUIAction(moveTo)
			end
		elseif self.m_tOpenResult.times == 1 then 
			table.remove(self.m_tMiceList, 1)
			local miceIndex = 1
			local temp = math.random(1, 100)
			for i = 1, #self.m_tContent.shrewmouse do
				if self.m_tContent.shrewmouse[i] > 0 then 
					local tItem = {}
					tItem[1] = i 
					tItem[2] = self.m_tContent.shrewmouse[i]
					tItem[3] = math.fmod(temp, 3) + 1
					local bIsUse = false 
					for j = 1, #self.m_tMiceList do
						if self.m_tMiceList[j][1] == i then 
							bIsUse = true 
							break 
						end
					end
					while bIsUse do
						tItem[1] = tItem[1] + 1
						if tItem[1] > 10 then 
							tItem[1] = 1
						end
						bIsUse = false 
						for j = 1, #self.m_tMiceList do
							if self.m_tMiceList[j][1] == tItem[1] then 
								bIsUse = true 
								break 
							end
						end
					end 
					if not bIsUse then 
						if tItem[2] > 1 then 
							table.insert(self.m_tMiceList, 1, tItem)
						else
							table.insert(self.m_tMiceList, tItem)
							miceIndex = #self.m_tMiceList
						end
					end
					break 
				end
			end

			local conHole = GetElement(self.m_root, "conHole" .. self.m_tMiceList[miceIndex][1] .. "_WndBeatMice", WZUIContainer)
			local spineOpen = GetElement(conHole, "spineOpen_WndBeatMice", WZUISpine)
			spineOpen:setFileJson("")
			spineOpen:setFileAtlas("")
			local fileName = self.m_tMiceSpineFile[self.m_tMiceList[miceIndex][2]]
			local existSpine = CheckEffectFile(fileName)
			local actionIndex = self.m_tMiceList[miceIndex][3] or 1
			if existSpine then 
				spineOpen:setFileJson(fileName .. ".json")
				spineOpen:setFileAtlas(fileName .. ".atlas")
				spineOpen:play("wait_" .. actionIndex, true)
			end
			--地鼠掉坑动画
			local moveTo = WZUIActionMoveTo:create()
		    moveTo:setMoveX(0.5)
		    moveTo:setMoveY(0.04)
		    moveTo:setDuration(0.3)
		    moveTo:setFinishLuaFunction("buildNewMiceFinish")
		    spineOpen:runUIAction(moveTo)
		end
	elseif nIndex == 4 then 
		for i = 1, 5 do
			local conHole = GetElement(self.m_root, "conHole" .. self.m_tMiceList[i][1] .. "_WndBeatMice", WZUIContainer)
			local spineOpen = GetElement(conHole, "spineOpen_WndBeatMice", WZUISpine)
			--地鼠掉坑动画
			local moveTo = WZUIActionMoveTo:create()
		    moveTo:setMoveX(0.5)
		    moveTo:setMoveY(-0.99)
		    moveTo:setDuration(0.3)
		    if i == 5 then 
		    	moveTo:setFinishLuaFunction("hideAllMice")
		    end
		    spineOpen:runUIAction(moveTo)
		end
	elseif nIndex == 5 then 
		for i = 1, 10 do
			local conHole = GetElement(self.m_root, "conHole" .. i .. "_WndBeatMice", WZUIContainer)
			local spineOpen = GetElement(conHole, "spineOpen_WndBeatMice", WZUISpine)
			spineOpen:setFileJson("")
			spineOpen:setFileAtlas("")
			spineOpen:setAnimationName("")
			spineOpen:setRelativePosition(GlobalMethod:ccp(0.5, -0.99))
		end
		for i = 1, 5 do
			local conHole = GetElement(self.m_root, "conHole" .. self.m_tMiceList[i][1] .. "_WndBeatMice", WZUIContainer)
			local spineOpen = GetElement(conHole, "spineOpen_WndBeatMice", WZUISpine)
			local fileName = self.m_tMiceSpineFile[self.m_tMiceList[i][2]]
			local existSpine = CheckEffectFile(fileName)
			local actionIndex = self.m_tMiceList[i][3] or 1
			if existSpine then 
				spineOpen:setFileJson(fileName .. ".json")
				spineOpen:setFileAtlas(fileName .. ".atlas")
				spineOpen:play("wait_" .. actionIndex, true)
			end
			--地鼠掉坑动画
			local moveTo = WZUIActionMoveTo:create()
		    moveTo:setMoveX(0.5)
		    moveTo:setMoveY(0.04)
		    moveTo:setDuration(0.3)
		    if i == 5 then 
		    	moveTo:setFinishLuaFunction("updateMicePosFinish")
		    end
		    spineOpen:runUIAction(moveTo)
		end
	end
end

--@brief 	生成新地鼠
function WndBeatMice:buildNewMice()
	self:showShootReward()

	self:_showMice(3)
end

--@brief 	生成新地鼠
function WndBeatMice:buildNewMiceFinish()
	self.m_nTimeCaculate = 0
	self:setOpenState(false)
end

--@brief 	更新地鼠的位置
function WndBeatMice:_updateMicePos(element, delta)
	if self.m_bOpenState then return end 

	self.m_nTimeCaculate = self.m_nTimeCaculate + 1

	if self.m_nTimeCaculate >= 7 then 
		self:setOpenState(true)
		self.m_nTimeCaculate = 0
		self:_showMice(4)
	end
end

--@brief 	隐藏打击特效
function WndBeatMice:hideBeatEffect(element)
	element:disableSchedule()
	element = WZUISpine:luaTo(element)
	element:setFileJson("")
	element:setFileAtlas("")
	element:setVisible(false)
end

--@brief 	隐藏所有地鼠
function WndBeatMice:hideAllMice()
	local tRandomList = GetRandomNum(5, 10, 1)
	WZLog("WndBeatMice:_updateMicePos", Serialize(tRandomList))
	local tRandomListTwo = GetRandomNum(5, 100, 1)
	for i = 1, #tRandomList do
		self.m_tMiceList[i][1] = tRandomList[i]
		self.m_tMiceList[i][3] = math.fmod(tRandomListTwo[i], 3) + 1
	end
	self:_showMice(5)
end

--@brief 	刷新地鼠位置完成回调
function WndBeatMice:updateMicePosFinish()
	self.m_nTimeCaculate = 0
	self:setOpenState(false)
end
-------------------------------------私有方法模块End----------------------------------------

function WndBeatMice:_adaptLanguage_vn()
	local txtBtnTask1 = GetElement(self.m_root, "txtBtnTask1_WndBeatMice", WZUILabelTTF)
	txtBtnTask1:setScale(0.8)
	txtBtnTask1:setDimensions(GlobalMethod:CCSize(120,0))
	local txtBtnTask2 = GetElement(self.m_root, "txtBtnTask2_WndBeatMice", WZUILabelTTF)
	txtBtnTask2:setScale(0.8)
	txtBtnTask2:setDimensions(GlobalMethod:CCSize(120,0))
	local txtBtnTask3 = GetElement(self.m_root, "txtBtnTask3_WndBeatMice", WZUILabelTTF)
	txtBtnTask3:setScale(0.8)
	txtBtnTask3:setDimensions(GlobalMethod:CCSize(120,0))
	GetElement(self.m_root, "txtActivityTime_WndBeatMice", WZUILabelTTF):setScale(0.85)

	local txtLevel = GetElement(self.m_root, "txtLevel_WndBeatMice", WZUILabelTTF)
	txtLevel:setScale(0.7)
end