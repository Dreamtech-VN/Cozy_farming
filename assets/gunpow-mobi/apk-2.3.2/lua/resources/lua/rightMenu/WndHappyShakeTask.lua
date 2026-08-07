--WndHappyShakeTask.lua
--@brief	WndHappyShakeTask的UI模块
--@date		2020/05/28
--@author	XTX
--@note		全民摇摇乐任务


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndHappyShakeTask:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
    ProtocolProcessorNewActivity:send_ACTIVITY2_GetPokerTaskList()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndHappyShakeTask:onExit(element)
    if self.m_root then 
        self.m_root:disableSchedule()
    end

	self:_unInit()
end

--@brief	点击关闭按钮的响应方法
--@param	element:关闭按钮绑定的UI节点引用
--@note		点击关闭按钮的响应方法
function WndHappyShakeTask:onClose(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	点击成长按钮的响应方法
--@param	element:主线按钮绑定的UI节点引用
--@note		点击主线按钮的响应方法
function WndHappyShakeTask:onMainTaskSelected(element)
    local isTeach = TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 18 and TeachGroup1.STEP == 3
    if 0 == self.m_nCurIndex or isTeach then
        return
    end
    self:_setCheckBoxSel(true, false)
    self.m_nCurIndex = 0
    WZLog("WndHappyShakeTask:onMainTaskSelected")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

    self:_updateMainTask()
end

--@brief	点击每日按钮的响应方法
--@param	element:每日按钮绑定的UI节点引用
--@note		点击每日按钮的响应方法
function WndHappyShakeTask:onDailyTaskSelected(element)
    WZLog("WndHappyShakeTask:onDailyTaskSelected")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    
    self:_setCheckBoxSel(false, true)

    local conTaskContent = GetElement(self.m_root,"conTaskContent_WndHappyShakeTask",WZUIContainer)
    removeShowPanelNullTip(conTaskContent)

    self.m_nCurIndex = 1

    if self.bDailyTaskFirstLoad then
        self:DailyTaskTableCellUpdate()
        self.bDailyTaskFirstLoad = false
    end
end

--@brief    日常任务列表更新
function WndHappyShakeTask:DailyTaskTableCellUpdate()
    WZLog("WndHappyShakeTask:DailyTaskTableCellUpdate")
    local tbconDailyList = GetElement(self.m_root, "flconDailyList_WndHappyShakeTask", WZUIFreeListContainer)
    if tbconDailyList:size() > 0 then
        tbconDailyList:removeAll()
    end
    self.m_tDailyLoadIndex = 1
    if #self.m_tDailyTaskList.tToSubmit > 0 then 
        self:_setDailyTaskItem(self.m_tDailyTaskList.tToSubmit, tbconDailyList)
    end
    if #self.m_tDailyTaskList.tDoing > 0 then 
        self.m_tDailyLoadIndex = 2
        self:_setDailyTaskItem(self.m_tDailyTaskList.tDoing, tbconDailyList)
    end
    if #self.m_tDailyTaskList.tCompleted > 0 then 
        self.m_tDailyLoadIndex = 3
        self:_setDailyTaskItem(self.m_tDailyTaskList.tCompleted, tbconDailyList)
    end 
end

function WndHappyShakeTask:_setDailyTaskItem(tTaskList,tbconDailyList )
    WZLog("*********** WndHappyShakeTask:_setDailyTaskItem *************")
    if tTaskList == nil or tTaskList == {} then
        WZLog("*********** WndHappyShakeTask:_setDailyTaskItem 11111*************")
    end
    if tTaskList == nil then 
        return 
    end 
    local count = #tTaskList
    self.m_tDailyCacheTaskList = tTaskList
    self.m_nCurrentCellIndex = 1
    
    if count > 0 then
        self:_loadDailyTaskItem(tbconDailyList)
    end 
end


--@brief    分帧加载日常任务
function WndHappyShakeTask:_loadDailyTaskItem( element ,delate )
    element = WZUIFreeListContainer:luaTo(element)
    if self.m_nCurrentCellIndex > #self.m_tDailyCacheTaskList then 
        WZLog("******** WndHappyShakeTask:_loadDailyTaskItem *******", self.m_tDailyLoadIndex)
        return 
    end 
    WZLog("日常任务状态值:"..self.m_tDailyCacheTaskList[self.m_nCurrentCellIndex].nTaskStatus)
    if not (self.m_tDailyCacheTaskList[self.m_nCurrentCellIndex].nTaskStatus == TASKSTATUS_STALE) then
        for i = 1, #self.m_tDailyCacheTaskList do
            local dailyElement, tLuaObj = CellHappyShakeTask:createElement()
            element:pushBack(WZUIContainer:luaTo(dailyElement))
            dailyElement:setContentSize(GlobalMethod:CCSize(620,95))
            dailyElement:setRelativeSize(GlobalMethod:CCSize(1,95/320))
            local tTaskDesc = GDatatab_shake_task["id_"..self.m_tDailyCacheTaskList[self.m_nCurrentCellIndex].nId].desc
            if tTaskDesc == nil then
                return
            end

            WZLog("TaskDesc==0>"..tTaskDesc.."|"..self.m_tDailyCacheTaskList[self.m_nCurrentCellIndex].nTaskStatus)
            m_tTaskDesc = tTaskDesc
            local _sTaskGoals = string.format("%d/%d", self.m_tDailyCacheTaskList[self.m_nCurrentCellIndex].nTargetStatus,self.m_tDailyCacheTaskList[self.m_nCurrentCellIndex].nTargetValue)

            local tTaskData = GDatatab_shake_task["id_" .. self.m_tDailyCacheTaskList[self.m_nCurrentCellIndex].nId]
            if tTaskData == nil then 
                return 
            end
            m_tTaskTitle = ""
            local tReward = {}
            local _itemQuality = {}
            tLuaObj:setTaskID(self.m_tDailyCacheTaskList[self.m_nCurrentCellIndex].nId)
            if self.m_tDailyCacheTaskList[self.m_nCurrentCellIndex].nTaskStatus == TASKSTATUS_DOING then
                tLuaObj:setBtnText(LocalStrings.UNCOMPLETE)
            elseif self.m_tDailyCacheTaskList[self.m_nCurrentCellIndex].nTaskStatus == TASKSTATUS_TOSUBMIT then
                tLuaObj:setTaskID(self.m_tDailyCacheTaskList[self.m_nCurrentCellIndex].nId)
                tLuaObj:setBtnText(LocalStrings.COMPLETE_TASK)
            end
            local m_tRewardData={}       --物品奖励表
            local RewardCount = #tTaskData.reward
            for i=1,RewardCount do
                local cell_item = {}
                local ItemId = tTaskData.reward[i][1]
                cell_item.ItemNum = tTaskData.reward[i][2]
                cell_item.id = ItemId
                local m_tItemData = GDatatab_item["id_"..ItemId]
                if m_tItemData == nil then 
                    break 
                end 
                cell_item.icon = m_tItemData.icon
                if m_tItemData.sex == 2 or m_tItemData.sex == CacheCenter:getPlayerInfo().sex then
                    table.insert(m_tRewardData, cell_item)
                end
            end

            tLuaObj:initMessageInfo(m_tRewardData, m_tTaskTitle, m_tTaskDesc, self.m_tDailyCacheTaskList[self.m_nCurrentCellIndex].nTaskStatus, self.m_nCurrentCellIndex, _sTaskGoals)
            element:getMoveElement():setPositionY(element:getMinPosition().y)
            self.m_nCurrentCellIndex = self.m_nCurrentCellIndex + 1
        end
    end
end

function WndHappyShakeTask:scheduleCountdown(element, delta)
    if self.m_refreshTime then
        self.m_refreshTime = math.max(self.m_refreshTime - 1, 0)
        if self.m_refreshTime <= 0 then
            self.m_root:disableSchedule()
            ProtocolProcessorNewActivity:send_ACTIVITY2_GetPokerTaskList()
        end
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    设置选中的选项卡高亮图片可见，其余不可见
--@param    bMainVisible 主线任务高亮是否显示
--@param    bDailyVisible 日常任务是否高亮显示
function WndHappyShakeTask:_setCheckBoxSel(bMainVisible, bDailyVisible)
    -- body
    GetElement(self.m_root, "conCheckBoxMainSel_WndHappyShakeTask", WZUIContainer):setVisible(bMainVisible)
    GetElement(self.m_root, "conCheckBoxDailySel_WndHappyShakeTask", WZUIContainer):setVisible(bDailyVisible)

    GetElement(self.m_root, "flconTaskList_WndHappyShakeTask", WZUITableContainer):setVisible(bMainVisible)
    GetElement(self.m_root, "flconDailyList_WndHappyShakeTask", WZUIFreeListContainer):setVisible(bDailyVisible)
end

--@brief    更新主线任务
function WndHappyShakeTask:_updateMainTask()
    WZLog("WndHappyShakeTask:_updateMainTask", #self.m_tMainTaskList)
    if #self.m_tMainTaskList <= 0  then 
        local flconTaskList = GetElement(self.m_root,"flconTaskList_WndHappyShakeTask",WZUITableContainer)
        if flconTaskList == nil then
            return
        end
        flconTaskList:cleanTable()

        self:_showEmptyTip()
        return 
    end 
    local conTaskContent = GetElement(self.m_root,"conTaskContent_WndHappyShakeTask",WZUIContainer)
    removeShowPanelNullTip(conTaskContent)

    self:_sortMainTaskList()
    self:_setTaskList(self.m_tMainTaskList)
end

--@breif 对主线任务进行排序
function WndHappyShakeTask:_sortMainTaskList()
    --WZLog(debug.traceback())
    local taskCount = #self.m_tMainTaskList
    local tTaskFinish = {}
    local tTaskNew = {}
    local tTaskDoing = {}
    for i=1,taskCount do
        if self.m_tMainTaskList[i].nTaskStatus == TASKSTATUS_TOSUBMIT then
            table.insert(tTaskFinish,self.m_tMainTaskList[i])
        elseif self.m_tMainTaskList[i].nTaskStatus == TASKSTATUS_DOING then
            table.insert(tTaskNew,self.m_tMainTaskList[i])
        else 
            table.insert(tTaskDoing,self.m_tMainTaskList[i])
        end 
    end

    self.m_tMainTaskList = {}
    table.sort(tTaskFinish, function(a, b) return a.nId < b.nId end)
    for j = 1, #tTaskFinish do
        table.insert(self.m_tMainTaskList, tTaskFinish[j])
    end
    table.sort(tTaskNew, function(a, b) return a.nId < b.nId end)
    for i = 1, #tTaskNew do
        WZLog("WndHappyShakeTask:_sortMainTaskList()===>new")
        table.insert(self.m_tMainTaskList, tTaskNew[i])
    end
    table.sort(tTaskDoing, function(a, b) return a.nId < b.nId end)
    for k = 1, #tTaskDoing do
        table.insert(self.m_tMainTaskList, tTaskDoing[k])   
    end
end

--@brief 设置主支线任务列表
function WndHappyShakeTask:_setTaskList(m_tTaskList)
    WZLog("************ WndHappyShakeTask:_setTaskList ************")
    local flconTaskList = GetElement(self.m_root,"flconTaskList_WndHappyShakeTask",WZUITableContainer)
    if flconTaskList == nil then
        return
    end
    flconTaskList:cleanTable()

    if m_tTaskList == nil then 
        m_tTaskList = {}
    end
    local list_count = #m_tTaskList
    WZLog("WndHappyShakeTask:_setTaskList=="..list_count)

    self.m_tCacheTaskList = m_tTaskList 
    self.m_nCurrentCellIndex = 1 
	if list_count > 0 then
        self:_LoadTaskFrame(flconTaskList)
    end
end


--@brief  分帧加载任务
function WndHappyShakeTask:_LoadTaskFrame( element ,delta )
    if not (self.m_tCacheTaskList[self.m_nCurrentCellIndex].nTaskStatus == TASKSTATUS_STALE) then
        element = WZUITableContainer:luaTo(element)
        for i = 1, #self.m_tCacheTaskList do
            local cellElement,luaObj = CellHappyShakeTask:createElement()
            local tMainTaskData = GDatatab_shake_task["id_"..self.m_tCacheTaskList[self.m_nCurrentCellIndex].nId]
            self:_setTaskContext(self.m_tCacheTaskList, self.m_nCurrentCellIndex, luaObj, tMainTaskData)
            cellElement = WZUIContainer:luaTo(cellElement)
            
            cellElement:setTag(self.m_nCurrentCellIndex - 1)
            element:setCellElement(cellElement)

            self.m_nCurrentCellIndex = self.m_nCurrentCellIndex + 1
        end
    end
end

--@brief 设置任务详细内容面板
function WndHappyShakeTask:_setTaskContext(m_listData, nIndex, tLuaObj, tMainTaskData)
       --body
        local list_count = #m_listData
        local m_tRewardData={}       --物品奖励表
        local m_tTaskTitle = nil     --任务标题
        local m_tTaskDesc = nil      --任务描述
        local m_tTaskState = 0       --任务状态
        
        WZLog("WndHappyShakeTask:_setTaskContext::=============================index="..m_listData[nIndex].nId)
        local tTaskDesc = GDatatab_shake_task["id_" .. m_listData[nIndex].nId].desc
        if tTaskDesc == nil then
            return
        end
        WZLog("TaskDesc==>"..tTaskDesc)
        m_tTaskDesc = tTaskDesc
      
        local _sTaskGoals = ""
         _sTaskGoals = string.format("%d/%d",m_listData[nIndex].nTargetStatus,m_listData[nIndex].nTargetValue)
        --m_tTaskDesc = m_tTaskDesc

        local tTaskData = tMainTaskData
        if tTaskData == nil then 
            return 
        end
        m_tTaskTitle = ""
           
        local tReward = {}
        local _itemQuality = {}
       
        tLuaObj:setTaskID(m_listData[nIndex].nId)
        if m_listData[nIndex].nTaskStatus == TASKSTATUS_DOING then
            tLuaObj:setBtnText(LocalStrings.UNCOMPLETE)
        elseif m_listData[nIndex].nTaskStatus == TASKSTATUS_TOSUBMIT then
            tLuaObj:setTaskID(m_listData[nIndex].nId)
            tLuaObj:setBtnText(LocalStrings.COMPLETE_TASK)
        end
        
    local RewardCount = #tTaskData.reward
    for i=1,RewardCount do
        local cell_item = {}
        local ItemId = tTaskData.reward[i][1]
        cell_item.ItemNum = tTaskData.reward[i][2]
        cell_item.id = ItemId
        local m_tItemData = GDatatab_item["id_"..ItemId]
        if m_tItemData == nil then 
            break 
        end 
        cell_item.icon = m_tItemData.icon

        if m_tItemData.sex == 2 or m_tItemData.sex == CacheCenter:getPlayerInfo().sex then
            table.insert(m_tRewardData,cell_item)
        end
    end
   
    tLuaObj:initMessageInfo(m_tRewardData,m_tTaskTitle,m_tTaskDesc,m_listData[nIndex].nTaskStatus,nIndex,_sTaskGoals)
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配begin----------------------------------------
function WndHappyShakeTask:_adaptLanguage_vn()
    local txtDailyTask = GetElement(self.m_root,"txtDailyTask_WndHappyShakeTask",WZUILabelTTF)
    txtDailyTask:setScale(0.8)
    txtDailyTask:setDimensions(GlobalMethod:CCSize(90))
    local txtDailyTask_1 = GetElement(self.m_root,"txtDailyTask_1_WndHappyShakeTask",WZUILabelTTF)
    txtDailyTask_1:setScale(0.8)
    txtDailyTask_1:setDimensions(GlobalMethod:CCSize(90))
    local txtMainTask = GetElement(self.m_root,"txtMainTask_WndHappyShakeTask",WZUILabelTTF)
    txtMainTask:setScale(0.8)
    txtMainTask:setDimensions(GlobalMethod:CCSize(90))
    local txtMainTask_1 = GetElement(self.m_root,"txtMainTask_1_WndHappyShakeTask",WZUILabelTTF)
    txtMainTask_1:setScale(0.8)
    txtMainTask_1:setDimensions(GlobalMethod:CCSize(90))
end

-------------------------------------语言适配end----------------------------------------
