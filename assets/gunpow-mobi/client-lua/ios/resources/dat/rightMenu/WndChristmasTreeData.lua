--WndChristmasTreeData.lua
--@brief	WndChristmasTree的数据模块
--@date		2017/12/05
--@author	Tianxiang_Xu
--@note		圣诞树活动

WndChristmasTree = {
	--请不要在这里定义变量
}

CellChristmasRankItem = {
	-- 请在这里定义和初始化全局成员变量
}

CellChristmasRankRewardList = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndChristmasTree:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tRewardsList = nil 
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_nActivityId = nil 
	self.m_nMyRank = nil 
	self.m_nMyScore = 0
	self.m_nFreeCount = 0 
	self.m_tBagList = nil  
	self.m_tRankList = nil 
	self.m_nTotalScore = 0
	self.m_tCostList = nil 
	self.m_nBasicScore = nil 
	self.m_nDisappearTime = nil 	--活动消失时间戳
	self.m_nLotteryType = nil 
	self.m_nBagMaxNum = 200 		--背包最大的容量
	self.m_tRandomNum = nil 
	self.m_nActionIndex = 1
	self.m_tGridPosition = {{0.5,0.88},{0.34,0.66},{0.5,0.66},{0.66,0.66},{0.18,0.44},{0.34,0.44},{0.5,0.44},{0.66,0.44},{0.82,0.44},{0.1,0.22},{0.26,0.22},{0.42,0.22},{0.58,0.22},{0.74,0.22},{0.9,0.22}}
	self.m_nMaxPlayNum = 35 		--跳动的动画重复次数
	self.m_tLotteryItemId = nil 
	self.m_tLotteryItemNum = nil 
	self.m_bIsLotterying = false 	--是否正在抽取
	self.m_tRankRewardsList = nil   --积分奖励
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndChristmasTree:_unInit()
	self.m_root = nil
	self.m_tRewardsList = nil 
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_nActivityId = nil 
	self.m_nMyRank = nil 
	self.m_nMyScore = nil 
	self.m_nFreeCount = nil  
	self.m_tBagList = nil  
	self.m_tRankList = nil 
	self.m_nTotalScore = nil 
	self.m_tCostList = nil 
	self.m_nBasicScore = nil 
	self.m_nDisappearTime = nil 
	self.m_nLotteryType = nil 
	self.m_nBagMaxNum = nil 
	self.m_tRandomNum = nil 
	self.m_nActionIndex = nil 
	self.m_nMaxPlayNum = nil 		--跳动的动画重复次数
	self.m_tLotteryItemId = nil 
	self.m_tLotteryItemNum = nil 
	self.m_bIsLotterying = nil 	--是否正在抽取
	self.m_tRankRewardsList = nil   --积分奖励
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndChristmasTree:createElement()
	if WndChristmasTree.m_root ~= nil then
		WindowManager:removeWindow(WndChristmasTree.m_root, WndChristmasTree, true)
	end
	local element = WZUISystem:getInstance():createElement("WndChristmasTree")
	assert(element, "WndChristmasTree create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndChristmasTree:showInterface()
	-- body
	local wnd = WndChristmasTree:createElement()
	WindowManager:addWindow(wnd, WndChristmasTree, true)
end


--@brief 	设置活动数据
function WndChristmasTree:setData(activityId, startTime, endTime, rewardItems, rewardCounts, serverIntegration, rank, rankPlayerName, rankIntegration, myRank, myIntegration, itemId, itemNum, freeCount, rankPlayerId, rankParam, rankReward)
	-- body
	self.m_nStartTime = startTime 
	self.m_nEndTime = endTime 
	self.m_nActivityId = activityId 
	self.m_nMyRank = myRank 
	self.m_nMyScore = myIntegration 
	self.m_nFreeCount = freeCount
	self.m_nTotalScore = serverIntegration
	self.m_nDisappearTime = WndApartmentAct:getActivityDisappearTime(self.m_nActivityId)

	--可获得的奖励物品
	self.m_tRewardsList = {}
	for i = 1, #rewardItems do
		local tItem = {}
		tItem.id = rewardItems[i]
		tItem.num = rewardCounts[i]

		table.insert(self.m_tRewardsList, tItem)
	end 
	WZLog("WndChristmasTree:setData", #self.m_tRewardsList)
	--礼物箱中的物品
	self:setBagListData(itemId, itemNum)
	--上榜名单
	self:setRankListData(rank, rankPlayerId, rankPlayerName, rankIntegration)
	--积分排名奖励预览数据
	self:setRankRewardData(rankParam, rankReward)

	self:showWindow()
end

--@brief 	设置榜单数据
function WndChristmasTree:setRankListData(rank, rankPlayerId, rankPlayerName, rankIntegration)
	-- body
	self.m_tRankList = {}
	for i = 1, #rank do
		local tItem = {}
		tItem.rank = rank[i]
		tItem.playerId = rankPlayerId[i]
		tItem.playerName = rankPlayerName[i]
		tItem.score = rankIntegration[i]

		table.insert(self.m_tRankList, tItem)
	end
	WZLog("WndChristmasTree:setRankListData", #self.m_tRankList)
end

--@brief 	设置礼物箱数据
function WndChristmasTree:setBagListData(itemId, itemNum)
	-- body
	if self.m_root == nil then return end 

	self.m_tBagList = {}
	for i = 1, #itemId do
		local tItem = {}
		tItem.id = itemId[i]
		tItem.num = itemNum[i]

		table.insert(self.m_tBagList, tItem)
	end

	self:showBoxRedDot()
end

--@brief 	设置积分排名奖励预览数据
function WndChristmasTree:setRankRewardData(nIndex, reward)
	-- body
	self.m_tRankRewardsList = {}

	for i = 1, #nIndex do
		local tItem = {}
		tItem.rank = nIndex[i]
		tItem.reward = reward[i]

		table.insert(self.m_tRankRewardsList, tItem)
	end
end

--@brief 	抽取成功
function WndChristmasTree:lotteryOK(itemId, itemNum, rank, rankPlayerName, rankIntegration, myRank, myIntegration, serverIntegration, rankPlayerId, freeCount)
	-- body
	if self.m_root == nil then return end
	--创建触摸屏蔽层
	self:_createUnvisibleImage()

	self.m_nMyRank = myRank 
	self.m_nMyScore = myIntegration 
	self.m_nFreeCount = freeCount
	self.m_nTotalScore = serverIntegration
	self.m_tLotteryItemId = itemId 
	self.m_tLotteryItemNum = itemNum 

	self:setRankListData(rank, rankPlayerId, rankPlayerName, rankIntegration)
	--新增礼物箱数据
	for i = 1, #itemId do
		local tItem = {}
		tItem.id = itemId[i]
		tItem.num = itemNum[i]

		table.insert(self.m_tBagList, tItem)
	end

	--刷新数据显示
	--展示抽取动画
	local tTempNum = GetRandomNum(15, 15)
	self.m_nActionIndex = 1
	self.m_tRandomNum = {}
	for i = 1, self.m_nMaxPlayNum do
		local nIndex = i%15
		if nIndex == 0 then 
			nIndex = 15 
		end
		self.m_tRandomNum[i] = tTempNum[nIndex]
	end
	--添加抽到的物品的各自索引到最后
	self.m_tRandomNum[self.m_nMaxPlayNum + 1] = self:getLotteryItemIndex(self.m_tLotteryItemId, self.m_tLotteryItemNum)
	WZLog("WndChristmasTree:sureUseDiamondInstead", Serialize(self.m_tRandomNum))
	local conForReward = GetElement(self.m_root, "conForReward_WndChristmasTree", WZUIContainer)
	self:_createEffect()
	conForReward:enableSchedule("_createEffect", 0.02)
end

--@brief 	抽奖返回错误协议的时候，重置变量
function WndChristmasTree:resetLotteryState()
	-- body
	if WndChristmasTree.m_root then 
		self.m_bIsLotterying = false 
	end
end

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellChristmasRankItem:createElement()
	local tNewObj = self:_new()

	local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setName("__CellChristmasRankItem")
    element:setAbsContentSize(GlobalMethod:CCSize(290, 38))
    element:setLuaObjectIndex(tNewObj)
    return element,tNewObj
end

--@brief 	设置榜单数据
function CellChristmasRankItem:setData(tData)
	-- body
	self.m_tData = tData
end

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellChristmasRankRewardList:createElement()
	local tNewObj = self:_new()

	local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setName("__CellChristmasRankRewardList")
    element:setAbsContentSize(GlobalMethod:CCSize(350,80))
    element:setLuaObjectIndex(tNewObj)
    return element,tNewObj
end

--@brief 	设置榜单奖励预览数据
function CellChristmasRankRewardList:setData(tData)
	-- body
	self.m_tData = tData
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellChristmasRankItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--@brief	获取活动的状态
--@return 	nState : 0->活动尚未开启；1->活动已经开始，但尚未结束；2->活动已经结束，但还可以展示；3->活动已经关闭，不让展示
function WndChristmasTree:getActivityState()
	-- body
	local nCurTime = SystemTime:getServerTime()

	local nState = 0 
	if nCurTime < self.m_nStartTime then 
		nState = 0
	elseif nCurTime >= self.m_nStartTime and nCurTime < self.m_nEndTime then 
		nState = 1
	elseif nCurTime >= self.m_nEndTime and nCurTime < self.m_nDisappearTime then 
		nState = 2
	else
		nState = 3
	end

	return nState 
end

--@brief 	获取抽中的礼物的索引
function WndChristmasTree:getLotteryItemIndex(itemId, itemNum)
	-- body
	local index 
	for i = 1, #itemId do
		for j = 1, #self.m_tRewardsList do
			if itemId[i] == self.m_tRewardsList[j].id and itemNum[i] == self.m_tRewardsList[j].num then 
				index = j
				break 
			end
		end
		if index then 
			break 
		end
	end

	return index 
end

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellChristmasRankRewardList:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
-------------------------------------私有方法模块End----------------------------------------
