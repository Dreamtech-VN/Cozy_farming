--ProtocolProcessorWndShop.lua
--@brief	商城模块协议
--@date  	2013/12/23
--@author 	SunShanshan


ProtocolProcessorWndShop = ProtocolProcessorBase:new()

-------------------------------------公有方法模块--------------------------------------

--@brief	注册协议组所有协议
function ProtocolProcessorWndShop:regAll()
	WZLog("ProtocolProcessorWndShop:regAll")
    --@brief	商城商品（MALL_MallList = 2）
    self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_MallList, "ProtocolProcessorWndShop:parse_MALL_MallList", "vivivsvbvbvbvnvsvivivsvivbvivsvsvivtvbvi")
	
	--@brief	购买物品结果（MALL_BuyResult = 4）
	self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_BuyResult, "ProtocolProcessorWndShop:parse_MALL_BuyResult", "bss")
	--@brief	更新商品剩余次数（MALL_UpdateMall = 5）
	self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_UpdateMall, "ProtocolProcessorWndShop:parse_MALL_UpdateMall", "vivi")
    --@brief    购买限制物品结果（MALL_BuyLimitedItemOK = 7）
    self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_BuyLimitedItemOK, "ProtocolProcessorWndShop:parse_MALL_BuyLimitedItemOK", "vivitii")
    --@brief    限制物品次数结果（MALL_GetUpdateLimitedOK = 9）
    self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_GetUpdateLimitedOK, "ProtocolProcessorWndShop:parse_MALL_GetUpdateLimitedOK", "tii")
    --@brief    限制物品时间（MALL_GetLimitedTimeOK = 11）
    self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_GetLimitedTimeOK, "ProtocolProcessorWndShop:parse_MALL_GetLimitedTimeOK", "tii")
    --@brief	服装商品列表（MALL_GetMallListBySexOK = 13）
    self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_GetMallListBySexOK, "ProtocolProcessorWndShop:parse_MALL_GetMallListBySexOK", "vivivsvbvbvbvnvsvivivsvivbvivsvsvivt")
    --@brief	获取操作对象（MALL_GetOperateFriendOK = 15）
    self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_GetOperateFriendOK, "ProtocolProcessorWndShop:parse_MALL_GetOperateFriendOK", "vivsvivtvivivivivi")
    --@brief	商品操作（MALL_MallOperateOK = 17）
    self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_MallOperateOK, "ProtocolProcessorWndShop:parse_MALL_MallOperateOK", "")
    --@brief	更新商品剩余次数（MALL_UpdateMallBySex = 18）
    self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_UpdateMallBySex, "ProtocolProcessorWndShop:parse_MALL_UpdateMallBySex", "vivi")
	--@brief	推送玩家黑店激活（MALL_PushBlackMarketActivate = 22）
	self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_PushBlackMarketActivate, "ProtocolProcessorWndShop:parse_MALL_PushBlackMarketActivate", "")
	--@brief	返回热销商品列表（MALL_GetHotMallListOk = 28）
	self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_GetHotMallListOk, "ProtocolProcessorWndShop:parse_MALL_GetHotMallListOk", "vivivbvbvnvsvivivsvivi")
	--@brief	获取限购列表（MALL_GetSpecialOfferOk = 30）
	self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_GetSpecialOfferOk, "ProtocolProcessorWndShop:parse_MALL_GetSpecialOfferOk", "vivivivivivi")
    --@brief	获取商城抽奖列表信息（MALL_GetLuckDrawInfoOk = 32））
    self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_GetLuckDrawInfoOk, "ProtocolProcessorWndShop:parse_MALL_GetLuckDrawInfoOk", "ivivivbivivi")
    --@brief	商城抽奖（MALL_LuckDrawResult = 34）
    self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_LuckDrawResult, "ProtocolProcessorWndShop:parse_MALL_LuckDrawResult", "ivivii")
    --@brief	获取折扣商贩活动状态（MALL_GetDiscountStoreStatusOk = 36）
    self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_GetDiscountStoreStatusOk, "ProtocolProcessorWndShop:parse_MALL_GetDiscountStoreStatusOk", "t")
    --@brief	获取折扣商贩信息（MALL_GetDiscountStoreOk = 38）
    self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_GetDiscountStoreOk, "ProtocolProcessorWndShop:parse_MALL_GetDiscountStoreOk", "tvivivivivivivissi")
    --@brief	折扣商贩贿赂（MALL_DiscountStoreBriberyOk = 40）
    self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_DiscountStoreBriberyOk, "ProtocolProcessorWndShop:parse_MALL_DiscountStoreBriberyOk", "")
    --@brief	折扣商贩购买（MALL_DiscountStorePurchaseOk = 42）
    self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_DiscountStorePurchaseOk, "ProtocolProcessorWndShop:parse_MALL_DiscountStorePurchaseOk", "ii")
    --@brief	折扣商贩刷新（MALL_DiscountStoreRefreshOk = 44）
    self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_DiscountStoreRefreshOk, "ProtocolProcessorWndShop:parse_MALL_DiscountStoreRefreshOk", "")

	

    --@brief	获取商城列表（MALL_GetMallList = 1）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_GetMallList, "ProtocolProcessorWndShop:send_MALL_GetMallList_ErrorProcess", "is" )
	--@brief	购买物品（MALL_BuyItems = 3）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_BuyItems, "ProtocolProcessorWndShop:send_MALL_BuyItems_ErrorProcess", "is" )
    --@brief    购买限制物品（MALL_BuyLimitedItem = 6）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_BuyLimitedItem, "ProtocolProcessorWndShop:send_MALL_BuyLimitedItem_ErrorProcess", "is" )
    --@brief    限制物品次数（MALL_GetUpdateLimited = 8）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_GetUpdateLimited, "ProtocolProcessorWndShop:send_MALL_GetUpdateLimited_ErrorProcess", "is" )
    --@brief    购买限制物品时间（MALL_GetLimitedTime = 10）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_GetLimitedTime, "ProtocolProcessorWndShop:send_MALL_GetLimitedTime_ErrorProcess", "is" )
    --@brief	服装商品列表（MALL_GetMallListBySex = 12）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_GetMallListBySex , "ProtocolProcessorWndShop:send_MALL_GetMallListBySex_ErrorProcess", "is" )
    --@brief	获取操作对象（MALL_GetOperateFriend = 14）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_GetOperateFriend, "ProtocolProcessorWndShop:send_MALL_GetOperateFriend_ErrorProcess", "is" )
    --@brief	商品操作（MALL_MallOperate = 16）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_MallOperate, "ProtocolProcessorWndShop:send_MALL_MallOperate_ErrorProcess", "is" )
    --@brief	更新限购物品（MALL_RequestUpdateMall = 19）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_RequestUpdateMall, "ProtocolProcessorWndShop:send_MALL_RequestUpdateMall_ErrorProcess", "is" )
	--@brief	获取热销商品列表（MALL_GetHotMallList = 27）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_GetHotMallList, "ProtocolProcessorWndShop:send_MALL_GetHotMallList_ErrorProcess", "is" )	
	--@brief	获取限购列表（MALL_GetSpecialOffer = 29）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_GetSpecialOffer, "ProtocolProcessorWndShop:send_MALL_GetSpecialOffer_ErrorProcess", "is" )
    --@brief	获取商城抽奖列表信息（MALL_GetLuckDrawInfo = 31）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_GetLuckDrawInfo, "ProtocolProcessorWndShop:send_MALL_GetLuckDrawInfo_ErrorProcess", "is" )
    --@brief	商城抽奖（MALL_LuckDraw = 33）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_LuckDraw, "ProtocolProcessorWndShop:send_MALL_LuckDraw_ErrorProcess", "is" )
    --@brief	获取折扣商贩活动状态（MALL_GetDiscountStoreStatus = 35）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_GetDiscountStoreStatus, "ProtocolProcessorWndShop:send_MALL_GetDiscountStoreStatus_ErrorProcess", "is" )
    --@brief	获取折扣商贩信息（MALL_GetDiscountStore = 37）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_GetDiscountStore, "ProtocolProcessorWndShop:send_MALL_GetDiscountStore_ErrorProcess", "is" )
    --@brief	折扣商贩贿赂（MALL_DiscountStoreBribery = 39）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_DiscountStoreBribery, "ProtocolProcessorWndShop:send_MALL_DiscountStoreBribery_ErrorProcess", "is" )
    --@brief	折扣商贩购买（MALL_DiscountStorePurchase = 41）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_DiscountStorePurchase, "ProtocolProcessorWndShop:send_MALL_DiscountStorePurchase_ErrorProcess", "is" )
    --@brief	折扣商贩刷新（MALL_DiscountStoreRefresh = 43）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_DiscountStoreRefresh, "ProtocolProcessorWndShop:send_MALL_DiscountStoreRefresh_ErrorProcess", "is" )
	
end

--@brief	反注册协议组所有协议
function ProtocolProcessorWndShop:unregAll()
	WZLog("ProtocolProcessorWndShop:unregAll")
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief	获取商城列表（MALL_GetMallList = 1）
function ProtocolProcessorWndShop:send_MALL_GetMallList( )
	WZLog("send_MALL_GetMallList")
	local sender = Protocol:getSender( Protocol.MAIN_MALL, Protocol.MALL_GetMallList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	购买物品（MALL_BuyItems = 3）
function ProtocolProcessorWndShop:send_MALL_BuyItems(count, mallId, paytype, buyType, sex, targetPlayerId)
	WZLog("send_MALL_BuyItems", buyType)
	local sender = Protocol:getSender( Protocol.MAIN_MALL, Protocol.MALL_BuyItems )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInts( count )	-- 商城数量，时效装备是对应序号
	sender:writeInts( mallId )	-- 商城id
	sender:writeInt( paytype )	-- 支付方式
    sender:writeByte( buyType ) -- 购买方式
    sender:writeByte( sex or 9 ) -- 孩子物品传性别（其余传9）
	sender:writeInt( targetPlayerId or 0)	-- 给孩子时装续费时传指定玩家Id，其它传0
	SendProtocol(sender,false) --true:showLoading
end

--@brief    购买限制物品（MALL_BuyLimitedItem = 6）
function ProtocolProcessorWndShop:send_MALL_BuyLimitedItem(limitItem, num )
    WZLog("send_MALL_BuyLimitedItem")
    local sender = Protocol:getSender( Protocol.MAIN_MALL, Protocol.MALL_BuyLimitedItem )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeByte( limitItem )   -- 限制类型1、金币，2、体力
    sender:writeInt( num )  -- 购买次数
    SendProtocol(sender,false) --true:showLoading
end

--@brief    限制物品次数（MALL_GetUpdateLimited = 8）
function ProtocolProcessorWndShop:send_MALL_GetUpdateLimited(limitItem )
    WZLog("send_MALL_GetUpdateLimited")
    local sender = Protocol:getSender( Protocol.MAIN_MALL, Protocol.MALL_GetUpdateLimited )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeByte( limitItem )   -- 限制类型1、金币，2、体力
    SendProtocol(sender,false) --true:showLoading
end


--@brief    购买限制物品时间（MALL_GetLimitedTime = 10）
function ProtocolProcessorWndShop:send_MALL_GetLimitedTime(limitItem )
    WZLog("send_MALL_GetLimitedTime")
    local sender = Protocol:getSender( Protocol.MAIN_MALL, Protocol.MALL_GetLimitedTime )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeByte( limitItem )   -- 限制类型1、金币，2、体力
    SendProtocol(sender,false) --true:showLoading
end

--@brief	服装商品列表（MALL_GetMallListBySex = 12）
function ProtocolProcessorWndShop:send_MALL_GetMallListBySex (sex )
    WZLog("send_MALL_GetMallListBySex ")
    local sender = Protocol:getSender( Protocol.MAIN_MALL, Protocol.MALL_GetMallListBySex  )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeByte( sex )	-- 性别（0为男性，1为女性）
    SendProtocol(sender,false) --true:showLoading
end

--@brief	获取操作对象（MALL_GetOperateFriend = 14）
function ProtocolProcessorWndShop:send_MALL_GetOperateFriend(operateType, sex )
    WZLog("send_MALL_GetOperateFriend")
    local sender = Protocol:getSender( Protocol.MAIN_MALL, Protocol.MALL_GetOperateFriend )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeByte( operateType )	-- 1为赠送，2为索要
    sender:writeByte( sex )	-- 1为赠送，2为索要
    SendProtocol(sender,false) --true:showLoading
end

--@brief	商品操作（MALL_MallOperate = 16）
function ProtocolProcessorWndShop:send_MALL_MallOperate(operateType, mallId, count, operatePlayerId, message )
    WZLog("send_MALL_MallOperate")
    local sender = Protocol:getSender( Protocol.MAIN_MALL, Protocol.MALL_MallOperate )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeByte( operateType )	-- 1为赠送，2为索要
    sender:writeInts( mallId )	-- 商品Id
    sender:writeInts( count )	-- 物品Id
    sender:writeInt( operatePlayerId )	-- 操作对象Id
    sender:writeString( message )	-- 留言
    SendProtocol(sender,false) --true:showLoading
end

--@brief	更新限购物品（MALL_RequestUpdateMall = 19）
function ProtocolProcessorWndShop:send_MALL_RequestUpdateMall( )
    WZLog("send_MALL_RequestUpdateMall")
    local sender = Protocol:getSender( Protocol.MAIN_MALL, Protocol.MALL_RequestUpdateMall )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief	获取热销商品列表（MALL_GetHotMallList = 27）
function ProtocolProcessorWndShop:send_MALL_GetHotMallList( )
	WZLog("send_MALL_GetHotMallList")
	local sender = Protocol:getSender( Protocol.MAIN_MALL, Protocol.MALL_GetHotMallList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取限购列表（MALL_GetSpecialOffer = 29）
function ProtocolProcessorWndShop:send_MALL_GetSpecialOffer( )
	WZLog("send_MALL_GetSpecialOffer")
	local sender = Protocol:getSender( Protocol.MAIN_MALL, Protocol.MALL_GetSpecialOffer )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取商城抽奖列表信息（MALL_GetLuckDrawInfo = 31）
function ProtocolProcessorWndShop:send_MALL_GetLuckDrawInfo(type )
	WZLog("send_MALL_GetLuckDrawInfo")
	local sender = Protocol:getSender( Protocol.MAIN_MALL, Protocol.MALL_GetLuckDrawInfo )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( type )	-- 1蓝钻抽奖，2粉钻抽奖
	SendProtocol(sender,false) --true:showLoading
end

--@brief	商城抽奖（MALL_LuckDraw = 33）
function ProtocolProcessorWndShop:send_MALL_LuckDraw(type, drawNum )
	WZLog("send_MALL_LuckDraw", type, drawNum)
	local sender = Protocol:getSender( Protocol.MAIN_MALL, Protocol.MALL_LuckDraw )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( type )	-- 1蓝钻抽奖，2粉钻抽奖
	sender:writeInt( drawNum )	-- 抽奖次数
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取折扣商贩活动状态（MALL_GetDiscountStoreStatus = 35）
function ProtocolProcessorWndShop:send_MALL_GetDiscountStoreStatus( )
	WZLog("send_MALL_GetDiscountStoreStatus")
	local sender = Protocol:getSender( Protocol.MAIN_MALL, Protocol.MALL_GetDiscountStoreStatus )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取折扣商贩信息（MALL_GetDiscountStore = 37）
function ProtocolProcessorWndShop:send_MALL_GetDiscountStore( )
	WZLog("send_MALL_GetDiscountStore")
	local sender = Protocol:getSender( Protocol.MAIN_MALL, Protocol.MALL_GetDiscountStore )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	折扣商贩贿赂（MALL_DiscountStoreBribery = 39）
function ProtocolProcessorWndShop:send_MALL_DiscountStoreBribery( )
	WZLog("send_MALL_DiscountStoreBribery")
	local sender = Protocol:getSender( Protocol.MAIN_MALL, Protocol.MALL_DiscountStoreBribery )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	折扣商贩购买（MALL_DiscountStorePurchase = 41）
function ProtocolProcessorWndShop:send_MALL_DiscountStorePurchase(id )
	WZLog("send_MALL_DiscountStorePurchase")
	local sender = Protocol:getSender( Protocol.MAIN_MALL, Protocol.MALL_DiscountStorePurchase )
	if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( id )  
	SendProtocol(sender,false) --true:showLoading
end

--@brief	折扣商贩刷新（MALL_DiscountStoreRefresh = 43）
function ProtocolProcessorWndShop:send_MALL_DiscountStoreRefresh( )
	WZLog("send_MALL_DiscountStoreRefresh")
	local sender = Protocol:getSender( Protocol.MAIN_MALL, Protocol.MALL_DiscountStoreRefresh )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

-------------------------------------服务器到客户端协议回调方法模块--------------------------------------
--@brief	商城商品（MALL_MallList = 2）
function ProtocolProcessorWndShop:parse_MALL_MallList(id, itemId, itemName, isHot, isNew, isVip, discount, mainType, moneyId, floorPrice, agingPrice, limitLeave,isOnSale,transaction,ad,newad, moneyId2, suit, isPromotion, discountTime)
    -- id : 商城ID
    -- itemId : 物品id
    -- itemName : 物品名称
    -- isHot : 是否热卖
    -- isNew : 是否新品
    -- isVip : 是否Vip
    -- discount : 折扣 万分比 10000不打折
    -- mainType : 大类 格式：1,2
    -- subType : 小类
    -- moneyId : 支付货币id
    -- floorPrice : 底价
    -- agingPrice : 时效价格 {"1":"3"}json格式  ""为使用数量价格
    -- limitLeave : 剩余购买数量， -1 为不限购
    WZLog("ProtocolProcessorWndShop:parse_MALL_MallList------------",
        id:size(), itemId:size(), itemName:size(), isHot:size(), isNew:size(), isVip:size(), discount:size(), mainType:size(),
        moneyId:size(), floorPrice:size(), agingPrice:size(),ad:size(),newad:size(), moneyId2:size())
    CacheCenter:setShopItems(id, itemId, itemName, isHot, isNew, isVip, discount, mainType, moneyId, floorPrice, agingPrice, limitLeave,isOnSale,transaction,ad,newad, moneyId2, suit, isPromotion, discountTime)
end

--@brief	购买物品结果（MALL_BuyResult = 4）
function ProtocolProcessorWndShop:parse_MALL_BuyResult(buyResult, content, cost)
	-- buyResult : 购买成功还是失败
	-- content : 结果内容
	-- cost : 花费掉多少道具，json格式
	WZLog("ProtocolProcessorWndShop:parse_MALL_BuyResult")
	if buyResult == true then
        -- 购买单个商品时调用
		if WndPurchase and WndPurchase.buyFlag then
            WndPurchase.buyFlag = false
			WndPurchase:BuyResult()
        end

        -- 保存形象时调用
		if WndBuy and WndBuy.buyFlag then
            g_tTempItemForLaterShow = {}
            WndBuy.buyFlag = false
			WndBuy:BuyResult()
		end

		--衣橱界面，购买后自动穿上
		if Wndwardrobe.m_root ~= nil then
			Wndwardrobe:onBatchCall()
		end

		if WndShop.m_root ~= nil and WndShop.leftIndex == 1 then
			-- 获取热销信息
			ProtocolProcessorWndShop:send_MALL_GetHotMallList( )
		end

        if WndSpecifyActivity.m_root ~= nil then 
            WndSpecifyActivity:buyResultType2()
        end
        
        if WndVipGift and WndVipGift.m_root then 
            WndVipGift:buyResult()
        end

		--更新特价限购
		WndShop:_updateLeft4()

		MsgBoxManager:showTipBox(LocalStrings.SHOP_BUY_SUCCESS)
		SoundManager:playEffectSound(SoundDefine.E_S_KILL_GOUMAICHENGGONG)
	else
		MsgBoxManager:showTipBox(LocalStrings.SHOP_BUY_FAIL, nil, nil, nil, nil)
    end
    --弹穿上或打开提示窗口
    pushEquipInList()
    g_bIsShowWndDressUp = true
end

--@brief	更新商品剩余次数（MALL_UpdateMall = 5）
function ProtocolProcessorWndShop:parse_MALL_UpdateMall(id, limitLeave)
	-- id : 商城ID
	-- limitLeave : 剩余购买数量，-1 为不限购
    WZLog("-------------------------------------------55555555555------------------------")
	WZLog("ProtocolProcessorWndShop:parse_MALL_UpdateMall")
	WZLog(Serialize(VectorToTable(id)),Serialize(VectorToTable(limitLeave)))
	CacheCenter:setShopItemsLimitLeave(VectorToTable(id), VectorToTable(limitLeave))
end

--@brief    购买限制物品结果（MALL_BuyLimitedItemOK = 7）
function ProtocolProcessorWndShop:parse_MALL_BuyLimitedItemOK(addNum, multiple, limitItem, costCurDay, returnNum)
    -- addNum : 增加数量
    -- multiple : 爆击倍数
    -- limitItem : 限制类型1、金币，2体力
    -- costCurDay : 当天消耗（不包括已经返还的部分）
    -- returnNum : 返还数量（0：表示没有返还）
    WZLog("ProtocolProcessorWndShop:parse_MALL_BuyLimitedItemOK", returnNum)

    WndBuyActivity:setBuyResultData(addNum, multiple, limitItem, costCurDay, returnNum)
end

--@brief    限制物品次数结果（MALL_GetUpdateLimitedOK = 9）
function ProtocolProcessorWndShop:parse_MALL_GetUpdateLimitedOK(limitItem, buyTimes, costCurDay)
    -- limitItem : 限制类型，1、金币，2、体力
    -- buyTimes : 购买次数
    -- costCurDay : 当天消耗（不包括已经返还的部分）
    WZLog("ProtocolProcessorWndShop:parse_MALL_GetUpdateLimitedOK")

    WndBuyActivity:getDataFromServer(limitItem, buyTimes, costCurDay)
end


--@brief    限制物品时间（MALL_GetLimitedTimeOK = 11）
function ProtocolProcessorWndShop:parse_MALL_GetLimitedTimeOK(limitItem, leaveTime, fullTime)
    -- limitItem : 限制类型，1、金币，2、体力
    -- leaveTime : 下次更新剩余时间（秒）
    -- fullTime : 满体力时间（秒）
    WZLog("ProtocolProcessorWndShop:parse_MALL_GetLimitedTimeOK")

    WndBuyActivity:setLeftTime(limitItem, leaveTime, fullTime)
end

--@brief	服装商品列表（MALL_GetMallListBySexOK = 13）
function ProtocolProcessorWndShop:parse_MALL_GetMallListBySexOK(id, itemId, itemName, isHot, isNew, isVip, discount, mainType, moneyId, floorPrice, price, limitLeave, isOnSale,transaction,ad,newad, moneyId2, suit)
    -- id : 商城ID
    -- itemId : 物品id
    -- itemName : 物品名称
    -- isHot : 是否热卖
    -- isNew : 是否新品
    -- isVip : 是否Vip
    -- discount : 折扣 万分比 10000不打折
    -- mainType : 大类 格式：{"1":"2","2":"3"} {大类：小类}
    -- moneyId : 支付货币id
    -- floorPrice : 底价
    -- price : 价格 {"1":"3"}json格式
    -- limitLeave : 剩余购买数量， -1 为不限购
    -- isOnSale : 是否上架，true为上架，false为不上架
    -- moneyId2 : 货币id2
    WZLog("ProtocolProcessorWndShop:parse_MALL_GetMallListBySexOK", moneyId2:size())
    WndShop:updateShopItems(id, itemId, itemName, isHot, isNew, isVip, discount, mainType, moneyId, floorPrice, price, limitLeave,isOnSale,transaction,ad,newad, moneyId2, suit)
end

--@brief	获取操作对象（MALL_GetOperateFriendOK = 15）
function ProtocolProcessorWndShop:parse_MALL_GetOperateFriendOK(playerId, playerName, level, sex, faceItemId, headItemId, friendNum,vipLv,headColor)
    -- playerId : 好友Id
    -- playerName : 好友名称
    -- level : 好友等级
    -- sex : 好友性别，0是男，1是女
    -- faceItemId : 脸道具id,没有为0
    -- headItemId : 头道具id，没有为0
    -- friendNum : 好友度
    WZLog("ProtocolProcessorWndShop:parse_MALL_GetOperateFriendOK")
    WndShopGiven:setFriendData(playerId, playerName, level, sex, faceItemId, headItemId, friendNum,vipLv,headColor)
end

--@brief	商品操作（MALL_MallOperateOK = 17）
function ProtocolProcessorWndShop:parse_MALL_MallOperateOK()
    WZLog("ProtocolProcessorWndShop:parse_MALL_MallOperateOK")
    WndShopGiven:handleSuccess()
end


--@brief	更新商品剩余次数（MALL_UpdateMallBySex = 18）
function ProtocolProcessorWndShop:parse_MALL_UpdateMallBySex(id, limitLeave)
    -- id : 商城ID
    -- limitLeave : 剩余购买数量，-1 为不限购
    WZLog("ProtocolProcessorWndShop:parse_MALL_UpdateMallBySex")
    -- 限购信息共用
    CacheCenter:setShopItemsLimitLeave(VectorToTable(id), VectorToTable(limitLeave))
    WndShop:updateShopItemsLimitLeave(VectorToTable(id), VectorToTable(limitLeave))
end

--@brief	推送玩家黑店激活（MALL_PushBlackMarketActivate = 22）
function ProtocolProcessorWndShop:parse_MALL_PushBlackMarketActivate()
	WZLog("ProtocolProcessorWndShop:parse_MALL_PushBlackMarketActivate")
	if SceneCopy.m_root ~= nil and WndTeamCopySweep and not WndTeamCopySweep.m_bSweeping and WndSweepResult.m_root == nil  then
		local wnd = WndGangsterInnOwner:createElement()
    	WindowManager:addWindow(wnd, WndGangsterInnOwner, false)
	elseif WndMultiCopy.m_root and WndTeamCopySweep.m_bSweeping then
		WndGangsterInn.m_bFirstOpen = true
    elseif not TeachGroup1:isInTeach() then
        WndGangsterInn.m_bFirstOpen = true
	end
end

--@brief	返回热销商品列表（MALL_GetHotMallListOk = 28）
function ProtocolProcessorWndShop:parse_MALL_GetHotMallListOk(id, itemId, isNew, isVip, discount, mainType, moneyId, floorPrice, price, limitLeave, moneyId2)
	-- id : 商城ID
	-- itemId : 物品id
	-- isNew : 是否新品
	-- isVip : 是否Vip
	-- discount : 折扣 万分比 10000不打折
	-- mainType : 大类 格式：{"1":"2","2":"3"} {大类：小类}
    -- moneyId : 支付货币id
    -- floorPrice : 底价
    -- price : 价格 {"1":"3"}json格式
    -- limitLeave : 剩余购买数量， -1 为不限购
	-- moneyId2 : 支付货币id2
	WZLog("ProtocolProcessorWndShop:parse_MALL_GetHotMallListOk",id:size())
	WndShop:updateHotShopItems(id, itemId, isNew, isVip, discount, mainType, moneyId, floorPrice, price, limitLeave, moneyId2)
end

--@brief	获取限购列表（MALL_GetSpecialOfferOk = 30）
function ProtocolProcessorWndShop:parse_MALL_GetSpecialOfferOk(mallId, itemId, moneyId, oldPrice, newPrice, limitLeave)
	-- mallId : 商城ID
	-- itemId : 物品id
	-- oldPrice : 原价
	-- newPrice : 折扣价
	-- limitLeave : 剩余购买数量
	WZLog("ProtocolProcessorWndShop:parse_MALL_GetSpecialOfferOk", mallId:size(),limitLeave:size())
	WndShop:setLeft4Data( VectorToTable(mallId), VectorToTable(itemId), VectorToTable(moneyId), VectorToTable(oldPrice), VectorToTable(newPrice), VectorToTable(limitLeave))
end

--@brief	获取商城抽奖列表信息（MALL_GetLuckDrawInfoOk = 32））
function ProtocolProcessorWndShop:parse_MALL_GetLuckDrawInfoOk(nType, itemId, itemNum, rare, luckValue, drawNum, drawPrice)
	-- type : 1蓝钻抽奖，2粉钻抽奖
	-- itemId : 物品id
	-- rare : 是否稀有物品
	-- luckValue : 当前幸运值
	-- drawNum : 抽奖次数
	-- drawPrice : 抽奖价格
	WZLog("ProtocolProcessorWndShop:parse_MALL_GetLuckDrawInfoOk",drawNum:size())
	--WndShop:setData7(nType, VectorToTable(itemId), VectorToTable(itemNum), VectorToTable(rare), luckValue, VectorToTable(drawNum), VectorToTable(drawPrice))
	WndShopLottery:setData7(nType, VectorToTable(itemId), VectorToTable(itemNum), VectorToTable(rare), luckValue, VectorToTable(drawNum), VectorToTable(drawPrice))
end

--@brief	商城抽奖（MALL_LuckDrawResult = 34）
function ProtocolProcessorWndShop:parse_MALL_LuckDrawResult(nType, itemId, itemNum, luckValue)
	-- type : 1蓝钻抽奖，2粉钻抽奖
	-- itemId : 物品id
	-- itemNum : 物品数量
	-- luckValue : 当前幸运值
	WZLog("ProtocolProcessorWndShop:parse_MALL_LuckDrawResult")
	WndShopLottery:showLotteryResult(nType, VectorToTable(itemId), VectorToTable(itemNum), luckValue)
end

--@brief	获取折扣商贩活动状态（MALL_GetDiscountStoreStatusOk = 36）
function ProtocolProcessorWndShop:parse_MALL_GetDiscountStoreStatusOk(status)
	-- status : 活动状态*(1:开启,2:关闭)
	WZLog("ProtocolProcessorWndShop:parse_MALL_GetDiscountStoreStatusOk")
end

--@brief	获取折扣商贩信息（MALL_GetDiscountStoreOk = 38）
function ProtocolProcessorWndShop:parse_MALL_GetDiscountStoreOk(status, id, gainNum, itemId, costId, price, discount, leftNum, startDateStr, endDateStr, countdown)
	-- status : 状态(0:初始化,1:已贿赂)
	-- id : 唯一标志
	-- gainNum : 购买获取数目
	-- itemId : 获取物品的id
	-- costId : 消耗物品的id
	-- price : 价格
	-- discount : 折扣(0为无折扣)
	-- leftNum : 剩余可购买数目
	-- startDateStr : MM-dd
	-- endDateStr : MM-dd
	WZLog("ProtocolProcessorWndShop:parse_MALL_GetDiscountStoreOk")
	WndRebate:setData(status, VectorToTable(id), VectorToTable(gainNum), VectorToTable(itemId), VectorToTable(costId), VectorToTable(price), VectorToTable(discount), VectorToTable(leftNum), startDateStr, endDateStr, countdown)

	WndApartmentAct:setData10(status, VectorToTable(id), VectorToTable(gainNum), VectorToTable(itemId), VectorToTable(costId), VectorToTable(price), VectorToTable(discount), VectorToTable(leftNum), startDateStr, endDateStr, countdown)
end

--@brief	折扣商贩贿赂（MALL_DiscountStoreBriberyOk = 40）
function ProtocolProcessorWndShop:parse_MALL_DiscountStoreBriberyOk()
	WZLog("ProtocolProcessorWndShop:parse_MALL_DiscountStoreBriberyOk")
end

--@brief	折扣商贩购买（MALL_DiscountStorePurchaseOk = 42）
function ProtocolProcessorWndShop:parse_MALL_DiscountStorePurchaseOk(gainItemId, gainNum)
	-- gainItemId : 获取商品id
	-- gainNum : 获取数目
	WZLog("ProtocolProcessorWndShop:parse_MALL_DiscountStorePurchaseOk")
	WndRewardShow:showById({gainItemId},{gainNum})
	ProtocolProcessorWndShop:send_MALL_GetDiscountStore( )
end

--@brief	折扣商贩刷新（MALL_DiscountStoreRefreshOk = 44）
function ProtocolProcessorWndShop:parse_MALL_DiscountStoreRefreshOk()
	WZLog("ProtocolProcessorWndShop:parse_MALL_DiscountStoreRefreshOk")
end
-------------------------------------协议错误处理方法模块--------------------------------------
--@brief	获取商城列表（MALL_GetMallList = 1）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndShop:send_MALL_GetMallList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndShop:send_MALL_GetMallList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MALL, Protocol.MALL_GetMallList, nflag, sMessage)
end

--@brief	购买物品（MALL_BuyItems = 3）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndShop:send_MALL_BuyItems_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndShop:send_MALL_BuyItems_ErrorProcess")
    WndBuy:closeLoading()
    WndPurchase:closeLoading()
    --MsgBoxManager:showTipBox(sMessage)
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MALL, Protocol.MALL_BuyItems, nflag, sMessage)
end

--@brief    购买限制物品（MALL_BuyLimitedItem = 6）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndShop:send_MALL_BuyLimitedItem_ErrorProcess(nFlag, sMessage)
    WndBuy:closeLoading()
    WndPurchase:closeLoading()
    WZLog("ProtocolProcessorWndShop:send_MALL_BuyLimitedItem_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MALL, Protocol.MALL_BuyLimitedItem, nflag, sMessage)
end

--@brief    限制物品次数（MALL_GetUpdateLimited = 8）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndShop:send_MALL_GetUpdateLimited_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndShop:send_MALL_GetUpdateLimited_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MALL, Protocol.MALL_GetUpdateLimited, nflag, sMessage)
end

--@brief    购买限制物品时间（MALL_GetLimitedTime = 10）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndShop:send_MALL_GetLimitedTime_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndShop:send_MALL_GetLimitedTime_ErrorProcess")
    WndBuy:closeLoading()
    WndPurchase:closeLoading()
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MALL, Protocol.MALL_GetLimitedTime, nflag, sMessage)
end

--@brief	服装商品列表（MALL_GetMallListBySex = 12）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndShop:send_MALL_GetMallListBySex_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndShop:send_MALL_GetMallListBySex _ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MALL, Protocol.MALL_GetMallListBySex , nflag, sMessage)
end

--@brief	获取操作对象（MALL_GetOperateFriend = 14）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndShop:send_MALL_GetOperateFriend_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndShop:send_MALL_GetOperateFriend_ErrorProcess")
    WndShopGiven:errorProHandle()
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MALL, Protocol.MALL_GetOperateFriend, nflag, sMessage)
end

--@brief	商品操作（MALL_MallOperate = 16）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndShop:send_MALL_MallOperate_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndShop:send_MALL_MallOperate_ErrorProcess")
    WndShopGiven:errorProHandle()
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MALL, Protocol.MALL_MallOperate, nflag, sMessage)
end

--@brief	更新限购物品（MALL_RequestUpdateMall = 19）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndShop:send_MALL_RequestUpdateMall_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndShop:send_MALL_RequestUpdateMall_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MALL, Protocol.MALL_RequestUpdateMall, nflag, sMessage)
end

--@brief	获取热销商品列表（MALL_GetHotMallList = 27）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndShop:send_MALL_GetHotMallList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndShop:send_MALL_GetHotMallList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MALL, Protocol.MALL_GetHotMallList, nflag, sMessage)
end

--@brief	获取限购列表（MALL_GetSpecialOffer = 29）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndShop:send_MALL_GetSpecialOffer_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndShop:send_MALL_GetSpecialOffer_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MALL, Protocol.MALL_GetSpecialOffer, nflag, sMessage)
end

--@brief	获取商城抽奖列表信息（MALL_GetLuckDrawInfo = 31）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndShop:send_MALL_GetLuckDrawInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndShop:send_MALL_GetLuckDrawInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MALL, Protocol.MALL_GetLuckDrawInfo, nflag, sMessage)
end

--@brief	商城抽奖（MALL_LuckDraw = 33）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndShop:send_MALL_LuckDraw_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndShop:send_MALL_LuckDraw_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MALL, Protocol.MALL_LuckDraw, nflag, sMessage)
end

--@brief	获取折扣商贩活动状态（MALL_GetDiscountStoreStatus = 35）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndShop:send_MALL_GetDiscountStoreStatus_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndShop:send_MALL_GetDiscountStoreStatus_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MALL, Protocol.MALL_GetDiscountStoreStatus, nflag, sMessage)
end

--@brief	获取折扣商贩信息（MALL_GetDiscountStore = 37）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndShop:send_MALL_GetDiscountStore_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndShop:send_MALL_GetDiscountStore_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MALL, Protocol.MALL_GetDiscountStore, nflag, sMessage)
end

--@brief	折扣商贩贿赂（MALL_DiscountStoreBribery = 39）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndShop:send_MALL_DiscountStoreBribery_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndShop:send_MALL_DiscountStoreBribery_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MALL, Protocol.MALL_DiscountStoreBribery, nflag, sMessage)
end

--@brief	折扣商贩购买（MALL_DiscountStorePurchase = 41）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndShop:send_MALL_DiscountStorePurchase_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndShop:send_MALL_DiscountStorePurchase_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MALL, Protocol.MALL_DiscountStorePurchase, nflag, sMessage)
end

--@brief	折扣商贩刷新（MALL_DiscountStoreRefresh = 43）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndShop:send_MALL_DiscountStoreRefresh_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndShop:send_MALL_DiscountStoreRefresh_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MALL, Protocol.MALL_DiscountStoreRefresh, nflag, sMessage)
end
