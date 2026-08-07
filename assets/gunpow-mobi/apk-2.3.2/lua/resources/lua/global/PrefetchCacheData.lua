--PrefetchCacheData.lua
--@brief	客户端预获取缓存，即提前获取缓存数据
--@date		2014/9/10
--@author	刘凑贵
--@note     定义预获取缓存的变量与方法

PrefetchCache = 
{
	m_tCommunityList = nil,        --公会列表数据
	m_tQualifyList = nil,          --排位赛列表数据
	m_tTaskList = nil, 			   --任务列表
	m_tHallRoomList = nil,         --大厅房间列表
	m_tVipInfo = nil,				--VIP信息
	m_tVipLevelGiftList = nil,		--VIP等级礼包
	m_tVipDailyGiftList = nil ,		--VIP每日礼包
	m_tMonthlyCardInfo = nil,     --月卡信息
	--add by  wuweidong
	m_tNoticeList = nil,			--公告列表
	m_tActivityList = nil,			--活动列表
	m_tVipDailyGiftList = nil 		--VIP每日礼包
}


-------------------------------------公有方法模块Begin--------------------------------------
--@brief	设置公会列表数据
function PrefetchCache:setCommunityList(communityId, communityName, level, prestige, rank, isCommunityMember, pageNumber, totalNumber)
	self.m_tCommunityList = {}
	self.m_tCommunityList.communityId = VectorToTable(communityId)
	self.m_tCommunityList.communityName = VectorToTable(communityName)
	self.m_tCommunityList.level = VectorToTable(level)
	self.m_tCommunityList.prestige = VectorToTable(prestige)
	self.m_tCommunityList.rank = VectorToTable(rank)
	self.m_tCommunityList.isCommunityMember = isCommunityMember
	self.m_tCommunityList.pageNumber = pageNumber
	self.m_tCommunityList.totalNumber = totalNumber
end

--@brief	设置排位赛数据
function PrefetchCache:setQualifyList( playerId, rankings, names, scores, ranks, successRates, rewardIcons, rewardName, rewardValidTime, remainingTime, myRanking, myScore, myRank, myRankName, myExp, myNextExp, hasOpened )
	WZLog ("PrefetchCache:setQualifyList")
	self.m_tQualifyList = {}
	self.m_tQualifyList.playerId = {}        --玩家id           array(数组类型)
	self.m_tQualifyList.rankings = {}        --排名             array(数组类型)
	self.m_tQualifyList.names = {}           --名称             array(数组类型)
	self.m_tQualifyList.scores = {}          --积分             array(数组类型)
	self.m_tQualifyList.ranks = {}           --军衔等级         array(数组类型)
	self.m_tQualifyList.successRates = {}    --胜率             array(数组类型)
	self.m_tQualifyList.rewardIcons = {}     --排位赛奖励图标   array(数组类型)
	self.m_tQualifyList.rewardName = {}	   --奖励名称         array(数组类型)
	self.m_tQualifyList.rewardValidTime = {} --奖励有效期       array(数组类型)
	self.m_tQualifyList.remainingTime = remainingTime  --本赛季剩余时间   int
	self.m_tQualifyList.myRanking = myRanking          --我的排名         int
	self.m_tQualifyList.myScore = myScore              --我的积分         int
	self.m_tQualifyList.myRank = myRank                --我的军衔等级     int
	self.m_tQualifyList.myRankName = myRankName        --我的军衔名称     string
	self.m_tQualifyList.myExp = myExp                  --我的经验         int
	self.m_tQualifyList.myNextExp = myNextExp          --我的下次升级需要经验 int
	self.m_tQualifyList.hasOpened = hasOpened          --排位赛是否开启   bool
	
	for i = 0 , playerId:size() - 1  do	
		table.insert( self.m_tQualifyList.playerId , playerId:get(i) )
		table.insert( self.m_tQualifyList.rankings , rankings:get(i) )		
		table.insert( self.m_tQualifyList.names , names:get(i) )
		table.insert( self.m_tQualifyList.scores , scores:get(i) )		
		table.insert( self.m_tQualifyList.ranks , ranks:get(i) )
		table.insert( self.m_tQualifyList.successRates , successRates:get(i) )		
	end
	--添加奖励,因为奖励跟玩家数量不一样，所以分开添加
	WZLog("rewardIcons:size():",rewardIcons:size())
	for i = 0 , rewardIcons:size() -1 do
		table.insert( self.m_tQualifyList.rewardIcons , rewardIcons:get(i) )		
		table.insert( self.m_tQualifyList.rewardName , rewardName:get(i) )
		table.insert( self.m_tQualifyList.rewardValidTime , rewardValidTime:get(i) )
		WZLog("rewardIcons:",rewardIcons:get(i))	
		WZLog("rewardName:",rewardName:get(i))	
		WZLog("rewardValidTime:",rewardValidTime:get(i))			
	end
end

--@brief 	设置任务列表数据
--@param 	参数与获取任务列表协议一致
function PrefetchCache:setTaskList(id, status, target, complete, boxStatus)
	--TaskCacheIsChanage.m_bTaskCacheIsChanage = true
	self.m_tTaskList = {}
	local MainTaskCount = 0
	local BranchTaskCount = 0
	self.m_tTaskList.tMainTask = {}
	self.m_tTaskList.tBranchTask = {}
	self.m_tTaskList.tDailyTask = {}
	self.m_tTaskList.tDailyTask.tToSubmit = {}		--待提交的每日任务
	self.m_tTaskList.tDailyTask.tDoing = {}			--正在进行的每日任务
	self.m_tTaskList.tDailyTask.tCompleted = {} 	--已完成的每日任务
	self.m_tTaskList.tAthleticsTask = {}
	self.m_tTaskList.tAthleticsTask.tToSubmit = {}		--待提交的竞技任务
	self.m_tTaskList.tAthleticsTask.tDoing = {}			--正在进行的竞技任务
	self.m_tTaskList.tAthleticsTask.tCompleted = {} 	--已完成的竞技任务
	self.m_tTaskList.boxStatus = boxStatus
	self.m_tTaskList.tProfessionTask = {}
	self.m_tTaskList.tProfessionTask.tToSubmit = {}		--待提交的职业任务
	self.m_tTaskList.tProfessionTask.tDoing = {}			--正在进行的职业任务
	self.m_tTaskList.tProfessionTask.tCompleted = {} 	--已完成的职业任务

	self.m_tTaskList.tStrategicDailyTask = {}
	self.m_tTaskList.tStrategicDailyTask.tToSubmit = {}			--待提交的战略赛每日任务
	self.m_tTaskList.tStrategicDailyTask.tDoing = {}			--正在进行的战略赛每日任务
	self.m_tTaskList.tStrategicDailyTask.tCompleted = {} 		--已完成的战略赛每日任务
	self.m_tTaskList.tStrategicSeasonTask = {}
	self.m_tTaskList.tStrategicSeasonTask.tToSubmit = {}		--待提交的战略赛赛季任务
	self.m_tTaskList.tStrategicSeasonTask.tDoing = {}			--正在进行的战略赛赛季任务
	self.m_tTaskList.tStrategicSeasonTask.tCompleted = {} 		--已完成的战略赛赛季任务

	WZLog("PrefetchCache:setTaskList one", Serialize(id), Serialize(status),Serialize(target),Serialize(complete))
	for i,v in pairs(id) do
		local taskId = id[i]
		if not (TASKSTATUS_STALE == status[i]) then
			WZLog("PrefetchCache:setTaskList:TaskId="..taskId)
			WZLog("TaskStatus="..status[i])
			local m_tTaskData = GDatatab_task["id_"..taskId]
			if m_tTaskData == nil then 
				WZLog("TaskData is error!")
				--Modify By Tianxiang_Xu
				m_tTaskData = {}
				m_tTaskData.type = 0 	--当本地数据表中没有这个任务的数据是，忽略掉该任务
				--End Modify
			end 
			if 1 == m_tTaskData.type  then
				local list_MainTask	
				list_MainTask = self.m_tTaskList.tMainTask
				list_MainTask[MainTaskCount+1] = {}
				list_MainTask[MainTaskCount+1].nId = v
				
				--list_MainTask[MainTaskCount+1].nTargetCount = targetCount[i]
				list_MainTask[MainTaskCount+1].nTaskStatus = status[i]
				if TASKSTATUS_TOSUBMIT == status[i] then
					GlobalGame.g_nMainTaskCount = GlobalGame.g_nMainTaskCount + 1
				end
--				WZLog("PrefetchCache:setTaskList::Maintask_taskStatus=="..status[i])
				list_MainTask[MainTaskCount+1].nTargetStatus = 0
				list_MainTask[MainTaskCount+1].nTargetValue = 0
				list_MainTask[MainTaskCount+1].nTaskType = m_tTaskData.type
--				WZLog("PrefetchCache:setTaskList::Maintask_targetStatus=="..complete[i])
				list_MainTask[MainTaskCount+1].nTargetStatus=complete[i]

--				WZLog("PrefetchCache:setTaskList::Maintask_targetValue=="..target[i])
				list_MainTask[MainTaskCount+1].nTargetValue=target[i]
				list_MainTask[MainTaskCount+1].m_nChangeTag = false 				--修改选项卡TAG
				MainTaskCount = MainTaskCount + 1
			elseif 2 == m_tTaskData.type then
				local list_BranchTask
				WZLog("获取支线任务",v)
				list_BranchTask = self.m_tTaskList.tBranchTask
				list_BranchTask[BranchTaskCount+1] = {}
				list_BranchTask[BranchTaskCount+1].nId = v
				
				--list_BranchTask[BranchTaskCount+1].nTargetCount = targetCount[i]
				list_BranchTask[BranchTaskCount+1].nTaskStatus = status[i]
				if TASKSTATUS_TOSUBMIT == status[i] then
	    			GlobalGame.g_nBranchTaskCount = GlobalGame.g_nBranchTaskCount + 1
				end
--				WZLog("PrefetchCache:setTaskList::Branch_taskStatus=="..status[i])
				list_BranchTask[BranchTaskCount+1].nTargetStatus = 0
				list_BranchTask[BranchTaskCount+1].nTargetValue = 0
				list_BranchTask[BranchTaskCount+1].nTaskType = m_tTaskData.type

--				WZLog("PrefetchCache:setTaskList::Branch_nTargetStatus=="..complete[i])
				list_BranchTask[BranchTaskCount+1].nTargetStatus=complete[i]

--				WZLog("PrefetchCache:setTaskList::Branch_nTargetValue=="..target[i])
				list_BranchTask[BranchTaskCount+1].nTargetValue=target[i]
				
				list_BranchTask[BranchTaskCount+1].m_nChangeTag = false 				--修改选项卡TAG
				BranchTaskCount = BranchTaskCount + 1	
			elseif 3 == m_tTaskData.type then
				local tDailyTaskList
                local bIsAdd = self:whetherAddShareTask(m_tTaskData)
                if bIsAdd then
    				if status[i] == TASKSTATUS_TOSUBMIT then
    					tDailyTaskList = self.m_tTaskList.tDailyTask.tToSubmit
    	    			GlobalGame.g_nDailyTaskCount = GlobalGame.g_nDailyTaskCount + 1
    				elseif status[i] == TASKSTATUS_DOING  then
    					tDailyTaskList = self.m_tTaskList.tDailyTask.tDoing
    				elseif status[i] == TASKSTATUS_COMPLETED then
    					tDailyTaskList = self.m_tTaskList.tDailyTask.tCompleted
    				end

    				local nCount = table.getn(tDailyTaskList)
    				tDailyTaskList[nCount+1] = {}
    				tDailyTaskList[nCount+1].nTargetStatus = 0
    				tDailyTaskList[nCount+1].nTargetValue = 0
    				tDailyTaskList[nCount+1].nId = v
    				tDailyTaskList[nCount+1].nTaskType =  m_tTaskData.type
    				--tDailyTaskList[nCount+1].nTaskSubType = taskSubType[i]
    				tDailyTaskList[nCount+1].nTaskStatus = status[i]
    			
--    				WZLog("PrefetchCache:settDailyTaskList:initTargetStatus->"..complete[i])
    				tDailyTaskList[nCount+1].nTargetStatus=complete[i]

--    				WZLog("PrefetchCache:settDailyTaskList:initTargetValue->"..target[i])
    				tDailyTaskList[nCount+1].nTargetValue=target[i]
                end
			elseif 9 == m_tTaskData.type then
				local tAthleticsTaskList
				if status[i] == TASKSTATUS_TOSUBMIT then
					tAthleticsTaskList = self.m_tTaskList.tAthleticsTask.tToSubmit
	    			GlobalGame.g_nAthleticsTaskCount = GlobalGame.g_nAthleticsTaskCount + 1
				elseif status[i] == TASKSTATUS_DOING  then
					tAthleticsTaskList = self.m_tTaskList.tAthleticsTask.tDoing
				elseif status[i] == TASKSTATUS_COMPLETED then
					tAthleticsTaskList = self.m_tTaskList.tAthleticsTask.tCompleted
				end

				local nCount = table.getn(tAthleticsTaskList)
				tAthleticsTaskList[nCount+1] = {}
				tAthleticsTaskList[nCount+1].nTargetStatus = 0
				tAthleticsTaskList[nCount+1].nTargetValue = 0
				tAthleticsTaskList[nCount+1].nId = v
				tAthleticsTaskList[nCount+1].nTaskType =  m_tTaskData.type
				tAthleticsTaskList[nCount+1].nTaskStatus = status[i]
				tAthleticsTaskList[nCount+1].nTargetStatus=complete[i]
				tAthleticsTaskList[nCount+1].nTargetValue=target[i]
			elseif 8 == m_tTaskData.type then
				local tProfessionTaskList
				if status[i] == TASKSTATUS_TOSUBMIT then
					tProfessionTaskList = self.m_tTaskList.tProfessionTask.tToSubmit
	    			GlobalGame.g_nProfessionTaskCount = GlobalGame.g_nProfessionTaskCount + 1
				elseif status[i] == TASKSTATUS_DOING  then
					tProfessionTaskList = self.m_tTaskList.tProfessionTask.tDoing
				elseif status[i] == TASKSTATUS_COMPLETED then
					tProfessionTaskList = self.m_tTaskList.tProfessionTask.tCompleted
				end

				local nCount = table.getn(tProfessionTaskList)
				tProfessionTaskList[nCount+1] = {}
				tProfessionTaskList[nCount+1].nTargetStatus = 0
				tProfessionTaskList[nCount+1].nTargetValue = 0
				tProfessionTaskList[nCount+1].nId = v
				tProfessionTaskList[nCount+1].nTaskType =  m_tTaskData.type
				tProfessionTaskList[nCount+1].nTaskStatus = status[i]
				tProfessionTaskList[nCount+1].nTargetStatus=complete[i]
				tProfessionTaskList[nCount+1].nTargetValue=target[i]
			elseif 10 == m_tTaskData.type then
				local tStrategicDailyTaskList
				if status[i] == TASKSTATUS_TOSUBMIT then
					tStrategicDailyTaskList = self.m_tTaskList.tStrategicDailyTask.tToSubmit
	    			GlobalGame.g_nStrategicDailyTaskCount = GlobalGame.g_nStrategicDailyTaskCount + 1
				elseif status[i] == TASKSTATUS_DOING  then
					tStrategicDailyTaskList = self.m_tTaskList.tStrategicDailyTask.tDoing
				elseif status[i] == TASKSTATUS_COMPLETED then
					tStrategicDailyTaskList = self.m_tTaskList.tStrategicDailyTask.tCompleted
				end

				local nCount = table.getn(tStrategicDailyTaskList)
				tStrategicDailyTaskList[nCount+1] = {}
				tStrategicDailyTaskList[nCount+1].nTargetStatus = 0
				tStrategicDailyTaskList[nCount+1].nTargetValue = 0
				tStrategicDailyTaskList[nCount+1].nId = v
				tStrategicDailyTaskList[nCount+1].nTaskType =  m_tTaskData.type
				tStrategicDailyTaskList[nCount+1].nTaskStatus = status[i]
				tStrategicDailyTaskList[nCount+1].nTargetStatus=complete[i]
				tStrategicDailyTaskList[nCount+1].nTargetValue=target[i]
			elseif 11 == m_tTaskData.type then
				local tStrategicSeasonTaskList
				if status[i] == TASKSTATUS_TOSUBMIT then
					tStrategicSeasonTaskList = self.m_tTaskList.tStrategicSeasonTask.tToSubmit
	    			GlobalGame.g_nStrategicSeasonTaskCount = GlobalGame.g_nStrategicSeasonTaskCount + 1
				elseif status[i] == TASKSTATUS_DOING  then
					tStrategicSeasonTaskList = self.m_tTaskList.tStrategicSeasonTask.tDoing
				elseif status[i] == TASKSTATUS_COMPLETED then
					tStrategicSeasonTaskList = self.m_tTaskList.tStrategicSeasonTask.tCompleted
				end

				local nCount = table.getn(tStrategicSeasonTaskList)
				tStrategicSeasonTaskList[nCount+1] = {}
				tStrategicSeasonTaskList[nCount+1].nTargetStatus = 0
				tStrategicSeasonTaskList[nCount+1].nTargetValue = 0
				tStrategicSeasonTaskList[nCount+1].nId = v
				tStrategicSeasonTaskList[nCount+1].nTaskType =  m_tTaskData.type
				tStrategicSeasonTaskList[nCount+1].nTaskStatus = status[i]
				tStrategicSeasonTaskList[nCount+1].nTargetStatus=complete[i]
				tStrategicSeasonTaskList[nCount+1].nTargetValue=target[i]
			end
		end 
	end

	WZLog("self.m_tTaskList.tStrategicDailyTask",Serialize(self.m_tTaskList.tStrategicDailyTask))
	WZLog("self.m_tTaskList.tStrategicSeasonTask",Serialize(self.m_tTaskList.tStrategicSeasonTask))

    if GlobalGame.g_nMainTaskCount > 0 or GlobalGame.g_nBranchTaskCount > 0 or GlobalGame.g_nDailyTaskCount > 0 or GlobalGame.g_nAthleticsTaskCount > 0 or self:whetherHaveBoxActive() or GlobalGame.g_nProfessionTaskCount > 0 then 
        CacheCenter:setRedState("btnTask",true,3)
    else 
        CacheCenter:setRedState("btnTask",false,4)
    end
    GlobalGame:getBtnRedPointEvent():dispatcher()

    --日常任务有更新
    if WndTask.m_root ~= nil then 
    	WndTask:onCloseAnim()
    end 
end

--@brief	设置游戏大厅房间列表数据
function PrefetchCache:setHallRoomList(roomCount, roomId, roomName, battleStatus, battleMode, playerNumMode, passWord, playerNum, startMode, roomStaus)
	self.m_tHallRoomList = {}
	self.m_tHallRoomList.roomCount = roomCount
	self.m_tHallRoomList.roomId = VectorToTable(roomId)
	self.m_tHallRoomList.roomName = VectorToTable(roomName)
	self.m_tHallRoomList.battleStatus = VectorToTable(battleStatus)
	self.m_tHallRoomList.battleMode = VectorToTable(battleMode)
	self.m_tHallRoomList.playerNumMode = VectorToTable(playerNumMode)
	self.m_tHallRoomList.passWord = VectorToTable(passWord)
	self.m_tHallRoomList.playerNum = VectorToTable(playerNum)
	self.m_tHallRoomList.startMode = VectorToTable(startMode)
	self.m_tHallRoomList.roomStaus = VectorToTable(roomStaus)
end

function PrefetchCache:setVipList(vipExp, vipLv, nextLvExp, isReceiveDayPack)
	self.m_tVipInfo = {vipExp, vipLv, nextLvExp, isReceiveDayPack} 
end 

--@brief 	任务删减
function PrefetchCache:RemoveTask(id,nType,nTaskStatus)
	WZLog("PrefetchCache:RemoveTask= "..id.."|"..nType)
	if nType == 1  then
		local Count = #self.m_tTaskList.tMainTask
    	for j=1,#self.m_tTaskList.tMainTask do
    		if  self.m_tTaskList.tMainTask[j].nId == id and nTaskStatus == TASKSTATUS_COMPLETED then
    			table.remove(self.m_tTaskList.tMainTask, j)
    			break
    		end
    	end
    elseif nType == 2 then
    	for j=1,#self.m_tTaskList.tBranchTask do
    		if  self.m_tTaskList.tBranchTask[j].nId == id and nTaskStatus == TASKSTATUS_COMPLETED then
    			table.remove(self.m_tTaskList.tBranchTask, j)
    			break 
    		end
    	end
    elseif nType == 3 then
        --先遍历正在进行任务列表
        if nTaskStatus == TASKSTATUS_COMPLETED then
            for j,v in pairs(self.m_tTaskList.tDailyTask.tToSubmit) do
                if v.nId == id then
                    v.nTaskStatus = nTaskStatus
                    v.nTargetStatus = 0
                    v.nTargetValue = 0
                    table.insert(self.m_tTaskList.tDailyTask.tCompleted, v)
                    table.remove(self.m_tTaskList.tDailyTask.tToSubmit, j)
                    break
                end
            end
        end
    elseif nType == 9 then
        if nTaskStatus == TASKSTATUS_COMPLETED then
            for j,v in pairs(self.m_tTaskList.tAthleticsTask.tToSubmit) do
                if v.nId == id then
                    v.nTaskStatus = nTaskStatus
                    v.nTargetStatus = 0
                    v.nTargetValue = 0
                    table.insert(self.m_tTaskList.tAthleticsTask.tCompleted, v)
                    table.remove(self.m_tTaskList.tAthleticsTask.tToSubmit, j)
                    break
                end
            end
        end
    elseif nType == 8 then
        if nTaskStatus == TASKSTATUS_COMPLETED then
            for j,v in pairs(self.m_tTaskList.tProfessionTask.tToSubmit) do
                if v.nId == id then
                    v.nTaskStatus = nTaskStatus
                    v.nTargetStatus = 0
                    v.nTargetValue = 0
                    table.insert(self.m_tTaskList.tProfessionTask.tCompleted, v)
                    table.remove(self.m_tTaskList.tProfessionTask.tToSubmit, j)
                    break
                end
            end
        end
    elseif nType == 10 then
        if nTaskStatus == TASKSTATUS_COMPLETED then
            for j,v in pairs(self.m_tTaskList.tStrategicDailyTask.tToSubmit) do
                if v.nId == id then
                    v.nTaskStatus = nTaskStatus
                    v.nTargetStatus = 0
                    v.nTargetValue = 0
                    table.insert(self.m_tTaskList.tStrategicDailyTask.tCompleted, v)
                    table.remove(self.m_tTaskList.tStrategicDailyTask.tToSubmit, j)
                    break
                end
            end
        end
    elseif nType == 9 then
        if nTaskStatus == TASKSTATUS_COMPLETED then
            for j,v in pairs(self.m_tTaskList.tStrategicSeasonTask.tToSubmit) do
                if v.nId == id then
                    v.nTaskStatus = nTaskStatus
                    v.nTargetStatus = 0
                    v.nTargetValue = 0
                    table.insert(self.m_tTaskList.tStrategicSeasonTask.tCompleted, v)
                    table.remove(self.m_tTaskList.tStrategicSeasonTask.tToSubmit, j)
                    break
                end
            end
        end
    end
end

--@brief 添加可以进行的任务
function PrefetchCache:addNewTask(list, task)
    table.insert(list,task)

    if GDatatab_story_talk and WndTeachTalk:IsNoExist() then
        for i ,v in pairs (GDatatab_story_talk) do
            if type(v.triggerWay) == "table" then
--                WZLog("PrefetchCache:addNewTask one",i,v.triggerWay[1][1],v.triggerWay[1][2],task.nId)
                if v.triggerWay[1][1] == TRIGGER_TASK_GET and v.triggerWay[1][2] == task.nId then
                    WZLog("PrefetchCache:addNewTask two")
                    CreateStoryTalkGroup(v.storyId)
                    break
                end
            end
        end
    end
end

--@brief 	检测任务的完成状态
function PrefetchCache:CheckTaskListState( nIndex )

	if type(self.m_tTaskList) ~= "table" then
		return
	end
	if nIndex == 1  then --主线
		GlobalGame.g_nMainTaskCount = 0 
		for idx_main,data in pairs(self.m_tTaskList.tMainTask) do
			if TASKSTATUS_TOSUBMIT == data.nTaskStatus then  --可提交
    			GlobalGame.g_nMainTaskCount = GlobalGame.g_nMainTaskCount + 1
			end
		end
    elseif nIndex == 2 then --支线
    	GlobalGame.g_nBranchTaskCount = 0 
		for idx_branch,data in pairs (self.m_tTaskList.tBranchTask) do
    		if TASKSTATUS_TOSUBMIT == data.nTaskStatus then  --可提交
    			GlobalGame.g_nBranchTaskCount = GlobalGame.g_nBranchTaskCount + 1
			end
    	end
    elseif nIndex == 3 then --日常
    	if #self.m_tTaskList.tDailyTask.tToSubmit > 0 then 
    		GlobalGame.g_nDailyTaskCount = #self.m_tTaskList.tDailyTask.tToSubmit
    	else 
    		GlobalGame.g_nDailyTaskCount = 0
    	end 
    elseif nIndex == 4 then --竞技
    	if #self.m_tTaskList.tAthleticsTask.tToSubmit > 0 then 
    		GlobalGame.g_nAthleticsTaskCount = #self.m_tTaskList.tAthleticsTask.tToSubmit
    	else 
    		GlobalGame.g_nAthleticsTaskCount = 0
    	end
    elseif nIndex == 5 then --职业
    	if #self.m_tTaskList.tProfessionTask.tToSubmit > 0 then 
    		GlobalGame.g_nProfessionTaskCount = #self.m_tTaskList.tProfessionTask.tToSubmit
    	else 
    		GlobalGame.g_nProfessionTaskCount = 0
    	end 
    elseif nIndex == 6 then --战略赛每日
    	if #self.m_tTaskList.tStrategicDailyTask.tToSubmit > 0 then 
    		GlobalGame.g_nStrategicDailyTaskCount = #self.m_tTaskList.tStrategicDailyTask.tToSubmit
    	else 
    		GlobalGame.g_nStrategicDailyTaskCount = 0
    	end 
    elseif nIndex == 7 then --战略赛赛季
    	if #self.m_tTaskList.tStrategicSeasonTask.tToSubmit > 0 then 
    		GlobalGame.g_nStrategicSeasonTaskCount = #self.m_tTaskList.tStrategicSeasonTask.tToSubmit
    	else 
    		GlobalGame.g_nStrategicSeasonTaskCount = 0
    	end 
    end 
end

--@brief	任务状态变更协议  add by wuweidong
function PrefetchCache:updateTaskStatus(id, status, target, complete)
	WZLog("PrefetchCache:updateTaskStatus", Serialize(id))
	if type(self.m_tTaskList) ~= "table" then
		return
	end
	for i=1,#id do
		local taskId = id[i] 
		if status[i] == TASKSTATUS_STALE then 
			WZLog("PrefetchCache:updateTaskStatus::任务已过期!")
			WZLog("过期任务id="..taskId)
		end 
		local m_tTaskData = GDatatab_task["id_"..taskId]
		if m_tTaskData.type == 1  then
			if status[i] == 0 then 
				WZLog("PrefetchCache:updateTaskStatus .......新增任务!")
				WZLog("name="..m_tTaskData.name)
				WZLog("desc="..m_tTaskData.desc)
			end 
			local isEnd = false
    		for j=1,#self.m_tTaskList.tMainTask do
    			if self.m_tTaskList.tMainTask[j].nId == taskId then
    				self.m_tTaskList.tMainTask[j].nTargetStatus = complete[i]
    				self.m_tTaskList.tMainTask[j].nTaskStatus = status[i]
    				if TASKSTATUS_TOSUBMIT == status[i] then  --可提交
    					GlobalGame.g_nMainTaskCount = GlobalGame.g_nMainTaskCount + 1
    					WZLog("在PrefetchCache 里+1 >>"..GlobalGame.g_nMainTaskCount)
					end
    				isEnd = true 
    			end
    		end
    		if isEnd==false  then 
    			local list_MainTask	= {}
				list_MainTask.nId = id[i]
				list_MainTask.nTaskStatus = status[i]
				if TASKSTATUS_TOSUBMIT == status[i] then  --可提交
    				GlobalGame.g_nMainTaskCount = GlobalGame.g_nMainTaskCount + 1
    				WZLog("在PrefetchCache 里+1 >2>"..GlobalGame.g_nMainTaskCount)
				end
				list_MainTask.nTargetStatus = 0
				list_MainTask.nTargetValue = 0
				list_MainTask.nTaskType = m_tTaskData.type
				list_MainTask.nTargetStatus=complete[i]
				list_MainTask.nTargetValue=target[i]
    			self:addNewTask(self.m_tTaskList.tMainTask,list_MainTask)
    		end 
    	elseif m_tTaskData.type == 2 then
    		local isEnd = false
    		for j=1,#self.m_tTaskList.tBranchTask do
    			if  self.m_tTaskList.tBranchTask[j].nId == taskId then
    				self.m_tTaskList.tBranchTask[j].nTargetStatus = complete[i]
    				self.m_tTaskList.tBranchTask[j].nTaskStatus = status[i]
    				if TASKSTATUS_TOSUBMIT == status[i] then  --可提交
    					GlobalGame.g_nBranchTaskCount = GlobalGame.g_nBranchTaskCount + 1
					end
					isEnd = true
    			end
    		end
    		if isEnd==false then 
    			local list_BranchTask	= {}
				list_BranchTask.nId = id[i]
				list_BranchTask.nTaskStatus = status[i]
				if TASKSTATUS_TOSUBMIT == status[i] then  --可提交
    				GlobalGame.g_nBranchTaskCount = GlobalGame.g_nBranchTaskCount + 1
				end
				list_BranchTask.nTargetStatus = 0
				list_BranchTask.nTargetValue = 0
				list_BranchTask.nTaskType = m_tTaskData.type
				list_BranchTask.nTargetStatus=complete[i]
				list_BranchTask.nTargetValue=target[i]
    			self:addNewTask(self.m_tTaskList.tBranchTask,list_BranchTask)
    		end
   	 	elseif m_tTaskData.type == 3 then
   	 		local bIsAdd = self:whetherAddShareTask(m_tTaskData)
   	 		if bIsAdd then
	        	if status[i] == TASKSTATUS_TOSUBMIT then
	        		local isEnd = false
					for j,v in pairs(self.m_tTaskList.tDailyTask.tDoing) do
						if v.nId == taskId  then
							v.nTaskStatus = status[i]
							v.nTargetStatus = complete[i] --modify in 2014/10/22 
							table.insert(self.m_tTaskList.tDailyTask.tToSubmit,v)
							table.remove(self.m_tTaskList.tDailyTask.tDoing, j)
							if TASKSTATUS_TOSUBMIT == status[i] then  --可提交
								GlobalGame.g_nDailyTaskCount = GlobalGame.g_nDailyTaskCount + 1
							end
							isEnd = true
							break
						end
					end
					if isEnd==false then 
	    				local list_DailyTask= {}
						list_DailyTask.nId = id[i]
						list_DailyTask.nTaskStatus = status[i]
						if TASKSTATUS_TOSUBMIT == status[i] then  --可提交
							GlobalGame.g_nDailyTaskCount = GlobalGame.g_nDailyTaskCount + 1
						end
						list_DailyTask.nTargetStatus = 0
						list_DailyTask.nTargetValue = 0
						list_DailyTask.nTaskType = m_tTaskData.type
						list_DailyTask.nTargetStatus=complete[i]
						list_DailyTask.nTargetValue=target[i]
	    				table.insert(self.m_tTaskList.tDailyTask.tToSubmit,list_DailyTask)
	    			end
				elseif status[i] == TASKSTATUS_COMPLETED then
					WZLog("============PrefetchCacheData 1>"..complete[i])
					WZLog("============PrefetchCacheData 2>"..target[i])
					local bFound = false
					--先遍历正在进行任务列表
					for j,v in pairs(self.m_tTaskList.tDailyTask.tDoing) do
						if v.nId == taskId then
							v.nTaskStatus = status[i]
							v.nTargetStatus = 0
							v.nTargetValue = 0
							table.insert(self.m_tTaskList.tDailyTask.tCompleted, v)
							table.remove(self.m_tTaskList.tDailyTask.tDoing, j)
							bFound = true
							break
						end
					end
					--未找到要更新的任务则遍历待提交任务列表
					if not bFound then
						for j,v in pairs(self.m_tTaskList.tDailyTask.tToSubmit) do
							if v.nId == taskId then
								v.nTaskStatus = status[i]
								v.nTargetStatus = 0
								v.nTargetValue = 0
								table.insert(self.m_tTaskList.tDailyTask.tCompleted, v)
								table.remove(self.m_tTaskList.tDailyTask.tToSubmit, j)
								break
							end
						end
					end
				else
					local isEnd = false
					for j,v in pairs(self.m_tTaskList.tDailyTask.tDoing) do
						if v.nId == taskId then
							v.nTargetStatus = complete[i]
							v.nTargetValue = target[i]
							v.nTaskStatus = status[i]
							isEnd = true
							break
						end
					end

					--判断已完成的任务列表中是否有过期任务
					if status[i] == TASKSTATUS_STALE then 
						for j,v in pairs(self.m_tTaskList.tDailyTask.tCompleted) do
							if v.nId == taskId then
								v.nTaskStatus = status[i]
								break
							end
						end
					end 

					if isEnd==false then 
	    				local list_DailyTask	= {}
						list_DailyTask.nId = id[i]
						list_DailyTask.nTaskStatus = status[i]
						list_DailyTask.nTargetStatus = 0
						list_DailyTask.nTargetValue = 0
						list_DailyTask.nTaskType = m_tTaskData.type
						list_DailyTask.nTargetStatus=complete[i]
						list_DailyTask.nTargetValue=target[i]
						if TASKSTATUS_TOSUBMIT == status[i] then  --可提交
							GlobalGame.g_nDailyTaskCount = GlobalGame.g_nDailyTaskCount + 1
							self:addNewTask(self.m_tTaskList.tDailyTask.tToSubmit,list_DailyTask)
						else 
	    					self:addNewTask(self.m_tTaskList.tDailyTask.tDoing,list_DailyTask)
	    				end 
	    			end
				end
			end
		elseif m_tTaskData.type == 9 then
        	if status[i] == TASKSTATUS_TOSUBMIT then
        		local isEnd = false
				for j,v in pairs(self.m_tTaskList.tAthleticsTask.tDoing) do
					if v.nId == taskId  then
						v.nTaskStatus = status[i]
						v.nTargetStatus = complete[i] --modify in 2014/10/22 
						table.insert(self.m_tTaskList.tAthleticsTask.tToSubmit,v)
						table.remove(self.m_tTaskList.tAthleticsTask.tDoing, j)
						if TASKSTATUS_TOSUBMIT == status[i] then  --可提交
							GlobalGame.g_nAthleticsTaskCount = GlobalGame.g_nAthleticsTaskCount + 1
						end
						isEnd = true
						break
					end
				end
				if isEnd==false then 
    				local list_DailyTask= {}
					list_DailyTask.nId = id[i]
					list_DailyTask.nTaskStatus = status[i]
					if TASKSTATUS_TOSUBMIT == status[i] then  --可提交
						GlobalGame.g_nAthleticsTaskCount = GlobalGame.g_nAthleticsTaskCount + 1
					end
					list_DailyTask.nTargetStatus = 0
					list_DailyTask.nTargetValue = 0
					list_DailyTask.nTaskType = m_tTaskData.type
					list_DailyTask.nTargetStatus=complete[i]
					list_DailyTask.nTargetValue=target[i]
    				table.insert(self.m_tTaskList.tAthleticsTask.tToSubmit,list_DailyTask)
    			end
			elseif status[i] == TASKSTATUS_COMPLETED then
				local bFound = false
				--先遍历正在进行任务列表
				for j,v in pairs(self.m_tTaskList.tAthleticsTask.tDoing) do
					if v.nId == taskId then
						v.nTaskStatus = status[i]
						v.nTargetStatus = 0
						v.nTargetValue = 0
						table.insert(self.m_tTaskList.tAthleticsTask.tCompleted, v)
						table.remove(self.m_tTaskList.tAthleticsTask.tDoing, j)
						bFound = true
						break
					end
				end
				--未找到要更新的任务则遍历待提交任务列表
				if not bFound then
					for j,v in pairs(self.m_tTaskList.tAthleticsTask.tToSubmit) do
						if v.nId == taskId then
							v.nTaskStatus = status[i]
							v.nTargetStatus = 0
							v.nTargetValue = 0
							table.insert(self.m_tTaskList.tAthleticsTask.tCompleted, v)
							table.remove(self.m_tTaskList.tAthleticsTask.tToSubmit, j)
							break
						end
					end
				end
			else
				local isEnd = false
				for j,v in pairs(self.m_tTaskList.tAthleticsTask.tDoing) do
					if v.nId == taskId then
						v.nTargetStatus = complete[i]
						v.nTargetValue = target[i]
						v.nTaskStatus = status[i]
						isEnd = true
						break
					end
				end

				--判断已完成的任务列表中是否有过期任务
				if status[i] == TASKSTATUS_STALE then 
					for j,v in pairs(self.m_tTaskList.tAthleticsTask.tCompleted) do
						if v.nId == taskId then
							v.nTaskStatus = status[i]
							break
						end
					end
				end 

				if isEnd==false then 
    				local list_DailyTask	= {}
					list_DailyTask.nId = id[i]
					list_DailyTask.nTaskStatus = status[i]
					list_DailyTask.nTargetStatus = 0
					list_DailyTask.nTargetValue = 0
					list_DailyTask.nTaskType = m_tTaskData.type
					list_DailyTask.nTargetStatus=complete[i]
					list_DailyTask.nTargetValue=target[i]
					if TASKSTATUS_TOSUBMIT == status[i] then  --可提交
						GlobalGame.g_nAthleticsTaskCount = GlobalGame.g_nAthleticsTaskCount + 1
						self:addNewTask(self.m_tTaskList.tAthleticsTask.tToSubmit,list_DailyTask)
					else 
    					self:addNewTask(self.m_tTaskList.tAthleticsTask.tDoing,list_DailyTask)
    				end 
    			end
			end
		elseif m_tTaskData.type == 8 then
        	if status[i] == TASKSTATUS_TOSUBMIT then
        		local isEnd = false
				for j,v in pairs(self.m_tTaskList.tProfessionTask.tDoing) do
					if v.nId == taskId  then
						v.nTaskStatus = status[i]
						v.nTargetStatus = complete[i] --modify in 2014/10/22 
						table.insert(self.m_tTaskList.tProfessionTask.tToSubmit,v)
						table.remove(self.m_tTaskList.tProfessionTask.tDoing, j)
						if TASKSTATUS_TOSUBMIT == status[i] then  --可提交
							GlobalGame.g_nProfessionTaskCount = GlobalGame.g_nProfessionTaskCount + 1
						end
						isEnd = true
						break
					end
				end
				if isEnd==false then 
    				local list_ProfessionTask= {}
					list_ProfessionTask.nId = id[i]
					list_ProfessionTask.nTaskStatus = status[i]
					if TASKSTATUS_TOSUBMIT == status[i] then  --可提交
						GlobalGame.g_nProfessionTaskCount = GlobalGame.g_nProfessionTaskCount + 1
					end
					list_ProfessionTask.nTargetStatus = 0
					list_ProfessionTask.nTargetValue = 0
					list_ProfessionTask.nTaskType = m_tTaskData.type
					list_ProfessionTask.nTargetStatus=complete[i]
					list_ProfessionTask.nTargetValue=target[i]
    				table.insert(self.m_tTaskList.tProfessionTask.tToSubmit,list_ProfessionTask)
    			end
			elseif status[i] == TASKSTATUS_COMPLETED then
				local bFound = false
				--先遍历正在进行任务列表
				for j,v in pairs(self.m_tTaskList.tProfessionTask.tDoing) do
					if v.nId == taskId then
						v.nTaskStatus = status[i]
						v.nTargetStatus = 0
						v.nTargetValue = 0
						table.insert(self.m_tTaskList.tProfessionTask.tCompleted, v)
						table.remove(self.m_tTaskList.tProfessionTask.tDoing, j)
						bFound = true
						break
					end
				end
				--未找到要更新的任务则遍历待提交任务列表
				if not bFound then
					for j,v in pairs(self.m_tTaskList.tProfessionTask.tToSubmit) do
						if v.nId == taskId then
							v.nTaskStatus = status[i]
							v.nTargetStatus = 0
							v.nTargetValue = 0
							table.insert(self.m_tTaskList.tProfessionTask.tCompleted, v)
							table.remove(self.m_tTaskList.tProfessionTask.tToSubmit, j)
							break
						end
					end
				end
			else
				local isEnd = false
				for j,v in pairs(self.m_tTaskList.tProfessionTask.tDoing) do
					if v.nId == taskId then
						v.nTargetStatus = complete[i]
						v.nTargetValue = target[i]
						v.nTaskStatus = status[i]
						isEnd = true
						break
					end
				end

				--判断已完成的任务列表中是否有过期任务
				if status[i] == TASKSTATUS_STALE then 
					for j,v in pairs(self.m_tTaskList.tProfessionTask.tCompleted) do
						if v.nId == taskId then
							v.nTaskStatus = status[i]
							break
						end
					end
				end 

				if isEnd==false then 
    				local list_ProfessionTask	= {}
					list_ProfessionTask.nId = id[i]
					list_ProfessionTask.nTaskStatus = status[i]
					list_ProfessionTask.nTargetStatus = 0
					list_ProfessionTask.nTargetValue = 0
					list_ProfessionTask.nTaskType = m_tTaskData.type
					list_ProfessionTask.nTargetStatus=complete[i]
					list_ProfessionTask.nTargetValue=target[i]
					if TASKSTATUS_TOSUBMIT == status[i] then  --可提交
						GlobalGame.g_nProfessionTaskCount = GlobalGame.g_nProfessionTaskCount + 1
						self:addNewTask(self.m_tTaskList.tProfessionTask.tToSubmit,list_ProfessionTask)
					else 
    					self:addNewTask(self.m_tTaskList.tProfessionTask.tDoing,list_ProfessionTask)
    				end 
    			end
			end
		elseif m_tTaskData.type == 10 then
        	if status[i] == TASKSTATUS_TOSUBMIT then
        		local isEnd = false
				for j,v in pairs(self.m_tTaskList.tStrategicDailyTask.tDoing) do
					if v.nId == taskId  then
						v.nTaskStatus = status[i]
						v.nTargetStatus = complete[i] --modify in 2014/10/22 
						table.insert(self.m_tTaskList.tStrategicDailyTask.tToSubmit,v)
						table.remove(self.m_tTaskList.tStrategicDailyTask.tDoing, j)
						if TASKSTATUS_TOSUBMIT == status[i] then  --可提交
							GlobalGame.g_nStrategicDailyTaskCount = GlobalGame.g_nStrategicDailyTaskCount + 1
						end
						isEnd = true
						break
					end
				end
				if isEnd==false then 
    				local list_DailyTask= {}
					list_DailyTask.nId = id[i]
					list_DailyTask.nTaskStatus = status[i]
					if TASKSTATUS_TOSUBMIT == status[i] then  --可提交
						GlobalGame.g_nStrategicDailyTaskCount = GlobalGame.g_nStrategicDailyTaskCount + 1
					end
					list_DailyTask.nTargetStatus = 0
					list_DailyTask.nTargetValue = 0
					list_DailyTask.nTaskType = m_tTaskData.type
					list_DailyTask.nTargetStatus=complete[i]
					list_DailyTask.nTargetValue=target[i]
    				table.insert(self.m_tTaskList.tStrategicDailyTask.tToSubmit,list_DailyTask)
    			end
			elseif status[i] == TASKSTATUS_COMPLETED then
				local bFound = false
				--先遍历正在进行任务列表
				for j,v in pairs(self.m_tTaskList.tStrategicDailyTask.tDoing) do
					if v.nId == taskId then
						v.nTaskStatus = status[i]
						v.nTargetStatus = 0
						v.nTargetValue = 0
						table.insert(self.m_tTaskList.tStrategicDailyTask.tCompleted, v)
						table.remove(self.m_tTaskList.tStrategicDailyTask.tDoing, j)
						bFound = true
						break
					end
				end
				--未找到要更新的任务则遍历待提交任务列表
				if not bFound then
					for j,v in pairs(self.m_tTaskList.tStrategicDailyTask.tToSubmit) do
						if v.nId == taskId then
							v.nTaskStatus = status[i]
							v.nTargetStatus = 0
							v.nTargetValue = 0
							table.insert(self.m_tTaskList.tStrategicDailyTask.tCompleted, v)
							table.remove(self.m_tTaskList.tStrategicDailyTask.tToSubmit, j)
							break
						end
					end
				end
			else
				local isEnd = false
				for j,v in pairs(self.m_tTaskList.tStrategicDailyTask.tDoing) do
					if v.nId == taskId then
						v.nTargetStatus = complete[i]
						v.nTargetValue = target[i]
						v.nTaskStatus = status[i]
						isEnd = true
						break
					end
				end

				--判断已完成的任务列表中是否有过期任务
				if status[i] == TASKSTATUS_STALE then 
					for j,v in pairs(self.m_tTaskList.tStrategicDailyTask.tCompleted) do
						if v.nId == taskId then
							v.nTaskStatus = status[i]
							break
						end
					end
				end 

				if isEnd==false then 
    				local list_DailyTask	= {}
					list_DailyTask.nId = id[i]
					list_DailyTask.nTaskStatus = status[i]
					list_DailyTask.nTargetStatus = 0
					list_DailyTask.nTargetValue = 0
					list_DailyTask.nTaskType = m_tTaskData.type
					list_DailyTask.nTargetStatus=complete[i]
					list_DailyTask.nTargetValue=target[i]
					if TASKSTATUS_TOSUBMIT == status[i] then  --可提交
						GlobalGame.g_nStrategicDailyTaskCount = GlobalGame.g_nStrategicDailyTaskCount + 1
						self:addNewTask(self.m_tTaskList.tStrategicDailyTask.tToSubmit,list_DailyTask)
					else 
    					self:addNewTask(self.m_tTaskList.tStrategicDailyTask.tDoing,list_DailyTask)
    				end 
    			end
			end
		elseif m_tTaskData.type == 10 then
        	if status[i] == TASKSTATUS_TOSUBMIT then
        		local isEnd = false
				for j,v in pairs(self.m_tTaskList.tStrategicDailyTask.tDoing) do
					if v.nId == taskId  then
						v.nTaskStatus = status[i]
						v.nTargetStatus = complete[i] --modify in 2014/10/22 
						table.insert(self.m_tTaskList.tStrategicDailyTask.tToSubmit,v)
						table.remove(self.m_tTaskList.tStrategicDailyTask.tDoing, j)
						if TASKSTATUS_TOSUBMIT == status[i] then  --可提交
							GlobalGame.g_nStrategicDailyTaskCount = GlobalGame.g_nStrategicDailyTaskCount + 1
						end
						isEnd = true
						break
					end
				end
				if isEnd==false then 
    				local list_DailyTask= {}
					list_DailyTask.nId = id[i]
					list_DailyTask.nTaskStatus = status[i]
					if TASKSTATUS_TOSUBMIT == status[i] then  --可提交
						GlobalGame.g_nStrategicDailyTaskCount = GlobalGame.g_nStrategicDailyTaskCount + 1
					end
					list_DailyTask.nTargetStatus = 0
					list_DailyTask.nTargetValue = 0
					list_DailyTask.nTaskType = m_tTaskData.type
					list_DailyTask.nTargetStatus=complete[i]
					list_DailyTask.nTargetValue=target[i]
    				table.insert(self.m_tTaskList.tStrategicDailyTask.tToSubmit,list_DailyTask)
    			end
			elseif status[i] == TASKSTATUS_COMPLETED then
				local bFound = false
				--先遍历正在进行任务列表
				for j,v in pairs(self.m_tTaskList.tStrategicDailyTask.tDoing) do
					if v.nId == taskId then
						v.nTaskStatus = status[i]
						v.nTargetStatus = 0
						v.nTargetValue = 0
						table.insert(self.m_tTaskList.tStrategicDailyTask.tCompleted, v)
						table.remove(self.m_tTaskList.tStrategicDailyTask.tDoing, j)
						bFound = true
						break
					end
				end
				--未找到要更新的任务则遍历待提交任务列表
				if not bFound then
					for j,v in pairs(self.m_tTaskList.tStrategicDailyTask.tToSubmit) do
						if v.nId == taskId then
							v.nTaskStatus = status[i]
							v.nTargetStatus = 0
							v.nTargetValue = 0
							table.insert(self.m_tTaskList.tStrategicDailyTask.tCompleted, v)
							table.remove(self.m_tTaskList.tStrategicDailyTask.tToSubmit, j)
							break
						end
					end
				end
			else
				local isEnd = false
				for j,v in pairs(self.m_tTaskList.tStrategicDailyTask.tDoing) do
					if v.nId == taskId then
						v.nTargetStatus = complete[i]
						v.nTargetValue = target[i]
						v.nTaskStatus = status[i]
						isEnd = true
						break
					end
				end

				--判断已完成的任务列表中是否有过期任务
				if status[i] == TASKSTATUS_STALE then 
					for j,v in pairs(self.m_tTaskList.tStrategicDailyTask.tCompleted) do
						if v.nId == taskId then
							v.nTaskStatus = status[i]
							break
						end
					end
				end 

				if isEnd==false then 
    				local list_DailyTask	= {}
					list_DailyTask.nId = id[i]
					list_DailyTask.nTaskStatus = status[i]
					list_DailyTask.nTargetStatus = 0
					list_DailyTask.nTargetValue = 0
					list_DailyTask.nTaskType = m_tTaskData.type
					list_DailyTask.nTargetStatus=complete[i]
					list_DailyTask.nTargetValue=target[i]
					if TASKSTATUS_TOSUBMIT == status[i] then  --可提交
						GlobalGame.g_nStrategicDailyTaskCount = GlobalGame.g_nStrategicDailyTaskCount + 1
						self:addNewTask(self.m_tTaskList.tStrategicDailyTask.tToSubmit,list_DailyTask)
					else 
    					self:addNewTask(self.m_tTaskList.tStrategicDailyTask.tDoing,list_DailyTask)
    				end 
    			end
			end
		elseif m_tTaskData.type == 11 then
        	if status[i] == TASKSTATUS_TOSUBMIT then
        		local isEnd = false
				for j,v in pairs(self.m_tTaskList.tStrategicSeasonTask.tDoing) do
					if v.nId == taskId  then
						v.nTaskStatus = status[i]
						v.nTargetStatus = complete[i] --modify in 2014/10/22 
						table.insert(self.m_tTaskList.tStrategicSeasonTask.tToSubmit,v)
						table.remove(self.m_tTaskList.tStrategicSeasonTask.tDoing, j)
						if TASKSTATUS_TOSUBMIT == status[i] then  --可提交
							GlobalGame.g_nStrategicSeasonTaskCount = GlobalGame.g_nStrategicSeasonTaskCount + 1
						end
						isEnd = true
						break
					end
				end
				if isEnd==false then 
    				local list_DailyTask= {}
					list_DailyTask.nId = id[i]
					list_DailyTask.nTaskStatus = status[i]
					if TASKSTATUS_TOSUBMIT == status[i] then  --可提交
						GlobalGame.g_nStrategicSeasonTaskCount = GlobalGame.g_nStrategicSeasonTaskCount + 1
					end
					list_DailyTask.nTargetStatus = 0
					list_DailyTask.nTargetValue = 0
					list_DailyTask.nTaskType = m_tTaskData.type
					list_DailyTask.nTargetStatus=complete[i]
					list_DailyTask.nTargetValue=target[i]
    				table.insert(self.m_tTaskList.tStrategicSeasonTask.tToSubmit,list_DailyTask)
    			end
			elseif status[i] == TASKSTATUS_COMPLETED then
				local bFound = false
				--先遍历正在进行任务列表
				for j,v in pairs(self.m_tTaskList.tStrategicSeasonTask.tDoing) do
					if v.nId == taskId then
						v.nTaskStatus = status[i]
						v.nTargetStatus = 0
						v.nTargetValue = 0
						table.insert(self.m_tTaskList.tStrategicSeasonTask.tCompleted, v)
						table.remove(self.m_tTaskList.tStrategicSeasonTask.tDoing, j)
						bFound = true
						break
					end
				end
				--未找到要更新的任务则遍历待提交任务列表
				if not bFound then
					for j,v in pairs(self.m_tTaskList.tStrategicSeasonTask.tToSubmit) do
						if v.nId == taskId then
							v.nTaskStatus = status[i]
							v.nTargetStatus = 0
							v.nTargetValue = 0
							table.insert(self.m_tTaskList.tStrategicSeasonTask.tCompleted, v)
							table.remove(self.m_tTaskList.tStrategicSeasonTask.tToSubmit, j)
							break
						end
					end
				end
			else
				local isEnd = false
				for j,v in pairs(self.m_tTaskList.tStrategicSeasonTask.tDoing) do
					if v.nId == taskId then
						v.nTargetStatus = complete[i]
						v.nTargetValue = target[i]
						v.nTaskStatus = status[i]
						isEnd = true
						break
					end
				end

				--判断已完成的任务列表中是否有过期任务
				if status[i] == TASKSTATUS_STALE then 
					for j,v in pairs(self.m_tTaskList.tStrategicSeasonTask.tCompleted) do
						if v.nId == taskId then
							v.nTaskStatus = status[i]
							break
						end
					end
				end 

				if isEnd==false then 
    				local list_DailyTask	= {}
					list_DailyTask.nId = id[i]
					list_DailyTask.nTaskStatus = status[i]
					list_DailyTask.nTargetStatus = 0
					list_DailyTask.nTargetValue = 0
					list_DailyTask.nTaskType = m_tTaskData.type
					list_DailyTask.nTargetStatus=complete[i]
					list_DailyTask.nTargetValue=target[i]
					if TASKSTATUS_TOSUBMIT == status[i] then  --可提交
						GlobalGame.g_nStrategicSeasonTaskCount = GlobalGame.g_nStrategicSeasonTaskCount + 1
						self:addNewTask(self.m_tTaskList.tStrategicSeasonTask.tToSubmit,list_DailyTask)
					else 
    					self:addNewTask(self.m_tTaskList.tStrategicSeasonTask.tDoing,list_DailyTask)
    				end 
    			end
			end
    	end 
	end

	if WndTask.m_root ~= nil then 
		WZLog("******* updateUIFunc 4444444 ********")
		WndTask:updateUIFunc( )
	end 
	if SceneCity.m_root then 
		SceneCity:updateCityTask()
	end
	if WndSingleCopy and WndSingleCopy.m_root then 
		WndSingleCopy:updateCityTask()
	end
    --Teach:openTeachByTask(taskId, taskType, status,targetStatus)
   	if GlobalGame.g_nMainTaskCount > 0 or GlobalGame.g_nBranchTaskCount > 0 or GlobalGame.g_nDailyTaskCount > 0 or GlobalGame.g_nAthleticsTaskCount > 0 or self:whetherHaveBoxActive() or GlobalGame.g_nProfessionTaskCount > 0 then 
        CacheCenter:setRedState("btnTask",true,5)
    else 
        CacheCenter:setRedState("btnTask",false,6)
    end
    if SceneCity.m_root ~= nil and SceneCity.m_tWndBottomBarObj then
    	CacheCenter:updateRedPoint("right",SceneCity.m_tWndBottomBarObj.m_root,"btnTask",8)
    end
    GlobalGame:getBtnRedPointEvent():dispatcher()

    if GlobalGame.g_tWndBottomBarObj and GlobalGame.g_tWndBottomBarObj.m_root then
        CacheCenter:updateRedPoint("right",GlobalGame.g_tWndBottomBarObj.m_root,nil,9)
    end
end

--@brief	公告列表
function PrefetchCache:setBulletinList(title, content)
	self.m_tNoticeList = {}
	for i=1,#title do
		WZLog("PrefetchCache:setBulletinList=>title="..title[i])
		local noticeItem = {}
		noticeItem.theme 	= title[i]
		noticeItem.content 	= content[i]
		table.insert(self.m_tNoticeList,noticeItem)
	end
	if #self.m_tNoticeList > 0 then 
		if GlobalGame.g_bIsActivityUIShow == false and WndAnnouncement.m_root == nil and SceneCity.m_root ~= nil and WndAnnouncement.m_root==nil then 
			-- local wndAnnouncement = WndAnnouncement:createElement()
   --      	if wndAnnouncement ~= nil   then
   --      		GlobalGame.g_bIsActivityUIShow = true
   --         		WindowManager:addWindow(wndAnnouncement,WndAnnouncement,nil,false)
   --      	end
		end
	end
end

--@brief 日常任务奖励提升
function PrefetchCache:updateTaskRewards(taskId)
	--TaskCacheIsChanage.m_bTaskCacheIsChanage = true
	WZLog("PrefetchCache:updateTaskRewards...taskId.."..taskId)

	--local tRewardsNum = {}
	local bFound = false
	--先遍历待提交任务列表
	for i,v in pairs(self.m_tTaskList.tDailyTask.tToSubmit) do
		if v.nId == taskId then
			v.nUpLevel = v.nUpLevel+1
			--if v.nUpLevel==0 then
			--	v.nUpLevel = v.nUpLevel+2
			--elseif v.nUpLevel< self.m_tTaskList.tDailyTask.nTaskTopLevel then
			--	v.nUpLevel = v.nUpLevel+1 
			--else
			--	v.nUpLevel = self.m_tTaskList.tDailyTask.nTaskTopLevel
			--end
			--for i = v.nUpLevel,table.getn(v.tUpCount),self.m_tTaskList.tDailyTask.nTaskTopLevel do
			--	table.insert(tRewardsNum, v.tUpCount[i])
			--end
			bFound = true
			--v:improveTaskRewards(tRewardsNum)
			break
		end
	end
	--未找到要更新的任务则遍历正在进行任务列表
	if not bFound then
		for i,v in pairs(self.m_tTaskList.tDailyTask.tDoing) do
			if v.nId == taskId then
				v.nUpLevel  = v.nUpLevel+1
				--WZLog("updateTaskRewards::NOT")
				--if v.nUpLevel==0 then
				--	v.nUpLevel = v.nUpLevel+2
				--elseif v.nUpLevel< self.m_tTaskList.tDailyTask.nTaskTopLevel then
				--	v.nUpLevel = v.nUpLevel+1 
				--else
				--	v.nUpLevel = self.m_tTaskList.tDailyTask.nTaskTopLevel
				--end
				--for i=v.nUpLevel,table.getn(v.tUpCount),self.m_tTaskList.tDailyTask.nTaskTopLevel do
				--	table.insert(tRewardsNum, v.tUpCount[i])
				--end
				--v:improveTaskRewards(tRewardsNum)
				break
			end
		end
	end
end

--@brief 用户月卡信息
function PrefetchCache:updateMonthlyCardInfo(nHasBuy,lastDays)
	self.m_tMonthlyCardInfo = {}
	self.m_tMonthlyCardInfo.nHasBuy = nHasBuy
	self.m_tMonthlyCardInfo.lastDays = lastDays
end

--@brief 重载缓存
function PrefetchCache:reset( )
	WZLog("PrefetchCache:reset()")
	self.m_tCommunityList = nil       --公会列表数据
	self.m_tQualifyList = nil          --排位赛列表数据
	self.m_tTaskList = nil 			   --任务列表
	self.m_tHallRoomList = nil        --大厅房间列表
	self.m_tVipInfo = nil				--VIP信息
	self.m_tVipLevelGiftList = nil		--VIP等级礼包
	self.m_tVipDailyGiftList = nil 		--VIP每日礼包
	self.m_tMonthlyCardInfo = nil     --月卡信息
	self.m_tNoticeList = nil 

	GlobalGame.g_nMainTaskCount = 0 --主线任务未领取数量
    GlobalGame.g_nBranchTaskCount = 0 --支线任务未领取数量
    GlobalGame.g_nDailyTaskCount = 0 --日常任务未领取数量
    GlobalGame.g_nAthleticsTaskCount = 0 --竞技任务未领取数量
    GlobalGame.g_nProfessionTaskCount = 0 --职业任务未领取数量
    GlobalGame.g_nStrategicDailyTaskCount = 0 --战略赛每日任务未领取数量
    GlobalGame.g_nStrategicSeasonTaskCount = 0 --战略赛赛季任务未领取数量
end

--brief 	返回各类任务状态
function PrefetchCache:getTaskStatusList()
	-- body
	if not self.m_tTaskList then
		return {},{}
	end
	local tDoneList = {}
	if GlobalGame.g_nMainTaskCount > 0 then 	--主线
		table.insert(tDoneList, 1)
	else
		table.insert(tDoneList, 0)
	end
    if GlobalGame.g_nDailyTaskCount > 0 then   --日常
		table.insert(tDoneList, 1)
    else
		table.insert(tDoneList, 0)
    end
    if GlobalGame.g_nBranchTaskCount > 0 then 	--支线
		table.insert(tDoneList, 1)
    else
		table.insert(tDoneList, 0)
    end

    local tDoingList = {}
    if self.m_tTaskList and #self.m_tTaskList.tMainTask > 0 then
    	table.insert(tDoingList, 1)
    else
    	table.insert(tDoingList, 0)
    end
    if self.m_tTaskList and #self.m_tTaskList.tDailyTask.tDoing > 0 then
    	table.insert(tDoingList, 1)
    else
    	table.insert(tDoingList, 0)
    end
    if self.m_tTaskList and #self.m_tTaskList.tBranchTask > 0 then
    	table.insert(tDoingList, 1)
    else
    	table.insert(tDoingList, 0)
    end

    return tDoneList, tDoingList
end

--@brief    领取任务奖励成功
function PrefetchCache:afterReceiveOK(nTaskId, nTaskType, nTaskStatus)
    -- body
    --主线任务
    self:RemoveTask(nTaskId,nTaskType, nTaskStatus)
    if 1 == nTaskType then
        self:CheckTaskListState(1)
    elseif 2 == nTaskType then
        self:CheckTaskListState(2)
    --每日任务
    elseif 3 == nTaskType then
        self:CheckTaskListState(3)
    --竞技任务
    elseif 9 == nTaskType then
        self:CheckTaskListState(4)
    --职业任务
    elseif 8 == nTaskType then
        self:CheckTaskListState(5)
    --战略赛每日
    elseif 10 == nTaskType then
        self:CheckTaskListState(6)
    --战略赛赛季
    elseif 11 == nTaskType then
        self:CheckTaskListState(7)
    end 

    WZLog("******* 22222222 *********")
    if GlobalGame.g_nMainTaskCount > 0 or GlobalGame.g_nBranchTaskCount > 0 or GlobalGame.g_nDailyTaskCount > 0 or GlobalGame.g_nAthleticsTaskCount > 0 or self:whetherHaveBoxActive() or GlobalGame.g_nProfessionTaskCount > 0 then 
        CacheCenter:setRedState("btnTask",true,1)
    else 
        CacheCenter:setRedState("btnTask",false,2)
    end
    GlobalGame:getBtnRedPointEvent():dispatcher()
end

--@brief 	判断日常任务活跃度宝箱是否存在可以领取的
function PrefetchCache:whetherHaveBoxActive()
	-- body
	if not self.m_tTaskList then 
		return false
	end
	if self.m_tTaskList.boxStatus == nil or self.m_tTaskList.boxStatus == {} then return false end

	for i = 1, #self.m_tTaskList.boxStatus do
		if self.m_tTaskList.boxStatus[i] == 1 then 
			return true
		end
	end

	return false 
end

--@brief 	更新某宝箱的状态
--@param 	nIndex: 宝箱的索引
function PrefetchCache:updateActivityBoxStatus(nIndex, status)
	-- body
	if self.m_tTaskList and self.m_tTaskList.boxStatus then 
		self.m_tTaskList.boxStatus[nIndex] = status
	end
end

--@brief 	获取宝箱的状态
function PrefetchCache:getActivityBoxStatus()
	-- body
	return self.m_tTaskList.boxStatus
end

--@brief 	获取职业任务未完成的任务数量
function PrefetchCache:getProfessionTaskDoingNum()
	-- body
	if self.m_tTaskList == nil then return 0 end
	if self.m_tTaskList.tProfessionTask == nil then return 0 end 

	return #self.m_tTaskList.tProfessionTask.tDoing
end

--@brief 	获取主城中显示的任务
function PrefetchCache:getCityTask()
	if not self.m_tTaskList then return end
	
	-- body
	local cityTaskList = {}
	--主线
	for i, value in pairs(self.m_tTaskList.tMainTask) do
		local taskData = GDatatab_task["id_" .. value.nId]
		if value.nTaskStatus == TASKSTATUS_TOSUBMIT or (value.nTaskStatus == TASKSTATUS_DOING and taskData.liushui <= 9000) then 
			table.insert(cityTaskList, value)
		end
	end
	--支线
	if CheckButtonOpen(37, false) then 
		for i, value in pairs(self.m_tTaskList.tBranchTask) do
			local taskData = GDatatab_task["id_" .. value.nId]
			if value.nTaskStatus == TASKSTATUS_TOSUBMIT or (value.nTaskStatus == TASKSTATUS_DOING and taskData.liushui <= 9000) then
				table.insert(cityTaskList, value)
			end
		end
	end
	--日常
	if CheckButtonOpen(38, false) then 
		for i, value in pairs(self.m_tTaskList.tDailyTask.tToSubmit) do
			table.insert(cityTaskList, value)
		end
		for i, value in pairs(self.m_tTaskList.tDailyTask.tDoing) do
			local taskData = GDatatab_task["id_" .. value.nId]
			if taskData.liushui <= 9000 then 
				table.insert(cityTaskList, value)
			end
		end
	end
	--竞技 
	if CheckButtonOpen(5, false) then
		for i, value in pairs(self.m_tTaskList.tAthleticsTask.tToSubmit) do
			table.insert(cityTaskList, value)
		end
		for i, value in pairs(self.m_tTaskList.tAthleticsTask.tDoing) do
			local taskData = GDatatab_task["id_" .. value.nId]
			if taskData.liushui <= 9000 then 
				table.insert(cityTaskList, value)
			end
		end
	end
	local function getTempSortType(a)
		-- body
		local taskData = GDatatab_task["id_" .. a.nId]
		if taskData.type == 3 then 
			return 6
		elseif taskData.type == 9 then 
			return 5
		else
			return taskData.type
		end
	end
	--排序
	local function sortList(a, b)
		-- body
		if a.nTaskStatus ~= b.nTaskStatus then 
			return a.nTaskStatus > b.nTaskStatus 
		else
			if a.nTaskStatus == TASKSTATUS_TOSUBMIT then 
				return a.nId < b.nId
			else
				local taskDataA = GDatatab_task["id_" .. a.nId]
				local taskDataB = GDatatab_task["id_" .. b.nId]
				local nTypeA = getTempSortType(a)
				local nTypeB = getTempSortType(b)
				if nTypeA ~= nTypeB then 
					return nTypeA > nTypeB
				else
					return taskDataA.liushui < taskDataB.liushui
				end
			end
		end
	end
	table.sort(cityTaskList, sortList)

	return cityTaskList
end

--@brief 	获取单人副本中显示的任务
function PrefetchCache:getSingleCopyTask()
	-- body
	local cityTaskList = {}
	--主线
	for i, value in pairs(self.m_tTaskList.tMainTask) do
		local taskData = GDatatab_task["id_" .. value.nId]
		if value.nTaskStatus == TASKSTATUS_TOSUBMIT or (value.nTaskStatus == TASKSTATUS_DOING and taskData.liushui <= 9000) then 
			table.insert(cityTaskList, value)
		end
	end
	--支线
	if CheckButtonOpen(37, false) then 
		for i, value in pairs(self.m_tTaskList.tBranchTask) do
			local taskData = GDatatab_task["id_" .. value.nId]
			if value.nTaskStatus == TASKSTATUS_TOSUBMIT or (value.nTaskStatus == TASKSTATUS_DOING and taskData.liushui <= 9000) then
				table.insert(cityTaskList, value)
			end
		end
	end
	--日常
	if CheckButtonOpen(38, false) then 
		for i, value in pairs(self.m_tTaskList.tDailyTask.tToSubmit) do
			table.insert(cityTaskList, value)
		end
		for i, value in pairs(self.m_tTaskList.tDailyTask.tDoing) do
			local taskData = GDatatab_task["id_" .. value.nId]
			if taskData.liushui <= 9000 then 
				table.insert(cityTaskList, value)
			end
		end
	end
	--竞技 
	if CheckButtonOpen(5, false) then
		for i, value in pairs(self.m_tTaskList.tAthleticsTask.tToSubmit) do
			table.insert(cityTaskList, value)
		end
		for i, value in pairs(self.m_tTaskList.tAthleticsTask.tDoing) do
			local taskData = GDatatab_task["id_" .. value.nId]
			if taskData.liushui <= 9000 then 
				table.insert(cityTaskList, value)
			end
		end
	end
	local function getTempSortType(a)
		-- body
		local taskData = GDatatab_task["id_" .. a.nId]
		if taskData.type == 1 then 
			return 6
		elseif taskData.type == 3 then 
			return 5
		elseif taskData.type == 9 then 
			return 4
		else
			return taskData.type
		end
	end
	--排序
	local function sortList(a, b)
		-- body
		if a.nTaskStatus ~= b.nTaskStatus then 
			return a.nTaskStatus > b.nTaskStatus 
		else
			local taskDataA = GDatatab_task["id_" .. a.nId]
			local taskDataB = GDatatab_task["id_" .. b.nId]
			if a.nTaskStatus == TASKSTATUS_TOSUBMIT then 
				return taskDataA.liushui < taskDataB.liushui
			else
				local nTypeA = getTempSortType(a)
				local nTypeB = getTempSortType(b)
				if nTypeA ~= nTypeB then 
					return nTypeA > nTypeB
				else
					return taskDataA.liushui < taskDataB.liushui
				end
			end
		end
	end
	table.sort(cityTaskList, sortList)

	return cityTaskList
end

function PrefetchCache:updateRedDot()
	WZLog("PrefetchCache:updateRedDot",GlobalGame.g_nMainTaskCount, GlobalGame.g_nBranchTaskCount, GlobalGame.g_nDailyTaskCount, GlobalGame.g_nAthleticsTaskCount, PrefetchCache:whetherHaveBoxActive(), GlobalGame.g_nProfessionTaskCount)
    if GlobalGame.g_nMainTaskCount > 0 or GlobalGame.g_nBranchTaskCount > 0 or GlobalGame.g_nDailyTaskCount > 0 or GlobalGame.g_nAthleticsTaskCount > 0 or PrefetchCache:whetherHaveBoxActive() or GlobalGame.g_nProfessionTaskCount > 0 then 
        CacheCenter:setRedState("btnTask",true)
    else 
        CacheCenter:setRedState("btnTask",false)
    end
    CacheCenter:updateRedPoint("right", SceneCity.m_tWndBottomBar, nil)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------























