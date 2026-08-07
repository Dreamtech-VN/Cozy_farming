--CellMonthCardPanelData.lua
--@brief	CellMonthCardPanel的数据模块
--@date		2016/06/05
--@author	Tianxiang_Xu
--@note		月卡活动

CellMonthCardPanel = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellMonthCardPanel:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tDailyTaskCompleted = nil 	--日常任务已完成列表
	self.m_nCardActivityState = nil  
    self.m_nBuyCardTimes = nil  
    self.m_nCardActivityEndTime = nil  
    self.newRechargeType = nil 
    self.m_tRechargeData = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellMonthCardPanel:_unInit()
	self.m_root = nil
	self.m_tDailyTaskCompleted = nil 	--日常任务已完成列表
	self.m_nCardActivityState = nil  
    self.m_nBuyCardTimes = nil  
    self.m_nCardActivityEndTime = nil  
    self.newRechargeType = nil 
    self.m_tRechargeData = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellMonthCardPanel:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellMonthCardPanel table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellMonthCardPanel")
	assert(element, "CellMonthCardPanel element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief 	设置数据
function CellMonthCardPanel:setMessage(progress, num, endTime)
	-- body
	self.m_nCardActivityState = progress 
    self.m_nBuyCardTimes = num 
    self.m_nCardActivityEndTime = endTime 
end

--@brief 	根据类型获取相应的充值数据
function CellMonthCardPanel:getRechargeData(rechargeType)
	-- body
	local vipList = CacheCenter:getVipList()

	for i = 1, #vipList do
		local value = GDatatab_recharge["id_" .. vipList[i].ids]
		if value.type == rechargeType then 
			return value 
		end
	end

	return nil 
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellMonthCardPanel:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
--	CellMonthCardPanel.m_current = tNewObj
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
