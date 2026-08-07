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

    --离线本地数据
    self.m_tOffLineTaskData = {}
    self.m_bIsGettingReward = false 
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
    self.m_tOffLineTaskData = {}
    self.m_bIsGettingReward = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndTask:createElement()
    if WndTask.m_root ~= nil then
        WindowManager:removeWindow(WndTask.m_root, WndTask, true)
    end
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
        --职业任务
    elseif 8 == nTaskType then
        if nTaskStatus == TASKSTATUS_TOSUBMIT then
            WZLog("ProfessionTask TASKSTATUS_TOSUBMIT")
        elseif nTaskStatus == TASKSTATUS_COMPLETED then
            local tItemId = {}
            local bFound = false
            local bNextFound = false
            self:dealwithTask(nTaskType, nTaskId, nTaskStatus)
            --先遍历正在进行任务列表
            for i,v in pairs(self.m_tTaskList.tProfessionTask.tDoing) do
                if v.nId == nTaskId then
                    v.nTaskStatus = nTaskStatus
                    v.nTargetStatus = 0
                    v.nTargetValue = 0
                    table.insert(self.m_tTaskList.tProfessionTask.tCompleted, v)
                    table.remove(self.m_tTaskList.tProfessionTask.tDoing, i)
                    bFound = true
                    break
                end
            end
            --未找到要更新的任务则遍历待提交任务列表
            if not bFound then
                for i,v in pairs(self.m_tTaskList.tProfessionTask.tToSubmit) do
                    if v.nId == nTaskId then
                        v.nTaskStatus = nTaskStatus
                        v.nTargetStatus = 0
                        v.nTargetValue = 0
                        table.insert(self.m_tTaskList.tProfessionTask.tCompleted, v)
                        table.remove(self.m_tTaskList.tProfessionTask.tToSubmit, i)
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
    self:setGetRewardLimit(false)
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
    elseif self.m_nCurIndex == 4 then
        self:_updateProfessionTask()
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

--@brief    设置宝箱的数据状态
function WndTask:setDailyBoxData2()
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
        if GlobalGame.g_nMainTaskCount > 0 or GlobalGame.g_nBranchTaskCount > 0 or GlobalGame.g_nDailyTaskCount > 0 or GlobalGame.g_nAthleticsTaskCount > 0 or PrefetchCache:whetherHaveBoxActive() or GlobalGame.g_nProfessionTaskCount > 0 then 
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

    WndTask:updateRedDot()
end

--@brief    领取奖励收到错误协议，去掉领取状态限制
function WndTask:setGetRewardLimit(bBool)
    -- body
    if self.m_root == nil then return end 

    self.m_bIsGettingReward = bBool
end

--@brief    获取是否在领取奖励
function WndTask:weatherInGetReward()
    -- body
    return self.m_bIsGettingReward 
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


--离线找回子项模块
CellTaskOffOnlineItem = {}
function CellTaskOffOnlineItem:_init()
    self.m_root = nil                   --场景根节点
end

--@brief    反初始化表的成员变量
--@note     在退出场景时回调的onExit函数里面必须调用本函数
function CellTaskOffOnlineItem:_unInit()
    self.m_root = nil
end

--@brief    创建控件
function CellTaskOffOnlineItem:createElement()
    local tNewObj = self:_new()
    local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setAbsContentSize(GlobalMethod:CCSize(888,130))
    element:setLuaObjectIndex(tNewObj)
    tNewObj.m_root = element
    self:_init()
    return element,tNewObj
end
function CellTaskOffOnlineItem:setTaskOffOnlineMessage(index, data)
--     self.m_nDayIndex = index
    self.m_tTaskOffOnlineData = data
end
--@brief    开始加载
function CellTaskOffOnlineItem:onLoadData(element)
    local celElement = WZUISystem:getInstance():createElement("OffOnlineTaskItem")
    celElement:setVisible(true)
    element:addChild(celElement)

    self:setTaskOffOnlineDateItem()
end

function CellTaskOffOnlineItem:setTaskOffOnlineDateItem()
    if not self.m_tTaskOffOnlineData then return end

    -- local good_item = GetElement(self.m_root,"good_item",WZUIContainer)
    -- local imgFreeTextBox1 = GetElement(self.m_root,"imgFreeTextBox11",WZUIFreeTextBox)
    -- local imgFreeTextBox2 = GetElement(self.m_root,"imgFreeTextBox24",WZUIFreeTextBox)
    -- imgFreeTextBox2:setVisible(false)
    if self.m_tTaskOffOnlineData.item_id and self.m_tTaskOffOnlineData.item_num then
        local ids = {}
        local nums = {}
        local table_insert = table.insert
        for i=1,#self.m_tTaskOffOnlineData.item_id do
            local key = "id_"..self.m_tTaskOffOnlineData.item_id[i]
            local path = GDatatab_item[key].icon
            table_insert(ids, path)
            table_insert(nums, self.m_tTaskOffOnlineData.item_num[i])
        end
        local str = [[<I Z="0.5">%s</I><T C="99,255,95" S="20" P="1">%d  </T>]]
        local temp = ""
        local temp_1 = ""
        WZLog("离线奖励长度",Serialize(ids))
        for i,v in ipairs(ids) do
            if i <= 5 then
                local imgFreeTextBox1 = GetElement(self.m_root,"imgFreeTextBox1"..i,WZUIFreeTextBox)
                imgFreeTextBox1:setShowText(string.format(str,v,nums[i]))
                imgFreeTextBox1:setTag(i)
                -- temp = temp .. string.format(str,v,nums[i])
            else
                local imgFreeTextBox2 = GetElement(self.m_root,"imgFreeTextBox2"..i,WZUIFreeTextBox)
                imgFreeTextBox2:setShowText(string.format(str,v,nums[i]))
                imgFreeTextBox2:setTag(i)
                -- temp_1 = temp_1 .. string.format(str,v,nums[i])
            end
        end
        -- imgFreeTextBox1:setShowText(temp)
        -- if temp_1 ~= "" then
        --     imgFreeTextBox2:setVisible(true)
        --     imgFreeTextBox2:setShowText(temp_1)
        -- end
    end
    local item_img = GetElement(self.m_root,"item_img",WZUIImage)
    item_img:setFile("ui/"..self.m_tTaskOffOnlineData.icon)

    GetElement(self.m_root,"offonline_title",WZUILabelTTF):setText(self.m_tTaskOffOnlineData.title)

    self.isStrengthRetrieveDiamond = 1
    if self.m_tTaskOffOnlineData.item_id[1] == 6 then
        self.isStrengthRetrieveDiamond = self.m_tTaskOffOnlineData.item_num[1]
    end

    --钻石
    local retrieve_diamond = GetElement(self.m_root,"retrieve_diamond",WZUIImage)
    retrieve_diamond:setFile(GDatatab_item["id_"..self.m_tTaskOffOnlineData.dianmond_info[1]].icon)
    local diamond_label = GetElement(self.m_root,"diamond_label",WZUILabelTTF)
    diamond_label:setText(self.m_tTaskOffOnlineData.dianmond_info[2]*self.isStrengthRetrieveDiamond)

    --金币
    local retrieve_gold = GetElement(self.m_root,"retrieve_gold",WZUIImage)
    retrieve_gold:setFile(GDatatab_item["id_"..self.m_tTaskOffOnlineData.gold_info[1]].icon)
    local gold_label = GetElement(self.m_root,"gold_label",WZUILabelTTF)
    gold_label:setText(self.m_tTaskOffOnlineData.gold_info[2]*self.isStrengthRetrieveDiamond)
end

--钻石找回
function CellTaskOffOnlineItem:onBtnDiamondClick()
    if self.m_tTaskOffOnlineData then
        local monNum =  CacheCenter:getPlayerItemCountById(1)
        if tonumber(self.m_tTaskOffOnlineData.dianmond_info[2]*self.isStrengthRetrieveDiamond) > tonumber(monNum) then
            JudgeMoneyIsEnough(70, tonumber(self.m_tTaskOffOnlineData.dianmond_info[2]*self.isStrengthRetrieveDiamond), nil, nil, nil, nil, nil, nil, nil, self, function() 
                ProtocolProcessorSceneActive:send_TASK_Retrieve(self.m_tTaskOffOnlineData.task_id, 0)
            end)
            return
        end
        ProtocolProcessorSceneActive:send_TASK_Retrieve(self.m_tTaskOffOnlineData.task_id, 0)
    end
end
--金币找回
function CellTaskOffOnlineItem:onBtnGoldClick()
    MsgBoxManager:showConfirmBox(LocalStrings.OPTIMIZE_TEXT14,self,function()
        if self.m_tTaskOffOnlineData then
            local monNum =  CacheCenter:getPlayerItemCountById(2)
            if monNum >= self.m_tTaskOffOnlineData.gold_info[2]*self.isStrengthRetrieveDiamond then 
                ProtocolProcessorSceneActive:send_TASK_Retrieve(self.m_tTaskOffOnlineData.task_id, 1)
            else
                MsgBoxManager:showTipBox(LocalStrings.GOLD1..LocalStrings.NOT_ENABLE)
            end
        end
    end)
end

function CellTaskOffOnlineItem:onClickTips(element)
    -- body
    local tag = element:getTag()
    WZLog("點擊按鈕",tag)
    if not self.m_tTaskOffOnlineData then return end
    if tag > #self.m_tTaskOffOnlineData.item_id then return end
    if self.m_tTaskOffOnlineData.item_id and self.m_tTaskOffOnlineData.item_num then
        local key = "id_"..self.m_tTaskOffOnlineData.item_id[tag]
        local tData = CopyTable(GDatatab_item[key])
        WndItemInfo:onCloseClick()
        WndItemInfo:showInfo(element,WndTask.m_root,1,tData,false)
    end
end

--@brief    点击物品弹出对应的tips
function CellTaskOffOnlineItem:onItemClick(tCell,tag,tData)
    if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tCell.m_root,WndTask.m_root,1,tData,false)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@return   新建的表实例对象
function CellTaskOffOnlineItem:_new( )
    local tNewObj = {}
    setmetatable(tNewObj, self)
    self.__index = self
    return tNewObj
end


