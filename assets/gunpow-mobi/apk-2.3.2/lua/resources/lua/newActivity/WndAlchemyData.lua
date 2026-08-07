--WndAlchemyData.lua
--@brief	WndAlchemy的数据模块
--@date		2022/02/08
--@author	XTX
--@note		丹道修真活动

WndAlchemy = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndAlchemy:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_tBigRewardList = nil 		--大奖和特奖奖励
	self.m_bOpenState = false 
	self.m_tOpenResult = nil 
	self.m_nCoinId2 = nil
	self.m_nCoinId = 160200
	self.m_bIsOpenReward = false 
	self.m_nRecvRewardsPool = {}    --两个特殊奖池信息分两次协议接收，两个奖池都接收到，才显示奖池弹框
	self.m_nChooseReward = 0 		--选择奖励状态0：弹出预览界面；1：不弹
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndAlchemy:_unInit()
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
	self.m_bIsOpenReward = nil 
	self.m_nRecvRewardsPool = nil    --两个特殊奖池信息分两次协议接收，两个奖池都接收到，才显示奖池弹框
	self.m_nChooseReward = nil 		--选择奖励状态0：弹出预览界面；1：不弹
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndAlchemy:createElement()
	if WndAlchemy.m_root ~= nil then
		WindowManager:removeWindow(WndAlchemy.m_root, WndAlchemy, true)
	end
	local element = WZUISystem:getInstance():createElement("WndAlchemy")
	assert(element, "WndAlchemy create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndAlchemy:showInterface()
	LoadNewActivityRes(true)
	local wndWater = WndAlchemy:createElement()
	if wndWater then 
		WindowManager:addWindow(wndWater, WndAlchemy, false)
	end
end

--@brief 	获取活动详情成功
function WndAlchemy:GetActivityInfoOK(activityId,maxCount,count,status, rewardCounts, rewardItems, rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	-- body
	WZLog("WndAlchemy:GetActivityInfoOK", g_cityExtenInfo.activity7036, activityId, content)
	if g_cityExtenInfo.activity7036 == activityId then 
		self.m_tContent = json.decode(content)
		self.m_nStartTime = startTime 
		self.m_nEndTime = endTime 
		self.m_nActivityId = activityId
		self.m_nChooseReward = GetOperateTimes("ALCHEMYACTIVITYID", self.m_nActivityId)

		self:_analyzeBigReward()
		self:_update()
	end
end

--@brief 	获取其他活动数据
function WndAlchemy:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end 

	if doType == 1 then --开启结果
		local tResult = json.decode(jsonData)
		WZLog("WndAlchemy:_onGetOtherData", Serialize(tResult))
		self.m_tOpenResult = {}

		self.m_tOpenResult.normalRewards = {} --常规奖
		self.m_tOpenResult.firstRewards = {} --一等奖
		self.m_tOpenResult.bigRewards = {} --特等奖
		self.m_tOpenResult.alchemyReward = {} --普通丹药
		local nSex = CacheCenter:getPlayerInfo().sex
		if #tResult.rewardTypes > 0 then 
			local randomList = GetRandomNum(5, 10, 1)
			for k = 1, tResult.times do
				local nTempItemId = 0
				if randomList[k]%2 == 0 then 
					nTempItemId = 160201
				else
					nTempItemId = 160202
				end
				local bExist = false 
				for n = 1, #self.m_tOpenResult.alchemyReward do
					if self.m_tOpenResult.alchemyReward[n][1] == nTempItemId then 
						bExist = true 
						self.m_tOpenResult.alchemyReward[n][2] = self.m_tOpenResult.alchemyReward[n][2] + 1
						break 
					end
				end
				if not bExist then 
					table.insert(self.m_tOpenResult.alchemyReward, {nTempItemId, 1})
				end
			end
			for i = 1, #tResult.rewardTypes do
				if tResult.rewardTypes[i] == 2 then 
					local array = tResult.rewards[i]
					for j = 1, #array do
						local tItem = {}

						tItem.itemId = array[j][nSex + 1]
						tItem.itemNum = array[j][3]
						tItem.type = 3

						table.insert(self.m_tOpenResult.firstRewards, tItem)
					end
				elseif tResult.rewardTypes[i] == 3 then 
					local array = tResult.rewards[i]
					for j = 1, #array do
						local tItem = {}

						tItem.itemId = array[j][nSex + 1]
						tItem.itemNum = array[j][3]
						tItem.type = 4

						table.insert(self.m_tOpenResult.bigRewards, tItem)
					end
				else
					local array = tResult.rewards[i]
					for j = 1, #array do
						local tItem = {}
						tItem.itemId = array[j][nSex + 1]
						tItem.itemNum = array[j][3]
						if tResult.times == 1 then 
							tItem.type = 1
						elseif tResult.times == 5 then 
							tItem.type = 2
						end

						table.insert(self.m_tOpenResult.normalRewards, tItem)
					end
				end
			end
		end

		if result == 1 then 
			self:showOpenAction()
		end
	elseif doType == 2 then 
		WndAlchemySmelt:smeltResult(activityId, doType, result, jsonData)
	elseif doType == 3 then 
		--[[
			{
				pool	: int 大奖类型 2:三品破厄丹 3：五品长生丹 4：五品破厄丹 5:九品长生丹,
				rewards	: '大奖奖池物品 [男物品id,女物品id,数量]&[...',
				globalLimitConfig	: '大奖全局日限量配置 [限量数量,限量数量]',
				playerLimitConfig	: '大奖个人日限量配置 [限量数量,限量数量]',
				globalLimit	: int[]大奖全局日限量,
				playerLimit	: int[]大奖个人日限量,
				optionalList	: int[]大奖奖选中下标
			}
		]]
		local tResult = json.decode(jsonData)
		--WZLog("WndAlchemy:_onGetOtherData 333", Serialize(tResult))
		WZLog("WndAlchemy:_onGetOtherData 333 self.m_nRecvRewardsPool = ", Serialize(self.m_nRecvRewardsPool))

		local pool = tonumber(tResult.pool)
		WZLog("WndAlchemy:_onGetOtherData 333 pool = ", pool)
		if pool == nil then return end
		if pool == 2 or pool == 4 then
			self.m_nRecvRewardsPool.pool1 = true
			local nSex = CacheCenter:getPlayerInfo().sex
			local sBigReward = tResult.rewards
			local array = SplitStringWithSeparator(sBigReward, "&")

			local tItem = {reward_ids1 = {}, reward_nums1 = {}, name = LocalStrings.ALCHEMY_TEXT1[16]}
			if pool == 4 then
				tItem = {reward_ids1 = {}, reward_nums1 = {}, name = LocalStrings.ALCHEMY_TEXT1[27]}
			end
			--WZLog("WndAlchemy:_onGetOtherData 333 tItem = ", Serialize(tItem))
			--tItem = {reward_ids1 = {}, reward_nums1 = {}, name = LocalStrings.ALCHEMY_TEXT1[16], strAtt = LocalStrings.DETECTIVE_TEXT1[16], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31}
			for i = 1, #tResult.globalLimit do
				local tab = {}
				tab.id = i - 1
				tab.limitNum = tResult.playerLimitConfig[i]
				tab.dailyLimit = tResult.globalLimitConfig[i]
				tab.dailyBuyNum = tResult.globalLimit[i]
				tab.soldNum = tResult.playerLimit[i]
				-- if utilsValueInTable(i - 1, tResult.optionalList) then 
				-- 	tItem.chooseState[i] = 1
				-- else
				-- 	tItem.chooseState[i] = 0
				-- end
				
				-- tItem.leftConfig[i] = tab
			end
			for i = 1, #array do
				local string = string.sub(array[i], 2, -2) 
				local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
				local num = tonumber(SplitStringWithSeparator(string,",")[3])

				table.insert(tItem.reward_ids1, id)
				table.insert(tItem.reward_nums1, num)
			end

			self.m_tBigRewardList[1] = tItem
		elseif pool == 3 or pool == 5 then
			self.m_nRecvRewardsPool.pool2 = true
			local nSex = CacheCenter:getPlayerInfo().sex
			local sBigReward = tResult.rewards
			local array = SplitStringWithSeparator(sBigReward, "&")

			local tItem = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.ALCHEMY_TEXT1[17]}
			tItem = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.ALCHEMY_TEXT1[17], strAtt = LocalStrings.DETECTIVE_TEXT1[16], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31, pool = pool}
			if pool == 5 then
				tItem = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.ALCHEMY_TEXT1[28], strAtt = LocalStrings.DETECTIVE_TEXT1[16], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31, pool = pool, origin = 857036}
			end
			--WZLog("WndAlchemy:_onGetOtherData 333 tItem = ", Serialize(tItem))
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
		end
		WZLog("WndAlchemy:_onGetOtherData 333 self.m_nRecvRewardsPool = ", Serialize(self.m_nRecvRewardsPool))

		if self.m_bIsOpenReward and self.m_nRecvRewardsPool.pool1 == true and self.m_nRecvRewardsPool.pool2 == true then 
			self.m_bIsOpenReward = false
			self.m_nRecvRewardsPool = {}
			local otherData = {}
			otherData.winType = 1
			otherData.activityId = self.m_nActivityId
			-- otherData.otherRewardData = self.m_tBigRewardList[3]
			WndJoinReward:showInterface("", self.m_tBigRewardList[1], self.m_tBigRewardList[2], LocalStrings.TREASURE_TEXT7, false, 2, otherData, 2)
		end
	elseif doType == 4 then --选择奖励
		--[[
			{
				status	: int勾选的状态：0-取消，1-勾选,
				id	: int 自选大奖 下标从0开始
			}
		]]
		local tResult = json.decode(jsonData)
		WZLog("WndAlchemy:_onGetOtherData 444", Serialize(tResult))
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
function WndAlchemy:updatePlayerItemData()
	WZLog("WndAlchemy:updatePlayerItemData")
	if self.m_root ~= nil then
		self:_updateLightNum()
		self:showRedDot()
	end
end

--@brief 	设置射箭的状态
function WndAlchemy:setOpenState(state)
	-- body
	if self.m_root == nil then return end 

	self.m_bOpenState = state
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	关闭抽奖奖励展示界面回调
function WndAlchemy:_afterCloseReward()
	if self.m_root == nil then return end 
	local tBigReward = {}
	local nIndex = 1
	if #self.m_tOpenResult.firstRewards > 0 then 
		tBigReward[nIndex] = CopyTable(self.m_tOpenResult.firstRewards)
		nIndex = nIndex + 1
	end
	if #self.m_tOpenResult.bigRewards > 0 then 
		tBigReward[nIndex] = CopyTable(self.m_tOpenResult.bigRewards)
	end

	if self.m_tOpenResult.normalRewards and #self.m_tOpenResult.normalRewards > 0 then 
		WndHoraryBigReward:showInterface(11, self.m_tOpenResult.normalRewards, tBigReward)
	elseif #tBigReward > 0 then 
		WndHoraryBigReward:showInterface(12, tBigReward)
	end
end

--@brief 	解析大奖数据
function WndAlchemy:_analyzeBigReward()
	-- body
	local sBigReward = self.m_tContent.bigReward1
	local nSex = CacheCenter:getPlayerInfo().sex
	local tItem = {reward_ids1 = {}, reward_nums1 = {}, name = LocalStrings.ALCHEMY_TEXT1[16]}
	self.m_tBigRewardList = {}
	for i = 1, #sBigReward do
		local id = sBigReward[i][nSex + 1]
		local num = sBigReward[i][3]

		table.insert(tItem.reward_ids1, id)
		table.insert(tItem.reward_nums1, num)
	end

	self.m_tBigRewardList[1] = tItem

	local specialReward = self.m_tContent.bigReward2
	local tItem1 = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.ALCHEMY_TEXT1[17]}
	for i = 1, #specialReward do
		local id = specialReward[i][nSex + 1]
		local num = specialReward[i][3]
		
		table.insert(tItem1.reward_ids2, id)
		table.insert(tItem1.reward_nums2, num)
	end

	self.m_tBigRewardList[2] = tItem1
end




-------------------------------------私有方法模块End----------------------------------------
