--CellPetRaffleData.lua
--@brief	CellPetRaffle的数据模块
--@date		2015/09/22
--@author	zhangming
--@note		宠物抽奖宠物

CellPetRaffle = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellPetRaffle:_init()
	self.m_root = nil  			--Cell的根节点
	self.t_data = {}			--数据信息
	self.n_type = 0             --抽奖方式，0为普通抽奖，1为钻石抽奖，2为10连抽
	self.n_px = 0
	self.n_py = 0
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellPetRaffle:_unInit()
	self.m_root = nil
	self.t_data = nil
	self.n_type = nil
	self.n_px = nil
	self.n_py = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellPetRaffle:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellPetRaffle table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellPetRaffle")
	assert(element, "CellPetRaffle element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellPetRaffle:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
