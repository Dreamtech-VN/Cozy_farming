--CellCommunityInfoListData.lua
--@brief	CellCommunityInfoList的数据模块
--@date		2013/12/25
--@author	林庆凯
--@note		创建公会信息的列表

CellCommunityInfoList = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellCommunityInfoList:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_nTime = nil 
	self.m_nLastTime = nil 
	self.m_sLog = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellCommunityInfoList:_unInit()
	self.m_root = nil
	self.m_nTime = nil 
	self.m_nLastTime = nil 
	self.m_sLog = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellCommunityInfoList:createElement(conSize)
	local tNewObj = self:_new()
	assert(tNewObj, "CellCommunityInfoList table create failed!")
	tNewObj:_init()

	local element = WZUIContainer:create()
	element:setName("__CellCommunityInfoList")
	element:setUseAbsSize(true)
	element:setAbsContentSize(conSize or GlobalMethod:CCSize(878,55))
	element:setLuaObjectIndex(tNewObj)

	return element,tNewObj
end

--@brief 	设置数据
function CellCommunityInfoList:setLog(log, time, lastTime)
	self.m_nTime = time 
	self.m_nLastTime = lastTime 
	self.m_sLog = log 
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellCommunityInfoList:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
