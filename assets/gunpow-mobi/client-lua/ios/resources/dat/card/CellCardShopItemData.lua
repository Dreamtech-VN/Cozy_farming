--CellCardShopItemData.lua
--@brief	CellCardShopItem的数据模块
--@date		2016/07/26
--@author	Tianxiang_Xu
--@note		卡牌系统-卡片

CellCardShopItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellCardShopItem:_init()
	self.m_root = nil  			    --Cell的根节点
    self.tData = {}
    self.cell = {}
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellCardShopItem:_unInit()
	self.m_root = nil
    self.tData = nil
    self.cell = nil
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellCardShopItem:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellCardShopItem table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellCardShopItem")
	assert(element, "CellCardShopItem element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

function CellCardShopItem:setData(data)
    self.tData = data
    self:_update()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellCardShopItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

function CellCardShopItem:setSellOut(bSellOut)
	-- body
	WZLog("CellCardShopItem:setSellOut")
	local conS = GetElement(self.m_root,"conSell_CellCardShopItem",WZUIContainer)
	if bSellOut then
		conS:setVisible(true)
	else
		conS:setVisible(false)
	end
end


function CellCardShopItem:getShopId()
	-- body
	if self.tData then
		return self.tData[1]
	else
		return nil
	end
end
-------------------------------------私有方法模块End----------------------------------------
