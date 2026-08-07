--WndSetCircleData.lua
--@brief	WndSetCircle的数据模块
--@date		2022/03/24
--@author	XTX
--@note		套圈圈活动主界面

WndSetCircle = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSetCircle:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_tBigRewardList = nil 		--大奖和特奖奖励
	self.m_bOpenState = false 
	self.m_tOpenResult = nil 
	self.m_nCoinId = 160239
	self.m_nCount = 0  					--当天累计抽奖次数
	self.m_tArrayEffectPos = {{["1"] = {0.5,0.26}, ["2"] = {0.74,0.24}, ["3"] = {0.26,0.26}}, {["4"] = {0.3,0.49}, ["8"] = {0.5,0.5}, ["5"] = {0.7,0.5}}, {["6"] = {0.33,0.664}, ["7"] = {0.67,0.664}, ["9"] = {0.5,0.664}}}
	self.m_tSpineName = {"ui_taoquan_tuzi", "ui_taoquan_naicha", "ui_taoquan_ya", "ui_taoquan_liwu", "ui_taoquan_ji", "ui_taoquan_xiong", "ui_taoquan_hezi", "ui_taoquan_gan", "ui_taoquan_bdw"}
	self.m_bIsOpenReward = false 
	self.m_nChooseReward = 0 		--选择奖励状态0：弹出预览界面；1：不弹
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSetCircle:_unInit()
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
	self.m_tArrayEffectPos = nil 
	self.m_tSpineName = nil 
	self.m_bIsOpenReward = nil 
	self.m_nChooseReward = nil 		--选择奖励状态0：弹出预览界面；1：不弹
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSetCircle:createElement()
	if WndSetCircle.m_root ~= nil then
		WindowManager:removeWindow(WndSetCircle.m_root, WndSetCircle, true)
	end
	local element = WZUISystem:getInstance():createElement("WndSetCircle")
	assert(element, "WndSetCircle create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndSetCircle:showInterface()
	LoadNewActivityRes(true)
	local wndWater = WndSetCircle:createElement()
	if wndWater then 
		WindowManager:addWindow(wndWater, WndSetCircle, false)
	end
end

--@brief 	获取活动详情成功
function WndSetCircle:GetActivityInfoOK(activityId,maxCount,count,status, rewardCounts, rewardItems, rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	-- body
	WZLog("WndSetCircle:GetActivityInfoOK", g_cityExtenInfo.activity7046, activityId, content)
	if g_cityExtenInfo.activity7046 == activityId then 
		self.m_tContent = json.decode(content)
	--	WZLog("WndSetCircle:GetActivityInfoOK", Serialize(self.m_tContent))
		self.m_nStartTime = startTime 
		self.m_nEndTime = endTime 
		self.m_nActivityId = activityId
		self.m_nCount = count
		self.m_nChooseReward = GetOperateTimes("SETCIRCLEACTIVITYID", self.m_nActivityId)

		self:_analyzeBigReward()
		self:_update()
	end
end

--@brief 	获取其他活动数据
function WndSetCircle:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end 

	WZLog("WndSetCircle:_onGetOtherData activityId", activityId, doType, result)
	if doType == 2 then --特大奖奖池限量信息
		--[[
			{
				rewards	: '大奖奖池物品 [男物品id,女物品id,数量]&[...',
				globalLimitConfig	: '大奖全局日限量配置 [限量数量,限量数量]',
				playerLimitConfig	: '大奖个人日限量配置 [限量数量,限量数量]',
				globalLimit	: int[]大奖全局日限量,
				playerLimit	: int[]大奖个人日限量,
				optionalList	: int[]大奖奖选中下标
			}
		]]
		local tResult = json.decode(jsonData)
		WZLog("WndSetCircle:_onGetOtherData 222", Serialize(tResult))

		local nSex = CacheCenter:getPlayerInfo().sex
		local sBigReward = tResult.rewards
		local array = SplitStringWithSeparator(sBigReward, "&")

		local tItem = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.SETCIRCLE_TEXT1[10]}
		tItem = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.BILLIARDBALL_TEXT1[8], strAtt = LocalStrings.DETECTIVE_TEXT1[16], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31}
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

		if self.m_bIsOpenReward then 
			self.m_bIsOpenReward = false 
			local otherData = {}
			otherData.winType = 1
			otherData.activityId = self.m_nActivityId
			-- otherData.otherRewardData = self.m_tBigRewardList[3]
			WndJoinReward:showInterface("", self.m_tBigRewardList[1], self.m_tBigRewardList[2], LocalStrings.TREASURE_TEXT7, nil, 2, otherData, 2)
		end
	
	elseif doType == 3 then --开启结果
		local tResult = json.decode(jsonData)
		WZLog("WndSetCircle:_onGetOtherData", Serialize(tResult))
		self.m_tOpenResult = {}

		self.m_tOpenResult.normalRewards = {itemIds = {}, itemNums = {}} --常规奖
		self.m_tOpenResult.firstRewards = {} --一等奖
		self.m_tOpenResult.bigRewards = {} --特等奖
		self.m_tOpenResult.dropDoll = {} --玩偶掉落
		self.m_tOpenResult.rewardType = {} --表演套种动画的spine索引
		self.m_tOpenResult.dollReward = {} --玩偶奖励
		self.m_tOpenResult.nScore = 0 
		--随机表演动画索引
		local randList = GetRandomNum(8, 9, 1)
		--移除掉玩偶所在的位置
		while true do
			local bExist = false  
			for i = 1, #randList do
				if randList[i] == 1 or randList[i] == 3 or randList[i] == 5 then 
					bExist = true 
					table.remove(randList, i)
					break 
				end
			end
			if not bExist then 
				break 
			end
		end
		local nIndex = 1
		for i = 1, #tResult.rewardType do
			if tResult.rewardType[i] == 0 then 
				table.insert(self.m_tOpenResult.rewardType, randList[nIndex])
				nIndex = nIndex + 1
			elseif tResult.rewardType[i] == 1 then 
				table.insert(self.m_tOpenResult.rewardType, tResult.rewardType[i])
			elseif tResult.rewardType[i] == 2 then 
				table.insert(self.m_tOpenResult.rewardType, 3)
			elseif tResult.rewardType[i] == 3 then 
				table.insert(self.m_tOpenResult.rewardType, 5)
			end
		end

		for i = 1, #tResult.itemIds do
			if tResult.itemIds[i] ~= 160240 then 
				local tItem = {}
				tItem.itemId = tResult.itemIds[i]
				tItem.itemNum = tResult.itemNums[i]
				if tResult.itemTypes[i] == 0 then 
					table.insert(self.m_tOpenResult.normalRewards, tItem)
				else
					tItem.type = tResult.itemTypes[i]
					table.insert(self.m_tOpenResult.dollReward, tItem)
				end
			else
				local tItem = {}
				tItem[1] = tResult.itemIds[i]
				tItem[2] = tResult.itemNums[i]

				table.insert(self.m_tOpenResult.dropDoll, tItem)
			end
		end

		--一等奖
		for j = 1, #tResult.fItemIds do
			local tItem = {}

			tItem.itemId = tResult.fItemIds[j]
			tItem.itemNum = tResult.fItemNums[j]
			tItem.type = 10

			table.insert(self.m_tOpenResult.firstRewards, tItem)
		end
		--特等奖
		for j = 1, #tResult.sItemIds do
			local tItem = {}

			tItem.itemId = tResult.sItemIds[j]
			tItem.itemNum = tResult.sItemNums[j]
			tItem.type = 11

			table.insert(self.m_tOpenResult.bigRewards, tItem)
		end

		if result == 1 then 
			self.m_nCount = tResult.count
			self.m_tOpenResult.nScore = tResult.addPoint
			self:_setFreeBtnText()
			self:showOpenAction()
		end
	elseif doType == 7 then --选择奖励
		--[[
			{
				status	: int勾选的状态：0-取消，1-勾选,
				id	: int 自选大奖 下标从0开始
			}
		]]
		local tResult = json.decode(jsonData)
		WZLog("WndSetCircle:_onGetOtherData 666", Serialize(tResult))
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
function WndSetCircle:updatePlayerItemData()
	WZLog("WndSetCircle:updatePlayerItemData")
	if self.m_root ~= nil then
		self:_updateLightNum()
		self:showRedDot()
	end
end

--@brief 	设置射箭的状态
function WndSetCircle:setOpenState(state)
	-- body
	if self.m_root == nil then return end 

	self.m_bOpenState = state
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	关闭抽奖奖励展示界面回调
function WndSetCircle:_afterCloseReward()
	if self.m_root == nil then return end 
	self:_cleanEffect()

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

	if (self.m_tOpenResult.normalRewards and #self.m_tOpenResult.normalRewards > 0) or #self.m_tOpenResult.dollReward > 0 then 
		WndHoraryBigReward:showInterface(15, self.m_tOpenResult.normalRewards, tBigReward, self.m_tOpenResult.dollReward)
	elseif #tBigReward > 0 then 
		WndHoraryBigReward:showInterface(6, tBigReward)
	end
end

--@brief 	解析大奖数据
function WndSetCircle:_analyzeBigReward()
	-- body
	local sBigReward = self.m_tContent.firstRewards
	local array = SplitStringWithSeparator(sBigReward, "&")
	local nSex = CacheCenter:getPlayerInfo().sex
	local tItem = {reward_ids1 = {}, reward_nums1 = {}, name = LocalStrings.SETCIRCLE_TEXT1[9]}
	self.m_tBigRewardList = {}
	for i = 1, #array do
		WZLog("WndSetCircle:_analyzeBigReward", string.sub(array[i], 2, -2))
		local string = string.sub(array[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string,",")[3])

		table.insert(tItem.reward_ids1, id)
		table.insert(tItem.reward_nums1, num)
	end

	self.m_tBigRewardList[1] = tItem

	local specialReward = self.m_tContent.superRewards
	local array1 = SplitStringWithSeparator(specialReward, "&")
	local tItem1 = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.SETCIRCLE_TEXT1[10]}
	for i = 1, #array1 do
		WZLog("WndSetCircle:_analyzeBigReward", string.sub(array1[i], 2, -2))
		local string = string.sub(array1[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string, ",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string, ",")[3])
		
		table.insert(tItem1.reward_ids2, id)
		table.insert(tItem1.reward_nums2, num)
	end

	self.m_tBigRewardList[2] = tItem1
end


-------------------------------------私有方法模块End----------------------------------------
