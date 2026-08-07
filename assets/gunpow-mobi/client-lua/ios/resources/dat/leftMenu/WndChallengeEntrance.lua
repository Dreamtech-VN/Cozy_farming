--WndChallengeEntrance.lua
--@brief	WndChallengeEntrance的UI模块
--@date		2016/12/26
--@author	Tianxiang_Xu
--@note		爬塔和世界BOSS的入口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndChallengeEntrance:onEnter(element)
	self.m_root = element
    ProtocolProcessorSceneWorldBoss:regAll()
    self:controlBtnShow()

    local isEndTeach49, finishStep49 = TeachGroup1:isTeachFinish(49)
    WZLog("WndChallengeEntrance:onEnter", isEndTeach49, finishStep49)
    if isEndTeach49 ~= true and TeachGroup1:isTeach() and CacheCenter:getPlayerInfo().level == 27 then
        WindowManager:removeTeachShelterLayer()
        WindowManager:addTeachShelterLayer( 999999, 0 )
        WZLog("WndChallengeEntrance:onEnter2")
    end
    AdaptLanguage(self)
end

--@brief    退出场景时被调用的函数
--@param    element:表绑定的UI节点引用
--@note     在这里做场景退出前的清理工作
function WndChallengeEntrance:onExit(element)
    ProtocolProcessorSceneWorldBoss:unregAll()
    self:_unInit()
end

--@brief    触摸开始回调
function WndChallengeEntrance:onTouchBegan(element)
    -- body
    if WndItemInfo.m_root then
        WndItemInfo:onCloseClick()
    end
end

--@brief    界面加载完成回调
function WndChallengeEntrance:onEnterTransitionDidFinish( element )
    -- body
    self:_addTop()
    self:updateRedPoint()
    self:updateTabooRedPoint() 
    WndChallengeEntrance:createLoading()
    ProtocolProcessorSceneWorldBoss:send_WORLDBOSSHALL_GetOpenState()
end

--@brief    点击图标回调
function WndChallengeEntrance:onClickEvent(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local nTag = element:getTag()
    if nTag == 0 then   --爬塔副本
        TeachGroup1:endTeachStep({14,2})
        if CheckButtonOpen(ISLAND_BUILDING_TOWER) then
            SceneCopy:showScene(4)
            SceneCopy:setCallBackFun(WndChallengeEntrance, self.showInterface)
        end
    elseif nTag == 1 then --世界BOSS
        TeachGroup1:endTeachStep({28,2})
        if CheckButtonOpen(ISLAND_BUILDING_WORLDBOSSMAP) then
            local info = self.openInfo[1]
            if not info then return end
            self.selBossId = info.mapId
            local bossId = GDatatab_world_boss_map["id_"..self.selBossId].id
            SceneWorldBoss:showInterface(bossId)
            SceneWorldBoss:setCallBackFun(WndChallengeEntrance, self.showInterface)
        end
    elseif nTag == 2 then   --禁忌之地 
        if CheckButtonOpen(TABOO_BATTLE) then
        -- MsgBoxManager:showTipBox(LocalStrings.ASCENDING32)
            SceneTabooMap:show()
            SceneTabooMap:setCallBackFun(WndChallengeEntrance, self.showInterface)
        end
    elseif nTag == 3 then   --世界组队boss
        if CheckButtonOpen(ISLAND_UP_WORLDTEAM_BOSS) then
            SceneWorldTeamBoss:showInterface()
            SceneWorldTeamBoss:setCallBackFun(WndChallengeEntrance, self.showInterface)
        end
    end
end

--@brief    点击关闭按钮回调
function WndChallengeEntrance:onClickClose(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    WindowManager:removeWindow(self.m_root , self , true)
end

--@brief    刷新爬塔入口红点
function WndChallengeEntrance:updateRedPoint()
    -- body
    local imgClimbRedDot = GetElement(self.m_root, "imgClimbRedDot_WndChallengeEntrance", WZUIImage)
    if imgClimbRedDot then
        imgClimbRedDot:setVisible(GlobalGame.g_tRedPointList.tower or GlobalGame.g_tRedPointList.heroTower)
    end
end

--@brief    刷新爬塔入口红点
function WndChallengeEntrance:updateTabooRedPoint()
    -- body
    local imgClimbRedDot = GetElement(self.m_root, "imgTabooRedDot_WndChallengeEntrance", WZUIImage)
    if imgClimbRedDot then
        imgClimbRedDot:setVisible(GlobalGame.g_tRedPointList.taboo)
    end
end

-- 倒计时格式转换
function WndChallengeEntrance:_timeChangeStyle(time)
    local h,m = 3600,60
    local hour = math.floor(time/h)
    local min = math.floor((time - hour*h)/m)
    --local sec = math.floor(time-hour*h-min*60)
    if hour < 10 then hour = "0"..hour end
    if min < 10 then min = "0"..min end
    --if sec < 10 then sec = "0"..sec end
    local str = hour..":"..min
    return str
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
-- 初始化boss主界面
function WndChallengeEntrance:_initOpenDesc()
    self:closeLoading()
    WindowManager:removeTeachShelterLayer()
    TeachGroup1:startGroup({14,2,self.m_root},{28,2,self.m_root},{49,2,self.m_root})
    local str = [[<T C="255,236,193" S="22" P="0">%s</T><T C="255,89,74" S="22" P="0">%s</T>]]
    local ftxtOpenTime = GetElement(self.m_root,"ftxtOpenTime_WndChallengeEntrance",WZUIFreeTextBox)
    local openInfo = self.openInfo
    for i = 1, 1 do
        if openInfo[i] and openInfo[i].state then
            -- 开启时间
            -- if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or 
            --     ProjConfig.LANGUAGE == "en" then
                local time,overTime = openInfo[i].time,openInfo[i].overTime
                if time > 0 then
                    local time1 = self:_timeChangeStyle(time)
                    ftxtOpenTime:setShowText(string.format(str,LocalStrings.WORLD_BOSS_OPEN_TIME_DOWN,time1))
                    ftxtOpenTime:enableSchedule("_updateOpenTime",1)
                elseif time <= 0 and overTime > 0 then
                    local time2 = self:_timeChangeStyle(overTime)
                    ftxtOpenTime:setShowText(string.format(str,LocalStrings.ACTIVITY_END_COUNTDOWN,time2))
                    ftxtOpenTime:enableSchedule("_updateEndTime",1)
                elseif overTime == 0 then
                    ftxtOpenTime:setShowText(string.format(str,LocalStrings.ACTIVITY_END_COUNTDOWN,"00"..LocalStrings.HOUR.."00"..LocalStrings.MINUTE))
                end
            -- else
            --      local data = GDatatab_world_boss_map["id_"..openInfo[i].mapId]
            -- 开启时间
            --      local start_time,end_time = data.start_time,data.end_time
            --     local data = GDatatab_world_boss_map["id_"..openInfo[i].mapId]
            --     ftxtOpenTime:setShowText(string.format(LocalStrings.WORLD_BOSS_OPEN_TIME,start_time,end_time))
            -- end
            
        else
            ftxtOpenTime:setShowText(LocalStrings.WORLD_BOSS_NOT_OPEN)
        end
    end
end

function WndChallengeEntrance:_addTop()
    -- body
    local celElement, tNewObj = CellTopHandle:createElement()
    tNewObj:setTopData("ui/world_boss/common_icon_tz.png", WndChallengeEntrance, WndChallengeEntrance.onClickClose, true, false, false, "WndChallengeEntrance")
    self.m_root:addChild(celElement)
end

--@brief    开启倒计时
function WndChallengeEntrance:_updateOpenTime( element,time )
    local str = [[<T C="255,236,193" S="22" P="0">%s</T><T C="255,89,74" S="22" P="0">%s</T>]]
    local ftxtOpenTime = GetElement(self.m_root,"ftxtOpenTime_WndChallengeEntrance",WZUIFreeTextBox)
    if self.openInfo[1].time > 0 then
        self.openInfo[1].time = self.openInfo[1].time - 1
        local time = self:_timeChangeStyle(self.openInfo[1].time)
        ftxtOpenTime:setShowText(string.format(str,LocalStrings.WORLD_BOSS_OPEN_TIME_DOWN,time))
    else
        element:disableSchedule()
    end
end

--@brief    结束倒计时
function WndChallengeEntrance:_updateEndTime( element,time )
    local str = [[<T C="255,236,193" S="22" P="0">%s</T><T C="255,89,74" S="22" P="0">%s</T>]]
    local ftxtOpenTime = GetElement(self.m_root,"ftxtOpenTime_WndChallengeEntrance",WZUIFreeTextBox)
    if self.openInfo[1].overTime > 0 then
        self.openInfo[1].overTime = self.openInfo[1].overTime - 1
        local time = self:_timeChangeStyle(self.openInfo[1].overTime)
        ftxtOpenTime:setShowText(string.format(str,LocalStrings.ACTIVITY_END_COUNTDOWN,time))
    else
        element:disableSchedule()
    end
end
-------------------------------------私有方法模块End----------------------------------------
--按照功能开放等级进行显示
function WndChallengeEntrance:controlBtnShow()
    -- body
    WZLog("WndChallengeEntrance:controlBtnShow")
    local GDatatab_button_info = GDatatab_button_info
    local GetElement = GetElement
    local btnList = {3,10,117,148}
    
    local conList = GetElement(self.m_root,"conList_WndChallengeEntrance",WZUIContainer)
    local playerLevel = CacheCenter:getPlayerInfo().level
    for i,v in ipairs(btnList) do
        local con = GetElement(conList,"con" .. i .. "_WndChallengeEntrance",WZUIContainer)
        if playerLevel >= GDatatab_button_info["id_"..v].open_level  then 
            con:setVisible(false)
        else
            con:setVisible(true)
        end
    end
end

-------------------------------------语言适配Begin------------------------------------------
function WndChallengeEntrance:_adaptLanguage_es(  )
    GetElement(self.m_root,"ftxtOpenTime_WndChallengeEntrance",WZUIFreeTextBox):setScale(0.8)

    GetElement(self.m_root,"txtTower_WndChallengeEntrance",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtWorld_WndChallengeEntrance",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtTeamWorldBoss_WndChallengeEntrance",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtTaboo_WndChallengeEntrance",WZUILabelTTF):setScale(0.8)
end

function WndChallengeEntrance:_adaptLanguage_tr(  )
    GetElement(self.m_root,"ftxtOpenTime_WndChallengeEntrance",WZUIFreeTextBox):setScale(0.8)
    --GetElement(self.m_root,"txtTitle3_WndChallengeEntrance",WZUILabelTTF):setFontSize(24)
end

function WndChallengeEntrance:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txtTower_WndChallengeEntrance",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtWorld_WndChallengeEntrance",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtTeamWorldBoss_WndChallengeEntrance",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtTaboo_WndChallengeEntrance",WZUILabelTTF):setScale(0.8)
end

function WndChallengeEntrance:_adaptLanguage_pt(  )
    GetElement(self.m_root,"ftxtOpenTime_WndChallengeEntrance",WZUIFreeTextBox):setScale(0.8)

    GetElement(self.m_root,"txtTower_WndChallengeEntrance",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtWorld_WndChallengeEntrance",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtTeamWorldBoss_WndChallengeEntrance",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtTaboo_WndChallengeEntrance",WZUILabelTTF):setScale(0.8)
end

function WndChallengeEntrance:_adaptLanguage_en(  )
    GetElement(self.m_root,"ftxtOpenTime_WndChallengeEntrance",WZUIFreeTextBox):setScale(0.8)

    GetElement(self.m_root,"txtTower_WndChallengeEntrance",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtWorld_WndChallengeEntrance",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtTeamWorldBoss_WndChallengeEntrance",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtTaboo_WndChallengeEntrance",WZUILabelTTF):setScale(0.8)
end
-------------------------------------语言适配End--------------------------------------------