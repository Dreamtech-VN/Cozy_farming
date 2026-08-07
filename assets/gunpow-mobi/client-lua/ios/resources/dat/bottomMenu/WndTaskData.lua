--WndTaskData.lua
--@brief	WndTask的数据模块
--@date		2014/09/05
--@author	SuYuan
--@note		任务模块

--@brief	任务数据是否更改
TaskCacheIsChanage = {
    m_bTaskCacheIsChanage = nil
}

--@brief    日常任务数值表
m_tItemNum = {
	m_tabDailyTaskItemNum = {}
} 

WndTask = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndTask:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tTaskList = {}   			--任务列表
	self.m_tDailyLuaObj = {} 			--每日任务lua表列表
    self.m_tRewardsLuaObj = nil 		--主线任务奖励lua表
    self.m_nCurIndex = 0 				--当前索引（0：主线任务，1：每日任务）
    self.m_nloadingId = 0 				--lodaing id
    self.bDailyTaskFirstLoad = true

    self.m_bIsadaptLanguage_en = false
    self.m_tCacheTaskList = nil
    self.m_tDailyCacheTaskList = nil   
    self.m_tDailyLoadIndex = 0
    self.m_nDailyMonthCardTime = 0    --月卡时间

    self.m_bIsTeach = nil
    self.m_tListItem = nil
    self.m_nSpecifyIndex = nil 
    self.m_nWeekCardTime = nil
    self.m_tDailyActivityData = nil     --日常活跃度数据
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndTask:_unInit()
	self.m_root = nil
	self.m_tTaskList = nil
	self.m_tDailyLuaObj = nil
    self.m_tRewardsLuaObj = nil
    self.m_nCurIndex = nil
    self.m_nloadingId = nil
    self.nDailyTaskFirstLoad = nil
    self.m_tCacheTaskList = nil  
    self.m_tDailyCacheTaskList = nil
    self.m_tDailyLoadIndex = nil 
    self.m_nDailyMonthCardTime = nil    --月卡时间

    self.m_bIsTeach = nil
    self.m_tListItem = nil
    self.m_nSpecifyIndex = nil 
    self.m_nWeekCardTime = nil
    self.m_tDailyActivityData = nil     --日常活跃度数据
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndTask:createElement()
	local element = WZUISystem:getInstance():createElement("WndTask")
	assert(element, "WndTask create element failed!")
    Teach.PreUIChannelId = GlobalGame.g_nCurrentUIChannelId
	self:_init()
	return element
end


--@brief 	更新任务状态
--@param 	nTaskId:任务ID
--@param 	nTaskType:任务类型
--@param 	nTaskStatus:任务状态
function WndTask:updateTaskStatus(nTaskId, nTaskType, nTaskStatus, reward)
	WZLog("wndTask:updateTaskStatus====任务领取的更新")
	--主线任务
	if 1 == nTaskType then
		if nTaskStatus == TASKSTATUS_COMPLETED  then
            self:dealwithTask(nTaskType, nTaskId, nTaskStatus)
            local tRewardsNum
            local tRewardsItemId
            if reward then 
                tRewardsItemId, tRewardsNum = SplitItemString(reward)
            else
                tRewardsNum,tRewardsItemId = self:_getTaskRewards(nTaskType, nTaskId)
            end
			WndRewardShow:showById(tRewardsItemId,tRewardsNum,nil,nTaskId)
			
            self:updateUIFunc()
		elseif nTaskStatus == TASKSTATUS_TOSUBMIT then
			self:updateUIFunc()
		end
	elseif 2 == nTaskType then
		if nTaskStatus == TASKSTATUS_COMPLETED then
            self:dealwithTask(nTaskType, nTaskId, nTaskStatus)
			local tRewardsNum
            local tRewardsItemId
            if reward then 
                tRewardsItemId, tRewardsNum = SplitItemString(reward)
            else
                tRewardsNum,tRewardsItemId = self:_getTaskRewards(nTaskType, nTaskId)
            end
			WndRewardShow:showById(tRewardsItemId,tRewardsNum,nil,nTaskId)
			
            self:updateUIFunc()
		elseif nTaskStatus == TASKSTATUS_TOSUBMIT then
            WZLog("******* updateUIFunc 2222222 ********")
			self:updateUIFunc()
		end
	--每日任务
	elseif 3 == nTaskType then
		if nTaskStatus == TASKSTATUS_TOSUBMIT then
			WZLog("DailyTask TASKSTATUS_TOSUBMIT")
		elseif nTaskStatus == TASKSTATUS_COMPLETED then
			local tItemId = {}
			local bFound = false
			local bNextFound = false
            self:dealwithTask(nTaskType, nTaskId, nTaskStatus)
			--先遍历正在进行任务列表
			for i,v in pairs(self.m_tTaskList.tDailyTask.tDoing) do
				if v.nId == nTaskId then
					v.nTaskStatus = nTaskStatus
					v.nTargetStatus = 0
					v.nTargetValue = 0
					table.insert(self.m_tTaskList.tDailyTask.tCompleted, v)
					table.remove(self.m_tTaskList.tDailyTask.tDoing, i)
					bFound = true
					break
				end
			end
			--未找到要更新的任务则遍历待提交任务列表
			if not bFound then
				for i,v in pairs(self.m_tTaskList.tDailyTask.tToSubmit) do
					if v.nId == nTaskId then
						v.nTaskStatus = nTaskStatus
						v.nTargetStatus = 0
						v.nTargetValue = 0
						table.insert(self.m_tTaskList.tDailyTask.tCompleted, v)
						table.remove(self.m_tTaskList.tDailyTask.tToSubmit, i)
						bNextFound = true
						break
					end
				end
			end

			local tRewardsNum
            local tRewardsItemId
            if reward then 
                tRewardsItemId, tRewardsNum = SplitItemString(reward)
            else
                tRewardsNum,tRewardsItemId = self:_getTaskRewards(nTaskType, nTaskId)
            end
			WndRewardShow:showById(tRewardsItemId,tRewardsNum,nil,nTaskId)
            WZLog("******* updateUIFunc 3333333 ********", nTaskId)
            self:updateUIFunc()
		end
        --竞技任务
    elseif 9 == nTaskType then
        if nTaskStatus == TASKSTATUS_TOSUBMIT then
            WZLog("AthleticsTask TASKSTATUS_TOSUBMIT")
        elseif nTaskStatus == TASKSTATUS_COMPLETED then
            local tItemId = {}
            local bFound = false
            local bNextFound = false
            self:dealwithTask(nTaskType, nTaskId, nTaskStatus)
            --先遍历正在进行任务列表
            for i,v in pairs(self.m_tTaskList.tAthleticsTask.tDoing) do
                if v.nId == nTaskId then
                    v.nTaskStatus = nTaskStatus
                    v.nTargetStatus = 0
                    v.nTargetValue = 0
                    table.insert(self.m_tTaskList.tAthleticsTask.tCompleted, v)
                    table.remove(self.m_tTaskList.tAthleticsTask.tDoing, i)
                    bFound = true
                    break
                end
            end
            --未找到要更新的任务则遍历待提交任务列表
            if not bFound then
                for i,v in pairs(self.m_tTaskList.tAthleticsTask.tToSubmit) do
                    if v.nId == nTaskId then
                        v.nTaskStatus = nTaskStatus
                        v.nTargetStatus = 0
                        v.nTargetValue = 0
                        table.insert(self.m_tTaskList.tAthleticsTask.tCompleted, v)
                        table.remove(self.m_tTaskList.tAthleticsTask.tToSubmit, i)
                        bNextFound = true
                        break
                    end
                end
            end

            local tRewardsNum
            local tRewardsItemId
            if reward then 
                tRewardsItemId, tRewardsNum = SplitItemString(reward)
            else
                tRewardsNum,tRewardsItemId = self:_getTaskRewards(nTaskType, nTaskId)
            end
            WndRewardShow:showById(tRewardsItemId,tRewardsNum,nil,nTaskId)
            WZLog("******* updateUIFunc 444444 ********", nTaskId)
            self:updateUIFunc()
        end
	end	
    if self:getLoadingId() ~= -1 then
        MsgBoxManager:removeMsgById(self:getLoadingId())
        self:setLoadingId(-1)
    end
end

--@brief    更新任务状态
function WndTask:dealwithTask(nTaskType, nDealwithTaskId, nTaskStatus)
    -- body
    if nTaskType == 3 then 
        local element = GetElement(self.m_root, "flconDailyList_WndTask", WZUIFreeListContainer)
        for i = 1 , element:size() do
            local newElement = element:getAt(i-1)
            newElement = WZUIContainer:luaTo(newElement)
            local tNewObj = newElement:getLuaObjectIndex()
            local nTaskId = tNewObj:getTaskID()
            if nTaskId == nDealwithTaskId then
                if nTaskType == 3 then
                    tNewObj:setTaskStatus( nTaskStatus)
                end
                break
            end
        end
    else
        local element = GetElement(self.m_root, "flconTaskList_WndTask", WZUITableContainer)
        local nTag = 0 
        local cellElement = element:getCellElement(nTag)
        while cellElement do
            cellElement = WZUIContainer:luaTo(cellElement)
            local cellItem = cellElement:getChildElement("__CellTaskListItem")
            if cellItem then
                local cellObj = WZUIContainer:luaTo(cellItem):getLuaObjectIndex()
                if cellObj then
                    local nTaskId = cellObj:getTaskID()
                    if nTaskId == nDealwithTaskId then
                        if nTaskType == 1 then
                            element:removeCellElementByReset(nTag)
                        elseif nTaskType == 2 then
                            element:removeCellElementByReset(nTag)
                        elseif nTaskType == 9 then
                            cellObj:setTaskStatus( nTaskStatus)
                        end
                        break
                    end
                end
            end
            nTag = nTag + 1
            cellElement = element:getCellElement(nTag)
        end
    end
end

--@brief 	更新任务奖励
--@param 	nTaskID:任务ID
function WndTask:updateTaskRewards(nTaskID)
	local tRewardsNum = {}
	local bFound = false
	local now_uplevel = 0
	--先遍历待提交任务列表
	for i,v in pairs(self.m_tTaskList.tDailyTask.tToSubmit) do
		if v.nId == nTaskID then
			
			now_uplevel = v.nUpLevel
			bFound = true
			break
		end
	end
	--未找到要更新的任务则遍历正在进行任务列表
	if not bFound then
		for i,v in pairs(self.m_tTaskList.tDailyTask.tDoing) do
			if v.nId == nTaskID then
				
				now_uplevel = v.nUpLevel
				break
			end
		end
	end
	
	for i,v in pairs(self.m_tDailyLuaObj) do
		if v.m_tTaskData.nId == nTaskID then
			--v:improveTaskRewards(tRewardsNum)
			WZLog("v:improveTaskRewards:::loadingId="..self.m_nloadingId)
			MsgBoxManager:removeMsgById(self.m_nloadingId)
			--self:setLoadingId(-1)
			WZLog("loadingBox is remove")
			v:improveTaskRewards(now_uplevel)
			return
		end
	end
end

--add by wuweidong
--@brief	设置loadingId
function WndTask:setLoadingId(nId)
	self.m_nloadingId = nId
end

--@brief	获得loadingId
function WndTask:getLoadingId()
	return self.m_nloadingId
end

--@brief	loading回调
function WndTask:updateUIFunc( )
	if PrefetchCache:hasTaskList() then
		self.m_tTaskList = {}
        self.m_tTaskList = PrefetchCache:getTaskList()
    end
    self:_setTaskCount()
	if self.m_nCurIndex == 0 then
		WZLog("update MainTask")
		self:_updateMainTask()
	elseif self.m_nCurIndex == 1 then
		WZLog("update DailyTask")
		self:DailyTaskTableCellUpdate()
	elseif self.m_nCurIndex == 2 then
		WZLog("update BranchTask")
        self:_updateBranchTask()
    elseif self.m_nCurIndex == 3 then
		self:_updateAthleticsTask()
	end
end

--@brief    任务外部接口
--@brief    nIndex : 0~2依次表示主线，支线，日常
function WndTask:showInterface(nIndex)
    -- body
    if self.m_root then
        self:actionCallback_close()
    end

    local wndTask = WndTask:createElement()
    if wndTask then
        self.m_nSpecifyIndex = nIndex
        WindowManager:addWindow(wndTask, WndTask,nil,nil,nil)
    end
end

--@brief    设置宝箱的数据状态
function WndTask:setDailyBoxData()
    -- body
    self.m_tDailyActivityData = {}
    local tStatus = PrefetchCache:getActivityBoxStatus()

    local taskReward = CacheCenter:getGameParam()["huoyue"]
    WZLog("WndTask:setDailyBoxData", type(taskReward), taskReward)
    local tRewardConfig = json.decode(taskReward)
    for key, value in pairs(tRewardConfig) do

        local tItem = {}
        tItem.target = tonumber(key)
        tItem.coinId = 80

        tItem.reward = {}
        local array = SplitStringWithSeparator(value, "&")
        for k = 1, #array do
            WZLog("SplitItemString",string.sub(array[k], 2, -2))
            local string = string.sub(array[k], 2, -2) 
            local id = SplitStringWithSeparator(string,",")[1]
            local num = SplitStringWithSeparator(string,",")[2]

            table.insert(tItem.reward, {tonumber(id), tonumber(num)})
        end

        table.insert(self.m_tDailyActivityData, tItem)
    end

    table.sort(self.m_tDailyActivityData, function (a,b)
        -- body
        return a.target < b.target
    end)
    for i = 1, #self.m_tDailyActivityData do
        self.m_tDailyActivityData[i].status = tStatus[i]
    end

    self:_showDailyActivity()
end


--@brief    宝箱领取成功
function WndTask:getActivityBoxRewardOK(status, index)
    -- body
    if status == 0 then 
        self.m_tDailyActivityData[index + 1].status = 2

        local tRewardsItemId = {}
        local tRewardsNum = {}
        for k = 1, #self.m_tDailyActivityData[index + 1].reward do
            table.insert(tRewardsItemId, self.m_tDailyActivityData[index + 1].reward[k][1])
            table.insert(tRewardsNum, self.m_tDailyActivityData[index + 1].reward[k][2])
        end
        WndRewardShow:showById(tRewardsItemId, tRewardsNum)
        self:_showDailyActivity()

        PrefetchCache:updateActivityBoxStatus(index + 1, 2)
        self:_setTaskCount()
        if GlobalGame.g_nMainTaskCount > 0 or GlobalGame.g_nBranchTaskCount > 0 or GlobalGame.g_nDailyTaskCount > 0 or GlobalGame.g_nAthleticsTaskCount > 0 or PrefetchCache:whetherHaveBoxActive() then 
            CacheCenter:setRedState("btnTask", true, 1)
        else 
            CacheCenter:setRedState("btnTask", false, 2)
        end
        GlobalGame:getBtnRedPointEvent():dispatcher()
    end
end

--@brief    缓存推送更新物品时调用的函数
function WndTask:updatePlayerItemData()
    WZLog("WndTask:updatePlayerItemData")

    if self.m_root ~= nil and 1 == self.m_nCurIndex then
        self:_showDailyActivity()
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	获取任务数据
--@param 	nTaskID:任务ID
--@param 	nTaskType:任务类型（0:主线任务，2:日常任务）
--@note 	根据任务ID从LocalData.lua中获取任务数据
function WndTask:_getTaskData(nTaskID, nTaskType)
	local tTaskData = {}
	
	if 0 == nTaskType or 3 == nTaskType then
		tTaskData = MainTask["id_"..nTaskID]
	elseif 2 == nTaskType then
		tTaskData = DailyTask["id_"..nTaskID]
	end

	return tTaskData
end

--@brief 	获取任务奖励
--@param 	nTaskType:任务类型（0：主线，2：每日）
--@param 	nTaskID:任务ID
function WndTask:_getTaskRewards(nTaskType, nTaskID)
	local tRewardsNum = {}
	local tRewardsItemId = {}
	local tTaskData = GDatatab_task["id_"..nTaskID]
	for i=1,#tTaskData.reward do
		table.insert(tRewardsNum,tTaskData.reward[i][2])
		table.insert(tRewardsItemId,tTaskData.reward[i][1])
	end
	return tRewardsNum,tRewardsItemId
end

--@brief 	更新每日任务《完成日常任务数量》的状态值
--@note 	对于每日任务中的特殊任务《完成日常任务数量》，每当有其他每日任务完成时需要更新该任务的状态
function WndTask:_updateDailyTaskSpecial(nTargetStatus)
	for i,v in pairs(self.m_tTaskList.tDailyTask.tDoing) do
		if 15 == v.nId then
			--v.nTargetStatus = v.nTargetStatus + 1
			v.nTargetStatus = nTargetStatus --modify by wuweidong
		end
	end
end


--@brief	空数据提示语
function WndTask:_showEmptyTip()
    WZLog("***** WndTask:_showEmptyTip *****")
	local conTaskContent_WndTask = GetElement(self.m_root,"conTaskContent_WndTask",WZUIContainer)
	removeShowPanelNullTip(conTaskContent_WndTask)
    ShowPanelNullTip(conTaskContent_WndTask)
end

--@brief    获取月卡时间剩余天数
function WndTask:_getMonthCardTime()
    --body
    local tPlayerItemsList = CacheCenter:getPlayerItems()
    if tPlayerItemsList == nil or tPlayerItemsList == {} then return end
    local nLastTime = 0
    local nTime = 0
    for i = 1, #tPlayerItemsList do
        if tPlayerItemsList[i].id == 50 or tPlayerItemsList[i].id == 51 then
            nLastTime = nLastTime + tPlayerItemsList[i].lastTime
        end
        if tPlayerItemsList[i].id == 55 then
    		nTime = nTime + tPlayerItemsList[i].lastTime
    	end
    end

    WZLog("********* WndTask:_getMonthCardTime *********", nLastTime)

    local nLastDays = nLastTime / (24 * 3600)
    local Days = nTime / (24 * 3600)

    self.m_nDailyMonthCardTime = math.ceil(nLastDays)
    self.m_nWeekCardTime = math.ceil(Days)
end
-------------------------------------私有方法模块End----------------------------------------



