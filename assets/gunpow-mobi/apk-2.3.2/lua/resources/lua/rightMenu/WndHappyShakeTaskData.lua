--WndHappyShakeTaskData.lua
--@brief	WndHappyShakeTask的数据模块
--@date		2020/05/28
--@author	XTX
--@note		全民摇摇乐任务

WndHappyShakeTask = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndHappyShakeTask:_init()
	self.m_root = nil	 	  			--场景根节点
	self.bDailyTaskFirstLoad = true
	self.m_tMainTaskList = nil 
	self.m_tDailyTaskList = nil 
	self.m_nCurIndex = 1
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndHappyShakeTask:_unInit()
	self.m_root = nil
	self.bDailyTaskFirstLoad = false
	self.m_tMainTaskList = nil 
	self.m_tDailyTaskList = nil 
	self.m_nCurIndex = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndHappyShakeTask:createElement()
	if WndHappyShakeTask.m_root ~= nil then
		WindowManager:removeWindow(WndHappyShakeTask.m_root, WndHappyShakeTask, true)
	end
	local element = WZUISystem:getInstance():createElement("WndHappyShakeTask")
	assert(element, "WndHappyShakeTask create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndHappyShakeTask:showInterface()
	-- body
	local wndShake = WndHappyShakeTask:createElement()
	if wndShake then 
		WindowManager:addWindow(wndShake, WndHappyShakeTask, nil, nil, nil, true)
	end
end

--@brief 	设置活动数据
function WndHappyShakeTask:getActivityTaskListOk( id, status, target, complete, refreshTime )
	-- body
	if self.m_root == nil then return end 
	WZLog("WndHappyShakeTask:getActivityTaskListOk",Serialize(id),Serialize(status),Serialize(target),Serialize(complete),refreshTime)

	self.m_tMainTaskList = {}
	self.m_tDailyTaskList = {}
	self.m_tDailyTaskList.tToSubmit = {}
	self.m_tDailyTaskList.tDoing = {}
	self.m_tDailyTaskList.tCompleted = {}
	local temptasksList01 = {}
	local temptasksList11 = {}
	local temptasksList21 = {}

	local temptasksList02 = {}
	local temptasksList12 = {}
	local temptasksList22 = {}
	local bMainRedDot, bDailyRedDot = false, false
	for i = 1, #id do
		local itemData = {}
		itemData.nId = id[i] 
		itemData.nTaskStatus = status[i] 
		itemData.nTargetValue = target[i] 
		itemData.nTargetStatus = complete[i] 

		local nType = GDatatab_shake_task["id_" .. itemData.nId].type
		if nType == 2 then 
			if itemData.nTaskStatus == 0 then
				table.insert(temptasksList01,itemData)
			elseif itemData.nTaskStatus == 1 then
				bMainRedDot = true
				table.insert(temptasksList11,itemData)
			elseif itemData.nTaskStatus == 2 then
				table.insert(temptasksList21,itemData)
			end
		elseif nType == 1 then 
			if itemData.nTaskStatus == 0 then
				table.insert(temptasksList02,itemData)
			elseif itemData.nTaskStatus == 1 then
				bDailyRedDot = true
				table.insert(temptasksList12,itemData)
			elseif itemData.nTaskStatus == 2 then
				table.insert(temptasksList22,itemData)
			end
		end

	end

	local function _sortTask( a, b )
		return a.nId < b.nId
	end
	--成长
	table.sort( temptasksList01, _sortTask)
	table.sort( temptasksList11, _sortTask)
	table.sort( temptasksList21, _sortTask)
	--日常
	table.sort( temptasksList02, _sortTask)
	table.sort( temptasksList12, _sortTask)
	table.sort( temptasksList22, _sortTask)


	for i = 1, #temptasksList11 do
		table.insert(self.m_tMainTaskList, temptasksList11[i])
	end
	for i = 1, #temptasksList01 do
		table.insert(self.m_tMainTaskList, temptasksList01[i])
	end
	for i = 1, #temptasksList21 do
		table.insert(self.m_tMainTaskList, temptasksList21[i])
	end

	for i = 1, #temptasksList12 do
		table.insert(self.m_tDailyTaskList.tToSubmit, temptasksList12[i])
	end
	for i = 1, #temptasksList02 do
		table.insert(self.m_tDailyTaskList.tDoing, temptasksList02[i])
	end
	for i = 1, #temptasksList22 do
		table.insert(self.m_tDailyTaskList.tCompleted, temptasksList22[i])
	end

	self.m_refreshTime = refreshTime
	self:updateUIFunc()

	GetElement(self.m_root, "conDailyRed_WndHappyShakeTask", WZUIContainer):setVisible(bDailyRedDot)
	GetElement(self.m_root, "conMainRed_WndHappyShakeTask", WZUIContainer):setVisible(bMainRedDot)
end

--@brief 领取任务奖励成功
function WndHappyShakeTask:getTastRewardOK(status, id)
	-- body
	if self.m_root == nil then return end 
	WZLog("WndHappyShakeTask:getTastRewardOK", status, id)
	if status == 0 then
		
	elseif status == 1 then
		local tReward = GDatatab_shake_task["id_" .. id].reward
		local tRewardId = {}
		local tRewardNum = {}
		for i = 1, #tReward do
			local tempRewardId = {}
			local tempRewardNum = {}

			tempRewardId = tReward[i][1]
			tempRewardNum = tReward[i][2]

			local m_tItemData = GDatatab_item["id_"..tReward[i][1]]
            if m_tItemData.sex == 2 or m_tItemData.sex == CacheCenter:getPlayerInfo().sex then
				table.insert(tRewardId,tempRewardId)
				table.insert(tRewardNum,tempRewardNum)
			end
		end
		WndRewardShow:showById(tRewardId, tRewardNum)
	end

	ProtocolProcessorNewActivity:send_ACTIVITY2_GetPokerTaskList()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	空数据提示语
function WndHappyShakeTask:_showEmptyTip()
    WZLog("***** WndHappyShakeTask:_showEmptyTip *****")
	local conTaskContent = GetElement(self.m_root,"conTaskContent_WndHappyShakeTask",WZUIContainer)
	removeShowPanelNullTip(conTaskContent)
    ShowPanelNullTip(conTaskContent)
end

--@brief	loading回调
function WndHappyShakeTask:updateUIFunc( )
	if self.m_nCurIndex == 0 then
		WZLog("update MainTask")
		self:_setCheckBoxSel(true, false)
		self:_updateMainTask()
	elseif self.m_nCurIndex == 1 then
		WZLog("update DailyTask")
		self:_setCheckBoxSel(false, true)
		self:DailyTaskTableCellUpdate()
	end

	self.m_root:enableSchedule("scheduleCountdown", 1)
end

-------------------------------------私有方法模块End----------------------------------------
