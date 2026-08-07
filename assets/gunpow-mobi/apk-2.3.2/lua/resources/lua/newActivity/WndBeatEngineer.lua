--WndBeatEngineer.lua
--@brief	WndBeatEngineer的UI模块
--@date		2021/12/09
--@author	XTX
--@note		暴揍策划活动主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndBeatEngineer:onEnter(element)
	self.m_root = element
	g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
	ProtocolProcessorFestivalActivity:regAll6()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)

	self:_adaptIphoneX()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndBeatEngineer:onExit(element)
	g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
	ProtocolProcessorFestivalActivity:regAll6()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)

	self:_unInit()
	LoadNewActivityRes(false)
end

--@brief    onenter函数已执行
function WndBeatEngineer:onEnterTransitionDidFinish(element)
    WZLog("WndBeatEngineer:onEnterTransitionDidFinish")
	self:_initStaticText()
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7034, 7034)
    self:showRedDot()
end

--@brief    关闭窗口
function WndBeatEngineer:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    --如果是自动弹出的活动界面
   WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮回调
function WndBeatEngineer:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 
    WndSingleMapDesc:showInterface1(LocalStrings.BEATENGINEER_TEXT2) 
end

--@brief 	点击目标按钮回调
function WndBeatEngineer:onClickTask(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if nTag == 1 then 
		CellNewYearTask:showInterface(7, self.m_nActivityId)
	elseif nTag == 3 then 
		WndShopRank:showInterface(17, self.m_nActivityId) 
	end
end

--@brief 	点击大奖预览按钮回调
function WndBeatEngineer:onClickBigReward(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local otherData = {}
	otherData.winType = 1
	WndJoinReward:showInterface("", self.m_tBigRewardList[1], self.m_tBigRewardList[2], LocalStrings.TREASURE_TEXT7, nil, 2, otherData)
end

--@brief 	点击开启按钮回调
function WndBeatEngineer:onClickFive(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	--背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
    WZLog("WndBeatEngineer:onClickFive", self.m_bOpenState)
    if self.m_bOpenState then return end 

    local nToolType = self.m_nodeCbgTool:getCheckIndex()
    local costData = self.m_tPrice[nToolType + 1][nTag]
    local tData = {}
	tData.times = costData[1]
	tData.optType = nToolType
	tData.moneyType = costData[2]

	self.m_sBeatConfigJson = json.encode(tData)

	if not JudgeMoneyIsEnough(costData[2], costData[3], nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.goToBeat) then 
		return 
	end

	self:goToBeat()
end

--@brief 	确认暴打购买
function WndBeatEngineer:goToBeat()
	self:setOpenState(true)
	WZLog("WndBeatEngineer:goToBeat", self.m_sBeatConfigJson)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 1, self.m_sBeatConfigJson)
end

--@brief 	点击赛事礼包按钮回调
function WndBeatEngineer:onClickGift(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_nGiftRewardNum >= 1 then
		--背包已满提示
	    if CacheCenter:getRemainAmount() <= 0 then
	        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
	        return
	    end
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, "")
	else
		local tData = {}
		tData.txtTitle = LocalStrings.BEATENGINEER_TEXT1[12]
		tData.nType = 2
		WndTips:show(element, self.m_root, 52, tData, GlobalMethod:ccp(120,80), true)
	end
end

--@brief 	点击切换道具回调
function WndBeatEngineer:onChooseTool(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local nTag = element:getTag()
	local tData = {}
	tData.txtTitle = LocalStrings.BEATENGINEER_TEXT1[14 + nTag]
	tData.nType = 2
	WndTips:show(element, self.m_root, 52, tData, GlobalMethod:ccp(250,80), true)

	self:updateToolType()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndBeatEngineer:_update()
	-- body
	if self.m_root == nil then return end 
	
	self:_initActivityTime()
	self:updateToolType()
	self:showBagGiftInfo()
end

--@brief 	初始化静态文本
function WndBeatEngineer:_initStaticText()
	GetElement(self.m_root, "txtBtnOpenOne_WndBeatEngineer", WZUILabelTTF):setText(string.format(LocalStrings.BEATENGINEER_TEXT1[2], 1))
	GetElement(self.m_root, "txtBtnOpenFive_WndBeatEngineer", WZUILabelTTF):setText(string.format(LocalStrings.BEATENGINEER_TEXT1[2], 10))
	GetElement(self.m_root, "txtBtnTask1_WndBeatEngineer", WZUILabelTTF):setText(LocalStrings.BEATENGINEER_TEXT1[4])
	GetElement(self.m_root, "txtBtnTask3_WndBeatEngineer", WZUILabelTTF):setText(LocalStrings.BEATENGINEER_TEXT1[5])
	GetElement(self.m_root, "txtYearBigReward_WndBeatEngineer", WZUILabelTTF):setText(LocalStrings.BEATENGINEER_TEXT1[11])
	GetElement(self.m_root, "txtBigReward_WndBeatEngineer", WZUILabelTTF):setText(LocalStrings.BEATENGINEER_TEXT1[3])
	GetElement(self.m_root, "txtThink_WndBeatEngineer", WZUILabelTTF):setText(LocalStrings.BEATENGINEER_TEXT1[21])

	self.m_nodeCbgTool = GetElement(self.m_root, "cbgTool_WndBeatEngineer", WZUICheckBoxGroup)
	self:setWaitAni()
end

--@brief 	红点
function WndBeatEngineer:showRedDot()
	-- body
	if self.m_root == nil then return end 

	local imgTaskRedDot = GetElement(self.m_root, "imgTaskRedDot_WndBeatEngineer", WZUIImage)

	if GlobalGame.g_tRedPointTypeList[117034] or GlobalGame.g_tRedPointTypeList[127034] then 
		imgTaskRedDot:setVisible(true)
	else
		imgTaskRedDot:setVisible(false)
	end
end

--@brief 	初始化活动时间
function WndBeatEngineer:_initActivityTime()
	-- body
	if self.m_root == nil then return end 
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndBeatEngineer", WZUILabelTTF)
    if txtActivityTime then 
    	txtActivityTime:setText(LocalStrings.ACTIVITY_TIME_KEY .. ":" .. needDay_str)
    end
end

--@brief 	刷新赛事礼包的信息
function WndBeatEngineer:showBagGiftInfo()
	-- body
	if self.m_root == nil then return end 
	if self.m_nGiftRewardNum > 0 then 
		GetElement(self.m_root, "spineGift_WndBeatEngineer", WZUISpine):setVisible(true)
		GetElement(self.m_root, "imgGiftRed_WndBeatEngineer", WZUIImage):setVisible(true)
		GetElement(self.m_root, "txtGiftNum_WndBeatEngineer", WZUILabelTTF):setText(self.m_nGiftRewardNum)
	else
		GetElement(self.m_root, "spineGift_WndBeatEngineer", WZUISpine):setVisible(false)
		GetElement(self.m_root, "imgGiftRed_WndBeatEngineer", WZUIImage):setVisible(false)
	end
end

--@brief 	显示开启动画
function WndBeatEngineer:showOpenAction()
	-- body
	local conOpenAct = GetElement(self.m_root, "conOpenAct_WndBeatEngineer", WZUIContainer)
	conOpenAct:setVisible(true)
	local spineBow = GetElement(self.m_root, "spineOpen_WndBeatEngineer", WZUISpine)
	if spineBow then 
		local spinePath = "activity/ui_activity_bzch"
		local existSpine = CheckEffectFile(spinePath)
		if existSpine then 
			local nToolType = self.m_nodeCbgTool:getCheckIndex()
			local nActIndex = 1
			if nToolType == 0 then 
				nActIndex = 2
			end
			spineBow:setFileAtlas(spinePath .. ".atlas")
			spineBow:setFileJson(spinePath .. ".json")
			spineBow:play("hit" .. nActIndex, false)
		else
			local _sIndex = "ui_activity_bzch"
	        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
	        if downloadInfo then 
	        	DownloadManager:addDownloadTask(14211,downloadInfo.url,downloadInfo.md5,_sIndex,"DownloadResourceCallback", _G)
	        end
		end
		conOpenAct:enableSchedule("showShootReward", 1.5)
	end
end

--@brief 	显示开启奖励
function WndBeatEngineer:showShootReward()
	-- body
	local conOpenAct = GetElement(self.m_root, "conOpenAct_WndBeatEngineer", WZUIContainer)
	conOpenAct:disableSchedule()

	local spineBow = GetElement(self.m_root, "spineOpen_WndBeatEngineer", WZUISpine)
	spineBow:play("wait", true)
	self:setOpenState(false)
	if self.m_tOpenResult.itemIds and #self.m_tOpenResult.itemIds > 0 then 
		WndRewardShow:showById(self.m_tOpenResult.itemIds, self.m_tOpenResult.itemNums)
		WndRewardShow:closeCallBack(self, self._afterCloseReward)
	else
		self:_afterCloseReward()
	end
--	MsgBoxManager:showTipBox(string.format(LocalStrings.WATERCOUNTRY_TEXT5[4], #self.m_tOpenResult.bzms))
end

--@brief 	更新道具类型
function WndBeatEngineer:updateToolType()
	if self.m_root == nil then return end 

	if self.m_nodeCbgTool == nil then 
		self.m_nodeCbgTool = GetElement(self.m_root, "cbgTool_WndBeatEngineer", WZUICheckBoxGroup)
	end
	local nToolType = self.m_nodeCbgTool:getCheckIndex()

	local basicData1 = GDatatab_item["id_" .. self.m_tPrice[nToolType + 1][1][4]]
	local txtGiveGold1 = GetElement(self.m_root, "txtGiveGold1_WndBeatEngineer", WZUILabelTTF)
	txtGiveGold1:setText(string.format(LocalStrings.BEATENGINEER_TEXT1[14], self.m_tPrice[nToolType + 1][1][5], basicData1.name))
	local txtGiveGold2 = GetElement(self.m_root, "txtGiveGold2_WndBeatEngineer", WZUILabelTTF)
	local basicData2 = GDatatab_item["id_" .. self.m_tPrice[nToolType + 1][2][4]]
	txtGiveGold2:setText(string.format(LocalStrings.BEATENGINEER_TEXT1[14], self.m_tPrice[nToolType + 1][2][5], basicData2.name))

	local txtCostValue1 = GetElement(self.m_root, "txtCostValue1_WndBeatEngineer", WZUILabelTTF)
	txtCostValue1:setText(self.m_tPrice[nToolType + 1][1][3])
	local txtCostValue2 = GetElement(self.m_root, "txtCostValue2_WndBeatEngineer", WZUILabelTTF)
	txtCostValue2:setText(self.m_tPrice[nToolType + 1][2][3])
	local imgCostIcon1 = GetElement(self.m_root, "imgCostIcon1_WndBeatEngineer", WZUIImage)
	local basicInfo1 = GDatatab_item["id_" .. self.m_tPrice[nToolType + 1][1][2]]
	imgCostIcon1:setFile(basicInfo1.icon)
	local imgCostIcon2 = GetElement(self.m_root, "imgCostIcon2_WndBeatEngineer", WZUIImage)
	local basicInfo2 = GDatatab_item["id_" .. self.m_tPrice[nToolType + 1][2][2]]
	imgCostIcon2:setFile(basicInfo2.icon)

	local ftxtGiveCount1 = GetElement(self.m_root, "ftxtGiveCount1_WndBeatEngineer", WZUIFreeTextBox)
	ftxtGiveCount1:setShowText(string.format(LocalStrings.BEATENGINEER_TEXT3, self.m_tPrice[nToolType + 1][1][1]))
	local ftxtGiveCount2 = GetElement(self.m_root, "ftxtGiveCount2_WndBeatEngineer", WZUIFreeTextBox)
	ftxtGiveCount2:setShowText(string.format(LocalStrings.BEATENGINEER_TEXT3, self.m_tPrice[nToolType + 1][2][1]))
end

--@brief 	iphoneX适配
function WndBeatEngineer:_adaptIphoneX()
	if IsIphoneX() then
		GetElement(self.m_root, "conBottom_WndBeatEngineer", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5, 0.53))
		GetElement(self.m_root, "btnTarget_WndBeatEngineer", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.935,0.553))
	end
end

--@brief 	 设置待机动画
function WndBeatEngineer:setWaitAni()
	local spineBow = GetElement(self.m_root, "spineOpen_WndBeatEngineer", WZUISpine)
	if spineBow then 
		local spinePath = "activity/ui_activity_bzch"
		local existSpine = CheckEffectFile(spinePath)
		if existSpine then 
			spineBow:setFileAtlas(spinePath .. ".atlas")
			spineBow:setFileJson(spinePath .. ".json")
			spineBow:play("wait", true)
		else
			local _sIndex = "ui_activity_bzch"
	        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
	        if downloadInfo then 
	        	DownloadManager:addDownloadTask(14211,downloadInfo.url,downloadInfo.md5,_sIndex,"downloadSpineCallback", self)
	        end
		end
	end
end

function WndBeatEngineer:downloadSpineCallback(taskId,extraData,failed)
    WZLog("WndBeatEngineer:downloadSpineCallback",taskId,extraData,failed)
    self:setWaitAni()
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配begin----------------------------------------

function WndBeatEngineer:_adaptLanguage_vn()
	GetElement(self.m_root,"txtThink_WndBeatEngineer",WZUILabelTTF):setFontSize(16)
	GetElement(self.m_root,"txtActivityTime_WndBeatEngineer",WZUILabelTTF):setFontSize(16)
	GetElement(self.m_root,"txtBigReward_WndBeatEngineer",WZUILabelTTF):setFontSize(12)
	GetElement(self.m_root,"txtBtnOpenOne_WndBeatEngineer",WZUILabelTTF):setFontSize(14)
	GetElement(self.m_root,"txtBtnOpenFive_WndBeatEngineer",WZUILabelTTF):setFontSize(14)
end

-------------------------------------语言适配End----------------------------------------