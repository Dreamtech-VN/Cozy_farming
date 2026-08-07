--CellReturnActivity2.lua
--@brief	CellReturnActivity2的UI模块
--@date		2021/05/19
--@author	hyx
--@note		回归活动王者归来


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellReturnActivity2:onEnter(element)
	self.m_root = element
	self:register()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellReturnActivity2:onExit(element)
	self:_unInit()
	self:unregister()
end

function CellReturnActivity2:register()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self._onGetBoxInfo,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetTaskList,self._onGetReturnActivity2Info,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetInfo,self._onCellActivity2GetBoxResult,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetResult,self._onGetTaskResult,self)
end
function CellReturnActivity2:unregister()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self._onGetBoxInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetTaskList,self._onGetReturnActivity2Info,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetInfo,self._onCellActivity2GetBoxResult,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetResult,self._onGetTaskResult,self)
end
function CellReturnActivity2:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,false,"actionCallback",self)
end

function CellReturnActivity2:actionCallback()
	self:initShow()
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(self.m_nActivityId, self.m_nActivityType)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, 1 )
end
function CellReturnActivity2:initShow()
	for i=1,5 do
		local tab = {}
		local btn = GetElement(self.m_root,"btn"..i,WZUIButton)
		tab.normal = GetElement(btn,"normal",WZUI9Image)
		tab.select = GetElement(btn,"select",WZUI9Image)
		tab.name = GetElement(btn,"name",WZUILabelTTF)
		tab.name:setColor(GlobalMethod:ccc3(127,70,26))
		tab.name:setText(LocalStrings.ACTIVITY_TEXT42[i])
		tab.txtDay = GetElement(btn,"txtDay",WZUIFreeTextBox)
		tab.redpoint = GetElement(btn,"redpoint",WZUIImage)
		self.m_tBtnChangeTitle[i] = tab
	end
	self.m_nCurIndex = 1
	self.m_tBtnChangeTitle[self.m_nCurIndex].normal:setVisible(false)
	self.m_tBtnChangeTitle[self.m_nCurIndex].select:setVisible(true)
	self.m_tBtnChangeTitle[self.m_nCurIndex].name:setColor(GlobalMethod:ccc3(255,236,193))
	self.m_tBtnChangeTitle[self.m_nCurIndex].name:setEnableStroke(true)
	self.m_tBtnChangeTitle[self.m_nCurIndex].name:setStrokeSize(4)
	self.m_tBtnChangeTitle[self.m_nCurIndex].name:setStrokeColor(GlobalMethod:ccc3(132,66,29))

	local box_container = GetElement(self.m_root,"box_container",WZUIContainer)
	local box_common, box_common_obj = CellCommonBox:createElement({title = LocalStrings.ACTIVITY_TEXT50}, self.m_nActivityId)
	box_container:addChild(box_common)
	self.m_sBoxCommonObj = box_common_obj
end

function CellReturnActivity2:setVisibleView(tag)
	GetElement(self.m_root,"freeList1",WZUIFreeListContainer):setVisible(tag == 1)
	GetElement(self.m_root,"freeList2",WZUIFreeListContainer):setVisible(tag == 2)
	GetElement(self.m_root,"freeList3",WZUIFreeListContainer):setVisible(tag == 3)
	GetElement(self.m_root,"freeList4",WZUIFreeListContainer):setVisible(tag == 4)
	GetElement(self.m_root,"freeList5",WZUIFreeListContainer):setVisible(tag == 5)
	if self.m_tOpenListView[tag] == true then return end
	self.m_tOpenListView[tag] = true

	if self.m_tCellObjData[tag] == nil then
		self.m_tCellObjData[tag] = {}
	end
	local freeList = GetElement(self.m_root,"freeList"..tag,WZUIFreeListContainer)
	freeList:removeAll()
	self:taskTableSort(self.m_tDayTaskData[tag])
	for i=1, #self.m_tDayTaskData[tag] do
		local element, tLuaObj = CellActivity2Item:createElement()
		self.m_tCellObjData[tag][i] = tLuaObj
		freeList:pushBack(WZUIContainer:luaTo(element))
		freeList:getMoveElement():setPositionY(freeList:getMinPosition().y)
		tLuaObj:setCellItem2Data(self.m_tDayTaskData[tag][i], self.m_nActivityId)
	end
end
--排序
function CellReturnActivity2:taskTableSort(data_sort)
	local temp = {
		[-1] = 2, --未领取
		[0] = 1, --可领取
		[1] = 3, --已领取
	}
	local function testFunc(a,b)
		if a.status ~= b.status then
			if temp[a.status] and temp[b.status] then
				return temp[a.status] < temp[b.status]
			else
				return false
			end
		else
			return a.id < b.id
		end
	end
	table.sort(data_sort, testFunc)
end
function CellReturnActivity2:onBtnChangeTitle(element)
	local tag = element:getTag()
	if tag > self.m_nCurDay then
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT49)
		return
	end
	if tag == self.m_nCurIndex then return end
	if self.m_tBtnChangeTitle[self.m_nCurIndex] then
		self.m_tBtnChangeTitle[self.m_nCurIndex].normal:setVisible(true)
		self.m_tBtnChangeTitle[self.m_nCurIndex].select:setVisible(false)
		self.m_tBtnChangeTitle[self.m_nCurIndex].name:setColor(GlobalMethod:ccc3(127,70,26))
		self.m_tBtnChangeTitle[self.m_nCurIndex].name:setEnableStroke(false)
	end
	if self.m_tBtnChangeTitle[tag] then
		self.m_tBtnChangeTitle[tag].normal:setVisible(false)
		self.m_tBtnChangeTitle[tag].select:setVisible(true)
		self.m_tBtnChangeTitle[tag].name:setColor(GlobalMethod:ccc3(255,236,193))
		self.m_tBtnChangeTitle[tag].name:setEnableStroke(true)
		self.m_tBtnChangeTitle[tag].name:setStrokeSize(4)
		self.m_tBtnChangeTitle[tag].name:setStrokeColor(GlobalMethod:ccc3(132,66,29))
	end
	self:setVisibleView(tag)
	self.m_nCurIndex = tag
end

--天数是否完成
function CellReturnActivity2:setDayStatus(day)
	local status = false
	for i=1, #self.m_tDayTaskData[day] do
		if self.m_tDayTaskData[day][i].status == -1 or self.m_tDayTaskData[day][i].status == 0 then
			status = true
			break
		end
	end
	--没有完成的
	if status == true then
		self.m_tBtnChangeTitle[day].txtDay:setShowText(string.format(LocalStrings.ACTIVITY_TEXT46,day))
	else
		self.m_tBtnChangeTitle[day].txtDay:setShowText(string.format(LocalStrings.ACTIVITY_TEXT47,day))
	end
	--红点
	local redpoint_status = false
	for i,v in pairs(self.m_tDayTaskData[day]) do
		if v.status == 0 then
			redpoint_status = true
			break
		end
	end
	self.m_tTitleRedpoint[day] = redpoint_status
	self.m_tBtnChangeTitle[day].redpoint:setVisible(redpoint_status)
end

function CellReturnActivity2:setVisibleStatus(bool)
	bool = bool or false
	if self.m_root then
		self.m_root:setVisible(bool)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--获取宝箱数据
function CellReturnActivity2:_onGetBoxInfo(activityId,maxCount,count,status, rewardCounts, rewardItems,rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	if self.m_nActivityId == activityId then
		self.m_nCurDay = tonumber(count)
		local txtActivity2Time = GetElement(self.m_root,"txtActivity2Time",WZUIFreeTextBox)
		if txtActivity2Time then
			local time = SystemTime:getTimeConverLocal(endTime)
			local str = string.format([[%s<T C="255,236,193" S="18" P="1" SC="132,66,29" SE="1" SS="4"> %s</T>]],LocalStrings.SEVENDAY_TEXT4, time)
			txtActivity2Time:setShowText(str)
		end
		if self.m_sBoxCommonObj then
			self.m_tBoxRewardData = self.m_sBoxCommonObj:setBoxProgressData(rewardId,status,rewardItems,rewardItemsParamCount,rewardCounts,finishCondition)
			self.m_sBoxCommonObj:setInitBoxStatus(maxCount,self.m_tBoxRewardData)
		end
	end
end

--宝箱领取
function CellReturnActivity2:_onCellActivity2GetBoxResult(itemsId, count, _type, rewardId)
	if _type == self.m_nActivityType then
		WndRewardShow:showById(itemsId, count)
		if self.m_tBoxRewardData and self.m_tBoxRewardData[rewardId] then
			self.m_tBoxRewardData[rewardId].status = 1
			if self.m_sBoxCommonObj then
				self.m_sBoxCommonObj:setBoxStatus()
			end
			self:getTitleRedPoint()
		end
	end
end

--获取任务列表
function CellReturnActivity2:_onGetReturnActivity2Info(activityId, activityType, taskType, id, status, target, progress, progressCount, refreshTime)
	if activityId == self.m_nActivityId then
		self:setGetStatusData(id, status, target, progress, progressCount)
		self:setDayTaskData( activityType )
		for i=1,5 do
			self:setDayStatus(i)
		end
		self:setVisibleView(1)
	end
end
--领取任务返回
function CellReturnActivity2:_onGetTaskResult(activityId,taskId)
	if self.m_nActivityId == activityId then
		local tab_index = nil
		for i=1,5 do
			for m=1,#self.m_tDayTaskData[i] do
				if self.m_tDayTaskData[i][m].id == taskId then
					tab_index = i
					self.m_tDayTaskData[i][m].status = 1
					break
				end
			end
		end
		if tab_index then
			self:taskTableSort(self.m_tDayTaskData[tab_index])
			for i=1, #self.m_tCellObjData[tab_index] do
				self.m_tCellObjData[tab_index][i]:setCellItem2Data(self.m_tDayTaskData[tab_index][i], self.m_nActivityId)
				self.m_tCellObjData[tab_index][i]:setData(self.m_tDayTaskData[tab_index][i])
			end
			self:setDayStatus(tab_index)
		end
		self:getTitleRedPoint()
	end
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配模块begin--------------------------------------
function CellReturnActivity2:_adaptLanguage_vn()
	GetElement(self.m_root,"txtActivity2Time",WZUIFreeTextBox):setMaxWidth(800)

	for i=1,5 do
		local tab = {}
		local btn = GetElement(self.m_root,"btn"..i,WZUIButton)
		local name = GetElement(btn,"name",WZUILabelTTF)
		name:setScale(0.65)
	end
end
-------------------------------------语言适配模块end--------------------------------------
