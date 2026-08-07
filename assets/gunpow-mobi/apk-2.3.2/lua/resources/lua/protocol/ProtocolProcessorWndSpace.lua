--ProtocolProcessorWndSpace.lua
--@brief	个人空间协议
--@date  	2016/1/11
--@author 	SunShanshan


ProtocolProcessorWndSpace = ProtocolProcessorBase:new()

-------------------------------------公有方法模块--------------------------------------

--@brief	注册协议组所有协议
function ProtocolProcessorWndSpace:regAll()
	WZLog("ProtocolProcessorWndSpace:regAll")
	--@brief	获取玩家空间信息（SPACE_GetSpaceInfo = 1）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SPACE, Protocol.SPACE_GetSpaceInfo, "ProtocolProcessorWndSpace:send_SPACE_GetSpaceInfo_ErrorProcess", "is" )
	--@brief	更新个人资料（SPACE_UpdatePlayerInfo = 3）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SPACE, Protocol.SPACE_UpdatePlayerInfo, "ProtocolProcessorWndSpace:send_SPACE_UpdatePlayerInfo_ErrorProcess", "is" )
	--@brief	更换头像（SPACE_UpdateHeadScul = 4）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SPACE, Protocol.SPACE_UpdateHeadScul, "ProtocolProcessorWndSpace:send_SPACE_UpdateHeadScul_ErrorProcess", "is" )
	--@brief	更换坐标（SPACE_UpdateGPSInfo = 5）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SPACE, Protocol.SPACE_UpdateGPSInfo, "ProtocolProcessorWndSpace:send_SPACE_UpdateGPSInfo_ErrorProcess", "is" )
	--@brief	购买礼物（SPACE_BuyGift = 6）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SPACE, Protocol.SPACE_BuyGift, "ProtocolProcessorWndSpace:send_SPACE_BuyGift_ErrorProcess", "is" )
	--@brief	获取最近访客列表（SPACE_GetVisitorsList = 7）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SPACE, Protocol.SPACE_GetVisitorsList, "ProtocolProcessorWndSpace:send_SPACE_GetVisitorsList_ErrorProcess", "is" )
	--@brief	获取留言列表（SPACE_GetMessageList = 9）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SPACE, Protocol.SPACE_GetMessageList, "ProtocolProcessorWndSpace:send_SPACE_GetMessageList_ErrorProcess", "is" )
	--@brief	发送留言（SPACE_SendMessage = 11）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SPACE, Protocol.SPACE_SendMessage, "ProtocolProcessorWndSpace:send_SPACE_SendMessage_ErrorProcess", "is" )
	--@brief	删除留言（SPACE_DelMessage = 12）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SPACE, Protocol.SPACE_DelMessage, "ProtocolProcessorWndSpace:send_SPACE_DelMessage_ErrorProcess", "is" )
	--@brief	获取照片列表（SPACE_GetPhotoList = 13）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SPACE, Protocol.SPACE_GetPhotoList, "ProtocolProcessorWndSpace:send_SPACE_GetPhotoList_ErrorProcess", "is" )
	--@brief	上传照片（SPACE_SetPhotoUrl = 15）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SPACE, Protocol.SPACE_SetPhotoUrl, "ProtocolProcessorWndSpace:send_SPACE_SetPhotoUrl_ErrorProcess", "is" )
	--@brief	删除照片（SPACE_DelPhoto = 16）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SPACE, Protocol.SPACE_DelPhoto, "ProtocolProcessorWndSpace:send_SPACE_DelPhoto_ErrorProcess", "is" )
	--@brief	获取踩一踩列表（SPACE_GetJoinList = 17）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SPACE, Protocol.SPACE_GetJoinList, "ProtocolProcessorWndSpace:send_SPACE_GetJoinList_ErrorProcess", "is" )
	--@brief	踩一踩（SPACE_JoinPlayer = 19）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SPACE, Protocol.SPACE_JoinPlayer, "ProtocolProcessorWndSpace:send_SPACE_JoinPlayer_ErrorProcess", "is" )
	--@brief	获取鲜花记录列表（SPACE_GetFlowersList = 21）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SPACE, Protocol.SPACE_GetFlowersList, "ProtocolProcessorWndSpace:send_SPACE_GetFlowersList_ErrorProcess", "is" )
	--@brief	送鲜花（SPACE_GiveFlowers = 23）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SPACE, Protocol.SPACE_GiveFlowers, "ProtocolProcessorWndSpace:send_SPACE_GiveFlowers_ErrorProcess", "is" )
	--@brief	设置坐标（SPACE_SetGPSInfo = 25）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SPACE, Protocol.SPACE_SetGPSInfo, "ProtocolProcessorWndSpace:send_SPACE_SetGPSInfo_ErrorProcess", "is" )
	--@brief	魅力空间-获取推荐列表（SPACE_GetRecommendList = 26）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SPACE, Protocol.SPACE_GetRecommendList , "ProtocolProcessorWndSpace:send_SPACE_GetRecommendList _ErrorProcess", "is" )
	--@brief	魅力空间-搜索玩家（SPACE_SearchPlayer = 28）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SPACE, Protocol.SPACE_SearchPlayer, "ProtocolProcessorWndSpace:send_SPACE_SearchPlayer_ErrorProcess", "is" )
	--@brief	魅力时装-获取推荐列表（SPACE_GetFashionRecommendList = 61）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SPACE, Protocol.SPACE_GetFashionRecommendList, "ProtocolProcessorWndSpace:send_SPACE_GetFashionRecommendList_ErrorProcess", "is" )
	--@brief	点赞（SPACE_GiveLike = 63）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SPACE, Protocol.SPACE_GiveLike, "ProtocolProcessorWndSpace:send_SPACE_GiveLike_ErrorProcess", "is" )
	--@brief	魅力时装-搜索玩家（SPACE_SearchFashionPlayer = 65）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SPACE, Protocol.SPACE_SearchFashionPlayer, "ProtocolProcessorWndSpace:send_SPACE_SearchFashionPlayer_ErrorProcess", "is" )
	--@brief	魅力时装-获取魅力时装信息（SPACE_GetCharmFashionInfo = 67）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SPACE, Protocol.SPACE_GetCharmFashionInfo, "ProtocolProcessorWndSpace:send_SPACE_GetCharmFashionInfo_ErrorProcess", "is" )
	--@brief	魅力时装-报名或推荐（SPACE_Operation = 69）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SPACE, Protocol.SPACE_Operation, "ProtocolProcessorWndSpace:send_SPACE_Operation_ErrorProcess", "is" )
	--@brief	魅力时装-获取历届排名列表（SPACE_GetFashionPreviousList = 71）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SPACE, Protocol.SPACE_GetFashionPreviousList, "ProtocolProcessorWndSpace:send_SPACE_GetFashionPreviousList_ErrorProcess", "is" )
	--@brief	解锁照片槽（SPACE_UnlockPhoto = 75）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SPACE, Protocol.SPACE_UnlockPhoto, "ProtocolProcessorWndSpace:send_SPACE_UnlockPhoto_ErrorProcess", "is" )


	--@brief	获取玩家空间信息（SPACE_GetSpaceInfoOk = 2）
	self:regProtocolCallbackFunction( Protocol.MAIN_SPACE, Protocol.SPACE_GetSpaceInfoOk, "ProtocolProcessorWndSpace:parse_SPACE_GetSpaceInfoOk", "isiisssissiissiiiivsiiiibivsvsvssivivi")
	--@brief	获取最近访客列表（SPACE_GetVisitorsListOk = 8）
	self:regProtocolCallbackFunction( Protocol.MAIN_SPACE, Protocol.SPACE_GetVisitorsListOk, "ProtocolProcessorWndSpace:parse_SPACE_GetVisitorsListOk", "vivsvivsvsiivi")
	--@brief	获取留言列表（SPACE_GetMessageListOk = 10）
	self:regProtocolCallbackFunction( Protocol.MAIN_SPACE, Protocol.SPACE_GetMessageListOk, "ProtocolProcessorWndSpace:parse_SPACE_GetMessageListOk", "vivsvivsvsvivsvi")
	--@brief	获取照片列表（SPACE_GetPhotoListOk = 14）
	self:regProtocolCallbackFunction( Protocol.MAIN_SPACE, Protocol.SPACE_GetPhotoListOk, "ProtocolProcessorWndSpace:parse_SPACE_GetPhotoListOk", "vsvi")
	--@brief	获取踩一踩列表（SPACE_GetJoinListOk = 18）
	self:regProtocolCallbackFunction( Protocol.MAIN_SPACE, Protocol.SPACE_GetJoinListOk, "ProtocolProcessorWndSpace:parse_SPACE_GetJoinListOk", "vivsvivsvbiivi")
	--@brief	踩一踩结果（SPACE_JoinPlayerResult = 20）
	self:regProtocolCallbackFunction( Protocol.MAIN_SPACE, Protocol.SPACE_JoinPlayerResult, "ProtocolProcessorWndSpace:parse_SPACE_JoinPlayerResult", "ivivi")
	--@brief	获取鲜花记录列表（SPACE_GetFlowersListOk = 22）
	self:regProtocolCallbackFunction( Protocol.MAIN_SPACE, Protocol.SPACE_GetFlowersListOk, "ProtocolProcessorWndSpace:parse_SPACE_GetFlowersListOk", "vivsvivsviiivi")
	--@brief	踩一踩结果（SPACE_GiveFlowersResult = 24）
	self:regProtocolCallbackFunction( Protocol.MAIN_SPACE, Protocol.SPACE_GiveFlowersResult, "ProtocolProcessorWndSpace:parse_SPACE_GiveFlowersResult", "i")
	--@brief	魅力空间-获取推荐列表（SPACE_GetRecommendListOk = 27）
	self:regProtocolCallbackFunction( Protocol.MAIN_SPACE, Protocol.SPACE_GetRecommendListOk, "ProtocolProcessorWndSpace:parse_SPACE_GetRecommendListOk", "vivsvsvivivi")
	--@brief	魅力空间-搜索玩家结果（SPACE_SearchPlayerOk = 29）
	self:regProtocolCallbackFunction( Protocol.MAIN_SPACE, Protocol.SPACE_SearchPlayerOk, "ProtocolProcessorWndSpace:parse_SPACE_SearchPlayerOk", "issiii")
	--@brief	跨服空间错误消息（SPACE_SpaceError = 30）
	self:regProtocolCallbackFunction( Protocol.MAIN_SPACE, Protocol.SPACE_SpaceError, "ProtocolProcessorWndSpace:parse_SPACE_SpaceError", "is")
	--@brief	魅力时装-获取推荐列表（SPACE_GetFashionRecommendListOk = 62）
	self:regProtocolCallbackFunction( Protocol.MAIN_SPACE, Protocol.SPACE_GetFashionRecommendListOk, "ProtocolProcessorWndSpace:parse_SPACE_GetFashionRecommendListOk", "ivivsvivivivivivivivtvtviviii")
	--@brief	点赞结果（SPACE_GiveLikeResult = 64）
	self:regProtocolCallbackFunction( Protocol.MAIN_SPACE, Protocol.SPACE_GiveLikeResult, "ProtocolProcessorWndSpace:parse_SPACE_GiveLikeResult", "iii")
	--@brief	魅力时装-搜索玩家结果（SPACE_SearchFashionPlayerOk = 66）
	self:regProtocolCallbackFunction( Protocol.MAIN_SPACE, Protocol.SPACE_SearchFashionPlayerOk, "ProtocolProcessorWndSpace:parse_SPACE_SearchFashionPlayerOk", "iisiiiiiiittii")
	--@brief	魅力时装-获取魅力时装信息（SPACE_GetCharmFashionInfoOk = 68）
	self:regProtocolCallbackFunction( Protocol.MAIN_SPACE, Protocol.SPACE_GetCharmFashionInfoOk, "ProtocolProcessorWndSpace:parse_SPACE_GetCharmFashionInfoOk", "iisiiiiiiitiiii")
	--@brief	魅力时装-报名或推荐结果（SPACE_OperationOk = 70）
	self:regProtocolCallbackFunction( Protocol.MAIN_SPACE, Protocol.SPACE_OperationOk, "ProtocolProcessorWndSpace:parse_SPACE_OperationOk", "iiii")
	--@brief	魅力时装-获取历届排名列表（SPACE_GetFashionPreviousListOk = 72）
	self:regProtocolCallbackFunction( Protocol.MAIN_SPACE, Protocol.SPACE_GetFashionPreviousListOk, "ProtocolProcessorWndSpace:parse_SPACE_GetFashionPreviousListOk", "vivsvivivivivivivivtvtvii")
	--@brief	解锁照片槽（SPACE_UnlockPhotoResult = 76）
	self:regProtocolCallbackFunction( Protocol.MAIN_SPACE, Protocol.SPACE_UnlockPhotoResult, "ProtocolProcessorWndSpace:parse_SPACE_UnlockPhotoResult", "i")
end

--@brief	反注册协议组所有协议
function ProtocolProcessorWndSpace:unregAll()
	WZLog("ProtocolProcessorWndSpace:unregAll")
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief	获取玩家空间信息（SPACE_GetSpaceInfo = 1）
function ProtocolProcessorWndSpace:send_SPACE_GetSpaceInfo(playerId  )
	WZLog("send_SPACE_GetSpaceInfo")
	local sender = Protocol:getSender( Protocol.MAIN_SPACE, Protocol.SPACE_GetSpaceInfo )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerId  )	-- 角色Id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	更新个人资料（SPACE_UpdatePlayerInfo = 3）
function ProtocolProcessorWndSpace:send_SPACE_UpdatePlayerInfo(playerSex, birthday, playerAge, playerCon, voiceInfo, locSeting, pahSeting, msgSeting, cityCode)
	WZLog("send_SPACE_UpdatePlayerInfo")
	local sender = Protocol:getSender( Protocol.MAIN_SPACE, Protocol.SPACE_UpdatePlayerInfo )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerSex )	-- 角色性别
	sender:writeString( birthday )	-- 语音信息
	sender:writeInt( playerAge )	-- 年龄
	sender:writeInt( playerCon )	-- 星座
	sender:writeString( voiceInfo )	-- 语音信息
	sender:writeInt( locSeting )	-- 星座
	sender:writeInt( pahSeting )	-- 星座
	sender:writeInt( msgSeting )	-- 星座
	sender:writeInt( cityCode or 0 )	-- 城市码
	SendProtocol(sender,false) --true:showLoading
end

--@brief	更换头像（SPACE_UpdateHeadScul = 4）
function ProtocolProcessorWndSpace:send_SPACE_UpdateHeadScul(index )
	WZLog("send_SPACE_UpdateHeadScul")
	local sender = Protocol:getSender( Protocol.MAIN_SPACE, Protocol.SPACE_UpdateHeadScul )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( index )	-- 头像索引
	SendProtocol(sender,false) --true:showLoading
end

--@brief	更换坐标（SPACE_UpdateGPSInfo = 5）
function ProtocolProcessorWndSpace:send_SPACE_UpdateGPSInfo(playerId , longitude, latitude )
	WZLog("send_SPACE_UpdateGPSInfo")
	local sender = Protocol:getSender( Protocol.MAIN_SPACE, Protocol.SPACE_UpdateGPSInfo )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerId  )	-- 角色Id
	sender:writeInt( longitude )	-- 经度
	sender:writeInt( latitude )	-- 纬度
	SendProtocol(sender,false) --true:showLoading
end

--@brief	购买礼物（SPACE_BuyGift = 6）
function ProtocolProcessorWndSpace:send_SPACE_BuyGift(giftNum )
	WZLog("send_SPACE_BuyGift")
	local sender = Protocol:getSender( Protocol.MAIN_SPACE, Protocol.SPACE_BuyGift )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( giftNum )	-- 购买的数量
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取最近访客列表（SPACE_GetVisitorsList = 7）
function ProtocolProcessorWndSpace:send_SPACE_GetVisitorsList( )
	WZLog("send_SPACE_GetVisitorsList")
	local sender = Protocol:getSender( Protocol.MAIN_SPACE, Protocol.SPACE_GetVisitorsList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取留言列表（SPACE_GetMessageList = 9）
function ProtocolProcessorWndSpace:send_SPACE_GetMessageList(playerId  )
	WZLog("send_SPACE_GetMessageList")
	local sender = Protocol:getSender( Protocol.MAIN_SPACE, Protocol.SPACE_GetMessageList )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerId  )	-- 角色Id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	发送留言（SPACE_SendMessage = 11）
function ProtocolProcessorWndSpace:send_SPACE_SendMessage(playerId , messages )
	WZLog("send_SPACE_SendMessage")
	local sender = Protocol:getSender( Protocol.MAIN_SPACE, Protocol.SPACE_SendMessage )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerId  )	-- 角色Id
	sender:writeString( messages )	-- 留言内容
	SendProtocol(sender,false) --true:showLoading
end

--@brief	删除留言（SPACE_DelMessage = 12）
function ProtocolProcessorWndSpace:send_SPACE_DelMessage(index  )
	WZLog("send_SPACE_DelMessage")
	local sender = Protocol:getSender( Protocol.MAIN_SPACE, Protocol.SPACE_DelMessage )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( index  )	-- 留言的索引
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取照片列表（SPACE_GetPhotoList = 13）
function ProtocolProcessorWndSpace:send_SPACE_GetPhotoList(playerId  )
	WZLog("send_SPACE_GetPhotoList")
	local sender = Protocol:getSender( Protocol.MAIN_SPACE, Protocol.SPACE_GetPhotoList )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerId  )	-- 角色Id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	上传照片（SPACE_SetPhotoUrl = 15）
function ProtocolProcessorWndSpace:send_SPACE_SetPhotoUrl(index , photoUrl )
	WZLog("send_SPACE_SetPhotoUrl", index, photoUrl)
	if photoUrl == nil or photoUrl == "" then
		return
	end
	WZLog("send_SPACE_SetPhotoUrl 1", index, photoUrl)
	local sender = Protocol:getSender( Protocol.MAIN_SPACE, Protocol.SPACE_SetPhotoUrl )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( index  )	-- 设置栏位的索引
	sender:writeString( photoUrl )	-- 图片的url
	SendProtocol(sender,false) --true:showLoading
end

--@brief	删除照片（SPACE_DelPhoto = 16）
function ProtocolProcessorWndSpace:send_SPACE_DelPhoto(index  )
	WZLog("send_SPACE_DelPhoto")
	local sender = Protocol:getSender( Protocol.MAIN_SPACE, Protocol.SPACE_DelPhoto )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( index  )	-- 删除栏位的索引
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取踩一踩列表（SPACE_GetJoinList = 17）
function ProtocolProcessorWndSpace:send_SPACE_GetJoinList(playerId  )
	WZLog("send_SPACE_GetJoinList")
	local sender = Protocol:getSender( Protocol.MAIN_SPACE, Protocol.SPACE_GetJoinList )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerId  )	-- 角色Id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	踩一踩（SPACE_JoinPlayer = 19）
function ProtocolProcessorWndSpace:send_SPACE_JoinPlayer(playerId  )
	WZLog("send_SPACE_JoinPlayer")
	local sender = Protocol:getSender( Protocol.MAIN_SPACE, Protocol.SPACE_JoinPlayer )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerId  )	-- 角色Id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取鲜花记录列表（SPACE_GetFlowersList = 21）
function ProtocolProcessorWndSpace:send_SPACE_GetFlowersList(playerId  )
	WZLog("send_SPACE_GetFlowersList")
	local sender = Protocol:getSender( Protocol.MAIN_SPACE, Protocol.SPACE_GetFlowersList )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerId  )	-- 角色Id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	送鲜花（SPACE_GiveFlowers = 23）
function ProtocolProcessorWndSpace:send_SPACE_GiveFlowers(playerId , flowersId )
	WZLog("send_SPACE_GiveFlowers")
	local sender = Protocol:getSender( Protocol.MAIN_SPACE, Protocol.SPACE_GiveFlowers )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerId  )	-- 角色Id
	sender:writeInt( flowersId )	-- 赠送礼物ID
	SendProtocol(sender,false) --true:showLoading
end

--@brief	设置坐标（SPACE_SetGPSInfo = 25）
function ProtocolProcessorWndSpace:send_SPACE_SetGPSInfo(longitude, latitude )
	WZLog("send_SPACE_SetGPSInfo")
	local sender = Protocol:getSender( Protocol.MAIN_SPACE, Protocol.SPACE_SetGPSInfo )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( longitude )	-- 经度
	sender:writeInt( latitude )	-- 纬度
	SendProtocol(sender,false) --true:showLoading
end

--@brief	魅力空间-获取推荐列表（SPACE_GetRecommendList = 26）
function ProtocolProcessorWndSpace:send_SPACE_GetRecommendList(sex, recommendType)
	WZLog("send_SPACE_GetRecommendList")
	local sender = Protocol:getSender( Protocol.MAIN_SPACE, Protocol.SPACE_GetRecommendList )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( sex )	-- 性别(0:男,1:女,2:无)
	sender:writeInt( recommendType or 0 )	-- 0魅力空间 1魅力人气
	SendProtocol(sender,false) --true:showLoading
end

--@brief	魅力空间-搜索玩家（SPACE_SearchPlayer = 28）
function ProtocolProcessorWndSpace:send_SPACE_SearchPlayer(playerID, recommendType)
	WZLog("send_SPACE_SearchPlayer")
	local sender = Protocol:getSender( Protocol.MAIN_SPACE, Protocol.SPACE_SearchPlayer )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerID )	-- 玩家ID
	sender:writeInt( recommendType or 0 )	-- 0魅力空间 1魅力人气
	SendProtocol(sender,false) --true:showLoading
end

--@brief	魅力时装-获取推荐列表（SPACE_GetFashionRecommendList = 61）
function ProtocolProcessorWndSpace:send_SPACE_GetFashionRecommendList(oType, sex )
	WZLog("send_SPACE_GetFashionRecommendList",oType,sex)
	local sender = Protocol:getSender( Protocol.MAIN_SPACE, Protocol.SPACE_GetFashionRecommendList )
	if sender==nil then WZLog("sender == nil") return end
	sender:writeInt( oType ) --类型（1.魅力时装 2：丑人秀）
	sender:writeInt( sex )	-- 性别(0:男,1:女,2:无)
	SendProtocol(sender,false) --true:showLoading
end

--@brief	点赞（SPACE_GiveLike = 63）
function ProtocolProcessorWndSpace:send_SPACE_GiveLike(oType, playerId  )
	WZLog("send_SPACE_GiveLike",oType,playerId)
	local sender = Protocol:getSender( Protocol.MAIN_SPACE, Protocol.SPACE_GiveLike )
	if sender==nil then WZLog("sender == nil") return end
	sender:writeInt( oType ) --类型（1.魅力时装 2：丑人秀）
	sender:writeInt( playerId  )	-- 角色Id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	魅力时装-搜索玩家（SPACE_SearchFashionPlayer = 65）
function ProtocolProcessorWndSpace:send_SPACE_SearchFashionPlayer(oType, playerId )
	WZLog("send_SPACE_SearchFashionPlayer",oType,playerId)
	local sender = Protocol:getSender( Protocol.MAIN_SPACE, Protocol.SPACE_SearchFashionPlayer )
	if sender==nil then WZLog("sender == nil") return end
	sender:writeInt( oType ) --类型（1.魅力时装 2：丑人秀）
	sender:writeInt( playerId )	-- 玩家id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	魅力时装-获取魅力时装信息（SPACE_GetCharmFashionInfo = 67）
function ProtocolProcessorWndSpace:send_SPACE_GetCharmFashionInfo( oType)
	WZLog("send_SPACE_GetCharmFashionInfo",oType)
	local sender = Protocol:getSender( Protocol.MAIN_SPACE, Protocol.SPACE_GetCharmFashionInfo )
	if sender==nil then WZLog("sender == nil") return end
	sender:writeInt( oType )
	SendProtocol(sender,false) --true:showLoading
end

--@brief	魅力时装-报名或推荐（SPACE_Operation = 69）
function ProtocolProcessorWndSpace:send_SPACE_Operation(oType,operationType )
	WZLog("send_SPACE_Operation",oType,operationType)
	local sender = Protocol:getSender( Protocol.MAIN_SPACE, Protocol.SPACE_Operation )
	if sender==nil then WZLog("sender == nil") return end
	sender:writeInt( oType ) --类型（1.魅力时装 2：丑人秀）
	sender:writeInt( operationType )	-- 1报名 2推荐
	SendProtocol(sender,false) --true:showLoading
end

--@brief	魅力时装-获取历届排名列表（SPACE_GetFashionPreviousList = 71）
function ProtocolProcessorWndSpace:send_SPACE_GetFashionPreviousList(rankType )
	WZLog("send_SPACE_GetFashionPreviousList",rankType)
	local sender = Protocol:getSender( Protocol.MAIN_SPACE, Protocol.SPACE_GetFashionPreviousList )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( rankType )	-- 1魅力时装 2魅力空间 3魅力人气 4魅力之王 5仇人秀
	SendProtocol(sender,false) --true:showLoading
end

--@brief	解锁照片槽（SPACE_UnlockPhoto = 75）
function ProtocolProcessorWndSpace:send_SPACE_UnlockPhoto( )
	WZLog("send_SPACE_UnlockPhoto")
	local sender = Protocol:getSender( Protocol.MAIN_SPACE, Protocol.SPACE_UnlockPhoto )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end
-------------------------------------服务器到客户端协议回调方法模块--------------------------------------
--@brief	获取玩家空间信息（SPACE_GetSpaceInfoOk = 2）
function ProtocolProcessorWndSpace:parse_SPACE_GetSpaceInfoOk(playerId , playerName, playerSex, playerLevel, title, headScul, guildName, position, mateName, birthday, playerAge, playerCon, distance, voiceInfo, giftNum, popularity, charmNum, giftPrice, visitorsInfos, locSeting, pahSeting, msgSeting, todayGFNum, beGFLower, serverId, flowersInfo, joinInfo, friendsTop3Info, guildInfo, cityCode, advanceEnchantingIds, advanceEnchantingWingIds)
	-- playerId  : 角色Id
	-- playerName : 角色名称
	-- playerSex : 角色性别
	-- playerLevel : 角色等级
	-- title : 称号
	-- headScul : 头像信息
	-- guildName : 公会名称
	-- position : 公会职位
	-- mateName : 伴侣名称
	-- birthday : 生日
	-- playerAge : 年龄
	-- playerCon : 星座
	-- distance : 距离
	-- voiceInfo : 语音信息
	-- giftNum : 礼物数量
	-- popularity : 人气
	-- charmNum : 魅力
	-- giftPrice : 礼物单价
	-- visitorsInfos : 访客信息
	-- flowersInfo : 鲜花羁绊信息
	-- joinInfo : 踩一踩羁绊信息
	-- friendsTop3Info : 好友度前三玩家数据
	-- guildInfo : 公会会长数据
	-- advanceEnchantingIds : 玩家已进阶的套装Id
	WZLog("ProtocolProcessorWndSpace:parse_SPACE_GetSpaceInfoOk",serverId, locSeting, tostring(guildInfo), birthday, playerAge, playerCon, distance)
	WndCheckOther:setData(playerId , playerName, playerSex, playerLevel, title, headScul, guildName, position, mateName, birthday, playerAge, playerCon, distance, voiceInfo, giftNum, popularity, charmNum, giftPrice, visitorsInfos, locSeting, pahSeting, msgSeting, todayGFNum, beGFLower, serverId, VectorToTable(flowersInfo), VectorToTable(joinInfo), VectorToTable(friendsTop3Info), guildInfo, cityCode, VectorToTable(advanceEnchantingIds), VectorToTable(advanceEnchantingWingIds))
end

--@brief	获取最近访客列表（SPACE_GetVisitorsListOk = 8）
function ProtocolProcessorWndSpace:parse_SPACE_GetVisitorsListOk(playerId , playerName, playerLevel, headScul, interviewTime, visitorsNum, todayNum, serverId)
	-- playerId  : 角色Id
	-- playerName : 角色名称
	-- playerLevel : 角色等级
	-- headScul : 头像信息
	-- interviewTime : 访问时间
	-- visitorsNum : 总访客量
	-- todayNum : 今日访客量
	WZLog("ProtocolProcessorWndSpace:parse_SPACE_GetVisitorsListOk", serverId)
	WndCheckOther:closeLoading()
	WndSpaceRecord:setData3(playerId , playerName, playerLevel, headScul, interviewTime, visitorsNum, todayNum, serverId)
end

--@brief	获取留言列表（SPACE_GetMessageListOk = 10）
function ProtocolProcessorWndSpace:parse_SPACE_GetMessageListOk(playerId , playerName, playerLevel, headScul, sendTime, index, messages, serverId)
	-- playerId  : 角色Id
	-- playerName : 角色名称
	-- playerLevel : 角色等级
	-- headScul : 头像信息
	-- sendTime : 留言时间
	-- index : 留言的索引
	-- messages : 留言内容
	WZLog("ProtocolProcessorWndSpace:parse_SPACE_GetMessageListOk", serverId)
	WndCheckOther:closeLoading()
	if WndSpaceMessage.m_root then 
		WndSpaceMessage:setData(playerId , playerName, playerLevel, headScul, sendTime, index, messages, serverId)
		return 
	end
	if WndCheckOther.m_root then 
		WndCheckOther:setMessageData(VectorToTable(messages))
	end
end

--@brief	获取照片列表（SPACE_GetPhotoListOk = 14）
function ProtocolProcessorWndSpace:parse_SPACE_GetPhotoListOk(photoUrl, photoStatus)
	-- photoUrl : 照片地址
	-- photoStatus : 照片状态 1未开启，2未上传，3未审核，4已审核
	WZLog("ProtocolProcessorWndSpace:parse_SPACE_GetPhotoListOk", Serialize(VectorToTable(photoUrl)), Serialize(VectorToTable(photoStatus)))
	WndCheckOther:closeLoading()
	WndCheckOther:setSpacePhotoData(VectorToTable(photoUrl), VectorToTable(photoStatus))
	WndSpacePhoto:setData(photoUrl, photoStatus)
	WndSpacePhotoThree:setData(photoUrl, photoStatus)
end

--@brief	获取踩一踩列表（SPACE_GetJoinListOk = 18）
function ProtocolProcessorWndSpace:parse_SPACE_GetJoinListOk(playerId , playerName, playerLevel, headScul, isAwards, popularity, sendGift, serverId)
	-- playerId  : 角色Id
	-- playerName : 角色名称
	-- playerLevel : 角色等级
	-- headScul : 头像信息
	-- isAwards : 是否获得礼物
	WZLog("ProtocolProcessorWndSpace:parse_SPACE_GetJoinListOk", serverId)
	WndCheckOther:closeLoading()
	WndSpaceRecord:setData1(playerId , playerName, playerLevel, headScul, isAwards, popularity, sendGift, serverId)
end

--@brief	踩一踩结果（SPACE_JoinPlayerResult = 20）
function ProtocolProcessorWndSpace:parse_SPACE_JoinPlayerResult(result, itemId, count)
	-- result : 1获得礼物，2未获得礼物，3重复踩
	-- itemId : 礼物Id
	-- count : 礼物数量
	WZLog("ProtocolProcessorWndSpace:parse_SPACE_JoinPlayerResult", serverId)
	if result == 1 then
		if #VectorToTable(itemId) ~= 0 then
			WndRewardShow:showById(VectorToTable(itemId),VectorToTable(count))
			GetElement(WndRewardShow.m_root,"ttf2_WndRewardShow",WZUILabelTTF):setText(LocalStrings.SPACE29)
		end
	elseif result == 2 then
        MsgBoxManager:showTipBox(LocalStrings.SPACE16)
	elseif result == 3 then
        MsgBoxManager:showTipBox(LocalStrings.SPACE17)
	end
	if WndCheckOther.m_tData ~= nil then
		ProtocolProcessorWndSpace:send_SPACE_GetSpaceInfo(WndCheckOther.m_tData.playerId  )
	end
end

--@brief	获取鲜花记录列表（SPACE_GetFlowersListOk = 22）
function ProtocolProcessorWndSpace:parse_SPACE_GetFlowersListOk(playerId , playerName, playerLevel, headScul, flowersId, visitorsNum, todayNum, serverId)
	-- playerId  : 角色Id
	-- playerName : 角色名称
	-- playerLevel : 角色等级
	-- headScul : 头像信息
	-- flowersId : 赠送礼物ID
	-- visitorsNum : 总访客量
	-- todayNum : 今日访客量
	WZLog("ProtocolProcessorWndSpace:parse_SPACE_GetFlowersListOk", serverId)
	WndCheckOther:closeLoading()
	WndSpaceRecord:setData2(playerId , playerName, playerLevel, headScul, flowersId, visitorsNum, todayNum, serverId)
end

--@brief	踩一踩结果（SPACE_GiveFlowersResult = 24）
function ProtocolProcessorWndSpace:parse_SPACE_GiveFlowersResult(result)
	-- result : 1送礼成功，2赠送次数超限,3该玩家已赠送
	WZLog("ProtocolProcessorWndSpace:parse_SPACE_GiveFlowersResult")
	if result == 1 then
		--送鲜花次数加一
		if WndCheckOther and WndCheckOther.m_tData and WndCheckOther.m_tData.todayGFNum ~= nil then
			WndCheckOther.m_tData.todayGFNum = WndCheckOther.m_tData.todayGFNum + 1
			WndSpaceSendFlower:update()
			ProtocolProcessorWndSpace:send_SPACE_GetSpaceInfo(WndCheckOther.m_tData.playerId  )
		end
		--活力满时不能使用加活力物品
		if tonumber(CacheCenter:getPlayerInfo().vigor) >= 1000 then
			MsgBoxManager:showTipBox(LocalStrings.TIPS10)
			self:onCloseClick()
			return
		end
		if WndCheckOther.m_nFlowerNum ~= nil and WndCheckOther.m_nProfit ~= nil then
        	--MsgBoxManager:showTipBox(string.format(LocalStrings.SPACE18,WndCheckOther.m_nFlowerNum,WndCheckOther.m_nProfit))
			MsgBoxManager:showTipBox(string.format(LocalStrings.SPACE105,WndCheckOther.m_nProfit))
		end
	elseif result == 2 then
        MsgBoxManager:showTipBox(LocalStrings.SPACE106)
	elseif result == 3 then
        MsgBoxManager:showTipBox(LocalStrings.SPACE107)
	end
end

--@brief	魅力空间-获取推荐列表（SPACE_GetRecommendListOk = 27）
function ProtocolProcessorWndSpace:parse_SPACE_GetRecommendListOk(playerIds, playerNames, photoUrl, sexs, cross, level)
	-- playerIds : 玩家id
	-- playerNames : 玩家名称
	-- photoUrl : 照片链接
	-- sexs : 性别
	-- cross : 是否跨服
	-- level : 等级
	WZLog("ProtocolProcessorWndSpace:parse_SPACE_GetRecommendListOk")
	WndCharmSpace:setData1(VectorToTable(playerIds),VectorToTable(playerNames),VectorToTable(photoUrl),VectorToTable(sexs),VectorToTable(cross),VectorToTable(level))
end

--@brief	魅力空间-搜索玩家结果（SPACE_SearchPlayerOk = 29）
function ProtocolProcessorWndSpace:parse_SPACE_SearchPlayerOk(playerId, playerName, photoUrl, sex, cross, level)
	-- playerId : 玩家id
	-- playerName : 玩家名称
	-- photoUrl : 照片链接
	-- sex : 性别
	-- cross : 是否跨服
	-- level : 等级
	WZLog("ProtocolProcessorWndSpace:parse_SPACE_SearchPlayerOk")
	WndCharmSpace:setData2(playerId,playerName,photoUrl,sex,cross,level)
end

--@brief	跨服空间错误消息（SPACE_SpaceError = 30）
function ProtocolProcessorWndSpace:parse_SPACE_SpaceError(errorCode, tip)
	-- errorCode : 1空间非好友不能留言
	-- tip : 错误提示信息
	WZLog("ProtocolProcessorWndSpace:parse_SPACE_SpaceError")
	MsgBoxManager:showTipBox(tip)
end

--@brief	魅力时装-获取推荐列表（SPACE_GetFashionRecommendListOk = 62）
function ProtocolProcessorWndSpace:parse_SPACE_GetFashionRecommendListOk(oType, playerId, name, level, headId, faceId, bodyId, wingId, headColor, bodyColor, cross, sex, like, isRecomm, likeNum, totalLikeNum)
	-- name : 名称
	-- cross : 是否跨服
	-- sex : 性别
	-- like : 点赞数
	-- isRecomm : 是否推荐 0不推荐 1推荐
	-- likeNum : 剩余点赞数
	WZLog("ProtocolProcessorWndSpace:parse_SPACE_GetFashionRecommendListOk",oType)

	WndCharmSpace:getFashionRecommendDataOK(oType, VectorToTable(playerId), VectorToTable(name), VectorToTable(level), VectorToTable(headId), VectorToTable(faceId), VectorToTable(bodyId), VectorToTable(wingId), VectorToTable(headColor), VectorToTable(bodyColor), VectorToTable(cross), VectorToTable(sex), VectorToTable(like), VectorToTable(isRecomm), likeNum, totalLikeNum)
end

--@brief	点赞结果（SPACE_GiveLikeResult = 64）
function ProtocolProcessorWndSpace:parse_SPACE_GiveLikeResult(oType, result, playerId)
	-- result : 1点赞成功，2点赞次数超限,3该玩家已点赞
	-- 被点赞的玩家Id
	WZLog("ProtocolProcessorWndSpace:parse_SPACE_GiveLikeResult")

	WndCharmSpace:giveGoodOK(oType, result, playerId)
end

--@brief	魅力时装-搜索玩家结果（SPACE_SearchFashionPlayerOk = 66）
function ProtocolProcessorWndSpace:parse_SPACE_SearchFashionPlayerOk(oType, playerId, name, level, headId, faceId, bodyId, wingId, colour, bodycolour, cross, sex, like, isRecomm)
	-- playerId : 玩家id
	-- name : 名称
	-- level : 玩家等级
	-- headId : 头
	-- faceId : 脸
	-- bodyId : 身
	-- wingId : 身
	-- colour : 头部颜色
	-- bodycolour : 身颜色
	-- cross : 是否跨服
	-- sex : 性别
	-- like : 点赞数
	-- isRecomm : 是否推荐 0不推荐 1推荐
	WZLog("ProtocolProcessorWndSpace:parse_SPACE_SearchFashionPlayerOk",oType,playerId,like,isRecomm)

	WndCharmSpace:searchFashionPlayerOK(oType, playerId, name, level, headId, faceId, bodyId, wingId, colour, bodycolour, cross, sex, like, isRecomm)
end

--@brief	魅力时装-获取魅力时装信息（SPACE_GetCharmFashionInfoOk = 68）
function ProtocolProcessorWndSpace:parse_SPACE_GetCharmFashionInfoOk(oType, playerId, playerName, level, headId, faceId, bodyId, wingId, colour, bodyColor, sex, like, isApply, time, isRecomm)
	-- playerId : 玩家id
	-- playerName : 玩家名称
	-- level : 玩家等级
	-- headId : 头
	-- faceId : 脸
	-- bodyId : 身
	-- wingId : 翅膀
	-- colour : 头部颜色
	-- sex : 性别
	-- like : 点赞数
	-- isApply : 是否报名 0未报名 1已报名
	-- time : 推荐剩余时间（秒）
	-- isRecomm : 是否推荐 0未推荐 1已推荐
	WZLog("ProtocolProcessorWndSpace:parse_SPACE_GetCharmFashionInfoOk",oType)

	WndCharmSpace:getPlayerFashionInfoOK(oType, playerId, playerName, level, headId, faceId, bodyId, wingId, colour, bodyColor, sex, like, isApply, time, isRecomm)
end

--@brief	魅力时装-报名或推荐结果（SPACE_OperationOk = 70）
function ProtocolProcessorWndSpace:parse_SPACE_OperationOk(oType, operationType, result, time)
	-- result : 0成功 1失败
	-- time : 推荐剩余时间（秒）
	-- operationType : 操作类型
	WZLog("ProtocolProcessorWndSpace:parse_SPACE_OperationOk",oType, operationType, result, time)

	WndCharmSpace:applyOrRecommendSuccess(oType, result, time, operationType)
end

--@brief	魅力时装-获取历届排名列表（SPACE_GetFashionPreviousListOk = 72）
function ProtocolProcessorWndSpace:parse_SPACE_GetFashionPreviousListOk(playerId, name, level, headId, faceId, bodyId, wingId, headColor, bodyColor, cross, sex, periodNum, rankType)
	-- playerId : 玩家id
	-- playerName : 玩家名称
	-- level : 玩家等级
	-- headId : 头
	-- faceId : 脸
	-- bodyId : 身
	-- wingId : 翅膀
	-- colour : 头部颜色
	-- bodyColor : 身颜色
	-- cross : 是否跨服
	-- sex : 性别
	-- periodNum : 届数
	WZLog("ProtocolProcessorWndSpace:parse_SPACE_GetFashionPreviousListOk",
		"\nplayerId=",Serialize(VectorToTable(playerId)),
		"\nname=",Serialize(VectorToTable(name)),
		"\nlevel=",Serialize(VectorToTable(level)),
		"\nheadId=",Serialize(VectorToTable(headId)),
		"\nfaceId=",Serialize(VectorToTable(faceId)),
		"\nbodyId=",Serialize(VectorToTable(bodyId)),
		"\nwingId=",Serialize(VectorToTable(wingId)),
		"\nheadColor=",Serialize(VectorToTable(headColor)),
		"\nbodyColor=",Serialize(VectorToTable(bodyColor)),
		"\ncross=",Serialize(VectorToTable(cross)),
		"\nsex=",Serialize(VectorToTable(sex)),
		"\nperiodNum=",Serialize(VectorToTable(periodNum)),
		"\nrankType=",Serialize(VectorToTable(rankType)))

	WndCharmSpace:getFashionPeriodDataOK(VectorToTable(playerId), VectorToTable(name), VectorToTable(level), VectorToTable(headId), VectorToTable(faceId), VectorToTable(bodyId), VectorToTable(wingId), VectorToTable(headColor), VectorToTable(bodyColor), VectorToTable(cross), VectorToTable(sex), VectorToTable(periodNum), rankType)
end

--@brief	解锁照片槽（SPACE_UnlockPhotoResult = 76）
function ProtocolProcessorWndSpace:parse_SPACE_UnlockPhotoResult(result)
	-- result : 0成功 1失败
	-- time : 推荐剩余时间（秒）
	-- operationType : 操作类型
	WZLog("ProtocolProcessorWndSpace:parse_SPACE_UnlockPhotoResult")

	WndSpacePhoto:unlockSeatResult(result)
	WndSpacePhotoThree:unlockSeatResult(result)
end
-------------------------------------协议错误处理方法模块--------------------------------------
--@brief	获取玩家空间信息（SPACE_GetSpaceInfo = 1）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSpace:send_SPACE_GetSpaceInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSpace:send_SPACE_GetSpaceInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SPACE, Protocol.SPACE_GetSpaceInfo, nflag, sMessage)
	if WndCheckOther.m_root ~= nil then
		WindowManager:removeWindow(WndCheckOther.m_root, WndCheckOther, true)
	end
end

--@brief	更新个人资料（SPACE_UpdatePlayerInfo = 3）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSpace:send_SPACE_UpdatePlayerInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSpace:send_SPACE_UpdatePlayerInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SPACE, Protocol.SPACE_UpdatePlayerInfo, nflag, sMessage)
end

--@brief	更换头像（SPACE_UpdateHeadScul = 4）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSpace:send_SPACE_UpdateHeadScul_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSpace:send_SPACE_UpdateHeadScul_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SPACE, Protocol.SPACE_UpdateHeadScul, nflag, sMessage)
end

--@brief	更换坐标（SPACE_UpdateGPSInfo = 5）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSpace:send_SPACE_UpdateGPSInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSpace:send_SPACE_UpdateGPSInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SPACE, Protocol.SPACE_UpdateGPSInfo, nflag, sMessage)
end

--@brief	购买礼物（SPACE_BuyGift = 6）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSpace:send_SPACE_BuyGift_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSpace:send_SPACE_BuyGift_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SPACE, Protocol.SPACE_BuyGift, nflag, sMessage)
end

--@brief	获取最近访客列表（SPACE_GetVisitorsList = 7）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSpace:send_SPACE_GetVisitorsList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSpace:send_SPACE_GetVisitorsList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SPACE, Protocol.SPACE_GetVisitorsList, nflag, sMessage)
end

--@brief	获取留言列表（SPACE_GetMessageList = 9）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSpace:send_SPACE_GetMessageList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSpace:send_SPACE_GetMessageList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SPACE, Protocol.SPACE_GetMessageList, nflag, sMessage)
end

--@brief	发送留言（SPACE_SendMessage = 11）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSpace:send_SPACE_SendMessage_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSpace:send_SPACE_SendMessage_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SPACE, Protocol.SPACE_SendMessage, nflag, sMessage)
	WndCheckOther:closeLoading()
    MsgBoxManager:showTipBox(sMessage)
end

--@brief	删除留言（SPACE_DelMessage = 12）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSpace:send_SPACE_DelMessage_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSpace:send_SPACE_DelMessage_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SPACE, Protocol.SPACE_DelMessage, nflag, sMessage)
end

--@brief	获取照片列表（SPACE_GetPhotoList = 13）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSpace:send_SPACE_GetPhotoList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSpace:send_SPACE_GetPhotoList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SPACE, Protocol.SPACE_GetPhotoList, nflag, sMessage)
end

--@brief	上传照片（SPACE_SetPhotoUrl = 15）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSpace:send_SPACE_SetPhotoUrl_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSpace:send_SPACE_SetPhotoUrl_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SPACE, Protocol.SPACE_SetPhotoUrl, nflag, sMessage)
end

--@brief	删除照片（SPACE_DelPhoto = 16）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSpace:send_SPACE_DelPhoto_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSpace:send_SPACE_SetPhoto_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SPACE, Protocol.SPACE_DelPhoto, nflag, sMessage)
end

--@brief	获取踩一踩列表（SPACE_GetJoinList = 17）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSpace:send_SPACE_GetJoinList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSpace:send_SPACE_GetJoinList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SPACE, Protocol.SPACE_GetJoinList, nflag, sMessage)
end

--@brief	踩一踩（SPACE_JoinPlayer = 19）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSpace:send_SPACE_JoinPlayer_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSpace:send_SPACE_JoinPlayer_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SPACE, Protocol.SPACE_JoinPlayer, nflag, sMessage)
end

--@brief	获取鲜花记录列表（SPACE_GetFlowersList = 21）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSpace:send_SPACE_GetFlowersList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSpace:send_SPACE_GetFlowersList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SPACE, Protocol.SPACE_GetFlowersList, nflag, sMessage)
end

--@brief	送鲜花（SPACE_GiveFlowers = 23）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSpace:send_SPACE_GiveFlowers_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSpace:send_SPACE_GiveFlowers_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SPACE, Protocol.SPACE_GiveFlowers, nflag, sMessage)
end

--@brief	设置坐标（SPACE_SetGPSInfo = 25）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSpace:send_SPACE_SetGPSInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSpace:send_SPACE_SetGPSInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SPACE, Protocol.SPACE_SetGPSInfo, nflag, sMessage)
end

--@brief	魅力空间-搜索玩家（SPACE_SearchPlayer = 28）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSpace:send_SPACE_SearchPlayer_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSpace:send_SPACE_SearchPlayer_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SPACE, Protocol.SPACE_SearchPlayer, nflag, sMessage)
end

--@brief	魅力空间-获取推荐列表（SPACE_GetRecommendList = 26）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSpace:send_SPACE_GetRecommendList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSpace:send_SPACE_GetRecommendList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SPACE, Protocol.SPACE_GetRecommendList, nflag, sMessage)
end

--@brief	魅力时装-获取推荐列表（SPACE_GetFashionRecommendList = 61）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSpace:send_SPACE_GetFashionRecommendList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSpace:send_SPACE_GetFashionRecommendList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SPACE, Protocol.SPACE_GetFashionRecommendList, nflag, sMessage)
end

--@brief	点赞（SPACE_GiveLike = 63）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSpace:send_SPACE_GiveLike_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSpace:send_SPACE_GiveLike_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SPACE, Protocol.SPACE_GiveLike, nflag, sMessage)
end

--@brief	魅力时装-搜索玩家（SPACE_SearchFashionPlayer = 65）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSpace:send_SPACE_SearchFashionPlayer_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSpace:send_SPACE_SearchFashionPlayer_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SPACE, Protocol.SPACE_SearchFashionPlayer, nflag, sMessage)
end

--@brief	魅力时装-获取魅力时装信息（SPACE_GetCharmFashionInfo = 67）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSpace:send_SPACE_GetCharmFashionInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSpace:send_SPACE_GetCharmFashionInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SPACE, Protocol.SPACE_GetCharmFashionInfo, nflag, sMessage)
end

--@brief	魅力时装-报名或推荐（SPACE_Operation = 69）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSpace:send_SPACE_Operation_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSpace:send_SPACE_Operation_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SPACE, Protocol.SPACE_Operation, nflag, sMessage)
end

--@brief	魅力时装-获取历届排名列表（SPACE_GetFashionPreviousList = 71）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSpace:send_SPACE_GetFashionPreviousList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSpace:send_SPACE_GetFashionPreviousList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SPACE, Protocol.SPACE_GetFashionPreviousList, nflag, sMessage)
end

--@brief	解锁照片槽（SPACE_UnlockPhoto = 75）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSpace:send_SPACE_UnlockPhoto_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSpace:send_SPACE_UnlockPhoto_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SPACE, Protocol.SPACE_UnlockPhoto, nflag, sMessage)
end


