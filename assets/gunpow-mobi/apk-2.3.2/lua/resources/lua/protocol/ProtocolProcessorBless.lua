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
    self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.PRAY_GetPrayMessOk, "ProtocolProcessorBless:parse_PRAY_GetPrayMessOk", "vivivivivivivivii")

    --@brief    返回祈福结果（PRAY_PrayOk = 4）
    self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.PRAY_PrayOk, "ProtocolProcessorBless:parse_PRAY_PrayOk", "vivivi")
    --@brief    返回单次吞噬结果（PRAY_DevourOk = 6）
    self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.PRAY_DevourOk, "ProtocolProcessorBless:parse_PRAY_DevourOk", "iiivii")
    --@brief    开启祈福(PRAY_EquipOk=14) 
    self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.PRAY_EquipOk, "ProtocolProcessorBless:parse_PRAY_EquipOk", "i")
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
    --@brief    开启祈福(PRAY_Equip=13) 错误处理(S->C)
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

    --@brief    祈福刷新 (PRAY_RePrayShop = 34)
    self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.PRAY_RePrayShop, "ProtocolProcessorBless:send_PRAY_RePrayShop_ErrorProcess", "is")
   

    
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
function ProtocolProcessorBless:send_PRAY_Pray(typeId ,devour)
    WZLog("send_PRAY_Pray",typeId,devour)
    local sender = Protocol:getSender( Protocol.MAIN_TRATE, Protocol.PRAY_Pray )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( typeId )   -- 祈福类型（祈福类型 0低额单次祈福 1低额十次祈福 2高额单次祈福 3高额十次祈福）
    sender:writeInt( devour )   -- 是否一键吞噬 0否 1是
    SendProtocol(sender,false) --true:showLoading
end

--@brief    单次吞噬（PRAY_Devour = 5）
function ProtocolProcessorBless:send_PRAY_Devour(prayNum, prayIds )
    WZLog("send_PRAY_Devour", 
        "\nprayNum",Serialize(VectorToTable(prayNum)),
        "\nprayIds",Serialize(VectorToTable(prayIds)))
    local sender = Protocol:getSender( Protocol.MAIN_TRATE, Protocol.PRAY_Devour )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt(prayNum)    -- 装备祈福配置id
    sender:writeInts(prayIds)   -- 需要吞噬的祈福唯一id
    SendProtocol(sender,false) --true:showLoading
end

--@brief    开启祈福(PRAY_Equip=13) 
function ProtocolProcessorBless:send_PRAY_Equip(bId)
    WZLog("send_PRAY_Equip",bId)
    local sender = Protocol:getSender( Protocol.MAIN_TRATE, Protocol.PRAY_Equip )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( bId ) -- 祈福配置id 
    SendProtocol(sender,false) --true:showLoading
end

--@brief    一键吞噬（PRAY_FastDevour = 15）
function ProtocolProcessorBless:send_PRAY_FastDevour ( )
    WZLog("send_PRAY_FastDevour ")
    local sender = Protocol:getSender( Protocol.MAIN_TRATE, Protocol.PRAY_FastDevour  )
    if sender==nil then WZLog("sender == nil") return end

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

--@brief    祈福刷新（PRAY_RePrayShop = 34）
function ProtocolProcessorBless:send_PRAY_RePrayShop()
    -- body
    WZLog("send_PRAY_RePrayShop")
    local sender = Protocol:getSender( Protocol.MAIN_TRATE, Protocol.PRAY_RePrayShop)
    if sender == nil then WZLog("sender == nil") return end
    SendProtocol(sender,false)
end

---------------------------------服务器到客户端协议回调方法模块----------------------------------
-- --@brief    获取祈福信息成功（PRAY_GetPrayMessOk = 2）
function ProtocolProcessorBless:parse_PRAY_GetPrayMessOk(bagIds, bagExps, bagPrayIds, bagPrayNum, prayNum, equipPrayId, equipId, equipExp, fightNum)
    -- bagIds : 背包祈福唯一id
    -- bagExps : 背包祈福经验
    -- bagPrayIds : 背包祈福id
    -- bagPrayNum : 祈福珠数量
    -- prayNum : 装备祈福配置id
    -- equipPrayId : 装备祈福id
    -- equipId : 装备祈福唯一id
    -- equipExp : 装备祈福经验
    -- fightNum : 祈福战力
    WZLog("ProtocolProcessorBless:parse_PRAY_GetPrayMessOk",
        "\nbagIds",Serialize(VectorToTable(bagIds)),
        "\nbagExps",Serialize(VectorToTable(bagExps)),
        "\nbagPrayIds",Serialize(VectorToTable(bagPrayIds)),
        "\nbagPrayNum",Serialize(VectorToTable(bagPrayNum)),
        "\nprayNum",Serialize(VectorToTable(prayNum)),
        "\nequipPrayId",Serialize(VectorToTable(equipPrayId)),
        "\nequipId",Serialize(VectorToTable(equipId)),
        "\nequipExp",Serialize(VectorToTable(equipExp)),
        "\nfightNum",Serialize(VectorToTable(fightNum)))

    -- if WndBless.m_root and g_blessDataGetIndex == 1 then
    --     WndBless:setData(time, bagIds, bagExps, bagPrayIds, prayNum, equipPrayId, equipId, equipExp, fightNum, num, openlevel)
    -- end
    if WndBlessBag.m_root and g_blessDataGetIndex == 2 then
        -- WndBlessBag:setData(bagIds, bagExps, bagPrayIds, prayNum, equipPrayId, equipId, equipExp, fightNum, num, openlevel)
        WndBlessBag:setBlessData(bagIds, bagExps, bagPrayIds, bagPrayNum, prayNum, equipPrayId, equipId, equipExp, fightNum)
    end
    if SceneCity.m_root and CheckButtonOpen(ISLAND_UP_BLESS,true) then
        -- SceneCity:updateRedDotBuilding("bless", time == 0, GlobalMethod:ccp(100,40))
        -- WndSummonEntrance:updateRedPoint(nil, nil, nil, time == 0)
    end
end

--@brief    返回祈福结果（PRAY_PrayOk = 4）
function ProtocolProcessorBless:parse_PRAY_PrayOk(id, prayId, exp)
    -- id : 祈福得到祈福珠唯一标示id列表(-1为得到碎片)
    -- prayId : 祈福得到祈福珠列表(id为-1这个值是碎片Id)
    -- exp : 祝福珠经验列表(id为-1这个值是碎片数量)
    WZLog("ProtocolProcessorBless:parse_PRAY_PrayOk",
        "\nid",Serialize(VectorToTable(id)),
        "\nprayId",Serialize(VectorToTable(prayId)),
        "\nexp",Serialize(VectorToTable(exp)))

    WndBless:blessSuccess(VectorToTable(id),VectorToTable(prayId),VectorToTable(exp))
end

--@brief    返回单次吞噬结果（PRAY_DevourOk = 6）
function ProtocolProcessorBless:parse_PRAY_DevourOk(devourId, exp, prayId, ids, fighting)
    -- devourId : 吞噬后祈福珠唯一标示Id
    -- exp : 经验
    -- prayId : 祈福珠id
    -- ids : 被吞噬的祈福珠id
    -- fighting :战力
    WZLog("ProtocolProcessorBless:parse_PRAY_DevourOk",
        "\ndevourId",Serialize(VectorToTable(devourId)),
        "\nexp",Serialize(VectorToTable(exp)),
        "\nprayId",Serialize(VectorToTable(prayId)),
        "\nids",Serialize(VectorToTable(ids)),
        "\nfighting",Serialize(VectorToTable(fighting)))

    if WndDevour.m_root then
        WndDevour:onceDevourOk(devourId, exp, prayId, VectorToTable(ids), fighting)
    end
    if WndDevour1.m_root then
        WndDevour1:onceDevourOk(devourId, exp, prayId, VectorToTable(ids), fighting)
    end
    if WndBless.m_root then
        WndBless:onceDevourOk(devourId, exp, prayId, VectorToTable(ids), fighting)
    end
    if WndBlessBag.m_root then
        WndBlessBag:onceDevourOk(devourId, exp, prayId, VectorToTable(ids), fighting)
    end
end

-- --@brief    祈福珠操作结果（PRAY_EquipOk = 14）
-- function ProtocolProcessorBless:parse_PRAY_EquipOk(prayNum, equipPrayId, equipId, equipLevel, bagIds, bagExps, bagPrayIds, fightNum)
--     -- prayNum : 装备祈福珠孔（从1开始，没有装备祈福珠就不发）
--     -- equipPrayId : 装备祈福珠id
--     -- equipId : 装备祈福珠唯一标示Id
--     -- equipLevel : 装备祈福珠经验
--     -- bagIds : 背包中祈福唯一标示id列表
--     -- bagExps : 背包中祈福经验列表
--     -- bagPrayIds : 背包中祈福id列表
--     -- fightNum : 祈福珠战斗力
--     WZLog("ProtocolProcessorBless:parse_PRAY_EquipOk")

--     WndBlessBag:operateOK(prayNum, equipPrayId, equipId, equipLevel, bagIds, bagExps, bagPrayIds, fightNum)
-- end
--@brief    开启祈福(PRAY_EquipOk=14) 
function ProtocolProcessorBless:parse_PRAY_EquipOk(bId)
    -- bId  : 祈福配置id 
    WZLog("ProtocolProcessorBless:parse_PRAY_EquipOk", bId)
    if WndBlessBag.m_root then
        WndBlessBag:activateBlessOk(bId)
    end
end


--@brief    一键吞噬结果（PRAY_FastDevourOk = 16）
function ProtocolProcessorBless:parse_PRAY_FastDevourOk(devourId, exp, prayId, ids)
    -- devourId : 吞噬后祈福珠唯一标示Id
    -- exp : 经验
    -- prayId : 祈福珠id
    -- ids : 被吞噬的祈福珠id
    WZLog("ProtocolProcessorBless:parse_PRAY_FastDevourOk",devourId, exp, prayId, Serialize(VectorToTable(ids)))
    -- if WndBless.m_root then
    --     WndBless:devourAllOK(devourId, exp, prayId, VectorToTable(ids))
    -- end
    if WndBlessBag.m_root then
        WndBlessBag:devourAllOK(devourId, exp, prayId, VectorToTable(ids))
    end
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

--@brief    开启祈福(PRAY_Equip=13) 错误处理函数(S->C)
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

--@brief    祈福刷新(PRAY_RePrayShop = 34) 错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorBless:send_PRAY_RePrayShop_ErrorProcess(nFlag, sMessage)
    -- body
    WZLog("ProtocolProcessorBless:send_PRAY_RePrayShop_ErrorProcess")
    ProtocolProcessorBless:errorProcess(Protocol.MAIN_TRATE, Protocol.PRAY_RePrayShop, nFlag, sMessage)
end