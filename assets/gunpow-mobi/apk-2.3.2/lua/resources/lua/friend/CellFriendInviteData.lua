--CellFriendInviteData.lua
--@brief	CellFriendInvite的数据模块
--@date		2016/06/07
--@author	Tianxiang_Xu
--@note		邀请码好友子项

CellFriendInvite = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellFriendInvite:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tFriend = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellFriendInvite:_unInit()
	self.m_root = nil
	self.m_tFriend = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellFriendInvite:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellFriendInvite table create failed!")
	tNewObj:_init()
	
	local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setName("__CellFriendInvite")
    element:setAbsContentSize(GlobalMethod:CCSize(296,106))
    element:setLuaObjectIndex(tNewObj)
    return element,tNewObj
end

--@brief 	设置cell的数据
function CellFriendInvite:setData(tData)
	-- body
	WZLog("邀请码好友数据",Serialize(tData))
	self.m_tFriend = tData
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellFriendInvite:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
