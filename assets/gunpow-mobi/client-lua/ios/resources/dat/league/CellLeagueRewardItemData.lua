--CellLeagueRewardItemData.lua
--@brief	CellLeagueRewardItem的数据模块
--@date		2016/06/15
--@author	Tianxiang_Xu
--@note		英雄联赛-奖励列表项

CellLeagueRewardItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellLeagueRewardItem:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil 
	self.m_bIsLoaded = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellLeagueRewardItem:_unInit()
	self.m_root = nil
	self.m_tData = nil
	self.m_bIsLoaded = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellLeagueRewardItem:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellLeagueRewardItem table create failed!")
	tNewObj:_init()
	
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setName("__CellLeagueRewardItem")
	element:setAbsContentSize(GlobalMethod:CCSize(673,98))
	element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end

--@brief 	设置数据
function CellLeagueRewardItem:setData(tData)
	-- body
	self.m_tData = tData
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellLeagueRewardItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
