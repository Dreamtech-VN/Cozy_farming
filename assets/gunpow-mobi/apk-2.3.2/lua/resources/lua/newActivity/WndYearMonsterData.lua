--WndYearMonsterData.lua
--@brief	WndYearMonster的数据模块
--@date		2021/12/09
--@author	XTX
--@note		年兽大作战活动主界面

WndYearMonster = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndYearMonster:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_tBigRewardList = nil 		--大奖和特奖奖励
	self.m_bOpenState = false 
	self.m_tOpenResult = nil 
	self.m_nGiftRewardNum = 0 
	self.m_nCurHp = 0 
	self.m_nMaxHp = 1 
	self.m_tMonsterType = {"ui/activityWords/text_hd_nsdzz_n.png", "ui/activityWords/text_hd_nsdzz_x.png", "ui/activityWords/text_hd_nsdzz_s.png"}
	self.m_tMonsterTypeAni = {"ui_activity_nsdzz3", "ui_activity_nsdzz2", "ui_activity_nsdzz1"}
	self.m_nMonsterType = 0 
	self.m_nLastMonsterType = 0 
	self.m_nMonsterIndex = 1  --第几只年兽
	self.m_nCoinId = 160185
	self.m_nUpdateInterval = 0 	--更新怪物血量间隔
	self.m_nChooseReward = 0 	--选择奖励状态0：弹出预览界面；1：不弹
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndYearMonster:_unInit()
	self.m_root = nil
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_tBigRewardList = nil 		--大奖和特奖奖励
	self.m_bOpenState = false 
	self.m_tOpenResult = nil 
	self.m_nGiftRewardNum = nil 
	self.m_nCurHp = nil 
	self.m_nMaxHp = nil 
	self.m_tMonsterType = nil 
	self.m_nMonsterType = nil 
	self.m_nLastMonsterType = nil
	self.m_nMonsterIndex = nil 
	self.m_nCoinId = nil 
	self.m_nUpdateInterval = nil 
	self.m_tMonsterTypeAni = nil 
	self.m_nChooseReward = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndYearMonster:createElement()
	if WndYearMonster.m_root ~= nil then
		WindowManager:removeWindow(WndYearMonster.m_root, WndYearMonster, true)
	end
	local element = WZUISystem:getInstance():createElement("WndYearMonster")
	assert(element, "WndYearMonster create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndYearMonster:showInterface()
	LoadNewActivityRes(true)
	local wndWater = WndYearMonster:createElement()
	if wndWater then 
		WindowManager:addWindow(wndWater, WndYearMonster, false)
	end
end

--@brief 	获取活动详情成功
function WndYearMonster:GetActivityInfoOK(activityId,maxCount,count,status, rewardCounts, rewardItems, rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	-- body
	WZLog("WndYearMonster:GetActivityInfoOK", g_cityExtenInfo.activity7035, activityId, content)
	if g_cityExtenInfo.activity7035 == activityId then 
		self.m_tContent = json.decode(content)
		self.m_nStartTime = startTime 
		self.m_nEndTime = endTime 
		self.m_nActivityId = activityId
		self.m_nChooseReward = GetOperateTimes("YEARMONSTERACTIVITYID", self.m_nActivityId) 

		self:_analyzeBigReward()
		self:_update()
	end
end

--@brief 	获取其他活动数据
function WndYearMonster:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end 

	if doType == 1 then --年兽的血量
		local tResult = json.decode(jsonData)

		self.m_nCurHp = tResult.target - tResult.progress
		self.m_nMaxHp = tResult.target

		self:_updateMonsterBlood()
		--特奖限量
		local nSex = CacheCenter:getPlayerInfo().sex
		for i = 1, #tResult.globalLimitSuper do
			local tab = {}
			tab.id = i - 1
			tab.limitNum = tResult.playerLimitSuperConfig[i]
			tab.dailyLimit = tResult.globalLimitSuperConfig[i]
			tab.dailyBuyNum = tResult.globalLimitSuper[i]
			tab.soldNum = tResult.playerLimitSuper[i]
			if utilsValueInTable(i - 1, tResult.optionalListSuper) then 
				self.m_tBigRewardList[2].chooseState[i] = 1
			else
				self.m_tBigRewardList[2].chooseState[i] = 0
			end
			
			self.m_tBigRewardList[2].leftConfig[i] = tab
		end
	elseif doType == 2 then --年兽类型，大礼数量
		local tResult = json.decode(jsonData)

		self.m_nGiftRewardNum = tResult.joinRewardSum
		self.m_nMonsterIndex = tResult.version
		self.m_nLastMonsterType = self.m_nMonsterType
		if tResult.currentRewardType == "rewardA" then 
			self.m_nMonsterType = 1
		elseif tResult.currentRewardType == "rewardB" then 
			self.m_nMonsterType = 2
		elseif tResult.currentRewardType == "rewardC" then 
			self.m_nMonsterType = 3
		end
		WZLog("WndYearMonster:_onGetOtherData", self.m_nGiftRewardNum, tResult.currentRewardType, self.m_nMonsterType, self.m_nMonsterIndex)
		self:updateMonsterType()
		self:showBagGiftInfo()
	elseif doType == 3 then --开启结果
		local tResult = json.decode(jsonData)
		self.m_tOpenResult = {}
		local tempItemIds = {}
		local tempItemNums = {}
		local nTempNums = 0
		for i = 1, #tResult.itemIds do
			if tResult.itemIds[i] ~= 160186 then 
				table.insert(tempItemIds, tResult.itemIds[i])
				table.insert(tempItemNums, tResult.itemNums[i])
			else
				nTempNums = nTempNums + tResult.itemNums[i]
			end
		end
		self.m_tOpenResult.ysqNum = nTempNums
		self.m_tOpenResult.itemIds = tempItemIds
		self.m_tOpenResult.itemNums = tempItemNums
		self.m_tOpenResult.bigRewards = {} --大奖特奖
		if #tResult.fItemIds > 0 then 
			for i = 1, #tResult.fItemIds do
				local tItem = {}
				tItem.itemId = tResult.fItemIds[i]
				tItem.itemNum = tResult.fItemNums[i]
				tItem.type = 5

				table.insert(self.m_tOpenResult.bigRewards, tItem)
			end
		end

		if #tResult.sItemIds > 0 then 
			for i = 1, #tResult.sItemIds do
				local tItem = {}
				tItem.itemId = tResult.sItemIds[i]
				tItem.itemNum = tResult.sItemNums[i]
				tItem.type = 6

				table.insert(self.m_tOpenResult.bigRewards, tItem)
			end
		end

		if result == 1 then 
			self:showOpenAction()
		end
	elseif doType == 6 then --新年大礼
		local tResult = json.decode(jsonData)

		if result == 1 then 
			WndRewardShow:showById(tResult.itemIds, tResult.itemNums)
		end
	elseif doType == 8 then 
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
function WndYearMonster:updatePlayerItemData()
	WZLog("WndYearMonster:updatePlayerItemData")
	if self.m_root ~= nil then
		self:_updateLightNum()
	end
end

--@brief 	设置射箭的状态
function WndYearMonster:setOpenState(state)
	-- body
	if self.m_root == nil then return end 

	self.m_bOpenState = state
end

--@brief 	设置刷新血量间隔
function WndYearMonster:setUpdateInterval()
	if self.m_root == nil then return end 

	self.m_nUpdateInterval = 0 
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 7, "")
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	关闭抽奖奖励展示界面回调
function WndYearMonster:_afterCloseReward()
	if self.m_root == nil then return end 

	if self.m_tOpenResult.bigRewards and #self.m_tOpenResult.bigRewards > 0 then 
		WndHoraryBigReward:showInterface(6, self.m_tOpenResult.bigRewards)
	end
end

--@brief 	解析大奖数据
function WndYearMonster:_analyzeBigReward()
	-- body
	local sBigReward = self.m_tContent.firstRewards
	local array = SplitStringWithSeparator(sBigReward, "&")
	local nSex = CacheCenter:getPlayerInfo().sex
	local tItem = {reward_ids1 = {}, reward_nums1 = {}, name = LocalStrings.ACTIVITY_TEXT18}
	self.m_tBigRewardList = {}
	for i = 1, #array do
		WZLog("WndYearMonster:_analyzeBigReward", string.sub(array[i], 2, -2))
		local string = string.sub(array[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string,",")[3])

		table.insert(tItem.reward_ids1, id)
		table.insert(tItem.reward_nums1, num)
	end

	self.m_tBigRewardList[1] = tItem

	local specialReward = self.m_tContent.superRewards
	local array1 = SplitStringWithSeparator(specialReward, "&")
	local tItem1 = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.ACTIVITY_TEXT19, strAtt = LocalStrings.GONGANDDRUM_TEXT1[16], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31}
	for i = 1, #array1 do
		WZLog("WndYearMonster:_analyzeBigReward", string.sub(array1[i], 2, -2))
		local string = string.sub(array1[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string, ",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string, ",")[3])
		
		table.insert(tItem1.reward_ids2, id)
		table.insert(tItem1.reward_nums2, num)
	end

	self.m_tBigRewardList[2] = tItem1
end
-------------------------------------私有方法模块End----------------------------------------
