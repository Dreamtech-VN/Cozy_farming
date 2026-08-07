--CellMagicStoneShopData.lua
--@brief	CellMagicStoneShop的数据模块
--@date		2019/10/24
--@author	Tianxiang_Xu
--@note		幻石系统-商店

CellMagicStoneShop = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellMagicStoneShop:_init()
	self.m_root = nil  			--Cell的根节点
	self.tData = {}
    self.cell = {}
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellMagicStoneShop:_unInit()
	self.m_root = nil
	self.tData = nil
    self.cell = nil
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellMagicStoneShop:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellMagicStoneShop table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellMagicStoneShop")
	assert(element, "CellMagicStoneShop element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

function CellMagicStoneShop:setData(data)
    self.tData = data
    self:_update()
end

--@brief 	获取商品Id
function CellMagicStoneShop:getShopId()
	-- body
	return self.tData.id
end

--@brief 	更新数量
function CellMagicStoneShop:updateGoodNum(marketNum)
	-- body
	WZLog("CellMagicStoneShop:updateGoodNum", marketNum)
	self.tData.marketNum = marketNum 

	self:_update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellMagicStoneShop:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
