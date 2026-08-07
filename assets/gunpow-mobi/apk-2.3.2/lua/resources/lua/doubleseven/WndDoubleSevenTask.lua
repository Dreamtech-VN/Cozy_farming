--WndDoubleSevenTask.lua
--@brief	WndDoubleSevenTask的UI模块
--@date		2020/08/03
--@author	hyx
--@note		告白任务


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndDoubleSevenTask:onEnter(element)
	self.m_root = element
	self:register()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndDoubleSevenTask:onExit(element)
	self:_unInit()
	self:unregister()
end
function WndDoubleSevenTask:register()
	GlobalGame:getGameEventDispathcer():Add(WndDoubleSevenEvent.WndDoubleSevenEvent_ConfreeTask,self._onDoubleSevenTaskList,self)
	GlobalGame:getGameEventDispathcer():Add(WndDoubleSevenEvent.WndDoubleSevenEvent_GetTaskResult,self._onDoubleSevenGetTaskResult,self)
end
function WndDoubleSevenTask:unregister()
	GlobalGame:getGameEventDispathcer():Remove(WndDoubleSevenEvent.WndDoubleSevenEvent_ConfreeTask,self._onDoubleSevenTaskList,self)
	GlobalGame:getGameEventDispathcer():Remove(WndDoubleSevenEvent.WndDoubleSevenEvent_GetTaskResult,self._onDoubleSevenGetTaskResult,self)
end
function WndDoubleSevenTask:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndDoubleSevenTask:actionCallback()
	self:initShow()
	ProtocolProcessorNewActivity:send_ACTIVITY2_QiXiTaskList( )
end
function WndDoubleSevenTask:initShow()
	GetElement(self.m_root, "title_name", WZUILabelTTF):setText(LocalStrings.DOUBLE_SEVEN_TEXT3)
	self.taskFreeListContainer = GetElement(self.m_root, "taskFreeListContainer", WZUIFreeListContainer)
	self.taskFreeListContainer:removeAll()
end
function WndDoubleSevenTask:onClickClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
--解析服务端传过来的物品奖励
function WndDoubleSevenTask:setServerItem(rewardNum, ItemId, itemNum)
	local ids,nums = {},{}
	local table_insert = table.insert
	local ids = {}
	local nums = {}
	local index = 1
	for i=1,#rewardNum do
		ids[i] = {}
		nums[i] = {}
		for id=1, rewardNum[i] do
			table_insert(ids[i], ItemId[index])
			table_insert(nums[i], itemNum[index])
			index = index + 1
		end
	end
	return ids, nums
end
function WndDoubleSevenTask:setTaskList(taskId, target, progress, status, rewardNum, ItemId, itemNum)
	if not taskId or next(taskId) == nil then return end

	local str = LocalStrings.DOUBLE_SEVEN_TEXT18
	local ids, nums = self:setServerItem(rewardNum, ItemId, itemNum)
	local tDate = {}
	for i=1,#taskId do
		local tab = {}
		tab.desc = str[i]
		tab.taskId = taskId[i]
		tab.target = target[i]
		tab.progress = progress[i]
		tab.status = status[i]
		tab.item_ids = ids[i]
		tab.item_nums = nums[i]
		tDate[i] = tab
	end
	self:taskSort(tDate)
	self.taskObjItem = {}
	self.m_tTaskDate = tDate
	for i = 1, #taskId do
        local element, tLuaObj = CellDoubleSevenTaskItem:createElement()
        self.taskFreeListContainer:pushBack(WZUIContainer:luaTo(element))
        self.taskFreeListContainer:getMoveElement():setPositionY(self.taskFreeListContainer:getMinPosition().y)
        tLuaObj:setTaskMessageInit(i,tDate[i])
        self.taskObjItem[i] = tLuaObj

        tLuaObj:setFunCallTaskItem(function(task_id)
        	ProtocolProcessorNewActivity:send_ACTIVITY2_QiXiGetTaskReward(tonumber(task_id))
    	end)
    end
end

function WndDoubleSevenTask:setGetTaskResult(result, taskId)
	if not self.m_tTaskDate then return end
	local tRewardId = {}
	local tRewardNum = {}
	for i,v in pairs(self.m_tTaskDate) do
		if v.taskId == taskId then
			v.status = 2
			tRewardId = v.item_ids
			tRewardNum = v.item_nums
			break
		end
	end
	WndRewardShow:showById(tRewardId, tRewardNum)
	self:taskSort(self.m_tTaskDate)
	for i,v in ipairs(self.m_tTaskDate) do
		if self.taskObjItem[i] then
			self.taskObjItem[i]:upTaskDateItem(i, self.m_tTaskDate[i])
		end
	end
end
--排序
function WndDoubleSevenTask:taskSort(data_sort)
	local temp = {
		[0] = 2, --未领取
		[1] = 1, --可领取
		[2] = 3, --已领取
	}
	local function testFunc(a,b)
		if a.status ~= b.status then
			if temp[a.status] and temp[b.status] then
				return temp[a.status] < temp[b.status]
			else
				return false
			end
		else
			return a.taskId < b.taskId
		end
	end
	table.sort(data_sort, testFunc)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function WndDoubleSevenTask:_onDoubleSevenTaskList(taskId, target, progress, status, rewardNum, ItemId, itemNum)
	self:setTaskList(taskId, target, progress, status, rewardNum, ItemId, itemNum)
end
function WndDoubleSevenTask:_onDoubleSevenGetTaskResult(result, taskId)
	self:setGetTaskResult(result, taskId)
end
-------------------------------------私有方法模块End----------------------------------------
