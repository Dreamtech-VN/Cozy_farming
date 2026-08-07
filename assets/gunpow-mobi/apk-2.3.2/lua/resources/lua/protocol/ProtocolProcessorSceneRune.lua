--ProtocolProcessorSceneRune.lua
--@brief	符文系统相关协议
--@date  	2017-3-24
--@author 	qixiang


ProtocolProcessorSceneRune = ProtocolProcessorBase:new()

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorSceneRune:regAll()
	--@brief	获取符文信息（RUNE_GetRuneInfo = 1）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_RUNE, Protocol.RUNE_GetRuneInfo, "ProtocolProcessorSceneRune:send_RUNE_GetRuneInfo_ErrorProcess", "is" )
    --@brief	获取符文信息（RUNE_GetRuneInfoOk = 2）
    self:regProtocolCallbackFunction( Protocol.MAIN_RUNE, Protocol.RUNE_GetRuneInfoOk, "ProtocolProcessorSceneRune:parse_RUNE_GetRuneInfoOk", "viviviiviviii")
    
    --@brief	开启槽位（RUNE_OpenPlace = 3）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_RUNE, Protocol.RUNE_OpenPlace, "ProtocolProcessorSceneRune:send_RUNE_OpenPlace_ErrorProcess", "is" )
    
    --@brief	开启槽位（RUNE_OpenPlaceStatus = 4）
    self:regProtocolCallbackFunction( Protocol.MAIN_RUNE, Protocol.RUNE_OpenPlaceStatus, "ProtocolProcessorSceneRune:parse_RUNE_OpenPlaceStatus", "ti")
    
    --@brief	更新符文操作（RUNE_UpdateRune = 5）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_RUNE, Protocol.RUNE_UpdateRune, "ProtocolProcessorSceneRune:send_RUNE_UpdateRune_ErrorProcess", "is" )
    
    --@brief	更新符文操作（RUNE_UpdateRuneStatus = 6）
    self:regProtocolCallbackFunction( Protocol.MAIN_RUNE, Protocol.RUNE_UpdateRuneStatus, "ProtocolProcessorSceneRune:parse_RUNE_UpdateRuneStatus", "tii")
    
    --@brief	获取符文列表（RUNE_GetRuneList = 7）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_RUNE, Protocol.RUNE_GetRuneList, "ProtocolProcessorSceneRune:send_RUNE_GetRuneList_ErrorProcess", "is" )
    
    --@brief	获取符文列表（RUNE_GetRuneListOk = 8）
    self:regProtocolCallbackFunction( Protocol.MAIN_RUNE, Protocol.RUNE_GetRuneListOk, "ProtocolProcessorSceneRune:parse_RUNE_GetRuneListOk", "vivivi")
    

	--@brief	出售符文（RUNE_SellRune = 9）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_RUNE, Protocol.RUNE_SellRune, "ProtocolProcessorSceneRune:send_RUNE_SellRune_ErrorProcess", "is" )

	--@brief	出售符文（RUNE_SellRuneStatus = 10）
	self:regProtocolCallbackFunction( Protocol.MAIN_RUNE, Protocol.RUNE_SellRuneStatus, "ProtocolProcessorSceneRune:parse_RUNE_SellRuneStatus", "t")
	--@brief	符文共振（RUNE_RuneResonateOk = 21）
	self:regProtocolCallbackFunction( Protocol.MAIN_RUNE, Protocol.RUNE_RuneResonateOk, "ProtocolProcessorSceneRune:parse_RUNE_RuneResonateOk", "ii")
end


--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorSceneRune:unregAll()
	self:clearReg()
end

--------------------------------------------------send------------------------------------------------------------------

--@brief	获取符文信息（RUNE_GetRuneInfo = 1）
function ProtocolProcessorSceneRune:send_RUNE_GetRuneInfo()
	WZLog("send_RUNE_GetRuneInfo")
	local sender = Protocol:getSender(Protocol.MAIN_RUNE, Protocol.RUNE_GetRuneInfo )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	开启槽位（RUNE_OpenPlace = 3）
function ProtocolProcessorSceneRune:send_RUNE_OpenPlace(placeId )
	WZLog("send_RUNE_OpenPlace")
	local sender = Protocol:getSender( Protocol.MAIN_RUNE, Protocol.RUNE_OpenPlace )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( placeId )	-- 要开启的槽位ID
	SendProtocol(sender,false) --true:showLoading
end

--@brief	更新符文操作（RUNE_UpdateRune = 5）
function ProtocolProcessorSceneRune:send_RUNE_UpdateRune(placeId, itemId )
	WZLog("send_RUNE_UpdateRune")
	local sender = Protocol:getSender( Protocol.MAIN_RUNE, Protocol.RUNE_UpdateRune )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( placeId )	-- 更新的槽位ID（-1表示卸载所有符文）
	sender:writeInt( itemId )	-- 要装载的符文ID(0表示卸载)
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取符文列表（RUNE_GetRuneList = 7）
function ProtocolProcessorSceneRune:send_RUNE_GetRuneList( )
	WZLog("send_RUNE_GetRuneList")
	local sender = Protocol:getSender( Protocol.MAIN_RUNE, Protocol.RUNE_GetRuneList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end


--@brief	出售符文（RUNE_SellRune = 9）
function ProtocolProcessorSceneRune:send_RUNE_SellRune(itemIds, sellNums )
	WZLog("send_RUNE_SellRune")
	local sender = Protocol:getSender( Protocol.MAIN_RUNE, Protocol.RUNE_SellRune )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInts( itemIds )	-- 要出售的符文ID
	sender:writeInts( sellNums )	-- 要出售的符文数量
	SendProtocol(sender,false) --true:showLoading
end


-------------------------------------------------receive ok-------------------------------------------------------------
--@brief	获取符文信息（RUNE_GetRuneInfoOk = 2）
function ProtocolProcessorSceneRune:parse_RUNE_GetRuneInfoOk(placeIds, placeItemId, rpIds, runeLevel, itemIds, itemNums, resonateBuffState, resonateState)
	-- placeIds : 槽位id
	-- placeItemId : 槽位装备的符文ID（0未装备）
	-- rpIds : 激活的圣痕id
	-- runeLevel : 符文总等级
	-- itemIds : 拥有的符文ID
	-- itemNums : 拥有的符文数量
	WZLog("ProtocolProcessorSceneRune:parse_RUNE_GetRuneInfoOk",Serialize(rpIds))
	placeIds = VectorToTable(placeIds)
	placeItemId = VectorToTable(placeItemId)
	SceneRune:setRuneInfo(placeIds,placeItemId,VectorToTable(rpIds),runeLevel,VectorToTable(itemIds),VectorToTable(itemNums), resonateBuffState, resonateState)

	CacheCenter:parse_RUNE_GetRuneInfoOk(placeIds, placeItemId,VectorToTable(itemIds))
end

--@brief	开启槽位（RUNE_OpenPlaceStatus = 4）
function ProtocolProcessorSceneRune:parse_RUNE_OpenPlaceStatus(status, placeId)
	-- status : 槽位开启状态（0开启成功，1货币不足）
	-- placeId : 槽位id
	WZLog("ProtocolProcessorSceneRune:parse_RUNE_OpenPlaceStatus ",status, status == 0)
	SceneRune:openSlotCallback(status, placeId)

	CacheCenter:parse_RUNE_OpenPlaceStatus(status, placeId)
end

--@brief	更新符文操作（RUNE_UpdateRuneStatus = 6）
function ProtocolProcessorSceneRune:parse_RUNE_UpdateRuneStatus(status,placeId,itemId)
	-- status : 符文更新状态（0成功，其他更新失败）
	-- placeId ：更新的槽位ID（-1表示卸载所有符文）
	-- itemId : 要装载的符文ID(0表示卸载)
	WZLog("ProtocolProcessorSceneRune:parse_RUNE_UpdateRuneStatus ",status,placeId,itemId)
	SceneRune:updateSlotRuneStatus(status,placeId,itemId)

	CacheCenter:parse_RUNE_UpdateRuneStatus(status,placeId,itemId)
end

--@brief	获取符文列表（RUNE_GetRuneListOk = 8）
function ProtocolProcessorSceneRune:parse_RUNE_GetRuneListOk(itemIds, itemNums, isUseds)
	-- itemIds : 拥有的符文ID
	-- itemNums : 拥有的符文数量
	-- isUseds : 符文装载的个数
	WZLog("ProtocolProcessorSceneRune:parse_RUNE_GetRuneListOk")
	WndRuneBook:getRuneList(VectorToTable(itemIds),VectorToTable(itemNums),VectorToTable(isUseds))
end

--@brief	出售符文（RUNE_SellRuneStatus = 10）
function ProtocolProcessorSceneRune:parse_RUNE_SellRuneStatus(status)
	-- status : 符文出售状态（0成功，其他出售失败）
	WZLog("ProtocolProcessorSceneRune:parse_RUNE_SellRuneStatus")
	if WndSellRune.m_root then
		WndSellRune:onSaleStatus(status)
	else
		WndSingleSellRune:onSaleStatus(status)
	end
end
--@brief	符文共振（RUNE_RuneResonate = 20）
function ProtocolProcessorSceneRune:send_RUNE_RuneResonate(costType)
	WZLog("send_RUNE_RuneResonate")
	local sender = Protocol:getSender( Protocol.MAIN_RUNE, Protocol.RUNE_RuneResonate )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeByte(costType)	-- 消耗类型：1-符文碎片，2-礼钻
	SendProtocol(sender,false) --true:showLoading
end
--@brief	符文共振（RUNE_RuneResonateOk = 21）
function ProtocolProcessorSceneRune:parse_RUNE_RuneResonateOk(result, buffTime)
	-- result : 0、成功,1、正在共振中
	-- buffTime : 如果大于0表示当前正在共振buff所剩余的时间
	GlobalGame:getGameEventDispathcer():Dispatch(bottomMeneEvent.WndBottomMeneEvent_GetResonateState, result, buffTime)
end

-------------------------------------------------receive error----------------------------------------------------------

--@brief	获取符文信息（RUNE_GetRuneInfo = 1）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneRune:send_RUNE_GetRuneInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneRune:send_RUNE_GetRuneInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_RUNE, Protocol.RUNE_GetRuneInfo, nflag, sMessage)
end

--@brief	开启槽位（RUNE_OpenPlace = 3）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneRune:send_RUNE_OpenPlace_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneRune:send_RUNE_OpenPlace_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_RUNE, Protocol.RUNE_OpenPlace, nflag, sMessage)
end

--@brief	更新符文操作（RUNE_UpdateRune = 5）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneRune:send_RUNE_UpdateRune_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneRune:send_RUNE_UpdateRune_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_RUNE, Protocol.RUNE_UpdateRune, nflag, sMessage)
end

--@brief	获取符文列表（RUNE_GetRuneList = 7）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneRune:send_RUNE_GetRuneList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneRune:send_RUNE_GetRuneList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_RUNE, Protocol.RUNE_GetRuneList, nflag, sMessage)
end

--@brief	出售符文（RUNE_SellRune = 9）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneRune:send_RUNE_SellRune_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneRune:send_RUNE_SellRune_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_RUNE, Protocol.RUNE_SellRune, nflag, sMessage)
end
