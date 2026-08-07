--CellLevelSprintPanelData.lua
--@brief	CellLevelSprintPanel的数据模块
--@date		2015/05/13
--@author	weidong_wu
--@note		等级冲刺

CellLevelSprintPanel = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellLevelSprintPanel:_init()
	self.m_root = nil  			--Cell的根节点
	self.b_scheduleState = false
    self.reduceTime = 0.0
    self.startTime = nil
    self.endTime = nil
    self.serverTime = nil
    self.rewardItems = nil
    self.rewardId = nil
    self.rewardItemsParamCount = nil
    self.rewardCounts = nil
    self.status = nil
    self.index = 0
    self.tips = nil
    self.now_time = 0
    self.activityId = nil 
    self.target = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellLevelSprintPanel:_unInit()
	self.m_root = nil
	self.b_scheduleState = false
    self.reduceTime = 0.0
    self.startTime = nil
    self.endTime = nil
    self.serverTime = nil
    self.rewardItems = nil
    self.rewardId = nil
    self.rewardItemsParamCount = nil
    self.rewardCounts = nil
    self.status = nil
    self.index = 0
    self.tips = nil
    self.now_time = 0
    self.activityId = nil 
    self.target = nil 
end

--@breif 	初始信息
function CellLevelSprintPanel:setMessage( index,tips,startTime,endTime,serverTime,rewardId,status,rewardItems,rewardItemsParamCount,rewardCounts ,activityId,target)
    self.startTime = startTime
    self.endTime = endTime
    self.serverTime = serverTime
    self.rewardItems = rewardItems
    self.rewardId = rewardId
    self.rewardItemsParamCount = rewardItemsParamCount
    self.rewardCounts = rewardCounts
    self.status = status
    self.index = index
    self.tips = tips
    self.activityId = activityId
    self.target = target
end
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellLevelSprintPanel:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellLevelSprintPanel table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellLevelSprintPanel")
	assert(element, "CellLevelSprintPanel element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellLevelSprintPanel:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	CellLevelSprintPanel.m_current = tNewObj
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
