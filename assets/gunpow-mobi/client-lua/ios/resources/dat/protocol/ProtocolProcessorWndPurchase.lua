--ProtocolProcessorWndPurchase.lua
--@brief	商城模块协议
--@date  	2013/12/23
--@author 	SunShanshan


ProtocolProcessorWndPurchase = ProtocolProcessorBase:new()

-------------------------------------公有方法模块--------------------------------------

--@brief	注册协议组所有协议
function ProtocolProcessorWndPurchase:regAll()
	 
	--@brief	返回物品价格表
	self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.TRATE_GetItemPriceOk, "ProtocolProcessorWndPurchase:parse_TRATE_GetItemPriceOk", "ivivivivivtvivivivivivi")

	--@brief	购买物品结果
	self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.TRATE_BuyResult, "ProtocolProcessorWndPurchase:parse_TRATE_BuyResult", "bsiiiisii")

	--@brief	购买物品结果
	self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.TRATE_BuyPromotResult, "ProtocolProcessorWndPurchase:parse_TRATE_BuyPromotResult", "bsiiiisi")
	
	--@brief	获取购买限量物品价格
	self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.TRATE_GetLimitedItemPriceOk, "ProtocolProcessorWndPurchase:parse_TRATE_GetLimitedItemPriceOk", "iiiii")

	--@brief	购买限量物品
	self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.TRATE_BuyLimitedItemOk, "ProtocolProcessorWndPurchase:parse_TRATE_BuyLimitedItemOk", "iii")

	--------------错误协议注册-------------------
	 
   
	--@brief	获取商品价格错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.TRATE_GetItemPrice , "ProtocolProcessorWndPurchase:send_TRATE_GetItemPrice_ErrorProcess", "is" )
	
	--@brief	购买物品错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.TRATE_BuyItems , "ProtocolProcessorWndPurchase:send_TRATE_BuyItems_ErrorProcess", "is" )
	 
    --@brief	购买物品错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.TRATE_BuyPromotItems , "ProtocolProcessorWndPurchase:send_TRATE_BuyPromotItems_ErrorProcess", "is" )

	--@brief	获取购买限量物品价格错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.TRATE_GetLimitedItemPrice, "ProtocolProcessorWndPurchase:send_TRATE_GetLimitedItemPrice_ErrorProcess", "is" )

	--@brief	购买限量物品错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.TRATE_BuyLimitedItem, "ProtocolProcessorWndPurchase:send_TRATE_BuyLimitedItem_ErrorProcess", "is" )

end

--@brief	反注册协议组所有协议
function ProtocolProcessorWndPurchase:unregAll()
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块--------------------------------------

--@brief	获取商品价格
function ProtocolProcessorWndPurchase:send_TRATE_GetItemPrice (itemId, shoptype )
	WZLog("send_TRATE_GetItemPrice ")
	local sender = Protocol:getSender( Protocol.MAIN_TRATE, Protocol.TRATE_GetItemPrice  )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( itemId )	-- 物品ID
	sender:writeInt( shoptype )	-- 商城类型(8:获取促销价格)
	SendProtocol(sender,false) --true:showLoading
end

--@brief	购买物品
function ProtocolProcessorWndPurchase:send_TRATE_BuyItems (count, itemId, itemPriceId )
	WZLog("send_TRATE_BuyItems ")
	local sender = Protocol:getSender( Protocol.MAIN_TRATE, Protocol.TRATE_BuyItems  )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( count )	-- 物品类型数量
	sender:writeInts( itemId )	-- 物品id
	sender:writeInts( itemPriceId )	-- 物品价格id
	SendProtocol(sender,false) --true:showLoading
	WZLog("send_TRATE_BuyItems 2")
end

--@brief	购买物品
function ProtocolProcessorWndPurchase:send_TRATE_BuyPromotItems (count, itemId, itemPriceId )
	WZLog("send_TRATE_BuyPromotItems ")
	local sender = Protocol:getSender( Protocol.MAIN_TRATE, Protocol.TRATE_BuyPromotItems  )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( count )	-- 物品类型数量
	sender:writeInts( itemId )	-- 物品id
	sender:writeInts( itemPriceId )	-- 物品价格id
	SendProtocol(sender,false) --true:showLoading
	WZLog("send_TRATE_BuyPromotItems2 ")
end

--@brief	获取购买限量物品价格
function ProtocolProcessorWndPurchase:send_TRATE_GetLimitedItemPrice(itemId )
	WZLog("send_TRATE_GetLimitedItemPrice")
	local sender = Protocol:getSender( Protocol.MAIN_TRATE, Protocol.TRATE_GetLimitedItemPrice )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( itemId )	-- 物品ID
	SendProtocol(sender,false) --true:showLoading
end

--@brief	购买限量物品
function ProtocolProcessorWndPurchase:send_TRATE_BuyLimitedItem(itemId )
	WZLog("send_TRATE_BuyLimitedItem")
	local sender = Protocol:getSender( Protocol.MAIN_TRATE, Protocol.TRATE_BuyLimitedItem )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( itemId )	-- 物品ID（限量物品）
	SendProtocol(sender,false) --true:showLoading
end



-------------------------------------服务器到客户端协议回调方法模块--------------------------------------
 
--@brief	返回物品价格表
function ProtocolProcessorWndPurchase:parse_TRATE_GetItemPriceOk(priceCount, priceIndex, shopItemId, days, count, costType, costUseTickets, costUseGold, costUseBadge, costUseTicketsPrev, costUseGoldPrev, costUseBadgePrev)
	-- priceCount : 价格数(类型)
	-- priceIndex : 价格序号
	-- shopItemId : 对应的商品id
	-- days : 可用的天数
	-- count : 可用的数量(-1不限次数）
	-- costType : 0：用点劵 1:用金币 3:徽章 2：两种都用 -1：免费
	-- costUseTickets : 需要花费的点劵
	-- costUseGold : 需要花费的金币
	-- costUseBadge : 需花费的勋章数
	-- costUseTicketsPrev : 需要花费的点劵（打折前）
	-- costUseGoldPrev : 需要花费的金币（打折前）
	-- costUseBadgePrev : 需花费的勋章数（打折前）
end

--@brief	购买物品结果
function ProtocolProcessorWndPurchase:parse_TRATE_BuyResult (buyResult, content, costTicks, costGold, costMedal, itemId, lastTime, limitLeave, lastTimeMark)
	-- buyResult : 购买成功还是失败
	-- content : 结果内容
	-- costTicks : 花费掉多少点券
	-- costGold : 花费掉多少金币
	-- costMedal : 花费掉多少勋章
	-- itemId : 商品ID
	-- lastTime : 剩余天数（字符串）
	-- limitLeave : 剩余可以购买数量
	-- lastTimeMark : 剩余天数（-1表示不按天数计算或无限期，10期添加）
	WZLog("ProtocolProcessorWndPurchase:parse_TRATE_BuyResult ")
	if WndPurchase ~= nil and WndPurchase.m_root ~= nil then
		WndPurchase:BuyResult(buyResult, content, costTicks, costGold, costMedal, itemId, lastTime, limitLeave, lastTimeMark)
	elseif WndBuy ~= nil and WndBuy.m_root ~= nil then 
		WndBuy:BuyResult(buyResult, content, costTicks, costGold, costMedal, itemId, lastTime, limitLeave, lastTimeMark)
	end
	if SceneWeddingChurch ~= nil and SceneWeddingChurch.m_root ~= nil then 
		SceneWeddingChurch:BuyResult(buyResult, content, costTicks, costGold, costMedal, itemId, lastTime, limitLeave, lastTimeMark)
	end 
	
end

--@brief	购买物品结果
function ProtocolProcessorWndPurchase:parse_TRATE_BuyPromotResult(buyResult, content, costTicks, costGold, costMedal, itemId, lastTime, lastTimeMark)
	-- buyResult : 购买成功还是失败
	-- content : 结果内容
	-- costTicks : 花费掉多少点券
	-- costGold : 花费掉多少金币
	-- costMedal : 花费掉多少勋章
	-- itemId : 商品ID
	-- lastTime : 剩余天数（字符串）
	-- lastTimeMark : 剩余天数（-1表示不按天数计算或无限期，10期添加）
	WZLog("ProtocolProcessorWndPurchase:parse_TRATE_BuyPromotResult")
	WndPurchase:BuyResult(buyResult, content, costTicks, costGold, costMedal, itemId, lastTime, 0, lastTimeMark)
end

--@brief	获取购买限量物品价格
function ProtocolProcessorWndPurchase:parse_TRATE_GetLimitedItemPriceOk(itemId, lastNum, useDiam, itemCurNum, addItemNum)
	-- itemId : 物品ID
	-- lastNum : 购剩余次数>0时候才可以购买
	-- useDiam : 需要消耗的钻石数
	-- itemCurNum : 限量物品当前的个数
	-- addItemNum : 增加的限量物品的个数
	WZLog("ProtocolProcessorWndPurchase:parse_TRATE_GetLimitedItemPriceOk")
--	WndBuyActivity:getPriceResult(itemId, lastNum, useDiam, itemCurNum, addItemNum)
end

--@brief	购买限量物品
function ProtocolProcessorWndPurchase:parse_TRATE_BuyLimitedItemOk(itemId, itemCurNum, addItemNum)
	-- itemId : 物品ID
	-- itemCurNum : 限量物品当前的个数
	-- addItemNum : 增加的限量物品的个数
	WZLog("ProtocolProcessorWndPurchase:parse_TRATE_BuyLimitedItemOk")
end

-------------------------------------协议错误处理方法模块--------------------------------------

--@brief	获取商品价格错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndPurchase:send_TRATE_GetItemPrice_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndPurchase:send_TRATE_GetItemPrice _ErrorProcess",sMessage)
	WndPurchase:getErrorProcess(sMessage)
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TRATE, Protocol.TRATE_GetItemPrice , nFlag, sMessage)
end

--@brief	购买物品错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndPurchase:send_TRATE_BuyItems_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndPurchase:send_TRATE_BuyItems _ErrorProcess"..sMessage)
	WndPurchase:getErrorProcess(sMessage)
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TRATE, Protocol.TRATE_BuyItems , nFlag, sMessage)
end

--@brief	购买物品错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndPurchase:send_TRATE_BuyPromotItems_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndPurchase:send_TRATE_BuyPromotItems _ErrorProcess"..sMessage)
	WndPurchase:getErrorProcess(sMessage)
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TRATE, Protocol.TRATE_BuyPromotItems , nFlag, sMessage)
end

--@brief	获取购买限量物品价格错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndPurchase:send_TRATE_GetLimitedItemPrice_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndPurchase:send_TRATE_GetLimitedItemPrice_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TRATE, Protocol.TRATE_GetLimitedItemPrice, nflag, sMessage)
end

--@brief	购买限量物品错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndPurchase:send_TRATE_BuyLimitedItem_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndPurchase:send_TRATE_BuyLimitedItem_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TRATE, Protocol.TRATE_BuyLimitedItem, nflag, sMessage)
end