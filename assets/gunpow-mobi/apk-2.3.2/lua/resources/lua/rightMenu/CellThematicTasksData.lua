--CellThematicTasksData.lua
--@brief	CellThematicTasks的数据模块
--@date		2017/12/08
--@author	yrd
--@note		主题任务格子

CellThematicTasks = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellThematicTasks:_init()
	self.m_root = nil	 	  			--场景根节点
	self.data = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellThematicTasks:_unInit()
	self.m_root = nil
	self.data = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellThematicTasks:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellThematicTasks table create failed!")
	tNewObj:_init()
	local element = WZUIContainer:create()
	element:setName("__CellThematicTasks")
    element:setUseAbsSize(true)
    element:setAbsContentSize(GlobalMethod:CCSize(630,80))
	assert(element, "CellThematicTasks element create failed!")
	element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end

function CellThematicTasks:getActivityTaskRewardOk(status)
	if status == 0 then
		-- MsgBoxManager:showTipBox("失败")
	elseif status == 1 then
		local tReward = GDatatab_activity_task["id_"..CellThematicTasks.m_tCurClick.data.id].reward
		local tRewardId = {}
		local tRewardNum = {}
		for i = 1, #tReward do
			local tempRewardId = {}
			local tempRewardNum = {}

			tempRewardId = tReward[i][1]
			tempRewardNum = tReward[i][2]

			table.insert(tRewardId,tempRewardId)
			table.insert(tRewardNum,tempRewardNum)
		end
		WndRewardShow:showById(tRewardId,tRewardNum)
	end
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityTaskList()
end

function CellThematicTasks:setData(data)
	self.data = data
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellThematicTasks:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end




-------------------------------------私有方法模块End----------------------------------------
