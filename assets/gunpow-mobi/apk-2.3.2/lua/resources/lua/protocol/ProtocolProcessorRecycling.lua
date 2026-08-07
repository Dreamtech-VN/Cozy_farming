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
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_RecycleItemOk, "ProtocolProcessorRecycling:parse_PLAYERITEM_RecycleItemOk", "ivivi")
	--@brief	使用物品返回（PLAYERITEM_UseItemOk = 5）
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_UseItemOk, "ProtocolProcessorRecycling:parse_PLAYERITEM_UseItemOk", "ti")
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
	--@brief	获取元魂列表信息成功（PLAYERITEM_GetYuanSoulInfoOk = 22）
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_GetYuanSoulInfoOk, "ProtocolProcessorRecycling:parse_PLAYERITEM_GetYuanSoulInfoOk", "vivivivivivivivivivivivivi")
	--@brief	元魂操作成功（PLAYERITEM_CastSoulResult = 24）
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_CastSoulResult, "ProtocolProcessorRecycling:parse_PLAYERITEM_CastSoulResult", "iiiiivi")
	--@brief	获取玩家祈福套装（PLAYERITEM_GetSuitOk = 26）
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_GetSuitOk, "ProtocolProcessorRecycling:parse_PLAYERITEM_GetSuitOk", "ivivsvb")
	--@brief	修改祈福套装名（PLAYERITEM_ModifySuitNameOk = 28）
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_ModifySuitNameOk, "ProtocolProcessorRecycling:parse_PLAYERITEM_ModifySuitNameOk", "iist")
	--@brief	增加祈福套装数（PLAYERITEM_IncreaseSuitNumOk = 30）
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_IncreaseSuitNumOk, "ProtocolProcessorRecycling:parse_PLAYERITEM_IncreaseSuitNumOk", "iis")
	--@brief	切换自定义祈福套装（PLAYERITEM_SwitchSuitOk = 32）
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_SwitchSuitOk, "ProtocolProcessorRecycling:parse_PLAYERITEM_SwitchSuitOk", "i")
	--@brief	宠物装备所有方案（PLAYERITEM_PetEquipSchemeListOK = 42）
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_PetEquipSchemeListOK, "ProtocolProcessorRecycling:parse_PLAYERITEM_PetEquipSchemeListOK", "vtvsvb")
	--@brief	宠物装备使用方案（PLAYERITEM_PetEquipUseSchemeOK = 44）
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_PetEquipUseSchemeOK, "ProtocolProcessorRecycling:parse_PLAYERITEM_PetEquipUseSchemeOK", "tvivi")
	--@brief	宠物装备方案重命名（PLAYERITEM_PetEquipSchemeReNameOK = 46）
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_PetEquipSchemeReNameOK, "ProtocolProcessorRecycling:parse_PLAYERITEM_PetEquipSchemeReNameOK", "ist")
	--@brief	宠物装备增加方案（PLAYERITEM_PetEquipSchemeAddOK = 48）
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_PetEquipSchemeAddOK, "ProtocolProcessorRecycling:parse_PLAYERITEM_PetEquipSchemeAddOK", "ts")


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
	--@brief	获取元魂列表信息（PLAYERITEM_GetYuanSoulInfo = 21）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_GetYuanSoulInfo, "ProtocolProcessorRecycling:send_PLAYERITEM_GetYuanSoulInfo_ErrorProcess", "is" )
	--@brief	铸魂（PLAYERITEM_CastSoul = 23）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_CastSoul, "ProtocolProcessorRecycling:send_PLAYERITEM_CastSoul_ErrorProcess", "is" )
	--@brief	获取玩家祈福套装（PLAYERITEM_GetSuit = 25）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_GetSuit, "ProtocolProcessorRecycling:send_PLAYERITEM_GetSuit_ErrorProcess", "is" )
	--@brief	修改祈福套装名（PLAYERITEM_ModifySuitName = 27）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_ModifySuitName, "ProtocolProcessorRecycling:send_PLAYERITEM_ModifySuitName_ErrorProcess", "is" )
	--@brief	增加祈福套装数（PLAYERITEM_IncreaseSuitNum = 29）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_IncreaseSuitNum, "ProtocolProcessorRecycling:send_PLAYERITEM_IncreaseSuitNum_ErrorProcess", "is" )
	--@brief	切换自定义祈福套装（PLAYERITEM_SwitchSuit = 31）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_SwitchSuit, "ProtocolProcessorRecycling:send_PLAYERITEM_SwitchSuit_ErrorProcess", "is" )
	--@brief	宠物装备所有方案（PLAYERITEM_PetEquipSchemeList = 41）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_PetEquipSchemeList, "ProtocolProcessorRecycling:send_PLAYERITEM_PetEquipSchemeList_ErrorProcess", "is")
	--@brief	宠物装备使用方案（PLAYERITEM_PetEquipUseScheme = 43）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_PetEquipUseScheme, "ProtocolProcessorRecycling:send_PLAYERITEM_PetEquipUseScheme_ErrorProcess", "is")
	--@brief	宠物装备方案重命名（PLAYERITEM_PetEquipSchemeReName = 45）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_PetEquipSchemeReName, "ProtocolProcessorRecycling:send_PLAYERITEM_PetEquipSchemeReName_ErrorProcess", "is")
	--@brief	宠物装备增加方案（PLAYERITEM_PetEquipSchemeAdd = 47）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_PetEquipSchemeAdd, "ProtocolProcessorRecycling:send_PLAYERITEM_PetEquipSchemeAdd_ErrorProcess", "is")

end

function ProtocolProcessorRecycling:regAll1()
	--@brief	使用物品（PLAYERITEM_ExchangeItemOk = 34）
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_ExchangeItemOk, "ProtocolProcessorRecycling:parse_PLAYERITEM_ExchangeItemOk", "t")
end
--@brief	使用物品（PLAYERITEM_ExchangeItem = 33）
function ProtocolProcessorRecycling:send_PLAYERITEM_ExchangeItem(playerItemId, itemNum, content )
	WZLog("send_PLAYERITEM_ExchangeItem")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_ExchangeItem )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerItemId )	-- 玩家物品ID
	sender:writeInt( itemNum )	-- 物品数量
	sender:writeString( content )	-- json内容 目前子类型51的 需要填写内容{"name":"名字","mobile":"手机","address":"地址"}
	SendProtocol(sender,false) --true:showLoading
end
--@brief	使用物品（PLAYERITEM_ExchangeItemOk = 34）
function ProtocolProcessorRecycling:parse_PLAYERITEM_ExchangeItemOk(result)
	-- result : 1、成功，2、数量不足 3、兑换信息不全
	if result == 1 then
		WindowManager:removeWindow(WndGameGoodsGet.m_root, WndGameGoodsGet, true)
	elseif result == 2 then
		MsgBoxManager:showTipBox(LocalStrings.OPTIMIZE_TEXT44)
	elseif result == 3 then
		MsgBoxManager:showTipBox(LocalStrings.OPTIMIZE_TEXT45)
	end
end

function ProtocolProcessorRecycling:regAll2()
	--@brief	获取玩家图鉴信息OK（PLAYERITEM_GetPokedexInfoOk = 36）
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_GetPokedexInfoOk, "ProtocolProcessorRecycling:parse_PLAYERITEM_GetPokedexInfoOk", "vivt")
	--@brief	领取图鉴奖励OK（PLAYERITEM_ReceivePokedexRewardOk = 38）
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_ReceivePokedexRewardOk, "ProtocolProcessorRecycling:parse_PLAYERITEM_ReceivePokedexRewardOk", "iviviii")
	--@brief	图鉴升级OK（PLAYERITEM_PokedexUpgradeOk = 40）
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_PokedexUpgradeOk, "ProtocolProcessorRecycling:parse_PLAYERITEM_PokedexUpgradeOk", "ii")
end
--@brief	获取玩家图鉴信息（PLAYERITEM_GetPokedexInfo = 35）
function ProtocolProcessorRecycling:send_PLAYERITEM_GetPokedexInfo()
	WZLog("send_PLAYERITEM_GetPokedexInfo")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_GetPokedexInfo )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end
--@brief	获取玩家图鉴信息OK（PLAYERITEM_GetPokedexInfoOk = 36）
function ProtocolProcessorRecycling:parse_PLAYERITEM_GetPokedexInfoOk(itemId, rewardStatus)
	-- itemId : 玩家获得过的道具ID
	-- rewardStatus : 玩家获得过的道具的奖励状态【1=可领取|2=已领取】
	GlobalGame:getGameEventDispathcer():Dispatch(LibraryEvent.LibraryEvent_GetLibraryRewardInfo, VectorToTable(itemId), VectorToTable(rewardStatus))
end
--@brief	领取图鉴奖励（PLAYERITEM_ReceivePokedexReward = 37）
function ProtocolProcessorRecycling:send_PLAYERITEM_ReceivePokedexReward(itemId)
	WZLog("send_PLAYERITEM_ReceivePokedexReward")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_ReceivePokedexReward )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(itemId)	-- 领取哪一个道具的收集奖励
	SendProtocol(sender,false) --true:showLoading
end
--@brief	领取图鉴奖励OK（PLAYERITEM_ReceivePokedexRewardOk = 38）
function ProtocolProcessorRecycling:parse_PLAYERITEM_ReceivePokedexRewardOk(itemId, rewardId, rewardNum, level, exp)
	-- itemId : 领取了哪一个道具的收集奖励【客户端请求时传上来的参数】
	-- rewardId : 获得的奖励ID，内含获得的图鉴经验ID=161015
	-- rewardNum : 获得的奖励数量
	-- level : 玩家图鉴等级
	-- exp : 玩家图鉴经验
	WZLog("ProtocolProcessorRecycling:parse_PLAYERITEM_ReceivePokedexRewardOk")
	GlobalGame:getGameEventDispathcer():Dispatch(LibraryEvent.LibraryEvent_GetLibraryRewardResult, itemId, VectorToTable(rewardId), VectorToTable(rewardNum), level, exp)
end
--@brief	图鉴升级（PLAYERITEM_PokedexUpgrade = 39）
function ProtocolProcessorRecycling:send_PLAYERITEM_PokedexUpgrade()
	WZLog("send_PLAYERITEM_PokedexUpgrade")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_PokedexUpgrade )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end
--@brief	图鉴升级OK（PLAYERITEM_PokedexUpgradeOk = 40）
function ProtocolProcessorRecycling:parse_PLAYERITEM_PokedexUpgradeOk(level, exp)
	-- level : 玩家图鉴等级
	-- exp : 玩家图鉴经验
	WZLog("ProtocolProcessorRecycling:parse_PLAYERITEM_PokedexUpgradeOk")
	GlobalGame:getGameEventDispathcer():Dispatch(LibraryEvent.LibraryEvent_GetLibraryUpgradeResult,level, exp)
end
--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorRecycling:unregAll()
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块Begin--------------------------------------
--@brief	回收物品（PLAYERITEM_RecycleItem = 1）
function ProtocolProcessorRecycling:send_PLAYERITEM_RecycleItem(itemId, itemNum, recycleType, bagType)
	WZLog("send_PLAYERITEM_RecycleItem", 
		"\n itemId = ",TableToString(VectorToTable(itemId)), 
		"\n itemNum = ",TableToString(VectorToTable(itemNum)), 
		"\n recycleType = ",TableToString(VectorToTable(recycleType)), 
		"\n bagType = ",bagType)
	--由于普通物品与幻化装备分开回收，一次会发送两次协议，空数组则不发送
	if not itemId or #(VectorToTable(itemId)) <= 0 or not itemNum or #(VectorToTable(itemNum)) <= 0 then
		WZLog("send_PLAYERITEM_RecycleItem empty items")
		return
	end
	local sender = Protocol:getSender( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_RecycleItem )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInts( itemId )	-- 回收物品ID
	sender:writeInts( itemNum )	-- 物品数量
	sender:writeInt(recycleType or 0)	-- 回收类型【0=普通回收|1=消耗礼钻回收】【179+】，变废为宝活动期间回收如若触发抽奖，还会另外推送112-108[doType=3]协议，内含抽奖产出的奖励
	sender:writeInt(bagType or 0)	-- 背包类型【0=默认，1=皮肤装备】
	SendProtocol(sender,false) --true:showLoading
end

--@brief	换装（PLAYERITEM_ChangeEquipment= 3）
function ProtocolProcessorRecycling:send_PLAYERITEM_ChangeEquipment(playerItemId, move)
	WZLog("send_PLAYERITEM_ChangeEquipment", Serialize(VectorToTable(playerItemId)), Serialize(VectorToTable(move)))
	local sender = Protocol:getSender( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_ChangeEquipment )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInts( playerItemId )	-- 新玩家物品ID
	sender:writeInts( move )	-- 是否继承0不继承 1继承
	SendProtocol(sender,false) --true:showLoading

	WndPlayer.m_bChangeDress = true

    local isEndTeach, step = TeachGroup1:isTeachFinish(8)
    if isEndTeach ~= true and step > 0 then
    	PostPlayerEvent:postEvent(PostPlayerEvent.event_fourLvDressup)
        TeachGroup1:endTeachStep({8,4})
        WindowManager:removeTeachShelterLayer()
        WindowManager:addTeachShelterLayer( 999999 )
    end

end

--@brief	使用物品（PLAYERITEM_UseItem = 4）
function ProtocolProcessorRecycling:send_PLAYERITEM_UseItem(playerItemId, itemNum, content )
	WZLog("send_PLAYERITEM_UseItem")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_UseItem )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( tonumber(playerItemId) )	-- 玩家物品ID
	sender:writeInt( itemNum )	-- 物品数量
	sender:writeString( content )	-- 内容
	SendProtocol(sender,false) --true:showLoading
end

--@brief	使用物品（PLAYERITEM_OpenGift = 6）
function ProtocolProcessorRecycling:send_PLAYERITEM_OpenGift(playerItemId, itemNum, itemId)
	WZLog("send_PLAYERITEM_OpenGift")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_OpenGift )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerItemId )	-- 玩家物品ID
	sender:writeInt( itemNum )	-- 物品数量
	sender:writeInt( itemId or 0 )	-- 物品Id（针对自选礼包）
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

--@brief	获取元魂列表信息（PLAYERITEM_GetYuanSoulInfo = 21）
function ProtocolProcessorRecycling:send_PLAYERITEM_GetYuanSoulInfo()
	WZLog("send_PLAYERITEM_GetYuanSoulInfo")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_GetYuanSoulInfo )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	铸魂（PLAYERITEM_CastSoul = 23）
function ProtocolProcessorRecycling:send_PLAYERITEM_CastSoul(suitType, operateType, gridId, playerItemId,num)
	WZLog("send_PLAYERITEM_CastSoul",suitType, operateType, gridId, playerItemId,num)
	local sender = Protocol:getSender( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_CastSoul )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( suitType )	-- 类型 1时装普通元魂 2翅膀普通元魂 3时装共鸣元魂 4翅膀共鸣元魂
	sender:writeInt( operateType )	-- 类型 1铸魂 2升级 3拆卸
	sender:writeInt( gridId )	-- 位置id
	sender:writeInt( playerItemId or 0 )	-- 玩家物品Id
	sender:writeInt( num)
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取玩家祈福套装（PLAYERITEM_GetSuit = 25）
function ProtocolProcessorRecycling:send_PLAYERITEM_GetSuit(suitType)
	WZLog("send_PLAYERITEM_GetSuit")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_GetSuit )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( suitType )	-- 套装类型：6->祈福；7->符文；8->技能/道具/幻技
	SendProtocol(sender,false) --true:showLoading
end

--@brief	修改祈福套装名（PLAYERITEM_ModifySuitName = 27）
function ProtocolProcessorRecycling:send_PLAYERITEM_ModifySuitName(suitType, suitId, name )
	WZLog("send_PLAYERITEM_ModifySuitName")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_ModifySuitName )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( suitType )	-- 套装类型：6->祈福；7->符文；8->技能/道具/幻技
	sender:writeInt( suitId )	-- 套装ID
	sender:writeString( name )	-- 套装名
	SendProtocol(sender,false) --true:showLoading
end

--@brief	增加祈福套装数（PLAYERITEM_IncreaseSuitNum = 29）
function ProtocolProcessorRecycling:send_PLAYERITEM_IncreaseSuitNum(suitType)
	WZLog("send_PLAYERITEM_IncreaseSuitNum")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_IncreaseSuitNum )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( suitType )	-- 套装类型：6->祈福；7->符文；8->技能/道具/幻技
	SendProtocol(sender,false) --true:showLoading
end

--@brief	切换自定义祈福套装（PLAYERITEM_SwitchSuit = 31）
function ProtocolProcessorRecycling:send_PLAYERITEM_SwitchSuit(suitType, suitId)
	WZLog("send_PLAYERITEM_SwitchSuit")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_SwitchSuit )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( suitType )	-- 套装类型：6->祈福；7->符文；8->技能/道具/幻技
	sender:writeInt( suitId )	-- 套装ID
	SendProtocol(sender,false) --true:showLoading
end

--@brief	宠物装备所有方案（PLAYERITEM_PetEquipSchemeList = 41）
function ProtocolProcessorRecycling:send_PLAYERITEM_PetEquipSchemeList()
	WZLog("send_PLAYERITEM_PetEquipSchemeList")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_PetEquipSchemeList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	宠物装备使用方案（PLAYERITEM_PetEquipUseScheme = 43）
function ProtocolProcessorRecycling:send_PLAYERITEM_PetEquipUseScheme(schemeId)
	WZLog("send_PLAYERITEM_PetEquipUseScheme", schemeId)
	local sender = Protocol:getSender( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_PetEquipUseScheme )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeByte(schemeId)	-- 宠物装备方案id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	宠物装备方案重命名（PLAYERITEM_PetEquipSchemeReName = 45）
function ProtocolProcessorRecycling:send_PLAYERITEM_PetEquipSchemeReName(schemeId, name)
	WZLog("send_PLAYERITEM_PetEquipSchemeReName")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_PetEquipSchemeReName )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeByte(schemeId)	-- 方案id
	sender:writeString(name)	-- 修改后的名称
	SendProtocol(sender,false) --true:showLoading
end

--@brief	宠物装备增加方案（PLAYERITEM_PetEquipSchemeAdd = 47）
function ProtocolProcessorRecycling:send_PLAYERITEM_PetEquipSchemeAdd()
	WZLog("send_PLAYERITEM_PetEquipSchemeAdd")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_PetEquipSchemeAdd )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

---------------------------客户端到服务器协议发送方法模块End------------------------------


--------------------------服务器到客户端协议回调方法模块Begin-------------------------------
--@brief	回收物品返回（PLAYERITEM_RecycleItemOk = 2）
function ProtocolProcessorRecycling:parse_PLAYERITEM_RecycleItemOk(result, items, nums)
	-- result : 回收道具结果 0=成功 1=变废为宝活动未上架 2=礼钻不足
	WZLog("ProtocolProcessorRecycling:parse_PLAYERITEM_RecycleItemOk",
		"\nresult =",TableToString(VectorToTable(result)), 
		"\nitems =",TableToString(VectorToTable(items)), 
		"\nnums =",TableToString(VectorToTable(nums)))
	if WndSellList.m_root then
		WndSellList:recycleItemOk(result, items, nums)
		GlobalGame:getGameEventDispathcer():Dispatch(bottomMeneEvent.WndBottomMeneEvent_UpdataBagResertInfo)
		return
	end
	if type(VectorToTable(items)) == "table" and #VectorToTable(items) > 0 then
		WndRewardShow:showById(VectorToTable(items),VectorToTable(nums))
	end
	if WndPetRecover.m_root ~= nil then
		WndPetRecover:recycleSucc()
	end
	GlobalGame:getGameEventDispathcer():Dispatch(bottomMeneEvent.WndBottomMeneEvent_UpdataBagResertInfo)
end

--@brief	使用物品返回（PLAYERITEM_UseItemOk = 5）
function ProtocolProcessorRecycling:parse_PLAYERITEM_UseItemOk(result, itemId)
	-- result : 1、成功，2、重名，3、非法字符，4、名字不能为空，5、名字太长, 6、名字太短,7、纯数字
	WZLog("ProtocolProcessorRecycling:parse_PLAYERITEM_UseItemOk")
	if WndCheckOther.m_root ~= nil then
		if itemId and GDatatab_item["id_" .. itemId] and (GDatatab_item["id_" .. itemId].main_type == 2 and GDatatab_item["id_" .. itemId].sub_type == 49 or GDatatab_item["id_" .. itemId].main_type == 40) then 
			return 
		end
		WndCheckOther:displayResult(result)
		return
	end
	if WndSkillExplosion.m_root then
		WndSkillExplosion:useItemOk(result)
		return
	end
	if result == 1 then
		if itemId == 850 or itemId == 849 then
			MsgBoxManager:showTipBox(LocalStrings.NEWSKILL25)
		elseif itemId == 860 then 
			MsgBoxManager:showTipBox(LocalStrings.BATTLE_HELP_TEXT16)
			CacheCenter:resetAwakeMultiCopyTimes()
			return 
		end
	end
	if WndBag then
		WndBag:displayResult(result)
	end

	WndChangeSex:changeSuccess(result)
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
		if tData.main_type == 42 and tData.sub_type == 2 then
			local text = string.format(LocalStrings.SKILL_EXPLOSION_7, tData.name)
			MsgBoxManager:showConfirmBox(text)
		else
			local text = string.format(LocalStrings.LIMITEQUIP1, tData.name)
			MsgBoxManager:showConfirmBox(text)
		end
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
	WZLog("ProtocolProcessorRecycling:parse_PLAYERITEM_GetDressSuitOk",
		"\nsuitId =",Serialize(VectorToTable(suitId)), 
		"\nname =",Serialize(VectorToTable(name)), 
		"\nisUse =",Serialize(VectorToTable(isUse)))

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

--@brief	获取元魂列表信息成功（PLAYERITEM_GetYuanSoulInfoOk = 22）
function ProtocolProcessorRecycling:parse_PLAYERITEM_GetYuanSoulInfoOk(suitType, gridId, soulId, soulLuck, fashionGongming, wingGongming, titleGongming, fGongmingSpiritId, wGongmingSpiritId, tGongmingSpiritId, fashionLuck, wingLuck, titleLuck)
	WZLog("ProtocolProcessorRecycling:parse_PLAYERITEM_GetYuanSoulInfoOk",
		"\nsuitType =",Serialize(VectorToTable(suitType)), 
		"\ngridId =",Serialize(VectorToTable(gridId)), 
		"\nsoulId =",Serialize(VectorToTable(soulId)), 
		"\nsoulLuck =",Serialize(VectorToTable(soulLuck)), 
		"\nfashionGongming =",Serialize(VectorToTable(fashionGongming)), 
		"\nwingGongming =",Serialize(VectorToTable(wingGongming)), 
		"\nfGongmingSpiritId =",Serialize(VectorToTable(fGongmingSpiritId)), 
		"\nwGongmingSpiritId =",Serialize(VectorToTable(wGongmingSpiritId)), 
		"\nfashionLuck =",Serialize(VectorToTable(fashionLuck)), 
		"\nwingLuck =",Serialize(VectorToTable(wingLuck)))
	-- suitType : 类型1时装 2翅膀 3时装共鸣元魂  4翅膀共鸣元魂 5称号元魂 6称号共鸣元魂
	-- gridId : 格子Id
	-- soulId : 元魂Id
	-- soulLuck : 元魂幸运值
	-- fashionGongming : 时装共鸣元魂位置id
	-- wingGongming : 翅膀共鸣元魂位置id
	-- titleGongming : Vip称号共鸣元魂位置id
	-- fGongmingSpiritId : 时装共鸣元魂id
	-- wGongmingSpiritId : 翅膀共鸣元魂id
	-- tGongmingSpiritId : Vip称号共鸣元魂id
	-- fashionLuck : 时装共鸣元魂幸运值
	-- wingLuck : 翅膀共鸣元魂幸运值
	-- titleLuck : Vip称号共鸣元魂幸运值

	WndDressCastSoul:setSoulData(VectorToTable(suitType), VectorToTable(gridId), VectorToTable(soulId), VectorToTable(soulLuck), VectorToTable(fashionGongming), VectorToTable(wingGongming), VectorToTable(fGongmingSpiritId), VectorToTable(wGongmingSpiritId), VectorToTable(fashionLuck), VectorToTable(wingLuck), VectorToTable(titleGongming), VectorToTable(tGongmingSpiritId), VectorToTable(titleLuck))
end

--@brief	元魂操作成功（PLAYERITEM_CastSoulResult = 24）
function ProtocolProcessorRecycling:parse_PLAYERITEM_CastSoulResult(suitType, gridId, soulId, num, lucky, result)
	WZLog("ProtocolProcessorRecycling:parse_PLAYERITEM_CastSoulResult", suitType, gridId, soulId, num, lucky, Serialize(VectorToTable(result)))
	-- suitType : 套装类型1时装 2翅膀
	-- gridId : 格子Id
	-- soulId : 元魂Id
	-- lucky : 元魂幸运值
	-- result : 元魂升级结果1:失败，0：成功
	if soulId <= 0 then return end 
	WndDressCastSoul:operateSoulResult(suitType, gridId, soulId, num, lucky, VectorToTable(result))
end

--@brief	获取玩家祈福套装（PLAYERITEM_GetSuitOk = 26） 
function ProtocolProcessorRecycling:parse_PLAYERITEM_GetSuitOk(suitType, suitId, name, isUse)
	-- suitType : 套装类型：6->祈福；7->符文；8->技能/道具/幻技
	-- suitId : 套装ID
	-- name : 套装名称
	-- isUse : 是否使用中
	WZLog("ProtocolProcessorRecycling:parse_PLAYERITEM_GetSuitOk", suitType, suitId:size())

	if suitType == 6 then 
		WndBlessBag:setDressSuitData(VectorToTable(suitId), VectorToTable(name), VectorToTable(isUse))
		WndBlessBag:updateDressSuitData()
	elseif suitType == 7 then 
		SceneRune:setDressSuitData(VectorToTable(suitId), VectorToTable(name), VectorToTable(isUse))
		SceneRune:updateDressSuitData()
	elseif suitType == 8 then 
		CacheCenter:setSkillSuitData(VectorToTable(suitId), VectorToTable(name), VectorToTable(isUse))
		WndSkillContainer:setDressSuitData(VectorToTable(suitId), VectorToTable(name), VectorToTable(isUse))
		WndSkillContainer:updateDressSuitData()

		CacheCenter:updateSkillSuitData()
	end
end

--@brief	修改祈福套装名（PLAYERITEM_ModifySuitNameOk = 28）
function ProtocolProcessorRecycling:parse_PLAYERITEM_ModifySuitNameOk(suitType, suitId, name, result)
	-- suitType : 套装类型：6->祈福；7->符文；8->技能/道具/幻技
	-- suitId : 套装ID
	-- name : 套装名
	-- result : result
	WZLog("ProtocolProcessorRecycling:parse_PLAYERITEM_ModifySuitNameOk", suitType)
	if suitType == 6 then 
		if WndBlessBag.m_root and WndBlessBag.m_tCellDressSuit then
			if result == 1 then
				WndBlessBag:dressSuitRename(suitId, name)
			end
			WndBlessBag.m_tCellDressSuit:renameResult(result, suitId, name)
			WndBlessBag:updateDressSuitData()
		end
	elseif suitType == 7 then 
		if SceneRune.m_root and SceneRune.m_tCellDressSuit then
			if result == 1 then
				SceneRune:dressSuitRename(suitId, name)
			end
			SceneRune.m_tCellDressSuit:renameResult(result, suitId, name)
			SceneRune:updateDressSuitData()
		end
	elseif suitType == 8 then 
		if WndSkillContainer.m_root and WndSkillContainer.m_tCellDressSuit then
			if result == 1 then
				CacheCenter:skillSuitRename(suitId, name)
				WndSkillContainer:dressSuitRename(suitId, name)
			end
			WndSkillContainer.m_tCellDressSuit:renameResult(result, suitId, name)
			WndSkillContainer:updateDressSuitData()

			CacheCenter:updateSkillSuitData()
		end
	end

end

--@brief	增加祈福套装数（PLAYERITEM_IncreaseSuitNumOk = 30）
function ProtocolProcessorRecycling:parse_PLAYERITEM_IncreaseSuitNumOk(suitType, suitId, name)
	-- suitType : 套装类型：6->祈福；7->符文；8->技能/道具/幻技
	-- suitId : 套装ID
	-- name : 套装名
	WZLog("ProtocolProcessorRecycling:parse_PLAYERITEM_IncreaseSuitNumOk", suitType)
	if suitType == 6 then 
		WndBlessBag:addNewDressSuit(suitId, name)
		WndBlessBag:updateDressSuitData()
	elseif suitType == 7 then 
		SceneRune:addNewDressSuit(suitId, name)
		SceneRune:updateDressSuitData()
	elseif suitType == 8 then 
		CacheCenter:addNewSkillSuit(suitId, name)
		WndSkillContainer:addNewDressSuit(suitId, name)
		WndSkillContainer:updateDressSuitData()
		CacheCenter:updateSkillSuitData()
	end
end

--@brief	切换自定义祈福套装（PLAYERITEM_SwitchSuitOk = 32）
function ProtocolProcessorRecycling:parse_PLAYERITEM_SwitchSuitOk(suitType)
	-- suitType : 套装类型：6->祈福；7->符文；8->技能/道具/幻技
	WZLog("ProtocolProcessorRecycling:parse_PLAYERITEM_SwitchSuitOk", suitType)

	if suitType == 6 then 
		WndBlessBag:updateDressSuitData(1)
	elseif suitType == 7 then 
		SceneRune:updateDressSuitData(1)
	elseif suitType == 8 then 
		WndSkillContainer:updateDressSuitData(1)
	end
end


--@brief	宠物装备所有方案（PLAYERITEM_PetEquipSchemeListOK = 42）
function ProtocolProcessorRecycling:parse_PLAYERITEM_PetEquipSchemeListOK(schemeId, name, isUse)
	-- schemeId : 方案id
	-- name : 方案名称
	-- isUse : 是否使用
	WZLog("ProtocolProcessorRecycling:parse_PLAYERITEM_PetEquipSchemeListOK",
		"\nschemeId =",Serialize(VectorToTable(schemeId)), 
		"\nname =",Serialize(VectorToTable(name)), 
		"\nisUse =",Serialize(VectorToTable(isUse)))
	CacheCenter:setPetEquipSchemeData(VectorToTable(schemeId), VectorToTable(name), VectorToTable(isUse))
	CacheCenter:updatePetEuqipSchemeData()
end

--@brief	宠物装备使用方案（PLAYERITEM_PetEquipUseSchemeOK = 44）
function ProtocolProcessorRecycling:parse_PLAYERITEM_PetEquipUseSchemeOK(schemeId, itemId, playerItemId)
	-- schemeId : 宠物装备方案id
	-- itemId : 物品id
	-- playerItemId : 宠物装备唯一id
	WZLog("ProtocolProcessorRecycling:parse_PLAYERITEM_PetEquipUseSchemeOK", 
		"\n schemeId =",Serialize(VectorToTable(schemeId)), 
		"\n itemId =",Serialize(VectorToTable(itemId)), 
		"\n playerItemId =",Serialize(VectorToTable(playerItemId)))
	CacheCenter:updatePetEuqipSchemeData(1)
end

--@brief	宠物装备方案重命名（PLAYERITEM_PetEquipSchemeReNameOK = 46）
function ProtocolProcessorRecycling:parse_PLAYERITEM_PetEquipSchemeReNameOK(schemeId, name, code)
	-- schemeId : 方案id
	-- name : 修改后的名称
	WZLog("ProtocolProcessorRecycling:parse_PLAYERITEM_PetEquipSchemeReNameOK", schemeId, name, code)
	CacheCenter:petEquipSchemeRename(schemeId, name)
	CacheCenter:updatePetEuqipSchemeData()
end

--@brief	宠物装备增加方案（PLAYERITEM_PetEquipSchemeAddOK = 48）
function ProtocolProcessorRecycling:parse_PLAYERITEM_PetEquipSchemeAddOK(schemeId, name)
	-- schemeId : 方案id
	-- name : 方案名称
	WZLog("ProtocolProcessorRecycling:parse_PLAYERITEM_PetEquipSchemeAddOK", schemeId, name)

	CacheCenter:addNewPetEquipScheme(schemeId, name)
	CacheCenter:updatePetEuqipSchemeData()
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

--@brief	获取元魂列表信息（PLAYERITEM_GetYuanSoulInfo = 21）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorRecycling:send_PLAYERITEM_GetYuanSoulInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorRecycling:send_PLAYERITEM_GetYuanSoulInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_GetYuanSoulInfo, nflag, sMessage)
end

--@brief	铸魂（PLAYERITEM_CastSoul = 23）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorRecycling:send_PLAYERITEM_CastSoul_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorRecycling:send_PLAYERITEM_CastSoul_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_CastSoul, nflag, sMessage)
end

--@brief	获取玩家祈福套装（PLAYERITEM_GetSuit = 25）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorRecycling:send_PLAYERITEM_GetSuit_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorRecycling:send_PLAYERITEM_GetSuit_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_GetSuit, nflag, sMessage)
end

--@brief	修改祈福套装名（PLAYERITEM_ModifySuitName = 27）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorRecycling:send_PLAYERITEM_ModifySuitName_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorRecycling:send_PLAYERITEM_ModifySuitName_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_ModifySuitName, nflag, sMessage)
end

--@brief	增加祈福套装数（PLAYERITEM_IncreaseSuitNum = 29）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorRecycling:send_PLAYERITEM_IncreaseSuitNum_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorRecycling:send_PLAYERITEM_IncreaseSuitNum_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_IncreaseSuitNum, nflag, sMessage)
end

--@brief	切换自定义祈福套装（PLAYERITEM_SwitchSuit = 31）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorRecycling:send_PLAYERITEM_SwitchSuit_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorRecycling:send_PLAYERITEM_SwitchSuit_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_SwitchSuit, nflag, sMessage)
end

--@brief	宠物装备所有方案（PLAYERITEM_PetEquipSchemeList = 41）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorRecycling:send_PLAYERITEM_PetEquipSchemeList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorRecycling:parse_PLAYERITEM_PetEquipSchemeList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_PetEquipSchemeList, nflag, sMessage)
end

--@brief	宠物装备使用方案（PLAYERITEM_PetEquipUseScheme = 43）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorRecycling:send_PLAYERITEM_PetEquipUseScheme_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorRecycling:parse_PLAYERITEM_PetEquipUseScheme_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_PetEquipUseScheme, nflag, sMessage)
end

--@brief	宠物装备方案重命名（PLAYERITEM_PetEquipSchemeReName = 45）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorRecycling:send_PLAYERITEM_PetEquipSchemeReName_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorRecycling:parse_PLAYERITEM_PetEquipSchemeReName_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_PetEquipSchemeReName, nflag, sMessage)
end

--@brief	宠物装备增加方案（PLAYERITEM_PetEquipSchemeAdd = 47）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorRecycling:send_PLAYERITEM_PetEquipSchemeAdd_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorRecycling:parse_PLAYERITEM_PetEquipSchemeAdd_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYERITEM, Protocol.PLAYERITEM_PetEquipSchemeAdd, nflag, sMessage)
end

