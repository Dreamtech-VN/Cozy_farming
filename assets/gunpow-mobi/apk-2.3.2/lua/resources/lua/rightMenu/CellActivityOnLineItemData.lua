--CellActivityOnLineItemData.lua
--@brief	CellActivityOnLineItem的数据模块
--@date		2014/11/27
--@author	weidong_wu
--@note		列表选项

CellActivityOnLineItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellActivityOnLineItem:_init()
	self.m_root = nil  			--Cell的根节点
	self.n_CellItemId = 0		--选项Id
	self.b_isClicked = false	--是否点击过
	self.n_CellType = -1
	self.m_bIsLoad = false
	self.m_sName = nil 			--活动名称
	self.m_bIsNeedAddRedDot = nil --是否需要添加红点
	self.m_bIsHighLight = false 	--是否高亮
	self.n_fyberTime = 0
	self.m_bIsHotActivity = false --是否火爆活动
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellActivityOnLineItem:_unInit()
	self.m_root = nil
	self.n_CellItemId = nil		--选项Id
	self.b_isClicked = nil	--是否点击过
	self.n_CellType = nil
	self.m_bIsLoad = nil
	self.m_sName = nil 			--活动名称
	self.m_bIsNeedAddRedDot = nil --是否需要添加红点
	self.m_bIsHighLight = nil 	--是否高亮
	self.n_fyberTime = nil 
	self.m_bIsHotActivity = nil --是否火爆活动
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellActivityOnLineItem:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellActivityOnLineItem table create failed!")
	tNewObj:_init()
	
	local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setName("__CellActivityOnLineItem")
    element:setAbsContentSize(GlobalMethod:CCSize(212,65))
    element:setLuaObjectIndex(tNewObj)
    return element,tNewObj
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellActivityOnLineItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
