--WndMakeSnowman.lua
--@brief	WndMakeSnowman的UI模块
--@date		2023/11/07
--@author	yrd
--@note		堆雪人活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMakeSnowman:onEnter(element)
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

	GetElement(self.m_root,"conJigsaw",WZUIContainer):setVisible(false)

	self:_adaptIphoneX()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMakeSnowman:onExit(element)
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
function WndMakeSnowman:onEnterTransitionDidFinish(element)
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7099, 7099)
end

--@brief    点击关闭窗口按钮
function WndMakeSnowman:showInterface()
	LoadNewActivityRes(true)
	local wnd = WndMakeSnowman:createElement()
	WindowManager:addWindow(wnd, WndMakeSnowman, false)
end

--@brief    点击关闭窗口按钮
function WndMakeSnowman:onClickClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	self:saveToolType()
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮
function WndMakeSnowman:onClickRule(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local otherInfo = {imgBg="ui/common/frame_tc_xiao_lan.png", imgClose = "ui/newvip/common_top_btn_guanbi_lan.png"}
 	WndFourStarRuleDesc:showInterface(LocalStrings.MAKE_SHOWMAN_TEXT2, nil, otherInfo)
end

--@brief    初始化静态文本
function WndMakeSnowman:_initStaticText()
	self:getToolType()
	self:_showAnimal()

	GetElement(self.m_root,"txtChoosePrize",WZUILabelTTF):setText(LocalStrings.WATERMELON_TEXT1[22])
	GetElement(self.m_root,"txtOperateBtn1",WZUILabelTTF):setText(LocalStrings.MAKE_SHOWMAN_TEXT1[4])
	GetElement(self.m_root,"txtOperateBtn2",WZUILabelTTF):setText(LocalStrings.MAKE_SHOWMAN_TEXT1[5])
	GetElement(self.m_root,"txtOperateBtn4",WZUILabelTTF):setText(LocalStrings.MAKE_SHOWMAN_TEXT1[6])
	GetElement(self.m_root,"txtOperateBtn5",WZUILabelTTF):setText(LocalStrings.MAKE_SHOWMAN_TEXT1[7])

	GetElement(self.m_root,"txtJigsawReward",WZUILabelTTF):setText(LocalStrings.MAKE_SHOWMAN_TEXT1[18])
	GetElement(self.m_root,"txtJigsawTips",WZUILabelTTF):setText(LocalStrings.MAKE_SHOWMAN_TEXT1[20])
	GetElement(self.m_root,"txtJigsawTitle",WZUILabelTTF):setText(LocalStrings.MAKE_SHOWMAN_TEXT1[7])
end

--@brief 	更新许愿币的数量
function WndMakeSnowman:_updateCoinNum()
	local sFormat = [[<I Z="0.4" P="1">%s</I><T C="255,255,255" S="20" P="1" SC="10,104,181" SS="4" SE="1">%d</T>]]
	local basicData = GDatatab_item["id_" .. self.m_nCoinId]
	local nNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	GetElement(self.m_root, "ftbOwnCoin", WZUIFreeTextBox):setShowText(string.format(sFormat, basicData.icon, nNum))

	local sFormat2 = [[<I Z="0.4" P="1">%s</I><T C="127,70,26" S="20" P="1">%s:</T><T C="229,105,22" S="20" P="1">%d</T>]]
	local basicData2 = GDatatab_item["id_" .. self.m_nCoinId2]
	local nNum2 = CacheCenter:getPlayerItemCountById(self.m_nCoinId2)
	GetElement(self.m_root, "ftbJigsawCoin", WZUIFreeTextBox):setShowText(string.format(sFormat2, basicData2.icon, basicData2.name, nNum2))
end

--@brief 	初始化活动时间
function WndMakeSnowman:_initActivityTime()
	local tStartDate = os.date("*t", self.m_nStartTime)
	local tEndDate = os.date("*t", self.m_nEndTime)
	local sDuration = string.format(LocalStrings.ACTIVITYTIME_FORMAT, tStartDate.month, tStartDate.day, tStartDate.hour, tStartDate.min, tEndDate.month, tEndDate.day, tEndDate.hour, tEndDate.min)
	GetElement(self.m_root, "txtActivityTime", WZUILabelTTF):setText(sDuration)
end

--@brief 	红点
function WndMakeSnowman:showRedDot()
	if self.m_root == nil then return end 

	local imgBtnRedDot1 = GetElement(self.m_root, "imgBtnRedDot1", WZUIImage)
	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[217099] or GlobalGame.g_tRedPointTypeList[227099] or GlobalGame.g_tRedPointTypeList[237099]) then 
		imgBtnRedDot1:setVisible(true)
	else
		imgBtnRedDot1:setVisible(false)
	end
end

--@brief 	刷新"全民许愿"礼包的信息
function WndMakeSnowman:showBagGiftInfo()
	if self.m_nGiftRewardNum > 0 then 
		GetElement(self.m_root, "imgGiftRed", WZUIImage):setVisible(true)
		GetElement(self.m_root, "txtGiftNum", WZUILabelTTF):setText(self.m_nGiftRewardNum)
	else
		GetElement(self.m_root, "imgGiftRed", WZUIImage):setVisible(false)
	end
end

--@brief 	点击选择瓶子按钮回调
function WndMakeSnowman:onClickChooseTool(element)
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
function WndMakeSnowman:updateWishingBtn()
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
				txtUseTool:setText(LocalStrings.MAKE_SHOWMAN_TEXT1[2])
			elseif i == 2 then
				if nTempTimes == 0 then
					txtUseTool:setText(string.format(LocalStrings.MAKE_SHOWMAN_TEXT1[3], self.m_tDrawNumList[i]))
				else
					txtUseTool:setText(string.format(LocalStrings.MAKE_SHOWMAN_TEXT1[3], nTimes))
				end
			end
		else
			txtUseTool:setText(string.format(LocalStrings.MAKE_SHOWMAN_TEXT1[3], nTimes))
		end
	end
end


--@brief 	设置待机特效
function WndMakeSnowman:_showAnimal()
	local spinePath = "activity/hd_pic_duixueren"
	local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".json")
	if existSpine then
		local spineBG = GetElement(self.m_root, "spineBG", WZUISpine)
		if spineBG then 
			spineBG:setFileJson(spinePath .. ".json")
			spineBG:setFileAtlas(spinePath .. ".atlas")
			spineBG:play("wait3_1", true)
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
		local _sIndex = "hd_pic_duixueren"
		local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
		if downloadInfo then 
			DownloadManager:addDownloadTask(7099, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndMakeSnowman)
		end
	end
end

function WndMakeSnowman:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndMakeSnowman:downloadEffectCallback",taskId,extraData,failed)
    self:_showAnimal()
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndMakeSnowman:_playAni(aniIndex, bLoop)
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
function WndMakeSnowman:_playAnotherAni(aniIndex, bLoop)
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
function WndMakeSnowman:showOpenAction()
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	local spinePath1 = "activity/hd_pic_duixueren"
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
function WndMakeSnowman:showShootBefore()
	self:_playAni(0)
	local nSeconds = 2
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	spineOpen:disableSchedule()
	spineOpen:enableSchedule("showShootReward", nSeconds)
end

--@brief 	显示开启奖励
function WndMakeSnowman:showShootReward()
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	spineOpen:disableSchedule()
	self:_playAni(1, true)
	self:_playAnotherAni(0)

	local strContent = ""
	if self.m_tOpenResult.addExp and self.m_tOpenResult.addExp > 0 then 
		strContent = strContent .. LocalStrings.MAKE_SHOWMAN_TEXT1[21] .. "+" .. self.m_tOpenResult.addExp .. "    "
	end
	if strContent ~= "" then 
		MsgBoxManager:showTipBox(strContent, nil, nil, nil, nil, nil, nil, nil, nil, GlobalMethod:ccp(0.5, 0.77))
	end

	self:setOpenState(false)
	self:_afterCloseReward()
end



--@brief 	点击"自选奖励"按钮回调
function WndMakeSnowman:onClickChoosePrize(element)
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
function WndMakeSnowman:onClickUseTool(element)
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
function WndMakeSnowman:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

--@brief 	点击按钮回调
function WndMakeSnowman:onClickOperateBtn(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nTag = element:getTag()
	if nTag == 1 then
		CellNewYearTask:showInterface(46, self.m_nActivityId)
	elseif nTag == 2 then
		WndShopRank:showInterface(65, self.m_nActivityId) 
	elseif nTag == 3 then

	elseif nTag == 4 then
		if self.m_nGiftRewardNum >= 1 then
			if CacheCenter:getRemainAmount() <= 0 then --背包已满提示
				MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
				return
			end
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 5, "")
		else
			local tData = {}
			tData.txtTitle = string.format(LocalStrings.MAKE_SHOWMAN_TEXT1[12], self.m_tContent.globalConfig[1])
			tData.nType = 2
			WndTips:show(element, self.m_root, 52, tData, GlobalMethod:ccp(70,80), true)
		end
	elseif nTag == 5 then
		self:showResidualPage(true)
		self:setOpenPageState(false)

		local tData = {pool = 3}
		local strJson = json.encode(tData)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson)
	end
end

--@brief 	显示残页界面
function WndMakeSnowman:showResidualPage(bShow)
	GetElement(self.m_root,"conJigsaw",WZUIContainer):setVisible(bShow)
end

--@brief 	点击打开旅行足迹界面
function WndMakeSnowman:onClickCloseJigsaw(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self:showResidualPage(false)
	self:setOpenPageState(false)
end

--@brief 	显示拼图奖励
function WndMakeSnowman:_showFiveKeyReward()
	local tcReward = GetElement(self.m_root, "tcJigsawReward", WZUITableContainer)
	tcReward:cleanTable()

	local reward_ids = self.m_tFiveKeyReward.reward_ids1
	local reward_nums = self.m_tFiveKeyReward.reward_nums1
	local tTempData = self.m_tFiveKeyReward
	for i = 1, #reward_ids do
		local tabItem = GDatatab_item["id_".. reward_ids[i]]
		local itemInfo = {id = tabItem.id, name=tabItem.name,icon=tabItem.icon,lastTime=reward_nums[i],quality=tabItem.quality,basicInfo=CopyTable(tabItem), index = i}
		local bVisibleLimit = false
		local strLimit = "" 
		if tTempData.leftConfig then 
			itemInfo.leftConfig = tTempData.leftConfig[i]
			bVisibleLimit, strLimit = WndJoinReward:getLimitData(itemInfo.leftConfig.soldNum, itemInfo.leftConfig.limitNum, itemInfo.leftConfig.dailyLimit, itemInfo.leftConfig.dailyBuyNum)
		end
		if tTempData.chooseState then 
			itemInfo.chooseState = tTempData.chooseState[i]
		end
		if tTempData.pool then 
			itemInfo.pool = tTempData.pool
		end
		local nType = 17 
		if tTempData.type then 
			nType = tTempData.type
			itemInfo.rootNode = self.m_root
		end
		local celElement,tCell = CellGoodItem:createElement()
		if celElement and tCell then
			tCell:setCellGoodItem(itemInfo, nType)
			celElement:setTag(i-1)
			celElement:setScale(0.75)
			tcReward:setCellElement(celElement)
			if ProjConfig.LANGUAGE == "vn" then
				tTempData.chooseState = nil
			end
			if tTempData.chooseState then 
				tCell:setItemClickFun(self,self.onClickItem2)
			else
				tCell:setItemClickFun(self,self.onItemClick)
			end
			if bVisibleLimit then 
				tCell:_addNumLimit(strLimit)
			end
			if itemInfo.chooseState and itemInfo.chooseState == 1 then 
				tCell:setItemSelState(true)
			end
		end
	end

end

--@brief	点击物品弹出对应的tips
function WndMakeSnowman:onItemClick(tCell,tag,tData)
    if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData,false)
end

--@brief    点击奖励回调
function WndMakeSnowman:onClickItem2(tCell, tag, tData)
    WZLog("WndMakeSnowman:onClickItem2 ")
    if tData.chooseState and tData.chooseState == 0 then 
		local _, _, bIsSoldOut = WndJoinReward:getLimitData(tData.leftConfig.soldNum, tData.leftConfig.limitNum, tData.leftConfig.dailyLimit, tData.leftConfig.dailyBuyNum)
	    if bIsSoldOut then
	  	   	MsgBoxManager:showTipBox(string.format(LocalStrings.PLANETSEARCH_TEXT1[18], LocalStrings.CHESS_ACTIVITY_TEXT1[26], tData.basicInfo.name, tData.lastTime))
	  	   	return
	  	else
	  		self.m_tClickCell = tCell 
	  		local tTempData = {}
	  		local doType = 4
			tTempData.id = tData.index - 1
			tTempData.pool = tData.pool
	  		
			local stringData = json.encode(tTempData)
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, doType, stringData)
	   end
    elseif tData.chooseState and tData.chooseState == 1 then 
		self.m_tClickCell = tCell 
		local tTempData = {}
		local doType = 4
		tTempData.id = tData.index - 1
		tTempData.pool = tData.pool
			
		local stringData = json.encode(tTempData)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, doType, stringData)
		tCell:setItemSelState(false)
    end
end

--@brief 	选择奖励返回
function WndMakeSnowman:chooseReturn(tag, index, status)
	if self.m_root == nil then return end 

	local tTempData = self.m_tFiveKeyReward
	tTempData.chooseState[index] = status
	self.m_tClickCell:updateChooseStateData(status)
	if status == 0 then 
		self.m_tClickCell:setItemSelState(false)
	elseif status == 1 then 
		self.m_tClickCell:setItemSelState(true)
	end
end

--@brief 	点击编写棋谱按钮回调
function WndMakeSnowman:onClickPageDraw(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if CacheCenter:getRemainAmount() <= 0 then --背包已满提示
		MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
		return
	end

    if self.m_bOpenPageState then return end

	for i=1,#self.m_nGiftStatus do
		if self.m_nGiftStatus[i] ~= 1 then
			MsgBoxManager:showTipBox(LocalStrings.MAKE_SHOWMAN_TEXT1[22])
			return 
		end
	end

	self:setOpenPageState(true)

	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 6, "")
end

--@brief 	显示开启奖励
function WndMakeSnowman:showShootPageReward()
	self:setOpenPageState(false)
	self:_afterClosePageReward()
end

--@brief 	显示碎片
function WndMakeSnowman:showJigsaw()
	for i=1,#self.m_nGiftStatus do
		local imgJigsawShare = GetElement(self.m_root, "imgJigsawShare"..i, WZUIImage)
		if self.m_nGiftStatus[i] == 1 then
			imgJigsawShare:setGrayRender(false)
		else
			imgJigsawShare:setGrayRender(true)
		end
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief 	iphoneX适配
function WndMakeSnowman:_adaptIphoneX()
	if IsIphoneX() then
		GetElement(self.m_root, "btnOperate5", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.07,0.3))
	end
end




-------------------------------------私有方法模块End----------------------------------------


--------------------------------------语言适配Begin-----------------------------------------

function WndMakeSnowman:_adaptLanguage_vn(  )
	local txtUseTool1 = GetElement(self.m_root,"txtUseTool1",WZUILabelTTF)
	txtUseTool1:setScale(0.55)
	txtUseTool1:setDimensions(GlobalMethod:CCSize(200))
	local txtUseTool2 = GetElement(self.m_root,"txtUseTool2",WZUILabelTTF)
	txtUseTool2:setScale(0.55)
	txtUseTool2:setDimensions(GlobalMethod:CCSize(200))
	GetElement(self.m_root,"txtOperateBtn1",WZUILabelTTF):setScale(0.5)
	local txtJigsawTips = GetElement(self.m_root,"txtJigsawTips",WZUILabelTTF)
	txtJigsawTips:setScale(0.7)
	txtJigsawTips:setDimensions(GlobalMethod:CCSize(620,0))
	GetElement(self.m_root,"txtJigsawReward",WZUILabelTTF):setScale(0.8)
end

---------------------------------------语言适配End------------------------------------------
