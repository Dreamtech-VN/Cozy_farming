--CellShopFriendData.lua
--@brief	CellShopFriend的数据模块
--@date		2016-4-24
--@author	binshao
--@note		商城赠送好友列表cell

CellShopFriend = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellShopFriend:_init()
	self.m_root = nil       --Cell的根节点
	self.data =  nil
	self.selState = false
	self.loadEnd = false
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellShopFriend:_unInit()
	self.m_root = nil
	self.data =  nil
	self.selState = false
	self.loadEnd = false
end


-------------------------------------公有方法模块--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellShopFriend:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellShopFriend table create failed!")
	tNewObj:_init()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(344,94))   --这个容器的大小要和cell的大小一致
	element:setLuaObjectIndex(tNewObj)
	return element,tNewObj

--	local tNewObj = self:_new()
--	assert(tNewObj, "CellShopFriend table create failed!")
--	tNewObj:_init()
--	local element = WZUISystem:getInstance():createElement("CellShopFriend")
--	assert(element, "CellShopFriend element create failed!")
--	element:setLuaObjectIndex(tNewObj)
--	return element,tNewObj
end


-------------------------------------私有方法模块--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellShopFriend:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-- 设置好友的数据
function CellShopFriend:setData(data)
	self.data = data
	--self:_update()
end