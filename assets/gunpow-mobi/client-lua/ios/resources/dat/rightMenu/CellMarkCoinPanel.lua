--CellMarkCoinPanel.lua
--@brief	CellMarkCoinPanel的UI模块
--@date		2019/04/23
--@author	Tianxiang_Xu
--@note		纪念币活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellMarkCoinPanel:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellMarkCoinPanel:onExit(element)
	self:_unInit()
end


function CellMarkCoinPanel:update()
	if self.m_root then 
		self:setTime()
		self:addTasksCell()	
	end
end

function CellMarkCoinPanel:setTime(  )
	local startT = os.date("%m.%d",self.m_startTime)
    local endT = os.date("%m.%d",self.m_endTime)
    local actT = LocalStrings.ACTIVITY_TIME_KEY .. ":" .. startT .. "-" .. endT
	GetElement(self.m_root, "txtTime_CellMarkCoinPanel", WZUILabelTTF):setText(actT)
end

function CellMarkCoinPanel:addTasksCell(  )
	local tableTasks = GetElement(self.m_root,"tableTaskList_CellMarkCoinPanel",WZUITableContainer)
	tableTasks:cleanTable()
	
	for i = 1, #self.m_tTaskslist do
		local element,tNewObj = CellMarkCoinItem:createElement()
		element:setTag(i - 1)
		tNewObj:setData(self.m_tTaskslist[i])

		tableTasks:setCellElement(element)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
