--CellVipPowerListData.lua
--@brief	CellVipPowerList的数据模块
--@date		2014/04/24
--@author	jiaming_liu
--@note		1-10级会员权限列表

CellVipPowerList = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellVipPowerList:_init()
	self.m_root = nil  			--Cell的根节点
	self.sproductName = nil
    self.data = {}
    self.sdkData = {}
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellVipPowerList:_unInit()
	self.m_root = nil
	self.sproductName = nil
    self.data = nil
	self.sdkData = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellVipPowerList:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellVipPowerList table create failed!")
	tNewObj:_init()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(218,216))   --这个容器的大小要和cell的大小一致
	element:setLuaObjectIndex(tNewObj)
	return element,tNewObj

--	local tNewObj = self:_new()
--	assert(tNewObj, "CellVipPowerList table create failed!")
--	tNewObj:_init()
--	local element = WZUISystem:getInstance():createElement("CellVipPowerList")
--	assert(element, "CellVipPowerList element create failed!")
--	element:setLuaObjectIndex(tNewObj)
--	tNewObj.m_root = element
--	return element,tNewObj
end


function CellVipPowerList:setData(data)
    self.data = data
	self:initDataForSDK()
    --self:update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellVipPowerList:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

function CellVipPowerList:initDataForSDK()
		WZLog("CellVipPowerList:initDataForSDK",self.data.itemId)
	local itemInfo = GDatatab_item["id_"..self.data.itemId]
	local productName = itemInfo.name
	local productDesc = self.data.name
	local quantifier = LocalStrings.SHOP_IND
	local number = self.data.number
	if self.data.itemId == 50 or self.data.itemId == 51 or self.data.itemId == 52 or self.data.itemId == 55 or self.data.itemId == 56 then
		quantifier = LocalStrings.Expand
		number = 1
	end
	self.sdkData = {
		id = self.data.ids,
		price = self.data.price,
		payCode = self.data.payCodeId,
		productName = productName,
		productDesc = productDesc,
		quantifier = quantifier,
		number = math.max(1,number),
		giftNumber = self.data.giftNumber,
	}
end
-------------------------------------私有方法模块End----------------------------------------
