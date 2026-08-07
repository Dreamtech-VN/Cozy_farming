--ProtocolProcessorTeach.lua
--@brief	教学相关协议
--@date  	2014/2/19
--@author 	liangguang_long
--@note 	教学相关协议


ProtocolProcessorTeach = ProtocolProcessorBase:new()

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorTeach:regAll()
	
	--@brief	完成新手指引（TASK_TiroTaskOk = 10）
	self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_TiroTaskOk, "ProtocolProcessorTeach:parse_TASK_TiroTaskOk", "vivi")

    --错误处理(S->C)
	--@brief	保存新手指引进行到的步骤（TASK_TiroStep = 26）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_TiroStep, "ProtocolProcessorTeach:send_TASK_TiroStep_ErrorProcess", "is" )

end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorTeach:unregAll()
	self:clearReg()
end
  
-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief	保存新手指引进行到的步骤（TASK_TiroStep = 11）
function ProtocolProcessorTeach:send_TASK_TiroStep(id, step )
	WZLog("send_TASK_TiroStep", tostring(id), tostring(step))
	local sender = Protocol:getSender( Protocol.MAIN_TASK, Protocol.TASK_TiroStep )
	if sender==nil then WZLog("sender == nil") return end
	sender:writeInt( id )	-- 玩家教程ID
	sender:writeInt( step )	-- 教程步骤
	SendProtocol(sender,false) --true:showLoading
end
-------------------------------------服务器到客户端协议回调方法模块--------------------------------------

--@brief	完成新手指引（TASK_TiroTaskOk = 10）
function ProtocolProcessorTeach:parse_TASK_TiroTaskOk(ids, step)
	-- ids : 教程ID
	-- level : 教程等级
	-- interfaceId : 教程界面ID
	-- step : 教程步骤
	WZLog("ProtocolProcessorTeach:parse_TASK_TiroTaskOk")

    TeachGroup1:getAllData( ids, step )
end

-------------------------------------协议错误处理方法模块--------------------------------------

--完成新手指引（TASK_TiroTask = 9）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorTeach:send_TASK_TiroTask_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorTeach:send_TASK_TiroTask_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TASK, Protocol.TASK_TiroTask, nFlag, sMessage)
end

-------------------------------------公有方法模块End----------------------------------------


