--WndBattleHud.lua
--@brief    WndBattleHud的UI模块
--@date     2013/1/15
--@author   Zjh
--@note     战斗Hud界面

-------------------------------------公有方法模块Begin--------------------------------------

--@brief    进入场景时被调用的函数
--@param    element:表绑定的UI节点引用
--@note     在这里做场景进入前的准备工作
function WndBattleHud:onEnter(element)
	self.m_root = element

    -- self.m_sHudBgName = "conMyHudBg_WndBattleHud"
    -- if WBattleGlobal:getCurrent().m_tMakePairOk.mapId == 10102 then
    --     self.m_sHudBgName = "conMyHudBg2_WndBattleHud"
    -- end
    -- GetElement(self.m_root,self.m_sHudBgName):setVisible(true)
    GetElement(self.m_root,"conMyHud_WndBattleHud"):setRelativePositionLuaTo(0.5,-0.32)
    -- GetElement(self.m_root,self.m_sHudBgName):setRelativePositionLuaTo(0.5,-0.25)
    if g_nEnemyTalkLimit == nil then 
        local data = WZDataFile:getInstance():getUserData()
        _KeyString = "EnemyTalkLimit" .. tostring(CacheCenter:getPlayerInfo().id)
        
        local strValue =  data:getStringValue("TALK_LIMIT", _KeyString)
        if strValue ~= nil and strValue ~= "" then 
            g_nEnemyTalkLimit = tonumber(strValue)
        end
    end
    if g_nTeamTalkLimit == nil then 
        local data = WZDataFile:getInstance():getUserData()
        _KeyString = "TeamTalkLimit" .. tostring(CacheCenter:getPlayerInfo().id)
        
        local strValue =  data:getStringValue("TALK_LIMIT", _KeyString)
        if strValue ~= nil and strValue ~= "" then 
            g_nTeamTalkLimit = tonumber(strValue)
        end
    end
    local scale = math.floor(G_WINDOW_SIZE.WIDTH / 1136)
    scale = scale == 0 and 1 or scale

    WZLog("WndBattleHud:onEnter", G_WINDOW_SIZE.WIDTH, scale, WBattleGlobal.getCurrent().m_nAwakeSkillId)
    if WBattleGlobal:getCurrent().m_nAwakeSkillId then 
        self.m_nAwakeSkillLevel = CacheCenter:getAwakeSkillLevel()  --获取觉醒之技的等级
        self:updateAwakeSkillLevel()
        self:useMySkill(WBattleGlobal.getCurrent().m_nAwakeSkillId)
        GetElement(self.m_root, "conAwakeSkill_WndBattleHud", WZUIContainer):setVisible(true)
    else
        GetElement(self.m_root, "conAwakeSkill_WndBattleHud", WZUIContainer):setVisible(false)
    end

    local battleChannle = WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle
    if battleChannle == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_ZLS then
        GetElement(self.m_root, "btnBigSkillSwitch_WndBattleHud", WZUIButton):setVisible(false)
        GetElement(self.m_root, "btnBigSkillIcon_WndBattleHud", WZUIButton):setVisible(false)
        self.m_nBigSkillIndex = 1
    elseif WBattleGlobal:getCurrent().m_tSkinBigSkillList and #WBattleGlobal:getCurrent().m_tSkinBigSkillList > 0 then
        GetElement(self.m_root, "btnBigSkillSwitch_WndBattleHud", WZUIButton):setVisible(true)
        GetElement(self.m_root, "btnBigSkillIcon_WndBattleHud", WZUIButton):setVisible(true)
        self.m_nBigSkillIndex = GlobalGame.g_saveBigSkillType or 1
    else
        GetElement(self.m_root, "btnBigSkillSwitch_WndBattleHud", WZUIButton):setVisible(false)
        GetElement(self.m_root, "btnBigSkillIcon_WndBattleHud", WZUIButton):setVisible(false)
    end
    -- 功能开放表skinSkillCloss对切换非默认皮肤大招功能的限制
    self.m_bCloseSkinSkillSwitch = false
    local strSkinSkillCloss = CacheCenter:getGameParam().skinSkillCloss or "[]"
    skinSkillCloss = string.sub(strSkinSkillCloss,2,-2)
    if skinSkillCloss ~= "" then
        local tabSkinSkillCloss = SplitStringWithSeparator(skinSkillCloss,",")
        local battleType = WBattleGlobal:getCurrent().m_nBattleType
        local battleChannle = WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle
        local battleMode = WBattleGlobal:getCurrent().m_tMakePairOk.battleMode
        WZLog("WndBattleHud:onEnter skinSkillCloss",tostring(battleType),tostring(battleChannle),tostring(battleMode))
        for i = 1, #tabSkinSkillCloss do
            if tonumber(tabSkinSkillCloss[i]) == 91 and WBattleGlobal:getCurrent():isTeamStage() then --组队副本
                self.m_bCloseSkinSkillSwitch = true
            elseif tonumber(tabSkinSkillCloss[i]) == 136 and WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_SINGLE) then --单人副本
                self.m_bCloseSkinSkillSwitch = true
            elseif tonumber(tabSkinSkillCloss[i]) == 137 and WBattleGlobal:getCurrent():isWorldBossStage() then --世界boss
                self.m_bCloseSkinSkillSwitch = true
            elseif tonumber(tabSkinSkillCloss[i]) == 138 and battleType == BattleConstants.g_nBATTLE_TYPE_NORMAL and battleChannle == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_DZ and battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_JJ then --竞技场
                self.m_bCloseSkinSkillSwitch = true
            elseif tonumber(tabSkinSkillCloss[i]) == 139 and battleType == BattleConstants.g_nBATTLE_TYPE_BOSS and battleMode == BattleConstants.g_tBossBattleMode.MODE_TOWER_STAGE then --爬塔副本
                self.m_bCloseSkinSkillSwitch = true
            elseif tonumber(tabSkinSkillCloss[i]) == 140 and battleType == BattleConstants.g_nBATTLE_TYPE_BOSS and battleMode == BattleConstants.g_tBossBattleMode.MODE_DAILY_STAGE then --日常副本
                self.m_bCloseSkinSkillSwitch = true
            elseif tonumber(tabSkinSkillCloss[i]) == 141 and battleType == BattleConstants.g_nBATTLE_TYPE_NORMAL and battleChannle == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_PW then --排位赛
                self.m_bCloseSkinSkillSwitch = true
            elseif tonumber(tabSkinSkillCloss[i]) == 152 and battleType == BattleConstants.g_nBATTLE_TYPE_NORMAL and battleChannle == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_GZ then --公会战
                self.m_bCloseSkinSkillSwitch = true
            elseif tonumber(tabSkinSkillCloss[i]) == 164 and battleType == BattleConstants.g_nBATTLE_TYPE_NORMAL and battleChannle == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_LS then --英雄联赛
                self.m_bCloseSkinSkillSwitch = true
            elseif tonumber(tabSkinSkillCloss[i]) == 299 and battleType == BattleConstants.g_nBATTLE_TYPE_NORMAL and battleChannle == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_ZLS then --战略赛
                self.m_bCloseSkinSkillSwitch = true
            end
            if false and self.m_bCloseSkinSkillSwitch == true then
                GetElement(self.m_root, "btnBigSkillIcon_WndBattleHud", WZUIButton):setVisible(false)
                GetElement(self.m_root, "txtBigSkillSwitch_WndBattleHud", WZUILabelTTF):setText(LocalStrings.BIGSKILL_TYPE[self.m_nBigSkillIndex])
                break
            end
        end
    end
	self:createAngerAnim()

    WndBattleHud:getTargetRangeElement():setVisible(false)

	self:_createFaceBox()

	if PlatformInfo:getCurrentPlatform() == PlatformInfo.type.PLATFORM_WIN32 then
		--GetElement(self.m_root,"btnAddScale_WndBattleHud"):setVisible(true)
		--GetElement(self.m_root,"btnMinusScale_WndBattleHud"):setVisible(true)
	end

    if WBattleGlobal:getCurrent():isShowAutoFightBtnFight() and not WBattleGlobal:getCurrent():isAudience() and not WBattleGlobal:getCurrent():isReplayGame() and not AutoRunBattleConst.AUTO_RUN_BATTLE then 
        if CheckButtonShow(160) then 
            GetElement(self.m_root, "btnAutoFight_WndBattleHud", WZUIButton):setVisible(true)
        end
        GlobalGame.g_bIsAutoFightOpen = GlobalGame.g_saveAutoFightOpenState
        if GlobalGame.g_bIsAutoFightOpen then 
            GetElement(self.m_root, "imgAutoF_WndBattleHud", WZUIImage):setFile("ui/combat/optimize/battle_icon_stopAuto.png")
        end
    end

    --设置战斗节奏
    self:setTimeScaleByMode()
    
    if WBattleGlobal:getCurrent():getBattleType() == BattleConstants.g_nBATTLE_TYPE_NORMAL then
        
    end

    self:showCopyView()

    self:showReplayUI()

	BattleCtbManager:startBattleCtb(self.m_root)
	
	self:createMedal()
	
	self:setBigSkillPer(0)

    CellNetSignal:showInterface(GetElement(self.m_root, "conWifi_WndBattleHud", WZUIContainer), GlobalMethod:ccp(0.5,0.5))

    if GlobalGame.g_bIsOpenTouchScaleBtn ~= true then
        GetElement(self.m_root,"btnScale_WndBattleHud",WZUIButton):setVisible(false)
    end

    if WBattleGlobal:getCurrent():isAudience() then
        self:setAudienceMode()
    end

    self:checkVoice()
    self:_setStaticText()

    self:showGuideText()
    self:_setKMSkillShowState()

    if IsIphoneX() then
        GetElement(self.m_root, "btnSetting_WndBattleHud", WZUIButton):setRelativePositionLuaTo(0.955,0.995)
        GetElement(self.m_root, "conWifi_WndBattleHud", WZUIContainer):setRelativePositionLuaTo(0.957708,0.935)
        GetElement(self.m_root, "btnPassTurn_WndBattleHud",WZUIButton):setRelativePositionLuaTo(0.955,0.87)
        GetElement(self.m_root, "conMySkill_WndBattleHud", WZUIContainer):setRelativePositionLuaTo(0.5,0.028)
        GetElement(self.m_root, "conBattleCtb_WndBattleHud", WZUIContainer):setRelativePositionLuaTo(0.52,0.5)
        GetElement(self.m_root, "conBigBattleCtb_WndBattleHud", WZUIContainer):setRelativePositionLuaTo(0.54,0.5)
        GetElement(self.m_root, "conReplay_WndBattleHud", WZUIContainer):setRelativePositionLuaTo(0.97,0.570076)
        GetElement(self.m_root, "btnAutoFight_WndBattleHud",WZUIButton):setRelativePositionLuaTo(0.955,0.636)
        GetElement(self.m_root, "btnGameFlash_WndBattleHud",WZUIButton):setRelativePositionLuaTo(0.955,0.753)
    end
    AdaptLanguage(self)

    --防止新手引导中对话框导致闪退
    self.m_tButtonTipsAnim1, self.m_tButtonTipsDialog1 = nil, nil
    self.m_tButtonTipsAnim2, self.m_tButtonTipsDialog2 = nil, nil
    self.m_tButtonTipsAnim3, self.m_tButtonTipsDialog3 = nil, nil
    self.m_tButtonTipsAnim4, self.m_tButtonTipsDialog4 = nil, nil
    self.m_tButtonTipsAnim5, self.m_tButtonTipsDialog5 = nil, nil
    self.m_tButtonTipsDialog6, self.m_tButtonTipsDialogObj6 = nil, nil
    self.m_tDialog = nil
    self.m_tDialog2 = nil


    --新手boss显示跳过新手按钮
    self:_showSkipTeachBtn()
end

--@brief 显示引导文本
function WndBattleHud:showGuideText()
    local mapId = WBattleGlobal:getCurrent().m_tMakePairOk.mapId
    local txtTeach = GetElement(WndBattleHud.m_root,"txtTeach_WndBattleHud",WZUILabelTTF)
    if WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_SINGLE) then
        local tSingleInfo = GDatatab_single_map["id_"..mapId]
        if tSingleInfo and tSingleInfo.hint and tostring(tSingleInfo.hint) ~= "-1" then
           txtTeach:setVisible(true)
           txtTeach:setText(tSingleInfo.hint)
        end
    end
end

--@brief 观战
function WndBattleHud:setAudienceMode()
    GetElement(self.m_root,"btnBigSkill_WndBattleHud"):setTouchEnable(false)
    GetElement(self.m_root,"conMyHud_WndBattleHud"):setTouchEnable(false)
    GetElement(self.m_root,"btnFace_WndBattleHud"):setTouchEnable(false)
    GetElement(self.m_root,"btnScale_WndBattleHud"):setTouchEnable(false)
    GetElement(self.m_root,"btnAutoFight_WndBattleHud", WZUIButton):setVisible(false)
    self:setPassTurnBtnEnable(false)
    self:setBigSkillEnable(false)
end

--@brief    退出场景时被调用的函数
--@param    element:表绑定的UI节点引用
--@note     在这里做场景退出前的清理工作
function WndBattleHud:onExit(element)
    WZLog("WndBattleHud:onExit reset timeScale")
    CCDirector:sharedDirector():getScheduler():setTimeScale(1)
    self:quitAutoFight()
    self:_removeDialog()
    if WndBattleHud.m_tLine then
        WZLog("WndBattleHud:onExit one")
        WndBattleHud.m_tLine:destroy()
        WndBattleHud.m_tLine = nil
    end

	self:_unInit()
end

--@brief    触摸面板Began回调
--@param    element:回调绑定的UI节点引用
--@param    pt：触摸点
function WndBattleHud:onTouchBegan(element, pt)
    -- body
    WZLog("WndBattleHud:onTouchBegan")
    self.m_nTouchBeginTime = WZThread:getUTickCount()
    
    if WndItemInfo.m_root then
        WndItemInfo:onCloseClick()
    end

    if WndTips.m_root and not WndTips:checkPointInBtn(pt) then
        WndTips:_onCloseClick()
    end
    local conTalkLimit = GetElement(self.m_root, "conTalkLimit_WndBattleHud", WZUIContainer)
    WZLog("WndBattleHud:onTouchBegan", conTalkLimit:isVisible(), self:checkPointInBtn(pt))
    if conTalkLimit:isVisible() and not self:checkPointInBtn(pt) then 
        conTalkLimit:setVisible(false)
    end
end

--@brief 显示副本信息
function WndBattleHud:showCopyView()
    local container = nil
     if WndBattleHud.m_root then
        container = GetElement(self.m_root, "conInfo_WndBattleHud", WZUIContainer)
    end
    --pvp
    if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_NORMAL then
        if WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_LS then
            --英雄联赛
            local infoView = WndHeroCDView:createElement()
            if container then
                container:addChild(infoView)
            end
        elseif WBattleGlobal:getCurrent():isGuildWarStage() then
            --公会战
            local infoView = WndHeroCDView:createElement()
            if container then
                container:addChild(infoView)
            end
        elseif WBattleGlobal:getCurrent():isEscapeBattle() then
            --逃杀
            --组队副本
            local infoView = WndCopyTeamCDView:createElement()
            --infoView:setRelativePositionLuaTo(1,0.92)
            infoView:setRelativePositionLuaTo(0.99,1)
            if container then
                container:addChild(infoView)
            end
        end
    --副本信息显示
    elseif WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS then
        --单人副本信息显示
        if WBattleGlobal:getCurrent():isSingleStage() then
            --日常
            if WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_DAILY_STAGE then
                if container and WBattleGlobal:getCurrent():getCopyData() then 
                    container:addChild(WBattleGlobal:getCurrent():getCopyData():getInfoView())
                    --[[
                    --金币副本屏蔽道具技能栏
                    if WBattleGlobal:getCurrent():getCopyData() then
                        local tmpCon = nil
                        tmpCon = GetElement(self.m_root, "conMySkill_WndBattleHud", WZUIContainer)
                        tmpCon:setVisible(false)
                        tmpCon = GetElement(self.m_root, "conFly_WndBattleHud", WZUIContainer)
                        tmpCon:setVisible(false)
                    end
                    --]]
                end
            elseif WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_TOWER_STAGE then
                --爬塔
                local infoView = WndCopyTowerInfoView:createElement()
                --infoView:setRelativePositionLuaTo(1,0.902)
                infoView:setRelativePositionLuaTo(0.96,1)
                if container then
                    container:addChild(infoView)
                end
            elseif WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_NORMAL_HARD then
                --单人副本
                local infoView = WndCopySingleInfoView2:createElement()
                --infoView:setRelativePositionLuaTo(1,0.902)
                infoView:setRelativePositionLuaTo(0.96,1)
                if container then
                    container:addChild(infoView)
                end
            elseif WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_TRAIN_STAGE then
                --训练营
                local infoView = WndCopyFlyInfoView:createElement()
                --infoView:setRelativePositionLuaTo(1,0.902)
                infoView:setRelativePositionLuaTo(0.96,1)
                if container then
                    container:addChild(infoView)
                end
            else
                --单人副本
                local infoView = WndCopySingleInfoView:createElement()
                --infoView:setRelativePositionLuaTo(1,0.902)
                infoView:setRelativePositionLuaTo(0.96,1)
                if container then
                    container:addChild(infoView)
                end
            end
        elseif WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_WORLDBOSS then
            --世界boss
            local infoView = WndCopyWorldBossInfoView:createElement()
            --infoView:setRelativePositionLuaTo(0.5,0.80)
            if container then
                container:addChild(infoView)
            end
        elseif WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_REMAINSBOSS then
            --遗迹副本
            local infoView = WndCopyRelicView:createElement()
            infoView:setRelativePositionLuaTo(0.92,0.98)
            if container then
                container:addChild(infoView)
            end
        elseif WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODEL_GUILD_STATE then
            --公会副本
            local infoView = WndCopyGuildInfoView:createElement()
            infoView:setRelativePositionLuaTo(0.92,0.98)
            if container then
                container:addChild(infoView)
            end
        elseif WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_WORLDTEAMBOSS then
            --世界组队boss
            local infoView = WndWorldTeamBossInfoView:createElement()
            if container then
                container:addChild(infoView)
            end
        elseif WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_COUPLE_HEGEMONY then
            --夫妻争霸boss
            local infoView = WndCoupleHegemonyInfoView:createElement()
            if container then
                container:addChild(infoView)
            end
        elseif WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_DOUBLETOWER_STAGE then
            --双人爬塔
            local infoView = WndCopyTowerInfoView:createElement()
            WndCopyTowerInfoView:setType(1)
            infoView:setRelativePositionLuaTo(0.96,1)
            if container then
                container:addChild(infoView)
            end
        else
            --组队副本
            local infoView = WndCopyTeamCDView:createElement()
            --infoView:setRelativePositionLuaTo(1,0.92)
            infoView:setRelativePositionLuaTo(0.96,1)
            if container then
                container:addChild(infoView)
            end
        end
    end

    --英雄塔副本显示buff
    self:_showHeroTowerBuff()
end

--@brief 录像回放ui
function WndBattleHud:showReplayUI()
    if WBattleGlobal:getCurrent():isReplayGame() then
        local conReplay =  GetElement(self.m_root,"conReplay_WndBattleHud",WZUIContainer)
        self.m_btnReplayExit = GetElement(conReplay,"btnReplayExit_WndBattleHud",WZUIButton)
        self.m_btnReplayStop = GetElement(conReplay,"btnReplayStop_WndBattleHud",WZUIButton)
        self.m_btnReplayPlay = GetElement(conReplay,"btnReplayPlay_WndBattleHud",WZUIButton)
        self.m_btnReplaySpeed1 = GetElement(conReplay,"btnReplaySpeed1_WndBattleHud",WZUIButton)
        self.m_btnReplaySpeed2 = GetElement(conReplay,"btnReplaySpeed2_WndBattleHud",WZUIButton)
        self.m_btnReplaySpeed4 = GetElement(conReplay,"btnReplaySpeed4_WndBattleHud",WZUIButton)
        self.m_nReplayTimeScale = 1

        self.m_btnReplayExit:setVisible(true)
        self.m_btnReplayStop:setVisible(true)
        self.m_btnReplayPlay:setVisible(false)
        self.m_btnReplaySpeed1:setVisible(true)
        self.m_btnReplaySpeed2:setVisible(false)
        self.m_btnReplaySpeed4:setVisible(false)

        self:getBigSkillContainer():setVisible(false)
        GetElement(self.m_root,"btnSetting_WndBattleHud",WZUIButton):setVisible(false)
        GetElement(self.m_root,"btnChat_WndBattleHud",WZUIButton):setVisible(false)
        GetElement(self.m_root,"conFace_WndBattleHud",WZUIContainer):setVisible(false)
        GetElement(self.m_root,"btnScale_WndBattleHud",WZUIButton):setVisible(false)
        GetElement(self.m_root,"btnMyHudSwitch_WndBattleHud",WZUIButton):setVisible(false)
    end
end

--@brief    回放退出
--@note
function WndBattleHud:onClickReplayExit(sender)
    MsgBoxManager:showConfirmCancelBox(LocalStrings.BATTLE_SURE_REPLAY_EXIT, self, self.exitReplay, nil)
end

--@brief    回放退出
function WndBattleHud:exitReplay(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        SceneBattle:leftBattle()
        -- if WBattleGlobal:getCurrent():isSingleStage() then
        
        -- SceneBattle:leftBattle()
        -- else
        --     ProtocolProcessorBattleInterface:send_BATTLE_QuitBattle(WBattleGlobal:getCurrent().m_tMakePairOk.battleId,WBattleGlobal:getCurrent():getMyBattleId())
        --     SceneBattle:leftBattle()
        -- end
    end
end


--@brief    回放暂停
--@note
function WndBattleHud:onClickReplayStop(sender)
    self.m_btnReplayStop:setVisible(false)
    self.m_btnReplayPlay:setVisible(true)
    CCDirector:sharedDirector():getScheduler():setTimeScale(0)
    SceneBattle:disableSchedule()

    local msg = MsgManager:getNoneBlockMsgByName("BattleMsgReplayGame")
    if msg then
        msg:setReplaySpeed(0)
    end
end

--@brief    回放继续
--@note
function WndBattleHud:onClickReplayPlay(sender)
    self.m_btnReplayStop:setVisible(true)
    self.m_btnReplayPlay:setVisible(false)
    SceneBattle:startSchedule()
    CCDirector:sharedDirector():getScheduler():setTimeScale(self.m_nReplayTimeScale)

    local msg = MsgManager:getNoneBlockMsgByName("BattleMsgReplayGame")
    if msg then
        msg:setReplaySpeed(self.m_nReplayTimeScale)
    end
end

--@brief    回放速度1
--@note
function WndBattleHud:onClickReplaySpeed1(sender)
    self.m_btnReplaySpeed1:setVisible(false)
    self.m_btnReplaySpeed2:setVisible(true)
    self.m_nReplayTimeScale = 2
    self:onClickReplayPlay()
end

--@brief    回放速度2
--@note
function WndBattleHud:onClickReplaySpeed2(sender)
    self.m_btnReplaySpeed2:setVisible(false)
    self.m_btnReplaySpeed4:setVisible(true)
    self.m_nReplayTimeScale = 4
    self:onClickReplayPlay()
end

--@brief    回放速度4
--@note
function WndBattleHud:onClickReplaySpeed4(sender)
    self.m_btnReplaySpeed4:setVisible(false)
    self.m_btnReplaySpeed1:setVisible(true)
    self.m_nReplayTimeScale = 1
    self:onClickReplayPlay()
end

--Test
function WndBattleHud:onAddScale()
	if SceneBattle:getFrontLayer():getScale() + 0.05 <= 1.2 then
		SceneBattle:getFrontLayer():setScale(SceneBattle:getFrontLayer():getScale() + 0.05)
        WZLog("BattleScreen:setScale 7")
		SceneBattle:getFrontLayer():setPositionX(SceneBattle:getFrontLayer():getPositionX()-0.05*SceneBattle:getFrontLayer():getContentSize().width/2 )
            SceneBattle:getFrontLayer():setPositionY(SceneBattle:getFrontLayer():getPositionY()-0.05*SceneBattle:getFrontLayer():getContentSize().height/2 )
		BattleMapManager:getFrontControl():centerOnPoint(BattleMapManager:getFrontControl():getCurScreenCenter())
	end
end

--Test
function WndBattleHud:onMinusScale()
	if SceneBattle:getFrontLayer():getScale() - 0.05 >= BattleMapManager:getFrontControl():getZoomOutInit() then
		SceneBattle:getFrontLayer():setScale(SceneBattle:getFrontLayer():getScale() - 0.05)
        WZLog("BattleScreen:setScale 8")
		SceneBattle:getFrontLayer():setPositionX(SceneBattle:getFrontLayer():getPositionX()+0.05*SceneBattle:getFrontLayer():getContentSize().width/2 )
            SceneBattle:getFrontLayer():setPositionY(SceneBattle:getFrontLayer():getPositionY()+0.05*SceneBattle:getFrontLayer():getContentSize().height/2 )
		BattleMapManager:getFrontControl():centerOnPoint(BattleMapManager:getFrontControl():getCurScreenCenter())
	end
end

--@brief    游戏节奏
function WndBattleHud:onGameFlashClick(sender)
    local bIsRoomOwner = WBattleGlobal:getCurrent().m_tMakePairOk.bIsRoomOwner
    if not bIsRoomOwner and (WBattleGlobal:getCurrent():isDoubleTowerStage() or WBattleGlobal:getCurrent():isWorldTeamBossStage() or WBattleGlobal:getCurrent():isCoupleHegemonyStage() or WBattleGlobal:getCurrent():isTeamStage()) then
        MsgBoxManager:showTipBox(LocalStrings.SETSPEED_ATT)
        return
    end

    local speedlevel = string.sub(CacheCenter:getGameParam()["speedlevel"],2,-2)
    local tLevelLimit = SplitStringWithSeparator(speedlevel, ",")

    local level = CacheCenter:getPlayerInfo().level

    local tGameflashIndex = {}
    tGameflashIndex[0] = 1 --速度x1
    if level >= tonumber(tLevelLimit[1]) then
        tGameflashIndex[1] = 2 --速度x2
    end
    if level >= tonumber(tLevelLimit[2]) then
        tGameflashIndex[2] = 4 --速度x4
    end

    local tempIndex = 0
    local data = WZDataFile:getInstance():getUserData()
    if data then
        local value = data:getStringValue("BattleSetting", "gameflash")
        if value ~= nil and value ~= "" then
            tempIndex = (tonumber(value) + 1) % GetTableLen(tGameflashIndex)
        else
            tempIndex = tempIndex + 1
        end
            
        CCDirector:sharedDirector():getScheduler():setTimeScale(tGameflashIndex[tempIndex])

        data:setStringValue("BattleSetting", "gameflash", tempIndex)
        data:flush()

        self:setGameFlashBtnStatus(tempIndex)
        if bIsRoomOwner then 
            ProtocolProcessorSceneBattle:send_BATTLE_ChangeNeedleRate(WBattleGlobal:getCurrent().m_tMakePairOk.battleId, WBattleGlobal:getCurrent():getMyBattleId(), tempIndex)
        end
    end
end

------refersh

--@brief    重置WndBattleHud
--@param    nPlayerId:英雄ID
--@note     每回合调用
function WndBattleHud:reset(nPlayerId)
	if self.m_root then
        WndBattleHud.m_nCanUsePlayer = nPlayerId
		if self.m_tMyHero and nPlayerId == self.m_tMyHero:getBattleId() or (WBattleGlobal:getCurrent():isAudience() and WBattleGlobal:getCurrent():getCurrentCharacter():getType() == 0) then

			self:setMyHudSwitchEnable(true)

			self:setMyHudShow(true)

			self:resetSkill(nil,1)
			self:resetItem()
            self:resetKMSkill()

			self.m_bPreviousHudStatus = true

			self:setBigSkillEnable(true)

			BattleMapManager:getFrontControl():resetBottomExpand()
            if WBattleGlobal:getCurrent():isFog() then
                BattleMapManager:getFogControl():resetBottomExpand()
            end

		else

			self:setMyHudSwitchEnable(false)

			--self:setMyHudShow(false)

			self:setBigSkillEnable(true)

		end
	end
end

------Fly

--@brief    点击飞行后的回调
--@param    sender:飞行按钮元素
--@note
function WndBattleHud:onReadyFly(sender, isTeach)
    WZLog("WndBattleHud:onReadyFly 1", self.m_nCanUsePlayer, self.m_tMyHero:getBattleId(), tostring(isTeach), self.m_tMyHero:getUseSkillTime())
    if WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle then
        MsgBoxManager:showTipBox(LocalStrings.BATTLE_NOT_MY_TURN)
        return
    end

    if (self.m_nCanUsePlayer ~= self.m_tMyHero:getBattleId()) or 
        (isTeach == nil and TeachGroup1.ISBATTLE == true and TeachGroup1.ISFLY ~= true) or 
        (isTeach == nil and ( WBattleGlobal:getCurrent():isGameOver() == true)) or 
        (isTeach == nil and self.m_tMyHero:getUseSkillTime() >= 1) or 
        (self.m_tMyHero:isInBuffState(EffectTypeConfig.LIMIT_FLY)) then
        return
    end
    if (self.m_nCanUsePlayer ~= self.m_tMyHero:getBattleId()) or 
        (isTeach == nil and TeachGroup1.ISBATTLE == true and TeachGroup1.ISFLY ~= true) or 
        (isTeach == nil and ( WBattleGlobal:getCurrent():isGameOver() == true)) or 
        (isTeach == nil and self.m_tMyHero:getUseSkillTime() >= 1) or 
        (self.m_tMyHero:isInBuffState(EffectTypeConfig.LIMIT_FLY)) then
        return
    end

    --自动战斗不可操作提示
    if GlobalGame.g_bIsAutoFightOpen then 
        MsgBoxManager:showTipBox(LocalStrings.BATTLE_AUTOFIGHT_ATT)
        return 
    end

    WZLog("WndBattleHud:onReadyFly 2", tostring(WBattleGlobal:getCurrent():isMyTurn()))
	if WBattleGlobal:getCurrent():isMyTurn() then
		sender:setTouchEnable(false)
        BattleHeroUse:heroUse(self.m_tMyHero:getBattleId(),BattleHeroUse.USE_FLY)
		--self:setBigSkillEnable(false)
        WBattleGlobal:getCurrent().m_nAutoFightActIndex = 2
		self:useMySkill(BattleHeroUse.FLY_SKILL_ID)

        WBattleGlobal:getCurrent():getSkillById(62).isNoFirst = true
	end

    self:setFlyPos()
end

function WndBattleHud:setFlyPos()
    local btn = GetElement(self.m_root,"btnFly_WndBattleHud")
    btn:setRelativePosition(btn:getRelativePosition())
end

--@brief    是否可点击Fly按钮
--@param    bEnable:是否可点击
--@note
function WndBattleHud:setMyFlyEnable(bEnable)
	GetElement(self.m_root,"btnFly_WndBattleHud"):setTouchEnable(bEnable)
end
------TurnTime

--@brief    回合开始计时
--@param    nTime:回合时间长度
--@note
function WndBattleHud:startTurnTime(nTime)
	WBattleGlobal:getCurrent():collectGarbage()
	self:isStopTurnTime(false)
	self:_updateTurnTime(nTime)
    self.m_nStartTime = os.time()
    self.m_bStopTimeTtf = nil
end

function WndBattleHud:isStopTurnTime(bStop, isOnlyTtfEnd)
    if isOnlyTtfEnd == nil then
        self.m_bStopTime = bStop
    else
        self.m_bStopTimeTtf = true
    end
end

--@brief    回合结束计时
--@note
function WndBattleHud:endTurnTime(isOnlyTtfEnd)
	--self:_updateTurnTime(0)
	self:isStopTurnTime(true, isOnlyTtfEnd)
	if self.m_root then
		GetElement(self.m_root,"btnPassTurn_WndBattleHud"):setTouchEnable(false)
	end
    self.m_nCanUsePlayer = 0

    self:_removeFinger()
end

--@brief    操作范围更新函数
function WndBattleHud:isUpdateTouchCircle()
    if self:getMyHero() == nil then
        return
    end

    local pos = self:getMyHero():getPosition()
    local width = BattleMapManager.m_nWidth

    local distanceX = math.abs(pos.x - width) > pos.x and pos.x or math.abs(pos.x - width)
    local distanceY = pos.y
    local scale = WBattleGlobal:getCurrent().m_nScale
    local dis = 200
    local isUpdate = false
    --WZLog("WndBattleHud:isUpdateTouchCircle",distanceX,distanceY,scale,width,pos.x,pos.y)
    if (distanceX <= dis or distanceY <= dis) and scale ~= 1 then
        isUpdate = true
    end

    -- local mapId = WBattleGlobal:getCurrent().m_tMakePairOk.mapId
    -- local ttf = GetElement(WndBattleHud.m_root,"txtTeach_WndBattleHud",WZUILabelTTF)
    -- --WZLog("WndBattleHud:isUpdateTouchCircle", scale, self:getMyHero().m_nLevel, ttf:getText())
    -- if scale == 1 and self:getMyHero().m_nLevel <= 15 then
    --     if ttf:getText() ~= TeachGroup1:getTeachText(148) or ttf:isVisible() ~= true then
    --         ttf:setText(TeachGroup1:getTeachText(148))
    --         ttf:setVisible(true)
    --     end
    -- elseif scale == 0 and self:getMyHero().m_nLevel <= 7 and mapId ~= 10101 and mapId ~= 9999 and WBattleGlobal:getCurrent().m_nCurrentPlayerId == self:getMyHero():getBattleId() then
    --     if ttf:getText() ~= TeachGroup1:getTeachText(131) or ttf:isVisible() ~= true then
    --         ttf:setText(TeachGroup1:getTeachText(131))
    --         ttf:setVisible(true)
    --     end
    -- elseif ttf:isVisible() == true then
    --     ttf:setVisible(false)
    -- end
    return isUpdate
end

--@brief    更新回合时间
--@param    dt:经过的时间
--@note
function WndBattleHud:updateTeach(dt)
    if WindowManager:isHaveTeachTouchLayer() == true or WndTeachTalk.m_root ~= nil or CacheCenter:getPlayerInfo() == nil then
        return
    end

    if TeachGroup1:isTeach() and CacheCenter:getPlayerInfo().level <= 4 and WBattleGlobal:getCurrent():isMyTurn() and WndBattleHud:isShowingMyHudEnd() and BattleMsgCanStartCurRound.m_bIsEnd == true then
        local hero = WBattleGlobal:getCurrent():getMyHero()
        local heroPos = hero:getPosition()
        local isRight = true
        local myTurnCount = hero.m_nMyTurnCount
        local mapId = WBattleGlobal:getCurrent().m_tMakePairOk.mapId
        if mapId == 10102 and ((myTurnCount == 1 and self.m_nTurnTime <= 20) or (myTurnCount ~= 1 and self.m_nTurnTime <= 15)) then
            local textOffset = {x=50,y=150}
            local textOffset2 = {x=-250,y=150}
            local animOffset = {x=0,y=0}
            local animPos = GlobalMethod:ccp(WBattleGlobal:getCurrent():getMyHero():getPosition().x,WBattleGlobal:getCurrent():getMyHero():getPosition().y)
            animPos = SceneBattle:getFrontLayer():convertToWorldSpaceAR(animPos)
            animPos = SceneBattle:getTopInfoLayer():convertToNodeSpace(animPos)
            animPos = GlobalMethod:ccp(animPos.x + animOffset.x, animPos.y + animOffset.y)

            for i,guai in pairs(WBattleGlobal:getCurrent():getGuaiList()) do
                if heroPos.x < guai:getPosition().x then
                    isRight = false
                end
            end

            if self.m_tDialog == nil then
                if isRight then
                    self:_showFinger(4,GlobalMethod:ccp(animPos.x + textOffset.x, animPos.y + textOffset.y),-90,true,nil,"attack")
                else
                    self:_showFinger(4,GlobalMethod:ccp(animPos.x + textOffset2.x, animPos.y + textOffset2.y),0,false,nil,"attack")
                end
                self.m_tDialog.m_root:setVisible(false)
            else
                if isRight then
                    self.m_tFinger:setPosition(animPos.x, animPos.y)
                    self.m_tFinger:setRotation(-90)
                    self.m_tFingerAnim:setRotation(90)
                    self.m_tFingerAnim:setScaleX(2.5)
                    self.m_tDialog.m_root:setPosition(GlobalMethod:ccp(animPos.x + textOffset.x, animPos.y + textOffset.y))
                else
                    self.m_tFinger:setPosition(animPos.x, animPos.y)
                    self.m_tFinger:setRotation(0)
                    self.m_tFingerAnim:setRotation(0)
                    self.m_tFingerAnim:setScaleX(-2.5)
                    WZLog("WndBattleHud:_showFinger2", animPos.x + textOffset2.x, animPos.y + textOffset2.y, textOffset2.x, textOffset2.y)
                    self.m_tDialog.m_root:setPosition(GlobalMethod:ccp(animPos.x + textOffset2.x, animPos.y + textOffset2.y))
                end

                if self.m_tDialog.m_root:isVisible() == false then
                    self.m_tDialog.m_root:setVisible(true)
                end
            end
        -- elseif mapId == 10104 then
        --     local tempElement
        --     if WBattleGlobal:getCurrent():isGameOver() ~= true and self.m_bIsVisble == true and WndBattleHud:isShowingMyHudEnd() then
        --         local cd = self:getMyHero().m_tSkillCdList[21]
        --         WZLog("WndBattleHud:updateTeach", cd)
        --         if cd == nil then
        --             if self.m_tButtonTipsAnim5 == nil then
        --                 local index = 185
        --                 local offset = BattleCommon:getPointTable(80 ,35)
        --                 local pos = BattleCommon:getPointTable(17,-37)
        --                 if IsIphoneX() then
        --                     pos = BattleCommon:getPointTable(17,-23)
        --                 end
        --                 self.m_tButtonTipsAnim5, self.m_tButtonTipsDialog5 = WindowManager:addTipForButton(self:getSkillCellTeach(4), 0.35, pos, index, 4, offset,nil)
        --             end
        --         else
        --             if self.m_tButtonTipsAnim5 then
        --                 --WindowManager:removeTeachShelterLayer()
        --                 self.m_tButtonTipsAnim5:removeFromParentAndCleanup(true)
        --                 self.m_tButtonTipsDialog5:removeFromParentAndCleanup(true)
        --                 self.m_tButtonTipsAnim5, self.m_tButtonTipsDialog5 = nil, nil
        --             end
        --         end
        --     end
        end

    end
end

function WndBattleHud:_showFinger(index, textOffset, rotation, isFlip, animOffset, sound)
    WZLog("WndBattleHud:_showFinger1", textOffset.x, textOffset.y)

    self:_buildShootDialog(index, textOffset, sound)
    animOffset = animOffset or {x=0,y=0}
    local animPos = GlobalMethod:ccp(WBattleGlobal:getCurrent():getMyHero():getPosition().x,WBattleGlobal:getCurrent():getMyHero():getPosition().y)
    animPos = SceneBattle:getFrontLayer():convertToWorldSpaceAR(animPos)
    animPos = SceneBattle:getTopInfoLayer():convertToNodeSpace(animPos)
    animPos = GlobalMethod:ccp(animPos.x + animOffset.x, animPos.y + animOffset.y)
    self.m_tFinger, self.m_tFingerAnim = TeachBattleCommon:showFingerAnimation(SceneBattle:getTopInfoLayer(), animPos, rotation, 0, isFlip)
    return true
end

function WndBattleHud:_buildShootDialog(index,offset, sound)
    WZLog("WndBattleHud:_buildShootDialog",index,tostring(sound))
    local strText = LocalStrings["TEACH_" .. index]
    if isChannelPC() then 
        if tonumber(index) == 4 then 
            strText = LocalStrings.QQHALL_TEXT1[3]
        elseif tonumber(index) == 107 then 
            strText = LocalStrings.QQHALL_TEXT1[4]
        elseif tonumber(index) == 113 then 
            strText = LocalStrings.QQHALL_TEXT1[5]
        end
    end
    _,self.m_tDialog = Teach:showDialog( WBattleGlobal:getCurrent():getMyHero():getAnimation():getAnimNode(),SceneBattle:getTopInfoLayer(), strText, 4 , offset or GlobalMethod:ccp(0,0), 1 )
    if sound then
        SoundManager:playEffectSound(GetRoleSound() .. "/" .. sound..".mp3")
    end
end

function WndBattleHud:_removeFinger()
    WZLog("WndBattleHud:_removeFinger", self.m_tDialog)
    if self.m_tDialog and self.m_tDialog.m_root then
        self.m_tFinger:removeFromParentAndCleanup(true)
        self.m_tFinger = nil
        self.m_tFingerAnim = nil
        self.m_tDialog:removeDialog(true)
        self.m_tDialog = nil
    end

    if self.m_tButtonTipsAnim5 and self.m_tButtonTipsDialog5 then
        --WindowManager:removeTeachShelterLayer()
        self.m_tButtonTipsAnim5:removeFromParentAndCleanup(true)
        self.m_tButtonTipsDialog5:removeFromParentAndCleanup(true)
        self.m_tButtonTipsAnim5, self.m_tButtonTipsDialog5 = nil, nil
    end
    BattleMsgCanStartCurRound.m_bIsEnd = nil
end

--@brief    获取当前随机数
function WndBattleHud:getCurRandNum()
    self.m_nRandNumIndex = self.m_nRandNumIndex or 1
    self.m_tRandNumList = WBattleGlobal:getCurrent().m_tBattleRand
    self.m_nRandNumIndex = (self.m_nRandNumIndex + math.abs(self:getMyHero():getBattleId())) % 10 + 1
    self.m_nCurRandNum = self.m_tRandNumList[self.m_nRandNumIndex]

    return self.m_nCurRandNum
end

--@brief    更新参考线
function WndBattleHud:updatePointLine()
    local hero = WBattleGlobal:getCurrent():getCurrentCharacter()
    --WZLog("WndBattleHud:updatePointLine one", tostring(not WBattleGlobal:getCurrent():isWindTeach()), hero:getBattleId(), self:getMyHero():getBattleId())
    if (not WBattleGlobal:getCurrent():isWindTeach() and not WBattleGlobal:getCurrent():isChapterOneTeach() and not WBattleGlobal:getCurrent():isFirstPvp() ) or hero ~= self:getMyHero() or hero:isUseFly() or WBattleGlobal:getCurrent().m_bGameOver == true or WBattleGlobal:getCurrent().m_tBattleRand == nil then
        if self.m_tLine and self.m_tLine:isVisible() then
            self.m_tLine:setVisible(false)
        end
        return
    end

    local aimHero = WBattleGlobal:getCurrent():getGuaiSortList()[1]
    if aimHero == nil then
        WZLog("WndBattleHud:updatePointLine No aimHero,use myHero instead")
        aimHero = WBattleGlobal:getCurrent():getOneOtherTeamHero(WBattleGlobal:getCurrent():getMyHero():getBattleId())
    end

    local mapId = WBattleGlobal:getCurrent().m_tMakePairOk.mapId
    local speed = {}
    local sPos = hero:getPosition()
    local ePos = BattleCommon:getPointTable(aimHero:getPosition().x, aimHero:getPosition().y + 50)
    if mapId == 10104 and hero.m_nMyTurnCount == 1 then
        ePos.x = ePos.x -5
        ePos.y = ePos.y - 100
    end

    local angle
    local face
    local isAtkSucceed = false
    local heroPos = BattleCommon:getPointTable(aimHero:getPosition().x, aimHero:getPosition().y)
    local count = 0
    if ePos.x <= sPos.x then
        face = 1
        angle = -68 -90;
        sPos = BattleCommon:getShootPos(true)
    else
        face = 0
        angle = -68;
        sPos = BattleCommon:getShootPos(false)
    end
    
    if mapId == 10301 or mapId == 10302 then
        isAtkSucceed,speed = BattleAiCheck:adjustAngle(sPos,ePos, true)
    else
        ---[[
        repeat 
            local power= (self:getCurRandNum() % 4 + 1) * SceneBattle:getFrontLayer():getScale() * 0.9;
            speed = BattleCommon:angleToPoint(BattleCommon:degressToRadius(-angle))
            isAtkSucceed, speed = BattleCommon:vectorNormalize(speed)
            isAtkSucceed, power = BattleCommon:getStartSpeedPowerWithSpeed(speed, sPos, ePos, power)

            speed.x = speed.x * power
            speed.y = speed.y * power
--            WZLog("WndBattleHud:updatePointLine two", isAtkSucceed, count, angle, speed.x, speed.y)

            if ePos.x <= sPos.x then
                angle = angle - 5;
            else
                angle = angle - 5;
            end 
            count = count + 1
        until (isAtkSucceed == true or count >= 20)
        --]]
    end


    
    --WZLog("WndBattleHud:updatePointLine two", tostring(isAtkSucceed), speed.x, speed.y)

    if isAtkSucceed then
        self:showLine(speed, sPos, ePos, aimHero)
    elseif self.m_tLine then
        self.m_tLine:setVisible(false)
    end

end

function WndBattleHud:showLine(speed, pos, ePos, aimHero)
    --do return end
    if self.m_tLine == nil then
        self.m_tLine = BattlePointsLine:create(SceneBattle:getFrontLayer(), 20, nil, nil, nil, nil, nil, nil, ePos)
        --self.m_tLine = BattlePointsLine:create(SceneBattle:getTopInfoLayer(), 20)
        self.m_tLine:setVisible(false)
    end

    if self.m_tLine:isVisible() ~= true then
        self.m_tLine:setVisible(true)
        
    end

    local acceleration = BattleCommon:pointAdd(BattleConstants.g_nFlyGravity,WBattleGlobal:getCurrent():getWind())
    self.m_tLine:update(pos,speed,acceleration, 1.5)
    
    local sp1 = SceneBattle.m_pointsLine.m_tSpeed
    if SceneBattle.m_pointsLine.m_bIsVisible and sp1 and BattleCommon:isnan(sp1.x) == false and BattleCommon:isnan(sp1.y) == false and (sp1.x ~= 0 or sp1.y ~= 0) then
        local sp2 = self.m_tLine.m_tSpeed
        local x = math.abs(sp1.x - sp2.x) 
        local y = math.abs(sp1.y - sp2.y) 
        local mapId = WBattleGlobal:getCurrent().m_tMakePairOk.mapId
        local isFirstPvp = WBattleGlobal:getCurrent():isFirstPvp()
        print("BattleMsgTeachStep4:_showLine", tostring(SceneBattle.m_pointsLine.m_bisWrong), sp1.x, sp2.x, sp1.y, sp2.y, x, y)
        if mapId == 10301 or mapId == 10302 then
            SceneBattle.m_pointsLine.m_bisWrong = not self:checkWrong(sp1, pos, ePos, aimHero)
        elseif (mapId ~= 10301 and mapId ~= 10302 and (not isFirstPvp) and (x < 4 and y < 4 or x / y > 8 and x < 7 and y < 4)) or 
            mapId == 10104 and x < 6 and y < 6 or 
            (isFirstPvp) and x < 2 and y < 2 then
            SceneBattle.m_pointsLine.m_bisWrong = false
        else
            SceneBattle.m_pointsLine.m_bisWrong = true
        end

        -- local angle = BattleCommon:radiansToDegress(BattleCommon:pointToAngle(sp1))
        -- local angle2 = BattleCommon:radiansToDegress(BattleCommon:pointToAngle(sp2))
        -- --WZLog("WndBattleHud:showLine", angle, angle2, SceneBattle.m_pointsLine.m_bisWrong, WBattleGlobal:getCurrent().m_tTouchCircle:getAnimNode():getOpacity())
        -- if math.abs(angle - angle2) < 5 and SceneBattle.m_pointsLine.m_bisWrong == true then
        --     --WBattleGlobal:getCurrent().m_tTouchCircle:getAnimNode():setOpacity(50)
        -- elseif WBattleGlobal:getCurrent().m_tTouchCircle:getAnimNode():getOpacity() == 50 then
        --     WBattleGlobal:getCurrent().m_tTouchCircle:getAnimNode():setOpacity(255)
        -- end
    end
end

function WndBattleHud:checkWrong(speed, sPos, ePos, aimHero)
    --WZLog("WndBattleHud:checkWrong zero", speed.x, speed.y, sPos.x, sPos.y, ePos.x, ePos.y)
    local isAtkSucceed = false
    local acceleration = BattleCommon:pointAdd(BattleConstants.g_nFlyGravity,WBattleGlobal:getCurrent():getWind())
    local hasCollision, posCollision, posEnd = BattleCommon:checkHasCollision(sPos, ePos, speed, acceleration, BattleMapManager.m_pixelByte, BattleConstants.g_nE_COLLISION_CIRCLE, aimHero)
    local dis = BattleCommon:pointDis(ePos, posCollision)
    if hasCollision == true and dis < 60 then
        isAtkSucceed = true

    else
        isAtkSucceed = false
    end
    WZLog("WndBattleHud:checkWrong one", isAtkSucceed, "dis=" .. dis, "hasCol=".. tostring(hasCollision), "ePos.x="..ePos.x, "ePos.y="..ePos.y, 
        "posCol.x="..posCollision.x, "posCol.y="..posCollision.y, "posEnd.x="..posEnd.x, "posEnd.y="..posEnd.y, "speed.x="..speed.x, "speed.y="..speed.y)
    return isAtkSucceed
end


--@brief    更新回合时间
--@param    dt:经过的时间
--@note
function WndBattleHud:updateTurnTime(dt)
    if self:getMyHero() and not WBattleGlobal:getCurrent():isAudience() then
        self:updatePointLine()
        local heroCharacter = WBattleGlobal:getCurrent():getCurrentCharacter()

        local wind = type(WBattleGlobal:getCurrent():getWindLevel()) == "table" and WBattleGlobal:getCurrent():getWindLevel().x or WBattleGlobal:getCurrent():getWindLevel()

        local windx = -17
        if heroCharacter and self.m_tButtonTipsAnim2 == nil and ((WBattleGlobal:getCurrent():isWindTeach() and heroCharacter == self:getMyHero() and wind ~= 0) or self.m_nTurnTime > 10 and heroCharacter.m_nLevel >= 10 and heroCharacter.m_nLevel <= 11 and self.m_tButtonTipsAnim2 == nil and heroCharacter == self:getMyHero() and wind ~= 0 and TeachGroup1:isTaskTeachFinish(TeachGroup1.WIND_OPEN_0, true) ~= true) then
            TeachGroup1:taskTeach(TeachGroup1.WIND_OPEN_0)
            local pos = BattleCommon:getPointTable(windx,-82)
            if wind < 0 then
                pos = BattleCommon:getPointTable(windx,-82)
            else
                pos = BattleCommon:getPointTable(windx,-82)
            end
            WZLog("WndBattleHud:updateTurnTime wind-0", wind)
            self.m_tButtonTipsAnim2, self.m_tButtonTipsDialog2 = WindowManager:addTipForButton(GetElement(self.m_root,"conWind_WndBattleHud",WZUIContainer), 0.9, pos, 91, 3, BattleCommon:getPointTable(-30,-10),3.4,nil,"2")
        end

        if heroCharacter and self.m_nTurnTime > 15 and heroCharacter.m_nLevel >= 10 and heroCharacter.m_nLevel <= 11 and self.m_tButtonTipsAnim2 == nil and self.m_tButtonTipsAnim3 == nil and heroCharacter == self:getMyHero() and math.abs(wind) >= 3 and TeachGroup1:isWindTeachFinish(TeachGroup1.WIND_OPEN_0 + math.abs(wind)) ~= true then
            TeachGroup1:windTeach(TeachGroup1.WIND_OPEN_0 + math.abs(wind))

            local pos = BattleCommon:getPointTable(windx,-82)
            local index = 91
            if wind < 0 then
                --左侧
                index = 89 + wind * -1 + (wind * -1 - 3)
                pos = BattleCommon:getPointTable(windx,-82)
            else
                --右侧
                index = 90 + wind + (wind - 3)
                pos = BattleCommon:getPointTable(windx,-82)
            end

            local isEnd, count = TeachGroup1:isWindTeachFinish(TeachGroup1.WIND_OPEN_0 + math.abs(wind))
            WZLog("WndBattleHud:updateTurnTime wind-1", wind, tostring(isEnd), count, index)
            self.m_tButtonTipsAnim3, self.m_tButtonTipsDialog3 = WindowManager:addTipForButton(GetElement(self.m_root,"conWind_WndBattleHud",WZUIContainer), 0.9, pos, index, 3, BattleCommon:getPointTable(-30,-10),3.4,nil,"2")
        end



        if self.m_tButtonTipsAnim2 and (WBattleGlobal:getCurrent():isWindTeach() and self.m_nTurnTime <= 1 or WBattleGlobal:getCurrent():isWindTeach() == false and self.m_nTurnTime <= 10) then
            self.m_tButtonTipsAnim2:removeFromParentAndCleanup(true)
            self.m_tButtonTipsDialog2:removeFromParentAndCleanup(true)
            self.m_tButtonTipsAnim2, self.m_tButtonTipsDialog2 = nil, nil
        end

        if self.m_tButtonTipsAnim3 and (self.m_nTurnTime <= 15 or heroCharacter ~= self:getMyHero()) then
            self.m_tButtonTipsAnim3:removeFromParentAndCleanup(true)
            self.m_tButtonTipsDialog3:removeFromParentAndCleanup(true)
            self.m_tButtonTipsAnim3, self.m_tButtonTipsDialog3 = nil, nil
        end

        if self.m_nTurnTime <= 1 then
            if self.m_tLine then
                self.m_tLine:setVisible(false)
            end

            self.m_bIsShowBigSkill = nil
            if self.m_tButtonTipsDialog6 then
                self.m_tButtonTipsDialog6:removeFromParentAndCleanup(true)
                self.m_tButtonTipsDialog6, self.m_tButtonTipsDialogObj6 = nil, nil
            end
        end

        if heroCharacter and heroCharacter:getUseBigSkill() == true then
            self.m_bIsShowBigSkill = nil
            if self.m_tButtonTipsDialog6 then
                self.m_tButtonTipsDialog6:removeFromParentAndCleanup(true)
                self.m_tButtonTipsDialog6, self.m_tButtonTipsDialogObj6 = nil, nil
            end
        end

        local mapId = WBattleGlobal:getCurrent().m_tMakePairOk.mapId
        if mapId == 10105 and heroCharacter:getSp() >= 100 and self.m_bIsShowBigSkill ~= true and self.m_nTurnTime > 1 then
            self.m_bIsShowBigSkill = true
            --TeachGroup1:start(50,1,self.m_root)
            local cell = GetElement(self.m_root,"btnBigSkill_WndBattleHud",WZUIButton)
            if ProjConfig.LANGUAGE == "ug" then
                self.m_tButtonTipsDialog6, self.m_tButtonTipsDialogObj6 = Teach:showDialog( cell , cell ,  TeachGroup1:getTeachText(211) , 3 , GlobalMethod:ccp(20,100), 1, nil )
            else
                self.m_tButtonTipsDialog6, self.m_tButtonTipsDialogObj6 = Teach:showDialog( cell , cell ,  TeachGroup1:getTeachText(211) , 3 , GlobalMethod:ccp(20,0), 1, nil )
            end
        end


        local item = WBattleGlobal:getCurrent().m_tMyProp_Beginning
        local tempElement

        if WBattleGlobal:getCurrent():isGameOver() ~= true and self:isUpdateTouchCircle() and heroCharacter == self:getMyHero() and self.m_bIsVisble == true and WndBattleHud:isShowingMyHudEnd() and WBattleGlobal:getCurrent().m_nScale == 0 and heroCharacter.m_nLevel <= 15 then
            if self.m_tButtonTipsAnim4 == nil then
                local offset = BattleCommon:getPointTable(115,115)
                if "en" == ProjConfig.LANGUAGE then
                    offset = BattleCommon:getPointTable(175,160)
                end
                self.m_tButtonTipsAnim4, self.m_tButtonTipsDialog4 = WindowManager:addTipForButton(
                    GetElement(self.m_root,"btnScale_WndBattleHud",WZUIButton), 0.35, BattleCommon:getPointTable(32,-5)
                    , 147, 3, offset,nil)
            end
        else
            if self.m_tButtonTipsAnim4 then
                self.m_tButtonTipsAnim4:removeFromParentAndCleanup(true)
                self.m_tButtonTipsDialog4:removeFromParentAndCleanup(true)
                self.m_tButtonTipsAnim4, self.m_tButtonTipsDialog4 = nil, nil
            end
        end

        if WBattleGlobal:getCurrent():isGameOver() ~= true and heroCharacter == self:getMyHero() and self.m_bIsVisble == true and WndBattleHud:isShowingMyHudEnd() and self.m_tMyHero:getUseItemTime() < 1 and self.m_tButtonTipsAnim4 == nil then
            for i=1,item.count do
                tempElement = self:getItemCell(i)
                if tempElement and tempElement:getTouchEnable() == true and item.id[i] ~= -1 and item.id[i] ~= 0 and self.m_tUseItem[i] > 0 then
                    local isAnger = true and (item.id[i] == 31 or item.id[i] == 37) and heroCharacter.m_nLevel <= 10 and heroCharacter:getSp() >= 70 and heroCharacter:getSp() < 100
                    local isBlood = (item.id[i] == 32 or item.id[i] == 34 or item.id[i] == 38) and heroCharacter.m_nLevel <= 15 and heroCharacter:getHp() / heroCharacter:getMaxHp() <= 0.5
                    if isAnger or isBlood then
                        if self.m_tButtonTipsAnim1 == nil then
                            --WZLog("WndBattleHud:updateTurnTime zero", tostring(isAnger), tostring(isBlood), item.id[i], heroCharacter.m_nLevel, heroCharacter:getSp(), heroCharacter:getHp(), heroCharacter:getMaxHp())
                            --local conShelter = WindowManager:addTeachShelterLayer( 999999 )
                            --conShelter:setLuaObjectIndex(TeachGroup1)
                            local index = 88
                            if isAnger then
                                index = 88
                            elseif isBlood then
                                index = 89
                            end
                            local offset = BattleCommon:getPointTable(-20 - (i - 1) * 72,30)
                            if "en" == ProjConfig.LANGUAGE or "ug" == ProjConfig.LANGUAGE then
                                offset = BattleCommon:getPointTable(30 - (i - 1) * 72,150)
                            elseif "vn" == ProjConfig.LANGUAGE then
                                offset = BattleCommon:getPointTable(10 - (i - 1) * 72,70)
                            end
                            local pos = BattleCommon:getPointTable(27,-37)
                            if IsIphoneX() then
                                pos = BattleCommon:getPointTable(27,-23)
                            end
                            self.m_tButtonTipsAnim1, self.m_tButtonTipsDialog1 = WindowManager:addTipForButton(self:getItemCellTeach(i), 0.35, pos, index, 3, offset,nil)
                            break
                        end
                    end
                end
            end
        else
            if self.m_tButtonTipsAnim1 then
                --WindowManager:removeTeachShelterLayer()
                self.m_tButtonTipsAnim1:removeFromParentAndCleanup(true)
                self.m_tButtonTipsDialog1:removeFromParentAndCleanup(true)
                self.m_tButtonTipsAnim1, self.m_tButtonTipsDialog1 = nil, nil
            end
        end

        self:updateTeach(dt)

        self:updateTurnTime_Skill(dt)
        self:updateTurnTime_Item(dt)
        self:updateTurnTime_KMSkill(dt)
    end

    if WBattleGlobal:getCurrent():isEscapeBattle() then
        for i=1,5 do
            local con, anim = WndBattleHud:getItemLigthCell(i)
            if con:isVisible() then
                WZLog("WndBattleHud:updateTurnTime_EscapeBattle", i, anim:isCurrentAnimationDone())
                if anim:isCurrentAnimationDone() then
                    con:setVisible(false)
                    tempElement = self:getItemCell(i)
                    local img = WZUIImage:luaTo(tempElement)
                    -- if img and MsgManager:isInShowActionMsg() then
                    --     img:setColor(GlobalMethod:ccc3(100,100,100))
                    --     img:setTouchEnable(false)
                    -- end
                end
            end
        end
    end

    dt = os.time() - self.m_nStartTime

    if TeachGroup1.ANIME or WndTeachTalk.m_root then
        self.m_nStartTime = os.time()
    end
	if self.m_nTurnTime <=0 or self.m_bStopTime == true or TeachGroup1.ISBATTLE_MYTURN or WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle then
		return
	end

    --WZLog("WndBattleHud:updateTurnTime", os.time(), self.m_nStartTime)
	if self.m_nTurnTime - dt >0 then
        self.m_nStartTime = os.time()
		self:_updateTurnTime(self.m_nTurnTime - dt)
	else
		self:endTurn()
	end
end

--@brief    冷却
--@note
function WndBattleHud:onCoolKMSkill(sender)
    WZLog("WndBattleHud:onCoolKMSkill")
    sender:disableSchedule()
    local curTime = WZThread:getUTickCount()
    if self.m_nTouchBeginTime == nil then return end 
    WZLog("WndBattleHud:onCoolKMSkill =====", curTime - self.m_nTouchBeginTime)
    if curTime - self.m_nTouchBeginTime >= 800000 then
        return 
    end

    if WBattleGlobal:getCurrent():isMyTurn() and BattleMsgTeachStep4.skillUse == nil then
        MsgBoxManager:showTipBox(LocalStrings.SKILL_COOL_TIME)
    end
end

--@brief    冷却
--@note
function WndBattleHud:onCoolSkill(sender)
    WZLog("WndBattleHud:onCoolSkill")
    sender:disableSchedule()
    local curTime = WZThread:getUTickCount()
    if self.m_nTouchBeginTime == nil then return end 

    WZLog("WndBattleHud:onCoolSkill =====", curTime - self.m_nTouchBeginTime)
    if curTime - self.m_nTouchBeginTime >= 800000 then
        return 
    end

    if WBattleGlobal:getCurrent():isMyTurn() and BattleMsgTeachStep4.skillUse == nil then
        MsgBoxManager:showTipBox(LocalStrings.SKILL_COOL_TIME)
    end
end

--@brief    冷却
--@note
function WndBattleHud:onCoolItem(sender)
    WZLog("WndBattleHud:onCoolItem")
    sender:disableSchedule()
    local curTime = WZThread:getUTickCount()
    if self.m_nTouchBeginTime == nil then return end 
    WZLog("WndBattleHud:onCoolItem =====", curTime - self.m_nTouchBeginTime)
    if curTime - self.m_nTouchBeginTime >= 800000 then
        return 
    end

    if WBattleGlobal:getCurrent():isMyTurn() then
        MsgBoxManager:showTipBox(LocalStrings.ITEM_COOL_TIME or "...")
    end
end

--@brief    结束回合的默认处理
--@note
function WndBattleHud:endTurn()
	self:endTurnTime()
	self:_updateTurnTime(0)
	local hero = WBattleGlobal:getCurrent():getCurrentCharacter()
    WZLog("WndBattleHud:endTurn one hero===",WBattleGlobal:getCurrent().m_nCurrentPlayerId, tostring(hero))
	if hero and hero:getBattleId() == self.m_tMyHero:getBattleId() then
		self:setMyHudSwitchEnable(false)
		self:setMyHudShow(false)
	end
    --pass当做命中了
    hero:addHitTargetTimes()
    if WBattleGlobal:getCurrent():isReplayGame() then
        return
    end
	if hero and hero:isCanControl() == true and self.m_bStopTimeTtf == nil then
		-- local msg = MsgManager:createMsg(BattleMsgPass)
		-- msg.m_nBattleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
		-- msg.m_nPlayerId = WBattleGlobal:getCurrent():getMyBattleId()
		-- msg.m_nPlayerOrGuai = hero:getType()
		-- MsgManager:pushBlockMsg(msg)

        WZLog("sendMsg BattleMsgEndCurRound: 1", WBattleGlobal:getCurrent().m_nCurrentPlayerId, tostring(hero:getType()))
        WBattleGlobal:getCurrent():endCurRound(WBattleGlobal:getCurrent().m_nCurrentPlayerId,1)
		-- local msg = MsgManager:createMsg(BattleMsgEndCurRound)
		-- msg.m_nBattleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
		-- msg.m_nPlayerId = WBattleGlobal:getCurrent():getMyBattleId()
		-- msg.m_nCurrentPlayerId = WBattleGlobal:getCurrent().m_nCurrentPlayerId
		-- msg.m_nPlayerOrGuai = hero:getType()
  --       msg.note = 1
		-- MsgManager:pushBlockMsg(msg)
    else
        self:sendRoundInfo()
	end

    
end


--@note     发送回合信息
function WndBattleHud:sendRoundInfo()
    local curId = WBattleGlobal:getCurrent():getCurrentCharacterId()

    local roundCount = WBattleGlobal:getCurrent().m_nTurnTimes - 1
    roundCount = roundCount < 0 and 0 or roundCount
    local playerIds = {}
    local postionX = {}
    local postionY = {}
    local angle = {}
    local face = {}
    local explodePlayerId = -1
    local explodeSkillId = -1
    local explodePosX = {}
    local explodePosY = {}
    local explodePosWidth = {}
    local explodePosHeight = {}
    local battleInfo = ""
    local explodeDirection = {}

    for id, hero in ipairs (WBattleGlobal:getCurrent():getCharacterList()) do
        local x = BattleCommon:float2int2float(hero:getPosition().x)
        local y = BattleCommon:float2int2float(hero:getPosition().y)
        local r = BattleCommon:float2int2float(hero:getAnimation():getRotate())
        hero:setPosition({x = x , y = y } )
        hero:getAnimation():setRotate(r)

        table.insert(playerIds, hero:getBattleId())
        table.insert(postionX, x)
        table.insert(postionY, y)
        table.insert(angle, r)
        table.insert(face, hero:getAnimation():isFlipX() == true and 1 or 0)
    end

    WZLog("WndBattleHud:sendRoundInfo")
    ProtocolProcessorBattleInterface:send_BATTLE_SendCurRoundInfo(WBattleGlobal:getCurrent().m_tMakePairOk.battleId, roundCount,playerIds, postionX, postionY, angle, face, explodePlayerId, explodeSkillId, explodePosX, explodePosY, battleInfo, explodeDirection)
end

------PassTurnBtn

--@brief    是否可点击回合Pass按钮
--@param    bEnable:是否可点击
--@note
function WndBattleHud:setPassTurnBtnEnable(bEnable)
	bEnable = bEnable or false

	GetElement(self.m_root,"btnPassTurn_WndBattleHud"):setTouchEnable(bEnable)
end

--@brief    PassTurn按钮点击后的Lua回调
--@param    sender:PassTurn元素
--@note
function WndBattleHud:onPassTurnClick(sender)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if TeachGroup1.ISBATTLE == true or WBattleGlobal:getCurrent():isGameOver() == true then
        return
    end

    if WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle then
        MsgBoxManager:showTipBox(LocalStrings.BATTLE_NOT_MY_TURN)
        return
    end
    --自动战斗不可操作提示
    if GlobalGame.g_bIsAutoFightOpen then 
        MsgBoxManager:showTipBox(LocalStrings.BATTLE_AUTOFIGHT_ATT)
        return 
    end

    WBattleGlobal:getCurrent().m_bIsPlayerOperateAlready = true
    self:endTurn()
end

--@brief    点击自动战斗按钮回调
function WndBattleHud:onAutoFightClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    --皮肤大招处理
    if self.m_tMyHero:getUseSkinBigSkill() then
        if self.m_tMyHero:getSkinBigSkill() == 3036 or self.m_tMyHero:getSkinBigSkill() == 3044 or self.m_tMyHero:getSkinBigSkill() == 3051 or self.m_tMyHero:getSkinBigSkill() == 3053 or self.m_tMyHero:getSkinBigSkill() == 3054 or self.m_tMyHero:getSkinBigSkill() == 3065 then --大招处理 不死金乌,双生梦境,傀儡师,姜子牙 审判殿主
            MsgBoxManager:showTipBox(LocalStrings.BATTLE_HUD_TEXT1)
            return
        end
    end

    if not CheckButtonOpen(160) then 
        return 
    end

    if GlobalGame.g_bIsAutoFightOpen then 
        GlobalGame.g_bIsAutoFightOpen = false
        MsgBoxManager:showTipBox(LocalStrings.BATTLE_AUTOFIGHT_CLOSE)
        GetElement(self.m_root, "imgAutoF_WndBattleHud", WZUIImage):setFile("ui/combat/optimize/battle_icon_startAuto.png")
    else
        GlobalGame.g_bIsAutoFightOpen = true
        AutoRunBattle.m_bHeroInit = false
        AutoRunBattle:init()
        MsgBoxManager:showTipBox(LocalStrings.BATTLE_AUTOFIGHT_OPEN)
        GetElement(self.m_root, "imgAutoF_WndBattleHud", WZUIImage):setFile("ui/combat/optimize/battle_icon_stopAuto.png")
        if WBattleGlobal:getCurrent():isMyTurn() and not WBattleGlobal:getCurrent().m_bIsPlayerOperateAlready then 
            if not MsgManager:getBlockMsgByName("BattleMsgAutoRunRound") then 
                local msg = MsgManager:createMsg(BattleMsgAutoRunRound)
                MsgManager:pushBlockMsg(msg)
            end
        end
    end

    GlobalGame.g_saveAutoFightOpenState = GlobalGame.g_bIsAutoFightOpen
end

------Wind

--@brief    是否显示风力
--@param    bVisible:是否可见
--@note
function WndBattleHud:setWindVisible(bVisible)
	GetElement(self.m_root,"conWind_WndBattleHud"):setVisible(bVisible)
end

--@brief    设置风力等级
--@param    tLevel:风力等级
--@param    nWindSkillId： 当前回合生效的风力药剂Id
--@note
function WndBattleHud:setWindLevel(tLevel, nWindSkillId)
    local xLevel = tLevel.x
    self.m_nWindSkillId = nWindSkillId 
    local animWind = WZUISpine:luaTo(GetElement(self.m_root,"animWind_WndBattleHud"))
    local windAbs = math.abs(xLevel)
    if xLevel ~= 0 then
        WZArmature:luaTo(GetElement(self.m_root,"armWind_WndBattleHud")):setVisible(true)
        WZUISpine:luaTo(GetElement(self.m_root,"armWind2_WndBattleHud")):setVisible(true)

        animWind:setVisible(true)
        WZLog("WndBattleHud:setWindLevel 000", windAbs)
        if windAbs >= 5 then
            animWind:setAnimationName("large")
        elseif windAbs >= 3 then
            animWind:setAnimationName("mid")
        elseif windAbs >= 1 then
            animWind:setAnimationName("small")
        end
    else
        WZArmature:luaTo(GetElement(self.m_root,"armWind_WndBattleHud")):setVisible(false)
        WZUISpine:luaTo(GetElement(self.m_root,"armWind2_WndBattleHud")):setVisible(false)
        animWind:setVisible(false)
    end
    if xLevel >= 0 then
        animWind:setFlipX(true)
        WZArmature:luaTo(GetElement(self.m_root,"armWind_WndBattleHud")):setFlipX(false)
        WZArmature:luaTo(GetElement(self.m_root,"armWind_WndBattleHud")):setRelativePositionLuaTo(0.27562,0.476049)
        
        WZUIContainer:luaTo(GetElement(self.m_root,"conImgWind_WndBattleHud")):setScaleX(1)
        WZUILabelAtlasFont:luaTo(GetElement(self.m_root,"txtWind_WndBattleHud")):setScaleX(1)
        WZUIContainer:luaTo(GetElement(self.m_root,"conImgWind_WndBattleHud")):setRelativePositionLuaTo(0.691464,0.454545)
        if CacheCenter:getPlayerInfo() and CacheCenter:getPlayerInfo().level >= 10 and xLevel ~= 0 then
            local wind = WZUISpine:luaTo(GetElement(self.m_root,"armWind2_WndBattleHud"))
            wind:setFlipX(false)
            wind:setAnimationName("animation")
            wind:setLoop(false)
            wind:setVisible(true)
            wind:setRelativePositionLuaTo(0.2,0.95)
        end

    else
        animWind:setFlipX(false)
        WZArmature:luaTo(GetElement(self.m_root,"armWind_WndBattleHud")):setFlipX(true)
        WZArmature:luaTo(GetElement(self.m_root,"armWind_WndBattleHud")):setRelativePositionLuaTo(-1.04145,0.476049)
        
        WZUIContainer:luaTo(GetElement(self.m_root,"conImgWind_WndBattleHud")):setScaleX(-1)
        WZUILabelAtlasFont:luaTo(GetElement(self.m_root,"txtWind_WndBattleHud")):setScaleX(-1)
        WZUIContainer:luaTo(GetElement(self.m_root,"conImgWind_WndBattleHud")):setRelativePositionLuaTo(-1.47927,0.454545)

        if CacheCenter:getPlayerInfo() and CacheCenter:getPlayerInfo().level >= 10 and xLevel ~= 0 then
            local wind = WZUISpine:luaTo(GetElement(self.m_root,"armWind2_WndBattleHud"))
            wind:setFlipX(true)
            wind:setAnimationName("animation")
            wind:setLoop(false)
            wind:setVisible(true)
            wind:setRelativePositionLuaTo(-0.912199,0.95)
        end
        xLevel = xLevel * -1
    end
    WZLog("WndBattleHud:setWindLevel", xLevel, tLevel.x)
    WZUILabelAtlasFont:luaTo(GetElement(self.m_root,"txtWind_WndBattleHud")):setText(xLevel)
    --派发风力事件
    if WBattleGlobal:getCurrent():isSingleStage() then
        if WBattleGlobal:getCurrent().m_tWindLevelLimit == nil then 
            WBattleGlobal:getCurrent().m_tWindLevelLimit = {min = xLevel, max = xLevel}
        else
            if WBattleGlobal:getCurrent().m_tWindLevelLimit.min == nil then 
                WBattleGlobal:getCurrent().m_tWindLevelLimit.min = xLevel
            elseif WBattleGlobal:getCurrent().m_tWindLevelLimit.min > xLevel then 
                WBattleGlobal:getCurrent().m_tWindLevelLimit.min = xLevel
            end

            if WBattleGlobal:getCurrent().m_tWindLevelLimit.max == nil then 
                WBattleGlobal:getCurrent().m_tWindLevelLimit.max = xLevel
            elseif WBattleGlobal:getCurrent().m_tWindLevelLimit.max < xLevel then 
                WBattleGlobal:getCurrent().m_tWindLevelLimit.max = xLevel
            end
        end
        GlobalGame:getBattleEventDispatcher():Dispatch(BATTLE_EVENT_TYPE.WIND_CHANGE)
    end
    --显示风向药剂图标
    local imgWindSkill = GetElement(self.m_root, "imgWindSkill_WndBattleHud", WZUIImage)
    if self.m_nWindSkillId and self.m_nWindSkillId > 0 then 
        local skillData = GDatatab_skill["id_" .. self.m_nWindSkillId]

        imgWindSkill:setVisible(true)
        if skillData then
            imgWindSkill:setFile(skillData.icon)
        end
    else
        imgWindSkill:setVisible(false)
    end
end

--@brief    点击风回调
function WndBattleHud:onClickWind(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("WndBattleHud:onClickWind", self.m_nWindSkillId)
    if self.m_nWindSkillId and self.m_nWindSkillId > 0 then 
        local conWind = GetElement(self.m_root, "conWind_WndBattleHud", WZUIContainer)
        local tData = {}
        tData.passive_skill = {}
        tData.passive_skill[1] = {self.m_nWindSkillId}

        WndTips:show(element, conWind, 36, tData, GlobalMethod:ccp(180, -85))
    end
end

------MyHudSwitch

--@brief    MyHudSwitch按钮点击后的Lua回调
--@param    sender:MyHudSwitch元素
--@note
function WndBattleHud:onMyHudSwitch(sender)
    if WBattleGlobal:getCurrent():isGameOver() == true or TeachGroup1.ISBATTLE or WBattleGlobal:getCurrent():isAudience() then
        return
    end

    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	self.m_bMyHudShow = not self.m_bMyHudShow
	self.m_bPreviousHudStatus = self.m_bMyHudShow
	self:setMyHudShow(self.m_bMyHudShow,true)
end

--@brief    是否显示MyHud
--@param    bVisible:是否显示
--@note
function WndBattleHud:setMyHudShow(bVisible,bIgnoreSkillItem)
    self.m_bIsVisble = bVisible
    local myHero = WBattleGlobal:getCurrent():getMyHero()
    if myHero:isDead() then
        return
    end

    if bVisible == false and bIgnoreSkillItem ~= true then
		self:resetSkill(true,3)
        self:resetItem(true)
        self:resetKMSkill(true)
	end
	
	if bVisible == false then
		--BattleMapManager:getFrontControl():dropDownFrontMapExpandSize()
	end
	GetElement(self.m_root,"conMyHud_WndBattleHud"):stopAllActions()
    -- GetElement(self.m_root,self.m_sHudBgName):stopAllActions()
	local moveTo = WZUIActionMoveTo:create()
	moveTo:setMoveX(0.5)
	if bVisible then
		--GetElement(self.m_root,"conMyHud_WndBattleHud"):setVisible(true)
		WZUIImage:luaTo(GetElement(self.m_root,"imgMyHudSwitch_WndBattleHud")):setFlipY(false)
		WZUIImage:luaTo(GetElement(self.m_root,"imgMyHudSwitchSel_WndBattleHud")):setFlipY(false)
		moveTo:setMoveY(0)
	else
		moveTo:setMoveY(-0.32)
		WZUIImage:luaTo(GetElement(self.m_root,"imgMyHudSwitch_WndBattleHud")):setFlipY(true)
		WZUIImage:luaTo(GetElement(self.m_root,"imgMyHudSwitchSel_WndBattleHud")):setFlipY(true)
	end
	moveTo:setDuration(0.25)
	moveTo:setFinishLuaFunction("showingMyHudEnd")
	moveTo:setFinishLuaTable(self)
	GetElement(self.m_root,"conMyHud_WndBattleHud"):runUIAction(moveTo)

	self.m_bMyHudShow = bVisible
    self.m_bShowingMyHud = true
end

--@brief    MyHud动画播放回调
--@note     
function WndBattleHud:showingMyHudEnd()
	self.m_bShowingMyHud = false
end

--@brief    MyHud动画播放是否结束
function WndBattleHud:isShowingMyHudEnd()
    return not self.m_bShowingMyHud
end

--@brief    是否强制显示MyHud
--@param    bVisible:是否显示
--@note
function WndBattleHud:setForceMyHudShow(bVisible)
	self:setMyHudShow(bVisible)
end

--@brief    是否可点击MyHudSwitch
--@param    bEnable:是否可点击
--@note
function WndBattleHud:setMyHudSwitchEnable(bEnable)
    if TeachGroup1.ISBATTLE_MYTURN then
        bEnable = false
    end

    local myHero = WBattleGlobal:getCurrent():getMyHero()
    if bEnable == true and myHero:getUseBigSkill() == true then
        return
    end
	if bEnable then
		GetElement(self.m_root,"btnMyHudSwitch_WndBattleHud"):setTouchEnable(bEnable)
	end
end

--@brief    到达地图底部自动显示hud
--@param
--@note
function WndBattleHud:autoShowMyHud()
    local myHero = WBattleGlobal:getCurrent():getMyHero()
    if myHero:getUseBigSkill() == true then
        return
    end

	if self.m_bMyHudShow then
		--self:setMyHudSwitchEnable(false)
	else
		--self:setMyHudSwitchEnable(false)
		self:setForceMyHudShow(true)
	end
end

--@brief	process screen move hud status
--@param
--@note
function WndBattleHud:processHudAutoShow(isBackPrevious)
	if isBackPrevious then
		--my turn recovery previous status
		if WBattleGlobal:getCurrent():isMyTurn() then
			local touch = SceneBattle:getBattleTouch()
			if touch:getTouchStatus(1) == BattleTouch.TOUCH_HOLD and self.m_nTurnTime > 0 then
				local previousStatus = self:getPreviousHudStatus()
                local myHero = WBattleGlobal:getCurrent():getMyHero()
				if previousStatus ~= nil and (previousStatus == false or (previousStatus == true and myHero:getUseBigSkill() ~= true)) then
					self:setForceMyHudShow(previousStatus)
				end
				--self:setMyHudSwitchEnable(true)
			end
		end
	else
		--my turn automatic show hud
		if WBattleGlobal:getCurrent():isMyTurn() then
			local touch = SceneBattle:getBattleTouch()
			if touch:getTouchStatus(1) == BattleTouch.TOUCH_HOLD and self.m_nTurnTime > 0 then
				self:autoShowMyHud()
			end
		end
	end
end

--@brief    获取hud的前一个状态
--@note

function WndBattleHud:getPreviousHudStatus()
	return self.m_bPreviousHudStatus
end
------TeachGuide

--@brief    移除新手教学引导对话框
--@note     --teach
function WndBattleHud:removeGuideDialog()
	WZLog("removeGuideDialog",self.m_tGuideDialog)
	if self.m_tGuideDialog then
		self.m_tGuideDialog:removeDialog()
		self.m_tGuideDialog = nil
	end
end


------BigSkill

--@brief    获取大招元素
--@return   element,大招元素
function WndBattleHud:getBigSkillContainer()
    return GetElement(self.m_root,"conBigSkill_WndBattleHud",WZUIContainer)
end

--@brief    获取大招按钮元素
--@return   element,大招元素
function WndBattleHud:getBigSkillBtnContainer()
    return GetElement(self.m_root,"btnBigSkill_WndBattleHud",WZUIContainer)
end

--@brief    创建怒气动画
--@note
function WndBattleHud:createAngerAnim()
    --new Blue
    self.m_angerAnim2 = BattleAnimation:createAnimation("ui_battle_angermax_01",true, "battle/ui")
    local node2 = self.m_angerAnim2:getAnimNode()
    node2:setRelativePositionLuaTo(0.5,0.0)
    node2:setVisible(false)
    node2:setTouchEnable(false)
    node2:setZOrder(0)
    node2:setScale(0.7)
    self:getBigSkillContainer():addChild(node2)
    self.m_angerAnim2:play("0",true)

	self.m_angerAnim = BattleAnimation:createAnimation("ui_battle_angerblue_02",true, "battle/ui")
	local node1 = self.m_angerAnim:getAnimNode()
	node1:setRelativePositionLuaTo(0.5,0.0)
	node1:setVisible(true)
	node1:setTouchEnable(false)
	node1:setZOrder(0)
    node1:setScale(0.7)
	self:getBigSkillContainer():addChild(node1)
	self.m_angerAnim:play("0",true)
end

--@brief    设置大招的百分率
--@param    nPer:大招的百分率
--@note
function WndBattleHud:setBigSkillPer(nPer)
	--Test
	--nPer = 100
	WZUIProgress:luaTo(GetElement(self.m_root,"progBigSkill_WndBattleHud")):setPercentage(nPer * 1)
	GetElement(self.m_root,"txtMySp_WndBattleHud",WZUIFreeTextBox):setShowText(string.format([[<A IMG="ui/combat/battle_num_niqishuzi.png" W="18" H="22" CHAR="0">%s</A><I>ui/combat/battle_num_niqibaifenbi.png</I>]],""))

    nPer = math.floor(nPer)
    GetElement(self.m_root,"txtMySpValue_WndBattleHud",WZUILabelAtlasFont):setText(nPer)
    if nPer < 10 then
        GetElement(self.m_root,"txtMySpValue_WndBattleHud",WZUILabelAtlasFont):setRelativePositionLuaTo(0.46,0.58)
        GetElement(self.m_root,"imgMySp_WndBattleHud",WZUIImage):setRelativePositionLuaTo(0.59,0.51)

    else
        GetElement(self.m_root,"txtMySpValue_WndBattleHud",WZUILabelAtlasFont):setRelativePositionLuaTo(0.44,0.58)
        GetElement(self.m_root,"imgMySp_WndBattleHud",WZUIImage):setRelativePositionLuaTo(0.625,0.51)
    end
	if nPer >=100 then
        WZLog("WndBattleHud:setBigSkillPer", self.m_nBigSkillIndex)
        if self.m_nBigSkillIndex == 1 then 
            self.m_angerAnim2:getAnimNode():setVisible(true)
            self.m_angerAnim:getAnimNode():setVisible(false)
        elseif self.m_nBigSkillIndex == 2 then 
            self.m_angerAnim2:getAnimNode():setVisible(false)
            self.m_angerAnim:getAnimNode():setVisible(true)
        end
        --self:bigSkillGuideWithCheck()
    else
        self.m_angerAnim2:getAnimNode():setVisible(false)
        self.m_angerAnim:getAnimNode():setVisible(false)
	end
end

--@brief    大招教学引导
--@note     teach
function WndBattleHud:bigSkillGuideWithCheck()
    if self.m_tMyHero and self.m_tMyHero:getSp() >= 100 and self:getBigSkillBtnContainer():getTouchEnable() then
        --Teach:isStartTeach("WndBattleHud:bigSkillGuideWithCheck")
    end
end

--@brief    是否可点击大招按钮
--@param    bEnable:是否可点击
--@note
function WndBattleHud:setBigSkillEnable(bEnable)
    if WBattleGlobal:getCurrent():isAudience() then 
        bEnable = false
    end
	self:getBigSkillBtnContainer():setTouchEnable(bEnable)
	self:bigSkillGuideWithCheck()
end

--@brief    BigSkill的回调
--@param    sender:BigSkill按钮元素
--@note
function WndBattleHud:onBigSkill(sender)
    if TeachGroup1.ISFIRSTBATTLE then
        --local packageName = WGameCmUtil:GetBundleIdentifier()
        if true then --packageName == "com.tencent.tmgp.DDD2" or packageName == "com.wyd.hero.dandandao.baidu" then
            self.m_tJumpTeachList.count = self.m_tJumpTeachList.count and self.m_tJumpTeachList.count + 1 or 1
            WZLog("TeachGroup1.ISFIRSTBATTLE", self.m_tJumpTeachList.count)
            if self.m_tJumpTeachList.count >= 8 then
                g_bIsFirstBattleEnd = true
                TeachGroup1:setTeachFinish(0,-1)
                TeachGroup1.ISNOTEACH = true
                TeachGroup1:endFirstBattleTeach()
            end
        end
    end

    if WBattleGlobal:getCurrent():isGameOver() == true or self.m_tMyHero:isInBuffState(EffectTypeConfig.LIMIT_USE_SKILL) or (TeachGroup1.ISSKILL ~= true and TeachGroup1.ISBATTLE) then
        return
    end

    local myTurnCount = WBattleGlobal:getCurrent():getMyHero().m_nMyTurnCount
    if myTurnCount == 2 and TeachGroup1.ISBATTLE_MYTURN then
        return
    end

	local allow = not WBattleGlobal:getCurrent():isGameOver()
	allow = allow and not self.m_tMyHero:isDead()
	if allow and WBattleGlobal:getCurrent():getCurrentCharacterId() ~= self.m_tMyHero:getBattleId() or WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle then
		MsgBoxManager:showTipBox(LocalStrings.BATTLE_NOT_MY_TURN)
		return
	end

    --自动战斗不可操作提示
    if GlobalGame.g_bIsAutoFightOpen then 
        MsgBoxManager:showTipBox(LocalStrings.BATTLE_AUTOFIGHT_ATT)
        return 
    end

	allow = allow and WBattleGlobal:getCurrent():isWaitNextRound() == false
	allow = allow and SceneBattle:getBattleLoop():getBattleStatus() ~= BattleLoop.S_PLAYER_SHOOT
	allow = allow and SceneBattle:getBattleLoop():getBattleStatus() ~= BattleLoop.S_PLAYER_FLY
    allow = allow and SceneBattle:getBattleLoop():getBattleStatus() ~= BattleLoop.S_PET_SHOOT
	if allow then
        if self.m_tMyHero:getUseSkillTime() >= 1 and self.m_tMyHero:getSp() >= 100 then
            MsgBoxManager:showTipBox(LocalStrings.BATTLE_FAIL_BIGSKILL or "")
            return
        end

        if self.m_tMyHero:getSp() < 100 then
            MsgBoxManager:showTipBox(LocalStrings.BATTLE_ANGER_LIMIT)
            return
        end

        local useId = self.m_tMyHero.m_nBigSkillType
        if self.m_nBigSkillIndex == 2 then 
            useId = self.m_tMyHero.m_nBigSkinSkillType
        end

        local tItemData = GDatatab_skill["id_" .. useId]
        local nAddConsume = WndBattleHud:getBigSkillAddConsume(useId) --使用非默认皮肤大招多扣除ctb
        local nSubConsume = self:getBigSkillSubConsume() --职业技能减少大招ctb消耗
        WZLog("WndBattleHud:onBigSkill HHH", self.m_nUsePoint)
        if self.m_nUsePoint + (tItemData.consume - nSubConsume + nAddConsume)/1000 > 10 then
            MsgBoxManager:showTipBox(LocalStrings.BATTLE_ACTION_VALUE_NO_ENOUGH)
            return
        end

        self.m_nUsePoint = self.m_nUsePoint + (tItemData.consume - nSubConsume + nAddConsume)/1000
        self.m_tMyHero.m_nUsePoint = self.m_tMyHero.m_nUsePoint + tItemData.consume - nSubConsume + nAddConsume
        
		if BattleHeroUse:heroUse(self.m_tMyHero:getBattleId(), BattleHeroUse.USE_BIGSKILL, useId) then
            self.m_angerAnim2:getAnimNode():setVisible(false)
			self.m_angerAnim:getAnimNode():setVisible(false)
			--self:setMyHudSwitchEnable(false)

			--self:setMyHudShow(false)
            self:setFlyPos()

            --皮肤大招处理
            if self.m_tMyHero:getUseSkinBigSkill() then
                local skinBigSkill = self.m_tMyHero:getSkinBigSkill()
                if (skinBigSkill == 3030 or skinBigSkill == 3046 or skinBigSkill == 3059) then --大招处理 宇航员,鬼新娘,灵魂宿主
                    --大招靶子
                    local tPos = {x = WndBattleHud:getTargetRangeElement():getContentSize().width / 2, y = WndBattleHud:getTargetRangeElement():getContentSize().height / 2}
                    WndBattleHud:setBigSkillTargetPos(tPos)
                    local txtTargetInstruction = GetElement(self.m_root, "txtTargetInstruction_WndBattleHud", WZUILabelTTF)
                    if skinBigSkill == 3059 then 
                        txtTargetInstruction:setText(LocalStrings.BATTLE_HUD_TEXT3[2])
                    else
                        txtTargetInstruction:setText(LocalStrings.BATTLE_HUD_TEXT3[1])
                        
                    end
                    WndBattleHud:getTargetRangeElement():setVisible(true)
                elseif skinBigSkill == 3036 or skinBigSkill == 3044 or skinBigSkill == 3051 or skinBigSkill == 3054 then --大招处理 不死金乌,双生梦境,傀儡师
                    WndBattleHud:showSkinBigSkillShelter(1)
                elseif skinBigSkill == 3053 or skinBigSkill == 3065 then --大招处理 姜子牙 棋圣
                    WndBattleHud:showSkinBigSkillShelter(2)
                end
            end

            local isEndTeach, teachStep = TeachGroup1:isTeachFinish(50)
            if isEndTeach ~= true then
                TeachGroup1:endTeachStep({50,1})
            end
            self:_postSkillItemEvent(nil, true)
		end
	end
end

--@brief 更新大招信息
function WndBattleHud:updateBigSkillInfo()
    local useId = self.m_tMyHero.m_nBigSkillType
    if self.m_nBigSkillIndex == 2 then 
        useId = self.m_tMyHero.m_nBigSkinSkillType
    end

    -- 玩家选中的皮肤大招是-1就改回普通大招
    if self.m_nBigSkillIndex == 2 and self.m_tMyHero.m_nBigSkinSkillType <= 0 then
        useId = self.m_tMyHero.m_nBigSkillType
        self.m_nBigSkillIndex = 1
        GlobalGame.g_saveBigSkillType = self.m_nBigSkillIndex
    end

    local tItemData = GDatatab_skill["id_" .. useId]

    local imgBigSkillIcon = GetElement(self.m_root,"imgBigSkillIcon_WndBattleHud",WZUIImage)
    imgBigSkillIcon:setFile(tItemData.icon)
    local nAddConsume = self:getBigSkillAddConsume(useId) --使用非默认皮肤大招多扣除ctb
    local txtBigSkillConsume = GetElement(self.m_root,"txtBigSkillConsume_WndBattleHud",WZUILabelTTF)
    txtBigSkillConsume:setText((tItemData.consume + nAddConsume)/1000)

    if false and self.m_bCloseSkinSkillSwitch == true then
        GetElement(self.m_root, "txtBigSkillSwitch_WndBattleHud", WZUILabelTTF):setText(LocalStrings.BIGSKILL_TYPE[self.m_nBigSkillIndex])
    else
        GetElement(self.m_root, "txtBigSkillSwitch_WndBattleHud", WZUILabelTTF):setText(tItemData.name) 
    end
end

--@brief 显示大招信息
function WndBattleHud:onClickBigSkillIcon(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local useId = self.m_tMyHero.m_nBigSkillType
    if self.m_nBigSkillIndex == 2 then 
        useId = self.m_tMyHero.m_nBigSkinSkillType
    end

    local tData = CopyTable(GDatatab_skill["id_" .. useId])

    local nAddConsume = self:getBigSkillAddConsume(useId) --使用非默认皮肤大招多扣除ctb
    tData.consume = tData.consume + nAddConsume
    WndTips:show(element, self.m_root, 51, tData, GlobalMethod:ccp(-100,170), true)
end

--@brief 更新大招列表
function WndBattleHud:updateBigSkillList()
    local tSkinBigSkillList = WBattleGlobal:getCurrent().m_tSkinBigSkillList
    local tBigSkillId = {}
    table.insert(tBigSkillId,self.m_tMyHero.m_nBigSkillType) --武器大招
    if WBattleGlobal:getCurrent().m_tSkinBigSkillId then
        for i=1, #WBattleGlobal:getCurrent().m_tSkinBigSkillId do
            table.insert(tBigSkillId, WBattleGlobal:getCurrent().m_tSkinBigSkillId[i]) --默认皮肤大招
        end
    end
    if self.m_bCloseSkinSkillSwitch ~= true then
        for i=1,#tSkinBigSkillList do
            if not utilsValueInTable(tSkinBigSkillList[i], WBattleGlobal:getCurrent().m_tSkinBigSkillId) then
                table.insert(tBigSkillId,tSkinBigSkillList[i]) --其他皮肤大招
            end
        end
    end

    self.m_tBigSkillItemList = {}
    local tcBSItem = GetElement(self.m_root,"tcBSItem_WndBattleHud",WZUITableContainer)
    tcBSItem:cleanTable()
    for i=1,#tBigSkillId do
        local tItemData = GDatatab_skill["id_" .. tBigSkillId[i]]

        local conCellBSItem = CreateElement("conCellBSItem_WndBattleHud")
        conCellBSItem:setVisible(true)
        conCellBSItem:setTag(i-1)
        local btnCellBSItem = GetElement(conCellBSItem,"btnCellBSItem_WndBattleHud",WZUIButton)
        btnCellBSItem:setTag(i) --我把self.m_tBigSkillItemList索引绑定在这上面
        local imgCellBSIcon = GetElement(conCellBSItem,"imgCellBSIcon_WndBattleHud",WZUIImage)
        imgCellBSIcon:setFile(tItemData.icon)
        imgCellBSIcon:setTag(tItemData.id) --我把技能id绑定在这上面
        local nAddConsume = self:getBigSkillAddConsume(tBigSkillId[i]) --使用非默认皮肤大招多扣除ctb
        local txtCellBSConsume = GetElement(conCellBSItem,"txtCellBSConsume_WndBattleHud",WZUILabelTTF)
        txtCellBSConsume:setText((tItemData.consume + nAddConsume)/1000)
        tcBSItem:setCellElement(conCellBSItem)
        --使用中
        local conCellBSUsing = GetElement(conCellBSItem,"conCellBSUsing_WndBattleHud",WZUIContainer)
        conCellBSUsing:setVisible(false)
        if self:isUsingBigSkill(tItemData.id) then
            conCellBSUsing:setVisible(true)
        end
        --刚打开时默认选中使用中的大招
        local conCellBSSelected = GetElement(conCellBSItem,"conCellBSSelected_WndBattleHud",WZUIContainer)
        conCellBSSelected:setVisible(false)
        if self:isUsingBigSkill(tItemData.id) then
            conCellBSSelected:setVisible(true)
        end

        table.insert(self.m_tBigSkillItemList,conCellBSItem)
    end

    self:updateBigSkillInfo2()
end

--@brief 更新大招列表上的信息
function WndBattleHud:updateBigSkillInfo2()
    for i=1,#self.m_tBigSkillItemList do
        local conCellBSSelected = GetElement(self.m_tBigSkillItemList[i],"conCellBSSelected_WndBattleHud",WZUIContainer)
        if conCellBSSelected:isVisible() == true then
            local imgCellBSIcon = GetElement(self.m_tBigSkillItemList[i],"imgCellBSIcon_WndBattleHud",WZUIImage)
            local skillId = imgCellBSIcon:getTag()
            local tSkillData = GDatatab_skill["id_" .. skillId]
            
            local imgBSIcon = GetElement(self.m_root,"imgBSIcon_WndBattleHud",WZUIImage)
            imgBSIcon:setFile(tSkillData.icon)
            local txtBSName = GetElement(self.m_root,"txtBSName_WndBattleHud",WZUILabelTTF)
            txtBSName:setText(tSkillData.name)
            local nAddConsume = self:getBigSkillAddConsume(skillId) --使用非默认皮肤大招多扣除ctb
            local txtBSConsumeValue = GetElement(self.m_root,"txtBSConsumeValue_WndBattleHud",WZUILabelTTF)
            txtBSConsumeValue:setText((tSkillData.consume + nAddConsume)/1000)
            local txtBSDesc = GetElement(self.m_root,"txtBSDesc_WndBattleHud",WZUILabelTTF)
            txtBSDesc:setText(tSkillData.tool_desc)
            break
        end
    end
end

--@brief 更新大招列表
function WndBattleHud:isUsingBigSkill(skillId)
    local useId = self.m_tMyHero.m_nBigSkillType
    if self.m_nBigSkillIndex == 2 then 
        useId = self.m_tMyHero.m_nBigSkinSkillType
    end

    if useId == skillId then
        return true
    end
    return false
end

--@brief 获取大招ctb增加值,使用非默认皮肤大招时会多消耗ctb
function WndBattleHud:getBigSkillAddConsume(skillId)
    local nAddConsume = 0

    local tSkillData = GDatatab_skill["id_" .. skillId]
    if tSkillData.skill_type == 2 and tSkillData.sub_type == 50 and not utilsValueInTable(skillId, WBattleGlobal:getCurrent().m_tSkinBigSkillId) then --皮肤大招skill_type == 2 & sub_type == 50,且不是默认皮肤大招
        nAddConsume = CacheCenter:getGameParam().useNotDefaultBigSkillCost or 2000
    end
    return nAddConsume
end

--@brief 获取大招ctb减少值,职业某技能会减少消耗ctb
function WndBattleHud:getBigSkillSubConsume(playerId)
    local hero = WBattleGlobal:getCurrent():getMyHero()
    if playerId then
        hero = WBattleGlobal:getCurrent():getCharacterWithId(playerId)
    end

    local nSubConsume = 0
    if hero:getProfessionId() and hero:getProfessionId() > 0 and hero.m_tProfessionSkills then 
        for k = 1, hero.m_tProfessionSkills.count do
            if hero.m_tProfessionSkills.skill_type[k] == 6 then 
                nSubConsume = hero.m_tProfessionSkills.attribute[k]
                break 
            end
        end
    end
    return nSubConsume
end

--@brief 点击大招列表外范围就隐藏大招列表
function WndBattleHud:onClickBigSkillOut(element)
    self:showBigSkillList(false)
end

--@brief 点击大招列表中的技能
function WndBattleHud:onClickBigSkillItem(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tag = element:getTag()
    for i=1,#self.m_tBigSkillItemList do
        local conCellBSItem = self.m_tBigSkillItemList[i]
        local conCellBSSelected = GetElement(conCellBSItem,"conCellBSSelected_WndBattleHud",WZUIContainer)
        conCellBSSelected:setVisible(false)
        if i == tag then
            conCellBSSelected:setVisible(true)
        end
    end
    self:updateBigSkillInfo2()
end

--@brief 点击大招列表中的确定
function WndBattleHud:onConfirmBigSkill(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_tMyHero:getUseBigSkill() then
        MsgBoxManager:showTipBox(LocalStrings.BATTLE_HUD_TEXT1)
        return
    end

    local nIndex = 1
    for i=1,#self.m_tBigSkillItemList do
        local conCellBSItem = self.m_tBigSkillItemList[i]
        local conCellBSSelected = GetElement(conCellBSItem,"conCellBSSelected_WndBattleHud",WZUIContainer)
        if conCellBSSelected:isVisible() == true then
            nIndex = i
            break
        end
    end

    local conCellBSItem = self.m_tBigSkillItemList[nIndex]
    local imgCellBSIcon = GetElement(conCellBSItem,"imgCellBSIcon_WndBattleHud",WZUIImage)
    local nSkillId = imgCellBSIcon:getTag()
    if nSkillId == self.m_tMyHero.m_nBigSkillType then
        self.m_nBigSkillIndex = 1
    else
        self.m_nBigSkillIndex = 2
        self.m_tMyHero.m_nBigSkinSkillType = nSkillId
        SceneBattle:updateSkinBigSkillShape()
    end
    GlobalGame.g_saveBigSkillType = self.m_nBigSkillIndex

    self:updateBigSkillList()
    self:updateBigSkillInfo()
    self:updateBigSkillAnim()

    self:showBigSkillList(false)
end

--@brief 显示大招列表
function WndBattleHud:showBigSkillList(bShow)
    GetElement(self.m_root,"conSwitchBigSkill_WndBattleHud",WZUIContainer):setVisible(bShow)
end

function WndBattleHud:updateBigSkillAnim()
    local progBigSkill = GetElement(self.m_root, "progBigSkill_WndBattleHud", WZUIProgress)
    local bigPer = progBigSkill:getPercentage()
    WZLog("WndBattleHud:updateBigSkillAnim", bigPer)
    if bigPer >=100 then
        if self.m_nBigSkillIndex == 1 then 
            self.m_angerAnim2:getAnimNode():setVisible(true)
            self.m_angerAnim:getAnimNode():setVisible(false)
        elseif self.m_nBigSkillIndex == 2 then 
            self.m_angerAnim2:getAnimNode():setVisible(false)
            self.m_angerAnim:getAnimNode():setVisible(true)
        end
    else
        self.m_angerAnim2:getAnimNode():setVisible(false)
        self.m_angerAnim:getAnimNode():setVisible(false)
    end
    GlobalGame.g_saveBigSkillType = self.m_nBigSkillIndex
end

------HeroAPI

--@brief    设置自己的英雄
--@param    tHero:英雄表
--@note
function WndBattleHud:setMyHero(tHero)
	self.m_tMyHero = tHero
	self:_updateMyHP()
	self:_updateMyPF()
	
	self:resetSkill(true,4)
	self:resetItem(true)
    self:resetKMSkill(true)
	self:setMyHudSwitchEnable(true)
	local skill = WBattleGlobal:getCurrent().m_tMySkill_Beginning
	for i=1,skill.count do
		self:useMySkill(skill.id[i],true)
	end
	self:useMySkill(BattleHeroUse.FLY_SKILL_ID,true)

    local skill = WBattleGlobal:getCurrent().m_tMyProp_Beginning
    for i=1,skill.count do
        self:useMyItem(skill.id[i],true)
    end

    local skill = WBattleGlobal:getCurrent().m_tMyKMSkill_Beginning
    for i=1,skill.count do
        self:useMyKMSkill(skill.id[i],true)
    end

    self:updateBigSkillInfo()
    self:updateBigSkillList()
end

--@brief    获取自己的英雄
--@note
function WndBattleHud:getMyHero()
    return self.m_tMyHero
end

--@brief    更新英雄血量
--@param    nPlayerId:玩家ID
--@note
function WndBattleHud:updatePlayerHP(nPlayerId, bSet)
    local hero = self.m_tMyHero
    if WBattleGlobal:getCurrent():isAudience() and WBattleGlobal:getCurrent():getCurrentCharacter() then
        hero = WBattleGlobal:getCurrent():getCurrentCharacter()
    end

    if hero and nPlayerId == hero:getBattleId() then
        self:_updateMyHP(bSet)
    end
end

--@brief    更新英雄体力
--@param    nPlayerId:玩家ID
--@note
function WndBattleHud:updatePlayerPF(nPlayerId)
    local hero = self.m_tMyHero
    if WBattleGlobal:getCurrent():isAudience() and WBattleGlobal:getCurrent():getCurrentCharacter() then
        hero = WBattleGlobal:getCurrent():getCurrentCharacter()
    end

    WZLog("WndBattleHud:updatePlayerSp", hero and nPlayerId == hero:getBattleId())
	if hero and nPlayerId == hero:getBattleId() then
		self:_updateMyPF()
	end
end

--@brief    更新英雄技能道具
--@param    nPlayerId:玩家ID
--@note
function WndBattleHud:updateSkillItem(nPlayerId)
    local hero = self.m_tMyHero
    if WBattleGlobal:getCurrent():isAudience() and WBattleGlobal:getCurrent():getCurrentCharacter() then
        hero = WBattleGlobal:getCurrent():getCurrentCharacter()
    end

	if hero and nPlayerId == hero:getBattleId()  then
		if hero:getUseSkillTime() > 0 and hero:getUseItemTime() > 0 and hero:getUseKMSkillTime() > 0 then
			self:setMyHudShow(false)
			--self:setMyHudSwitchEnable(false)
		end

		self:resetSkill(nil,5)
		self:resetItem()
        self:resetKMSkill()
	end
end

--@brief    更新英雄怒气
--@param    nPlayerId:玩家ID
--@note
function WndBattleHud:updatePlayerSp(nPlayerId)
    local hero = self.m_tMyHero
    if WBattleGlobal:getCurrent():isAudience() and WBattleGlobal:getCurrent():getCurrentCharacter() then
        hero = WBattleGlobal:getCurrent():getCurrentCharacter()
    end

    WZLog("WndBattleHud:updatePlayerSp", hero and nPlayerId == hero:getBattleId(), hero:getSp())
	if hero and nPlayerId == hero:getBattleId() then
		self:setBigSkillPer(hero:getSp())
	end
end
------Skill

--@brief    获取技能栏元素
--@param    nTag,第几个技能栏元素
--@note
function WndBattleHud:getSkillCell(nTag)
	if nTag >0 and nTag <= 6 then
		return GetElementWithoutAssert(self.m_root,"imgSkill"..nTag.."_WndBattleHud",WZUIImage)
    elseif nTag == 7 then 
        return GetElementWithoutAssert(self.m_root,"imgAwakeSkill_WndBattleHud",WZUIImage)
	end
	return nil
end

--@brief    获取技能栏元素
--@param    nTag,第几个技能栏元素
--@note
function WndBattleHud:getSkillCostCell(nTag)
    if nTag >0 and nTag <= 6 then
        return GetElementWithoutAssert(self.m_root,"imgSkillCost"..nTag.."_WndBattleHud",WZUIImage), GetElementWithoutAssert(self.m_root,"txtCost"..nTag.."_WndBattleHud",WZUILabelAtlasFont)
    end
    return nil
end

--@brief    获取技能栏元素
--@param    nTag,第几个技能栏元素
--@note
function WndBattleHud:getItemCostCell(nTag)
    if nTag >0 and nTag <= 6 then
        return GetElementWithoutAssert(self.m_root,"imgItemCost"..nTag.."_WndBattleHud",WZUIImage), GetElementWithoutAssert(self.m_root,"txtItemCost"..nTag.."_WndBattleHud",WZUILabelAtlasFont)
    end
    return nil
end

--@brief    获取幽灵技能栏元素
--@param    nTag,第几个技能栏元素
--@note
function WndBattleHud:getGhostSkillCell(nTag)
    if nTag > 0 and nTag < 4 then
        return GetElementWithoutAssert(self.m_root,"imgGhostSkill"..nTag.."_WndBattleHud",WZUIImage), GetElementWithoutAssert(self.m_root,"imgGLv"..nTag.."_WndBattleHud",WZUIImage)
    end
    return nil
end

--@brief    获取技能栏元素
--@param    nTag,第几个技能栏元素
--@note
function WndBattleHud:getSkillClipCell(nTag)
--    WZLog("WndBattleHud:getSkillClipCell", nTag)
	if nTag >0 and nTag <= 6 then
		return GetElementWithoutAssert(self.m_root,"progSkillClip"..nTag.."_WndBattleHud",WZUIProgress),GetElementWithoutAssert(self.m_root,"txtProgSkillClip"..nTag.."_WndBattleHud",WZUILabelTTF)
	end
	if nTag == -1 or nTag == 62 then
		return GetElementWithoutAssert(self.m_root,"progFlyClip_WndBattleHud",WZUIProgress),GetElementWithoutAssert(self.m_root,"txtProgFlyClip_WndBattleHud",WZUILabelTTF)
	end
    if nTag == 7 then
--        WZLog("WndBattleHud:getSkillClipCell")
        return GetElementWithoutAssert(self.m_root,"progAwakeSkill_WndBattleHud",WZUIProgress),GetElementWithoutAssert(self.m_root,"txtProgAwakeClip_WndBattleHud",WZUILabelTTF)
    end
	return nil
end

--@brief    获取道具栏元素
--@param    nTag,第几个技能栏元素
--@note
function WndBattleHud:getItemClipCell(nTag)
    WZLog("WndBattleHud:getItemClipCell", nTag)
    if nTag >0 and nTag <= 6 then
        return GetElementWithoutAssert(self.m_root,"progItemClip"..nTag.."_WndBattleHud",WZUIProgress)
    end
    return nil
end

--@brief    增加技能引导效果
--@param    nTag,第几个技能栏元素
--@note     --teach
function WndBattleHud:addSkillGuide(nTag, note)
    WZLog("WndBattleHud:addSkillGuide one", tostring(nTag), tostring(note))
end

--@brief    移除技能引导效果
--@param    nTag,第几个技能栏元素
--@note     --teach
function WndBattleHud:removeSkillGuide(nTag, note)
    WZLog("WndBattleHud:removeSkillGuide one", tostring(nTag), tostring(note))

    local skill = WBattleGlobal:getCurrent().m_tMySkill_Beginning
    local tempElement
    local canUseSkill = 0
    for i=1,skill.count do
        tempElement = self:getSkillCell(i)
        if tempElement:getTouchEnable() == false or skill.id[i] == -1 then
            canUseSkill = canUseSkill + 1
        end
    end

    WZLog("WndBattleHud:removeSkillGuide two", tostring(skill.count), tostring(canUseSkill))

end

--@brief    重置技能栏
--@note
function WndBattleHud:resetSkill(bForceClose,note)

	local skill = WBattleGlobal:getCurrent().m_tMySkill_Beginning

    if WBattleGlobal:getCurrent():isAudience() and WBattleGlobal:getCurrent():getCurrentCharacterId() then
        skill =  WBattleGlobal:getCurrent().m_tHudSkill[WBattleGlobal:getCurrent():getCurrentCharacterId()]
    end

    if skill == nil then
        skill = WBattleGlobal:getCurrent().m_tMySkill_Beginning
    end
    WZLog("WndBattleHud:resetSkill zero-1", self.m_tMyHero:isInBuffState(EffectTypeConfig.LIMIT_ONLY_TIMES_SHOOT))

    local tempElement = GetElement(self.m_root,"imgFly_WndBattleHud",WZUIImage)
    if TeachGroup1.ISFIRSTBATTLE ~= true and self.m_tMyHero and (self.m_tMyHero:isInBuffState(EffectTypeConfig.LIMIT_FLY) or
     self.m_tMyHero:isInBuffState(EffectTypeConfig.LIMIT_ONLY_TIMES_SHOOT) or 
     self.m_tMyHero:isInBuffState(EffectTypeConfig.LIMIT_ONLY_TIMES_SHOOT_MOVE) or 
     self.m_tMyHero:isInBuffState(EffectTypeConfig.LIMIT_ONLY_SCATTER_TIMES_SHOOT) or
     self.m_tMyHero:getUseSkillTime() >= 1) then
        local img = WZUIImage:luaTo(tempElement)
        local color = img:getColor()
        WZLog("WndBattleHud:resetSkill zero-2", color.r)
        if color.r ~= 100 then
            img:setColor(GlobalMethod:ccc3(100,100,100))
        end
        self:setMyFlyEnable(false)

    else
        WZLog("WndBattleHud:resetSkill zero-3")
        local img = WZUIImage:luaTo(tempElement)
        img:setColor(GlobalMethod:ccc3(255,255,255))
        self:setMyFlyEnable(true)
    end

    local hero = self.m_tMyHero
    if WBattleGlobal:getCurrent():isAudience() and WBattleGlobal:getCurrent():getCurrentCharacter() then
        hero = WBattleGlobal:getCurrent():getCurrentCharacter()
    end

	local tempElement
	for i=1,skill.count do
		tempElement = self:getSkillCell(i)
        self.m_tSkillTouchMark[i] = true 
        local img, txt = self:getSkillCostCell(i)
		if tempElement then
            WZLog("WndBattleHud:resetSkill one", i, tostring(TeachGroup1.ISBATTLE), tostring(skill.id[i]), tostring(skill.consumePower[i]), tostring(BattleMsgTeachStep4.m_bIsDoing))
			if skill.id[i] == -1 then
				WZUIImage:luaTo(tempElement):setFile(WndBattleHud.SKILL_ITEM_LOCK_PATH)
				tempElement:setVisible(true)
                tempElement:setScale(0.5)
                img:setVisible(false)
			elseif skill.id[i] == 0 then
				tempElement:setVisible(false)
                tempElement:setScale(1)
                img:setVisible(false)
            elseif skill.id[i] == nil then
                tempElement:setScale(1)
                img:setVisible(false)
            elseif self.m_tMyHero:isInBuffState(EffectTypeConfig.LIMIT_ONLY_TIMES_SHOOT) or self.m_tMyHero:isInBuffState(EffectTypeConfig.LIMIT_ONLY_TIMES_SHOOT_MOVE) then
                local x,y = 0.7,0.2
                local bPFNotAllow = hero:getUseSkillTime() >= 1 or bForceClose
                WZLog("WndBattleHud:resetSkill five-1")
                if skill.itemSubType[i] == 1 and hero:isInBuffState(EffectTypeConfig.LIMIT_USE_SKILL) ~= true and bPFNotAllow ~= true then
                    local pngPath = skill.icon[i]
                    local img = WZUIImage:luaTo(tempElement)
                    img:setColor(GlobalMethod:ccc3(255,255,255))
                    img:setFile(pngPath)
                    img:setVisible(true)
                    img:setTouchEnable(true)

                    if img:getChildByTag(77) == nil and skill.lv and skill.lv[i] then
                        local lv = WZUIImage:create()
                        lv:setUseOriginSize(true)
                        lv:setFile(skill.lv[i])
                        lv:setRelativePositionLuaTo(x,y)
                        img:addChild(lv,0,77)
                    end
                    WZLog("WndBattleHud:resetSkill five-2")
                else
                    local img = WZUIImage:luaTo(tempElement)
                    img:setColor(GlobalMethod:ccc3(100,100,100))
                    img:setFile(skill.icon[i])
                    img:setTouchEnable(false)
                --    WZLog("WndBattleHudWndBattleHud 111111111")
                    WZLog("WndBattleHud:resetSkill five-3")

                    if img:getChildByTag(77) == nil and skill.lv and skill.lv[i] then
                        local lv = WZUIImage:create()
                        lv:setUseOriginSize(true)
                        lv:setFile(skill.lv[i])
                        lv:setRelativePositionLuaTo(x,y)
                        img:addChild(lv,0,77)
                    end
                end
            elseif self.m_tMyHero:isInBuffState(EffectTypeConfig.LIMIT_ONLY_SCATTER_TIMES_SHOOT) then
                local x,y = 0.7,0.2
                local bPFNotAllow = hero:getUseSkillTime() >= 1 or bForceClose
                if (skill.itemSubType[i] == 1 or skill.itemSubType[i] == 2) and hero:isInBuffState(EffectTypeConfig.LIMIT_USE_SKILL) ~= true and bPFNotAllow ~= true then
                    local pngPath = skill.icon[i]
                    local img = WZUIImage:luaTo(tempElement)
                    img:setColor(GlobalMethod:ccc3(255,255,255))
                    img:setFile(pngPath)
                    img:setVisible(true)
                    img:setTouchEnable(true)

                    if img:getChildByTag(77) == nil and skill.lv and skill.lv[i] then
                        local lv = WZUIImage:create()
                        lv:setUseOriginSize(true)
                        lv:setFile(skill.lv[i])
                        lv:setRelativePositionLuaTo(x,y)
                        img:addChild(lv,0,77)
                    end
                else
                    local img = WZUIImage:luaTo(tempElement)
                    img:setColor(GlobalMethod:ccc3(100,100,100))
                    img:setFile(skill.icon[i])
                    img:setTouchEnable(false)
                --    WZLog("WndBattleHudWndBattleHud 22222222")
--                    WZLog("WndBattleHud:resetSkill two-2")

                    if img:getChildByTag(77) == nil and skill.lv and skill.lv[i] then
                        local lv = WZUIImage:create()
                        lv:setUseOriginSize(true)
                        lv:setFile(skill.lv[i])
                        lv:setRelativePositionLuaTo(x,y)
                        img:addChild(lv,0,77)
                    end
                end
			else
                tempElement:setScale(1)
                img:setVisible(true)
                local point = math.ceil(skill.consumePower[i]/1000)
                txt:setText(point)
				local bPFNotAllow = hero:getUseSkillTime() >= 1 or bForceClose

                WZLog("WndBattleHud:resetSkill two", i, skill.icon[i])

                local x,y = 0.7,0.2
				if hero and (bPFNotAllow or  hero:getUseBigSkill() == true or hero:isInBuffState(EffectTypeConfig.LIMIT_USE_SKILL) or self.m_nUsePoint + point > 10 or self.m_tMyHero:isInBuffState(EffectTypeConfig.LIMIT_ONLY_FLY_MOVE)) then
					local img = WZUIImage:luaTo(tempElement)
					img:setColor(GlobalMethod:ccc3(100,100,100))
					img:setFile(skill.icon[i])
				--	img:setTouchEnable(false)
                    self.m_tSkillTouchMark[i] = false
                --    WZLog("WndBattleHudWndBattleHud 333333333333")
				--	WZLog("WndBattleHud:resetSkill two-2")

                    if img:getChildByTag(77) == nil and skill.lv and skill.lv[i] then
                        local lv = WZUIImage:create()
                        lv:setUseOriginSize(true)
                        lv:setFile(skill.lv[i])
                        lv:setRelativePositionLuaTo(x,y)
                        img:addChild(lv,0,77)
                    end
				else
                --    WZLog("WndBattleHud:resetSkill two-3")
					local pngPath = skill.icon[i]
					local img = WZUIImage:luaTo(tempElement)
					img:setColor(GlobalMethod:ccc3(255,255,255))
					img:setFile(pngPath)
					img:setVisible(true)
					img:setTouchEnable(true)

                    if img:getChildByTag(77) == nil and skill.lv and skill.lv[i] then
                        local lv = WZUIImage:create()
                        lv:setUseOriginSize(true)
                        lv:setFile(skill.lv[i])
                        lv:setRelativePositionLuaTo(x,y)
                        img:addChild(lv,0,77)
                    end
				end

			end
		end
	end
end

--@brief    技能回调
--@param    sender:被选中的技能元素
--@note
function WndBattleHud:onSkill(sender)
    WZLog("WndBattleHud:onSkill",tostring(TeachGroup1.ISBATTLE), tostring(TeachGroup1.ISBATTLE_MYTURN))
    sender:disableSchedule()
    if WBattleGlobal:getCurrent():isGameOver() == true or (TeachGroup1.ISBATTLE and TeachGroup1.ISSKILL == nil) or self.m_tMyHero:isInBuffState(EffectTypeConfig.LIMIT_USE_SKILL) then
        return
    end

    local nTag = sender:getTag()
    if self.m_tSkillTouchMark[nTag] ~= nil and self.m_tSkillTouchMark[nTag] == false then return end 

    local curTime = WZThread:getUTickCount()
    if self.m_nTouchBeginTime == nil then self.m_nTouchBeginTime = curTime end 
    if not TeachGroup1.ISBATTLE and curTime - self.m_nTouchBeginTime >= 800000 then
        return 
    end

    if WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle then
        MsgBoxManager:showTipBox(LocalStrings.BATTLE_NOT_MY_TURN)
        return
    end
    --自动战斗不可操作提示
    if GlobalGame.g_bIsAutoFightOpen then 
        MsgBoxManager:showTipBox(LocalStrings.BATTLE_AUTOFIGHT_ATT)
        return 
    end

	if sender then
		local skill = WBattleGlobal:getCurrent().m_tMySkill_Beginning
		local index = sender:getTag()
		WZLog("WndBattleHud:onSkill=",index)
		if skill.id[index]~=-1 then

			local originScale = 1
            --触摸动画部分
			local scale1 = WZUIActionScaleTo:create()
			scale1:setScaleX(0.7 * originScale)
			scale1:setScaleY(0.7 * originScale)
			scale1:setDuration(0.1)
			local scale2 = WZUIActionScaleTo:create()
			scale2:setScaleX(1 * originScale)
			scale2:setScaleY(1 * originScale)
			scale2:setDuration(0.1)
			local sequence = WZUIActionSequence:create()
			sequence:setChildAction(scale1)
			sequence:setChildAction(scale2)
			sender:runUIAction(sequence)

			local useType = BattleHeroUse.USE_SKILL
			local useId = skill.id[index]

            if TeachGroup1.ISBATTLE_MYTURN then
                TeachGroup1.SKILLID = useId
            end

            if self.m_nUsePoint + skill.consumePower[index] / 1000 > 10 then 
                MsgBoxManager:showTipBox(LocalStrings.BATTLE_ACTION_VALUE_NO_ENOUGH)
                return 
            end
            self.m_nUsePoint = self.m_nUsePoint + skill.consumePower[index] / 1000
            self.m_tMyHero.m_nUsePoint = self.m_tMyHero.m_nUsePoint + skill.consumePower[index]

            --单人副本，生成溅射弹角度
            local tItemData = GDatatab_skill["id_" .. useId]
            if tItemData and tItemData.id_group == 107 and tItemData.sub_type == 12 and WBattleGlobal:getCurrent():isSingleStage() then 
                local effectData = GDatatab_effect["id_" .. tItemData.effect_id[1][1]]
                local tSpatterAngle = GetRandomNum(effectData.effect[1][5], 110, 70)
                WZLog("WndBattleHud:onSkill", Serialize(tSpatterAngle))
                WBattleGlobal:getCurrent():setCurSpatterAngle(tSpatterAngle)
            end

			if BattleHeroUse:heroUse(self.m_tMyHero:getBattleId(),useType,useId, nil) then
                WZLog("WndBattleHud:onSkill", useType, useId, skill.id[index])
				WBattleGlobal:getCurrent().m_nAutoFightActIndex = 1
				self:useMySkill(useId)
				
				--self:setBigSkillEnable(false)
                self:_postSkillItemEvent(tItemData)
			end
			self:setFlyPos()
		else
			--MsgBoxManager:showTipBox(LocalStrings.BATTLE_EXT_ITEMSKILL_LIMIT)
		end
	end
end

------Item

--@brief    获取道具栏发光元素
function WndBattleHud:getItemLigthCell(nTag)
    if nTag <= 6 then
        return GetElementWithoutAssert(self.m_root,"conAnimItem"..nTag.."_WndBattleHud",WZUIContainer), GetElementWithoutAssert(self.m_root,"animItem"..nTag.."_WndBattleHud",WZUISpine)
    end
    return nil
end

--@brief    获取道具栏元素
--@param    nTag,第几个道具元素
--@note
function WndBattleHud:getItemCell(nTag)
	if nTag <= 6 then
		return GetElementWithoutAssert(self.m_root,"imgItem"..nTag.."_WndBattleHud",WZUIImage)
	end
	return nil
end

--@brief    获取道具栏元素
--@param    nTag,第几个道具元素
--@note
function WndBattleHud:getItemCellTeach(nTag)
    if nTag < 6 then
        return GetElementWithoutAssert(self.m_root,"imgItemTeach"..nTag.."_WndBattleHud",WZUIImage)
    end
    return nil
end

--@brief    获取道具栏元素
--@param    nTag,第几个道具元素
--@note
function WndBattleHud:getSkillCellTeach(nTag)
    if nTag < 6 then
        return GetElementWithoutAssert(self.m_root,"imgSkillTeach"..nTag.."_WndBattleHud",WZUIImage)
    end
    return nil
end

--@brief    增加道具引导效果
--@param    nTag,第几个道具栏元素
--@note     --teach
function WndBattleHud:addItemGuide(nTag)
	local img = self:getItemCell(nTag)

	--self:_addSkillORItemGuide(img)
end

--@brief    移除道具引导效果
--@param    nTag,第几个道具元素
--@note     --teach
function WndBattleHud:removeItemGuide(nTag)
	local img = self:getItemCell(nTag)

	self:_removeSkillORItemGuide(img)
end

--@brief    重置道具栏
--@note
function WndBattleHud:resetItem(bForceClose, isGet)
    WZLog("WndBattleHud:resetItem zero", isGet)
	local item = WBattleGlobal:getCurrent().m_tMyProp_Beginning

    if WBattleGlobal:getCurrent():isAudience() and WBattleGlobal:getCurrent():getCurrentCharacterId() then
        item =  WBattleGlobal:getCurrent().m_tHudItem[WBattleGlobal:getCurrent():getCurrentCharacterId()]
    end

    if item == nil then
        item = WBattleGlobal:getCurrent().m_tMyProp_Beginning
    end

	local tempElement
    local heroCharacter = WBattleGlobal:getCurrent():getCurrentCharacter()
    if not heroCharacter then return end

	for i=1,item.count do
		tempElement = self:getItemCell(i)
        self.m_tItemTouchMark[i] = true
        local img, txt = self:getItemCostCell(i)

		if tempElement then
			if item.id[i] == -1 then
				WZUIImage:luaTo(tempElement):setFile(WndBattleHud.SKILL_ITEM_LOCK_PATH)
				tempElement:setVisible(true)
                tempElement:setScale(0.5)
                img:setVisible(false)
			elseif item.id[i] == 0 or self.m_tUseItem[i] <=0 then
                tempElement:setScale(1)
				tempElement:setVisible(false)
                img:setVisible(false)
			else
                tempElement:setScale(1)
                local point = math.ceil(item.consumePower[i]/1000)
                txt:setText(point)
				local bPFNotAllow = self.m_tMyHero:getUseItemTime() >= 1 or bForceClose--or WBattleGlobal:getCurrent():getCurrentCharacterId() ~= self.m_tMyHero:getBattleId()) --self.m_tMyHero:getPF() < item.consumePower[i]

                --WZLog("WndBattleHud:resetItem one", point, self.m_nUsePoint, tostring(TeachGroup1.ISFIRSTBATTLE), tostring(self.m_tMyHero))
                WZLog("WndBattleHud:resetItem one", self.m_tUseItem[i])
                local x,y = 0.7,0.2
				if self.m_tUseItem[i]<=0 then
                    WZLog("WndBattleHud:resetItem two-1")
					tempElement:setVisible(false)
				elseif TeachGroup1.ISFIRSTBATTLE == nil and self.m_tMyHero and (bPFNotAllow or self.m_tMyHero.m_nDebuffSealRound or 
                    self.m_tMyHero:isInBuffState(EffectTypeConfig.LIMIT_USE_ITEM) or 
                    self.m_tMyHero:isInBuffState(EffectTypeConfig.LIMIT_ONLY_TIMES_SHOOT) or 
                    self.m_tMyHero:isInBuffState(EffectTypeConfig.LIMIT_ONLY_TIMES_SHOOT_MOVE) or
                    self.m_tMyHero:isInBuffState(EffectTypeConfig.LIMIT_ONLY_SCATTER_TIMES_SHOOT) or
                    isGet or
                    self.m_nUsePoint + point > 10) then
                WZLog("WndBattleHud:resetItem two-2", item.lv[i], img:getChildByTag(987) and img:getChildByTag(987):getFile())
					local img = WZUIImage:luaTo(tempElement)
					img:setFile(item.icon[i])
                    img:setColor(GlobalMethod:ccc3(100,100,100))
				--	img:setTouchEnable(false)
                --    WZLog("ItemItemItemItem 11111111")
                    self.m_tItemTouchMark[i] = false  --可以触摸长按，弹出道具tips
                    img:setVisible(true)

                    if tostring(item.lv[i]) ~= "-1" then
                            if img:getChildByTag(987) == nil or img:getChildByTag(987).getFile == nil or img:getChildByTag(987):getFile() ~= item.lv[i] then
                                if img:getChildByTag(987) and img:getChildByTag(987).removeFromParentAndCleanup then
                                    img:getChildByTag(987):removeFromParentAndCleanup(true)
                                end
                                local lv = WZUIImage:create()
                                lv:setUseOriginSize(true)
                                lv:setFile(item.lv[i])
                                lv:setRelativePositionLuaTo(x,y)
                                img:addChild(lv,0,987)
                            end
                        elseif tostring(item.lv[i]) == "-1" and img:getChildByTag(987) then
                            img:getChildByTag(987):removeFromParentAndCleanup(true)
                        end
                elseif self.m_tMyHero and self.m_tMyHero:isInBuffState(EffectTypeConfig.LIMIT_ONLY_FLY_MOVE) then
                    WZLog("WndBattleHud:resetItem two-3")
                    if item.id[i] == BattleHeroUse.ITEM_FLY then
                        WZLog("WndBattleHud:resetItem two-3-1", tostring(item.lv[i]) ~= "-1")
                        local pngPath = item.icon[i]
                        local img = WZUIImage:luaTo(tempElement)
                        img:setColor(GlobalMethod:ccc3(255,255,255))
                        img:setFile(pngPath)
                        img:setVisible(true)
                        img:setTouchEnable(true)

                        if tostring(item.lv[i]) ~= "-1" then
                            if img:getChildByTag(987) == nil or img:getChildByTag(987).getFile == nil or img:getChildByTag(987):getFile() ~= item.lv[i] then
                                if img:getChildByTag(987) and img:getChildByTag(987).removeFromParentAndCleanup then
                                    img:getChildByTag(987):removeFromParentAndCleanup(true)
                                end
                                local lv = WZUIImage:create()
                                lv:setUseOriginSize(true)
                                lv:setFile(item.lv[i])
                                lv:setRelativePositionLuaTo(x,y)
                                img:addChild(lv,0,987)
                            end
                        elseif tostring(item.lv[i]) == "-1" and img:getChildByTag(987) then
                            img:getChildByTag(987):removeFromParentAndCleanup(true)
                        end
                    else
                        WZLog("WndBattleHud:resetItem two-3-2", tostring(item.lv[i]) ~= "-1")
                        local img = WZUIImage:luaTo(tempElement)
                        img:setColor(GlobalMethod:ccc3(100,100,100))
                        img:setFile(item.icon[i])
                        img:setTouchEnable(false)
                    --    WZLog("ItemItemItemItem 22222222")
                        if tostring(item.lv[i]) ~= "-1" then
                            if img:getChildByTag(987) == nil or img:getChildByTag(987).getFile == nil or img:getChildByTag(987):getFile() ~= item.lv[i] then
                                if img:getChildByTag(987) and img:getChildByTag(987).removeFromParentAndCleanup then
                                    img:getChildByTag(987):removeFromParentAndCleanup(true)
                                end
                                local lv = WZUIImage:create()
                                lv:setUseOriginSize(true)
                                lv:setFile(item.lv[i])
                                lv:setRelativePositionLuaTo(x,y)
                                img:addChild(lv,0,987)
                            end
                        elseif tostring(item.lv[i]) == "-1" and img:getChildByTag(987) then
                            img:getChildByTag(987):removeFromParentAndCleanup(true)
                        end
                    end

				else
                    WZLog("WndBattleHud:resetItem two-4")
					if TeachGroup1.ISFIRSTBATTLE == nil and item.id[i] == BattleHeroUse.ITEM_FLY and self.m_tMyHero and self.m_tMyHero:isInBuffState(EffectTypeConfig.LIMIT_FLY) then
						WZLog("WndBattleHud:resetItem two-4-1", tostring(item.lv[i]) ~= "-1")
                        local img = WZUIImage:luaTo(tempElement)
						img:setColor(GlobalMethod:ccc3(100,100,100))
						img:setFile(item.icon[i])
						img:setTouchEnable(false)
                    --    WZLog("ItemItemItemItem 3333333")
                        if tostring(item.lv[i]) ~= "-1" then
                            if img:getChildByTag(987) == nil or img:getChildByTag(987).getFile == nil or img:getChildByTag(987):getFile() ~= item.lv[i] then
                                if img:getChildByTag(987) and img:getChildByTag(987).removeFromParentAndCleanup then
                                    img:getChildByTag(987):removeFromParentAndCleanup(true)
                                end
                                local lv = WZUIImage:create()
                                lv:setUseOriginSize(true)
                                lv:setFile(item.lv[i])
                                lv:setRelativePositionLuaTo(x,y)
                                img:addChild(lv,0,987)
                            end
                        elseif tostring(item.lv[i]) == "-1" and img:getChildByTag(987) then
                            img:getChildByTag(987):removeFromParentAndCleanup(true)
                        end
					else
						--new UI
                        WZLog("WndBattleHud:resetItem two-4-2", tostring(item.lv[i]) ~= "-1", item.icon[i], "item.lv[i]", item.lv[i])
						local pngPath = item.icon[i]
						local img = WZUIImage:luaTo(tempElement)
						img:setColor(GlobalMethod:ccc3(255,255,255))
						img:setFile(pngPath)
						img:setVisible(true)
						img:setTouchEnable(true)

                        if tostring(item.lv[i]) ~= "-1" then
                            if img:getChildByTag(987) == nil or img:getChildByTag(987).getFile == nil or img:getChildByTag(987):getFile() ~= item.lv[i] then
                                if img:getChildByTag(987) and img:getChildByTag(987).removeFromParentAndCleanup then
                                    img:getChildByTag(987):removeFromParentAndCleanup(true)
                                end
                                local lv = WZUIImage:create()
                                lv:setUseOriginSize(true)
                                lv:setFile(item.lv[i])
                                lv:setRelativePositionLuaTo(x,y)
                                img:addChild(lv,0,987)
                            end
                        elseif tostring(item.lv[i]) == "-1" and img:getChildByTag(987) then
                            img:getChildByTag(987):removeFromParentAndCleanup(true)
                        end
					end
				end
			end
		end
	end
end

--@brief    道具回调
--@param    sender:被选中的道具元素
--@note
function WndBattleHud:onItem(sender)
    sender:disableSchedule()
    if WBattleGlobal:getCurrent():isGameOver() == true or TeachGroup1.ISBATTLE or self.m_tMyHero:isInBuffState(EffectTypeConfig.LIMIT_USE_SKILL) then
        return
    end

    local nTag = sender:getTag()
    if self.m_tItemTouchMark[nTag] ~= nil and self.m_tItemTouchMark[nTag] == false then return end 

    local curTime = WZThread:getUTickCount()
    if self.m_nTouchBeginTime == nil then self.m_nTouchBeginTime = curTime end 
    if not TeachGroup1.ISBATTLE and curTime - self.m_nTouchBeginTime >= 800000 then
        return 
    end

    if WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle then
        MsgBoxManager:showTipBox(LocalStrings.BATTLE_NOT_MY_TURN)
        return
    end

    --自动战斗不可操作提示
    if GlobalGame.g_bIsAutoFightOpen then 
        MsgBoxManager:showTipBox(LocalStrings.BATTLE_AUTOFIGHT_ATT)
        return 
    end

    WZLog("WndBattleHud:onItem")
	if sender then
		local item = WBattleGlobal:getCurrent().m_tMyProp_Beginning
		local index = sender:getTag()
		if item.id[index] ~= -1 then
			local originScale = 1
            --触摸动画部分
			local scale1 = WZUIActionScaleTo:create()
			scale1:setScaleX(0.7 * originScale)
			scale1:setScaleY(0.7 * originScale)
			scale1:setDuration(0.1)
			local scale2 = WZUIActionScaleTo:create()
			scale2:setScaleX(1 * originScale)
			scale2:setScaleY(1 * originScale)
			scale2:setDuration(0.1)
			local sequence = WZUIActionSequence:create()
			sequence:setChildAction(scale1)
			sequence:setChildAction(scale2)
			sender:runUIAction(sequence)

            local useType = BattleHeroUse.USE_ITEM
			local useId = item.id[index]
            WZLog("WndBattleHud:onItem one", useId)
            if useId == 61 and WBattleGlobal:getCurrent():isDigGappingFighting() then 
                MsgBoxManager:showTipBox(LocalStrings.BATTLE_HUD_TEXT2)
                return 
            end
            if self.m_nUsePoint + item.consumePower[index] / 1000 > 10 then 
                MsgBoxManager:showTipBox(LocalStrings.BATTLE_ACTION_VALUE_NO_ENOUGH)
                return 
            end

            local tItemData = GDatatab_skill["id_" .. useId]
            if tItemData then
                local tCondition = SplitStringWithSeparator(tItemData.use_condition,"&")
                for i=1,#tCondition do
                    local nStart1, nEnd1 = string.find(tCondition[i],"^syxlxy%%=") --回光返照条件
                    if nStart1 then
                        local hp = self.m_tMyHero:getHp()
                        local hpNow = hp/self.m_tMyHero:getMaxHp()*100
                        local use_condition_num = string.match(tCondition[i], "%d+")
                        if hpNow >= tonumber(use_condition_num) then 
                            local strTemp1 = string.gsub(tItemData.tool_desc, "，", ",")
                            local nStartTemp, nEndTemp = string.find(strTemp1, ",")
                            if nStartTemp and nEndTemp then 
                                local strTemp2 = string.sub(strTemp1, 1, nStartTemp - 1)
                                MsgBoxManager:showTipBox(strTemp2)
                            end
                            return 
                        end
                    end
                end
            end

            self.m_nUsePoint = self.m_nUsePoint + item.consumePower[index] / 1000
            self.m_tMyHero.m_nUsePoint = self.m_tMyHero.m_nUsePoint + item.consumePower[index]

			if BattleHeroUse:heroUse(self.m_tMyHero:getBattleId(),useType,useId, nil) then
                WZLog("WndBattleHud:onItem two", useId)
                -- if tItemData and tItemData.id_group == 703 and WBattleGlobal:getCurrent():isSingleStage() then 
                --     local tEffectData = GDatatab_effect["id_" .. tItemData.effect_id[1][1]]
                --     self.m_nWindSkillId = useId
                --     self.m_nWindSkillBuffTime = tEffectData.effect[1][7]
                -- end
				self.m_tUseItem[index] = self.m_tUseItem[index] - 1
				if self.m_tUseItem[index] <= 0 then
					sender:setVisible(false)
                    local img, txt = self:getItemCostCell(index)
                    if img then
                        img:setVisible(false)
                    end
                    if WBattleGlobal:getCurrent():isEscapeBattle() then
                        WBattleGlobal:getCurrent().m_tMyProp_Beginning.id[index] = 0
                    end
				end

                if useId == 61 then 
                    WBattleGlobal:getCurrent().m_nAutoFightActIndex = 2
                end
                if tItemData and tItemData.id_group == 100 then 
                    self:_postPowerItemEvent()
                end
			end
            self:setFlyPos()
		else
			--MsgBoxManager:showTipBox(LocalStrings.BATTLE_EXT_ITEMSKILL_LIMIT)
		end
	end
end

--@brief    自动战斗，设置使用过的道具不可见
function WndBattleHud:dealwithItemAfterUse(itemId)
    -- body
    if self.m_root == nil then return end 
    if itemId <= 0 then return end 

    local item = WBattleGlobal:getCurrent().m_tMyProp_Beginning
    local index = 0 
    for i = 1, #item.id do
        if item.id[i] == itemId then 
            index = i
            break 
        end
    end

    if index > 0 then 
        local sender = GetElement(self.m_root, "imgItem" .. index .. "_WndBattleHud", WZUIImage)
        if sender then 
            sender:setVisible(false)
        end

        self.m_tUseItem[index] = self.m_tUseItem[index] - 1
        if self.m_tUseItem[index] <= 0 then
            local img, txt = self:getItemCostCell(index)
            if img then
                img:setVisible(false)
            end
        end
    end
end
------Medal

--@brief    创建勋章界面
function WndBattleHud:createMedal()
	if WBattleGlobal:getCurrent():getBattleType() == BattleConstants.g_nBATTLE_TYPE_NORMAL then
		if GlobalGame.g_tBattleMode.BATTLE_MODE_FH == WBattleGlobal:getCurrent().m_tMakePairOk.battleMode then
            for i=1,WBattleGlobal:getCurrent():getNeedMedal() do
				self:_addMedal(true,i)
				self:_addMedal(false,i)
			end
		end
	end
    WZLog("WndBattleHud:createMedal", WBattleGlobal:getCurrent():getLeftMedal(), WBattleGlobal:getCurrent():getRightMedal(), WBattleGlobal:getCurrent():getNeedMedal())

end

--@brief    显示勋章动画
--@param    tPlayerPos,玩家的位置
--@param    isLeft,勋章是否在左边
--@param    nIdx,第几个位置
function WndBattleHud:showMedal(tPlayerPos,isLeft,nIdx)
    WZLog("WndBattleHud:showMedal", tostring(isLeft), nIdx, WBattleGlobal:getCurrent():getLeftMedal(), WBattleGlobal:getCurrent():getRightMedal(), WBattleGlobal:getCurrent():getNeedMedal())

	self.m_bShowMedalAnim = true

	-- if CCArmatureDataManager:sharedArmatureDataManager():getTextureData("ui_medal") == nil then
	-- 	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("armatures/battle/ui/ui.png", "armatures/battle/ui/ui.plist", "armatures/battle/ui/ui.xml")
 --        CCArmatureDataManager:sharedArmatureDataManager():addSpriteFrameFromFile("armatures/battle/ui/ui.plist", "armatures/battle/ui/ui.png")
	-- end
 --    local anim = BattleAnimation:createAnimation("ui_medal",true)

	local anim = BattleAnimation:createAnimation("ui_medal",true,"battle/ui")
	anim:getAnimNode():setUseOriginSize(true)
	anim:getAnimNode():setShowAll(true)
	anim:getAnimNode():setAnchorPointLuaTo(0.5,0.5)
	local pos = SceneBattle:getFrontLayer():convertToWorldSpace(tPlayerPos)
	pos = self.m_root:convertToNodeSpace(pos)
	pos.x = pos.x / self.m_root:getContentSize().width
	pos.y = pos.y / self.m_root:getContentSize().height
	anim:getAnimNode():setRelativePosition(pos)
	self.m_root:addChild(anim:getAnimNode())
	anim:getAnimNode():setScaleX(1.3 * anim:getAnimNode():getScaleX() )
	anim:getAnimNode():setScaleY(1.3 * anim:getAnimNode():getScaleY() )
	anim:play("0",true)

	if isLeft then
		self.m_tMedalAnimTarget = GetElement(self.m_root,"imgLeftMedal"..nIdx.."_WndBattleHud")
	else
		self.m_tMedalAnimTarget = GetElement(self.m_root,"imgRightMedal"..nIdx.."_WndBattleHud")
	end
	self.m_tMedalAnimTarget = WZUIImage:luaTo(self.m_tMedalAnimTarget)

	local action1 = WZUIActionDelayTime:create()
	action1:setDuration(2)
	local action2 = WZUIActionMoveTo:create()
	action2:setMoveX(self.m_tMedalAnimTarget:getRelativePosition().x)
	action2:setMoveY(self.m_tMedalAnimTarget:getRelativePosition().y)
	action2:setDuration(1)
	local action3 = WZUIActionDelayTime:create()
	action3:setDuration(0.3)

	local sequence = WZUIActionSequence:create()
	sequence:setChildAction(action1)
	sequence:setChildAction(action2)
	sequence:setChildAction(action3)
    sequence:setFinishLuaTable(self)
    sequence:setFinishLuaFunction("showMedalDone")
	anim:getAnimNode():runUIAction(sequence)
	local xScale = self.m_tMedalAnimTarget:getScaleX()
	local yScale = self.m_tMedalAnimTarget:getScaleY()
    self.m_tMedalAnimTarget:setGrayRender(false)
	self.m_tMedalAnimTarget:setScaleX(xScale)
	self.m_tMedalAnimTarget:setScaleY(yScale)

	local actionFadeTo1 = WZUIActionFadeTo:create()
	actionFadeTo1:setOpacity(0)
	actionFadeTo1:setDuration(0.25)
	local actionFadeTo2 = WZUIActionFadeTo:create()
	actionFadeTo2:setOpacity(255)
	actionFadeTo2:setDuration(0.25)
	sequence = WZUIActionSequence:create()
	sequence:setIsLoop(true)

	sequence:setChildAction(actionFadeTo1)
	sequence:setChildAction(actionFadeTo2)

	self.m_tMedalAnimTarget:runUIAction(sequence)

	SoundManager:playEffectSound(SoundDefine.E_S_GETBADGE)
end

--@brief    显示勋章动画
--@param    tPlayerPos,玩家的位置
--@param    isLeft,勋章是否在左边
--@param    nIdx,第几个位置
function WndBattleHud:showMedal2(tPlayerPos,isLeft,nIdx)
    WZLog("WndBattleHud:showMedal2", isLeft, nIdx)
    local id = 1
    if isLeft ~= true then
        id = 2
    end


    self.m_tMedalList[id + (nIdx-1) * 2]:setGrayRender(false)
end


--@brief    显示勋章动画完成回调
--@param    sender,动画绑定的对象
function WndBattleHud:showMedalDone(sender)
    WZLog("WndBattleHud:showMedalDone")
	sender:removeFromParentAndCleanup(true)
	self.m_tMedalAnimTarget:stopAllActions()
	self.m_tMedalAnimTarget:setOpacity(255)
	local xScale = self.m_tMedalAnimTarget:getScaleX()
	local yScale = self.m_tMedalAnimTarget:getScaleY()
	self.m_tMedalAnimTarget:setScaleX(xScale)
	self.m_tMedalAnimTarget:setScaleY(yScale)
    self.m_tMedalAnimTarget:setGrayRender(false)
	self.m_tMedalAnimTarget = nil
	self.m_bShowMedalAnim = false
    
end

--@brief    判断是否正在播放勋章动画
--@return   是否在播放
function WndBattleHud:isRunningMedalAnim()
	return self.m_bShowMedalAnim
end


-----Ctb
function WndBattleHud:onCtbBg()
    WZLog("WndBattleHud:onCtbBg")
	BattleCtbManager:showBigCtb(false)
    if self.m_tMedalList and #self.m_tMedalList > 0 then
        for i, medal in pairs(self.m_tMedalList) do
            medal:setVisible(true)
        end
    end
end

function WndBattleHud:showBigCtb2()
    WZLog("WndBattleHud:showBigCtb2")
    WndBattleHud:showBigCtb()
end

function WndBattleHud:showBigCtb()
    if TeachGroup1.ISBATTLE == true then
        return
    end

    WZLog("WndBattleHud:showBigCtb")
    if BattleCtbManager.m_bIsVisble == true then
        BattleCtbManager:showBigCtb()
        self.m_nShowBigCtb = 0
        if self.m_tMedalList and #self.m_tMedalList > 0 then
            for i, medal in pairs(self.m_tMedalList) do
                medal:setVisible(false)
            end
        end
    end
end

--@brief    获取技能在哪个位置
function WndBattleHud:getMySkillPos(nSkillId)
	local skill = WBattleGlobal:getCurrent().m_tMySkill_Beginning

    if WBattleGlobal:getCurrent():isAudience() and WBattleGlobal:getCurrent():getCurrentCharacterId() then
        skill =  WBattleGlobal:getCurrent().m_tHudSkill[WBattleGlobal:getCurrent():getCurrentCharacterId()]
    end

    if skill == nil then
        skill = WBattleGlobal:getCurrent().m_tMySkill_Beginning
    end

	local nTag
	for i=1,skill.count do
		if skill.id[i] == nSkillId then
			nTag = i
		end
	end
	if nSkillId == BattleHeroUse.FLY_SKILL_ID then
		nTag = -1
	end
    if WBattleGlobal:getCurrent().m_nAwakeSkillId and nSkillId == WBattleGlobal:getCurrent().m_nAwakeSkillId then
        nTag = 7
    end

	return nTag
end

--@brief    获取道具在哪个位置
function WndBattleHud:getMyItemPos(nSkillId)
    local skill = WBattleGlobal:getCurrent().m_tMyProp_Beginning

    if WBattleGlobal:getCurrent():isAudience() and WBattleGlobal:getCurrent():getCurrentCharacterId() then
        skill =  WBattleGlobal:getCurrent().m_tHudItem[WBattleGlobal:getCurrent():getCurrentCharacterId()]
    end

    if skill == nil then
        skill = WBattleGlobal:getCurrent().m_tMyProp_Beginning
    end

    local nTag
    for i=1,skill.count do
        if skill.id[i] == nSkillId then
            nTag = i
        end
    end

    return nTag
end

--@brief    使用自己的技能后对应的冷却效果
function WndBattleHud:useMySkill(nSkillId,bFirstTime)
	bFirstTime = bFirstTime or false
	local nTag = WndBattleHud:getMySkillPos(nSkillId)
	if nTag and nSkillId and nSkillId > 0 then
        local coolSkillTime = nSkillId <= 0 and 0 or WBattleGlobal:getCurrent():getSkillById(nSkillId).coolSkillTime
		if bFirstTime and nSkillId > 0 then
			coolSkillTime = WBattleGlobal:getCurrent():getSkillById(nSkillId).startCoolSkillTime
            coolSkillTime = coolSkillTime <= 1 and 0 or coolSkillTime
		end
		if true then
			local prog,txtProg = WndBattleHud:getSkillClipCell(nTag)
			prog:setPercentage(100)
			prog:setVisible(true)
			if txtProg then
				txtProg:setText( BattleCtbManager:convertCtbToTime(coolSkillTime) )
				txtProg:setVisible(false)
			end
            if nSkillId == WBattleGlobal.getCurrent().m_nAwakeSkillId then 
                GetElement(self.m_root, "spineAwakeSkill_WndBattleHud", WZUISpine):setVisible(false)
            end
		end
        WZLog("WndBattleHud:useMySkill", nSkillId, coolSkillTime, tostring(bFirstTime))
	end
end

--@brief    使用自己的道具后对应的冷却效果
function WndBattleHud:useMyItem(nSkillId,bFirstTime)
    bFirstTime = bFirstTime or false
    local nTag = WndBattleHud:getMyItemPos(nSkillId)
    if nTag and nSkillId > 0 then
        WZLog("WndBattleHud:useMyItem zero", nSkillId, nTag)
        local coolSkillTime = WBattleGlobal:getCurrent():getItemById(nSkillId).startCoolSkillTime
        coolSkillTime = coolSkillTime <= 1 and 0 or coolSkillTime

        if true then
            local prog = WndBattleHud:getItemClipCell(nTag)
            prog:setPercentage(100)
            prog:setVisible(true)
        end
        WZLog("WndBattleHud:useMyItem one", nSkillId, coolSkillTime)
    end
end

--@brief    使用自己的辅助技能道具后对应的冷却效果
function WndBattleHud:useMyKMSkill(nSkillId)
    local nTag = WndBattleHud:getMyKMSkillPos(nSkillId)
    if nTag and nSkillId > 0 then
        WZLog("WndBattleHud:useMyKMSkill zero", nSkillId, nTag)
        local coolSkillTime = WBattleGlobal:getCurrent():getKMSkillById(nSkillId).startCoolSkillTime
        coolSkillTime = coolSkillTime <= 1 and 0 or coolSkillTime

        if true then
            local prog = WndBattleHud:getKMSkillClipCell(nTag)
            prog:setPercentage(100)
            prog:setVisible(true)
        end
        WZLog("WndBattleHud:useMyKMSkill one", nSkillId, coolSkillTime)
    end
end

function WndBattleHud:updateSkillClipCallBack(element)
	--local nTag = element:getTag()
	if WZUIProgress:luaTo(element):getPercentage() <= 0 then
		element:setVisible(false)
        local nTag = element:getTag()
        if nTag == 9000 then   ---特殊处理觉醒技能
            GetElement(self.m_root, "spineAwakeSkill_WndBattleHud", WZUISpine):setVisible(true)
        end
	end
end

function WndBattleHud:updateItemClipCallBack(element)
    --local nTag = element:getTag()
    if WZUIProgress:luaTo(element):getPercentage() <= 0 then
        element:setVisible(false)
    end
end

function WndBattleHud:updateMySkillCtb()
	if self:getMyHero() or (WBattleGlobal:getCurrent():isAudience() and WBattleGlobal:getCurrent():getCurrentCharacter():getType() == 0) then
        local count = 0

        local listCD = self:getMyHero().m_tSkillCdList
        local list = WBattleGlobal:getCurrent().m_tMySkill_Beginning.id
        list[8] = 62
        list[7] = WBattleGlobal.getCurrent().m_nAwakeSkillId

        WZLog("WndBattleHud:updateMySkillCtb zero", Serialize(list))
		for i,v in pairs(list) do
            count = count + 1
			local pos = self:getMySkillPos(v)
            local cd = listCD[v]
            local skill = WBattleGlobal:getCurrent():getSkillById(v)
			if pos and skill then

				local prog,txtProg = WndBattleHud:getSkillClipCell(pos)
				local progAction = WZUIActionProgressFromTo:create()
				
                local coolSkillTime = 0
                if skill.isNoFirst == nil then
                    coolSkillTime = WBattleGlobal:getCurrent():getSkillById(v).startCoolSkillTime
                else
                    coolSkillTime = WBattleGlobal:getCurrent():getSkillById(v).coolSkillTime
                end

				local nowSkillTime = cd and (cd -  BattleCtbManager.m_nUpdateCTB_time) or 0
				nowSkillTime = nowSkillTime
				local nowPer = (coolSkillTime == 0 or nowSkillTime <= 0) and 0 or nowSkillTime/coolSkillTime * 100

                WZLog("WndBattleHud:updateMySkillCtb one-00", pos,cd,coolSkillTime,BattleCtbManager.m_nUpdateCTB_time,nowSkillTime, nowPer, prog:getPercentage())

                if nowPer > 0 then
                    local tempElement
                    if pos ~= -1 then
                        tempElement = self:getSkillCell(pos)
                        local img = WZUIImage:luaTo(tempElement)
                        if img then
                            img:setColor(GlobalMethod:ccc3(100,100,100))
                            img:setTouchEnable(false)
                        end
                    else
                        tempElement = GetElement(self.m_root,"imgFly_WndBattleHud",WZUIImage)
                        local img = WZUIImage:luaTo(tempElement)
                        if img then
                            img:setColor(GlobalMethod:ccc3(100,100,100))
                            img:setTouchEnable(false)
                        end
                    end
                end

				local duration = BattleCtbManager.m_nUpdateCTB_time / BattleCtbManager.SECOND_PER_CTB
				progAction:setFromPercent(prog:getPercentage())
				progAction:setToPercent(nowPer)
				progAction:setDuration( duration )
				progAction:setFinishLuaFunction("updateSkillClipCallBack")
				progAction:setFinishLuaTable(self)
				prog:stopAllActions()
				prog:runUIAction(progAction)
			end
		end
	end
end

function WndBattleHud:updateMySkillCtbAudience()
    if self:getMyHero() or (WBattleGlobal:getCurrent():isAudience() and WBattleGlobal:getCurrent():getCurrentCharacter():getType() == 0) then
        local count = 0

        local list = self:getMyHero().m_tSkillCdList

        if WBattleGlobal:getCurrent():isAudience() and WBattleGlobal:getCurrent():getCurrentCharacter() then
            list = WBattleGlobal:getCurrent():getCurrentCharacter().m_tSkillCdList
        end

        if list == nil then
            list = WBattleGlobal:getCurrent().m_tMySkill_Beginning
        end

        WZLog("WndBattleHud:updateMySkillCtbAudience zero", Serialize(list))
        for i,v in pairs(list) do
            count = count + 1
            local pos = self:getMySkillPos(i)
            if pos then

                local prog,txtProg = WndBattleHud:getSkillClipCell(pos)
                local progAction = WZUIActionProgressFromTo:create()
                local skill = WBattleGlobal:getCurrent():getSkillById(i)
                local coolSkillTime = 0
                if skill.isNoFirst == nil then
                    coolSkillTime = WBattleGlobal:getCurrent():getSkillById(i).startCoolSkillTime
                else
                    coolSkillTime = WBattleGlobal:getCurrent():getSkillById(i).coolSkillTime
                end

                local nowSkillTime = v
                nowSkillTime = nowSkillTime
                local nowPer = (nowSkillTime <= 0) and 0 or (nowSkillTime/coolSkillTime * 100)

                local tempElement
                if pos ~= -1 then
                    tempElement = self:getSkillCell(pos)
                else
                    tempElement = GetElement(self.m_root,"imgFly_WndBattleHud",WZUIImage)
                end
                local img = WZUIImage:luaTo(tempElement)
                WZLog("WndBattleHud:updateMySkillCtbAudience one-00",pos,v,coolSkillTime,BattleCtbManager.m_nUpdateCTB_time,
                    nowSkillTime, "nowPer:", nowPer, prog:getPercentage(), tostring(img))

                if nowPer > 0 then
                    if img then
                        img:setColor(GlobalMethod:ccc3(100,100,100))
                        img:setTouchEnable(false)
                    --    WZLog("WndBattleHudWndBattleHud 5555555555555")
                        --WZLog("WndBattleHud:updateMySkillCtb two",i,pos)
                    end
                    prog:setPercentage(nowPer)
                else
                    prog:setPercentage(0)
                end
            end
        end
    end
end

function WndBattleHud:updateMyItemCtb()
    if self:getMyHero() or (WBattleGlobal:getCurrent():isAudience() and WBattleGlobal:getCurrent():getCurrentCharacter():getType() == 0) then
        local count = 0

        local listCD = self:getMyHero().m_tItemCdList
        local list = WBattleGlobal:getCurrent().m_tMyProp_Beginning.id

        WZLog("WndBattleHud:updateMyItemCtb zero", Serialize(list))
        for i,v in pairs(list) do
            count = count + 1
            local pos = self:getMyItemPos(v)
            local cd = listCD[v]
            local skill = WBattleGlobal:getCurrent():getItemById(v)
            if pos and skill then

                local prog = WndBattleHud:getItemClipCell(pos)
                local progAction = WZUIActionProgressFromTo:create()
                
                local coolSkillTime = WBattleGlobal:getCurrent():getItemById(v).startCoolSkillTime

                local nowSkillTime = cd and (cd -  BattleCtbManager.m_nUpdateCTB_time) or 0
                nowSkillTime = nowSkillTime
                local nowPer = (coolSkillTime == 0 or nowSkillTime <= 0) and 0 or nowSkillTime/coolSkillTime * 100

                WZLog("WndBattleHud:updateMyItemCtb one-00", pos,cd,coolSkillTime,BattleCtbManager.m_nUpdateCTB_time,nowSkillTime, nowPer, prog:getPercentage())

                if nowPer > 0 then
                    local tempElement = self:getItemCell(pos)
                    local img = WZUIImage:luaTo(tempElement)
                    if img then
                        img:setColor(GlobalMethod:ccc3(100,100,100))
                        img:setTouchEnable(false)
                    --    WZLog("ItemItemItemItem 5555555555555")
                        --WZLog("WndBattleHud:updateMySkillCtb two",i,pos)
                    end
                end

                local duration = BattleCtbManager.m_nUpdateCTB_time / BattleCtbManager.SECOND_PER_CTB
                progAction:setFromPercent(prog:getPercentage())
                progAction:setToPercent(nowPer)
                progAction:setDuration( duration )
                progAction:setFinishLuaFunction("updateItemClipCallBack")
                progAction:setFinishLuaTable(self)
                prog:stopAllActions()
                prog:runUIAction(progAction)
            end
        end
    end
end

--newUI
function WndBattleHud:showNewTip(tString)
	if tString == LocalStrings.BATTLE_NOT_MY_TURN then
		local con = self.m_root:getChildElement("conNewTip_WndBattleHud")
        con:setVisible(true)
		con:stopAllActions()
		con:setScale(0)
		local actionSeq = WZUIActionSequence:create()
		local action1 = WZUIActionScaleTo:create()
		action1:setDuration(0.2)
		action1:setScaleX(1)
		action1:setScaleY(1)
		local action2 = WZUIActionDelayTime:create()
		action2:setDuration(0.6)
		local action3 = WZUIActionScaleTo:create()
		action3:setDuration(0.2)
		action3:setScaleX(0)
		action3:setScaleY(0)
		actionSeq:setChildAction(action1)
		actionSeq:setChildAction(action2)
		actionSeq:setChildAction(action3)
		con:runUIAction(actionSeq)
	end
end
------Face

--@brief    Face按钮点击后的Lua回调
--@param    sender:Face元素
--@note
function WndBattleHud:onFace(sender)
    if TeachGroup1.ISBATTLE == true then
        return
    end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self:changeFaceShow()
end

--@brief    FaceBg图片点击后的Lua回调
--@param    sender:FaceBg图片
--@note
function WndBattleHud:onFaceBg(sender)
	self:changeFaceShow()
end

--@brief    表情界面显示隐藏转换
--@param    bShow:表示指定是否显示，若不填则转换成相反的状态
function WndBattleHud:changeFaceShow(bShow)
	local bg = GetElement(self.m_root,"imgFaceBg_WndBattleHud")
	local faceBox = GetElement(self.m_root,"conFaceBox_WndBattleHud")
    local faceBoxTxt = GetElement(self.m_root,"txtFace_WndBattleHud")
    local freeTable = GetElement(self.m_root,"freeTable_WndBattleHud",WZUITableContainer)
    local faceBoxContainer = GetElement(self.m_root,"faceBoxContainer_WndBattleHud",WZUIContainer)
	faceBox:stopAllActions()

	local scale = WZUIActionScaleTo:create()
	scale:setDuration(0.15)
	scale:setRateType("SineIn")

	if bg:isVisible() then
		scale:setScaleX(0)
		scale:setScaleY(0)
        faceBoxContainer:setTouchSwallow(false)
	else
		scale:setScaleX(1)
		scale:setScaleY(1)
		faceBox:setVisible(true)
        freeTable:setVisible(true)
        faceBoxTxt:setVisible(true)
        faceBoxContainer:setTouchSwallow(true)
	end

	bg:setVisible(not bg:isVisible())
	faceBox:runUIAction(scale)
end

--@brief    表情按钮点击后的Lua回调
--@param    sender:表情按钮
--@note
function WndBattleHud:onSelFace(index)
    self:changeFaceShow()
	local faceId = tonumber(index)
    if g_nTeamTalkLimit == nil or g_nTeamTalkLimit == 0 then 
	   self.m_tMyHero:playFaceAnimation(faceId)
    end

	local heroId = self.m_tMyHero:getBattleId()
	local battleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
	ProtocolProcessorBattleInterface:send_BATTLE_UsingFace(battleId, heroId, faceId )
end

------语音聊天
--@brief    加入语音聊天室
function WndBattleHud:joinVoice()
    if self.m_bIsTryJoinVoice ~= true then
        GlobalGame.m_sVoiceRoomName = "battle_" .. WBattleGlobal:getCurrent().m_tMakePairOk.battleId .. "_" .. WBattleGlobal:getCurrent():getMyHero():getCamp()
        local isOk =  WGCloudVoiceNotify:JoinTeamRoom(GlobalGame.m_sVoiceRoomName)
        WZLog("WndBattleHud:joinVoice", GlobalGame.m_sVoiceRoomName, isOk, type(isOk))
        if isOk ~= 0 then
            self.m_bIsTryJoinVoice = true
            local call=CCCallFunc:create(function() 
                        self.m_bIsTryJoinVoice = false
                        self:joinVoice()
                    end)
            local delay =  CCDelayTime:create(0.2)
            local array = CCArray:create()
            array:addObject(delay)
            array:addObject(call)
            self.m_root:runAction(CCSequence:create(array))
        else
            self.m_bIsVoiceState = true
            self.m_bIsTryJoinVoice = false
        end
    end
end

--@brief    离开语音聊天室
function WndBattleHud:quitVoice()
    WZLog("WndBattleHud:quitVoice", GlobalGame.m_sVoiceRoomName)
    if GlobalGame.m_sVoiceRoomName == nil then return end
    WGCloudVoiceNotify:QuitRoom(GlobalGame.m_sVoiceRoomName)
    GlobalGame.m_sVoiceRoomName = nil
    GlobalGame.m_nVoiceId = nil
end

--@brief    语音聊天室成员状态回调
--0 停止说话
--1 开始说话
--2 继续说话
function WndBattleHud:voiceMemberState(state)
    WZLog("WndBattleHud:voiceMemberState one", Serialize(state))
    for j=1,state.count do
        for i,v in pairs(WBattleGlobal:getCurrent():getHeroList()) do
            local ctb = v.m_tCtb
            local offset = (j-1) * 2
            WZLog("WndBattleHud:voiceMemberState two", j, offset)
            if ctb.m_nVoiceId == state.members[1 + offset] and ctb.m_bIsVoice == true and ctb.m_nMicState == 1 then
                WZLog("WndBattleHud:voiceMemberState three", state.members[2 + offset])
                local anim = GetElement(ctb.m_root,"animFigureVoice_CellBattleCtb",WZUISpine)
                local img = GetElement(ctb.m_root,"imgFigureVoice_CellBattleCtb",WZUIImage)
                local file
                local isGray
                if state.members[2 + offset] == 0 then
                    -- if ctb.m_nVoiceState == 0 then
                    --     file = "ui/common/common_icon_yuying_02.png"
                    --     isGray = true
                    -- elseif ctb.m_nMicState == 1 then
                    --     file = "ui/common/common_icon_yuying02.png"
                    --     isGray = false
                    -- elseif ctb.m_nVoiceState == 1 then
                    --     file = "ui/common/common_icon_yuying_02.png"
                    --     isGray = false
                    -- end
                    img:setVisible(true)
                    anim:setVisible(false)
                elseif state.members[2 + offset] == 1 or state.members[2 + offset] == 2 then
                    -- file = "ui/common/common_icon_yuying02_sel.png"
                    -- WZLog("WndBattleHud:voiceMemberState four_2")
                    -- isGray = false
                    img:setVisible(false)
                    anim:setVisible(true)
                end
                -- img:setFile(file)
                -- img:setGrayRender(isGray)
                break
            end
        end
    end
end

--@brief    语音聊天室屏蔽某人
function WndBattleHud:forbidMemberVoice(id, isVoice, playerId)
    WZLog("WndBattleHud:forbidMemberVoice", id, isVoice)
    if id ~= -1 then
        WGCloudVoiceNotify:ForbidMemberVoice(id,isVoice)
        for i,v in pairs(WBattleGlobal:getCurrent():getHeroList()) do
            local ctb = v.m_tCtb
            if ctb.m_nVoiceId == id then
                ctb.m_bIsVoice = isVoice
                local img = GetElement(ctb.m_root,"imgFigureNoVoice_CellBattleCtb",WZUIImage)
                img:setVisible(not isVoice)
                if isVoice == false then
                    local img = GetElement(ctb.m_root,"imgFigureVoice_CellBattleCtb",WZUIImage)
                    img:setFile("ui/common/common_icon_yuying_02.png")
                    img:setGrayRender(true)
                end
            end
        end
    else
        table.insert(self.m_tForbidMembers, {playerId=playerId,isVoice=isVoice})

        for i,v in pairs(WBattleGlobal:getCurrent():getHeroList()) do
            if v:getBattleId() == playerId then
                local ctb = v.m_tCtb
                ctb.m_bIsVoice = isVoice
                local img = GetElement(ctb.m_root,"imgFigureNoVoice_CellBattleCtb",WZUIImage)
                img:setVisible(not isVoice)
                if isVoice == false then
                    local img = GetElement(ctb.m_root,"imgFigureVoice_CellBattleCtb",WZUIImage)
                    img:setFile("ui/common/common_icon_yuying_02.png")
                    img:setGrayRender(true)
                end
            end
        end
    end
end

--@brief    开启语音按钮定时器
function WndBattleHud:openVoiceTimer()
    self.m_nVoiceTimer = 0.7
    local call=CCCallFunc:create(function() 
                self:closeVoiceTimer()
            end)
    local delay =  CCDelayTime:create(self.m_nVoiceTimer)
    local array = CCArray:create()
    array:addObject(delay)
    array:addObject(call)
    self.m_root:runAction(CCSequence:create(array))
end

--@brief    关闭语音按钮定时器
function WndBattleHud:closeVoiceTimer()
    self.m_nVoiceTimer = 0
end

--@brief    听筒按钮点击后的Lua回调
function WndBattleHud:onClickSpeaker(sender, state, isNoSend)
    if TeachGroup1.ISBATTLE == true then
        return
    end

    if GetPlayTalk() == 1 then
        MsgBoxManager:showConfirmCancelBox(LocalStrings.VOICE_OPENSTR or "", self, self.onClickSpeakerCall, nil)
        return
    end

    if not WGCloudVoiceNotify:IsSupportVoice() then
        MsgBoxManager:showTipBox(LocalStrings.VOICE_NOSUPPORT or "")
        return
    end

    if self.m_nVoiceTimer > 0 and sender then
        MsgBoxManager:showTipBox(LocalStrings.VOICE_CLICKMORE or "")
        return
    end

    if sender then
        self:openVoiceTimer()
    end
	--SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("WndBattleHud:onClickSpeaker", self.m_nSpeakerState, state)
    if state then
        if state ~= self.m_nSpeakerState then
            return
        end
        self.m_nSpeakerState = state
    end
    if self.m_nSpeakerState == 0 then
        WGCloudVoiceNotify:OpenSpeaker()
        GetElement(self.m_root,"imgSpeaker1_WndBattleHud",WZUIImage):setGrayRender(false)
        GetElement(self.m_root,"imgSpeaker2_WndBattleHud",WZUIImage):setGrayRender(false)
    else
        WGCloudVoiceNotify:CloseSpeaker()
        GetElement(self.m_root,"imgSpeaker1_WndBattleHud",WZUIImage):setGrayRender(true)
        GetElement(self.m_root,"imgSpeaker2_WndBattleHud",WZUIImage):setGrayRender(true)
    end

    if self.m_nSpeakerState == 1 then
        self:onClickMic(nil, 1, true)
    end
    self.m_nSpeakerState = 1 - self.m_nSpeakerState

    if self.m_bIsVoiceState == false then
        self:joinVoice()
    elseif isNoSend == nil then
        ProtocolProcessorGlobal:send_CHAT_SendMessage(CHANNEL_TEAM, 8, "2," .. self.m_nSpeakerState, 0 )
    end
end

function WndBattleHud:onClickSpeakerCall(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        local data = WZDataFile:getInstance():getUserData()
        if data then        
            data:setStringValue("TalkData", "playTalk", "0")
            data:flush()
        end
        self:onClickSpeaker(true)
    end
end

function WndBattleHud:onClickMicCall(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        local data = WZDataFile:getInstance():getUserData()
        if data then        
            data:setStringValue("TalkData", "playTalk", "0")
            data:flush()
        end
        self:onClickMic(true)
    end
end

--@brief    麦克风按钮点击后的Lua回调
function WndBattleHud:onClickMic(sender, state, isNoSend)
    if TeachGroup1.ISBATTLE == true then
        return
    end

    if GetPlayTalk() == 1 then
        MsgBoxManager:showConfirmCancelBox(LocalStrings.VOICE_OPENSTR or "", self, self.onClickMicCall, nil)
        return
    end

    if not WGCloudVoiceNotify:IsSupportVoice() then
        MsgBoxManager:showTipBox(LocalStrings.VOICE_NOSUPPORT or "")
        return
    end

    if self.m_nVoiceTimer > 0 and sender then
        MsgBoxManager:showTipBox(LocalStrings.VOICE_CLICKMORE or "")
        return
    end

    if sender then
        self:openVoiceTimer()
    end
    --SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("WndBattleHud:onClickMic one", self.m_nMicState)
    
    if state then
        if state ~= self.m_nMicState then
            return
        end
        self.m_nMicState = state
    end

    if self.m_nMicState == 0 then
        WGCloudVoiceNotify:OpenMic()
        GetElement(self.m_root,"imgMic1_WndBattleHud",WZUIImage):setGrayRender(false)
        GetElement(self.m_root,"imgMic2_WndBattleHud",WZUIImage):setGrayRender(false)
    else
        WGCloudVoiceNotify:CloseMic()
        GetElement(self.m_root,"imgMic1_WndBattleHud",WZUIImage):setGrayRender(true)
        GetElement(self.m_root,"imgMic2_WndBattleHud",WZUIImage):setGrayRender(true)
    end
    
    if self.m_nMicState == 0 then
        self:onClickSpeaker(nil, 0, true)
    end

    if self.m_nMicState == 1 then
        WZLog("WndBattleHud:onClickMic two")
        --self:onClickSpeaker(nil, 1 - self.m_nSpeakerState)
        local call=CCCallFunc:create(function() 
                self:onClickSpeaker(nil, 1 - self.m_nSpeakerState)
            end)
        local delay =  CCDelayTime:create(1)
        local array = CCArray:create()
        array:addObject(delay)
        array:addObject(call)
        self.m_root:runAction(CCSequence:create(array))
    end
    self.m_nMicState = 1 - self.m_nMicState

    if self.m_bIsVoiceState == false then
        self:joinVoice()
    elseif isNoSend == nil then
        ProtocolProcessorGlobal:send_CHAT_SendMessage(CHANNEL_TEAM, 8, "3," .. self.m_nMicState, 0 )
    end
end

--@brief    检查是否可以语音
function WndBattleHud:checkVoice()
    local isVoice = false
    
    WZLog("WndBattleHud:checkVoice")
    if self:checkVoiceChannelLv() then
        isVoice = true
    end
    self.m_bIsVoice = isVoice

    local btnTalkLimit = GetElement(self.m_root, "btnTalkLimit_WndBattleHud", WZUIButton)
    if isVoice then
        btnTalkLimit:setRelativePosition(GlobalMethod:ccp(0.0293,0.26))
    else
        GetElement(self.m_root,"btnSpeaker_WndBattleHud",WZUIButton):setVisible(false)
        GetElement(self.m_root,"btnMic_WndBattleHud",WZUIButton):setVisible(false)
    end
end

--@brief    检查语音渠道和等级
function WndBattleHud:checkVoiceChannelLv()
    local isShow = false
    local types = WBattleGlobal:getCurrent().m_nBattleType
    local mode = WBattleGlobal:getCurrent().battleMode
    local battleMode = WBattleGlobal:getCurrent().m_tMakePairOk.battleMode
    local isSingle = WBattleGlobal:getCurrent():isSingleStage()
    local channel = WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle

    WZLog("WndBattleHud:checkVoiceChannelLv", types, mode, battleMode, channel, isSingle, CheckTalkButtonShow(3), CheckTalkButtonShow(15), CheckTalkButtonShow(17))
    if types == BattleConstants.g_nBATTLE_TYPE_NORMAL then
        if channel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_PW and CheckTalkButtonShow(13) then
            isShow = true
        elseif channel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_DZ and battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_JJ and CheckTalkButtonShow(3) then
            isShow = true
        elseif channel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL and battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_DJ and CheckTalkButtonShow(5) then
            isShow = true
        elseif channel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL and battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_WK and CheckTalkButtonShow(7) then
            isShow = true
        elseif channel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL and battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_FH and CheckTalkButtonShow(9) then
            isShow = true
        elseif channel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL and battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_DZ and CheckTalkButtonShow(11) then
            isShow = true
        elseif channel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_LS and CheckTalkButtonShow(15) then
            isShow = true
        elseif channel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_GZ and CheckTalkButtonShow(17) then
            isShow = true
        end
    elseif types == BattleConstants.g_nBATTLE_TYPE_BOSS then
        if isSingle ~= true and (mode == BattleConstants.g_tBossBattleMode.MODE_NORMAL or 
            mode == BattleConstants.g_tBossBattleMode.MODE_BOSSMAP_1 or mode == BattleConstants.g_tBossBattleMode.MODE_BOSSMAP_2) and 
            CheckTalkButtonShow(1) then
            isShow = true
        end
    end
    isShow = isShow
    return isShow
end

--@brief    Chat按钮点击后的Lua回调
--@param    sender:Chat元素
--@note
function WndBattleHud:onChat(sender)
    if TeachGroup1.ISBATTLE == true then
        return
    end

    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndCurrentChat:wndCurChatVisible(false)
    WndChat:showChatWindowForFightingByOrder(nil)
end

function WndBattleHud:setScaleData()
    local data = WZDataFile:getInstance():getUserData()
    if data then        
        data:setStringValue("HudData", "scale", WBattleGlobal:getCurrent().m_nScale)
        data:flush()
    end
end

--@brief    获取放大倍数
function WndBattleHud:getScaleData()
     local data = WZDataFile:getInstance():getUserData()
     if data ~=  nil then
        local playTalk = data:getStringValue("HudData", "scale")
        if playTalk ~= nil and playTalk ~= "" then
            if playTalk == "0" then
                return 0
            end
        end
    end
    return 1
end

--@brief    scale按钮点击后的Lua回调
--@param    sender:scale元素
--@note
function WndBattleHud:onScale(sender, parm, parm2, scale, must)
    
    --WBattleGlobal:getCurrent():doMapErosion()

    if (TeachGroup1.ISBATTLE == true and must == nil) or WBattleGlobal:getCurrent().m_tTouchCircle == nil then
        return
    end

    scale = scale or WBattleGlobal:getCurrent().m_nScale

    WZLog("WndBattleHud:onScale one", scale, SceneBattle:getFrontLayer():getScale())
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if scale == 0 then
        WBattleGlobal:getCurrent().m_nScale = scale + 1
    elseif parm and scale == 2 then   
        WBattleGlobal:getCurrent().m_nScale = 2
    elseif parm2 and scale == 1 then   
        WBattleGlobal:getCurrent().m_nScale = 1
    else
        WBattleGlobal:getCurrent().m_nScale = 0
    end
    self:setScaleData()
    self:updateScaleBtnShow()
    


    local scalef = SceneBattle:getFrontLayer():getScale()
    local scaleMonsterMode = 1
    if WBattleGlobal:getCurrent().m_tMakePairOk.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_GS and WBattleGlobal:getCurrent():getMyHero().m_nCamp == 1 then
        scaleMonsterMode = 2
    end
    if WBattleGlobal:getCurrent().m_nScale == 0 then
        WBattleGlobal:getCurrent().m_tTouchCircle:setScale(
        (300 + BattleConstants.g_nTouchDistance * 2 * WBattleGlobal:getCurrent().m_nScale)/680 / 2.5 / 0.6 * scalef/scaleMonsterMode)
    elseif WBattleGlobal:getCurrent().m_nScale == 1 then
        WBattleGlobal:getCurrent().m_tTouchCircle:setScale(
        (300 + BattleConstants.g_nTouchDistance * 2 * WBattleGlobal:getCurrent().m_nScale)/680 / 3.3 / 0.6 * scalef/scaleMonsterMode)
    elseif WBattleGlobal:getCurrent().m_nScale == 2 then
        WBattleGlobal:getCurrent().m_tTouchCircle:setScale(
        (300 + BattleConstants.g_nTouchDistance * 2 * WBattleGlobal:getCurrent().m_nScale)/680 / 3.3 / 0.6 * scalef/scaleMonsterMode)
    end

    if WBattleGlobal:getCurrent().m_nScale == 1 then
        WBattleGlobal:getCurrent().m_tTouchCircle:getAnimNode():setOpacity(150)
        WBattleGlobal:getCurrent().m_tTouchCircle:getAnimNode():setRelativePositionLuaTo(0.5,0.7)
    else
        WBattleGlobal:getCurrent().m_tTouchCircle:getAnimNode():setOpacity(255)
        WBattleGlobal:getCurrent().m_tTouchCircle:getAnimNode():setRelativePositionLuaTo(0.5,0.7)
    end
end

function WndBattleHud:updateScaleBtnShow()
    if not self.m_root then
        return
    end
    local scale = WBattleGlobal:getCurrent().m_nScale

    WZLog("WndBattleHud:onScale one", scale, SceneBattle:getFrontLayer():getScale())
    local name = "battle_icon_fangda"
    if scale == 1 then
        name = "battle_icon_suoxiao"
    elseif scale == 2 then 
        name = "battle_icon_suoxiao"
    --[[
    elseif scale == 1 then
        WBattleGlobal:getCurrent().m_nScale = scale + 1
        name = "3"
    --]]
    else
        name = "battle_icon_fangda"
    end

    

    local btn = GetElement(self.m_root,"btnScale_WndBattleHud",WZUIButton)

    local icon = WZUIImage:create()
    icon:setUseOriginSize(true)
    icon:setFile("ui/combat/optimize/"..name..".png")

    btn:setNormalElement(icon)

    icon = WZUIImage:create()
    icon:setUseOriginSize(true)
    icon:setFile("ui/combat/optimize/"..name..".png")
    btn:setSelectElement(icon)

    local scalef = SceneBattle:getFrontLayer():getScale()
    local scaleMonsterMode = 1
    if WBattleGlobal:getCurrent().m_tMakePairOk.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_GS and WBattleGlobal:getCurrent():getMyHero().m_nCamp == 1 then
        scaleMonsterMode = 2
    end
    if WBattleGlobal:getCurrent():isFog() then
        if WBattleGlobal:getCurrent().m_nScale == 0 then
            WBattleGlobal:getCurrent().m_tTouchCircle:setScale(
            (300 + BattleConstants.g_nTouchDistance * 2 * WBattleGlobal:getCurrent().m_nScale)/680 / 2.5 / 0.6 * scalef/scaleMonsterMode)
        elseif WBattleGlobal:getCurrent().m_nScale == 1 then
            WBattleGlobal:getCurrent().m_tTouchCircle:setScale(
            (300 + BattleConstants.g_nTouchDistance * 2 * WBattleGlobal:getCurrent().m_nScale)/680 / 3.3 / 0.6 * scalef/scaleMonsterMode)
        end
    else
        WBattleGlobal:getCurrent().m_tTouchCircle:setScale((300 + BattleConstants.g_nTouchDistance * 2 * WBattleGlobal:getCurrent().m_nScale)/680/scaleMonsterMode)
    end

    if WBattleGlobal:getCurrent().m_nScale == 1 then
        WBattleGlobal:getCurrent().m_tTouchCircle:getAnimNode():setOpacity(150)
        WBattleGlobal:getCurrent().m_tTouchCircle:getAnimNode():setRelativePositionLuaTo(0.5,0.7)
    else
        WBattleGlobal:getCurrent().m_tTouchCircle:getAnimNode():setOpacity(255)
        WBattleGlobal:getCurrent().m_tTouchCircle:getAnimNode():setRelativePositionLuaTo(0.5,0.7)
    end
end

--@brief    Setting按钮点击后的Lua回调
--@param    sender:Setting元素
--@note
function WndBattleHud:onSetting(sender)
    WZLog("WndBattleHud:onSetting", WBattleGlobal:getCurrent():isCopyTeach(), TeachGroup1.ISBATTLE)
    if TeachGroup1.ISBATTLE ~= true and WBattleGlobal:getCurrent():isCopyTeach() ~= true and WBattleGlobal:getCurrent():isGameOver() == false and WndBattleSetting.m_root == nil and CacheCenter:getPlayerInfo().level >= 3 then
        SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

		local setting = WndBattleSetting:createElement()
		setting:setZOrder(100)
		WindowManager:addWindow(setting, WndBattleSetting)
	end
end

--@brief    hud按钮透明化的处理
--@param    isNeedIntervalDo 是否需要间隔5桢执行
--@return
--@note
function WndBattleHud:setHudBtnOpacity(isNeedIntervalDo)
    do return end
	if self.m_root == nil then
		return
	end
	if isNeedIntervalDo and self.m_setHudOpacityTimes < 5 then
		self.m_setHudOpacityTimes = self.m_setHudOpacityTimes + 1
		return
	else
		self.m_setHudOpacityTimes = 0
	end

	local btnNames = {}
	table.insert(btnNames,"btnSetting_WndBattleHud")
	table.insert(btnNames,"btnPassTurn_WndBattleHud")
	--table.insert(btnNames,"btnChat_WndBattleHud")
	table.insert(btnNames,"btnMyHudSwitch_WndBattleHud")
	table.insert(btnNames,"btnFace_WndBattleHud")
	local txtNames = {}
	table.insert(txtNames,"txtTurnTime_WndBattleHud")
	local conNames = {}
	table.insert(conNames,"conWind_WndBattleHud")



	for i,btnName in ipairs(btnNames) do
		local btnNeedOpacity = GetElement(self.m_root,btnName,WZUIButton)
		if self:_checkNeedToOpacity(btnNeedOpacity) then
			self:_setContainerOpacity(btnNeedOpacity,60)
		else
			self:_setContainerOpacity(btnNeedOpacity,255)
		end
	end




	for i,conName in ipairs(conNames) do
		local conNeedOpacity = GetElement(self.m_root,conName,WZUIContainer)
		if self:_checkNeedToOpacity(conNeedOpacity) then
			self:_setContainerOpacity(conNeedOpacity,60)
		else
			self:_setContainerOpacity(conNeedOpacity,255)
		end
	end




	for i,txtName in ipairs(txtNames) do
		local txtNeedOpacity = WZUILabelAtlasFont:luaTo(GetElement(self.m_root,txtName))
		local nTime = math.ceil(self.m_nTurnTime)
		if nTime > 3 and self:_checkNeedToOpacity(txtNeedOpacity) then
			txtNeedOpacity:setOpacity(60)
		else
			txtNeedOpacity:setOpacity(255)
		end
	end


    --大招按钮自己回合不做隐藏
	if (self.m_tMyHero == nil or self.m_tMyHero:getBattleId() ~= WBattleGlobal:getCurrent():getCurrentCharacterId()) and self:_checkNeedToOpacity(self:getBigSkillContainer()) then
		self:_setContainerOpacity(self:getBigSkillContainer(),60)
	else
		self:_setContainerOpacity(self:getBigSkillContainer(),255)
	end

end



--@brief    hud按钮透明化
--@param
function WndBattleHud:_setContainerOpacity(tSender,opacity)
	--WZLog("WndBattleHud:_setContainerOpacity(tSender,opacity)")

	if tSender then
		if tolua.type(tSender) == "cwSngSprite" then
			local tSprite = tolua.cast(tSender,"cwSngSprite")
			if  tSprite:getOpacity()~= opacity then
				tSprite:setOpacity(opacity)
			end
			return
		end

		if WZUIElementHandle:luaTo(tSender) == nil then

			local ccArray = tSender:getChildren()
			if ccArray and ccArray:count() > 0 then
				for i=0,ccArray:count()-1 do
					self:_setContainerOpacity(tolua.cast(ccArray:objectAtIndex(i),"CCNode"),opacity)
				end
			end
		else
			local tElement = WZUIElementHandle:luaTo(tSender)
			if tElement:getOpacity() ~= opacity then
				tElement:setOpacity(opacity)
			end
		end
	end
end

--@brief    判断是否需要透明化
--@param
function WndBattleHud:_checkNeedToOpacity(tSender)
	--WZLog("WndBattleHud:_checkNeedToOpacity(tSender)",tSender:getName())
	-- local rect = self:_getSenderRect(tSender)
	local isNeedOpacity = false

    ---判断是否跟角色重叠

	local rectInHeroLayer = nil
    for i,hero in pairs(WBattleGlobal:getCurrent():getHeroList()) do
		if not hero:isHide() or WBattleGlobal:getCurrent():isMyTeam(hero:getBattleId()) then
			if rectInHeroLayer == nil then
				rectInHeroLayer = self:_getSenderRect(tSender,hero:getAnimation():getAnimNode())
			end

			local heroPos = hero:getPosition()
			local heroRadius = hero:getRadiusForHurt()/(0.7)

			local circle = {x = heroPos.x,y=heroPos.y + 30,r = heroRadius}
			if BattleCommon:rectCircleOverLap(rectInHeroLayer,circle) then
				isNeedOpacity = true
				break
			end
		end
    end
    -------判断是否跟瞄准线重叠
    local rectInPointsLineLayer = nil
	local pointsLine = SceneBattle:getBattlePointsLine()
	if pointsLine.m_uBatchNode:isVisible() then
		for i = 1, #pointsLine.m_tPoints do

			local ccs = pointsLine.m_tPoints[i]
			if rectInPointsLineLayer == nil then
				rectInPointsLineLayer = self:_getSenderRect(tSender,ccs)
			end

			if ccs:isVisible() then
				local pointPos = {x = 0, y = 0}
				pointPos.x,pointPos.y = ccs:getPosition()
				if BattleCommon:pointInRect(pointPos,rectInPointsLineLayer) == true then
					isNeedOpacity = true
					break
				end
			end
		end
	end

    --WZLog("isNeedOpacity -->",isNeedOpacity)
    return isNeedOpacity;
end


--@brief    判断tsender 在 tCompareNode所在坐标系的坐标 rect
--@return   tSender在tCompareNode层上的正方形位置
function WndBattleHud:_getSenderRect(tSender,tCompareNode)
	-- WZLog("WndBattleHud:_getSenderRect(tSender)")

    if tCompareNode == nil then
        local rect = {x = 0,y = 0,w = 0,h=0}
        return rect
    end

	local senderPos = {x = 0, y = 0}
	senderPos.x,senderPos.y = tSender:getPosition()

	senderPos = tSender:getParent():convertToWorldSpaceAuto(CCAutoPoint:create(senderPos.x,senderPos.y))
	senderPos = tCompareNode:getParent():convertToNodeSpaceAuto(senderPos)

	local anchorPoint = tSender:getAnchorPoint()
	local size = tSender:getContentSize()
	local rectX = (senderPos.x - anchorPoint.x * size.width)
	local rectY = (senderPos.y - anchorPoint.y * size.height)
	local rect = {x = rectX,y = rectY,w = size.width,h=size.height}
	return rect
end

--@brief    点击觉醒技能按钮回调
function WndBattleHud:onAwakeSkillClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if WBattleGlobal:getCurrent():isGameOver() == true then
        return
    end

    local myHero = WBattleGlobal:getCurrent():getMyHero()
    if myHero and myHero:isDead() then 
        return 
    end

    --自动战斗不可操作提示
    if GlobalGame.g_bIsAutoFightOpen then 
        MsgBoxManager:showTipBox(LocalStrings.BATTLE_AUTOFIGHT_ATT)
        return 
    end

    --冷却技能不能用
    local spineAwakeSkill = GetElement(self.m_root, "spineAwakeSkill_WndBattleHud", WZUISpine)
    if not spineAwakeSkill:isVisible() then
        MsgBoxManager:showTipBox(LocalStrings.SKILL_COOL_TIME)
        return 
    end
    WZLog("WndBattleHud:onAwakeSkillClick 2", tostring(WBattleGlobal:getCurrent():isMyTurn()))
    local MAX_CTB = BattleCtbManager.MAX_CTB
    local nMyCtb = self.m_tMyHero:getNowCtb(self.m_tMyHero:getBattleId())
    WZLog("WndBattleHud:onAwakeSkillClick", nMyCtb)
    if nMyCtb >= MAX_CTB then 
        MsgBoxManager:showTipBox(LocalStrings.WAKEUP_TEXT43)
        return 
    end
    --ctb在走的时候不让点击
    if not WBattleGlobal:getCurrent().m_bIsCanUseAwakeSkill then
        MsgBoxManager:showTipBox(LocalStrings.WAKEUP_TEXT38)
        return 
    end

    --判断是否在发射状态或飞行状态使用觉醒技能
    self.m_bIsUseInShootOrFly = false
    if SceneBattle:getBattleLoop():getBattleStatus()==BattleLoop.S_PLAYER_SHOOT or SceneBattle:getBattleLoop():getBattleStatus()==BattleLoop.S_PLAYER_FLY then
        WndBattleHud:setUseAwakeSkillState(true)
    end

    if BattleHeroUse:heroUse(self.m_tMyHero:getBattleId(), BattleHeroUse.USE_CTB, WBattleGlobal.getCurrent().m_nAwakeSkillId) then
        local useId = WBattleGlobal.getCurrent().m_nAwakeSkillId
        local skill = CopyTable(GDatatab_skill["id_" .. useId])
        local effectData = CopyTable(GDatatab_effect["id_" .. skill.effect_id[1][1]])
        self.m_nUsePoint = self.m_nUsePoint - effectData.effect[1][5]/1000
        self.m_tMyHero.m_nUsePoint = self.m_tMyHero.m_nUsePoint - effectData.effect[1][5]
        if self.m_nUsePoint < 0 then 
            self.m_nUsePoint = 0 
            self.m_tMyHero.m_nUsePoint = 0
        end
        local isNoMyTurn = not WBattleGlobal:getCurrent():isMyTurn()
        self:resetSkill(isNoMyTurn)
        self:resetItem(isNoMyTurn)
        self:resetKMSkill(isNoMyTurn)
        self:useMySkill(WBattleGlobal.getCurrent().m_nAwakeSkillId)
    end
end

--@brief    设置觉醒技能百分比
--@param    nPercentage: 百分比
function WndBattleHud:updateAwakeSkillLevel()
    -- body
    --等级
    local txtAwakeSkillLevel = GetElement(self.m_root, "txtAwakeSkillLevel_WndBattleHud", WZUILabelTTF)
    if txtAwakeSkillLevel then
        txtAwakeSkillLevel:setText("L" .. self.m_nAwakeSkillLevel)
    end
end

function WndBattleHud:onKMSkillBegin(sender)
    WZLog("WndBattleHud:onKMSkillBegin")
    if WBattleGlobal:getCurrent():isGameOver() == true or (TeachGroup1.ISBATTLE and TeachGroup1.ISSKILL == nil) then
        return
    end
    if TeachGroup1.ISBATTLE == true then return end 

    self.m_nTouchBeginTime = WZThread:getUTickCount()
    self.m_nTouchIndex = sender:getTag()
    sender:enableSchedule("_caculatePressTimeKMSkill", 0)
end

function WndBattleHud:onSkillBegin(sender)
    WZLog("WndBattleHud:onSkillBegin")
    if WBattleGlobal:getCurrent():isGameOver() == true or (TeachGroup1.ISBATTLE and TeachGroup1.ISSKILL == nil) then
        return
    end
    if TeachGroup1.ISBATTLE == true then return end 

    self.m_nTouchBeginTime = WZThread:getUTickCount()
    self.m_nTouchIndex = sender:getTag()
    sender:enableSchedule("_caculatePressTimeSkill", 0)
end

function WndBattleHud:onItemBegin(sender)
    if WBattleGlobal:getCurrent():isGameOver() == true or TeachGroup1.ISBATTLE then
        return
    end
    if TeachGroup1.ISBATTLE == true then return end 

    self.m_nTouchBeginTime = WZThread:getUTickCount()
    self.m_nTouchIndex = sender:getTag()
    sender:enableSchedule("_caculatePressTime", 0)
end

function WndBattleHud:onGhostSkillBegin(sender)
    if WBattleGlobal:getCurrent():isGameOver() == true or TeachGroup1.ISBATTLE then
        return
    end
    if TeachGroup1.ISBATTLE == true then return end 

    WZLog("WndBattleHud:onGhostSkillBegin")
    self.m_nTouchBeginTime = WZThread:getUTickCount()
    self.m_nTouchIndex = sender:getTag()
    sender:enableSchedule("_caculatePressTimeGhostSkill", 0)
end

function WndBattleHud:onCoolKMSkillBegin(sender)
    if TeachGroup1.ISBATTLE == true then return end 

    self.m_nTouchBeginTime = WZThread:getUTickCount()
    self.m_nTouchIndex = sender:getTag()
    sender:enableSchedule("_caculatePressTimeKMSkill", 0)
end

function WndBattleHud:onCoolSkillBegin(sender)
    if TeachGroup1.ISBATTLE == true then return end 

    self.m_nTouchBeginTime = WZThread:getUTickCount()
    self.m_nTouchIndex = sender:getTag()
    sender:enableSchedule("_caculatePressTimeSkill", 0)
end

function WndBattleHud:onCoolItemBegin(sender)
    if TeachGroup1.ISBATTLE == true then return end 

    self.m_nTouchBeginTime = WZThread:getUTickCount()
    self.m_nTouchIndex = sender:getTag()
    sender:enableSchedule("_caculatePressTime", 0)
end

function WndBattleHud:onCoolGhostSkillBegin(sender)
    if TeachGroup1.ISBATTLE == true then return end 
    WZLog("WndBattleHud:onCoolGhostSkillBegin")

    self.m_nTouchBeginTime = WZThread:getUTickCount()
    self.m_nTouchIndex = sender:getTag()
    sender:enableSchedule("_caculatePressTimeGhostSkill", 0)
end

function WndBattleHud:onKMSkillOut(sender)
    sender:disableSchedule()
end

function WndBattleHud:onSkillOut(sender)
    sender:disableSchedule()
end

function WndBattleHud:onItemOut(sender)
    sender:disableSchedule()
end

function WndBattleHud:onGhostSkillOut(sender)
    WZLog("WndBattleHud:onGhostSkillOut")
    sender:disableSchedule()
end

function WndBattleHud:onCoolKMSkillOut(sender)
    sender:disableSchedule()
end

function WndBattleHud:onCoolSkillOut(sender)
    sender:disableSchedule()
end

function WndBattleHud:onCoolItemOut(sender)
    sender:disableSchedule()
end

function WndBattleHud:onCoolGhostSkillOut(sender)
    WZLog("WndBattleHud:onCoolGhostSkillOut")
    sender:disableSchedule()
end

--@brief    幽灵模式点击切换目标按钮回调
function WndBattleHud:onSwitchTarget(element)
    --body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if WBattleGlobal:getCurrent():isGameOver() == true or TeachGroup1.ISBATTLE then
        return
    end

    WZLog("WndBattleHud:onSwitchTarget")
    local nCount = 0 
    for i,hero in pairs(WBattleGlobal:getCurrent():getHeroList()) do
        if self.m_nGhostTargetId and self.m_nGhostTargetId == hero:getId() then
            hero:setTargetMark(false)
        end

        nCount = nCount + 1
    end

    local tHeroList = WBattleGlobal:getCurrent():getHeroList()
    local nIndex = 1 
    local tPlayerIds = WBattleGlobal:getCurrent().m_tMakePairOk.playerId

    local nTargetIndex = 0
    for i = 1, #tPlayerIds do
        if tPlayerIds[i] == self.m_nGhostTargetId then 
            nTargetIndex = i - 1
            break 
        end
    end

    while nIndex <= nCount do
        local nTempIndex = math.fmod(nTargetIndex + nIndex, nCount)
        local hero = WBattleGlobal:getCurrent():getHeroWithId(tPlayerIds[nTempIndex + 1])
        if hero and not hero.m_bIsDead and hero.m_nPlayerId ~= self.m_nGhostTargetId then 
            self.m_nGhostTargetId = hero:getId()
            hero:setTargetMark(true)
            self:_setGhostTargetName(hero)
            break 
        end
        nIndex = nIndex + 1
    end
end

--@brief    重置幽灵技能栏
--@note
function WndBattleHud:resetGhostSkill(bForceClose, isGet)
    WZLog("WndBattleHud:resetGhostSkill zero", isGet)
    local item = WBattleGlobal:getCurrent().m_tMyGhostSkill_Beginning

    local tempElement
    if item.count == nil then return end 

    for i = 1, item.count do
        tempElement, imgLv = self:getGhostSkillCell(i)
        if tempElement then
            if item.id[i] == nil or item.id[i] == 0 or self.m_tUseGhostSkill[i] <=0 then
                tempElement:setScale(1)
                tempElement:setVisible(false)
                imgLv = WZUIImage:luaTo(imgLv)
                imgLv:setFile("")
            else
                tempElement:setScale(1)
               
                --WZLog("WndBattleHud:resetGhostSkill one", point, self.m_nUsePoint, tostring(TeachGroup1.ISFIRSTBATTLE), tostring(self.m_tMyHero))
                WZLog("WndBattleHud:resetGhostSkill one", self.m_tUseGhostSkill[i])
                local x,y = 0.7,0.2
                if self.m_tUseGhostSkill[i]<=0 then
                    WZLog("WndBattleHud:resetGhostSkill two-1")
                    tempElement:setVisible(false)
                else
                    --new UI
                    WZLog("WndBattleHud:resetGhostSkill two-4-2", tostring(item.lv[i]) ~= "-1", item.icon[i], "item.lv[i]", item.lv[i])
                    local pngPath = item.icon[i]
                    local img = WZUIImage:luaTo(tempElement)
                    img:setColor(GlobalMethod:ccc3(255,255,255))
                    img:setFile(pngPath)
                    img:setVisible(true)
                    img:setTouchEnable(true)

                    if tostring(item.lv[i]) ~= "-1" then
                        imgLv:setFile(item.lv[i])
                    elseif tostring(item.lv[i]) == "-1" and img:getChildByTag(987) then
                        imgLv:setFile("")
                    end
                end
            end
        end
    end
end

--@brief    点击幽灵技能回调
function WndBattleHud:onGhostSkill(sender)
    -- body
    WZLog("WndBattleHud:onGhostSkill 22222")
    sender:disableSchedule()
    if WBattleGlobal:getCurrent():isGameOver() == true or TeachGroup1.ISBATTLE then
        return
    end

    WZLog("WndBattleHud:onGhostSkill 00000")

    local nTag = sender:getTag()

    local curTime = WZThread:getUTickCount()
    if not TeachGroup1.ISBATTLE and curTime - self.m_nTouchBeginTime >= 800000 then
        return 
    end

    if self.m_nGhostTargetId == nil then 
        MsgBoxManager:showTipBox(LocalStrings.GHOSTBATTLE_TEXT1)
        return 
    end
    --选中的目标已死
    for i,hero in pairs(WBattleGlobal:getCurrent():getHeroList()) do
        if hero.m_bIsDead and self.m_nGhostTargetId == hero.m_nPlayerId then 
            MsgBoxManager:showTipBox(LocalStrings.GHOSTBATTLE_TEXT4)
            return 
        end
    end
    local item = WBattleGlobal:getCurrent().m_tMyGhostSkill_Beginning
    if item.choose and item.choose[nTag] == 1 then --友方技能
        if self:_judgeCamp(self.m_nGhostTargetId) then 
            MsgBoxManager:showTipBox(LocalStrings.GHOSTBATTLE_TEXT2)
            return 
        end
    elseif item.choose and item.choose[nTag] == 2 then --敌方技能 
        if not self:_judgeCamp(self.m_nGhostTargetId) then 
            MsgBoxManager:showTipBox(LocalStrings.GHOSTBATTLE_TEXT3)
            return 
        end
    end
    -- if self.m_nGhostTargetId ~= WBattleGlobal:getCurrent():getCurrentCharacterId() then 
    --     MsgBoxManager:showTipBox(LocalStrings.GHOSTBATTLE_TEXT7)
    --     return 
    -- end
    

    WZLog("WndBattleHud:onGhostSkill")
    if sender then
        local index = sender:getTag()
        if item.id[index] > 0 then
            local originScale = 0.8
            --触摸动画部分
            local scale1 = WZUIActionScaleTo:create()
            scale1:setScaleX(0.7 * originScale)
            scale1:setScaleY(0.7 * originScale)
            scale1:setDuration(0.1)
            local scale2 = WZUIActionScaleTo:create()
            scale2:setScaleX(1 * originScale)
            scale2:setScaleY(1 * originScale)
            scale2:setDuration(0.1)
            local sequence = WZUIActionSequence:create()
            sequence:setChildAction(scale1)
            sequence:setChildAction(scale2)
            sender:runUIAction(sequence)

            local useType = BattleHeroUse.USE_GHOSTSKILL
            local useId = item.id[index]
            WZLog("WndBattleHud:onGhostSkill one", useId, item.skillUniqueId[index])
            
            self.m_nUsePoint = item.consumePower[index] / 1000
            if BattleHeroUse:heroUse(self.m_tMyHero:getBattleId(), useType, useId, nil, nil, nil, {self.m_nGhostTargetId}, item.skillUniqueId[index]) then
                WZLog("WndBattleHud:onGhostSkill two", useId)
                
                self.m_tUseGhostSkill[index] = self.m_tUseGhostSkill[index] - 1
                if self.m_tUseGhostSkill[index] <= 0 then
                    sender:setVisible(false)
                    local img, imgLv = self:getGhostSkillCell(index)
                    if img then
                        img:setVisible(false)
                        imgLv = WZUIImage:luaTo(imgLv)
                        imgLv:setFile("")
                    end

                    WBattleGlobal:getCurrent().m_tMyGhostSkill_Beginning.id[index] = 0
                end
            end
        else
            --MsgBoxManager:showTipBox(LocalStrings.BATTLE_EXT_ITEMSKILL_LIMIT)
        end
    end
end

--@brief    点击幽灵技能丢弃按钮回掉
function WndBattleHud:onClickDrop(tData)
    -- body
    if self.m_root == nil then return end 
    
    ProtocolProcessorSceneBattle:send_BATTLE_RemoveGhostSkill(WBattleGlobal:getCurrent():getBattleId(), WBattleGlobal:getCurrent():getMyBattleId(), tData.uniqueId)
end

--@brief    点击buff图标回调
function WndBattleHud:onCLickBuff(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self:hideBuffInfo()
    if g_myHeroTowerBuffId == nil or g_myHeroTowerBuffId == 0 then return end 

    local tData = {}
    tData.buffId = g_myHeroTowerBuffId
    local conForBuff = GetElement(self.m_root, "conForBuff_WndBattleHud", WZUIContainer)
    WndTips:show(element, conForBuff, 55, tData, GlobalMethod:ccp(20, 300))
end

--@brief    退出自动战斗
function WndBattleHud:quitAutoFight()
    if not AutoRunBattleConst.AUTO_RUN_BATTLE and GlobalGame.g_bIsAutoFightOpen then 
        AutoRunBattle.m_bHeroInit = false
        GlobalGame.g_bIsAutoFightOpen = false 
    end
end

--@brief    点击切换大招按钮回调
function WndBattleHud:onSwitchBigSkill(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

    if false and self.m_bCloseSkinSkillSwitch == true then
        local progBigSkill = GetElement(self.m_root, "progBigSkill_WndBattleHud", WZUIProgress)
        local bigPer = progBigSkill:getPercentage()
        WZLog("WndBattleHud:onSwitchBigSkill", bigPer)
        if self.m_nBigSkillIndex == 1 then 
            self.m_nBigSkillIndex = 2 
            if bigPer >= 100 then 
                self.m_angerAnim2:getAnimNode():setVisible(false)
                self.m_angerAnim:getAnimNode():setVisible(true)
            end
        else
            self.m_nBigSkillIndex = 1 
            if bigPer >= 100 then 
                self.m_angerAnim2:getAnimNode():setVisible(true)
                self.m_angerAnim:getAnimNode():setVisible(false)
            end
        end
        GlobalGame.g_saveBigSkillType = self.m_nBigSkillIndex
        GetElement(self.m_root, "txtBigSkillSwitch_WndBattleHud", WZUILabelTTF):setText(LocalStrings.BIGSKILL_TYPE[self.m_nBigSkillIndex])
    else
        if self.m_tMyHero:getUseBigSkill() then
            MsgBoxManager:showTipBox(LocalStrings.BATTLE_HUD_TEXT1)
            return
        end
        self:showBigSkillList(true)
    end

end

--@brief    辅助技能回调
--@param    sender:被选中的技能元素
function WndBattleHud:onKMSkill(sender)
    WZLog("WndBattleHud:onKMSkill",tostring(TeachGroup1.ISBATTLE), tostring(TeachGroup1.ISBATTLE_MYTURN))
    sender:disableSchedule()
    if WBattleGlobal:getCurrent():isGameOver() == true or (TeachGroup1.ISBATTLE and TeachGroup1.ISSKILL == nil) or self.m_tMyHero:isInBuffState(EffectTypeConfig.LIMIT_USE_SKILL) then
        return
    end

    local nTag = sender:getTag()
    if self.m_tKMSkillTouchMark[nTag] ~= nil and self.m_tKMSkillTouchMark[nTag] == false then return end 

    local curTime = WZThread:getUTickCount()
    if self.m_nTouchBeginTime == nil then 
        self.m_nTouchBeginTime = curTime
    end
    if not TeachGroup1.ISBATTLE and curTime - self.m_nTouchBeginTime >= 800000 then
        return 
    end

    if WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle then
        MsgBoxManager:showTipBox(LocalStrings.BATTLE_NOT_MY_TURN)
        return
    end
    --自动战斗不可操作提示
    if GlobalGame.g_bIsAutoFightOpen then 
        MsgBoxManager:showTipBox(LocalStrings.BATTLE_AUTOFIGHT_ATT)
        return 
    end

    if sender then
        local skill = WBattleGlobal:getCurrent().m_tMyKMSkill_Beginning
        local index = sender:getTag()
        WZLog("WndBattleHud:onKMSkill=",index)
        if skill.id[index]~=-1 then

            local originScale = 1
            --触摸动画部分
            local scale1 = WZUIActionScaleTo:create()
            scale1:setScaleX(0.7 * originScale)
            scale1:setScaleY(0.7 * originScale)
            scale1:setDuration(0.1)
            local scale2 = WZUIActionScaleTo:create()
            scale2:setScaleX(1 * originScale)
            scale2:setScaleY(1 * originScale)
            scale2:setDuration(0.1)
            local sequence = WZUIActionSequence:create()
            sequence:setChildAction(scale1)
            sequence:setChildAction(scale2)
            sender:runUIAction(sequence)

            local useType = BattleHeroUse.USE_KMSKILL
            local useId = skill.id[index]

            if TeachGroup1.ISBATTLE_MYTURN then
                TeachGroup1.SKILLID = useId
            end

            if self.m_nUsePoint + skill.consumePower[index] / 1000 > 10 then 
                MsgBoxManager:showTipBox(LocalStrings.BATTLE_ACTION_VALUE_NO_ENOUGH)
                return 
            end

            self.m_nUsePoint = self.m_nUsePoint + skill.consumePower[index] / 1000
            self.m_tMyHero.m_nUsePoint = self.m_tMyHero.m_nUsePoint + skill.consumePower[index]

            --单人副本，生成溅射弹角度
            local tItemData = GDatatab_skill["id_" .. useId]
            if tItemData and tItemData.id_group == 107 and tItemData.sub_type == 12 and WBattleGlobal:getCurrent():isSingleStage() then 
                local effectData = GDatatab_effect["id_" .. tItemData.effect_id[1][1]]
                local tSpatterAngle = GetRandomNum(effectData.effect[1][5], 110, 70)
                WZLog("WndBattleHud:onKMSkill", Serialize(tSpatterAngle))
                WBattleGlobal:getCurrent():setCurSpatterAngle(tSpatterAngle)
            end
            if BattleHeroUse:heroUse(self.m_tMyHero:getBattleId(),useType,useId, nil) then
                WZLog("WndBattleHud:onKMSkill two", useId)
                if tItemData and tItemData.id_group == 703 and WBattleGlobal:getCurrent():isSingleStage() then 
                    local tEffectData = GDatatab_effect["id_" .. tItemData.effect_id[1][1]]
                    self.m_nWindSkillId = useId
                    self.m_nWindSkillBuffTime = tEffectData.effect[1][7]
                end
                self.m_tUseKMSkill[index] = self.m_tUseKMSkill[index] - 1
                if self.m_tUseKMSkill[index] <= 0 then
                    sender:setVisible(false)
                    local img, txt = self:getKMSkillCostCell(index)
                    if img then
                        img:setVisible(false)
                    end
                end
            end
            self:setFlyPos()
        end
    end
end

--@brief    点击快捷发言按钮回调
function WndBattleHud:onQuickChat(element)
    -- body
    if TeachGroup1.ISBATTLE == true then
        return
    end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndQuickChatList:showInterface(2)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief    刷新回合时间
--@param    nTime,设定的时间
--@note
function WndBattleHud:_updateTurnTime(nTime)

	if ProjConfig.DEBUG == 1 then
    	--nTime = 20
	end

    if TeachGroup1.ISBATTLE_MYTURN then
        nTime = 20
    end

	if self.m_root then
        ---[[
		local txtTurnTime = GetElement(self.m_root,"txtTurnTime_WndBattleHud",WZUILabelAtlasFont)
		
		if nTime > 0 and self.m_bStopTimeTtf ~= true then
			local _time = math.ceil(nTime)
			
			if _time<= 10 and math.ceil(self.m_nTurnTime) == _time + 1 then
				SoundManager:playEffectSound(SoundDefine.E_S_TIMER)
				txtTurnTime:stopAllActions()
				txtTurnTime:setOpacity(255)
				local actionSeq = WZUIActionSequence:create()
				local action1 = WZUIActionFadeTo:create()
				action1:setDuration(1)
				action1:setOpacity(0)
				local action2 = WZUIActionFadeTo:create()
				action2:setDuration(0)
				action2:setOpacity(255)
				actionSeq:setChildAction(action1)
				actionSeq:setChildAction(action2)
				txtTurnTime:runUIAction(actionSeq)
			end
			
			txtTurnTime:setText(string.format("%02d",_time))
			
			txtTurnTime:setVisible(true)
		elseif self.m_bStopTimeTtf ~= true then
			txtTurnTime:setText(string.format("%02d",0))
			--txtTurnTime:setVisible(false)
		end
        --]]
	end
	WBattleGlobal:getCurrent():checkIsCheat(math.ceil(self.m_nTurnTime),self.m_nTurnTime_Encrypt,22)
	self.m_nTurnTime = nTime
	self.m_nTurnTime_Encrypt = BattleCommon:intEncrypt(math.ceil(self.m_nTurnTime))
end


--@brief    刷新自己HP相关控件
--@note
function WndBattleHud:_updateMyHP(bSet)
    if self.m_root == nil then
        return
    end

    local hero = self.m_tMyHero
    if WBattleGlobal:getCurrent():isAudience() and WBattleGlobal:getCurrent():getCurrentCharacter() then
        hero = WBattleGlobal:getCurrent():getCurrentCharacter()
    end

    local myHP = hero:getHp()
    local myExtraHP = hero:getExtraHp()
    local myMaxHP = hero:getMaxHp()

    WZLog("WndBattleHud:_updateMyHP", myHP, myMaxHP, myExtraHP, tostring(hero:getExtraHPBuff()))
    WZUIProgress:luaTo(GetElement(self.m_root,"progMyHP_WndBattleHud")):setPercentage(100*myHP/myMaxHP)
    if bSet or (bSet == nil and hero:getExtraHPBuff()) then 
        WZUIProgress:luaTo(GetElement(self.m_root,"progMyExtraHP_WndBattleHud")):setPercentage(100*myExtraHP/myMaxHP)
        GetElement(self.m_root,"txtMyHP_WndBattleHud",WZUIFreeTextBox):setShowText(string.format([[<T C="255,255,255" S="14" P="1" SC="132,66,29" SS="1" SE="1">%d+%d/%d</T>]], myHP, myExtraHP, myMaxHP))
    else
        WZUIProgress:luaTo(GetElement(self.m_root,"progMyExtraHP_WndBattleHud")):setPercentage(0)
        GetElement(self.m_root,"txtMyHP_WndBattleHud",WZUIFreeTextBox):setShowText(string.format([[<T C="255,255,255" S="14" P="1" SC="132,66,29" SS="1" SE="1">%d/%d</T>]],myHP,myMaxHP))
    end

end

--@brief    观众模式刷新界面
function WndBattleHud:resetByAudience()

    local hero = WBattleGlobal:getCurrent():getCurrentCharacter()
    if hero then
        self:updatePlayerSp(hero:getBattleId())
        self:updatePlayerPF(hero:getBattleId())
        self:updatePlayerHP(hero:getBattleId())
    end
end

--@brief    刷新自己PF相关控件
--@note
function WndBattleHud:_updateMyPF()
	if self.m_root == nil then
		return
	end

    local hero = self.m_tMyHero
    if WBattleGlobal:getCurrent():isAudience() and WBattleGlobal:getCurrent():getCurrentCharacter() then
        hero = WBattleGlobal:getCurrent():getCurrentCharacter()
    end

	local myPF = hero:getPF()
	local myMaxPF = hero:getMaxPF()

    WZLog("WndBattleHud:_updateMyHP", myPF, myMaxPF)
    WZUIProgress:luaTo(GetElement(self.m_root,"progMyPF_WndBattleHud")):setPercentage(100*math.floor(myPF)/myMaxPF)
    GetElement(self.m_root,"txtMyPF_WndBattleHud",WZUIFreeTextBox):setShowText(string.format([[<T C="255,255,255" S="14" P="1" SC="132,66,29" SS="1" SE="1">%d/%d</T>]],math.floor(myPF),myMaxPF))

end

--@brief    创建表情控件
--@note
function WndBattleHud:_createFaceBox()
	local faceBox = GetElement(self.m_root,"conFaceBox_WndBattleHud")

    GetElement(WndBattleHud.m_root,"txtFace_WndBattleHud",WZUILabelTTF):setText(LocalStrings.EXPLAIN1)
    
    if ProjConfig.LANGUAGE == "pt" then
        GetElement(WndBattleHud.m_root,"txtFace_WndBattleHud",WZUILabelTTF):setFontSize(14)
    elseif ProjConfig.LANGUAGE == "es" then
        GetElement(WndBattleHud.m_root,"txtFace_WndBattleHud",WZUILabelTTF):setFontSize(16)
    end
    local freeTable = GetElement(self.m_root,"freeTable_WndBattleHud",WZUITableContainer)
    freeTable:cleanTable()

    local faceCount = GetTableLen(self.FACE_INDEX)
    for i=1, faceCount do
        local celElement,tCell = CellFaceItem:createElement()
        if celElement and tCell then
            celElement:setTag(i-1)
            freeTable:setCellElement(celElement)
            tCell:setFaceMessage(WndChat.FACEIMASK_INDEX[i])
            tCell:setItemClickFun(function(index)
                self:onSelFace(index)
            end)
        end
    end

end

--@brief    创建勋章控件
--@param    isLeft,是否在左边
--@param    nIdx,第几个位置
function WndBattleHud:_addMedal(isLeft,nIdx)

    local medal = WZUIImage:create()
    medal:setTouchEnable(false)
    medal:setUseOriginSize(true)
    medal:setShowAll(true)
    medal:setFile("ui/combat/battle_icon_HP.png")
    medal:setGrayRender(true)
    medal:setScale(1.0)
    if isLeft then
        medal:setName("imgLeftMedal"..nIdx.."_WndBattleHud")
        
        local tab = GetElement(self.m_root,"tabBattleCtb_WndBattleHud",WZUITableContainer)
        local cell = tab:getCellElement(0)
        local pos = self.m_root:convertToNodeSpace(cell:getParent():convertToWorldSpace(GlobalMethod:ccp(cell:getPosition())))
        pos.x = pos.x + cell:getContentSize().width/2 + nIdx * 30 - 33
        medal:setRelativePositionLuaTo(pos.x/self.m_root:getContentSize().width , pos.y/self.m_root:getContentSize().height + 0.002)
    else
        medal:setName("imgRightMedal"..nIdx.."_WndBattleHud")
        
        local tab = GetElement(self.m_root,"tabBattleCtb2_WndBattleHud",WZUITableContainer)
        local cell = tab:getCellElement(0)
        local pos = self.m_root:convertToNodeSpace(cell:getParent():convertToWorldSpace(GlobalMethod:ccp(cell:getPosition())))
        pos.x = pos.x + cell:getContentSize().width/2 + nIdx * 30 - 33
        medal:setRelativePositionLuaTo(pos.x/self.m_root:getContentSize().width , pos.y/self.m_root:getContentSize().height + 0.002)
    end
    self.m_root:addChild(medal)
    medal:setScaleX(1 * medal:getScaleX() )
    medal:setScaleY(1 * medal:getScaleY() )
    table.insert(self.m_tMedalList, medal)
end


--@brief    增加技能道具引导效果
--@note     --teach
function WndBattleHud:_addSkillORItemGuide(tSender)
	local img = tSender

	if tSender:getChildByTag(1)==nil then
		local img1 = WZUIImage:create()
		img1:setUseOriginSize(true)
		img1:setScale(0.41)
		img1:setFile("common/animation/7_an.png")
		img1:setRelativePositionLuaTo(0.5,0.5)
		img1:setTag(1)

		local actionFadeTo1 = WZUIActionFadeTo:create()
		actionFadeTo1:setOpacity(50)
		actionFadeTo1:setDuration(0.5)
		local actionFadeTo2 = WZUIActionFadeTo:create()
		actionFadeTo2:setOpacity(255)
		actionFadeTo2:setDuration(0.5)
		sequence = WZUIActionSequence:create()
		sequence:setIsLoop(true)

		sequence:setChildAction(actionFadeTo1)
		sequence:setChildAction(actionFadeTo2)

		img:addChild(img1,-1)
		img1:runUIAction(sequence)
	else
		tSender:getChildByTag(1):setVisible(true)
	end

	if tSender:getChildByTag(2)==nil then
		local bg = WZUIImage:create()
		bg:setUseOriginSize(true)
		bg:setFile("battle/hud/battle_hud_playericon_bg.png")
		bg:setRelativePositionLuaTo(0.5,0.5)
		bg:setTag(2)
		img:addChild(bg,-1)
	else
		tSender:getChildByTag(2):setVisible(true)
	end
	
end

--@brief    移除技能道具引导效果
--@note     --teach
function WndBattleHud:_removeSkillORItemGuide(tSender)
	WZLog("_removeSkillORItemGuide")
	local img = tSender:getChildByTag(1)
	if img then
		img:setVisible(false)
	end
	local bg = tSender:getChildByTag(2)
	if bg then
		bg:setVisible(false)
	end
end

--@brief    时间计算
function WndBattleHud:_caculatePressTime(element)
    -- body
    local curTime = WZThread:getUTickCount()
    if curTime - self.m_nTouchBeginTime >= 800000 then
        element:disableSchedule()
        --弹技能tips
        local item = WBattleGlobal:getCurrent().m_tMyProp_Beginning
        local index = self.m_nTouchIndex
        WZLog("WndBattleHud:_caculatePressTime =",index)
        if item.id[index]~=-1 then
            local tData = GDatatab_skill["id_" .. item.id[index]]
            WndTips:show(element, self.m_root, 51, tData, GlobalMethod:ccp(0,140), true)
        end
    end
end

--@brief    时间计算
function WndBattleHud:_caculatePressTimeKMSkill(element)
    -- body
    local curTime = WZThread:getUTickCount()
    if curTime - self.m_nTouchBeginTime >= 800000 then
        element:disableSchedule()
        --弹技能tips
        local skill = WBattleGlobal:getCurrent().m_tMyKMSkill_Beginning
        local index = self.m_nTouchIndex
        WZLog("WndBattleHud:_caculatePressTimeKMSkill=",index)
        if skill.id[index]~=-1 then
            local tData = GDatatab_skill["id_" .. skill.id[index]]
            WndTips:show(element, self.m_root, 51, tData, GlobalMethod:ccp(0,130), true)
        end
    end
end

--@brief    删除buff图标
function WndBattleHud:removeBuffIcon(buff)
    --WZLog("WndBattleHud:removeBuffIcon 0", Serialize(buff))
    if buff.m_tOwner == self:getMyHero() then
        -- if buff.m_nType == 58 then 
        --     buff.m_tOwner:setExtraHp(0, false)
        -- end
        for i,v in ipairs(self.m_tBuffIconList) do
            if buff == v.data then
                WZLog("WndBattleHud:removeBuffIcon 1", i)
                local tbconEquip = GetElement(self.m_root,"tabBuff_WndBattleHud",WZUITableContainer)
                if buff.m_nEffectType == 0 then
                    tbconEquip = GetElement(self.m_root,"tabDebuff_WndBattleHud",WZUITableContainer)
                    table.remove(self.m_tDebuffIconList, v:getTag()+1)
                else
                    table.remove(self.m_tGoodbuffIconList, v:getTag()+1)
                end
                tbconEquip:removeCellElementByReset(v:getTag())
                table.remove(self.m_tBuffIconList, i)
                self:hideBuffInfo()
                break
            end
        end
    end
end

--@brief    更新buff图标
function WndBattleHud:updateBuffIcon(buff)
    --WZLog("WndBattleHud:updateBuffIcon 0", Serialize(buff))
    if buff.m_tOwner == self:getMyHero() then
        for i,v in ipairs(self.m_tBuffIconList) do
            if buff == v.data and buff.m_nTimeDurationValue ~= -1 then
                local time = buff.m_nTimeDurationValue - buff.m_nTimePassValue
                WZLog("WndBattleHud:updateBuffIcon 1", i, time, buff.m_nTimeDurationValue, buff.m_nTimePassValue)
                local txtBuffCell = GetElement(v,"txtBuffCell_WndBattleHud",WZUILabelTTF)
                if buff.m_nTimeDurationValue < 999999 then
                    txtBuffCell:setText(string.format(LocalStrings.BATTLE_BUFF_2, time / 1000))
                    if time <= 2000 then
                        txtBuffCell:setColor(ccc3(255,171,171))
                    end
                end
                break
            end
        end
    end
end

--@brief    更新buff叠加数量
function WndBattleHud:updateBuffAddTimes(buff)
    -- WZLog("WndBattleHud:updateBuffAddTimes", Serialize(buff))
    if buff.m_tOwner == self:getMyHero() then
        for i,v in ipairs(self.m_tBuffIconList) do
            if buff.m_nType == v.data.m_nType then
                local txtInbornAddTimes = GetElement(v, "txtInbornAddTimes_WndBattleHud", WZUILabelTTF)
                if buff.m_tOwner.m_tBuffAddTimes and buff.m_tOwner.m_tBuffAddTimes[buff.m_nType] and buff.m_tOwner.m_tBuffAddTimes[buff.m_nType] > 1 then
                    txtInbornAddTimes:setText(buff.m_tOwner.m_tBuffAddTimes[buff.m_nType])
                else
                    txtInbornAddTimes:setText("")
                end
                break
            end

        end
    end
end

--@brief    添加buff图标
function WndBattleHud:addBuffIcon(buff)
    WZLog("WndBattleHud:addBuffIcon", buff.m_tOwner.m_nPlayerId, buff.m_nVisible)
    if buff.m_tOwner and buff.m_tOwner.m_nPlayerId == WBattleGlobal:getCurrent():getMyBattleId() and buff.m_nVisible == 1 then
        WZLog("WndBattleHud:addBuffIcon2",buff.m_nID)
        local tbconEquip = GetElement(self.m_root,"tabBuff_WndBattleHud",WZUITableContainer)

        local ele = CreateElement("conBuffCell_WndBattleHud")

        local time = buff.m_nTimeDurationValue - buff.m_nTimePassValue
        if buff.m_nTimeDurationValue == -1 or buff.m_nTimeDurationValue > 999999 then
            GetElement(ele,"txtBuffCell_WndBattleHud",WZUILabelTTF):setText(LocalStrings.BATTLE_BUFF_1)
            GetElement(ele,"txtBuffCell_WndBattleHud",WZUILabelTTF):setColor(ccc3(114,200,85))
        else
            GetElement(ele,"txtBuffCell_WndBattleHud",WZUILabelTTF):setText(string.format(LocalStrings.BATTLE_BUFF_2, time / 1000))
        end

        local txtInbornAddTimes = GetElement(ele, "txtInbornAddTimes_WndBattleHud", WZUILabelTTF)
        if buff.m_tOwner.m_tBuffAddTimes and buff.m_tOwner.m_tBuffAddTimes[buff.m_nType] and buff.m_tOwner.m_tBuffAddTimes[buff.m_nType] > 1 then
            txtInbornAddTimes:setText(buff.m_tOwner.m_tBuffAddTimes[buff.m_nType])
        else
            txtInbornAddTimes:setText("")
        end

        --buff.m_nIngIcon = "skills_023"
        GetElement(ele,"imgBuffCell_WndBattleHud",WZUIImage):setFile("battleitems/" .. buff.m_nIngIcon .. ".png")

        ele:setVisible(true)
        ele.data = buff

        if buff.m_nEffectType == 0 then
            tbconEquip = GetElement(self.m_root,"tabDebuff_WndBattleHud",WZUITableContainer)
            tbconEquip:getMoveElement():setScaleX(-1)
            ele:setScaleX(-1)
            
            ele:setTag(#self.m_tDebuffIconList)
            table.insert(self.m_tDebuffIconList, ele)
        else
            ele:setTag(#self.m_tGoodbuffIconList)
            table.insert(self.m_tGoodbuffIconList, ele)
        end

        tbconEquip:setCellElement(ele)
        table.insert(self.m_tBuffIconList, ele)
    end
end

--@brief    点击buff图标
function WndBattleHud:onBuff(ele)
    local ele0 = ele:getParent():getParent()
    WZLog("WndBattleHud:onBuff one", Serialize(ele0.data))

    local buff = ele0.data
    local parent = WZUIContainer:luaTo(ele:getParent())

    self:hideBuffInfo()

    local bubbleElement = WZUIContainer:luaTo(CreateElement("conBubble_WndBattleHud"))

    GetElement(bubbleElement,"imgBubble_WndBattleHud",WZUIImage):setFile("battleitems/" .. buff.m_nIngIcon .. ".png")
    local ttf = GetElement(bubbleElement,"txtBubble_WndBattleHud",WZUILabelTTF)
    local ttf1 = GetElement(bubbleElement,"txtBubbleDesc_WndBattleHud",WZUILabelTTF)
    ttf:setText(buff.m_sName)
    ttf1:setText(buff.m_sDesc)

    local posX,posY = parent:getParent():getPosition()
    local pos = parent:getParent():getParent():convertToWorldSpace(GlobalMethod:ccp(posX,posY))
    pos = GetElement(self.m_root,"conPassTurn_WndBattleHud",WZUIContainer):convertToNodeSpace(pos)

    WZLog("WndBattleHud:onBuff two",posX,posY,pos.x,pos.y)
    bubbleElement:setVisible(true)

    local w, h = 290, 120 --初始大小
    local h = h + ttf1:getLabelContentSize().height
    bubbleElement:setAbsContentSize(GlobalMethod:CCSize(w,h))
    bubbleElement:setContentSize(GlobalMethod:CCSize(w,h))
    bubbleElement:setUseAbsSize(true)
    GetElement(self.m_root,"conPassTurn_WndBattleHud",WZUIContainer):addChild(bubbleElement)
    bubbleElement:setPositionX(pos.x+50)

    self.m_tBubbleElement = bubbleElement

    if ProjConfig.LANGUAGE == "vn" then
        ttf:setDimensions(GlobalMethod:CCSize(180,0))
    end
end

--@brief    隐藏buff信息
function WndBattleHud:hideBuffInfo()
    if self.m_tBubbleElement then
        self.m_tBubbleElement:setVisible(false)
        self.m_tBubbleElement:removeFromParentAndCleanup(true)
        self.m_tBubbleElement = nil
    end
end


--@brief    时间计算
function WndBattleHud:_caculatePressTimeSkill(element)
    -- body
    local curTime = WZThread:getUTickCount()
    if curTime - self.m_nTouchBeginTime >= 800000 then
        element:disableSchedule()
        --弹技能tips
        local skill = WBattleGlobal:getCurrent().m_tMySkill_Beginning
        local index = self.m_nTouchIndex
        WZLog("WndBattleHud:_caculatePressTimeSkill=",index)
        if skill.id[index]~=-1 then
            local tData = GDatatab_skill["id_" .. skill.id[index]]
            WndTips:show(element, self.m_root, 51, tData, GlobalMethod:ccp(0,130), true)
        end
    end
end

--@brief    时间计算
function WndBattleHud:_caculatePressTimeGhostSkill(element)
    -- body
    local curTime = WZThread:getUTickCount()
    if curTime - self.m_nTouchBeginTime >= 800000 then
        element:disableSchedule()
        --弹技能tips
        local skill = WBattleGlobal:getCurrent().m_tMyGhostSkill_Beginning
        local index = self.m_nTouchIndex
        WZLog("WndBattleHud:_caculatePressTimeGhostSkill=",index)
        if skill.id and skill.id[index] and skill.id[index] > 0 then
            local tData = CopyTable(GDatatab_skill["id_" .. skill.id[index]])
            tData.uniqueId = skill.skillUniqueId[index]
            WndTips:show(element, self.m_root, 51, tData, GlobalMethod:ccp(0,150), true)
        end
    end
end

--@brief    幽灵模式，隐藏原有的技能和道具怒气
function WndBattleHud:_showGhostSkill()
    -- body
    GetElement(self.m_root, "conMyHud_WndBattleHud", WZUIContainer):setVisible(false)
    local conBigSkill = self:getBigSkillContainer()
    if conBigSkill then 
        conBigSkill:setVisible(false)
    end
    GetElement(self.m_root, "conMyGhostHud_WndBattleHud", WZUIContainer):setVisible(true)
end

--@brief     返回我所在的阵营的标记值
--@author    Tianxiang_Xu
function WndBattleHud:rtnMyCamp()
    --body
    local tMakePairOk = WBattleGlobal:getCurrent().m_tMakePairOk
    if not tMakePairOk.playerCamp then
        return 0
    end

    for i = 1, tMakePairOk.playerCount do
        WZLog("************** WndBattleHud:rtnMyCamp ***************", tMakePairOk.playerCount, CacheCenter:getPlayerInfo().id, tMakePairOk.playerId[i])
        if tMakePairOk.selfId == tMakePairOk.playerId[i] then
            return tMakePairOk.playerCamp[i]
        end
    end 
end

--@brief    根据玩家id判断是友是敌
--@param    playerId: 玩家Id
function WndBattleHud:_judgeCamp(playerId)
    -- body
    local bIsEnemy = false 
    local tMakePairOk = WBattleGlobal:getCurrent().m_tMakePairOk
    if not tMakePairOk.playerCamp then
        return bIsEnemy
    end

    for i = 1, #tMakePairOk.playerCamp do
        if tMakePairOk.playerId[i] == playerId and tMakePairOk.playerCamp[i] ~= self:rtnMyCamp() then
            bIsEnemy = true
            break 
        end
    end
    WZLog("playerIdplayerIdplayerIdplayerIdplayerId", playerId, bIsEnemy)
    return bIsEnemy 
end

--@brief    设置选中的目标的角色名字
function WndBattleHud:_setGhostTargetName(hero)
    -- body
    local txtTargetPlayerName = GetElement(self.m_root, "txtTargetPlayerName_WndBattleHud", WZUILabelTTF)
    if txtTargetPlayerName then 
        txtTargetPlayerName:setText(hero:getPlayerName())
        if self:rtnMyCamp() ~= hero:getCamp() then 
            txtTargetPlayerName:setColor(GlobalMethod:ccc3(255,255,255))
        else
            txtTargetPlayerName:setColor(GlobalMethod:ccc3(99,255,95))
        end
    end
end

--@brief    显示英雄塔buff
function WndBattleHud:_showHeroTowerBuff()
    -- body
    if WBattleGlobal:getCurrent():isHeroTowerStage() then 
        if g_myHeroTowerBuffId then 
            GetElement(self.m_root, "conForBuff_WndBattleHud", WZUIContainer):setVisible(true)
            local imgBuffIcon = GetElement(self.m_root, "imgBuffIcon_WndBattleHud", WZUIImage)
            if imgBuffIcon then 
                local buffData = GDatatab_herotower_map["id_" .. g_myHeroTowerBuffId]
                if buffData then 
                    imgBuffIcon:setFile(buffData.buff2icon)
                end
            end
        end
    end
end

--@brief    设置速度
--@param    ownerIndex:房主设置的帧率索引
function WndBattleHud:setTimeScaleByMode(ownerIndex)
    -- body
    if self.m_root == nil then return end 
    local sConfig = CacheCenter:getGameParam().gameflash
    if not sConfig then return end

    local string = string.sub(sConfig, 2, -2) 
    local timer1 = SplitStringWithSeparator(string,",")[1]
    local timer2 = SplitStringWithSeparator(string,",")[2]

    if WBattleGlobal:getCurrent():isArenaFighting() then 
        CCDirector:sharedDirector():getScheduler():setTimeScale(tonumber(timer2))
    elseif WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_SINGLE) 
            or WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_DAILY) 
            or WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_TOWER) 
            or WBattleGlobal:getCurrent():isGuildBossStage() 
            or WBattleGlobal:getCurrent():isHeroTowerStage() 
            or WBattleGlobal:getCurrent():isRemainStage() then
        local speedlevel = string.sub(CacheCenter:getGameParam()["speedlevel"],2,-2)
        local tLevelLimit = SplitStringWithSeparator(speedlevel, ",")

        local level = CacheCenter:getPlayerInfo().level

        local tGameflashIndex = {}
        tGameflashIndex[0] = 1 --速度x1
        if level >= tonumber(tLevelLimit[1]) then
            tGameflashIndex[1] = 2 --速度x2
        end
        if level >= tonumber(tLevelLimit[2]) then
            tGameflashIndex[2] = 4 --速度x4
        end

        if GetTableLen(tGameflashIndex) > 1 then
            GetElement(self.m_root,"btnGameFlash_WndBattleHud",WZUIButton):setVisible(true)
        end

        local tempIndex = 0
        local data = WZDataFile:getInstance():getUserData()
        if data then
            local value = data:getStringValue("BattleSetting", "gameflash")
            if value ~= nil and value ~= "" then
                if tonumber(value) < GetTableLen(tGameflashIndex) then
                    tempIndex = tonumber(value)
                end
            end

            CCDirector:sharedDirector():getScheduler():setTimeScale(tGameflashIndex[tempIndex])

            self:setGameFlashBtnStatus(tempIndex)
        end
    elseif WBattleGlobal:getCurrent():isDoubleTowerStage() 
            or WBattleGlobal:getCurrent():isWorldTeamBossStage()
            or WBattleGlobal:getCurrent():isCoupleHegemonyStage()
            or WBattleGlobal:getCurrent():isTeamStage() then
        local speedlevel = string.sub(CacheCenter:getGameParam()["speedlevel"],2,-2)
        local tLevelLimit = SplitStringWithSeparator(speedlevel, ",")
        local bIsRoomOwner = WBattleGlobal:getCurrent().m_tMakePairOk.bIsRoomOwner

        local level = CacheCenter:getPlayerInfo().level

        local tGameflashIndex = {}
        tGameflashIndex[0] = 1 --閫熷害x1
        if level >= tonumber(tLevelLimit[1]) then
            tGameflashIndex[1] = 2 --閫熷害x2
        end
        if level >= tonumber(tLevelLimit[2]) then
            tGameflashIndex[2] = 4 --閫熷害x4
        end

        if GetTableLen(tGameflashIndex) > 1 then
            GetElement(self.m_root,"btnGameFlash_WndBattleHud",WZUIButton):setVisible(true)
        end

        local tempIndex = 0
        local data = WZDataFile:getInstance():getUserData()
        if data and bIsRoomOwner then
            local value = data:getStringValue("BattleSetting", "gameflash")
            if value ~= nil and value ~= "" then
                if tonumber(value) < GetTableLen(tGameflashIndex) then
                    tempIndex = tonumber(value)
                end
            end

            CCDirector:sharedDirector():getScheduler():setTimeScale(tGameflashIndex[tempIndex])
            self:setGameFlashBtnStatus(tempIndex)
            ProtocolProcessorSceneBattle:send_BATTLE_ChangeNeedleRate(WBattleGlobal:getCurrent().m_tMakePairOk.battleId, WBattleGlobal:getCurrent():getMyBattleId(), tempIndex)
        elseif not bIsRoomOwner and ownerIndex then
            CCDirector:sharedDirector():getScheduler():setTimeScale(tGameflashIndex[ownerIndex])
            self:setGameFlashBtnStatus(ownerIndex)
        end
    else
        CCDirector:sharedDirector():getScheduler():setTimeScale(tonumber(timer1))
    end

end

--  设置游戏节奏按钮状态
function WndBattleHud:setGameFlashBtnStatus(nStatus)
    local imgGameFlash1 = GetElement(self.m_root,"imgGameFlash1_WndBattleHud",WZUIImage)
    local imgGameFlash2 = GetElement(self.m_root,"imgGameFlash2_WndBattleHud",WZUIImage)
    local imgGameFlash3 = GetElement(self.m_root,"imgGameFlash3_WndBattleHud",WZUIImage)
    if nStatus == 0 then
        imgGameFlash1:setFile("ui/common/common_ch1.png")
        imgGameFlash2:setFile("ui/common/common_ch1.png")
        imgGameFlash3:setFile("ui/common/common_ch1.png")
    elseif nStatus == 1 then
        imgGameFlash1:setFile("ui/common/common_ch2.png")
        imgGameFlash2:setFile("ui/common/common_ch2.png")
        imgGameFlash3:setFile("ui/common/common_ch2.png")
    elseif nStatus == 2 then
        imgGameFlash1:setFile("ui/common/common_ch4.png")
        imgGameFlash2:setFile("ui/common/common_ch4.png")
        imgGameFlash3:setFile("ui/common/common_ch4.png")
    end
end

--@brief    获取觉醒容器
function WndBattleHud:getAwakeSkillContainer()
    -- body
    return GetElement(self.m_root, "conAwakeSkill_WndBattleHud", WZUIContainer)
end

--@brief    显示帮助对话框
function WndBattleHud:_skinHelperOk(hero)
    -- body
    self:_removeDialog()
    _,self.m_tDialog2 = Teach:showDialog(hero:getAnimation():getAnimNode(), SceneBattle:getFrontLayer(), LocalStrings.HELPER_ATT, 4,  GlobalMethod:ccp(0, 200), 1)
end

function WndBattleHud:_removeDialog()
    if self.m_tDialog2 then
        self.m_tDialog2:removeDialog(true)
        self.m_tDialog2 = nil
    end
end

--@brief    点击怒气道具事件
function WndBattleHud:_postPowerItemEvent()
    -- body
    local level = CacheCenter:getPlayerInfo().level
    if level >= 5 and level <= 8 then 
        local eventKey = PostPlayerEvent["event_clickPowerItem" .. level]
        if eventKey then 
            PostPlayerEvent:postEvent(eventKey)    
        end
    end
end

--@brief    玩家使用技能道具事件
function WndBattleHud:_postSkillItemEvent(skillData, bIsBigSkill)
    -- body
    if not WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_SINGLE) then return end 

    local mapId = WBattleGlobal:getCurrent().m_tMakePairOk.mapId
    if mapId == 10101 and skillData then 
        if skillData.id == 62 then 
            PostPlayerEvent:postEvent(PostPlayerEvent.event_oneLvClickFly)     
        elseif skillData.id_group == 2 then 
            PostPlayerEvent:postEvent(PostPlayerEvent.event_oneLvChooseScatter)     
        elseif skillData.id_group == 3 then 
            PostPlayerEvent:postEvent(PostPlayerEvent.event_oneLvChooseForceSkill)     
        end
    elseif mapId == 10102 and skillData then 
        local eventKey = PostPlayerEvent["event_oneLvPlayerFirstSkill"]
        if eventKey then 
            PostPlayerEvent:postEvent(eventKey)    
        end
    elseif mapId == 10104 and skillData and skillData.id_group == 5 then 
        local eventKey = PostPlayerEvent["event_threeLvUseBomb"]
        if eventKey then 
            PostPlayerEvent:postEvent(eventKey)    
        end
    elseif mapId == 10105 and bIsBigSkill then 
        local eventKey = PostPlayerEvent["event_fourLvUseBigSkill"]
        if eventKey then 
            PostPlayerEvent:postEvent(eventKey)    
        end
    end
end

--@brief    获取辅助技能栏元素
--@param    nTag,第几个技能栏元素
function WndBattleHud:getKMSkillCell(nTag)
    if nTag > 0 and nTag <= 6 then
        return GetElementWithoutAssert(self.m_root, "imgKMSkill"..nTag.."_WndBattleHud", WZUIImage)
    end
    return nil
end

--@brief    获取辅助技能栏元素
--@param    nTag,第几个技能栏元素
function WndBattleHud:getKMSkillClipCell(nTag)
--    WZLog("WndBattleHud:getKMSkillClipCell", nTag)
    if nTag > 0 and nTag <= 6 then
        return GetElementWithoutAssert(self.m_root,"progKMSkillClip"..nTag.."_WndBattleHud",WZUIProgress)
    end
    return nil
end

--@brief    获取辅助技能栏元素
--@param    nTag,第几个技能栏元素
function WndBattleHud:getKMSkillCostCell(nTag)
    if nTag > 0 and nTag <= 6 then
        return GetElementWithoutAssert(self.m_root, "imgKMSkillCost"..nTag.."_WndBattleHud", WZUIImage), GetElementWithoutAssert(self.m_root,"txtKMCost"..nTag.."_WndBattleHud",WZUILabelAtlasFont)
    end
    return nil
end

--@brief    获取道具在哪个位置
function WndBattleHud:getMyKMSkillPos(nSkillId)
    local skill = WBattleGlobal:getCurrent().m_tMyKMSkill_Beginning

    if WBattleGlobal:getCurrent():isAudience() and WBattleGlobal:getCurrent():getCurrentCharacterId() then
        skill =  WBattleGlobal:getCurrent().m_tHudKMSkill[WBattleGlobal:getCurrent():getCurrentCharacterId()]
    end

    if skill == nil then
        skill = WBattleGlobal:getCurrent().m_tMyKMSkill_Beginning
    end

    local nTag
    for i=1,skill.count do
        if skill.id[i] == nSkillId then
            nTag = i
        end
    end

    return nTag
end

function WndBattleHud:updateMyKMSkillCtb()
    if self:getMyHero() or (WBattleGlobal:getCurrent():isAudience() and WBattleGlobal:getCurrent():getCurrentCharacter():getType() == 0) then
        local count = 0

        local listCD = self:getMyHero().m_tKMSkillCdList
        local list = WBattleGlobal:getCurrent().m_tMyKMSkill_Beginning.id

        WZLog("WndBattleHud:updateMyKMSkillCtb zero", Serialize(list))
        for i,v in pairs(list) do
            count = count + 1
            local pos = self:getMyKMSkillPos(v)
            local cd = listCD[v]
            local skill = WBattleGlobal:getCurrent():getKMSkillById(v)
            if pos and skill then

                local prog = WndBattleHud:getKMSkillClipCell(pos)
                local progAction = WZUIActionProgressFromTo:create()
                
                local coolSkillTime = WBattleGlobal:getCurrent():getKMSkillById(v).startCoolSkillTime

                local nowSkillTime = cd and (cd -  BattleCtbManager.m_nUpdateCTB_time) or 0
                nowSkillTime = nowSkillTime
                local nowPer = (coolSkillTime == 0 or nowSkillTime <= 0) and 0 or nowSkillTime/coolSkillTime * 100

                WZLog("WndBattleHud:updateMyKMSkillCtb one-00", pos,cd,coolSkillTime,BattleCtbManager.m_nUpdateCTB_time,nowSkillTime, nowPer, prog:getPercentage())

                if nowPer > 0 then
                    local tempElement = self:getKMSkillCell(pos)
                    local img = WZUIImage:luaTo(tempElement)
                    if img then
                        img:setColor(GlobalMethod:ccc3(100,100,100))
                        img:setTouchEnable(false)
                    end
                end

                local duration = BattleCtbManager.m_nUpdateCTB_time / BattleCtbManager.SECOND_PER_CTB
                progAction:setFromPercent(prog:getPercentage())
                progAction:setToPercent(nowPer)
                progAction:setDuration( duration )
                progAction:setFinishLuaFunction("updateItemClipCallBack")
                progAction:setFinishLuaTable(self)
                prog:stopAllActions()
                prog:runUIAction(progAction)
            end
        end
    end
end

--@brief    重置道具栏
--@note
function WndBattleHud:resetKMSkill(bForceClose, isGet)
    WZLog("WndBattleHud:resetKMSkill zero", isGet)
    local item = WBattleGlobal:getCurrent().m_tMyKMSkill_Beginning

    if WBattleGlobal:getCurrent():isAudience() and WBattleGlobal:getCurrent():getCurrentCharacterId() then
        item =  WBattleGlobal:getCurrent().m_tHudKMSkill[WBattleGlobal:getCurrent():getCurrentCharacterId()]
    end

    if item == nil then
        item = WBattleGlobal:getCurrent().m_tMyKMSkill_Beginning
    end

    local tempElement
    local heroCharacter = WBattleGlobal:getCurrent():getCurrentCharacter()
    for i=1,item.count do
        tempElement = self:getKMSkillCell(i)
        self.m_tKMSkillTouchMark[i] = true
        local img, txt = self:getKMSkillCostCell(i)

        if tempElement then
            if item.id[i] == -1 then
                WZUIImage:luaTo(tempElement):setFile(WndBattleHud.SKILL_ITEM_LOCK_PATH)
                tempElement:setVisible(true)
                tempElement:setScale(0.5)
                img:setVisible(false)
            elseif item.id[i] == 0 or self.m_tUseKMSkill[i] <= 0 then
                tempElement:setScale(1)
                tempElement:setVisible(false)
                img:setVisible(false)
            else
                tempElement:setScale(1)
                local point = math.ceil(item.consumePower[i]/1000)
                txt:setText(point)
                local bPFNotAllow = self.m_tMyHero:getUseKMSkillTime() >= 1 or bForceClose--or WBattleGlobal:getCurrent():getCurrentCharacterId() ~= self.m_tMyHero:getBattleId()) --self.m_tMyHero:getPF() < item.consumePower[i]

                --WZLog("WndBattleHud:resetKMSkill one", point, self.m_nUsePoint, tostring(TeachGroup1.ISFIRSTBATTLE), tostring(self.m_tMyHero))
                WZLog("WndBattleHud:resetKMSkill one", self.m_tUseKMSkill[i])
                local x,y = 0.7,0.2
                if self.m_tUseKMSkill[i]<=0 then
                    WZLog("WndBattleHud:resetKMSkill two-1")
                    tempElement:setVisible(false)
                elseif TeachGroup1.ISFIRSTBATTLE == nil and self.m_tMyHero and (bPFNotAllow or self.m_tMyHero.m_nDebuffSealRound or 
                    self.m_tMyHero:isInBuffState(EffectTypeConfig.LIMIT_USE_ITEM) or 
                    self.m_tMyHero:isInBuffState(EffectTypeConfig.LIMIT_ONLY_TIMES_SHOOT) or 
                    self.m_tMyHero:isInBuffState(EffectTypeConfig.LIMIT_ONLY_TIMES_SHOOT_MOVE) or
                    self.m_tMyHero:isInBuffState(EffectTypeConfig.LIMIT_ONLY_SCATTER_TIMES_SHOOT) or
                    isGet or
                    self.m_nUsePoint + point > 10) then
                WZLog("WndBattleHud:resetKMSkill two-2", item.lv[i], img:getChildByTag(987) and img:getChildByTag(987):getFile())
                    local img = WZUIImage:luaTo(tempElement)
                    img:setFile(item.icon[i])
                    img:setColor(GlobalMethod:ccc3(100,100,100))

                    self.m_tKMSkillTouchMark[i] = false  --可以触摸长按，弹出道具tips
                    img:setVisible(true)

                    if tostring(item.lv[i]) ~= "-1" then
                        if img:getChildByTag(987) == nil or img:getChildByTag(987).getFile == nil or img:getChildByTag(987):getFile() ~= item.lv[i] then
                            if img:getChildByTag(987) and img:getChildByTag(987).removeFromParentAndCleanup then
                                img:getChildByTag(987):removeFromParentAndCleanup(true)
                            end
                            local lv = WZUIImage:create()
                            lv:setUseOriginSize(true)
                            lv:setFile(item.lv[i])
                            lv:setRelativePositionLuaTo(x,y)
                            img:addChild(lv,0,987)
                        end
                    elseif tostring(item.lv[i]) == "-1" and img:getChildByTag(987) then
                        img:getChildByTag(987):removeFromParentAndCleanup(true)
                    end
                elseif self.m_tMyHero and self.m_tMyHero:isInBuffState(EffectTypeConfig.LIMIT_ONLY_FLY_MOVE) then
                    WZLog("WndBattleHud:resetKMSkill two-3")
                    if item.id[i] == BattleHeroUse.ITEM_FLY then
                        WZLog("WndBattleHud:resetKMSkill two-3-1", tostring(item.lv[i]) ~= "-1")
                        local pngPath = item.icon[i]
                        local img = WZUIImage:luaTo(tempElement)
                        img:setColor(GlobalMethod:ccc3(255,255,255))
                        img:setFile(pngPath)
                        img:setVisible(true)
                        img:setTouchEnable(true)

                        if tostring(item.lv[i]) ~= "-1" then
                            if img:getChildByTag(987) == nil or img:getChildByTag(987).getFile == nil or img:getChildByTag(987):getFile() ~= item.lv[i] then
                                if img:getChildByTag(987) and img:getChildByTag(987).removeFromParentAndCleanup then
                                    img:getChildByTag(987):removeFromParentAndCleanup(true)
                                end
                                local lv = WZUIImage:create()
                                lv:setUseOriginSize(true)
                                lv:setFile(item.lv[i])
                                lv:setRelativePositionLuaTo(x,y)
                                img:addChild(lv,0,987)
                            end
                        elseif tostring(item.lv[i]) == "-1" and img:getChildByTag(987) then
                            img:getChildByTag(987):removeFromParentAndCleanup(true)
                        end
                    else
                        WZLog("WndBattleHud:resetKMSkill two-3-2", tostring(item.lv[i]) ~= "-1")
                        local img = WZUIImage:luaTo(tempElement)
                        img:setColor(GlobalMethod:ccc3(100,100,100))
                        img:setFile(item.icon[i])
                        img:setTouchEnable(false)
                    --    WZLog("ItemItemItemItem 22222222")
                        if tostring(item.lv[i]) ~= "-1" then
                            if img:getChildByTag(987) == nil or img:getChildByTag(987).getFile == nil or img:getChildByTag(987):getFile() ~= item.lv[i] then
                                if img:getChildByTag(987) and img:getChildByTag(987).removeFromParentAndCleanup then
                                    img:getChildByTag(987):removeFromParentAndCleanup(true)
                                end
                                local lv = WZUIImage:create()
                                lv:setUseOriginSize(true)
                                lv:setFile(item.lv[i])
                                lv:setRelativePositionLuaTo(x,y)
                                img:addChild(lv,0,987)
                            end
                        elseif tostring(item.lv[i]) == "-1" and img:getChildByTag(987) then
                            img:getChildByTag(987):removeFromParentAndCleanup(true)
                        end
                    end

                else
                    WZLog("WndBattleHud:resetKMSkill two-4")
                    if TeachGroup1.ISFIRSTBATTLE == nil and item.id[i] == BattleHeroUse.ITEM_FLY and self.m_tMyHero and self.m_tMyHero:isInBuffState(EffectTypeConfig.LIMIT_FLY) then
                        WZLog("WndBattleHud:resetKMSkill two-4-1", tostring(item.lv[i]) ~= "-1")
                        local img = WZUIImage:luaTo(tempElement)
                        img:setColor(GlobalMethod:ccc3(100,100,100))
                        img:setFile(item.icon[i])
                        img:setTouchEnable(false)
                    --    WZLog("ItemItemItemItem 3333333")
                        if tostring(item.lv[i]) ~= "-1" then
                            if img:getChildByTag(987) == nil or img:getChildByTag(987).getFile == nil or img:getChildByTag(987):getFile() ~= item.lv[i] then
                                if img:getChildByTag(987) and img:getChildByTag(987).removeFromParentAndCleanup then
                                    img:getChildByTag(987):removeFromParentAndCleanup(true)
                                end
                                local lv = WZUIImage:create()
                                lv:setUseOriginSize(true)
                                lv:setFile(item.lv[i])
                                lv:setRelativePositionLuaTo(x,y)
                                img:addChild(lv,0,987)
                            end
                        elseif tostring(item.lv[i]) == "-1" and img:getChildByTag(987) then
                            img:getChildByTag(987):removeFromParentAndCleanup(true)
                        end
                    else
                        --new UI
                        WZLog("WndBattleHud:resetKMSkill two-4-2", tostring(item.lv[i]) ~= "-1", item.icon[i], "item.lv[i]", item.lv[i])
                        local pngPath = item.icon[i]
                        local img = WZUIImage:luaTo(tempElement)
                        img:setColor(GlobalMethod:ccc3(255,255,255))
                        img:setFile(pngPath)
                        img:setVisible(true)
                        img:setTouchEnable(true)

                        if tostring(item.lv[i]) ~= "-1" then
                            if img:getChildByTag(987) == nil or img:getChildByTag(987).getFile == nil or img:getChildByTag(987):getFile() ~= item.lv[i] then
                                if img:getChildByTag(987) and img:getChildByTag(987).removeFromParentAndCleanup then
                                    img:getChildByTag(987):removeFromParentAndCleanup(true)
                                end
                                local lv = WZUIImage:create()
                                lv:setUseOriginSize(true)
                                lv:setFile(item.lv[i])
                                lv:setRelativePositionLuaTo(x,y)
                                img:addChild(lv,0,987)
                            end
                        elseif tostring(item.lv[i]) == "-1" and img:getChildByTag(987) then
                            img:getChildByTag(987):removeFromParentAndCleanup(true)
                        end
                    end
                end
            end
        end
    end
end

--@brief    被updateTurnTime调用刷新武器技能状态方法
function WndBattleHud:updateTurnTime_Skill(dt)
    local skill = WBattleGlobal:getCurrent().m_tMySkill_Beginning

    if WBattleGlobal:getCurrent():isAudience() and WBattleGlobal:getCurrent():getCurrentCharacterId() then
        skill =  WBattleGlobal:getCurrent().m_tHudSkill[WBattleGlobal:getCurrent():getCurrentCharacterId()]
    end

    if skill == nil then
        skill = WBattleGlobal:getCurrent().m_tMySkill_Beginning
    end

    --技能列表
    local skillList = {} 
    for i=1,skill.count do
        table.insert(skillList,skill.id[i])
    end

    local count = 0
    local list = self:getMyHero().m_tSkillCdList

    if WBattleGlobal:getCurrent():isAudience() and WBattleGlobal:getCurrent():getCurrentCharacter() then
        list = WBattleGlobal:getCurrent():getCurrentCharacter().m_tSkillCdList
    end

    if list == nil then
        list = WBattleGlobal:getCurrent().m_tMySkill_Beginning
    end

    for i,v in pairs(list) do
        --过滤在cd列表的技能
        for k = #skillList,1,-1 do
            if skillList[k] == i then
                table.remove(skillList,k)
            end
        end
        local pos = self:getMySkillPos(i)
        count = count + 1
        if pos then

            local prog,txtProg = WndBattleHud:getSkillClipCell(pos)
            local skill = WBattleGlobal:getCurrent():getSkillById(i)
            local percentPro = prog:getPercentage()
            if TeachGroup1.ISFIRSTBATTLE and WBattleGlobal:getCurrent().m_nTurnTimes > 2 then
                prog:setPercentage(0)
                txtProg:setVisible(false)
            elseif prog:getPercentage() > 0 then
                local time = 0
                if skill.isNoFirst == nil then
                    time = WBattleGlobal:getCurrent():getSkillById(i).startCoolSkillTime
                else
                    time = WBattleGlobal:getCurrent():getSkillById(i).coolSkillTime
                end
                local coolSkillTime = BattleCtbManager:convertCtbToTime(time)
                local coolSkillTimePro = coolSkillTime
                if coolSkillTime > 1 then
                    coolSkillTime = prog:getPercentage()/100 * coolSkillTime/ 1000

                    coolSkillTime = coolSkillTime < 0.1 and coolSkillTime > 0 and 0.1 or coolSkillTime
                    txtProg.m_nTxetPre = txtProg:getText()
                    local txt =string.format("%.1f", coolSkillTime)
                    if txt ~= txtProg.m_nTxetPre then
                        txtProg:setText(txt)
                    --    WZLog("WndBattleHud:updateMySkillCtb one-3",count,pos,i,v, percentPro, prog:getPercentage(), coolSkillTimePro, coolSkillTime, time, tostring(skill.isNoFirst))
                    end
                    --WZLog("WndBattleHud:updateMySkillCtb one-01",i,pos)

                    local tempElement
                    if pos ~= -1 then
                        tempElement = self:getSkillCell(pos)
                    else
                        tempElement = GetElement(self.m_root,"imgFly_WndBattleHud",WZUIImage)
                    end
                    local img = WZUIImage:luaTo(tempElement)
                    if img then
                        img:setColor(GlobalMethod:ccc3(100,100,100))
                        img:setTouchEnable(false)
                        --WZLog("WndBattleHud:updateMySkillCtb one-02",i,pos)
                    end
                else
                    txtProg:setVisible(false)

                    --WZLog("WndBattleHud:updateMySkillCtb one-03",i,v, prog:getPercentage(), coolSkillTime, time, tostring(skill.isNoFirst), Serialize(WBattleGlobal:getCurrent():getSkillById(i)))
                    skill.isNoFirst = true
                end
                if true then
                    --WZLog("WndBattleHud:updateMySkillCtb one-1",count,pos,i,v, percentPro, prog:getPercentage(), coolSkillTimePro, coolSkillTime, time, tostring(skill.isNoFirst))
                end
            elseif txtProg:isVisible() == true or skill.isNoFirst == nil then
                txtProg:setVisible(false)
                skill.isNoFirst = true
            --    WZLog("WndBattleHud:updateMySkillCtb one-2",count,i,v, prog:getPercentage())
            end

        end
    end
    
    for i,v in pairs(skillList) do
        local pos = self:getMySkillPos(v)
        if pos then
            local prog,txtProg = WndBattleHud:getSkillClipCell(pos)
            if txtProg:isVisible() == true then
                txtProg:setVisible(false)
            end
        end
    end
end

--@brief    被updateTurnTime调用刷新道具状态方法
function WndBattleHud:updateTurnTime_Item(dt)
    local skill = WBattleGlobal:getCurrent().m_tMyProp_Beginning

    if WBattleGlobal:getCurrent():isAudience() and WBattleGlobal:getCurrent():getCurrentCharacterId() then
        skill =  WBattleGlobal:getCurrent().m_tHudItem[WBattleGlobal:getCurrent():getCurrentCharacterId()]
    end

    if skill == nil then
        skill = WBattleGlobal:getCurrent().m_tMyProp_Beginning
    end

    --技能列表
    local skillList = {} 
    for i=1,skill.count do
        table.insert(skillList,skill.id[i])
    end

    local count = 0
    local list = self:getMyHero().m_tItemCdList

    if WBattleGlobal:getCurrent():isAudience() and WBattleGlobal:getCurrent():getCurrentCharacter() then
        list = WBattleGlobal:getCurrent():getCurrentCharacter().m_tItemCdList
    end

    if list == nil then
        list = WBattleGlobal:getCurrent().m_tMyProp_Beginning
    end

    for i,v in pairs(list) do
        --过滤在cd列表的技能
        for k = #skillList,1,-1 do
            if skillList[k] == i then
                table.remove(skillList,k)
            end
        end
        local pos = self:getMyItemPos(i)
        count = count + 1
        if pos then
            local prog = WndBattleHud:getItemClipCell(pos)
            local skill = WBattleGlobal:getCurrent():getItemById(i)
            local percentPro = prog:getPercentage()
            if prog:getPercentage() > 0 then
                local tempElement
                if pos ~= -1 then
                    tempElement = self:getItemCell(pos)
                end
                local img = WZUIImage:luaTo(tempElement)
                if img then
                    img:setColor(GlobalMethod:ccc3(100,100,100))
                    img:setTouchEnable(false)
                end
            end
        end
    end
end

--@brief    被updateTurnTime调用刷新辅助技能状态方法
function WndBattleHud:updateTurnTime_KMSkill(dt)
    -- body
    local skill = WBattleGlobal:getCurrent().m_tMyKMSkill_Beginning

    if WBattleGlobal:getCurrent():isAudience() and WBattleGlobal:getCurrent():getCurrentCharacterId() then
        skill =  WBattleGlobal:getCurrent().m_tHudKMSkill[WBattleGlobal:getCurrent():getCurrentCharacterId()]
    end

    if skill == nil then
        skill = WBattleGlobal:getCurrent().m_tMyKMSkill_Beginning
    end

    --技能列表
    local skillList = {} 
    for i=1,skill.count do
        table.insert(skillList,skill.id[i])
    end

    local count = 0
    local list = self:getMyHero().m_tKMSkillCdList

    if WBattleGlobal:getCurrent():isAudience() and WBattleGlobal:getCurrent():getCurrentCharacter() then
        list = WBattleGlobal:getCurrent():getCurrentCharacter().m_tKMSkillCdList
    end

    if list == nil then
        list = WBattleGlobal:getCurrent().m_tMyKMSkill_Beginning
    end

    for i,v in pairs(list) do
        --过滤在cd列表的技能
        for k = #skillList,1,-1 do
            if skillList[k] == i then
                table.remove(skillList,k)
            end
        end
        local pos = self:getMyKMSkillPos(i)
        count = count + 1
        if pos then
            local prog = WndBattleHud:getKMSkillClipCell(pos)
            local skill = WBattleGlobal:getCurrent():getKMSkillById(i)
            local percentPro = prog:getPercentage()
            if prog:getPercentage() > 0 then
                local tempElement
                if pos ~= -1 then
                    tempElement = self:getKMSkillCell(pos)
                end
                local img = WZUIImage:luaTo(tempElement)
                if img then
                    img:setColor(GlobalMethod:ccc3(100,100,100))
                    img:setTouchEnable(false)
                end
            end
        end
    end
end

--@brief    设置助战技的显示与否
function WndBattleHud:_setKMSkillShowState()
    -- body
    if CheckButtonOpen(SKILL_ASSISTSKILL, false) then 
        if not WBattleGlobal:getCurrent():isDigGappingFighting() and not WBattleGlobal:getCurrent():isArenaZLSStage() then 
            GetElement(self.m_root, "conKMSkillSeat_WndBattleHud", WZUIContainer):setVisible(true)
            GetElement(self.m_root, "conKMSkill_WndBattleHud", WZUIContainer):setVisible(true)
            GetElement(self.m_root, "conKMSkillClip_WndBattleHud", WZUIContainer):setVisible(true)
            GetElement(self.m_root, "conKMSkillCost_WndBattleHud", WZUIContainer):setVisible(true)
        end
    end
    --挖坑赛禁止飞行
    if WBattleGlobal:getCurrent():isDigGappingFighting() then 
        tmpCon = GetElement(self.m_root, "conFly_WndBattleHud", WZUIContainer)
        tmpCon:setVisible(false)
    end
end


--@brief    点击皮肤大招靶子确认按钮
function WndBattleHud:onClickBigSkillTarget(bShow)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndBattleHud:getTargetRangeElement():setVisible(false)

    local allow = WBattleGlobal:getCurrent():isWaitNextRound() == false
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(WBattleGlobal:getCurrent().m_nCurrentPlayerId)
    if hero:getUseSkinBigSkill() and (hero:getSkinBigSkill() == 3030 or hero:getSkinBigSkill() == 3046 or hero:getSkinBigSkill() == 3059) and allow then
        local tSkinBigSkillTargetPos = WBattleGlobal:getCurrent().m_tSkinBigSkillTargetPos

        local msg = MsgManager:createMsg(BattleMsgPlayerShoot)
        msg.m_nBattleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
        msg.m_nPlayerId = WBattleGlobal:getCurrent():getMyBattleId()
        msg.m_nCurrentPlayerId = WBattleGlobal:getCurrent():getMyBattleId()
        msg.m_nSpeedx = 0
        msg.m_nSpeedy = 0
        local startPos = hero:getPosition()

        WBattleGlobal:getCurrent().m_bIsPlayerOperateAlready = true
      
        if hero:getAnimation():isFlipX() then
            msg.m_nLeftRight = 1
        else
            msg.m_nLeftRight = 0
        end
        msg.m_nStartX = tSkinBigSkillTargetPos.x
        msg.m_nStartY = SceneBattle:getFrontLayerSize().height
        msg.m_nEndX = tSkinBigSkillTargetPos.x
        msg.m_nEndY = tSkinBigSkillTargetPos.y
        if TeachGroup1.ISBATTLE_MYTURN ~= true then
            MsgManager:pushBlockMsg(msg)
        end

        WndBattleHud:setMyHudSwitchEnable(false)
        WndBattleHud:setMyHudShow(false)
        WndBattleHud:endTurnTime()
    end
end

--@brief    获取大招靶子节点
function WndBattleHud:getTargetRangeElement()
    return GetElement(self.m_root,"conTargetRange_WndBattleHud",WZUIContainer)
end

--@brief    获取大招靶子节点
function WndBattleHud:getBigSkillTargetElement()
    return GetElement(self.m_root,"conBigSkillTarget_WndBattleHud",WZUIContainer)
end

--@brief    设置皮肤大招靶子位置
--@brief    tPos:在WndBattleHud上的坐标
function WndBattleHud:setBigSkillTargetPos(tPos)
    -- local tNewPos = SceneBattle:getFrontLayer():convertToNodeSpace(GlobalMethod:ccp(tPos.x,tPos.y))
    local tNewPos = WndBattleHud:getTargetRangeElement():convertToWorldSpace(GlobalMethod:ccp(tPos.x,tPos.y))
    tNewPos = SceneBattle:getFrontLayer():convertToNodeSpace(GlobalMethod:ccp(tNewPos.x,tNewPos.y))
    WndBattleHud:updateBigSkillTargetPos(tNewPos)
end

--@brief    更新皮肤大招靶子在WndBattleHud上的位置
--@brief    tPos:地图上的坐标
function WndBattleHud:updateBigSkillTargetPos(tPos)
    tPos = tPos or WBattleGlobal:getCurrent().m_tSkinBigSkillTargetPos
    if tPos == nil then
        return
    end
    local conBigSkillTarget = WndBattleHud:getBigSkillTargetElement()

    WBattleGlobal:getCurrent().m_tSkinBigSkillTargetPos = tPos

    local point = SceneBattle:getFrontLayer():convertToWorldSpace(GlobalMethod:ccp(tPos.x,tPos.y))
    point = WndBattleHud:getTargetRangeElement():convertToNodeSpace(point)

    conBigSkillTarget:setAbsPosition(GlobalMethod:ccp(point.x,point.y))
end


--@brief    获取存放高亮元素的表
function WndBattleHud:getBrightnessElement()
    return self.m_tBrightnessElement
end

--@brief    获取存放阴影中敌人按钮的表
function WndBattleHud:getBtnEnemyElement()
    return self.m_tBtnEnemyElement
end

--@brief    获取存放敌人按钮的阴影层
function WndBattleHud:getBigSkillShadedElement()
    return GetElement(self.m_root,"conBigSkillShaded_WndBattleHud",WZUIContainer)
end

--@brief    把WndBattleHud中conBigSkillShaded_WndBattleHud容器上坐标转化为前景层上的坐标
--@brief    tPos:在WndBattleHud上的坐标
function WndBattleHud:convertHudPosToFrontPos(tPos)
    local tNewPos = WndBattleHud:getBigSkillShadedElement():convertToWorldSpace(GlobalMethod:ccp(tPos.x,tPos.y))
    tNewPos = SceneBattle:getFrontLayer():convertToNodeSpace(GlobalMethod:ccp(tNewPos.x,tNewPos.y))
    return tNewPos
end

--@brief    点击敌人
function WndBattleHud:onClickEnemy(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tag = element:getTag()
    local enemy = WBattleGlobal:getCurrent():getCharacterWithId(tag)

    if WBattleGlobal:getCurrent():getCurrentCharacterId() ~= self.m_tMyHero:getBattleId() or WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle or WBattleGlobal:getCurrent():isWaitNextRound() then
        return
    end

    local hero = WBattleGlobal:getCurrent():getCharacterWithId(WBattleGlobal:getCurrent().m_nCurrentPlayerId)
    if hero:getUseSkinBigSkill() and (hero:getSkinBigSkill() == 3036 or hero:getSkinBigSkill() == 3044 or hero:getSkinBigSkill() == 3051 or hero:getSkinBigSkill() == 3053 or hero:getSkinBigSkill() == 3054 or hero:getSkinBigSkill() == 3065) then
        if hero:getSkinBigSkill() == 3065 then 
            ProtocolProcessorBattleInterface:send_BATTLE_SkillEquip(WBattleGlobal:getCurrent():getBattleId(), hero:getBattleId(), hero:getSkinBigSkill(), nil, nil, nil, tonumber(tag))
        end
        local tSkinBigSkillTargetPos = WBattleGlobal:getCurrent().m_tSkinBigSkillTargetPos

        local msg = MsgManager:createMsg(BattleMsgPlayerShoot)
        msg.m_nBattleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
        msg.m_nPlayerId = WBattleGlobal:getCurrent():getMyBattleId()
        msg.m_nCurrentPlayerId = WBattleGlobal:getCurrent():getMyBattleId()
        msg.m_nSpeedx = 0
        msg.m_nSpeedy = 0
        local startPos = hero:getPosition()

        WBattleGlobal:getCurrent().m_bIsPlayerOperateAlready = true
      
        if hero:getAnimation():isFlipX() then
            msg.m_nLeftRight = 1
        else
            msg.m_nLeftRight = 0
        end
        if hero:getSkinBigSkill() == 3054 then 
            local offset
            if hero:getUseBigSkill() then
                offset = {x = 90, y = 70}
            end
            startPos = BattleCommon:getShootPos(false,hero,offset)
            msg.m_nStartX = startPos.x
            msg.m_nStartY = startPos.y
            msg.m_nBulletEndX = enemy:getPosition().x
            msg.m_nBulletEndY = enemy:getCenterPos().y 
        else
            msg.m_nStartX = enemy:getPosition().x
            msg.m_nStartY = enemy:getPosition().y
        end
        if hero:getSkinBigSkill() == 3065 then 
            msg.m_nChooseTarget = tonumber(tag)
        end
        if hero:getSkinBigSkill() == 3065 then 
            msg.m_nChooseTarget = tonumber(tag)
        end
        if TeachGroup1.ISBATTLE_MYTURN ~= true then
            MsgManager:pushBlockMsg(msg)
        end

        WndBattleHud:setMyHudSwitchEnable(false)
        WndBattleHud:setMyHudShow(false)
        WndBattleHud:endTurnTime()
    end

    WndBattleHud:cleanBigSkillShaded()
end

--@brief    清理大招阴影
function WndBattleHud:cleanBigSkillShaded()
    self.m_tBtnEnemyElement = {}
    self.m_tBrightnessElement = {}
    WndBattleHud:getBigSkillShadedElement():removeAllChildrenWithCleanup(true)
    WindowManager:removeBigSkillShelterLayer()
end

--@brief    显示皮肤大招阴影
function WndBattleHud:showSkinBigSkillShelter(nType)
    nType = nType or 1

    self.m_tBtnEnemyElement = {}
    self.m_tBrightnessElement = {}

    if nType == 1 then --选择敌人
        local shelterLayer = WindowManager:addBigSkillShelterLayer( 600000, 150 )
        GetElement(shelterLayer,"txtChooseTargetTips_TeachShelterLayer",WZUILabelTTF):setText(LocalStrings.BATTLE_HUD_TEXT4)
        for id,guai in pairs(WBattleGlobal:getCurrent():getGuaiList()) do
            if not guai:isDead() then
                local element = guai:getAnimation():getAnimNode()
                local imgBrightness = WindowManager:addBigSkillShelterLight(element, guai)
                imgBrightness:setTag(id)
                table.insert(self.m_tBrightnessElement, imgBrightness)

                --添加敌人按钮,按钮位置和光圈重叠在一起
                local tNewPos = imgBrightness:getParentElement():convertToWorldSpace(GlobalMethod:ccp(imgBrightness:getPositionX(),imgBrightness:getPositionY()))
                tNewPos = WndBattleHud:getBigSkillShadedElement():convertToNodeSpace(GlobalMethod:ccp(tNewPos.x,tNewPos.y))
                local conBigSkillShaded = GetElement(self.m_root,"conBigSkillShaded_WndBattleHud",WZUIContainer)
                local elementSize = element:getContentSize()
                local width = elementSize.width
                local height = elementSize.height
                if width > 300 then 
                    width = 300
                end
                if height > 300 then 
                    height = 300
                end
                local btnEnemy =  WZUIButton:create()
                btnEnemy:setTag(id)
                btnEnemy:setLuaDoneFunctionName("onClickEnemy")
                btnEnemy:setUseAbsSize(true)
                btnEnemy:setAbsContentSize(GlobalMethod:CCSize(width, height))
                btnEnemy:setUseAbsCoordinate(true)
                btnEnemy:setAbsPosition(ccp(tNewPos.x,tNewPos.y))
                conBigSkillShaded:addChild(btnEnemy)

                --创建角色指示箭头
                local sp = CCSprite:create("ui/common/common_top_btn_jiant.png")
                local action =  CCRepeatForever:create(CCJumpBy:create(1,GlobalMethod:ccp(0,0),30,1))
                local arrowLayer = CCLayer:create()
                sp:setPosition(width/2,height)
                sp:setFlipY(true)
                sp:runAction(action)
                arrowLayer:addChild(sp)
                btnEnemy:addChild(arrowLayer,5)

                table.insert(self.m_tBtnEnemyElement,btnEnemy)
            end
        end
        for id,guai in pairs(WBattleGlobal:getCurrent():getHeroList()) do
            if not guai:isDead() and not WBattleGlobal:getCurrent():isMyTeam(id) then
                local element = guai:getAnimation():getAnimNode()
                local imgBrightness = WindowManager:addBigSkillShelterLight(element, guai)
                imgBrightness:setTag(id)
                table.insert(self.m_tBrightnessElement, imgBrightness)

                --添加角色按钮,按钮位置和光圈重叠在一起
                local tNewPos = imgBrightness:getParentElement():convertToWorldSpace(GlobalMethod:ccp(imgBrightness:getPositionX(),imgBrightness:getPositionY()))
                tNewPos = WndBattleHud:getBigSkillShadedElement():convertToNodeSpace(GlobalMethod:ccp(tNewPos.x,tNewPos.y))
                local conBigSkillShaded = GetElement(self.m_root,"conBigSkillShaded_WndBattleHud",WZUIContainer)
                local elementSize = element:getContentSize()
                local btnEnemy =  WZUIButton:create()
                btnEnemy:setTag(id)
                btnEnemy:setLuaDoneFunctionName("onClickEnemy")
                btnEnemy:setUseAbsSize(true)
                btnEnemy:setAbsContentSize(elementSize)
                btnEnemy:setUseAbsCoordinate(true)
                btnEnemy:setAbsPosition(ccp(tNewPos.x,tNewPos.y))
                conBigSkillShaded:addChild(btnEnemy)

                --创建角色指示箭头
                local sp = CCSprite:create("ui/common/common_top_btn_jiant.png")
                local action =  CCRepeatForever:create(CCJumpBy:create(1,GlobalMethod:ccp(0,0),30,1))
                local arrowLayer = CCLayer:create()
                sp:setPosition(elementSize.width/2,elementSize.height)
                sp:setFlipY(true)
                sp:runAction(action)
                arrowLayer:addChild(sp)
                btnEnemy:addChild(arrowLayer,5)

                table.insert(self.m_tBtnEnemyElement,btnEnemy)
            end
        end
    elseif nType == 2 then --选择队友
        local shelterLayer = WindowManager:addBigSkillShelterLayer( 600000, 150 )
        GetElement(shelterLayer,"txtChooseTargetTips_TeachShelterLayer",WZUILabelTTF):setText(LocalStrings.BATTLE_HUD_TEXT5)
        for id,guai in pairs(WBattleGlobal:getCurrent():getHeroList()) do
            if not guai:isDead() and WBattleGlobal:getCurrent():isMyTeam(id) then
                local element = guai:getAnimation():getAnimNode()
                local imgBrightness = WindowManager:addBigSkillShelterLight(element, guai)
                imgBrightness:setTag(id)
                table.insert(self.m_tBrightnessElement, imgBrightness)

                --添加角色按钮,按钮位置和光圈重叠在一起
                local tNewPos = imgBrightness:getParentElement():convertToWorldSpace(GlobalMethod:ccp(imgBrightness:getPositionX(),imgBrightness:getPositionY()))
                tNewPos = WndBattleHud:getBigSkillShadedElement():convertToNodeSpace(GlobalMethod:ccp(tNewPos.x,tNewPos.y))
                local conBigSkillShaded = GetElement(self.m_root,"conBigSkillShaded_WndBattleHud",WZUIContainer)
                local elementSize = element:getContentSize()
                local btnEnemy =  WZUIButton:create()
                btnEnemy:setTag(id)
                btnEnemy:setLuaDoneFunctionName("onClickEnemy")
                btnEnemy:setUseAbsSize(true)
                btnEnemy:setAbsContentSize(elementSize)
                btnEnemy:setUseAbsCoordinate(true)
                btnEnemy:setAbsPosition(ccp(tNewPos.x,tNewPos.y))
                conBigSkillShaded:addChild(btnEnemy)

                --创建角色指示箭头
                local sp = CCSprite:create("ui/common/common_top_btn_jiant.png")
                local action =  CCRepeatForever:create(CCJumpBy:create(1,GlobalMethod:ccp(0,0),30,1))
                local arrowLayer = CCLayer:create()
                sp:setPosition(elementSize.width/2,elementSize.height)
                sp:setFlipY(true)
                sp:runAction(action)
                arrowLayer:addChild(sp)
                btnEnemy:addChild(arrowLayer,5)

                table.insert(self.m_tBtnEnemyElement,btnEnemy)
            end
        end
    end
end

--@brief    新手boss显示跳过新手按钮
function WndBattleHud:_showSkipTeachBtn()
    local skipGuide = CacheCenter:getGameParam().skipGuide or "0"
    local btnSkipTeach = GetElement(self.m_root,"btnSkipTeach_WndBattleHud",WZUIButton)
    if btnSkipTeach then
        if TeachGroup1.ISFIRSTBATTLE then
            btnSkipTeach:setVisible(true)
        else
            btnSkipTeach:setVisible(false)
        end
    end
end


--@brief    新手boss显示跳过新手按钮
function WndBattleHud:onClickSkipTeach(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    MsgBoxManager:showConfirmCancelBox(LocalStrings.TEACH_SKIP_TEXT2, self, self.sureSkipTeach)
end

--@brief    确认跳过新手
--@param    nId:消息id
--@param    nResType:响应类型(超时，确定，取消)
function WndBattleHud:sureSkipTeach(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        g_bIsFirstBattleEnd = true
        TeachGroup1:setTeachFinish(0,-1)
        TeachGroup1.ISNOTEACH = true
        TeachGroup1:endFirstBattleTeach()
        if PassportSdkManager and PassportSdkManager.postGameInfoVn then
            PassportSdkManager:postGameInfoVn("tutorial_skip","")--跳过新手指引 
        end
    end
end

--@brief    点击禁止发言按钮回调
function WndBattleHud:onTalkLimit(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    GetElement(self.m_root, "conTalkLimit_WndBattleHud", WZUIContainer):setVisible(true)
    if g_nEnemyTalkLimit then 
        GetElement(self.m_root, "checkTalk1_WndBattleHud", WZUICheckBox):setCheckIndex(g_nEnemyTalkLimit)
    end
    if g_nTeamTalkLimit then 
        GetElement(self.m_root, "checkTalk2_WndBattleHud", WZUICheckBox):setCheckIndex(g_nTeamTalkLimit)
    end
end

--@brief    
function WndBattleHud:checkPointInBtn(pt)
    -- body
    local btn
    btn = GetElement(self.m_root, "conTalkLimit_WndBattleHud", WZUIContainer)
    if btn then
        local btnSize = btn:getContentSize()
        --获得btn的世界坐标
        local ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
        if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
            return true
        end 
    end
    
    return false 
end

--@brief    点击屏蔽发言复选框回调
function WndBattleHud:onChooseTalkLimit(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

    local nTag = element:getTag()
    if nTag == 1 then 
        g_nEnemyTalkLimit = GetElement(self.m_root, "checkTalk1_WndBattleHud", WZUICheckBox):getCheckIndex()

        local _KeyString = ""
        local data = WZDataFile:getInstance():getUserData()
        _KeyString = "EnemyTalkLimit" .. tostring(CacheCenter:getPlayerInfo().id)
       
        local curValue = g_nEnemyTalkLimit
        data:setStringValue("TALK_LIMIT", _KeyString, curValue)
        data:flush()
    elseif nTag == 2 then 
        g_nTeamTalkLimit = GetElement(self.m_root, "checkTalk2_WndBattleHud", WZUICheckBox):getCheckIndex()
        WZLog("WndBattleHud:onChooseTalkLimit", g_nTeamTalkLimit)
        local _KeyString = ""
        local data = WZDataFile:getInstance():getUserData()
        _KeyString = "TeamTalkLimit" .. tostring(CacheCenter:getPlayerInfo().id)
       
        local curValue = g_nTeamTalkLimit
        data:setStringValue("TALK_LIMIT", _KeyString, curValue)
        data:flush()
    end
end

--@brief    设置静态文本
function WndBattleHud:_setStaticText()
    GetElement(self.m_root, "txtTalkLimit1_WndBattleHud", WZUILabelTTF):setText(LocalStrings.BATTLE_TEXT1[1])
    GetElement(self.m_root, "txtTalkLimitSel1_WndBattleHud", WZUILabelTTF):setText(LocalStrings.BATTLE_TEXT1[1])
    GetElement(self.m_root, "txtTalkLimit2_WndBattleHud", WZUILabelTTF):setText(LocalStrings.BATTLE_TEXT1[2])
    GetElement(self.m_root, "txtTalkLimitSel2_WndBattleHud", WZUILabelTTF):setText(LocalStrings.BATTLE_TEXT1[2])
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配begin----------------------------------------
function WndBattleHud:_adaptLanguage_vn()

    -- 越南12+防沉迷图片
    local imgVN = GetElement(self.m_root, "imgVN_WndBattleHud",WZUIImage)
    imgVN:setVisible(true)
    imgVN:setFile("ui/common/12-plus-detail.png")
    --ios审核不显示12+防沉迷图片
    if CacheCenter:getGameParam().gameStatus == "1" then
        imgVN:setVisible(false)
    end

    local txtBigSkillSwitch = GetElement(self.m_root, "txtBigSkillSwitch_WndBattleHud", WZUILabelTTF)
    txtBigSkillSwitch:setScale(0.7)
    txtBigSkillSwitch:setDimensions(GlobalMethod:CCSize(160,0))

    local txtBSDesc = GetElement(self.m_root,"txtBSDesc_WndBattleHud",WZUILabelTTF)
    txtBSDesc:setScale(0.65)
    txtBSDesc:setDimensions(GlobalMethod:CCSize(600,0))
end
-------------------------------------语言适配End----------------------------------------

