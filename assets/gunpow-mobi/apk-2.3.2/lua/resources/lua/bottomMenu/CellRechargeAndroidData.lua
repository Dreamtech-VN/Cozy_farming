--CellRechargeAndroidData.lua
--@brief	CellRechargeAndroid的数据模块
--@date		2014/08/13
--@author	Android充值模块
--@note		Android充值模块

CellRechargeAndroid = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellRechargeAndroid:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_nDesc = nil 			--数据列表
	self.m_tBackFun = nil		--回调函数列表
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellRechargeAndroid:_unInit()
	self.m_root = nil
	self.m_nDesc = nil 			--数据列表
	self.m_tBackFun = nil		--回调函数列表
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellRechargeAndroid:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellRechargeAndroid table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellRechargeAndroid")
	assert(element, "CellRechargeAndroid element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief	获取表参数
function CellRechargeAndroid:setCellData(data)
	self.m_nDesc = data 			--数据列表
	self:_update()
end

--@brief	设置回调函数
--@param	tCell:回调的表
--@param	backFun:回调函数名
function CellRechargeAndroid:setBackFun(tCell,backFun)
	if tCell and backFun then
		self.m_tBackFun = {}
		table.insert(self.m_tBackFun,tCell)
		table.insert(self.m_tBackFun,backFun)
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellRechargeAndroid:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--@brief	设置文本
--@param	tCell:表绑定的UI节点引用
--@param	txt:显示的内容
function CellRechargeAndroid:_setTxtProperty(tCell,txt)
	if self.m_root == nil or tCell == nil then
		return
	end
	tCell = WZUILabelTTF:luaTo(tCell)
	tCell:setText(txt)
end

-------------------------------------私有方法模块End----------------------------------------
