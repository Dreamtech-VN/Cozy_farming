--WndLoginSelect.lua
--@brief	WndLoginSelect的UI模块
--@date		2015-6-12
--@author	binshao
--@note		登陆账号选择


-------------------------------------公有方法模块Begin--------------------------------------

function WndLoginSelect:onEnter(element)
	WZLog("WndLoginSelect:onEnter")
	self.m_root = element
    AdaptLanguage(self)
    self.isSdkLogin = PassportSdkManager:needLogin()
    self.sdkIndex = getLoginType()
    WZLog("----------------sdk----------------",self.isSdkLogin,self.sdkIndex)
    PostPlayerEvent:postEvent(PostPlayerEvent.event_enterLoginUI)
    if self.isSdkLogin then
        local conSdk = GetElement(self.m_root,"conSdkLogin_WndLoginSelect",WZUIContainer) -- 一个按键登陆
        conSdk:setVisible(true)
    else
        self:setConLoginState(true)
        self:_initAccountSaveState()
        self:_initPlaceHolder()
    end
    g_canInvite = false
	g_selectPlayerId = nil
    IPDConnector.g_nNetConnectFlag = NET_FLAG_1
    GlobalGame.g_bIsDisconnectToLoginOk = nil

    if self.changeServer then
        self:getIpdHttpServerList()
    --    self.changeServer = false
    end
    PassportSdkManager:doAnzhiOthers("highFloatButton")
    -- 简体中文出现警告提示
    if ProjConfig.LANGUAGE == "cn" then
        self:_addWarnDesc()
    end
    local packName = WGameCmUtil:GetBundleIdentifier()
    if packName == "com.wyd.hero.dandandao.kaopu" then
        GetElement(self.m_root,"btnBackLogin_WndLoginSelect",WZUIButton):setVisible(false)
    elseif packName == "com.tencent.tmgp.DDD2"  then
        GetElement(self.m_root,"btnChangeAccount_WndLoginSelect",WZUIButton):setVisible(true)
    end
    if packName == "com.ddjt.lucky" then
        GetElement(self.m_root,"btnBack_WndLoginSelect",WZUIButton):setVisible(false)
    end
      
end

function WndLoginSelect:onExit(element)
    self.m_root:disableSchedule()
	self:_unInit()
end

function WndLoginSelect:showWnd(isChangeServer)
    local WndLogin = WndLoginSelect:createElement()
    WindowManager:addWindow( WndLogin , WndLoginSelect)
    self.changeServer = isChangeServer
end

function WndLoginSelect:onTouchBegan(element,pt)
end

-- 登出游戏
function WndLoginSelect:loginOutGame()
    local packName = WGameCmUtil:GetBundleIdentifier()
    if self.m_root and packName == "com.wyd.dandandao2.PP" then
        return
    end
    IPDConnector.g_nNetConnectFlag = NET_FLAG_1
    KLuaMutiRegSocket:getInstance():closeSocket()
    WindowManager:removeWindow(self.m_root, self, true)
    SceneLoginMgr:showScene(2,false,true)
end

-- 换区
function WndLoginSelect:OnBtnChangeArea()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local index = IPDhttpServer:getLogined() and 0 or 1
    WZLog("-------------index----------------",index)

    WndServersSel:showWndUI(index)
end

--切换账号
function WndLoginSelect:onChangeaccount(element)
    local tData = {}
    tData.funType = "logout"
    PassportSdkManager:Others(tData)
end

-- 控制进入游戏按键的时间
function WndLoginSelect:btnClickTime()
    if self.clickTime == 0 then
        self.clickTime = os.time()
        WZLog("---------time----------1",self.clickTime)
    else
        local time = os.time()-self.clickTime
        WZLog("---------time----------2",time,self.clickTime)
        if time < 1 then
            return false
        else
            self.clickTime = os.time()
        end
    end
    return true
end

-- 进入游戏按键回调
function WndLoginSelect:OnBtnEnterGame()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    PostPlayerEvent:postEvent(PostPlayerEvent.event_clickEnterGame)
    if self:btnClickTime() == false then
        return
    end

    WZLog("---------get serverlist state------------------",self.getServersListFlag)
    if not self.getServersListFlag then
        return
    end

    -- 如果当前服务器没有开启不能进入游戏
    local serverInfo = IPDhttpServer:getCurServer()
    local status = serverInfo.status
    if status == 1 then
        local desc = serverInfo.bulletin
        MsgBoxManager:showConfirmBox(desc, self, self.getIpdHttpServerList, MSGBOXLEVEL_NORMAL, nil,true) -- 维护
        return
--    elseif status == 6 then
--        MsgBoxManager:showTipBox(LocalStrings.SERVER_FULL_PERSON) -- 满人
--        return
    end

    self:isNeedQueue()

--    if g_tAccountData.loginFlag == 2 then
--        WZLog("-----------------test quene------------------------")
--        -- 先判断是否需要排队
--        self:isNeedQueue()
--    else
--        self:NoNeedQueueAndEnterGame()
--    end
end

function WndLoginSelect:NoNeedQueueAndEnterGame()
    WZLog("------------------login game ok and next loading res------------------")
    -- 进入加载资源
    WindowManager:removeWindow(self.m_root, self, true)
    SceneLoginMgr:showScene(3)
end

function WndLoginSelect:delaySendHttpServerList()
    WZLog("-----------account uid-------------------",WGameCmUtil:GetUDID())
    self.getServersListFlag = false
    local ipdAddr = ProjConfig:getIpdAddr()
    local channelId = ProjConfig:getChannelId()
    local uId = WGameCmUtil:GetUDID()
    local name = g_tAccountData.accountName
    local password = g_tAccountData.passWord
    local version =  WZDeviceInfo:appVersion()
    self.isSdkLogin = PassportSdkManager:needLogin()
    local isChannel = self.isSdkLogin and 1 or 0
    if isChannel == 0 and self.isSdkFlag then
        -- 二次判断
        isChannel = 1
    end
    local sign = WZDeviceInfo:md5Generate(uId..name..password..version..channelId..isChannel.."gz!y^d&zh*wyd")
    local data = { id = uId, username = name, password = password, channel = channelId, version = version, isChannel = isChannel,sign = sign }
    local vBytes = WGameCmUtil:EnCrypt(json.encode(data), ENCRYPT_KEY)
    local sData = WGameCmUtil:transformBytesToString(vBytes)
    local url = "http://"..ipdAddr.."/load?data="..sData
    if ProjConfig.USE_HTTPS and ProjConfig.USE_HTTPS == 1 then
        url = "https://"..ipdAddr.."/load?data="..sData
    end
    WZLog("IpdHttpServerListUrl = ",url)
    PushSdkManager:setAccount(name)
    WZLog("WndLoginSelect:name:",name)
    IPDhttpServer:getHttpServerData(url)
    PostPlayerEvent:postEvent(PostPlayerEvent.event_requestServerList)
    self.m_root:disableSchedule()
end

-- 获取服务器列表
function WndLoginSelect:getIpdHttpServerList()
    self:_createLoadingBox(600)
    self.m_root:enableSchedule("delaySendHttpServerList",0.5)
end

-- 服务器列表回调
function WndLoginSelect:getServerListSuccess(isConnect)
    self:_closeLoadingBox()
    self.getServersListFlag = isConnect
    if isConnect then
        self:LoginSuccess()
    else
        MsgBoxManager:showConfirmBox(LocalStrings.NETWORK_UNAVAILABLE, self, self.getServerListFailCallBack, MSGBOXLEVEL_NORMAL, nil,true)
    end
end

-- 服务器连接失败回调
function WndLoginSelect:getServerListFailCallBack(cnt,tag)
    if tag == 1 then self:getIpdHttpServerList()  end
end

-- 服务器维护
function WndLoginSelect:serverMaintain()
    self:_closeLoadingBox()
    MsgBoxManager:showConfirmBox(LocalStrings.SERVER_MAINTAINING,nil,nil,nil,nil,true)
end

------------------------------------------------SDK---------------------------------------------------------------------
-- SDK回调
function WndLoginSelect:sdkLoginCallback(jsonArg)
    WZLog("WndLoginSelect:sdkLoginCallback:",jsonArg)
    if WndLoadLuaResources.m_root or WndDownLoad.m_root then
        WZLog("--------99-------------",WndLoadLuaResources.m_root)
        WZLog("--------98-------------",WndDownLoad.m_root)
        return
    end
    --此处调用，避免在SDK登入成功后将它隐藏
    PassportSdkManager:doAnzhiOthers("highFloatButton")
    if not WndLoginSelect.m_root then
        WZLog("WndLoginSelect:sdkLoginCallback is not root")
        KLuaMutiRegSocket:getInstance():closeSocket()
        NetManager:disableBreathNotifyDisconnect()
        SceneLoginMgr:showScene(2,true)
        IPDConnector.g_nNetConnectFlag = NET_FLAG_1
        g_canInvite = false
        GlobalGame.g_bIsDisconnectToLoginOk = nil
    end

    local t_jsonArg = SDK_Util:decodeFromJson(jsonArg)
    WZLog("WndLoginSelect:sdkLoginCallback------------",jsonArg)
    if t_jsonArg["return"] == "success" then
        if not WndLoginSelect.m_root then
            KLuaMutiRegSocket:getInstance():closeSocket()
            NetManager:disableBreathNotifyDisconnect()
            --        local newScene = WndLoginSelect:createElement()
            --        replaceScene(newScene)
            SceneLoginMgr:showScene(2)
            IPDConnector.g_nNetConnectFlag = NET_FLAG_1
            g_canInvite = false
            GlobalGame.g_bIsDisconnectToLoginOk = nil
        end
        g_loginType = t_jsonArg["loginType"] or ""
        local account =t_jsonArg.uid --tostring(channelId).."-"..t_jsonArg.uid
        --越南语同账号的特殊修改
        local packName = WGameCmUtil:GetBundleIdentifier()
        if packName == "com.wyd.gunpow" or packName == "com.gp.mobi" then
            account = string.gsub(account,"vn%-","vn_")
        end 
        if ProjConfig.LANGUAGE == "vn" then
             g_vn_userId = string.sub(account,4)
             g_vn_sessionId = t_jsonArg["sessionId"] or ""
             WZLog("g_vn_userId:",g_vn_userId,g_vn_sessionId)
        end
        local channelId = tonumber(t_jsonArg.channelId)
        WZLog("-------------channelId-----------",channelId)
        if channelId ~= nil and channelId ~= "" then
            --判断平台且为85的转为106（这期的特殊处理）
            if channelId == 85 and WZUISystem:getInstance():getPlatformInfo() == 1 then
                channelId = 106
            end
            WZLog("sdkChannelID:",channelId)
            ProjConfig.CHANNEL_ID = channelId
        end
        --针对奇虎360包的修改
        local packageName = WGameCmUtil:GetBundleIdentifier()
        if packageName == "com.wyd.hero.dandandao.qihu" then
            ProjConfig.CHANNEL_ID = 12
        end
        --针对华为的关掉debug处理
        if tostring(ProjConfig.CHANNEL_ID) == "24" and ProjConfig.DEBUG == 1 then
            ProjConfig.DEBUG = 0
            CCDirector:sharedDirector():setDisplayStats(false)
        end
        --渠道的uid
        gChannelUid = "0"
        local tUid = SplitStringWithSeparator(account, "-")
        if #tUid >= 3 then
            gChannelUid = ""
            for i = 3,#tUid do
                gChannelUid = gChannelUid..tUid[i]
            end
        else
            gChannelUid = account
        end
        --针对heroU没区分渠道号的修改
        if packageName == "com.wyd.hero.dandandao.lb" or packageName == "com.wyd.hero.dandandao.lb.lb" then
            ProjConfig.CHANNEL_ID = 50007
        elseif packageName == "com.wyd.hero.dandandao.dmw" then
            ProjConfig.CHANNEL_ID = 463
        elseif packageName == "com.wyd.hero.dandandao.yxf" then
            ProjConfig.CHANNEL_ID = 306
        elseif packageName == "com.wyd.hero.dandandao.hz" then
            ProjConfig.CHANNEL_ID = 628
        end
        --针对heroU四个渠道的帐号做特殊处理将herosdk-xxx-userid改成herosdk-userid
        if ProjConfig.CHANNEL_ID == 50007 or ProjConfig.CHANNEL_ID == 463 or ProjConfig.CHANNEL_ID == 306 or ProjConfig.CHANNEL_ID == 628 then
            --WZLog("WndLoginSelect:sdkLoginCallback-account pre:",account)
            if #tUid >= 3 then
                account = tUid[1].."-"..tUid[3]
            end
            --WZLog("WndLoginSelect:sdkLoginCallback-account after:",account)
        end
        WZLog("yyyyyyy:",gChannelUid,#tUid)
        GlobalGame.g_oppo_channel = t_jsonArg["oppo_channel"] or "-1"
        GlobalGame.g_oppo_adId = t_jsonArg["oppo_adId"] or "-1"
        WZLog("WndLoginSelect:sdkLoginCallback------------oppo:",GlobalGame.g_oppo_channel,GlobalGame.g_oppo_adId)
        PostPlayerEvent:postEvent(PostPlayerEvent.event_loginSuccess)
        PostPlayerEvent:postEvent(PostPlayerEvent.event_sdkLoginSuccess)
        local passWord = account
        local channelId = ProjConfig:getChannelId()            
        g_tAccountData = {accountName = account,passWord = passWord, loginFlag = 0 }
        self.isSdkFlag = true
        if self.m_root then
            self:getIpdHttpServerList()
        end
    else
        PostPlayerEvent:postEvent(PostPlayerEvent.event_loginFail)            
        self:_closeLoadingBox()
    end
end

-- SDK登陆
function WndLoginSelect:OnBtnSDK()
    WZLog("-------------------------SDK0--------------------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self:doBtnSDKLogin()
    --SceneLoginMgr:createSnowBallAni()
end

--@brief    执行sdk登陆
function WndLoginSelect:doBtnSDKLogin()
    -- body
    self:_createLoadingBox(60)
    PostPlayerEvent:postEvent(PostPlayerEvent.event_clickStartLogin)
    PassportSdkManager:doLogin(self.sdkLoginCallback, self)
end
------------------------------------------------SDK---------------------------------------------------------------------

--------------------------------------------------------本地账号--------------------------------------------------------

-- 游客
function WndLoginSelect:OnMyYK()
    WZLog("---------------YK2-----------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    PostPlayerEvent:postEvent(PostPlayerEvent.event_clickVisitorLogin)
    --海外包游客登入的特殊处理
    -- local packName = WGameCmUtil:GetBundleIdentifier()
    -- if packName == "com.ios.rwt.bombcrash" then
    --      PassportSdkManager:doLogin(self.sdkLoginCallback, self,"")
    --      return
    -- end
    local accountName = WGameCmUtil:GetUDID()
    local passWord = WGameCmUtil:GetUDID()
    WZLog("------------------YK---------------",accountName,passWord)
    g_tAccountData = {accountName = accountName,passWord = passWord,loginFlag = 2 }
    self:getIpdHttpServerList()
end

-- 注册
function WndLoginSelect:OnMyRegist()
    WZLog("--------------ZC-----------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local conRegist = GetElement(self.m_root,"conMyRegist"..self.sdkIndex.."_WndLoginSelect",WZUIContainer)
    conRegist:setVisible(true)
    self:setConLoginState(false)
    PostPlayerEvent:postEvent(PostPlayerEvent.event_clickRegisiter)
end

-- 注册界面--返回回调
function WndLoginSelect:OnMyRegistBack()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self:setConLoginState(true)
    local conRegist = GetElement(self.m_root,"conMyRegist"..self.sdkIndex.."_WndLoginSelect",WZUIContainer)
    conRegist:setVisible(false)
    -- 清空当前的注册信息
    self:_clearRegistUIEditBox()
    PostPlayerEvent:postEvent(PostPlayerEvent.event_closeRegisiterView)
end

-- 注册界面--注册回调
function WndLoginSelect:OnMyRegistRegist()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local editA = GetElement(self.m_root,"editRegistAccount"..self.sdkIndex.."_WndLoginSelect",WZUIEditBox)
    local editP1 = GetElement(self.m_root,"editRegistPass"..self.sdkIndex.."_WndLoginSelect",WZUIEditBox)
    local editP2 = GetElement(self.m_root,"editRegistPassSure"..self.sdkIndex.."_WndLoginSelect",WZUIEditBox)
    local editM = GetElement(self.m_root,"editRegistMail"..self.sdkIndex.."_WndLoginSelect",WZUIEditBox)
    local txtAccount = editA:getText()
    local txtP1 = editP1:getText()
    local txtP2 = editP2:getText()
    local txtMail = ""
    if self:_checkAccount(txtAccount) and self:_checkPassword(txtP1) and self:_checkPassword(txtP2) and self:_confirmPassword(txtP1,txtP2) then
        WZLog("--------------can regist--------------------")
        self:_createLoadingBox()
        self.registInfo.account = txtAccount
        self.registInfo.password = txtP1
        local ipdAddr = ProjConfig:getIpdAddr()
        local channelId = ProjConfig:getChannelId()
        local uId = WGameCmUtil:GetUDID()
        local name = txtAccount
        local password = txtP1
        local sign = WZDeviceInfo:md5Generate(uId..name..password..channelId.."gz!y^d&zh*wyd")
        local data = {sign = sign, id = uId, username = name, email = txtMail, channel = channelId,password = password}
        local vBytes = WGameCmUtil:EnCrypt(json.encode(data), ENCRYPT_KEY)
        local sData = WGameCmUtil:transformBytesToString(vBytes)
        local url = "http://" .. ipdAddr.."/create?data="..sData
        if ProjConfig.USE_HTTPS and ProjConfig.USE_HTTPS == 1 then
            url = "https://" .. ipdAddr.."/create?data="..sData
        end
        WZLog("url = ",url)
        IPDhttpServer:getRegistData(url)
    end
end

-- 登陆
function WndLoginSelect:OnMyLogin()
    WZLog("---------------DL1-----------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local editAccount = GetElement(self.m_root,"editAccount"..self.sdkIndex.."_WndLoginSelect",WZUIEditBox)
    local txtAccount = editAccount:getText()
    local editPassword = GetElement(self.m_root,"editPassword"..self.sdkIndex.."_WndLoginSelect",WZUIEditBox)
    local txtPassword = editPassword:getText()
    if self:_checkAccount(txtAccount,true) and self:_checkPassword(txtPassword,true) then
        g_tAccountData = {accountName = txtAccount,passWord = txtPassword,loginFlag = 1 }
        self:getIpdHttpServerList()
        local data = WZDataFile:getInstance():getUserData()
        if data then
            data:setStringValue("AccountData", "account", g_tAccountData.accountName)
            data:setStringValue("AccountData", "password", g_tAccountData.passWord)
            data:flush()
        end
    end
end

-- 改变账号保存的状态
function WndLoginSelect:OnCheckSaveState()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local box = GetElement(self.m_root,"boxSave"..self.sdkIndex.."_WndLoginSelect",WZUICheckBox)
    local data = WZDataFile:getInstance():getUserData()
    if not data then  return end
    local index = box:getCheckIndex()
    data:setStringValue("AccountData", "SaveAccount", index)
    data:flush()
    WZLog("--------------------account state-----------------",index)
    box:setCheckIndex(index)
end
--------------------------------------------------------本地账号--------------------------------------------------------

-- 返回登录选择界面
function WndLoginSelect:OnReturnLoginSel()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    self:returnLoginUI()
    if PassportSdkManager.logout then
        PassportSdkManager:logout()
    end
end
-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------

-- 登陆成功
function WndLoginSelect:LoginSuccess()
    self:setConLoginState(false)
    local conSdk = GetElement(self.m_root,"conSdkLogin_WndLoginSelect",WZUIContainer)      -- 只有一个SDK按键
    local conDesc = GetElement(self.m_root,"conServerDesc_WndLoginSelect",WZUIContainer)   -- 登陆有服务器展示
    local conRegist = GetElement(self.m_root,"conMyRegist"..self.sdkIndex.."_WndLoginSelect",WZUIContainer)
    conSdk:setVisible(false)
    conDesc:setVisible(true)
    conRegist:setVisible(false)
    self:setCurServerName()
    PostPlayerEvent:postEvent(PostPlayerEvent.event_enterServerUI)
    if self.changeServer then
        WndServersSel:resetServerListData()
        self.changeServer = false
    end
--    -- 游客登录弹框
--    if g_tAccountData.loginFlag == 2 then
--        --local desc = {MSGBOXUICFG_CONFIRM = LocalStrings.ACCOUNT_BD1}
--        local desc = {}
--        desc[MSGBOXUICFG_CONFIRM] = LocalStrings.ACCOUNT_BD1
--        --MsgBoxManager:showConfirmBox(LocalStrings.ACCOUNT_BD_DESC, self,self.onBindAccount, nil, desc)
--        MsgBoxManager:showConfirmBox(LocalStrings.ACCOUNT_BD_DESC, nil,nil, nil, nil,true)
--    end
end

-- 返回登陆界面
function WndLoginSelect:returnLoginUI()
    self:setConLoginState(not self.isSdkLogin)
    local conSdk = GetElement(self.m_root,"conSdkLogin_WndLoginSelect",WZUIContainer)      -- 只有一个SDK按键
    local conDesc = GetElement(self.m_root,"conServerDesc_WndLoginSelect",WZUIContainer)   -- 登陆有服务器展示
    conSdk:setVisible(self.isSdkLogin)
    conDesc:setVisible(false)
	if ProjConfig.LANGUAGE == "vn" and self.isSdkLogin then
		PassportSdkManager:logout()
	end
end

-- 设置服务器的名字和区号
function WndLoginSelect:setCurServerName()
    local name,id = IPDhttpServer:getCurServerName(1)
    local txt = GetElement(self.m_root,"txtServerName_WndLoginSelect",WZUILabelTTF)
    txt:setText(name)
    local txtId = GetElement(self.m_root,"txtServerId_WndLoginSelect",WZUILabelTTF)
    txtId:setText(id..LocalStrings.SETTING_SERVER_AREA)
end

-- 修改账号处理，当账号不一样时，清空密码
-- 点击账号输入框开始,记录当前账号
function  WndLoginSelect:onEditAccountBegin()
    local editAccount = GetElement(self.m_root,"editAccount"..self.sdkIndex.."_WndLoginSelect",WZUIEditBox)
    self.oldAccount = editAccount:getText()
end

-- 点击账号输入框结束
function WndLoginSelect:onEditAccountEnd()
    local editAccount = GetElement(self.m_root,"editAccount"..self.sdkIndex.."_WndLoginSelect",WZUIEditBox)
    local newName = editAccount:getText()
    WZLog("-------------account change info---------------",self.oldAccount,newName)
    if newName ~= self.oldAccount then
        local editPassword = GetElement(self.m_root,"editPassword"..self.sdkIndex.."_WndLoginSelect",WZUIEditBox)
        editPassword:setText("")
        self.oldAccount = newName
    end
end

-- 账号，邮箱，密码的检查
-- 账号检测
function WndLoginSelect:_checkAccount(txtAccount,notLimitLen)
    if type(txtAccount) ~= "string" or "" == txtAccount then
        MsgBoxManager:showTipBox(LocalStrings.PLEASE_INPUT_ACCOUNT, nil, nil, nil, nil)
        return false
    end
    if Regexp:isHasBlankChar(txtAccount) then
        MsgBoxManager:showTipBox(LocalStrings.NO_BLACKCHAR, nil, nil, nil, nil)
        return false
    end
    if not notLimitLen then
        if string.len(txtAccount) < 6 or string.len(txtAccount) > 16 then
            MsgBoxManager:showTipBox(LocalStrings.ACCOUNT_LEN_ILLEGAL, nil, nil, nil, nil)
            return false
        end
    end

    return true
end

-- 密码检测
function WndLoginSelect:_checkPassword(txtPassword,notLimitLen)
    if type(txtPassword) ~= "string" or "" == txtPassword then
        MsgBoxManager:showTipBox(LocalStrings.PLEASE_INPUT_PSW, nil, nil, nil, nil)
        return false
    end
    if Regexp:isHasBlankChar(txtPassword) then
        MsgBoxManager:showTipBox(LocalStrings.NO_BLACKCHAR, nil, nil, nil, nil)
        return false
    end
    if Regexp:isHasControlChar(txtPassword) then
        MsgBoxManager:showTipBox(LocalStrings.NO_CONTROLCHAR, nil, nil, nil, nil)
        return false
    end
    if not notLimitLen then
        if string.len(txtPassword) < 6 or string.len(txtPassword) > 12 then
            MsgBoxManager:showTipBox(LocalStrings.PSW_LEN_ILLEGAL, nil, nil, nil, nil)
            return false
        end
    end
    return true
end

-- 密码核对函数
function WndLoginSelect:_confirmPassword(password1,password2)
    if type(password1) ~= "string" or type(password2) ~= "string" or password1 ~= password2 then
        MsgBoxManager:showTipBox(LocalStrings.PSWCONFIRM_NOT_THE_SAME, nil, nil, nil, nil)
        return false
    end
    return true
end

-- 邮箱检测
function WndLoginSelect:_checkMail(txtMail)
    if type(txtMail) ~= "string" or "" == txtMail then
        MsgBoxManager:showTipBox(LocalStrings.PLEASE_INPUT_MAIL, nil, nil, nil, nil)
        return false
    end
    if not Regexp:isEmailAddress(txtMail) then
        MsgBoxManager:showTipBox(LocalStrings.PLEASE_INPUT_CORRECT_MAIL, nil, nil, nil, nil)
        return false
    end
    return true
end

-- 初始化账号保存状态（是否保存账号）
function WndLoginSelect:_initAccountSaveState()
    local box = GetElement(self.m_root,"boxSave"..self.sdkIndex.."_WndLoginSelect",WZUICheckBox)
    local data = WZDataFile:getInstance():getUserData()
    if not data then  return end
    local index = data:getStringValue("AccountData", "SaveAccount")
    if not index or index == "" then index = 0 end
    box:setCheckIndex(tonumber(index))
    if index == "1" then
        local account  = data:getStringValue("AccountData", "account")
        local password  = data:getStringValue("AccountData", "password")
        local editName = GetElement(self.m_root,"editAccount"..self.sdkIndex.."_WndLoginSelect",WZUIEditBox)
        local editPassword = GetElement(self.m_root,"editPassword"..self.sdkIndex.."_WndLoginSelect",WZUIEditBox)
        if account and account ~= "" then editName:setText(account) end
        if password and password ~= "" then editPassword:setText(password) end
        WZLog("------------------cur account info---------------------",account,password)
    end
end

------------------------------------------注册相关----------------------------------------------------------------------
-- 保存注册信息
function WndLoginSelect:saveRegistAccountInfo()
    g_tAccountData = {accountName = self.registInfo.account,passWord = self.registInfo.password }
    WZLog("--------------regist account-----------------",g_tAccountData.accountName,g_tAccountData.passWord)
    local data = WZDataFile:getInstance():getUserData()
    if data then
        data:setStringValue("AccountData", "account", g_tAccountData.accountName)
        data:setStringValue("AccountData", "password", g_tAccountData.passWord)
        data:flush()
    end

    -- 回到登陆界面
    self:OnMyRegistBack()

    -- 将当前注册的账号和密码自动补全
    local editAccount = GetElement(self.m_root,"editAccount"..self.sdkIndex.."_WndLoginSelect",WZUIEditBox)
    editAccount:setText(g_tAccountData.accountName)
    local editPass = GetElement(self.m_root,"editPassword"..self.sdkIndex.."_WndLoginSelect",WZUIEditBox)
    editPass:setText(g_tAccountData.passWord)

    -- 清空当前的注册信息
    self:_clearRegistUIEditBox()
end

-- 清空注册界面的注册信息
function WndLoginSelect:_clearRegistUIEditBox()
    local editA = GetElement(self.m_root,"editRegistAccount"..self.sdkIndex.."_WndLoginSelect",WZUIEditBox)
    local editP1 = GetElement(self.m_root,"editRegistPass"..self.sdkIndex.."_WndLoginSelect",WZUIEditBox)
    local editP2 = GetElement(self.m_root,"editRegistPassSure"..self.sdkIndex.."_WndLoginSelect",WZUIEditBox)
    local editM = GetElement(self.m_root,"editRegistMail"..self.sdkIndex.."_WndLoginSelect",WZUIEditBox)
    editA:setText("")
    editP1:setText("")
    editP2:setText("")
    editM:setText("")
end

-- 400账号不存在，500密码错误
function WndLoginSelect:accountOrPasswordError(errorId)
    if errorId == 400 then
        MsgBoxManager:showTipBox(LocalStrings.ACCOUNT_NOT_EXIST, nil, nil, nil, nil)
    elseif errorId == 500 then
        MsgBoxManager:showTipBox(LocalStrings.PASSWORD_ERROR, nil, nil, nil, nil)
    else
        WZLog("----------------invalid id-------------------")
    end
    self:_closeLoadingBox()
end

-- 403 渠道未开放
function WndLoginSelect:channelNotOpen()
    MsgBoxManager:showConfirmBox(LocalStrings.SERVER_MAINTAINING,nil,nil,nil,nil,true)
    self:_closeLoadingBox()
end

-- 注册回调
function WndLoginSelect:registCallBack(data)
    self:_closeLoadingBox()
    WZLog("-----------------data.result------------",data.result)
    if data.result == 200 then
        --第三方SDK注册成功
        --local tData = {}
        --tData.funType = "finshRegister"
        --PassportSdkManager:Others(tData)

        WndLoginSelect:saveRegistAccountInfo()
        MsgBoxManager:showTipBox(LocalStrings.LOGIN_REGIST_SUCCESS, nil, nil, nil, nil)
        PostPlayerEvent:postEvent(PostPlayerEvent.event_regisiterAccountOk)
    elseif data.result == 400 then
        MsgBoxManager:showTipBox(LocalStrings.LOGIN_REGISTED, nil, nil, nil, nil)
        PostPlayerEvent:postEvent(PostPlayerEvent.event_regisiterAccountFail)
    else
        MsgBoxManager:showTipBox(LocalStrings.LOGIN_REGIST_FAIL, nil, nil, nil, nil)
        PostPlayerEvent:postEvent(PostPlayerEvent.event_regisiterAccountFail)
    end
end
------------------------------------------注册相关----------------------------------------------------------------------

-------------------------------------私有方法模块End----------------------------------------
-- 不同容器之间可见状态切换

-- loginFlag 登陆部分的容器
-- passFlag  密码部分容器
function WndLoginSelect:conVisibleModify(loginFlag,forgetFlag)
    local conLogin = GetElement(self.m_root,"conLogin_WndLoginSelect",WZUIContainer)
    conLogin:setVisible(loginFlag)
    local conFind = GetElement(self.m_root,"conForgetPassword_WndLoginSelect",WZUIContainer)
    conFind:setVisible(forgetFlag)
end


-- -------------------------------------------------找回密码------------------------------------------------------------
-- 点击忘记密码
function WndLoginSelect:onForgetPassword()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("---------------------forget password-----------------")
    self:conVisibleModify(false,true)
end

-- 忘记密码返回
function WndLoginSelect:onBackFindMM()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("---------------onBackFindMM----------------------")
    self:conVisibleModify(true,false)
end

-- 忘记密码确定
function WndLoginSelect:onConfirmFindMM()
    WZLog("---------------onConfirmFindMM----------------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local editName = GetElement(self.m_root,"editForgetAccount_WndLoginSelect",WZUIEditBox)
    local editMail = GetElement(self.m_root,"editForgetMail_WndLoginSelect",WZUIEditBox)
    local userName= editName:getText()      -- 账号
    local email = editMail:getText()         -- 邮箱
    if self:_checkAccount(userName) and self:_checkMail(email) then
        self:_createLoadingBox()
        self:findPassword(userName,email)
        WZLog("--------------forget info---------------",userName,email)
    end
end

-- 发送HTTP协议获取账号
function WndLoginSelect:findPassword(userName,email)
    local ipdAddr = ProjConfig:getIpdAddr()
    local data = { username = userName,email = email}
    local vBytes = WGameCmUtil:EnCrypt(json.encode(data), ENCRYPT_KEY)
    local sData = WGameCmUtil:transformBytesToString(vBytes)
    local url = ipdAddr.."/findPassword?data="..sData
    WZLog("url = ",url)
    IPDhttpServer:findPassword(url)
end

-- 找回密码回调
function WndLoginSelect:findPasswordCallBack(data) 
    self:_closeLoadingBox()
    WZLog("-----------------findPasswordCallBackResult------------",data.result)
    if data.result == 200 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_SEND_SUCCUSS, nil, nil, nil, nil)
        self:conVisibleModify(true,false)
    elseif data.result == 300 then
        MsgBoxManager:showTipBox(LocalStrings.ACCOUNT_NOT_MAIL, nil, nil, nil, nil)
    elseif data.result == 400 then
        MsgBoxManager:showTipBox(LocalStrings.ACCOUNT_NOT_EXIST, nil, nil, nil, nil)
    elseif data.result == 500 then
        MsgBoxManager:showTipBox(LocalStrings.PASSWORD_MAIL_ERROR, nil, nil, nil, nil)
    end
end


-- ----------------------------------------修改密码------------------------------------------------------------------
function WndLoginSelect:onModifyPassword()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("---------------------modify password-----------------")
    self:conVisibleModify(false,false)
end

-- 修改密码返回
function WndLoginSelect:onBackModifyMM()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("---------------onBackModifyMM----------------------")
    self:conVisibleModify(true,false)
end

-- 修改密码确认
function WndLoginSelect:onConfirmModifyMM()
    WZLog("---------------onConfirmModifyMM----------------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local editName = GetElement(self.m_root,"editModifyAccount_WndLoginSelect",WZUIEditBox)
    local editOldP = GetElement(self.m_root,"editModifyPass_WndLoginSelect",WZUIEditBox)
    local editNewP = GetElement(self.m_root,"editModifyNewPass_WndLoginSelect",WZUIEditBox)
    local editConfirmP = GetElement(self.m_root,"editModifyNewPassSure_WndLoginSelect",WZUIEditBox)
    local userName= editName:getText()      -- 账号
    local oldP = editOldP:getText()         -- 旧密码
    local newP = editNewP:getText()         -- 新密码
    local confirmP = editConfirmP:getText() -- 确认密码
    if self:_checkAccount(userName) and self:_checkPassword(oldP) and self:_checkPassword(newP) and self:_checkPassword(confirmP) and self:_confirmPassword(newP,confirmP) then
        self:_createLoadingBox()
        self:modifyPassword(userName,oldP,newP)
        WZLog("--------------modify info---------------",userName,oldP,newP,confirmP)
    end
end

-- 通过HTTP协议修改密码
function WndLoginSelect:modifyPassword(userName,password,newPassword)
    local ipdAddr = ProjConfig:getIpdAddr()
    local sign = WZDeviceInfo:md5Generate(userName..password..newPassword.."gz!y^d&zh*wyd")
    local data = {sign = sign, username = userName,password = password,newpassword = newPassword}
    local vBytes = WGameCmUtil:EnCrypt(json.encode(data), ENCRYPT_KEY)
    local sData = WGameCmUtil:transformBytesToString(vBytes)
    local url = ipdAddr.."/modifyPassword?data="..sData
    WZLog("url = ",url)
    IPDhttpServer:modifyPassword(url)
end

-- 修改密码回调
function WndLoginSelect:modifyPasswordCallBack(data)
    self:_closeLoadingBox()
    WZLog("-----------------modifyPasswordCallBackResult------------",data.result)
    if data.result == 200 then
        MsgBoxManager:showTipBox(LocalStrings.CHANGE_PSW_SUCCESS, nil, nil, nil, nil)
        self:conVisibleModify(true,false)
    elseif data.result == 400 then
        MsgBoxManager:showTipBox(LocalStrings.ACCOUNT_NOT_EXIST, nil, nil, nil, nil)
    else
        MsgBoxManager:showTipBox(LocalStrings.LOGIN_ERROR, nil, nil, nil, nil)
    end
end


-- ------------------------------------------------绑定账号-------------------------------------------------------------
-- 点击绑定
function WndLoginSelect:onBindAccount()
    WZLog("------------------bind------------------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndBindAccount:showWndUI()
end

function WndLoginSelect:bindAccountCallBack(name)
    self:returnLoginUI()
    local editAccount = GetElement(self.m_root,"editAccount"..self.sdkIndex.."_WndLoginSelect",WZUIEditBox)
    editAccount:setText(name)
    local editPassword = GetElement(self.m_root,"editPassword"..self.sdkIndex.."_WndLoginSelect",WZUIEditBox)
    editPassword:setText("")
end


------------------------------------------------------------------------------------------------------------------------
-- 最新修改，每种editbox 添加默认提示
function WndLoginSelect:_initPlaceHolder()
    -- 登陆部分
    local editAccount = GetElement(self.m_root,"editAccount"..self.sdkIndex.."_WndLoginSelect",WZUIEditBox)
    editAccount:setPlaceHolder(LocalStrings.PLEASE_INPUT_ACCOUNT)
    local editPassword = GetElement(self.m_root,"editPassword"..self.sdkIndex.."_WndLoginSelect",WZUIEditBox)
    editPassword:setPlaceHolder(LocalStrings.PLEASE_INPUT_PSW)

    -- 注册部分
    local editA = GetElement(self.m_root,"editRegistAccount"..self.sdkIndex.."_WndLoginSelect",WZUIEditBox)
    local editP1 = GetElement(self.m_root,"editRegistPass"..self.sdkIndex.."_WndLoginSelect",WZUIEditBox)
    local editP2 = GetElement(self.m_root,"editRegistPassSure"..self.sdkIndex.."_WndLoginSelect",WZUIEditBox)
    editA:setPlaceHolder(LocalStrings.LOGIN_TIPS_ACCOUNT2)
    editP1:setPlaceHolder(LocalStrings.LOGIN_TIPS_PASSWORD)
    editP2:setPlaceHolder(LocalStrings.LOGIN_TIPS_PASSWORD1)

    -- 忘记密码
    local editName = GetElement(self.m_root,"editForgetAccount_WndLoginSelect",WZUIEditBox)
    local editMail = GetElement(self.m_root,"editForgetMail_WndLoginSelect",WZUIEditBox)
    editName:setPlaceHolder(LocalStrings.PLEASE_INPUT_ACCOUNT)
    editMail:setPlaceHolder(LocalStrings.PLEASE_INPUT_MAIL)
end


------------------------------------------排队----------------------------------------------------
-- 询问是否需要排队
function WndLoginSelect:isNeedQueue()
    local ipdAddr = ProjConfig:getIpdAddr()
    local serverid = IPDhttpServer:getCurServerId()
    local token = IPDhttpServer:getIpdToken()
    local url = "http://"..ipdAddr.."/queuing?serverid="..serverid.."&token="..token
    if ProjConfig.USE_HTTPS and ProjConfig.USE_HTTPS == 1 then
        url = "https://"..ipdAddr.."/queuing?serverid="..serverid.."&token="..token
    end
    WZLog("WndLoginSelect:isNeedQueueUrl = ",url)
    self:_createLoadingBox()
    PostPlayerEvent:postEvent(PostPlayerEvent.event_checkNeedQueue)
    IPDhttpServer:getNeedQueue(url)
end

-- 定时器询问是否需要排队
function WndLoginSelect:scheduleAskLoginQueue(element,dt)
    self.askTime = self.askTime - 1
    if self.askTime == 0 then
        self.m_root:disableSchedule()
        self:isNeedQueue()
        self.askTime = 10
    end
end

-- 排队回调
function WndLoginSelect:needQueueCallBack(data)
    self:_closeLoadingBox()
    WZLog("-----------------needQueueCallBack------------",data)
    if tonumber(data) == 0 then
        self:NoNeedQueueAndEnterGame()
    else
        self.askTime = 10
        self.m_root:enableSchedule("scheduleAskLoginQueue",1)
        WndLoginQueue:showWndUI(data) 
    end
end

-- 取消排队
function WndLoginSelect:cancelQueue()
    local ipdAddr = ProjConfig:getIpdAddr()
    local serverid = IPDhttpServer:getCurServerId()
    local token = IPDhttpServer:getIpdToken()
    local url = "http://"..ipdAddr.."/queuing?serverid="..serverid.."&token="..token.."&exit=true"
    if ProjConfig.USE_HTTPS and ProjConfig.USE_HTTPS == 1 then
        url = "https://"..ipdAddr.."/queuing?serverid="..serverid.."&token="..token.."&exit=true"
    end
    WZLog("WndLoginSelect:cancelQueue = ",url)
    self:_createLoadingBox()
    IPDhttpServer:cancelQueue(url)
    self.m_root:disableSchedule()
end

-- 取消排队回调
function WndLoginSelect:cancelQueueCallBack(data)
    self:_closeLoadingBox()
    self.m_root:disableSchedule()
    PostPlayerEvent:postEvent(PostPlayerEvent.event_cancelQueue)
    WZLog("-----------------cancelQueueCallBack------------",data)
    if tonumber(data) == 0 then
        MsgBoxManager:showTipBox(LocalStrings.LOGIN_QUEUE4)
    else
        MsgBoxManager:showTipBox(LocalStrings.LOGIN_QUEUE5)
    end
end

function WndLoginSelect:_addWarnDesc()
    local str = {LocalStrings.WARN_DESC1,LocalStrings.WARN_DESC2,LocalStrings.WARN_DESC3}
    for i = 1, 3 do
        local ftb = GetElement(self.m_root,"ftbWarn"..i.."_WndLoginSelect",WZUIFreeTextBox)
        ftb:setShowText(str[i])
        local packageName = WGameCmUtil:GetBundleIdentifier()
        if  packageName == "com.xmqqls.ddlm" or packageName == "com.caohua.ddqs" or packageName == "com.lyddd.ddd2001.qianliu" 
            or packageName == "com.ddwg.ddd2003.xiaoyuzhou" then
            ftb:setVisible(false)
        end
    end
end

----------------------------不同非SDK版本处理----------------------------------
function WndLoginSelect:setConLoginState(state)
    local conMyLogin = GetElement(self.m_root,"conMyLogin_WndLoginSelect",WZUIContainer)
    conMyLogin:setVisible(state)

    local conIndex = GetElement(self.m_root,"conMyLogin"..self.sdkIndex.."_WndLoginSelect",WZUIContainer)
    conIndex:setVisible(state)

    local _,facebookFlag,googleFlag = getLoginType()
    if self.sdkIndex == 1 then
		local btnF = GetElement(self.m_root,"btnFacebook_WndLoginSelect",WZUIButton)
		local btnG = GetElement(self.m_root,"btnGoogle_WndLoginSelect",WZUIButton)
		btnG:setVisible(googleFlag == 1)
		btnF:setVisible(facebookFlag == 1)
		if facebookFlag == 1 and googleFlag ~= 1 then
			btnF:setRelativePosition(GlobalMethod:ccp(0.5,0.2))
		elseif facebookFlag ~= 1 and googleFlag == 1 then
			btnG:setRelativePosition(GlobalMethod:ccp(0.5,0.2))
		else
		end
    end
    --北美渠道包蛋疼的修改
         --越南语包的修改
    -- local packName = WGameCmUtil:GetBundleIdentifier()
    -- if packName == "com.ios.rwt.bombcrash" then
    --     GetElement(self.m_root,"conMyLogin11_WndLoginSelect",WZUIContainer):setVisible(false)
    --     GetElement(self.m_root,"conMyLogin12_WndLoginSelect",WZUIContainer):setVisible(true)
    -- end
end

-- FACKBOOKLOGIN
function WndLoginSelect:onFacebook()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("--------------fb--------------")
    PassportSdkManager:doLogin(self.sdkLoginCallback, self,"fb")
end

-- GOOGLE+LOGIN
function WndLoginSelect:onGoogle()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("-------------google--------------")
    PassportSdkManager:doLogin(self.sdkLoginCallback, self,"google")
end

-- 忘记密码GOOGLE
function WndLoginSelect:onForgetPassword1()
end

-- 隐私条例
function WndLoginSelect:onSingleInfo()
    WZLog("--WndLoginSelect:onSingleInfo--1")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSingleInfo:showInterface(LocalStrings.SINGLE_INFO_SHOW)
    WZLog("--WndLoginSelect:onSingleInfo--2")
end

----------------------------------语言适配Begin------------------------------------------------------
function WndLoginSelect:_adaptLanguage_en()
    WZLog("----------------en---------------------WndLoginSelect:_adaptLanguage_en")
    local txtSaveAcccount = GetElement(self.m_root,"txtSaveAccount0_WndLoginSelect",WZUILabelTTF)
    txtSaveAcccount:setFontSize(16)
    GetElement(self.m_root,"txtAccountInfo_WndLoginSelect",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.12,0.5))
end

function WndLoginSelect:_adaptLanguage_pt(  )
    local txtSaveAcccount = GetElement(self.m_root,"txtSaveAccount0_WndLoginSelect",WZUILabelTTF)
    txtSaveAcccount:setFontSize(14)
    local txtForget = GetElement(self.m_root,"txtForget2_WndLoginSelect",WZUILabelTTF)
    txtForget:setFontSize(20)
    txtForget:setDimensions(GlobalMethod:CCSize(100,0))
    local txtAccount = GetElement(self.m_root,"txtAccountInfo_WndLoginSelect",WZUILabelTTF)
    txtAccount:setFontSize(20)
    txtAccount:setDimensions(GlobalMethod:CCSize(100,0))
end

function WndLoginSelect:_adaptLanguage_vn() 
    local txtSaveAcccount = GetElement(self.m_root,"txtForget2_WndLoginSelect",WZUILabelTTF)
    txtSaveAcccount:setRelativePosition(GlobalMethod:ccp(0.061928,0.5))


    local boxSave = GetElement(self.m_root,"boxSave"..self.sdkIndex.."_WndLoginSelect",WZUICheckBox)
    boxSave:setRelativePosition(GlobalMethod:ccp(0.177778,0.5))
end

function WndLoginSelect:_adaptLanguage_th(  )
    GetElement(self.m_root,"txt2_WndLoginSelect",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.2,0.5))
end

--@brief 土耳其适配   
function WndLoginSelect:_adaptLanguage_tr(  )
    local txtForget = GetElement(self.m_root,"txtForget2_WndLoginSelect",WZUILabelTTF)
    txtForget:setRelativePosition(GlobalMethod:ccp(0.09,0.5))

    local txtAccount = GetElement(self.m_root,"txtAccountInfo_WndLoginSelect",WZUILabelTTF)
    txtAccount:setRelativePosition(GlobalMethod:ccp(0.09,0.5))

    GetElement(self.m_root,"txtSaveAccount0_WndLoginSelect",WZUILabelTTF):setFontSize(18)
end

function WndLoginSelect:_adaptLanguage_es(  )
    GetElement(self.m_root,"txtGuest_WndLoginSelect",WZUILabelTTF):setScale(0.85)
    GetElement(self.m_root,"txtRegister_WndLoginSelect",WZUILabelTTF):setScale(0.85)
    local txtLogin = GetElement(self.m_root,"txtLogin_WndLoginSelect",WZUILabelTTF)
    txtLogin:setScale(0.85)
    local txtAccountInfo = GetElement(self.m_root,"txtAccountInfo_WndLoginSelect",WZUILabelTTF)
    txtAccountInfo:setRelativePosition(GlobalMethod:ccp(0.03,0.5))
    txtAccountInfo:setFontSize(20)
    local txtForget2 = GetElement(self.m_root,"txtForget2_WndLoginSelect",WZUILabelTTF)
    txtForget2:setRelativePosition(GlobalMethod:ccp(0.06,0.5))
    txtForget2:setFontSize(20)
end
-------------------------------语言适配End----------------------------------------------------------
