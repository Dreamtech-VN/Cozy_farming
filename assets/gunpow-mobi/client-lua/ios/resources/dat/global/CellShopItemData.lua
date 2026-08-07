--CellShopItemData.lua
--@brief	CellShopItem的数据模块
--@date		2015/05/15
--@author	xiaoyu_wu
--@note		商店物品单元格

CellShopItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellShopItem:_init()
	self.m_root = nil  			--Cell的根节点
    
    self.m_tData = nil          --数据表
    self.m_fClickCallback = nil --点击后的回调方法
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellShopItem:_unInit()
	self.m_root = nil
    
    self.m_tData = nil
    self.m_fClickCallback = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellShopItem:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellShopItem table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellShopItem")
	assert(element, "CellShopItem element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief	设置数据表
--@param    tData, 数据表
--[[        tData定义
            {
                id, 物品id
                count, 物品数量
                currencyId, 货币id
                currencyCost, 货币消耗
                isSoldOut, 是否已售罄
            }
]]
function CellShopItem:setData(tData)
    self.m_tData = tData
    self:_update()
end

--@brief	设置点击后的回调
--@param    fCallback, 点击后的回调方法, 返回两个参数，第一个是m_root的tag，第二个是self
function CellShopItem:setClickCallback(fCallback)
    self.m_fClickCallback = fCallback
end

--@brief	设置是否售罄
--@param    isSoldOut, 是否售罄
function CellShopItem:setIsSoldOut(isSoldOut)
    self.m_tData.isSoldOut = isSoldOut
    self:_updateSoldOut()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellShopItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
