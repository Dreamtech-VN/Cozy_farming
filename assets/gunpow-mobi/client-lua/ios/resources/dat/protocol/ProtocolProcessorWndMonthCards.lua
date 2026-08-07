--ProtocolProcessorWndMonthCards.lua
--@brief	月卡模块协议
--@date  	2014/09/17
--@author 	Lijie


ProtocolProcessorWndMonthCards = ProtocolProcessorBase:new()

-------------------------------------公有方法模块--------------------------------------

--@brief	注册协议组所有协议
function ProtocolProcessorWndMonthCards:regAll()
--@brief	获取公会在线成员（MONTHCARD_GetOnlineMember = 1）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_MONTHCARD, Protocol.MONTHCARD_GetOnlineMember, "ProtocolProcessorWndMonthCards:send_MONTHCARD_GetOnlineMember_ErrorProcess", "is" )
--@brief	赠送月卡（MONTHCARD_GiveMonthCard  = 3）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_MONTHCARD, Protocol.MONTHCARD_GiveMonthCard, "ProtocolProcessorWndMonthCards:send_MONTHCARD_GiveMonthCard_ErrorProcess", "is" )	

--@brief	获取公会在线成员（MONTHCARD_GetOnlineMemberOK = 2）
self:regProtocolCallbackFunction( Protocol.MAIN_MONTHCARD, Protocol.MONTHCARD_GetOnlineMemberOK, "ProtocolProcessorWndMonthCards:parse_MONTHCARD_GetOnlineMemberOK", "vivsvn")
--@brief	赠送月卡成功（MONTHCARD_GiveMonthCardOK = 4）
self:regProtocolCallbackFunction( Protocol.MAIN_MONTHCARD, Protocol.MONTHCARD_GiveMonthCardOK, "ProtocolProcessorWndMonthCards:parse_MONTHCARD_GiveMonthCardOK", "")
end 
--@brief	反注册协议组所有协议
function ProtocolProcessorWndMonthCards:unregAll()
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief	获取公会在线成员（MONTHCARD_GetOnlineMember = 1）
function ProtocolProcessorWndMonthCards:send_MONTHCARD_GetOnlineMember( )
	WZLog("send_MONTHCARD_GetOnlineMember")
	local sender = Protocol:getSender( Protocol.MAIN_MONTHCARD, Protocol.MONTHCARD_GetOnlineMember )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	赠送月卡（MONTHCARD_GiveMonthCard  = 3）
function ProtocolProcessorWndMonthCards:send_MONTHCARD_GiveMonthCard(playerId )
	WZLog("send_MONTHCARD_GiveMonthCard")
	local sender = Protocol:getSender( Protocol.MAIN_MONTHCARD, Protocol.MONTHCARD_GiveMonthCard )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInts( playerId )	-- 玩家id
	SendProtocol(sender,false) --true:showLoading
end

-------------------------------------服务器到客户端协议回调方法模块--------------------------------------
--@brief	获取公会在线成员（MONTHCARD_GetOnlineMemberOK = 2）
function ProtocolProcessorWndMonthCards:parse_MONTHCARD_GetOnlineMemberOK(playerId, playerName, playerLevel)
	-- playerId : 玩家id
	-- playerName : 玩家名称
	-- playerLevel : 玩家等级
	WZLog("ProtocolProcessorWndMonthCards:parse_MONTHCARD_GetOnlineMemberOK")
	WndCommunityMonthCard:setData(VectorToTable(playerId),VectorToTable(playerName),VectorToTable(playerLevel))
end

--@brief	赠送月卡成功（MONTHCARD_GiveMonthCardOK = 4）
function ProtocolProcessorWndMonthCards:parse_MONTHCARD_GiveMonthCardOK()
	WZLog("ProtocolProcessorWndMonthCards:parse_MONTHCARD_GiveMonthCardOK")
	MsgBoxManager:showTipBox(LocalStrings.DIITSUCCESS)
end

-------------------------------------协议错误处理方法模块--------------------------------------
--@brief	获取公会在线成员（MONTHCARD_GetOnlineMember = 1）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMonthCards:send_MONTHCARD_GetOnlineMember_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMonthCards:send_MONTHCARD_GetOnlineMember_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MONTHCARD, Protocol.MONTHCARD_GetOnlineMember, nflag, sMessage)
end

--@brief	赠送月卡（MONTHCARD_GiveMonthCard  = 3）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMonthCards:send_MONTHCARD_GiveMonthCard_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMonthCards:send_MONTHCARD_GiveMonthCard_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MONTHCARD, Protocol.MONTHCARD_GiveMonthCard, nflag, sMessage)
end
