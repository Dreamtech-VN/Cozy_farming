--ProtocolProcessorWndMaster.lua
--@brief	背包模块协议
--@date  	2014/02/18
--@author 	xiaoyu_wu
--@note 	背包模块所使用协议


ProtocolProcessorWndMaster = ProtocolProcessorBase:new()

-------------------------------------公有方法模块--------------------------------------

--@brief	注册协议组所有协议
function ProtocolProcessorWndMaster:regAll()
	WZLog("ProtocolProcessorWndMaster:regAll")
--@brief	获取师徒圣殿（MENTORING_GetTemple = 1）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetTemple, "ProtocolProcessorWndMaster:send_MENTORING_GetTemple_ErrorProcess", "is" )
--@brief	师徒大厅（MENTORING_GetMentoring = 3）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetMentoring, "ProtocolProcessorWndMaster:send_MENTORING_GetMentoring_ErrorProcess", "is" )
--@brief	我的师博（MENTORING_GetMyMaster = 5）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetMyMaster, "ProtocolProcessorWndMaster:send_MENTORING_GetMyMaster_ErrorProcess", "is" )
--@brief	我的徒弟（MENTORING_GetMyPupils = 7）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetMyPupils, "ProtocolProcessorWndMaster:send_MENTORING_GetMyPupils_ErrorProcess", "is" )
--@brief	拜师（MENTORING_Baishi = 9）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_Baishi, "ProtocolProcessorWndMaster:send_MENTORING_Baishi_ErrorProcess", "is" )
--@brief	收徒（MENTORING_Shoutu = 11）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_Shoutu, "ProtocolProcessorWndMaster:send_MENTORING_Shoutu_ErrorProcess", "is" )
--@brief	获取消息列表（MENTORING_GetMentoringMessage = 13）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetMentoringMessage, "ProtocolProcessorWndMaster:send_MENTORING_GetMentoringMessage_ErrorProcess", "is" )
--@brief	处理拜师/收徒消息（MENTORING_Processing = 16）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_Processing, "ProtocolProcessorWndMaster:send_MENTORING_Processing_ErrorProcess", "is" )
--@brief	解除关系（MENTORING_Disassociate = 18）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_Disassociate, "ProtocolProcessorWndMaster:send_MENTORING_Disassociate_ErrorProcess", "is" )
--@brief	获取任务信息（MENTORING_GetTask = 23）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetTask, "ProtocolProcessorWndMaster:send_MENTORING_GetTask_ErrorProcess", "is" )
--@brief	领取任务奖励（MENTORING_GetReward = 25）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetReward, "ProtocolProcessorWndMaster:send_MENTORING_GetReward_ErrorProcess", "is" )
--@brief	孝敬（MENTORING_XiaoJing = 26）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_XiaoJing, "ProtocolProcessorWndMaster:send_MENTORING_XiaoJing_ErrorProcess", "is" )
--@brief	孝敬（MENTORING_ShouYe = 28）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_ShouYe, "ProtocolProcessorWndMaster:send_MENTORING_ShouYe_ErrorProcess", "is" )

--@brief	获取师徒圣殿（MENTORING_GetTempleOk = 2）
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetTempleOk, "ProtocolProcessorWndMaster:parse_MENTORING_GetTempleOk", "biiiiibiii")
--@brief	师徒大厅（MENTORING_GetMentoringOk = 4）
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetMentoringOk, "ProtocolProcessorWndMaster:parse_MENTORING_GetMentoringOk", "vivsvivsvivivivivivsvbvivivsvivivi")
--@brief	我的师博（MENTORING_GetMyMaster = 6）
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetMyMasterOk, "ProtocolProcessorWndMaster:parse_MENTORING_GetMyMaster", "vivivsviviviviviblivivivsviviivi")
--@brief	我的徒弟（MENTORING_GetMyPupils = 8）
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetMyPupilsOk, "ProtocolProcessorWndMaster:parse_MENTORING_GetMyPupils", "vivivsvivivivivivbvlvivivsvivivi")
--@brief	拜师（MENTORING_BaishiOk = 10）
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_BaishiOk, "ProtocolProcessorWndMaster:parse_MENTORING_BaishiOk", "blbb")
--@brief	收徒（MENTORING_ShoutuOk = 12）
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_ShoutuOk, "ProtocolProcessorWndMaster:parse_MENTORING_ShoutuOk", "blbb")
--@brief	申请列表（MENTORING_ApplerList = 14）
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_ApplerList, "ProtocolProcessorWndMaster:parse_MENTORING_ApplerList", "vivivivsvivi")
--@brief	师徒消息（MENTORING_LogList = 15）
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_LogList, "ProtocolProcessorWndMaster:parse_MENTORING_LogList", "vsvlvivivivivi")
--self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_LogList, "ProtocolProcessorWndMaster:parse_MENTORING_LogList", "vsvl")
--@brief	处理拜师/收徒消息（MENTORING_ProcessingOk = 17）
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_ProcessingOk, "ProtocolProcessorWndMaster:parse_MENTORING_ProcessingOk", "ii")
--@brief	解除关系（MENTORING_DisassociateOk = 19）
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_DisassociateOk, "ProtocolProcessorWndMaster:parse_MENTORING_DisassociateOk", "")
--@brief	师德升级（MENTORING_MoralityUpLevel = 20）
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_MoralityUpLevel, "ProtocolProcessorWndMaster:parse_MENTORING_MoralityUpLevel", "i")
--@brief	拜师消息弹窗（MENTORING_BaishiPopMsg = 21）
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_BaishiPopMsg, "ProtocolProcessorWndMaster:parse_MENTORING_BaishiPopMsg", "issiiiivi")
--@brief	收徒消息弹窗（MENTORING_ShoutuPopMsg = 22）
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_ShoutuPopMsg, "ProtocolProcessorWndMaster:parse_MENTORING_ShoutuPopMsg", "issiiiivi")
--@brief	获取任务信息（MENTORING_GetTaskOk = 24）
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetTaskOk, "ProtocolProcessorWndMaster:parse_MENTORING_GetTaskOk", "viviviiivi")
--@brief	获取任务信息（MENTORING_XiaoJingOk = 27）
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_XiaoJingOk, "ProtocolProcessorWndMaster:parse_MENTORING_XiaoJingOk", "viviviiivi")
--@brief	获取任务信息（MENTORING_ShouYeOk = 29）
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_ShouYeOk, "ProtocolProcessorWndMaster:parse_MENTORING_ShouYeOk", "viviviiivi")
end

--@brief	反注册协议组所有协议
function ProtocolProcessorWndMaster:unregAll()
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief	获取师徒圣殿（MENTORING_GetTemple = 1）
function ProtocolProcessorWndMaster:send_MENTORING_GetTemple( )
	WZLog("send_MENTORING_GetTemple")
	local sender = Protocol:getSender( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetTemple )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	师徒大厅（MENTORING_GetMentoring = 3）
function ProtocolProcessorWndMaster:send_MENTORING_GetMentoring(id )
	WZLog("send_MENTORING_GetMentoring")
	local sender = Protocol:getSender( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetMentoring )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( id )	-- 玩家ID，没有填-1
	SendProtocol(sender,false) --true:showLoading
end

--@brief	我的师博（MENTORING_GetMyMaster = 5）
function ProtocolProcessorWndMaster:send_MENTORING_GetMyMaster( )
	WZLog("send_MENTORING_GetMyMaster")
	local sender = Protocol:getSender( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetMyMaster )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	我的徒弟（MENTORING_GetMyPupils = 7）
function ProtocolProcessorWndMaster:send_MENTORING_GetMyPupils( )
	WZLog("send_MENTORING_GetMyPupils")
	local sender = Protocol:getSender( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetMyPupils )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	拜师（MENTORING_Baishi = 9）
function ProtocolProcessorWndMaster:send_MENTORING_Baishi(id, message )
	WZLog("send_MENTORING_Baishi")
	local sender = Protocol:getSender( Protocol.MAIN_MENTORING, Protocol.MENTORING_Baishi )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( id )	-- 师博ID
	sender:writeString( message )	-- 独白
	SendProtocol(sender,false) --true:showLoading
end

--@brief	收徒（MENTORING_Shoutu = 11）
function ProtocolProcessorWndMaster:send_MENTORING_Shoutu(id, message )
	WZLog("send_MENTORING_Shoutu")
	local sender = Protocol:getSender( Protocol.MAIN_MENTORING, Protocol.MENTORING_Shoutu )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( id )	-- 徒弟ID
	sender:writeString( message )	-- 独白
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取消息列表（MENTORING_GetMentoringMessage = 13）
function ProtocolProcessorWndMaster:send_MENTORING_GetMentoringMessage( )
	WZLog("send_MENTORING_GetMentoringMessage")
	local sender = Protocol:getSender( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetMentoringMessage )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	处理拜师/收徒消息（MENTORING_Processing = 16）
function ProtocolProcessorWndMaster:send_MENTORING_Processing(id, action )
	WZLog("send_MENTORING_Processing")
	local sender = Protocol:getSender( Protocol.MAIN_MENTORING, Protocol.MENTORING_Processing )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( id )	-- 玩家ID
	sender:writeInt( action )	-- 0拒绝1接受
	SendProtocol(sender,false) --true:showLoading
end

--@brief	解除关系（MENTORING_Disassociate = 18）
function ProtocolProcessorWndMaster:send_MENTORING_Disassociate(id, mode )
	WZLog("send_MENTORING_Disassociate")
	local sender = Protocol:getSender( Protocol.MAIN_MENTORING, Protocol.MENTORING_Disassociate )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( id )	-- 玩家ID
	sender:writeInt( mode )	-- 0免费,1钻石
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取任务信息（MENTORING_GetTask = 23）
function ProtocolProcessorWndMaster:send_MENTORING_GetTask( )
	WZLog("send_MENTORING_GetTask")
	local sender = Protocol:getSender( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetTask )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	领取任务奖励（MENTORING_GetReward = 25）
function ProtocolProcessorWndMaster:send_MENTORING_GetReward(taskId )
	WZLog("send_MENTORING_GetReward")
	local sender = Protocol:getSender( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetReward )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( taskId )	-- 获取奖励的任务Id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	孝敬（MENTORING_XiaoJing = 26）
function ProtocolProcessorWndMaster:send_MENTORING_XiaoJing( )
	WZLog("send_MENTORING_XiaoJing")
	local sender = Protocol:getSender( Protocol.MAIN_MENTORING, Protocol.MENTORING_XiaoJing )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	授业（MENTORING_ShouYe = 28）
function ProtocolProcessorWndMaster:send_MENTORING_ShouYe( )
	WZLog("send_MENTORING_ShouYe")
	local sender = Protocol:getSender( Protocol.MAIN_MENTORING, Protocol.MENTORING_ShouYe )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

-------------------------------------服务器到客户端协议回调方法模块--------------------------------------
--@brief	获取师徒圣殿（MENTORING_GetTempleOk = 2）
function ProtocolProcessorWndMaster:parse_MENTORING_GetTempleOk(hasMaster, pupil, moralityLevel, moralityExp, baishiLevel, addVigor, message, num, lastTime, taskfinish)
	-- hasMaster : true有师博
	-- pupil : 徒弟数
	-- moralityLevel : 师德等级起始1
	-- moralityExp : 师德值
	WZLog("ProtocolProcessorWndMaster:parse_MENTORING_GetTempleOk",message, taskfinish)
	CacheCenter:setMasterInfo(hasMaster, pupil, moralityLevel, moralityExp, baishiLevel, addVigor, message, num, lastTime, taskfinish)
end

--@brief	师徒大厅（MENTORING_GetMentoringOk = 4）
function ProtocolProcessorWndMaster:parse_MENTORING_GetMentoringOk(id, title, level, name, fighting, headId, faceId, bodyId, wingId, pet, isOnline, sex, itemId, extraInfo, headColor, bodyColor, vipLevel)
	-- id : 玩家ID
	-- title : 称号
	-- level : 级别
	-- name : 名称
	-- fighting : 战力
	-- headId : 头ID
	-- faceId : 脸ID
	-- bodyId : 身ID
	-- wingId : 翅膀ID
	-- pet : 宠物动画
	-- isOnline : true在线
	WZLog("ProtocolProcessorWndMaster:parse_MENTORING_GetMentoringOk",Serialize(VectorToTable(headColor)),Serialize(VectorToTable(name)),Serialize(VectorToTable(headId)))
	WndMasterHall:setMasterHall(VectorToTable(id), VectorToTable(title), VectorToTable(level), VectorToTable(name), VectorToTable(fighting), VectorToTable(headId), VectorToTable(faceId), VectorToTable(bodyId), VectorToTable(wingId), VectorToTable(pet), VectorToTable(isOnline), VectorToTable(sex), VectorToTable(itemId), VectorToTable(extraInfo), VectorToTable(headColor), VectorToTable(bodyColor), VectorToTable(vipLevel))
end

--@brief	我的师博（MENTORING_GetMyMaster = 6）
function ProtocolProcessorWndMaster:parse_MENTORING_GetMyMaster(id, level, name, fighting, headId, faceId, bodyId, wingId, isOnline, loginTime, moralityLevel, sex, itemId, extraInfo, headColor, bodyColor, graduationNum, vipLevel)
	-- id : 玩家ID
	-- level : 级别
	-- name : 名称
	-- fighting : 战力
	-- headId : 头ID
	-- faceId : 脸ID
	-- bodyId : 身ID
	-- wingId : 翅膀ID
	-- isOnline : true在线
	-- loginTime : 玩家登陆时间
	WZLog("ProtocolProcessorWndMaster:parse_MENTORING_GetMyMaster")
	WndMasterMember:setMyMaster(VectorToTable(id), VectorToTable(level), VectorToTable(name), VectorToTable(fighting), VectorToTable(headId), VectorToTable(faceId), VectorToTable(bodyId), VectorToTable(wingId), isOnline, loginTime, moralityLevel, VectorToTable(sex), VectorToTable(itemId), VectorToTable(extraInfo), VectorToTable(headColor), VectorToTable(bodyColor), graduationNum, VectorToTable(vipLevel))
end

--@brief	我的徒弟（MENTORING_GetMyPupils = 8）
function ProtocolProcessorWndMaster:parse_MENTORING_GetMyPupils(id, level, name, fighting, headId, faceId, bodyId, wingId, isOnline, loginTime, sex, itemId, extraInfo, headColor, bodyColor, vipLevel)
	-- id : 玩家ID
	-- level : 级别
	-- name : 名称
	-- fighting : 战力
	-- headId : 头ID
	-- faceId : 脸ID
	-- bodyId : 身ID
	-- wingId : 翅膀ID
	-- isOnline : true在线
	-- loginTime : 玩家登陆时间
	WZLog("ProtocolProcessorWndMaster:parse_MENTORING_GetMyPupils")
	WndMasterMember:setMyPupils(VectorToTable(id), VectorToTable(level), VectorToTable(name), VectorToTable(fighting), VectorToTable(headId), VectorToTable(faceId), VectorToTable(bodyId), VectorToTable(wingId), VectorToTable(isOnline), VectorToTable(loginTime), VectorToTable(sex), VectorToTable(itemId), VectorToTable(extraInfo), VectorToTable(headColor), VectorToTable(bodyColor), VectorToTable(vipLevel))
end

--@brief	拜师（MENTORING_BaishiOk = 10）
function ProtocolProcessorWndMaster:parse_MENTORING_BaishiOk(result, cdtime, isFull, applied)
	-- result : true成功
	-- cdtime : 正数为解除限制拜师时间；负数为对方解除限收徒时间
	-- isFull : true对方收徒人满了
	-- applied : true已拜过
	WZLog("ProtocolProcessorWndMaster:parse_MENTORING_BaishiOk",Serialize(WndMasterTip.m_tChatInfo))
	if applied == true then
		MsgBoxManager:showTipBox(LocalStrings.MASTERINFO50) 
		return
	end
	if result == true then
		MsgBoxManager:showTipBox(LocalStrings.MASTERINFO51) 
		--发送私聊
		if WndMasterMember.m_tSendMsg == nil then WndMasterMember.m_tSendMsg = {} end
		local chatInfo = WndMasterTip.m_tChatInfo
		if WndMasterTip:valInTable(WndMasterTip.m_tCurID, WndMasterMember.m_tSendMsg) == false then
			WndChat:sendChat(CHANNEL_WHISPER,chatInfo.chatMsg,chatInfo.receivePlayerId,chatInfo.receivePlayerName,chatInfo.receivePlayerSex,chatInfo.receivePlayerLevel,chatInfo.receivePlayerVipLevel,chatInfo.receivePlayerHead,chatInfo.receivePlayerFace,chatInfo.receivePlayerHeadColor)
			table.insert(WndMasterMember.m_tSendMsg,WndMasterTip.m_tCurID)
		end
	elseif cdtime > 0 then
		local hours = math.ceil((cdtime - os.time())/3600)
		MsgBoxManager:showTipBox(string.format(LocalStrings.MASTERINFO52,hours)) 
	elseif cdtime < 0 then
		local hours = math.ceil(((0-cdtime) - os.time())/3600)
		MsgBoxManager:showTipBox(string.format(LocalStrings.MASTERINFO53,hours)) 
	elseif isFull == true then
		MsgBoxManager:showTipBox(LocalStrings.MASTERINFO54) 
	end
end

--@brief	收徒（MENTORING_ShoutuOk = 12）
function ProtocolProcessorWndMaster:parse_MENTORING_ShoutuOk(result, cdtime, hasMaster, applied)
	-- result : true成功
	-- cdtime : 正数为解除限制收徒时间；负数为对方解除限拜师时间
	-- hasMaster : true对方已有师博了
	-- applied : true已收过
	WZLog("ProtocolProcessorWndMaster:parse_MENTORING_ShoutuOk",Serialize(WndMasterTip.m_tChatInfo))
	if applied == true then
		MsgBoxManager:showTipBox(LocalStrings.MASTERINFO45) 
		return
	end
	if result == true then
		MsgBoxManager:showTipBox(LocalStrings.MASTERINFO46) 
		--发送私聊
		if WndMasterMember.m_tSendMsg == nil then WndMasterMember.m_tSendMsg = {} end
		local chatInfo = WndMasterTip.m_tChatInfo
		if WndMasterTip:valInTable(WndMasterTip.m_tCurID, WndMasterMember.m_tSendMsg) == false then
			WndChat:sendChat(CHANNEL_WHISPER,chatInfo.chatMsg,chatInfo.receivePlayerId,chatInfo.receivePlayerName,chatInfo.receivePlayerSex,chatInfo.receivePlayerLevel,chatInfo.receivePlayerVipLevel,chatInfo.receivePlayerHead,chatInfo.receivePlayerFace,chatInfo.receivePlayerHeadColor)
			table.insert(WndMasterMember.m_tSendMsg,WndMasterTip.m_tCurID)
		end
	elseif cdtime > 0 then
		local hours = math.ceil((cdtime - os.time())/3600)
		MsgBoxManager:showTipBox(string.format(LocalStrings.MASTERINFO47,hours)) 
	elseif cdtime < 0 then
		local hours = math.ceil(((0-cdtime) - os.time())/3600)
		MsgBoxManager:showTipBox(string.format(LocalStrings.MASTERINFO48,hours)) 
	elseif isFull == true then
		MsgBoxManager:showTipBox(LocalStrings.MASTERINFO49) 
	end
end

--@brief	申请列表（MENTORING_ApplerList = 14）
function ProtocolProcessorWndMaster:parse_MENTORING_ApplerList(playerId, headId, faceId, message, sex, headColor)
	-- playerId : 玩家ID
	-- headId : 头ID
	-- faceId : 脸ID
	-- message : 独白
	WZLog("ProtocolProcessorWndMaster:parse_MENTORING_ApplerList",Serialize(VectorToTable(headColor)))
	WndMasterLog:setMasterLog1(VectorToTable(playerId), VectorToTable(headId), VectorToTable(faceId), VectorToTable(message), VectorToTable(sex), VectorToTable(headColor))
end

--@brief	师徒消息（MENTORING_LogList = 15）
function ProtocolProcessorWndMaster:parse_MENTORING_LogList(message, createTime, playerId, headId, faceId, sex, headColor)
	-- message : 消息
	-- createTime : 创建时间
	WZLog("ProtocolProcessorWndMaster:parse_MENTORING_LogList",Serialize(VectorToTable(playerId)),Serialize(VectorToTable(headId)),Serialize(VectorToTable(faceId)),Serialize(VectorToTable(sex)))
	WndMasterLog:setMasterLog2(VectorToTable(message), VectorToTable(createTime), VectorToTable(playerId), VectorToTable(headId), VectorToTable(faceId), VectorToTable(sex), VectorToTable(headColor))
end

--@brief	处理拜师/收徒消息（MENTORING_ProcessingOk = 17）
function ProtocolProcessorWndMaster:parse_MENTORING_ProcessingOk(result, action)
	-- result : 0成功。1对方有师博，2对方徒弟数满了
	-- action : 0拒绝1接受
	WZLog("ProtocolProcessorWndMaster:parse_MENTORING_ProcessingOk")
	--在战斗中直接返回
	if GlobalGame.g_bIfInBattle == true then return end    

	if result == 0 then
		MsgBoxManager:showTipBox(LocalStrings.MASTERINFO55) 
	elseif result == 1 then
		MsgBoxManager:showTipBox(LocalStrings.MASTERINFO56) 
	elseif result == 2 then
		MsgBoxManager:showTipBox(LocalStrings.MASTERINFO57) 
	end
	--修改私聊中的数据
	CacheCenter:dealwithMasterMessageAfterOperate()
	WndChat:dealwithMsgAfterOperate()
	if WndMaster and WndMaster.m_root ~= nil then
		--获得消息列表
		ProtocolProcessorWndMaster:send_MENTORING_GetMentoringMessage()
		--获取师徒信息 
		ProtocolProcessorWndMaster:send_MENTORING_GetTemple()
	end
end

--@brief	解除关系（MENTORING_DisassociateOk = 19）
function ProtocolProcessorWndMaster:parse_MENTORING_DisassociateOk()
	WZLog("ProtocolProcessorWndMaster:parse_MENTORING_DisassociateOk")
	MsgBoxManager:showTipBox(LocalStrings.MASTERINFO58) 
	local playerInfo = CacheCenter:getPlayerInfo()
	local masterInfo = CacheCenter:getMasterInfo()
	if playerInfo == nil or masterInfo == nil then return end
	masterInfo.hasMaster = false
	if playerInfo.level < MASTERLEVEL then
		--我的等级小于等于35,返回师徒大厅
		--ProtocolProcessorWndMaster:send_MENTORING_GetMyMaster()
		if WndMaster then
			WndMaster:onCheck1()
		end
	else
		--我的等级大于35,获得我的徒弟列表
		ProtocolProcessorWndMaster:send_MENTORING_GetMyPupils()
		--徒弟数减一
		--masterInfo.pupil = masterInfo.pupil - 1
	end
end

--@brief	师德升级（MENTORING_MoralityUpLevel = 20）
function ProtocolProcessorWndMaster:parse_MENTORING_MoralityUpLevel(level)
	-- level : 最新等级
	WZLog("ProtocolProcessorWndMaster:parse_MENTORING_MoralityUpLevel",level)
	if GlobalGame.g_bIfInBattle == false then
		local tData = {level=level}
		WndMasterTip:showByType(tData,4)
	end
end

--@brief	拜师消息弹窗（MENTORING_BaishiPopMsg = 21）
function ProtocolProcessorWndMaster:parse_MENTORING_BaishiPopMsg(playerId, playerName, message, level, headId, faceId, sex, headColor)
	-- playerId : 徒弟玩家ID
	-- playerName : 徒弟名称
	-- message : 消息
	-- level : 徒弟等级
	-- headId : 徒弟头
	-- faceId : 徒弟脸
	-- sex : 徒弟性别
	WZLog("ProtocolProcessorWndMaster:parse_MENTORING_BaishiPopMsg")
    if WindowManager:getTeachShelterLayer() or WndTeachTalk.m_root then return end
	--if GlobalGame.g_bIfInBattle == false then
	--	local tData = {id=playerId,message=message,name=playerName,level=level,headId=headId,faceId=faceId,sex=sex}
	--	WndMasterTip:receivedRequest(tData,2)
	--end
end

--@brief	收徒消息弹窗（MENTORING_ShoutuPopMsg = 22）
function ProtocolProcessorWndMaster:parse_MENTORING_ShoutuPopMsg(playerId, playerName, message, level, headId, faceId, sex, headColor)
	-- playerId : 师傅玩家ID
	-- playerName : 师傅名称
	-- message : 消息
	-- level : 师博等级
	-- headId : 师博头
	-- faceId : 师博脸
	-- sex : 师博性别
	WZLog("ProtocolProcessorWndMaster:parse_MENTORING_ShoutuPopMsg")
    if WindowManager:getTeachShelterLayer() or WndTeachTalk.m_root then return end
	--if GlobalGame.g_bIfInBattle == false then
	--	local tData = {id=playerId,message=message,name=playerName,level=level,headId=headId,faceId=faceId,sex=sex}
	--	WndMasterTip:receivedRequest(tData,1)
	--end
end

--@brief	获取任务信息（MENTORING_GetTaskOk = 24）
function ProtocolProcessorWndMaster:parse_MENTORING_GetTaskOk(taskId, progress, giveTaskId, num, lastTime, alltaskId)
	-- taskId : 任务Id
	-- progress : 任务进度
	-- giveTaskId : 获取奖励的任务Id
	-- num : 孝敬或授业次数
	-- lastTime : 上一次孝敬或授业的时间（秒）
	WZLog("ProtocolProcessorWndMaster:parse_MENTORING_GetTaskOk")
	WndMasterTask:setData( VectorToTable(taskId), VectorToTable(progress), VectorToTable(giveTaskId), num, lastTime, VectorToTable(alltaskId))
	ProtocolProcessorWndMaster:send_MENTORING_GetTemple()
	local masterInfo = CacheCenter:getMasterInfo()
	if masterInfo == nil then return end
	masterInfo.lastTime = lastTime
	masterInfo.honorTime = num
end

--@brief	孝敬完成（MENTORING_XiaoJingOk = 27）
function ProtocolProcessorWndMaster:parse_MENTORING_XiaoJingOk(taskId, progress, giveTaskId, num, lastTime, alltaskId)
	-- taskId : 任务Id
	-- progress : 任务进度
	-- giveTaskId : 获取奖励的任务Id
	-- num : 孝敬或授业次数
	-- lastTime : 上一次孝敬或授业的时间（秒）
	-- itemId : 孝敬奖励Id
	-- itemNum : 孝敬奖励数量
	WZLog("ProtocolProcessorWndMaster:parse_MENTORING_XiaoJingOk")
	MsgBoxManager:showTipBox(LocalStrings.MASTERINFO68)
	ProtocolProcessorWndMaster:send_MENTORING_GetTemple()
	local masterInfo = CacheCenter:getMasterInfo()
	if masterInfo == nil then return end
	masterInfo.lastTime = lastTime
	masterInfo.honorTime = num
end

--@brief	授业完成（MENTORING_ShouYeOk = 29）
function ProtocolProcessorWndMaster:parse_MENTORING_ShouYeOk(taskId, progress, giveTaskId, num, lastTime, alltaskId)
	-- taskId : 任务Id
	-- progress : 任务进度
	-- giveTaskId : 获取奖励的任务Id
	-- num : 孝敬或授业次数
	-- lastTime : 上一次孝敬或授业的时间（秒）
	WZLog("ProtocolProcessorWndMaster:parse_MENTORING_ShouYeOk")
	WndMasterImpart:setData( VectorToTable(taskId), VectorToTable(progress), VectorToTable(giveTaskId), num, lastTime, VectorToTable(alltaskId))
	ProtocolProcessorWndMaster:send_MENTORING_GetTemple()
end
-------------------------------------协议错误处理方法模块--------------------------------------
--@brief	获取师徒圣殿（MENTORING_GetTemple = 1）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMaster:send_MENTORING_GetTemple_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMaster:send_MENTORING_GetTemple_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MENTORING, Protocol.MENTORING_GetTemple, nflag, sMessage)
end

--@brief	师徒大厅（MENTORING_GetMentoring = 3）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMaster:send_MENTORING_GetMentoring_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMaster:send_MENTORING_GetMentoring_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MENTORING, Protocol.MENTORING_GetMentoring, nflag, sMessage)
end

--@brief	我的师博（MENTORING_GetMyMaster = 5）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMaster:send_MENTORING_GetMyMaster_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMaster:send_MENTORING_GetMyMaster_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MENTORING, Protocol.MENTORING_GetMyMaster, nflag, sMessage)
end

--@brief	我的徒弟（MENTORING_GetMyPupils = 7）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMaster:send_MENTORING_GetMyPupils_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMaster:send_MENTORING_GetMyPupils_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MENTORING, Protocol.MENTORING_GetMyPupils, nflag, sMessage)
end

--@brief	拜师（MENTORING_Baishi = 9）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMaster:send_MENTORING_Baishi_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMaster:send_MENTORING_Baishi_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MENTORING, Protocol.MENTORING_Baishi, nflag, sMessage)
end

--@brief	收徒（MENTORING_Shoutu = 11）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMaster:send_MENTORING_Shoutu_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMaster:send_MENTORING_Shoutu_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MENTORING, Protocol.MENTORING_Shoutu, nflag, sMessage)
end

--@brief	获取消息列表（MENTORING_GetMentoringMessage = 13）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMaster:send_MENTORING_GetMentoringMessage_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMaster:send_MENTORING_GetMentoringMessage_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MENTORING, Protocol.MENTORING_GetMentoringMessage, nflag, sMessage)
end

--@brief	处理拜师/收徒消息（MENTORING_Processing = 16）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMaster:send_MENTORING_Processing_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMaster:send_MENTORING_Processing_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MENTORING, Protocol.MENTORING_Processing, nflag, sMessage)
end

--@brief	解除关系（MENTORING_Disassociate = 18）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMaster:send_MENTORING_Disassociate_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMaster:send_MENTORING_Disassociate_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MENTORING, Protocol.MENTORING_Disassociate, nflag, sMessage)
end

--@brief	获取任务信息（MENTORING_GetTask = 23）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMaster:send_MENTORING_GetTask_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMaster:send_MENTORING_GetTask_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MENTORING, Protocol.MENTORING_GetTask, nflag, sMessage)
end

--@brief	领取任务奖励（MENTORING_GetReward = 25）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMaster:send_MENTORING_GetReward_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMaster:send_MENTORING_GetReward_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MENTORING, Protocol.MENTORING_GetReward, nflag, sMessage)
end

--@brief	孝敬（MENTORING_XiaoJing = 26）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMaster:send_MENTORING_XiaoJing_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMaster:send_MENTORING_XiaoJing_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MENTORING, Protocol.MENTORING_XiaoJing, nflag, sMessage)
end

--@brief	孝敬（MENTORING_ShouYe = 28）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMaster:send_MENTORING_ShouYe_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMaster:send_MENTORING_ShouYe_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MENTORING, Protocol.MENTORING_ShouYe, nflag, sMessage)
end
