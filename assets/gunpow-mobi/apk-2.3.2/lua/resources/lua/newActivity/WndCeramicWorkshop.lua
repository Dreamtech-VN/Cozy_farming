--WndCeramicWorkshop.lua
--@brief	WndCeramicWorkshop的UI模块
--@date		2023/11/29
--@author	yrd
--@note		陶艺工坊


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCeramicWorkshop:onEnter(element)
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
function WndCeramicWorkshop:onExit(element)
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
function WndCeramicWorkshop:onEnterTransitionDidFinish(element)
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7101, 7101)
end

--@brief    点击关闭窗口按钮
function WndCeramicWorkshop:showInterface()
	LoadNewActivityRes(true)
	local wnd = WndCeramicWorkshop:createElement()
	WindowManager:addWindow(wnd, WndCeramicWorkshop, false)
end

--@brief    点击关闭窗口按钮
function WndCeramicWorkshop:onClickClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	self:saveToolType()
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮
function WndCeramicWorkshop:onClickRule(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSingleMapDesc:showInterface(LocalStrings.CERAMIC_WORKSHOP_TEXT3)
end

--@brief    初始化静态文本
function WndCeramicWorkshop:_initStaticText()
	self:getToolType()

	GetElement(self.m_root,"txtChoosePrize",WZUILabelTTF):setText(LocalStrings.WATERMELON_TEXT1[22])
	GetElement(self.m_root,"txtOperateBtn1",WZUILabelTTF):setText(LocalStrings.CERAMIC_WORKSHOP_TEXT1[9])
	GetElement(self.m_root,"txtOperateBtn2",WZUILabelTTF):setText(LocalStrings.CERAMIC_WORKSHOP_TEXT1[10])
	GetElement(self.m_root,"txtLvRewardT",WZUILabelTTF):setText(LocalStrings.CERAMIC_WORKSHOP_TEXT1[16])
end

--@brief 	更新许愿币的数量
function WndCeramicWorkshop:_updateCoinNum()
	local sFormat = [[<I Z="0.4" P="1">%s</I><T C="255,236,193" S="20" P="1" SC="163,74,20" SS="4" SE="0">%d</T>]]
	local basicData = GDatatab_item["id_" .. self.m_nCoinId]
	local nNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	GetElement(self.m_root, "ftbOwnCoin", WZUIFreeTextBox):setShowText(string.format(sFormat, basicData.icon, nNum))
end

--@brief 	初始化活动时间
function WndCeramicWorkshop:_initActivityTime()
	local tStartDate = os.date("*t", self.m_nStartTime)
	local tEndDate = os.date("*t", self.m_nEndTime)
	local sDuration = string.format(LocalStrings.ACTIVITYTIME_FORMAT, tStartDate.month, tStartDate.day, tStartDate.hour, tStartDate.min, tEndDate.month, tEndDate.day, tEndDate.hour, tEndDate.min)
	GetElement(self.m_root, "txtActivityTime", WZUILabelTTF):setText(LocalStrings.PEOPLE_SHOP_TEXT1.. " "..sDuration)
end

--@brief 	红点
function WndCeramicWorkshop:showRedDot()
	if self.m_root == nil then return end 

	local imgBtnRedDot1 = GetElement(self.m_root, "imgBtnRedDot1", WZUIImage)
	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[117101] or GlobalGame.g_tRedPointTypeList[127101]) then 
		imgBtnRedDot1:setVisible(true)
	else
		imgBtnRedDot1:setVisible(false)
	end

	local imgExpReddot = GetElement(self.m_root, "imgExpReddot", WZUIImage)
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

--@brief 	刷新"全民许愿"礼包的信息
function WndCeramicWorkshop:showBagGiftInfo()
	if self.m_nGiftRewardNum > 0 then 
		GetElement(self.m_root, "imgGiftRed", WZUIImage):setVisible(true)
		GetElement(self.m_root, "txtGiftNum", WZUILabelTTF):setText(self.m_nGiftRewardNum)
	else
		GetElement(self.m_root, "imgGiftRed", WZUIImage):setVisible(false)
	end
end

--@brief 	点击选择瓶子按钮回调
function WndCeramicWorkshop:onClickChooseTool(element)
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


--@brief 	设置待机特效
function WndCeramicWorkshop:_showAnimal()
	local spinePath = "activity/hd_pic_tyhd"
	local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".json")
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
		local _sIndex = "hd_pic_tyhd"
		local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
		if downloadInfo then 
			DownloadManager:addDownloadTask(7101, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndCeramicWorkshop)
		end
	end
end

function WndCeramicWorkshop:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndCeramicWorkshop:downloadEffectCallback",taskId,extraData,failed)
    self:_showAnimal()
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndCeramicWorkshop:_playAni(aniIndex, bLoop)
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	aniIndex = aniIndex or 0
	if aniIndex == 0 then
		spineOpen:setVisible(false)
		return
	end
	spineOpen:setVisible(true)
	bLoop = bLoop == true and true or false

	local tAniName
	if self.m_nCurFireLeftProg > 0 then
		tAniName = self.m_tClipAniName2
	else
		tAniName = self.m_tClipAniName1
	end

	if spineOpen then 
		spineOpen:play(tAniName[self.m_nDrawToolType + 1][aniIndex], bLoop)
	end
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndCeramicWorkshop:_playAnotherAni(aniIndex, bLoop)
	local spineCopy = GetElement(self.m_root, "spineCopy", WZUISpine)
	aniIndex = aniIndex or 0
	if aniIndex == 0 then
		spineCopy:setVisible(false)
		return
	end
	spineCopy:setVisible(true)
	bLoop = bLoop == true and true or false

	local tAniName
	if self.m_nCurFireLeftProg > 0 then
		tAniName = self.m_tClipAniName2
	else
		tAniName = self.m_tClipAniName1
	end

	if spineCopy then 
		spineCopy:play(tAniName[self.m_nDrawToolType + 1][aniIndex], bLoop)
	end
end

--@brief 	显示开启动画
function WndCeramicWorkshop:showOpenAction()
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	local spinePath1 = "activity/hd_pic_tyhd"
	local existSpine1 = WZDataFile:getInstance():checkFileExist(spinePath1 .. ".json")
	if spineOpen then 
		if existSpine1 then
			local aniIndex = self.m_nAniType + 1 
			self:_playAnotherAni(aniIndex, false)
			spineOpen:enableSchedule("showShootBefore", 0)
		else
			self:showShootReward()
		end
	end
end

--@brief 	显示开启奖励 处理抽奖时人物人物会闪一下问题
function WndCeramicWorkshop:showShootBefore()
	self:_playAni(0)
	local nSeconds = 2
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	spineOpen:disableSchedule()
	spineOpen:enableSchedule("showShootReward", nSeconds)
end

--@brief 	显示开启奖励
function WndCeramicWorkshop:showShootReward()
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	spineOpen:disableSchedule()
	self:_playAni(1, true)
	self:_playAnotherAni(0)

	local strContent = ""
	if self.m_tOpenResult.addExp and self.m_tOpenResult.addExp > 0 then 
		strContent = strContent .. LocalStrings.CERAMIC_WORKSHOP_TEXT1[14] .. "+" .. self.m_tOpenResult.addExp .. "    "
	end
	if strContent ~= "" then 
		MsgBoxManager:showTipBox(strContent, nil, nil, nil, nil, nil, nil, nil, nil, GlobalMethod:ccp(0.5, 0.77))
	end

	self:setOpenState(false)
	self:_afterCloseReward()
end

--@brief 	点击"自选奖励"按钮回调
function WndCeramicWorkshop:onClickChoosePrize(element)
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

--@brief 	点击选择数量按钮回调
function WndCeramicWorkshop:onClickSwitchNum(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	self.m_nDrawNumType = self.m_nDrawNumType % 2 + 1

	self:updateDrawgBtn()
end

--@brief 	更新许愿按钮
function WndCeramicWorkshop:updateDrawgBtn()
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
	
	-- 单次抽奖不能超过度烧窑或捏陶阶段剩余次数,
	local tmpNum = 0
	if self.m_nCurFireLeftProg > 0 then
		tmpNum = self.m_nCurFireLeftProg / self.m_tCostByType[self.m_nDrawToolType + 1]
	else
		tmpNum = (self.m_tContent.giftConfig[1] - self.m_nCostTimes) / self.m_tCostByType[self.m_nDrawToolType + 1]
	end
	if self.m_nDrawToolType == 0 and self.m_nCount > 0 then
		tmpNum = tmpNum + 1
	end
	nTimes = math.min(nTimes, tmpNum)

	local strDesc1 = ""
	local strDesc2 = ""
	if self.m_nCurFireLeftProg > 0 then
		strDesc1 = LocalStrings.CERAMIC_WORKSHOP_TEXT1[4]
		strDesc2 = LocalStrings.CERAMIC_WORKSHOP_TEXT1[5]
	else
		strDesc1 = LocalStrings.CERAMIC_WORKSHOP_TEXT1[2]
		strDesc2 = LocalStrings.CERAMIC_WORKSHOP_TEXT1[3]
	end

	if freeCount == 1 then
		if self.m_nDrawNumType == 1 then
			txtUseTool:setText(strDesc1)
		elseif self.m_nDrawNumType == 2 then
			if nTempTimes == 0 then
				txtUseTool:setText(string.format(strDesc2, self.m_tDrawNumList[self.m_nDrawNumType]))
			else
				txtUseTool:setText(string.format(strDesc2, nTimes))
			end
		end
	else
		txtUseTool:setText(string.format(strDesc2, nTimes))
	end

	local tempColorList = {GlobalMethod:ccc3(127,70,26), GlobalMethod:ccc3(255,255,255)}
	txtUseTool:setColor(tempColorList[self.m_nDrawNumType])

	local imgUseTool1 = GetElement(self.m_root,"imgUseTool1",WZUIImage)
	local tempImgPathList = {"ui/activity/common_btn_51.png", "ui/activity/common_btn_52.png"}
	imgUseTool1:setFile(tempImgPathList[self.m_nDrawNumType])
end

--@brief 	点击许愿按钮回调
function WndCeramicWorkshop:onClickUseTool(element)
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
function WndCeramicWorkshop:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

--@brief 	点击按钮回调
function WndCeramicWorkshop:onClickOperateBtn(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nTag = element:getTag()
	if nTag == 1 then
		CellNewYearTask:showInterface(48, self.m_nActivityId)
	elseif nTag == 2 then
		WndShopRank:showInterface(67, self.m_nActivityId)
	end
end

--@brief 	显示等级经验
function WndCeramicWorkshop:_showLvAndExp()
	local txtLevel = GetElement(self.m_root, "txtLevel", WZUILabelTTF)
	local txtLvTitle = GetElement(self.m_root, "txtLvTitle", WZUILabelTTF)
	local txtExp = GetElement(self.m_root, "txtExp", WZUILabelTTF)
	local prgExp = GetElement(self.m_root, "prgExp", WZUIProgress)

	local tCurInfo, tNextInfo, nMaxLv = self:getCurLvInfo()
	local strLvTitle = LocalStrings.CERAMIC_WORKSHOP_TEXT2[1]
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

--@brief 	点击领取等级奖励按钮
function WndCeramicWorkshop:onClickLvReward(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	GetElement(self.m_root, "conLvReward", WZUIContainer):setVisible(true)
	self:_createLvRewardList()
end

--@brief 	关闭捕鼠奖励界面
function WndCeramicWorkshop:onCloseTip(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	GetElement(self.m_root, "conLvReward", WZUIContainer):setVisible(false)
	self:showRedDot()
end

--@brief 	创建捕鼠奖励
function WndCeramicWorkshop:_createLvRewardList()
	local tbLvRewardList = GetElement(self.m_root, "tbLvRewardList", WZUITableContainer)
	tbLvRewardList:cleanTable()
	for i = 1, #self.m_tLvRewardList do
		local element, tNewObj = CellLvRewardItem:createElement()
		if element and tNewObj then
			element:setTag(i - 1)
			tNewObj:setData(self.m_tLvRewardList[i], 8)

			tbLvRewardList:setCellElement(element)
		end
	end
end

--@brief 	显示火力进度
function WndCeramicWorkshop:showMainUI()
	local conFireProgress = GetElement(self.m_root,"conFireProgress",WZUIContainer)
	local txtOutputValue = GetElement(self.m_root,"txtOutputValue",WZUILabelTTF)
	if self.m_nCurFireLeftProg > 0 then
		conFireProgress:setVisible(true)
		txtOutputValue:setVisible(false)
	else
		conFireProgress:setVisible(false)
		txtOutputValue:setVisible(true)
	end
	local txtFireValue = GetElement(self.m_root,"txtFireValue",WZUILabelTTF)
	txtFireValue:setText((self.m_tContent.giftConfig[2] - self.m_nCurFireLeftProg).."/"..self.m_tContent.giftConfig[2])
	local prgFireValue = GetElement(self.m_root,"prgFireValue",WZUIProgress)
	prgFireValue:setPercentage((self.m_tContent.giftConfig[2] - self.m_nCurFireLeftProg) / self.m_tContent.giftConfig[2] * 100)
	local nLeftValue = self.m_tContent.giftConfig[1] - self.m_nCostTimes
	txtOutputValue:setText(string.format(LocalStrings.CERAMIC_WORKSHOP_TEXT1[20], nLeftValue, self.m_tContent.giftConfig[5]))


	if not self.m_bOpenState then
		self:_showAnimal()
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief 	iphoneX适配
function WndCeramicWorkshop:_adaptIphoneX()
	if IsIphoneX() then
	end
end




-------------------------------------私有方法模块End----------------------------------------


--------------------------------------语言适配Begin-----------------------------------------

function WndCeramicWorkshop:_adaptLanguage_vn(  )
	GetElement(self.m_root,"txtLevel",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txtUseTool1",WZUILabelTTF):setScale(0.7)
	local txtOperateBtn1 = GetElement(self.m_root,"txtOperateBtn1",WZUILabelTTF)
	txtOperateBtn1:setScale(0.7)
	txtOperateBtn1:setDimensions(GlobalMethod:CCSize(120,0))
	txtOperateBtn1:setRelativePosition(GlobalMethod:ccp(0.5,0.54))
end

---------------------------------------语言适配End------------------------------------------
