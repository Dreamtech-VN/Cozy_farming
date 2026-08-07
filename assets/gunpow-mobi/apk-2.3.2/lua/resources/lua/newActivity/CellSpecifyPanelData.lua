--CellSpecifyPanelData.lua
--@brief	CellSpecifyPanel的数据模块
--@date		2017/08/21
--@author	Tianxiang_Xu
--@note		定向推送活动-礼包详情

CellSpecifyPanel = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellSpecifyPanel:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_ItemId = nil         --礼包id
	self.m_nLeftCount = nil 	--剩余次数
	self.m_nGiftType = nil 		--礼包类型
	self.m_originPrice = nil	--礼包原价
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellSpecifyPanel:_unInit()
	self.m_root = nil
	self.m_ItemId = nil         --礼包id
	self.m_nLeftCount = nil 	--剩余次数
	self.m_nGiftType = nil 		--礼包类型
	self.m_originPrice = nil	--礼包原价
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellSpecifyPanel:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellSpecifyPanel table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellSpecifyPanel")
	assert(element, "CellSpecifyPanel element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief 	设置数据
--@param 	item_id:充值id或商品Id
--@param 	count:礼包数量
--@param 	nGiftType : 礼包类型1：vip礼包；2：商城礼包
function CellSpecifyPanel:setMessage(item_id, count, nGiftType, originPrice)
	-- body
	self.m_ItemId = item_id         --id
	self.m_nLeftCount = count 	--剩余次数
	self.m_nGiftType = nGiftType 
	self.m_originPrice = originPrice
end

--@brief 	获取Id
function CellSpecifyPanel:getKeyId()
	-- body
	return self.m_ItemId 
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellSpecifyPanel:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
