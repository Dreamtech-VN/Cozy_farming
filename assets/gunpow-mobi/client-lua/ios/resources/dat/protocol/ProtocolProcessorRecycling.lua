--ProtocolProcessorRecycling.lua
--@brief	物品回收相关协议
--@date  	2013/12/25
--@author 	zsq
--@note 	物品回收相关协议


ProtocolProcessorRecycling = ProtocolProcessorBase:new()


--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorRecycling:regAll()
	--服务器到客户端协议注册
	--@brief	回收物品返回（PLAYERITEM_RecycleItemOk = 2）
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_RecycleItemOk, "ProtocolProcessorRecycling:parse_PLAYERITEM_RecycleItemOk", "vivi")
	--@brief	使用物品返回（PLAYERITEM_UseItemOk = 5）
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_UseItemOk, "ProtocolProcessorRecycling:parse_PLAYERITEM_UseItemOk", "t")
	--@brief	使用物品返回（PLAYERITEM_OpenGiftOK = 7）
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_OpenGiftOK, "ProtocolProcessorRecycling:parse_PLAYERITEM_OpenGiftOK", "vivii")
	--@brief	获取玩家溢出经验信息（PLAYERITEM_GetOverflowedExpExchangeOk = 9）
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_GetOverflowedExpExchangeOk, "ProtocolProcessorRecycling:parse_PLAYERITEM_GetOverflowedExpExchangeOk", "tiiiiii")
	--@brief	溢出经验兑换（PLAYERITEM_ExchangeExpOk = 11）
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_ExchangeExpOk, "ProtocolProcessorRecycling:parse_PLAYERITEM_ExchangeExpOk", "i")
	--@brief	体验装备过期（PLAYERITEM_ItemTimeOver = 12）
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_ItemTimeOver, "ProtocolProcessorRecycling:parse_PLAYERITEM_ItemTimeOver", "i")
	--@brief	获取玩家套装（PLAYERITEM_GetDressSuitOk = 14）
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_GetDressSuitOk, "ProtocolProcessorRecycling:parse_PLAYERITEM_GetDressSuitOk", "vivsvb")
	--@brief	修改套装名（PLAYERITEM_ModifyDressSuitNameOk = 16）
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_ModifyDressSuitNameOk, "ProtocolProcessorRecycling:parse_PLAYERITEM_ModifyDressSuitNameOk", "ist")
	--@brief	增加套装数（PLAYERITEM_IncreaseDressSuitNumOk = 18）
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_IncreaseDressSuitNumOk, "ProtocolProcessorRecycling:parse_PLAYERITEM_IncreaseDressSuitNumOk", "is")
	--@brief	切换自定义套装（PLAYERITEM_SwitchDressSuitOk = 20）
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_SwitchDressSuitOk, "ProtocolProcessorRecycling:parse_PLAYERITEM_SwitchDressSuitOk", "")


	--协议错误处理
	--@brief	回收物品（PLAYERITEM_RecycleItem = 1）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_RecycleItem, "ProtocolProcessorRecycling:send_PLAYERITEM_RecycleItem_ErrorProcess", "is" )
	--@brief	换装（PLAYERITEM_ChangeEquipment= 3）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_ChangeEquipment, "ProtocolProcessorRecycling:send_PLAYERITEM_ChangeEquipment_ErrorProcess", "is" )
	--@brief	使用物品（PLAYERITEM_UseItem = 4）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_UseItem, "ProtocolProcessorRecycling:send_PLAYERITEM_UseItem_ErrorProcess", "is" )
	--@brief	使用物品（PLAYERITEM_OpenGift = 6）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_OpenGift, "ProtocolProcessorRecycling:send_PLAYERITEM_OpenGift_ErrorProcess", "is" )
	--@brief	 获取玩家溢出经验信息（PLAYERITEM_GetOverflowedExpExchange = 8）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_GetOverflowedExpExchange, "ProtocolProcessorRecycling:send_PLAYERITEM_GetOverflowedExpExchange_ErrorProcess", "is" )
	--@brief	溢出经验兑换（PLAYERITEM_ExchangeExp = 10）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_ExchangeExp, "ProtocolProcessorRecycling:send_PLAYERITEM_ExchangeExp_ErrorProcess", "is" )
	--@brief	获取玩家套装（PLAYERITEM_GetDressSuit = 13）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_GetDressSuit, "ProtocolProcessorRecycling:send_PLAYERITEM_GetDressSuit_ErrorProcess", "is" )
	--@brief	修改套装名（PLAYERITEM_ModifyDressSuitName = 15）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_ModifyDressSuitName, "ProtocolProcessorRecycling:send_PLAYERITEM_ModifyDressSuitName_ErrorProcess", "is" )
	--@brief	增加套装数（PLAYERITEM_IncreaseDressSuitNum = 17）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_IncreaseDressSuitNum, "ProtocolProcessorRecycling:send_PLAYERITEM_IncreaseDressSuitNum_ErrorProcess", "is" )
	--@brief	切换自定义套装（PLAYERITEM_SwitchDressSuit = 19）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_SwitchDressSuit, "ProtocolProcessorRecycling:send_PLAYERITEM_SwitchDressSuit_ErrorProcess", "is" )

end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorRecycling:unregAll()
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块Begin--------------------------------------
--@brief	回收物品（PLAYERITEM_RecycleItem = 1）
function ProtocolProcessorRecycling:send_PLAYERITEM_RecycleItem(itemId, itemNum )
	WZLog("send_PLAYERITEM_RecycleItem")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_RecycleItem )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInts( itemId )	-- 回收物品ID
	sender:writeInts( itemNum )	-- 物品数量
	SendProtocol(sender,false) --true:showLoading
end

--@brief	换装（PLAYERITEM_ChangeEquipment= 3）
function ProtocolProcessorRecycling:send_PLAYERITEM_ChangeEquipment(playerItemId )
	WZLog("send_PLAYERITEM_ChangeEquipment")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_ChangeEquipment )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInts( playerItemId )	-- 新玩家物品ID
	SendProtocol(sender,false) --true:showLoading

	WndPlayer.m_bChangeDress = true

    local isEndTeach, step = TeachGroup1:isTeachFinish(8)
    if isEndTeach ~= true and step > 0 then
        TeachGroup1:endTeachStep({8,5})
        WindowManager:removeTeachShelterLayer()
        WindowManager:addTeachShelterLayer( 999999 )
    end

end

--@brief	使用物品（PLAYERITEM_UseItem = 4）
function ProtocolProcessorRecycling:send_PLAYERITEM_UseItem(playerItemId, itemNum, content )
	WZLog("send_PLAYERITEM_UseItem")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_UseItem )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerItemId )	-- 玩家物品ID
	sender:writeInt( itemNum )	-- 物品数量
	sender:writeString( content )	-- 内容
	SendProtocol(sender,false) --true:showLoading
end

--@brief	使用物品（PLAYERITEM_OpenGift = 6）
function ProtocolProcessorRecycling:send_PLAYERITEM_OpenGift(playerItemId, itemNum )
	WZLog("send_PLAYERITEM_OpenGift")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_OpenGift )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerItemId )	-- 玩家物品ID
	sender:writeInt( itemNum )	-- 物品数量
	SendProtocol(sender,false) --true:showLoading
end

--@brief	 获取玩家溢出经验信息（PLAYERITEM_GetOverflowedExpExchange = 8）
function ProtocolProcessorRecycling:send_PLAYERITEM_GetOverflowedExpExchange( )
	WZLog("send_PLAYERITEM_GetOverflowedExpExchange")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_GetOverflowedExpExchange )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	溢出经验兑换（PLAYERITEM_ExchangeExp = 10）
function ProtocolProcessorRecycling:send_PLAYERITEM_ExchangeExp(exchangeType )
	WZLog("send_PLAYERITEM_ExchangeExp")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_ExchangeExp )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeByte( exchangeType )	-- 兑换类型,0:单次;1:自动
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取玩家套装（PLAYERITEM_GetDressSuit = 13）
function ProtocolProcessorRecycling:send_PLAYERITEM_GetDressSuit( )
	WZLog("send_PLAYERITEM_GetDressSuit")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_GetDressSuit )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	修改套装名（PLAYERITEM_ModifyDressSuitName = 15）
function ProtocolProcessorRecycling:send_PLAYERITEM_ModifyDressSuitName(suitId, name )
	WZLog("send_PLAYERITEM_ModifyDressSuitName")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_ModifyDressSuitName )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( suitId )	-- 套装ID
	sender:writeString( name )	-- 套装名
	SendProtocol(sender,false) --true:showLoading
end

--@brief	增加套装数（PLAYERITEM_IncreaseDressSuitNum = 17）
function ProtocolProcessorRecycling:send_PLAYERITEM_IncreaseDressSuitNum( )
	WZLog("send_PLAYERITEM_IncreaseDressSuitNum")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_IncreaseDressSuitNum )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	切换自定义套装（PLAYERITEM_SwitchDressSuit = 19）
function ProtocolProcessorRecycling:send_PLAYERITEM_SwitchDressSuit(suitId )
	WZLog("send_PLAYERITEM_SwitchDressSuit")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_SwitchDressSuit )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( suitId )	-- 套装ID
	SendProtocol(sender,false) --true:showLoading
end

---------------------------客户端到服务器协议发送方法模块End------------------------------


--------------------------服务器到客户端协议回调方法模块Begin-------------------------------
--@brief	回收物品返回（PLAYERITEM_RecycleItemOk = 2）
function ProtocolProcessorRecycling:parse_PLAYERITEM_RecycleItemOk(items,nums)
	WZLog("ProtocolProcessorRecycling:parse_PLAYERITEM_RecycleItemOk")
	if type(VectorToTable(items)) == "table" and #VectorToTable(items) > 0 then
		WndRewardShow:showById(VectorToTable(items),VectorToTable(nums))
	end
	if WndSellList then
		WndSellList:recycleSucc()
	end
end

--@brief	使用物品返回（PLAYERITEM_UseItemOk = 5）
function ProtocolProcessorRecycling:parse_PLAYERITEM_UseItemOk(result)
	-- result : 1、成功，2、重名，3、非法字符，4、名字不能为空，5、名字太长, 6、名字太短,7、纯数字
	WZLog("ProtocolProcessorRecycling:parse_PLAYERITEM_UseItemOk")
	if WndCheckOther.m_root ~= nil then
		WndCheckOther:displayResult(result)
		return
	end

	if WndBag then
		WndBag:displayResult(result)
	end

	WndChangeSex:changeSuccess()
end

--@brief	使用物品返回（PLAYERITEM_OpenGiftOK = 7）
function ProtocolProcessorRecycling:parse_PLAYERITEM_OpenGiftOK(itemId, count, fashionCount)
	-- itemId : 物品id
	-- count : 数量
	WZLog("ProtocolProcessorRecycling:parse_PLAYERITEM_OpenGiftOK", Serialize(VectorToTable(itemId)), Serialize(VectorToTable(count)))
	WndRewardShow:showById(VectorToTable(itemId),VectorToTable(count), nil, nil, nil, fashionCount)
end


--@brief	获取玩家溢出经验信息（PLAYERITEM_GetOverflowedExpExchangeOk = 9）
function ProtocolProcessorRecycling:parse_PLAYERITEM_GetOverflowedExpExchangeOk(status, overflowExp, exchangeTimes, costExp, gainReward, autoExchangeCostNum, autoExchangeGainNum)
	-- status : 状态: 0)没有溢出,1)溢出
	-- overflowExp : 溢出的经验
	-- exchangeTimes : 本日兑换的次数
	-- costExp : 兑换需要扣除的经验 
	-- gainReward : 本次兑换可以获取的奖励
	-- autoExchangeCostNum : 自动兑换需要扣除的数目
	-- autoExchangeGainNum : 自动兑换可以获取的数目
	WZLog("ProtocolProcessorRecycling:parse_PLAYERITEM_GetOverflowedExpExchangeOk")

	WndExchangeExp:setData(status, overflowExp, exchangeTimes, costExp, gainReward, autoExchangeCostNum, autoExchangeGainNum)
end

--@brief	溢出经验兑换（PLAYERITEM_ExchangeExpOk = 11）
function ProtocolProcessorRecycling:parse_PLAYERITEM_ExchangeExpOk(gainNum)
	-- gainNum : 兑换获取的数目
	WZLog("ProtocolProcessorRecycling:parse_PLAYERITEM_ExchangeExpOk")

	WndExchangeExp:exchangeSuccess(gainNum)
end

--@brief	体验装备过期（PLAYERITEM_ItemTimeOver = 12）
function ProtocolProcessorRecycling:parse_PLAYERITEM_ItemTimeOver(itemId)
	-- itemId : 物品id
	WZLog("ProtocolProcessorRecycling:parse_PLAYERITEM_ItemTimeOver")
	if (not WindowManager:getTeachShelterLayer()) and WndTeachTalk.m_root == nil then
		local tData = GDatatab_item["id_"..itemId]
		local text = string.format(LocalStrings.LIMITEQUIP1, tData.name)
		MsgBoxManager:showConfirmBox(text)
	end

	if itemId == 107024 then
		local isShowFirstRechange = TeachGroup1:isFirstRechangePushFinish("2_2")
		WZLog("ProtocolProcessorRecycling:parse_PLAYERITEM_ItemTimeOver two", isShowFirstRechange)
		TeachGroup1:setFirstRechangePushFinish("2_1")
        if isShowFirstRechange == false and GlobalGame.g_bIsGetFirstRecharge and SceneBattle.m_bIsCreate == nil and SceneLoginMgr.m_bIsCreate == nil and 
        	SceneBattleLoading.m_bIsCreate == nil and (not WindowManager:getTeachShelterLayer()) and WndTeachTalk.m_root == nil then
            WZLog("ProtocolProcessorRecycling:parse_PLAYERITEM_ItemTimeOver three")
            TeachGroup1:setFirstRechangePushFinish("2_2")
            local wnd = CellRechargePanelActivity:createElement()
            CellRechargePanelActivity.m_bIsText = true
            WindowManager:addWindow(wnd, CellRechargePanelActivity, true)
        end
	end

end

--@brief	获取玩家套装（PLAYERITEM_GetDressSuitOk = 14）
function ProtocolProcessorRecycling:parse_PLAYERITEM_GetDressSuitOk(suitId, name, isUse)
	-- suitId : 套装ID
	-- name : 套装名称
	-- isUse : 是否使用中
	WZLog("ProtocolProcessorRecycling:parse_PLAYERITEM_GetDressSuitOk")

	CacheCenter:setDressSuitData(VectorToTable(suitId), VectorToTable(name), VectorToTable(isUse))

	CacheCenter:updateDressSuitData()
end

--@brief	修改套装名（PLAYERITEM_ModifyDressSuitNameOk = 16）
function ProtocolProcessorRecycling:parse_PLAYERITEM_ModifyDressSuitNameOk(suitId, name, result)
	-- suitId : 套装ID
	-- name : 套装名
	-- result : result
	WZLog("ProtocolProcessorRecycling:parse_PLAYERITEM_ModifyDressSuitNameOk")

	if result == 1 then
		CacheCenter:dressSuitRename(suitId, name)
	end
	if Wndwardrobe.m_root and Wndwardrobe.m_tCellDressSuit then
		Wndwardrobe.m_tCellDressSuit:renameResult(result, suitId, name)
	end
	if WndPhantom.m_root and WndPhantom.m_tCellDressSuit then
		WndPhantom.m_tCellDressSuit:renameResult(result, suitId, name)
	end

	CacheCenter:updateDressSuitData()
end

--@brief	增加套装数（PLAYERITEM_IncreaseDressSuitNumOk = 18）
function ProtocolProcessorRecycling:parse_PLAYERITEM_IncreaseDressSuitNumOk(suitId, name)
	-- suitId : 套装ID
	-- name : 套装名
	WZLog("ProtocolProcessorRecycling:parse_PLAYERITEM_IncreaseDressSuitNumOk")

	CacheCenter:addNewDressSuit(suitId, name)
	CacheCenter:updateDressSuitData()
end

--@brief	切换自定义套装（PLAYERITEM_SwitchDressSuitOk = 20）
function ProtocolProcessorRecycling:parse_PLAYERITEM_SwitchDressSuitOk()
	WZLog("ProtocolProcessorRecycling:parse_PLAYERITEM_SwitchDressSuitOk")

	CacheCenter:updateDressSuitData(1)
end
-----------------------------服务器到客户端协议回调方法模块End--------------------------------


------------------------------协议错误处理方法模块Begin-------------------------------
--@brief	回收物品（PLAYERITEM_RecycleItem = 1）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorRecycling:send_PLAYERITEM_RecycleItem_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorRecycling:send_PLAYERITEM_RecycleItem_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_RecycleItem, nflag, sMessage)
end
-------------------------------------协议错误处理方法模块End--------------------------------------

--@brief	换装（PLAYERITEM_ChangeEquipment= 3）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorRecycling:send_PLAYERITEM_ChangeEquipment_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorRecycling:send_PLAYERITEM_ChangeEquipment_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_ChangeEquipment, nflag, sMessage)
end

--@brief	使用物品（PLAYERITEM_UseItem = 4）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorRecycling:send_PLAYERITEM_UseItem_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorRecycling:send_PLAYERITEM_UseItem_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_UseItem, nflag, sMessage)
end

--@brief	使用物品（PLAYERITEM_OpenGift = 6）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorRecycling:send_PLAYERITEM_OpenGift_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorRecycling:send_PLAYERITEM_OpenGift_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_OpenGift, nflag, sMessage)
end

--@brief	 获取玩家溢出经验信息（PLAYERITEM_GetOverflowedExpExchange = 8）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorRecycling:send_PLAYERITEM_GetOverflowedExpExchange_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorRecycling:send_PLAYERITEM_GetOverflowedExpExchange_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_GetOverflowedExpExchange, nflag, sMessage)
end

--@brief	溢出经验兑换（PLAYERITEM_ExchangeExp = 10）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorRecycling:send_PLAYERITEM_ExchangeExp_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorRecycling:send_PLAYERITEM_ExchangeExp_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_ExchangeExp, nflag, sMessage)
end

--@brief	获取玩家套装（PLAYERITEM_GetDressSuit = 13）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorRecycling:send_PLAYERITEM_GetDressSuit_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorRecycling:send_PLAYERITEM_GetDressSuit_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_GetDressSuit, nflag, sMessage)
end

--@brief	修改套装名（PLAYERITEM_ModifyDressSuitName = 15）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorRecycling:send_PLAYERITEM_ModifyDressSuitName_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorRecycling:send_PLAYERITEM_ModifyDressSuitName_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_ModifyDressSuitName, nflag, sMessage)
end

--@brief	增加套装数（PLAYERITEM_IncreaseDressSuitNum = 17）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorRecycling:send_PLAYERITEM_IncreaseDressSuitNum_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorRecycling:send_PLAYERITEM_IncreaseDressSuitNum_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_IncreaseDressSuitNum, nflag, sMessage)
end

--@brief	切换自定义套装（PLAYERITEM_SwitchDressSuit = 19）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorRecycling:send_PLAYERITEM_SwitchDressSuit_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorRecycling:send_PLAYERITEM_SwitchDressSuit_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_SwitchDressSuit, nflag, sMessage)
end
