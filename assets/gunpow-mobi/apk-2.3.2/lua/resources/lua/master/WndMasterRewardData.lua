--WndMasterRewardData.lua
--@brief	WndMasterReward的数据模块
--@date		2015/05/27
--@author	zsq
--@note		师徒奖励

WndMasterReward = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndMasterReward:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_bInit = false
	self.m_nCurPageIndex = 0
	self.m_bChecked = false
	self.m_nShowRewardType = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndMasterReward:_unInit()
	self.m_root = nil
	self.m_bInit = false
	self.m_nCurPageIndex = nil
	self.m_bChecked = nil
	self.m_nShowRewardType = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndMasterReward:createElement()
	local element = WZUISystem:getInstance():createElement("WndMasterReward")
	assert(element, "WndMasterReward create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
