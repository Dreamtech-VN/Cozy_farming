--CellBlessShopData.lua
--@brief	CellBlessShop的数据模块
--@date		2016/04/12
--@author	Tianxiang_Xu
--@note		祈福商店格子

CellBlessShop = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellBlessShop:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil 
	self.m_tCallBack = nil 		
	self.m_tTipParentNode = nil 	--节点tips框父节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellBlessShop:_unInit()
	self.m_root = nil
	self.m_tData = nil 	
	self.m_tCallBack = nil
	self.m_tTipParentNode = nil 	--节点tips框父节点
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellBlessShop:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellBlessShop table create failed!")
	tNewObj:_init()
	
	local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setName("__CellBlessShop")
    element:setAbsContentSize(GlobalMethod:CCSize(175,183))
    element:setLuaObjectIndex(tNewObj)
    return element,tNewObj
end

--@brief 	设置数据
function CellBlessShop:setData(tData, parentNode)
	-- body
	self.m_tData = tData
	self.m_tTipParentNode = parentNode

--	self:_update()
end

--@brief 	设置点击回调
--@param 	tCell:表对象
--@param 	func:回调方法
function CellBlessShop:setCallBackFun(tCell, func)
	--body
	if self.m_tCallBack == nil then
		self.m_tCallBack = {}
	end

	self.m_tCallBack[1] = tCell
	self.m_tCallBack[2] = func
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellBlessShop:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
