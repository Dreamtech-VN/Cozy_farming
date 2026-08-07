--CellMidFestival3.lua
--@brief	CellMidFestival3的UI模块
--@date		2021/08/18
--@author	hyx
--@note		中秋活动1


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellMidFestival3:onEnter(element)
	self.m_root = element
	self:register()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellMidFestival3:onExit(element)
	self:_unInit()
	self:unregister()
end
function CellMidFestival3:register()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetTaskList,self._onGetTaskInfo,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetResult,self._onGetTaskResult,self)
end
function CellMidFestival3:unregister()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetTaskList,self._onGetTaskInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetResult,self._onGetTaskResult,self)
end
function CellMidFestival3:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,false,"actionCallback",self)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_tActivityData.activityId, 1)
end
function CellMidFestival3:actionCallback()
	local txtActivityTime = GetElement(self.m_root,"txtActivityTime",WZUILabelTTF)
	local startTime = SystemTime:getTimeConverLocal(self.m_tActivityData.startTime)
	local endTime = SystemTime:getTimeConverLocal11(self.m_tActivityData.endTime)
	txtActivityTime:setText(startTime.."-"..endTime)
end
function CellMidFestival3:setVisibleStatus(bool)
	bool = bool or false
	if self.m_root then
		self.m_root:setVisible(bool)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellMidFestival3:_onGetTaskInfo(activityId, activityType, taskType, id, status, target, progress, progressCount, refreshTime)
	if self.m_tActivityData.activityId == activityId then
		self.m_tMidfestivalTaskData = WndDollMachineTask:setTaskData(id, status, target, progress)
		WndDollMachineTask:taskTableSort(self.m_tMidfestivalTaskData)
		local taskFreeList = GetElement(self.m_root,"taskFreeList",WZUIFreeListContainer)
		taskFreeList:removeAll()
		for i = 1, #self.m_tMidfestivalTaskData do
			local element, tLuaObj = MidFestivalTaskItem:createElement()
			self.m_tMidFestivalTaskItem[i] = tLuaObj
			taskFreeList:pushBack(WZUIContainer:luaTo(element))
			taskFreeList:getMoveElement():setPositionY(taskFreeList:getMinPosition().y)
			tLuaObj:setTaskData(i,self.m_tMidfestivalTaskData[i], activityId)
		end
	end
end
function CellMidFestival3:_onGetTaskResult(activityId, taskId)
	if self.m_tActivityData.activityId == activityId then
		for i,v in pairs(self.m_tMidfestivalTaskData) do
			if v and v.id == taskId then
				v.status = 1
				break
			end
		end
		WndDollMachineTask:taskTableSort(self.m_tMidfestivalTaskData)
		for i,v in ipairs(self.m_tMidFestivalTaskItem) do
			if v then
				v:setTaskItemMessage(i, self.m_tMidfestivalTaskData[i])
			end
		end
		--红点
		local status = false
		for i,v in pairs(self.m_tMidfestivalTaskData) do
			if v.status == 0 then
				status = true
				break
			end
		end
		WndMidFestivalActivity:setVisibleTitleRedPoint(status)
	end
end


-------------------------------------私有方法模块End----------------------------------------
