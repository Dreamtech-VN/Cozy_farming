--WndBowlingData.lua
--@brief	WndBowling的数据模块
--@date		2022/04/21
--@author	XTX
--@note		保龄球活动主界面

WndBowling = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndBowling:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_tBigRewardList = nil 		--大奖和特奖奖励
	self.m_bOpenState = false 
	self.m_tOpenResult = nil 
	self.m_nCoinId = 160258
	self.m_nCount = 0  					--当天累计抽奖次数
	self.m_nLastTalkIndex = 0 		--上一次tips索引
	self.m_nTalkGapping = nil 		--说话间隔
	self.m_nBowlType = 0 			--0：初级场；1：高级场
	self.m_nPaintedEggTime = -1 		--彩蛋奖励倒计时
	self.m_nPaintedEggTimesLeft = 0 --距离触发彩蛋奖励还差多少次抽奖
	self.m_nPaintedTimeLimit = 20 	--触发彩蛋提醒界限
	self.m_nHighTypeCostTimes = 2 	--高级场消耗倍数
	self.m_nRefreshTime = 0 		--定时刷新时间间隔S
	self.m_tBallAniName = {{"wait_J","hit_1_J","wait_J1","hit_2_J"}, {"wait_J2","hit_1_S","wait_S2","hit_2_S"}}
	self.m_PaintedTimeAniIndex = 0  --彩蛋时刻动画索引
	self.m_bIsFirstIn = true 		
	self.m_nChooseReward = 0 		--选择奖励状态0：弹出预览界面；1：不弹
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndBowling:_unInit()
	self.m_root = nil
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_tBigRewardList = nil 		--大奖和特奖奖励
	self.m_bOpenState = nil 
	self.m_tOpenResult = nil 
	self.m_nCoinId = nil
	self.m_nCount = nil  					--当天累计抽奖次数
	self.m_nLastTalkIndex = nil 		--上一次tips索引
	self.m_nTalkGapping = nil 
	self.m_nBowlType = nil 
	self.m_nPaintedEggTime = nil 		--彩蛋奖励倒计时
	self.m_nPaintedEggTimesLeft = nil --距离触发彩蛋奖励还差多少次抽奖
	self.m_nPaintedTimeLimit = nil  	--触发彩蛋提醒界限
	self.m_nHighTypeCostTimes = nil 	--高级场消耗倍数
	self.m_nRefreshTime = nil 
	self.m_tBallAniName = nil 
	self.m_PaintedTimeAniIndex = nil  --彩蛋时刻动画索引
	self.m_bIsFirstIn = nil 
	self.m_nChooseReward = nil 		--选择奖励状态0：弹出预览界面；1：不弹
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndBowling:createElement()
	if WndBowling.m_root ~= nil then
		WindowManager:removeWindow(WndBowling.m_root, WndBowling, true)
	end
	local element = WZUISystem:getInstance():createElement("WndBowling")
	assert(element, "WndBowling create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndBowling:showInterface()
	LoadNewActivityRes(true)
	local wndWater = WndBowling:createElement()
	if wndWater then 
		WindowManager:addWindow(wndWater, WndBowling, false)
	end
end

--@brief 	获取活动详情成功
function WndBowling:GetActivityInfoOK(activityId,maxCount,count,status, rewardCounts, rewardItems, rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	-- body
	WZLog("WndBowling:GetActivityInfoOK", g_cityExtenInfo.activity7049, activityId, content)
	if g_cityExtenInfo.activity7049 == activityId then 
		self.m_tContent = json.decode(content)
		WZLog("WndBowling:GetActivityInfoOK", Serialize(self.m_tContent))
		self.m_nStartTime = startTime 
		self.m_nEndTime = endTime 
		self.m_nActivityId = activityId
		self.m_nCount = count
		self.m_nHighTypeCostTimes = maxCount
		self.m_nChooseReward = GetOperateTimes("BOWLINGACTIVITYID", self.m_nActivityId) 

		self:_analyzeBigReward()
		self:_update()
	end
end

--@brief 	获取其他活动数据
function WndBowling:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end 

	if doType == 1 then --彩蛋状态
		local tResult = json.decode(jsonData)
		self.m_nPaintedEggTimesLeft = tResult.target - tResult.progress
		self.m_nPaintedTimeLimit = tResult.tipNum
		self.m_nPaintedEggTime = tResult.endTime - SystemTime:getServerTime()
		WZLog("WndBowling:_onGetOtherData", self.m_nPaintedEggTimesLeft, self.m_nPaintedTimeLimit, self.m_nPaintedEggTime)
		self:_showPaintedEgg()
		if self.m_bIsFirstIn then 
			self.m_bIsFirstIn = false 
			self:_setBowlingPlayAni(1, true)
		end
	elseif doType == 2 then --大奖限量
		local tResult = json.decode(jsonData)
		local nSex = CacheCenter:getPlayerInfo().sex
		local sBigReward = tResult.rewards
		local array = SplitStringWithSeparator(sBigReward, "&")
		local tItem = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.BOWLING_TEXT1[8], strAtt = LocalStrings.GONGANDDRUM_TEXT1[16], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31, pool = tResult.pool}
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

			table.insert(tItem.reward_ids2, id)
			table.insert(tItem.reward_nums2, num)
		end
		self.m_tBigRewardList[2] = tItem

		local otherData = {}
		otherData.winType = 1
		otherData.activityId = self.m_nActivityId
		WndJoinReward:showInterface("", self.m_tBigRewardList[1], self.m_tBigRewardList[2], LocalStrings.TREASURE_TEXT7, true, 2, otherData, 2)
	elseif doType == 3 then --开启结果
		local tResult = json.decode(jsonData)
		WZLog("WndBowling:_onGetOtherData", Serialize(tResult))
		self.m_tOpenResult = {}

		self.m_tOpenResult.normalRewards = {itemIds = {}, itemNums = {}} --常规奖
		self.m_tOpenResult.firstRewards = {} --一等奖
		self.m_tOpenResult.bigRewards = {} --特等奖
		self.m_tOpenResult.nScore = 0 
		self.m_tOpenResult.target = tResult.bottleDownNum

		local rewardType = 6 
		if tResult.extItemNums and #tResult.extItemNums > 0 then 
			rewardType = 7
		end
		for i = 1, #tResult.itemNums do
			local tItem = {}
			tItem.itemId = tResult.itemIds[i]
			tItem.itemNum = tResult.itemNums[i]
			tItem.type = rewardType
			table.insert(self.m_tOpenResult.normalRewards, tItem)
		end
		if tResult.extItemNums and #tResult.extItemNums > 0 then 
			for i = 1, #tResult.extItemNums do
				local tItem = {}
				tItem.itemId = tResult.itemIds[i]
				tItem.itemNum = tResult.extItemNums[i]
				tItem.type = rewardType
				table.insert(self.m_tOpenResult.normalRewards, tItem)
			end
		end

		--一等奖
		for j = 1, #tResult.fItemIds do
			local tItem = {}

			tItem.itemId = tResult.fItemIds[j]
			tItem.itemNum = tResult.fItemNums[j]
			tItem.type = 4

			table.insert(self.m_tOpenResult.firstRewards, tItem)
		end
		--特等奖
		for j = 1, #tResult.sItemIds do
			local tItem = {}

			tItem.itemId = tResult.sItemIds[j]
			tItem.itemNum = tResult.sItemNums[j]
			tItem.type = 5

			table.insert(self.m_tOpenResult.bigRewards, tItem)
		end

		self.m_nRefreshTime = 0
		if result == 1 then 
			self.m_nCount = tResult.count
			self.m_tOpenResult.nScore = tResult.addPoint
			self.m_tOpenResult.medalNum = tResult.jnxzAdd   --勋章数量

			self:showOpenAction()
			self:_setFreeBtnText()
		else
			self:setOpenState(false)
		end
	elseif doType == 7 then 
		local tResult = json.decode(jsonData)
		if result == 0 then 
			local tTempList = nil 
			tTempList = self.m_tBigRewardList[2]
			tTempList.chooseState[tResult.id + 1] = tResult.status
			if tResult.status == 1 then 
				WndJoinReward:chooseReturn(2, tResult.id + 1, tResult.status)
			end
		elseif result == 1 then
			MsgBoxManager:showTipBox(LocalStrings.SUMMERSURF_TEXT1[24])
		end
	end
end

--@brief	缓存推送更新物品时调用的函数
function WndBowling:updatePlayerItemData()
	WZLog("WndBowling:updatePlayerItemData")
	if self.m_root ~= nil then
		self:_updateLightNum()
		self:showRedDot()
	end
end

--@brief 	设置射箭的状态
function WndBowling:setOpenState(state)
	-- body
	if self.m_root == nil then return end 

	self.m_bOpenState = state
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	关闭抽奖奖励展示界面回调
function WndBowling:_afterCloseReward()
	if self.m_root == nil then return end 

	local tBigReward = {}
	local nIndex = 1
	if #self.m_tOpenResult.firstRewards > 0 then 
		for i = 1, #self.m_tOpenResult.firstRewards do
			table.insert(tBigReward, self.m_tOpenResult.firstRewards[i])
		end
	end
	if #self.m_tOpenResult.bigRewards > 0 then 
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

--@brief 	解析大奖数据
function WndBowling:_analyzeBigReward()
	-- body
	local sBigReward = self.m_tContent.firstRewards
	local array = SplitStringWithSeparator(sBigReward, "&")
	local nSex = CacheCenter:getPlayerInfo().sex
	local tItem = {reward_ids1 = {}, reward_nums1 = {}, name = LocalStrings.BOWLING_TEXT1[7]}
	self.m_tBigRewardList = {}
	for i = 1, #array do
--		WZLog("WndBowling:_analyzeBigReward", string.sub(array[i], 2, -2))
		local string = string.sub(array[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string,",")[3])

		table.insert(tItem.reward_ids1, id)
		table.insert(tItem.reward_nums1, num)
	end

	self.m_tBigRewardList[1] = tItem

	local specialReward = self.m_tContent.superRewards
	local array1 = SplitStringWithSeparator(specialReward, "&")
	local tItem1 = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.BOWLING_TEXT1[8]}
	for i = 1, #array1 do
--		WZLog("WndBowling:_analyzeBigReward", string.sub(array1[i], 2, -2))
		local string = string.sub(array1[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string, ",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string, ",")[3])
		
		table.insert(tItem1.reward_ids2, id)
		table.insert(tItem1.reward_nums2, num)
	end

	self.m_tBigRewardList[2] = tItem1
end




-------------------------------------私有方法模块End----------------------------------------
