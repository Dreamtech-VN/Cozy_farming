--SceneCopy.lua
--@brief	SceneCopy的UI模块
--@date		2015/04/09
--@author	xiaoyu_wu
-- modify   binshao 2015-7-9
--@note		副本UI场景


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function SceneCopy:onEnter(element)
	self.m_root = element

    self:_initUI()
    GlobalGame:getGameEventDispathcer():Dispatch("GameState_Change",'state_hall')
    --延时显示成就特效
    ShowDelayAchie()
    g_SceneCopyCallback = self.onReturn
end

--@brief    界面加载完成回调
function SceneCopy:onEnterTransitionDidFinish(element)
    -- body
    if tostring(ProjConfig:getChannelId()) ~= "53" and tostring(ProjConfig:getChannelId()) ~= "75" and tostring(ProjConfig:getChannelId()) ~= "275" then
        if g_bIsPushSpecifyActivity then 
            self:showLoading()
            ProtocolProcessorCommonPush:send_COMMONPUSH_GetDirectionalPush(ProjConfig.CHANNEL_ID, 1, GlobalGame.g_nCurrentUIChannelId)
        end
    end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function SceneCopy:onExit(element)
    --add by wuweidong
    GlobalGame:getBtnRedPointEvent():unregListener("btnTask","SceneCopy")
    GlobalGame:getBtnRedPointEvent():unregListener("btnBag","SceneCopy")

	self:_unInit()
end

-- 游戏顶部
function SceneCopy:_addTop(imgPath, chatFlag, scale)
    local cell,tcell = CellTopHandle:createElement()
    local con = GetElement(SceneCopy.m_root,"conMain_SceneCopy",WZUIContainer)
    con:addChild(cell)
    cell:setZOrder(1)
    local scale = scale or 1
    tcell:setTopData(imgPath,SceneCopy,SceneCopy.onReturn,true,true,chatFlag,"SceneCopy",{scale = scale})
    tcell:setTopType()
    self.m_tCellTopHandle = tcell 
end

function SceneCopy:onTouchBegan(element,pt)
	WZLog("SceneCopy:onTouchBegan")
	if WndUpgrade.m_root ~= nil or CacheCenter:getPlayerInfo().level <= 5 then return end
	if WndRewardShow.m_root ~= nil then return end
	if WndDressUp.m_root ~= nil and (not WndDressUp:checkPoint(pt)) then
		WndDressUp:onCloseClick()
	end
end

--@brief	点击关闭按钮时被调用的函数
--@param	element:按钮绑定的UI节点引用
function SceneCopy:onReturn(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    WZLog("---------------close end start-----------------",self.m_fBack)
    
    --if WindowManager:ifSceneActive() or not self.m_fBack  then
        if WndSingleCopy.m_root ~= nil then
            self:resetSingleCopyData()
        end
    --     local sceneCity = SceneCity:createElement()
    --     replaceScene(sceneCity)
    -- else
    --     self.m_fBack()
    -- end
    self:_postBackToCityEvent()

    if self.copyType == 1 or self.copyType == 2 or self.copyType == 3 then
        local sceneCity = SceneCity:createElement(nil,true)
        replaceScene(sceneCity)
        -- WndCopyEntry:showScene()
    elseif not self.m_fBack then
        local sceneCity = SceneCity:createElement()
        replaceScene(sceneCity)
        if self.m_tReturnCallBack then
            self.m_tReturnCallBack[2](self.m_tReturnCallBack[1])
        end
    else
        self.m_fBack()
    end

end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	初始化界面
function SceneCopy:_initUI()
    local imgPath = {
        "ui/common/common_icon_txzd.png",
        "ui/common/common_icon_zdfb.png",
        "ui/common/common_icon_mjbz.png",
        "",--"ui/common/common_icon_slt.png",
        "ui/common/common_icon_yxt.png",
    }
    if self.copyType == 1 or self.copyType == 2 or self.copyType == 3 then
        self:_addTop(imgPath[self.copyType], true, 0.75)
    -- elseif self.copyType == 4 and self.levelId and self.levelId == 2 then 
    --     self:_addTop(imgPath[self.copyType], true)
    elseif self.copyType == 4 or self.copyType == 5 then 
        self:_addTop(imgPath[self.copyType],true, 0.75)
    else
        local scale = 1
        if self.copyType == 1 or self.copyType == 4 or self.copyType == 5 then
            scale = 0.75
        end
        self:_addTop(imgPath[self.copyType],false, scale)
    end
    --获取近期进入的单人副本章节
    if GlobalGame.g_nRecentChallengeSection == nil then 
        GlobalGame.g_nRecentChallengeSection = self:_getRecentChallengeSection()
    end
    if GlobalGame.g_nRecentChallengeTime == nil then 
        GlobalGame.g_nRecentChallengeTime = self:_getChallengeTime()
    end
WZTempLog("self.copyType....: ",self.copyType)
    -- 根据进入的Index创建对应的副本
    if self.copyType == 1 then
        self:_initSingleCopy() --单人副本
    elseif self.copyType == 2 then
        self:_initMultiCopy() --多人副本
    elseif self.copyType == 3 then
        self:_initDailyCopy() --日常副本
    elseif self.copyType == 4 then
        self:_initTowerCopy() --爬塔副本
    elseif self.copyType == 5 then 
        self:_initHeroTowerCopy() --英雄塔副本
    end
    WZLog("----------------type----------------",self.copyType)
end

--@brief  关闭loading
function SceneCopy:showLoading()
    self.m_nLoadId = MsgBoxManager:showLoadingBox()
end

--@brief  关闭loading
function SceneCopy:closeLoading()
    if self.m_nLoadId then
        MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadId)
        self.m_nLoadId = nil
    end
end

-- 创建单人副本
function SceneCopy:_initSingleCopy()
    WZLog("SceneCopy:_initSingleCopy() ")
    local wnd = WndSingleCopy:createElement()
    if self.m_bTaskJump and self.showInfo ~= nil and  self.showInfo > 100 then
        local sectionId = GDatatab_task["id_"..self.showInfo].target
        if sectionId ~= nil then
            local strIndex = string.find(sectionId,"*")
            local str2Index = string.find(sectionId,"=")
            local isNull = string.find(sectionId,"-1")
            if strIndex ~= nil and str2Index ~= nil and isNull == nil then
                sectionId = string.sub(sectionId,strIndex+1,str2Index-1)
                local singInfo = GDatatab_single_map["id_" .. sectionId]
                WndSingleCopy:setIsShowCopyLevelInfo(true)
                WndSingleCopy:setShowIslandOwner(self.nJumpIsland)
                if singInfo == nil then
                    WndSingleCopy:setJumpPageIndex("10101")
                    WndSingleCopy:setCopyType(1)
                    return
                end
                WZLog("SceneCopy:_initSingleCopy sectionId = ",sectionId,strIndex,str2Index,self.showInfo)
                local sinlgeCopyModel = singInfo.map_type
                WndSingleCopy:setJumpPageIndex(sectionId)
                WndSingleCopy:setCopyType(sinlgeCopyModel)
            end
        end
    elseif self.m_bTaskJump and self.showInfo ~= nil and  self.showInfo < 100 and GlobalGame.g_nRecentChallengeSection then
        local singleCopyInfo = GDatatab_single_map["id_" .. GlobalGame.g_nRecentChallengeSection]
        if singleCopyInfo.map_type == self.showInfo then
            local sinlgeCopyModel = singleCopyInfo.map_type
            WndSingleCopy:setJumpPageIndex(singleCopyInfo.id)
            WndSingleCopy:setCopyType(self.showInfo)
        end
    elseif self.showInfo ~= nil and  self.showInfo > 100 and not self.m_bTaskJump then
        local singleCopyInfo = GDatatab_single_map["id_" .. self.showInfo]
        local sinlgeCopyModel = singleCopyInfo.map_type
        WndSingleCopy:setIsShowCopyLevelInfo(true)
        WndSingleCopy:setShowIslandOwner(self.nJumpIsland)
        WndSingleCopy:setJumpPageIndex(self.showInfo)
        WndSingleCopy:setCopyType(sinlgeCopyModel)
    end

    if self.showInfo ~= nil and self.showInfo < 100 then
        WndSingleCopy:setCopyType(self.showInfo)
    end

    WZLog("SceneCopy:_initSingleCopy55555555 ",type(self.copyType),type(self.m_bTaskJump), type(self.m_nChapterID), type(self.showInfo),GlobalGame.g_nRecentChallengeSection,self.showInfo)
    if self.m_nChapterID then
        WndSingleCopy:setCurChapterID(self.m_nChapterID,true)
    else
        --Add By Tianxiang    章节跳转优化
        if CacheCenter:getPlayerInfo().level >= 10 and self.copyType == 1 and not self.m_bTaskJump and self.showInfo == nil  then 
            if GlobalGame.g_nRecentChallengeSection then 
                local tTempData = GDatatab_single_map["id_" .. GlobalGame.g_nRecentChallengeSection]
                if tTempData then 
                    self.showInfo = tTempData.map_type
                    if self.showInfo and self.showInfo < 100 then 
                        if self.typeTag then
                            self.showInfo = self.typeTag
                        end
                        WndSingleCopy:setCopyType(self.showInfo)
                    end
                    self.m_nChapterID = tTempData.section
                    WZLog("SceneCopy:_initSingleCopy *****", self.m_nChapterID,GlobalGame.g_nRecentChallengeSection, self.showInfo)
                    if self.m_nChapterID and self.m_bSet == nil then 
                        WndSingleCopy:setCurChapterID(self.m_nChapterID, true)
                    end
                end
            end
        end
    end

    local con = GetElement(SceneCopy.m_root,"conMain_SceneCopy",WZUIContainer)
    con:addChild(wnd,0,1)
    
    self.m_tCurCopyWin = WndSingleCopy
end

-- 创建多人副本
function SceneCopy:_initMultiCopy()
    local wnd = WndMultiCopy:createElement()
    local con = GetElement(SceneCopy.m_root,"conMain_SceneCopy",WZUIContainer)
    con:addChild(wnd,0,2)
    self.m_tCurCopyWin = WndMultiCopy
end

-- 创建日常副本
function SceneCopy:_initDailyCopy()
    local wnd = WndDailyCopy:createElement()
    local con = GetElement(SceneCopy.m_root,"conMain_SceneCopy",WZUIContainer)
    con:addChild(wnd,0,3)
    self.m_tCurCopyWin = WndDailyCopy
end

-- 创建爬塔副本
function SceneCopy:_initTowerCopy()
    self.m_nLoadId  = MsgBoxManager:showLoadingBox()
    local con = GetElement(SceneCopy.m_root,"conMain_SceneCopy",WZUIContainer)
    WndTowerScroll:showInterface(con, self.levelId)
    self.m_tCurCopyWin = WndTowerScroll
end

-- 创建噩梦塔爬塔副本房间
function SceneCopy:_initDoubleTowerCopy()
    self.m_nLoadId  = MsgBoxManager:showLoadingBox()
    local con = GetElement(SceneCopy.m_root,"conMain_SceneCopy",WZUIContainer)
    WndTowerScroll:showInterface(con, 2)
    WndDoubleTowerRoom:showInterface()
    self.m_tCurCopyWin = WndTowerScroll
end

-- 创建英雄塔副本
function SceneCopy:_initHeroTowerCopy()
    local wnd = WndHeroTower:createElement()
    self.m_nLoadId  = MsgBoxManager:showLoadingBox()
    local con = GetElement(SceneCopy.m_root,"conMain_SceneCopy",WZUIContainer)
    con:addChild(wnd,0,5)
    self.m_tCurCopyWin = WndHeroTower
end

--@brief    获取最新挑战单人副本的章节的ID
function SceneCopy:_getRecentChallengeSection()
    local data = WZDataFile:getInstance():getUserData()
    if not data then return nil end
    local sectionKey = "SECTION" .. tostring(CacheCenter:getPlayerInfo().id)
    local nCurSection = data:getStringValue("SINGLECOPY", sectionKey)
    WZLog("SceneCopy:_getRecentChallengeSection", type(nCurSection), nCurSection)
    return tonumber(nCurSection) 
end

--@brief    获取最近挑战单人副本的时间
function SceneCopy:_getChallengeTime()
    local data = WZDataFile:getInstance():getUserData()
    if not data then return nil end
    local key = "SECTIONTIME" .. tostring(CacheCenter:getPlayerInfo().id)
    local nCurTime = data:getStringValue("SINGLECOPY", key)
    WZLog("SceneCopy:_getChallengeTime", type(nCurTime), nCurTime)
    return tonumber(nCurTime)
end

-- 保存最新挑战单人副本的章节的ID
function SceneCopy:_saveRecentChallengeSection(nCurSection)
    local data = WZDataFile:getInstance():getUserData()
    if not data then return end
    if GlobalGame.g_nRecentChallengeSection == nil or (GlobalGame.g_nRecentChallengeSection and GlobalGame.g_nRecentChallengeSection ~= nCurSection) then
        GlobalGame.g_nRecentChallengeSection = nCurSection
        local key = "SECTION" .. tostring(CacheCenter:getPlayerInfo().id)
        data:setStringValue("SINGLECOPY", key, nCurSection)
        data:flush()
    end
end

-- 保存最近挑战单人副本的时间
function SceneCopy:_saveChallengeTime()
    local data = WZDataFile:getInstance():getUserData()
    if not data then return end
    local nCurTime = math.floor(SystemTime:getServerTime()/(3600 * 24))
    if GlobalGame.g_nRecentChallengeTime == nil or (GlobalGame.g_nRecentChallengeTime and GlobalGame.g_nRecentChallengeTime < nCurTime) then
        GlobalGame.g_nRecentChallengeTime = nCurTime
        local key = "SECTIONTIME" .. tostring(CacheCenter:getPlayerInfo().id)
        data:setStringValue("SINGLECOPY", key, nCurTime)
        data:flush()
    end
end

--@brief    点击返回按钮事件
function SceneCopy:_postBackToCityEvent()
    -- body
    if self.copyType == 1 then 
        local level = CacheCenter:getPlayerInfo().level
        if level == 6 or level == 7 then 
            local eventKey = PostPlayerEvent["event_singleCopyClickBack" .. level]
            if eventKey then 
                PostPlayerEvent:postEvent(eventKey)    
            end
        end
    end
end
-------------------------------------私有方法模块End----------------------------------------
