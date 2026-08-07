

ProtocolProcessorStore = ProtocolProcessorBase:new()


--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorStore:regAll()
	--@brief	获取公会商店（GUILD_GetGuildStoreOk = 45）
	self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildStoreOk, "ProtocolProcessorStore:parse_GUILD_GetGuildStoreOk", "vivii")
	--@brief	购买公会商店（GUILD_BuyGuildStoreOk = 47）
	self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_BuyGuildStoreOk, "ProtocolProcessorStore:parse_GUILD_BuyGuildStoreOk", "t")
	--@brief	获取公会商店（GUILD_GetGuildStore = 44）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildStore, "ProtocolProcessorStore:send_GUILD_GetGuildStore_ErrorProcess", "is" )
	--@brief	购买公会商店（GUILD_BuyGuildStore = 46）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_BuyGuildStore, "ProtocolProcessorStore:send_GUILD_BuyGuildStore_ErrorProcess", "is" )
	--@brief	刷新公会商店（GUILD_RefreshGuildStore = 48）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_RefreshGuildStore, "ProtocolProcessorStore:send_GUILD_RefreshGuildStore_ErrorProcess", "is" )
	--@brief	获取公会商店日志（GUILD_GetGuildStoreLog = 86）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildStoreLog, "ProtocolProcessorStore:send_GUILD_GetGuildStoreLog_ErrorProcess", "is" )
    --@brief	获取公会商店日志（GUILD_GetGuildStoreLogOk = 87）
    self:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildStoreLogOk ,"ProtocolProcessorStore:parse_GUILD_GetGuildStoreLogOk", "vtvsvivsvivi")



    --@brief	获取黑店信息结果（MALL_GetBlackMarketInfoOk = 21）
	self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_GetBlackMarketInfoOk, "ProtocolProcessorStore:parse_MALL_GetBlackMarketInfoOk", "bivivivivivivi")
	--@brief	购买黑店商品结果（MALL_PurchaseBlackMarketOk = 24）
	self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_PurchaseBlackMarketOk, "ProtocolProcessorStore:parse_MALL_PurchaseBlackMarketOk", "")
	--@brief	关闭黑店结果（MALL_CloseBlackMarketOk = 26）
	self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_CloseBlackMarketOk, "ProtocolProcessorStore:parse_MALL_CloseBlackMarketOk", "")
    --@brief	获取黑店信息（MALL_GetBlackMarketInfo = 20）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_GetBlackMarketInfo, "ProtocolProcessorStore:send_MALL_GetBlackMarketInfo_ErrorProcess", "is" )
	--@brief	购买黑店商品（MALL_PurchaseBlackMarket = 23）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_PurchaseBlackMarket, "ProtocolProcessorStore:send_MALL_PurchaseBlackMarket_ErrorProcess", "is" )
	--@brief	关闭黑店（MALL_CloseBlackMarket = 25）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_CloseBlackMarket, "ProtocolProcessorStore:send_MALL_CloseBlackMarket_ErrorProcess", "is" )
    

    --@brief	获取竞技商品列表（ROOM_GetArenaStoreOk = 24）
    self:regProtocolCallbackFunction( Protocol.MAIN_ROOM , Protocol.ROOM_GetArenaStoreOk, "ProtocolProcessorStore:parse_ROOM_GetArenaStoreOk", "vivsvsviil")
    --@brief	获取竞技商品列表（ROOM_GetArenaStore = 23）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ROOM , Protocol.ROOM_GetArenaStore, "ProtocolProcessorStore:send_ROOM_GetArenaStore_ErrorProcess", "is" )
    --@brief	购买竞技商店物品（ROOM_BuyArenaStore = 25）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_BuyArenaStore, "ProtocolProcessorStore:send_ROOM_BuyArenaStore_ErrorProcess", "is" )
    --@brief	购买竞技商店物品（ROOM_BuyArenaStoreOk = 26）
    self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_BuyArenaStoreOk, "ProtocolProcessorStore:parse_ROOM_BuyArenaStoreOk", " ")
    --@brief	刷新竞技商店（ROOM_RefreshArenaStore = 27）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_RefreshArenaStore, "ProtocolProcessorStore:send_ROOM_RefreshArenaStore_ErrorProcess", "is" )


    --@brief    获取祈福商店信息结果（PRAY_GetPrayShopOk = 18）
    self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.PRAY_GetPrayShopOk, "ProtocolProcessorStore:parse_PRAY_GetPrayShopOk", "vivsvsvs")
    --@brief    购买祈福商店物品结果（PRAY_GetShopOk = 20）
    self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.PRAY_GetShopOk, "ProtocolProcessorStore:parse_PRAY_GetShopOk", "vivivi")
    --@brief    获取祈福商店信息（PRAY_GetPrayShop = 17）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.PRAY_GetPrayShop, "ProtocolProcessorStore:send_PRAY_GetPrayShop_ErrorProcess", "is" )
    --@brief    购买祈福商店物品（PRAY_buy = 19）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.PRAY_buy, "ProtocolProcessorStore:send_PRAY_buy_ErrorProcess", "is" )

    
    --@brief	获取宠物商店（PET_GetPetStore = 18）								
	self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_GetPetStore, "ProtocolProcessorStore:send_PET_GetPetStore_ErrorProcess", "is" )
     --@brief	获取宠物商店成功（PET_GetPetStoreOk = 19）
    self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_GetPetStoreOk, "ProtocolProcessorStore:parse_PET_GetPetStoreOk", "viviviviviviiiii")
     --@brief	购买宠物成功（PET_PurchasePetOk = 21）
    self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_PurchasePetOk, "ProtocolProcessorStore:parse_PET_PurchasePetOk", "i")
     --@brief	购买宠物（PET_PurchasePet = 20）								
	self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_PurchasePet, "ProtocolProcessorStore:send_PET_PurchasePet_ErrorProcess", "is" )


    --@brief    获取卡牌信息（CARD_GetCardMesOk = 2）
    self:regProtocolCallbackFunction( Protocol.MAIN_CARD, Protocol.CARD_GetCardMesOk, "ProtocolProcessorStore:parse_CARD_GetCardMesOk", "vivivivivsvsviviivi")
    --@brief    获取卡牌信息（CARD_GetCardMes = 1）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_CARD, Protocol.CARD_GetCardMes, "ProtocolProcessorStore:send_CARD_GetCardMes_ErrorProcess", "is" )
    --@brief    购买卡牌（CARD_BuyCardOk = 6）
    self:regProtocolCallbackFunction( Protocol.MAIN_CARD, Protocol.CARD_BuyCardOk, "ProtocolProcessorStore:parse_CARD_BuyCardOk", "i")
    --@brief    购买卡牌（CARD_BuyCard = 5）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_CARD, Protocol.CARD_BuyCard, "ProtocolProcessorStore:send_CARD_BuyCard_ErrorProcess", "is" )
     --@brief    刷新卡牌商店（CARD_RefreshCardStore = 13）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_CARD, Protocol.CARD_RefreshCardStore, "ProtocolProcessorStore:send_CARD_RefreshCardStore_ErrorProcess", "is" )
    
    --符文商店
    --@brief	获取符文商店信息（RUNE_GetRuneStore = 11）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_RUNE, Protocol.RUNE_GetRuneStore, "ProtocolProcessorStore:send_RUNE_GetRuneStore_ErrorProcess", "is" )
	--@brief	获取符文商店信息（RUNE_GetRuneStoreOk = 12）
	self:regProtocolCallbackFunction( Protocol.MAIN_RUNE, Protocol.RUNE_GetRuneStoreOk , "ProtocolProcessorStore:parse_RUNE_GetRuneStoreOk", "vivii")
	--@brief	刷新符文商店（RUNE_RefreshRuneStore = 13）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_RUNE, Protocol.RUNE_RefreshRuneStore, "ProtocolProcessorStore:send_RUNE_RefreshRuneStore_ErrorProcess", "is" )
	--@brief	购买商品（RUNE_BuyCommodity = 14）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_RUNE, Protocol.RUNE_BuyCommodity, "ProtocolProcessorStore:send_RUNE_BuyCommodity_ErrorProcess", "is" )
	--@brief	购买商品（RUNE_BuyCommodityStatus = 15）
	self:regProtocolCallbackFunction( Protocol.MAIN_RUNE, Protocol.RUNE_BuyCommodityStatus , "ProtocolProcessorStore:parse_RUNE_BuyCommodityStatus", "tii")

    
    --装备商店
    --@brief	获取装备商店（EQUIP_GetEquipStore = 16）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_EQUIP, Protocol.EQUIP_GetEquipStore, "ProtocolProcessorStore:send_EQUIP_GetEquipStore_ErrorProcess", "is" )
    --@brief	获取装备商店（EQUIP_GetEquipStoreOk = 17）
    self:regProtocolCallbackFunction( Protocol.MAIN_EQUIP, Protocol.EQUIP_GetEquipStoreOk, "ProtocolProcessorStore:parse_EQUIP_GetEquipStoreOk", "viviviviviviiiii")
    --@brief	刷新装备商店（EQUIP_RefreshEquipStore = 18）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_EQUIP, Protocol.EQUIP_RefreshEquipStore, "ProtocolProcessorStore:send_EQUIP_RefreshEquipStore_ErrorProcess", "is" )
    --@brief	装备商店购买（EQUIP_Purchase = 19）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_EQUIP, Protocol.EQUIP_Purchase, "ProtocolProcessorStore:send_EQUIP_Purchase_ErrorProcess", "is" )
    --@brief	装备商店购买（EQUIP_PurchaseOk = 20）
    self:regProtocolCallbackFunction( Protocol.MAIN_EQUIP, Protocol.EQUIP_PurchaseOk, "ProtocolProcessorStore:parse_EQUIP_PurchaseOk", "ii")

    
    --冒险商店
    --@brief	获取冒险商品列表（MALL_GetArenaStore = 49）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_GetArenaStore, "ProtocolProcessorStore:send_MALL_GetArenaStore_ErrorProcess", "is" )
    --@brief	获取冒险商品列表（MALL_GetArenaStoreOk = 50）
    self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_GetArenaStoreOk, "ProtocolProcessorStore:parse_MALL_GetArenaStoreOk", "vivsvsviil")
    --@brief	刷新冒险商店（MALL_RefreshArenaStore = 53）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_RefreshArenaStore, "ProtocolProcessorStore:send_MALL_RefreshArenaStore_ErrorProcess", "is" )
    --@brief	购买冒险商店物品（MALL_BuyArenaStore = 51）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_BuyArenaStore, "ProtocolProcessorStore:send_MALL_BuyArenaStore_ErrorProcess", "is" )
    --@brief	购买冒险商店物品（MALL_BuyArenaStoreOk = 52）
    self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_BuyArenaStoreOk, "ProtocolProcessorStore:parse_MALL_BuyArenaStoreOk", "s")

    
    --排位商店
    --@brief    获取排位商店（PLAYER_GetTrioRankMatchShop = 104）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetTrioRankMatchShop, "ProtocolProcessorStore:send_PLAYER_GetTrioRankMatchShop_ErrorProcess", "is" )
    --@brief    刷新排位商店（成功返回105）（PLAYER_RefreshTrioRankMatchShop = 106）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_RefreshTrioRankMatchShop, "ProtocolProcessorStore:send_PLAYER_RefreshTrioRankMatchShop_ErrorProcess", "is" ) 
    --@brief    购买排位商店物品（PLAYER_BuyTrioRankMatch = 107）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_BuyTrioRankMatch, "ProtocolProcessorStore:send_PLAYER_BuyTrioRankMatch_ErrorProcess", "is" )
    --@brief    获取排位商店（PLAYER_GetTrioRankMatchShopOk = 105）
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetTrioRankMatchShopOk, "ProtocolProcessorStore:parse_PLAYER_GetTrioRankMatchShopOk", "vivivivivivii")
    --@brief    购买排位商店物品（PLAYER_BuyTrioRankMatchOk = 108）
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_BuyTrioRankMatchOk, "ProtocolProcessorStore:parse_PLAYER_BuyTrioRankMatchOk", "")

end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorStore:unregAll()
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块--------------------------------------

--@brief	获取公会商店（GUILD_GetGuildStore = 44）
function ProtocolProcessorStore:send_GUILD_GetGuildStore()
	WZLog("send_GUILD_GetGuildStore")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildStore )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	购买公会商店（GUILD_BuyGuildStore = 46）
function ProtocolProcessorStore:send_GUILD_BuyGuildStore(itemId,buyNum)
	WZLog("send_GUILD_BuyGuildStore")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_BuyGuildStore )
	if sender==nil then WZLog("sender == nil") return end
	sender:writeInt( itemId )	-- 商品ID
	sender:writeInt( buyNum )	-- 购买数量
	SendProtocol(sender,false) 
end

--@brief	刷新公会商店（GUILD_RefreshGuildStore = 48）
function ProtocolProcessorStore:send_GUILD_RefreshGuildStore()
	WZLog("send_GUILD_RefreshGuildStore")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_RefreshGuildStore )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取黑店信息（MALL_GetBlackMarketInfo = 20）
function ProtocolProcessorStore:send_MALL_GetBlackMarketInfo()
	WZLog("send_MALL_GetBlackMarketInfo")
	local sender = Protocol:getSender( Protocol.MAIN_MALL, Protocol.MALL_GetBlackMarketInfo )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	购买黑店商品（MALL_PurchaseBlackMarket = 23）
function ProtocolProcessorStore:send_MALL_PurchaseBlackMarket(id)
	WZLog("send_MALL_PurchaseBlackMarket")
	local sender = Protocol:getSender( Protocol.MAIN_MALL, Protocol.MALL_PurchaseBlackMarket )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( id )	-- 物品表id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	关闭黑店（MALL_CloseBlackMarket = 25）
function ProtocolProcessorStore:send_MALL_CloseBlackMarket()
	WZLog("send_MALL_CloseBlackMarket")
	local sender = Protocol:getSender( Protocol.MAIN_MALL, Protocol.MALL_CloseBlackMarket )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取竞技商品列表（ROOM_GetArenaStore = 23）
function ProtocolProcessorStore:send_ROOM_GetArenaStore()
    WZLog("send_ROOM_GetArenaStore")
    local sender = Protocol:getSender( Protocol.MAIN_ROOM , Protocol.ROOM_GetArenaStore )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief	购买竞技商店物品（ROOM_BuyArenaStore = 25）
function ProtocolProcessorStore:send_ROOM_BuyArenaStore(storeId )
    WZLog("send_ROOM_BuyArenaStore")
    local sender = Protocol:getSender( Protocol.MAIN_ROOM, Protocol.ROOM_BuyArenaStore )
    if sender==nil then WZLog("sender == nil") return end
    sender:writeInt( storeId )	-- 123456
    SendProtocol(sender,false) --true:showLoading
end

--@brief	刷新竞技商店（ROOM_RefreshArenaStore = 27）
function ProtocolProcessorStore:send_ROOM_RefreshArenaStore()
    WZLog("send_ROOM_RefreshArenaStore")
    local sender = Protocol:getSender( Protocol.MAIN_ROOM, Protocol.ROOM_RefreshArenaStore )
    if sender==nil then WZLog("sender == nil") return end
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取祈福商店信息（PRAY_GetPrayShop = 17）
function ProtocolProcessorStore:send_PRAY_GetPrayShop()
    WZLog("send_PRAY_GetPrayShop")
    local sender = Protocol:getSender( Protocol.MAIN_TRATE, Protocol.PRAY_GetPrayShop )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    购买祈福商店物品（PRAY_buy = 19）
function ProtocolProcessorStore:send_PRAY_buy(shopId )
    WZLog("send_PRAY_buy")
    local sender = Protocol:getSender( Protocol.MAIN_TRATE, Protocol.PRAY_buy )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( shopId )   -- 商品id
    SendProtocol(sender,false) --true:showLoading
end

--@brief	获取宠物商店（PET_GetPetStore = 18）
function ProtocolProcessorStore:send_PET_GetPetStore()
	WZLog("ProtocolProcessorScenePets:send_PET_GetPetStore")
	local sender = Protocol:getSender( Protocol.MAIN_PET, Protocol.PET_GetPetStore)
	if sender==nil then WZLog("sender == nil") return end
	SendProtocol(sender,false) --true:showLoading
end

--@brief    获取卡牌信息（CARD_GetCardMes = 1）
function ProtocolProcessorStore:send_CARD_GetCardMes()
    WZLog("ProtocolProcessorStore:send_CARD_GetCardMes")
    local sender = Protocol:getSender( Protocol.MAIN_CARD, Protocol.CARD_GetCardMes )
    if sender==nil then WZLog("sender == nil") return end
    SendProtocol(sender,false) --true:showLoading
end

--@brief	刷新宠物列表（PET_RefreshStore = 22）
function ProtocolProcessorStore:send_PET_RefreshStore()
	WZLog("ProtocolProcessorScenePets:send_PET_RefreshStore(")
	local sender = Protocol:getSender( Protocol.MAIN_PET, Protocol.PET_RefreshStore)
	if sender==nil then WZLog("sender == nil") return end
	SendProtocol(sender,false) --true:showLoading
end

--@brief	购买宠物（PET_PurchasePet = 20）
function ProtocolProcessorStore:send_PET_PurchasePet(itemId)
	WZLog("ProtocolProcessorStore:send_PET_PurchasePet = ",itemId)
	local sender = Protocol:getSender( Protocol.MAIN_PET, Protocol.PET_PurchasePet)
	if sender==nil then WZLog("sender == nil") return end
	sender:writeInt( itemId )	-- 玩家宠物id
	SendProtocol(sender,false) --true:showLoading
end

--@brief    购买卡牌（CARD_BuyCard = 5）
function ProtocolProcessorStore:send_CARD_BuyCard(shopId)
    WZLog("ProtocolProcessorStore:send_CARD_BuyCard")
    local sender = Protocol:getSender( Protocol.MAIN_CARD, Protocol.CARD_BuyCard )
    if sender==nil then WZLog("sender == nil") return end
    sender:writeInt( shopId ) 
    SendProtocol(sender,false) --true:showLoading
end

--@brief	获取公会商店日志（GUILD_GetGuildStoreLog = 86）
function ProtocolProcessorStore:send_GUILD_GetGuildStoreLog()
	WZLog("send_GUILD_GetGuildStoreLog")
	local sender = Protocol:getSender( Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildStoreLog )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取符文商店信息（RUNE_GetRuneStore = 11）
function ProtocolProcessorStore:send_RUNE_GetRuneStore()
	WZLog("send_RUNE_GetRuneStore")
	local sender = Protocol:getSender( Protocol.MAIN_RUNE, Protocol.RUNE_GetRuneStore)
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	刷新符文商店（RUNE_RefreshRuneStore = 13）
function ProtocolProcessorStore:send_RUNE_RefreshRuneStore()
	WZLog("send_RUNE_RefreshRuneStore")
	local sender = Protocol:getSender( Protocol.MAIN_RUNE, Protocol.RUNE_RefreshRuneStore )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	购买商品（RUNE_BuyCommodity = 14）
function ProtocolProcessorStore:send_RUNE_BuyCommodity(commodityId )
	WZLog("send_RUNE_BuyCommodity")
	local sender = Protocol:getSender( Protocol.MAIN_RUNE, Protocol.RUNE_BuyCommodity )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( commodityId )	-- 购买商品的ID
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取装备商店（EQUIP_GetEquipStore = 16）
function ProtocolProcessorStore:send_EQUIP_GetEquipStore()
	WZLog("send_EQUIP_GetEquipStore")
	local sender = Protocol:getSender( Protocol.MAIN_EQUIP, Protocol.EQUIP_GetEquipStore )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	刷新装备商店（EQUIP_RefreshEquipStore = 18）
function ProtocolProcessorStore:send_EQUIP_RefreshEquipStore()
	WZLog("send_EQUIP_RefreshEquipStore")
	local sender = Protocol:getSender( Protocol.MAIN_EQUIP, Protocol.EQUIP_RefreshEquipStore )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	装备商店购买（EQUIP_Purchase = 19）
function ProtocolProcessorStore:send_EQUIP_Purchase(configId )
	WZLog("send_EQUIP_Purchase")
	local sender = Protocol:getSender( Protocol.MAIN_EQUIP, Protocol.EQUIP_Purchase )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( configId )	-- 配置表id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取冒险商品列表（MALL_GetArenaStore = 49）
function ProtocolProcessorStore:send_MALL_GetArenaStore()
	WZLog("send_MALL_GetArenaStore")
	local sender = Protocol:getSender( Protocol.MAIN_MALL, Protocol.MALL_GetArenaStore )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	刷新冒险商店（MALL_RefreshArenaStore = 53）
function ProtocolProcessorStore:send_MALL_RefreshArenaStore()
	WZLog("send_MALL_RefreshArenaStore")
	local sender = Protocol:getSender( Protocol.MAIN_MALL, Protocol.MALL_RefreshArenaStore )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	购买冒险商店物品（MALL_BuyArenaStore = 51）
function ProtocolProcessorStore:send_MALL_BuyArenaStore(storeId)
	WZLog("send_MALL_BuyArenaStore ",storeId)
	local sender = Protocol:getSender( Protocol.MAIN_MALL, Protocol.MALL_BuyArenaStore )
	if sender==nil then WZLog("sender == nil") return end
	sender:writeInt(storeId)	
	SendProtocol(sender,false) --true:showLoading
end

--@brief    刷新卡牌商店（CARD_RefreshCardStore = 13）
function ProtocolProcessorStore:send_CARD_RefreshCardStore()
    WZLog("send_CARD_RefreshCardStore")
    local sender = Protocol:getSender( Protocol.MAIN_CARD, Protocol.CARD_RefreshCardStore )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取排位商店（PLAYER_GetTrioRankMatchShop = 104）
function ProtocolProcessorStore:send_PLAYER_GetTrioRankMatchShop( )
    WZLog("send_PLAYER_GetTrioRankMatchShop")
    local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetTrioRankMatchShop )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    刷新排位商店（成功返回105）（PLAYER_RefreshTrioRankMatchShop = 106）
function ProtocolProcessorStore:send_PLAYER_RefreshTrioRankMatchShop()
    WZLog("send_PLAYER_RefreshTrioRankMatchShop")
    local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_RefreshTrioRankMatchShop )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    购买排位商店物品（PLAYER_BuyTrioRankMatch = 107）
function ProtocolProcessorStore:send_PLAYER_BuyTrioRankMatch(id )
    WZLog("send_PLAYER_BuyTrioRankMatch")
    local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_BuyTrioRankMatch )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( id )   -- 唯一标识
    SendProtocol(sender,false) --true:showLoading
end


-------------------------------------服务器到客户端协议回调方法模块--------------------------------------

--@brief	获取公会商店（GUILD_GetGuildStoreOk = 45）
function ProtocolProcessorStore:parse_GUILD_GetGuildStoreOk(itemId, itemNum, guildLevel)
	-- itemId	int[]	商品ID
    -- itemNum	int[]	商品数量
    -- guildLevel	int	公会等级
	WZLog("ProtocolProcessorStore:parse_GUILD_GetGuildStoreOk")
	if not WndStore or WndStore.m_root == nil then return end
	itemId = VectorToTable(itemId)
	itemNum = VectorToTable(itemNum)
    local shopList = {}
	for i=1,#itemId do
		local tempTable = {}
		tempTable.itemId = itemId[i]
		tempTable.itemNum = itemNum[i]
		tempTable.guildLevel = guildLevel
		table.insert(shopList,tempTable)
	end
	WndStore:setCommunityShopData(shopList)
end

--@brief	购买公会商店（GUILD_BuyGuildStoreOk = 47）
function ProtocolProcessorStore:parse_GUILD_BuyGuildStoreOk(status)
	WZLog("ProtocolProcessorStore:parse_GUILD_BuyGuildStoreOk")
	if not WndStore or WndStore.m_root == nil then return end
	if status == 0 then
		WndStore:storeItemBuySuccess()
	else
		WndStore:storeItemBuyFile(stats)
	end
end


--@brief	获取黑店信息结果（MALL_GetBlackMarketInfoOk = 21）
function ProtocolProcessorStore:parse_MALL_GetBlackMarketInfoOk(isOpen, leftSecond, id, itemId, gainCount, leftBuyTime, costItemId, costCount)
	-- isOpen : 黑店是否开启
	-- leftSecond : 黑店剩余时间(s)
	-- itemId : 商品id
	-- gainCount : 商品数目 
	-- leftBuyTime : 剩余购买次数
	-- costItemId : 消耗物品id
	-- costCount : 消耗数目
	WZLog("ProtocolProcessorStore:parse_MALL_GetBlackMarketInfoOk",leftSecond)
	if leftSecond > 0 then
		WndGangsterInn.m_bOpen = true
	else
		WndGangsterInn.m_bOpen = false
	end
	id = VectorToTable(id)
	itemId = VectorToTable(itemId)
	gainCount = VectorToTable(gainCount)
	leftBuyTime = VectorToTable(leftBuyTime)
	costItemId = VectorToTable(costItemId)
	costCount = VectorToTable(costCount)
	local tempDataList = {}
	for i=1,#itemId do
		local tempData = {}
		tempData.id = id[i]
		tempData.itemId = itemId[i]
		tempData.gainCount = gainCount[i]
		tempData.leftBuyTime = leftBuyTime[i]
		tempData.costItemId = costItemId[i]
		tempData.costCount = costCount[i]

		table.insert(tempDataList, tempData)
	end
	WndGangsterInnActivity:update()
	WndStore:setSurpriseShopData(tempDataList,leftSecond,isOpen)
end

--@brief	购买黑店商品结果（MALL_PurchaseBlackMarketOk = 24）
function ProtocolProcessorStore:parse_MALL_PurchaseBlackMarketOk()
	WZLog("ProtocolProcessorStore:parse_MALL_PurchaseBlackMarketOk")
	if not WndStore or WndStore.m_root == nil then return end
	WndStore:storeItemBuySuccess()
end

--@brief	关闭黑店结果（MALL_CloseBlackMarketOk = 26）
function ProtocolProcessorStore:parse_MALL_CloseBlackMarketOk()
	WZLog("ProtocolProcessorStore:parse_MALL_CloseBlackMarketOk")
	WndGangsterInn.m_bOpen = false
	WndGangsterInnActivity:update()
end

--@brief	获取竞技商品列表（ROOM_GetArenaStoreOk = 24）
function ProtocolProcessorStore:parse_ROOM_GetArenaStoreOk(storeId, store, cost, status, refreshCount, nextRefreshTime)
    -- storeId : 商店ID（购买时使用该ID）
    -- store : 商品,格式[100,2]
    -- cost : 购买消耗，格式[7,100]
    -- status : 状态0未买过，1已买过了
    -- refreshCount : 刷新次数
    -- nextRefreshTime : 下次自动刷新时间(秒数)
    WZLog("ProtocolProcessorStore:parse_ROOM_GetArenaStoreOk")
    if not WndStore or WndStore.m_root == nil then return end
    local shopInfo = {}
    for i = 0, storeId:size()-1 do
        local temp = nil
        local prop = {}
        prop.storeId = storeId:get(i)
        temp = SplitTeachTalkStringWithSeparator(store:get(i))
        temp = SplitStringWithSeparator(temp[1],",")
        prop.propId = tonumber(temp[1])
        prop.propNum = tonumber(temp[2])
        temp = SplitTeachTalkStringWithSeparator(cost:get(i))
        temp = SplitStringWithSeparator(temp[1],",")
        prop.costId = tonumber(temp[1])
        prop.costNum = tonumber(temp[2])
        prop.status = status:get(i)
        --物品基础数据
        local key = "id_"..prop.propId
        prop.basicInfo = GDatatab_item[key]
        table.insert(shopInfo,prop)
    end
    WndStore:setFightShopData(shopInfo,refreshCount,nextRefreshTime)
    WZLog("--------------------------get ath shop list-------------------------------")
end

--@brief	购买竞技商店物品（ROOM_BuyArenaStoreOk = 26）
function ProtocolProcessorStore:parse_ROOM_BuyArenaStoreOk()
    WZLog("ProtocolProcessorStore:parse_ROOM_BuyArenaStoreOk")
    if not WndStore or WndStore.m_root == nil then return end
    WndStore:storeItemBuySuccess()
end

--@brief    获取祈福商店信息结果（PRAY_GetPrayShopOk = 18）
function ProtocolProcessorStore:parse_PRAY_GetPrayShopOk(shopId, store, name, cost)
    -- shopId : 商品id
    -- store : 商品信息
    -- name : 商品名称
    -- cost : 购买商品消耗
    WZLog("ProtocolProcessorStore:parse_PRAY_GetPrayShopOk")
    if not WndStore or WndStore.m_root == nil then return end
    local shopItemList = {}

	for i = 0, shopId:size() - 1 do
		local itemId = SplitStringToTable(store:get(i))

		local tTemp = CopyTable(GDatatab_pray["id_"..itemId[1]])
		tTemp.shopId = shopId:get(i)
		tTemp.itemid_num = itemId
		tTemp.curExp = 0
		tTemp.cost = SplitStringToTable(cost:get(i))
		tTemp.userType = 4
		tTemp.basicInfo = CopyTable(GDatatab_item["id_"..tTemp.item_id])
		tTemp.name = tTemp.basicInfo.name

		table.insert(shopItemList, tTemp)
	end

	table.sort(shopItemList, function (a, b) 
		return a.shopId < b.shopId
	end)
	
	WndStore:setBlessShopData(shopItemList)
end

--@brief    购买祈福商店物品结果（PRAY_GetShopOk = 20）
function ProtocolProcessorStore:parse_PRAY_GetShopOk(buyPrayId, prayId, exp)
    -- buyPrayId : 购买祈福珠唯一标示id列表
    -- prayId : 购买祈福珠Id
    -- exp : 购买祈福珠经验
    WZLog("ProtocolProcessorStore:parse_PRAY_GetShopOk")
     if not WndStore or WndStore.m_root == nil then return end
    WndStore:storeItemBuySuccess()
    WndBlessBag:resetBagList(buyPrayId, prayId, exp)
end

--@brief	获取宠物商店成功（PET_GetPetStoreOk = 19）		
function ProtocolProcessorStore:parse_PET_GetPetStoreOk(id,gainNum,itemId,costId,price,leftNum,leftRefreshTimes,totalRefreshTimes,refreshCostId,refreshCostNum)
	-- id : 唯一标志
	-- gainNum : 购买获取数目
	-- itemId : 获取物品的id
	-- costId : 消耗物品的id
	-- price : 价格
	-- leftNum : 剩余可购买数目
	-- leftRefreshTimes : 剩余的刷新次数
	-- totalRefreshTimes : 总的刷新次数
	-- refreshCostId : 刷新消耗物品的id
	-- refreshCostNum : 刷新消耗物品的数量
	WZLog("ProtocolProcessorStore:parse_PET_GetPetStoreOk")
	if not WndStore or WndStore.m_root == nil then return end
	local tData = {}
	tData.shopList = {}
	tData.leftRefreshTimes = leftRefreshTimes
	tData.totalRefreshTimes = totalRefreshTimes
	tData.refreshCostId = refreshCostId
	tData.refreshCostNum = refreshCostNum
	for i = 0 , id:size() - 1 do
		local tab = {}
		tab.id = id:get(i)
		tab.gainNum = gainNum:get(i)
		tab.itemId = itemId:get(i)
		tab.costId = costId:get(i)
		tab.price = price:get(i)
		tab.status = leftNum:get(i) == 0 and 1 or 0
		table.insert(tData.shopList, tab)
	end
    WndStore:setPetShopData(tData)
end

--@brief	购买宠物成功（PET_GetPetStoreOk = 21）
function ProtocolProcessorStore:parse_PET_PurchasePetOk(itemId)
	-- itemId : 宠物itemID
	WZLog("ProtocolProcessorStore:parse_PET_PurchasePetOk")
	if not WndStore or WndStore.m_root == nil then return end
    WndStore:storeItemBuySuccess()
    WndPets:doRefresh()
end


--@brief    获取卡牌信息（CARD_GetCardMesOk = 2）
function ProtocolProcessorStore:parse_CARD_GetCardMesOk(itemId, level, num, shopId, shopItem, shopPrice, shopRebate, shopStatus, refreshCount,lookItemId)
    -- itemId : 物品Id
    -- level : 等级
    -- num : 数量
    -- shopId : 卡牌商店ID
    -- shopItem : 卡牌商店物品
    -- shopPrice : 卡牌商店价格
    -- shopRebate : 卡牌商店打折
    -- shopStatus : 卡牌商店商品状态 0可购买 1已售罄
    -- refreshCount : 手动刷新次数
    -- lookItemId : 查看过的卡牌ID
    WZLog("ProtocolProcessorStore:parse_CARD_GetCardMesOk ")
    WndStore:setCardShopData(VectorToTable(itemId), VectorToTable(level), VectorToTable(num), VectorToTable(shopId), VectorToTable(shopItem), VectorToTable(shopPrice), VectorToTable(shopRebate),VectorToTable(shopStatus),refreshCount)
end

--@brief    购买卡牌（CARD_BuyCardOk = 6）
function ProtocolProcessorStore:parse_CARD_BuyCardOk(shopid)
    WZLog("ProtocolProcessorStore:parse_CARD_BuyCardOk =",shopid)
    WndStore:buyCardSuccess(shopid)
end

--@brief	获取公会商店日志（GUILD_GetGuildStoreLogOk = 87）
function ProtocolProcessorStore:parse_GUILD_GetGuildStoreLogOk (logType, createTime, objId, objName, itemId, itemNum)
	-- logType : 0存储日志，1购买日志
	-- createTime : 事件发生时间
	-- objId : 对象ID
	-- objName : 对象名称（BOSS的传空值）
	-- itemId : 物品id
	-- itemNum : 物品数量
	WZLog("ProtocolProcessorStore:parse_GUILD_GetGuildStoreLogOk ")
	WndCommunityShopLog:setLogInfo(VectorToTable(logType), VectorToTable(createTime),VectorToTable(objId), VectorToTable(objName), VectorToTable(itemId), VectorToTable(itemNum))
end


--@brief	获取符文商店信息（RUNE_GetRuneStoreOk = 12）
function ProtocolProcessorStore:parse_RUNE_GetRuneStoreOk(commodityIds, commodityNums, refreshTimes)
	-- commodityIds : 商品ID
	-- itemNums : 物品数量
	-- refreshTimes : 当天刷新次数
	WZLog("ProtocolProcessorStore:parse_RUNE_GetRuneStoreOk")
	if not WndStore or WndStore.m_root == nil then return end
	WndStore:setRuneStoreData(VectorToTable(commodityIds),VectorToTable(commodityNums),refreshTimes)
end

--@brief	购买商品（RUNE_BuyCommodityStatus = 15）
function ProtocolProcessorStore:parse_RUNE_BuyCommodityStatus(status, itemId, itemNum)
	-- status : 购买状态（0成功，1货币不足，2商品不足）
	-- itemId : 获得的物品id
	-- itemNum : 获得的物品数量
	WZLog("ProtocolProcessorStore:parse_RUNE_BuyCommodityStatus ",status)
	if status ~= 0 then
		MsgBoxManager:showTipBox(LocalStrings.SHOP_BUY_FAIL)
		return
	end
	WndStore:storeItemBuySuccess()
end

--@brief	获取装备商店（EQUIP_GetEquipStoreOk = 17）
function ProtocolProcessorStore:parse_EQUIP_GetEquipStoreOk(id, gainNum, itemId, costId, price, leftNum, leftRefreshTimes, totalRefreshTimes, refreshCostId, refreshCostNum)
	-- id : 唯一标志
	-- gainNum : 购买获取数目
	-- itemId : 获取物品的id
	-- costId : 消耗物品的id
	-- price : 价格
	-- leftNum : 剩余可购买数目
	-- leftRefreshTimes : 剩余的刷新次数
	-- totalRefreshTimes : 总的刷新次数
	-- refreshCostId : 刷新商店消耗的物品id
	-- refreshCostNum : 刷新商店消耗的物品数目
	WZLog("ProtocolProcessorStore:parse_EQUIP_GetEquipStoreOk")
	if not WndStore or WndStore.m_root == nil then return end
	WndStore:setEquipStoreData(VectorToTable(id), VectorToTable(gainNum), VectorToTable(itemId),VectorToTable(costId), VectorToTable(price), VectorToTable(leftNum),leftRefreshTimes,totalRefreshTimes,refreshCostId,refreshCostNum)
end

--@brief	装备商店购买（EQUIP_PurchaseOk = 20）
function ProtocolProcessorStore:parse_EQUIP_PurchaseOk(rewardId, num)
	-- rewardId : 奖励物品id
	-- num : 数目
	WZLog("ProtocolProcessorStore:parse_EQUIP_PurchaseOk")
	WndStore:storeItemBuySuccess()
end

--@brief	获取冒险商品列表（MALL_GetArenaStoreOk = 50）
function ProtocolProcessorStore:parse_MALL_GetArenaStoreOk(storeId, store, cost, status, refreshCount, nextRefreshTime)
	-- storeId : 商店ID（购买时使用该ID）
	-- store : 商品,格式[100,2]
	-- cost : 购买消耗，格式[7,100]
	-- status : 状态0未买过，1已买过了
	-- refreshCount : 刷新次数
	-- nextRefreshTime : 下次自动刷新时间(秒数)
	WZLog("ProtocolProcessorStore:parse_MALL_GetArenaStoreOk")
	if not WndStore or WndStore.m_root == nil then return end
    local shopInfo = {}
    for i = 0, storeId:size()-1 do
        local temp = nil
        local prop = {}
        prop.storeId = storeId:get(i)
        temp = SplitTeachTalkStringWithSeparator(store:get(i))
        temp = SplitStringWithSeparator(temp[1],",")
        prop.propId = tonumber(temp[1])
        prop.propNum = tonumber(temp[2])
        temp = SplitTeachTalkStringWithSeparator(cost:get(i))
        temp = SplitStringWithSeparator(temp[1],",")
        prop.costId = tonumber(temp[1])
        prop.costNum = tonumber(temp[2])
        prop.status = status:get(i)
        --物品基础数据
        local key = "id_"..prop.propId
        prop.basicInfo = GDatatab_item[key]
        table.insert(shopInfo,prop)
    end
    WndStore:setAdventureShopData(shopInfo,refreshCount,nextRefreshTime)
end

--@brief	购买冒险商店物品（MALL_BuyArenaStoreOk = 52）
function ProtocolProcessorStore:parse_MALL_BuyArenaStoreOk(store)
	WZLog("ProtocolProcessorStore:parse_MALL_BuyArenaStoreOk")
	WndStore:storeItemBuySuccess()
end

--@brief    获取排位商店（PLAYER_GetTrioRankMatchShopOk = 105）
function ProtocolProcessorStore:parse_PLAYER_GetTrioRankMatchShopOk(id, gainNum, itemId, costId, price, leftNum, totalRefreshTimes)
    -- id : 唯一标志
    -- gainNum : 购买获取数目 
    -- itemId : 获取物品的id
    -- costId : 消耗物品的id
    -- price : 价格
    -- leftNum : 剩余可购买数目
    -- totalRefreshTimes : 总的刷新次数
    WZLog("ProtocolProcessorStore:parse_PLAYER_GetTrioRankMatchShopOk")

    WndStore:setPvpRankShopData(VectorToTable(id), VectorToTable(gainNum), VectorToTable(itemId), VectorToTable(costId), VectorToTable(price), VectorToTable(leftNum), totalRefreshTimes)
end

--@brief    购买排位商店物品（PLAYER_BuyTrioRankMatchOk = 108）
function ProtocolProcessorStore:parse_PLAYER_BuyTrioRankMatchOk()
    WZLog("ProtocolProcessorStore:parse_PLAYER_BuyTrioRankMatchOk")

    WndStore:storeItemBuySuccess()
end
-------------------------------------协议错误处理方法模块--------------------------------------


--@brief	获取公会商店（GUILD_GetGuildStore = 44）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorStore:send_GUILD_GetGuildStore_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorStore:send_GUILD_GetGuildStore_ErrorProcess")
	WndStore:closeLoadingB()
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildStore, nflag, sMessage)
end

--@brief	购买公会商店（GUILD_BuyGuildStore = 46）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorStore:send_GUILD_BuyGuildStore_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorStore:send_GUILD_BuyGuildStore_ErrorProcess")
	WndStore:closeLoadingB()
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_BuyGuildStore, nflag, sMessage)
end

--@brief	刷新公会商店（GUILD_RefreshGuildStore = 48）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorStore:send_GUILD_RefreshGuildStore_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorStore:send_GUILD_RefreshGuildStore_ErrorProcess")
	WndStore:closeLoadingB()
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_RefreshGuildStore, nflag, sMessage)
end


--@brief	获取黑店信息（MALL_GetBlackMarketInfo = 20）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorStore:send_MALL_GetBlackMarketInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorStore:send_MALL_GetBlackMarketInfo_ErrorProcess")
	WndStore:closeLoadingB()
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MALL, Protocol.MALL_GetBlackMarketInfo, nflag, sMessage)
end

--@brief	购买黑店商品（MALL_PurchaseBlackMarket = 23）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorStore:send_MALL_PurchaseBlackMarket_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorStore:send_MALL_PurchaseBlackMarket_ErrorProcess")
	WndStore:closeLoadingB()
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MALL, Protocol.MALL_PurchaseBlackMarket, nflag, sMessage)
	MsgBoxManager:showTipBox(sMessage)
end

--@brief	关闭黑店（MALL_CloseBlackMarket = 25）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorStore:send_MALL_CloseBlackMarket_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorStore:send_MALL_CloseBlackMarket_ErrorProcess")
	WndStore:closeLoadingB()
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MALL, Protocol.MALL_CloseBlackMarket, nflag, sMessage)
end

--@brief	获取竞技商品列表（ROOM_GetArenaStore = 23）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorStore:send_ROOM_GetArenaStore_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorStore:send_ROOM_GetArenaStore_ErrorProcess")
    WndStore:closeLoadingB()
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ROOM , Protocol.ROOM_GetArenaStore, nFlag, sMessage)
end

--@brief	购买竞技商店物品（ROOM_BuyArenaStore = 25）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorStore:send_ROOM_BuyArenaStore_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorStore:send_ROOM_BuyArenaStore_ErrorProcess")
    WndStore:closeLoadingB()
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ROOM, Protocol.ROOM_BuyArenaStore, nFlag, sMessage)
end

--@brief	刷新竞技商店（ROOM_RefreshArenaStore = 27）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorStore:send_ROOM_RefreshArenaStore_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorStore:send_ROOM_RefreshArenaStore_ErrorProcess")
    WndStore:closeLoadingB()
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ROOM, Protocol.ROOM_RefreshArenaStore, nFlag, sMessage)
end

--@brief    获取祈福商店信息（PRAY_GetPrayShop = 17）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorStore:send_PRAY_GetPrayShop_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorStore:send_PRAY_GetPrayShop_ErrorProcess")
    WndStore:closeLoadingB()
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TRATE, Protocol.PRAY_GetPrayShop, nflag, sMessage)
end

--@brief    购买祈福商店物品（PRAY_buy = 19）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorStore:send_PRAY_buy_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorStore:send_PRAY_buy_ErrorProcess")
    WndStore:closeLoadingB()
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TRATE, Protocol.PRAY_buy, nflag, sMessage)
end


--@brief	获取宠物商店（PET_GetPetStore = 18）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorStore:send_PET_GetPetStore_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorStore:send_PET_GetPetStore_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PET, Protocol.PET_GetPetStore, nflag, sMessage)
	WndStore:closeLoadingB()
end

--@brief	购买宠物（PET_PurchasePet = 20））错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorStore:send_PET_PurchasePet_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorStore:send_PET_PurchasePet_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PET, Protocol.PET_PurchasePet, nflag, sMessage)
	WndStore:closeLoadingB()
end

--@brief    获取卡牌信息（CARD_GetCardMes = 1）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorStore:send_CARD_GetCardMes_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorStore:send_CARD_GetCardMes_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_CARD, Protocol.CARD_GetCardMes, nflag, sMessage)
end

--@brief    购买卡牌（CARD_BuyCard = 5）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorStore:send_CARD_BuyCard_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorStore:send_CARD_BuyCard_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_CARD, Protocol.CARD_BuyCard, nflag, sMessage)
    WndStore:resetBuyCardItemTag()
end

--@brief	获取公会商店日志（GUILD_GetGuildStoreLog = 86）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorStore:send_GUILD_GetGuildStoreLog_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorStore:send_GUILD_GetGuildStoreLog_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildStoreLog, nflag, sMessage)
end

--@brief	获取符文商店信息（RUNE_GetRuneStore = 11）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorStore:send_RUNE_GetRuneStore_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorStore:send_RUNE_GetRuneStore_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_RUNE, Protocol.RUNE_GetRuneStore, nflag, sMessage)
end


--@brief	刷新符文商店（RUNE_RefreshRuneStore = 13）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorStore:send_RUNE_RefreshRuneStore_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorStore:send_RUNE_RefreshRuneStore_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_RUNE, Protocol.RUNE_RefreshRuneStore, nflag, sMessage)
end

--@brief	购买商品（RUNE_BuyCommodity = 14）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorStore:send_RUNE_BuyCommodity_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorStore:send_RUNE_BuyCommodity_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_RUNE, Protocol.RUNE_BuyCommodity, nflag, sMessage)
end

--@brief	获取装备商店（EQUIP_GetEquipStore = 16）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorStore:send_EQUIP_GetEquipStore_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorStore:send_EQUIP_GetEquipStore_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_EQUIP, Protocol.EQUIP_GetEquipStore, nflag, sMessage)
end

--@brief	刷新装备商店（EQUIP_RefreshEquipStore = 18）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorStore:send_EQUIP_RefreshEquipStore_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorStore:send_EQUIP_RefreshEquipStore_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_EQUIP, Protocol.EQUIP_RefreshEquipStore, nflag, sMessage)
end


--@brief	装备商店购买（EQUIP_Purchase = 19）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorStore:send_EQUIP_Purchase_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorStore:send_EQUIP_Purchase_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_EQUIP, Protocol.EQUIP_Purchase, nflag, sMessage)
end

--@brief	获取冒险商品列表（MALL_GetArenaStore = 49）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorStore:send_MALL_GetArenaStore_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorStore:send_MALL_GetArenaStore_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MALL, Protocol.MALL_GetArenaStore, nflag, sMessage)
end

--@brief	刷新冒险商店（MALL_RefreshArenaStore = 53）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorStore:send_MALL_RefreshArenaStore_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorStore:send_MALL_RefreshArenaStore_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MALL, Protocol.MALL_RefreshArenaStore, nflag, sMessage)
end

--@brief	购买冒险商店物品（MALL_BuyArenaStore = 51）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorStore:send_MALL_BuyArenaStore_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorStore:send_MALL_BuyArenaStore_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MALL, Protocol.MALL_BuyArenaStore, nflag, sMessage)
end

--@brief    刷新卡牌商店（CARD_RefreshCardStore = 13）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorStore:send_CARD_RefreshCardStore_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorStore:send_CARD_RefreshCardStore_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_CARD, Protocol.CARD_RefreshCardStore, nflag, sMessage)
end

--@brief    获取排位商店（PLAYER_GetTrioRankMatchShop = 104）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorStore:send_PLAYER_GetTrioRankMatchShop_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorStore:send_PLAYER_GetTrioRankMatchShop_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_GetTrioRankMatchShop, nflag, sMessage)
end

--@brief    刷新排位商店（成功返回105）（PLAYER_RefreshTrioRankMatchShop = 106）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorStore:send_PLAYER_RefreshTrioRankMatchShop_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorStore:send_PLAYER_RefreshTrioRankMatchShop_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_RefreshTrioRankMatchShop, nflag, sMessage)
end

--@brief    购买排位商店物品（PLAYER_BuyTrioRankMatch = 107）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorStore:send_PLAYER_BuyTrioRankMatch_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorStore:send_PLAYER_BuyTrioRankMatch_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_BuyTrioRankMatch, nflag, sMessage)
end