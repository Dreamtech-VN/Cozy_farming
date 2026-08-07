--CellCardItemData.lua
--@brief	CellCardItem的数据模块
--@date		2016/07/26
--@author	Tianxiang_Xu
--@note		卡牌系统-卡片

CellCardItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellCardItem:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil 
	self.m_tCallBack = nil 		--回调函数列表
	self.m_relativePosition = nil 	

	self.m_bCreateOther = false
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellCardItem:_unInit()
	self.m_root = nil
	self.m_tData = nil 
	self.m_tCallBack = nil 
	self.m_relativePosition = nil 	

	self.m_bCreateOther = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellCardItem:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellCardItem table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellCardItem")
	assert(element, "CellCardItem element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief 	设置数据
function CellCardItem:setData(tData)
	-- body
	self.m_tData = tData
	
	self:_update()
end

--@brief 	设置点击回调函数
function CellCardItem:setCallBackFunc(tCell, func)
	-- body
	if self.m_tCallBack == nil then
		self.m_tCallBack = {}
	end

	self.m_tCallBack[1] = tCell
	self.m_tCallBack[2] = func
end

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellCardItem:createElementOther()
	local tNewObj = self:_new()
	assert(tNewObj, "CellCardItem table create failed!")
	tNewObj:_init()
	local element = WZUIContainer:create()
	element:setName("__CellCardItem")
	element:setAbsContentSize(GlobalMethod:CCSize(116,150))
	element:setUseAbsSize(true)
	element:setLuaObjectIndex(tNewObj)

	tNewObj.m_bCreateOther = true

	return element,tNewObj
end

--@brief 	设置数据
function CellCardItem:setDataOther(tData, relativePosition)
	-- body
	self.m_tData = tData
	self.m_relativePosition = relativePosition 	
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellCardItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
