--CellOnlineHintFriendData.lua
--@brief	CellOnlineHintFriend的数据模块
--@date		2016/04/29
--@author	Tianxiang_Xu
--@note		好友上线提示子项

CellOnlineHintFriend = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellOnlineHintFriend:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tFriend = nil 
	self.m_tCallBack = nil
	self.m_nType = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellOnlineHintFriend:_unInit()
	self.m_root = nil
	self.m_tFriend = nil
	self.m_tCallBack = nil
	self.m_nType = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellOnlineHintFriend:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellOnlineHintFriend table create failed!")
	tNewObj:_init()

	local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setName("__CellOnlineHintFriend")
    element:setAbsContentSize(GlobalMethod:CCSize(726,75))
    element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end

--@brief 	設置cell数据
function CellOnlineHintFriend:setCellData(tData, nType)
	--body
	WZLog("CellOnlineHintFriend:setCellData")
	self.m_tFriend = tData
	self.m_nType = nType 
end

--@brief 	设置回调函数
function CellOnlineHintFriend:setBackFun(tCell, backFunc, backFunc2)
	-- body
	self.m_tCallBack = {}

	self.m_tCallBack[1] = tCell
	self.m_tCallBack[2] = backFunc
	self.m_tCallBack[3] = backFunc2
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellOnlineHintFriend:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
