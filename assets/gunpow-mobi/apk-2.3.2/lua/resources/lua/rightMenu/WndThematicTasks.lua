--WndThematicTasks.lua
--@brief	WndThematicTasks的UI模块
--@date		2017/12/08
--@author	yrd
--@note		主题任务


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndThematicTasks:onEnter(element)
	self.m_root = element
	
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndThematicTasks:onExit(element)
	self:_unInit()
end

function WndThematicTasks:update(  )
	self:setTime()
	self:addTasksCell()	
	self.m_root:enableSchedule("scheduleCountdown", 1)
end
	
function WndThematicTasks:scheduleCountdown(element, delta)
	if self.m_refreshTime then
	    self.m_refreshTime = math.max(self.m_refreshTime - 1, 0)
	    if self.m_refreshTime <= 0 then
	    	self.m_root:disableSchedule()
	    	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityTaskList()
		end
	end
end

function WndThematicTasks:setTime(  )
	local startT = os.date("%m.%d",self.m_startTime)
    local endT = os.date("%m.%d",self.m_endTime)
    local actT = LocalStrings.ACTIVITY_TIME_KEY .. ":" .. startT .. "-" .. endT
	GetElement(self.m_root,"txtTime_WndThematicTasks",WZUILabelTTF):setText(actT)
end

function WndThematicTasks:addTasksCell(  )
	local tableTasks = GetElement(self.m_root,"tableTasks_WndThematicTasks",WZUITableContainer)
	tableTasks:cleanTable()
	
	for i = 1, #self.m_tTaskslist do
		local element,tNewObj = CellThematicTasks:createElement()
		element:setTag(i - 1)
		tNewObj:setData(self.m_tTaskslist[i])

		tableTasks:setCellElement(element)

	end
	
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
