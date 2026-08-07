--ProtocolProcessorSceneActive.lua
--@brief	活跃度相关协议
--@date  	2014/02/18
--@author 	sunshashan
--@note 	活跃度相关协议


ProtocolProcessorSceneActive = ProtocolProcessorBase:new()

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	注册协议组所有协议
function ProtocolProcessorSceneActive:regAll()

	--@brief	发送客户需要显示的活跃度任务列表
	self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_SendActiveTaskList, "ProtocolProcessorSceneActive:parse_TASK_SendActiveTaskList", "vivivsvsvivivsvsvsvsittvivivtvsvsvs")
	--@brief	领取活跃度奖励成功
	self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_GetActiveRewardOk, "ProtocolProcessorSceneActive:parse_TASK_GetActiveRewardOk", "")
	-------------------------错误协议注册--------------------------------
	--@brief	获取活跃度任务列表错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_GetActiveTaskList, "ProtocolProcessorSceneActive:send_TASK_GetActiveTaskList_ErrorProcess", "is" )
	--@brief	领取活跃度奖励错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_GetActiveReward, "ProtocolProcessorSceneActive:send_TASK_GetActiveReward_ErrorProcess", "is" )
end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorSceneActive:unregAll()
	self:clearReg()
end
  
-------------------------------------客户端到服务器协议发送方法模块------------------------------
--@brief	获取活跃度任务列表
function ProtocolProcessorSceneActive:send_TASK_GetActiveTaskList( )
	WZLog("send_TASK_GetActiveTaskList")
	local sender = Protocol:getSender( Protocol.MAIN_TASK, Protocol.TASK_GetActiveTaskList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
	WZLog("send_TASK_GetActiveTaskList1")
end

--@brief	领取活跃度奖励
function ProtocolProcessorSceneActive:send_TASK_GetActiveReward( )
	WZLog("send_TASK_GetActiveReward")
	local sender = Protocol:getSender( Protocol.MAIN_TASK, Protocol.TASK_GetActiveReward )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

-------------------------------------服务器到客户端协议回调方法模块------------------------------
--@brief	发送客户需要显示的活跃度任务列表
function ProtocolProcessorSceneActive:parse_TASK_SendActiveTaskList(taskId, taskType, taskName, taskDesc, hyz, taskStatus, targetText, targetValue, taskScript,taskTime, activity, rewardProgress, playerVipLevel, activityDemand, propId, vipLevel,propName, propDesc,propDetail)
	-- taskId : 任务id
	-- taskType : 任务类型
	-- taskName : 任务名称
	-- taskDesc : 任务描述
	-- hyz : 任务奖励活跃值
	-- taskStatus : 任务状态
	-- targetText : 任务完成条件描述
	-- targetValue : 任务完成条件状态
	-- taskScript : 客户端动作脚本
	-- activity : 玩家当前活跃度
	-- rewardProgress : 玩家活跃度奖励领取进度
	-- playerVipLevel : 玩家当前vip等级
	-- activityDemand : 领取奖励活跃度要求值
	-- propId : 奖励的礼包
	-- vipLevel : 领取该礼包所需的vip等级
	--propName : 礼包名称
	--propDesc : 礼包说明
	--propDetail : 礼包内容
	WZLog("ProtocolProcessorSceneActive:parse_TASK_SendActiveTaskList",taskStatus:size())
	SceneActive:parse_TASK_SendActiveTaskList(VectorToTable(taskId), VectorToTable(taskType), VectorToTable(taskName), VectorToTable(taskDesc), VectorToTable(hyz), VectorToTable(taskStatus), VectorToTable(targetText), VectorToTable(targetValue), VectorToTable(taskScript), VectorToTable(taskTime),activity, rewardProgress, playerVipLevel, VectorToTable(activityDemand), VectorToTable(propId), VectorToTable(vipLevel),VectorToTable(propName), VectorToTable(propDesc), VectorToTable(propDetail))
end

--@brief	领取活跃度奖励成功
function ProtocolProcessorSceneActive:parse_TASK_GetActiveRewardOk()
	WZLog("ProtocolProcessorSceneActive:parse_TASK_GetActiveRewardOk")
	SceneActive:getActiveRewardOk()
	MsgBoxManager:showTipBox( LocalStrings.VIP_RECVSUCCESS )
end
-------------------------------------协议错误处理方法模块--------------------------------------
--@brief	获取活跃度任务列表错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneActive:send_TASK_GetActiveTaskList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneActive:send_TASK_GetActiveTaskList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TASK, Protocol.TASK_GetActiveTaskList, nflag, sMessage)
	SceneActive:getActiveTaskListErrorProcess(sMessage)
end


--@brief	领取活跃度奖励错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneActive:send_TASK_GetActiveReward_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneActive:send_TASK_GetActiveReward_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TASK, Protocol.TASK_GetActiveReward, nflag, sMessage)
end

-------------------------------------公有方法模块End----------------------------------------








