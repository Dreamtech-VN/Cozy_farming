--CellNewYearChange.lua
--@brief	CellNewYearChange的UI模块
--@date		2020/12/24
--@author	hyx
--@note		新年充值


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellNewYearChange:onEnter(element)
	self.m_root = element
	self:register()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellNewYearChange:onExit(element)
	self:unregister()
	self:_unInit()
end

function CellNewYearChange:register()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetTaskList,self._onGetChargeInfo,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetResult,self._onGetChargeResult,self)
end
function CellNewYearChange:unregister()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetTaskList,self._onGetChargeInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetResult,self._onGetChargeResult,self)
end

function CellNewYearChange:onEnterTransitionDidFinish(element)
	self.m_sChargeFreeList = GetElement(self.m_root,"ChargeFreeList",WZUIFreeListContainer)
end


function CellNewYearChange:setVisibleStatus(bool)
	bool = bool or false
	if self.m_root then
		if bool == true then
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, 1)
		end
		self.m_root:setVisible(bool)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellNewYearChange:_onGetChargeInfo(activityId, activityType, taskType, id, status, target, progress, progressCount, refreshTime)
	if self.m_nActivityId == activityId then
		if self.m_sChargeFreeList then
			local data = self:setTaskItemData(activityId, taskType, id, status, target, progress, progressCount)
			self.m_sChargeFreeList:removeAll()
			if next(data) == nil then
				ShowPanelNullTip( self.m_sChargeFreeList, LocalStrings.CHARM_RESULT)
				return
			end
			for i = 1, #data do
				local element, tLuaObj = CellChargeItem:createElement()
				self.m_sChargeFreeList:pushBack(WZUIContainer:luaTo(element))
				self.m_sChargeFreeList:getMoveElement():setPositionY(self.m_sChargeFreeList:getMinPosition().y)
				tLuaObj:setChargeMessage(i, data[i])
			end
		end
	end
end

function CellNewYearChange:_onGetChargeResult(activityId,taskId)
	if self.m_nActivityId == activityId then
		if self.m_sChargeFreeList then
			self.m_sChargeFreeList:removeAll()
			self:updateTaskData(taskId)
			for i = 1, #self.m_tChargeTaskData do
				local element, tLuaObj = CellChargeItem:createElement()
				self.m_sChargeFreeList:pushBack(WZUIContainer:luaTo(element))
				self.m_sChargeFreeList:getMoveElement():setPositionY(self.m_sChargeFreeList:getMinPosition().y)
				tLuaObj:setChargeMessage(i, self.m_tChargeTaskData[i])
			end
		end
	end
end


-------------------------------------私有方法模块End----------------------------------------
