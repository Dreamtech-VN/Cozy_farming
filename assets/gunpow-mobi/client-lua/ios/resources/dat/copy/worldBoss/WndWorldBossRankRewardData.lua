--WndWorldBossRankRewardData.lua
--@brief	WndWorldBossRankReward的数据模块
--@date		2015/03/28
--@author	weidong_wu
--@note		世界boss排名奖励界面

WndWorldBossRankReward = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndWorldBossRankReward:_init()
	self.m_root = nil	 	  			--场景根节点
	self.startRank = nil 
	self.endRank=nil 
	self.RewardItems=nil 
	self.m_nLoadingId = 0
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndWorldBossRankReward:_unInit()
	self.m_root = nil
	self.startRank = nil
	self.endRank=nil
	self.RewardItems=nil
	self.m_nLoadingId = 0
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndWorldBossRankReward:createElement()
	local element = WZUISystem:getInstance():createElement("WndWorldBossRankReward")
	assert(element, "WndWorldBossRankReward create element failed!")
	self:_init()
	return element
end


---@bried  接收排行奖励信息
function WndWorldBossRankReward:getRewardList( startTime,startRank,endRank,RewardItems )
	
	local ItemsNewTabel = {}
	for i=1,#startRank do
		local m_tItem = {id=startRank[i]}
		m_tItem.item = {}
		table.insert(m_tItem.item,RewardItems[i])
		table.insert(ItemsNewTabel, m_tItem)
	end
	table.sort( startRank, function ( a,b )		
		return a<b
	end )
	table.sort( endRank, function ( a,b )		
		return a<b
	end )
	table.sort( ItemsNewTabel, function ( a,b )
		return a.id<b.id
	end )
	self.startRank = startRank 
	self.endRank = endRank
	self.RewardItems = ItemsNewTabel
	self:_closeLoading()
	self:_update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
