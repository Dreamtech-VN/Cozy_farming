
VoiceChat={
    m_wydVoice = nil,           --语音聊天模块
    m_bIsOpenVoiceChat = false,    --是否开通语音聊天
    m_bIsChatWithAll = false,    --是否开通语音聊天
    m_bSetVoiceChat = 0,
    m_isConnectVoiceServer = nil, --是否连接语音服务器
    m_isLoginVoiceServer = nil, --是否登录语音服务器
    m_isLoginVoiceRoom = nil,      --是否登录语音房间
    m_isCreateVoiceRoom = nil,    --是否已经创建房间
    m_nRoomId = nil,        --语音房间ID
    m_nTimer = 0,
    m_nMaxTimer = 1,
}
--@brief	设置开启语音聊天变量
--@param
--@note
function VoiceChat:setOpenVoice(isVoiceChat)
    
    self.m_bIsOpenVoiceChat = false
end
--@brief	设置是否敌方能接收语音
--@param
--@note
function VoiceChat:setChatWithAll(isOpen)
    if self.m_bIsOpenVoiceChat == false then
        return
    end
    self.m_bIsChatWithAll = isOpen
end
--@brief	获取开启语音聊天变量
--@param
--@note
function VoiceChat:getOpenVoice()
    return self.m_bIsOpenVoiceChat
end
--@brief	连接语音聊天服务器
--@param	
--@note		
function VoiceChat:ConnectVoiceServer()
    
    if self.m_bIsOpenVoiceChat == false or self.m_wydVoice == nil then
        return
    end
   --local serverAddress = "192.168.1.248"--"183.57.16.34"
    local serverAddress = "115.29.191.130" 
    local port = "9009"
    local timeout = "2" --1秒
    
    self.m_wydVoice:connectServer(serverAddress, port,timeout, VoiceChat.callback_ConnectServer, VoiceChat)
    return
end

--@brief	登录语音聊天服务器
--@param
--@note
function VoiceChat:loginVoiceServer()
    if self.m_bIsOpenVoiceChat == false or self.m_wydVoice == nil then
        return
    end
    local playerId = CacheCenter:getPlayerInfo().id
    self.m_wydVoice:loginServer(playerId, VoiceChat.callback_LoginServer, VoiceChat)
    return
end

--@brief	创建语音聊天房间
--@param    房间ID
--@note
function VoiceChat:createVoiceRoom(roomId)
 
    if self.m_bIsOpenVoiceChat == false or self.m_isConnectVoiceServer == false or self.m_wydVoice == nil then
        return
    end
    self.m_nRoomId = roomId
    self.m_wydVoice:creaetRoom(roomId, VoiceChat.callback_CreaetRoom, VoiceChat)
end


--@brief	进入语音聊天房间
--@param    房间ID
--@note
function VoiceChat:enterVoiceRoom(roomId)

    if self.m_bIsOpenVoiceChat == false or self.m_wydVoice == nil then
        return
    end
    if self.m_nRoomId ~= nil then
        return
    end
    self.m_nRoomId = roomId
    self.m_wydVoice:enterRoom(roomId, VoiceChat.callback_EnterRoom, VoiceChat)
end

--@brief	开始录音
--@param
--@note
function VoiceChat:startRecordVoice()
    CCLuaLog("10 - startRecord")
    if self.m_bIsOpenVoiceChat == false or self.m_wydVoice == nil then
        return
    end
    self.m_wydVoice:startRecord(VoiceChat.callback_StartRecord, VoiceChat)
end
--@brief	停止语音录音
--@param
--@note
function VoiceChat:stopRecordVoice()
    if self.m_bIsOpenVoiceChat == false or self.m_isConnectVoiceServer == false or self.m_wydVoice == nil then
        return
    end
    self.m_wydVoice:stopRecord(VoiceChat.callback_StopRecord, VoiceChat)
end
--@brief	开始语音聊天
--@param
--@note
function VoiceChat:playVoice()
    if self.m_bIsOpenVoiceChat == false or self.m_isConnectVoiceServer == false or self.m_wydVoice == nil then
        return
    end
    self.m_wydVoice:startPlay(VoiceChat.callback_StartPlay, VoiceChat)
 
end
--@brief	停止语音聊天
--@param
--@note
function VoiceChat:StopVoice()
    if self.m_bIsOpenVoiceChat == false or self.m_isConnectVoiceServer == false or self.m_wydVoice == nil then
        return
    end
    self.m_wydVoice:stopPlay(VoiceChat.callback_StopPlay, VoiceChat)
end
--@brief	退出语音聊天服务
--@param    
--@note
function VoiceChat:logoutVoiceServer()
    if self.m_bIsOpenVoiceChat == false or self.m_wydVoice == nil then
        return
    end
    if self.m_isLoginVoiceServer ~= nil then
        if self.m_isLoginVoiceRoom ~= nil then
            self.m_wydVoice:leaveRoom(VoiceChat.callback_LeaveRoom, VoiceChat)
        end
        self.m_wydVoice:resetServer(VoiceChat.callback_ResetServer, VoiceChat)
    end
end
--@brief	退出语音聊天房间
--@param
--@note
function VoiceChat:logoutVoiceRoom()
    if self.m_bIsOpenVoiceChat == false or self.m_wydVoice == nil then
        return
    end
    if self.m_isLoginVoiceRoom ~= nil then
        self.m_wydVoice:leaveRoom(VoiceChat.callback_LeaveRoom, VoiceChat)
    end
end
--@brief	向所有玩家发送语音聊天
--@param
--@note
function VoiceChat:setAudioRecvALL()
    if self.m_bIsOpenVoiceChat == false or self.m_wydVoice == nil then
        return
    end
    self.m_wydVoice:setAudioRecv(0,1,VoiceChat.callback_SetAudioRecv, VoiceChat)
end
--@brief	不向某玩家发送语音聊天
--@param
--@note
function VoiceChat:setAudioRecv(nPlayerId)
    if self.m_bIsOpenVoiceChat == false or self.m_wydVoice == nil then
        return
    end
    self.m_wydVoice:setAudioRecv(nPlayerId,0,VoiceChat.callback_SetAudioRecv, VoiceChat)
end
--@brief	初始化数据
--@param
--@note
function VoiceChat:parseResult(strJson)
    local jsonTbl = json.decode(strJson, 0)
    local retCode = jsonTbl["RetCode"]
    local retMsg = jsonTbl["RetMsg"]
    CCLuaLog("==========parseResult=============")
    LogD("RetCode = " .. retCode)
    LogD("RetMsg = " .. retMsg)
    return retCode, retMsg
end
--@brief	初始化数据
--@param
--@note
function VoiceChat:parseResultExtend(strJson)
    local jsonTbl = json.decode(strJson, 0)
    local retCode = jsonTbl["RetCode"]
    local retMsg = jsonTbl["RetMsg"]
    local retList = nil
    if "0" == retCode then
        retList = jsonTbl["RetList"]
        LogD("RetList = " .. type(retList) .. " has " .. #retList .. " object")
        for k, v in pairs(retList) do
            LogD("RetList: Key="..k  .." Value="..v)
        end
    end
    
    return retCode, retMsg, retList
end


--注册服务端回调消息接收者
function VoiceChat:callback_RegisterServerMsgReceiver(strJson)

    if self.m_bIsOpenVoiceChat == false or self.m_wydVoice == nil then
        return
    end
    if "" == strJson then
        LogI("Empty String")
    end
    
    LogD("Lua Print: " .. strJson)
    local jsonTbl = json.decode(strJson, 0)
    local msgCode = jsonTbl["MsgCode"]
    if "18" == msgCode then --connect server succeed
        local retCode, retMsg = self:parseResult(strJson)
        if retCode ~= "0" then
            if WindowManager:ifWindowExist(WndBattleHud) then
                WndBattleHud:setVoiceRecordVible(true)
            end
            
            self.m_nTimer = self.m_nTimer + 1
            if self.m_nTimer <= self.m_nMaxTimer then
                self.m_wydVoice:resetServer(VoiceChat.callback_ResetServer, VoiceChat)
            end
            return
        end
        self.m_isConnectVoiceServer = 1
        self:loginVoiceServer()
    elseif "20" == msgCode then --connect server failed
        local retCode = jsonTbl["RetCode"]
        local retMsg = jsonTbl["RetMsg"]
        LogD("RetCode = " .. retCode)
        LogD("RetMsg = " .. retMsg)
        self.m_nTimer = self.m_nTimer + 1
        if self.m_nTimer <= self.m_nMaxTimer then
            self:voiceServerFail()
        end
    elseif "22" == msgCode then --someone enter room
        local roomId = jsonTbl["RoomId"]
        local playerId = jsonTbl["PlayerId"]
        LogD("Player[" ..playerId.. "] enter Room[" ..roomId.. "]")
        --客户端需要注意是否只响应同一房间的消息
        
    elseif "24" == msgCode then --someone leave room
        local roomId = jsonTbl["RoomId"]
        local playerId = jsonTbl["PlayerId"]
        LogD("Player[" ..playerId.. "] leave Room[" ..roomId.. "]")
        --客户端需要注意是否只响应同一房间的消息
        
    elseif "26" == msgCode then --server disconnect 
        --如果进到此处，则表明服务器异常，客户端需要注意是否对此进行处理
        self.m_nTimer = self.m_nTimer + 1
        if self.m_nTimer <= self.m_nMaxTimer then
            self:voiceServerFail()
        end
    elseif "30" == msgCode then --someone begin talk
        local playerId = jsonTbl["PlayerId"]
        LogD("Player[" ..playerId.. "] begin talk")
        if VoiceChat.m_bIsOpenVoiceChat == true then
            --设置静音状态
            SoundManager:setEffectSoundMute(0,true)
            --设置静音状态
            SoundManager:setBgMusicMute(0,true)
        end
        WndBattleHud:PlayerVoPointAnima(tonumber(playerId),true)
    elseif "32" == msgCode then --someone stop talk
        local playerId = jsonTbl["PlayerId"]
        LogD("Player[" ..playerId.. "] stop talk")
        WndBattleHud:PlayerVoPointAnima(tonumber(playerId),false)
        if VoiceChat.m_bIsOpenVoiceChat == true then
            --设置静音状态
            SoundManager:setEffectSoundMute(1,true)
            --设置静音状态
            SoundManager:setBgMusicMute(1,true)
        end
    else
        LogE("Unknown MsgCode")
    end
end
--@brief	初始化回调
--@param	
--@note
function VoiceChat:voiceServerFail()
    if self.m_wydVoice == nil then
        return
    end
    self.m_isConnectVoiceServer = nil
    if WindowManager:ifWindowExist(WndBattleHud) then
        WndBattleHud:setVoiceRecordVible(true)
    end
    self.m_wydVoice:resetServer(VoiceChat.callback_ResetServer, VoiceChat)
    return
end
--@brief	初始化回调
--@param    json
--@note
function VoiceChat:callback_Init(strJson)

    if "" == strJson then
        LogI("Empty String")
    end

    local retCode, retMsg = self:parseResult(strJson)
    
end

--@brief	连接服务器回调
--@param    json
--@note
function VoiceChat:callback_ConnectServer(strJson)
    CCLuaLog("==VoiceChat:callback_ConnectServer==")
    if "" == strJson then
        CCLuaLog("Empty String")
    end
end

--@brief	重置服务器回调
--@param    json
--@note
function VoiceChat:callback_ResetServer(strJson)
    CCLuaLog("==VoiceChat:callback_ResetServer==")
    if "" == strJson then
        LogI("Empty String")
    end
    local retCode, retMsg = self:parseResult(strJson)
    if retCode ~= "0" then
        if WindowManager:ifWindowExist(WndBattleHud) then
            WndBattleHud:setVoiceRecordVible(true)
        end
        self.m_nTimer = self.m_nTimer + 1
        if self.m_nTimer <= self.m_nMaxTimer then
            self.m_wydVoice:resetServer(VoiceChat.callback_ResetServer, VoiceChat)
        end
        return
    end
    self.m_isConnectVoiceServer = 1
    self:ConnectVoiceServer()
end

--@brief	登录回调
--@param    json
--@note
function VoiceChat:callback_LoginServer(strJson)
    CCLuaLog("==VoiceChat:callback_LoginServer==")
    if "" == strJson then
        LogI("Empty String")
    end

    local retCode, retMsg = self:parseResult(strJson)
    if retCode ~= "0" then
        if WindowManager:ifWindowExist(WndBattleHud) then
            WndBattleHud:setVoiceRecordVible(true)
        end
        self.m_nTimer = self.m_nTimer + 1
        if self.m_nTimer <= self.m_nMaxTimer then
            self.m_wydVoice:resetServer(VoiceChat.callback_ResetServer, VoiceChat)
        end
        return
    end
    self.m_isLoginVoiceServer = 1
    if self.m_nRoomId ~=nil then
       VoiceChat:enterVoiceRoom(m_nRoomId)
    end
end

--@brief	登出回调
--@param    json
--@note
function VoiceChat:callback_LoginOut(strJson)
    CCLuaLog("==VoiceChat:callback_LoginOut==")
    if "" == strJson then
        LogI("Empty String")
    end

    local retCode, retMsg = self:parseResult(strJson)
    self.m_nRoomId = nil
    self.m_isLoginVoiceServer = nil
    self.m_isCreateVoiceRoom = nil
end

--@brief	创建房间回调
--@param    json
--@note
function VoiceChat:callback_CreaetRoom(strJson)
    CCLuaLog("==VoiceChat:callback_CreaetRoom==")
    if "" == strJson then
        LogI("Empty String")
    end

    local retCode, retMsg = self:parseResult(strJson)
    if retCode ~= "0" then
        if WindowManager:ifWindowExist(WndBattleHud) then
            WndBattleHud:setVoiceRecordVible(true)
        end
        self.m_nTimer = self.m_nTimer + 1
        --CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(check, 1, false)
        if self.m_nTimer <= self.m_nMaxTimer then
            self.m_wydVoice:resetServer(VoiceChat.callback_ResetServer, VoiceChat)
        end
        return
    end
    if WindowManager:ifWindowExist(WndBattleHud) then
        WndBattleHud:setVoiceRecordVible(false)
    end
    self.m_nTimer = 0
    self.m_isLoginVoiceRoom = 1
    self.m_isCreateVoiceRoom = 1
end

--@brief	进入房间回调
--@param    json
--@note
function VoiceChat:callback_EnterRoom(strJson)
    CCLuaLog("==VoiceChat:callback_EnterRoom==")
    if "" == strJson then
        LogI("Empty String")
    end

    local retCode, retMsg = self:parseResult(strJson)
    if retCode == "103" then
        return
    end
    if retCode ~= "0" then
        if WindowManager:ifWindowExist(WndBattleHud) then
            WndBattleHud:setVoiceRecordVible(true)
        end
        self.m_wydVoice:resetServer(VoiceChat.callback_ResetServer, VoiceChat)
        return
    end
    if WindowManager:ifWindowExist(WndBattleHud) then
        WndBattleHud:setVoiceRecordVible(false)
    end
    self.m_nTimer = 0
    self.m_isLoginVoiceRoom = 1
end

--@brief	离开房间回调
--@param    json
--@note
function VoiceChat:callback_LeaveRoom(strJson)
    CCLuaLog("==VoiceChat:callback_LeaveRoom==")
    if "" == strJson then
        LogI("Empty String")
    end

    local retCode, retMsg = self:parseResult(strJson)
    if retCode ~= "0" then
        return
    end
    self.m_nTimer = 0
    self.m_nRoomId = nil
    self.m_isLoginVoiceRoom = nil
    self.m_isCreateVoiceRoom = nil
end


--10 
function VoiceChat:callback_SetAudioRecv(strJson)
    CCLuaLog("==VoiceChat:callback_SetAudioRecv==")
    if "" == strJson then
        LogI("Empty String")
    end

    local retCode, retMsg = self:parseResult(strJson)
end
--11 开始录音
function VoiceChat:callback_StartRecord(strJson)
    CCLuaLog("==VoiceChat:callback_StartRecord==")
    if "" == strJson then
        LogI("Empty String")
    end
    
    local retCode, retMsg = self:parseResult(strJson)
end
--11 停止录音
function VoiceChat:callback_StopRecord(strJson)
    CCLuaLog("==VoiceChat:callback_StopRecord==")
    if "" == strJson then
        LogI("Empty String")
    end

    local retCode, retMsg = self:parseResult(strJson)
end

--12 开始播放
function VoiceChat:callback_StartPlay(strJson)
    CCLuaLog("==VoiceChat:callback_StartPlay==")
    if "" == strJson then
        LogI("Empty String")
    end
    local retCode, retMsg = self:parseResult(strJson)
    if WindowManager:ifWindowExist(WndBattleHud) then
        WndBattleHud:setVoiceRecordVible(false)
    end
end

--13 停止播放
function VoiceChat:callback_StopPlay(strJson)
    CCLuaLog("==VoiceChat:callback_StopPlay==")
    if "" == strJson then
        CCLuaLog("Empty String")
    end
    --设置静音状态
	--SoundManager:setBgMusicMute(0,true)
    --设置静音状态
    --SoundManager:setEffectSoundMute(0,true)
    
    local retCode, retMsg = self:parseResult(strJson)
end
--@brief	初始化语音聊天服务器
--@param
--@note
function VoiceChat:init()
    if self.m_bIsOpenVoiceChat == false then
       return
    end
    if PlatformInfo:getCurrentPlatform() == PlatformInfo.type.PLATFORM_ANDROID then
        return
    end
    if self.m_wydVoice == nil then
        self.m_wydVoice = WydVoice:new()
    end
    local bSuccess = self.m_wydVoice:initialize()
    if false == bSuccess then
        print("WydVoice initialize fail")
        return
    end

    CCLuaLog("0 - Init")
    self.m_nTimer = 0
    self.m_nRoomId = nil
    self.m_wydVoice:init(VoiceChat.callback_Init, VoiceChat)
    self.m_wydVoice:RegisterServerMsgReceiver(VoiceChat.callback_RegisterServerMsgReceiver, VoiceChat)
end

