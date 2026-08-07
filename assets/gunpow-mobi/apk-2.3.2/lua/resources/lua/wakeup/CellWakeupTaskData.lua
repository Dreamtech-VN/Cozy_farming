--CellWakeupTaskData.lua
--@brief	CellWakeupTask的数据模块
--@date		2017/05/20
--@author	Tianxiang_Xu
--@note		觉醒模块-任务界面

CellWakeupTask = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellWakeupTask:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nTopSelIndex = 1 
	self.m_nCurProgress = 2 			--当前正在进行的任务
	self.m_tData = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellWakeupTask:_unInit()
	self.m_root = nil
	self.m_nTopSelIndex = nil 
	self.m_nCurProgress = nil 
	self.m_tData = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellWakeupTask:createElement()
	local element = WZUISystem:getInstance():createElement("CellWakeupTask")
	assert(element, "CellWakeupTask create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
--@param 	parentNode:父节点
--@param 	nTag : 顶部标签
--@param 	nCurDoingIndex: 正在进行的任务
function CellWakeupTask:showInterface(parentNode, nTag, nCurDoingIndex)
	-- body
	if not self.m_root then
		local wakeupTask = CellWakeupTask:createElement()
		if wakeupTask then
			self.m_nTopSelIndex = nTag
			self.m_nCurProgress = nCurDoingIndex
			parentNode:addChild(wakeupTask)
		end
	else
		self.m_nTopSelIndex = nTag 	
		self.m_nCurProgress = nCurDoingIndex	

		self:_update()
	end
end

--@brief 	设置数据
function CellWakeupTask:setData(tData)
	-- body
	self.m_tData = tData
end

function CellWakeupTask:updatePlayerItemData()
	if self.m_root == nil then return end

	self:_createCostList()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	判断是否满足觉醒条件
function CellWakeupTask:_judgeWakeupCondition()
	-- body
	local tTaskList = self.m_tData.taskData

	for i = 1, #tTaskList do
		if tonumber(tTaskList[i].target) > tonumber(tTaskList[i].complete) then
			return LocalStrings.WAKEUP_TEXT18
		end
	end

	return nil 
end

--@brief 	判断消耗物品是否充足
function CellWakeupTask:_judgeWakeupCostEnough()
	-- body
	local tCostList = self.m_tData.basicInfo.awake_cost
	for i = 1, #tCostList do
		local nTempNum = CacheCenter:getPlayerItemCountById(tCostList[i][1])
		if nTempNum < tCostList[i][2] then
			local basicInfo = GDatatab_item["id_" .. tCostList[i][1]]
			local tipContent = basicInfo.name .. LocalStrings.NOT_ENABLE
			JudgeMoneyIsEnough(tCostList[i][1], tCostList[i][2], tipContent,nil,202)
			return false
		end
	end

	return true
end


-------------------------------------私有方法模块End----------------------------------------
