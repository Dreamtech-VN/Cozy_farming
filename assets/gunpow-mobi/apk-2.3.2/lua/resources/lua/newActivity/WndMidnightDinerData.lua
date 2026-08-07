--WndMidnightDinerData.lua
--@brief	WndMidnightDiner的数据模块
--@date		2022/10/08
--@author	XTX
--@note		深夜食堂活动主界面

WndMidnightDiner = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndMidnightDiner:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_tBigRewardList = nil 		--大奖和特奖奖励
	self.m_bOpenState = false 
	self.m_tOpenResult = nil 
	self.m_nCoinId = 160344
	self.m_nCount = 0  					--当天累计抽奖次数
	self.m_nPoleType = 0 			--0：云吞；1：烤串；2：小龙虾
	self.m_tGlovesCost = {1, 2, 3}  --不同食物消耗的夜宵券数量
	self.m_nMaxLotteryCount = 20    --最大抽奖次数
	self.m_tBallAniName = {{"ui/newActivity/common_pic_syst_cai_01.png", "wait1", 0.285},{"ui/newActivity/common_pic_syst_cai_02.png", "wait2", 0.2725},{"ui/newActivity/common_pic_syst_cai_03.png", "wait3", 0.2725}}
	self.m_tRandomTaskInfo = nil
	self.m_nRandomTaskEndTime = -1 --随机任务结束时间
	self.m_conTeamReward = nil 
	self.m_nGiftRewardNum = 0 	--特饮数量
	self.m_nRefreshTime = 0 	--定时请求随机深夜打卡任务数据
	self.m_bIsNeedRefresh = true 	--是否需要刷新
	self.m_nChooseReward = 0 		--选择奖励状态0：弹出预览界面；1：不弹
	self.m_bIsOpenReward = false 
	self.m_tGetTimes = {} 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndMidnightDiner:_unInit()
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
	self.m_nPoleType = nil 
	self.m_tGlovesCost = nil 
	self.m_nMaxLotteryCount = nil 
	self.m_tBallAniName = nil 
	self.m_tRandomTaskInfo = nil 
	self.m_nRandomTaskEndTime = nil --随机任务结束时间
	self.m_conTeamReward = nil 
	self.m_nGiftRewardNum = nil
	self.m_nRefreshTime = nil 
	self.m_bIsNeedRefresh = nil 
	self.m_nChooseReward = nil 		--选择奖励状态0：弹出预览界面；1：不弹
	self.m_bIsOpenReward = nil 
	self.m_tGetTimes = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndMidnightDiner:createElement()
	if WndMidnightDiner.m_root ~= nil then
		WindowManager:removeWindow(WndMidnightDiner.m_root, WndMidnightDiner, true)
	end
	local element = WZUISystem:getInstance():createElement("WndMidnightDiner")
	assert(element, "WndMidnightDiner create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndMidnightDiner:showInterface()
	LoadNewActivityRes(true)
	local wndWater = WndMidnightDiner:createElement()
	if wndWater then 
		WindowManager:addWindow(wndWater, WndMidnightDiner, false)
	end
end

--@brief 	获取活动详情成功
function WndMidnightDiner:GetActivityInfoOK(activityId,maxCount,count,status, rewardCounts, rewardItems, rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	-- body
	WZLog("WndMidnightDiner:GetActivityInfoOK", g_cityExtenInfo.activity7058, activityId, content)
	if g_cityExtenInfo.activity7058 == activityId then 
		self.m_tContent = json.decode(content)
		WZLog("WndMidnightDiner:GetActivityInfoOK", Serialize(self.m_tContent))
		self.m_nStartTime = startTime 
		self.m_nEndTime = endTime 
		self.m_nActivityId = activityId
		self.m_nCount = count
		self.m_tGlovesCost = self.m_tContent.cost
		self.m_nGiftRewardNum = maxCount
		self.m_nChooseReward = GetOperateTimes("MIDNIGHTDINERACTIVITYID", self.m_nActivityId) 

		self:_analyzeBigReward()
		self:_update()
	end
end

--@brief 	获取其他活动数据
function WndMidnightDiner:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end 

	if doType == 7 then --随机深夜打卡任务数据
		local tResult = json.decode(jsonData)
		WZLog("WndMidnightDiner:_onGetOtherData 111", Serialize(tResult))
		if self.m_tRandomTaskInfo == nil then 
			self.m_tRandomTaskInfo = {}
			self.m_bIsNeedRefresh = true
		end
		if self.m_tRandomTaskInfo and (self.m_tRandomTaskInfo.id and self.m_tRandomTaskInfo.id ~= tResult.dkTaskId or self.m_tRandomTaskInfo.status and self.m_tRandomTaskInfo.status ~= tResult.dkTaskStatus) then 
			self.m_bIsNeedRefresh = true
		end
		self.m_tRandomTaskInfo.id = tResult.dkTaskId
		self.m_tRandomTaskInfo.target = tResult.dkTaskTarget
		self.m_tRandomTaskInfo.progress = tResult.dkTaskProgress
		self.m_tRandomTaskInfo.status = tResult.dkTaskStatus

		self.m_nRandomTaskEndTime = tResult.dkTaskRemainTime
		self.m_nRefreshTime = 0

		self:_showRandomTask()
	elseif doType == 6 then --开启结果
		local tResult = json.decode(jsonData)
		WZLog("WndMidnightDiner:_onGetOtherData 333", Serialize(tResult))
		self.m_tOpenResult = {}

		self.m_tOpenResult.normalRewards = {} --常规奖
		self.m_tOpenResult.firstRewards = {} --达人奖
		self.m_tOpenResult.bigRewards = {} --网红奖
		self.m_tOpenResult.starRewards = {} --明星奖

		local rewardType = 10 
		for i = 1, #tResult.itemNums do
			local tItem = {}
			tItem.itemId = tResult.itemIds[i]
			tItem.itemNum = tResult.itemNums[i]
			tItem.type = rewardType
			table.insert(self.m_tOpenResult.normalRewards, tItem)
		end

		--达人奖
		for j = 1, #tResult.fAItemIds do
			local tItem = {}

			tItem.itemId = tResult.fAItemIds[j]
			tItem.itemNum = tResult.fAItemNums[j]
			tItem.type = 23

			table.insert(self.m_tOpenResult.firstRewards, tItem)
		end
		--网红奖
		for j = 1, #tResult.fBItemIds do
			local tItem = {}

			tItem.itemId = tResult.fBItemIds[j]
			tItem.itemNum = tResult.fBItemNums[j]
			tItem.type = 24

			table.insert(self.m_tOpenResult.bigRewards, tItem)
		end
		--明星奖
		for j = 1, #tResult.sItemIds do
			local tItem = {}

			tItem.itemId = tResult.sItemIds[j]
			tItem.itemNum = tResult.sItemNums[j]
			tItem.type = 25

			table.insert(self.m_tOpenResult.starRewards, tItem)
		end

		if result == 1 then 
			self.m_nCount = tResult.count
			self.m_nGiftRewardNum = tResult.maxCount

			self:showOpenAction()
			self:_setFreeBtnText()
			self:showBagGiftInfo()
		else
			self:setOpenState(false)
		end
	elseif doType == 9 then --领取特饮奖励
		local tResult = json.decode(jsonData)
		WZLog("WndMidnightDiner:_onGetOtherData 333", Serialize(tResult))
		self.m_tOpenResult = {}

		self.m_tOpenResult.normalRewards = {} --常规奖

		local rewardType = 10 
		for i = 1, #tResult.itemNums do
			local tItem = {}
			tItem.itemId = tResult.itemIds[i]
			tItem.itemNum = tResult.itemNums[i]
			tItem.type = rewardType
			table.insert(self.m_tOpenResult.normalRewards, tItem)
		end

		self.m_nGiftRewardNum = tResult.maxCount

		self:showBagGiftInfo()
		self:_afterCloseReward()
		self:setOpenState(false)
	elseif doType == 10 then --大奖限量
		local tResult = json.decode(jsonData)
		local nSex = CacheCenter:getPlayerInfo().sex
		local sBigReward = tResult.rewards
		local array = SplitStringWithSeparator(sBigReward, "&")

		table.insert(self.m_tGetTimes, tResult.pool)
		local tItem = {}
		if tResult.pool == 1 then 
			tItem = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.MIDNIGHTDINER_TEXT1[9], strAtt = LocalStrings.GONGANDDRUM_TEXT1[16], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31, pool = tResult.pool}
		elseif tResult.pool == 2 then 
			tItem = {reward_ids = {}, reward_nums = {}, name = LocalStrings.MIDNIGHTDINER_TEXT1[10], strAtt = LocalStrings.GONGANDDRUM_TEXT1[16], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31, pool = tResult.pool}
		end
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
			if tResult.pool == 1 then 
				table.insert(tItem.reward_ids2, id)
				table.insert(tItem.reward_nums2, num)
			elseif tResult.pool == 2 then 
				table.insert(tItem.reward_ids, id)
				table.insert(tItem.reward_nums, num)
			end
		end
		if tResult.pool == 1 then 
			self.m_tBigRewardList[2] = tItem
		elseif tResult.pool == 2 then 
			self.m_tBigRewardList[3] = tItem
		end

		if self.m_bIsOpenReward and self.m_tGetTimes and #self.m_tGetTimes == 2 then 
			self.m_bIsOpenReward = false 
			local otherData = {}
			otherData.winType = 1
			otherData.activityId = self.m_nActivityId
			otherData.otherRewardData = self.m_tBigRewardList[3]
			otherData.chooseInfo = {strKey="MIDNIGHTDINER_TEXT1", wordIndex=8, doType=11}

			WndJoinReward:showInterface("", self.m_tBigRewardList[1], self.m_tBigRewardList[2], LocalStrings.TREASURE_TEXT7, nil, 3, otherData, 3)
		end
	elseif doType == 11 then 
		local tResult = json.decode(jsonData)
		if result == 0 then 
			local tTempList = nil 
			local nTag = 2 
			if tResult.pool == 1 then 
				nTag = 2 
				tTempList = self.m_tBigRewardList[2]
			elseif tResult.pool == 2 then 
				nTag = 4 
				tTempList = self.m_tBigRewardList[3]
			end
			tTempList.chooseState[tResult.id + 1] = tResult.status
			if tResult.status == 1 then 
				WndJoinReward:chooseReturn(nTag, tResult.id + 1, tResult.status)
			end
		elseif result == 1 then
			MsgBoxManager:showTipBox(LocalStrings.SUMMERSURF_TEXT1[24])
		end
	end
end

--@brief	缓存推送更新物品时调用的函数
function WndMidnightDiner:updatePlayerItemData()
	WZLog("WndMidnightDiner:updatePlayerItemData")
	if self.m_root ~= nil then
		self:_updateLightNum()
		self:showRedDot()
	end
end

--@brief 	设置射箭的状态
function WndMidnightDiner:setOpenState(state)
	-- body
	if self.m_root == nil then return end 

	self.m_bOpenState = state
end


function WndMidnightDiner:_onGetNewYearTaskGetResult(activityId, taskId, activityType, rewardItems, rewardCount)
	local taskData = GDatatab_new_activity_task["id_" .. taskId]
	self:setOpenState(false)
	if taskData and taskData.group_by == 4 then 
		self.m_tRandomTaskInfo.status = 1
		
		self.m_bIsNeedRefresh = true
		self:_showRandomTask()
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	关闭抽奖奖励展示界面回调
function WndMidnightDiner:_afterCloseReward()
	if self.m_root == nil then return end 

	local tBigReward = {}
	local nIndex = 1
	if self.m_tOpenResult.firstRewards and #self.m_tOpenResult.firstRewards > 0 then 
		for i = 1, #self.m_tOpenResult.firstRewards do
			table.insert(tBigReward, self.m_tOpenResult.firstRewards[i])
		end
	end
	if self.m_tOpenResult.bigRewards and #self.m_tOpenResult.bigRewards > 0 then 
		for i = 1, #self.m_tOpenResult.bigRewards do
			table.insert(tBigReward, self.m_tOpenResult.bigRewards[i])
		end
	end
	if self.m_tOpenResult.starRewards and #self.m_tOpenResult.starRewards > 0 then 
		for i = 1, #self.m_tOpenResult.starRewards do
			table.insert(tBigReward, self.m_tOpenResult.starRewards[i])
		end
	end

	if self.m_tOpenResult.normalRewards and #self.m_tOpenResult.normalRewards > 0 then 
		WndHoraryBigReward:showInterface(7, self.m_tOpenResult.normalRewards, tBigReward)
	elseif #tBigReward > 0 then 
		WndHoraryBigReward:showInterface(6, tBigReward)
	end
end

--@brief 	解析大奖数据
function WndMidnightDiner:_analyzeBigReward()
	-- body
	local sBigReward = self.m_tContent.firstARewards
	local array = SplitStringWithSeparator(sBigReward, "&")
	local nSex = CacheCenter:getPlayerInfo().sex
	local tItem = {reward_ids1 = {}, reward_nums1 = {}, name = LocalStrings.MIDNIGHTDINER_TEXT1[8]}
	self.m_tBigRewardList = {}
	for i = 1, #array do
--		WZLog("WndMidnightDiner:_analyzeBigReward", string.sub(array[i], 2, -2))
		local string = string.sub(array[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string,",")[3])

		table.insert(tItem.reward_ids1, id)
		table.insert(tItem.reward_nums1, num)
	end

	self.m_tBigRewardList[1] = tItem

	local specialReward = self.m_tContent.firstBRewards
	local array1 = SplitStringWithSeparator(specialReward, "&")
	local tItem1 = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.MIDNIGHTDINER_TEXT1[9]}
	for i = 1, #array1 do
--		WZLog("WndMidnightDiner:_analyzeBigReward", string.sub(array1[i], 2, -2))
		local string = string.sub(array1[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string, ",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string, ",")[3])
		
		table.insert(tItem1.reward_ids2, id)
		table.insert(tItem1.reward_nums2, num)
	end

	self.m_tBigRewardList[2] = tItem1

	local specialReward = self.m_tContent.superRewards
	local array2 = SplitStringWithSeparator(specialReward, "&")
	local tItem2 = {reward_ids = {}, reward_nums = {}, name = LocalStrings.MIDNIGHTDINER_TEXT1[10]}
	for i = 1, #array2 do
--		WZLog("WndMidnightDiner:_analyzeBigReward", string.sub(array2[i], 2, -2))
		local string = string.sub(array2[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string, ",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string, ",")[3])
		
		table.insert(tItem2.reward_ids, id)
		table.insert(tItem2.reward_nums, num)
	end

	self.m_tBigRewardList[3] = tItem2
end

--@brief    添加保存上次选择球杆
function WndMidnightDiner:savePoleType()
    WZLog("WndMidnightDiner:savePoleType")
    local _KeyString = ""
    local curDate = os.date("*t", SystemTime:getServerTime())
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = "MIDNIGHTDINER" .. tostring(CacheCenter:getPlayerInfo().id)
    local strValue =  data:getStringValue("MIDNIGHTDINER_FOOD_MARK", _KeyString)
    local curValue = string.format("%02d%02d_%d", curDate.month, curDate.day, self.m_nPoleType)
    if strValue == nil or strValue == "" or strValue ~= curValue then
        data:setStringValue("MIDNIGHTDINER_FOOD_MARK", _KeyString, curValue)
        data:flush()
    end
end

--@brief    获取上次保存的球杆
function WndMidnightDiner:getPoleType()
    WZLog("WndMidnightDiner:getPoleType")
    local _KeyString = ""
    local curDate = os.date("*t", SystemTime:getServerTime())
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = "MIDNIGHTDINER" .. tostring(CacheCenter:getPlayerInfo().id)
    local strValue =  data:getStringValue("MIDNIGHTDINER_FOOD_MARK", _KeyString)
    local curValue = string.format("%02d%02d", curDate.month, curDate.day)
    if strValue ~= nil and strValue ~= "" then
        local result = SplitStringWithSeparator(strValue, "_")
        if result[1] == curValue then 
        	self.m_nPoleType = tonumber(result[2])
        	if self.m_nPoleType ~= 0 then 
        		GetElement(self.m_root, "cbgTool_WndMidnightDiner", WZUICheckBoxGroup):setCheckIndex(self.m_nPoleType)
        	end
        end
    end
end


-------------------------------------私有方法模块End----------------------------------------
