--ProtocolProcessorRecharge.lua
--@brief	充值相关协议
--@date  	2013/1/21
--@author 	林庆凯
--@note 	充值相关协议


ProtocolProcessorRecharge = ProtocolProcessorBase:new()


-------------------------------------公有方法模块--------------------------------------

--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorRecharge:regAll()
    --@brief	发送购买产品验证信息错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PURCHASE, Protocol.PURCHASE_IOSSendProductCheckInfo, "ProtocolProcessorRecharge:send_PURCHASE_IOSSendProductCheckInfo_ErrorProcess", "ssi" )
    --@brief	购买成功
    self:regProtocolCallbackFunction( Protocol.MAIN_PURCHASE, Protocol.PURCHASE_BuySuccess, "ProtocolProcessorRecharge:parse_PURCHASE_BuySuccess", "ibisi")
    --@brief    购买成功2（PURCHASE_BuySuccess2 = 18）【158版本新增兼容多个Item】
    self:regProtocolCallbackFunction( Protocol.MAIN_PURCHASE, Protocol.PURCHASE_BuySuccess2, "ProtocolProcessorRecharge:parse_PURCHASE_BuySuccess2", "bisvivi")
    --@brief	获取SerialNum成功(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PURCHASE, Protocol.PURCHASE_RequestSmsCodeSerialidOk, "ProtocolProcessorRecharge:parse_PURCHASE_CodeSerialidOk", "s")
    --@brief    获取SerialNum
    self:regProtocolCallbackFunction( Protocol.MAIN_PURCHASE, Protocol.PURCHASE_RequestSmsCodeSerialid, "ProtocolProcessorRecharge:send_PURCHASE_RequestSmsCodeSerialid_ErrorProcess", "iss")

    --@brief	获取产品道具id列表（PURCHASE_GetProductIdListOK = 2）
    self:regProtocolCallbackFunction( Protocol.MAIN_PURCHASE, Protocol.PURCHASE_GetProductIdListOK, "ProtocolProcessorRecharge:parse_PURCHASE_GetProductIdListOK", "vivsvivivsvsvtvsvsvsvivn")
    --@brief	获取产品道具id列表（PURCHASE_GetProductIdList = 1）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PURCHASE, Protocol.PURCHASE_GetProductIdList, "ProtocolProcessorRecharge:send_PURCHASE_GetProductIdList_ErrorProcess", "is" )

    --@brief    获取vip礼包信息结果（PURCHASE_GetGiftIdListOK = 9）
    self:regProtocolCallbackFunction( Protocol.MAIN_PURCHASE, Protocol.PURCHASE_GetGiftIdListOK, "ProtocolProcessorRecharge:parse_PURCHASE_GetGiftIdListOK", "vivsvivivsvtvsvsvsvivnvsvivtvi")

    --@brief    获取vip礼包信息（PURCHASE_PURCHASE_GetGiftIdList = 8）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PURCHASE, Protocol.PURCHASE_GetGiftIdList, "ProtocolProcessorRecharge:send_PURCHASE_GetGiftIdList_ErrorProcess", "is" )

    --@brief    获取周年vip礼包信息（PURCHASE_GetNianGiftIdList = 10）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PURCHASE, Protocol.PURCHASE_GetNianGiftIdList, "ProtocolProcessorRecharge:send_PURCHASE_GetNianGiftIdList_ErrorProcess", "is" )
    
    --@brief    获取周年vip礼包信息结果（PURCHASE_GetNianGiftIdListOK = 11）
    self:regProtocolCallbackFunction( Protocol.MAIN_PURCHASE, Protocol.PURCHASE_GetNianGiftIdListOK , "ProtocolProcessorRecharge:parse_PURCHASE_GetNianGiftIdListOK", "vivsvivivsvtvsvsvsvivnvsvivtvi")
    
    --@brief    获取暑期礼包信息（PURCHASE_GetSummerGiftIdList = 12）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PURCHASE, Protocol.PURCHASE_GetSummerGiftIdList , "ProtocolProcessorRecharge:send_PURCHASE_GetSummerGiftIdList _ErrorProcess", "is" )

    --@brief    获取暑期礼包信息（PURCHASE_GetSummerGiftIdListOk = 13）
    self:regProtocolCallbackFunction( Protocol.MAIN_PURCHASE, Protocol.PURCHASE_GetSummerGiftIdListOk, "ProtocolProcessorRecharge:parse_PURCHASE_GetSummerGiftIdListOk", "vivsvivivsvtvsvsvsvivnvsvivtvivi")

    --@brief    IOS订阅验证（PURCHASE_IOSSubscription = 14）      错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PURCHASE, Protocol.PURCHASE_IOSSubscription, "ProtocolProcessorRecharge:send_PURCHASE_IOSSubscription_ErrorProcess", "is" )
    --@brief    谷歌兑换码（PURCHASE_GoogleSendProductCheckInfo = 15）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PURCHASE, Protocol.PURCHASE_GoogleSendProductCheckInfo, "ProtocolProcessorRecharge:send_PURCHASE_GoogleSendProductCheckInfo_ErrorProcess", "is" )
    --@brief    是否有订阅（PURCHASE_IOSSubscrip = 16）        错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PURCHASE, Protocol.PURCHASE_IOSSubscrip, "ProtocolProcessorRecharge:send_PURCHASE_IOSSubscrip_ErrorProcess", "is" )
    --@brief    是否有订阅（PURCHASE_IOSSubscripOk = 17）      
    self:regProtocolCallbackFunction( Protocol.MAIN_PURCHASE, Protocol.PURCHASE_IOSSubscripOk, "ProtocolProcessorRecharge:parse_PURCHASE_IOSSubscripOk", "ii")
    --@brief    QQ游戏大厅购买（PURCHASE_QQGameHallBuyCheckInfo = 19）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PURCHASE, Protocol.PURCHASE_QQGameHallBuyCheckInfo, "ProtocolProcessorRecharge:send_PURCHASE_QQGameHallBuyCheckInfo_ErrorProcess", "is")
    --@brief    Flash渠道购买（PURCHASE_FlashBuyCheckInfo = 20）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PURCHASE, Protocol.PURCHASE_FlashBuyCheckInfo, "ProtocolProcessorRecharge:send_PURCHASE_FlashBuyCheckInfo_ErrorProcess", "is")
end 

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorRecharge:unregAll()
	self:clearReg()
end


-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief	获取产品道具id列表
function ProtocolProcessorRecharge:send_PURCHASE_GetProductIdList(channelId, note )
	WZLog("send_PURCHASE_GetProductIdList:",channelId, note)
	local sender = Protocol:getSender( Protocol.MAIN_PURCHASE, Protocol.PURCHASE_GetProductIdList )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( channelId )	-- 渠道号
	SendProtocol(sender,false) --true:showLoading
end


--@brief	发送购买产品验证信息
function ProtocolProcessorRecharge:send_PURCHASE_IOSSendProductCheckInfo(orderNum, key ,channelId)
	WZLog("send_PURCHASE_IOSSendProductCheckInfo",orderNum,playerId,key,channelId)
	local sender = Protocol:getSender( Protocol.MAIN_PURCHASE, Protocol.PURCHASE_IOSSendProductCheckInfo )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeString( orderNum )	-- 订单号
	sender:writeString( key )	-- 订单验证的key(“0”表示购买失败，“-1”表示用户取消)
    sender:writeInt( channelId )	-- 订单验证的key(“0”表示购买失败，“-1”表示用户取消)
	SendProtocol(sender,false) --true:showLoading
end


--@brief	发送获取serialid信息
function ProtocolProcessorRecharge:send_PURCHASE_RequestSmsCodeSerialid(Id,channelid,payChannelid)
	WZLog("send_PURCHASE_RequestSmsCodeSerialid",Id,channelid,payChannelid)
	local sender = Protocol:getSender( Protocol.MAIN_PURCHASE, Protocol.PURCHASE_RequestSmsCodeSerialid )
    
    --id	int	短代id
    --localId	int	客户端对支付点的本地定义
    --channelid string 渠道id
    --payChannelid string 付费渠道id

    sender:writeInt(tonumber(Id))
    sender:writeString(channelid)
    sender:writeString(payChannelid)
	if sender==nil then WZLog("sender == nil") return end
	SendProtocol(sender,false)
end

--@brief    获取vip礼包信息（PURCHASE_PURCHASE_GetGiftIdList = 8）
function ProtocolProcessorRecharge:send_PURCHASE_GetGiftIdList(channelId )
    WZLog("send_PURCHASE_GetGiftIdList")
    local sender = Protocol:getSender( Protocol.MAIN_PURCHASE, Protocol.PURCHASE_GetGiftIdList )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( channelId )    -- 渠道号
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取周年vip礼包信息（PURCHASE_GetNianGiftIdList = 10）
function ProtocolProcessorRecharge:send_PURCHASE_GetNianGiftIdList(channelId)
    WZLog("send_PURCHASE_GetNianGiftIdList")
    local sender = Protocol:getSender( Protocol.MAIN_PURCHASE, Protocol.PURCHASE_GetNianGiftIdList )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( channelId )    -- 渠道号
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取暑期礼包信息（PURCHASE_GetSummerGiftIdList = 12）
function ProtocolProcessorRecharge:send_PURCHASE_GetSummerGiftIdList(channelId,activityType)
    WZLog("send_PURCHASE_GetSummerGiftIdList ",activityType)
    local sender = Protocol:getSender( Protocol.MAIN_PURCHASE, Protocol.PURCHASE_GetSummerGiftIdList)
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( channelId )    -- 渠道号
    sender:writeInt( activityType ) -- 活动类型(102:夏日专属;101:夏日盛惠;103:爱情公寓;107:两个礼包)
    SendProtocol(sender,false) --true:showLoading
end


--@brief    IOS订阅验证（PURCHASE_IOSSubscription = 14）      
function ProtocolProcessorRecharge:send_PURCHASE_IOSSubscription(orderNum, key, channelId, packname )
    WZLog("ProtocolProcessorRecharge:send_PURCHASE_IOSSubscription",orderNum,key,channelId,packname)
    local sender = Protocol:getSender( Protocol.MAIN_PURCHASE, Protocol.PURCHASE_IOSSubscription )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeString( orderNum )  -- 订单号
    sender:writeString( key )   -- 订单验证的key(“0”表示购买失败，“-1”表示用户取消)
    sender:writeInt( channelId )    -- 渠道id
    sender:writeString( packname )  -- 包名
    SendProtocol(sender,false) --true:showLoading
end

--@brief    谷歌兑换码（PURCHASE_GoogleSendProductCheckInfo = 15）
function ProtocolProcessorRecharge:send_PURCHASE_GoogleSendProductCheckInfo(packageName, productId, token, channelId )
    WZLog("send_PURCHASE_GoogleSendProductCheckInfo",packageName,productId,token,channelId)
    local sender = Protocol:getSender( Protocol.MAIN_PURCHASE, Protocol.PURCHASE_GoogleSendProductCheckInfo )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeString( packageName )   -- 包名
    sender:writeString( productId ) -- 产品id
    sender:writeString( token ) -- 验证token
    sender:writeInt( channelId )    -- 渠道id
    SendProtocol(sender,false) --true:showLoading
end

--@brief    是否有订阅（PURCHASE_IOSSubscrip = 16）        
function ProtocolProcessorRecharge:send_PURCHASE_IOSSubscrip( )
    WZLog("send_PURCHASE_IOSSubscrip")
    local sender = Protocol:getSender( Protocol.MAIN_PURCHASE, Protocol.PURCHASE_IOSSubscrip )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    QQ游戏大厅购买（PURCHASE_QQGameHallBuyCheckInfo = 19）
function ProtocolProcessorRecharge:send_PURCHASE_QQGameHallBuyCheckInfo(channelId, productId, openid, openkey, pf, pfkey, zoneid)
    WZLog("send_PURCHASE_QQGameHallBuyCheckInfo", channelId, productId, openid, openkey, pf, pfkey, zoneid)
    local sender = Protocol:getSender( Protocol.MAIN_PURCHASE, Protocol.PURCHASE_QQGameHallBuyCheckInfo )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt(channelId)  -- 渠道id
    sender:writeString(productId)   -- 平台商品id
    sender:writeString(openid)  -- 
    sender:writeString(openkey) -- 
    sender:writeString(pf)  -- 
    sender:writeString(pfkey)   -- 
    sender:writeString(zoneid)  -- 
    SendProtocol(sender,false) --true:showLoading
end

--@brief    Flash渠道购买（PURCHASE_FlashBuyCheckInfo = 20）
function ProtocolProcessorRecharge:send_PURCHASE_FlashBuyCheckInfo(channelId, gkey, serverId, uid, money, productName, ext, callbackInfo, sign, pageType, size)
    WZLog("send_PURCHASE_FlashBuyCheckInfo", channelId, gkey, serverId, uid, money, productName, ext, callbackInfo, sign, pageType, size)
    local sender = Protocol:getSender( Protocol.MAIN_PURCHASE, Protocol.PURCHASE_FlashBuyCheckInfo )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeString(channelId)   -- 渠道id
    sender:writeString(gkey)    -- 游戏名缩写
    sender:writeString(serverId)    -- 服务器id
    sender:writeString(uid) -- 玩家在flash平台的唯一标识符
    sender:writeString(money)   -- 支付金额 单位：元
    sender:writeString(productName) -- 商品名称 如1000钻石礼包, 用于在页面展示商品名称
    sender:writeString(ext) -- 透传参数, 通知发货时会透传给游戏方, 如角色id,商品id等参数
    sender:writeString(callbackInfo)    -- 进游戏时传的回调参数
    sender:writeString(sign)    -- 参数加密验证串
    sender:writeString(pageType)    -- 如果游戏不支持内嵌页面, type传1可以直接生成二维码图片
    sender:writeString(size)    -- 如果type传1, size参数可以控制生成二维码图片的大小, 单位为像素
    SendProtocol(sender,false) --true:showLoading
end

-------------------------------------服务器到客户端协议回调方法模块--------------------------------------

--@brief    获取vip礼包信息结果（PURCHASE_GetGiftIdListOK = 9）
function ProtocolProcessorRecharge:parse_PURCHASE_GetGiftIdListOK(ids, icons, number, giftNumber, price, flag, name, remark, showPrice, itemId, sortId, payCodeId, leftTimes, limitType, needVipLv)
    -- ids : 产品id
    -- icons : 图标
    -- number : 获得数目
    -- giftNumber : 赠送钻石的数目
    -- price : 价格
    -- payCodeId : sdk平台产品id
    -- showFlag : 显示标志:0:无,1:推荐.2:首充双倍
    -- name : 名称
    -- remark : 描述
    -- showPrice : 显示价格
    -- itemId : 物品id
    -- sort : 排序
    WZLog("ProtocolProcessorRecharge:parse_PURCHASE_GetGiftIdListOK",ids:size())
    WndVip:setGiftList(VectorToTable(ids),VectorToTable(icons),VectorToTable(number),
        VectorToTable(giftNumber), VectorToTable(price),VectorToTable(payCodeId),
        VectorToTable(flag), VectorToTable(name), VectorToTable(remark),
        VectorToTable(showPrice),VectorToTable(itemId),VectorToTable(sortId),VectorToTable(leftTimes),VectorToTable(limitType),VectorToTable(needVipLv))
    --设置纪念币的充值数据
    CacheCenter:setMarkCoinRechargeData(VectorToTable(ids),VectorToTable(icons),VectorToTable(number),
        VectorToTable(giftNumber), VectorToTable(price),VectorToTable(payCodeId),
        VectorToTable(flag), VectorToTable(name), VectorToTable(remark),
        VectorToTable(showPrice),VectorToTable(itemId),VectorToTable(sortId),VectorToTable(leftTimes),VectorToTable(limitType),VectorToTable(needVipLv))
end


--@brief	获取产品道具id列表（PURCHASE_GetProductIdListOK = 2）
function ProtocolProcessorRecharge:parse_PURCHASE_GetProductIdListOK(ids, icons, number, giftNumber, price, payCodeId, flag, name, remark,showPrice,itemId, sortId)
    -- ids : 产品id列表
    -- icons : 产品图片(选中效果在后面加“_sel”)
    -- number : 钻石
    -- giftNumber : 赠送钻石
    -- price : 价格，（配置表的值乘以100）
    -- payCodeId : sdk平台产品id
    -- flag : 标识，0、无，1、推荐，2、首冲双倍
    -- name : 名字
    -- remark : 描述
    -- showPrice 显示价格
    -- itemId 物品id
    -- sortId 排序id
    WZLog("ProtocolProcessorRecharge:parse_PURCHASE_GetProductIdListOK",ids:size(),icons:size(),number:size(),giftNumber:size(),price:size(),payCodeId:size(),flag:size(),name:size(),remark:size())
    --WndVip:setData(VectorToTable(ids),VectorToTable(icons),VectorToTable(number), VectorToTable(giftNumber), VectorToTable(price),VectorToTable(payCodeId),VectorToTable(flag), VectorToTable(name), VectorToTable(remark))
    CacheCenter:setVipList(VectorToTable(ids),VectorToTable(icons),VectorToTable(number),
        VectorToTable(giftNumber), VectorToTable(price),VectorToTable(payCodeId),
        VectorToTable(flag), VectorToTable(name), VectorToTable(remark),
        VectorToTable(showPrice),VectorToTable(itemId),VectorToTable(sortId))
    --WZLog("ProtocolProcessorRecharge:parse_PURCHASE_GetProductIdListOK", Serialize(CacheCenter:getVipList()))
end

--@brief	购买成功
function ProtocolProcessorRecharge:parse_PURCHASE_BuySuccess(count,isUp,vipLevel,sRemk,itemId)
	WZLog("ProtocolProcessorRecharge:parse_PURCHASE_BuySuccess")
    WndGameActivity:closeLoadingInMonthCard()
    WndVip:closeLoadingUI()
	-- 充值成功需要重新获取充值列表
    ProtocolProcessorRecharge:send_PURCHASE_GetGiftIdList(ProjConfig:getChannelId())
	
    if WndVipGift.m_root then
        if WndVipGift.m_nType == 2 or WndVipGift.m_nType == 5 then --新手定推礼包时候
            WndVipGift:buyResult(itemId, count)
        else
            WndVipGift:onClose()
            --ProtocolProcessorRecharge:send_PURCHASE_GetGiftIdList(ProjConfig:getChannelId())
            ProtocolProcessorWndVip:send_VIP_GetVipRebateInfo( )
            ProtocolProcessorRecharge:send_PURCHASE_GetProductIdList(ProjConfig:getChannelId(),9)
        end
    end
    PassportSdkManager:postHeroOrder(0)
    WZLog("----------------recharg success  count---------------------",itemId,count,isUp,vipLevel,sRemk)
    local tData = {}
    tData.funType = "finshPay"
    tData.money = ""..sRemk
    PassportSdkManager:Others(tData)
    if PassportSdkManager.postGameInfoHK then
        PassportSdkManager:postGameInfoHK("finshPay_hk",""..sRemk)
    end
    if PassportSdkManager.postGameInfoBeiMei then
        PassportSdkManager:postGameInfoBeiMei("finshPay_beimei",""..sRemk)
    end
    PassportSdkManager:postGameInfoHK("finshPay_hk",""..sRemk)
    if PassportSdkManager.postGameInfoBeiMei then
        PassportSdkManager:postGameInfoBeiMei("finshPay_beimei",""..sRemk)
    end
    PassportSdkManager:postHeroOrder(0)
    PostPlayerEvent:postEvent(PostPlayerEvent.event_payStep8,g_payEventId)
    if "vn" == ProjConfig.LANGUAGE and PassportSdkManager and PassportSdkManager.postGameInfoVn then
        PassportSdkManager:postGameInfoVn("purchase",""..itemId)--记录所有充值操作（游戏内+网页）
        local purchaseType = PassportSdkManager.m_sPurchaseType
        if itemId == 87 then
            purchaseType = "purchase_bpass"
        end
        if purchaseType ~= "purchase" then
            PassportSdkManager:postGameInfoVn(purchaseType,itemId)--记录所有充值操作（游戏内+网页）
            PassportSdkManager.m_sPurchaseType = "purchase"
        end
    end
    --Add By Tianxiang 
    --请求刷新充值活动进度
    if WndGameActivity.m_root then
        WndGameActivity:refreshActivityContext()
    end
    if WndNewActivity.m_root then
        WndNewActivity:refreshActivityContext(true)
    end

    if WndSumVacAct and WndSumVacAct.m_root then
        WndSumVacAct:refreshActivityContext(true)
    end
    if WndSpecifyActivity and WndSpecifyActivity.m_root then 
        WndSpecifyActivity:buyResult(itemId, count)
    end
    if WndWelfare and WndWelfare.m_root then 
        WndWelfare:chooseMethod()
    end
    if WndFrameActivity and WndFrameActivity.m_root then 
        WndFrameActivity:refreshActivityContext()
    end
    if CellMondayPlanCard and CellMondayPlanCard.m_root then
        CellMondayPlanCard:sendMondayCardProtocol()
    end
    if WndOneRechargeActivity and WndOneRechargeActivity.m_root then 
        WndOneRechargeActivity:sendOneYuanActivityProtocol()
    end
    if WndWelcomeBackActivity.m_root then
        WndWelcomeBackActivity:refreshActivityContext()
    end

	WndApartmentAct:refreshActivityContext(true)

    if WndFreeca.m_root then
        WZLog("--WndFreeca.m_root--")
        if itemId == 50 then
            WZLog("--WndFreeca.m_root1--")
            WndFreeca:refreshActivityContext(143)
        elseif itemId == 52 then
            WndFreeca:refreshActivityContext(167)
        elseif itemId == 55 then
            WndFreeca:refreshActivityContext(265)
        elseif itemId == 56 then
            WndFreeca:refreshActivityContext(266)
        end
    end
    --End Add
    -- 分开两种方式，第一种 ID= 1,50,51,52 为钻石购买， 其他的为物品充值
    if itemId == 1 or itemId == 50 or itemId == 51 or itemId == 52  or itemId == 55 or itemId == 56 then
        local data = {count = count, isUp = isUp, vipLevel = vipLevel,itemId = itemId }
        WndRechargeSuccess:showWndUI(data)
        if itemId == 52 then
            WndWelfareCard:showWindow( )
        end
        --如果在购买金币或活力界面，刷新刷新
        if WndBuyActivity.m_root then
            WndBuyActivity:updateVipInfo()
        end
        if itemId == 50 then 
            WndVip:resetMonthCardPrice()
        end
    elseif itemId == 259 then
        CellMondayPlanCard:onBuyOkTips()
    else
        if itemId > 0 then 
            if itemId == 87 then 
                local strConfig = CacheCenter:getGameParam().stoneRewardImmediately
                local tRewardConfig = json.decode(strConfig)
                local nSeason = g_nMagicStoneSeason
                local sActive = tRewardConfig[tostring(nSeason)]
                local ids, num = SplitItemString(sActive)
                local tItemId, tItemNum = {}, {}
                for i = 1, #ids do
                    table.insert(tItemId, tonumber(ids[i]))
                    table.insert(tItemNum, tonumber(num[i]))
                end
                WndRewardShow:showById(tItemId, tItemNum)
            else
                WndRewardShow:showById({itemId},{count})
            end
        end
    end

    if "vn" == ProjConfig.LANGUAGE then
        ProtocolProcessorWndVip:send_VIP_GetVipPrivilegeGift()
    end

    if checkIsOpenIOSAutoRenewalSubscription() == true then
        --获取是否订阅过苹果自动续订月卡，订阅是否到期
        ProtocolProcessorRecharge:send_PURCHASE_IOSSubscrip()
    end
    if itemId == 87 then --幻石进阶资格
        WndMagicStone:activeAdvanceOK()
    end
    GlobalGame:getGameEventDispathcer():Dispatch(NewVipEvent.NewVipEvent_ChargeSuccessResult, isUp, vipLevel)
end
--@brief    购买成功2（PURCHASE_BuySuccess2 = 18）【158版本新增兼容多个Item】
function ProtocolProcessorRecharge:parse_PURCHASE_BuySuccess2(isUp, vipLevel, remark, itemId, count)
    -- isUp : vip是否升级
    -- vipLevel : 当前vip等级
    -- remark : 附加信息
    -- itemId : 充值获得物品id
    -- count : 充值获得物品数量
    WZLog("ProtocolProcessorRecharge:parse_PURCHASE_BuySuccess2")

    if WndWelcomeBackActivity.m_root then
        WndWelcomeBackActivity:refreshActivityContext()
    end

    local itemId = VectorToTable(itemId)
    if itemId[1] == 160107 then --崛起活动的时候
        getRiseChooseGiftData()
        WndRiseGetReward:showInterface(itemId, VectorToTable(count))
        GlobalGame:getGameEventDispathcer():Dispatch(WndNationalEvent.WndNationalEvent_BuyGiftResult, itemId, VectorToTable(count))
    else
        WndRewardShow:showById(itemId, VectorToTable(count))
    end

    if "vn" == ProjConfig.LANGUAGE and PassportSdkManager and PassportSdkManager.postGameInfoVn then
        local itemIds = ""
        for i = 1, #itemId do
            itemIds = itemIds .. itemId[i]
            if i < #itemId then
                itemIds = itemIds .. ","
            end
        end
        PassportSdkManager:postGameInfoVn("purchase","")--记录所有充值操作（游戏内+网页）
        local purchaseType = PassportSdkManager.m_sPurchaseType
        if purchaseType == "purchase_dailygift" then
            PassportSdkManager:postGameInfoVn(purchaseType,itemIds)--记录所有充值操作（游戏内+网页）
            PassportSdkManager.m_sPurchaseType = "purchase"
        end
    end
end
--@brief    获取Serialid
function ProtocolProcessorRecharge:parse_PURCHASE_CodeSerialidOk(orderNum)
    WZLog("ProtocolProcessorRecharge:parse_PURCHASE_CodeSerialidOk",orderNum)
    PassportSdkManager:getOrderNumOK(orderNum)
end

--@brief    获取周年vip礼包信息结果（PURCHASE_GetNianGiftIdListOK = 11）
function ProtocolProcessorRecharge:parse_PURCHASE_GetNianGiftIdListOK(id, icon, count, giftDiamondCount, price, showFlag, name, describe, showPrice, itemId, sort, payCodeId, leftTimes, limitType, needVipLv)
    -- id : 产品id
    -- icon : 图标
    -- count : 获得数目
    -- giftDiamondCount : 赠送钻石的数目
    -- price : 价格
    -- showFlag : 显示标志:0:无,1:推荐.2:首充双倍
    -- name : 名称
    -- describe : 描述
    -- showPrice : 显示价格
    -- itemId : 物品id
    -- sort : 排序
    -- payCodeId : sdk平台产品id
    -- leftTimes : 剩余次数
    -- limitType : 限购类型,0:不限购,1:每日限购,2:终身限购
    -- needVipLv : 需要的vip等级
    WZLog("ProtocolProcessorRecharge:parse_PURCHASE_GetNianGiftIdListOK ")
    WndNewActivity:GetVipRechargeInfoOK(VectorToTable(id),VectorToTable(icon),VectorToTable(count),
        VectorToTable(giftDiamondCount), VectorToTable(price),VectorToTable(payCodeId),
        VectorToTable(showFlag), VectorToTable(name), VectorToTable(describe),
        VectorToTable(showPrice),VectorToTable(itemId),VectorToTable(sort),VectorToTable(leftTimes),VectorToTable(limitType),VectorToTable(needVipLv))
end

--@brief    获取暑期礼包信息（PURCHASE_GetSummerGiftIdListOk = 13）
function ProtocolProcessorRecharge:parse_PURCHASE_GetSummerGiftIdListOk(id, icon, count, giftDiamondCount, price, showFlag, name, describe, showPrice, itemId, sort, payCodeId, leftTimes, limitType, needVipLv, maxTimes)
    -- id : 产品id
    -- icon : 图标
    -- count : 获得数目
    -- giftDiamondCount : 赠送钻石的数目
    -- price : 价格
    -- showFlag : 显示标志:0:无,1:推荐.2:首充双倍
    -- name : 名称
    -- describe : 描述
    -- showPrice : 显示价格
    -- itemId : 物品id
    -- sort : 排序
    -- payCodeId : sdk平台产品id
    -- leftTimes : 剩余次数
    -- limitType : 限购类型,0:不限购,1:每日限购,2:终身限购
    -- needVipLv : 需要的vip等级
    WZLog("ProtocolProcessorRecharge:parse_PURCHASE_GetSummerGiftIdListOk  ",Serialize(VectorToTable(leftTimes)),Serialize(VectorToTable(maxTimes)),Serialize(VectorToTable(limitType)))
    WndSumVacAct:GetVipRechargeInfoOK(VectorToTable(id),VectorToTable(icon),VectorToTable(count),
        VectorToTable(giftDiamondCount), VectorToTable(price),VectorToTable(payCodeId),
        VectorToTable(showFlag), VectorToTable(name), VectorToTable(describe),
        VectorToTable(showPrice),VectorToTable(itemId),VectorToTable(sort),VectorToTable(leftTimes),VectorToTable(limitType),VectorToTable(needVipLv))

    WndApartmentAct:GetVipRechargeInfoOK(VectorToTable(id),VectorToTable(icon),VectorToTable(count),
        VectorToTable(giftDiamondCount), VectorToTable(price),VectorToTable(payCodeId),
        VectorToTable(showFlag), VectorToTable(name), VectorToTable(describe),
        VectorToTable(showPrice),VectorToTable(itemId),VectorToTable(sort),VectorToTable(leftTimes),VectorToTable(limitType),VectorToTable(needVipLv),VectorToTable(maxTimes))
    if WndGameActivity.m_root then 
        WndGameActivity:GetSmallRechargeDataOK(VectorToTable(id),VectorToTable(icon),VectorToTable(count),
        VectorToTable(giftDiamondCount), VectorToTable(price), VectorToTable(showFlag), VectorToTable(name), VectorToTable(describe), VectorToTable(showPrice), VectorToTable(itemId), VectorToTable(sort), VectorToTable(payCodeId), VectorToTable(leftTimes), VectorToTable(limitType), VectorToTable(needVipLv))
    end
end

--@brief    是否有订阅（PURCHASE_IOSSubscripOk = 17）      
function ProtocolProcessorRecharge:parse_PURCHASE_IOSSubscripOk(subscrip, effective)
    -- subscrip : 是否订阅（1为订阅，0为没订阅）
    -- effective : 订阅是否有效期内(1为有效，0为没效)
    WZLog("ProtocolProcessorRecharge:parse_PURCHASE_IOSSubscripOk", subscrip, effective)
    if GlobalGame.g_nSubscrip == nil and GlobalGame.g_nSubscripEffective == nil then
        WZLog("ProtocolProcessorRecharge:parse_PURCHASE_IOSSubscripOk: nSubscrip nil, nSubscripEffective nil")
    end
    GlobalGame.g_nSubscrip = subscrip
    GlobalGame.g_nSubscripEffective = effective
end

-------------------------------------协议错误处理方法模块--------------------------------------
--@brief	发送购买产品验证信息错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorRecharge:send_PURCHASE_IOSSendProductCheckInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorRecharge:send_PURCHASE_IOSSendProductCheckInfo_ErrorProcess",sMessage)
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PURCHASE, Protocol.PURCHASE_IOSSendProductCheckInfo, nflag, sMessage)
end

--@brief	获取产品道具id列表（PURCHASE_GetProductIdList = 1）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorRecharge:send_PURCHASE_GetProductIdList_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorRecharge:send_PURCHASE_GetProductIdList_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PURCHASE, Protocol.PURCHASE_GetProductIdList, nflag, sMessage)
end

--@brief	获取序列号失败（PURCHASE_GetProductIdList = 6）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorRecharge:send_PURCHASE_RequestSmsCodeSerialid_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorRecharge:send_PURCHASE_RequestSmsCodeSerialid_ErrorProcess")
    WndVip:showWndUIRecharge()
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PURCHASE, Protocol.PURCHASE_RequestSmsCodeSerialid, nflag, sMessage)
end

--@brief    获取vip礼包信息（PURCHASE_PURCHASE_GetGiftIdList = 8）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorRecharge:send_PURCHASE_GetGiftIdList_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorRecharge:send_PURCHASE_GetGiftIdList_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PURCHASE, Protocol.PURCHASE_GetGiftIdList, nflag, sMessage)
end

--@brief    获取周年vip礼包信息（PURCHASE_GetNianGiftIdList = 10）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorRecharge:send_PURCHASE_GetNianGiftIdList_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorRecharge:send_PURCHASE_GetNianGiftIdList_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PURCHASE, Protocol.PURCHASE_GetNianGiftIdList, nflag, sMessage)
end

--@brief    获取暑期礼包信息（PURCHASE_GetSummerGiftIdList = 12）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorRecharge:send_PURCHASE_GetSummerGiftIdList_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorRecharge:send_PURCHASE_GetSummerGiftIdList _ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PURCHASE, Protocol.PURCHASE_GetSummerGiftIdList , nflag, sMessage)
end

--@brief    IOS订阅验证（PURCHASE_IOSSubscription = 14）      错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorRecharge:send_PURCHASE_IOSSubscription_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorRecharge:send_PURCHASE_IOSSubscription_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PURCHASE, Protocol.PURCHASE_IOSSubscription, nflag, sMessage)
    if checkIsOpenIOSAutoRenewalSubscription() == true then
        --获取是否订阅过苹果自动续订月卡，订阅是否到期
        ProtocolProcessorRecharge:send_PURCHASE_IOSSubscrip()
    end
    if GlobalGame.g_bIsClickMonthCard == true then
        GlobalGame.g_bIsClickMonthCard = false  
        GlobalGame.g_bIsSubscriptionFailed = true  
        --popFastRechargeUI50(50)
        CellMonthCardPanel:onRechargeEvent()
    end
end

--@brief    谷歌兑换码（PURCHASE_GoogleSendProductCheckInfo = 15）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorRecharge:send_PURCHASE_GoogleSendProductCheckInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorRecharge:send_PURCHASE_GoogleSendProductCheckInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PURCHASE, Protocol.PURCHASE_GoogleSendProductCheckInfo, nflag, sMessage)
end

--@brief    是否有订阅（PURCHASE_IOSSubscrip = 16）        错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorRecharge:send_PURCHASE_IOSSubscrip_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorRecharge:send_PURCHASE_IOSSubscrip_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PURCHASE, Protocol.PURCHASE_IOSSubscrip, nflag, sMessage)
end

--@brief    QQ游戏大厅购买（PURCHASE_QQGameHallBuyCheckInfo = 19）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorRecharge:send_PURCHASE_QQGameHallBuyCheckInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorRecharge:parse_PURCHASE_QQGameHallBuyCheckInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PURCHASE, Protocol.PURCHASE_QQGameHallBuyCheckInfo, nflag, sMessage)
end

--@brief    Flash渠道购买（PURCHASE_FlashBuyCheckInfo = 20）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorRecharge:send_PURCHASE_FlashBuyCheckInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorRecharge:parse_PURCHASE_FlashBuyCheckInfo_ErrorProcess", nFlag, sMessage)
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PURCHASE, Protocol.PURCHASE_FlashBuyCheckInfo, nflag, sMessage)
end