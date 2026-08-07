--WndHappyMidAutumnData.lua
--@brief	WndHappyMidAutumn的数据模块
--@date		2024/08/14
--@author	yrd
--@note		欢度中秋

WndHappyMidAutumn = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndHappyMidAutumn:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nCoinId = 160705				--货币
	self.m_nDrawToolType = 0 			--抽奖工具类型 0,1
	self.m_tDrawNumList = {1,20} 		--抽奖数量列表
	self.m_nDrawNumType = 1 			--抽奖数量类型 1,2
	self.m_bOpenState = nil

	self.m_nCount = 0
	self.m_tSocre1 = {} 				--个人奖励
	self.m_tSocre2 = {} 				--全服奖励
	self.m_nCurPoolIndex = nil 			--点击的个人里程奖池下标
	self.m_tBallAniName = {"", "wait2", "wait3"}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndHappyMidAutumn:_unInit()
	self.m_root = nil
	self.m_nCoinId = nil
	self.m_nDrawToolType = nil
	self.m_tDrawNumList = nil
	self.m_nDrawNumType = nil
	self.m_bOpenState = nil

	self.m_nCount = 0
	self.m_tSocre1 = nil
	self.m_tSocre2 = nil
	self.m_nCurPoolIndex = nil
	self.m_tBallAniName = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndHappyMidAutumn:createElement()
	if WndHappyMidAutumn.m_root ~= nil then
		WindowManager:removeWindow(WndHappyMidAutumn.m_root, WndHappyMidAutumn, true)
	end
	local element = WZUISystem:getInstance():createElement("WndHappyMidAutumn")
	assert(element, "WndHappyMidAutumn create element failed!")
	self:_init()
	return element
end

--@brief	缓存推送更新物品时调用的函数
function WndHappyMidAutumn:updatePlayerItemData()
	WZLog("WndHappyMidAutumn:updatePlayerItemData")
	if self.m_root ~= nil then
		self:_updateCoinNum()
	end
end

--@brief 	获取活动详情成功
function WndHappyMidAutumn:GetActivityInfoOK(activityId, maxCount, count, status, rewardCounts, rewardItems, rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	if g_cityExtenInfo.activity7137 == activityId then
		self.m_nActivityId = activityId
		-- self.m_nMaxCount = maxCount
		self.m_nCount = count
		-- self.m_nStatus = status
		-- self.m_nRewardCounts = rewardCounts
		-- self.m_nRewardItems = rewardItems
		-- self.m_nRewardItemsParamCount = rewardItemsParamCount
		self.m_nStartTime = startTime
		self.m_nEndTime = endTime
		self.m_tContent = json.decode(content)
		-- self.m_nRewardId = rewardId
		-- self.m_nFinishCondition = finishCondition
		-- self.m_nTips = tips

		self.m_tCostByType = {finishCondition[1]}

		local nSex = CacheCenter:getPlayerInfo().sex

		self.m_tSocre1 = {}
		self.m_tSocre1.reward = {}
		for i=1, #self.m_tContent.scoreRewards do
			local tItem = {}
			local array = SplitStringWithSeparator(self.m_tContent.scoreRewards[i], "&")
			for i = 1, #array do
				local strTemp = string.sub(array[i], 2, -2)
				local id = tonumber(SplitStringWithSeparator(strTemp,",")[nSex + 1])
				local num = tonumber(SplitStringWithSeparator(strTemp,",")[3])
				table.insert(tItem, {id, num})
			end
			table.insert(self.m_tSocre1.reward, tItem)
		end
		self.m_tSocre1.score = self.m_tContent.scoreConfig
		self.m_tSocre1.limitConfig = self.m_tContent.playerLimitConfig

		self.m_tSocre2 = {}
		self.m_tSocre2.reward = {}
		for i=1, #self.m_tContent.globalRewardConfig do
			local tItem = {}
			local array = SplitStringWithSeparator(self.m_tContent.globalRewardConfig[i], "&")
			for i = 1, #array do
				local strTemp = string.sub(array[i], 2, -2)
				local id = tonumber(SplitStringWithSeparator(strTemp,",")[nSex + 1])
				local num = tonumber(SplitStringWithSeparator(strTemp,",")[3])
				table.insert(tItem, {id, num})
			end
			table.insert(self.m_tSocre2.reward, tItem)
		end
		self.m_tSocre2.score = self.m_tContent.globalScoreConfig

		self:_initActivityTime()
		self:updateWishingBtn()

	end
end

--@brief 	获取其他活动数据
function WndHappyMidAutumn:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end

	if doType == 1 then --获取达人奖、大奖限量数据
		local tResult = json.decode(jsonData)
		WZLog("WndHappyMidAutumn:_onGetOtherData", doType, Serialize(tResult))

		self.m_tSocre1.soldNum = tResult.playerLimit

		self.m_nScore = tResult.score
		self.m_tScoreRewardStatus = tResult.scoreRewardStatus
		self.m_tScoreRewards = tResult.scoreRewards
		self.m_nGlobalScore = tResult.globalScore
		self.m_tGlobalStatus = tResult.globalStatus
		self:updateUI()

		self:showRedDot()
	elseif doType == 3 then --开启结果
		local tResult = json.decode(jsonData)
		WZLog("WndHappyMidAutumn:_onGetOtherData", doType, Serialize(tResult))
		self.m_tOpenResult = {}

		self.m_tOpenResult.normalRewards = {} --常规奖
		self.m_tOpenResult.firstRewards = {} --小礼奖
		self.m_tOpenResult.bigRewards = {} --大礼奖
		self.m_tOpenResult.doyensRewards = {} --达人奖

		local rewardType = 8 
		local itemIdIndex = 1
		if tResult.itemIds then 
			for i = 1, #tResult.itemIds do
				local tItem = {}
				tItem.itemId = tResult.itemIds[i]
				tItem.itemNum = tResult.itemNums[i]
				tItem.type = rewardType
				tItem.imgRewardTitle = "ui/newActivity/bt_text_gxhd_2.png"
				tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
				tItem.playerItemId = tResult.playerItemIds[itemIdIndex]
				table.insert(self.m_tOpenResult.normalRewards, tItem)

				itemIdIndex = itemIdIndex + 1
			end
		end
		--大奖
		local strTitleFormat = [[<T C="255,255,255" S="46" P="1" SC="222,78,0" SS="4" SE="1">%s</T>]]
		local bigRewardType = 26 
		if tResult.fItemIds then 
			for i = 1, #tResult.fItemIds do
				local tItem = {}

				tItem.itemId = tResult.fItemIds[i]
				tItem.itemNum = tResult.fItemNums[i]
				tItem.type = bigRewardType
				tItem.imgRewardTitle = "ui/newActivity/bt_text_ty_dxj.png"
				tItem.imgBK = "ui/specialBg/hd_pic_ty_xj.png"
				tItem.playerItemId = tResult.playerItemIds[itemIdIndex]
				tItem.strTitle = string.format(strTitleFormat, LocalStrings.BLOW_BUBBLES_TEXT1[10])
				tItem.txtTitlePt = {0.5,0.885}
				tItem.spineEffect = {path = "activity/ui_bengchuang_xj", _sIndex = "ui_bengchuang_xj", play = "wait1"}

				table.insert(self.m_tOpenResult.firstRewards, tItem)

				itemIdIndex = itemIdIndex + 1
			end
		end
		--特奖
		if tResult.sItemIds then 
			for i = 1, #tResult.sItemIds do
				local tItem = {}
				tItem.itemId = tResult.sItemIds[i]
				tItem.itemNum = tResult.sItemNums[i]
				tItem.playerItemId = tResult.playerItemIds[itemIdIndex]
				tItem.type = bigRewardType
				tItem.imgRewardTitle = "ui/newActivity/bt_text_ty_dxj.png"
				tItem.imgBK = "ui/specialBg/hd_pic_ty_dj.png"
				tItem.goodsconPt = {0.515, 0.498}
				tItem.strTitle = string.format(strTitleFormat, LocalStrings.BLOW_BUBBLES_TEXT1[9])
				tItem.txtTitlePt = {0.5,0.885}
				tItem.spineEffect = {path = "activity/ui_bengchuang_drj", _sIndex = "ui_bengchuang_drj", play = "wait1"}

				table.insert(self.m_tOpenResult.bigRewards, tItem)
				itemIdIndex = itemIdIndex + 1
			end
		end

		--达人奖
		if tResult.nItemIds then 
			for i = 1, #tResult.nItemIds do
				local tItem = {}

				tItem.itemId = tResult.nItemIds[i]
				tItem.itemNum = tResult.nItemNums[i]
				tItem.playerItemId = tResult.playerItemIds[itemIdIndex]
				tItem.type = bigRewardType
				tItem.imgRewardTitle = "ui/newActivity/bt_text_ty_tj.png"
				tItem.imgBK = "ui/specialBg/hd_pic_ty_tj.png"
				tItem.titlePt = {0.5,0.97}
				tItem.imgBKPt = {0.491,0.499}
				tItem.strTitle = string.format(strTitleFormat, LocalStrings.BLOW_BUBBLES_TEXT1[8])
				tItem.txtTitlePt = {0.5,0.95}
				tItem.spineEffect = {path = "activity/ui_bengchuang_mxj", _sIndex = "ui_bengchuang_mxj", play = "wait1"}

				table.insert(self.m_tOpenResult.bigRewards, tItem)
				itemIdIndex = itemIdIndex + 1
			end
		end

		if result == 1 then 
			-- self.m_nCount = tResult.count
			self.m_tOpenResult.addExp = tResult.score

			self.m_nMaxGiftScore = 1
			for i=1,#tResult.giftScore do
				if self.m_nMaxGiftScore < tResult.giftScore[i] then
					self.m_nMaxGiftScore = tResult.giftScore[i]
				end
			end
			self:showOpenAction()

			self:updateWishingBtn()
		else
			self:setOpenState(false)
		end

		--刷新排行榜
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(g_cityExtenInfo.activity7137, 1)
	elseif doType == 4 then --选择奖励
		local tResult = json.decode(jsonData)
		WZLog("WndHappyMidAutumn:_onGetOtherData", doType, Serialize(tResult))
		if result == 0 then
			if tResult.status == 0 then
				self.m_tScoreRewards[tResult.pool+1] = -1
			elseif tResult.status == 1 then
				self.m_tScoreRewards[tResult.pool+1] = tResult.id
			end
			self:updateCurPoolItem()
		elseif result == 1 then
			MsgBoxManager:showTipBox(LocalStrings.SUMMERSURF_TEXT1[24])
		end
	elseif doType == 5 then
		local tResult = json.decode(jsonData)
		WZLog("WndHappyMidAutumn:_onGetOtherData", doType, Serialize(tResult))
		if result == 1 then 
			WndRewardShow:showById(tResult.itemIds, tResult.itemNums, nil, nil, nil, nil, nil, nil, nil, nil, nil, tResult.playerItemIds)
		elseif result == 4 then
			MsgBoxManager:showTipBox(LocalStrings.HAPPY_MIDAUTUMN_TEXT1[14])
		end
	elseif doType == 6 then
		local tResult = json.decode(jsonData)
		WZLog("WndHappyMidAutumn:_onGetOtherData", doType, Serialize(tResult))
		if result == 0 then 
			WndRewardShow:showById(tResult.itemIds, tResult.itemNums, nil, nil, nil, nil, nil, nil, nil, nil, nil, tResult.playerItemIds)
		end
	end
end

--@brief 	设置射箭的状态
function WndHappyMidAutumn:setOpenState(state)
	if self.m_root == nil then return end 
	self.m_bOpenState = state
end

--@brief 	关闭抽奖奖励展示界面回调
function WndHappyMidAutumn:_afterCloseReward()
	if self.m_root == nil then return end

	local tBigReward = {}
	if self.m_tOpenResult.firstRewards and #self.m_tOpenResult.firstRewards > 0 then 
		for i = 1, #self.m_tOpenResult.firstRewards do
			table.insert(tBigReward, self.m_tOpenResult.firstRewards[i])
		end
	end
	if self.m_tOpenResult.bigRewards and #self.m_tOpenResult.bigRewards > 0 then 
		for i = 1, #self.m_tOpenResult.bigRewards do
			table.insert(tBigReward, self.m_tOpenResult.bigRewards[i])
		end
	end

	if self.m_tOpenResult.normalRewards and #self.m_tOpenResult.normalRewards > 0 then 
		WndHoraryBigReward:showInterface(8, self.m_tOpenResult.normalRewards, tBigReward)
	elseif #tBigReward > 0 then 
		WndHoraryBigReward:showInterface(9, tBigReward)
	end
end

--@brief 	收到排行榜协议后显示界面
function WndHappyMidAutumn:_onRankResult(activityId, activityType, rankingType, myPoint, myRanking, rewardConfig, playerIds, 
	ranks, points, nickname, headIds, headColors, faceIds, sexs, vipLevel, level, bodyIds, wingIds, title, serverIds, headEffectId, qqInfo, bodyColourId, session, settlementDate)

	if self.m_root == nil then
		return
	end

	local nRank = 0
	local nScore = 0
	for i=1,3 do
		local conRankPlayer = GetElement(self.m_root,"conRankPlayer"..i,WZUIContainer)
		conRankPlayer:setVisible(false)
		local txtRPRank = GetElement(conRankPlayer,"txtRPRank",WZUILabelTTF)
		local txtRPName = GetElement(conRankPlayer,"txtRPName",WZUILabelTTF)
		local txtRPScore = GetElement(conRankPlayer,"txtRPScore",WZUILabelTTF)
		if points[i] then
			if points[i] ~= nScore or nRank > 1 and points[i] == nScore then
				nRank = nRank + 1
			end
			conRankPlayer:setVisible(true)
			txtRPRank:setText(nRank)
			txtRPName:setText(nickname[i])
			txtRPScore:setText(points[i])
			nScore = points[i]
		end
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
