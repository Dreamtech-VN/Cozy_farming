--CellWakeupCoinUseData.lua
--@brief	CellWakeupCoinUse的数据模块
--@date		2017/05/24
--@author	Tianxiang_Xu
--@note		觉醒之晶的使用

CellWakeupCoinUse = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellWakeupCoinUse:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_nItemId = nil 
	self.m_tCallBack = nil 
	self.m_nTag = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellWakeupCoinUse:_unInit()
	self.m_root = nil
	self.m_nItemId = nil 
	self.m_tCallBack = nil 
	self.m_nTag = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellWakeupCoinUse:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellWakeupCoinUse table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellWakeupCoinUse")
	assert(element, "CellWakeupCoinUse element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief 	设置数据
function CellWakeupCoinUse:setData(itemId)
	-- body
	self.m_nItemId = itemId

	self:_update()
end

--@brief 	设置回调
function CellWakeupCoinUse:setCallBackFunc(tCell, func)
	-- body
	self.m_tCallBack = {}

	self.m_tCallBack[1] = tCell
	self.m_tCallBack[2] = func
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellWakeupCoinUse:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
