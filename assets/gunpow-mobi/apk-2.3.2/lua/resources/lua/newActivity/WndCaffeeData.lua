--WndCaffeeData.lua
--@brief	WndCaffee的数据模块
--@date		2022/04/21
--@author	XTX
--@note		咖啡大师活动主界面

WndCaffee = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCaffee:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_tBigRewardList = nil 		--大奖和特奖奖励
	self.m_bOpenState = false 
	self.m_tOpenResult = nil 
	self.m_nCoinId = 160255
	self.m_nCount = 0  					--当天累计抽奖次数
	self.m_nTimes = 0  					--可冲泡次数
	self.m_nLastTalkIndex = 0 		--上一次tips索引
	self.m_nTalkGapping = nil 		--咖啡师说话间隔
	self.m_bIsGrind = true 			--是否研磨按钮：true=研磨；false=冲泡
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCaffee:_unInit()
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
	self.m_nTimes = nil  					--可冲泡次数
	self.m_nLastTalkIndex = nil 		--上一次tips索引
	self.m_nTalkGapping = nil 
	self.m_bIsGrind = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCaffee:createElement()
	if WndCaffee.m_root ~= nil then
		WindowManager:removeWindow(WndCaffee.m_root, WndCaffee, true)
	end
	local element = WZUISystem:getInstance():createElement("WndCaffee")
	assert(element, "WndCaffee create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndCaffee:showInterface()
	LoadNewActivityRes(true)
	local wndWater = WndCaffee:createElement()
	if wndWater then 
		WindowManager:addWindow(wndWater, WndCaffee, false)
	end
end

--@brief 	获取活动详情成功
function WndCaffee:GetActivityInfoOK(activityId,maxCount,count,status, rewardCounts, rewardItems, rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	-- body
	WZLog("WndCaffee:GetActivityInfoOK", g_cityExtenInfo.activity7048, activityId, maxCount, content)
	if g_cityExtenInfo.activity7048 == activityId then 
		self.m_tContent = json.decode(content)
	--	WZLog("WndCaffee:GetActivityInfoOK", Serialize(self.m_tContent))
		self.m_nStartTime = startTime 
		self.m_nEndTime = endTime 
		self.m_nActivityId = activityId
		self.m_nCount = count
		self.m_nTimes = maxCount 

		self:_analyzeBigReward()
		self:_update()
	end
end

--@brief 	获取其他活动数据
function WndCaffee:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end 

	if doType == 3 then --开启结果
		local tResult = json.decode(jsonData)
		WZLog("WndCaffee:_onGetOtherData", Serialize(tResult))
		self.m_tOpenResult = {}

		self.m_tOpenResult.normalRewards = {itemIds = {}, itemNums = {}} --常规奖
		self.m_tOpenResult.firstRewards = {} --一等奖
		self.m_tOpenResult.bigRewards = {} --特等奖
		self.m_tOpenResult.nScore = 0 

		for i = 1, #tResult.itemIds do
			local tItem = {}
			tItem.itemId = tResult.itemIds[i]
			tItem.itemNum = tResult.itemNums[i]
			table.insert(self.m_tOpenResult.normalRewards, tItem)
		end

		--一等奖
		for j = 1, #tResult.fItemIds do
			local tItem = {}

			tItem.itemId = tResult.fItemIds[j]
			tItem.itemNum = tResult.fItemNums[j]
			tItem.type = 14

			table.insert(self.m_tOpenResult.firstRewards, tItem)
		end
		--特等奖
		for j = 1, #tResult.sItemIds do
			local tItem = {}

			tItem.itemId = tResult.sItemIds[j]
			tItem.itemNum = tResult.sItemNums[j]
			tItem.type = 15

			table.insert(self.m_tOpenResult.bigRewards, tItem)
		end

		if result == 1 then 
			self.m_nCount = tResult.count
			self.m_tOpenResult.nScore = tResult.addPoint
			self.m_nTimes = tResult.lotteryNum
			self:_setFreeBtnText()
			self:_showLeftTimes()
			self:showOpenAction()
		end
	elseif doType == 2 then --研磨成功
		local tResult = json.decode(jsonData)
		if result == 1 then 
			self.m_nCount = tResult.count
			self.m_nTimes = tResult.lotteryNum
			self:showGrindAction()
		end
	end
end

--@brief	缓存推送更新物品时调用的函数
function WndCaffee:updatePlayerItemData()
	WZLog("WndCaffee:updatePlayerItemData")
	if self.m_root ~= nil then
		self:_updateLightNum()
		self:showRedDot()
	end
end

--@brief 	设置射箭的状态
function WndCaffee:setOpenState(state)
	-- body
	if self.m_root == nil then return end 

	self.m_bOpenState = state
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	关闭抽奖奖励展示界面回调
function WndCaffee:_afterCloseReward()
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
		WndHoraryBigReward:showInterface(15, self.m_tOpenResult.normalRewards, tBigReward)
	elseif #tBigReward > 0 then 
		WndHoraryBigReward:showInterface(6, tBigReward)
	end
end

--@brief 	解析大奖数据
function WndCaffee:_analyzeBigReward()
	-- body
	local sBigReward = self.m_tContent.firstRewards
	local array = SplitStringWithSeparator(sBigReward, "&")
	local nSex = CacheCenter:getPlayerInfo().sex
	local tItem = {reward_ids1 = {}, reward_nums1 = {}, name = LocalStrings.CAFFEE_TEXT1[7]}
	self.m_tBigRewardList = {}
	for i = 1, #array do
--		WZLog("WndCaffee:_analyzeBigReward", string.sub(array[i], 2, -2))
		local string = string.sub(array[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string,",")[3])

		table.insert(tItem.reward_ids1, id)
		table.insert(tItem.reward_nums1, num)
	end

	self.m_tBigRewardList[1] = tItem

	local specialReward = self.m_tContent.superRewards
	local array1 = SplitStringWithSeparator(specialReward, "&")
	local tItem1 = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.CAFFEE_TEXT1[8]}
	for i = 1, #array1 do
--		WZLog("WndCaffee:_analyzeBigReward", string.sub(array1[i], 2, -2))
		local string = string.sub(array1[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string, ",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string, ",")[3])
		
		table.insert(tItem1.reward_ids2, id)
		table.insert(tItem1.reward_nums2, num)
	end

	self.m_tBigRewardList[2] = tItem1
end




-------------------------------------私有方法模块End----------------------------------------
