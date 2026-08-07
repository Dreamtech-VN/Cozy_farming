--WndSeafarRoadData.lua
--@brief	WndSeafarRoad的数据模块
--@date		2023/04/10
--@author	XTX
--@note		航海之路活动主界面

WndSeafarRoad = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSeafarRoad:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_tBigRewardList = nil 		--大奖和特奖奖励
	self.m_bOpenState = false 
	self.m_tOpenResult = nil 
	self.m_nCoinId = 160439
	self.m_nCoinId2 = 160440
	self.m_nMaxLotteryCount = 20    --最大抽奖次数
	self.m_nCount = 0 
	self.m_tBallAniName = {"wait", "wait"}
	self.m_nAniType = 0 			--抽奖动画索引
	self.m_tScoreConfig = nil 
	self.m_tStepBoxConfig = nil 
	self.m_nCurScore = 0 	--当前步行积分
	self.m_nCurStep = nil 	--当前海里
	self.m_nGiftRewardNum = 0 	--全服礼包数
	self.m_tMovePos = {{0.2499, 0.1197}, {0.242, 0.14}, {0.24, 0.156}, {0.224, 0.174}, {0.215,0.19}, {0.208, 0.2}, {0.197,0.214}, {0.185, 0.226}, {0.175,0.24}, {0.164, 0.249}, {0.153,0.263}, {0.148, 0.277}, {0.141,0.296}, {0.137, 0.315}, {0.137,0.337}, {0.137, 0.358}, {0.142,0.38}, {0.146, 0.396}, {0.156,0.412}, {0.167, 0.427}, {0.177,0.4395}, {0.189, 0.45}, {0.201,0.461}, {0.212, 0.466}, {0.228,0.477}, {0.237, 0.48}, {0.259, 0.49}, {0.287, 0.494}, {0.313, 0.494}, {0.336, 0.494}, {0.36, 0.488}, {0.386, 0.483}, {0.408, 0.472}, {0.432, 0.458}, {0.455, 0.441}, {0.477, 0.421}, {0.501, 0.405}, {0.522, 0.386}, {0.546, 0.371}, {0.571, 0.354}, {0.593, 0.338}, {0.617, 0.327}, {0.641, 0.315}, {0.666, 0.302}, {0.689, 0.296}, {0.715, 0.288}, {0.738, 0.282}, {0.765, 0.282}, {0.791, 0.282}, {0.816, 0.283}, {0.84, 0.294}, {0.864, 0.305}, {0.887, 0.326}, {0.906, 0.355}, {0.921, 0.39}, {0.928, 0.412}, {0.924, 0.476}, {0.909, 0.515}, {0.889, 0.546}, {0.87, 0.571}, {0.846, 0.582}, {0.823, 0.596}, {0.799, 0.604}, {0.771, 0.608}, {0.746, 0.61}, {0.72, 0.612}, {0.696, 0.608}, {0.673, 0.605}, {0.647, 0.601}, {0.623, 0.594}, {0.597, 0.585}, {0.573, 0.577}, {0.549, 0.569}, {0.525, 0.558}, {0.502, 0.551}, {0.475, 0.546}, {0.451, 0.544}, {0.427, 0.544}, {0.399, 0.546}, {0.38, 0.551}, {0.354, 0.557}, {0.327, 0.572}, {0.31, 0.6}, {0.317, 0.638}, {0.338, 0.668}, {0.361, 0.688}, {0.385, 0.702}, {0.405, 0.71}, {0.434, 0.719}, {0.456, 0.724}, {0.484, 0.726}, {0.508, 0.729}, {0.533, 0.729}, {0.533, 0.729}, {0.582, 0.729}, {0.608, 0.726}, {0.631, 0.721}, {0.658, 0.718}, {0.681, 0.713}, {0.708, 0.705}, {0.742, 0.712}}
	self.m_nPosIndex = nil 
	self.m_nPirate = 0 	--是否出现海盗
	self.m_nPirateHP = 0 	--海盗血量
	self.m_nPirateProgress = 0 	--海盗出现进度
	self.m_tIslandOccupyInfo = nil --占领玩家名字
	self.m_bIsBeatPirate = false 	--抽奖是否是击杀海盗
	self.m_nConstantOilToMile = 1 	--1油桶走多少海里
	self.m_nPerStepMiles = 0 		
	self.m_nTotalSeaMileTime = 0
	self.m_nChooseReward = 0 		--选择奖励状态0：弹出预览界面；1：不弹
	self.m_bIsOpenReward = false
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSeafarRoad:_unInit()
	self.m_root = nil
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_tBigRewardList = nil 		--大奖和特奖奖励
	self.m_bOpenState = nil 
	self.m_tOpenResult = nil 
	self.m_nCoinId = nil  
	self.m_nCoinId2 = nil 
	self.m_nMaxLotteryCount = nil    --最大抽奖次数
	self.m_nCount = nil 
	self.m_tBallAniName = nil 
	self.m_nAniType = nil 
	self.m_tScoreConfig = nil 
	self.m_tStepBoxConfig = nil 
	self.m_nCurScore = nil 	--当前步行积分
	self.m_nCurStep = nil 	--当前步行数
	self.m_nGiftRewardNum = nil 	--全服礼包数
	self.m_tMovePos = nil 
	self.m_nPosIndex = nil 
	self.m_nPirate = nil 
	self.m_nPirateHP = nil  	--海盗血量
	self.m_nPirateProgress = nil  	--海盗出现进度
	self.m_tIslandOccupyInfo = nil --占领玩家名字
	self.m_bIsBeatPirate = nil 
	self.m_nConstantOilToMile = nil 	--1油桶走多少海里
	self.m_nPerStepMiles = nil 
	self.m_nTotalSeaMileTime = nil 
	self.m_nChooseReward = nil 		--选择奖励状态0：弹出预览界面；1：不弹
	self.m_bIsOpenReward = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSeafarRoad:createElement()
	if WndSeafarRoad.m_root ~= nil then
		WindowManager:removeWindow(WndSeafarRoad.m_root, WndSeafarRoad, true)
	end
	local element = WZUISystem:getInstance():createElement("WndSeafarRoad")
	assert(element, "WndSeafarRoad create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndSeafarRoad:showInterface()
	LoadNewActivityRes(true)
	local wndWater = WndSeafarRoad:createElement()
	if wndWater then 
		WindowManager:addWindow(wndWater, WndSeafarRoad, false)
	end
end

--@brief 	获取活动详情成功
function WndSeafarRoad:GetActivityInfoOK(activityId,maxCount,count,status, rewardCounts, rewardItems, rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	-- body
	WZLog("WndSeafarRoad:GetActivityInfoOK", g_cityExtenInfo.activity7072, activityId)
	if g_cityExtenInfo.activity7072 == activityId then 
		self.m_tContent = json.decode(content)
		self.m_nStartTime = startTime 
		self.m_nEndTime = endTime 
		self.m_nActivityId = activityId
		self.m_nCount = count
		WZLog("self.m_tContentself.m_tContent", Serialize(self.m_tContent))
		local tempScoreReward = json.decode(self.m_tContent.scoreRewards)
		local tempScoreTarget = json.decode(self.m_tContent.scoreConfig)

		--步行积分配置
		self.m_tScoreConfig = {}
		local nSex = CacheCenter:getPlayerInfo().sex
		for j = 1, #tempScoreReward do
			local array = SplitStringWithSeparator(tempScoreReward[j], "&")
			local nSex = CacheCenter:getPlayerInfo().sex
			local tItem = {}
			tItem.reward = {}
			tItem.scoreTarget = tempScoreTarget[j]
			tItem.status = -1
			for i = 1, #array do
				local strTemp = string.sub(array[i], 2, -2) 
				local id = tonumber(SplitStringWithSeparator(strTemp,",")[nSex + 1])
				local num = tonumber(SplitStringWithSeparator(strTemp,",")[3])

				table.insert(tItem.reward, {id, num})
			end

			table.insert(self.m_tScoreConfig, tItem)
		end
		--步数宝箱配置
		local tempStepReward = json.decode(self.m_tContent.islandGiftRewards)
		local tempStepTarget = json.decode(self.m_tContent.islandGiftConfig)
		self.m_tStepBoxConfig = {}
		local maxMiles = 0 
		for j = 1, #tempStepReward do
			local array = SplitStringWithSeparator(tempStepReward[j], "&")
			local nSex = CacheCenter:getPlayerInfo().sex
			local tItem = {}
			tItem.reward = {}
			tItem.stepTarget = tempStepTarget[j]
			tItem.status = -1
			for i = 1, #array do
				local strTemp = string.sub(array[i], 2, -2) 
				local id = tonumber(SplitStringWithSeparator(strTemp,",")[nSex + 1])
				local num = tonumber(SplitStringWithSeparator(strTemp,",")[3])

				table.insert(tItem.reward, {id, num})
			end

			table.insert(self.m_tStepBoxConfig, tItem)
			if tempStepTarget[j] > maxMiles then 
				maxMiles = tempStepTarget[j]
			end
		end
		local pointNums = #self.m_tMovePos
		self.m_nPerStepMiles = maxMiles/pointNums
		self.m_nChooseReward = GetOperateTimes("SEAFARROADACTIVITYID", self.m_nActivityId) 

		self:_analyzeBigReward()
		self:_update()
	end
end

--@brief 	获取其他活动数据
function WndSeafarRoad:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end 

	if doType == 1 then 
		local tResult = json.decode(jsonData)
		WZLog("WndSeafarRoad:_onGetOtherData 111", Serialize(tResult))
		self.m_nCurScore = tResult.score
		self.m_nCurStep = tResult.seaMileTime 	--当前海里
		self.m_nTotalSeaMileTime = tResult.totalSeaMileTime
		if self.m_nPosIndex == nil or tResult.seaMileTime == 0 then 
			self.m_nPosIndex = math.floor(tResult.seaMileTime/self.m_nPerStepMiles)
			if self.m_nPosIndex == 0 then self.m_nPosIndex = 1 end 
			self:_initBoardPos()
		end

		self.m_nGiftRewardNum = tResult.globalNum
		self.m_nPirate = tResult.pirateStatus
		self.m_nPirateHP = tResult.pirateHP 	--海盗血量
		self.m_tIslandOccupyInfo = {}
		for i = 1, #tResult.playerIds do
			local tItem = {}
			tItem.playerId = tResult.playerIds[i]
			tItem.name = tResult.nicknames[i]
			tItem.vipLevel = tResult.vipLevels[i]
			tItem.headId = tResult.headIds[i]
			tItem.headColor = tResult.headColors[i]
			tItem.faceId = tResult.faceIds[i]
			tItem.sex = tResult.sexs[i]
			tItem.level = tResult.levels[i]
			tItem.headEffectId = tResult.profileFrame[i]
			tItem.occupyTimes = tResult.islandOccupyNum[i]

			table.insert(self.m_tIslandOccupyInfo, tItem)
		end
		if tResult.globalIslandReward and self.m_tStepBoxConfig then 
			for j = 1, #tResult.globalIslandReward do
				local array = SplitStringWithSeparator(tResult.globalIslandReward[j], "&")
				local nSex = CacheCenter:getPlayerInfo().sex
				self.m_tStepBoxConfig[j].rewardNor = {}
				for i = 1, #array do
					local strTemp = string.sub(array[i], 2, -2) 
					local id = tonumber(SplitStringWithSeparator(strTemp,",")[nSex + 1])
					local num = tonumber(SplitStringWithSeparator(strTemp,",")[3])

					table.insert(self.m_tStepBoxConfig[j].rewardNor, {id, num})
				end
			end
		end
		
		self.m_nPirateProgress = tResult.pirateProgress
		--更新积分宝箱的状态
		for i = 1, #tResult.scoreRewardStatus do
			self.m_tScoreConfig[i].status = tResult.scoreRewardStatus[i]
		end

		self:_showProgress()
		self:showBagGiftInfo()
		if not self.m_bIsBeatPirate then 
			self:_showPirate()
			self:_setFreeBtnText()
		end
	elseif doType == 2 then --大奖限量
		local tResult = json.decode(jsonData)
		local nSex = CacheCenter:getPlayerInfo().sex
		local sBigReward = tResult.rewards
		local array = SplitStringWithSeparator(sBigReward, "&")

		table.insert(self.m_tGetTimes, tResult.pool)
		local tItem = {}
		if tResult.pool == 1 then 
			tItem = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.SEAFARROAD_TEXT1[9], strAtt = LocalStrings.GONGANDDRUM_TEXT1[16], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31, pool = tResult.pool}
		elseif tResult.pool == 2 then 
			tItem = {reward_ids = {}, reward_nums = {}, name = LocalStrings.SEAFARROAD_TEXT1[10], strAtt = LocalStrings.GONGANDDRUM_TEXT1[16], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31, pool = tResult.pool}
		end
		for i = 1, #tResult.globalLimit do
			local tab = {}
			tab.id = i - 1
			tab.limitNum = tResult.playerLimitConfig[i]
			tab.dailyLimit = tResult.globalLimitConfig[i]
			tab.dailyBuyNum = tResult.globalLimit[i]
			tab.soldNum = tResult.playerLimit[i]
			if utilsValueInTable(i - 1, tResult.optionalList) then 
				tItem.chooseState[i] = 1
			else
				tItem.chooseState[i] = 0
			end
			
			tItem.leftConfig[i] = tab
		end

		for i = 1, #array do
			local string = string.sub(array[i], 2, -2) 
			local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
			local num = tonumber(SplitStringWithSeparator(string,",")[3])
			if tResult.pool == 1 then 
				table.insert(tItem.reward_ids2, id)
				table.insert(tItem.reward_nums2, num)
			elseif tResult.pool == 2 then 
				table.insert(tItem.reward_ids, id)
				table.insert(tItem.reward_nums, num)
			end
		end
		if tResult.pool == 1 then 
			self.m_tBigRewardList[2] = tItem
		elseif tResult.pool == 2 then 
			self.m_tBigRewardList[3] = tItem
		end

		if self.m_bIsOpenReward and self.m_tGetTimes and #self.m_tGetTimes == 2 then 
			self.m_bIsOpenReward = false 
			local otherData = {}
			otherData.winType = 1
			otherData.activityId = self.m_nActivityId
			otherData.otherRewardData = self.m_tBigRewardList[3]
			otherData.chooseInfo = {strKey="SEAFARROAD_TEXT1", wordIndex=8, doType=8}

			WndJoinReward:showInterface("", self.m_tBigRewardList[1], self.m_tBigRewardList[2], LocalStrings.SEAFARROAD_TEXT1[10], true, 3, otherData, 3)
		end
	elseif doType == 3 then --开启结果
		local tResult = json.decode(jsonData)
		WZLog("WndSeafarRoad:_onGetOtherData 333", Serialize(tResult))
		self.m_tOpenResult = {}

		self.m_tOpenResult.normalRewards = {} --常规奖
		self.m_tOpenResult.firstRewards = {} --小礼奖
		self.m_tOpenResult.bigRewards = {} --大礼奖
		self.m_tOpenResult.killPirateRewards = {} --击杀死海盗奖
		self.m_tOpenResult.firstZLRewards = {} --首次占领奖励
		self.m_tOpenResult.normalZLRewards = {} --普通占领奖励
		self.m_tOpenResult.addScore = 0 --增加的积分
		self.m_tOpenResult.addStep = 0 --增加的步数

		local rewardType = 8 
		for i = 1, #tResult.itemNums do
			local tItem = {}
			tItem.itemId = tResult.itemIds[i]
			tItem.itemNum = tResult.itemNums[i]
			tItem.type = rewardType
			tItem.imgRewardTitle = "ui/newActivity/bt_text_gxhd_2.png"
			tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
			table.insert(self.m_tOpenResult.normalRewards, tItem)
		end
		--击杀死海盗奖励
		local strTitleFormat = [[<T C="255,255,255" S="46" P="1" SC="222,78,0" SS="4" SE="0">%s</T><T C="249,255,0" S="46" P="1" SC="222,78,0" SS="4" SE="0">%s</T>]]
		if tResult.hdItems then 
			for i = 1, #tResult.hdItems do
				local tItem = {}
				tItem.itemId = tResult.hdItems[i]
				tItem.itemNum = tResult.hdItemNums[i]
				tItem.type = rewardType
				tItem.imgRewardTitle = "ui/newActivity/text_hd_tqq_di.png"
				tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
				tItem.strTitle = string.format(strTitleFormat, LocalStrings.SEAFARROAD_TEXT1[31], LocalStrings.ATH_REWARD_CHECK)
				table.insert(self.m_tOpenResult.killPirateRewards, tItem)
			end
		end
		--首次占领奖励
		if tResult.fOccupyItems then 
			for i = 1, #tResult.fOccupyItems do
				local tItem = {}
				tItem.itemId = tResult.fOccupyItems[i]
				tItem.itemNum = tResult.fOccupyItemNums[i]
				tItem.type = rewardType
				tItem.imgRewardTitle = "ui/newActivity/text_hd_tqq_di.png"
				tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
				tItem.strTitle = string.format(strTitleFormat, LocalStrings.SEAFARROAD_TEXT1[29], LocalStrings.ATH_REWARD_CHECK)
				table.insert(self.m_tOpenResult.firstZLRewards, tItem)
			end
		end
		--普通占领必得奖励
		if tResult.islandItems then 
			for i = 1, #tResult.islandItems do
				local tItem = {}
				tItem.itemId = tResult.islandItems[i]
				tItem.itemNum = tResult.islandItemNums[i]
				tItem.type = rewardType
				tItem.imgRewardTitle = "ui/newActivity/text_hd_tqq_di.png"
				tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
				tItem.strTitle = string.format(strTitleFormat, LocalStrings.SEAFARROAD_TEXT1[32], LocalStrings.ATH_REWARD_CHECK)
				table.insert(self.m_tOpenResult.normalZLRewards, tItem)
			end
		end
		--普通占领奖励
		if tResult.fIslandItems then 
			for i = 1, #tResult.fIslandItems do
				local tItem = {}
				tItem.itemId = tResult.fIslandItems[i]
				tItem.itemNum = tResult.fIslandItemNums[i]
				tItem.type = rewardType
				tItem.imgRewardTitle = "ui/newActivity/text_hd_tqq_di.png"
				tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
				tItem.strTitle = string.format(strTitleFormat, LocalStrings.SEAFARROAD_TEXT1[32], LocalStrings.ATH_REWARD_CHECK)
				table.insert(self.m_tOpenResult.normalZLRewards, tItem)
			end
		end

		--大奖
		local bigRewardType = 26 
		--大奖
		if tResult.fItemIds then 
			for j = 1, #tResult.fItemIds do
				local tItem = {}

				tItem.itemId = tResult.fItemIds[j]
				tItem.itemNum = tResult.fItemNums[j]
				tItem.type = bigRewardType
				tItem.imgRewardTitle = "ui/newActivity/bt_text_hhzs_hhj.png"
				tItem.imgBK = "ui/newActivity/hd_pic_hhsz_hhxj.png"
			--	tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
				tItem.imgBKPt = GlobalMethod:ccp(0.5, 0.5)
				tItem.goodsconPt = GlobalMethod:ccp(0.5, 0.5)
				tItem.imgTitle = "ui/activityWords/bt_text_hhzs_hhxj.png"
				tItem.imgTitlePt = GlobalMethod:ccp(0.5,0.893)
				tItem.spineEffect = {path = "activity/ui_hh_xj", _sIndex = "ui_hh_xj", play = "wait1"}

				table.insert(self.m_tOpenResult.firstRewards, tItem)
			end
		end
		--特奖
		for j = 1, #tResult.sItemIds do
			local tItem = {}

			tItem.itemId = tResult.sItemIds[j]
			tItem.itemNum = tResult.sItemNums[j]
			tItem.type = bigRewardType
			tItem.imgRewardTitle = "ui/newActivity/bt_text_hhzs_hhj.png"
			tItem.imgBK = "ui/specialBg/hd_pic_hhsz_hhdj.png"
			tItem.goodsconPt = GlobalMethod:ccp(0.5, 0.5)
			tItem.imgBKPt = GlobalMethod:ccp(0.49,0.5)
			tItem.imgTitle = "ui/activityWords/bt_text_hhzs_hhdj.png"
			tItem.imgTitlePt = GlobalMethod:ccp(0.5,0.893)
			tItem.spineEffect = {path = "activity/ui_hh_dj", _sIndex = "ui_hh_dj", play = "wait1"}

			table.insert(self.m_tOpenResult.bigRewards, tItem)
		end

		--狂魔奖
		for j = 1, #tResult.nItems do
			local tItem = {}

			tItem.itemId = tResult.nItems[j]
			tItem.itemNum = tResult.nItemNums[j]
			tItem.type = bigRewardType
			tItem.imgRewardTitle = "ui/newActivity/bt_text_hhzs_hsdjd.png"
			tItem.titlePt = GlobalMethod:ccp(0.5,0.935)
			tItem.imgBK = "ui/specialBg/hd_pic_hhsz_hsdj.png"
			tItem.imgBKPt = GlobalMethod:ccp(0.52,0.5)
			tItem.goodsconPt = GlobalMethod:ccp(0.5, 0.5)			
			tItem.imgTitle = "ui/activityWords/bt_text_hhzs_hsdj.png"
			tItem.imgTitlePt = GlobalMethod:ccp(0.5,0.915)
			tItem.spineEffect = {path = "activity/ui_hh_hs", _sIndex = "ui_hh_hs", play = "wait1"}

			table.insert(self.m_tOpenResult.bigRewards, tItem)
		end

		if result == 1 then 
			self.m_nCount = tResult.count
			self.m_tOpenResult.addScore = tResult.score --增加的积分
			self.m_tOpenResult.addStep = tResult.num --增加的海里
			if self.m_nCurStep then 
				local seaMiles = self.m_nCurStep + tResult.num
				local nTempPosIndex = math.floor(seaMiles/self.m_nPerStepMiles)
				WZLog("WndSeafarRoad:_onGetOtherData 333_00", self.m_nCurStep, self.m_nPosIndex)
				self.m_nAniType = nTempPosIndex - self.m_nPosIndex
			end
			
			self:showOpenAction()
			self:_setFreeBtnText()
		else
			self:setOpenState(false)
		end
	elseif doType == 4 then --领取步行积分奖励
		local tResult = json.decode(jsonData)
		WZLog("WndSeafarRoad:_onGetOtherData 444", Serialize(tResult))
		if result == 0 then 
			WndRewardShow:showById(tResult.itemIds, tResult.itemNums)
			--刷新积分宝箱状态
			self.m_tScoreConfig[tResult.scoreType + 1].status = tResult.status
			local nullBox = {"ui/common/common_icon_djbx3.png","ui/common/common_icon_lan3.png","ui/common/common_icon_zi3.png","ui/common/common_icon_huang3.png","ui/common/common_icon_zis3.png", "ui/common/common_icon_hong3.png"}
			if tResult.status == 0 then 
				GetElement(self.m_root, "armScoreBox" .. (tResult.scoreType + 1) .. "_WndSeafarRoad", WZArmature):setVisible(true)
			else
				GetElement(self.m_root, "armScoreBox" .. (tResult.scoreType + 1) .. "_WndSeafarRoad", WZArmature):setVisible(false)
				local imgScoreBox = GetElement(self.m_root, "imgScoreBox" .. (tResult.scoreType + 1) .. "_WndSeafarRoad", WZUIImage)
				imgScoreBox:setFile(nullBox[tResult.scoreType + 1])
			end
			self.m_tScoreConfig[tResult.scoreType + 1].lastStatus = tResult.status
		end
	elseif doType == 5 then --获取海神之印星级
		local tResult = json.decode(jsonData)
		WZLog("WndSeafarRoad:_onGetOtherData 55", Serialize(tResult))
		self:_ShowStar(tResult.star)
	elseif doType == 6 then --传承
		local tResult = json.decode(jsonData)
		WZLog("WndSeafarRoad:_onGetOtherData 666", Serialize(tResult))
		if result == 0 then 
			self:_ShowStar(tResult.star)
		end
	elseif doType == 7 then --领取全服踏青奖励
		local tResult = json.decode(jsonData)
		WZLog("WndSecretTower:_onGetOtherData 666", Serialize(tResult))
		if result == 1 then 
			WndRewardShow:showById(tResult.itemIds, tResult.itemNums)
			self.m_nGiftRewardNum = 0
			self:showBagGiftInfo()
		end
	elseif doType == 8 then 
		local tResult = json.decode(jsonData)
		if result == 0 then 
			local tTempList = nil 
			local nTag = 2 
			if tResult.pool == 1 then 
				nTag = 2 
				tTempList = self.m_tBigRewardList[2]
			elseif tResult.pool == 2 then 
				nTag = 4 
				tTempList = self.m_tBigRewardList[3]
			end
			tTempList.chooseState[tResult.id + 1] = tResult.status
			if tResult.status == 1 then 
				WndJoinReward:chooseReturn(nTag, tResult.id + 1, tResult.status)
			end
		elseif result == 1 then
			MsgBoxManager:showTipBox(LocalStrings.SUMMERSURF_TEXT1[24])
		end
	end
end

--@brief	缓存推送更新物品时调用的函数
function WndSeafarRoad:updatePlayerItemData()
	WZLog("WndSeafarRoad:updatePlayerItemData")
	if self.m_root ~= nil then
		self:_updateLightNum()
	end
end

--@brief 	设置射箭的状态
function WndSeafarRoad:setOpenState(state)
	-- body
	if self.m_root == nil then return end 

	self.m_bOpenState = state
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	关闭抽奖奖励展示界面回调
function WndSeafarRoad:_afterCloseReward()
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

	local tOtherReward = {}
	if self.m_tOpenResult.killPirateRewards and #self.m_tOpenResult.killPirateRewards > 0 then 
		table.insert(tOtherReward, self.m_tOpenResult.killPirateRewards)
	end
	if self.m_tOpenResult.firstZLRewards and #self.m_tOpenResult.firstZLRewards > 0 then 
		table.insert(tOtherReward, self.m_tOpenResult.firstZLRewards)
	end
	if self.m_tOpenResult.normalZLRewards and #self.m_tOpenResult.normalZLRewards > 0 then 
		table.insert(tOtherReward, self.m_tOpenResult.normalZLRewards)
	end

	if self.m_tOpenResult.normalRewards and #self.m_tOpenResult.normalRewards > 0 then 
		WndHoraryBigReward:showInterface(8, self.m_tOpenResult.normalRewards, tBigReward, tOtherReward)
	elseif #tBigReward > 0 then 
		WndHoraryBigReward:showInterface(9, tBigReward)
	end
end

--@brief 	解析大奖数据
function WndSeafarRoad:_analyzeBigReward()
	-- body
	local sBigReward = self.m_tContent.firstRewards
	local array = SplitStringWithSeparator(sBigReward, "&")
	local nSex = CacheCenter:getPlayerInfo().sex
	local tItem = {reward_ids1 = {}, reward_nums1 = {}, name = LocalStrings.SEAFARROAD_TEXT1[8]}
	self.m_tBigRewardList = {}
	for i = 1, #array do
--		WZLog("WndSeafarRoad:_analyzeBigReward", string.sub(array[i], 2, -2))
		local string = string.sub(array[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string,",")[3])

		table.insert(tItem.reward_ids1, id)
		table.insert(tItem.reward_nums1, num)
	end

	self.m_tBigRewardList[1] = tItem

	local specialReward = self.m_tContent.superRewards
	local array1 = SplitStringWithSeparator(specialReward, "&")
	local tItem1 = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.SEAFARROAD_TEXT1[9] }
	for i = 1, #array1 do
--		WZLog("WndSeafarRoad:_analyzeBigReward", string.sub(array1[i], 2, -2))
		local string = string.sub(array1[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string, ",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string, ",")[3])
		
		table.insert(tItem1.reward_ids2, id)
		table.insert(tItem1.reward_nums2, num)
	end

	self.m_tBigRewardList[2] = tItem1

	local specialReward2 = self.m_tContent.normalRewards
	local array2 = SplitStringWithSeparator(specialReward2, "&")
	local tItem2 = {reward_ids = {}, reward_nums = {}, name = LocalStrings.SEAFARROAD_TEXT1[10]}
	for i = 1, #array2 do
--		WZLog("WndMidnightDiner:_analyzeBigReward", string.sub(array2[i], 2, -2))
		local string = string.sub(array2[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string, ",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string, ",")[3])
		
		table.insert(tItem2.reward_ids, id)
		table.insert(tItem2.reward_nums, num)
	end

	self.m_tBigRewardList[3] = tItem2
end


-------------------------------------私有方法模块End----------------------------------------
