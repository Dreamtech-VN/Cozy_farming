--CellCommunityShopData.lua
--@brief	CellCommunityShop的数据模块
--@date		2015/04/28
--@author	zsq
--@note		公会商店Cell

CellCommunityShop = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellCommunityShop:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_nID = nil
	self.m_nNum = nil
	self.m_nCost = nil
	self.m_nGuildLevel = nil
	self.m_tItemInfo = nil
	self.m_nCostId = nil
	self.m_nCostCount = nil 
	self.m_nDiscount = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellCommunityShop:_unInit()
	self.m_root = nil
	self.m_nID = nil
	self.m_nNum = nil
	self.m_nCost = nil
	self.m_nGuildLevel = nil
	self.m_tItemInfo = nil
	self.m_nCostId = nil
	self.m_nCostCount = nil 
	self.m_nDiscount = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellCommunityShop:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellCommunityShop table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellCommunityShop")
	assert(element, "CellCommunityShop element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellCommunityShop:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
