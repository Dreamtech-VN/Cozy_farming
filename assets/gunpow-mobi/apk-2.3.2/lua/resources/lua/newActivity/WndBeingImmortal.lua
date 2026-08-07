--WndBeingImmortal.lua
--@brief	WndBeingImmortal的UI模块
--@date		2022/12/01
--@author	XTX
--@note		修仙传活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndBeingImmortal:onEnter(element)
	self.m_root = element

	g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
	ProtocolProcessorFestivalActivity:regAll6()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
	GlobalGame:getGameEventDispathcer():Add(Independent_Activity.ActivityReddot, self.showRedDot, self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetTaskList,self._onGetTaskInfo,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetResult,self._onGetTaskResult,self)

	self:_initStaticText()
	self:_adaptIphoneX()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndBeingImmortal:onExit(element)
	g_bIsShowWndDressUp = true
    g_tTempItemForLaterShow = {}
	CacheCenter:unregisterUpatePlayerItemObserver(self)
	ProtocolProcessorFestivalActivity:unregAll6()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
	GlobalGame:getGameEventDispathcer():Remove(Independent_Activity.ActivityReddot, self.showRedDot, self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetTaskList,self._onGetTaskInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetResult,self._onGetTaskResult,self)

	self:_unInit()
	LoadNewActivityRes(false)
end

--@brief    onenter函数已执行
function WndBeingImmortal:onEnterTransitionDidFinish(element)
    WZLog("WndBeingImmortal:onEnterTransitionDidFinish")
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7061, 7061)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(g_cityExtenInfo.activity7061, -1, 4)
end

--@brief    关闭窗口
function WndBeingImmortal:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    --如果是自动弹出的活动界面
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮回调
function WndBeingImmortal:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 
    WndSingleMapDesc:showInterface1(LocalStrings.BEINGIMMORTAL_TEXT2) 
end

--@brief 	点击目标按钮回调
function WndBeingImmortal:onClickTask(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if nTag == 1 then 
		CellNewYearTask:showInterface(20, self.m_nActivityId)
	elseif nTag == 2 then
		WndShopRank:showInterface(36, self.m_nActivityId) 
	elseif nTag == 3 then 
		WndShopRank:showInterface(34, self.m_nActivityId) 
	elseif nTag == 4 then 
		WndFlyUp:showInterface(self.m_nActivityId) 
	end
end

--@brief 	点击大奖预览按钮回调
function WndBeingImmortal:onClickBigReward(element)
	-- body
	local eleType = type(element)
	if eleType ~= "number" then 
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	end

	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 5, "")
end

--@brief 	点击开启按钮回调
function WndBeingImmortal:onClickFive(element)
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
		SaveOperateTimes("BEINGIMMORTALACTIVITYID", self.m_nActivityId)
    	return 
    end

	local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local nTempTimes = nArrowNum
	local nTimes = nTag
	if nTag == 5 then 
		nTag = self.m_nMaxLotteryCount 
		nTimes = nTempTimes >= self.m_nMaxLotteryCount and self.m_nMaxLotteryCount or nTempTimes > 0 and nTempTimes or self.m_nMaxLotteryCount 
	end
	local nCostNum = nTimes
	if nCostNum > nArrowNum then 
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
function WndBeingImmortal:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

--@brief 	点击等级奖励按钮回调、
function WndBeingImmortal:onClickLvReward(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	GetElement(self.m_root, "conLvReward_WndBeingImmortal", WZUIContainer):setVisible(true)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(g_cityExtenInfo.activity7061, -1, 4)
end

--@brief 	关闭捕鼠奖励界面
function WndBeingImmortal:onCloseTip(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	GetElement(self.m_root, "conLvReward_WndBeingImmortal", WZUIContainer):setVisible(false)
	local bIsReddot = false 
	for i = 1, #self.m_tLvRewardList do
		if self.m_tLvRewardList[i].status == 1 then 
			bIsReddot = true 
			break 
		end
	end
	GlobalGame.g_tRedPointTypeList[247061] = bIsReddot 
	self:showRedDot()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndBeingImmortal:_update()
	-- body
	self:_setFreeBtnText()
	self:showRedDot()
	self:_initActivityTime()
    self:_updateLightNum()
end

--@brief 	初始化静态文本
function WndBeingImmortal:_initStaticText()
	GetElement(self.m_root, "txtBtnOpenOne_WndBeingImmortal", WZUILabelTTF):setText(string.format(LocalStrings.BEINGIMMORTAL_TEXT1[5], 1))
	GetElement(self.m_root, "txtBigReward_WndBeingImmortal", WZUILabelTTF):setText(LocalStrings.BEINGIMMORTAL_TEXT1[8])
	GetElement(self.m_root, "txtBtnTask1_WndBeingImmortal", WZUILabelTTF):setText(LocalStrings.BEINGIMMORTAL_TEXT1[2])
	GetElement(self.m_root, "txtBtnTask2_WndBeingImmortal", WZUILabelTTF):setText(LocalStrings.BEINGIMMORTAL_TEXT1[3])
	GetElement(self.m_root, "txtBtnTask3_WndBeingImmortal", WZUILabelTTF):setText(LocalStrings.BEINGIMMORTAL_TEXT1[6])
	GetElement(self.m_root, "txtLvRewardT_WndBeingImmortal", WZUILabelTTF):setText(LocalStrings.BEINGIMMORTAL_TEXT1[9])
	GetElement(self.m_root, "txtFlyupBtn_WndBeingImmortal", WZUILabelTTF):setText(LocalStrings.BEINGIMMORTAL_TEXT1[34])

	for i = 1, 5 do
		local txtMapName = GetElement(self.m_root, "txtMapName" .. i .. "_WndBeingImmortal", WZUILabelTTF)
		txtMapName:setText(LocalStrings.BEINGIMMORTAL_TEXT1[32][i])
	end
	self:_setBallAni()
end

--@brief 	红点
function WndBeingImmortal:showRedDot()
	-- body
	if self.m_root == nil then return end 

	local imgTaskRedDot = GetElement(self.m_root, "imgTaskRedDot_WndBeingImmortal", WZUIImage)
	local imgExpReddot = GetElement(self.m_root, "imgExpReddot_WndBeingImmortal", WZUIImage)
	local imgCardRedDot = GetElement(self.m_root, "imgCardRedDot_WndBeingImmortal", WZUIImage)

	if GlobalGame.g_tRedPointTypeList[217061] or GlobalGame.g_tRedPointTypeList[227061] then 
		imgTaskRedDot:setVisible(true)
	else
		imgTaskRedDot:setVisible(false)
	end

	if GlobalGame.g_tRedPointTypeList[247061] then 
		imgExpReddot:setVisible(true)
	else
		imgExpReddot:setVisible(false)
	end

	if GlobalGame.g_tRedPointTypeList[237061] then 
		imgCardRedDot:setVisible(true)
	else
		imgCardRedDot:setVisible(false)
	end
end

--@brief 	更新异火的数量
function WndBeingImmortal:_updateLightNum()
	-- body
	local ftxtLightNum = GetElement(self.m_root, "ftxtLightNum_WndBeingImmortal", WZUIFreeTextBox)
	local sFormat = [[<I Z="0.5" P="1">%s</I><T C="255,255,255" S="20" P="1" SC="132,66,29" SS="4" SE="1">%d</T>]]
	if ftxtLightNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
		ftxtLightNum:setShowText(string.format(sFormat, basicData.icon, nLightNum))
	end
end

--@brief 	初始化活动时间
function WndBeingImmortal:_initActivityTime()
	-- body
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndBeingImmortal", WZUILabelTTF)
    local txtActivityTimeW = GetElement(self.m_root, "txtActivityTimeW_WndBeingImmortal", WZUILabelTTF)
    txtActivityTimeW:setText(LocalStrings.ACTIVITY_TIME_KEY )
    if txtActivityTime then 
    	txtActivityTime:setText(needDay_str)
    end
end

--@brief 	显示开启动画
function WndBeingImmortal:showOpenAction()
	-- body
	local spinePath = "activity/ui_xiuxian_zhandou"
	local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".json")
	if not existSpine then 
		local _sIndex = "ui_xiuxian_zhandou"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7061, downloadInfo.url, downloadInfo.md5, _sIndex, "DownloadResourceCallback", _G)
        end
	end

	local spineOpen = GetElement(self.m_root, "spineFight" .. self.m_nCurMapId .. "_WndBeingImmortal", WZUISpine)
	if spineOpen then 
		if existSpine then 
			spineOpen:setVisible(true)
			spineOpen:play("wait1", false)
			spineOpen:enableSchedule("showShootReward", 0.5)
		else
			self:showShootReward()
		end
	end
end

--@brief 	显示开启奖励
function WndBeingImmortal:showShootReward()
	-- body
	local spineOpen = GetElement(self.m_root, "spineFight" .. self.m_nCurMapId .. "_WndBeingImmortal", WZUISpine)
	spineOpen:disableSchedule()
	spineOpen:setVisible(false)

	self:setOpenState(false)
	self:_afterCloseReward()
end

--@brief 	iphoneX适配
function WndBeingImmortal:_adaptIphoneX()
	if IsIphoneX() then
		GetElement(self.m_root, "imgTitle_WndBeingImmortal", WZUIImage):setRelativePosition(GlobalMethod:ccp(0.07,0.588996))
	end
end

--@brief 	显示等级、经验
function WndBeingImmortal:_showLvAndExp()
	local txtLevel = GetElement(self.m_root, "txtLevel_WndBeingImmortal", WZUILabelTTF)
	local txtLvTitle = GetElement(self.m_root, "txtLvTitle_WndBeingImmortal", WZUILabelTTF)
	local txtExp = GetElement(self.m_root, "txtExp_WndBeingImmortal", WZUILabelTTF)
	local prgExp = GetElement(self.m_root, "prgExp_WndBeingImmortal", WZUIProgress)

	local tCurInfo, tNextInfo, nMaxLv = self:getCurLvInfo()
	local strLvTitle = LocalStrings.BEINGIMMORTAL_TEXT1[31]
	if tCurInfo then 
		strLvTitle = tCurInfo.name 
	end
	txtLevel:setText(LocalStrings.LV .. self.m_nCurLevel)
	txtLvTitle:setText(strLvTitle)
	if tCurInfo and tCurInfo.lv > nMaxLv then 
		txtExp:setText("Max")
	else
		txtExp:setText(self.m_nCurExp .. "/" .. tCurInfo.exp)
	end

	local nPercentage = math.floor(100 * self.m_nCurExp/tCurInfo.exp)
	if nPercentage > 100 then 
		nPercentage = 100
	end
	prgExp:setPercentage(nPercentage)
end

--@brief 	设置免费丢
function WndBeingImmortal:_setFreeBtnText()
	local txtBtnOpenFive = GetElement(self.m_root, "txtBtnOpenFive_WndBeingImmortal", WZUILabelTTF)

	local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local nTimes = nLightNum >= self.m_nMaxLotteryCount and self.m_nMaxLotteryCount or nLightNum > 1 and nLightNum or self.m_nMaxLotteryCount 

	txtBtnOpenFive:setText(string.format(LocalStrings.BEINGIMMORTAL_TEXT1[5], nTimes))
end

--@brief 	创建捕鼠奖励
function WndBeingImmortal:_createLvRewardList()
	local tbLvRewardList = GetElement(self.m_root, "tbLvRewardList_WndBeingImmortal", WZUITableContainer)
	tbLvRewardList:cleanTable()
	self.m_tLvCell = {}

	for i = 1, #self.m_tLvRewardList do
		local element, tNewObj = CellLvRewardItem:createElement()
		if element and tNewObj then
			element:setTag(i - 1)
			tNewObj:setData(self.m_tLvRewardList[i], 2)

			tbLvRewardList:setCellElement(element)
			table.insert(self.m_tLvCell, tNewObj)
		end
	end
end

--@brief 	设置待机特效
function WndBeingImmortal:_setBallAni()
	local spinePath = "activity/hd_pic_xiuxian"
	local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".json")
	if existSpine then 
		for i = 1, 5 do
			local spineMap = GetElement(self.m_root, "spineMap" .. i .. "_WndBeingImmortal", WZUISpine)
			if spineMap then 
				spineMap:setFileJson(spinePath .. ".json")
				spineMap:setFileAtlas(spinePath .. ".atlas")
				self:_setBowlingPlayAni(i, true)
			end
		end
	else
		local _sIndex = "hd_pic_xiuxian"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7061, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndBeingImmortal)
        end
	end

	local spinePath2 = "activity/ui_xiuxian_zhandou"
	local existSpine = WZDataFile:getInstance():checkFileExist(spinePath2 .. ".json")
	if existSpine then 
		for i = 1, 5 do
			local spineFight = GetElement(self.m_root, "spineFight" .. i .. "_WndBeingImmortal", WZUISpine)
			if spineFight then 
				spineFight:setFileJson(spinePath2 .. ".json")
				spineFight:setFileAtlas(spinePath2 .. ".atlas")
			end
		end
	else
		local _sIndex = "ui_xiuxian_zhandou"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7061, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndBeingImmortal)
        end
	end
end

function WndBeingImmortal:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndBeingImmortal:downloadEffectCallback",taskId,extraData,failed)
    self:_setBallAni()
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndBeingImmortal:_setBowlingPlayAni(aniIndex, bLoop)
	local spineMap = GetElement(self.m_root, "spineMap" .. aniIndex .. "_WndBeingImmortal", WZUISpine)
	aniIndex = aniIndex or 1
	WZLog("WndBeingImmortal:_setBowlingPlayAni", aniIndex, bLoop)
	if spineMap then 
		spineMap:play(self.m_tBallAniName[aniIndex], bLoop ~= nil and bLoop or true)
	end
end

--@brief 	显示地图
function WndBeingImmortal:_showMap()
	WZLog("_showMap_showMap", self.m_nCurMapId)
	local tCurInfo, tNextInfo, nMaxLv = self:getCurLvInfo()
	for i = 1, 5 do
		local spineMap = GetElement(self.m_root, "spineMap" .. i .. "_WndBeingImmortal", WZUISpine)

		if self.m_nCurLevel >= nMaxLv and self.m_nCurExp >= tCurInfo.exp then 
			spineMap:setGrayRender(false)
		else
			if i < self.m_nCurMapId then 
				spineMap:setGrayRender(false)
			else
				spineMap:setGrayRender(true)
			end
		end
	end
end

--@brief 	射箭任务奖励
function WndBeingImmortal:_onGetTaskResult(activityId, id)
--	WZLog("WndBeingImmortal:_onGetTaskResult", self.m_nActivityId, activityId, id)
	if self.m_nActivityId ~= activityId then
		MsgBoxManager:showTipBox(LocalStrings.RETURNEE_TEXT28)
		return
	end
	
	local taskData = GDatatab_new_activity_task["id_" .. id]
	if taskData and taskData.group_by == 4 then
		self:setTeskGetResult(id)
	end
end

function WndBeingImmortal:setTeskGetResult(id)
	if self.m_tLvCell then
		for i,v in pairs(self.m_tLvRewardList) do
			if v and v.id == id then
				self.m_tLvRewardList[i].status = 2	
				self.m_tLvCell[i]:updateStatue(self.m_tLvRewardList[i].status)
				break
			end
		end
	end
end
-------------------------------------私有方法模块End----------------------------------------



function WndBeingImmortal:_adaptLanguage_vn()
	local txtLevel = GetElement(self.m_root, "txtLevel_WndBeingImmortal", WZUILabelTTF)
	txtLevel:setFontSize(18)
	local txtLvTitle = GetElement(self.m_root, "txtLvTitle_WndBeingImmortal", WZUILabelTTF)
	txtLvTitle:setFontSize(18)

	GetElement(self.m_root, "imgTitle_WndBeingImmortal", WZUIImage):setRelativePosition(GlobalMethod:ccp(0.099,0.589))

	GetElement(self.m_root, "btnBigReward_WndBeingImmortal", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.36,0.19))
	GetElement(self.m_root, "btnTip_WndBeingImmortal", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.75,0.17))

	local txtBtnTask1 = GetElement(self.m_root, "txtBtnTask1_WndBeingImmortal", WZUILabelTTF)
	txtBtnTask1:setScale(0.7)
	txtBtnTask1:setDimensions(GlobalMethod:CCSize(120,0))
	local txtBtnTask2 = GetElement(self.m_root, "txtBtnTask2_WndBeingImmortal", WZUILabelTTF)
	txtBtnTask2:setScale(0.7)
	txtBtnTask2:setDimensions(GlobalMethod:CCSize(120,0))
	local txtBtnTask3 = GetElement(self.m_root, "txtBtnTask3_WndBeingImmortal", WZUILabelTTF)
	txtBtnTask3:setScale(0.7)
	txtBtnTask3:setDimensions(GlobalMethod:CCSize(120,0))
end
