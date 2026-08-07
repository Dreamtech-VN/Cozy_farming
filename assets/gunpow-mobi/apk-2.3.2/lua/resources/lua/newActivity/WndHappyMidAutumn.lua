--WndHappyMidAutumn.lua
--@brief	WndHappyMidAutumn的UI模块
--@date		2024/08/14
--@author	yrd
--@note		欢度中秋


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndHappyMidAutumn:onEnter(element)
	self.m_root = element

	g_bIsShowWndDressUp = false
	g_tTempItemForLaterShow = {}
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
	ProtocolProcessorFestivalActivity:regAll6()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
	GlobalGame:getGameEventDispathcer():Add(Independent_Activity.ActivityReddot, self.showRedDot, self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetRankResult,self._onRankResult,self)

	self:_initStaticText()
	self:_updateCoinNum()

	self:_adaptIphoneX()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndHappyMidAutumn:onExit(element)
	g_bIsShowWndDressUp = true
	g_tTempItemForLaterShow = {}
	CacheCenter:unregisterUpatePlayerItemObserver(self)
	ProtocolProcessorFestivalActivity:unregAll6()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
	GlobalGame:getGameEventDispathcer():Remove(Independent_Activity.ActivityReddot, self.showRedDot, self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetRankResult,self._onRankResult,self)

	self:_unInit()
	LoadNewActivityRes(false)
end

--@brief    onenter函数已执行
function WndHappyMidAutumn:onEnterTransitionDidFinish(element)
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7137, 7137)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(g_cityExtenInfo.activity7137, 1)
end

--@brief    点击关闭窗口按钮
function WndHappyMidAutumn:showInterface()
	LoadNewActivityRes(true)
	local wnd = WndHappyMidAutumn:createElement()
	WindowManager:addWindow(wnd, WndHappyMidAutumn, nil, nil, nil, true)
end

--@brief    点击关闭窗口按钮
function WndHappyMidAutumn:onClickClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    初始化静态文本
function WndHappyMidAutumn:_initStaticText()
	self:_showAnimal()

	GetElement(self.m_root,"ftbTips",WZUIFreeTextBox):setShowText(LocalStrings.HAPPY_MIDAUTUMN_TEXT1[11])
	GetElement(self.m_root,"txtAllServerRank",WZUILabelTTF):setText(LocalStrings.HAPPY_MIDAUTUMN_TEXT1[4])
	GetElement(self.m_root,"txtRankTitle1",WZUILabelTTF):setText(LocalStrings.HAPPY_MIDAUTUMN_TEXT1[6])
	GetElement(self.m_root,"txtRankTitle2",WZUILabelTTF):setText(LocalStrings.HAPPY_MIDAUTUMN_TEXT1[7])
	GetElement(self.m_root,"txtRankTitle3",WZUILabelTTF):setText(LocalStrings.HAPPY_MIDAUTUMN_TEXT1[8])
	GetElement(self.m_root,"txtCheckRank",WZUILabelTTF):setText(LocalStrings.HAPPY_MIDAUTUMN_TEXT1[5])

	GetElement(self.m_root,"txtU2Title",WZUILabelTTF):setText(LocalStrings.HAPPY_MIDAUTUMN_TEXT1[10])
end

--@brief    点击规则按钮
function WndHappyMidAutumn:onClickRule(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSingleMapDesc:showInterface(LocalStrings.HAPPY_MIDAUTUMN_TEXT2)
end

--@brief 	设置待机特效
function WndHappyMidAutumn:_showAnimal()
	local spinePath = "activity/hd_pic_hdzq_vx"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then
		for i=1,5 do
			local btnLantern = GetElement(self.m_root, "btnLantern"..i, WZUIButton)
			local spineLanternGet = GetElement(btnLantern, "spineLanternGet", WZUISpine)
			if spineLanternGet then 
				spineLanternGet:setFileJson(spinePath .. ".json")
				spineLanternGet:setFileAtlas(spinePath .. ".atlas")
				spineLanternGet:play("animation", true)
			end
		end
	else
		local _sIndex = "hd_pic_hdzq_vx"
		local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
		if downloadInfo then 
			DownloadManager:addDownloadTask(7137, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndHappyMidAutumn)
		end
	end

	local spinePath = "activity/hd_pic_baoji"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then
		local spineCriticalHit = GetElement(self.m_root, "spineCriticalHit", WZUISpine)
		if spineCriticalHit then 
			spineCriticalHit:setFileJson(spinePath .. ".json")
			spineCriticalHit:setFileAtlas(spinePath .. ".atlas")
		end
	else
		local _sIndex = "hd_pic_baoji"
		local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
		if downloadInfo then 
			DownloadManager:addDownloadTask(71371, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndHappyMidAutumn)
		end
	end

	local spinePath = "activity/hd_pic_nianhuodazuoz_"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then
		local spineBG = GetElement(self.m_root, "spineBG", WZUISpine)
		if spineBG then 
			spineBG:setFileJson(spinePath .. ".json")
			spineBG:setFileAtlas(spinePath .. ".atlas")
			spineBG:play("wait1", true)
		end
		local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
		if spineOpen then 
			spineOpen:setFileJson(spinePath .. ".json")
			spineOpen:setFileAtlas(spinePath .. ".atlas")
			self:_playAni(1,true)
		end
		local spineCopy = GetElement(self.m_root, "spineCopy", WZUISpine)
		if spineCopy then 
			spineCopy:setFileJson(spinePath .. ".json")
			spineCopy:setFileAtlas(spinePath .. ".atlas")
			self:_playAnotherAni(0)
		end
	else
		local _sIndex = "hd_pic_nianhuodazuoz_"
		local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
		if downloadInfo then 
			DownloadManager:addDownloadTask(71372, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndHappyMidAutumn)
		end
	end
end

function WndHappyMidAutumn:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndHappyMidAutumn:downloadEffectCallback",taskId,extraData,failed)
    self:_showAnimal()
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndHappyMidAutumn:_playAni(aniIndex, bLoop)
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	aniIndex = aniIndex or 0
	if aniIndex == 0 then
		spineOpen:setVisible(false)
		return
	end
	spineOpen:setVisible(true)
	bLoop = bLoop == true and true or false

	if spineOpen then 
		spineOpen:play(self.m_tBallAniName[aniIndex], bLoop)
	end
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndHappyMidAutumn:_playAnotherAni(aniIndex, bLoop)
	local spineCopy = GetElement(self.m_root, "spineCopy", WZUISpine)
	aniIndex = aniIndex or 0
	if aniIndex == 0 then
		spineCopy:setVisible(false)
		return
	end
	spineCopy:setVisible(true)
	bLoop = bLoop == true and true or false

	if spineCopy then 
		spineCopy:play(self.m_tBallAniName[aniIndex], bLoop)
	end
end

--@brief 	显示开启动画
function WndHappyMidAutumn:showOpenAction()
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	local spinePath1 = "activity/hd_pic_nianhuodazuoz_"
	local existSpine1 = CheckEffectFile(spinePath1)
	if existSpine1 then
		local aniIndex = self.m_nDrawNumType + 1 
		self:_playAnotherAni(aniIndex, false)
		spineOpen:enableSchedule("showShootBefore", 0)
	else
		self:showShootReward()
	end
end

--@brief 	显示开启奖励 处理抽奖时人物人物会闪一下问题
function WndHappyMidAutumn:showShootBefore()
	self:_playAni(0)
	local nSeconds = 1.5
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	spineOpen:disableSchedule()
	spineOpen:enableSchedule("showShootBefore2", nSeconds)
end


--@brief 	显示开启奖励 处理抽奖时人物人物会闪一下问题
function WndHappyMidAutumn:showShootBefore2()
	self:_playAni(1, true)
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	spineOpen:disableSchedule()
	spineOpen:enableSchedule("showOpenAction2", 0)
end

--@brief 	显示开启动画
function WndHappyMidAutumn:showOpenAction2()
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	spineOpen:disableSchedule()
	self:_playAnotherAni(0)

	local spineCriticalHit = GetElement(self.m_root, "spineCriticalHit", WZUISpine)
	local spinePath2 = "activity/hd_pic_baoji"
	local existSpine2 = CheckEffectFile(spinePath2)
	if existSpine2 then
		if self.m_nDrawNumType == 1 then
			spineCriticalHit:setRelativePosition(GlobalMethod:ccp(0.5,0.64))
		elseif self.m_nDrawNumType == 2 then
			spineCriticalHit:setRelativePosition(GlobalMethod:ccp(0.5,0.64))
		end
		if self.m_nMaxGiftScore == 2 then
			spineCriticalHit:play("baiji_1", false)
		elseif self.m_nMaxGiftScore == 100 then
			spineCriticalHit:play("baiji_2", false)
		else
			spineCriticalHit:play("", false)
		end
		local nSeconds = 0.5
		spineCriticalHit:enableSchedule("showShootReward", nSeconds)
	else
		self:showShootReward()
	end
end

--@brief 	显示开启奖励
function WndHappyMidAutumn:showShootReward()
	local spineCriticalHit = GetElement(self.m_root, "spineCriticalHit", WZUISpine)
	spineCriticalHit:disableSchedule()

	local strContent = ""
	if self.m_tOpenResult.addExp and self.m_tOpenResult.addExp > 0 then 
		strContent = strContent .. LocalStrings.HAPPY_MIDAUTUMN_TEXT1[8] .. "+" .. self.m_tOpenResult.addExp .. "    "
	end
	if strContent ~= "" then 
		MsgBoxManager:showTipBox(strContent, nil, nil, nil, nil, nil, nil, nil, nil, GlobalMethod:ccp(0.5, 0.77))
	end

	self:setOpenState(false)
	self:_afterCloseReward()
end

--@brief 	更新许愿币的数量
function WndHappyMidAutumn:_updateCoinNum()
	local sFormat = [[<I Z="0.4" P="1">%s</I><T C="255,236,193" S="20" P="1" SC="163,74,20" SS="4" SE="0">%d</T>]]
	local basicData = GDatatab_item["id_" .. self.m_nCoinId]
	local nNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	GetElement(self.m_root, "ftbOwnCoin", WZUIFreeTextBox):setShowText(string.format(sFormat, basicData.icon, nNum))
end

--@brief 	初始化活动时间
function WndHappyMidAutumn:_initActivityTime()
	local tStartDate = os.date("*t", self.m_nStartTime)
	local tEndDate = os.date("*t", self.m_nEndTime)
	local strFormat = [[<T C="255,236,193" S="16" P="1" SC="132,66,29" SS="4" SE="1">%s</T><T C="255,255,255" S="16" P="1" SC="132,66,29" SS="4" SE="1">%02d.%02d %02d:%02d-%02d.%02d %02d:%02d</T>]]
	local sDuration = string.format(strFormat, LocalStrings.PEOPLE_SHOP_TEXT1, tStartDate.month, tStartDate.day, tStartDate.hour, tStartDate.min, tEndDate.month, tEndDate.day, tEndDate.hour, tEndDate.min)
	GetElement(self.m_root, "ftbActivityTime", WZUIFreeTextBox):setShowText(sDuration)
end

--@brief 	更新界面
function WndHappyMidAutumn:updateUI()
	self:updateLantern()
	self:updatePlate()
end

--@brief 	全服里程奖励
function WndHappyMidAutumn:updateLantern()
	--全服里程
	local strFormat = [[<T C="255,236,193" S="18" P="1" SC="132,66,29" SS="4" SE="1">%s</T><T C="255,255,255" S="18" P="1" SC="132,66,29" SS="4" SE="1">%s</T>]]
	GetElement(self.m_root,"ftbGlobalScore",WZUIFreeTextBox):setShowText(string.format(strFormat, LocalStrings.HAPPY_MIDAUTUMN_TEXT1[9]..":", self.m_nGlobalScore))
	local curProgress = 5
	for i=1,5 do
		if self.m_tGlobalStatus[i] == -1 then
			curProgress = i
			break
		end
	end
	for i=1,5 do
		local conLantern = GetElement(self.m_root,"conLantern"..i,WZUIContainer)
		local ftbLantern = GetElement(conLantern,"ftbLantern",WZUIFreeTextBox)
		if curProgress >= i then
			local strFormat = [[<T C="127,70,26" S="16" P="1">%s%s</T>]]
			ftbLantern:setShowText(string.format(strFormat, self.m_tSocre2.score[i], LocalStrings.HAPPY_MIDAUTUMN_TEXT1[9]))
		else
			local strFormat = [[<I Z="0.24">ui/common/common_icon_suo8.png</I><T C="127,70,26" S="16" P="1">%s%s</T>]]
			ftbLantern:setShowText(string.format(strFormat, self.m_tSocre2.score[i], LocalStrings.HAPPY_MIDAUTUMN_TEXT1[9]))
		end

		local btnLantern = GetElement(self.m_root,"btnLantern"..i,WZUIButton)

		local conLanternItem = GetElement(btnLantern,"conLanternItem",WZUIContainer)
		conLanternItem:removeAllChildrenWithCleanup(true)
		local celElement,tCell = CellGoodItem:createElement()
		celElement:setTag(i)
		tCell:setCellGoodLocalId(self.m_tSocre2.reward[i][1][1], self.m_tSocre2.reward[i][1][2], 15)
		tCell:setItemCount(self.m_tSocre2.reward[i][1][2])
		celElement:setScale(0.8)
		conLanternItem:addChild(celElement)

		local imgLanternBg = GetElement(btnLantern,"imgLanternBg",WZUIImage)
		local imgLanternGet = GetElement(btnLantern,"imgLanternGet",WZUIImage)
		local spineLanternGet = GetElement(btnLantern,"spineLanternGet",WZUISpine)
		if self.m_tGlobalStatus[i] == -1 then
			imgLanternBg:setGrayRender(true)
			tCell:setGrayRender(true)
			imgLanternGet:setVisible(false)
			spineLanternGet:setVisible(false)
		elseif self.m_tGlobalStatus[i] == 0 then
			imgLanternBg:setGrayRender(false)
			tCell:setGrayRender(false)
			imgLanternGet:setVisible(false)
			spineLanternGet:setVisible(true)
		elseif self.m_tGlobalStatus[i] == 1 then
			imgLanternBg:setGrayRender(false)
			tCell:setGrayRender(false)
			imgLanternGet:setVisible(true)
			spineLanternGet:setVisible(false)
		end
	end

	for i=1,5 do
		GetElement(self.m_root,"imgProgress"..i,WZUIImage):setGrayRender(self.m_tGlobalStatus[i] == -1)
	end
	local lineProgress = {0,10,30,67,100}
	local pgrLine = GetElement(self.m_root,"pgrLine_WndHappyMidAutumn", WZUIProgress)
	if pgrLine then 
		for i=1,5 do
			if self.m_tGlobalStatus[i] ~= -1 then 
				pgrLine:setPercentage(lineProgress[i])
			end
		end
	end
end

--@brief 	个人里程奖励
function WndHappyMidAutumn:updatePlate()
	local curProgress = 5
	for i=1,5 do
		if self.m_tScoreRewardStatus[i] == -1 then
			curProgress = i
			break
		end
	end
	for i=1,5 do
		local conPlateMile = GetElement(self.m_root,"conPlateMile"..i,WZUIContainer)
		local ftbPlateMile = GetElement(conPlateMile,"ftbPlateMile",WZUIFreeTextBox)
		if curProgress >= i then
			local strFormat = [[<T C="229,105,22" S="16" P="1">%s</T><T C="127,70,26" S="16" P="1">/%s%s</T>]]
			local nScore = math.min(self.m_nScore, self.m_tSocre1.score[i])
			ftbPlateMile:setShowText(string.format(strFormat, nScore, self.m_tSocre1.score[i], LocalStrings.HAPPY_MIDAUTUMN_TEXT1[8]))
		else
			local strFormat = [[<I Z="0.24">ui/common/common_icon_suo8.png</I><T C="127,70,26" S="16" P="1">%s%s</T>]]
			ftbPlateMile:setShowText(string.format(strFormat, self.m_tSocre1.score[i], LocalStrings.HAPPY_MIDAUTUMN_TEXT1[8]))
		end

		self:updatePlateItem(i)
	end
end

--@brief 	更新个人里程盘子上的物品
function WndHappyMidAutumn:updatePlateItem(index)
	local conPlate = GetElement(self.m_root,"conPlate"..index,WZUIContainer)
	local btnAdd = GetElement(conPlate,"btnAdd",WZUIButton)
	local conPlateItem = GetElement(conPlate,"conPlateItem",WZUIContainer)
	local itemIdx = self.m_tScoreRewards[index]
	local imgPlateGet = GetElement(conPlate,"imgPlateGet",WZUIImage)
	local imgPlateRedDot = GetElement(conPlate,"imgPlateRedDot",WZUIImage)
	if itemIdx == -1 then
		btnAdd:setVisible(true)

		conPlateItem:setVisible(false)

		imgPlateGet:setVisible(false)
		imgPlateRedDot:setVisible(false)
	else
		btnAdd:setVisible(false)

		conPlateItem:setVisible(true)
		conPlateItem:removeAllChildrenWithCleanup(true)
		local celElement,tCell = CellGoodItem:createElement()
		celElement:setTag(index)
		tCell:setCellGoodLocalId(self.m_tSocre1.reward[index][itemIdx+1][1], self.m_tSocre1.reward[index][itemIdx+1][2], 17)
		tCell:setItemClickFun(self,self.onClickPlateItem)
		conPlateItem:addChild(celElement)

		imgPlateGet:setVisible(self.m_tScoreRewardStatus[index] == 1)
		imgPlateRedDot:setVisible(self.m_tScoreRewardStatus[index] == 0)
	end
end

--@brief 	点击个人里程奖励按钮回调
function WndHappyMidAutumn:onClickPlateItem(tCell, tag, tData)
	if self.m_tScoreRewardStatus[tag] == -1 then
		self:onClickAdd(tag)
	elseif self.m_tScoreRewardStatus[tag] == 0 then
		local tTempData = {}
		tTempData.id = tag - 1
		local stringData = json.encode(tTempData)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 6, stringData)
	elseif self.m_tScoreRewardStatus[tag] == 1 then
	    WndItemInfo:onCloseClick()
		WndItemInfo:showInfo(tCell.m_root, self.m_root, 1, tData, false)
	end
end

--@brief 	点击添加个人里程奖励按钮回调
function WndHappyMidAutumn:onClickAdd(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nTag
	if type(element) == "number" then
		nTag = element
	else
		nTag = element:getTag()
	end
	self.m_nCurPoolIndex = nTag

	GetElement(self.m_root,"conUI2",WZUIContainer):setVisible(true)

    self.m_tCurPoolItemObj = {}
	local tcU2Reward = GetElement(self.m_root,"tcU2Reward",WZUITableContainer)
    tcU2Reward:cleanTable()
    local tItemList = self.m_tSocre1.reward[self.m_nCurPoolIndex]
    local itemIdx = self.m_tScoreRewards[self.m_nCurPoolIndex]
    for i = 1, #tItemList do

		local tabItem = GDatatab_item["id_".. tItemList[i][1]]
		local itemInfo = {id = tabItem.id, name=tabItem.name,icon=tabItem.icon,lastTime=tItemList[i][2],quality=tabItem.quality,basicInfo=CopyTable(tabItem), index = i}
		itemInfo.rootNode = self.m_root

        local celElement,tCell = CellGoodItem:createElement()
        celElement:setTag(i - 1)
        tCell:setCellGoodItem(itemInfo, 31)
        tCell:setItemClickFun(self, self.onClickChooseItem)
        tcU2Reward:setCellElement(celElement)
		tCell:setItemSelState(itemIdx == i-1)
		if self.m_tSocre1.soldNum[self.m_nCurPoolIndex][i] <= self.m_tSocre1.limitConfig[self.m_nCurPoolIndex][i] then --限量
			local strFormat = [[%s:%d/%d]]
			tCell:_addNumLimit(string.format(strFormat, LocalStrings.SHOP_LIMIT_TITLE, self.m_tSocre1.soldNum[self.m_nCurPoolIndex][i], self.m_tSocre1.limitConfig[self.m_nCurPoolIndex][i]))
		end
		table.insert(self.m_tCurPoolItemObj, tCell)
    end
end

--@brief 	点击选择个人里程奖池里的物品回调
function WndHappyMidAutumn:onClickChooseItem(tCell, tag, tData)
	local tTempData = {}
	tTempData.pool = self.m_nCurPoolIndex - 1
	tTempData.id = tag
	local stringData = json.encode(tTempData)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 4, stringData)
end

--@brief 	更新个人奖池选中物品
function WndHappyMidAutumn:updateCurPoolItem()
    local itemIdx = self.m_tScoreRewards[self.m_nCurPoolIndex]
	for i=1,#self.m_tCurPoolItemObj do
		self.m_tCurPoolItemObj[i]:setItemSelState(itemIdx == i-1)
	end

	self:updatePlateItem(self.m_nCurPoolIndex)
end

--@brief 	点击积分宝箱回调
function WndHappyMidAutumn:onClickLantern(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	
	local tData = self.m_tSocre2.reward[nTag]
	local data = {}
	data.scale = 0.4
	local reward_id = {}
	local reward_num = {}
	for i = 1, #tData do
		table.insert(reward_id,  tData[i][1])
		table.insert(reward_num, tData[i][2])
	end
	data.cur_value = self.m_nGlobalScore
	data.totle_value = self.m_tSocre2.score[nTag]
	data.rewardIds = reward_id
	data.rewardNums = reward_num
	local conUI1 = GetElement(self.m_root, "conUI1", WZUIContainer)
	WndNewTipsReward:showInterface(conUI1, element, data, false, GlobalMethod:ccp(0.5, 0.5))

	if self.m_tGlobalStatus[nTag] == 0 then 
		--背包已满提示
		if CacheCenter:getRemainAmount() <= 0 then
			MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
			return
		end
		local tData = {}
		tData.id = nTag - 1
		local strData = json.encode(tData)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 5, strData)
	end
end

--@brief 	红点
function WndHappyMidAutumn:showRedDot()
	if self.m_root == nil then return end 

end


--@brief 	点击选择数量按钮回调
function WndHappyMidAutumn:onClickSwitchNum(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	self.m_nDrawNumType = self.m_nDrawNumType % 2 + 1

	self:updateWishingBtn()
end

--@brief 	更新许愿按钮
function WndHappyMidAutumn:updateWishingBtn()
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
			txtUseTool:setText(LocalStrings.HAPPY_MIDAUTUMN_TEXT1[2])
		elseif self.m_nDrawNumType == 2 then
			if nTempTimes == 0 then
				txtUseTool:setText(string.format(LocalStrings.HAPPY_MIDAUTUMN_TEXT1[3], self.m_tDrawNumList[self.m_nDrawNumType]))
			else
				txtUseTool:setText(string.format(LocalStrings.HAPPY_MIDAUTUMN_TEXT1[3], nTimes))
			end
		end
	else
		txtUseTool:setText(string.format(LocalStrings.HAPPY_MIDAUTUMN_TEXT1[3], nTimes))
	end
end

--@brief 	点击许愿按钮回调
function WndHappyMidAutumn:onClickUseTool(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	for i=1,5 do
		if self.m_tScoreRewards[i] == -1 then
			MsgBoxManager:showTipBox(LocalStrings.HAPPY_MIDAUTUMN_TEXT1[12])
			return
		end
	end

	--背包已满提示
	if CacheCenter:getRemainAmount() <= 0 then
		MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
		return
	end
	if self.m_bOpenState then return end 

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
	local stringData = json.encode(tData)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 3, stringData)
end

--@brief 	前往小推车购买
function WndHappyMidAutumn:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        -- WndActivityPropsGift:showInterface(self.m_nCoinId)
        WndApartmentAct:showInterface()
    end
end

--@brief    点击关闭个人自选界面按钮
function WndHappyMidAutumn:onClickClose2(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	GetElement(self.m_root,"conUI2",WZUIContainer):setVisible(false)
end

--@brief    点击排行榜按钮
function WndHappyMidAutumn:onClickRank(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local otherData = {}
	otherData.type = 1
	otherData.strRankTitleName = LocalStrings.HAPPY_MIDAUTUMN_TEXT1[4]
	otherData.strChangeTitle = LocalStrings.HAPPY_MIDAUTUMN_TEXT1[8]
	otherData.strScoreTitle = LocalStrings.HAPPY_MIDAUTUMN_TEXT1[13] .. ":"
	WndShopRank:showInterface(90, self.m_nActivityId, nil, nil, otherData) 
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


--@brief 	iphoneX适配
function WndHappyMidAutumn:_adaptIphoneX()
	if IsIphoneX() then
		-- GetElement(self.m_root, "conCoin", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.262,0.047))
		-- GetElement(self.m_root, "ftbActivityTime", WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.262,0.093))
	end
end



-------------------------------------私有方法模块End----------------------------------------

--@brief    语言适配
function WndHappyMidAutumn:_adaptLanguage_vn()

	GetElement(self.m_root,"txtRankTitle3",WZUILabelTTF):setScale(0.7)

	for i=1,5 do
		local conLantern = GetElement(self.m_root,"conLantern"..i,WZUIContainer)
		local ftbLantern = GetElement(conLantern,"ftbLantern",WZUIFreeTextBox)
		ftbLantern:setScale(0.7)
	end

	for i=1,5 do
		local conPlateMile = GetElement(self.m_root,"conPlateMile"..i,WZUIContainer)
		local ftbPlateMile = GetElement(conPlateMile,"ftbPlateMile",WZUIFreeTextBox)
		ftbPlateMile:setScale(0.8)
	end

	local ftbTips = GetElement(self.m_root,"ftbTips",WZUIFreeTextBox)
	ftbTips:setScale(0.6)
	ftbTips:setRelativePosition(GlobalMethod:ccp(0.51,0.52))
	ftbTips:setMaxWidth(300)

	GetElement(self.m_root, "ftbActivityTime", WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.242,0.067))
end
