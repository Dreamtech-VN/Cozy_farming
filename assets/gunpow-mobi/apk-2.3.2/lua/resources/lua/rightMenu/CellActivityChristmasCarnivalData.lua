--CellActivityChristmasCarnivalData.lua
--@brief	CellActivityChristmasCarnival的数据模块
--@date		2020/12/07
--@author	hyc
--@note		圣诞狂欢

CellActivityChristmasCarnival = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellActivityChristmasCarnival:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_activityId = 0	--活动id
	self.m_startime = nil
	self.m_endtime = nil
	self.m_target = {}		--充值/目标充值，消费/目标消费
	self.m_status = {}		--任务进度/领取状态
	self.m_rewardId = {}	--奖励Id,1左边/2右边
	self.m_rewardItem = {}	--奖励item
	self.m_rewardCount = {}	--奖励item的数量
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellActivityChristmasCarnival:_unInit()
	self.m_root = nil
	self.m_activityId = nil
	self.m_startime = nil
	self.m_endtime = nil
	self.m_target = nil		--充值/目标充值，消费/目标消费
	self.m_status = nil		--任务进度/领取状态
	self.m_rewardId = nil	--奖励Id,1左边/2右边
	self.m_rewardItem = nil	--奖励item
	self.m_rewardCount = nil	--奖励item的数量
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellActivityChristmasCarnival:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellActivityChristmasCarnival table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellActivityChristmasCarnival")
	assert(element, "CellActivityChristmasCarnival element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end
function CellActivityChristmasCarnival:setActivityReturnInfo(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,target)
	self.m_activityId = activityId
	self.m_startime = startTime
	self.m_endtime = endTime
	self.m_target = target
	self.m_status = status
	self.m_rewardId = rewardId
	self.m_rewardItem = rewardItems
	self.m_rewardCount = rewardCounts
end

--@brief 领取成功
function CellActivityChristmasCarnival:ACTIVITY_ReceiveRewardOk(rewardItems,rewardCount,rewardId)
	WZLog("CellActivityChristmasCarnival:ACTIVITY_ReceiveRewardOk", Serialize(rewardItems))
	self:_updateBtn(rewardId)
    WndRewardShow:showById(rewardItems,rewardCount)
    WndRewardShow:closeCallBack(self,self._GetRewardOk, _G, pushEquipInList)
end

--@brief    奖励获取成功回调  
function CellActivityChristmasCarnival:_GetRewardOk()
	WndGameActivity:refreshActivityContext()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellActivityChristmasCarnival:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end




-------------------------------------私有方法模块End----------------------------------------
