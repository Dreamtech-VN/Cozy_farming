--ProtocolProcessorBless.lua
--@brief    成长基金相关协议
--@date     2016/4/14
--@author   Tianxiang_Xu
--@note     成长基金相关协议


ProtocolProcessorBless = ProtocolProcessorBase:new()


--@brief    注册协议组所有协议
--@note     注册协议组所有协议
function ProtocolProcessorBless:regAll()
    --@brief    获取祈福信息成功（PRAY_GetPrayMessOk = 2）
    self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.PRAY_GetPrayMessOk, "ProtocolProcessorBless:parse_PRAY_GetPrayMessOk", "iiiviviviviviviviviviviivivi")
    --@brief    返回祈福结果（PRAY_PrayOk = 4）
    self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.PRAY_PrayOk, "ProtocolProcessorBless:parse_PRAY_PrayOk", "vivivivi")
    --@brief    返回单次吞噬结果（PRAY_DevourOk = 6）
    self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.PRAY_DevourOk, "ProtocolProcessorBless:parse_PRAY_DevourOk", "iiivii")
    --@brief    祈福珠换到背包结果（PRAY_ChangeBagOk = 8）
    self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.PRAY_ChangeBagOk, "ProtocolProcessorBless:parse_PRAY_ChangeBagOk", "vi")
    --@brief    出售垃圾祈福珠结果（PRAY_SellOk = 10）
    self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.PRAY_SellOk, "ProtocolProcessorBless:parse_PRAY_SellOk", "vi")
    --@brief    召唤祈福师结果（PRAY_CallOk = 12）
    self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.PRAY_CallOk, "ProtocolProcessorBless:parse_PRAY_CallOk", "i")
    --@brief    祈福珠操作结果（PRAY_EquipOk = 14）
    self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.PRAY_EquipOk, "ProtocolProcessorBless:parse_PRAY_EquipOk", "vivivivivivivii")
    --@brief    一键吞噬结果（PRAY_FastDevourOk = 16）
    self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.PRAY_FastDevourOk, "ProtocolProcessorBless:parse_PRAY_FastDevourOk", "iiivi")
    --@brief    一键装备祈福珠结果（PRAY_FastEquipOk = 25）
    self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.PRAY_FastEquipOk, "ProtocolProcessorBless:parse_PRAY_FastEquipOk", "vivii")


    --@brief    获取祈福信息（PRAY_GetPrayMess = 1）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.PRAY_GetPrayMess, "ProtocolProcessorBless:send_PRAY_GetPrayMess_ErrorProcess", "is" )
    --@brief    祈福（PRAY_Pray = 3）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.PRAY_Pray, "ProtocolProcessorBless:send_PRAY_Pray_ErrorProcess", "is" )
    --@brief    单次吞噬（PRAY_Devour = 5）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.PRAY_Devour, "ProtocolProcessorBless:send_PRAY_Devour_ErrorProcess", "is" )
    --@brief    祈福珠换到背包（PRAY_ChangeBag = 7）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.PRAY_ChangeBag, "ProtocolProcessorBless:send_PRAY_ChangeBag_ErrorProcess", "is" )
    --@brief    出售垃圾祈福珠（PRAY_Sell = 9）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.PRAY_Sell, "ProtocolProcessorBless:send_PRAY_Sell_ErrorProcess", "is" )
    --@brief    召唤祈福师（PRAY_Call = 11）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.PRAY_Call, "ProtocolProcessorBless:send_PRAY_Call_ErrorProcess", "is" )
    --@brief    祈福珠操作（PRAY_Equip = 13）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.PRAY_Equip, "ProtocolProcessorBless:send_PRAY_Equip_ErrorProcess", "is" )
    --@brief    一键吞噬（PRAY_FastDevour = 15）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.PRAY_FastDevour , "ProtocolProcessorBless:send_PRAY_FastDevour _ErrorProcess", "is" )
    --@brief 一键装备祈福珠（PRAY_FastEquip = 24）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.PRAY_FastEquip, "ProtocolProcessorBless:send_PRAY_FastEquip_ErrorProcess", "is" )
    
    --@brief    获取拉杆信息（PRAY_GetRaffleInfo = 26）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.PRAY_GetRaffleInfo, "ProtocolProcessorBless:send_PRAY_GetRaffleInfo_ErrorProcess", "is" )

    --@brief    获取拉杆信息（PRAY_GetRaffleInfoOk = 27）
    self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.PRAY_GetRaffleInfoOk, "ProtocolProcessorBless:parse_PRAY_GetRaffleInfoOk", "viiii")

    --@brief    拉杆抽奖（PRAY_Raffle = 28）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.PRAY_Raffle, "ProtocolProcessorBless:send_PRAY_Raffle_ErrorProcess", "is" )

    --@brief    拉杆抽奖（PRAY_RaffleOk = 29）
    self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.PRAY_RaffleOk, "ProtocolProcessorBless:parse_PRAY_RaffleOk", "vi")
   

    
    --@brief 重置结果（PRAY_ResetRaffle = 30）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.PRAY_ResetRaffle, "ProtocolProcessorBless:send_PRAY_ResetRaffle_ErrorProcess", "is" )
    
    --@brief    拉杆抽奖（PRAY_ResetRaffle = 31）
    self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.PRAY_ResetRaffleOk, "ProtocolProcessorBless:parse_PRAY_ResetRaffleOk", "i")
    
    --@brief    领取摇杆奖励（PRAY_GiveRaffleReward = 32）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.PRAY_GiveRaffleReward, "ProtocolProcessorBless:send_PRAY_GiveRaffleReward_ErrorProcess", "is" )
    
    --@brief    领取摇杆奖励（PRAY_GiveRaffleRewardOk = 33）
    self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.PRAY_GiveRaffleRewardOk , "ProtocolProcessorBless:parse_PRAY_GiveRaffleRewardOk", "vivii")

end



--@brief    反注册协议组所有协议
--@note     反注册协议组所有协议
function ProtocolProcessorBless:unregAll()
    self:clearReg()
end


---------------------------------客户端到服务器协议发送方法模块----------------------------------
--@brief    获取祈福信息（PRAY_GetPrayMess = 1）
function ProtocolProcessorBless:send_PRAY_GetPrayMess( )
    WZLog("send_PRAY_GetPrayMess")
    local sender = Protocol:getSender( Protocol.MAIN_TRATE, Protocol.PRAY_GetPrayMess )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    祈福（PRAY_Pray = 3）
function ProtocolProcessorBless:send_PRAY_Pray(typeId )
    WZLog("send_PRAY_Pray")
    local sender = Protocol:getSender( Protocol.MAIN_TRATE, Protocol.PRAY_Pray )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( typeId )   -- 祈福类型（1为单次祈福，2为一键祈福）
    SendProtocol(sender,false) --true:showLoading
end

--@brief    单次吞噬（PRAY_Devour = 5）
function ProtocolProcessorBless:send_PRAY_Devour(typeId, devourId, prayIds )
    WZLog("send_PRAY_Devour")
    local sender = Protocol:getSender( Protocol.MAIN_TRATE, Protocol.PRAY_Devour )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( typeId )   -- 吞噬类型（1为背包中祝福，2为祈福栏中祝福）
    sender:writeInt( devourId ) -- 吞噬祝福Id
    sender:writeInts( prayIds ) -- 被吞噬祝福Id列表
    SendProtocol(sender,false) --true:showLoading
end

--@brief    祈福珠换到背包（PRAY_ChangeBag = 7）
function ProtocolProcessorBless:send_PRAY_ChangeBag(typeId, prayIds )
    WZLog("send_PRAY_ChangeBag")
    local sender = Protocol:getSender( Protocol.MAIN_TRATE, Protocol.PRAY_ChangeBag )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( typeId )   -- 切换类型（1为一键切换，2为部分切换）
    sender:writeInts( prayIds ) -- 被切换祈福Id列表
    SendProtocol(sender,false) --true:showLoading
end

--@brief    出售垃圾祈福珠（PRAY_Sell = 9）
function ProtocolProcessorBless:send_PRAY_Sell(prayIds )
    WZLog("send_PRAY_Sell")
    local sender = Protocol:getSender( Protocol.MAIN_TRATE, Protocol.PRAY_Sell )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInts( prayIds ) -- 出售祈福珠Id列表
    SendProtocol(sender,false) --true:showLoading
end

--@brief    召唤祈福师（PRAY_Call = 11）
function ProtocolProcessorBless:send_PRAY_Call(typeId )
    WZLog("send_PRAY_Call")
    local sender = Protocol:getSender( Protocol.MAIN_TRATE, Protocol.PRAY_Call )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( typeId )   -- 召唤祈福师类型（1为普通召唤，2为vip召唤）
    SendProtocol(sender,false) --true:showLoading
end

--@brief    祈福珠操作（PRAY_Equip = 13）
function ProtocolProcessorBless:send_PRAY_Equip(typeId, prayId )
    WZLog("send_PRAY_Equip")
    local sender = Protocol:getSender( Protocol.MAIN_TRATE, Protocol.PRAY_Equip )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( typeId )   -- 操作类型（1为装备，2为卸下）
    sender:writeInt( prayId )   -- 祈福珠唯一标示Id
    SendProtocol(sender,false) --true:showLoading
end

--@brief    一键吞噬（PRAY_FastDevour = 15）
function ProtocolProcessorBless:send_PRAY_FastDevour (typeId )
    WZLog("send_PRAY_FastDevour ")
    local sender = Protocol:getSender( Protocol.MAIN_TRATE, Protocol.PRAY_FastDevour  )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( typeId )   -- 吞噬类型（1为祈福栏中祝福，2为背包中祝福）
    SendProtocol(sender,false) --true:showLoading
end

--@brief    一键装备祈福珠（PRAY_FastEquip = 24）
function ProtocolProcessorBless:send_PRAY_FastEquip()
    WZLog("send_PRAY_FastEquip")
    local sender = Protocol:getSender( Protocol.MAIN_TRATE, Protocol.PRAY_FastEquip )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取拉杆信息（PRAY_GetRaffleInfo = 26）
function ProtocolProcessorBless:send_PRAY_GetRaffleInfo()
    WZLog("send_PRAY_GetRaffleInfo")
    local sender = Protocol:getSender( Protocol.MAIN_TRATE, Protocol.PRAY_GetRaffleInfo )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end


--@brief    拉杆抽奖（PRAY_Raffle = 28）
function ProtocolProcessorBless:send_PRAY_Raffle()
    WZLog("send_PRAY_Raffle")
    local sender = Protocol:getSender( Protocol.MAIN_TRATE, Protocol.PRAY_Raffle )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end


--@brief    重置（PRAY_ResetRaffle = 30）
function ProtocolProcessorBless:send_PRAY_ResetRaffle(index )
    WZLog("send_PRAY_ResetRaffle")
    local sender = Protocol:getSender( Protocol.MAIN_TRATE, Protocol.PRAY_ResetRaffle )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( index )    -- 重置的下标（0开始）
    SendProtocol(sender,false) --true:showLoading
end

--@brief    领取摇杆奖励（PRAY_GiveRaffleReward = 32）
function ProtocolProcessorBless:send_PRAY_GiveRaffleReward()
    WZLog("send_PRAY_GiveRaffleReward")
    local sender = Protocol:getSender( Protocol.MAIN_TRATE, Protocol.PRAY_GiveRaffleReward )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end


---------------------------------服务器到客户端协议回调方法模块----------------------------------
--@brief    获取祈福信息成功（PRAY_GetPrayMessOk = 2）
function ProtocolProcessorBless:parse_PRAY_GetPrayMessOk(debris, prayerId, summonNum, bagIds, bagExps, bagPrayIds, roomIds, roomExps, roomPrayIds, prayNum, equipPrayId, equipId, equipExp, fightNum, num, openlevel)
    -- debris : 碎片数量
    -- prayerId : 祈福师Id
    -- summonNum : 今天召唤次数
    -- bagIds : 背包中祈福唯一标示id列表
    -- bagExps : 背包中祈福经验列表
    -- bagPrayIds : 背包中祈福id列表
    -- roomIds : 祝福栏中祈福唯一标示id列表
    -- roomExps : 祝福栏中祈福经验列表
    -- roomPrayIds : 祝福栏中祈福id列表
    -- prayNum : 装备祈福珠孔（从1开始，没有装备祈福珠就不发）
    -- equipPrayId : 装备祈福珠id
    -- equipId : 装备祈福珠唯一标示Id
    -- equipExp : 装备祈福珠经验
    -- fightNum : 祈福珠战斗力
    -- num : 装备栏索引
    -- openlevel : 装备栏开启等级
    WZLog("ProtocolProcessorBless:parse_PRAY_GetPrayMessOk")
    if WndBless.m_root and g_blessDataGetIndex == 1 then
        WndBless:setData(debris, prayerId, summonNum, bagIds, bagExps, bagPrayIds, roomIds, roomExps, roomPrayIds, prayNum, equipPrayId, equipId, equipExp, fightNum, num, openlevel)
    end
    if WndBlessBag.m_root and g_blessDataGetIndex == 2 then
        WndBlessBag:setData(bagIds, bagExps, bagPrayIds, prayNum, equipPrayId, equipId, equipExp, fightNum, num, openlevel)
    end
end

--@brief    返回祈福结果（PRAY_PrayOk = 4）
function ProtocolProcessorBless:parse_PRAY_PrayOk(id, prayId, exp, prayerId)
    -- id : 祈福得到祈福珠唯一标示id列表(-1为得到碎片)
    -- prayId : 祈福得到祈福珠列表(id为-1这个值是碎片Id)
    -- exp : 祝福珠经验列表(id为-1这个值是碎片数量)
    -- prayerId : 祈福师id列表
    WZLog("ProtocolProcessorBless:parse_PRAY_PrayOk", id:size())
    WndBless:blessSuccess(id, prayId, exp, prayerId)
end

--@brief    返回单次吞噬结果（PRAY_DevourOk = 6）
function ProtocolProcessorBless:parse_PRAY_DevourOk(devourId, exp, prayId, ids, fighting)
    -- devourId : 吞噬后祈福珠唯一标示Id
    -- exp : 经验
    -- prayId : 祈福珠id
    -- ids : 被吞噬的祈福珠id
    -- fighting :战力
    WZLog("ProtocolProcessorBless:parse_PRAY_DevourOk", fighting)
    WndDevour:onceDevourOk(devourId, exp, prayId, VectorToTable(ids), fighting)
end

--@brief    祈福珠换到背包结果（PRAY_ChangeBagOk = 8）
function ProtocolProcessorBless:parse_PRAY_ChangeBagOk(prayIds)
    -- prayIds : 背包中祈福唯一标示id列表
    WZLog("ProtocolProcessorBless:parse_PRAY_ChangeBagOk")
    WndBless:pickupOK(VectorToTable(prayIds))
end

--@brief    出售垃圾祈福珠结果（PRAY_SellOk = 10）
function ProtocolProcessorBless:parse_PRAY_SellOk(prayIds)
    -- prayIds : 成功出售祈福珠Id列表
    WZLog("ProtocolProcessorBless:parse_PRAY_SellOk")
    WndBless:sellOutOK(VectorToTable(prayIds))
end

--@brief    召唤祈福师结果（PRAY_CallOk = 12）
function ProtocolProcessorBless:parse_PRAY_CallOk(prayerId)
    -- prayerId : 成功召唤的祈福师Id
    WZLog("ProtocolProcessorBless:parse_PRAY_CallOk")
    WndBless:callBlessMenOK(prayerId)
end

--@brief    祈福珠操作结果（PRAY_EquipOk = 14）
function ProtocolProcessorBless:parse_PRAY_EquipOk(prayNum, equipPrayId, equipId, equipLevel, bagIds, bagExps, bagPrayIds, fightNum)
    -- prayNum : 装备祈福珠孔（从1开始，没有装备祈福珠就不发）
    -- equipPrayId : 装备祈福珠id
    -- equipId : 装备祈福珠唯一标示Id
    -- equipLevel : 装备祈福珠经验
    -- bagIds : 背包中祈福唯一标示id列表
    -- bagExps : 背包中祈福经验列表
    -- bagPrayIds : 背包中祈福id列表
    -- fightNum : 祈福珠战斗力
    WZLog("ProtocolProcessorBless:parse_PRAY_EquipOk")

    WndBlessBag:operateOK(prayNum, equipPrayId, equipId, equipLevel, bagIds, bagExps, bagPrayIds, fightNum)
end

--@brief    一键吞噬结果（PRAY_FastDevourOk = 16）
function ProtocolProcessorBless:parse_PRAY_FastDevourOk(devourId, exp, prayId, ids)
    -- devourId : 吞噬后祈福珠唯一标示Id
    -- exp : 经验
    -- prayId : 祈福珠id
    -- ids : 被吞噬的祈福珠id
    WZLog("ProtocolProcessorBless:parse_PRAY_FastDevourOk")
    WndBless:devourAllOK(devourId, exp, prayId, VectorToTable(ids))
end

--@brief    一键装备祈福珠结果（PRAY_FastEquipOk = 25）
function ProtocolProcessorBless:parse_PRAY_FastEquipOk(index, equipId, fightNum)
    -- index : 装备祈福珠孔（从1开始，没有装备祈福珠就不发）
    -- equipId : 装备祈福珠唯一标示Id
    -- fightNum : 祈福珠战斗力
    WZLog("ProtocolProcessorBless:parse_PRAY_FastEquipOk")

    WndBlessBag:oneKeyEquipOK(VectorToTable(index), VectorToTable(equipId), fightNum)
end

--@brief    获取拉杆信息（PRAY_GetRaffleInfoOk = 27）
function ProtocolProcessorBless:parse_PRAY_GetRaffleInfoOk(raffleMark, status, raffleNum, raffleReset)
    -- raffleMark : 拉杆显示的标志
    -- status : 状态（0为可拉杆，1为可领奖励）
    -- raffleNum : 今天拉杆次数
    -- raffleReset : 今天更改结果次数
    WZLog("ProtocolProcessorBless:parse_PRAY_GetRaffleInfoOk")
    WndClownTreasure:setTreasureInfo(VectorToTable(raffleMark), status, raffleNum, raffleReset)
end

--@brief    拉杆抽奖（PRAY_RaffleOk = 29）
function ProtocolProcessorBless:parse_PRAY_RaffleOk(raffleMark)
    -- raffleMark : 拉杆显示的标志
    WZLog("ProtocolProcessorBless:parse_PRAY_RaffleOk")
    WndClownTreasure:raffleSuccess(VectorToTable(raffleMark))
end

--@brief    领取摇杆奖励（PRAY_GiveRaffleRewardOk = 33）
function ProtocolProcessorBless:parse_PRAY_GiveRaffleRewardOk(itemId, itemNum, status)
    -- itemId : 物品Id
    -- itemNum : 物品数量
    -- status : 状态（0为可拉杆，1为可领奖励）
    WZLog("ProtocolProcessorBless:parse_PRAY_GiveRaffleRewardOk ")
    WndClownTreasure:receiveGoods(VectorToTable(itemId),VectorToTable(itemNum),status)
end

--@brief    拉杆抽奖（PRAY_ResetRaffle = 31）
function ProtocolProcessorBless:parse_PRAY_ResetRaffleOk(raffleMark)
    -- raffleMark : 重置后的标志
    WZLog("ProtocolProcessorBless:parse_PRAY_ResetRaffleOk")
    WndClownTreasure:resertSingleSlot(raffleMark)
end


---------------------------------------协议错误处理方法模块--------------------------------------
--@brief    获取祈福信息（PRAY_GetPrayMess = 1）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorBless:send_PRAY_GetPrayMess_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorBless:send_PRAY_GetPrayMess_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TRATE, Protocol.PRAY_GetPrayMess, nflag, sMessage)
end

--@brief    祈福（PRAY_Pray = 3）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorBless:send_PRAY_Pray_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorBless:send_PRAY_Pray_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TRATE, Protocol.PRAY_Pray, nflag, sMessage)
end

--@brief    单次吞噬（PRAY_Devour = 5）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorBless:send_PRAY_Devour_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorBless:send_PRAY_Devour_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TRATE, Protocol.PRAY_Devour, nflag, sMessage)
end

--@brief    祈福珠换到背包（PRAY_ChangeBag = 7）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorBless:send_PRAY_ChangeBag_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorBless:send_PRAY_ChangeBag_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TRATE, Protocol.PRAY_ChangeBag, nflag, sMessage)
end

--@brief    出售垃圾祈福珠（PRAY_Sell = 9）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorBless:send_PRAY_Sell_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorBless:send_PRAY_Sell_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TRATE, Protocol.PRAY_Sell, nflag, sMessage)
end

--@brief    召唤祈福师（PRAY_Call = 11）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorBless:send_PRAY_Call_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorBless:send_PRAY_Call_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TRATE, Protocol.PRAY_Call, nflag, sMessage)
end

--@brief    祈福珠操作（PRAY_Equip = 13）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorBless:send_PRAY_Equip_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorBless:send_PRAY_Equip_ErrorProcess")
    WndBlessBag:_stopLoading()
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TRATE, Protocol.PRAY_Equip, nflag, sMessage)
end

--@brief    一键吞噬（PRAY_FastDevour = 15）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorBless:send_PRAY_FastDevour_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorBless:send_PRAY_FastDevour _ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TRATE, Protocol.PRAY_FastDevour , nflag, sMessage)
end

--@brief    一键装备祈福珠（PRAY_FastEquip = 24）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorBless:send_PRAY_FastEquip_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorBless:send_PRAY_FastEquip_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TRATE, Protocol.PRAY_FastEquip, nflag, sMessage)
end

--@brief    获取拉杆信息（PRAY_GetRaffleInfo = 26）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorBless:send_PRAY_GetRaffleInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorBless:send_PRAY_GetRaffleInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TRATE, Protocol.PRAY_GetRaffleInfo, nflag, sMessage)
end



--@brief    拉杆抽奖（PRAY_Raffle = 28）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorBless:send_PRAY_Raffle_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorBless:send_PRAY_Raffle_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TRATE, Protocol.PRAY_Raffle, nflag, sMessage)
end


--@brief    领取摇杆奖励（PRAY_GiveRaffleReward = 32）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorBless:send_PRAY_GiveRaffleReward_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorBless:send_PRAY_GiveRaffleReward_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TRATE, Protocol.PRAY_GiveRaffleReward, nflag, sMessage)
end

--@brief    重置结果（PRAY_ResetRaffle = 30）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorBless:send_PRAY_ResetRaffle_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorBless:send_PRAY_ResetRaffle_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TRATE, Protocol.PRAY_ResetRaffle, nflag, sMessage)
end
