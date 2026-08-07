--WndArenaWin.lua
--@brief	WndArenaWin的UI模块
--@date		2015-11-19
--@author	binshao
--@note		竞技场胜利结算


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndArenaWin:onEnter(element)
	self.m_root = element
    -- if ProjConfig.CHANNEL_ID == 1048 or ProjConfig.CHANNEL_ID == 1051 
    --     or ProjConfig.CHANNEL_ID == 1053 then
    --     GetElement(self.m_root,"btnFBShare_WndArenaWin",WZUIButton):setVisible(true)
    -- end
    ProtocolProcessorBattleSettlement:regAll()
    self.m_nCountdown = 8
    self.m_root:enableSchedule("scheduleCountdown", 1)
    
    -- if WBattleGlobal:getCurrent():getMyHero().m_nBoyOrGirl == 0 then
    --     SoundManager:playEffectSound(SoundDefine.E_S_BATTLE_WIN_BOY,false,true)
    -- else
    --     SoundManager:playEffectSound(SoundDefine.E_S_BATTLE_WIN_GIRL,false,true)
    -- end

    SoundManager:playEffectSound(SoundDefine.E_S_BATTLE_WIN)
    self:_update()
    WindowManager:getSceneRoot():removeChildByTag(78945, true)

    if IsIphoneX() then
        local con = GetElement(self.m_root, "conVideo_WndArenaWin", WZUIContainer)
        if con then
            con:setRelativePositionLuaTo(0.97,0.5)
        end
    end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndArenaWin:onExit(element)
    if self.m_root then
        self.m_root:disableSchedule()
    end
	self:_unInit()
    ProtocolProcessorBattleSettlement:unregAll()
end

--@brief	倒计时定时器
--@param	element:定时器绑定的UI节点引用
--@param    delta:时间间隔
function WndArenaWin:scheduleCountdown(element, delta)
    self.m_nCountdown = math.max(self.m_nCountdown - 1, 0)
    if self.m_nCountdown <= 0 then
        self.m_root:disableSchedule()
        self:goback()
    end
end

--@brief    战斗成功分享到Facebook点击事件
function WndArenaWin:onFBShare( element )
    SetFBShareByPackage(1)
end

-- 重播录像
function WndArenaWin:onAgainVideo()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    BattleMsgReplayGameRecord:replayRecord()
end

-- 退出录像
function WndArenaWin:onExitVideo()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    SceneBattle:leftBattle()
end

--@brief	返回
function WndArenaWin:goback()
    WZLog("WndArenaWin:goback")
    if not self.m_root then return end
    local battleMode = WBattleGlobal:getCurrent().m_tMakePairOk.battleMode
    local battleChannel = WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle
    local schedule = WBattleGlobal:getCurrent().m_tMakePairOk.schedule
    if self.isVideo then
        local con = GetElement(self.m_root, "conVideo_WndArenaWin", WZUIContainer)
        con:setVisible(true)
    else
        if battleChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_LS then
            --联赛
            SceneLeagueMain:showInterface()
        elseif battleChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_GZ and (schedule == GlobalGame.g_tSchedule.SCHEDULE_GW_1 or schedule == GlobalGame.g_tSchedule.SCHEDULE_GW_2) then
            ProtocolProcessorBattleSettlement:send_BATTLE_BackToRoom(WBattleGlobal:getCurrent():getMyRoomId())
        else
            SceneCommunityWar:showInterface()
        end
    end
end
-- -----------------------------------公有方法模块End----------------------------------------


-- -----------------------------------私有方法模块Begin--------------------------------------
--@brief	更新界面
function WndArenaWin:_update()
    local athChannel = BattleConstants.g_tBattleChannel.MODE_GUILD      -- 竞技场
    local leagueStartChannel = BattleConstants.g_tBattleChannel.MODE_HERO   -- 联赛开始
    local leagueEndChannel = BattleConstants.g_tBattleChannel.MODE_FINAL_THREE  -- 联赛结束
    
    local meleeChannel = BattleConstants.g_tBattleChannel.BATTLE_CHANNEL_HERO_MELEE_WAR  -- 大乱斗

    local battleChannel = WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle
    local conAth = GetElement(self.m_root, "conAth_WndArenaWin", WZUIContainer)
    local conLeg = GetElement(self.m_root, "conLeague_WndArenaWin", WZUIContainer)
    local conGuild = GetElement(self.m_root, "conGuild_WndArenaWin", WZUIContainer)
    conAth:setVisible(false)
    conLeg:setVisible(false)
    conGuild:setVisible(false)
    if battleChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_DZ or battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_LD then
        WZLog("-----------desc ath---------------")
        conAth:setVisible(true)
        self:createAthPlayerData()
    elseif battleChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_LS then
        WZLog("-----------desc leg---------------")
        conLeg:setVisible(true)
        self:createLegPlayerData()
    elseif WBattleGlobal:getCurrent():isGuildWarStage() then
        WZLog("-----------desc guild---------------")
        conGuild:setVisible(true)
        self:createGuildPlayerData()
    end
    self:createPlayerAni()
end

-- 创建竞技场玩家数据界面
function WndArenaWin:createAthPlayerData()
    for i = 1, #self.winTeam do
        local con = GetElement(self.m_root, "conAthL"..i.."_WndArenaWin", WZUIContainer)
        local cell, tcell = CellArenaInfo:createElement()
        con:addChild(cell)
        tcell:setData(self.winTeam[i])
    end

    for i = 1, #self.failTeam do
        local con = GetElement(self.m_root, "conAthR"..i.."_WndArenaWin", WZUIContainer)
        local cell, tcell = CellArenaInfo:createElement()
        con:addChild(cell)
        tcell:setData(self.failTeam[i])
    end

    -- 图标
    local imgPath = {GDatatab_item["id_13"].icon,GDatatab_item["id_18"].icon}
    for i = 1, 2 do
        local imgScore = GetElement(self.m_root, "imgScore"..i.."_WndArenaWin",WZUIImage)
        -- 图标
        imgScore:setFile(imgPath[1])
        -- 可见
        if g_areaIndex == 2 then
            imgScore:setVisible(false)
        else
            imgScore:setVisible(true)
        end
    end
end

-- 创建英雄联赛玩家数据界面
function WndArenaWin:createLegPlayerData()
    for i = 1, #self.winTeam do
        local con = GetElement(self.m_root, "conLegL"..i.."_WndArenaWin", WZUIContainer)
        local cell, tcell = CellLeagueInfo:createElement()
        con:addChild(cell)
        tcell:setData(self.winTeam[i],false)
    end

    for i = 1, #self.failTeam do
        local con = GetElement(self.m_root, "conLegR"..i.."_WndArenaWin", WZUIContainer)
        local cell, tcell = CellLeagueInfo:createElement()
        con:addChild(cell)
        tcell:setData(self.failTeam[i],true)
    end

    -- 队伍图标和名字
    local temaScore = {self.winScore,self.failScore}
    for i = 1 , 2 do
        local teamInfo = self.teamInfo[i]
        WZLog("-----------teamInfo-----------",teamInfo.url,teamInfo.teamName)
        local celElement,tCell = CellDownloadImg:createElement()
        local conIcon = GetElement(self.m_root, "conIcon"..i.."_WndArenaWin", WZUIContainer)
        conIcon:addChild(celElement)
        SceneLeagueMain:addDownloadFileList(teamInfo.url, tCell, nil, 60)

        local name = GetElement(self.m_root,"txtName"..i.."_WndArenaWin",WZUILabelTTF)
        name:setText(teamInfo.teamName)

        -- 积分
        WZLog("-----------league score---------------",temaScore[i])
        local score = GetElement(self.m_root,"txtScore"..i.."_WndArenaWin",WZUILabelTTF)
        local str = temaScore[i] >= 0 and "+"..temaScore[i] or temaScore[i]
        score:setText(str)
    end
end

-- 创建公会战玩家数据界面
function WndArenaWin:createGuildPlayerData()
    for i = 1, #self.winTeam do
        local con = GetElement(self.m_root, "conGuildL"..i.."_WndArenaWin", WZUIContainer)
        local cell, tcell = CellCommunityInfo:createElement()
        con:addChild(cell)
        tcell:setData(self.winTeam[i],false)
    end

    for i = 1, #self.failTeam do
        local con = GetElement(self.m_root, "conGuildR"..i.."_WndArenaWin", WZUIContainer)
        local cell, tcell = CellCommunityInfo:createElement()
        con:addChild(cell)
        tcell:setData(self.failTeam[i],true)
    end

    -- 公会名字和公会战斗index
    local name1,name2 = self.winTeam[1].guildName,self.failTeam[1].guildName
    local index1,index2 = self.winTeam[1].guildIndex,self.failTeam[1].guildIndex
    WZLog("-------------guild wnd win------------name1,name2",name1,name2)
    WZLog("-------------guild wnd win------------index1,index2",index1,index2)
    local teamName = {name1,name2 }
    local teamIndex = {index1,index2}
    for i = 1 , 2 do
        local name = GetElement(self.m_root,"txtGuildName"..i.."_WndArenaWin",WZUILabelTTF)
        name:setText(teamName[i])

        local lafIndex = GetElement(self.m_root,"lafTeamIndex"..i.."_WndArenaWin",WZUILabelAtlasFont)
        lafIndex:setText(teamIndex[i])
    end
    --如果是出线和入围赛，不显示队标
    local schedule = WBattleGlobal:getCurrent().m_tMakePairOk.schedule

    if schedule == GlobalGame.g_tSchedule.SCHEDULE_GW_1 or schedule == GlobalGame.g_tSchedule.SCHEDULE_GW_2 then
        GetElement(self.m_root, "conTeamLeft_WndArenaWin", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "conTeamRight_WndArenaWin", WZUIContainer):setVisible(false)
    end
end

-- 创建玩家动画
function WndArenaWin:createPlayerAni()
    local conPW,conPH = 100,200
    local winPlayerCnt = #self.winTeam
    for i = 1 , #self.playerCon do
        local aniPlayer,aniNode = self:_createPlayerFigure(self.playerCon[i])
        if aniPlayer and aniNode then
            local add = 0
            local imgDi = GetElement(self.m_root,"imgPlayerDi"..i.."_WndArenaWin",WZUIImage)
            if i > winPlayerCnt then
                add = 120
                aniPlayer:play("failure", true)
                aniPlayer:setFlipX(true)
                imgDi:setRelativePosition(GlobalMethod:ccp(0.6,0.04))
            else
                aniPlayer:play("win", true)
                aniPlayer:setFlipX(false)
                imgDi:setRelativePosition(GlobalMethod:ccp(0.5,0.02))
            end

            local tmpCon = WZUIContainer:create()
            tmpCon:setRelativePosition(GlobalMethod:ccp(0.5,0.4))
            tmpCon:setUseAbsSize(true)
            tmpCon:setAbsContentSize(GlobalMethod:CCSize(96,96))
            tmpCon:addChild(aniNode)


            local conP = GetElement(self.m_root,"conPlayer"..i.."_WndArenaWin",WZUIContainer)
            conP:setVisible(true)
            conP:addChild(tmpCon)
            conP:setPosition(ccp((i-1)*(conPW)+add,0))

            -- 脚部圈
            if self.playerCon[i].playerId == WBattleGlobal:getCurrent().m_tMakePairOk.selfId then--CacheCenter:getPlayerInfo().id then
                local arm = GetElement(self.m_root,"armBase"..i.."_WndArenaWin",WZArmature)
                arm:setVisible(true)
            end
        end
    end
    local size = CCDirector:sharedDirector():getWinSize()
    local con = GetElement(self.m_root,"conPlayer_WndArenaWin",WZUIContainer)
    con:setContentSize(CCSize(#self.playerCon*conPW+120,150))
end


--@brief	创建玩家形象
function WndArenaWin:_createPlayerFigure(tData)
    WZLog("WndArenaWin:_createPlayerFigure", tData.sex)
    if tData.sex then
        WZLog("WndArenaWin:_createPlayerFigure two", tData.faceId, tData.headId, tData.bodyId, tData.wingId, tData.weaponId)
        local tEquip = {tData.faceId, tData.headId, tData.bodyId, tData.wingId, tData.weaponId}
        local aniPlayer = CreatePlayerFigure(tData.sex, tEquip, nil,nil,nil,nil,nil,nil,false,nil,tData.headColor,tData.bodyColor)
        local aniNode = aniPlayer:getAnimNode()
        aniPlayer:setScale(0.64)
        -- aniNode:setRelativePositionLuaTo(0.5, 0.07)

        return aniPlayer,aniNode
    end

    return false,false
end



-- 胜利特效
function WndArenaWin:OnPlayerParCallBack()
    local parPath = {
        {"ui_jiesuan_fashelihua_01.plist", "ui_jiesuan_fashelihua_02.plist", "ui_jiesuan_fashelihua_03.plist","ui_jiesuan_fashelihua_04.plist" },
        {"ui_jiesuan_lihua_01.plist", "ui_jiesuan_lihua_02.plist", "ui_jiesuan_lihua_03.plist","ui_jiesuan_lihua_04.plist"}
    }
    local con = {"conPar1_WndArenaWin","conPar2_WndArenaWin" }
    for i = 1, 2 do
        local con = GetElement(self.m_root, con[i], WZUIContainer)
        for k = 1, 4 do
            local backFire = CCParticleSystemQuad:create("particle/"..parPath[i][k])
            backFire:setAutoRemoveOnFinish(true)
            con:addChild(backFire)
        end
    end
end
----------------------------------私有方法模块End----------------------------------------