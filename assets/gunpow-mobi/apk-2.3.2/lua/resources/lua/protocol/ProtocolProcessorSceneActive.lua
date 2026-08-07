--ProtocolProcessorSceneActive.lua
--@brief	活跃度相关协议->
--@date  	2014/02/18
--@author 	sunshashan
--@note 	活跃度相关协议


ProtocolProcessorSceneActive = ProtocolProcessorBase:new()

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	注册协议组所有协议
function ProtocolProcessorSceneActive:regAll()
	--@brief	获取收益找回列表（TASK_GetRetrieveList = 30）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_GetRetrieveList, "ProtocolProcessorSceneActive:send_TASK_GetRetrieveList_ErrorProcess", "is" )
	--@brief	成功获取收益找回列表（TASK_GetRetrieveListOk = 31）
	self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_GetRetrieveListOk, "ProtocolProcessorSceneActive:parse_TASK_GetRetrieveListOk", "vivsvivivi")
	--@brief	收益找回（TASK_Retrieve = 32）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_Retrieve, "ProtocolProcessorSceneActive:send_TASK_Retrieve_ErrorProcess", "is" )
	--@brief	成功找回收益（TASK_RetrieveOk = 33）
	self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_RetrieveOk, "ProtocolProcessorSceneActive:parse_TASK_RetrieveOk", "iivivi")

	-------------------------错误协议注册--------------------------------
end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorSceneActive:unregAll()
	self:clearReg()
end
  
-------------------------------------客户端到服务器协议发送方法模块------------------------------
--@brief	获取收益找回列表（TASK_GetRetrieveList = 30）
function ProtocolProcessorSceneActive:send_TASK_GetRetrieveList( )
	WZLog("send_TASK_GetRetrieveList")
	local sender = Protocol:getSender( Protocol.MAIN_TASK, Protocol.TASK_GetRetrieveList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end
--@brief	收益找回（TASK_Retrieve = 32）
function ProtocolProcessorSceneActive:send_TASK_Retrieve(taskId, rType )
	WZLog("send_TASK_Retrieve")
	local sender = Protocol:getSender( Protocol.MAIN_TASK, Protocol.TASK_Retrieve )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( taskId )	-- 任务ID
	sender:writeInt( rType )	-- 找回类型0钻石找回 1金币找回
	SendProtocol(sender,false) --true:showLoading
end
-------------------------------------服务器到客户端协议回调方法模块------------------------------
--@brief	成功获取收益找回列表（TASK_GetRetrieveListOk = 31）
function ProtocolProcessorSceneActive:parse_TASK_GetRetrieveListOk(taskId, title, itemId, num, itemSise)
	-- taskId : 任务ID
	-- title : 标题
	-- itemId : 物品id
	-- num : 数量 
	-- itemSise : 物品数量
	GlobalGame:getGameEventDispathcer():Dispatch(bottomMeneEvent.WndBottomMeneEvent_TaskOffLine, VectorToTable(taskId), VectorToTable(title), 
		VectorToTable(itemId), VectorToTable(num), VectorToTable(itemSise))
end
--@brief	成功找回收益（TASK_RetrieveOk = 33）
function ProtocolProcessorSceneActive:parse_TASK_RetrieveOk(taskId, rType, itemId, num)
	-- taskId : 任务ID
	-- rType : 找回类型0钻石找回 1金币找回
	-- itemId : 物品id
	-- num : 物品数量
	GlobalGame:getGameEventDispathcer():Dispatch(bottomMeneEvent.WndBottomMeneEvent_GetTaskOffLineResult, taskId, rType, VectorToTable(itemId), VectorToTable(num))
end

-------------------------------------协议错误处理方法模块--------------------------------------

--@brief	获取收益找回列表（TASK_GetRetrieveList = 30）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneActive:send_TASK_GetRetrieveList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneActive:send_TASK_GetRetrieveList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TASK, Protocol.TASK_GetRetrieveList, nflag, sMessage)
end
--@brief	收益找回（TASK_Retrieve = 32）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneActive:send_TASK_Retrieve_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneActive:send_TASK_Retrieve_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TASK, Protocol.TASK_Retrieve, nflag, sMessage)
end

-------------------------------------公有方法模块End----------------------------------------








