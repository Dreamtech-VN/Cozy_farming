--ProtocolProcessorWndSamllGame.lua
--@brief	小游戏相关协议
--@date  	2022/11/11
--@author 	yrd
--@note 	小游戏相关协议


ProtocolProcessorWndSamllGame = ProtocolProcessorBase:new()


--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorWndSamllGame:regAll()
	--@brief	获取小游戏列表（SMALLGAME_GetSmallGameList = 1）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SMALLGAME, Protocol.SMALLGAME_GetSmallGameList, "ProtocolProcessorWndSamllGame:send_SMALLGAME_GetSmallGameList_ErrorProcess", "is")
	--@brief	获取小游戏的信息（SMALLGAME_GetSmallGameInfo = 3）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SMALLGAME, Protocol.SMALLGAME_GetSmallGameInfo, "ProtocolProcessorWndSamllGame:send_SMALLGAME_GetSmallGameInfo_ErrorProcess", "is")
	--@brief	开始游戏（SMALLGAME_StartGame = 5）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SMALLGAME, Protocol.SMALLGAME_StartGame, "ProtocolProcessorWndSamllGame:send_SMALLGAME_StartGame_ErrorProcess", "is")
	--@brief	结束游戏（SMALLGAME_EndGame = 7）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SMALLGAME, Protocol.SMALLGAME_EndGame, "ProtocolProcessorWndSamllGame:send_SMALLGAME_EndGame_ErrorProcess", "is")
	--@brief	小游戏操作（SMALLGAME_SmallGameDo = 9）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SMALLGAME, Protocol.SMALLGAME_SmallGameDo, "ProtocolProcessorWndSamllGame:send_SMALLGAME_SmallGameDo_ErrorProcess", "is")
	--@brief	获取排行榜（SMALLGAME_GetRankingList = 11）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SMALLGAME, Protocol.SMALLGAME_GetRankingList, "ProtocolProcessorWndSamllGame:send_SMALLGAME_GetRankingList_ErrorProcess", "is")


	--@brief	获取小游戏列表OK（SMALLGAME_GetSmallGameListOk = 2）
	self:regProtocolCallbackFunction( Protocol.MAIN_SMALLGAME, Protocol.SMALLGAME_GetSmallGameListOk, "ProtocolProcessorWndSamllGame:parse_SMALLGAME_GetSmallGameListOk", "vivsivi")
	--@brief	获取小游戏的信息OK（SMALLGAME_GetSmallGameInfoOk = 4）
	self:regProtocolCallbackFunction( Protocol.MAIN_SMALLGAME, Protocol.SMALLGAME_GetSmallGameInfoOk, "ProtocolProcessorWndSamllGame:parse_SMALLGAME_GetSmallGameInfoOk", "iss")
	--@brief	开始游戏OK（SMALLGAME_StartGameOk = 6）
	self:regProtocolCallbackFunction( Protocol.MAIN_SMALLGAME, Protocol.SMALLGAME_StartGameOk, "ProtocolProcessorWndSamllGame:parse_SMALLGAME_StartGameOk", "ii")
	--@brief	结束游戏OK（SMALLGAME_EndGameOk = 8）
	self:regProtocolCallbackFunction( Protocol.MAIN_SMALLGAME, Protocol.SMALLGAME_EndGameOk, "ProtocolProcessorWndSamllGame:parse_SMALLGAME_EndGameOk", "iivivivis")
	--@brief	小游戏操作OK（SMALLGAME_SmallGameDoOk = 10）
	self:regProtocolCallbackFunction( Protocol.MAIN_SMALLGAME, Protocol.SMALLGAME_SmallGameDoOk, "ProtocolProcessorWndSamllGame:parse_SMALLGAME_SmallGameDoOk", "iiis")
	--@brief	获取排行榜OK（SMALLGAME_GetRankingListOk = 12）
	self:regProtocolCallbackFunction( Protocol.MAIN_SMALLGAME, Protocol.SMALLGAME_GetRankingListOk, "ProtocolProcessorWndSamllGame:parse_SMALLGAME_GetRankingListOk", "iiiisvivivivsvivivivtvnvnvivivsvsviis")

end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorWndSamllGame:unregAll()
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块Begin--------------------------------------

--@brief	获取小游戏列表（SMALLGAME_GetSmallGameList = 1）
function ProtocolProcessorWndSamllGame:send_SMALLGAME_GetSmallGameList()
	WZLog("send_SMALLGAME_GetSmallGameList")
	local sender = Protocol:getSender( Protocol.MAIN_SMALLGAME, Protocol.SMALLGAME_GetSmallGameList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取小游戏的信息（SMALLGAME_GetSmallGameInfo = 3）
function ProtocolProcessorWndSamllGame:send_SMALLGAME_GetSmallGameInfo(gameType)
	WZLog("send_SMALLGAME_GetSmallGameInfo",gameType)
	local sender = Protocol:getSender( Protocol.MAIN_SMALLGAME, Protocol.SMALLGAME_GetSmallGameInfo )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(gameType)	-- 小游戏类型
	SendProtocol(sender,false) --true:showLoading
end

--@brief	开始游戏（SMALLGAME_StartGame = 5）
function ProtocolProcessorWndSamllGame:send_SMALLGAME_StartGame(gameType, json)
	WZLog("send_SMALLGAME_StartGame", gameType, json)
	local sender = Protocol:getSender( Protocol.MAIN_SMALLGAME, Protocol.SMALLGAME_StartGame )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(gameType)	-- 小游戏类型
	sender:writeString(json)	-- 参数json字符串
	SendProtocol(sender,false) --true:showLoading
end

--@brief	结束游戏（SMALLGAME_EndGame = 7）
function ProtocolProcessorWndSamllGame:send_SMALLGAME_EndGame(gameType, endCode)
	WZLog("send_SMALLGAME_EndGame", gameType, endCode)
	local sender = Protocol:getSender( Protocol.MAIN_SMALLGAME, Protocol.SMALLGAME_EndGame )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(gameType)	-- 小游戏类型
	sender:writeInt(endCode)	-- 游戏结束码[0=胜利|1=失败|2=中途放弃]
	SendProtocol(sender,false) --true:showLoading
end

--@brief	小游戏操作（SMALLGAME_SmallGameDo = 9）
function ProtocolProcessorWndSamllGame:send_SMALLGAME_SmallGameDo(gameType, doType, json)
	WZLog("send_SMALLGAME_SmallGameDo", gameType, doType, Serialize(json))
	local sender = Protocol:getSender( Protocol.MAIN_SMALLGAME, Protocol.SMALLGAME_SmallGameDo )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(gameType)	-- 小游戏类型
	sender:writeInt(doType)	-- 操作类型[目前后端预留了1-10十种操作码，每个小游戏可以自定义这些操作码的具体含义]
	sender:writeString(json)	-- 操作参数json字符串
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取排行榜（SMALLGAME_GetRankingList = 11）
function ProtocolProcessorWndSamllGame:send_SMALLGAME_GetRankingList(gameType, rankingCode)
	WZLog("send_SMALLGAME_GetRankingList", gameType, rankingCode)
	local sender = Protocol:getSender( Protocol.MAIN_SMALLGAME, Protocol.SMALLGAME_GetRankingList )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(gameType)	-- 小游戏类型
	sender:writeInt(rankingCode)	-- 排行榜编号【多个排行榜时使用，从0开始编号，默认传0】
	SendProtocol(sender,false) --true:showLoading
end

-------------------------------------客户端到服务器协议发送方法模块End--------------------------------------


-------------------------------------服务器到客户端协议回调方法模块Begin--------------------------------------

--@brief	获取小游戏列表OK（SMALLGAME_GetSmallGameListOk = 2）
function ProtocolProcessorWndSamllGame:parse_SMALLGAME_GetSmallGameListOk(gameTypes, gameNames, lastGameType, playedGameTypes)
	-- gameTypes : 小游戏类型
	-- gameNames : 小游戏名称
	-- lastGameType : 玩家最近一次玩的小游戏类型
	-- playedGameTypes : 玩家玩过的小游戏类型【预留，先不做】
	WZLog("ProtocolProcessorWndSamllGame:parse_SMALLGAME_GetSmallGameListOk", 
		"\n gameTypes =",Serialize(VectorToTable(gameTypes)), 
		"\n gameNames =",Serialize(VectorToTable(gameNames)), 
		"\n lastGameType =",Serialize(VectorToTable(lastGameType)), 
		"\n playedGameTypes =",Serialize(VectorToTable(playedGameTypes)))

	local gameType = 1000
	ProtocolProcessorWndSamllGame:send_SMALLGAME_GetSmallGameInfo(gameType)
end

--@brief	获取小游戏的信息OK（SMALLGAME_GetSmallGameInfoOk = 4）
function ProtocolProcessorWndSamllGame:parse_SMALLGAME_GetSmallGameInfoOk(gameType, gameName, extInfo)
	-- gameType : 小游戏类型
	-- gameName : 小游戏名称
	-- extInfo : 小游戏自定义数据，json字符串{}
	WZLog("ProtocolProcessorWndSamllGame:parse_SMALLGAME_GetSmallGameInfoOk", gameType, gameName, extInfo)
	if gameType == 1000 then
		SceneYangLeGeYang:getSmallGameInfoOk(gameType,gameName,extInfo)
	end
end

--@brief	开始游戏OK（SMALLGAME_StartGameOk = 6）
function ProtocolProcessorWndSamllGame:parse_SMALLGAME_StartGameOk(gameType, result)
	-- gameType : 小游戏类型
	-- result : 结果【0=成功|其他值=各个游戏自定义】
	WZLog("ProtocolProcessorWndSamllGame:parse_SMALLGAME_StartGameOk", gameType, result)
	if gameType == 1000 then
		SceneYangLeGeYang:startGameOk(gameType, result)
	end
end

--@brief	结束游戏OK（SMALLGAME_EndGameOk = 8）
function ProtocolProcessorWndSamllGame:parse_SMALLGAME_EndGameOk(gameType, result, itemIds, itemNums, itemCounts, sjson)
	-- gameType : 小游戏类型
	-- result : 结果【0=成功|其他值=各个游戏自定义】
	-- itemIds : 奖励道具ID数组，没有时返回空数组
	-- itemNums : 奖励道具数量数组，没有时返回空数组
	-- itemCounts : 多种奖励分组数量。用于将上述的奖励道具进行分组,用不上时返回空数组【预留】
	-- json : json格式内容{}
	WZLog("ProtocolProcessorWndSamllGame:parse_SMALLGAME_EndGameOk", gameType, result, Serialize(VectorToTable(itemIds)), Serialize(VectorToTable(itemNums)), Serialize(VectorToTable(itemCounts)), sjson)
	if gameType == 1000 then
		SceneYangLeGeYang:SMALLGAME_EndGameOk(gameType, result, VectorToTable(itemIds), VectorToTable(itemNums), VectorToTable(itemCounts), sjson)
	end
end

--@brief	小游戏操作OK（SMALLGAME_SmallGameDoOk = 10）
function ProtocolProcessorWndSamllGame:parse_SMALLGAME_SmallGameDoOk(gameType, doType, result, sjson)
	-- gameType : 小游戏类型
	-- doType : 操作码【直接返回客户端请求时传递上来的值】
	-- result : 操作结果【0=成功|其他各个游戏自定义】
	-- json : json格式内容{}
	WZLog("ProtocolProcessorWndSamllGame:parse_SMALLGAME_SmallGameDoOk", gameType, doType, result, sjson)
	if gameType == 1000 then
		SceneYangLeGeYang:smallGameDoOk(gameType, doType, result, sjson)
	end
end

--@brief	获取排行榜OK（SMALLGAME_GetRankingListOk = 12）
function ProtocolProcessorWndSamllGame:parse_SMALLGAME_GetRankingListOk(gameType, rankingCode, myPoint, myRank, rewardConfig, playerIds, ranks, points, nicknames, headIds, headColors, faceIds, sexs, vipLevels, levels, bodyIds, windIds, title, guildName, serverId, season, settlementDate)
	-- gameType : 游戏类型
	-- rankingCode : 排行榜编码
	-- myPoint : 我的积分
	-- myRank : 我的排名 >0 就是有排名了
	-- rewardConfig : 奖励内容
	-- playerIds : 玩家id
	-- ranks : 排名从1开始
	-- points : 积分
	-- nicknames : 昵称
	-- headIds : 头
	-- headColors : 头颜色
	-- faceIds : 脸
	-- sexs : 性别
	-- vipLevels : vip等级
	-- levels : 等级
	-- bodyIds : 身体
	-- windIds : 翅膀
	-- title : 称号
	-- serverId : 服务器id
	-- season : 期数，第几期排行榜
	-- settlementDate : 排行榜结算日期 年-月-日 时:分:秒
	-- guildName : 公会
	WZLog("ProtocolProcessorWndSamllGame:parse_SMALLGAME_GetRankingListOk", 
		"\n gameType = ",Serialize(VectorToTable(gameType)), 
		"\n rankingCode = ",Serialize(VectorToTable(rankingCode)), 
		"\n myPoint = ",Serialize(VectorToTable(myPoint)), 
		"\n myRank = ",Serialize(VectorToTable(myRank)), 
		"\n rewardConfig = ",Serialize(VectorToTable(rewardConfig)), 
		"\n playerIds = ",Serialize(VectorToTable(playerIds)), 
		"\n ranks = ",Serialize(VectorToTable(ranks)), 
		"\n points = ",Serialize(VectorToTable(points)), 
		"\n nicknames = ",Serialize(VectorToTable(nicknames)), 
		"\n headIds = ",Serialize(VectorToTable(headIds)), 
		"\n headColors = ",Serialize(VectorToTable(headColors)), 
		"\n faceIds = ",Serialize(VectorToTable(faceIds)), 
		"\n sexs = ",Serialize(VectorToTable(sexs)), 
		"\n vipLevels = ",Serialize(VectorToTable(vipLevels)), 
		"\n levels = ",Serialize(VectorToTable(levels)), 
		"\n bodyIds = ",Serialize(VectorToTable(bodyIds)), 
		"\n windIds = ",Serialize(VectorToTable(windIds)), 
		"\n title = ",Serialize(VectorToTable(title)), 
		"\n guildName = ",Serialize(VectorToTable(guildName)),
		"\n serverId = ",Serialize(VectorToTable(serverId)), 
		"\n season = ",Serialize(VectorToTable(season)), 
		"\n settlementDate = ",Serialize(VectorToTable(settlementDate))
		)

	if gameType == 1000 then
		if WndTowerRank.m_root then
			WndTowerRank:getYangLeGeYangRankOk(gameType, rankingCode, myPoint, myRank, rewardConfig, VectorToTable(playerIds), VectorToTable(ranks), VectorToTable(points), VectorToTable(nicknames), VectorToTable(headIds), VectorToTable(headColors), VectorToTable(faceIds), VectorToTable(sexs), VectorToTable(vipLevels), VectorToTable(levels), VectorToTable(bodyIds), VectorToTable(windIds), VectorToTable(title), VectorToTable(guildName), VectorToTable(serverId), season, settlementDate)
		end
		if WndYLGYSettlement.m_root then
			WndYLGYSettlement:getYangLeGeYangRankOk(gameType, rankingCode, myPoint, myRank, rewardConfig, VectorToTable(playerIds), VectorToTable(ranks), VectorToTable(points), VectorToTable(nicknames), VectorToTable(headIds), VectorToTable(headColors), VectorToTable(faceIds), VectorToTable(sexs), VectorToTable(vipLevels), VectorToTable(levels), VectorToTable(bodyIds), VectorToTable(windIds), VectorToTable(title), VectorToTable(guildName), VectorToTable(serverId), season, settlementDate)
		end
	end

end

-------------------------------------服务器到客户端协议回调方法模块End--------------------------------------


-------------------------------------协议错误处理方法模块Begin--------------------------------------

--@brief	获取小游戏列表（SMALLGAME_GetSmallGameList = 1）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSamllGame:send_SMALLGAME_GetSmallGameList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSamllGame:parse_SMALLGAME_GetSmallGameList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SMALLGAME, Protocol.SMALLGAME_GetSmallGameList, nflag, sMessage)
end

--@brief	获取小游戏的信息（SMALLGAME_GetSmallGameInfo = 3）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSamllGame:send_SMALLGAME_GetSmallGameInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSamllGame:parse_SMALLGAME_GetSmallGameInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SMALLGAME, Protocol.SMALLGAME_GetSmallGameInfo, nflag, sMessage)
end

--@brief	开始游戏（SMALLGAME_StartGame = 5）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSamllGame:send_SMALLGAME_StartGame_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSamllGame:parse_SMALLGAME_StartGame_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SMALLGAME, Protocol.SMALLGAME_StartGame, nflag, sMessage)
end

--@brief	结束游戏（SMALLGAME_EndGame = 7）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSamllGame:send_SMALLGAME_EndGame_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSamllGame:parse_SMALLGAME_EndGame_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SMALLGAME, Protocol.SMALLGAME_EndGame, nflag, sMessage)
end

--@brief	小游戏操作（SMALLGAME_SmallGameDo = 9）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSamllGame:send_SMALLGAME_SmallGameDo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSamllGame:parse_SMALLGAME_SmallGameDo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SMALLGAME, Protocol.SMALLGAME_SmallGameDo, nflag, sMessage)
end

--@brief	获取排行榜（SMALLGAME_GetRankingList = 11）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSamllGame:send_SMALLGAME_GetRankingList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSamllGame:parse_SMALLGAME_GetRankingList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SMALLGAME, Protocol.SMALLGAME_GetRankingList, nflag, sMessage)
end


-------------------------------------协议错误处理方法模块End--------------------------------------





