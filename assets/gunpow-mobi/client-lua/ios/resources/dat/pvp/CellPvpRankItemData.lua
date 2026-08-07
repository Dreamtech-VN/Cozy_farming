--CellPvpRankItemData.lua
--@brief	CellPvpRankItem的数据模块
--@date		2017/01/12
--@author	Tianxiang_Xu
--@note		排位赛奖励面板排行

CellPvpRankItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellPvpRankItem:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellPvpRankItem:_unInit()
	self.m_root = nil
	self.m_tData = nil 
end

function CellPvpRankItem:setData(tData)
	-- body
	self.m_tData = tData
end
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellPvpRankItem:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellPvpRankItem table create failed!")
	tNewObj:_init()

	local element = WZUIContainer:create()
	element:setName("__CellPvpRankItem")
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(726,114))
	element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellPvpRankItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
