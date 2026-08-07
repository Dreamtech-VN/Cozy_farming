--CellMasterReward1Data.lua
--@brief	CellMasterReward1的数据模块
--@date		2015/05/29
--@author	zsq
--@note		徒弟奖励单元格

CellMasterReward1 = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellMasterReward1:_init()
	self.m_root = nil  			--Cell的根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellMasterReward1:_unInit()
	self.m_root = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellMasterReward1:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellMasterReward1 table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellMasterReward1")
	assert(element, "CellMasterReward1 element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellMasterReward1:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
