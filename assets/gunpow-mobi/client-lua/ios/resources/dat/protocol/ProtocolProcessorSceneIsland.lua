--ProtocolProcessorSceneIsland.lua
--@brief	小岛模块协议
--@date  	2013/02/25
--@author 	xiaoyu_wu


ProtocolProcessorSceneIsland = ProtocolProcessorBase:new()

-------------------------------------公有方法模块--------------------------------------

--@brief	注册协议组所有协议
function ProtocolProcessorSceneIsland:regAll()
    --@brief	玩家领取在线奖励成功
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetOnlineRewardOk, "ProtocolProcessorSceneIsland:parse_PLAYER_GetOnlineRewardOk", "vsvivs")

	--@brief	玩家领取在线奖励错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetOnlineReward, "ProtocolProcessorSceneIsland:send_PLAYER_GetOnlineReward_ErrorProcess", "is" )
end

--@brief	反注册协议组所有协议
function ProtocolProcessorSceneIsland:unregAll()
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief	玩家领取在线奖励
function ProtocolProcessorSceneIsland:send_PLAYER_GetOnlineReward( )
	WZLog("send_PLAYER_GetOnlineReward")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetOnlineReward )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

-------------------------------------服务器到客户端协议回调方法模块--------------------------------------	
--@brief	玩家领取在线奖励成功
function ProtocolProcessorSceneIsland:parse_PLAYER_GetOnlineRewardOk(itemName, itemCount, itemIcon)
	-- itemName : 奖励需要在线时长
	-- itemCount : 奖励的数量
	-- itemIcon : 奖励物品的图标
	WZLog("ProtocolProcessorSceneIsland:parse_PLAYER_GetOnlineRewardOk")
    SceneIsland:getOnlineRewardOk(VectorToTable(itemName), VectorToTable(itemCount), VectorToTable(itemIcon))
end

-------------------------------------协议错误处理方法模块--------------------------------------
--@brief	玩家领取在线奖励错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneIsland:send_PLAYER_GetOnlineReward_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneIsland:send_PLAYER_GetOnlineReward_ErrorProcess")
	SceneIsland:errorProcess(sMessage)
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_GetOnlineReward, nflag, sMessage)
end

