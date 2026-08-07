--CellLeagueMatch2Data.lua
--@brief	CellLeagueMatch2的数据模块
--@date		2016/06/12
--@author	zsq
--@note		十六强匹配

CellLeagueMatch2 = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellLeagueMatch2:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil
	self.m_nRound = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellLeagueMatch2:_unInit()
	self.m_root = nil
	self.m_tData = nil
	self.m_nRound = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellLeagueMatch2:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellLeagueMatch2 table create failed!")
	tNewObj:_init()
    --local element = WZUIContainer:create()
    --element:setUseAbsSize(true)
    --element:setName("__CellLeagueMatch2")          --用于在表的外面，通过名字获取对应的表结构
    --element:setAbsContentSize(GlobalMethod:CCSize(600,105))   --这个容器的大小要和cell的大小
	local element = WZUISystem:getInstance():createElement("CellLeagueMatch2")
	assert(element, "CellLeagueMatch1 element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellLeagueMatch2:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
