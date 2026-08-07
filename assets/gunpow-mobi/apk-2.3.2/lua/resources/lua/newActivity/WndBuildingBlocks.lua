--WndBuildingBlocks.lua
--@brief	WndBuildingBlocks的UI模块
--@date		2023/12/07
--@author	yrd
--@note		拼装积木


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndBuildingBlocks:onEnter(element)
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
function WndBuildingBlocks:onExit(element)
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
function WndBuildingBlocks:onEnterTransitionDidFinish(element)
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7104, 7104)
end

--@brief    点击关闭窗口按钮
function WndBuildingBlocks:showInterface()
	LoadNewActivityRes(true)
	local wnd = WndBuildingBlocks:createElement()
	WindowManager:addWindow(wnd, WndBuildingBlocks, false)
end

--@brief    点击关闭窗口按钮
function WndBuildingBlocks:onClickClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	self:saveToolType()
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮
function WndBuildingBlocks:onClickRule(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSingleMapDesc:showInterface(LocalStrings.BUILDING_BLOCKS_TEXT2)
end

--@brief    初始化静态文本
function WndBuildingBlocks:_initStaticText()
	self:getToolType()
	self:_showAnimal()

	GetElement(self.m_root,"txtChoosePrize",WZUILabelTTF):setText(LocalStrings.WATERMELON_TEXT1[22])
	GetElement(self.m_root,"txtOperateBtn1",WZUILabelTTF):setText(LocalStrings.BUILDING_BLOCKS_TEXT1[4])
	GetElement(self.m_root,"txtOperateBtn2",WZUILabelTTF):setText(LocalStrings.BUILDING_BLOCKS_TEXT1[5])
	GetElement(self.m_root,"txtOperateBtn3",WZUILabelTTF):setText(LocalStrings.BUILDING_BLOCKS_TEXT1[6])
	GetElement(self.m_root,"cbTool1_1",WZUILabelTTF):setText(LocalStrings.BUILDING_BLOCKS_TEXT1[21])
	GetElement(self.m_root,"cbTool1_2",WZUILabelTTF):setText(LocalStrings.BUILDING_BLOCKS_TEXT1[21])
	GetElement(self.m_root,"cbTool2_1",WZUILabelTTF):setText(LocalStrings.BUILDING_BLOCKS_TEXT1[22])
	GetElement(self.m_root,"cbTool2_2",WZUILabelTTF):setText(LocalStrings.BUILDING_BLOCKS_TEXT1[22])

	GetElement(self.m_root, "txtLvRewardT", WZUILabelTTF):setText(LocalStrings.BUILDING_BLOCKS_TEXT1[7])
end

--@brief 	更新许愿币的数量
function WndBuildingBlocks:_updateCoinNum()
	local sFormat = [[<I Z="0.4" P="1">%s</I><T C="255,236,193" S="20" P="1" SC="163,74,20" SS="4" SE="0">%d</T>]]
	local basicData = GDatatab_item["id_" .. self.m_nCoinId]
	local nNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	GetElement(self.m_root, "ftbOwnCoin", WZUIFreeTextBox):setShowText(string.format(sFormat, basicData.icon, nNum))
end

--@brief 	初始化活动时间
function WndBuildingBlocks:_initActivityTime()
	local tStartDate = os.date("*t", self.m_nStartTime)
	local tEndDate = os.date("*t", self.m_nEndTime)
	local sDuration = string.format(LocalStrings.ACTIVITYTIME_FORMAT, tStartDate.month, tStartDate.day, tStartDate.hour, tStartDate.min, tEndDate.month, tEndDate.day, tEndDate.hour, tEndDate.min)
	GetElement(self.m_root, "txtActivityTime", WZUILabelTTF):setText(LocalStrings.PEOPLE_SHOP_TEXT1.. " "..sDuration)
end

--@brief 	红点
function WndBuildingBlocks:showRedDot()
	if self.m_root == nil then return end 

	local imgBtnRedDot1 = GetElement(self.m_root, "imgBtnRedDot1", WZUIImage)
	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[227104] or GlobalGame.g_tRedPointTypeList[217104]) then 
		imgBtnRedDot1:setVisible(true)
	else
		imgBtnRedDot1:setVisible(false)
	end

	local imgBtnRedDot2 = GetElement(self.m_root, "imgBtnRedDot2", WZUIImage)
	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[237104]) then 
		imgBtnRedDot2:setVisible(true)
	else
		imgBtnRedDot2:setVisible(false)
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
function WndBuildingBlocks:showBagGiftInfo()
	if self.m_nGiftRewardNum > 0 then 
		GetElement(self.m_root, "imgGiftRed", WZUIImage):setVisible(true)
		GetElement(self.m_root, "txtGiftNum", WZUILabelTTF):setText(self.m_nGiftRewardNum)
	else
		GetElement(self.m_root, "imgGiftRed", WZUIImage):setVisible(false)
	end
end

--@brief 	点击选择瓶子按钮回调
function WndBuildingBlocks:onClickChooseTool(element)
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
function WndBuildingBlocks:_showAnimal()
	local spinePath = "activity/hd_pic_jimu"
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
		local spineBlingBling1 = GetElement(self.m_root, "spineBlingBling1", WZUISpine)
		if spineBlingBling1 then
			spineBlingBling1:setFileJson(spinePath .. ".json") 
			spineBlingBling1:setFileAtlas(spinePath .. ".atlas")
			spineBlingBling1:play("wait3", true)
		end
		local spineBlingBling2 = GetElement(self.m_root, "spineBlingBling2", WZUISpine)
		if spineBlingBling2 then
			spineBlingBling2:setFileJson(spinePath .. ".json") 
			spineBlingBling2:setFileAtlas(spinePath .. ".atlas")
		end
	else
		local _sIndex = "hd_pic_jimu"
		local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
		if downloadInfo then 
			DownloadManager:addDownloadTask(7104, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndBuildingBlocks)
		end
	end
end

function WndBuildingBlocks:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndBuildingBlocks:downloadEffectCallback",taskId,extraData,failed)
    self:_showAnimal()
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndBuildingBlocks:_playAni(aniIndex, bLoop)
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
function WndBuildingBlocks:_playAnotherAni(aniIndex, bLoop)
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
function WndBuildingBlocks:showOpenAction()
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	local spinePath1 = "activity/hd_pic_jimu"
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
function WndBuildingBlocks:showShootBefore()
	self:_playAni(0)
	local nSeconds = 0.8
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	spineOpen:disableSchedule()
	spineOpen:enableSchedule("showShootOther", nSeconds)
end

--@brief 	插播其他动画
function WndBuildingBlocks:showShootOther()
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	spineOpen:disableSchedule()

	local nSeconds = 1
	local spineBlingBling2 = GetElement(self.m_root, "spineBlingBling2", WZUISpine)
	spineBlingBling2:play("wait4", false)
	spineBlingBling2:disableSchedule()
	spineBlingBling2:enableSchedule("showShootReward", nSeconds)
end

--@brief 	显示开启奖励
function WndBuildingBlocks:showShootReward()
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	spineOpen:disableSchedule()
	local spineBlingBling2 = GetElement(self.m_root, "spineBlingBling2", WZUISpine)
	spineBlingBling2:disableSchedule()
	self:_playAni(1, true)
	self:_playAnotherAni(0)

	local strContent = ""
	if self.m_tOpenResult.addExp and self.m_tOpenResult.addExp > 0 then 
		strContent = strContent .. LocalStrings.BUILDING_BLOCKS_TEXT1[13] .. "+" .. self.m_tOpenResult.addExp .. "    "
	end
	if strContent ~= "" then 
		MsgBoxManager:showTipBox(strContent, nil, nil, nil, nil, nil, nil, nil, nil, GlobalMethod:ccp(0.5, 0.77))
	end

	self:_showLvAndExp()
	self:setOpenState(false)
	self:_afterCloseReward()
end

--@brief 	点击"自选奖励"按钮回调
function WndBuildingBlocks:onClickChoosePrize(element)
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

--@brief 	更新许愿按钮
function WndBuildingBlocks:updateDrawgBtn()
	for i=1, 2 do
		local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
		local nTempTimes = math.floor(nArrowNum/self.m_tCostByType[self.m_nDrawToolType + 1]) --可许愿次数
		local freeCount = 0 --免费次数
		if self.m_nDrawToolType == 0 then 
			freeCount = self.m_nCount > 0 and 1 or 0 
		end
		local nTimes = self.m_tDrawNumList[i]
		local nAllTimes = nTempTimes + freeCount --可许愿次数 + 免费次数
		if nAllTimes > 0 and nAllTimes < self.m_tDrawNumList[i] then
			nTimes = nAllTimes
		end

		local txtUseTool = GetElement(self.m_root,"txtUseTool"..i,WZUILabelTTF)
		local strDraw = string.format(LocalStrings.BUILDING_BLOCKS_TEXT1[3], nTimes)
		if freeCount == 1 then
			if i == 1 then
				strDraw = LocalStrings.BUILDING_BLOCKS_TEXT1[2]
			elseif i == 2 then
				if nTempTimes == 0 then
					strDraw = string.format(LocalStrings.BUILDING_BLOCKS_TEXT1[3], self.m_tDrawNumList[i])
				end
			end
		end
		txtUseTool:setText(strDraw)
	end
end

--@brief 	点击许愿按钮回调
function WndBuildingBlocks:onClickUseTool(element)
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

	local nTag = element:getTag()
	local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local nTempTimes = math.floor(nArrowNum/self.m_tCostByType[self.m_nDrawToolType + 1]) --可许愿次数
	local freeCount = 0 --免费次数
	if self.m_nDrawToolType == 0 then 
		freeCount = self.m_nCount > 0 and 1 or 0 
	end
	self.m_nAniType = nTag
	local nTimes = self.m_tDrawNumList[nTag]
	local nAllTimes = nTempTimes + freeCount --可许愿次数 + 免费次数
	if nAllTimes > 0 and nAllTimes < self.m_tDrawNumList[nTag] then
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
	tData.times = self.m_tDrawNumList[nTag]
	tData.pool = self.m_nDrawToolType
	local stringData = json.encode(tData)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 3, stringData)
end

--@brief 	前往小推车购买
function WndBuildingBlocks:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

--@brief 	点击按钮回调
function WndBuildingBlocks:onClickOperateBtn(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nTag = element:getTag()
	if nTag == 1 then
		CellNewYearTask:showInterface(51, self.m_nActivityId)
	elseif nTag == 2 then
		WndShopRank:showInterface(71, self.m_nActivityId)
	elseif nTag == 3 then
		WndShopRank:showInterface(70, self.m_nActivityId)
	end
end

--@brief 	显示等级经验
function WndBuildingBlocks:_showLvAndExp()
	local txtLevel = GetElement(self.m_root, "txtLevel", WZUILabelTTF)
	local txtLvTitle = GetElement(self.m_root, "txtLvTitle", WZUILabelTTF)
	local txtExp = GetElement(self.m_root, "txtExp", WZUILabelTTF)
	local prgExp = GetElement(self.m_root, "prgExp", WZUIProgress)

	local tCurInfo, tNextInfo, nMaxLv = self:getCurLvInfo()
	local strLvTitle = LocalStrings.BUILDING_BLOCKS_TEXT3[1]
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

	local tImgPath = {[0]="ui/specialBg/hd_pic_pzjm_cb_Lv0.png","ui/specialBg/hd_pic_pzjm_cb_Lv1.png", "ui/specialBg/hd_pic_pzjm_cb_Lv2.png", "ui/specialBg/hd_pic_pzjm_cb_Lv3.png", "ui/specialBg/hd_pic_pzjm_cb_Lv4.png", "ui/specialBg/hd_pic_pzjm_cb_Lv5.png"}
	local tImgPos = {[0]=ccp(0.525,0.255),ccp(0.54,0.295),ccp(0.555,0.405),ccp(0.57,0.385),ccp(0.505,0.39),ccp(0.55,0.505)}
	local imgHouse = GetElement(self.m_root,"imgHouse",WZUIImage)
	imgHouse:setRelativePosition(tImgPos[nCurLevel])
	imgHouse:setFile(tImgPath[nCurLevel])

	local nPercentage = math.floor(100 * self.m_nCurExp/tNextInfo.exp)
	if nPercentage > 100 then 
		nPercentage = 100
	end
	prgExp:setPercentage(nPercentage)
end

--@brief 	点击领取等级奖励按钮
function WndBuildingBlocks:onClickLvReward(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	GetElement(self.m_root, "conLvReward", WZUIContainer):setVisible(true)
	self:_createLvRewardList()
end

--@brief 	关闭捕鼠奖励界面
function WndBuildingBlocks:onCloseTip(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	GetElement(self.m_root, "conLvReward", WZUIContainer):setVisible(false)
	self:showRedDot()
end

--@brief 	创建捕鼠奖励
function WndBuildingBlocks:_createLvRewardList()
	local tbLvRewardList = GetElement(self.m_root, "tbLvRewardList", WZUITableContainer)
	tbLvRewardList:cleanTable()
	for i = 1, #self.m_tLvRewardList do
		local element, tNewObj = CellLvRewardItem:createElement()
		if element and tNewObj then
			element:setTag(i - 1)
			tNewObj:setData(self.m_tLvRewardList[i], 9)

			tbLvRewardList:setCellElement(element)
		end
	end
end

--@brief    点击领取碎片
function WndBuildingBlocks:onClickGetElement(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nIndex = -1
	for i=1,#self.m_nMagicStatus do
		if self.m_nMagicStatus[i] == 0 then
			nIndex = i - 1
			break
		end
	end

	if nIndex == -1 then
		return
	end

	local tData = {}
	tData.id = nIndex
	local stringData = json.encode(tData)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 6, stringData)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief 	iphoneX适配
function WndBuildingBlocks:_adaptIphoneX()
	if IsIphoneX() then
	end
end




-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配模块Begin----------------------------------------

function WndBuildingBlocks:_adaptLanguage_vn()
	GetElement(self.m_root,"btnTip",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.31,0.743))
	GetElement(self.m_root,"txtUseTool1",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtUseTool2",WZUILabelTTF):setScale(0.8)
	local txtOperateBtn1 = GetElement(self.m_root,"txtOperateBtn1",WZUILabelTTF)
	txtOperateBtn1:setScale(0.6)
	txtOperateBtn1:setDimensions(GlobalMethod:CCSize(120,0))
	local txtOperateBtn2 = GetElement(self.m_root,"txtOperateBtn2",WZUILabelTTF)
	txtOperateBtn2:setScale(0.6)
	txtOperateBtn2:setDimensions(GlobalMethod:CCSize(120,0))
	local txtOperateBtn3 = GetElement(self.m_root,"txtOperateBtn3",WZUILabelTTF)
	txtOperateBtn3:setScale(0.6)
	txtOperateBtn3:setDimensions(GlobalMethod:CCSize(120,0))
	local cbTool1_1 = GetElement(self.m_root,"cbTool1_1",WZUILabelTTF)
	cbTool1_1:setScale(0.6)
	cbTool1_1:setDimensions(GlobalMethod:CCSize(120,0))
	local cbTool1_2 = GetElement(self.m_root,"cbTool1_2",WZUILabelTTF)
	cbTool1_2:setScale(0.6)
	cbTool1_2:setDimensions(GlobalMethod:CCSize(120,0))
	local cbTool2_1 = GetElement(self.m_root,"cbTool2_1",WZUILabelTTF)
	cbTool2_1:setScale(0.6)
	cbTool2_1:setDimensions(GlobalMethod:CCSize(120,0))
	local cbTool2_2 = GetElement(self.m_root,"cbTool2_2",WZUILabelTTF)
	cbTool2_2:setScale(0.6)
	cbTool2_2:setDimensions(GlobalMethod:CCSize(120,0))
end

-------------------------------------语言适配模块End----------------------------------------

