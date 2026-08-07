--WndUpTaskRewardsData.lua
--@brief	WndUpTaskRewards的数据模块
--@date		2014/09/10
--@author	SuYuan
--@note		提升任务奖励弹窗

WndUpTaskRewards = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndUpTaskRewards:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_bShowTip = true 				--是否弹出提升奖励提示窗口
	self.m_tCallbackTable = nil 		--回调函数所属lua表
	self.m_fnCallback = nil 			--回调函数
	self.m_nCost = nil 					--操作消耗的钻石
	self.m_nTipType = nil 				--提示类型（1：快速完成，2：提升奖励）
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndUpTaskRewards:_unInit()
	self.m_root = nil
	self.m_bShowTip = nil
	self.m_tCallbackTable = nil
	self.m_fnCallback = nil
	self.m_nCost = nil
	self.m_nTipType = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndUpTaskRewards:createElement()
	local element = WZUISystem:getInstance():createElement("WndUpTaskRewards")
	assert(element, "WndUpTaskRewards create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------



