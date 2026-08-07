--WndBeatEngineerData.lua
--@brief	WndBeatEngineer的数据模块
--@date		2021/12/09
--@author	XTX
--@note		暴揍策划活动主界面

WndBeatEngineer = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndBeatEngineer:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_tBigRewardList = nil 		--大奖和特奖奖励
	self.m_bOpenState = false 
	self.m_tOpenResult = nil 
	self.m_nGiftRewardNum = 0 
	self.m_nodeCbgTool = nil 
	self.m_sBeatConfigJson = nil 
	self.m_tPrice = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndBeatEngineer:_unInit()
	self.m_root = nil
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_tBigRewardList = nil 		--大奖和特奖奖励
	self.m_bOpenState = false 
	self.m_tOpenResult = nil 
	self.m_nGiftRewardNum = nil  
	self.m_nodeCbgTool = nil 
	self.m_sBeatConfigJson = nil 
	self.m_tPrice = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndBeatEngineer:createElement()
	if WndBeatEngineer.m_root ~= nil then
		WindowManager:removeWindow(WndBeatEngineer.m_root, WndBeatEngineer, true)
	end
	local element = WZUISystem:getInstance():createElement("WndBeatEngineer")
	assert(element, "WndBeatEngineer create element failed!")
	self:_init()
	return element
end
--@brief 	外部接口
function WndBeatEngineer:showInterface()
	LoadNewActivityRes(true)
	local wndWater = WndBeatEngineer:createElement()
	if wndWater then 
		WindowManager:addWindow(wndWater, WndBeatEngineer, false)
	end
end

--@brief 	获取活动详情成功
function WndBeatEngineer:GetActivityInfoOK(activityId,maxCount,count,status, rewardCounts, rewardItems, rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	-- body
	WZLog("WndBeatEngineer:GetActivityInfoOK", g_cityExtenInfo.activity7034, activityId, content)
	if g_cityExtenInfo.activity7034 == activityId then 
		self.m_tContent = json.decode(content)
		self.m_nStartTime = startTime 
		self.m_nEndTime = endTime 
		self.m_nActivityId = activityId
		self.m_nGiftRewardNum = self.m_tContent.globalRewardCount or 0
		self.m_tPrice = {}
		local tTempPrice = json.decode(self.m_tContent.price)
		for i = 1, #tTempPrice do
			local tPrice = json.decode(tTempPrice[i])

			table.insert(self.m_tPrice, tPrice)
		end
		self:_analyzeBigReward()
		self:_update()
	end
end

--@brief 	获取其他活动数据
function WndBeatEngineer:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end 

	if doType == 1 then --开启结果
		local tResult = json.decode(jsonData)
		self.m_tOpenResult = {}
		self.m_tOpenResult.itemIds = {}
		self.m_tOpenResult.itemNums = {}
		self.m_tOpenResult.bigRewards = {} --大奖特奖
		self.m_tOpenResult.zdjcRewards = {} --隐藏大奖
		self.m_tOpenResult.congratCardNum = tResult.congratCardNum
		local nSex = CacheCenter:getPlayerInfo().sex
		local tRewardsList = tResult.rewards
		for i = 1, #tResult.rewardTypes do
			if tResult.rewardTypes[i] == 1 or tResult.rewardTypes[i] == 4 then --普通奖
				for j = 1, #tRewardsList[i] do
					local id = tRewardsList[i][j][nSex + 1]
					local num = tRewardsList[i][j][3]
					table.insert(self.m_tOpenResult.itemIds, id)
					table.insert(self.m_tOpenResult.itemNums, num)
				end
			elseif tResult.rewardTypes[i] == 2 or tResult.rewardTypes[i] == 5 then --隐藏大奖
				for j = 1, #tRewardsList[i] do
					local tItem = {}

					local id = tRewardsList[i][j][nSex + 1]
					local num = tRewardsList[i][j][3]
					tItem.itemId = id
					tItem.itemNum = num
					tItem.type = tResult.rewardTypes[i]

					table.insert(self.m_tOpenResult.zdjcRewards, tItem)
				end
			elseif tResult.rewardTypes[i] == 3 or tResult.rewardTypes[i] == 6 then --大奖
				for j = 1, #tRewardsList[i] do
					local tItem = {}

					local id = tRewardsList[i][j][nSex + 1]
					local num = tRewardsList[i][j][3]
					tItem.itemId = id
					tItem.itemNum = num
					if tResult.rewardTypes[i] == 3 then 
						tItem.type = 2
					else
						tItem.type = 3
					end

					table.insert(self.m_tOpenResult.bigRewards, tItem)
				end
			end
		end

		if result == 1 then 
			if tResult.globalRewardCount then 
				self.m_nGiftRewardNum = tResult.globalRewardCount
			end
			self:showBagGiftInfo()

			self:showOpenAction()
		end
	elseif doType == 2 then --收礼品卡
		local tResult = json.decode(jsonData)
		if result == 1 then 
			self.m_nGiftRewardNum = tResult.globalRewardCount
			self:showBagGiftInfo()
			local itemIds = {}
			local itemNums = {}
			local nSex = CacheCenter:getPlayerInfo().sex
			for j = 1, #tResult.rewards do
				local id = tResult.rewards[j][nSex + 1]
				local num = tResult.rewards[j][3]
				table.insert(itemIds, id)
				table.insert(itemNums, num)
			end

			WndRewardShow:showById(itemIds, itemNums)
		end
	end
end

--@brief 	设置射箭的状态
function WndBeatEngineer:setOpenState(state)
	-- body
	if self.m_root == nil then return end 

	self.m_bOpenState = state
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	关闭抽奖奖励展示界面回调
function WndBeatEngineer:_afterCloseReward()
	if self.m_root == nil then return end 

	if self.m_tOpenResult.zdjcRewards and #self.m_tOpenResult.zdjcRewards > 0 then 
		WndHoraryBigReward:showInterface(8, self.m_tOpenResult.zdjcRewards, self.m_tOpenResult.bigRewards)
	elseif self.m_tOpenResult.bigRewards and #self.m_tOpenResult.bigRewards > 0 then 
		WndHoraryBigReward:showInterface(9, self.m_tOpenResult.bigRewards)
	end
end

--@brief 	解析大奖数据
function WndBeatEngineer:_analyzeBigReward()
	-- body
	local tBigReward = self.m_tContent.bigReward1
	local nSex = CacheCenter:getPlayerInfo().sex
	local tItem = {reward_ids1 = {}, reward_nums1 = {}, name = LocalStrings.BEATENGINEER_TEXT1[7]}
	self.m_tBigRewardList = {}
	for i = 1, #tBigReward do
		local id = tBigReward[i][nSex + 1]
		local num = tBigReward[i][3]

		table.insert(tItem.reward_ids1, id)
		table.insert(tItem.reward_nums1, num)
	end

	self.m_tBigRewardList[1] = tItem

	local tSpecialReward = self.m_tContent.bigReward2
	local tItem1 = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.BEATENGINEER_TEXT1[8]}
	for i = 1, #tSpecialReward do
		local id = tSpecialReward[i][nSex + 1]
		local num = tSpecialReward[i][3]
		
		table.insert(tItem1.reward_ids2, id)
		table.insert(tItem1.reward_nums2, num)
	end

	self.m_tBigRewardList[2] = tItem1
end

-------------------------------------私有方法模块End----------------------------------------
