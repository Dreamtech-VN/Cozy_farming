--WndMoneyTree.lua
--@brief	WndMoneyTree的UI模块
--@date		2022/07/21
--@author	XTX
--@note		摇钱树活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMoneyTree:onEnter(element)
	self.m_root = element

	g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
	ProtocolProcessorFestivalActivity:regAll6()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
	GlobalGame:getGameEventDispathcer():Add(Independent_Activity.ActivityReddot, self.showRedDot, self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetRankResult,self._onRankResult,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetTaskList,self._onGetTaskInfo,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetResult,self._onGetTaskResult,self)

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMoneyTree:onExit(element)
	g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
	ProtocolProcessorFestivalActivity:regAll6()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
	GlobalGame:getGameEventDispathcer():Remove(Independent_Activity.ActivityReddot, self.showRedDot, self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetRankResult,self._onRankResult,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetTaskList,self._onGetTaskInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetResult,self._onGetTaskResult,self)

	self:_unInit()
	LoadNewActivityRes(false)
end

--@brief    onenter函数已执行
function WndMoneyTree:onEnterTransitionDidFinish(element)
    WZLog("WndMoneyTree:onEnterTransitionDidFinish")
    self:_initStaticText()
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7054, 7054)
end

--@brief    关闭窗口
function WndMoneyTree:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    --如果是自动弹出的活动界面
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    关闭窗口
function WndMoneyTree:onClose()
	if self.m_root == nil then return end 
    --如果是自动弹出的活动界面
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮回调
function WndMoneyTree:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 
    WndSingleMapDesc:showInterface1(LocalStrings.MONEYTREE_TEXT2) 
end

--@brief 	点击目标按钮回调
function WndMoneyTree:onClickTask(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if self.m_nTabIndex == nTag then return end 
	self.m_nTabIndex = nTag
	self:_setConVisible()
	if nTag == 1 then 
		self:_showTree()
	elseif nTag == 2 then
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif nTag == 3 then 
		self:setOpenState(true)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 1, "")
	end
end

--@brief 	点击开启按钮回调
function WndMoneyTree:onClickFive(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	--背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
    if self.m_bOpenState then return end 

	local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local nLightNum2 = CacheCenter:getPlayerItemCountById(self.m_nCoinId2)
	local nTempTimes = nArrowNum + nLightNum2

	local nTimes = nTag
	if nTag == 2 then 
		nTag = self.m_nMaxOpTimes 
		nTimes = nTempTimes >= self.m_nMaxOpTimes and self.m_nMaxOpTimes or nTempTimes > 0 and nTempTimes or self.m_nMaxOpTimes 
	end
	local nCostNum = nTimes
	if nCostNum > nTempTimes then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId2]
		MsgBoxManager:showConfirmBox(string.format(LocalStrings.WATERCOUNTRY_TEXT4, basicData.name), self, self.goToBuy)
		return 
	end
    local tData = {}
	tData.times = nTag

	self.m_nShakeIndex = nTimes
	local stringData = json.encode(tData)

	self:setOpenState(true)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 3, stringData)
end

--@brief 	前往小推车购买
function WndMoneyTree:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

--@brief 	点击物品回调
function WndMoneyTree:onClickItem(tCell,tag,tData)
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root, self.m_root,1,tData,false,nil,true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndMoneyTree:_update()
	-- body
	self:showRedDot()
	self:_initActivityTime()
    self:_updateLightNum()
end

--@brief 	初始化静态文本
function WndMoneyTree:_initStaticText()
	GetElement(self.m_root, "txtBtnTask4_WndMoneyTree", WZUILabelTTF):setText(LocalStrings.MONEYTREE_TEXT1[1])
	GetElement(self.m_root, "txtBtnTask4Sel_WndMoneyTree", WZUILabelTTF):setText(LocalStrings.MONEYTREE_TEXT1[1])
	GetElement(self.m_root, "txtBtnTask2_WndMoneyTree", WZUILabelTTF):setText(LocalStrings.MONEYTREE_TEXT1[3])
	GetElement(self.m_root, "txtBtnTask2Sel_WndMoneyTree", WZUILabelTTF):setText(LocalStrings.MONEYTREE_TEXT1[3])
	GetElement(self.m_root, "txtBtnTask1_WndMoneyTree", WZUILabelTTF):setText(LocalStrings.MONEYTREE_TEXT1[2])
	GetElement(self.m_root, "txtBtnTask1Sel_WndMoneyTree", WZUILabelTTF):setText(LocalStrings.MONEYTREE_TEXT1[2])
	GetElement(self.m_root, "txtActivityTimeW_WndMoneyTree", WZUILabelTTF):setText(LocalStrings.ACTIVITY_TIME_KEY)
	GetElement(self.m_root, "txtBtnOpenOne_WndMoneyTree", WZUILabelTTF):setText(LocalStrings.MONEYTREE_TEXT1[5])
	GetElement(self.m_root, "txtBtnOpenFive_WndMoneyTree", WZUILabelTTF):setText(LocalStrings.MONEYTREE_TEXT1[6])
	GetElement(self.m_root, "txtTaskTitle_WndMoneyTree", WZUILabelTTF):setText(LocalStrings.MONEYTREE_TEXT1[7])
	GetElement(self.m_root, "txtTimes_WndMoneyTree", WZUILabelTTF):setText(LocalStrings.MONEYTREE_TEXT1[4])
	GetElement(self.m_root, "txtTimesWord_WndMoneyTree", WZUILabelTTF):setText(LocalStrings.MONEYTREE_TEXT1[4] .. ":")
	GetElement(self.m_root, "txtTitle3_WndMoneyTree", WZUILabelTTF):setText(LocalStrings.MONEYTREE_TEXT1[8])

	self:_setTowerAni()
end

--@brief 	红点
function WndMoneyTree:showRedDot()
	-- body
	if self.m_root == nil then return end 

	local imgTaskRedDot = GetElement(self.m_root, "imgTaskRedDot_WndMoneyTree", WZUIImage)

	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[117054] or GlobalGame.g_tRedPointTypeList[127054]) then 
		imgTaskRedDot:setVisible(true)
	else
		imgTaskRedDot:setVisible(false)
	end
end

--@brief 	更新异火的数量
function WndMoneyTree:_updateLightNum()
	-- body
	local ftxtLightNum = GetElement(self.m_root, "ftxtLightNum_WndMoneyTree", WZUIFreeTextBox)
	local sFormat = [[<T C="255,255,255" S="20" P="1" SC="132,66,29" SS="4" SE="1">%s</T><T C="255,250,119" S="20" P="1" SC="132,66,29" SS="4" SE="1">%d</T>]]
	if ftxtLightNum then 
		local nCostId = self.m_nCoinId
		local basicData = GDatatab_item["id_" .. nCostId]
		local nLightNum = CacheCenter:getPlayerItemCountById(nCostId)
		local nLightNum2 = CacheCenter:getPlayerItemCountById(self.m_nCoinId2)
		ftxtLightNum:setShowText(string.format(sFormat, LocalStrings.MONEYTREE_TEXT1[10], nLightNum + nLightNum2))
	end
end

--@brief 	初始化活动时间
function WndMoneyTree:_initActivityTime()
	-- body
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndMoneyTree", WZUILabelTTF)
    if txtActivityTime then 
    	txtActivityTime:setText(needDay_str)
    end

    local txtDate = GetElement(self.m_root, "txtDate_WndMoneyTree", WZUILabelTTF)
    local strDate = DayEndTab.month .. LocalStrings.SPACE31 .. DayEndTab.day .. LocalStrings.SPACE32
	txtDate:setText(string.format(LocalStrings.MONEYTREE_TEXT1[9], strDate, DayEndTab.hour, DayEndTab.min))
end

--@brief 	显示开启动画
function WndMoneyTree:showOpenAction()
	-- body
	--创建选中特效
	local spinePath = "activity/yaoqian"
	local existSpine = CheckEffectFile(spinePath)
	if not existSpine then 
		local _sIndex = "yaoqian"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7054, downloadInfo.url, downloadInfo.md5, _sIndex, "DownloadResourceCallback", _G)
        end
	end

	local spineOpen = GetElement(self.m_root, "spineOpen_WndMoneyTree", WZUISpine)
	if spineOpen then 
		if existSpine then 
			local nIndex = self.m_nShakeIndex > 1 and 2 or 1
			self:_setTowerPlayAni(nIndex, false)
			local nDelayTime = 1.2
			spineOpen:enableSchedule("showShootReward", nDelayTime)
		else
			self:showShootReward()
		end
	end
end

--@brief 	显示开启奖励
function WndMoneyTree:showShootReward()
	-- body
	local spineOpen = GetElement(self.m_root, "spineOpen_WndMoneyTree", WZUISpine)
	spineOpen:disableSchedule()
	self:_setTowerPlayAni(3, true)

	WndRewardShow:showById(self.m_tOpenResult.normalRewards.itemIds, self.m_tOpenResult.normalRewards.itemNums)
	self:setOpenState(false)
end

--@brief 	显示摇钱树
function WndMoneyTree:_showTree()
	self.m_nTaskInfoMark = 0

	ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 1)
end

--@brief 	显示任务
function WndMoneyTree:_showTaskContent()
	local tbTaskList = GetElement(self.m_root, "tbTaskList_WndMoneyTree", WZUITableContainer)
	tbTaskList:cleanTable()

	self.m_tTaskItemCell = {}
	local count = #self.m_tTaskData 
	for i = 1, count do
		local element, tLuaObj = CellMoneyTreeTask:createElement()
		element:setTag(i - 1)
		self.m_tTaskItemCell[i] = tLuaObj
		tbTaskList:setCellElement(element)
		tLuaObj:setGiftBuyMessage(i, self.m_tTaskData[i])
	end
end

--@brief 	显示榜单
function WndMoneyTree:_showRank(myRank, myPoint, tData)
	local txtMyRank = GetElement(self.m_root, "txtMyRank_WndMoneyTree", WZUILabelTTF)
	local txtMyTimes = GetElement(self.m_root, "txtMyTimes_WndMoneyTree", WZUILabelTTF)
	
	if myRank < 0 then
		txtMyRank:setText(LocalStrings.NOT_IN_RANKLIST)
	else
		txtMyRank:setText(myRank)
	end
	if myPoint < 0 then myPoint = 0 end
	txtMyTimes:setText(myPoint)

	local flRank = GetElement(self.m_root, "flRank_WndMoneyTree", WZUIFreeListContainer)

	for i = 1, #tData do
		local element, tLuaObj = CellShopRankItem:createElement(29)
		flRank:pushBack(WZUIContainer:luaTo(element))
		flRank:getMoveElement():setPositionY(flRank:getMinPosition().y)
		tLuaObj:setShopRankMessage(i, tData[i], 29)
	end
end

--@brief 	显示收益图
function WndMoneyTree:_showIncomeChart(earning)
	for i = 1, #earning do
		local pgrCoin = GetElement(self.m_root, "pgrCoin" .. i .. "_WndMoneyTree", WZUIProgress)
		local nPercentage = math.floor(100 * tonumber(earning[i]) / self.m_tCoinList[i][2])
		if nPercentage > 100 then 
			nPercentage = 100 
		end
		pgrCoin:setPercentage(nPercentage)

		local txtCoinName = GetElement(self.m_root, "txtCoinName" .. i .. "_WndMoneyTree", WZUILabelTTF)
		txtCoinName:setText(earning[i])
	end
end

--@brief 	显示隐藏相应的内容
function WndMoneyTree:_setConVisible()
	for i = 1, 3 do
		if self.m_nTabIndex == i then 
			GetElement(self.m_root, "conContent" .. i .. "_WndMoneyTree", WZUIContainer):setVisible(true)
		else
			GetElement(self.m_root, "conContent" .. i .. "_WndMoneyTree", WZUIContainer):setVisible(false)
		end
	end
end

--@brief 	设置待机特效
function WndMoneyTree:_setTowerAni()
	local spinePath = "activity/yaoqian"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		local spineOpen = GetElement(self.m_root, "spineOpen_WndMoneyTree", WZUISpine)
		if spineOpen then 
			spineOpen:setFileJson(spinePath .. ".json")
			spineOpen:setFileAtlas(spinePath .. ".atlas")
			self:_setTowerPlayAni(3, true)
		end
	else
		local _sIndex = "yaoqian"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7054, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndMoneyTree)
        end
	end

	local spinePath2 = "activity/yaoqian_daiji"
	local existSpine2 = CheckEffectFile(spinePath2)
	if existSpine2 then 
		local spineWait = GetElement(self.m_root, "spineWait_WndMoneyTree", WZUISpine)
		if spineWait then 
			spineWait:setFileJson(spinePath2 .. ".json")
			spineWait:setFileAtlas(spinePath2 .. ".atlas")
			spineWait:play("animation", true)
		end
	else
		local _sIndex = "yaoqian_daiji"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(70541, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndMoneyTree)
        end
	end
end

function WndMoneyTree:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndMoneyTree:downloadEffectCallback",taskId,extraData,failed)
    if failed == 0 then 
    	self:_setTowerAni()
    end
end

--@brief 	设置播放
--@param 	aniIndex:1摇1次；2大力摇；3待机
function WndMoneyTree:_setTowerPlayAni(aniIndex, bLoop)
	local spineOpen = GetElement(self.m_root, "spineOpen_WndMoneyTree", WZUISpine)
	aniIndex = aniIndex or 3
	if spineOpen then 
		spineOpen:play("wait_" .. aniIndex, bLoop ~= nil and bLoop or true)
	end
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配begin----------------------------------------

function WndMoneyTree:_adaptLanguage_vn( )
	GetElement(self.m_root, "pgrCoin2_WndMoneyTree", WZUIProgress):setVisible(false)
	GetElement(self.m_root, "txtCoinName2_WndMoneyTree", WZUILabelTTF):setVisible(false)
	GetElement(self.m_root, "pgrCoin1_WndMoneyTree", WZUIProgress):setRelativePosition(GlobalMethod:ccp(0.384,0.392))
	GetElement(self.m_root, "txtCoinName1_WndMoneyTree", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.41,0.69))
	GetElement(self.m_root, "pgrCoin3_WndMoneyTree", WZUIProgress):setRelativePosition(GlobalMethod:ccp(0.719,0.392))
	GetElement(self.m_root, "txtCoinName3_WndMoneyTree", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.745,0.69))

	local txtBtnTask4 = GetElement(self.m_root, "txtBtnTask4_WndMoneyTree", WZUILabelTTF)
	txtBtnTask4:setFontSize(18)
	txtBtnTask4:setDimensions(GlobalMethod:CCSize(100,0))
	local txtBtnTask4Sel = GetElement(self.m_root, "txtBtnTask4Sel_WndMoneyTree", WZUILabelTTF)
	txtBtnTask4Sel:setFontSize(18)
	txtBtnTask4Sel:setDimensions(GlobalMethod:CCSize(100,0))
	local txtBtnTask2 = GetElement(self.m_root, "txtBtnTask2_WndMoneyTree", WZUILabelTTF)
	txtBtnTask2:setFontSize(18)
	txtBtnTask2:setDimensions(GlobalMethod:CCSize(100,0))
	local txtBtnTask2Sel = GetElement(self.m_root, "txtBtnTask2Sel_WndMoneyTree", WZUILabelTTF)
	txtBtnTask2Sel:setFontSize(18)
	txtBtnTask2Sel:setDimensions(GlobalMethod:CCSize(100,0))
	local txtBtnTask1 = GetElement(self.m_root, "txtBtnTask1_WndMoneyTree", WZUILabelTTF)
	txtBtnTask1:setFontSize(18)
	txtBtnTask1:setDimensions(GlobalMethod:CCSize(100,0))
	local txtBtnTask1Sel = GetElement(self.m_root, "txtBtnTask1Sel_WndMoneyTree", WZUILabelTTF)
	txtBtnTask1Sel:setFontSize(18)
	txtBtnTask1Sel:setDimensions(GlobalMethod:CCSize(100,0))

	GetElement(self.m_root, "txtBtnOpenOne_WndMoneyTree", WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root, "txtActivityTime_WndMoneyTree", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.35,0.81))
	GetElement(self.m_root, "txtTaskTitle_WndMoneyTree", WZUILabelTTF):setScale(0.6)

	GetElement(self.m_root, "txtTitle3_WndMoneyTree", WZUILabelTTF):setFontSize(16)
end

-------------------------------------语言适配end----------------------------------------
