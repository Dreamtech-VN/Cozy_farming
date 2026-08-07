--WndMasterTaskData.lua
--@brief	WndMasterTask的数据模块
--@date		2016/07/23
--@author	zsq
--@note		师傅任务

WndMasterTask = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndMasterTask:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tDataList = nil
	self.giveTaskId = nil
	self.m_bShowReward = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndMasterTask:_unInit()
	self.m_root = nil
	self.m_tDataList = nil
	self.giveTaskId = nil
	self.m_bShowReward = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndMasterTask:createElement()
	local element = WZUISystem:getInstance():createElement("WndMasterTask")
	assert(element, "WndMasterTask create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndMasterTask:setData(taskId, progress, giveTaskId, num, lastTime, alltaskId)
	--如果是领取奖励返回，显示奖励
	if self.m_bShowReward ~= nil then
		local tTable = GDatatab_mentoring_task["id_"..self.m_bShowReward]
		local id = {tTable.reward[1][1],tTable.reward[2][1]}
		local num = {tTable.reward[1][2],tTable.reward[2][2]}
		WndRewardShow:showById(id, num)
		self.m_bShowReward = nil
	end

	self.m_tDataList = {}
	--local id , numOfComplete
	--local playerInfo = CacheCenter:getPlayerInfo()
	--if playerInfo.level < MASTERLEVEL then
	--	id = {1,2,3}
	--	numOfComplete = {2,360,1}
	--end
	--if playerInfo.level >= MASTERLEVEL then
	--	id = {34,35,36,37}
	--	numOfComplete = {1,90,3,1}
	--end
	for i=1,#alltaskId do
		local tempTable = {}
		tempTable.id = alltaskId[i]
		tempTable.numOfComplete = 0
		for j=1,#taskId do
			if alltaskId[i] == taskId[j] then
				tempTable.numOfComplete = progress[j]
			end
		end
		WZLog("显示任务id",tempTable.id)
		table.insert(self.m_tDataList,tempTable)
	end
	for i=1,#giveTaskId do
		local tempTable = {}
		WZLog("已完成任务id",giveTaskId[i])
		tempTable.id = giveTaskId[i]
		tempTable.numOfComplete = 100000
		if GDatatab_mentoring_task["id_"..giveTaskId[i]].daily_type == 1 then
			table.insert(self.m_tDataList,tempTable)
		end
	end


	self.giveTaskId = giveTaskId

	self:update()
end




-------------------------------------私有方法模块End----------------------------------------
