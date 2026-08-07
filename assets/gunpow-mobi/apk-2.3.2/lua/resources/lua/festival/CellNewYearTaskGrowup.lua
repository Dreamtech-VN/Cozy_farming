--CellNewYearTaskGrowup.lua
--@brief	CellNewYearTaskGrowup的UI模块
--@date		2020/12/01
--@author	hyx
--@note		元旦每日任务


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellNewYearTaskGrowup:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellNewYearTaskGrowup:onExit(element)
	self:_unInit()
end
function CellNewYearTaskGrowup:onEnterTransitionDidFinish(element)
	local taskGrowupList = GetElement(self.m_root,"taskGrowupList",WZUIFreeListContainer)
	local count = getnTableCount(self.m_tTaskGrowupData)
	taskTableSort(self.m_tTaskGrowupData)
	for i = 1, count do
		local element, tLuaObj = CellNewYearTaskItem:createElement()
		self.m_tGrowupTaskItemCell[i] = tLuaObj
		taskGrowupList:pushBack(WZUIContainer:luaTo(element))
		taskGrowupList:getMoveElement():setPositionY(taskGrowupList:getMinPosition().y)
		tLuaObj:setGiftBuyMessage(i, self.m_tTaskGrowupData[i], self.m_nType, self.m_tOtherData)
	end
end

function CellNewYearTaskGrowup:setTeskGetResult(id)
	if self.m_tGrowupTaskItemCell then
		for i,v in pairs(self.m_tTaskGrowupData) do
			if v and v.id == id then
				self.m_tTaskGrowupData[i].status = 2	
				break
			end
		end
		taskTableSort(self.m_tTaskGrowupData)
		for i,v in ipairs(self.m_tGrowupTaskItemCell) do
			if v then
				v:setTaskItemMessage(i,self.m_tTaskGrowupData[i])
			end
		end
	end
end
--红点
function CellNewYearTaskGrowup:setRedPoint(node, data)
	if not node then return end
	
	local status = false
	data = data or self.m_tTaskGrowupData
	local tTypeList = {117020, 227031, 237031, 117030, 117035, 117033, 117034, 117036, 117037, 117046, 117047, 117048, 117049, 117051, 117052, 117055, 117057, 227058, 117059, 227061, 227062, 227063, 227065, 227070, 227072, 117075, 227076, 117077, 227081, 227082, 227083, 117084, 117086, 227087, 117089, 227088, 117091, 227090, 227092, 117093, 117094, 117095, 117096, 227097, 117098, 227099, 227100, 117101, 227102, 117103, 227104, 227105, 227106, 227107}
	if self.m_tOtherData then 
		tTypeList[self.m_nType] = self.m_tOtherData.redPoint[1]
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
