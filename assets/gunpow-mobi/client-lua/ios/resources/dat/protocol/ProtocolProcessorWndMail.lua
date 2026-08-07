--ProtocolProcessorWndMail.lua
--@brief	邮件相关协议
--@date  	2015/3/27
--@author 	chuanchuan_wang
--@note 	邮件相关协议


ProtocolProcessorWndMail = ProtocolProcessorBase:new()

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	注册协议组所有协议
--@note	注册协议组所有协议
function ProtocolProcessorWndMail:regAll()
	--@brief	发送邮件内容（MAIL_GetMailContentOk = 2）
	self:regProtocolCallbackFunction( Protocol.MAIN_MAIL, Protocol.MAIL_GetMailContentOk, "ProtocolProcessorWndMail:parse_MAIL_GetMailContentOk", "ii") --新
	--@brief	发送邮件成功（MAIL_SendMailOk = 4）
	self:regProtocolCallbackFunction( Protocol.MAIN_MAIL, Protocol.MAIL_SendMailOk, "ProtocolProcessorWndMail:parse_MAIL_SendMailOk", "") --新
	--@brief	删除邮件成功（MAIL_DeleteMailOk = 6）
	self:regProtocolCallbackFunction( Protocol.MAIN_MAIL, Protocol.MAIL_DeleteMailOk, "ProtocolProcessorWndMail:parse_MAIL_DeleteMailOk", "") --新
	--@brief	删除商务邮件成功（MAIL_DeleteMailOk = 19）
	self:regProtocolCallbackFunction( Protocol.MAIN_MAIL, Protocol.MAIL_DeleteMallMailOk, "ProtocolProcessorWndMail:parse_MAIL_DeleteMailOk2", "") --新
	--@brief	获取邮件列表成功（MAIL_GetMailListOk = 8）
	self:regProtocolCallbackFunction( Protocol.MAIN_MAIL, Protocol.MAIL_GetMailListOk, "ProtocolProcessorWndMail:parse_MAIL_GetMailListOk", "vivsvsvivivivivivsvsvsvtvsvsvi") --新
	--@brief	推送新增邮件到客户端（MAIL_PushMail = 9）*玩家发邮件给别人，或别人发邮件给玩家服务端都会推送该协议
	self:regProtocolCallbackFunction( Protocol.MAIN_MAIL, Protocol.MAIL_PushMail, "ProtocolProcessorWndMail:parse_MAIL_PushMail", "issiiiiissstssii") --新
	--@brief	领取邮件里的物品（MAIL_GetMailRewardOk = 11）
	self:regProtocolCallbackFunction( Protocol.MAIN_MAIL, Protocol.MAIL_GetMailRewardOk, "ProtocolProcessorWndMail:parse_MAIL_GetMailRewardOk", "sb") --新
	--@brief	领取邮件里的物品（MAIL_GetAllMailRewardOk = 13）
	self:regProtocolCallbackFunction( Protocol.MAIN_MAIL, Protocol.MAIL_GetAllMailRewardOk, "ProtocolProcessorWndMail:parse_MAIL_GetAllMailRewardOk", "svib") --新
	--@brief	领取邮件里的物品（MAIL_SendSuggestionOk = 15）
	self:regProtocolCallbackFunction( Protocol.MAIN_MAIL, Protocol.MAIL_SendSuggestionOk, "ProtocolProcessorWndMail:parse_MAIL_SendSuggestionOk", "") --新
	--@brief	领取邮件里的物品（MAIL_SendSuggestionOk = 17）
	self:regProtocolCallbackFunction( Protocol.MAIN_MAIL, Protocol.MAIL_MallMailOperateOk, "ProtocolProcessorWndMail:parse_MAIL_MallMailOperateOk", "iivivi") --新
	
	--协议错误处理	
	--@brief	获取邮件内容（MAIL_GetMailContent = 1）错误处理(S->C)---新
	self:regProtocolCallbackFunction( Protocol.MAIN_MAIL, Protocol.MAIL_GetMailContent, "ProtocolProcessorWndMail:send_MAIL_GetMailContent_ErrorProcess", "is" )
	--@brief	发送邮件（MAIL_SendMail = 3）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_MAIL, Protocol.MAIL_SendMail, "ProtocolProcessorWndMail:send_MAIL_SendMail_ErrorProcess", "is" ) --新
	--@brief	删除邮件（MAIL_DeleteMail = 5）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_MAIL, Protocol.MAIL_DeleteMail, "ProtocolProcessorWndMail:send_MAIL_DeleteMail_ErrorProcess", "is" ) --新
	--@brief	获取邮件列表（MAIL_GetMailList = 7）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_MAIL, Protocol.MAIL_GetMailList, "ProtocolProcessorWndMail:send_MAIL_GetMailList_ErrorProcess", "is" ) --新
	--@brief	领取邮件里的物品（MAIL_GetMailReward = 10）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_MAIL, Protocol.MAIL_GetMailReward, "ProtocolProcessorWndMail:send_MAIL_GetMailReward_ErrorProcess", "is" ) --新
	--@brief	领取所有邮件里的物品（MAIL_GetAllMailReward = 12）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_MAIL, Protocol.MAIL_GetAllMailReward, "ProtocolProcessorWndMail:send_MAIL_GetAllMailReward_ErrorProcess", "is" ) --新
	--@brief	领取邮件里的物品（MAIL_SendSuggestionOk = 16）
	self:regProtocolCallbackFunction( Protocol.MAIN_MAIL, Protocol.MAIL_MallMailOperate, "ProtocolProcessorWndMail:MAIL_MallMailOperate_ErrorProcess", "is") --新
	--@brief	领取邮件里的物品（MAIL_SendSuggestion = 14）
	--self:regProtocolCallbackFunction( Protocol.MAIN_MAIL, Protocol.MAIL_SendSuggestion, "ProtocolProcessorWndMail:send_MAIL_SendSuggestion_ErrorProcess", "is") --新
end


--@brief	反注册协议组所有协议
--@note	反注册协议组所有协议
function ProtocolProcessorWndMail:unregAll()
	self:clearReg()
end
  
-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief	获取邮件内容（MAIL_GetMailContent = 1）--新
function ProtocolProcessorWndMail:send_MAIL_GetMailContent(id )
	WZLog("send_MAIL_GetMailContent")
	local sender = Protocol:getSender( Protocol.MAIN_MAIL, Protocol.MAIL_GetMailContent )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( id )	-- 邮件id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取邮件内容（MAIL_GetMailContent = 1）--新
function ProtocolProcessorWndMail:MAIL_MallMailOperate(id,state)
	WZLog("send_MAIL_GetMailContent")
	local sender = Protocol:getSender( Protocol.MAIN_MAIL, Protocol.MAIL_MallMailOperate )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( id )	-- 邮件id
	sender:writeInt( state )	-- 操作状态
	SendProtocol(sender,false) --true:showLoading
end

--@brief	发送邮件（MAIL_SendMail = 3） --新
function ProtocolProcessorWndMail:send_MAIL_SendMail(theme, addressee, content )
	WZLog("发送邮件send_MAIL_SendMail")
	local sender = Protocol:getSender( Protocol.MAIN_MAIL, Protocol.MAIL_SendMail )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeString( theme )	-- 主题
	sender:writeInt( addressee )	-- 收件人id
	sender:writeString( content )	-- 内容
	SendProtocol(sender,false) --true:showLoading
end

--@brief	删除邮件（MAIL_DeleteMail = 5）--新
function ProtocolProcessorWndMail:send_MAIL_DeleteMail(id )
	WZLog("send_MAIL_DeleteMail")
	local sender = Protocol:getSender( Protocol.MAIN_MAIL, Protocol.MAIL_DeleteMail )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInts( id )	-- 邮件id
	SendProtocol(sender,false) --true:showLoading

    CacheCenter:setMailStatus(VectorToTable(id), 2, "del")
    CacheCenter:isMailRedPoint()

	--@brief   创建加载框
	--WndMail:createLoading()
end

--@brief	删除邮件（MAIL_DeleteMail = 5）--新
function ProtocolProcessorWndMail:send_MAIL_DeleteMail2(id )
	WZLog("send_MAIL_DeleteMail")
	local sender = Protocol:getSender( Protocol.MAIN_MAIL, Protocol.MAIL_DeleteMallMail )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( id )	-- 邮件id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取邮件列表（MAIL_GetMailList = 7）
function ProtocolProcessorWndMail:send_MAIL_GetMailList( ) --新
	WZLog("h-获取邮件列表请求send_MAIL_GetMailList")
	local sender = Protocol:getSender( Protocol.MAIN_MAIL, Protocol.MAIL_GetMailList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	领取邮件里的物品（MAIL_GetMailReward = 10）
function ProtocolProcessorWndMail:send_MAIL_GetMailReward(id )
	WZLog("send_MAIL_GetMailReward")
	local sender = Protocol:getSender( Protocol.MAIN_MAIL, Protocol.MAIL_GetMailReward )
	if sender==nil then WZLog("sender == nil") return end

	NOTRECYCLESKINIDS = {}
	COPYSKINDATA = CopyTable(WndPhantom.m_tDataList)

	sender:writeInt( id )	-- 邮件id
	SendProtocol(sender,false) --true:showLoading
    CacheCenter:setMailStatus(id, 2, "get")
    CacheCenter:isMailRedPoint()
end

--@brief	领取所有邮件里的物品（MAIL_GetAllMailReward = 12）：一键领取
function ProtocolProcessorWndMail:send_MAIL_GetAllMailReward()
	WZLog("send_MAIL_GetAllMailReward")
	local sender = Protocol:getSender( Protocol.MAIN_MAIL, Protocol.MAIL_GetAllMailReward )
	if sender==nil then WZLog("sender == nil") return end

	NOTRECYCLESKINIDS = {}
	COPYSKINDATA = CopyTable(WndPhantom.m_tDataList)
	
	SendProtocol(sender,false) --true:showLoading

end

--@brief	发送建议邮箱（MAIL_SendSuggestion = 14）：一键领取
function ProtocolProcessorWndMail:send_MAIL_SendSuggestion(id, content)
	WZLog("send_MAIL_SendSuggestion")
	local sender = Protocol:getSender( Protocol.MAIN_MAIL, Protocol.MAIL_SendSuggestion )
	if sender==nil then WZLog("sender == nil") return end
	sender:writeInt(id)	-- 收件人id
	sender:writeString(content)	-- 内容
	SendProtocol(sender,false) --true:showLoading
end

-------------------------------------服务器到客户端协议回调方法模块--------------------------------------
--@brief	打开的邮件内容（MAIL_GetMailContentOk = 2）
function ProtocolProcessorWndMail:parse_MAIL_GetMailContentOk(id, state) --新
	-- id : 邮件ID
	-- sender : 发件人名称
	-- theme : 邮件主题
	-- content : 邮件内容
	-- sendTime : 发送时间
	-- attachments : 附件,例如[26,100]&[856,2]
	WZLog("ProtocolProcessorWndMail:parse_MAIL_GetMailContentOk",id,state)
	WndMail:openMailCallBack(id, state)
    CacheCenter:setMailStatus(id, 2, "open")
    CacheCenter:isMailRedPoint()
end

function ProtocolProcessorWndMail:parse_MAIL_MallMailOperateOk(id, state, itemId, itemNum)
	WZLog("ProtocolProcessorWndMail:parse_MAIL_MallMailOperateOk",id,state)
	WndMail:updateShopMailList(id, state)
    CacheCenter:isMailRedPoint()
	if itemId:size() > 0 then
		WndRewardShow:showById(VectorToTable(itemId), VectorToTable(itemNum))
	end
end

--@brief	发送邮件成功（MAIL_SendMailOk = 4）
function ProtocolProcessorWndMail:parse_MAIL_SendMailOk() --新
	WZLog("发送邮件成功ProtocolProcessorWndMail:parse_MAIL_SendMailOk")
  	MsgBoxManager:showTipBox(LocalStrings.SEND_MAIL_SUCCESS)
end

--@brief	删除邮件成功（MAIL_DeleteMailOk = 6）
function ProtocolProcessorWndMail:parse_MAIL_DeleteMailOk() --新
	WZLog("删除邮件成功:ProtocolProcessorWndMail:parse_MAIL_DeleteMailOk")
    WndMail:getInfoFromServer(0)
    MsgBoxManager:showTipBox(LocalStrings.DEL_MAIL_SUCCESS)
end

--@brief	删除邮件成功（MAIL_DeleteMailOk = 6）
function ProtocolProcessorWndMail:parse_MAIL_DeleteMailOk2(result) --新
	WZLog("删除邮件成功:ProtocolProcessorWndMail:parse_MAIL_DeleteMailOk")
    WndMail:getInfoFromServer(0)
    MsgBoxManager:showTipBox(LocalStrings.DEL_MAIL_SUCCESS)
end

--@brief	获取邮件列表成功（MAIL_GetMailListOk = 8）
function ProtocolProcessorWndMail:parse_MAIL_GetMailListOk(id, theme, time, status, sendId, attachment, headId, faceId, cost, content, attachments,sexs,senderName,recvName,color) --新
	-- id : 邮件ID
	-- theme : 邮件主题
	-- time : 发件时间
	-- status : 0未读1已读未领取2已读已领取3为可领取4为已领5为付款6为已付款7为已拒绝;8未读已领取
	-- sendId : 发件人ID。当发件人ID不等于玩家ID为收件，否则为发件
	WZLog("ProtocolProcessorWndMail:parse_MAIL_GetMailListOk",id:size())
	CacheCenter:setMailList(id, theme, time, status, sendId, attachment, headId, faceId, cost, content, attachments,sexs,senderName,recvName,color)
end

--@brief   推送新增邮件到客户端（MAIL_PushMail = 9）*玩家发邮件给别人，或别人发邮件给玩家服务端都会推送该协议
function ProtocolProcessorWndMail:parse_MAIL_PushMail(id, theme, time, status, sendId, attachment, headId, faceId, cost, content, attachments,sexs,senderName,recvName, deleMailId,color) --新
	-- id : 邮件ID
	-- theme : 邮件主题
	-- time : 发件时间
	-- sendId : 发件人ID。当发件人ID不等于玩家ID为收件，否则为发件
	WZLog("推送新增邮件到客户端ProtocolProcessorWndMail:parse_MAIL_PushMail")
	CacheCenter:pushMail(id, theme, time, status, sendId, attachment, headId, faceId, cost, content, attachments,sexs,senderName,recvName, deleMailId,color)

end

--@brief	领取邮件里的物品（MAIL_GetMailRewardOk = 11）
function ProtocolProcessorWndMail:parse_MAIL_GetMailRewardOk(reward,fullBag) --新
	-- reward : 格式[26*100]&[856*2]
	WZLog("ProtocolProcessorWndMail:parse_MAIL_GetMailRewardOk",reward)
	--local id,num = SplitItemString(WndMail.attachments)
	local id,num = SplitItemString(reward)
    WndMail:getAwardOk()
	for i=1,#id do
		local tData = GDatatab_item["id_"..id[i]]
		if tData ~= nil and tData.main_type == 20 then
			local show = true
			if COPYSKINDATA ~= nil then  
				local shapeId = tData.property[1][1]
				for i=1,#COPYSKINDATA do
					if COPYSKINDATA[i].shapeId == shapeId then
						if COPYSKINDATA[i].remainTime == -1 then
							show = false
						end
					end
				end
			end
			WZLog("NOTRECYCLEIDS_0", show)
			
			if show == true and (not utilsValueInTable(tData.id, NOTRECYCLESKINIDS)) then
				table.insert(NOTRECYCLESKINIDS, tData.id)
			end
		end
	end
	WZLog("ProtocolProcessorWndMail:parse_MAIL_",Serialize(NOTRECYCLESKINIDS))
	WndRewardShow:showById(id,num)
	pushEquipInList()
	WndMail:setTips(fullBag)
end

--@brief	领取所有邮件里的物品（MAIL_GetAllMailRewardOk = 13）
function ProtocolProcessorWndMail:parse_MAIL_GetAllMailRewardOk(reward, id, fullBag) --新
	-- reward : 格式[26*100]&[856*2]
	WZLog("ProtocolProcessorWndMail:parse_MAIL_GetAllMailRewardOk",id:size(),reward)
    WndMail:getAllRewardOk(reward,id)
    WndMail:setTips(fullBag)

    CacheCenter:setMailStatus(VectorToTable(id), 8, "getAll")
    CacheCenter:isMailRedPoint()
end

--@brief	发送建议邮箱成功（MAIL_GetAllMailRewardOk = 15）
function ProtocolProcessorWndMail:parse_MAIL_SendSuggestionOk() --新
	-- reward : 格式[26*100]&[856*2]
	WZLog("ProtocolProcessorWndMail:parse_MAIL_SendSuggestionOk")
    MsgBoxManager:showTipBox(LocalStrings.SEND_MAIL_SUCCESS)
end
-------------------------------------公有方法模块End-------------------------------------------

-------------------------------------协议错误处理方法模块--------------------------------------

--@brief	获取邮件内容（MAIL_GetMailContent = 1）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMail:send_MAIL_GetMailContent_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMail:send_MAIL_GetMailContent_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MAIL, Protocol.MAIL_GetMailContent, nflag, sMessage)
    MsgBoxManager:showTipBox(sMessage)
end


--@brief	发送邮件（MAIL_SendMail = 3）错误处理函数(S->C) --新
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMail:send_MAIL_SendMail_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMail:send_MAIL_SendMail_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MAIL, Protocol.MAIL_SendMail, nflag, sMessage)
    WndMail:closeLoading()
    MsgBoxManager:showTipBox(sMessage)
end

--@brief	删除邮件（MAIL_DeleteMail = 5）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMail:send_MAIL_DeleteMail_ErrorProcess(nFlag, sMessage)  --新
	WZLog("ProtocolProcessorWndMail:send_MAIL_DeleteMail_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MAIL, Protocol.MAIL_DeleteMail, nflag, sMessage)
    WndMail:closeLoading()
    MsgBoxManager:showTipBox(sMessage)
end

--@brief	获取邮件列表（MAIL_GetMailList = 7）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMail:send_MAIL_GetMailList_ErrorProcess(nFlag, sMessage) --新
	WZLog("ProtocolProcessorWndMail:send_MAIL_GetMailList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MAIL, Protocol.MAIL_GetMailList, nflag, sMessage)
    WndMail:closeLoading()
    MsgBoxManager:showTipBox(sMessage)
end

--@brief	领取邮件里的物品（MAIL_GetMailReward = 10）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMail:send_MAIL_GetMailReward_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMail:send_MAIL_GetMailReward_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MAIL, Protocol.MAIL_GetMailReward, nflag, sMessage)
    WndMail:closeLoading()
    MsgBoxManager:showTipBox(sMessage)
end

--@brief	领取所有邮件里的物品（MAIL_GetMailReward = 12）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMail:send_MAIL_GetAllMailReward_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMail:send_MAIL_GetMailReward_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MAIL, Protocol.MAIL_GetAllMailReward, nflag, sMessage)
    WndMail:closeLoading()
    MsgBoxManager:showTipBox(sMessage)
end

--@brief	领取所有邮件里的物品（MAIL_GetMailReward = 12）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMail:send_MAIL_MallMailOperate_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMail:send_MAIL_MallMailOperate_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MAIL, Protocol.MAIL_MallMailOperate, nflag, sMessage)
    WndMail:closeLoading()
    MsgBoxManager:showTipBox(sMessage)
end
