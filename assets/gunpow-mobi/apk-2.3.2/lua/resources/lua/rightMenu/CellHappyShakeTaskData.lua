--CellHappyShakeTaskData.lua
--@brief	CellHappyShakeTask的数据模块
--@date		2020/05/28
--@author	XTX
--@note		全民摇摇乐任务Cell

CellHappyShakeTask = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellHappyShakeTask:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tRewardData={}		--物品奖励表
	self.m_tTaskTitle = nil     --任务标题
	self.m_tTaskDesc = nil 		--任务描述
	self.m_tTaskState = 0 		--任务状态
	self.m_nMainID = -1 				--跳转界面主ID
	self.m_nSubID = -1 					--跳转界面子ID
	self.m_nTaskID = -1 				--任务ID
	self.m_nTag = 0
	self.m_txtTaskTarget = nil 
	self.m_tBack = nil 
	self.m_bIsLoad = false
	self.m_nActualyLeftDay = nil 	--实际剩余天使
	self.m_nTempState = nil 		--
	self.m_txtTempTarget = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellHappyShakeTask:_unInit()
	self.m_root = nil
	self.m_tRewardData=nil		--物品奖励表
	self.m_tTaskTitle = nil     --任务标题
	self.m_tTaskDesc = nil 		--任务描述
	self.m_tTaskState = nil 		--任务状态
	self.m_nMainID = nil 				--跳转界面主ID
	self.m_nSubID = nil 					--跳转界面子ID
	self.m_nTaskID = nil 				--任务ID
	self.m_nTag = nil
	self.m_txtTaskTarget = nil 
	self.m_tBack = nil 
	self.m_bIsLoad = nil
	self.m_nActualyLeftDay = nil 	--实际剩余天使
	self.m_nTempState = nil 		--
	self.m_txtTempTarget = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellHappyShakeTask:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellHappyShakeTask table create failed!")
	tNewObj:_init()
	
	local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setName("__CellHappyShakeTask")
    element:setAbsContentSize(GlobalMethod:CCSize(620,95))
    element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end

--@brief 	初始化数据
function CellHappyShakeTask:initMessageInfo(RewardData, TaskTitle, TaskDesc, TaskState, nTag, txtTaskTarget)
	self.m_tRewardData = RewardData
	self.m_tTaskTitle = TaskTitle
	self.m_tTaskDesc = TaskDesc
	self.m_tTaskState = TaskState
	self.m_txtTaskTarget = txtTaskTarget
	self.m_nTag = nTag
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellHappyShakeTask:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
