--WndAfforestation.lua
--@brief	WndAfforestation的UI模块
--@date		2023/12/29
--@author	yrd
--@note		植树造林活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndAfforestation:onEnter(element)
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
function WndAfforestation:onExit(element)
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
function WndAfforestation:onEnterTransitionDidFinish(element)
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7109, 7109)
end

--@brief    点击关闭窗口按钮
function WndAfforestation:showInterface()
	LoadNewActivityRes(true)
	local wnd = WndAfforestation:createElement()
	WindowManager:addWindow(wnd, WndAfforestation, false)
end

--@brief    点击关闭窗口按钮
function WndAfforestation:onClickClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	self:saveToolType()
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮
function WndAfforestation:onClickRule(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSingleMapDesc:showInterface(LocalStrings.AFFORESTATION_TEXT2)
end

--@brief    初始化静态文本
function WndAfforestation:_initStaticText()
	self:getToolType()
	self:_showAnimal()

	GetElement(self.m_root,"txtOperateBtn1",WZUILabelTTF):setText(LocalStrings.AFFORESTATION_TEXT1[8])
	GetElement(self.m_root,"txtOperateBtn2",WZUILabelTTF):setText(LocalStrings.AFFORESTATION_TEXT1[9])
	GetElement(self.m_root,"txtOperateBtn3",WZUILabelTTF):setText(LocalStrings.AFFORESTATION_TEXT1[10])
end

--@brief 	更新许愿币的数量
function WndAfforestation:_updateCoinNum()
	local sFormat = [[<I Z="0.4" P="1">%s</I><T C="255,236,193" S="20" P="1" SC="163,74,20" SS="4" SE="0">%d</T>]]
	local basicData = GDatatab_item["id_" .. self.m_nCoinId]
	local nNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	GetElement(self.m_root, "ftbOwnCoin", WZUIFreeTextBox):setShowText(string.format(sFormat, basicData.icon, nNum))
end

--@brief 	初始化活动时间
function WndAfforestation:_initActivityTime()
	local tStartDate = os.date("*t", self.m_nStartTime)
	local tEndDate = os.date("*t", self.m_nEndTime)
	local sDuration = string.format(LocalStrings.ACTIVITYTIME_FORMAT, tStartDate.month, tStartDate.day, tStartDate.hour, tStartDate.min, tEndDate.month, tEndDate.day, tEndDate.hour, tEndDate.min)
	GetElement(self.m_root, "txtActivityTime", WZUILabelTTF):setText(LocalStrings.PEOPLE_SHOP_TEXT1.. " "..sDuration)
end

--@brief 	红点
function WndAfforestation:showRedDot()
	if self.m_root == nil then return end

	local imgBtnRedDot1 = GetElement(self.m_root, "imgBtnRedDot1", WZUIImage)
	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[217109] or GlobalGame.g_tRedPointTypeList[227109] or GlobalGame.g_tRedPointTypeList[237109]) then 
		imgBtnRedDot1:setVisible(true)
	else
		imgBtnRedDot1:setVisible(false)
	end

	local imgBtnRedDot2 = GetElement(self.m_root, "imgBtnRedDot2", WZUIImage)
	if GlobalGame.g_tRedPointTypeList and GlobalGame.g_tRedPointTypeList[247109] or self.m_nDailyTeamScore < 0 and self.m_nTeamScore >= self.m_tContent.teamScoreConfig[1] then 
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

--@brief 	更新界面
function WndAfforestation:updateUI()

end

--@brief 	点击选择瓶子按钮回调
function WndAfforestation:onClickChooseTool(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nIndex = GetElement(self.m_root, "cbgTools", WZUICheckBoxGroup):getCheckIndex()
	if self.m_nDrawToolType == nIndex then
		return
	end

	self.m_nDrawToolType = nIndex
	self:updateWishingBtn()
	self:_playAni(1, true)
	self:_playAnotherAni(0)
end

--@brief 	更新许愿按钮
function WndAfforestation:updateWishingBtn()
	for i=1, 2 do
		local txtUseTool = GetElement(self.m_root,"txtUseTool"..i,WZUILabelTTF)

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
		if freeCount == 1 then
			if i == 1 then
				txtUseTool:setText(LocalStrings.AFFORESTATION_TEXT1[2])
			elseif i == 2 then
				if nTempTimes == 0 then
					txtUseTool:setText(string.format(LocalStrings.AFFORESTATION_TEXT1[3], self.m_tDrawNumList[i]))
				else
					txtUseTool:setText(string.format(LocalStrings.AFFORESTATION_TEXT1[3], nTimes))
				end
			end
		else
			txtUseTool:setText(string.format(LocalStrings.AFFORESTATION_TEXT1[3], nTimes))
		end
	end
end


--@brief 	设置待机特效
function WndAfforestation:_showAnimal()
	local spinePath = "activity/hd_pic_zhishuzhaolin"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then
		local spineBG = GetElement(self.m_root, "spineBG", WZUISpine)
		if spineBG then 
			spineBG:setFileJson(spinePath .. ".json")
			spineBG:setFileAtlas(spinePath .. ".atlas")
			spineBG:play("wait1", true)
		end
		local spineBG2 = GetElement(self.m_root, "spineBG2", WZUISpine)
		if spineBG2 then 
			spineBG2:setFileJson(spinePath .. ".json")
			spineBG2:setFileAtlas(spinePath .. ".atlas")
			spineBG2:play("wait11", true)
		end
		local spineBG3 = GetElement(self.m_root, "spineBG3", WZUISpine)
		if spineBG3 then 
			spineBG3:setFileJson(spinePath .. ".json")
			spineBG3:setFileAtlas(spinePath .. ".atlas")
			spineBG3:play("wait2", true)
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
		local _sIndex = "hd_pic_zhishuzhaolin"
		local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
		if downloadInfo then 
			DownloadManager:addDownloadTask(7109, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndAfforestation)
		end
	end
end

function WndAfforestation:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndAfforestation:downloadEffectCallback",taskId,extraData,failed)
    self:_showAnimal()
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndAfforestation:_playAni(aniIndex, bLoop)
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	aniIndex = aniIndex or 0
	if aniIndex == 0 then
		spineOpen:setVisible(false)
		return
	end
	spineOpen:setVisible(true)
	bLoop = bLoop == true and true or false

	if spineOpen then
		local animName = self.m_tClipAniName[self.m_nDrawToolType + 1][aniIndex]
		if aniIndex == 2 then
			math.randomseed(os.time())
			animName = animName[math.random(#animName)]
		end
		spineOpen:play(animName, bLoop)
	end
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndAfforestation:_playAnotherAni(aniIndex, bLoop)
	local spineCopy = GetElement(self.m_root, "spineCopy", WZUISpine)
	aniIndex = aniIndex or 0
	if aniIndex == 0 then
		spineCopy:setVisible(false)
		return
	end
	spineCopy:setVisible(true)
	bLoop = bLoop == true and true or false

	if spineCopy then
		local animName = self.m_tClipAniName[self.m_nDrawToolType + 1][aniIndex]
		if aniIndex == 2 then
			math.randomseed(os.time())
			animName = animName[math.random(#animName)]
		end
		spineCopy:play(animName, bLoop)
	end
end

--@brief 	显示开启动画
function WndAfforestation:showOpenAction()
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	local spinePath1 = "activity/hd_pic_zhishuzhaolin"
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
function WndAfforestation:showShootBefore()
	self:_playAni(0)
	local nSeconds = 2
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	spineOpen:disableSchedule()
	spineOpen:enableSchedule("showShootReward", nSeconds)
end

--@brief 	显示开启奖励
function WndAfforestation:showShootReward()
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	spineOpen:disableSchedule()
	self:_playAni(1, true)
	self:_playAnotherAni(0)

	local strContent = ""
	if self.m_tOpenResult.score and self.m_tOpenResult.score > 0 then 
		strContent = strContent .. LocalStrings.AFFORESTATION_TEXT1[21] .. "+" .. self.m_tOpenResult.score .. "    "
	end
	if strContent ~= "" then 
		MsgBoxManager:showTipBox(strContent, nil, nil, nil, nil, nil, nil, nil, nil, GlobalMethod:ccp(0.5, 0.77))
	end

	self:setOpenState(false)
	self:_afterCloseReward()
end



--@brief 	点击"自选奖励"按钮回调
function WndAfforestation:onClickChoosePrize(element)
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

--@brief 	点击许愿按钮回调
function WndAfforestation:onClickUseTool(element)
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
function WndAfforestation:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

--@brief 	点击按钮回调
function WndAfforestation:onClickOperateBtn(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nTag = element:getTag()
	if nTag == 1 then
		local otherData = {}
		otherData.taskCount = 3 --几个任务标签
		otherData.tTaskTypeName = {LocalStrings.AFFORESTATION_TEXT1[11], LocalStrings.AFFORESTATION_TEXT1[12], LocalStrings.AFFORESTATION_TEXT1[13]} --任务标签名字
		otherData.taskTitle = LocalStrings.AFFORESTATION_TEXT1[8]
		otherData.taskType = 1
		otherData.redPoint = {227109, 217109, 237109} --长线；日常；每天
		CellNewYearTask:showInterface(60, self.m_nActivityId, otherData)
	elseif nTag == 2 then
		WndHouseInvite:showInterface(13, self.m_nActivityId)
	elseif nTag == 3 then 
		local otherData = {}
		otherData.type = 1
		otherData.strRankTitleName = LocalStrings.AFFORESTATION_TEXT1[10]
		otherData.strCountLabel = string.format(LocalStrings.NEWYEAR_TEXT15,100)
		otherData.strChangeTitle = LocalStrings.AFFORESTATION_TEXT1[14]
		otherData.strScoreTitle = LocalStrings.AFFORESTATION_TEXT1[15] .. ":"
		WndShopRank:showInterface(90, self.m_nActivityId, nil, nil, otherData) 
	end
end


--@brief 	显示等级经验
function WndAfforestation:_showLvAndExp()
	local txtLevel = GetElement(self.m_root, "txtLevel", WZUILabelTTF)
	local txtLvTitle = GetElement(self.m_root, "txtLvTitle", WZUILabelTTF)
	local txtExp = GetElement(self.m_root, "txtExp", WZUILabelTTF)
	local prgExp = GetElement(self.m_root, "prgExp", WZUIProgress)

	local tCurInfo, tNextInfo, nMaxLv = self:getCurLvInfo()
	local strLvTitle = LocalStrings.AFFORESTATION_TEXT3[1]
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
function WndAfforestation:onClickLvReward(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	GetElement(self.m_root, "conLvReward", WZUIContainer):setVisible(true)
	self:_createLvRewardList()
end

--@brief 	关闭等级奖励界面
function WndAfforestation:onCloseTip(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	GetElement(self.m_root, "conLvReward", WZUIContainer):setVisible(false)
	self:showRedDot()
end

--@brief 	创建奖励
function WndAfforestation:_createLvRewardList()
	local tbLvRewardList = GetElement(self.m_root, "tbLvRewardList", WZUITableContainer)
	tbLvRewardList:cleanTable()

	local otherData = {}
	otherData.opType = 6
	otherData.strExp = LocalStrings.AFFORESTATION_TEXT1[4]
	otherData.exp = self.m_nCurExp
	otherData.tipsRoot = self.m_root
	otherData.rewardType = 2 --奖励类型：1={{id,num},{id,num},...};2={{id,id,num},{id,id,num},...};0="[id,id,num]&[id,id,num]&..."

	for i = 1, #self.m_tLvRewardList do
		local element, tNewObj = CellLvRewardItem:createElement()
		if element and tNewObj then
			element:setTag(i - 1)
			tNewObj:setData(self.m_tLvRewardList[i], 11, otherData)

			tbLvRewardList:setCellElement(element)
		end
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief 	iphoneX适配
function WndAfforestation:_adaptIphoneX()
	if IsIphoneX() then
		GetElement(self.m_root,"conOperateBtn",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.91,0.19))
	end
end




-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配模块Begin----------------------------------------

function WndAfforestation:_adaptLanguage_vn()
	GetElement(self.m_root, "txtUseTool1", WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root, "txtUseTool2", WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root, "txtOperateBtn1", WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root, "txtOperateBtn2", WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root, "txtOperateBtn3", WZUILabelTTF):setScale(0.6)

	GetElement(self.m_root, "txtLevel", WZUILabelTTF):setScale(0.55)
end

-------------------------------------语言适配模块End----------------------------------------

