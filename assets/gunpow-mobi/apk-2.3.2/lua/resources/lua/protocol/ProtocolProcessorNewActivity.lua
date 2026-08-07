--ProtocolProcessorNewActivity.lua
--@brief    线上活动/公告模块协议
--@date     2014/11/27
--@author   weidong_wu


ProtocolProcessorNewActivity = ProtocolProcessorBase:new()
-------------------------------------公有方法模块--------------------------------------
--@brief    注册协议组所有协议
function ProtocolProcessorNewActivity:regAll()
    --@brief    获取摇摇乐信息（ACTIVITY2_GetPokerInfo = 1）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetPokerInfo, "ProtocolProcessorNewActivity:send_ACTIVITY2_GetPokerInfo_ErrorProcess", "is" )
    --@brief    摇摇乐抽奖（ACTIVITY2_PokerLottery = 3）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_PokerLottery, "ProtocolProcessorNewActivity:send_ACTIVITY2_PokerLottery_ErrorProcess", "is" )
    --@brief    摇摇乐重置（ACTIVITY2_PokerReset = 5）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_PokerReset, "ProtocolProcessorNewActivity:send_ACTIVITY2_PokerReset_ErrorProcess", "is" )
    --@brief    领取摇摇乐奖励（ACTIVITY2_PokerReward = 7）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_PokerReward, "ProtocolProcessorNewActivity:send_ACTIVITY2_PokerReward_ErrorProcess", "is" )
    --@brief    获取摇摇乐任务活动信息（ACTIVITY2_GetPokerTaskList = 9）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetPokerTaskList, "ProtocolProcessorNewActivity:send_ACTIVITY2_GetPokerTaskList_ErrorProcess", "is" )
    --@brief    领取摇摇乐任务奖励（ACTIVITY2_PokerTaskRewardReward = 11）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_PokerTaskRewardReward, "ProtocolProcessorNewActivity:send_ACTIVITY2_PokerTaskRewardReward_ErrorProcess", "is" )
    --@brief    获取幸运一元充活动详情（ACTIVITY2_GetOneYuanLuckyInfo = 13）     错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetOneYuanLuckyInfo, "ProtocolProcessorNewActivity:send_ACTIVITY2_GetOneYuanLuckyInfo_ErrorProcess", "is" )
    --@brief    领取幸运码（ACTIVITY2_GetOneYuanLuckyCode = 15）       错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetOneYuanLuckyCode, "ProtocolProcessorNewActivity:send_ACTIVITY2_GetOneYuanLuckyCode_ErrorProcess", "is" )
    --@brief    获取我的幸运码（ACTIVITY2_GetOneYuanMyLuckyCode = 17）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetOneYuanMyLuckyCode, "ProtocolProcessorNewActivity:send_ACTIVITY2_GetOneYuanMyLuckyCode_ErrorProcess", "is" )
    --@brief    获取往期回顾（ACTIVITY2_GetOneYuanLuckyWinRecord = 19）     错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetOneYuanLuckyWinRecord, "ProtocolProcessorNewActivity:send_ACTIVITY2_GetOneYuanLuckyWinRecord_ErrorProcess", "is" )
    --@brief    获取七夕活动详情（ACTIVITY2_QiXiActivityInfo = 23）       错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_QiXiActivityInfo, "ProtocolProcessorNewActivity:send_ACTIVITY2_QiXiActivityInfo_ErrorProcess", "is" )
    --@brief    发起|接受|拒绝 七夕告白（ACTIVITY2_QiXiConfess = 25）       错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_QiXiConfess, "ProtocolProcessorNewActivity:send_ACTIVITY2_QiXiConfess_ErrorProcess", "is" )
    --@brief    获取告白列表（ACTIVITY2_QiXiConfessList = 27）      错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_QiXiConfessList, "ProtocolProcessorNewActivity:send_ACTIVITY2_QiXiConfessList_ErrorProcess", "is" )
    --@brief        送礼物告白（ACTIVITY2_QiXiGiveGift = 29）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_QiXiGiveGift, "ProtocolProcessorNewActivity:send_ACTIVITY2_QiXiGiveGift_ErrorProcess", "is" )
    --@brief    获取七夕任务列表（ACTIVITY2_QiXiTaskList = 31）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_QiXiTaskList, "ProtocolProcessorNewActivity:send_ACTIVITY2_QiXiTaskList_ErrorProcess", "is" )
    --@brief    领取七夕任务奖励（ACTIVITY2_QiXiGetTaskReward = 33）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_QiXiGetTaskReward, "ProtocolProcessorNewActivity:send_ACTIVITY2_QiXiGetTaskReward_ErrorProcess", "is" )
    --@brief    获取七夕情侣榜列表（ACTIVITY2_QiXiRankingList = 35）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_QiXiRankingList, "ProtocolProcessorNewActivity:send_ACTIVITY2_QiXiRankingList_ErrorProcess", "is" )
    --@brief    拍卖行出价（ACTIVITY2_Bid = 40）       错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_Bid, "ProtocolProcessorNewActivity:send_ACTIVITY2_Bid_ErrorProcess", "is" )
    --@brief    获取拍卖行信息（ACTIVITY2_GetAuctionInfo = 42）      错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetAuctionInfo, "ProtocolProcessorNewActivity:send_ACTIVITY2_GetAuctionInfo_ErrorProcess", "is" )
    --@brief    获取拍卖行总榜（ACTIVITY2_GetAuctionRank = 44）      错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetAuctionRank, "ProtocolProcessorNewActivity:send_ACTIVITY2_GetAuctionRank_ErrorProcess", "is" )
    --@brief    获取拍卖行商店信息（ACTIVITY2_GetAuctionMallInfo = 47）        错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetAuctionMallInfo, "ProtocolProcessorNewActivity:send_ACTIVITY2_GetAuctionMallInfo_ErrorProcess", "is" )
    --@brief    刷新拍卖行商店物品（ACTIVITY2_ResetAuction = 49）      错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_ResetAuction, "ProtocolProcessorNewActivity:send_ACTIVITY2_ResetAuction_ErrorProcess", "is" )
    --@brief    兑换拍卖行商店物品（ACTIVITY2_ExchangeAuctionItem = 50）       错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_ExchangeAuctionItem, "ProtocolProcessorNewActivity:send_ACTIVITY2_ExchangeAuctionItem_ErrorProcess", "is" )
    --@brief    鉴宝自定义协议（ACTIVITY2_JBActivityDo = 115）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_JBActivityDo, "ProtocolProcessorNewActivity:send_ACTIVITY2_JBActivityDo_ErrorProcess", "is")


    --@brief    获取拉杆信息（ACTIVITY2_GetPokerInfoOk = 2）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetPokerInfoOk, "ProtocolProcessorNewActivity:parse_ACTIVITY2_GetPokerInfoOk", "vsviiii")
    --@brief    摇摇乐抽奖（ACTIVITY2_PokerLotteryOk = 4）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_PokerLotteryOk, "ProtocolProcessorNewActivity:parse_ACTIVITY2_PokerLotteryOk", "vsii")
    --@brief    摇摇乐重置结果（ACTIVITY2_PokerResetOk = 6）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_PokerResetOk, "ProtocolProcessorNewActivity:parse_ACTIVITY2_PokerResetOk", "sii")
    --@brief    领取摇摇乐奖励（ACTIVITY2_PokerRewardOk = 8）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_PokerRewardOk, "ProtocolProcessorNewActivity:parse_ACTIVITY2_PokerRewardOk", "vivii")
    --@brief    获取摇摇乐任务活动信息（ACTIVITY2_GetPokerTaskListOk = 10）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetPokerTaskListOk, "ProtocolProcessorNewActivity:parse_ACTIVITY2_GetPokerTaskListOk", "vivivivii")
    --@brief    领取摇摇乐任务奖励（ACTIVITY2_PokerTaskRewardRewardOk = 12）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_PokerTaskRewardRewardOk, "ProtocolProcessorNewActivity:parse_ACTIVITY2_PokerTaskRewardRewardOk", "ii")
    --@brief    获取幸运一元充活动详情（ACTIVITY2_GetOneYuanLuckyInfoOk = 14）       
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetOneYuanLuckyInfoOk, "ProtocolProcessorNewActivity:parse_ACTIVITY2_GetOneYuanLuckyInfoOk", "iviviiiiiivsvi")
    --@brief    领取幸运码（ACTIVITY2_GetOneYuanLuckyCodeOk = 16）     
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetOneYuanLuckyCodeOk, "ProtocolProcessorNewActivity:parse_ACTIVITY2_GetOneYuanLuckyCodeOk", "i")
    --@brief    获取我的幸运码（ACTIVITY2_GetOneYuanMyLuckyCodeOk = 18）     
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetOneYuanMyLuckyCodeOk, "ProtocolProcessorNewActivity:parse_ACTIVITY2_GetOneYuanMyLuckyCodeOk", "vi")
    --@brief    获取往期回顾（ACTIVITY2_GetOneYuanLuckyWinRecordOk = 20）       
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetOneYuanLuckyWinRecordOk, "ProtocolProcessorNewActivity:parse_ACTIVITY2_GetOneYuanLuckyWinRecordOk", "vivivsvivivivivivivivi")
    --@brief    获取七夕活动详情（ACTIVITY2_QiXiActivityInfoOk = 24）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_QiXiActivityInfoOk, "ProtocolProcessorNewActivity:parse_ACTIVITY2_QiXiActivityInfoOk", "iiiisiivivi")
    --@brief    发起|接受|拒绝 七夕告白（ACTIVITY2_QiXiConfessOk = 26）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_QiXiConfessOk, "ProtocolProcessorNewActivity:parse_ACTIVITY2_QiXiConfessOk", "it")
    --@brief    获取告白列表（ACTIVITY2_QiXiConfessListOk = 28）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_QiXiConfessListOk, "ProtocolProcessorNewActivity:parse_ACTIVITY2_QiXiConfessListOk", "vivsvivivivtvnvtvivtvt")
    --@brief    送礼物告白（ACTIVITY2_QiXiGiveGiftOk = 30）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_QiXiGiveGiftOk, "ProtocolProcessorNewActivity:parse_ACTIVITY2_QiXiGiveGiftOk", "ii")
    --@brief    获取七夕任务列表（ACTIVITY2_QiXiTaskListOk = 32）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_QiXiTaskListOk, "ProtocolProcessorNewActivity:parse_ACTIVITY2_QiXiTaskListOk", "vivivivivivivi")
    --@brief    领取七夕任务奖励（ACTIVITY2_QiXiGetTaskRewardOk = 34）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_QiXiGetTaskRewardOk, "ProtocolProcessorNewActivity:parse_ACTIVITY2_QiXiGetTaskRewardOk", "ii")
    --@brief    获取七夕情侣榜列表（ACTIVITY2_QiXiRankingListOk = 36）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_QiXiRankingListOk, "ProtocolProcessorNewActivity:parse_ACTIVITY2_QiXiRankingListOk", "vivsvivivivtvnvi")
    --@brief    出价结果（ACTIVITY2_BidOk= 41）       
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_BidOk, "ProtocolProcessorNewActivity:parse_ACTIVITY2_BidOk", "ii")
    --@brief    成功获取拍卖行信息（ACTIVITY2_GetAuctionInfoOk= 43）       
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetAuctionInfoOk, "ProtocolProcessorNewActivity:parse_ACTIVITY2_GetAuctionInfoOk", "iiiivsiiisiisvss")
    --@brief    成功获取拍卖行总榜（ACTIVITY2_GetAuctionRankOk = 45）      
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetAuctionRankOk, "ProtocolProcessorNewActivity:parse_ACTIVITY2_GetAuctionRankOk", "ivivsvivsiivivivivi")
    --@brief    获取拍卖行商店信息（ACTIVITY2_GetAuctionMallInfoOk = 48）      
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetAuctionMallInfoOk, "ProtocolProcessorNewActivity:parse_ACTIVITY2_GetAuctionMallInfoOk", "vivsvivsviivii")
    --@brief    兑换拍卖行商店成功（ACTIVITY2_ExchangeAuctionItemOk = 51）     
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_ExchangeAuctionItemOk, "ProtocolProcessorNewActivity:parse_ACTIVITY2_ExchangeAuctionItemOk", "")
    --@brief    鉴宝自定义协议（ACTIVITY2_JBActivityDoOk = 116）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_JBActivityDoOk, "ProtocolProcessorNewActivity:parse_ACTIVITY2_JBActivityDoOk", "iis")


end


--@brief    反注册协议组所有协议
function ProtocolProcessorNewActivity:unregAll()
    WZLog("ProtocolProcessorNewActivity:unregAll")
    self:clearReg()
end


-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief    获取摇摇乐信息（ACTIVITY2_GetPokerInfo = 1）
function ProtocolProcessorNewActivity:send_ACTIVITY2_GetPokerInfo()
    WZLog("send_ACTIVITY2_GetPokerInfo ")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetPokerInfo )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    摇摇乐抽奖（ACTIVITY2_PokerLottery = 3）
function ProtocolProcessorNewActivity:send_ACTIVITY2_PokerLottery(nTimesIndex, rewardIndex)
    WZLog("send_ACTIVITY2_PokerLottery ")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_PokerLottery )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( nTimesIndex )  -- 倍数索引
    sender:writeInt( rewardIndex )  -- 选中的奖励
    SendProtocol(sender,false) --true:showLoading
end

--@brief    摇摇乐重置（ACTIVITY2_PokerReset = 5）
function ProtocolProcessorNewActivity:send_ACTIVITY2_PokerReset(index)
    WZLog("send_ACTIVITY2_PokerReset ")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_PokerReset )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( index )  -- 重置的下标（0开始）
    SendProtocol(sender,false) --true:showLoading
end

--@brief    领取摇摇乐奖励（ACTIVITY2_PokerReward = 7）
function ProtocolProcessorNewActivity:send_ACTIVITY2_PokerReward()
    WZLog("send_ACTIVITY2_PokerReward ")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_PokerReward )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取摇摇乐任务活动信息（ACTIVITY2_GetPokerTaskList = 9）
function ProtocolProcessorNewActivity:send_ACTIVITY2_GetPokerTaskList()
    WZLog("send_ACTIVITY2_GetPokerTaskList ")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetPokerTaskList )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    领取摇摇乐任务奖励（ACTIVITY2_PokerTaskRewardReward = 11）
function ProtocolProcessorNewActivity:send_ACTIVITY2_PokerTaskRewardReward(id)
    WZLog("send_ACTIVITY2_PokerTaskRewardReward ")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_PokerTaskRewardReward )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( id )  -- 任务Id
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取幸运一元充活动详情（ACTIVITY2_GetOneYuanLuckyInfo = 13）     
function ProtocolProcessorNewActivity:send_ACTIVITY2_GetOneYuanLuckyInfo( )
    WZLog("send_ACTIVITY2_GetOneYuanLuckyInfo")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetOneYuanLuckyInfo )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    领取幸运码（ACTIVITY2_GetOneYuanLuckyCode = 15）       
function ProtocolProcessorNewActivity:send_ACTIVITY2_GetOneYuanLuckyCode( )
    WZLog("send_ACTIVITY2_GetOneYuanLuckyCode")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetOneYuanLuckyCode )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取我的幸运码（ACTIVITY2_GetOneYuanMyLuckyCode = 17）
function ProtocolProcessorNewActivity:send_ACTIVITY2_GetOneYuanMyLuckyCode( )
    WZLog("send_ACTIVITY2_GetOneYuanMyLuckyCode")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetOneYuanMyLuckyCode )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取往期回顾（ACTIVITY2_GetOneYuanLuckyWinRecord = 19）     
function ProtocolProcessorNewActivity:send_ACTIVITY2_GetOneYuanLuckyWinRecord( )
    WZLog("send_ACTIVITY2_GetOneYuanLuckyWinRecord")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetOneYuanLuckyWinRecord )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end


--@brief    获取七夕活动详情（ACTIVITY2_QiXiActivityInfo = 23）       
function ProtocolProcessorNewActivity:send_ACTIVITY2_QiXiActivityInfo( )
    WZLog("send_ACTIVITY2_QiXiActivityInfo")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_QiXiActivityInfo )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end
--@brief    发起|接受|拒绝 七夕告白（ACTIVITY2_QiXiConfess = 25）       
function ProtocolProcessorNewActivity:send_ACTIVITY2_QiXiConfess(confessType, playerId )
    WZLog("send_ACTIVITY2_QiXiConfess")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_QiXiConfess )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeByte( confessType ) -- 告白类型【1=发起 | 2=接受 | 3=拒绝】
    sender:writeInts( playerId )    -- 玩家ID【仅发起告白支持批量，接受和拒绝只能传一个玩家Id】
    SendProtocol(sender,false) --true:showLoading
end
--@brief    获取告白列表（ACTIVITY2_QiXiConfessList = 27）      
function ProtocolProcessorNewActivity:send_ACTIVITY2_QiXiConfessList( )
    WZLog("send_ACTIVITY2_QiXiConfessList")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_QiXiConfessList )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end
--@brief        送礼物告白（ACTIVITY2_QiXiGiveGift = 29）
function ProtocolProcessorNewActivity:send_ACTIVITY2_QiXiGiveGift(giftId )
    WZLog("send_ACTIVITY2_QiXiGiveGift")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_QiXiGiveGift )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( giftId )   -- 七夕礼物ID
    SendProtocol(sender,false) --true:showLoading
end
--@brief    获取七夕任务列表（ACTIVITY2_QiXiTaskList = 31）
function ProtocolProcessorNewActivity:send_ACTIVITY2_QiXiTaskList( )
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_QiXiTaskList )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end
--@brief    领取七夕任务奖励（ACTIVITY2_QiXiGetTaskReward = 33）
function ProtocolProcessorNewActivity:send_ACTIVITY2_QiXiGetTaskReward(taskId )
    WZLog("send_ACTIVITY2_QiXiGetTaskReward")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_QiXiGetTaskReward )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( taskId )   -- 任务ID
    SendProtocol(sender,false) --true:showLoading
end
--@brief    获取七夕情侣榜列表（ACTIVITY2_QiXiRankingList = 35）
function ProtocolProcessorNewActivity:send_ACTIVITY2_QiXiRankingList( )
    WZLog("send_ACTIVITY2_QiXiRankingList")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_QiXiRankingList )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    拍卖行出价（ACTIVITY2_Bid = 40）       
function ProtocolProcessorNewActivity:send_ACTIVITY2_Bid(auction, bType, price )
    WZLog("send_ACTIVITY2_Bid",auction,bType,price)
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_Bid )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( auction )    -- 第几件
    sender:writeInt( bType )    -- 0出价 1加价5% 2加价25% 3加价100%
    sender:writeInt( price )    -- 价格
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取拍卖行信息（ACTIVITY2_GetAuctionInfo = 42）      
function ProtocolProcessorNewActivity:send_ACTIVITY2_GetAuctionInfo( )
    WZLog("send_ACTIVITY2_GetAuctionInfo")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetAuctionInfo )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取拍卖行排行榜（ACTIVITY2_GetAuctionRank = 44）
function ProtocolProcessorNewActivity:send_ACTIVITY2_GetAuctionRank(rankType)
    WZLog("send_ACTIVITY2_GetAuctionRank", rankType)
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetAuctionRank )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt(rankType)   -- 排行榜类型：1-原来的排行榜，2-鉴宝榜
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取拍卖行商店信息（ACTIVITY2_GetAuctionMallInfo = 47）        
function ProtocolProcessorNewActivity:send_ACTIVITY2_GetAuctionMallInfo(activityId )
    WZLog("send_ACTIVITY2_GetAuctionMallInfo",activityId)
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetAuctionMallInfo )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( activityId )   -- 活动id
    SendProtocol(sender,false) --true:showLoading
end

--@brief    刷新拍卖行商店物品（ACTIVITY2_ResetAuction = 49）      
function ProtocolProcessorNewActivity:send_ACTIVITY2_ResetAuction( )
    WZLog("send_ACTIVITY2_ResetAuction")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_ResetAuction )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    兑换拍卖行商店物品（ACTIVITY2_ExchangeAuctionItem = 50）       
function ProtocolProcessorNewActivity:send_ACTIVITY2_ExchangeAuctionItem(mallId, num )
    WZLog("send_ACTIVITY2_ExchangeAuctionItem")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_ExchangeAuctionItem )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( mallId )   -- 商品id
    sender:writeInt( num )  -- 兑换数量
    SendProtocol(sender,false) --true:showLoading
end

--@brief    鉴宝自定义协议（ACTIVITY2_JBActivityDo = 115）
function ProtocolProcessorNewActivity:send_ACTIVITY2_JBActivityDo(opType, sjson)
    WZLog("send_ACTIVITY2_JBActivityDo", opType, sjson)
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_JBActivityDo )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt(opType) -- 操作类型：1-鉴宝，</br>2-刷新鉴宝奖池，</br>3-自选鉴宝奖励，</br>4-获取大奖奖池，</br>5-刷新大奖奖池，</br>6-领取大奖，</br>7-结算，</br>8-获取鉴宝奖池，</br>
    sender:writeString(sjson)    -- 对应操作类型的参数：</br>1-{'type(1-1次，2多次)':1}；</br>3-{'index(下标)':0}</br>
    SendProtocol(sender,false) --true:showLoading
end


-------------------------------------协议接收处理方法模块--------------------------------------
--@brief    获取拉杆信息（ACTIVITY2_GetPokerInfoOk = 2）
function ProtocolProcessorNewActivity:parse_ACTIVITY2_GetPokerInfoOk(marks, status, reset, num, pokerType)
    -- marks : 显示的标志["1-1","3-1","3-2"…]
    -- status : 状态（0为可抽奖，1为可领奖励）[领取状态，当时抽奖选中的倍数，选中的奖励索引]
    -- reset : 今天更改结果次数
    -- num : 牌型对应的倍数 
    -- pokerType : 牌型 
    WZLog("ProtocolProcessorNewActivity:parse_ACTIVITY2_GetPokerInfoOk")
    
    WndHappyShake:setTreasureInfo(VectorToTable(marks), VectorToTable(status), reset, num, pokerType)
end

--@brief    摇摇乐抽奖（ACTIVITY2_PokerLotteryOk = 4）
function ProtocolProcessorNewActivity:parse_ACTIVITY2_PokerLotteryOk(marks, num, pokerType)
    -- marks : 显示的标志["1-1","3-1","3-2"…]
    -- num : 牌型对应的倍数 
    -- pokerType : 牌型
    WZLog("ProtocolProcessorNewActivity:parse_ACTIVITY2_PokerLotteryOk")

    WndHappyShake:raffleSuccess(VectorToTable(marks), pokerType, num)
end

--@brief    摇摇乐重置结果（ACTIVITY2_PokerResetOk = 6）
function ProtocolProcessorNewActivity:parse_ACTIVITY2_PokerResetOk(marks, num, pokerType)
    -- marks : 显示的标志["1-1","3-1","3-2"…]
    -- num : 牌型对应的倍数 
    -- pokerType : 牌型 
    WZLog("ProtocolProcessorNewActivity:parse_ACTIVITY2_PokerResetOk")
    
    WndHappyShake:resertSingleSlot(marks, pokerType, num)
end

--@brief    领取摇摇乐奖励（ACTIVITY2_PokerRewardOk = 8）
function ProtocolProcessorNewActivity:parse_ACTIVITY2_PokerRewardOk(itemId, itemNum, status)
    -- itemId : 物品id
    -- itemNum : 物品数量
    -- status : 状态（0为可拉杆，1为可领奖励）
    WZLog("ProtocolProcessorNewActivity:parse_ACTIVITY2_PokerRewardOk")
    
    WndHappyShake:getRewardOK(VectorToTable(itemId), VectorToTable(itemNum), status)
end

--@brief   获取摇摇乐任务活动信息（ACTIVITY2_GetPokerTaskListOk = 10）
function ProtocolProcessorNewActivity:parse_ACTIVITY2_GetPokerTaskListOk(id, status, target, complete, refreshTime)
    -- id : 任务Id
    -- target : 目标数量
    -- complete : 当前数量
    -- status : 状态（0进行中，1为可领奖励，2已领取）
    -- refreshTime : 刷新剩余时间
    WZLog("ProtocolProcessorNewActivity:parse_ACTIVITY2_GetPokerTaskListOk")
    WndHappyShake:getActivityTaskListOk(VectorToTable(id), VectorToTable(status), VectorToTable(target), VectorToTable(complete), refreshTime)
    
    WndHappyShakeTask:getActivityTaskListOk(VectorToTable(id), VectorToTable(status), VectorToTable(target), VectorToTable(complete), refreshTime)
end

--@brief   领取摇摇乐任务奖励（ACTIVITY2_PokerTaskRewardRewardOk = 12）
function ProtocolProcessorNewActivity:parse_ACTIVITY2_PokerTaskRewardRewardOk(id, status)
    -- itemId : id任务Id
    -- status : 状态（0为失败，1为成功）
    WZLog("ProtocolProcessorNewActivity:parse_ACTIVITY2_PokerTaskRewardRewardOk")
    
    WndHappyShakeTask:getTastRewardOK(status, id)
end

--@brief    获取幸运一元充活动详情（ACTIVITY2_GetOneYuanLuckyInfoOk = 14）       
function ProtocolProcessorNewActivity:parse_ACTIVITY2_GetOneYuanLuckyInfoOk(phase, rewardItemId, rewardItemNum, joinCount, openRewardCondition, rechargeSum, luckyCodeRechargeNum, luckyCodeCount, nickname, luckyCodeNum)
    -- phase : 活动期数，如第1期
    -- rewardItemId : 奖励物品ID
    -- rewardItemNum : 奖励物品数量
    -- joinCount : 当前参与人次
    -- openRewardCondition : 开奖条件-参与人次
    -- rechargeSum : 活动期间累计充值钻石总数量
    -- luckyCodeRechargeNum : 换取了幸运码的充值钻石数量【根据累计充值与此比较去决定显不显示领取按钮和红点】
    -- luckyCodeCount : 本期累计领取了多少个幸运码【每期没人最多领取100个】
    -- nickname : 幸运码获取记录-玩家昵称【注意本期还没有领取幸运码时，数组长度为0】
    -- luckyCodeNum : 幸运码领取记录-领取了多少个幸运码
    WZLog("ProtocolProcessorNewActivity:parse_ACTIVITY2_GetOneYuanLuckyInfoOk",
        "\nphase=",Serialize(VectorToTable(phase)),
        "\nrewardItemId=",Serialize(VectorToTable(rewardItemId)),
        "\nrewardItemNum=",Serialize(VectorToTable(rewardItemNum)),
        "\njoinCount=",Serialize(VectorToTable(joinCount)),
        "\nopenRewardCondition=",Serialize(VectorToTable(openRewardCondition)),
        "\nrechargeSum=",Serialize(VectorToTable(rechargeSum)),
        "\nluckyCodeRechargeNum=",Serialize(VectorToTable(luckyCodeRechargeNum)),
        "\nluckyCodeCount=",Serialize(VectorToTable(luckyCodeCount)),
        "\nnickname=",Serialize(VectorToTable(nickname)),
        "\nluckyCodeNum=",Serialize(VectorToTable(luckyCodeNum)))

    WndOneRechargeActivity:getOneYuanLuckyInfoOk(phase, VectorToTable(rewardItemId), VectorToTable(rewardItemNum), joinCount, openRewardCondition, rechargeSum, luckyCodeRechargeNum, luckyCodeCount, VectorToTable(nickname), VectorToTable(luckyCodeNum))
end

--@brief    领取幸运码（ACTIVITY2_GetOneYuanLuckyCodeOk = 16）     
function ProtocolProcessorNewActivity:parse_ACTIVITY2_GetOneYuanLuckyCodeOk(status)
    -- status : 领取状态，0=失败|1=未达到开奖条件 | 2=没中奖 | 3=中奖了【最后一个幸运码被领取时会触发开奖】
    WZLog("ProtocolProcessorNewActivity:parse_ACTIVITY2_GetOneYuanLuckyCodeOk",status)
    WndOneRechargeActivity:getOneYuanLuckyCodeOk(status)
end

--@brief    获取我的幸运码（ACTIVITY2_GetOneYuanMyLuckyCodeOk = 18）     
function ProtocolProcessorNewActivity:parse_ACTIVITY2_GetOneYuanMyLuckyCodeOk(luckyCode)
    -- luckyCode : 我本期获得了的幸运码
    WZLog("ProtocolProcessorNewActivity:parse_ACTIVITY2_GetOneYuanMyLuckyCodeOk",luckyCode)
    if WndOneActivityRule.m_root then
        WndOneActivityRule:getOneYuanMyLuckyCodeOk(VectorToTable(luckyCode))
    end
end

--@brief    获取往期回顾（ACTIVITY2_GetOneYuanLuckyWinRecordOk = 20）       
function ProtocolProcessorNewActivity:parse_ACTIVITY2_GetOneYuanLuckyWinRecordOk(date, playerId, nickname, headId, headColor, faceId, sex, rewardCount, itemId, itemNum, luckyCode)
    -- date : 中奖记录-开奖日期时间戳，单位秒
    -- playerId : 中奖记录-中奖玩家ID
    -- nickname : 中奖记录-中奖玩家昵称
    -- headId : 中奖记录-中奖玩家头像
    -- headColor : 中奖记录-中奖玩家头像颜色
    -- rewardCount : 中奖记录-奖品包含的物品种类数，前端根据此值去切割下面的两个数组，得到各条中奖记录中的奖品内容(暂时用不到,因为每期奖励只有1个)
    -- itemId : 中奖记录-奖品的物品ID
    -- itemNum : 中奖记录-奖品的物品数量
    -- luckyCode : 中奖记录-中奖幸运码
    -- faceId : 中奖记录-中奖玩家面部
    WZLog("ProtocolProcessorNewActivity:parse_ACTIVITY2_GetOneYuanLuckyWinRecordOk",
        "\ndate",Serialize(VectorToTable(date)),
        "\nplayerId",Serialize(VectorToTable(playerId)),
        "\nnickname",Serialize(VectorToTable(nickname)),
        "\nheadId",Serialize(VectorToTable(headId)),
        "\nheadColor",Serialize(VectorToTable(headColor)),
        "\nfaceId",Serialize(VectorToTable(faceId)),
        "\nsex",Serialize(VectorToTable(sex)),
        "\nrewardCount",Serialize(VectorToTable(rewardCount)),
        "\nitemId",Serialize(VectorToTable(itemId)),
        "\nitemNum",Serialize(VectorToTable(itemNum)),
        "\nluckyCode",Serialize(VectorToTable(luckyCode)))
    if WndOneActivityRule.m_root then
        WndOneActivityRule:getOneYuanLuckyWinRecordOk(VectorToTable(date),VectorToTable(playerId),VectorToTable(nickname),VectorToTable(headId),VectorToTable(headColor),VectorToTable(faceId),VectorToTable(sex),VectorToTable(rewardCount),VectorToTable(itemId),VectorToTable(itemNum),VectorToTable(luckyCode))
    end
end

--@brief    获取七夕活动详情（ACTIVITY2_QiXiActivityInfoOk = 24）
function ProtocolProcessorNewActivity:parse_ACTIVITY2_QiXiActivityInfoOk(activityId, startTime, endTime, playerId, headScul, myConfess, confessSum, itemId, itemNum)
    -- activityId : 活动ID
    -- startTime : 活动开始时间
    -- endTime : 活动结束时间
    -- playerId : 另一伴的玩家ID，没有时为0
    -- headScul : 令一半的自定义头像，没有为 ""
    -- myConfess : 我的告白值
    -- confessSum : 双方的告白值总合
    -- itemId : 最新收到的礼物ID，当此数组有值时，需要弹“收到礼物”提示。玫瑰没有物品ID，用礼钻的ID=70代表玫瑰ID
    -- itemNum : 最新收到的礼物数量，当此数组有值时，需要弹“收到礼物”提示。
    GlobalGame:getGameEventDispathcer():Dispatch(WndDoubleSevenEvent.WndDoubleSevenEvent_InitMessage,activityId, startTime, endTime, playerId, headScul,
                                                   myConfess, confessSum, VectorToTable(itemId), VectorToTable(itemNum))
end
--@brief    发起|接受|拒绝 七夕告白（ACTIVITY2_QiXiConfessOk = 26）
function ProtocolProcessorNewActivity:parse_ACTIVITY2_QiXiConfessOk(result, confessType)
    -- result : 结果，0=成功，非0=失败【如1=对方不是你的异性好友不能接受他的告白，2=你接受告白慢了，对方已经是别人的情侣了】
    -- 3：已有情侣，不能再向他人告白或接受他人告白
    if result == 0 then
        if WndDoubleSevenInvit.m_root then
            MsgBoxManager:showTipBox(LocalStrings.DOUBLE_SEVEN_TEXT30)
            WindowManager:removeWindow(WndDoubleSevenInvit.m_root, WndDoubleSevenInvit, true)
        end
    else
        if result == 1 then
            MsgBoxManager:showTipBox(LocalStrings.DOUBLE_SEVEN_TEXT27)
        elseif result == 2 then
            MsgBoxManager:showTipBox(LocalStrings.DOUBLE_SEVEN_TEXT28)
        elseif result == 3 then
            MsgBoxManager:showTipBox(LocalStrings.DOUBLE_SEVEN_TEXT35)
        end
    end
end
--@brief    获取告白列表（ACTIVITY2_QiXiConfessListOk = 28）
function ProtocolProcessorNewActivity:parse_ACTIVITY2_QiXiConfessListOk(playerId, nickname, headId, headColor, faceId, sex, level, confessContext, confessTime, confessType, confessStatus)
    -- playerId : 向我表白的玩家ID
    -- nickname : 向我表白的玩家昵称
    -- headId : 向我表白的玩家头像
    -- headColor : 向我表白的玩家头像颜色
    -- faceId : 向我表白的玩家脸蛋
    -- sex : 向我表白的玩家性别
    -- level : 向我表白的玩家等级
    -- confessContext : 向我表白的内容文本的配置编号
    -- confessTime : 告白时间，通过此字段进行列表顺序排序
    -- confessType : 告白类型【1=我向别人告白的回复|2=别人向我告白】
    -- confessStatus : 我向别人告白的回复结果【1=接受|2=拒绝】
    WZLog("ProtocolProcessorNewActivity:parse_ACTIVITY2_QiXiConfessListOk")
    GlobalGame:getGameEventDispathcer():Dispatch(WndDoubleSevenEvent.WndDoubleSevenEvent_InvateNotice, VectorToTable(playerId), VectorToTable(nickname), VectorToTable(headId), 
        VectorToTable(headColor), VectorToTable(faceId), VectorToTable(sex), VectorToTable(level), VectorToTable(confessContext), VectorToTable(confessTime), VectorToTable(confessType), VectorToTable(confessStatus))
end
--@brief    送礼物告白（ACTIVITY2_QiXiGiveGiftOk = 30）
function ProtocolProcessorNewActivity:parse_ACTIVITY2_QiXiGiveGiftOk(myConfess, confessSum)
    -- myConfess : 我的告白值
    -- confessSum : 双方的告白值总合
    GlobalGame:getGameEventDispathcer():Dispatch(WndDoubleSevenEvent.WndDoubleSevenEvent_SendGiftResult, myConfess, confessSum)
end
--@brief    获取七夕任务列表（ACTIVITY2_QiXiTaskListOk = 32）
function ProtocolProcessorNewActivity:parse_ACTIVITY2_QiXiTaskListOk(taskId, target, progress, status, rewardNum, itemId, itemNum)
    -- taskId : 任务ID
    -- target : 任务目标数量
    -- progress : 任务进度数量
    -- status : 任务奖励状态
    -- rewardNum : 奖励数量
    -- itemId : 奖励物品id
    -- itemNum : 奖励物品数量
    GlobalGame:getGameEventDispathcer():Dispatch(WndDoubleSevenEvent.WndDoubleSevenEvent_ConfreeTask, VectorToTable(taskId), VectorToTable(target), VectorToTable(progress),
                                                   VectorToTable(status),VectorToTable(rewardNum),VectorToTable(itemId),VectorToTable(itemNum))
end
--@brief    领取七夕任务奖励（ACTIVITY2_QiXiGetTaskRewardOk = 34）
function ProtocolProcessorNewActivity:parse_ACTIVITY2_QiXiGetTaskRewardOk(result, taskId)
    -- result : 结果，0=成功，非0=失败
    WZLog("ProtocolProcessorNewActivity:parse_ACTIVITY2_QiXiGetTaskRewardOk")
    if result == 0 then
        GlobalGame:getGameEventDispathcer():Dispatch(WndDoubleSevenEvent.WndDoubleSevenEvent_GetTaskResult,result,taskId)
    end
end
--@brief    获取七夕情侣榜列表（ACTIVITY2_QiXiRankingListOk = 36）
function ProtocolProcessorNewActivity:parse_ACTIVITY2_QiXiRankingListOk(playerId, nickname, headId, headColor, faceId, sex, level, confessSum)
    -- playerId : 玩家ID【每2个组成一对情侣，即数组下标0、1为一对，2、3为一对；下同】
    -- nickname : 玩家昵称
    -- headId : 玩家头像
    -- headColor : 玩家头像颜色
    -- faceId : 玩家脸蛋
    -- sex : 玩家性别
    -- level : 玩家等级
    -- confessSum : 双方的告白值总合【注意这个数组下标对应关系和上面不同】
    GlobalGame:getGameEventDispathcer():Dispatch(WndDoubleSevenEvent.WndDoubleSevenEvent_ConfreeRank, VectorToTable(playerId), VectorToTable(nickname), VectorToTable(headId), 
                                                  VectorToTable(headColor), VectorToTable(faceId), VectorToTable(sex), VectorToTable(level), VectorToTable(confessSum))
end

--@brief    出价结果（ACTIVITY2_BidOk= 41）       
function ProtocolProcessorNewActivity:parse_ACTIVITY2_BidOk(bType, result)
    -- result : 1为成功
    -- bType : 0出价 1加价5% 2加价25% 3加价100%
    WZLog("ProtocolProcessorNewActivity:parse_ACTIVITY2_BidOk", bType, result)
    CellAuctionHouse:auctionBidOk(bType, result)
end

--@brief    成功获取拍卖行信息（ACTIVITY2_GetAuctionInfoOk= 43）       
function ProtocolProcessorNewActivity:parse_ACTIVITY2_GetAuctionInfoOk(activityId, startTime, endTime, status, auctions, auction, initPrice, price, name, totalTime, time, weekName, bidInfo, auctionStartTime)
    -- activityId : 活动ID
    -- startTime : 开始时间（秒）
    -- endTime : 结束时间（秒）
    -- status :  -1没有此活动 0今日活动未开启  2今日少去已结束 1活动中
    -- auctions : 今日拍卖品 格式[1,10]&[2,20]
    -- auction : 第几件
    -- initPrice : 起拍价
    -- price : 当前出价
    -- name : 玩家姓名
    -- totalTime : 总时长（秒）
    -- time : 当前拍卖品时长
    -- weekName : 本周竞拍之王
    -- bidInfo : 出价记录
    -- auctionStartTime : 活动开始时间
    WZLog("ProtocolProcessorNewActivity:parse_ACTIVITY2_GetAuctionInfoOk",
        "\nactivityId",Serialize(VectorToTable(activityId)),
        "\nstartTime",Serialize(VectorToTable(startTime)),
        "\nendTime",Serialize(VectorToTable(endTime)),
        "\nstatus",Serialize(VectorToTable(status)),
        "\nauctions",Serialize(VectorToTable(auctions)),
        "\nauction",Serialize(VectorToTable(auction)),
        "\ninitPrice",Serialize(VectorToTable(initPrice)),
        "\nprice",Serialize(VectorToTable(price)),
        "\nname",Serialize(VectorToTable(name)),
        "\ntotalTime",Serialize(VectorToTable(totalTime)),
        "\ntime",Serialize(VectorToTable(time)),
        "\nweekName",Serialize(VectorToTable(weekName)),
        "\nbidInfo",Serialize(VectorToTable(bidInfo)),
        "\nauctionStartTime",Serialize(VectorToTable(auctionStartTime))
        )
    WndAuctionHouseAct:GetManyCollectDataOK(activityId, startTime, endTime, status, VectorToTable(auctions), auction, initPrice, price, name, totalTime, time, weekName, VectorToTable(bidInfo), auctionStartTime)
end

--@brief    成功获取拍卖行总榜（ACTIVITY2_GetAuctionRankOk = 45）      
function ProtocolProcessorNewActivity:parse_ACTIVITY2_GetAuctionRankOk(rankType, rank, name, score, reward, myScore, myRank, faceIds, headIds, headColors, playerId)
    -- rankType : 排行榜类型：1-原来的排行榜，2-鉴宝榜 
    -- rank : 排名
    -- name : 玩家名字
    -- score : 竞拍积分
    -- reward : 奖励
    -- myScore : 我的竞拍积分
    -- myRank : 我的排名
    -- playerId : 玩家Id
    WZLog("ProtocolProcessorNewActivity:parse_ACTIVITY2_GetAuctionRankOk",
        "\nrankType",rankType,
        "\nrank",Serialize(VectorToTable(rank)),
        "\nname",Serialize(VectorToTable(name)),
        "\nscore",Serialize(VectorToTable(score)),
        "\nreward",Serialize(VectorToTable(reward)),
        "\nmyScore",Serialize(VectorToTable(myScore)),
        "\nmyRank",Serialize(VectorToTable(myRank)))
    WndAuctionRank:getAuctionRankOk(rankType, VectorToTable(rank), VectorToTable(name), VectorToTable(score), VectorToTable(reward), myScore, myRank, VectorToTable(faceIds),VectorToTable(headIds),VectorToTable(headColors), VectorToTable(playerId))
end

--@brief    获取拍卖行商店信息（ACTIVITY2_GetAuctionMallInfoOk = 48）      
function ProtocolProcessorNewActivity:parse_ACTIVITY2_GetAuctionMallInfoOk(mallId, item, exchange, price, exchangeNum, resetNum, mType, time)
    -- mallId : 商品id
    -- item : 商品 格式=[1,1]
    -- exchange : 兑换次数
    -- price : 价格 [11,250]
    -- exchangeNum : 已兑换次数
    -- resetNum : 今日刷新次数
    -- mType : 商品类型
    WZLog("ProtocolProcessorNewActivity:parse_ACTIVITY2_GetAuctionMallInfoOk",
        "\nmallId",Serialize(VectorToTable(mallId)),
        "\nitem",Serialize(VectorToTable(item)),
        "\nexchange",Serialize(VectorToTable(exchange)),
        "\nprice",Serialize(VectorToTable(price)),
        "\nexchangeNum",Serialize(VectorToTable(exchangeNum)),
        "\nresetNum",Serialize(VectorToTable(resetNum)),
        "\nmType",Serialize(VectorToTable(mType)),
        "\ntime",Serialize(VectorToTable(time)))
    WndAuctionStore:getAuctionMallInfoOk(VectorToTable(mallId), VectorToTable(item), VectorToTable(exchange), VectorToTable(price), VectorToTable(exchangeNum), resetNum, VectorToTable(mType), time)
end

--@brief    兑换拍卖行商店成功（ACTIVITY2_ExchangeAuctionItemOk = 51）     
function ProtocolProcessorNewActivity:parse_ACTIVITY2_ExchangeAuctionItemOk()
    WZLog("ProtocolProcessorNewActivity:parse_ACTIVITY2_ExchangeAuctionItemOk")

    WndAuctionStore:getExchangeAuctionItemOk()
end

--@brief    鉴宝自定义协议（ACTIVITY2_JBActivityDoOk = 116）
function ProtocolProcessorNewActivity:parse_ACTIVITY2_JBActivityDoOk(opType, result, sjson)
    -- opType : 操作类型：1-鉴宝，</br>2-刷新鉴宝奖池，</br>3-自选鉴宝奖励，</br>4-获取大奖奖池，</br>5-刷新大奖奖池，</br>6-领取大奖，</br>7-结算，</br>8-获取鉴宝奖池，</br>
    -- result : 操作结果：1-成功，2-失败，3-参数异常，4-道具不足，5-请先选择物品，6-不能切换已选物品，7-未达到最小倍数，8-未达成条件，9-已达限量
    -- json : 1-返回获得json，itemIds数组、nums数组、times已鉴宝次数；</br>2-返回奖池json，[[下标，下标（服务端用），道具id，数量，是否选择（1-已选）]]；</br>3-返回奖池json，已选择的下标index和勾选状态（1勾选）；</br>4-返回奖池数组，[[下标，下标（服务端用），道具id，数量，是否选择（1-已选）]]；</br>5-返回奖池数组，[[下标，下标（服务端用），道具id，数量，全局限量，个人限量，全局限量已购买数量，个人限量已购买数量]]；</br>6-返回获得奖励json，itemIds数组和nums数组；</br>7-返回获得奖励json，itemIds数组和nums数组；</br>8-返回奖池数组，[[下标，下标（服务端用），道具id，数量，是否选择（1-已选）]]；</br>9-返回获得奖励json，itemIds数组和nums数组；</br>
    WZLog("ProtocolProcessorNewActivity:parse_ACTIVITY2_JBActivityDoOk", opType, result, sjson)
    WndAuctionIdentifyMain:getJBActivityDoOk(opType, result, sjson)
end


-------------------------------------协议错误处理方法模块--------------------------------------

--@brief    获取摇摇乐信息（ACTIVITY2_GetPokerInfo = 1）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorNewActivity:send_ACTIVITY2_GetPokerInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorNewActivity:send_ACTIVITY2_GetPokerInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetPokerInfo, nflag, sMessage)
end

--@brief    摇摇乐抽奖（ACTIVITY2_PokerLottery = 3）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorNewActivity:send_ACTIVITY2_PokerLottery_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorNewActivity:send_ACTIVITY2_PokerLottery_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_PokerLottery, nflag, sMessage)
end

--@brief    摇摇乐重置（ACTIVITY2_PokerReset = 5）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorNewActivity:send_ACTIVITY2_PokerReset_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorNewActivity:send_ACTIVITY2_PokerReset_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_PokerReset, nflag, sMessage)
end

--@brief    领取摇摇乐奖励（ACTIVITY2_PokerReward = 7）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorNewActivity:send_ACTIVITY2_PokerReward_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorNewActivity:send_ACTIVITY2_PokerReward_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_PokerReward, nflag, sMessage)
end

--@brief    获取摇摇乐任务活动信息（ACTIVITY2_GetPokerTaskList = 9）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorNewActivity:send_ACTIVITY2_GetPokerTaskList_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorNewActivity:send_ACTIVITY2_GetPokerTaskList_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetPokerTaskList, nflag, sMessage)
end

--@brief    领取摇摇乐任务奖励（ACTIVITY2_PokerTaskRewardReward = 11）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorNewActivity:send_ACTIVITY2_PokerTaskRewardReward_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorNewActivity:send_ACTIVITY2_PokerTaskRewardReward_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_PokerTaskRewardReward, nflag, sMessage)
end

--@brief    获取幸运一元充活动详情（ACTIVITY2_GetOneYuanLuckyInfo = 13）     错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorNewActivity:send_ACTIVITY2_GetOneYuanLuckyInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorNewActivity:send_ACTIVITY2_GetOneYuanLuckyInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetOneYuanLuckyInfo, nflag, sMessage)
end

--@brief    领取幸运码（ACTIVITY2_GetOneYuanLuckyCode = 15）       错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorNewActivity:send_ACTIVITY2_GetOneYuanLuckyCode_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorNewActivity:send_ACTIVITY2_GetOneYuanLuckyCode_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetOneYuanLuckyCode, nflag, sMessage)
end

--@brief    获取我的幸运码（ACTIVITY2_GetOneYuanMyLuckyCode = 17）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorNewActivity:send_ACTIVITY2_GetOneYuanMyLuckyCode_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorNewActivity:send_ACTIVITY2_GetOneYuanMyLuckyCode_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetOneYuanMyLuckyCode, nflag, sMessage)
end

--@brief    获取往期回顾（ACTIVITY2_GetOneYuanLuckyWinRecord = 19）     错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorNewActivity:send_ACTIVITY2_GetOneYuanLuckyWinRecord_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorNewActivity:send_ACTIVITY2_GetOneYuanLuckyWinRecord_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetOneYuanLuckyWinRecord, nflag, sMessage)
end

--@brief    获取七夕活动详情（ACTIVITY2_QiXiActivityInfo = 23）       错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorNewActivity:send_ACTIVITY2_QiXiActivityInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorNewActivity:send_ACTIVITY2_QiXiActivityInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_QiXiActivityInfo, nflag, sMessage)
end
--@brief    发起|接受|拒绝 七夕告白（ACTIVITY2_QiXiConfess = 25）       错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorNewActivity:send_ACTIVITY2_QiXiConfess_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorNewActivity:send_ACTIVITY2_QiXiConfess_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_QiXiConfess, nflag, sMessage)
end
--@brief    获取告白列表（ACTIVITY2_QiXiConfessList = 27）      错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorNewActivity:send_ACTIVITY2_QiXiConfessList_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorNewActivity:send_ACTIVITY2_QiXiConfessList_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_QiXiConfessList, nflag, sMessage)
end
--@brief        送礼物告白（ACTIVITY2_QiXiGiveGift = 29）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorNewActivity:send_ACTIVITY2_QiXiGiveGift_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorNewActivity:send_ACTIVITY2_QiXiGiveGift_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_QiXiGiveGift, nflag, sMessage)
end
--@brief    获取七夕任务列表（ACTIVITY2_QiXiTaskList = 31）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorNewActivity:send_ACTIVITY2_QiXiTaskList_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorNewActivity:send_ACTIVITY2_QiXiTaskList_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_QiXiTaskList, nflag, sMessage)
end

--@brief    领取七夕任务奖励（ACTIVITY2_QiXiGetTaskReward = 33）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorNewActivity:send_ACTIVITY2_QiXiGetTaskReward_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorNewActivity:send_ACTIVITY2_QiXiGetTaskReward_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_QiXiGetTaskReward, nflag, sMessage)
end
--@brief    获取七夕情侣榜列表（ACTIVITY2_QiXiRankingList = 35）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorNewActivity:send_ACTIVITY2_QiXiRankingList_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorNewActivity:send_ACTIVITY2_QiXiRankingList_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_QiXiRankingList, nflag, sMessage)
end

--@brief    拍卖行出价（ACTIVITY2_Bid = 40）       错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorNewActivity:send_ACTIVITY2_Bid_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorNewActivity:send_ACTIVITY2_Bid_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_Bid, nflag, sMessage)
end

--@brief    获取拍卖行信息（ACTIVITY2_GetAuctionInfo = 42）      错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorNewActivity:send_ACTIVITY2_GetAuctionInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorNewActivity:send_ACTIVITY2_GetAuctionInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetAuctionInfo, nflag, sMessage)
end

--@brief    获取拍卖行总榜（ACTIVITY2_GetAuctionRank = 44）      错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorNewActivity:send_ACTIVITY2_GetAuctionRank_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorNewActivity:send_ACTIVITY2_GetAuctionRank_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetAuctionRank, nflag, sMessage)
end

--@brief    获取拍卖行商店信息（ACTIVITY2_GetAuctionMallInfo = 47）        错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorNewActivity:send_ACTIVITY2_GetAuctionMallInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorNewActivity:send_ACTIVITY2_GetAuctionMallInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetAuctionMallInfo, nflag, sMessage)
end

--@brief    刷新拍卖行商店物品（ACTIVITY2_ResetAuction = 49）      错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorNewActivity:send_ACTIVITY2_ResetAuction_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorNewActivity:send_ACTIVITY2_ResetAuction_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_ResetAuction, nflag, sMessage)
end

--@brief    兑换拍卖行商店物品（ACTIVITY2_ExchangeAuctionItem = 50）       错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorNewActivity:send_ACTIVITY2_ExchangeAuctionItem_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorNewActivity:send_ACTIVITY2_ExchangeAuctionItem_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_ExchangeAuctionItem, nflag, sMessage)
end

--@brief    鉴宝自定义协议（ACTIVITY2_JBActivityDo = 115）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorNewActivity:send_ACTIVITY2_JBActivityDo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorNewActivity:parse_ACTIVITY2_JBActivityDo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_JBActivityDo, nflag, sMessage)
end
