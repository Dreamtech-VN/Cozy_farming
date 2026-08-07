--ProtocolProcessorReturnee.lua
--@brief    成长基金相关协议
--@date     2016/4/14
--@author   Tianxiang_Xu
--@note     成长基金相关协议


ProtocolProcessorReturnee = ProtocolProcessorBase:new()


--@brief    注册协议组所有协议
--@note     注册协议组所有协议
function ProtocolProcessorReturnee:regAll()
    --@brief    获取回归任务列表（RETURN_GetReturnTaskList = 1）      错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_RETURN, Protocol.RETURN_GetReturnTaskList, "ProtocolProcessorReturnee:send_RETURN_GetReturnTaskList_ErrorProcess", "is" )
    --@brief    领取回归任务奖励（RETURN_GetReturnTaskReward = 3）        错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_RETURN, Protocol.RETURN_GetReturnTaskReward, "ProtocolProcessorReturnee:send_RETURN_GetReturnTaskReward_ErrorProcess", "is" )
    --@brief    获取回归BUFF信息（RETURN_GetReturnBuffInfo = 5）        错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_RETURN, Protocol.RETURN_GetReturnBuffInfo, "ProtocolProcessorReturnee:send_RETURN_GetReturnBuffInfo_ErrorProcess", "is" )
    --@brief    提升回归BUFF等级（RETURN_UpgradeReturnBuff = 7）        错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_RETURN, Protocol.RETURN_UpgradeReturnBuff, "ProtocolProcessorReturnee:send_RETURN_UpgradeReturnBuff_ErrorProcess", "is" )
    --@brief    获取玩家回归商城信息（RETURN_GetReturnShopInfo = 9）        错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_RETURN, Protocol.RETURN_GetReturnShopInfo, "ProtocolProcessorReturnee:send_RETURN_GetReturnShopInfo_ErrorProcess", "is" )
    --@brief    购买回归商品（RETURN_BuyReturnShop = 11）       错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_RETURN, Protocol.RETURN_BuyReturnShop, "ProtocolProcessorReturnee:send_RETURN_BuyReturnShop_ErrorProcess", "is" )
    --@brief    领取绑定邀请码奖励（RETURN_GetInviteReward = 13）      错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_RETURN, Protocol.RETURN_GetInviteReward, "ProtocolProcessorReturnee:send_RETURN_GetInviteReward_ErrorProcess", "is" )
    --@brief    获取我邀请回归的玩家列表（RETURN_GetMyInvitePlayerList = 15）     错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_RETURN, Protocol.RETURN_GetMyInvitePlayerList, "ProtocolProcessorReturnee:send_RETURN_GetMyInvitePlayerList_ErrorProcess", "is" )
    --@brief    领取邀请玩家奖励（RETURN_GetInvitePlayerReward = 17）     错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_RETURN, Protocol.RETURN_GetInvitePlayerReward, "ProtocolProcessorReturnee:send_RETURN_GetInvitePlayerReward_ErrorProcess", "is" )

    --@brief    获取回归任务列表结果（RETURN_GetReturnTaskListOk = 2）       
    self:regProtocolCallbackFunction( Protocol.MAIN_RETURN, Protocol.RETURN_GetReturnTaskListOk, "ProtocolProcessorReturnee:parse_RETURN_GetReturnTaskListOk", "vivivivitiivi")
    --@brief    领取回归任务奖励结果（RETURN_GetReturnTaskRewardOk = 4）        
    self:regProtocolCallbackFunction( Protocol.MAIN_RETURN, Protocol.RETURN_GetReturnTaskRewardOk, "ProtocolProcessorReturnee:parse_RETURN_GetReturnTaskRewardOk", "iivi")
    --@brief    获取回归BUFF信息结果（RETURN_GetReturnBuffInfoOk = 6）        
    self:regProtocolCallbackFunction( Protocol.MAIN_RETURN, Protocol.RETURN_GetReturnBuffInfoOk, "ProtocolProcessorReturnee:parse_RETURN_GetReturnBuffInfoOk", "ii")
    --@brief    提升回归BUFF等级结果（RETURN_UpgradeReturnBuffOk = 8）        
    self:regProtocolCallbackFunction( Protocol.MAIN_RETURN, Protocol.RETURN_UpgradeReturnBuffOk, "ProtocolProcessorReturnee:parse_RETURN_UpgradeReturnBuffOk", "ii")
    --@brief    获取玩家回归商城信息结果（RETURN_GetReturnShopInfoOk = 10）       
    self:regProtocolCallbackFunction( Protocol.MAIN_RETURN, Protocol.RETURN_GetReturnShopInfoOk, "ProtocolProcessorReturnee:parse_RETURN_GetReturnShopInfoOk", "vi")
    --@brief    购买回归商品结果（RETURN_BuyReturnShopOk = 12）       
    self:regProtocolCallbackFunction( Protocol.MAIN_RETURN, Protocol.RETURN_BuyReturnShopOk, "ProtocolProcessorReturnee:parse_RETURN_BuyReturnShopOk", "ii")
    --@brief    领取绑定邀请码奖励结果（RETURN_GetInviteRewardOk = 14）      
    self:regProtocolCallbackFunction( Protocol.MAIN_RETURN, Protocol.RETURN_GetInviteRewardOk, "ProtocolProcessorReturnee:parse_RETURN_GetInviteRewardOk", "is")
    --@brief    获取我邀请回归的玩家列表结果（RETURN_GetMyInvitePlayerListOk = 16）     
    self:regProtocolCallbackFunction( Protocol.MAIN_RETURN, Protocol.RETURN_GetMyInvitePlayerListOk, "ProtocolProcessorReturnee:parse_RETURN_GetMyInvitePlayerListOk", "vivivivivtvivivivivivtvittiisi")
    --@brief    领取邀请玩家奖励结果（RETURN_GetInvitePlayerRewardOk = 18）     
    self:regProtocolCallbackFunction( Protocol.MAIN_RETURN, Protocol.RETURN_GetInvitePlayerRewardOk, "ProtocolProcessorReturnee:parse_RETURN_GetInvitePlayerRewardOk", "t")
end



--@brief    反注册协议组所有协议
--@note     反注册协议组所有协议
function ProtocolProcessorReturnee:unregAll()
    self:clearReg()
end


---------------------------------客户端到服务器协议发送方法模块----------------------------------

--@brief    获取回归任务列表（RETURN_GetReturnTaskList = 1）      
function ProtocolProcessorReturnee:send_RETURN_GetReturnTaskList(type)
    WZLog("send_RETURN_GetReturnTaskList",type)
    local sender = Protocol:getSender( Protocol.MAIN_RETURN, Protocol.RETURN_GetReturnTaskList )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeByte(type)    -- 回归任务类型(1为勤劳的归来者，2为归来者的逆袭)
    SendProtocol(sender,false) --true:showLoading
end

--@brief    领取回归任务奖励（RETURN_GetReturnTaskReward = 3）        
function ProtocolProcessorReturnee:send_RETURN_GetReturnTaskReward(taskId, type )
    WZLog("send_RETURN_GetReturnTaskReward",taskId, type)
    local sender = Protocol:getSender( Protocol.MAIN_RETURN, Protocol.RETURN_GetReturnTaskReward )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( taskId )   -- 任务ID
    sender:writeByte( type )    -- 奖励类型，1=任务奖励，2=任务进度奖励
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取回归BUFF信息（RETURN_GetReturnBuffInfo = 5）        
function ProtocolProcessorReturnee:send_RETURN_GetReturnBuffInfo( )
    WZLog("send_RETURN_GetReturnBuffInfo")
    local sender = Protocol:getSender( Protocol.MAIN_RETURN, Protocol.RETURN_GetReturnBuffInfo )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    提升回归BUFF等级（RETURN_UpgradeReturnBuff = 7）        
function ProtocolProcessorReturnee:send_RETURN_UpgradeReturnBuff( )
    WZLog("send_RETURN_UpgradeReturnBuff")
    local sender = Protocol:getSender( Protocol.MAIN_RETURN, Protocol.RETURN_UpgradeReturnBuff )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取玩家回归商城信息（RETURN_GetReturnShopInfo = 9）        
function ProtocolProcessorReturnee:send_RETURN_GetReturnShopInfo( )
    WZLog("send_RETURN_GetReturnShopInfo")
    local sender = Protocol:getSender( Protocol.MAIN_RETURN, Protocol.RETURN_GetReturnShopInfo )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    购买回归商品（RETURN_BuyReturnShop = 11）       
function ProtocolProcessorReturnee:send_RETURN_BuyReturnShop(shopId )
    WZLog("send_RETURN_BuyReturnShop",shopId)
    local sender = Protocol:getSender( Protocol.MAIN_RETURN, Protocol.RETURN_BuyReturnShop )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( shopId )   -- 回归商品ID
    SendProtocol(sender,false) --true:showLoading
end

--@brief    领取绑定邀请码奖励（RETURN_GetInviteReward = 13）      
function ProtocolProcessorReturnee:send_RETURN_GetInviteReward(inviteCode )
    WZLog("send_RETURN_GetInviteReward",inviteCode)
    local sender = Protocol:getSender( Protocol.MAIN_RETURN, Protocol.RETURN_GetInviteReward )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeString( inviteCode )    -- 邀请码
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取我邀请回归的玩家列表（RETURN_GetMyInvitePlayerList = 15）     
function ProtocolProcessorReturnee:send_RETURN_GetMyInvitePlayerList( )
    WZLog("send_RETURN_GetMyInvitePlayerList")
    local sender = Protocol:getSender( Protocol.MAIN_RETURN, Protocol.RETURN_GetMyInvitePlayerList )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    领取邀请玩家奖励（RETURN_GetInvitePlayerReward = 17）     
function ProtocolProcessorReturnee:send_RETURN_GetInvitePlayerReward(type, rewardId )
    WZLog("send_RETURN_GetInvitePlayerReward",type, rewardId)
    local sender = Protocol:getSender( Protocol.MAIN_RETURN, Protocol.RETURN_GetInvitePlayerReward )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeByte( type )    -- 奖励类型（1=普通奖励|2=付费奖励|3=普通大奖|4=付费大奖）
    sender:writeInt( rewardId ) -- 奖励ID，type=3|4时传0即可
    SendProtocol(sender,false) --true:showLoading
end


---------------------------------服务器到客户端协议回调方法模块----------------------------------

--@brief    获取回归任务列表结果（RETURN_GetReturnTaskListOk = 2）       
function ProtocolProcessorReturnee:parse_RETURN_GetReturnTaskListOk(id, status, target, complete, taskType, refreshTime, progress, progressRewardStatus)
    -- id : 任务ID
    -- status : 任务奖励状态（0=待完成，1=完成未领取，2=已领取）
    -- target : 目标数量
    -- complete : 完成数量
    -- type : 回归任务类型(1为勤劳的归来者，2为归来者的逆袭)
    -- refreshTime : 刷新倒计时
    -- progress : 任务进度
    -- progressRewardStatus : 任务进度奖励状态（0=待完成，1=完成未领取，2=已领取）
    WZLog("ProtocolProcessorReturnee:parse_RETURN_GetReturnTaskListOk",
        "\nid",Serialize(VectorToTable(id)),
        "\nstatus",Serialize(VectorToTable(status)),
        "\ntarget",Serialize(VectorToTable(target)),
        "\ncomplete",Serialize(VectorToTable(complete)),
        "\ntaskType",Serialize(VectorToTable(taskType)),
        "\nrefreshTime",Serialize(VectorToTable(refreshTime)),
        "\nprogress",Serialize(VectorToTable(progress)),
        "\nprogressRewardStatus",Serialize(VectorToTable(progressRewardStatus))
        )
    WndReturneeActivity:getReturnTaskListOk(VectorToTable(id), VectorToTable(status), VectorToTable(target), VectorToTable(complete), taskType, refreshTime, progress, VectorToTable(progressRewardStatus))
end

--@brief    领取回归任务奖励结果（RETURN_GetReturnTaskRewardOk = 4）        
function ProtocolProcessorReturnee:parse_RETURN_GetReturnTaskRewardOk(status, progress, progressRewardStatus)
    -- status : 状态(0失败,1成功)
    -- progress : 任务进度 （领取任务奖励会涉及任务进度变化，进度变化会涉及任务进度奖励状态变化）
    -- progressRewardStatus : 任务进度奖励状态（0=待完成，1=完成未领取，2=已领取）
    WZLog("ProtocolProcessorReturnee:parse_RETURN_GetReturnTaskRewardOk", status, progress, Serialize(VectorToTable(progressRewardStatus)))
    if CellReturneeCounterattack.m_current and CellReturneeCounterattack.m_current.m_root then
        CellReturneeCounterattack.m_current:getReturnTaskRewardOk(status, progress, progressRewardStatus)
    end
    if CellReturneeIndustrious.m_current and CellReturneeIndustrious.m_current.m_root then
        CellReturneeIndustrious.m_current:getReturnTaskRewardOk(status, progress, progressRewardStatus)
    end
end

--@brief    获取回归BUFF信息结果（RETURN_GetReturnBuffInfoOk = 6）        
function ProtocolProcessorReturnee:parse_RETURN_GetReturnBuffInfoOk(level, lastLevelUpTime)
    -- level : 回归BUFF等级 [是否满级需要前端读配置表判断，满级后不能再触发下面的提升接口]
    -- lastLevelUpTime : 上次提升BUFF等级的时间 【需要前端判断今天是否已经提升过，已经提升过不能再触发下面的提升接口】
    WZLog("ProtocolProcessorReturnee:parse_RETURN_GetReturnBuffInfoOk", level, lastLevelUpTime)
    WndReturneeActivity:getReturnBuffInfoOk(level, lastLevelUpTime)
end

--@brief    提升回归BUFF等级结果（RETURN_UpgradeReturnBuffOk = 8）        
function ProtocolProcessorReturnee:parse_RETURN_UpgradeReturnBuffOk(level, lastLevelUpTime)
    -- level : 回归BUFF等级 [是否满级需要前端读配置表判断，满级后不能再触发下面的提升接口]
    -- lastLevelUpTime : 上次提升BUFF等级的时间
    WZLog("ProtocolProcessorReturnee:parse_RETURN_UpgradeReturnBuffOk",  level, lastLevelUpTime)
    if CellReturneeBuff.m_current and CellReturneeBuff.m_current.m_root then
        CellReturneeBuff.m_current:getUpgradeReturnBuffOk(level, lastLevelUpTime)
    end
end

--@brief    获取玩家回归商城信息结果（RETURN_GetReturnShopInfoOk = 10）       
function ProtocolProcessorReturnee:parse_RETURN_GetReturnShopInfoOk(buyNum)
    -- buyNum : 玩家各个商品还能买的数量(-1表示不限购数量)【数组按tab_return_shop的中商品排序】
    WZLog("ProtocolProcessorReturnee:parse_RETURN_GetReturnShopInfoOk", Serialize(VectorToTable(buyNum)))
    WndReturneeActivity:getReturnShopInfoOk(VectorToTable(buyNum))
end

--@brief    购买回归商品结果（RETURN_BuyReturnShopOk = 12）       
function ProtocolProcessorReturnee:parse_RETURN_BuyReturnShopOk(shopId, buyNum)
    -- shopId : 商品ID
    -- buyNum : 对应商品，玩家还能买的数量(-1表示不限购数量)
    WZLog("ProtocolProcessorReturnee:parse_RETURN_BuyReturnShopOk", shopId, buyNum)
    CellReturneeBusinessman:setBuyReturnShopOk(shopId,buyNum)
end

--@brief    领取绑定邀请码奖励结果（RETURN_GetInviteRewardOk = 14）      
function ProtocolProcessorReturnee:parse_RETURN_GetInviteRewardOk(status, inviteCode)
    -- status : 1为成功
    -- inviteCode : 邀请码
    WZLog("ProtocolProcessorReturnee:parse_RETURN_GetInviteRewardOk", status, inviteCode)
    CellReturneeInvitation.m_current:getInviteRewardOK(status, inviteCode)
end

--@brief    获取我邀请回归的玩家列表结果（RETURN_GetMyInvitePlayerListOk = 16）     
function ProtocolProcessorReturnee:parse_RETURN_GetMyInvitePlayerListOk(normalRewardStatus, normalPlayerId, normalFaceId, normalHeadId, normalSex, normalHeadColor, payRewardStatus, payPlayerId, payFaceId, payHeadId, paySex, payHeadColor, normalBigRewardStatus, payBigRewardStatus, normalRewardNum, payRewardNum, myInviteCode, endTime)
    -- normalRewardStatus : 普通回归奖励状态（0=未能领取 | 1=完成可领取 | 2=已领取）【按tab_return_reward_new配置表type=2的奖励顺序排列，注最后一条是大奖】
    -- normalPlayerId : 玩家ID，没玩家时为0
    -- normalFaceId : 脸道具id,没有为0；
    -- normalHeadId : 头道具id,没有为0;
    -- normalSex : 好友性别
    -- normalHeadColor : 头部颜色
    -- payRewardStatus : 付费回归奖励状态（0=未能领取 | 1=完成可领取 | 2=已领取）【按tab_return_reward_new配置表type=3的奖励顺序排列，注最后一条是大奖】
    -- payPlayerId : 玩家ID，没玩家时为0
    -- payFaceId : 脸道具id,没有为0；
    -- payHeadId : 头道具id,没有为0;
    -- paySex : 好友性别
    -- payHeadColor : 头部颜色
    -- normalBigRewardStatus : 普通回归大奖状态（0=未能领取 | 1=完成可领取 | 2=已领取）
    -- payBigRewardStatus : 付费回归大奖状态（0=未能领取 | 1=完成可领取 | 3=已领取）
    -- normalRewardNum : 额外普通奖励达成数量
    -- payRewardNum : 额外付费奖励达成数量
    -- myInviteCode : 我的邀请码
    -- endTime : 结束时间
    WZLog("ProtocolProcessorReturnee:parse_RETURN_GetMyInvitePlayerListOk",
        "\nnormalRewardStatus",Serialize(VectorToTable(normalRewardStatus)),
        "\nnormalPlayerId",Serialize(VectorToTable(normalPlayerId)),
        "\nnormalFaceId",Serialize(VectorToTable(normalFaceId)),
        "\nnormalHeadId",Serialize(VectorToTable(normalHeadId)),
        "\nnormalSex",Serialize(VectorToTable(normalSex)),
        "\nnormalHeadColor",Serialize(VectorToTable(normalHeadColor)),
        "\npayRewardStatus",Serialize(VectorToTable(payRewardStatus)),
        "\npayPlayerId",Serialize(VectorToTable(payPlayerId)),
        "\npayFaceId",Serialize(VectorToTable(payFaceId)),
        "\npayHeadId",Serialize(VectorToTable(payHeadId)),
        "\npaySex",Serialize(VectorToTable(paySex)),
        "\npayHeadColor",Serialize(VectorToTable(payHeadColor)),
        "\nnormalBigRewardStatus",Serialize(VectorToTable(normalBigRewardStatus)),
        "\npayBigRewardStatus",Serialize(VectorToTable(payBigRewardStatus)),
        "\nnormalRewardNum",Serialize(VectorToTable(normalRewardNum)),
        "\npayRewardNum",Serialize(VectorToTable(payRewardNum)),
        "\nmyInviteCode",Serialize(VectorToTable(myInviteCode)),
        "\nendTime",endTime
        )
    WndReturneeActivity:getMyInvitePlayerListOk(VectorToTable(normalRewardStatus), VectorToTable(normalPlayerId), VectorToTable(normalFaceId), VectorToTable(normalHeadId), VectorToTable(normalSex), VectorToTable(normalHeadColor), VectorToTable(payRewardStatus), VectorToTable(payPlayerId), VectorToTable(payFaceId), VectorToTable(payHeadId), VectorToTable(paySex), VectorToTable(payHeadColor), normalBigRewardStatus, payBigRewardStatus, normalRewardNum, payRewardNum, myInviteCode, endTime)
end

--@brief    领取邀请玩家奖励结果（RETURN_GetInvitePlayerRewardOk = 18）     
function ProtocolProcessorReturnee:parse_RETURN_GetInvitePlayerRewardOk(status)
    -- status : 领取结果（1=成功）
    WZLog("ProtocolProcessorReturnee:parse_RETURN_GetInvitePlayerRewardOk", status)
    if CellReturneeFriend.m_current and CellReturneeFriend.m_current.m_root then
        CellReturneeFriend.m_current:getInvitePlayerRewardOk(status)
    end
end


---------------------------------------协议错误处理方法模块--------------------------------------

--@brief    获取回归任务列表（RETURN_GetReturnTaskList = 1）      错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorReturnee:send_RETURN_GetReturnTaskList_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorReturnee:send_RETURN_GetReturnTaskList_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_RETURN, Protocol.RETURN_GetReturnTaskList, nflag, sMessage)
end

--@brief    领取回归任务奖励（RETURN_GetReturnTaskReward = 3）        错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorReturnee:send_RETURN_GetReturnTaskReward_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorReturnee:send_RETURN_GetReturnTaskReward_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_RETURN, Protocol.RETURN_GetReturnTaskReward, nflag, sMessage)
end

--@brief    获取回归BUFF信息（RETURN_GetReturnBuffInfo = 5）        错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorReturnee:send_RETURN_GetReturnBuffInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorReturnee:send_RETURN_GetReturnBuffInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_RETURN, Protocol.RETURN_GetReturnBuffInfo, nflag, sMessage)
end

--@brief    提升回归BUFF等级（RETURN_UpgradeReturnBuff = 7）        错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorReturnee:send_RETURN_UpgradeReturnBuff_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorReturnee:send_RETURN_UpgradeReturnBuff_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_RETURN, Protocol.RETURN_UpgradeReturnBuff, nflag, sMessage)
end

--@brief    获取玩家回归商城信息（RETURN_GetReturnShopInfo = 9）        错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorReturnee:send_RETURN_GetReturnShopInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorReturnee:send_RETURN_GetReturnShopInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_RETURN, Protocol.RETURN_GetReturnShopInfo, nflag, sMessage)
end

--@brief    购买回归商品（RETURN_BuyReturnShop = 11）       错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorReturnee:send_RETURN_BuyReturnShop_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorReturnee:send_RETURN_BuyReturnShop_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_RETURN, Protocol.RETURN_BuyReturnShop, nflag, sMessage)
end

--@brief    领取绑定邀请码奖励（RETURN_GetInviteReward = 13）      错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorReturnee:send_RETURN_GetInviteReward_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorReturnee:send_RETURN_GetInviteReward_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_RETURN, Protocol.RETURN_GetInviteReward, nflag, sMessage)
end

--@brief    获取我邀请回归的玩家列表（RETURN_GetMyInvitePlayerList = 15）     错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorReturnee:send_RETURN_GetMyInvitePlayerList_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorReturnee:send_RETURN_GetMyInvitePlayerList_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_RETURN, Protocol.RETURN_GetMyInvitePlayerList, nflag, sMessage)
end

--@brief    领取邀请玩家奖励（RETURN_GetInvitePlayerReward = 17）     错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorReturnee:send_RETURN_GetInvitePlayerReward_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorReturnee:send_RETURN_GetInvitePlayerReward_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_RETURN, Protocol.RETURN_GetInvitePlayerReward, nflag, sMessage)
end

