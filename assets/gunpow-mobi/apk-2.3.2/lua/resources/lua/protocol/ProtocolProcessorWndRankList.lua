--ProtocolProcessorWndRankList.lua
--@brief	排行榜相关协议
--@date  	2015/4/23
--@author 	hyq
--@note 	排行榜相关协议


ProtocolProcessorWndRankList = ProtocolProcessorBase:new()

-------------------------------------公有方法模块--------------------------------------
--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorWndRankList:regAll()

    --@brief	获取排行榜数据（RANK_GetRankRecord = 1）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_RANK, Protocol.RANK_GetRankRecord, "ProtocolProcessorWndRankList:send_RANK_GetRankRecord_ErrorProcess", "is" )

    --@brief    排行榜信息（RANK_GetRankRecordOK = 2）
    self:regProtocolCallbackFunction( Protocol.MAIN_RANK, Protocol.RANK_GetRankRecordOK, "ProtocolProcessorWndRankList:parse_RANK_GetRankRecordOK", "tvtvivivsvivivtvivsvsvsvsvsvsvsvtvsvivsvivivs")

    --@brief    获取玩家简单信息（PLAYER_GetSimpleInfoOK = 69）
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetSimpleInfoOK, "ProtocolProcessorWndRankList:parse_PLAYER_GetSimpleInfoOK", "vivsvivsvivivivivivivsvtvsvivivi")

    --@brief    获取个人排行榜数据（RANK_GetPlayerRankOK = 4）
    self:regProtocolCallbackFunction( Protocol.MAIN_RANK, Protocol.RANK_GetPlayerRankOK, "ProtocolProcessorWndRankList:parse_RANK_GetPlayerRankOK", "iiittt")

    --@brief    膜拜日志成功 (RANK_GetWorshipLogOK = 8）
    self:regProtocolCallbackFunction( Protocol.MAIN_RANK, Protocol.RANK_GetWorshipLogOK, "ProtocolProcessorWndRankList:parse_RANK_GetWorshipLogOK", "vsvivs")

    --@brief    获取玩家简单信息（PLAYER_GetSimpleInfo = 68）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetSimpleInfo, "ProtocolProcessorWndRankList:send_PLAYER_GetSimpleInfo_ErrorProcess", "is" )

    --@brief    获取个人排行榜数据（RANK_GetPlayerRank = 3）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_RANK, Protocol.RANK_GetPlayerRank, "ProtocolProcessorWndRankList:send_RANK_GetPlayerRank_ErrorProcess", "is" )

    --@brief    膜拜（RANK_Worship = 5）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_RANK, Protocol.RANK_Worship, "ProtocolProcessorWndRankList:send_RANK_Worship_ErrorProcess", "is" )

    --@brief    膜拜日志（RANK_GetWorshipLog = 7）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_RANK, Protocol.RANK_GetWorshipLog, "ProtocolProcessorWndRankList:send_RANK_GetWorshipLog_ErrorProcess", "is" )
    
    --@brief    获取烟花排行榜（RANK_GetFireworkRank = 9）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_RANK, Protocol.RANK_GetFireworkRank, "ProtocolProcessorWndRankList:send_RANK_GetFireworkRank_ErrorProcess", "is" )

    --@brief    获取烟花排行榜成功 (RANK_GetFireworkRankOK = 10）
    self:regProtocolCallbackFunction( Protocol.MAIN_RANK, Protocol.RANK_GetFireworkRankOK, "ProtocolProcessorWndRankList:parse_RANK_GetFireworkRankOK", "ivivivsvivivtvivtviviivii")

    self:regAll1()
end
function ProtocolProcessorWndRankList:regAll1()
    --@brief    膜拜成功（RANK_WorshipOK = 6）
    self:regProtocolCallbackFunction( Protocol.MAIN_RANK, Protocol.RANK_WorshipOK, "ProtocolProcessorWndRankList:parse_RANK_WorshipOK", "iii")
end

function ProtocolProcessorWndRankList:regAll2()
    --@brief    获取勋章信息PLAYER2_GetVipMedalInfoOk
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER2, Protocol.PLAYER2_GetVipMedalInfoOk, "ProtocolProcessorWndRankList:parse_PLAYER2_GetVipMedalInfoOk", "viviviviii")
    --@brief    勋章等级奖励返回PLAYER2_ReceiveVipMedalLevelRewardOk=4
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER2, Protocol.PLAYER2_ReceiveVipMedalLevelRewardOk, "ProtocolProcessorWndRankList:parse_PLAYER2_ReceiveVipMedalLevelRewardOk", "tivivi")
    --@brief    PLAYER2_ReceiveVipMedalStageOk 4-7  
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER2, Protocol.PLAYER2_ReceiveVipMedalStageOk, "ProtocolProcessorWndRankList:parse_PLAYER2_ReceiveVipMedalStageOk", "vivivsvs")
    --@brief    level:int 等级
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER2, Protocol.PLAYER2_ReceiveVipLevelRewardOk, "ProtocolProcessorWndRankList:parse_PLAYER2_ReceiveVipLevelRewardOk", "tivivi")

end

function ProtocolProcessorWndRankList:regAll3()
    --@brief    获取抽奖信息（PLAYER2_GetLotteryInfo = 23）
    self:regProtocolCallbackFunction(Protocol.MAIN_PLAYER2, Protocol.PLAYER2_GetLotteryInfo, "ProtocolProcessorWndRankList:send_PLAYER2_GetLotteryInfo_ErrorProcess", "is" )
    --@brief    获取抽奖信息成功(PLAYER2_GetLotteryInfoOk = 24)
    -- self:regProtocolCallbackFunction(4, 24, "ProtocolProcessorWndRankList:rrrrrrrrr","iiiiiVivi")
    self:regProtocolCallbackFunction(Protocol.MAIN_PLAYER2, Protocol.PLAYER2_GetLotteryInfoOk, "ProtocolProcessorWndRankList:parse_PLAYER2_GetLotteryInfoOk", "iviiii")
    --@brief    抽奖(PLAYER2_Lottery = 25)
    self:regProtocolCallbackFunction(Protocol.MAIN_PLAYER2, Protocol.PLAYER2_Lottery, "ProtocolProcessorWndRankList:send_PLAYER2_Lottery_ErrorProcess", "is")
    --@brief    抽奖成功(PLAYER2_LotteryOk = 26)
    self:regProtocolCallbackFunction(Protocol.MAIN_PLAYER2, Protocol.PLAYER2_LotteryOk, "ProtocolProcessorWndRankList:parse_PLAYER2_LotteryOk", "ivivivivivivs")
    --@brief    领取抽奖自选礼包(PLAYER2_GetLotteryReward = 27)
    self:regProtocolCallbackFunction(Protocol.MAIN_PLAYER2, Protocol.PLAYER2_GetLotteryReward, "ProtocolProcessorWndRankList:send_PLAYER2_GetLotteryReward_ErrorProcess", "is")
    --@brief    领取抽奖自选礼包成功(PLAYER2_GetLotteryReward = 28)
    self:regProtocolCallbackFunction(Protocol.MAIN_PLAYER2, Protocol.PLAYER2_GetLotteryRewardOk, "ProtocolProcessorWndRankList:parse_PLAYER2_GetLotteryRewardOk", "ivivi")
end

function ProtocolProcessorWndRankList:regAll4()
    -- body
    --@brief    分享（PLAYER2_ShareLotteryReward = 29）
    self:regProtocolCallbackFunction(Protocol.MAIN_PLAYER2, Protocol.PLAYER2_ShareLotteryReward, "ProtocolProcessorWndRankList:send_PLAYER2_ShareLotteryReward_ErrorProcess", "is" )
    --@brief    分享成功(PLAYER2_ShareLotteryRewardOk = 30)
    -- self:regProtocolCallbackFunction(4, 24, "ProtocolProcessorWndRankList:rrrrrrrrr","iiiiiVivi")
    self:regProtocolCallbackFunction(Protocol.MAIN_PLAYER2, Protocol.PLAYER2_ShareLotteryRewardOk, "ProtocolProcessorWndRankList:parse_PLAYER2_ShareLotteryRewardOk", "ivivi")
end

--@brief    反注册协议组所有协议
--@note     反注册协议组所有协议
function ProtocolProcessorWndRankList:unregAll()
    self:clearReg()
end

--@brief    反注册协议组所有协议
--@note     反注册协议组所有协议
function ProtocolProcessorWndRankList:unregAll2()
    --@brief    获取勋章信息PLAYER2_GetVipMedalInfoOk
    Protocol:unreg( Protocol.MAIN_PLAYER2, Protocol.PLAYER2_GetVipMedalInfoOk, "ProtocolProcessorWndRankList:parse_PLAYER2_GetVipMedalInfoOk", "viviviviii")
    --@brief    勋章等级奖励返回PLAYER2_ReceiveVipMedalLevelRewardOk=4
    Protocol:unreg( Protocol.MAIN_PLAYER2, Protocol.PLAYER2_ReceiveVipMedalLevelRewardOk, "ProtocolProcessorWndRankList:parse_PLAYER2_ReceiveVipMedalLevelRewardOk", "tivivi")
    --@brief    PLAYER2_ReceiveVipMedalStageOk 4-7  
    Protocol:unreg( Protocol.MAIN_PLAYER2, Protocol.PLAYER2_ReceiveVipMedalStageOk, "ProtocolProcessorWndRankList:parse_PLAYER2_ReceiveVipMedalStageOk", "vivivsvs")
    --@brief    level:int 等级
    Protocol:unreg( Protocol.MAIN_PLAYER2, Protocol.PLAYER2_ReceiveVipLevelRewardOk, "ProtocolProcessorWndRankList:parse_PLAYER2_ReceiveVipLevelRewardOk", "tivivi")
end

--@brief    分享 PLAYER2_ShareLotteryReward
function ProtocolProcessorWndRankList:send_PLAYER2_ShareLotteryReward(lType,itemName)
    -- body
    WZLog("send_PLAYER2_ShareLotteryReward",lType,itemName)
    local sender = Protocol:getSender(Protocol.MAIN_PLAYER2, Protocol.PLAYER2_ShareLotteryReward)
    if sender == nil then WZLog("sender == nil") return end
    sender:writeInt(lType)
    sender:writeString(itemName)
    SendProtocol(sender,false)
end

--@brief    分享成功
function ProtocolProcessorWndRankList:parse_PLAYER2_ShareLotteryRewardOk(lType,itemId,num)
    if lType == 1 then
        if WndEquipLottery.m_root then
            WndEquipLottery:getShareReward(lType,VectorToTable(itemId),VectorToTable(num))
        end
    elseif lType == 2 then
        if WndPetLottery.m_root then
            WndPetLottery:getShareReward(lType,VectorToTable(itemId),VectorToTable(num))
        end
    elseif lType == 3 then
        if WndMountLottery.m_root then
            WndMountLottery:getShareReward(lType,VectorToTable(itemId),VectorToTable(num))
        end
    elseif lType == 4 then
        if WndPhantomLottery.m_root then
            WndPhantomLottery:getShareReward(lType,VectorToTable(itemId),VectorToTable(num))
        end
    elseif lType == 5 then
        if WndFootLottery.m_root then
            WndFootLottery:getShareReward(lType,VectorToTable(itemId),VectorToTable(num))
        end
    elseif lType == 6 then
        if WndPetEquipLottery.m_root then
            WndPetEquipLottery:getShareReward(lType,VectorToTable(itemId),VectorToTable(num))
        end
    end
end

--@brief    获取抽奖信息 PLAYER2_GetLotteryInfo
function ProtocolProcessorWndRankList:send_PLAYER2_GetLotteryInfo(lType)
    WZLog("send_PLAYER2_GetLotteryInfo",lType)
    local sender = Protocol:getSender(Protocol.MAIN_PLAYER2, Protocol.PLAYER2_GetLotteryInfo)
    if sender==nil then WZLog("sender == nil") return end
    sender:writeInt(lType)
    SendProtocol(sender,false)
end

--@brief    获取抽奖信息成功 PLAYER2_GetLotteryInfoOk
function ProtocolProcessorWndRankList:parse_PLAYER2_GetLotteryInfoOk(lType, batch, lotteryNum, reTime, freeTime)
    -- lType : 1装备 2宠物 3坐骑 4皮肤 5足迹
    -- batch : 奖励批次
    -- reTime : 距离下一次刷新批次时间  装备抽奖中用于使用免费抽奖倒计时
    -- lotteryNum ：抽奖次数
    -- discountTime ：折扣时间
    -- rewardStatus : 奖励状态
    WZLog("parse_PLAYER2_GetLotteryInfoOk:",lType,Serialize(VectorToTable(batch)),lotteryNum,reTime,freeTime)
    if lType == 1 then
        if WndEquipLottery.m_root then
            WndEquipLottery:setLotteryData(lType,VectorToTable(batch),lotteryNum,reTime,freeTime)
        end
    elseif lType == 2 then
        if WndPetLottery.m_root then
            WndPetLottery:setLotteryData(lType,VectorToTable(batch),lotteryNum,reTime,freeTime)
        end
    elseif lType == 3 then
        if WndMountLottery.m_root then
            WndMountLottery:setLotteryData(lType,VectorToTable(batch),lotteryNum,reTime,freeTime)
        end
    elseif lType == 4 then
        if WndPhantomLottery.m_root then
            WndPhantomLottery:setLotteryData(lType,VectorToTable(batch),lotteryNum,reTime,freeTime)
        end
    elseif lType == 5 then
        if WndFootLottery.m_root then
            WndFootLottery:setLotteryData(lType,VectorToTable(batch),lotteryNum,reTime,freeTime)
        end
    elseif lType == 6 then
        if WndPetEquipLottery.m_root then
            WndPetEquipLottery:setLotteryData(lType,VectorToTable(batch),lotteryNum,reTime,freeTime)
        end
    end
end

--@brief    抽奖
function ProtocolProcessorWndRankList:send_PLAYER2_Lottery(lType, oType, coType, batch)
    --lType : 1装备 2宠物 3坐骑 4皮肤 5足迹
    --oType : 抽奖类型 2一抽抽奖 3十连抽
    --coType : 消耗类型 1礼钻 2钻石
    --batch : 批次
    g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
    WZLog("send_PLAYER2_Lottery",lType,oType,coType,batch)
    local sender = Protocol:getSender(Protocol.MAIN_PLAYER2, Protocol.PLAYER2_Lottery)
    if sender==nil then WZLog("sender == nil") return end
    sender:writeInt(lType)
    sender:writeInt(oType)
    sender:writeInt(coType)
    sender:writeInt(batch)
    SendProtocol(sender,false)
end

--@brief    抽奖成功
function ProtocolProcessorWndRankList:parse_PLAYER2_LotteryOk(lType, itemId, num, nCountId, nCountNum, natural, data)
    WZLog("parse_PLAYER2_LotteryOk:",lType,Serialize(VectorToTable(itemId)),Serialize(VectorToTable(num)),Serialize(VectorToTable(nCountId)),Serialize(VectorToTable(nCountNum)),Serialize(VectorToTable(natural)), Serialize(VectorToTable(data)))
    if lType == 1 then
        if WndEquipLottery.m_root then
            WndEquipLottery:successLottery(lType,VectorToTable(itemId),VectorToTable(num),VectorToTable(nCountId), VectorToTable(nCountNum), VectorToTable(natural), VectorToTable(data))
        end
    elseif lType == 2 then
        if WndPetLottery.m_root then
            WndPetLottery:successLottery(lType,VectorToTable(itemId),VectorToTable(num),VectorToTable(nCountId), VectorToTable(nCountNum), VectorToTable(natural), VectorToTable(data))
        end
    elseif lType == 3 then
        if WndMountLottery.m_root then
            WndMountLottery:successLottery(lType,VectorToTable(itemId),VectorToTable(num),VectorToTable(nCountId), VectorToTable(nCountNum), VectorToTable(natural), VectorToTable(data))
        end
    elseif lType == 4 then
        if WndPhantomLottery.m_root then
            WndPhantomLottery:successLottery(lType,VectorToTable(itemId),VectorToTable(num),VectorToTable(nCountId), VectorToTable(nCountNum), VectorToTable(natural), VectorToTable(data))
        end
    elseif lType == 5 then
        if WndFootLottery.m_root then
            WndFootLottery:successLottery(lType,VectorToTable(itemId),VectorToTable(num),VectorToTable(nCountId), VectorToTable(nCountNum), VectorToTable(natural), VectorToTable(data))
        end
    elseif lType == 6 then
        if WndPetEquipLottery.m_root then
            WndPetEquipLottery:successLottery(lType,VectorToTable(itemId),VectorToTable(num),VectorToTable(nCountId), VectorToTable(nCountNum), VectorToTable(natural), VectorToTable(data))
        end
    end
end

--@brief    领取抽奖自选礼包
function ProtocolProcessorWndRankList:send_PLAYER2_GetLotteryReward(lType)
    --lType 1装备 2宠物 3坐骑 4皮肤 5足迹
    WZLog("send_PLAYER2_GetLotteryReward",lType)
    local sender = Protocol:getSender(Protocol.MAIN_PLAYER2, Protocol.PLAYER2_GetLotteryReward)
    if sender==nil then WZLog("sender == nil") return end
    sender:writeInt(lType)
    SendProtocol(sender,false)
end

--@brief    领取抽奖自选礼包成功
function ProtocolProcessorWndRankList:parse_PLAYER2_GetLotteryRewardOk(lType, itemId, num)
    WZLog("parse_PLAYER2_GetLotteryRewardOk",lType,Serialize(VectorToTable(itemId)),Serialize(VectorToTable(num)))
    if lType == 1 then
        if WndEquipLottery.m_root then
            WndEquipLottery:getLotteryReward(lType,VectorToTable(itemId),VectorToTable(num))
        end
    elseif lType == 2 then
        if WndPetLottery.m_root then
            WndPetLottery:getLotteryReward(lType,VectorToTable(itemId),VectorToTable(num))
        end
    elseif lType == 3 then
        if WndMountLottery.m_root then
            WndMountLottery:getLotteryReward(lType,VectorToTable(itemId),VectorToTable(num))
        end
    elseif lType == 4 then
        if WndPhantomLottery.m_root then
            WndPhantomLottery:getLotteryReward(lType,VectorToTable(itemId),VectorToTable(num))
        end
    elseif lType == 5 then
        if WndFootLottery.m_root then
            WndFootLottery:getLotteryReward(lType,VectorToTable(itemId),VectorToTable(num))
        end
    elseif lType == 6 then
        if WndPetEquipLottery.m_root then
            WndPetEquipLottery:getLotteryReward(lType,VectorToTable(itemId),VectorToTable(num))
        end
    end
end

--@brief    获取勋章信息MAIN_PLAYER2
function ProtocolProcessorWndRankList:send_PLAYER2_GetVipMedalInfo( )
    WZLog("send_PLAYER2_GetVipMedalInfo")
    local sender = Protocol:getSender( Protocol.MAIN_PLAYER2, Protocol.PLAYER2_GetVipMedalInfo )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end
--@brief    获取勋章信息PLAYER2_GetVipMedalInfoOk
function ProtocolProcessorWndRankList:parse_PLAYER2_GetVipMedalInfoOk(levelIds, levelRewardStatus, medalTypes, medalStages, medalLevel, medalPoint)
    -- levelIds : 可领取的都发，其他的都不发了
    -- levelRewardStatus : 不可领取 0可领取 1已经领取
    -- medalTypes : 勋章类型 1、2、3、4、5、6
    -- medalStages : 勋章阶段
    -- medalLevel : 勋章等级
    -- medalPoint : 勋章对应的积分
    GlobalGame:getGameEventDispathcer():Dispatch(NewVipEvent.NewVipEvent_MedalInfo,VectorToTable(medalStages), medalLevel, medalPoint, 
                                                VectorToTable(levelIds),VectorToTable(levelRewardStatus))
end

--@brief    勋章等级奖励idPLAYER2_ReceiveVipMedalLevelReward
function ProtocolProcessorWndRankList:send_PLAYER2_ReceiveVipMedalLevelReward(medalLevelId )
    WZLog("send_PLAYER2_ReceiveVipMedalLevelReward")
    local sender = Protocol:getSender( Protocol.MAIN_PLAYER2, Protocol.PLAYER2_ReceiveVipMedalLevelReward )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( medalLevelId ) -- 勋章等级奖励id
    SendProtocol(sender,false) --true:showLoading
end
--@brief    勋章等级奖励返回PLAYER2_ReceiveVipMedalLevelRewardOk=4
function ProtocolProcessorWndRankList:parse_PLAYER2_ReceiveVipMedalLevelRewardOk(result, medalLevelId, rewardItemIds, rewardItemNums)
    -- result : 1成功、2失败、3已经领取过了
    -- medalLevelId : 勋章等级奖励id
    -- rewardItemIds : 领取的物品id
    -- rewardItemNums : 领取的物品数量
    WZLog("ProtocolProcessorWndRankList:parse_PLAYER2_ReceiveVipMedalLevelRewardOk")
    if CellMedalAllReward.m_root then 
        GlobalGame:getGameEventDispathcer():Dispatch(NewVipEvent.NewVipEvent_GetMedalRewardResult,result, medalLevelId,VectorToTable(rewardItemIds),VectorToTable(rewardItemNums))
        return 
    end

    CellNewVipMedal:onGetRewardResult(result, medalLevelId,VectorToTable(rewardItemIds),VectorToTable(rewardItemNums))
end

--@brief    勋章类型 1~6
function ProtocolProcessorWndRankList:send_PLAYER2_ReceiveVipMedalStage(vipType )
    WZLog("send_PLAYER2_ReceiveVipMedalStage")
    local sender = Protocol:getSender( Protocol.MAIN_PLAYER2, Protocol.PLAYER2_ReceiveVipMedalStage )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( vipType )  -- 勋章类型 1~6
    SendProtocol(sender,false) --true:showLoading
end
--@brief    PLAYER2_ReceiveVipMedalStageOk 4-7  
function ProtocolProcessorWndRankList:parse_PLAYER2_ReceiveVipMedalStageOk(medalStageIds, medalStageStatus, medalStageProgress, medalStageTargets)
    -- medalStageIds : 对应的勋章类型等级
    -- medalStageStatus : 当前状态
    -- medalStageProgress : 当前进度
    -- medalStageTargets : 目标
    WZLog("ProtocolProcessorWndRankList:parse_PLAYER2_ReceiveVipMedalStageOk", Serialize(VectorToTable(medalStageProgress)), Serialize(VectorToTable(medalStageTargets)))
    GlobalGame:getGameEventDispathcer():Dispatch(NewVipEvent.NewVipEvent_GetMedalItemInfo,VectorToTable(medalStageIds),VectorToTable(medalStageStatus),
                                        VectorToTable(medalStageProgress),VectorToTable(medalStageTargets))
end
--@brief    level:int 等级 4-8
function ProtocolProcessorWndRankList:send_PLAYER2_ReceiveVipLevelReward(level )
    WZLog("send_PLAYER2_ReceiveVipLevelReward")
    local sender = Protocol:getSender( Protocol.MAIN_PLAYER2, Protocol.PLAYER2_ReceiveVipLevelReward )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( tonumber(level) )    -- 等级
    SendProtocol(sender,false) --true:showLoading

end
--@brief    level:int 等级 4-9
function ProtocolProcessorWndRankList:parse_PLAYER2_ReceiveVipLevelRewardOk(result, level, rewardItemIds, rewardItemNums)
    -- result : 1成功、2失败、3已经领取过了
    -- level : 等级
    -- rewardItemIds : 领取的物品id
    -- rewardItemNums : 领取的物品数量
    WZLog("ProtocolProcessorWndRankList:parse_PLAYER2_ReceiveVipLevelRewardOk")
    GlobalGame:getGameEventDispathcer():Dispatch(NewVipEvent.NewVipEvent_GetPrivilegeResult,result,level,VectorToTable(rewardItemIds),VectorToTable(rewardItemNums))
end

-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief	获取排行榜数据（RANK_GetRankRecord = 1）
function ProtocolProcessorWndRankList:send_RANK_GetRankRecord(rankType)
    WZLog("send_RANK_GetRankRecord",rankType)
    local sender = Protocol:getSender( Protocol.MAIN_RANK, Protocol.RANK_GetRankRecord )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeByte(rankType)-- 排行榜类型【1、战力榜，2、等级榜，3、宠物榜，4、坐骑榜， 11、战迹榜，12、胜绩榜，13、成就榜,14、公会榜， 21、魅力榜，22、师德榜，23、恩爱榜】
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取玩家简单信息（PLAYER_GetSimpleInfo = 68）
function ProtocolProcessorWndRankList:send_PLAYER_GetSimpleInfo(playerId, handleType)
    WZLog("send_PLAYER_GetSimpleInfo")
    -- WZLog("send_PLAYER_GetSimpleInfo",Serialize(VectorToTable(playerId)))
    local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetSimpleInfo )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInts( playerId )    -- 玩家id
    sender:writeInt( handleType or 0 )    -- 排行榜类型 因为服务端说:勋章排行榜56和恩爱排行榜23要特殊处理.所以加了这个参数发送,其他榜可以默认发0
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取个人排行榜数据（RANK_GetPlayerRank = 3）
function ProtocolProcessorWndRankList:send_RANK_GetPlayerRank(rankType )
    WZLog("send_RANK_GetPlayerRank",rankType)
    local sender = Protocol:getSender( Protocol.MAIN_RANK, Protocol.RANK_GetPlayerRank )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeByte( rankType )    -- 排行榜类型【1、战力榜，2、等级榜，3、宠物榜，4、坐骑榜， 11、战迹榜，12、胜绩榜，13、成就榜,14、公会榜， 21、魅力榜，22、师德榜，23、恩爱榜】
    SendProtocol(sender,false) --true:showLoading
end

--@brief    膜拜（RANK_Worship = 5）
function ProtocolProcessorWndRankList:send_RANK_Worship(rankType, playerId )
    WZLog("send_RANK_Worship")
    local sender = Protocol:getSender( Protocol.MAIN_RANK, Protocol.RANK_Worship )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeByte( rankType )    -- 排行榜类型【1、战力榜，2、等级榜，3、宠物榜，4、坐骑榜， 12、竞技榜，13、成就榜,14、公会榜， 21、魅力榜，22、师德榜，23、恩爱榜】
    sender:writeInt( playerId ) -- 被膜拜的人
    SendProtocol(sender,false) --true:showLoading
end

--@brief    膜拜日志（RANK_GetWorshipLog = 7）
function ProtocolProcessorWndRankList:send_RANK_GetWorshipLog( )
    WZLog("send_RANK_GetWorshipLog")
    local sender = Protocol:getSender( Protocol.MAIN_RANK, Protocol.RANK_GetWorshipLog )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取烟花排行榜（RANK_GetFireworkRank = 9）
function ProtocolProcessorWndRankList:send_RANK_GetFireworkRank(rankType)
    WZLog("send_RANK_GetFireworkRank")
    local sender = Protocol:getSender( Protocol.MAIN_RANK, Protocol.RANK_GetFireworkRank )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( rankType or 1 ) -- 1.烟花榜 2.点球大战排行榜 3.足球竞猜
    SendProtocol(sender,false) --true:showLoading
end




-------------------------------------服务器到客户端协议回调方法模块--------------------------------------
--@brief    排行榜信息（RANK_GetRankRecordOK = 2）
function ProtocolProcessorWndRankList:parse_RANK_GetRankRecordOK(rankType, trendRank, ranking, playerId, name, faceId, headId, sex, level, param1, param2, param3, param4, param5, param6, param7, vipLevel, param8, headColor, param9, headEffectId, wifeHeadEffectId, qqHallInfo)
    -- rankType : 排行榜类型 1本服战力榜    59全服战力榜,60全服宠物榜,61全服等级榜
    -- trendRank : 排行趋势0、不变，1、上升，2、下降
    -- ranking : 名次
    -- playerId : 从左向右，第一个显示玩家
    -- name : 从左向右，第一个显示名称
    -- faceId : 玩家脸
    -- headId : 玩家头
    -- sex : 性别
    -- level : 等级【人物等级】
    -- param1 : 【玩家战力、宠物头像、竞技等级、成就数量、师德等级、妻子id】
    -- param2 : 【公会名称、宠物等级、竞技积分、当前称号、师德经验、妻子名称】
    -- param3 : 【宠物名称、竞技胜利场数、出徒数量、妻子等级】
    -- param4 : 【宠物战斗力、竞技总场、妻子头】
    -- param5 : 【妻子脸, 宠物品质】
    -- param6 : 【恩爱等级】
    -- param7 : 【恩爱经验】
    -- vipLevel : vip等级
    -- param8 : 妻子vip等级
    -- headColor : 头颜色索引
    -- param9 : 妻子头颜色索引
    -- headEffectId : 玩家头像框特效
    -- wifeHeadEffectId : 妻子头像框特效
    -- qqHallInfo : qq大厅玩家蓝钻数据
    --WZLog("ProtocolProcessorWndRankList:parse_RANK_GetRankRecordOK", Serialize(VectorToTable(qqHallInfo)))
    WZLog("ProtocolProcessorWndRankList:parse_RANK_GetRankRecordOK",
        "\nrankType = ",Serialize(VectorToTable(rankType)),
        "\ntrendRank = ",Serialize(VectorToTable(trendRank)),
        "\nranking = ",Serialize(VectorToTable(ranking)),
        "\nplayerId = ",Serialize(VectorToTable(playerId)),
        "\nname = ",Serialize(VectorToTable(name)),
        "\nfaceId = ",Serialize(VectorToTable(faceId)),
        "\nheadId = ",Serialize(VectorToTable(headId)),
        "\nsex = ",Serialize(VectorToTable(sex)),
        "\nlevel = ",Serialize(VectorToTable(level)),
        "\nparam1 = ",Serialize(VectorToTable(param1)),
        "\nparam2 = ",Serialize(VectorToTable(param2)),
        "\nparam3 = ",Serialize(VectorToTable(param3)),
        "\nparam4 = ",Serialize(VectorToTable(param4)),
        "\nparam5 = ",Serialize(VectorToTable(param5)),
        "\nparam6 = ",Serialize(VectorToTable(param6)),
        "\nparam7 = ",Serialize(VectorToTable(param7)),
        "\nvipLevel = ",Serialize(VectorToTable(vipLevel)),
        "\nparam8 = ",Serialize(VectorToTable(param8)),
        "\nheadColor = ",Serialize(VectorToTable(headColor)),
        "\nparam9 = ",Serialize(VectorToTable(param9)),
        "\nheadEffectId =",Serialize(VectorToTable(headEffectId)),
        "\nwifeHeadEffectId =",Serialize(VectorToTable(wifeHeadEffectId)),
        "\nqqHallInfo =",Serialize(VectorToTable(qqHallInfo))
        )

    -- 24 ,28,29 -- 分别为高级，初级，中级排行,25高级,30初级,31中级为竞技场历史排行.  积分榜:跨服总榜42,跨服历史总榜43,本服总榜44,本服历史总榜45
    --52 娱乐赛段位排名；53 娱乐赛周积分排名
    if rankType == 24 or rankType == 28 or rankType == 29 or rankType == 25 or rankType == 30 or rankType == 31 or rankType == 32 or rankType == 33 or rankType == 34 or rankType == 35 or rankType == 36 or rankType == 37 or rankType == 42 or rankType == 43 or rankType == 44 or rankType == 45 or rankType == 52 or rankType == 53 then
        --        rankType	byte	排行榜类型
        --        trendRank	byte[]	排行趋势0、不变，1、上升，2、下降
        --        ranking	int[]	名次
        --        playerId	int[]	从左向右，第一个显示玩家
        --        name	String[]	从左向右，第一个显示名称
        --        faceId	int[]	玩家脸
        --        headId	int[]	玩家头
        --        sex	byte[]	性别
        --        level	int[]	等级【人物等级】
        --        param1	String[]	竞技积分
        --        param2	String[]	竞技场数
        --        param3	String[]	竞技胜利场数
        
        local index = {[24] = 3, [28] = 1, [29] = 2, [25] = 3,[30] = 1, [31] = 2, [32] = 7,[33] = 5,[34]= 6,[35] = 7,[36] = 5,[37] = 6, [42] = 4,[43] = 4,[44] = 8,[45] = 8,[52] = 1, [53] = 1}
        if rankType == 24 or rankType == 28 or rankType == 29 or rankType == 32 or rankType == 33 or rankType == 34 or rankType == 42 or rankType == 44 or rankType == 53 then
            WndAthRank:setRankData(ranking,playerId,name,faceId,headId,sex,level,param1,param2,param3,param4,vipLevel,headColor,index[rankType], headEffectId, qqHallInfo)
        else
            if rankType == 52 then 
                WndAthRank:setLastDataAmuse(ranking,playerId,name,faceId,headId,sex,level,param1,param2,param3,param4,param5,vipLevel,headColor,index[rankType], headEffectId, qqHallInfo)
            else
                WndAthRank:setLastData(ranking,playerId,name,faceId,headId,sex,level,param1,param2,param3,param4,vipLevel,headColor,index[rankType], headEffectId, qqHallInfo)
            end
        end
    elseif rankType == 26 or rankType == 27 then
        WndCharmSpace:setData3(VectorToTable(ranking),VectorToTable(playerId),VectorToTable(name),VectorToTable(sex),VectorToTable(level),VectorToTable(param1),VectorToTable(param2),VectorToTable(param3),VectorToTable(param4),VectorToTable(param5),VectorToTable(param6), VectorToTable(qqHallInfo))
    else
        CacheCenter:setRankListInfo(ranking, playerId, name, faceId, headId, sex, level, param1, param2, param3, param4, param5, param6, param7, rankType, trendRank, vipLevel, param8, headColor, param9, headEffectId, wifeHeadEffectId, qqHallInfo)
    end

end

--@brief    获取玩家简单信息（PLAYER_GetSimpleInfoOK = 69）
function ProtocolProcessorWndRankList:parse_PLAYER_GetSimpleInfoOK(playerId, name, level, title, fighting, weaponId, headId, faceId, bodyId, wingId, petMessage, sex, guildName, wrshipNum, headColor, bodyColor)
    -- playerId : 玩家id
    -- name : 名称
    -- level : 玩家等级
    -- title : 称号
    -- fighting : 战力
    -- weaponId : 武器
    -- headId : 头
    -- faceId : 脸
    -- bodyId : 身
    -- wingId : 翅膀
    -- petMessage : 宠物信息json
    -- sex : 性别0男，1女
    -- guildName : 公会名称
    -- wrshipNum : 被膜拜次数
    --WZLog("ProtocolProcessorWndRankList:parse_PLAYER_GetSimpleInfoOK")
    WZLog("ProtocolProcessorWndRankList:parse_PLAYER_GetSimpleInfoOK",
        "\nplayerId = ",Serialize(VectorToTable(playerId)),
        "\nname = ",Serialize(VectorToTable(name)),
        "\nlevel = ",Serialize(VectorToTable(level)),
        "\ntitle = ",Serialize(VectorToTable(title)),
        "\nfighting = ",Serialize(VectorToTable(fighting)),
        "\nweaponId = ",Serialize(VectorToTable(weaponId)),
        "\nheadId = ",Serialize(VectorToTable(headId)),
        "\nfaceId = ",Serialize(VectorToTable(faceId)),
        "\nbodyId = ",Serialize(VectorToTable(bodyId)),
        "\nwingId = ",Serialize(VectorToTable(wingId)),
        "\npetMessage = ",Serialize(VectorToTable(petMessage)),
        "\nsex = ",Serialize(VectorToTable(sex)),
        "\nguildName = ",Serialize(VectorToTable(guildName)),
        "\nwrshipNum = ",Serialize(VectorToTable(wrshipNum)),
        "\nheadColor = ",Serialize(VectorToTable(headColor)),
        "\nbodyColor = ",Serialize(VectorToTable(bodyColor)))

    WndRankList:setFamousListData(VectorToTable(playerId), VectorToTable(name), VectorToTable(level), VectorToTable(title), VectorToTable(fighting), VectorToTable(weaponId), VectorToTable(headId), VectorToTable(faceId), VectorToTable(bodyId), VectorToTable(wingId), VectorToTable(petMessage), VectorToTable(sex), VectorToTable(guildName), VectorToTable(wrshipNum), VectorToTable(headColor), VectorToTable(bodyColor))
end

--@brief    获取个人排行榜数据（RANK_GetPlayerRankOK = 4）
function ProtocolProcessorWndRankList:parse_RANK_GetPlayerRankOK(myRank, rankValue, rankExp, myTrendRank, rankType, canWorship)
    -- myRank : 我的排名（没有排名，-1，没有排名）
    -- rankValue : 排名值
    -- rankExp : 第二排名值
    -- myTrendRank : 趋势0、不变，1、上升，2、下降
    -- rankType : 排行榜类型
    -- canWorship : 是否可膜拜1、可膜拜，0、不可膜拜
    --WZLog("ProtocolProcessorWndRankList:parse_RANK_GetPlayerRankOK")
    WZLog("ProtocolProcessorWndRankList:parse_RANK_GetPlayerRankOK", 
        "\nmyRank =",Serialize(VectorToTable(myRank)), 
        "\nrankValue =",Serialize(VectorToTable(rankValue)), 
        "\nrankExp =",Serialize(VectorToTable(rankExp)), 
        "\nmyTrendRank =",Serialize(VectorToTable(myTrendRank)), 
        "\nrankType =",Serialize(VectorToTable(rankType)), 
        "\ncanWorship =",Serialize(VectorToTable(canWorship)))
    
    CacheCenter:setMyRankListInfo(myRank, rankValue, rankExp, myTrendRank, rankType, canWorship)
    if rankType == 26 then
        WndCharmSpace:_update2(2)
    elseif rankType == 27 then
        WndCharmSpace:_update2(3)
    elseif rankType == 52 or rankType == 53 then
        WndAthRank:setMyAmuseRankData(myRank, rankType)
    end
end

--@brief    膜拜成功（RANK_WorshipOK = 6）
function ProtocolProcessorWndRankList:parse_RANK_WorshipOK(vigor, result, worshipId)
    -- vigor : 体力值
    -- result : 0膜拜过 1、成功，2、失败
    WZLog("ProtocolProcessorWndRankList:parse_RANK_WorshipOK")
    GlobalGame:getGameEventDispathcer():Dispatch(NewVipEvent.NewVipEvent_VipRankWorshipResult,result, worshipId, vigor)
    WndRankList:hideRedDot(result)
    CellRankSeat:receiveWorshipOK(vigor, result)
    ProtocolProcessorSceneCity:send_PLAYER_CancelRedDot(106)
    GlobalGame.g_tRedPointList.chart = false
end

--@brief    膜拜日志成功 (RANK_GetWorshipLogOK = 8）
function ProtocolProcessorWndRankList:parse_RANK_GetWorshipLogOK(playerName, worshipDate, worshipName)
    -- playerName : 膜拜者名称
    -- worshipDate : 膜拜时间（秒）时间戳
    -- worshipName : 被膜拜者名称
    WZLog("ProtocolProcessorWndRankList:parse_RANK_GetWorshipLogOK")
    WndRankList:getWorshipLogOK(VectorToTable(playerName), VectorToTable(worshipDate), VectorToTable(worshipName))
end

--@brief    获取烟花排行榜成功 (RANK_GetFireworkRankOK = 10）
function ProtocolProcessorWndRankList:parse_RANK_GetFireworkRankOK(status, ranking, playerId, name, faceId, headId, sex, level, vipLevel, headColour,score,myRank,otherServer, rankType)
    -- status : 状态（1为活动还在显示期间，0为活动已经失效了）
    -- ranking : 排名
    -- playerId : 玩家Id
    -- name : 玩家名字
    -- faceId : 脸Id
    -- headId : 头Id
    -- sex : 性别
    -- level : 等级
    -- vipLevel : VIP等级
    -- headColour : 头颜色
    -- score : 积分
    -- rankType : 类型 1.烟花榜 2.点球大战排行榜 3.足球竞猜
    WZLog("ProtocolProcessorWndRankList:parse_RANK_GetFireworkRankOK")

    if WndFootballActivity.m_root then
        WZLog("--dsgag----35345",IS_FOOTBALL_RANK, rankType)
        if rankType == 3 then
            WndFootballGuessList:handleRankInfo(status, VectorToTable(ranking), VectorToTable(playerId), VectorToTable(name), VectorToTable(faceId), VectorToTable(headId), VectorToTable(sex), VectorToTable(level), VectorToTable(vipLevel), VectorToTable(headColour),VectorToTable(score),myRank,VectorToTable(otherServer))
        else
            if not IS_FOOTBALL_RANK then
                CellFootballGame:getPlayerScore(status,VectorToTable(ranking),VectorToTable(name),VectorToTable(score),myRank)
            else
                WndFootballActivity:handleRankInfo(status, VectorToTable(ranking), VectorToTable(playerId), VectorToTable(name), VectorToTable(faceId), VectorToTable(headId), VectorToTable(sex), VectorToTable(level), VectorToTable(vipLevel), VectorToTable(headColour),VectorToTable(score),myRank,VectorToTable(otherServer))
            end
        end
    else
        if WndNewActivity.m_root then
            WndNewActivity:handleRankInfo(status, VectorToTable(ranking), VectorToTable(playerId), VectorToTable(name), VectorToTable(faceId), VectorToTable(headId), VectorToTable(sex), VectorToTable(level), VectorToTable(vipLevel), VectorToTable(headColour),VectorToTable(score),myRank,VectorToTable(otherServer))
        end
        if WndApartmentAct.m_root then
            WndApartmentAct:handleRankInfo(VectorToTable(ranking), VectorToTable(playerId), VectorToTable(name), VectorToTable(faceId), VectorToTable(headId), VectorToTable(sex), VectorToTable(level), VectorToTable(vipLevel), VectorToTable(headColour),VectorToTable(score),myRank,VectorToTable(otherServer))
        end
    end
end


-------------------------------------协议错误处理方法模块--------------------------------------
--@brief	获取排行榜数据（RANK_GetRankRecord = 1）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndRankList:send_RANK_GetRankRecord_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndRankList:send_RANK_GetRankRecord_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_RANK, Protocol.RANK_GetRankRecord, nflag, sMessage)
end

--@brief    获取玩家简单信息（PLAYER_GetSimpleInfo = 68）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndRankList:send_PLAYER_GetSimpleInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndRankList:send_PLAYER_GetSimpleInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_GetSimpleInfo, nflag, sMessage)
end

--@brief    获取个人排行榜数据（RANK_GetPlayerRank = 3）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndRankList:send_RANK_GetPlayerRank_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndRankList:send_RANK_GetPlayerRank_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_RANK, Protocol.RANK_GetPlayerRank, nflag, sMessage)
end

--@brief    膜拜（RANK_Worship = 5）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndRankList:send_RANK_Worship_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndRankList:send_RANK_Worship_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_RANK, Protocol.RANK_Worship, nflag, sMessage)
end

--@brief    膜拜日志（RANK_GetWorshipLog = 7）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndRankList:send_RANK_GetWorshipLog_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndRankList:send_RANK_GetWorshipLog_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_RANK, Protocol.RANK_GetWorshipLog, nflag, sMessage)
end


--@brief    获取烟花排行榜（RANK_GetFireworkRank = 9）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndRankList:send_RANK_GetFireworkRank_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndRankList:send_RANK_GetFireworkRank_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_RANK, Protocol.RANK_GetFireworkRank, nflag, sMessage)
    ISFIREWORKRANK = false
end

--@brief    获取抽奖信息（PLAYER2_GetLotteryInfo = 23）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndRankList:send_PLAYER2_GetLotteryInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndRankList:send_PLAYER2_GetLotteryInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER2, Protocol.PLAYER2_GetLotteryInfo, nFlag, sMessage)
end

--@brief    抽奖（PLAYER2_Lottery = 25）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndRankList:send_PLAYER2_Lottery_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndRankList:send_PLAYER2_Lottery_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER2, Protocol.PLAYER2_Lottery, nFlag, sMessage)
end

--@brief    领取抽奖自选礼包（PLAYER2_GetLotteryReward = 27）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndRankList:send_PLAYER2_GetLotteryReward_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndRankList:send_PLAYER2_GetLotteryReward_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER2, Protocol.PLAYER2_GetLotteryReward, nFlag, sMessage)
end

--@brief    分享（PLAYER2_GetLotteryReward = 27）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndRankList:send_PLAYER2_ShareLotteryReward_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndRankList:send_PLAYER2_ShareLotteryReward_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER2, Protocol.PLAYER2_ShareLotteryReward, nFlag, sMessage)
end