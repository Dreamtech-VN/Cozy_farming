--CellNewYearTaskDay.lua
--@brief	CellNewYearTaskDay的UI模块
--@date		2020/12/01
--@author	hyx
--@note		元旦每日任务


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellNewYearTaskDay:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellNewYearTaskDay:onExit(element)
	self:_unInit()
end
function CellNewYearTaskDay:onEnterTransitionDidFinish(element)
	local taskDayList = GetElement(self.m_root,"taskDayList",WZUIFreeListContainer)
	local count = getnTableCount(self.m_tTaskDayData)
	taskTableSort(self.m_tTaskDayData)
	for i = 1, count do
		local element, tLuaObj = CellNewYearTaskItem:createElement()
		self.m_tDayTaskItemCell[i] = tLuaObj
		taskDayList:pushBack(WZUIContainer:luaTo(element))
		taskDayList:getMoveElement():setPositionY(taskDayList:getMinPosition().y)
		tLuaObj:setGiftBuyMessage(i, self.m_tTaskDayData[i], self.m_nType, self.m_tOtherData)
	end
end

function CellNewYearTaskDay:setTeskGetResult(id)
	if self.m_tDayTaskItemCell then
		for i,v in pairs(self.m_tTaskDayData) do
			if v and v.id == id then
				self.m_tTaskDayData[i].status = 2	
				break
			end
		end
		taskTableSort(self.m_tTaskDayData)
		for i,v in ipairs(self.m_tDayTaskItemCell) do
			if v then
				v:setTaskItemMessage(i,self.m_tTaskDayData[i])
			end
		end
	end
end
--红点
function CellNewYearTaskDay:setRedPoint(node, data)
	if not node then return end
	
	local status = false
	data = data or self.m_tTaskDayData
	local tTypeList = {127020, 217031, 0, 127030, 127035, 127033, 127034, 127036, 127037, 127046, 127047, 127048, 127049, 127051, 127052, 127055, 127057, 217058, 127059, 217061, 217062, 217063, 217065, 217070, 217072, 127075, 217076, 127077, 217081, 217082, 217083, 127084, 127086, 217087, 127089, 217088, 127091, 217090, 217092, 127093, 127094, 127095, 127096, 217097, 127098, 217099, 217100, 127101, 217102, 127103, 217104, 217105, 217106, 217107}
	if self.m_tOtherData and self.m_tOtherData.redPoint then 
		tTypeList[self.m_nType] = self.m_tOtherData.redPoint[2]
	end
	if data then
		for i,v in pairs(data) do
			if v.status == 1 then
				status = true
				break
			end
		end
		if node then
			node:setVisible(status)
			GlobalGame.g_tRedPointTypeList[tTypeList[self.m_nType]] = status
			return
		end
	end

	GlobalGame.g_tRedPointTypeList[tTypeList[self.m_nType]] = false
	node:setVisible(status)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
