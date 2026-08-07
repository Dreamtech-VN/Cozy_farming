--CellLoginActivityPanelData.lua
--@brief	CellLoginActivityPanel的数据模块
--@date		2015/02/05
--@author	weidong_wu
--@note		登录活动界面

CellLoginActivityPanel = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellLoginActivityPanel:_init()
	self.m_root = nil  			--Cell的根节点
	self.startTime= nil 
	self.endTime = nil 
	self.serverTime = nil 
	self.rewardItems = nil 
	self.rewardId=nil 
	self.rewardItemsParamCount=nil 
	self.n_ActivityType = 0 
	self.n_needTime = 0
	self.tips = nil 
	self.status = nil 
	self.rewardCounts = nil 
	self.m_cellItemObj = nil 
	self.m_nCurActivityType = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellLoginActivityPanel:_unInit()
	self.m_root = nil
	self.startTime= nil 
	self.endTime = nil 
	self.serverTime = nil 
	self.rewardItems = nil 
	self.rewardId=nil 
	self.rewardItemsParamCount=nil 
	self.n_ActivityType = nil 
	self.n_needTime = 0
	self.tips = nil 
	self.status = nil
	self.rewardCounts = nil 
	self.m_cellItemObj = nil 
	self.m_nCurActivityType = nil 
end

--@brief 	初始化数据信息
function CellLoginActivityPanel:setMessage(n_ActivityType, tips, startTime, endTime, serverTime, rewardItems, rewardId, rewardItemsParamCount, n_needTime, status, rewardCounts, cellObj, activityType)
	self.startTime= startTime 
	self.tips=tips
	self.endTime = endTime 
	self.serverTime = serverTime 
	self.rewardItems = rewardItems 
	self.rewardId=rewardId 
	self.rewardItemsParamCount=rewardItemsParamCount 
	self.n_ActivityType = n_ActivityType 
	self.n_needTime = n_needTime
	self.status = status
	self.rewardCounts = rewardCounts
	self.m_cellItemObj = cellObj
	self.m_nCurActivityType = activityType
	WZLog("CellLoginActivityPanel:setMessage", serverTime)
end
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellLoginActivityPanel:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellLoginActivityPanel table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellLoginActivityPanel")
	assert(element, "CellLoginActivityPanel element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellLoginActivityPanel:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	CellLoginActivityPanel.m_current = tNewObj
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
