--ProtocolProcessorWndStarSoul.lua
--@brief	星魂系统相关协议
--@date  	2014/8/18
--@author 	郭月奇
--@note 	星魂系统相关协议


ProtocolProcessorWndStarSoul = ProtocolProcessorBase:new()


-------------------------------------公有方法模块--------------------------------------

--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorWndStarSoul:regAll()
    --WZLog("ProtocolProcessorWndStarSoul:regAll")
	--角色信息获取成功(S->C)
    --@brief    发送星魂列表（STARSOUL_GetStarListOK = 2）
    self:regProtocolCallbackFunction( Protocol.MAIN_STARSOUL, Protocol.STARSOUL_GetStarListOK, "ProtocolProcessorWndStarSoul:parse_STARSOUL_GetStarListOK", "viiii")


    --@brief    激活星魂成功（STARSOUL_ActivityStarOK = 4）
    self:regProtocolCallbackFunction( Protocol.MAIN_STARSOUL, Protocol.STARSOUL_ActivityStarOK, "ProtocolProcessorWndStarSoul:parse_STARSOUL_ActivityStarOK", "iiiii")


    --@brief   错误协议处理
    --@brief    获得星魂列表（STARSOUL_GetStarList=1）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_STARSOUL, Protocol.STARSOUL_GetStarList, "ProtocolProcessorWndStarSoul:send_STARSOUL_GetStarList_ErrorProcess", "is" )
    --@brief    激活某个星魂（STARSOUL_ActivityStar = 3）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_STARSOUL, Protocol.STARSOUL_ActivityStar, "ProtocolProcessorWndStarSoul:send_STARSOUL_ActivityStar_ErrorProcess", "is" )

end 


--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorWndStarSoul:unregAll()
    WZLog("ProtocolProcessorSingleMap:unregAll")
	self:clearReg()
end



-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief    获得星魂列表（STARSOUL_GetStarList=1）
function ProtocolProcessorWndStarSoul:send_STARSOUL_GetStarList( )
    WZLog("send_STARSOUL_GetStarList")
    local sender = Protocol:getSender( Protocol.MAIN_STARSOUL, Protocol.STARSOUL_GetStarList )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    激活某个星魂（STARSOUL_ActivityStar = 3）
function ProtocolProcessorWndStarSoul:send_STARSOUL_ActivityStar(id )
    WZLog("send_STARSOUL_ActivityStar")
    local sender = Protocol:getSender( Protocol.MAIN_STARSOUL, Protocol.STARSOUL_ActivityStar )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( id )   -- 星系Id
    SendProtocol(sender,false) --true:showLoading
end
-------------------------------------服务器到客户端协议回调方法模块--------------------------------------

--@brief    发送星魂列表（STARSOUL_GetStarListOK = 2）
function ProtocolProcessorWndStarSoul:parse_STARSOUL_GetStarListOK(idlist, fight, siglevalue, teamvalue)
    -- idlist : id列表
    -- fight : 总战力
    WZLog("ProtocolProcessorWndStarSoul:parse_STARSOUL_GetStarListOK")
    WndStarSoul:setStarSoulData(idlist, fight, siglevalue, teamvalue)
end

--@brief    激活星魂成功（STARSOUL_ActivityStarOK = 4）
function ProtocolProcessorWndStarSoul:parse_STARSOUL_ActivityStarOK(result, fight, id, siglevalue, teamvalue)
    -- result : 处理结果
    -- fight : 总战力
    -- id : 升级的id
    WZLog("ProtocolProcessorWndStarSoul:parse_STARSOUL_ActivityStarOK")
    WndStarSoul:updateStarSoulData(result, fight, id, siglevalue, teamvalue)
end
-------------------------------------协议错误处理方法模块--------------------------------------
--@brief    获得星魂列表（STARSOUL_GetStarList=1）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndStarSoul:send_STARSOUL_GetStarList_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndStarSoul:send_STARSOUL_GetStarList_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_STARSOUL, Protocol.STARSOUL_GetStarList, nflag, sMessage)
end

--@brief    激活某个星魂（STARSOUL_ActivityStar = 3）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndStarSoul:send_STARSOUL_ActivityStar_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndStarSoul:send_STARSOUL_ActivityStar_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_STARSOUL, Protocol.STARSOUL_ActivityStar, nflag, sMessage)
end












