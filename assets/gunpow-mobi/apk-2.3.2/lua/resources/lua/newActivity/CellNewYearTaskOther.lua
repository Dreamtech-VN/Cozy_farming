--CellNewYearTaskOther.lua
--@brief	CellNewYearTaskOther的UI模块
--@date		2022/03/04
--@author	XTX
--@note		任务面板


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellNewYearTaskOther:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellNewYearTaskOther:onExit(element)
	self:_unInit()
end

function CellNewYearTaskOther:onEnterTransitionDidFinish(element)
	local taskOtherList = GetElement(self.m_root,"taskOtherList_CellNewYearTaskOther",WZUIFreeListContainer)
	local count = getnTableCount(self.m_tTaskOtherData)
	taskTableSort(self.m_tTaskOtherData)
	for i = 1, count do
		local element, tLuaObj = CellNewYearTaskItem:createElement()
		self.m_tOtherTaskItemCell[i] = tLuaObj
		taskOtherList:pushBack(WZUIContainer:luaTo(element))
		taskOtherList:getMoveElement():setPositionY(taskOtherList:getMinPosition().y)
		tLuaObj:setGiftBuyMessage(i, self.m_tTaskOtherData[i], self.m_nType, self.m_tOtherData)
	end
end

function CellNewYearTaskOther:setTeskGetResult(id)
	if self.m_tOtherTaskItemCell then
		for i,v in pairs(self.m_tTaskOtherData) do
			if v and v.id == id then
				self.m_tTaskOtherData[i].status = 2	
				break
			end
		end
		taskTableSort(self.m_tTaskOtherData)
		for i,v in ipairs(self.m_tOtherTaskItemCell) do
			if v then
				v:setTaskItemMessage(i,self.m_tTaskOtherData[i])
			end
		end
	end
end
--红点
function CellNewYearTaskOther:setRedPoint(node, data)
	if not node then return end
	
	local status = false
	data = data or self.m_tTaskOtherData
	local tTypeList = {nil, nil, nil, nil, nil, nil, nil, nil, 137037, 137046, 137047, nil, nil, nil, nil, 137055, nil, 237058, nil, 227061, 237062, 237063, 237065, 237070, 237072, nil, nil, nil, 237081, 237082, 237083, nil, nil, nil, nil, 237088}
	tTypeList[44] = 237097
	tTypeList[46] = 237099
	tTypeList[47] = 237100
	tTypeList[49] = 237102
	tTypeList[51] = 237104
	tTypeList[52] = 237105
	tTypeList[53] = 237106
	tTypeList[54] = 237107
	tTypeList[56] = 247109
	tTypeList[57] = 247119
	if self.m_tOtherData then 
		tTypeList[self.m_nType] = self.m_tOtherData.redPoint[3]
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
