--CellSettlementCardData.lua
--@brief	CellSettlementCard的数据模块
--@date		2015/04/16
--@author	xiaoyu_wu
--@note		翻牌奖励单张牌

CellSettlementCard = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellSettlementCard:_init()
	self.m_root = nil  			--Cell的根节点
    
    self.m_tData = nil          --数据表
    self.m_nType = 0            --类型 1:免费，2:VIP免费，3:付费
    self.m_nState = 0           --状态 0:未翻  1:已翻
    self.m_fClickCallback = nil --点击后的回调
    self.m_tcallbackLua = nil
    self.m_nFlopRebate = 100 	--粉钻翻牌折扣
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellSettlementCard:_unInit()
	self.m_root = nil
    
    self.m_tData = nil
    self.m_nType = 0
    self.m_nState = 0
    self.m_fClickCallback = nil
    self.m_tcallbackLua = nil
    self.m_nFlopRebate = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellSettlementCard:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellSettlementCard table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellSettlementCard")
	assert(element, "CellSettlementCard element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief	设置数据
--@param    nItemId,道具id
--@param    nCount,道具数量
--@param    nPlayerName,玩家姓名
function CellSettlementCard:setData(tData)
    self.m_tData = tData
    self:_update()
end

--@brief	设置点击回调
function CellSettlementCard:setClickCallback(fCallback)
    self.m_fClickCallback = fCallback
end

function CellSettlementCard:setClickCallback2(fCallback,lua)
	WZLog("CellSettlementCard:setClickCallback2")
	self.m_fClickCallback = fCallback --点击后的回调
    self.m_tcallbackLua = lua
end

--@brief	获取翻牌类型
function CellSettlementCard:getType()
    return self.m_nType
end

--@brief	获取翻牌状态
function CellSettlementCard:getState()
    return self.m_nState
end

--@brief 	设置翻牌折扣
function CellSettlementCard:setDiscount(flopRebate)
	self.m_nFlopRebate = flopRebate or 100
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellSettlementCard:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
