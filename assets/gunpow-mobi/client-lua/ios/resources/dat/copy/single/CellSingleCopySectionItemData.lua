--CellSingleCopySectionItemData.lua
--@brief	CellSingleCopySectionItem的数据模块
--@date		2019/06/13
--@author	Tianxiang_Xu
--@note		章节名字cell

CellSingleCopySectionItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellSingleCopySectionItem:_init()
	self.m_root = nil  			--Cell的根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellSingleCopySectionItem:_unInit()
	self.m_root = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellSingleCopySectionItem:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellSingleCopySectionItem table create failed!")
	tNewObj:_init()

	local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setAbsContentSize(GlobalMethod:CCSize(160, 35))   --这个容器的大小要和cell的大小一致
    element:setLuaObjectIndex(tNewObj)

	return element,tNewObj
end

--@brief	设置数据
--@param    tData,数据表
--@note     请先调用本方法设置数据后再调用setCellElement方法加进tableContainer
function CellSingleCopySectionItem:setData(tData)
    self.m_tData = tData
end

--@brief	获取数据表
--@return   #1,数据表
function CellSingleCopySectionItem:getData()
    return self.m_tData
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellSingleCopySectionItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
