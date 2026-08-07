--ProtocolProcessorSceneThrowingEggs.lua
--@brief	战斗副本结束砸蛋相关协议
--@date  	2014/02/24
--@author 	sunshanshan
--@note 	砸蛋相关协议


ProtocolProcessorSceneThrowingEggs = ProtocolProcessorBase:new()

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	注册协议组所有协议
function ProtocolProcessorSceneThrowingEggs:regAll()

	--@brief	抽奖
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_RewardOk, "ProtocolProcessorSceneThrowingEggs:parse_BOSSMAPROOM_RewardOk", "")
	--@brief	其它人抽一次奖
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_OtherRewardOk, "ProtocolProcessorSceneThrowingEggs:parse_BOSSMAPROOM_OtherRewardOk", "i")
	
	--@brief	抽奖错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_Reward, "ProtocolProcessorSceneThrowingEggs:send_BOSSMAPROOM_Reward_ErrorProcess", "is" )
end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorSceneThrowingEggs:unregAll()
	self:clearReg()
end
  
-------------------------------------客户端到服务器协议发送方法模块------------------------------
 --@brief	抽奖
function ProtocolProcessorSceneThrowingEggs:send_BOSSMAPROOM_Reward( )
	WZLog("send_BOSSMAPROOM_Rewarddddddddddddddddddddddddddd")
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_Reward )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

-------------------------------------服务器到客户端协议回调方法模块------------------------------
 --@brief	通知游戏结束
--[[function ProtocolProcessorSceneThrowingEggs:parse_BOSSMAPBATTLE_GameOver(battleId, firstHurtPlayerId, winCamp, playerCount, playerIds, shootRate, totalHurt, killCount, beKilledCount, addExp, Exp, upgradeExp, nextUpgradeExp, star, eggCount, egg_playeId, egg_Item_Name, egg_item_icon, egg_ItemNum, pices)
	-- battleId : 战斗id
	-- firstHurtPlayerId : 第一个打中别人的角色
	-- winCamp : 胜利的一方
	-- playerCount : 人数
	-- playerIds : 角色id
	-- shootRate : 命中率(放大100倍）
	-- totalHurt : 总共伤害多少
	-- killCount : 杀人数(包括同队的)
	-- beKilledCount : 被杀死次数
	-- addExp : 增加的经验
	-- Exp : 当前的经验(没有增加经验前的)
	-- upgradeExp : 当前升级所需经验
	-- nextUpgradeExp : 下一级升级所需经验
	-- star : 星级评价
	-- eggCount : 蛋的数量
	-- egg_playeId : 属于谁的奖品
	-- egg_Item_Name : 对应的商品名称
	-- egg_item_icon : 物品对应的icon
	-- egg_ItemNum : 赠送数量
	-- pices : 砸蛋的价格
	WZLog("ProtocolProcessorSceneThrowingEggs:parse_BOSSMAPBATTLE_GameOver")
end]]

--@brief	抽奖
function ProtocolProcessorSceneThrowingEggs:parse_BOSSMAPROOM_RewardOk()
	WZLog("ProtocolProcessorSceneThrowingEggs:parse_BOSSMAPROOM_RewardOk")
	SceneThrowingEggs:rewardOk()
end

--@brief	其它人抽一次奖
function ProtocolProcessorSceneThrowingEggs:parse_BOSSMAPROOM_OtherRewardOk(playerId)
	-- playerId : 谁抽奖了
	WZLog("ProtocolProcessorSceneThrowingEggs:parse_BOSSMAPROOM_OtherRewardOk")
	SceneThrowingEggs:otherRewardOk(playerId)
end
-------------------------------------协议错误处理方法模块--------------------------------------
 --@brief	抽奖错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneThrowingEggs:send_BOSSMAPROOM_Reward_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneThrowingEggs:send_BOSSMAPROOM_Reward_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_Reward, nflag, sMessage)
end


-------------------------------------公有方法模块End----------------------------------------








