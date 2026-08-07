--WndNewYearWishData.lua
--@brief	WndNewYearWish的数据模块
--@date		2021/12/09
--@author	XTX
--@note		新年愿望活动主界面

WndNewYearWish = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndNewYearWish:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_tBigRewardList = nil 		--大奖和特奖奖励
	self.m_bOpenState = false 
	self.m_tOpenResult = nil 
	self.m_nCoinId = 160183
	self.m_nCoinId2 = 160184
	self.m_tWishWordsNum = {-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1}
	self.m_tWishWords = nil 
	self.m_nGiftRewardNum = 0 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndNewYearWish:_unInit()
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
	self.m_tWishWordsNum = nil 
	self.m_tWishWords = nil  
	self.m_nGiftRewardNum = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndNewYearWish:createElement()
	if WndNewYearWish.m_root ~= nil then
		WindowManager:removeWindow(WndNewYearWish.m_root, WndNewYearWish, true)
	end
	local element = WZUISystem:getInstance():createElement("WndNewYearWish")
	assert(element, "WndNewYearWish create element failed!")
	self:_init()
	return element
end
--@brief 	外部接口
function WndNewYearWish:showInterface()
	LoadNewActivityRes(true)
	local wndWater = WndNewYearWish:createElement()
	if wndWater then 
		WindowManager:addWindow(wndWater, WndNewYearWish, false)
	end
end

--@brief 	获取活动详情成功
function WndNewYearWish:GetActivityInfoOK(activityId,maxCount,count,status, rewardCounts, rewardItems,rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	-- body
	WZLog("WndNewYearWish:GetActivityInfoOK", g_cityExtenInfo.activity7033, activityId, content)
	if g_cityExtenInfo.activity7033 == activityId then 
		self.m_tContent = json.decode(content)
		self.m_nStartTime = startTime 
		self.m_nEndTime = endTime 
		self.m_nActivityId = activityId
		for key, value in pairs(self.m_tContent.rewardCount) do
			self.m_nGiftRewardNum = self.m_nGiftRewardNum + value
		end

		self:_analyzeWishWords()
		self:_update()
	end
end

--@brief 	获取其他活动数据
function WndNewYearWish:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end 

	if doType == 1 then --开启结果
		local tResult = json.decode(jsonData)
		self.m_tOpenResult = {}
		self.m_tOpenResult.itemIds = {}
		self.m_tOpenResult.itemNums = {}
		self.m_tOpenResult.bigRewards = {} --奖池1
		self.m_tOpenResult.zdjcRewards = {} --奖池2
		self.m_tOpenResult.sGetWords = ""
		local nSex = CacheCenter:getPlayerInfo().sex
		local bIsBless = false 
		WZLog("WndNewYearWish:_onGetOtherData", Serialize(tResult))
		for i = 1, #tResult.rewardTypes do
			if tResult.rewardTypes[i] == 1 or tResult.rewardTypes[i] == 2 then 
				for j = 1, #tResult.rewards[i] do
					local id = tResult.rewards[i][j][nSex + 1]
					local num = tResult.rewards[i][j][3]
					table.insert(self.m_tOpenResult.itemIds, id)
					table.insert(self.m_tOpenResult.itemNums, num)
				end

			elseif tResult.rewardTypes[i] == 3 then 
				for j = 1, #tResult.rewards[i] do
					local tItem = {}

					local id = tResult.rewards[i][j][nSex + 1]
					local num = tResult.rewards[i][j][3]
					tItem.itemId = id
					tItem.itemNum = num
					tItem.type = tResult.rewardTypes[i]

					table.insert(self.m_tOpenResult.zdjcRewards, tItem)
				end
			elseif tResult.rewardTypes[i] == 4 then 
				for j = 1, #tResult.rewards[i] do
					local tItem = {}

					local id = tResult.rewards[i][j][nSex + 1]
					local num = tResult.rewards[i][j][3]
					tItem.itemId = id
					tItem.itemNum = num
					tItem.type = tResult.rewardTypes[i]

					table.insert(self.m_tOpenResult.bigRewards, tItem)
				end
			end
		end
		--更新点亮的字
		for i = 1, #tResult.words do
			local nCount = tResult.words[i][1]
			local nIndex = tResult.words[i][2]
			for j = 1, nCount - 1 do
				local nTempNum = #LocalStrings.NEWYEARWISH_TEXT3[j]
				nIndex = nIndex + nTempNum
			end

			self.m_tWishWordsNum[nIndex] = self.m_tWishWordsNum[nIndex] + 1
			if i > 1 then 
				self.m_tOpenResult.sGetWords = self.m_tOpenResult.sGetWords .. ","
			end
			self.m_tOpenResult.sGetWords = self.m_tOpenResult.sGetWords .. self.m_tWishWords[nIndex]
		end

		if result == 1 then 
			self.m_nGiftRewardNum = 0
			for key, value in pairs(tResult.rewardCount) do
				self.m_nGiftRewardNum = self.m_nGiftRewardNum + value
			end
			if self.m_nGiftRewardNum > 0 then 
				GlobalGame.g_tRedPointTypeList[27033] = true
				self:showRedDot()
			end

			self:showOpenAction()
		end
	elseif doType == 2 then --领取心愿礼物
		local tResult = json.decode(jsonData)
		self.m_nGiftRewardNum = 0
		WZLog("WndNewYearWish:_onGetOtherData 222", Serialize(tResult))
		local tRewardIds = {}
		local tRewardNums = {}
		local nSex = CacheCenter:getPlayerInfo().sex
		self.m_tOpenResult = {}
		self.m_tOpenResult.bigRewards = {} --心愿大礼

		for k = 1, #tResult.rewardTypes do
			if tResult.rewardTypes[k] == 6 then 
				for i = 1, #tResult.wishRewards[k] do
					local v = tResult.wishRewards[k][i]
					local tItem = {}

					local id = v[nSex + 1]
					local num = v[3]
					tItem.itemId = id
					tItem.itemNum = num
					tItem.type = tResult.rewardTypes[k]

					table.insert(self.m_tOpenResult.bigRewards, tItem)
				end
			else
				for i = 1, #tResult.wishRewards[k] do
					local v = tResult.wishRewards[k][i]
					local id = v[nSex + 1]
					local num = v[3]
					table.insert(tRewardIds, id)
					table.insert(tRewardNums, num)
				end
			end
		end
		WndRewardShow:showById(tRewardIds, tRewardNums)
		WndRewardShow:closeCallBack(self, self._afterCloseReward)

		GlobalGame.g_tRedPointTypeList[27033] = false
		self:showRedDot()
		WndHouseInvite:getWishGiftSuccess()
	end
end

--@brief	缓存推送更新物品时调用的函数
function WndNewYearWish:updatePlayerItemData()
	WZLog("WndNewYearWish:updatePlayerItemData")
	if self.m_root ~= nil then
		self:_updateLightNum()
	end
end

--@brief 	设置射箭的状态
function WndNewYearWish:setOpenState(state)
	-- body
	if self.m_root == nil then return end 

	self.m_bOpenState = state
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	关闭抽奖奖励展示界面回调
function WndNewYearWish:_afterCloseReward()
	if self.m_root == nil then return end 

	if self.m_tOpenResult.zdjcRewards and #self.m_tOpenResult.zdjcRewards > 0 then 
		WndHoraryBigReward:showInterface(10, self.m_tOpenResult.zdjcRewards, self.m_tOpenResult.bigRewards)
	elseif self.m_tOpenResult.bigRewards and #self.m_tOpenResult.bigRewards > 0 then 
		WndHoraryBigReward:showInterface(10, self.m_tOpenResult.bigRewards)
	end
end

--@brief 	解析心愿字
function WndNewYearWish:_analyzeWishWords()
	-- body
	self.m_tWishWords = {}
	for i = 1, #LocalStrings.NEWYEARWISH_TEXT3 do
		for j = 1, #LocalStrings.NEWYEARWISH_TEXT3[i] do
			table.insert(self.m_tWishWords, LocalStrings.NEWYEARWISH_TEXT3[i][j])
		end
	end

	for i, value in pairs(self.m_tContent.words) do 
		local nCount = tonumber(i)
		local nIndex = 0
		for j = 1, nCount - 1 do
			local nTempNum = #LocalStrings.NEWYEARWISH_TEXT3[j]
			nIndex = nIndex + nTempNum
		end
		for key, v in pairs(value) do
			self.m_tWishWordsNum[nIndex + tonumber(key)] = v
		end
	end
end

-------------------------------------私有方法模块End----------------------------------------
