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

	--@brief	获取挖矿信息（MINING_GetMiningOk = 2）
	self:regProtocolCallbackFunction( Protocol.MAIN_MINING, Protocol.MINING_GetMiningOk, "ProtocolProcessorDigGem:parse_MINING_GetMiningOk", "iiiiviviviviii")
    --@brief	获取挖矿日志（MINING_MiningLogOk = 4）
	self:regProtocolCallbackFunction( Protocol.MAIN_MINING, Protocol.MINING_MiningLogOk, "ProtocolProcessorDigGem:parse_MINING_MiningLogOk", "vivsvivivi")
	--@brief	购买矿晶（MINING_MiningBuyOk = 8）
	self:regProtocolCallbackFunction( Protocol.MAIN_MINING, Protocol.MINING_MiningBuyOk, "ProtocolProcessorDigGem:parse_MINING_MiningBuyOk", "i")
	--@brief	宝石背包（MINING_GetMiningBagOk = 11）
	self:regProtocolCallbackFunction( Protocol.MAIN_MINING, Protocol.MINING_GetMiningBagOk, "ProtocolProcessorDigGem:parse_MINING_GetMiningBagOk", "vivi")
	--@brief	回收宝石（MINING_RecyclingMiningOk = 13）
	self:regProtocolCallbackFunction( Protocol.MAIN_MINING, Protocol.MINING_RecyclingMiningOk, "ProtocolProcessorDigGem:parse_MINING_RecyclingMiningOk", "vivivivi")
	--@brief	回收宝石（MINING_AuthenticateOk = 15）
	self:regProtocolCallbackFunction( Protocol.MAIN_MINING, Protocol.MINING_AuthenticateOk, "ProtocolProcessorDigGem:parse_MINING_AuthenticateOk", "vivivivi")

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
	WZLog("send_MINING_BuyTool")
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


-------------------------------------服务器到客户端协议回调方法模块--------------------------------------
--@brief	获取挖矿信息（MINING_GetMiningOk = 2）
function ProtocolProcessorDigGem:parse_MINING_GetMiningOk(useTool, remainTime, level, exp, toolId, remainToolTime, item, num, toolTime, buyNum)
	-- useTool : 正在使用的挖矿工具（0为不在挖矿中）
	-- remainTime : 下一次获取宝石的倒计时（秒）（useTool大于0是才有效）
	-- level : 熟练度等级
	-- exp : 熟练度经验
	-- toolId : 拥有的工具
	-- remainToolTime : 该工具剩余的挖矿时间（分）
	-- item : 背包中的宝石
	-- num : 该宝石的数量
	-- toolTime : 使用的工具剩余时间
	-- buyNum : 当天购买矿晶的次数
	WZLog("ProtocolProcessorDigGem:parse_MINING_GetMiningOk")
	if WndDigGem.m_root then
		WndDigGem:setData(useTool, remainTime, level, exp, VectorToTable(toolId), VectorToTable(remainToolTime), VectorToTable(item), VectorToTable(num), toolTime, buyNum)
	end

	if SceneCity.m_root and CheckButtonOpen(ISLAND_BUILDING_TREASURE, true) then
		SceneCity:updateRedDotBuilding("DigGem", useTool == 0, GlobalMethod:ccp(155,40))
	end
end

--@brief	获取挖矿日志（MINING_MiningLogOk = 4）
function ProtocolProcessorDigGem:parse_MINING_MiningLogOk(logtype, time, itemId, miningExp, miningLevel)
	-- logtype : 日志类型(类型1为开始挖宝，2为时间到挖宝结束，3为背包满停止挖宝，4为主动停止挖宝，5为挖到宝物，6为熟练度升级)
	-- time : 记录日志时间戳
	-- itemId : 物品Id
	-- miningExp : 获得经验
	-- miningLevel : 熟练度等级
	WZLog("ProtocolProcessorDigGem:parse_MINING_MiningLogOk")
	WndDigGem:setLogData(VectorToTable(logtype), VectorToTable(time), VectorToTable(itemId), VectorToTable(miningExp), VectorToTable(miningLevel))
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