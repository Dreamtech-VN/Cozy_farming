--CellWakeupPowerItemData.lua
--@brief	CellWakeupPowerItem的数据模块
--@date		2017/05/24
--@author	Tianxiang_Xu
--@note		觉醒之晶的使用

CellWakeupPowerItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellWakeupPowerItem:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil 
	self.m_tCallBack = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellWakeupPowerItem:_unInit()
	self.m_root = nil
	self.m_tData = nil 
	self.m_tCallBack = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellWakeupPowerItem:createElement()
	local tNewObj = self:_new()
	tNewObj:_init()

	local element = WZUIContainer:create()
	element:setName("__CellWakeupPowerItem")
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(73,73))
	element:setLuaObjectIndex(tNewObj)

	return element,tNewObj
end

--@brief 	设置数据
function CellWakeupPowerItem:setData(tData)
	-- body
	self.m_tData = tData 
end

--@brief 	设置回调
function CellWakeupPowerItem:setCallBackFunc(tCell, func)
	-- body
	self.m_tCallBack = {}

	self.m_tCallBack[1] = tCell
	self.m_tCallBack[2] = func
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellWakeupPowerItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
