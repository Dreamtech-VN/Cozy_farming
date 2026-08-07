--SceneLogin.lua
--@brief    SceneLogin的UI模块
--@date     2013/12/09
--@author   SuYuan
--@note     登陆界面

-------------------------------------公有方法模块Begin--------------------------------------

--@brief    进入场景时被调用的函数
--@param    element:表绑定的UI节点引用
--@note     在这里做场景进入前的准备工作
function SceneLogin:onEnter(element)
    WZLog("SceneLogin:onEnter")
    self.m_root = element
    --设置登录提示文本
    self:setLoginTipText(LocalStrings.LOGINING)
    self:startLogin()
end

--@brief    登陆游戏服务器
function SceneLogin:startLogin(params)
    WZLog("SceneLogin:startLogin")
    local curSdkObj = PassportSdkManager:getCurSdkObj()
        local bIsChannelLogin = false
        local bIsFreeRegist = false
        if curSdkObj then
            local config = curSdkObj.m_tConfig
            CCLuaLog(Serialize(config))
            if config.SDKOtherConfig.isFreeRegist == "true" and  self:isRegistered()==false then
                 bIsFreeRegist = true
            end
            if config.SDKOtherConfig.checkUserData == "true" and params == nil 
                and config.SDKOtherConfig.hasAccountBtnParam then 
                    local data = WZDataFile:getInstance():getUserData()
                    if nil ~= data then
                        local freeLogin = data:getStringValue("AccountData", "accountFreeLogin")
                        if freeLogin == "false" then
                            params = config.SDKOtherConfig.hasAccountBtnParam
                        end  
                    end
            end 
            if config.SDKOtherConfig.isChannelLogin == "true" then  --渠道sdk包含登录模块
                  if bIsFreeRegist  then
                    if ProjConfig.IS_FREE_REGISTER ~= nil and ProjConfig.IS_FREE_REGISTER == 2 then
                            WZLog("SceneLogin:startLogin two")
                          curSdkObj:login(params or "",SceneLogin.loginCallBack, self)
                    else
                        WZLog("SceneLogin:startLogin three")
                        self.m_loginType = 0
                        NetManager:connectServer(IPDConnector:getGameServerIP(), IPDConnector:getGameServerPort(), SceneLogin.connectCallback, SceneLogin)
                         --self:loginByUDID()

                    end
                  else
                    WZLog("SceneLogin:startLogin four")
                    curSdkObj:login( params or "",SceneLogin.loginCallBack, self)
                  end
                bIsChannelLogin = true
            end 
        end
        
        if bIsChannelLogin == false then----渠道sdk不包含登录模块，使用游戏自有的账号系统
            if self:isRegistered() then
               -- self:loginByAccount()
                self.m_loginType = 1
            else
              --  self:loginByUDID()
                self.m_loginType = 0
            end 
            NetManager:connectServer(IPDConnector:getGameServerIP(), IPDConnector:getGameServerPort(), SceneLogin.connectCallback, SceneLogin)
        end
        --return
end
    --NetManager:connectServer(IPDConnector:getGameServerIP(), IPDConnector:getGameServerPort(), SceneLogin.connectCallback, SceneLogin)
--end

function SceneLogin:initSDKCallBack()
    CCLuaLog("--SDK  test CallBack--");
end

--@brief    退出场景时被调用的函数
--@param    element:表绑定的UI节点引用
--@note     在这里做场景退出前的清理工作
function SceneLogin:onExit(element)
    WZLog("Sceneloginouthaha")
    self:_unInit()
end

--token验证来连接游戏服务器
--@token 连接ipd返回的token字段
--@accountid 连接ipd返回的accountid字段
function SceneLogin:StartLoginByToken()
    NetManager:connectServer(IPDConnector:getGameServerIP(), IPDConnector:getGameServerPort(), SceneLogin.connectCallbackByToken, SceneLogin)
end

--@brief 	从连接服务器成功到登陆成功的回调函数
--@note 	从连接服务器成功到登陆成功的回调函数
function SceneLogin:LinkokToLoginokTimer()
    WZLog("SceneLogin:LinkokToLoginokTimer one")

    if g_nLinkokToLoginokTimer ~= -1 and os.time() - g_nLinkokToLoginokTimer >= RECONNET_TIME_LIMIT and SceneCreateActor.m_root == nil and WndDownLoad.m_root == nil and WndLoginSelect.m_root == nil and GlobalGame.g_bIsDisconnectToLoginOk then
        g_nLinkokToLoginokTimer = -1
        WZLog("SceneLogin:LinkokToLoginokTimer two")
        MsgBoxManager:showConfirmBox(LocalStrings.NETWORK_UNAVAILABLE, SceneLogin, SceneLogin.LinkokToLoginokTimerCall, MSGBOXLEVEL_HIGH, nil,true, nil, true)
    end

end

--@brief 	从连接服务器成功到登陆成功的回调函数
--@note 	从连接服务器成功到登陆成功的回调函数
function SceneLogin:LinkokToLoginokTimerCall()
    WZLog("SceneLogin:LinkokToLoginokTimerCall one")
    --g_nLinkokToLoginokTimer = os.time()

    KLuaMutiRegSocket:getInstance():closeSocket()
    IPDConnector.g_nNetConnectFlag = NET_FLAG_2
    SceneLogin:connectCallbackByToken(CONNECTSERVER_DISCONNECT, true)
end

--@brief    链接服务器回调函数
--@param    connectResult:链接结果，成功：CONNECTSERVER_SUCCESS，失败：CONNECTSERVER_FAILED, 断开：CONNECTSERVER_DISCONNECT
--@note     根据链接结果在这里做相应的操作
function SceneLogin:connectCallbackByToken(connectResult, isSingleMap)
    WZLog("------------SceneLogin:connectCallbackByToken--------------", connectResult, tostring(g_nReconnectScheduleID), tostring(IPDConnector.g_nNetConnectFlag))
    GlobalGame.g_tSysConfig.connectState = connectResult

    --链接游戏服务器成功
    if connectResult == CONNECTSERVER_SUCCESS then
        NetManager.g_bConnectFailed = false
        NetManager.g_bIsRepeatLogin = false

        if g_nReconnectServerScheduleID ~= nil and g_nReconnectServerScheduleID ~= -1 then
            WZLog("SceneLogin:connectCallbackByToken ten two-1",g_nReconnectServerScheduleID)
            CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(g_nReconnectServerScheduleID)
            g_nReconnectServerScheduleID = -1
        end
        g_nReconnectServerBeginTime = -1
        
        if g_nReconnectScheduleID ~= nil and g_nReconnectScheduleID ~= -1 then
            WZLog("SceneLogin:connectCallbackByToken zero1",g_nReconnectScheduleID)
            CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(g_nReconnectScheduleID)
            g_nReconnectScheduleID = -1
        end

        if g_nLinkokToLoginokScheduleID ~= nil and g_nLinkokToLoginokScheduleID ~= -1 then
            WZLog("SceneLogin:connectCallbackByToken zero2",g_nLinkokToLoginokScheduleID)
            CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(g_nLinkokToLoginokScheduleID)
            g_nLinkokToLoginokScheduleID = -1
        end

        if -1 == g_nLinkokToLoginokScheduleID then
            g_nLinkokToLoginokScheduleID = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(SceneLogin.LinkokToLoginokTimer, 0, false)
        end
        if -1 == g_nLinkokToLoginokTimer then
            g_nLinkokToLoginokTimer = os.time()
        end
        --if GlobalGame ~=  nil then  GlobalGame:reset() end 
        if CacheCenter ~=  nil then  CacheCenter:reset() end 
        if PrefetchCache ~=  nil then  PrefetchCache:reset() end
        --注册用户相关协议
        ProtocolProcessorAccount:regAll()

        local token = IPDhttpServer:getIpdToken()
        local info = getDeviceInfo()
        WZLog("SceneLogin:connectCallbackByToken one 99999", Serialize(info))
        local infoData = SDK_Util:decodeFromJson(info);
        infoData.language = ProjConfig.LANGUAGE
        info = json.encode(infoData)
        ProtocolProcessorAccount:send_ACCOUNT_Login(token,info)

        WZLog("SceneLogin:connectCallbackByToken one", ProjConfig.IS_FREE_REGISTER, self.m_loginType)

    end

        --链接游戏服务器失败
    if connectResult == CONNECTSERVER_FAILED then
        GlobalGame.g_bisLogined = false
        WZLog("SceneLogin:connectCallbackByToken two", tostring(NetManager.g_bIsRepeatLogin), tostring(IPDConnector.g_nNetConnectFlag), tostring(g_nReconnectLoadingBoxID))

        if WndSingleCopySettlement.m_root then
            GlobalGame.m_bIsLostNetSettlement = true
        end
        if SceneBattle then
            local map = WBattleGlobal:getCurrent().m_tMakePairOk and WBattleGlobal:getCurrent().m_tMakePairOk.mapId

            WZLog("SceneLogin:connectCallbackByToken 1", tostring(map), WBattleGlobal:getCurrent():isSingleStage(), tostring(isSingleMap), SceneBattle.m_bIsLostNetSingleMap)
            if (WBattleGlobal:getCurrent():isReplayGame() or WBattleGlobal:getCurrent():isSingleStage()) and isSingleMap == nil then
                SceneBattle.m_bIsLostNetSingleMap = SceneBattle.m_bIsLostNetSingleMap + 1
                return
            end
        end

        if WindowManager:getTeachShelterLayer() or WndTeachTalk.m_root then
            TeachGroup1.LOST_NET = true
        end

        --账号重复登录处理（账号重复登录会被服务器踢掉线，此时不自动重连）
        if NetManager.g_bIsRepeatLogin then
            return
        end

        --游戏挂后台的特殊处理
        if IPDConnector.g_nNetConnectFlag == NET_FLAG_0 then
            return
        end

        NetManager.g_bConnectFailed = true

        --显示断线重连loading框
        if -1 == g_nReconnectLoadingBoxID then
            WZLog("SceneLogin:connectCallbackByToken three")
            g_nReconnectLoadingBoxID = MsgBoxManager:showLoadingBox(9999999)
        end
        
        --退出语音服务器
        VoiceChat:logoutVoiceServer()

        if NET_FLAG_1 == IPDConnector.g_nNetConnectFlag then
            WZLog("SceneLogin:connectCallbackByToken four")
            MsgBoxManager:showConfirmBox(LocalStrings.NETWORK_UNAVAILABLE, self, self.networkUnavailableTipCallback, MSGBOXLEVEL_HIGH, nil,true)
        elseif NET_FLAG_2 == IPDConnector.g_nNetConnectFlag or NET_FLAG_7 == IPDConnector.g_nNetConnectFlag then
            WZLog("SceneLogin:connectCallbackByToken five")

            -- do
            --     if -1 == g_nReconnectBeginTime then
            --         g_nReconnectBeginTime = os.time()
            --     end
            --     IPDConnector:checkIPDServer()
            --     return
            -- end

            IPDConnector:checkIPDServer()
            if -1 == g_nReconnectBeginTime then
                g_nReconnectBeginTime = os.time()
            end

            --开启断线重连服务器状态定时器
            if g_nReconnectServerScheduleID ~= nil and g_nReconnectServerScheduleID ~= -1 then
                WZLog("SceneLogin:connectCallbackByToken ten two-1",g_nReconnectServerScheduleID)
                CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(g_nReconnectServerScheduleID)
                g_nReconnectServerScheduleID = -1
            end
            if -1 == g_nReconnectServerScheduleID then
                g_nReconnectServerScheduleID = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(IPDConnector.checkIPDServerUpdate, 0, false)
            end
            if -1 == g_nReconnectServerBeginTime then
                g_nReconnectServerBeginTime = os.time()
            end

            -- --开启断线重连定时器与重连超时判断定时器
            -- if g_nReconnectScheduleID ~= nil and g_nReconnectScheduleID ~= -1 then
            --     WZLog("SceneLogin:connectCallbackByToken five-1",g_nReconnectScheduleID)
            --     CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(g_nReconnectScheduleID)
            --     g_nReconnectScheduleID = -1
            -- end
            -- if -1 == g_nReconnectScheduleID then
            --     g_nReconnectScheduleID = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(IPDConnector.Reconnecting, 0, false)
            -- end
            -- if -1 == g_nReconnectBeginTime then
            --     g_nReconnectBeginTime = os.time()
            -- end

            --MsgBoxManager:showConfirmBox(LocalStrings.NETWORK_UNAVAILABLE, self, self.networkUnavailableTipCallback2, MSGBOXLEVEL_HIGH, nil,true)

        --断线重连后，连接IPD成功，但连接游戏服务器再次断开，立即弹出提示框
        elseif NET_FLAG_3 == IPDConnector.g_nNetConnectFlag then
            WZLog("SceneLogin:connectCallbackByToken six")
            MsgBoxManager:showConfirmBox(LocalStrings.NETWORK_UNAVAILABLE, self, self.networkUnavailableTipCallback, MSGBOXLEVEL_HIGH, nil,true)
            --self:networkUnavailableTipCallback()
        
        --断线重连超时后，每次连接失败都立即弹出提示框
        elseif NET_FLAG_4 == IPDConnector.g_nNetConnectFlag then
            WZLog("SceneLogin:connectCallbackByToken seven", tostring(IPDConnector.g_bIpdConnectOk))
            if IPDConnector.g_bIpdConnectOk then
                MsgBoxManager:showConfirmBox(LocalStrings.NETWORK_UNAVAILABLE, self, self.networkUnavailableTipCallback, MSGBOXLEVEL_HIGH, nil,true)
            end

        --对于断线重连后需要切换到小岛的特殊界面，立即弹出提示框
        elseif false and NET_FLAG_7 == IPDConnector.g_nNetConnectFlag then
            WZLog("SceneLogin:connectCallbackByToken eight")
            MsgBoxManager:showConfirmBox(LocalStrings.NETWORK_UNAVAILABLE, self, self.networkUnavailableTipCallback, MSGBOXLEVEL_HIGH, nil,true)
        end
        
        return
    end
    
    --与游戏服务器的链接断开
    if connectResult == CONNECTSERVER_DISCONNECT then
        GlobalGame.g_bisLogined = false
        GlobalGame.g_bIsDisconnectToLoginOk = true
        WZLog("SceneLogin:connectCallbackByToken nine", tostring(NetManager.g_bIsRepeatLogin), tostring(IPDConnector.g_nNetConnectFlag), tostring(g_nReconnectLoadingBoxID))

        if WndSingleCopySettlement.m_root then
            GlobalGame.m_bIsLostNetSettlement = true
        end
        if SceneBattle then
            local map = WBattleGlobal:getCurrent().m_tMakePairOk and WBattleGlobal:getCurrent().m_tMakePairOk.mapId

            WZLog("SceneLogin:connectCallbackByToken 1", tostring(map), WBattleGlobal:getCurrent():isSingleStage(), tostring(isSingleMap), SceneBattle.m_bIsLostNetSingleMap)
            if (WBattleGlobal:getCurrent():isReplayGame() or  WBattleGlobal:getCurrent():isSingleStage()) and isSingleMap == nil  then
                SceneBattle.m_bIsLostNetSingleMap = SceneBattle.m_bIsLostNetSingleMap + 1
                return
            end
        end

        if WindowManager:getTeachShelterLayer() or WndTeachTalk.m_root then
            TeachGroup1.LOST_NET = true
        end

        --账号重复登录处理（账号重复登录会被服务器踢掉线，此时不自动重连）
        if NetManager.g_bIsRepeatLogin then
            return
        end

        --游戏挂后台的特殊处理
        if IPDConnector.g_nNetConnectFlag == NET_FLAG_0 then
            return
        end

        NetManager.g_bConnectFailed = true

        --显示断线重连loading框
        if -1 == g_nReconnectLoadingBoxID then
            WZLog("SceneLogin:connectCallbackByToken ten")
            g_nReconnectLoadingBoxID = MsgBoxManager:showLoadingBox(9999999)
        end

        --退出语音服务器
        VoiceChat:logoutVoiceServer()
        
        if NET_FLAG_1 == IPDConnector.g_nNetConnectFlag then
            WZLog("SceneLogin:connectCallbackByToken ten one")
            MsgBoxManager:showConfirmBox(LocalStrings.NETWORK_UNAVAILABLE, self, self.accountCallbacl, MSGBOXLEVEL_HIGH, nil,true)
        elseif NET_FLAG_2 == IPDConnector.g_nNetConnectFlag or NET_FLAG_7 == IPDConnector.g_nNetConnectFlag then
            WZLog("SceneLogin:connectCallbackByToken ten two")

            -- do
            --     if -1 == g_nReconnectBeginTime then
            --         g_nReconnectBeginTime = os.time()
            --     end
            --     IPDConnector:checkIPDServer()
            --     return
            -- end

            IPDConnector:checkIPDServer()
            if -1 == g_nReconnectBeginTime then
                g_nReconnectBeginTime = os.time()
            end

            --开启断线重连服务器状态定时器
            if g_nReconnectServerScheduleID ~= nil and g_nReconnectServerScheduleID ~= -1 then
                WZLog("SceneLogin:connectCallbackByToken ten two-1",g_nReconnectServerScheduleID)
                CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(g_nReconnectServerScheduleID)
                g_nReconnectServerScheduleID = -1
            end
            if -1 == g_nReconnectServerScheduleID then
                g_nReconnectServerScheduleID = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(IPDConnector.checkIPDServerUpdate, 0, false)
            end
            if -1 == g_nReconnectServerBeginTime then
                g_nReconnectServerBeginTime = os.time()
            end

        
        --断线重连后，连接IPD成功，但连接游戏服务器再次断开，立即弹出提示框
        elseif NET_FLAG_3 == IPDConnector.g_nNetConnectFlag then
            WZLog("SceneLogin:connectCallback ten three")
            MsgBoxManager:showConfirmBox(LocalStrings.NETWORK_UNAVAILABLE, self, self.networkUnavailableTipCallback, MSGBOXLEVEL_HIGH, nil,true, nil,true)

        --断线重连超时后，每次连接失败都立即弹出提示框
        elseif NET_FLAG_4 == IPDConnector.g_nNetConnectFlag then
            WZLog("SceneLogin:connectCallback ten three")
            if IPDConnector.g_bIpdConnectOk then
                MsgBoxManager:showConfirmBox(LocalStrings.NETWORK_UNAVAILABLE, self, self.networkUnavailableTipCallback, MSGBOXLEVEL_HIGH, nil,true)
            end

        --对于断线重连后需要切换到小岛的特殊界面，立即弹出提示框
        elseif false and NET_FLAG_7 == IPDConnector.g_nNetConnectFlag then
            WZLog("SceneLogin:connectCallback ten four")
            MsgBoxManager:showConfirmBox(LocalStrings.NETWORK_UNAVAILABLE, self, self.networkUnavailableTipCallback, MSGBOXLEVEL_HIGH, nil,true)
        end
        
        return
    end
end

--@brief    链接服务器回调函数
--@param    connectResult:链接结果，成功：CONNECTSERVER_SUCCESS，失败：CONNECTSERVER_FAILED, 断开：CONNECTSERVER_DISCONNECT
--@note     根据链接结果在这里做相应的操作
function SceneLogin:connectCallback(connectResult) 
    WZLog("------------SceneLogin:connectCallback--------------", connectResult, tostring(g_nReconnectScheduleID), tostring(IPDConnector.g_nNetConnectFlag))
    GlobalGame.g_tSysConfig.connectState = connectResult
    --链接游戏服务器成功
    if connectResult == CONNECTSERVER_SUCCESS then
        NetManager.g_bConnectFailed = false
        NetManager.g_bIsRepeatLogin = false
        if g_nReconnectScheduleID ~= nil and g_nReconnectScheduleID ~= -1 then
            WZLog("SceneLogin:connectCallback zero1",g_nReconnectScheduleID)
            CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(g_nReconnectScheduleID)
            g_nReconnectScheduleID = -1
        end
        --if GlobalGame ~=  nil then  GlobalGame:reset() end 
        if CacheCenter ~=  nil then  CacheCenter:reset() end 
        if PrefetchCache ~=  nil then  PrefetchCache:reset() end
        --注册用户相关协议
        ProtocolProcessorAccount:regAll()
        WZLog("SceneLogin:connectCallback one", ProjConfig.IS_FREE_REGISTER, self.m_loginType)
        if self.m_loginType==0 then
            self:loginByUDID()
        elseif self.m_loginType==1 then
            self:loginByAccount()
        elseif self.m_loginType== 2 then
            self:loginBySDK()
        end
    end
    
    --链接游戏服务器失败
    if connectResult == CONNECTSERVER_FAILED then
        WZLog("SceneLogin:connectCallback two", tostring(NetManager.g_bIsRepeatLogin), tostring(IPDConnector.g_nNetConnectFlag), tostring(g_nReconnectLoadingBoxID))

        --账号重复登录处理（账号重复登录会被服务器踢掉线，此时不自动重连）
        if NetManager.g_bIsRepeatLogin then
            return
        end

        --游戏挂后台的特殊处理
        if IPDConnector.g_nNetConnectFlag == NET_FLAG_0 then
            return
        end

        NetManager.g_bConnectFailed = true

        --显示断线重连loading框
        if -1 == g_nReconnectLoadingBoxID then
            WZLog("SceneLogin:connectCallback three")
            g_nReconnectLoadingBoxID = MsgBoxManager:showLoadingBox(9999999)
        end
        
        --退出语音服务器
        VoiceChat:logoutVoiceServer()

        if NET_FLAG_1 == IPDConnector.g_nNetConnectFlag then
            WZLog("SceneLogin:connectCallback four")
            MsgBoxManager:showConfirmBox(LocalStrings.NETWORK_UNAVAILABLE, self, self.networkUnavailableTipCallback, MSGBOXLEVEL_HIGH, nil,true)
        elseif NET_FLAG_2 == IPDConnector.g_nNetConnectFlag then
            WZLog("SceneLogin:connectCallback five")

            -- do
            --     if -1 == g_nReconnectBeginTime then
            --         g_nReconnectBeginTime = os.time()
            --     end
            --     IPDConnector:checkIPDServer()
            --     return
            -- end

            IPDConnector:checkIPDServer()
            if -1 == g_nReconnectBeginTime then
                g_nReconnectBeginTime = os.time()
            end

            --开启断线重连服务器状态定时器
            if g_nReconnectServerScheduleID ~= nil and g_nReconnectServerScheduleID ~= -1 then
                WZLog("SceneLogin:connectCallbackByToken ten two-1",g_nReconnectServerScheduleID)
                CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(g_nReconnectServerScheduleID)
                g_nReconnectServerScheduleID = -1
            end
            if -1 == g_nReconnectServerScheduleID then
                g_nReconnectServerScheduleID = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(IPDConnector.checkIPDServerUpdate, 0, false)
            end
            if -1 == g_nReconnectServerBeginTime then
                g_nReconnectServerBeginTime = os.time()
            end
            
            -- --开启断线重连定时器与重连超时判断定时器
            -- if g_nReconnectScheduleID ~= nil and g_nReconnectScheduleID ~= -1 then
            --     WZLog("SceneLogin:connectCallback five-1",g_nReconnectScheduleID)
            --     CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(g_nReconnectScheduleID)
            --     g_nReconnectScheduleID = -1
            -- end
            -- if -1 == g_nReconnectScheduleID then
            --     g_nReconnectScheduleID = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(IPDConnector.Reconnecting, 0, false)
            -- end
            -- if -1 == g_nReconnectBeginTime then
            --     g_nReconnectBeginTime = os.time()
            -- end

            --MsgBoxManager:showConfirmBox(LocalStrings.NETWORK_UNAVAILABLE, self, self.networkUnavailableTipCallback2, MSGBOXLEVEL_HIGH, nil,true)

        --断线重连后，连接IPD成功，但连接游戏服务器再次断开，立即弹出提示框
        elseif NET_FLAG_3 == IPDConnector.g_nNetConnectFlag then
            WZLog("SceneLogin:connectCallback six")
            MsgBoxManager:showConfirmBox(LocalStrings.NETWORK_UNAVAILABLE, self, self.networkUnavailableTipCallback, MSGBOXLEVEL_HIGH, nil,true)
        
        --断线重连超时后，每次连接失败都立即弹出提示框
        elseif NET_FLAG_4 == IPDConnector.g_nNetConnectFlag then
            WZLog("SceneLogin:connectCallback seven", tostring(IPDConnector.g_bIpdConnectOk))
            if IPDConnector.g_bIpdConnectOk then
                MsgBoxManager:showConfirmBox(LocalStrings.NETWORK_UNAVAILABLE, self, self.networkUnavailableTipCallback, MSGBOXLEVEL_HIGH, nil,true)
            end

        --对于断线重连后需要切换到小岛的特殊界面，立即弹出提示框
        elseif NET_FLAG_7 == IPDConnector.g_nNetConnectFlag then
            WZLog("SceneLogin:connectCallback eight")
            MsgBoxManager:showConfirmBox(LocalStrings.NETWORK_UNAVAILABLE, self, self.networkUnavailableTipCallback, MSGBOXLEVEL_HIGH, nil,true)
        end
        
        return
    end
    
    --与游戏服务器的链接断开
    if connectResult == CONNECTSERVER_DISCONNECT then
        WZLog("SceneLogin:connectCallback nine", tostring(NetManager.g_bIsRepeatLogin), tostring(IPDConnector.g_nNetConnectFlag), tostring(g_nReconnectLoadingBoxID))

        --账号重复登录处理（账号重复登录会被服务器踢掉线，此时不自动重连）
        if NetManager.g_bIsRepeatLogin then
            return
        end

        --游戏挂后台的特殊处理
        if IPDConnector.g_nNetConnectFlag == NET_FLAG_0 then
            return
        end

        NetManager.g_bConnectFailed = true

        --显示断线重连loading框
        if -1 == g_nReconnectLoadingBoxID then
            WZLog("SceneLogin:connectCallback ten")
            g_nReconnectLoadingBoxID = MsgBoxManager:showLoadingBox(9999999)
        end

        --退出语音服务器
        VoiceChat:logoutVoiceServer()
        
        if NET_FLAG_1 == IPDConnector.g_nNetConnectFlag then
            WZLog("SceneLogin:connectCallback ten one")
            MsgBoxManager:showConfirmBox(LocalStrings.NETWORK_UNAVAILABLE, self, self.accountCallbacl, MSGBOXLEVEL_HIGH, nil,true)
        elseif NET_FLAG_2 == IPDConnector.g_nNetConnectFlag then
            WZLog("SceneLogin:connectCallback ten two")

            -- do
            --     if -1 == g_nReconnectBeginTime then
            --         g_nReconnectBeginTime = os.time()
            --     end
            --     IPDConnector:checkIPDServer()
            --     return
            -- end

            IPDConnector:checkIPDServer()
            if -1 == g_nReconnectBeginTime then
                g_nReconnectBeginTime = os.time()
            end

            --开启断线重连服务器状态定时器
            if g_nReconnectServerScheduleID ~= nil and g_nReconnectServerScheduleID ~= -1 then
                WZLog("SceneLogin:connectCallbackByToken ten two-1",g_nReconnectServerScheduleID)
                CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(g_nReconnectServerScheduleID)
                g_nReconnectServerScheduleID = -1
            end
            if -1 == g_nReconnectServerScheduleID then
                g_nReconnectServerScheduleID = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(IPDConnector.checkIPDServerUpdate, 0, false)
            end
            if -1 == g_nReconnectServerBeginTime then
                g_nReconnectServerBeginTime = os.time()
            end

            -- --开启断线重连定时器与重连超时判断定时器
            -- if g_nReconnectScheduleID ~= nil and g_nReconnectScheduleID ~= -1 then
            --     WZLog("SceneLogin:connectCallback ten two-1",g_nReconnectScheduleID)
            --     CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(g_nReconnectScheduleID)
            --     g_nReconnectScheduleID = -1
            -- end
            -- if -1 == g_nReconnectScheduleID then
            --     g_nReconnectScheduleID = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(IPDConnector.scheduleFuncReconnecting, 0, false)
            -- end
            -- if -1 == g_nReconnectBeginTime then
            --     g_nReconnectBeginTime = os.time()
            -- end
        
        --断线重连后，连接IPD成功，但连接游戏服务器再次断开，立即弹出提示框
        elseif NET_FLAG_3 == IPDConnector.g_nNetConnectFlag then
            WZLog("SceneLogin:connectCallback ten three")
            MsgBoxManager:showConfirmBox(LocalStrings.NETWORK_UNAVAILABLE, self, self.networkUnavailableTipCallback, MSGBOXLEVEL_HIGH, nil,true)

        --断线重连超时后，每次连接失败都立即弹出提示框
        elseif NET_FLAG_4 == IPDConnector.g_nNetConnectFlag then
            WZLog("SceneLogin:connectCallback ten three")
            if IPDConnector.g_bIpdConnectOk then
                MsgBoxManager:showConfirmBox(LocalStrings.NETWORK_UNAVAILABLE, self, self.networkUnavailableTipCallback, MSGBOXLEVEL_HIGH, nil,true)
            end

        --对于断线重连后需要切换到小岛的特殊界面，立即弹出提示框
        elseif NET_FLAG_7 == IPDConnector.g_nNetConnectFlag then
            WZLog("SceneLogin:connectCallback ten four")
            MsgBoxManager:showConfirmBox(LocalStrings.NETWORK_UNAVAILABLE, self, self.networkUnavailableTipCallback, MSGBOXLEVEL_HIGH, nil,true)
        end
        
        return
    end
end

--@note SDK  在第一链接IPD前得到账号 密码
function SceneLogin:LoginCallBackForAccount(jsonArg)

    local t_jsonArg = SDK_Util:decodeFromJson(jsonArg);
    CCLuaLog("SceneLogin:LoginCallBackForAccount  ------")
    if t_jsonArg["return"] == "fail" then
        CCLuaLog("uid, token , nil ");

        if not (GlobalGame.g_nCurrentUIChannelId == Chat_Channel_Setting and ProjConfig.IS_FREE_REGISTER == 2) then
            MsgBoxManager:showConfirmBox(LocalStrings.LOGIN_FAILD, nil, SceneLogin.reLogin, MSGBOXLEVEL_HIGH, nil)
        end

        return
    end
    CCLuaLog(t_jsonArg.uid);

    local account = t_jsonArg.prefix .. t_jsonArg.uid

    CCLuaLog("account:" .. account);

    local data = WZDataFile:getInstance():getUserData()

    if data ~= nil then
        if  t_jsonArg.FreeLogin then
            data:setStringValue("AccountData", "accountFreeLogin", t_jsonArg.FreeLogin)
        end
        data:setStringValue("AccountData", "account", account)

        data:setStringValue("AccountData", "password", account)

        data:flush()
    end

    self.m_callback(self.m_callbacktable,account,account)
end




function SceneLogin:loginCallBack(jsonArg)

    --CCLuaLog("SDK loginCallBack----",debug.traceback());
    --CCLuaLog(jsonArg);
    local t_jsonArg = SDK_Util:decodeFromJson(jsonArg);
    CCLuaLog("SceneLogin:loginCallBack  ------")
    if t_jsonArg["return"] == "fail" then
        CCLuaLog("uid, token , nil ");

        if not (GlobalGame.g_nCurrentUIChannelId == Chat_Channel_Setting and ProjConfig.IS_FREE_REGISTER == 2) then
            MsgBoxManager:showConfirmBox(LocalStrings.LOGIN_FAILD, nil, SceneLogin.reLogin, MSGBOXLEVEL_HIGH, nil)
        end

        return
    end
    CCLuaLog(t_jsonArg.uid);

    --CCLuaLog(t_jsonArg.ifGotUid);

    --CCLuaLog(tostring(t_jsonArg.token));

    local account = t_jsonArg.prefix .. t_jsonArg.uid

    CCLuaLog("account:" .. account);

    local data = WZDataFile:getInstance():getUserData()

        if data ~= nil then
            if  t_jsonArg.FreeLogin then
                data:setStringValue("AccountData", "accountFreeLogin", t_jsonArg.FreeLogin)
            end
            data:setStringValue("AccountData", "account", account)

            data:setStringValue("AccountData", "password", account)

            data:flush()

        end
    SceneLogin.m_loginType = 2
    WZLog("NetManager:connectServer=====",IPDConnector:getGameServerIP(), IPDConnector:getGameServerPort(), SceneLogin.connectCallback, SceneLogin)
    NetManager:connectServer(IPDConnector:getGameServerIP(), IPDConnector:getGameServerPort(), SceneLogin.connectCallback, SceneLogin)

    SceneLogin:loginBySDK()
    GlobalGame.g_nCurrentUIChannelId = 1
    CCLuaLog("SceneLogin:loginBySDK");

end

--@brief    通过账号登录

--@note     通过注册(绑定)的账号登录

function SceneLogin:loginBySDK()

    WZLog("--------------SceneLogin:loginBySDK-------------------", tostring(SceneLogin.g_curerntUserAccount))

    local data = WZDataFile:getInstance():getUserData()

    if nil == data then

        return

    end

    local udid = WGameCmUtil:GetUDID()

    local accountName = data:getStringValue("AccountData", "account")

    local passWord = data:getStringValue("AccountData", "password")

    local version = WZDeviceInfo:appVersion()-- WGameCmUtil:getAppVersion()

    local channel = PassportSdkManager:getChannelId()

    local isChannelLogon = 1

    local oldudid = WGameCmUtil:GetUDID()

    WZLog("udid:"..udid)

    WZLog("accountName:"..accountName)

    WZLog("Version:"..version)

    WZLog("channel:"..channel)

    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local curSdkObj = PassportSdkManager:getCurSdkObj()
    local config = curSdkObj.m_tConfig
    local isGotoFirstScene = true
    if config.SDKOtherConfig.loginNoGotoFirstScene == "true" then
        isGotoFirstScene = false
    end
    WZLog("SceneLogin.g_curerntUserAccount",SceneLogin.g_curerntUserAccount,accountName)
    --if SceneLogin.g_curerntUserAccount == nil or isGotoFirstScene == false or tostring(SceneLogin.g_curerntUserAccount) == tostring(accountName) then
        WZLog("SceneLogin.g_curerntUserAccount nil ",accountName)
        SceneLogin.g_curerntUserAccount = accountName
        ProtocolProcessorAccount:send_ACCOUNT_Login(udid, accountName, passWord, version, channel, isChannelLogon, oldudid)
    --[[
    else
        SceneLogin.g_curerntUserAccount = accountName

        --NetManager:connectServer(IPDConnector:getGameServerIP(), IPDConnector:getGameServerPort(), SceneLogin.connectCallback, SceneLogin)
        SceneLogin:startLogin()
        --gotoFirstScene()
    end
    --]]

end


--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--@brief    网络连接断开提示对话框回调
--@param    nId:消息ID
--@param    nType:响应类型
--@note     网络连接断开提示对话框回调
function SceneLogin:networkUnavailableTipCallback()
    WZLog("SceneLogin:networkUnavailableTipCallback", GlobalGame.g_tSysConfig.connectState)

    if GlobalGame.g_tSysConfig.connectState ~= CONNECTSERVER_SUCCESS then
        IPDConnector:checkIPDServer()
        IPDConnector.g_nNetConnectFlag = NET_FLAG_2
        if -1 == g_nReconnectBeginTime then
            g_nReconnectBeginTime = os.time()
        end

        --开启断线重连服务器状态定时器
        if g_nReconnectServerScheduleID ~= nil and g_nReconnectServerScheduleID ~= -1 then
            WZLog("SceneLogin:connectCallbackByToken ten two-1",g_nReconnectServerScheduleID)
            CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(g_nReconnectServerScheduleID)
            g_nReconnectServerScheduleID = -1
        end
        if -1 == g_nReconnectServerScheduleID then
            g_nReconnectServerScheduleID = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(IPDConnector.checkIPDServerUpdate, 0, false)
        end
        if -1 == g_nReconnectServerBeginTime then
            g_nReconnectServerBeginTime = os.time()
        end

        -- if g_nReconnectScheduleID ~= nil and g_nReconnectScheduleID ~= -1 then
        --     WZLog("SceneLogin:networkUnavailableTipCallback2",g_nReconnectScheduleID)
        --     CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(g_nReconnectScheduleID)
        --     g_nReconnectScheduleID = -1
        -- end
        -- --开启断线重连定时器与重连超时判断定时器
        -- if -1 == g_nReconnectScheduleID then
        --     g_nReconnectScheduleID = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(IPDConnector.Reconnecting, 0, false)
        -- end
    end
end

--@brief    网络连接断开提示对话框回调
--@param    nId:消息ID
--@param    nType:响应类型
--@note     网络连接断开提示对话框回调
function SceneLogin:networkUnavailableTipCallback2()
    WZLog("SceneLogin:networkUnavailableTipCallback2")
    if g_nReconnectScheduleID ~= nil and g_nReconnectScheduleID ~= -1 then
        WZLog("SceneLogin:networkUnavailableTipCallback2",g_nReconnectScheduleID)
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

--@brief    重复账号登陆提示对话框回调
function SceneLogin:accountRepeatLoginCallback()
    WZLog("SceneLogin:accountRepeatLoginCallback")

    IPDConnector.g_nNetConnectFlag = NET_FLAG_1
   -- NetManager.g_bIsRepeatLogin = false
    NetManager.g_bConnectFailed = true
    SceneLoginMgr:showScene(2)

--    if -1 == g_nReconnectLoadingBoxID then
--        WZLog("SceneLogin:connectCallback ten")
--        g_nReconnectLoadingBoxID = MsgBoxManager:showLoadingBox(9999999)
--    end
--
--
--    NetManager:pcb_ConnectFailed()
--    NetManager.g_bIsRepeatLogin = false
--    NetManager.g_bConnectFailed = true
--
--    if GlobalGame.g_tSysConfig.connectState ~= CONNECTSERVER_SUCCESS then
--        WZLog("houhouhouhou")
--        GlobalGame:reset()
--        CacheCenter:reset()
--        PrefetchCache:reset()
--        IPDConnector.g_nNetConnectFlag = NET_FLAG_1
--        local data = WZDataFile:getInstance():getUserData()
--        if nil == data then
--            return
--        end
--        accountName = data:getStringValue("AccountData", "account")
--        passWord = data:getStringValue("AccountData", "password")
--        WZLog("fdasf41234124123",accountName,accountName)
--        IPDConnector:connectIPDServer(accountName,passWord,true)
--    end

    --[[
    GlobalGame:reset()
    CacheCenter:reset()
    PrefetchCache:reset()
    
    IPDConnector.g_nNetConnectFlag = NET_FLAG_1
    IPDConnector:connectIPDServer()
    --]]
end

--@brief    通过账号登录
--@note     通过注册(绑定)的账号登录
function SceneLogin:loginByAccount()
    WZLog("--------------SceneLogin:loginByAccount-------------------")
    local data = WZDataFile:getInstance():getUserData()
    if nil == data then
        return
    end
    local udid = WGameCmUtil:GetUDID()
    local accountName = data:getStringValue("AccountData", "account")
    local passWord = data:getStringValue("AccountData", "password")
    local version = WZDeviceInfo:appVersion() --WGameCmUtil:getAppVersion()
    local channel =  PassportSdkManager:getChannelId()
    local isChannelLogon = 0
    local oldudid = 0
    WZLog("udid:"..udid)
    WZLog("accountName:"..accountName)
    WZLog("Version:"..version)
    WZLog("channel:"..channel)
    
    ProtocolProcessorAccount:send_ACCOUNT_Login(udid, accountName, passWord, version, channel, isChannelLogon, oldudid)
end

--@brief    通过udid登录
--@note     未注册（绑定账号时），通过udid登录
function SceneLogin:loginByUDID()
    WZLog("----------------SceneLogin:loginByUDID-------------------")
    local udid =  WGameCmUtil:GetUDID()
    local accountName = WGameCmUtil:GetUDID()
    local passWord = WGameCmUtil:GetUDID()
    local version = WZDeviceInfo:appVersion() --WGameCmUtil:getAppVersion()
    local channel = PassportSdkManager:getChannelId()

    local isChannelLogon = 0
    local oldudid = 0
    WZLog("SceneLogin:loginByUDID udid:"..udid)
    WZLog("SceneLogin:loginByUDID accountName:"..accountName)
    WZLog("SceneLogin:loginByUDID Version:"..version)
    WZLog("SceneLogin:loginByUDID channel:"..channel)
    
    ProtocolProcessorAccount:send_ACCOUNT_Login(udid, accountName, passWord, version, channel, isChannelLogon, oldudid)
end

--@brief    是否已经注册过
--@note     判断用户是否已经注册过
function SceneLogin:isRegistered()
    local data = WZDataFile:getInstance():getUserData()
    if nil == data then
        return
    end
    
    local accountName = data:getStringValue("AccountData", "account")
    local passWord = data:getStringValue("AccountData", "password")
    if accountName ~= nil and accountName ~= "" and passWord ~= nil and passWord ~= "" then
        return true
    end
    
    return false
end

--@brief    获得用户注册的账户名
--@return   #1:用户注册的账户名
--@note     获得用户注册的账户名
function SceneLogin:getAccountName()
    local data = WZDataFile:getInstance():getUserData()
    if data ~= nil then
        local sAccountName = data:getStringValue("AccountData", "account")
        if sAccountName ~= "" then
            return sAccountName
        end
    end
    return nil
end

--@brief    设置登录提示文本
--@param    text:要设置的文本
--@note     设置登录提示文本
function SceneLogin:setLoginTipText(text)
    local txtLoginTip = self.m_root:getChildElement("txtLoginTip_SceneLogin")
    if txtLoginTip ~= nil then
        WZUIShadowTTF:luaTo(txtLoginTip):setText(text)
    end
end

--@brief   发送外挂进程到SDK
--@param
--@note
function SceneLogin:checkAntiPlug(plugName,plugValue)

    -- if PlatformInfo:getCurrentPlatform() == PlatformInfo.type.PLATFORM_IOS then
        -- local plugtabel = {}
        -- plugtabel.PlugName = {}
        -- plugtabel.PlugValue = {}
        -- for var = 0,plugName:size() -1 do
            -- table.insert(plugtabel.PlugName,plugName:get(var))
            -- WZLog("plugName:get(var):",plugName:get(var))
            -- table.insert(plugtabel.PlugValue,plugValue:get(var))
            -- WZLog("plugValue:get(var):",plugValue:get(var))
        -- end
        -- plugtabel.CodeType = "check"
        -- plugtabel.funType = "check"
        -- WZLog("SceneLogin:checkAntiPlug:",json.encode(plugtabel))
        -- --local curSdkObj = PassportSdkManager:getCurSdkObj()
        -- --curSdkObj:accountOthers(json.encode(plugtabel),nil,nil)
        -- local adapter = WydPlAdapterManager:sharedWydPlAdapterManager():createAdapter("CheckIOSPlugHelper")
        -- WZLog("adapter:-------------------------",adapter)
        -- if adapter ~= nil  then
            -- adapter:callMethodByNameReturn("setProcessArg",json.encode(plugtabel))
            -- WydPlAdapterManager:sharedWydPlAdapterManager():destroyAdapter(adapter:getId())
        -- end
    -- elseif PlatformInfo:getCurrentPlatform() == PlatformInfo.type.PLATFORM_ANDROID then 
        -- local plugtabel = {}
        -- local sPlugName = ""
        -- local sPlugValue = ""
        -- for var = 0,plugName:size() -1 do
            -- sPlugName  = tostring(sPlugName)..tostring(plugName:get(var)).." "
            -- sPlugValue = tostring(sPlugValue)..tostring(plugValue:get(var)).." "
        -- end
        -- plugtabel.funType = "check"
        -- plugtabel.CodeType = "check"
        -- plugtabel.PlugName = sPlugName
        -- plugtabel.PlugValue = sPlugValue
        -- WZLog("SceneLogin:checkAntiPlug111111:",json.encode(plugtabel))
        -- --local curSdkObj = PassportSdkManager:getCurSdkObj()
        -- --curSdkObj:accountOthers(json.encode(plugtabel),nil,nil)
        -- --
        -- local adapter = WydPlAdapterManager:sharedWydPlAdapterManager():createAdapter("com/wyd/xingepush/WydXingeHelper")
        -- local plugInfo = adapter:callMethodByNameReturn("setPlugInfo",json.encode(plugtabel))
        -- WydPlAdapterManager:sharedWydPlAdapterManager():destroyAdapter(adapter:getId())
    -- end


end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function SceneLogin:reLogin()
    local params = ""
    local curSdkObj = PassportSdkManager:getCurSdkObj()
    local config = curSdkObj.m_tConfig
    if config.SDKOtherConfig.checkUserData == "true" and config.SDKOtherConfig.hasAccountBtnParam then 
        local data = WZDataFile:getInstance():getUserData() if nil ~= data then
            local freeLogin = data:getStringValue("AccountData", "accountFreeLogin")
            if freeLogin == "false" then
                params = config.SDKOtherConfig.hasAccountBtnParam
            end
        end
    end 
    curSdkObj:login(params ,SceneLogin.loginCallBack, SceneLogin)
end


function SceneLogin:accountCallbacl()
    gotoFirstScene()
   -- MsgBoxManager:showConfirmBox(LocalStrings.ACCOUNT_HAS_PROHIBITED_TIPS, self, self.accountCallbacl, MSGBOXLEVEL_NORMAL, nil)
end
-------------------------------------私有方法模块End----------------------------------------

