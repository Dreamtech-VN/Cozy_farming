--WndAlchemySmeltData.lua
--@brief	WndAlchemySmelt的数据模块
--@date		2022/02/08
--@author	XTX
--@note		丹道修真活动-聚炼界面

WndAlchemySmelt = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndAlchemySmelt:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tElixirList = {{160203, 5}, {160205, 3}}
	self.m_tActList = nil 
	self.m_nSelIndex = nil 
	self.m_nEquipNum = 0   				--已装备的丹药数量
	self.m_nActivityId = nil 
	self.m_tOpenResult = nil 
	self.m_nChooseReward = 0 		--选择奖励状态0：弹出预览界面；1：不弹
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndAlchemySmelt:_unInit()
	self.m_root = nil
	self.m_tElixirList = nil 
	self.m_tActList = nil 
	self.m_nSelIndex = nil 
	self.m_nEquipNum = nil   				--已装备的丹药数量
	self.m_nActivityId = nil 
	self.m_tOpenResult = nil 
	self.m_nChooseReward = nil 		--选择奖励状态0：弹出预览界面；1：不弹
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndAlchemySmelt:createElement()
	if WndAlchemySmelt.m_root ~= nil then
		WindowManager:removeWindow(WndAlchemySmelt.m_root, WndAlchemySmelt, true)
	end
	local element = WZUISystem:getInstance():createElement("WndAlchemySmelt")
	assert(element, "WndAlchemySmelt create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndAlchemySmelt:showInterface(nActivityId, cost5Num, cost9Num)
	local wndWater = WndAlchemySmelt:createElement()
	if wndWater then 
		self.m_nActivityId = nActivityId
		self.m_tElixirList[1][2] = cost5Num
		self.m_tElixirList[2][2] = cost9Num
		self.m_nChooseReward = GetOperateTimes("ALCHEMYACTIVITYID_TWO", self.m_nActivityId)
		WindowManager:addWindow(wndWater, WndAlchemySmelt, false, nil, nil, true)
	end
end

--@brief	缓存推送更新物品时调用的函数
function WndAlchemySmelt:updatePlayerItemData()
	WZLog("WndAlchemySmelt:updatePlayerItemData")
	if self.m_root ~= nil then
		self:updateSmeltData()
	end
end

--@brief 	设置聚炼数据
function WndAlchemySmelt:setSmeltData()
	self.m_tActList = {}
	for i = 1, #self.m_tElixirList do
		local nNum = CacheCenter:getPlayerItemCountById(self.m_tElixirList[i][1])
		if nNum > 0 then 
			local tItem = {}
			tItem[1] = self.m_tElixirList[i][1]
			tItem[2] = self.m_tElixirList[i][2]
			tItem[3] = nNum

			table.insert(self.m_tActList, tItem)
		end
	end

	self:showElixirList()
end

--@brief 	刷新聚炼数据
function WndAlchemySmelt:updateSmeltData()
	for i = 1, #self.m_tActList do
		local nNum = CacheCenter:getPlayerItemCountById(self.m_tActList[i][1])
		self.m_tActList[i][3] = nNum
	end

	self:showElixirList()
end

--@brief 	聚炼结果
function WndAlchemySmelt:smeltResult(activityId, doType, result, jsonData)
	if doType == 2 then 
		local tResult = json.decode(jsonData)
		local nSex = CacheCenter:getPlayerInfo().sex

		self.m_tOpenResult = {}
		self.m_tOpenResult.firstRewards = {}
		self.m_tOpenResult.bigRewards = {}

		for i = 1, #tResult.rewardTypes do
			if tResult.rewardTypes[i] == 4 then 
				local tTempItem = {}
				tTempItem.itemId = 160204
				tTempItem.itemNum = 1
				tTempItem.type = 5 
				table.insert(self.m_tOpenResult.firstRewards, tTempItem)

				local array = tResult.rewards[i]
				for j = 1, #array do
					local tItem = {}

					tItem.itemId = array[j][nSex + 1]
					tItem.itemNum = array[j][3]
					tItem.type = 5
					tItem.playerItemId = tResult.playerItemIds[i]

					table.insert(self.m_tOpenResult.firstRewards, tItem)
				end

			elseif tResult.rewardTypes[i] == 5 then 
				local tTempItem = {}
				tTempItem.itemId = 160206
				tTempItem.itemNum = 1
				tTempItem.type = 6 
				table.insert(self.m_tOpenResult.bigRewards, tTempItem)

				local array = tResult.rewards[i]
				for j = 1, #array do
					local tItem = {}

					tItem.itemId = array[j][nSex + 1]
					tItem.itemNum = array[j][3]
					tItem.type = 6
					tItem.playerItemId = tResult.playerItemIds[i]

					table.insert(self.m_tOpenResult.bigRewards, tItem)
				end
			end
		end
		
		if result == 1 then 
			self:showOpenAction()
		end
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	关闭抽奖奖励展示界面回调
function WndAlchemySmelt:_afterCloseReward()
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
	if #tBigReward > 0 then 
		WndHoraryBigReward:showInterface(12, tBigReward)
		self:_initGrid()
		self:updateUseElixirNum()
	end
end




-------------------------------------私有方法模块End----------------------------------------
