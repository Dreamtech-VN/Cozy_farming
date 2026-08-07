--WndMagicStoneData.lua
--@brief	WndMagicStone的数据模块
--@date		2019/10/23
--@author	Tianxiang_Xu
--@note		幻石系统界面

WndMagicStone = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndMagicStone:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nCurIndex = 0 					--0：奖励；1：任务；2兑换
	self.m_nMagicStoneLevel = 0 		--幻石等级
	self.m_nFreshTime = 0 				--任务刷新时间
	self.m_nOpenState = 0 				--状态
	self.m_nCurExp = 0 					--当前经验
	self.m_nWeekExp = 0 					--周增加经验
	self.m_tRewardData = nil 			--奖励数据
	self.m_tTaskData = nil    			--任务数据
	self.m_tShopData = nil 				--商店数据
	self.m_nPreviewIndex = nil 			--预览数据索引
	self.m_nMaxPositionX = nil 			--奖励列表最大位置
	self.m_nMaxWeekAddExp = 0 			--周增加经验最大值
	self.m_bBuyLevelMark = false 		--标记是否购买等级
	self.m_nSeasonTime = 0 				--季度刷新时间
	self.m_sFirstComeIn = nil
	self.m_sRoleSpine = nil
	self.m_tAllServerRewardData = {} --全服数据
	self.m_nAllServerAdvanceNum = 0
	self.m_nSeasonIndex = 1

	self.m_nCoinId = 161086 				--弹令印记
	self.m_tLevelInterval = {40,80,120}		--等级区间
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndMagicStone:_unInit()
	self.m_root = nil
	self.m_nCurIndex = nil 
	self.m_nMagicStoneLevel = nil 		--幻石等级
	self.m_nFreshTime = nil 				--刷新时间
	self.m_nOpenState = nil 				--状态
	self.m_nCurExp = nil 					--当前经验
	self.m_nWeekExp = nil 					--周增加经验
	self.m_tRewardData = nil
	self.m_tTaskData = nil
	self.m_tShopData = nil
	self.m_nPreviewIndex = nil 
	self.m_nMaxPositionX = nil
	self.m_nMaxWeekAddExp = nil 			--周增加经验最大值
	self.m_bBuyLevelMark = nil 
	self.m_nSeasonTime = nil
	self.m_sFirstComeIn = nil
	self.m_sRoleSpine = nil
	self.m_tAllServerRewardData = {}
	self.m_nAllServerAdvanceNum = 0
	self.m_nSeasonIndex = nil

	self.m_nCoinId = nil
	self.m_tLevelInterval = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndMagicStone:createElement()
	if WndMagicStone.m_root ~= nil then
		WindowManager:removeWindow(WndMagicStone.m_root, WndMagicStone, true)
	end
	local element = WZUISystem:getInstance():createElement("WndMagicStone")
	assert(element, "WndMagicStone create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndMagicStone:showInterface(nIndex)
	-- body
	local wndStone = WndMagicStone:createElement()
	if wndStone then 
		self.m_nCurIndex = nIndex or 0
		WindowManager:addWindow(wndStone,WndMagicStone,nil,nil,nil,true)
	end
end

--@brief 	获取幻石等级
function WndMagicStone:getMagicStoneLevel()
	-- body
	return self.m_nMagicStoneLevel
end

--@brief 	设置数据
function WndMagicStone:setData(openStatus, level, exp, weekExp, commonReward, advancedReward, taskId, taskCompleteNum, taskTargetNum, taskState, taskRcvNum, taskRcvLimit, marketId, marketNum, refreshTime, seasonTime, fullCommonReward, fullAdvanceReward, advanceNum, seasonNum, batch)
	-- body
	self.m_nOpenState = openStatus 				--状态
	self.m_nMagicStoneLevel = level 		--幻石等级
	self.m_nFreshTime = refreshTime 				--刷新时间
	self.m_nCurExp = exp
	self.m_nWeekExp = weekExp
	self.m_nSeasonTime = seasonTime
	self.m_nSeasonNum = seasonNum
	self.m_nBatch = batch

	WZLog("WndMagicStone:setData", openStatus, level, exp, weekExp, refreshTime, seasonTime)
	self.m_nSeasonIndex = self:getCurSeasonIndex()
	g_nMagicStoneSeason = self.m_nSeasonIndex
	self:setRewardData(commonReward, advancedReward)
	self:setTaskData(taskId, taskCompleteNum, taskTargetNum, taskState, taskRcvNum, taskRcvLimit)
	self:setShopData(marketId, marketNum)

	self:setAllServerData(fullCommonReward, fullAdvanceReward, advanceNum)
	self:_update()
	if self.m_bBuyLevelMark then 
		self.m_bBuyLevelMark = false 
		WndMagicBuyLevel:buyLevelSuccess()
	end
end

--@brief 	购买等级成
function WndMagicStone:buyShopGoodOK(marketId, buyNum, itemId, itemNum)
	-- body
	WndRewardShow:showById({itemId}, {itemNum})

	for i = 1, #self.m_tShopData do 
		if self.m_tShopData[i].id == marketId then 
			if self.m_tShopData[i].marketNum > 0 then 
				self.m_tShopData[i].marketNum = self.m_tShopData[i].marketNum - buyNum
				if CellMagicStoneShop.m_current then 	
					WZLog("WndMagicStone:buyShopGoodOK Two")
					CellMagicStoneShop.m_current:updateGoodNum(self.m_tShopData[i].marketNum)
				end
			end
			break 
		end
	end
end

--@brief 	激活进阶成功
function WndMagicStone:activeAdvanceOK()
	-- body
	if self.m_root == nil then return end 

	self.m_nOpenState = 1
	if WndMagicAdvance.m_root then 
		WndMagicAdvance:_showState()
	end
end

--@brief 	设置购买等级标记
function WndMagicStone:setBuyLevel(bBool)
	-- body
	self.m_bBuyLevelMark = bBool
end

--@brief	缓存推送更新物品时调用的函数
function WndMagicStone:updatePlayerItemData()
	if self.m_root ~= nil then
		self:_showCoinNum()
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	设置奖励数据
function WndMagicStone:setRewardData(commonReward, advancedReward)
	-- body
	self.m_tRewardData = {}

	for i = 1, #commonReward do
		local tItem = {}
		for j, levelData in pairs(GDatatab_stone_reward) do
			if levelData.lv == i and levelData.season == self.m_nSeasonIndex then 
				tItem = CopyTable(levelData) 
				tItem.levelState = commonReward[i]
				tItem.advanceState = advancedReward[i]

				table.insert(self.m_tRewardData, tItem)
				break 
			end
		end
	end
end

--@brief 	设置任务数据
function WndMagicStone:setTaskData(taskId, taskCompleteNum, taskTargetNum, taskState, taskRcvNum, taskRcvLimit)
	-- body
	self.m_tTaskData = {}
	for i = 1, #taskId do
		local tItem = {}
		local taskData = GDatatab_stonetask["id_" .. taskId[i]]
		if taskData then 
			tItem = CopyTable(taskData)
			tItem.complete = taskCompleteNum[i]
			tItem.targetNum = taskTargetNum[i]
			tItem.state = taskState[i]
			tItem.taskRcvNum = taskRcvNum[i]
			tItem.taskRcvLimit = taskRcvLimit[i]

			table.insert(self.m_tTaskData, tItem)
		end
	end

	table.sort(self.m_tTaskData, _sortMagicStoneTask)
end

--全服的数据
function WndMagicStone:setAllServerData(fullCommonReward, fullAdvanceReward, advanceNum)
	self.m_nAllServerAdvanceNum = advanceNum
	
	if next(self.m_tAllServerRewardData) == nil then
		for i,v in pairs(GDatatab_stone_reward) do
			if v.lv == 0 then
				table.insert(self.m_tAllServerRewardData, v)
			end
		end
		table.sort( self.m_tAllServerRewardData, function(a,b) return a.id < b.id end)
	end
	for i=1,#self.m_tAllServerRewardData do
		self.m_tAllServerRewardData[i].levelState = fullCommonReward[i]
		self.m_tAllServerRewardData[i].advanceState = fullAdvanceReward[i]
	end
end

--@brief 	设置商店数据
function WndMagicStone:setShopData(marketId, marketNum)
	-- body
	self.m_tShopData = {}
	
	for i = 1, #marketId do
		local tItem = {}
		local marketData = GDatatab_stone_market_item["id_" .. marketId[i]]
		if marketData then 
			tItem = CopyTable(marketData)
			tItem.marketNum = marketNum[i]

			table.insert(self.m_tShopData, tItem)
		end
	end
end

--@brief 	任务排序函数
function _sortMagicStoneTask(a, b)
	-- body
	local function getSortState(t)
		-- body
		if t.state == TASKSTATUS_DOING then 
			return 1
		elseif t.state == TASKSTATUS_TOSUBMIT then 
			return 0
		else
			return 2
		end
	end

	local stateA = getSortState(a)
	local stateB = getSortState(b)

	if stateA ~= stateB then 
		return stateA < stateB
	else
		return a.id < b.id
	end
end

--@brief 	领取任务成功
function WndMagicStone:getTaskRewardOK(rewardId)
	-- body
	if self.m_nCurIndex ~= 1 then return end 

	for i = 1, #self.m_tTaskData do
		if self.m_tTaskData[i].id == rewardId then 
			self.m_tTaskData[i].state = TASKSTATUS_COMPLETED
			break 
		end
	end

	table.sort(self.m_tTaskData, _sortMagicStoneTask)
	--刷新红点
	self:setRedDot()

	self:_showTask()
end

--@brief 	判断是否有可领取的奖励
function WndMagicStone:_judgeCanGetReward()
	-- body
	local bHave = false 
	for i = 1, #self.m_tRewardData do
		if self.m_tRewardData[i].levelState == 1 or self.m_tRewardData[i].advanceState == 1 then 
			bHave = true
			break  
		end
	end

	return bHave
end

--@brief 	判断全服奖励是否有可领取的奖励
function WndMagicStone:_judgeAllServerCanGetReward()
	-- body
	local bHave = false 
	for i = 1, #self.m_tAllServerRewardData do
		if self.m_tAllServerRewardData[i].levelState == 1 or self.m_tAllServerRewardData[i].advanceState == 1 then 
			bHave = true
			break  
		end
	end
	local stoneOpenLevel = CacheCenter:getGameParam().stoneOpenLevel
	local level = CacheCenter:getPlayerInfo().level
	if bHave == true then
		bHave = false
		if tonumber(level) >= tonumber(stoneOpenLevel) then
			bHave = true
		end
	end
	return bHave
end

--@brief 	判断是否有可领取的任务
function WndMagicStone:_judgeTaskRedDot()
	-- body
	local bHave = false 
	for i = 1, #self.m_tTaskData do
		if self.m_tTaskData[i].state == TASKSTATUS_TOSUBMIT then 
			bHave = true
			break  
		end
	end

	return bHave
end

--@breif 	获取当前季度
function WndMagicStone:getCurSeasonIndex()
	-- body
	local seasonConfig = CacheCenter:getGameParam().stoneSeason
	WZLog("WndMagicStone:getCurSeasonIndex zero", seasonConfig)
	local array = SplitStringWithSeparator(seasonConfig, "&")
	local season = {}
	local dateBegin = {}
	local dateEnd = {}
	for i=1, #array do
		local string = string.sub(array[i],2,-2) 
		local id = tonumber(SplitStringWithSeparator(string,",")[1])
		local date1 = tonumber(SplitStringWithSeparator(string,",")[2])
		local date2 = tonumber(SplitStringWithSeparator(string,",")[3])
		table.insert(season, id)
		table.insert(dateBegin, date1)
		table.insert(dateEnd, date2)
	end

	local curDate = SystemTime:getTimeTabelByServerTimestamp(SystemTime:getServerTime())
	local sDate = string.format("%d%02d%02d", curDate.year, curDate.month, curDate.day)
	WZLog("WndMagicStone:getCurSeasonIndex one", sDate)
	for i = 1, #season do
		if dateBegin[i] <= tonumber(sDate) and dateEnd[i] > tonumber(sDate) then 
			return season[i]
		elseif dateEnd[i] == tonumber(sDate) then 
			if curDate.sec <= 1 then 
				return season[i]
			end
		end
	end

	return 1
end

--@brief 	
function WndMagicStone:getCurSeasonValue()
	-- body
	return self.m_nSeasonIndex 
end
-------------------------------------私有方法模块End----------------------------------------
