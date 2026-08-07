--CellDouble11ActivityData.lua
--@brief	CellDouble11Activity的数据模块
--@date		2020/10/20
--@author	hyx
--@note		双11奖励

CellDouble11Activity = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellDouble11Activity:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tGetButtonList = {}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellDouble11Activity:_unInit()
	self.m_root = nil
	self.m_tGetButtonList = {}
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellDouble11Activity:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellOneRechargeAct table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellDouble11Activity")
	assert(element, "CellDouble11Activity element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief    初始化信息
function CellDouble11Activity:setActivityReturnInfo(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,target)
	self.doubleElevenActivityId = activityId or 0
	self.startTime = startTime
	self.endTime = endTime
	self.target = target
	self.count = count
	self.status = status --(-1不可领取,0可领取，1已领取)
	self.rewardItems = rewardItems
	self.rewardItemsParamCount = rewardItemsParamCount
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellDouble11Activity:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end




-------------------------------------私有方法模块End----------------------------------------
