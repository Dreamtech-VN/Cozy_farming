--WndCommunityTaskData.lua
--@brief	WndCommunityTask的数据模块
--@date		2016/06/17
--@author	zsq
--@note		公会任务主界面

WndCommunityTask = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCommunityTask:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tDataList1 = nil
	self.m_tDataList2 = nil
	self.m_tData = nil
	self.m_tReward = nil
	self.m_bPublishing = nil
	self.m_nRewardTag = 1
	self.m_bJurisdiction = nil
	self.m_nTaskDayIndex = 0 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCommunityTask:_unInit()
	self.m_root = nil
	self.m_tDataList1 = nil
	self.m_tDataList2 = nil
	self.m_tData = nil
	self.m_tReward = nil
	self.m_bPublishing = nil
	self.m_nRewardTag = nil
	self.m_bJurisdiction = nil
	self.m_nTaskDayIndex = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCommunityTask:createElement()
	local element = WZUISystem:getInstance():createElement("WndCommunityTask")
	assert(element, "WndCommunityTask create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndCommunityTask:setData(playerid, faceid, headid, level, itime, vipLevel, job, online, msgList, name, sex, idList, totalCount, currCount, taskType, headColor, refresh)
	self.m_bJurisdiction = refresh
	self.m_tDataList1 = {}
	self.m_tDataList2 = {}
	for i=1,#playerid do
		local tempTable = {}
		tempTable.playerId = playerid[i]
		tempTable.headId = headid[i]
		tempTable.faceId = faceid[i]
		tempTable.level = level[i]
		tempTable.itime = itime[i]
		tempTable.vipLevel = vipLevel[i]
		tempTable.job = job[i]
		tempTable.online = online[i]
		tempTable.msgList = msgList[i]
		tempTable.name = name[i]
		tempTable.sex = sex[i]
		tempTable.headColor = headColor[i]
		table.insert(self.m_tDataList1,tempTable)
	end

	local tTempType = {}
	local bIsExistNoSet = false 
	for i = 1, #taskType do
		local bIsExist = false
		if taskType[i] == -1 then bIsExistNoSet = true end
		for j = 1, #tTempType do
			if tTempType[j] == taskType[i] then 
				bIsExist = true
				break
			end
		end

		if not bIsExist then 
			table.insert(tTempType, taskType[i])
		end
	end
	if bIsExistNoSet then
		self.m_nTaskDayIndex = #tTempType - 1
	else
		self.m_nTaskDayIndex = #tTempType
	end
	for i=1,#idList do
		local tempTable = {}
		tempTable.idList = idList[i]
		tempTable.totalCount = totalCount[i]
		tempTable.currCount = currCount[i]
		tempTable.index = i
		tempTable.taskType = taskType[i]
		if currCount[i] >= totalCount[i] then
			tempTable.finish = 1
		else
			tempTable.finish = 0
		end
		table.insert(self.m_tDataList2,tempTable)
	end

	table.sort(self.m_tDataList2,_sortCommunityTask)
--	WZLog("WndCommunityTask:setData",CacheCenter:getPlayerInfo().position,Serialize(self.m_tDataList1))
	if self.m_tData == nil then self.m_tData = {} end
--	WZLog("任务列表",Serialize(self.m_tDataList2))

	self:updateState()
end

function _sortCommunityTask(a,b)
	local function rtnValue(c)
		-- body
		if c.taskType == -1 then
			return 8
		else
			return c.taskType
		end
	end

	local nTypeA = rtnValue(a)
	local nTypeB = rtnValue(b)
	if nTypeB ~= nTypeA then
		return nTypeA < nTypeB
	else
		if a.finish ~= b.finish then
			return a.finish < b.finish
		else
			if a.index == nil or b.index == nil then
				return true
			else
				return a.index < b.index
			end
		end
	end
end

function WndCommunityTask:updateState()
	if self.m_tData == nil then return end
	local taskStatus = self.m_nTaskDayIndex
	WZLog("WndCommunityTask:updateState", taskStatus, self.m_bJurisdiction)
	--状态  1.发布任务 2.任务奖励 3.会员留言列表 4.会员留言
	--if tonumber(CacheCenter:getPlayerInfo().position) == COMMUNITY_PRESIDENT then
	if tonumber(self.m_bJurisdiction) == 1 then
		if taskStatus == 0 then
			if WndCommunityTask.m_bPublishing then
				self.m_nState = 1
			else
				self.m_nState = 3
			end
		else
			self.m_nState = 1
		end
	else
		if taskStatus == 0 then
			if WndCommunityTask.m_bPublishing then
				self.m_nState = 1
			else
				self.m_nState = 4
			end
		else
			self.m_nState = 1
		end
	end
	self:update()
end

function WndCommunityTask:setData1(success, content, currFund)
	if self.m_tReward == nil then self.m_tReward = {} end
	self.m_tReward.success = success
	self.m_tReward.currFund = currFund
	WZLog("WndCommunityTask:setData1",content)
	local ids,nums = SplitItemString(content)
	self.m_tReward.nums = nums
	WZLog("WndCommunityTask:setData1",Serialize(ids),Serialize(nums))

	self:updateReward()
end

-------------------------------------私有方法模块End----------------------------------------
