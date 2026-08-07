--CellDropListData.lua
--@brief	CellDropList的数据模块
--@date		2015/04/15
--@author	xiaoyu_wu
--@note		掉落列表

CellDropList = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellDropList:_init()
	self.m_root = nil  			--Cell的根节点
    
    self.m_tData = nil          --数据表
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellDropList:_unInit()
	self.m_root = nil
    
    self.m_tData = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellDropList:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellDropList table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellDropList")
	assert(element, "CellDropList element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief	设置数据表
--@param    tData:数据表
function CellDropList:setData(tData)
    self.m_tData = tData
	self._updateDropList()
end

--@brief	获取数据表
--@return   #1,数据表
function CellDropList:getData()
    return self.m_tData
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellDropList:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
