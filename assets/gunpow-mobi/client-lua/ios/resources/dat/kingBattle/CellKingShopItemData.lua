--CellKingShopItemData.lua
--@brief	CellKingShopItem的数据模块
--@date		2015/05/15
--@author	xiaoyu_wu
--@note		商店物品单元格

CellKingShopItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellKingShopItem:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_itemInfoRoot = nil
    
    self.m_tData = nil          --数据表
    self.m_fClickCallback = nil --点击后的回调方法
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellKingShopItem:_unInit()
	self.m_root = nil
	self.m_itemInfoRoot = nil
    
    self.m_tData = nil
    self.m_fClickCallback = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellKingShopItem:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellKingShopItem table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellKingShopItem")
	assert(element, "CellKingShopItem element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief	设置数据表
--@param    tData, 数据表
--[[        tData定义
            {
				id 							,数据表id
				rest_num 	                ,剩余次数
				itemId 	                    ,物品id
				itemCount 	                ,物品数量
				currencyId	                ,货币类型
				currencyCost                ,价格
            }
]]
function CellKingShopItem:setData(tData)
    self.m_tData = tData
	
	local data = GDatatab_king_mall["id_"..self.m_tData.id]
	self.m_tData.itemId 		= data.item_id
	self.m_tData.itemCount		= data.number
	self.m_tData.currencyId		= data.price[1][1]
	self.m_tData.currencyCost	= data.price[1][2]
	
    self:_update()
end

function CellKingShopItem:setItemInfoRoot(element)
    self.m_itemInfoRoot = element
end

--@brief	设置点击后的回调
--@param    fCallback, 点击后的回调方法, 返回两个参数，第一个是m_root的tag，第二个是self
function CellKingShopItem:setClickCallback(fCallback)
    self.m_fClickCallback = fCallback
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellKingShopItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
