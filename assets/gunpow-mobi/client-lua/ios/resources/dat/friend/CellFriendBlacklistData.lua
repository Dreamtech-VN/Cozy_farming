--CellFriendBlacklistData.lua
--@brief	CellFriendBlacklist的数据模块
--@date		2018/04/19
--@author	Tianxiang_Xu
--@note		黑名单

CellFriendBlacklist = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellFriendBlacklist:_init()
	self.m_root = nil  			--Cell的根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellFriendBlacklist:_unInit()
	self.m_root = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellFriendBlacklist:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellFriendBlacklist table create failed!")
	tNewObj:_init()
	
	local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setName("__CellFriendBlacklist")
    element:setAbsContentSize(GlobalMethod:CCSize(752,106))
    element:setLuaObjectIndex(tNewObj)

	return element,tNewObj
end

--@brief	获取好友列表数据
function CellFriendBlacklist:setCellData(tFriend)
	self.m_tFriend = tFriend
end

--@brief	设置获得函数
--@param	tCell:表名
--@param	backFun:回调函数
function CellFriendBlacklist:setBackFun(tCell , backFun,recvBackFun)
	if tCell == nil or backFun == nil then
		return
	end
	self.m_tBackFun = {}
	self.m_tBackFun[1] = tCell
	self.m_tBackFun[2] = backFun
	self.m_tBackFun[3] = recvBackFun
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellFriendBlacklist:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
