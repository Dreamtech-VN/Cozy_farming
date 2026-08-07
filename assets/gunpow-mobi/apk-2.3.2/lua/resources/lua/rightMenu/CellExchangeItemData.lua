--CellExchangeItemData.lua
--@brief	CellExchangeItem的数据模块
--@date		2016/08/13
--@author	Tianxiang_Xu
--@note		物品兑换活动子列表项

CellExchangeItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellExchangeItem:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tRewardsData = nil 	--奖励数据
	self.m_tConsumeData = nil 	--消耗数据
	self.m_nLeftTimes = nil 	--剩余次数
	self.m_tCallBack = nil
	self.m_rewardId = nil  
	self.m_nActivityType = nil 
	self.m_nChooseNum = nil 	--一次兑换的数量
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellExchangeItem:_unInit()
	self.m_root = nil
	self.m_tRewardsData = nil 	--奖励数据
	self.m_tConsumeData = nil 	--消耗数据
	self.m_nLeftTimes = nil 	--剩余次数
	self.m_tCallBack = nil 
	self.m_rewardId = nil 
	self.m_nActivityType = nil 
	self.m_nChooseNum = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellExchangeItem:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellExchangeItem table create failed!")
	tNewObj:_init()
	local element = WZUIContainer:create()
	element:setName("__CellExchangeItem")
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(640,106))
	element:setLuaObjectIndex(tNewObj)

	return element,tNewObj
end

--@brief 	设置数据
function CellExchangeItem:setData(rewardData, consumeData, times, rewardId, activityType)
	-- body
	self.m_tRewardsData = rewardData 	--奖励数据
	self.m_tConsumeData = consumeData 	--消耗数据
	self.m_nLeftTimes = times 	--剩余次数
	self.m_rewardId = rewardId 
	self.m_nActivityType = activityType

	WZLog("CellExchangeItem:setData", Serialize(self.m_tRewardsData), Serialize(self.m_tConsumeData), self.m_nLeftTimes)
end

--@brief 	设置回调函数
function CellExchangeItem:setCallBackFunc(tCell, func)
	-- body
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
function CellExchangeItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
