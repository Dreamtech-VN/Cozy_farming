--ProtocolProcessorWndActive.lua
--@brief	活跃度相关协议
--@date  	2015/7/7
--@author 	谢启祥
--@note 	活跃度相关协议


ProtocolProcessorWndActive = ProtocolProcessorBase:new()

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	注册协议组所有协议
function ProtocolProcessorWndActive:regAll()
	--@brief	获取活跃值信息（ACTIVE_GetActiveInfo = 1）
    self:regProtocolCallbackFunction(Protocol.MAIN_ACTIVE,Protocol.ACTIVE_GetActiveInfo, "ProtocolProcessorWndActive:send_ACTIVE_GetActiveInfo_ErrorProcess", "is" )

    --@brief	领取奖励（ACTIVE_GetActiveAward = 3）错误处理(S->C)
    self:regProtocolCallbackFunction(Protocol.MAIN_ACTIVE,Protocol.ACTIVE_GetActiveAward, "ProtocolProcessorWndActive:send_ACTIVE_GetActiveAward_ErrorProcess", "is" )
    
    --@brief	获取基础信息（GetActiveBaseInfo = 5）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVE, Protocol.GetActiveBaseInfo, "ProtocolProcessorWndActive:send_GetActiveBaseInfo_ErrorProcess", "is" )

    --@brief	获取活跃值信息成功（GetActiveInfoOk = 2）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVE, Protocol.GetActiveInfoOk, "ProtocolProcessorWndActive:parse_GetActiveInfoOk", "vsvsivsvssvsvs")
    
    --@brief	领取奖励（ACTIVE_GetActiveAwardOk = 4）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVE, Protocol.ACTIVE_GetActiveAwardOk, "ProtocolProcessorWndActive:parse_ACTIVE_GetActiveAwardOk", "si")
    
    --@brief	获取基础信息（GetActiveBaseInfoOk = 6）
    self:regProtocolCallbackFunction(Protocol.MAIN_ACTIVE,Protocol.GetActiveBaseInfoOk,"ProtocolProcessorWndActive:parse_GetActiveBaseInfoOk", "ss")

end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorWndActive:unregAll()
	self:clearReg()
end

  
-------------------------------------客户端到服务器协议发送方法模块------------------------------

--@brief	获取活跃值信息（ACTIVE_GetActiveInfo = 1）
function ProtocolProcessorWndActive:send_ACTIVE_GetActiveInfo( )
	WZLog("send_ACTIVE_GetActiveInfo")
	local sender = Protocol:getSender( Protocol.MAIN_ACTIVE, Protocol.ACTIVE_GetActiveInfo )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	领取奖励（ACTIVE_GetActiveAward = 3）
function ProtocolProcessorWndActive:send_ACTIVE_GetActiveAward(awardId )
	WZLog("send_ACTIVE_GetActiveAward")
	local sender = Protocol:getSender( Protocol.MAIN_ACTIVE, Protocol.ACTIVE_GetActiveAward )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeString( awardId )	-- 奖励编号
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取基础信息（GetActiveBaseInfo = 5）
function ProtocolProcessorWndActive:send_GetActiveBaseInfo()
	WZLog("send_GetActiveBaseInfo ")
	local sender = Protocol:getSender( Protocol.MAIN_ACTIVE, Protocol.GetActiveBaseInfo )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end



-------------------------------------服务器到客户端协议回调方法模块--------------------------------------

--@brief	获取活跃值信息成功（GetActiveInfoOk = 2）
function ProtocolProcessorWndActive:parse_GetActiveInfoOk(activityId, complStatus, activeNum, awardId, awardStatus,serverTime,standard,progress)
	-- activityId : 活动编号
	-- complStatus : 完成状态 1：未开启(等级不够) 2：未开启(时间未达到) 3：未完成  4：已完成 
	-- activeNum : 总活跃值
	-- awardId : 奖励编号
	-- awardStatus : 奖励状态 -1：不可领取 0：可以领取  1：已领取
	-- serverTime : 服务端时间
	-- standard : 完成标准
	-- progress : 完成进度
	WZLog("ProtocolProcessorWndActive:parse_GetActiveInfoOk", Serialize(VectorToTable(awardId)), Serialize(VectorToTable((awardStatus))))
	WndActive:getActiveInfo(VectorToTable(activityId),VectorToTable(complStatus),activeNum,VectorToTable(awardId),VectorToTable(awardStatus),VectorToTable(serverTime),VectorToTable(standard),VectorToTable(progress))
end

--@brief	领取奖励（ACTIVE_GetActiveAwardOk = 4）
function ProtocolProcessorWndActive:parse_ACTIVE_GetActiveAwardOk(awardId, status)
	-- awardId : 奖励编号
	-- status : 状态 0:领取失败,1:领取成功
	WZLog("ProtocolProcessorWndActive:parse_ACTIVE_GetActiveAwardOk")
	WndActive:getAward(awardId, status)

    ProtocolProcessorWndActive:send_ACTIVE_GetActiveInfo()
end

--@brief	获取基础信息（GetActiveBaseInfoOk = 6）
function ProtocolProcessorWndActive:parse_GetActiveBaseInfoOk(awardInfo,activityInfo)
	-- awardInfo : 奖励基础信息
	-- activityInfo : 奖励基础信息
	WZLog("ProtocolProcessorWndActive:parse_GetActiveBaseInfoOk")
    
    WndActive:getActiveBaseInfo(awardInfo,activityInfo)
end


-------------------------------------协议错误处理方法模块--------------------------------------
--@brief	活跃系统相关协议(MAIN_ACTIVE = 115)错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndActive:send_ACTIVE_GetActiveInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndActive:send_ACTIVE_GetActiveInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVE, Protocol.ACTIVE_GetActiveInfo, nflag, sMessage)
end

--@brief	获取基础信息（GetActiveBaseInfo = 5）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndActive:send_GetActiveBaseInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndActive:send_GetActiveBaseInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVE, Protocol.GetActiveBaseInfo, nflag, sMessage)
end

--@brief	领取奖励（ACTIVE_GetActiveAward = 3）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndActive:send_ACTIVE_GetActiveAward_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndActive:send_ACTIVE_GetActiveAward _ErrorProcess")
	MsgBoxManager:stopLoadingBoxByMsgId(WndActive.m_nLoadingId)
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVE, Protocol.ACTIVE_GetActiveAward , nflag, sMessage)
end

-------------------------------------公有方法模块End----------------------------------------








