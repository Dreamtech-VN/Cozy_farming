--SceneCity.lua
--@brief	SceneCity的UI模块
--@date		2015/2/9
--@author	莫剑峰
--@note		主城界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function SceneCity:onEnter(element)
    --ProtocolProcessorTeach:send_TASK_TiroStep(19, 0)
    -- if GlobalGame.test == nil then
    --     GlobalGame.m_bPlayMovie = true
    --     GlobalGame.test = 2
    -- end
    --GlobalGame.m_nTrailerId = {buttonId=120, icon="ui/city/newUI/main_icon_daoju.png"}
    --WZLog = doNone
    --g_testFigureScene = true

    self.m_root = element
    local platForm =  WZUISystem:getInstance():getPlatformInfo()
    if ProjConfig.PLAY_LOGO == 1 and SceneCity:getMovieRecord() == false and (platForm == 1 or platForm == 2 and WZDeviceInfo:getTotalMemory()/(1024*1024) > 1024) then
        GlobalGame.m_bPlayMovie = true
    end

    WZLog("SceneCity:onEnter", tostring(GlobalGame.m_bPlayMovie))

    if GlobalGame.m_bPlayMovie then
        GlobalGame.m_bPlayMovie = nil
        self:playMovie()
        self.m_bIsPlayMovie = true
        local action1 = CCDelayTime:create(1)
        local action2 = CCCallFuncN:create(function() 
            GetElement(self.m_root, "imgBlack_SceneCity", WZUIImage):setVisible(false)
        end)

        local array = CCArray:create()
        array:addObject(action1)
        array:addObject(action2)
        self.m_root:runAction(CCSequence:create(array))
    else
        GetElement(self.m_root, "imgBlack_SceneCity", WZUIImage):setVisible(false)
    end

    if GlobalGame.m_bIsLevelUp == true then
        self.m_bIsLevelUp = true
        GlobalGame.m_bIsLevelUp = nil
    end
    self.m_scheduleLoopId = -1
    
    WindowManagerAni.createAppearActionTimes = 0
    WindowManagerAni.m_nAppearTimes = 0
    --local reflectVector = BattleCommon:reflectVector(GlobalMethod:ccp(0,0),GlobalMethod:ccp(10,10),GlobalMethod:ccp(0,-5))
    --WZLog("SceneCity:onEnter_one")

	
    SceneCity.m_currentFullScreenCount = 0
    WndCurrentChat:addWndCurrentChatToCurScene(self.m_root:getLuaObjectName(),self.m_root)
    g_enterCityIsland = true
    local tBtnsInfo = GlobalGame:getBtnInfoByType(ISLAND_BTNTYPE_BUILDING)
    self:setBtnsInfo(tBtnsInfo)
    CCDirector:sharedDirector():setAnimationInterval(1.0/60)
    CacheCenter:registerUpatePlayerInfoObserver(self)
    ChangeChatChannel(Chat_Channel_Island)

    CacheCenter:initRedInfo()

    if CacheCenter:hasPlayerInfo()then
        self:getPlayerInfo()
    end
    --多语言版本界面适配
    AdaptLanguage(self)

    --self.m_root:enableSchedule("loop",0)

    --设置网络链接相关信息
    IPDConnector.g_nNetConnectFlag = NET_FLAG_2    

    if Teach.OPEN_MODULE_MARK ~= nil then
        Teach.OPEN_MODULE_MARK = nil
    end

    
    --WZLog("SceneCity:onEnter two")

    local wndBottomBar,wndBottomBarObj = WndCityBottomBar:createElement()
    self.m_tWndBottomBarObj = wndBottomBarObj
    self.m_tWndBottomBar = wndBottomBar
    GlobalGame:getBtnRedPointEvent():regListenerBottomBar("SceneCity",wndBottomBarObj,"right")
    if WndCityBottomBar.setScene then
        wndBottomBarObj:setScene(self)
    end
    self.m_root:addChild(wndBottomBar)
    wndBottomBarObj:setNeedMoveVerticalBar(true)
    wndBottomBarObj:setNeedChat(true)
    --wndBottomBarObj:onClickSwitch()
    

    CacheCenter:updateRedPoint("left",wndBottomBar,nil,1)
    local wndOwnCity = WndOwnCity:createElement()
    if WndOwnCity.setNeedMoveVerticalBar then
        WndOwnCity:setNeedMoveVerticalBar(true)
    end
	if WndOwnCity.setScene then
        WndOwnCity:setScene(self)
    end
    self.m_root:addChild(wndOwnCity)

    CacheCenter:updateRedPoint("left",WndOwnCity.m_root,nil,1)
    CacheCenter:updateRedPoint("right",wndBottomBar,nil,2)
    
    --CreateStoryTalkGroup(101)

    self.m_bAutoInit = false

    self:_postBackToCityEvent()
    self:register()
end

function SceneCity:register()
    GlobalGame:getGameEventDispathcer():Add(bottomMeneEvent.WndBottomMeneEvent_HonorPointCountDown,self._onWndCopyEntryInfoData,self)
end
function SceneCity:unregister()
    GlobalGame:getGameEventDispathcer():Remove(bottomMeneEvent.WndBottomMeneEvent_HonorPointCountDown,self._onWndCopyEntryInfoData,self)
end

function SceneCity:_onWndCopyEntryInfoData(honourPoint, restoreTime, serverTime)
    local _, score = GlobalMethod:HonorPointStatus(5)
    if tonumber(honourPoint) >= score then
        if CheckButtonOpen(ISLAND_BUILDING_BOSSMAP) then
            TeachGroup1:endTeachStep({15,2})
            SceneCopy:showScene(2, nil, nil,true)
            WindowManager:removeWindow(self.m_root, self, true)
        end
    else
        local status, score = GlobalMethod:HonorPointStatus(5)
        if status == false then
            WndHonorPoint:showInterface(score, honourPoint, restoreTime, serverTime)
        end
    end
end

--@brief	删除多余的资源
function SceneCity:onEnterTransitionDidFinish(element)
    --WZLog("SceneCity:onEnterTransitionDidFinish", self.m_scheduleId, self.m_scheduleLoopId)
    if PassportSdkManager:getLogoutState() then
        PassportSdkManager:setLogoutState(false)
        WndLoginSelect:loginOutGame()
        return
    end

    local className = "AMapSceneController"
    if WZUISystem:getInstance():getPlatformInfo() == 2 then
        className = "com/baiduMap/MapSceneController"
    end
    local adapter = WydPlAdapterManager:sharedWydPlAdapterManager():createAdapter(className)
    if adapter then
        adapter:callMethodByName("enterGame", nil, "")
        WydPlAdapterManager:sharedWydPlAdapterManager():destroyAdapter(adapter:getId())
    end

    CCTextureCache:sharedTextureCache():removeUnusedTextures()

    if self.m_scheduleId == -1 then
        self.m_scheduleId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(self.updateSchedule, 0, false)
    end

    if self.m_scheduleLoopId == -1 then
        self.m_scheduleLoopId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(self.loop, 0, false)
    end

    self:init()
    --local state = 0
    self:getSceneMoveEndPointX()
    if GlobalGame.g_nMoveEndPointXNowMoveElement then
        local scene = WZUIScene:luaTo(self.m_root:getChildElement("conBgLayer_SceneCity"))
        local element = scene:getMoveElement()
        WZLog("SceneCity:onEnterTransitionDidFinish two",GlobalGame.g_nMoveEndPointXNowMoveElement)
        element:setPositionX(GlobalGame.g_nMoveEndPointXNowMoveElement)
    end

    if self.m_bIsPlayMovie == true then
        --GetElement(self.m_root, "imgBlack_SceneCity", WZUIImage):setVisible(false)
        self.m_bIsPlayMovie = nil
    else
        self:checkPopupWindow()
    end
    --鲜花榜协议
    Protocol:reg( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GiveFlowerOk, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GiveFlowerOk", "t")

    --个人空间开启时获取自己位置
    -- if CheckButtonShow(60) and CheckButtonOpen(60,false) then
    --  local result = WZLocation:getInstance():getCurrentCoordinate()
    --  WZLog("result:",result)
    --  if result ~=  nil then
    --      local resultTable = json.decode(result)
    --      if resultTable.result == "true" then
    --          ProtocolProcessorWndSpace:send_SPACE_UpdateGPSInfo(CacheCenter:getPlayerInfo().id , resultTable.Longitude*100000, resultTable.Latitude*100000 )
    --      end
    --  end
    -- end
    

    SceneCity.m_bIsOpenWorldBoss = nil
    if not isEnterTeach then
        if self.m_bFromChurch then
            WndMarryManager:initManager()
            WndMarryManager:createLoading()
            self.m_bFromChurch = false
        end
    end

    --获取玩家的辅助技能
    ProtocolProcessorWndSkillProp:send_PLAYER2_GetPlayerAssist()
    
    CacheCenter:getSingleCopyData()

    --安智悬浮窗的显示
    PassportSdkManager:doAnzhiOthers("showFloatButton")
    ProtocolProcessorDigGem:regAll()
    ProtocolProcessorDigGem:send_MINING_GetMining()
    if not whetherCloseRecharge() then
        ProtocolProcessorCommonPush:send_COMMONPUSH_GetStoredDirectionalPush(ProjConfig.CHANNEL_ID)
    end

    --一些渠道隐藏掉娄艺潇活动入口
    self:closeLouyixiaoActivity()

    if CacheCenter:getPlayerInfo() and CacheCenter:getPlayerInfo().level < 21 then 
        getNewOnlineRewardState()
    end

    --进入主城进行安卓权限申请
    --self:checkPermission()

    local conAll = GetElement(self.m_root, "conAll_SceneCity", WZUIContainer)
    if conAll then 
        conAll:enableSchedule("dowithSendProtocol", 1)
    end
    --显示主城小屋建筑
    self:updateKidHomeState()
    --检测资源下载

    -- local path = CCFileUtils:sharedFileUtils():getTmpWritablePath().."DressAniDownloadConfig.xml"
    -- local platForm =  WZUISystem:getInstance():getPlatformInfo()
    -- if platForm == 3 then
    --     path = "DressAniDownloadConfig.xml"
    -- end
    -- if platForm == 3 then
    --     local multiThread = WZUISystem:getInstance():getMultiThreadSystem()
    --     local downloadTask = WZHTTPFileLuaTask:create(200, ProjConfig.DressAniDownloadConfig, path, self.downloadAniConfigCall, self)
    --     multiThread:addDownloadTaskInFront(downloadTask)
    --     path = "DressAniDownloadConfig_All.xml"
    --     downloadTask = WZHTTPFileLuaTask:create(201, ProjConfig.DressAniDownloadConfig_All, path, self.downloadAniConfigCall_All, self)
    --     multiThread:addDownloadTaskInFront(downloadTask)
    -- end
    
    --检测资源下载
    local platForm =  WZUISystem:getInstance():getPlatformInfo()
    if isChannelPC() then           
        if GlobalGame.g_bIsDownloadingResCheckAll == false then 
            -- local multiThread = WZUISystem:getInstance():getMultiThreadSystem()
            -- multiThread:addDownloadTaskInFront(DownloadManager.downloadResCheck)
            WZLog("SceneCity:onEnterTransitionDidFinish", "DownloadManager:downloadResCheckAll")
            if ProjConfig.DressAniDownloadConfig_All and ProjConfig.DressAniDownloadConfig_All ~= "" then
                DownloadManager:downloadResCheckAll()
                GlobalGame.g_bIsDownloadingResCheckAll = true
            end
        end
        --定时续期openkey
        if isChannelQQHall() then
            WQQGameHelper:updateOpenKey()
        end
    else
        -- if platForm ~= 3 then            
        --     if GlobalGame.g_bIsDownloadingResCheckAll == false then 
        --         WZLog("SceneCity:onEnterTransitionDidFinish", "DownloadManager:downloadResCheckAll")
        --         if ProjConfig.DressAniDownloadConfig_All and ProjConfig.DressAniDownloadConfig_All ~= "" then
        --             DownloadManager:downloadResCheckAll()
        --             GlobalGame.g_bIsDownloadingResCheckAll = true
        --         end
        --     end
        -- end
    end
    if self.m_tWndBottomBarObj then 
        self.m_tWndBottomBarObj:setDownloadState()
    end    
    g_bisloadingres = false--资源是否正在加载，用以控制是否可以打开tips弹框
end

function SceneCity:downloadAniConfigCall(taskId, path, totalSize, nowSize, finish, failed)
    WZLog("SceneCity:downloadAniConfigCall", taskId, path, totalSize, nowSize, finish, failed)
end

function SceneCity:downloadAniConfigCall_All(taskId, path, totalSize, nowSize, finish, failed)
    WZLog("SceneCity:downloadAniConfigCall_All", taskId, path, totalSize, nowSize, finish, failed)
    --检测资源下载
    local platForm =  WZUISystem:getInstance():getPlatformInfo()
    if platForm == 3 then 
        -- local multiThread = WZUISystem:getInstance():getMultiThreadSystem()
        -- multiThread:addDownloadTaskInFront(DownloadManager.downloadResCheck)
        DownloadManager:downloadResCheckAll()
    end

    g_bisloadingres = false--资源是否正在加载，用以控制是否可以打开tips弹框
end

--@brief    延迟请求一些协议，防止进主城协议一次性发送太多造成重连
function SceneCity:dowithSendProtocol(element)
    -- body
    element:disableSchedule()
    
    ProtocolProcessorScenePvpRank:regAll()
    ProtocolProcessorScenePvpRank:send_RANKMATCH_GetStatueInfo()
--    ProtocolProcessorWndLeague:send_HERO_HeroStartTime()
    ProtocolProcessorProfession:regAll()
    ProtocolProcessorProfession:send_PROFESSION_GetInfo()
    ProtocolProcessorKid:send_WEDDING_GetHouseItemCache()
end

--@brief    进入主城进行安卓权限申请
function SceneCity:checkPermission()
    --判断是否为android的quick包
    CCLuaLog("SceneCity:checkPermission")
    local platForm =  WZUISystem:getInstance():getPlatformInfo()

    --记录是否已申请过权限:1申请过    游戏中只会申请1次,之后不再申请
    local data = WZDataFile:getInstance():getUserData()
    if data then
        local value = data:getStringValue("SceneCityData", "bIsOpenedSceneCity")
        if value == "1" then
            return
        end
    end

    if platForm ~= 2 then
        return 
    end
    local curSdkObj = PassportSdkManager:getCurSdkObj()
    if curSdkObj then
        local config = curSdkObj.m_tConfig
        if config then
            if config.SDKOtherConfig.needPost == "true" then
                --android
                CCLuaLog("SceneCity:checkPermission-2")
                --curSdkObj:setCallbackByName("others",PassportSdkManager.getGoogleAdIdCallback, PassportSdkManager)
                local postData = {}
                postData.funType = "checkPermission_phone_1"
                local sJsonArg = json.encode(postData)
                curSdkObj:accountOthers(sJsonArg, nil, nil)
                --self:Others(postData)  

                if data then
                    data:setStringValue("SceneCityData", "bIsOpenedSceneCity", "1")
                    data:flush()
                end
            end 
        end
  end  
end

--@brief    是否活动弹框
function SceneCity:checkPopupWindow()
    if self.m_bIsWndCopyTop == nil and self:teach() == false and WndUpgrade.m_root == nil 
        --and ProjConfig.DEBUG ~= 1 
        then
        self.m_bIsNoTeach = true
        
        if GlobalGame.g_checkLoginActivities  then
            self:JoinByLogin()
        else
            local item = CacheCenter:getPlayerItemById(107024)
            local isToShowFirstRechange2, isEndShowFirstRechange2 = TeachGroup1:isFirstRechangePushFinish("2_1"), TeachGroup1:isFirstRechangePushFinish("2_2")
            WZLog("SceneCity:checkPopupWindow one", tostring(isToShowFirstRechange2), tostring(isEndShowFirstRechange2), Serialize(item))
            if (item and item.lastTime == 0 or isToShowFirstRechange2) and isEndShowFirstRechange2 == false then
                WZLog("SceneCity:checkPopupWindow two")
                if GlobalGame.g_bIsGetFirstRecharge and SceneBattle.m_bIsCreate == nil and 
                    SceneBattleLoading.m_bIsCreate == nil and (not WindowManager:getTeachShelterLayer()) and WndTeachTalk.m_root == nil then
                    WZLog("SceneCity:checkPopupWindow three")
                    TeachGroup1:setFirstRechangePushFinish("2_2")
                    local wnd = CellRechargePanelActivity:createElement()
                    CellRechargePanelActivity.m_bIsText = true
                    WindowManager:addWindow(wnd, CellRechargePanelActivity, true)
                end
            end
        end
        local NextDayState = CacheCenter:isNewDay("SignIn")
        if NextDayState.state then
            CacheCenter:resetNewDayState("SignIn")
            if WndGameSingIn.m_root == nil then 
                WndGameSingIn.m_bNeedSendProtocol = true 
                WZLog("SceneCity:onEnterTransitionDidFinish 11111")
                MsgBoxManager:showWelfare()
            end
        end
    end
end

--@brief    从副本出来检查是否弹框
function SceneCity:checkWelfare()
    if self:teach() == false then
        self.m_bIsNoTeach = true
        WZLog("SceneCity:checkWelfare three", GlobalGame.g_checkLoginActivities)
        if GlobalGame.g_checkLoginActivities  then
            self:JoinByLogin()
        end
        local NextDayState = CacheCenter:isNewDay("SignIn")
        if NextDayState.state then
            CacheCenter:resetNewDayState("SignIn")
            if WndGameSingIn.m_root == nil then 
                WndGameSingIn.m_bNeedSendProtocol = true 
                WZLog("SceneCity:checkWelfare 11111")
                -- WndWelfare:showInterface(1, 79)
                WndActivityIntegrate:showInterface(1, 79)
            end
        end
    end
end

--@brief    设置位置
function SceneCity:getSceneMoveEndPointX()
    local openTeach = self.m_nTeachStep
    if self.m_nTeachStep == nil then
        openTeach = self:getTeachStep()
    end
    
    local lv = CacheCenter:getPlayerInfo().level
--    openTeach,lv = 41, 9
    WZLog("SceneCity:getTeachStep-1 one", tostring(openTeach), lv, self.m_bIsLevelUp)
    if (openTeach == 1 and (lv <= 1 or TeachGroup1.ISTEACHMODE)) or (openTeach == 15 and (lv == 13 or TeachGroup1.ISTEACHMODE)) or (openTeach == 16 and (lv == 12 or TeachGroup1.ISTEACHMODE)) or (openTeach == 29 and (lv <= 17 or TeachGroup1.ISTEACHMODE)) then
        GlobalGame.g_nMoveEndPointXNowMoveElement =  nil
    elseif openTeach == 13 and (lv == 19 or TeachGroup1.ISTEACHMODE) then
        GlobalGame.g_nMoveEndPointXNowMoveElement = nil
    elseif self.m_bIsLevelUp and lv == 27 then
        GlobalGame.g_nMoveEndPointXNowMoveElement = nil
    elseif openTeach == 20 and (lv == 8 or TeachGroup1.ISTEACHMODE) or openTeach == 48 and (lv == 23 or TeachGroup1.ISTEACHMODE) then
        GlobalGame.g_nMoveEndPointXNowMoveElement = nil 
    elseif openTeach == 14 or openTeach == 15 then
        GlobalGame.g_nMoveEndPointXNowMoveElement = nil
    elseif openTeach == 23 and (lv == 15 or TeachGroup1.ISTEACHMODE) then
        GlobalGame.g_nMoveEndPointXNowMoveElement = -381 * (FigureSceneManager:getInstance().m_nScreenWidth - 1517) / (1136 - 1517)
    elseif openTeach == 16 and (lv == 10 or TeachGroup1.ISTEACHMODE) then
        GlobalGame.g_nMoveEndPointXNowMoveElement = 400 / 1136 * FigureSceneManager:getInstance().m_nScreenWidth
    elseif openTeach == 24 and (lv == 21 or TeachGroup1.ISTEACHMODE) then
        -- GlobalGame.g_nMoveEndPointXNowMoveElement = 500 / 1136 * FigureSceneManager:getInstance().m_nScreenWidth
       GlobalGame.g_nMoveEndPointXNowMoveElement = 750 / 1136 * FigureSceneManager:getInstance().m_nScreenWidth
    --    GlobalGame.g_nMoveEndPointXNowMoveElement = -200 * (FigureSceneManager:getInstance().m_nScreenWidth - 1517) / (1136 - 1517)
    elseif openTeach == 26 and (TeachGroup1:isTaskTeachFinish(TeachGroup1.TASK_ID_7) or TeachGroup1.ISTEACHMODE) then
        -- GlobalGame.g_nMoveEndPointXNowMoveElement = 900 / 1136 * FigureSceneManager:getInstance().m_nScreenWidth
        GlobalGame.g_nMoveEndPointXNowMoveElement = 600 / 1136 * FigureSceneManager:getInstance().m_nScreenWidth
    elseif (openTeach == 28 and (lv == 26 or TeachGroup1.ISTEACHMODE)) or (openTeach == 49 and (lv == 28 or TeachGroup1.ISTEACHMODE)) then
        GlobalGame.g_nMoveEndPointXNowMoveElement = nil
    elseif openTeach == 41 and (lv == 9 or TeachGroup1.ISTEACHMODE) or openTeach == 42 and (lv == 24 or TeachGroup1.ISTEACHMODE) then
        -- GlobalGame.g_nMoveEndPointXNowMoveElement = 500 / 1136 * FigureSceneManager:getInstance().m_nScreenWidth
       GlobalGame.g_nMoveEndPointXNowMoveElement = nil
    elseif self.m_bIsLevelUp and lv == 18 then
        GlobalGame.g_nMoveEndPointXNowMoveElement = 750 / 1136 * FigureSceneManager:getInstance().m_nScreenWidth
    end

    if ProjConfig.LANGUAGE == "vn" then 
        if openTeach == 42 and (lv == 19 or TeachGroup1.ISTEACHMODE) then
            GlobalGame.g_nMoveEndPointXNowMoveElement = nil
        end
    end
end

--@brief    设置位置
function SceneCity:setScenePos()
    
    self:getSceneMoveEndPointX()
    local scene = WZUIScene:luaTo(self.m_root:getChildElement("conBgLayer_SceneCity"))
    --WZLog("SceneCity:setScenePos two", tostring(scene), tostring( GlobalGame.g_nMoveEndPointXNowMoveElement))
    if scene ~= nil then
        if GlobalGame.g_nMoveEndPointXNowMoveElement then
            scene:setScenePosition(GlobalGame.g_nMoveEndPointXNowMoveElement,0.5)
        else
            scene:setScenePosition(2600,320)
        end
    end
end

--@brief    单人副本红点
function SceneCity:getSingleData()
    if SceneCity.m_root then
        WndSingleCopy:_initData()
        local single = false
        for i = 0, WndSingleCopy.m_nCurCopyIndex do

            if WndSingleCopy:_getSectionRewardStateByIndex(1,i,1) == 2 or WndSingleCopy:_getSectionRewardStateByIndex(2,i,1) == 2 or WndSingleCopy:_getSectionRewardStateByIndex(3,i,1) == 2 or WndSingleCopy:_getSectionRewardStateByIndex(1,i,2) == 2 or WndSingleCopy:_getSectionRewardStateByIndex(2,i,2) == 2 or WndSingleCopy:_getSectionRewardStateByIndex(3,i,2) == 2 then
                single = true
                break
            end
        end

        self:updateRedDotBuilding("singleMap", single, GlobalMethod:ccp(100,40))
    end
end

--@brief    获取该进行教学的组ID
function SceneCity:getTeachStep()
    local openTeach = 0
    if not TeachGroup1:isTeach() then
        return false
    end

    local isConfirmActive = WindowManager:ifActiveWindow(WndConfirmBox)
    --WZLog("SceneCity:getTeachStep zero", tostring(isConfirmActive))
    if isConfirmActive then
        return false
    end

    ProtocolProcessorSingleMap:regAll()
    --ProtocolProcessorTeach:send_TASK_TiroStep(16, -1)
    --TeachGroup1:setTeachFinish(31,-1)
    --TeachGroup1:taskTeach(TeachGroup1.TASK_ID_7)
    local group, step = nil, 1
    if group then
        TeachGroup1.ISTEACHMODE = true

        if group -1 > 0 then
            for i = 1 ,group -1 do
                TeachGroup1:setTeachFinish(i, -1, true)
            end
        end
        for i = group, TeachGroup1.COUNT do
            TeachGroup1:setTeachFinish(group, step, true)
        end
        openTeach = group
    else
        local isEndTeach26, teachStep26 = TeachGroup1:isTeachFinish(26)
        if isEndTeach26 ~= true and CacheCenter:getPlayerInfo().level == 10 and (TeachGroup1:isTaskTeachFinish(TeachGroup1.TASK_ID_7) or TeachGroup1.ISTEACHMODE) then
            openTeach = 26
            return openTeach
        end

        local isEndTeach41, teachStep41 = TeachGroup1:isTeachFinish(41)
        if isEndTeach41 ~= true and CacheCenter:getPlayerInfo().level > 9 then
            TeachGroup1:setTeachFinish(41, -1, true)
            ProtocolProcessorTeach:send_TASK_TiroStep(41, -1)
        end

        local stepList = {44,49,19,28,42,48,14,24,22,13,43,11,10,29,23,15,12,16,26,41,20,40,39,36,35,34,33,32,31,8,9,5,7,1,3,6}
        for j = 1 ,TeachGroup1.COUNT do
            local i = stepList[j]
            if i ~= nil then
                local isEndTeach, teachStep = TeachGroup1:isTeachFinish(i)
                WZLog("SceneCity:getTeachStep one", i, tostring(isEndTeach), tostring(teachStep), CheckButtonOpen(25,false))
                if i == 8 and teachStep== 0 and TeachGroup1:isTaskTeachFinish(TeachGroup1.TASK_ID_3) == true then
                    --TeachGroup1:setTeachFinish(i, 1)
                end
                if (i == 11 and teachStep >= 5) then
                    TeachGroup1:setTeachFinish(i, -1)
                elseif isEndTeach ~= true then
                    local nLevel = CacheCenter:getPlayerInfo().level
                    if (i == 22 and CheckButtonOpen(20,false)) or 
                        (i == 43 and CheckButtonOpen(ISLAND_EXTEND_PRACTICE,false) and nLevel == 23) or 
                        (i == 44 and CheckButtonOpen(ISLAND_EXTEND_CARD,false) and nLevel == 17) or 
                        (i == 19 and CheckButtonOpen(28,false)) or (i == 28 and CheckButtonOpen(10,false)) or 
                        (i == 42 and CheckButtonOpen(64,false) and nLevel == 24) or 
                        (i == 11 and CheckButtonOpen(43,false)) or (i == 14 and CheckButtonOpen(3,false)) or 
                        (i == 24 and CheckButtonOpen(8,false) and nLevel == 21) or (i == 13 and CheckButtonOpen(6,false)) or 
                        (i == 10 and CheckButtonOpen(41,false) and nLevel == 14) or 
                        (i == 29 and nLevel == 16) or (i == 23 and CheckButtonOpen(9,false)) or 
                        (i == 15 and CheckButtonOpen(1,false) and nLevel == 13) or (i == 16 and CheckButtonOpen(4,false)) or 
                        (i == 12 and CheckButtonOpen(27,false)) or 
                        (i == 26 and (nLevel == 10 and (TeachGroup1:isTaskTeachFinish(TeachGroup1.TASK_ID_7) or TeachGroup1.ISTEACHMODE))) or 
                        (i == 20 and CheckButtonOpen(5,false) and nLevel == 8) or (i == 8 and TeachGroup1:isTaskTeachFinish(TeachGroup1.TASK_ID_5) == true) or 
                        (i == 9 and CheckButtonOpen(40,false) and nLevel == 5) or 
                        (i == 7 and TeachGroup1:isTaskTeachFinish(10103) == true and nLevel <= 3) or 
                        (i == 31 and TeachGroup1:isTaskTeachFinish(10104) == true and nLevel <= 4) or 
                        (i == 32 and TeachGroup1:isTaskTeachFinish(10105) == true and nLevel <= 6) or 
                        (i == 33 and TeachGroup1:isTaskTeachFinish(10201) == true and nLevel <= 8) or 
                        (i == 34 and TeachGroup1:isTaskTeachFinish(10202) == true and nLevel <= 8) or 
                        (i == 35 and TeachGroup1:isTaskTeachFinish(10203) == true and nLevel <= 8) or 
                        (i == 36 and TeachGroup1:isTaskTeachFinish(10204) == true and nLevel <= 8) or 
                        (i == 39 and TeachGroup1:isTaskTeachFinish(10205) == true and nLevel <= 8) or 
                        (i == 40 and TeachGroup1:isTaskTeachFinish(10206) == true and nLevel <= 8) or 
                        (i == 5 and CheckButtonOpen(25,false)) or ((i == 1 and nLevel <= 1) or 
                        (i == 3 and nLevel <=2)) or 
                        (i == 6 and nLevel == 3) or
                        (i == 48 and nLevel ==23) or 
                        (i == 49 and nLevel ==28) or
                        (i == 41 and CheckButtonOpen(11,false) and nLevel == 9) then
                        openTeach = i

                        WZLog("SceneCity:teach one",i)
                        break
                    end

                end
            end
        end
    end

    return openTeach
end

--@brief    获取该进行教学的步骤ID
function SceneCity:teach(levelUp, isTrailerAnim)
    WZLog("SceneCity:teach one", tostring(GlobalGame.m_nTrailerId), tostring(isTrailerAnim))
    if GlobalGame.m_nTrailerId then
        addTrailerAnim(GlobalGame.m_nTrailerId)
        return true
    end
    local openTeach = self.m_nTeachStep
        if self.m_nTeachStep == nil then
            openTeach = self:getTeachStep()
        end
    WZLog("SceneCity:teach two", tostring(openTeach), tostring(levelUp), tostring(GlobalGame.g_tWndBottomBarObj), tostring(GlobalGame.g_tWndBottomBarObj and GlobalGame.g_tWndBottomBarObj.m_nMoveDirection))
    if openTeach == 0 and CacheCenter:getPlayerInfo().level < 3 then
        local isEndTeach3, teachStep3 = TeachGroup1:isTeachFinish(3)
        local isEndTeach6, teachStep6 = TeachGroup1:isTeachFinish(6)
        local isEndTeach7, teachStep7 = TeachGroup1:isTeachFinish(7)
        if isEndTeach7 == true then
            return false
        elseif isEndTeach7 ~= true and isEndTeach6 == true then
            WindowManager:addTeachShelterLayer( 999999 )
            SceneCopy:showScene(1)
        elseif isEndTeach6 == false then 
            WindowManager:addTeachShelterLayer( 999999 )
            SceneCopy:showScene(1)
        end
    end
    if openTeach == false then
        return false
    end

    local isTeach = true
    if openTeach == 0 then
        isTeach = false
    elseif openTeach == 1 then
        if true then
            TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {1,1})
        else
            WindowManager:addTeachShelterLayer( 999999 )
            -- 处理战斗时默认皮肤大招id获取不到的问题,做一层保险
            if GlobalGame.g_saveBigSkillType == 2 and (CacheCenter.m_nDefaultShapeBigSkill == nil or CacheCenter.m_nDefaultShapeBigSkill <= 0) then
                ProtocolProcessorWndSkillProp:send_PLAYER_GetShapeSkillList(2)
            end
            ProtocolProcessorSingleMap:send_SINGLEMAP_StartChallenge(10101, COPYTYPE_SINGLE)
        end
    elseif openTeach == 3 then
        if WndSingleCopy.m_root == nil then 
            WindowManager:addTeachShelterLayer( 999999 )
            SceneCopy:showScene(1)
        else
            WndSingleCopy:teachStart()
        end
    elseif openTeach == 4 then
        --WindowManager:addTeachShelterLayer( 999999 )
        -- -- 处理战斗时默认皮肤大招id获取不到的问题,做一层保险
        -- if GlobalGame.g_saveBigSkillType == 2 and (CacheCenter.m_nDefaultShapeBigSkill == nil or CacheCenter.m_nDefaultShapeBigSkill <= 0) then
        --     ProtocolProcessorWndSkillProp:send_PLAYER_GetShapeSkillList(2)
        -- end
        --ProtocolProcessorSingleMap:send_SINGLEMAP_StartChallenge(10102, COPYTYPE_SINGLE)
    elseif openTeach == 5 then
        if GlobalGame.g_tWndBottomBarObj == nil and self.m_tWndBottomBarObj == nil then
            return false
        end
        local elementObj = GlobalGame.g_tWndBottomBarObj or self.m_tWndBottomBarObj
        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {5,1, elementObj.m_root})
    elseif openTeach == 6 then
        if WndSingleCopy.m_root == nil then 
            WindowManager:addTeachShelterLayer( 999999 )
            SceneCopy:showScene(1)
        else
            WndSingleCopy:teachStart()
        end
    elseif openTeach == 7 then
        if WndSingleCopy.m_root == nil then 
            WindowManager:addTeachShelterLayer( 999999 )
            SceneCopy:showScene(1)
        else
            WndSingleCopy:teachStart()
        end
    elseif openTeach == 8 then
        if GlobalGame.g_tWndBottomBarObj == nil and self.m_tWndBottomBarObj == nil then
            return false
        end
        local elementObj = GlobalGame.g_tWndBottomBarObj or self.m_tWndBottomBarObj
        if elementObj.m_nMoveDirection == 0 then
            isTeach = elementObj:endMoveVerticalBar(nil, levelUp, isTrailerAnim)
        else
            isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {8,2, elementObj.m_root})
        end
    elseif openTeach == 9 and CheckButtonOpen(40,false) then
        if GlobalGame.g_tWndBottomBarObj == nil and self.m_tWndBottomBarObj == nil then
            return false
        end
        local elementObj = GlobalGame.g_tWndBottomBarObj or self.m_tWndBottomBarObj
        if elementObj.m_nMoveDirection == 0 then
            isTeach = elementObj:endMoveVerticalBar(nil, levelUp, isTrailerAnim)
        else
            isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {9,2,elementObj.m_root})
        end
    elseif openTeach == 10 and CheckButtonOpen(41,false) then
        
        if GlobalGame.g_tWndBottomBarObj == nil and self.m_tWndBottomBarObj == nil then
            return false
        end
        local elementObj = GlobalGame.g_tWndBottomBarObj or self.m_tWndBottomBarObj
        if elementObj.m_nMoveDirection == 0 then
            isTeach = elementObj:endMoveVerticalBar(nil, levelUp, isTrailerAnim)
        else
            isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {10,1,elementObj.m_root})
        end
    elseif openTeach == 11 and CheckButtonOpen(43,false) then
        if GlobalGame.g_tWndBottomBarObj == nil and self.m_tWndBottomBarObj == nil then
            return false
        end
        local elementObj = GlobalGame.g_tWndBottomBarObj or self.m_tWndBottomBarObj
        if elementObj.m_nMoveDirection == 0 then
            isTeach = elementObj:endMoveVerticalBar(nil, levelUp, isTrailerAnim)
        else
            isTeach =  TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {11,1,elementObj.m_root})
        end
    elseif openTeach == 12 and CheckButtonOpen(27,false) then
        if GlobalGame.g_tWndBottomBarObj == nil and self.m_tWndBottomBarObj == nil then
            return false
        end
        local elementObj = GlobalGame.g_tWndBottomBarObj or self.m_tWndBottomBarObj
        -- if elementObj.m_nMoveDirection == 0 then
        --     isTeach = elementObj:endMoveVerticalBar(nil, levelUp, isTrailerAnim)
        -- else
        --     isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {12,1,elementObj.m_root})
        -- end

        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {12,1,elementObj.m_root})
    elseif openTeach == 13 and CheckButtonOpen(6,false) then
        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {13,1})
    elseif openTeach == 14 and CheckButtonOpen(3,false) then
        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {14,1})
    elseif openTeach == 15 and CheckButtonOpen(1,false) then
        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {15,1,self.m_root})
    elseif openTeach == 16 and CheckButtonOpen(4,false) then
        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {16,1})
    elseif openTeach == 17 and CheckButtonOpen(15,false) then
        --TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {17,1,WndOwnCity.m_root})
    elseif openTeach == 18 and CheckButtonOpen(37,false) then
        --TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {18,1,GlobalGame.g_tWndBottomBarObj.m_root})
    elseif openTeach == 19 and CheckButtonOpen(28,false) then
        if GlobalGame.g_tWndBottomBarObj == nil and self.m_tWndBottomBarObj == nil then
            return false
        end
        local elementObj = GlobalGame.g_tWndBottomBarObj or self.m_tWndBottomBarObj
        -- if elementObj.m_nMoveDirection == 0 then
        --     isTeach = elementObj:endMoveVerticalBar(nil, levelUp, isTrailerAnim)
        -- else
        --     isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {19,1,elementObj.m_root})
        -- end
        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {19,1,elementObj.m_root})
    elseif openTeach == 20 and CheckButtonOpen(5,false) then
        local isEndTeach, teachStep = TeachGroup1:isTeachFinish(20)

        WZLog("SceneCity:teach three", teachStep, tostring(TeachGroup1:isTaskTeachFinish(TeachGroup1.TASK_ID_6)), tostring(GlobalGame.g_tWndBottomBarObj))
        if teachStep >= 4 or TeachGroup1:isTaskTeachFinish(TeachGroup1.TASK_ID_6) == true then
            if GlobalGame.g_tWndBottomBarObj == nil and self.m_tWndBottomBarObj == nil then
                return false
            end
            local elementObj = GlobalGame.g_tWndBottomBarObj or self.m_tWndBottomBarObj
            if elementObj.m_nMoveDirection == 0 then
                isTeach = elementObj:endMoveVerticalBar(nil, levelUp, isTrailerAnim)
            else
                isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {20,6,elementObj.m_root})
            end
        else
            isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {20,1})
        end
    elseif openTeach == 48 and CacheCenter:getPlayerInfo().level == 23 then
        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {48,1})
    elseif openTeach == 21 then
        --if CacheCenter:getPlayerInfo().level <= 3 then
        --    WindowManager:addTeachShelterLayer( 999999 )
            -- -- 处理战斗时默认皮肤大招id获取不到的问题,做一层保险
            -- if GlobalGame.g_saveBigSkillType == 2 and (CacheCenter.m_nDefaultShapeBigSkill == nil or CacheCenter.m_nDefaultShapeBigSkill <= 0) then
            --     ProtocolProcessorWndSkillProp:send_PLAYER_GetShapeSkillList(2)
            -- end
        --    ProtocolProcessorSingleMap:send_SINGLEMAP_StartChallenge(10104, COPYTYPE_SINGLE)
        --end
    elseif openTeach == 22 and CheckButtonOpen(20,false) then
        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {22,1,WndOwnCity.m_root})
    elseif openTeach == 23 and CheckButtonOpen(9,false) then
        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {23,1})
    elseif openTeach == 24 and CheckButtonOpen(8,false) and CacheCenter:getPlayerInfo().level == 21 then
        local isEndTeach, teachStep = TeachGroup1:isTeachFinish(24)
        if teachStep < 2 then
            isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {24,1})
        else 
            TeachGroup1:removeTeach()
        end
    elseif openTeach == 26 then
        local isEndTeach, teachStep = TeachGroup1:isTeachFinish(26)
        if teachStep < 3 then
            isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {26,1})
        -- elseif teachStep >= 7 then
        --     if GlobalGame.g_tWndBottomBarObj == nil and self.m_tWndBottomBarObj == nil then
        --         return false
        --     end
        --     local elementObj = GlobalGame.g_tWndBottomBarObj or self.m_tWndBottomBarObj
        --     if elementObj.m_nMoveDirection == 0 then
        --         isTeach = elementObj:endMoveVerticalBar(nil, levelUp, isTrailerAnim)
        --     else
        --         isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, true, {26,9,elementObj.m_root})
        --     end
        else
            ProtocolProcessorTeach:send_TASK_TiroStep(26, -1)
            TeachGroup1:setTeachFinish(26,-1)
            TeachGroup1:removeTeach()
            return false
        end
    elseif openTeach == 27 then
        if GlobalGame.g_tWndBottomBarObj == nil and self.m_tWndBottomBarObj == nil then
            return false
        end
        local elementObj = GlobalGame.g_tWndBottomBarObj or self.m_tWndBottomBarObj
        if elementObj.m_nMoveDirection == 0 then
            isTeach = elementObj:endMoveVerticalBar(nil, levelUp, isTrailerAnim)
        else
            isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {27,1,elementObj.m_root})
        end
    elseif openTeach == 28 and CheckButtonOpen(10,false) then
        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {28,1})
    elseif openTeach == 29 then
        TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {29,1})
    elseif openTeach == 30 then
        TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {30,1,SceneCity.m_root})
    elseif openTeach == 31 then
        if WndSingleCopy.m_root == nil then
            WindowManager:addTeachShelterLayer( 999999 )
            SceneCopy:showScene(1)
        else
            WndSingleCopy:teachStart()
        end
    elseif openTeach == 32 then
        if WndSingleCopy.m_root == nil then
            WindowManager:addTeachShelterLayer( 999999 )
            SceneCopy:showScene(1)
        else
            WndSingleCopy:teachStart()
        end
    elseif openTeach == 33 then
        if WndSingleCopy.m_root == nil then
            WindowManager:addTeachShelterLayer( 999999 )
            SceneCopy:showScene(1)
        else
            WndSingleCopy:teachStart()
        end
    elseif openTeach == 34 then
        if WndSingleCopy.m_root == nil then
            WindowManager:addTeachShelterLayer( 999999 )
            SceneCopy:showScene(1)
        else
            WndSingleCopy:teachStart()
        end
    elseif openTeach == 35 then
        if WndSingleCopy.m_root == nil then
            WindowManager:addTeachShelterLayer( 999999 )
            SceneCopy:showScene(1)
        else
            WndSingleCopy:teachStart()
        end
    elseif openTeach == 36 then
        if WndSingleCopy.m_root == nil then
            WindowManager:addTeachShelterLayer( 999999 )
            SceneCopy:showScene(1)
        else
            WndSingleCopy:teachStart()
        end
    elseif openTeach == 39 then
        if WndSingleCopy.m_root == nil then
            WindowManager:addTeachShelterLayer( 999999 )
            SceneCopy:showScene(1)
        else
            WndSingleCopy:teachStart()
        end
    elseif openTeach == 40 then
        if WndSingleCopy.m_root == nil then
            WindowManager:addTeachShelterLayer( 999999 )
            SceneCopy:showScene(1)
        else
            WndSingleCopy:teachStart()
        end
    elseif openTeach == 41 and CheckButtonOpen(11,false) and WndEquipLottery.m_root == nil then
        local isEndTeach, teachStep = TeachGroup1:isTeachFinish(41)
        if teachStep < 3 then
            isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {41,1})
        elseif GlobalGame.g_tWndBottomBarObj.m_nMoveDirection == 0 then
            isTeach = GlobalGame.g_tWndBottomBarObj:endMoveVerticalBar(nil, levelUp, isTrailerAnim)
        elseif WndEquipLottery.m_bIsCloseClick then
            if GlobalGame.g_tWndBottomBarObj == nil and self.m_tWndBottomBarObj == nil then
                return false
            end
            local elementObj = GlobalGame.g_tWndBottomBarObj or self.m_tWndBottomBarObj
            isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {41,7, elementObj.m_root})
        else
            TeachGroup1:setTeachFinish(41, -1, true)
            ProtocolProcessorTeach:send_TASK_TiroStep(41, -1)
            return false
        end
    elseif openTeach == 42 then
        if GlobalGame.g_tWndBottomBarObj == nil and self.m_tWndBottomBarObj == nil then
            return false
        end
        local elementObj = GlobalGame.g_tWndBottomBarObj or self.m_tWndBottomBarObj

        local isEndTeach, teachStep = TeachGroup1:isTeachFinish(42)
        if teachStep >= 4 then
            TeachGroup1:setTeachFinish(42, -1, true)
            ProtocolProcessorTeach:send_TASK_TiroStep(42, -1)
            return false
        end
        -- if elementObj.m_nMoveDirection == 0 then
        --     isTeach = elementObj:endMoveVerticalBar(nil, levelUp, isTrailerAnim)
        -- else
        --     isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {42,1, elementObj.m_root})
        -- end
        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {42,1, elementObj.m_root})
    elseif openTeach == 43 then
        if GlobalGame.g_tWndBottomBarObj == nil and self.m_tWndBottomBarObj == nil then
            return false
        end
        local elementObj = GlobalGame.g_tWndBottomBarObj or self.m_tWndBottomBarObj
        if elementObj.m_nMoveDirection == 0 then
            isTeach = elementObj:endMoveVerticalBar(nil, levelUp, isTrailerAnim)
        else
            isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {43,1, elementObj.m_root})
        end
    elseif openTeach == 44 then
        if GlobalGame.g_tWndBottomBarObj == nil and self.m_tWndBottomBarObj == nil then
            return false
        end
        local elementObj = GlobalGame.g_tWndBottomBarObj or self.m_tWndBottomBarObj
        -- if elementObj.m_nMoveDirection == 0 then
        --     isTeach = elementObj:endMoveVerticalBar(nil, levelUp, isTrailerAnim)
        -- else
        --     isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {44,1, elementObj.m_root})
        -- end

        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {44,1,elementObj.m_root})
    elseif openTeach == 49 and CacheCenter:getPlayerInfo().level == 28 then
        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {49,1})
    end


    --WZLog("SceneCity:teach three", tostring(isTeach), tostring(GlobalGame.g_checkLoginActivities))
    if isTeach == false then
        return false
    end
end

--@brief    是否从登录界面进入主城
function SceneCity:JoinByLogin(  )
    WZLog("SceneCity:JoinByLogin")
    GlobalGame.g_checkLoginActivities = false 
   
    self:ShowActivityUI()

end


--@brief    弹出游戏公告  add by weidong
function SceneCity:ShowActivityUI(  )
  	WZLog("SceneCity:ShowActivityUI(  )")
  	--do return end
   
    local action1 = CCDelayTime:create(0.5)
    local action2 = CCCallFuncN:create(function() 
		local adMessage = CacheCenter:getAdMessage()
		local displayAD = "1"
    	local data = WZDataFile:getInstance():getUserData()
    	if data ~= nil then
       	    displayAD = data:getStringValue("AdData", "Display"..CacheCenter:getPlayerInfo().id)
    	end
		WZLog("是否弹出广告",CacheCenter:getGameParam().isAd,ADINDEX,displayAD)
		if adMessage ~= nil and #adMessage > 0 then
			WZLog("是否弹出广告1",adMessage[#adMessage].sort)
		end

        local item = CacheCenter:getPlayerItemById(107024)
        local isToShowFirstRechange2, isEndShowFirstRechange2 = TeachGroup1:isFirstRechangePushFinish("2_1"), TeachGroup1:isFirstRechangePushFinish("2_2")
        WZLog("SceneCity:checkPopupWindow one", tostring(isToShowFirstRechange2), tostring(isEndShowFirstRechange2), Serialize(item))
        if (item and item.lastTime == 0 or isToShowFirstRechange2) and isEndShowFirstRechange2 == false then
            WZLog("SceneCity:checkPopupWindow two")
            if GlobalGame.g_bIsGetFirstRecharge and SceneBattle.m_bIsCreate == nil and 
                SceneBattleLoading.m_bIsCreate == nil and (not WindowManager:getTeachShelterLayer()) and WndTeachTalk.m_root == nil then
                WZLog("SceneCity:checkPopupWindow three")
                TeachGroup1:setFirstRechangePushFinish("2_2")
                local wnd = CellRechargePanelActivity:createElement()
                CellRechargePanelActivity.m_bIsText = true
                WindowManager:addWindow(wnd, CellRechargePanelActivity, true)
                GlobalGame.g_checkLoginActivities = true
            end
        end

        if CellRechargePanelActivity.m_bIsText == nil then
            --获取保存的状态
            WZLog("SceneCity:checkPopupWindow one _ 11", GlobalGame.g_autoThankfulSign)
            WndThankfulSign:getAutoActivity()
            WndWelcomeBackActivity:getAutoActivity()
            WndSevenYear:getAutoActivity()

            if CheckButtonShow(21) then
                if GlobalGame.g_autoWelcomeBack or GlobalGame.g_autoThankfulSign or GlobalGame.g_autoSevenYear then
                    if g_cityExtenInfo == nil then 
                        g_bIsDelayCheckAutoActivity = true
                    else
                        self:aloneActivityWinCheck()
                    end
                else
                    SceneCity:checkOtherWnd()
                end
            else
                SceneCity:checkOtherWnd()
            end
        end
     end)

    local array = CCArray:create()
    array:addObject(action1)
    array:addObject(action2)
    self.m_root:runAction(CCSequence:create(array))
end

--@brief    检测token时调用
function SceneCity:_scheduleUpdateCheckTken()
end

--@param    发送玩家微博ID
function SceneCity:sendWeibo()
    local tData = self:_getWeiboData()
    if tData then
        --发送玩家微博ID（PLAYER_SetPlayerWeiboId = 45）
        ProtocolProcessorAccount:send_PLAYER_SetPlayerWeiboId(tData[1], tData[2], tData[3] )
    end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function SceneCity:onExit(element)
    WZLog("SceneCity:onExit zero", self.m_bIsNoRelease)
    --足迹
    FootEffectManager:getInstance():destroy()
    
    if self.m_bIsNoRelease == nil then
        WZLog("SceneCity:onExit one")
        --ios 主动释放资源
        local platForm =  WZUISystem:getInstance():getPlatformInfo()
        if WZFileUtil:isFileExist("pack/city_new_ui/pack_city_new_ui_0.plist") and platForm == 1 then
            CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("pack/city_new_ui/pack_city_new_ui_0.plist")
        end
        if WZFileUtil:isFileExist("pack/city/pack_city_0.plist") and platForm == 1 then
            CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("pack/city/pack_city_0.plist")
        end
        if WZFileUtil:isFileExist("pack/city/pack_city_1.plist") and platForm == 1 then
            CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("pack/city/pack_city_1.plist")
        end
        if WZFileUtil:isFileExist("pack/city/pack_city_2.plist") and platForm == 1 then
            CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("pack/city/pack_city_2.plist")
        end
        
        GlobalGame:getBtnRedPointEvent():unregListener("btnTask","SceneCity")
        GlobalGame:getBtnRedPointEvent():unregListener("btnBag","SceneCity")
    	CCDirector:sharedDirector():setAnimationInterval(1.0/60)
        if self.m_tTextureCache ~= nil then
            for i, v in pairs(self.m_tTextureCache) do
                if v ~= nil and v.release ~= nil then
                    v:release()
                end
            end
        end
    end

    ProtocolProcessorSceneIsland:unregAll()
    ProtocolProcessorProfession:unregAll()

    CacheCenter:unregisterUpatePlayerInfoObserver(self)
    --登录小岛界面后活动界面更改
    --g_checkLoginActivities = false

    WZLog("SceneCity:onExit two", self.m_scheduleId, self.m_scheduleLoopId)
    if self.m_scheduleLoopId ~= -1 then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_scheduleLoopId)
        self.m_scheduleLoopId = -1
        CCDirector:sharedDirector():setAnimationInterval(1.0/60)

    end

    if self.m_root then 
        local conAll = GetElement(self.m_root, "conAll_SceneCity", WZUIContainer)
        if conAll then 
            conAll:disableSchedule()
        end
    end

    --self.m_root:disableSchedule()
    if self.m_bIsDoSendEvent then 
        GlobalGame.g_bSendEventPerMinite = false
    end

    FigureSceneManager:getInstance():release()
	self:_unInit()
	CCArmatureDataManager:sharedArmatureDataManager():removeAll()

    --退出场景时关闭第三方渠道显示的icon
    local curSdkObj = PassportSdkManager:getCurSdkObj()
        if curSdkObj then
            local config = curSdkObj.m_tConfig
            if config.SDKOtherConfig.isNeedListToAppStore == "true" and GlobalGame.g_tProducteList.productPrice and #GlobalGame.g_tProducteList.productPrice == 0 then
                UNRegisterProtolRecharge()
            end
        end

    if self.m_scheduleId ~= -1 then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_scheduleId)
        self.m_scheduleId = -1
    end

    if m_ncheckPushId ~= nil and m_ncheckPushId ~= -1 then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(m_ncheckPushId)
        m_ncheckPushId = -1
    end
    
    --鲜花榜协议
    Protocol:unreg( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GiveFlowerOk, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GiveFlowerOk", "t")
    self:unregister()

end

--@brief   每帧调用函数
function SceneCity:updateSchedule(dt)
    -- WZLog("SceneCity:updateSchedule",SystemTime:getServerTime())
    local self = SceneCity
    local time = WZThread:getUTickCount()

    --自动战斗延迟初始化（避免协议冲突）
    if AutoRunBattleConst.AUTO_RUN_BATTLE then
        curTime = math.floor(time/1000)
        --延时进入场景
        if not self.m_bAutoInit then
            if not self.m_nAutoDelay then
                self.m_nAutoDelay = curTime
            end
           
            if curTime - self.m_nAutoDelay > 3000 then
                GlobalGame:getGameEventDispathcer():Dispatch("GameState_Change","state_scene")
                self.m_bAutoInit = true
            end
        end
        --英雄联赛自动创建队伍
        if AutoRunBattleConst.BattleType == AutoRunBattleConst.HERO_WAR_BUILD then
            if not self.m_nHeroTeamDelay then
                self.m_nHeroTeamDelay = curTime
            end
            if curTime - self.m_nHeroTeamDelay > 5000 then
                self.m_nHeroTeamDelay = 0
                ProtocolProcessorWndLeague:send_HERO_ReadyFight()
                if CacheCenter:getPlayerInfo().teamId > 0 then
                    ProtocolProcessorWndLeague:send_HERO_GetApplyList()
                    ProtocolProcessorWndLeague:send_HERO_SearchTeam(CacheCenter:getPlayerInfo().teamId )
                else
                    ProtocolProcessorWndLeague:send_HERO_GetHeroTeamList()
                end
            end
        end
    end
    
    if self.m_count == 0 then
        ProtocolProcessorSceneIsland:regAll()
        --结婚协议注册
        WndMarryManager:RegAllProtocol()
    elseif self.m_count == 1 then
        --local tBtnsInfo = GlobalGame:getBtnInfoByType(ISLAND_BTNTYPE_BUILDING)
        --self:setBtnsInfo(tBtnsInfo)
    elseif self.m_count == 2 then
        if GlobalGame.bOpenGPS == true then
            GlobalGame.bOpenGPS = false
        end
        -- if GlobalGame.bOpenGPS == false then
        --     GlobalGame.bOpenGPS = true
        --     RoleGPS:checkGPS()--检查GPS状态
        -- end
    elseif self.m_count == 3 then
        --初始化聊天
        WndChat:initChat()
    elseif self.m_count == 4 then
        self:checkIsNeedDownload()
    elseif self.m_count == 5 then
        
    elseif self.m_count == 6 then
        
    elseif self.m_count == 7 then
        
    elseif self.m_count == 8 then
		if SceneCity.m_root ~= nil then
        	SoundManager:playBgMusic(SoundDefine.E_MUSIC_ISLAND)
		end
        WZLog("SceneCity:_updateSchedule8",WZThread:getUTickCount()-time)
    elseif self.m_count == 9 then

    elseif self.m_count == 10 then
        if WndRegister ~= nil then
            WndRegister:stopLoading()
        end
    elseif self.m_count == 11 then
        if WndChangeAccount ~= nil then
            WndChangeAccount:stopLoading()
        end
    elseif self.m_count == 12 then
        if WndExistAccount ~= nil then
            WndExistAccount:stopLoading()
        end
    elseif self.m_count == 13 then
        local curSdkObj = PassportSdkManager:getCurSdkObj()
        if curSdkObj ~= nil then
            local config = curSdkObj.m_tConfig
            --苹果支付，先去请求充值列表
            -- if config.SDKOtherConfig.isNeedListToAppStore == "true" and #GlobalGame.g_tProducteList.productPrice == 0 then
            --     RegisterProtolRecharge()
            --     bIsLoadInIsland = true
            -- end
        end
    elseif self.m_count == 14 then
        --第三方渠道登陆icon显示
        if ProjConfig.LANGUAGE == "pt" and GlobalGame.g_bIshasPlatForm == false then
            GlobalGame.g_bIshasPlatForm = true
            local tshowPlatFormParams = {}
            tshowPlatFormParams.funType = "showPlatForm"
            local data = WZDataFile:getInstance():getUserData()
            if nil == data then
                tshowPlatFormParams.userID = ""
                tshowPlatFormParams.serverCode = ""
            else
                tshowPlatFormParams.userID = data:getStringValue("AccountData", "account")
                tshowPlatFormParams.serverCode = data:getStringValue("IPDParam", "ServerId")
            end
            tshowPlatFormParams.uid = tostring(GlobalGame.g_tPlayerInfo.nPlayerId)
            tshowPlatFormParams.level = tostring(GlobalGame.g_tPlayerInfo.nLevel)
            tshowPlatFormParams.playerName = GlobalGame.g_tPlayerInfo.sPlayerName
            tshowPlatFormParams.serverName = IPDhttpServer:getCurServerName()

            local sJsonArg = json.encode(tshowPlatFormParams)
            WZLog("WndRightMenu:onClickFacebookInvite sJsonArg", sJsonArg)
            --curSdkObj:accountOthers(sJsonArg, nil, NIL)
        end
    elseif self.m_count == 15 then
        if GlobalGame.g_bIfInTeaching == false and self.m_root ~= nil and GlobalGame.g_checkLoginActivities == false then
            self.m_root:enableSchedule("scheduleShowDialog", 2.5)
        end
    else
        self.m_bIsCanClick = true
        --计时器不停止
         if AutoRunBattleConst.AUTO_RUN_BATTLE then
            return
         end

        if self.m_scheduleId ~= -1 then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_scheduleId)
            self.m_scheduleId = -1
            WZLog("SceneCity:_updateSchedule17",WZThread:getUTickCount()-time)
        end
    end

     self.m_count =  self.m_count + 1
end

--@brief	初始化
--@note		界面前的所有初始化
function SceneCity:init()
    WZLog("SceneCity:init one")
    --检测是否使用粒子效果
    WBattleGlobal:getCurrent():isHighEndMachine()

    self:initScene()
end

--@brief	初始化场景
--@note
function SceneCity:initScene()
    local scene = WZUIScene:luaTo(self.m_root:getChildElement("conBgLayer_SceneCity"))
    ---[[
    self.m_tWinSize = CCEGLView:sharedOpenGLView():getFrameSize()
    local scaleY = self.m_tWinSize.height/640
    local scaleX = self.m_tWinSize.width/1136
    local realScale = scaleY/scaleX
    
    scene:setResistance(0.8)
    scene:setScaleX(realScale)
    if scaleX < scaleY then
        local diff = 1136*scaleY-self.m_tWinSize.width
        diff = diff/scaleY
        scene:setContentSize(CCSizeMake(1136-diff,640))
        print("SceneCity:initScene one", scaleY, scaleX, diff)
    else
        local diff = self.m_tWinSize.width - 1136*scaleY
        diff = diff/scaleY
        scene:setContentSize(CCSizeMake(1136+diff,640))
        print("SceneCity:initScene TWO", scaleY, scaleX, diff)
    end
    --]]
    
    local playerLayer = scene:getPlayerLayer()
    self.m_tSceneLayer = scene
    self.m_tPlayerLayer = playerLayer
    playerLayer:setDrawInfo(false)
    playerLayer:setStartMoveCallback("startMoveCallback")
    playerLayer:setEndMoveCallback("endMoveCallback")
    playerLayer:setNextMoveCellCallback("nextMoveCellCallback")

    FigureSceneManager:getInstance():setCurrentScene(self,Chat_Channel_Island)
    FigureSceneManager:getInstance():setFigureLayer(self.m_tPlayerLayer)
    -- if self:isLouyixiao() or SceneCity:isSummer() then
    --     FigureSceneManager:getInstance():createNpc3(1)
    -- end
    
    self:initFootLayer()
    --FigureSceneManager:getInstance():initFigure()

    --self:updateQualifyingStatue()
end

function SceneCity:initFootLayer()
    if not self.m_root then
        return
    end
    local scene = WZUIScene:luaTo(self.m_root:getChildElement("conBgLayer_SceneCity"))
    local playerLayer = scene:getPlayerLayer()
    FootEffectManager:getInstance():setFootLayer(playerLayer,true)
end

--@brief	点击场景
function SceneCity:onClickBg(element,event,x,y)
    FigureSceneManager:getInstance():onClickBg(element,event,x,y)
	if WndItemInfo then
		WndItemInfo:onCloseClick()
	end
end

--@brief	开始移动
function SceneCity:startMoveCallback(element,node,x,y)
    FigureSceneManager:getInstance():startMoveCallback(element,node,x,y)
end

--@brief	移动中
function SceneCity:nextMoveCellCallback(element,node,x,y,index)
    FigureSceneManager:getInstance():nextMoveCellCallback(element,node,x,y,index)
end

--@brief	结束移动
function SceneCity:endMoveCallback(element,node)
    FigureSceneManager:getInstance():endMoveCallback(element,node)
end

--@brief	缓存纹理
--@note		缓存纹理,减少纹理加载操作
function SceneCity:createTextureCache(path)
    --local fullPath = CCFileUtils:sharedFileUtils():fullPathForFilename(path)
    local isFileExist = WZFileUtil:isFileExist(path)
    WZLog("SceneCity:createTextureCache", isFileExist, path)
    if isFileExist ~= true then
        return
    end

    if self.m_tTextureCache == nil then
        self.m_tTextureCache = {}
    end

    local textureCacheElement = CCSprite:create(path)
    if textureCacheElement ~= nil then
        textureCacheElement:retain()
        table.insert(self.m_tTextureCache, textureCacheElement)
    end
end

--@brief	创建背景
--@return
--@note
function SceneCity:createBg()
    WZLog("SceneCity:createBg")

    self:createBgSky()
    self:createBgSea()
    self:createBgLand()
end

--@brief	创建背景_空
--@return
--@note
function SceneCity:createBgSky()
    WZLog("SceneCity:createBgSky")

    local offsetX, offsetY = 0.62, 1.07
    local count = 4

    for i = 1, count do
        local bg = WZUIImage:create()
        bg:setFile("ui/city/bg/5.png")
        bg:setAnchorPoint(GlobalMethod:ccp(0,1))
        bg:setRelativePosition(GlobalMethod:ccp(-0.683 + offsetX * (i-1), offsetY))
        bg:setZOrder(1)
        bg:setUseOriginSize(true)
        bg:setUseOriginSizeProportion(true)
        bg:setName("imgBgSky"..i.."_SceneCity")
        self:getBgLayer():addChild(bg)
    end
end

--@brief	创建背景_海
--@return
--@note
function SceneCity:createBgSea()
    WZLog("SceneCity:createBgSea")

    local offsetX, offsetY = 0.09, 0.43
    local count = 90

    for i = 1, count do
        local bg = WZUIImage:create()
        bg:setFile("ui/city/bg/12.png")
        bg:setAnchorPoint(GlobalMethod:ccp(0,0))
        bg:setRelativePosition(GlobalMethod:ccp(-0.683 + offsetX * (i-1), offsetY))
        bg:setZOrder(2)
        bg:setUseOriginSize(true)
        bg:setUseOriginSizeProportion(true)
        bg:setName("imgBgSea"..i.."_SceneCity")
        self:getBgLayer():addChild(bg)
    end
end

--@brief	创建背景_陆
--@return
--@note
function SceneCity:createBgLand()
    WZLog("SceneCity:createBgLand")

    local offsetX, offsetY = 0.5, -0.06
    local count = 5

    for i = 1, count do
        local bg = WZUIImage:create()
        bg:setFile("ui/city/bg/6.png")
        bg:setAnchorPoint(GlobalMethod:ccp(0,0))
        bg:setRelativePosition(GlobalMethod:ccp(-0.684 + offsetX * (i-1), offsetY))
        bg:setZOrder(3)
        bg:setUseOriginSize(true)
        bg:setUseOriginSizeProportion(true)
        bg:setName("imgBgLand"..i.."_SceneCity")
        self:getBgLayer():addChild(bg)
    end
end

--@brief	获取人物Layer大小
--@return	table,人物Layer大小
--@note
function SceneCity:getFrontLayerSize()
	if self.m_nFrontLayerWidth == nil or self.m_nFrontLayerHeight == nil then
		if self:getFrontLayer() then
			local size = self:getFigureLayer():getContentSize()
			self.m_nFrontLayerWidth = size.width
			self.m_nFrontLayerHeight = size.height
		end
	end
	return {width = self.m_nFrontLayerWidth , height = self.m_nFrontLayerHeight }
end

--@brief	设置按钮
--@return	
--@note
function SceneCity:setBtnsInfo(btnsInfo)
    self.m_tBtnsInfo = btnsInfo
    self:_update()
end

local buildingWordName = {
    [ISLAND_BUILDING_SINGLEMAP] =       LocalStrings.OPTIMIZE_TEXT47,
    [ISLAND_BUILDING_TOWER] =       LocalStrings.CHALLENGEENTRANCE_TITLE,
    [ISLAND_BUILDING_RANK] =       "",
    [ISLAND_BUILDING_HALL] =       LocalStrings.PVP_HALL_9,
    [ISLAND_BUILDING_SHOP] =       LocalStrings.SHOP,
    [ISLAND_BUILDING_MARRY] =       LocalStrings.CITY_TITLE32,
    [ISLAND_BUILDING_COMMUNITY] =       LocalStrings.COMMUNITY,
    [ISLAND_BUILDING_EQUIT_LOTTERY] =       LocalStrings.CALL,
    [ISLAND_BUILDING_TREASURE] =       LocalStrings.CITY_TITLE34,
    [ISLAND_BUILDING_REVELRY1] =       LocalStrings.WONDERFUL_TEXT1,
    [ISLAND_BUILDING_HOME] =       LocalStrings.CITY_TITLE33,
    [ISLAND_BUILDING_REVELRY2] =       LocalStrings.WONDERFUL_TEXT1,
    [ISLAND_BUILDING_TRADEWOMAN] =       LocalStrings.CITY_TITLE35,
    [ISLAND_BUILDING_KID] =       LocalStrings.KID_TEXT42,
    [ISLAND_BUILDING_HOLIDAYVILLAGE] =       LocalStrings.HOLIDAYVILLAGE_TEXT1[1],
}


--@brief    界面更新函数
--@note     根据小岛的状态更新背景
function SceneCity:_update()
    if self.m_root == nil and self.m_tBtnsInfo == nil then
        return
    end

    local isOpenMarry = false
    for i,v in pairs (self.m_tBtnsInfo) do
        local bFlag, lv = IfButtonOpen(v)
        local btnName = GetElementWithoutAssert(self.m_root, "building" .. v.buttonId , WZUIImage)
        WZLog("SceneCity:_update one", lv, "building" .. v.buttonId, tostring(btnName), tostring(bFlag))
        if btnName then
            if v.buttonId == 8 and lv == 999 then
                btnName:setVisible(false)
                isOpenMarry = false
            elseif v.buttonId == 8 and lv ~= 999 then
                btnName:setVisible(true)
                isOpenMarry = true
            elseif (v.buttonId == 122 or v.buttonId == 127 or v.buttonId == 221) and lv == 999 then
                btnName:setVisible(false)
                local btn = GetElement(self.m_root, "building" .. v.buttonId .. "_SceneCity", WZUIButton)
                btn:setVisible(false)
            elseif v.buttonId == 139 then
                WZLog("SceneCity:_update 139")
            elseif v.buttonId == 4 then
                btnName:setFile("")
            elseif bFlag == false then
                btnName:setVisible(false)
            end
            local buildingWord = btnName:getChildByTag(888)
            if not buildingWord and buildingWordName[v.buttonId] then 
                local txtValue = WZUILabelTTF:create()
                txtValue:setFontSize(22)
                txtValue:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
                txtValue:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
                txtValue:setColor(GlobalMethod:ccc3(255,236,193))
                txtValue:setStrokeColor(GlobalMethod:ccc3(132,66,29))
                txtValue:setStrokeSize(4)
                txtValue:setEnableStroke(true)
                txtValue:setText(buildingWordName[v.buttonId])
                btnName:addChild(txtValue, 1, 888)
            end
        end

        if bFlag == false then
            if v.buttonId ~= 5 and v.buttonId ~= 11 then
                local con = GetElement(self.m_root, "conBuilding" .. v.buttonId .. "_1_SceneCity", WZUIContainer)
                local con2 = GetElement(self.m_root, "conBuilding" .. v.buttonId .. "_2_SceneCity", WZUIContainer)

                if con then
                    con:setVisible(false)
                end

                if con2 then
                    con2:setVisible(false)
                end
            else
                local anim = GetElement(self.m_root, "animBuilding" .. v.buttonId .. "_1", WZUISpine)
                local anim2 = GetElement(self.m_root, "animBuilding" .. v.buttonId .. "_2", WZUISpine)
                anim:setAnimationName("close")
                anim2:setAnimationName("close")
            end
        end

    end

    if CacheCenter:getGameParam().gameStatus == "1" or CheckButtonShow(114,true) == false then
        GetElement(self.m_root, "building114_SceneCity", WZUIButton):setVisible(false)
        GetElementWithoutAssert(self.m_root, "building114" , WZUIImage):setVisible(false)
    end

    if self:isLouyixiao() == false then
        GetElement(self.m_root, "building132_SceneCity", WZUIButton):setVisible(false)
        GetElementWithoutAssert(self.m_root, "building132" , WZUIImage):setVisible(false)
    end

    if SceneCity:isAnniversary() == false then
        local btnName = GetElementWithoutAssert(self.m_root, "building122" , WZUIImage)
        btnName:setVisible(false)
        local btn = GetElement(self.m_root, "building122_SceneCity", WZUIButton)
        btn:setVisible(false)
    end

    if SceneCity:isSummer() == false then
        local btnName = GetElementWithoutAssert(self.m_root, "building127" , WZUIImage)
        btnName:setVisible(false)
        local btn = GetElement(self.m_root, "building127_SceneCity", WZUIButton)
        btn:setVisible(false)
    end

    local _time, isOpen = GlobalGame:getEscapeInfo()
    isOpen = 0
    if isOpen ~= 1 then
        local btnName = GetElementWithoutAssert(self.m_root, "building139" , WZUIImage)
        if btnName then
            btnName:setVisible(false)
        end
        local btn = GetElement(self.m_root, "building139_SceneCity", WZUIButton)
        if btn then
            btn:setVisible(false)
        end
    end

    if self.m_tSceneLayer then
        if self:isLouyixiao() == false and SceneCity:isSummer() == false then
            FigureSceneManager:getInstance():destroyNpc3()
        else
            --FigureSceneManager:getInstance():createNpc3(2)
        end
    end

    if SceneCity:isSterious() == false or true then
        local btnName = GetElementWithoutAssert(self.m_root, "building136" , WZUIImage)
        btnName:setVisible(false)
        local btn = GetElement(self.m_root, "building136_SceneCity", WZUIButton)
        btn:setVisible(false)
    end

    SceneCity:updateRedDotBuilding("summer", WndSumVacAct:bShowRedPoint())
    WZLog("SceneCity:_update two", CacheCenter:getGameParam().spokesmanActrivityConfig)

    --华为渠道判定结婚系统为18+，游戏为16+，故统一在审核服通过功能开放表隐藏夫妻争霸，结婚大厅
    --WZLog("SceneCity:_update CacheCenter:getGameParam().gameStatus = ", CacheCenter:getGameParam().gameStatus)
    --WZLog("SceneCity:_update serverName=", IPDhttpServer:getCurServerName())
    if CacheCenter:getGameParam().gameStatus ~= "0" then
        WZLog("SceneCity:_update 审核服")
        isOpenMarry = false
    end
    if isOpenMarry == false then
        GetElement(self.m_root, "building8_SceneCity", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "building8", WZUIImage):setVisible(false)
        GetElementWithoutAssert(self.m_root, "building8_1_SceneCity" , WZUIImage):setVisible(false)
    end

    local teachList = {"2_1", "3_1","5_1", "5_2","7_1", "8_1", "8_2", "9_1", "11_1", "11_2", "4_1", "4_2"}
    for i, buildingName in pairs (teachList) do
        GetElementWithoutAssert(self.m_root, "building"..buildingName.."_SceneCity" , WZUIImage):setVisible(false)
    end
end

function SceneCity:isLouyixiao()
    local isLouyixiao = tonumber(GlobalGame.g_autoLouraActivity or 0) == 1
    WZLog("SceneCity:isLouyixiao", isLouyixiao, CheckButtonShow(132,true))
    isLouyixiao = isLouyixiao and CheckButtonShow(132,true)

    return isLouyixiao
end

function SceneCity:openLouyixiao(isOpen)
    isOpen = isOpen and CheckButtonShow(132,true)
    WZLog("SceneCity:openLouyixiao", isOpen)
    if SceneCity.m_root then
        local isVisible = GetElement(self.m_root, "building132_SceneCity", WZUIButton):isVisible()
        if isOpen and isVisible == false then
            GetElement(self.m_root, "building132_SceneCity", WZUIButton):setVisible(true)
            GetElementWithoutAssert(self.m_root, "building132" , WZUIImage):setVisible(true)
        elseif not isOpen and isVisible == true then
            GetElement(self.m_root, "building132_SceneCity", WZUIButton):setVisible(false)
            GetElementWithoutAssert(self.m_root, "building132" , WZUIImage):setVisible(false)
        end
    end

    self:closeLouyixiaoActivity()
end

function SceneCity:openSterious(isOpen)
    isOpen = isOpen and CheckButtonShow(136,true)
	isOpen = false
    if SceneCity.m_root then
        local isVisible = GetElement(self.m_root, "building136_SceneCity", WZUIButton):isVisible()
        if isOpen and isVisible == false then
            GetElement(self.m_root, "building136_SceneCity", WZUIButton):setVisible(true)
            GetElementWithoutAssert(self.m_root, "building136" , WZUIImage):setVisible(true)
        elseif not isOpen and isVisible == true then
            GetElement(self.m_root, "building136_SceneCity", WZUIButton):setVisible(false)
            GetElementWithoutAssert(self.m_root, "building136" , WZUIImage):setVisible(false)
        end
    end
end

function SceneCity:openTree(isOpen)
--    WZLog("SceneCity:openTree", isOpen)
    if isOpen then
        self:openLouyixiao(isOpen)
    elseif isOpen == false and self:isLouyixiao() == false then
        self:openLouyixiao(isOpen)
    end
end

function SceneCity:isSterious()
    local isSummer = GlobalGame.g_isSterious
    if isSummer == 1 then
        isSummer = true
    else
        isSummer = false
    end
--    WZLog("SceneCity:isSterious", isSummer)
    return isSummer
end

function SceneCity:isSummer()
    local isSummer = GlobalGame.g_autoSummerActivity
    if isSummer == 2 or isSummer == 3 then
        isSummer = true
    else
        isSummer = false
    end
--    WZLog("SceneCity:isSummer", isSummer)
    return isSummer
end

function SceneCity:isAnniversary()
    local timeCur = os.date("*t",SystemTime:getServerTime())
    local timeEnd = SplitStringWithSeparator(CacheCenter:getGameParam().nianGifeEnd or "", "-", nil, true) or {}
    local DayEndTab = {}
    local time = false
    if #timeEnd == 3 and CheckButtonShow(122,true) then
        DayEndTab.year = timeEnd[1]
        DayEndTab.month = timeEnd[2]
        DayEndTab.day = timeEnd[3] - 1
        if timeCur.year > DayEndTab.year then
            time = false
        elseif timeCur.year < DayEndTab.year then
            time = true
        elseif timeCur.month > DayEndTab.month then
            time = false
        elseif timeCur.month < DayEndTab.month then
            time = true
        elseif timeCur.month == DayEndTab.month and timeCur.day > DayEndTab.day then
            time = false
        else
            time = true
        end
    end

    WZLog("SceneCity:isAnniversary", tostring(time), tostring(CheckButtonOpen(122,true)), CacheCenter:getGameParam().nianGifeEnd, "timeEnd", timeEnd[1], timeEnd[2], timeEnd[3], "timeCur", timeCur.year, timeCur.month, timeCur.day, "DayEndTab", DayEndTab.year, DayEndTab.month, DayEndTab.day)
    return time
end

function SceneCity:isAnniversaryNoStart()
    local timeCur = os.date("*t",SystemTime:getServerTime())
    local timeEnd = SplitStringWithSeparator(CacheCenter:getGameParam().nianGifeStar or "", "-", nil, true) or {}
    local DayEndTab = {}
    local time = false
    if #timeEnd == 3 and CheckButtonOpen(122,true) then
        DayEndTab.year = timeEnd[1]
        DayEndTab.month = timeEnd[2]
        DayEndTab.day = timeEnd[3]
        if timeCur.year > DayEndTab.year then
            time = false
        elseif timeCur.year < DayEndTab.year then
            time = true
        elseif timeCur.month > DayEndTab.month then
            time = false
        elseif timeCur.month < DayEndTab.month then
            time = true
        elseif timeCur.month == DayEndTab.month and timeCur.day >= DayEndTab.day then
            time = false
        else
            time = true
        end
    end

    --WZLog("SceneCity:isAnniversary", CacheCenter:getGameParam().nianGifeEnd, "timeEnd", timeEnd[1], timeEnd[2], timeEnd[3], "timeCur", timeCur.year, timeCur.month, timeCur.day, "DayEndTab", DayEndTab.year, DayEndTab.month, DayEndTab.day)
    return time
end

function SceneCity:setRedPoint(btn,state,pos,scale)
    WZLog("SceneCity:setRedPoint", tostring(btn),tostring(state),tostring(pos))
    if btn == nil then return end
    pos = pos or GlobalMethod:ccp(95,45)
    if state then
        if not btn:getChildByTag(88) then
            local spr =  CCSprite:create("ui/common/common_icon_xiaodianzhui.png")
            btn:addChild(spr,5,88)
            spr:setAnchorPoint(GlobalMethod:ccp(1,1))
            spr:setPosition(pos)
            spr:setScale(scale or 1)
        end
    else
        if  btn:getChildByTag(88) then btn:removeChildByTag(88,true) end
    end
end

function SceneCity:updateRedDot(type,value,activityType,welfareType)
    local marry = GlobalGame.g_tRedPointList.marry
    local school = false --主城建筑-学校
    local community = false
    local activity = GlobalGame.g_tRedPointList.activity --活跃度
    local tower = GlobalGame.g_tRedPointList.tower
    local fund = GlobalGame.g_tRedPointList.fund
    local qualifying = false --GlobalGame.g_tRedPointList.qualifying
    local chart = GlobalGame.g_tRedPointList.chart
    local master = false --GlobalGame.g_tRedPointList.master
    local gameActivity = GlobalGame.g_tRedPointList.gameActivity --活动
    local firstRecharge = GlobalGame.g_bIsGetFirstRecharge
    local love = GlobalGame.g_tRedPointList.love
    local practice = false --GlobalGame.g_tRedPointList.practice
    local badge = GlobalGame.g_tRedPointList.badge      --徽章
    local melee = GlobalGame.g_tRedPointList.melee      --大乱斗
    local fundOpen = GlobalGame.g_tRedPointList.fundOpen
    local transaction = GlobalGame.g_tRedPointList.transaction      --交易行
    local taboo = GlobalGame.g_tRedPointList.taboo
    local shop = false
    local home = false
    local bless = false 
    local louraAct = false
	local sevenDays = false    --七天乐
    local petFetter = false     --宠物羁绊
    local pvpBuff = false       --竞技和排位buff红点
    local heroTower = false       --英雄塔
    local kidHome = false       --小孩
    local magicStone = false    --幻石系统
    local myCircle = false       --我的心情
    local magicStone = false --战令
    local phantomEquipment = false --幻化装备
    local phantomGroup = false --共生录
    local schoolApplyWaiting = false --学校申请等待
    local schoolApplyPass = false --学校申请成功
    local footBeatCard = false    --足迹打卡
    local union = false           --联盟红点

    --七夕活动
    local invite_redpoint = false
    local task_redpoint = false
    --娃娃机任务
    local dolltask_redpoint = false
    local task1_redpoint = false --每日
    local task2_redpoint = false --成长
    --首冲
    local first1_redpoint = false
    local first2_redpoint = false
    local first3_redpoint = false

    --召唤抽奖
    local lottery1_redPoint = false
    local lottery2_redPoint = false
    local lottery3_redPoint = false
    local lottery4_redPoint = false
    local lottery5_redPoint = false
    local lottery6_redPoint = false
    --坐骑灵石
    local mountstone_redpoint = false

    local dressCastSoul = false    --时装注魂红点258
    local blessBag = false    --祈福槽位红点145

    --红点类型
    if GlobalGame.g_tRedPointTypeList == nil then
        GlobalGame.g_tRedPointTypeList = {}
    end
    for i,v in pairs(GlobalGame.g_tRedPointTypeList) do
        if GlobalGame.g_tRedPointTypeList[tonumber(i)] then
            GlobalGame.g_tRedPointTypeList[tonumber(i)] = false
        end
    end
    for i,v in pairs(activityType) do --手动上架的
        GlobalGame.g_tRedPointTypeList[tonumber(v)] = true
    end
    for i, v in pairs(type) do
--        WZLog("SceneCity:updateRedDot one", i, v, value[i])
        if v == 21 then
            if value[i] ~= 0 then
                tower = true
            else
                tower = false
            end
        elseif v == 144 then
            if value[i] ~= 0 then
                bless = true
            else
                bless = false
            end
        elseif v == 218 then
            if value[i] ~= 0 then
                home = true
            else
                home = false
            end
        elseif v == 43 then
            if value[i] ~= 0 then
                shop = true
            else
                shop = false
            end
        elseif v == 34 then
            if value[i] ~= 0 then
                community = true
            else
                community = false
            end
        elseif v == 78 then
            if value[i] ~= 0 then
                activity = true
            else
                activity = false
            end
        elseif v == 89 or v == 94 then
            if value[i] ~= 0 then
                marry = true
            else
                marry = false
            end
        elseif v == 93 then
            if value[i] ~= 0 then
                master = true
            else
                master = false
            end
        elseif v == 106 then
            if value[i] ~= 0 then
                chart = true
            else
                chart = false
            end
        elseif v == 115 then
            if value[i] ~= 0 then
                fund = true
            else
                fund = false
            end
        elseif v == 118 then
            if value[i] ~= 0 then
                qualifying = true
            else
                qualifying = false
            end
        elseif v == 121 then
            if value[i] ~= 0 then
                gameActivity = true
            else
                gameActivity = false
            end
        elseif v == 125 then
            if value[i] ~= 0 then
                badge = true
            else
                badge = false
            end
        elseif v == 126 then
            if value[i] ~= 0 then
                love = true
            else
                love = false
            end
        elseif v == 142 then
            if value[i] == 0 then
                firstRecharge = false
            elseif value[i] == 1 then
                firstRecharge = true and CheckButtonShow(ISLAND_UP_FIRST_RECHARGE, true)
            elseif value[i] == 2 then
                firstRecharge = true and CheckButtonShow(ISLAND_UP_FIRST_RECHARGE, true)
            end
        elseif v == 154 then 
            if value[i] ~= 0 then 
                pvpBuff = true
            else
                pvpBuff = false
            end
        elseif v == 166 then
            if value[i] ~= 0 then
                practice = true
            else
                practice = false
            end
        elseif v == 181 then
            if value[i] ~= 0 then
                melee = true
            else
                melee = false
            end
        elseif v == 116 then
            if value[i] == 1 then
                fundOpen = true
            else
                fundOpen = false
            end
        elseif v == 200 then
            if value[i] == 1 then
                transaction = true
            else
                transaction = false
            end
        elseif v == 201 then
            if value[i] == 1 then
                taboo = true
            else
                taboo = false
            end
        elseif v == 222 then
            if value[i] ~= 0 then
                louraAct = true
            else
                louraAct = false
            end
        elseif v == 237 then
            if value[i] ~= 0 then 
                sevenDays = true
            else
                sevenDays = false
            end
        elseif v == 240 then
            if value[i] ~= 0 then 
                kidHome = true
            else
                kidHome = false 
            end
        elseif v == 246 then
            if value[i] ~= 0 then 
                petFetter = true
            else
                petFetter = false
            end
        elseif v == 247 then
            if value[i] ~= 0 then 
                heroTower = true
            else
                heroTower = false 
            end
        elseif v == 256 then
            if value[i] ~= 0 then 
                magicStone = true
            else
                magicStone = false 
            end
        elseif v == 261 then
            if value[i] ~= 0 then 
                myCircle = true
            else
                myCircle = false 
            end
        elseif v == 266 then --任务
            if value[i] ~= 0 then 
                task_redpoint = true
            else
                task_redpoint = false 
            end
        elseif v == 265 then --告白通知
            if value[i] ~= 0 then 
                invite_redpoint = true
            else
                invite_redpoint = false 
            end
        elseif v == 256 then
            if value[i] ~= 0 then
                magicStone = true
            else
                magicStone = false
            end
		elseif v == 284 then
            if value[i] ~= 0 then
                phantomEquipment = true
            end
        elseif v == 295 then
            if value[i] ~= 0 then
                phantomGroup = true
            end
		elseif v == 27010 then
            if value[i] ~= 0 then
                task2_redpoint = true
            end
        elseif v == 17010 then
            if value[i] ~= 0 then
                task1_redpoint = true
            end
        elseif v == 17012 then
            if value[i] ~= 0 then
                first1_redpoint = true
            end
        elseif v == 27012 then
            if value[i] ~= 0 then
                first2_redpoint = true
            end
        elseif v == 37012 then
            if value[i] ~= 0 then
                first3_redpoint = true
            end
        elseif v == 285 then
            if value[i] ~= 0 then
                schoolApplyWaiting = true
                school = true --主城建筑学校红点
            end
        elseif v == 286 then
            if value[i] ~= 0 then
                schoolApplyPass = true
                school = true --主城建筑学校红点
            end
        elseif v == 151 then
            if value[i] ~= 0 then
                lottery1_redPoint = true
            end
        elseif v == 64 then
            if value[i] ~= 0 then
                lottery2_redPoint = true
            end
        elseif v == 275 then
            if value[i] ~= 0 then
                lottery3_redPoint = true
            end
        elseif v == 276 then
            if value[i] ~= 0 then
                lottery4_redPoint = true
            end
        elseif v == 277 then
            if value[i] ~= 0 then
                lottery5_redPoint = true
            end
        elseif v == 278 then
            if value[i] ~= 0 then
                mountstone_redpoint = true
            end
        elseif v == 258 then
            if value[i] ~= 0 then
                dressCastSoul = true
            end
        elseif v == 145 then
            if value[i] ~= 0 then
                blessBag = true
            end
        elseif v == 303 then 
            if value[i] ~= 0 then 
                footBeatCard = true 
            end
        elseif v == 304 then 
            if value[i] ~= 0 then 
                lottery6_redPoint = true 
            end
        elseif v == 305 then 
            if value[i] ~= 0 then 
                union = true 
            end
        else
            local status = false
            if value[i] ~= 0 then
                status = true
            end
            --任务红点：100000 + 任务类型*10000 + 活动类型
            GlobalGame.g_tRedPointTypeList[tonumber(v)] = status
        end
    end
    -- WZTempLog("********** 红点协议 ************")
    -- dump(GlobalGame.g_tRedPointTypeList)

    GlobalGame.g_tRedPointList.community = community
    GlobalGame.g_tRedPointList.marry = marry
    GlobalGame.g_tRedPointList.school = school
    GlobalGame.g_tRedPointList.activity = activity
    GlobalGame.g_tRedPointList.tower = tower
    GlobalGame.g_tRedPointList.fund = fund
    GlobalGame.g_tRedPointList.qualifying = qualifying
    GlobalGame.g_tRedPointList.chart = chart
    GlobalGame.g_tRedPointList.master = master
    GlobalGame.g_tRedPointList.gameActivity = gameActivity
    GlobalGame.g_tRedPointList.love = love
    GlobalGame.g_tRedPointList.practice = practice
    GlobalGame.g_tRedPointList.badge = badge
    GlobalGame.g_tRedPointList.melee = melee
    GlobalGame.g_tRedPointList.fundOpen = fundOpen
    GlobalGame.g_tRedPointList.transaction = transaction
    GlobalGame.g_tRedPointList.taboo = taboo
    GlobalGame.g_tRedPointList.shop = shop
    GlobalGame.g_tRedPointList.home = home
    bless = bless and CheckButtonOpen(ISLAND_UP_BLESS, false)
    GlobalGame.g_tRedPointList.bless = bless
    GlobalGame.g_tRedPointList.petFetter = petFetter
    GlobalGame.g_tRedPointList.pvpBuff = pvpBuff
    GlobalGame.g_tRedPointList.heroTower = heroTower
    GlobalGame.g_tRedPointList.kidHome = kidHome
    GlobalGame.g_tRedPointList.magicStone = magicStone
    GlobalGame.g_tRedPointList.myCircle = myCircle
    GlobalGame.g_tRedPointList.invite_redpoint = invite_redpoint
    GlobalGame.g_tRedPointList.task_redpoint = task_redpoint
    GlobalGame.g_tRedPointList.magicStone = magicStone
	GlobalGame.g_tRedPointList.phantomEquipment = phantomEquipment
    GlobalGame.g_tRedPointList.phantomGroup = phantomGroup

	GlobalGame.g_tRedPointList.task1_redpoint = task1_redpoint
    GlobalGame.g_tRedPointList.task2_redpoint = task2_redpoint

    GlobalGame.g_tRedPointList.first1_redpoint = first1_redpoint
    GlobalGame.g_tRedPointList.first2_redpoint = first2_redpoint
    GlobalGame.g_tRedPointList.first3_redpoint = first3_redpoint

    GlobalGame.g_tRedPointList.schoolApplyWaiting = schoolApplyWaiting
    GlobalGame.g_tRedPointList.schoolApplyPass = schoolApplyPass
    GlobalGame.g_tRedPointList.lottery1_redPoint = lottery1_redPoint
    GlobalGame.g_tRedPointList.lottery2_redPoint = lottery2_redPoint
    GlobalGame.g_tRedPointList.lottery3_redPoint = lottery3_redPoint
    GlobalGame.g_tRedPointList.lottery4_redPoint = lottery4_redPoint
    GlobalGame.g_tRedPointList.lottery5_redPoint = lottery5_redPoint
    GlobalGame.g_tRedPointList.lottery6_redPoint = lottery6_redPoint
    GlobalGame.g_tRedPointList.mountstone_redpoint = mountstone_redpoint
    GlobalGame.g_tRedPointList.footBeatCard = footBeatCard
    GlobalGame.g_tRedPointList.union = union

    if judgeHavedRecordString(LocalStrings.KID_TEXT69, false) then 
        kidHome = false 
        GlobalGame.g_tRedPointList.kidHome = kidHome
    end
    
    if WndOwnCity.updateFundOpen then
        WndOwnCity:updateFundOpen(GlobalGame.g_tRedPointList.fundOpen)
    end
	--代言人活动
--	WndApartmentAct:setRed2(GlobalGame.g_tRedPointList.louraAct)

    CacheCenter:setRedState("btnPractice_ExtendUp",practice,55)
    GlobalGame:getBtnRedPointEvent():dispatcher()

    WZLog("SceneCity:updateRedDot two", tostring(firstRecharge), tostring(practice), tostring(SceneCity.m_root), tostring(community), tostring(marry), tostring(activity), tostring(tower), tostring(qualifying), tostring(badge), tostring(school))

    GlobalGame.g_bIsGetFirstRecharge = firstRecharge
    
    if WndOwnCity.updateFirstRecharge then
        WndOwnCity:updateFirstRecharge(firstRecharge)
    end
    SceneCity:updateRedDotBuilding("summer", WndSumVacAct:bShowRedPoint())

    WZLog("SceneCity:updateRedDot three", tostring(WndOwnCity.m_nIndex), GlobalGame.g_bIsGetFirstRecharge, tostring(gameActivity), tostring(isFirstRecharge))
    if WndDesignationMain then
        if badge then
            CacheCenter:setRedState("btnBag",true)
            GlobalGame:getBtnRedPointEvent():dispatcher()
        end
        WndDesignationMain:showRedPointBadge(badge)
    end
    if WndDigGem then
        WndDigGem:showRedDot(GlobalGame.g_tRedPointList.transaction)
    end
    
    --孩子学校红点
    SceneKidSchoolHome:updateRedDot()
    GlobalGame:getGameEventDispathcer():Dispatch(Independent_Activity.ActivityReddot)

    if SceneCity.m_root == nil then
        return
    end

    WndSummonEntrance:updateRedPoint1(lottery1_redPoint, lottery2_redPoint, lottery3_redPoint, lottery4_redPoint,lottery5_redPoint,lottery6_redPoint)
    
    self:updateZhaohuanRedDot(lottery1_redPoint, lottery2_redPoint, lottery3_redPoint, lottery4_redPoint,lottery6_redPoint)
    self:updateRedDotBuilding("home", home)
    self:updateRedDotBuilding("shop", shop)
    self:updateRedDotBuilding("anniversary", #CacheCenter.m_tYearActivityItemRedDotList > 0, GlobalMethod:ccp(130,45))
    self:updateRedDotBuilding("marry", marry)
    self:updateRedDotBuilding("school", school or kidHome)
    local bCommunity = community or GlobalGame.g_bIsGuildWarHaveRedDot
    WZLog("HHHHHHHHHHHHHHHHHHH ", #CacheCenter.m_tYearActivityItemRedDotList, tostring(community), tostring(GlobalGame.g_bIsGuildWarHaveRedDot))
    self:updateRedDotBuilding("community", bCommunity)
   
    self:updateRedDotBuilding("taboo", taboo, GlobalMethod:ccp(100,40))
    self:updateRedDotBuilding("tower", tower, GlobalMethod:ccp(100,40))
    self:updateRedDotBuilding("chart", chart, GlobalMethod:ccp(155,37))
    self:updateRedDotBuilding("heroTower", heroTower, GlobalMethod:ccp(100,40))

    local masterInfo = CacheCenter:getMasterInfo()
    if masterInfo and masterInfo.taskfinish == 1 or GlobalGame.g_tRedPointTypeList[300] or GlobalGame.g_tRedPointTypeList[301] or GlobalGame.g_tRedPointTypeList[302] then
        master = true
    end
    self:updateRedDotBuilding("master", master, GlobalMethod:ccp(150,308), 1/0.6)

    local btn = GetElementWithoutAssert(self.m_root, "btn68_WndOwnCity", WZUIButton)
    WZLog("SceneCity:updateRedDot four", tostring(btn), tostring(qualifying))
    if btn then
        if qualifying or GlobalGame.g_bIsGuildWarHaveRedDot then
            SceneCity:setRedPoint(btn,true,GlobalMethod:ccp(73,73))
        else
            SceneCity:setRedPoint(btn,false)
        end
    end

    local btn = GetElementWithoutAssert(self.m_root, "btn61_WndOwnCity", WZUIButton)
    if btn then
        if love then
            SceneCity:setRedPoint(btn,true,GlobalMethod:ccp(73,73))
        else
            SceneCity:setRedPoint(btn,false)
        end
    end

	--首充按钮
	WZLog("首充红点",firstRecharge)
    local btn = GetElementWithoutAssert(self.m_root, "btn"..ISLAND_UP_FIRST_RECHARGE.."_WndOwnCity", WZUIButton)
    if btn then
        if firstRecharge then
            SceneCity:setRedPoint(btn,true,GlobalMethod:ccp(73,73))
        else
            SceneCity:setRedPoint(btn,false)
        end
    end

	--福利按钮
    local btn = GetElementWithoutAssert(self.m_root, "btn"..ISLAND_UP_WELFARE.."_WndOwnCity", WZUIButton)
    if btn then
    	if #CacheCenter.m_tWelfareItemRedDotList > 0 or CacheCenter:getPlayerItemCountById(116) >= 10 or (WndOwnCity.m_bIsClickWelfare == nil and WndGangsterInn.m_bOpen == true) then 
            SceneCity:setRedPoint(btn,true,GlobalMethod:ccp(73,73))
        else
            SceneCity:setRedPoint(btn,false)
        end
    end
    --回流活动红点
    local btnBack = GetElementWithoutAssert(self.m_root, "btn"..ISLAND_UP_BACK_ACTIVITY.."_WndOwnCity", WZUIButton)
    if btnBack then 
        SceneCity:setRedPoint(btnBack, #CacheCenter.m_tBackActivityRedDotList > 0, GlobalMethod:ccp(73,73))
    end
    
    if GlobalGame.g_tRedPointList.eliteShop then
        SceneCity:updateRedDotBuilding("eliteShop", true)
    end

    if GlobalGame.g_tRedPointList.help then
        SceneCity:updateRedDotBuilding("help", true)
    end

    if #CacheCenter.m_tApartmentRedDotList > 0 then
        SceneCity:updateRedDotBuilding("louyixiao", true)
    else
        SceneCity:updateRedDotBuilding("louyixiao", false)
    end

    if GlobalGame.g_tRedPointList.share then
        SceneCity:updateRedDotBuilding("share", true)
    end

    if GlobalGame.g_tRedPointList.pray then
        SceneCity:updateRedDotBuilding("pray", true)
    end

    --时装注魂红点
    CacheCenter:setRedState("btnCastSoul",dressCastSoul)
    --祈福背包红点
    CacheCenter:setRedState("btnBlessBag",blessBag)
    WndBagMain:setBlessBagRed(CacheCenter:getRedState("btnBlessBag"))
    --联盟红点
    CacheCenter:setRedState("btnUnion",union)

    CacheCenter:updateRedPoint("right", self.m_tWndBottomBar, nil)

    --七天乐
    local btn = GetElementWithoutAssert(self.m_root, "btn" .. ISLAND_UP_SEVEN_DAY .. "_WndOwnCity", WZUIButton)
    if sevenDays then 
        SceneCity:setRedPoint(btn,true,GlobalMethod:ccp(73,73))
    else
        SceneCity:setRedPoint(btn,false)
    end
    --幻石
    local btn = GetElementWithoutAssert(self.m_root, "btn" .. ISLAND_UP_MAGIC_STONE .. "_WndOwnCity", WZUIButton)
    if GlobalGame.g_tRedPointList.magicStone then
        SceneCity:setRedPoint(btn,true,GlobalMethod:ccp(73,73))
    else
        SceneCity:setRedPoint(btn,false)
    end
    --投资返利
    local btnInvest = GetElementWithoutAssert(self.m_root, "btn" .. ISLAND_UP_INVESTREBATE .. "_WndOwnCity", WZUIButton)
    if GlobalGame.g_tRedPointList.investRebate then 
        SceneCity:setRedPoint(btnInvest,true,GlobalMethod:ccp(73,73))
    else
        SceneCity:setRedPoint(btnInvest,false)
    end
    --全民摇摇乐
    local btnShake = GetElementWithoutAssert(self.m_root, "btn" .. ISLAND_UP_HAPPYSHAKE .. "_WndOwnCity", WZUIButton)
    if GlobalGame.g_tRedPointList.happyShake then 
        SceneCity:setRedPoint(btnShake,true,GlobalMethod:ccp(73,73))
    else
        SceneCity:setRedPoint(btnShake,false)
    end
    --一元冲
    local btnOneYuan = GetElementWithoutAssert(self.m_root, "btn" .. ISLAND_UP_ONE_YUAN .. "_WndOwnCity", WZUIButton)
    if GlobalGame.g_tRedPointList.oneYuanRecharge then 
        SceneCity:setRedPoint(btnOneYuan,true,GlobalMethod:ccp(73,73))
    else
        SceneCity:setRedPoint(btnOneYuan,false)
    end
    --七夕活動********************************
    local btnDoubleSeven = GetElementWithoutAssert(self.m_root, "btn" .. DOUBLE_SEVEN_CONFREE .. "_WndOwnCity", WZUIButton)
    local is_visible = GlobalGame.g_tRedPointList.qixiActivity or GlobalGame.g_tRedPointList.invite_redpoint or GlobalGame.g_tRedPointList.task_redpoint
    if is_visible then 
        SceneCity:setRedPoint(btnDoubleSeven,true,GlobalMethod:ccp(73,73))
    else
        SceneCity:setRedPoint(btnDoubleSeven,false)
    end
    --战令
    self:setSceneMainIconRedPoint(ISLAND_UP_MAGIC_STONE, GlobalGame.g_tRedPointList.magicStone)
    --国庆签到
    self:setSceneMainIconRedPoint(NATIONAL_FESTIVAL, GlobalGame.g_tRedPointList.FestivalLoginActivity)
    --答题
    self:setSceneMainIconRedPoint(NATIONAL_ANSWER, GlobalGame.g_tRedPointList.FestivalAnswerActivity)
    --全民购物
    self:setSceneMainIconRedPoint(PEOPLESHOP, GlobalGame.g_tRedPointList.PeopleShopActivity)
    --寻宝界面
    self:setSceneMainIconRedPoint(TREASURESEARCH, GlobalGame.g_tRedPointList.treasureMainRedPoint)
    --每日必购
    self:setSceneMainIconRedPoint(EVERYDAYBUY, GlobalGame.g_tRedPointList.everyDayBuyRedPoint)
    --元旦
    self:setSceneMainIconRedPoint(NEWYEARDAY, GlobalGame.g_tRedPointList.newyearRedPoint)
    --新年活动
    local redpoint_status = WndNewYearActivityMain:getRedPointStatus()
    self:setSceneMainIconRedPoint(FEBRUARYNEWYEAR, redpoint_status)
    --四象星宿
    self:setSceneMainIconRedPoint(FOURSTARS, GlobalGame.g_tRedPointList.fourStarRedPoint)
    --盲盒
    self:setSceneMainIconRedPoint(BLINDBOX, GlobalGame.g_tRedPointList.blindRedPoint)
    --娃娃机
    self:setSceneMainIconRedPoint(DOLLMACHINE, GlobalGame.g_tRedPointList.dollMachineRedPoint)
    --战力飞升
    self:setSceneMainIconRedPoint(FIGHT_ACTIVITY, GlobalGame.g_tRedPointTypeList[127018] or GlobalGame.g_tRedPointTypeList[117018])
    --崛起之路
    self:setSceneMainIconRedPoint(RISE_ACTIVITY, GlobalGame.g_tRedPointTypeList[7019])
    local red_point = GlobalGame.g_tRedPointTypeList[117023] or GlobalGame.g_tRedPointTypeList[127023] or GlobalGame.g_tRedPointTypeList[17023]
    self:setSceneMainIconRedPoint(HORARY_ACTIVITY, red_point)
    --中秋活动
    local red_point1 = GlobalGame.g_tRedPointTypeList[7025] or GlobalGame.g_tRedPointTypeList[7026] or GlobalGame.g_tRedPointTypeList[7027]
    self:setSceneMainIconRedPoint(MIDFESTIVAL_ACTIVITY, red_point1)
    --钓鱼
    local red_point2 = GlobalGame.g_tRedPointTypeList[127024] or GlobalGame.g_tRedPointTypeList[117024]
    self:setSceneMainIconRedPoint(FISH_ACTIVITY, red_point2)
    --弹珠活动
    local red_point3 = GlobalGame.g_tRedPointTypeList[127028] or GlobalGame.g_tRedPointTypeList[27028] or GlobalGame.g_tRedPointTypeList[37028]
    self:setSceneMainIconRedPoint(PELLET_ACTIVITY, red_point3)
    --房产活动
    local red_point4 = GlobalGame.g_tRedPointTypeList[7029] or GlobalGame.g_tRedPointTypeList[27029] or GlobalGame.g_tRedPointTypeList[17029]
    self:setSceneMainIconRedPoint(HOUSEINVEST_ACTIVITY, red_point4)
    --限时登录
    self:setSceneMainIconRedPoint(ACTIVITYLIMITLOGIN, GlobalGame.g_tRedPointList.limitLoginRedPoint)
    --首冲
    self:setSceneMainIconRedPoint(ACTIVITYNEWRECHARGE, GlobalGame.g_tRedPointList.firstRedPoint)
    --回归活动
    local redpoint_status1 = WndReturnActivityMain:getReturnRedPointStatus()
    self:setSceneMainIconRedPoint(REBACKACTIVITY, redpoint_status1)
    --OV琥珀大玩家    
    local btnOPPOAmberPlayer = GetElementWithoutAssert(self.m_root, "btn" .. ISLAND_UP_OPPO_AMBERPLAYER .. "_WndOwnCity", WZUIButton)
    local m_bIsShowRedDot_OV = false
    if #CacheCenter.m_tActivityItemRedDotList > 0 then
        for idx=1,#CacheCenter.m_tActivityItemRedDotList do
            -- WZLog("WndActivityIntegrate:setRedDot=============get RedDot List============="..idx..CacheCenter.m_tActivityItemRedDotList[idx])
            local redDot = CacheCenter.m_tActivityItemRedDotList[idx]
            if redDot == g_tGameActivityTypes.ACTIVITY_OPPO_BIGVIP_WELFARE or redDot == g_tGameActivityTypes.ACTIVITY_OPPO_BIGVIP_SIGNIN or redDot == g_tGameActivityTypes.ACTIVITY_OPPO_BIGVIP_RECHARGE then 
                m_bIsShowRedDot_OV = true
                break
            end 
        end
    end
    if btnOPPOAmberPlayer and m_bIsShowRedDot_OV then 
        SceneCity:setRedPoint(btnOPPOAmberPlayer,true,GlobalMethod:ccp(73,73))
    else
        SceneCity:setRedPoint(btnOPPOAmberPlayer,false)
    end
    --射箭赛事
    self:setSceneMainIconRedPoint(ACTIVITY_SHOOT_ARROW, GlobalGame.g_tRedPointList.redDot_7020)
    --蓝钻特权
    self:setSceneMainIconRedPoint(BLUEPRIVILEGE_ACTIVITY, #CacheCenter.m_tActivityBluePriRedDotList > 0)
    --大厅特权
    self:setSceneMainIconRedPoint(QQHALLPRIVILEGE_ACTIVITY, #CacheCenter.m_tActivityHallPriRedDotList > 0)
    --独立活动红点
    -- for i = 1, #g_tAloneActivity do
    for i = 1, GetTableLen(g_tAloneActivity) do
        if g_tAloneActivity[i] then
            self:setSceneMainIconRedPoint(g_tAloneActivity[i], GlobalGame.g_tRedPointTypeList[g_tAloneActivity[i]])
        end
    end
    --8周年庆典
    local red_eightYear = GlobalGame.g_tRedPointTypeList[7120] or GlobalGame.g_tRedPointTypeList[7121] or GlobalGame.g_tRedPointTypeList[7122] or GlobalGame.g_tRedPointTypeList[7123]
    self:setSceneMainIconRedPoint(EIGHTYEAR_ACTIVITY, red_eightYear)
    --********************************************************************
    --周一卡
    local btnMondayCard = GetElementWithoutAssert(self.m_root, "btn" .. ISLAND_UP_CARD_WELFARE .. "_WndOwnCity", WZUIButton)
    if #CacheCenter.m_tFreecaRedDotList>0 then 
        SceneCity:setRedPoint(btnMondayCard,true,GlobalMethod:ccp(73,73))
    else
        WndActivityIntegrate:setRedDot()
    end
    --疯狂翻倍
    local btnCrazyDoubling = GetElementWithoutAssert(self.m_root, "btn" .. ISLAND_UP_CRAZY_DOUBLING .. "_WndOwnCity", WZUIButton)
    if GlobalGame.g_tRedPointList.crazyDoubling then 
        SceneCity:setRedPoint(btnCrazyDoubling,true,GlobalMethod:ccp(73,73))
    else
        SceneCity:setRedPoint(btnCrazyDoubling,false)
    end
    --好友圈
    if GlobalGame.g_tRedPointList.myCircle then
        CacheCenter:addMark("btnFriend_WndOwnCity", 1)
    elseif not GlobalGame.g_tRedPointList.myCircle and CacheCenter.m_nDailyMark == 0 and CacheCenter.m_nInviteMark == 0 then 
        CacheCenter:addMark("btnFriend_WndOwnCity", 0)
    end
end

function SceneCity:setSceneMainIconRedPoint(id, visible)
    local btn_icon = GetElementWithoutAssert(self.m_root, "btn" .. id .. "_WndOwnCity", WZUIButton)
    local is_visible = visible or false
    if is_visible then 
        SceneCity:setRedPoint(btn_icon,true,GlobalMethod:ccp(73,73))
    else
        SceneCity:setRedPoint(btn_icon,false)
    end
end

function SceneCity:updateZhaohuanRedDot(red1,red2,red3,red4,red6)
    -- body
    if self.m_root == nil then return end 

    WZLog("SceneCity:updateZhaohuanRedDot",red1,red2,red3,red4,red6)
    local btnName = GetElementWithoutAssert(self.m_root, "building11" , WZUIImage)
    if red1 or red2 or red3 or red4 or red6 then   
        self:setRedPoint(btnName, true, GlobalMethod:ccp(100,40), 1)
    else 
        self:setRedPoint(btnName, false, GlobalMethod:ccp(100,40), 1)
    end        
end

--更新建筑红点
function SceneCity:updateRedDotBuilding(name, state, pos, scale)

    local btnIndex
    local isNpc
    if name == "marry" then
        btnIndex = "building8"
    elseif name == "school" then
        btnIndex = "building145"
    elseif name == "shop" then
        btnIndex = "building7"
    elseif name == "home" then
        btnIndex = "building131"
        pos = GlobalMethod:ccp(150,45)
    elseif name == "community" then
        btnIndex = "building9"
    elseif name == "singleMap" then
        btnIndex = "building2"
    elseif name == "tower" or name == "heroTower" or name == "taboo" then
        btnIndex = "building3"
    elseif name == "chart" then
        btnIndex = "building4"
    elseif name == "master" then
        btnIndex = 2
        isNpc = true
    elseif name == "DigGem" then
        btnIndex = "building114"
    elseif name == "anniversary" then
        btnIndex = "building122"
    elseif name == "summer" then
        btnIndex = "building127"
        pos = GlobalMethod:ccp(150,45)
    elseif name == "louyixiao" then
        btnIndex = "building132"
        pos = GlobalMethod:ccp(130,45)
    elseif name == "eliteShop" then
        btnIndex = "103"
        pos = GlobalMethod:ccp(83,83)
    elseif name == "pray" then
        btnIndex = "138"
        pos = GlobalMethod:ccp(83,83)
    elseif name == "help" then
        btnIndex = "Helper"
        pos = GlobalMethod:ccp(60,60)
    elseif name == "share" then
        btnIndex = "Share"
        pos = GlobalMethod:ccp(70,70)
    end
    --公会的，如果公会战有红点，会造成大厅也有红点的bug, 如果入口红点又多个部分的红点组合，则这里要加限制
    if state == true and name ~= "marry" and name ~= "community" then
        GlobalGame.g_tRedPointList[name] = true
    elseif state ~= true then
        GlobalGame.g_tRedPointList[name] = nil
    end
    if name == "tower" or name == "heroTower" or name == "taboo" then
        if GlobalGame.g_tRedPointList.tower or GlobalGame.g_tRedPointList.heroTower or GlobalGame.g_tRedPointList.taboo then 
            state = true
        end
    end

    WZLog("SceneCity:updateRedDotBuilding one-1", name, state, self.m_root, self.m_tWndBottomBarObj and self.m_tWndBottomBarObj.m_root)
    if self.m_root and isNpc == nil then 
        if (name == "eliteShop" or name == "pray") and WndOwnCity.m_root then
            local btnName = GetElement(WndOwnCity.m_root, "con" .. btnIndex .. "_WndOwnCity", WZUIContainer)
            if btnName then
                self:setRedPoint(btnName, state, pos, scale)
            end
            return
        elseif name == "share" and self.m_tWndBottomBarObj and self.m_tWndBottomBarObj.m_root then
            local btnName = GetElement(self.m_tWndBottomBarObj.m_root, "btn"..btnIndex.."_WndBottomBar", WZUIButton)
            WZLog("SceneCity:updateRedDotBuilding three", btnName)
            if btnName then
                self:setRedPoint(btnName, state, pos, scale)
            end
            return
        elseif name == "help" and self.m_tWndBottomBarObj and self.m_tWndBottomBarObj.m_root then
            local btnName = GetElement(self.m_tWndBottomBarObj.m_root, "btn"..btnIndex.."_WndBottomBar", WZUIButton)
            WZLog("SceneCity:updateRedDotBuilding three", btnName)
            if btnName then
                self:setRedPoint(btnName, state, pos, scale)
            end
            return

        -- elseif name == "lottery1_redPoint" then
        --     state = GlobalGame.g_tRedPointList["lottery1_redPoint"]
        -- elseif name == "lottery2_redPoint" then
        --     state = GlobalGame.g_tRedPointList["lottery2_redPoint"]
        -- elseif name == "lottery3_redPoint" then
        --     state = GlobalGame.g_tRedPointList["lottery3_redPoint"]
        -- elseif name == "lottery4_redPoint" then
        --     state = GlobalGame.g_tRedPointList["lottery4_redPoint"]
        -- elseif name == "lottery1_redPoint" or name == "lottery2_redPoint" or name == "lottery3_redPoint" or name == "lottery4_redPoint" then
        --     state = GlobalGame.g_tRedPointList["lottery1_redPoint"] or GlobalGame.g_tRedPointList["lottery2_redPoint"] or GlobalGame.g_tRedPointList["lottery3_redPoint"] or GlobalGame.g_tRedPointList["lottery4_redPoint"]
        end

        local btnName = GetElementWithoutAssert(self.m_root, btnIndex , WZUIImage)
        self:setRedPoint(btnName, state, pos, scale)
        --WZLog("SceneCity:updateRedDotBuilding one-2", btnIndex, btnName)
    elseif isNpc then
        if btnIndex == 2 and self.m_root then 
            if name == "master" and self.m_tWndBottomBarObj and self.m_tWndBottomBarObj.m_root then
                local btnName = GetElement(self.m_tWndBottomBarObj.m_root, "btnMaster_WndBottomBar", WZUIButton)
                btnName:setVisible(false)
                WZLog("SceneCity:updateRedDotBuilding four", btnName, state)
                if btnName then
                    self:setRedPoint(btnName, state, GlobalMethod:ccp(60,60))
                end
            end
        end
        local npc
        for i = #FigureSceneManager:getInstance().m_tFigureList, 1, -1 do
            local figure = FigureSceneManager:getInstance().m_tFigureList[i]
            if figure.m_nFigureType == FigureType.Npc and btnIndex == figure.m_nAnimId then
                WZLog("SceneCity:updateRedDotBuilding two", btnIndex)
                self:setRedPoint(figure.m_anim:getAnimNode(), state, pos, scale)
                break
            end
        end
    end
end

--@brief	往场景根节点添加元素的方法
--@param	element:要添加的界面元素引用
--@note		这里会修改showAll属性，为了适配不同分辨率，保证界面元素不会变形
--          注: 对于主场景showAll属性已经是true的时候不用修改元素的showAll
--          小岛界面有特殊需求，所以showAll属性为false，需要修改里面元素的showAll属性
function SceneCity:addChild(element)
    if self.m_root == nil or element == nil then
        return
    end
    --element:setShowAll(true)
    self.m_root:addChild(element)
end

--@brief	点击回调
function SceneCity:onBuildClickNotice(element)
    --WZLog("SceneCity:onBuildClickNotice",element:getTag())
    do return end
    self.m_nClickBtnTag = element:getTag()

    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    if CheckButtonOpen(ISLAND_BUILDING_ACTIVITIES) then
        local wndActivityElement = wndActivityOnLine:createElement()
        if wndActivityElement ~= nil then
            WindowManager:addWindow(wndActivityElement,wndActivityOnLine,nil,false)
        end
    end
end

--@brief    点击逃杀回调
function SceneCity:onBuildClickFledKill(element)
    WZLog("SceneCity:onBuildClickFledKill", GlobalGame:getEscapeInfo())
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    SceneAthMelee:showInterface(2)
end

--@brief	点击回调
function SceneCity:onBuildClickRanking(element)
    --WZLog("SceneCity:onBuildClickRanking",element:getTag())
    self.m_nClickBtnTag = element:getTag()

    TeachGroup1:endTeachStep({16,1})
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    if CheckButtonOpen(ISLAND_BUILDING_RANK) then
        CheckLuaLoad(LUAFILES_BLOCK_COMMON)
        CheckLuaLoad(Chat_Channel_Ranking)
        PostPlayerEvent:postEvent(PostPlayerEvent.event_tenLvClickRank)

       WndRankList:showInterface(59)
    end
end

--@brief 更新小屋建筑是否显示
function SceneCity:updateKidHomeState()
    WZLog("SceneCity:updateKidHomeState")
    local school = GetElement(self.m_root, "con_building145_SceneCity", WZUIContainer)
    if school == nil then
        return
    end
    if CheckButtonShow(ISLAND_BUILDING_KID) then  
        school:setVisible(true)
    else
        school:setVisible(false)
    end
end

--@brief 跳转到学校
function SceneCity:onBuildClickKid(element)
    WZLog("SceneCity:onBuildClickKid")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    -- body
    if CheckButtonOpen(ISLAND_BUILDING_KID) then 
        if SceneCommunityKnockout.m_root ~= nil then
            MsgBoxManager:showTipBox(LocalStrings.CHECKOTHER_NEWTEXT6)
            return
        end
        if SceneCommunityWar.m_root ~= nil then
            MsgBoxManager:showTipBox(LocalStrings.CHECKOTHER_NEWTEXT6)
            return
        end

        if GlobalGame.g_bIfInBattle == true then
            MsgBoxManager:showTipBox(LocalStrings.CHECKOTHER_NEWTEXT5)
            return
        end
        SceneKidHome:showInterface()
    end
end

--@brief	点击回调
function SceneCity:onBuildClickConquer(element)
    --WZLog("SceneCity:onBuildClickConquer",element:getTag())
    self.m_nClickBtnTag = element:getTag()
    
    TeachGroup1:endTeachStep({14,1},{28,1},{49,1},{13,1})
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    local isTeach = (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 15 and TeachGroup1.STEP == 1) or (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 29 and TeachGroup1.STEP == 1)
    
    if isTeach ~= true and CheckButtonOpen(ISLAND_BUILDING_DAILYMAP) then
        WndChallengeEntrance:showInterface()
    end
end

--@brief	点击回调
function SceneCity:onBuildClickBossMap(element)
    --WZLog("SceneCity:onBuildClickBossMap",element:getTag())
    
    self.m_nClickBtnTag = element:getTag()

    TeachGroup1:endTeachStep({15,1})
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    local isTeach = (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 17 and TeachGroup1.STEP == 1) or (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 29 and TeachGroup1.STEP == 1)
    if CheckButtonOpen(ISLAND_BUILDING_BOSSMAP) and isTeach ~= true then
                SceneCopy:showScene(2)
    end
end

--@brief	点击回调
function SceneCity:onBuildClickHall(element)
    --WZLog("SceneCity:onBuildClickHall",element:getTag())
    self.m_nClickBtnTag = element:getTag()

    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    TeachGroup1:endTeachStep({20,1},{48,1})
    local isTeach = TeachGroup1.ISTEACH == true and (TeachGroup1.GROUP == 13 and TeachGroup1.STEP == 1 or TeachGroup1.GROUP == 41 and TeachGroup1.STEP == 1)

    if CheckButtonOpen(ISLAND_BUILDING_HALL) and isTeach ~= true then
        CheckLuaLoad(LUAFILES_BLOCK_COMMON)
        CheckLuaLoad(Chat_Channel_Hall)
        g_areaIndex = 1
        --replaceScene(SceneHall:createElement())
        PostPlayerEvent:postEvent(PostPlayerEvent.event_eightLvClickHallBuilding)
		ScenePvp:showScene()
    end
end

--@brief	点击回调
function SceneCity:onBuildClickResearch(element)
    --WZLog("SceneCity:onBuildClickResearch",element:getTag())
    self.m_nClickBtnTag = element:getTag()

    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    if CheckButtonOpen(ISLAND_BUILDING_STRENGTHEN) then
        --检测加载公共模块所需lua文件
        CheckLuaLoad(LUAFILES_BLOCK_COMMON)
        CheckLuaLoad(Chat_CHannel_Strengthen)
        CheckLuaLoad(Chat_CHannel_Shop)

        local wndStrengthen = WndStrengthen:createElement()
        if wndStrengthen ~= nil then
            WindowManager:addWindow(wndStrengthen, WndStrengthen, false)
        end
    end

end

--@brief	点击回调
function SceneCity:onBuildClickShop(element)
    self.m_nClickBtnTag = element:getTag()

    TeachGroup1:endTeachStep({26,2})

    local isEndTeach26, teachStep26 = TeachGroup1:isTeachFinish(26)
    if teachStep26 >= 5 then
        TeachGroup1:setTeachFinish(26, -1)
        TeachGroup1:removeTeach()
    end

    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    local isTeach = TeachGroup1.ISTEACH == true and (TeachGroup1.GROUP == 41 and TeachGroup1.STEP == 1 or TeachGroup1.GROUP == 24 and TeachGroup1.STEP == 1)

    if isTeach ~= true and CheckButtonOpen(ISLAND_BUILDING_SHOP) then
        CheckLuaLoad(LUAFILES_BLOCK_COMMON)
        CheckLuaLoad(Chat_CHannel_Shop)
        PostPlayerEvent:postEvent(PostPlayerEvent.event_tenLvClickShop)
        
        WZLog("SceneCity:onBuildClickShop", tostring(GlobalGame.g_tRedPointList.shop))
        if GlobalGame.g_tRedPointList.shop then
            WndShop:jumpTab(7, 3)
        else
            WndShop.startTime = WZThread:getUTickCount()
            local wndShop = WndShop:createElement()
			WndShop.jumpMain = nil
			WndShop.jumpSub = nil
			WindowManager:addWindow(wndShop, WndShop)
        end
    end

end

--@brief	点击回调
function SceneCity:onBuildClickPet(element)
    --WZLog("SceneCity:onBuildClickPet",element:getTag())
    self.m_nClickBtnTag = element:getTag()

    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    if CheckButtonOpen(ISLAND_BUILDING_PET) then
        local index = 4
        local isMove = true
        WZLog("点击宠物乐园按钮后的响应方法:::",GlobalGame.g_bIfInTeaching)
        if GlobalGame.g_bIfInTeaching == true then
            index = 2
            isMove = false
        end
        CheckLuaLoad(LUAFILES_BLOCK_COMMON)
        CheckLuaLoad(Chat_Channel_Pet)
        replaceScene(ScenePets:createElement())
    end

end

--@brief	点击回调
function SceneCity:onBuildClickGuild(element)
    --WZLog("SceneCity:onBuildClickGuild",element:getTag())
    self.m_nClickBtnTag = element:getTag()

    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    TeachGroup1:endTeachStep({23,1})
    if CheckButtonOpen(ISLAND_BUILDING_COMMUNITY) then
        CheckLuaLoad(LUAFILES_BLOCK_COMMON)
        CheckLuaLoad(Chat_Channel_Community)
        SceneCommunity:onJumpToCommunity()
    end

end

--@brief	点击回调
function SceneCity:onBuildClickMarry(element)
    --WZLog("SceneCity:onBuildClickMarry",element:getTag())
    self.m_nClickBtnTag = element:getTag()

    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    TeachGroup1:endTeachStep({24,1})
    CheckLuaLoad(LUAFILES_BLOCK_COMMON)
    CheckLuaLoad(Chat_Channel_MarryChoice)
    WndMarryManager:initManager(2)
    WndMarryManager:createLoading()
end

--@brief    点击回调
function SceneCity:onBuildClickDigGem(element)
    --WZLog("SceneCity:onBuildClickMarry",element:getTag())
    self.m_nClickBtnTag = element:getTag()

    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    WndDigGem:showInterface()
end

--@brief    点击家园回调
function SceneCity:onBuildClickHome(element)
    WZLog("SceneCity:onBuildClickHome")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    if CheckButtonOpen(ISLAND_BUILDING_HOME) then
        if CacheCenter:getPlayerInfo().homeLevel < 1 then 
            WndCreateFamily:showInterface()
        else   --已创建则直接进入家园
            --进入家园场景
            SceneFamily:showInterface()
        end
    end
end

--@brief	点击回调
function SceneCity:onBuildClickUnknown1(element)
    --WZLog("SceneCity:onBuildClickUnknown1",element:getTag())
    self.m_nClickBtnTag = element:getTag()

    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

end

--@brief	点击回调
function SceneCity:onBuildClickUnknown2(element)
    --WZLog("SceneCity:onBuildClickUnknown2",element:getTag())
    self.m_nClickBtnTag = element:getTag()

    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

end

--@brief	爱心点击回调
function SceneCity:onBuildClickLove(element)
    WZLog("SceneCity:onBuildClickLove")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    if CheckButtonOpen(ISLAND_BUILDING_LOTTERY) then
        local wnd = WndLoveLottery:createElement()
        WindowManager:addWindow( wnd ,WndLoveLottery,true)
    end
end

--@brief	点击日常副本回调
function SceneCity:onBuildClickDaily(element)
    WZLog("SceneCity:onBuildClickDaily")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    self.m_nClickBtnTag = element:getTag()

    if CheckButtonOpen(ISLAND_BUILDING_DAILYMAP) then
        SceneCopy:showScene(3)
    end
end

--@brief	点击单人副本回调
function SceneCity:onBuildClickSingleCopy(element)
    WZLog("SceneCity:onBuildClickSingleCopy")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    
    self.m_nClickBtnTag = element:getTag()
    local isTeach = TeachGroup1.ISTEACH == true and (TeachGroup1.GROUP == 1 and TeachGroup1.STEP == 2 or TeachGroup1.GROUP == 15 and TeachGroup1.STEP == 1 or TeachGroup1.GROUP == 29 and TeachGroup1.STEP == 1)
    if isTeach then 
        if TeachGroup1.GROUP == 15 and TeachGroup1.STEP == 1 then 
            g_SingleOrTeamMap = 2
        else
            g_SingleOrTeamMap = 1
        end
    end

    TeachGroup1:endTeachStep({1,2},{29,1},{15,1})

    if g_SingleOrTeamMap == 1 then
        if CheckButtonOpen(ISLAND_BUILDING_SINGLEMAP) then
            self:_postCopyShipEvent()
            PostPlayerEvent:postEvent(PostPlayerEvent.event_oneLvClickSingleCopy)
            GlobalGame.g_nSingleMapPage = nil
            SceneCopy:showScene(tag, nil, nil,nil,nil,false)
            WindowManager:removeWindow(self.m_root, self, true)        
        end
    elseif g_SingleOrTeamMap == 2 then
        ProtocolProcessorWndTask:send_PLAYER_GetHonourInfo( )
        return     
    end
end

--@brief	点击回调
function SceneCity:onBuildClickExchange(element)
    WZLog("SceneCity:onBuildClickExchange")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)


end

--@brief	点击回调
function SceneCity:onBuildClickTreasure(element)
    WZLog("SceneCity:onBuildClickTreasure")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    TeachGroup1:endTeachStep({41,1}, {42,2})

    local isTeach = TeachGroup1.ISTEACH == true and (TeachGroup1.GROUP == 26 and TeachGroup1.STEP == 2 or TeachGroup1.GROUP == 20 and TeachGroup1.STEP == 1)

    if isTeach ~= true and self:_checkBuildingOpen(ISLAND_BUILDING_EQUIT_LOTTERY) then
        WndSummonEntrance:showInterface()
    end
end

--@brief	点击回调
function SceneCity:onBuildClickTree(element)
    WZLog("SceneCity:onBuildClickTree")

    if self.m_bIsCanClick == nil then
        return false
    end
    local tree = GetElement(self.m_root, "armaTree4_SceneCity", WZUISpine)
    if tree and tree:getAnimationName() == "wait" then
        local tree1 = GetElement(self.m_root, "armaTree4_SceneCity", WZUISpine)
        tree1:play("click",false)
        local tree2 = GetElement(self.m_root, "armaTree5_SceneCity", WZUISpine)
        tree2:play("click",false)
        self.m_root:enableSchedule("updateTree")
    end
end

--@brief	树动画完成回调
function SceneCity:updateTree(element,t)

    local tree = GetElement(self.m_root, "armaTree4_SceneCity", WZUISpine)

    WZLog("SceneCity:updateTree one")
    if tree and tree:getAnimationName() == "click" then
        local isEnd = tree:isCurrentAnimationDone()
        if isEnd == true then
            WZLog("SceneCity:updateTree two")
            tree:play("wait",true)
            element:disableSchedule()
        end
    end

end

--@brief    点击回调
function SceneCity:onBuildClickHudie(element)
    --WZLog("SceneCity:onBuildClickHudie", tostring(SceneCity.m_bIsHudieMove))

    if self.m_bIsCanClick == nil or SceneCity.m_bIsHudieMove == true then
        return false
    end
    WZLog("SceneCity:onBuildClickHudie2")
    local Hudie = GetElement(self.m_root, "armaHudie1_SceneCity", WZArmature)
    if Hudie:getArmature() and Hudie:isPlayIndex(0) then
        --SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
        local Hudie1 = GetElement(self.m_root, "armaHudie1_SceneCity", WZArmature)
        Hudie1:play(1)
        local Hudie2 = GetElement(self.m_root, "armaHudie2_SceneCity", WZArmature)
        Hudie2:play(1)

        local Hudie = GetElement(SceneCity.m_root, "armaHudie1_SceneCity", WZArmature)
        --WZLog("SceneCity:_updateScheduleY1", tostring(Hudie:getArmature()))
        local armature = Hudie:getArmature()

        local Hudie2 = GetElement(SceneCity.m_root, "armaHudie2_SceneCity", WZArmature)
        local armature2 = Hudie:getArmature()
        if armature then

            local bone = armature:getBoneRecursively("hudie_4")
            local bone2 = armature2:getBoneRecursively("hudie_4")
            --WZLog("SceneCity:_updateScheduleY2", tostring(bone))
            if bone == nil then return end
            bone = tolua.cast(bone,"CCBone")
            armature = bone:getChildArmature()
            bone2 = tolua.cast(bone2,"CCBone")
            armature2 = bone2:getChildArmature()
            --WZLog("SceneCity:_updateScheduleY3", tostring(armature))
            if armature == nil then return end
            SceneCity.m_bIsUpdateHudie = 1
            armature:getAnimation():playByIndex("1",-1,-1,1);
            armature2:getAnimation():playByIndex("1",-1,-1,1);
        end

        SceneCity.m_bIsHudieMove = true
        self.m_root:enableSchedule("updateHudie")
    end
end

--@brief    蝴蝶动画完成回调
function SceneCity:updateHudie(element,t)

    local Hudie = GetElement(self.m_root, "armaHudie1_SceneCity", WZArmature)

    --WZLog("SceneCity:updateHudie one", tostring(Hudie:getArmature()), tostring(Hudie:isPlayIndex(1)), tostring(Hudie.m_currentBone), tostring(Hudie:isCurrentDone("")))
    if Hudie:getArmature() and Hudie:isPlayIndex(1) then
        local isEnd = nil
        if Hudie.m_currentBone == nil then
            isEnd = Hudie:isCurrentDone("")
        else
            isEnd = Hudie:isCurrentDone(Hudie.m_currentBone)
        end
        if isEnd == true then
            WZLog("SceneCity:updateHudie two")
            --Hudie:play(0)
            local armature = Hudie:getArmature()
            armature:getAnimation():playByIndex(0,-1,-1,1)
            element:disableSchedule()

            local Hudie = GetElement(SceneCity.m_root, "armaHudie1_SceneCity", WZArmature)
            --WZLog("SceneCity:_updateScheduleY1", tostring(Hudie:getArmature()))
            local armature = Hudie:getArmature()

            local Hudie2 = GetElement(SceneCity.m_root, "armaHudie2_SceneCity", WZArmature)
            local armature2 = Hudie:getArmature()
            if armature then

            local bone = armature:getBoneRecursively("hudie_4")
            local bone2 = armature2:getBoneRecursively("hudie_4")
            --WZLog("SceneCity:_updateScheduleY2", tostring(bone))
            if bone == nil then return end
            bone = tolua.cast(bone,"CCBone")
            armature = bone:getChildArmature()
            bone2 = tolua.cast(bone2,"CCBone")
            armature2 = bone2:getChildArmature()
            --WZLog("SceneCity:_updateScheduleY3", tostring(armature))
            if armature == nil then return end
            SceneCity.m_bIsUpdateHudie = 1
            armature:getAnimation():playByIndex("0",-1,-1,1);
            armature2:getAnimation():playByIndex("0",-1,-1,1);
            end
            SceneCity.m_bIsHudieMove = nil
        end
    end

end

--@brief    点击周年庆
function SceneCity:onBuildClickFirst(element)
    WZLog("SceneCity:onBuildClickFirst")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    local isTeach = TeachGroup1.ISTEACH == true and (TeachGroup1.GROUP == 1 and TeachGroup1.STEP == 2 or 
        TeachGroup1.GROUP == 13 and TeachGroup1.STEP == 1 or TeachGroup1.GROUP == 15 and TeachGroup1.STEP == 1 or TeachGroup1.GROUP == 29 and TeachGroup1.STEP == 1)

    if isTeach == true then
        return
    end

    if SceneCity:isAnniversary() == false then
        MsgBoxManager:showTipBox(LocalStrings.ANNIV_END or "")
        return
    end

    if CheckButtonOpen(122) then
        local pWndNewActivity = WndNewActivity:createElement()
        if pWndNewActivity ~= nil then
           WindowManager:addWindow( pWndNewActivity , WndNewActivity,nil,nil,nil,true)
        end
    end
end

--@brief    点击娄艺潇
function SceneCity:onBuildClickLouyixiao(element)
    WZLog("SceneCity:onBuildClickLouyixiao")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    local isTeach = TeachGroup1.ISTEACH == true and (TeachGroup1.GROUP == 1 and TeachGroup1.STEP == 2 or 
        TeachGroup1.GROUP == 13 and TeachGroup1.STEP == 1 or TeachGroup1.GROUP == 15 and TeachGroup1.STEP == 1 or
         TeachGroup1.GROUP == 29 and TeachGroup1.STEP == 1 or TeachGroup1.GROUP == 20 and TeachGroup1.STEP == 1 or TeachGroup1.GROUP == 48 and TeachGroup1.STEP == 1)
    if isTeach == true then
        return
    end

    if SceneCity:isLouyixiao() == false then
        MsgBoxManager:showTipBox(LocalStrings.ANNIV_END or "")
        return
    end

    if CheckButtonOpen(132) then
        WndApartmentAct:showInterface()
    end
end


--@brief    点击暑期
function SceneCity:onBuildClickSummer(element)
    WZLog("SceneCity:onBuildClickSummer")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    local isTeach = TeachGroup1.ISTEACH == true and (TeachGroup1.GROUP == 1 and TeachGroup1.STEP == 2 or 
        TeachGroup1.GROUP == 13 and TeachGroup1.STEP == 1 or TeachGroup1.GROUP == 15 and TeachGroup1.STEP == 1 or TeachGroup1.GROUP == 29 and TeachGroup1.STEP == 1)

    if isTeach == true then
        return
    end

    if SceneCity:isSummer() == false then
        MsgBoxManager:showTipBox(LocalStrings.SUMMER_END or "")
        return
    end

    if CheckButtonOpen(127) then
        WndSumVacAct:showInterface()
    end
end

--@brief    点击女商人
function SceneCity:onBuildClickSterious(element)
    WZLog("SceneCity:onBuildClickSterious")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    local isTeach = TeachGroup1.ISTEACH == true and (TeachGroup1.GROUP == 1 and TeachGroup1.STEP == 2 or 
        TeachGroup1.GROUP == 13 and TeachGroup1.STEP == 1 or TeachGroup1.GROUP == 15 and TeachGroup1.STEP == 1 or TeachGroup1.GROUP == 29 and TeachGroup1.STEP == 1)

    if isTeach == true then
        return
    end

    if SceneCity:isSterious() == false then
        MsgBoxManager:showTipBox(LocalStrings.SUMMER_END or "")
        return
    end

    if CheckButtonOpen(136) then
        WndRebate:show()
    end
end

--@brief	点击排位赛雕像
function SceneCity:onClickStatue(element)
    WZLog("SceneCity:onClickStatue")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    local conPlayer = GetElement(self.m_root, "conPlayer_CellQualifyingStatue")
    conPlayer:setScale(conPlayer:getScale()/1.1)
    
    WndWorship:showWindow()
end

--@brief    点击度假村回调
function SceneCity:onBuildClickHolidayVillage(element)
    WZLog("SceneCity:onBuildClickHolidayVillage")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    SceneHolidayVillage:showInterface()
end

function SceneCity:onTouchBegan(element,pt)
	WZLog("SceneCity:onTouchBegan")
	if WndUpgrade.m_root ~= nil then return end
	if WndRewardShow.m_root ~= nil or WindowManager:getTeachShelterLayer() then return end
	if WndDressUp.m_root ~= nil and (not WndDressUp:checkPoint(pt)) then
		WndDressUp:onCloseClick()
	end
end

--@brief	开始点击排位赛雕像
function SceneCity:onTouchStatue(element)
    WZLog("SceneCity:onTouchStatue")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    local conPlayer = GetElement(self.m_root, "conPlayer_CellQualifyingStatue")
    conPlayer:setScale(conPlayer:getScale()*1.1)
end

--@brief     比赛光圈
function SceneCity:matchLight()
    if SceneCity.tabCur and SceneCity.tabStartRank and SceneCity.tabStartHero and SceneCity.tabEndHero and SceneCity.tabEndRank.day then
        local isLight = false
        local offset = os.time() - SceneCity.tabCur.osTime
        local tab = os.date("*t", SceneCity.tabCur.serverTime + offset)

        --英雄联赛
        if tab.month and SceneCity.tabStartHero.month and SceneCity.tabEndHero.month and SceneCity.tabEndHero and SceneCity.tabEndHero.month ~= "" then
            if tab.month == SceneCity.tabStartHero.month and tab.month == SceneCity.tabEndHero.month then
                if tab.day >= SceneCity.tabStartHero.day and tab.day <= SceneCity.tabEndHero.day then
                    if tab.hour == SceneCity.tabStartHero.hour and tab.hour == SceneCity.tabEndHero.hour then
                        if tab.min >= SceneCity.tabStartHero.min and tab.min <= SceneCity.tabEndHero.min then
                            isLight = true
                            WZLog("SceneCity:matchLight one-11")
                        end
                    elseif tab.hour == SceneCity.tabStartHero.hour then
                        if tab.min >= SceneCity.tabStartHero.min then
                            isLight = true
                            WZLog("SceneCity:matchLight one-12")
                        end
                    elseif tab.hour > SceneCity.tabStartHero.hour and tab.hour < SceneCity.tabEndHero.hour then
                            isLight = true
                            WZLog("SceneCity:matchLight one-13")
                    elseif tab.hour == SceneCity.tabEndHero.hour then
                        if tab.min < SceneCity.tabEndHero.min then
                            isLight = true
                            WZLog("SceneCity:matchLight one-14")
                        end
                    end
                end
            elseif tab.month == SceneCity.tabStartHero.month then
                if tab.day >= SceneCity.tabStartHero.day then
                    if tab.hour == SceneCity.tabStartHero.hour and tab.hour == SceneCity.tabEndHero.hour then
                        if tab.min >= SceneCity.tabStartHero.min and tab.min <= SceneCity.tabEndHero.min then
                            isLight = true
                            WZLog("SceneCity:matchLight one-15")
                        end
                    elseif tab.hour == SceneCity.tabStartHero.hour then
                        if tab.min >= SceneCity.tabStartHero.min then
                            isLight = true
                            WZLog("SceneCity:matchLight one-16")
                        end
                    elseif tab.hour > SceneCity.tabStartHero.hour and tab.hour < SceneCity.tabEndHero.hour then
                            isLight = true
                            WZLog("SceneCity:matchLight one-17")
                    elseif tab.hour == SceneCity.tabEndHero.hour then
                        if tab.min < SceneCity.tabEndHero.min then
                            isLight = true
                            WZLog("SceneCity:matchLight one-18")
                        end
                    end
                end
            elseif tab.month > SceneCity.tabStartHero.month and tab.month < SceneCity.tabEndHero.month then
                if true then
                    if tab.hour == SceneCity.tabStartHero.hour and tab.hour == SceneCity.tabEndHero.hour then
                        if tab.min >= SceneCity.tabStartHero.min and tab.min <= SceneCity.tabEndHero.min then
                            isLight = true
                            WZLog("SceneCity:matchLight one-19")
                        end
                    elseif tab.hour == SceneCity.tabStartHero.hour then
                        if tab.min >= SceneCity.tabStartHero.min then
                            isLight = true
                            WZLog("SceneCity:matchLight one-20")
                        end
                    elseif tab.hour > SceneCity.tabStartHero.hour and tab.hour < SceneCity.tabEndHero.hour then
                            isLight = true
                            WZLog("SceneCity:matchLight one-21")
                    elseif tab.hour == SceneCity.tabEndHero.hour then
                        if tab.min < SceneCity.tabEndHero.min then
                            isLight = true
                            WZLog("SceneCity:matchLight one-22")
                        end
                    end
                end
            elseif tab.month == SceneCity.tabEndHero.month then
                if tab.day <= SceneCity.tabEndHero.day then
                    if tab.hour == SceneCity.tabStartHero.hour and tab.hour == SceneCity.tabEndHero.hour then
                        if tab.min >= SceneCity.tabStartHero.min and tab.min <= SceneCity.tabEndHero.min then
                            isLight = true
                            WZLog("SceneCity:matchLight one-23")
                        end
                    elseif tab.hour == SceneCity.tabStartHero.hour then
                        if tab.min >= SceneCity.tabStartHero.min then
                            isLight = true
                            WZLog("SceneCity:matchLight one-24")
                        end
                    elseif tab.hour > SceneCity.tabStartHero.hour and tab.hour < SceneCity.tabEndHero.hour then
                            isLight = true
                            WZLog("SceneCity:matchLight one-25")
                    elseif tab.hour == SceneCity.tabEndHero.hour then
                        if tab.min < SceneCity.tabEndHero.min then
                            isLight = true
                            WZLog("SceneCity:matchLight one-26")
                        end
                    end
                end
            end
        end

        --排位赛
        -- if SceneCity.tabEndRank and SceneCity.tabEndRank.month ~= "" then
        --     if tab.month == SceneCity.tabStartRank.month and tab.month == SceneCity.tabEndRank.month then
        --         if tab.day >= SceneCity.tabStartRank.day and tab.day <= SceneCity.tabEndRank.day then
        --             if tab.hour == SceneCity.tabStartRank.hour and tab.hour == SceneCity.tabEndRank.hour then
        --                 if tab.min >= SceneCity.tabStartRank.min and tab.min <= SceneCity.tabEndRank.min then
        --                     isLight = true
        --                     WZLog("SceneCity:matchLight one-51")
        --                 end
        --             elseif tab.hour == SceneCity.tabStartRank.hour then
        --                 if tab.min >= SceneCity.tabStartRank.min then
        --                     isLight = true
        --                     WZLog("SceneCity:matchLight one-52")
        --                 end
        --             elseif tab.hour > SceneCity.tabStartRank.hour and tab.hour < SceneCity.tabEndRank.hour then
        --                     isLight = true
        --                     --WZLog("SceneCity:matchLight one-53")
        --             elseif tab.hour == SceneCity.tabEndRank.hour then
        --                 if tab.min < SceneCity.tabEndRank.min then
        --                     isLight = true
        --                     WZLog("SceneCity:matchLight one-54")
        --                 end
        --             end
        --         end
        --     elseif tab.month == SceneCity.tabStartRank.month then
        --         if tab.day >= SceneCity.tabStartRank.day then
        --             if tab.hour == SceneCity.tabStartRank.hour and tab.hour == SceneCity.tabEndRank.hour then
        --                 if tab.min >= SceneCity.tabStartRank.min and tab.min <= SceneCity.tabEndRank.min then
        --                     isLight = true
        --                     WZLog("SceneCity:matchLight one-55")
        --                 end
        --             elseif tab.hour == SceneCity.tabStartRank.hour then
        --                 if tab.min >= SceneCity.tabStartRank.min then
        --                     isLight = true
        --                     --WZLog("SceneCity:matchLight one-56")
        --                 end
        --             elseif tab.hour > SceneCity.tabStartRank.hour and tab.hour < SceneCity.tabEndRank.hour then
        --                     isLight = true
        --                     WZLog("SceneCity:matchLight one-57")
        --             elseif tab.hour == SceneCity.tabEndRank.hour then
        --                 if tab.min < SceneCity.tabEndRank.min then
        --                     isLight = true
        --                     WZLog("SceneCity:matchLight one-58")
        --                 end
        --             end
        --         end
        --     elseif tab.month > SceneCity.tabStartRank.month and tab.month < SceneCity.tabEndRank.month then
        --         if true then
        --             if tab.hour == SceneCity.tabStartRank.hour and tab.hour == SceneCity.tabEndRank.hour then
        --                 if tab.min >= SceneCity.tabStartRank.min and tab.min <= SceneCity.tabEndRank.min then
        --                     isLight = true
        --                     WZLog("SceneCity:matchLight one-59")
        --                 end
        --             elseif tab.hour == SceneCity.tabStartRank.hour then
        --                 if tab.min >= SceneCity.tabStartRank.min then
        --                     isLight = true
        --                     WZLog("SceneCity:matchLight one-60")
        --                 end
        --             elseif tab.hour > SceneCity.tabStartRank.hour and tab.hour < SceneCity.tabEndRank.hour then
        --                     isLight = true
        --                     WZLog("SceneCity:matchLight one-61")
        --             elseif tab.hour == SceneCity.tabEndRank.hour then
        --                 if tab.min < SceneCity.tabEndRank.min then
        --                     isLight = true
        --                     WZLog("SceneCity:matchLight one-62")
        --                 end
        --             end
        --         end
        --     elseif tab.month == SceneCity.tabEndRank.month then
        --         if tab.day <= SceneCity.tabEndRank.day then
        --             if tab.hour == SceneCity.tabStartRank.hour and tab.hour == SceneCity.tabEndRank.hour then
        --                 if tab.min >= SceneCity.tabStartRank.min and tab.min <= SceneCity.tabEndRank.min then
        --                     isLight = true
        --                     WZLog("SceneCity:matchLight one-63")
        --                 end
        --             elseif tab.hour == SceneCity.tabStartRank.hour then
        --                 if tab.min >= SceneCity.tabStartRank.min then
        --                     isLight = true
        --                     WZLog("SceneCity:matchLight one-64")
        --                 end
        --             elseif tab.hour > SceneCity.tabStartRank.hour and tab.hour < SceneCity.tabEndRank.hour then
        --                     isLight = true
        --                     WZLog("SceneCity:matchLight one-65")
        --             elseif tab.hour == SceneCity.tabEndRank.hour then
        --                 if tab.min < SceneCity.tabEndRank.min then
        --                     isLight = true
        --                     WZLog("SceneCity:matchLight one-66")
        --                 end
        --             end
        --         end
        --     end
        -- end

        -- isLight = false
        -- self.m_heroMatchType = 15
        -- SceneCity.startTimeFOneData[2] = 9
        -- SceneCity.startTimeFOneData[3] = 9
        -- SceneCity.startTimeFThreeTime[1] = 16
        -- SceneCity.startTimeFThreeTime[2] = 20
        -- SceneCity.endTimeFThreeTime[1]   = 17
        -- SceneCity.endTimeFThreeTime[2]   = 15

        if isLight == false and self.m_heroMatchType ~= nil and SceneCity.startTime16ThreeData then
        	WZLog("SceneCity:matchLight one-70", self.m_heroMatchType, "month", tab.month, tab.day, "hour", tab.hour, tab.min)
            if self.m_heroMatchType == 1 then
                if tab.month == SceneCity.startTime32OneData[2] and tab.day == SceneCity.startTime32OneData[3] then
                    if tab.hour == SceneCity.startTime32OneTime[1] and tab.hour == SceneCity.endTime32OneTime[1] then
                        if tab.min >= SceneCity.startTime32OneTime[2] and tab.min <= SceneCity.endTime32OneTime[2] then
                            isLight = true
                            WZLog("SceneCity:matchLight one-71")
                        end
                    elseif tab.hour == SceneCity.startTime32OneTime[1] then
                        if tab.min >= SceneCity.startTime32OneTime[2] then
                            isLight = true
                            WZLog("SceneCity:matchLight one-72")
                        end
                    elseif tab.hour > SceneCity.startTime32OneTime[1] and tab.hour < SceneCity.endTime32OneTime[1] then
                        isLight = true
                        WZLog("SceneCity:matchLight one-73")
                    elseif tab.hour == SceneCity.endTime32OneTime[1] then
                        if tab.min < SceneCity.endTime32OneTime[2] then
                            isLight = true
                            WZLog("SceneCity:matchLight one-74")
                        end
                    end
                end
            end

            if self.m_heroMatchType == 2 then
                if tab.month == SceneCity.startTime32TwoData[2] and tab.day == SceneCity.startTime32TwoData[3] then
                    if tab.hour == SceneCity.startTime32TwoTime[1] and tab.hour == SceneCity.endTime32TwoTime[1] then
                        if tab.min >= SceneCity.startTime32TwoTime[2] and tab.min <= SceneCity.endTime32TwoTime[2] then
                            isLight = true
                            WZLog("SceneCity:matchLight one-75")
                        end
                    elseif tab.hour == SceneCity.startTime32TwoTime[1] then
                        if tab.min >= SceneCity.startTime32TwoTime[2] then
                            isLight = true
                            WZLog("SceneCity:matchLight one-76")
                        end
                    elseif tab.hour > SceneCity.startTime32TwoTime[1] and tab.hour < SceneCity.endTime32TwoTime[1] then
                        isLight = true
                        WZLog("SceneCity:matchLight one-77")
                    elseif tab.hour == SceneCity.endTime32TwoTime[1] then
                        if tab.min < SceneCity.endTime32TwoTime[2] then
                            isLight = true
                            WZLog("SceneCity:matchLight one-78")
                        end
                    end
                end
            end

            if self.m_heroMatchType == 3 then
                if tab.month == SceneCity.startTime32ThreeData[2] and tab.day == SceneCity.startTime32ThreeData[3] then
                    if tab.hour == SceneCity.startTime32ThreeTime[1] and tab.hour == SceneCity.endTime32ThreeTime[1] then
                        if tab.min >= SceneCity.startTime32ThreeTime[2] and tab.min <= SceneCity.endTime32ThreeTime[2] then
                            isLight = true
                            WZLog("SceneCity:matchLight one-79")
                        end
                    elseif tab.hour == SceneCity.startTime32ThreeTime[1] then
                        if tab.min >= SceneCity.startTime32ThreeTime[2] then
                            isLight = true
                            WZLog("SceneCity:matchLight one-80")
                        end
                    elseif tab.hour > SceneCity.startTime32ThreeTime[1] and tab.hour < SceneCity.endTime32ThreeTime[1] then
                        isLight = true
                        WZLog("SceneCity:matchLight one-81")
                    elseif tab.hour == SceneCity.endTime32ThreeTime[1] then
                        if tab.min < SceneCity.endTime32ThreeTime[2] then
                            isLight = true
                            WZLog("SceneCity:matchLight one-82")
                        end
                    end
                end
            end

            if self.m_heroMatchType == 4 then
                if tab.month == SceneCity.startTime16OneData[2] and tab.day == SceneCity.startTime16OneData[3] then
                    if tab.hour == SceneCity.startTime16OneTime[1] and tab.hour == SceneCity.endTime16OneTime[1] then
                        if tab.min >= SceneCity.startTime16OneTime[2] and tab.min <= SceneCity.endTime16OneTime[2] then
                            isLight = true
                            WZLog("SceneCity:matchLight one-83")
                        end
                    elseif tab.hour == SceneCity.startTime16OneTime[1] then
                        if tab.min >= SceneCity.startTime16OneTime[2] then
                            isLight = true
                            WZLog("SceneCity:matchLight one-84")
                        end
                    elseif tab.hour > SceneCity.startTime16OneTime[1] and tab.hour < SceneCity.endTime16OneTime[1] then
                        isLight = true
                        WZLog("SceneCity:matchLight one-85")
                    elseif tab.hour == SceneCity.endTime16OneTime[1] then
                        if tab.min < SceneCity.endTime16OneTime[2] then
                            isLight = true
                            WZLog("SceneCity:matchLight one-86")
                        end
                    end
                end
            end

            if self.m_heroMatchType == 5 then
                if tab.month == SceneCity.startTime16TwoData[2] and tab.day == SceneCity.startTime16TwoData[3] then
                    if tab.hour == SceneCity.startTime16TwoTime[1] and tab.hour == SceneCity.endTime16TwoTime[1] then
                        if tab.min >= SceneCity.startTime16TwoTime[2] and tab.min <= SceneCity.endTime16TwoTime[2] then
                            isLight = true
                            WZLog("SceneCity:matchLight one-87")
                        end
                    elseif tab.hour == SceneCity.startTime16TwoTime[1] then
                        if tab.min >= SceneCity.startTime16TwoTime[2] then
                            isLight = true
                            WZLog("SceneCity:matchLight one-88")
                        end
                    elseif tab.hour > SceneCity.startTime16TwoTime[1] and tab.hour < SceneCity.endTime16TwoTime[1] then
                        isLight = true
                        WZLog("SceneCity:matchLight one-89")
                    elseif tab.hour == SceneCity.endTime16TwoTime[1] then
                        if tab.min < SceneCity.endTime16TwoTime[2] then
                            isLight = true
                            WZLog("SceneCity:matchLight one-90")
                        end
                    end
                end
            end

            if self.m_heroMatchType == 6 then
                if tab.month == SceneCity.startTime16ThreeData[2] and tab.day == SceneCity.startTime16ThreeData[3] then
                    if tab.hour == SceneCity.startTime16ThreeTime[1] and tab.hour == SceneCity.endTime16ThreeTime[1] then
                        if tab.min >= SceneCity.startTime16ThreeTime[2] and tab.min <= SceneCity.endTime16ThreeTime[2] then
                            isLight = true
                            WZLog("SceneCity:matchLight one-91")
                        end
                    elseif tab.hour == SceneCity.startTime16ThreeTime[1] then
                        if tab.min >= SceneCity.startTime16ThreeTime[2] then
                            isLight = true
                            WZLog("SceneCity:matchLight one-92")
                        end
                    elseif tab.hour > SceneCity.startTime16ThreeTime[1] and tab.hour < SceneCity.endTime16ThreeTime[1] then
                        isLight = true
                        WZLog("SceneCity:matchLight one-93")
                    elseif tab.hour == SceneCity.endTime16ThreeTime[1] then
                        if tab.min < SceneCity.endTime16ThreeTime[2] then
                            isLight = true
                            WZLog("SceneCity:matchLight one-94")
                        end
                    end
                end
            end

            if self.m_heroMatchType == 7 then
                if tab.month == SceneCity.startTime8OneData[2] and tab.day == SceneCity.startTime8OneData[3] then
                    if tab.hour == SceneCity.startTime8OneTime[1] and tab.hour == SceneCity.endTime8OneTime[1] then
                        if tab.min >= SceneCity.startTime8OneTime[2] and tab.min <= SceneCity.endTime8OneTime[2] then
                            isLight = true
                            WZLog("SceneCity:matchLight one-95")
                        end
                    elseif tab.hour == SceneCity.startTime8OneTime[1] then
                        if tab.min >= SceneCity.startTime8OneTime[2] then
                            isLight = true
                            WZLog("SceneCity:matchLight one-96")
                        end
                    elseif tab.hour > SceneCity.startTime8OneTime[1] and tab.hour < SceneCity.endTime8OneTime[1] then
                        isLight = true
                        WZLog("SceneCity:matchLight one-97")
                    elseif tab.hour == SceneCity.endTime8OneTime[1] then
                        if tab.min < SceneCity.endTime8OneTime[2] then
                            isLight = true
                            WZLog("SceneCity:matchLight one-98")
                        end
                    end
                end
            end

            if self.m_heroMatchType == 8 then
                if tab.month == SceneCity.startTime8TwoData[2] and tab.day == SceneCity.startTime8TwoData[3] then
                    if tab.hour == SceneCity.startTime8TwoTime[1] and tab.hour == SceneCity.endTime8TwoTime[1] then
                        if tab.min >= SceneCity.startTime8TwoTime[2] and tab.min <= SceneCity.endTime8TwoTime[2] then
                            isLight = true
                            WZLog("SceneCity:matchLight one-99")
                        end
                    elseif tab.hour == SceneCity.startTime8TwoTime[1] then
                        if tab.min >= SceneCity.startTime8TwoTime[2] then
                            isLight = true
                            WZLog("SceneCity:matchLight one-100")
                        end
                    elseif tab.hour > SceneCity.startTime8TwoTime[1] and tab.hour < SceneCity.endTime8TwoTime[1] then
                        isLight = true
                        WZLog("SceneCity:matchLight one-101")
                    elseif tab.hour == SceneCity.endTime8TwoTime[1] then
                        if tab.min < SceneCity.endTime8TwoTime[2] then
                            isLight = true
                            WZLog("SceneCity:matchLight one-102")
                        end
                    end
                end
            end

            if self.m_heroMatchType == 9 then
                if tab.month == SceneCity.startTime8ThreeData[2] and tab.day == SceneCity.startTime8ThreeData[3] then
                    if tab.hour == SceneCity.startTime8ThreeTime[1] and tab.hour == SceneCity.endTime8ThreeTime[1] then
                        if tab.min >= SceneCity.startTime8ThreeTime[2] and tab.min <= SceneCity.endTime8ThreeTime[2] then
                            isLight = true
                            WZLog("SceneCity:matchLight one-103")
                        end
                    elseif tab.hour == SceneCity.startTime8ThreeTime[1] then
                        if tab.min >= SceneCity.startTime8ThreeTime[2] then
                            isLight = true
                            WZLog("SceneCity:matchLight one-104")
                        end
                    elseif tab.hour > SceneCity.startTime8ThreeTime[1] and tab.hour < SceneCity.endTime8ThreeTime[1] then
                        isLight = true
                        WZLog("SceneCity:matchLight one-105")
                    elseif tab.hour == SceneCity.endTime8ThreeTime[1] then
                        if tab.min < SceneCity.endTime8ThreeTime[2] then
                            isLight = true
                            WZLog("SceneCity:matchLight one-106")
                        end
                    end
                end
            end

            if self.m_heroMatchType == 10 then
                if tab.month == SceneCity.startTime4OneData[2] and tab.day == SceneCity.startTime4OneData[3] then
                    if tab.hour == SceneCity.startTime4OneTime[1] and tab.hour == SceneCity.endTime4OneTime[1] then
                        if tab.min >= SceneCity.startTime4OneTime[2] and tab.min <= SceneCity.endTime4OneTime[2] then
                            isLight = true
                            WZLog("SceneCity:matchLight one-107")
                        end
                    elseif tab.hour == SceneCity.startTime4OneTime[1] then
                        if tab.min >= SceneCity.startTime4OneTime[2] then
                            isLight = true
                            WZLog("SceneCity:matchLight one-108")
                        end
                    elseif tab.hour > SceneCity.startTime4OneTime[1] and tab.hour < SceneCity.endTime4OneTime[1] then
                        isLight = true
                        WZLog("SceneCity:matchLight one-109")
                    elseif tab.hour == SceneCity.endTime4OneTime[1] then
                        if tab.min < SceneCity.endTime4OneTime[2] then
                            isLight = true
                            WZLog("SceneCity:matchLight one-110")
                        end
                    end
                end
            end

            if self.m_heroMatchType == 11 then
                if tab.month == SceneCity.startTime4TwoData[2] and tab.day == SceneCity.startTime4TwoData[3] then
                    if tab.hour == SceneCity.startTime4TwoTime[1] and tab.hour == SceneCity.endTime4TwoTime[1] then
                        if tab.min >= SceneCity.startTime4TwoTime[2] and tab.min <= SceneCity.endTime4TwoTime[2] then
                            isLight = true
                            WZLog("SceneCity:matchLight one-111")
                        end
                    elseif tab.hour == SceneCity.startTime4TwoTime[1] then
                        if tab.min >= SceneCity.startTime4TwoTime[2] then
                            isLight = true
                            WZLog("SceneCity:matchLight one-112")
                        end
                    elseif tab.hour > SceneCity.startTime4TwoTime[1] and tab.hour < SceneCity.endTime4TwoTime[1] then
                        isLight = true
                        WZLog("SceneCity:matchLight one-113")
                    elseif tab.hour == SceneCity.endTime4TwoTime[1] then
                        if tab.min < SceneCity.endTime4TwoTime[2] then
                            isLight = true
                            WZLog("SceneCity:matchLight one-114")
                        end
                    end
                end
            end

            if self.m_heroMatchType == 12 then
                if tab.month == SceneCity.startTime4ThreeData[2] and tab.day == SceneCity.startTime4ThreeData[3] then
                    if tab.hour == SceneCity.startTime4ThreeTime[1] and tab.hour == SceneCity.endTime4ThreeTime[1] then
                        if tab.min >= SceneCity.startTime4ThreeTime[2] and tab.min <= SceneCity.endTime4ThreeTime[2] then
                            isLight = true
                            WZLog("SceneCity:matchLight one-71")
                        end
                    elseif tab.hour == SceneCity.startTime4ThreeTime[1] then
                        if tab.min >= SceneCity.startTime4ThreeTime[2] then
                            isLight = true
                            WZLog("SceneCity:matchLight one-72")
                        end
                    elseif tab.hour > SceneCity.startTime4ThreeTime[1] and tab.hour < SceneCity.endTime4ThreeTime[1] then
                        isLight = true
                        WZLog("SceneCity:matchLight one-73")
                    elseif tab.hour == SceneCity.endTime4ThreeTime[1] then
                        if tab.min < SceneCity.endTime4ThreeTime[2] then
                            isLight = true
                            WZLog("SceneCity:matchLight one-74")
                        end
                    end
                end
            end

            if self.m_heroMatchType == 13 then
                if tab.month == SceneCity.startTimeFOneData[2] and tab.day == SceneCity.startTimeFOneData[3] then
                    if tab.hour == SceneCity.startTimeFOneTime[1] and tab.hour == SceneCity.endTimeFOneTime[1] then
                        if tab.min >= SceneCity.startTimeFOneTime[2] and tab.min <= SceneCity.endTimeFOneTime[2] then
                            isLight = true
                            WZLog("SceneCity:matchLight one-71")
                        end
                    elseif tab.hour == SceneCity.startTimeFOneTime[1] then
                        if tab.min >= SceneCity.startTimeFOneTime[2] then
                            isLight = true
                            WZLog("SceneCity:matchLight one-72")
                        end
                    elseif tab.hour > SceneCity.startTimeFOneTime[1] and tab.hour < SceneCity.endTimeFOneTime[1] then
                        isLight = true
                        WZLog("SceneCity:matchLight one-73")
                    elseif tab.hour == SceneCity.endTimeFOneTime[1] then
                        if tab.min < SceneCity.endTimeFOneTime[2] then
                            isLight = true
                            WZLog("SceneCity:matchLight one-7F")
                        end
                    end
                end
            end

            if self.m_heroMatchType == 14 then
                if tab.month == SceneCity.startTimeFTwoData[2] and tab.day == SceneCity.startTimeFTwoData[3] then
                    if tab.hour == SceneCity.startTimeFTwoTime[1] and tab.hour == SceneCity.endTimeFTwoTime[1] then
                        if tab.min >= SceneCity.startTimeFTwoTime[2] and tab.min <= SceneCity.endTimeFTwoTime[2] then
                            isLight = true
                            WZLog("SceneCity:matchLight one-71")
                        end
                    elseif tab.hour == SceneCity.startTimeFTwoTime[1] then
                        if tab.min >= SceneCity.startTimeFTwoTime[2] then
                            isLight = true
                            WZLog("SceneCity:matchLight one-72")
                        end
                    elseif tab.hour > SceneCity.startTimeFTwoTime[1] and tab.hour < SceneCity.endTimeFTwoTime[1] then
                        isLight = true
                        WZLog("SceneCity:matchLight one-73")
                    elseif tab.hour == SceneCity.endTimeFTwoTime[1] then
                        if tab.min < SceneCity.endTimeFTwoTime[2] then
                            isLight = true
                            WZLog("SceneCity:matchLight one-7F")
                        end
                    end
                end
            end

            if self.m_heroMatchType == 15 then
                if tab.month == SceneCity.startTimeFThreeData[2] and tab.day == SceneCity.startTimeFThreeData[3] then
                    if tab.hour == SceneCity.startTimeFThreeTime[1] and tab.hour == SceneCity.endTimeFThreeTime[1] then
                        if tab.min >= SceneCity.startTimeFThreeTime[2] and tab.min <= SceneCity.endTimeFThreeTime[2] then
                            isLight = true
                            WZLog("SceneCity:matchLight one-71")
                        end
                    elseif tab.hour == SceneCity.startTimeFThreeTime[1] then
                        if tab.min >= SceneCity.startTimeFThreeTime[2] then
                            isLight = true
                            WZLog("SceneCity:matchLight one-72")
                        end
                    elseif tab.hour > SceneCity.startTimeFThreeTime[1] and tab.hour < SceneCity.endTimeFThreeTime[1] then
                        isLight = true
                        WZLog("SceneCity:matchLight one-73")
                    elseif tab.hour == SceneCity.endTimeFThreeTime[1] then
                        if tab.min < SceneCity.endTimeFThreeTime[2] then
                            isLight = true
                            WZLog("SceneCity:matchLight one-7F")
                        end
                    end
                end
            end
        end


        --WZLog("SceneCity:matchLight two", tostring(isLight))
        local btn = GetElementWithoutAssert(self.m_root, "btn71_WndOwnCity", WZUIButton)
        --WZLog("SceneCity:matchLight three", tostring(btn))
        if btn and isLight then
            self:setSceneMainIconRedPoint(ISLAND_UP_LEAGUE, true)
        elseif btn and isLight == false then
            self:setSceneMainIconRedPoint(ISLAND_UP_LEAGUE, false)
        end

    end
end

--@note     移动云
function SceneCity:moveCloud(dt)
    if SceneCity.m_root == nil then
        return
    end

    local conCloud1 = GetElement(self.m_root,"conCloud1_SceneCity",WZUIContainer)
    local conCloud2 = GetElement(self.m_root,"conCloud2_SceneCity",WZUIContainer)  
    if conCloud1 == nil then
        return
    end 
    local conCloud1x = conCloud1:getPositionX()
    local conCloud2x = conCloud2:getPositionX()
    local conCloudSpeed = 1 * dt
    conCloudSpeed = conCloudSpeed > 1 and 1 or conCloudSpeed

    conCloud1x = conCloud1x + conCloudSpeed
    conCloud2x = conCloud2x + conCloudSpeed
    if conCloud1x >= 1536 then
        conCloud1x = -1536
        conCloud2x = 0
    end

    
    if conCloud2x >= 1536 then
        conCloud2x = -1536
        conCloud1x = 0
    end


    local imgCloud = GetElement(self.m_root,"imgCloud_SceneCity",WZUIImage)
    local imgCloudx = imgCloud:getPositionX()
    local imgCloudSpeed = 1 * dt
    imgCloudSpeed = imgCloudSpeed > 2 and 2 or imgCloudSpeed

    imgCloudx = imgCloudx + imgCloudSpeed
    if imgCloudx >= 1700 then
        imgCloudx = 0
    end
    --WZLog("SceneCity:moveCloud", dt, tostring(conCloud1), tostring(conCloud2), tostring(imgCloud), imgCloudx, imgCloudx, imgCloudSpeed)
    conCloud1:setPositionX(conCloud1x)
    conCloud2:setPositionX(conCloud2x)
    imgCloud:setPositionX(imgCloudx)
end

--@brief    活动光圈
function SceneCity:showActivityLingth(curTime, rewardTime, state)
    if SceneCity.m_root == nil then
        return
    end
    
    self.m_nCurLingthTime = curTime * 60
    self.m_nRewardLingthTime1 = rewardTime[1] * 60 - self.m_nCurLingthTime
    self.m_nRewardLingthTime2 = rewardTime[2] * 60 - self.m_nCurLingthTime
    if state[1] == 1 or state[1] == 2 then
        self.m_nRewardLingthTime1 = -1
    end

    if state[2] == 1 or state[2] == 2 then
        self.m_nRewardLingthTime2 = -1
    end

    SceneCity.m_nStartTime3 = os.time()

    WZLog("SceneCity:showActivityLingth", curTime, rewardTime[1], rewardTime[2], state[1], state[2], "self.m_nCurLingthTime", self.m_nCurLingthTime, self.m_nRewardLingthTime1, self.m_nRewardLingthTime2)
end

--@brief    活动光圈
function SceneCity:showActivityLingthAction(dt0)
    if SceneCity.m_root == nil or (self.m_nRewardLingthTime1 <= 0 and self.m_nRewardLingthTime2 <= 0) or WndOwnCity.m_root == nil or CacheCenter:getPlayerInfo() == nil or CacheCenter:getPlayerInfo().level <= 4 or CacheCenter:getPlayerInfo().level >= 21 then
        return
    end

    if SceneCity.m_nStartTime2 == nil then
        SceneCity.m_nStartTime2 = os.time()
    end

    local dt = os.time() - SceneCity.m_nStartTime2
    local dt1 = os.time() - SceneCity.m_nStartTime3

    if WindowManager:isHaveTeachTouchLayer() == true or WndTeachTalk.m_root ~= nil then
        SceneCity.m_nStartTime2 = os.time()
        dt = 0
    end

    SceneCity.m_nTime2 = dt

    self.m_nCurLingthTime = dt1
    --WZLog("SceneCity:showActivityLingthAction", SceneCity.m_nTime2, tostring(SceneCity.m_bIsTipsAppear3), tostring(SceneCity.m_tButtonTipsAnim3), self.m_nCurLingthTime, self.m_nRewardLingthTime1, self.m_nRewardLingthTime2, tostring(self.m_nCurLingthType))
    if (SceneCity.m_nTime2 >= 3 and SceneCity.m_nTime2 <= 9 or SceneCity.m_nTime2 >= 13 and SceneCity.m_nTime2 <= 19 or SceneCity.m_nTime2 >= 23 and SceneCity.m_nTime2 <= 28) and SceneCity.m_bIsTipsAppear3 == nil then
        SceneCity.m_bIsTipsAppear3 = true
        if SceneCity.m_tButtonTipsAnim3 == nil then
            local btn = GetElement(WndOwnCity.m_root, "btn21_WndOwnCity", WZUIButton)
            local conBtns = GetElement(WndOwnCity.m_root, "conActivityBtns_WndOwnCity", WZUIContainer)
            local txt = 208
            if self.m_nRewardLingthTime1 > 0 --[[and self.m_nRewardLingthTime2 < 0]] then
                if self.m_nCurLingthTime < self.m_nRewardLingthTime1 then
                    txt = string.format(LocalStrings.TEACH_207, math.floor((self.m_nRewardLingthTime1 - self.m_nCurLingthTime) / 60) )
                else
                    txt = 208
                end
                self.m_nCurLingthType = 1
            elseif self.m_nRewardLingthTime2 > 0 and self.m_nRewardLingthTime1 < 0 then
                if self.m_nCurLingthTime < self.m_nRewardLingthTime2 then
                    txt = string.format(LocalStrings.TEACH_209, math.floor((self.m_nRewardLingthTime2 - self.m_nCurLingthTime) / 60) )
                else
                    txt = 210
                end
                self.m_nCurLingthType = 2
            -- elseif self.m_nRewardLingthTime1 > 0 and self.m_nRewardLingthTime2 > 0 then
            --     if self.m_nCurLingthType == nil or self.m_nCurLingthType == 2 then
            --         if self.m_nCurLingthTime < self.m_nRewardLingthTime1 then
            --             txt = string.format(LocalStrings.TEACH_207, math.floor((self.m_nRewardLingthTime1 - self.m_nCurLingthTime) / 60) )
            --         else
            --             txt = 208
            --         end
            --         self.m_nCurLingthType = 1
            --     else
            --         if self.m_nCurLingthTime < self.m_nRewardLingthTime2 then
            --             txt = string.format(LocalStrings.TEACH_209, math.floor((self.m_nRewardLingthTime2 - self.m_nCurLingthTime) / 60) )
            --         else
            --             txt = 210
            --         end
            --         self.m_nCurLingthType = 2
            --     end
            end
            -- SceneCity.m_tButtonTipsAnim3, SceneCity.m_tButtonTipsDialog3 = WindowManager:addTipForButton(conBtns, 0.30, GlobalMethod:ccp(40,10), txt, 3, GlobalMethod:ccp(100,-70))
            WZLog("SceneCity:loop zero-44", txt,  tostring(conBtns))

            local armaTeachClip = BattleAnimation:createAnimation("zhiyin_dianji_anniu_01",true, "teach")
            armaTeachClip:getAnimNode():setScale(0.3)
            btn:addChild(armaTeachClip:getAnimNode(),99)
            armaTeachClip:getAnimNode():setTouchEnable(false)
            armaTeachClip:play("0",true)
            armaTeachClip:getAnimNode():setPosition(GlobalMethod:ccp(40,10))
            SceneCity.m_tButtonTipsAnim3 = armaTeachClip

            local dialog = Teach:showDialog( conBtns , conBtns , TeachGroup1:getTeachText(txt) , 3 , GlobalMethod:ccp(0,-70), 1 )
            SceneCity.m_tButtonTipsDialog3 = dialog
        else
            SceneCity.m_tButtonTipsAnim3:setVisible(true)
            SceneCity.m_tButtonTipsDialog3:setVisible(true)
            WZLog("SceneCity:loop zero-45")
        end
    end

    if SceneCity.m_bIsTipsAppear3 == true and SceneCity.m_tButtonTipsAnim3 and (SceneCity.m_nTime2 >= 10 and SceneCity.m_nTime2 <= 12 or SceneCity.m_nTime2 == 20 and SceneCity.m_nTime2 <= 22 or SceneCity.m_nTime2 >= 29) then
        SceneCity.m_tButtonTipsAnim3:getAnimNode():removeFromParentAndCleanup(true)
        SceneCity.m_tButtonTipsDialog3:removeFromParentAndCleanup(true)
        SceneCity.m_tButtonTipsAnim3, SceneCity.m_tButtonTipsDialog3 = nil, nil
        SceneCity.m_bIsTipsAppear3 = nil
    end

    if SceneCity.m_nTime2 >= 30 then
        SceneCity.m_nTime2 = 0
        SceneCity.m_nStartTime2 = os.time()
    end
end

--@brief    每帧循环处理函数
--@param    element:定时器绑定对象
--@param    dt:定时器间隔
--@note     定时器回调
function SceneCity:loop(element, dt, dt1)

    --WZLog("SceneCity:loop", tostring(element), tostring(dt), tostring(dt1))
    if --[[g_testFigureScene and]] FigureSceneManager:getInstance().m_bCanUpdate then
        FigureSceneManager:getInstance():update(dt)
    end

    local ostime = os.time()
    if SceneCity.m_nStartTime == nil then
        SceneCity.m_nStartTime = ostime
    end

    dt = ostime - SceneCity.m_nStartTime

    if WindowManager:isHaveTeachTouchLayer() == true or WndTeachTalk.m_root ~= nil then
        SceneCity.m_nStartTime = ostime
        dt = 0
    end

    if dt > 1 and SceneCity.m_bIsHudiePlay == nil then
        local huidie = WZUISpine:luaTo(GetElement(SceneCity.m_root,"animHuidie2"))
        huidie:setAnimationName("scene_city_hudie")
        SceneCity.m_bIsHudiePlay = true
        WZLog("SceneCity:loop zero-3333")
    end

    SceneCity:moveCloud(dt);
    SceneCity:showActivityLingthAction(dt)

    if SceneCity.m_root and WindowManager:isHaveTeachTouchLayer() then
        if SceneCity.m_tButtonTipsAnim1 then
            SceneCity.m_tButtonTipsAnim1:removeFromParentAndCleanup(true)
            SceneCity.m_tButtonTipsDialog1:removeFromParentAndCleanup(true)
            SceneCity.m_tButtonTipsAnim1, SceneCity.m_tButtonTipsDialog1 = nil, nil
            SceneCity.m_bIsTipsAppear1 = nil
            WZLog("SceneCity:loop zero-3")
        end

        if SceneCity.m_tButtonTipsAnim2 then
            SceneCity.m_tButtonTipsAnim2:removeFromParentAndCleanup(true)
            SceneCity.m_tButtonTipsDialog2:removeFromParentAndCleanup(true)
            SceneCity.m_tButtonTipsAnim2, SceneCity.m_tButtonTipsDialog2 = nil, nil
            SceneCity.m_bIsTipsAppear2 = nil
        end
    end
    SceneCity.m_nTime = dt
    --WZLog("SceneCity:loop zero-7", tostring(CopyManager:curLevelChallengeState()))
    if SceneCity.m_root and WindowManager:isHaveTeachTouchLayer() ~= true and WndTeachTalk.m_root == nil and CacheCenter:getPlayerInfo() and CacheCenter:getPlayerInfo().level >= 1 and CacheCenter:getPlayerInfo().level <= 11 then
        SceneCity.m_nTime = dt

        --WZLog("SceneCity:loop zero-0", SceneCity.m_nTime, tostring(SceneCity.m_bIsTipsAppear1), tostring(SceneCity.m_tButtonTipsAnim1), tostring(SceneCity.m_tButtonTipsDialog1))
        if --[[SceneCity.m_nTime >= 20 and SceneCity.m_nTime < 24 and]] SceneCity.m_bIsTipsAppear1 == nil and CopyManager:curLevelChallengeState() and SceneCity.m_tButtonTipsAnim3 == nil then
            SceneCity.m_bIsTipsAppear1 = true
            if SceneCity.m_tButtonTipsAnim1 == nil then
                local btn = GetElementWithoutAssert(SceneCity.m_root, "building2", WZUIImage)
                SceneCity.m_tButtonTipsAnim1, SceneCity.m_tButtonTipsDialog1 = WindowManager:addTipForButton(btn, 0.85, GlobalMethod:ccp(45,-120), 86, 4, GlobalMethod:ccp(130,60), 2.4,nil,nil, true)
                WZLog("SceneCity:loop zero-1")
            else
                SceneCity.m_tButtonTipsAnim1:setVisible(true)
                SceneCity.m_tButtonTipsDialog1:setVisible(true)
                WZLog("SceneCity:loop zero-2")
            end
        end

        if (--[[SceneCity.m_nTime >= 24 
            or ]]CopyManager:curLevelChallengeState() ~= true or SceneCity.m_tButtonTipsAnim3 ~= nil
            ) and SceneCity.m_bIsTipsAppear1 == true then
            SceneCity.m_tButtonTipsAnim1:removeFromParentAndCleanup(true)
            SceneCity.m_tButtonTipsDialog1:removeFromParentAndCleanup(true)
            SceneCity.m_tButtonTipsAnim1, SceneCity.m_tButtonTipsDialog1 = nil, nil
            SceneCity.m_bIsTipsAppear1 = nil
            WZLog("SceneCity:loop zero-3")
        end

        if false and SceneCity.m_nTime >= 5 and SceneCity.m_nTime < 10 and SceneCity.m_bIsTipsAppear2 == nil and SceneCity.m_tWndBottomBarObj and SceneCity.m_tWndBottomBarObj.m_nMoveDirection == 1 then
            SceneCity.m_bIsTipsAppear2 = true
            if SceneCity.m_tButtonTipsAnim2 == nil and SceneCity.m_tWndBottomBarObj then
                local btn = GetElementWithoutAssert(SceneCity.m_tWndBottomBarObj.m_root, "btnTask_WndBottomBar", WZUIButton)
                SceneCity.m_tButtonTipsAnim2, SceneCity.m_tButtonTipsDialog2 = WindowManager:addTipForButton(btn, 0.30, GlobalMethod:ccp(50,-10), 87, 4, GlobalMethod:ccp(0,0))
                WZLog("SceneCity:loop zero-4")
            else
                SceneCity.m_tButtonTipsAnim2:setVisible(true)
                SceneCity.m_tButtonTipsDialog2:setVisible(true)
                WZLog("SceneCity:loop zero-5")
            end
        end

        if SceneCity.m_bIsTipsAppear2 == true and SceneCity.m_tButtonTipsAnim2 and (SceneCity.m_nTime >= 10 or (SceneCity.m_tWndBottomBarObj and  SceneCity.m_tWndBottomBarObj.m_nMoveDirection == 0)) then
            SceneCity.m_tButtonTipsAnim2:removeFromParentAndCleanup(true)
            SceneCity.m_tButtonTipsDialog2:removeFromParentAndCleanup(true)
            SceneCity.m_tButtonTipsAnim2, SceneCity.m_tButtonTipsDialog2 = nil, nil
            SceneCity.m_bIsTipsAppear2 = nil
        end
    end

    if SceneCity.m_nTime >= 30 then
        SceneCity.m_nTime = 0
        SceneCity.m_nStartTime = ostime
    end

    if false and SceneCity.m_root and SceneCity.m_bIsUpdateBoat == nil then
        local boat = GetElementWithoutAssert(SceneCity.m_root, "armaBoat1_SceneCity", WZArmature)

        if boat then
            WZLog("SceneCity:_updateScheduleX1", tostring(boat:getArmature()))
            local armature = boat:getArmature()

            local boat2 = GetElementWithoutAssert(SceneCity.m_root, "armaBoat2_SceneCity", WZArmature)
            local armature2 = boat:getArmature()
            if armature then

                local bone = armature:getBoneRecursively("boat")
                local bone2 = armature2:getBoneRecursively("boat")
                WZLog("SceneCity:_updateScheduleX2", tostring(bone))
                if bone == nil then return end
                bone = tolua.cast(bone,"CCBone")
                armature = bone:getChildArmature()
                bone2 = tolua.cast(bone2,"CCBone")
                armature2 = bone2:getChildArmature()
                WZLog("SceneCity:_updateScheduleX3", tostring(armature))
                if armature == nil then return end
                SceneCity.m_bIsUpdateBoat = 1
                armature:getAnimation():playByIndex("0",-1,-1,1);
                armature2:getAnimation():playByIndex("0",-1,-1,1);
            end
        end
    end

    if SceneCity.m_root and SceneCity.m_bIsUpdateHudie == nil and SceneCity.m_bIsHudieMove == nil then
        local Hudie = GetElementWithoutAssert(SceneCity.m_root, "armaHudie1_SceneCity", WZArmature)
        if Hudie then
            --WZLog("SceneCity:_updateScheduleY1", tostring(Hudie:getArmature()))
            local armature = Hudie:getArmature()

            local Hudie2 = GetElementWithoutAssert(SceneCity.m_root, "armaHudie2_SceneCity", WZArmature)
            local armature2 = Hudie:getArmature()
            if armature then

                local bone = armature:getBoneRecursively("hudie_4")
                local bone2 = armature2:getBoneRecursively("hudie_4")
                --WZLog("SceneCity:_updateScheduleY2", tostring(bone))
                if bone == nil then return end
                bone = tolua.cast(bone,"CCBone")
                armature = bone:getChildArmature()
                bone2 = tolua.cast(bone2,"CCBone")
                armature2 = bone2:getChildArmature()
                --WZLog("SceneCity:_updateScheduleY3", tostring(armature))
                if armature == nil then return end
                SceneCity.m_bIsUpdateHudie = 1
                armature:getAnimation():playByIndex("0",-1,-1,1);
                armature2:getAnimation():playByIndex("0",-1,-1,1);
                WZLog("SceneCity:_updateSchedule zero", tostring(SceneCity.m_bIsHudieMove))
            end
        end
    end

    SceneCity:matchLight()

    --WZLog("SceneCity:_updateSchedule x111", SceneCity.m_nTime, "m_nCheckOpenTreeTime", SceneCity.m_nCheckOpenTreeTime, "ostime", ostime)
    if SceneCity.m_nTime and SceneCity.m_nTime ~= 0 and SceneCity.m_nTime % 3 == 0 and (ostime ~= SceneCity.m_nCheckOpenTreeTime) then
        SceneCity.m_nCheckOpenTreeTime = ostime
        SceneCity:openTree(WndApartmentAct:isSeckillOn())
        
        if WndOwnCity.checkSevenDay then
            WndOwnCity:checkSevenDay()
        end
    end

    --时间到，关闭调研按钮
    if GlobalGame.g_questionOpen then 
        --获取调研结束时间戳
        if SceneCity.m_nQuestionEndTime == nil then 
            local sConfig = CacheCenter:getGameParam().researchDate
            local tQuestionConfig = json.decode(sConfig)
            local date = SplitStringWithSeparator(tQuestionConfig.endDate, "-", nil, true)
            SceneCity.m_nQuestionEndTime = os.time({year = date[1], month = date[2], day = date[3], hour = 23, min = 59, sec = 59})
            WZLog("SceneCity:loop", type(SceneCity.m_nQuestionEndTime), SceneCity.m_nQuestionEndTime)
        end
        if WndAnswerSurvey.m_root == nil and ostime >= SceneCity.m_nQuestionEndTime then 
            GlobalGame.g_questionOpen = false 
            WndOwnCity:openQuestion(GlobalGame.g_questionOpen)
        end
    end
    SceneCity:closeLouyixiaoActivity()
    --处理越南pulse发送事件
    SceneCity:sendVNPulseEvent()
end

--@brief    清除没用的动画和加载需要的动画
function SceneCity:reloadAnimation()
    CCArmatureDataManager:sharedArmatureDataManager():removeAll()
end

------获取元素

--@brief    获取NoBorderCon
--@return   NoBorderCon
--@note
function SceneCity:getNoBorderCon()
    if self.m_root then
        return GetElement(self.m_root,"conNoBorder_SceneCity",WZUIContainer)
    end
end

--@brief    获取背景Layer
--@return   背景Layer
--@note
function SceneCity:getBgLayer()
    if self.m_root then
        return GetElement(self.m_root,"conBgLayer_SceneCity",WZUIContainer)
    end
end

--@brief    获取背景装饰Layer
--@return   背景Layer
--@note
function SceneCity:getBgAdornLayer()
    if self.m_root then
        return GetElement(self.m_root,"conBgAdornLayer_SceneCity",WZUIContainer)
    end
end

--@brief    获取建筑Layer
--@return   建筑Layer
--@note
function SceneCity:getBuildLayer()
    if self.m_root then
        return GetElement(self.m_root,"conBtn_SceneCityScene",WZUIContainer)
    end
end

--@brief    获取建筑动画Layer
--@return   建筑动画Layer
--@note
function SceneCity:getBuildAniLayer()
    if self.m_root then
        return GetElement(self.m_root,"conBuildAniLayer_SceneCity",WZUIContainer)
    end
end

--@brief    获取人物Layer
--@return   人物Layer
--@note
function SceneCity:getFigureLayer()
    if self.m_root then
        return self.m_tPlayerLayer
        --return GetElement(self.m_root,"conFigureLayer_SceneCity",WZUIContainer)
    end
end

--@brief    获取UILayer
--@return   UILayer
--@note
function SceneCity:getUILayer()
    if self.m_root then
        return GetElement(self.m_root,"conUILayer_SceneCity",WZUIContainer)
    end
end

--@brief    获取Top信息层Layer
--@return   Top信息层Layer
--@note     存放一些信息在整个场景的最上层
function SceneCity:getTopInfoLayer()
    if self.m_root then
        return GetElement(self.m_root,"conTopInfoLayer_SceneCity",WZUIContainer)
    end
end

--@brief    获取Top动画Layer
--@return   Top动画Layer
--@note     存放一些动画在整个场景的最上层
function SceneCity:getTopInfoLayer()
    if self.m_root then
        return GetElement(self.m_root,"conTopAniLayer_SceneCity",WZUIContainer)
    end
end

--@brief    获取Loop
--@return   Loop
--@note
function SceneCity:getLoop()
    return self.m_loop
end

--@brief    获取Touch
--@return   Touch
--@note
function SceneCity:getTouch()
    return self.m_touch
end

--@brief    人物升级后更新小岛界面
function SceneCity:updateForUpgrade()
    WZLog("人物升级后更新小岛界面")
    if self.m_root == nil then
        return
    end

    WndRightMenu:updateForUpgrade()
    WndLeftMenu:updateForUpgrade()
    WndBottomMenu:updateForUpgrade()
    WndActivityMenu:updateForUpgrade()
    WndRightMoreMenu:updateForUpgrade()
    WndLeftBox:updateForUpgrade()

    self:_update()
end

local tempPt = GlobalMethod:ccp(0,0)
--@brief    更新排位赛冠军雕像
function SceneCity:updateQualifyingStatue()
    WZLog("SceneCity:updateQualifyingStatue")
    local layer = SceneCity:getBuildLayer()
    local cellStatue = GetElementWithoutAssert(layer, "CellQualifyingStatue")
    if cellStatue == nil then
        cellStatue = CreateElement("CellQualifyingStatue")
        layer:addChild(cellStatue)
        cellStatue:setPositionX(880)
        cellStatue:setPositionY(260)
        
        local txtTitle = GetElement(cellStatue, "txtTitle_CellQualifyingStatue", WZUILabelTTF)
        txtTitle:setText("排位赛冠军")
    end
    local conPlayer = GetElement(cellStatue, "conPlayer_CellQualifyingStatue")
    conPlayer:removeAllChildrenWithCleanup(true)
    --local playerSprite = AnimationManager:createRoleForShop(0, {bhead = "bhead8", bbody = "bbody8", bface = "bface8", weapon = "weapon15a", wing="wing1"}, "room")
    --conPlayer:addChild(playerSprite)
    local txtName = GetElement(cellStatue, "txtName_CellQualifyingStatue", WZUILabelTTF)
    txtName:setText("啊啊啊啊啊啊啊")
end

--@brief  检测是否需要下载
function SceneCity:checkIsNeedDownload()
    -- body
    if CacheCenter:getPlayerInfo() == nil then
        return
    end
    WZLog("###### playerId=" .. CacheCenter:getPlayerInfo().level)
    SavePlayerLevel(CacheCenter:getPlayerInfo().level)
    local extendLastestVer = WZUpdateManager:getInstance():getExtendUpdateVersion()  --当前更新到的增量包版本
    WZLog("extendLastestVer",extendLastestVer)
    if ProjConfig.USE_DOWNLOAD == 1 then
        --WZLog("GYQ",CacheCenter:getPlayerInfo().level,ProjConfig.EXTEND_LEVEL)

        if false and ProjConfig.ISOPEN_EXTEND == 1 then
            if self:downloadType() and extendLastestVer < "1.0.1.0" then
                WndDownLoad.bIsPopDownloadTips = true
             GlobalGame.g_bIsHasDownload = false
              WZLog("SceneCity:checkIsNeedDownload")
             --MsgBoxManager:showConfirmBox(LocalStrings.NEED_DOWNLOAD_TIPS_V16, self, self.downloadTipCallback, MSGBOXLEVEL_NORMAL, nil)
             WndDownloadReward:showDownloadReward()
             WndDownloadReward:closeCallBack(self,self.downloadTipCallback)
             return           
            end

            GlobalGame.g_bIsHasDownload = true
            WZLog("下载奖励框弹出条件：",GlobalGame.g_bIsHasDownload,CCUserDefault:sharedUserDefault():getBoolForKey("isGetDownloadReward"),self:downloadType(),GlobalGame.g_tDownloadReward.status)
            if GlobalGame.g_bIsHasDownload and CCUserDefault:sharedUserDefault():getBoolForKey("isGetDownloadReward")~=true and self:downloadType() then 
                CCUserDefault:sharedUserDefault():setBoolForKey("isGetDownloadReward",true)
                
                --WndRewardShow:showById(GlobalGame.g_tDownloadReward.rewardItemsId,GlobalGame.g_tDownloadReward.rewardItemsNum)
            end
            WZLog("gyq---------------++++++++111",GlobalGame.g_tPlayerInfo.nLevel,extendLastestVer)
        end
        
    end  
end

function SceneCity:downloadType()
    if CacheCenter.m_tPlayerInfo.zsLevel~=nil and CacheCenter.m_tPlayerInfo.zsLevel > 0 then
        WZLog("下载等级判断 转生判断",CacheCenter.m_tPlayerInfo.zsLevel)
        SavePlayerLevel(CacheCenter:getPlayerInfo().level+99)
        return true
    elseif ProjConfig.EXTEND_LEVEL~=nil and CacheCenter.m_tPlayerInfo.level >= ProjConfig.EXTEND_LEVEL then
        SavePlayerLevel(CacheCenter:getPlayerInfo().level)
        WZLog("下载等级判断等级判断",CacheCenter.m_tPlayerInfo.level)
        return true
    else
        return false
    end
end
--@brief    下载点击回调
--@param    nType，按钮类型，关闭，取消，确定
--@param    nId，按钮id
function SceneCity:downloadTipCallback(nId,nType)
    IPDConnector.g_nNetConnectFlag = NET_FLAG_1
    if nType == MSGBOXRESTYPE_CONFIRM then
        gotoFirstScene()
    else
       gotoFirstScene()
    end
      
end

--@brief    根据设置判断是否显示任务快捷栏
function SceneCity:setTaskQuickVisible(nValue)
    -- body
    if self.m_root == nil then return end 
    if self.m_tWndBottomBarObj == nil then return end 

    self.m_tWndBottomBarObj:setQuickTaskVisible(nValue)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

local buildOpenList =
{
    ISLAND_BUILDING_HALL,
    ISLAND_BUILDING_SHOP,
}

--@brief	检查建筑物功能是否开放
--@param    nBtnId, 按钮id
--@return   #1, 是否开放
function SceneCity:_checkBuildingOpen(nBtnId)

    if self.m_tBtnsInfo then
        for i,v in ipairs(self.m_tBtnsInfo) do
            WZLog(v.buttonId)
            if v.buttonId == nBtnId then
                WZLog(v.buttonId)
                local bFlag = self:ifBuildingOpen(v)
                if bFlag == false then
                    WZLog("SceneCity:_checkBuildingOpen", tostring(v.buttonTips))
                    MsgBoxManager:showTipBox(v.buttonTips)
                end
                return bFlag
            end
        end
    end
    return true
end

--@brief	建筑物是否开放(可以进入功能模块)
--@param    tButtonInfo, 按钮信息表
--@return   #1, 是否开放
function SceneCity:ifBuildingOpen(tButtonInfo)
    if TeachGroup1.ISTEACHMODE then return true end
    if CacheCenter.m_tPlayerInfo == nil then
        return nil
    end
    if self.root then
        return false
    end
    --WZLog("SceneCity:ifBuildingOpen", CacheCenter.m_tPlayerInfo.level, tButtonInfo.buttonStatus3Level, tButtonInfo.buttonId)
    --转生过都开放
    if GlobalGame:getSecretNumberData("player_level") > GlobalGame.g_ReincPlayerLeve then
        return true
    end

    if GlobalGame:getSecretNumberData("player_level") and tButtonInfo.buttonStatus3Level and
        GlobalGame:getSecretNumberData("player_level") < tButtonInfo.buttonStatus3Level then
        return false
    else
        return true
    end
end

--@brief    建筑物是否显示(可以显示功能模块)
--@param    tButtonInfo, 按钮信息表
--@return   #1, 是否开放
function SceneCity:checkIconButtonOpen(tButtonInfo)
    --转生过都开放
    if CacheCenter.m_tPlayerInfo.level > GlobalGame.g_ReincPlayerLeve then
        return true
    end

    if GlobalGame:getSecretNumberData("player_level") and tButtonInfo.buttonStatus1Level and
        GlobalGame:getSecretNumberData("player_level") < tButtonInfo.buttonStatus1Level then
        return false
    else
        return true
    end
end


--@brief    打开全屏界面的时候调用，这个时候可以隐藏主城界面
function SceneCity:unsivibleWithFullScreenWnd()
    --SceneCity.m_currentFullScreenCount = SceneCity.m_currentFullScreenCount + 1
    WZLog("SceneCity:pushFullScreenWindow")
    if self.m_root ~= nil then 
        WZLog("SceneCity:pushFullScreenWindow 1")
        local scene = WZUIScene:luaTo(self.m_root:getChildElement("conBgLayer_SceneCity"))
        if scene ~= nil then 
            scene:setVisible(false)
             --越南语渠道那里悬浮窗的控制
            if WGameCmUtil:GetBundleIdentifier() == "com.wyd.gunpow" then
                local sdkTab = {}
                sdkTab.funType = "hideButton"
                PassportSdkManager:Others(sdkTab)
            end
        end
        local con = WZUIContainer:luaTo(self.m_root:getChildElement("conBgAdornLayer_SceneCity"))
        if con ~= nil then 
            con:setVisible(false)
        end
        con = WZUIContainer:luaTo(self.m_root:getChildElement("conBuildAniLayer_SceneCity"))
        if con ~= nil then 
            con:setVisible(false)
        end
        con = WZUIContainer:luaTo(self.m_root:getChildElement("conFigureLayer_SceneCity"))
        if con ~= nil then 
            con:setVisible(false)
        end
        con = WZUIContainer:luaTo(self.m_root:getChildElement("conTopInfoLayer_SceneCity"))
        if con ~= nil then 
            con:setVisible(false)
        end
        if WndOwnCity.m_root ~= nil then 
            WndOwnCity.m_root:setVisible(false)
        end
    end
    if SceneRoom.m_root ~= nil then 
        local con = WZUIContainer:luaTo(SceneRoom.m_root:getChildElement("conRight_SceneRoom"))
        if con ~= nil then con:setVisible(false) end
        con = WZUIContainer:luaTo(SceneRoom.m_root:getChildElement("conBg_SceneRoom"))
        if con ~= nil then con:setVisible(false) end
        con = WZUIContainer:luaTo(SceneRoom.m_root:getChildElement("conMiddle_SceneRoom"))
        if con ~= nil then con:setVisible(false) end
    end
    -- if SceneBossRoom.m_root then
    --     local con = GetElement(SceneBossRoom.m_root,"conFrame_SceneBossRoom",WZUIContainer)
    --     con:setVisible(false)
    -- end
    if SceneHall.m_root then
        local con = GetElement(SceneHall.m_root,"conMain_SceneHall",WZUIContainer)
        con:setVisible(false)
    end
    if SceneCopy.m_root then
        local con = GetElement(SceneCopy.m_root,"conMain_SceneCopy",WZUIContainer)
        con:setVisible(false)
    end
end

--@brief    关闭全屏界面的时候调用，这个时候可以隐藏主城界面
function SceneCity:visibleWithoutFullScreenWnd()
    --SceneCity.m_currentFullScreenCount = SceneCity.m_currentFullScreenCount - 1
    WZLog("SceneCity:popFullScreenWindow")
    
    if self.m_root ~= nil then
        local scene = WZUIScene:luaTo(self.m_root:getChildElement("conBgLayer_SceneCity"))
        if scene ~= nil and scene:isVisible() ~= true then 
            scene:setVisible(true)
            WndOwnCity:setPlayerInfoCache(nil, true) 
            --越南语渠道那里悬浮窗的控制
            if WGameCmUtil:GetBundleIdentifier() == "com.wyd.gunpow" then
                local sdkTab = {}
                sdkTab.funType = "showButton"
                PassportSdkManager:Others(sdkTab)
            end
        end
        local con = WZUIContainer:luaTo(self.m_root:getChildElement("conBgAdornLayer_SceneCity"))
        if con ~= nil then 
            con:setVisible(true)
        end
        con = WZUIContainer:luaTo(self.m_root:getChildElement("conBuildAniLayer_SceneCity"))
        if con ~= nil then 
            con:setVisible(true)
        end
        con = WZUIContainer:luaTo(self.m_root:getChildElement("conFigureLayer_SceneCity"))
        if con ~= nil then 
            con:setVisible(true)
        end
        con = WZUIContainer:luaTo(self.m_root:getChildElement("conTopInfoLayer_SceneCity"))
        if con ~= nil then 
            con:setVisible(true)
        end
        if WndOwnCity.m_root ~= nil then 
            WndOwnCity.m_root:setVisible(true)
        end
    end
    
    if SceneRoom.m_root ~= nil then 
        local con = WZUIContainer:luaTo(SceneRoom.m_root:getChildElement("conRight_SceneRoom"))
        if con ~= nil then con:setVisible(true) end
        con = WZUIContainer:luaTo(SceneRoom.m_root:getChildElement("conBg_SceneRoom"))
        if con ~= nil then con:setVisible(true) end
        con = WZUIContainer:luaTo(SceneRoom.m_root:getChildElement("conMiddle_SceneRoom"))
        if con ~= nil then con:setVisible(true) end
    end

    -- if SceneBossRoom.m_root then
    --     local con = GetElement(SceneBossRoom.m_root,"conFrame_SceneBossRoom",WZUIContainer)
    --     con:setVisible(true)
    -- end

    if SceneHall.m_root then
        local con = GetElement(SceneHall.m_root,"conMain_SceneHall",WZUIContainer)
        con:setVisible(true)
    end

    if SceneCopy.m_root then
        local con = GetElement(SceneCopy.m_root,"conMain_SceneCopy",WZUIContainer)
        con:setVisible(true)
    end
end

--@brief    添加竞技目标气泡
--@param    #1将节点添加到的父节点
--@param    #2等级
--@param    #3等级数字X锚点
function SceneCity:createCompetitiveGoal(bFlag)
	WZLog("SceneCity:createCompetitiveGoal")
	local element = GetElement(self.m_root,"building5",WZUIImage)

    if true or element == nil then
        return
    end
	--删除重复节点
	if element:getChildByTag(666) then
		element:removeChildByTag(666,true)
	end
	if element:getChildByTag(6) then
		element:removeChildByTag(6,true)
	end

	if bFlag == false then return end

    --LV标记
    local imgBg = WZUIImage:create()
    imgBg:setFile("ui/common/common_scale9_kk.png")
    imgBg:setUseOriginSize(true)
    imgBg:setAnchorPoint(GlobalMethod:ccp(0.5, 0.5))
    imgBg:setRelativePosition(GlobalMethod:ccp(0.5, 2.32))
    element:addChild(imgBg,6,6)

    --等级值
    local atlasLevel = WZUILabelTTF:create()
	atlasLevel:setColor(GlobalMethod:ccc3(127,70,26))
	atlasLevel:setBoldFont(true)
	atlasLevel:setFontSize(26)
    if ProjConfig.LANGUAGE == "vn" then
        atlasLevel:setFontSize(18)
    elseif ProjConfig.LANGUAGE == "tr" then
        atlasLevel:setFontSize(18)
        atlasLevel:setDimensions(GlobalMethod:CCSize(250,0))
    end
    atlasLevel:setAnchorPoint(GlobalMethod:ccp(0.5, 0.5))
    atlasLevel:setRelativePosition(GlobalMethod:ccp(0.5, 2.39))
    atlasLevel:setText(LocalStrings.HALL_01)
    element:addChild(atlasLevel,666,666)
end

--@brief    播放视频
function SceneCity:playMovie()
    WZLog("SceneCity:playMovie")
    self:saveMovieRecord()
    SoundManager:stopBgMusic()
    local platForm =  WZUISystem:getInstance():getPlatformInfo()
    if platForm == 2 then --android
        self.t_utilsAdapter = WydPlAdapterManager:sharedWydPlAdapterManager():createAdapter("org/cocos2dx/hellolua/DandandaoUtils")
     elseif platForm == 1 then -- ios
        self.t_utilsAdapter = WydPlAdapterManager:sharedWydPlAdapterManager():createAdapter("DandandaoUtils")
     end
    local filePath = "vedio/citylogo.mp4"
    filePath = CCFileUtils:sharedFileUtils():fullPathForFilename(filePath)
    local callback = WZAdapterCallback:create(SceneCity.logoOver, SceneCity)
    if self.t_utilsAdapter ~= nil then 
        self.t_utilsAdapter:callMethodByName("playLogo",callback,filePath)
    else
        self:logoOver()
    end

end

--@brief    播放完视频
function SceneCity:logoOver()
    WZLog("SceneCity:logoOver")
    if self.t_utilsAdapter ~= nil then 
        WydPlAdapterManager:sharedWydPlAdapterManager():destroyAdapter(self.t_utilsAdapter:getId())
        self.t_utilsAdapter = nil
        SoundManager:playBgMusic(SoundDefine.E_MUSIC_ISLAND)
        AudioManager:_refreshBackgroundMusic()
    end

    GetElement(self.m_root, "imgBlack_SceneCity", WZUIImage):setVisible(false)
    self:checkPopupWindow()
end

--@brief    保存播放视频记录
function SceneCity:saveMovieRecord()
    local data = WZDataFile:getInstance():getUserData()
    if data ~= nil then
        data:setStringValue("saveMovieRecord", "id_" .. CacheCenter:getPlayerInfo().id, 1)
        data:flush()
        WZLog("SceneCity:saveMovieRecord", "id_" .. CacheCenter:getPlayerInfo().id)
    end
end

--@brief    读取播放视频记录
function SceneCity:getMovieRecord()
    local data = WZDataFile:getInstance():getUserData()
    if nil == data then
        return false
    end
    local value = data:getStringValue("saveMovieRecord", "id_" .. CacheCenter:getPlayerInfo().id)
    WZLog("SceneCity:getMovieRecord",value, type(value))
    if value == nil or value == "" or value == "0" then
        value = false
    elseif value == "1" then
        value = true
    end
    return value
end

--@brief    不显示娄艺潇活动
function SceneCity:closeLouyixiaoActivity()
    -- body
    if self.m_root == nil then return end 
--    WZLog("SceneCity:closeLouyixiaoActivity", tostring(ProjConfig:getChannelId()))
    if whetherCloseRecharge() then
        GetElement(self.m_root, "building132_SceneCity", WZUIButton):setVisible(false)
        GetElementWithoutAssert(self.m_root, "building132" , WZUIImage):setVisible(false)
    end
end

--@brief    点击冒险入口事件
function SceneCity:_postCopyShipEvent()
    -- body
    local level = CacheCenter:getPlayerInfo().level
    if level >= 1 and level <= 10 then 
        local eventKey = PostPlayerEvent["event_clickCopyShip" .. level]
        if eventKey then 
            PostPlayerEvent:postEvent(eventKey)    
        end
    end
end

--@brief    返回主城显示福利事件
function SceneCity:_postBackToCityEvent()
    -- body
    local level = CacheCenter:getPlayerInfo().level
    if level == 6 or level == 7 then 
        local eventKey = PostPlayerEvent["event_beInCityShowWelfare" .. level]
        if eventKey then 
            PostPlayerEvent:postEvent(eventKey)    
        end
    end
end

--@brief    计时器
function SceneCity:sendVNPulseEvent()
    if ProjConfig.LANGUAGE ~= "vn" then return end 

    if not GlobalGame.g_bSendEventPerMinite then 
        if not self.m_bIsDoSendEvent then 
            self.m_bIsDoSendEvent = true 
            GlobalGame.g_bSendEventPerMinite = true 
        end
    end

    if self.m_bIsDoSendEvent and GlobalGame.g_bSendEventPerMinite then 
        local nCurTime = SystemTime:getServerTime()
        if nCurTime - GlobalGame.g_nLoginInCityTime >= 60 then 
            GlobalGame.g_nLoginInCityTime = nCurTime 
            if PassportSdkManager.postGameInfoVn then
                PassportSdkManager:postGameInfoVn("pulse", "")
            end
        end
    end
end
-------------------------------------私有方法模块End----------------------------------------
function SceneCity:_adaptLanguage_vn(  )
    for i, value in pairs(GDatatab_Teach) do
        if value.group == 42 then 
            value.force = 19
        elseif value.group == 43 then 
            value.force = 24
        elseif value.group == 44 then 
            value.force = 30
        end
    end
end