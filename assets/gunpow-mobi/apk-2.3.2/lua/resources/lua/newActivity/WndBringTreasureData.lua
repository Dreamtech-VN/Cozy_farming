--WndBringTreasureData.lua
--@brief	WndBringTreasure的数据模块
--@date		2022/12/29
--@author	XTX
--@note		拜财神-招财进宝界面

WndBringTreasure = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndBringTreasure:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nCoinId = 160393 		
	self.m_nCoinId2 = 160394 			
	self.m_bOpenState = false 
	self.m_nMaxLimit = 5 
	self.m_nPoolIndex = 1 				--1=A   2=S
	self.m_tSelItem = nil 				--已选择的奖励
	self.m_tRewardPool = nil 			--奖池数据
	self.m_nTotalShakeTimes = 0 		--累计摇奖次数
	self.m_nTransBaseNum = 10           --次数和奖励转换基数
	self.m_nActivityId = nil 
	self.m_nFirstRefreshCost = 1 		--首次刷新消耗
	self.m_nRefreshAddStep = 1 			--刷新消耗增长值
	self.m_nRefreshCount = 0 			--今日刷新次数
	self.m_tShakeReward = nil 			--摇摇乐奖励
	self.m_tCellPool = nil 				--奖池的奖励Cell
	self.m_nRefreshCostId = nil 		--刷新消耗货币Id
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndBringTreasure:_unInit()
	self.m_root = nil
	self.m_nCoinId = nil 
	self.m_nCoinId2 = nil 
	self.m_bOpenState = nil 
	self.m_nMaxLimit = nil 
	self.m_nPoolIndex = nil 
	self.m_tSelItem = nil 
	self.m_tRewardPool = nil 			--奖池数据
	self.m_nTotalShakeTimes = nil 
	self.m_nTransBaseNum = nil           --转换基数
	self.m_nActivityId = nil 
	self.m_nFirstRefreshCost = nil 		--首次刷新消耗
	self.m_nRefreshAddStep = nil 		--刷新消耗增长值
	self.m_nRefreshCount = nil 			--今日刷新次数
	self.m_tShakeReward = nil 			--摇摇乐奖励
	self.m_tCellPool = nil 				--选中的奖励
	self.m_nRefreshCostId = nil 		--刷新消耗货币Id
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndBringTreasure:createElement()
	if WndBringTreasure.m_root ~= nil then
		WindowManager:removeWindow(WndBringTreasure.m_root, WndBringTreasure, true)
	end
	local element = WZUISystem:getInstance():createElement("WndBringTreasure")
	assert(element, "WndBringTreasure create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndBringTreasure:showInterface(activityId)
	local wndWater = WndBringTreasure:createElement()
	if wndWater then 
		self.m_nActivityId = activityId
		WindowManager:addWindow(wndWater, WndBringTreasure, false, nil, nil, true)
	end
end

--@brief 	设置射箭的状态
function WndBringTreasure:setOpenState(state)
	-- body
	if self.m_root == nil then return end 

	self.m_bOpenState = state
end

--@brief 	设置摇摇乐奖励数据
function WndBringTreasure:setShakeRewardData(shakeRewardIds, shakeRewardNums, dailyRefreshCount, yylConfig)
	if self.m_root == nil then return end 
	
	self.m_tShakeReward = {}
	self.m_nRefreshCount = dailyRefreshCount
	if yylConfig then 
		self.m_nRefreshCostId = yylConfig[1]
		self.m_nFirstRefreshCost = yylConfig[2]
		self.m_nRefreshAddStep = yylConfig[3] 			--刷新消耗增长值
	end

	for i = 1, #shakeRewardIds do
		local tItem = {}

		tItem.itemId = shakeRewardIds[i]
		tItem.itemNum = shakeRewardNums[i]

		table.insert(self.m_tShakeReward, tItem)
	end

	self:_showShakeRewards()
	self:_updateLightNum()
end

--@brief 	设置奖池数据
function WndBringTreasure:setRewardPoolData(data)
	if self.m_root == nil then return end 

	if self.m_tRewardPool == nil then self.m_tRewardPool = {} end 
	self.m_tRewardPool = WndDollMachineShop:setChipShopFishData(data, 867062)

	local tRewardData = self.m_tRewardPool
	self.m_nTransBaseNum = tRewardData[1].price

	self:_update()
end

--@brief	缓存推送更新物品时调用的函数
function WndBringTreasure:updatePlayerItemData()
	WZLog("WndBringTreasure:updatePlayerItemData")
	if self.m_root ~= nil then
		self:_updateLightNum()
		self:updateChooseNum()
		self:_setFreeBtnText()
	end
end

--@brief 	领取自选奖励返回
function WndBringTreasure:getPoolRewardOK(tResult)
	self.m_tSelItem = nil 
	WndRewardShow:showById(tResult.itemIds, tResult.itemNums, nil, nil, nil, nil, nil, nil, nil, nil, nil, tResult.playerItemIds)

	local tPoolData = self.m_tRewardPool
	for i = 1, #tResult.id do
		for k = 1, #tPoolData do
			if tPoolData[k].id == tResult.id[i] then 
				tPoolData[k].soldNum = tResult.soldNum[i]
				tPoolData[k].dailyBuyNum = tResult.dailyBuyNum[i]

				self.m_tCellPool[k]:setFishBuyData(tPoolData[k].soldNum, tPoolData[k].limitNum, tPoolData[k].dailyLimit, tPoolData[k].dailyBuyNum)
				self.m_tCellPool[k]:setItemSelState(false)
				break 
			end
		end
	end

	self:updateChooseNum()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
