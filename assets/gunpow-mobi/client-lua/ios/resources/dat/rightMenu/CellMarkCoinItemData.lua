--CellMarkCoinItemData.lua
--@brief	CellMarkCoinItem的数据模块
--@date		2019/04/23
--@author	Tianxiang_Xu
--@note		纪念币活动-任务列表

CellMarkCoinItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellMarkCoinItem:_init()
	self.m_root = nil  			--Cell的根节点
	self.data = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellMarkCoinItem:_unInit()
	self.m_root = nil
	self.data = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellMarkCoinItem:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellMarkCoinItem table create failed!")
	tNewObj:_init()
	
	local element = WZUIContainer:create()
	element:setName("__CellMarkCoinItem")
    element:setUseAbsSize(true)
    element:setAbsContentSize(GlobalMethod:CCSize(634, 102))
	element:setLuaObjectIndex(tNewObj)

	return element,tNewObj
end

function CellMarkCoinItem:getActivityTaskRewardOk(taskId, rewardType, itemId, itemNum)
	--body
	WndRewardShow:showById(itemId, itemNum)

	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetMarkTaskInfo()
end

function CellMarkCoinItem:setData(data)
	self.data = data
	WZLog("CellMarkCoinItem:setData", Serialize(self.data))
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellMarkCoinItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
