--WndHappyShakeData.lua
--@brief	WndHappyShake的数据模块
--@date		2020/05/27
--@author	XTX
--@note		全民摇摇乐活动界面

WndHappyShake = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndHappyShake:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nActivityId = nil  
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_nServerTime = nil 
	self.m_nCount = nil 
	self.m_tRewardData = nil 
	self.m_tBoxData = nil 
	self.m_tTips = nil 
	self.m_nTabTimesIndex = 1       	--倍数选择
	self.m_nSelRewardIndex = nil 		--选中的奖励索引
	self.m_tSelRewardCell = nil 		--选中的奖励cell
	self.m_tTarget = nil 				--单次刷新消耗
	self.m_nMaxCount = nil 				--牌型索引0,1,2...
	self.m_nStatus = 0 					--按钮状态
	self.m_nCheckIndex = 0				--跳过动画按钮状态
	self.t_nConListPosY = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndHappyShake:_unInit()
	self.m_root = nil
	self.m_nActivityId = nil  
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_nServerTime = nil 
	self.m_nCount = nil 
	self.m_tRewardData = nil 
	self.m_tBoxData = nil 
	self.m_tTips = nil 
	self.m_nTabTimesIndex = nil 
	self.m_nSelRewardIndex = nil 		--选中的奖励索引
	self.m_tSelRewardCell = nil 		--选中的奖励cell
	self.m_tTarget = nil 
	self.m_nMaxCount = nil
	self.m_nStatus = nil
	self.m_nCheckIndex = nil
	self.t_nConListPosY = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndHappyShake:createElement()
	if WndHappyShake.m_root ~= nil then
		WindowManager:removeWindow(WndHappyShake.m_root, WndHappyShake, true)
	end
	local element = WZUISystem:getInstance():createElement("WndHappyShake")
	assert(element, "WndHappyShake create element failed!")
	self:_init()
	return element
end

--@brief 	设置活动数据
function WndHappyShake:setMessage(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts, count, maxCount, target)
	-- body
	self.m_nActivityId = activityId 
	self.m_tTips = tips
	self.m_nStartTime = startTime 
	self.m_nEndTime = endTime 
	self.m_nServerTime = serverTime 
	WZLog("WndHappyShake:setMessage 000", activityId, Serialize(tips), startTime, endTime, serverTime, self.m_nCount)
	--奖励数据
	local bCallUpdateFun = true 
	if self.m_tRewardData == nil then 
		bCallUpdateFun = false
	end
	self.m_tRewardData = {}
	local nIndex = 1
	local nRechargeNum = 3
	for i = 1, nRechargeNum do
		local tItem = {}
		tItem.rewardId = rewardId[i]
		tItem.times = rewardId[i]

		tItem.cost = {}
		tItem.cost[1] = status[i]
		tItem.cost[2] = tonumber(tips[i])
		tItem.reward = {}
		for j = 1, rewardCounts[i] do
			table.insert(tItem.reward, {rewardItems[nIndex], rewardItemsParamCount[nIndex]})

			nIndex = nIndex + 1
		end

		table.insert(self.m_tRewardData, tItem)
	end
	self.m_tTarget = {}
	local nRefreshTimes = #target/3
	for i = 1, nRefreshTimes do
		local tItem = {}
		tItem[1] = target[2 + (i - 1) * 3]
		tItem[2] = target[3 + (i - 1) * 3]

		table.insert(self.m_tTarget, tItem)
	end
	WZLog("WndHappyShake:setMessage 111", Serialize(rewardCounts), Serialize(status), Serialize(self.m_tRewardData))
	if bCallUpdateFun then 
		self:_update()
	end
end

--拉杆信息
function WndHappyShake:setTreasureInfo(marks, status, reset, num, pokerType)
	-- body
	WZLog("WndHappyShake:setTreasureInfo ",Serialize(marks),Serialize(status),reset, num, pokerType)
	if self.m_root == nil then return end
	local raffleMark = {}
	local sharp = {}
	for i = 1, #marks do
		local id = SplitStringWithSeparator(marks[i], "-")[1]
		local num = SplitStringWithSeparator(marks[i], "-")[2]

		table.insert(raffleMark, tonumber(id))
		table.insert(sharp, tonumber(num))
	end
	self:_setPositionPoker(raffleMark, sharp)

	self.m_tRaffleMark = {}
	for i = 1, #raffleMark do
		local nNewMark = math.fmod(raffleMark[i], 8) + 1

		self.m_tRaffleMark[i] = nNewMark
	end

	self.m_nCount = num  
	self.m_nMaxCount = pokerType + 1

	self.m_nStatus = status[1]
	self.m_nRaffleReset = #self.m_tTarget - reset
	if self.m_nStatus == 1 then 
		for i = 1, #self.m_tRewardData do
			if self.m_tRewardData[i].times == status[2] then 
				self.m_nTabTimesIndex = i
				break 
			end
		end
		self.m_nSelRewardIndex = status[3]
	end
	self:_update()

	self:updateUI()
end

--拉杆抽奖成功
function WndHappyShake:raffleSuccess(marks, rewardType, rewardTimes)
	-- body
	WZLog("WndHappyShake:raffleSuccess ",Serialize(marks))
	if self.m_root == nil then return end

	local raffleMark = {}
	local sharp = {}
	for i = 1, #marks do
		local id = SplitStringWithSeparator(marks[i], "-")[1]
		local num = SplitStringWithSeparator(marks[i], "-")[2]

		table.insert(raffleMark, tonumber(id))
		table.insert(sharp, tonumber(num))
	end
	WZLog("WndHappyShake:raffleSuccess ",Serialize(raffleMark))
	self:_setPositionPoker(raffleMark, sharp)

	self.m_tLuckDrawData = {}
	for i = 1, #raffleMark do
		local nNewMark = math.fmod(raffleMark[i], 8) + 1

		self.m_tLuckDrawData[i] = nNewMark
	end

	self.m_nMaxCount = rewardType + 1
	self.m_nCount = rewardTimes

	self.m_nStatus = 1
	self.m_nRaffleReset = 0
	GetElement(self.m_root,"conAll_WndHappyShake",WZUIContainer):setTouchEnable(false)
	self:_startRoll()
end

--重置单个槽位
function WndHappyShake:resertSingleSlot(marks, rewardType, rewardTimes)
	-- body
	WZLog("WndHappyShake:resertSingleSlot ",Serialize(self.m_tRaffleMark), self.m_nTag, rewardType, rewardTimes)
	if self.m_root == nil then return end
	GetElement(self.m_root,"conAll_WndHappyShake",WZUIContainer):setTouchEnable(false)

	local id = SplitStringWithSeparator(marks, "-")[1]
	local num = SplitStringWithSeparator(marks, "-")[2]
	self:_setPositionPoker(tonumber(id), tonumber(num), self.m_nTag)

	self.m_tLuckDrawData = self.m_tRaffleMark
	self.m_tLuckDrawData[self.m_nTag] = math.fmod(tonumber(id), 8) + 1
	self.m_nSingleRaffleMark = math.fmod(tonumber(id), 8) + 1

	self.m_nMaxCount = rewardType + 1
	self.m_nCount = rewardTimes
	self.m_nRaffleReset  = self.m_nRaffleReset  + 1
	self:_startSingleRoll()
end

--@brief 	领取奖励成功
function WndHappyShake:getRewardOK(itemId, itemNum, status)
	-- body
	self.m_nStatus = status 

	self:updateUI()

	WndRewardShow:showById(itemId, itemNum, nil, nil, nil, nil, nil, 3, string.format(LocalStrings.FOURYEAR_TEXT21, LocalStrings.FOURYEAR_TEXT13[self.m_nMaxCount], self.m_nCount * self.m_tRewardData[self.m_nTabTimesIndex].times))

	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activityPokerStatus, g_tGameActivityTypes.ACTIVITY_HAPPYSHAKE)

	ProtocolProcessorNewActivity:send_ACTIVITY2_GetPokerTaskList()
end

--@brief 	任务数据
function WndHappyShake:getActivityTaskListOk( id, status, target, complete, refreshTime )
	-- body
	if self.m_root == nil then return end 
	WZLog("WndHappyShake:getActivityTaskListOk", Serialize(status))
	local bHaveRedDot = false 
	for i = 1, #id do
		if status[i] == 1 then
			bHaveRedDot = true
			break 
		end
	end

	GetElement(self.m_root, "imgRedDot_WndHappyShake", WZUIImage):setVisible(bHaveRedDot)

	if not bHaveRedDot and self.m_nStatus ~= 1 then 
		if SceneCity.m_root then 
			local btnShake = GetElementWithoutAssert(SceneCity.m_root, "btn" .. ISLAND_UP_HAPPYSHAKE .. "_WndOwnCity", WZUIButton)
			GlobalGame.g_tRedPointList.happyShake = false
		    SceneCity:setRedPoint(btnShake,false)
		end
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
