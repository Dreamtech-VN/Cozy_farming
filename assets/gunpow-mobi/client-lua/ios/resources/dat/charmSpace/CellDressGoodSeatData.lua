--CellDressGoodSeatData.lua
--@brief	CellDressGoodSeat的数据模块
--@date		2019/06/03
--@author	Tianxiang_Xu
--@note		时装点赞-玩家形象UI

CellDressGoodSeat = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellDressGoodSeat:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_nType = nil 			--形象类型
	self.m_tData = nil 
	self.m_bIsLoaded = false
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellDressGoodSeat:_unInit()
	self.m_root = nil
	self.m_nType = nil 			--形象类型
	self.m_tData = nil 
	self.m_bIsLoaded = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellDressGoodSeat:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellDressGoodSeat table create failed!")
	tNewObj:_init()

	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setName("__CellDressGoodSeat")
	element:setAbsContentSize(GlobalMethod:CCSize(206,340))
	element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellDressGoodSeat:createElement2()
	local tNewObj = self:_new()
	assert(tNewObj, "CellDressGoodSeat table create failed!")
	tNewObj:_init()

	local element = WZUISystem:getInstance():createElement("CellDressGoodSeat")
	assert(element, "CellDressGoodSeat element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief 	设置数据
--@param 	nType : 0->报名；1->推荐；2->历届
function CellDressGoodSeat:setData(tData, nType)
	-- body
	self.m_tData = tData
	self.m_nType = nType
end

--@brief 	设置数据
--@param 	nType : 0->报名；1->推荐；2->历届
function CellDressGoodSeat:setData2(tData, nType)
	-- body
	self.m_tData = tData
	self.m_nType = nType

	self.m_bIsLoaded = true
	self:_update()
end

--@brief 	获取玩家Id
function CellDressGoodSeat:getPlayerId()
	-- body
	return self.m_tData.id
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellDressGoodSeat:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
