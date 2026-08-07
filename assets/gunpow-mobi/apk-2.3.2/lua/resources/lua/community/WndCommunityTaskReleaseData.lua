--WndCommunityTaskReleaseData.lua
--@brief	WndCommunityTaskRelease的数据模块
--@date		2016/06/17
--@author	zsq
--@note		公会发布任务界面

WndCommunityTaskRelease = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCommunityTaskRelease:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tSelectedCell = nil
	self.m_tID = {}
	self.m_nCost = nil
	self.m_nCostId = nil
	self.m_nTopTabIndex = 1 
	self.m_nTopTabCount = 8				--任务标题最大数量
	self.m_tTitleElementList = nil		--存放任务标题按钮
	self.m_nReleaseCostId = 161070		--发布任务消耗物品id
	self.m_tReleaseCostNums = {}		--发布任务消耗物品数量列表
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCommunityTaskRelease:_unInit()
	self.m_root = nil
	self.m_tSelectedCell = nil
	self.m_tID = nil
	self.m_nCost = nil
	self.m_nCostId = nil
	self.m_nTopTabIndex = nil 
	self.m_nTopTabCount = nil
	self.m_tTitleElementList = nil
	self.m_nReleaseCostId = nil
	self.m_tReleaseCostNums = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCommunityTaskRelease:createElement()
	local element = WZUISystem:getInstance():createElement("WndCommunityTaskRelease")
	assert(element, "WndCommunityTaskRelease create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------




-------------------------------------私有方法模块End----------------------------------------
