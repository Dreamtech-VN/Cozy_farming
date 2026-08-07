--CellTaskListItemData.lua
--@brief	CellTaskListItem的数据模块
--@date		2015/03/31
--@author	weidong_wu
--@note		任务列表项

CellTaskListItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellTaskListItem:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_imgIconType = 0 		--Item图标显示的类型
	self.m_tRewardData={}		--物品奖励表
	self.m_tTaskTitle = nil     --任务标题
	self.m_tTaskDesc = nil 		--任务描述
	self.m_tTaskState = 0 		--任务状态
	self.m_nMainID = -1 				--跳转界面主ID
	self.m_nSubID = -1 					--跳转界面子ID
	self.m_nTaskID = -1 				--任务ID
	self.m_nTaskType = -1 				--任务类型
	self.CartorNeedId = -1 				--副本跳转任务Id
	self.m_nTag = 0
	self.m_txtTaskTarget = nil 
	self.m_tBack = nil 
	self.m_bIsLoad = false
	self.m_nActualyLeftDay = nil 	--实际剩余天使
	self.m_nTempState = nil 		--
	self.m_txtTempTarget = nil
	self.m_tScript = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellTaskListItem:_unInit()
	self.m_root = nil
	self.m_imgIconType = 0 		--Item图标显示的类型
	self.m_tRewardData={}		--物品奖励表
	self.m_tTaskTitle = nil     --任务标题
	self.m_tTaskDesc = nil 		--任务描述
	self.m_tTaskState = 0 		--任务状态
	self.m_nTaskID = -1 				--任务ID
	self.m_nTaskType = -1 				--任务类型
	self.m_txtTaskTarget = nil 
	self.m_tBack = nil 
	self.m_bIsLoad = nil
	self.m_nActualyLeftDay = nil 	--实际剩余天使
	self.m_nTempState = nil
	self.m_txtTempTarget = nil
	self.m_tScript = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellTaskListItem:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellTaskListItem table create failed!")
	tNewObj:_init()

	local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setName("__CellTaskListItem")
    element:setAbsContentSize(GlobalMethod:CCSize(725,95))
    element:setLuaObjectIndex(tNewObj)
    return element,tNewObj
end


--@brief 	初始化数据
function CellTaskListItem:initMessageInfo( imgIconType,RewardData,TaskTitle,TaskDesc,TaskState ,nTag,txtTaskTarget, script)
	self.m_imgIconType = imgIconType
	self.m_tRewardData = RewardData
	self.m_tTaskTitle = TaskTitle
	self.m_tTaskDesc = TaskDesc
	self.m_tTaskState = TaskState
	self.m_txtTaskTarget = txtTaskTarget
	self.m_nTag = nTag
	self.m_tScript = script
	
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellTaskListItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
