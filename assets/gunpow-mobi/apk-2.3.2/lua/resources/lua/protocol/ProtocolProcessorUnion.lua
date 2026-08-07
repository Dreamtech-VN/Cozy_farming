--ProtocolProcessorUnion.lua
--@brief	聯盟相关协议
--@date  	2013/12/12
--@author 	xtx
--@note 	聯盟相关协议


ProtocolProcessorUnion = ProtocolProcessorBase:new()

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorUnion:regAll()
	--@brief	获取联盟列表（LEAGUE_GetLeagueList = 1）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_LEAGUE, Protocol.LEAGUE_GetLeagueList, "ProtocolProcessorUnion:send_LEAGUE_GetLeagueList_ErrorProcess", "is")
	--@brief	创建联盟（LEAGUE_CreateLeague = 3）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_LEAGUE, Protocol.LEAGUE_CreateLeague, "ProtocolProcessorUnion:send_LEAGUE_CreateLeague_ErrorProcess", "is")
	--@brief	获取联盟数据信息（LEAGUE_GetLeagueInfo = 5）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_LEAGUE, Protocol.LEAGUE_GetLeagueInfo, "ProtocolProcessorUnion:send_LEAGUE_GetLeagueInfo_ErrorProcess", "is")
	--@brief	修改联盟设置（LEAGUE_Setting = 7）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_LEAGUE, Protocol.LEAGUE_Setting, "ProtocolProcessorUnion:send_LEAGUE_Setting_ErrorProcess", "is")
	--@brief	申请加入联盟（LEAGUE_ApplyLeague = 9）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_LEAGUE, Protocol.LEAGUE_ApplyLeague, "ProtocolProcessorUnion:send_LEAGUE_ApplyLeague_ErrorProcess", "is")
	--@brief	获取申请入盟列表（LEAGUE_GetApplyerList = 11）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_LEAGUE, Protocol.LEAGUE_GetApplyerList, "ProtocolProcessorUnion:send_LEAGUE_GetApplyerList_ErrorProcess", "is")
	--@brief	审批入盟申请（LEAGUE_Approval = 13）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_LEAGUE, Protocol.LEAGUE_Approval, "ProtocolProcessorUnion:send_LEAGUE_Approval_ErrorProcess", "is")
	--@brief	退出联盟（LEAGUE_Resignations = 15）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_LEAGUE, Protocol.LEAGUE_Resignations, "ProtocolProcessorUnion:send_LEAGUE_Resignations_ErrorProcess", "is")
	--@brief	任命联盟职位（LEAGUE_ChangePost = 17）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_LEAGUE, Protocol.LEAGUE_ChangePost, "ProtocolProcessorUnion:send_LEAGUE_ChangePost_ErrorProcess", "is")
	--@brief	开除联盟成员（LEAGUE_ExpelMember = 19）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_LEAGUE, Protocol.LEAGUE_ExpelMember, "ProtocolProcessorUnion:send_LEAGUE_ExpelMember_ErrorProcess", "is")
	--@brief	获取联盟操作日志（LEAGUE_GetOperationLog = 27）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_LEAGUE, Protocol.LEAGUE_GetOperationLog, "ProtocolProcessorUnion:send_LEAGUE_GetOperationLog_ErrorProcess", "is")
	--@brief	盟主让位（LEAGUE_Abdicate = 29）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_LEAGUE, Protocol.LEAGUE_Abdicate, "ProtocolProcessorUnion:send_LEAGUE_Abdicate_ErrorProcess", "is")
	--@brief	批量任命成员为指定职位（LEAGUE_ChangePostBatch = 31）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_LEAGUE, Protocol.LEAGUE_ChangePostBatch, "ProtocolProcessorUnion:send_LEAGUE_ChangePostBatch_ErrorProcess", "is")
	--@brief	邀请好友加入联盟（LEAGUE_Invite = 33）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_LEAGUE, Protocol.LEAGUE_Invite, "ProtocolProcessorUnion:send_LEAGUE_Invite_ErrorProcess", "is")
	--@brief	回复入盟邀请（LEAGUE_ResponseInvite = 36）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_LEAGUE, Protocol.LEAGUE_ResponseInvite, "ProtocolProcessorUnion:send_LEAGUE_ResponseInvite_ErrorProcess", "is")
	
	--@brief	获取联盟列表OK（LEAGUE_GetLeagueListOk = 2）
	self:regProtocolCallbackFunction( Protocol.MAIN_LEAGUE, Protocol.LEAGUE_GetLeagueListOk, "ProtocolProcessorUnion:parse_LEAGUE_GetLeagueListOk", "vivsvivsvivivivivivi")
	--@brief	协议号名字（LEAGUE_CreateLeagueOk = 4）
	self:regProtocolCallbackFunction( Protocol.MAIN_LEAGUE, Protocol.LEAGUE_CreateLeagueOk, "ProtocolProcessorUnion:parse_LEAGUE_CreateLeagueOk", "i")
	--@brief	获取联盟数据信息OK（LEAGUE_GetLeagueInfoOk = 6）
	self:regProtocolCallbackFunction( Protocol.MAIN_LEAGUE, Protocol.LEAGUE_GetLeagueInfoOk, "ProtocolProcessorUnion:parse_LEAGUE_GetLeagueInfoOk", "isiiiiiiiiivivivivivivsvivivivivivivivivi")
	--@brief	修改联盟设置OK（LEAGUE_SettingOk = 8）
	self:regProtocolCallbackFunction( Protocol.MAIN_LEAGUE, Protocol.LEAGUE_SettingOk, "ProtocolProcessorUnion:parse_LEAGUE_SettingOk", "iiii")
	--@brief	申请加入联盟OK（LEAGUE_ApplyLeagueOk = 10）
	self:regProtocolCallbackFunction( Protocol.MAIN_LEAGUE, Protocol.LEAGUE_ApplyLeagueOk, "ProtocolProcessorUnion:parse_LEAGUE_ApplyLeagueOk", "i")
	--@brief	获取申请入盟列表OK（LEAGUE_GetApplyerListOk = 12）
	self:regProtocolCallbackFunction( Protocol.MAIN_LEAGUE, Protocol.LEAGUE_GetApplyerListOk, "ProtocolProcessorUnion:parse_LEAGUE_GetApplyerListOk", "vivsvivivivivtvivivi")
	--@brief	审批入盟申请OK（LEAGUE_ApprovalOk = 14）
	self:regProtocolCallbackFunction( Protocol.MAIN_LEAGUE, Protocol.LEAGUE_ApprovalOk, "ProtocolProcessorUnion:parse_LEAGUE_ApprovalOk", "ivivivsvivivivivtvivivi")
	--@brief	退出联盟OK（LEAGUE_ResignationsOk = 16）
	self:regProtocolCallbackFunction( Protocol.MAIN_LEAGUE, Protocol.LEAGUE_ResignationsOk, "ProtocolProcessorUnion:parse_LEAGUE_ResignationsOk", "")
	--@brief	任命联盟职位OK（LEAGUE_ChangePostOk = 18）
	self:regProtocolCallbackFunction( Protocol.MAIN_LEAGUE, Protocol.LEAGUE_ChangePostOk, "ProtocolProcessorUnion:parse_LEAGUE_ChangePostOk", "i")
	--@brief	开除联盟成员OK（LEAGUE_ExpelMemberOk = 20）
	self:regProtocolCallbackFunction( Protocol.MAIN_LEAGUE, Protocol.LEAGUE_ExpelMemberOk, "ProtocolProcessorUnion:parse_LEAGUE_ExpelMemberOk", "")
	--@brief	获取联盟操作日志（LEAGUE_GetOperationLogOk = 28）
	self:regProtocolCallbackFunction( Protocol.MAIN_LEAGUE, Protocol.LEAGUE_GetOperationLogOk, "ProtocolProcessorUnion:parse_LEAGUE_GetOperationLogOk", "vivivivivsvsvivi")
	--@brief	盟主让位OK（LEAGUE_AbdicateOk = 30）
	self:regProtocolCallbackFunction( Protocol.MAIN_LEAGUE, Protocol.LEAGUE_AbdicateOk, "ProtocolProcessorUnion:parse_LEAGUE_AbdicateOk", "")
	--@brief	批量任命成员为指定职位OK（LEAGUE_ChangePostBatchOk = 32）
	self:regProtocolCallbackFunction( Protocol.MAIN_LEAGUE, Protocol.LEAGUE_ChangePostBatchOk, "ProtocolProcessorUnion:parse_LEAGUE_ChangePostBatchOk", "")
	--@brief	邀请好友加入联盟OK（LEAGUE_InviteOk = 34）
	self:regProtocolCallbackFunction( Protocol.MAIN_LEAGUE, Protocol.LEAGUE_InviteOk, "ProtocolProcessorUnion:parse_LEAGUE_InviteOk", "")
end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorUnion:unregAll()
	self:clearReg()
end
  
-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief	获取联盟列表（LEAGUE_GetLeagueList = 1）
function ProtocolProcessorUnion:send_LEAGUE_GetLeagueList()
	WZLog("send_LEAGUE_GetLeagueList")
	local sender = Protocol:getSender( Protocol.MAIN_LEAGUE, Protocol.LEAGUE_GetLeagueList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	创建联盟（LEAGUE_CreateLeague = 3）
function ProtocolProcessorUnion:send_LEAGUE_CreateLeague(name)
	WZLog("send_LEAGUE_CreateLeague")
	local sender = Protocol:getSender( Protocol.MAIN_LEAGUE, Protocol.LEAGUE_CreateLeague )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeString(name)	-- 联盟名称
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取联盟数据信息（LEAGUE_GetLeagueInfo = 5）
function ProtocolProcessorUnion:send_LEAGUE_GetLeagueInfo(leagueId)
	WZLog("send_LEAGUE_GetLeagueInfo")
	local sender = Protocol:getSender( Protocol.MAIN_LEAGUE, Protocol.LEAGUE_GetLeagueInfo )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(leagueId)	-- 联盟ID
	SendProtocol(sender,false) --true:showLoading
end

--@brief	修改联盟设置（LEAGUE_Setting = 7）
function ProtocolProcessorUnion:send_LEAGUE_Setting(examine, level, fight, vipLevel)
	WZLog("send_LEAGUE_Setting")
	local sender = Protocol:getSender( Protocol.MAIN_LEAGUE, Protocol.LEAGUE_Setting )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(examine)	-- 申请入会是否需要审批【默认0=需要审批 | 1=不需要审批】
	sender:writeInt(level)	-- 申请入会等级下限
	sender:writeInt(fight)	-- 申请入会战力下限
	sender:writeInt(vipLevel)	-- 申请入会VIP等级下限
	SendProtocol(sender,false) --true:showLoading
end

--@brief	申请加入联盟（LEAGUE_ApplyLeague = 9）
function ProtocolProcessorUnion:send_LEAGUE_ApplyLeague(leagueId, lengueName)
	WZLog("send_LEAGUE_ApplyLeague")
	local sender = Protocol:getSender( Protocol.MAIN_LEAGUE, Protocol.LEAGUE_ApplyLeague )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(leagueId)	-- 联盟ID
	sender:writeString(lengueName)	-- 联盟名字
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取申请入盟列表（LEAGUE_GetApplyerList = 11）
function ProtocolProcessorUnion:send_LEAGUE_GetApplyerList()
	WZLog("send_LEAGUE_GetApplyerList")
	local sender = Protocol:getSender( Protocol.MAIN_LEAGUE, Protocol.LEAGUE_GetApplyerList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	审批入盟申请（LEAGUE_Approval = 13）
function ProtocolProcessorUnion:send_LEAGUE_Approval(playerId, action)
	WZLog("send_LEAGUE_Approval")
	local sender = Protocol:getSender( Protocol.MAIN_LEAGUE, Protocol.LEAGUE_Approval )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInts(playerId)	-- 申请人ID
	sender:writeInt(action)	-- 审批行为【0=拒绝加入 | 1=同意加入】
	SendProtocol(sender,false) --true:showLoading
end

--@brief	退出联盟（LEAGUE_Resignations = 15）
function ProtocolProcessorUnion:send_LEAGUE_Resignations()
	WZLog("send_LEAGUE_Resignations")
	local sender = Protocol:getSender( Protocol.MAIN_LEAGUE, Protocol.LEAGUE_Resignations )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	任命联盟职位（LEAGUE_ChangePost = 17）
function ProtocolProcessorUnion:send_LEAGUE_ChangePost(playerId, action)
	WZLog("send_LEAGUE_ChangePost")
	local sender = Protocol:getSender( Protocol.MAIN_LEAGUE, Protocol.LEAGUE_ChangePost )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(playerId)	-- 被任命的玩家ID
	sender:writeInt(action)	-- 任命行为类型【-1=降职 | 1=升职】
	SendProtocol(sender,false) --true:showLoading
end

--@brief	开除联盟成员（LEAGUE_ExpelMember = 19）
function ProtocolProcessorUnion:send_LEAGUE_ExpelMember(playerId)
	WZLog("send_LEAGUE_ExpelMember")
	local sender = Protocol:getSender( Protocol.MAIN_LEAGUE, Protocol.LEAGUE_ExpelMember )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInts(playerId)	-- 欲开除的成员ID
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取联盟操作日志（LEAGUE_GetOperationLog = 27）
function ProtocolProcessorUnion:send_LEAGUE_GetOperationLog()
	WZLog("send_LEAGUE_GetOperationLog")
	local sender = Protocol:getSender( Protocol.MAIN_LEAGUE, Protocol.LEAGUE_GetOperationLog )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	盟主让位（LEAGUE_Abdicate = 29）
function ProtocolProcessorUnion:send_LEAGUE_Abdicate(id)
	WZLog("send_LEAGUE_Abdicate")
	local sender = Protocol:getSender( Protocol.MAIN_LEAGUE, Protocol.LEAGUE_Abdicate )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(id)	-- 让位给谁
	SendProtocol(sender,false) --true:showLoading
end

--@brief	批量任命成员为指定职位（LEAGUE_ChangePostBatch = 31）
function ProtocolProcessorUnion:send_LEAGUE_ChangePostBatch(id, post)
	WZLog("send_LEAGUE_ChangePostBatch")
	local sender = Protocol:getSender( Protocol.MAIN_LEAGUE, Protocol.LEAGUE_ChangePostBatch )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInts(id)	-- 批量任命哪些人
	sender:writeInt(post)	-- 任命为什么职位
	SendProtocol(sender,false) --true:showLoading
end

--@brief	邀请好友加入联盟（LEAGUE_Invite = 33）
function ProtocolProcessorUnion:send_LEAGUE_Invite(id)
	WZLog("send_LEAGUE_Invite")
	local sender = Protocol:getSender( Protocol.MAIN_LEAGUE, Protocol.LEAGUE_Invite )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(id)	-- 邀请谁
	SendProtocol(sender,false) --true:showLoading
end

--@brief	回复入盟邀请（LEAGUE_ResponseInvite = 36）
function ProtocolProcessorUnion:send_LEAGUE_ResponseInvite(leagueId, lengueName, accept)
	WZLog("send_LEAGUE_ResponseInvite")
	local sender = Protocol:getSender( Protocol.MAIN_LEAGUE, Protocol.LEAGUE_ResponseInvite )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(leagueId)	-- 联盟ID
	sender:writeString(lengueName)	-- 联盟名字
	sender:writeBoolean(accept)	-- 是否接受
	SendProtocol(sender,false) --true:showLoading
end
-------------------------------------服务器到客户端协议回调方法模块--------------------------------------
--@brief	获取联盟列表OK（LEAGUE_GetLeagueListOk = 2）
function ProtocolProcessorUnion:parse_LEAGUE_GetLeagueListOk(id, name, chairmanId, chairmanName, level, exp, joinLimitLv, joinLimitVipLv, joinLimitFight, memberNum)
	-- id : 联盟ID
	-- name : 联盟名称
	-- chairmanId : 盟主Id
	-- chairmanName : 盟主昵称
	-- level : 联盟等级
	-- exp : 联盟经验
	-- joinLimitLv : 入盟等级条件
	-- joinLimitVipLv : 入盟VIP等级条件
	-- joinLimitFight : 入盟战力条件
	-- memberNum : 联盟成员人数
	WZLog("ProtocolProcessorUnion:parse_LEAGUE_GetLeagueListOk", id:size(), Serialize(VectorToTable(memberNum)), Serialize(VectorToTable(chairmanName)))

	WndUnionList:getCommunityListNew(VectorToTable(id), VectorToTable(name), VectorToTable(chairmanName), VectorToTable(level), VectorToTable(exp), VectorToTable(joinLimitLv), VectorToTable(joinLimitFight), VectorToTable(memberNum), VectorToTable(joinLimitVipLv))
end

--@brief	协议号名字（LEAGUE_CreateLeagueOk = 4）
function ProtocolProcessorUnion:parse_LEAGUE_CreateLeagueOk(id)
	-- id : 联盟ID【0=创建失败】
	WZLog("ProtocolProcessorUnion:parse_LEAGUE_CreateLeagueOk")
	if id > 0 then 
		WndUnionList:showInterface("hall")
	end
end

--@brief	获取联盟数据信息OK（LEAGUE_GetLeagueInfoOk = 6）
function ProtocolProcessorUnion:parse_LEAGUE_GetLeagueInfoOk(id, name, level, exp, joinLimitLv, joinLimitVipLv, joinLimitFight, examine, memberNum, totemLevel, schoolLevel, playerId, headId, faceId, colour, headEffectId, playerName, playerLevel, vipLevel, sex, loginTime, isOnline, post, fight, donate, totalDonate)
	-- id : 联盟ID
	-- name : 联盟名称
	-- level : 联盟等级
	-- exp : 联盟经验
	-- joinLimitLv : 限制加入联盟的等级
	-- joinLimitVipLv : 限制加入联盟的VIP等级
	-- joinLimitFight : 限制加入联盟的战力
	-- examine : 申请加入联盟时是否需要审批才能加入（0为需要审批）
	-- memberNum : 联盟成员数
	-- totemLevel : 图腾等级
	-- schoolLevel : 技能学堂等级
	-- playerId : 玩家ID
	-- headId : 玩家头像-头ID
	-- faceId : 玩家头像-脸ID
	-- colour : 头部颜色
	-- headEffectId : 头像框
	-- playerName : 玩家名称
	-- playerLevel : 玩家等级
	-- vipLevel : 玩家VIP等级
	-- sex : 性别
	-- loginTime : 玩家离线时间
	-- isOnline : 是否在线
	-- post : 玩家职位
	-- fight : 成员战斗力
	-- donate : 玩家当日贡献
	-- totalDonate : 玩家总贡献
	WZLog("ProtocolProcessorUnion:parse_LEAGUE_GetLeagueInfoOk", playerId:size(), Serialize(VectorToTable(playerId)), Serialize(VectorToTable(loginTime)))

	WndUnionList:getCommunityInfoOk(id, name, level, memberNum, totemLevel, exp, joinLimitLv, joinLimitVipLv, joinLimitFight, examine, schoolLevel, VectorToTable(playerId), VectorToTable(headId), VectorToTable(faceId), VectorToTable(colour), VectorToTable(headEffectId), VectorToTable(playerName), VectorToTable(playerLevel), VectorToTable(sex), VectorToTable(loginTime), VectorToTable(isOnline), VectorToTable(post), VectorToTable(fight), VectorToTable(donate), VectorToTable(totalDonate), VectorToTable(vipLevel))
	CacheCenter:setUnionInfo(id, name, level, exp, joinLimitLv, joinLimitVipLv, joinLimitFight, examine, memberNum, totemLevel, schoolLevel, VectorToTable(playerId), VectorToTable(headId), VectorToTable(faceId), VectorToTable(colour), VectorToTable(headEffectId), VectorToTable(playerName), VectorToTable(playerLevel), VectorToTable(vipLevel), VectorToTable(sex), VectorToTable(loginTime), VectorToTable(isOnline), VectorToTable(post), VectorToTable(fight), VectorToTable(donate), VectorToTable(totalDonate))
	if WndUnionHall.m_root then 
		WndUnionHall:getCommunityMemberList(id, name, level, exp, memberNum, joinLimitLv, joinLimitVipLv, joinLimitFight, examine, totemLevel, schoolLevel, VectorToTable(playerId), VectorToTable(headId), VectorToTable(faceId), VectorToTable(colour), VectorToTable(headEffectId), VectorToTable(playerName), VectorToTable(playerLevel), VectorToTable(sex), VectorToTable(loginTime), VectorToTable(isOnline), VectorToTable(post), VectorToTable(fight), VectorToTable(donate), VectorToTable(totalDonate), VectorToTable(vipLevel))
	end

	if WndCommunityAppoint.m_root ~= nil then
		if WndCommunityAppoint.m_nWinType == 1 then 
			WndCommunityAppoint:refresh()
		end
	end
	if WndCommunityRemove.m_root ~= nil then
		if WndCommunityRemove.m_nWinType == 1 then 
			WndCommunityRemove:update()
		end
	end
end

--@brief	修改联盟设置OK（LEAGUE_SettingOk = 8）
function ProtocolProcessorUnion:parse_LEAGUE_SettingOk(examine, level, fight, vipLevel)
	-- examine : 申请入会是否需要审批【默认0=需要审批 | 1=不需要审批】
	-- level : 申请入会等级下限
	-- fight : 申请入会战力下限
	-- vipLevel : 申请入会VIP等级下限
	WZLog("ProtocolProcessorUnion:parse_LEAGUE_SettingOk")

	MsgBoxManager:showTipBox(LocalStrings.SET_SUCCESS)
end

--@brief	申请加入联盟OK（LEAGUE_ApplyLeagueOk = 10）
function ProtocolProcessorUnion:parse_LEAGUE_ApplyLeagueOk(result)
	-- result : 申请结果【0=成功等待审批|1=成功直接入盟|小于0=异常码】
	WZLog("ProtocolProcessorUnion:parse_LEAGUE_ApplyLeagueOk")
	--自动审核则进入联盟
	if result == 1 then
		--进入联盟场景
   		WndUnionList:showInterface("hall")
		return
	elseif result == 0 then
		MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO9) 
	end
end

--@brief	获取申请入盟列表OK（LEAGUE_GetApplyerListOk = 12）
function ProtocolProcessorUnion:parse_LEAGUE_GetApplyerListOk(id, name, headId, faceId, colour, profileFrame, sex, level, vipLevel, fight)
	-- id : 申请人ID
	-- name : 申请人昵称
	-- headId : 申请人头部
	-- faceId : 申请人脸部
	-- colour : 申请人头颜色
	-- profileFrame : 申请人头像框
	-- sex : 申请人性别
	-- level : 申请人等级
	-- vipLevel : 申请人VIP等级
	-- fight : 申请人战力
	WZLog("ProtocolProcessorUnion:parse_LEAGUE_GetApplyerListOk", Serialize(VectorToTable(level)))

	WndRecruit:SendApprovingMemberList(VectorToTable(id), VectorToTable(name), VectorToTable(level), VectorToTable(vipLevel), VectorToTable(headId), VectorToTable(faceId), VectorToTable(sex), VectorToTable(fight), VectorToTable(colour), VectorToTable(profileFrame))
end

--@brief	审批入盟申请OK（LEAGUE_ApprovalOk = 14）
function ProtocolProcessorUnion:parse_LEAGUE_ApprovalOk(action, approvalPids, id, name, headId, faceId, colour, profileFrame, sex, level, vipLevel, fight)
	-- action : 审批行为【0=拒绝加入 | 1=同意加入】【前端触发协议时上传上来的参数】
	-- approvalPids : 通过审批的玩家ID
	-- id : 剩余申请人ID
	-- name : 剩余申请人昵称
	-- headId : 剩余申请人头部
	-- faceId : 剩余申请人脸部
	-- colour : 剩余申请人头颜色
	-- profileFrame : 剩余申请人头像框
	-- sex : 剩余申请人性别
	-- level : 剩余申请人等级
	-- vipLevel : 剩余申请人VIP等级
	-- fight : 剩余申请人战力
	WZLog("ProtocolProcessorUnion:parse_LEAGUE_ApprovalOk", action, Serialize(VectorToTable(id)))
	WndRecruit:SendApprovingMemberList(VectorToTable(id), VectorToTable(name), VectorToTable(level), VectorToTable(vipLevel), VectorToTable(headId), VectorToTable(faceId), VectorToTable(sex), VectorToTable(fight), VectorToTable(colour), VectorToTable(profileFrame))
end

--@brief	退出联盟OK（LEAGUE_ResignationsOk = 16）
function ProtocolProcessorUnion:parse_LEAGUE_ResignationsOk()
	WZLog("ProtocolProcessorUnion:parse_LEAGUE_ResignationsOk")
	if WndUnionList.m_root then 
		WindowManager:removeWindow(WndUnionList.m_root, WndUnionList, true)
	end
	CacheCenter:getPlayerInfo().leagueInfo = ""
	CacheCenter:getPlayerInfo().unionInfo = nil 
end

--@brief	任命联盟职位OK（LEAGUE_ChangePostOk = 18）
function ProtocolProcessorUnion:parse_LEAGUE_ChangePostOk(result)
	WZLog("ProtocolProcessorUnion:parse_LEAGUE_ChangePostOk", result)
	if result == 100 then 
		MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO96)
		--获取联盟大厅数据
		local unionId = CacheCenter:getPlayerInfo().unionInfo.id
		ProtocolProcessorUnion:send_LEAGUE_GetLeagueInfo(unionId)
	end
end

--@brief	开除联盟成员OK（LEAGUE_ExpelMemberOk = 20）
function ProtocolProcessorUnion:parse_LEAGUE_ExpelMemberOk()
	WZLog("ProtocolProcessorUnion:parse_LEAGUE_ExpelMemberOk")
	MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO97)
	--获取联盟大厅数据
	local unionId = CacheCenter:getPlayerInfo().unionInfo.id
	ProtocolProcessorUnion:send_LEAGUE_GetLeagueInfo(unionId)
end

--@brief	获取联盟操作日志（LEAGUE_GetOperationLogOk = 28）
function ProtocolProcessorUnion:parse_LEAGUE_GetOperationLogOk(action, createTime, playerIdA, playerIdB, nameA, nameB, paramA, paramB)
	-- action : 日志类型【1=入盟|2=退盟|3=升职|4=降职|5=开除|6=让位|7=联盟升级|...】
	-- createTime : 日志创建时间【单位：秒】
	-- playerIdA : 操作人ID【A玩家将B玩家踢出联盟，A为操作人】
	-- playerIdB : 被操作人ID【A玩家将B玩家踢出联盟，B为被操作人】
	-- nameA : 操作人昵称【A玩家将B玩家踢出联盟，A为操作人】
	-- nameB : 被操作人昵称【A玩家将B玩家踢出联盟，B为被操作人】
	-- paramA : 操作人参数【A玩家将B玩家踢出联盟，A为操作人】【参数可能含义：职位、联盟等级、等】
	-- paramB : 被操作人参数【A玩家将B玩家踢出联盟，B为被操作人】【参数可能含义：职位、联盟等级、等】
	WZLog("ProtocolProcessorUnion:parse_LEAGUE_GetOperationLogOk", Serialize(VectorToTable(action)), Serialize(VectorToTable(paramB)), Serialize(VectorToTable(paramA)))

	WndUnionHall:setOperateLog(VectorToTable(nameB), VectorToTable(nameA), VectorToTable(action), VectorToTable(paramB), VectorToTable(createTime), VectorToTable(paramA))
end

--@brief	盟主让位OK（LEAGUE_AbdicateOk = 30）
function ProtocolProcessorUnion:parse_LEAGUE_AbdicateOk()
	WZLog("ProtocolProcessorUnion:parse_LEAGUE_AbdicateOk")
	WndDismissCommunity:changeUnionPresidentOk()
end

--@brief	批量任命成员为指定职位OK（LEAGUE_ChangePostBatchOk = 32）
function ProtocolProcessorUnion:parse_LEAGUE_ChangePostBatchOk()
	WZLog("ProtocolProcessorUnion:parse_LEAGUE_ChangePostBatchOk")
	MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO137)
	--获取联盟大厅数据
	local unionId = CacheCenter:getPlayerInfo().unionInfo.id
	ProtocolProcessorUnion:send_LEAGUE_GetLeagueInfo(unionId)
end

--@brief	邀请好友加入联盟OK（LEAGUE_InviteOk = 34）
function ProtocolProcessorUnion:parse_LEAGUE_InviteOk()
	WZLog("ProtocolProcessorUnion:parse_LEAGUE_InviteOk")
end
-------------------------------------协议错误处理方法模块--------------------------------------
--@brief	获取联盟列表（LEAGUE_GetLeagueList = 1）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorUnion:send_LEAGUE_GetLeagueList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorUnion:parse_LEAGUE_GetLeagueList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_LEAGUE, Protocol.LEAGUE_GetLeagueList, nflag, sMessage)
end

--@brief	创建联盟（LEAGUE_CreateLeague = 3）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorUnion:send_LEAGUE_CreateLeague_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorUnion:parse_LEAGUE_CreateLeague_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_LEAGUE, Protocol.LEAGUE_CreateLeague, nflag, sMessage)
end

--@brief	获取联盟数据信息（LEAGUE_GetLeagueInfo = 5）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorUnion:send_LEAGUE_GetLeagueInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorUnion:parse_LEAGUE_GetLeagueInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_LEAGUE, Protocol.LEAGUE_GetLeagueInfo, nflag, sMessage)

	WndUnionList:getCommunityInfoError(sMessage)
end

--@brief	修改联盟设置（LEAGUE_Setting = 7）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorUnion:send_LEAGUE_Setting_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorUnion:parse_LEAGUE_Setting_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_LEAGUE, Protocol.LEAGUE_Setting, nflag, sMessage)
end

--@brief	申请加入联盟（LEAGUE_ApplyLeague = 9）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorUnion:send_LEAGUE_ApplyLeague_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorUnion:parse_LEAGUE_ApplyLeague_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_LEAGUE, Protocol.LEAGUE_ApplyLeague, nflag, sMessage)
end

--@brief	获取申请入盟列表（LEAGUE_GetApplyerList = 11）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorUnion:send_LEAGUE_GetApplyerList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorUnion:parse_LEAGUE_GetApplyerList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_LEAGUE, Protocol.LEAGUE_GetApplyerList, nflag, sMessage)
end

--@brief	审批入盟申请（LEAGUE_Approval = 13）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorUnion:send_LEAGUE_Approval_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorUnion:parse_LEAGUE_Approval_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_LEAGUE, Protocol.LEAGUE_Approval, nflag, sMessage)
end

--@brief	退出联盟（LEAGUE_Resignations = 15）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorUnion:send_LEAGUE_Resignations_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorUnion:parse_LEAGUE_Resignations_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_LEAGUE, Protocol.LEAGUE_Resignations, nflag, sMessage)
end

--@brief	任命联盟职位（LEAGUE_ChangePost = 17）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorUnion:send_LEAGUE_ChangePost_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorUnion:parse_LEAGUE_ChangePost_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_LEAGUE, Protocol.LEAGUE_ChangePost, nflag, sMessage)
end

--@brief	开除联盟成员（LEAGUE_ExpelMember = 19）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorUnion:send_LEAGUE_ExpelMember_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorUnion:parse_LEAGUE_ExpelMember_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_LEAGUE, Protocol.LEAGUE_ExpelMember, nflag, sMessage)
end

--@brief	获取联盟操作日志（LEAGUE_GetOperationLog = 27）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorUnion:send_LEAGUE_GetOperationLog_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorUnion:parse_LEAGUE_GetOperationLog_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_LEAGUE, Protocol.LEAGUE_GetOperationLog, nflag, sMessage)
end

--@brief	盟主让位（LEAGUE_Abdicate = 29）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorUnion:send_LEAGUE_Abdicate_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorUnion:parse_LEAGUE_Abdicate_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_LEAGUE, Protocol.LEAGUE_Abdicate, nflag, sMessage)
end

--@brief	批量任命成员为指定职位（LEAGUE_ChangePostBatch = 31）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorUnion:send_LEAGUE_ChangePostBatch_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorUnion:parse_LEAGUE_ChangePostBatch_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_LEAGUE, Protocol.LEAGUE_ChangePostBatch, nflag, sMessage)
end

--@brief	邀请好友加入联盟（LEAGUE_Invite = 33）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorUnion:send_LEAGUE_Invite_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorUnion:parse_LEAGUE_Invite_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_LEAGUE, Protocol.LEAGUE_Invite, nflag, sMessage)
end

--@brief	回复入盟邀请（LEAGUE_ResponseInvite = 36）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorUnion:send_LEAGUE_ResponseInvite_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorUnion:parse_LEAGUE_ResponseInvite_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_LEAGUE, Protocol.LEAGUE_ResponseInvite, nflag, sMessage)
end
-------------------------------------公有方法模块End----------------------------------------


