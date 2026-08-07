--CellMultiVideoData.lua
--@brief	CellMultiVideo的数据模块
--@date		2016-6-12
--@author	binshao
--@note		组队副本录像单元格

CellMultiVideo = {
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellMultiVideo:_init()
	self.m_root = nil  			--Cell的根节点
	self.data = nil
	self.loadEnd = false
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellMultiVideo:_unInit()
	self.m_root = nil
	self.data = nil
	self.loadEnd = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellMultiVideo:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellMultiVideo table create failed!")
	tNewObj:_init()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(536,110))   --这个容器的大小要和cell的大小一致
	element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end

--@brief	设置数据
function CellMultiVideo:setData(tData)
    self.data = tData
end

-------------------------------------公有方法模块End----------------------------------------
-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellMultiVideo:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
-------------------------------------私有方法模块End----------------------------------------