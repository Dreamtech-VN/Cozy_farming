--WndZooSightseeing.lua
--@brief	WndZooSightseeing的UI模块
--@date		2024/11/15
--@author	yrd
--@note		动物园观光


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndZooSightseeing:onEnter(element)
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

    local checkSkip = GetElement(self.m_root,"checkSkip",WZUICheckBox)
	local data = WZDataFile:getInstance():getUserData()
    if data then
        local nCheckIndex = data:getStringValue("WndZooSightseeing", "checkSkip") == "1" and 1 or 0
        self.m_nCheckIndex = nCheckIndex
        checkSkip:setCheckIndex(nCheckIndex)
    end

	GetElement(self.m_root,"conDrawWheel",WZUIContainer):setVisible(false)
	self:showBlessBtnTxt()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndZooSightseeing:onExit(element)
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
function WndZooSightseeing:onEnterTransitionDidFinish(element)
    WZLog("WndZooSightseeing:onEnterTransitionDidFinish")
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7147, 7147)
end

--@brief    关闭窗口
function WndZooSightseeing:onCloseClick(element)
	local eleType = type(element)
	if eleType ~= "number" then 
    	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    end

	SaveActivityPoleType("TOOLTYPE_7147", self.m_nCalabashType)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮回调
function WndZooSightseeing:onRuleClick(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface(LocalStrings.ZOO_SIGHTSEEING_TEXT2)
end

--@brief 	点击目标按钮回调
function WndZooSightseeing:onClickTask(element)
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
		otherData.tTaskTypeName = {LocalStrings.ZOO_SIGHTSEEING_TEXT1[10], LocalStrings.ZOO_SIGHTSEEING_TEXT1[11]} --任务标签名字
		otherData.titleList = otherData.tTaskTypeName
		otherData.taskType = 2
		otherData.redPoint = {117147, 127147} --长线；日常；每天
		CellNewYearTask:showInterface(60, self.m_nActivityId, otherData)
	elseif nTag == 2 then
		local otherData = {}
		otherData.title = LocalStrings.ZOO_SIGHTSEEING_TEXT1[8]
		otherData.doType_get = 6
		otherData.doType_buy = 7
		otherData.showBuyReward = true 
		otherData.coinId = self.m_nCoinId2
		otherData.chipPt = GlobalMethod:ccp(0.034,0.95) 
		WndDollMachineShop:showInterface(90, self.m_nActivityId, otherData)
	elseif nTag == 3 then 
		local otherData = {}
		otherData.type = 1
		otherData.strRankTitleName = LocalStrings.ZOO_SIGHTSEEING_TEXT1[3]
		otherData.strChangeTitle = LocalStrings.ZOO_SIGHTSEEING_TEXT1[18]
		otherData.strScoreTitle = LocalStrings.ZOO_SIGHTSEEING_TEXT1[19] .. ":"
		WndShopRank:showInterface(90, self.m_nActivityId, nil, nil, otherData) 
	elseif nTag == 4 then --全民
	elseif nTag == 5 then
		GetElement(self.m_root,"conDrawWheel",WZUIContainer):setVisible(true)
	end
end

--@brief 	点击大奖预览按钮回调
function WndZooSightseeing:onClickBigReward(element)	
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
function WndZooSightseeing:onClickFive(element) 
	if SystemTime:getServerTime() >= self.m_nEndTime then 
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END) 
		self:onCloseClick(0)
		return 
	end 
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if nTag == 5 then 
		if self.m_nAniType == 2 then 
			self.m_nAniType = 1
		else
			self.m_nAniType = 2
		end
		local btnFile = {"ui/newvip/common_btn_41_1.png", "ui/newvip/common_btn_42_1.png"}
		local btnWordsStrokeColor = {GlobalMethod:ccc3(163,74,20), GlobalMethod:ccc3(0,108,3)}
		local imgOpenBtn = GetElement(self.m_root, "imgOpenOneBtn_WndZooSightseeing", WZUIImage)
		local txtBtnOpenOne = GetElement(self.m_root, "txtBtnOpenOne_WndZooSightseeing", WZUILabelTTF)
		imgOpenBtn:setFile(btnFile[self.m_nAniType])
		txtBtnOpenOne:setStrokeColor(btnWordsStrokeColor[self.m_nAniType])
		self:_setFreeBtnText()
		return 
	end
	--背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
    if self.m_bOpenState then return end 
    if self.m_nChooseReward == 0 then 
    	self:onClickBigReward(0)

		self.m_nChooseReward = 1
		SaveOperateTimes("OPERATETIMES_7147", self.m_nActivityId)
    	return 
    end

	local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local nTempTimes = math.floor(nArrowNum/self.m_tCostByType[self.m_nCalabashType + 1])
	local nTimes = nTag
	local freeCount = 0
	if self.m_nCalabashType == 0 then 
		freeCount = self.m_nCount > 0 and 1 or 0 
	end

	local useTimes = nTimes 
	if self.m_nAniType == 2 then 
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
function WndZooSightseeing:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        -- WndActivityPropsGift:showInterface(self.m_nCoinId)
        WndApartmentAct:showInterface()
    end
end

--@brief 	点击切换浪板类型
function WndZooSightseeing:onChooseTool(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local nIndex = GetElement(self.m_root, "cbgTool_WndZooSightseeing", WZUICheckBoxGroup):getCheckIndex()
	if self.m_nCalabashType == nIndex then
		return
	end

	self.m_nCalabashType = nIndex
	self:_setFreeBtnText()
	self:_playAni(1, true)
	self:_playAnotherAni(0)
	self:_playBgSpine()
end

--@brief	点击物品弹出对应的tips
function WndZooSightseeing:onItemClick(tCell,tag,tData)
    if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData,false)
end

--@brief 	点击等级奖励按钮回调、
function WndZooSightseeing:onClickLvReward(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	GetElement(self.m_root, "conLvReward_WndZooSightseeing", WZUIContainer):setVisible(true)
	self:_createLvRewardList()
end

--@brief 	关闭捕鼠奖励界面
function WndZooSightseeing:onCloseTip(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	GetElement(self.m_root, "conLvReward_WndZooSightseeing", WZUIContainer):setVisible(false)
	self:showRedDot()
end


-- 转盘
--@brief 	关闭转轮界面
function WndZooSightseeing:onCloseClick2()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	GetElement(self.m_root,"conDrawWheel",WZUIContainer):setVisible(false)
end

--@brief 	展示转盘物品
function WndZooSightseeing:_showWheelItems()
	-- 奖品
	local tItem = self.m_tGiftRewards
	local conWheelItem1 = GetElement(self.m_root,"conWheelItem1",WZUIContainer)
	conWheelItem1:removeAllChildrenWithCleanup(true)
	--奖品
	for i=0,#tItem+2 do
		local idx = (i+#tItem-1)%#tItem+1
		local element, tNewObj = CellGoodItem:createElement()
		element:setTag(i - 1)
		element:setRelativePosition(GlobalMethod:ccp(0.5, 0.5+(i-1)))
		tNewObj:setCellGoodLocalId(tItem[idx][1], tItem[idx][2], 17)
		tNewObj:setItemClickFun(self, self.onItemClick)
		conWheelItem1:addChild(element)
	end
	--分割线
	for i=0,#tItem+1 do
		local imgDividingLine = WZUIImage:create()
		imgDividingLine:setFile("ui/newActivity/common_sdqf_d_03.png")
		imgDividingLine:setUseOriginSize(true)
		imgDividingLine:setRelativePosition(GlobalMethod:ccp(0.5, i))
		conWheelItem1:addChild(imgDividingLine)
	end

	-- 倍率
	local tRatio = self.m_tGiftMultipleConfig
	local conWheelItem2 = GetElement(self.m_root,"conWheelItem2",WZUIContainer)
	conWheelItem2:removeAllChildrenWithCleanup(true)
	--奖品
	local strFormat = [[<A IMG = "ui/common_num/sdqf_0-9.png" Z="1" W="60" H="72" CHAR="0">%d</A><I Z="1">ui/newActivity/common_sz_sdqf_b.png</I>]]
	for i=0,#tRatio+2 do
		local idx = (i+#tRatio-1)%#tRatio+1
		local ftbRatio = WZUIFreeTextBox:create()
		ftbRatio:setMaxWidth(1000)
		ftbRatio:setRelativePosition(GlobalMethod:ccp(0.5, 0.5+(i-1)))
		ftbRatio:setShowText(string.format(strFormat, tRatio[idx]))
		conWheelItem2:addChild(ftbRatio)
	end
	--分割线
	for i=0,#tRatio+1 do
		local imgDividingLine = WZUIImage:create()
		imgDividingLine:setFile("ui/newActivity/common_sdqf_d_03.png")
		imgDividingLine:setUseOriginSize(true)
		imgDividingLine:setRelativePosition(GlobalMethod:ccp(0.5, i-1))
		conWheelItem2:addChild(imgDividingLine)
	end
end

--@brief 	点击确定按钮回调
function WndZooSightseeing:onClickStartWheel(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_bIsBlessing ~= true then
		local cost = {self.m_nCoinId2, self.m_tCostByType[3]}
		if not JudgeMoneyIsEnough(cost[1], cost[2], nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureToUseDiaInstead) then 
			return 
		end
		self:sureToUseDiaInstead()

		self.m_bIsBlessing = true
		self:showBlessBtnTxt()
	else
		local conDrawWheel = GetElement(self.m_root,"conDrawWheel",WZUIContainer)
		conDrawWheel:disableSchedule()
		self:_passRoll()
	end

end

--@brief 	确定使用蓝钻代替进行摇一摇
function WndZooSightseeing:sureToUseDiaInstead()
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 8, "")
end


--@breif 开始滚动相关数值
function WndZooSightseeing:_startRoll()
	WZLog("WndZooSightseeing:_startRoll")
	local conDrawWheel = GetElement(self.m_root,"conDrawWheel",WZUIContainer)

	if self.m_nCheckIndex == 1 then
		self:_passRoll()
	else
		self.n_speed = {0.4,0.2} --初始速度
		self.t_bActionOver = {0,0} --转盘动画结束
		conDrawWheel:enableSchedule("_starRollSchedule")
	end
end

--@breif 跳过动画直接滚动
function WndZooSightseeing:_passRoll()
	local tEndPosIdx = {self.m_tBlessId, self.m_nBlessMultiple} --最终抽到的物品或倍率下标

	for i=1,#tEndPosIdx do
		local conWheelItem = GetElement(self.m_root,"conWheelItem"..i,WZUIContainer)
		local curPos = conWheelItem:getRelativePosition()
		local endPosY = 0.5 - 1 * (tEndPosIdx[i] - 1)
		conWheelItem:setRelativePosition(GlobalMethod:ccp(curPos.x, endPosY))
	end

	WndRewardShow:showById(self.m_tBlessItemIds, self.m_tBlessItemNums)

	self.m_bIsBlessing = false
	self:showBlessBtnTxt()
end

--@brief 开始滚动
function WndZooSightseeing:_starRollSchedule()
	local tItem = self.m_tGiftRewards
	local tRatio = self.m_tGiftMultipleConfig

	local conDrawWheel = GetElement(self.m_root,"conDrawWheel",WZUIContainer)

	local nMinSpeed1 = 0.1 --第一段减速时最小速度
	local nDeclineSpeed1 = 0.005 --第一段减速时速度每帧减小
	local nMinSpeed2 = 0.005 --第二段减速时最小速度
	local nDeclineSpeed2 = 0.001 --第二段减速时速度每帧减小

	local tEndPosIdx = {self.m_tBlessId, self.m_nBlessMultiple} --最终抽到的物品或倍率下标
	local tRewardList = {self.m_tGiftRewards, self.m_tGiftMultipleConfig}

	for i=1,#tEndPosIdx do
		local conWheelItem = GetElement(self.m_root,"conWheelItem"..i,WZUIContainer)
		local curPos = conWheelItem:getRelativePosition()

		local tData
		if i == 1 then
			tData = tItem
		elseif i == 2 then
			tData = tRatio
		end
		local endPosY = 0.5 - 1 * (tEndPosIdx[i] - 1)

		local nPrevNum = math.min(#tRewardList[i], 5) --提前5个开始减慢速度
		local nPrevPosIdx = ((tEndPosIdx[i] - 1) + #tRewardList[i] - nPrevNum) % #tRewardList[i] + 1
		local nPrevPosY = 0.5 - 1 * (nPrevPosIdx - 1)
		if (i == 1 or i ~= 1 and self.t_bActionOver[i-1] == 1) and ( --第二个转盘要等第一个转盘先结束
			(self.n_speed[i] < nMinSpeed1 and self.n_speed[i] > nMinSpeed2) or
			(self.n_speed[i] == nMinSpeed1 and curPos.y - self.n_speed[i] <= nPrevPosY and curPos.y >= nPrevPosY)
		) then
			self.n_speed[i] = math.max(self.n_speed[i] - nDeclineSpeed2, nMinSpeed2)
		elseif (i == 1 or i ~= 1 and self.t_bActionOver[i-1] == 1) and self.n_speed[i] > nMinSpeed1 then
			self.n_speed[i] = math.max(self.n_speed[i] - nDeclineSpeed1, nMinSpeed1)
		end

		if (i == 1 or i ~= 1 and self.t_bActionOver[i-1] == 1) and self.n_speed[i] == nMinSpeed2 and curPos.y - self.n_speed[i] <= endPosY and curPos.y >= endPosY then
			conWheelItem:setRelativePosition(GlobalMethod:ccp(curPos.x, endPosY))
			self.t_bActionOver[i] = 1
		else
			local posY = curPos.y - self.n_speed[i]
			if posY <= 0.5 - 1 * #tData then
				posY = 0.5
			end
			conWheelItem:setRelativePosition(GlobalMethod:ccp(curPos.x, posY))
		end
	end

	local bEndAni = true
	for i=1, #self.t_bActionOver do
		if self.t_bActionOver[i] ~= 1 then
			bEndAni = false
			break
		end
	end
	if bEndAni then
		conDrawWheel:disableSchedule()

		WndRewardShow:showById(self.m_tBlessItemIds, self.m_tBlessItemNums)
	
		self.m_bIsBlessing = false
		self:showBlessBtnTxt()
	end
end

--@brief    勾选跳过动画按钮回调
function WndZooSightseeing:showBlessBtnTxt()
	local txtBlessNum = GetElement(self.m_root,"txtBlessNum",WZUILabelTTF)
	if self.m_nCheckIndex == 1 or self.m_bIsBlessing ~= true then
		txtBlessNum:setText(LocalStrings.ZOO_SIGHTSEEING_TEXT1[24])
	else
		txtBlessNum:setText(LocalStrings.ZOO_SIGHTSEEING_TEXT1[25])
	end
end

--@brief    勾选跳过动画按钮回调
function WndZooSightseeing:onClickSkip(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local checkSkip = GetElement(self.m_root,"checkSkip",WZUICheckBox)
    self.m_nCheckIndex = checkSkip:getCheckIndex()
    local data = WZDataFile:getInstance():getUserData()
    if data then
        data:setStringValue("WndZooSightseeing", "checkSkip", tostring(self.m_nCheckIndex))
        data:flush()
    end
end


--@brief 	点击道具回调
function WndZooSightseeing:onItemClick(tCell,tag,tData)
    if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tCell.m_root,self.m_root, 1, tData)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndZooSightseeing:_update()
	self:_setFreeBtnText()
	self:showRedDot()
	self:_initActivityTime()
    self:_updateLightNum()
end

--@brief 	初始化静态文本
function WndZooSightseeing:_initStaticText()
	self.m_nCalabashType = GetActivityPoleType("TOOLTYPE_7147")
	if self.m_nCalabashType ~= 0 then 
		GetElement(self.m_root, "cbgTool_WndZooSightseeing", WZUICheckBoxGroup):setCheckIndex(self.m_nCalabashType)
	end

	GetElement(self.m_root, "txtBtnTask1_WndZooSightseeing", WZUILabelTTF):setText(LocalStrings.ZOO_SIGHTSEEING_TEXT1[2])
	GetElement(self.m_root, "txtBtnTask2_WndZooSightseeing", WZUILabelTTF):setText(LocalStrings.ZOO_SIGHTSEEING_TEXT1[8])
	GetElement(self.m_root, "txtBtnTask3_WndZooSightseeing", WZUILabelTTF):setText(LocalStrings.ZOO_SIGHTSEEING_TEXT1[3])
	GetElement(self.m_root, "txtBtnTask4_WndZooSightseeing", WZUILabelTTF):setText(LocalStrings.ZOO_SIGHTSEEING_TEXT1[22])
	GetElement(self.m_root, "txtBtnTask5_WndZooSightseeing", WZUILabelTTF):setText(LocalStrings.ZOO_SIGHTSEEING_TEXT1[5])
	-- GetElement(self.m_root, "txtBigReward_WndZooSightseeing", WZUILabelTTF):setText(LocalStrings.WATERMELON_TEXT1[22])
	GetElement(self.m_root, "txtLvRewardT_WndZooSightseeing", WZUILabelTTF):setText(LocalStrings.ZOO_SIGHTSEEING_TEXT1[15])

	self:_setBallAni()
	self:_playBgSpine()
end

--@brief 	红点
function WndZooSightseeing:showRedDot()
	if self.m_root == nil then return end 

	local imgTaskRedDot = GetElement(self.m_root, "imgTaskRedDot_WndZooSightseeing", WZUIImage)
	local imgExpReddot = GetElement(self.m_root, "imgExpReddot_WndZooSightseeing", WZUIImage)

	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[117147] or GlobalGame.g_tRedPointTypeList[127147]) then 
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
end

--@brief 	更新异火的数量
function WndZooSightseeing:_updateLightNum()
	local ftxtLightNum = GetElement(self.m_root, "ftxtLightNum_WndZooSightseeing", WZUIFreeTextBox)
	local sFormat = [[<I Z="0.45" P="1">%s</I><T C="255,255,255" S="18" P="1" SC="163,74,20" SS="4" SE="1">%d</T>]]
	if ftxtLightNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
		ftxtLightNum:setShowText(string.format(sFormat, basicData.icon, nLightNum))
	end

	local ftbWheelCost = GetElement(self.m_root, "ftbWheelCost", WZUIFreeTextBox)
	local sFormat = [[<I Z="0.4" P="1">%s</I><T C="255,255,255" S="18" P="1" SC="163,74,20" SS="4" SE="1">%s</T>]]
	if ftbWheelCost then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId2]
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId2)
		ftbWheelCost:setShowText(string.format(sFormat, basicData.icon, nLightNum))
	end
end

--@brief 	初始化活动时间
function WndZooSightseeing:_initActivityTime()
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndZooSightseeing", WZUILabelTTF)
    if txtActivityTime then 
    	txtActivityTime:setText(LocalStrings.ACTIVE_TIME .. ":".. needDay_str)
    end
end

--@brief 	显示开启动画
function WndZooSightseeing:showOpenAction()
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	local spinePath1 = "activity/hd_pic_dwuygg"
	local existSpine1 = CheckEffectFile(spinePath1)
	if spineOpen then 
		if existSpine1 then
			local aniIndex = self.m_nAniType + 1 
			self:_playAnotherAni(aniIndex, false)
			-- local nSeconds = 2
			-- spineOpen:enableSchedule("showShootReward", nSeconds)
			spineOpen:enableSchedule("showShootBefore", 0)
		else
			self:showShootReward()
		end
	end
end

--@brief 	显示开启奖励 处理抽奖时人物人物会闪一下问题
function WndZooSightseeing:showShootBefore()
	self:_playAni(0)
	local nSeconds = 2
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	spineOpen:disableSchedule()
	spineOpen:enableSchedule("showShootReward", nSeconds)
end

--@brief 	显示开启奖励
function WndZooSightseeing:showShootReward()
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	spineOpen:disableSchedule()
	self:_playAni(1, true)
	self:_playAnotherAni(0)

	local strContent = ""
	if self.m_tOpenResult.addScore and self.m_tOpenResult.addScore > 0 then 
		strContent = strContent .. LocalStrings.ZOO_SIGHTSEEING_TEXT1[23] .. "+" .. self.m_tOpenResult.addScore .. "    "
	end
	if self.m_tOpenResult.addShopNum and self.m_tOpenResult.addShopNum > 0 then 
		strContent = strContent .. LocalStrings.ZOO_SIGHTSEEING_TEXT1[22] .. "+" .. self.m_tOpenResult.addShopNum .. "    "
	end
	if strContent ~= "" then 
		MsgBoxManager:showTipBox(strContent, nil, nil, nil, nil, nil, nil, nil, nil, GlobalMethod:ccp(0.5, 0.77))
	end

	self:setOpenState(false)
	self:_afterCloseReward()
end

--@brief 	设置免费丢
function WndZooSightseeing:_setFreeBtnText()
	local txtBtnOpenOne = GetElement(self.m_root, "txtBtnOpenOne_WndZooSightseeing", WZUILabelTTF)

	local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local freeTimes = 0 
	local nTempTimes = math.floor(nLightNum/self.m_tCostByType[self.m_nCalabashType + 1])
	local nTimes = 0
	local strTemp = LocalStrings.ZOO_SIGHTSEEING_TEXT1[7]
	local nMileToTimes = self.m_nMaxLotteryCount

	if self.m_nAniType == 1 then 
		if self.m_nCalabashType == 0 then 
			if self.m_nCount > 0 then 
				freeTimes = 1
				txtBtnOpenOne:setText(LocalStrings.ZOO_SIGHTSEEING_TEXT1[6])
			else 
				txtBtnOpenOne:setText(string.format(strTemp, 1))
			end
		else
			txtBtnOpenOne:setText(string.format(strTemp, 1))
		end
	else
		nTimes = (nTempTimes + freeTimes) >= self.m_nMaxLotteryCount and self.m_nMaxLotteryCount or nTempTimes > 0 and (nTempTimes + freeTimes) or self.m_nMaxLotteryCount 

		txtBtnOpenOne:setText(string.format(strTemp, nTimes))
	end
end

--@brief 	设置待机特效
function WndZooSightseeing:_setBallAni()
	local spinePath = "activity/hd_pic_dwuygg"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then
		local spineBG = GetElement(self.m_root, "spineBG", WZUISpine)
		if spineBG then 
			spineBG:setFileJson(spinePath .. ".json")
			spineBG:setFileAtlas(spinePath .. ".atlas")
		end

		local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
		if spineOpen then
			spineOpen:setFileJson(spinePath .. ".json") 
			spineOpen:setFileAtlas(spinePath .. ".atlas")
			self:_playAni(1, true)
		end
		local spineCopy = GetElement(self.m_root, "spineCopy", WZUISpine)
		if spineCopy then
			spineCopy:setFileJson(spinePath .. ".json") 
			spineCopy:setFileAtlas(spinePath .. ".atlas")
			self:_playAnotherAni(0)
		end
	else
		local _sIndex = "hd_pic_dwuygg"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7147, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndZooSightseeing)
        end
	end

	local spinePath = "activity/hd_pic_choujiang"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then
		local spineBG2 = GetElement(self.m_root, "spineBG2", WZUISpine)
		if spineBG2 then 
			spineBG2:setFileJson(spinePath .. ".json")
			spineBG2:setFileAtlas(spinePath .. ".atlas")
			spineBG2:play("wait", true)
		end
	else
		local _sIndex = "hd_pic_choujiang"
		local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
		if downloadInfo then 
			DownloadManager:addDownloadTask(71470, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndZooSightseeing)
		end
	end
end

function WndZooSightseeing:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndZooSightseeing:downloadEffectCallback",taskId,extraData,failed)
    self:_setBallAni()
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndZooSightseeing:_playAni(aniIndex, bLoop)
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	aniIndex = aniIndex or 0
	if aniIndex == 0 then
		spineOpen:setVisible(false)
		return
	end
	spineOpen:setVisible(true)
	bLoop = bLoop == true and true or false

	if spineOpen then 
		spineOpen:play(self.m_tBallAniName[self.m_nCalabashType + 1][aniIndex], bLoop)
	end
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndZooSightseeing:_playAnotherAni(aniIndex, bLoop)
	local spineCopy = GetElement(self.m_root, "spineCopy", WZUISpine)
	aniIndex = aniIndex or 0
	if aniIndex == 0 then
		spineCopy:setVisible(false)
		return
	end
	spineCopy:setVisible(true)
	bLoop = bLoop == true and true or false

	if spineCopy then 
		spineCopy:play(self.m_tBallAniName[self.m_nCalabashType + 1][aniIndex], bLoop)
	end
end

--@brief 	设置播放的保龄球的动画
function WndZooSightseeing:_playBgSpine()
	local spineBG = GetElement(self.m_root, "spineBG", WZUISpine)
	local spinePath = "activity/hd_pic_dwuygg"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then
		if self.m_nCalabashType == 0 then
			spineBG:play("wait1", true)
		elseif self.m_nCalabashType == 1 then
			spineBG:play("wait2", true)
		end
	end
end

--@brief 	显示等级、经验
function WndZooSightseeing:_showLvAndExp()
	local txtLevel = GetElement(self.m_root, "txtLevel_WndZooSightseeing", WZUILabelTTF)
	local txtLvTitle = GetElement(self.m_root, "txtLvTitle_WndZooSightseeing", WZUILabelTTF)
	local txtExp = GetElement(self.m_root, "txtExp_WndZooSightseeing", WZUILabelTTF)
	local prgExp = GetElement(self.m_root, "prgExp_WndZooSightseeing", WZUIProgress)

	local tCurInfo, tNextInfo, nMaxLv = self:getCurLvInfo()
	local strLvTitle = LocalStrings.ZOO_SIGHTSEEING_TEXT1[17][1]
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
function WndZooSightseeing:_createLvRewardList()
	local tbLvRewardList = GetElement(self.m_root, "tbLvRewardList_WndZooSightseeing", WZUITableContainer)
	tbLvRewardList:cleanTable()

	local otherData = {}
	otherData.opType = 5
	otherData.strExp = LocalStrings.ZOO_SIGHTSEEING_TEXT1[23]
	otherData.exp = self.m_nCurExp
	otherData.tipsRoot = self.m_root
	otherData.rewardType = 0 --奖励类型：1={{id,num},{id,num},...};2={{id,id,num},{id,id,num},...};0="[id,id,num]&[id,id,num]&..."

	for i = 1, #self.m_tLvRewardList do
		local element, tNewObj = CellLvRewardItem:createElement()
		if element and tNewObj then
			element:setTag(i - 1)
			tNewObj:setData(self.m_tLvRewardList[i], 10, otherData)

			tbLvRewardList:setCellElement(element)
		end
	end
end

-------------------------------------私有方法模块End----------------------------------------


--@brief 	iphoneX适配
function WndZooSightseeing:_adaptIphoneX()
	if IsIphoneX() then
		GetElement(self.m_root,"btnOperate2",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.066,0.09))
		GetElement(self.m_root,"btnOperate5",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.066,0.27))
	end
end


--@brief	语言适配
function WndZooSightseeing:_adaptLanguage_vn()
	local txtLvTitle = GetElement(self.m_root, "txtLvTitle_WndZooSightseeing", WZUILabelTTF)
	txtLvTitle:setScale(0.6)
	txtLvTitle:setDimensions(GlobalMethod:CCSize(140,0))

	local txtBtnTask1 = GetElement(self.m_root, "txtBtnTask1_WndZooSightseeing", WZUILabelTTF)
	txtBtnTask1:setScale(0.7)
	txtBtnTask1:setDimensions(GlobalMethod:CCSize(100,0))
	local txtBtnTask2 = GetElement(self.m_root, "txtBtnTask2_WndZooSightseeing", WZUILabelTTF)
	txtBtnTask2:setScale(0.7)
	txtBtnTask2:setDimensions(GlobalMethod:CCSize(100,0))
	local txtBtnTask3 = GetElement(self.m_root, "txtBtnTask3_WndZooSightseeing", WZUILabelTTF)
	txtBtnTask3:setScale(0.7)
	txtBtnTask3:setDimensions(GlobalMethod:CCSize(100,0))
	local txtBtnTask4 = GetElement(self.m_root, "txtBtnTask4_WndZooSightseeing", WZUILabelTTF)
	txtBtnTask4:setScale(0.7)
	txtBtnTask4:setDimensions(GlobalMethod:CCSize(100,0))
	local txtBtnTask5 = GetElement(self.m_root, "txtBtnTask5_WndZooSightseeing", WZUILabelTTF)
	txtBtnTask5:setScale(0.7)
	txtBtnTask5:setDimensions(GlobalMethod:CCSize(100,0))

	GetElement(self.m_root, "txtBtnOpenOne_WndZooSightseeing", WZUILabelTTF):setScale(0.6)
end