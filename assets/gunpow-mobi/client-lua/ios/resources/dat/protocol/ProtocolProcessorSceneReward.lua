--ProtocolProcessorSceneReward.lua
--@brief	充值奖励模块协议
--@date  	2013/12/18
--@author 	SunShanshan


ProtocolProcessorSceneReward = ProtocolProcessorBase:new()

-------------------------------------公有方法模块--------------------------------------

--@brief	注册协议组所有协议
function ProtocolProcessorSceneReward:regAll()
	--@brief	返回首冲奖励、抽奖列表
	self:regProtocolCallbackFunction( Protocol.MAIN_REWARD, Protocol.REWARD_GetRewardListOk, "ProtocolProcessorSceneReward:parse_REWARD_GetRewardListOk", "vsvsvsviiiiivsvsvsvivibbvi")
    --@brief	抽奖
	self:regProtocolCallbackFunction( Protocol.MAIN_REWARD, Protocol.REWARD_GetRewardOk , "ProtocolProcessorSceneReward:parse_REWARD_GetRewardOk", "i")
       ---------------------注册错误协议-----------------
	--@brief	获取首冲奖励、抽奖列表错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_REWARD, Protocol.REWARD_GetRewardList, "ProtocolProcessorSceneReward:send_REWARD_GetRewardList_ErrorProcess", "is" )
    --@brief	首冲奖励领取、抽奖错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_REWARD, Protocol.REWARD_GetReward, "ProtocolProcessorSceneReward:send_REWARD_GetReward_ErrorProcess", "is" )
end

--@brief	反注册协议组所有协议
function ProtocolProcessorSceneReward:unregAll()
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief	获取首冲奖励、抽奖列表
function ProtocolProcessorSceneReward:send_REWARD_GetRewardList( )
	WZLog("send_REWARD_GetRewardList")
	local sender = Protocol:getSender( Protocol.MAIN_REWARD, Protocol.REWARD_GetRewardList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
	WZLog("send_REWARD_GetRewardList2")
end

--@brief	首冲奖励领取、抽奖
function ProtocolProcessorSceneReward:send_REWARD_GetReward(rewardType )
	WZLog("send_REWARD_GetReward")
	local sender = Protocol:getSender( Protocol.MAIN_REWARD, Protocol.REWARD_GetReward )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( rewardType )	-- "0领取首冲奖励、
	SendProtocol(sender,false) --true:showLoading
	WZLog("send_REWARD_GetReward2")
end

-------------------------------------服务器到客户端协议回调方法模块--------------------------------------	
--@brief	返回首冲奖励、抽奖列表
function ProtocolProcessorSceneReward:parse_REWARD_GetRewardListOk(rechargeReward, rechargeRewardRemark, rechargeRewardNum, rechargeStrongLevel, currentAmount, currentLottery, nextAmount, nextLottery, lotteryItems, lotteryItemsRemark, lotteryItemsNum, lotteryItemsId, lotteryStrongLevel, isReward, isLottery,rechargeRewardId)
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
    -- rechargeRewardId :首冲奖励物品ID
	WZLog("ProtocolProcessorSceneReward:parse_REWARD_GetRewardListOk")
	SceneReward:GetRewardListOk(rechargeReward, rechargeRewardRemark, rechargeRewardNum, rechargeStrongLevel, currentAmount, currentLottery, nextAmount, nextLottery, lotteryItems, lotteryItemsRemark, lotteryItemsNum, lotteryItemsId, lotteryStrongLevel, isReward, isLottery,rechargeRewardId)
    WZLog("rechargeRewardId:",rechargeRewardId)
end
	 
--@brief	抽奖
function ProtocolProcessorSceneReward:parse_REWARD_GetRewardOk (itemId)
	-- itemId : "抽奖时抽中的物品，首冲奖励时为-1"
	WZLog("ProtocolProcessorSceneReward:parse_REWARD_GetRewardOk ")
	SceneReward:GetRewardOk(itemId)
end
-------------------------------------协议错误处理方法模块--------------------------------------
function ProtocolProcessorSceneReward:send_REWARD_GetReward_ErrorProcess(n,str)
    WZLog("send_REWARD_GetReward_ErrorProcess"..n..KLuaSocket:utfToGBK(str))
end

--@brief	获得奖励列表错误处理
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneReward:send_REWARD_GetRewardList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneReward:send_REWARD_GetRewardList_ErrorProcess"..sMessage)
	SceneReward:getRewardListErrorProcess(sMessage)
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_REWARD, Protocol.REWARD_GetRewardList, nFlag, sMessage)
end