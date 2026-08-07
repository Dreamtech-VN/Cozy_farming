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


--@brief	领取任务奖励成功
function ProtocolProcessorWndTask:parse_TASK_GetTaskRewardOk(id, reward)
	-- id : 任务ID
	-- reward : 奖励内容
	WZLog("ProtocolProcessorWndTask:parse_TASK_GetTaskRewardOk",id,reward, type(reward))
	if PassportDefaultCallback.hasShare then
        PassportDefaultCallback.hasShare = false
    end
	local m_tTaskData = GDatatab_task["id_"..id]
	PrefetchCache:afterReceiveOK(id, m_tTaskData.type, TASKSTATUS_COMPLETED)
	if WndTask.m_root then
		WndTask:updateTaskStatus(id, m_tTaskData.type, TASKSTATUS_COMPLETED, reward)
	end
    if SceneCity.m_tWndBottomBarObj then SceneCity.m_tWndBottomBarObj:updateTask() end
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

--@brief	领取任务奖励错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndTask:send_TASK_GetTaskReward_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndTask:send_TASK_GetTaskReward_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TASK, Protocol.TASK_GetTaskReward, nflag, sMessage)
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
-------------------------------------公有方法模块End----------------------------------------



