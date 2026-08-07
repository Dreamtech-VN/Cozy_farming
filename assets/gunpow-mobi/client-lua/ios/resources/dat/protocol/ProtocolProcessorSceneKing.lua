--ProtocolProcessorSceneKing.lua
--@brief	弹王争霸相关协议
--@date  	2014/5/22
--@author 	zjh
--@note 	弹王争霸相关协议

--local WZLog = print
ProtocolProcessorSceneKing = ProtocolProcessorBase:new()

-------------------------------------公有方法模块--------------------------------------

--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorSceneKing:regAll()

	--@brief	进入入口协议成功
	self:regProtocolCallbackFunction( Protocol.MAIN_KING, Protocol.KING_GetKingStartOK, "ProtocolProcessorSceneKing:parse_KING_GetKingStartOK", "iibii")

	--@brief	进入主界面成功
	self:regProtocolCallbackFunction( Protocol.MAIN_KING, Protocol.KING_GetKingInfoOK, "ProtocolProcessorSceneKing:parse_KING_GetKingInfoOK", "iiiiti")

	--@brief	进入弹王名人榜成功
	self:regProtocolCallbackFunction( Protocol.MAIN_KING, Protocol.KING_GetFameHallOK, "ProtocolProcessorSceneKing:parse_KING_GetFameHallOK", "vivivivsvs")

	--@brief	进入排行榜成功
	self:regProtocolCallbackFunction( Protocol.MAIN_KING, Protocol.KING_GetRankOK, "ProtocolProcessorSceneKing:parse_KING_GetRankOK", "vivsvsviviviiiii")

	--@brief	进入弹王商店
	self:regProtocolCallbackFunction( Protocol.MAIN_KING, Protocol.KING_GetMallInfoOK, "ProtocolProcessorSceneKing:parse_KING_GetMallInfoOK", "viviii")

	--@brief	弹王商店购买成果
	self:regProtocolCallbackFunction( Protocol.MAIN_KING, Protocol.KING_GetMallBuyOK, "ProtocolProcessorSceneKing:parse_KING_GetMallBuyOK", "vi")

	--@brief	进入入口协议错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_KING, Protocol.KING_GetKingStart, "ProtocolProcessorSceneKing:send_KING_GetKingStart_ErrorProcess", "is" )

	--@brief	进入主界面协议错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_KING, Protocol.KING_GetKingInfo, "ProtocolProcessorSceneKing:send_KING_GetKingInfo_ErrorProcess", "is" )

	--@brief	弹王名人错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_KING, Protocol.KING_GetFameHall, "ProtocolProcessorSceneKing:send_KING_GetFameHall_ErrorProcess", "is" )

	--@brief	弹王排行榜错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_KING, Protocol.KING_GetRank, "ProtocolProcessorSceneKing:send_KING_GetRank_ErrorProcess", "is" )

	--@brief	弹王商店错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_KING, Protocol.KING_GetMallInfo, "ProtocolProcessorSceneKing:send_KING_GetMallInfo_ErrorProcess", "is" )

	--@brief	弹王商店购买错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_KING, Protocol.KING_GetMallBuy, "ProtocolProcessorSceneKing:send_KING_GetMallBuy_ErrorProcess", "is" )

end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorSceneKing:unregAll()
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief	进入入口协议
function ProtocolProcessorSceneKing:send_KING_GetKingStart( )
	WZLog("send_KING_GetKingStart")
	local sender = Protocol:getSender( Protocol.MAIN_KING, Protocol.KING_GetKingStart )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	进入主界面协议
function ProtocolProcessorSceneKing:send_KING_GetKingInfo( )
	WZLog("send_KING_GetKingInfo")
	local sender = Protocol:getSender( Protocol.MAIN_KING, Protocol.KING_GetKingInfo )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	弹王名人
function ProtocolProcessorSceneKing:send_KING_GetFameHall( )
	WZLog("send_KING_GetFameHall")
	local sender = Protocol:getSender( Protocol.MAIN_KING, Protocol.KING_GetFameHall )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	弹王排行榜
function ProtocolProcessorSceneKing:send_KING_GetRank( )
	WZLog("send_KING_GetRank")
	local sender = Protocol:getSender( Protocol.MAIN_KING, Protocol.KING_GetRank )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	弹王商店
function ProtocolProcessorSceneKing:send_KING_GetMallInfo( )
	WZLog("send_KING_GetMallInfo")
	local sender = Protocol:getSender( Protocol.MAIN_KING, Protocol.KING_GetMallInfo )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	弹王商店购买
function ProtocolProcessorSceneKing:send_KING_GetMallBuy(kingMallId )
	WZLog("send_KING_GetMallBuy")
	local sender = Protocol:getSender( Protocol.MAIN_KING, Protocol.KING_GetMallBuy )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInts( kingMallId )	-- 商城物品id
	SendProtocol(sender,false) --true:showLoading
end

-------------------------------------服务器到客户端协议回调方法模块--------------------------------------

--@brief	进入入口协议成功
function ProtocolProcessorSceneKing:parse_KING_GetKingStartOK(score, rank, start, leaveTime, nextTime)
	-- score : 弹王积分
	-- rank : 弹王排名
	-- start : 开启
	-- leaveTime : 剩余开启时间/结束时间
	-- nextTime : 下一个剩余时间
	WZLog("ProtocolProcessorSceneKing:parse_KING_GetKingStartOK")
end

--@brief	进入主界面成功
function ProtocolProcessorSceneKing:parse_KING_GetKingInfoOK(score, rank, battleTimes, winTimes, leaveTimes, todayScore)
	-- score : 弹王积分
	-- rank : 弹王排名
	-- battleTimes : 战斗场数
	-- winTimes : 胜利场数
	-- leaveTimes : 剩余次数
	-- todayScore : 今日积分
	WZLog("ProtocolProcessorSceneKing:parse_KING_GetKingInfoOK")
end

--@brief	进入弹王名人榜成功
function ProtocolProcessorSceneKing:parse_KING_GetFameHallOK(season, rank, playerId, playerName, serverName)
	-- season : 赛季
	-- rank : 名次
	-- playerId : 人物id
	-- playerName : 人物姓名
	-- serverName : 服务器名称
	WZLog("ProtocolProcessorSceneKing:parse_KING_GetFameHallOK")
end

--@brief	进入排行榜成功
function ProtocolProcessorSceneKing:parse_KING_GetRankOK(playerId, playerName, serverName, score, battleTimes, winTimes, myRank, myScore, myBattleTimes, myWinTimes)
	-- playerId : 玩家id
	-- playerName : 玩家姓名
	-- serverName : 服务器名称
	-- score : 积分
	-- battleTimes : 战斗场数
	-- winTimes : 胜利场数
	-- myRank : 我的排名
	-- myScore : 我的积分
	-- myBattleTimes : 战斗场数
	-- myWinTimes : 胜利场数
	WZLog("ProtocolProcessorSceneKing:parse_KING_GetRankOK")
	if WndKingRank:getRoot() then
		local tData = {}
		tData.playerId 		= VectorToTable(playerId)
		tData.playerName 	= VectorToTable(playerName)
		tData.serverName 	= VectorToTable(serverName)
		tData.score 		= VectorToTable(score)
		tData.battleTimes 	= VectorToTable(battleTimes)
		tData.winTimes 		= VectorToTable(winTimes)
		tData.myRank 		= myRank
		tData.myScore 		= myScore
		tData.myBattleTimes = myBattleTimes
		tData.myWinTimes 	= myWinTimes
		WZLog(Serialize(tData))
		WndKingRank:setData(tData)
	end
end

--@brief	进入弹王商店
function ProtocolProcessorSceneKing:parse_KING_GetMallInfoOK(kingMallId, leaveTimes, refreshDate, refreshPrice)
	-- kingMallId : 商城物品id
	-- leaveTimes : 剩余次数
	-- refreshDate : 刷新时间（剩余时间）（秒）
	-- refreshPrice : 刷新价格（为零不给刷新）
	WZLog("ProtocolProcessorSceneKing:parse_KING_GetMallInfoOK")
	if WndKingShop:getRoot() then
		local tData = {}
		tData.kingMallId = VectorToTable(kingMallId)
		tData.leaveTimes = VectorToTable(leaveTimes)
		WndKingShop:setData(tData)
	end
end

--@brief	弹王商店购买成果
function ProtocolProcessorSceneKing:parse_KING_GetMallBuyOK(kingMallId)
	-- kingMallId : 商城物品id
	WZLog("ProtocolProcessorSceneKing:parse_KING_GetMallBuyOK")
	if WndAthBuy.m_root then
		WindowManager:removeWindow(WndAthBuy.m_root, WndAthBuy, true)
	end
	if WndKingShop:getRoot() then
		ProtocolProcessorSceneKing:send_KING_GetMallInfo( )
	end
end
-------------------------------------协议错误处理方法模块--------------------------------------


--@brief	进入入口协议错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneKing:send_KING_GetKingStart_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneKing:send_KING_GetKingStart_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_KING, Protocol.KING_GetKingStart, nflag, sMessage)
end

--@brief	进入主界面协议错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneKing:send_KING_GetKingInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneKing:send_KING_GetKingInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_KING, Protocol.KING_GetKingInfo, nflag, sMessage)
end

--@brief	弹王名人错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneKing:send_KING_GetFameHall_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneKing:send_KING_GetFameHall_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_KING, Protocol.KING_GetFameHall, nflag, sMessage)
end

--@brief	弹王排行榜错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneKing:send_KING_GetRank_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneKing:send_KING_GetRank_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_KING, Protocol.KING_GetRank, nflag, sMessage)
end

--@brief	弹王商店错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneKing:send_KING_GetMallInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneKing:send_KING_GetMallInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_KING, Protocol.KING_GetMallInfo, nflag, sMessage)
end

--@brief	弹王商店购买错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneKing:send_KING_GetMallBuy_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneKing:send_KING_GetMallBuy_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_KING, Protocol.KING_GetMallBuy, nflag, sMessage)
end
