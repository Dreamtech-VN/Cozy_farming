--CellTotalRechargetPanelData.lua
--@brief	CellTotalRechargetPanel的数据模块
--@date		2014/12/02
--@author	wuweidong
--@note		累计充值面板

CellTotalRechargetPanel = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellTotalRechargetPanel:_init()
    self.b_scheduleState = false
    self.reduceTime = 0.0
    self.startTime = nil
    self.endTime = nil
    self.serverTime = nil
    self.rewardItems = nil
    self.rewardId = nil
    self.rewardItemsParamCount = nil
    self.rewardCounts = nil
    self.count = 0
    self.status = nil
    self.index = 0
    self.tips = nil
    self.now_time = 0
    self.maxCount = 0
    self.activityId = nil 
    self.m_tNextId = {}
    self.target = nil 
    self.cellItemIndex = 1 
    self.m_currentIndex = 1
    self.m_content = nil 
    self.m_nLimitType = nil 
    self.m_nNeedVipLevel = nil
    self.m_tClickItemCell = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellTotalRechargetPanel:_unInit()
	self.m_root = nil
	self.b_scheduleState = false
    self.reduceTime = 0.0
    self.startTime = nil
    self.endTime = nil
    self.serverTime = nil
    self.rewardItems = nil
    self.rewardId = nil
    self.rewardItemsParamCount = nil
    self.rewardCounts = nil
    self.count = 0
    self.status = nil
    self.index = 0 
    self.tips = nil 
    self.now_time = 0
    self.maxCount = 0
    self.activityId = nil 
    self.m_tNextId = nil 
    self.target = nil 
    self.cellItemIndex = 1 
    self.m_currentIndex = 1
    self.m_content = nil 
    self.m_nLimitType = nil 
    self.m_nNeedVipLevel = nil
    self.m_tClickItemCell = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellTotalRechargetPanel:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellTotalRechargetPanel table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellTotalRechargetPanel")
	assert(element, "CellTotalRechargetPanel element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief    初始化信息
function CellTotalRechargetPanel:setMessage(index,tips,startTime ,endTime ,serverTime,rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,activityId,target, content)
    self.startTime = startTime
    self.endTime = endTime
    self.serverTime = serverTime
    self.rewardItems = rewardItems
    self.rewardId = rewardId
    self.rewardItemsParamCount = rewardItemsParamCount
    self.rewardCounts = rewardCounts
    self.count = count
    self.status = status
    self.index = index
    self.tips = tips
    self.maxCount = maxCount
    self.activityId = activityId
    self.target = target
    self.m_content = content 
    if self.index == g_tGameActivityTypes.ACTIVITY_DIAMOND_COST_TWO then 
        local tTempContent = json.decode(content)
        local targetConfig = json.decode(tTempContent.countConfig)
        local rewardConfig = json.decode(tTempContent.rewardsConfig)

        self:setTaskDataTwo(status, targetConfig, target, activityId, rewardConfig)
    end
end

--@brief    初始化信息
function CellTotalRechargetPanel:setMessage_smallRecharge(id, icon, count, giftDiamondCount, price, showFlag, name, describe, showPrice, itemId, sort, payCodeId, leftTimes, limitType, needVipLv)
    self.startTime, self.endTime = WndGameActivity:getActivityTime(g_tGameActivityTypes.ACTIVITY_SMALL_RECHARGE)
    self.serverTime = SystemTime:getServerTime()
    self.index = g_tGameActivityTypes.ACTIVITY_SMALL_RECHARGE
    WZLog("setMessage_smallRecharge", Serialize(showPrice), Serialize(itemId), Serialize(leftTimes), Serialize(sort))
    self.rewardCounts = id
    self.rewardId = sort
    self.tips = showPrice
    self.rewardItems = itemId
    self.status = leftTimes
    self.m_nLimitType = limitType 
    self.m_nNeedVipLevel = needVipLv 
end

--@brief    连续充值已经完成了几天
function CellTotalRechargetPanel:getFinishDays()
    -- body
    local nDays = 0
    if self.status == nil then 
        return nDays 
    end

    for i = 1, #self.status do
        if self.status[i] >= 0 then
            nDays = nDays + 1 
        end
    end

    return nDays
end

--@brief    获取射箭任务列表
function CellTotalRechargetPanel:_onGetTaskInfo(activityId, activityType, taskType, id, status, target, progress, progressCount, refreshTime, taskGroup)
    if activityId == self.activityId then 
        local tab = self:setTaskData(id, status, target, progress, activityId)
    --    WZLog("CellTotalRechargetPanel:_onGetTaskInfo", taskType, taskGroup, Serialize(tab))
        
        self:showWindow( )
    end
end

--@brief    设置任务数据成功
function CellTotalRechargetPanel:setTaskData(id, status, target, progress, activityId)
    self.m_tRewardList = {}
    self.m_tRewardList.m_tDoingList = {}
    self.m_tRewardList.m_tDoneList = {}
    local data = {}
    local nMaxNum = 0 
    if id and next(id) ~= nil then
        for i = 1, #id do
            local tab = {}
            tab.rewardId = id[i]
            tab.status = status[i]
            tab.target = target[i]
            tab.curTarget = progress[i]
            tab.tip = ""
            tab.m_tData = {}
            tab.activityId = activityId
            local config = GDatatab_new_activity_task["id_"..id[i]]
            if config then
                tab.tip = string.format(config.desc, tab.curTarget .. "/" .. tab.target)
                tab.m_tData = {}
                for k = 1, #config.reward do
                    local tTempItem = {id = config.reward[k][1], num = config.reward[k][2]}
                    table.insert(tab.m_tData, tTempItem)
                end
                tab.script = config.script
            end

            if tab.status == 1 then 
                table.insert(self.m_tRewardList.m_tDoneList, tab)
            else
                table.insert(self.m_tRewardList.m_tDoingList, tab)
            end
            if tab.target > nMaxNum then 
                nMaxNum = tab.target
            end
        end

        self.maxCount = nMaxNum
        table.sort(self.m_tRewardList.m_tDoneList, sortReward)
        table.sort(self.m_tRewardList.m_tDoingList, sortReward)
    end
    return self.m_tRewardList
end

--@brief    设置任务数据成功
function CellTotalRechargetPanel:setTaskDataTwo(status, target, progress, activityId, rewardConfig)
    self.m_tRewardList = {}
    self.m_tRewardList.m_tDoingList = {}
    self.m_tRewardList.m_tDoneList = {}
    local data = {}
    local nMaxNum = 0 
    if status and next(status) ~= nil then
        for i = 1, #status do
            local tab = {}
            tab.rewardId = i - 1
            tab.status = status[i]
            tab.target = target[i][2]
            tab.curTarget = progress[i]
            tab.tip = ""
            tab.m_tData = {}
            tab.activityId = activityId
           
            tab.m_tData = {}
            local strReward = rewardConfig[i]
            local array = SplitStringWithSeparator(strReward, "&")
            local nSex = CacheCenter:getPlayerInfo().sex
            for k = 1, #array do
                local strTemp = string.sub(array[k], 2, -2) 
                local id = tonumber(SplitStringWithSeparator(strTemp,",")[nSex + 1])
                local num = tonumber(SplitStringWithSeparator(strTemp,",")[3])
                local tTempItem = {id = id, num = num}

                table.insert(tab.m_tData, tTempItem)
            end

            if tab.status == 1 then 
                table.insert(self.m_tRewardList.m_tDoneList, tab)
            else
                table.insert(self.m_tRewardList.m_tDoingList, tab)
            end
            if tab.target > nMaxNum then 
                nMaxNum = tab.target
            end
        end

        self.maxCount = nMaxNum
        table.sort(self.m_tRewardList.m_tDoneList, sortReward)
        table.sort(self.m_tRewardList.m_tDoingList, sortReward)
    end
    return self.m_tRewardList
end

--@brief    任务奖励
function CellTotalRechargetPanel:_onGetTaskResult(activityId, id)
--  WZLog("CellNewYearTask:_onGetTaskResult", self.activityId, activityId, id)
    if self.activityId ~= activityId then
        MsgBoxManager:showTipBox(LocalStrings.RETURNEE_TEXT28)
        return
    end
    
    local taskData = GDatatab_new_activity_task["id_" .. id]
    if self.m_tClickItemCell then 
        local rewardId = self.m_tClickItemCell:getRewardId()
        if rewardId == id then 
            self.m_tClickItemCell:_GetRewardOk()
        end
    end
end

--@brief    任务奖励
function CellTotalRechargetPanel:_onGetTaskResultTwe(activityId, doType, result, jsonData)
--  WZLog("CellNewYearTask:_onGetTaskResultTwe", self.activityId, activityId, id)
    if self.activityId ~= activityId then
        MsgBoxManager:showTipBox(LocalStrings.RETURNEE_TEXT28)
        return
    end
    
    if doType == 2 then --开启结果
        local tResult = json.decode(jsonData)
        WZLog("WndCalabash:_onGetOtherData 333", Serialize(tResult))
        if result == 0 then 
            WndRewardShow:showById(tResult.itemIds, tResult.itemNums)
            self:_onGetTaskResult(activityId, tResult.id)
        end
    end
end

--@brief    设置保存当下领取的任务Cell表
function CellTotalRechargetPanel:setItemCell(tCell)
    self.m_tClickItemCell = tCell 
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellTotalRechargetPanel:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	CellTotalRechargetPanel.m_current = tNewObj
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
