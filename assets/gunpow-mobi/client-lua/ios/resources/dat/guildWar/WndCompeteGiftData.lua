-- WndCompeteGift
-- @brief:公会战奖励数据模块
-- @date: 2017-02-22 16:18:54
-- @author: zhenwei_jian
-- @note:奖励列表

local WndCompeteGift = {}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCompeteGift:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tCellList = {}				--cell列表
	self.m_tDataMap = {} 				--列表数据
	self.m_nTabNum = 1 					--tab标记  默认为 "出线赛"列表

	local configData = QuickCopyTable(GDatatab_ghbattle_reward)
	
	--从配置表组装数据
	for k, config in pairs(GDatatab_ghbattle_reward) do
		local nTabNum = config.type
		local tDataList = self.m_tDataMap[nTabNum]
		if nil == tDataList then
			tDataList = {}
			self.m_tDataMap[nTabNum] = tDataList
		end
		table.insert(tDataList, config)
	end
	
	for nTabNum, tDataList in pairs(self.m_tDataMap) do
		table.sort(tDataList, _sortByRank)
	end
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCompeteGift:_unInit()
	self.m_root = nil
	self.m_tCellList = nil
	self.m_tDataMap = nil
	self.m_nTabNum = 1--tab标记
	self.m_nType = nil					--奖励类型，2为家园排行榜奖励，3为小家排行奖励
end


-------------------------------------公有方法模块Begin--------------------------------------
--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCompeteGift:createElement()
	local element = WZUISystem:getInstance():createElement("WndCompeteGift")
	assert(element, "WndCompeteGift create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function _sortByRank(a, b)
	local rankA = a.rank
	local rankB = b.rank

	rankA = rankA[1][#rankA]
	rankB = rankB[1][#rankB]

	if rankA < rankB then
		return true
	end
	return false
end

-------------------------------------私有方法模块End--------------------------------------

rawset(_G, "WndCompeteGift", WndCompeteGift)
