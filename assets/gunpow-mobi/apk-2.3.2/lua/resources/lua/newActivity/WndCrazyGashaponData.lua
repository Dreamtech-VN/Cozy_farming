--WndCrazyGashaponData.lua
--@brief	WndCrazyGashapon的数据模块
--@date		2022/09/13
--@author	yrd
--@note		疯狂扭蛋

WndCrazyGashapon = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCrazyGashapon:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nCoinId = 160325 			--货币
	self.m_nRewardCoinId1 = 160326 		--时光券
	self.m_nRewardCoinId2 = 160327 		--时光机抽奖次数
	self.m_nWatermelonType = 0 			--习惯类型0==麒麟西瓜；1黑美人；2=西瓜汁
	-- self.m_nGiftRewardNum = 0 			--全民吃瓜奖励数量
	self.m_bIsFirstIn = true
	self.m_tAniAction = {"wait1", "wait2"}
	self.m_bOpenState = false
	self.m_nMaxLotteryCount = 20    --最大抽奖次数
	self.m_nCount = 0  					--当天累计抽奖次数
	self.m_nChooseReward = 0 		--选择奖励状态0：弹出预览界面；1：不弹
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCrazyGashapon:_unInit()
	self.m_root = nil
	self.m_nCoinId = nil
	self.m_nRewardCoinId1 = nil
	self.m_nRewardCoinId2 = nil
	self.m_nWatermelonType = nil
	-- self.m_nGiftRewardNum = nil
	self.m_bIsFirstIn = nil
	self.m_bOpenState = nil
	self.m_nMaxLotteryCount = nil
	self.m_nCount = nil
	self.m_nChooseReward = nil 		--选择奖励状态0：弹出预览界面；1：不弹
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCrazyGashapon:createElement()
	if WndCrazyGashapon.m_root ~= nil then
		WindowManager:removeWindow(WndCrazyGashapon.m_root, WndCrazyGashapon, true)
	end
	local element = WZUISystem:getInstance():createElement("WndCrazyGashapon")
	assert(element, "WndCrazyGashapon create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndCrazyGashapon:showInterface()
	LoadNewActivityRes(true)
	local wnd = WndCrazyGashapon:createElement()
	if wnd then 
		WindowManager:addWindow(wnd, WndCrazyGashapon, false)
	end
end

--@brief 	获取活动详情成功
function WndCrazyGashapon:GetActivityInfoOK(activityId,maxCount,count,status, rewardCounts, rewardItems, rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	WZLog("WndCrazyGashapon:GetActivityInfoOK", g_cityExtenInfo.activity7057, activityId)
	if g_cityExtenInfo.activity7057 == activityId then
		self.m_tContent = json.decode(content)
		self.m_nStartTime = startTime 
		self.m_nEndTime = endTime 
		self.m_nActivityId = activityId
		self.m_tRewardCounts = rewardCounts --玩家翻倍信息[当前拥有翻倍次数,扭蛋值进度,已达成翻倍条件次数]
		self.m_tFinishCondition = finishCondition --翻倍配置[单次产出扭蛋值,扭蛋值进度目标,基础翻倍次数,翻倍倍数]
		self.m_tCostTimes = maxCount --抽奖消耗
		self.m_nCount = count --免费次数
		self.m_nChooseReward = GetOperateTimes("CRAZYGASHAPONACTIVITYID", self.m_nActivityId) 

		self:_analyzeBigReward()
		self:_update()
	end
end

--@brief 	获取其他活动数据
function WndCrazyGashapon:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end 

	if doType == 2 then --大奖限量
		local tResult = json.decode(jsonData)
		local nSex = CacheCenter:getPlayerInfo().sex
		local sBigReward = tResult.rewards
		local array = SplitStringWithSeparator(sBigReward, "&")
		local tItem = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.CRAZY_GASHAPON_TEXT1[11], strAtt = LocalStrings.GONGANDDRUM_TEXT1[16], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31}
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
		WZLog("WndBilliardBall:_onGetOtherData 333", Serialize(tResult))
		self.m_tOpenResult = {}

		self.m_tOpenResult.normalRewards = {} --常规奖
		self.m_tOpenResult.firstRewards = {} --一等奖
		self.m_tOpenResult.bigRewards = {} --特等奖

		local rewardType = 9 
		for i = 1, #tResult.itemNums do
			local tItem = {}
			tItem.itemId = tResult.itemIds[i]
			tItem.itemNum = tResult.itemNums[i]
			tItem.type = rewardType
			table.insert(self.m_tOpenResult.normalRewards, tItem)
		end

		--一等奖
		for j = 1, #tResult.fItemIds do
			local tItem = {}

			tItem.itemId = tResult.fItemIds[j]
			tItem.itemNum = tResult.fItemNums[j]
			tItem.type = 21

			table.insert(self.m_tOpenResult.firstRewards, tItem)
		end
		--特等奖
		for j = 1, #tResult.sItemIds do
			local tItem = {}

			tItem.itemId = tResult.sItemIds[j]
			tItem.itemNum = tResult.sItemNums[j]
			tItem.type = 22

			table.insert(self.m_tOpenResult.bigRewards, tItem)
		end

		if result == 1 then 
			self.m_nCount = tResult.count
			self.m_tOpenResult.medalNum = tResult.extItemNums   --获得时光卷数量
			self.m_tRewardCounts = tResult.doubleInfo --玩家翻倍信息[当前拥有翻倍次数,扭蛋值进度,已达成翻倍条件次数]

			self:showOpenAction()
			self:_setFreeBtnText()
			self:_updateDoubleProg()
		else
			self:setOpenState(false)
		end
	elseif doType == 4 then --自选奖池
		local tResult = json.decode(jsonData)
		WZLog("WndCrazyGashapon:_onGetOtherData 44", Serialize(tResult))
		if result == 1 then 
			WndCrazyGashaponShake:setRewardPoolData(tResult)
		end
	elseif doType == 5 then --自选奖池领取
		local tResult = json.decode(jsonData)
		WZLog("WndCrazyGashapon:_onGetOtherData 55", Serialize(tResult))
		if result == 0 then 
			WndCrazyGashaponShake:getPoolRewardOK(tResult)
		end
	elseif doType == 9 then --摇摇乐抽奖
		local tResult = json.decode(jsonData)
		WZLog("WndCrazyGashapon:_onGetOtherData 99", Serialize(tResult))
		if result == 1 then 
			local tItem = {id = {}, num = {}, playerItemId = {}}
			local nIndex = 1
			for j = 1, #tResult.itemIds do
				if tResult.itemIds[j] ~= self.m_nRewardCoinId2 then
					tItem.id[nIndex] = tResult.itemIds[j]
					tItem.num[nIndex] = tResult.itemNums[j]
					tItem.playerItemId[nIndex] = tResult.playerItemIds[j]

					nIndex = nIndex + 1
				end
			end
			-- WndRewardShow:showById(tItem.id, tItem.num, nil, nil, nil, nil, nil, nil, nil, nil, nil, tItem.playerItemId)
			-- WndCrazyGashaponShake:setOpenState(false)
			WndCrazyGashaponShake:showOpenAction(tItem)
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
function WndCrazyGashapon:updatePlayerItemData()
	WZLog("WndCrazyGashapon:updatePlayerItemData")
	if self.m_root ~= nil then
		self:_updateLightNum()
		self:showRedDot()
	end
end

--@brief 	设置射箭的状态
function WndCrazyGashapon:setOpenState(state)
	if self.m_root == nil then return end 

	self.m_bOpenState = state
end

--@brief 	阿拉伯数字转中文
function WndCrazyGashapon:convertNum2chinese(number)
	assert(tonumber(number), "传入参数非正确number类型！")

	--特殊处理
	if number == 2 then
		return LocalStrings.CRAZY_GASHAPON_TEXT6
	end

	local numerical_tbl = {}
	local str0 = LocalStrings.CRAZY_GASHAPON_TEXT4[1]
	local str1 = LocalStrings.CRAZY_GASHAPON_TEXT4[2]
	local str2 = LocalStrings.CRAZY_GASHAPON_TEXT4[3]
	local str3 = LocalStrings.CRAZY_GASHAPON_TEXT4[4]
	local str4 = LocalStrings.CRAZY_GASHAPON_TEXT4[5]
	local str5 = LocalStrings.CRAZY_GASHAPON_TEXT4[6]
	local str6 = LocalStrings.CRAZY_GASHAPON_TEXT4[7]
	local str7 = LocalStrings.CRAZY_GASHAPON_TEXT4[8]
	local str8 = LocalStrings.CRAZY_GASHAPON_TEXT4[9]
	local str9 = LocalStrings.CRAZY_GASHAPON_TEXT4[10]
	local numerical_names = {[0] = str0, str1, str2, str3, str4, str5, str6, str7, str8, str9}

	local strShi = LocalStrings.CRAZY_GASHAPON_TEXT5[1]
	local strBai = LocalStrings.CRAZY_GASHAPON_TEXT5[2]
	local strqian = LocalStrings.CRAZY_GASHAPON_TEXT5[3]
	local strWan = LocalStrings.CRAZY_GASHAPON_TEXT5[4]
	local strYi = LocalStrings.CRAZY_GASHAPON_TEXT5[5]
	local strZhao = LocalStrings.CRAZY_GASHAPON_TEXT5[6]
	local numerical_units = {"", strShi, strBai, strqian, strWan, strShi, strBai, strqian, strYi, strShi, strBai, strqian, strZhao, strShi, strBai, strqian}

	if number == 10 then
		return strShi
	end

	--01，数字转成表结构存储
	local numerical_length = string.len(number)
	for i = 1, numerical_length do
		numerical_tbl[i] = tonumber(string.sub(number, i, i))
	end

	--02，对应数字转中文处理
	local result_numberical = ""
	local to_append_zero, need_filling = false, true
	for index, number in ipairs(numerical_tbl) do
		--从高位到底位的顺序数字转成对应的从低位到高位的顺序数字单位.
		local real_unit_index = numerical_length - index + 1
		if number == 0 then
			if need_filling then
				if real_unit_index == 5 then--万位
					result_numberical = result_numberical .. LocalStrings.CRAZY_GASHAPON_TEXT5[5]
					need_filling = false
				end
				if real_unit_index == 9 then--亿位
					result_numberical = result_numberical .. LocalStrings.CRAZY_GASHAPON_TEXT5[9]
					need_filling = false
				end
				if real_unit_index == 13 then--兆位
					result_numberical = result_numberical .. LocalStrings.CRAZY_GASHAPON_TEXT5[13]
					need_filling = false
				end
			end
			to_append_zero = true
		else
			if to_append_zero then
				result_numberical = result_numberical .. LocalStrings.CRAZY_GASHAPON_TEXT4[1]
				to_append_zero = false
			end
			result_numberical = result_numberical  .. numerical_names[number] .. numerical_units[real_unit_index]
			if real_unit_index == 5 or real_unit_index == 9 or real_unit_index == 13 then
				need_filling = false
			else
				need_filling = true
			end
		end
	end
	return result_numberical
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief 	解析大奖数据
function WndCrazyGashapon:_analyzeBigReward()
	-- body
	local sBigReward = self.m_tContent.firstRewards
	local array = SplitStringWithSeparator(sBigReward, "&")
	local nSex = CacheCenter:getPlayerInfo().sex
	local tItem = {reward_ids1 = {}, reward_nums1 = {}, name = LocalStrings.CRAZY_GASHAPON_TEXT1[10]}
	self.m_tBigRewardList = {}
	for i = 1, #array do
--		WZLog("WndCrazyGashapon:_analyzeBigReward", string.sub(array[i], 2, -2))
		local string = string.sub(array[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string,",")[3])

		table.insert(tItem.reward_ids1, id)
		table.insert(tItem.reward_nums1, num)
	end

	self.m_tBigRewardList[1] = tItem

	local specialReward = self.m_tContent.superRewards
	local array1 = SplitStringWithSeparator(specialReward, "&")
	local tItem1 = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.CRAZY_GASHAPON_TEXT1[11]}
	for i = 1, #array1 do
--		WZLog("WndCrazyGashapon:_analyzeBigReward", string.sub(array1[i], 2, -2))
		local string = string.sub(array1[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string, ",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string, ",")[3])
		
		table.insert(tItem1.reward_ids2, id)
		table.insert(tItem1.reward_nums2, num)
	end

	self.m_tBigRewardList[2] = tItem1
end


--@brief 	关闭抽奖奖励展示界面回调
function WndCrazyGashapon:_afterCloseReward()
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
		WndHoraryBigReward:showInterface(7, self.m_tOpenResult.normalRewards, tBigReward)
	elseif #tBigReward > 0 then 
		WndHoraryBigReward:showInterface(6, tBigReward)
	end
end




-------------------------------------私有方法模块End----------------------------------------
