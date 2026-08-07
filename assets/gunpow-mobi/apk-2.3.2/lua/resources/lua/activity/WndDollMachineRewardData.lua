--WndDollMachineRewardData.lua
--@brief	WndDollMachineReward的数据模块
--@date		2021/05/13
--@author	hyx
--@note		娃娃机奖励

WndDollMachineReward = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndDollMachineReward:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tRewardData = {}
	self.m_nType = 1
	self.m_nIndex = 1
	self.m_nCurIndex = 1
	self.m_sRewardCellItem = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndDollMachineReward:_unInit()
	self.m_root = nil
	self.m_tRewardData = {}
	self.m_nType = 1
	self.m_nIndex = 1
	self.m_nCurIndex = 1
	self.m_sRewardCellItem = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndDollMachineReward:createElement(_type,reward_data,index)
	if WndDollMachineReward.m_root ~= nil then
		WindowManager:removeWindow(WndDollMachineReward.m_root, WndDollMachineReward, true)
	end
	local element = WZUISystem:getInstance():createElement("WndDollMachineReward")
	assert(element, "WndDollMachineReward create element failed!")
	self:_init()
	self.m_tRewardData = reward_data
	self.m_nType = _type
	self.m_nIndex = index
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
