--CellCheckOther9Data.lua
--@brief	CellCheckOther9的数据模块
--@date		2015/07/06
--@author	zsq
--@note		玩家信息栏2

CellCheckOther9 = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellCheckOther9:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tDataList = nil
	self.sureBtnState = nil
	self.m_sTitle = nil 
	self.m_nRowNum = 1 
	self.m_nType = nil					--1:坐骑栏,2:星魂栏,3:祈福,7:足迹打卡印记,8:贵族勋章
	self.m_nBtnTag = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellCheckOther9:_unInit()
	self.m_root = nil
	self.m_tDataList = nil
	self.sureBtnState = nil
	self.m_sTitle = nil 
	self.m_nRowNum = nil
	self.m_nType = nil
	self.m_nBtnTag = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellCheckOther9:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellCheckOther9 table create failed!")
	tNewObj:_init()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setName("__CellCheckOther9")
	element:setAbsContentSize(GlobalMethod:CCSize(482, 80))
	element:setLuaObjectIndex(tNewObj)

	return element,tNewObj
end

--@brief 	设置数据
function CellCheckOther9:setData(tData, nType, sTitle, nRowNum)
	-- body
	self.m_tDataList = tData
	self.m_nType = nType
	self.m_sTitle = sTitle 
	self.m_nRowNum = nRowNum
	-- if nType == 8 then 
	-- 	self.m_nRowNum = math.ceil(#self.m_tDataList.stage/6)
	-- else
	-- 	self.m_nRowNum = math.ceil(#tData/6)
	-- end

--	self:update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellCheckOther9:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
