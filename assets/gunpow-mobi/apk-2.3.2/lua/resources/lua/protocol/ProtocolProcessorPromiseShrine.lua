--
-- @brief:许愿树相关协议
-- @date: 2017-03-14 18:40:48
-- @author: zhenwei_jian
-- @note:许愿树相关协议
ProtocolProcessorPromiseShrine = ProtocolProcessorBase:new()


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorPromiseShrine:regAll()

	
	--@brief	获取许愿池信息（ACTIVITY_GetWishingWell = 22）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetWishingWell, "ProtocolProcessorPromiseShrine:send_ACTIVITY_GetWishingWell_ErrorProcess", "is" )


	--@brief	许愿池许愿（ACTIVITY_MakeWish = 24）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_MakeWish, "ProtocolProcessorPromiseShrine:send_ACTIVITY_MakeWish_ErrorProcess", "is" )


	--@brief	获取许愿池信息（ACTIVITY_GetWishingWellOk = 23）
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetWishingWellOk, "ProtocolProcessorPromiseShrine:parse_ACTIVITY_GetWishingWellOk", "tiiiiii")

	--@brief	许愿池许愿（ACTIVITY_MakeWishOk = 25）
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_MakeWishOk, "ProtocolProcessorPromiseShrine:parse_ACTIVITY_MakeWishOk", "")

end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorPromiseShrine:unregAll()
	self:clearReg()
end
  


-------------------------------------客户端到服务器协议发送方法模块--------------------------------------

--@brief	获取许愿池信息（ACTIVITY_GetWishingWell = 22）
function ProtocolProcessorPromiseShrine:send_ACTIVITY_GetWishingWell( )
	WZLog("send_ACTIVITY_GetWishingWell")
	local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetWishingWell )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end


--@brief	许愿池许愿（ACTIVITY_MakeWish = 24）
function ProtocolProcessorPromiseShrine:send_ACTIVITY_MakeWish( )
	WZLog("send_ACTIVITY_MakeWish")
	local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_MakeWish )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

-------------------------------------服务器到客户端协议回调方法模块--------------------------------------


--@brief	获取许愿池信息（ACTIVITY_GetWishingWellOk = 23）
function ProtocolProcessorPromiseShrine:parse_ACTIVITY_GetWishingWellOk(status, startTimestamp, endTimestamp, leftWishTimes, rechargeId, leftPurchaseTimes, countDown)
	-- status : 状态 2结束  1 进行
	-- startTimestamp : 开始时间戳
	-- endTimestamp : 结束时间戳
	-- leftWishTimes : 剩余许愿次数
	-- rechargeId : 充值id,0为无可充值项目,-1为任意充值
	-- leftPurchaseTimes : 剩余的购买次数
	-- countDown : 倒计时
	WZLog("ProtocolProcessorPromiseShrine:parse_ACTIVITY_GetWishingWellOk")

	
	CacheCenter:setPromiseData(status, startTimestamp, endTimestamp, leftWishTimes, rechargeId, leftPurchaseTimes, countDown)
	WndPromiseShrine:flushData()
end


--@brief	许愿池许愿（ACTIVITY_MakeWishOk = 25）
function ProtocolProcessorPromiseShrine:parse_ACTIVITY_MakeWishOk()
	WZLog("ProtocolProcessorPromiseShrine:parse_ACTIVITY_MakeWishOk")

	if nil ~= WndPromiseShrine.m_root then
		WndPromiseShrine:closeLoadingUI()
		WndPromiseShrine:onRecvWishOk()
	end
end



-------------------------------------协议错误处理方法模块--------------------------------------

--@brief	获取许愿池信息（ACTIVITY_GetWishingWell = 22）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorPromiseShrine:send_ACTIVITY_GetWishingWell_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorPromiseShrine:send_ACTIVITY_GetWishingWell_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetWishingWell, nflag, sMessage)
end


--@brief	许愿池许愿（ACTIVITY_MakeWish = 24）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorPromiseShrine:send_ACTIVITY_MakeWish_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorPromiseShrine:send_ACTIVITY_MakeWish_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_MakeWish, nflag, sMessage)
end

-------------------------------------公有方法模块End----------------------------------------


