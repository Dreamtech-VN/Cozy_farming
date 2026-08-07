

CellCommonPanel = {
	-- 请在这里定义和初始化全局成员变量
}
function CellCommonPanel:_init()
	self.m_root = nil
	self.m_nStartTime = 0
    self.m_nEndTime = 0
    self.m_nCommonActivityType = nil
    self.m_tCellCommonData = {}
    self.m_bIsCharge = nil --是否充值过
    self.m_nActivityId = nil 
end
function CellCommonPanel:_unInit()
	self.m_root = nil
	self.m_nStartTime = nil
    self.m_nEndTime = nil
    self.m_nCommonActivityType = nil
    self.m_tCellCommonData = nil
    self.m_bIsCharge = nil
    self.m_nActivityId = nil 
end

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellCommonPanel:createElement(activityId, activityType)
	local tNewObj = self:_new()
	assert(tNewObj, "CellCommonPanel table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellTotalRechargetPanel")
	assert(element, "CellCommonPanel element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self.m_nCommonActivityType = activityType
	return element,tNewObj
end

--@brief 	获取射箭任务列表
function CellCommonPanel:_onGetTaskInfo(activityId, activityType, taskType, id, status, target, progress, progressCount, refreshTime)
	if activityId == self.m_nActivityId then 
		local tab = self:setTaskData(id, status, target, progress, activityId)
		self.m_tCellCommonData = tab

		self:showList()
	end
end

--@brief 	设置任务数据成功
function CellCommonPanel:setTaskData(id, status, target, progress, activityId)
	local data = {}
	if id and next(id) ~= nil then
		for i = 1, #id do
			local tab = {}
			tab.reward_id = id[i]
			tab.status = status[i]
			tab.target = target[i]
			tab.progress = progress[i]
			tab.desc = ""
			tab.reward = {}
			tab.activityId = activityId
			tab.activityType = self.m_nCommonActivityType
			local config = GDatatab_new_activity_task["id_"..id[i]]
			if config then
				tab.desc = string.format(config.desc, tab.progress .. "/" .. tab.target)
				tab.reward = config.reward
			end
			tab.id = {}
			tab.num = {}
			for i = 1, #tab.reward do
				table.insert(tab.id, tab.reward[i][1])
				table.insert(tab.num, tab.reward[i][2])
			end

			data[i] = tab
		end
	end
	return data
end

--@brief 	领取任务奖励成功
function CellCommonPanel:_onGetTaskResult(activityId, taskId)
	if activityId == self.m_nActivityId then 
		if self.m_tCellCommonData then
			for i,v in pairs(self.m_tCellCommonData) do
				if taskId == v.reward_id then
					v.status = 1
					break
				end
			end
			
			self:showList()
		end
	end
end

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellCommonPanel:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end