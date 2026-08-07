--ProtocolProcessorGlobal.lua
--@brief	全局协议
--@date  	2013/12/12
--@author 	xiaoyu_wu
--@note 	全局协议
ProtocolProcessorGlobal = ProtocolProcessorBase:new()

-------------------------------------公有方法模块--------------------------------------

--@brief	注册协议组所有协议
function ProtocolProcessorGlobal:regAll()
    WZLog("ProtocolProcessorGlobal:regAll")
	--个人信息更新协议
	--角色信息获取成功(S->C)
	--更新玩家属性成功(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_UpdatePlayerAttribute, "ProtocolProcessorGlobal:parse_PLAYER_UpdatePlayerAttribute", "s")
	--@brief	玩家升级提示
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_UpdatePlayerLevel, "ProtocolProcessorGlobal:parse_PLAYER_UpdatePlayerLevel", "i")
    
	--任务信息更新协议
	--任务状态变更协议(S->C)
	--self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_StatusChanged, "ProtocolProcessorGlobal:parse_TASK_StatusChanged", "ii")
	
	-----关于聊天
	--@brief	接收聊天信息
	self:regProtocolCallbackFunction( Protocol.MAIN_CHAT, Protocol.CHAT_ReceiveMessage, "ProtocolProcessorGlobal:parse_CHAT_ReceiveMessage", "tisissittiiittiiiisiiiiii")

	--@brief	进入房间成功（ROOM_EnterRoomOk = 6）
    self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_EnterRoomOk, "ProtocolProcessorGlobal:parse_ROOM_EnterRoomOk", "iiiiiiiiiivbvivivsvivbvivivivivsssvivsvivivivsvivsvivsvivissssssvivivivivivsvivi")


    --@brief	被邀请(副本房间)（BOSSMAPROOM_BeInvite = 23）
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_BeInvite, "ProtocolProcessorGlobal:parse_BOSSMAPROOM_BeInvite", "isisiiii")
    
	--@brief	被邀请
    self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_BeInvite, "ProtocolProcessorGlobal:parse_ROOM_BeInvite", "iissiiiii")
    
    --@brief	推送玩家的按钮信息
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_PlayerButtonInfo, "ProtocolProcessorGlobal:parse_PLAYER_PlayerButtonInfo", "vivtvivb")
    
    --@brief	推送玩家在线奖励信息
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_OnlineRewardInfo, "ProtocolProcessorGlobal:parse_PLAYER_OnlineRewardInfo", "is")
    
    --@brief	推送实时语聊开放表（CHAT_PushVoiceChatButtonInfo = 13）
	self:regProtocolCallbackFunction( Protocol.MAIN_CHAT, Protocol.CHAT_PushVoiceChatButtonInfo, "ProtocolProcessorGlobal:parse_CHAT_PushVoiceChatButtonInfo", "vivivivivs")

	--协议错误处理
	--获取角色信息错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerInfo, "ProtocolProcessorGlobal:send_PLAYER_GetPlayerInfo_ErrorProcess", "is" )
    
    --获取玩家身上装备成功
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerBodyEquipmentOk, "ProtocolProcessorGlobal:parse_PLAYER_GetPlayerBodyEquipmentOk", "ivivsvsvsvsvcvcvivivivivivivivivivivivsvivivbvbiiviviviviviviviviviviii")
    
    --@brief	查看主角信息成功
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_LookPlayerInfoOk, "ProtocolProcessorGlobal:parse_PLAYER_LookPlayerInfoOk", "isiiiibivssiiiiivsvsibvsvsvsvsvsvsvsvsvssssiiiiiiiiivs")

    --@brief	获取玩家身上装备列表（PLAYER_GetPlayerBodyEquipment = 5）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerBodyEquipment, "ProtocolProcessorGlobal:send_PLAYER_GetPlayerBodyEquipment_ErrorProcess", "is" )
    --@brief	查看主角信息错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_LookPlayerInfo, "ProtocolProcessorGlobal:send_PLAYER_LookPlayerInfo_ErrorProcess", "is" )
    
    --@brief	获取玩家仓库装备列表错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerStoreEquipmentNew, "ProtocolProcessorGlobal:send_PLAYER_GetPlayerStoreEquipmentNew_ErrorProcess", "is" )
    
	--@brief	可领取奖励的数量（TASK_GetRewardNum = 44）
	self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_GetRewardNum, "ProtocolProcessorGlobal:parse_TASK_GetRewardNum", "iiii")

    --@brief	获取关卡信息成功（MAP_GetSingleMapListOk = 2）
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_GetPointsOk, "ProtocolProcessorGlobal:parse_MAP_GetSingleMapListOk", "vivivivtvivtvivtvivt")

    --@brief	获取关卡信息错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_GetPoints, "ProtocolProcessorGlobal:send_SINGLEMAP_GetPoints_ErrorProcess", "is" )

    --@brief	发送副本列表
    self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_SendBossMapList, "ProtocolProcessorGlobal:parse_BOSSMAPROOM_SendBossMapList", "iviviviiis")
    --@brief	获得副本列表错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_GetBossMapList, "ProtocolProcessorGlobal:send_BOSSMAPROOM_GetBossMapList_ErrorProcess", "is" )
    --@brief	获取日常副本信息成功
    --self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_GetsMapOk, "ProtocolProcessorGlobal:parse_SINGLEMAP_GetDailyMapOk", "vivivbvi")
    --self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_GetsMapOk, "ProtocolProcessorGlobal:parse_SINGLEMAP_GetDailyMapOk", "vivivbvi")
    --@brief	获取日常副本信息错误处理(S->C)
    --self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_GetDailyMap, "ProtocolProcessorGlobal:send_SINGLEMAP_GetDailyMap_ErrorProcess", "is" )
    --@brief	邀请来宾请求给朋友（WEDDING_InvitationToFriend = 53）
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_InvitationToFriend, "ProtocolProcessorGlobal:parse_WEDDING_InvitationToFriend", "iss")

    --@brief	进入婚礼现场（WEDDING_JoinWeddingOK = 23)
   self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_JoinWeddingOK, "ProtocolProcessorGlobal:parse_WEDDING_JoinWeddingOK", "ssvivsvivivivivtvntiiisvtviviiiiiiiiiviiiviitii")


    --@brief	参加婚礼（WEDDING_JoinWedding = 22）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_JoinWedding, "ProtocolProcessorGloba:send_WEDDING_JoinWedding_ErrorProcess", "is" )
    --@brief	查找房间（ROOM_SelectRoom = 14）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_SelectRoom, "ProtocolProcessorGlobal:send_ROOM_SelectRoom_ErrorProcess", "is" )
 
    --@brief	通知全服有人结婚（WEDDING_NoticeOnlinePlayer = 56）
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_NoticeOnlinePlayer, "ProtocolProcessorGlobal:parse_WEDDING_NoticeOnlinePlayer", "t")

    --@brief	获取爬塔副本信息
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_GetTowerInfoOk, "ProtocolProcessorGlobal:parse_SINGLEMAP_GetTowerInfoOk", "iiiiibiii")

    --@brief    获取双人爬塔副本信息（BOSSMAPROOM_GetTwoTowerInfo = 44）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_GetTwoTowerInfo, "ProtocolProcessorGlobal:send_BOSSMAPROOM_GetTwoTowerInfo_ErrorProcess", "is" )
    --@brief    获取双人爬塔副本信息（BOSSMAPROOMP_GetTwoTowerInfoOk = 45）
    self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOMP_GetTwoTowerInfoOk, "ProtocolProcessorGlobal:parse_BOSSMAPROOMP_GetTwoTowerInfoOk", "iiiiiivtvii")

	--@brief	获取语音聊天协议Token错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_CHAT, Protocol.CHAT_GetIMToken, "ProtocolProcessorGlobal:send_CHAT_GetIMToken_ErrorProcess", "is" )

    --@brief	IMTOKEN结果（CHAT_GetIMToken = 6）
    self:regProtocolCallbackFunction( Protocol.MAIN_CHAT, Protocol.CHAT_GetIMTokenOK, "ProtocolProcessorGlobal:parse_CHAT_GetIMTokenOK", "ss")

    --@brief	聊天室列表（CHAT_GetRoomList = 7）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_CHAT, Protocol.CHAT_GetRoomList , "ProtocolProcessorGlobal:send_CHAT_GetRoomList_ErrorProcess", "is" )

    --@brief	聊天室列表结果（CHAT_GetRoomListOK = 8）
    self:regProtocolCallbackFunction( Protocol.MAIN_CHAT, Protocol.CHAT_GetRoomListOK, "ProtocolProcessorGlobal:parse_CHAT_GetRoomListOK", "vivtvis")
    
    --@brief	新增聊天室（CHAT_AddRoom = 9）
    self:regProtocolCallbackFunction( Protocol.MAIN_CHAT, Protocol.CHAT_AddRoom, "ProtocolProcessorGlobal:parse_CHAT_AddRoom", "iti")

    --@brief	删除聊天室（CHAT_DelRoom = 10）
    self:regProtocolCallbackFunction( Protocol.MAIN_CHAT, Protocol.CHAT_DelRoom, "ProtocolProcessorGlobal:parse_CHAT_DelRoom", "i")

    --@brief	世界语音聊天（CHAT_WorldIM = 11）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_CHAT, Protocol.CHAT_WorldIM, "ProtocolProcessorGlobal:send_CHAT_WorldIM_ErrorProcess", "is" )

    --@brief	世界语音聊天结果（CHAT_WorldIMOK = 12）
    self:regProtocolCallbackFunction( Protocol.MAIN_CHAT, Protocol.CHAT_WorldIMOK, "ProtocolProcessorGlobal:parse_CHAT_WorldIMOK", "i")
    
     --@brief     查看战斗记录(BATTLE_Record=56)错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.BATTLE_Record, "ProtocolProcessorGlobal:send_BATTLE_Record_ErrorProcess", "is" )
    --@brief      查看战斗记录(BATTLE_RecordOk=57)
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.BATTLE_RecordOk, "ProtocolProcessorGlobal:parse_BATTLE_RecordOk", "vsi")

    --@brief	同步战斗信息错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_SynchronousBattleInfo, "ProtocolProcessorGlobal:send_BATTLE_SynchronousBattleInfo_ErrorProcess", "is" )

    --@brief	同步战斗信息错误处理(S->C)
	-- self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_SynchronousBattleInfo, "ProtocolProcessorGlobal:send_BOSSMAPBATTLE_SynchronousBattleInfo_ErrorProcess", "is" )

	--@brief	观战开始错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.PLAYER_Watch, "ProtocolProcessorGlobal:send_PLAYER_Watch_ErrorProcess", "is" )

	--@brief	观战同步信息错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.PLAYER_SynchronousWatch, "ProtocolProcessorGlobal:send_PLAYER_SynchronousWatch_ErrorProcess", "is" )

	--@brief	观战开始成功
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.PLAYER_WatchOk, "ProtocolProcessorGlobal:parse_PLAYER_WatchOk", "iiiiivivivsvsvsvsvivivivivivivivivivivivivivivivivivivivivivivivivsvivivsvivivivivivivivsvsvnvivi")

	--@brief	观战同步信息成功
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.PLAYER_SynchronousWatchOk, "ProtocolProcessorGlobal:parse_PLAYER_SynchronousWatchOk", "iviviviviviviviviviviviviviviviviviviviviiivi")

	--@brief	发送观战信息成功(PLAYER_WatchMes = 87)
	self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.PLAYER_WatchMes, "ProtocolProcessorGlobal:parse_PLAYER_WatchMes", "ivs")

    --@brief	获取娱乐赛信息（ROOM_GetFunnyMatchInfo = 97）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_GetFunnyMatchInfo, "ProtocolProcessorGlobal:send_ROOM_GetFunnyMatchInfo_ErrorProcess", "is" )

    --@brief	获取娱乐赛信息结果（ROOM_GetFunnyMatchInfoOk = 96）
    self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_GetFunnyMatchInfoOk, "ProtocolProcessorGlobal:parse_ROOM_GetFunnyMatchInfoOk", "vtvtvsvii")
	
	--@brief	获取加成卡信息（ROOM_GetAdditionInfo = 100）
	self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_GetAdditionInfo, "ProtocolProcessorGlobal:parse_ROOM_GetAdditionInfo", "vivivii")
    
    --@brief	发送聊天信息（CHAT_SendMessage = 1）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.CHAT_SendMessage, Protocol.CHAT_SendMessage, "ProtocolProcessorGlobal:send_CHAT_SendMessage_ErrorProcess", "is" )

    --@brief	获取推送引导信息（PLAYER_PushCommentGuide = 87）
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_PushCommentGuide, "ProtocolProcessorGlobal:parse_PLAYER_PushCommentGuide", "i")

	--@brief	获取推送引导信息（PLAYER_FinishCommentOk = 89）
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_FinishCommentOk, "ProtocolProcessorGlobal:parse_PLAYER_FinishCommentOk", "s")
   
    --@brief	发送完成引导（PLAYER_FinishComment = 88）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_FinishComment, "ProtocolProcessorGlobal:send_PLAYER_FinishComment_ErrorProcess", "is" )

    --@brief    获取暑期活动状态,登陆时推送（ACTIVITY_GetSummerActivityStatusOk = 27）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetSummerActivityStatusOk, "ProtocolProcessorGlobal:parse_ACTIVITY_GetSummerActivityStatusOk", "tii")
    
	--@brief	获取代言人活动状态（ACTIVITY_GetSpokesmanActivityStatusOk = 33）
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetSpokesmanActivityStatusOk, "ProtocolProcessorGlobal:parse_ACTIVITY_GetSpokesmanActivityStatusOk", "t")
    --@brief    获取世界杯活动状态（ACTIVITY_GetWorldCupActivityStatusOk = 111）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetWorldCupActivityStatusOk, "ProtocolProcessorGlobal:parse_ACTIVITY_GetWorldCupActivityStatusOk", "t")
    --@brief    回归系列活动状态（ACTIVITY_GetUserBackActivityStatusOk = 112）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetUserBackActivityStatusOk, "ProtocolProcessorGlobal:parse_ACTIVITY_GetUserBackActivityStatusOk", "tits")
	
    --@brief    获取折扣商贩活动状态（MALL_GetDiscountStoreStatusOk = 36）
    self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_GetDiscountStoreStatusOk, "ProtocolProcessorGlobal:parse_MALL_GetDiscountStoreStatusOk", "t")

    --@brief    获取绝地大逃杀玩法状态
    self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_GetGreatEscapeStatusOk, "ProtocolProcessorGlobal:parse_ROOM_GetGreatEscapeStatusOk", "ti")

    --@brief    获取绝地大逃杀玩法状态错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_GetGreatEscapeStatus, "ProtocolProcessorGlobal:send_ROOM_GetGreatEscapeStatus_ErrorProcess", "is" )
    
    --@brief    检测排位赛惩罚剩余时间（ROOM_CheckPwPunish = 103）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_CheckPwPunish, "ProtocolProcessorGlobal:send_ROOM_CheckPwPunish_ErrorProcess", "is" )
    
    --@brief    检测排位赛惩罚剩余时间（ROOM_CheckPwPunishOk = 104）
    self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_CheckPwPunishOk, "ProtocolProcessorGlobal:parse_ROOM_CheckPwPunishOk", "ii")
    
    --@brief    激活聊天气泡（CHAT_Activate = 14）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_CHAT, Protocol.CHAT_Activate, "ProtocolProcessorGlobal:send_CHAT_Activate_ErrorProcess", "is" )

    --@brief    激活聊天气泡（CHAT_ActivateOK = 15）
    self:regProtocolCallbackFunction( Protocol.MAIN_CHAT, Protocol.CHAT_ActivateOK , "ProtocolProcessorGlobal:parse_CHAT_ActivateOK", "i")

    --@brief    购买聊天气泡（CHAT_BuyChatBubble = 16）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_CHAT, Protocol.CHAT_BuyChatBubble, "ProtocolProcessorGlobal:send_CHAT_BuyChatBubble_ErrorProcess", "is" )
    --@brief    购买聊天气泡（CHAT_BuyChatBubbleOk = 17）
    self:regProtocolCallbackFunction( Protocol.MAIN_CHAT, Protocol.CHAT_BuyChatBubbleOk , "ProtocolProcessorGlobal:parse_CHAT_BuyChatBubbleOk", "i")
    --@brief    世界组队Boss被邀请（TEAMWORLDBOSS_BeInvite = 8）
    self:regProtocolCallbackFunction( Protocol.MAIN_TEAMWORLDBOSS, Protocol.TEAMWORLDBOSS_BeInvite, "ProtocolProcessorGlobal:parse_TEAMWORLDBOSS_BeInvite", "isisiii")
    --@brief    夫妻争霸被邀请（COUPLEFIGHTBOSS_BeInvite = 8）
    self:regProtocolCallbackFunction( Protocol.MAIN_COUPLEFIGHTBOSS, Protocol.COUPLEFIGHTBOSS_BeInvite, "ProtocolProcessorGlobal:parse_COUPLEFIGHTBOSS_BeInvite", "isisiii")

    --@brief    点赞BUFF错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_ThumbUp, "ProtocolProcessorGlobal:send_BATTLE_ThumbUp_ErrorProcess", "is" )
    --@brief    点赞BUFF(BATTLE_ThumbUpOk = 106)
    self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_ThumbUpOk, "ProtocolProcessorGlobal:parse_BATTLE_ThumbUpOk", "isis")
    --@brief    助战成功（BOSSMAPROOM_AssistOk =36）
    self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_AssistOk, "ProtocolProcessorGlobal:parse_BOSSMAPROOM_AssistOk", "s")

    --@brief    聊天举报（CHAT_ChatReport = 18）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_CHAT, Protocol.CHAT_ChatReport, "ProtocolProcessorGlobal:send_CHAT_ChatReport_ErrorProcess", "is" )
    --@brief   聊天举报结果（CHAT_ChatReportOk = 19）
    self:regProtocolCallbackFunction( Protocol.MAIN_CHAT, Protocol.CHAT_ChatReportOk, "ProtocolProcessorGlobal:parse_CHAT_ChatReportOk", "i")

    --@brief   开启调研（PLAYER_OpenInvestigate = 114）
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_OpenInvestigate, "ProtocolProcessorGlobal:parse_PLAYER_OpenInvestigate", "")

    --@brief    错误提示语PLAYER2_Tips = 5
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER2, Protocol.PLAYER2_Tips, "ProtocolProcessorGlobal:parse_PLAYER2_Tips", "is")

    --回流活动的弹窗
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_ActivityDoOk, "ProtocolProcessorGlobal:parse_ACTIVITY2_ActivityDoOk", "iiiis")
    --@brief    记录打开界面（PLAYER2_LogOpenAct = 36）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER2, Protocol.PLAYER2_LogOpenAct, "ProtocolProcessorGlobal:send_PLAYER2_LogOpenAct_ErrorProcess", "is")

    --@brief    玩家行为通知，不返回给发送人了，直接推到目标玩家（PLAYER2_ActToDo = 40）
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER2, Protocol.PLAYER2_ActToDo, "ProtocolProcessorGlobal:parse_PLAYER2_ActToDo", "iisi")
    --@brief    玩家行为通知（PLAYER2_ActToOtherOk = 41）
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER2, Protocol.PLAYER2_ActToOtherOk, "ProtocolProcessorGlobal:parse_PLAYER2_ActToOtherOk", "")

    --@brief    岛主复仇通知（MAP_SendLandlordNotify = 61）
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.MAP_SendLandlordNotify, "ProtocolProcessorGlobal:parse_MAP_SendLandlordNotify", "vivivivsvivivivsvivivivivivi")
    --@brief    获取岛主副本红点（MAP_LandlordRedDot = 63）
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.MAP_LandlordRedDot, "ProtocolProcessorGlobal:parse_MAP_LandlordRedDot", "vi")

    --活动结束主动推送
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_ActivityClose, "ProtocolProcessorGlobal:parse_ACTIVITY2_ActivityClose", "vi")
    --@brief    发红包（CHAT_SendRedEnvelope = 21）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_CHAT, Protocol.CHAT_SendRedEnvelope, "ProtocolProcessorGlobal:send_CHAT_SendRedEnvelope_ErrorProcess", "is")
    --@brief    抢红包（CHAT_GrabRedEnvelope = 23）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_CHAT, Protocol.CHAT_GrabRedEnvelope, "ProtocolProcessorGlobal:send_CHAT_GrabRedEnvelope_ErrorProcess", "is")
    --@brief    获取最近发的红包信息（CHAT_GetRedEnvelopeInfo = 27）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_CHAT, Protocol.CHAT_GetRedEnvelopeInfo, "ProtocolProcessorGlobal:send_CHAT_GetRedEnvelopeInfo_ErrorProcess", "is")
    --@brief    发红包返回（CHAT_SendRedEnvelopeOk = 22）
    self:regProtocolCallbackFunction( Protocol.MAIN_CHAT, Protocol.CHAT_SendRedEnvelopeOk, "ProtocolProcessorGlobal:parse_CHAT_SendRedEnvelopeOk", "it")
    --@brief    红包信息（CHAT_GetRedEnvelopeInfoOk = 28）
    self:regProtocolCallbackFunction( Protocol.MAIN_CHAT, Protocol.CHAT_GetRedEnvelopeInfoOk, "ProtocolProcessorGlobal:parse_CHAT_GetRedEnvelopeInfoOk", "it")
    --@brief    抢红包结果（CHAT_GrabRedEnvelopeOk = 24）
    self:regProtocolCallbackFunction( Protocol.MAIN_CHAT, Protocol.CHAT_GrabRedEnvelopeOk, "ProtocolProcessorGlobal:parse_CHAT_GrabRedEnvelopeOk", "iisiiiiiiiiiit")

    --@brief    接收发言（CHAT_ReceiveMessageBatch = 33）
    self:regProtocolCallbackFunction( Protocol.MAIN_CHAT, Protocol.CHAT_ReceiveMessageBatch, "ProtocolProcessorGlobal:parse_CHAT_ReceiveMessageBatch", "tvivsvivsvsvivtvtvivivivtvtvivivivivsvivivivivivi")

    --@brief    聊天屏蔽（CHAT_ChatShield = 34）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_CHAT, Protocol.CHAT_ChatShield, "ProtocolProcessorGlobal:send_CHAT_ChatShield_ErrorProcess", "is")
    --@brief    聊天屏蔽（CHAT_ChatShieldOk = 35）
    self:regProtocolCallbackFunction( Protocol.MAIN_CHAT, Protocol.CHAT_ChatShieldOk, "ProtocolProcessorGlobal:parse_CHAT_ChatShieldOk", "")
    --@brief    被邀请加入联盟（LEAGUE_BeInvite = 35）
    self:regProtocolCallbackFunction( Protocol.MAIN_LEAGUE, Protocol.LEAGUE_BeInvite, "ProtocolProcessorGlobal:parse_LEAGUE_BeInvite", "isisi")
    --@brief    回复入盟邀请OK（LEAGUE_ResponseInviteOk = 37）
    self:regProtocolCallbackFunction( Protocol.MAIN_LEAGUE, Protocol.LEAGUE_ResponseInviteOk, "ProtocolProcessorGlobal:parse_LEAGUE_ResponseInviteOk", "")



    --@brief    参与评分奖励（PLAYER2_ReceivePraiseReward = 50）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER2, Protocol.PLAYER2_ReceivePraiseReward, "ProtocolProcessorGlobal:send_PLAYER2_ReceivePraiseReward_ErrorProcess", "is")
    --@brief    参与评分奖励成功（PLAYER2_ReceivePraiseRewardOk = 51）
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER2, Protocol.PLAYER2_ReceivePraiseRewardOk, "ProtocolProcessorGlobal:parse_PLAYER2_ReceivePraiseRewardOk", "ivivi")

    ProtocolProcessorWndFriends:regAll()
	ProtocolProcessorWndMail:regAll()
	ProtocolProcessorWndShop:regAll()
	ProtocolProcessorSceneCommunity:regAll()
	ProtocolProcessorDesignation:regAll()
    ProtocolProcessorWndBottomMenu:regAll()
    ProtocolProcessorCache:regAll()
    ProtocolProcessorPrefetchCache:regAll()
    ProtocolProcessorSceneCity:regAll()
    ProtocolProcessorBossMap:regAll()
	ProtocolProcessorWndMaster:regAll()
    ProtocolProcessorWndMounts:regAll()
    ProtocolProcessorRecharge:regAll()
	ProtocolProcessorRecycling:regAll()
    ProtocolProcessorScenePvpRank:regAll()
    ProtocolProcessorSceneHall:regAll()
	ProtocolProcessorWndSpace:regAll()
	ProtocolProcessorWndSkillProp:regAll()
	ProtocolProcessorWndLeague:regAll()
    ProtocolProcessorCommunityWar:regAll()
    ProtocolProcessorRedPack:regAll()
    ProtocolProcessorWndVip:regAll()
    ProtocolProcessorWndTask:regAll()

    ProtocolProcessorStore:regAll()

    ProtocolProcessorPromiseShrine:regAll()
	ProtocolProcessorPhantom:regAll()
	ProtocolProcessorWndAscending:regAll()
    ProtocolProcessorCommonPush:regAll()
    ProtocolProcessorWndActivityOnLine:regAll()
end

--@brief	反注册协议组所有协议
function ProtocolProcessorGlobal:unregAll()
    ProtocolProcessorScenePvpRank:unregAll()
    ProtocolProcessorRecharge:unregAll()
	ProtocolProcessorWndFriends:unregAll()
    ProtocolProcessorWndBottomMenu:unregAll()
    ProtocolProcessorCache:unregAll()
    ProtocolProcessorPrefetchCache:unregAll()
    ProtocolProcessorBossMap:unregAll()
    ProtocolProcessorSceneCity:unregAll()
	ProtocolProcessorWndMail:unregAll()
	ProtocolProcessorDesignation:unregAll()
	ProtocolProcessorWndShop:unregAll()
	ProtocolProcessorWndMaster:unregAll()
	ProtocolProcessorSceneCommunity:unregAll()
    ProtocolProcessorWndMounts:unregAll()
	ProtocolProcessorRecycling:unregAll()
	ProtocolProcessorSceneHall:unregAll()
	ProtocolProcessorWndSpace:unregAll()
	ProtocolProcessorWndSkillProp:unregAll()
	ProtocolProcessorWndLeague:unregAll()
    ProtocolProcessorCommunityWar:unregAll()
    ProtocolProcessorRedPack:unregAll()
    ProtocolProcessorWndVip:unregAll()
    ProtocolProcessorStore:unregAll()
    ProtocolProcessorPromiseShrine:unregAll()
	ProtocolProcessorPhantom:unregAll()
	ProtocolProcessorWndAscending:unregAll()
    ProtocolProcessorWndTask:unregAll()
    ProtocolProcessorCommonPush:unregAll()
    ProtocolProcessorFootMark:unregAll()
    ProtocolProcessorWndActivityOnLine:unregAll()
    ProtocolProcessorScenePets:unregAll()
	self:clearReg()
end

--@brief    注册协议组所有协议
function ProtocolProcessorGlobal:regAllTwo()
    --@brief    等级突破【167新增】（PLAYER2_LevelBreach = 42）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER2, Protocol.PLAYER2_LevelBreach, "ProtocolProcessorGlobal:send_PLAYER2_LevelBreach_ErrorProcess", "is")
    --@brief    等级突破【167新增】（PLAYER2_LevelBreachOk = 43）
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER2, Protocol.PLAYER2_LevelBreachOk, "ProtocolProcessorGlobal:parse_PLAYER2_LevelBreachOk", "iii")
end

--@brief    反注册协议组所有协议
function ProtocolProcessorGlobal:unregAllTwo()
    --@brief    等级突破【167新增】（PLAYER2_LevelBreach = 42）错误处理(S->C)
    self:unregProtocolCallbackFunction( Protocol.MAIN_PLAYER2, Protocol.PLAYER2_LevelBreach, "ProtocolProcessorGlobal:send_PLAYER2_LevelBreach_ErrorProcess", "is")
    --@brief    等级突破【167新增】（PLAYER2_LevelBreachOk = 43）
    self:unregProtocolCallbackFunction( Protocol.MAIN_PLAYER2, Protocol.PLAYER2_LevelBreachOk, "ProtocolProcessorGlobal:parse_PLAYER2_LevelBreachOk", "iii")
end
-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief    获取绝地大逃杀玩法状态
function ProtocolProcessorGlobal:send_ROOM_GetGreatEscapeStatus( )
    WZLog("send_ROOM_GetGreatEscapeStatus")
    local sender = Protocol:getSender( Protocol.MAIN_ROOM, Protocol.ROOM_GetGreatEscapeStatus )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief	发送完成引导
function ProtocolProcessorGlobal:send_PLAYER_FinishComment(id,tag,params )
	WZLog("send_PLAYER_GetPlayerInfo")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_FinishComment )
	if sender==nil then WZLog("sender == nil") return end
    sender:writeInt( id ) -- 
	sender:writeByte( tag ) -- 
	sender:writeString( params ) -- 
	SendProtocol(sender,false) --t
end

--@brief	获取角色信息
function ProtocolProcessorGlobal:send_PLAYER_GetPlayerInfo(noviceTutorials )
	WZLog("send_PLAYER_GetPlayerInfo")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerInfo )
	if sender==nil then WZLog("sender == nil") return end
    
	sender:writeInt( noviceTutorials ) -- 是否新手教程0不是1是
	SendProtocol(sender,false) --true:showLoading
end

--@brief	更换聊天频道（C->S）
function ProtocolProcessorGlobal:send_CHAT_ChangeChannel(channelId )
	WZLog("send_CHAT_ChangeChannel")
	local sender = Protocol:getSender( Protocol.MAIN_CHAT, Protocol.CHAT_ChangeChannel )
	if sender==nil then WZLog("sender == nil") return end
	sender:writeInt( channelId )	-- 当前频道id（界面id）
	SendProtocol(sender,false) --true:showLoading
	WZLog("send_CHAT_ChangeChannel2")
end

--@brief	发送聊天信息（CHAT_SendMessage = 1）
function ProtocolProcessorGlobal:send_CHAT_SendMessage(channel, messageType, message, playerId,bubbleId )
	WZLog("send_CHAT_SendMessage", bubbleId)
	local sender = Protocol:getSender( Protocol.MAIN_CHAT, Protocol.CHAT_SendMessage )
	if sender==nil then WZLog("sender == nil") return end
    if bubbleId == nil then bubbleId = WndChat:getPlayerBubble() end
    WZLog("bubbleId =",bubbleId)
	sender:writeByte( channel )	-- 频道（0世界，1当前，2公会，3队伍，4私聊, 5系统, 6彩聊）
	sender:writeByte( messageType )	-- 0文字聊天，7语音聊天，8同步语音ID
	sender:writeString( message )	-- 聊天内容
	sender:writeInt( playerId )	-- 信息接收人ID（私聊时用,用名称时该字段为-1）
    sender:writeInt(bubbleId) --聊天气泡ID
	SendProtocol(sender,false) --true:showLoading
end


--@brief	获取喇叭数量（C->S）
function ProtocolProcessorGlobal:send_CHAT_GetSpeakerNum(playerId )
	WZLog("send_CHAT_GetSpeakerNum")
	local sender = Protocol:getSender( Protocol.MAIN_CHAT, Protocol.CHAT_GetSpeakerNum )
	if sender==nil then WZLog("sender == nil") return end
    
	sender:writeInt( playerId )	-- 玩家ID
	SendProtocol(sender,false) --true:showLoading
end

--@brief	进入房间（BOSSMAPROOM_EnterRoom = 5）
function ProtocolProcessorGlobal:send_BOSSMAPROOM_EnterRoom(roomId, mapId)
	WZLog("send_BOSSMAPROOM_EnterRoom")
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_EnterRoom )
	if sender==nil then WZLog("sender == nil") return end
    
	sender:writeInt( roomId )	-- 房间Id
	sender:writeInt( mapId )	-- 房间Id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取关卡信息
function ProtocolProcessorGlobal:send_SINGLEMAP_GetPoints( id )
	WZLog("send_SINGLEMAP_GetPoints")
	local sender = Protocol:getSender( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_GetPoints )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( id )	-- 大关卡顺序
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获得副本列表
function ProtocolProcessorGlobal:send_BOSSMAPROOM_GetBossMapList()
	WZLog("send_BOSSMAPROOM_GetBossMapList")
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_GetBossMapList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

----@brief	获取日常副本信息
--function ProtocolProcessorGlobal:send_SINGLEMAP_GetDailyMap( )
--	WZLog("send_SINGLEMAP_GetDailyMap")
--	local sender = Protocol:getSender( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_GetDailyMap )
--	if sender==nil then WZLog("sender == nil") return end
--
--	SendProtocol(sender,false) --true:showLoading
--end

--@brief	查找房间（ROOM_SelectRoom = 14）
function ProtocolProcessorGlobal:send_ROOM_SelectRoom(roomId, roomChannel, numMode, passWord )
	WZLog("send_ROOM_SelectRoom ",roomChannel)
	local sender = Protocol:getSender( Protocol.MAIN_ROOM, Protocol.ROOM_SelectRoom )
	if sender==nil then WZLog("sender == nil") return end
	sender:writeInt( roomId )	-- 房间Id
	sender:writeInt(roomChannel)
    sender:writeInt(numMode) --[177+]房间人数模式(2=2V2|3=3V3)
	sender:writeString( passWord )	-- 房间密码，"-1"为没有密码
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取语音聊天协议Token
function ProtocolProcessorGlobal:send_CHAT_GetIMToken( )
	WZLog("send_CHAT_GetIMToken")
	local sender = Protocol:getSender( Protocol.MAIN_CHAT, Protocol.CHAT_GetIMToken )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	聊天室列表（CHAT_GetRoomList = 7）
function ProtocolProcessorGlobal:send_CHAT_GetRoomList()
	WZLog("send_CHAT_GetRoomList ")
	local sender = Protocol:getSender( Protocol.MAIN_CHAT, Protocol.CHAT_GetRoomList  )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	世界语音聊天（CHAT_WorldIM = 11）
function ProtocolProcessorGlobal:send_CHAT_WorldIM()
	WZLog("send_CHAT_WorldIM")
	local sender = Protocol:getSender( Protocol.MAIN_CHAT, Protocol.CHAT_WorldIM )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief     查看战斗记录(BATTLE_Record=56)
function ProtocolProcessorGlobal:send_BATTLE_Record(id,typeId,levelId)
    WZLog("send_BATTLE_Record")
    local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.BATTLE_Record )
    if sender==nil then WZLog("sender == nil") return end
    sender:writeInt( id )   --录像Id
    sender:writeInt( typeId )   --录像类型
    sender:writeInt( levelId )   -- 关卡ID
    SendProtocol(sender,false) --true:showLoading
end

--@brief	观战开始
function ProtocolProcessorGlobal:send_PLAYER_Watch(battleId )
	WZLog("send_PLAYER_Watch")
	local sender = Protocol:getSender( Protocol.MAIN_HERO, Protocol.PLAYER_Watch )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( 0 )	-- 服务器id
	sender:writeInt( 1 )	-- playerid
	SendProtocol(sender,false) --true:showLoading
end

--@brief	观战同步信息
function ProtocolProcessorGlobal:send_PLAYER_SynchronousWatch(battleId )
	WZLog("send_PLAYER_SynchronousWatch", battleId)
	local sender = Protocol:getSender( Protocol.MAIN_HERO, Protocol.PLAYER_SynchronousWatch )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( 0 )	-- 服务器id
	sender:writeInt( WBattleGlobal:getCurrent():getMyBattleId() )	-- playerid
	sender:writeInt( battleId )	-- 战斗id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	结束观战
function ProtocolProcessorGlobal:send_HERO_EndWatch(battleId)
	WZLog("send_HERO_EndWatch")
	local sender = Protocol:getSender( Protocol.MAIN_HERO, Protocol.HERO_EndWatch )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( battleId )	-- 战斗id
	sender:writeInt( 1 )	-- playerid
	SendProtocol(sender,false) --true:showLoading
end

--@brief    检测排位赛惩罚剩余时间（ROOM_CheckPwPunish = 103）
function ProtocolProcessorGlobal:send_ROOM_CheckPwPunish(channel)
    -- channel : 战斗频道
    WZLog("send_ROOM_CheckPwPunish")
    local sender = Protocol:getSender( Protocol.MAIN_ROOM, Protocol.ROOM_CheckPwPunish )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( channel ) -- 战斗id
    SendProtocol(sender,false) --true:showLoading
end

--@brief    激活聊天气泡（CHAT_Activate = 14）
function ProtocolProcessorGlobal:send_CHAT_Activate(bubbleId )
    WZLog("send_CHAT_Activate")
    local sender = Protocol:getSender( Protocol.MAIN_CHAT, Protocol.CHAT_Activate )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( bubbleId ) -- 聊天气泡Id
    SendProtocol(sender,false) --true:showLoading
end

--@brief    购买聊天气泡（CHAT_BuyChatBubble = 16）
function ProtocolProcessorGlobal:send_CHAT_BuyChatBubble(bubbleId )
    WZLog("send_CHAT_BuyChatBubble")
    local sender = Protocol:getSender( Protocol.MAIN_CHAT, Protocol.CHAT_BuyChatBubble )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( bubbleId ) -- 聊天气泡Id
    SendProtocol(sender,false) --true:showLoading
end

--@brief    点赞BUFF(BATTLE_ThumbUp = 105)
function ProtocolProcessorGlobal:send_BATTLE_ThumbUp(targetPlayerId )
    WZLog("send_BATTLE_ThumbUp")
    local sender = Protocol:getSender( Protocol.MAIN_BATTLE, Protocol.BATTLE_ThumbUp )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( targetPlayerId ) -- 被点赞的玩家Id
    SendProtocol(sender,false) --true:showLoading
end

--@brief    聊天举报（CHAT_ChatReport = 18）
function ProtocolProcessorGlobal:send_CHAT_ChatReport(playerId, report, content, explain)
    WZLog("send_CHAT_ChatReport")
    local sender = Protocol:getSender( Protocol.MAIN_CHAT, Protocol.CHAT_ChatReport)
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( playerId ) -- 被举报者id
    sender:writeInt( report ) -- 举报选项
    sender:writeString( content ) -- 被举报者聊天内容
    sender:writeString( explain ) -- 举报说明
    SendProtocol(sender,false) --true:showLoading
end

--@brief    记录打开界面（PLAYER2_LogOpenAct = 36）
function ProtocolProcessorGlobal:send_PLAYER2_LogOpenAct(actType, actInfo)
    WZLog("send_PLAYER2_LogOpenAct")
    local sender = Protocol:getSender( Protocol.MAIN_PLAYER2, Protocol.PLAYER2_LogOpenAct )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt(actType)    -- 操作界面类型 功能类型|活动类型
    sender:writeInt(actInfo)    -- 操作信息 一般定义id或者序号
    SendProtocol(sender,false) --true:showLoading
end

--@brief    发红包（CHAT_SendRedEnvelope = 21）
function ProtocolProcessorGlobal:send_CHAT_SendRedEnvelope(money, num, moneyType, wishWordsId, coverId, channelId)
    WZLog("send_CHAT_SendRedEnvelope", money, num, moneyType, wishWordsId, coverId, channelId)
    local sender = Protocol:getSender( Protocol.MAIN_CHAT, Protocol.CHAT_SendRedEnvelope )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt(money)  -- 红包金额
    sender:writeInt(num)    -- 红包个数
    sender:writeByte(moneyType) -- 红包类型,2、金币，70、礼钻
    sender:writeByte(wishWordsId)   -- 祝福话语id
    sender:writeInt(coverId)    -- 封面id
    sender:writeByte(channelId) -- 0-世界，1-公会
    SendProtocol(sender,false) --true:showLoading
end

--@brief    抢红包（CHAT_GrabRedEnvelope = 23）
function ProtocolProcessorGlobal:send_CHAT_GrabRedEnvelope(redEnvId, channelId)
    WZLog("send_CHAT_GrabRedEnvelope", redEnvId, channelId)
    local sender = Protocol:getSender( Protocol.MAIN_CHAT, Protocol.CHAT_GrabRedEnvelope )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt(redEnvId)   -- 红包id
    sender:writeByte(channelId) -- 0-世界，1-公会
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取最近发的红包信息（CHAT_GetRedEnvelopeInfo = 27）
function ProtocolProcessorGlobal:send_CHAT_GetRedEnvelopeInfo(channelId)
    WZLog("send_CHAT_GetRedEnvelopeInfo", channelId)
    local sender = Protocol:getSender( Protocol.MAIN_CHAT, Protocol.CHAT_GetRedEnvelopeInfo )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeByte(channelId) -- 0-世界，1-公会
    SendProtocol(sender,false) --true:showLoading
end

--@brief    等级突破【167新增】（PLAYER2_LevelBreach = 42）
function ProtocolProcessorGlobal:send_PLAYER2_LevelBreach()
    WZLog("send_PLAYER2_LevelBreach")
    local sender = Protocol:getSender( Protocol.MAIN_PLAYER2, Protocol.PLAYER2_LevelBreach )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    聊天屏蔽（CHAT_ChatShield = 34）
function ProtocolProcessorGlobal:send_CHAT_ChatShield(opType)
    WZLog("send_CHAT_ChatShield")
    local sender = Protocol:getSender( Protocol.MAIN_CHAT, Protocol.CHAT_ChatShield )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt(opType) -- 二进制表示 屏蔽陌生人私聊，屏蔽公会私聊
    SendProtocol(sender,false) --true:showLoading
end


--@brief    评分奖励请求（PLAYER2_ReceivePraiseReward = 50）
function ProtocolProcessorGlobal:send_PLAYER2_ReceivePraiseReward()
    WZLog("send_PLAYER2_ReceivePraiseReward")
    local sender = Protocol:getSender( Protocol.MAIN_PLAYER2, Protocol.PLAYER2_ReceivePraiseReward )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end
-------------------------------------服务器到客户端协议回调方法模块--------------------------------------
--@brief    获取绝地大逃杀玩法状态
function ProtocolProcessorGlobal:parse_ROOM_GetGreatEscapeStatusOk(status, changeTime)
    -- status : 大逃杀频道的开启状态0关闭，1开启
    -- changeTime : 大逃杀频道状态转换时间单位（秒）
    WZLog("ProtocolProcessorGlobal:parse_ROOM_GetGreatEscapeStatusOk", status, changeTime)
    GlobalGame.g_nEscapeState = status
    GlobalGame.g_nEscapeReceiveTime = os.time()
    GlobalGame.g_nEscapeSurplusTime = changeTime
end

--@brief	获取推送引导信息（PLAYER_PushCommentGuide = 87）
function ProtocolProcessorGlobal:parse_PLAYER_PushCommentGuide(id)
	WZLog("ProtocolProcessorGlobal:parse_PLAYER_PushCommentGuid:",id)
	WndComment:show(id)
end

--@brief	获取推送引导信息（PLAYER_FinishCommentOk = 89）
function ProtocolProcessorGlobal:parse_PLAYER_FinishCommentOk(reward)
	WZLog("ProtocolProcessorGlobal:parse_PLAYER_FinishCommentOk:",reward)
    if string.len(reward) >= 1 then
	   local id,num = SplitItemString(reward)
	   WndRewardShow:showById(id,num)
    end
end

--@brief	推送实时语聊开放表（CHAT_PushVoiceChatButtonInfo = 13）
function ProtocolProcessorGlobal:parse_CHAT_PushVoiceChatButtonInfo(id, sceneType, showLevel, openLevel, channel)
	-- id : id
	-- sceneType : 场景id
	-- showLevel : 显示等级
	-- openLevel : 开放等级
	-- channel : 渠道

    --do return end
	id = VectorToTable(id)
	sceneType = VectorToTable(sceneType)
	showLevel = VectorToTable(showLevel)
	openLevel = VectorToTable(openLevel)
	channel = VectorToTable(channel)
--	WZLog("ProtocolProcessorGlobal:parse_CHAT_PushVoiceChatButtonInfo one", GDatatab_talk_button_info["id_1"].show_level, Serialize(id), Serialize(sceneType), Serialize(showLevel), Serialize(openLevel), Serialize(channel))
	for i,v in pairs(id) do
		for k,u in pairs(GDatatab_talk_button_info) do
			if v == u.id then
				u.show_level = showLevel[i]
				u.open_level = openLevel[i]
				u.channel = channel[i]
				break
			end
		end
	end
	WZLog("ProtocolProcessorGlobal:parse_CHAT_PushVoiceChatButtonInfo two", GDatatab_talk_button_info["id_1"].show_level)
end


--@brief	观战开始成功(PLAYER_WatchOk = 83)
function ProtocolProcessorGlobal:parse_PLAYER_WatchOk(battleId,battleMode,battleChannle,mapId, playerCount, playerCamp,
	playerId, serverId, playerName, playerTitle, playerCommunity, playerLevel, playerSex, maxHP, maxPF, maxSP, 
	attack, critRate, defence, injuryFree, wreckDefense, reduceCrit, power, armor, constitution, agility, lucky, 
	winRate, fighting, headId, faceId, bodyId, weaponId, wingId, item_id, petSkill, playerBuffCount, buffId, petId, 
	petParam, battleTimes, winTimes, streakTimes, segmentLevel, tournamentLevel,teamId,teamName,url, 
	petLevel, colour, bodyColour)
    -- -- battleId : 战斗组Id
	-- battleMode : 对战模式
	-- battleChannle : 对战频道(1、积分赛， 2、练习赛，5、排位赛，6、公会赛、7弹王赛,大于7的都是英雄联赛)
	-- mapId : 地图id
	-- playerCount : 玩家数量
	-- playerCamp : 玩家阵营
	-- playerId : 所有玩家id
	-- serverId : 玩家所在服id
	-- playerName : 房间内玩家昵称
	-- playerTitle : 称号
	-- playerGuild : 公会名称
	-- playerLevel : 房间内玩家等级
	-- playerSex : 玩家性别（0男1女）
	-- maxHP : 最大血量
	-- maxPF : 最大体力值
	-- maxSP : 最大怒气
	-- attack : 普攻击力
	-- critRate : 爆击攻击力比率
	-- defence : 防御力
	-- injuryFree : 免伤(10000)
	-- wreckDefense : 破防(10000)
	-- reduceCrit : 免暴(10000)
	-- power : 力量
	-- armor : 护甲
	-- constitution : 体质
	-- agility : 敏捷
	-- lucky : 幸运
	-- winRate : 玩家的胜率(万分比)
	-- fighting : 玩家的战斗力
	-- headId : 着装串头
	-- faceId : 着装串脸
	-- bodyId : 着装串身
	-- weaponId : 着装串武器
	-- skillful : 玩家武器熟练度
	-- wingId : 着装翅膀
	-- item_id : 技能道具ID（0没装备，-1锁, 其他ID）
	-- playerBuffCount : 表示每一个player,buff的数量,如果没有要填零
	-- buffId : 玩家BUFFID
	-- petAnimation : 宠物形象，空字符串表示无宠物
	-- petGift : 宠物资质
	-- battleTimes : 排位赛本周战斗次数
	-- winTimes : 排位赛本周胜利战斗次数
	-- streakTimes : 排位赛当前连胜次数
	-- segmentLevel : 排位赛段位等级
	-- weaponSkill :  着装串武器拥有的技能
	-- tournamentLevel : 竞技等级
	WZLog("ProtocolProcessorGlobal:parse_PLAYER_WatchOk", tostring(battleMull), battleChannle,"\n\nbattleId",serverId,

    Serialize(VectorToTable(battleId)),Serialize(VectorToTable(battleMode)),Serialize(VectorToTable(mapId)),Serialize(VectorToTable(playerCount)),Serialize(VectorToTable(playerCamp)),Serialize(VectorToTable(playerId)),Serialize(VectorToTable(playerName)),Serialize(VectorToTable(playerTitle)),Serialize(VectorToTable(playerCommunity)),"\n\nplayerLevel",

    Serialize(VectorToTable(playerLevel)),Serialize(VectorToTable(playerSex)),Serialize(VectorToTable(maxHP)),Serialize(VectorToTable(maxPF)),Serialize(VectorToTable(maxSP)),Serialize(VectorToTable(attack)),Serialize(VectorToTable(critRate)),Serialize(VectorToTable(defence)),Serialize(VectorToTable(injuryFree)),"\n\nwreckDefense",

    Serialize(VectorToTable(wreckDefense)),Serialize(VectorToTable(reduceCrit)),Serialize(VectorToTable(power)),Serialize(VectorToTable(armor)),Serialize(VectorToTable(constitution)),Serialize(VectorToTable(agility)),Serialize(VectorToTable(lucky)),"\n\nheadId",

    Serialize(VectorToTable(headId)),Serialize(VectorToTable(faceId)),Serialize(VectorToTable(bodyId)),Serialize(VectorToTable(weaponId)),Serialize(VectorToTable(wingId)),Serialize(VectorToTable(item_id)),Serialize(VectorToTable(playerBuffCount)),Serialize(VectorToTable(buffId)),"\n\npetId",

        Serialize(VectorToTable(petId)),Serialize(VectorToTable(petParam)), "\n\nweaponSkill",
        Serialize(VectorToTable(weaponSkill)),
        Serialize(VectorToTable(tournamentLevel)), "\n\ncolour",
        Serialize(VectorToTable(colour)),
        Serialize(VectorToTable(bodyColour)))

	self:receiveMakePairOk(VectorToTable(battleId), VectorToTable(battleMode),battleMull,battleChannle,VectorToTable(mapId), VectorToTable(playerCount), VectorToTable(playerCamp), VectorToTable(playerId), VectorToTable(serverId),VectorToTable(playerName), VectorToTable(playerTitle), VectorToTable(playerCommunity), VectorToTable(playerLevel), VectorToTable(playerSex), VectorToTable(maxHP), VectorToTable(maxPF), VectorToTable(maxSP), VectorToTable(attack), VectorToTable(critRate), VectorToTable(defence), VectorToTable(injuryFree), VectorToTable(wreckDefense), VectorToTable(reduceCrit), VectorToTable(reduceBury), VectorToTable(power), VectorToTable(armor), VectorToTable(constitution), VectorToTable(agility), VectorToTable(lucky), VectorToTable(winRate), VectorToTable(fighting), VectorToTable(headId), VectorToTable(faceId), VectorToTable(bodyId), VectorToTable(weaponId), VectorToTable(wingId), VectorToTable(item_id), VectorToTable(playerBuffCount), VectorToTable(buffId), VectorToTable(petId), VectorToTable(petSkill), VectorToTable(petParam), VectorToTable(weaponSkill), VectorToTable(tournamentLevel), VectorToTable(teamId), VectorToTable(teamName), VectorToTable(url), VectorToTable(petLevel), VectorToTable(colour), VectorToTable(bodyColour))

end

--@brief	观战处理
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function ProtocolProcessorGlobal:receiveMakePairOk(battleId, battleMode, battleMull, battleChannle, mapId, playerCount, playerCamp,playerId, serverId, playerName, playerTitle, playerCommunity, playerLevel, playerSex, maxHP, maxPF, maxSP, attack, critRate, defence, injuryFree, wreckDefense, reduceCrit, reduceBury, power, armor, constitution, agility, lucky, winRate, fighting, headId, faceId, bodyId, weaponId, wingId, item_id, playerBuffCount, buffId, petId, petSkill, petParam, weaponSkill,tournamentLevel,teamId,teamName,url, petLevel, colour, bodyColour)
	WZLog("SceneRoom:receiveMakePairOk")

    WBattleGlobal:getCurrent():destroy()
    WBattleGlobal:getCurrent().m_bIsAudience = true
    BattleAudienceManager:start()
    WBattleGlobal:getCurrent().m_tMakePairOk = {
    battleId=battleId,battleMode=battleMode, battleMull=battleMull, battleChannle=battleChannle,mapId=mapId,playerCount=playerCount,playerCamp=playerCamp,playerId=playerId,serverId=serverId,playerName=playerName,

    playerTitle=playerTitle,playerCommunity=playerCommunity,playerLevel=playerLevel,playerSex=playerSex,maxHP=maxHP,maxPF=maxPF,maxSP=maxSP,attack=attack,

    critRate=critRate,defence=defence,injuryFree=injuryFree,wreckDefense=wreckDefense,reduceCrit=reduceCrit,reduceBury=reduceBury,power=power,armor=armor,

    constitution=constitution,agility=agility,lucky=lucky,winRate=winRate,fighting=fighting,headId=headId,faceId=faceId,bodyId=bodyId,weaponId=weaponId,wingId=wingId,item_id=item_id,

playerBuffCount=playerBuffCount,buffId=buffId,petId=petId,petSkillId=petId,petParam=petParam,guaiBattleId=guaiBattleId,guaiId=guaiId,weaponSkill=weaponSkill,tournamentLevel=tournamentLevel,
teamId =teamId,teamName=teamName,url=url, petSkill=petSkill, petLevel=petLevel, colour=colour, bodyColour=bodyColour}

	WBattleGlobal:getCurrent().m_nBattleType = BattleConstants.g_nBATTLE_TYPE_NORMAL

	replaceScene(SceneBattleLoading:createElement())
end

--@brief	观战同步信息成功(PLAYER_SynchronousWatchOk = 85)
function ProtocolProcessorGlobal:parse_PLAYER_SynchronousWatchOk(battleId, playerIds, dataIds, masterIds, camp, hp, sp, CTB, postionX, postionY, angle, face, buffCount, buffId, buffPassCtb, buffUserId, explodePlayerId, explodeSkillId, explodePosNum, explodePosX, explodePosY, finishPercent, roundNum, explodeDirection)
	-- battleId : 战斗id
	-- playerIds : 角色id
	-- dataIds : 数据表id(玩家为0,怪物为对应的ID)
	-- masterId : 召唤者怪物Id
	-- camp : 阵营
	-- hp : 角色的血量
	-- sp : 角色的怒气
	-- CTB : 角色的回合CTB
	-- postionX : 角色的x坐标
	-- postionY : 角色的y坐标
	-- angle : 角色的角度
	-- face : 角色面向
	-- buffCount : 角色的buff数目
	-- buffId : buff的ID
	-- buffPassCtb : buff剩下的CTB时间
	-- buffPlayerId : buff使用角色Id
	-- explodePlayerId : 炸点对应的角色
	-- explodeSkillId : 炸点所使用的技能
	-- explodePosNum : 炸点数量
	-- explodePosX : 炸点的x坐标
    -- explodePosY : 炸点的y坐标
    -- finishPercent : 加载进度完成百分比
    -- roundNum : 回合数
	-- explodeDirection : 炸点的爆破方向
	WZLog("ProtocolProcessorGlobal:parse_PLAYER_SynchronousWatchOk", roundNum, "\n设置当前属性",Serialize(VectorToTable(playerIds)), Serialize(VectorToTable(dataIds)), Serialize(VectorToTable(masterIds)), Serialize(VectorToTable(camp)), 
		"\nhp",Serialize(VectorToTable(hp)), Serialize(VectorToTable(sp)), Serialize(VectorToTable(CTB)), Serialize(IntVectorToFloatTable(postionX)), Serialize(IntVectorToFloatTable(postionY)), Serialize(IntVectorToFloatTable(angle)), Serialize(VectorToTable(face))
		, "\n增减buff", Serialize(VectorToTable(buffCount)), Serialize(VectorToTable(buffId)), Serialize(VectorToTable(buffPassCtb)), Serialize(VectorToTable(buffUserId))
		, "\n地图爆炸", Serialize(VectorToTable(explodePlayerId)), Serialize(VectorToTable(explodeSkillId)), Serialize(VectorToTable(explodePosNum)), Serialize(IntVectorToFloatTable(explodePosX)), Serialize(IntVectorToFloatTable(explodePosY)),finishPercent, Serialize(VectorToTable(explodeDirection)))

		--战斗中
	if true or finishPercent == 100 then

		local data = {}
		data.playerIds = VectorToTable(playerIds)
		data.dataIds = VectorToTable(dataIds)
		data.masterIds = VectorToTable(masterIds)
		data.camp = VectorToTable(camp)
		data.hp = VectorToTable(hp)
		data.sp = VectorToTable(sp)
		data.CTB = VectorToTable(CTB)
		data.postionX = IntVectorToFloatTable(postionX)
		data.postionY = IntVectorToFloatTable(postionY)
		data.angle = IntVectorToFloatTable(angle)
		data.face = VectorToTable(face)

		data.buffCount = VectorToTable(buffCount)
		data.buffId = VectorToTable(buffId)
		data.buffPassCtb = VectorToTable(buffPassCtb)
		data.buffUserId = VectorToTable(buffUserId)

        data.explodePlayerId = VectorToTable(explodePlayerId)
        data.explodeSkillId = VectorToTable(explodeSkillId)
        data.explodePosNum = VectorToTable(explodePosNum)
        data.explodePosX = IntVectorToFloatTable(explodePosX)
        data.explodePosY = IntVectorToFloatTable(explodePosY)
        data.finishPercent = finishPercent
        data.roundNum = roundNum
		data.explodeDirection = VectorToTable(explodeDirection)

		local msg = MsgManager:createMsg(BattleMsgSynchronousBattleInfo)
		msg.m_tData = data
	    MsgManager:pushBlockMsg(msg)
	end
end

--@brief	发送观战信息成功(PLAYER_WatchMes = 87)
function ProtocolProcessorGlobal:parse_PLAYER_WatchMes(battleId, mes)
	-- battleId : 战斗id
	-- mes : 协议字符串数组
	WZLog("ProtocolProcessorGlobal:parse_PLAYER_WatchMes")

	BattleAudienceManager:push(VectorToTable(mes))
end

--@brief	角色信息获取成功
function ProtocolProcessorGlobal:parse_PLAYER_GetPlayerInfoOk(playerId, playerName, tickets, maxLevel, playerHp, playerDefend, playerPhysical, playerDefense, playerGold, playerHonor, playerSex, level, attack, exp, guildName, medalNum, critRate, explodeRadius, proficiency, suit_head, suit_face, suit_body, suit_weapon, weapon_type, upgradeexp, vipLevel, suit_wing, player_title, weaponLevel, wbUserId, zsleve, injuryFree, wreckDefense, reduceCrit, reduceBury, force, armor, agility, physique, luck, fighting, vipMark, vipLastDay)
	-- playerId : 角色id
	-- playerName : 角色名称
	-- tickets : 点卷数量
	-- maxLevel : 最高等级
	-- playerHp : HP
	-- playerDefend : 防御
	-- playerPhysical : 体力
	-- playerDefense : 暴击
	-- playerGold : 金币
	-- playerHonor : 荣誉
	-- playerSex : 性别
	-- level : 角色等级
	-- attack : 攻击力
	-- exp : 角色当前经验
	-- guildName : 公会名称
	-- medalNum : 勋章数量
	-- critRate : 暴击率
	-- explodeRadius : 爆破范围
	-- proficiency : 武器熟练度
	-- suit_head : 着装串头
	-- suit_face : 着装串脸
	-- suit_body : 着装串身
	-- suit_weapon : 着装串武器
	-- weapon_type : 武器类型0:投掷类1:射击类
	-- upgradeexp : 角色当前升级所需经验
	-- vipLevel : vip等级，非vip返回0
	-- suit_wing : 着装翅膀
	-- player_title : 称号
	-- weaponLevel : 玩家装备的武器的等级
	-- wbUserId : 玩家绑定的微博id
	-- zsleve : 玩家的转生等级
	-- injuryFree : 免伤
	-- wreckDefense : 破防
	-- reduceCrit : 免暴
	-- reduceBury : 免坑
	-- force : 力量
	-- armor : 护甲
	-- agility : 敏捷
	-- physique : 体质
	-- luck : 幸运
	-- fighting : 战斗力
	-- vipMark : 是不是vip
	-- vipLastDay : vip剩余天数
	WZLog("ProtocolProcessorGlobal:parse_PLAYER_GetPlayerInfoOk::"..level)
    
    GlobalGame.g_tPlayerInfo.nPlayerId = playerId
	GlobalGame.g_tPlayerInfo.sPlayerName = playerName
	GlobalGame.g_tPlayerInfo.nTickets = tickets
	GlobalGame.g_tPlayerInfo.nMaxLevel = maxLevel
	GlobalGame.g_tPlayerInfo.nPlayerHp = playerHp
	GlobalGame.g_tPlayerInfo.nPlayerDefend = playerDefend
	GlobalGame.g_tPlayerInfo.nPlayerPhysical = playerPhysical
	GlobalGame.g_tPlayerInfo.nPlayerDefense = playerDefense
	GlobalGame.g_tPlayerInfo.nPlayerGold = playerGold
	GlobalGame.g_tPlayerInfo.nPlayerHonor = playerHonor
	GlobalGame.g_tPlayerInfo.nPlayerSex = playerSex
	GlobalGame.g_tPlayerInfo.nLevel = level
	GlobalGame.g_tPlayerInfo.nAattack = attack
	GlobalGame.g_tPlayerInfo.nExp = exp
	GlobalGame.g_tPlayerInfo.sGuildName = guildName
	GlobalGame.g_tPlayerInfo.nMedalNum = medalNum
	GlobalGame.g_tPlayerInfo.nCritRate = critRate
	GlobalGame.g_tPlayerInfo.nExplodeRadius = explodeRadius
	GlobalGame.g_tPlayerInfo.nProficiency = proficiency
	GlobalGame.g_tPlayerInfo.sSuit_head = suit_head
	GlobalGame.g_tPlayerInfo.sSuit_face = suit_face
	GlobalGame.g_tPlayerInfo.sSuit_body = suit_body
	GlobalGame.g_tPlayerInfo.sSuit_weapon = suit_weapon
	GlobalGame.g_tPlayerInfo.nWeapon_type = weapon_type
	GlobalGame.g_tPlayerInfo.nUpgradeexp = upgradeexp
	GlobalGame.g_tPlayerInfo.nVipLevel = vipLevel
	GlobalGame.g_tPlayerInfo.sSuit_wing = suit_wing
	GlobalGame.g_tPlayerInfo.sPlayer_title = player_title
	GlobalGame.g_tPlayerInfo.nWeaponLevel = weaponLevel
	GlobalGame.g_tPlayerInfo.vsWbUserId = wbUserId
	GlobalGame.g_tPlayerInfo.nZsleve = zsleve
	GlobalGame.g_tPlayerInfo.nInjuryFree = injuryFree
	GlobalGame.g_tPlayerInfo.nWreckDefense = wreckDefense
	GlobalGame.g_tPlayerInfo.nReduceCrit = reduceCrit
	GlobalGame.g_tPlayerInfo.nReduceBury = reduceBury
	GlobalGame.g_tPlayerInfo.nforce = force
	GlobalGame.g_tPlayerInfo.nArmor = armor
	GlobalGame.g_tPlayerInfo.nAgility = agility
	GlobalGame.g_tPlayerInfo.nPhysique = physique
	GlobalGame.g_tPlayerInfo.nLuck = luck
	GlobalGame.g_tPlayerInfo.nFighting = fighting
	GlobalGame.g_tPlayerInfo.nVipMark = vipMark
	GlobalGame.g_tPlayerInfo.nVipLastDay = vipLastDay
	--if WindowManager:ifWindowExist(WndShop) then
	--	WndShop:GetPlayerInfoOk()
	--end
end

--@brief	更新玩家属性成功(S->C)
--@note		更新玩家属性成功时的回调函数
function ProtocolProcessorGlobal:parse_PLAYER_UpdatePlayerAttribute(attributeInfo)
	--- attributeInfo : 玩家属性信息描述：[ticket]钻石,[gold]金币,[badge]徽章,[heart]爱心,[suona]喇叭,[colorsuona]彩喇叭
	WZLog("ProtocolProcessorGlobal:parse_PLAYER_UpdatePlayerAttribute")
	
	--更新玩家属性
	local playerAttrInfo = json.decode(attributeInfo)
	GlobalGame.g_tPlayerInfo.nMedalNum = tonumber(playerAttrInfo["badge"])
	GlobalGame.g_tPlayerInfo.nPetNum = tonumber(playerAttrInfo["petnum"])
	GlobalGame.g_tPlayerInfo.nTickets = tonumber(playerAttrInfo["ticket"])
	GlobalGame.g_tPlayerInfo.nPlayerGold = tonumber(playerAttrInfo["gold"])
	GlobalGame.g_tPlayerInfo.nLabaNum = tonumber(playerAttrInfo["suona"])
	GlobalGame.g_tPlayerInfo.nColorLabaNum = tonumber(playerAttrInfo["colorsuona"])
	GlobalGame.g_tPlayerInfo.nHeart = tonumber(playerAttrInfo["heart"])
	
    --充值窗口
    if WindowManager:ifWindowExist(WndRecharge) then
		WndRecharge:showUpdate()
	end
end

--@brief	玩家升级提示
function ProtocolProcessorGlobal:parse_PLAYER_UpdatePlayerLevel(level)
	-- level : 玩家等级
	WZLog("ProtocolProcessorGlobal:parse_PLAYER_UpdatePlayerLevel",level)
	GlobalGame.g_tPlayerInfo.nLevel = level
	--[[
    if GlobalGame.g_bIfInBattle == false then
        WZLog("GlobalGame.g_bIfLevelUp == true 4")
		WndUpgrade:showInfo()
        GlobalGame.g_bIfLevelUp = false
    else
        GlobalGame.g_bIfLevelUp = true
    end
	--]]
    --SceneIsland:updateForUpgrade()
    --androidQuicktSDK数据提交
    PassportSdkManager:postGameInfo(false,"finshLevel")
    if PassportSdkManager.postGameInfoVn then
    	PassportSdkManager:postGameInfoVn("level_vn","" .. level)
        PassportSdkManager:postGameInfoVn("level_up", "")
        if level == 10 or level == 15 or level == 20 or level == 30 or level == 35 then 
            PassportSdkManager:postGameInfoVn("level_up_" .. level, "")
        end
    end
    --第三方SDK等级数据
    if level == 5 then
        local tData = {}
        tData.funType = "finshLevel"
        tData.level = ""..level
        tData.value = ""..level
        PassportSdkManager:Others(tData)
    elseif level == 8 then
        local tData = {}
        tData.funType = "finshLevel"
        tData.level = ""..level
        tData.value = ""..level
        PassportSdkManager:Others(tData)
    end

    if level == 2 or level == 6 or level == 8 or level == 11 then
        if PassportSdkManager.postGameInfoHK then
            PassportSdkManager:postGameInfoHK("finshLevel_hk",""..level)
        end
    end
    if level == 2 or level == 5 or level == 8 then --北美包埋点
        if PassportSdkManager.postGameInfoBeiMei then
    	   PassportSdkManager:postGameInfoBeiMei("finshLevel_beimei",""..level)
        end
    end
    --等级埋点。反正都只会推一次
    if level == 50 then
        PostPlayerEvent:postEvent(PostPlayerEvent.event_level50)
    elseif level == 40 then
        PostPlayerEvent:postEvent(PostPlayerEvent.event_level40)
    elseif level == 30 then
        PostPlayerEvent:postEvent(PostPlayerEvent.event_level30)
    elseif level == 20 then
        PostPlayerEvent:postEvent(PostPlayerEvent.event_level20)
    elseif level == 10 then
        PostPlayerEvent:postEvent(PostPlayerEvent.event_level10)
    elseif level == 5 then
        PostPlayerEvent:postEvent(PostPlayerEvent.event_level5)
    end
	
	--关闭攻击自动制导提示
	if level == GlobalGame.g_tPlayerInfo.nGuideLevel then
		--MsgBoxManager:showConfirmBox(string.format(LocalStrings.SHOOT_GUIDE_CLOSE, level), nil, nil, MSGBOXLEVEL_NORMAL, nil)
	end
    GlobalGame:putSecretData("player_level","" .. level)
    --WZLog("ProtocolProcessorGlobal GlobalGame:getSecretNumberData",GlobalGame:getSecretNumberData("player_level"))
end

--@brief	进入婚礼现场（WEDDING_JoinWeddingOK = 23)
function ProtocolProcessorGlobal:parse_WEDDING_JoinWeddingOK(manName, womanName, playerId, playerName, playerHeadId, playerFaceId, playerBodyId, playerWingId, sex, level, marryType, weddingHallId, manFaceId, womanFaceId, password, vipLevel, playerHeadcolour, playerBodyColour, manHeadColour, womanHeadColour, manBodyColour, womanBodyColour, manFashionId, womanFashionId, manHeadId, womanHeadId,footmark, manServerId, womanServerId, playerServerId, eatStatus, progress, manId, womanId)
	-- manName : 新郎名称，不在婚礼现场为""
	-- womanName : 新娘名称，不在婚礼现场为""
	-- playerId : 来宾玩家id
	-- playerName : 来宾玩家昵称
	-- playerHeadId : 来宾的头
	-- playerFaceId : 来宾的脸
	-- playerBodyId : 来宾的身
	-- playerWingId : 来宾的翅膀
	-- sex : 来宾性别，true是男，false是女
	-- level : 来宾等级
	-- marryType : 婚礼类型
	-- weddingHallId : 婚礼id
	-- manFaceId : 新郎的脸
	-- womanFaceId : 新娘的脸
	-- password : 密码
	-- vipLevel : 来宾vip等级
	-- playerHeadcolour : 来宾的头颜色
	-- playerBodyColour : 来宾的身颜色
	-- manHeadColour : 新郎头颜色
	-- womanHeadColour : 新娘头颜色
	-- manBodyColour : 新郎身颜色
	-- womanBodyColour : 新娘身颜色
	-- manFashionId : 新郎时装
	-- womanFashionId : 新娘时装
	-- manHeadId : 新郎头
	-- womanHeadId : 新娘头
    -- footmark : 足迹
    -- eatStatus : 吃婚宴按钮状态 -1不可吃 | 0可以吃 | 1已经吃了
    -- progress : 婚礼进度 1等待双方入场 | 2等待举办婚礼 | 3正在举办婚礼 | 4正在婚宴
    -- manId : 新郎id
    -- womanId : 新娘id
	WZLog("ProtocolProcessorGlobal:parse_WEDDING_JoinWeddingOK ",progress)

	SceneWeddingChurch:JoinWeddingOk(manName, womanName, VectorToTable(playerId), VectorToTable(playerName), VectorToTable(playerHeadId), VectorToTable(playerFaceId), VectorToTable(playerBodyId), VectorToTable(playerWingId), VectorToTable(sex), VectorToTable(level), marryType, weddingHallId,manFaceId,womanFaceId,password,VectorToTable(vipLevel),VectorToTable(playerHeadcolour),VectorToTable(playerBodyColour),manHeadColour,womanHeadColour,manBodyColour,womanBodyColour,manFashionId,womanFashionId,manHeadId,womanHeadId,VectorToTable(footmark), manServerId, womanServerId, VectorToTable(playerServerId), manId, womanId)
    SceneWeddingChurch:updateWedding(progress)
    
    if eatStatus == -1 then
        SceneWeddingChurch:setEatStatus(-1)
    else
        SceneWeddingChurch:setEatStatus(1)
    end
end

--@brief	任务状态变更协议
function ProtocolProcessorGlobal:parse_TASK_StatusChanged(taskId, status)
	-- taskId : 完成任务的id
	-- status : 任务当前的状态（1进行中，2未提交，3已完成）
	WZLog("ProtocolProcessorGlobal:parse_TASK_StatusChanged")
end

--@brief	接收聊天信息(S->C)
function ProtocolProcessorGlobal:parse_CHAT_ReceiveMessage(channel, sendId, sendName, receiveId, receiveName, message, rtime,chatType,subType,vipLevel,sendFaceId,sendHeadId,sendSex,headScul,serviceId,headColor,senderLevel,bubbleId, playerTitle, playerPvpLevel, professionId, openStatus, offlineMessage, headEffectId, leagueId)
    --time这个字段要换个名字，与系统名字冲突
	-- channel : 频道（0世界，1当前，2公会，3队伍，4私聊，5系统，6彩聊）
	-- sendId : 信息发送人ID
	-- sendName : 信息发送人名称
	-- receiveId : 信息接收人ID
	-- receiveName : 信息接收人名称
	-- message : 聊天内容
	-- time : MM-dd
	--chatType:聊天类型：0玩家聊天，1普通公告，2结婚公告,3世界BOSS公告,4弹王公告,5跨服对战聊天,6GM小助手,7语音聊天,8同步语音id
	--subType聊天子协议：
            --0（1：普通聊天，2：彩色聊天）
            --1（1：普通公告，2：彩色公告）
	--2（1：普通婚礼,2：浪漫婚礼，3：豪华婚礼，4：奢华婚礼）
	--3（1：世界BOSS开启,2：世界BOSS关闭）
	--4（1：弹王开始,2：弹王结束）
	--vipLevel发送人vip等级（系统的默认为0）
	--headScul:头像，（有头像为1，没有头像为0）
	--serviceId:接收人所在服务器id
	--colour:发送人头部颜色
	--level:发送人等级
	--WZLog("ProtocolProcessorGlobal:parse_CHAT_ReceiveMessage"..KLuaSocket:utfToGBK(message),channel)  
	--全服结婚动画处理
    -- bubbleId :聊天气泡ID
    -- playerTitle : 玩家称号（需要显示的才有内容，不符合显示要求的为""）
    -- playerPvpLevel : 玩家排位等级（对应排位表中的level3）
    -- professionId : 玩家职业Id(玩家职业(0=未开通|1=战士|2=刺客|3=法师))
    -- leagueId : 消息所属联盟Id(主要服务器用)
    local playerInfo = CacheCenter:getPlayerInfo()
    WZLog("ProtocolProcessorGlobal:parse_CHAT_ReceiveMessage ", channel, chatType)
    -- WZLog("ProtocolProcessorGlobal:parse_CHAT_ReceiveMessage ", 
    --     "\n channel =",Serialize(VectorToTable(channel)), 
    --     "\n sendId =",Serialize(VectorToTable(sendId)), 
    --     "\n sendName =",Serialize(VectorToTable(sendName)), 
    --     "\n receiveId =",Serialize(VectorToTable(receiveId)), 
    --     "\n receiveName =",Serialize(VectorToTable(receiveName)), 
    --     "\n message =",Serialize(VectorToTable(message)), 
    --     "\n rtime =",Serialize(VectorToTable(rtime)),
    --     "\n chatType =",Serialize(VectorToTable(chatType)),
    --     "\n subType =",Serialize(VectorToTable(subType)),
    --     "\n vipLevel =",Serialize(VectorToTable(vipLevel)),
    --     "\n sendFaceId =",Serialize(VectorToTable(sendFaceId)),
    --     "\n sendHeadId =",Serialize(VectorToTable(sendHeadId)),
    --     "\n sendSex =",Serialize(VectorToTable(sendSex)),
    --     "\n headScul =",Serialize(VectorToTable(headScul)),
    --     "\n serviceId =",Serialize(VectorToTable(serviceId)),
    --     "\n headColor =",Serialize(VectorToTable(headColor)),
    --     "\n senderLevel =",Serialize(VectorToTable(senderLevel)),
    --     "\n bubbleId =",Serialize(VectorToTable(bubbleId)), 
    --     "\n playerTitle =",Serialize(VectorToTable(playerTitle)), 
    --     "\n playerPvpLevel =",Serialize(VectorToTable(playerPvpLevel)), 
    --     "\n professionId =",Serialize(VectorToTable(professionId)), 
    --     "\n openStatus =",Serialize(VectorToTable(openStatus)), 
    --     "\n offlineMessage =",Serialize(VectorToTable(offlineMessage)), 
    --     "\n headEffectId =",Serialize(VectorToTable(headEffectId)))

    --小助手的时候
    if sendId == receiveId and channel == CHANNEL_WHISPER then
        WndChat:saveAssiantToLacal(message, rtime)
    end

    if channel == CHANNEL_TEAM and chatType == 8 then
    	message = SplitStringWithSeparator(message, ",", nil, true)
    	synchronousVoicePlayerState(sendId, message)
    	return
    end

	if (channel == CHANNEL_WORLD or channel == CHANNEL_SYSTEM) and chatType == CHANNEL_GUILD then
		--WndMarryManager:playAllServerMarryAnimation( sendId, receiveName , subType,sendName )
	end

	if GetPlayTalk() == 1 and chatType == 7 then
		return
	end
	
	if (channel==CHANNEL_SYSTEM or channel==CHANNEL_WORLD or channel==CHANNEL_COLORCHAT or channel==CHANNEL_GOLD) and sendId ~= GlobalGame.g_tPlayerInfo.nPlayerId  then
		local mes = message
		local chType = chatType
		if chType == 7 then
			local msss = SplitStringWithSeparator(message,"&")     
		    local recordLen = tonumber(msss[2])
		    local fileId = msss[1]
		    local showText = msss[3]
		    if showText == nil then
		    	return
		    end
		    mes = showText
		    chType = 1
		end

        local bInBlacklist = false 
        BANCHAT = CacheCenter:getFriendBlacklist()
        for i = 1, #BANCHAT do
            if BANCHAT[i].id == tonumber(sendId) then
                bInBlacklist = true
                break 
            end
        end

		if channel==CHANNEL_COLORCHAT then
            local indexx = string.find(mes,"##~")
            local msg = mes
            if indexx ~= nil and indexx > 0 then
                local teamRoomInfo = string.sub(msg,0,indexx-1)
                local teamRoomInfo2 = string.sub(msg,indexx+3)
                local tempT = SplitStringWithSeparator(teamRoomInfo2,"||")
                if tempT and #tempT == 2 then
                    msg = teamRoomInfo
                    channel = CHANNEL_COPY
                end
            end
            if msg == mes then --世界副本邀请不进行滚动显示
                if not bInBlacklist then
                    if chatType == 9 or chatType == 10 then 
                        local sTempMsg = LocalStrings.RED_PACK14
                        WndSuona:showSuonaWithSendNameAndMessage(channel,sendName,sTempMsg,chType,subType,vipLevel)
                    else
                        WndSuona:showSuonaWithSendNameAndMessage(channel,sendName,mes,chType,subType,vipLevel)
                    end
                end
            end
	    else
            if not bInBlacklist then
                if chatType == 9 or chatType == 10 then 
                    local sTempMsg = LocalStrings.RED_PACK14
                    WndSuona:showSuonaWithSendNameAndMessage(channel,sendName,sTempMsg,chatType,subType,vipLevel)
                elseif chatType == 11 then 
                    WndSuona:showSuonaWithSendNameAndMessage(channel,sendName,mes,chatType,subType,vipLevel)
                else
	    	        WndSuona:showSuonaWithSendNameAndMessage(channel,sendName,mes,4,subType,vipLevel)
                end
            end
		end
	end


    --遗迹副本处理 彩聊变为副本
    local sStart,sEnd,sContent = string.find(message,g_REMAINSMessage_Mark)
    if sContent then
        if channel==CHANNEL_COLORCHAT then
            channel = CHANNEL_COPY
        end

        --显示自己发出的遗迹分享
        if sendId == GlobalGame.g_tPlayerInfo.nPlayerId then
            tabContent = json.decode(sContent)
            local sCurrentMsg = tabContent.desc .. tabContent.text
            WndChat:sendOwnChatMsg(channel,sCurrentMsg)
        end
    end


	if channel==CHANNEL_COLORCHAT and sendName ==LocalStrings.CHAT_SYSTEM then
	   return
	end

    if chatType == 9 then 
        g_RedPackChannel = 0

        g_QuickRedPackState = true
        if SceneCity and SceneCity.m_tWndBottomBarObj then
            SceneCity.m_tWndBottomBarObj:setRedPackBtnVisible()
        end
        WndChat:setRedPackBtnVisible()
    elseif chatType == 10 then 
        g_RedPackChannel = 1

        g_QuickRedPackState2 = true
        if SceneCity and SceneCity.m_tWndBottomBarObj then
            SceneCity.m_tWndBottomBarObj:setRedPackBtnVisible()
        end
        WndChat:setRedPackBtnVisible()
    end

	WndChat:getReceiveMessageOK(channel, sendId, sendName, receiveId, receiveName, message, rtime, vipLevel,sendFaceId,sendHeadId,sendSex,headScul,
        serviceId,headColor,senderLevel,chatType,bubbleId, playerTitle, playerPvpLevel, professionId, openStatus, offlineMessage, headEffectId)
	if channel ==CHANNEL_WHISPER  then
		WZLog("getReceiveMessageOK"..channel)
		GlobalGame.g_nPrivateNum = GlobalGame.g_nPrivateNum +1  --统计接收到得私聊信息数目
		WZLog("GlobalGame.g_nPrivateNum  "..GlobalGame.g_nPrivateNum)
	end
	--当玩家自己向好友发送信息时，不显示未读信息数目提示，数目置零
	if sendId == GlobalGame.g_tPlayerInfo.nPlayerId or ((WBattleGlobal:getCurrent().m_tMakePairOk.selfId ~= nil) and (sendId== (0 - WBattleGlobal:getCurrent().m_tMakePairOk.selfId))) then
    	GlobalGame.g_nPrivateNum = 0
    end
end

--@brief	获取喇叭数量成功(S->C)
function ProtocolProcessorGlobal:parse_CHAT_GetSpeakerNumOk(speakNum, colorSpeakNum)
	-- speakNum : 普通喇叭数量
	-- colorSpeakNum : 彩色喇叭数量
	WZLog("ProtocolProcessorGlobal:parse_CHAT_GetSpeakerNumOk",speakNum,colorSpeakNum)
	GlobalGame.g_tPlayerInfo.nLabaNum = speakNum
    GlobalGame.g_tPlayerInfo.nColorLabaNum = colorSpeakNum
end


--@brief    进入房间成功（ROOM_EnterRoomOk = 6）
function ProtocolProcessorGlobal:parse_ROOM_EnterRoomOk(roomId, roomStatus, battleMode, roomChannel, playerNumMode,schedule ,mapId, wnersId, startMode, playerNum, seatUsed, playerId, serviceId, playerName, playerLevel, playerReady, playerSex, equipmentId, equipmentLevel, vipLevel, playerTitle, roomName, roomPassword, fighting, pet, tournamentLevel, winNum, playNum, extranInfo,tournamentExp,url,teamId,teamName,headColors,bodyColors, mentoringStr, coupleStr, chumStr, coupleNum, chumNum,mentoringNum,matchLevel, matchscore,joinTimes,winTimes,continuousWinTimes, useMountsMes, professionId, openStatus)
    -- roomId : 房间Id
    -- roomStatus : 房间状态（0等待中，1匹配中，2战斗中）
    -- battleMode : 战斗模式
    -- roomChannel : 房间所属频道（1初级，2中级，3高级）
    -- playerNumMode : 对战人数模式
    -- schedule : 比赛赛程
    -- mapId : 房间地图id
    -- wnersId : 房主id
    -- startMode : 撮合方式
    -- playerNum : 房间座位数量
    -- seatUsed : 该座位是否使用
    -- playerId : 房间内玩家id
    -- serviceId : 玩家所在服ID
    -- playerName : 房间内玩家昵称
    -- playerLevel : 房间内玩家等级
    -- playerReady : 玩家是否已准备
    -- playerSex : 玩家性别
    -- equipmentId : 玩家身上的装备
    -- equipmentLevel : 玩家武器等级
    -- vipLevel : 玩家vip等级0表示非vip
    -- playerTitle : 玩家称号
    -- roomName : 房间名称
    -- roomPassword : 房间密码
    -- fighting : 玩家战斗力
    -- pet : 玩家宠物信息(JSON)
    -- tournamentLevel : 竞技等级
    -- winNum : 胜利场次
    -- playNum : 战斗场次
    -- extranInfo : 装备扩展信息(武器)
    -- tournamentExp : 竞技积分
    -- url : 战队图标
    -- teamId : 战队Id
    -- teamName : 战队名字
    -- headColour : 头部颜色
    -- bodyColour : 身体颜色
    -- mentoringStr : 师徒关系(id|id,id|id)
    -- coupleStr : 夫妻关系(id|id,id|id)
    -- chumStr : 密友关系(id|id,id|id)
    -- coupleNum : 夫妻恩爱值(恩爱值|恩爱等级,恩爱值|恩爱等级)
    -- chumNum : 密友关系(好友值,好友值)
    -- mentoringNum : 师德值(好友值|师德等级,好友值|师德等级)
    -- matchLevel : 排位等级(战略赛复用)
    -- matchscore : 排位赛积分(战略赛复用)
    -- joinTimes :  赛季参与次数
    -- winTimes : 赛季胜利次数
    -- continuousWinTimes : 赛季当前连胜次数
    -- useMountsMes : 使用中的坐骑信息
    -- professionId : 123战士法师刺客
    -- openStatus : 0未开启职业 1职业一转 2职业二转
--[[	WZLog("ProtocolProcessorGlobal:parse_ROOM_EnterRoomOk",
        "\n roomId =",Serialize(VectorToTable(roomId)),
        "\n roomStatus =",Serialize(VectorToTable(roomStatus)),
        "\n battleMode =",Serialize(VectorToTable(battleMode)),
        "\n roomChannel =",Serialize(VectorToTable(roomChannel)),
        "\n playerNumMode =",Serialize(VectorToTable(playerNumMode)),
        "\n schedule =",Serialize(VectorToTable(schedule)),
        "\n mapId =",Serialize(VectorToTable(mapId)),
        "\n wnersId =",Serialize(VectorToTable(wnersId)),
        "\n startMode =",Serialize(VectorToTable(startMode)),
        "\n playerNum =",Serialize(VectorToTable(playerNum)),
        "\n seatUsed =",Serialize(VectorToTable(seatUsed)),
        "\n playerId =",Serialize(VectorToTable(playerId)),
        "\n serviceId =",Serialize(VectorToTable(serviceId)),
        "\n playerName =",Serialize(VectorToTable(playerName)),
        "\n playerLevel =",Serialize(VectorToTable(playerLevel)),
        "\n playerReady =",Serialize(VectorToTable(playerReady)),
        "\n playerSex =",Serialize(VectorToTable(playerSex)),
        "\n equipmentId =",Serialize(VectorToTable(equipmentId)),
        "\n equipmentLevel =",Serialize(VectorToTable(equipmentLevel)),
        "\n vipLevel =",Serialize(VectorToTable(vipLevel)),
        "\n playerTitle =",Serialize(VectorToTable(playerTitle)),
        "\n roomName =",Serialize(VectorToTable(roomName)),
        "\n roomPassword =",Serialize(VectorToTable(roomPassword)),
        "\n fighting =",Serialize(VectorToTable(fighting)),
        "\n pet =",Serialize(VectorToTable(pet)),
        "\n tournamentLevel =",Serialize(VectorToTable(tournamentLevel)),
        "\n winNum =",Serialize(VectorToTable(winNum)),
        "\n playNum =",Serialize(VectorToTable(playNum)),
        "\n extranInfo =",Serialize(VectorToTable(extranInfo)),
        "\n tournamentExp =",Serialize(VectorToTable(tournamentExp)),
        "\n url =",Serialize(VectorToTable(url)),
        "\n teamId =",Serialize(VectorToTable(teamId)),
        "\n teamName =",Serialize(VectorToTable(teamName)),
        "\n headColors =",Serialize(VectorToTable(headColors)),
        "\n bodyColors =",Serialize(VectorToTable(bodyColors)),
        "\n mentoringStr =",Serialize(VectorToTable(mentoringStr)),
        "\n coupleStr =",Serialize(VectorToTable(coupleStr)),
        "\n chumStr =",Serialize(VectorToTable(chumStr)),
        "\n coupleNum =",Serialize(VectorToTable(coupleNum)),
        "\n chumNum =",Serialize(VectorToTable(chumNum)),
        "\n mentoringNum =",Serialize(VectorToTable(mentoringNum)),
        "\n matchLevel =",Serialize(VectorToTable(matchLevel)),
        "\n matchscore =",Serialize(VectorToTable(matchscore)),
        "\n joinTimes =",Serialize(VectorToTable(joinTimes)),
        "\n winTimes =",Serialize(VectorToTable(winTimes)),
        "\n continuousWinTimes =",Serialize(VectorToTable(continuousWinTimes)),
        "\n useMountsMes =",Serialize(VectorToTable(useMountsMes)),
        "\n professionId =",Serialize(VectorToTable(professionId)),
        "\n openStatus =",Serialize(VectorToTable(openStatus))
        )
	]]
	WZLog("--------------roomChannel-----------",roomChannel)
    GlobalGame.g_isOpenMapEvent = eventMode
    if GlobalGame.g_bIfInBattle == false then
        if roomChannel == 9 then
            if schedule == 1 then --赛程等于海选赛阶段
                WndLeagueTeamDetail:EnterRoomOk()
            else
                WZLog("ProtocolProcessorGlobal:parse_ROOM_EnterRoomOk1",teamName)
                WZLog("ProtocolProcessorGlobal:parse_ROOM_EnterRoomOk2",teamId)
                SceneLeagueRoom:showScene()
                SceneLeagueRoom:setPlayerData(roomId, roomStatus, battleMode, roomChannel, playerNumMode,schedule, mapId, wnersId,
                    startMode, playerNum, seatUsed, playerId, serviceId, playerName, playerLevel, playerReady,
                    playerSex, equipmentId, equipmentLevel, vipLevel, playerTitle, roomName, roomPassword,
                    fighting, pet, tournamentLevel, winNum, playNum, extranInfo,tournamentExp,url,teamId,teamName,headColors,bodyColors)
            end
        else
            SceneHall:closeLoadingBox()
            local roomLua = SceneRoom
            if roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_GZ then
                roomLua = SceneGuildWarRoom
            end
            --区分公会战 和常规匹配
            if roomLua.m_root == nil then
                local roomElement = roomLua:createElement()
                replaceScene(roomElement)
            end
            roomLua:receiveEnterRoomOk(roomId,roomStatus,battleMode, roomChannel,
                playerNumMode,schedule,mapId,wnersId,startMode,playerNum, VectorToTable(seatUsed),
                VectorToTable(playerId), VectorToTable(playerName),
                VectorToTable(playerLevel), VectorToTable(playerReady),
                VectorToTable(playerSex), VectorToTable(equipmentId),
                VectorToTable(equipmentLevel), VectorToTable(vipLevel),
                VectorToTable(playerTitle),roomName,roomPassword,VectorToTable(fighting),
                VectorToTable(pet),VectorToTable(tournamentLevel),VectorToTable(winNum),
                VectorToTable(playNum),VectorToTable(extranInfo),VectorToTable(serviceId),
                VectorToTable(tournamentExp),VectorToTable(headColors),VectorToTable(bodyColors),mentoringStr,coupleStr,chumStr,coupleNum,chumNum,mentoringNum,VectorToTable(matchLevel),VectorToTable(matchscore),VectorToTable(joinTimes),VectorToTable(winTimes),VectorToTable(continuousWinTimes), VectorToTable(useMountsMes), VectorToTable(professionId),VectorToTable(openStatus))
        end
    end
end


--@brief	被邀请（副本房间）（BOSSMAPROOM_BeInvite = 23）
function ProtocolProcessorGlobal:parse_BOSSMAPROOM_BeInvite(roomId, playerName, mapId, password, roomChannel, assist, interfaceId, playerId)
	-- room  :  房间Id
	-- playerName : 邀请人名称
	WZLog("ProtocolProcessorGlobal:parse_BOSSMAPROOM_BeInvite ", roomId, playerName, mapId, password, roomChannel, assist)
	if SceneRoom.m_root == nil and SceneBossRoom.m_root == nil and SceneBattle.m_root == nil and SceneBattleLoading.m_root == nil and GlobalGame.g_bIfInBattle == false and WndTeachOpenModule.m_root == nil and WndTeachTalk.m_root == nil and SceneKingMain.m_root == nil and not SceneHall:getMatchState() and not WndStrengthen.m_root and WndDoubleTowerRoom.m_root == nil and not (WndSingleCopyInfo.m_root and WndSingleCopyInfo.m_bIslandRoom) then
        if WindowManager:getTeachShelterLayer() or WndTeachTalk.m_root then return end
        if roomChannel == 16 then
            WndSingleCopyInfo:beInvited(roomId,playerName,mapId,password,roomChannel,assist)
        else
            if judgeMapIdIsMarryCopy(mapId) then
    			SceneMarryCopy:beInvited(roomId , playerName,mapId,password,roomChannel)
    		else
                local mapData = GDatatab_grouptower_map["id_" .. mapId]
                if mapData then 
    			    WndDoubleTowerRoom:beInvited(roomId, playerName, mapId, password, roomChannel, assist, interfaceId, playerId)
                else
                    SceneBossRoom:beInvited(roomId, playerName, mapId, password, roomChannel, assist, interfaceId, playerId)
                end
    		end
        end
	end
end

--@brief	被邀请
function ProtocolProcessorGlobal:parse_ROOM_BeInvite(roomId, battleMode, playerName,passWord,roomChannel, numMode, schedule, interfaceId, playerId)
	-- roomId : 房间ID
	-- battleMode : 房间战斗模式
	-- playerName : 邀请人名称
	-- passWord : 房间密码
	-- roomChannel :/** 房间频道:对战赛频道 */
    -- public static final int    BATTLE_CHANNEL_DZ    = 1;
    -- /** 房间频道:娱乐赛频道 */
    -- public static final int    BATTLE_CHANNEL_YL    = 2;
    -- /** 房间频道:排位赛频道 */
    -- public static final int    BATTLE_CHANNEL_PW    = 3;
    -- /** 房间频道:世界BOSS频道 */
    -- public static final int    BATTLE_CHANNEL_SJ    = 4;
    -- /** 房间频道:组队副本频道 */
    -- public static final int    BATTLE_CHANNEL_ZF    = 5;
    -- /** 房间频道:夫妻副本频道 */
    -- public static final int    BATTLE_CHANNEL_FF    = 6;
    -- /** 房间频道:公会副本频道 */
    -- public static final int    BATTLE_CHANNEL_GF    = 7;
    -- /** 房间频道:公会战频道 */
    -- public static final int    BATTLE_CHANNEL_GZ    = 8;
    -- /** 房间频道:英雄联赛频道 */
    -- public static final int    BATTLE_CHANNEL_LS    = 9;
    -- /** 房间频道:练习赛频道 */
    -- public static final int    BATTLE_CHANNEL_LS    = 10;
    -- /** 房间频道:世界组队Boss频道 */
    -- public static final int    BATTLE_CHANNEL_WTB   = 12;

	WZLog("ProtocolProcessorGlobal:parse_ROOM_BeInvite",roomChannel,schedule)
	if WndInvited then
		local channel = roomChannel
		local tempStr = LocalStrings.ROOM_BEINVITED_2
		if channel == 8 or channel == 10 then
			tempStr = LocalStrings.ROOM_BEINVITED_3
		end
		local localSchedule = battleMode
		if roomChannel == 3 then  --排位赛
			localSchedule = 8
		elseif roomChannel == 8 then  --公会战
			if schedule == 1 then
				localSchedule = 9
			elseif schedule == 2 then
				localSchedule = 10
			elseif schedule == 3 then
				localSchedule = 11
			end
        elseif roomChannel == 10 then  --练习赛
            localSchedule = 12
        elseif roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_ZLS then  --战略赛
            localSchedule = 13
		end
        local temp_str = string.format(tempStr,playerName,g_tRoomModeDesc[localSchedule])
		WndInvited:showInterface(self, self.send_ROOM_SelectRoom, roomId,passWord, nil, temp_str,playerName,nil,nil,roomChannel, nil, interfaceId, playerId, numMode)
	end
end

--@brief	推送玩家的按钮信息
function ProtocolProcessorGlobal:parse_PLAYER_PlayerButtonInfo(buttonId, buttonType, buttonSort, IsHighlight)
	-- buttonId : 按钮id
	-- buttonType : 按钮类型 0主界面建筑按钮，1主界面左侧按钮，2主界面中部按钮，3主界面右侧按钮。
	-- buttonSort : 按钮的排序值
	-- IsHighlight : 按钮是否高亮
	WZLog("ProtocolProcessorGlobal:parse_PLAYER_PlayerButtonInfo")
    do return end
  if buttonId:size() > 0 then
		GlobalGame.g_tButtonInfo.buttonId 	    = VectorToTable(buttonId)
		GlobalGame.g_tButtonInfo.buttonType     = VectorToTable(buttonType)
		GlobalGame.g_tButtonInfo.buttonSort     = VectorToTable(buttonSort)
		GlobalGame.g_tButtonInfo.IsHighlight    = VectorToTable(IsHighlight)
		local tBtnsInfo = GlobalGame:getBtnInfoByType(ISLAND_BTNTYPE_RIGHT)
		local tBtnMenu = GlobalGame:getBtnInfoByType(ISLAND_BTNTYPE_EVENTS)
		WndRightMenu:setBtnsInfo(tBtnsInfo,tBtnMenu)
		
		local tLeftBtnsInfo = GlobalGame:getBtnInfoByType(ISLAND_BTNTYPE_LEFT)
		local tBtnWelInfo = GlobalGame:getBtnInfoByType(ISLAND_BTNTYPE_WELFARE)
		WndLeftMenu:setBtnsInfo(tLeftBtnsInfo,tBtnWelInfo)
	end
end

--@brief	推送玩家在线奖励信息
function ProtocolProcessorGlobal:parse_PLAYER_OnlineRewardInfo(rewardTime, rewardRemark)
	-- rewardTime : 奖励需要在线时长
	-- rewardRemark : 奖励说明
	WZLog("ProtocolProcessorGlobal:parse_PLAYER_OnlineRewardInfo")
    SceneIsland:setOnlineRewardInfo(rewardTime, rewardRemark)
end

--@brief	可领取奖励的数量（TASK_GetRewardNum = 44）
function ProtocolProcessorGlobal:parse_TASK_GetRewardNum(signRewardNum, loginRewardNum, levelRewardNum, onlineRewardNum)
	-- signRewardNum : 签到可领取奖励数量
	-- loginRewardNum : 登录可领取奖励数量
	-- levelRewardNum : 等级可领取奖励数量
	-- onlineRewardNum : 在线可领取奖励数量
	WZLog("ProtocolProcessorGlobal:parse_TASK_GetRewardNum",signRewardNum,loginRewardNum,levelRewardNum,onlineRewardNum)
	GlobalGame.g_nSignRewardNum = signRewardNum
	GlobalGame.g_nLoginRewardNum = loginRewardNum
	GlobalGame.g_nLevelRewardNum = levelRewardNum
	GlobalGame.g_nOnlineRewardNum = onlineRewardNum
	local rewardNum = signRewardNum + loginRewardNum + levelRewardNum + onlineRewardNum
	WndLeftMenu:setRewardCount(true)
end

--@brief	邀请来宾请求给朋友（WEDDING_InvitationToFriend = 53）
function ProtocolProcessorGlobal:parse_WEDDING_InvitationToFriend(marryRecordId, playerName, password)
	-- marryRecordId : 婚礼id
	-- playerName : 邀请人姓名
	-- password : 密码，不输入密码为""
	WZLog("ProtocolProcessorGlobal:parse_WEDDING_InvitationToFriend ",marryRecordId,playerName,password)
	WndMarryManager:inviteFriendWedding(marryRecordId, playerName, password)
end

--@brief	参加婚礼（WEDDING_JoinWedding = 22）
function ProtocolProcessorGlobal:send_WEDDING_JoinWedding(wedNum ,password)
	WZLog("send_WEDDING_JoinWedding")
	local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WEDDING_JoinWedding )
	if sender==nil then WZLog("sender == nil") return end
	sender:writeInt( wedNum )	-- 婚礼编号
	if password == nil then
		password = ""
	end
    sender:writeString( password )  -- 礼堂密码
	SendProtocol(sender,false) --true:showLoading
end

--@brief	世界语音聊天结果（CHAT_WorldIMOK = 12）
function ProtocolProcessorGlobal:parse_CHAT_WorldIMOK(result)
	-- result : 1、扣除成功，0、扣除失败
	WZLog("ProtocolProcessorGlobal:parse_CHAT_WorldIMOK")
end

--@brief    获取暑期活动状态,登陆时推送（ACTIVITY_GetSummerActivityStatusOk = 27）
function ProtocolProcessorGlobal:parse_ACTIVITY_GetSummerActivityStatusOk(status, startTimestamp, endTimestamp)
    -- status : 状态(1:关闭;2准备中;3:进行中)
    -- startTimestamp : 开始时间戳
    -- endTimestamp : 结束时间戳
    WZLog("ProtocolProcessorGlobal:parse_ACTIVITY_GetSummerActivityStatusOk ",status)
    GlobalGame.g_autoSummerStartT = startTimestamp
    GlobalGame.g_autoSummerEndT = endTimestamp --暑假活动结束时间
    GlobalGame.g_autoSummerActivity = status
end

--@brief	获取代言人活动状态（ACTIVITY_GetSpokesmanActivityStatusOk = 33）
function ProtocolProcessorGlobal:parse_ACTIVITY_GetSpokesmanActivityStatusOk(status)
	-- status : 状态(1:进行中;2:关闭)
	WZLog("ProtocolProcessorGlobal:parse_ACTIVITY_GetSpokesmanActivityStatusOk", status)
    GlobalGame.g_autoLouraActivity = status

    SceneCity:openLouyixiao(status == 1)
end

--@brief    获取折扣商贩活动状态（MALL_GetDiscountStoreStatusOk = 36）
function ProtocolProcessorGlobal:parse_MALL_GetDiscountStoreStatusOk(status)
    -- status : 活动状态*(1:开启,2:关闭)
    WZLog("ProtocolProcessorGlobal:parse_MALL_GetDiscountStoreStatusOk", status)
    GlobalGame.g_isSterious = status
    SceneCity:openSterious(status == 1)
end

--@brief    检测排位赛惩罚剩余时间（ROOM_CheckPwPunishOk = 104）
function ProtocolProcessorGlobal:parse_ROOM_CheckPwPunishOk(channel, punishTime)
    -- punishTime : 惩罚剩余时间，小于0为不在惩罚时间内（秒）
    WZLog("ProtocolProcessorGlobal:parse_ROOM_CheckPwPunishOk ", channel, punishTime)
    if channel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_PW then
        GlobalGame.g_pvpPunishTime = punishTime
        GlobalGame.g_pvpPunishTimeCurServiceT = SystemTime:getServerTime()
    elseif channel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_ZLS then
        GlobalGame.g_pvpZlsPunishTime = punishTime
        GlobalGame.g_pvpZlsPunishTimeCurServiceT = SystemTime:getServerTime()
    end
end

--@brief    获取世界杯活动状态（ACTIVITY_GetWorldCupActivityStatusOk = 111）
function ProtocolProcessorGlobal:parse_ACTIVITY_GetWorldCupActivityStatusOk(status)
    -- status : 状态(1:进行中;2:关闭)
    WZLog("ProtocolProcessorGlobal:parse_ACTIVITY_GetWorldCupActivityStatusOk", status)
    GlobalGame.g_autoFootballActivity = status

    WndOwnCity:openFootball(status == 1)
end

--@brief    回归系列活动状态（ACTIVITY_GetUserBackActivityStatusOk = 112）
function ProtocolProcessorGlobal:parse_ACTIVITY_GetUserBackActivityStatusOk(status, returnTime, bindingInviteStatus, inviteCode)
    -- status : 回归活动状态【原有字段】
    -- returnTime : 玩家回归时间【新增字段】
    -- bindingInviteStatus : 玩家绑定邀请码状态(0=未绑定|1=已绑定)【新增字段，用于绑定邀请码界面，已绑定过不要再触发绑定接口】
    -- inviteCode : 邀请码
    WZLog("ProtocolProcessorGlobal:parse_ACTIVITY_GetUserBackActivityStatusOk", status, returnTime, bindingInviteStatus, inviteCode)

    -- status = 1
    -- returnTime = 1590700000
    -- bindingInviteStatus = 0
    -- inviteCode = "ABCDxyz"

    GlobalGame.g_autoBackActivity = status
    GlobalGame.g_returneeActStartTime = returnTime
    GlobalGame.g_returneeInviteStatus = bindingInviteStatus
    GlobalGame.g_returneeInviteCode = inviteCode
    if WndOwnCity.openBackActivity then
        WndOwnCity:openBackActivity(status == 1)
    end
end

--@brief    接收发言（CHAT_ReceiveMessageBatch = 33）
function ProtocolProcessorGlobal:parse_CHAT_ReceiveMessageBatch(channel, sendId, sendName, receiveId, receiveName, message, rtime,chatType,subType,vipLevel,sendFaceId,sendHeadId,sendSex,headScul,serviceId,headColor,senderLevel,bubbleId, playerTitle, playerPvpLevel, professionId, openStatus, offlineMessage, headEffectId, leagueId)
    --time这个字段要换个名字，与系统名字冲突
    -- channel : 频道（0世界，1当前，2公会，3队伍，4私聊，5系统，6彩聊）
    -- sendId : 信息发送人ID
    -- sendName : 信息发送人名称
    -- receiveId : 信息接收人ID
    -- receiveName : 信息接收人名称
    -- message : 聊天内容
    -- time : MM-dd
    --chatType:聊天类型：0玩家聊天，1普通公告，2结婚公告,3世界BOSS公告,4弹王公告,5跨服对战聊天,6GM小助手,7语音聊天,8同步语音id
    --subType聊天子协议：
            --0（1：普通聊天，2：彩色聊天）
            --1（1：普通公告，2：彩色公告）
    --2（1：普通婚礼,2：浪漫婚礼，3：豪华婚礼，4：奢华婚礼）
    --3（1：世界BOSS开启,2：世界BOSS关闭）
    --4（1：弹王开始,2：弹王结束）
    --vipLevel发送人vip等级（系统的默认为0）
    --headScul:头像，（有头像为1，没有头像为0）
    --serviceId:接收人所在服务器id
    --colour:发送人头部颜色
    --level:发送人等级
    --WZLog("ProtocolProcessorGlobal:parse_CHAT_ReceiveMessage"..KLuaSocket:utfToGBK(message),channel)  
    --全服结婚动画处理
    -- bubbleId :聊天气泡ID
    -- playerTitle : 玩家称号（需要显示的才有内容，不符合显示要求的为""）
    -- playerPvpLevel : 玩家排位等级（对应排位表中的level3）
    -- professionId : 玩家职业Id(玩家职业(0=未开通|1=战士|2=刺客|3=法师))
    -- leagueId : 消息所属联盟Id
    local playerInfo = CacheCenter:getPlayerInfo()
--    WZLog("ProtocolProcessorGlobal:parse_CHAT_ReceiveMessageBatch ", Serialize(VectorToTable(sendId)), Serialize(VectorToTable(message)))
    -- WZLog("ProtocolProcessorGlobal:parse_CHAT_ReceiveMessageBatch ", 
    --     "\n channel =",Serialize(VectorToTable(channel)), 
    --     "\n sendId =",Serialize(VectorToTable(sendId)), 
    --     "\n sendName =",Serialize(VectorToTable(sendName)), 
    --     "\n receiveId =",Serialize(VectorToTable(receiveId)), 
    --     "\n receiveName =",Serialize(VectorToTable(receiveName)), 
    --     "\n message =",Serialize(VectorToTable(message)), 
    --     "\n rtime =",Serialize(VectorToTable(rtime)),
    --     "\n chatType =",Serialize(VectorToTable(chatType)),
    --     "\n subType =",Serialize(VectorToTable(subType)),
    --     "\n vipLevel =",Serialize(VectorToTable(vipLevel)),
    --     "\n sendFaceId =",Serialize(VectorToTable(sendFaceId)),
    --     "\n sendHeadId =",Serialize(VectorToTable(sendHeadId)),
    --     "\n sendSex =",Serialize(VectorToTable(sendSex)),
    --     "\n headScul =",Serialize(VectorToTable(headScul)),
    --     "\n serviceId =",Serialize(VectorToTable(serviceId)),
    --     "\n headColor =",Serialize(VectorToTable(headColor)),
    --     "\n senderLevel =",Serialize(VectorToTable(senderLevel)),
    --     "\n bubbleId =",Serialize(VectorToTable(bubbleId)), 
    --     "\n playerTitle =",Serialize(VectorToTable(playerTitle)), 
    --     "\n playerPvpLevel =",Serialize(VectorToTable(playerPvpLevel)), 
    --     "\n professionId =",Serialize(VectorToTable(professionId)), 
    --     "\n openStatus =",Serialize(VectorToTable(openStatus)), 
    --     "\n offlineMessage =",Serialize(VectorToTable(offlineMessage)), 
    --     "\n headEffectId =",Serialize(VectorToTable(headEffectId)))
    sendId = VectorToTable(sendId)
    sendName = VectorToTable(sendName)
    receiveId = VectorToTable(receiveId)
    receiveName = VectorToTable(receiveName)
    message = VectorToTable(message)
    rtime = VectorToTable(rtime)
    chatType = VectorToTable(chatType)
    subType = VectorToTable(subType)
    vipLevel = VectorToTable(vipLevel)
    sendFaceId = VectorToTable(sendFaceId)
    sendHeadId = VectorToTable(sendHeadId)
    sendSex = VectorToTable(sendSex)
    headScul = VectorToTable(headScul)
    serviceId = VectorToTable(serviceId)
    headColor = VectorToTable(headColor)
    senderLevel = VectorToTable(senderLevel)
    bubbleId = VectorToTable(bubbleId)
    playerTitle = VectorToTable(playerTitle)
    playerPvpLevel = VectorToTable(playerPvpLevel)
    professionId = VectorToTable(professionId)
    openStatus = VectorToTable(openStatus)
    offlineMessage = VectorToTable(offlineMessage)
    headEffectId = VectorToTable(headEffectId)
    leagueId = VectorToTable(leagueId)
    for i = 1, #sendId do
        --小助手的时候
        if sendId[i] == receiveId[i] and channel == CHANNEL_WHISPER then
            WndChat:saveAssiantToLacal(message[i], rtime[i])
        end

        if channel == CHANNEL_TEAM and chatType[i] == 8 then
            message[i] = SplitStringWithSeparator(message[i], ",", nil, true)
            synchronousVoicePlayerState(sendId[i], message[i])
            return
        end

        if (channel == CHANNEL_WORLD or channel == CHANNEL_SYSTEM) and chatType[i] == CHANNEL_GUILD then
            --WndMarryManager:playAllServerMarryAnimation( sendId, receiveName , subType,sendName )
        end

        if GetPlayTalk() == 1 and chatType[i] == 7 then
            return
        end
        
        if (channel == CHANNEL_SYSTEM or channel == CHANNEL_WORLD or channel == CHANNEL_COLORCHAT or channel==CHANNEL_GOLD ) and sendId[i] ~= GlobalGame.g_tPlayerInfo.nPlayerId  then
            local mes = message[i]
            local chType = chatType[i]
            if chType == 7 then
                local msss = SplitStringWithSeparator(message[i],"&")     
                local recordLen = tonumber(msss[2])
                local fileId = msss[1]
                local showText = msss[3]
                if showText == nil then
                    return
                end
                mes = showText
                chType = 1
            end

            local bInBlacklist = false 
            BANCHAT = CacheCenter:getFriendBlacklist()
            for j = 1, #BANCHAT do
                if BANCHAT[j].id == tonumber(sendId[i]) then
                    bInBlacklist = true
                    break 
                end
            end

            if channel == CHANNEL_COLORCHAT then
                local indexx = string.find(mes,"##~")
                local msg = mes
                if indexx ~= nil and indexx > 0 then
                    local teamRoomInfo = string.sub(msg,0,indexx-1)
                    local teamRoomInfo2 = string.sub(msg,indexx+3)
                    local tempT = SplitStringWithSeparator(teamRoomInfo2,"||")
                    if tempT and #tempT == 2 then
                        msg = teamRoomInfo
                        channel = CHANNEL_COPY
                    end
                end
                if msg == mes then --世界副本邀请不进行滚动显示
                    if not bInBlacklist then
                        if chatType[i] == 9 or chatType[i] == 10 then 
                            local sTempMsg = LocalStrings.RED_PACK14
                            WndSuona:showSuonaWithSendNameAndMessage(channel,sendName[i],sTempMsg,chType,subType[i],vipLevel)
                        else
                            WndSuona:showSuonaWithSendNameAndMessage(channel,sendName[i],mes,chType,subType[i],vipLevel)
                        end
                    end
                end
            else
                if not bInBlacklist then
                    if chatType[i] == 9 or chatType[i] == 10 then 
                        local sTempMsg = LocalStrings.RED_PACK14
                        WndSuona:showSuonaWithSendNameAndMessage(channel,sendName[i],sTempMsg,chatType[i],subType[i],vipLevel)
                    elseif chatType[i] == 11 then 
                        WndSuona:showSuonaWithSendNameAndMessage(channel,sendName[i],mes,chatType[i],subType[i],vipLevel)
                    else
                        WndSuona:showSuonaWithSendNameAndMessage(channel,sendName[i],mes,4,subType[i],vipLevel)
                    end
                end
            end
        end


        --遗迹副本处理 彩聊变为副本
        local sStart,sEnd,sContent = string.find(message[i],g_REMAINSMessage_Mark)
        if sContent then
            if channel==CHANNEL_COLORCHAT then
                channel = CHANNEL_COPY
            end

            --显示自己发出的遗迹分享
            if sendId[i] == GlobalGame.g_tPlayerInfo.nPlayerId then
                tabContent = json.decode(sContent)
                local sCurrentMsg = tabContent.desc .. tabContent.text
                WndChat:sendOwnChatMsg(channel, sCurrentMsg)
            end
        end


        if channel == CHANNEL_COLORCHAT and sendName[i] ==LocalStrings.CHAT_SYSTEM then
           return
        end

        if chatType[i] == 9 then 
            g_RedPackChannel = 0

            g_QuickRedPackState = true
            if SceneCity and SceneCity.m_tWndBottomBarObj then
                SceneCity.m_tWndBottomBarObj:setRedPackBtnVisible()
            end
            WndChat:setRedPackBtnVisible()
        elseif chatType[i] == 10 then 
            g_RedPackChannel = 1

            g_QuickRedPackState2 = true
            if SceneCity and SceneCity.m_tWndBottomBarObj then
                SceneCity.m_tWndBottomBarObj:setRedPackBtnVisible()
            end
            WndChat:setRedPackBtnVisible()
        end

        WndChat:getReceiveMessageOK(channel, sendId[i], sendName[i], receiveId[i], receiveName[i], message[i], rtime[i], vipLevel[i],sendFaceId[i],sendHeadId[i],sendSex[i],headScul[i],
            serviceId[i],headColor[i],senderLevel[i],chatType[i],bubbleId[i], playerTitle[i], playerPvpLevel[i], professionId[i], openStatus[i], offlineMessage[i], headEffectId[i])
        if channel == CHANNEL_WHISPER  then
            WZLog("getReceiveMessageOK" .. channel)
            GlobalGame.g_nPrivateNum = GlobalGame.g_nPrivateNum +1  --统计接收到得私聊信息数目
            WZLog("GlobalGame.g_nPrivateNum  "..GlobalGame.g_nPrivateNum)
        end
        --当玩家自己向好友发送信息时，不显示未读信息数目提示，数目置零
        if sendId[i] == GlobalGame.g_tPlayerInfo.nPlayerId or ((WBattleGlobal:getCurrent().m_tMakePairOk.selfId ~= nil) and (sendId[i] == (0 - WBattleGlobal:getCurrent().m_tMakePairOk.selfId))) then
            GlobalGame.g_nPrivateNum = 0
        end
    end
end

--@brief    商店评分奖励领取成功（PLAYER2_ReceivePraiseRewardOk = 51）
function ProtocolProcessorGlobal:parse_PLAYER2_ReceivePraiseRewardOk(result, itemIds, itemNums)
    -- result : 领取奖励结果【0=成功|1=参数错误I2=已领取过】
    -- itemIds : 奖励物品Id
    -- itemNums : 奖励数量
    WZLog("ProtocolProcessorGlobal:parse_PLAYER2_ReceivePraiseRewardOk", result)

    if result == 0 then 
        MsgBoxManager:showTipBox(LocalStrings.STORERATING[4])
        CacheCenter:getPlayerInfo().praiseRewardStatus = 1
        WndSweep:onClose()

        PassportSdkManager:doStoreRatingVN()
    end
end
-------------------------------------协议错误处理方法模块--------------------------------------

--@brief	获取角色信息错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note		在此对协议错误进行相应处理
function ProtocolProcessorGlobal:send_PLAYER_GetPlayerInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorGlobal:send_PLAYER_GetPlayerInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerInfo, nflag, sMessage)
end

--@brief	获取物品列表错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorGlobal:send_TRATE_GetShopListNew_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorGlobal:send_TRATE_GetShopListNew _ErrorProcess")
	WndShop:getShopListNewErrorProcess(sMessage)
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TRATE, Protocol.TRATE_GetShopListNew , nflag, sMessage)
end

--@brief	获取玩家身上装备列表（PLAYER_GetPlayerBodyEquipment = 5）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorGlobal:send_PLAYER_GetPlayerBodyEquipment_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorGlobal:send_PLAYER_GetPlayerBodyEquipment_ErrorProcess")
	--WndShop:getPlayerBodyEquipmentErrorProcess(sMessage)
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerBodyEquipment, nFlag, sMessage)
end

--@brief	获取玩家仓库装备列表
function ProtocolProcessorGlobal:send_PLAYER_GetPlayerStoreEquipmentNew(itemType, pageNumber )
	WZLog("send_PLAYER_GetPlayerStoreEquipmentNew")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerStoreEquipmentNew )
	if sender==nil then WZLog("sender == nil") return end
    
	sender:writeInt( itemType )	-- 物品类别（1：武器，2：装扮，3：其他）
	sender:writeInt( pageNumber )	-- 所需的页数
	SendProtocol(sender,false) --true:showLoading
end


--@brief	查看主角信息错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorGlobal:send_PLAYER_LookPlayerInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorGlobal:send_PLAYER_LookPlayerInfo_ErrorProcess")
    --WndBag:errorProcess(sMessage)
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_LookPlayerInfo, nflag, sMessage)
end

--@brief	世界语音聊天（CHAT_WorldIM = 11）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorGlobal:send_CHAT_WorldIM_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorGlobal:send_CHAT_WorldIM_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_CHAT, Protocol.CHAT_WorldIM, nflag, sMessage)
end

--@brief	获取玩家仓库装备列表错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorGlobal:send_PLAYER_GetPlayerStoreEquipmentNew_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorGlobal:send_PLAYER_GetPlayerStoreEquipmentNew_ErrorProcess")
    --WndPlayerGoods:errorProcess(sMessage)
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerStoreEquipmentNew, nflag, sMessage)
end

--@brief	获取娱乐赛信息（ROOM_GetFunnyMatchInfo = 97）
function ProtocolProcessorGlobal:send_ROOM_GetFunnyMatchInfo()
	WZLog("send_ROOM_GetFunnyMatchInfo")
	local sender = Protocol:getSender( Protocol.MAIN_ROOM, Protocol.ROOM_GetFunnyMatchInfo )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief    获取双人爬塔副本信息（BOSSMAPROOM_GetTwoTowerInfo = 44）
function ProtocolProcessorGlobal:send_BOSSMAPROOM_GetTwoTowerInfo()
    WZLog("send_BOSSMAPROOM_GetTwoTowerInfo")
    local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_GetTwoTowerInfo)
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief	获取玩家身上装备成功
function ProtocolProcessorGlobal:parse_PLAYER_GetPlayerBodyEquipmentOk(itemCount, id, name, icon, animationIndexCode, desc, itemMainType, itemSubType, sex, level, addHP, addPower, addAttack, attackArea, criticalCoefficient, addDefend, addCriticalRate, useLastTime, expExtraRate, p_lastTime, p_lastNum, m_proficiency, hasExpired, hasShowStrengthenInfo, pageNumber, totalNumber, skillType, skillLevel, starLevel, attackOpen, defendOpen, specialOpen, attackStoneLevel, defendStoneLevel, specailStoneLevel, betterok, petId,playerid)
	-- itemCount : 物品类型数量
	-- id : 物品序号
	-- name : 物品名字
	-- icon : relativePath/图标名称.png(资源会放到同一个目录下)
	-- animationIndexCode : 商品在动画资源包的索引串
	-- desc : 物品描述
	-- itemMainType :  0:投掷武器 1:射击武器 2:身躯装扮 3:脸谱 4:头发 5:一般道具（只能在战场上使用的道具） 6:合成类（合成时使用的） 7：镶嵌（镶嵌时使用的）8:其它
	-- itemSubType : 主类型是其它类型可以使用这个再分类
	-- sex : 0：女 1：男 2：不限
	-- level : 物品等级，人物低于这个等级是不能使用的
	-- addHP : 生命增加
	-- addPower : 体力增加
	-- addAttack : 攻击力增加
	-- attackArea : 攻击范围
	-- criticalCoefficient : 暴击换算系数
	-- addDefend : 防御增加
	-- addCriticalRate : 万份比数值(放大一万陪) 增加暴击率
	-- useLastTime : 使用后持续多少时间有这个效果（如多常时间内会提高获得经验比例）
	-- expExtraRate : 经验获得百分比加成(在一定时间内获得时间的加成）
	-- p_lastTime : 剩余的天数，如果是-1，就是不限时间使用
	-- p_lastNum : 剩余数量，如果是-1，就是不限数量使用
	-- m_proficiency : 物品熟练度
	-- hasExpired : 是否过期
	-- hasShowStrengthenInfo : 是否显示强化信息（即是否被强化或洗炼过）
	-- pageNumber : 当前页数
	-- totalNumber : 总页数
	-- skillType : 当前装备的武器的技能类型
	-- skillLevel : 当前装备的武器的技能等级
	-- starLevel : 装备星级
	-- attackOpen : 镶嵌的攻击宝石id。没有则为-1
	-- defendOpen : 镶嵌的防御宝石id。没有则为-1
	-- specialOpen : 镶嵌的特殊宝石id。没有则为-1
	-- attackStoneLevel : 攻击宝石等级（未镶嵌或未打孔等级为0）
	-- defendStoneLevel : 防御宝石等级（未镶嵌或未打孔等级为0）
	-- specailStoneLevel : 特殊宝石等级（未镶嵌或未打孔等级为0）
    -- betterok :
	-- petId : 玩家宠物技能ID（没有宠物ID为-1）
    -- playerid : 玩家ID
	WZLog("ProtocolProcessorGlobal:parse_PLAYER_GetPlayerBodyEquipmentOk")
    if playerid == GlobalGame.g_tPlayerInfo.nPlayerId then
        GlobalGame.g_tPlayerEquipments = {}
        GlobalGame.g_tPlayerEquipments.itemCount=itemCount
        GlobalGame.g_tPlayerEquipments.id=VectorToUserData(id)
        GlobalGame.g_tPlayerEquipments.name=VectorToUserData(name)
        GlobalGame.g_tPlayerEquipments.icon=VectorToUserData(icon)
        GlobalGame.g_tPlayerEquipments.animationIndexCode=VectorToUserData(animationIndexCode)
        GlobalGame.g_tPlayerEquipments.desc=VectorToUserData(desc)
        GlobalGame.g_tPlayerEquipments.itemMainType=VectorToUserData(itemMainType)
        GlobalGame.g_tPlayerEquipments.itemSubType=VectorToUserData(itemSubType)
        GlobalGame.g_tPlayerEquipments.sex=VectorToUserData(sex)
        GlobalGame.g_tPlayerEquipments.level=VectorToUserData(level)
        GlobalGame.g_tPlayerEquipments.addHP=VectorToUserData(addHP)
        GlobalGame.g_tPlayerEquipments.addPower=VectorToUserData(addPower)
        GlobalGame.g_tPlayerEquipments.addAttack=VectorToUserData(addAttack)
        GlobalGame.g_tPlayerEquipments.attackArea=VectorToUserData(attackArea)
        GlobalGame.g_tPlayerEquipments.criticalCoefficient=VectorToUserData(criticalCoefficient)
        GlobalGame.g_tPlayerEquipments.addDefend=VectorToUserData(addDefend)
        GlobalGame.g_tPlayerEquipments.addCriticalRate=VectorToUserData(addCriticalRate)
        GlobalGame.g_tPlayerEquipments.useLastTime=VectorToUserData(useLastTime)
        GlobalGame.g_tPlayerEquipments.expExtraRate=VectorToUserData(expExtraRate)
        GlobalGame.g_tPlayerEquipments.p_lastTime=VectorToUserData(p_lastTime)
        GlobalGame.g_tPlayerEquipments.p_lastNum=VectorToUserData(p_lastNum)
        GlobalGame.g_tPlayerEquipments.m_proficiency=VectorToUserData(m_proficiency)
        GlobalGame.g_tPlayerEquipments.hasExpired=VectorToUserData(hasExpired)
        GlobalGame.g_tPlayerEquipments.hasShowStrengthenInfo=VectorToUserData(hasShowStrengthenInfo)
        GlobalGame.g_tPlayerEquipments.pageNumber=pageNumber
        GlobalGame.g_tPlayerEquipments.totalNumber=totalNumber
        GlobalGame.g_tPlayerEquipments.skillType=VectorToUserData(skillType)
        GlobalGame.g_tPlayerEquipments.skillLevel=VectorToUserData(skillLevel)
        GlobalGame.g_tPlayerEquipments.starLevel=VectorToUserData(starLevel)
        GlobalGame.g_tPlayerEquipments.attackOpen=VectorToUserData(attackOpen)
        GlobalGame.g_tPlayerEquipments.defendOpen=VectorToUserData(defendOpen)
        GlobalGame.g_tPlayerEquipments.specialOpen=VectorToUserData(specialOpen)
        GlobalGame.g_tPlayerEquipments.attackStoneLevel=VectorToUserData(attackStoneLevel)
        GlobalGame.g_tPlayerEquipments.defendStoneLevel=VectorToUserData(defendStoneLevel)
        GlobalGame.g_tPlayerEquipments.specailStoneLevel=VectorToUserData(specailStoneLevel)
        GlobalGame.g_tPlayerEquipments.betterok=VectorToUserData(betterok)
        GlobalGame.g_tPlayerEquipments.petId=petId
    --[[
        if WindowManager:ifWindowExist(WndBag) then
            WndBag:receivePlayerEquipmentInfo()
        elseif WindowManager:ifWindowExist(WndShop) then
            --WndShop:GetPlayerBodyEquipmentOk(GlobalGame.g_tPlayerEquipments.id,GlobalGame.g_tPlayerEquipments.addHP,GlobalGame.g_tPlayerEquipments.addPower,GlobalGame.g_tPlayerEquipments.addAttack,GlobalGame.g_tPlayerEquipments.attackArea,GlobalGame.g_tPlayerEquipments.addCriticalRate,GlobalGame.g_tPlayerEquipments.icon, GlobalGame.g_tPlayerEquipments.m_proficiency , GlobalGame.g_tPlayerEquipments.skillType , GlobalGame.g_tPlayerEquipments.skillLevel ,GlobalGame.g_tPlayerEquipments.level,GlobalGame.g_tPlayerEquipments.itemMainType,GlobalGame.g_tPlayerEquipments.itemSubType)
        end
		--]]
    end
end

-------------------------------------服务器到客户端协议回调方法模块--------------------------------------
--@brief	接收主角信息成功并且加入缓存
function ProtocolProcessorGlobal:parse_PLAYER_LookPlayerInfoOk(playerId, playerName, level, currentExperience, needExperience, playerRank, vipMark, vipLevel, expDoubleMark, weaponsName, weaponSkillDegree, fighting, losing, winNum, playNumber, wbUserId, weiboIcon, zsLevel, doubleCard, weapSkill, headMessage, faceMessage, bodyMessage, weapMessage, wingMessage, ringMessage, ring2Message, necklaceMessage, communityName, communityPosition, callName, hp, attack, defend, reduceCrit, physical, wreckDefense, luck, critRate, weaponsArea, petMessage)
	-- playerId : 玩家Id
	-- playerName : 玩家名称
	-- level : 玩家等级
	-- currentExperience : 玩家当前经验
	-- needExperience : 玩家该等级升级所需经验
	-- playerRank : 玩家军衔
	-- vipMark : vip标识
	-- vipLevel : vip等级
	-- expDoubleMark : buff状态标识
	-- weaponsName : 玩家武器名称
	-- weaponSkillDegree : 武器熟练度
	-- fighting : 战斗力
	-- losing : 胜率(服务端*100倍，客户端转换成0.00%形式)
	-- winNum : 胜利次数
	-- playNumber : 游戏次数
	-- wbUserId : 微博uid
	-- weiboIcon : 微博图片url
	-- zsLevel : 玩家的转生等级
	-- doubleCard : 双倍经验卡
	-- weapSkill : 武器技能
	-- headMessage : 头部装备信息
	-- faceMessage : 脸部装备信息
	-- bodyMessage : 身体装备信息
	-- weapMessage : 武器信息
	-- wingMessage : 翅膀装备信息
	-- ringMessage : 戒指装备信息
	-- ring2Message : 装备戒指装备信息
	-- necklaceMessage : 项链装备信息
	-- communityName : 玩家公会名称
	-- communityPosition : 公会职务
	-- callName : 玩家称号
	-- hp : 生命值
	-- attack : 攻击力
	-- defend : 防御值
	-- reduceCrit : 免暴
	-- physical : 体力值
	-- wreckDefense : 破防
	-- luck : 幸运
	-- critRate : 暴击率
	-- weaponsArea : 武器攻击范围
	-- petMessage : 宠物信息
	WZLog("ProtocolProcessorGlobal:parse_PLAYER_LookPlayerInfoOk")
    
    GlobalGame.g_tBagInfo={}
        GlobalGame.g_tBagInfo.playerId=playerId
        GlobalGame.g_tBagInfo.playerName=playerName
        GlobalGame.g_tBagInfo.level=level
        GlobalGame.g_tBagInfo.currentExperience=currentExperience
        GlobalGame.g_tBagInfo.needExperience=needExperience
        GlobalGame.g_tBagInfo.playerRank=playerRank
        GlobalGame.g_tBagInfo.vipMark=vipMark
        GlobalGame.g_tBagInfo.vipLevel=vipLevel
        GlobalGame.g_tBagInfo.expDoubleMark=VectorToUserData(expDoubleMark)
        GlobalGame.g_tBagInfo.weaponsName=weaponsName
        GlobalGame.g_tBagInfo.weaponSkillDegree=weaponSkillDegree
        GlobalGame.g_tBagInfo.fighting=fighting
        GlobalGame.g_tBagInfo.losing=losing
        GlobalGame.g_tBagInfo.winNum=winNum
        GlobalGame.g_tBagInfo.playNumber=playNumber
        GlobalGame.g_tBagInfo.wbUserId=VectorToUserData(wbUserId)
        GlobalGame.g_tBagInfo.weiboIcon=VectorToUserData(weiboIcon)
        GlobalGame.g_tBagInfo.zsLevel=zsLevel
        GlobalGame.g_tBagInfo.doubleCard=doubleCard
        GlobalGame.g_tBagInfo.weapSkill=VectorToUserData(weapSkill)
        GlobalGame.g_tBagInfo.headMessage=VectorToUserData(headMessage)
        GlobalGame.g_tBagInfo.faceMessage=VectorToUserData(faceMessage)
        GlobalGame.g_tBagInfo.bodyMessage=VectorToUserData(bodyMessage)
        GlobalGame.g_tBagInfo.weapMessage=VectorToUserData(weapMessage)
        GlobalGame.g_tBagInfo.wingMessage=VectorToUserData(wingMessage)
        GlobalGame.g_tBagInfo.ringMessage=VectorToUserData(ringMessage)
        GlobalGame.g_tBagInfo.ring2Message=VectorToUserData(ring2Message)
        GlobalGame.g_tBagInfo.necklaceMessage=VectorToUserData(necklaceMessage)
        GlobalGame.g_tBagInfo.communityName=communityName
        GlobalGame.g_tBagInfo.communityPosition=communityPosition
        GlobalGame.g_tBagInfo.callName=callName
        GlobalGame.g_tBagInfo.hp=hp
        GlobalGame.g_tBagInfo.attack=attack
        GlobalGame.g_tBagInfo.defend=defend
        GlobalGame.g_tBagInfo.reduceCrit=reduceCrit
        GlobalGame.g_tBagInfo.physical=physical
        GlobalGame.g_tBagInfo.wreckDefense=wreckDefense
        GlobalGame.g_tBagInfo.luck=luck
        GlobalGame.g_tBagInfo.critRate=critRate
        GlobalGame.g_tBagInfo.weaponsArea=weaponsArea
        GlobalGame.g_tBagInfo.petMessage=VectorToUserData(petMessage)
    
    GlobalGame.g_tLookEquipment = {}

    GlobalGame.g_tLookEquipment[g_tEquipmentIndex.EQUIP_HEAD] = VectorToUserData(headMessage)
    GlobalGame.g_tLookEquipment[g_tEquipmentIndex.EQUIP_FACE] = VectorToUserData(faceMessage)
    GlobalGame.g_tLookEquipment[g_tEquipmentIndex.EQUIP_BODY] = VectorToUserData(bodyMessage)
    GlobalGame.g_tLookEquipment[g_tEquipmentIndex.EQUIP_WEAPON] = VectorToUserData(weapMessage)
    GlobalGame.g_tLookEquipment[g_tEquipmentIndex.EQUIP_WING] = VectorToUserData(wingMessage)
    GlobalGame.g_tLookEquipment[g_tEquipmentIndex.EQUIP_RING1] = VectorToUserData(ringMessage)
    GlobalGame.g_tLookEquipment[g_tEquipmentIndex.EQUIP_RING2] = VectorToUserData(ring2Message)
    GlobalGame.g_tLookEquipment[g_tEquipmentIndex.EQUIP_NECKLACE] = VectorToUserData(necklaceMessage)
    
    if WindowManager:ifWindowExist(WndBag) then
       WndBag:lookPlayerInfoOk() 
    end
end

--@brief	获取玩家装备列表成功
function ProtocolProcessorGlobal:parse_PLAYER_GetPlayerStoreEquipmentOk(itemCount, id, name, icon, animationIndexCode, desc, itemMainType, itemSubType, sex, level, addHP, addPower, addAttack, attackArea, criticalCoefficient, addDefend, addCriticalRate, useLastTime, expExtraRate, p_lastTime, p_lastNum, m_proficiency, hasExpired, hasShowStrengthenInfo, pageNumber, totalNumber, skillType, skillLevel, starLevel, attackOpen, defendOpen, specialOpen, attackStoneLevel, defendStoneLevel, specailStoneLevel, betterok, useLevel, lastTimeMark, isUse, attribute,itemType)
	WZLog("获取玩家装备列表成功:golb:")
	-- itemCount : 物品类型数量
	-- id : 物品序号
	-- name : 物品名字
	-- icon : relativePath/图标名称.png(资源会放到同一个目录下)
	-- animationIndexCode : 商品在动画资源包的索引串
	-- desc : 物品描述
	-- itemMainType :  0:投掷武器 1:射击武器 2:身躯装扮 3:脸谱 4:头发 5:一般道具（只能在战场上使用的道具）  6:合成类（合成时使用的） 7：镶嵌（镶嵌时使用的）8:其它
	-- itemSubType : 主类型是其它类型可以使用这个再分类
	-- sex : 0：女 1：男 2：不限
	-- level : 物品等级，人物低于这个等级是不能使用的
	-- addHP : 生命增加
	-- addPower : 体力增加
	-- addAttack : 攻击力增加
	-- attackArea : 攻击范围
	-- criticalCoefficient : 暴击换算系数
	-- addDefend : 防御增加
	-- addCriticalRate : 万份比数值(放大一万陪) 增加暴击率
	-- useLastTime : 使用后持续多少时间有这个效果（如多常时间内会提高获得经验比例）
	-- expExtraRate : 经验获得百分比加成(在一定时间内获得时间的加成）
	-- p_lastTime : 剩余的天数，如果是-1，就是不限时间使用
	-- p_lastNum : 剩余数量，如果是-1，就是不限数量使用
	-- m_proficiency : 物品熟练度
	-- hasExpired : 是否过期
	-- hasShowStrengthenInfo : 是否显示强化信息（即是否被强化或洗炼过）
	-- pageNumber : 当前页数
	-- totalNumber : 总页数
	-- skillType : 当前装备的武器的技能类型
	-- skillLevel : 当前装备的武器的技能等级
	-- starLevel : 装备星级
	-- attackOpen : 镶嵌的攻击宝石id。没有则为-1
	-- defendOpen : 镶嵌的防御宝石id。没有则为-1
	-- specialOpen : 镶嵌的特殊宝石id。没有则为-1
	-- attackStoneLevel : 攻击宝石等级（未镶嵌或未打孔等级为0）
	-- defendStoneLevel : 防御宝石等级（未镶嵌或未打孔等级为0）
	-- specailStoneLevel : 特殊宝石等级（未镶嵌或未打孔等级为0）
	-- useLevel : 物品使用等级
	-- lastTimeMark : 剩余天数（-1表示不按天数计算或无限期，10期添加）
    -- isUse : 是否穿在身上
    -- attribute : 物品当前属性文字描述（非数据表里的desc）
    -- itemType : 所需要的类型，1代表武器，2装扮，3其他
	WZLog("ProtocolProcessorGlobal:parse_PLAYER_GetPlayerStoreEquipmentOk:获取玩家装备列表成功:",itemType,itemCount)
     if itemType == 1 then
     GlobalGame.g_tPlayerStoreEquipment1 = {
     itemCount=VectorToTable(itemCount),
     id=VectorToUserData(id),
     name=VectorToTable(name),
     icon=VectorToTable(icon),
     animationIndexCode=VectorToTable(animationIndexCode),
     desc=VectorToTable(desc),
     itemMainType=VectorToTable(itemMainType),
     itemSubType=VectorToTable(itemSubType),
     sex=VectorToTable(sex),
     level=VectorToTable(level),
     addHP=VectorToTable(addHP),
     addPower=VectorToTable(addPower),
     addAttack=VectorToTable(addAttack),
     attackArea=VectorToTable(attackArea),
     criticalCoefficient=VectorToTable(criticalCoefficient),
     addDefend=VectorToTable(addDefend),
     addCriticalRate=VectorToTable(addCriticalRate),
     useLastTime=VectorToTable(useLastTime),
     expExtraRate=VectorToTable(expExtraRate),
     p_lastTime=VectorToTable(p_lastTime),
     p_lastNum=VectorToTable(p_lastNum),
     m_proficiency=VectorToTable(m_proficiency),
     hasExpired=VectorToTable(hasExpired),
     hasShowStrengthenInfo=VectorToTable(hasShowStrengthenInfo),
     pageNumber=VectorToTable(pageNumber),
     totalNumber=(totalNumber),
     skillType=VectorToTable(skillType),
     skillLevel=VectorToTable(skillLevel),
     starLevel=VectorToTable(starLevel),
     attackOpen=VectorToTable(attackOpen),
     defendOpen=VectorToTable(defendOpen),
     specialOpen=VectorToTable(specialOpen),
     attackStoneLevel=VectorToTable(attackStoneLevel),
     defendStoneLevel=VectorToTable(defendStoneLevel),
     specailStoneLevel=VectorToTable(specailStoneLevel),
     betterok=VectorToTable(betterok),
     useLevel=VectorToTable(useLevel),
     lastTimeMark=VectorToTable(lastTimeMark),
     isUse=VectorToTable(isUse),
     attribute=VectorToTable(attribute)}
    elseif itemType == 2 then
     GlobalGame.g_tPlayerStoreEquipment2 = {
     itemCount=VectorToTable(itemCount),
     id=VectorToUserData(id),
     name=VectorToTable(name),
     icon=VectorToTable(icon),
     animationIndexCode=VectorToTable(animationIndexCode),
     desc=VectorToTable(desc),
     itemMainType=VectorToTable(itemMainType),
     itemSubType=VectorToTable(itemSubType),
     sex=VectorToTable(sex),
     level=VectorToTable(level),
     addHP=VectorToTable(addHP),
     addPower=VectorToTable(addPower),
     addAttack=VectorToTable(addAttack),
     attackArea=VectorToTable(attackArea),
     criticalCoefficient=VectorToTable(criticalCoefficient),
     addDefend=VectorToTable(addDefend),
     addCriticalRate=VectorToTable(addCriticalRate),
     useLastTime=VectorToTable(useLastTime),
     expExtraRate=VectorToTable(expExtraRate),
     p_lastTime=VectorToTable(p_lastTime),
     p_lastNum=VectorToTable(p_lastNum),
     m_proficiency=VectorToTable(m_proficiency),
     hasExpired=VectorToTable(hasExpired),
     hasShowStrengthenInfo=VectorToTable(hasShowStrengthenInfo),
     pageNumber=VectorToTable(pageNumber),
     totalNumber=(totalNumber),
     skillType=VectorToTable(skillType),
     skillLevel=VectorToTable(skillLevel),
     starLevel=VectorToTable(starLevel),
     attackOpen=VectorToTable(attackOpen),
     defendOpen=VectorToTable(defendOpen),
     specialOpen=VectorToTable(specialOpen),
     attackStoneLevel=VectorToTable(attackStoneLevel),
     defendStoneLevel=VectorToTable(defendStoneLevel),
     specailStoneLevel=VectorToTable(specailStoneLevel),
     betterok=VectorToTable(betterok),
     useLevel=VectorToTable(useLevel),
     lastTimeMark=VectorToTable(lastTimeMark),
     isUse=VectorToTable(isUse),
     attribute=VectorToTable(attribute)}
     
    elseif itemType == 3 then
     GlobalGame.g_tPlayerStoreEquipment3 = {
     itemCount=VectorToTable(itemCount),
     id=VectorToUserData(id),
     name=VectorToTable(name),
     icon=VectorToTable(icon),
     animationIndexCode=VectorToTable(animationIndexCode),
     desc=VectorToTable(desc),
     itemMainType=VectorToTable(itemMainType),
     itemSubType=VectorToTable(itemSubType),
     sex=VectorToTable(sex),
     level=VectorToTable(level),
     addHP=VectorToTable(addHP),
     addPower=VectorToTable(addPower),
     addAttack=VectorToTable(addAttack),
     attackArea=VectorToTable(attackArea),
     criticalCoefficient=VectorToTable(criticalCoefficient),
     addDefend=VectorToTable(addDefend),
     addCriticalRate=VectorToTable(addCriticalRate),
     useLastTime=VectorToTable(useLastTime),
     expExtraRate=VectorToTable(expExtraRate),
     p_lastTime=VectorToTable(p_lastTime),
     p_lastNum=VectorToTable(p_lastNum),
     m_proficiency=VectorToTable(m_proficiency),
     hasExpired=VectorToTable(hasExpired),
     hasShowStrengthenInfo=VectorToTable(hasShowStrengthenInfo),
     pageNumber=VectorToTable(pageNumber),
     totalNumber=(totalNumber),
     skillType=VectorToTable(skillType),
     skillLevel=VectorToTable(skillLevel),
     starLevel=VectorToTable(starLevel),
     attackOpen=VectorToTable(attackOpen),
     defendOpen=VectorToTable(defendOpen),
     specialOpen=VectorToTable(specialOpen),
     attackStoneLevel=VectorToTable(attackStoneLevel),
     defendStoneLevel=VectorToTable(defendStoneLevel),
     specailStoneLevel=VectorToTable(specailStoneLevel),
     betterok=VectorToTable(betterok),
     useLevel=VectorToTable(useLevel),
     lastTimeMark=VectorToTable(lastTimeMark),
     isUse=VectorToTable(isUse),
     attribute=VectorToTable(attribute)}
     end
--[[
    if WindowManager:ifWindowExist(WndBag) and (itemType == 3 or itemType == 2 or itemType == 1) then
        WndPlayerGoods:getPlayerStoreEquipment(WndPlayerGoods.m_ntype, WndPlayerGoods.m_nPage)
    end
	--]]
end

--@brief	发送好友列表（FRIEND_SendFriendList = 2）
function ProtocolProcessorGlobal:parse_FRIEND_SendFriendList(playerId, playerName, level, sex, online, pageNumber, totalPage,zsleve,fighting,community,friendCount,maxCount)
	-- playerId : 好友Id
	-- playerName : 好友名称
	-- level : 好友等级
	-- sex : 好友性别，false是男，true是女
	-- online : 好友是否在线
	-- pageNumber : 当前第几页
	-- totalPage : 总页数
	-- zsleve : 转生等级
	-- fighting : 玩家战斗力
	-- community : 玩家公会
    -- friendCoun : 玩家好友数量
    -- maxCount : 玩家最大好友数量
	WZLog("ProtocolProcessorGlobal:parse_FRIEND_SendFriendList55",fighting,playerId:size(),pageNumber,totalPage)
    GlobalGame.g_tFrientList.playerId=VectorToUserData(playerId)
    GlobalGame.g_tFrientList.playerName=VectorToUserData(playerName)
    GlobalGame.g_tFrientList.level=VectorToUserData(level)
    GlobalGame.g_tFrientList.sex=VectorToUserData(sex)
    GlobalGame.g_tFrientList.online=VectorToUserData(online)
    GlobalGame.g_tFrientList.pageNumber=pageNumber
    GlobalGame.g_tFrientList.totalPage=totalPage
    GlobalGame.g_tFrientList.zsleve=VectorToUserData(zsleve)
    GlobalGame.g_tFrientList.fighting=VectorToUserData(fighting)
    GlobalGame.g_tFrientList.community=VectorToUserData(community)
    GlobalGame.g_tFrientList.friendCount=VectorToUserData(friendCount)
    GlobalGame.g_tFrientList.maxCount=maxCount
    
    if WindowManager:ifWindowExist(WndNearbyFriend) then
         WndNearbyFriend:setFriendOkData(GlobalGame.g_tFrientList.playerId, GlobalGame.g_tFrientList.playerName, GlobalGame.g_tFrientList.level, GlobalGame.g_tFrientList.sex, GlobalGame.g_tFrientList.online, GlobalGame.g_tFrientList.pageNumber, GlobalGame.g_tFrientList.totalPage,GlobalGame.g_tFrientList.zsleve,GlobalGame.g_tFrientList.fighting,GlobalGame.g_tFrientList.community,GlobalGame.g_tFrientList.friendCount,GlobalGame.g_tFrientList.maxCount,0)
    end
    WZLog("globalfriend",WindowManager:ifWindowExist(WndFriendImpl),WndFriendImpl.nFlagWhickCheckBoxSel)
    if WindowManager:ifWindowExist(WndFriendImpl) and WndFriendImpl.nFlagWhickCheckBoxSel == 0 then
       WndFriendImpl:getFriendListOK(GlobalGame.g_tFrientList.playerId, GlobalGame.g_tFrientList.playerName, GlobalGame.g_tFrientList.level, GlobalGame.g_tFrientList.sex, GlobalGame.g_tFrientList.online, GlobalGame.g_tFrientList.pageNumber, GlobalGame.g_tFrientList.totalPage,GlobalGame.g_tFrientList.zsleve,-1)
    end
end
--@brief	发送黑名单列表（FRIEND_SendBlackList = 16）
function ProtocolProcessorGlobal:parse_FRIEND_SendBlackList(playerId, playerName, level, sex, online, pageNumber, totalPage, zsleve,fighting,community)
	-- playerId : 好友Id
	-- playerName : 好友名称
	-- level : 好友等级
	-- sex : 好友性别，false是男，true是女
	-- online : 好友是否在线
	-- pageNumber : 当前第几页
	-- totalPage : 总页数
	-- zsleve : 转生等级
	-- fighting : 玩家战斗力
	-- community : 玩家公会
	WZLog("ProtocolProcessorGlobal:parse_FRIEND_SendBlackList")
    GlobalGame.g_tBlackList.playerId = VectorToUserData(playerId)
    GlobalGame.g_tBlackList.playerName = VectorToUserData(playerName)
    GlobalGame.g_tBlackList.level = VectorToUserData(level)
    GlobalGame.g_tBlackList.sex = VectorToUserData(sex)
    GlobalGame.g_tBlackList.online = VectorToUserData(online)
    GlobalGame.g_tBlackList.pageNumber = pageNumber
    GlobalGame.g_tBlackList.totalPage = totalPage
    GlobalGame.g_tBlackList.zsleve = VectorToUserData(zsleve)
    GlobalGame.g_tBlackList.fighting = VectorToUserData(fighting)
    GlobalGame.g_tBlackList.community = VectorToUserData(community)

    if WindowManager:ifWindowExist(WndNearbyFriend) then
        WndNearbyFriend:setBackFriendData(GlobalGame.g_tBlackList.playerId, GlobalGame.g_tBlackList.playerName, GlobalGame.g_tBlackList.level, GlobalGame.g_tBlackList.sex, GlobalGame.g_tBlackList.online, GlobalGame.g_tBlackList.pageNumber, GlobalGame.g_tBlackList.totalPage,GlobalGame.g_tBlackList.zsleve,GlobalGame.g_tBlackList.fighting,GlobalGame.g_tBlackList.community)--黑名单数据列表
	end
end

--@brief	获取关卡信息成功（MAP_GetSingleMapListOk = 2）
function ProtocolProcessorGlobal:parse_MAP_GetSingleMapListOk(pointId, passTime, restTimes ,factor, sectionId, rewardNum,sectionId2,rewardNum2, sectionId3, rewardNum3)
	-- mapId : 关卡ID
	-- passTimes : 当日通关次数
	-- restTimes : 当日重置次数
	-- factor : 通关条件状态1位条件一，2位条件二，3位条件三
	-- sectionId1 : 普通章节ID
	-- rewardNum1 : 领取的奖励数1位奖励一，2位奖励二，3位奖励三
	-- sectionId2 : 精英章节ID
	-- rewardNum2 : 领取的奖励数1位奖励一，2位奖励二，3位奖励三
	-- sectionId3 : 噩梦章节ID
	-- rewardNum3 : 领取的奖励数1位奖励一，2位奖励二，3位奖励三
	WZLog("ProtocolProcessorGlobal:parse_MAP_GetSingleMapListOk")

	-- pointId : 关卡ID
	-- passTime : 当日通关次数
	-- factor : 通关条件状态1位条件一，2位条件二，3位条件三
	-- sectionId : 章节ID
	-- rewardNum : 领取的奖励数1位奖励一，2位奖励二，3位奖励三
	WZLog("ProtocolProcessorGlobal:parse_SINGLEMAP_GetPointsOk")
    CacheCenter:setSingleCopyData(VectorToTable(pointId), VectorToTable(passTime), VectorToTable(factor), VectorToTable(sectionId), VectorToTable(rewardNum),VectorToTable(sectionId2),VectorToTable(rewardNum2),VectorToTable(restTimes),VectorToTable(sectionId3), VectorToTable(rewardNum3))

    SceneCity:getSingleData()
end

--@brief	发送副本列表
function ProtocolProcessorGlobal:parse_BOSSMAPROOM_SendBossMapList(resetTime, mapId, passTime, starLevel, awakeMap, awakeTimes, awakeJson)
	-- resetTime : 重置次数
	-- mapId : 地图id
	-- passTime : 已挑战次数
	-- starLevel : 副本星级（未打过的副本星级为0）
    -- awakeMap : 当前开启的觉醒难度的副本Id
    -- awakeTimes : 当天挑战觉醒副本的次数
    -- awakeJson : 觉醒玩家头像信息
	WZLog("ProtocolProcessorGlobal:parse_BOSSMAPROOM_SendBossMapListaa")
    CacheCenter:setMultiCopyData(resetTime, VectorToTable(mapId), VectorToTable(passTime), VectorToTable(starLevel), awakeMap, awakeTimes, awakeJson)
end

--@brief	获取爬塔副本信息
function ProtocolProcessorGlobal:parse_SINGLEMAP_GetTowerInfoOk(topFloor, nowFloor, dareTimes, resetTimes, myRank,isReward,state,remainTime,oneFloor)
	-- topFloor : 最高记录层数
	-- nowFloor : 当前层数
	-- dareTimes : 本层挑战次数
	-- resetTimes : 可重置次数
    -- state : 扫荡状态 0：未开始，1进行中
    -- remainTime : 剩余秒数
	WZLog("ProtocolProcessorSingleMap:parse_SINGLEMAP_GetTowerInfoOk")
    SceneCopy:closeLoading()
    local timeStruct = os.date("*t",os.time())
	local timeStr = string.format("%d%d%02d",timeStruct.year,timeStruct.month,timeStruct.day)
    local data = {topFloor = topFloor,nowFloor = nowFloor,dareTimes = dareTimes,resetTimes = resetTimes, myRank = myRank,isReward = isReward,state = state,remainTime = remainTime,oneFloor = oneFloor,timeStr=timeStr}
    CacheCenter:setTowerCopyData(data)
end

--@brief	IMTOKEN结果（CHAT_GetIMToken = 6）
function ProtocolProcessorGlobal:parse_CHAT_GetIMTokenOK(token, appkey)
	-- token : 验证token
	-- appkey : 应用appkey
	WZLog("ProtocolProcessorGlobal:parse_CHAT_GetIMToken")
    GlobalGame.g_sRecordToken = token
    GlobalGame.g_sRecordAppkey = appkey
end

--@brief	聊天室列表结果（CHAT_GetRoomListOK = 8）
function ProtocolProcessorGlobal:parse_CHAT_GetRoomListOK(roomId, roomType,sceneIds,appKey)
	-- roomId : 聊天室编号
	-- roomType : 聊天室类型1、公会，2、战斗,3、当前主场景
	WZLog("ProtocolProcessorGlobal:parse_CHAT_GetRoomListOK", appKey)
	if roomId == nil or roomType == nil then
		return
	end
	local roomIds = VectorToTable(roomId)
	local roomTypes = VectorToTable(roomType)
	local sceneId = VectorToTable(sceneIds)
	GlobalGame.g_tRecordRoomList = {}
	GlobalGame.g_sServerAppkey = appKey
	GlobalGame.g_tEnterRecordRoomList = {}
	--local curSceneName = GetRunningSceneName()
	--local chatId = GlobalGame.g_tSceneList[curSceneName]
	for i,v in ipairs(roomIds) do
		local recordRoomInfo = {}
		table.insert(recordRoomInfo,v)
		table.insert(recordRoomInfo,roomTypes[i])
		table.insert(recordRoomInfo,sceneId[i])
		table.insert(GlobalGame.g_tRecordRoomList,recordRoomInfo)
	end
	WZLog("voice room list =",Serialize(GlobalGame.g_tRecordRoomList))
	EnterRecordRoom()
end

--@brief	新增聊天室（CHAT_AddRoom = 9）
function ProtocolProcessorGlobal:parse_CHAT_AddRoom(roomId,roomType,sceneId)
	-- roomId : 聊天室编号
	-- roomType : 聊天室类型1、公会，2、战斗,3、当前主场景
	WZLog("ProtocolProcessorGlobal:parse_CHAT_AddRoom")
	-- if roomId == nil or roomType == nil then
	-- 	return
	-- end
	-- local index = nil
	-- for i,v in ipairs(GlobalGame.g_tRecordRoomList) do
	-- 	if v[1] == roomId then
	-- 		i = index
	-- 	end
	-- end
	-- if index ~= nil then
	-- 	table.remove(GlobalGame.g_tRecordRoomList,index)
	-- end
	-- local recordRoomInfo = {}
	-- table.insert(recordRoomInfo,roomId)
	-- table.insert(recordRoomInfo,roomType)
	-- table.insert(recordRoomInfo,sceneId)
	-- table.insert(GlobalGame.g_tRecordRoomList,recordRoomInfo)
 --    WZLog("ProtocolProcessorGlobal:parse_CHAT_AddRoom = ",roomId,roomType,sceneId)
	
	--SDK_Talk:setRoomState("enter",tostring(roomId),WndChat.callbackEnterOrExitChatRoom,WndChat)
end

--@brief	删除聊天室（CHAT_DelRoom = 10）
function ProtocolProcessorGlobal:parse_CHAT_DelRoom(roomId)
	-- roomId : 聊天室编号
	WZLog("ProtocolProcessorGlobal:parse_CHAT_DelRoom")
	-- if roomId == nil then
	-- 	return
	-- end
	-- local index = nil
	-- for i,v in ipairs(GlobalGame.g_tRecordRoomList) do
	-- 	if v[1] == roomId then
	-- 		index = i
	-- 	end
	-- end
	-- if index ~= nil then
	-- 	table.remove(GlobalGame.g_tRecordRoomList,index)
	-- end
	--SDK_Talk:setRoomState("exit",tostring(roomId),WndChat.callbackEnterOrExitChatRoom,WndChat)  --退出聊天室
end

--@brief      查看战斗记录(BATTLE_RecordOk=57)
function ProtocolProcessorGlobal:parse_BATTLE_RecordOk(recordMes,typeId)
    -- recordMes : 战斗记录内容
    WZLog("ProtocolProcessorGlobal:parse_BATTLE_RecordOk")
    BattleMsgReplayGameRecord:setRecord(VectorToTable(recordMes),typeId)
    replaceScene(SceneBattleLoading:createElement())
end

--@brief	获取娱乐赛信息结果（ROOM_GetFunnyMatchInfoOk = 96）
function ProtocolProcessorGlobal:parse_ROOM_GetFunnyMatchInfoOk(matchType, activityStatus, dayOfWeek, dayBegin, coinDropNum)
	-- matchType : 比赛类型 1:挖坑,2:队长,3:道具,4:乱斗,5:复活
	-- activityStatus : 活动状态,1:开启,2:结束
	-- dayOfWeek : 逗号隔开,"0,1,2"表示周日周一周二开启
    -- dayBegin : 几天后开启
    -- coinDropNum : 當天掉落的冒险币数量
	WZLog("ProtocolProcessorGlobal:parse_ROOM_GetFunnyMatchInfoOk")
	ScenePvpAmuse:setOpenState(VectorToTable(matchType), VectorToTable(activityStatus), VectorToTable(dayOfWeek), VectorToTable(dayBegin), coinDropNum)
end

--@brief	获取加成卡信息（ROOM_GetAdditionInfo = 100）
function ProtocolProcessorGlobal:parse_ROOM_GetAdditionInfo(addValue, timeValue, timeType,serverTime)
	-- addValue : 加成比例
	-- timeValue : 加成时效
	-- timeType : 时效类型（0竞技次数，1时间, 2排位加成,3回归勇者积分,4回归竞技积分）
	WZLog("ProtocolProcessorGlobal:parse_ROOM_GetAdditionInfo", Serialize(VectorToTable(addValue)), Serialize(VectorToTable(timeValue)), Serialize(VectorToTable(timeType)))
	CacheCenter:setArenaAddInfo(VectorToTable(addValue),VectorToTable(timeValue),VectorToTable(timeType),serverTime)
	if ScenePvp.m_root then
		local element = ScenePvp.m_root:getChildByTag(8989898)
		if element then
			element = WZUIContainer:luaTo(element)
			local luaObject = element:getLuaObjectIndex()
			luaObject:updateArenaAddBtn()
		end
	end
end

--@brief    获取世界杯活动状态（ACTIVITY_GetWorldCupActivityStatusOk = 111）
function ProtocolProcessorGlobal:parse_ACTIVITY_GetWorldCupActivityStatusOk(status)
    -- status : 状态(1:进行中;2:关闭)
    WZLog("ProtocolProcessorGlobal:parse_ACTIVITY_GetWorldCupActivityStatusOk", status)
    GlobalGame.g_autoFootballActivity = status

    if WndOwnCity.openFootball then
        WndOwnCity:openFootball(status == 1)
    end
end

--@brief    激活聊天气泡（CHAT_ActivateOK = 15）
function ProtocolProcessorGlobal:parse_CHAT_ActivateOK (bubbleId)
    -- bubbleId : 是否成功
    WZLog("ProtocolProcessorGlobal:parse_CHAT_ActivateOK ",bubbleId)
    MsgBoxManager:showTipBox(LocalStrings.STARSOUL_ACTIVITY_SUCCESS)
end

--@brief    购买聊天气泡（CHAT_BuyChatBubbleOk = 17）
function ProtocolProcessorGlobal:parse_CHAT_BuyChatBubbleOk(bubbleId)
    -- bubbleId : 聊天气泡Id
    WZLog("ProtocolProcessorGlobal:parse_CHAT_BuyChatBubbleOk", bubbleId)
    
    WndChat:buyBubbleOk(bubbleId)
end

--@brief    被邀请（TEAMWORLDBOSS_BeInvite = 8）
function ProtocolProcessorGlobal:parse_TEAMWORLDBOSS_BeInvite(roomId, playerName, mapId, password, roomChannel, interfaceId, playerId)
    -- roomId : 房间ID
    -- playerName : 玩家名
    -- mapId : 地图
    -- password : 房间密码
    -- roomChannel : 房间频道
    WZLog("ProtocolProcessorGlobal:parse_TEAMWORLDBOSS_BeInvite")

    SceneWorldTeamBossRoom:beInvited(roomId , playerName, mapId, password, roomChannel, interfaceId, playerId)
end

--@brief    夫妻争霸被邀请（COUPLEFIGHTBOSS_BeInvite = 8）
function ProtocolProcessorGlobal:parse_COUPLEFIGHTBOSS_BeInvite(roomId, playerName, mapId, passWorld, roomChannel, interfaceId, playerId)
    -- roomId : 
    -- playerName : 
    -- mapId : 
    -- passWorld : 
    -- roomChannel : 
    -- paramInt1 : 客户端定义的参数，原封不动返回
    -- fromPlayerId : 发出玩家id
    WZLog("ProtocolProcessorGlobal:parse_COUPLEFIGHTBOSS_BeInvite")
    
    SceneCoupleHegemonyRoom:beInvited(roomId , playerName, mapId, password, roomChannel, interfaceId, playerId)
end

--@brief    点赞BUFF(BATTLE_ThumbUpOk = 106)
function ProtocolProcessorGlobal:parse_BATTLE_ThumbUpOk(playerId, playerName, targetPlayerId, targetPlayerName)
    -- playerId : 点赞玩家
    -- playerName : 点赞玩家名
    -- targetPlayerId : 被点赞玩家
    -- targetPlayerName : 被点赞玩家名
    WZLog("ProtocolProcessorGlobal:parse_BATTLE_ThumbUpOk")

    if playerId == CacheCenter:getPlayerInfo().id then
        MsgBoxManager:showTipBox(string.format(LocalStrings.PVPGOOD_TEXT1, targetPlayerName))
        WndArenaWinNew:thumbUpOk(playerId, playerName, targetPlayerId, targetPlayerName)
        return
    elseif targetPlayerId == CacheCenter:getPlayerInfo().id then 
        MsgBoxManager:showTipBox(string.format(LocalStrings.PVPGOOD_TEXT2, playerName))
        return
    end
end

----@brief	获取日常副本信息成功
--function ProtocolProcessorGlobal:parse_SINGLEMAP_GetDailyMapOk(mapId, passTime, isOpen, resetTimes)
--	-- mapId : 副本Id
--	-- passTime : 已挑战次数
--	-- isOpen : 是否开启
--	-- resetTimes : 已重置次数
--	WZLog("ProtocolProcessorGlobal:parse_SINGLEMAP_GetDailyMapOk")
--    CacheCenter:setDailyCopyData(VectorToTable(mapId), VectorToTable(passTime), VectorToTable(isOpen), VectorToTable(resetTimes))
--end
--@brief  助战成功（BOSSMAPROOM_AssistOk = 36）
function ProtocolProcessorGlobal:parse_BOSSMAPROOM_AssistOk(message)
    -- message : 消息内容
    WZLog("ProtocolProcessorGlobal:parse_BOSSMAPROOM_AssistOk", message)
    g_sAssistMessage = message
end

--@brief  聊天举报结果（CHAT_ChatReportOk = 19）
function ProtocolProcessorGlobal:parse_CHAT_ChatReportOk(result)
    -- result : 举报结果0->成功；其他失败
    WZLog("ProtocolProcessorGlobal:parse_CHAT_ChatReportOk", result)
    
    if result == 0 then 
        MsgBoxManager:showTipBox(LocalStrings.CHAT_REPORT_TEXT1)

        WndChatReport:closeReportWin()
    elseif result >=1 and result <= 4 then 
        MsgBoxManager:showTipBox(LocalStrings.CHAT_REPORT_TEXT8[result])
    else
        MsgBoxManager:showTipBox(LocalStrings.CHAT_REPORT_TEXT8[5])
    end
end

--@brief    获取双人爬塔副本信息（BOSSMAPROOMP_GetTwoTowerInfoOk = 45）
function ProtocolProcessorGlobal:parse_BOSSMAPROOMP_GetTwoTowerInfoOk(topFloor, nowFloor, dareTimes, helpTimes, state, remainTime, factor, mapId, buyTimesNum)
    -- topFloor : 最高记录层数
    -- nowFloor : 当前层数
    -- dareTimes : 本层挑战次数
    -- helpTimes : 当天助战次数
    -- state : 扫荡状态 0：未开始，1进行中
    -- remainTime : 剩余秒数
    -- factor : 通关条件状态1位条件一，2位条件二，3位条件三
    -- mapId : 副本id
    -- buyTimesNum : 购买挑战次数的次数
    WZLog("ProtocolProcessorSingleMap:parse_BOSSMAPROOMP_GetTwoTowerInfoOk")
    SceneCopy:closeLoading()
    local timeStruct = os.date("*t",os.time())
    local timeStr = string.format("%d%d%02d",timeStruct.year,timeStruct.month,timeStruct.day)

    local floorState = {}
    local tempMapId = VectorToTable(mapId)
    local tempFactor = VectorToTable(factor)
    for j, value in pairs(GDatatab_grouptower_map) do
        floorState[value.floor_num] = 0
    end
    for i = 1, #tempMapId do
        local value = GDatatab_grouptower_map["id_" .. tempMapId[i]]
        if value then 
            floorState[value.floor_num] = tempFactor[i]
        end
    end
    local data = {topFloor = topFloor, nowFloor = nowFloor ,dareTimes = dareTimes, helpTimes = helpTimes, state = state, remainTime = remainTime, timeStr = timeStr, floorState = floorState, buyTimesNum = buyTimesNum}

    CacheCenter:setDoubleTowerCopyData(data)
end

--@brief  开启调研（PLAYER_OpenInvestigate = 114）
function ProtocolProcessorGlobal:parse_PLAYER_OpenInvestigate()
    WZLog("ProtocolProcessorGlobal:parse_PLAYER_OpenInvestigate")
    
    GlobalGame.g_questionOpen = true
    WndOwnCity:openQuestion(GlobalGame.g_questionOpen)
end

--@brief    错误提示语PLAYER2_Tips = 5
function ProtocolProcessorGlobal:parse_PLAYER2_Tips(code, tips)
    -- code : 错误提示语
    -- tips : 提示语内容
    WZLog("ProtocolProcessorGlobal:parse_PLAYER2_Tips", tips)
    MsgBoxManager:showTipBox(tips, nil, nil, nil, nil, nil, nil, nil, true)
end

function ProtocolProcessorGlobal:parse_ACTIVITY2_ActivityDoOk(activityId, activityType, doType, result, json)
    if activityType and activityType == 7014 then
        GlobalGame.g_autoReturnActivity = true
    end
end
--@brief    活动结束主动推送 165.1+（ACTIVITY2_ActivityClose = 110）
function ProtocolProcessorGlobal:parse_ACTIVITY2_ActivityClose(activityTypes)
    -- activityTypes : 结束的活动类型
    WZLog("ProtocolProcessorGlobal:parse_ACTIVITY2_ActivityClose")
    local types = VectorToTable(activityTypes)
    for i,v in pairs(types) do
        if v == 7028 then --弹珠
            WindowManager:removeWindow(WndPelletMain.m_root, WndPelletMain, true)
            WindowManager:removeWindow(WndPelletGift.m_root, WndPelletGift, true)
            WindowManager:removeWindow(WndPelletChip.m_root, WndPelletChip, true)
            WindowManager:removeWindow(WndDollMachineTask.m_root, WndDollMachineTask, true)
            WindowManager:removeWindow(WndFourStarRank.m_root, WndFourStarRank, true)
        end
    end
end
--@brief    玩家行为通知，服务端需要进行一些校验（PLAYER2_ActToOther = 39）
function ProtocolProcessorGlobal:send_PLAYER2_ActToOther(actType, toPlayerId, paramInt1)
    WZLog("send_PLAYER2_ActToOther")
    local sender = Protocol:getSender( Protocol.MAIN_PLAYER2, Protocol.PLAYER2_ActToOther )
    if sender==nil then WZLog("sender == nil") return end

    paramInt1 = paramInt1 or 0
    sender:writeInt(actType)    -- 动作类型 1师徒邀请拒绝通知
    sender:writeInt(tonumber(toPlayerId)) -- 通知给谁
    sender:writeInt(tonumber(paramInt1))  -- 自定义参数1，没有的话发0
    SendProtocol(sender,false) --true:showLoading
end
--@brief    玩家行为通知，不返回给发送人了，直接推到目标玩家（PLAYER2_ActToDo = 40）
function ProtocolProcessorGlobal:parse_PLAYER2_ActToDo(actType, fromPlayerId, fromPlayerName, paramInt1)
    -- actType : 动作类型 1师徒拒绝通知
    -- fromPlayerId : 通知来自谁
    -- fromPlayerName : 通知来自谁
    -- paramInt1 : 自定义参数1
    WZLog("ProtocolProcessorGlobal:parse_PLAYER2_ActToDo")
    if actType == 1 then
        local info = CacheCenter:getPlayerInfo() 
        if info then
            local str = ""
            if info.masterId == fromPlayerId then
                str = LocalStrings.MASTER
            else
                str = LocalStrings.APPRENTICE
            end
            MsgBoxManager:showTipBox(string.format(LocalStrings.OPTIMIZE_TEXT92, str, fromPlayerName))
        end
    end
end
--@brief    玩家行为通知（PLAYER2_ActToOtherOk = 41）
function ProtocolProcessorGlobal:parse_PLAYER2_ActToOtherOk()
    WZLog("ProtocolProcessorGlobal:parse_PLAYER2_ActToOtherOk")
end



--@brief    岛主复仇通知（MAP_SendLandlordNotify = 61）
function ProtocolProcessorGlobal:parse_MAP_SendLandlordNotify(mapId, createTime, leaveTime, reward, playerNum, playerId, serverId, name, sex, vipLevel, headId, headColor, faceId, fight)
    -- mapId : 副本id
    -- createTime : 创建时间
    -- leaveTime : 剩余时间
    -- reward : 损失奖励
    -- playerNum : 玩家数量
    -- playerId : 玩家id
    -- serverId : 服务器id
    -- name : 玩家名字
    -- sex : 姓别
    -- vipLevel : vip等级
    -- headId : 头id
    -- headColor : 头颜色
    -- faceId : 脸id
    -- fight : 战力
    WZLog("ProtocolProcessorGlobal:parse_MAP_SendLandlordNotify",
        "\nmapId =",Serialize(VectorToTable(mapId)),
        "\ncreateTime =",Serialize(VectorToTable(createTime)),
        "\nleaveTime =",Serialize(VectorToTable(leaveTime)),
        "\nreward =",Serialize(VectorToTable(reward)),
        "\nplayerNum =",Serialize(VectorToTable(playerNum)),
        "\nplayerId =",Serialize(VectorToTable(playerId)),
        "\nserverId =",Serialize(VectorToTable(serverId)),
        "\nname =",Serialize(VectorToTable(name)),
        "\nsex =",Serialize(VectorToTable(sex)),
        "\nvipLevel =",Serialize(VectorToTable(vipLevel)),
        "\nheadId =",Serialize(VectorToTable(headId)),
        "\nheadColor =",Serialize(VectorToTable(headColor)),
        "\nfaceId =",Serialize(VectorToTable(faceId)),
        "\nfight =",Serialize(VectorToTable(fight))
    )

    CacheCenter:setIslandOwnerData(VectorToTable(mapId),VectorToTable(createTime),VectorToTable(leaveTime),VectorToTable(reward),VectorToTable(playerNum),VectorToTable(playerId),VectorToTable(serverId),VectorToTable(name),VectorToTable(sex),VectorToTable(vipLevel),VectorToTable(headId),VectorToTable(headColor),VectorToTable(faceId),VectorToTable(fight))

    if SceneCity.m_tWndBottomBar then
        SceneCity.m_tWndBottomBarObj:updateIslandOwnerBtn()
    end
    
end

--@brief    获取岛主副本红点（MAP_LandlordRedDot = 63）
function ProtocolProcessorGlobal:parse_MAP_LandlordRedDot(mapId)
    -- mapId : 副本id
    WZLog("ProtocolProcessorGlobal:parse_MAP_LandlordRedDot",Serialize(VectorToTable(mapId)))

    CacheCenter:setIslandOwnerRedData(VectorToTable(mapId))
end

--@brief    发红包返回（CHAT_SendRedEnvelopeOk = 22）
function ProtocolProcessorGlobal:parse_CHAT_SendRedEnvelopeOk(result, channelId)
    -- result : 发红包结果：0、发送成功，1、钱不够，2、今日发红包次数用完了
    -- channelId : 0-世界，1-公会
    WZLog("ProtocolProcessorGlobal:parse_CHAT_SendRedEnvelopeOk")
    if result == 0 then 
        WndChallengeLevel:closeWin()
    elseif result == 2 then 
        MsgBoxManager:showTipBox(LocalStrings.RED_PACK8)
    end
end

--@brief    红包信息（CHAT_GetRedEnvelopeInfoOk = 28）
function ProtocolProcessorGlobal:parse_CHAT_GetRedEnvelopeInfoOk(sendRedEnvDailyCount, channelId)
    -- sendRedEnvDailyCount : 今日剩余发红包次数
    -- channelId : 0-世界，1-公会
    WZLog("ProtocolProcessorGlobal:parse_CHAT_GetRedEnvelopeInfoOk", sendRedEnvDailyCount, channelId)
    WndChallengeLevel:getRadPackData(1, sendRedEnvDailyCount, nil, nil, channelId)
end

--@brief    抢红包结果（CHAT_GrabRedEnvelopeOk = 24）
function ProtocolProcessorGlobal:parse_CHAT_GrabRedEnvelopeOk(moneyType, money, playerName, result, wishWorldsId, faceId, headId, headColor, profileFrame, sex, vipLevel, playerId, coverId, channelId)
    -- moneyType : 1、蓝钻,70、礼钻
    -- money : 红包金额
    -- playerName : 发红包玩家的昵称
    -- result : 抢红包结果，0、成功,1、手慢了,2、已经抢过了
    -- wishWorldsId : 祝福话语id
    -- faceId : 脸id
    -- headId : 头id
    -- headColor : 头颜色
    -- profileFrame : 头像框
    -- sex : 
    -- vipLevel : 
    -- playerId : 
    -- coverId : 红包皮肤
    -- channelId : 0-世界，1-公会
    WZLog("ProtocolProcessorGlobal:parse_CHAT_GrabRedEnvelopeOk", 
        "\n moneyType =",Serialize(VectorToTable(moneyType)), 
        "\n money =",Serialize(VectorToTable(money)), 
        "\n playerName =",Serialize(VectorToTable(playerName)), 
        "\n result =",Serialize(VectorToTable(result)), 
        "\n wishWorldsId =",Serialize(VectorToTable(wishWorldsId)), 
        "\n faceId =",Serialize(VectorToTable(faceId)), 
        "\n headId =",Serialize(VectorToTable(headId)), 
        "\n headColor =",Serialize(VectorToTable(headColor)), 
        "\n profileFrame =",Serialize(VectorToTable(profileFrame)), 
        "\n sex =",Serialize(VectorToTable(sex)), 
        "\n vipLevel =",Serialize(VectorToTable(vipLevel)), 
        "\n playerId =",Serialize(VectorToTable(playerId)), 
        "\n coverId =",Serialize(VectorToTable(coverId)), 
        "\n channelId =",Serialize(VectorToTable(channelId)))
    local tData = {}
    tData.playerId = playerId
    tData.playerName = playerName
    tData.wishWorldsId = wishWorldsId
    tData.faceId = faceId
    tData.headId = headId
    tData.headColor = headColor
    tData.headEffectId = profileFrame
    tData.sex = sex
    tData.vipLevel = vipLevel
    tData.itemId = moneyType
    tData.itemNum = money
    tData.redpackSkinId = coverId or 0
    WndChallengeLevel:getRadPackData(2, 0, result, tData, channelId)
end

--@brief    等级突破【167新增】（PLAYER2_LevelBreachOk = 43）
function ProtocolProcessorGlobal:parse_PLAYER2_LevelBreachOk(result, levelBreachId, maxLevel)
    -- result : 等级突破结果【0=成功|1=功能未开放|2=货币不足】
    -- levelBreachId : 新突破等级ID
    -- maxLevel : 玩家等级上限
    WZLog("ProtocolProcessorGlobal:parse_PLAYER2_LevelBreachOk")

    WndServersSure:breakResult(result, levelBreachId, maxLevel)
end

--@brief    聊天屏蔽（CHAT_ChatShieldOk = 35）
function ProtocolProcessorGlobal:parse_CHAT_ChatShieldOk()
    WZLog("ProtocolProcessorGlobal:parse_CHAT_ChatShieldOk")
end

--@brief    被邀请加入联盟（LEAGUE_BeInvite = 35）
function ProtocolProcessorGlobal:parse_LEAGUE_BeInvite(senderId, senderName, leagueId, leagueName, beInvitePid)
    -- senderId : 邀请人ID
    -- senderName : 邀请人昵称
    -- leagueId : 邀请人所在联盟ID
    -- leagueName : 邀请人所在联盟名称
    -- beInvitePid : 被邀请人ID
    WZLog("ProtocolProcessorGlobal:parse_LEAGUE_BeInvite")
    WndUnionHall.inviteId = leagueId
    WndUnionHall.inviteLeagueName = leagueName
    WndInvited:showInterface(WndUnionHall, WndUnionHall.onAcceptInvite, nil, nil,nil, string.format(LocalStrings.UNION_TEXT2[6], senderName, leagueName))
end

--@brief    回复入盟邀请OK（LEAGUE_ResponseInviteOk = 37）
function ProtocolProcessorGlobal:parse_LEAGUE_ResponseInviteOk()
    WZLog("ProtocolProcessorGlobal:parse_LEAGUE_ResponseInviteOk")
    WndUnionList:showInterface("hall")
end
------------------------------------------错误协议--------------------------------------------------
--@brief	获取关卡信息错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorGlobal:send_SINGLEMAP_GetPoints_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorGlobal:send_SINGLEMAP_GetPoints_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_GetPoints, nflag, sMessage)
end

--@brief	获得副本列表错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorGlobal:send_BOSSMAPROOM_GetBossMapList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorGlobal:send_BOSSMAPROOM_GetBossMapList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_GetBossMapList, nflag, sMessage)
end

----@brief	获取日常副本信息错误处理函数(S->C)
----@param	nFlag:标志位
----@param	sMessage:错误信息
----@note	在此对协议错误进行相应处理
--function ProtocolProcessorGlobal:send_SINGLEMAP_GetDailyMap_ErrorProcess(nFlag, sMessage)
--	WZLog("ProtocolProcessorGlobal:send_SINGLEMAP_GetDailyMap_ErrorProcess")
--	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_GetDailyMap, nflag, sMessage)
--end

--@brief	参加婚礼（WEDDING_JoinWedding = 22）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorGlobal:send_WEDDING_JoinWedding_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorGlobal:send_WEDDING_JoinWedding_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WEDDING_JoinWedding, nflag, sMessage)
	MsgBoxManager:showTipBox(sMessage)
end

--@brief	查找房间（ROOM_SelectRoom = 14）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorGlobal:send_ROOM_SelectRoom_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorGlobal:send_ROOM_SelectRoom_ErrorProcess",sMessage)
	if WndMultiCopy.m_root then
		WndMultiCopy:closeLoadingBox()
	end

	if SceneHall.m_root then
		SceneHall:receiveSelectRoomFail()
	end
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ROOM, Protocol.ROOM_SelectRoom, nflag, sMessage)
end

--@brief	获取语音聊天协议Token错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorGlobal:send_CHAT_GetIMToken_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorGlobal:send_CHAT_GetIMToken_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_CHAT, Protocol.CHAT_GetIMToken, nflag, sMessage)
end

--@brief	聊天室列表（CHAT_GetRoomList = 7）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorGlobal:send_CHAT_GetRoomList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorGlobal:send_CHAT_GetRoomList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_CHAT, Protocol.CHAT_GetRoomList , nflag, sMessage)
end

--@brief	通知全服有人结婚（WEDDING_NoticeOnlinePlayer = 56）
function ProtocolProcessorGlobal:parse_WEDDING_NoticeOnlinePlayer(marryType)
	-- marryType : 婚礼类型（1：奢华，2：豪华，3：浪漫，4：普通）
	WZLog("ProtocolProcessorGlobal:parse_WEDDING_NoticeOnlinePlayer")
	WndMarryManager:showGlobalWeddingMes(marryType)
end

--@brief     查看战斗记录(BATTLE_Record=56)错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorGlobal:send_BATTLE_Record_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorGlobal:send_BATTLE_Record_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BATTLE, Protocol.BATTLE_Record, nflag, sMessage)
    if WndSingleCopyInfo and WndSingleCopyInfo.m_root then
    	WndSingleCopyInfo:resetLoadingTag()
    end
end

--@brief	同步战斗信息错误处理错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorGlobal:send_BATTLE_SynchronousBattleInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorGlobal:send_BATTLE_SynchronousBattleInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BATTLE, Protocol.BATTLE_SynchronousBattleInfo, nflag, "")

	MsgBoxManager:showConfirmBox(sMessage, SceneBattle, SceneBattle.leftBattle, MSGBOXLEVEL_HIGH, nil, true)
end

--@brief	同步战斗信息错误处理错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorGlobal:send_BOSSMAPBATTLE_SynchronousBattleInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorGlobal:send_BATTLE_SynchronousBattleInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPBATTLE, Protocol.BOSSMAPBATTLE_SynchronousBattleInfo, nflag, "")

	MsgBoxManager:showConfirmBox(sMessage, SceneBattle, SceneBattle.leftBattle, MSGBOXLEVEL_HIGH, nil, true)
end

--@brief	发送完成引导（PLAYER_FinishComment = 88）错误处理(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorGlobal:send_PLAYER_FinishComment_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorGlobal:send_PLAYER_FinishComment_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_FinishComment, nflag, sMessage)
end

--@brief	观战开始错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorGlobal:send_PLAYER_Watch_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorGlobal:send_PLAYER_Watch_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_Watch, nflag, sMessage)

	MsgBoxManager:showConfirmBox(sMessage, SceneBattle, SceneBattle.leftBattle, MSGBOXLEVEL_HIGH, nil, true)
end

--@brief	观战同步信息错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorGlobal:send_PLAYER_SynchronousWatch_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorGlobal:send_PLAYER_SynchronousWatch_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_SynchronousWatch, nflag, sMessage)

	MsgBoxManager:showConfirmBox(sMessage, SceneBattle, SceneBattle.leftBattle, MSGBOXLEVEL_HIGH, nil, true)
end

--@brief	获取娱乐赛信息（ROOM_GetFunnyMatchInfo = 97）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorGlobal:send_ROOM_GetFunnyMatchInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorGlobal:send_ROOM_GetFunnyMatchInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ROOM, Protocol.ROOM_GetFunnyMatchInfo, nflag, sMessage)
end

--@brief	发送聊天信息（CHAT_SendMessage = 1）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorGlobal:send_CHAT_SendMessage_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorGlobal:send_CHAT_SendMessage_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.CHAT_SendMessage, Protocol.CHAT_SendMessage, nflag, sMessage)
end

--@brief    获取绝地大逃杀玩法状态错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorGlobal:send_ROOM_GetGreatEscapeStatus_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorGlobal:send_ROOM_GetGreatEscapeStatus_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ROOM, Protocol.ROOM_GetGreatEscapeStatus, nflag, sMessage)
end

--@brief    检测排位赛惩罚剩余时间（ROOM_CheckPwPunish = 103）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorGlobal:send_ROOM_CheckPwPunish_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorGlobal:send_ROOM_CheckPwPunish_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ROOM, Protocol.ROOM_CheckPwPunish, nflag, sMessage)
end


--@brief    激活聊天气泡（CHAT_Activate = 14）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorGlobal:send_CHAT_Activate_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorGlobal:send_CHAT_Activate_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_CHAT, Protocol.CHAT_Activate, nflag, sMessage)
end

--@brief    购买聊天气泡（CHAT_BuyChatBubble = 16）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorGlobal:send_CHAT_BuyChatBubble_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorGlobal:send_CHAT_BuyChatBubble_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_CHAT, Protocol.CHAT_BuyChatBubble, nflag, sMessage)
end

--@brief    点赞BUFF(BATTLE_ThumbUp = 105)错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorGlobal:send_BATTLE_ThumbUp_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorGlobal:send_BATTLE_ThumbUp_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BATTLE, Protocol.BATTLE_ThumbUp, nflag, sMessage)
end

--@brief    聊天举报（CHAT_ChatReport = 18）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorGlobal:send_CHAT_ChatReport_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorGlobal:send_CHAT_ChatReport_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_CHAT, Protocol.CHAT_ChatReport, nflag, sMessage)
end

--@brief    获取双人爬塔副本信息（BOSSMAPROOM_GetTwoTowerInfo = 44）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorGlobal:send_BOSSMAPROOM_GetTwoTowerInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorGlobal:send_BOSSMAPROOM_GetTwoTowerInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_GetTwoTowerInfo, nflag, sMessage)
end

--@brief    记录打开界面（PLAYER2_LogOpenAct = 36）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorGlobal:send_PLAYER2_LogOpenAct_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorGlobal:parse_PLAYER2_LogOpenAct_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER2, Protocol.PLAYER2_LogOpenAct, nflag, sMessage)
end

--@brief    发红包（CHAT_SendRedEnvelope = 21）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorGlobal:send_CHAT_SendRedEnvelope_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorGlobal:parse_CHAT_SendRedEnvelope_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_CHAT, Protocol.CHAT_SendRedEnvelope, nflag, sMessage)
end

--@brief    抢红包（CHAT_GrabRedEnvelope = 23）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorGlobal:send_CHAT_GrabRedEnvelope_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorGlobal:parse_CHAT_GrabRedEnvelope_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_CHAT, Protocol.CHAT_GrabRedEnvelope, nflag, sMessage)
end

--@brief    获取最近发的红包信息（CHAT_GetRedEnvelopeInfo = 27）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorGlobal:send_CHAT_GetRedEnvelopeInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorGlobal:parse_CHAT_GetRedEnvelopeInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_CHAT, Protocol.CHAT_GetRedEnvelopeInfo, nflag, sMessage)
end

--@brief    等级突破【167新增】（PLAYER2_LevelBreach = 42）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorGlobal:send_PLAYER2_LevelBreach_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorGlobal:parse_PLAYER2_LevelBreach_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER2, Protocol.PLAYER2_LevelBreach, nflag, sMessage)
end

--@brief    聊天屏蔽（CHAT_ChatShield = 34）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorGlobal:send_CHAT_ChatShield_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorGlobal:parse_CHAT_ChatShield_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_CHAT, Protocol.CHAT_ChatShield, nflag, sMessage)
end

--@brief   商店评分奖励领取（PLAYER2_ReceivePraiseReward = 50）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorGlobal:send_PLAYER2_ReceivePraiseReward_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorGlobal:send_PLAYER2_ReceivePraiseReward_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER2, Protocol.PLAYER2_ReceivePraiseReward, nflag, sMessage)
end
