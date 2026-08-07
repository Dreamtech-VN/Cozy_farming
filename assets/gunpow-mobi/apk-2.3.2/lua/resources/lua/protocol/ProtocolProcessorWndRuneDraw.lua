--ProtocolProcessorWndRuneDraw.lua
--@brief	ProtocolProcessorWndRuneDraw的UI模块
--@date		2017/03/29
--@author	启祥
--@note		符文抽奖协议


-------------------------------------公有方法模块Begin--------------------------------------

ProtocolProcessorWndRuneDraw = ProtocolProcessorBase:new()
--@brief	注册协议组所有协议
function ProtocolProcessorWndRuneDraw:regAll()
	--@brief	获取符文抽奖信息（RUNE_GetLotteryInfo = 16）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_RUNE, Protocol.RUNE_GetLotteryInfo, "ProtocolProcessorWndRuneDraw:send_RUNE_GetLotteryInfo_ErrorProcess", "is" )

	--@brief	获取符文抽奖信息（RUNE_GetLotteryInfoOk = 17）
	self:regProtocolCallbackFunction( Protocol.MAIN_RUNE, Protocol.RUNE_GetLotteryInfoOk, "ProtocolProcessorWndRuneDraw:parse_RUNE_GetLotteryInfoOk", "iii")

	--@brief	抽奖（RUNE_Lottery = 18）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_RUNE, Protocol.RUNE_Lottery, "ProtocolProcessorWndRuneDraw:send_RUNE_Lottery_ErrorProcess", "is" )

	--@brief	抽奖（RUNE_LotteryStatus = 19）
	self:regProtocolCallbackFunction( Protocol.MAIN_RUNE, Protocol.RUNE_LotteryStatus, "ProtocolProcessorWndRuneDraw:parse_RUNE_LotteryStatus", "ttvivi")
end

--@brief	反注册协议组所有协议
function ProtocolProcessorWndRuneDraw:unregAll()
	self:clearReg()
end


-------------------------------------客户端到服务器协议发送方法模块--------------------------------------

--@brief	获取符文抽奖信息（RUNE_GetLotteryInfo = 16）
function ProtocolProcessorWndRuneDraw:send_RUNE_GetLotteryInfo()
	WZLog("send_RUNE_GetLotteryInfo")
	local sender = Protocol:getSender( Protocol.MAIN_RUNE, Protocol.RUNE_GetLotteryInfo )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	抽奖（RUNE_Lottery = 18）
function ProtocolProcessorWndRuneDraw:send_RUNE_Lottery(lotteryType, times)
	WZLog("send_RUNE_Lottery")
	local sender = Protocol:getSender( Protocol.MAIN_RUNE, Protocol.RUNE_Lottery )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeByte( lotteryType )	-- 抽奖类型（0钻石，1金币）
	sender:writeInt( times )	-- 抽奖次数
	SendProtocol(sender,false) --true:showLoading
end


-------------------------------------服务器到客户端协议回调方法模块--------------------------------------


--@brief	获取符文抽奖信息（RUNE_GetLotteryInfoOk = 17）
function ProtocolProcessorWndRuneDraw:parse_RUNE_GetLotteryInfoOk(freeTime,type0STimes,type1STimes)
	-- freeTime : 距离免费抽奖时间（秒）
	-- type1STimes : 金币抽奖距离特殊抽奖次数
	-- type0STimes : 钻石抽奖距离特殊抽奖次数
	WZLog("ProtocolProcessorWndRuneDraw:parse_RUNE_GetLotteryInfoOk =",freeTime,type0STimes,type1STimes)
	SceneRuneLockDraw:setDrawInfo(freeTime,type1STimes,type0STimes)

	-- if SceneCity.m_root and CheckButtonOpen(ISLAND_UP_RUNE,true) then
	-- 	SceneCity:updateRedDotBuilding("RuneDraw", freeTime == 0, GlobalMethod:ccp(100,40))
 --    	WndSummonEntrance:updateRedPoint(nil, nil, freeTime == 0)
	-- end
end

--@brief	抽奖（RUNE_LotteryStatus = 19）
function ProtocolProcessorWndRuneDraw:parse_RUNE_LotteryStatus(status,drawType,itemIds,itemNums)
	-- status : 抽奖状态（0成功，1货币不足）
	-- itemIds : 获得的物品id
	-- itemNums : 获得的物品数量
	-- drawType :抽奖类型(0钻石,金币)
	WZLog("ProtocolProcessorWndRuneDraw:parse_RUNE_LotteryStatus")
	SceneRuneLockDraw:drawCallback(status,VectorToTable(itemIds),VectorToTable(itemNums),drawType)
end

--@brief	获取符文抽奖信息（RUNE_GetLotteryInfo = 16）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndRuneDraw:send_RUNE_GetLotteryInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndRuneDraw:send_RUNE_GetLotteryInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_RUNE, Protocol.RUNE_GetLotteryInfo, nflag, sMessage)
end


--@brief	抽奖（RUNE_Lottery = 18）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndRuneDraw:send_RUNE_Lottery_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndRuneDraw:send_RUNE_Lottery_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_RUNE, Protocol.RUNE_Lottery, nflag, sMessage)
end