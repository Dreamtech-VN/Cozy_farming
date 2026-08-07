--CellSignItemsData.lua
--@brief	CellSignItems的数据模块
--@date		2014/01/21
--@author	SuYuan
--@note		每日签到奖励物品

CellSignItems = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellSignItems:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_itemElement1 = nil	--物品1节点对象
	self.m_itemLuaObj1 = nil	--物品1Lua表对象
	self.m_itemElement2 = nil	--物品2节点对象
	self.m_itemLuaObj2 = nil	--物品2Lua表对象
	self.m_itemElement3 = nil	--物品3节点对象
	self.m_itemLuaObj3 = nil	--物品3Lua表对象
	self.scaleFromLanguage = {}			--存放不同的语言缩放比例表
	self.scaleFromLanguage.pt = 0.65
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellSignItems:_unInit()
	self.m_root = nil
	self.m_itemElement1 = nil
	self.m_itemLuaObj1 = nil
	self.m_itemElement2 = nil
	self.m_itemLuaObj2 = nil
	self.m_itemElement3 = nil
	self.m_itemLuaObj3 = nil
	self.scaleFromLanguage = nil

end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellSignItems:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellSignItems table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellSignItems")
	assert(element, "CellSignItems element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellSignItems:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
