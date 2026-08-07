--CellGoodsListBigData.lua
--@brief	CellGoodsListBig的数据模块
--@date		2016-12-7
--@author	binshao

CellGoodsListBig = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellGoodsListBig:_init()
	
	self.m_root = nil       --Cell的根节点
	self.cellData =  nil    --商品路径
    self.goodItemCell = nil
	self.isDress = false		-- 是否是时装
	self.loadEnd = false
	self.tryState = false		-- 试穿状态
	self.selState = false		-- 选中状态
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellGoodsListBig:_unInit()
	self.m_root = nil
	self.cellData =  nil
    self.goodItemCell = nil
	self.isDress = false		-- 是否是时装
	self.loadEnd = false
	self.tryState = false
	self.selState = false
end


-------------------------------------公有方法模块--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellGoodsListBig:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellGoodsListBig table create failed!")
	tNewObj:_init()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(240,200))   --这个容器的大小要和cell的大小一致
	element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end


-------------------------------------私有方法模块--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellGoodsListBig:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end