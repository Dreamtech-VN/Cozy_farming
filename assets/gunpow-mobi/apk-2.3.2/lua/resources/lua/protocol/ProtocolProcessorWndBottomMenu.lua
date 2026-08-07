--ProtocolProcessorWndBottomMenu.lua
--@brief	底部菜单用到的相关协议
--@date  	2014/01/14
--@author 	xiaoyu_wu
--@note 	底部菜单用到的相关协议


ProtocolProcessorWndBottomMenu = ProtocolProcessorBase:new()


--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorWndBottomMenu:regAll()
	--服务器到客户端协议注册
    --@brief	返回是否有未读邮件
    self:regProtocolCallbackFunction( Protocol.MAIN_MAIL, Protocol.MAIL_LoginCheckMailOk, "ProtocolProcessorWndBottomMenu:parse_MAIL_LoginCheckMailOk", "bi")
    --@brief    可提交任务的数量
    self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_GetCommitTaskNum, "ProtocolProcessorWndBottomMenu:parse_TASK_GetCommitTaskNum", "iiii")
	--协议错误处理	
	--@brief	获取是否有完成未提交的任务错误处理(S->C)
    --self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_GetTaskStatus, "ProtocolProcessorWndBottomMenu:send_TASK_GetTaskStatus_ErrorProcess", "is" )
    --@brief	登陆时检测是否有未读邮件错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_MAIL, Protocol.MAIL_LoginCheckMail, "ProtocolProcessorWndBottomMenu:send_MAIL_LoginCheckMail_ErrorProcess", "is" )

end

--@brief    可提交任务的数量
function ProtocolProcessorWndBottomMenu:parse_TASK_GetCommitTaskNum(taskNum,nMainTaskCount,nDailyTaskCount,nBranchTaskCount)
    -- taskNum : 未提交完成任务数量
    WZLog("ProtocolProcessorWndBottomMenu:parse_TASK_GetCommitTaskNum")
    GlobalGame.g_nTaskCount = taskNum
    GlobalGame.g_nMainTaskCount = nMainTaskCount
    GlobalGame.g_nBranchTaskCount = nBranchTaskCount
    GlobalGame.g_nDailyTaskCount = nDailyTaskCount
    WZLog("ProtocolProcessorWndBottomMenu::MAIN_TASK="..nMainTaskCount)
    WZLog("ProtocolProcessorWndBottomMenu:Branch_task="..nBranchTaskCount)
    WZLog("ProtocolProcessorWndBottomMenu:dailyTask="..nDailyTaskCount)
    if WndTask.m_root ~= nil then
        if not (nMainTaskCount == 0) or not (nBranchTaskCount==0) or not (nDailyTaskCount==0) then
            WndTask:_setTaskCount()
        end
    end
    WndBottomMenu:setTaskCount(true, taskNum)
end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorWndBottomMenu:unregAll()
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块Begin--------------------------------------
--@brief	获取是否有完成未提交的任务
function ProtocolProcessorWndBottomMenu:send_TASK_GetTaskStatus( )
	--WZLog("send_TASK_GetTaskStatus")
	local sender = Protocol:getSender( Protocol.MAIN_TASK, Protocol.TASK_GetTaskStatus )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	登陆时检测是否有未读邮件
function ProtocolProcessorWndBottomMenu:send_MAIL_LoginCheckMail( )
	--WZLog("send_MAIL_LoginCheckMail")
	local sender = Protocol:getSender( Protocol.MAIN_MAIL, Protocol.MAIL_LoginCheckMail )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end


-------------------------------------客户端到服务器协议发送方法模块End--------------------------------------


-------------------------------------服务器到客户端协议回调方法模块Begin--------------------------------------

--@brief	返回是否有未读邮件
function ProtocolProcessorWndBottomMenu:parse_MAIL_LoginCheckMailOk(checkMail, mailNum)
	-- checkMail : 是否有未读邮件（true表示有，false表示没有）
	-- mailNum : 未读邮件数量
	--WZLog("ProtocolProcessorWndBottomMenu:parse_MAIL_LoginCheckMailOk")
	GlobalGame.g_nMailCount = mailNum
    WndBottomMenu:setMailCount(checkMail, mailNum)
end

-------------------------------------服务器到客户端协议回调方法模块End--------------------------------------


-------------------------------------协议错误处理方法模块Begin--------------------------------------
--@brief	获取是否有完成未提交的任务错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndBottomMenu:send_TASK_GetTaskStatus_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndBottomMenu:send_TASK_GetTaskStatus_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TASK, Protocol.TASK_GetTaskStatus, nflag, sMessage)
end

--@brief	登陆时检测是否有未读邮件错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndBottomMenu:send_MAIL_LoginCheckMail_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndBottomMenu:send_MAIL_LoginCheckMail_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MAIL, Protocol.MAIL_LoginCheckMail, nflag, sMessage)
end

-------------------------------------协议错误处理方法模块End--------------------------------------





