--ProtocolProcessorWndReward.lua
--@brief	充值奖励模块协议
--@date  	2014/9/12
--@author 	陈海宽


ProtocolProcessorWndReward = ProtocolProcessorBase:new()
-------------------------------------公有方法模块--------------------------------------
--@brief	注册协议组所有协议
function ProtocolProcessorWndReward:regAll()
	--@brief	获取首冲奖励、抽奖列表（REWARD_GetRewardList = 1）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_REWARD , Protocol.REWARD_GetRewardList , "ProtocolProcessorWndReward:send_REWARD_GetRewardList _ErrorProcess", "is" )
	
	--@brief	返回首冲奖励、抽奖列表
	self:regProtocolCallbackFunction( Protocol.MAIN_REWARD, Protocol.REWARD_GetRewardListOk, "ProtocolProcessorWndReward:parse_REWARD_GetRewardListOk", "vsvsvsviiiiivsvsvsvivibbviviivivii")

	--@brief	首冲奖励领取、抽奖（REWARD_GetReward = 3）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_REWARD, Protocol.REWARD_GetReward, "ProtocolProcessorWndReward:send_REWARD_GetReward_ErrorProcess", "is" )

	--@brief	发送错误列表（REWARD_GetRewardOk = 4）
	--self:regProtocolCallbackFunction( Protocol.MAIN_REWARD, Protocol.REWARD_GetRewardOk, "ProtocolProcessorWndReward:parse_REWARD_GetRewardOk", "isi")
	--@brief	首冲奖励物品领取协议
	--self:regProtocolCallbackFunction( Protocol.MAIN_REWARD, Protocol.REWARD_GetRewardOk, "WndReward:parse_REWARD_GetRewardOk", "vivivisii")
end


--@brief	反注册协议组所有协议
function ProtocolProcessorWndReward:unregAll()
	self:clearReg()
end


-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief	获取首冲奖励、抽奖列表（REWARD_GetRewardList = 1）
function ProtocolProcessorWndReward:send_REWARD_GetRewardList ( )
	WZLog("send_REWARD_GetRewardList ")
	local sender = Protocol:getSender( Protocol.MAIN_REWARD , Protocol.REWARD_GetRewardList  )
	if sender==nil then WZLog("sender == nil") return end
	SendProtocol(sender,false) --true:showLoading
end

--@brief	首冲奖励领取、抽奖（REWARD_GetReward = 3）
function ProtocolProcessorWndReward:send_REWARD_GetReward(rewardType )
	WZLog("send_REWARD_GetReward")
	local sender = Protocol:getSender( Protocol.MAIN_REWARD, Protocol.REWARD_GetReward )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( rewardType )	-- "0领取首冲奖励、
	SendProtocol(sender,false) --true:showLoading
end



-------------------------------------服务器到客户端协议回调方法模块--------------------------------------



--@brief	返回首冲奖励、抽奖列表
function ProtocolProcessorWndReward:parse_REWARD_GetRewardListOk(rechargeReward, rechargeRewardRemark, rechargeRewardNum, rechargeStrongLevel, currentAmount, currentLottery, nextAmount, nextLottery, lotteryItems, lotteryItemsRemark, lotteryItemsNum, lotteryItemsId, lotteryStrongLevel, isReward, isLottery, rewardId, rewardType, everyDayRewardNum, rewardNum, rechargeNum, maxNum)
	-- rechargeReward : 首冲奖励物品
	-- rechargeRewardRemark : 首冲奖励物品描述
	-- rechargeRewardNum : 首冲奖励物品数量
	-- rechargeStrongLevel : 首冲奖励物品强化等级
	-- currentAmount : 当前累积钻石
	-- currentLottery : 当前抽奖次数
	-- nextAmount : 下阶累积钻石
	-- nextLottery : 下阶抽奖次数
	-- lotteryItems : 抽奖物品
	-- lotteryItemsRemark : 抽奖物品描述
	-- lotteryItemsNum : 抽奖物品数量
	-- lotteryItemsId : 抽奖物品id
	-- lotteryStrongLevel : 抽奖物品强化等级
	-- isReward : 是否可以领取
	-- isLottery : 是否可以抽奖
	-- rewardId : 奖励ID
	-- rewardType : 1 首充奖励物品，2 每日首充奖励物品
	-- everyDayRewardNum : 可以每日奖励领取的次数
	-- rewardNum : 奖励次数
	-- rechargeNum : 奖励次数对应的充值额度
	-- maxNum : 最大累计数量

	WndReward:GetRewardListOk(rechargeReward, rechargeRewardRemark, rechargeRewardNum, rechargeStrongLevel, currentAmount, currentLottery, nextAmount, nextLottery, lotteryItems, lotteryItemsRemark, lotteryItemsNum, lotteryItemsId, lotteryStrongLevel, isReward, isLottery, rewardId, rewardType, everyDayRewardNum,rewardNum, rechargeNum, maxNum)
	WZLog("ProtocolProcessorWndReward:parse_REWARD_GetRewardListOk")
end

--@brief	发送错误列表（REWARD_GetRewardOk = 4）
--[[function ProtocolProcessorWndReward:parse_REWARD_GetRewardOk(itemId, msg, status)
	-- itemId : 抽奖时抽中的物品，首冲奖励时为-1
	-- msg : 消息
	WZLog("ProtocolProcessorWndReward:parse_REWARD_GetRewardOk")
	if itemId == -2 then
		local _status = false
		if status == 1 then  --首日领取成功
			_status = true
		end
		WndReward:showRewardMsg(msg,_status)
	else
		WndReward:showRewardBox(itemId)
	end

end]]

--@brief	首冲奖励物品领取协议
function ProtocolProcessorWndReward:parse_REWARD_GetRewardOk(itemsId, count, days, msg, status, rewardType)
	-- itemsId : 物品id
	-- count : 物品数量
	-- days : 物品天数
	-- msg : 消息
	-- status : 状态 1 成功 0 失败
	-- rewardType : "0领取首冲奖励、1领取抽奖奖励,2领取每日首充奖励"
	WZLog("WndReward:parse_REWARD_GetRewardOk")
	if rewardType == 2 then
		local _status = false
		if status == 1 then  --首日领取成功
			_status = true
		end
		--WndReward:showRewardMsg(msg,_status)
	else
		--WndReward:showRewardBox(rewardType,itemsId,count,days)
	end
end

-------------------------------------协议错误处理方法模块--------------------------------------
--@brief	获取首冲奖励、抽奖列表（REWARD_GetRewardList = 1）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndReward:send_REWARD_GetRewardList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndReward:send_REWARD_GetRewardList _ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_REWARD , Protocol.REWARD_GetRewardList , nflag, sMessage)
end

--@brief	首冲奖励领取、抽奖（REWARD_GetReward = 3）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndReward:send_REWARD_GetReward_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndReward:send_REWARD_GetReward_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_REWARD, Protocol.REWARD_GetReward, nflag, sMessage)
	WndReward:showRewardMsg(sMessage,false)
end

