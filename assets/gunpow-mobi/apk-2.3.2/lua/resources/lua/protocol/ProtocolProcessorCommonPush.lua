--ProtocolProcessorCommonPush.lua
--@brief    推送相关协议
--@date     2016/4/14
--@author   Tianxiang_Xu
--@note     推送相关协议


ProtocolProcessorCommonPush = ProtocolProcessorBase:new()


--@brief    注册协议组所有协议
--@note     注册协议组所有协议
function ProtocolProcessorCommonPush:regAll()
    --@brief    获取定向推送（COMMONPUSH_GetDirectionalPush = 2）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_COMMONPUSH, Protocol.COMMONPUSH_GetDirectionalPush, "ProtocolProcessorCommonPush:send_COMMONPUSH_GetDirectionalPush_ErrorProcess", "is" )
    --@brief    获取定向推送（COMMONPUSH_GetStoredDirectionalPush = 4）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_COMMONPUSH, Protocol.COMMONPUSH_GetStoredDirectionalPush, "ProtocolProcessorCommonPush:send_COMMONPUSH_GetStoredDirectionalPush_ErrorProcess", "is" )
    --@brief    获取登录定向推送（COMMONPUSH_LoginDirectionalPush = 6）       错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_COMMONPUSH, Protocol.COMMONPUSH_LoginDirectionalPush, "ProtocolProcessorCommonPush:send_COMMONPUSH_LoginDirectionalPush_ErrorProcess", "is" )

    --@brief    定向推送（COMMONPUSH_GetDirectionalPushOk = 3）
    self:regProtocolCallbackFunction( Protocol.MAIN_COMMONPUSH, Protocol.COMMONPUSH_GetDirectionalPushOk, "ProtocolProcessorCommonPush:parse_COMMONPUSH_GetDirectionalPushOk", "vsviivsivi")
    --@brief    获取定向推送保存礼包（COMMONPUSH_GetStoredDirectionalPushOk = 5）
    self:regProtocolCallbackFunction( Protocol.MAIN_COMMONPUSH, Protocol.COMMONPUSH_GetStoredDirectionalPushOk, "ProtocolProcessorCommonPush:parse_COMMONPUSH_GetStoredDirectionalPushOk", "vivsvivivs")
    --@brief    登录定向推送礼包（COMMONPUSH_LoginDirectionalPushOk = 7）     
    self:regProtocolCallbackFunction( Protocol.MAIN_COMMONPUSH, Protocol.COMMONPUSH_LoginDirectionalPushOk, "ProtocolProcessorCommonPush:parse_COMMONPUSH_LoginDirectionalPushOk", "vsvivsvi")
end



--@brief    反注册协议组所有协议
--@note     反注册协议组所有协议
function ProtocolProcessorCommonPush:unregAll()
    self:clearReg()
end


--------------------------客户端到服务器协议发送方法模块----------------------------------
--@brief    获取定向推送（COMMONPUSH_GetDirectionalPush = 2）
function ProtocolProcessorCommonPush:send_COMMONPUSH_GetDirectionalPush(channelId, pushType, funcId )
    WZLog("send_COMMONPUSH_GetDirectionalPush")
    local sender = Protocol:getSender( Protocol.MAIN_COMMONPUSH, Protocol.COMMONPUSH_GetDirectionalPush )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( channelId )    -- 渠道id
    sender:writeInt( pushType )    -- 推送类型.1-战斗失败 2-系统功能开启 3-物品消耗不足 5-登陆30分钟礼包推荐
    sender:writeInt( funcId or 0 )    -- 功能Id
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取定向推送（COMMONPUSH_GetStoredDirectionalPush = 4）
function ProtocolProcessorCommonPush:send_COMMONPUSH_GetStoredDirectionalPush(channelId)
    WZLog("send_COMMONPUSH_GetStoredDirectionalPush")
    local sender = Protocol:getSender( Protocol.MAIN_COMMONPUSH, Protocol.COMMONPUSH_GetStoredDirectionalPush )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( channelId )    -- 渠道id
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取登录定向推送（COMMONPUSH_LoginDirectionalPush = 6）       
function ProtocolProcessorCommonPush:send_COMMONPUSH_LoginDirectionalPush( )
    WZLog("send_COMMONPUSH_LoginDirectionalPush")
    local sender = Protocol:getSender( Protocol.MAIN_COMMONPUSH, Protocol.COMMONPUSH_LoginDirectionalPush )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end
--------------------------服务器到客户端协议回调方法模块----------------------------------
--@brief    定向推送（COMMONPUSH_GetDirectionalPushOk = 3）
function ProtocolProcessorCommonPush:parse_COMMONPUSH_GetDirectionalPushOk(pushInfo, lastNum, pushType, originPrice, funcId, endTime)
    -- pushInfo : 推送商品信息
    -- lastNum : 剩余数量
    -- pushType : 推送类型.1-战斗失败 2-系统功能开启 3-物品消耗不足
    WZLog("ProtocolProcessorCommonPush:parse_COMMONPUSH_GetDirectionalPushOk",funcId,Serialize( VectorToTable(pushInfo)),Serialize( VectorToTable(lastNum)),Serialize( VectorToTable(endTime)),Serialize( VectorToTable(originPrice)))
    if whetherCloseRecharge() then
        return 
    end
    if #VectorToTable(pushInfo)==0 or #VectorToTable(lastNum)==0 or #VectorToTable(endTime)==0 or #VectorToTable(originPrice)==0 then return end
    if pushType == 2 then 
        WndVipGift:showInterface(VectorToTable(pushInfo), VectorToTable(lastNum), pushType, VectorToTable(originPrice), funcId, VectorToTable(endTime))
        --更新缓存中的新手礼包数据
        CacheCenter:updateNewUserPackageList(funcId, VectorToTable(pushInfo), VectorToTable(lastNum), VectorToTable(endTime), VectorToTable(originPrice))
    elseif pushType == 5 then 
        --更新缓存中的新手礼包数据
        CacheCenter:updateNewUserPackageList(funcId, VectorToTable(pushInfo), VectorToTable(lastNum), VectorToTable(endTime), VectorToTable(originPrice), pushType)
    else
        SceneCopy:setSpecifyActivityData(VectorToTable(pushInfo), VectorToTable(lastNum), pushType, VectorToTable(originPrice))
    end
end

--@brief    获取定向推送保存礼包（COMMONPUSH_GetStoredDirectionalPushOk = 5）
function ProtocolProcessorCommonPush:parse_COMMONPUSH_GetStoredDirectionalPushOk(funcId, pushInfo, lastNum, endTime, originPrice)
    -- funcId : 功能ID
    -- pushInfo : 推送配置， 格式为[商品类型, 充值ID或商城商品ID]
    -- lastNum : 剩余可购买次数
    -- endTime : 礼包消失时间
    -- originPrice : 原价
    WZLog("ProtocolProcessorCommonPush:parse_COMMONPUSH_GetStoredDirectionalPushOk")

    CacheCenter:setNewUserPackageList(VectorToTable(funcId), VectorToTable(pushInfo), VectorToTable(lastNum), VectorToTable(endTime), VectorToTable(originPrice))
end

--@brief    登录定向推送礼包（COMMONPUSH_LoginDirectionalPushOk = 7）     
function ProtocolProcessorCommonPush:parse_COMMONPUSH_LoginDirectionalPushOk(pushInfo, lastNum, originPrice, endTime)
    -- pushInfo : 推送商品信息
    -- lastNum : 剩余数量
    -- originPrice : 原价
    -- endTime : 礼包消失时间
    WZLog("ProtocolProcessorCommonPush:parse_COMMONPUSH_LoginDirectionalPushOk", Serialize(VectorToTable(pushInfo)), Serialize(VectorToTable(lastNum)), Serialize(VectorToTable(originPrice)), Serialize(VectorToTable(endTime)))
    CacheCenter:setLimitPackageList(VectorToTable(pushInfo), VectorToTable(lastNum), VectorToTable(originPrice), VectorToTable(endTime))
    WndOwnCity:createLimitPackageBtn( )
end
--------------------------------协议错误处理方法模块--------------------------------------
--@brief    获取定向推送（COMMONPUSH_GetDirectionalPush = 2）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorCommonPush:send_COMMONPUSH_GetDirectionalPush_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorCommonPush:send_COMMONPUSH_GetDirectionalPush_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_COMMONPUSH, Protocol.COMMONPUSH_GetDirectionalPush, nflag, sMessage)
end

--@brief    获取定向推送（COMMONPUSH_GetStoredDirectionalPush = 4）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorCommonPush:send_COMMONPUSH_GetStoredDirectionalPush_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorCommonPush:send_COMMONPUSH_GetStoredDirectionalPush_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_COMMONPUSH, Protocol.COMMONPUSH_GetStoredDirectionalPush, nflag, sMessage)
end

--@brief    获取登录定向推送（COMMONPUSH_LoginDirectionalPush = 6）       错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorCommonPush:send_COMMONPUSH_LoginDirectionalPush_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorCommonPush:send_COMMONPUSH_LoginDirectionalPush_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_COMMONPUSH, Protocol.COMMONPUSH_LoginDirectionalPush, nflag, sMessage)
end