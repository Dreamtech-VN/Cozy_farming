--ProtocolProcessorWndFriends.lua
--@brief	好友相关协议
--@date  	2013/12/11
--@author 	xiaoyu_wu
--@note 	好友相关协议


ProtocolProcessorWndFriends = ProtocolProcessorBase:new()

-------------------------------------公有方法模块--------------------------------------

--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorWndFriends:regAll()
	--@brief	发送好友列表（FRIEND_FriendInfoList = 1）
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_FriendInfoList, "ProtocolProcessorWndFriends:parse_FRIEND_FriendInfoList", "vivsvivtvtvivbvtvivivivtvivtvtvtvtvivivivivivivivsvivivivivsvi")
	--@brief	申请添加好友成功（FRIEND_AddFriendOK = 3）
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_AddFriendOK, "ProtocolProcessorWndFriends:parse_FRIEND_AddFriendOK", "vivt")
	--@brief	删除好友对象成功（FRIEND_DeleteFriendOK = 5）
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_DeleteFriendOK, "ProtocolProcessorWndFriends:parse_FRIEND_DeleteFriendOK", "vit")
	--@brief	搜索好友协议（FRIEND_SearchFriendOK = 7）
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_SearchFriendOK, "ProtocolProcessorWndFriends:parse_FRIEND_SearchFriendOK", "i")
	--@brief	审批同意好友协议（FRIEND_ApproveOK = 9）
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_ApproveOK, "ProtocolProcessorWndFriends:parse_FRIEND_ApproveOK", "vivbt")
	--@brief	操作协议（FRIEND_OperationOK = 11）
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_OperationOK, "ProtocolProcessorWndFriends:parse_FRIEND_OperationOK", "vivttvtvi")
	--@brief	好友动态协议（FRIEND_AcceptOK = 13）
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_AcceptOK, "ProtocolProcessorWndFriends:parse_FRIEND_AcceptOK", "vivsvivtvitvivivtvivivivivivivivi")
	--@brief	增加好友协议（FRIEND_AddFriendInfo = 14）
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_AddFriendInfo, "ProtocolProcessorWndFriends:parse_FRIEND_AddFriendInfo", "isittibtiiitittiiii")
	--@brief	在线玩家协议（FRIEND_OnlinePlayerOK = 16）
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_OnlinePlayerOK, "ProtocolProcessorWndFriends:parse_FRIEND_OnlinePlayerOK", "vivsvivivivivtvtvtvivivs")
	--@brief	删除动态协议（FRIEND_DeleteAccept = 12）
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_DeleteAccept, "ProtocolProcessorWndFriends:parse_FRIEND_DeleteAccept", "vi")
	--@brief	获取好友（FRIEND_GetFriendOK = 19）
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_GetFriendOK, "ProtocolProcessorWndFriends:parse_FRIEND_GetFriendOK", "vivsvivtvivivbvivivivtvivivivivivtvitvtvivivivivsvi")
	--@brief	获取领用体力数量（FRIEND_GetVigorNum = 20）
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_GetVigorNum, "ProtocolProcessorWndFriends:parse_FRIEND_GetVigorNum", "t")
	--@brief	更新好友动态赠送时间（FRIEND_UpdateAccept = 21）
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_UpdateAccept, "ProtocolProcessorWndFriends:parse_FRIEND_UpdateAccept", "ii")
	--@brief	上下线协议（FRIEND_IsOnline = 17）
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_IsOnline, "ProtocolProcessorWndFriends:parse_FRIEND_IsOnline", "itiii")
	--@brief	更新好友信息	
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_UpdateFriend, "ProtocolProcessorWndFriends:parse_FRIEND_UpdateFriend", "i")
	--@brief	送好友礼物返回协议（FRIEND_SendGiftOk = 25）
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_SendGiftOk, "ProtocolProcessorWndFriends:parse_FRIEND_SendGiftOk", "ivivt")
	--@brief	设置上线通知（FRIEND_ChangeNotifyOk = 30）
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_ChangeNotifyOk, "ProtocolProcessorWndFriends:parse_FRIEND_ChangeNotifyOk", "")
	--@brief	邀请结果（INVITE_InviteInfoListOk = 10）
	self:regProtocolCallbackFunction( Protocol.MAIN_INVITE, Protocol.INVITE_InviteInfoListOk, "ProtocolProcessorWndFriends:parse_INVITE_InviteInfoListOk", "svivsviviviviviviviviviviviivivi")
	--@brief	填写邀请码结果（INVITE_InviteAwardOk = 12）
	self:regProtocolCallbackFunction( Protocol.MAIN_INVITE, Protocol.INVITE_InviteAwardOk, "ProtocolProcessorWndFriends:parse_INVITE_InviteAwardOk", "ssiiiiiiiiii")
	--@brief	领取奖励结果(INVITE_GetInviteRewardsOk = 14)
	self:regProtocolCallbackFunction( Protocol.MAIN_INVITE, Protocol.INVITE_GetInviteRewardsOk, "ProtocolProcessorWndFriends:parse_INVITE_GetInviteRewardsOk", "ivivii")
	--@brief	更新邀请码任务（INVITE_UpdatePlayerInviteInfoOk = 16）
	self:regProtocolCallbackFunction( Protocol.MAIN_INVITE, Protocol.INVITE_UpdatePlayerInviteInfoOk, "ProtocolProcessorWndFriends:parse_INVITE_UpdatePlayerInviteInfoOk", "vivivivi")
	--@brief	新增邀请码好友（INVITE_InviteFinishTaskOk = 17）
	self:regProtocolCallbackFunction( Protocol.MAIN_INVITE, Protocol.INVITE_InviteFinishTaskOk, "ProtocolProcessorWndFriends:parse_INVITE_InviteFinishTaskOk", "isiiiiiiiii")
	--@brief	申请添加密友成功（FRIEND_AddChumOK = 39）
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_AddChumOK, "ProtocolProcessorWndFriends:parse_FRIEND_AddChumOK", "vivt")
	--@brief	删除密友成功（FRIEND_RemoveChumOK = 41）
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_RemoveChumOK, "ProtocolProcessorWndFriends:parse_FRIEND_RemoveChumOK", "ti")
	--@brief	获取恩爱值协议（FRIEND_CoupleNumOK = 45）
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_CoupleNumOK, "ProtocolProcessorWndFriends:parse_FRIEND_CoupleNumOK", "ii")
	--@brief	审批密友协议（FRIEND_ApproveChumOK = 43）
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_ApproveChumOK, "ProtocolProcessorWndFriends:parse_FRIEND_ApproveChumOK", "titvi")
	--@brief	申请添加双休好友成功（FRIEND_AddShuangXiuOk = 51）
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_AddShuangXiuOk, "ProtocolProcessorWndFriends:parse_FRIEND_AddShuangXiuOk", "it")
	--@brief	审批同意双休密友协议（FRIEND_ApproveShuangXiuOk = 53）
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_ApproveShuangXiuOk, "ProtocolProcessorWndFriends:parse_FRIEND_ApproveShuangXiuOk", "itts")
	--@brief	备注好友成功（FRIEND_RemarkFriendOk = 77）
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_RemarkFriendOk, "ProtocolProcessorWndFriends:parse_FRIEND_RemarkFriendOk", "iis")

	--@brief	获取朋友圈列表（FRIEND_GetFriendCircleOk = 58）
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_GetFriendCircleOk, "ProtocolProcessorWndFriends:parse_FRIEND_GetFriendCircleOk", "vivivivsvivivivivivsvivivsvivivtvsvivivsvivsvivsiisvivsvt")
	--@brief	点赞成功（FRIENTD_LikeFriendCircleOk = 69）
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIENTD_LikeFriendCircleOk, "ProtocolProcessorWndFriends:parse_FRIENTD_LikeFriendCircleOk", "iitvs")
	--@brief	评论成功（FRIENTD_CommentFriendCircleOk = 70）
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIENTD_CommentFriendCircleOk, "ProtocolProcessorWndFriends:parse_FRIENTD_CommentFriendCircleOk", "iisisiis")
	--@brief	操作朋友圈成功（FRIENTD_OFriendCircleOk = 71）
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIENTD_OFriendCircleOk, "ProtocolProcessorWndFriends:parse_FRIENTD_OFriendCircleOk", "iii")
	--@brief	查看心情红点列表（FRIENTD_LookFriendCircleOk = 72）
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIENTD_LookFriendCircleOk, "ProtocolProcessorWndFriends:parse_FRIENTD_LookFriendCircleOk", "vivivsvsvsvivsvivivivivivivs")
	--@brief	查看个人空间朋友圈（FRIENTD_SpaceFriendCircleOk = 73）
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIENTD_SpaceFriendCircleOk, "ProtocolProcessorWndFriends:parse_FRIENTD_SpaceFriendCircleOk", "isvsiiiiii")
	--@brief	成功查询指定空间朋友圈（FRIENTD_GetByIdFriendCircleOk = 74）
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIENTD_GetByIdFriendCircleOk, "ProtocolProcessorWndFriends:parse_FRIENTD_GetByIdFriendCircleOk", "iiisiiiiisiivsvivsvivivivivivivsvivsvivs")
	--@brief	朋友圈异常（FRIENTD_FriendCircleError = 75）
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIENTD_FriendCircleError, "ProtocolProcessorWndFriends:parse_FRIENTD_FriendCircleError", "iii")
	--@brief	获取点赞列表（FRIEND_GetFriendCircleLikesOk = 111）
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_GetFriendCircleLikesOk, "ProtocolProcessorWndFriends:parse_FRIEND_GetFriendCircleLikesOk", "ivivsvtvivivivivivs")
	--@brief	协议号名字（FRIEND_MoodTopOk = 119）
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_MoodTopOk, "ProtocolProcessorWndFriends:parse_FRIEND_MoodTopOk", "i")


	--@brief	发送好友列表（FRIEND_AddFriend = 2）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_AddFriend, "ProtocolProcessorWndFriends:send_FRIEND_AddFriend_ErrorProcess", "is" )
	--@brief	删除好友对象（FRIEND_DeleteFriend = 4）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_DeleteFriend, "ProtocolProcessorWndFriends:send_FRIEND_DeleteFriend_ErrorProcess", "is" )
	--@brief	搜索好友协议（FRIEND_SearchFriend = 6）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_SearchFriend, "ProtocolProcessorWndFriends:send_FRIEND_SearchFriend_ErrorProcess", "is" )
	--@brief	审批好友协议（FRIEND_Approve = 8）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_Approve, "ProtocolProcessorWndFriends:send_FRIEND_Approve_ErrorProcess", "is" )
	--@brief	操作协议（FRIEND_Operation = 10）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_Operation, "ProtocolProcessorWndFriends:send_FRIEND_Operation_ErrorProcess", "is" )
	--@brief	在线玩家协议（FRIEND_OnlinePlayer = 15）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_OnlinePlayer, "ProtocolProcessorWndFriends:send_FRIEND_OnlinePlayer_ErrorProcess", "is" )
	--@brief	获取好友（FRIEND_GetFriend = 18）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_GetFriend, "ProtocolProcessorWndFriends:send_FRIEND_GetFriend_ErrorProcess", "is" )
	--@brief	获得好友列表错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_GetFriendInfoList, "ProtocolProcessorWndFriends:send_FRIEND_GetFriendInfoList_ErrorProcess", "is" )
	--@brief	送礼物协议（FRIEND_SendGift = 24）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_SendGift, "ProtocolProcessorWndFriends:send_FRIEND_SendGift_ErrorProcess", "is" )
	--@brief	获得好友动态（FRIEND_Accept=28）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_Accept, "ProtocolProcessorWndFriends:send_FRIEND_Accept_ErrorProcess", "is" )
	--@brief	设置上线通知（FRIEND_ChangeNotify = 29）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_ChangeNotify, "ProtocolProcessorWndFriends:send_FRIEND_ChangeNotify_ErrorProcess", "is" )
	--@brief	填写邀请码（INVITE_InviteWriteCode = 11）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_INVITE, Protocol.INVITE_InviteWriteCode, "ProtocolProcessorWndFriends:send_INVITE_InviteWriteCode_ErrorProcess", "is" )
	--@brief	领取邀请码奖励（INVITE_GetInviteRewards = 13）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_INVITE, Protocol.INVITE_GetInviteRewards, "ProtocolProcessorWndFriends:send_INVITE_GetInviteRewards_ErrorProcess", "is" )
	--@brief	已经填写邀请码，请求填写的玩家内容（INVITE_requestList = 15）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_INVITE, Protocol.INVITE_requestList, "ProtocolProcessorWndFriends:send_INVITE_requestList_ErrorProcess", "is" )
	--@brief	请求邀请码好友列表(INVITE_RequestInviteInfoList = 9)错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_INVITE, Protocol.INVITE_RequestInviteInfoList, "ProtocolProcessorWndFriends:send_INVITE_RequestInviteInfoList_ErrorProcess", "is" )
	--@brief	申请添加密友（FRIEND_AddChum = 38）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_AddChum, "ProtocolProcessorWndFriends:send_FRIEND_AddChum_ErrorProcess", "is" )
	--@brief	删除密友（FRIEND_RemoveChum = 40）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_RemoveChum, "ProtocolProcessorWndFriends:send_FRIEND_RemoveChum_ErrorProcess", "is" )
	--@brief	审批密友协议（FRIEND_ApproveChum = 42）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_ApproveChum, "ProtocolProcessorWndFriends:send_FRIEND_ApproveChum_ErrorProcess", "is" )
	--@brief	获取恩爱值协议（FRIEND_CoupleNum = 44）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_CoupleNum, "ProtocolProcessorWndFriends:send_FRIEND_CoupleNum_ErrorProcess", "is" )
	--@brief	黑名单操作（FRIENT_BlackListOperate = 46）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIENT_BlackListOperate, "ProtocolProcessorWndFriends:send_FRIENT_BlackListOperate_ErrorProcess", "is" )
	--@brief	黑名单操作（FRIENT_BlackListOperateOk = 47）
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIENT_BlackListOperateOk, "ProtocolProcessorWndFriends:parse_FRIENT_BlackListOperateOk", "ii")
	--@brief	获取黑名单列表（FRIENT_GetBlackList = 48）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIENT_GetBlackList, "ProtocolProcessorWndFriends:send_FRIENT_GetBlackList_ErrorProcess", "is" )
	--@brief	获取黑名单列表（FRIENT_GetBlackListOk = 49）
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIENT_GetBlackListOk, "ProtocolProcessorWndFriends:parse_FRIENT_GetBlackListOk", "vivsvivtvtvivivtvivivi")
	--@brief	申请添加双休好友（FRIEND_AddShuangXiu = 50）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_AddShuangXiu, "ProtocolProcessorWndFriends:send_FRIEND_AddShuangXiu_ErrorProcess", "is" )
	--@brief	审批双修请求（FRIENTD_ApproveShuangXiu = 52）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIENTD_ApproveShuangXiu, "ProtocolProcessorWndFriends:send_FRIENTD_ApproveShuangXiu_ErrorProcess", "is" )

	--@brief	获取朋友圈（FRIENTD_GetFriendCircle = 57）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIENTD_GetFriendCircle, "ProtocolProcessorWndFriends:send_FRIENTD_GetFriendCircle_ErrorProcess", "is" )
	--@brief	发布心情（FRIENTD_AddFriendCircle = 59）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIENTD_AddFriendCircle, "ProtocolProcessorWndFriends:send_FRIENTD_AddFriendCircle_ErrorProcess", "is" )
	--@brief	删除心情（FRIENTD_DelFriendCircle = 60）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIENTD_DelFriendCircle, "ProtocolProcessorWndFriends:send_FRIENTD_DelFriendCircle_ErrorProcess", "is" )
	--@brief	点赞心情（FRIENTD_LikeFriendCircle = 61）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIENTD_LikeFriendCircle, "ProtocolProcessorWndFriends:send_FRIENTD_LikeFriendCircle_ErrorProcess", "is" )
	--@brief	取消点赞（FRIENTD_DelLikeFriendCircle = 62）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIENTD_DelLikeFriendCircle, "ProtocolProcessorWndFriends:send_FRIENTD_DelLikeFriendCircle_ErrorProcess", "is" )
	--@brief	评论心情（FRIENTD_CommentFriendCircle = 63）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIENTD_CommentFriendCircle, "ProtocolProcessorWndFriends:send_FRIENTD_CommentFriendCircle_ErrorProcess", "is" )
	--@brief	删除评论（FRIENTD_DelComment = 64）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIENTD_DelComment, "ProtocolProcessorWndFriends:send_FRIENTD_DelComment_ErrorProcess", "is" )
	--@brief	举报心情（FRIENTD_ReportFriendCircle = 65）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIENTD_ReportFriendCircle, "ProtocolProcessorWndFriends:send_FRIENTD_ReportFriendCircle_ErrorProcess", "is" )
	--@brief	设置心情（FRIENTD_SetFriendCircle = 66）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIENTD_SetFriendCircle, "ProtocolProcessorWndFriends:send_FRIENTD_SetFriendCircle_ErrorProcess", "is" )
	--@brief	查看心情红点列表（FRIENTD_LookFriendCircle = 67）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIENTD_LookFriendCircle, "ProtocolProcessorWndFriends:send_FRIENTD_SetFriendCircle_ErrorProcess", "is" )
	--@brief	查询指定空间朋友圈（FRIENTD_GetByIdFriendCircle = 68）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIENTD_GetByIdFriendCircle, "ProtocolProcessorWndFriends:send_FRIENTD_GetByIdFriendCircle_ErrorProcess", "is" )
	--@brief	备注好友（FRIEND_RemarkFriend = 76）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_RemarkFriend, "ProtocolProcessorWndFriends:send_FRIEND_RemarkFriend_ErrorProcess", "is" )
	--@brief	获取点赞列表（FRIEND_GetFriendCircleLikes = 110）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_GetFriendCircleLikes, "ProtocolProcessorWndFriends:send_FRIEND_GetFriendCircleLikes_ErrorProcess", "is" )
	--@brief	我的心情置顶（FRIEND_MoodTop = 118）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_MoodTop, "ProtocolProcessorWndFriends:send_FRIEND_MoodTop_ErrorProcess", "is")

	--@brief	好友列表：置顶好友（FRIEND_TopFriend = 120）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_TopFriend, "ProtocolProcessorWndFriends:send_FRIEND_TopFriend_ErrorProcess", "is")
	--@brief	好友列表：置顶好友（FRIEND_TopFriendOK = 121）
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_TopFriendOK, "ProtocolProcessorWndFriends:parse_FRIEND_TopFriendOK", "vii")
	--@brief	移动置顶好友（FRIEND_SwapTopFriend = 122）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_SwapTopFriend, "ProtocolProcessorWndFriends:send_FRIEND_SwapTopFriend_ErrorProcess", "is")
	--@brief	移动置顶好友（FRIEND_SwapTopFriendOK = 123）
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_SwapTopFriendOK, "ProtocolProcessorWndFriends:parse_FRIEND_SwapTopFriendOK", "ii")


end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorWndFriends:unregAll()
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块--------------------------------------

--@brief	申请添加好友（FRIEND_AddFriend = 2）
function ProtocolProcessorWndFriends:send_FRIEND_AddFriend(playerId )
	WZLog("send_FRIEND_AddFriend")
	local sender = Protocol:getSender( Protocol.MAIN_FRIEND, Protocol.FRIEND_AddFriend )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInts( playerId )	-- 添加的好友Id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	删除好友对象（FRIEND_DeleteFriend = 4）
function ProtocolProcessorWndFriends:send_FRIEND_DeleteFriend(playerId )
	WZLog("send_FRIEND_DeleteFriend")
	local sender = Protocol:getSender( Protocol.MAIN_FRIEND, Protocol.FRIEND_DeleteFriend )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInts( playerId )	-- 添加的好友Id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	搜索好友协议（FRIEND_SearchFriend = 6）
function ProtocolProcessorWndFriends:send_FRIEND_SearchFriend(playerId, playerName )
	WZLog("send_FRIEND_SearchFriend")
	local sender = Protocol:getSender( Protocol.MAIN_FRIEND, Protocol.FRIEND_SearchFriend )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerId )	-- 玩家Id
	sender:writeString( playerName )	-- 玩家名称
	SendProtocol(sender,false) --true:showLoading
end

--@brief	审批好友协议（FRIEND_Approve = 8）
function ProtocolProcessorWndFriends:send_FRIEND_Approve(playerId, approveType )
	WZLog("send_FRIEND_Approve")
	local sender = Protocol:getSender( Protocol.MAIN_FRIEND, Protocol.FRIEND_Approve )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInts( playerId )	-- 好友Id,
	sender:writeByte( approveType )	-- 1、同意，2、拒绝
	SendProtocol(sender,false) --true:showLoading
end

--@brief	操作协议（FRIEND_Operation = 10）
function ProtocolProcessorWndFriends:send_FRIEND_Operation(playerId, operType )
	WZLog("send_FRIEND_Operation")
	local sender = Protocol:getSender( Protocol.MAIN_FRIEND, Protocol.FRIEND_Operation )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInts( playerId )	-- 好友Id
	sender:writeByte( operType )	-- 1、赠送，2、领取
	SendProtocol(sender,false) --true:showLoading
end

--@brief	在线玩家协议（FRIEND_OnlinePlayer = 15）
function ProtocolProcessorWndFriends:send_FRIEND_OnlinePlayer(sex )
	WZLog("send_FRIEND_OnlinePlayer")
	local sender = Protocol:getSender( Protocol.MAIN_FRIEND, Protocol.FRIEND_OnlinePlayer )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( sex )	-- 0男1女2全部
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取好友（FRIEND_GetFriend = 18）
function ProtocolProcessorWndFriends:send_FRIEND_GetFriend(useType, playerType,topLevel, tiroLevels, numMode)
	WZLog("send_FRIEND_GetFriend ",Serialize(VectorToTable(useType)), Serialize(VectorToTable(playerType)), Serialize(VectorToTable(topLevel)), Serialize(VectorToTable(tiroLevels)))
	if topLevel == nil then
		topLevel = 0
	end
	if tiroLevels == nil then 
		tiroLevels = {}
	end
	local sender = Protocol:getSender( Protocol.MAIN_FRIEND, Protocol.FRIEND_GetFriend )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeByte( useType )	-- "1、发请柬， 2、婚礼邀请 3、战斗邀请 4、邮件邀请 5、异性单身 6、组队副本 7、私聊 8、战队邀请 9、公会战邀请 11、排位赛 12、娱乐赛 15、双修邀请18、岛主挑战 19、夫妻争霸 20战略赛
	sender:writeByte( playerType )	-- 1、好友，2、公会，3、大厅，4、跨服  6:师门
	sender:writeInt( topLevel )	-- 排位赛房间内玩家最高的排位等级
	sender:writeInts( TableToVector(tiroLevels, WZLuaVector_int_) )	-- 排位赛房间内玩家的排位等级
	sender:writeInt( numMode or 0 )	-- 人数模式[177+] 战略赛用到,其他模式默认传0
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获得好友列表
function ProtocolProcessorWndFriends:send_FRIEND_GetFriendInfoList( )
	WZLog("send_FRIEND_GetFriendInfoList")
	local sender = Protocol:getSender( Protocol.MAIN_FRIEND, Protocol.FRIEND_GetFriendInfoList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	送礼物协议（FRIEND_SendGift = 24）
function ProtocolProcessorWndFriends:send_FRIEND_SendGift(playerId, itemId )
	WZLog("send_FRIEND_SendGift")
	local sender = Protocol:getSender( Protocol.MAIN_FRIEND, Protocol.FRIEND_SendGift )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerId )	-- 好友Id
	sender:writeInt( itemId )	-- 赠送礼物Id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获得好友动态（FRIEND_Accept=28）
function ProtocolProcessorWndFriends:send_FRIEND_Accept( )
	WZLog("send_FRIEND_Accept")
	local sender = Protocol:getSender( Protocol.MAIN_FRIEND, Protocol.FRIEND_Accept )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	设置上线通知（FRIEND_ChangeNotify = 29）
function ProtocolProcessorWndFriends:send_FRIEND_ChangeNotify(playerId )
	WZLog("send_FRIEND_ChangeNotify")
	local sender = Protocol:getSender( Protocol.MAIN_FRIEND, Protocol.FRIEND_ChangeNotify )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInts( playerId )	-- 好友Id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	填写邀请码（INVITE_InviteWriteCode = 11）
function ProtocolProcessorWndFriends:send_INVITE_InviteWriteCode(writeCode )
	WZLog("send_INVITE_InviteWriteCode")
	local sender = Protocol:getSender( Protocol.MAIN_INVITE, Protocol.INVITE_InviteWriteCode )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeString( writeCode )	-- 填写的邀请码
	SendProtocol(sender,false) --true:showLoading
end

--@brief	领取邀请码奖励（INVITE_GetInviteRewards = 13）
function ProtocolProcessorWndFriends:send_INVITE_GetInviteRewards(id )
	WZLog("send_INVITE_GetInviteRewards")
	local sender = Protocol:getSender( Protocol.MAIN_INVITE, Protocol.INVITE_GetInviteRewards )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( id )	-- 奖励id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	已经填写邀请码，请求填写的玩家内容（INVITE_requestList = 15）
function ProtocolProcessorWndFriends:send_INVITE_requestList( )
	WZLog("send_INVITE_requestList")
	local sender = Protocol:getSender( Protocol.MAIN_INVITE, Protocol.INVITE_requestList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	请求邀请码好友列表(INVITE_RequestInviteInfoList = 9)
function ProtocolProcessorWndFriends:send_INVITE_RequestInviteInfoList( )
	WZLog("send_INVITE_RequestInviteInfoList")
	local sender = Protocol:getSender( Protocol.MAIN_INVITE, Protocol.INVITE_RequestInviteInfoList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	申请添加密友（FRIEND_AddChum = 38）
function ProtocolProcessorWndFriends:send_FRIEND_AddChum(playerId )
	WZLog("send_FRIEND_AddChum")
	local sender = Protocol:getSender( Protocol.MAIN_FRIEND, Protocol.FRIEND_AddChum )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInts( playerId )	-- 添加的密友Id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	删除密友（FRIEND_RemoveChum = 40）
function ProtocolProcessorWndFriends:send_FRIEND_RemoveChum(playerId )
	WZLog("send_FRIEND_RemoveChum")
	local sender = Protocol:getSender( Protocol.MAIN_FRIEND, Protocol.FRIEND_RemoveChum )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerId )	-- 添加的密友Id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	审批密友协议（FRIEND_ApproveChum = 42）
function ProtocolProcessorWndFriends:send_FRIEND_ApproveChum(playerId, approveType )
	WZLog("send_FRIEND_ApproveChum")
	local sender = Protocol:getSender( Protocol.MAIN_FRIEND, Protocol.FRIEND_ApproveChum )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerId )	-- 好友Id,
	sender:writeByte( approveType )	-- 1、同意，2、拒绝
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取恩爱值协议（FRIEND_CoupleNum = 44）
function ProtocolProcessorWndFriends:send_FRIEND_CoupleNum( )
	WZLog("send_FRIEND_CoupleNum")
	local sender = Protocol:getSender( Protocol.MAIN_FRIEND, Protocol.FRIEND_CoupleNum )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	黑名单操作（FRIENT_BlackListOperate = 46）
function ProtocolProcessorWndFriends:send_FRIENT_BlackListOperate(actionType, targetPlayerId )
	WZLog("send_FRIENT_BlackListOperate")
	local sender = Protocol:getSender( Protocol.MAIN_FRIEND, Protocol.FRIENT_BlackListOperate )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( actionType )	-- 操作类型 0.添加黑名单 1.移除黑名单
	sender:writeInt( targetPlayerId )	-- 目标玩家ID
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取黑名单列表（FRIENT_GetBlackList = 48）
function ProtocolProcessorWndFriends:send_FRIENT_GetBlackList()
	WZLog("send_FRIENT_GetBlackList")
	local sender = Protocol:getSender( Protocol.MAIN_FRIEND, Protocol.FRIENT_GetBlackList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	申请添加双休好友（FRIEND_AddShuangXiu = 50）
function ProtocolProcessorWndFriends:send_FRIEND_AddShuangXiu(playerId)
	WZLog("send_FRIEND_AddShuangXiu")
	local sender = Protocol:getSender( Protocol.MAIN_FRIEND, Protocol.FRIEND_AddShuangXiu )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerId )	-- 添加的好友Id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	审批双修请求（FRIENTD_ApproveShuangXiu = 52）
function ProtocolProcessorWndFriends:send_FRIENTD_ApproveShuangXiu(playerId, opType)
	WZLog("send_FRIENTD_ApproveShuangXiu")
	local sender = Protocol:getSender( Protocol.MAIN_FRIEND, Protocol.FRIENTD_ApproveShuangXiu )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerId )	-- 玩家Id
	sender:writeByte( opType )	-- 1、同意，2、拒绝
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取朋友圈（FRIENTD_GetFriendCircle = 57）
function ProtocolProcessorWndFriends:send_FRIENTD_GetFriendCircle(opType, playerId)
	WZLog("send_FRIENTD_GetFriendCircle")
	local sender = Protocol:getSender( Protocol.MAIN_FRIEND, Protocol.FRIENTD_GetFriendCircle )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( opType )	-- 1我的圈 2好友圈 3热点圈
	sender:writeInt( playerId )	-- 查看指定玩家id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	发布心情（FRIENTD_AddFriendCircle = 59）
function ProtocolProcessorWndFriends:send_FRIENTD_AddFriendCircle(message, SpacePhoto, comment)
	WZLog("send_FRIENTD_AddFriendCircle")
	local sender = Protocol:getSender( Protocol.MAIN_FRIEND, Protocol.FRIENTD_AddFriendCircle )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeString( message )	-- 心情描述
	sender:writeStrings( SpacePhoto )	-- 图片
	sender:writeInt( comment )	-- 陌生人是否开启评论：0开启 1关闭
	SendProtocol(sender,false) --true:showLoading
end

--@brief	删除心情（FRIENTD_DelFriendCircle = 60）
function ProtocolProcessorWndFriends:send_FRIENTD_DelFriendCircle(cId)
	WZLog("send_FRIENTD_DelFriendCircle")
	local sender = Protocol:getSender( Protocol.MAIN_FRIEND, Protocol.FRIENTD_DelFriendCircle )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( cId )	-- 朋友圈Id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	点赞心情（FRIENTD_LikeFriendCircle = 61）
function ProtocolProcessorWndFriends:send_FRIENTD_LikeFriendCircle(cId)
	WZLog("send_FRIENTD_LikeFriendCircle")
	local sender = Protocol:getSender( Protocol.MAIN_FRIEND, Protocol.FRIENTD_LikeFriendCircle )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( cId )	-- 朋友圈Id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	取消点赞（FRIENTD_DelLikeFriendCircle = 62）
function ProtocolProcessorWndFriends:send_FRIENTD_DelLikeFriendCircle(cId)
	WZLog("send_FRIENTD_DelLikeFriendCircle")
	local sender = Protocol:getSender( Protocol.MAIN_FRIEND, Protocol.FRIENTD_DelLikeFriendCircle )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( cId )	-- 朋友圈Id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	评论心情（FRIENTD_CommentFriendCircle = 63）
function ProtocolProcessorWndFriends:send_FRIENTD_CommentFriendCircle(cId, playerId, commentId, message)
	WZLog("send_FRIENTD_CommentFriendCircle")
	local sender = Protocol:getSender( Protocol.MAIN_FRIEND, Protocol.FRIENTD_CommentFriendCircle )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( cId )	-- 朋友圈Id
	sender:writeInt( playerId )	-- 朋友圈所属的玩家Id
	sender:writeInt( commentId )	-- 回复的评论Id（0时则是评论心情）
	sender:writeString( message )	-- 评论内容
	SendProtocol(sender,false) --true:showLoading
end

--@brief	删除评论（FRIENTD_DelComment = 64）
function ProtocolProcessorWndFriends:send_FRIENTD_DelComment(cId, commentId)
	WZLog("send_FRIENTD_DelComment")
	local sender = Protocol:getSender( Protocol.MAIN_FRIEND, Protocol.FRIENTD_DelComment )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( cId )	-- 朋友圈Id
	sender:writeInt( commentId )	-- 评论id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	举报心情（FRIENTD_ReportFriendCircle = 65）
function ProtocolProcessorWndFriends:send_FRIENTD_ReportFriendCircle(cId, rType, message)
	WZLog("send_FRIENTD_ReportFriendCircle")
	local sender = Protocol:getSender( Protocol.MAIN_FRIEND, Protocol.FRIENTD_ReportFriendCircle )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( cId )	-- 朋友圈Id
	sender:writeInts( rType )	-- 举报类型 1色情暴力 2欺诈欺骗 3散播BUG 4商业广告 5盗版侵权 6 其他违规
	sender:writeString( message )	-- 举报信息
	SendProtocol(sender,false) --true:showLoading
end

--@brief	设置心情（FRIENTD_SetFriendCircle = 66）
function ProtocolProcessorWndFriends:send_FRIENTD_SetFriendCircle(cId)
	WZLog("send_FRIENTD_SetFriendCircle")
	local sender = Protocol:getSender( Protocol.MAIN_FRIEND, Protocol.FRIENTD_SetFriendCircle )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( cId )	-- 朋友圈Id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	查看心情红点列表（FRIENTD_LookFriendCircle = 67）
function ProtocolProcessorWndFriends:send_FRIENTD_LookFriendCircle()
	WZLog("send_FRIENTD_LookFriendCircle")
	local sender = Protocol:getSender( Protocol.MAIN_FRIEND, Protocol.FRIENTD_LookFriendCircle )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	查询指定空间朋友圈（FRIENTD_GetByIdFriendCircle = 68）
function ProtocolProcessorWndFriends:send_FRIENTD_GetByIdFriendCircle(cId)
	WZLog("send_FRIENTD_GetByIdFriendCircle")
	local sender = Protocol:getSender( Protocol.MAIN_FRIEND, Protocol.FRIENTD_GetByIdFriendCircle )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( cId )	-- 朋友圈Id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	备注好友（FRIEND_RemarkFriend = 76）
function ProtocolProcessorWndFriends:send_FRIEND_RemarkFriend(friendId, remarkName)
	WZLog("send_FRIEND_RemarkFriend")
	local sender = Protocol:getSender( Protocol.MAIN_FRIEND, Protocol.FRIEND_RemarkFriend)
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( friendId )	-- 好友Id
	sender:writeString( remarkName )	-- 备注名字
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取点赞列表（FRIEND_GetFriendCircleLikes = 110）
function ProtocolProcessorWndFriends:send_FRIEND_GetFriendCircleLikes(cId)
	WZLog("send_FRIEND_GetFriendCircleLikes")
	local sender = Protocol:getSender( Protocol.MAIN_FRIEND, Protocol.FRIEND_GetFriendCircleLikes)
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( cId )	-- 好友Id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	我的心情置顶（FRIEND_MoodTop = 118）
function ProtocolProcessorWndFriends:send_FRIEND_MoodTop(id)
	WZLog("send_FRIEND_MoodTop")
	local sender = Protocol:getSender( Protocol.MAIN_FRIEND, Protocol.FRIEND_MoodTop )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(id)	-- 需要置顶的id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	好有置顶（FRIEND_TopFriend = 120）
function ProtocolProcessorWndFriends:send_FRIEND_TopFriend(playerIds, topType)
	WZLog("send_FRIEND_TopFriend")
	local sender = Protocol:getSender( Protocol.MAIN_FRIEND, Protocol.FRIEND_TopFriend )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInts(playerIds)	-- 选中的好友id
	sender:writeInt(topType)	-- 好友置顶类型： 0 置顶 1: 取消置顶
	SendProtocol(sender,false) --true:showLoading
end

--@brief	移动置顶好友（FRIEND_SwapTopFriend = 122）
function ProtocolProcessorWndFriends:send_FRIEND_SwapTopFriend(playerId, beforePlayerId)
	WZLog("send_FRIEND_SwapTopFriend")
	local sender = Protocol:getSender( Protocol.MAIN_FRIEND, Protocol.FRIEND_SwapTopFriend )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(playerId)	-- 移动好友id
	sender:writeInt(beforePlayerId)	-- 后一个置顶好友id
	SendProtocol(sender,false) --true:showLoading
end


-------------------------------服务器到客户端协议回调方法模块--------------------------------

--@brief	发送好友列表（FRIEND_FriendInfoList = 1）
function ProtocolProcessorWndFriends:parse_FRIEND_FriendInfoList(playerId, playerName, level, sex, online, fighting, send, friendType, faceItemId, headItemId,appTimer,isMentoring,friendNum, sendGift, couple, loginNotify, vipLevel, offlineTime, headColor, serverId, chum, applychum, mentoringNum, spaceVisitState, remarkName, bodyId, wingId, bodyColor, headEffectId, qqHallInfo, topFriendIds)
	-- playerId : 好友Id
	-- playerName : 好友名称
	-- level : 好友等级
	-- sex : 好友性别，0是男，1是女
	-- online : 好友是否在线
	-- fighting : 玩家战斗力
	-- send : 是否可赠送
	-- friendType : 好友类型1、正式好友，2、等待审批
	-- faceItemId : 脸道具id,没有为0
	-- headItemId : 头道具id，没有为0
    -- isMentoring:是否师徒(0为没有关系，1为师父，2为徒弟)
    -- sendGift : 是否可赠送礼物（1为可以，0为不可以）
    -- friendNum :好友度
    -- couple ：是否夫妻关系
    -- loginNotify : 上线是否需要通知
    -- vipLevel : vip等级
    -- offlineTime : 离线时刻
    -- headColor : 头的颜色
    -- serverId : 所在服务器Id
    -- chum : 是否密友（1为是密友，0为不是）
    -- applychum : 请求加为密友Id
    -- mentoringNum : 师德等级
    -- spaceVisitState : 访问好友空间的状态：1->访问过；0->未访问
    -- remarkName : 备注名字
    -- headEffectId : 玩家头像特效Id
    -- qqHallInfo : 玩家qq大厅蓝钻信息
    -- topFriendIds : [186+] 置顶好友顺序[非在线排序]
	WZLog("ProtocolProcessorWndFriends:parse_FRIEND_FriendInfoList", 
		"\n playerId =",TableToString(VectorToTable(playerId)),
		"\n playerName =",TableToString(VectorToTable(playerName)),
		"\n level =",TableToString(VectorToTable(level)),
		"\n sex =",TableToString(VectorToTable(sex)),
		"\n online =",TableToString(VectorToTable(online)),
		"\n fighting =",TableToString(VectorToTable(fighting)),
		"\n send =",TableToString(VectorToTable(send)),
		"\n friendType =",TableToString(VectorToTable(friendType)),
		"\n faceItemId =",TableToString(VectorToTable(faceItemId)),
		"\n headItemId =",TableToString(VectorToTable(headItemId)),
		"\n appTimer =",TableToString(VectorToTable(appTimer)),
		"\n isMentoring =",TableToString(VectorToTable(isMentoring)),
		"\n friendNum =",TableToString(VectorToTable(friendNum)),
		"\n sendGift =",TableToString(VectorToTable(sendGift)),
		"\n couple =",TableToString(VectorToTable(couple)),
		"\n loginNotify =",TableToString(VectorToTable(loginNotify)),
		"\n vipLevel =",TableToString(VectorToTable(vipLevel)),
		"\n offlineTime =",TableToString(VectorToTable(offlineTime)),
		"\n headColor =",TableToString(VectorToTable(headColor)),
		"\n serverId =",TableToString(VectorToTable(serverId)),
		"\n chum =",TableToString(VectorToTable(chum)),
		"\n applychum =",TableToString(VectorToTable(applychum)),
		"\n mentoringNum =",TableToString(VectorToTable(mentoringNum)),
		"\n spaceVisitState =",TableToString(VectorToTable(spaceVisitState)),
		"\n remarkName =",TableToString(VectorToTable(remarkName)),
		"\n bodyId =",TableToString(VectorToTable(bodyId)),
		"\n wingId =",TableToString(VectorToTable(wingId)),
		"\n bodyColor =",TableToString(VectorToTable(bodyColor)),
		"\n headEffectId =",TableToString(VectorToTable(headEffectId)),
		"\n qqHallInfo =",TableToString(VectorToTable(qqHallInfo)),
		"\n topFriendIds =",TableToString(VectorToTable(topFriendIds))
	)
	CacheCenter:setFriendList(playerId, playerName, level, sex, online, fighting, send, friendType, faceItemId, headItemId,appTimer,isMentoring, sendGift, couple, friendNum, loginNotify, vipLevel, offlineTime, serverId, headColor, chum, applychum, mentoringNum, spaceVisitState, remarkName, bodyId, wingId, bodyColor, headEffectId, qqHallInfo, topFriendIds)
end

--@brief	申请添加好友成功（FRIEND_AddFriendOK = 3）
function ProtocolProcessorWndFriends:parse_FRIEND_AddFriendOK(playerId, result)
	-- playerId : 添加的好友Id
	-- result : 添加好友结果，1成功，2到达对方审批上限
	WZLog("ProtocolProcessorWndFriends:parse_FRIEND_AddFriendOK")
	WndFriends:closeLoading()
--	WndFriends:WndAddFriendSuc()
    NotificationCenter:sendNotification("parse_FRIEND_AddFriendOK", {playerId=VectorToTable(playerId), result=VectorToTable(result)})
	WndFriends:addFriendsSuccess( VectorToTable(playerId) )
	
    local count = result:size()
	local suc = LocalStrings.APPFRIEND..LocalStrings.SUCCESS
	local fail = LocalStrings.APPFRIEND..LocalStrings.FAIL
	local num = 0 
	if count == 1 then
		if result:get(0) == 1 or result:get(0) == true then
			MsgBoxManager:showTipBox(LocalStrings.FRIEND_SUC)
			WndCheckOther:operateBlacklistOK(1, playerId:get(0))
			return 
		end
		if CacheCenter:getFriendList() == nil or #CacheCenter:getFriendList() == 0 then
			MsgBoxManager:showTipBox(LocalStrings.FRIEND_WAIT)
			return
		end
		for i,data in pairs(CacheCenter:getFriendList()) do 
			if data.type == 1 then
				num = num + 1 
			end
			local k=0,count-1 do 
				if data.id == playerId:get(k) and data.type==1 then--"该玩家和你已经是好友了"
					MsgBoxManager:showTipBox(LocalStrings.FRIEND_EXIST)
					return
				end
			end
		end
		local nMaxFriendsNum = GetMaxFriends(CacheCenter:getPlayerInfo().vipLevel)
		if num >= tonumber(nMaxFriendsNum) then
			MsgBoxManager:showTipBox(LocalStrings.FRIEND_MAX)
			return--"自己好友上限已满"
		end
		MsgBoxManager:showTipBox(LocalStrings.FRIEND_WAIT)
		return
	end
	MsgBoxManager:showTipBox(LocalStrings.FRIEND_SUC)	
end

--@brief	删除好友对象成功（FRIEND_DeleteFriendOK = 5）
function ProtocolProcessorWndFriends:parse_FRIEND_DeleteFriendOK(playerId,result)
	WZLog("ProtocolProcessorWndFriends:parse_FRIEND_DeleteFriendOK",result)
	CacheCenter:delFriendList(playerId)
	if result == 1 then
		local desc = LocalStrings.DELFRIEND..LocalStrings.SUCCESS
		MsgBoxManager:showTipBox(desc)
	end
end

--@brief	搜索好友协议（FRIEND_SearchFriendOK = 7）
function ProtocolProcessorWndFriends:parse_FRIEND_SearchFriendOK(playerId)
	-- playerId : 好友Id
	WZLog("ProtocolProcessorWndFriends:parse_FRIEND_SearchFriendOK")
	WndFriends:onFindSuc(playerId)
end

--@brief	审批同意好友协议（FRIEND_ApproveOK = 9）
function ProtocolProcessorWndFriends:parse_FRIEND_ApproveOK(playerId,result,nType)
	-- playerId : 好友Id
	-- result : true:1成功，false:0失败
	WZLog("ProtocolProcessorWndFriends:parse_FRIEND_ApproveOK",nType)
	CacheCenter:ApprovalFriendResult(playerId, result,nType)

	local count = playerId:size()
	if nType == 1 then--同意
		if count == 1 then
			if result:get(0) == 0 or result:get(0) == false then 
				MsgBoxManager:showTipBox(LocalStrings.FRIEND_OTHERMAX)--"目标的好友数量已满"
			 else 				
				MsgBoxManager:showTipBox(LocalStrings.FRIEND_APPSUC)--审批操作成功
			end
			return
		end
		MsgBoxManager:showTipBox(LocalStrings.FRIEND_APPSUC)--"审批操作成功"
		return
	end
	if nType == 2 then 
		MsgBoxManager:showTipBox(LocalStrings.FRIEND_REFUSESUC)--拒绝操作成功
	end
end

--@brief	操作协议（FRIEND_OperationOK = 11）
function ProtocolProcessorWndFriends:parse_FRIEND_OperationOK(playerId, acceptType,vigorNum, sendType, friendNum)
	-- playerId : 好友Id
	-- acceptType : 状态1、可领取，2、可回馈，3、已回馈
	-- sendType : 状态1、可回馈，0为没有改选项
	-- freindNum : 好友度
	WZLog("ProtocolProcessorWndFriends:parse_FRIEND_OperationOK")
	CacheCenter:OperationFriendOK(playerId, acceptType,vigorNum, sendType, friendNum)
end

--@brief	删除动态协议（FRIEND_DeleteAccept = 12）
function ProtocolProcessorWndFriends:parse_FRIEND_DeleteAccept(playerId)
	-- playerId : 玩家id
	WZLog("ProtocolProcessorWndFriends:parse_FRIEND_DeleteAccept")
	CacheCenter:delDynamicFriendList(playerId)
end

--@brief	好友动态协议（FRIEND_AcceptOK = 13）
function ProtocolProcessorWndFriends:parse_FRIEND_AcceptOK(playerId, playerName, date, acceptType, vigor, vigorNum, friendNum, typeList, sendType, id, faceItemId, headItemId, sex, headColor, isOnline, vipLevel, headEffectId)
	-- playerId : 玩家id
	-- playerName : 玩家名称
	-- typeList : 类型（1为被赠送活力，2为被赠送礼物，3为同阵营战斗，4为好友申请，5为赠送礼物，6为赠送活力）
	-- date : 时间（秒）
	-- acceptType : 状态1、可领取，2、可回馈，3、已回馈，0为没有改选项
	-- vigor : 赠送的活力值
	-- friendNum : 增加好友度
	-- vigorNum : 领用体力数量
	-- headEffectId : 玩家头像特效Id
	WZLog("ProtocolProcessorWndFriends:parse_FRIEND_AcceptOK")
	CacheCenter:setDynamicFriendList(playerId, playerName, typeList, date, acceptType, sendType, vigor, friendNum, vigorNum, id, faceItemId,headItemId, sex, headColor, isOnline, vipLevel, headEffectId)
end

--@brief	增加好友协议（FRIEND_AddFriendInfo = 14）
function ProtocolProcessorWndFriends:parse_FRIEND_AddFriendInfo(playerId, playerName, level, sex, online, fighting, send, friendType, faceItemId, headItemId, applyDate, isMentoring, friendNum, sendGift, vipLevel, headColor, serverId, mentoringNum, headEffectId)
	-- playerId : 好友Id
	-- playerName : 好友名称
	-- level : 好友等级
	-- sex : 好友性别，0是男，1是女
	-- online : 1、在线，0、离线
	-- fighting : 玩家战斗力
	-- send : 是否可赠送
	-- friendType : 好友类型1、正式好友，2、等待审批
	-- faceItemId : 脸道具id, 不存在为0
	-- headItemId : 头道具id, 不存在为0
	-- applyDate : 申请时间（毫秒）
	-- isMentoring : 是否师徒关系true 是存在关系，false 不存在关系
	-- friendNum : 好友度
	-- sendGift : 是否可赠送礼物（1为可以，0为不可以）
	-- vipLevel : vip等级
	-- headColor : 头的颜色索引
	-- serverId : 所在服务器Id
	-- headEffectId : 头像特效Id
	WZLog("ProtocolProcessorWndFriends:parse_FRIEND_AddFriendInfo")
	CacheCenter:addFriendList(playerId, playerName, level, sex, online, fighting, send, friendType, faceItemId, headItemId,appTimer, isMentoring, friendNum, sendGift, vipLevel, serverId, headColor, mentoringNum, headEffectId)
	if friendType == 2 then 
		if WndFriends.m_root ~= nil then
			WndFriends:RefreshInterface(1,nil)
		end 
	end 
end


--@brief	在线玩家协议（FRIEND_OnlinePlayerOK = 16）
function ProtocolProcessorWndFriends:parse_FRIEND_OnlinePlayerOK(playerId, playerName, level, fighting, headId, faceId, sex, online, vipLevel, headColor, headEffectId, qqHallInfo)
	-- playerId : 玩家id
	-- playerName : 玩家名称
	-- level : 玩家等级
	-- fighting : 战斗力
	-- headId : 头id
	-- faceId : 脸id
	-- sex : 性别
	-- online: 1->在线；0->离线
	-- vipLevel: vip等级
	-- headColor: 头颜色索引
	-- headEffectId : 头像特效Id
	-- qqHallInfo : 玩家qq蓝钻特权信息
	WZLog("ProtocolProcessorWndFriends:parse_FRIEND_OnlinePlayerOK")
	WndFriends:setRecommendData(playerId, playerName, level, fighting, headId, faceId, sex, online, vipLevel, headColor, headEffectId, qqHallInfo)
end

--@brief	上下线协议（FRIEND_IsOnline = 17）
function ProtocolProcessorWndFriends:parse_FRIEND_IsOnline(playerId, isOnline, faceItemId, headItemId, headColor)
	-- playerId : 玩家id
	-- isOnline : 1、在线，0、离线
	-- faceItemId : 脸道具id, 不存在为0
	-- headItemId : 头道具id, 不存在为0
	-- headColor : 头颜色索引
	WZLog("ProtocolProcessorWndFriends:parse_FRIEND_IsOnline",playerId, isOnline, faceItemId, headItemId, headColor)
	CacheCenter:onlineStatic(playerId, isOnline, faceItemId, headItemId, headColor)
end

--@brief	获取好友（FRIEND_GetFriendOK = 19）
function ProtocolProcessorWndFriends:parse_FRIEND_GetFriendOK(playerId, playerName, level, sex, headItemId, faceItemId, isMentoring, playerFighting, friendNum, isOnline, vipLevel, tournamentLevel, colour, serverId, isChum, mentoringNum, couple, professionId, useType, status, bodyId, wingId, assistSize, headEffectId, qqHallInfo, topFriendIds)
	-- playerId : 玩家id
	-- playerName : 玩家名称
	-- level : 玩家等级
	-- sex : 玩家性别0、男，1、女
	-- headItemId : 头像id， 不在线返回0
	-- faceItemId : 脸id，不在线返回0
	-- isMentoring : 是否师徒关系true 是存在关系，false 不存在关系
	-- playerFighting : 玩家战力
	-- friendNum : 好友度
	-- isOnline : 1为在线，0为不在线
	-- vipLevel : vip等级
	-- tournamentLevel : 竞技等级
	-- colour : 头部颜色
	-- serverId : 所在服id
	-- isChum : 是否密友，1为是密友
	-- mentoringNum : 师德等级
	-- couple : 夫妻关系（0为没有关系，1为未婚夫妻关系，2为已婚夫妻关系）
	-- useType : 邀请类型
	-- professionId : 职业id
	-- status : 状态 0空闲 1忙碌 2战斗
	-- assistSize : 岛主副本助战数量
	-- headEffectId : 头像特效Id
	-- qqHallInfo : 玩家qq特权信息
	-- topFriendIds : 置顶好友
	-- WZLog("ProtocolProcessorWndFriends:parse_FRIEND_GetFriendOK")
	WZLog("ProtocolProcessorWndFriends:parse_FRIEND_GetFriendOK",
		"\n playerId =",Serialize(VectorToTable(playerId)),
		"\n playerName =",Serialize(VectorToTable(playerName)),
		"\n level =",Serialize(VectorToTable(level)),
		"\n sex =",Serialize(VectorToTable(sex)),
		"\n headItemId =",Serialize(VectorToTable(headItemId)),
		"\n faceItemId =",Serialize(VectorToTable(faceItemId)),
		"\n isMentoring =",Serialize(VectorToTable(isMentoring)),
		"\n playerFighting =",Serialize(VectorToTable(playerFighting)),
		"\n friendNum =",Serialize(VectorToTable(friendNum)),
		"\n isOnline =",Serialize(VectorToTable(isOnline)),
		"\n vipLevel =",Serialize(VectorToTable(vipLevel)),
		"\n tournamentLevel =",Serialize(VectorToTable(tournamentLevel)),
		"\n colour =",Serialize(VectorToTable(colour)),
		"\n serverId =",Serialize(VectorToTable(serverId)),
		"\n isChum =",Serialize(VectorToTable(isChum)),
		"\n mentoringNum =",Serialize(VectorToTable(mentoringNum)),
		"\n couple =",Serialize(VectorToTable(couple)),
		"\n professionId =",Serialize(VectorToTable(professionId)),
		"\n useType =",Serialize(VectorToTable(useType)),
		"\n status =",Serialize(VectorToTable(status)),
		"\n bodyId =",Serialize(VectorToTable(bodyId)),
		"\n wingId =",Serialize(VectorToTable(wingId)),
		"\n assistSize =",Serialize(VectorToTable(assistSize)),
		"\n headEffectId =",Serialize(VectorToTable(headEffectId)),
		"\n qqHallInfo =",Serialize(VectorToTable(qqHallInfo)),
		"\n topFriendIds =",Serialize(VectorToTable(topFriendIds))
		)
	CacheCenter:setFriendDataList(playerId, playerName, level, sex ,faceItemId ,headItemId,isMentoring,playerFighting, friendNum, isOnline, vipLevel, tournamentLevel, serverId, colour, isChum, mentoringNum, couple, useType, professionId, status, bodyId, wingId, assistSize, headEffectId, qqHallInfo, topFriendIds)
	--七夕好友
	if useType == 17 then
		GlobalGame:getGameEventDispathcer():Dispatch(WndDoubleSevenEvent.WndDoubleSevenEvent_GetDoubleSevenFriends,VectorToTable(playerId),VectorToTable(sex),VectorToTable(playerName),VectorToTable(level), VectorToTable(headItemId), VectorToTable(faceItemId), VectorToTable(colour), VectorToTable(serverId), VectorToTable(headEffectId), VectorToTable(qqHallInfo))
	end
end

--@brief	获取领用体力数量（FRIEND_GetVigorNum = 20）
function ProtocolProcessorWndFriends:parse_FRIEND_GetVigorNum(vigorNum)
	-- vigorNum : 领用体力数量
	WZLog("ProtocolProcessorWndFriends:parse_FRIEND_GetVigorNum",vigorNum)
	CacheCenter:setDynamicCount(vigorNum)
end

--@brief	更新好友动态赠送时间（FRIEND_UpdateAccept = 21）
function ProtocolProcessorWndFriends:parse_FRIEND_UpdateAccept(playerId, date)
	-- playerId : 玩家id
	-- date : 赠送时间
	WZLog("ProtocolProcessorWndFriends:parse_FRIEND_UpdateAccept")
	CacheCenter:updateDynamicAccept(playerId, timer)
end


--@brief	更新好友信息	（FRIEND_UpdateFriend = 22）
function ProtocolProcessorWndFriends:parse_FRIEND_UpdateFriend(playerId)
	-- playerId : 玩家id(改变好友状态)
	WZLog("ProtocolProcessorWndFriends:parse_FRIEND_UpdateFriend")
	CacheCenter:updateFriendRelations( playerId )
end

--@brief	送好友礼物返回协议（FRIEND_SendGiftOk = 25）
function ProtocolProcessorWndFriends:parse_FRIEND_SendGiftOk(result, playerId, sendType)
	-- result : 送礼物结果（1为成功，0为失败）
	WZLog("ProtocolProcessorWndFriends:parse_FRIEND_SendGiftOk")
	CacheCenter:giveFriendGiftOK(result, playerId, sendType)
end


--@brief	设置上线通知（FRIEND_ChangeNotifyOk = 30）
function ProtocolProcessorWndFriends:parse_FRIEND_ChangeNotifyOk()
	WZLog("ProtocolProcessorWndFriends:parse_FRIEND_ChangeNotifyOk")

	WndOnlineHintFriend:setFriendOnlineOk()
end

--@brief	请求结果（INVITE_InviteInfoListOk = 10）
function ProtocolProcessorWndFriends:parse_INVITE_InviteInfoListOk(myInviteCode, friendIdList, nameList, pictureList, faceIdList, levelList, vipLevelList, sex, lineStatusList, serverIdList, taskIdList, conditions, currCount, statusList, writeFlag, headColor, headEffectId)
	-- myInviteCode : 当前玩家的邀请码
	-- friendIdList : 当前玩家的邀请码好友列表
	-- nameList : 名字列表
	-- pictureList : 头像列表
	-- faceIdList : 脸id
	-- levelList : 等级列表
	-- vipLevelList : vip等级列表
	-- lineStatusList : 是否在线
	-- serverIdList : 服务器id列表
	-- taskIdList : 任务列表
	-- conditions : 完成任务的条件数量
	-- currCount : 当前完成几个条件
	-- statusList : 任务状态 -1不可领取0可领取1已经领取
	-- writeFlag : 是否提交过邀请码1：提交过；0：未提交过
	-- headColor : 头颜色索引
	-- headEffectId : 玩家头像特效Id
	WZLog("ProtocolProcessorWndFriends:parse_INVITE_InviteInfoListOk")
	CacheCenter:setInviteData(myInviteCode, friendIdList, nameList, pictureList, faceIdList, levelList, vipLevelList, sex, lineStatusList, serverIdList, taskIdList, conditions, currCount, statusList, writeFlag, headColor, headEffectId)
end

--@brief	填写邀请码结果（INVITE_InviteAwardOk = 12）
function ProtocolProcessorWndFriends:parse_INVITE_InviteAwardOk(code, name, level, serverid, playerId, successFlag, headId, faceId, vipLevel, sex, headColor, headEffectId)
	-- code : 邀请码
	-- name : 玩家名称
	-- level : 玩家等级
	-- serverid : 服务器id
	-- playerId : 所填写的玩家id
	-- successFlag : // 0失败，1成功
	-- headId : 头像
	-- faceId : faceid
	-- vipLevel : vip等级
	-- sex : 性别
	-- headColor : 头像颜色索引
	-- headEffectId : 玩家头像特效Id
	WZLog("ProtocolProcessorWndFriends:parse_INVITE_InviteAwardOk")
	if WndFriendInviteCode.m_root then
		WndFriendInviteCode:setData(code, name, level, serverid, playerId, successFlag, headId, faceId, vipLevel, sex, headColor, headEffectId)
	end
end

--@brief	领取奖励结果(INVITE_GetInviteRewardsOk = 14)
function ProtocolProcessorWndFriends:parse_INVITE_GetInviteRewardsOk(rewardId, items, nums, successFlag)
	-- rewardId : 任务id
	-- items : 奖励物品id
	-- nums : 奖励物品数量
	-- successFlag : 领取奖励成功0不成功1成功
	WZLog("ProtocolProcessorWndFriends:parse_INVITE_GetInviteRewardsOk", successFlag)
	if successFlag == 1 then
		WndFriends:receiveTaskRewardOK(rewardId, VectorToTable(items), VectorToTable(nums))
	end
end

--@brief	更新邀请码任务（INVITE_UpdatePlayerInviteInfoOk = 16）
function ProtocolProcessorWndFriends:parse_INVITE_UpdatePlayerInviteInfoOk(id, status, count, currCount)
	-- id : 任务id
	-- status : 状态
	-- count : 总进度
	-- currCount : 当前进度
	WZLog("ProtocolProcessorWndFriends:parse_INVITE_UpdatePlayerInviteInfoOk")
	CacheCenter:updateInviteTask(id, status, count, currCount)
end

--@brief	新增邀请码好友（INVITE_InviteFinishTaskOk = 17）
function ProtocolProcessorWndFriends:parse_INVITE_InviteFinishTaskOk(friendId, name, headId, faceId, level, vipLevel, sex, lineStatus, serverId, headColor, headEffectId)
	-- friendId : 好友id
	-- name : 名字列表
	-- headId : 头像列表
	-- faceId : 脸id
	-- level : 等级列表
	-- vipLevel : vip等级列表
	-- sex : 玩家性别
	-- lineStatus : 是否在线
	-- serverId : 服务器id列表
	-- headColor : 头颜色索引
	-- headEffectId : 玩家头像特效Id
	WZLog("ProtocolProcessorWndFriends:parse_INVITE_InviteFinishTaskOk")
	CacheCenter:addInviteFriend(friendId, name, headId, faceId, level, vipLevel, sex, lineStatus, serverId, headColor, headEffectId)
end

--@brief	申请添加密友成功（FRIEND_AddChumOK = 39）
function ProtocolProcessorWndFriends:parse_FRIEND_AddChumOK(playerId, result)
	-- playerId : 添加的密友Id
	-- result : 添加密友结果，0、不是好友，1、成功， 2、好友度不够，3.夫妻关系，4.超过密友上限
	WZLog("ProtocolProcessorWndFriends:parse_FRIEND_AddChumOK")

	CacheCenter:applyBestFriendSuccess(playerId, result)
end

--@brief	删除密友成功（FRIEND_RemoveChumOK = 41）
function ProtocolProcessorWndFriends:parse_FRIEND_RemoveChumOK(result, playerId)
	-- result : 删除密友结果,1为成功
	WZLog("ProtocolProcessorWndFriends:parse_FRIEND_RemoveChumOK", result)
	CacheCenter:removeBestFriendList(playerId)
	if result == 1 then
		WndCheckOther:deleteBestFriendOK()
	end
end

--@brief	审批密友协议（FRIEND_ApproveChumOK = 43）
function ProtocolProcessorWndFriends:parse_FRIEND_ApproveChumOK(result, playerId, approveType, applychum)
	-- result : 审批结果，0、不是好友，1、成功， 2、好友度不够，3.夫妻关系，4.超过密友上限
	-- playerId : 好友Id,
	-- approveType : 1、同意，2、拒绝
	-- applychum : 请求加为密友Id
	WZLog("ProtocolProcessorWndFriends:parse_FRIEND_ApproveChumOK", result, playerId, approveType)

	WndFriends:closeLoading()
	CacheCenter:ApprovalBestFriendResult(playerId, result, approveType, applychum)

	if approveType == 1 then--同意
		if result == 0 then 
			MsgBoxManager:showTipBox(LocalStrings.FRIENDS_BESTFRIEND12)--"不是好友"
		elseif result == 1 then 				
			MsgBoxManager:showTipBox(LocalStrings.FRIENDS_BESTFRIEND15)--"审批成功"
		elseif result == 2 then 				
			MsgBoxManager:showTipBox(LocalStrings.FRIENDS_BESTFRIEND13)--"好友度不够"
		elseif result == 3 then 				
			MsgBoxManager:showTipBox(LocalStrings.FRIENDS_BESTFRIEND14)--"夫妻"
		elseif result == 4 then 				
			MsgBoxManager:showTipBox(LocalStrings.FRIENDS_BESTFRIEND10)--审批操作成功
		end
		return
	elseif approveType == 2 then 
		MsgBoxManager:showTipBox(LocalStrings.FRIENDS_BESTFRIEND16)--拒绝操作成功
	end

end

--@brief	获取恩爱值协议（FRIEND_CoupleNumOK = 45）
function ProtocolProcessorWndFriends:parse_FRIEND_CoupleNumOK(num, level)
	-- num : 恩爱值
	-- level : 恩爱等级
	WZLog("ProtocolProcessorWndFriends:parse_FRIEND_CoupleNumOK")

	CellRelation:getLoveLevelAndValueOK(num, level)
end

--@brief	获取黑名单列表（FRIENT_GetBlackListOk = 49）
function ProtocolProcessorWndFriends:parse_FRIENT_GetBlackListOk(playerId, playerName, level, sex, online, faceItemId, headItemId, vipLevel, headColor, serverId, headEffectId)
	-- playerId : 玩家id
	-- playerName : 玩家名称
	-- level : 玩家等级
	-- sex : 玩家性别0、男，1、女
	-- online : 1为在线，0为不在线
	-- faceItemId : 脸id，不在线返回0
	-- headItemId : 头像id， 不在线返回0
	-- vipLevel : vip等级
	-- colour : 头部颜色
	-- serverId : 所在服id
	-- headEffectId : 玩家头像特效Id
	WZLog("ProtocolProcessorWndFriends:parse_FRIENT_GetBlackListOk")

	CacheCenter:setFriendBlacklistData(playerId, playerName, level, sex ,faceItemId ,headItemId, online, vipLevel, serverId, headColor, headEffectId)

	WndFriendBlackList:addBlacklistOK()
end

--@brief	黑名单操作（FRIENT_BlackListOperateOk = 47）
function ProtocolProcessorWndFriends:parse_FRIENT_BlackListOperateOk(actionType, playerId)
	-- actionType : 操作类型 0.添加黑名单 1.移除黑名单
	-- playerId : 玩家id
	WZLog("ProtocolProcessorWndFriends:parse_FRIENT_BlackListOperateOk")
	if actionType == 0 then
		MsgBoxManager:showTipBox(LocalStrings.BLACKLIST_TEXT13)
		WndCheckOther:operateBlacklistOK(actionType, playerId)
	else
		MsgBoxManager:showTipBox(LocalStrings.BLACKLIST_TEXT12)
		CacheCenter:delFriendBlacklist(playerId)
		WndCheckOther:operateBlacklistOK(actionType, playerId)
		WndFriendBlackList:DelBlacklistSuccess(playerId)
	end
end

--@brief	申请添加双休好友成功（FRIEND_AddShuangXiuOk = 51）
function ProtocolProcessorWndFriends:parse_FRIEND_AddShuangXiuOk(playerId, result)
	-- playerId : 添加的好友Id
	-- result : 添加好友结果，1、成功， 2、已经在对方审批列表中 3、失败：对方已经有双休好友
	WZLog("ProtocolProcessorWndFriends:parse_FRIEND_AddShuangXiuOk")

	if result == 1 then 
		MsgBoxManager:showTipBox(LocalStrings.PRACTICE_TEXT11)
	elseif result == 2 then 
		MsgBoxManager:showTipBox(LocalStrings.PRACTICE_TEXT12)
	elseif result == 3 then 
		MsgBoxManager:showTipBox(LocalStrings.PRACTICE_TEXT13)
	end
end

--@brief	审批同意双休密友协议（FRIEND_ApproveShuangXiuOk = 53）
function ProtocolProcessorWndFriends:parse_FRIEND_ApproveShuangXiuOk(playerId, result, nType, msg)
	-- playerId : 添加的好友Id
	-- result : 1成功，2: 失败:对象有有双修对象 3：失败：自己已经有双修对象 4：失败：对方或自己惩罚期
	-- nType : 1同意，2拒绝
	-- msg : 失败提示错误信息
	WZLog("ProtocolProcessorWndFriends:parse_FRIEND_ApproveShuangXiuOk")

	if result ~= 4 then 
		CacheCenter:ApprovalDoublePracticeResult(playerId, result, nType)
	end

	if nType == 1 then--同意
		if result == 1 then 
			MsgBoxManager:showTipBox(LocalStrings.PRACTICE_TEXT10)--审批操作成功
			WndBagMain:showPractice()
		else 				
			MsgBoxManager:showTipBox(msg)
		end
		return
	end
	if nType == 2 then 
		MsgBoxManager:showTipBox(LocalStrings.PRACTICE_TEXT9)--拒绝操作成功
	end
end

--@brief	获取朋友圈列表（FRIEND_GetFriendCircleOk = 58）
function ProtocolProcessorWndFriends:parse_FRIEND_GetFriendCircleOk(cId, playerId, sex, playerName, vipLevel, headId, faceId, headColor, time, message, verify, comment, spacePhoto, spacePhotoNum, likeTotal, hasLike, likeName, commentTotal, commentId, commentMse, cPlayerId, cPlayerName, bPlayerId, bPlayerName, redDotNum, fPlayerId, fPlayerName, headEffectId, qqHallInfo, setTopMark)
	--cId ：朋友圈id
	--playerId：玩家id
	--sex ：玩家姓别
	--playerName ：玩家姓名
	--headScul ：玩家头像
	--time ：发布时间（秒）
	--message ：内容
	--verify ：1通过
	--comment ：0开启评论 1关闭评论
	--spacePhoto ：图片
	--spacePhotoNum ：图片数
	--likeTotal ：点赞总数
	--hasLike ：点赞玩家id
	--likeName ：点赞玩家姓名
	--likeHeadScul ：点赞玩家头像
	--commentTotal ：评论总数
	--commentId ：评论id
	--commentMse ：评论内容
	--cPlayerId ：评论回复玩家id
	--cPlayerName ：评论回复玩家姓名
	--bPlayerId ：评论被回复玩家id
	--bPlayerName ：评论被回复玩家姓名
	--redDotNum ： 红点条数
	--fPlayerId ： 查看指定玩家的圈
	--fPlayerName ： 查看指定玩家的名字
	--headEffectId ： 玩家头像特效Id
	--qqHallInfo ： 玩家qq特权信息
	--setTopMark ： 心情是否置顶

	WZLog("ProtocolProcessorWndFriends:parse_FRIEND_GetFriendCircleOk", fPlayerId, Serialize(VectorToTable(setTopMark)))

	if fPlayerId == 0 then 
		WndFriends:setCircleData(VectorToTable(cId), VectorToTable(playerId), VectorToTable(sex), VectorToTable(playerName), VectorToTable(vipLevel), VectorToTable(headId), VectorToTable(faceId), VectorToTable(headColor), VectorToTable(time), VectorToTable(message), VectorToTable(verify), VectorToTable(comment), VectorToTable(spacePhoto), VectorToTable(spacePhotoNum), VectorToTable(likeTotal), VectorToTable(hasLike), VectorToTable(likeName), VectorToTable(commentTotal), VectorToTable(commentId), VectorToTable(commentMse), VectorToTable(cPlayerId), VectorToTable(cPlayerName), VectorToTable(bPlayerId), VectorToTable(bPlayerName), redDotNum, fPlayerId, fPlayerName, VectorToTable(headEffectId), VectorToTable(qqHallInfo), VectorToTable(setTopMark))
	else
		if WndCircleOfFriend.m_root then 
			WndCircleOfFriend:setData(VectorToTable(cId), VectorToTable(playerId), VectorToTable(sex), VectorToTable(playerName), VectorToTable(vipLevel), VectorToTable(headId), VectorToTable(faceId), VectorToTable(headColor), VectorToTable(time), VectorToTable(message), VectorToTable(verify), VectorToTable(comment), VectorToTable(spacePhoto), VectorToTable(spacePhotoNum), VectorToTable(likeTotal), VectorToTable(hasLike), VectorToTable(likeName), VectorToTable(commentTotal), VectorToTable(commentId), VectorToTable(commentMse), VectorToTable(cPlayerId), VectorToTable(cPlayerName), VectorToTable(bPlayerId), VectorToTable(bPlayerName), redDotNum, fPlayerId, fPlayerName, VectorToTable(headEffectId), VectorToTable(qqHallInfo), VectorToTable(setTopMark))
		end
	end
end

--@brief	点赞成功（FRIENTD_LikeFriendCircleOk = 69）
function ProtocolProcessorWndFriends:parse_FRIENTD_LikeFriendCircleOk(cId, likeTotal, hasLike, likeName)
	--cId ：朋友圈id
	--like ：点赞玩家id
	--likeName ：点赞玩家姓名
	--likeHeadScul ：点赞玩家头像
	WZLog("ProtocolProcessorWndFriends:parse_FRIENTD_LikeFriendCircleOk")

	WndFriends:giveGoodOK(cId, likeTotal, hasLike, VectorToTable(likeName))
	WndCircleOfFriend:giveGoodOK(cId, likeTotal, hasLike, VectorToTable(likeName))
	WndCheckOther:giveGoodOK(cId, likeTotal, hasLike, VectorToTable(likeName))
end

--@brief	评论成功（FRIENTD_CommentFriendCircleOk = 70）
function ProtocolProcessorWndFriends:parse_FRIENTD_CommentFriendCircleOk(cId, commentId, commentMse, cPlayerId, cPlayerName, bCommentId, bPlayerId, bPlayerName)
	--cId ：朋友圈id(-1:此条已被删除 -2：玩家已开启非好友不能评论)
	--commentId ：评论id
	--commentMse ：评论内容
	--cPlayerId ：评论回复玩家id
	--cPlayerName ：评论回复玩家姓名
	--bCommentId ：被评论的评论id
	--bPlayerId ：评论被回复玩家id
	--bPlayerName ：评论被回复玩家姓名
	WZLog("ProtocolProcessorWndFriends:parse_FRIENTD_CommentFriendCircleOk")

	WndFriends:commentCircleOK(cId, commentId, commentMse, cPlayerId, cPlayerName, bCommentId, bPlayerId, bPlayerName)
	WndCircleOfFriend:commentCircleOK(cId, commentId, commentMse, cPlayerId, cPlayerName, bCommentId, bPlayerId, bPlayerName)
	WndCheckOther:commentCircleOK(cId, commentId, commentMse, cPlayerId, cPlayerName, bCommentId, bPlayerId, bPlayerName)
end

--@brief	操作朋友圈成功（FRIENTD_OFriendCircleOk = 71）
function ProtocolProcessorWndFriends:parse_FRIENTD_OFriendCircleOk(oType, cId, param)
	--oType ：1删除心情  2.取消点赞  3.删除评论  4.举报 5.设置心情 6.发布成功
	--cId ：朋友圈id
	--param ：其他参数
	WZLog("ProtocolProcessorWndFriends:parse_FRIENTD_OFriendCircleOk")

	WndFriends:dealWithResultByType(oType, cId, param)
	WndCircleOfFriend:dealWithResultByType(oType, cId, param)
	WndCheckOther:dealWithResultByType(oType, cId, param)
end

--@brief	查看心情红点列表（FRIENTD_LookFriendCircleOk = 72）
function ProtocolProcessorWndFriends:parse_FRIENTD_LookFriendCircleOk(oType, cId, oMessage, message, bMessage, playerId, playerName, sex, vipLevel, headId, faceId, headColor, headEffectId, qqHallInfo)
	--oType ：1点赞 2评论 3回复
	--cId ：朋友圈id
	--oMessage : 操作信息
	--message : 心情方案或回复内容
	--bMessage : 操作内容
	--playerId : 玩家id
	--playerName : 玩家姓名
	--time ：被点赞或评论距离现在多少秒
	--headEffectId ：玩家头像框特效Id
	--qqHallInfo ：玩家qq特权信息
	WZLog("ProtocolProcessorWndFriends:parse_FRIENTD_LookFriendCircleOk", Serialize(VectorToTable(oType)))

	WndFriends:getNewMessageListOK(VectorToTable(oType), VectorToTable(cId), VectorToTable(oMessage), VectorToTable(message), VectorToTable(bMessage), VectorToTable(playerId), VectorToTable(playerName), VectorToTable(sex), VectorToTable(vipLevel), VectorToTable(headId), VectorToTable(faceId), VectorToTable(headColor), VectorToTable(headEffectId), VectorToTable(qqHallInfo))
end

--@brief	查看个人空间朋友圈（FRIENTD_SpaceFriendCircleOk = 73）
function ProtocolProcessorWndFriends:parse_FRIENTD_SpaceFriendCircleOk(cId, message, spacePhoto, likeTotal, commentTotal, time, verify, giveGoodMark, commentState)
	--cId ：朋友圈id
	--message : 信息
	--spacePhoto : 照片
	--likeTotal : 点赞总数
	--commentTotal : 评论总数
	--time ：发布时间（秒）
	--verify ：1通过
	--giveGoodMark ：是否点赞过
	--commentState ：是否开启不让陌生人评论
	WZLog("ProtocolProcessorWndFriends:parse_FRIENTD_SpaceFriendCircleOk")

	WndCheckOther:setSpaceDynamicData(cId, message, VectorToTable(spacePhoto), likeTotal, commentTotal, time, verify, giveGoodMark, commentState)
end

--@brief	成功查询指定空间朋友圈（FRIENTD_GetByIdFriendCircleOk = 74）
function ProtocolProcessorWndFriends:parse_FRIENTD_GetByIdFriendCircleOk(cId, playerId, sex, playerName, vipLevel, headId, faceId, headColor, time, message, verify, comment, spacePhoto, like, likeName, likeSex, likeVip, likeHeadId, likeFaceId, likeHeadColor, commentId, commentMse, cPlayerId, cPlayerName, bPlayerId, bPlayerName)
	--cId ：朋友圈id
	--playerId：玩家id
	--sex ：玩家姓别
	--playerName ：玩家姓名
	--headScul ：玩家头像
	--time ：发布时间（秒）
	--message ：内容
	--verify ：1通过
	--comment ：0开启评论 1关闭评论
	--spacePhoto ：图片
	--likeTotal ：点赞总数
	--like ：点赞玩家id
	--likeName ：点赞玩家姓名
	--commentId ：评论id
	--commentMse ：评论内容
	--cPlayerId ：评论回复玩家id
	--cPlayerName ：评论回复玩家姓名
	--bPlayerId ：评论被回复玩家id
	--bPlayerName ：评论被回复玩家姓名

	WZLog("ProtocolProcessorWndFriends:parse_FRIENTD_GetByIdFriendCircleOk")

	WndCircleOfFriend:setSpecifyData(cId, playerId, sex, playerName, vipLevel, headId, faceId, headColor, time, message, verify, comment, VectorToTable(spacePhoto), VectorToTable(like), VectorToTable(likeName), VectorToTable(likeSex), VectorToTable(likeVip), VectorToTable(likeHeadId), VectorToTable(likeFaceId), VectorToTable(likeHeadColor), VectorToTable(commentId), VectorToTable(commentMse), VectorToTable(cPlayerId), VectorToTable(cPlayerName), VectorToTable(bPlayerId), VectorToTable(bPlayerName))
end

--@brief	朋友圈异常（FRIENTD_FriendCircleError = 75）
function ProtocolProcessorWndFriends:parse_FRIENTD_FriendCircleError(code, cId, commentId)
	--code :   1.好友圈已删除  2.评论已删除 3.玩家开启非好友不能评论
	--cId ：朋友圈id
	--commentId ：评论Id
	WZLog("ProtocolProcessorWndFriends:parse_FRIENTD_FriendCircleError", cId, commentId)

	if code == 1 then 
		MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT28)
		WndFriends:deleteCircleOK(nil, cId, commentId)
		WndCircleOfFriend:deleteCircleOK(nil, cId, commentId)
	elseif code == 2 then 
		MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT29)
		WndFriends:deleteCommentOK(nil, cId, commentId)
		WndCircleOfFriend:deleteCommentOK(nil, cId, commentId)
	elseif code == 3 then 
		MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT25)
	elseif code == 5 then 
		MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT37)
	elseif code == 6 then 
		MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT38)
	end
end

--@brief	备注好友成功（FRIEND_RemarkFriendOk = 77）
function ProtocolProcessorWndFriends:parse_FRIEND_RemarkFriendOk(playerId, result, remarkName)
	--playerId : 好友Id
	--result ：1-成功 | 2-其他原因失败,3-非法字符 | 4-名字不能为空 | 5-名字太长 | 6-名字太短
	--remarkName ：备注名字
	WZLog("ProtocolProcessorWndFriends:parse_FRIEND_RemarkFriendOk")

	if result == 1 then 
		MsgBoxManager:showTipBox(LocalStrings.FRIEND_DELETE10)
		CacheCenter:resetFriendRemarkName(playerId, remarkName)
		WndFriends:addRemarknameOK(playerId, result, remarkName)
		WndCheckOther:addRemarknameOK(playerId, result, remarkName)
	elseif result == 2 then
        MsgBoxManager:showTipBox(LocalStrings.NAME_HAVED_EXIST)
    elseif result == 3 then
        MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO3)
    elseif result == 4 then
        MsgBoxManager:showTipBox(LocalStrings.ISBLANKKEY)
    elseif result == 5 then
        MsgBoxManager:showTipBox(LocalStrings.FRIEND_DELETE11)
    elseif result == 6 then 
        MsgBoxManager:showTipBox(LocalStrings.NAME_TOO_SHOOT)
	end
end

--@brief	获取点赞列表（FRIEND_GetFriendCircleLikesOk = 111）
function ProtocolProcessorWndFriends:parse_FRIEND_GetFriendCircleLikesOk(cId, like, likeName, likeSex, likeVip, likeHeadId, likeFaceId, likeHeadColor, headEffectId, qqHallInfo)
	--cId ：朋友圈id
	--like ：点赞玩家id
	--likeName ：点赞玩家姓名
	--likeSex ：点赞玩家性别
	--likeVip ：点赞玩家VIP
	--likeHeadId ：点赞玩家头Id
	--likeFaceId ：点赞玩家脸Id
	--likeHeadColor ：点赞玩家头颜色
	--headEffectId ：玩家头像框特效Id
	--qqHallInfo ：玩家qq蓝钻信息

	WZLog("ProtocolProcessorWndFriends:parse_FRIEND_GetFriendCircleLikesOk")

	WndGiveGoodPlayer:setData(cId, VectorToTable(like), VectorToTable(likeName), VectorToTable(likeSex), VectorToTable(likeVip), VectorToTable(likeHeadId), VectorToTable(likeFaceId), VectorToTable(likeHeadColor), VectorToTable(headEffectId), VectorToTable(qqHallInfo))
end

--@brief	协议号名字（FRIEND_MoodTopOk = 119）
function ProtocolProcessorWndFriends:parse_FRIEND_MoodTopOk(cId)
	WZLog("ProtocolProcessorWndFriends:parse_FRIEND_MoodTopOk")
	GlobalGame:getGameEventDispathcer():Dispatch(FriendEvent.CircleOfFriendEvent_SetTop, cId)
end

--@brief	好友列表：置顶好友（FRIEND_TopFriendOK = 121）
function ProtocolProcessorWndFriends:parse_FRIEND_TopFriendOK(playerIds, topType)
	-- playerIds : 选中的好友id
	-- topType : 好友置顶类型： 0 设置置顶 1: 取消置顶
	WZLog("ProtocolProcessorWndFriends:parse_FRIEND_TopFriendOK", Serialize(VectorToTable(playerIds)), topType)
	WndOnlineHintFriend:setTopFriendOk()
end

--@brief	移动置顶好友（FRIEND_SwapTopFriendOK = 123）
function ProtocolProcessorWndFriends:parse_FRIEND_SwapTopFriendOK(playerId, beforePlayerId)
	-- playerId : 移动好友id
	-- beforePlayerId : 后一个置顶好友id
	WZLog("ProtocolProcessorWndFriends:parse_FRIEND_SwapTopFriendOK", Serialize(VectorToTable(playerId)), beforePlayerId)
end


-------------------------------------协议错误处理方法模块--------------------------------------
--@brief	发送好友列表（FRIEND_FriendInfoList = 1）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndFriends:send_FRIEND_AddFriend_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndFriends:send_FRIEND_AddFriend_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FRIEND, Protocol.FRIEND_AddFriend, nflag, sMessage)
	MsgBoxManager:showTipBox(sMessage)
	WndFriends:closeLoading()
end


--@brief	删除好友对象（FRIEND_DeleteFriend = 4）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndFriends:send_FRIEND_DeleteFriend_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndFriends:send_FRIEND_DeleteFriend_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FRIEND, Protocol.FRIEND_DeleteFriend, nflag, sMessage)
	MsgBoxManager:showTipBox(sMessage)
	WndFriends:closeLoading()
end

--@brief	搜索好友协议（FRIEND_SearchFriend = 6）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndFriends:send_FRIEND_SearchFriend_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndFriends:send_FRIEND_SearchFriend_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FRIEND, Protocol.FRIEND_SearchFriend, nflag, sMessage)
	MsgBoxManager:showTipBox(sMessage)
	WndFriends:closeLoading()
end

--@brief	审批好友协议（FRIEND_Approve = 8）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndFriends:send_FRIEND_Approve_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndFriends:send_FRIEND_Approve_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FRIEND, Protocol.FRIEND_Approve, nflag, sMessage)
	MsgBoxManager:showTipBox(sMessage)
	WndFriends:closeLoading()
end


--@brief	操作协议（FRIEND_Operation = 10）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndFriends:send_FRIEND_Operation_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndFriends:send_FRIEND_Operation_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FRIEND, Protocol.FRIEND_Operation, nflag, sMessage)
	MsgBoxManager:showTipBox(sMessage)
	WndFriends:closeLoading()
end

--@brief	在线玩家协议（FRIEND_OnlinePlayer = 15）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndFriends:send_FRIEND_OnlinePlayer_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndFriends:send_FRIEND_OnlinePlayer_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FRIEND, Protocol.FRIEND_OnlinePlayer, nflag, sMessage)
	MsgBoxManager:showTipBox(sMessage)
	WndFriends:closeLoading()
end


--@brief	获取好友（FRIEND_GetFriend = 18）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndFriends:send_FRIEND_GetFriend_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndFriends:send_FRIEND_GetFriend_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FRIEND, Protocol.FRIEND_GetFriend, nflag, sMessage)
	MsgBoxManager:showTipBox(sMessage)
	WndFriends:closeLoading()
end

--@brief	获得好友列表错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndFriends:send_FRIEND_GetFriendInfoList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndFriends:send_FRIEND_GetFriendInfoList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FRIEND, Protocol.FRIEND_GetFriendInfoList, nflag, sMessage)
end

--@brief	送礼物协议（FRIEND_SendGift = 24）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndFriends:send_FRIEND_SendGift_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndFriends:send_FRIEND_SendGift_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FRIEND, Protocol.FRIEND_SendGift, nflag, sMessage)
end

--@brief	获得好友动态（FRIEND_Accept=28）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndFriends:send_FRIEND_Accept_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndFriends:send_FRIEND_Accept_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FRIEND, Protocol.FRIEND_Accept, nflag, sMessage)
end

--@brief	设置上线通知（FRIEND_ChangeNotify = 29）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndFriends:send_FRIEND_ChangeNotify_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndFriends:send_FRIEND_ChangeNotify_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FRIEND, Protocol.FRIEND_ChangeNotify, nflag, sMessage)
end

--@brief	填写邀请码（INVITE_InviteWriteCode = 11）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndFriends:send_INVITE_InviteWriteCode_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndFriends:send_INVITE_InviteWriteCode_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_INVITE, Protocol.INVITE_InviteWriteCode, nflag, sMessage)
end

--@brief	领取邀请码奖励（INVITE_GetInviteRewards = 13）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndFriends:send_INVITE_GetInviteRewards_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndFriends:send_INVITE_GetInviteRewards_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_INVITE, Protocol.INVITE_GetInviteRewards, nflag, sMessage)
end

--@brief	已经填写邀请码，请求填写的玩家内容（INVITE_requestList = 15）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndFriends:send_INVITE_requestList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndFriends:send_INVITE_requestList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_INVITE, Protocol.INVITE_requestList, nflag, sMessage)
end

--@brief	请求邀请码好友列表(INVITE_RequestInviteInfoList = 9)错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndFriends:send_INVITE_RequestInviteInfoList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndFriends:send_INVITE_RequestInviteInfoList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_INVITE, Protocol.INVITE_RequestInviteInfoList, nflag, sMessage)
end

--@brief	申请添加密友（FRIEND_AddChum = 38）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndFriends:send_FRIEND_AddChum_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndFriends:send_FRIEND_AddChum_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FRIEND, Protocol.FRIEND_AddChum, nflag, sMessage)
end

--@brief	删除密友（FRIEND_RemoveChum = 40）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndFriends:send_FRIEND_RemoveChum_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndFriends:send_FRIEND_RemoveChum_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FRIEND, Protocol.FRIEND_RemoveChum, nflag, sMessage)
end

--@brief	审批密友协议（FRIEND_ApproveChum = 42）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndFriends:send_FRIEND_ApproveChum_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndFriends:send_FRIEND_ApproveChum_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FRIEND, Protocol.FRIEND_ApproveChum, nflag, sMessage)
end

--@brief	获取恩爱值协议（FRIEND_CoupleNum = 44）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndFriends:send_FRIEND_CoupleNum_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndFriends:send_FRIEND_CoupleNum_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FRIEND, Protocol.FRIEND_CoupleNum, nflag, sMessage)
end

--@brief	黑名单操作（FRIENT_BlackListOperate = 46）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndFriends:send_FRIENT_BlackListOperate_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndFriends:send_FRIENT_BlackListOperate_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FRIEND, Protocol.FRIENT_BlackListOperate, nflag, sMessage)
end

--@brief	获取黑名单列表（FRIENT_GetBlackList = 48）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndFriends:send_FRIENT_GetBlackList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndFriends:send_FRIENT_GetBlackList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FRIEND, Protocol.FRIENT_GetBlackList, nflag, sMessage)
end

--@brief	申请添加双休好友（FRIEND_AddShuangXiu = 50）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndFriends:send_FRIEND_AddShuangXiu_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndFriends:send_FRIEND_AddShuangXiu_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FRIEND, Protocol.FRIEND_AddShuangXiu, nflag, sMessage)
end

--@brief	审批双修请求（FRIENTD_ApproveShuangXiu = 52）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndFriends:send_FRIENTD_ApproveShuangXiu_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndFriends:send_FRIENTD_ApproveShuangXiu_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FRIEND, Protocol.FRIENTD_ApproveShuangXiu, nflag, sMessage)
end

--@brief	获取朋友圈（FRIENTD_GetFriendCircle = 57）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndFriends:send_FRIENTD_GetFriendCircle_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndFriends:send_FRIENTD_GetFriendCircle_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FRIEND, Protocol.FRIENTD_GetFriendCircle, nflag, sMessage)
end

--@brief	发布心情（FRIENTD_AddFriendCircle = 59）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndFriends:send_FRIENTD_AddFriendCircle_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndFriends:send_FRIENTD_AddFriendCircle_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FRIEND, Protocol.FRIENTD_AddFriendCircle, nflag, sMessage)
end

--@brief	删除心情（FRIENTD_DelFriendCircle = 60）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndFriends:send_FRIENTD_DelFriendCircle_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndFriends:send_FRIENTD_DelFriendCircle_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FRIEND, Protocol.FRIENTD_DelFriendCircle, nflag, sMessage)
end

--@brief	点赞心情（FRIENTD_LikeFriendCircle = 61）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndFriends:send_FRIENTD_LikeFriendCircle_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndFriends:send_FRIENTD_LikeFriendCircle_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FRIEND, Protocol.FRIENTD_LikeFriendCircle, nflag, sMessage)
end

--@brief	取消点赞（FRIENTD_DelLikeFriendCircle = 62）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndFriends:send_FRIENTD_DelLikeFriendCircle_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndFriends:send_FRIENTD_DelLikeFriendCircle_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FRIEND, Protocol.FRIENTD_DelLikeFriendCircle, nflag, sMessage)
end

--@brief	评论心情（FRIENTD_CommentFriendCircle = 63）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndFriends:send_FRIENTD_CommentFriendCircle_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndFriends:send_FRIENTD_CommentFriendCircle_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FRIEND, Protocol.FRIENTD_CommentFriendCircle, nflag, sMessage)
end

--@brief	删除评论（FRIENTD_DelComment = 64）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndFriends:send_FRIENTD_DelComment_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndFriends:send_FRIENTD_DelComment_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FRIEND, Protocol.FRIENTD_DelComment, nflag, sMessage)
end

--@brief	举报心情（FRIENTD_ReportFriendCircle = 65）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndFriends:send_FRIENTD_ReportFriendCircle_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndFriends:send_FRIENTD_ReportFriendCircle_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FRIEND, Protocol.FRIENTD_ReportFriendCircle, nflag, sMessage)
end

--@brief	设置心情（FRIENTD_SetFriendCircle = 66）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndFriends:send_FRIENTD_SetFriendCircle_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndFriends:send_FRIENTD_SetFriendCircle_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FRIEND, Protocol.FRIENTD_SetFriendCircle, nflag, sMessage)
end

--@brief	查看心情红点列表（FRIENTD_LookFriendCircle = 67）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndFriends:send_FRIENTD_LookFriendCircle_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndFriends:send_FRIENTD_LookFriendCircle_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FRIEND, Protocol.FRIENTD_LookFriendCircle, nflag, sMessage)
end

--@brief	查询指定空间朋友圈（FRIENTD_GetByIdFriendCircle = 68）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndFriends:send_FRIENTD_GetByIdFriendCircle_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndFriends:send_FRIENTD_GetByIdFriendCircle_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FRIEND, Protocol.FRIENTD_GetByIdFriendCircle, nflag, sMessage)
end

--@brief	备注好友（FRIEND_RemarkFriend = 76）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndFriends:send_FRIEND_RemarkFriend_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndFriends:send_FRIEND_RemarkFriend_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FRIEND, Protocol.FRIEND_RemarkFriend, nflag, sMessage)
end

--@brief	获取点赞列表（FRIEND_GetFriendCircleLikes = 110）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndFriends:send_FRIEND_GetFriendCircleLikes_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndFriends:send_FRIEND_GetFriendCircleLikes_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FRIEND, Protocol.FRIEND_GetFriendCircleLikes, nflag, sMessage)
end

--@brief	我的心情置顶（FRIEND_MoodTop = 118）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndFriends:send_FRIEND_MoodTop_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndFriends:parse_FRIEND_MoodTop_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FRIEND, Protocol.FRIEND_MoodTop, nflag, sMessage)
end

--@brief	好友置顶（FRIEND_TopFriend = 120）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndFriends:send_FRIEND_TopFriend_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndFriends:parse_FRIEND_TopFriend_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FRIEND, Protocol.FRIEND_TopFriend, nflag, sMessage)
end

--@brief	移动置顶好友（FRIEND_SwapTopFriend = 122）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndFriends:send_FRIEND_SwapTopFriend_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndFriends:parse_FRIEND_SwapTopFriend_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FRIEND, Protocol.FRIEND_SwapTopFriend, nflag, sMessage)
end
