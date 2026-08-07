--WndThematicTasksData.lua
--@brief	WndThematicTasks的数据模块
--@date		2017/12/08
--@author	yrd
--@note		主题任务

WndThematicTasks = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndThematicTasks:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_startTime = nil
	self.m_endTime = nil
	self.m_tTaskslist = {}
	self.m_refreshTime = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndThematicTasks:_unInit()
	self.m_root = nil
	self.m_startTime = nil
	self.m_endTime = nil
	self.tablelist = nil
	self.m_refreshTime = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndThematicTasks:createElement()
	if WndThematicTasks.m_root ~= nil then
		WindowManager:removeWindow(WndThematicTasks.m_root, WndThematicTasks, true)
	end
	local element = WZUISystem:getInstance():createElement("WndThematicTasks")
	assert(element, "WndThematicTasks create element failed!")
	self:_init()
	return element
end

--@brief 	设置活动数据
function WndThematicTasks:getActivityTaskListOk( id, status, target, complete, refreshTime )
	-- body
	WZLog("WndThematicTasks:getActivityTaskListOk",Serialize(id),Serialize(status),Serialize(target),Serialize(complete),refreshTime)

	self.m_tTaskslist = {}
	local temptasksList0 = {}
	local temptasksList1 = {}
	local temptasksList2 = {}
	for i = 1, #id do
		local itemData = {}
		itemData.id = id[i] 
		itemData.status = status[i] 
		itemData.target = target[i] 
		itemData.complete = complete[i] 

		if itemData.status == 0 then
			table.insert(temptasksList0,itemData)
		elseif itemData.status == 1 then
			table.insert(temptasksList1,itemData)
		elseif itemData.status == 2 then
			table.insert(temptasksList2,itemData)
		end

	end

	table.sort( temptasksList0, _sortTask )
	table.sort( temptasksList1, _sortTask )
	table.sort( temptasksList2, _sortTask )


	for i = 1, #temptasksList1 do
		table.insert( self.m_tTaskslist, temptasksList1[i])
	end
	for i = 1, #temptasksList0 do
		table.insert( self.m_tTaskslist, temptasksList0[i])
	end
	for i = 1, #temptasksList2 do
		table.insert( self.m_tTaskslist, temptasksList2[i])
	end
	self.m_refreshTime = refreshTime
	self:update()
end

function _sortTask( a, b )
	local taskTypeA = GDatatab_activity_task["id_"..a.id].type
	local taskTypeB = GDatatab_activity_task["id_"..b.id].type
	if taskTypeA == taskTypeB then
		return a.id < b.id
	else
		return taskTypeA < taskTypeB
	end
end

function WndThematicTasks:setData(tActivityData)
	self.m_startTime = tActivityData.startTime
	self.m_endTime = tActivityData.endTime
	
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------




-------------------------------------私有方法模块End----------------------------------------
