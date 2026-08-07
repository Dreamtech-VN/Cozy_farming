--CellKidBagItemData.lua
--@brief	CellKidBagItem的数据模块
--@date		2018/05/16
--@author	Tianxiang_Xu
--@note		小家商店

CellKidBagItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellKidBagItem:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil 
	self.m_nType = nil 			--物品类型
	self.m_nInterfaceType = nil 	--界面类型；1->家具;2->装饰;5->食物;7->背包
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellKidBagItem:_unInit()
	self.m_root = nil
	self.m_tData = nil 
	self.m_nType = nil 
	self.m_nInterfaceType = nil 	--界面类型；1->家具;2->装饰;5->食物;7->背包
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellKidBagItem:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellKidBagItem table create failed!")
	tNewObj:_init()

	local element = WZUIContainer:create()
	element:setAbsContentSize(GlobalMethod:CCSize(230, 240))
	element:setUseAbsSize(true)
	element:setName("__CellKidBagItem")
	element:setLuaObjectIndex(tNewObj)

	return element,tNewObj
end

--@brief 	设置数据
--@param 	nType : 1->建筑类;2->其他
function CellKidBagItem:setData(tData, nType, nInterfaceType)
	-- body
	self.m_tData = tData 
	self.m_nType = nType 
	self.m_nInterfaceType = nInterfaceType
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellKidBagItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
