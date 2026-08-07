--CellRuneStoreItemData.lua
--@brief	CellRuneStoreItem的数据模块
--@date		2017/03/22
--@author	qixiang
--@note		符文商店item

CellRuneStoreItem = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellRuneStoreItem:_init()
	self.m_root = nil	 	  			--场景根节点
	self.tData = nil
	self.m_nCostId = nil
	self.m_nCostNum = nil
	self.m_tShopItem = nil
	self.m_nQuality = nil
	self.m_nItemCount = nil
	self.m_tItemProperty = nil
	self.m_sItemName = nil
	self.m_sItemImage = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellRuneStoreItem:_unInit()
	self.m_root = nil
	self.tData = nil
	self.m_nCostId = nil
	self.m_nCostNum = nil
	self.m_tShopItem = nil
	self.m_nQuality = nil
	self.m_nItemCount = nil
	self.m_tItemProperty = nil
	self.m_sItemName = nil
	self.m_sItemImage = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellRuneStoreItem:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellMsgItem table create failed!")
	tNewObj:_init()
    local element = WZUISystem:getInstance():createElement("CellRuneStoreItem")
	element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end

function CellRuneStoreItem:setData(data)
    self.tData = data
end

function CellRuneStoreItem:updateSellStatus()
    WZLog("CellRuneStoreItem:updateSellStatus")
    self.tData[2] = self.tData[2] -1
    if self.tData[2] <= 0 then
    	local conS = GetElement(self.m_root,"conSell_CellRuneStoreItem",WZUIContainer)
        conS:setVisible(true)
    end
end
-------------------------------------公有方法模块End----------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellRuneStoreItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
