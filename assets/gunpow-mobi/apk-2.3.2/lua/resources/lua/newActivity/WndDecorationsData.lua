--WndDecorationsData.lua
--@brief	WndDecorations的数据模块
--@date		2021/11/16
--@author	XTX
--@note		张灯结彩活动

WndDecorations = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndDecorations:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_tBigRewardList = nil 		--大奖和特奖奖励
	self.m_bOpenState = false 
	self.m_tOpenResult = nil 
	self.m_tCardPath = {"ui/newActivity/common_pic_zdjc_hk1.png", "ui/newActivity/common_pic_zdjc_hk2.png"}
	self.m_nLastLightState = nil 		--点灯前的状态
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndDecorations:_unInit()
	self.m_root = nil
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_tBigRewardList = nil 		
	self.m_bOpenState = nil 
	self.m_tOpenResult = nil 
	self.m_tCardPath = nil 
	self.m_nLastLightState = nil 		--点灯前的状态
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndDecorations:createElement()
	if WndDecorations.m_root ~= nil then
		WindowManager:removeWindow(WndDecorations.m_root, WndDecorations, true)
	end
	local element = WZUISystem:getInstance():createElement("WndDecorations")
	assert(element, "WndDecorations create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndDecorations:showInterface()
	LoadNewActivityRes(true)
	local wndWater = WndDecorations:createElement()
	if wndWater then 
		WindowManager:addWindow(wndWater, WndDecorations, false)
	end
end

--@brief 	获取活动详情成功
function WndDecorations:GetActivityInfoOK(activityId,maxCount,count,status, rewardCounts, rewardItems,rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	-- body
	WZLog("WndDecorations:GetActivityInfoOK", g_cityExtenInfo.activity7030, activityId, content)
	if g_cityExtenInfo.activity7030 == activityId then 
		self.m_tContent = json.decode(content)
		self.m_nStartTime = startTime 
		self.m_nEndTime = endTime 
		self.m_nActivityId = activityId

		self:_analyzeBigReward()
		self:_update()
	end
end

--@brief 	获取其他活动数据
function WndDecorations:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end 

	if doType == 4 then --待收取礼品卡
	elseif doType == 2 then --兑换礼品卡
	elseif doType == 3 then --赠送礼品卡
		local tResult = json.decode(jsonData)

		if result == 1 then 
			self.m_tContent.sendCardLeftNum = tResult.sendCardLeftNum
			MsgBoxManager:showTipBox(LocalStrings.DECORATIONS_TEXT1[12])
			if WndOnlineHintFriend.m_root then 
				WndOnlineHintFriend:onCloseActionCallback()
			end
		elseif result == 2 then 
			MsgBoxManager:showTipBox(LocalStrings.FRIENDS_BESTFRIEND12)
		elseif result == 3 then 
			MsgBoxManager:showTipBox(LocalStrings.DECORATIONS_TEXT1[10])
		end
	elseif doType == 1 then --开启结果
		local tResult = json.decode(jsonData)
		self.m_tOpenResult = {}
		self.m_tOpenResult.itemIds = {}
		self.m_tOpenResult.itemNums = {}
		self.m_tOpenResult.bigRewards = {} --大奖特奖
		self.m_tOpenResult.zdjcRewards = {} --张灯结彩奖
		self.m_tOpenResult.congratCardNum = tResult.congratCardNum
		local nSex = CacheCenter:getPlayerInfo().sex
		local bIsBless = false 
		for i = 1, #tResult.rewardTypes do
			if tResult.rewardTypes[i] == 1 or tResult.rewardTypes[i] == 4 then 
				local array = SplitStringWithSeparator(tResult.rewards[i], "&")
				for j = 1, #array do
					local strTemp = string.sub(array[j], 2, -2) 
					local id = tonumber(SplitStringWithSeparator(strTemp,",")[nSex + 1])
					local num = tonumber(SplitStringWithSeparator(strTemp,",")[3])
					table.insert(self.m_tOpenResult.itemIds, id)
					table.insert(self.m_tOpenResult.itemNums, num)
				end
				if tResult.rewardTypes[i] == 4 then 
					bIsBless = true 
				end
			elseif tResult.rewardTypes[i] == 2 or tResult.rewardTypes[i] == 3 then 
				local array = SplitStringWithSeparator(tResult.rewards[i], "&")
				for j = 1, #array do
					local tItem = {}

					local strTemp = string.sub(array[j], 2, -2) 
					local id = tonumber(SplitStringWithSeparator(strTemp,",")[nSex + 1])
					local num = tonumber(SplitStringWithSeparator(strTemp,",")[3])
					tItem.itemId = id
					tItem.itemNum = num
					tItem.type = tResult.rewardTypes[i] + 1 

					table.insert(self.m_tOpenResult.bigRewards, tItem)
				end
			elseif tResult.rewardTypes[i] == 5 then 
				local array = SplitStringWithSeparator(tResult.rewards[i], "&")
				for j = 1, #array do
					local tItem = {}

					local strTemp = string.sub(array[j], 2, -2) 
					local id = tonumber(SplitStringWithSeparator(strTemp,",")[nSex + 1])
					local num = tonumber(SplitStringWithSeparator(strTemp,",")[3])
					tItem.itemId = id
					tItem.itemNum = num
					tItem.type = tResult.rewardTypes[i]

					table.insert(self.m_tOpenResult.zdjcRewards, tItem)
				end
			end
		end

		if result == 1 then 
			if bIsBless then 
				WndHouseInvite:blessSuccess()
				self:showShootReward()
			else
				self.m_tContent.lightStates = tResult.lightStates
				self:showOpenAction()
			end
		end
	elseif doType == 5 then --收礼品卡
		local tResult = json.decode(jsonData)
		if result == 1 then 
			self.m_tContent.takeCardLeftNum = tResult.takeCardLeftNum
			WndHouseInvite:updateTakeLeftNum()
			WndHouseInvite:_onGetOtherData(tResult.index)
		elseif result == 2 then 
			MsgBoxManager:showTipBox(LocalStrings.DECORATIONS_TEXT1[11])
		end
	end
end

--@brief	缓存推送更新物品时调用的函数
function WndDecorations:updatePlayerItemData()
	WZLog("WndDecorations:updatePlayerItemData")
	if self.m_root ~= nil then
		self:_updateLightNum()
	end
end

--@brief 	设置射箭的状态
function WndDecorations:setOpenState(state)
	-- body
	if self.m_root == nil then return end 

	self.m_bOpenState = state
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	关闭抽奖奖励展示界面回调
function WndDecorations:_afterCloseReward()
	if self.m_root == nil then return end 
--	WZLog("WndDecorations:_afterCloseReward", Serialize(self.m_tOpenResult.bigRewards))
	table.sort( self.m_tOpenResult.bigRewards, function (a, b)
		-- body
		return a.type < b.type
	end )
	if self.m_tOpenResult.zdjcRewards and #self.m_tOpenResult.zdjcRewards > 0 then 
		WndHoraryBigReward:showInterface(7, self.m_tOpenResult.zdjcRewards, self.m_tOpenResult.bigRewards)
	elseif self.m_tOpenResult.bigRewards and #self.m_tOpenResult.bigRewards > 0 then 
		WndHoraryBigReward:showInterface(6, self.m_tOpenResult.bigRewards)
	end
end

--@brief 	解析大奖数据
function WndDecorations:_analyzeBigReward()
	-- body
	local sBigReward = self.m_tContent.firstRewards
	local array = SplitStringWithSeparator(sBigReward, "&")
	local nSex = CacheCenter:getPlayerInfo().sex
	local tItem = {reward_ids1 = {}, reward_nums1 = {}, name = LocalStrings.ACTIVITY_TEXT18}
	self.m_tBigRewardList = {}
	for i = 1, #array do
		WZLog("WndDecorations:_analyzeBigReward", string.sub(array[i], 2, -2))
		local string = string.sub(array[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string,",")[3])

		table.insert(tItem.reward_ids1, id)
		table.insert(tItem.reward_nums1, num)
	end

	self.m_tBigRewardList[1] = tItem

	local specialReward = self.m_tContent.specialRewards
	local array1 = SplitStringWithSeparator(specialReward, "&")
	local tItem1 = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.ACTIVITY_TEXT19}
	for i = 1, #array1 do
		WZLog("WndDecorations:_analyzeBigReward", string.sub(array1[i], 2, -2))
		local string = string.sub(array1[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string, ",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string, ",")[3])
		
		table.insert(tItem1.reward_ids2, id)
		table.insert(tItem1.reward_nums2, num)
	end

	self.m_tBigRewardList[2] = tItem1
end




-------------------------------------私有方法模块End----------------------------------------
