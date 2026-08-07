--CellPopupMenuData.lua
--@brief	CellPopupMenu的数据模块
--@date		2013/12/11
--@author	xiaoyu_wu
--@note		弹出菜单的选项单元格模块

CellPopupMenu = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellPopupMenu:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_nId = nil			--菜单选项Id
	self.m_tMenu = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellPopupMenu:_unInit()
	self.m_root = nil
	self.m_nId = nil
	self.m_tMenu = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellPopupMenu:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellPopupMenu table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellPopupMenu")
	assert(element, "CellPopupMenu element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief	设置弹出菜单选项Id
--@param	nId，选项的Id
--@note		Id定义参见GlobalDefine中POPUPMENU相关定义
function CellPopupMenu:setMenuItemID(nId,tMenu)
	self.m_nId = nId
	self.m_tMenu = tMenu
	self:_update()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellPopupMenu:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
