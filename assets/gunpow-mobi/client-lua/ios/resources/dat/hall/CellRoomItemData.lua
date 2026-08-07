--CellRoomItemData.lua
--@brief	CellRoomItem的数据模块
--@date		2013/12/18
--@author	李光森
--@note		游戏大厅中房间列表中的项

CellRoomItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellRoomItem:_init()
	self.m_root = nil  			--Cell的根节点
    self.m_lpClickCallback = nil  --外部回调函数
	self.m_tCallbackTable = nil	--回调表
    self.m_tData = nil          --cell的数据
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellRoomItem:_unInit()
	self.m_root = nil
    self.m_lpClickCallback = nil
	self.m_tCallbackTable = nil
    self.m_tData = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellRoomItem:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellRoomItem table create failed!")
	tNewObj:_init()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(454,64))   --这个容器的大小要和cell的大小一致
	element:setLuaObjectIndex(tNewObj)
	return element,tNewObj

--	local tNewObj = self:_new()
--	assert(tNewObj, "CellRoomItem table create failed!")
--	tNewObj:_init()
--	local element = WZUISystem:getInstance():createElement("CellRoomItem")
--	assert(element, "CellRoomItem element create failed!")
--	element:setLuaObjectIndex(tNewObj)
--	tNewObj.m_root = element
--	return element,tNewObj
end

--@brief	设置点击回调函数
--@param	callback:回调函数引用,可置空
--@param	tLuaObj:回调函数所属表对象
--@note		主要用于点击时外部的回调用
function CellRoomItem:setClickCallback(callback,tLuaObj)
    self.m_lpClickCallback = callback
	self.m_tCallbackTable = tLuaObj
end

--@brief	设置cell数据
function CellRoomItem:setData(data)
    self.m_tData = data
	--self:_update()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellRoomItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------