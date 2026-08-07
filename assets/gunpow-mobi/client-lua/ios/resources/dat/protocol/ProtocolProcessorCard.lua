--ProtocolProcessorCard.lua
--@brief    卡牌系统相关协议
--@date     2016/4/14
--@author   Tianxiang_Xu
--@note     卡牌系统相关协议


ProtocolProcessorCard = ProtocolProcessorBase:new()


--@brief    注册协议组所有协议
--@note     注册协议组所有协议
function ProtocolProcessorCard:regAll()
    --@brief    获取卡牌信息（CARD_GetCardMesOk = 2）
    self:regProtocolCallbackFunction( Protocol.MAIN_CARD, Protocol.CARD_GetCardMesOk, "ProtocolProcessorCard:parse_CARD_GetCardMesOk", "vivivivivsvsviviivi")
    --@brief    升级卡牌（CARD_UpCardOk = 4）
    self:regProtocolCallbackFunction( Protocol.MAIN_CARD, Protocol.CARD_UpCardOk, "ProtocolProcessorCard:parse_CARD_UpCardOk", "")
    --@brief    激活卡牌（CARD_ActivationCardOk = 8）
    self:regProtocolCallbackFunction( Protocol.MAIN_CARD, Protocol.CARD_ActivationCardOk, "ProtocolProcessorCard:parse_CARD_ActivationCardOk", "i")
    --@brief    获取宝箱列表（CARD_GetCardSetListOk = 10）
    self:regProtocolCallbackFunction( Protocol.MAIN_CARD, Protocol.CARD_GetCardSetListOk, "ProtocolProcessorCard:parse_CARD_GetCardSetListOk", "viviii")
    --@brief    开启宝箱（CARD_OpenCardSetOk = 12）
    self:regProtocolCallbackFunction( Protocol.MAIN_CARD, Protocol.CARD_OpenCardSetOk, "ProtocolProcessorCard:parse_CARD_OpenCardSetOk", "iviviii")
    --@brief    加速成功（CARD_SpeedUpOk = 15）
    self:regProtocolCallbackFunction( Protocol.MAIN_CARD, Protocol.CARD_SpeedUpOk, "ProtocolProcessorCard:parse_CARD_SpeedUpOk", "ii")


    --@brief    获取卡牌信息（CARD_GetCardMes = 1）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_CARD, Protocol.CARD_GetCardMes, "ProtocolProcessorCard:send_CARD_GetCardMes_ErrorProcess", "is" )
    --@brief    升级卡牌（CARD_UpCard = 3）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_CARD, Protocol.CARD_UpCard, "ProtocolProcessorCard:send_CARD_UpCard_ErrorProcess", "is" )
    --@brief    查看卡牌（CARD_LookCard = 7）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_CARD, Protocol.CARD_LookCard, "ProtocolProcessorCard:send_CARD_LookCard_ErrorProcess", "is" )
    --@brief    获取宝箱列表（CARD_GetCardSetList = 9）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_CARD, Protocol.CARD_GetCardSetList, "ProtocolProcessorCard:send_CARD_GetCardSetList_ErrorProcess", "is" )
    --@brief    开启宝箱（CARD_OpenCardSet = 11）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_CARD, Protocol.CARD_OpenCardSet, "ProtocolProcessorCard:send_CARD_OpenCardSet_ErrorProcess", "is" )
    --@brief    加速（CARD_SpeedUp = 14）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_CARD, Protocol.CARD_SpeedUp, "ProtocolProcessorCard:send_CARD_SpeedUp_ErrorProcess", "is" )
end



--@brief    反注册协议组所有协议
--@note     反注册协议组所有协议
function ProtocolProcessorCard:unregAll()
    self:clearReg()
end


--------------------------客户端到服务器协议发送方法模块----------------------------------
--@brief    获取卡牌信息（CARD_GetCardMes = 1）
function ProtocolProcessorCard:send_CARD_GetCardMes()
    WZLog("send_CARD_GetCardMes")
    local sender = Protocol:getSender( Protocol.MAIN_CARD, Protocol.CARD_GetCardMes )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    升级卡牌（CARD_UpCard = 3）
function ProtocolProcessorCard:send_CARD_UpCard(itemId )
    WZLog("send_CARD_UpCard")
    local sender = Protocol:getSender( Protocol.MAIN_CARD, Protocol.CARD_UpCard )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( itemId )   -- 升级的物品Id
    SendProtocol(sender,false) --true:showLoading
end

--@brief    查看卡牌（CARD_LookCard = 7）
function ProtocolProcessorCard:send_CARD_LookCard(itemId )
    WZLog("send_CARD_LookCard")
    local sender = Protocol:getSender( Protocol.MAIN_CARD, Protocol.CARD_LookCard )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( itemId )   -- 查看的物品Id
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取宝箱列表（CARD_GetCardSetList = 9）
function ProtocolProcessorCard:send_CARD_GetCardSetList()
    WZLog("send_CARD_GetCardSetList")
    local sender = Protocol:getSender( Protocol.MAIN_CARD, Protocol.CARD_GetCardSetList )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    开启宝箱（CARD_OpenCardSet = 11）
function ProtocolProcessorCard:send_CARD_OpenCardSet(cardSetId )
    WZLog("send_CARD_OpenCardSet")
    local sender = Protocol:getSender( Protocol.MAIN_CARD, Protocol.CARD_OpenCardSet )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( cardSetId )    -- 宝箱id
    SendProtocol(sender,false) --true:showLoading
end

--@brief    加速（CARD_SpeedUp = 14）
function ProtocolProcessorCard:send_CARD_SpeedUp(cardSetId )
    WZLog("send_CARD_SpeedUp")
    local sender = Protocol:getSender( Protocol.MAIN_CARD, Protocol.CARD_SpeedUp )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( cardSetId or 0)    -- 宝箱id
    SendProtocol(sender,false) --true:showLoading
end
--------------------------服务器到客户端协议回调方法模块----------------------------------
--@brief    获取卡牌信息（CARD_GetCardMesOk = 2）
function ProtocolProcessorCard:parse_CARD_GetCardMesOk(itemId, level, num, shopId, shopItem, shopPrice, shopRebate, shopStatus, refreshCount,lookItemId)
    -- itemId : 物品Id
    -- level : 等级
    -- num : 数量
    -- position : 商店位置
    -- shopItemId : 商店物品Id
    -- buyNum : 该商店购买次数
    -- lookItemId : 查看過的卡牌Id
    WZLog("ProtocolProcessorCard:parse_CARD_GetCardMesOk")
    WndCard:setData(VectorToTable(itemId), VectorToTable(level), VectorToTable(num), VectorToTable(lookItemId))
end

--@brief    升级卡牌（CARD_UpCardOk = 4）
function ProtocolProcessorCard:parse_CARD_UpCardOk()
    WZLog("ProtocolProcessorCard:parse_CARD_UpCardOk")

    WndCard:upgradeSuccess()
end

--@brief    激活卡牌（CARD_ActivationCardOk = 8）
function ProtocolProcessorCard:parse_CARD_ActivationCardOk(itemId)
    -- itemId : 激活的物品Id
    WZLog("ProtocolProcessorCard:parse_CARD_ActivationCardOk")

    WndCard:activeCardSuccess(itemId)
end

--@brief    获取宝箱列表（CARD_GetCardSetListOk = 10）
function ProtocolProcessorCard:parse_CARD_GetCardSetListOk(cardSetId, count, cdTime, openNum)
    -- cardSetId : 宝箱id
    -- count : 宝箱数量
    -- cdTime : 宝箱CD（秒）
    -- openNum : 可开启数量
    WZLog("ProtocolProcessorCard:parse_CARD_GetCardSetListOk")
    WndCard:setCardBoxData(VectorToTable(cardSetId), VectorToTable(count), cdTime, openNum)
end

--@brief    开启宝箱（CARD_OpenCardSetOk = 12）
function ProtocolProcessorCard:parse_CARD_OpenCardSetOk(code, itemId, itemNum, cdTime, openNum)
    -- code : 宝箱开启状态0成功1道具不足
    -- itemId : 获得物品id
    -- itemNum : 获得物品数量
    -- cdTime : 宝箱CD（秒）
    -- openNum : 可开启数量
    WZLog("ProtocolProcessorCard:parse_CARD_OpenCardSetOk")
    WndOpenCardBox:openCardBoxOK(code, VectorToTable(itemId), VectorToTable(itemNum), cdTime, openNum)
end

--@brief    加速结果（CARD_SpeedUpOk = 15）
function ProtocolProcessorCard:parse_CARD_SpeedUpOk(result, cdTime)
    -- result : 0 失败 ,1：用卡牌加速道具加速成功 2：用钻石加速成功
    -- cdTime : 宝箱CD（秒）
    WZLog("ProtocolProcessorCard:parse_CARD_SpeedUpOk")
    WndCard:speedUpOK(result, cdTime)
end
--------------------------------协议错误处理方法模块--------------------------------------
--@brief    获取卡牌信息（CARD_GetCardMes = 1）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorCard:send_CARD_GetCardMes_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorCard:send_CARD_GetCardMes_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_CARD, Protocol.CARD_GetCardMes, nflag, sMessage)
end

--@brief    升级卡牌（CARD_UpCard = 3）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorCard:send_CARD_UpCard_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorCard:send_CARD_UpCard_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_CARD, Protocol.CARD_UpCard, nflag, sMessage)
end

--@brief    查看卡牌（CARD_LookCard = 7）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorCard:send_CARD_LookCard_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorCard:send_CARD_LookCard_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_CARD, Protocol.CARD_LookCard, nflag, sMessage)
end

--@brief    获取宝箱列表（CARD_GetCardSetList = 9）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorCard:send_CARD_GetCardSetList_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorCard:send_CARD_GetCardSetList_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_CARD, Protocol.CARD_GetCardSetList, nflag, sMessage)
end

--@brief    开启宝箱（CARD_OpenCardSet = 11）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorCard:send_CARD_OpenCardSet_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorCard:send_CARD_OpenCardSet_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_CARD, Protocol.CARD_OpenCardSet, nflag, sMessage)
    WndOpenCardBox:setOpenTab(false)
end

--@brief    加速（CARD_SpeedUp = 14）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorCard:send_CARD_SpeedUp_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorCard:send_CARD_SpeedUp_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_CARD, Protocol.CARD_SpeedUp, nflag, sMessage)
    WndOpenCardBox:setOpenTab(false)
end
