--ProtocolProcessorWndOnLineReward.lua
--@brief	ProtocolProcessorWndOnLineReward的UI模块
--@date		2016/07/23
--@author	maopeiting
--@note		在线奖励相关协议


ProtocolProcessorWndOnLineReward = ProtocolProcessorBase:new()

-------------------------------------公有方法模块--------------------------------------

--@brief	注册协议组所有协议
function ProtocolProcessorWndOnLineReward:regAll()
	self:regProtocolCallbackFunction( Protocol.MAIN_ONLINEREWARD, Protocol.ONLINEREWARD_GetOnlineMes, "ProtocolProcessorWndOnLineReward:send_ONLINEREWARD_GetOnlineMes_ErrorProcess", "is" )
	self:regProtocolCallbackFunction( Protocol.MAIN_ONLINEREWARD, Protocol.ONLINEREWARD_GetReward, "ProtocolProcessorWndOnLineReward:send_ONLINEREWARD_GetReward_ErrorProcess", "is" )
	self:regProtocolCallbackFunction( Protocol.MAIN_ONLINEREWARD, Protocol.ONLINEREWARD_GetOnlineMesOk, "ProtocolProcessorWndOnLineReward:parse_ONLINEREWARD_GetOnlineMesOk", "ivivs")
	self:regProtocolCallbackFunction( Protocol.MAIN_ONLINEREWARD, Protocol.ONLINEREWARD_GetRewardOk, "ProtocolProcessorWndOnLineReward:parse_ONLINEREWARD_GetRewardOk", "iviviivi")
end 
--@brief	反注册协议组所有协议
function ProtocolProcessorWndOnLineReward:unregAll()
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
function ProtocolProcessorWndOnLineReward:send_ONLINEREWARD_GetOnlineMes( )
	WZLog("send_ONLINEREWARD_GetOnlineMes")
	local sender = Protocol:getSender( Protocol.MAIN_ONLINEREWARD, Protocol.ONLINEREWARD_GetOnlineMes )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end


--@brief	领取在线奖励（ONLINEREWARD_GiveReward  = 3）
function ProtocolProcessorWndOnLineReward:send_ONLINEREWARD_GetReward(rewardId )
	WZLog("send_ONLINEREWARD_GetReward")
	local sender = Protocol:getSender( Protocol.MAIN_ONLINEREWARD, Protocol.ONLINEREWARD_GetReward )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( rewardId )	-- 领取奖励的Id
	SendProtocol(sender,false) --true:showLoading
end

-------------------------------------服务器到客户端协议回调方法模块--------------------------------------
--@brief	获取在线奖励信息（ONLINEREWARD_GetOnlineMesOK = 2）
function ProtocolProcessorWndOnLineReward:parse_ONLINEREWARD_GetOnlineMesOk(online, reward, config)
	-- online : 在线时间（秒）
	-- reward : 已经领取的在线奖励
	-- config : 在线奖励配置，json格式。 { "id": 1, "time": 60, "reward": "[1,200]", "reward2": "[1,200]" "remark": "" }
	WZLog("ProtocolProcessorWndOnLineReward:parse_ONLINEREWARD_GetOnlineMesOk")
	--CellOnLineReward:setData(online,VectorToTable(reward))
	WndWelfare:setCellData( online, reward, config)
	if WndKingEndTip.m_root then 
		WndKingEndTip:setData( online, VectorToTable(reward), VectorToTable(config))
	end
end

--@brief	领取在线奖励（ONLINEREWARD_GetRewardOk = 4)
function ProtocolProcessorWndOnLineReward:parse_ONLINEREWARD_GetRewardOk(rewardId, itemId, num, online, reward)
	-- rewardId : 领取奖励的Id
	-- itemId : 奖励物品Id
	-- num : 奖励物品数量
	-- online : 在线时间（秒）
	-- reward : 已经领取的在线奖励
	WZLog("ProtocolProcessorWndOnLineReward:parse_ONLINEREWARD_GetRewardOk")
	if WndWelfare.m_root then
		WndWelfare:getReward( rewardId,itemId,num,online,reward )
	end
end


-------------------------------------协议错误处理方法模块--------------------------------------
--@brief	获取在线奖励信息（ONLINEREWARD_GetOnlineMes = 1）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndOnLineReward:send_ONLINEREWARD_GetOnlineMes_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndOnLineReward:send_ONLINEREWARD_GetOnlineMes_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ONLINEREWARD, Protocol.ONLINEREWARD_GetOnlineMes, nflag, sMessage)
end

--@brief	领取在线奖励（ONLINEREWARD_GiveReward  = 3）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndOnLineReward:send_ONLINEREWARD_GetReward_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndOnLineReward:send_ONLINEREWARD_GetReward_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ONLINEREWARD, Protocol.ONLINEREWARD_GetReward, nflag, sMessage)
end
