--ProtocolProcessorWndChat.lua
--@brief	聊天模块协议
--@date  	2013/12/10
--@author 	SunShanshan


ProtocolProcessorWndChat = ProtocolProcessorBase:new()

-------------------------------------公有方法模块--------------------------------------

--@brief	注册协议组所有协议
function ProtocolProcessorWndChat:regAll()
	--协议错误注册
	--接收信息协议错误(S->C)
	--self:regProtocolCallbackFunction( Protocol.MAIN_CHAT, Protocol.CHAT_SendMessage, "ProtocolProcessorWndChat:SendMessage_ErrorProcess", "is" )
	--获取喇叭数量协议错误(S->C)
	--self:regProtocolCallbackFunction( Protocol.MAIN_CHAT, Protocol.CHAT_GetSpeakerNum, "ProtocolProcessorWndChat:GetSpeakerNum_ErrorProcess", "is" )
	--更换聊天频道协议错误(S->C)
	--self:regProtocolCallbackFunction( Protocol.MAIN_CHAT, Protocol.CHAT_ChangeChannel, "ProtocolProcessorWndChat:ChangeChannel_ErrorProcess", "is" )
end

--@brief	反注册协议组所有协议
function ProtocolProcessorWndChat:unregAll()
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief	发送聊天信息（C->S）
function ProtocolProcessorWndChat:send_CHAT_SendMessage(channel, message, playerId )
	WZLog("ProtocolProcessorWndChat:send_CHAT_SendMessage ",playerId,channel,message)
	local sender = Protocol:getSender( Protocol.MAIN_CHAT, Protocol.CHAT_SendMessage )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( channel )	-- 频道（0世界，1当前，2公会，3队伍，4私聊，5系统，6彩聊）
	sender:writeString( message )	-- 聊天内容
	sender:writeInt( playerId )	-- 信息接收人ID（私聊时用,用名称时该字段为-1）
	SendProtocol(sender,false) --true:showLoading
	 
end


--@brief	更换聊天频道（C->S）
function ProtocolProcessorWndChat:send_CHAT_ChangeChannel(channelId )
	WZLog("send_CHAT_ChangeChannel")
	local sender = Protocol:getSender( Protocol.MAIN_CHAT, Protocol.CHAT_ChangeChannel )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( channelId )	-- 当前频道id（界面id）
	SendProtocol(sender,false) --true:showLoading
end


-------------------------------------服务器到客户端协议回调方法模块--------------------------------------

----------------------------------------错误协议回调------------------------------------------

--@brief	接收信息协议错误处理(S->C)
function ProtocolProcessorWndChat:SendMessage_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndChat:SendMessage_ErrorProcess")
	
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_CHAT, Protocol.CHAT_SendMessage, nflag, sMessage)
end

--@brief	获取喇叭数量协议错误处理(S->C)
function ProtocolProcessorWndChat:GetSpeakerNum_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndChat:GetSpeakerNum_ErrorProcess")
	
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_CHAT, Protocol.CHAT_GetSpeakerNum, nflag, sMessage)
end

--@brief	更换聊天频道协议错误处理(S->C)
function ProtocolProcessorWndChat:ChangeChannel_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndChat:ChangeChannel_ErrorProcess")
	
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_CHAT, Protocol.CHAT_ChangeChannel, nflag, sMessage)
end