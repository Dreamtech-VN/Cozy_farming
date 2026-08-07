--CellTaskRewardsData.lua
--@brief	CellTaskRewards的数据模块
--@date		2014/09/09
--@author	SuYuan
--@note		主线任务奖励Cell

CellTaskRewards = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellTaskRewards:_init()
    WZLog("CellTaskRewards:_init")
	self.m_root = nil	 	  			--场景根节点
	self.m_nMainID = -1 				--跳转界面主ID
	self.m_nSubID = -1 					--跳转界面子ID
	self.m_nTaskID = -1 				--任务ID
	self.m_nTaskType = -1 				--任务类型
	self.m_nCacheItemCount = 0 			--物品数量
	self.CartorNeedId = -1 				--副本跳转任务Id
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellTaskRewards:_unInit()
    WZLog("CellTaskRewards:_unInit")
	self.m_root = nil
	self.m_nMainID = nil
	self.m_nSubID = nil
	self.m_nTaskID = -1
	self.m_nTaskType = -1 				--任务类型
	self.m_nCacheItemCount = 0 			--物品数量
	self.CartorNeedId = -1 				--副本跳转任务Id
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellTaskRewards:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellTaskRewards table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellTaskRewards")
	assert(element, "CellTaskRewards create element failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellTaskRewards:_new()
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------



