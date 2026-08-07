--WndFightTask2.lua
--@brief	WndFightTask2的UI模块
--@date		2021/06/21
--@author	hyx
--@note		战力任务


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFightTask2:onEnter(element)
	self.m_root = element
	self:register()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFightTask2:onExit(element)
	self:_unInit()
	self:unregister()
end
function WndFightTask2:showInterface()
	local wndTask = WndFightTask2:createElement()
	if wndTask ~= nil then
	    WindowManager:addWindow(wndTask,WndFightTask2,nil,false)
	end
end

function WndFightTask2:register()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetTaskList,self._onGetTaskInfo,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetResult,self._onGetTaskResult,self)
end
function WndFightTask2:unregister()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetTaskList,self._onGetTaskInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetResult,self._onGetTaskResult,self)
end
function WndFightTask2:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndFightTask2:actionCallback()
	for i=1,2 do
		local tab = {}
		local btn = GetElement(self.m_root,"btn"..i,WZUIButton)
		tab.normal = GetElement(btn,"normal",WZUI9Image)
		tab.select = GetElement(btn,"select",WZUI9Image)
		tab.name = GetElement(btn,"name",WZUILabelTTF)
		self.m_tTaskTitle[i] = tab
	end
	self.m_nCurIndex = 1
	self.m_tTaskTitle[self.m_nCurIndex].select:setVisible(true)
	self.m_tTaskTitle[self.m_nCurIndex].normal:setVisible(false)
	self.m_tTaskTitle[self.m_nCurIndex].name:setColor(GlobalMethod:ccc3(255,236,193))
	self.m_tTaskTitle[self.m_nCurIndex].name:setEnableStroke(true)
	self.m_tTaskTitle[self.m_nCurIndex].name:setStrokeSize(4)
	self.m_tTaskTitle[self.m_nCurIndex].name:setStrokeColor(GlobalMethod:ccc3(132,66,29))

	ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(g_cityExtenInfo.activity7201, 2)
	self:setDayRedPoint(GlobalGame.g_tRedPointTypeList[127201])
	self:setGroupRedPoint(GlobalGame.g_tRedPointTypeList[117201])
end

function WndFightTask2:onBtnChangeTitle(element)
	local tag = element:getTag()

	if self.m_tTaskTitle[self.m_nCurIndex] then
		self.m_tTaskTitle[self.m_nCurIndex].select:setVisible(false)
		self.m_tTaskTitle[self.m_nCurIndex].normal:setVisible(true)
		self.m_tTaskTitle[self.m_nCurIndex].name:setEnableStroke(false)
		self.m_tTaskTitle[self.m_nCurIndex].name:setColor(GlobalMethod:ccc3(127,70,26))
	end

	if self.m_tTaskTitle[tag] then
		self.m_tTaskTitle[tag].select:setVisible(true)
		self.m_tTaskTitle[tag].normal:setVisible(false)
		self.m_tTaskTitle[tag].name:setColor(GlobalMethod:ccc3(255,236,193))
		self.m_tTaskTitle[tag].name:setEnableStroke(true)
		self.m_tTaskTitle[tag].name:setStrokeSize(4)
		self.m_tTaskTitle[tag].name:setStrokeColor(GlobalMethod:ccc3(132,66,29))
	end

	GetElement(self.m_root,"fightTaskFreeList1",WZUIFreeListContainer):setVisible(tag == 1)
	GetElement(self.m_root,"fightTaskFreeList2",WZUIFreeListContainer):setVisible(tag == 2)

	if tag == 2 and self.m_tTaskTypeData[2] == nil then
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(g_cityExtenInfo.activity7201, 1)
	end
	self.m_nCurIndex = tag
end
function WndFightTask2:setDayRedPoint(visible)
	visible = visible or false
	if not self.m_root then return end
	GetElement(self.m_root,"dayRedPoint",WZUIImage):setVisible(visible)
end
function WndFightTask2:setGroupRedPoint(visible)
	visible = visible or false
	if not self.m_root then return end
	GetElement(self.m_root,"groupRedPoint",WZUIImage):setVisible(visible)
end
function WndFightTask2:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndFightTask2:_onGetTaskInfo(activityId, activityType, taskType, id, status, target, progress, progressCount, refreshTime)
	if activityId == tonumber(g_cityExtenInfo.activity7201) then
		local temp_tag = {2,1}
		taskType = temp_tag[taskType]
		if self.m_tTaskTypeData[taskType] == nil then
			self.m_tTaskTypeData[taskType] = {}
			self.m_tCellFightTaskItem[taskType] = {}
		end
		self.m_tTaskTypeData[taskType] = WndDollMachineTask:setTaskData(id, status, target, progress)
		WndDollMachineTask:taskTableSort(self.m_tTaskTypeData[taskType])
		local fightTaskFreeList = GetElement(self.m_root,"fightTaskFreeList"..taskType,WZUIFreeListContainer)
		fightTaskFreeList:removeAll()
		fightTaskFreeList:setVisible(true)
		for i = 1, #self.m_tTaskTypeData[taskType] do
			local element, tLuaObj = CellFightTaskItem2:createElement()
			table.insert(self.m_tCellFightTaskItem[taskType], tLuaObj)
			fightTaskFreeList:pushBack(WZUIContainer:luaTo(element))
			fightTaskFreeList:getMoveElement():setPositionY(fightTaskFreeList:getMinPosition().y)
			tLuaObj:setFightTaskData(i, self.m_tTaskTypeData[taskType][i])
		end
	end
end
function WndFightTask2:_onGetTaskResult(activityId, taskId)
	if tonumber(g_cityExtenInfo.activity7201) == activityId then
		local _type = nil
		for i=1,2 do
			if self.m_tTaskTypeData[i] then
				for m=1, #self.m_tTaskTypeData[i] do
					if self.m_tTaskTypeData[i][m].id == taskId then
						_type = i
						break
					end
				end
			end
		end
		if _type and self.m_tCellFightTaskItem[_type] then
			for i,v in pairs(self.m_tTaskTypeData[_type]) do
				if v and v.id == taskId then
					v.status = 1
					break
				end
			end
			WndDollMachineTask:taskTableSort(self.m_tTaskTypeData[_type])
			for i,v in ipairs(self.m_tCellFightTaskItem[_type]) do
				if v then
					v:setFightTaskItemData(i, self.m_tTaskTypeData[_type][i])
				end
			end
			local _status = false
			for i,v in pairs(self.m_tTaskTypeData[_type]) do
				if v.status == 0 then
					_status = true
					break
				end
			end
			if _type == 1 then
				GlobalGame.g_tRedPointTypeList[127201] = _status
			elseif _type == 2 then
				GlobalGame.g_tRedPointTypeList[117201] = _status
			end
			self:setDayRedPoint(GlobalGame.g_tRedPointTypeList[127201])
			self:setGroupRedPoint(GlobalGame.g_tRedPointTypeList[117201])
			WndFightActivity:setFightTaskPoint(GlobalGame.g_tRedPointTypeList[127201] or GlobalGame.g_tRedPointTypeList[117201])
			SceneCity:setSceneMainIconRedPoint(FIGHT_ACTIVITY, GlobalGame.g_tRedPointTypeList[127201] or GlobalGame.g_tRedPointTypeList[117201])
		end
	end
end

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配begin----------------------------------------
function WndFightTask2:_adaptLanguage_vn()
	local btn1 = GetElement(self.m_root,"btn1",WZUIButton)
	local name = GetElement(btn1,"name",WZUILabelTTF)
	name:setScale(0.8)
	name:setDimensions(GlobalMethod:CCSize(140,0))
	local btn2 = GetElement(self.m_root,"btn2",WZUIButton)
	local name = GetElement(btn2,"name",WZUILabelTTF)
	name:setScale(0.8)
	name:setDimensions(GlobalMethod:CCSize(140,0))
end
-------------------------------------语言适配end----------------------------------------
