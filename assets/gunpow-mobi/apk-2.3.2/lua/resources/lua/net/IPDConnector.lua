--IPDConnector.lua
--@brief	IPD链接器
--@date  	2015-8-28
--@author 	binshao
--@note 	链接IPD服务器


IPDConnector = 
{
	g_nNetConnectFlag = 0,	--网络链接标识位
    ip = nil,               -- 服务器ip
    port = nil,             -- 服务器端口
    IpdAddr = "",           -- 服务器地址
    ipdUrl = nil,           -- IPD链接
    isChangeAccount = nil,  -- 是否切换账号
    ipdTaskId = 1,          --任务ID，为固定值
    ipdCheckTaskId = 2,     --任务ID，为固定值
    reconnectStartTime = nil,

}

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	链接IPD服务器
--@note		链接IPD服务器获取游戏服务器地址
--@param    account 账号  passport 密码
function IPDConnector:connectIPDServer(account,passport,bchangeaccount)
    self.isChangeAccount = bchangeaccount and true or false
    if account == "" or passport == "" then return  end

    PostPlayerEvent:postEvent(PostPlayerEvent.event_connectIPD)
    
	--登录成功的标识置为false,IPD链接成功标示设置FALSE
	GlobalGame.g_bIfLoginOk = false

    self:_initIPDUrlData()

    -- 获取服务器的连接
    local serverID = IPDhttpServer:getCurServerId()
    local udid = WGameCmUtil:GetUDID()
    local token =  IPDhttpServer:getIpdToken()
    local serverId = IPDhttpServer:getCurServerId()
    local version = IPDhttpServer:getIpdVersion()
    self.ipdUrl = "http://" .. self.IpdAddr .."/ipd?token="..token.."&version="..version.."&serverid=".. serverId
    if ProjConfig.USE_HTTPS and ProjConfig.USE_HTTPS == 1 then
        self.ipdUrl = "https://" .. self.IpdAddr .."/ipd?token="..token.."&version="..version.."&serverid=".. serverId
    end
    WZLog("ipdConnectorServer IpdUrl = ",self.ipdUrl)
    -- 连接服务器
	local mulThreadSystem = WZUISystem:getInstance():getMultiThreadSystem()
	local downLoadInfoTask = WZHTTPInfoLuaTask:createWithTimeout(self.ipdTaskId, self.ipdUrl,10,30, self.ipdCallback,self)
	downLoadInfoTask:setLevel(5)
	mulThreadSystem:addDownloadTask(downLoadInfoTask)
end

-- IPD链接回调函数
-- sData   {"token":"25cd57e3-e356-466b-8248-e503d4a641f5","name":"祥超服","state":"1","ip":"192.168.1.216:19990"}
function IPDConnector:ipdCallback(nTaskID, sData, bFinish, bFailed)
    WZLog("--------------------IPDConnector:ipdCallback---------------nTaskID",nTaskID)
    WZLog("--------------------IPDConnector:ipdCallback---------------bFailed",bFailed)
    WZLog("--------------------IPDConnector:ipdCallback---------------sData",sData)
	if self.ipdTaskId ~= nTaskID then  return end
    PostPlayerEvent:postEvent(PostPlayerEvent.event_finishIpdConnect, {isSuccess=tostring((bFailed==false))})

    --获取IPD失败  重新连接IPD
	if bFailed then
		WZLog("------------IpdConnectFailed------------------")
		if NET_FLAG_3 == self.g_nNetConnectFlag then self.g_nNetConnectFlag = NET_FLAG_4 end
        ProjConfig:setIpdAddrFlag()
        PostPlayerEvent:postEvent(PostPlayerEvent.event_connectIPDFail)
		MsgBoxManager:showConfirmBox(LocalStrings.NETWORK_UNAVAILABLE, self, self.networkUnavailableTipCallback, MSGBOXLEVEL_HIGH, nil,true)
		return
    end

    --解析数据
    local data = json.decode(tostring(sData))
    if not data then
    	WZLog("------------------IPDConnectorDataError-----------------")
    	ProjConfig:setIpdAddrFlag()
        PostPlayerEvent:postEvent(PostPlayerEvent.event_connectIPDFail)
		MsgBoxManager:showConfirmBox(LocalStrings.NETWORK_UNAVAILABLE, self, self.networkUnavailableTipCallback, MSGBOXLEVEL_HIGH, nil,true)
		return
    end

    WZLog("\n---------------IPDConnectorData--------------------start\n")
    WZLog(Serialize(data))
    WZLog("\n---------------IPDConnectorData--------------------end\n")

    if tonumber(data.state) == -1 then
        PostPlayerEvent:postEvent(PostPlayerEvent.event_connectIPDFail)
		MsgBoxManager:showConfirmBox(LocalStrings.NETWORK_UNAVAILABLE, self, self.networkUnavailableTipCallback, MSGBOXLEVEL_HIGH, nil,true)
        return
	elseif tonumber(data.state) == 0 then --游戏服务器全关闭
        PostPlayerEvent:postEvent(PostPlayerEvent.event_connectIPDFail)
        MsgBoxManager:showConfirmBox(LocalStrings.SERVER_MAINTAINING, self, self.networkUnavailableTipCallback, MSGBOXLEVEL_HIGH, nil)
        return 
    end

    --连接IDP成功
    g_passportwrongstate = nil
    PostPlayerEvent:postEvent(PostPlayerEvent.event_connectIPDSuccess)
    -- 保存data的数据
    local tempdata =  SplitStringWithSeparator(data.ip,":")
    self.ip =  tostring(tempdata[1])
    self.port = tonumber(tempdata[2])
    IPDhttpServer:setIpdToken(data.token)

    WZLog("---------------ip,port-------------",self.ip,self.port)
    WZLog("---------------cur flag---------------",self.g_nNetConnectFlag)
    WZLog("---------------cur isChangeAccount---------------",self.isChangeAccount)

	--正常游戏登录链接IPD
	if NET_FLAG_1 == self.g_nNetConnectFlag then
        WZLog("--------------g_bisloadres---------------",g_bisloadres)
		if not self.isChangeAccount or g_bisloadres then
            -- 本地资源加载完后进入游戏
            WZLog("---------------------OK1------------------")
            WndLoadLuaResources:connectServerSuccess()
		elseif  self.isChangeAccount == true then
            WZLog("---------------------OK2------------------")
			local data = WZDataFile:getInstance():getUserData()
			if data then
				data:setStringValue("AccountData", "account", g_tAccountData.accountName)
				data:setStringValue("AccountData", "password", g_tAccountData.passWord)
				data:flush()
            end
			NetManager:connectServer(self.ip,self.port, SceneLogin.connectCallbackByToken, SceneLogin)
		end
	--对于断线重连后，需要切换到小岛的特殊界面（例如战斗、战斗房间等等）
	elseif NET_FLAG_7 == self.g_nNetConnectFlag then
        WZLog("---------------------OK3------------------")
		NetManager:connectServer(self.ip,self.port, SceneLogin.connectCallbackByToken, SceneLogin)
	--游戏中断线后重连IPD
	elseif NET_FLAG_3 == self.g_nNetConnectFlag or NET_FLAG_4 == self.g_nNetConnectFlag then
        WZLog("---------------------OK4------------------")
		NetManager:connectServer(self.ip,self.port, SceneLogin.connectCallbackByToken, SceneLogin)
    end
end

--@brief	游戏主版本强制更新提示对话框回调
--@param	nId:消息ID
--@param	nType:响应类型
--@note		游戏主版本强制更新提示对话框回调
function IPDConnector:updateMainVersionCallback(nId, nType)
--    WZLog("IPDConnector:updateMainVersionCallback", nId, nType,self.updateUrl,type(self.updateUrl))
--	if type(self.updateUrl) ~= "string" then return end
--
--	WZPush:openURL(self.updateUrl)
--	local platForm =  WZUISystem:getInstance():getPlatformInfo()
--	if platForm == 13  then
--	   MsgBoxManager:showConfirmBox(LocalStrings.NEED_UPDATE_VERSION, self, self.updateMainVersionCallback, MSGBOXLEVEL_HIGH, nil)
--	end
end

--@brief	游戏子版本更新提示对话框回调
--@param	nId:消息ID
--@param	nType:响应类型
--@note		游戏子版本更新提示对话框回调
function IPDConnector:updateSubVersionCallback(nId, nType)
--    WZLog("IPDConnector:updateSubVersionCallback", nId, nType)
--	if nType == MSGBOXRESTYPE_CONFIRM then
--		if type(self.updateUrl) ~= "string" then return end
--		WZPush:openURL(self.updateUrl)
--	else
--		--正常游戏登录链接IPD
--		if NET_FLAG_1 == self.g_nNetConnectFlag then
--			self.connectIPDServer(g_tAccountData.accountName,g_tAccountData.passWord)
--		--对于断线重连后，需要切换到小岛的特殊界面（例如战斗、战斗房间等等）
--		elseif NET_FLAG_7 == self.g_nNetConnectFlag then
--			NetManager:connectServer(self.ip,self.port, SceneLogin.connectCallbackByToken, SceneLogin)
--		--游戏中断线后重连IPD
--		elseif NET_FLAG_3 == self.g_nNetConnectFlag or NET_FLAG_4 == self.g_nNetConnectFlag then
--			WZLog("NET_FLAG3333")
--			NetManager:connectServer(self.ip,self.port, SceneLogin.connectCallbackByToken, SceneLogin)
--		--切换账号和在创建角色界面用已有账号登录
--		elseif NET_FLAG_5 == self.g_nNetConnectFlag or NET_FLAG_6 == self.g_nNetConnectFlag then
--			WZLog("NET_FLAG4444")
--			NetManager:connectServer(self.ip,self.port, SceneLogin.connectCallbackByToken, SceneLogin)
--		end
--	end
end

--@brief	网络连接断开提示对话框回调
--@param	nId:消息ID
--@param	nType:响应类型
--@note		网络连接断开提示对话框回调
function IPDConnector:networkUnavailableTipCallback()
    WZLog("IPDConnector:networkUnavailableTipCallback")
	--self:connectIPDServer(g_tAccountData.accountName,g_tAccountData.passWord)
	gotoFirstScene()
end

-- 获得游戏服务器IP
function IPDConnector:getGameServerIP(ntag)
    return self.ip
end

-- 获得游戏服务器端口
function IPDConnector:getGameServerPort(ntag)
    return self.port
end

--@brief	获得IPD地址
--@return 	#1:IPD地址
function IPDConnector:getIPDAddr()
	return self.IpdAddr
end

--@brief	设置IPD服务器地址
function IPDConnector:setIPDAddr(sIPDAddr)
	self.IpdAddr = sIPDAddr
end


--@brief 	断线重连时的定时器回调函数
--@note 	断线重连时的定时器回调函数
function IPDConnector:scheduleFuncReconnecting()
    --WZLog("IPDConnector:scheduleFuncReconnecting", g_nReconnectScheduleID)
	NetManager:reconnectServer()
end

--@brief 	断线重连时的回调函数
--@note 	断线重连时的回调函数
function IPDConnector:Reconnecting()
    WZLog("IPDConnector:Reconnecting", g_nReconnectScheduleID)
	NetManager:reconnectServer()
end

--@brief	挂入后台超时的回调函数
--@note		挂入后台超过设定时间后会回调此函数
function IPDConnector:toBackgroundTimeOutCallback()
    WZLog("IPDConnector:toBackgroundTimeOutCallback")
	self = IPDConnector
	self.g_nNetConnectFlag = NET_FLAG_1
	local sceneSplashElement = WZUISystem:getInstance():createElement("splash")
	if sceneSplashElement then
		replaceScene(sceneSplashElement)
	end
end

--@brief    检查IPD服务器定时器
function IPDConnector:checkIPDServerUpdate()

    local time = os.time()
--    WZLog("IPDConnector:checkIPDServerUpdate one", time, g_nReconnectServerBeginTime)
    if time - g_nReconnectServerBeginTime >= RECONNET_TIME_LIMIT then
        --IPDConnector:checkIPDServer()
        --g_nReconnectServerBeginTime = os.time()

        WZLog("IPDConnector:checkIPDServerUpdate two")

        if g_nReconnectServerScheduleID ~= nil and g_nReconnectServerScheduleID ~= -1 then
            WZLog("SceneLogin:connectCallbackByToken ten two-1",g_nReconnectServerScheduleID)
            CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(g_nReconnectServerScheduleID)
            g_nReconnectServerScheduleID = -1
        end
        g_nReconnectServerBeginTime = -1

        --开启断线重连定时器与重连超时判断定时器
        if g_nReconnectScheduleID ~= nil and g_nReconnectScheduleID ~= -1 then
            WZLog("SceneLogin:connectCallbackByToken ten two-1",g_nReconnectScheduleID)
            CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(g_nReconnectScheduleID)
            g_nReconnectScheduleID = -1
        end
        if -1 == g_nReconnectScheduleID then
            g_nReconnectScheduleID = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(IPDConnector.scheduleFuncReconnecting, 0, false)
        end

        if -1 == g_nReconnectBeginTime then
            g_nReconnectBeginTime = os.time()
        end
    end
end

--@brief    检查IPD服务器
--@note     检查IPD服务器
function IPDConnector:checkIPDServer()
    WZLog("IPDConnector:checkIPDServer IpdUrl = ",self.ipdUrl)

    -- 连接服务器
    local mulThreadSystem = WZUISystem:getInstance():getMultiThreadSystem()
    local downLoadInfoTask = WZHTTPInfoLuaTask:createWithTimeout(self.ipdCheckTaskId, self.ipdUrl,10,30, self.ipdCheckCallback,self)
    downLoadInfoTask:setLevel(5)
    mulThreadSystem:addDownloadTask(downLoadInfoTask)
end

-- 检查IPD回调函数
-- sData   {"token":"25cd57e3-e356-466b-8248-e503d4a641f5","name":"祥超服","state":"1","ip":"192.168.1.216:19990"}
function IPDConnector:ipdCheckCallback(nTaskID, sData, bFinish, bFailed)
    WZLog("IPDConnector:ipdCheckCallback one nTaskID", nTaskID, "bFailed",bFailed)

    if g_nReconnectServerScheduleID ~= nil and g_nReconnectServerScheduleID ~= -1 then
        WZLog("SceneLogin:connectCallbackByToken ten two-1",g_nReconnectServerScheduleID)
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(g_nReconnectServerScheduleID)
        g_nReconnectServerScheduleID = -1
    end
    g_nReconnectServerBeginTime = -1

    if self.ipdCheckTaskId ~= nTaskID then  return end

    --获取IPD失败  重新连接IPD
    if bFailed then
        WZLog("IPDConnector:ipdCheckCallback two", g_nReconnectScheduleID)

        IPDConnector.g_nNetConnectFlag = NET_FLAG_2

        if g_nReconnectScheduleID ~= nil and g_nReconnectScheduleID ~= -1 then
            CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(g_nReconnectScheduleID)
            g_nReconnectScheduleID = -1
        end
        --开启断线重连定时器与重连超时判断定时器
        if -1 == g_nReconnectScheduleID then
            g_nReconnectScheduleID = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(IPDConnector.Reconnecting, 0, false)
        end

        if -1 == g_nReconnectBeginTime then
            g_nReconnectBeginTime = os.time()
        end
        return
    end

    --解析数据
    local data = json.decode(tostring(sData))
    if not data then
        WZLog("IPDConnector:ipdCheckCallback three", g_nReconnectScheduleID)
        IPDConnector.g_nNetConnectFlag = NET_FLAG_2

        if g_nReconnectScheduleID ~= nil and g_nReconnectScheduleID ~= -1 then
            CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(g_nReconnectScheduleID)
            g_nReconnectScheduleID = -1
        end
        --开启断线重连定时器与重连超时判断定时器
        if -1 == g_nReconnectScheduleID then
            g_nReconnectScheduleID = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(IPDConnector.Reconnecting, 0, false)
        end

        if -1 == g_nReconnectBeginTime then
            g_nReconnectBeginTime = os.time()
        end
        return
    end

    WZLog("IPDConnector:ipdCheckCallback four \n", Serialize(data))
    if tonumber(data.state) == 0 then
        MsgBoxManager:showConfirmBox(LocalStrings.SERVER_MAINTAINING, self, self.networkUnavailableTipCallback, MSGBOXLEVEL_HIGH, nil, true)
    elseif NetManager.g_bConnectFailed == true then
        IPDConnector.g_nNetConnectFlag = NET_FLAG_2

        if g_nReconnectScheduleID ~= nil and g_nReconnectScheduleID ~= -1 then
            CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(g_nReconnectScheduleID)
            g_nReconnectScheduleID = -1
        end
        --开启断线重连定时器与重连超时判断定时器
        if -1 == g_nReconnectScheduleID then
            g_nReconnectScheduleID = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(IPDConnector.Reconnecting, 0, false)
        end

        if -1 == g_nReconnectBeginTime then
            g_nReconnectBeginTime = os.time()
        end
    end

end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-- 初始化ipdUrl数据
function IPDConnector:_initIPDUrlData()
	--版本号
    --self.version = WZDeviceInfo:appVersion()

    self.IpdAddr =  ProjConfig:getIpdAddr()
end
-------------------------------------私有方法模块End----------------------------------------