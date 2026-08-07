--ProtocolProcessorMatchmaking.lua
--@brief	结婚大厅相关协议
--@date  	2013/4/21
--@author 	林庆凯	
--@note 	结婚礼堂相关协议

ProtocolProcessorMatchmaking = ProtocolProcessorBase:new()

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorMatchmaking:regAll()
    --@brief	登记交友宣言（WEDDING_DatingServiceSignOk = 99）
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_DatingServiceSignOk, "ProtocolProcessorMatchmaking:parse_WEDDING_DatingServiceSignOk", "tis")
    --@brief	交友推荐（WEDDING_DatingServiceRecommendOk = 101）
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_DatingServiceRecommendOk, "ProtocolProcessorMatchmaking:parse_WEDDING_DatingServiceRecommendOk", "b")
    --@brief	交友列表（WEDDING_GetDatingServiceInfoListOk = 103）
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetDatingServiceInfoListOk, "ProtocolProcessorMatchmaking:parse_WEDDING_GetDatingServiceInfoListOk", "vivsvtvivivivivivsvivsvsvbvi")
    --@brief	交友推荐（WEDDING_GetDatingServiceInfoOk = 105）
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetDatingServiceInfoOk, "ProtocolProcessorMatchmaking:parse_WEDDING_GetDatingServiceInfoOk", "sbi")
    --@brief	撤销交友宣言（WEDDING_CancelDatingServiceSignOk = 107）
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_CancelDatingServiceSignOk, "ProtocolProcessorMatchmaking:parse_WEDDING_CancelDatingServiceSignOk", "sbi")

    --@brief	登记交友宣言（WEDDING_DatingServiceSign = 98）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_DatingServiceSign, "ProtocolProcessorMatchmaking:send_WEDDING_DatingServiceSign_ErrorProcess", "is" )
	--@brief	交友推荐（WEDDING_DatingServiceRecommend = 100）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_DatingServiceRecommend, "ProtocolProcessorMatchmaking:send_WEDDING_DatingServiceRecommend_ErrorProcess", "is" )
	--@brief	交友列表（WEDDING_GetDatingServiceInfoList = 102）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetDatingServiceInfoList, "ProtocolProcessorMatchmaking:send_WEDDING_GetDatingServiceInfoList_ErrorProcess", "is" )
	--@brief	交友推荐（WEDDING_GetDatingServiceInfo = 104）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetDatingServiceInfo, "ProtocolProcessorMatchmaking:send_WEDDING_GetDatingServiceInfo_ErrorProcess", "is" )
	--@brief	撤销交友宣言（WEDDING_CancelDatingServiceSign = 106）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_CancelDatingServiceSign, "ProtocolProcessorMatchmaking:send_WEDDING_CancelDatingServiceSign_ErrorProcess", "is" )
end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorMatchmaking:unregAll()
	self:clearReg()
end
  
-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief	登记交友宣言（WEDDING_DatingServiceSign = 98）
function ProtocolProcessorMatchmaking:send_WEDDING_DatingServiceSign(msg)
	WZLog("send_WEDDING_DatingServiceSign")
	local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WEDDING_DatingServiceSign )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeString( msg ) -- 交友宣言
	SendProtocol(sender,false) --true:showLoading
end

--@brief	交友推荐（WEDDING_DatingServiceRecommend = 100）
function ProtocolProcessorMatchmaking:send_WEDDING_DatingServiceRecommend( )
	WZLog("send_WEDDING_DatingServiceRecommend")
	local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WEDDING_DatingServiceRecommend )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	交友列表（WEDDING_GetDatingServiceInfoList = 102）
function ProtocolProcessorMatchmaking:send_WEDDING_GetDatingServiceInfoList(sex)
	WZLog("send_WEDDING_GetDatingServiceInfoList")
	local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetDatingServiceInfoList )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeByte(sex) -- 性别
	SendProtocol(sender,false) --true:showLoading
end

--@brief	交友推荐（WEDDING_GetDatingServiceInfo = 104）
function ProtocolProcessorMatchmaking:send_WEDDING_GetDatingServiceInfo( )
	WZLog("send_WEDDING_GetDatingServiceInfo")
	local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetDatingServiceInfo )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	撤销交友宣言（WEDDING_CancelDatingServiceSign = 106）
function ProtocolProcessorMatchmaking:send_WEDDING_CancelDatingServiceSign( )
	WZLog("send_WEDDING_CancelDatingServiceSign")
	local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WEDDING_CancelDatingServiceSign )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end
-------------------------------------服务器到客户端协议回调方法模块--------------------------------------
--@brief	登记交友宣言（WEDDING_DatingServiceSignOk = 99）
function ProtocolProcessorMatchmaking:parse_WEDDING_DatingServiceSignOk(status, lastTime, msg)
	-- status : 1、成功,3、非法字符,4、名字不能为空,5、名字太长, 6、名字太短
	-- lastTime : 宣言剩余时间
	-- msg : 交友宣言
	
	WZLog("ProtocolProcessorMatchmaking:parse_WEDDING_DatingServiceSignOk")
	WndMatchmaking:registerSuccess(status, lastTime, msg)
end

--@brief	交友推荐（WEDDING_DatingServiceRecommendOk = 101）
function ProtocolProcessorMatchmaking:parse_WEDDING_DatingServiceRecommendOk(recommend)
	-- recommend : 推荐状态
	
	WZLog("ProtocolProcessorMatchmaking:parse_WEDDING_DatingServiceRecommendOk")
	WndMatchmaking:recommendSuccess(recommend)
end

--@brief	交友列表（WEDDING_GetDatingServiceInfoListOk = 103）
function ProtocolProcessorMatchmaking:parse_WEDDING_GetDatingServiceInfoListOk(playerId, playerName, sex, level, vipLevel, headId, faceId, headColor, photoUrl, fight, guildName, msg, recommend, serverId)
	-- photoUrl : 照片url
	-- msg : 交友宣言
	-- recommend : 是否推荐
	
	WZLog("ProtocolProcessorMatchmaking:parse_WEDDING_GetDatingServiceInfoListOk")
	WndMatchmaking:setPlayerListData(VectorToTable(playerId), VectorToTable(sex), VectorToTable(level), VectorToTable(playerName), VectorToTable(vipLevel), VectorToTable(headId), VectorToTable(faceId), VectorToTable(headColor), VectorToTable(guildName), VectorToTable(fight), VectorToTable(msg), VectorToTable(photoUrl), VectorToTable(recommend), VectorToTable(serverId))
end

--@brief	交友推荐（WEDDING_GetDatingServiceInfoOk = 105）
function ProtocolProcessorMatchmaking:parse_WEDDING_GetDatingServiceInfoOk(msg, status, lastTime)
	-- msg : 交友宣言
	-- status : 推荐状态
	-- lastTime : 宣言剩余时间
	
	WZLog("ProtocolProcessorMatchmaking:parse_WEDDING_GetDatingServiceInfoOk")
	WndMatchmaking:getDataOk(msg, status, lastTime)
end

--@brief	撤销交友宣言（WEDDING_CancelDatingServiceSignOk = 107）
function ProtocolProcessorMatchmaking:parse_WEDDING_CancelDatingServiceSignOk()
	WZLog("ProtocolProcessorMatchmaking:parse_WEDDING_CancelDatingServiceSignOk")
	WndMatchmaking:cancelRegisterSuccess()
end
-------------------------------------协议错误处理方法模块--------------------------------------
--@brief	登记交友宣言（WEDDING_DatingServiceSign = 98）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorMatchmaking:send_WEDDING_DatingServiceSign_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorMatchmaking:send_WEDDING_DatingServiceSign_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WEDDING_DatingServiceSign, nflag, sMessage)
end

--@brief	交友推荐（WEDDING_DatingServiceRecommend = 100）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorMatchmaking:send_WEDDING_DatingServiceRecommend_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorMatchmaking:send_WEDDING_DatingServiceRecommend_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WEDDING_DatingServiceRecommend, nflag, sMessage)
end

--@brief	交友列表（WEDDING_GetDatingServiceInfoList = 102）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorMatchmaking:send_WEDDING_GetDatingServiceInfoList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorMatchmaking:send_WEDDING_GetDatingServiceInfoList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WEDDING_GetDatingServiceInfoList, nflag, sMessage)
end

--@brief	交友推荐（WEDDING_GetDatingServiceInfo = 104）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorMatchmaking:send_WEDDING_GetDatingServiceInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorMatchmaking:send_WEDDING_GetDatingServiceInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WEDDING_GetDatingServiceInfo, nflag, sMessage)
end

--@brief	撤销交友宣言（WEDDING_CancelDatingServiceSign = 106）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorMatchmaking:send_WEDDING_CancelDatingServiceSign_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorMatchmaking:send_WEDDING_CancelDatingServiceSign_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WEDDING_CancelDatingServiceSign, nflag, sMessage)
end
-------------------------------------公有方法模块End----------------------------------------


