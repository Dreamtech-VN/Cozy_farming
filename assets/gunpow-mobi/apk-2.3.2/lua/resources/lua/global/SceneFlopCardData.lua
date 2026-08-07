--WndFlopCardData.lua
--@brief	SceneFlopCard的数据模块
--@date		2017/02/18
--@author	qixiang
--@note		翻牌

SceneFlopCard = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function SceneFlopCard:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tCardObjList = nil
	self.m_nCountdown = 7
	self.m_nFlopId = nil
	self.m_nFlopCount = nil

	self.m_bCard1Flag = false
	self.m_bCard2Flag = false
	self.m_nSweepTimes = nil 		--本次扫荡的次数
	self.m_tSweepReward = nil 
	self.m_nOpenCardNum1 = 0 		--翻开的免费card数量
	self.m_nOpenCardNum2 = 0 		--翻开的VIPcard数量
	self.m_nOpenCardNum3 = 0 		--翻开的钻石card数量
	self.m_nFlopRebate = 100 		--翻牌折扣
	self.m_bIsMarryCopy = false 	--是否为夫妻副本
	self.m_tMarryCopyRoomInfo = nil 			--夫妻副本房间信息
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function SceneFlopCard:_unInit()
	self.m_root = nil
	self.m_tCardObjList = nil
	self.m_nCountdown = nil
	self.m_nFlopId = nil
	self.m_nFlopCount = nil
	self.m_bCard1Flag = nil
	self.m_bCard2Flag = nil
	self.m_nSweepTimes = nil 
	self.m_tSweepReward = nil 
	self.m_nOpenCardNum1 = nil 		--翻开的免费card数量
	self.m_nOpenCardNum2 = nil 		--翻开的VIPcard数量
	self.m_nOpenCardNum3 = nil 		--翻开的钻石card数量
	self.m_nFlopRebate = nil
	self.m_bIsMarryCopy = nil 
	self.m_tMarryCopyRoomInfo = nil 			--夫妻副本房间信息
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function SceneFlopCard:createElement()
	local element = WZUISystem:getInstance():createElement("SceneFlopCard")
	assert(element, "SceneFlopCard create element failed!")
	self:_init()
	return element
end

--设置翻牌的物品
function SceneFlopCard:setFlopCardItem(flopId, flopCount, sweepTimes, flopRebate)
	-- body
	WZLog("SceneFlopCard:setFlopCardItem ", Serialize(flopId), Serialize(flopCount))
	self.m_nFlopId = flopId
	self.m_nFlopCount = flopCount
	self.m_nSweepTimes = sweepTimes
	self.m_nFlopRebate = flopRebate or 100
	self.m_tSweepReward = {}
	for i = 1, self.m_nSweepTimes do
		local tItem = {}
		tItem.flopId = {}
		tItem.flopCount = {}
		for k = 1 + (i - 1) * 6, i * 6 do
			table.insert(tItem.flopId, flopId[k])
			table.insert(tItem.flopCount, flopCount[k])
		end

		table.insert(self.m_tSweepReward, tItem)
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
