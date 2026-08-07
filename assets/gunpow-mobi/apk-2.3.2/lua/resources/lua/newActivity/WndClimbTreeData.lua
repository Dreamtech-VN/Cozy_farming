--WndClimbTreeData.lua
--@brief	WndClimbTree的数据模块
--@date		2023/05/04
--@author	XTX
--@note		爬藤大赛

WndClimbTree = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndClimbTree:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_tBigRewardList = nil 		--大奖和特奖奖励
	self.m_bOpenState = false 
	self.m_tOpenResult = nil 
	self.m_nCoinId = 160447
	self.m_nMaxLotteryCount = 20    --最大抽奖次数
	self.m_nCount = 0 
	self.m_tBallAniName = {"wait1"}
	self.m_tPeaceConfig = nil 		--和平使者配置
	self.m_nSaveBird = 0 			--1:触发解救小鸟
	self.m_tLvCell = nil 
	self.m_nClimbMetre = 0 			--攀爬高度
	self.m_nBirdMetre = 0 			--离遇到下一只小鸟，已经走出的米数
	self.m_nClimbTimes = 0 			--攀爬次数
	self.m_bIsFirstIn = true 		--首次进界面
	self.m_conScrollMap = nil 
	self.m_nMapStartPtY = 0 		
	self.m_nMapStartPtX = 0 		
	self.m_nMapAddStep = 560 		
	self.m_tTimeGiftReward = nil 	--攀爬系数礼包奖励
	self.m_tLockBirdNode = nil 		--保存未解救的小鸟节点
	self.m_nInitTreeNum = 10 
	self.m_nCurSaveBirdIndex = nil 	--
	self.m_nMetreExchangeRatio = 5.61
	self.m_nLastClimbMetre = 0 		--上一次玩家所在的高度
	self.m_nSaveBirdCostNum = 0 	--解救小鸟消耗
	self.m_nPlayerOffsetY = 180	    --玩家位置偏移
	self.m_nBirdIndex = 1
	self.m_nMapTreeIndex = 1 		--树索引
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndClimbTree:_unInit()
	self.m_root = nil
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_tBigRewardList = nil 		--大奖和特奖奖励
	self.m_bOpenState = nil 
	self.m_tOpenResult = nil 
	self.m_nCoinId = nil  
	self.m_nMaxLotteryCount = nil    --最大抽奖次数
	self.m_nCount = nil 
	self.m_tBallAniName = nil 
	self.m_tPeaceConfig = nil 		--和平使者配置
	self.m_nSaveBird = nil 
	self.m_tLvCell = nil 
	self.m_nClimbMetre = nil 			--攀爬高度
	self.m_nBirdMetre = nil 
	self.m_nClimbTimes = nil 
	self.m_bIsFirstIn = false 		--首次进界面
	self.m_conScrollMap = nil 
	self.m_nMapStartPtY = nil 
	self.m_nMapStartPtX = nil 
	self.m_nMapAddStep = nil  		
	self.m_tTimeGiftReward = nil 
	self.m_tLockBirdNode = nil 		--保存未解救的小鸟节点
	self.m_nInitTreeNum = nil 
	self.m_nCurSaveBirdIndex = 0 	--
	self.m_nMetreExchangeRatio = nil 
	self.m_nLastClimbMetre = nil 
	self.m_nSaveBirdCostNum = nil 	--解救小鸟消耗
	self.m_nPlayerOffsetY = nil 
	self.m_nBirdIndex = nil 
	self.m_nMapTreeIndex = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndClimbTree:createElement()
	if WndClimbTree.m_root ~= nil then
		WindowManager:removeWindow(WndClimbTree.m_root, WndClimbTree, true)
	end
	local element = WZUISystem:getInstance():createElement("WndClimbTree")
	assert(element, "WndClimbTree create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndClimbTree:showInterface()
	LoadNewActivityRes(true)
	local wndWater = WndClimbTree:createElement()
	if wndWater then 
		WindowManager:addWindow(wndWater, WndClimbTree, false)
	end
end

--@brief 	获取活动详情成功
function WndClimbTree:GetActivityInfoOK(activityId,maxCount,count,status, rewardCounts, rewardItems, rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	-- body
	WZLog("WndClimbTree:GetActivityInfoOK", Serialize(finishCondition), content)
	if g_cityExtenInfo.activity7075 == activityId then 
		self.m_tContent = json.decode(content)
		self.m_nStartTime = startTime 
		self.m_nEndTime = endTime 
		self.m_nActivityId = activityId
		self.m_nCount = count
		WZLog("self.m_tContentself.m_tContent", Serialize(self.m_tContent))
		self.m_nSaveBirdCostNum = finishCondition[2]

		self:_analyzeBigReward()
		self:_update()
	end
end

--@brief 	获取其他活动数据
function WndClimbTree:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end 

	if doType == 1 then 
		local tResult = json.decode(jsonData)
		WZLog("WndClimbTree:_onGetOtherData 111", Serialize(tResult))
		self.m_nSaveBird = tResult.birdStatus
		self.m_nClimbMetre = tResult.sumTimes
		self.m_nBirdMetre = tResult.birdTimes
		self.m_nClimbTimes = tResult.giftTimes
		self.m_tTimeGiftReward = tResult.giftRewardList

		self:_setFreeBtnText()
		if self.m_bIsFirstIn then 
			self.m_bIsFirstIn = false 
			self:_initMapAndPlayer()
		else
			--是否需要重新设置树的高度
			local nTreeNum = math.ceil((self.m_nPlayerOffsetY + self.m_nClimbMetre * self.m_nMetreExchangeRatio)/self.m_nMapAddStep)
			if nTreeNum + 5 > self.m_nInitTreeNum then 
				self.m_nInitTreeNum = self.m_nInitTreeNum + 5
				self:_resetMoveContainerSize()
				self:loadMap(self.m_nInitTreeNum)
				local node = self.m_tPlayerAni:getAnimNode()
				local ppoint = {}
			    ppoint.x = self.m_nMapStartPtX
			    ppoint.y = self.m_nPlayerOffsetY + self.m_nClimbMetre * self.m_nMetreExchangeRatio
			    node:setPosition(ppoint.x, ppoint.y)
			end
		end
		if self.m_tOpenResult and self.m_tOpenResult.addExp and self.m_tOpenResult.addExp > 0 then 
			self:_updateBirdStatus()
		end
	elseif doType == 3 then --开启结果
		local tResult = json.decode(jsonData)
		WZLog("WndClimbTree:_onGetOtherData 333", Serialize(tResult))
		self.m_tOpenResult = {}

		self.m_tOpenResult.normalRewards = {} --常规奖
		self.m_tOpenResult.firstRewards = {} --小礼奖
		self.m_tOpenResult.bigRewards = {} --大礼奖

		local rewardType = 8 
		if tResult.giftTime <= 0 then
			for i = 1, #tResult.itemNums do
				local tItem = {}
				tItem.itemId = tResult.itemIds[i]
				tItem.itemNum = tResult.itemNums[i]
				tItem.type = rewardType
				tItem.imgRewardTitle = "ui/newActivity/bt_text_gxhd_2.png"
				tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
				table.insert(self.m_tOpenResult.normalRewards, tItem)
			end
		else
			--解救小鸟奖励
			local strTitleFormat = [[<T C="255,255,255" S="36" P="1" SC="222,78,0" SS="4" SE="0">%s</T><T C="249,255,0" S="36" P="1" SC="222,78,0" SS="4" SE="0">%s</T>]]
			for j = 1, #tResult.itemNums do
				local tItem = {}

				tItem.itemId = tResult.itemIds[j]
				tItem.itemNum = tResult.itemNums[j]
				tItem.type = rewardType
				tItem.imgRewardTitle = "ui/newActivity/text_hd_tqq_di.png"
				tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
				tItem.strTitle = string.format(strTitleFormat, LocalStrings.CLIMBTREE_TEXT1[21], LocalStrings.ATH_REWARD_CHECK)

				table.insert(self.m_tOpenResult.normalRewards, tItem)
			end
		end

		--大奖
		local bigRewardType = 26 
		local strTitleFormat = [[<T C="255,255,255" S="36" P="1" SC="222,78,0" SS="4" SE="1">%s</T>]]
		--大奖
		if tResult.fItemIds then 
			for j = 1, #tResult.fItemIds do
				local tItem = {}

				tItem.itemId = tResult.fItemIds[j]
				tItem.itemNum = tResult.fItemNums[j]
				tItem.type = bigRewardType
				tItem.imgRewardTitle = "ui/newActivity/text_hd_tqq_di.png"
				tItem.imgBK = ""
				tItem.bIsShowLongBg = true
				tItem.imgBKPt = GlobalMethod:ccp(0.45, 0.5)
				tItem.goodsconPt = GlobalMethod:ccp(0.5, 0.5)
				tItem.strTitle = string.format(strTitleFormat, LocalStrings.CLIMBTREE_TEXT1[8])
			--	tItem.spineEffect = {path = "activity/ui_hl_ptj", _sIndex = "ui_hl_ptj", play = "wait1"}

				table.insert(self.m_tOpenResult.firstRewards, tItem)
			end
		end
		--特奖
		for j = 1, #tResult.sItemIds do
			local tItem = {}

			tItem.itemId = tResult.sItemIds[j]
			tItem.itemNum = tResult.sItemNums[j]
			tItem.type = bigRewardType
			tItem.imgRewardTitle = "ui/newActivity/text_hd_tqq_di.png"
			tItem.imgBK = ""
			tItem.bIsShowLongBg = true
			tItem.goodsconPt = GlobalMethod:ccp(0.5, 0.5)
			tItem.imgBKPt = GlobalMethod:ccp(0.49,0.5)
			tItem.strTitle = string.format(strTitleFormat, LocalStrings.CLIMBTREE_TEXT1[9])
		--	tItem.spineEffect = {path = "activity/ui_hl_dj", _sIndex = "ui_hl_dj", play = "wait1"}

			table.insert(self.m_tOpenResult.bigRewards, tItem)
		end
		
		if result == 1 then 
			self.m_nCount = tResult.count
			self.m_tOpenResult.addExp = tResult.giftTime
			self.m_tOpenResult.addMetre = tResult.ppTimes

			self.m_nLastClimbMetre = self.m_nLastClimbMetre + tResult.ppTimes
			self:showOpenAction()
			self:_setFreeBtnText()
		else
			self:setOpenState(false)
		end
	elseif doType == 4 then --领取攀爬次数礼包
		local tResult = json.decode(jsonData)
		WZLog("WndClimbTree:_onGetOtherData 444", Serialize(tResult))
		if result == 0 then 
			local normalRewards = {}
			for i = 1, #tResult.itemNums do
				local tItem = {}
				tItem.itemId = tResult.itemIds[i]
				tItem.itemNum = tResult.itemNums[i]
				tItem.type = 8
				tItem.imgRewardTitle = "ui/newActivity/bt_text_gxhd_2.png"
				tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
				table.insert(normalRewards, tItem)
			end
			WndHoraryBigReward:showInterface(8, normalRewards)
		end
		self:setOpenState(false)
	elseif doType == 5 then --获取和平使者数据
		local tResult = json.decode(jsonData)
		WZLog("WndClimbTree:_onGetOtherData 555", Serialize(tResult))
		--和平使者配置
		self.m_tPeaceConfig = {}
		local nSex = CacheCenter:getPlayerInfo().sex
		for j = 1, #tResult.lv do
			local array = SplitStringWithSeparator(tResult.reward[j], "&")
			local nSex = CacheCenter:getPlayerInfo().sex
			local tItem = {}

			tItem.id = j - 1
			tItem.lv = tResult.lv[j]
			tItem.name = tResult.name[j]
			tItem.activityId = activityId
			tItem.reward = {}
			tItem.exp = tResult.score[j]
			tItem.progress = tResult.totalScore > tItem.exp and tItem.exp or tResult.totalScore
			tItem.status = tResult.status[j] + 1
			for i = 1, #array do
				local strTemp = string.sub(array[i], 2, -2) 
				local id = tonumber(SplitStringWithSeparator(strTemp,",")[nSex + 1])
				local num = tonumber(SplitStringWithSeparator(strTemp,",")[3])

				table.insert(tItem.reward, {id, num})
			end

			table.insert(self.m_tPeaceConfig, tItem)
		end
		self:setOpenState(false)
		self:_createLvRewardList()
	elseif doType == 6 then --领取等级奖励
		local tResult = json.decode(jsonData)
		WZLog("WndClimbTree:_onGetOtherData 666", Serialize(tResult))
		if result == 0 then 
			for i = 1, #self.m_tPeaceConfig do 
				if self.m_tPeaceConfig[i].id == tResult.lvType then 
					self.m_tPeaceConfig[i].status = 2
					local ids, nums = {}, {}
					for j = 1, #self.m_tPeaceConfig[i].reward do
						table.insert(ids, self.m_tPeaceConfig[i].reward[j][1])
						table.insert(nums, self.m_tPeaceConfig[i].reward[j][2])
					end
					WndRewardShow:showById(ids, nums)

					break 
				end
			end
			for i = 1, #self.m_tLvCell do
				local tData = self.m_tLvCell[i]:getData()
				if tData and tData.id == tResult.lvType then 
					self.m_tLvCell[i]:updateStatue(2)
					break 
				end
			end
		end
	end
end

--@brief	缓存推送更新物品时调用的函数
function WndClimbTree:updatePlayerItemData()
	WZLog("WndClimbTree:updatePlayerItemData")
	if self.m_root ~= nil then
		self:_updateLightNum()
		self:showRedDot()
	end
end

--@brief 	设置射箭的状态
function WndClimbTree:setOpenState(state)
	-- body
	if self.m_root == nil then return end 

	self.m_bOpenState = state
end

--@brief 	获取图鉴数据
function WndClimbTree:getLibraryData()
	return self.m_tLibraryTaskData
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	关闭抽奖奖励展示界面回调
function WndClimbTree:_afterCloseReward()
	if self.m_root == nil then return end 

	local tBigReward = {}
	local nIndex = 1
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

	local tOtherRewards = {}
	if self.m_tOpenResult.cardRewards and #self.m_tOpenResult.cardRewards > 0 then 
		table.insert(tOtherRewards, self.m_tOpenResult.cardRewards)
	end

	if self.m_tOpenResult.normalRewards and #self.m_tOpenResult.normalRewards > 0 then 
		WndHoraryBigReward:showInterface(8, self.m_tOpenResult.normalRewards, tBigReward, tOtherRewards)
	elseif #tBigReward > 0 then 
		WndHoraryBigReward:showInterface(9, tBigReward)
	end
end

--@brief 	解析大奖数据
function WndClimbTree:_analyzeBigReward()
	-- body
	local sBigReward = self.m_tContent.firstRewards
	local array = SplitStringWithSeparator(sBigReward, "&")
	local nSex = CacheCenter:getPlayerInfo().sex
	local tItem = {reward_ids1 = {}, reward_nums1 = {}, name = LocalStrings.CLIMBTREE_TEXT1[8]}
	self.m_tBigRewardList = {}
	for i = 1, #array do
--		WZLog("WndClimbTree:_analyzeBigReward", string.sub(array[i], 2, -2))
		local string = string.sub(array[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string,",")[3])

		table.insert(tItem.reward_ids1, id)
		table.insert(tItem.reward_nums1, num)
	end

	self.m_tBigRewardList[1] = tItem

	local specialReward = self.m_tContent.superRewards
	local array1 = SplitStringWithSeparator(specialReward, "&")
	local tItem1 = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.CLIMBTREE_TEXT1[9] }
	for i = 1, #array1 do
--		WZLog("WndClimbTree:_analyzeBigReward", string.sub(array1[i], 2, -2))
		local string = string.sub(array1[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string, ",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string, ",")[3])
		
		table.insert(tItem1.reward_ids2, id)
		table.insert(tItem1.reward_nums2, num)
	end

	self.m_tBigRewardList[2] = tItem1
end




-------------------------------------私有方法模块End----------------------------------------
