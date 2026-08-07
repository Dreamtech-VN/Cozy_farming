--CellDigGemRemainsData.lua
--@brief	CellDigGemRemains的数据模块
--@date		2019/07/03
--@author	yrd
--@note		挖宝系统-遗迹之光

CellDigGemRemains = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellDigGemRemains:_init()
	self.m_root = nil  			--Cell的根节点
	self.tData = nil
	self.m_bShareCD = false				--是否分享cd
	self.m_nShareTime = 0				--分享cd时间
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellDigGemRemains:_unInit()
	self.m_root = nil
	self.tData = nil
	self.m_bShareCD = nil				--是否分享cd
	self.m_nShareTime = nil				--分享cd时间
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellDigGemRemains:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellDigGemRemains table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellDigGemRemains")
	assert(element, "CellDigGemRemains element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

function CellDigGemRemains:setData(tData)	
	self.tData = tData
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellDigGemRemains:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
