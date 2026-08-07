--CellCheckOther10Data.lua
--@brief	CellCheckOther10的数据模块
--@date		2018/05/11
--@author	Tianxiang_Xu
--@note		个人信息祈福、修炼展示

CellCheckOther10 = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellCheckOther10:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tDataList = nil
	self.sureBtnState = nil
	self.m_tTempData = nil 
	self.m_tTempData2 = nil 
	self.m_sTitle = nil 
	self.m_nRowNum = 1
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellCheckOther10:_unInit()
	self.m_root = nil
	self.m_tDataList = nil
	self.sureBtnState = nil
	self.m_tTempData = nil 
	self.m_tTempData2 = nil 
	self.m_eleTitle = nil 
	self.m_sTitle = nil 
	self.m_nRowNum = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellCheckOther10:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellCheckOther10 table create failed!")
	tNewObj:_init()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setName("__CellCheckOther10")
	element:setAbsContentSize(GlobalMethod:CCSize(410, 90))
	element:setLuaObjectIndex(tNewObj)

	return element,tNewObj
end

--@brief 	设置数据
function CellCheckOther10:setData(tData, nType, tData1, sTitle, nRowNum)
	-- body
	self.m_tTempData = tData
	self.m_nType = nType
	self.m_tTempData2 = tData1
	self.m_sTitle = sTitle
	self.m_nRowNum = nRowNum
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellCheckOther10:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
