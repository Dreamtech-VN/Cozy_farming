--CellDesignationOneData.lua
--@brief	CellDesignationOne的数据模块
--@date		2015/03/26
--@author	clc
--@note		成就系统-成就面板-主分类cell

CellDesignationOne = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellDesignationOne:_init()
	self.m_root       = nil  	--Cell的根节点
	self.n_JobId      = -1      --主成就Id
	self.m_bIsSelected  = nil	--是否选中状态
	self.n_CellType   = -1      --1为主分类，2为之分类。此Cell中永远是1
	self.n_CellPos    = -1      --cell在FreeListcontainer的位置   对应数据数组下标
	self.m_sName = nil 			--主成就名字
	self.m_nDoneNum = nil 		--已完成子成就数量
	self.m_nAllNum = nil 		--所有子成就数量
	self.m_bIsLoad = false 		
	self.m_bIsRedDotVisible = nil 	--红点是否可见
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellDesignationOne:_unInit()
	self.m_root      = nil      --Cell的根节点
	self.n_JobId     = nil        --主成就Id
	self.m_bIsSelected = nil	--是否选中状态
	self.n_CellType  = nil       --1为主分类，2为之分类。此Cell中永远是1
	self.n_CellPos   = nil       --cell在FreeListcontainer的位置    对应数据数组下标

	self.m_sName = nil 			--主成就名字
	self.m_nDoneNum = nil 		--已完成子成就数量
	self.m_nAllNum = nil 		--所有子成就数量
	self.m_bIsLoad = nil 
	self.m_bIsRedDotVisible = nil 	--红点是否可见
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellDesignationOne:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellDesignationOne table create failed!")
	tNewObj:_init()

	local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setName("__CellDesignationOne")
    element:setAbsContentSize(GlobalMethod:CCSize(120,52))
    element:setLuaObjectIndex(tNewObj)
    return element,tNewObj
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellDesignationOne:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
