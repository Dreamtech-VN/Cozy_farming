--WndJoinRewardData.lua
--@brief	WndJoinReward的数据模块
--@date		2020/12/11
--@author	hyx
--@note		参与奖励

WndJoinReward = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndJoinReward:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_sDesc = ""
	self.m_tRewardIdsData = {}
	self.m_tRewardNumsData = {}
	self.m_nCurIndex = nil
	self.m_tRewardTabTitle = {}
	self.m_tTabView = {}
	self.m_sNameColor = nil
	self.m_tClickCell = nil 
	self.m_nSpecifyIndex = nil 	
	self.m_tRewardObj = {}				--存放上方全部对象
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndJoinReward:_unInit()
	self.m_root = nil
	self.m_sDesc = ""
	self.m_tRewardIdsData = {}
	self.m_tRewardNumsData = {}
	self.m_nCurIndex = nil
	self.m_tRewardTabTitle = {}
	self.m_tTabView = {}
	self.m_sNameColor = nil
	self.m_tClickCell = nil 
	self.m_nSpecifyIndex = nil 	
	self.m_tRewardObj = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndJoinReward:createElement()
	if WndJoinReward.m_root ~= nil then
		WindowManager:removeWindow(WndJoinReward.m_root, WndJoinReward, true)
	end
	local element = WZUISystem:getInstance():createElement("WndJoinReward")
	assert(element, "WndJoinReward create element failed!")
	self:_init()
	return element
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
