--CellGuildVSRecordData.lua
--@brief	CellGuildVSRecord的数据模块
--@date		2017/02/28
--@author	Tianxiang_Xu
--@note		比赛回顾列表

CellGuildVSRecord = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellGuildVSRecord:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil 
	self.m_nGroupLeftId = nil 
	self.m_nGroupRightId = nil 
	self.m_tCallBack = nil 
	self.m_nRaceMark = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellGuildVSRecord:_unInit()
	self.m_root = nil
	self.m_tData = nil 
	self.m_nGroupLeftId = nil 
	self.m_nGroupRightId = nil 
	self.m_tCallBack = nil 
	self.m_nRaceMark = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellGuildVSRecord:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellGuildVSRecord table create failed!")
	tNewObj:_init()
	local element = WZUIContainer:create()
	element:setName("__CellGuildVSRecord")
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(725,100))
	element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end


--@brief 	设置数据
function CellGuildVSRecord:setData(tData1, tData2, nGroupLeftId, nGroupRightId, nRaceMark)
	-- body
	self.m_tData = {}
	self.m_tData[1] = tData1
	self.m_tData[2] = tData2
	self.m_nGroupLeftId = nGroupLeftId 
	self.m_nGroupRightId = nGroupRightId 
	self.m_nRaceMark = nRaceMark 
end

--@brief 	设置回调函数
function CellGuildVSRecord:setCallBackFunc(tCell, func1, func2)
	-- body
	if self.m_tCallBack == nil then
		self.m_tCallBack = {}
	end

	self.m_tCallBack[1] = tCell
	self.m_tCallBack[2] = func1
	self.m_tCallBack[3] = func2
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellGuildVSRecord:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
