--ProtocolProcessorSceneLottery.lua
--@brief	爱心许愿模块协议
--@date  	2013/12/16
--@author 	SunShanshan


ProtocolProcessorSceneLottery = ProtocolProcessorBase:new()

-------------------------------------公有方法模块--------------------------------------

--@brief	注册协议组所有协议
function ProtocolProcessorSceneLottery:regAll()
	--@brief	领取礼盒
	self:regProtocolCallbackFunction( Protocol.MAIN_LOTTERY, Protocol.LOTTERY_ReceiveZflhOk, "ProtocolProcessorSceneLottery:parse_LOTTERY_ReceiveZflhOk", "")
    --@brief	发送奖励
	self:regProtocolCallbackFunction( Protocol.MAIN_LOTTERY, Protocol.LOTTERY_ReceiveRewardOk, "ProtocolProcessorSceneLottery:parse_LOTTERY_ReceiveRewardOk", "ivivi")
	------
	--@brief	获得奖励列表错误处理(S->C)
	--self:regProtocolCallbackFunction( Protocol.MAIN_LOTTERY, Protocol.LOTTERY_GetRewardList, "ProtocolProcessorSceneLottery:send_LOTTERY_GetRewardList_ErrorProcess", "is" )
	--@brief	获取奖励错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_LOTTERY, Protocol.LOTTERY_ReceiveReward, "ProtocolProcessorSceneLottery:send_LOTTERY_ReceiveReward_ErrorProcess", "is" )
	--@brief	发送奖励公告错误处理(S->C)
	--self:regProtocolCallbackFunction( Protocol.MAIN_LOTTERY, Protocol.LOTTERY_ReceiveZflh, "ProtocolProcessorSceneLottery:send_LOTTERY_SendNotice_ErrorProcess", "is" )
    
    --@brief	获取奖励（LOTTERY_ReceiveZflh = 3）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_LOTTERY, Protocol.LOTTERY_ReceiveZflh, "ProtocolProcessorSceneLottery:send_LOTTERY_ReceiveZflh_ErrorProcess", "is" )
    

	--@brief	活动卡包转盘信息（ACTIVITY_GetCardLotteryInfo = 44）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetCardLotteryInfo, "ProtocolProcessorSceneLottery:send_ACTIVITY_GetCardLotteryInfo_ErrorProcess", "is" )
    
    --@brief	活动卡包转盘信息（ACTIVITY_GetCardLotteryInfoOk = 45）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetCardLotteryInfoOk, "ProtocolProcessorSceneLottery:parse_ACTIVITY_GetCardLotteryInfoOk", "svivs")
    
    --@brief	卡包转盘抽奖（ACTIVITY_CardLottery = 47）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_CardLottery, "ProtocolProcessorSceneLottery:send_ACTIVITY_CardLottery_ErrorProcess", "is" )
    
    --@brief	卡包转盘抽奖（ACTIVITY_CardLotteryOk = 48）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_CardLotteryOk, "ProtocolProcessorSceneLottery:parse_ACTIVITY_CardLotteryOk", "ivivi")

end

--@brief	反注册协议组所有协议
function ProtocolProcessorSceneLottery:unregAll()
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief	发送奖励公告
function ProtocolProcessorSceneLottery:send_LOTTERY_SendNotice(notice )
	WZLog("send_LOTTERY_SendNotice")
	local sender = Protocol:getSender( Protocol.MAIN_LOTTERY, Protocol.LOTTERY_SendNotice )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeString( notice )	-- 需要播放的公告
	SendProtocol(sender,false) --true:showLoading
	WZLog("send_LOTTERY_SendNotice2")
end

--@brief	获得奖励列表
function ProtocolProcessorSceneLottery:send_LOTTERY_GetRewardList( )
	WZLog("send_LOTTERY_GetRewardList")
	local sender = Protocol:getSender( Protocol.MAIN_LOTTERY, Protocol.LOTTERY_GetRewardList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取奖励
function ProtocolProcessorSceneLottery:send_LOTTERY_ReceiveReward(rewardType)
    WZLog("ProtocolProcessorSceneLottery:send_LOTTERY_ReceiveReward")
	local sender = Protocol:getSender( Protocol.MAIN_LOTTERY, Protocol.LOTTERY_ReceiveReward )
	if sender==nil then WZLog("sender == nil") return end
	sender:writeByte(rewardType)	
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取礼盒奖励（LOTTERY_ReceiveZflh = 3）
function ProtocolProcessorSceneLottery:send_LOTTERY_ReceiveZflh(id )
	WZLog("send_LOTTERY_ReceiveZflh")
	local sender = Protocol:getSender( Protocol.MAIN_LOTTERY, Protocol.LOTTERY_ReceiveZflh )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( id )	-- 礼盒ID
	SendProtocol(sender,false) --true:showLoading
end

--@brief	活动卡包转盘信息（ACTIVITY_GetCardLotteryInfo = 44）
function ProtocolProcessorSceneLottery:send_ACTIVITY_GetCardLotteryInfo( )
	WZLog("send_ACTIVITY_GetCardLotteryInfo")
	local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetCardLotteryInfo )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	卡包转盘抽奖（ACTIVITY_CardLottery = 47）
function ProtocolProcessorSceneLottery:send_ACTIVITY_CardLottery(lotteryType )
	WZLog("send_ACTIVITY_CardLottery")
	local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_CardLottery )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeByte( lotteryType )	-- 抽奖类型,0:单次;1:十次
	SendProtocol(sender,false) --true:showLoading
end


-------------------------------------服务器到客户端协议回调方法模块--------------------------------------	
--@brief	发送奖励物品列表
function ProtocolProcessorSceneLottery:parse_LOTTERY_ReceiveZflhOk()
	-- itemName : 物品名称
	-- itemIcon : 物品图标
	-- itemNum : 物品对应数量
	-- accumulateDiamond : 已经积累的钻石数
	-- lottery : 持有的爱心数
	-- everyDiamond : 每次累计钻石数
	WZLog("ProtocolProcessorSceneLottery:parse_LOTTERY_ReceiveZflhOk")

end

--@brief	发送奖励
function ProtocolProcessorSceneLottery:parse_LOTTERY_ReceiveRewardOk(gridId, itemId, num)
	-- itemId : 抽中的物品Id
	-- accumulateDiamond : 已经积累的钻石数
	-- num : 物品数量
	WZLog("ProtocolProcessorSceneLottery:parse_LOTTERY_ReceiveRewardOk")
	WndLoveLottery:ReceiveRewardOk(gridId,VectorToTable(itemId), VectorToTable(num))
end


--@brief	活动卡包转盘信息（ACTIVITY_GetCardLotteryInfoOk = 45）
function ProtocolProcessorSceneLottery:parse_ACTIVITY_GetCardLotteryInfoOk(cost ,index, reward)
	-- cost : 消耗
	-- index : 下标
	-- reward : 奖励
	WZLog("ProtocolProcessorSceneLottery:parse_ACTIVITY_GetCardLotteryInfoOk")
	WndCardDraw:setLotteryInfo(cost,VectorToTable(index),VectorToTable(reward))
end

--@brief	卡包转盘抽奖（ACTIVITY_CardLotteryOk = 48）
function ProtocolProcessorSceneLottery:parse_ACTIVITY_CardLotteryOk(gridId, itemId, itemNum)
	-- gridId : 选中的格子序号
	-- itemId : 格子里的物品
	-- itemNum : 格子里的物品数量
	WZLog("ProtocolProcessorSceneLottery:parse_ACTIVITY_CardLotteryOk")
	WndCardDraw:ReceiveRewardOk(gridId,VectorToTable(itemId), VectorToTable(itemNum))
end
-------------------------------------协议错误处理方法模块--------------------------------------

function ProtocolProcessorSceneLottery:send_LOTTERY_ReceiveReward_ErrorProcess(n,str)
   WZLog("ProtocolProcessorSceneLottery:send_LOTTERY_ReceiveReward_ErrorProcess")
    if WndLoveLottery.m_nLoadingId ~= nil and WndLoveLottery.m_nLoadingId > 0 then
        MsgBoxManager:stopLoadingBoxByMsgId(WndLoveLottery.m_nLoadingId)
        WndLoveLottery.m_nLoadingId = nil
    end
end

--@brief	获得奖励列表错误处理
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneLottery:send_LOTTERY_GetRewardList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneLottery:send_LOTTERY_GetRewardList_ErrorProcess"..sMessage)
	WndLoveLottery:getRewardListErrorProcess(sMessage)
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_LOTTERY, Protocol.LOTTERY_GetRewardList, nFlag, sMessage)
end

function ProtocolProcessorSceneLottery:send_LOTTERY_SendNotice_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneLottery:send_LOTTERY_SendNotice_ErrorProcess"..sMessage)
	 
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_LOTTERY, Protocol.LOTTERY_SendNotice, nFlag, sMessage)
end


--@brief	获取奖励（LOTTERY_ReceiveZflh = 3）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneLottery:send_LOTTERY_ReceiveZflh_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneLottery:send_LOTTERY_ReceiveZflh_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_LOTTERY, Protocol.LOTTERY_ReceiveZflh, nflag, sMessage)
end

--@brief	活动卡包转盘信息（ACTIVITY_GetCardLotteryInfo = 44）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneLottery:send_ACTIVITY_GetCardLotteryInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneLottery:send_ACTIVITY_GetCardLotteryInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetCardLotteryInfo, nflag, sMessage)
end


--@brief	卡包转盘抽奖（ACTIVITY_CardLottery = 47）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneLottery:send_ACTIVITY_CardLottery_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneLottery:send_ACTIVITY_CardLottery_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_CardLottery, nflag, sMessage)
end