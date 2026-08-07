--WndPickTea.lua
--@brief	WndPickTea的UI模块
--@date		2023/12/28
--@author	XTX
--@note		一起来采茶活动主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPickTea:onEnter(element)
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
function WndPickTea:onExit(element)
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
function WndPickTea:onEnterTransitionDidFinish(element)
    WZLog("WndPickTea:onEnterTransitionDidFinish")
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7108, 7108)
end

--@brief    关闭窗口
function WndPickTea:onCloseClick(element)
	local eleType = type(element)
	if eleType ~= "number" then 
    	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    end

	SaveActivityPoleType("PICKTEA", self.m_nCalabashType)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮回调
function WndPickTea:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 	
    WndSingleMapDesc:showInterface(LocalStrings.PICKTEA_TEXT2)
end

--@brief 	点击目标按钮回调
function WndPickTea:onClickTask(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if SystemTime:getServerTime() >= self.m_nEndTime then 
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END) 
		self:onCloseClick(0)
		return 
	end 

	local nTag = element:getTag()
	if nTag == 1 then 
		local otherData = {}
		otherData.taskCount = 2 --几个任务标签
		otherData.tTaskTypeName = {LocalStrings.PICKTEA_TEXT1[10], LocalStrings.PICKTEA_TEXT1[11]} --任务标签名字
		otherData.taskTitle = LocalStrings.PICKTEA_TEXT1[2]
		otherData.taskType = 2
		otherData.redPoint = {117108, 127108} --长线；日常；每天
		CellNewYearTask:showInterface(60, self.m_nActivityId, otherData)
	elseif nTag == 2 then
		local otherData = {}
		otherData.doType = 7
		otherData.paramType = 1  --传数组
		otherData.img9Bg = "ui/common/frame_lieb.png"
		otherData.img9TitleBg =  "ui/common/title_frame_02.png"
		WndHouseInvite:showInterface(12, self.m_nActivityId, nil, otherData)
	elseif nTag == 3 then 
		local otherData = {}
		otherData.type = 1
		otherData.strRankTitleName = LocalStrings.PICKTEA_TEXT1[3]
		otherData.strCountLabel = string.format(LocalStrings.NEWYEAR_TEXT15,100)
		otherData.strChangeTitle = LocalStrings.PICKTEA_TEXT1[18]
		otherData.strScoreTitle = LocalStrings.PICKTEA_TEXT1[18] .. ":"

		WndShopRank:showInterface(90, self.m_nActivityId, nil, nil, otherData) 
	elseif nTag == 4 then --全民采茶
		self:onClickGift(element)
	end
end

--@brief 	点击大奖预览按钮回调
function WndPickTea:onClickBigReward(element)
	-- body	
	if SystemTime:getServerTime() >= self.m_nEndTime then 
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END) 
		self:onCloseClick(0)
		return 
	end 
	local eleType = type(element)
	if eleType ~= "number" then 
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	end

	self.m_tGetTimes = {}
	self.m_tBigRewardList = {}
	self.m_bIsOpenReward = true 
	local tData = {pool = 0}
	local tData2 = {pool = 1}
	local tData3 = {pool = 2}
	
	local strJson = json.encode(tData)
	local strJson2 = json.encode(tData2)
	local strJson3 = json.encode(tData3)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson2)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson3)
end


--@brief 	点击开启按钮回调
function WndPickTea:onClickFive(element) 
	if SystemTime:getServerTime() >= self.m_nEndTime then 
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END) 
		self:onCloseClick(0)
		return 
	end 
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	--背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
    if self.m_bOpenState then MsgBoxManager:showTipBox(LocalStrings.PICKTEA_TEXT1[19]) return end 
    if self.m_nChooseReward == 0 then 
    	self:onClickBigReward(0)

		self.m_nChooseReward = 1
		SaveOperateTimes("PICKTEAACTIVITYID", self.m_nActivityId)
    	return 
    end

    self.m_nAniType = 1
	local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local nTempTimes = math.floor(nArrowNum/self.m_tCostByType[self.m_nCalabashType + 1])
	local nTimes = nTag
	local freeCount = 0
	if self.m_nCalabashType == 0 then 
		freeCount = self.m_nCount > 0 and 1 or 0 
	end

	local useTimes = nTimes 
	if nTag == 5 then 
		self.m_nAniType = 2
		nTag = self.m_nMaxLotteryCount 
		nTimes = (nTempTimes + freeCount) >= self.m_nMaxLotteryCount and self.m_nMaxLotteryCount or nTempTimes > 0 and (nTempTimes + freeCount) or self.m_nMaxLotteryCount 
		
		useTimes = nTimes 
	end
	local nCostNum = useTimes * self.m_tCostByType[self.m_nCalabashType + 1]
	if nCostNum - freeCount > nArrowNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		MsgBoxManager:showConfirmBox(string.format(LocalStrings.WATERCOUNTRY_TEXT4, basicData.name), self, self.goToBuy)
		return 
	end

    local tData = {}
	tData.times = useTimes
	tData.pool = self.m_nCalabashType

	local stringData = json.encode(tData)

	self:setOpenState(true)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 3, stringData)
end

--@brief 	前往小推车购买
function WndPickTea:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

--@brief 	点击切换浪板类型
function WndPickTea:onChooseTool(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local nTag = element:getTag()
	if self.m_bOpenState then 
		GetElement(self.m_root, "cbgTool_WndPickTea", WZUICheckBoxGroup):setCheckIndex(self.m_nCalabashType)
		return 
	end 
	if self.m_nCalabashType == nTag then return end 

	self.m_nCalabashType = nTag
	self:_setFreeBtnText()
	self:_setBowlingPlayAni(1, true)
end

--@brief	点击物品弹出对应的tips
function WndPickTea:onItemClick(tCell,tag,tData)
    if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData,false)
end

--@brief 	点击等级奖励按钮回调、
function WndPickTea:onClickLvReward(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	GetElement(self.m_root, "conLvReward_WndPickTea", WZUIContainer):setVisible(true)
	self:_createLvRewardList()
end

--@brief 	关闭捕鼠奖励界面
function WndPickTea:onCloseTip(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	GetElement(self.m_root, "conLvReward_WndPickTea", WZUIContainer):setVisible(false)
	self:showRedDot()
end

--@brief 	点击全民采茶按钮回调
function WndPickTea:onClickGift(element)
	-- body
	if self.m_nGiftRewardNum >= 1 then
		--背包已满提示
	    if CacheCenter:getRemainAmount() <= 0 then
	        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
	        return
	    end
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 5, "")
	else
		local tData = {}
		tData.txtTitle = string.format(LocalStrings.PICKTEA_TEXT1[9], self.m_nGiftRewardConfig)
		tData.nType = 2
		WndTips:show(element, self.m_root, 52, tData, GlobalMethod:ccp(200,80), true)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndPickTea:_update()
	-- body
	self:_setFreeBtnText()
	self:showRedDot()
	self:_initActivityTime()
    self:_updateLightNum()
    self:showBagGiftInfo()
end

--@brief 	初始化静态文本
function WndPickTea:_initStaticText()
	self.m_nCalabashType = GetActivityPoleType("PICKTEA")
	if self.m_nCalabashType ~= 0 then 
		GetElement(self.m_root, "cbgTool_WndPickTea", WZUICheckBoxGroup):setCheckIndex(self.m_nCalabashType)
	end

	GetElement(self.m_root, "txtBtnTask1_WndPickTea", WZUILabelTTF):setText(LocalStrings.PICKTEA_TEXT1[2])
	GetElement(self.m_root, "txtBtnTask2_WndPickTea", WZUILabelTTF):setText(LocalStrings.PICKTEA_TEXT1[8])
	GetElement(self.m_root, "txtBtnTask3_WndPickTea", WZUILabelTTF):setText(LocalStrings.PICKTEA_TEXT1[3])
	GetElement(self.m_root, "txtBtnTask4_WndPickTea", WZUILabelTTF):setText(LocalStrings.PICKTEA_TEXT1[22])
	GetElement(self.m_root, "txtBigReward_WndPickTea", WZUILabelTTF):setText(LocalStrings.WATERMELON_TEXT1[22])
	GetElement(self.m_root, "txtLvRewardT_WndPickTea", WZUILabelTTF):setText(LocalStrings.PICKTEA_TEXT1[15])
	GetElement(self.m_root, "txtActivityWord_WndPickTea", WZUILabelTTF):setText(LocalStrings.ACTIVE_TIME .. ":")

	self:_setBallAni()
end

--@brief 	红点
function WndPickTea:showRedDot()
	-- body
	if self.m_root == nil then return end 

	local imgTaskRedDot = GetElement(self.m_root, "imgTaskRedDot_WndPickTea", WZUIImage)
	local imgExpReddot = GetElement(self.m_root, "imgExpReddot_WndPickTea", WZUIImage)
	local imgLibraryRedDot = GetElement(self.m_root, "imgLibraryRedDot_WndPickTea", WZUIImage)

	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[117108] or GlobalGame.g_tRedPointTypeList[127108]) then 
		imgTaskRedDot:setVisible(true)
	else
		imgTaskRedDot:setVisible(false)
	end

	local bHaveRedDot = false 
	if self.m_tLvRewardList then 
		for i = 1, #self.m_tLvRewardList do
			if self.m_tLvRewardList[i].status == 1 then 
				bHaveRedDot = true 
				break 
			end
		end
	end

	imgExpReddot:setVisible(bHaveRedDot)
	--图鉴红点
	bHaveRedDot = false 
	if self.m_tLibraryData then 
		for i = 1, #self.m_tLibraryData do
			if self.m_tLibraryData[i].status == 1 then 
				bHaveRedDot = true 
				break 
			end
		end
	end

	imgLibraryRedDot:setVisible(bHaveRedDot)
end

--@brief 	更新异火的数量
function WndPickTea:_updateLightNum()
	-- body
	local ftxtLightNum = GetElement(self.m_root, "ftxtLightNum_WndPickTea", WZUIFreeTextBox)
	local sFormat = [[<I Z="0.45" P="1">%s</I><T C="255,255,255" S="18" P="1" SC="163,74,20" SS="4" SE="1">%d</T>]]
	if ftxtLightNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
		ftxtLightNum:setShowText(string.format(sFormat, basicData.icon, nLightNum))
	end
end

--@brief 	初始化活动时间
function WndPickTea:_initActivityTime()
	-- body
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndPickTea", WZUILabelTTF)
    if txtActivityTime then 
    	txtActivityTime:setText(needDay_str)
    end
end

--@brief 	显示开启动画
function WndPickTea:showOpenAction()
	-- body
	local spineOpen = GetElement(self.m_root, "spineOpen_WndPickTea", WZUISpine)
	local spinePath = "activity/hd_pic_caicha"
	local existSpine = CheckEffectFile(spinePath)
	
	if spineOpen then 
		if existSpine then 
			self:_setBowlingPlayAni(2, false)
			spineOpen:enableSchedule("afterAni", 1.8)
		else
			self:showShootReward()
			self:setOpenState(false)
		end
	end
end

--@brief 	显示开启奖励
function WndPickTea:showShootReward()
	-- body
	local strContent = ""
	local nIndex = 0 
	if self.m_tOpenResult.otherRewards and #self.m_tOpenResult.otherRewards > 0 then 
		for i = 1, #self.m_tOpenResult.otherRewards do
			if i == 1 then 
				strContent = strContent .. LocalStrings.CRAZY_DOUBLING_TEXT8 .. " "
			else
				strContent = strContent .. ", "
			end
			local basicData = GDatatab_item["id_" .. self.m_tOpenResult.otherRewards[i][1]]
			strContent = strContent .. basicData.name .. "*" .. self.m_tOpenResult.otherRewards[i][2]
		end
		nIndex = nIndex + 1
	end
	if self.m_tOpenResult.addExp and self.m_tOpenResult.addExp > 0 then 
		if nIndex > 0 then 
			strContent = strContent .. " "
		end
		strContent = strContent .. LocalStrings.PICKTEA_TEXT1[18] .. "+" .. self.m_tOpenResult.addExp
	end

	if strContent ~= "" then 
		MsgBoxManager:showTipBox(strContent, nil, nil, nil, nil, nil, nil, nil, nil, GlobalMethod:ccp(0.5, 0.77))
	end

	self:_afterCloseReward()
end

--@brief 	iphoneX适配
function WndPickTea:_adaptIphoneX()
	if IsIphoneX() then
		GetElement(self.m_root, "btnShop_WndPickTea", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.08,0.42))
		GetElement(self.m_root, "conLeftMenu_WndPickTea", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.97,0))
	end
end

--@brief 	设置免费丢
function WndPickTea:_setFreeBtnText()
	local txtBtnOpenOne = GetElement(self.m_root, "txtBtnOpenOne_WndPickTea", WZUILabelTTF)
	local txtBtnOpenFive = GetElement(self.m_root, "txtBtnOpenFive_WndPickTea", WZUILabelTTF)

	local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local freeTimes = 0 
	local nTempTimes = math.floor(nLightNum/self.m_tCostByType[self.m_nCalabashType + 1])
	local nTimes = 0
	local strTemp = LocalStrings.PICKTEA_TEXT1[7]
	local nMileToTimes = self.m_nMaxLotteryCount

	if self.m_nCalabashType == 0 then 
		if self.m_nCount > 0 then 
			freeTimes = 1
			txtBtnOpenOne:setText(LocalStrings.PICKTEA_TEXT1[6])
		else 
			txtBtnOpenOne:setText(string.format(strTemp, 1))
		end
	else
		txtBtnOpenOne:setText(string.format(strTemp, 1))
	end

	nTimes = (nTempTimes + freeTimes) >= self.m_nMaxLotteryCount and self.m_nMaxLotteryCount or nTempTimes > 0 and (nTempTimes + freeTimes) or self.m_nMaxLotteryCount 

	txtBtnOpenFive:setText(string.format(strTemp, nTimes))
end

--@brief 	设置待机特效
function WndPickTea:_setBallAni()
	local spinePath = "activity/hd_pic_caicha"
	local existSpine = CheckEffectFile(spinePath)
	
	if existSpine then 
		local spineOpen = GetElement(self.m_root, "spineOpen_WndPickTea", WZUISpine)
		if spineOpen then 
			spineOpen:setFileJson(spinePath .. ".json")
			spineOpen:setFileAtlas(spinePath .. ".atlas")
			self:_setBowlingPlayAni(1, true)
		end
		local spineWait2 = GetElement(self.m_root, "spineWait2_WndPickTea", WZUISpine)
		if spineWait2 then 
			spineWait2:setFileJson(spinePath .. ".json")
			spineWait2:setFileAtlas(spinePath .. ".atlas")
			spineWait2:play("wait1_1", true)
		end
	end
end

function WndPickTea:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndPickTea:downloadEffectCallback",taskId,extraData,failed)
    self:_setBallAni()
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndPickTea:_setBowlingPlayAni(aniIndex, bLoop)
	local spineOpen = GetElement(self.m_root, "spineOpen_WndPickTea", WZUISpine)
	aniIndex = aniIndex or 1
	WZLog("WndPickTea:_setBowlingPlayAni", aniIndex, bLoop)

	if spineOpen then
		spineOpen:setVisible(true) 
		spineOpen:play(self.m_tBallAniName[self.m_nCalabashType + 1][aniIndex], bLoop ~= nil and bLoop or true)
	end
end

--@brief 	鱼移出屏幕后，删除动画
function WndPickTea:afterAni(element)
	local spineOpen = GetElement(self.m_root, "spineOpen_WndPickTea", WZUISpine)
	spineOpen:disableSchedule()
	self:_setBowlingPlayAni(1, true)

	self:showShootReward()
	self:setOpenState(false)
end

--@brief 	播放露营动画后
function WndPickTea:waitHide(element)
	local spineWait3 = GetElement(self.m_root, "spineWait3_WndPickTea", WZUISpine)
	spineWait3:disableSchedule()
	spineWait3:setVisible(false)
end

--@brief 	显示等级、经验
function WndPickTea:_showLvAndExp()
	local txtLevel = GetElement(self.m_root, "txtLevel_WndPickTea", WZUILabelTTF)
	local txtLvTitle = GetElement(self.m_root, "txtLvTitle_WndPickTea", WZUILabelTTF)
	local txtExp = GetElement(self.m_root, "txtExp_WndPickTea", WZUILabelTTF)
	local prgExp = GetElement(self.m_root, "prgExp_WndPickTea", WZUIProgress)

	local tCurInfo, tNextInfo, nMaxLv = self:getCurLvInfo()
	local strLvTitle = LocalStrings.PICKTEA_TEXT1[17][1]
	local nCurLevel = 0 
	if tCurInfo then 
		nCurLevel = tCurInfo.lv
		strLvTitle = tCurInfo.name 
	end
	txtLevel:setText(LocalStrings.LV .. nCurLevel)
	txtLvTitle:setText(strLvTitle)
	if tCurInfo and tCurInfo.lv >= nMaxLv then 
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
function WndPickTea:_createLvRewardList()
	local tbLvRewardList = GetElement(self.m_root, "tbLvRewardList_WndPickTea", WZUITableContainer)
	tbLvRewardList:cleanTable()

	local otherData = {}
	otherData.opType = 6
	otherData.strExp = LocalStrings.PICKTEA_TEXT1[18]
	otherData.exp = self.m_nCurExp
	otherData.tipsRoot = self.m_root
	otherData.rewardType = 2 --奖励类型：1={{id,num},{id,num},...};2={{id,id,num},{id,id,num},...};0="[id,id,num]&[id,id,num]&..."

	for i = 1, #self.m_tLvRewardList do
		local element, tNewObj = CellLvRewardItem:createElement()
		if element and tNewObj then
			element:setTag(i - 1)
			tNewObj:setData(self.m_tLvRewardList[i], 10, otherData)

			tbLvRewardList:setCellElement(element)
		end
	end
end

--@brief 	刷新赛事礼包的信息
function WndPickTea:showBagGiftInfo()
	-- body
	if self.m_nGiftRewardNum > 0 then 
		GetElement(self.m_root, "imgGiftRed_WndPickTea", WZUIImage):setVisible(true)
		GetElement(self.m_root, "txtGiftNum_WndPickTea", WZUILabelTTF):setText(self.m_nGiftRewardNum)
	else
		GetElement(self.m_root, "imgGiftRed_WndPickTea", WZUIImage):setVisible(false)
	end
end


-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配模块Begin----------------------------------------

function WndPickTea:_adaptLanguage_vn()
	GetElement(self.m_root, "txtBtnOpenOne_WndPickTea", WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root, "txtBtnOpenFive_WndPickTea", WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root, "txtLevel_WndPickTea", WZUILabelTTF):setScale(0.55)
	GetElement(self.m_root, "txtBtnTask1_WndPickTea", WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root, "txtActivityWord_WndPickTea", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.18,0.5))
end

-------------------------------------语言适配模块End----------------------------------------

