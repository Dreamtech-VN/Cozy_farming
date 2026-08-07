--ProtocolProcessorWndLeague.lua
--@brief	英雄联赛相关协议
--@date  	2016/6/24
--@author 	zsq
--@note 	英雄联赛相关协议


ProtocolProcessorWndLeague = ProtocolProcessorBase:new()


--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorWndLeague:regAll()
	--@brief	创建战队（HERO_CreateTeam=1）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_CreateTeam, "ProtocolProcessorWndLeague:send_HERO_CreateTeam_ErrorProcess", "is" )
	--@brief	获取战队列表（HERO_GetHeroTeamList = 3）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_GetHeroTeamList, "ProtocolProcessorWndLeague:send_HERO_GetHeroTeamList_ErrorProcess", "is" )
	--@brief	申请战队（HERO_ApplyHeroTeam = 5）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_ApplyHeroTeam, "ProtocolProcessorWndLeague:send_HERO_ApplyHeroTeam_ErrorProcess", "is" )
	--@brief	获取英雄联赛战队申请列表（HERO_GetApplyList = 7）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_GetApplyList, "ProtocolProcessorWndLeague:send_HERO_GetApplyList_ErrorProcess", "is" )
	--@brief	审核申请列表（HERO_Reviewed = 9）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_Reviewed, "ProtocolProcessorWndLeague:send_HERO_Reviewed_ErrorProcess", "is" )
	--@brief	查找战队（HERO_SearchTeam = 11）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_SearchTeam, "ProtocolProcessorWndLeague:send_HERO_SearchTeam_ErrorProcess", "is" )
	--@brief	退出战队（HERO_OutTeam = 13）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_OutTeam, "ProtocolProcessorWndLeague:send_HERO_OutTeam_ErrorProcess", "is" )
	--@brief	踢出战队（HERO_KickTeam = 15）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_KickTeam, "ProtocolProcessorWndLeague:send_HERO_KickTeam_ErrorProcess", "is" )
	--@brief	邀请加入战队（HERO_Invitation = 17）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_Invitation, "ProtocolProcessorWndLeague:send_HERO_Invitation_ErrorProcess", "is" )
	--@brief	同意加入战队（HERO_Agree = 19）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_Agree, "ProtocolProcessorWndLeague:send_HERO_Agree_ErrorProcess", "is" )
	--@brief	进入战队界面准备战斗（HERO_ReadyFight = 21）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_ReadyFight, "ProtocolProcessorWndLeague:send_HERO_ReadyFight_ErrorProcess", "is" )
	--@brief	匹配战斗（HERO_MakePairHero = 23）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_MakePairHero, "ProtocolProcessorWndLeague:send_HERO_MakePairHero_ErrorProcess", "is" )
	--@brief	退出战队界面（HERO_OutHeroRoom = 24）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_OutHeroRoom, "ProtocolProcessorWndLeague:send_HERO_OutHeroRoom_ErrorProcess", "is" )
	--@brief	取消匹配（HERO_EndMakePairHero = 28）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_EndMakePairHero, "ProtocolProcessorWndLeague:send_HERO_EndMakePairHero_ErrorProcess", "is" )
	--@brief	报名参加小组赛（HERO_SignHeroStrong = 29）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_SignHeroStrong, "ProtocolProcessorWndLeague:send_HERO_SignHeroStrong_ErrorProcess", "is" )
	--@brief	队长切换成员状态（HERO_ChangeStatus = 31）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_ChangeStatus, "ProtocolProcessorWndLeague:send_HERO_ChangeStatus_ErrorProcess", "is" )
	--@brief	修改宣言和图片（HERO_NewPhotoAndDec=34）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_NewPhotoAndDec, "ProtocolProcessorWndLeague:send_HERO_NewPhotoAndDec_ErrorProcess", "is" )
	--@brief	海选赛排行（HERO_FirstSelectRank = 73）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_FirstSelectRank, "ProtocolProcessorWndLeague:send_HERO_FirstSelectRank_ErrorProcess", "is" )
	--@brief	小组赛结果（HERO_TeamSelectRank = 75）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_TeamSelectRank, "ProtocolProcessorWndLeague:send_HERO_TeamSelectRank_ErrorProcess", "is" )
	--@brief	16强（HERO_Team16SelectStatus = 77）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_Team16SelectStatus, "ProtocolProcessorWndLeague:send_HERO_Team16SelectStatus_ErrorProcess", "is" )
	--@brief	8强战况（HERO_Team8SelectStatus = 79）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_Team8SelectStatus, "ProtocolProcessorWndLeague:send_HERO_Team8SelectStatus_ErrorProcess", "is" )
	--@brief	海选赛奖励（HERO_FirstSelectReward = 71）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_FirstSelectReward, "ProtocolProcessorWndLeague:send_HERO_FirstSelectReward_ErrorProcess", "is" )
	--@brief	获取历届冠军队列表（HERO_TeamFirstList = 81）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_TeamFirstList, "ProtocolProcessorWndLeague:send_HERO_TeamFirstList_ErrorProcess", "is" )
	--@brief	获取某一冠军队的详细信息（HERO_TeamFirstDetail = 83）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_TeamFirstDetail, "ProtocolProcessorWndLeague:send_HERO_TeamFirstDetail_ErrorProcess", "is" )
	--@brief	请求英雄联赛战斗回放列表（HERO_RecordList=37）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_RecordList, "ProtocolProcessorWndLeague:send_HERO_RecordList_ErrorProcess", "is" )
	--@brief	请求战斗回放详细信息（HERO_RecordMes=41）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_RecordMes, "ProtocolProcessorWndLeague:send_HERO_RecordMes_ErrorProcess", "is" )
	--@brief	请求播放英雄联赛战斗回放列表（HERO_Record=39）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_Record, "ProtocolProcessorWndLeague:send_HERO_Record_ErrorProcess", "is" )
	--@brief	请求英雄联赛观战列表（HERO_WatchList=43）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_WatchList, "ProtocolProcessorWndLeague:send_HERO_WatchList_ErrorProcess", "is" )
	--@brief	获得报名参加的玩家列表（HERO_GetEnterPlayerList = 87）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_GetEnterPlayerList, "ProtocolProcessorWndLeague:send_HERO_GetEnterPlayerList_ErrorProcess", "is" )
	--@brief	邀请进入战队准备(HERO_InvitationReady = 53)错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_InvitationReady, "ProtocolProcessorWndLeague:send_HERO_InvitationReady_ErrorProcess", "is" )
--@brief	准备战斗(HERO_Ready = 59)错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_Ready, "ProtocolProcessorWndLeague:send_HERO_Ready_ErrorProcess", "is" )
--@brief	取消战斗准备(HERO_CancelReady = 60)错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_CancelReady, "ProtocolProcessorWndLeague:send_HERO_CancelReady_ErrorProcess", "is" )
--@brief	提升为副队长(HERO_Promotion = 61)错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_Promotion, "ProtocolProcessorWndLeague:send_HERO_Promotion_ErrorProcess", "is" )
--@brief	取消副队长(HERO_Cancel  = 62)错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_Cancel, "ProtocolProcessorWndLeague:send_HERO_Cancel_ErrorProcess", "is" )
	
	--@brief	英雄联赛开始时间（HERO_HeroStartTime = 85）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_HeroStartTime, "ProtocolProcessorWndLeague:send_HERO_HeroStartTime_ErrorProcess", "is" )
	--@brief	创建战队成功（HERO_CreateTeamOK=2）
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_CreateTeamOK, "ProtocolProcessorWndLeague:parse_HERO_CreateTeamOK", "issviisiii")
	--@brief	获取战队列表（HERO_GetHeroTeamListOK = 4）
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_GetHeroTeamListOK, "ProtocolProcessorWndLeague:parse_HERO_GetHeroTeamListOK", "vivsvivs")
	--@brief	申请战队（HERO_ApplyHeroTeamOK = 6）
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_ApplyHeroTeamOK, "ProtocolProcessorWndLeague:parse_HERO_ApplyHeroTeamOK", "i")
	--@brief	获取英雄联赛战队申请列表成功（HERO_GetApplyListOK = 8）
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_GetApplyListOK, "ProtocolProcessorWndLeague:parse_HERO_GetApplyListOK", "vivivsvivivivivivivi")
	--@brief	审核申请列表成功返回申请列表（HERO_ReviewedOK = 10）
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_ReviewedOK, "ProtocolProcessorWndLeague:parse_HERO_ReviewedOK", "vivivsvivivivi")
	--@brief	查找战队（HERO_SearchTeamOK = 12）
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_SearchTeamOK, "ProtocolProcessorWndLeague:parse_HERO_SearchTeamOK", "sisssviviviviivivivivsivivi")
	--@brief	退出战队（HERO_OutTeamOK = 14）
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_OutTeamOK, "ProtocolProcessorWndLeague:parse_HERO_OutTeamOK", "")
	--@brief	踢出战队（HERO_KickTeamOK = 16）
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_KickTeamOK, "ProtocolProcessorWndLeague:parse_HERO_KickTeamOK", "vi")
	--@brief	邀请加入战队，被邀请人收到（HERO_InvitationOK = 18）
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_InvitationOK, "ProtocolProcessorWndLeague:parse_HERO_InvitationOK", "iss")
	--@brief	同意加入战队（HERO_AgreeOK = 20）
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_AgreeOK, "ProtocolProcessorWndLeague:parse_HERO_AgreeOK", "issviisiii")
	--@brief	进入战队界面准备战斗，战队界面成员收到（HERO_ReadyFightOK = 22）
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_ReadyFightOK, "ProtocolProcessorWndLeague:parse_HERO_ReadyFightOK", "isssviviviviviiiiiviviivivsvissvivsivivsiviisviiivivissssssvivivivivi")
	--@brief	退出战队界面，战队界面成员收到（HERO_OutHeroRoomOK = 25）
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_OutHeroRoomOK, "ProtocolProcessorWndLeague:parse_HERO_OutHeroRoomOK", "vivivivivivivi")
	--@brief	报名参加小组赛成功（HERO_SignHeroStrongOk = 30）
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_SignHeroStrongOk, "ProtocolProcessorWndLeague:parse_HERO_SignHeroStrongOk", "")
	--@brief	队长切换成员状态，所有在战队界面成员都会收到（HERO_ChangeStatuOk = 32）
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_ChangeStatuOk, "ProtocolProcessorWndLeague:parse_HERO_ChangeStatuOk", "isssviviviviviiiiiviviivivsvissvivs")
	--@brief	更新玩家战队Id（HERO_ChangeTeamOk = 33）
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_ChangeTeamOk, "ProtocolProcessorWndLeague:parse_HERO_ChangeTeamOk", "i")
	--@brief	修改宣言和图片（HERO_NewPhotoAndDecOK=35）
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_NewPhotoAndDecOK, "ProtocolProcessorWndLeague:parse_HERO_NewPhotoAndDecOK", "issviisiii")
	--@brief	审核小红点（队长才能收到）(HERO_ReviewRedDot = 55)
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_ReviewRedDot, "ProtocolProcessorWndLeague:parse_HERO_ReviewRedDot", "")
	--@brief	匹配战斗失败(HERO_MakePairHeroFail = 58)
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_MakePairHeroFail, "ProtocolProcessorWndLeague:parse_HERO_MakePairHeroFail", "i")
	--@brief	海选赛排行（HERO_FirstSelectRankOk = 74）
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_FirstSelectRankOk, "ProtocolProcessorWndLeague:parse_HERO_FirstSelectRankOk", "iiissvivivsvivivivs")
	--@brief	海选赛排行（HERO_TeamSelectRankOk = 76））
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_TeamSelectRankOk, "ProtocolProcessorWndLeague:parse_HERO_TeamSelectRankOk", "ssssssvivsvs")
	--@brief	小组赛战况（HERO_Team16SelectStatusOk = 78）
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_Team16SelectStatusOk, "ProtocolProcessorWndLeague:parse_HERO_Team16SelectStatusOk", "ssssssvivsvsvs")
	--@brief	8强战况（HERO_TeamSelectRankOk = 80）
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_Team8SelectStatusOk, "ProtocolProcessorWndLeague:parse_HERO_Team8SelectStatusOk", "ssssssssssssssssssvivsvsvivsvsvivsvsissississi")
	--@brief	海选赛参与奖励（HERO_FirstSelectRewardOk = 72）
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_FirstSelectRewardOk, "ProtocolProcessorWndLeague:parse_HERO_FirstSelectRewardOk", "vivtvivissiisii")
	--@brief	获取历届冠军队列表成功（HERO_TeamFirstListOk = 82）
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_TeamFirstListOk, "ProtocolProcessorWndLeague:parse_HERO_TeamFirstListOk", "vivsvi")
	--@brief	荣誉某一届冠军队伍信息（HERO_TeamFirstDetailOk = 84）
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_TeamFirstDetailOk, "ProtocolProcessorWndLeague:parse_HERO_TeamFirstDetailOk", "isssvivsvivivivivivivii")
	--@brief	请求英雄联赛战斗回放列表（HERO_RecordListOk=38）
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_RecordListOk, "ProtocolProcessorWndLeague:parse_HERO_RecordListOk", "vivivsvsvivivi")
	--@brief	请求请求战斗回放详细信息（HERO_RecordMesOk=42）
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_RecordMesOk, "ProtocolProcessorWndLeague:parse_HERO_RecordMesOk", "vivivivsviviivivivi")
	--@brief	请求播放英雄联赛战斗（HERO_RecordOk=40）
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_RecordOk, "ProtocolProcessorWndLeague:parse_HERO_RecordOk", "vs")
	--@brief	英雄联赛开始时间（HERO_HeroStartTimeOk = 86）
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_HeroStartTimeOk, "ProtocolProcessorWndLeague:parse_HERO_HeroStartTimeOk", "ssssssssssssssssssssssssssssssissssssiiii")
	--@brief	取消匹配（HERO_EndMakePairHeroOk = 36）
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_EndMakePairHeroOk, "ProtocolProcessorWndLeague:parse_HERO_EndMakePairHeroOk", "")
	--@brief	请求英雄联赛观战列表（HERO_WatchListOk=44）
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_WatchListOk, "ProtocolProcessorWndLeague:parse_HERO_WatchListOk", "vivivsvsvivi")
	--@brief	获得报名参加的玩家列表（HERO_GetEnterPlayerListOk = 88）
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_GetEnterPlayerListOk, "ProtocolProcessorWndLeague:parse_HERO_GetEnterPlayerListOk", "itvivsvivivs")
	--@brief	邀请进入战队准备（被邀请人才能收到）(HERO_InvitationReadyOk = 54)
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_InvitationReadyOk, "ProtocolProcessorWndLeague:parse_HERO_InvitationReadyOk", "s")
	--@brief	战队战绩（HERO_GetFightMes = 89）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_GetFightMes, "ProtocolProcessorWndLeague:send_HERO_GetFightMes_ErrorProcess", "is" )
	--@brief	战队战绩（HERO_GetFightMesOk = 90）
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_GetFightMesOk, "ProtocolProcessorWndLeague:parse_HERO_GetFightMesOk", "si")
	--@brief	英雄联赛系统相关协议(MAIN_HERO = 120)
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_CrossFightSuc, "ProtocolProcessorWndLeague:parse_HERO_CrossFightSuc", "i")

     --@brief	系统邀请进入联赛(HERO_Cancel  = 63)
    self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.Invite_League, "ProtocolProcessorWndLeague:parse_HERO_Cancel", "i")
end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorWndLeague:unregAll()
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块Begin--------------------------------------
--@brief	创建战队（HERO_CreateTeam=1）
function ProtocolProcessorWndLeague:send_HERO_CreateTeam(teamName, declaration, photoURL )
	WZLog("send_HERO_CreateTeam",teamName,declaration)
	local sender = Protocol:getSender( Protocol.MAIN_HERO, Protocol.HERO_CreateTeam )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeString( teamName )	-- 战队名字
	sender:writeString( declaration )	-- 宣言
	sender:writeString( photoURL )	-- 照片url
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取战队列表（HERO_GetHeroTeamList = 3）
function ProtocolProcessorWndLeague:send_HERO_GetHeroTeamList( )
	WZLog("send_HERO_GetHeroTeamList")
	local sender = Protocol:getSender( Protocol.MAIN_HERO, Protocol.HERO_GetHeroTeamList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	申请战队（HERO_ApplyHeroTeam = 5）
function ProtocolProcessorWndLeague:send_HERO_ApplyHeroTeam(teamId )
	WZLog("send_HERO_ApplyHeroTeam")
	local sender = Protocol:getSender( Protocol.MAIN_HERO, Protocol.HERO_ApplyHeroTeam )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( teamId )	-- 战队Id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取英雄联赛战队申请列表（HERO_GetApplyList = 7）
function ProtocolProcessorWndLeague:send_HERO_GetApplyList( )
	WZLog("send_HERO_GetApplyList")
	local sender = Protocol:getSender( Protocol.MAIN_HERO, Protocol.HERO_GetApplyList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	审核申请列表（HERO_Reviewed = 9）
function ProtocolProcessorWndLeague:send_HERO_Reviewed(reviewedId, typeId )
	WZLog("send_HERO_Reviewed")
	local sender = Protocol:getSender( Protocol.MAIN_HERO, Protocol.HERO_Reviewed )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInts( reviewedId )	-- 审核玩家列表
	sender:writeInt( typeId )	-- 操作类型（1为同意，2为拒绝）
	SendProtocol(sender,false) --true:showLoading
end

--@brief	查找战队（HERO_SearchTeam = 11）
function ProtocolProcessorWndLeague:send_HERO_SearchTeam(teamId )
	WZLog("send_HERO_SearchTeam")
	local sender = Protocol:getSender( Protocol.MAIN_HERO, Protocol.HERO_SearchTeam )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( teamId )	-- 查找战队的id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	退出战队（HERO_OutTeam = 13）
function ProtocolProcessorWndLeague:send_HERO_OutTeam( )
	WZLog("send_HERO_OutTeam")
	local sender = Protocol:getSender( Protocol.MAIN_HERO, Protocol.HERO_OutTeam )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	踢出战队（HERO_KickTeam = 15）
function ProtocolProcessorWndLeague:send_HERO_KickTeam(pid )
	WZLog("send_HERO_KickTeam")
	local sender = Protocol:getSender( Protocol.MAIN_HERO, Protocol.HERO_KickTeam )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( pid )	-- 被踢出的玩家Id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	邀请加入战队（HERO_Invitation = 17）
function ProtocolProcessorWndLeague:send_HERO_Invitation(playerId )
	WZLog("send_HERO_Invitation")
	local sender = Protocol:getSender( Protocol.MAIN_HERO, Protocol.HERO_Invitation )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInts( playerId )	-- 被邀请的玩家Id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	同意加入战队（HERO_Agree = 19）
function ProtocolProcessorWndLeague:send_HERO_Agree(teamId )
	WZLog("send_HERO_Agree")
	local sender = Protocol:getSender( Protocol.MAIN_HERO, Protocol.HERO_Agree )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( teamId )	-- 被邀请的玩家Id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	进入战队界面准备战斗（HERO_ReadyFight = 21）
function ProtocolProcessorWndLeague:send_HERO_ReadyFight( )
	WZLog("send_HERO_ReadyFight")
	local sender = Protocol:getSender( Protocol.MAIN_HERO, Protocol.HERO_ReadyFight )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	匹配战斗（HERO_MakePairHero = 23）
function ProtocolProcessorWndLeague:send_HERO_MakePairHero( )
	WZLog("send_HERO_MakePairHero")
	local sender = Protocol:getSender( Protocol.MAIN_HERO, Protocol.HERO_MakePairHero )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	退出战队界面（HERO_OutHeroRoom = 24）
function ProtocolProcessorWndLeague:send_HERO_OutHeroRoom( )
	WZLog("send_HERO_OutHeroRoom")
	local sender = Protocol:getSender( Protocol.MAIN_HERO, Protocol.HERO_OutHeroRoom )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	取消匹配（HERO_EndMakePairHero = 28）
function ProtocolProcessorWndLeague:send_HERO_EndMakePairHero( )
	WZLog("send_HERO_EndMakePairHero")
	local sender = Protocol:getSender( Protocol.MAIN_HERO, Protocol.HERO_EndMakePairHero )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	报名参加小组赛（HERO_SignHeroStrong = 29）
function ProtocolProcessorWndLeague:send_HERO_SignHeroStrong( )
	WZLog("send_HERO_SignHeroStrong")
	local sender = Protocol:getSender( Protocol.MAIN_HERO, Protocol.HERO_SignHeroStrong )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	队长切换成员状态（HERO_ChangeStatus = 31）
function ProtocolProcessorWndLeague:send_HERO_ChangeStatus(pid, typeId )
	WZLog("send_HERO_ChangeStatus")
	local sender = Protocol:getSender( Protocol.MAIN_HERO, Protocol.HERO_ChangeStatus )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( pid )	-- 被切换的成员Id
	sender:writeInt( typeId )	-- 切换类型（1为出战，2为观战）
	SendProtocol(sender,false) --true:showLoading
end

--@brief	修改宣言和图片（HERO_NewPhotoAndDec=34）
function ProtocolProcessorWndLeague:send_HERO_NewPhotoAndDec(declaration, photoURL )
	WZLog("send_HERO_NewPhotoAndDec")
	local sender = Protocol:getSender( Protocol.MAIN_HERO, Protocol.HERO_NewPhotoAndDec )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeString( declaration )	-- 宣言
	sender:writeString( photoURL )	-- 照片url
	SendProtocol(sender,false) --true:showLoading
end

--@brief	邀请进入战队准备(HERO_InvitationReady = 53)
function ProtocolProcessorWndLeague:send_HERO_InvitationReady(playerId )
	WZLog("send_HERO_InvitationReady")
	local sender = Protocol:getSender( Protocol.MAIN_HERO, Protocol.HERO_InvitationReady )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerId )	-- 被邀请的玩家Id
	SendProtocol(sender,false) --true:showLoading
end


--@brief	海选赛排行（HERO_FirstSelectRank = 73）
function ProtocolProcessorWndLeague:send_HERO_FirstSelectRank( )
	WZLog("send_HERO_FirstSelectRank")
	local sender = Protocol:getSender( Protocol.MAIN_HERO, Protocol.HERO_FirstSelectRank )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	小组赛结果（HERO_TeamSelectRank = 75）
function ProtocolProcessorWndLeague:send_HERO_TeamSelectRank( )
	WZLog("send_HERO_TeamSelectRank")
	local sender = Protocol:getSender( Protocol.MAIN_HERO, Protocol.HERO_TeamSelectRank )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	16强（HERO_Team16SelectStatus = 77）
function ProtocolProcessorWndLeague:send_HERO_Team16SelectStatus( )
	WZLog("send_HERO_Team16SelectStatus")
	local sender = Protocol:getSender( Protocol.MAIN_HERO, Protocol.HERO_Team16SelectStatus )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	8强战况（HERO_Team8SelectStatus = 79）
function ProtocolProcessorWndLeague:send_HERO_Team8SelectStatus( )
	WZLog("send_HERO_Team8SelectStatus")
	local sender = Protocol:getSender( Protocol.MAIN_HERO, Protocol.HERO_Team8SelectStatus )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	海选赛奖励（HERO_FirstSelectReward = 71）
function ProtocolProcessorWndLeague:send_HERO_FirstSelectReward(itype )
	WZLog("send_HERO_FirstSelectReward")
	local sender = Protocol:getSender( Protocol.MAIN_HERO, Protocol.HERO_FirstSelectReward )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( itype )	-- 1：海选赛奖励；2：海选排名奖励；3：英雄联赛奖励；4：击杀奖励
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取历届冠军队列表（HERO_TeamFirstList = 81）
function ProtocolProcessorWndLeague:send_HERO_TeamFirstList( )
	WZLog("send_HERO_TeamFirstList")
	local sender = Protocol:getSender( Protocol.MAIN_HERO, Protocol.HERO_TeamFirstList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取某一冠军队的详细信息（HERO_TeamFirstDetail = 83）
function ProtocolProcessorWndLeague:send_HERO_TeamFirstDetail(periodNum )
	WZLog("send_HERO_TeamFirstDetail")
	local sender = Protocol:getSender( Protocol.MAIN_HERO, Protocol.HERO_TeamFirstDetail )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( periodNum )	-- 第几届比赛
	SendProtocol(sender,false) --true:showLoading
end

--@brief	请求英雄联赛战斗回放列表（HERO_RecordList=37）
function ProtocolProcessorWndLeague:send_HERO_RecordList(typeId )
	WZLog("send_HERO_RecordList")
	local sender = Protocol:getSender( Protocol.MAIN_HERO, Protocol.HERO_RecordList )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( typeId )	-- 类型（1为正在进行，2为精彩回放，3为决赛回放）
	SendProtocol(sender,false) --true:showLoading
end

--@brief	请求战斗回放详细信息（HERO_RecordMes=41）
function ProtocolProcessorWndLeague:send_HERO_RecordMes(typeId, id )
	WZLog("send_HERO_RecordMes")
	local sender = Protocol:getSender( Protocol.MAIN_HERO, Protocol.HERO_RecordMes )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( typeId )	-- 类型（1为正在回放，2为精彩回放，3为决赛回放）
	sender:writeInt( id )	-- 记录唯一标示
	SendProtocol(sender,false) --true:showLoading
end

--@brief	请求播放英雄联赛战斗回放列表（HERO_Record=39）
function ProtocolProcessorWndLeague:send_HERO_Record(id, typeId )
	WZLog("send_HERO_Record")
	local sender = Protocol:getSender( Protocol.MAIN_HERO, Protocol.HERO_Record )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( id )	-- 记录唯一标示
	sender:writeInt( typeId )	-- 类型（2为精彩回放，3为决赛回放）
	SendProtocol(sender,false) --true:showLoading
end

--@brief	英雄联赛开始时间（HERO_HeroStartTime = 85）
function ProtocolProcessorWndLeague:send_HERO_HeroStartTime( )
	WZLog("send_HERO_HeroStartTime")
	local sender = Protocol:getSender( Protocol.MAIN_HERO, Protocol.HERO_HeroStartTime )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	请求英雄联赛观战列表（HERO_WatchList=43）
function ProtocolProcessorWndLeague:send_HERO_WatchList()
	WZLog("send_HERO_WatchList")
	local sender = Protocol:getSender( Protocol.MAIN_HERO, Protocol.HERO_WatchList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	获得报名参加的玩家列表（HERO_GetEnterPlayerList = 87）
function ProtocolProcessorWndLeague:send_HERO_GetEnterPlayerList( )
	WZLog("send_HERO_GetEnterPlayerList")
	local sender = Protocol:getSender( Protocol.MAIN_HERO, Protocol.HERO_GetEnterPlayerList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	准备战斗(HERO_Ready = 59)
function ProtocolProcessorWndLeague:send_HERO_Ready( )
	WZLog("send_HERO_Ready")
	local sender = Protocol:getSender( Protocol.MAIN_HERO, Protocol.HERO_Ready )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	取消战斗准备(HERO_CancelReady = 60)
function ProtocolProcessorWndLeague:send_HERO_CancelReady( )
	WZLog("send_HERO_CancelReady")
	local sender = Protocol:getSender( Protocol.MAIN_HERO, Protocol.HERO_CancelReady )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	提升为副队长(HERO_Promotion = 61)
function ProtocolProcessorWndLeague:send_HERO_Promotion(pid )
	WZLog("send_HERO_Promotion")
	local sender = Protocol:getSender( Protocol.MAIN_HERO, Protocol.HERO_Promotion )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( pid )	-- 玩家Id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	取消副队长(HERO_Cancel  = 62)
function ProtocolProcessorWndLeague:send_HERO_Cancel( )
	WZLog("send_HERO_Cancel")
	local sender = Protocol:getSender( Protocol.MAIN_HERO, Protocol.HERO_Cancel )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	战队战绩（HERO_GetFightMes = 89）
function ProtocolProcessorWndLeague:send_HERO_GetFightMes(teamId, channel )
	WZLog("send_HERO_GetFightMes")
	local sender = Protocol:getSender( Protocol.MAIN_HERO, Protocol.HERO_GetFightMes )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( teamId )	-- 战队Id
	sender:writeInt( channel )	-- 类型
	SendProtocol(sender,false) --true:showLoading
end
-------------------------------------客户端到服务器协议发送方法模块End--------------------------------------


-------------------------------------服务器到客户端协议回调方法模块Begin--------------------------------------
--@brief	创建战队成功（HERO_CreateTeamOK=2）
function ProtocolProcessorWndLeague:parse_HERO_CreateTeamOK(teamId, teamName, declaration, playerId, captain, photoURL, score, fightNum, winNum)
	-- teamId : 战队id
	-- teamName : 战队名字
	-- declaration : 宣言
	-- playerId : 成员
	-- captain : 队长id
	-- photoURL : 照片url
	-- score : 积分
	-- fightNum : 战斗次数
	-- winNum :  胜利次数
	WZLog("ProtocolProcessorWndLeague:parse_HERO_CreateTeamOK",teamName)
	CacheCenter:getPlayerInfo().teamId = teamId
	MsgBoxManager:showTipBox(LocalStrings.LEAGUE76)
	if WndLeagueTeamList.m_root ~= nil then
		WndLeagueTeamList.m_root:setVisible(false)
	end
	if SceneLeagueMain.m_root ~= nil then
		WndLeagueTeamDetail:show(GetElement(SceneLeagueMain.m_root,"conCurWindow_SceneLeagueMain",WZUIContainer))
	end
end

--@brief	获取战队列表（HERO_GetHeroTeamListOK = 4）
function ProtocolProcessorWndLeague:parse_HERO_GetHeroTeamListOK(teamId, teamName, playerNum, photoURL)
	-- teamId : 战队id
	-- teamName : 战队名称
	-- playerNum : 成员数量
	-- photoURL : 照片url
	WZLog("ProtocolProcessorWndLeague:parse_HERO_GetHeroTeamListOK")
	WndLeagueTeamList:setData(VectorToTable(teamId), VectorToTable(teamName), VectorToTable(playerNum), VectorToTable(photoURL))
end

--@brief	申请战队（HERO_ApplyHeroTeamOK = 6）
function ProtocolProcessorWndLeague:parse_HERO_ApplyHeroTeamOK(sec)
	WZLog("ProtocolProcessorWndLeague:parse_HERO_ApplyHeroTeamOK")
	if sec > 0 then
		local min = math.ceil(sec/60)
		MsgBoxManager:showTipBox(min..LocalStrings.LEAGUE77)
		return
	end
	MsgBoxManager:showTipBox(LocalStrings.LEAGUE78)
end

--@brief	获取英雄联赛战队申请列表成功（HERO_GetApplyListOK = 8）
function ProtocolProcessorWndLeague:parse_HERO_GetApplyListOK(playerId, level, playerName, outTeamNum, fight, faceId, headId, sex, vip, headColor)
	-- playerId : 玩家id
	-- level : 等级
	-- playerName : 名称
	-- outTeamNum : 退出战队次数
	-- fighte : 战斗力
	-- faceId : 脸部Id
	-- headId : 头部Id
	WZLog("ProtocolProcessorWndLeague:parse_HERO_GetApplyListOK")
	WndLeagueRecruit:setData(VectorToTable(playerId), VectorToTable(level), VectorToTable(playerName), VectorToTable(outTeamNum), VectorToTable(fight), VectorToTable(faceId), VectorToTable(headId), VectorToTable(sex), VectorToTable(vip), VectorToTable(headColor))
end

--@brief	审核申请列表成功返回申请列表（HERO_ReviewedOK = 10）
function ProtocolProcessorWndLeague:parse_HERO_ReviewedOK(playerId, level, playerName, outTeamNum, fighte, faceId, headId)
	-- playerId : 玩家id
	-- level : 等级
	-- playerName : 名称
	-- outTeamNum : 退出战队次数
	-- fighte : 战斗力
	-- faceId : 脸部Id
	-- headId : 头部Id
	WZLog("ProtocolProcessorWndLeague:parse_HERO_ReviewedOK")
	MsgBoxManager:showTipBox(LocalStrings.LEAGUE79)
	ProtocolProcessorWndLeague:send_HERO_ReadyFight()
end

--@brief	查找战队（HERO_SearchTeamOK = 12）
function ProtocolProcessorWndLeague:parse_HERO_SearchTeamOK(serviceName, teamId, teamName, photoURL, declaration, playerId, headId, faceId, sex, mvp, bodyId, wingId, level, name , captain, headColor, bodyColor)
	-- serviceName : 服务器名称
	-- teamId : 战队id（-2时为找不到该战队）
	-- teamName : 战队名称
	-- photoURL : 照片url
	-- declaration : 宣言
	-- playerId : 成员Id
	-- headId : 脸部Id
	-- faceId : 头部Id
	-- sex : 性别
	-- mvp : mvp玩家Id
	-- captain : 队长id
	WZLog("ProtocolProcessorWndLeague:parse_HERO_SearchTeamOK",Serialize(VectorToTable(playerId)),mvp,captain,photoURL)
	if teamId == -1 then
		MsgBoxManager:showTipBox(LocalStrings.LEAGUE35)
		return
	end
	if SceneLeagueMain.m_nCheckType == 1 then
		if SceneLeagueMain.m_tCheckElement.m_root ~= nil and SceneLeagueMain.m_tCheckWnd.m_root ~= nil then
			local tData = {}
			tData.serviceName = serviceName
			tData.teamId = teamId
			tData.teamName = teamName
			tData.photoURL = photoURL
			tData.declaration = declaration
			tData.mvp = mvp
			tData.captain = captain
			tData.playerId = VectorToTable(playerId)
			tData.headId = VectorToTable(headId)
			tData.faceId = VectorToTable(faceId)
			tData.sex = VectorToTable(sex)
			tData.headColor = VectorToTable(headColor)
			tData.bodyColor = VectorToTable(bodyColor)
			WndTips:show(SceneLeagueMain.m_tCheckElement.m_root,SceneLeagueMain.m_tCheckWnd.m_root,26,tData,GlobalMethod:ccp(180,-35))
		end
	elseif SceneLeagueMain.m_nCheckType == 2 then
		--隐藏创建按钮
		GetElement(WndLeagueTeamList.m_root,"btnCreate",WZUIButton):setVisible(false)

		WndLeagueTeamList.m_tDataList = {}

		local tempList = {}
		tempList.id = teamId
		tempList.icon = photoURL
		tempList.name = teamName
		tempList.captain = captain
		tempList.memberNumber = #VectorToTable(playerId)
		table.insert(WndLeagueTeamList.m_tDataList,tempList)
		
		WZLog("战队列表",Serialize(WndLeagueTeamList.m_tDataList))
		
		WndLeagueTeamList:update()
	elseif SceneLeagueMain.m_nCheckType == 3 then
		SceneLeagueMain.m_nCaptain = captain
	elseif SceneLeagueMain.m_nCheckType == 4 then
		if SceneLeagueMain.m_tCheckElement ~= nil and SceneLeagueMain.m_tCheckWnd.m_root ~= nil then
			local tData = {}
			tData.serviceName = serviceName
			tData.teamId = teamId
			tData.teamName = teamName
			tData.photoURL = photoURL
			tData.declaration = declaration
			tData.mvp = mvp
			tData.captain = captain
			tData.playerId = VectorToTable(playerId)
			tData.headId = VectorToTable(headId)
			tData.faceId = VectorToTable(faceId)
			tData.sex = VectorToTable(sex)
			tData.headColor = VectorToTable(headColor)
			tData.bodyColor = VectorToTable(bodyColor)
			WndTips:show(SceneLeagueMain.m_tCheckElement,SceneLeagueMain.m_tCheckWnd.m_root,26,tData,GlobalMethod:ccp(180,-35))
		end
	end
	GlobalGame:getGameEventDispathcer():Dispatch("GameState_Change","state_hero_team_update",teamId,teamName,#VectorToTable(playerId))
end

--@brief	退出战队（HERO_OutTeamOK = 14）
function ProtocolProcessorWndLeague:parse_HERO_OutTeamOK()
	WZLog("ProtocolProcessorWndLeague:parse_HERO_OutTeamOK")
	CacheCenter:getPlayerInfo().teamId = 0
	if WndLeagueTeamDetail.m_root ~= nil then
		WndLeagueTeamDetail.m_root:setVisible(false)
	end
	if SceneLeagueMain.m_root ~= nil then
		WndLeagueTeamList:show(GetElement(SceneLeagueMain.m_root,"conCurWindow_SceneLeagueMain",WZUIContainer))
	end
end

--@brief	踢出战队（HERO_KickTeamOK = 16）
function ProtocolProcessorWndLeague:parse_HERO_KickTeamOK(playerId)
	-- playerId : 剩余成员Id
	WZLog("ProtocolProcessorWndLeague:parse_HERO_KickTeamOK")
	MsgBoxManager:showTipBox(LocalStrings.LEAGUE80)
	ProtocolProcessorWndLeague:send_HERO_ReadyFight()
end

--@brief	系统邀请进入联赛(HERO_Cancel  = 63)
--（1为三十二强第1场，2为三十二强第2场，3为三十二强第3场，4为十六强第1场，5为十六强第1场，6为十六强第1场，7为八强第1场，8为八强第1场，9为八强第1场，10为四强第1场，11为四强第2场，12为四强第3场，13为决赛第1场，14为决赛第2场，15为决赛第3场）
function ProtocolProcessorWndLeague:parse_HERO_Cancel(inviteType)
	-- inviteType  : 联赛类型
	WZLog("ProtocolProcessorWndLeague:parse_HERO_Cancel")
	if SceneCity and SceneCity.m_root ~= nil then
        SceneCity.m_heroMatchType = inviteType
		--WndInvited:showInterface(SceneCity,SceneCity.receiveLeagueInvite,nil,nil,LocalStrings.INVITE_LEAGUE)
	end
end

--@brief	邀请加入战队，被邀请人收到（HERO_InvitationOK = 18）
function ProtocolProcessorWndLeague:parse_HERO_InvitationOK(teamId, message,playerName)
	-- teamId : 战队Id
	WZLog("ProtocolProcessorWndLeague:parse_HERO_InvitationOK")
	--能否被邀请（在战斗房间、副本房间、战斗场景、战斗加载场景都不能够被邀请）
	--return   #1:true :能够被邀请 , false :不能够被邀请
	--if SceneRoom.m_root == nil and SceneBossRoom.m_root == nil and SceneBattle.m_root == nil and SceneBattleLoading.m_root == nil then 
	if WndInvited then
		WndInvited:showInterface(WndLeagueTeamDetail, WndLeagueTeamDetail.sendJoinTeam, teamId, nil,nil, message,playerName,nil, false)
	end
end

--@brief	同意加入战队（HERO_AgreeOK = 20）
function ProtocolProcessorWndLeague:parse_HERO_AgreeOK(teamId, teamName, declaration, playerId, captain, photoURL, score, fightNum, winNum)
	-- teamId : 战队id
	-- teamName : 战队名字
	-- declaration : 宣言
	-- playerId : 成员
	-- captain : 队长id
	-- photoURL : 照片url
	-- score : 积分
	-- fightNum : 战斗次数
	-- winNum :  胜利次数
	WZLog("ProtocolProcessorWndLeague:parse_HERO_AgreeOK")
	MsgBoxManager:showTipBox(LocalStrings.LEAGUE81)
	--local wnd = SceneLeagueMain:createElement()
	--WindowManager:addWindow(wnd, SceneLeagueMain, nil, nil, true)
	if SceneLeagueMain.m_root == nil then
		SceneLeagueMain:showInterface(2)
	else
		local checkbox1 = GetElement(SceneLeagueMain.m_root, "checkbox1_SceneLeagueMain", WZUICheckBox)
		checkbox1:setCheckIndex(0)
		local checkbox2 = GetElement(SceneLeagueMain.m_root, "checkbox2_SceneLeagueMain", WZUICheckBox)
		checkbox2:setCheckIndex(1)
		SceneLeagueMain:onTab2()
	end
end

--@brief	进入战队界面准备战斗，战队界面成员收到（HERO_ReadyFightOK = 22）
function ProtocolProcessorWndLeague:parse_HERO_ReadyFightOK(teamId, teamName, photoURL, declaration, playerId, faceId, headId, bodyId, wingId, captain, score, fightNum, winNum, readyPlayerId, watchPlayerId, rank, sex, pet, status, timeMes, openTime, level, name, lastFight, itemId, extraInfo, kictNum, outNum, picStatue, canFight, readyed, fight, viceCaptain, headColor, bodyColor, mentoringStr, coupleStr, chumStr, coupleNum, chumNum, mentoringNum, matchLevel, matchscore, joinTimes, winTimes, continuousWinTimes)
	-- teamId : 战队Id
	-- teamName      : 战队名字
	-- photoURL : 照片url
	-- declaration : 宣言
	-- playerId : 成员
	-- faceId : 脸部Id
	-- headId : 头部Id
	-- bodyId : 身体Id
	-- wingId : 翅膀
	-- captain : 队长
	-- score : 积分
	-- fightNum : 战斗次数
	-- winNum : 胜利次数
	-- readyPlayerId : 准备战斗成员
	-- watchPlayerId : 观战成员
	-- rank : 排名
	WZLog("ProtocolProcessorWndLeague:parse_HERO_ReadyFightOK",lastFight,timeMes,openTime,captain)
	WndLeagueTeamDetail:setData(teamId, teamName, photoURL, declaration, VectorToTable(playerId), VectorToTable(faceId), VectorToTable(headId), VectorToTable(bodyId), VectorToTable(wingId), captain, score, fightNum, winNum, VectorToTable(readyPlayerId), VectorToTable(watchPlayerId), rank, VectorToTable(sex), VectorToTable(pet), VectorToTable(status), timeMes, openTime, VectorToTable(level), VectorToTable(name), lastFight, VectorToTable(itemId), VectorToTable(extraInfo), kictNum, VectorToTable(outNum), picStatue, canFight, VectorToTable(readyed), fight, viceCaptain, VectorToTable(headColor), VectorToTable(bodyColor), mentoringStr, coupleStr, chumStr, coupleNum, chumNum, mentoringNum, VectorToTable(matchLevel), VectorToTable(matchscore), VectorToTable(joinTimes), VectorToTable(winTimes), VectorToTable(continuousWinTimes))
	if #VectorToTable(readyed) >= 2 then
		GlobalGame:getGameEventDispathcer():Dispatch("GameState_Change","state_hero_ready")
	end
end

--@brief	退出战队界面，战队界面成员收到（HERO_OutHeroRoomOK = 25）
function ProtocolProcessorWndLeague:parse_HERO_OutHeroRoomOK(playerId, faceId, headId, bodyId, wingId, readyPlayerId, watchPlayerId)
	-- playerId : 成员
	-- faceId : 脸部Id
	-- headId : 头部Id
	-- bodyId : 身体Id
	-- wingId : 翅膀
	-- readyPlayerId : 准备战斗成员
	-- watchPlayerId : 观战成员
	WZLog("ProtocolProcessorWndLeague:parse_HERO_OutHeroRoomOK")
end

--@brief	报名参加小组赛成功（HERO_SignHeroStrongOk = 30）
function ProtocolProcessorWndLeague:parse_HERO_SignHeroStrongOk()
	WZLog("ProtocolProcessorWndLeague:parse_HERO_SignHeroStrongOk")
	MsgBoxManager:showTipBox(LocalStrings.LEAGUE49)
end

--@brief	队长切换成员状态，所有在战队界面成员都会收到（HERO_ChangeStatuOk = 32）
function ProtocolProcessorWndLeague:parse_HERO_ChangeStatuOk(teamId, teamName, photoURL, declaration, playerId, faceId, headId, bodyId, wingId, captain, score, fightNum, winNum, readyPlayerId, watchPlayerId, rank, sex, pet, status, timeMes, openTime, level, name)
	-- teamId : 战队Id
	-- teamName      : 战队名字
	-- photoURL : 照片url
	-- declaration : 宣言
	-- playerId : 成员
	-- faceId : 脸部Id
	-- headId : 头部Id
	-- bodyId : 身体Id
	-- wingId : 翅膀
	-- captain : 队长
	-- score : 积分
	-- fightNum : 战斗次数
	-- winNum : 胜利次数
	-- readyPlayerId : 准备战斗成员
	-- watchPlayerId : 观战成员
	-- rank : 排名
	-- sex : 性别
	-- pet : 宠物
	-- status : 数字-1为在线，正数为离线时间（单位为秒）
	-- timeMes : 当天开战时间
	-- openTime : 下一场战斗开始的时间
	-- level : 等级
	-- name : 名字
	WZLog("ProtocolProcessorWndLeague:parse_HERO_ChangeStatuOk")
	ProtocolProcessorWndLeague:send_HERO_ReadyFight()
end

--@brief	更新玩家战队Id（HERO_ChangeTeamOk = 33）
function ProtocolProcessorWndLeague:parse_HERO_ChangeTeamOk(teamId)
	-- teamId : 战队Id
	WZLog("ProtocolProcessorWndLeague:parse_HERO_ChangeTeamOk")
	CacheCenter:getPlayerInfo().teamId = teamId
	if SceneLeagueMain.m_root ~= nil and SceneLeagueMain.m_nTab == 2 then
		if teamId == 0 then
			if SceneLeagueMain.m_root ~= nil then
				WndLeagueTeamList:show(GetElement(SceneLeagueMain.m_root,"conCurWindow_SceneLeagueMain",WZUIContainer))
			end
			if WndLeagueTeamDetail.m_root ~= nil then
				WndLeagueTeamDetail.m_root:setVisible(false)
			end
			if WndLeagueTeamDetail.m_bExitTeam == true then
				MsgBoxManager:showTipBox(LocalStrings.LEAGUE82)
			else
				MsgBoxManager:showTipBox(LocalStrings.LEAGUE38)
			end
			WndLeagueTeamDetail.m_tData = nil
		else
			MsgBoxManager:showTipBox(LocalStrings.LEAGUE81)
			WndLeagueTeamDetail.m_bExitTeam = nil
			if WndLeagueTeamList.m_root ~= nil then
				WndLeagueTeamList.m_root:setVisible(false)
			end
			if SceneLeagueMain.m_root ~= nil then
				WndLeagueTeamDetail:show(GetElement(SceneLeagueMain.m_root,"conCurWindow_SceneLeagueMain",WZUIContainer))
			end
		end
	end
end

--@brief	修改宣言和图片（HERO_NewPhotoAndDecOK=35）
function ProtocolProcessorWndLeague:parse_HERO_NewPhotoAndDecOK(teamId, teamName, declaration, playerId, captain, photoURL, score, fightNum, winNum)
	-- teamId : 战队id
	-- teamName : 战队名字
	-- declaration : 宣言
	-- playerId : 成员
	-- captain : 队长id
	-- photoURL : 照片url
	-- score : 积分
	-- fightNum : 战斗次数
	-- winNum :  胜利次数
	WZLog("ProtocolProcessorWndLeague:parse_HERO_NewPhotoAndDecOK")
	ProtocolProcessorWndLeague:send_HERO_ReadyFight()
end

--@brief	英雄联赛奖励（HERO_FirstSelectRewardOk = 72）
function ProtocolProcessorWndLeague:parse_HERO_FirstSelectRewardOk(rewardId, state, complete, target, startTime, endTime, dayFightNum, dayWinNum, rewardTime, killNum, myTeamRank)
	-- rewardId : 唯一Id
	-- state : 状态0未完成1已经完成2已经发放
	-- complete : 完成数量
	-- target : 目标数量
	-- startTime : 开始时间(海选赛或者英雄联赛)
	-- endTime : 结束时间(海选赛或者英雄联赛)
	-- dayFightNum : 今天战斗次数
	-- dayWinNum : 今天胜利次数
	-- rewardTime : 发奖时间
	-- killNum : 击杀数
	-- myTeamRank : 本队排名
	WZLog("ProtocolProcessorWndLeague:parse_HERO_FirstSelectRewardOk")
	WndLeagueHPR:setRewardsData(rewardId, state, complete, target, startTime, endTime, dayFightNum, dayWinNum, rewardTime, killNum, myTeamRank)
end


--@brief	海选赛排行（HERO_FirstSelectRankOk = 74）
function ProtocolProcessorWndLeague:parse_HERO_FirstSelectRankOk(myTeamId, myTeamScore, myTeamRank, startTime, endTime, teamIds, ranks, names, scores, successCount, totalCount, url)
	-- myTeamId : 本人的队伍id
	-- myTeamScore : 本人队伍的积分
	-- myTeamRank : 本人队伍的排名
	-- startTime : 开始时间
	-- endTime : 结束时间
	-- teamIds : 队伍id
	-- ranks : 队伍排名
	-- names : 队伍名称
	-- scores : 队伍积分
	-- successCount : 队伍胜利场次
	-- totalCount : 队伍总场次
	-- url : 队伍图标
	WZLog("ProtocolProcessorWndLeague:parse_HERO_FirstSelectRankOk")
	WndLeagueMatch:setData1(myTeamId, myTeamScore, myTeamRank, startTime, endTime, VectorToTable(teamIds), VectorToTable(ranks), VectorToTable(names), VectorToTable(scores), VectorToTable(successCount), VectorToTable(totalCount), VectorToTable(url))
end

--@brief	海选赛排行（HERO_TeamSelectRankOk = 76））
function ProtocolProcessorWndLeague:parse_HERO_TeamSelectRankOk(firstStartTime, firstEndTime, secondStartTime, secondEndTime, thirdStartTime, thirdEndTime, teamId, successStatus, url)
	-- firstStartTime : 第一轮开始时间
	-- firstEndTime : 第一轮结束时间
	-- secondStartTime : 第二轮开始时间
	-- secondEndTime : 第二轮结束时间
	-- thirdStartTime : 第三轮开始时间
	-- thirdEndTime : 第三轮结束时间
	-- teamId : 队伍id
	-- successStatus : 队伍三轮胜负情况
	-- url : 队伍图标
	WZLog("ProtocolProcessorWndLeague:parse_HERO_TeamSelectRankOk")
	WndLeagueMatch:setData2(firstStartTime, firstEndTime, secondStartTime, secondEndTime, thirdStartTime, thirdEndTime, VectorToTable(teamId), VectorToTable(successStatus), VectorToTable(url))
end

--@brief	16强战况（HERO_Team16SelectStatusOk = 78）
function ProtocolProcessorWndLeague:parse_HERO_Team16SelectStatusOk(firstStartTime, firstEndTime, secondStartTime, secondEndTime, thirdStartTime, thirdEndTime, teamId, name, url, successStatus)
	-- firstStartTime : 第一轮开始时间
	-- firstEndTime : 第一轮结束时间
	-- secondStartTime : 第二轮开始时间
	-- secondEndTime : 第二轮结束时间
	-- thirdStartTime : 第三轮开始时间
	-- thirdEndTime : 第三轮结束时间
	-- teamId : 队伍id
	-- name : 队伍名称
	-- url : 队伍头像
	-- successStatus : 队伍胜负情况
	WZLog("ProtocolProcessorWndLeague:parse_HERO_Team16SelectStatusOk")
	WndLeagueMatch:setData3(firstStartTime, firstEndTime, secondStartTime, secondEndTime, thirdStartTime, thirdEndTime, VectorToTable(teamId), VectorToTable(name), VectorToTable(url), VectorToTable(successStatus))
end

--@brief	8强战况（HERO_Team8SelectStatusOk = 80）
function ProtocolProcessorWndLeague:parse_HERO_Team8SelectStatusOk(firstStartTime8, firstEndTime8, secondStartTime8, secondEndTime, thirdStartTime8, thirdEndTime8, firstStartTime4, firstEndTime4, secondStartTime4, secondEndTime4, thirdStartTime4, thirdEndTime4, firstStartTime2, firstEndTime2, secondStartTime2, secondEndTime2, thirdStartTime2, thirdEndTime2, teamId8, name8, url8, teamId4, name4, url4, teamId2, name2, url2, teamIdFirst, namefirst, urlfirst, teamIdSecond, nameSecond, urlSecond, teamIdThird, nameThird, urlThird, version)
	-- firstStartTime8 : 第一轮开始时间
	-- firstEndTime8 : 第一轮结束时间
	-- secondStartTime8 : 第二轮开始时间
	-- secondEndTime : 第二轮结束时间
	-- thirdStartTime8 : 第三轮开始时间
	-- thirdEndTime8 : 第三轮结束时间
	-- firstStartTime4 : 第一轮开始时间
	-- firstEndTime4 : 第一轮结束时间
	-- secondStartTime4 : 第二轮开始时间
	-- secondEndTime4 : 第二轮结束时间
	-- thirdStartTime4 : 第三轮开始时间
	-- thirdEndTime4 : 第三轮结束时间
	-- firstStartTime2 : 第一轮开始时间
	-- firstEndTime2 : 第一轮结束时间
	-- secondStartTime2 : 第二轮开始时间
	-- secondEndTime2 : 第二轮结束时间
	-- thirdStartTime2 : 第三轮开始时间
	-- thirdEndTime2 : 第三轮结束时间
	-- teamId8 : 8强队伍id
	-- name8 : 8强队伍名称
	-- url8 : 8强图标
	-- teamId4 : 4强队伍id
	-- name4 : 4强队伍名称
	-- url4 : 4强图标
	-- teamId2 : 2强队伍id
	-- name2 : 2强队伍名称
	-- url2 : 2强图标
	-- teamIdFirst : 冠军队id
	-- namefirst : 冠军队名称
	-- urlfirst : 冠军队图标
	-- teamIdSecond : 亚军队id
	-- nameSecond : 亚军队名称
	-- urlSecond : 亚军队图标
	-- teamIdThird : 季军队id
	-- nameThird : 季军队名称
	-- urlThird : 季军队图标
	WZLog("ProtocolProcessorWndLeague:HERO_Team8SelectStatusOk")
	WndLeagueMatch:setData4(firstStartTime8, firstEndTime8, secondStartTime8, secondEndTime, thirdStartTime8, thirdEndTime8, firstStartTime4, firstEndTime4, secondStartTime4, secondEndTime4, thirdStartTime4, thirdEndTime4, firstStartTime2, firstEndTime2, secondStartTime2, secondEndTime2, thirdStartTime2, thirdEndTime2, VectorToTable(teamId8), VectorToTable(name8), VectorToTable(url8), VectorToTable(teamId4), VectorToTable(name4), VectorToTable(url4), VectorToTable(teamId2), VectorToTable(name2), VectorToTable(url2), teamIdFirst, namefirst, urlfirst, teamIdSecond, nameSecond, urlSecond, teamIdThird, nameThird, urlThird, version)
end

--@brief	获取历届冠军队列表成功（HERO_TeamFirstListOk = 82）
function ProtocolProcessorWndLeague:parse_HERO_TeamFirstListOk(teamId, teamName, periodNum)
	-- Id : 唯一标记
	-- teamId : 战队Id
	-- teamName     : 战队名字
	-- periodNum : 第几届比赛
	WZLog("ProtocolProcessorWndLeague:parse_HERO_TeamFirstListOk")
	WndLeagueHPR:setHonourItemData(teamId, teamName, periodNum)
end

--@brief	荣誉某一届冠军队伍信息（HERO_TeamFirstDetailOk = 84）
function ProtocolProcessorWndLeague:parse_HERO_TeamFirstDetailOk(teamId, teamName, photoURL, declaration, playerId, name, level, sex, faceId, headId, bodyId, wingId, mvpMark, captain)
	-- teamId : 战队Id
	-- teamName      : 战队名字
	-- photoURL : 照片url
	-- declaration : 宣言
	-- playerId : 成员
	-- name : 成员名字
	-- level : 等级
	-- sex : 性别
	-- faceId : 脸部Id
	-- headId : 头部Id
	-- bodyId : 身体Id
	-- wingId : 翅膀
	-- mvpMark : MVP标记：1是MVP；0不是MVP
	-- captain : 队长
	WZLog("ProtocolProcessorWndLeague:parse_HERO_TeamFirstDetailOk")
	WndLeagueHPR:setHonourData(teamId, teamName, photoURL, declaration, playerId, name, level, sex, faceId, headId, bodyId, wingId, mvpMark, captain)
end

--@brief	请求英雄联赛战斗回放列表（HERO_RecordListOk=38）
function ProtocolProcessorWndLeague:parse_HERO_RecordListOk(id, teamId, teamName, photoURL, winteamId, channel, isnew)
	-- id : 记录唯一标示
	-- teamId : 战队id
	-- teamName : 战队名字
	-- photoURL : 照片url
	-- winteamId : 胜利战队
	-- channel : 战斗类型（）
	-- isnew : 是否新的（1为已观看2为没观看）
	WZLog("ProtocolProcessorWndLeague:parse_HERO_RecordListOk")
	WndLeagueHPR:setReplayData(id, teamId, teamName, photoURL, winteamId, channel, isnew)
end

--@brief	请求请求战斗回放详细信息（HERO_RecordMesOk=42）
function ProtocolProcessorWndLeague:parse_HERO_RecordMesOk(playerId, faceId, headId, name, sex, camp, mvp, teamId, level, headColor)
	-- playerId : 玩家Id
	-- faceId : 玩家脸
	-- headId : 玩家头像
	-- name : 玩家名字
	-- sex : 性别
	-- camp : 玩家阵营
	-- mvp : mvp
	-- teamId : 战队id
	-- level : 等级
	-- headColor : 头像颜色索引
	WZLog("ProtocolProcessorWndLeague:parse_HERO_RecordMesOk")
	if WndLeagueVSInfo.m_root then 
		WndLeagueVSInfo:setData(playerId, faceId, headId, name, sex, camp, mvp, teamId, level, headColor)
	else
		WndLeagueHPR:getTeamPlayersOK(playerId, faceId, headId, name, sex, camp, mvp, teamId, level, headColor)
	end
end

--@brief	请求播放英雄联赛战斗（HERO_RecordOk=40）
function ProtocolProcessorWndLeague:parse_HERO_RecordOk(recordMes)
	-- recordMes : 战斗记录
	WZLog("ProtocolProcessorWndLeague:parse_HERO_RecordOk")

	WndLeagueVSInfo:checkAndQuitRoom()
	BattleMsgReplayGameRecord:setRecord(VectorToTable(recordMes),4)
    replaceScene(SceneBattleLoading:createElement())
end

--@brief	英雄联赛开始时间（HERO_HeroStartTimeOk = 86）
function ProtocolProcessorWndLeague:parse_HERO_HeroStartTimeOk(startTime32One, endTime32One, startTime32Two, endTime32Two, startTime32Three, endTime32Three, startTime16One, endTime16One, startTime16Two, endTime16Two, startTime16Three, endTime16Three, startTime8One, endTime8One, startTime8Two, endTime8Two, startTime8Three, endTime8Three, startTime4One, endTime4One, startTime4Two, endTime4Two, startTime4Three, endTime4Three, startTimeFOne, endTimeFOne, startTimeFTwo, endTimeFTwo, startTimeFThree, endTimeFThree, nowTime, startDateAll, endDateAll, startTimeAll, endTimeAll, startSignTime, endSignTime, winScore, failScore, applyPunish, makePairPunish)
	-- startTime32One : 32强第一轮开始时间（格式 yyyy.MM.dd HH:mm）
	-- endTime32One : 32强第一轮结束时间（格式 yyyy.MM.dd HH:mm）
	-- startTime32Two : 32强第二轮开始时间（格式 yyyy.MM.dd HH:mm）
	-- endTime32Two : 32强第二轮结束时间（格式 yyyy.MM.dd HH:mm）
	-- startTime32Three : 32强第三轮开始时间（格式 yyyy.MM.dd HH:mm）
	-- endTime32Three : 32强第三轮结束时间（格式 yyyy.MM.dd HH:mm）
	-- startTime16One : 16强第一轮开始时间（格式 yyyy.MM.dd HH:mm）
	-- endTime16One : 16强第一轮结束时间（格式 yyyy.MM.dd HH:mm）
	-- startTime16Two : 16强第二轮开始时间（格式 yyyy.MM.dd HH:mm）
	-- endTime16Two : 16强第二轮结束时间（格式 yyyy.MM.dd HH:mm）
	-- startTime16Three : 16强第三轮开始时间（格式 yyyy.MM.dd HH:mm）
	-- endTime16Three : 16强第三轮结束时间（格式 yyyy.MM.dd HH:mm）
	-- startTime8One : 8强第一轮开始时间（格式 yyyy.MM.dd HH:mm）
	-- endTime8One : 8强第一轮结束时间（格式 yyyy.MM.dd HH:mm）
	-- startTime8Two : 8强第二轮开始时间（格式 yyyy.MM.dd HH:mm）
	-- endTime8Two : 8强第二轮结束时间（格式 yyyy.MM.dd HH:mm）
	-- startTime8Three : 8强第三轮开始时间（格式 yyyy.MM.dd HH:mm）
	-- endTime8Three : 8强第三轮结束时间（格式 yyyy.MM.dd HH:mm）
	-- startTime4One : 4强第一轮开始时间（格式 yyyy.MM.dd HH:mm）
	-- endTime4One : 4强第一轮结束时间（格式 yyyy.MM.dd HH:mm）
	-- startTime4Two : 4强第二轮开始时间（格式 yyyy.MM.dd HH:mm）
	-- endTime4Two : 4强第二轮结束时间（格式 yyyy.MM.dd HH:mm）
	-- startTime4Three : 4强第三轮开始时间（格式 yyyy.MM.dd HH:mm）
	-- endTime4Three : 4强第三轮结束时间（格式 yyyy.MM.dd HH:mm）
	-- startTimeFOne : 决赛第一轮开始时间（格式 yyyy.MM.dd HH:mm）
	-- endTimeFOne : 决赛第一轮结束时间（格式 yyyy.MM.dd HH:mm）
	-- startTimeFTwo : 决赛第二轮开始时间（格式 yyyy.MM.dd HH:mm）
	-- endTimeFTwo : 决赛第二轮结束时间（格式 yyyy.MM.dd HH:mm）
	-- startTimeFThree : 决赛第三轮开始时间（格式 yyyy.MM.dd HH:mm）
	-- endTimeFThree : 决赛第三轮结束时间（格式 yyyy.MM.dd HH:mm）
	-- nowTime : 服务器当前时间戳
	-- startDateAll : 海选赛开始日期（格式 yyyy.MM.dd）
	-- endDateAll : 海选赛结束日期（格式 yyyy.MM.dd）
	-- startTimeAll : 海选赛开始时间（格式 HH:mm）
	-- endTimeAll : 海选赛结束时间（格式 HH:mm）
	-- startSignTime : 报名开始时间（格式 yyyy.MM.dd）
	-- endSignTime : 报名结束时间（格式 yyyy.MM.dd）

	if startDateAll == "" or endDateAll == "" then
        return
    end

	WZLog("ProtocolProcessorWndLeague:parse_HERO_HeroStartTimeOk",applyPunish,makePairPunish)

    if startDateAll == "" or endDateAll == "" then
        return
    end
	if SceneLeagueMain.m_root ~= nil then
		SceneLeagueMain:saveGameTime(startTime32One, endTime32One, startTime32Two, endTime32Two, startTime32Three, endTime32Three, startTime16One, endTime16One, startTime16Two, endTime16Two, startTime16Three, endTime16Three, startTime8One, endTime8One, startTime8Two, endTime8Two, startTime8Three, endTime8Three, startTime4One, endTime4One, startTime4Two, endTime4Two, startTime4Three, endTime4Three, startTimeFOne, endTimeFOne, startTimeFTwo, endTimeFTwo, startTimeFThree, endTimeFThree, nowTime, startDateAll, endDateAll, startTimeAll, endTimeAll, startSignTime, endSignTime, winScore, failScore, applyPunish, makePairPunish)
		return
	end
	WndWelfare:onReceiveLeagueDataOK(startTime32One,startTime16One,startTime8One, endTime32Three, endTime16Three, endTimeFThree, nowTime, startDateAll .. " " .. startTimeAll, endDateAll .. " " .. endTimeAll)
end

--@brief	取消匹配（HERO_EndMakePairHeroOk = 36）
function ProtocolProcessorWndLeague:parse_HERO_EndMakePairHeroOk()
	WZLog("ProtocolProcessorWndLeague:parse_HERO_EndMakePairHeroOk")
	--local show =  SceneLeagueRoom:needShowBox()
	--SceneLeagueMain:showInterface(2,show)
	if SceneLeagueMain.m_root == nil then
		SceneLeagueMain:showInterface(2)
	else
		local checkbox1 = GetElement(SceneLeagueMain.m_root, "checkbox1_SceneLeagueMain", WZUICheckBox)
		checkbox1:setCheckIndex(0)
		local checkbox2 = GetElement(SceneLeagueMain.m_root, "checkbox2_SceneLeagueMain", WZUICheckBox)
		checkbox2:setCheckIndex(1)
		--SceneLeagueMain:onTab2()
		SceneLeagueMain.m_nTab = 2
		SceneLeagueMain:hideAllSubWnd()
		if CacheCenter:getPlayerInfo().teamId == 0 then
			WndLeagueTeamList:show(GetElement(SceneLeagueMain.m_root,"conCurWindow_SceneLeagueMain",WZUIContainer))
			WndLeagueTeamDetail.m_tData = nil
		else
			WndLeagueTeamDetail:show(GetElement(SceneLeagueMain.m_root,"conCurWindow_SceneLeagueMain",WZUIContainer))
		end
		if WndLeagueTeamDetail.m_root ~= nil then
			GetElement(WndLeagueTeamDetail.m_root,"conCountDown",WZUIContainer):setVisible(false)
		end
	end
end

--@brief	请求英雄联赛观战列表（HERO_WatchListOk=44）
function ProtocolProcessorWndLeague:parse_HERO_WatchListOk(id, teamId, teamName, photoURL, watchNum, channel)
	-- id : 记录唯一标示
	-- teamId : 战队id
	-- teamName : 战队名字
	-- photoURL : 照片url
	-- watchNum : 观看人数
	-- channel : 战斗类型（1为海选赛，2为三十二强，3为十六强，4为八强，5为四强，6为决赛）
	WZLog("ProtocolProcessorWndLeague:parse_HERO_WatchListOk")
	WndLeagueHPR:setReplayData(id, teamId, teamName, photoURL, watchNum, channel)
end

--@brief	获得报名参加的玩家列表（HERO_GetEnterPlayerListOk = 88）
function ProtocolProcessorWndLeague:parse_HERO_GetEnterPlayerListOk(myTeamScore, myTeamTatus, teamId, url, score, rank, name)
	-- myTeamScore : 本队积分
	-- myTeamTatus : 本队是否报名
	-- teamId : 队伍id
	-- url : 队伍头像
	-- score : 队伍积分
	-- rank : 队伍排名
	WZLog("ProtocolProcessorWndLeague:parse_HERO_GetEnterPlayerListOk",myTeamScore,myTeamTatus)
	WndLeagueApply:setData(myTeamScore, myTeamTatus, VectorToTable(teamId), VectorToTable(url), VectorToTable(score), VectorToTable(rank), VectorToTable(name))
end

--@brief	邀请进入战队准备（被邀请人才能收到）(HERO_InvitationReadyOk = 54)
function ProtocolProcessorWndLeague:parse_HERO_InvitationReadyOk(msg)
	WZLog("ProtocolProcessorWndLeague:parse_HERO_InvitationReadyOk")
	if WindowManager:getTeachShelterLayer() or WndTeachTalk.m_root then return end
	if SceneRoom.m_root == nil and SceneBossRoom.m_root == nil and SceneBattle.m_root == nil and SceneBattleLoading.m_root == nil and not WndChat.m_bRecording and not SceneHall:getMatchState() and not WndTowerScroll.m_root then 
   		MsgBoxManager:showConfirmCancelBox(msg..LocalStrings.LEAGUE83, WndLeagueTeamDetail, WndLeagueTeamDetail.onInviteCall, MSGBOXLEVEL_HIGH,nil)
	end 
end

--@brief	审核小红点（队长才能收到）(HERO_ReviewRedDot = 55)
function ProtocolProcessorWndLeague:parse_HERO_ReviewRedDot()
	WZLog("ProtocolProcessorWndLeague:parse_HERO_ReviewRedDot")
	WndLeagueTeamDetail.m_bNeedRecruit = true
	WndLeagueTeamDetail:setRedDot()
end

--@brief	匹配战斗失败(HERO_MakePairHeroFail = 58)
function ProtocolProcessorWndLeague:parse_HERO_MakePairHeroFail(time)
	-- time : 剩余秒数
	WZLog("ProtocolProcessorWndLeague:parse_HERO_MakePairHeroFail",time)
	if time > 0 then
		local min = math.ceil(time/60)
		MsgBoxManager:showTipBox(min..LocalStrings.LEAGUE84)
	end
end

--@brief	战队战绩（HERO_GetFightMesOk = 90）
function ProtocolProcessorWndLeague:parse_HERO_GetFightMesOk(fightMes,teamId)
	-- fightMes : 战队战绩（小组赛战斗结果0为失败,1为胜利,2为弃权）120代表第一场胜利第二场弃权第三场失败
	WZLog("ProtocolProcessorWndLeague:parse_HERO_GetFightMesOk",fightMes,teamId)
	SceneLeagueRoom:updateGrade(fightMes,teamId)
end


--@brief	英雄联赛系统相关协议(MAIN_HERO = 120)
function ProtocolProcessorWndLeague:parse_HERO_CrossFightSuc(teamId)
	-- teamId : 战队Id
	WZLog("ProtocolProcessorWndLeague:parse_HERO_CrossFightSuc")
	SceneLeagueMain:showInterface(2,true)
end

-------------------------------------服务器到客户端协议回调方法模块End--------------------------------------


-------------------------------------协议错误处理方法模块Begin--------------------------------------
--@brief	创建战队（HERO_CreateTeam=1）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndLeague:send_HERO_CreateTeam_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndLeague:send_HERO_CreateTeam_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HERO, Protocol.HERO_CreateTeam, nflag, sMessage)
end

--@brief	获取战队列表（HERO_GetHeroTeamList = 3）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndLeague:send_HERO_GetHeroTeamList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndLeague:send_HERO_GetHeroTeamList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HERO, Protocol.HERO_GetHeroTeamList, nflag, sMessage)
end

--@brief	申请战队（HERO_ApplyHeroTeam = 5）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndLeague:send_HERO_ApplyHeroTeam_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndLeague:send_HERO_ApplyHeroTeam_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HERO, Protocol.HERO_ApplyHeroTeam, nflag, sMessage)
end

--@brief	获取英雄联赛战队申请列表（HERO_GetApplyList = 7）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndLeague:send_HERO_GetApplyList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndLeague:send_HERO_GetApplyList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HERO, Protocol.HERO_GetApplyList, nflag, sMessage)
end

--@brief	审核申请列表（HERO_Reviewed = 9）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndLeague:send_HERO_Reviewed_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndLeague:send_HERO_Reviewed_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HERO, Protocol.HERO_Reviewed, nflag, sMessage)
end

--@brief	查找战队（HERO_SearchTeam = 11）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndLeague:send_HERO_SearchTeam_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndLeague:send_HERO_SearchTeam_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HERO, Protocol.HERO_SearchTeam, nflag, sMessage)
end

--@brief	退出战队（HERO_OutTeam = 13）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndLeague:send_HERO_OutTeam_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndLeague:send_HERO_OutTeam_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HERO, Protocol.HERO_OutTeam, nflag, sMessage)
end

--@brief	踢出战队（HERO_KickTeam = 15）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndLeague:send_HERO_KickTeam_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndLeague:send_HERO_KickTeam_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HERO, Protocol.HERO_KickTeam, nflag, sMessage)
end

--@brief	邀请加入战队（HERO_Invitation = 17）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndLeague:send_HERO_Invitation_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndLeague:send_HERO_Invitation_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HERO, Protocol.HERO_Invitation, nflag, sMessage)
end

--@brief	同意加入战队（HERO_Agree = 19）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndLeague:send_HERO_Agree_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndLeague:send_HERO_Agree_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HERO, Protocol.HERO_Agree, nflag, sMessage)
end

--@brief	进入战队界面准备战斗（HERO_ReadyFight = 21）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndLeague:send_HERO_ReadyFight_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndLeague:send_HERO_ReadyFight_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HERO, Protocol.HERO_ReadyFight, nflag, sMessage)
end

--@brief	匹配战斗（HERO_MakePairHero = 23）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndLeague:send_HERO_MakePairHero_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndLeague:send_HERO_MakePairHero_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HERO, Protocol.HERO_MakePairHero, nflag, sMessage)
end

--@brief	退出战队界面（HERO_OutHeroRoom = 24）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndLeague:send_HERO_OutHeroRoom_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndLeague:send_HERO_OutHeroRoom_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HERO, Protocol.HERO_OutHeroRoom, nflag, sMessage)
end

--@brief	取消匹配（HERO_EndMakePairHero = 28）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndLeague:send_HERO_EndMakePairHero_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndLeague:send_HERO_EndMakePairHero_ErrorProcess")
	SceneLeagueRoom:closeLoadingBox()
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HERO, Protocol.HERO_EndMakePairHero, nflag, sMessage)
end

--@brief	报名参加小组赛（HERO_SignHeroStrong = 29）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndLeague:send_HERO_SignHeroStrong_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndLeague:send_HERO_SignHeroStrong_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HERO, Protocol.HERO_SignHeroStrong, nflag, sMessage)
end

--@brief	队长切换成员状态（HERO_ChangeStatus = 31）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndLeague:send_HERO_ChangeStatus_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndLeague:send_HERO_ChangeStatus_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HERO, Protocol.HERO_ChangeStatus, nflag, sMessage)
end

--@brief	修改宣言和图片（HERO_NewPhotoAndDec=34）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndLeague:send_HERO_NewPhotoAndDec_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndLeague:send_HERO_NewPhotoAndDec_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HERO, Protocol.HERO_NewPhotoAndDec, nflag, sMessage)
end

--@brief	海选赛排行（HERO_FirstSelectRank = 73）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndLeague:send_HERO_FirstSelectRank_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndLeague:send_HERO_FirstSelectRank_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HERO, Protocol.HERO_FirstSelectRank, nflag, sMessage)
end

--@brief	小组赛结果（HERO_TeamSelectRank = 75）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndLeague:send_HERO_TeamSelectRank_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndLeague:send_HERO_TeamSelectRank_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HERO, Protocol.HERO_TeamSelectRank, nflag, sMessage)
end

--@brief	16强（HERO_Team16SelectStatus = 77）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndLeague:send_HERO_Team16SelectStatus_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndLeague:send_HERO_Team16SelectStatus_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HERO, Protocol.HERO_Team16SelectStatus, nflag, sMessage)
end

--@brief	8强战况（HERO_Team8SelectStatus = 79）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndLeague:send_HERO_Team8SelectStatus_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndLeague:send_HERO_Team8SelectStatus_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HERO, Protocol.HERO_Team8SelectStatus, nflag, sMessage)
end

--@brief	海选赛奖励（HERO_FirstSelectReward = 71）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndLeague:send_HERO_FirstSelectReward_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndLeague:send_HERO_FirstSelectReward_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HERO, Protocol.HERO_FirstSelectReward, nflag, sMessage)
end

--@brief	获取历届冠军队列表（HERO_TeamFirstList = 81）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndLeague:send_HERO_TeamFirstList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndLeague:send_HERO_TeamFirstList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HERO, Protocol.HERO_TeamFirstList, nflag, sMessage)
end

--@brief	获取某一冠军队的详细信息（HERO_TeamFirstDetail = 83）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndLeague:send_HERO_TeamFirstDetail_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndLeague:send_HERO_TeamFirstDetail_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HERO, Protocol.HERO_TeamFirstDetail, nflag, sMessage)
end

--@brief	请求英雄联赛战斗回放列表（HERO_RecordList=37）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndLeague:send_HERO_RecordList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndLeague:send_HERO_RecordList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HERO, Protocol.HERO_RecordList, nflag, sMessage)
end

--@brief	请求战斗回放详细信息（HERO_RecordMes=41）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndLeague:send_HERO_RecordMes_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndLeague:send_HERO_RecordMes_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HERO, Protocol.HERO_RecordMes, nflag, sMessage)
end

--@brief	请求播放英雄联赛战斗回放列表（HERO_Record=39）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndLeague:send_HERO_Record_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndLeague:send_HERO_Record_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HERO, Protocol.HERO_Record, nflag, sMessage)
end

--@brief	英雄联赛开始时间（HERO_HeroStartTime = 85）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndLeague:send_HERO_HeroStartTime_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndLeague:send_HERO_HeroStartTime_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HERO, Protocol.HERO_HeroStartTime, nflag, sMessage)
end

--@brief	请求英雄联赛观战列表（HERO_WatchList=43）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndLeague:send_HERO_WatchList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndLeague:send_HERO_WatchList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HERO, Protocol.HERO_WatchList, nflag, sMessage)
end

--@brief	获得报名参加的玩家列表（HERO_GetEnterPlayerList = 87）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndLeague:send_HERO_GetEnterPlayerList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndLeague:send_HERO_GetEnterPlayerList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HERO, Protocol.HERO_GetEnterPlayerList, nflag, sMessage)
end

--@brief	邀请进入战队准备(HERO_InvitationReady = 53)错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndLeague:send_HERO_InvitationReady_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndLeague:send_HERO_InvitationReady_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HERO, Protocol.HERO_InvitationReady, nflag, sMessage)
end

--@brief	准备战斗(HERO_Ready = 59)错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndLeague:send_HERO_Ready_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndLeague:send_HERO_Ready_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HERO, Protocol.HERO_Ready, nflag, sMessage)
end

--@brief	取消战斗准备(HERO_CancelReady = 60)错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndLeague:send_HERO_CancelReady_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndLeague:send_HERO_CancelReady_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HERO, Protocol.HERO_CancelReady, nflag, sMessage)
end

--@brief	提升为副队长(HERO_Promotion = 61)错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndLeague:send_HERO_Promotion_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndLeague:send_HERO_Promotion_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HERO, Protocol.HERO_Promotion, nflag, sMessage)
end

--@brief	取消副队长(HERO_Cancel  = 62)错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndLeague:send_HERO_Cancel_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndLeague:send_HERO_Cancel_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HERO, Protocol.HERO_Cancel, nflag, sMessage)
end


--@brief	战队战绩（HERO_GetFightMes = 89）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndLeague:send_HERO_GetFightMes_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndLeague:send_HERO_GetFightMes_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HERO, Protocol.HERO_GetFightMes, nflag, sMessage)
end
-------------------------------------协议错误处理方法模块End--------------------------------------






