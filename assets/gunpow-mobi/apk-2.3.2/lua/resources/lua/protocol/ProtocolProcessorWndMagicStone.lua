--ProtocolProcessorWndMagicStone.lua
--@brief	任务相关协议
--@date  	2014/09/09
--@author 	SuYuan
--@note 	任务相关协议


ProtocolProcessorWndMagicStone = ProtocolProcessorBase:new()

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorWndMagicStone:regAll() 
	--@brief	幻石信息（MAGICSTONE_GetMagicStoneInfo = 1）
	self:regProtocolCallbackFunction( Protocol.MAIN_MAGICSTONE, Protocol.MAGICSTONE_GetMagicStoneInfo, "ProtocolProcessorWndMagicStone:send_MAGICSTONE_GetMagicStoneInfo_ErrorProcess", "is")
	--@brief	领取奖励（MAGICSTONE_GetReward = 3）
	self:regProtocolCallbackFunction( Protocol.MAIN_MAGICSTONE, Protocol.MAGICSTONE_GetReward, "ProtocolProcessorWndMagicStone:send_MAGICSTONE_GetReward_ErrorProcess", "is")
	--@brief	商店购买（MAGICSTONE_Buy = 5）
	self:regProtocolCallbackFunction( Protocol.MAIN_MAGICSTONE, Protocol.MAGICSTONE_Buy, "ProtocolProcessorWndMagicStone:send_MAGICSTONE_Buy_ErrorProcess", "is")
	--@brief	购买等级（MAGICSTONE_BuyLevel = 7）
	self:regProtocolCallbackFunction( Protocol.MAIN_MAGICSTONE, Protocol.MAGICSTONE_BuyLevel, "ProtocolProcessorWndMagicStone:send_MAGICSTONE_BuyLevel_ErrorProcess", "is")

	--@brief 	幻石信息返回（MAGICSTONE_GetMagicStoneInfoOk = 2）
	self:regProtocolCallbackFunction( Protocol.MAIN_MAGICSTONE, Protocol.MAGICSTONE_GetMagicStoneInfoOk, "ProtocolProcessorWndMagicStone:parse_MAGICSTONE_GetMagicStoneInfoOk", "tiiiviviviviviviviviviviiiviviiii")
	--@brief	获取在线奖励信息（MAGICSTONE_GetRewardOk = 4）
	self:regProtocolCallbackFunction( Protocol.MAIN_MAGICSTONE, Protocol.MAGICSTONE_GetRewardOk, "ProtocolProcessorWndMagicStone:parse_MAGICSTONE_GetRewardOk", "iivivi")
	--@brief	购买成功（MAGICSTONE_BuyOk = 6）
	self:regProtocolCallbackFunction( Protocol.MAIN_MAGICSTONE, Protocol.MAGICSTONE_BuyOk, "ProtocolProcessorWndMagicStone:parse_MAGICSTONE_BuyOk", "iiii")
end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorWndMagicStone:unregAll()
	self:clearReg()
end
  
-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief	幻石信息（MAGICSTONE_GetMagicStoneInfo = 1）
function ProtocolProcessorWndMagicStone:send_MAGICSTONE_GetMagicStoneInfo()
	WZLog("send_MAGICSTONE_GetMagicStoneInfo")
	local sender = Protocol:getSender( Protocol.MAIN_MAGICSTONE, Protocol.MAGICSTONE_GetMagicStoneInfo )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	领取奖励（MAGICSTONE_GetReward = 3）
function ProtocolProcessorWndMagicStone:send_MAGICSTONE_GetReward(rewardType, rewardId)
	WZLog("send_MAGICSTONE_GetReward")
	local sender = Protocol:getSender( Protocol.MAIN_MAGICSTONE, Protocol.MAGICSTONE_GetReward )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( rewardType )	-- 1:普通奖励 2：进阶奖励 3： 任务奖励
	sender:writeInt( rewardId )	-- 等级或者任务id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	商店购买（MAGICSTONE_Buy = 5）
function ProtocolProcessorWndMagicStone:send_MAGICSTONE_Buy(marketId, buyNum)
	WZLog("send_MAGICSTONE_Buy")
	local sender = Protocol:getSender( Protocol.MAIN_MAGICSTONE, Protocol.MAGICSTONE_Buy )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( marketId )	-- 商品Id
	sender:writeInt( buyNum )	-- 购买的数量
	SendProtocol(sender,false) --true:showLoading
end

--@brief	购买等级（MAGICSTONE_BuyLevel = 7）
function ProtocolProcessorWndMagicStone:send_MAGICSTONE_BuyLevel(addLevel)
	WZLog("send_MAGICSTONE_BuyLevel")
	local sender = Protocol:getSender( Protocol.MAIN_MAGICSTONE, Protocol.MAGICSTONE_BuyLevel )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( addLevel )	-- 购买的等级
	SendProtocol(sender,false) --true:showLoading
end
-------------------------------------------服务器到客户端协议发送方法模块------------------------------------------
--@brief	幻石信息返回（MAGICSTONE_GetMagicStoneInfoOk = 2）
function ProtocolProcessorWndMagicStone:parse_MAGICSTONE_GetMagicStoneInfoOk(openStatus, level, exp, weekExp, commonReward, advancedReward, taskId, taskCompleteNum, taskTargetNum, taskState, taskRcvNum, taskRcvLimit, marketId, marketNum, refreshTime, seasonTime, fullCommonReward, fullAdvanceReward, advanceNum, seasonNum, batch)
	-- openStatus : 0: 未生效 1：生效
	-- level : 等级
	-- exp : 当前经验
	-- weekExp : 本周增加的经验
	-- commonReward : 等级奖励
	-- advancedReward : 进阶奖励
	-- taskId : 任务id
	-- taskCompleteNum : 任务进度
	-- taskTargetNum : 任务目标值
	-- taskState : 任务状态
	-- taskRcvNum : 已领取的奖励次数
	-- taskRcvLimit : 总共可以领取的奖励次数
	-- marketId : 商品id
	-- marketNum : 商品数量
	-- refreshTime : 任务刷新时间
	-- seasonTime : 季度刷新时间
	-- fullCommonReward : 战令全服普通奖励状态
	-- fullAdvanceReward : 战令全服进阶奖励状态
	-- seasonNum : 【182-1新增】赛季编号
	-- batch : 【182-1新增】赛季批次编号(每7天为一个批次) 
	WZLog("ProtocolProcessorWndMagicStone:parse_MAGICSTONE_GetMagicStoneInfoOk",
		"\n openStatus =",Serialize(VectorToTable(openStatus)),
		"\n level =",Serialize(VectorToTable(level)),
		"\n exp =",Serialize(VectorToTable(exp)),
		"\n weekExp =",Serialize(VectorToTable(weekExp)),
		"\n commonReward =",Serialize(VectorToTable(commonReward)),
		"\n advancedReward =",Serialize(VectorToTable(advancedReward)),
		"\n taskId =",Serialize(VectorToTable(taskId)),
		"\n taskCompleteNum =",Serialize(VectorToTable(taskCompleteNum)),
		"\n taskTargetNum =",Serialize(VectorToTable(taskTargetNum)),
		"\n taskState =",Serialize(VectorToTable(taskState)),
		"\n taskRcvNum =",Serialize(VectorToTable(taskRcvNum)),
		"\n taskRcvLimit =",Serialize(VectorToTable(taskRcvLimit)),
		"\n marketId =",Serialize(VectorToTable(marketId)),
		"\n marketNum =",Serialize(VectorToTable(marketNum)),
		"\n refreshTime =",Serialize(VectorToTable(refreshTime)),
		"\n seasonTime =",Serialize(VectorToTable(seasonTime)),
		"\n fullCommonReward =",Serialize(VectorToTable(fullCommonReward)),
		"\n fullAdvanceReward =",Serialize(VectorToTable(fullAdvanceReward)),
		"\n advanceNum =",Serialize(VectorToTable(advanceNum)),
		"\n seasonNum =",Serialize(VectorToTable(seasonNum)),
		"\n batch =",Serialize(VectorToTable(batch)))
	WndMagicStone:setData(openStatus, level, exp, weekExp, VectorToTable(commonReward), VectorToTable(advancedReward), VectorToTable(taskId), VectorToTable(taskCompleteNum), 
		VectorToTable(taskTargetNum), VectorToTable(taskState), VectorToTable(taskRcvNum), VectorToTable(taskRcvLimit), VectorToTable(marketId), VectorToTable(marketNum), 
		refreshTime, seasonTime, VectorToTable(fullCommonReward), VectorToTable(fullAdvanceReward), advanceNum, seasonNum, batch)
end

--@brief	获取在线奖励信息（MAGICSTONE_GetRewardOk = 4）
function ProtocolProcessorWndMagicStone:parse_MAGICSTONE_GetRewardOk(rewardType, rewardId, itemId, itemNum)
	-- rewardType : 1:普通奖励 2：进阶奖励 3： 任务奖励
	-- rewardId : 等级或者任务id
	WZLog("ProtocolProcessorWndMagicStone:parse_MAGICSTONE_GetRewardOk", rewardType, rewardId)
	local id, num = VectorToTable(itemId), VectorToTable(itemNum)
	WndRewardShow:showById(id,num)
	if rewardType == 3 then 
		WndMagicStone:getTaskRewardOK(rewardId)
	end
end

--@brief	购买商品成功（MAGICSTONE_BuyOk = 6）
function ProtocolProcessorWndMagicStone:parse_MAGICSTONE_BuyOk(marketId, buyNum, itemId, itemNum)
	-- marketId : 商品Id
	-- buyNum : 购买的数量
	-- itemId : 购买的物品Id
	-- itemNum : 购买的物品数量
	WZLog("ProtocolProcessorWndMagicStone:parse_MAGICSTONE_BuyOk")
	
	WndMagicStone:buyShopGoodOK(marketId, buyNum, itemId, itemNum)
end

------------------------------------------错误协议-----------------------------------------------------
--@brief	幻石信息（MAGICSTONE_GetMagicStoneInfo = 1）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMagicStone:send_MAGICSTONE_GetMagicStoneInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMagicStone:send_MAGICSTONE_GetMagicStoneInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MAGICSTONE, Protocol.MAGICSTONE_GetMagicStoneInfo, nflag, sMessage)
end

--@brief	领取奖励（MAGICSTONE_GetReward = 3）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMagicStone:send_MAGICSTONE_GetReward_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMagicStone:send_MAGICSTONE_GetReward_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MAGICSTONE, Protocol.MAGICSTONE_GetReward, nflag, sMessage)
end

--@brief	商店购买（MAGICSTONE_Buy = 5）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMagicStone:send_MAGICSTONE_Buy_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMagicStone:send_MAGICSTONE_Buy_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MAGICSTONE, Protocol.MAGICSTONE_Buy, nflag, sMessage)
end

--@brief	购买等级（MAGICSTONE_BuyLevel = 7）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMagicStone:send_MAGICSTONE_BuyLevel_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMagicStone:send_MAGICSTONE_BuyLevel_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MAGICSTONE, Protocol.MAGICSTONE_BuyLevel, nflag, sMessage)
end
-------------------------------------公有方法模块End----------------------------------------



