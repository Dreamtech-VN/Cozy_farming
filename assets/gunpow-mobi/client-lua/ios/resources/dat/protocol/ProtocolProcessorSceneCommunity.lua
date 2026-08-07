--ProtocolProcessorSceneCommunity.lua
--@brief	公会相关协议
--@date  	2013/12/24
--@author 	zsq
--@note 	公会相关协议


ProtocolProcessorSceneCommunity = ProtocolProcessorBase:new()

-------------------------------------公有方法模块--------------------------------------

--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorSceneCommunity:regAll()
	WZLog("ProtocolProcessorSceneCommunity:regAll")
	--客户端到服务端
	--@brief	创建公会（GUILD_CreateGuild = 1）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_CreateGuild, "ProtocolProcessorSceneCommunity:send_GUILD_CreateGuild_ErrorProcess", "is" )	
	--@brief	获取公会列表（GUILD_GetGuildList = 3）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildList, "ProtocolProcessorSceneCommunity:send_GUILD_GetGuildList_ErrorProcess", "is" )

	--@brief	获取公会（GUILD_GetGuild = 5）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_GetGuild, "ProtocolProcessorSceneCommunity:send_GUILD_GetGuild_ErrorProcess", "is" )

--@brief	申请公会（GUILD_ApplyGuild = 7）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_ApplyGuild, "ProtocolProcessorSceneCommunity:send_GUILD_ApplyGuild_ErrorProcess", "is" )

--@brief	获取审批人列表（GUILD_GetApplyerList = 9）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_GetApplyerList, "ProtocolProcessorSceneCommunity:send_GUILD_GetApplyerList_ErrorProcess", "is" )

--@brief	审批（GUILD_Approval = 11）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_Approval, "ProtocolProcessorSceneCommunity:send_GUILD_Approval_ErrorProcess", "is" )

--@brief	退出公会（GUILD_Resignations = 12）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_Resignations, "ProtocolProcessorSceneCommunity:send_GUILD_Resignations_ErrorProcess", "is" )

--@brief	转让会长（GUILD_Abdicate = 14）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_Abdicate, "ProtocolProcessorSceneCommunity:send_GUILD_Abdicate_ErrorProcess", "is" )

--@brief	获取公会大厅（GUILD_GetGuildHall = 16）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildHall, "ProtocolProcessorSceneCommunity:send_GUILD_GetGuildHall_ErrorProcess", "is" )

--@brief	修改会员职位（GUILD_ChangePost = 18）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_ChangePost, "ProtocolProcessorSceneCommunity:send_GUILD_ChangePost_ErrorProcess", "is" )

--@brief	开除会员（GUILD_ExpelMember = 20）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_ExpelMember, "ProtocolProcessorSceneCommunity:send_GUILD_ExpelMember_ErrorProcess", "is" )

--@brief	编辑公会宣言（GUILD_EditGuildDesc = 22）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_EditGuildDesc, "ProtocolProcessorSceneCommunity:send_GUILD_EditGuildDesc_ErrorProcess", "is" )

--@brief	公会升级（GUILD_GuildUpLevel = 24）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_GuildUpLevel, "ProtocolProcessorSceneCommunity:send_GUILD_GuildUpLevel_ErrorProcess", "is" )

--@brief	发送公会邮件（GUILD_SendGuildMail = 26）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_SendGuildMail, "ProtocolProcessorSceneCommunity:send_GUILD_SendGuildMail_ErrorProcess", "is" )

--@brief	公会设置（GUILD_GuildSetting = 28）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_GuildSetting, "ProtocolProcessorSceneCommunity:send_GUILD_GuildSetting_ErrorProcess", "is" )

--@brief	公会操作日志（GUILD_GetOperationLog = 30）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_GetOperationLog, "ProtocolProcessorSceneCommunity:send_GUILD_GetOperationLog_ErrorProcess", "is" )

--@brief	公会捐献（GUILD_GuildDonate = 32）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_GuildDonate, "ProtocolProcessorSceneCommunity:send_GUILD_GuildDonate_ErrorProcess", "is" )

--@brief	公会捐献日志（GUILD_GetDonateLog = 34）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_GetDonateLog, "ProtocolProcessorSceneCommunity:send_GUILD_GetDonateLog_ErrorProcess", "is" )

--@brief	公会建筑升级（GUILD_BuildUpLevel = 36）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_BuildUpLevel, "ProtocolProcessorSceneCommunity:send_GUILD_BuildUpLevel_ErrorProcess", "is" )

--@brief	图腾瞻仰（GUILD_TotemPay = 38）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_TotemPay, "ProtocolProcessorSceneCommunity:send_GUILD_TotemPay_ErrorProcess", "is" )

--@brief	获取玩家公会技能（GUILD_GetGuildSkill = 40）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildSkill, "ProtocolProcessorSceneCommunity:send_GUILD_GetGuildSkill_ErrorProcess", "is" )

--@brief	学习公会技能（GUILD_LearnGuildSkill = 42）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_LearnGuildSkill, "ProtocolProcessorSceneCommunity:send_GUILD_LearnGuildSkill_ErrorProcess", "is" )

--@brief	获取公会战列表（GUILD_GetGuildWar = 49）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildWar, "ProtocolProcessorSceneCommunity:send_GUILD_GetGuildWar_ErrorProcess", "is" )

--@brief	创建公会战房间（GUILD_CreateWarRoom = 51）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_CreateWarRoom, "ProtocolProcessorSceneCommunity:send_GUILD_CreateWarRoom_ErrorProcess", "is" )

--@brief	快速加入公会战房间（GUILD_QuickGame = 52）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_QuickGame, "ProtocolProcessorSceneCommunity:send_GUILD_QuickGame_ErrorProcess", "is" )

--@brief	获取公会战公会排名列表（GUILD_GetGuildWarRank = 53）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildWarRank, "ProtocolProcessorSceneCommunity:send_GUILD_GetGuildWarRank_ErrorProcess", "is" )

--@brief	获取公会周排名列表（GUILD_GetGuildWeekRank = 55）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildWeekRank, "ProtocolProcessorSceneCommunity:send_GUILD_GetGuildWeekRank_ErrorProcess", "is" )

--@brief	获取玩家工会任务列表（GUILD_RequestGuildTask = 57）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_RequestGuildTask, "ProtocolProcessorSceneCommunity:send_GUILD_RequestGuildTask_ErrorProcess", "is" )
--@brief	获取玩家工会基金奖励列表（GUILD_RequestFundReward = 59）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_RequestFundReward, "ProtocolProcessorSceneCommunity:send_GUILD_RequestFundReward_ErrorProcess", "is" )
--@brief	请求刷新任务列表（GUILD_RequestFlushTask = 61）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_RequestFlushTask, "ProtocolProcessorSceneCommunity:send_GUILD_RequestFlushTask_ErrorProcess", "is" )
--@brief	请求留言（GUILD_LeaveMsg = 63）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_LeaveMsg, "ProtocolProcessorSceneCommunity:send_GUILD_LeaveMsg_ErrorProcess", "is" )
--@brief	会长发布任务（GUILD_PublishTask = 65）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_PublishTask, "ProtocolProcessorSceneCommunity:send_GUILD_PublishTask_ErrorProcess", "is" )
--@brief	修改会员职位（GUILD_ChangeMemberPost = 68）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_ChangeMemberPost, "ProtocolProcessorSceneCommunity:send_GUILD_ChangeMemberPost_ErrorProcess", "is" )
--@brief	获取公会弹劾信息（GUILD_GetImpeachInfo = 73）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_GetImpeachInfo, "ProtocolProcessorSceneCommunity:send_GUILD_GetImpeachInfo_ErrorProcess", "is" )
--@brief	投票（GUILD_ImpeachVote = 71）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_ImpeachVote, "ProtocolProcessorSceneCommunity:send_GUILD_ImpeachVote_ErrorProcess", "is" )
--@brief	邀请（GUILD_Invite = 92）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_Invite, "ProtocolProcessorSceneCommunity:send_GUILD_Invite_ErrorProcess", "is" )
--@brief	响应邀请（GUILD_ResponseInvite = 95）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_ResponseInvite, "ProtocolProcessorSceneCommunity:send_GUILD_ResponseInvite_ErrorProcess", "is" )
--@brief	获取公会副本boss伤害排行（GUILD_GetGuildBossHurtRank = 97）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildBossHurtRank, "ProtocolProcessorSceneCommunity:send_GUILD_GetGuildBossHurtRank_ErrorProcess", "is" )


	--服务端到客户端
	--@brief	创建公会成功（GUILD_CreateGuildOk = 2）
	self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_CreateGuildOk, "ProtocolProcessorSceneCommunity:parse_GUILD_CreateGuildOk", "i")

	--@brief	获取公会列表（GUILD_GetGuildListOk = 4）
	self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildListOk, "ProtocolProcessorSceneCommunity:parse_GUILD_GetGuildListOk", "vivivsviviivivivivivi")

	--@brief	获取公会（GUILD_GetGuildOk = 6）
	self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildOk, "ProtocolProcessorSceneCommunity:parse_GUILD_GetGuildOk", "isiissiviisiiii")

--@brief	申请公会（GUILD_ApplyGuildOk = 8）
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_ApplyGuildOk, "ProtocolProcessorSceneCommunity:parse_GUILD_ApplyGuildOk", "i")

--@brief	获取审批人列表（GUILD_GetApplyerListOk = 10）
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_GetApplyerListOk, "ProtocolProcessorSceneCommunity:parse_GUILD_GetApplyerListOk", "vivsvivtvivivtvivi")

--@brief	退出公会（GUILD_ResignationsOk = 13）
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_ResignationsOk, "ProtocolProcessorSceneCommunity:parse_GUILD_ResignationsOk", "")

--@brief	转让会长（GUILD_AbdicateOk = 15）
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_AbdicateOk, "ProtocolProcessorSceneCommunity:parse_GUILD_AbdicateOk", "")

--@brief	获取公会大厅（GUILD_GetGuildHallOk = 17）
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildHallOk, "ProtocolProcessorSceneCommunity:parse_GUILD_GetGuildHallOk", "isiiisiiiiivivivivsvivivivivivivivivivivivivtiviviviiivivssviiiis")

--@brief	修改会员职位（GUILD_ChangePostOk = 19）
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_ChangePostOk, "ProtocolProcessorSceneCommunity:parse_GUILD_ChangePostOk", "")

--@brief	开除会员（GUILD_ExpelMemberOk = 21）
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_ExpelMemberOk, "ProtocolProcessorSceneCommunity:parse_GUILD_ExpelMemberOk", "")

--@brief	编辑公会宣言（GUILD_EditGuildDescOk = 23）
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_EditGuildDescOk, "ProtocolProcessorSceneCommunity:parse_GUILD_EditGuildDescOk", "i")

--@brief	公会升级（GUILD_GuildUpLeveOk = 25）
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_GuildUpLeveOk, "ProtocolProcessorSceneCommunity:parse_GUILD_GuildUpLeveOk", "")

--@brief	发送公会邮件（GUILD_SendGuildMailOk = 27）
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_SendGuildMailOk, "ProtocolProcessorSceneCommunity:parse_GUILD_SendGuildMailOk", "")

--@brief	公会设置（GUILD_GuildSettingOk = 29）
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_GuildSettingOk, "ProtocolProcessorSceneCommunity:parse_GUILD_GuildSettingOk", "")

--@brief	公会操作日志（GUILD_GetOperationLogOk = 31）
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_GetOperationLogOk, "ProtocolProcessorSceneCommunity:parse_GUILD_GetOperationLogOk", "vsvsvivivl")

--@brief	公会捐献（GUILD_GuildDonateOk = 33）
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_GuildDonateOk, "ProtocolProcessorSceneCommunity:parse_GUILD_GuildDonateOk", "")

--@brief	公会捐献日志（GUILD_GetDonateLogOk = 35）
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_GetDonateLogOk, "ProtocolProcessorSceneCommunity:parse_GUILD_GetDonateLogOk", "vsvivivivl")

--@brief	公会建筑升级（GUILD_BuildUpLevelOk = 37）
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_BuildUpLevelOk, "ProtocolProcessorSceneCommunity:parse_GUILD_BuildUpLevelOk", "")

--@brief	图腾瞻仰（GUILD_TotemPayOk = 39）
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_TotemPayOk, "ProtocolProcessorSceneCommunity:parse_GUILD_TotemPayOk", "")

--@brief	获取玩家公会技能（GUILD_GetGuildSkillOk = 41）
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildSkillOk, "ProtocolProcessorSceneCommunity:parse_GUILD_GetGuildSkillOk", "vivi")

--@brief	学习公会技能（GUILD_LearnGuildSkillOk = 43）
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_LearnGuildSkillOk, "ProtocolProcessorSceneCommunity:parse_GUILD_LearnGuildSkillOk", "")

--@brief	获取公会战列表（GUILD_GetGuildWarOk = 50）
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildWarOk, "ProtocolProcessorSceneCommunity:parse_GUILD_GetGuildWarOk", "iiiiisiiiiivivsvivivi")

--@brief	获取公会战公会排名列表（GUILD_GetGuildWarRankOk = 54）
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildWarRankOk, "ProtocolProcessorSceneCommunity:parse_GUILD_GetGuildWarRankOk", "vivivsvivivii")

--@brief	获取公会周排名列表（GUILD_GetGuildWeekRankOk = 56）
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildWeekRankOk, "ProtocolProcessorSceneCommunity:parse_GUILD_GetGuildWeekRankOk", "vivivsviviviitvivivivi")

--@brief	获取玩家工会任务列表（GUILD_RequestGuildTaskOk = 58）
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_RequestGuildTaskOk, "ProtocolProcessorSceneCommunity:parse_GUILD_RequestGuildTaskOk", "vivivivivivivivivsvsviviviviviivi")
--@brief	获取玩家工会基金奖励列表（GUILD_RequestFundRewardOk = 60）
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_RequestFundRewardOk, "ProtocolProcessorSceneCommunity:parse_GUILD_RequestFundRewardOk", "isi")
--@brief	获取玩家工会基金奖励列表（GUILD_RequestFlushTaskOk = 62）
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_RequestFlushTaskOk, "ProtocolProcessorSceneCommunity:parse_GUILD_RequestFlushTaskOk", "i")
--@brief	留言成功失败（GUILD_LeaveMsgOk = 64）
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_LeaveMsgOk, "ProtocolProcessorSceneCommunity:parse_GUILD_LeaveMsgOk", "i")
--@brief	发布任务成功（GUILD_PublishTaskOk = 66）
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_PublishTaskOk, "ProtocolProcessorSceneCommunity:parse_GUILD_PublishTaskOk", "i")
--@brief	修改会员职位（GUILD_ChangeMemberPostOk = 69）
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_ChangeMemberPostOk, "ProtocolProcessorSceneCommunity:parse_GUILD_ChangeMemberPostOk", "")
--@brief	推送公会弹劾信息（GUILD_ImpeachInfo = 70）
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_ImpeachInfo, "ProtocolProcessorSceneCommunity:parse_GUILD_ImpeachInfo", "siiiti")
--@brief	投票成功（GUILD_ImpeachVoteOk = 72）
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_ImpeachVoteOk, "ProtocolProcessorSceneCommunity:parse_GUILD_ImpeachVoteOk", "")
--@brief	邀请（GUILD_InviteOk = 93）
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_InviteOk, "ProtocolProcessorSceneCommunity:parse_GUILD_InviteOk", "")
--@brief	被邀请（GUILD_BeInvite = 94）
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_BeInvite, "ProtocolProcessorSceneCommunity:parse_GUILD_BeInvite", "ssi")
--@brief	响应邀请（GUILD_ResponseInviteOk = 96）
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_ResponseInviteOk, "ProtocolProcessorSceneCommunity:parse_GUILD_ResponseInviteOk", "")
--@brief	获取公会副本boss伤害排行（GUILD_GetGuildBossHurtRankOk = 98）
self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildBossHurtRankOk, "ProtocolProcessorSceneCommunity:parse_GUILD_GetGuildBossHurtRankOk", "ivivivsvivivivtvivivivs")

end 

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorSceneCommunity:unregAll()
	self:clearReg()
end


-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief	创建公会（GUILD_CreateGuild = 1）
function ProtocolProcessorSceneCommunity:send_GUILD_CreateGuild(name )
	WZLog("send_GUILD_CreateGuild")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_CreateGuild )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeString( name )	-- 公会名称
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取公会列表（GUILD_GetGuildList = 3）
function ProtocolProcessorSceneCommunity:send_GUILD_GetGuildList(pageSize, pageIndex )
	WZLog("send_GUILD_GetGuildList")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildList )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( pageSize )	-- 每页条数
	sender:writeInt( pageIndex )	-- 页数（从0开始）
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取公会（GUILD_GetGuild = 5）
function ProtocolProcessorSceneCommunity:send_GUILD_GetGuild(id, guildType)
	WZLog("send_GUILD_GetGuild")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_GetGuild )
	if sender==nil then WZLog("sender == nil") return end

	local guildType = guildType or 0
	sender:writeInt( id )	-- 公会ID
	sender:writeInt( guildType )	-- 公会ID
	SendProtocol(sender,false) --true:showLoading
end

--@brief	申请公会（GUILD_ApplyGuild = 7）
function ProtocolProcessorSceneCommunity:send_GUILD_ApplyGuild(id )
	WZLog("send_GUILD_ApplyGuild")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_ApplyGuild )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( id )	-- 公会ID
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取审批人列表（GUILD_GetApplyerList = 9）
function ProtocolProcessorSceneCommunity:send_GUILD_GetApplyerList( )
	WZLog("send_GUILD_GetApplyerList")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_GetApplyerList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	审批（GUILD_Approval = 11）
function ProtocolProcessorSceneCommunity:send_GUILD_Approval(id, action )
	WZLog("send_GUILD_Approval")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_Approval )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInts( id )	-- 玩家ID
	sender:writeInt( action )	-- 0,拒绝1同意
	SendProtocol(sender,false) --true:showLoading
end

--@brief	退出公会（GUILD_Resignations = 12）
function ProtocolProcessorSceneCommunity:send_GUILD_Resignations( )
	WZLog("send_GUILD_Resignations")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_Resignations )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	转让会长（GUILD_Abdicate = 14）
function ProtocolProcessorSceneCommunity:send_GUILD_Abdicate(id )
	WZLog("send_GUILD_Abdicate")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_Abdicate )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( id )	-- 新会长
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取公会大厅（GUILD_GetGuildHall = 16）
function ProtocolProcessorSceneCommunity:send_GUILD_GetGuildHall( )
	WZLog("send_GUILD_GetGuildHall")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildHall )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	修改会员职位（GUILD_ChangePost = 18）
function ProtocolProcessorSceneCommunity:send_GUILD_ChangePost(id, action )
	WZLog("send_GUILD_ChangePost")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_ChangePost )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( id )	-- 被修改人ID
	sender:writeInt( action )	-- -1降职1升职
	SendProtocol(sender,false) --true:showLoading
end

--@brief	开除会员（GUILD_ExpelMember = 20）
function ProtocolProcessorSceneCommunity:send_GUILD_ExpelMember(id )
	WZLog("send_GUILD_ExpelMember")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_ExpelMember )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInts( id )	-- 被开除人ID
	SendProtocol(sender,false) --true:showLoading
end

--@brief	编辑公会宣言（GUILD_EditGuildDesc = 22）
function ProtocolProcessorSceneCommunity:send_GUILD_EditGuildDesc(content )
	WZLog("send_GUILD_EditGuildDesc")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_EditGuildDesc )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeString( content )	-- 内容
	SendProtocol(sender,false) --true:showLoading
end

--@brief	公会升级（GUILD_GuildUpLevel = 24）
function ProtocolProcessorSceneCommunity:send_GUILD_GuildUpLevel( )
	WZLog("send_GUILD_GuildUpLevel")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_GuildUpLevel )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	发送公会邮件（GUILD_SendGuildMail = 26）
function ProtocolProcessorSceneCommunity:send_GUILD_SendGuildMail(content )
	WZLog("send_GUILD_SendGuildMail")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_SendGuildMail )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeString( content )	-- 内容
	SendProtocol(sender,false) --true:showLoading
end

--@brief	公会设置（GUILD_GuildSetting = 28）
function ProtocolProcessorSceneCommunity:send_GUILD_GuildSetting(setting, rankMatchLevel, examine ,vipLevel)
	WZLog("send_GUILD_GuildSetting")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_GuildSetting )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( setting )	-- 设置
	sender:writeInt( rankMatchLevel )	-- 设置
	sender:writeInt( examine )	-- 设置
	sender:writeInt( vipLevel )	-- 设置
	SendProtocol(sender,false) --true:showLoading
end

--@brief	公会操作日志（GUILD_GetOperationLog = 30）
function ProtocolProcessorSceneCommunity:send_GUILD_GetOperationLog( )
	WZLog("send_GUILD_GetOperationLog")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_GetOperationLog )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	公会捐献（GUILD_GuildDonate = 32）
function ProtocolProcessorSceneCommunity:send_GUILD_GuildDonate(id )
	WZLog("send_GUILD_GuildDonate")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_GuildDonate )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( id )	-- 捐献表id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	公会捐献日志（GUILD_GetDonateLog = 34）
function ProtocolProcessorSceneCommunity:send_GUILD_GetDonateLog( )
	WZLog("send_GUILD_GetDonateLog")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_GetDonateLog )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	公会建筑升级（GUILD_BuildUpLevel = 36）
function ProtocolProcessorSceneCommunity:send_GUILD_BuildUpLevel(build )
	WZLog("send_GUILD_BuildUpLevel")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_BuildUpLevel )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( build )	-- 1.公会图腾、2.技能学院、3.公会商店
	SendProtocol(sender,false) --true:showLoading
end

--@brief	图腾瞻仰（GUILD_TotemPay = 38）
function ProtocolProcessorSceneCommunity:send_GUILD_TotemPay( )
	WZLog("send_GUILD_TotemPay")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_TotemPay )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取玩家公会技能（GUILD_GetGuildSkill = 40）
function ProtocolProcessorSceneCommunity:send_GUILD_GetGuildSkill( )
	WZLog("send_GUILD_GetGuildSkill")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildSkill )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	学习公会技能（GUILD_LearnGuildSkill = 42）
function ProtocolProcessorSceneCommunity:send_GUILD_LearnGuildSkill(id )
	WZLog("send_GUILD_LearnGuildSkill")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_LearnGuildSkill )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( id )	-- 技能ID
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取公会战列表（GUILD_GetGuildWar = 49）
function ProtocolProcessorSceneCommunity:send_GUILD_GetGuildWar( )
	WZLog("send_GUILD_GetGuildWar")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildWar )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	创建公会战房间（GUILD_CreateWarRoom = 51）
function ProtocolProcessorSceneCommunity:send_GUILD_CreateWarRoom( )
	WZLog("send_GUILD_CreateWarRoom")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_CreateWarRoom )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	快速加入公会战房间（GUILD_QuickGame = 52）
function ProtocolProcessorSceneCommunity:send_GUILD_QuickGame( )
	WZLog("send_GUILD_QuickGame")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_QuickGame )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取公会战公会排名列表（GUILD_GetGuildWarRank = 53）
function ProtocolProcessorSceneCommunity:send_GUILD_GetGuildWarRank(pageSize, pageIndex )
	WZLog("send_GUILD_GetGuildWarRank")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildWarRank )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( pageSize )	-- 每页条数
	sender:writeInt( pageIndex )	-- 页数（从0开始）
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取公会周排名列表（GUILD_GetGuildWeekRank = 55）
function ProtocolProcessorSceneCommunity:send_GUILD_GetGuildWeekRank(pageSize, pageIndex, rankType )
	WZLog("send_GUILD_GetGuildWeekRank")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildWeekRank )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( pageSize )	-- 每页条数
	sender:writeInt( pageIndex )	-- 页数（从0开始）
	sender:writeByte( rankType )	-- 0周排名，1历史排名
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取玩家工会任务列表（GUILD_RequestGuildTask = 57）
function ProtocolProcessorSceneCommunity:send_GUILD_RequestGuildTask( )
	WZLog("send_GUILD_RequestGuildTask")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_RequestGuildTask )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取玩家工会基金奖励列表（GUILD_RequestFundReward = 59）
function ProtocolProcessorSceneCommunity:send_GUILD_RequestFundReward( )
	WZLog("send_GUILD_RequestFundReward")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_RequestFundReward )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	请求刷新任务列表（GUILD_RequestFlushTask = 61）
function ProtocolProcessorSceneCommunity:send_GUILD_RequestFlushTask(lockIdList )
	WZLog("send_GUILD_RequestFlushTask")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_RequestFlushTask )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInts( lockIdList )	-- 被锁的任务列表
	SendProtocol(sender,false) --true:showLoading
end

--@brief	请求留言（GUILD_LeaveMsg = 63）
function ProtocolProcessorSceneCommunity:send_GUILD_LeaveMsg(msg )
	WZLog("send_GUILD_LeaveMsg")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_LeaveMsg )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeString( msg )	-- 留言
	SendProtocol(sender,false) --true:showLoading
end

--@brief	会长发布任务（GUILD_PublishTask = 65）
function ProtocolProcessorSceneCommunity:send_GUILD_PublishTask(idList )
	WZLog("send_GUILD_PublishTask")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_PublishTask )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInts( idList )	-- 被锁的任务列表
	SendProtocol(sender,false) --true:showLoading
end

--@brief	修改会员职位（GUILD_ChangeMemberPost = 68）
function ProtocolProcessorSceneCommunity:send_GUILD_ChangeMemberPost(id, post )
	WZLog("send_GUILD_ChangeMemberPost")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_ChangeMemberPost )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInts( id )	-- 被修改人ID
	sender:writeInt( post )	-- 职位
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取公会弹劾信息（GUILD_GetImpeachInfo = 73）
function ProtocolProcessorSceneCommunity:send_GUILD_GetImpeachInfo( )
	WZLog("send_GUILD_GetImpeachInfo")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_GetImpeachInfo )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	投票（GUILD_ImpeachVote = 71）
function ProtocolProcessorSceneCommunity:send_GUILD_ImpeachVote( )
	WZLog("send_GUILD_ImpeachVote")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_ImpeachVote )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	邀请（GUILD_Invite = 92）
function ProtocolProcessorSceneCommunity:send_GUILD_Invite(targetPlayerId )
	WZLog("send_GUILD_Invite")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_Invite )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( targetPlayerId )	-- 目标玩家
	SendProtocol(sender,false) --true:showLoading
end

--@brief	响应邀请（GUILD_ResponseInvite = 95）
function ProtocolProcessorSceneCommunity:send_GUILD_ResponseInvite(guildId, accept )
	WZLog("send_GUILD_ResponseInvite")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_ResponseInvite )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( guildId )	-- 公会id
	sender:writeBoolean( accept )	-- 是否接受
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取公会副本boss伤害排行（GUILD_GetGuildBossHurtRank = 97）
function ProtocolProcessorSceneCommunity:send_GUILD_GetGuildBossHurtRank(guildId, mapId )
	WZLog("send_GUILD_GetGuildBossHurtRank")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildBossHurtRank )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( guildId )	-- 公会id
	sender:writeInt( mapId )	-- 副本ID
	SendProtocol(sender,false) --true:showLoading
end

-------------------------------------服务器到客户端协议回调方法模块--------------------------------------
--@brief	创建公会成功（GUILD_CreateGuildOk = 2）
function ProtocolProcessorSceneCommunity:parse_GUILD_CreateGuildOk(id)
	-- id : 公会ID
	WZLog("ProtocolProcessorSceneCommunity:parse_GUILD_CreateGuildOk")
	--进入公会场景
   	replaceScene(SceneCommunityMain:createElement())

	if SceneCommunityMain and SceneCommunityMain.m_root then
		SceneCommunityMain:closeLoading()
	end
end

--@brief	获取公会列表（GUILD_GetGuildListOk = 4）
function ProtocolProcessorSceneCommunity:parse_GUILD_GetGuildListOk(rank, id, name, level, prestige, totalPage, warRank, setting, rankMatchLevel, members, vipLevel)
	-- rank : 排名
	-- id : 公会ID
	-- name : 公会名称
	-- level : 公会等级
	-- prestige : 公会威望
	-- totalPage : 总页数
	WZLog("ProtocolProcessorSceneCommunity:parse_GUILD_GetGuildListOk")
	SceneCommunity:getCommunityListNew(VectorToTable(rank), VectorToTable(id), VectorToTable(name), VectorToTable(level), VectorToTable(prestige), VectorToTable(totalPage), VectorToTable(warRank), VectorToTable(setting), VectorToTable(rankMatchLevel), VectorToTable(members), VectorToTable(vipLevel))
	if SceneCommunityMain and SceneCommunityMain.m_root then
		SceneCommunityMain:closeLoading()
	end
end

--@brief	获取公会（GUILD_GetGuildOk = 6）
function ProtocolProcessorSceneCommunity:parse_GUILD_GetGuildOk(id, name, level, members, chairman, desc, totemLevel, warRank, rank, declaration, prestige, setting, rankMatchLevel, vipLevel)
	-- id : 公会ID
	-- name : 公会名称
	-- level : 公会级别
	-- members : 公会人数
	-- chairman : 会长名字
	-- desc : 公会宣言
	-- totemLevel : 图腾等级
	WZLog("ProtocolProcessorSceneCommunity:parse_GUILD_GetGuildOk", setting, vipLevel)
	if SceneCommunity.m_root then
		SceneCommunity:getCommunityInfoOk(id, name, level, members, chairman, desc, totemLevel, warRank, rank, declaration, prestige, setting, vipLevel)
		return 
	end

	if SceneCommunityWar.m_root or WndFinalistQualifying.m_root then   --公会战
		SceneCommunityWar:getCommunityInfoOk(id, name, level, members, chairman, desc, totemLevel, warRank, rank, declaration, prestige, setting, vipLevel)
		return
	end

	if WndCommunityBossWarRank.m_root then
		WndCommunityBossWarRank:getCommunityInfoOk(id, name, level, members, chairman, desc, totemLevel, warRank, rank, declaration, prestige, setting, vipLevel)
		return
	end
end

--@brief	申请公会（GUILD_ApplyGuildOk = 8）
function ProtocolProcessorSceneCommunity:parse_GUILD_ApplyGuildOk(result)
	-- result : 0 成功，其它值表示公会最低要求等级
	WZLog("ProtocolProcessorSceneCommunity:parse_GUILD_ApplyGuildOk")
	--自动审核则进入公会
	if result == 2 then
		--进入公会场景
   		replaceScene(SceneCommunityMain:createElement())
		return
	end
	if result == 0 then
		MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO9) 
	else
		local level = CacheCenter:getPlayerInfo().level
		MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO49) 
	end
	if SceneCommunityMain and SceneCommunityMain.m_root then
		SceneCommunityMain:closeLoading()
	end
end

--@brief	获取审批人列表（GUILD_GetApplyerListOk = 10）
function ProtocolProcessorSceneCommunity:parse_GUILD_GetApplyerListOk(id, name, level, vipLevel, headId, faceId, sex, fight, headColor)
	-- id : 玩家ID
	-- name : 玩家名称
	-- level : 玩家等级
	WZLog("ProtocolProcessorSceneCommunity:parse_GUILD_GetApplyerListOk",id:size())
	WndRecruit:SendApprovingMemberList(VectorToTable(id), VectorToTable(name), VectorToTable(level), VectorToTable(vipLevel), VectorToTable(headId), VectorToTable(faceId), VectorToTable(sex), VectorToTable(fight), VectorToTable(headColor))
	if SceneCommunityMain and SceneCommunityMain.m_root then
		SceneCommunityMain:closeLoading()
	end
end

--@brief	退出公会（GUILD_ResignationsOk = 13）
function ProtocolProcessorSceneCommunity:parse_GUILD_ResignationsOk()
	WZLog("ProtocolProcessorSceneCommunity:parse_GUILD_ResignationsOk")
	--if SceneCommunityMain.m_root ~= nil then
   	--	replaceScene(SceneCity:createElement())
	--end
end

--@brief	转让会长（GUILD_AbdicateOk = 15）
function ProtocolProcessorSceneCommunity:parse_GUILD_AbdicateOk()
	WZLog("ProtocolProcessorSceneCommunity:parse_GUILD_AbdicateOk")
	WndDismissCommunity:changePresidentOk()
end

--@brief	获取公会大厅（GUILD_GetGuildHallOk = 17）
function ProtocolProcessorSceneCommunity:parse_GUILD_GetGuildHallOk(guildId, guildName, guildLevel, prestige, members, desc, setting, totemLevel, schoolLevel, storeLevel, newApply, id, headId, faceId, name, level, post, donate, totalDonate, loginTime, isOnline, buyDonateTime, totemPayTime, sex, weekDonate, lastDonate, allDonate, vipLevel, maxDelCount, headColor, rmLevel, tournamentLevel, rankMatchLevel, examine, fight, donateTime, declaration, limitDonate, joinVipLevel, guildwarStage, qualification, presidentInfo)
	-- guildId : 公会ID
	-- guildName : 公会名称
	-- guildLevel : 公会等级
	-- prestige : 公会威望
	-- members : 公会成员数
	-- desc : 公会宣言
	-- setting : 公会设置
	-- totemLevel : 图腾等级
	-- schoolLevel : 技能学堂等级
	-- storeLevel : 公会商店等级
	-- newApply : 1表示有新的入会申请
	-- id : 玩家ID
	-- headId : 玩家头像-头ID
	-- faceId : 玩家头像-脸ID
	-- name : 玩家名称
	-- level : 玩家等级
	-- post : 玩家公会职位
	-- donate : 玩家今日贡献
	-- totalDonate : 玩家总贡献
	-- loginTime : 玩家登陆时间
	-- isOnline : 0不在线1在线
	-- buyDonateTime : 购买捐献时间.1表示已购买，不能再购买了
	-- totemPayTime : 瞻仰倒计时
	-- sex : 性别
	-- presidentInfo : 会长信息
	WZLog("ProtocolProcessorSceneCommunity:parse_GUILD_GetGuildHallOk", guildwarStage, qualification)
	CacheCenter:setGuildInfo(guildId, guildName, guildLevel, prestige, members, desc, setting, totemLevel, schoolLevel, storeLevel, newApply, VectorToTable(id), VectorToTable(level), VectorToTable(post), VectorToTable(donate), VectorToTable(totalDonate), VectorToTable(buyDonateTime), VectorToTable(totemPayTime), VectorToTable(sex), VectorToTable(weekDonate), VectorToTable(lastDonate), VectorToTable(allDonate), VectorToTable(vipLevel), examine, joinVipLevel, guildwarStage, qualification, presidentInfo)
	if SceneMemberList then
		SceneMemberList:getCommunityMemberList(guildId, guildName, guildLevel, prestige, members, desc, setting, totemLevel, schoolLevel, storeLevel, newApply, VectorToTable(id), VectorToTable(headId), VectorToTable(faceId), VectorToTable(name), VectorToTable(level), VectorToTable(post), VectorToTable(donate), VectorToTable(totalDonate), VectorToTable(loginTime), VectorToTable(isOnline), VectorToTable(buyDonateTime), VectorToTable(totemPayTime), VectorToTable(sex), VectorToTable(weekDonate), VectorToTable(lastDonate), VectorToTable(allDonate), VectorToTable(vipLevel), maxDelCount, VectorToTable(headColor), VectorToTable(rmLevel), VectorToTable(tournamentLevel), rankMatchLevel, examine, VectorToTable(fight), VectorToTable(donateTime), declaration, VectorToTable(limitDonate), joinVipLevel, guildwarStage, qualification)
	end
	--更新瞻仰时间
	if SceneCommunityTotem.m_root ~= nil then
		SceneCommunityTotem:updateCountDown()
	end
	if SceneCommunityMain then
		SceneCommunityMain:getDataOk()
		SceneCommunityMain:closeLoading()
	end
	if WndCommunityAppoint.m_root ~= nil then
		WndCommunityAppoint:refresh()
	end
	if WndCommunityRemove.m_root ~= nil then
		WndCommunityRemove:update()
	end

	if WndCompeteAgent.m_root ~= nil then
		WndCompeteAgent:setCommunityMemberList(guildId, guildName, guildLevel, prestige, members, desc, setting, totemLevel, schoolLevel, storeLevel, newApply, VectorToTable(id), VectorToTable(headId), VectorToTable(faceId), VectorToTable(name), VectorToTable(level), VectorToTable(post), VectorToTable(donate), VectorToTable(totalDonate), VectorToTable(loginTime), VectorToTable(isOnline), VectorToTable(buyDonateTime), VectorToTable(totemPayTime), VectorToTable(sex), VectorToTable(weekDonate), VectorToTable(lastDonate), VectorToTable(allDonate), VectorToTable(vipLevel), maxDelCount, VectorToTable(headColor))
		WndCompeteAgent:refresh()
	end
end

--@brief	修改会员职位（GUILD_ChangePostOk = 19）
function ProtocolProcessorSceneCommunity:parse_GUILD_ChangePostOk()
	WZLog("ProtocolProcessorSceneCommunity:parse_GUILD_ChangePostOk")
	MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO96)
	--获取公会大厅
	ProtocolProcessorSceneCommunity:send_GUILD_GetGuildHall()
end

--@brief	开除会员（GUILD_ExpelMemberOk = 21）
function ProtocolProcessorSceneCommunity:parse_GUILD_ExpelMemberOk()
	WZLog("ProtocolProcessorSceneCommunity:parse_GUILD_ExpelMemberOk")
	MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO97)
	--获取公会大厅
	ProtocolProcessorSceneCommunity:send_GUILD_GetGuildHall()
end

--@brief	编辑公会宣言（GUILD_EditGuildDescOk = 23）
function ProtocolProcessorSceneCommunity:parse_GUILD_EditGuildDescOk(result)
	-- result : 1->超长;0->成功
	WZLog("ProtocolProcessorSceneCommunity:parse_GUILD_EditGuildDescOk")
	if result == 1 then
		MsgBoxManager:showTipBox(LocalStrings.COMMUNITY_DECLARElEN_ATT2)
	else
		MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO98)
	end
	--获取公会大厅
	ProtocolProcessorSceneCommunity:send_GUILD_GetGuildHall()
end

--@brief	公会升级（GUILD_GuildUpLeveOk = 25）
function ProtocolProcessorSceneCommunity:parse_GUILD_GuildUpLeveOk()
	WZLog("ProtocolProcessorSceneCommunity:parse_GUILD_GuildUpLeveOk")
	PopupResult("ui/common/common_icon_sjz.png")
    SoundManager:playEffectSound(SoundDefine.E_S_STRENGTHEN_SUCCESS)
	--获取公会大厅
	ProtocolProcessorSceneCommunity:send_GUILD_GetGuildHall()
end

--@brief	发送公会邮件（GUILD_SendGuildMailOk = 27）
function ProtocolProcessorSceneCommunity:parse_GUILD_SendGuildMailOk()
	WZLog("ProtocolProcessorSceneCommunity:parse_GUILD_SendGuildMailOk")
	MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO99)
end

--@brief	公会设置（GUILD_GuildSettingOk = 29）
function ProtocolProcessorSceneCommunity:parse_GUILD_GuildSettingOk()
	WZLog("ProtocolProcessorSceneCommunity:parse_GUILD_GuildSettingOk")
	MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO100)
end

--@brief	公会操作日志（GUILD_GetOperationLogOk = 31）
function ProtocolProcessorSceneCommunity:parse_GUILD_GetOperationLogOk(username, operator, action, level, createTime)
	-- username : 会员名
	-- operator : 操作人名
	-- action : 动作 1加入公会，2退出公会，3升职，4降职，5开除，6升级公会及公会建筑
	-- level : 操作后的级别
	-- createTime : 发生时间
	WZLog("ProtocolProcessorSceneCommunity:parse_GUILD_GetOperationLogOk",Serialize(VectorToTable(username)),Serialize(VectorToTable(operator)),Serialize(VectorToTable(action)),Serialize(VectorToTable(level)))
	--WndCommunityLog:setOperateLog(VectorToTable(username),VectorToTable(operator),VectorToTable(action),VectorToTable(level),VectorToTable(createTime))
	SceneMemberList:setOperateLog(VectorToTable(username),VectorToTable(operator),VectorToTable(action),VectorToTable(level),VectorToTable(createTime))
	if SceneCommunityMain and SceneCommunityMain.m_root then
		SceneCommunityMain:closeLoading()
	end
end

--@brief	公会捐献（GUILD_GuildDonateOk = 33）
function ProtocolProcessorSceneCommunity:parse_GUILD_GuildDonateOk()
	WZLog("ProtocolProcessorSceneCommunity:parse_GUILD_GuildDonateOk")
	MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO101)
	--获取公会大厅
	ProtocolProcessorSceneCommunity:send_GUILD_GetGuildHall()
end

--@brief	公会捐献日志（GUILD_GetDonateLogOk = 35）
function ProtocolProcessorSceneCommunity:parse_GUILD_GetDonateLogOk(username, costType, cost, reward, createTime)
	-- username : 会员名
	-- costType : 1消耗钻石2消耗金币
	-- cost : 消耗数量
	-- reward : 获得贡献值
	-- createTime : 发生时间
	WZLog("ProtocolProcessorSceneCommunity:parse_GUILD_GetDonateLogOk")
	--WndCommunityLog:setDonateLog(VectorToTable(username), VectorToTable(costType), VectorToTable(cost), VectorToTable(reward), VectorToTable(createTime))
	SceneMemberList:setDonateLog(VectorToTable(username), VectorToTable(costType), VectorToTable(cost), VectorToTable(reward), VectorToTable(createTime))
	if SceneCommunityMain and SceneCommunityMain.m_root then
		SceneCommunityMain:closeLoading()
	end
end

--@brief	公会建筑升级（GUILD_BuildUpLevelOk = 37）
function ProtocolProcessorSceneCommunity:parse_GUILD_BuildUpLevelOk()
	WZLog("ProtocolProcessorSceneCommunity:parse_GUILD_BuildUpLevelOk")
    SoundManager:playEffectSound(SoundDefine.E_S_STRENGTHEN_SUCCESS)
	local guildInfo = CacheCenter:getGuildInfo()
	local cost = 0
	if GUILDUPGRADETYPE == 1 then
		PopupResult("ui/common/common_icon_sjz.png")
		--更新图腾等级
		guildInfo.totemLevel = guildInfo.totemLevel + 1
		--更新图腾威望
		for k,v in pairs(GDatatab_guild_building) do
			if v.type == GUILDUPGRADETYPE and v.level == (guildInfo.totemLevel) then
				cost = v.cost[1][2]
			end
		end 
		guildInfo.prestige = guildInfo.prestige - cost
		SceneCommunityTotem:_update()
	end
	if GUILDUPGRADETYPE == 2 then
		PopupResult("ui/common/common_icon_sjz.png")
		--更新技能学院等级
		guildInfo.schoolLevel = guildInfo.schoolLevel + 1
		--更新公会威望
		for k,v in pairs(GDatatab_guild_building) do
			if v.type == GUILDUPGRADETYPE and v.level == (guildInfo.schoolLevel) then
				cost = v.cost[1][2]
			end
		end 
		guildInfo.prestige = guildInfo.prestige - cost
		SceneCommunitySkill:_update()
	end
	if GUILDUPGRADETYPE == 3 then
		PopupResult("ui/common/common_icon_sjz.png")
		--更新商店等级
		guildInfo.storeLevel = guildInfo.storeLevel + 1
		--更新公会威望
		for k,v in pairs(GDatatab_guild_building) do
			if v.type == GUILDUPGRADETYPE and v.level == (guildInfo.storeLevel) then
				cost = v.cost[1][2]
			end
		end
		guildInfo.prestige = guildInfo.prestige - cost
		WndStore:communityShopUpdateSuccess()
	end
	if SceneCommunityMain and SceneCommunityMain.m_root then
		SceneCommunityMain:closeLoading()
		SceneCommunityMain:getDataOk()
	end
end

--@brief	图腾瞻仰（GUILD_TotemPayOk = 39）
function ProtocolProcessorSceneCommunity:parse_GUILD_TotemPayOk()
	WZLog("ProtocolProcessorSceneCommunity:parse_GUILD_TotemPayOk")
	MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO102)
	if SceneCommunityTotem then
		SceneCommunityTotem:learnSuccess()
	end
	if SceneCommunityMain and SceneCommunityMain.m_root then
		SceneCommunityMain:closeLoading()
	end
end

--@brief	获取玩家公会技能（GUILD_GetGuildSkillOk = 41）
function ProtocolProcessorSceneCommunity:parse_GUILD_GetGuildSkillOk(id, level)
	-- id : 技能ID（对应道具属性表）
	-- level : 技能等级
	WZLog("ProtocolProcessorSceneCommunity:parse_GUILD_GetGuildSkillOk",Serialize(VectorToTable(id)),Serialize(VectorToTable(level)))
	SceneCommunitySkill:setSkillLevel(VectorToTable(id),VectorToTable(level))
	--取消圆圈的转动效果
	MsgBoxManager:stopLoadingBoxByMsgId(SceneCommunitySkill.m_nLoadingCircleId)
	SceneCommunitySkill.m_nLoadingCircleId = nil
end

--@brief	学习公会技能（GUILD_LearnGuildSkillOk = 43）
function ProtocolProcessorSceneCommunity:parse_GUILD_LearnGuildSkillOk()
	WZLog("ProtocolProcessorSceneCommunity:parse_GUILD_LearnGuildSkillOk")
	--取消圆圈的转动效果
	MsgBoxManager:stopLoadingBoxByMsgId(SceneCommunitySkill.m_nLoadingCircleId)
end

--@brief	获取公会商店（GUILD_GetGuildStoreOk = 45）
function ProtocolProcessorSceneCommunity:parse_GUILD_GetGuildStoreOk(storeId, store, cost, status, guildLevel, refreshCount, nextRefreshTime)
	-- storeId : 商店ID（购买时使用该ID）
	-- store : 商品,格式[100,2]
	-- cost : 购买消耗，格式[7,100]
	-- status : 状态0未买过，1已买过了
	-- guildLevel : 公会等级限制
	-- refreshCount : 剩余刷新次数
	-- nextRefreshTime : 下次自动刷新时间
	WZLog("ProtocolProcessorSceneCommunity:parse_GUILD_GetGuildStoreOk", Serialize(VectorToTable(refreshCount)))
	SceneCommunityShop:setShopList(VectorToTable(storeId), VectorToTable(store), VectorToTable(cost), VectorToTable(status), VectorToTable(guildLevel), VectorToTable(refreshCount), VectorToTable(nextRefreshTime))
end

--@brief	获取公会战列表（GUILD_GetGuildWarOk = 50）
function ProtocolProcessorSceneCommunity:parse_GUILD_GetGuildWarOk(warCount, winCount, first, second, third, name2, warCount2, winCount2, score2, rank2, timeLeft, roomId, roomName, playerNumMode, playerNum, roomStatus)
	-- warCount : 历史战斗次数
	-- winCount : 历史战斗胜利次数
	-- first : 冠军次数
	-- second : 亚军次数
	-- third : 季军次数
	-- name2 : 上周冠军公会名称
	-- warCount2 : 上周冠军公会本周战斗次数
	-- winCount2 : 上周冠军公会本周战斗胜利次数
	-- score2 : 上周冠军公会当前积分
	-- rank2 : 上周冠军公会当前排名
	-- roomId : 房间ID
	-- roomName : 房间名称
	-- playerNumMode : 对战人数模式:2=2v2， 3=3v3
	-- playerNum : 房间当前人数
	-- roomStatus : 房间状态： 0表示等待中， 1表示战斗
	WZLog("ProtocolProcessorSceneCommunity:parse_GUILD_GetGuildWarOk")
    WndCommunityHall:setCommunityHallData(warCount,winCount,first,second,third,name2,warCount2,winCount2,score2,rank2,timeLeft,VectorToTable(roomId),VectorToTable(playerNumMode),VectorToTable(playerNum),VectorToTable(roomStatus))
end

--@brief	获取公会战公会排名列表（GUILD_GetGuildWarRankOk = 54）
function ProtocolProcessorSceneCommunity:parse_GUILD_GetGuildWarRankOk(rank, id, name, war, win, score, totalPage)
	-- rank : 排名
	-- id : 公会ID
	-- name : 公会名称
	-- war : 公会战次数
	-- win : 公会战胜利次数
	-- score : 公会战积分
	-- totalPage : 总页数
	WZLog("ProtocolProcessorSceneCommunity:parse_GUILD_GetGuildWarRankOk",Serialize(VectorToTable(name)),WndCommunityRank)
	--if WndCommunityRank and WndCommunityRank.m_root ~= nil then
	if WndCommunityRank then
		WndCommunityRank:setData(VectorToTable(rank), VectorToTable(id), VectorToTable(name), VectorToTable(war), VectorToTable(win), VectorToTable(score), totalPage)
	end
end

--@brief	获取公会周排名列表（GUILD_GetGuildWeekRankOk = 56）
function ProtocolProcessorSceneCommunity:parse_GUILD_GetGuildWeekRankOk(rank, id, name, level, prestige, weekPrestige, totalPage, rankType, setting, rankMatchLevel, members, joinVipLevel)
	-- rank : 排名
	-- id : 公会ID
	-- name : 公会名称
	-- level : 公会等级
	-- prestige : 公会威望
	-- weekPrestige : 本周新增威望
	-- totalPage : 总页数
	-- rankType : 0周排名，1历史排名
	WZLog("ProtocolProcessorSceneCommunity:parse_GUILD_GetGuildWeekRankOk")
	SceneCommunity:getCommunityListNew(VectorToTable(rank), VectorToTable(id), VectorToTable(name), VectorToTable(level), VectorToTable(weekPrestige), VectorToTable(totalPage), {}, VectorToTable(setting), VectorToTable(rankMatchLevel), VectorToTable(members), VectorToTable(joinVipLevel))
end

--@brief	获取玩家工会任务列表（GUILD_RequestGuildTaskOk = 58）
function ProtocolProcessorSceneCommunity:parse_GUILD_RequestGuildTaskOk(playerid, faceid, headid, level, itime, vipLevel, job, online, msgList, name, sex, idList, totalCount, currCount, headColor, refresh, taskType)
	-- playerid : 留言的玩家的id列表
	-- faceid : 脸
	-- headid : 头像
	-- level : 等级
	-- itime : 发表时间
	-- vipLevel : vip等级
	-- job : 职业,长老，精英
	-- online : 是否在线
	-- msgList : 留言内容
	-- name : 玩家名称
	-- sex : 玩家性别
	-- idList : 任务id列表
	-- totalCount : 任务总量
	-- currCount : 工会当前完成量
	-- taskType : 任务类型（-1 未发布 0 今天 1 明天 2 后天）
	WZLog("ProtocolProcessorSceneCommunity:parse_GUILD_RequestGuildTaskOk",Serialize(VectorToTable(online)))
	WndCommunityTask:setData(VectorToTable(playerid), VectorToTable(faceid), VectorToTable(headid), VectorToTable(level), VectorToTable(itime), VectorToTable(vipLevel), VectorToTable(job), VectorToTable(online), VectorToTable(msgList), VectorToTable(name), VectorToTable(sex), VectorToTable(idList), VectorToTable(totalCount), VectorToTable(currCount), VectorToTable(taskType), VectorToTable(headColor), refresh)
end

--@brief	获取玩家工会基金奖励列表（GUILD_RequestFundRewardOk = 60）
function ProtocolProcessorSceneCommunity:parse_GUILD_RequestFundRewardOk(success, content, currFund)
	-- success : 1成功0失败
	-- content : 奖励划分
	-- currFund : 工会当前基金数量
	WZLog("ProtocolProcessorSceneCommunity:parse_GUILD_RequestFundRewardOk")
	WndCommunityTask:setData1(success, content, currFund)
end

--@brief	获取任务列表（GUILD_RequestFlushTaskOk = 62）
function ProtocolProcessorSceneCommunity:parse_GUILD_RequestFlushTaskOk(success)
	-- success : 1成功0失败
	WZLog("ProtocolProcessorSceneCommunity:parse_GUILD_RequestFlushTaskOk")
	if success == 2 then
		MsgBoxManager:showTipBox(LocalStrings.CANTOPER)
		WndCommunityTask.m_bPublishing = false
		WndCommunityTask.m_bJurisdiction = 0
		WndCommunityTask:showSendMsg()
	end
end

--@brief	留言成功失败（GUILD_LeaveMsgOk = 64）
function ProtocolProcessorSceneCommunity:parse_GUILD_LeaveMsgOk(success)
	-- success : 1成功0失败
	WZLog("ProtocolProcessorSceneCommunity:parse_GUILD_LeaveMsgOk")
	if success == 1 then
		MsgBoxManager:showTipBox(LocalStrings.HAVED_SEND)
	end
end

--@brief	发布任务成功（GUILD_PublishTaskOk = 66）
function ProtocolProcessorSceneCommunity:parse_GUILD_PublishTaskOk(success)
	-- success : 1成功0失败
	WZLog("ProtocolProcessorSceneCommunity:parse_GUILD_PublishTaskOk")
	if success == 1 then
		MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO122)
	end
	if success == 2 then
		MsgBoxManager:showTipBox(LocalStrings.CANTOPER)
		WndCommunityTask.m_bPublishing = false
		WndCommunityTask.m_bJurisdiction = 0
		WndCommunityTask:showSendMsg()
	end
end

--@brief	修改会员职位（GUILD_ChangeMemberPostOk = 69）
function ProtocolProcessorSceneCommunity:parse_GUILD_ChangeMemberPostOk()
	WZLog("ProtocolProcessorSceneCommunity:parse_GUILD_ChangeMemberPostOk")
	MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO137)
	--获取公会大厅
	ProtocolProcessorSceneCommunity:send_GUILD_GetGuildHall()
end

--@brief	推送公会弹劾信息（GUILD_ImpeachInfo = 70）
function ProtocolProcessorSceneCommunity:parse_GUILD_ImpeachInfo(captainName, offlineDays, memberNum, agreeNum, voteStatus, impeachCountDown)
	-- captainName : 会长名称
	-- offlineDays : 离线天数
	-- memberNum : 会员总数
	-- agreeNum : 弹劾玩家数目
	-- voteStatus : 玩家本人投票状态,0:不可投票;1:可投票;2:已投票
	-- impeachCountDown : 发起弹劾倒计时
	WZLog("ProtocolProcessorSceneCommunity:parse_GUILD_ImpeachInfo", offlineDays)
	WndImpeach:setData(captainName, offlineDays, memberNum, agreeNum, voteStatus, impeachCountDown)
end

--@brief	投票成功（GUILD_ImpeachVoteOk = 72）
function ProtocolProcessorSceneCommunity:parse_GUILD_ImpeachVoteOk()
	WZLog("ProtocolProcessorSceneCommunity:parse_GUILD_ImpeachVoteOk")
	ProtocolProcessorSceneCommunity:send_GUILD_GetImpeachInfo( )
end

--@brief	邀请（GUILD_InviteOk = 93）
function ProtocolProcessorSceneCommunity:parse_GUILD_InviteOk()
	WZLog("ProtocolProcessorSceneCommunity:parse_GUILD_InviteOk")
end

--@brief	被邀请（GUILD_BeInvite = 94）
function ProtocolProcessorSceneCommunity:parse_GUILD_BeInvite(senderName, guildName, guildId)
	-- senderName : 发送玩家名称
	-- guildName : 公会名称
	-- guildId : 公会id
	WZLog("ProtocolProcessorSceneCommunity:parse_GUILD_BeInvite")
	SceneMemberList.inviteId = guildId
    WndInvited:showInterface(SceneMemberList, SceneMemberList.onAcceptInvite, nil, nil,nil, string.format(LocalStrings.COMMUNITYINFO234, senderName, guildName))
end

--@brief	响应邀请（GUILD_ResponseInviteOk = 96）
function ProtocolProcessorSceneCommunity:parse_GUILD_ResponseInviteOk()
	WZLog("ProtocolProcessorSceneCommunity:parse_GUILD_ResponseInviteOk")
   	replaceScene(SceneCommunityMain:createElement())
end

--@brief	获取公会副本boss伤害排行（GUILD_GetGuildBossHurtRankOk = 98）
function ProtocolProcessorSceneCommunity:parse_GUILD_GetGuildBossHurtRankOk(myRank, playerId, rank, name, faceId, headId, headColor, sex, level, vipLevel, hurt, percent)
	-- myRank : 当前玩家的排行(0为没在排行榜里)
	-- playerId : 玩家ID
	-- rank : 排名
	-- name : 玩家名称
	-- faceId : 脸ID
	-- headId : 头ID
	-- headColor : 头颜色
	-- sex : 性别
	-- level : 玩家等级
	-- vipLevel : 玩家VIP等级
	-- hurt : 玩家对该boss造成的伤害
	-- percent : 玩家对该boss造成的伤害百分比(带%)
	WZLog("ProtocolProcessorSceneCommunity:parse_GUILD_GetGuildBossHurtRankOk")
	WndCommunityCopyRank:setData( myRank, VectorToTable(playerId), VectorToTable(rank), VectorToTable(name), VectorToTable(faceId), VectorToTable(headId), VectorToTable(headColor), VectorToTable(sex), VectorToTable(level), VectorToTable(vipLevel), VectorToTable(hurt), VectorToTable(percent))
end
-------------------------------------协议错误处理方法模块--------------------------------------
--@brief	创建公会（GUILD_CreateGuild = 1）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneCommunity:send_GUILD_CreateGuild_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneCommunity:send_GUILD_CreateGuild_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_CreateGuild, nflag, sMessage)
	MsgBoxManager:showTipBox(sMessage)
	SceneCommunityMain:closeLoading()
end

--@brief	获取公会列表（GUILD_GetGuildList = 3）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneCommunity:send_GUILD_GetGuildList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneCommunity:send_GUILD_GetGuildList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildList, nflag, sMessage)
end

--@brief	获取公会（GUILD_GetGuild = 5）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneCommunity:send_GUILD_GetGuild_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneCommunity:send_GUILD_GetGuild_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_GetGuild, nflag, sMessage)
	SceneCommunity:getCommunityInfoError(sMessage)
end

--@brief	申请公会（GUILD_ApplyGuild = 7）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneCommunity:send_GUILD_ApplyGuild_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneCommunity:send_GUILD_ApplyGuild_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_ApplyGuild, nflag, sMessage)
end

--@brief	获取审批人列表（GUILD_GetApplyerList = 9）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneCommunity:send_GUILD_GetApplyerList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneCommunity:send_GUILD_GetApplyerList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_GetApplyerList, nflag, sMessage)
end

--@brief	审批（GUILD_Approval = 11）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneCommunity:send_GUILD_Approval_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneCommunity:send_GUILD_Approval_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_Approval, nflag, sMessage)
end

--@brief	退出公会（GUILD_Resignations = 12）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneCommunity:send_GUILD_Resignations_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneCommunity:send_GUILD_Resignations_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_Resignations, nflag, sMessage)
end

--@brief	转让会长（GUILD_Abdicate = 14）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneCommunity:send_GUILD_Abdicate_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneCommunity:send_GUILD_Abdicate_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_Abdicate, nflag, sMessage)
end

--@brief	获取公会大厅（GUILD_GetGuildHall = 16）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneCommunity:send_GUILD_GetGuildHall_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneCommunity:send_GUILD_GetGuildHall_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildHall, nflag, sMessage)
end

--@brief	修改会员职位（GUILD_ChangePost = 18）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneCommunity:send_GUILD_ChangePost_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneCommunity:send_GUILD_ChangePost_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_ChangePost, nflag, sMessage)
end

--@brief	开除会员（GUILD_ExpelMember = 20）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneCommunity:send_GUILD_ExpelMember_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneCommunity:send_GUILD_ExpelMember_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_ExpelMember, nflag, sMessage)
end

--@brief	编辑公会宣言（GUILD_EditGuildDesc = 22）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneCommunity:send_GUILD_EditGuildDesc_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneCommunity:send_GUILD_EditGuildDesc_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_EditGuildDesc, nflag, sMessage)
end

--@brief	公会升级（GUILD_GuildUpLevel = 24）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneCommunity:send_GUILD_GuildUpLevel_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneCommunity:send_GUILD_GuildUpLevel_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_GuildUpLevel, nflag, sMessage)
end

--@brief	发送公会邮件（GUILD_SendGuildMail = 26）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneCommunity:send_GUILD_SendGuildMail_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneCommunity:send_GUILD_SendGuildMail_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_SendGuildMail, nflag, sMessage)
end

--@brief	公会设置（GUILD_GuildSetting = 28）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneCommunity:send_GUILD_GuildSetting_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneCommunity:send_GUILD_GuildSetting_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_GuildSetting, nflag, sMessage)
end

--@brief	公会操作日志（GUILD_GetOperationLog = 30）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneCommunity:send_GUILD_GetOperationLog_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneCommunity:send_GUILD_GetOperationLog_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_GetOperationLog, nflag, sMessage)
end

--@brief	公会捐献（GUILD_GuildDonate = 32）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneCommunity:send_GUILD_GuildDonate_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneCommunity:send_GUILD_GuildDonate_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_GuildDonate, nflag, sMessage)
end

--@brief	公会捐献日志（GUILD_GetDonateLog = 34）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneCommunity:send_GUILD_GetDonateLog_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneCommunity:send_GUILD_GetDonateLog_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_GetDonateLog, nflag, sMessage)
end

--@brief	公会建筑升级（GUILD_BuildUpLevel = 36）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneCommunity:send_GUILD_BuildUpLevel_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneCommunity:send_GUILD_BuildUpLevel_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_BuildUpLevel, nflag, sMessage)
end

--@brief	图腾瞻仰（GUILD_TotemPay = 38）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneCommunity:send_GUILD_TotemPay_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneCommunity:send_GUILD_TotemPay_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_TotemPay, nflag, sMessage)
end

--@brief	获取玩家公会技能（GUILD_GetGuildSkill = 40）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneCommunity:send_GUILD_GetGuildSkill_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneCommunity:send_GUILD_GetGuildSkill_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildSkill, nflag, sMessage)
end

--@brief	学习公会技能（GUILD_LearnGuildSkill = 42）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneCommunity:send_GUILD_LearnGuildSkill_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneCommunity:send_GUILD_LearnGuildSkill_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_LearnGuildSkill, nflag, sMessage)
end

--@brief	获取公会商店（GUILD_GetGuildStore = 44）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneCommunity:send_GUILD_GetGuildStore_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneCommunity:send_GUILD_GetGuildStore_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildStore, nflag, sMessage)
end

--@brief	刷新公会商店（GUILD_RefreshGuildStore = 48）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneCommunity:send_GUILD_RefreshGuildStore_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneCommunity:send_GUILD_RefreshGuildStore_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_RefreshGuildStore, nflag, sMessage)
end

--@brief	获取公会战列表（GUILD_GetGuildWar = 49）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneCommunity:send_GUILD_GetGuildWar_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneCommunity:send_GUILD_GetGuildWar_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildWar, nflag, sMessage)
end

--@brief	创建公会战房间（GUILD_CreateWarRoom = 51）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneCommunity:send_GUILD_CreateWarRoom_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneCommunity:send_GUILD_CreateWarRoom_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_CreateWarRoom, nflag, sMessage)
end

--@brief	快速加入公会战房间（GUILD_QuickGame = 52）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneCommunity:send_GUILD_QuickGame_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneCommunity:send_GUILD_QuickGame_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_QuickGame, nflag, sMessage)
end

--@brief	获取公会战公会排名列表（GUILD_GetGuildWarRank = 53）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneCommunity:send_GUILD_GetGuildWarRank_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneCommunity:send_GUILD_GetGuildWarRank_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildWarRank, nflag, sMessage)
end

--@brief	获取公会周排名列表（GUILD_GetGuildWeekRank = 55）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneCommunity:send_GUILD_GetGuildWeekRank_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneCommunity:send_GUILD_GetGuildWeekRank_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildWeekRank, nflag, sMessage)
end

--@brief	获取玩家工会任务列表（GUILD_RequestGuildTask = 57）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneCommunity:send_GUILD_RequestGuildTask_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneCommunity:send_GUILD_RequestGuildTask_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_RequestGuildTask, nflag, sMessage)
end

--@brief	获取玩家工会基金奖励列表（GUILD_RequestFundReward = 59）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneCommunity:send_GUILD_RequestFundReward_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneCommunity:send_GUILD_RequestFundReward_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_RequestFundReward, nflag, sMessage)
end

--@brief	请求刷新任务列表（GUILD_RequestFlushTask = 61）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneCommunity:send_GUILD_RequestFlushTask_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneCommunity:send_GUILD_RequestFlushTask_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_RequestFlushTask, nflag, sMessage)
end

--@brief	请求留言（GUILD_LeaveMsg = 63）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneCommunity:send_GUILD_LeaveMsg_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneCommunity:send_GUILD_LeaveMsg_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_LeaveMsg, nflag, sMessage)
end

--@brief	会长发布任务（GUILD_PublishTask = 65）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneCommunity:send_GUILD_PublishTask_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneCommunity:send_GUILD_PublishTask_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_PublishTask, nflag, sMessage)
end

--@brief	修改会员职位（GUILD_ChangeMemberPost = 68）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneCommunity:send_GUILD_ChangeMemberPost_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneCommunity:send_GUILD_ChangeMemberPost_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_ChangeMemberPost, nflag, sMessage)
end

--@brief	获取公会弹劾信息（GUILD_GetImpeachInfo = 73）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneCommunity:send_GUILD_GetImpeachInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneCommunity:send_GUILD_GetImpeachInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_GetImpeachInfo, nflag, sMessage)
end

--@brief	投票（GUILD_ImpeachVote = 71）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneCommunity:send_GUILD_ImpeachVote_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneCommunity:send_GUILD_ImpeachVote_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_ImpeachVote, nflag, sMessage)
end

--@brief	邀请（GUILD_Invite = 92）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneCommunity:send_GUILD_Invite_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneCommunity:send_GUILD_Invite_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_Invite, nflag, sMessage)
end

--@brief	响应邀请（GUILD_ResponseInvite = 95）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneCommunity:send_GUILD_ResponseInvite_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneCommunity:send_GUILD_ResponseInvite_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_ResponseInvite, nflag, sMessage)
end

--@brief	获取公会副本boss伤害排行（GUILD_GetGuildBossHurtRank = 97）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneCommunity:send_GUILD_GetGuildBossHurtRank_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneCommunity:send_GUILD_GetGuildBossHurtRank_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildBossHurtRank, nflag, sMessage)
end
