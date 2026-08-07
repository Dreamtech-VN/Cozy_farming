--ProtocolProcessorWndLuckyGift.lua
--@brief	ProtocolProcessorWndLuckyGift的UI模块
--@date		2017/02/7
--@author	maopeiting
--@note		幸运礼盒相关协议


ProtocolProcessorWndLuckyGift = ProtocolProcessorBase:new()

-------------------------------------公有方法模块--------------------------------------

--@brief	注册协议组所有协议
function ProtocolProcessorWndLuckyGift:regAll()
	--@brief	获取当天系统福利翻牌列表（LUCKYBOX_GetSysCardsList = 1）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_LUCKYBOX, Protocol.LUCKYBOX_GetSysCardsList , "ProtocolProcessorWndLuckyGift:send_LUCKYBOX_GetSysCardsList _ErrorProcess", "is" )
	--@brief	获取玩家当天翻牌记录（LUCKYBOX_GetPlayerCardsRecord = 3）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_LUCKYBOX, Protocol.LUCKYBOX_GetPlayerCardsRecord, "ProtocolProcessorWndLuckyGift:send_LUCKYBOX_GetPlayerCardsRecord_ErrorProcess", "is" )
	--@brief	客户端发起翻牌请求（LUCKYBOX_TurnCard = 5）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_LUCKYBOX, Protocol.LUCKYBOX_TurnCard, "ProtocolProcessorWndLuckyGift:send_LUCKYBOX_TurnCard_ErrorProcess", "is" )
	--@brief	返回系统翻牌列表（LUCKYBOX_GetSysCardsListOK = 2）
	self:regProtocolCallbackFunction( Protocol.MAIN_LUCKYBOX, Protocol.LUCKYBOX_GetSysCardsListOK, "ProtocolProcessorWndLuckyGift:parse_LUCKYBOX_GetSysCardsListOK", "viii")
	--@brief	返回玩家当天福利翻牌记录列表（LUCKYBOX_GetPlayerCardsRecordOK = 4）
	self:regProtocolCallbackFunction( Protocol.MAIN_LUCKYBOX, Protocol.LUCKYBOX_GetPlayerCardsRecordOK, "ProtocolProcessorWndLuckyGift:parse_LUCKYBOX_GetPlayerCardsRecordOK", "viviiiiivii")
	--@brief	返回翻牌结果（LUCKYBOX_TurnCardOK = 6）
	self:regProtocolCallbackFunction( Protocol.MAIN_LUCKYBOX, Protocol.LUCKYBOX_TurnCardOK, "ProtocolProcessorWndLuckyGift:parse_LUCKYBOX_TurnCardOK", "iiiiiiiii")
end

--@brief	反注册协议组所有协议
function ProtocolProcessorWndLuckyGift:unregAll()
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief	获取当天系统福利翻牌列表（LUCKYBOX_GetSysCardsList = 1）
function ProtocolProcessorWndLuckyGift:send_LUCKYBOX_GetSysCardsList( )
	WZLog("send_LUCKYBOX_GetSysCardsList ")
	local sender = Protocol:getSender( Protocol.MAIN_LUCKYBOX, Protocol.LUCKYBOX_GetSysCardsList  )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取玩家当天翻牌记录（LUCKYBOX_GetPlayerCardsRecord = 3）
function ProtocolProcessorWndLuckyGift:send_LUCKYBOX_GetPlayerCardsRecord( )
	WZLog("send_LUCKYBOX_GetPlayerCardsRecord")
	local sender = Protocol:getSender( Protocol.MAIN_LUCKYBOX, Protocol.LUCKYBOX_GetPlayerCardsRecord )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	客户端发起翻牌请求（LUCKYBOX_TurnCard = 5）
function ProtocolProcessorWndLuckyGift:send_LUCKYBOX_TurnCard(index, version)
	WZLog("send_LUCKYBOX_TurnCard")
	local sender = Protocol:getSender( Protocol.MAIN_LUCKYBOX, Protocol.LUCKYBOX_TurnCard )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( index )	-- 卡牌栏位ID
	sender:writeInt(version) 		--系统卡牌版本
	SendProtocol(sender,false) --true:showLoading
end


-------------------------------------服务器到客户端协议回调方法模块--------------------------------------
--@brief	返回系统翻牌列表（LUCKYBOX_GetSysCardsListOK = 2）
function ProtocolProcessorWndLuckyGift:parse_LUCKYBOX_GetSysCardsListOK(cardIdList, freeTimes, version)
	-- cardIdList : 卡牌系统配置ID
	-- freeTimes : 今天剩余免费翻牌次数
	-- version ：系统卡牌版本，每天重置版本+1
	WZLog("ProtocolProcessorWndLuckyGift:parse_LUCKYBOX_GetSysCardsListOK")
	--WndLuckyGift:getSysCardsList(VectorToTable(cardIdList),freeTimes,version)
end

--@brief	返回玩家当天福利翻牌记录列表（LUCKYBOX_GetPlayerCardsRecordOK = 4）
function ProtocolProcessorWndLuckyGift:parse_LUCKYBOX_GetPlayerCardsRecordOK(index, cardId, todayTurnedTimes, curTurnCost, freeTimes, version, count, ratio)
	-- index : 卡牌栏位ID
	-- cardId : 卡牌对应的系统奖励配置id
	-- todayTurnedTimes : 当天翻牌次数
	-- curTurnCost : 当前翻牌所需消耗
	-- freeTimes : 今天剩余免费翻牌次数
	-- version : 系统卡牌版本，每天重置版本+1
	-- count : 物品数量
	-- ratio : 消耗倍率
	WZLog("ProtocolProcessorWndLuckyGift:parse_LUCKYBOX_GetPlayerCardsRecordOK")
	WndLuckyGift:getPlayerCardsRecord(VectorToTable(index),VectorToTable(cardId),todayTurnedTimes,curTurnCost,freeTimes,version,VectorToTable(count),ratio)
end

--@brief	返回翻牌结果（LUCKYBOX_TurnCardOK = 6）
function ProtocolProcessorWndLuckyGift:parse_LUCKYBOX_TurnCardOK(restFreeTimes, todayTurnedTimes, curTurnCost, turnBombState, cardId, result, resetState, count, ratio)
	-- restFreeTimes : 今天剩余免费翻牌次数
	-- todayTurnedTimes : 当天翻牌次数
	-- curTurnCost : 当前翻牌所需消耗钻石
	-- turnBombState : 是否抽到炸弹 1是 0否
	-- cardId : 卡牌对应的系统奖励配置id
	--result : 翻牌结果（1翻牌成功，2钻石不足)
	--resetState ：系统卡牌状态 1新系统重置 0不需重置
	-- count : 物品数量
	-- ratio : 消耗倍率
	WZLog("ProtocolProcessorWndLuckyGift:parse_LUCKYBOX_TurnCardOK")
	WndLuckyGift:getTurnCardOk(restFreeTimes,todayTurnedTimes,curTurnCost,turnBombState,cardId,result,resetState,count,ratio)
end

-------------------------------------协议错误处理方法模块--------------------------------------
--@brief	获取当天系统福利翻牌列表（LUCKYBOX_GetSysCardsList = 1）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndLuckyGift:send_LUCKYBOX_GetSysCardsList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndLuckyGift:send_LUCKYBOX_GetSysCardsList _ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_LUCKYBOX, Protocol.LUCKYBOX_GetSysCardsList , nflag, sMessage)
end

--@brief	获取玩家当天翻牌记录（LUCKYBOX_GetPlayerCardsRecord = 3）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndLuckyGift:send_LUCKYBOX_GetPlayerCardsRecord_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndLuckyGift:send_LUCKYBOX_GetPlayerCardsRecord_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_LUCKYBOX, Protocol.LUCKYBOX_GetPlayerCardsRecord, nflag, sMessage)
end

--@brief	客户端发起翻牌请求（LUCKYBOX_TurnCard = 5）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndLuckyGift:send_LUCKYBOX_TurnCard_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndLuckyGift:send_LUCKYBOX_TurnCard_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_LUCKYBOX, Protocol.LUCKYBOX_TurnCard, nflag, sMessage)
end
