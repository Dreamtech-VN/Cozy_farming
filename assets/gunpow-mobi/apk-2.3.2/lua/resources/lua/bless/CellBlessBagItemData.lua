--CellBlessBagItemData.lua
--@brief	CellBlessBagItem的数据模块
--@date		2021/07/28
--@author	yrd
--@note		祈福背包格子

CellBlessBagItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellBlessBagItem:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil			--祈福数据
	self.m_tClickCallback = nil		--点击祈福回调方法
	self.m_nChooseNum = 0 			--选中数量
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellBlessBagItem:_unInit()
	self.m_root = nil
	self.m_tData = nil			--祈福数据
	self.m_tClickCallback = nil		--点击祈福回调方法
	self.m_nChooseNum = nil 		--选中数量
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellBlessBagItem:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellBlessBagItem table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellBlessBagItem")
	assert(element, "CellBlessBagItem element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief	设置数据
function CellBlessBagItem:setData(tData)
	self.m_tData = tData

	self:updateUI()
end

function CellBlessBagItem:getData()
	return self.m_tData
end

--@brief	设置点击回调方法
function CellBlessBagItem:setClickCallback(tLuaObj, callback)
	self.m_tClickCallback = {}
	if tLuaObj and callback then
		self.m_tClickCallback[1] = tLuaObj
		self.m_tClickCallback[2] = callback
	end
end

-- --@brief 	设置吞噬界面点击祝福回调方法
-- function CellBlessItem:setDevourCallBackFun(tLuaObj, callback)
-- 	self.m_tDevourCallBack = {}
-- 	if tLuaObj and callback then
-- 		self.m_tDevourCallBack[1] = tLuaObj
-- 		self.m_tDevourCallBack[2] = callback
-- 	end
-- end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellBlessBagItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
