--CellDiscountLimitItemData.lua
--@brief	CellDiscountLimitItem的数据模块
--@date		2017/07/19
--@author	Tianxiang_Xu
--@note		折扣限购活动，可以配置消耗货币类型

CellDiscountLimitItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellDiscountLimitItem:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil 
	self.m_tCallBack = nil 
	self.m_nActivityType = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellDiscountLimitItem:_unInit()
	self.m_root = nil
	self.m_tData = nil 
	self.m_tCallBack = nil 
	self.m_nActivityType = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellDiscountLimitItem:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellDiscountLimitItem table create failed!")
	tNewObj:_init()
	
	local element = WZUIContainer:create()
	element:setName("__CellDiscountLimitItem")
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(304,140))
	element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end

--@brief 	设置数据
function CellDiscountLimitItem:setData(tData, nActivityType)
	-- body
	self.m_tData = tData
	self.m_nActivityType = nActivityType
end

--@brief 	设置回调函数
function CellDiscountLimitItem:setCallBackFunc(tCell, func)
	-- body
	if self.m_tCallBack == nil then
		self.m_tCallBack = {}
	end

	self.m_tCallBack[1] = tCell
	self.m_tCallBack[2] = func
end

--@brief 	获取cell数据
function CellDiscountLimitItem:getData()
	-- body
	return self.m_tData
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellDiscountLimitItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	CellDiscountLimitItem.m_current = tNewObj
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
