--NetManager.lua
--@brief	网络管理器
--@date		2013/12/04
--@author	SuYuan
--@note		网络链接控制模块


NetManager =
{
	m_sIP = "",
	m_nPort = 0,
	m_bConnected = false,
	m_bIsConnecting = false,
	m_bIsReconnecting = false,
	m_nEntryUpdateNetwork = nil,
	m_nEntryHandshake = nil,
	m_nHandshakeTime = -11,			--心跳发送的时间ms
	m_bHandshakeSuccess = false,	--心跳成功标识
	--用户自定义回调函数，应用逻辑在此回调函数中实现，再将此回调函数设置到m_fnUserCallback即可
	m_fnUserCallback = nil,
	--被回调的函数所在的表，若回调函数为全局函数，则m_tCallbackTable为nil
	m_tCallbackTable = nil,
	m_tOnConnectedEventCallbackList = nil,
	m_tOnDisconnectedEventCallbackList = nil,

	--游戏服务器连接失败标识
	g_bConnectFailed = false,

	--连接服务器回调函数编号
	g_nReconnectId = 1,

	--重复登录标识
	g_bIsRepeatLogin = false ,
    
    m_lastCheckVersionTime = -1,
    m_currentDelay = 0, --网络延迟ms
    m_tAdapter = nil,
}

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	链接服务器
--@param	sIp:服务器IP
--@param	nPort:服务器端口
--@param	fnUserCallbackFunc:用户回调函数
--@param	tCallbackTable:用户回调函数所属的表
--@return	无
--@note		链接地址为sIp的nPort端口 
function  NetManager:connectServer(sIp, nPort, fnUserCallbackFunc, tCallbackTable)
	g_isconnect = true
	WZLog("NetManager:connectServer one", tostring(sIp), tostring(nPort), tostring(NetManager.g_nReconnectId))
	
	--登录游戏服时，登录成功的标识置为false
	GlobalGame.g_bIfLoginOk = false

	self:closeConnect()
	
	self.m_bIsConnecting = true
	self.m_sIP = sIp
	self.m_nPort = nPort
	self.m_fnUserCallback = fnUserCallbackFunc
	self.m_tCallbackTable = tCallbackTable

    WZLog("NetManager:connectServer two", tostring(sIp), tostring(nPort), tostring(NetManager.g_nReconnectId))
	KLuaMutiRegSocket:getInstance():connect(self.m_sIP, self.m_nPort, "NetManager:pcb_ConnectOK", "NetManager:pcb_ConnectFailed", "NetManager:pcb_Disconnect")
end

--@brief	断线后重新链接游戏服务器
function NetManager:reconnectServer()
	WZLog("NetManager:reconnectServer one", g_nReconnectBeginTime,IPDConnector.g_nNetConnectFlag)

    if g_nLinkokToLoginokScheduleID ~= nil and g_nLinkokToLoginokScheduleID ~= -1 then
        WZLog("NetManager:reconnectServer zero",g_nLinkokToLoginokScheduleID)
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(g_nLinkokToLoginokScheduleID)
        g_nLinkokToLoginokScheduleID = -1
    end

    if -1 ~= g_nLinkokToLoginokTimer then
        g_nLinkokToLoginokTimer = -1
    end

	if -1 == g_nReconnectBeginTime then
		return
	end

	--KLuaMutiRegSocket:getInstance():closeSocket()

    WZLog("NetManager:reconnectServer two", NetManager.g_bConnectFailed, os.time(), g_nReconnectBeginTime)

	--断线重连游戏服务器超时
	if os.time() - g_nReconnectBeginTime >= RECONNET_TIME_LIMIT then
		g_nReconnectBeginTime = -1
		IPDConnector.g_nNetConnectFlag = NET_FLAG_3
        WZLog("NetManager:reconnectServer three")
	end

	--断线重连时，确保上一次连接失败后再进行下一次连接
	if not NetManager.g_bConnectFailed then
		return
	end

    WZLog("NetManager:reconnectServer four")
	NetManager.g_bConnectFailed = false

	self:connectServer(self.m_sIP, self.m_nPort, self.m_fnUserCallback, self.m_tCallbackTable)
end

--@brief	断开与服务器的链接
--@param 	无
--@return	无
--@note		断开与服务器的链接
function NetManager:closeConnect()
	WZLog("NetManager:closeConnect")
    self = NetManager
	self:_uninit()
	KLuaMutiRegSocket:getInstance():closeSocket()
	self.m_bIsConnecting = false
	self.m_bConnected = false
	self.m_tCallbackTable = nil
	self.m_fnUserCallback = nil
end

--@brief 重置网络环境
function NetManager:reset()
    self:_uninit()
end

--@brief	链接服务器成功时的回调函数
--@param	无
--@return	无
--@note		链接服务器成功时回调此函数
function NetManager:pcb_ConnectOK()
    self = NetManager

    if GlobalGame.g_nCurrentUIChannelId == -1 then
	    if CacheCenter ~= nil then
	        CacheCenter:reset()
	    end
	    if PrefetchCache ~= nil then
	        PrefetchCache:reset()
	    end
	end

	WZLog("connect OK one IP: "..self.m_sIP.." port: "..self.m_nPort.." ok!")
	--self:init()

    self.m_nEntryHandshake = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(DoHandshake, 1, false)
    self:_regHandshakeCallbackFunction()

	self.m_bConnected = true
	self.m_bIsConnecting = false
	if type(self.m_fnUserCallback)=="function" then
		if type(self.m_tCallbackTable)=="table" then
			self.m_fnUserCallback(self.m_tCallbackTable, CONNECTSERVER_SUCCESS)
		else
			self.m_fnUserCallback(nil, CONNECTSERVER_SUCCESS)
		end
	end
	
	--回调链接成功回调列表中的所有回调函数
	NetManager:_onConnected()
	DoHandshake()
end

--@brief	链接服务器失败时的回调函数
--@param	无
--@return	无
--@note		链接服务器失败时回调此函数
function NetManager:pcb_ConnectFailed()
   --有些机器加载LUA灯资源的时间超过了判定超时的时间 特殊处理
   NetManager:disableBreathNotifyDisconnect()
   self = NetManager
   WZLog("NetManager:pcb_ConnectFailed one g_isconnect "..tostring(g_isconnect).." connect Failed IP: "..self.m_sIP.." port: "..self.m_nPort.."type(self.m_fnUserCallback):"..type(self.m_fnUserCallback).."type(self.m_tCallbackTable)"..type(self.m_tCallbackTable))
   if g_isconnect == false  then
   else
		self.m_bConnected = false
		self.m_bIsConnecting = false
		if type(self.m_fnUserCallback)=="function" then
			if type(self.m_tCallbackTable)=="table" then
				self.m_fnUserCallback(self.m_tCallbackTable, CONNECTSERVER_FAILED)
			else
				self.m_fnUserCallback(nil, CONNECTSERVER_FAILED)
			end
		end
		--回调链接失败回调列表中的所有回调函数
		NetManager:_onDisconnected()
   end

end

--@brief	与服务器链接断开时的回调函数
--@param	无
--@return	无
--@note		与服务器链接断开时回调此函数
function NetManager:pcb_Disconnect()
	self = NetManager
	NetManager:disableBreathNotifyDisconnect()
    WZLog("NetManager:pcb_Disconnect g_isconnect "..tostring(g_isconnect).."IP: "..self.m_sIP.." port: "..self.m_nPort)
	if g_isconnect == false then
	else		
		self.m_bConnected = false
		self.m_bIsConnecting = false
		if type(self.m_fnUserCallback)=="function" then
			if type(self.m_tCallbackTable)=="table" then
				self.m_fnUserCallback(self.m_tCallbackTable, CONNECTSERVER_DISCONNECT)
			else
				self.m_fnUserCallback(nil, CONNECTSERVER_DISCONNECT)
			end
		end
		--回调链接失败回调列表中的所有回调函数
		NetManager:_onDisconnected()
	end

end


--@brief	心跳包发送成功时的回调函数
--@param	无
--@return	无
--@note		心跳包发送成功时回调此函数
function NetManager:pcb_Handshake(serverTime,clientTime)
	NetManager.m_bHandshakeSuccess = true
	NetManager.m_nServerCurTime = serverTime
	NetManager.m_nServerLastTime = serverTime
	NetManager.m_nClientCurTime = os.time()
    NetManager.m_bNotifyDisconnect = false
    local curTime = NetManager:getCurrentSysTime()
    NetManager.m_currentDelay = curTime - tonumber(clientTime)
	WZLog("NetManager:pcb_Handshake",serverTime,NetManager.m_currentDelay)
end

--@brief	是否正在链接服务器
--@param	无
--@return	#1:是否正在链接服务器
--@note		m_bIsConnecting为是否正在链接服务器的标志 
function NetManager:isConnecting()
	return self.m_bIsConnecting
end

--@brief	是否已经链接服务器
--@param	无
--@return	#1:是否已经链接服务器
--@note		m_bConnected为是否已经链接服务器的标志 
function NetManager:isConnected()
	return self.m_bConnected
end

--@brief	向链接成功回调表中添加回调函数
--@param	tCallbackTable:回调的函数所在的表
--@param	fnCallback:回调函数
--@return	无
--@note		向链接成功回调表中添加回调函数
function NetManager:addOnConnectedEventCallback(tCallbackTable, fnCallback)
	local key =  NetManager:_makeKey(tCallbackTable, fnCallback)
	if nil == key then
		WZLog("[NetManager:addOnConnectedEventCallback]error: make a nil key!")
		return
	end
	if type(self.m_tOnConnectedEventCallbackList)~="table" then
		self.m_tOnConnectedEventCallbackList = {}
	end
	self.m_tOnConnectedEventCallbackList[key] = {tCallbackTable, fnCallback}
end

--@brief	删除链接成功回调表中的回调函数
--@param	tCallbackTable:回调的函数所在的表
--@param	fnCallback:回调函数
--@return	无
--@note		删除链接成功回调表中的回调函数
function NetManager:delOnConnectedEventCallback(tCallbackTable, fnCallback)
	if type(self.m_tOnConnectedEventCallbackList)~="table" then
		return
	end
	local key =  NetManager:_makeKey(tCallbackTable, fnCallback)
	if key == nil then
		WZLog("[NetManager:delOnConnectedEventCallback]error: make a nil key!")
		return
	end
	self.m_tOnConnectedEventCallbackList[key] = nil
end

--@brief	清空链接成功回调表
--@param	无
--@return	无
--@note		清空链接成功回调表
function NetManager:clearOnConnectedEventCallback()
	self.m_tOnConnectedEventCallbackList = nil
end

--@brief	向链接失败回调表中添加回调函数
--@param	tCallbackTable:回调函数所在的表
--@param	fnCallback:回调函数
--@return	无
--@note		向链接失败回调表中添加回调函数
function NetManager:addOnDisconnectedEventCallback(tCallbackTable, fnCallback)
	local key =  NetManager:_makeKey(tCallbackTable, fnCallback)
	if key == nil then
		WZLog("[NetManager:addOnDisconnectedEventCallback]error: make a nil key!")
		return
	end
	if type(self.m_tOnDisconnectedEventCallbackList)~="table" then
		self.m_tOnDisconnectedEventCallbackList = {}
	end
	self.m_tOnDisconnectedEventCallbackList[key] = {tCallbackTable, fnCallback}
end

--@brief	删除链接失败回调表中的回调函数
--@param	tCallbackTable:回调函数所在的表
--@param	fnCallback:回调函数
--@return	无
--@note		删除链接失败回调表中的回调函数
function NetManager:delOnDisconnectedEventCallback(tCallbackTable, fnCallback)
	if type(self.m_tOnDisconnectedEventCallbackList)~="table" then
		return
	end
	local key =  NetManager:_makeKey(tCallbackTable, fnCallback)
	if key == nil then
		WZLog("[NetManager:delOnDisconnectedEventCallback]error: make a nil key!")
		return
	end
	self.m_tOnDisconnectedEventCallbackList[key] = nil
end

--@brief	清空链接成功回调表
--@param	无
--@return	无
--@note		清空链接成功回调表
function NetManager:clearOnDisconnectedEventCallback()
	self.m_tOnDisconnectedEventCallbackList = nil
end

--@brief	初始化网络管理器
--@param 	无
--@return	无
--@note		启动UpdateNetwork、DoHandshake计时器，注册错误处理回调
--UpdateNetwork的功能是对数据缓冲区中的数据进行收发
--DoHanshake的功能是发送心跳包
function NetManager:init()
    NetManager.m_bNotifyDisconnect = true
    self.m_nEntryUpdateNetwork = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(UpdateNetwork, 0, false)
    --[[
    self.m_nEntryHandshake = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(DoHandshake, 2, false)
    self:_regHandshakeCallbackFunction()
    --]]
    --在链接成功回调表与连接失败回调表中设置错误处理回调
    --NetManager:addOnConnectedEventCallback(ProtocolProcessorError, ProtocolProcessorError.regAll)
    --NetManager:addOnDisconnectedEventCallback(ProtocolProcessorError, ProtocolProcessorError.unregAll)
end

-------------------------------------公有方法模块End--------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	反初始化网络管理器
--@param 	无
--@return	无
--@note		关闭UpdateNetwork、DoHandshake计时器，清空链接服务器成功回调列表与链接服务器失败回调列表
function NetManager:_uninit()
    WZLog("NetManager:_uninit")
	--[[
	--不能注销，否则不会回调连接失败
	if self.m_nEntryUpdateNetwork ~= nil then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_nEntryUpdateNetwork)
		self.m_nEntryUpdateNetwork = nil
	end
	]]
	if self.m_nEntryHandshake ~= nil then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_nEntryHandshake)
		self.m_nEntryHandshake = nil
	end
	NetManager:clearOnConnectedEventCallback()
	NetManager:clearOnDisconnectedEventCallback()
end

--@brief	注册心跳成功回调函数
--@param 	无
--@return	无
--@note		注册心跳发送（DoHandshake）成功时的回调函数
function NetManager:_regHandshakeCallbackFunction()
    WZLog("NetManager:_regHandshakeCallbackFunction")
	Protocol:reg(Protocol.MAIN_SYSTEM, Protocol.SYSTEM_ShakeHands, "NetManager:pcb_Handshake", "is")
end

--@brief	生成key值
--@param	tCallbackTable:回调函数所属的表
--@param	fnCallback:回调函数
--@return	#1:tCallbackTable与fnCallback以字符串形式组成的key
--@note		生成key值
function NetManager:_makeKey(tCallbackTable, fnCallback)
	if type(fnCallback)~="function" then
		return nil
	end
	if type(tCallbackTable)~="table" then
		return nil
	end

	return tostring(tCallbackTable).."-"..tostring(fnCallback)
end

--@brief	链接成功时须做的操作
--@param	无
--@return	无
--@note		有些操作是在链接成功时须要执行的，
			--这些操作会以回调函数的形式加入到链接成功回调表m_tOnConnectedEventCallbackList中，
			--_onConnected()负责遍历执行m_tOnConnectedEventCallbackList中的所有回调函数
function NetManager:_onConnected()
	if type(self.m_tOnConnectedEventCallbackList)~="table" then
		return
	end
	for k, v in pairs(self.m_tOnConnectedEventCallbackList) do
		if k~=nil and v~=nil then
			if nil==v[1] and type(v[2])=="function" then
				v[2]()
			elseif type(v[1])=="table" and type(v[2])=="function" then
				v[2](v[1])
			end
		end
	end
end

--@brief	链接失败时须做的操作
--@param	无
--@return	无
--@note		有些操作是在链接失败时须要执行的，
			--这些操作会以回调函数的形式加入到链接失败回调表m_tOnDisconnectedEventCallbackList中，
			--_onDisconnected()负责遍历执行m_tOnDisconnectedEventCallbackList中的所有回调函数
function NetManager:_onDisconnected()
	if type(self.m_tOnDisconnectedEventCallbackList)~="table" then
		return
	end
	for k, v in pairs(self.m_tOnDisconnectedEventCallbackList) do
		if k~=nil and v~=nil then
			if nil==v[1] and type(v[2])=="function" then
				v[2]()
			elseif type(v[1])=="table" and type(v[2])=="function" then
				v[2](v[1])
			end
		end
	end
end

function NetManager:networkUnavailableTipCallback()
	gotoFirstScene()
end

function NetManager:disableBreathNotifyDisconnect()
    NetManager.m_bNotifyDisconnect = true
end

function NetManager:enableBreathNotifyDisconnect()
    NetManager.m_nClientCurTime = os.time()
    NetManager.m_bNotifyDisconnect = false
end

function NetManager:isDisableBreathNotifyDisconnect()
    return NetManager.m_bNotifyDisconnect == true
end 

--@brief  获取当前网络延迟
function NetManager:getCurrentNetDelay()
    if not NetManager:isConnected() then 
        return 99999
    end
    local delay = self.m_currentDelay
    local curTime = NetManager:getCurrentSysTime()
    if NetManager.m_bHandshakeSuccess ~= true and curTime - self.m_nHandshakeTime > self.m_currentDelay then
        delay = curTime - self.m_nHandshakeTime
    end
    --WZLog("NetManager:getCurrentNetDelay",delay,NetManager.m_bHandshakeSuccess,curTime - self.m_nHandshakeTime)
    return delay
end
--@brief  获取系统当前时间 单位是ms
function NetManager:getCurrentSysTime()
    if WZThread.getMicroTimeStr ~= nil then
        local str = WZThread:getMicroTimeStr()
        local tTime = json.decode(str)
        return tTime.sec*1000 + tTime.usec/1000
    elseif WZThread.getNanoTime ~= nil then 
        return os.time()*1000 + WZThread:getNanoTime()/1000
    end
    local curTime = os.time()*1000 + WZThread:getTickCount()%1000
    return curTime
end
-------------------------------------私有方法模块End--------------------------------------


-------------------------------------全局方法模块Begin--------------------------------------

--@brief	更新网络数据（收发网络数据）
--@param	无
--@return	无
--@note		对数据缓冲区中的网络数据进行收发（完成一次推拉）
function UpdateNetwork(dt)
	KLuaMutiRegSocket:getInstance():breath()
    if GCloudVoiceBridge ~= nil and GCloudVoiceBridge.GetVoiceEngine ~= nil and GCloudVoiceBridge:GetVoiceEngine() and WGCloudVoiceNotify:IsSupportVoice() then 
        local ret = GCloudVoiceBridge:GetVoiceEngine():Poll()
        if ret ~= 0 then 
            WZLog("GCloudVoiceBridge:GetVoiceEngine():Poll() failed",ret)
        end
    end
	if NetManager.m_nServerCurTime == nil or NetManager.m_nClientCurTime == nil or NetManager.m_nServerLastTime == nil then
		NetManager.m_nServerCurTime = os.time()
        NetManager.m_nServerLastTime = os.time()
	else 
		NetManager.m_nServerCurTime = NetManager.m_nServerLastTime + (os.time() - NetManager.m_nClientCurTime)
	end 
    -- 心跳检测
    if NetManager.m_nClientCurTime ~= nil and os.time() - NetManager.m_nClientCurTime > 20 and (not NetManager:isDisableBreathNotifyDisconnect()) then 
        local platForm =  WZUISystem:getInstance():getPlatformInfo()
        if platForm == 1 then 
            -- android战斗中不做心跳检测
            --if SceneBattle ~= nil and SceneBattle.m_root == nil then
                WZLog("UpdateNetwork NetManager:pcb_Disconnect")
                KLuaMutiRegSocket:getInstance():closeSocket()
                NetManager:pcb_Disconnect()     --20秒内没有收到心跳就断网
            --end
        else 
            WZLog("UpdateNetwork NetManager:pcb_Disconnect")
            KLuaMutiRegSocket:getInstance():closeSocket()
            NetManager:pcb_Disconnect()     --20秒内没有收到心跳就断网
            if ProjConfig.DEBUG == 1 then 
                MsgBoxManager:showTipBox("UpdateNetwork NetManager:pcb_Disconnect")
            end
        end
    end
    
    -- 加速外挂判断
	if NetManager.m_nLastDeltaTime == nil then
		NetManager.m_nLastDeltaTime = os.time()
		NetManager.m_nCountDeltaTime = 0
	end
	if NetManager.m_nCountDeltaTime == nil then 
		NetManager.m_nLastDeltaTime = os.time()
		NetManager.m_nCountDeltaTime = 0
	end
	-- WZLog("NetManager UpdateNetwork kick of bad client-one",NetManager.m_nCountDeltaTime)
	NetManager.m_nCountDeltaTime = NetManager.m_nCountDeltaTime + dt
	local deltaTime = os.time() - NetManager.m_nLastDeltaTime
	
	if deltaTime > 5 then 
		if NetManager.m_nTotalBad == nil then 
			NetManager.m_nTotalBad = 0
		end
		if NetManager.m_nCountDeltaTime > 2.5*deltaTime then 
			NetManager.m_nTotalBad = NetManager.m_nTotalBad + 1
			-- WZLog("NetManager UpdateNetwork kick of bad client-two",NetManager.m_nCountDeltaTime,NetManager.m_nLastDeltaTime,os.time(),deltaTime)
			if NetManager.m_nTotalBad > 2 then 
				WZLog("NetManager UpdateNetwork kick of bad client",deltaTime,NetManager.m_nCountDeltaTime)
				local platForm =  WZUISystem:getInstance():getPlatformInfo()
                if platForm ~= 3 and WBattleGlobal ~= nil and not WBattleGlobal:getCurrent():isReplayGame() then
                    MsgBoxManager:showConfirmBox(LocalStrings.NETWORK_UNAVAILABLE, NetManager, NetManager.networkUnavailableTipCallback, MSGBOXLEVEL_HIGH, nil)
                end
			end
		else
			NetManager.m_nTotalBad = 0
		end
		NetManager.m_nLastDeltaTime = os.time()
		NetManager.m_nCountDeltaTime = 0
	end
	-- 检测客户端版本号
    -- if os.time() - NetManager.m_lastCheckVersionTime > 300 and ProjConfig.USE_DOWNLOAD == 1 then 
        -- NetManager.m_lastCheckVersionTime = os.time()
        -- local task = CheckVersionTask:create(ProjConfig.UPDATE_URL,NetManager.CheckVersionCallback,NetManager)
        -- WZUISystem:getInstance():getMultiThreadSystem():addDownloadTask(task)
    -- end
end

function NetManager:resetDeltaTime()
	NetManager.m_nLastDeltaTime = os.time()
	NetManager.m_nCountDeltaTime = 0
	WZLog("NetManager:resetDeltaTime",NetManager.m_nCountDeltaTime,NetManager.m_nLastDeltaTime)
end

function NetManager:CheckVersionCallback(sServerVersion,sLocalVersion,bNeedUpdate)
    WZLog("LuaCheckVersionCallback", tostring(g_sServerVersion),sServerVersion,sLocalVersion,bNeedUpdate)

    if bNeedUpdate and g_sServerVersion ~= sServerVersion then
        g_sServerVersion = sServerVersion
        MsgBoxManager:showConfirmBox(LocalStrings.VERSION_LOW, ProtocolProcessorAccount, ProtocolProcessorAccount.reconectipd, MSGBOXLEVEL_HIGH, nil,true)
    end

end

--@brief	发送心跳包
--@param	无
--@return	无
--@note		定时向服务器发送心跳包
function DoHandshake()
	--WZLog("DoHandshake",NetManager:getCurrentSysTime(),NetManager.m_nHandshakeTime,NetManager.m_bHandshakeSuccess,NetManager:isConnected())
	local curTime = NetManager:getCurrentSysTime()
    if NetManager.m_bHandshakeSuccess then
		if curTime - NetManager.m_nHandshakeTime <= 5000 then
			return
		end
	else
        NetManager.m_currentDelay = 9999
		if curTime - NetManager.m_nHandshakeTime <= 10000 then
			return
		end
	end
    
	if not NetManager:isConnected() then
		return
	end
	local sender  = Protocol:getSender(Protocol.MAIN_SYSTEM, Protocol.SYSTEM_ShakeHands)
	if nil~=sender then
		sender:writeInt(0)
        sender:writeString(""..curTime)
        KLuaMutiRegSocket:getInstance():send(sender)
	end
    
    NetManager.m_nHandshakeTime = curTime
	NetManager.m_bHandshakeSuccess = false
	

	WZLog("DoHandshake...........................",NetManager.m_nHandshakeTime)
end

-------------------------------------全局方法模块End--------------------------------------



