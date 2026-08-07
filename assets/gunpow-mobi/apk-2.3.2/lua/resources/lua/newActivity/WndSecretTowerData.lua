--WndSecretTowerData.lua
--@brief	WndSecretTower的数据模块
--@date		2022/07/21
--@author	XTX
--@note		秘境闯塔活动

WndSecretTower = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSecretTower:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_tBigRewardList = nil 		--大奖和特奖奖励
	self.m_bOpenState = false 
	self.m_tOpenResult = nil 
	self.m_nCoinId = 160288
	self.m_nMaxOpTimes = 20 			--最大一次抽奖次数
	self.m_nCount = 0 					--当天累计抽奖次数
	self.m_nLiveGiftNum = 0 			--生门礼包数量
	self.m_nDeadGiftNum = 0 			--死门礼包数量
	self.m_nCurFloor 	= 0 			--当前所在的塔层
	self.m_nCurTowerValue 	= 0 			--当前闯塔值
	self.m_nFullTowerValue 	= 100 			--当前塔层闯塔值上限
	self.m_tFloorRewards = nil 			--当前塔层奖励
	self.m_tTopPlayerInfo = nil 		--最上层玩家的信息
	self.m_tLiveReward = nil   			--触发的生门奖励
	self.m_tBraveCostConfig = nil     	--无视死门需扣除进度,氪金勇闯消耗Id,消耗数量
	self.m_nLastShowFloor = 0 				--上一次刷新的楼层
	self.m_bIsFirstIn = true 			--首次进入游戏
	self.m_bIsHappenDeadDoor = false 			--是否触发死门事件
	self.m_tEightTaskData = nil 		--八卦方位数据
	self.m_nMyScore = 0 				--我的积分
	self.m_nChooseReward = 0 		--选择奖励状态0：弹出预览界面；1：不弹
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSecretTower:_unInit()
	self.m_root = nil
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_tBigRewardList = nil 		--大奖和特奖奖励
	self.m_bOpenState = nil 
	self.m_tOpenResult = nil 
	self.m_nCoinId = nil
	self.m_nMaxOpTimes = nil 			--最大一次抽奖次数
	self.m_nCount = nil 
	self.m_nLiveGiftNum = nil 			--生门礼包数量
	self.m_nDeadGiftNum = nil 			--死门礼包数量
	self.m_nCurFloor 	= nil 			--当前所在的塔层
	self.m_nCurTowerValue 	= nil 		--当前闯塔值
	self.m_nFullTowerValue 	= nil 		--当前塔层闯塔值上限
	self.m_tFloorRewards = nil
	self.m_tTopPlayerInfo = nil
	self.m_tLiveReward = nil   			--触发的生门奖励
	self.m_tBraveCostConfig = nil     	--氪金勇闯消耗
	self.m_nLastShowFloor = nil 
	self.m_bIsFirstIn = nil 
	self.m_bIsHappenDeadDoor = nil 
	self.m_tEightTaskData = nil 		--八卦方位数据
	self.m_nMyScore = nil  				--我的积分
	self.m_nChooseReward = nil 		--选择奖励状态0：弹出预览界面；1：不弹
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSecretTower:createElement()
	if WndSecretTower.m_root ~= nil then
		WindowManager:removeWindow(WndSecretTower.m_root, WndSecretTower, true)
	end
	local element = WZUISystem:getInstance():createElement("WndSecretTower")
	assert(element, "WndSecretTower create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndSecretTower:showInterface()
	LoadNewActivityRes(true)
	local wndWater = WndSecretTower:createElement()
	if wndWater then 
		WindowManager:addWindow(wndWater, WndSecretTower, false)
	end
end

--@brief 	获取活动详情成功
function WndSecretTower:GetActivityInfoOK(activityId,maxCount,count,status, rewardCounts, rewardItems, rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	-- body
	WZLog("WndSecretTower:GetActivityInfoOK", g_cityExtenInfo.activity7052, activityId, content, Serialize(finishCondition))
	if g_cityExtenInfo.activity7052 == activityId then 
		self.m_tContent = json.decode(content)
		self.m_nStartTime = startTime 
		self.m_nEndTime = endTime 
		self.m_nActivityId = activityId
		self.m_nCount = count
		self.m_tBraveCostConfig = finishCondition
		self.m_nChooseReward = GetOperateTimes("SECRETTOWERACTIVITYID", self.m_nActivityId) 

		self:_analyzeBigReward()
		self:_update()
		if self.m_bIsFirstIn then 
			if self.m_bIsHappenDeadDoor then 
				self.m_bIsFirstIn = false 
				self:_showDeadSituation()
			end
		end
	end
end

--@brief 	获取其他活动数据
function WndSecretTower:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end 

	if doType == 1 then --额外信息 
		local tResult = json.decode(jsonData)
		WZLog("WndSecretTower:_onGetOtherData 111", Serialize(tResult))
		self.m_tFloorRewards = {} 			--当前塔层奖励
		for i = 1, #tResult.lvRewardIds do
			local tItem = {}
			tItem[1] = tResult.lvRewardIds[i]
			tItem[2] = tResult.lvRewardNums[i]

			table.insert(self.m_tFloorRewards, tItem)
		end
		if tResult.zfItemId and tResult.zfItemId > 0 then 
			local tItem = {}
			tItem[1] = tResult.zfItemId 
			tItem[2] = 1

			table.insert(self.m_tFloorRewards, tItem)
		end

		self.m_nLiveGiftNum = tResult.eventReward[1] 			--生门礼包数量
		self.m_nDeadGiftNum = tResult.eventReward[2] 			--死门礼包数量
		self.m_nCurFloor 	= tResult.level + 1			--当前所在的塔层
		self.m_nCurTowerValue 	= tResult.progress 			--当前闯塔值
		self.m_nFullTowerValue 	= tResult.target 			--当前塔层闯塔值上限
		--触发死门事件
		if tResult.deadEventState and tResult.deadEventState == 1 then 
			self.m_bIsHappenDeadDoor = true
			if self.m_bIsFirstIn then 
				if self.m_tBraveCostConfig ~= nil then 
					self.m_bIsFirstIn = false 
					self:_showDeadSituation()
				end
			end
		end
		--更新楼层奖励，楼层数，礼包数
		self:_updateCurTowerData()
		if tResult.point then 
			self.m_nMyScore = tResult.point 
			if self.m_tTopPlayerInfo == nil or self.m_tTopPlayerInfo.id == nil or self.m_tTopPlayerInfo.floorNum < self.m_nMyScore then 
				ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(g_cityExtenInfo.activity7052, 1)
			end
		end
	elseif doType == 2 then --大奖限量
		local tResult = json.decode(jsonData)
		local nSex = CacheCenter:getPlayerInfo().sex
		local sBigReward = tResult.rewards
		local array = SplitStringWithSeparator(sBigReward, "&")
		local tItem = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.SECRETTOWER_TEXT1[8], strAtt = LocalStrings.GONGANDDRUM_TEXT1[16], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31}
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
		WndJoinReward:showInterface("", self.m_tBigRewardList[1], self.m_tBigRewardList[2], LocalStrings.SECRETTOWER_TEXT1[15], false, 2, otherData, 2)
	elseif doType == 3 then --开启结果
		local tResult = json.decode(jsonData)
		WZLog("WndSecretTower:_onGetOtherData 333", Serialize(tResult))
		self.m_tOpenResult = {}

		self.m_tOpenResult.normalRewards = {} --常规奖
		self.m_tOpenResult.towerRewards = {} --通关奖
		self.m_tOpenResult.firstRewards = {} --一等奖
		self.m_tOpenResult.bigRewards = {} --特等奖
		self.m_tLiveReward = {}

		
		--普通奖
		for j = 1, #tResult.itemIds do
			local tItem = {}

			tItem.itemId = tResult.itemIds[j]
			tItem.itemNum = tResult.itemNums[j]
			tItem.type = 1

			table.insert(self.m_tOpenResult.normalRewards, tItem)
		end
		--通关奖励
		if tResult.pItemIds and #tResult.pItemIds > 0 then 
			for j = 1, #tResult.pItemIds do
				local tItem = {}

				tItem.itemId = tResult.pItemIds[j]
				tItem.itemNum = tResult.pItemNums[j]
				tItem.type = 2
				tItem.floor = self.m_nCurFloor - 1

				table.insert(self.m_tOpenResult.towerRewards, tItem)
			end
		end
		--一等奖
		for j = 1, #tResult.fItemIds do
			local tItem = {}

			tItem.itemId = tResult.fItemIds[j]
			tItem.itemNum = tResult.fItemNums[j]
			tItem.type = 3

			table.insert(self.m_tOpenResult.firstRewards, tItem)
		end
		--特等奖
		for j = 1, #tResult.sItemIds do
			local tItem = {}

			tItem.itemId = tResult.sItemIds[j]
			tItem.itemNum = tResult.sItemNums[j]
			tItem.type = 18

			table.insert(self.m_tOpenResult.bigRewards, tItem)
		end
		--触发生门奖励
		if tResult.eItemIds and #tResult.eItemIds > 0 then 
			for j = 1, #tResult.eItemIds do
				local tItem = {}

				tItem.itemId = tResult.eItemIds[j]
				tItem.itemNum = tResult.eItemNums[j]
				tItem.type = 5 

				table.insert(self.m_tLiveReward, tItem)
			end
		end

		if result == 1 then 
			if self.m_nCount > 0 then self.m_nCount = 0 end 
			if tResult.eventReward then 
				self.m_nLiveGiftNum = tResult.eventReward[1] 			--生门礼包数量
				self.m_nDeadGiftNum = tResult.eventReward[2] 			--死门礼包数量
				self:showGiftInfo()
			end
			if tResult.progress then 
				self.m_nCurTowerValue = tResult.progress
				self:_showTowerValue()
			end
			if tResult.deadEventState and tResult.deadEventState == 1 then 
				self.m_bIsHappenDeadDoor = true
			end

			self:showOpenAction()
			self:_setFreeBtnText()
		else
			self:setOpenState(false)
		end
	elseif doType == 4 then --获取八卦方位数据
		local tResult = json.decode(jsonData)
		WZLog("WndSecretTower:_onGetOtherData 444", Serialize(tResult))
		if result == 1 then 
			self.m_tEightTaskData = {}

			local nSex = CacheCenter:getPlayerInfo().sex
			local nIndex = 0
			local nIndex1 = 0 
			for i = 1, #tResult.ids do
				local tItem = {}

				tItem.id = tResult.ids[i]
				tItem.reward = {}
				local nCount = tResult.split[i]
				for j = nIndex + 1, nCount + nIndex do
					local tItem1 = {}
					if nSex == 0 then 
						tItem1[1] = tResult.boyItemIds[j]
					else
						tItem1[1] = tResult.girlItemIds[j]
					end
					tItem1[2] = tResult.nums[j]

					table.insert(tItem.reward, tItem1)
				end
				nIndex = nIndex + nCount

				tItem.cost = {}
				local nCount1 = tResult.split2[i]
				for j = nIndex1 + 1, nCount1 + nIndex1 do
					local tItem1 = {}
					tItem1[1] = tResult.costItemIds[j]
					tItem1[2] = tResult.costNums[j]

					table.insert(tItem.cost, tItem1)
				end
				nIndex1 = nIndex1 + nCount1

				table.insert(self.m_tEightTaskData, tItem)
			end

			self:_checkEightRedDot()
		end
	elseif doType == 5 then --领取八卦方位兑换奖励
		local tResult = json.decode(jsonData)
		WZLog("WndSecretTower:_onGetOtherData 555", Serialize(tResult))
		if result == 0 then 
			WndRewardShow:showById(tResult.itemIds, tResult.itemNums)
		end
	elseif doType == 6 then --死门事件处理结果
		local tResult = json.decode(jsonData)
		WZLog("WndSecretTower:_onGetOtherData 666", Serialize(tResult))
		if result == 1 then 
			self.m_tOpenResult = {}
			self.m_tOpenResult.towerRewards = {} --通关奖
			self.m_tLiveReward = {}
			self.m_bIsHappenDeadDoor = false 
			GetElement(self.m_root, "conDead_WndSecretTower", WZUIContainer):setVisible(false)

			if tResult.progress then 
				self.m_nCurTowerValue = tResult.progress
				self:_showTowerValue()
			end
			--通关奖励
			if tResult.pItemIds and #tResult.pItemIds > 0 then 
				for j = 1, #tResult.pItemIds do
					local tItem = {}

					tItem.itemId = tResult.pItemIds[j]
					tItem.itemNum = tResult.pItemNums[j]
					tItem.type = 2
					tItem.floor = self.m_nCurFloor - 1

					table.insert(self.m_tOpenResult.towerRewards, tItem)
				end
			end
			--触发生门奖励
			if tResult.eItemIds and #tResult.eItemIds > 0 then 
				for j = 1, #tResult.eItemIds do
					local tItem = {}

					tItem.itemId = tResult.eItemIds[j]
					tItem.itemNum = tResult.eItemNums[j]
					tItem.type = 5 

					table.insert(self.m_tLiveReward, tItem)
				end
			end
			if #self.m_tOpenResult.towerRewards > 0 then 
				self:_afterCloseReward()
			else
				if #self.m_tLiveReward > 0 then 
					self:_showLiveReward()
				else
					pushEquipInList()
				end
			end
		end
		self:setOpenState(false)
	elseif doType == 7 then --领取生死门礼包奖励
		local tResult = json.decode(jsonData)
		WZLog("WndSecretTower:_onGetOtherData 777", Serialize(tResult))
		if result == 1 then 
			WndRewardShow:showById(tResult.itemIds, tResult.itemNums)
			self.m_nLiveGiftNum = tResult.eventReward[1] 			--生门礼包数量
			self.m_nDeadGiftNum = tResult.eventReward[2] 			--死门礼包数量
			self:showGiftInfo()
		end
		self:setOpenState(false)
	elseif doType == 10 then 
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
function WndSecretTower:updatePlayerItemData()
	WZLog("WndSecretTower:updatePlayerItemData")
	if self.m_root ~= nil then
		self:_updateLightNum()
		self:_setFreeBtnText()
		self:_checkEightRedDot()
	end
end

--@brief 	设置射箭的状态
function WndSecretTower:setOpenState(state)
	-- body
	if self.m_root == nil then return end 

	self.m_bOpenState = state
end

--@brief 	获取八卦方位数据
function WndSecretTower:getEightPragramData()
	return self.m_tEightTaskData
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	关闭抽奖奖励展示界面回调
function WndSecretTower:_afterCloseReward()
	if self.m_root == nil then return end 

	local tReward = {}
	if self.m_tOpenResult then 
		if self.m_tOpenResult.normalRewards and #self.m_tOpenResult.normalRewards > 0 then 
			table.insert(tReward, self.m_tOpenResult.normalRewards)
		end
		if self.m_tOpenResult.towerRewards and #self.m_tOpenResult.towerRewards > 0 then 
			table.insert(tReward, self.m_tOpenResult.towerRewards)
		end
		if self.m_tOpenResult.firstRewards and #self.m_tOpenResult.firstRewards > 0 then 
			table.insert(tReward, self.m_tOpenResult.firstRewards)
		end
		if self.m_tOpenResult.bigRewards and #self.m_tOpenResult.bigRewards > 0 then 
			table.insert(tReward, self.m_tOpenResult.bigRewards)
		end
	end 
	if #tReward > 0 then 
		WndHoraryBigReward:showInterface(17, tReward)
		if self.m_bIsHappenDeadDoor then 
			WndHoraryBigReward:setCallback(self, self._showDeadSituation)
		else
			if self.m_tLiveReward and #self.m_tLiveReward > 0 then 
				WndHoraryBigReward:setCallback(self, self._showLiveReward)
			end
		end
	end
end

--@brief 	解析大奖数据
function WndSecretTower:_analyzeBigReward()
	-- body
	local sBigReward = self.m_tContent.firstRewards
	local array = SplitStringWithSeparator(sBigReward, "&")
	local nSex = CacheCenter:getPlayerInfo().sex
	local tItem = {reward_ids1 = {}, reward_nums1 = {}, name = LocalStrings.SECRETTOWER_TEXT1[7]}
	self.m_tBigRewardList = {}
	for i = 1, #array do
--		WZLog("WndSecretTower:_analyzeBigReward", string.sub(array[i], 2, -2))
		local string = string.sub(array[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string,",")[3])

		table.insert(tItem.reward_ids1, id)
		table.insert(tItem.reward_nums1, num)
	end

	self.m_tBigRewardList[1] = tItem

	local specialReward = self.m_tContent.superRewards
	local array1 = SplitStringWithSeparator(specialReward, "&")
	local tItem1 = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.SECRETTOWER_TEXT1[8]}
	for i = 1, #array1 do
--		WZLog("WndSecretTower:_analyzeBigReward", string.sub(array1[i], 2, -2))
		local string = string.sub(array1[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string, ",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string, ",")[3])
		
		table.insert(tItem1.reward_ids2, id)
		table.insert(tItem1.reward_nums2, num)
	end

	self.m_tBigRewardList[2] = tItem1
end

--@brief 	设置最上层玩家数据
function WndSecretTower:_setTopPlayerInfo(tData)
	self.m_tTopPlayerInfo = {}	
	
	self.m_tTopPlayerInfo.id = tData.playerId
	self.m_tTopPlayerInfo.name = tData.name
	self.m_tTopPlayerInfo.sex = tData.sex
	self.m_tTopPlayerInfo.vipLevel = tData.vipLevel
	self.m_tTopPlayerInfo.headColor = tData.headColor
	self.m_tTopPlayerInfo.headId = tData.headId
	self.m_tTopPlayerInfo.faceId = tData.faceId
	self.m_tTopPlayerInfo.floorNum = tData.point
	self.m_tTopPlayerInfo.serverId = tData.serverId
	self.m_tTopPlayerInfo.headEffectId = 0

	self:_showTopPlayer()
end

function WndSecretTower:_onRankResult(activityId, activityType, rankingType, myPoint, myRanking, rewardConfig, playerIds, ranks, points, nickname, headIds, 
								   headColors, faceIds, sexs, vipLevel, level, bodyIds, wingIds, title, serverId, session, settlementDate)
	self:setRankListData(activityId,myPoint,rewardConfig,playerIds,level,points,nickname,faceIds,headIds, headColors, sexs, title, vipLevel, rankingType, 
		myRanking, serverId, session, settlementDate)
end

function WndSecretTower:setRankListData(activityId,myPoint,rewardConfig,playerIds,level,points,nickname,faceIds,headIds, headColors, sexs, title, vipLevel, 
	rankingType, myRanking, serverId, session, settlementDate)
	if activityId == self.m_nActivityId then
		if not rewardConfig or rewardConfig == "" then
			return
		end

		rewardConfig = json.decode(rewardConfig)
		if not rewardConfig then return end
		WZLog("WndSecretTower:setRankListData", Serialize(rewardConfig))
		if next(playerIds) == nil then
			return
		end

		local tData, myCurRank = WndShopRank:setRankData(rewardConfig, playerIds, level, points, nickname, faceIds, headIds, headColors, sexs, nil, nil, title, vipLevel, self.m_nRankType, rankingType, serverId)
		
		self:_setTopPlayerInfo(tData[1])
	end
end
-------------------------------------私有方法模块End----------------------------------------
