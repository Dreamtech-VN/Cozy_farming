--CellFamilyRankNewData.lua
--@brief	CellFamilyRankNew的数据模块
--@date		2018/02/23
--@author	Tianxiang_Xu
--@note		家园排名新Cell

CellFamilyRankNew = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellFamilyRankNew:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_nType = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellFamilyRankNew:_unInit()
	self.m_root = nil
	self.m_nType = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellFamilyRankNew:createElement(conSize)
	local tNewObj = self:_new()
	assert(tNewObj, "CellFamilyRankNew table create failed!")
	tNewObj:_init()
	local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setName("__CellFamilyRankNew")          --用于在表的外面，通过名字获取对应的表结构
    conSize = conSize or GlobalMethod:CCSize(374,90)
    element:setAbsContentSize(conSize)   --这个容器的大小要和cell的大小一致
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellFamilyRankNew:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
