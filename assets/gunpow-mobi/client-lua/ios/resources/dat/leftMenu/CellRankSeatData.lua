--CellRankSeatData.lua
--@brief	CellRankSeat的数据模块
--@date		2015/09/17
--@author	Tianxiang_Xu
--@note		排行榜人物格子

CellRankSeat = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellRankSeat:_init()
	self.m_root = nil  			--Cell的根节点

	self.m_tPlayerAni = nil 	
	self.m_tParentWnd = nil
	self.m_tData = nil 
	self.m_nType = nil 			--排行類型
	self.m_parentNodeForTips = nil 	--宠物Tips的父节点
	self.m_nCanWorship = nil 	--是否可膜拜
	self.m_nLoadingId = nil 
	self.m_bIsLightHide = false -- 当选中人物的时候，是否隐藏掉光线
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellRankSeat:_unInit()
	self.m_root = nil

	self.m_tPlayerAni = nil
	self.m_tParentWnd = nil
	self.m_tData = nil
	self.m_nType = nil 			--排行類型
	self.m_parentNodeForTips = nil 	--宠物Tips的父节点
	self.m_nCanWorship = nil 	--是否可膜拜
	self.m_nLoadingId = nil
	self.m_bIsLightHide = nil -- 当选中人物的时候，是否隐藏掉光线
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellRankSeat:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellRankSeat table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellRankSeat")
	assert(element, "CellRankSeat element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellRankSeat:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
