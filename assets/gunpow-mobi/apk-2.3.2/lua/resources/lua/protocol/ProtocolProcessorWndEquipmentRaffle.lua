--ProtocolProcessorWndEquipmentRaffle.lua
--@brief	微博相关协议
--@date  	2014/3/24
--@author 	liangguang_long
--@note 	微博相关协议


ProtocolProcessorWndEquipmentRaffle = ProtocolProcessorBase:new()

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorWndEquipmentRaffle:regAll()
	
    --@brief	装备抽奖系统相关协议(MAIN_EQUIP = 119)错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_EQUIP, Protocol.EQUIP_Lottery, "ProtocolProcessorWndEquipmentRaffle:send_EQUIP_Lottery_ErrorProcess", "is" )
    --@brief	抽奖成功（EQUIP_LotteryOK=2）
    self:regProtocolCallbackFunction( Protocol.MAIN_EQUIP, Protocol.EQUIP_LotteryOK, "ProtocolProcessorWndEquipmentRaffle:parse_EQUIP_LotteryOK", "vi")

    --@brief	装备免费抽奖剩余时间（EQUIP_GetFreeTime = 14）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_EQUIP, Protocol.EQUIP_GetFreeTime, "ProtocolProcessorWndEquipmentRaffle:send_EQUIP_GetFreeTime_ErrorProcess", "is" )
    
    --@brief	装备免费抽奖剩余时间（EQUIP_GetFreeTimeOK = 15）
    self:regProtocolCallbackFunction( Protocol.MAIN_EQUIP, Protocol.EQUIP_GetFreeTimeOK, "ProtocolProcessorWndEquipmentRaffle:parse_EQUIP_GetFreeTimeOK", "iibi")
    
    --@brief	 获取十连抽奖励领取状态（EQUIP_TenLotteryRewardStatus = 21）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_EQUIP, Protocol.EQUIP_TenLotteryRewardStatus, "ProtocolProcessorWndEquipmentRaffle:send_EQUIP_TenLotteryRewardStatus_ErrorProcess", "is" )

    
    --@brief	返回十连抽奖励领取状态（EQUIP_TenLotteryRewardStatusOk = 22）
    self:regProtocolCallbackFunction( Protocol.MAIN_EQUIP, Protocol.EQUIP_TenLotteryRewardStatusOk, "ProtocolProcessorWndEquipmentRaffle:parse_EQUIP_TenLotteryRewardStatusOk", "vivivivivi")
    
    --@brief	 获取十连抽奖励（EQUIP_ReceiveTenLotteryReward = 23）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_EQUIP, Protocol.EQUIP_ReceiveTenLotteryReward, "ProtocolProcessorWndEquipmentRaffle:send_EQUIP_ReceiveTenLotteryReward_ErrorProcess", "is" )
    
    --@brief	获取十连抽奖励（EQUIP_ReceiveTenLotteryRewardOk = 24）
    self:regProtocolCallbackFunction( Protocol.MAIN_EQUIP, Protocol.EQUIP_ReceiveTenLotteryRewardOk, "ProtocolProcessorWndEquipmentRaffle:parse_EQUIP_ReceiveTenLotteryRewardOk", "vivi")

end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorWndEquipmentRaffle:unregAll()
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief	装备抽奖系统相关协议(MAIN_EQUIP = 119)
function ProtocolProcessorWndEquipmentRaffle:send_EQUIP_Lottery(lotteryType )
	WZLog("send_EQUIP_Lottery =",lotteryType)
	local sender = Protocol:getSender( Protocol.MAIN_EQUIP, Protocol.EQUIP_Lottery )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( lotteryType )	-- 抽奖类型1、碎片抽，2、单次钻石，3、十连抽
	SendProtocol(sender,false) --true:showLoading
end

--@brief	装备免费抽奖剩余时间（EQUIP_GetFreeTime = 14）
function ProtocolProcessorWndEquipmentRaffle:send_EQUIP_GetFreeTime()
	WZLog("send_EQUIP_GetFreeTime")
	local sender = Protocol:getSender( Protocol.MAIN_EQUIP, Protocol.EQUIP_GetFreeTime )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	 获取十连抽奖励领取状态（EQUIP_TenLotteryRewardStatus = 21）
function ProtocolProcessorWndEquipmentRaffle:send_EQUIP_TenLotteryRewardStatus()
	WZLog("send_EQUIP_TenLotteryRewardStatus")
	local sender = Protocol:getSender( Protocol.MAIN_EQUIP, Protocol.EQUIP_TenLotteryRewardStatus )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	 获取十连抽奖励（EQUIP_ReceiveTenLotteryReward = 23）
function ProtocolProcessorWndEquipmentRaffle:send_EQUIP_ReceiveTenLotteryReward(targetTime )
	WZLog("send_EQUIP_ReceiveTenLotteryReward")
	local sender = Protocol:getSender( Protocol.MAIN_EQUIP, Protocol.EQUIP_ReceiveTenLotteryReward )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( targetTime )	-- 达成奖励的抽奖次数奖励顺序
	SendProtocol(sender,false) --true:showLoading
end



-------------------------------------服务器到客户端协议回调方法模块--------------------------------------

--@brief	抽奖成功（EQUIP_LotteryOK=2）
function ProtocolProcessorWndEquipmentRaffle:parse_EQUIP_LotteryOK(itemId)
	-- itemId : 获得装备Id
	WZLog("ProtocolProcessorWndEquipmentRaffle:parse_EQUIP_LotteryOK")
    WndEquipmentLottery:raffleSuccess(VectorToTable(itemId))
end

--@brief	装备免费抽奖剩余时间（EQUIP_GetFreeTimeOK = 15）
function ProtocolProcessorWndEquipmentRaffle:parse_EQUIP_GetFreeTimeOK(leaveTime, lotteryTime,bActivity,tenLotteryTime)
	-- leaveTime : 剩余时间
	-- lotteryTime : 剩余次数比抽中紫装
	-- bActivity : 是否有抽奖活动
	-- tenLotteryTime : 十连抽累计次数
	WZLog("ProtocolProcessorWndEquipmentRaffle:parse_EQUIP_GetFreeTimeOK")
	WndEquipmentLottery:updateUIInfo(leaveTime,lotteryTime,bActivity,tenLotteryTime)
end

--@brief	返回十连抽奖励领取状态（EQUIP_TenLotteryRewardStatusOk = 22）
function ProtocolProcessorWndEquipmentRaffle:parse_EQUIP_TenLotteryRewardStatusOk(targetTimes, status, rewardItems, rewardItemsCount, rewardCounts)
	-- targetTimes : 达成奖励的抽奖次数
	-- status : 领取状态. -1:不可领取 0:可领取 1：已领取
	-- rewardItems : 奖励物品ID
	-- rewardItemsCount : 奖励物品数量
	-- rewardCounts : 每个档次奖励的物品数
	WZLog("ProtocolProcessorWndEquipmentRaffle:parse_EQUIP_TenLotteryRewardStatusOk")
	WndEquipmentLottery:setRewardStatus(VectorToTable(targetTimes),VectorToTable(status),VectorToTable(rewardItems),VectorToTable(rewardItemsCount),VectorToTable(rewardCounts))
end

--@brief	获取十连抽奖励（EQUIP_ReceiveTenLotteryRewardOk = 24）
function ProtocolProcessorWndEquipmentRaffle:parse_EQUIP_ReceiveTenLotteryRewardOk(itemId, itemCount)
	-- itemId : 奖励物品ID
	-- itemCount : 物品数量
	WZLog("ProtocolProcessorWndEquipmentRaffle:parse_EQUIP_ReceiveTenLotteryRewardOk ",Serialize(VectorToTable(itemId)))
	WndRewardShow:showById(VectorToTable(itemId), VectorToTable(itemCount))
	ProtocolProcessorWndEquipmentRaffle:send_EQUIP_TenLotteryRewardStatus()
end

-------------------------------------协议错误处理方法模块--------------------------------------


--@brief	装备抽奖系统相关协议(MAIN_EQUIP = 119)错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndEquipmentRaffle:send_EQUIP_Lottery_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndEquipmentRaffle:send_EQUIP_Lottery_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_EQUIP, Protocol.EQUIP_Lottery, nflag, sMessage)
	WndEquipmentLottery:resetValue()

end

--@brief	装备免费抽奖剩余时间（EQUIP_GetFreeTime = 14）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndEquipmentRaffle:send_EQUIP_GetFreeTime_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndEquipmentRaffle:send_EQUIP_GetFreeTime_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_EQUIP, Protocol.EQUIP_GetFreeTime, nflag, sMessage)
	WndEquipmentLottery:resetValue()
end

--@brief	 获取十连抽奖励领取状态（EQUIP_TenLotteryRewardStatus = 21）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndEquipmentRaffle:send_EQUIP_TenLotteryRewardStatus_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndEquipmentRaffle:send_EQUIP_TenLotteryRewardStatus_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_EQUIP, Protocol.EQUIP_TenLotteryRewardStatus, nflag, sMessage)
end


--@brief	 获取十连抽奖励（EQUIP_ReceiveTenLotteryReward = 23）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndEquipmentRaffle:send_EQUIP_ReceiveTenLotteryReward_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndEquipmentRaffle:send_EQUIP_ReceiveTenLotteryReward_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_EQUIP, Protocol.EQUIP_ReceiveTenLotteryReward, nflag, sMessage)
end

-------------------------------------公有方法模块End----------------------------------------


