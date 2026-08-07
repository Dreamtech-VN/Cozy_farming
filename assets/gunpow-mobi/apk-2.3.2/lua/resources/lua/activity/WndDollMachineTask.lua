--WndDollMachineTask.lua
--@brief	WndDollMachineTask的UI模块
--@date		2021/04/29
--@author	hyx
--@note		娃娃机任务


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndDollMachineTask:onEnter(element)
	self.m_root = element
	self:register()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndDollMachineTask:onExit(element)
	self:unregister()
	self:_unInit()
end
-- activityType  默认是娃娃机类型   1:占卜 2:钓鱼 3:弹珠 4:房产
--extraInfo；扩展参数 table类型
function WndDollMachineTask:showInterface(activityId, index, activityType, extraInfo)
	local wndTask = WndDollMachineTask:createElement()
	if wndTask ~= nil then
	    WindowManager:addWindow(wndTask,WndDollMachineTask,nil,false)
	end
	self.m_nActivityId = tonumber(activityId)
	self.m_nCurTaskIndex = index or 1
	self.m_nActivityType = activityType or 0
	extraInfo = extraInfo or {}
	--是否显示切换按钮
	if extraInfo.isBtnChange == false then
		self.m_bIsChangeBtn = extraInfo.isBtnChange
	end
end

function WndDollMachineTask:register()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetTaskList,self._onGetTaskInfo,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetResult,self._onGetTaskResult,self)
end
function WndDollMachineTask:unregister()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetTaskList,self._onGetTaskInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetResult,self._onGetTaskResult,self)
end

function WndDollMachineTask:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndDollMachineTask:actionCallback()
	if self.m_nActivityId then
		--任务类型 1成长任务 2日常任务
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, 2)
	end
	self:initShow()
end
function WndDollMachineTask:initShow()
	local img_bg = GetElement(self.m_root,"img_bg",WZUI9Image) --底图
	local txtTitleName = GetElement(self.m_root,"txtTitleName",WZUILabelTTF) --标题
	local btnImgClose = GetElement(self.m_root,"btnImgClose",WZUIImage) --关闭按钮资源
	btnImgClose:setFile("ui/common/common_top_btn_guanbi.png")
	img_bg:setFile("ui/common/frame_tc_xiao_zi.png")
	if self.m_nActivityType == 1 or self.m_nActivityType == 2 or self.m_nActivityType == 3 or self.m_nActivityType == 4 then
		img_bg:setFile("ui/common/frame_tc_xiao.png")
	end
	local str_name = {LocalStrings.ACTIVITY_TEXT4, LocalStrings.ACTIVITY_TEXT95, LocalStrings.ACTIVITY_TEXT116, LocalStrings.ACTIVITY_TEXT151, LocalStrings.ACTIVITY_TEXT180}
	txtTitleName:setText(str_name[self.m_nActivityType+1])
	if self.m_nActivityType == 0 then
		self:setTask1Redpoint(0)
		self:setTask2Redpoint(0)
	else
		self:setTask1Redpoint(self.m_nActivityType)
		self:setTask2Redpoint(self.m_nActivityType)
	end
	local str_name1 = {{LocalStrings.EVERYDAYBUY_TEXT3,LocalStrings.EVERYDAYBUY_TEXT4}, {LocalStrings.EVERYDAYBUY_TEXT3,LocalStrings.EVERYDAYBUY_TEXT4}, 
					   {LocalStrings.ACTIVITY_TEXT116,LocalStrings.ACTIVITY_TEXT136},{"",""},{LocalStrings.ACTIVITY_TEXT179,LocalStrings.ACTIVITY_TEXT202}}
	local str_normal = {"ui/activity/common_btn_40.png","ui/common/common_btn_21.png","ui/common/common_btn_21.png","ui/common/common_btn_21.png","ui/common/common_btn_21.png"} 
	local str_select = {"ui/activity/common_btn_39.png","ui/common/common_btn_20.png","ui/common/common_btn_20.png","ui/common/common_btn_20.png","ui/common/common_btn_20.png"}
	
	for i=1,2 do
		local tab = {}
		local btn = GetElement(self.m_root,"btn"..i,WZUIButton)
		btn:setVisible(self.m_bIsChangeBtn)
		tab.normal = GetElement(btn,"normal",WZUI9Image)
		tab.select = GetElement(btn,"select",WZUI9Image)
		tab.normal:setFile(str_normal[self.m_nActivityType+1])
		tab.select:setFile(str_select[self.m_nActivityType+1])

		tab.name = GetElement(btn,"name",WZUILabelTTF)
		tab.name:setColor(GlobalMethod:ccc3(127,70,26))
		tab.name:setText(str_name1[self.m_nActivityType+1][i])
		self.m_tTaskTitle[i] = tab
	end
	self.m_tTaskTitle[self.m_nCurTaskIndex].normal:setVisible(false)
	self.m_tTaskTitle[self.m_nCurTaskIndex].select:setVisible(true)
	self.m_tTaskTitle[self.m_nCurTaskIndex].name:setColor(GlobalMethod:ccc3(255,236,193))
	self.m_tTaskTitle[self.m_nCurTaskIndex].name:setEnableStroke(true)
	self.m_tTaskTitle[self.m_nCurTaskIndex].name:setStrokeSize(4)
	self.m_tTaskTitle[self.m_nCurTaskIndex].name:setStrokeColor(GlobalMethod:ccc3(132,66,29))
end

function WndDollMachineTask:onBtnTaskChange( element )
	local tag = element:getTag()
	if self.m_nCurTaskIndex == tag then return end
	if self.m_tTaskTitle[self.m_nCurTaskIndex] then
		self.m_tTaskTitle[self.m_nCurTaskIndex].normal:setVisible(true)
		self.m_tTaskTitle[self.m_nCurTaskIndex].select:setVisible(false)
		self.m_tTaskTitle[self.m_nCurTaskIndex].name:setColor(GlobalMethod:ccc3(127,70,26))
		self.m_tTaskTitle[self.m_nCurTaskIndex].name:setEnableStroke(false)
	end
	if self.m_tTaskTitle[tag] then
		self.m_tTaskTitle[tag].normal:setVisible(false)
		self.m_tTaskTitle[tag].select:setVisible(true)
		self.m_tTaskTitle[tag].name:setColor(GlobalMethod:ccc3(255,236,193))
		self.m_tTaskTitle[tag].name:setEnableStroke(true)
		self.m_tTaskTitle[tag].name:setStrokeSize(4)
		self.m_tTaskTitle[tag].name:setStrokeColor(GlobalMethod:ccc3(132,66,29))
	end
	GetElement(self.m_root,"task1FreeList",WZUIFreeListContainer):setVisible(tag == 1)
	GetElement(self.m_root,"task2FreeList",WZUIFreeListContainer):setVisible(tag == 2)
	if self.m_tTaskData[1] == nil then
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, 1 )
	end
	self.m_nCurTaskIndex = tag
end
--成长任务
function WndDollMachineTask:setTask1Redpoint(_type)
	if not self.m_root then return end
	_type = _type or 0
	if self.m_nActivityType ~= _type then return end

	local visible = false
	if _type == 0 then
		visible = GlobalGame.g_tRedPointList.task1_redpoint
	elseif _type == 1 then
		visible = GlobalGame.g_tRedPointTypeList[117023]
	elseif _type == 2 then
		visible = GlobalGame.g_tRedPointTypeList[117024]
	elseif _type == 4 then
		visible = GlobalGame.g_tRedPointTypeList[117029]
	end
	local task2Redpoint = GetElement(self.m_root,"task2Redpoint",WZUIImage)
	if task2Redpoint then
		task2Redpoint:setVisible(visible)
	end
end
--每日任务
function WndDollMachineTask:setTask2Redpoint(_type)
	if not self.m_root then return end
	local task1Redpoint = GetElement(self.m_root,"task1Redpoint",WZUIImage)
	_type = _type or 0
	if self.m_nActivityType ~= _type then return end

	local visible = false
	if _type == 0 then
		visible = GlobalGame.g_tRedPointList.task2_redpoint
	elseif _type == 1 then
		visible = GlobalGame.g_tRedPointTypeList[127023]
	elseif _type == 2 then
		visible = GlobalGame.g_tRedPointTypeList[127024]
	elseif _type == 4 then
		visible = GlobalGame.g_tRedPointTypeList[127029]
	end
	if task1Redpoint then
		task1Redpoint:setVisible(visible)
	end
end
function WndDollMachineTask:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndDollMachineTask:_onGetTaskInfo(activityId, activityType, taskType, id, status, target, progress, progressCount, refreshTime)
	if self.m_tTaskData[taskType] == nil then
		self.m_tTaskData[taskType] = {}
		self.m_tCellTaskItem[taskType] = {}
	end
	self.m_tTaskData[taskType] = self:setTaskData(id, status, target, progress)
	local taskList = nil
	if taskType ==  1 then
		taskList = GetElement(self.m_root,"task2FreeList",WZUIFreeListContainer)
	elseif taskType == 2 then
		taskList = GetElement(self.m_root,"task1FreeList",WZUIFreeListContainer)
	end
	if next(self.m_tTaskData[taskType]) == nil then
		local _color = ccc3(255,255,255)
		if activityType == 7023 then --占星
			_color = ccc3(127,70,26)
		end
		ShowPanelNullTip( taskList, LocalStrings.ACTIVITY_TEXT11, _color)
	end
	if taskList then
		self:taskTableSort(self.m_tTaskData[taskType])
		taskList:removeAll()
		for i = 1, #self.m_tTaskData[taskType] do
			local element, tLuaObj = CellTaskItem:createElement()
			table.insert(self.m_tCellTaskItem[taskType], tLuaObj)
			taskList:pushBack(WZUIContainer:luaTo(element))
			taskList:getMoveElement():setPositionY(taskList:getMinPosition().y)
			tLuaObj:setTeakItemData(i, activityId,self.m_tTaskData[taskType][i], self.m_nActivityType)
		end
	end
end
function WndDollMachineTask:_onGetTaskResult(activityId, taskId)
	if self.m_nActivityId == activityId then
		local _type = nil --2:每日  1:成长
		for i=1,2 do
			if self.m_tTaskData[i] then
				for m=1, #self.m_tTaskData[i] do
					if self.m_tTaskData[i][m].id == taskId then
						_type = i
						break
					end
				end
			end
		end
		if _type and self.m_tCellTaskItem[_type] then
			for i,v in pairs(self.m_tTaskData[_type]) do
				if v and v.id == taskId then
					v.status = 1
					break
				end
			end
			self:taskTableSort(self.m_tTaskData[_type])
			for i,v in ipairs(self.m_tCellTaskItem[_type]) do
				if v then
					v:setTaskItemMessage(i, self.m_tTaskData[_type][i])
				end
			end
			self:setManageRedPoint(_type, self.m_nActivityType)
		end
	end
end
--处理红点
function WndDollMachineTask:setManageRedPoint(_type, activityType)
	local status = false
	for i,v in pairs(self.m_tTaskData[_type]) do
		if v.status == 0 then
			status = true
			break
		end
	end
	if activityType == 1 then
		if _type == 2 then
			GlobalGame.g_tRedPointTypeList[127023] = status
		elseif _type == 1 then
			GlobalGame.g_tRedPointTypeList[117023] = status
		end
	elseif activityType == 2 then
		if _type == 2 then
			GlobalGame.g_tRedPointTypeList[127024] = status
		elseif _type == 1 then
			GlobalGame.g_tRedPointTypeList[117024] = status
		end
	elseif activityType == 3 then
		GlobalGame.g_tRedPointTypeList[127028] = status
	elseif activityType == 4 then
		if _type == 2 then
			GlobalGame.g_tRedPointTypeList[127029] = status
		elseif _type == 1 then
			GlobalGame.g_tRedPointTypeList[117029] = status
		end
	end
	self:setTask1Redpoint(activityType)
	self:setTask2Redpoint(activityType)
	if activityType == 1 then
		WndMainHorary:setTaskRedPoint()
		local red_point = GlobalGame.g_tRedPointTypeList[117023] or GlobalGame.g_tRedPointTypeList[127023] or GlobalGame.g_tRedPointTypeList[17023]
	    SceneCity:setSceneMainIconRedPoint(HORARY_ACTIVITY, red_point)
	elseif activityType == 2 then
		WndFishMain:setTaskRedPoint()
		local red_point2 = GlobalGame.g_tRedPointTypeList[127024] or GlobalGame.g_tRedPointTypeList[117024]
    	SceneCity:setSceneMainIconRedPoint(FISH_ACTIVITY, red_point2)
    elseif activityType == 3 then
    	local red_point = GlobalGame.g_tRedPointTypeList[127028] or GlobalGame.g_tRedPointTypeList[27028] or GlobalGame.g_tRedPointTypeList[37028]
    	SceneCity:setSceneMainIconRedPoint(PELLET_ACTIVITY, red_point)
    elseif activityType == 4 then
    	local red_point = GlobalGame.g_tRedPointTypeList[7029] or GlobalGame.g_tRedPointTypeList[127029] or GlobalGame.g_tRedPointTypeList[117029]
    	SceneCity:setSceneMainIconRedPoint(HOUSEINVEST_ACTIVITY, red_point)
	end
end

-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配begin----------------------------------------
function WndDollMachineTask:_adaptLanguage_vn()
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
