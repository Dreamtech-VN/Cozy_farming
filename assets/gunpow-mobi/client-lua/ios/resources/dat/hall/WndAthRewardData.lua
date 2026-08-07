--WndAthRewardData.lua
--@brief	WndAthReward的数据模块
--@date		2015-6-6
--@author	binshao
--@note		竞技场奖励

WndAthReward = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndAthReward:_init()
	self.m_root = nil	 	    -- 场景根节点
	self.goalData = nil
	self.goalCell = {}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndAthReward:_unInit()
	self.m_root = nil
	self.goalData = nil
	self.goalCell = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndAthReward:createElement()
	local element = WZUISystem:getInstance():createElement("WndAthReward")
	assert(element, "WndAthReward create element failed!")
	self:_init()
	return element
end


-- 设置目标的数据
function WndAthReward:setGoalData(rewardId, status, fightNum, winNum,mfightNum,mwinNum,gfightNum,gwinNum,ffightNum,fwinNum)
	self.goalData = {}
	WZLog("----------------set data-------------",fightNum,winNum,mfightNum,mwinNum,gfightNum,gwinNum,ffightNum,fwinNum)
	local rewardId = VectorToTable(rewardId)
	local state = VectorToTable(status)
	WZLog("--------------setData------------",#rewardId,#state)
	if #rewardId > 0 then
		self.goalData.info = {}
		for i = 1, #rewardId do
			local info = {}
			info.rewardId = rewardId[i]
			info.state = state[i]
			info.fightNum = fightNum
			info.winNum = winNum
			info.mfightNum = mfightNum
			info.mwinNum = mwinNum
			info.gfightNum = gfightNum
			info.gwinNum = gwinNum
			info.ffightNum = ffightNum
			info.fwinNum = fwinNum
			table.insert(self.goalData.info,info)
			WZLog("----------state win fight------------",info.rewardId,info.state,info.fightNum,info.winNum)
		end
	end
	self.goalData.fightNum = fightNum
	self.goalData.winNum = winNum

	local function sort(v1,v2)
		if v1.state == v2.state then
			local order1 = GDatatab_rank_sports["id_"..v1.rewardId].order
			local order2 = GDatatab_rank_sports["id_"..v2.rewardId].order
			return order1 < order2
		else
			if v1.state == 0 then return true end
			if v2.state == 0 then return false end
			if v1.state == -1 then return true end
			if v2.state == -1 then return false end
			if v1.state == 1 then return true end
			if v2.state == 1 then return false end
		end
		return false
	end

	table.sort(self.goalData.info,sort)
	self:_updateGoal()
end

-- 设置cell的信息
function WndAthReward:setGoalCell(tag,cell,tcell)
	if not self.goalCell then self.goalCell = {} end
	if not self.goalCell[tag] then self.goalCell[tag] = {} end
	self.goalCell[tag].cell = cell
	self.goalCell[tag].tcell = tcell
end

-- 寻找对应的id的cell
function WndAthReward:findIndex(id)
	for i = 1, #self.goalData.info do
		if self.goalData.info[i].rewardId == id then
			return i
		end
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------