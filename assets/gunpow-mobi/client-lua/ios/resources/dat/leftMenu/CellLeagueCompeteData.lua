--CellLeagueCompeteData.lua
--@brief	CellLeagueCompete的数据模块
--@date		2016/06/29
--@author	Tianxiang_Xu
--@note		英雄联赛入口

CellLeagueCompete = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellLeagueCompete:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_nStartTime = nil 	--开始时间
	self.m_nEndTime = nil 	--结束时间
	self.m_nType 	= nil 	--赛程类型（0：敬请期待；1：海选赛进行中；2:小组赛进行中；3：十六强进行中；4:八强决赛进行中）
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellLeagueCompete:_unInit()
	self.m_root = nil
	self.m_nStartTime = nil 	--开始时间
	self.m_nEndTime = nil 	--结束时间
	self.m_nType 	= nil 	--赛程类型
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellLeagueCompete:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellLeagueCompete table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellLeagueCompete")
	assert(element, "CellLeagueCompete element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellLeagueCompete:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
