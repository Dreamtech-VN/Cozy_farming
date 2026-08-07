--WndClimbTree.lua
--@brief	WndClimbTree的UI模块
--@date		2023/05/04
--@author	XTX
--@note		爬藤大赛


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndClimbTree:onEnter(element)
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
function WndClimbTree:onExit(element)
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
function WndClimbTree:onEnterTransitionDidFinish(element)
    WZLog("WndClimbTree:onEnterTransitionDidFinish")
    self.m_nScreenSize = CCEGLView:sharedOpenGLView():getFrameSize()
    if self.m_conScrollMap == nil then 
        self.m_conScrollMap = GetElement(self.m_root,"conScrollMap_WndClimbTree",WZUIContainer)
    end
    
    local resolutionSize = CCEGLView:sharedOpenGLView():getDesignResolutionSize()
	local screenSize = CCEGLView:sharedOpenGLView():getFrameSize()
	local nScaleX = self.m_nScreenSize.width / resolutionSize.width
    local nScaleY = self.m_nScreenSize.height / resolutionSize.height
    local nScale = nScaleY > nScaleX and nScaleX or nScaleY
    local width = math.max(resolutionSize.width * nScale, resolutionSize.width)
    local x = width/2
    
    self.m_nMapStartPtX = resolutionSize.width/2
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7075, 7075)
end

--@brief    关闭窗口
function WndClimbTree:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    --如果是自动弹出的活动界面
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮回调
function WndClimbTree:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 
    WndSingleMapDesc:showInterface1(LocalStrings.CLIMBTREE_TEXT2) 
end

--@brief 	点击目标按钮回调
function WndClimbTree:onClickTask(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if nTag == 1 then --任务
		CellNewYearTask:showInterface(26, self.m_nActivityId)
	elseif nTag == 2 then --排行榜
		WndShopRank:showInterface(43, self.m_nActivityId) 
	elseif nTag == 3 then --和平大使
		GetElement(self.m_root, "conLvReward_WndClimbTree", WZUIContainer):setVisible(true)
		self:setOpenState(true)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 5, "")
	elseif nTag == 4 then --奖励预览
		local otherData = {}
		otherData.bIsUseOriginSize = true
		otherData.imgBg = "ui/specialBg/frame_tc_ptds_x.png"
		otherData.imgBgPt = GlobalMethod:ccp(0.5, 0.54)
		otherData.img9SecBg = "ui/common/frame_lieb_09.png"
		otherData.imgClose = "ui/common/common_top_btn_guanbi_l.png"
		otherData.titleColor = GlobalMethod:ccc3(255,255,255)
		otherData.titleStroke = false
		otherData.changeRes = 2
		WndJoinReward:showInterface("", self.m_tBigRewardList[1], self.m_tBigRewardList[2], LocalStrings.TREASURE_TEXT7, true, 2, otherData)
	end
end

--@brief 	点击开启按钮回调
function WndClimbTree:onClickFive(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
--	do WndClimbTree:_onGetOtherData(self.m_nActivityId, 3, 1, [[{"nItemNums":[100],"nItems":[1],"shopItemIds":[70,1,2],"shopItemNums":[7000,10000,200000],"itemIds":[],"num":20,"count":0,"itemNums":[],"fItemIds":[2],"fItemNums":[20000],"sItemIds":[3],"score":40,"sItemNums":[30000]}]]) return end
	--背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
    if self.m_bOpenState then return end 

    self.m_nLastClimbMetre = self.m_nClimbMetre
	local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local nTempTimes = nArrowNum
	local nTimes = nTag
	local freeCount = 0
	if self.m_nSaveBird == 0 then 
		freeCount = self.m_nCount > 0 and 1 or 0 
	end

	if self.m_nSaveBird == 0 or (self.m_nSaveBird == 1 and self.m_nSaveBirdCostNum ~= 0) then 
		if nTag == 5 then 
			nTag = self.m_nMaxLotteryCount 
			nTimes = (nTempTimes + freeCount) >= self.m_nMaxLotteryCount and self.m_nMaxLotteryCount or nTempTimes > 0 and (nTempTimes + freeCount) or self.m_nMaxLotteryCount 
		end
		local nCostNum = nTimes
		if nCostNum - freeCount > nArrowNum then 
			local basicData = GDatatab_item["id_" .. self.m_nCoinId]
			MsgBoxManager:showConfirmBox(string.format(LocalStrings.WATERCOUNTRY_TEXT4, basicData.name), self, self.goToBuy)
			return 
		end
	end

	if self.m_nSaveBird == 1 then 
		nTag = 1
	end

    local tData = {}
	tData.times = nTag

	local stringData = json.encode(tData)

	self:setOpenState(true)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 3, stringData)
end

--@brief 	前往小推车购买
function WndClimbTree:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

--@brief 	关闭捕鼠奖励界面
function WndClimbTree:onCloseTip(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	GetElement(self.m_root, "conLvReward_WndClimbTree", WZUIContainer):setVisible(false)
	local bIsReddot = false 
	for i = 1, #self.m_tPeaceConfig do
		if self.m_tPeaceConfig[i].status == 1 then 
			bIsReddot = true 
			break 
		end
	end
	GlobalGame.g_tRedPointTypeList[17075] = bIsReddot 
	self:showRedDot()
end

--@brief 	点击查看攀爬礼包奖励回调
function WndClimbTree:onClickClimbGift(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_nClimbTimes >= self.m_tContent.giftConfig[1] then 
		self:setOpenState(true)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 4, "")
	else
		local data = {}
		data.scale = 0.4
	    local reward_id = {}
	    local reward_num = {}
	    for i = 1, #self.m_tTimeGiftReward do
	        table.insert(reward_id,  self.m_tTimeGiftReward[i][1])
	        table.insert(reward_num, self.m_tTimeGiftReward[i][2])
	    end
	   
	    data.title = string.format(LocalStrings.CLIMBTREE_TEXT1[16], self.m_nClimbTimes, self.m_tContent.giftConfig[1])
	    data.titleFontSize = 18
	    data.rewardIds = reward_id
	    data.rewardNums = reward_num
	    WndNewTipsReward:showInterface(self.m_root, element, data, true, GlobalMethod:ccp(0.61, 0.3))
	end
end

--@brief 	点击小鸟回调
function WndClimbTree:onClickBird(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	local birdY = nTag * self.m_tContent.birdConfig[1]
	if birdY > self.m_nClimbMetre or (birdY == self.m_nClimbMetre and self.m_nSaveBird == 1) then 
		MsgBoxManager:showTipBox(LocalStrings.CLIMBTREE_TEXT1[17])
	else
		MsgBoxManager:showTipBox(LocalStrings.CLIMBTREE_TEXT1[20])
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndClimbTree:_update()
	-- body
	self:_setFreeBtnText()
	self:showRedDot()
	self:_initActivityTime()
    self:_updateLightNum()
end

--@brief 	初始化静态文本
function WndClimbTree:_initStaticText()

	GetElement(self.m_root, "txtBtnTask1_WndClimbTree", WZUILabelTTF):setText(LocalStrings.CLIMBTREE_TEXT1[3])
	GetElement(self.m_root, "txtBtnTask2_WndClimbTree", WZUILabelTTF):setText(LocalStrings.CLIMBTREE_TEXT1[2])
	GetElement(self.m_root, "txtBtnTask3_WndClimbTree", WZUILabelTTF):setText(LocalStrings.CLIMBTREE_TEXT1[4])
	GetElement(self.m_root, "txtBtnTask4_WndClimbTree", WZUILabelTTF):setText(LocalStrings.TREASURE_TEXT7)
	GetElement(self.m_root, "txtLvRewardT_WndClimbTree", WZUILabelTTF):setText(LocalStrings.CLIMBTREE_TEXT1[13])
	
	self:_setBallAni()
end

--@brief 	红点
function WndClimbTree:showRedDot()
	-- body
	if self.m_root == nil then return end 

	local imgTaskRedDot = GetElement(self.m_root, "imgTaskRedDot_WndClimbTree", WZUIImage)
	local imgLibraryRedDot = GetElement(self.m_root, "imgLibraryRedDot_WndClimbTree", WZUIImage)

	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[117075] or GlobalGame.g_tRedPointTypeList[127075]) then 
		imgTaskRedDot:setVisible(true)
	else
		imgTaskRedDot:setVisible(false)
	end

	if GlobalGame.g_tRedPointTypeList and GlobalGame.g_tRedPointTypeList[17075] then 
		imgLibraryRedDot:setVisible(true)
	else
		imgLibraryRedDot:setVisible(false)
	end
end

--@brief 	更新异火的数量
function WndClimbTree:_updateLightNum()
	-- body
	local ftxtLightNum = GetElement(self.m_root, "ftxtLightNum_WndClimbTree", WZUIFreeTextBox)
	local sFormat = [[<I Z="0.5" P="1">%s</I><T C="255,236,193" S="20" P="1" SC="132,66,29" SS="4" SE="0">%d</T>]]
	if ftxtLightNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
		ftxtLightNum:setShowText(string.format(sFormat, basicData.icon, nLightNum))
	end
end

--@brief 	初始化活动时间
function WndClimbTree:_initActivityTime()
	-- body
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_WndClimbTree", WZUILabelTTF)
    if txtActivityTime then 
    	txtActivityTime:setText(LocalStrings.ACTIVITY_TIME_KEY .. ":" .. needDay_str)
    end
end

--@brief 	显示开启动画
function WndClimbTree:showOpenAction()
	-- body
	--创建选中特效
	local conOpenAct = GetElement(self.m_root, "conOpenAct_WndClimbTree", WZUIContainer)

	if conOpenAct then 
		self:_setBowlingPlayAni(2, true)
		conOpenAct:enableSchedule("showShootReward", 0.6)
	end
end

--@brief 	显示开启奖励
function WndClimbTree:showShootReward()
	-- body
	local conOpenAct = GetElement(self.m_root, "conOpenAct_WndClimbTree", WZUIContainer)
	conOpenAct:disableSchedule()
	self:_setBowlingPlayAni(1, true)

	local strContent = ""
	if self.m_tOpenResult.addExp and self.m_tOpenResult.addExp > 0 then 
		strContent = strContent .. LocalStrings.CLIMBTREE_TEXT1[18] .. "+" .. self.m_tOpenResult.addExp .. "    "  
	end
	if self.m_tOpenResult.addMetre and self.m_tOpenResult.addMetre > 0 then 
		local strTemp = string.format(LocalStrings.CLIMBTREE_TEXT1[19], self.m_tOpenResult.addMetre)
		strContent = strContent ..  strTemp
	end

	if strContent ~= "" then 
		MsgBoxManager:showTipBox(strContent, nil, nil, nil, nil, nil, nil, nil, nil, GlobalMethod:ccp(0.5, 0.77))
	end

	self:setOpenState(false)
	self:_afterCloseReward()

	self:_toPlayerPso()
end

--@brief 	iphoneX适配
function WndClimbTree:_adaptIphoneX()
	if IsIphoneX() then
		GetElement(self.m_root, "conLeftMenu_WndClimbTree", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.076,0.283757))
	end
end

--@brief 	设置免费丢
function WndClimbTree:_setFreeBtnText()
	local txtBtnOpenOne = GetElement(self.m_root, "txtBtnOpenOne_WndClimbTree", WZUILabelTTF)
	local txtBtnOpenFive = GetElement(self.m_root, "txtBtnOpenFive_WndClimbTree", WZUILabelTTF)
	local btnOpenOne = GetElement(self.m_root, "btnOpenOne_WndClimbTree", WZUIButton)
	local btnOpenFive = GetElement(self.m_root, "btnOpenFive_WndClimbTree", WZUIButton)

	local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local freeTimes = 0 
	local nTempTimes = nLightNum
	local nTimes = 0
	local nTimesBird = 0 
	if self.m_nSaveBird == 0 then 
		btnOpenOne:setVisible(true)
		btnOpenFive:setRelativePosition(GlobalMethod:ccp(0.7,0.07))
		btnOpenFive:setVisible(true)
		if self.m_nCount > 0 then 
			freeTimes = 1
			txtBtnOpenOne:setText(LocalStrings.CLIMBTREE_TEXT1[6])
		else
			txtBtnOpenOne:setText(string.format(LocalStrings.CLIMBTREE_TEXT1[5], 1))
		end
		nTimesBird = math.ceil((self.m_tContent.birdConfig[1] - self.m_nBirdMetre)/self.m_tContent.expConfig[1])
	elseif self.m_nSaveBird == 1 then 
		btnOpenOne:setVisible(false)
		btnOpenFive:setVisible(true)
		btnOpenFive:setRelativePosition(GlobalMethod:ccp(0.5,0.07))
		txtBtnOpenFive:setText(LocalStrings.CLIMBTREE_TEXT1[21])
	end
	nTimes = (nTempTimes + freeTimes) >= self.m_nMaxLotteryCount and self.m_nMaxLotteryCount or nTempTimes > 0 and (nTempTimes + freeTimes) or self.m_nMaxLotteryCount 
	if self.m_nSaveBird == 0 then 
		nTimes = math.min(nTimes, nTimesBird)
		txtBtnOpenFive:setText(string.format(LocalStrings.CLIMBTREE_TEXT1[5], nTimes))
	end

	local txtBoxGift = GetElement(self.m_root, "txtBoxGift_WndClimbTree", WZUILabelTTF)
	local txtGiftNum = GetElement(self.m_root, "txtGiftNum_WndClimbTree", WZUILabelTTF)
	local imgGiftRed = GetElement(self.m_root, "imgGiftRed_WndClimbTree", WZUIImage)
	txtBoxGift:setText(string.format(LocalStrings.CLIMBTREE_TEXT1[16], self.m_nClimbTimes, self.m_tContent.giftConfig[1]))
	txtGiftNum:setText(math.floor(self.m_nClimbTimes/self.m_tContent.giftConfig[1]))
	local spineGift = GetElement(self.m_root, "spineGift_WndClimbTree", WZUISpine)
	if self.m_nClimbTimes >= self.m_tContent.giftConfig[1] and not spineGift:isVisible() then 
		spineGift:setVisible(true)
		imgGiftRed:setVisible(true)
	elseif self.m_nClimbTimes < self.m_tContent.giftConfig[1] and spineGift:isVisible() then 
		if imgGiftRed:isVisible() then 
			imgGiftRed:setVisible(false)
		end
		if spineGift:isVisible() then 
			spineGift:setVisible(false)
		end
	end
end

--@brief 	设置待机特效
function WndClimbTree:_setBallAni()
	local spinePath = "activity/ui_ptds"
	local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".json")
	if existSpine then 
		local spineCloud1 = GetElement(self.m_root, "spineCloud1_WndClimbTree", WZUISpine)
		if spineCloud1 then 
			spineCloud1:setFileJson(spinePath .. ".json")
			spineCloud1:setFileAtlas(spinePath .. ".atlas")
			spineCloud1:play("wait4", true)
		end
		local spineCloud2 = GetElement(self.m_root, "spineCloud2_WndClimbTree", WZUISpine)
		if spineCloud2 then 
			spineCloud2:setFileJson(spinePath .. ".json")
			spineCloud2:setFileAtlas(spinePath .. ".atlas")
			spineCloud2:play("wait3", true)
		end
	else
		local _sIndex = "ui_ptds"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7075, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndClimbTree)
        end
	end

	local spinePath3 = "activity/ui_lbhr"
	local existSpine3 = WZDataFile:getInstance():checkFileExist(spinePath3 .. ".json")
	if existSpine3 then 
		local spineGift = GetElement(self.m_root, "spineGift_WndClimbTree", WZUISpine)
		if spineGift then 
			spineGift:setFileJson(spinePath3 .. ".json")
			spineGift:setFileAtlas(spinePath3 .. ".atlas")
			spineGift:play("wait", true)
		end
	end
end

function WndClimbTree:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndClimbTree:downloadEffectCallback",taskId,extraData,failed)
    self:_setBallAni()
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndClimbTree:_setBowlingPlayAni(aniIndex, bLoop)
	aniIndex = aniIndex or 1
	WZLog("WndClimbTree:_setBowlingPlayAni", aniIndex, bLoop, self.m_nClimbMetre, self.m_nLastClimbMetre)
	if aniIndex == 2 then 
		self.m_tPlayerAni:play("move", bLoop)

		local array = CCArray:create()
		local act1 = CCMoveTo:create(0.3, ccp(self.m_nMapStartPtX, self.m_nPlayerOffsetY + self.m_nLastClimbMetre * self.m_nMetreExchangeRatio))
		array:addObject(act1)
		array:addObject(CCCallFunc:create(function()
					self:showShootReward()           
	            end))
		local sequence = CCSequence:create(array)
		self.m_tPlayerAni:getAnimNode():runAction(sequence)
	elseif aniIndex == 1 then 
		self.m_tPlayerAni:play("standby1", bLoop)
	end
end

--@brief 	创建和平使者奖励
function WndClimbTree:_createLvRewardList()
	local tbLvRewardList = GetElement(self.m_root, "tbLvRewardList_WndClimbTree", WZUITableContainer)
	tbLvRewardList:cleanTable()
	self.m_tLvCell = {}

	for i = 1, #self.m_tPeaceConfig do
		local element, tNewObj = CellLvRewardItem:createElement()
		if element and tNewObj then
			element:setTag(i - 1)
			tNewObj:setData(self.m_tPeaceConfig[i], 3)

			tbLvRewardList:setCellElement(element)

			table.insert(self.m_tLvCell, tNewObj)
		end
	end
end

--@brief	初始化玩家形象
--param     bUpdate :是否更新玩家形象
function WndClimbTree:_initPlayerAni()
    WZLog("WndClimbTree:_initPlayerAni")
    local tPlayerInfo = CacheCenter:getPlayerInfo()
    local tEquipment = CacheCenter:getEquipmentList()

    local headColor,bodyColor = CacheCenter:getHeadAndBodyColor()
    local curPosX = nil
    local curPosY = nil
    local isFlipX = nil
    local animName = nil
    
    if self.m_conScrollMap:getChildByTag(1014) then
       self.m_conScrollMap:removeChildByTag(1014,true)
    end
   
    self.m_tPlayerAni = CreatePlayerFigure(tPlayerInfo.sex, tEquipment, nil,nil,nil,nil,nil,nil,false,nil,headColor,bodyColor, false)
    
    local node = self.m_tPlayerAni:getAnimNode()
    node:setTouchEnable(false)
    self.m_conScrollMap:addChild(node,2,1014)
    node:setRotation(-90)
    self.m_tPlayerAni:play("standby1", true)
    self.m_tPlayerAni:setScale(0.5)
    node:setAnchorPoint(GlobalMethod:ccp(0.5, 0))

    local ppoint = {}
    ppoint.x = self.m_nMapStartPtX
    ppoint.y = self.m_nPlayerOffsetY + self.m_nClimbMetre * self.m_nMetreExchangeRatio
    node:setPosition(ppoint.x, ppoint.y)
end

--@brief  加载树藤
--@param  bFirstMapScaleX : 第一张地图是否进行X轴旋转
function WndClimbTree:loadMap(nCount)
    WZLog("WndClimbTree:loadMap = ", self.m_nMapTreeIndex, nCount)
    local nLoadCount = nCount 
    for i = self.m_nMapTreeIndex, nLoadCount do
        local conMap = CreateElement("conMap_WndClimbTree")
        conMap:setTag(i*10)
        conMap:setVisible(true)
        local mapPtY = self.m_nMapStartPtY + (i - 1)*self.m_nMapAddStep
        conMap:setAbsPosition(GlobalMethod:ccp(self.m_nMapStartPtX, mapPtY))
        local spinePath = "activity/ui_ptds"
		local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".json")
		if existSpine then 
			local spineTree = GetElement(conMap, "spineTree_WndClimbTree", WZUISpine)
			if spineTree then 
				spineTree:setFileJson(spinePath .. ".json")
				spineTree:setFileAtlas(spinePath .. ".atlas")
				spineTree:play("wait1", true)
			end
		end

        local birdX = {280, 50}
        local birdY = self.m_nBirdIndex * self.m_tContent.birdConfig[1] * self.m_nMetreExchangeRatio + self.m_nPlayerOffsetY
        while birdY > mapPtY and birdY <= mapPtY + self.m_nMapAddStep do
	        local conBird = CreateElement("conBird_WndClimbTree")
	        conBird:setVisible(true)
	        local tempBirdY = math.fmod(birdY, self.m_nMapAddStep + 1) 
	        WZLog("WndClimbTree:loadMap", tempBirdY, birdY)
	        local tempBirdX = birdX[math.fmod(self.m_nBirdIndex, 2) + 1]
	        conBird:setAbsPosition(GlobalMethod:ccp(tempBirdX, tempBirdY))
	        local btnBird = GetElement(conBird, "btnBird_conBird", WZUIButton)
	        btnBird:setTag(self.m_nBirdIndex)
	        local realBirdMetre = self.m_nBirdIndex * self.m_tContent.birdConfig[1]
	        local imgBubble = GetElement(conBird, "imgBubble_conBird", WZUIImage)
	        local spinePath2 = "activity/ui_cljz"
			local existSpine2 = WZDataFile:getInstance():checkFileExist(spinePath2 .. ".json")
			local spineBird = GetElement(conBird, "spineBird_WndClimbTree", WZUISpine)
			if existSpine2 then 
				if spineBird then 
					spineBird:setFileJson(spinePath2 .. ".json")
					spineBird:setFileAtlas(spinePath2 .. ".atlas")
				end
			end
	        if realBirdMetre > self.m_nClimbMetre or (realBirdMetre == self.m_nClimbMetre and self.m_nSaveBird == 1) then 
	        	imgBubble:setVisible(true)
	        	spineBird:play("wait1", true)
	        	table.insert(self.m_tLockBirdNode, {realBirdMetre, imgBubble, spineBird})
	        else
	        	spineBird:play("wait3", true)
	        	imgBubble:setVisible(false)
	        end
	        conMap:addChild(conBird)
	        self.m_nBirdIndex = self.m_nBirdIndex + 1

	        birdY = self.m_nBirdIndex * self.m_tContent.birdConfig[1] * self.m_nMetreExchangeRatio + self.m_nPlayerOffsetY
	    end
        self.m_conScrollMap:addChild(conMap)
    end
    self.m_nMapTreeIndex = nLoadCount + 1
end

--@brief 	转到玩家所在的位置
function WndClimbTree:_toPlayerPso()
	local movMap = GetElement(self.m_root,"movMap_WndClimbTree",WZUIMoveContainer)
    local ptx,pty  = movMap:getMoveElement():getPosition()
    
    local ps = self.m_tPlayerAni:getPosition()
    local nX = ps.x
    local nY = ps.y 
    local minX = movMap:getMinPosition().x
    local maxX = movMap:getMaxPosition().x
    
    local moveMaxY = movMap:getMaxPosition().y
    local moveMinY = movMap:getMinPosition().y
    movMap:getMoveElement():setPositionY(moveMaxY)
    movMap:getMoveElement():setPositionX((maxX+minX)/2)
    
    local moveX = (maxX + minX )/2
    local offset = 50

    local conScrollMap = GetElement(self.m_root,"conScrollMap_WndClimbTree",WZUIContainer)
    local playerP = conScrollMap:convertToWorldSpace(GlobalMethod:ccp(nX, nY))
    
    local moveY = moveMaxY - playerP.y + offset
    movMap:getMoveElement():setPositionX(moveX)
    movMap:getMoveElement():setPositionY(moveY)
end

--@brief 	初始化地图和玩家位置
function WndClimbTree:_initMapAndPlayer()
	self.m_nBirdIndex = 1
	self.m_nMapTreeIndex = 1
	self.m_tLockBirdNode = {}
	local nTreeNum = math.ceil((self.m_nPlayerOffsetY + self.m_nClimbMetre * self.m_nMetreExchangeRatio)/self.m_nMapAddStep)
	self.m_nInitTreeNum = nTreeNum + 10
	self:_resetMoveContainerSize()
	self:loadMap(self.m_nInitTreeNum)
	self:_initPlayerAni()
	self:_toPlayerPso()
end

--@brief 	根据实际高度，更新解救小鸟状态
function WndClimbTree:_updateBirdStatus()
	for i = 1, #self.m_tLockBirdNode do
		if self.m_tLockBirdNode[i][1] <= self.m_nClimbMetre then 
			self.m_tLockBirdNode[i][2]:setVisible(false)
			self.m_tLockBirdNode[i][3]:play("wait2", false)
			self.m_nCurSaveBirdIndex = i
			self.m_tLockBirdNode[i][3]:enableSchedule("afterBreakBubble", 0.2)
			break 
		end
	end
end

--@brief 	移除已解救的小鸟的数据
function WndClimbTree:afterBreakBubble(element)
	element = WZUISpine:luaTo(element)
	element:disableSchedule()
	if self.m_nCurSaveBirdIndex and self.m_nCurSaveBirdIndex > 0 then 
		self.m_tLockBirdNode[self.m_nCurSaveBirdIndex][3]:play("wait3", true)
		table.remove(self.m_tLockBirdNode, self.m_nCurSaveBirdIndex)
	end
end

--@brief	重新设置滚动容器大小
function WndClimbTree:_resetMoveContainerSize()
	local conMoveEle = GetElement(self.m_root, "conMoveEle_WndClimbTree", WZUIContainer)
	conMoveEle:setAbsContentSize(GlobalMethod:CCSize(1136, self.m_nInitTreeNum * self.m_nMapAddStep))
	conMoveEle:updateRelativeSize()
end
-------------------------------------私有方法模块End----------------------------------------


function WndClimbTree:_adaptLanguage_vn( ... )
	GetElement(self.m_root, "txtBtnTask1_WndClimbTree", WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root, "txtBtnTask2_WndClimbTree", WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root, "txtBtnTask3_WndClimbTree", WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root, "txtBtnTask4_WndClimbTree", WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root, "txtBtnOpenOne_WndClimbTree", WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root, "txtBtnOpenFive_WndClimbTree", WZUILabelTTF):setScale(0.7)
end