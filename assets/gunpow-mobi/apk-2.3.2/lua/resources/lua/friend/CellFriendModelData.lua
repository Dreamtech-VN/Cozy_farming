--CellFriendModelData.lua
--@brief	CellFriendModel的数据模块
--@date		2021/07/27
--@author	hyc
--@note		好友格子

CellFriendModel = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellFriendModel:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil
	self.m_tPlayerAni = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellFriendModel:_unInit()
	self.m_root = nil
	self.m_tData = nil
	self.m_tPlayerAni = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellFriendModel:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellFriendModel table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellFriendModel")
	assert(element, "CellFriendModel element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end


function CellFriendModel:setData( tData )
	-- body Serialize
	WZLog("CellFriendModel:setData",Serialize(tData))
	self.m_tData = tData
	self:upDateShow()
	self:showModel()
end

--@brief 	获取玩家Id
function CellFriendModel:getFriendId()
	-- body
	return self.m_tData.id
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellFriendModel:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
