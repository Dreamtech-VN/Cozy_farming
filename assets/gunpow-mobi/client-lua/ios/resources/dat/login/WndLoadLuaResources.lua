--WndLoadLuaResources.lua
--@brief	WndLoadLuaResources的UI模块
--@date		2015-8-29
--@modify   binshao
--@note		lua资源载入

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndLoadLuaResources:onEnter(element)
	self.m_root = element
    self:_moreLanguage()
    if WZDeviceHelper:sharedDeviceHelper().stopDeviceMotionUpdate then
        WZDeviceHelper:sharedDeviceHelper():stopDeviceMotionUpdate()
    end
    SceneLoginMgr.m_bIsCloseGravity = true
    self:_initUI()
    self.osTime = os.time()
    WZLog("-----------------enter WndLoadLuaResources---------------")
end

--@brief	创建窗口动画
function WndLoadLuaResources:onEnterTransitionDidFinish(element)
--    PostPlayerEvent:postEvent(PostPlayerEvent.event_loadlua)
--    GlobalGame.g_checkLoginActivities = true
--    CCDirector:sharedDirector():getScheduler():unscheduleAllScriptEntry()
--    self.m_loader = WZAsyncLoader:create(15,self.onCallback,self)
--    self.m_loader:start()

    self.m_root:enableSchedule("starLoadRes",1)
end

function WndLoadLuaResources:starLoadRes()
    self.m_root:disableSchedule()
    
    PostPlayerEvent:postEvent(PostPlayerEvent.event_starLoadRes)
    GlobalGame.g_checkLoginActivities = true
    CCDirector:sharedDirector():getScheduler():unscheduleAllScriptEntry()
    self.m_loader = WZAsyncLoader:create(15,self.onCallback,self)
    self.m_loader:start()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndLoadLuaResources:onExit(element)
	self:_unInit()
	WZLog("WndLoadLuaResources:onExit", ProjConfig.DressAniDownloadConfig)
	WZUpdateManager:getInstance():update("",WndDownLoad)
	local path = CCFileUtils:sharedFileUtils():getTmpWritablePath().."DressAniDownloadConfig.xml"
	local platForm =  WZUISystem:getInstance():getPlatformInfo()
	if platForm == 3 then
		path = "DressAniDownloadConfig.xml"
	end
	local multiThread = WZUISystem:getInstance():getMultiThreadSystem()
	local downloadTask = WZHTTPFileLuaTask:create(200, ProjConfig.DressAniDownloadConfig, path, self.downloadAniConfigCall, self)
	multiThread:addDownloadTaskInFront(downloadTask)
end

function WndLoadLuaResources:downloadAniConfigCall(taskId, path, totalSize, nowSize, finish, failed)
	WZLog("WndLoadLuaResources:downloadAniConfigCall", taskId, path, totalSize, nowSize, finish, failed)

end

-- 更新进度条
function WndLoadLuaResources:updateProgressBar(nPercent)
    local progBar = GetElement(self.m_root, "progBar_WndLoadLuaResources", WZUIProgress)
    progBar:setPercentage(nPercent*0.95)

    local txtPro = GetElement(self.m_root,"txtProTip_WndLoadLuaResources",WZUILabelTTF)
    --txtPro:setText(LocalStrings.RESOURCES_LOADING.." "..math.floor(nPercent*0.95).."%")
    txtPro:setText("("..math.floor(nPercent*0.95).."%)")

    local conDutiao = GetElement(self.m_root, "conDutiao_WndLoadLuaResources", WZUIContainer)
    conDutiao:setRelativePosition(GlobalMethod:ccp(nPercent*0.95/100, 0.65))

    local conScissor = GetElement(self.m_root, "conScissor_WndLoadLuaResources", WZUIScissorContainer)
    conScissor:setRelativeSize(GlobalMethod:CCSize(nPercent*0.95/100,1))
end

-- 进度条跑完
function WndLoadLuaResources:scheduleProAni(element,time)
    self:_updateUI()
    if self.bConnectServer then
        -- 更新进度条,100%则进入游戏
        local progBar = GetElement(self.m_root, "progBar_WndLoadLuaResources", WZUIProgress)
        local curPer = progBar:getPercentage()
        local conDutiao = GetElement(self.m_root, "conDutiao_WndLoadLuaResources", WZUIContainer)
        local txtPro = GetElement(self.m_root,"txtProTip_WndLoadLuaResources",WZUILabelTTF)
        txtPro:setText("("..curPer.."%)")
        WZLog("-----------------cur per---------------",curPer)
        if curPer< 100 then
            curPer = curPer + 1
            progBar:setPercentage(curPer)
            conDutiao:setRelativePosition(GlobalMethod:ccp(curPer/100, 0.65))
            local conScissor = GetElement(self.m_root, "conScissor_WndLoadLuaResources", WZUIScissorContainer)
            conScissor:setRelativeSize(GlobalMethod:CCSize(curPer/100,1))
        else
            WZLog("-----------------enter game---------------",curPer)
            self.m_root:disableSchedule()
            self:readyEnterGame()
        end
    end
end

-- ipd回调成功
function WndLoadLuaResources:connectServerSuccess()
    self.bConnectServer = true
    WZLog("-----------------connect success ---------------",self.bConnectServer)
end

-- 加载资源回调,进度条加载到95%，最后5%表示连接服务器
function WndLoadLuaResources:onCallback(nPer,actionTime)
    if not self.bLoadEnd then
        self:updateProgressBar(nPer)
        if nPer == 100 then
            PostPlayerEvent:postEvent(PostPlayerEvent.event_loadResSuccess)
            WZLog("loadLocalResSuccess---------")
            self.bLoadEnd = true
            g_bisloadres = true
            self.m_loader:endToLua()

            -- 本地资源加载完成后，连接服务器
            if not self.bConnectServer then
                WZLog("connect server----------",g_tAccountData.accountName,g_tAccountData.passWord)
				self:_initGame()
                NetManager.g_bIsRepeatLogin = false
                IPDConnector.g_nNetConnectFlag = NET_FLAG_1
                IPDConnector:connectIPDServer(g_tAccountData.accountName,g_tAccountData.passWord)
                --local txtPro = GetElement(self.m_root,"txtProTip_WndLoadLuaResources",WZUILabelTTF)
                --txtPro:setText(LocalStrings.CONNECTED_SERVER)
                self.m_root:enableSchedule("scheduleProAni",0.1)
                self.pointTime = os.time()
            end
        end
        self:_updateUI()
    end
end

-- 更新小提示
function WndLoadLuaResources:updateTip()
    local txtTipCnt = GetElement(self.m_root, "txtTipCnt_WndLoadLuaResources", WZUILabelTTF)
    if not LocalStrings.LOADING_TIPS or #LocalStrings.LOADING_TIPS == 0 then
        txtTipCnt:setText(LocalStrings.LOADING_TIP)
        return
    end

    local nIndex = math.random(1, #LocalStrings.LOADING_TIPS)
    if txtTipCnt:getText() == LocalStrings.LOADING_TIPS[nIndex] then
        nIndex = nIndex+1
        if nIndex > #LocalStrings.LOADING_TIPS then nIndex = 1 end
    end
    txtTipCnt:setText(LocalStrings.TIPS..":"..LocalStrings.LOADING_TIPS[nIndex])
end

-------------------------------------公有方法模块End--------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndLoadLuaResources:_initUI()
    self:_initText()
end

-- 初始化txt
function WndLoadLuaResources:_initText()
    -- 进度条提示
    WZLog("---------------------_initText-----------------")
    local txtPro = GetElement(self.m_root,"txtProTip_WndLoadLuaResources",WZUILabelTTF)
    WZLog("---------------------txtProTip_WndLoadLuaResources-----------------",txtPro)
    --txtPro:setText(LocalStrings.RESOURCES_LOADING.."0")
    txtPro:setText("(0%)")

    -- 小提示内容
    self:updateTip()
end

-- 更新提示和显示图片
function WndLoadLuaResources:_updateUI()
    if (os.time() - self.osTime) >= 2.5 then
        self.osTime = os.time()
        self:updateTip()
    end
end

-- 更新加载的点
function WndLoadLuaResources:_getLoadingPoint()
    local str = "."
    if (os.time() - self.osTime) <= 0 then
        str = "."
    elseif (os.time() - self.osTime) <= 1 then
        str = ". ."
    elseif (os.time() - self.osTime) <= 2 then
        str = ". . ."
    else
        self.osTime = os.time()
    end
    WZLog("--------------201---------------",str,os.time() - self.osTime)
    return str
end


-- 初始化游戏环境
function WndLoadLuaResources:_initGame()
    GlobalGame:reset()
    GlobalGame:resetAll()
    CCFileUtils:sharedFileUtils():clearCacheData()
    GlobalGame:checkCacheImage()
    MsgBoxManager:init()
	WndPhantom:init()
    SoundManager:init()
    CacheCenter:reset()
    CacheCenter:resetObservers()
    --AnimationManager:init()
    --PassportSdkManager:initSdk()
    --SNSSdkManager:init()
    --VipManager:init()
    g_canReset = true
end

-- 进入游戏
function WndLoadLuaResources:readyEnterGame()
    WZLog("enter game---------------***")
    --self:_initGame()
    NetManager:init()
    SceneLogin:StartLoginByToken()
end

-------------------------------------私有方法模块End----------------------------------------
function WndLoadLuaResources:_moreLanguage( )
    local txt = GetElement(self.m_root,"txt_WndLoadLuaResources",WZUILabelTTF)
    if txt and LocalStrings.NOT_CONSUME_TRAFFIC then
        txt:setText(LocalStrings.NOT_CONSUME_TRAFFIC)
    end
end