--CellCutePetPanelData.lua
--@brief	CellCutePetPanel的数据模块
--@date		2016/08/11
--@author	Tianxiang_Xu
--@note		萌宠上线活动

CellCutePetPanel = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellCutePetPanel:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_nStartTime = nil 	
	self.m_nEndTime = nil 
	self.m_context = nil 
	self.activityId = nil 
	self.tips = nil 	
	self.m_nActivityType = nil 	
	self.m_sOrderCode = nil 
	self.m_nCount = 0 
	self.m_nMaxCount = 0 
	self.m_nServerTime = nil 
	self.m_nRewardCounts = nil 
	self.m_nUIId = 0 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellCutePetPanel:_unInit()
	self.m_root = nil
	self.m_nStartTime = nil 	
	self.m_nEndTime = nil 
	self.m_context = nil 
	self.activityId = nil 
	self.tips = nil 	
	self.m_nActivityType = nil 	
	self.m_sOrderCode = nil 
	self.m_nCount = nil 
	self.m_nMaxCount = nil  
	self.m_nServerTime = nil 
	self.m_nRewardCounts = nil 
	self.m_nUIId = 0 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellCutePetPanel:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellCutePetPanel table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellCutePetPanel")
	assert(element, "CellCutePetPanel element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief 	设置数据
function CellCutePetPanel:setMessage(startTime,endTime,activityId, content, tips, activityType)
	-- body
	self.m_nStartTime = startTime 	
	self.m_nEndTime = endTime
	self.m_context = content
    self.activityId = activityId
    self.tips = tips[1]
    self.m_nActivityType = activityType

    WZLog("CellCutePetPanel:setMessage", content, self.tips)
end

--@brief 	设置数据
function CellCutePetPanel:setMessage2(startTime,endTime,activityId, rewardCounts, tips, serverTime, count, maxCount, activityType)
	-- body
	self.m_nStartTime = startTime 	
	self.m_nEndTime = endTime
    self.activityId = activityId
    self.m_sOrderCode = tips[1]
    self.m_nActivityType = activityType
    self.m_nCount = count 
	self.m_nMaxCount = maxCount 
	self.m_nServerTime = serverTime 
	self.m_nRewardCounts = rewardCounts[1] 

	WZLog("CellCutePetPanel:setMessage2", count, maxCount, self.m_sOrderCode, self.m_nRewardCounts)
end

--@brief 	设置全民狂欢数据
function CellCutePetPanel:setMessage3(uiId)
	-- body
	self.m_nUIId = uiId
	self.m_nActivityType = 0
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellCutePetPanel:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
