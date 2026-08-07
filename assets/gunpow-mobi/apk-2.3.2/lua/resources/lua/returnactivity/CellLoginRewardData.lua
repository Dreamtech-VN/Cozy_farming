--CellLoginRewardData.lua
--@brief	CellLoginReward的数据模块
--@date		2021/05/20
--@author	hyx
--@note		选择回归奖励

CellLoginReward = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellLoginReward:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tRewardData = nil
	self.m_tGetChooseType = {}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellLoginReward:_unInit()
	self.m_root = nil
	self.m_tRewardData = nil
	self.m_tGetChooseType = {}
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellLoginReward:createElement(activityId,reward)
	if CellLoginReward.m_root ~= nil then
		WindowManager:removeWindow(CellLoginReward.m_root, CellLoginReward, true)
	end
	local element = WZUISystem:getInstance():createElement("CellLoginReward")
	assert(element, "CellLoginReward create element failed!")
	self:_init()
	self.m_nActivityId = activityId
	self.m_tRewardData = reward
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
