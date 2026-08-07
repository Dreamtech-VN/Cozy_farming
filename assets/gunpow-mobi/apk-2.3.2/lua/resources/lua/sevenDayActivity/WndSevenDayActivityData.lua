--WndSevenDayActivityData.lua
--@brief	WndSevenDayActivity的数据模块
--@date		2017/12/19
--@author	Tianxiang_Xu
--@note		七天乐活动

WndSevenDayActivity = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSevenDayActivity:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nCreateRoleTime = nil 		--玩家创角的时间戳
	self.m_nCurSelDayIndex = nil 			--当前选中的天索引
	self.m_nCurSelTopIndex = nil 			--顶部标签索引
	self.m_tLeftMenuCell = {}
	self.m_tLimitBuyList = nil 			--限购列表
	self.m_tTaskList = nil 
	self.m_tActivityType = nil 			--活动的类型
	self.m_tDayMenuRedDot = {false, false, false, false, false, false, false} 			--天菜单列表红点
	self.m_nEndTime = nil 				--活动结束时间戳
	self.m_nEndRewardTime = nil 		--领取奖励结束时间戳
	self.m_nOriginDay = nil 			--保存加载界面的时候的当前第几天
	self.m_tTopTabText = nil 			
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSevenDayActivity:_unInit()
	self.m_root = nil
	self.m_nCreateRoleTime = nil 		--玩家创角的时间戳
	self.m_nCurSelDayIndex = nil 			--当前选中的天索引
	self.m_nCurSelTopIndex = nil 			--顶部标签索引
	self.m_tLeftMenuCell = nil 
	self.m_tLimitBuyList = nil 
	self.m_tTaskList = nil 
	self.m_tActivityType = nil 			--活动的类型
	self.m_tDayMenuRedDot = nil 			--天菜单列表红点
	self.m_nEndTime = nil 				--活动结束时间戳
	self.m_nEndRewardTime = nil 		--领取奖励结束时间戳
	self.m_nOriginDay = nil 
	self.m_tTopTabText = nil 			
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSevenDayActivity:createElement()
	if WndSevenDayActivity.m_root ~= nil then
		WindowManager:removeWindow(WndSevenDayActivity.m_root, WndSevenDayActivity, true)
	end
	local element = WZUISystem:getInstance():createElement("WndSevenDayActivity")
	assert(element, "WndSevenDayActivity create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndSevenDayActivity:showInterface()
	-- body
	local wndSevenDay = WndSevenDayActivity:createElement()
	if wndSevenDay then 
		WindowManager:addWindow(wndSevenDay, WndSevenDayActivity, nil, nil, nil, true)
	end
end

--@brief 	设置数据
--@param 	open : 开服任务活动是否存在（1为存在，0为不存在，0时下面所有数据无效）
function WndSevenDayActivity:setData(open, id, status, target, complete, time, buyShop)
	-- body
	WZLog("WndSevenDayActivity:setData", #id, Serialize(buyShop))
	if open == 0 then 
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END)
		WindowManager:removeWindow(self.m_root , self , true)
		return 
	end
	--返回的是创角当天凌晨的时间戳，如玩家是2017.3.20 18:00创建的角色，则是返回2017.3.20 00:00的时间戳
	local nCurTime = SystemTime:getServerTime()

	self.m_nCreateRoleTime = time  
	self.m_nOriginDay = math.floor((nCurTime - self.m_nCreateRoleTime)/(24 * 3600)) + 1
	self.m_nEndTime = self.m_nCreateRoleTime + 7 * 24 * 3600	
	self.m_nEndRewardTime = self.m_nEndTime + 2 * 24 * 3600     --比活动结束时间多两天
	self.m_tLimitBuyList = {}
	self.m_tTaskList = {}
	self.m_tActivityType = {}

	--各天任务数据
	for i = 1, #id do
		local tItem = {}
		tItem.id = id[i]
		tItem.complete = complete[i]
		tItem.target = target[i]
		local basicData = GDatatab_open_server_task["id_"  .. tItem.id]
		tItem.desc = basicData.desc
		tItem.day = basicData.dayNum
		tItem.type = basicData.index
		tItem.reward = basicData.reward
		tItem.script = basicData.script
		tItem.state = status[i]
		if self.m_tTaskList[tItem.day] == nil then 
			self.m_tTaskList[tItem.day] = {}
		end
		if self.m_tTaskList[tItem.day][tItem.type] == nil then 
			self.m_tTaskList[tItem.day][tItem.type] = {}
		end
		local bExist = false 
		for j = 1, #self.m_tActivityType do
			if self.m_tActivityType[j] == tItem.type then 
				bExist = true 
				break 
			end
		end

		--红点
		if tItem.state == 1 and self.m_tDayMenuRedDot[tItem.day] == false then 
			self.m_tDayMenuRedDot[tItem.day] = true
		end

		if not bExist then 
			table.insert(self.m_tActivityType, tItem.type)
		end
		table.insert(self.m_tTaskList[tItem.day][tItem.type], tItem)
	end
	table.insert(self.m_tActivityType, 4)
	table.sort(self.m_tActivityType, function (a,b)
		-- body
		return a < b
	end)
	--排序
	for i = 1, #self.m_tTaskList do
		for j = 1, #self.m_tTaskList[i] do
			if self.m_tTaskList[i][j] and #self.m_tTaskList[i][j] > 1 then
				table.sort(self.m_tTaskList[i][j], sevenDaySortFun)
			end
		end
	end
	--折扣限购数据
	for i, value in pairs(GDatatab_open_server_shop) do
		local tItem = {}
		tItem.id = value.id
		tItem.day = value.dayNum
		tItem.itemId = value.item[1][1]
		tItem.itemNum = value.item[1][2]
		tItem.leftTimes = 1
		tItem.originPrice = value.before_price[1][2]
		tItem.priceId = value.price[1][1]
		tItem.curPrice = value.price[1][2]
		for j = 1, #buyShop do
			if buyShop[j] == tItem.id then 
				tItem.leftTimes = 0
				break 
			end
		end

		table.insert(self.m_tLimitBuyList, tItem)
	end

	table.sort(self.m_tLimitBuyList, function (a,b)
		-- body
		return a.day < b.day
	end)

	self:showWindow()
end

--@brief 	排序函数
function sevenDaySortFun(a, b)
	-- body
	local stateA = WndSevenDayActivity:getTempState(a)
	local stateB = WndSevenDayActivity:getTempState(b)
	if stateA ~= stateB then 
		return stateA < stateB
	else
		return a.id < b.id
	end
end

--@brief 	临时状态转换
function WndSevenDayActivity:getTempState(a)
	-- body
	if a.state == 0 then 
		return 1
	elseif a.state == 1 then 
		return 0
	else
		return 2
	end
end

--@brief 	领取奖励成功
function WndSevenDayActivity:receiveRewardOK(taskId)
	-- body
 	local tRewardsNum
    local tRewardsItemId
    tRewardsItemId, tRewardsNum = self:_getTaskRewards(taskId)

	WndRewardShow:showById(tRewardsItemId,tRewardsNum)
	--更新数据
	self:_updateDataAfterReceiveReward(taskId, 2)
end

--@brief	购买折扣物品成功
function WndSevenDayActivity:buyLimiteGoodsOK(shopId)
	-- body
	local tRewardsNum = {}
    local tRewardsItemId = {}
    for i = 1, #self.m_tLimitBuyList do
    	if self.m_tLimitBuyList[i].id == shopId then 
    		table.insert(tRewardsNum, self.m_tLimitBuyList[i].itemNum)
    		table.insert(tRewardsItemId, self.m_tLimitBuyList[i].itemId)

    		break 
    	end
    end
	WndRewardShow:showById(tRewardsItemId, tRewardsNum)
	--更新数据
	self:_updateDataAfterBuy(shopId)
	self:_setBuyBtnState()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	获取配置的活动天数
function WndSevenDayActivity:getConfigDays()
	-- body
	local nDay = 0
	local tDay = {}
	for i, v in pairs(GDatatab_open_server_task) do
		local bIsExist = false 
		for j = 1, #tDay do
			if tDay[j] == v.dayNum then 
				bIsExist = true
				break 
			end
		end
		if not bIsExist then 
			nDay = nDay + 1
			table.insert(tDay, v.dayNum)
		end
	end

	return nDay 
end

--@brief 	获取配置的活动活动标签字
function WndSevenDayActivity:setConfigTabText()
	-- body
	self.m_tTopTabText = {}
	for i, v in pairs(GDatatab_open_server_task) do
		if self.m_tTopTabText[v.dayNum] == nil then
			self.m_tTopTabText[v.dayNum] = {}
		end
		if self.m_tTopTabText[v.dayNum][v.index] == nil then
			self.m_tTopTabText[v.dayNum][v.index] = v.name
		end
	end
end

--@brief 	领取奖励后更新任务状态
function WndSevenDayActivity:_updateDataAfterReceiveReward(id, state)
	-- body
	local nType = self.m_tActivityType[self.m_nCurSelTopIndex]
	local tTaskData = self.m_tTaskList[self.m_nCurSelDayIndex][nType]

	local bFinded = false 
	for i = 1, #tTaskData do
		if id == tTaskData[i].id then 
			tTaskData[i].state = state
			bFinded = true 
			break 
		end
	end
	if bFinded then 
		table.sort(self.m_tTaskList[self.m_nCurSelDayIndex][nType], sevenDaySortFun)
		self:_showTaskList()
	end
	--如果当前显示的数据中没有该任务数据，则另外取相应的数据
end

--@brief 	购买后更新数量
function WndSevenDayActivity:_updateDataAfterBuy(shopId)
	-- body
	for i = 1, #self.m_tLimitBuyList do
		if self.m_tLimitBuyList[i].id == shopId then 
			self.m_tLimitBuyList[i].leftTimes = self.m_tLimitBuyList[i].leftTimes - 1
			break 
		end
	end
end

--@brief 	获取任务奖励
--@param 	nTaskID:任务ID
function WndSevenDayActivity:_getTaskRewards(nTaskID)
	local tRewardsNum = {}
	local tRewardsItemId = {}
	local tTaskData = GDatatab_open_server_task["id_" .. nTaskID]
	for i=1,#tTaskData.reward do
		table.insert(tRewardsNum,tTaskData.reward[i][2])
		table.insert(tRewardsItemId,tTaskData.reward[i][1])
	end
	return tRewardsItemId, tRewardsNum
end
-------------------------------------私有方法模块End----------------------------------------
