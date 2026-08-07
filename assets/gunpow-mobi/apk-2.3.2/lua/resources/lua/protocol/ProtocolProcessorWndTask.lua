--ProtocolProcessorWndTask.lua
--@brief	任务相关协议
--@date  	2014/09/09
--@author 	SuYuan
--@note 	任务相关协议


ProtocolProcessorWndTask = ProtocolProcessorBase:new()

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorWndTask:regAll() 
	--获取任务列表成功	
	--@brief	领取任务奖励成功
	self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_GetTaskRewardOk, "ProtocolProcessorWndTask:parse_TASK_GetTaskRewardOk", "is")
	--@brief	领取广告任务奖励（TASK_GetADReward = 13）
	self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_GetADReward, "ProtocolProcessorWndTask:send_TASK_GetADReward_ErrorProcess", "is")
	--@brief	领取广告任务奖励（TASK_GetADRewardOk = 14）
	self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_GetADRewardOk, "ProtocolProcessorWndTask:parse_TASK_GetADRewardOk", "ivivi")

	--@brief	领取每日任务活跃度奖励（TASK_ReceiveDailyReward = 26）
	self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_ReceiveDailyReward, "ProtocolProcessorWndTask:send_TASK_ReceiveDailyReward_ErrorProcess", "is")
	--@brief	领取每日任务活跃度奖励返回（TASK_ReceiveDailyRewardOk = 27）
	self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_ReceiveDailyRewardOk, "ProtocolProcessorWndTask:parse_TASK_ReceiveDailyRewardOk", "ii")

	--@brief	获取荣誉值相关信息（PLAYER_GetHonourInfo = 123）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetHonourInfo, "ProtocolProcessorWndTask:send_PLAYER_GetHonourInfo_ErrorProcess", "is" )
	--@brief	获取荣誉值相关信息（PLAYER_GetHonourInfoOk = 124）
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetHonourInfoOk, "ProtocolProcessorWndTask:parse_PLAYER_GetHonourInfoOk", "iii")
	--GM返回
	self:regProtocolCallbackFunction( Protocol.MAIN_ZONE, Protocol.ZONE_TrainerListOk, "ProtocolProcessorWndTask:parse_PLAYER_TrainerListOk", "s")
end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorWndTask:unregAll()
	self:clearReg()
end
  
-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief	领取任务奖励
function ProtocolProcessorWndTask:send_TASK_GetTaskReward(id )
	WZLog("send_TASK_GetTaskReward")
	local sender = Protocol:getSender( Protocol.MAIN_TASK, Protocol.TASK_GetTaskReward )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( id )	-- 任务ID
	SendProtocol(sender,false) --true:showLoading
end

--@brief	领取广告任务奖励
function ProtocolProcessorWndTask:send_TASK_GetADReward(id )
	WZLog("send_TASK_GetADReward")
	local sender = Protocol:getSender( Protocol.MAIN_TASK, Protocol.TASK_GetADReward )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( id )	-- 任务ID
	SendProtocol(sender,false) --true:showLoading
end

--@brief	领取每日任务活跃度奖励（TASK_ReceiveDailyReward = 26）
function ProtocolProcessorWndTask:send_TASK_ReceiveDailyReward(index)
	WZLog("send_TASK_ReceiveDailyReward")
	local sender = Protocol:getSender( Protocol.MAIN_TASK, Protocol.TASK_ReceiveDailyReward )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( index )	-- 对应的宝箱位置，从0开始计数
	SendProtocol(sender,false) --true:showLoading
end
--@brief	获取荣誉值相关信息（PLAYER_GetHonourInfo = 123）
function ProtocolProcessorWndTask:send_PLAYER_GetHonourInfo( )
	WZLog("send_PLAYER_GetHonourInfo")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetHonourInfo )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end
--@brief	作弊指令
function ProtocolProcessorWndTask:send_PLAYER_Trainer(cmd )
	local sender = Protocol:getSender( Protocol.MAIN_ZONE, Protocol.ZONE_Trainer )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeString( cmd )	-- 指令 如修改等级:level=10 获得物品item=70*10
	SendProtocol(sender,false) --true:showLoading
end
function ProtocolProcessorWndTask:send_PLAYER_TrainerList()
	local sender = Protocol:getSender( Protocol.MAIN_ZONE, Protocol.ZONE_TrainerList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end
function ProtocolProcessorWndTask:parse_PLAYER_TrainerListOk(data)
	data = json.decode(data)
	if WndGm.m_root then
		WndGm:setGmData(data)
	end
end
--------------------------------------------------------------------------------

--@brief	领取任务奖励成功
function ProtocolProcessorWndTask:parse_TASK_GetTaskRewardOk(id, reward)
	-- id : 任务ID
	-- reward : 奖励内容
	if PassportDefaultCallback.hasShare then
        PassportDefaultCallback.hasShare = false
    end
	local m_tTaskData = GDatatab_task["id_"..id]
	PrefetchCache:afterReceiveOK(id, m_tTaskData.type, TASKSTATUS_COMPLETED)
	if WndTask.m_root then
		WndTask:updateTaskStatus(id, m_tTaskData.type, TASKSTATUS_COMPLETED, reward)
	end

	ScenePvpStrategic:updateTaskStatus(id, m_tTaskData.type, TASKSTATUS_COMPLETED, reward)

    if SceneCity.m_tWndBottomBarObj then SceneCity.m_tWndBottomBarObj:updateTask() end
    if WndSingleCopy.m_root then WndSingleCopy:updateTask() end

    for i=#g_tCellTopHandleObj,1,-1 do
    	if g_tCellTopHandleObj[i].m_root then
    		g_tCellTopHandleObj[i]:updateTask()
	    end
    end

    if CellTopHandle.m_current and CellTopHandle.m_current.m_root and not WndTask.m_root then 
		CellTopHandle.m_current:updateTaskAfterReward(id, m_tTaskData.type, TASKSTATUS_COMPLETED, reward)
    elseif WndSingleCopy.m_root and not WndTask.m_root then 
		WndSingleCopy:updateTaskAfterReward(id, m_tTaskData.type, TASKSTATUS_COMPLETED, reward)
	elseif SceneCity.m_root and not WndTask.m_root then 
		SceneCity:updateTaskAfterReward(id, m_tTaskData.type, TASKSTATUS_COMPLETED, reward)
    end
end

--@brief	领取任务奖励成功
function ProtocolProcessorWndTask:parse_TASK_GetADRewardOk(id, rewardId, rewardNum)
	-- id : 任务ID
	-- reward : 奖励内容
	WZLog("ProtocolProcessorWndTask:parse_TASK_GetADRewardOk",id,reward)
	local id,num = VectorToTable(rewardId),VectorToTable(rewardNum)
	WndRewardShow:showById(id,num)
	WindowManager:removeWindow(WndFyber.m_root, WndFyber, true)
end

--@brief	领取每日任务活跃度奖励返回（TASK_ReceiveDailyRewardOk = 27）
function ProtocolProcessorWndTask:parse_TASK_ReceiveDailyRewardOk(status, index)
	-- status : 0 成功 1 不可领取 2 已领取
	-- index : 对应的宝箱位置，从0开始计数
	WZLog("ProtocolProcessorWndTask:parse_TASK_ReceiveDailyRewardOk", status, index)
	WndTask:getActivityBoxRewardOK(status, index)
end
--@brief	获取荣誉值相关信息（PLAYER_GetHonourInfoOk = 124）
function ProtocolProcessorWndTask:parse_PLAYER_GetHonourInfoOk(honourPoint, restoreTime, serverTime)
	WZLog("ProtocolProcessorWndTask:parse_PLAYER_GetHonourInfoOk", honourPoint, restoreTime, serverTime)
	-- honourPoint : 当前荣誉值
	-- restoreTime : 上次恢复时间 等于0时已经不需要恢复了
	-- serverTime : 方便计算确实剩余时间
	GlobalGame:getGameEventDispathcer():Dispatch(bottomMeneEvent.WndBottomMeneEvent_HonorPointCountDown, honourPoint, restoreTime, serverTime)
end

--------------------------------------------------------------------------------
--@brief	领取任务奖励错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndTask:send_TASK_GetTaskReward_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndTask:send_TASK_GetTaskReward_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TASK, Protocol.TASK_GetTaskReward, nflag, sMessage)
	SceneCity:setGetRewardLimit(false)
	WndSingleCopy:setGetRewardLimit(false)
	WndTask:setGetRewardLimit(false)
	if CellTopHandle.m_current and CellTopHandle.m_current.m_root then
		CellTopHandle.m_current:setGetRewardLimit(false)
	end
end

--@brief	领取任务奖励错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndTask:send_TASK_GetADReward_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndTask:send_TASK_GetADReward_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TASK, Protocol.TASK_GetADReward, nflag, sMessage)
end

--@brief	领取每日任务活跃度奖励错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndTask:send_TASK_ReceiveDailyReward_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndTask:send_TASK_ReceiveDailyReward_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TASK, Protocol.TASK_ReceiveDailyReward, nflag, sMessage)
end
--@brief	获取荣誉值相关信息（PLAYER_GetHonourInfo = 123）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndTask:send_PLAYER_GetHonourInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndTask:send_PLAYER_GetHonourInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_GetHonourInfo, nflag, sMessage)
end
-------------------------------------公有方法模块End----------------------------------------



