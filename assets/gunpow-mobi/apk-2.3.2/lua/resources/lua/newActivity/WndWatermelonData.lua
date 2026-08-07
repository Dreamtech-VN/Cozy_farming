--WndWatermelonData.lua
--@brief	WndWatermelon的数据模块
--@date		2022/06/24
--@author	XTX
--@note		夏日西瓜活动

WndWatermelon = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndWatermelon:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_tBigRewardList = nil 		--大奖和特奖奖励
	self.m_bOpenState = false 
	self.m_tOpenResult = nil 
	self.m_nCoinId = 160276
	self.m_nCoinId2 = 160277
	self.m_nGiftRewardNum = 0 			--全民吃瓜奖励数量
	self.m_nWatermelonType = 0 			--习惯类型0==麒麟西瓜；1黑美人；2=西瓜汁
	self.m_tCostTimes = {} 		    --一次需要消耗的币
	self.m_tAniAction = {{"wait_5", "wait_1", "wait_3"}, {"wait_6", "wait_2", "wait_4"}}
	self.m_bIsFirstIn = true
	self.m_nChooseReward = 0 		--选择奖励状态0：弹出预览界面；1：不弹
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndWatermelon:_unInit()
	self.m_root = nil
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_tBigRewardList = nil 		--大奖和特奖奖励
	self.m_bOpenState = nil 
	self.m_tOpenResult = nil 
	self.m_nCoinId = nil
	self.m_nGiftRewardNum = nil 
	self.m_nWatermelonType = nil 
	self.m_tCostTimes = nil 
	self.m_tAniAction = nil 
	self.m_bIsFirstIn = false
	self.m_nChooseReward = nil 		--选择奖励状态0：弹出预览界面；1：不弹
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndWatermelon:createElement()
	if WndWatermelon.m_root ~= nil then
		WindowManager:removeWindow(WndWatermelon.m_root, WndWatermelon, true)
	end
	local element = WZUISystem:getInstance():createElement("WndWatermelon")
	assert(element, "WndWatermelon create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndWatermelon:showInterface()
	LoadNewActivityRes(true)
	local wndWater = WndWatermelon:createElement()
	if wndWater then 
		WindowManager:addWindow(wndWater, WndWatermelon, false)
	end
end

--@brief 	获取活动详情成功
function WndWatermelon:GetActivityInfoOK(activityId,maxCount,count,status, rewardCounts, rewardItems, rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	-- body
	WZLog("WndWatermelon:GetActivityInfoOK", g_cityExtenInfo.activity7051, activityId, content)
	if g_cityExtenInfo.activity7051 == activityId then 
		self.m_tContent = json.decode(content)
		self.m_nStartTime = startTime 
		self.m_nEndTime = endTime 
		self.m_nActivityId = activityId
		self.m_nGiftRewardNum = count
		self.m_tCostTimes = finishCondition
		self.m_nChooseReward = GetOperateTimes("WATERMELONACTIVITYID", self.m_nActivityId) 

		self:_analyzeBigReward()
		self:_update()
	end
end

--@brief 	获取其他活动数据
function WndWatermelon:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end 

	if doType == 2 then --大奖限量
		local tResult = json.decode(jsonData)
		local nSex = CacheCenter:getPlayerInfo().sex
		local sBigReward = tResult.rewards
		local array = SplitStringWithSeparator(sBigReward, "&")
		local tItem = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.WATERMELON_TEXT1[20], strAtt = LocalStrings.GONGANDDRUM_TEXT1[16], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31}
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
		WndJoinReward:showInterface("", self.m_tBigRewardList[1], self.m_tBigRewardList[2], LocalStrings.TREASURE_TEXT7, false, 2, otherData, 2)
	elseif doType == 3 then --开启结果
		local tResult = json.decode(jsonData)
		WZLog("WndWatermelon:_onGetOtherData", Serialize(tResult))
		self.m_tOpenResult = {}

		self.m_tOpenResult.normalRewards = {itemIds = {}, itemNums = {}} --常规奖
		self.m_tOpenResult.firstRewards = {} --一等奖
		self.m_tOpenResult.bigRewards = {} --特等奖

		self.m_tOpenResult.normalRewards.itemIds = tResult.itemIds
		self.m_tOpenResult.normalRewards.itemNums = tResult.itemNums

		--一等奖
		for j = 1, #tResult.fItemIds do
			local tItem = {}

			tItem.itemId = tResult.fItemIds[j]
			tItem.itemNum = tResult.fItemNums[j]
			tItem.type = 16

			table.insert(self.m_tOpenResult.firstRewards, tItem)
		end
		--特等奖
		for j = 1, #tResult.sItemIds do
			local tItem = {}

			tItem.itemId = tResult.sItemIds[j]
			tItem.itemNum = tResult.sItemNums[j]
			tItem.type = 17

			table.insert(self.m_tOpenResult.bigRewards, tItem)
		end

		if result == 1 then 
			self.m_tOpenResult.medalNum = tResult.extItemNums   --西瓜块数量
			self.m_nGiftRewardNum = tResult.globalReward

			self:showOpenAction()
			self:_setFreeBtnText()
			self:showBagGiftInfo()
		else
			self:setOpenState(false)
		end
	elseif doType == 4 then --自选奖池
		local tResult = json.decode(jsonData)
		WZLog("WndWatermelon:_onGetOtherData 44", Serialize(tResult))
		if result == 1 then 
			WndWatermelonShake:setRewardPoolData(tResult.shopType, tResult)
		end
	elseif doType == 5 then --自选奖池领取
		local tResult = json.decode(jsonData)
		WZLog("WndWatermelon:_onGetOtherData 55", Serialize(tResult))
		if result == 0 then 
			WndWatermelonShake:getPoolRewardOK(tResult)
		end
	elseif doType == 6 then --全服奖励
		local tResult = json.decode(jsonData)
		WZLog("WndWatermelon:_onGetOtherData 66", Serialize(tResult))
		if result == 1 then 
			self.m_nGiftRewardNum = 0
			WndRewardShow:showById(tResult.itemIds,tResult.itemNums)
			self:showBagGiftInfo()
		end
	elseif doType == 7 or doType == 8 then --获取和刷新摇摇乐奖励
		local tResult = json.decode(jsonData)
		WZLog("WndWatermelon:_onGetOtherData 7788", Serialize(tResult))
		if result == 1 then 
			WndWatermelonShake:setShakeRewardData(tResult.itemIds, tResult.itemNums, tResult.dailyRefreshCount, tResult.yylConfig)
		end
	elseif doType == 9 then --摇摇乐抽奖
		local tResult = json.decode(jsonData)
		WZLog("WndWatermelon:_onGetOtherData 99", Serialize(tResult))
		if result == 1 then 
			local tItem = {id = {}, num = {}, playerItemId = {}}
			local nIndex = 1
			for j = 1, #tResult.itemIds do
				if tResult.itemIds[j] ~= 160279 and tResult.itemIds[j] ~= 160285 then 
					tItem.id[nIndex] = tResult.itemIds[j]
					tItem.num[nIndex] = tResult.itemNums[j]
					tItem.playerItemId[nIndex] = tResult.playerItemIds[j]

					nIndex = nIndex + 1
				end
			end
			WndRewardShow:showById(tItem.id, tItem.num, nil, nil, nil, nil, nil, nil, nil, nil, nil, tItem.playerItemId)
			WndWatermelonShake:setOpenState(false)
		end
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
function WndWatermelon:updatePlayerItemData()
	WZLog("WndWatermelon:updatePlayerItemData")
	if self.m_root ~= nil then
		self:_updateLightNum()
		self:showRedDot()
	end
end

--@brief 	设置射箭的状态
function WndWatermelon:setOpenState(state)
	-- body
	if self.m_root == nil then return end 

	self.m_bOpenState = state
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	关闭抽奖奖励展示界面回调
function WndWatermelon:_afterCloseReward()
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

	if #tBigReward > 0 then 
		WndHoraryBigReward:showInterface(6, tBigReward)
	end
end

--@brief 	解析大奖数据
function WndWatermelon:_analyzeBigReward()
	-- body
	local sBigReward = self.m_tContent.firstRewards
	local array = SplitStringWithSeparator(sBigReward, "&")
	local nSex = CacheCenter:getPlayerInfo().sex
	local tItem = {reward_ids1 = {}, reward_nums1 = {}, name = LocalStrings.WATERMELON_TEXT1[19]}
	self.m_tBigRewardList = {}
	for i = 1, #array do
--		WZLog("WndWatermelon:_analyzeBigReward", string.sub(array[i], 2, -2))
		local string = string.sub(array[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string,",")[3])

		table.insert(tItem.reward_ids1, id)
		table.insert(tItem.reward_nums1, num)
	end

	self.m_tBigRewardList[1] = tItem

	local specialReward = self.m_tContent.superRewards
	local array1 = SplitStringWithSeparator(specialReward, "&")
	local tItem1 = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.WATERMELON_TEXT1[20]}
	for i = 1, #array1 do
--		WZLog("WndWatermelon:_analyzeBigReward", string.sub(array1[i], 2, -2))
		local string = string.sub(array1[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string, ",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string, ",")[3])
		
		table.insert(tItem1.reward_ids2, id)
		table.insert(tItem1.reward_nums2, num)
	end

	self.m_tBigRewardList[2] = tItem1
end




-------------------------------------私有方法模块End----------------------------------------
