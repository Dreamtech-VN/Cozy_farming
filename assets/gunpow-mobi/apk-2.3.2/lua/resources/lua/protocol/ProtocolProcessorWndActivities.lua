--ProtocolProcessorWndActivities.lua
--@brief	活动广场相关协议
--@date  	2013/12/25
--@author 	liangguang_long
--@note 	活动广场相关协议


ProtocolProcessorWndActivities = ProtocolProcessorBase:new()

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorWndActivities:regAll()

	--@brief	发送广场信息（SQUARE_SendInfo = 2）
	self:regProtocolCallbackFunction( Protocol.MAIN_SQUARE, Protocol.SQUARE_SendInfo, "ProtocolProcessorWndActivities:parse_SQUARE_SendInfo", "s")
	--@brief	获取慕和tickets url成功（SQUARE_GetMhUrlOk = 4）
	self:regProtocolCallbackFunction( Protocol.MAIN_SQUARE, Protocol.SQUARE_GetMhUrlOk, "ProtocolProcessorWndActivities:parse_SQUARE_GetMhUrlOk", "ss")

	
	--协议错误注册
	--获取广场信息（SQUARE_GetInfo = 1）失败
--	self:regProtocolCallbackFunction( Protocol.MAIN_SQUARE, Protocol.SQUARE_GetInfo , "ProtocolProcessorWndMessage:parse_SQUARE_GetInfoErrorMessage", "is" )
	--获取慕和tickets url（SQUARE_GetMhUrl = 3）失败
--	self:regProtocolCallbackFunction( Protocol.MAIN_SQUARE, Protocol.SQUARE_GetMhUrl , "ProtocolProcessorWndMessage:parse_SQUARE_GetMhUrlErrorMessage", "is" )
	
end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorWndActivities:unregAll()
	self:clearReg()
end
  
-------------------------------------客户端到服务器协议发送方法模块--------------------------------------

--@brief	获取广场信息（SQUARE_GetInfo = 1）
function ProtocolProcessorWndActivities:send_SQUARE_GetInfo( )
	WZLog("send_SQUARE_GetInfo77777")
	local sender = Protocol:getSender( Protocol.MAIN_SQUARE, Protocol.SQUARE_GetInfo )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取慕和tickets url（SQUARE_GetMhUrl = 3）
function ProtocolProcessorWndActivities:send_SQUARE_GetMhUrl( )
	WZLog("send_SQUARE_GetMhUrl")
	local sender = Protocol:getSender( Protocol.MAIN_SQUARE, Protocol.SQUARE_GetMhUrl )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

-------------------------------------服务器到客户端协议回调方法模块--------------------------------------

--@brief	发送广场信息（SQUARE_SendInfo = 2）
function ProtocolProcessorWndActivities:parse_SQUARE_SendInfo(squreUrl)
	-- squreUrl : 网址
	WZLog("ProtocolProcessorWndActivities:parse_SQUARE_SendInfo")
	WndActivities:setActivitiesList( squreUrl )
end


--@brief	获取慕和tickets url成功（SQUARE_GetMhUrlOk = 4）
function ProtocolProcessorWndActivities:parse_SQUARE_GetMhUrlOk(submitMh, listMh)
	-- submitMh : tickets提交网址
	-- listMh : tickets
	WZLog("ProtocolProcessorWndActivities:parse_SQUARE_GetMhUrlOk")
end

-------------------------------------协议错误处理方法模块--------------------------------------

-- --@brief	获取广场信息（SQUARE_GetInfo = 1）失败
-- function ProtocolProcessorWndMessage:parse_SQUARE_GetInfoErrorMessage(isexit , message)
-- 	WZLog( "RebirthErrorMessage::2 ",KLuaSocket:utfToGBK(message) )
-- 	--MsgBoxManager:showTipBox( LocalStrings.VIP_INFOFAIL )
-- end

-- --@brief	获取慕和tickets url（SQUARE_GetMhUrl = 3）失败
-- function ProtocolProcessorWndMessage:parse_SQUARE_GetMhUrlErrorMessage(isexit , message)
-- 	WZLog( "RebirthErrorMessage::2 ",KLuaSocket:utfToGBK(message) )
-- 	--MsgBoxManager:showTipBox( LocalStrings.VIP_INFOFAIL )
-- end

-------------------------------------公有方法模块End----------------------------------------








