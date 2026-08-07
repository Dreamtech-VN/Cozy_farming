--CellPetFetterItemData.lua
--@brief	CellPetFetterItem的数据模块
--@date		2019/01/26
--@author	Tianxiang_Xu
--@note		宠物羁绊列表

CellPetFetterItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellPetFetterItem:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellPetFetterItem:_unInit()
	self.m_root = nil
	self.m_tData = nil 
end

--@brief 	设置数据
function CellPetFetterItem:setData(tData)
	-- body
	self.m_tData = tData

	self:_update()
end
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellPetFetterItem:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellPetFetterItem table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellPetFetterItem")
	assert(element, "CellPetFetterItem element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellPetFetterItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
