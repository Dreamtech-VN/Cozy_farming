--ProtocolProcessorTransaction.lua
--@brief	交易行相关协议
--@date  	2017/3/15
--@author 	zsq
--@note 	合成相关协议


ProtocolProcessorTransaction = ProtocolProcessorBase:new()


--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorTransaction:regAll()
	--服务器到客户端协议注册
--@brief	获取商品列表（TRANSACTION_GetCommodityListOk = 2）
self:regProtocolCallbackFunction( Protocol.MAIN_TRANSACTION, Protocol.TRANSACTION_GetCommodityListOk, "ProtocolProcessorTransaction:parse_TRANSACTION_GetCommodityListOk", "vivivivi")
--@brief	购买商品（TRANSACTION_BuyCommodityStatus = 4）
self:regProtocolCallbackFunction( Protocol.MAIN_TRANSACTION, Protocol.TRANSACTION_BuyCommodityStatus, "ProtocolProcessorTransaction:parse_TRANSACTION_BuyCommodityStatus", "tiivivi")
--@brief	获取我的出售商品列表（TRANSACTION_GetSaleListOk = 6）
self:regProtocolCallbackFunction( Protocol.MAIN_TRANSACTION, Protocol.TRANSACTION_GetSaleListOk, "ProtocolProcessorTransaction:parse_TRANSACTION_GetSaleListOk", "vivivivivii")
--@brief	上架商品（TRANSACTION_SalesStatus = 8）
self:regProtocolCallbackFunction( Protocol.MAIN_TRANSACTION, Protocol.TRANSACTION_SalesStatus, "ProtocolProcessorTransaction:parse_TRANSACTION_SalesStatus", "t")
--@brief	下架商品（TRANSACTION_UnSalesStatus = 10）
self:regProtocolCallbackFunction( Protocol.MAIN_TRANSACTION, Protocol.TRANSACTION_UnSalesStatus, "ProtocolProcessorTransaction:parse_TRANSACTION_UnSalesStatus", "tii")
--@brief	获取交易日志列表（TRANSACTION_GetTransactionLogListOk = 12）
self:regProtocolCallbackFunction( Protocol.MAIN_TRANSACTION, Protocol.TRANSACTION_GetTransactionLogListOk, "ProtocolProcessorTransaction:parse_TRANSACTION_GetTransactionLogListOk", "vtvivivivivsvivivi")


--@brief	获取商品列表（TRANSACTION_GetCommodityList = 1）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_TRANSACTION, Protocol.TRANSACTION_GetCommodityList, "ProtocolProcessorTransaction:send_TRANSACTION_GetCommodityList_ErrorProcess", "is" )
--@brief	购买商品（TRANSACTION_BuyCommodity = 3）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_TRANSACTION, Protocol.TRANSACTION_BuyCommodity, "ProtocolProcessorTransaction:send_TRANSACTION_BuyCommodity_ErrorProcess", "is" )
--@brief	获取我的出售商品列表（TRANSACTION_GetSaleList = 5）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_TRANSACTION, Protocol.TRANSACTION_GetSaleList, "ProtocolProcessorTransaction:send_TRANSACTION_GetSaleList_ErrorProcess", "is" )
--@brief	上架商品（TRANSACTION_Sales = 7）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_TRANSACTION, Protocol.TRANSACTION_Sales, "ProtocolProcessorTransaction:send_TRANSACTION_Sales_ErrorProcess", "is" )
--@brief	下架商品（TRANSACTION_UnSales = 9）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_TRANSACTION, Protocol.TRANSACTION_UnSales, "ProtocolProcessorTransaction:send_TRANSACTION_UnSales_ErrorProcess", "is" )
--@brief	获取交易日志列表（TRANSACTION_GetTransactionLogList = 11）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_TRANSACTION, Protocol.TRANSACTION_GetTransactionLogList, "ProtocolProcessorTransaction:send_TRANSACTION_GetTransactionLogList_ErrorProcess", "is" )
	
end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorTransaction:unregAll()
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块Begin--------------------------------------
--@brief	获取商品列表（TRANSACTION_GetCommodityList = 1）
function ProtocolProcessorTransaction:send_TRANSACTION_GetCommodityList(commodityType, commodityQuality, commodityIds )
	WZLog("send_TRANSACTION_GetCommodityList", commodityType, commodityQuality, commodityIds )
	local sender = Protocol:getSender( Protocol.MAIN_TRANSACTION, Protocol.TRANSACTION_GetCommodityList )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( commodityType )	-- 商品类型
	sender:writeInt( commodityQuality )	-- 商品品质
	sender:writeInts( commodityIds )	-- 商品ID(没有可以不传)
	SendProtocol(sender,false) --true:showLoading
end

--@brief	购买商品（TRANSACTION_BuyCommodity = 3）
function ProtocolProcessorTransaction:send_TRANSACTION_BuyCommodity(commodityId, itemId, quantity )
	WZLog("send_TRANSACTION_BuyCommodity")
	local sender = Protocol:getSender( Protocol.MAIN_TRANSACTION, Protocol.TRANSACTION_BuyCommodity )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( commodityId )	-- 商品ID
	sender:writeInt( itemId )	-- 商品ID
	sender:writeInt( quantity )	-- 购买数量
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取我的出售商品列表（TRANSACTION_GetSaleList = 5）
function ProtocolProcessorTransaction:send_TRANSACTION_GetSaleList( )
	WZLog("send_TRANSACTION_GetSaleList")
	local sender = Protocol:getSender( Protocol.MAIN_TRANSACTION, Protocol.TRANSACTION_GetSaleList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	上架商品（TRANSACTION_Sales = 7）
function ProtocolProcessorTransaction:send_TRANSACTION_Sales(itemId, quantity )
	WZLog("send_TRANSACTION_Sales")
	local sender = Protocol:getSender( Protocol.MAIN_TRANSACTION, Protocol.TRANSACTION_Sales )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( itemId )	-- 上架物品ID
	sender:writeInt( quantity )	-- 销售数量
	SendProtocol(sender,false) --true:showLoading
end

--@brief	下架商品（TRANSACTION_UnSales = 9）
function ProtocolProcessorTransaction:send_TRANSACTION_UnSales(commodityId )
	WZLog("send_TRANSACTION_UnSales")
	local sender = Protocol:getSender( Protocol.MAIN_TRANSACTION, Protocol.TRANSACTION_UnSales )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( commodityId )	-- 下架商品ID
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取交易日志列表（TRANSACTION_GetTransactionLogList = 11）
function ProtocolProcessorTransaction:send_TRANSACTION_GetTransactionLogList( )
	WZLog("send_TRANSACTION_GetTransactionLogList")
	local sender = Protocol:getSender( Protocol.MAIN_TRANSACTION, Protocol.TRANSACTION_GetTransactionLogList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

-------------------------------------客户端到服务器协议发送方法模块End--------------------------------------


-------------------------------------服务器到客户端协议回调方法模块Begin--------------------------------------
--@brief	获取商品列表（TRANSACTION_GetCommodityListOk = 2）
function ProtocolProcessorTransaction:parse_TRANSACTION_GetCommodityListOk(commodityIds, itemIds, quantitys, prices)
	-- commodityIds : 商品ID
	-- itemIds : 物品ID
	-- quantitys : 物品数量
	-- prices : 商品单价
	WZLog("ProtocolProcessorTransaction:parse_TRANSACTION_GetCommodityListOk", Serialize(VectorToTable(commodityIds)), Serialize(VectorToTable(itemIds)), Serialize(VectorToTable(quantitys)), Serialize(VectorToTable(prices)))
	WndTransaction:setData1(VectorToTable(commodityIds), VectorToTable(itemIds), VectorToTable(quantitys), VectorToTable(prices))
end

--@brief	购买商品（TRANSACTION_BuyCommodityStatus = 4）
function ProtocolProcessorTransaction:parse_TRANSACTION_BuyCommodityStatus(status, itemId, quantity, authenticateItemId, authenticateItemNum)
	-- status : 购买返回状态（0购买成功，1背包已满，2晶石不足，3商品已出售）
	-- itemId : 获得物品ID
	-- quantity : 获得物品数量
	-- authenticateItemId : 购买的物品鉴定后获得的物品ID【162新增】
	-- authenticateItemNum : 购买的物品鉴定后获得的物品数量【162新增】 
	local authenticateItemId = VectorToTable(authenticateItemId)
	local authenticateItemNum = VectorToTable(authenticateItemNum)
	WZLog("ProtocolProcessorTransaction:parse_TRANSACTION_BuyCommodityStatus", status, Serialize(itemId), Serialize(quantity), Serialize(VectorToTable(authenticateItemId)), Serialize(VectorToTable(authenticateItemNum)))
	if status == 0 then
		if GetTableLen(authenticateItemNum) == 0 and GetTableLen(authenticateItemNum) == 0 then
			WndRewardShow:showById({itemId},{quantity})
		else
			WndRewardShow:showById(authenticateItemId,authenticateItemNum)
		end
		WndTransaction:sendGetCommodityList()
	elseif status == 1 then
		MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
	elseif status == 2 then
		MsgBoxManager:showTipBox(LocalStrings.TRANSACTION45)
	elseif status == 3 then
		MsgBoxManager:showTipBox(LocalStrings.TRANSACTION46)
	end
end

--@brief	获取我的出售商品列表（TRANSACTION_GetSaleListOk = 6）
function ProtocolProcessorTransaction:parse_TRANSACTION_GetSaleListOk(commodityIds, itemIds, quantitys, saleNums, saleTime, todaySaleCount)
	-- commodityIds : 商品ID
	-- itemIds : 物品ID
	-- quantitys : 商品数量
	-- saleNums : 已出售数量
	-- saleTime : 剩余销售时间（分钟）
	-- todaySaleCount : 玩家今日已售出商品数量 
	WZLog("ProtocolProcessorTransaction:parse_TRANSACTION_GetSaleListOk",
		"\ncommodityIds =",Serialize(VectorToTable(commodityIds)), 
		"\nitemIds =",Serialize(VectorToTable(itemIds)), 
		"\nquantitys =",Serialize(VectorToTable(quantitys)), 
		"\nsaleNums =",Serialize(VectorToTable(saleNums)), 
		"\nsaleTime =",Serialize(VectorToTable(saleTime)), 
		"\ntodaySaleCount =",todaySaleCount)
	WndTransaction:setData2(VectorToTable(commodityIds), VectorToTable(itemIds), VectorToTable(quantitys), VectorToTable(saleNums), VectorToTable(saleTime), todaySaleCount)
end

--@brief	上架商品（TRANSACTION_SalesStatus = 8）
function ProtocolProcessorTransaction:parse_TRANSACTION_SalesStatus(status)
	-- status : 购买返回状态（0上架成功，1上架栏已满，2物品数量不足）
	WZLog("ProtocolProcessorTransaction:parse_TRANSACTION_SalesStatus")
	if status == 0 then
		MsgBoxManager:showTipBox(LocalStrings.TRANSACTION47)
		WndTransaction.added = true
		ProtocolProcessorTransaction:send_TRANSACTION_GetSaleList( )
		ProtocolProcessorDigGem:send_MINING_GetMiningBag( )
	elseif status == 1 then
		MsgBoxManager:showTipBox(LocalStrings.TRANSACTION48)
	elseif status == 2 then
		MsgBoxManager:showTipBox(LocalStrings.TRANSACTION49)
	end
end

--@brief	下架商品（TRANSACTION_UnSalesStatus = 10）
function ProtocolProcessorTransaction:parse_TRANSACTION_UnSalesStatus(status, itemId, quantity)
	-- status : 购买返回状态（0下架成功，1已经被买走）
	-- itemId : 获得物品ID
	-- quantity : 获得物品数量
	WZLog("ProtocolProcessorTransaction:parse_TRANSACTION_UnSalesStatus")
	if status == 0 then
		MsgBoxManager:showTipBox(LocalStrings.TRANSACTION50)
		ProtocolProcessorTransaction:send_TRANSACTION_GetSaleList( )
		ProtocolProcessorDigGem:send_MINING_GetMiningBag( )
	elseif status == 1 then
		MsgBoxManager:showTipBox(LocalStrings.TRANSACTION55)
	elseif status == 2 then
		MsgBoxManager:showTipBox(LocalStrings.TRANSACTION51)
	end
end

--@brief	获取交易日志列表（TRANSACTION_GetTransactionLogListOk = 12）
function ProtocolProcessorTransaction:parse_TRANSACTION_GetTransactionLogListOk(logType, itemIds, itemNums, prices, addSpar, commodityTime, authenticateNum, authenticateItemId, authenticateItemNum)
	-- logType : 日志类型（0首充日志，1买入日志）
	-- itemIds : 物品ID
	-- itemNums : 物品数量
	-- prices : 成交价格
	-- addSpar : 获得矿晶
	-- commodityTime : 交易时间
	-- authenticateNum : 鉴定产出数量【162新增】 
	-- authenticateItemId : 鉴定产出物ID【162新增】 
	-- authenticateItemNum :  鉴定产出物数量【162新增】
	WZLog("ProtocolProcessorTransaction:parse_TRANSACTION_GetTransactionLogListOk")
	-- WZLog("ProtocolProcessorTransaction:parse_TRANSACTION_GetTransactionLogListOk", 
	-- 	"\nlogType",Serialize(VectorToTable(logType)), 
	-- 	"\nitemIds",Serialize(VectorToTable(itemIds)), 
	-- 	"\nitemNums",Serialize(VectorToTable(itemNums)), 
	-- 	"\nprices",Serialize(VectorToTable(prices)), 
	-- 	"\naddSpar",Serialize(VectorToTable(addSpar)), 
	-- 	"\ncommodityTime",Serialize(VectorToTable(commodityTime)), 
	-- 	"\nauthenticateNum",Serialize(VectorToTable(authenticateNum)), 
	-- 	"\nauthenticateItemId",Serialize(VectorToTable(authenticateItemId)), 
	-- 	"\nauthenticateItemNum",Serialize(VectorToTable(authenticateItemNum)))
	WndTransaction:setData4(VectorToTable(logType), VectorToTable(itemIds), VectorToTable(itemNums), VectorToTable(prices), VectorToTable(addSpar), VectorToTable(commodityTime), VectorToTable(authenticateNum), VectorToTable(authenticateItemId), VectorToTable(authenticateItemNum))
end
-------------------------------------服务器到客户端协议回调方法模块End--------------------------------------


-------------------------------------协议错误处理方法模块Begin--------------------------------------
--@brief	获取商品列表（TRANSACTION_GetCommodityList = 1）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorTransaction:send_TRANSACTION_GetCommodityList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorTransaction:send_TRANSACTION_GetCommodityList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TRANSACTION, Protocol.TRANSACTION_GetCommodityList, nflag, sMessage)
end

--@brief	购买商品（TRANSACTION_BuyCommodity = 3）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorTransaction:send_TRANSACTION_BuyCommodity_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorTransaction:send_TRANSACTION_BuyCommodity_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TRANSACTION, Protocol.TRANSACTION_BuyCommodity, nflag, sMessage)
end

--@brief	获取我的出售商品列表（TRANSACTION_GetSaleList = 5）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorTransaction:send_TRANSACTION_GetSaleList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorTransaction:send_TRANSACTION_GetSaleList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TRANSACTION, Protocol.TRANSACTION_GetSaleList, nflag, sMessage)
end

--@brief	上架商品（TRANSACTION_Sales = 7）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorTransaction:send_TRANSACTION_Sales_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorTransaction:send_TRANSACTION_Sales_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TRANSACTION, Protocol.TRANSACTION_Sales, nflag, sMessage)
end

--@brief	下架商品（TRANSACTION_UnSales = 9）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorTransaction:send_TRANSACTION_UnSales_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorTransaction:send_TRANSACTION_UnSales_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TRANSACTION, Protocol.TRANSACTION_UnSales, nflag, sMessage)
end

--@brief	获取交易日志列表（TRANSACTION_GetTransactionLogList = 11）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorTransaction:send_TRANSACTION_GetTransactionLogList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorTransaction:send_TRANSACTION_GetTransactionLogList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TRANSACTION, Protocol.TRANSACTION_GetTransactionLogList, nflag, sMessage)
end
-------------------------------------协议错误处理方法模块End--------------------------------------





