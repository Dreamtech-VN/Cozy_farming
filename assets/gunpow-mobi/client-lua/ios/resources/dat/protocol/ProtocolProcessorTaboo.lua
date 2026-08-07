--ProtocolProcessorTaboo.lua
--@brief    禁忌之地系统相关协议
--@date     2017/5/2
--@note     禁忌之地系统相关协议


ProtocolProcessorTaboo = ProtocolProcessorBase:new()


--@brief    注册协议组所有协议
--@note     注册协议组所有协议
function ProtocolProcessorTaboo:regAll()
    --@brief 获取章节信息（ZONE_GetZoneInfo = 1）        错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ZONE, Protocol.ZONE_GetZoneInfo, "ProtocolProcessorTaboo:send_ZONE_GetZoneInfo_ErrorProcess", "is" )
    --@brief    获取章节信息（ZONE_GetZoneInfoOk = 2）      
    self:regProtocolCallbackFunction( Protocol.MAIN_ZONE, Protocol.ZONE_GetZoneInfoOk, "ProtocolProcessorTaboo:parse_ZONE_GetZoneInfoOk", "iivtvivtiviviiii")
    --@brief    投骰子（ZONE_RollDice = 3）      错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ZONE, Protocol.ZONE_RollDice, "ProtocolProcessorTaboo:send_ZONE_RollDice_ErrorProcess", "is" )
    --@brief    推送事件（ZONE_PushEvent = 4）
    self:regProtocolCallbackFunction( Protocol.MAIN_ZONE, Protocol.ZONE_PushEvent, "ProtocolProcessorTaboo:parse_ZONE_PushEvent", "iivsitiii")
    --@brief    获取宝箱信息（ZONE_GetBoxInfo= 5）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ZONE, Protocol.ZONE_GetBoxInfo, "ProtocolProcessorTaboo:send_ZONE_GetBoxInfo_ErrorProcess", "is" )
    --@brief    获取宝箱信息（ZONE_GetBoxInfoOk = 6）
    self:regProtocolCallbackFunction( Protocol.MAIN_ZONE, Protocol.ZONE_GetBoxInfoOk, "ProtocolProcessorTaboo:parse_ZONE_GetBoxInfoOk", "vtvivti")

    --@brief    普通宝箱,抉择（ZONE_ChoiceBox = 7）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ZONE, Protocol.ZONE_ChoiceBox, "ProtocolProcessorTaboo:send_ZONE_ChoiceBox_ErrorProcess", "is" )
    --@brief    普通宝箱,抉择（ZONE_ChoiceBoxOk = 8）
    self:regProtocolCallbackFunction( Protocol.MAIN_ZONE, Protocol.ZONE_ChoiceBoxOk, "ProtocolProcessorTaboo:parse_ZONE_ChoiceBoxOk", "svtvivti")
    --@brief    额外宝箱,抉择（ZONE_ChoiceDiamondBox = 9）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ZONE, Protocol.ZONE_ChoiceDiamondBox, "ProtocolProcessorTaboo:send_ZONE_ChoiceDiamondBox_ErrorProcess", "is" )
    --@brief    额外宝箱,抉择（ZONE_ChoiceDiamondBoxOk = 10）
    self:regProtocolCallbackFunction( Protocol.MAIN_ZONE, Protocol.ZONE_ChoiceDiamondBoxOk, "ProtocolProcessorTaboo:parse_ZONE_ChoiceDiamondBoxOk", "s")


    --@brief    购买骰子（ZONE_BuyDice = 11）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ZONE, Protocol.ZONE_BuyDice, "ProtocolProcessorTaboo:send_ZONE_BuyDice_ErrorProcess", "is" )
    --@brief    购买骰子（ZONE_BuyDiceOk = 12）
    self:regProtocolCallbackFunction( Protocol.MAIN_ZONE, Protocol.ZONE_BuyDiceOk, "ProtocolProcessorTaboo:parse_ZONE_BuyDiceOk", "iiii")

    --@brief    推送地图刷新（ZONE_PushMapRefresh = 13）
    self:regProtocolCallbackFunction( Protocol.MAIN_ZONE, Protocol.ZONE_PushMapRefresh, "ProtocolProcessorTaboo:parse_ZONE_PushMapRefresh", "ivivi")

    --@brief    获取骰子状态（ZONE_GetDiceStatus = 14）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ZONE, Protocol.ZONE_GetDiceStatus, "ProtocolProcessorTaboo:send_ZONE_GetDiceStatus_ErrorProcess", "is" )
    --@brief    获取骰子状态（ZONE_GetDiceStatusOk = 15）
    self:regProtocolCallbackFunction( Protocol.MAIN_ZONE, Protocol.ZONE_GetDiceStatusOk, "ProtocolProcessorTaboo:parse_ZONE_GetDiceStatusOk", "iii")

end



--@brief    反注册协议组所有协议
--@note     反注册协议组所有协议
function ProtocolProcessorTaboo:unregAll()
    self:clearReg()
end


--------------------------客户端到服务器协议发送方法模块----------------------------------
--@brief    获取章节信息（ZONE_GetZoneInfo = 1）        
function ProtocolProcessorTaboo:send_ZONE_GetZoneInfo(chapterId )
    WZLog("send_ZONE_GetZoneInfo")
    local sender = Protocol:getSender( Protocol.MAIN_ZONE, Protocol.ZONE_GetZoneInfo )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( chapterId )    -- 章节id(-1:最后一次进入的章节)
    SendProtocol(sender,false) --true:showLoading
end

--@brief    投骰子（ZONE_RollDice = 3）      
function ProtocolProcessorTaboo:send_ZONE_RollDice(chapterId )
    WZLog("send_ZONE_RollDice")
    local sender = Protocol:getSender( Protocol.MAIN_ZONE, Protocol.ZONE_RollDice )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( chapterId )    -- 章节id
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取宝箱信息（ZONE_GetBoxInfo= 5）
function ProtocolProcessorTaboo:send_ZONE_GetBoxInfo( )
    WZLog("send_ZONE_GetBoxInfo")
    local sender = Protocol:getSender( Protocol.MAIN_ZONE, Protocol.ZONE_GetBoxInfo)
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    普通宝箱,抉择（ZONE_ChoiceBox = 7）
function ProtocolProcessorTaboo:send_ZONE_ChoiceBox(choiceType, index )
    WZLog("send_ZONE_ChoiceBox")
    local sender = Protocol:getSender( Protocol.MAIN_ZONE, Protocol.ZONE_ChoiceBox )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeByte( choiceType )  -- 操作类型,1:解锁宝箱;2:领取奖励;3:立即打开;4:放弃宝箱
    sender:writeByte( index )   -- 宝箱下标
    SendProtocol(sender,false) --true:showLoading
end

--@brief    额外宝箱,抉择（ZONE_ChoiceDiamondBox = 9）
function ProtocolProcessorTaboo:send_ZONE_ChoiceDiamondBox(choiceType )
    WZLog("send_ZONE_ChoiceDiamondBox ")
    local sender = Protocol:getSender( Protocol.MAIN_ZONE, Protocol.ZONE_ChoiceDiamondBox  )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeByte( choiceType )  -- 1:立即打开;2:放弃
    SendProtocol(sender,false) --true:showLoading
end

--@brief    购买骰子（ZONE_BuyDice = 11）
function ProtocolProcessorTaboo:send_ZONE_BuyDice(buyNum )
    WZLog("send_ZONE_BuyDice")
    local sender = Protocol:getSender( Protocol.MAIN_ZONE, Protocol.ZONE_BuyDice )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( buyNum )   -- 购买的个数
    SendProtocol(sender,false) --true:showLoading
end



--@brief    获取骰子状态（ZONE_GetDiceStatus = 14）
function ProtocolProcessorTaboo:send_ZONE_GetDiceStatus( )
    WZLog("send_ZONE_GetDiceStatus")
    local sender = Protocol:getSender( Protocol.MAIN_ZONE, Protocol.ZONE_GetDiceStatus )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--------------------------服务器到客户端协议回调方法模块----------------------------------
--@brief    获取章节信息（ZONE_GetZoneInfoOk = 2）      
function ProtocolProcessorTaboo:parse_ZONE_GetZoneInfoOk(currentChapterId, currentIndex, boxIndex, boxId, boxStatus, boxCountdown, eventIndex, eventCellId, diceNum, buyDiceNum, diceResumeCountdown)
    -- currentChapterId : 当前章节id
    -- currentIndex : 位置下标(起点下标为0)
    -- boxIndex : 宝箱下标
    -- boxId : 宝箱物品id
    -- boxStatus : 宝箱状态
    -- boxCountdown : 宝箱解锁倒计时(s)
    -- eventIndex : 下标(只发送存在事件的下标)
    -- eventCellId : 格子id
    -- diceNum : 骰子数目
    -- buyDiceNum : 本日已购买骰子数目
    -- diceResumeCountdown : 骰子恢复倒计时
    WZLog("ProtocolProcessorTaboo:parse_ZONE_GetZoneInfoOk")

    CacheCenter:updateBuyTabooCoinTimes(buyDiceNum)

    local data = {}
    data.currentChapterId = currentChapterId
    data.currentIndex = currentIndex
    data.boxIndex = VectorToTable(boxIndex)
    data.boxId = VectorToTable(boxId)
    data.boxStatus = VectorToTable(boxStatus)
    data.boxCountdown = boxCountdown
    data.eventIndex = VectorToTable(eventIndex)
    data.eventCellId = VectorToTable(eventCellId)
    data.diceResumeCountdown = VectorToTable(diceResumeCountdown)
    
    SceneTabooBattle:updateData(data)
end

--@brief    推送事件（ZONE_PushEvent = 4）
function ProtocolProcessorTaboo:parse_ZONE_PushEvent(chapterId, point, jsonParam, normalBoxId, normalBoxStatus, extraBoxId, diceNum, diceResumeCountdown)
    -- chapterId : 章节id
    -- point : 骰子点数
    -- jsonParam : json格式的事件参数
    -- normalBoxId : 普通宝箱id
    -- normalBoxStatus : 普通宝箱状态(0:格子足够;1:格子不足,需要抉择;2:格子不足,自动放弃)
    -- extraBoxId : 额外宝箱id(为0则表示没有出现额外宝箱)
    -- diceNum : 当前骰子的数目
    -- diceResumeCountdown : 骰子恢复倒计时
    WZLog("ProtocolProcessorTaboo:parse_ZONE_PushEvent")
    SceneTabooBattle:throwDiceBack(point,VectorToTable(jsonParam),normalBoxId,normalBoxStatus,extraBoxId)
    SceneTabooBattle:updateDiceData(diceResumeCountdown)
end


--@brief    获取宝箱信息（ZONE_GetBoxInfoOk = 6）
function ProtocolProcessorTaboo:parse_ZONE_GetBoxInfoOk(index, boxId, status, countdown)
    -- index : 下标
    -- boxId : 宝箱id
    -- status : 状态
    -- countdown : 倒计时
    WZLog("ProtocolProcessorTaboo:parse_ZONE_GetBoxInfoOk")
    if countdown > 0 then
        CacheCenter.m_nTabooBoxCountDown = countdown + SystemTime:getServerTime()
    end
    SceneTabooBattle:updateBoxData(VectorToTable(index),VectorToTable(boxId),VectorToTable(status),countdown)
end


--@brief    普通宝箱,抉择（ZONE_ChoiceBoxOk = 8）
function ProtocolProcessorTaboo:parse_ZONE_ChoiceBoxOk(rewardStr, index, boxId, status, countdown)
    -- rewardStr : 奖励
    -- index : 宝箱下标
    -- boxId : 宝箱id
    -- status : 状态
    -- countdown : 倒计时
    WZLog("ProtocolProcessorTaboo:parse_ZONE_ChoiceBoxOk",rewardStr,Serialize(VectorToTable(boxId)))
    if rewardStr ~= "" then
        SceneTabooBattle.g_rewardIds,SceneTabooBattle.g_nums = SplitItemString(rewardStr)
        SceneTabooBattle:showBoxSpineView()

        -- local ids,nums = SplitItemString(rewardStr)
        -- WndRewardShow:showById(ids,nums)
    end
    if countdown > 0 then
        CacheCenter.m_nTabooBoxCountDown = countdown + SystemTime:getServerTime()
    end
    --溢出宝箱不刷新
    if ProtocolProcessorTaboo.g_bOffRushBox then
        ProtocolProcessorTaboo.g_bOffRushBox = nil
    else
        SceneTabooBattle:updateBoxData(VectorToTable(index),VectorToTable(boxId),VectorToTable(status),countdown)
    end
end

--@brief    额外宝箱,抉择（ZONE_ChoiceDiamondBoxOk = 10）
function ProtocolProcessorTaboo:parse_ZONE_ChoiceDiamondBoxOk(reward)
    -- reward : 奖励
    WZLog("ProtocolProcessorTaboo:parse_ZONE_ChoiceDiamondBoxOk",reward)
    if reward ~= "" then
        local ids,nums = SplitItemString(reward)
        WndRewardShow:showById(ids,nums)
        SceneTabooBattle:updateTopHandlerNum()
    end
end


--@brief    购买骰子（ZONE_BuyDiceOk = 12）
function ProtocolProcessorTaboo:parse_ZONE_BuyDiceOk(diceNum, buyTimes,diceResumeCountdown,addNum)
    -- diceNum : 骰子个数
    -- buyTimes : 已购买次数
    WZLog("ProtocolProcessorTaboo:parse_ZONE_BuyDiceOk")
    CacheCenter:updateBuyTabooCoinTimes(buyTimes)
    SceneTabooBattle:updateDiceData(diceResumeCountdown)
    if WndBuyActivity.m_root then
        WndBuyActivity:setBuyResultData(TableToVector(WndBuyActivity.m_tResultAddNum,WZLuaVector_int_), TableToVector({1,1,1,1,1},WZLuaVector_int_), 15, nil, buyTimes)
    end
end

--@brief    推送地图刷新（ZONE_PushMapRefresh = 13）
function ProtocolProcessorTaboo:parse_ZONE_PushMapRefresh(chapterId, eventIndex, eventCellId)
    -- chapterId : 章节id
    -- eventIndex : 下标(只发送存在事件的下标)
    -- eventCellId : 格子id
    WZLog("ProtocolProcessorTaboo:parse_ZONE_PushMapRefresh")
    SceneTabooBattle.g_eventIndex = VectorToTable(eventIndex)
    SceneTabooBattle.g_eventCellId = VectorToTable(eventCellId)
end

--@brief    获取骰子状态（ZONE_GetDiceStatusOk = 15）
function ProtocolProcessorTaboo:parse_ZONE_GetDiceStatusOk(diceNum, buyTimes, diceResumeCountdown)
    -- diceNum : 骰子个数
    -- buyTimes : 已购买次数
    -- diceResumeCountdown : 骰子恢复倒计时
    WZLog("ProtocolProcessorTaboo:parse_ZONE_GetDiceStatusOk")
    CacheCenter:updateBuyTabooCoinTimes(buyTimes)
    SceneTabooBattle:updateDiceData(diceResumeCountdown)
end


--------------------------------协议错误处理方法模块--------------------------------------
--@brief    获取章节信息（ZONE_GetZoneInfo = 1）        错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorTaboo:send_ZONE_GetZoneInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorTaboo:send_ZONE_GetZoneInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ZONE, Protocol.ZONE_GetZoneInfo, nflag, sMessage)
end

--@brief    投骰子（ZONE_RollDice = 3）      错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorTaboo:send_ZONE_RollDice_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorTaboo:send_ZONE_RollDice_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ZONE, Protocol.ZONE_RollDice, nflag, sMessage)
    SceneTabooBattle:isOpenLockedScene(true)
end

--@brief    获取宝箱信息（ZONE_GetBoxInfo= 5）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorTaboo:send_ZONE_GetBoxInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorTaboo:send_ZONE_GetBoxInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ZONE, Protocol.ZONE_GetBoxInfo, nflag, sMessage)
end

--@brief    普通宝箱,抉择（ZONE_ChoiceBox = 7）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorTaboo:send_ZONE_ChoiceBox_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorTaboo:send_ZONE_ChoiceBox_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ZONE, Protocol.ZONE_ChoiceBox, nflag, sMessage)
end

--@brief    额外宝箱,抉择（ZONE_ChoiceDiamondBox = 9）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorTaboo:send_ZONE_ChoiceDiamondBox_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorTaboo:send_ZONE_ChoiceDiamondBox_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ZONE, Protocol.ZONE_ChoiceDiamondBox, nflag, sMessage)
end

--@brief    购买骰子（ZONE_BuyDice = 11）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorTaboo:send_ZONE_BuyDice_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorTaboo:send_ZONE_BuyDice_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ZONE, Protocol.ZONE_BuyDice, nflag, sMessage)
end

--@brief    获取骰子状态（ZONE_GetDiceStatus = 14）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorTaboo:send_ZONE_GetDiceStatus_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorTaboo:send_ZONE_GetDiceStatus_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ZONE, Protocol.ZONE_GetDiceStatus, nflag, sMessage)
end