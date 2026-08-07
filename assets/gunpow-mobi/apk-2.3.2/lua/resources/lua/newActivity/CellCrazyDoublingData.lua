--CellCrazyDoublingData.lua
--@brief	CellCrazyDoubling的数据模块
--@date		2020/07/30
--@author	yrd
--@note		疯狂翻倍子项

CellCrazyDoubling = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellCrazyDoubling:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil
	self.m_tCallbackFunc = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellCrazyDoubling:_unInit()
	self.m_root = nil
	self.m_tData = nil
	self.m_tCallbackFunc = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellCrazyDoubling:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellCrazyDoubling table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellCrazyDoubling")
	assert(element, "CellCrazyDoubling element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

function CellCrazyDoubling:setData(tData)
	self.m_tData = tData

	self:initUI()
end

function CellCrazyDoubling:setClickCallback(callbackLua,callbackFun)
	self.m_tCallbackFunc = {}
	if callbackLua and callbackFun then
		self.m_tCallbackFunc[1] = callbackLua
		self.m_tCallbackFunc[2] = callbackFun
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellCrazyDoubling:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
