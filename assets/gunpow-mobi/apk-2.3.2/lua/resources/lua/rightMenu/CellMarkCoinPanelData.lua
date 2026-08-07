--CellMarkCoinPanelData.lua
--@brief	CellMarkCoinPanel的数据模块
--@date		2019/04/23
--@author	Tianxiang_Xu
--@note		纪念币活动

CellMarkCoinPanel = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellMarkCoinPanel:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tTaskslist = nil 
	self.m_startTime = nil
	self.m_endTime = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellMarkCoinPanel:_unInit()
	self.m_root = nil
	self.m_tTaskslist = nil 
	self.m_startTime = nil
	self.m_endTime = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellMarkCoinPanel:createElement()
	local element = WZUISystem:getInstance():createElement("CellMarkCoinPanel")
	assert(element, "CellMarkCoinPanel create element failed!")
	self:_init()
	return element
end

--@brief 	设置活动数据
function CellMarkCoinPanel:getActivityTaskListOk( id, status, target, complete, statusCoin)
	-- body
	WZLog("CellMarkCoinPanel:getActivityTaskListOk",Serialize(id),Serialize(status),Serialize(target),Serialize(complete))

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
		itemData.statusCoin = statusCoin[i]

		if itemData.status == 1 or itemData.statusCoin == 1 then
			table.insert(temptasksList1, itemData)
		elseif itemData.status == 0 or itemData.statusCoin == 0 then
			table.insert(temptasksList0, itemData)
		else
			table.insert(temptasksList2, itemData)
		end

	end

	table.sort(temptasksList0, _sortMarkCoinTask)
	table.sort(temptasksList1, _sortMarkCoinTask)
	table.sort(temptasksList2, _sortMarkCoinTask)


	for i = 1, #temptasksList1 do
		table.insert(self.m_tTaskslist, temptasksList1[i])
	end
	for i = 1, #temptasksList0 do
		table.insert(self.m_tTaskslist, temptasksList0[i])
	end
	for i = 1, #temptasksList2 do
		table.insert(self.m_tTaskslist, temptasksList2[i])
	end

	self:update()
end


function CellMarkCoinPanel:setData(tActivityData)
	self.m_startTime = tActivityData.startTime
	self.m_endTime = tActivityData.endTime
	
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function _sortMarkCoinTask( a, b )
	return a.id < b.id
end





-------------------------------------私有方法模块End----------------------------------------
