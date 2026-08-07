--CellMagicStoneTaskData.lua
--@brief	CellMagicStoneTask的数据模块
--@date		2019/10/24
--@author	Tianxiang_Xu
--@note		幻石系统-任务

CellMagicStoneTask = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellMagicStoneTask:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tRewardData = nil
	self.m_tTaskTitle = nil
	self.m_tTaskDesc = nil 
	self.m_tTaskState = nil
	self.m_txtTaskTarget = nil
	self.m_nTag = nil
	self.m_tScript = nil
	self.m_bIsLoad = false 
	self.m_nTaskId = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellMagicStoneTask:_unInit()
	self.m_root = nil
	self.m_tRewardData = nil
	self.m_tTaskTitle = nil
	self.m_tTaskDesc = nil 
	self.m_tTaskState = nil
	self.m_txtTaskTarget = nil
	self.m_nTag = nil
	self.m_tScript = nil
	self.m_bIsLoad = nil 
	self.m_nTaskId = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellMagicStoneTask:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellMagicStoneTask table create failed!")
	tNewObj:_init()

	local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setName("__CellMagicStoneTask")
    element:setAbsContentSize(GlobalMethod:CCSize(660, 110))
    element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end

--@brief 	初始化数据
function CellMagicStoneTask:setData(taskId, RewardData, TaskTitle, TaskDesc, TaskState, nTag, txtTaskTarget, script, nAchieTimes, nMaxAchieTimes)
	self.m_nTaskId = taskId
	self.m_tRewardData = RewardData
	self.m_tTaskTitle = TaskTitle
	self.m_tTaskDesc = TaskDesc 
	self.m_tTaskState = TaskState
	self.m_txtTaskTarget = txtTaskTarget
	self.m_nTag = nTag
	self.m_tScript = script
	self.m_nAchieTimes = nAchieTimes
	self.m_nMaxAchieTimes = nMaxAchieTimes

end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellMagicStoneTask:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
