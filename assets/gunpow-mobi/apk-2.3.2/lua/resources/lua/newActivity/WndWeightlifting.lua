--WndWeightlifting.lua
--@brief	WndWeightlifting的UI模块
--@date		2023/11/08
--@author	yrd
--@note		举重比赛


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndWeightlifting:onEnter(element)
	self.m_root = element

	g_bIsShowWndDressUp = false
	g_tTempItemForLaterShow = {}
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
	ProtocolProcessorFestivalActivity:regAll6()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
	GlobalGame:getGameEventDispathcer():Add(Independent_Activity.ActivityReddot, self.showRedDot, self)

	self:_initStaticText()
	self:_updateCoinNum()

	self:_adaptIphoneX()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndWeightlifting:onExit(element)
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
function WndWeightlifting:onEnterTransitionDidFinish(element)
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7102, 7102)
end

--@brief    点击关闭窗口按钮
function WndWeightlifting:showInterface()
	LoadNewActivityRes(true)
	local wnd = WndWeightlifting:createElement()
	WindowManager:addWindow(wnd, WndWeightlifting, false)
end

--@brief    点击关闭窗口按钮
function WndWeightlifting:onClickClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	self:saveToolType()
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮
function WndWeightlifting:onClickRule(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local otherInfo = {imgBg="ui/common/frame_tc_xiao_lan.png", imgClose = "ui/newvip/common_top_btn_guanbi_lan.png"}
 	WndFourStarRuleDesc:showInterface(LocalStrings.WEIGHTLIFTING_TEXT2, nil, otherInfo)
end

--@brief    初始化静态文本
function WndWeightlifting:_initStaticText()
	self:getToolType()
	self:_showAnimal()

	GetElement(self.m_root,"txtChoosePrize",WZUILabelTTF):setText(LocalStrings.WATERMELON_TEXT1[22])

	GetElement(self.m_root,"txtTypeName",WZUILabelTTF):setText(LocalStrings.WEIGHTLIFTING_TEXT1[4])
	GetElement(self.m_root,"txtOperateBtn1",WZUILabelTTF):setText(LocalStrings.WEIGHTLIFTING_TEXT1[5])
	GetElement(self.m_root,"txtOperateBtn2",WZUILabelTTF):setText(LocalStrings.WEIGHTLIFTING_TEXT1[6])
	GetElement(self.m_root,"txtOperateBtn3",WZUILabelTTF):setText(LocalStrings.WEIGHTLIFTING_TEXT1[7])
	GetElement(self.m_root,"cbTool1_1",WZUILabelTTF):setText(LocalStrings.WEIGHTLIFTING_TEXT1[16])
	GetElement(self.m_root,"cbTool1_2",WZUILabelTTF):setText(LocalStrings.WEIGHTLIFTING_TEXT1[16])
	GetElement(self.m_root,"cbTool2_1",WZUILabelTTF):setText(LocalStrings.WEIGHTLIFTING_TEXT1[17])
	GetElement(self.m_root,"cbTool2_2",WZUILabelTTF):setText(LocalStrings.WEIGHTLIFTING_TEXT1[17])
end

--@brief 	更新许愿币的数量
function WndWeightlifting:_updateCoinNum()
	local sFormat = [[<I Z="0.4" P="1">%s</I><T C="255,236,193" S="20" P="1" SC="163,74,20" SS="4" SE="0">%d</T>]]
	local basicData = GDatatab_item["id_" .. self.m_nCoinId]
	local nNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	GetElement(self.m_root, "ftbOwnCoin", WZUIFreeTextBox):setShowText(string.format(sFormat, basicData.icon, nNum))
end

--@brief 	初始化活动时间
function WndWeightlifting:_initActivityTime()
	local tStartDate = os.date("*t", self.m_nStartTime)
	local tEndDate = os.date("*t", self.m_nEndTime)
	local sDuration = string.format(LocalStrings.ACTIVITYTIME_FORMAT, tStartDate.month, tStartDate.day, tStartDate.hour, tStartDate.min, tEndDate.month, tEndDate.day, tEndDate.hour, tEndDate.min)
	GetElement(self.m_root, "txtActivityTime", WZUILabelTTF):setText(sDuration)
end

--@brief 	红点
function WndWeightlifting:showRedDot()
	if self.m_root == nil then return end 

	local imgBtnRedDot2 = GetElement(self.m_root, "imgBtnRedDot2", WZUIImage)
	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[217102] or GlobalGame.g_tRedPointTypeList[227102] or GlobalGame.g_tRedPointTypeList[237102]) then 
		imgBtnRedDot2:setVisible(true)
	else
		imgBtnRedDot2:setVisible(false)
	end
end

--@brief 	更新界面
function WndWeightlifting:updateUI()

end

--@brief 	点击选择瓶子按钮回调
function WndWeightlifting:onClickChooseTool(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nIndex = GetElement(self.m_root, "cbgTools", WZUICheckBoxGroup):getCheckIndex()
	if self.m_nDrawToolType == nIndex then
		return
	end

	self.m_nDrawToolType = nIndex
	self:updateDrawgBtn()
	self:_playAni(1, true)
	self:_playAnotherAni(0)
end


--@brief 	点击选择数量按钮回调
function WndWeightlifting:onClickSwitchNum(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	self.m_nDrawNumType = self.m_nDrawNumType % 2 + 1

	self:updateDrawgBtn()
end

--@brief 	更新许愿按钮
function WndWeightlifting:updateDrawgBtn()
	local txtUseTool = GetElement(self.m_root,"txtUseTool1",WZUILabelTTF)

	local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local nTempTimes = math.floor(nArrowNum/self.m_tCostByType[self.m_nDrawToolType + 1]) --可许愿次数
	local freeCount = 0 --免费次数
	if self.m_nDrawToolType == 0 then 
		freeCount = self.m_nCount > 0 and 1 or 0 
	end
	local nTimes = self.m_tDrawNumList[self.m_nDrawNumType]
	local nAllTimes = nTempTimes + freeCount --可许愿次数 + 免费次数
	if nAllTimes > 0 and nAllTimes < self.m_tDrawNumList[self.m_nDrawNumType] then
		nTimes = nAllTimes
	end
	if freeCount == 1 then
		if self.m_nDrawNumType == 1 then
			txtUseTool:setText(LocalStrings.WEIGHTLIFTING_TEXT1[2])
		elseif self.m_nDrawNumType == 2 then
			if nTempTimes == 0 then
				txtUseTool:setText(string.format(LocalStrings.WEIGHTLIFTING_TEXT1[3], self.m_tDrawNumList[self.m_nDrawNumType]))
			else
				txtUseTool:setText(string.format(LocalStrings.WEIGHTLIFTING_TEXT1[3], nTimes))
			end
		end
	else
		txtUseTool:setText(string.format(LocalStrings.WEIGHTLIFTING_TEXT1[3], nTimes))
	end

	local tempColorList = {GlobalMethod:ccc3(127,70,26), GlobalMethod:ccc3(255,255,255)}
	local tempStrokeList = {false, true}
	txtUseTool:setColor(tempColorList[self.m_nDrawNumType])
	txtUseTool:setEnableStroke(tempStrokeList[self.m_nDrawNumType])

	local imgUseTool1 = GetElement(self.m_root,"imgUseTool1",WZUIImage)
	local tempImgPathList = {"ui/newActivity/common_btn_xxts_02.png", "ui/newActivity/common_btn_xxts_01.png"}
	imgUseTool1:setFile(tempImgPathList[self.m_nDrawNumType])
end

--@brief 	设置待机特效
function WndWeightlifting:_showAnimal()
	local spinePath = "activity/hd_pic_jzss"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then
		-- local spineBG = GetElement(self.m_root, "spineBG", WZUISpine)
		-- if spineBG then 
		-- 	spineBG:setFileJson(spinePath .. ".json")
		-- 	spineBG:setFileAtlas(spinePath .. ".atlas")
		-- 	spineBG:play("wait", true)
		-- end

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
		local _sIndex = "hd_pic_jzss"
		local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
		if downloadInfo then 
			DownloadManager:addDownloadTask(7102, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndWeightlifting)
		end
	end

	local spinePath2 = "activity/ui_tq_lihe"
	local existSpine2 = CheckEffectFile(spinePath2)
	if existSpine2 then 
		for i = 1, 6 do
			local spineScoreBox = GetElement(self.m_root, "spineScoreBox" .. i, WZUISpine)
			if spineScoreBox then 
				spineScoreBox:setFileJson(spinePath2 .. ".json")
				spineScoreBox:setFileAtlas(spinePath2 .. ".atlas")
			end
		end
	else
		local _sIndex = "ui_tq_lihe"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(70921, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndFlyKites)
        end
	end
end

function WndWeightlifting:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndWeightlifting:downloadEffectCallback",taskId,extraData,failed)
    self:_showAnimal()
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndWeightlifting:_playAni(aniIndex, bLoop)
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	aniIndex = aniIndex or 0
	if aniIndex == 0 then
		spineOpen:setVisible(false)
		return
	end
	spineOpen:setVisible(true)
	bLoop = bLoop == true and true or false

	if spineOpen then 
		spineOpen:play(self.m_tClipAniName[self.m_nDrawToolType + 1][aniIndex], bLoop)
	end
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndWeightlifting:_playAnotherAni(aniIndex, bLoop)
	local spineCopy = GetElement(self.m_root, "spineCopy", WZUISpine)
	aniIndex = aniIndex or 0
	if aniIndex == 0 then
		spineCopy:setVisible(false)
		return
	end
	spineCopy:setVisible(true)
	bLoop = bLoop == true and true or false

	if spineCopy then 
		spineCopy:play(self.m_tClipAniName[self.m_nDrawToolType + 1][aniIndex], bLoop)
	end
end

--@brief 	显示开启动画
function WndWeightlifting:showOpenAction()
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	local spinePath1 = "activity/hd_pic_jzss"
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
function WndWeightlifting:showShootBefore()
	self:_playAni(0)
	local nSeconds = 2
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	spineOpen:disableSchedule()
	spineOpen:enableSchedule("showShootReward", nSeconds)
end

--@brief 	显示开启奖励
function WndWeightlifting:showShootReward()
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	spineOpen:disableSchedule()
	self:_playAni(1, true)
	self:_playAnotherAni(0)

	local strContent = ""
	if self.m_tOpenResult.addExp and self.m_tOpenResult.addExp > 0 then 
		strContent = strContent .. LocalStrings.WEIGHTLIFTING_TEXT1[4] .. "+" .. self.m_tOpenResult.addExp .. "    "
	end
	if self.m_tOpenResult.addCoin and self.m_tOpenResult.addCoin > 0 then 
		strContent = strContent .. LocalStrings.WEIGHTLIFTING_TEXT1[8] .. "+" .. self.m_tOpenResult.addCoin .. "    "
	end
	if strContent ~= "" then 
		MsgBoxManager:showTipBox(strContent, nil, nil, nil, nil, nil, nil, nil, nil, GlobalMethod:ccp(0.5, 0.77))
	end

	self:setOpenState(false)
	self:_afterCloseReward()
end



--@brief 	点击"自选奖励"按钮回调
function WndWeightlifting:onClickChoosePrize(element)
	local eleType = type(element)
	if eleType ~= "number" then 
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	end

	self.m_bIsOpenReward = true 

	self.m_tGetTimes = {}
	self.m_tBigRewardList = {}

	local tData1 = {pool = 0}
	local tData2 = {pool = 1}
	local tData3 = {pool = 2}
	local strJson1 = json.encode(tData1)
	local strJson2 = json.encode(tData2)
	local strJson3 = json.encode(tData3)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson1)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson2)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson3)
end

--@brief 	点击许愿按钮回调
function WndWeightlifting:onClickUseTool(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	--背包已满提示
	if CacheCenter:getRemainAmount() <= 0 then
		MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
		return
	end
	if self.m_bOpenState then return end 

	if self.m_nChooseReward == 0 then 
		self:onClickChoosePrize(0)

		self.m_nChooseReward = 1
		self:saveOperateTimes()
		return 
	end

	local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local nTempTimes = math.floor(nArrowNum/self.m_tCostByType[self.m_nDrawToolType + 1]) --可许愿次数
	local freeCount = 0 --免费次数
	if self.m_nDrawToolType == 0 then 
		freeCount = self.m_nCount > 0 and 1 or 0 
	end
	self.m_nAniType = self.m_nDrawNumType
	local nTimes = self.m_tDrawNumList[self.m_nDrawNumType]
	local nAllTimes = nTempTimes + freeCount --可许愿次数 + 免费次数
	if nAllTimes > 0 and nAllTimes < self.m_tDrawNumList[self.m_nDrawNumType] then
		nTimes = nAllTimes
	end

	local nCostNum = nTimes * self.m_tCostByType[self.m_nDrawToolType + 1]
	if nCostNum - freeCount > nArrowNum or self.m_nAniType == 2 and nArrowNum == 0 then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		MsgBoxManager:showConfirmBox(string.format(LocalStrings.WATERCOUNTRY_TEXT4, basicData.name), self, self.goToBuy)
		return 
	end

	self:setOpenState(true)

	local tData = {}
	tData.times = self.m_tDrawNumList[self.m_nDrawNumType]
	tData.pool = self.m_nDrawToolType
	local stringData = json.encode(tData)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 3, stringData)
end

--@brief 	前往小推车购买
function WndWeightlifting:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

--@brief 	点击按钮回调
function WndWeightlifting:onClickOperateBtn(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nTag = element:getTag()
	if nTag == 1 then
		WndDollMachineShop:showInterface(16, self.m_nActivityId)
	elseif nTag == 2 then
		CellNewYearTask:showInterface(49, self.m_nActivityId)
	elseif nTag == 3 then
		WndShopRank:showInterface(68, self.m_nActivityId)
	end
end

--@brief 	成熟度
function WndWeightlifting:_showProgress()
	local txtStepNum = GetElement(self.m_root, "txtStepNum", WZUILabelTTF)
	if txtStepNum then 
		txtStepNum:setText(self.m_nCurScore)
	end

	local prgExp = GetElement(self.m_root, "prgExp", WZUIProgress)
	local nCurNum = self.m_nCurScore
    if prgExp then
        if nCurNum <= self.m_tScoreConfig[1].scoreTarget then 
            prgExp:setPercentage(math.floor(nCurNum * 17/self.m_tScoreConfig[1].scoreTarget))
        elseif nCurNum <= self.m_tScoreConfig[2].scoreTarget then 
            local nTempNum = self.m_tScoreConfig[2].scoreTarget - self.m_tScoreConfig[1].scoreTarget
            prgExp:setPercentage(17 + math.floor((nCurNum - self.m_tScoreConfig[1].scoreTarget) * 17/nTempNum))
        elseif nCurNum <= self.m_tScoreConfig[3].scoreTarget then 
            local nTempNum = self.m_tScoreConfig[3].scoreTarget - self.m_tScoreConfig[2].scoreTarget
            prgExp:setPercentage(34 + math.floor((nCurNum - self.m_tScoreConfig[2].scoreTarget) * 17/nTempNum))
        elseif nCurNum <= self.m_tScoreConfig[4].scoreTarget then 
            local nTempNum = self.m_tScoreConfig[4].scoreTarget - self.m_tScoreConfig[3].scoreTarget
            prgExp:setPercentage(51 + math.floor((nCurNum - self.m_tScoreConfig[3].scoreTarget) * 17/nTempNum))
        elseif nCurNum <= self.m_tScoreConfig[5].scoreTarget then 
            local nTempNum = self.m_tScoreConfig[5].scoreTarget - self.m_tScoreConfig[4].scoreTarget
            prgExp:setPercentage(68 + math.floor((nCurNum - self.m_tScoreConfig[4].scoreTarget) * 17/nTempNum))
        elseif nCurNum <= self.m_tScoreConfig[6].scoreTarget then 
            local nTempNum = self.m_tScoreConfig[6].scoreTarget - self.m_tScoreConfig[5].scoreTarget
            prgExp:setPercentage(85 + math.floor((nCurNum - self.m_tScoreConfig[5].scoreTarget) * 17/nTempNum))
        else
            prgExp:setPercentage(100)
        end
    end

    --步数
    for i = 1, 6 do
	    if self.m_tScoreConfig[i].lastStatus == nil or self.m_tScoreConfig[i].lastStatus ~= self.m_tScoreConfig[i].status then
			if self.m_tScoreConfig[i].status == -1 then
				GetElement(self.m_root, "spineScoreBox" .. i, WZUISpine):play("wait" .. i, true)
				GetElement(self.m_root, "imgScoreYlq" .. i, WZUIImage):setVisible(false)
			elseif self.m_tScoreConfig[i].status == 0 then 
				GetElement(self.m_root, "spineScoreBox" .. i, WZUISpine):play("wait1_" .. i, true)
				GetElement(self.m_root, "imgScoreYlq" .. i, WZUIImage):setVisible(false)
			elseif self.m_tScoreConfig[i].status == 1 then
				GetElement(self.m_root, "spineScoreBox" .. i, WZUISpine):play("wait" .. i, true)
				GetElement(self.m_root, "imgScoreYlq" .. i, WZUIImage):setVisible(true)
			end

	    	self.m_tScoreConfig[i].lastStatus = self.m_tScoreConfig[i].status
	    end
    end
end

--@brief 	设置步数积分宝箱数量
function WndWeightlifting:_showStepScoreNum()
	for i = 1, 6 do
		local txtScore = GetElement(self.m_root, "txtScore"..i, WZUILabelTTF)
		txtScore:setText(self.m_tScoreConfig[i].scoreTarget)
	end
end

--@brief 	点击积分宝箱回调
function WndWeightlifting:onClickScoreBox(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if self.m_tScoreConfig[nTag].status == 0 then 
		--背包已满提示
	    if CacheCenter:getRemainAmount() <= 0 then
	        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
	        return
	    end
	    local tData = {}
	    tData.id = nTag - 1
	    local strData = json.encode(tData)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 5, strData)
	else
		local tData = self.m_tScoreConfig[nTag]
		local data = {}

        data.scale = 0.4
        local reward_id = {}
        local reward_num = {}
        for i = 1, #tData.reward do
            table.insert(reward_id,  tData.reward[i][1])
            table.insert(reward_num, tData.reward[i][2])
        end
        data.cur_value = self.m_nCurScore
        data.totle_value = tData.scoreTarget
        data.rewardIds = reward_id
        data.rewardNums = reward_num
        local conLeftScore = GetElement(self.m_root, "conLeftScore", WZUIContainer)
        WndNewTipsReward:showInterface(conLeftScore, element, data, false, GlobalMethod:ccp(8.7, 0.2))
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief 	iphoneX适配
function WndWeightlifting:_adaptIphoneX()
	if IsIphoneX() then
		GetElement(self.m_root, "conLeftScore", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.07,0.46))
	end
end




-------------------------------------私有方法模块End----------------------------------------


--------------------------------------语言适配Begin-----------------------------------------

function WndWeightlifting:_adaptLanguage_vn(  )
	GetElement(self.m_root,"txtUseTool1",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"cbTool1_1",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"cbTool1_2",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"cbTool2_1",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"cbTool2_2",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txtOperateBtn1",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtOperateBtn2",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtOperateBtn3",WZUILabelTTF):setScale(0.8)
end

---------------------------------------语言适配End------------------------------------------
