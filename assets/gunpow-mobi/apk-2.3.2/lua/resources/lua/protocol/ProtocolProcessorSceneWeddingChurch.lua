--ProtocolProcessorSceneWeddingChurch.lua
--@brief	结婚礼堂相关协议
--@date  	2013/4/16
--@author 	林庆凯	
--@note 	结婚礼堂相关协议


ProtocolProcessorSceneWeddingChurch = ProtocolProcessorBase:new()

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorSceneWeddingChurch:regAll()
	
	--@brief	退出婚礼（WEDDING_EXTWedding = 24）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_EXTWedding, "ProtocolProcessorSceneWeddingChurch:send_WEDDING_EXTWedding_ErrorProcess", "is" )

	--@brief	退出婚礼现场（WEDDING_ExtWeddingOk = 25)
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_ExtWeddingOk, "ProtocolProcessorSceneWeddingChurch:parse_WEDDING_ExtWeddingOk", "i")

	--@brief	获取来宾列表（WEDDING_GetJoinList = 26）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetJoinList, "ProtocolProcessorSceneWeddingChurch:send_WEDDING_GetJoinList_ErrorProcess", "is" )

	--@brief	发送来宾列表（WEDDING_SendJoinList = 27）
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_SendJoinList, "ProtocolProcessorSceneWeddingChurch:parse_WEDDING_SendJoinList", "vivsvivbvb")
	
	--@brief	抢东西成功（WEDDING_GetSomethingOK = 31）
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetSomethingOK, "ProtocolProcessorSceneWeddingChurch:parse_WEDDING_GetSomethingOK", "bti")

	
   --@brief	婚礼操作（WEDDING_Operation = 28）错误处理(S->C)
   self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_Operation, "ProtocolProcessorSceneWeddingChurch:send_WEDDING_Operation_ErrorProcess", "is" )

	--@brief	操作结果（WEDDING_OperationOK = 29）
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_OperationOK, "ProtocolProcessorSceneWeddingChurch:parse_WEDDING_OperationOK", "tt")
	
	--@brief	礼炮祝福（WEDDING_Blessing = 32）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_Blessing, "ProtocolProcessorSceneWeddingChurch:send_WEDDING_Blessing_ErrorProcess", "is" )

	--@brief	礼炮祝福成功（WEDDING_BlessingOk = 33）
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_BlessingOk, "ProtocolProcessorSceneWeddingChurch:parse_WEDDING_BlessingOk", "")
	
	--@brief	婚礼结束（WEDDING_WeddingOver = 34）
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_WeddingOver, "ProtocolProcessorSceneWeddingChurch:parse_WEDDING_WeddingOver", "")
	
	--@brief	刷新礼炮数（WEDDING_PlayerHaveBless = 35）
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_PlayerHaveBless, "ProtocolProcessorSceneWeddingChurch:parse_WEDDING_PlayerHaveBless", "i")

	--@brief	邀请来宾结果（WEDDING_InvitationOK = 52）
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_InvitationOK, "ProtocolProcessorSceneWeddingChurch:parse_WEDDING_InvitationOK", "t")

	
	--角色信息获取成功(S->C)
	
	--@brief	刷新婚礼现场（WEDDING_RefreshWedding = 36）
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_RefreshWedding, "ProtocolProcessorSceneWeddingChurch:parse_WEDDING_RefreshWedding", "isiiiitniiii")
   
    --@brief	密码设置（WEDDING_SetPassword = 37）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_SetPassword, "ProtocolProcessorSceneWeddingChurch:send_WEDDING_SetPassword_ErrorProcess", "is" )    

    --@brief	密码设置成功（WEDDING_SetPasswordOk = 38）
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_SetPasswordOk, "ProtocolProcessorSceneWeddingChurch:parse_WEDDING_SetPasswordOk", "s")

    --@brief	踢出玩家（WEDDING_PleaseOut = 39）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_PleaseOut, "ProtocolProcessorSceneWeddingChurch:send_WEDDING_PleaseOut_ErrorProcess", "is" )
    
    --@brief	推送操作给所有人（WEDDING_OperationToPlayer = 40）
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_OperationToPlayer , "ProtocolProcessorSceneWeddingChurch:parse_WEDDING_OperationToPlayer", "ttii")

    --@brief	婚礼日志（WEDDING_GetMarryLog = 42）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetMarryLog, "ProtocolProcessorSceneWeddingChurch:send_WEDDING_GetMarryLog_ErrorProcess", "is" )

    --@brief	婚礼日志结果（WEDDING_GetMarryLogOK = 43）
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetMarryLogOK, "ProtocolProcessorSceneWeddingChurch:parse_WEDDING_GetMarryLogOK", "vtvivsvsvi")

    --@brief	邀请好友（WEDDING_Invitation = 51）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_Invitation, "ProtocolProcessorSceneWeddingChurch:send_WEDDING_Invitation_ErrorProcess", "is" )

    --@brief	cd时间（WEDDING_GetCDTime = 54）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetCDTime, "ProtocolProcessorSceneWeddingChurch:send_WEDDING_GetCDTime_ErrorProcess", "is" )

    --@brief	cd时间（WEDDING_GetCDTimeOK = 55）
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetCDTimeOK, "ProtocolProcessorSceneWeddingChurch:parse_WEDDING_GetCDTimeOK", "vtvii")

    --@brief	抢（红包，喜糖)（WEDDING_GetSomething = 30）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetSomething , "ProtocolProcessorSceneWeddingChurch:send_WEDDING_GetSomething_ErrorProcess", "is" )
    
    --@brief	婚礼结果代码（WEDDING_ResultCode = 41）
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_ResultCode , "ProtocolProcessorSceneWeddingChurch:parse_WEDDING_ResultCode", "t")

    --@brief	开始婚礼（WEDDING_StartWedding = 110）160+		错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_StartWedding, "ProtocolProcessorSceneWeddingChurch:send_WEDDING_StartWedding_ErrorProcess", "is" )
	--@brief	通知对方开始婚礼（WEDDING_NoticeStartWedding = 111）160+		
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_NoticeStartWedding, "ProtocolProcessorSceneWeddingChurch:parse_WEDDING_NoticeStartWedding", "")
	--@brief	开始婚礼播放动画（WEDDING_StartWeddingOk = 112）160+		
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_StartWeddingOk, "ProtocolProcessorSceneWeddingChurch:parse_WEDDING_StartWeddingOk", "t")
	--@brief	动画播放结束就发过来（WEDDING_EndWeddingAni = 113）160+		错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_EndWeddingAni, "ProtocolProcessorSceneWeddingChurch:send_WEDDING_EndWeddingAni_ErrorProcess", "is" )
	--@brief	可以吃婚姻回调（WEDDING_NoticeForEat = 114）160+		
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_NoticeForEat, "ProtocolProcessorSceneWeddingChurch:parse_WEDDING_NoticeForEat", "")
	--@brief	吃婚姻（WEDDING_Eat = 115）160+		错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_Eat, "ProtocolProcessorSceneWeddingChurch:send_WEDDING_Eat_ErrorProcess", "is" )
	--@brief	吃婚宴结果（WEDDING_EatOk  = 116）160+		
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_EatOk, "ProtocolProcessorSceneWeddingChurch:parse_WEDDING_EatOk", "t")
	--@brief	房间进度推送（WEDDING_UpdateWedding  = 117）160+		
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_UpdateWedding, "ProtocolProcessorSceneWeddingChurch:parse_WEDDING_UpdateWedding", "t")
	--@brief	弹幕消息（WEDDING_BulletComment  = 118）160+		
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_BulletComment, "ProtocolProcessorSceneWeddingChurch:parse_WEDDING_BulletComment", "s")

end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorSceneWeddingChurch:unregAll()
	self:clearReg()
end
  
-------------------------------------客户端到服务器协议发送方法模块--------------------------------------

--@brief	退出婚礼（WEDDING_EXTWedding = 24）
function ProtocolProcessorSceneWeddingChurch:send_WEDDING_EXTWedding(wedNum )
	WZLog("send_WEDDING_EXTWedding = ",wedNum)
	local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WEDDING_EXTWedding )
	if sender==nil then WZLog("sender == nil") return end
    WndMarryManager:createLoading()
	sender:writeInt( wedNum )	-- 婚礼编号
	SendProtocol(sender,false) --true:showLoading
end

--@brief	婚礼日志（WEDDING_GetMarryLog = 42）
function ProtocolProcessorSceneWeddingChurch:send_WEDDING_GetMarryLog(weddingHallId)
	WZLog("send_WEDDING_GetMarryLog")
	local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetMarryLog )
	if sender==nil then WZLog("sender == nil") return end
    WndMarryManager:createLoading()
	sender:writeInt( weddingHallId )	-- 婚礼id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	邀请好友（WEDDING_Invitation = 51）
function ProtocolProcessorSceneWeddingChurch:send_WEDDING_Invitation(playerId,weddingHallId )
	WZLog("send_WEDDING_Invitation")
	local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WEDDING_Invitation )
	if sender==nil then WZLog("sender == nil") return end
	sender:writeInt( playerId )	-- 玩家id
	sender:writeInt( weddingHallId )	-- 玩家id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取来宾列表（WEDDING_GetJoinList = 26）
function ProtocolProcessorSceneWeddingChurch:send_WEDDING_GetJoinList( wedNum)
	WZLog("send_WEDDING_GetJoinList")
	
	local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetJoinList )
	if sender==nil then WZLog("sender == nil") return end
	WZLog("wedNum = ",wedNum)
	sender:writeString( wedNum )
	SendProtocol(sender,false) --true:showLoading
end


--@brief	婚礼操作（WEDDING_Operation = 28）
function ProtocolProcessorSceneWeddingChurch:send_WEDDING_Operation(weddingHallId, operation, index )
	WZLog("send_WEDDING_Operation ",weddingHallId,operation,index)
	local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WEDDING_Operation )
	if sender==nil then WZLog("sender == nil") return end
    WndMarryManager:createLoading()
	sender:writeInt( weddingHallId )	-- 婚礼id
	sender:writeByte( operation )	-- 操作类型【1、发红包，2、发喜糖，3、送祝福，4、放礼炮】
	sender:writeByte( index )	-- 【从左到右操作位置】1、第一个位置，2、第二个位置，3、第三个位置
	SendProtocol(sender,true) --true:showLoading
end


--@brief	礼炮祝福（WEDDING_Blessing = 32）
function ProtocolProcessorSceneWeddingChurch:send_WEDDING_Blessing(wedNum )
	WZLog("send_WEDDING_Blessing")
	local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WEDDING_Blessing )
	if sender==nil then WZLog("sender == nil") return end
	WZLog("wedNum = ",wedNum)
	sender:writeInt( wedNum )	-- 婚礼编号
	SendProtocol(sender,true) --true:showLoading
end


--@brief	添加好友（FRIEND_AddFriendNew = 20）
function ProtocolProcessorSceneWeddingChurch:send_FRIEND_AddFriendNew(playerId )
	WZLog("send_FRIEND_AddFriendNew")
	local sender = Protocol:getSender( Protocol.MAIN_FRIEND, Protocol.FRIEND_AddFriendNew )
	if sender==nil then WZLog("sender == nil") return end
	WZLog("playerId = ",playerId)
	sender:writeInt( playerId )	-- 添加的好友Id
	SendProtocol(sender,false) --true:showLoading
end


--@brief	密码设置（WEDDING_SetPassword = 37）
function ProtocolProcessorSceneWeddingChurch:send_WEDDING_SetPassword(usePassword, password, wedNum )
	WZLog("send_WEDDING_SetPassword")
	local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WEDDING_SetPassword )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeBoolean( usePassword )	-- 是否使用密码（true是设置密码，false是不设置密码）
	sender:writeString( password )	-- 密码
	sender:writeInt( wedNum )	-- 婚礼编号
	SendProtocol(sender,false) --true:showLoading
end

--@brief	踢出玩家（WEDDING_PleaseOut = 39）
function ProtocolProcessorSceneWeddingChurch:send_WEDDING_PleaseOut(playerId, wedNum )
    WZLog("send_WEDDING_PleaseOut")
    local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WEDDING_PleaseOut )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( playerId )	-- 玩家ID
    sender:writeInt( wedNum )	-- 婚礼编号
    SendProtocol(sender,true) --true:showLoading
end

--@brief	cd时间（WEDDING_GetCDTime = 54）
function ProtocolProcessorSceneWeddingChurch:send_WEDDING_GetCDTime(weddingHallId)
	WZLog("send_WEDDING_GetCDTime")
	local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetCDTime )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( weddingHallId )	-- 婚礼id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	抢（红包，喜糖)（WEDDING_GetSomething = 30）
function ProtocolProcessorSceneWeddingChurch:send_WEDDING_GetSomething(weddingHallId, operation,operationTime )
	WZLog("send_WEDDING_GetSomething  = ",weddingHallId,operation)
	local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetSomething  )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( weddingHallId )	-- 婚礼id
	sender:writeByte( operation )	-- 1、抢红包，2、抢喜糖
	sender:writeInt( operationTime )	-- 操作时间
	SendProtocol(sender,false) --true:showLoading
end

--@brief	开始婚礼（WEDDING_StartWedding = 110）160+		
function ProtocolProcessorSceneWeddingChurch:send_WEDDING_StartWedding(opType)
	WZLog("send_WEDDING_StartWedding",opType)
	local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WEDDING_StartWedding )
	if sender==nil then WZLog("sender == nil") return end

    sender:writeByte( opType )	-- 1通知伴侣 | 2确认开始 | 3取消开始
	SendProtocol(sender,false) --true:showLoading
end

--@brief	动画播放结束就发过来（WEDDING_EndWeddingAni = 113）160+		
function ProtocolProcessorSceneWeddingChurch:send_WEDDING_EndWeddingAni( )
	WZLog("send_WEDDING_EndWeddingAni")
	local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WEDDING_EndWeddingAni )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	吃婚姻（WEDDING_Eat = 115）160+		
function ProtocolProcessorSceneWeddingChurch:send_WEDDING_Eat( )
	WZLog("send_WEDDING_Eat")
	local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WEDDING_Eat )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end


-------------------------------------服务器到客户端协议回调方法模块--------------------------------------


--@brief	退出婚礼现场（WEDDING_ExtWeddingOk = 25)
function ProtocolProcessorSceneWeddingChurch:parse_WEDDING_ExtWeddingOk(playerId)
	WZLog("ProtocolProcessorSceneWeddingChurch:parse_WEDDING_ExtWeddingOk ----- ")
	-- playerId	int	来宾玩家id
	WndMarryManager:closeLoading()
	SceneWeddingChurch:ExtWeddingOk(playerId)
end


--@brief	操作结果（WEDDING_OperationOK = 29）
function ProtocolProcessorSceneWeddingChurch:parse_WEDDING_OperationOK(result, operation)
	-- result : 1、成功，2、正在发红包或喜糖
	-- operation : "操作类型【1、发红包，
	WZLog("ProtocolProcessorSceneWeddingChurch:parse_WEDDING_OperationOK")
	WndMarryManager:closeLoading()
	SceneWeddingChurch:sendBlessingResult(result,operation)
end


--@brief	礼炮祝福成功（WEDDING_BlessingOk = 33）
function ProtocolProcessorSceneWeddingChurch:parse_WEDDING_BlessingOk()
	WZLog("ProtocolProcessorSceneWeddingChurch:parse_WEDDING_BlessingOk")
	SceneWeddingChurch:BlessingOk()
end

--@brief	婚礼结束（WEDDING_WeddingOver = 34）
function ProtocolProcessorSceneWeddingChurch:parse_WEDDING_WeddingOver()
	SceneWeddingChurch:WeddingOver()
	WZLog("ProtocolProcessorSceneWeddingChurch:parse_WEDDING_WeddingOver")
end


--@brief	刷新礼炮数（WEDDING_PlayerHaveBless = 35）
function ProtocolProcessorSceneWeddingChurch:parse_WEDDING_PlayerHaveBless(BlessingNum)
	-- BlessingNum : 剩余礼炮数
	WZLog("ProtocolProcessorSceneWeddingChurch:parse_WEDDING_PlayerHaveBless")
	SceneWeddingChurch:PlayerHaveBless(BlessingNum)
end



--@brief	刷新婚礼现场（WEDDING_RefreshWedding = 36）
function ProtocolProcessorSceneWeddingChurch:parse_WEDDING_RefreshWedding(playerId, playerName, playerHeadId, playerFaceId, playerBodyId, playerWingId, sex, level,headColor,bodyColor,footmark, serverId)
	-- playerId : 来宾玩家id
	-- playerName : 来宾玩家昵称
	-- playerHeadId : 来宾的头没有为0
	-- playerFaceId : 来宾的脸
	-- playerBodyId : 来宾的身
	-- playerWingId : 来宾的翅膀
	-- sex : 来宾性别，true是男，false是女
	-- level : 来宾等级
	-- footmark : 足迹
	WZLog("ProtocolProcessorSceneWeddingChurch:parse_WEDDING_RefreshWedding = ")
	SceneWeddingChurch:RefreshWedding(playerId, playerName, playerHeadId, playerFaceId,playerBodyId, playerWingId,sex,level,headColor,bodyColor,footmark, serverId)
end


--@brief	婚礼结果代码（WEDDING_ResultCode = 41）
function ProtocolProcessorSceneWeddingChurch:parse_WEDDING_ResultCode (code)
	-- code : "1、密码不对 2、礼堂爆满
	WZLog("ProtocolProcessorSceneWeddingChurch:parse_WEDDING_ResultCode ")
	SceneWeddingDaily:JonWeddingError(code)
end


--@brief	抢东西成功（WEDDING_GetSomethingOK = 31）
function ProtocolProcessorSceneWeddingChurch:parse_WEDDING_GetSomethingOK(result, operation, num)
	-- result : 抢到为true, 没有抢到为false
	-- operation : 1、抢红包，2、抢喜糖
	-- num : 奖励数值
	WZLog("ProtocolProcessorSceneWeddingChurch:parse_WEDDING_GetSomethingOK")
	SceneWeddingChurch:RobResult(result,operation,num)
end


--@brief	密码设置成功（WEDDING_SetPasswordOk = 38）
function ProtocolProcessorSceneWeddingChurch:parse_WEDDING_SetPasswordOk(password)
	-- password : 密码
   WZLog("ProtocolProcessorSceneWeddingChurch:parse_WEDDING_SetPasswordOk")
   MsgBoxManager:showTipBox(LocalStrings.SETTING_WEDDING_HALL_PASS)
   GlobalGame.g_MarryPassWord = password
end

--@brief	推送操作给所有人（WEDDING_OperationToPlayer = 40）
function ProtocolProcessorSceneWeddingChurch:parse_WEDDING_OperationToPlayer(operation,index,playerId,operationTime)
	-- operation : 1、发红包，2、发喜糖，3、发祝福，4、发礼炮
	-- index : 对应的内容位置
	-- playerId : 操作人id
	-- operationTime : 操作时间
	WZLog("ProtocolProcessorSceneWeddingChurch:parse_WEDDING_OperationToPlayer ")
	SceneWeddingChurch:handleBlessing(operation,playerId,index,operationTime)
end

--@brief	婚礼日志结果（WEDDING_GetMarryLogOK = 43）
function ProtocolProcessorSceneWeddingChurch:parse_WEDDING_GetMarryLogOK(logType, createDate, playerName, coupleName, num)
	-- logType : 日志类型
	-- createDate : 创建时间（秒）
	-- playerName : 操作人名称 
	-- coupleName : 对象名称，没有为""
	-- num : 数值
	WndMarryManager:closeLoading()
	WZLog("ProtocolProcessorSceneWeddingChurch:parse_WEDDING_GetMarryLogOK")
	SceneWeddingChurch:showWeddingBlog(VectorToTable(logType),VectorToTable(createDate),VectorToTable(playerName),VectorToTable(coupleName),VectorToTable(num))
end

--@brief	邀请来宾结果（WEDDING_InvitationOK = 52）
function ProtocolProcessorSceneWeddingChurch:parse_WEDDING_InvitationOK(result)
	-- result : "1、目标未在线，
	WZLog("ProtocolProcessorSceneWeddingChurch:parse_WEDDING_InvitationOK")
	-- WndMarryManager:closeLoading()
	-- if result ==3 then
	-- 	MsgBoxManager:showTipBox(LocalStrings.FRIEND_NO_ONLINE)
	-- elseif result ==2 then
	-- 	MsgBoxManager:showTipBox(LocalStrings.FRIENG_BUSY)
	-- end
end

--@brief	cd时间（WEDDING_GetCDTimeOK = 55）
function ProtocolProcessorSceneWeddingChurch:parse_WEDDING_GetCDTimeOK(cdType, leaveTime, weddingHallId)
	-- cdType : cd类型1、红包，2、喜糖，3、礼炮，4、祝福
	-- leaveTime : 剩余时间
	-- weddingHallId : 婚礼id
	WZLog("ProtocolProcessorSceneWeddingChurch:parse_WEDDING_GetCDTimeOK")
	SceneWeddingChurch:getCDTime(VectorToTable(cdType), VectorToTable(leaveTime), VectorToTable(weddingHallId))
end

--@brief	通知对方开始婚礼（WEDDING_NoticeStartWedding = 111）160+		
function ProtocolProcessorSceneWeddingChurch:parse_WEDDING_NoticeStartWedding()
	WZLog("ProtocolProcessorSceneWeddingChurch:parse_WEDDING_NoticeStartWedding")
	if SceneWeddingChurch.m_root then
		SceneWeddingChurch:noticeStartWedding()
	end
end

--@brief	开始婚礼播放动画（WEDDING_StartWeddingOk = 112）160+		
function ProtocolProcessorSceneWeddingChurch:parse_WEDDING_StartWeddingOk(result)
	-- result : 1开始婚礼动画 2对方不在婚礼房间 3对方取消了操作
	WZLog("ProtocolProcessorSceneWeddingChurch:parse_WEDDING_StartWeddingOk",result)
	if SceneWeddingChurch.m_root then
		SceneWeddingChurch:startWeddingOk(result)
	end

	if result == 2 then
		MsgBoxManager:showTipBox(LocalStrings.MARRY_DESC_34)
	elseif result == 3 then
		MsgBoxManager:showTipBox(LocalStrings.MARRY_DESC_35)
	end
end

--@brief	可以吃婚姻回调（WEDDING_NoticeForEat = 114）160+		
function ProtocolProcessorSceneWeddingChurch:parse_WEDDING_NoticeForEat()
	WZLog("ProtocolProcessorSceneWeddingChurch:parse_WEDDING_NoticeForEat")
	if SceneWeddingChurch.m_root then
		SceneWeddingChurch:setEatStatus(0)
	end
end

--@brief	吃婚宴结果（WEDDING_EatOk  = 116）160+		
function ProtocolProcessorSceneWeddingChurch:parse_WEDDING_EatOk(result)
	-- result :  1成功 | 2已经吃过了 | 3没有吃的权限
	WZLog("ProtocolProcessorSceneWeddingChurch:parse_WEDDING_EatOk",result)
	if SceneWeddingChurch.m_root then
		SceneWeddingChurch:getWeddingEatOk(result)
	end
end

--@brief	房间进度推送（WEDDING_UpdateWedding  = 117）160+		
function ProtocolProcessorSceneWeddingChurch:parse_WEDDING_UpdateWedding(progress )
	-- progress  : 婚礼进度 1等待双方入场 | 2等待举办婚礼 | 3正在举办婚礼 | 4正在婚宴
	WZLog("ProtocolProcessorSceneWeddingChurch:parse_WEDDING_UpdateWedding",progress)
	if SceneWeddingChurch.m_root then
		SceneWeddingChurch:updateWedding(progress)
	end
end

--@brief	弹幕消息（WEDDING_BulletComment  = 118）160+		
function ProtocolProcessorSceneWeddingChurch:parse_WEDDING_BulletComment(msg)
	-- msg : 弹幕内容
	WZLog("ProtocolProcessorSceneWeddingChurch:parse_WEDDING_BulletComment",msg)
	if SceneWeddingChurch.m_root then
		SceneWeddingChurch:showMessage(msg)
	end
end


-------------------------------------协议错误处理方法模块-------------------------------------



--@brief	退出婚礼（WEDDING_EXTWedding = 24）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneWeddingChurch:send_WEDDING_EXTWedding_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneWeddingChurch:send_WEDDING_EXTWedding_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WEDDING_EXTWedding, nflag, sMessage)
	SceneWeddingChurch:ExitWeddingErrorProcess(nFlag, sMessage)
end



--@brief	获取来宾列表（WEDDING_GetJoinList = 26）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneWeddingChurch:send_WEDDING_GetJoinList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneWeddingChurch:send_WEDDING_GetJoinList_ErrorProcess")
	WndMarryManager:closeLoading()
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WEDDING_GetJoinList, nflag, sMessage)
	MsgBoxManager:showTipBox(sMessage)
end



--@brief	婚礼操作（WEDDING_Operation = 28）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneWeddingChurch:send_WEDDING_Operation_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneWeddingChurch:send_WEDDING_Operation_ErrorProcess")
	WndMarryManager:closeLoading()
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WEDDING_Operation, nflag, sMessage)
	MsgBoxManager:showTipBox(sMessage)

end

--@brief	礼炮祝福（WEDDING_Blessing = 32）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneWeddingChurch:send_WEDDING_Blessing_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneWeddingChurch:send_WEDDING_Blessing_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WEDDING_Blessing, nflag, sMessage)
	MsgBoxManager:showTipBox(sMessage)
end

--@brief	获取玩家仓库装备列表（PLAYER_GetPlayerStoreEquipmentNew = 41）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneWeddingChurch:send_PLAYER_GetPlayerStoreEquipmentNew_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneWeddingChurch:send_PLAYER_GetPlayerStoreEquipmentNew_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerStoreEquipmentNew, nflag, sMessage)
end


--@brief	密码设置（WEDDING_SetPassword = 37）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneWeddingChurch:send_WEDDING_SetPassword_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneWeddingChurch:send_WEDDING_SetPassword_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WEDDING_SetPassword, nflag, sMessage)
	MsgBoxManager:showTipBox(sMessage)
end

--@brief	踢出玩家（WEDDING_PleaseOut = 39）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneWeddingChurch:send_WEDDING_PleaseOut_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorSceneWeddingChurch:send_WEDDING_PleaseOut = 39_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WEDDING_PleaseOut, nflag, sMessage)
    MsgBoxManager:showTipBox(sMessage)
end

--@brief	婚礼日志（WEDDING_GetMarryLog = 42）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneWeddingChurch:send_WEDDING_GetMarryLog_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneWeddingChurch:send_WEDDING_GetMarryLog_ErrorProcess")
	WndMarryManager:closeLoading()
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WEDDING_GetMarryLog, nflag, sMessage)
	MsgBoxManager:showTipBox(sMessage)
end

--@brief	邀请好友（WEDDING_Invitation = 51）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneWeddingChurch:send_WEDDING_Invitation_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneWeddingChurch:send_WEDDING_Invitation_ErrorProcess")
	--WndMarryManager:closeLoading()
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WEDDING_Invitation, nflag, sMessage)
	MsgBoxManager:showTipBox(sMessage)
end


--@brief	cd时间（WEDDING_GetCDTime = 54）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneWeddingChurch:send_WEDDING_GetCDTime_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneWeddingChurch:send_WEDDING_GetCDTime_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WEDDING_GetCDTime, nflag, sMessage)
end

--@brief	抢（红包，喜糖)（WEDDING_GetSomething = 30）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneWeddingChurch:send_WEDDING_GetSomething_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneWeddingChurch:send_WEDDING_GetSomething _ErrorProcess")
	SceneWeddingChurch:resetRobRedOrCandies()
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WEDDING_GetSomething , nflag, sMessage)
	MsgBoxManager:showTipBox(sMessage)
end

--@brief	开始婚礼（WEDDING_StartWedding = 110）160+		错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneWeddingChurch:send_WEDDING_StartWedding_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneWeddingChurch:send_WEDDING_StartWedding_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WEDDING_StartWedding, nflag, sMessage)
end

--@brief	动画播放结束就发过来（WEDDING_EndWeddingAni = 113）160+		错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneWeddingChurch:send_WEDDING_EndWeddingAni_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneWeddingChurch:send_WEDDING_EndWeddingAni_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WEDDING_EndWeddingAni, nflag, sMessage)
end

--@brief	吃婚姻（WEDDING_Eat = 115）160+		错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneWeddingChurch:send_WEDDING_Eat_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneWeddingChurch:send_WEDDING_Eat_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WEDDING_Eat, nflag, sMessage)
end

-------------------------------------公有方法模块End----------------------------------------


