--ProtocolProcessorDigGem
--@brief	称号相关协议
--@date  	2013/12/12
--@author 	liangguang_long
--@note 	称号相关协议


ProtocolProcessorDigGem = ProtocolProcessorBase:new()

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorDigGem:regAll()
	WZLog("ProtocolProcessorDigGem:regAll")
	--@brief	获取挖矿信息（MINING_GetMining = 1）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_MINING, Protocol.MINING_GetMining, "ProtocolProcessorDigGem:send_MINING_GetMining_ErrorProcess", "is" )
	--@brief	获取挖矿日志（MINING_MiningLog = 3）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_MINING, Protocol.MINING_MiningLog, "ProtocolProcessorDigGem:send_MINING_MiningLog_ErrorProcess", "is" )
	--@brief	开始挖宝（MINING_StartMining = 5）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_MINING, Protocol.MINING_StartMining, "ProtocolProcessorDigGem:send_MINING_StartMining_ErrorProcess", "is" )
	--@brief	停止挖宝（MINING_StopMining = 6）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_MINING, Protocol.MINING_StopMining, "ProtocolProcessorDigGem:send_MINING_StopMining_ErrorProcess", "is" )
	--@brief	购买矿晶（MINING_MiningBuy = 7）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_MINING, Protocol.MINING_MiningBuy, "ProtocolProcessorDigGem:send_MINING_MiningBuy_ErrorProcess", "is" )
	--@brief	购买挖矿工具（MINING_BuyTool = 9）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_MINING, Protocol.MINING_BuyTool, "ProtocolProcessorDigGem:send_MINING_BuyTool_ErrorProcess", "is" )
	--@brief	宝石背包（MINING_GetMiningBag = 10）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_MINING, Protocol.MINING_GetMiningBag, "ProtocolProcessorDigGem:send_MINING_GetMiningBag_ErrorProcess", "is" )
	--@brief	回收宝石（MINING_RecyclingMining = 12）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_MINING, Protocol.MINING_RecyclingMining, "ProtocolProcessorDigGem:send_MINING_RecyclingMining_ErrorProcess", "is" )
	--@brief	鉴定宝石（MINING_Authenticate = 14）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_MINING, Protocol.MINING_Authenticate, "ProtocolProcessorDigGem:send_MINING_Authenticate_ErrorProcess", "is" )
	--@brief	获取遗迹列表（MINING_GetRelicList = 16）		错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_MINING, Protocol.MINING_GetRelicList, "ProtocolProcessorDigGem:send_MINING_GetRelicList_ErrorProcess", "is" )
	--@brief	获取具体遗迹信息（MINING_GetRelicInfo = 18）		错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_MINING, Protocol.MINING_GetRelicInfo, "ProtocolProcessorDigGem:send_MINING_GetRelicInfo_ErrorProcess", "is" )
	--@brief	开始战斗（MINING_MakePair = 20）		错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_MINING, Protocol.MINING_MakePair, "ProtocolProcessorDigGem:send_MINING_MakePair_ErrorProcess", "is" )
	--@brief	领取遗迹奖励（MINING_GetMapReward = 22）		错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_MINING, Protocol.MINING_GetMapReward, "ProtocolProcessorDigGem:send_MINING_GetMapReward_ErrorProcess", "is" )
	--@brief	分享副本（MINING_ShareMap= 25）		错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_MINING, Protocol.MINING_ShareMap, "ProtocolProcessorDigGem:send_MINING_ShareMap_ErrorProcess", "is" )
	--@brief	获取雇佣好友列表（MINING_GetHireFriendList= 35）		错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_MINING, Protocol.MINING_GetHireFriendList, "ProtocolProcessorDigGem:send_MINING_GetHireFriendList_ErrorProcess", "is" )
	--@brief	雇佣好友（MINING_HireFriend= 37）		错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_MINING, Protocol.MINING_HireFriend, "ProtocolProcessorDigGem:send_MINING_HireFriend_ErrorProcess", "is" )
	--@brief	互动操作（MINING_HireInteract= 41）		错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_MINING, Protocol.MINING_HireInteract, "ProtocolProcessorDigGem:send_MINING_HireInteract_ErrorProcess", "is" )
	--@brief	驱赶偷矿者（MINING_ChasingThief= 45）		错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_MINING, Protocol.MINING_ChasingThief, "ProtocolProcessorDigGem:send_MINING_ChasingThief_ErrorProcess", "is" )

	--@brief	获取挖矿信息（MINING_GetMiningOk = 2）
	self:regProtocolCallbackFunction( Protocol.MAIN_MINING, Protocol.MINING_GetMiningOk, "ProtocolProcessorDigGem:parse_MINING_GetMiningOk", "iiiiviviviviiivsviviviiiiivivsvivtvivivivivivivsvivi")
    --@brief	获取挖矿日志（MINING_MiningLogOk = 4）
	self:regProtocolCallbackFunction( Protocol.MAIN_MINING, Protocol.MINING_MiningLogOk, "ProtocolProcessorDigGem:parse_MINING_MiningLogOk", "vivsvsvivivivivi")
	--@brief	购买矿晶（MINING_MiningBuyOk = 8）
	self:regProtocolCallbackFunction( Protocol.MAIN_MINING, Protocol.MINING_MiningBuyOk, "ProtocolProcessorDigGem:parse_MINING_MiningBuyOk", "i")
	--@brief	宝石背包（MINING_GetMiningBagOk = 11）
	self:regProtocolCallbackFunction( Protocol.MAIN_MINING, Protocol.MINING_GetMiningBagOk, "ProtocolProcessorDigGem:parse_MINING_GetMiningBagOk", "vivi")
	--@brief	回收宝石（MINING_RecyclingMiningOk = 13）
	self:regProtocolCallbackFunction( Protocol.MAIN_MINING, Protocol.MINING_RecyclingMiningOk, "ProtocolProcessorDigGem:parse_MINING_RecyclingMiningOk", "vivivivi")
	--@brief	回收宝石（MINING_AuthenticateOk = 15）
	self:regProtocolCallbackFunction( Protocol.MAIN_MINING, Protocol.MINING_AuthenticateOk, "ProtocolProcessorDigGem:parse_MINING_AuthenticateOk", "vivivivi")
	--@brief	获取遗迹列表（MINING_GetRelicListOk = 17）		
	self:regProtocolCallbackFunction( Protocol.MAIN_MINING, Protocol.MINING_GetRelicListOk, "ProtocolProcessorDigGem:parse_MINING_GetRelicListOk", "vivsvivsviviviviii")
	--@brief	获取遗迹信息（MINING_GetRelicInfoOk = 19）		
	self:regProtocolCallbackFunction( Protocol.MAIN_MINING, Protocol.MINING_GetRelicInfoOk, "ProtocolProcessorDigGem:parse_MINING_GetRelicInfoOk", "siiiiiiiivivivsvivisii")
	--@brief	开始战斗成功（MINING_MakePairOk = 21）		
	self:regProtocolCallbackFunction( Protocol.MAIN_MINING, Protocol.MINING_MakePairOk, "ProtocolProcessorDigGem:parse_MINING_MakePairOk", "iiivlvsvsvsvivivivivivivivivivivivivivivivivivivivivivivivsvivivsvivivivivivivivnvivivivivsvivivsvivsvsvsvivivivi")
	--@brief	领取遗迹奖励（MINING_GetMapRewardOk = 23）		
	self:regProtocolCallbackFunction( Protocol.MAIN_MINING, Protocol.MINING_GetMapRewardOk, "ProtocolProcessorDigGem:parse_MINING_GetMapRewardOk", "ivivi")
	--@brief	分享副本成功（MINING_ShareMapOk = 26）		
	self:regProtocolCallbackFunction( Protocol.MAIN_MINING, Protocol.MINING_ShareMapOk, "ProtocolProcessorDigGem:parse_MINING_ShareMapOk", "i")

	--@brief	获取雇佣好友列表成功（MINING_GetHireFriendListOk= 36）		
	self:regProtocolCallbackFunction( Protocol.MAIN_MINING, Protocol.MINING_GetHireFriendListOk, "ProtocolProcessorDigGem:parse_MINING_GetHireFriendListOk", "vivivsvtvtvivivivivivivivi")
	--@brief	雇佣好友成功（MINING_HireFriendOk= 38）
	self:regProtocolCallbackFunction( Protocol.MAIN_MINING, Protocol.MINING_HireFriendOk, "ProtocolProcessorDigGem:parse_MINING_HireFriendOk", "i")
	--@brief	互动操作成功（MINING_HireInteractOk= 42）		
	self:regProtocolCallbackFunction( Protocol.MAIN_MINING, Protocol.MINING_HireInteractOk, "ProtocolProcessorDigGem:parse_MINING_HireInteractOk", "iiii")
	--@brief	驱赶偷矿者成功（MINING_ChasingThiefOk= 46）		
	self:regProtocolCallbackFunction( Protocol.MAIN_MINING, Protocol.MINING_ChasingThiefOk, "ProtocolProcessorDigGem:parse_MINING_ChasingThiefOk", "")

end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorDigGem:unregAll()
	self:clearReg()
end
  
-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief	获取挖矿信息（MINING_GetMining = 1）
function ProtocolProcessorDigGem:send_MINING_GetMining()
	WZLog("send_MINING_GetMining")
	local sender = Protocol:getSender( Protocol.MAIN_MINING, Protocol.MINING_GetMining )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取挖矿日志（MINING_MiningLog = 3）
function ProtocolProcessorDigGem:send_MINING_MiningLog( )
	WZLog("send_MINING_MiningLog")
	local sender = Protocol:getSender( Protocol.MAIN_MINING, Protocol.MINING_MiningLog )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	开始挖宝（MINING_StartMining = 5）
function ProtocolProcessorDigGem:send_MINING_StartMining(toolId )
	WZLog("send_MINING_StartMining")
	local sender = Protocol:getSender( Protocol.MAIN_MINING, Protocol.MINING_StartMining )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( toolId )	-- 使用挖矿工具
	SendProtocol(sender,false) --true:showLoading
end

--@brief	停止挖宝（MINING_StopMining = 6）
function ProtocolProcessorDigGem:send_MINING_StopMining( )
	WZLog("send_MINING_StopMining")
	local sender = Protocol:getSender( Protocol.MAIN_MINING, Protocol.MINING_StopMining )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	购买矿晶（MINING_MiningBuy = 7）
function ProtocolProcessorDigGem:send_MINING_MiningBuy(num)
	WZLog("send_MINING_MiningBuy")
	local sender = Protocol:getSender( Protocol.MAIN_MINING, Protocol.MINING_MiningBuy )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( num )	-- 购买次数
	SendProtocol(sender,false) --true:showLoading
end

--@brief	购买挖矿工具（MINING_BuyTool = 9）
function ProtocolProcessorDigGem:send_MINING_BuyTool(toolId )
	WZLog("send_MINING_BuyTool",toolId)
	local sender = Protocol:getSender( Protocol.MAIN_MINING, Protocol.MINING_BuyTool )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( toolId )	-- 挖矿工具Id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	宝石背包（MINING_GetMiningBag = 10）
function ProtocolProcessorDigGem:send_MINING_GetMiningBag( )
	WZLog("send_MINING_GetMiningBag")
	local sender = Protocol:getSender( Protocol.MAIN_MINING, Protocol.MINING_GetMiningBag )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	回收宝石（MINING_RecyclingMining = 12）
function ProtocolProcessorDigGem:send_MINING_RecyclingMining(item, num )
	WZLog("send_MINING_RecyclingMining")
	local sender = Protocol:getSender( Protocol.MAIN_MINING, Protocol.MINING_RecyclingMining )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInts( item )	-- 回收宝石Id
	sender:writeInts( num )	-- 回收宝石数量
	SendProtocol(sender,false) --true:showLoading
end

--@brief	鉴定宝石（MINING_Authenticate = 14）
function ProtocolProcessorDigGem:send_MINING_Authenticate(item, num )
	WZLog("send_MINING_Authenticate")
	local sender = Protocol:getSender( Protocol.MAIN_MINING, Protocol.MINING_Authenticate )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInts( item )	-- 回收宝石Id
	sender:writeInts( num )	-- 回收宝石数量
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取遗迹列表（MINING_GetRelicList = 16）		
function ProtocolProcessorDigGem:send_MINING_GetRelicList( )
	WZLog("send_MINING_GetRelicList")
	local sender = Protocol:getSender( Protocol.MAIN_MINING, Protocol.MINING_GetRelicList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取具体遗迹信息（MINING_GetRelicInfo = 18）		
function ProtocolProcessorDigGem:send_MINING_GetRelicInfo(mapId )
	WZLog("send_MINING_GetRelicInfo")
	local sender = Protocol:getSender( Protocol.MAIN_MINING, Protocol.MINING_GetRelicInfo )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeString( mapId )	-- 副本Id(服务器生成的唯一id)
	SendProtocol(sender,false) --true:showLoading
end

--@brief	开始战斗（MINING_MakePair = 20）		
function ProtocolProcessorDigGem:send_MINING_MakePair(mapId )
	WZLog("send_MINING_MakePair")
	local sender = Protocol:getSender( Protocol.MAIN_MINING, Protocol.MINING_MakePair )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeString( mapId )	-- 副本Id(服务器生成的唯一id)
	SendProtocol(sender,false) --true:showLoading
end

--@brief	领取遗迹奖励（MINING_GetMapReward = 22）		
function ProtocolProcessorDigGem:send_MINING_GetMapReward(mapId )
	WZLog("send_MINING_GetMapReward")
	local sender = Protocol:getSender( Protocol.MAIN_MINING, Protocol.MINING_GetMapReward )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeString( mapId )	-- 副本Id(服务器生成的唯一id)
	SendProtocol(sender,false) --true:showLoading
end

--@brief	分享副本（MINING_ShareMap= 25）		
function ProtocolProcessorDigGem:send_MINING_ShareMap(mapId, bubbleId, shareType )
	WZLog("send_MINING_ShareMap")
	local sender = Protocol:getSender( Protocol.MAIN_MINING, Protocol.MINING_ShareMap )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeString( mapId )	-- 副本Id(服务器生成的唯一id)
	sender:writeInt( bubbleId )	-- 聊天气泡
	sender:writeInt( shareType )	-- 1世界 2公会 0全频道
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取雇佣好友列表（MINING_GetHireFriendList= 35）		
function ProtocolProcessorDigGem:send_MINING_GetHireFriendList( )
	WZLog("send_MINING_GetHireFriendList")
	local sender = Protocol:getSender( Protocol.MAIN_MINING, Protocol.MINING_GetHireFriendList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	雇佣好友（MINING_HireFriend= 37）		
function ProtocolProcessorDigGem:send_MINING_HireFriend(playerId)
	WZLog("send_MINING_HireFriend", playerId)
	local sender = Protocol:getSender( Protocol.MAIN_MINING, Protocol.MINING_HireFriend )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerId )	-- 玩家ID
	SendProtocol(sender,false) --true:showLoading
end

--@brief	互动操作（MINING_HireInteract= 41）		
function ProtocolProcessorDigGem:send_MINING_HireInteract(playerId, interactType)
	WZLog("send_MINING_HireInteract", playerId, interactType)
	local sender = Protocol:getSender( Protocol.MAIN_MINING, Protocol.MINING_HireInteract )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerId )	-- 玩家ID
	sender:writeInt( interactType )	-- 交互类型【1=飞吻|2=面包|3=皮鞭】
	SendProtocol(sender,false) --true:showLoading
end

--@brief	驱赶偷矿者（MINING_ChasingThief= 45）		
function ProtocolProcessorDigGem:send_MINING_ChasingThief( )
	WZLog("send_MINING_ChasingThief")
	local sender = Protocol:getSender( Protocol.MAIN_MINING, Protocol.MINING_ChasingThief )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

-------------------------------------服务器到客户端协议回调方法模块--------------------------------------
--@brief	获取挖矿信息（MINING_GetMiningOk = 2）		
function ProtocolProcessorDigGem:parse_MINING_GetMiningOk(useTool, remainTime, level, exp, toolId, remainToolTime, item, num, toolTime, buyNum, mapId, mapNum, mapStatus, overTime, complete, mapSize, shareTime, hireNum, playerId, playerName, playerLevel, playerSex, playerHeadId, playerFaceId, playerBodyId, playerWingId, playerHeadcolour, playerBodycolour, playerPet, hireMoodValue, hireEndTime)
	-- useTool : 正在使用的挖矿工具（0为不在挖矿中）
	-- remainTime : 下一次获取宝石的倒计时（秒）（useTool大于0是才有效）
	-- level : 熟练度等级
	-- exp : 熟练度经验
	-- toolId : 拥有的工具
	-- remainToolTime : 该工具剩余的挖矿时间（秒）
	-- item : 背包中的宝石
	-- num : 该宝石的数量
	-- toolTime : 当前使用工具的倒计时（秒）（useTool大于0是才有效）
	-- buyNum : 今天购买晶石次数
	-- mapId : 副本Id(服务器生成的唯一id)
	-- mapNum : 遗迹副本表中id
	-- mapStatus : 副本状态 0挑战中 1挑战成功
	-- overTime : 剩余时间(秒)
	-- complete : 周任务完成数量
	-- mapSize : 当前副本数
	-- shareTime : 可分享剩余倒计时
	-- hireNum : 我雇佣的人数【下面的数组除掉雇佣人数后，剩余的玩家为偷矿者】
	-- playerId : 我雇佣的玩家&偷矿玩家ID
	-- playerName : 我雇佣的玩家&偷矿玩家名称
	-- playerLevel : 我雇佣的玩家&偷矿玩家等级
	-- playerSex : 我雇佣的玩家&偷矿玩家性别【0男1女】
	-- playerHeadId : 我雇佣的玩家&偷矿玩家头ID
	-- playerFaceId : 我雇佣的玩家&偷矿玩家脸ID
	-- playerBodyId : 我雇佣的玩家&偷矿玩家身ID
	-- playerWingId : 我雇佣的玩家&偷矿玩家翅膀ID
	-- playerHeadcolour : 我雇佣的玩家&偷矿玩家头颜色
	-- playerBodycolour : 我雇佣的玩家&偷矿玩家身颜色
	-- playerPet : 我雇佣的玩家&偷矿玩家宠物动画
	-- hireMoodValue : 我雇佣的玩家心情值【偷矿者无意义0】
	-- hireEndTime : 雇佣关系结束时间【偷矿者无意义0】【注：要用服务器时间进行判断】
	WZLog("ProtocolProcessorDigGem:parse_MINING_GetMiningOk",
		"\nuseTool =",Serialize(VectorToTable(useTool)),
		"\nremainTime =",Serialize(VectorToTable(remainTime)),
		"\nlevel =",Serialize(VectorToTable(level)),
		"\nexp =",Serialize(VectorToTable(exp)),
		"\ntoolId =",Serialize(VectorToTable(toolId)),
		"\nremainToolTime =",Serialize(VectorToTable(remainToolTime)),
		"\nitem =",Serialize(VectorToTable(item)),
		"\nnum =",Serialize(VectorToTable(num)),
		"\ntoolTime =",Serialize(VectorToTable(toolTime)),
		"\nbuyNum =",Serialize(VectorToTable(buyNum)),
		"\nmapId =",Serialize(VectorToTable(mapId)),
		"\nmapNum =",Serialize(VectorToTable(mapNum)),
		"\nmapStatus =",Serialize(VectorToTable(mapStatus)),
		"\noverTime =",Serialize(VectorToTable(overTime)),
		"\ncomplete =",Serialize(VectorToTable(complete)),
		"\nmapSize =",Serialize(VectorToTable(mapSize)),
		"\nshareTime =",Serialize(VectorToTable(shareTime)),
		"\nhireNum =",Serialize(VectorToTable(hireNum)),
		"\nplayerId =",Serialize(VectorToTable(playerId)),
		"\nplayerName =",Serialize(VectorToTable(playerName)),
		"\nplayerLevel =",Serialize(VectorToTable(playerLevel)),
		"\nplayerSex =",Serialize(VectorToTable(playerSex)),
		"\nplayerHeadId =",Serialize(VectorToTable(playerHeadId)),
		"\nplayerFaceId =",Serialize(VectorToTable(playerFaceId)),
		"\nplayerBodyId =",Serialize(VectorToTable(playerBodyId)),
		"\nplayerWingId =",Serialize(VectorToTable(playerWingId)),
		"\nplayerHeadcolour =",Serialize(VectorToTable(playerHeadcolour)),
		"\nplayerBodycolour =",Serialize(VectorToTable(playerBodycolour)),
		"\nplayerPet =",Serialize(VectorToTable(playerPet)),
		"\nhireMoodValue =",Serialize(VectorToTable(hireMoodValue)),
		"\nhireEndTime =",Serialize(VectorToTable(hireEndTime)) )

	if WndDigGem.m_root then
		WndDigGem:setRoleData(hireNum, VectorToTable(playerId), VectorToTable(playerName), VectorToTable(playerLevel), VectorToTable(playerSex), VectorToTable(playerHeadId), VectorToTable(playerFaceId), VectorToTable(playerBodyId), VectorToTable(playerWingId), VectorToTable(playerHeadcolour), VectorToTable(playerBodycolour), VectorToTable(playerPet), VectorToTable(hireMoodValue), VectorToTable(hireEndTime))

		WndDigGem:setData(useTool, remainTime, level, exp, VectorToTable(toolId), VectorToTable(remainToolTime), VectorToTable(item), VectorToTable(num), toolTime, buyNum, 
			VectorToTable(mapId),VectorToTable(mapStatus),VectorToTable(overTime),VectorToTable(reward),VectorToTable(taskId),VectorToTable(status),VectorToTable(target),VectorToTable(complete),mapSize)

    	WndDigGem:setRemainsData(VectorToTable(mapId), VectorToTable(mapNum), VectorToTable(mapStatus), VectorToTable(overTime), complete, mapSize, shareTime)
	end

	if SceneCity.m_root and CheckButtonOpen(ISLAND_BUILDING_TREASURE, true) then
		SceneCity:updateRedDotBuilding("DigGem", useTool == 0, GlobalMethod:ccp(155,40))
	end
end

--@brief	获取挖矿日志（MINING_MiningLogOk = 4）
function ProtocolProcessorDigGem:parse_MINING_MiningLogOk(logtype, time, name, itemCount, itemId, itemNum, miningExp, miningLevel)
	-- logtype : 日志类型(类型1为开始挖宝，2为时间到挖宝结束，3为背包满停止挖宝，4为主动停止挖宝(弃用)，5为挖到宝物(弃用)，6为熟练度升级, 7挖到遗迹, 8雇佣, 9被雇佣, 10互动飞吻, 11互动面包, 12互动皮鞭, 13矿工等级升级, 14偷到宝石, 15宝石被偷, 16雇员挖到宝物)
	-- time : 记录日志时间戳
	-- name : 玩家昵称
	-- itemCount : 物品Id单条日志含有的不同Item的数量【前端根据此值去切割分组下面两个数组，组装日志中的Item内容】【161新增】
	-- itemId : 物品Id
	-- itemNum : 物品Num
	-- miningExp : 获得经验|心情值|挖矿持续时间(秒)
	-- miningLevel : 熟练度等级|矿工等级
	WZLog("ProtocolProcessorDigGem:parse_MINING_MiningLogOk",Serialize(VectorToTable(logtype)),Serialize(VectorToTable(time)),Serialize(VectorToTable(name)),Serialize(VectorToTable(itemCount)),Serialize(VectorToTable(itemId)),Serialize(VectorToTable(itemNum)),Serialize(VectorToTable(miningExp)),Serialize(VectorToTable(miningLevel)))
	WndDigGem:setLogData(VectorToTable(logtype), VectorToTable(time), VectorToTable(name), VectorToTable(itemCount), VectorToTable(itemId), VectorToTable(itemNum), VectorToTable(miningExp), VectorToTable(miningLevel))
end

--@brief	购买矿晶（MINING_MiningBuyOk = 8）
function ProtocolProcessorDigGem:parse_MINING_MiningBuyOk(buyNum)
	WZLog("ProtocolProcessorDigGem:parse_MINING_MiningBuyOk")

	WndDigGem:buyGemCoinOK(buyNum)
end

--@brief	宝石背包（MINING_GetMiningBagOk = 11）
function ProtocolProcessorDigGem:parse_MINING_GetMiningBagOk(item, num)
	-- item : 背包中的宝石
	-- num : 该宝石的数量
	WZLog("ProtocolProcessorDigGem:parse_MINING_GetMiningBagOk")
	WndTransaction:setMyGem( VectorToTable(item), VectorToTable(num))
end

--@brief	回收宝石（MINING_RecyclingMiningOk = 13）
function ProtocolProcessorDigGem:parse_MINING_RecyclingMiningOk(item, num, getIds, getNums)
	-- item : 背包中的宝石
	-- num : 该宝石的数量
	WZLog("ProtocolProcessorDigGem:parse_MINING_RecyclingMiningOk")
	ProtocolProcessorDigGem:send_MINING_GetMiningBag( )
	if #VectorToTable(getIds) > 0 then
		WndRewardShow:showById(VectorToTable(getIds), VectorToTable(getNums))
	end
	WndTransaction.m_tDataList3 = {}
	WndTransaction:updateRight3()
end

--@brief	回收宝石（MINING_AuthenticateOk = 15）
function ProtocolProcessorDigGem:parse_MINING_AuthenticateOk(item, num, giveItemId, giveNum)
	-- item : 背包中的宝石
	-- num : 该宝石的数量
	-- giveItemId : 回收获得物品Id
	-- giveNum : 回收获得物品数量
	WZLog("ProtocolProcessorDigGem:parse_MINING_AuthenticateOk")

	WndGemAppraise:appraiseOK(VectorToTable(item), VectorToTable(num), VectorToTable(giveItemId), VectorToTable(giveNum))
end

--@brief	获取遗迹列表（MINING_GetRelicListOk = 17）		
function ProtocolProcessorDigGem:parse_MINING_GetRelicListOk(playerId, playerName, mapTime, mapId, mapNum, bossBloodMax, bossBloodCurrent, mapStatus, challengeTime, time)
	-- playerId : 遗迹发现者Id
	-- playerName : 遗迹发现者名称
	-- mapTime : 遗迹剩余时间
	-- mapId : 副本Id(服务器生成的唯一id)
	-- mapNum : 遗迹副本表中id
	-- bossBloodMax : boss总血量
	-- bossBloodCurrent : boss当前血量
	-- mapStatus : 副本状态 0挑战中 1挑战成功 2挑战失败
	-- challengeTime : 剩余挑战次数
	-- time : 恢复挑战次数剩余时间(秒)
	WZLog("ProtocolProcessorDigGem:parse_MINING_GetRelicListOk", Serialize(VectorToTable(playerId)), Serialize(VectorToTable(playerName)), Serialize(VectorToTable(mapTime)), Serialize(VectorToTable(mapId)), Serialize(VectorToTable(mapNum)), Serialize(VectorToTable(bossBloodMax)), Serialize(VectorToTable(bossBloodCurrent)), Serialize(VectorToTable(mapStatus)), challengeTime, time)
	if SceneCity.m_tWndBottomBar then
		if #VectorToTable(mapId) > 0 then
			SceneCity.m_tWndBottomBarObj:showRemainsBtn(true)
		else
			SceneCity.m_tWndBottomBarObj:showRemainsBtn(false)
		end
	end
	if WndRemainsChallenge.m_root then
		WndRemainsChallenge:setData(VectorToTable(playerId), VectorToTable(playerName), VectorToTable(mapTime), VectorToTable(mapId), VectorToTable(mapNum), VectorToTable(bossBloodMax), VectorToTable(bossBloodCurrent), VectorToTable(mapStatus), challengeTime, time)
	end
end

--@brief	获取遗迹信息（MINING_GetRelicInfoOk = 19）		
function ProtocolProcessorDigGem:parse_MINING_GetRelicInfoOk(mapId, mapNum, mapTime, bossBloodMax, bossBloodCurrent, challengeTime, time, reward, mapStatus, rank, rankPlayerId, rankPlayerName, rankHurt, vip, playerName, shareTime, playerRank)
	-- mapId : 副本Id(服务器生成的唯一id)
	-- mapNum : 遗迹副本表中id
	-- mapTime : 剩余时间
	-- bossBloodMax : boss总血量
	-- bossBloodCurrent : boss当前血量
	-- challengeTime : 剩余挑战次数
	-- time : 恢复挑战次数剩余时间
	-- reward : 奖励领取状态 0不可领取 1可领取
	-- mapStatus : 副本状态 0挑战中 1挑战成功 2挑战失败
	-- rank : 排行榜名次
	-- rankPlayerId : 排行榜玩家ID
	-- rankPlayerName : 排行榜玩家名字
	-- rankHurt : 排位赛伤害输出
	-- vip : 排行榜vip
	-- playerName : 遗迹发现者名称
	--shareTime : 可分享剩余倒计时
	--playerRank : 拥有副本者玩家排名
	WZLog("ProtocolProcessorDigGem:parse_MINING_GetRelicInfoOk", mapId, mapNum, mapTime, bossBloodMax, bossBloodCurrent, challengeTime, time, reward, mapStatus, Serialize(VectorToTable(rank)), Serialize(VectorToTable(rankPlayerId)), Serialize(VectorToTable(rankPlayerName)), Serialize(VectorToTable(rankHurt)), Serialize(VectorToTable(vip)), playerName, shareTime, playerRank)
	WndRemainsInfo:setRemainsData(mapId, mapNum, mapTime, bossBloodMax, bossBloodCurrent, challengeTime, time, reward, mapStatus, VectorToTable(rank), VectorToTable(rankPlayerId), VectorToTable(rankPlayerName), VectorToTable(rankHurt), VectorToTable(vip), playerName, shareTime, playerRank)
end

--@brief	开始战斗成功（MINING_MakePairOk = 21）		
function ProtocolProcessorDigGem:parse_MINING_MakePairOk(battleId, mapId, playerCount, playerId, playerName, playerTitle, playerGuild, playerLevel, playerSex, maxHP, maxPF, maxSP, attack, critRate, defence, injuryFree, wreckDefense, reduceCrit, power, armor, constitution, agility, lucky, inspire, headId, faceId, bodyId, weaponId, wingId, item_id, skillId, playerBuffCount, buffId, petAnimation, petGift, guaiBattleId, guaiId, guaiMaxHP, guaiNowHP, guaiAttack, guaiLevel, petAdvancedLevel, colour, bodycolour, footmark, professionId, professionSkill, mountId, childId, childName, childSex, childImage, assistSkillIds, defaultShapeBigSkill, blastEffect, extPropertyKey, extPropertyValue, extPropertyCount)
	-- battleId : 战斗组Id
	-- mapId : 地图id
	-- playerCount : 玩家数量
	-- playerId : 所有玩家id
	-- playerName : 房间内玩家昵称
	-- playerTitle : 称号
	-- playerGuild : 公会名称
	-- playerLevel : 房间内玩家等级
	-- playerSex : 玩家性别（0男1女）
	-- maxHP : 最大血量
	-- maxPF : 最大体力值
	-- maxSP : 最大怒气
	-- attack : 普攻击力
	-- critRate : 爆击攻击力比率
	-- defence : 防御力
	-- injuryFree : 免伤(10000)
	-- wreckDefense : 破防(10000)
	-- reduceCrit : 免暴(10000)
	-- power : 力量
	-- armor : 护甲
	-- constitution : 体质
	-- agility : 敏捷
	-- lucky : 幸运
	-- inspire : 鼓舞值
	-- headId : 头ID
	-- faceId : 脸ID
	-- bodyId : 身ID
	-- weaponId : 武器ID
	-- wingId : 翅膀ID
	-- item_id : 技能道具ID（0没装备，-1锁, 其他ID）
	-- skillId : 技能id
	-- playerBuffCount : 表示每一个player,buff的数量,如果没有要填零
	-- buffId : 玩家BUFFID
	-- petAnimation : 宠物形象，空字符串表示无宠物
	-- petGift : 宠物资质
	-- guaiBattleId : BOSS的战斗ID
	-- guaiId : BOSS怪表中的id
	-- guaiMaxHP : BOSS最大血量
	-- guaiNowHP : BOSS当前血量
	-- guaiAttack : BOSS攻击力
	-- guaiLevel : BOSS等级
	-- petAdvancedLevel : 宠物进阶等级
	-- colour : 头部颜色
	-- bodycolour : 身颜色
	-- footmark : 足迹
	-- defaultShapeBigSkill : 默认皮肤大招
    -- blastEffect : 当前爆破特效【168.1新增】 
    -- extPropertyKey : 扩展属性key [171.1新增]
	-- extPropertyValue : 扩展属性value [171.1新增]
	-- extPropertyCount : 扩展属性个数,用来切割extPropertyKey和extPropertyValue [171.1新增]

	WZLog("ProtocolProcessorDigGem:parse_MINING_MakePairOk",
	"\nbattleId = ",					Serialize(VectorToTable(battleId)),
	"\nmapId = ",					Serialize(VectorToTable(mapId)),
	"\nplayerCount = ",					Serialize(VectorToTable(playerCount)),
	"\nplayerId = ",					Serialize(VectorToTable(playerId)),
	"\nplayerName = ",					Serialize(VectorToTable(playerName)),
	"\nplayerTitle = ",					Serialize(VectorToTable(playerTitle)),
	"\nplayerGuild = ",					Serialize(VectorToTable(playerGuild)),
	"\nplayerLevel = ",					Serialize(VectorToTable(playerLevel)),
	"\nplayerSex = ",					Serialize(VectorToTable(playerSex)),
	"\nmaxHP = ",					Serialize(VectorToTable(maxHP)),
	"\nmaxPF = ",					Serialize(VectorToTable(maxPF)),
	"\nmaxSP = ",					Serialize(VectorToTable(maxSP)),
	"\nattack = ",					Serialize(VectorToTable(attack)),
	"\ncritRate = ",					Serialize(VectorToTable(critRate)),
	"\ndefence = ",					Serialize(VectorToTable(defence)),
	"\ninjuryFree = ",					Serialize(VectorToTable(injuryFree)),
	"\nwreckDefense = ",					Serialize(VectorToTable(wreckDefense)),
	"\nreduceCrit = ",					Serialize(VectorToTable(reduceCrit)),
	"\npower = ",					Serialize(VectorToTable(power)),
	"\narmor = ",					Serialize(VectorToTable(armor)),
	"\nconstitution = ",					Serialize(VectorToTable(constitution)),
	"\nagility = ",					Serialize(VectorToTable(agility)),
	"\nlucky = ",					Serialize(VectorToTable(lucky)),
	"\ninspire = ",					Serialize(VectorToTable(inspire)),
	"\nheadId = ",					Serialize(VectorToTable(headId)),
	"\nfaceId = ",					Serialize(VectorToTable(faceId)),
	"\nbodyId = ",					Serialize(VectorToTable(bodyId)),
	"\nweaponId = ",					Serialize(VectorToTable(weaponId)),
	"\nwingId = ",					Serialize(VectorToTable(wingId)),
	"\nitem_id = ",					Serialize(VectorToTable(item_id)),
	"\nskillId = ",					Serialize(VectorToTable(skillId)),
	"\nplayerBuffCount = ",					Serialize(VectorToTable(playerBuffCount)),
	"\nbuffId = ",					Serialize(VectorToTable(buffId)),
	"\npetAnimation = ",					Serialize(VectorToTable(petAnimation)),
	"\npetGift = ",					Serialize(VectorToTable(petGift)),
	"\nguaiBattleId = ",					Serialize(VectorToTable(guaiBattleId)),
	"\nguaiId = ",					Serialize(VectorToTable(guaiId)),
	"\nguaiMaxHP = ",					Serialize(VectorToTable(guaiMaxHP)),
	"\nguaiNowHP = ",					Serialize(VectorToTable(guaiNowHP)),
	"\nguaiAttack = ",					Serialize(VectorToTable(guaiAttack)),
	"\nguaiLevel = ",					Serialize(VectorToTable(guaiLevel)),
	"\npetAdvancedLevel = ",					Serialize(VectorToTable(petAdvancedLevel)),
	"\ncolour = ",					Serialize(VectorToTable(colour)),
	"\nbodycolour = ",					Serialize(VectorToTable(bodycolour)),
	"\nfootmark = ",					Serialize(VectorToTable(footmark)),
	"\ndefaultShapeBigSkill =",		Serialize(VectorToTable(defaultShapeBigSkill)),
	"\nblastEffect =",		Serialize(VectorToTable(blastEffect)),
	"\nextPropertyKey =",				Serialize(VectorToTable(extPropertyKey)),
	"\nextPropertyValue =",		Serialize(VectorToTable(extPropertyValue)),
	"\nextPropertyCount =",		Serialize(VectorToTable(extPropertyCount))
	)
		
	local insptre = inspire
	local petSkill = skillId
	local petId = petAnimation
	local petParam = petGift
	local guaiAtk = guaiAttack
	local guaiLv = guaiLevel
	local petLevel = petAdvancedLevel
	local bodyColour = bodycolour

	WZLog("parse_MINING_MakePairOk",VectorToTable())
	WndRemainsInfo:receiveStartOk(battleId, mapId, playerCount,VectorToTable(playerId), VectorToTable(playerName), VectorToTable(playerTitle), VectorToTable(playerGuild), VectorToTable(playerLevel), 
		VectorToTable(playerSex), VectorToTable(maxHP), VectorToTable(maxPF), VectorToTable(maxSP), VectorToTable(attack), VectorToTable(critRate), VectorToTable(defence), VectorToTable(injuryFree), 
		VectorToTable(wreckDefense), VectorToTable(reduceCrit), VectorToTable(power), VectorToTable(armor), VectorToTable(constitution), VectorToTable(agility), VectorToTable(lucky), VectorToTable(insptre),
		VectorToTable(headId), VectorToTable(faceId), VectorToTable(bodyId), VectorToTable(weaponId), VectorToTable(wingId), VectorToTable(item_id), VectorToTable(playerBuffCount), VectorToTable(buffId), 
		VectorToTable(petId), VectorToTable(petSkill), VectorToTable(petParam), VectorToTable(guaiBattleId), VectorToTable(guaiId), VectorToTable(guaiMaxHP), VectorToTable(guaiNowHP),VectorToTable(guaiAtk),
		VectorToTable(guaiLv), VectorToTable(weaponSkill), VectorToTable(petLevel),VectorToTable(colour),VectorToTable(bodyColour),VectorToTable(footmark), VectorToTable(professionId), VectorToTable(professionSkill), 
		VectorToTable(mountId), VectorToTable(childId), VectorToTable(childName), VectorToTable(childSex), VectorToTable(childImage), VectorToTable(assistSkillIds), VectorToTable(defaultShapeBigSkill), VectorToTable(blastEffect), 
		VectorToTable(extPropertyKey), VectorToTable(extPropertyValue), VectorToTable(extPropertyCount))
end

--@brief	领取遗迹奖励（MINING_GetMapRewardOk = 23）		
function ProtocolProcessorDigGem:parse_MINING_GetMapRewardOk(status, itemId, num)
	-- status : 0成功 其他为失败
	-- itemId : 物品Id
	-- num : 数量
	WZLog("ProtocolProcessorDigGem:parse_MINING_GetMapRewardOk", status, Serialize(VectorToTable(itemId)), Serialize(VectorToTable(num)))
	WndRemainsInfo:getRewardOk(status, VectorToTable(itemId), VectorToTable(num))
end

--@brief	分享副本成功（MINING_ShareMapOk = 26）		
function ProtocolProcessorDigGem:parse_MINING_ShareMapOk(result)
	-- result : 0成功 其他为失败
	WZLog("ProtocolProcessorDigGem:parse_MINING_ShareMapOk", result)
	if WndRemainsInfo.m_root then
		WndRemainsInfo:getShareMapOk(result)
	end
	if WndDigGem.m_root then
		WndDigGem:getShareMapOk(result)
	end
end

--@brief	获取雇佣好友列表成功（MINING_GetHireFriendListOk= 36）		
function ProtocolProcessorDigGem:parse_MINING_GetHireFriendListOk(playerId, isOnline, playerName, sex, vipLevel, faceItemId, headItemId, headColor, minerLevel, hireId, hireEndTime, logtype, logTime)
	-- playerId : 玩家ID
	-- isOnline : 玩家是否在线
	-- playerName : 玩家昵称
	-- sex : 玩家性别
	-- vipLevel : 玩家vip等级
	-- faceItemId : 玩家脸
	-- headItemId : 玩家头
	-- headColor : 玩家头部染色
	-- minerLevel : 玩家矿工等级
	-- hireId : 雇佣此玩家的ID【没被雇佣为0】
	-- hireEndTime : 雇佣关系结束时间【注：要用服务器时间进行判断】
	-- logtype : 最近一条日志类型(类型1为开始挖宝，2为时间到挖宝结束，3为背包满停止挖宝，4为主动停止挖宝，5为挖到宝物，6为熟练度升级)
	-- logTime : 记录日志时间戳
	WZLog("ProtocolProcessorDigGem:parse_MINING_GetHireFriendListOk")
	-- WZLog("ProtocolProcessorDigGem:parse_MINING_GetHireFriendListOk",
	-- 	"\nplayerId = ",Serialize(VectorToTable(playerId)),
	-- 	"\nisOnline = ",Serialize(VectorToTable(isOnline)),
	-- 	"\nplayerName = ",Serialize(VectorToTable(playerName)),
	-- 	"\nsex = ",Serialize(VectorToTable(sex)),
	-- 	"\nvipLevel = ",Serialize(VectorToTable(vipLevel)),
	-- 	"\nfaceItemId = ",Serialize(VectorToTable(faceItemId)),
	-- 	"\nheadItemId = ",Serialize(VectorToTable(headItemId)),
	-- 	"\nheadColor = ",Serialize(VectorToTable(headColor)),
	-- 	"\nminerLevel = ",Serialize(VectorToTable(minerLevel)),
	-- 	"\nhireId = ",Serialize(VectorToTable(hireId)),
	-- 	"\nhireEndTime = ",Serialize(VectorToTable(hireEndTime)),
	-- 	"\nlogtype = ",Serialize(VectorToTable(logtype)),
	-- 	"\nlogTime = ",Serialize(VectorToTable(logTime)))

	WndDigGem:getHireFriendListOk(VectorToTable(playerId), VectorToTable(isOnline), VectorToTable(playerName), VectorToTable(sex), VectorToTable(vipLevel), VectorToTable(faceItemId), VectorToTable(headItemId), VectorToTable(headColor), VectorToTable(minerLevel), VectorToTable(hireId), VectorToTable(hireEndTime), VectorToTable(logtype), VectorToTable(logTime), VectorToTable(logName))
end

--@brief	获取雇佣好友列表成功（MINING_HireFriendOk= 38）
function ProtocolProcessorDigGem:parse_MINING_HireFriendOk(result)
	-- result : 0成功 其他为失败【如：1=好友已被他人雇佣|...】
	WZLog("ProtocolProcessorDigGem:parse_MINING_HireFriendOk", result)
end

--@brief	互动操作成功（MINING_HireInteractOk= 42）		
function ProtocolProcessorDigGem:parse_MINING_HireInteractOk(result, playerId, interactType, moodChange)
	-- result : 互动结果【0=成功|1=失败:玩家不是雇员不能进行互动操作】
	-- playerId : 玩家ID
	-- interactType : 交互类型【1=飞吻|2=面包|3=皮鞭】
	-- moodChange : 心情值变化量【增加为正数，减少为负数】【注：仅用于互动效果飘字，不能拿来计算】
	WZLog("ProtocolProcessorDigGem:parse_MINING_HireInteractOk", result, playerId, interactType, moodChange)
	WndDigGem:getHireInteractOk(result, playerId, interactType, moodChange)
end

--@brief	驱赶偷矿者成功（MINING_ChasingThiefOk= 46）		
function ProtocolProcessorDigGem:parse_MINING_ChasingThiefOk()
	WZLog("ProtocolProcessorDigGem:parse_MINING_ChasingThiefOk")
	WndDigGem:getChasingThiefOk()
end


-------------------------------------协议错误处理方法模块--------------------------------------
--@brief	获取挖矿信息（MINING_GetMining = 1）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorDigGem:send_MINING_GetMining_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorDigGem:send_MINING_GetMining_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MINING, Protocol.MINING_GetMining, nflag, sMessage)
end

--@brief	获取挖矿日志（MINING_MiningLog = 3）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorDigGem:send_MINING_MiningLog_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorDigGem:send_MINING_MiningLog_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MINING, Protocol.MINING_MiningLog, nflag, sMessage)
end

--@brief	开始挖宝（MINING_StartMining = 5）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorDigGem:send_MINING_StartMining_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorDigGem:send_MINING_StartMining_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MINING, Protocol.MINING_StartMining, nflag, sMessage)
end

--@brief	停止挖宝（MINING_StopMining = 6）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorDigGem:send_MINING_StopMining_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorDigGem:send_MINING_StopMining_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MINING, Protocol.MINING_StopMining, nflag, sMessage)
end

--@brief	购买矿晶（MINING_MiningBuy = 7）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorDigGem:send_MINING_MiningBuy_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorDigGem:send_MINING_MiningBuy_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MINING, Protocol.MINING_MiningBuy, nflag, sMessage)
end

--@brief	购买挖矿工具（MINING_BuyTool = 9）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorDigGem:send_MINING_BuyTool_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorDigGem:send_MINING_BuyTool_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MINING, Protocol.MINING_BuyTool, nflag, sMessage)
end

--@brief	宝石背包（MINING_GetMiningBag = 10）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorDigGem:send_MINING_GetMiningBag_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorDigGem:send_MINING_GetMiningBag_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MINING, Protocol.MINING_GetMiningBag, nflag, sMessage)
end

--@brief	回收宝石（MINING_RecyclingMining = 12）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorDigGem:send_MINING_RecyclingMining_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorDigGem:send_MINING_RecyclingMining_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MINING, Protocol.MINING_RecyclingMining, nflag, sMessage)
end

--@brief	鉴定宝石（MINING_Authenticate = 14）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorDigGem:send_MINING_Authenticate_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorDigGem:send_MINING_Authenticate_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MINING, Protocol.MINING_Authenticate, nflag, sMessage)
end

--@brief	获取遗迹列表（MINING_GetRelicList = 16）		错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorDigGem:send_MINING_GetRelicList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorDigGem:send_MINING_GetRelicList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MINING, Protocol.MINING_GetRelicList, nflag, sMessage)
end

--@brief	获取具体遗迹信息（MINING_GetRelicInfo = 18）		错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorDigGem:send_MINING_GetRelicInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorDigGem:send_MINING_GetRelicInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MINING, Protocol.MINING_GetRelicInfo, nflag, sMessage)
end

--@brief	开始战斗（MINING_MakePair = 20）		错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorDigGem:send_MINING_MakePair_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorDigGem:send_MINING_MakePair_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MINING, Protocol.MINING_MakePair, nflag, sMessage)
end

--@brief	领取遗迹奖励（MINING_GetMapReward = 22）		错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorDigGem:send_MINING_GetMapReward_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorDigGem:send_MINING_GetMapReward_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MINING, Protocol.MINING_GetMapReward, nflag, sMessage)
end

--@brief	分享副本（MINING_ShareMap= 25）		错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorDigGem:send_MINING_ShareMap_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorDigGem:send_MINING_ShareMap_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MINING, Protocol.MINING_ShareMap, nflag, sMessage)
end

--@brief	获取雇佣好友列表（MINING_GetHireFriendList= 35）		错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorDigGem:send_MINING_GetHireFriendList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorDigGem:send_MINING_GetHireFriendList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MINING, Protocol.MINING_GetHireFriendList, nflag, sMessage)
end

--@brief	雇佣好友（MINING_HireFriend= 37）		错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorDigGem:send_MINING_HireFriend_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorDigGem:send_MINING_HireFriend_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MINING, Protocol.MINING_HireFriend, nflag, sMessage)
end

--@brief	互动操作（MINING_HireInteract= 41）		错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorDigGem:send_MINING_HireInteract_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorDigGem:send_MINING_HireInteract_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MINING, Protocol.MINING_HireInteract, nflag, sMessage)
end

--@brief	驱赶偷矿者（MINING_ChasingThief= 45）		错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorDigGem:send_MINING_ChasingThief_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorDigGem:send_MINING_ChasingThief_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MINING, Protocol.MINING_ChasingThief, nflag, sMessage)
end
