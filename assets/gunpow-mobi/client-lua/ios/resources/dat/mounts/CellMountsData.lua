--CellMountsData.lua
--@brief	CellMounts的数据模块
--@date		2015-8-12
--@author	binshao
--@note		坐骑的cell

CellMounts = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellMounts:_init()
	self.m_root = nil  		--Cell的根节点
	self.tData = {}         --坐骑的信息
	self.loadEnd = false	-- 是否加载完成
	self.selState = false	-- 设置选中状态
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellMounts:_unInit()
	WZLog("CellMounts:_unInit")
	self.m_root = nil
	self.tData = nil
	self.loadEnd = false
	self.selState = false
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellMounts:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellMounts table create failed!")
	tNewObj:_init()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(450,100))   --这个容器的大小要和cell的大小一致
	element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end


-- 设置cell中的内容
function CellMounts:setCellAllElement(tInfo)
    self.tData = tInfo
    --self:_update()
end

function CellMounts:updateData(tInfo)
	self.tData = tInfo
	self:_update()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellMounts:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------