--WndFactionTaskData.lua
--@brief	WndFactionTask的数据模块
--@date		2023/05/29
--@author	yrd
--@note		宗门任务

WndFactionTask = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndFactionTask:_init()
	self.m_root = nil	 	  			--场景根节点

	self.m_tTaskList1 = nil 			--我的宗门任务数据
	self.m_tCellTaskObj1 = nil 			--我的宗门任务对象
	self.m_nCheckIndex1 = 0 			--当前选中哪一天 0:今天 1:明天 2:后天
	self.m_nTaskDayNum1 = 0 			--已发布任务天数
	self.m_nLastDayIndex1 = 2 			--最后一天下标
	self.m_tDayElementList1 = {} 		--存放"第几天"按钮element
	self.m_tLockIdList1 = {} 			--上锁的任务id列表

	self.m_tTaskList2 = nil 			--师傅的宗门任务数据
	self.m_tCellTaskObj2 = nil 			--我的宗门任务对象
	self.m_nCheckIndex2 = 0 			--当前选中哪一天 0:今天 1:明天 2:后天
	self.m_nTaskDayNum2 = 0 			--已发布任务天数
	self.m_nLastDayIndex2 = 2 			--最后一天下标
	self.m_tDayElementList2 = {} 		--存放"第几天"按钮element
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndFactionTask:_unInit()
	self.m_root = nil

	self.m_tTaskList1 = nil
	self.m_tCellTaskObj1 = nil
	self.m_nCheckIndex1 = nil
	self.m_nTaskDayNum1 = nil
	self.m_nLastDayIndex1 = nil
	self.m_tDayElementList1 = nil
	self.m_tLockIdList1 = nil

	self.m_tTaskList2 = nil
	self.m_tCellTaskObj2 = nil
	self.m_nCheckIndex2 = nil
	self.m_nTaskDayNum2 = nil
	self.m_nLastDayIndex2 = nil
	self.m_tDayElementList2 = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndFactionTask:createElement()
	if WndFactionTask.m_root ~= nil then
		WindowManager:removeWindow(WndFactionTask.m_root, WndFactionTask, true)
	end
	local element = WZUISystem:getInstance():createElement("WndFactionTask")
	assert(element, "WndFactionTask create element failed!")
	self:_init()
	return element
end

--@brief	获取宗门任务列表OK
function WndFactionTask:getZmTaskListOk(taskIds, taskTarget, taskProgress, taskType)
	if not self.m_root then return end

	self.m_tTaskList1 = {}
	for i=1,#taskIds do
		local tItme = {}
		tItme.taskId = taskIds[i]
		tItme.taskTarget = taskTarget[i]
		tItme.taskProgress = taskProgress[i]
		tItme.taskType = taskType[i]
		table.insert(self.m_tTaskList1,tItme)
	end
	table.sort( self.m_tTaskList1, function(a,b)
		if a.taskType ~= b.taskType then
			return a.taskType < b.taskType
		else
			return a.taskId < b.taskId
		end
	end )

	local tTempType = {}
	local bIsExistNoSet = false 
	for i = 1, #taskType do
		local bIsExist = false
		if taskType[i] == -1 then bIsExistNoSet = true end
		for j = 1, #tTempType do
			if tTempType[j] == taskType[i] then 
				bIsExist = true
				break
			end
		end
		if not bIsExist then 
			table.insert(tTempType, taskType[i])
		end
	end
	if bIsExistNoSet then
		self.m_nTaskDayNum1 = #tTempType - 1
	else
		self.m_nTaskDayNum1 = #tTempType
	end

	self:updateUI1()
end

--@brief	获取我的师门任务列表OK
function WndFactionTask:getShifuZmTaskListOk(taskIds, taskTarget, taskProgress, taskType)
	if not self.m_root then return end

	self.m_tTaskList2 = {}
	for i=1,#taskIds do
		local tItme = {}
		tItme.taskId = taskIds[i]
		tItme.taskTarget = taskTarget[i]
		tItme.taskProgress = taskProgress[i]
		tItme.taskType = taskType[i]
		table.insert(self.m_tTaskList2,tItme)
	end
	table.sort( self.m_tTaskList2, function(a,b)
		if a.taskType ~= b.taskType then
			return a.taskType < b.taskType
		else
			return a.taskId < b.taskId
		end
	end )

	local tTempType = {}
	local bIsExistNoSet = false 
	for i = 1, #taskType do
		local bIsExist = false
		if taskType[i] == -1 then bIsExistNoSet = true end
		for j = 1, #tTempType do
			if tTempType[j] == taskType[i] then 
				bIsExist = true
				break
			end
		end
		if not bIsExist then 
			table.insert(tTempType, taskType[i])
		end
	end
	if bIsExistNoSet then
		self.m_nTaskDayNum2 = #tTempType - 1
	else
		self.m_nTaskDayNum2 = #tTempType
	end

	self:updateUI2()
end

--@brief	获取刷新消耗
function WndFactionTask:getFlushCost(num)
    local mentoringZmTask = json.decode(CacheCenter:getGameParam().mentoringZmTask)
	local array = SplitStringWithSeparator(mentoringZmTask.flushTaskCost,"&")
	for i=1,#array do
		local str = string.sub(array[i],2,-2) 
		local tData = SplitStringWithSeparator(str,",",nil,true)
		if num == tData[1] then
			return {{tData[2],tData[3]}}
		end
	end
end

--@brief	刷新宗门任务OK
function WndFactionTask:getFlushZmTaskOk(result, myZmTaskIds, myZmTaskTarget)
	if not self.m_root then return end

	if result == 0 then
		for i=#self.m_tTaskList1,1,-1 do
			if self.m_nCheckIndex1 == self.m_nTaskDayNum1 and self.m_tTaskList1[i].taskType == -1 then
				table.remove(self.m_tTaskList1,i)
			end
		end
		for i=1,#myZmTaskIds do
			local tItme = {}
			tItme.taskId = myZmTaskIds[i]
			tItme.taskTarget = myZmTaskTarget[i]
			tItme.taskProgress = 0
			tItme.taskType = -1
			table.insert(self.m_tTaskList1,tItme)
		end
		table.sort( self.m_tTaskList1, function(a,b)
			if self:isLockTaskId(a.taskId) == true and self:isLockTaskId(b.taskId) == false then
				return true
			elseif self:isLockTaskId(a.taskId) == false and self:isLockTaskId(b.taskId) == true then
				return false
			else
				return a.taskId < b.taskId
			end
		end )
		
		self:updateUI1()
	elseif result == 1 then
		MsgBoxManager:showTipBox(LocalStrings.OPERATION_ERROR)
	elseif result == 2 then
		MsgBoxManager:showTipBox(LocalStrings.SEND_PROPOSAL_LETTER2)
	elseif result == 3 then
		MsgBoxManager:showTipBox(LocalStrings.FACTION_TEXT1[17])
	end
end

--@brief	发布宗门任务OK
function WndFactionTask:PublishZmTaskOk(result)
	if result == 0 then
		MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO122)
		self.m_tLockIdList1 = {}
	elseif result == 1 then
		MsgBoxManager:showTipBox(LocalStrings.FACTION_TEXT1[18])
	elseif result == 0 then
		MsgBoxManager:showTipBox(LocalStrings.FACTION_TEXT1[19])
	end
end

--@brief	是否是锁定任务
function WndFactionTask:isLockTaskId(nId)
	for i=1,#self.m_tLockIdList1 do
		if self.m_tLockIdList1[i] == nId then
			return true
		end
	end
	return false
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------




-------------------------------------任务子项begin----------------------------------------

CellFactionTask = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellFactionTask:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil
	self.m_bLocked = nil 		--任务是否加锁
	self.m_nType = nil 			--类型 1:我的宗门任务 2:师傅宗门任务
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellFactionTask:_unInit()
	self.m_root = nil
	self.m_tData = nil
	self.m_bLocked = nil
	self.m_nType = nil
end

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellFactionTask:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellFactionTask table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellFactionTask")
	assert(element, "CellFactionTask element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellFactionTask:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--@brief	设置数据
function CellFactionTask:setData(tData,nType)
	self.m_tData = tData
	self.m_nType = nType
	self:updateUI()

	AdaptLanguage(self)
end

--@brief 	设置加锁回调
function CellFactionTask:setLockCallBack(tCell, func)
	self.m_tLockCallBack = {}
	self.m_tLockCallBack[1] = tCell
	self.m_tLockCallBack[2] = func
end

--@brief	更新界面
function CellFactionTask:updateUI()
	GetElement(self.m_root,"txtTaskWord1_CellFactionTask",WZUILabelTTF):setText(LocalStrings.FACTION_TEXT1[1])
	GetElement(self.m_root,"txtTaskWord2_CellFactionTask",WZUILabelTTF):setText(LocalStrings.APPRENTICE)

	local tTaskInfo = GDatatab_mentoring_zm_task["id_"..self.m_tData.taskId]

	local txtCellTaskState = GetElement(self.m_root,"txtCellTaskState_WndFactionTask",WZUILabelTTF)
	if self.m_tData.taskType == -1 then
		txtCellTaskState:setText("["..LocalStrings.COMMUNITYINFO121.."]")
		txtCellTaskState:setColor(GlobalMethod:ccc3(255,255,255))
	else
		if self.m_tData.taskProgress < self.m_tData.taskTarget then
			txtCellTaskState:setText("["..LocalStrings.TASK_DOING.."]")
			txtCellTaskState:setColor(GlobalMethod:ccc3(255,255,255))
		else
			txtCellTaskState:setText("["..LocalStrings.ACTIVE_FINISH.."]")
			txtCellTaskState:setColor(GlobalMethod:ccc3(99,255,95))
		end
	end

	local txtCellTaskTitle = GetElement(self.m_root,"txtCellTaskTitle_WndFactionTask",WZUILabelTTF)
	txtCellTaskTitle:setText(tTaskInfo.name)

	for i=1,5 do
		local star = GetElement(self.m_root,"star"..i,WZUIImage)
		star:setVisible(false)
		if tTaskInfo.star >= i then
			star:setVisible(true)
		end
	end

	local txtTaskDesc = GetElement(self.m_root,"txtTaskDesc_CellFactionTask",WZUILabelTTF)
	txtTaskDesc:setText(tTaskInfo.desc.."("..self.m_tData.taskProgress.."/"..self.m_tData.taskTarget..")")

	for i=1,#tTaskInfo.reward_shifu do
		local tItemInfo = GDatatab_item["id_"..tTaskInfo.reward_shifu[i][1]]
		local imgTaskReward = GetElement(self.m_root,"imgTaskReward1T"..i.."_CellFactionTask",WZUIImage)
		imgTaskReward:setFile(tItemInfo.icon)
		local txtTaskReward = GetElement(self.m_root,"txtTaskReward1T"..i.."_CellFactionTask",WZUILabelTTF)
		txtTaskReward:setText(tTaskInfo.reward_shifu[i][2])
	end
	for i=1,#tTaskInfo.reward_tudi do
		local tItemInfo = GDatatab_item["id_"..tTaskInfo.reward_tudi[i][1]]
		local imgTaskReward = GetElement(self.m_root,"imgTaskReward2T"..i.."_CellFactionTask",WZUIImage)
		imgTaskReward:setFile(tItemInfo.icon)
		local txtTaskReward = GetElement(self.m_root,"txtTaskReward2T"..i.."_CellFactionTask",WZUILabelTTF)
		txtTaskReward:setText(tTaskInfo.reward_tudi[i][2])
	end

	local conTaskLock = GetElement(self.m_root,"conTaskLock_CellFactionTask",WZUIContainer)
	conTaskLock:setVisible(false)
	if self.m_nType == 1 and WndFactionTask.m_nCheckIndex1 == WndFactionTask.m_nTaskDayNum1 then
		conTaskLock:setVisible(true)
	end

	for i=1,#WndFactionTask.m_tLockIdList1 do
		if WndFactionTask.m_tLockIdList1[i] == self.m_tData.taskId then
			self:setLockStatue(true)
		end
	end
end

--@brief	设置加锁状态
function CellFactionTask:setLockStatue(bLock)
	self.m_bLocked = bLock
	local checkTaskLock = GetElement(self.m_root,"checkTaskLock_CellFactionTask",WZUICheckBox)
	if bLock == true then
		checkTaskLock:setCheckIndex(1)
	else
		checkTaskLock:setCheckIndex(0)
	end
end

--@brief	点击加锁按钮回调
function CellFactionTask:onClickLock(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nCheckIndex = WZUICheckBox:luaTo(element):getCheckIndex()
	if nCheckIndex == 0 then
		self.m_bLocked = false
		MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO124)
	else
		self.m_bLocked = true
		MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO123)
	end

    if self.m_tLockCallBack then
        self.m_tLockCallBack[2](self.m_tLockCallBack[1], self)
    end	
end

-------------------------------------任务子项end----------------------------------------


--@brief	设置加锁状态
function CellFactionTask:_adaptLanguage_vn()
	GetElement(self.m_root,"txtTaskWord1_CellFactionTask",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txtTaskWord2_CellFactionTask",WZUILabelTTF):setScale(0.6)
end