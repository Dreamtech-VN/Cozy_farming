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
    CCDirector:sharedDirector():setAnimationInterval(1.0/30)
    CacheCenter:registerUpatePlayerInfoObserver(self)
    ChangeChatChannel(Chat_Channel_Island)

    PostPlayerEvent:postEvent(PostPlayerEvent.event_loadingToCity)
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
    self.m_root:addChild(wndBottomBar)
    wndBottomBarObj:setNeedMoveVerticalBar(true)
    wndBottomBarObj:setNeedChat(true)
    --wndBottomBarObj:onClickSwitch()
    

    CacheCenter:updateRedPoint("left",wndBottomBar,nil,1)
    local wndOwnCity = WndOwnCity:createElement()
    WndOwnCity:setScene(self)
    self.m_root:addChild(wndOwnCity)

    CacheCenter:updateRedPoint("left",WndOwnCity.m_root,nil,1)
    CacheCenter:updateRedPoint("right",wndBottomBar,nil,2)
    
    --CreateStoryTalkGroup(101)

    self.m_bAutoInit = false
end

--@brief	删除多余的资源
function SceneCity:onEnterTransitionDidFinish(element)
    --WZLog("SceneCity:onEnterTransitionDidFinish", self.m_scheduleId, self.m_scheduleLoopId)
    if PassportSdkManager:getLogoutState() then
        PassportSdkManager:setLogoutState(false)
        WndLoginSelect:loginOutGame()
        return
    end

    --鲜花榜协议
    Protocol:reg( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GiveFlowerOk, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GiveFlowerOk", "t")

    local className = "AMapSceneController"
    if WZUISystem:getInstance():getPlatformInfo() == 2 then
        className = "com/baiduMap/MapSceneController"
    end
    local adapter = WydPlAdapterManager:sharedWydPlAdapterManager():createAdapter(className)
    
    if adapter then
        adapter:callMethodByName("enterGame", nil, "")
        WydPlAdapterManager:sharedWydPlAdapterManager():destroyAdapter(adapter:getId())
    end

    ProtocolProcessorWndEquipmentRaffle:send_EQUIP_GetFreeTime()

	--个人空间开启时获取自己位置
	-- if CheckButtonShow(60) and CheckButtonOpen(60,false) then
	-- 	local result = WZLocation:getInstance():getCurrentCoordinate()
	-- 	WZLog("result:",result)
	-- 	if result ~=  nil then
	-- 		local resultTable = json.decode(result)
	-- 		if resultTable.result == "true" then
	-- 			ProtocolProcessorWndSpace:send_SPACE_UpdateGPSInfo(CacheCenter:getPlayerInfo().id , resultTable.Longitude*100000, resultTable.Latitude*100000 )
	-- 		end
	-- 	end
	-- end
    
    CCTextureCache:sharedTextureCache():removeUnusedTextures()
    self:addTextureCache()

    if self.m_scheduleId == -1 then
        self.m_scheduleId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(self.updateSchedule, 0, false)
    end

    if self.m_scheduleLoopId == -1 then
        self.m_scheduleLoopId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(self.loop, 0, false)
    end

    if self.m_secondScheduleId == -1 then
        self.m_secondScheduleId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(self.updateSecond,1,false)
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

    SceneCity.m_bIsOpenWorldBoss = nil
    if not isEnterTeach then
        if self.m_bFromChurch then
            WndMarryManager:initManager()
            WndMarryManager:createLoading()
            self.m_bFromChurch = false
        end
    end

   
    ProtocolProcessorGlobal:send_SINGLEMAP_GetPoints(0)

    ProtocolProcessorScenePvpRank:regAll()
    ProtocolProcessorScenePvpRank:send_RANKMATCH_GetStatueInfo()
    --安智悬浮窗的显示
    PassportSdkManager:doAnzhiOthers("showFloatButton")

    --GlobalGame.m_bIsSendMaterGetTemple = true
    --ProtocolProcessorWndMaster:send_MENTORING_GetTemple()
    ProtocolProcessorWndBag:send_PLAYER_GetPlayerInfo(CacheCenter:getPlayerInfo().id )

    ProtocolProcessorWndLeague:send_HERO_HeroStartTime()
    ProtocolProcessorDigGem:regAll()
    ProtocolProcessorDigGem:send_MINING_GetMining()
    if tostring(ProjConfig:getChannelId()) ~= "53" and tostring(ProjConfig:getChannelId()) ~= "75" and tostring(ProjConfig:getChannelId()) ~= "275" then
        ProtocolProcessorCommonPush:send_COMMONPUSH_GetStoredDirectionalPush(ProjConfig.CHANNEL_ID)
    end
    ProtocolProcessorWndRuneDraw:regAll()

    --禁忌之地宝箱倒计时 
    if CheckButtonOpen(TABOO_BATTLE,false) then
        ProtocolProcessorGlobal:send_ZONE_GetBoxInfo( )
    end

    --一些渠道隐藏掉娄艺潇活动入口
    self:closeLouyixiaoActivity()

    getNewOnlineRewardState()


    
end

--@brief    是否活动弹框
function SceneCity:checkPopupWindow()
    local isEnterTeach = false
    if self.m_bIsWndCopyTop == nil and self:teach() == false and WndUpgrade.m_root == nil 
        --and ProjConfig.DEBUG ~= 1 
        then
        self.m_bIsNoTeach = true
        
        if GlobalGame.g_checkLoginActivities  then
            isEnterTeach = true
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
            --    WndWelfare:showInterface(1, 79)
            end
        elseif SceneCity.m_bIsOpenWorldBoss then
            self:onBuildClickWorldBoss()
        end
    end
end

--@brief    从副本出来检查是否弹框
function SceneCity:checkWelfare()
    if self:teach() == false then
        self.m_bIsNoTeach = true
        WZLog("SceneCity:checkWelfare three", GlobalGame.g_checkLoginActivities)
        if GlobalGame.g_checkLoginActivities  then
            isEnterTeach = true
            self:JoinByLogin()
        end
        local NextDayState = CacheCenter:isNewDay("SignIn")
        if NextDayState.state then
            CacheCenter:resetNewDayState("SignIn")
            if WndGameSingIn.m_root == nil then 
                WndGameSingIn.m_bNeedSendProtocol = true 
                WZLog("SceneCity:checkWelfare 11111")
                WndWelfare:showInterface(1, 79)
            end
        elseif SceneCity.m_bIsOpenWorldBoss then
            self:onBuildClickWorldBoss()
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
    elseif openTeach == 13 and (lv == 20 or TeachGroup1.ISTEACHMODE) then
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
        GlobalGame.g_nMoveEndPointXNowMoveElement = -381 * (FigureSceneManager:getInstance().m_nScreenWidth - 1517) / (1136 - 1517)
    elseif openTeach == 24 and (lv == 21 or TeachGroup1.ISTEACHMODE) then
        GlobalGame.g_nMoveEndPointXNowMoveElement = 750 / 1136 * FigureSceneManager:getInstance().m_nScreenWidth
    --    GlobalGame.g_nMoveEndPointXNowMoveElement = -200 * (FigureSceneManager:getInstance().m_nScreenWidth - 1517) / (1136 - 1517)
    elseif openTeach == 26 and (TeachGroup1:isTaskTeachFinish(TeachGroup1.TASK_ID_7) or TeachGroup1.ISTEACHMODE) then
        GlobalGame.g_nMoveEndPointXNowMoveElement = 750 / 1136 * FigureSceneManager:getInstance().m_nScreenWidth
    elseif (openTeach == 28 and (lv == 25 or TeachGroup1.ISTEACHMODE)) or (openTeach == 49 and (lv == 28 or TeachGroup1.ISTEACHMODE)) then
        GlobalGame.g_nMoveEndPointXNowMoveElement = nil
    elseif openTeach == 41 and (lv == 9 or TeachGroup1.ISTEACHMODE) or openTeach == 42 and (lv == 24 or TeachGroup1.ISTEACHMODE) then
        GlobalGame.g_nMoveEndPointXNowMoveElement = nil --500 / 1136 * FigureSceneManager:getInstance().m_nScreenWidth
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

        local stepList = {44,49,19,28,42,48,14,24,22,13,43,11,10,-37,29,23,15,12,16,26,41,20,40,39,36,35,34,33,32,31,9,8,7,5,1,3}
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
                    if (i == 22 and CheckButtonOpen(20,false)) or 
                        (i == 43 and CheckButtonOpen(ISLAND_EXTEND_PRACTICE,false) and CacheCenter:getPlayerInfo().level == 19) or 
                        (i == 44 and CheckButtonOpen(ISLAND_EXTEND_CARD,false) and CacheCenter:getPlayerInfo().level == 32) or 
                        (i == 19 and CheckButtonOpen(28,false)) or (i == 28 and CheckButtonOpen(10,false)) or 
                        (i == 42 and CheckButtonOpen(64,false) and CacheCenter:getPlayerInfo().level == 24) or 
                        (i == 11 and CheckButtonOpen(43,false)) or (i == 14 and CheckButtonOpen(3,false)) or 
                        (i == 24 and CheckButtonOpen(8,false)) or (i == 13 and CheckButtonOpen(6,false)) or 
                        (i == 10 and CheckButtonOpen(41,false)) or (i == 37 and CheckButtonOpen(58,false)) or 
                        (i == 29 and CacheCenter:getPlayerInfo().level == 16) or (i == 23 and CheckButtonOpen(9,false)) or 
                        (i == 15 and CheckButtonOpen(1,false)) or (i == 16 and CheckButtonOpen(4,false)) or 
                        (i == 12 and CheckButtonOpen(27,false)) or 
                        (i == 26 and (CacheCenter:getPlayerInfo().level == 10 and (TeachGroup1:isTaskTeachFinish(TeachGroup1.TASK_ID_7) or TeachGroup1.ISTEACHMODE))) or 
                        (i == 20 and CheckButtonOpen(5,false)) or (i == 8 and TeachGroup1:isTaskTeachFinish(TeachGroup1.TASK_ID_3) == true) or 
                        (i == 9 and CheckButtonOpen(40,false)) or (i == 7 and TeachGroup1:isTaskTeachFinish(10103) == true and CacheCenter:getPlayerInfo().level <= 2) or 
                        (i == 31 and TeachGroup1:isTaskTeachFinish(10104) == true) or 
                        (i == 32 and TeachGroup1:isTaskTeachFinish(10105) == true and CacheCenter:getPlayerInfo().level <= 5) or 
                        (i == 33 and TeachGroup1:isTaskTeachFinish(10201) == true and CacheCenter:getPlayerInfo().level <= 8) or 
                        (i == 34 and TeachGroup1:isTaskTeachFinish(10202) == true and CacheCenter:getPlayerInfo().level <= 8) or 
                        (i == 35 and TeachGroup1:isTaskTeachFinish(10203) == true and CacheCenter:getPlayerInfo().level <= 8) or 
                        (i == 36 and TeachGroup1:isTaskTeachFinish(10204) == true and CacheCenter:getPlayerInfo().level <= 8) or 
                        (i == 39 and TeachGroup1:isTaskTeachFinish(10205) == true and CacheCenter:getPlayerInfo().level <= 8) or 
                        (i == 40 and TeachGroup1:isTaskTeachFinish(10206) == true and CacheCenter:getPlayerInfo().level <= 8) or 
                        (i == 5 and CheckButtonOpen(25,false)) or ((i == 1 and CacheCenter:getPlayerInfo().level <= 1) or 
                        (i == 3 and CacheCenter:getPlayerInfo().level <=2)) or 
                        (i == 48 and CacheCenter:getPlayerInfo().level ==23) or 
                        (i == 49 and CacheCenter:getPlayerInfo().level ==28) or
                        (i == 41 and CheckButtonOpen(11,false) and CacheCenter:getPlayerInfo().level == 9) then
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
        local isEndTeach5, teachStep5 = TeachGroup1:isTeachFinish(5)
        local isEndTeach7, teachStep7 = TeachGroup1:isTeachFinish(7)
      
        if isEndTeach7 == true then
            return false
        elseif isEndTeach7 ~= true and isEndTeach5 == true then
            WindowManager:addTeachShelterLayer( 999999 )
            ProtocolProcessorSingleMap:send_SINGLEMAP_StartChallenge(10103, COPYTYPE_SINGLE)
        elseif isEndTeach5 ~= true and isEndTeach3 == true then
            WindowManager:addTeachShelterLayer( 999999 )
            ProtocolProcessorSingleMap:send_SINGLEMAP_StartChallenge(10102, COPYTYPE_SINGLE)
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
            ProtocolProcessorSingleMap:send_SINGLEMAP_StartChallenge(10101, COPYTYPE_SINGLE)
        end
    elseif openTeach == 3 then
        WindowManager:addTeachShelterLayer( 999999 )
        SceneCopy:showScene(1)
    elseif openTeach == 4 then
        --WindowManager:addTeachShelterLayer( 999999 )
        --ProtocolProcessorSingleMap:send_SINGLEMAP_StartChallenge(10102, COPYTYPE_SINGLE)
    elseif openTeach == 5 then
        if GlobalGame.g_tWndBottomBarObj == nil and self.m_tWndBottomBarObj == nil then
            return false
        end
        local elementObj = GlobalGame.g_tWndBottomBarObj or self.m_tWndBottomBarObj
        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {5,1, elementObj.m_root})
    elseif openTeach == 6 then
        --WindowManager:addTeachShelterLayer( 999999 )
        --ProtocolProcessorSingleMap:send_SINGLEMAP_StartChallenge(10103, COPYTYPE_SINGLE)
    elseif openTeach == 7 then
        local isEndTeach, teachStep = TeachGroup1:isTeachFinish(7)
        if false or teachStep < 2 then
            WindowManager:addTeachShelterLayer( 999999 )
            SceneCopy:showScene(1)
        else
            if GlobalGame.g_tWndBottomBarObj == nil and self.m_tWndBottomBarObj == nil then
                return false
            end
            local elementObj = GlobalGame.g_tWndBottomBarObj or self.m_tWndBottomBarObj
            if elementObj.m_nMoveDirection == 0 then
                isTeach = elementObj:endMoveVerticalBar(nil, levelUp, isTrailerAnim)
            else
                isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {7,3, elementObj.m_root})
            end
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
            isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {9,1,elementObj.m_root})
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
    elseif openTeach == 37 and CheckButtonOpen(58,false) then
        if GlobalGame.g_tWndBottomBarObj == nil and self.m_tWndBottomBarObj == nil then
            return false
        end
        local elementObj = GlobalGame.g_tWndBottomBarObj or self.m_tWndBottomBarObj
        if elementObj.m_nMoveDirection == 0 then
            isTeach = elementObj:endMoveVerticalBar(nil, levelUp, isTrailerAnim)
        else
            isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {37,1,elementObj.m_root})
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
        if elementObj.m_nMoveDirection == 0 then
            isTeach = elementObj:endMoveVerticalBar(nil, levelUp, isTrailerAnim)
        else
            isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {12,1,elementObj.m_root})
        end
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
        if elementObj.m_nMoveDirection == 0 then
            isTeach = elementObj:endMoveVerticalBar(nil, levelUp, isTrailerAnim)
        else
            isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {19,1,elementObj.m_root})
        end
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
        --    ProtocolProcessorSingleMap:send_SINGLEMAP_StartChallenge(10104, COPYTYPE_SINGLE)
        --end
    elseif openTeach == 22 and CheckButtonOpen(20,false) then
        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {22,1,WndOwnCity.m_root})
    elseif openTeach == 23 and CheckButtonOpen(9,false) then
        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {23,1})
    elseif openTeach == 24 and CheckButtonOpen(8,false) then
        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {24,1})
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
        if GlobalGame.g_tWndBottomBarObj == nil and self.m_tWndBottomBarObj == nil then
            return false
        end
        local elementObj = GlobalGame.g_tWndBottomBarObj or self.m_tWndBottomBarObj
        if elementObj.m_nMoveDirection == 0 then
            isTeach = elementObj:endMoveVerticalBar(nil, levelUp, isTrailerAnim)
        else
            isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {31,1, elementObj.m_root})
        end
    elseif openTeach == 32 then
        --isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {32,2, GlobalGame.g_tWndBottomBarObj.m_root})
        if WndSingleCopy.m_root == nil then
            WindowManager:addTeachShelterLayer( 999999 )
            SceneCopy:showScene(1)
        end
    elseif openTeach == 33 then
        if GlobalGame.g_tWndBottomBarObj == nil and self.m_tWndBottomBarObj == nil then
            return false
        end
        local elementObj = GlobalGame.g_tWndBottomBarObj or self.m_tWndBottomBarObj
        if elementObj.m_nMoveDirection == 0 then
            isTeach = elementObj:endMoveVerticalBar(nil, levelUp, isTrailerAnim)
        else
            isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {33,1, elementObj.m_root})
        end
    elseif openTeach == 34 then
        if GlobalGame.g_tWndBottomBarObj == nil and self.m_tWndBottomBarObj == nil then
            return false
        end
        local elementObj = GlobalGame.g_tWndBottomBarObj or self.m_tWndBottomBarObj
        if elementObj.m_nMoveDirection == 0 then
            isTeach = elementObj:endMoveVerticalBar(nil, levelUp, isTrailerAnim)
        else
            isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {34,1, elementObj.m_root})
        end
    elseif openTeach == 35 then
        if GlobalGame.g_tWndBottomBarObj == nil and self.m_tWndBottomBarObj == nil then
            return false
        end
        local elementObj = GlobalGame.g_tWndBottomBarObj or self.m_tWndBottomBarObj
        if elementObj.m_nMoveDirection == 0 then
            isTeach = elementObj:endMoveVerticalBar(nil, levelUp, isTrailerAnim)
        else
            isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {35,1, elementObj.m_root})
        end
    elseif openTeach == 36 then
        if GlobalGame.g_tWndBottomBarObj == nil and self.m_tWndBottomBarObj == nil then
            return false
        end
        local elementObj = GlobalGame.g_tWndBottomBarObj or self.m_tWndBottomBarObj
        if elementObj.m_nMoveDirection == 0 then
            isTeach = elementObj:endMoveVerticalBar(nil, levelUp, isTrailerAnim)
        else
            isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {36,1, elementObj.m_root})
        end
    elseif openTeach == 39 then
        if GlobalGame.g_tWndBottomBarObj == nil and self.m_tWndBottomBarObj == nil then
            return false
        end
        local elementObj = GlobalGame.g_tWndBottomBarObj or self.m_tWndBottomBarObj
        if elementObj.m_nMoveDirection == 0 then
            isTeach = elementObj:endMoveVerticalBar(nil, levelUp, isTrailerAnim)
        else
            isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {39,1, elementObj.m_root})
        end
    elseif openTeach == 40 then
        if GlobalGame.g_tWndBottomBarObj == nil and self.m_tWndBottomBarObj == nil then
            return false
        end
        local elementObj = GlobalGame.g_tWndBottomBarObj or self.m_tWndBottomBarObj
        if elementObj.m_nMoveDirection == 0 then
            isTeach = elementObj:endMoveVerticalBar(nil, levelUp, isTrailerAnim)
        else
            isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {40,1, elementObj.m_root})
        end
    elseif openTeach == 41 and CheckButtonOpen(11,false) and WndEquipmentLottery.m_root == nil then
        local isEndTeach, teachStep = TeachGroup1:isTeachFinish(41)
        if teachStep < 4 then
            isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {41,1})
        elseif GlobalGame.g_tWndBottomBarObj.m_nMoveDirection == 0 then
            isTeach = GlobalGame.g_tWndBottomBarObj:endMoveVerticalBar(nil, levelUp, isTrailerAnim)
        elseif WndEquipmentLottery.m_bIsCloseClick then
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
        if teachStep >= 5 then
            TeachGroup1:setTeachFinish(42, -1, true)
            ProtocolProcessorTeach:send_TASK_TiroStep(42, -1)
            return false
        end
        if elementObj.m_nMoveDirection == 0 then
            isTeach = elementObj:endMoveVerticalBar(nil, levelUp, isTrailerAnim)
        else
            isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {42,1, elementObj.m_root})
        end
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
        if elementObj.m_nMoveDirection == 0 then
            isTeach = elementObj:endMoveVerticalBar(nil, levelUp, isTrailerAnim)
        else
            isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {44,1, elementObj.m_root})
        end
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
            if CacheCenter:getGameParam().isAd == "true" and adMessage ~= nil and #adMessage > 0 and adMessage[#adMessage].sort <= ADINDEX and displayAD ~= "0" and os.date("%x", os.time()) ~= displayAD then
            	local wnd = WndAdvertising:createElement()
            	WindowManager:addWindow(wnd, WndAdvertising, false)
    			GlobalGame.g_checkLoginActivities = true
    		elseif CacheCenter.m_tWelfareItemRedDotList ~= nil and #CacheCenter.m_tWelfareItemRedDotList > 0 and CheckButtonShow(69) then
                if WndWelfare.m_root == nil then
                    MsgBoxManager:showWelfare()
                end
            elseif GlobalGame.g_autoGameActivity then
                WZLog("***** 进主城，获取活动信息 *****")
                if CheckButtonShow(21) then
                    if WndGameActivity.m_root == nil then
                        MsgBoxManager:showGameActivity()
                    end
                else
                    GlobalGame.g_autoGameActivity = false
                end
            elseif GlobalGame.g_autoNewActivity then
                WZLog("--****showNewActivity****--")
                if CheckButtonShow(122) then
                    if WndNewActivity.m_root == nil then
                        MsgBoxManager:showNewActivity()
                    end
                else
                    GlobalGame.g_autoNewActivity = false
                end
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
    	CCDirector:sharedDirector():setAnimationInterval(1.0/30)
        if self.m_tTextureCache ~= nil then
            for i, v in pairs(self.m_tTextureCache) do
                if v ~= nil and v.release ~= nil then
                    v:release()
                end
            end
        end
    end

    ProtocolProcessorSceneIsland:unregAll()

    CacheCenter:unregisterUpatePlayerInfoObserver(self)
    --登录小岛界面后活动界面更改
    --g_checkLoginActivities = false

    WZLog("SceneCity:onExit two", self.m_scheduleId, self.m_scheduleLoopId)
    if self.m_scheduleLoopId ~= -1 then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_scheduleLoopId)
        self.m_scheduleLoopId = -1
        CCDirector:sharedDirector():setAnimationInterval(1.0/30)

    end

    if self.m_secondScheduleId ~= -1 then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_secondScheduleId)
    end

    --self.m_root:disableSchedule()

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

end

--@brief 每秒调用
function SceneCity:updateSecond(dt)
    --获取禁忌之地红点信息
    if CacheCenter.m_nTabooBoxCountDown then
        -- WZLog("SceneCity:updateSecond taboo",CacheCenter.m_nTabooBoxCountDown , SystemTime:getServerTime())
        if CacheCenter.m_nTabooBoxCountDown < SystemTime:getServerTime() then
            CacheCenter.m_nTabooBoxCountDown =  nil
            ProtocolProcessorGlobal:send_ZONE_GetBoxInfo( )
        end
    end

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
        if GlobalGame.bOpenGPS == false then
            GlobalGame.bOpenGPS = true
            RoleGPS:checkGPS()--检查GPS状态
        end
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
    elseif self.m_count == 16 then
        ProtocolProcessorWndRuneDraw:send_RUNE_GetLotteryInfo()
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
    local scaleX = self.m_tWinSize.width/960
    local realScale = scaleY/scaleX
    
    scene:setResistance(0.8)
    scene:setScaleX(realScale)
    if scaleX < scaleY then
        local diff = 960*scaleY-self.m_tWinSize.width
        diff = diff/scaleY
        scene:setContentSize(CCSizeMake(960-diff,640))
        print("SceneCity:initScene one", scaleY, scaleX, diff)
    else
        local diff = self.m_tWinSize.width - 960*scaleY
        diff = diff/scaleY
        scene:setContentSize(CCSizeMake(960+diff,640))
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
    if self:isLouyixiao() or SceneCity:isSummer() then
        --FigureSceneManager:getInstance():createNpc3(1)
    end
    
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
--@note		缓存纹理,降低战斗中的纹理加载操作
function SceneCity:addTextureCache()
    WZLog("SceneCity:addTextureCache one")
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
            elseif v.buttonId == 122 and lv == 999 then
                btnName:setVisible(false)
                local btn = GetElement(self.m_root, "building122_SceneCity", WZUIButton)
                btn:setVisible(false)
            elseif v.buttonId == 127 and lv == 999 then
                btnName:setVisible(false)
                local btn = GetElement(self.m_root, "building127_SceneCity", WZUIButton)
                btn:setVisible(false)
            elseif v.buttonId == 139 then
                WZLog("SceneCity:_update 139")
            elseif bFlag == false then
                btnName:setVisible(false)
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
    if isOpen ~= 1 then
        local btnName = GetElementWithoutAssert(self.m_root, "building139" , WZUIImage)
        btnName:setVisible(false)
        local btn = GetElement(self.m_root, "building139_SceneCity", WZUIButton)
        btn:setVisible(false)
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
    if isOpenMarry == false then
        GetElement(self.m_root, "building8_SceneCity", WZUIContainer):setVisible(false)
        GetElementWithoutAssert(self.m_root, "building8_1_SceneCity" , WZUIImage):setVisible(false)
    end

    local teachList = {"2_1", "3_1","5_1", "5_2","7_1", "8_1", "8_2", "9_1", "11_1", "11_2", "4_1", "4_2"}
    for i, buildingName in pairs (teachList) do
        GetElementWithoutAssert(self.m_root, "building"..buildingName.."_SceneCity" , WZUIImage):setVisible(false)
    end

end

function SceneCity:openEscape(isOpen)
    if self.m_root == nil and self.m_tBtnsInfo == nil then
        return
    end
    local btnName = GetElementWithoutAssert(self.m_root, "building139" , WZUIImage)
    btnName:setVisible(isOpen == 1)
    local btn = GetElement(self.m_root, "building139_SceneCity", WZUIButton)
    btn:setVisible(isOpen == 1)
end

function SceneCity:isLouyixiao()
    local isLouyixiao = tonumber(GlobalGame.g_autoLouraActivity or 0) == 1
    WZLog("SceneCity:isLouyixiao", isLouyixiao, CheckButtonShow(131,true))
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
    WZLog("SceneCity:openTree", isOpen)
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
    WZLog("SceneCity:isSterious", isSummer)
    return isSummer
end

function SceneCity:isSummer()
    local isSummer = GlobalGame.g_autoSummerActivity
    if isSummer == 2 or isSummer == 3 then
        isSummer = true
    else
        isSummer = false
    end
    WZLog("SceneCity:isSummer", isSummer)
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
    --WZLog("SceneCity:setRedPoint", tostring(btn),tostring(state),tostring(pos))
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

    for i, v in pairs(type) do
        WZLog("SceneCity:updateRedDot one", i, v, value[i])
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
        end
        
    end

    GlobalGame.g_tRedPointList.community = community
    GlobalGame.g_tRedPointList.marry = marry
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
--    GlobalGame.g_tRedPointList.louraAct = louraAct
    GlobalGame.g_tRedPointList.shop = shop
    GlobalGame.g_tRedPointList.home = home
    bless = bless and CheckButtonOpen(ISLAND_UP_BLESS, false)
    GlobalGame.g_tRedPointList.bless = bless
    GlobalGame.g_tRedPointList.petFetter = petFetter
    GlobalGame.g_tRedPointList.pvpBuff = pvpBuff
    GlobalGame.g_tRedPointList.heroTower = heroTower
    WndOwnCity:updateFundOpen(GlobalGame.g_tRedPointList.fundOpen)

	--代言人活动
--	WndApartmentAct:setRed2(GlobalGame.g_tRedPointList.louraAct)

    CacheCenter:setRedState("btnPractice_ExtendUp",practice,55)
    GlobalGame:getBtnRedPointEvent():dispatcher()

    WZLog("SceneCity:updateRedDot two", tostring(firstRecharge), tostring(practice), tostring(SceneCity.m_root), tostring(community), tostring(marry), tostring(activity), tostring(tower), tostring(qualifying), tostring(badge))

    GlobalGame.g_bIsGetFirstRecharge = firstRecharge
    WndOwnCity:updateFirstRecharge(firstRecharge)
    SceneCity:updateRedDotBuilding("summer", WndSumVacAct:bShowRedPoint())

    WZLog("SceneCity:updateRedDot three", tostring(WndWelfare), tostring(WndWelfare and WndWelfare.updateRedDot), tostring(WndOwnCity.m_nIndex), GlobalGame.g_bIsGetFirstRecharge, tostring(gameActivity), tostring(isFirstRecharge))

    --WndOwnCity:updateFirstRecharge(GlobalGame.g_bIsGetFirstRecharge)
    if WndWelfare and WndWelfare.updateRedDot then
        WndWelfare:updateRedDot()
    end
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
    if WndApartmentAct then
        WndApartmentAct:updateRedDot()
    end

    if SceneCity.m_root == nil then
        return
    end

    --master = true
    WndSummonEntrance:updateRedPoint(nil, nil, nil, bless)
    SceneCity:updateRedDotBuilding("bless", bless, GlobalMethod:ccp(100,40))
    self:updateRedDotBuilding("home", home)
    self:updateRedDotBuilding("shop", shop)
    self:updateRedDotBuilding("anniversary", #CacheCenter.m_tYearActivityItemRedDotList > 0, GlobalMethod:ccp(130,45))
    self:updateRedDotBuilding("marry", marry)
    local bCommunity = community or GlobalGame.g_bIsGuildWarHaveRedDot
    WZLog("HHHHHHHHHHHHHHHHHHH ", #CacheCenter.m_tYearActivityItemRedDotList, tostring(community), tostring(GlobalGame.g_bIsGuildWarHaveRedDot))
    self:updateRedDotBuilding("community", bCommunity)
   
    self:updateRedDotBuilding("taboo", taboo, GlobalMethod:ccp(100,40))
    self:updateRedDotBuilding("tower", tower, GlobalMethod:ccp(100,40))
    self:updateRedDotBuilding("chart", chart, GlobalMethod:ccp(155,37))
    self:updateRedDotBuilding("heroTower", heroTower, GlobalMethod:ccp(100,40))

    local masterInfo = CacheCenter:getMasterInfo()
    if masterInfo and masterInfo.taskfinish == 1 then
        master = true
    end

    if "en" == ProjConfig.LANGUAGE or "th" == ProjConfig.LANGUAGE then
        self:updateRedDotBuilding("master", master, GlobalMethod:ccp(120,308), 1/0.6)
    else
        self:updateRedDotBuilding("master", master, GlobalMethod:ccp(150,308), 1/0.6)
    end

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

    if GlobalGame.g_tRedPointList.petFetter then 
        CacheCenter:updateRedPoint("right", self.m_tWndBottomBar, nil)
    end

    --七天乐
    local btn = GetElementWithoutAssert(self.m_root, "btn" .. ISLAND_UP_SEVEN_DAY .. "_WndOwnCity", WZUIButton)
    if sevenDays then 
        SceneCity:setRedPoint(btn,true,GlobalMethod:ccp(73,73))
    else
        SceneCity:setRedPoint(btn,false)
    end
end

--更新建筑红点
function SceneCity:updateRedDotBuilding(name, state, pos, scale)

    local btnIndex
    local isNpc
    if name == "marry" then
        btnIndex = "building8"
    elseif name == "shop" then
        btnIndex = "building7"
    elseif name == "home" then
        btnIndex = "building131"
        pos = GlobalMethod:ccp(150,45)
    elseif name == "community" then
        btnIndex = "building9"
    elseif name == "singleMap" then
        btnIndex = "building2"
    elseif name == "tower" or name == "taboo" or name == "heroTower" then
        btnIndex = "building3"
    elseif name == "chart" then
        btnIndex = "building4"
    elseif name == "master" then
        btnIndex = 2
        isNpc = true
    elseif name == "EquipLove" or name ==  "RuneDraw" or name ==  "btnPet" or name ==  "bless" then
        btnIndex = "building11"
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

    if state == true and name ~= "master" then
        GlobalGame.g_tRedPointList[name] = true
    elseif state ~= true then
        GlobalGame.g_tRedPointList[name] = nil
    end
    if name == "tower" or name == "taboo" or name == "heroTower" then
        if GlobalGame.g_tRedPointList.tower or GlobalGame.g_tRedPointList.taboo or GlobalGame.g_tRedPointList.heroTower then 
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
        elseif name == "EquipLove" or name == "RuneDraw" or name == "btnPet" or name == "bless" then
            state = GlobalGame.g_tRedPointList["EquipLove"] or GlobalGame.g_tRedPointList["btnPet"] or GlobalGame.g_tRedPointList["RuneDraw"] or GlobalGame.g_tRedPointList["bless"]
        end

        local btnName = GetElementWithoutAssert(self.m_root, btnIndex , WZUIImage)
        self:setRedPoint(btnName, state, pos, scale)
        --WZLog("SceneCity:updateRedDotBuilding one-2", btnIndex, btnName)

    elseif isNpc then
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

       local pWndRankList = WndRankList:createElement()
       if pWndRankList ~= nil then
           WindowManager:addWindow( pWndRankList , WndRankList )
       end
    end
end

--@brief	点击回调
function SceneCity:onBuildClickConquer(element)
    --WZLog("SceneCity:onBuildClickConquer",element:getTag())
    self.m_nClickBtnTag = element:getTag()
    
    TeachGroup1:endTeachStep({14,1},{28,1},{49,1})
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    local isTeach = (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 15 and TeachGroup1.STEP == 1) or (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 29 and TeachGroup1.STEP == 1) or (TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 13 and TeachGroup1.STEP == 1)
    
    if isTeach ~= true and CheckButtonOpen(ISLAND_BUILDING_TOWER) then
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
    WndMarryManager:initManager()
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

    if CheckButtonOpen(ISLAND_BUILDING_SINGLEMAP) then
        TeachGroup1:endTeachStep({1,2},{29,1},{15,1},{13,1})
        local wndCopyEntry = WndCopyEntry:createElement()
        WindowManager:addWindow(wndCopyEntry,WndCopyEntry)
        
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
        local wndSummonEntrance = WndSummonEntrance:createElement()
        WindowManager:addWindow(wndSummonEntrance,WndSummonEntrance)
    end
end

--@brief	点击回调
function SceneCity:onBuildClickWorldBoss(element)
    WZLog("SceneCity:onBuildClickWorldBoss")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    TeachGroup1:endTeachStep({28,1})

    local isTeach = TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 29 and TeachGroup1.STEP == 1

    if self:_checkBuildingOpen(ISLAND_BUILDING_WORLDBOSSMAP) and isTeach ~= true  then
        WndWorldBoss:showWnd(true)
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
        if SceneCity.tabEndRank and SceneCity.tabEndRank.month ~= "" then
            if tab.month == SceneCity.tabStartRank.month and tab.month == SceneCity.tabEndRank.month then
                if tab.day >= SceneCity.tabStartRank.day and tab.day <= SceneCity.tabEndRank.day then
                    if tab.hour == SceneCity.tabStartRank.hour and tab.hour == SceneCity.tabEndRank.hour then
                        if tab.min >= SceneCity.tabStartRank.min and tab.min <= SceneCity.tabEndRank.min then
                            isLight = true
                            WZLog("SceneCity:matchLight one-51")
                        end
                    elseif tab.hour == SceneCity.tabStartRank.hour then
                        if tab.min >= SceneCity.tabStartRank.min then
                            isLight = true
                            WZLog("SceneCity:matchLight one-52")
                        end
                    elseif tab.hour > SceneCity.tabStartRank.hour and tab.hour < SceneCity.tabEndRank.hour then
                            isLight = true
                            --WZLog("SceneCity:matchLight one-53")
                    elseif tab.hour == SceneCity.tabEndRank.hour then
                        if tab.min < SceneCity.tabEndRank.min then
                            isLight = true
                            WZLog("SceneCity:matchLight one-54")
                        end
                    end
                end
            elseif tab.month == SceneCity.tabStartRank.month then
                if tab.day >= SceneCity.tabStartRank.day then
                    if tab.hour == SceneCity.tabStartRank.hour and tab.hour == SceneCity.tabEndRank.hour then
                        if tab.min >= SceneCity.tabStartRank.min and tab.min <= SceneCity.tabEndRank.min then
                            isLight = true
                            WZLog("SceneCity:matchLight one-55")
                        end
                    elseif tab.hour == SceneCity.tabStartRank.hour then
                        if tab.min >= SceneCity.tabStartRank.min then
                            isLight = true
                            --WZLog("SceneCity:matchLight one-56")
                        end
                    elseif tab.hour > SceneCity.tabStartRank.hour and tab.hour < SceneCity.tabEndRank.hour then
                            isLight = true
                            WZLog("SceneCity:matchLight one-57")
                    elseif tab.hour == SceneCity.tabEndRank.hour then
                        if tab.min < SceneCity.tabEndRank.min then
                            isLight = true
                            WZLog("SceneCity:matchLight one-58")
                        end
                    end
                end
            elseif tab.month > SceneCity.tabStartRank.month and tab.month < SceneCity.tabEndRank.month then
                if true then
                    if tab.hour == SceneCity.tabStartRank.hour and tab.hour == SceneCity.tabEndRank.hour then
                        if tab.min >= SceneCity.tabStartRank.min and tab.min <= SceneCity.tabEndRank.min then
                            isLight = true
                            WZLog("SceneCity:matchLight one-59")
                        end
                    elseif tab.hour == SceneCity.tabStartRank.hour then
                        if tab.min >= SceneCity.tabStartRank.min then
                            isLight = true
                            WZLog("SceneCity:matchLight one-60")
                        end
                    elseif tab.hour > SceneCity.tabStartRank.hour and tab.hour < SceneCity.tabEndRank.hour then
                            isLight = true
                            WZLog("SceneCity:matchLight one-61")
                    elseif tab.hour == SceneCity.tabEndRank.hour then
                        if tab.min < SceneCity.tabEndRank.min then
                            isLight = true
                            WZLog("SceneCity:matchLight one-62")
                        end
                    end
                end
            elseif tab.month == SceneCity.tabEndRank.month then
                if tab.day <= SceneCity.tabEndRank.day then
                    if tab.hour == SceneCity.tabStartRank.hour and tab.hour == SceneCity.tabEndRank.hour then
                        if tab.min >= SceneCity.tabStartRank.min and tab.min <= SceneCity.tabEndRank.min then
                            isLight = true
                            WZLog("SceneCity:matchLight one-63")
                        end
                    elseif tab.hour == SceneCity.tabStartRank.hour then
                        if tab.min >= SceneCity.tabStartRank.min then
                            isLight = true
                            WZLog("SceneCity:matchLight one-64")
                        end
                    elseif tab.hour > SceneCity.tabStartRank.hour and tab.hour < SceneCity.tabEndRank.hour then
                            isLight = true
                            WZLog("SceneCity:matchLight one-65")
                    elseif tab.hour == SceneCity.tabEndRank.hour then
                        if tab.min < SceneCity.tabEndRank.min then
                            isLight = true
                            WZLog("SceneCity:matchLight one-66")
                        end
                    end
                end
            end
        end

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
        local btn = GetElementWithoutAssert(self.m_root, "btn68_WndOwnCity", WZUIButton)
        --WZLog("SceneCity:matchLight three", tostring(btn))
        if btn and isLight and GetElementWithoutAssert(btn, "armaMatchNormal_WndOwnCity"):isVisible() == false then
            GetElementWithoutAssert(btn, "armaMatchNormal_WndOwnCity"):setVisible(true)
            GetElementWithoutAssert(btn, "armaReMatchSel_WndOwnCity"):setVisible(true)
        elseif btn and isLight == false and GetElementWithoutAssert(btn, "armaMatchNormal_WndOwnCity"):isVisible() == true then
            GetElementWithoutAssert(btn, "armaMatchNormal_WndOwnCity"):setVisible(false)
            GetElementWithoutAssert(btn, "armaReMatchSel_WndOwnCity"):setVisible(false)

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
            SceneCity.m_tButtonTipsAnim3, SceneCity.m_tButtonTipsDialog3 = WindowManager:addTipForButton(btn, 0.30, GlobalMethod:ccp(40,10), txt, 3, GlobalMethod:ccp(100,-70))
            WZLog("SceneCity:loop zero-44", txt,  tostring(btn))
        else
            SceneCity.m_tButtonTipsAnim3:setVisible(true)
            SceneCity.m_tButtonTipsDialog3:setVisible(true)
            WZLog("SceneCity:loop zero-45")
        end
    end

    if SceneCity.m_bIsTipsAppear3 == true and SceneCity.m_tButtonTipsAnim3 and (SceneCity.m_nTime2 >= 10 and SceneCity.m_nTime2 <= 12 or SceneCity.m_nTime2 == 20 and SceneCity.m_nTime2 <= 22 or SceneCity.m_nTime2 >= 29) then
        SceneCity.m_tButtonTipsAnim3:removeFromParentAndCleanup(true)
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

    if false and SceneCity.m_root and SceneCity.m_bIsUpdatefeiting == nil then
        local feiting = GetElementWithoutAssert(SceneCity.m_root, "armaFeiting1_SceneCity", WZArmature)

        if feiting then
            --WZLog("SceneCity:_updateScheduleX1", tostring(feiting:getArmature()))
            local armature = feiting:getArmature()

            local feiting2 = GetElementWithoutAssert(SceneCity.m_root, "armaFeiting2_SceneCity", WZArmature)
            local armature2 = feiting:getArmature()
            if armature then

                local bone = armature:getBoneRecursively("feiting")
                local bone2 = armature2:getBoneRecursively("feiting")
                WZLog("SceneCity:_updateScheduleX2", tostring(bone))
                if bone == nil then return end
                bone = tolua.cast(bone,"CCBone")
                armature = bone:getChildArmature()
                bone2 = tolua.cast(bone2,"CCBone")
                armature2 = bone2:getChildArmature()
                WZLog("SceneCity:_updateScheduleX3", tostring(armature))
                if armature == nil then return end
                SceneCity.m_bIsUpdatefeiting = 1
                armature:getAnimation():playByIndex("0",-1,-1,1);
                armature2:getAnimation():playByIndex("0",-1,-1,1);
            end
        end
    end

    SceneCity:matchLight()

    --WZLog("SceneCity:_updateSchedule x111", SceneCity.m_nTime, "m_nCheckOpenTreeTime", SceneCity.m_nCheckOpenTreeTime, "ostime", ostime)
    if SceneCity.m_nTime and SceneCity.m_nTime ~= 0 and SceneCity.m_nTime % 3 == 0 and (ostime ~= SceneCity.m_nCheckOpenTreeTime) then
        SceneCity.m_nCheckOpenTreeTime = ostime
        SceneCity:openTree(WndApartmentAct:isSeckillOn())
        WndOwnCity:checkSevenDay()
    end

    SceneCity:closeLouyixiaoActivity()
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

----@brief  检测是否需要下载
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
    if tostring(ProjConfig:getChannelId()) == "8888" or tostring(ProjConfig:getChannelId()) == "53" or tostring(ProjConfig:getChannelId()) == "75" or tostring(ProjConfig:getChannelId()) == "275" or tostring(ProjConfig:getChannelId()) == "68" or tostring(ProjConfig:getChannelId()) == "10" then
        GetElement(self.m_root, "building132_SceneCity", WZUIButton):setVisible(false)
        GetElementWithoutAssert(self.m_root, "building132" , WZUIImage):setVisible(false)
    end
end

-------------------------------------私有方法模块End----------------------------------------
