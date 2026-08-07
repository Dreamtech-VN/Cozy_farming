--WndPlayerBackData.lua
--@brief	WndPlayerBack的数据模块
--@date		2017/02/14
--@author	maopeiting
--@note		老玩家回归奖励

WndPlayerBack = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndPlayerBack:_init()
	self.m_root = nil	 	  			--场景根节点
	self.activityId = nil
	self.startTime = nil
	self.endTime = nil
	self.rewardId = nil
	self.status = nil
	self.itemCount = nil
	self.day = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndPlayerBack:_unInit()
	self.m_root = nil
	self.activityId = nil
	self.startTime = nil
	self.endTime = nil
	self.rewardId = nil
	self.status = nil
	self.itemCount = nil
	self.day = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndPlayerBack:createElement()
	local element = WZUISystem:getInstance():createElement("WndPlayerBack")
	assert(element, "WndPlayerBack create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndPlayerBack:setMessage( activityId,startTime,endTime,status,rewardItems,rewardItemsParamCount,finishCondition )
	self.activityId = activityId
	self.startTime = startTime
	self.endTime = endTime
	self.status = status
	self.rewardId = rewardItems
	self.itemCount = rewardItemsParamCount
	self.day = finishCondition
	WZLog("--self.status--",status)
	WZLog("--self.rewardId--",Serialize(rewardItems))
	self:showWindow()
end




-------------------------------------私有方法模块End----------------------------------------
