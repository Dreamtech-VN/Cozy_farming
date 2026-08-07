--ProtocolProcessorWndSetting.lua
--@brief	关于相关协议
--@date  	2013/12/25
--@author 	liangguang_long
--@note 	关于相关协议


ProtocolProcessorWndSetting = ProtocolProcessorBase:new()

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorWndSetting:regAll()

	--@brief	获取关于成功（BULLETINT_GetAboutOk = 4）
	self:regProtocolCallbackFunction( Protocol.MAIN_SYSTEM, Protocol.SYSTEM_GetAboutGameOk, "ProtocolProcessorWndSetting:parse_BULLETINT_GetAboutOk", "s")
	--@brief	发送邮件成功
	self:regProtocolCallbackFunction( Protocol.MAIN_MAIL, Protocol.MAIL_SendMailOk, "ProtocolProcessorWndSetting:parse_MAIL_SendMailOk", "")
    
	--协议错误注册
	--@brief	发送邮件失败
	self:regProtocolCallbackFunction( Protocol.MAIN_MAIL, Protocol.MAIL_SendMail , "ProtocolProcessorWndSetting:parse_MAIL_ErrorWriteMessage", "is")
	--@brief	修改玩家聊天快捷方式（PLAYER2_ChangePlayerChatshortcut = 21）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER2, Protocol.PLAYER2_ChangePlayerChatshortcut , "ProtocolProcessorWndSetting:send_PLAYER2_ChangePlayerChatshortcut_ErrorProcess", "is")
	--@brief	成功修改玩家聊天快捷方式（PLAYER2_ChangePlayerChatshortcutOk = 22）
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER2, Protocol.PLAYER2_ChangePlayerChatshortcutOk, "ProtocolProcessorWndSetting:parse_PLAYER2_ChangePlayerChatshortcutOk", "")
end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorWndSetting:unregAll()
	self:clearReg()
end
  
-------------------------------------客户端到服务器协议发送方法模块--------------------------------------

--@brief	公告相关协议(SYSTEM_GetAboutGame = 24)
function ProtocolProcessorWndSetting:send_BULLETINT_GetAbout( )
	WZLog("send_BULLETINT_GetAbout")
	local sender = Protocol:getSender( Protocol.MAIN_SYSTEM, Protocol.SYSTEM_GetAboutGame )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	发送邮件
function ProtocolProcessorWndSetting:send_MAIL_SendMail( theme, senderId, receiverId, receiverName, mailType, content )
	WZLog("send_MAIL_SendMail")
	local sender = Protocol:getSender( Protocol.MAIN_MAIL, Protocol.MAIL_SendMail )
	if sender==nil then WZLog("sender == nil") 
		return 
	end

	sender:writeString( theme )	-- 主题
	sender:writeInt( senderId )	-- 发件人id
	sender:writeInt( receiverId )	-- 收件人id
	sender:writeString( receiverName )	-- 收件人名称
	sender:writeInt( mailType )	-- 类型
	sender:writeString( content )	-- 内容
	SendProtocol(sender,false) --true:showLoading
	
end

--@brief	修改玩家聊天快捷方式（PLAYER2_ChangePlayerChatshortcut = 21）
function ProtocolProcessorWndSetting:send_PLAYER2_ChangePlayerChatshortcut( opType, index, content )
	WZLog("send_PLAYER2_ChangePlayerChatshortcut")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER2, Protocol.PLAYER2_ChangePlayerChatshortcut )
	if sender==nil then WZLog("sender == nil") 
		return 
	end

	sender:writeInt( opType )	-- 1 全部 2队伍
	sender:writeInt( index )	-- 收件人id
	sender:writeString( content )	-- 内容
	SendProtocol(sender,false) --true:showLoading
	
end
-------------------------------------服务器到客户端协议回调方法模块--------------------------------------

--@brief	获取关于成功（BULLETINT_GetAboutOk = 4）
function ProtocolProcessorWndSetting:parse_BULLETINT_GetAboutOk(about)
	-- about : 公告内容
	WZLog("ProtocolProcessorWndSetting:parse_BULLETINT_GetAboutOk:",about)
	local test = string.gsub(about,"#","\n")
	WndGameNotice:setDescText(test)
end

--@brief	发送邮件成功
function ProtocolProcessorWndSetting:parse_MAIL_SendMailOk()
	WZLog("ProtocolProcessorWndMail:parse_MAIL_SendMailOk")
	--发送意见成功回调函数
	WndSuggestion:sendSuggestionSuccess()
end

--@brief	成功修改玩家聊天快捷方式（PLAYER2_ChangePlayerChatshortcutOk = 22）
function ProtocolProcessorWndSetting:parse_PLAYER2_ChangePlayerChatshortcutOk()
	WZLog("ProtocolProcessorWndMail:parse_PLAYER2_ChangePlayerChatshortcutOk")
	--发送意见成功回调函数
	MsgBoxManager:showTipBox(LocalStrings.SET_SUCCESS)
end
-------------------------------------协议错误处理方法模块--------------------------------------

--@brief	公告相关协议(MAIN_BULLETINT = 11)失败
function ProtocolProcessorWndSetting:parse_BULLETINT_GetAboutErrorMessage(isexit , message)
	WZLog( "RebirthErrorMessage::2 ",KLuaSocket:utfToGBK(message) )
	MsgBoxManager:showTipBox( message ) 
end

--@brief	获取帮助（BULLETINT_GetHelp = 5）失败
function ProtocolProcessorWndSetting:parse_BULLETINT_GetHelpErrorMessage(isexit , message)
	WZLog( "RebirthErrorMessage::2 ",KLuaSocket:utfToGBK(message) )
	MsgBoxManager:showTipBox( message ) 
end

--@brief    发邮件失败函数
function ProtocolProcessorWndSetting:parse_MAIL_ErrorWriteMessage(isexit,message)
	WZLog("WriteMailError:: ",KLuaSocket:utfToGBK(message))
	MsgBoxManager:showTipBox( message )
	--关闭加载框
	WndSuggestion:closeLoading()
end

--@brief	修改玩家聊天快捷方式（PLAYER2_ChangePlayerChatshortcut = 21）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSetting:send_PLAYER2_ChangePlayerChatshortcut_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSetting:send_PLAYER2_ChangePlayerChatshortcut_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER2_ChangePlayerChatshortcut, nflag, sMessage)
end
-------------------------------------公有方法模块End----------------------------------------







