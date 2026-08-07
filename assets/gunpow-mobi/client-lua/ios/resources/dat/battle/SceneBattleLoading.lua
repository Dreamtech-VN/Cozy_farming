
--SceneBattleLoading.lua
--@brief	SceneBattleLoading的UI模块
--@date		2014/01/08
--@author	李光森
--@note		战斗载入场景

-------------------------------------公有方法模块Begin--------------------------------------
--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function SceneBattleLoading:onEnter(element)
    --ctb数据初始化
    BattleCtbManager:_init()
    --战斗录像数据获取
    BattleMsgReplayGameRecord:checkReplayConfig()
    g_tSingCopyOver = nil
	--战斗加载界面断线需要直接弹出提示
	ChangeChatChannel(Chat_Channel_Loadding)
	IPDConnector.g_nNetConnectFlag = NET_FLAG_7
    local sSkillSubType = CacheCenter:getGameParam().trenchMatchNoCDSkill
    WZLog("SceneBattleLoading:onEnter", sSkillSubType, type(sSkillSubType))
    self.m_tNoCoolTimeSubType = SplitStringWithSeparator(sSkillSubType, ",", nil, true)
    --WBattleGlobal:getCurrent().m_bIsAudience = true

    if GlobalGame.g_singleCopyData then
        WZLog("SceneBattleLoading:onEnter 2222")
        WBattleGlobal:getCurrent().m_tMakePairOk = CopyTable(GlobalGame.g_singleCopyData)
        WBattleGlobal:getCurrent().m_nBattleType = BattleConstants.g_nBATTLE_TYPE_BOSS
        GlobalGame.g_singleCopyData = nil
    end

    --战斗记录
    if  WBattleGlobal:getCurrent():isReplayGame() then
        local msg = MsgManager:createMsg(BattleMsgReplayGame)
        MsgManager:pushNonBlockMsg(msg)
    else
        WBattleGlobal:getCurrent().m_tMakePairOk.selfId = CacheCenter:getPlayerInfo().id
    end

    if WBattleGlobal:getCurrent():isAudience() then
        local index = 1
        for i=1,6 do
            local camp = WBattleGlobal:getCurrent().m_tMakePairOk.playerCamp[i]
            if camp == 0 then
                index = i
                break
            end
        end
        WBattleGlobal:getCurrent().m_tMakePairOk.selfId = WBattleGlobal:getCurrent().m_tMakePairOk.playerId[index]
    end

    --英雄联赛
    if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_NORMAL and WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_LS then
        local indexSelf = -1
        local campSelf = -1

        local makePairOk = WBattleGlobal:getCurrent().m_tMakePairOk
        for i=1,6 do
            local playerId = makePairOk.playerId[i]
            if playerId == makePairOk.selfId then
                indexSelf = i
                campSelf = makePairOk.playerCamp[i]
                break
            end
        end

        for i=1,6 do
            local camp = makePairOk.playerCamp[i]
            if camp == campSelf and makePairOk.m_tSelfTeamInfo == nil and makePairOk.teamId then
                makePairOk.m_tSelfTeamInfo = {teamId=makePairOk.teamId[i],teamName=makePairOk.teamName[i],url=makePairOk.url[i]}
            elseif camp ~= campSelf and makePairOk.m_tEnemyTeamInfo == nil and makePairOk.teamId then
                makePairOk.m_tEnemyTeamInfo = {teamId=makePairOk.teamId[i],teamName=makePairOk.teamName[i],url=makePairOk.url[i]}
            end
        end
        WZLog("SceneBattleLoading:onEnter hero", Serialize(makePairOk.m_tSelfTeamInfo), Serialize(makePairOk.m_tEnemyTeamInfo))

    end

    --公会战时，设置对战双方的公会名可见
    if WBattleGlobal:getCurrent():isGuildWarStage() then
        --公会战
        GetElement(element, "conCommunityTeamInfo_SceneBattleLoading", WZUIContainer):setVisible(true)
        if WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_GZ and WBattleGlobal:getCurrent().m_tMakePairOk.schedule == GlobalGame.g_tSchedule.SCHEDULE_GW_3 then
            GetElement(element, "imgRedTeam_SceneBattleLoading", WZUIImage):setVisible(true)
            GetElement(element, "imgBlueTeam_SceneBattleLoading", WZUIImage):setVisible(true)
            local nTeamId = WBattleGlobal:getCurrent().m_tMakePairOk.teamId[1] + 1
            GetElement(element, "txtCommunityTeamNum2_SceneBattleLoading", WZUILabelAtlasFont):setText(nTeamId)
            GetElement(element, "txtCommunityTeamNum1_SceneBattleLoading", WZUILabelAtlasFont):setText(nTeamId)
        else
            GetElement(element, "imgRedTeam_SceneBattleLoading", WZUIImage):setVisible(false)
            GetElement(element, "imgBlueTeam_SceneBattleLoading", WZUIImage):setVisible(false)
        end

        local nLeftIndex, nRightIndex = self:_getCommunityName(WBattleGlobal:getCurrent().m_tMakePairOk.playerCamp)
        local txtRightCommunityName = GetElement(element, "txtRightCommunityName_SceneBattleLoading", WZUILabelTTF)
        if txtRightCommunityName then
            txtRightCommunityName:setText(WBattleGlobal:getCurrent().m_tMakePairOk.playerCommunity[nRightIndex])
        end
        local txtLeftCommunityName = GetElement(element, "txtLeftCommunityName_SceneBattleLoading", WZUILabelTTF)
        if txtLeftCommunityName then
            txtLeftCommunityName:setText(WBattleGlobal:getCurrent().m_tMakePairOk.playerCommunity[nLeftIndex])
        end
        WZLog("公会战双方名字：", nLeftIndex, nRightIndex, Serialize(WBattleGlobal:getCurrent().m_tMakePairOk.playerCommunity))
    end

    --英雄联赛，设置战队图标名字可见
    --联赛战队信息
    WZLog("战斗加载战队信息", WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle)
    if WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle  == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_LS then
        if WBattleGlobal:getCurrent().m_tMakePairOk.m_tSelfTeamInfo and WBattleGlobal:getCurrent().m_tMakePairOk.m_tEnemyTeamInfo then
            GetElement(element, "conLeagueTeamInfo_SceneBattleLoading", WZUIContainer):setVisible(true)
            local conLeagueLeft = GetElement(element, "conLeagueLeft_SceneBattleLoading", WZUIContainer)
            local celElementL, tCellL = CellDownloadImg:createElement()
            conLeagueLeft:addChild(celElementL) 
            SceneLeagueMain:addDownloadFileList(WBattleGlobal:getCurrent().m_tMakePairOk.m_tSelfTeamInfo.url, tCellL, nil, 68)
            --左战队的名字
            local txtLeftTeamName = GetElement(element, "txtLeftTeamName_SceneBattleLoading", WZUILabelTTF)
            txtLeftTeamName:setText(WBattleGlobal:getCurrent().m_tMakePairOk.m_tSelfTeamInfo.teamName)

            local conLeagueRight = GetElement(element, "conLeagueRight_SceneBattleLoading", WZUIContainer)
            local celElementR, tCellR = CellDownloadImg:createElement()
            conLeagueRight:addChild(celElementR)
            SceneLeagueMain:addDownloadFileList(WBattleGlobal:getCurrent().m_tMakePairOk.m_tEnemyTeamInfo.url, tCellR, nil, 68)
            --右战队的名字
            local txtRightTeamName = GetElement(element, "txtRightTeamName_SceneBattleLoading", WZUILabelTTF)
            txtRightTeamName:setText(WBattleGlobal:getCurrent().m_tMakePairOk.m_tEnemyTeamInfo.teamName)
        end
    end

    WZLog("SceneBattleLoading:onEnter zero", Serialize(WBattleGlobal:getCurrent().m_tMakePairOk))
    if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_NORMAL then
        if WBattleGlobal:getCurrent():isEscapeBattle() then
            local mapId = WBattleGlobal:getCurrent().m_tMakePairOk.mapId
            self.m_tMapInfo =  { id = mapId,name = "",dese = "",channel = 11,icon = ("map" .. mapId .."_bg.png"),animationIndexCode = ("map" .. mapId)}
            WBattleGlobal:getCurrent().m_tMakePairOk.battleMap = self.m_tMapInfo.animationIndexCode
            WBattleGlobal:getCurrent().m_tMakePairOk.map_icon = self.m_tMapInfo.icon
        elseif WBattleGlobal:getCurrent():isHeroTowerStage() then 
            self.m_tMapInfo =  CopyTable(GDatatab_herotower_map["id_"..WBattleGlobal:getCurrent().m_tMakePairOk.mapId] or GDatatab_herotower_map["id_70001"])
            WBattleGlobal:getCurrent().m_tMakePairOk.battleMap = self.m_tMapInfo.resources
            WBattleGlobal:getCurrent().m_tMakePairOk.map_icon = self.m_tMapInfo.resources .. "_bg.png"
        else
            self.m_tMapInfo =  CopyTable(GDatatab_battle_map["id_"..WBattleGlobal:getCurrent().m_tMakePairOk.mapId] or GDatatab_battle_map["id_2"])
            WBattleGlobal:getCurrent().m_tMakePairOk.battleMap = self.m_tMapInfo.animationIndexCode
            WBattleGlobal:getCurrent().m_tMakePairOk.map_icon = self.m_tMapInfo.icon
        end
    elseif WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS then
        if WBattleGlobal:getCurrent():isSingleStage() then
            if WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_DAILY_STAGE then
                self.m_tMapInfo = CopyTable(GDatatab_daily_map["id_"..WBattleGlobal:getCurrent().m_tMakePairOk.mapId] or GDatatab_daily_map["id_1001"])
                WBattleGlobal:getCurrent().m_tMakePairOk.battleMap = self.m_tMapInfo.resources
                WBattleGlobal:getCurrent().m_tMakePairOk.map_icon = self.m_tMapInfo.map_icon or "target_content5.png"

            elseif WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_TOWER_STAGE then
                self.m_tMapInfo = CopyTable(GDatatab_tower_map["id_"..WBattleGlobal:getCurrent().m_tMakePairOk.mapId] or GDatatab_tower_map["id_1001"])
                WBattleGlobal:getCurrent().m_tMakePairOk.battleMap = self.m_tMapInfo.resources
                WBattleGlobal:getCurrent().m_tMakePairOk.map_icon = self.m_tMapInfo.map_icon or "target_content5.png"
            elseif WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_TRAIN_STAGE then
                self.m_tMapInfo = CopyTable(GDatatab_train_map["id_"..WBattleGlobal:getCurrent().m_tMakePairOk.mapId] or GDatatab_train_map["id_1011"])
                WBattleGlobal:getCurrent().m_tMakePairOk.battleMap = self.m_tMapInfo.resources
                WBattleGlobal:getCurrent().m_tMakePairOk.map_icon = self.m_tMapInfo.map_icon or "target_content5.png"
                WBattleGlobal:getCurrent().m_tMakePairOk.section = self.m_tMapInfo.section
            else
                self.m_tMapInfo =  CopyTable(GDatatab_single_map["id_"..WBattleGlobal:getCurrent().m_tMakePairOk.mapId] or GDatatab_single_map["id_10101"])
                WBattleGlobal:getCurrent().m_tMakePairOk.battleMap = self.m_tMapInfo.resources
                WBattleGlobal:getCurrent().m_tMakePairOk.map_icon = self.m_tMapInfo.map_target or "target_content5.png"
            end
        else
            if WBattleGlobal:getCurrent().m_tMakePairOk.mapId == 0 then
                WBattleGlobal:getCurrent().m_tMakePairOk.mapId = 1
            end
            if WBattleGlobal:getCurrent():isGuildBossStage() then
                self.m_tMapInfo =  CopyTable(GDatatab_guild_boss_map["id_"..WBattleGlobal:getCurrent().m_tMakePairOk.mapId] or GDatatab_world_boss_map["id_1"])
            elseif WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_WORLDBOSS then
                self.m_tMapInfo =  CopyTable(GDatatab_world_boss_map["id_"..WBattleGlobal:getCurrent().m_tMakePairOk.mapId] or GDatatab_world_boss_map["id_1"])
            elseif WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_WORLDTEAMBOSS then
                self.m_tMapInfo =  CopyTable(GDatatab_team_world_boss_map["id_"..WBattleGlobal:getCurrent().m_tMakePairOk.mapId] or GDatatab_team_world_boss_map["id_10001"])
            else
                self.m_tMapInfo =  CopyTable(GDatatab_team_map["id_"..WBattleGlobal:getCurrent().m_tMakePairOk.mapId] or GDatatab_team_map["id_20101"])
            end
            WBattleGlobal:getCurrent().m_tMakePairOk.battleMap = self.m_tMapInfo.map
            WBattleGlobal:getCurrent().m_tMakePairOk.map_icon = self.m_tMapInfo.map_target
        end
    end

    self.m_bIsTest = false
	if self.m_bIsTest == true then
        WBattleGlobal:getCurrent().m_tMakePairOk.mapId = 1
        self.m_tMapInfo =  BossMapConfig["id_20101"] --GDatatab_team_map["id_"..WBattleGlobal:getCurrent().m_tMakePairOk.mapId]
        WBattleGlobal:getCurrent().m_tMakePairOk.battleMap = self.m_tMapInfo.map
        WBattleGlobal:getCurrent().m_tMakePairOk.map_icon = self.m_tMapInfo.map_target
        WZLog("SceneBattleLoading:onEnter one", self.m_tMapInfo.map, self.m_tMapInfo.map_target)
    end
    if self.m_tMapInfo.canDigHole and self.m_tMapInfo.canDigHole == 0 then
        WBattleGlobal:getCurrent().m_bMapCanDigHole = false
    else
        WBattleGlobal:getCurrent().m_bMapCanDigHole = true
    end
    BattleMapManager:loadMap(WBattleGlobal:getCurrent().m_tMakePairOk.battleMap:match("%d+"))

	--检测加载战斗所需lua文件
	CheckLuaLoad(LUAFILES_BLOCK_NORMALBATTLE)
	if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS then
		CheckLuaLoad(LUAFILES_BLOCK_BOSSBATTLE)
	end

	if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS then
        if WBattleGlobal:getCurrent():isGuildBossStage() then
            RECONNECT_BATTLE_MODE = BattleConstants.g_tBossBattleMode.MODEL_GUILD_STATE
		elseif WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_WORLDBOSS then
			RECONNECT_BATTLE_MODE = BattleConstants.g_tBossBattleMode.MODE_WORLDBOSS
        elseif WBattleGlobal:getCurrent():isSingleStage() then
            if WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_SINGLE) then
                RECONNECT_BATTLE_MODE = BattleConstants.g_tBossBattleMode.MODE_SINGLE_STAGE
                RECONNECT_BATTLE_MAP = WBattleGlobal:getCurrent().m_tMakePairOk.mapId
            elseif WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_DAILY) then
                RECONNECT_BATTLE_MODE = BattleConstants.g_tBossBattleMode.MODE_DAILY_STAGE
            elseif WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_TOWER) then
                RECONNECT_BATTLE_MODE = BattleConstants.g_tBossBattleMode.MODE_TOWER_STAGE
            end
		else
			RECONNECT_BATTLE_MODE = BattleConstants.g_nBATTLE_TYPE_BOSS
		end
	end

	self.m_root = element
	ProtocolProcessorBattleInterface:regAll()		--注册协议
    Protocol:unreg( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_EnterRoomOk, "ProtocolProcessorBossMap:parse_BOSSMAPROOM_EnterRoomOk", "issiiiivbvivivsvivbvivivivivsvivivivivsvsvivissssssvivivivivivivivivivi")
    Protocol:unreg( Protocol.MAIN_ROOM, Protocol.ROOM_EnterRoomOk, "ProtocolProcessorGlobal:parse_ROOM_EnterRoomOk", "iiiiiiiiiivbvivivsvivbvivivivivsssvivsvivivivsvivsvivsvivissssssvivivivivi")
    Protocol:unreg( Protocol.MAIN_HERO, Protocol.HERO_ReadyFightOK, "ProtocolProcessorWndLeague:parse_HERO_ReadyFightOK", "isssviviviviviiiiiviviivivsvissvivsivivsiviisviii")
    
    GlobalGame:setIfInBattle(true)

    --添加网络信号
    self:_addNetSignal()
	
	self:_update()

	self.m_root:enableSchedule("_updateLoading", 0)

	self.m_tMakePairOk = WBattleGlobal:getCurrent().m_tMakePairOk
    
    --Add By Tianxiang_Xu
    self.m_nMyCamp = self:rtnMyCamp()
    --End Add 
	self.m_tStepFunction = {}

    --记录出生点
    WBattleGlobal:getCurrent().bornPosList = self.m_tMapInfo.position

    WZLog("SceneBattleLoading:onEnter two", tostring(WBattleGlobal:getCurrent():isSingleStage()), tostring(WBattleGlobal:getCurrent().m_nBattleType), Serialize(self.m_tMakePairOk))
    if WBattleGlobal:getCurrent():isSingleStage() then
        table.insert(self.m_tStepFunction,{self._getTips})
        table.insert(self.m_tStepFunction,{self._initBoss})
        table.insert(self.m_tStepFunction,{self._initPlayer})
        --table.insert(self.m_tStepFunction,{self._initMachine})
        table.insert(self.m_tStepFunction,{self._getCharacterPos})
        table.insert(self.m_tStepFunction,{self._getPlayerSkill})
        table.insert(self.m_tStepFunction,{self._getPetSkill})
        table.insert(self.m_tStepFunction,{self._getPlayerProp})
        table.insert(self.m_tStepFunction,{self._endLoading})
    else
        table.insert(self.m_tStepFunction,{self._getTips})
        table.insert(self.m_tStepFunction,{self._sendStartLoading})
        table.insert(self.m_tStepFunction,{self._initPlayer})
        table.insert(self.m_tStepFunction,{self._sendPercent,10})
        if WBattleGlobal:getCurrent().m_nBattleType ~= BattleConstants.g_nBATTLE_TYPE_NORMAL then
            table.insert(self.m_tStepFunction,{self._initBoss})
        end
        table.insert(self.m_tStepFunction,{self._initMachine})
        table.insert(self.m_tStepFunction,{self._sendPercent,20})
        table.insert(self.m_tStepFunction,{self._getPlayerSkill})
        table.insert(self.m_tStepFunction,{self._getPetSkill})
        table.insert(self.m_tStepFunction,{self._sendPercent,40})
        table.insert(self.m_tStepFunction,{self._getPlayerProp})
        table.insert(self.m_tStepFunction,{self._sendPercent,60})
        
        if WBattleGlobal:getCurrent():isAudience() then
            table.insert(self.m_tStepFunction,{self._sendPercent,80})
            table.insert(self.m_tStepFunction,{self._sendPercent,100})
            table.insert(self.m_tStepFunction,{self._endLoading})
        else
            table.insert(self.m_tStepFunction,{self._getCharacterPos})
            table.insert(self.m_tStepFunction,{self._sendPercent,80})
            table.insert(self.m_tStepFunction,{self._sendPercent,100})
            table.insert(self.m_tStepFunction,{self._endLoading})
        end

    end
    
	if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_NORMAL then
        --公会战
        if WBattleGlobal:getCurrent():isGuildWarStage() then 
            local tPlayerCamp = WBattleGlobal:getCurrent().m_tMakePairOk.playerCamp
            self.m_nLeftPeopleNum = self:_getLeftPlayerNum(tPlayerCamp)
            self.m_nRightPeopleNum = WBattleGlobal:getCurrent().m_tMakePairOk.playerCount - self.m_nLeftPeopleNum
        elseif WBattleGlobal:getCurrent().m_tMakePairOk.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_LD then  --大乱斗
            GetElement(self.m_root, "conTips_SceneBattleLoading", WZUIContainer):setVisible(false)
            GetElement(self.m_root, "conTipsBK_SceneBattleLoading", WZUIContainer):setVisible(false)
            self.m_nLeftPeopleNum = 1
            self.m_nRightPeopleNum = WBattleGlobal:getCurrent().m_tMakePairOk.playerCount - self.m_nLeftPeopleNum
        elseif WBattleGlobal:getCurrent().m_tMakePairOk.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_GS then  --怪兽模式
            GetElement(self.m_root, "conTips_SceneBattleLoading", WZUIContainer):setVisible(false)
            GetElement(self.m_root, "conTipsBK_SceneBattleLoading", WZUIContainer):setVisible(false)
            local tPlayerCamp = WBattleGlobal:getCurrent().m_tMakePairOk.playerCamp
            self.m_nLeftPeopleNum = self:_getLeftPlayerNum(tPlayerCamp)
            self.m_nRightPeopleNum = WBattleGlobal:getCurrent().m_tMakePairOk.playerCount - self.m_nLeftPeopleNum
        elseif WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_LX then  --练习赛
            local tPlayerCamp = WBattleGlobal:getCurrent().m_tMakePairOk.playerCamp
            self.m_nLeftPeopleNum = self:_getLeftPlayerNum(tPlayerCamp)
            self.m_nRightPeopleNum = WBattleGlobal:getCurrent().m_tMakePairOk.playerCount - self.m_nLeftPeopleNum
        else
    		self.m_nLeftPeopleNum = math.ceil(WBattleGlobal:getCurrent().m_tMakePairOk.playerCount * 0.5)
    		self.m_nRightPeopleNum = math.floor(WBattleGlobal:getCurrent().m_tMakePairOk.playerCount * 0.5)
        end
	else
		self.m_nLeftPeopleNum = math.ceil(WBattleGlobal:getCurrent().m_tMakePairOk.playerCount)
		self.m_nRightPeopleNum = 0
		for i,id in pairs(WBattleGlobal:getCurrent().m_tMakePairOk.guaiBattleId) do
            local templateId = WBattleGlobal:getCurrent().m_tMakePairOk.guaiId[i]
            local monsterData = BossData["id_"..templateId]
			if id ~= -1 and (monsterData and monsterData.type <= MonsterType.ELITE)then
				self.m_nRightPeopleNum = self.m_nRightPeopleNum + 1
			end
		end

        if WBattleGlobal:getCurrent():isFlyCopy() then
            self.m_nRightPeopleNum = 1
        end
	end

    --Add By Tianxiang_Xu
    local spineVS = WZUISpine:create()
    if spineVS then
        local conForVSSpine = GetElement(self.m_root, "conForVSSpine_SceneBattleLoading", WZUIContainer)
        conForVSSpine:addChild(spineVS)
        spineVS:setFileAtlas("ui/ui_battleloading.atlas")
        spineVS:setFileJson("ui/ui_battleloading.json")
        spineVS:play("action", false)
        spineVS:setRelativePosition(GlobalMethod:ccp(0.5,1.02188))
        spineVS:enableSchedule("createRoleAni",0.6)
        SoundManager:playEffectSound(SoundDefine.E_S_BATTLE_VS)
    end
    --End Add

    --多语言版本界面适配
   AdaptLanguage(self)
   --]]

   local monster_data = CopyTable(self.m_tMapInfo.monster)
   --记录怪物出生点 
    WBattleGlobal:getCurrent().m_tMonsterBornPos = {}
    if monster_data then
        for index,guaiInfo in pairs(monster_data) do
            table.insert(WBattleGlobal:getCurrent().m_tMonsterBornPos, {[1]=guaiInfo[2],[2]=guaiInfo[3]})
        end
    end

    WZLog("SceneBattleLoading:onEnter 1111", Serialize(WBattleGlobal:getCurrent().m_tMonsterBornPos), Serialize(WBattleGlobal:getCurrent().m_tPlayerBornPt))
end

--@brief    觸摸開始
function SceneBattleLoading:onTouchBegin(element, pt)
    -- body
    if WndItemInfo.m_root then
        WndItemInfo:onCloseClick()
    end
end

--@brief     返回我所在的阵营的标记值
--@author    Tianxiang_Xu
function SceneBattleLoading:rtnMyCamp()
    --body
    local tMakePairOk = WBattleGlobal:getCurrent().m_tMakePairOk
    if not tMakePairOk.playerCamp then
        return 0
    end

    for i = 1, tMakePairOk.playerCount do
        WZLog("************** SceneBattleLoading:rtnMyCamp ***************", tMakePairOk.playerCount, CacheCenter:getPlayerInfo().id, tMakePairOk.playerId[i])
        if tMakePairOk.selfId == tMakePairOk.playerId[i] then
            return tMakePairOk.playerCamp[i]
        end
    end 
end

--@brief    VS特效播放完后的回调
function SceneBattleLoading:onFinish(element, delat)
    -- body
    if #self.m_tStepFunction <= 0 then
        if element then
            element:disableSchedule()
            element:removeFromParentAndCleanup(true)
        end

        local isConfirmActive = WindowManager:ifActiveWindow(WndConfirmBox)
        WZLog("SceneBattleLoading:onFinish", tostring(isConfirmActive))
        if isConfirmActive then
            return
        end

        g_singleCopyStartTime = os.time()
        local sceneBattle = SceneBattle:createElement()
        SceneBattle:setMapId(self.m_tMakePairOk.battleMap:match("%d+"))
        SceneBattle:init()
        WZLog("SceneBattleLoading:onFinish 1111", Serialize(WBattleGlobal:getCurrent().m_tMonsterBornPos))
        replaceScene(sceneBattle)
    end
end

-- 创建角色动画
function SceneBattleLoading:createRoleAni(element, delat)
    element:disableSchedule()

    if element then
        element = WZUISpine:luaTo(element)
        element:play("wait", true)
    end

    element:enableSchedule("onFinish",1)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function SceneBattleLoading:onExit(element)
	ProtocolProcessorBattleInterface:unregAll()		--反注册协议
    Protocol:reg( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_EnterRoomOk, "ProtocolProcessorBossMap:parse_BOSSMAPROOM_EnterRoomOk", "issiiiivbvivivsvivbvivivivivsvivivivivsvsvivissssssvivivivivivivivivivi")
    Protocol:reg( Protocol.MAIN_ROOM, Protocol.ROOM_EnterRoomOk, "ProtocolProcessorGlobal:parse_ROOM_EnterRoomOk", "iiiiiiiiiivbvivivsvivbvivivivivsssvivsvivivivsvivsvivsvivissssssvivivivivi")
	Protocol:reg( Protocol.MAIN_HERO, Protocol.HERO_ReadyFightOK, "ProtocolProcessorWndLeague:parse_HERO_ReadyFightOK", "isssviviviviviiiiiviviivivsvissvivsivivsiviisviii")
    
    self:_unInit()
end

--@brief	返回在MakePairOk表中自己的数据的下标
--@param	tMakePair:MakePairOk表
--@return	#1:下标,-1:没有找到
function SceneBattleLoading:getSelfIndex(tMakePair)

	for i=1,tMakePair.playerCount do
		if tMakePair.playerId[i] == WBattleGlobal:getCurrent():getMyBattleId() then
			return i
		end
	end
	return -1
end

--@brief	往场景根节点添加元素的方法
--@param	element:要添加的界面元素引用
--@note		这里会修改showAll属性，为了适配不同分辨率，保证界面元素不会变形
--          注: 对于主场景showAll属性已经是true的时候不用修改元素的showAll
function SceneBattleLoading:addChild(element)
    if self.m_root == nil or element == nil then
        return
    end
    element:setShowAll(true)
    self.m_root:addChild(element)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	获取提示语
function SceneBattleLoading:_getTips()
    WZLog("SceneBattleLoading:_getTips")
	--ProtocolProcessorBattleInterface:send_BATTLE_GetTips()
    SceneBattleLoading:receiveTips(GDatatab_tips)
	return true
end

--@brief	发送开始loading	
--@return	#1:true:完成,false:未完成
function SceneBattleLoading:_sendStartLoading()
    WZLog("SceneBattleLoading:_sendStartLoading")
	ProtocolProcessorBattleInterface:send_BATTLE_StartLoading(self.m_tMakePairOk.battleId, WBattleGlobal:getCurrent():getMyBattleId())
	return true
end

--@brief	初始化怪物
--@return	#1:true:完成,false:未完成
function SceneBattleLoading:_initBoss()
	WZLog("SceneBattleLoading:_initBoss")
    if not (WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS and (BattleConstants.g_tBossBattleMode.MODE_WORLDBOSS == WBattleGlobal:getCurrent().battleMode or BattleConstants.g_tBossBattleMode.MODE_SINGLE_STAGE == WBattleGlobal:getCurrent().battleMode)) then
    end

	local index = 1
    local guaiCount = #WBattleGlobal:getCurrent().m_tMakePairOk.guaiBattleId
    if WBattleGlobal:getCurrent():isFlyCopy() then
        guaiCount = 1
    end
	for i=1,guaiCount do
		local guai = WBattleGlobal:getCurrent():buildGuai(self.m_tMakePairOk,WBattleGlobal:getCurrent().m_tMakePairOk.guaiId[i],i)

        -- WZLog("SceneBattleLoading:_initBoss two", tostring(guai:getBattleId()))
        local offShow = true
        if guai ~= nil and guai:getBattleId() ~=  0 and guai:getBattleId() ~=  -1 then
            if guai.m_nMonsterType <= MonsterType.ELITE  then
                offShow = false
            end
        end
		if not offShow then
			--着装
			local element = WZUISystem:getInstance():createElement("conCellPlayer_SceneBattleLoading")
            --右边怪脚下的光阵位置
            local imgFootLight = GetElement(element, "imgFootLight_CellPlayer", WZUIImage)
            imgFootLight:setFile("ui/common/common_pic_fazheng5.png")
            imgFootLight:setRelativePosition(GlobalMethod:ccp(0.48, 0.32))

			WZUIContainer:luaTo(GetElement(element,"conPlayer_SceneBattleLoading")):addChild(guai:getShopAnimation())
            if guai.m_bIsOldAnim ~= nil and guai.m_bIsOldAnim == true then
                WZLog("******************* PLAY ***************************", guai:getAnimationName("move"))
                local sWaitAniName = guai:getAnimationName("move")
                guai.m_shopAnim:play(sWaitAniName,true)
            end
			WZUIProgress:luaTo(GetElement(element,"progPlayerLoad_SceneBattleLoading")):setPercentage(100)
            WZUIProgress:luaTo(GetElement(element,"progPlayerLoad_SceneBattleLoading")):setBgPicture("ui/combat/battle_progress_xingdongzhi_sel.png")
			local size = GlobalMethod:CCSize(230,260)--GetElement(element,"conPlayer_SceneBattleLoading"):getAbsContentSize()
            --加载界面怪的锚点，相对坐标，缩放比例
            local tLoadingInfo = {{50,0},{50,7},{100}}
            if guai.m_tLoadingInfo ~= nil and guai.m_tLoadingInfo ~= -1 then
                tLoadingInfo = guai.m_tLoadingInfo
            end

            if WBattleGlobal:getCurrent():isFlyCopy() then
                tLoadingInfo = {{50,0},{48,10},{100}}
            end

            WZLog("tLoadingInfo  tLoadingInfo", Serialize(tLoadingInfo))

            guai.m_shopAnim:getAnimNode():setScale(tLoadingInfo[3][1]/100)
            guai:getShopAnimation():setRelativePositionLuaTo(tLoadingInfo[2][1]/100,tLoadingInfo[2][2]/100)
            guai:getShopAnimation():setAnchorPoint(GlobalMethod:ccp(tLoadingInfo[1][1]/100,tLoadingInfo[1][2]/100))

            if WBattleGlobal:getCurrent():isSingleStage() and guai.m_bIsGuaiWithSuit == true then
                guai:getShopAnimation():setFlipX(true)
                guai.m_shopAnim:play(guai:getActionName(22), true)
            end
            
			--名字
            if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS and WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_WORLDBOSS then
                WZUILabelTTF:luaTo(GetElement(element,"txtPlayerName_SceneBattleLoading")):setMaxLength(0)
			elseif WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS then
                WZUILabelTTF:luaTo(GetElement(element,"txtPlayerName_SceneBattleLoading")):setMaxLength(0)	
            end
            --等级
            local level = GlobalGame:checkGlobalPlayerLevel(guai.m_nLevel)
            local zs = guai.m_nZSLevel
			WZUILabelTTF:luaTo(GetElement(element,"txtPlayerName_SceneBattleLoading")):setText("Lv" .. tostring(level) .. guai.m_sPlayerName)
		
            WZUIImage:luaTo(GetElement(element,string.format("imgPlayerLevelBack%d_SceneBattleLoading",zs))):setFile("ui/combat/common_icon_zhandoubuff.png")
			local conSeats = WZUIContainer:luaTo(GetElement(self.m_root,string.format("conBossSeatFor%d_SceneBattleLoading",self.m_nRightPeopleNum)))
			WZUIContainer:luaTo(GetElement(conSeats,string.format("conBossSeat%d_SceneBattleLoading",index))):addChild(element)
            --设置世界boss显示居中
            if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS and WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_WORLDBOSS then
                conSeats:setRelativePosition(GlobalMethod:ccp(0.5,0.39))
            end
            --组队副本boss位置
            if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS and WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_BOSSMAP_2 then
                if self.m_nRightPeopleNum == 2 then
                    conSeats:setRelativePosition(GlobalMethod:ccp(0.5,0.48))
                else
                    conSeats:setRelativePosition(GlobalMethod:ccp(0.5,0.39))
                end
            end
            --新手boss位置
            if guai.m_nPlayerId == 99999 then
                conSeats:setRelativePosition(GlobalMethod:ccp(0.5,0.39))
            end


			
			element:setVisible(true)
			index = index + 1
		end
	end

    if not (WBattleGlobal:getCurrent():isSingleStage()) then

        WBattleGlobal:getCurrent():requestGuaiBattleId(10)
    end


	return true
end

--@brief	初始化玩家
--@return	#1:true:完成,false:未完成
function SceneBattleLoading:_initPlayer()
    WZLog("SceneBattleLoading:_initPlayer zero", tostring(self.m_tMakePairOk.playerCount), tostring(self.__nPlayerIndex), Serialize(self.m_tMakePairOk))
	if self.__nPlayerIndex == nil then
		self.__nPlayerIndex = 1
		self.__nLeftPlayer = 1
		self.__nRightPlayer = 1
	end

	if self.__nPlayerIndex > self.m_tMakePairOk.playerCount then
		self.__nPlayerIndex = nil
		self.__nLeftPlayer = nil
		self.__nRightPlayer = nil
	
		return true
	end

	if self.m_tMakePairOk.playerId[self.__nPlayerIndex] <= 0 then
		return
	end

	--着装
	local element = WZUISystem:getInstance():createElement("conCellPlayer_SceneBattleLoading")
	local hero = WBattleGlobal:getCurrent():buildHero(self.m_tMakePairOk,self.__nPlayerIndex)
    local heroAnimeNode, heroAnim = nil
    local heroMonster = nil 
	if hero ~= nil then
        if WBattleGlobal:getCurrent().m_tMakePairOk.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_GS and hero.m_nCamp == 1 then 
            --保存怪兽形象
            heroMonster = WBattleGlobal:getCurrent():buildHero(self.m_tMakePairOk, self.__nPlayerIndex, true)
            local nSex = heroMonster:getHeroInfo()
            heroAnim = heroMonster.m_shopAnim
            heroAnimeNode = heroAnim:getAnimNode()
            heroMonster.m_shopAnim:getAnimNode():setScale(1.2)
            heroMonster.m_shopAnim:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0))
            heroMonster.m_shopAnim:play(heroMonster:getActionName(22), true)
            WZUIContainer:luaTo(GetElement(element,"conPlayer_SceneBattleLoading")):addChild(heroMonster.m_shopAnim:getAnimNode())
            local size = WZUIContainer:luaTo(GetElement(element,"conPlayer_SceneBattleLoading")):getAbsContentSize()
            heroMonster.m_shopAnim:getAnimNode():setPosition(size.width*0.5,0)
            if heroMonster.m_bIsMonster then
                local pos = heroMonster.m_shopAnim:getPosition()
                heroMonster.m_shopAnim:setPosition(Vector2:create(pos.x+100, pos.y))
            end
            if heroMonster.m_nCamp == self.m_nMyCamp then 
                heroMonster:getShopAnimation():setFlipX(true)
            end
        --     local guaiTable = WMonster
        --     local monsterId = WBattleGlobal:getCurrent().m_tMakePairOk.monsterId
        --     guai = (guaiTable and guaiTable:buildGuai(monsterId,GDatatab_monster["id_"..monsterId].scale,false))
        --     guai:getShopAnimation():setAnchorPoint(GlobalMethod:ccp(0.5, 0))
        --     guai:getShopAnimation():setRelativePosition(GlobalMethod:ccp(0.5, 0))
        --     if monsterId == 10007 or monsterId == 10008 or monsterId == 10009 or monsterId == 10010 then
        --         guai:getShopAnimation():play("wait_1", true)
        --     else
        --         guai:getShopAnimation():play("wait", true)
        --     end
        -- --    guai:getShopAnimation():setScale(bossData.scale/100)
        --     WZUIContainer:luaTo(GetElement(element,"conPlayer_SceneBattleLoading")):addChild(guai:getShopAnimation())
        --     if hero.m_nCamp == self.m_nMyCamp then 
        --         guai:getShopAnimation():setFlipX(true)
        --     end
            
        else
            local nSex = hero:getHeroInfo()
            heroAnim = hero.m_shopAnim
            heroAnimeNode = heroAnim:getAnimNode()
    		heroAnimeNode:setScale(0.84)
    		heroAnimeNode:setAnchorPoint(GlobalMethod:ccp(0.5,0))
    		heroAnim:play(hero:getActionName(22), true)
    		WZUIContainer:luaTo(GetElement(element,"conPlayer_SceneBattleLoading")):addChild(heroAnimeNode)
    		local size = WZUIContainer:luaTo(GetElement(element,"conPlayer_SceneBattleLoading")):getAbsContentSize()
            heroAnimeNode:setPosition(size.width*0.5,0)
            if hero.m_bIsMonster then
                local pos = heroAnim:getPosition()
                heroAnim:setPosition(Vector2:create(pos.x+100, pos.y))
            end
        end
	end
	
	--名字
    if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS and WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_WORLDBOSS then
        WZUILabelTTF:luaTo(GetElement(element,"txtPlayerName_SceneBattleLoading")):setMaxLength(0)
    end

    --玩家自己的名字颜色设置
    if hero.m_nPlayerId == WBattleGlobal:getCurrent().m_tMakePairOk.selfId then
        local txtPlayerName = WZUILabelTTF:luaTo(GetElement(element,"txtPlayerName_SceneBattleLoading"))
        txtPlayerName:setColor(GlobalMethod:ccc3(99,255,95))
    else
        --跨服标记
        local nLocalServerId = tonumber(CacheCenter:getPlayerInfo().serverId)
        if WBattleGlobal:getCurrent():isGuildWarStage() then
            local leftIndex, rightIndex = self:_getCommunityName(WBattleGlobal:getCurrent().m_tMakePairOk.playerCamp)
            nLocalServerId = tonumber(WBattleGlobal:getCurrent().m_tMakePairOk.serverId[leftIndex])
        end
        WZLog("*********** 跨服标记 ********", hero.serverId, nLocalServerId)
        if hero.serverId ~= nil and tonumber(hero.serverId) ~= nLocalServerId then
            GetElement(element, "imgOtherServerIcon_SceneBattleLoading", WZUIImage):setVisible(true)
            local txtPlayerName = WZUILabelTTF:luaTo(GetElement(element,"txtPlayerName_SceneBattleLoading"))
            txtPlayerName:setRelativePosition(GlobalMethod:ccp(0.58,0.5))
        else
            GetElement(element, "imgOtherServerIcon_SceneBattleLoading", WZUIImage):setVisible(false)
        end
    end
	
	--等级
    local zs = GlobalGame:checkGlobalPlayerZsleve(self.m_tMakePairOk.playerLevel[self.__nPlayerIndex])
    local level = GlobalGame:checkGlobalPlayerLevel(self.m_tMakePairOk.playerLevel[self.__nPlayerIndex])
    if hero.m_nZSLevel == 1 then
        zs = 1
    end

    WZUILabelTTF:luaTo(GetElement(element,"txtPlayerName_SceneBattleLoading")):setText("Lv" .. tostring(level) .. self.m_tMakePairOk.playerName[self.__nPlayerIndex])

    if WBattleGlobal:getCurrent():isSingleStage() then
        WZUIProgress:luaTo(GetElement(element,"progPlayerLoad_SceneBattleLoading")):setPercentage(100)
    end
    
    if hero.m_nCamp ~= self.m_nMyCamp then
        WZUIProgress:luaTo(GetElement(element,"progPlayerLoad_SceneBattleLoading")):setBgPicture("ui/combat/battle_progress_xingdongzhi_sel.png")
    end
	element:setVisible(true)

    local nBattleChannle = WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle

    WZLog("SceneBattleLoading:_initPlayer one", nBattleChannle, WBattleGlobal:getCurrent().m_tMakePairOk.battleMode, self.__nLeftPlayer, self.m_nLeftPeopleNum)
    if (hero.m_nCamp == self.m_nMyCamp or nBattleChannle == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_GZ or 
        WBattleGlobal:getCurrent():isEscapeBattle() or 
        (WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_NORMAL and 
            WBattleGlobal:getCurrent().m_tMakePairOk.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_LD )) and 
        self.__nLeftPlayer <= self.m_nLeftPeopleNum then

        local conSeats = WZUIContainer:luaTo(GetElement(self.m_root,string.format("conLeftSeatFor%d_SceneBattleLoading",self.m_nLeftPeopleNum)))
        if WBattleGlobal:getCurrent():isEscapeBattle() then
            conSeats = WZUIContainer:luaTo(GetElement(self.m_root,string.format("conLeftSeatFor%d_SceneBattleLoading",11)))
        end

        if (WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_NORMAL) and WBattleGlobal:getCurrent().m_tMakePairOk.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_LD then
            WZLog("**********  混战模式  ************", hero.m_nCamp, self.m_nMyCamp, self.__nLeftPlayer, self.m_nLeftPeopleNum)
            if hero.m_nCamp == self.m_nMyCamp or (hero.m_nCamp ~= self.m_nMyCamp and 
                ((self.__nLeftPlayer < self.m_nLeftPeopleNum and self.m_bIsLoadMyself == false) or 
                    (self.__nLeftPlayer <= self.m_nLeftPeopleNum and self.m_bIsLoadMyself == true))) then
                if hero.m_nCamp == self.m_nMyCamp then 
                    self.m_bIsLoadMyself = true
                end
--                WZLog("**********  混战模式  OTHER HERO************")
                WZUIContainer:luaTo(GetElement(conSeats,string.format("conLeftPlayer%d_SceneBattleLoading",self.__nLeftPlayer))):addChild(element)

                hero:setCampPosition(self.__nLeftPlayer*-1)
                if heroMonster then 
                    heroMonster:setCampPosition(self.__nLeftPlayer*-1)
                end
                self.__nLeftPlayer = self.__nLeftPlayer + 1

                --跨服显示区名
                if (WBattleGlobal:getCurrent().m_nServiceMode ~=nil and WBattleGlobal:getCurrent().m_nServiceMode ==1) and WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_NORMAL then --一般战斗，副本战斗
                    local txtLeftServerName = WZUILabelTTF:luaTo(GetElement(self.m_root,"txtLeftServerName_SceneBattleLoading"))
                    txtLeftServerName:getParentElement():setVisible(true)
                    txtLeftServerName:setText(self.m_tMakePairOk.serverName[self.__nPlayerIndex])
                end
            else
                local conSeats = WZUIContainer:luaTo(GetElement(self.m_root,string.format("conRightSeatFor%d_SceneBattleLoading",self.m_nRightPeopleNum)))
                WZUIContainer:luaTo(GetElement(conSeats,string.format("conRightPlayer%d_SceneBattleLoading",self.__nRightPlayer))):addChild(element)

                WZUIImage:luaTo(GetElement(element,string.format("imgPlayerLevelBack%d_SceneBattleLoading",zs))):setFile("ui/combat/common_icon_zhandoubuff.png")
                if heroAnimeNode then
                    if WBattleGlobal:getCurrent():isEscapeBattle() and (self.__nRightPlayer == 4 or self.__nRightPlayer == 5) then

                    else
                        heroAnim:setFlipX(true)
                    end
                    local positionX = heroAnimeNode:getPositionX()
                    positionX = positionX --+ 35
                    heroAnimeNode:setPositionX(positionX)
                end
                --右边角色脚下的光阵位置
                local imgFootLight = GetElement(element, "imgFootLight_CellPlayer", WZUIImage)
                imgFootLight:setFile("ui/common/common_pic_fazheng5.png")
                imgFootLight:setRelativePosition(GlobalMethod:ccp(0.5, 0.32))
           
                --hero:setwingFlipX(true)
                hero:setCampPosition(self.__nRightPlayer)
                if heroMonster then 
                    heroMonster:setCampPosition(self.__nRightPlayer)
                end

                self.__nRightPlayer = self.__nRightPlayer + 1

                --跨服显示区名
                if (WBattleGlobal:getCurrent().m_nServiceMode ~=nil and WBattleGlobal:getCurrent().m_nServiceMode ==1) and WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_NORMAL  then --一般战斗，副本战斗
                    local txtRightServerName = WZUILabelTTF:luaTo(GetElement(self.m_root,"txtRightServerName_SceneBattleLoading"))
                    txtRightServerName:getParentElement():setVisible(true)
                    txtRightServerName:setText(self.m_tMakePairOk.serverName[self.__nPlayerIndex])
                end
            end
        else --非混战模式左方战阵
            WZLog("hahahahahaha  不知道怎么回事")
            WZUIContainer:luaTo(GetElement(conSeats,string.format("conLeftPlayer%d_SceneBattleLoading",self.__nLeftPlayer))):addChild(element)

            hero:setCampPosition(self.__nLeftPlayer*-1)
            if heroMonster then 
                heroMonster:setCampPosition(self.__nLeftPlayer*-1)
            end
            self.__nLeftPlayer = self.__nLeftPlayer + 1

            --跨服显示区名
            if (WBattleGlobal:getCurrent().m_nServiceMode ~=nil and WBattleGlobal:getCurrent().m_nServiceMode ==1) and WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_NORMAL then --一般战斗，副本战斗
                local txtLeftServerName = WZUILabelTTF:luaTo(GetElement(self.m_root,"txtLeftServerName_SceneBattleLoading"))
                txtLeftServerName:getParentElement():setVisible(true)
                txtLeftServerName:setText(self.m_tMakePairOk.serverName[self.__nPlayerIndex])
            end
        end            
	else
        WZLog("****** 公会战 **********", self.__nRightPlayer, self.m_nRightPeopleNum, self.__nLeftPlayer, self.m_nLeftPeopleNum, self.__nPlayerIndex, WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle)
        
		local conSeats = WZUIContainer:luaTo(GetElement(self.m_root,string.format("conRightSeatFor%d_SceneBattleLoading",self.m_nRightPeopleNum)))
		
        WZUIContainer:luaTo(GetElement(conSeats,string.format("conRightPlayer%d_SceneBattleLoading",self.__nRightPlayer))):addChild(element)

		WZUIImage:luaTo(GetElement(element,string.format("imgPlayerLevelBack%d_SceneBattleLoading",zs))):setFile("ui/combat/common_icon_zhandoubuff.png")
        if heroAnimeNode then
            if WBattleGlobal:getCurrent():isEscapeBattle() and (self.__nRightPlayer == 4 or self.__nRightPlayer == 5) then

            else
                heroAnim:setFlipX(true)
            end
			local positionX = heroAnimeNode:getPositionX()
			positionX = positionX --+ 35
			heroAnimeNode:setPositionX(positionX)
        end
        --右边角色脚下的光阵位置
        local imgFootLight = GetElement(element, "imgFootLight_CellPlayer", WZUIImage)
        imgFootLight:setFile("ui/common/common_pic_fazheng5.png")
        imgFootLight:setRelativePosition(GlobalMethod:ccp(0.5, 0.32))

        hero:setCampPosition(self.__nRightPlayer)
        if heroMonster then 
		  heroMonster:setCampPosition(self.__nRightPlayer)
        end
		self.__nRightPlayer = self.__nRightPlayer + 1

		--跨服显示区名
		if (WBattleGlobal:getCurrent().m_nServiceMode ~=nil and WBattleGlobal:getCurrent().m_nServiceMode ==1) and WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_NORMAL then --一般战斗，副本战斗
			local txtRightServerName = WZUILabelTTF:luaTo(GetElement(self.m_root,"txtRightServerName_SceneBattleLoading"))
			txtRightServerName:getParentElement():setVisible(true)
			txtRightServerName:setText(self.m_tMakePairOk.serverName[self.__nPlayerIndex])
		end
	end
    if hero.m_nCamp ~= self.m_nMyCamp then
        WZUIProgress:luaTo(GetElement(element,"progPlayerLoad_SceneBattleLoading")):setBgPicture("ui/combat/battle_progress_xingdongzhi_sel.png")
        WZUIImage:luaTo(GetElement(element,string.format("imgPlayerLevelBack%d_SceneBattleLoading",zs))):setFile("ui/combat/common_icon_zhandoubuff.png")
    end
    --Add By Tianxiang_Xu
    --Add For 排位赛
    if (WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_NORMAL) and WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_PW then
        WZLog("********** 排位赛显示信息 *************")
        -- if hero.m_nSegmentLevel ~= nil then
        --     local tabInfo = GetPvpDataByLevel(hero.m_nSegmentLevel)
        --     local imgDi = GetElement(element,"imgLevelIcon_SceneBattleLoading",WZUIImage)
        --     imgDi:setFile("ui/common/"..tabInfo.icon..".png")

        --     GetElement(element, "conPvpRank_SceneBattleLoading", WZUIContainer):setVisible(true)
        -- --    GetElement(element, "txtPVLevelNum_SceneBattleLoading", WZUILabelAtlasFont):setText(tostring(tabInfo.iocn_level))
        --     --设置本周战斗总场数
        --     GetElement(element, "txtWeekFightNum_SceneBattleLoading", WZUILabelTTF):setText(tostring(hero.m_nBattleTimes))
        --     --设置本周战斗胜利场数
        --     GetElement(element, "txtWeekWinNum_SceneBattleLoading", WZUILabelTTF):setText(tostring(hero.m_nWinTimes))
        --     --设置当天连胜场数
        --     GetElement(element, "txtCurWinStreakNum_SceneBattleLoading", WZUILabelTTF):setText(tostring(hero.m_nStreakTimes))
            
        --     if ProjConfig.LANGUAGE == "pt" then
        --         local txtPvpRank1 = GetElement(self.m_root,"txtPvpRank1_SceneBattleLoading",WZUILabelTTF)
        --         txtPvpRank1:setFontSize(18)
        --         txtPvpRank1:setRelativePosition(GlobalMethod:ccp(0.598422,0.5))
        --         txtPvpRank1:setDimensions(GlobalMethod:CCSize(100,0))
        --         local txtPvpRank2 = GetElement(self.m_root,"txtPvpRank2_SceneBattleLoading",WZUILabelTTF)
        --         txtPvpRank2:setFontSize(16)
        --         txtPvpRank2:setRelativePosition(GlobalMethod:ccp(0.76,0.5))
        --         local txtWeekF = GetElement(self.m_root,"txtWeekFightNum_SceneBattleLoading",WZUILabelTTF)
        --         txtWeekF:setFontSize(18)
        --         txtWeekF:setRelativePosition(GlobalMethod:ccp(0.60193,0.5))
        --         local txtPvpRank3 = GetElement(self.m_root,"txtPvpRank3_SceneBattleLoading",WZUILabelTTF)
        --         txtPvpRank3:setFontSize(18) 
        --         GetElement(self.m_root,"txtWeekWinNum_SceneBattleLoading",WZUILabelTTF):setFontSize(18)
        --         GetElement(self.m_root,"txtPvpRank4_SceneBattleLoading",WZUILabelTTF):setFontSize(18)
        --         local txtCurWinS = GetElement(self.m_root,"txtCurWinStreakNum_SceneBattleLoading",WZUILabelTTF)
        --         txtCurWinS:setFontSize(18)
        --         txtCurWinS:setRelativePosition(GlobalMethod:ccp(0.765,0.5))
        --     elseif ProjConfig.LANGUAGE == "tr" or ProjConfig.LANGUAGE == "en" then
        --         local txtPvpRank1 = GetElement(self.m_root,"txtPvpRank1_SceneBattleLoading",WZUILabelTTF)
        --         txtPvpRank1:setScale(0.7)
        --         txtPvpRank1:setRelativePosition(GlobalMethod:ccp(0.63,0.5))
        --         local txtPvpRank2 = GetElement(self.m_root,"txtPvpRank2_SceneBattleLoading",WZUILabelTTF)
        --         txtPvpRank2:setScale(0.7)
        --         txtPvpRank2:setRelativePosition(GlobalMethod:ccp(0.63,0.5))
        --         txtPvpRank2:setDimensions(GlobalMethod:CCSize(160,0))
        --         local txtWeekF = GetElement(self.m_root,"txtWeekFightNum_SceneBattleLoading",WZUILabelTTF)
        --         txtWeekF:setScale(0.7)
        --         txtWeekF:setRelativePosition(GlobalMethod:ccp(0.63,0.47))
        --         local txtCurWinS = GetElement(self.m_root,"txtCurWinStreakNum_SceneBattleLoading",WZUILabelTTF)
        --         txtCurWinS:setScale(0.7)
        --         txtCurWinS:setRelativePosition(GlobalMethod:ccp(0.63,0.35))
        --     end
        -- end
        --排位赛不显示玩家等级
        WZUILabelTTF:luaTo(GetElement(element,"txtPlayerName_SceneBattleLoading")):setText(self.m_tMakePairOk.playerName[self.__nPlayerIndex])
    end
    --Add For 竞技等级
    --积分，练习
    WZLog("hhhhhhhhhhhhh", WBattleGlobal:getCurrent().m_nBattleType, WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle)
    if WBattleGlobal:getCurrent():isArenaStage() then 
        WZLog("wwwwwwwwwww", type(hero.m_nTournamentLevel), hero.m_nTournamentLevel)
        if hero.m_nTournamentLevel then
            GetElement(element, "conTournamentLevel_SceneBattleLoading", WZUIContainer):setVisible(true)
            local txtTournamengLevel = GetElement(element, "txtTournamengLevel_SceneBattleLoading", WZUILabelAtlasFont)
            local imgTournamentLvIcon = GetElement(element, "imgTournamentLvIcon_SceneBattleLoading", WZUIImage)
            local tCurLevelTable = GetIntegralName(hero.m_nTournamentLevel)
            imgTournamentLvIcon:setFile("ui/common/" .. tCurLevelTable.iocn .. ".png")
            --等级
            txtTournamengLevel:setText(tostring(tCurLevelTable.iocn_level))
        end
    end

	self.__nPlayerIndex = self.__nPlayerIndex + 1
	return false
end

--@brief 创建机关
function SceneBattleLoading:_initMachine()
    if self.m_tMapInfo.machine_data == nil or self.m_tMapInfo.machine_data == -1 then
        return
    end
    local machineId = "machine_1001"
    local ctrlBoss = nil
    local pos = nil
    for i,boss in pairs(WBattleGlobal:getCurrent():getBossList()) do
        ctrlBoss = boss
        break
    end
    for index, info in pairs (self.m_tMapInfo.machine_data) do
        machineId = info[1]
        pos = Vector2:create(info[2],info[3])
    end
    WZLog("SceneBattleLoading:_initMachine II",machineId)
    if ctrlBoss and machineId == 1001 then
        local machine = WBattleGlobal:getCurrent():buildMachine(MonsterType.BOSS_PAO,{aniFileIndex = "machine_"..machineId,owner = ctrlBoss})
        machine:setPosition(pos)
    end
    if ctrlBoss and machineId == 1008 then
        WBattleGlobal:getCurrent():buildMachine(MonsterType.BOSS_FIRE,{ctrlBoss:getCamp(),bronPos = pos})
    end
    return true
end

--@brief	获得玩家技能
--@return	#1:true:完成,false:未完成
function SceneBattleLoading:_getPlayerSkill()
    WZLog("SceneBattleLoading:_getPlayerSkill")


    for i=1,WBattleGlobal:getCurrent().m_tMakePairOk.playerCount do
        if true then
			-- item_id : 技能道具ID
			-- item_used : 是否装备道具（1有装备，0没装备，-1锁）
			-- item_img : 道具图像路径
			-- item_name : 道具名称
			-- item_desc : 道具描述
			-- item_type : 道具类型
			-- item_subType : 道具子类型
			-- item_param1 : 参数1
			-- item_param2 : 参数2
			-- item_ConsumePower : 消耗体力
			-- specialAttackType : 附加的特殊攻击类型
			-- specialAttackParam : 附加的特殊攻击数值参数

            local id={}
            local name={}
            local icon={}
            local lv={}
            local priceCostGold={}
            local desc={}
            local itemMainType={}
            local itemSubType={}
            local param1={}
            local param2={}
            local tireValue={}
            local consumePower={}
            local specialAttackType={}
            local specialAttackParam={}
            local effectId={}
            local coolSkillTime = {}
            local startCoolSkillTime = {}

            local weaponId = WBattleGlobal:getCurrent().m_tMakePairOk.weaponId[i]
            local weaponInfo = SplitStringWithSeparator(WBattleGlobal:getCurrent().m_tMakePairOk.petSkill[i], "|", nil, true)

            WZLog("SceneBattleLoading:_getPlayerSkill 00000", Serialize(weaponInfo))
            for j, v in ipairs (weaponInfo) do
                local isTeach = nil
                local isEndTeach1, step1 = TeachGroup1:isTeachFinish(1)
                if false or (TeachGroup1:isTeach() and WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_SINGLE) and ( isEndTeach1 == false and CacheCenter:getPlayerInfo().level <= 3)) then
                    isTeach = true
                end
                if true --[[(i ~= 5 and isTeach) or isTeach ~= true]] then
                    local itemId = v
                    --itemId = 88
                    if itemId == 0 then
                        table.insert(id,0)
                    elseif itemId == -1 then
                        table.insert(id,-1)
                    end

                    local skill = GDatatab_skill["id_"..itemId]
                    WZLog("SceneBattleLoading:_getPlayerSkill one", i, itemId, skill, WBattleGlobal:getCurrent():getMyBattleId(), WBattleGlobal:getCurrent().m_tMakePairOk.playerId[i])
                    local bIsNoCoolTime = false 
                    if self.m_tNoCoolTimeSubType and (itemId ~= 0 and itemId ~= -1) then
                        for i = 1, #self.m_tNoCoolTimeSubType do
                            if skill.id_group == self.m_tNoCoolTimeSubType[i] then
                                bIsNoCoolTime = true 
                                break 
                            end
                        end
                    end
                    WZLog("SceneBattleLoading:_getPlayerSkill TTTT", WBattleGlobal:getCurrent().m_nBattleType, WBattleGlobal:getCurrent().m_tMakePairOk.battleMode, WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle, bIsNoCoolTime)
                    if (itemId ~= 0 and itemId ~= -1) then 
                        if (skill.skill_type == 0 or skill.skill_type == -1) then
                            table.insert(id,itemId)
                            local itemInfo = {name = 0, icon = 0, lv = 0, desc = 0, type = 0, subType = 0, parm1 = 0, parm2 = 0, consume = 0, specialAttackType = 0, specialAttackParam = 0, effect_id = {{-1}},cooling_time = 0,start_time=0,}
                            if itemId > 0 and GDatatab_skill["id_"..itemId] then
                                itemInfo = GDatatab_skill["id_"..itemId]
                            end

                            table.insert(name,itemInfo.name)
                            table.insert(icon,itemInfo.icon == -1 and "battleitems/pound.png" or itemInfo.icon)
                            table.insert(lv,itemInfo.lv_icon == -1 and "battleitems/battle_icon_jnl1.png" or itemInfo.lv_icon)
                            table.insert(priceCostGold,0)
                            table.insert(consumePower,itemInfo.consume)
                            table.insert(specialAttackType,itemInfo.specialAttackType)
                            table.insert(specialAttackParam,itemInfo.specialAttackParam)
                                table.insert(effectId,itemInfo.effect_id[1][1])
                                table.insert(itemSubType,itemInfo.sub_type)

                            
                            if WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_TRAIN)then
                                table.insert(coolSkillTime,0)
                                table.insert(startCoolSkillTime,0)
                            else
                                if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_NORMAL and WBattleGlobal:getCurrent().m_tMakePairOk.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_WK and WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL and bIsNoCoolTime then
                                    table.insert(coolSkillTime, 0)
                                    table.insert(startCoolSkillTime, 0)
                                else
                                    table.insert(coolSkillTime,itemInfo.cooling_time)
                                    table.insert(startCoolSkillTime,itemInfo.start_time)
                                end
                            end
                            WZLog("SceneBattleLoading:_getPlayerSkill two", tostring(itemInfo.name), tostring(itemInfo.cooling_time), tostring(itemInfo.effect_id[1][1]))
                        elseif skill.skill_type == 5 and WBattleGlobal:getCurrent():getMyBattleId() == WBattleGlobal:getCurrent().m_tMakePairOk.playerId[i] then
                            if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_NORMAL and WBattleGlobal:getCurrent().m_tMakePairOk.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_JH then 
                            else
                                WBattleGlobal.getCurrent().m_nAwakeSkillId  = itemId
                            end
                        end
				    elseif itemId == 0 or itemId == -1 then
                        local itemInfo = {name = 0, icon = 0, lv = 0, desc = 0, type = 0, subType = 0, parm1 = 0, parm2 = 0, consume = 0, specialAttackType = 0, specialAttackParam = 0, effect_id = {{-1}},cooling_time = 0,start_time=0,}
                        table.insert(name,itemInfo.name)
                        table.insert(icon,itemInfo.icon == -1 and "battleitems/pound.png" or itemInfo.icon)
                        table.insert(lv,itemInfo.lv_icon == -1 and "battleitems/battle_icon_jnl1.png" or itemInfo.lv_icon)
                        table.insert(priceCostGold,0)
                        table.insert(consumePower,itemInfo.consume)
                        table.insert(specialAttackType,itemInfo.specialAttackType)
                        table.insert(specialAttackParam,itemInfo.specialAttackParam)
                        table.insert(effectId,itemInfo.effect_id[1][1])
                        table.insert(itemSubType,itemInfo.sub_type)
                        
                        if WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_TRAIN)then
                            table.insert(coolSkillTime,0)
                            table.insert(startCoolSkillTime,0)
                        else
                            if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_NORMAL and WBattleGlobal:getCurrent().m_tMakePairOk.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_WK and WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL and bIsNoCoolTime then
                                    table.insert(coolSkillTime, 0)
                                    table.insert(startCoolSkillTime, 0)
                            else
                                table.insert(coolSkillTime,itemInfo.cooling_time)
                                table.insert(startCoolSkillTime,itemInfo.start_time)
                            end
                        end
                    end
                end
			end

            if WBattleGlobal:getCurrent():getMyBattleId() == WBattleGlobal:getCurrent().m_tMakePairOk.playerId[i] then
                WBattleGlobal:getCurrent().m_tMySkill_Beginning = {count=5, id=id, name=name, icon=icon,lv=lv, priceCostGold=priceCostGold, desc=desc, itemMainType=itemMainType, itemSubType=itemSubType, param1=param1, param2=param2, tireValue=tireValue, consumePower=consumePower, specialAttackType=specialAttackType, specialAttackParam=specialAttackParam, effectId=effectId, coolSkillTime=coolSkillTime, startCoolSkillTime=startCoolSkillTime}

                WZLog("SceneBattleLoading:_getPlayerSkill three-1", weaponId, Serialize(WBattleGlobal:getCurrent().m_tMySkill_Beginning))
                WBattleGlobal:getCurrent().m_tSkillList = {}
                for i,v in pairs(GDatatab_skill) do
                    if v.skill_type == 0 or v.skill_type == -1 or v.skill_type == 2 or v.skill_type == 5 then
                        WZLog("SceneBattleLoading:_getPlayerSkill three-2",v.name,v.id)
                        local skillList
                        if WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_TRAIN)then
                            skillList = { name=v.name, icon=v.icon, lv=v.lv_icon, itemSubType= v.id, param1=5, param2=5, coolSkillTime = 0,damageRange = v.specialAttackType ,consumePower=v.consume, specialAttackType=v.specialAttackType, specialAttackParam=v.specialAttackParam, effectId=v.effect_id[1][1], startCoolSkillTime = 0}
                        else
                            local nTempCoolTime = v.cooling_time
                            local nTempStartTime = v.start_time
                            local bIsNoCoolTime2 = false 
                            if self.m_tNoCoolTimeSubType then
                                for k = 1, #self.m_tNoCoolTimeSubType do
                                    if v.id_group == self.m_tNoCoolTimeSubType[k] then
                                        bIsNoCoolTime2 = true 
                                        break 
                                    end
                                end
                            end
                            if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_NORMAL and WBattleGlobal:getCurrent().m_tMakePairOk.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_WK and WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL and bIsNoCoolTime2 then
                                nTempCoolTime = 0
                                nTempStartTime = 0
                            end
                            skillList = { name=v.name, icon=v.icon, lv=v.lv_icon, itemSubType= v.id, param1=5, param2=5, coolSkillTime = nTempCoolTime,damageRange = v.specialAttackType ,consumePower=v.consume, specialAttackType=v.specialAttackType, specialAttackParam=v.specialAttackParam, effectId=v.effect_id[1][1], startCoolSkillTime = nTempStartTime}
                        end
                        WBattleGlobal:getCurrent().m_tSkillList[ v.id ] = skillList
                    end
                end
            --    WZLog("SceneBattleLoading:_getPlayerSkill four-1", Serialize(WBattleGlobal:getCurrent().m_tSkillList))
            else
                local hero = WBattleGlobal:getCurrent():getCharacterWithId(WBattleGlobal:getCurrent().m_tMakePairOk.playerId[i])
                hero.m_tSkills = CopyTable(id)
                local heroMonster = WBattleGlobal:getCurrent():getHeroMonster()
                if heroMonster and heroMonster:getId() == hero:getId() then 
                    heroMonster.m_tSkills = CopyTable(id)
                end
                WZLog("SceneBattleLoading:_getPlayerSkill four", hero:getBattleId() ,Serialize(hero.m_tSkills))
            end

            if WBattleGlobal:getCurrent():isAudience() then
                if WBattleGlobal:getCurrent().m_tHudSkill == nil then
                    WBattleGlobal:getCurrent().m_tHudSkill = {}
                end
                local playerId = WBattleGlobal:getCurrent().m_tMakePairOk.playerId[i]
                WBattleGlobal:getCurrent().m_tHudSkill[playerId] = {playerId=playerId, count=5, id=id, name=name, icon=icon,lv=lv, priceCostGold=priceCostGold, desc=desc, itemMainType=itemMainType, itemSubType=itemSubType, param1=param1, param2=param2, tireValue=tireValue, consumePower=consumePower, specialAttackType=specialAttackType, specialAttackParam=specialAttackParam, effectId=effectId, coolSkillTime=coolSkillTime, startCoolSkillTime=startCoolSkillTime}
            end

            local hero = WBattleGlobal:getCurrent():getCharacterWithId(WBattleGlobal:getCurrent().m_tMakePairOk.playerId[i])

            hero.m_nBigSkillType = GDatatab_item["id_"..weaponId].value
            local heroMonster = WBattleGlobal:getCurrent():getHeroMonster()
            local bSameHero = false 
            if heroMonster and heroMonster:getId() == hero:getId() then 
                bSameHero = true 
                heroMonster.m_nBigSkillType = GDatatab_item["id_"..weaponId].value
            end
            WZLog("SceneBattleLoading:_getPlayerSkill five",i, WBattleGlobal:getCurrent().m_tMakePairOk.playerId[i], hero.m_nBigSkillType)
            local skillList = {count=5, id=id, name=name, icon=icon, lv=lv , priceCostGold=priceCostGold, desc=desc, itemMainType=itemMainType, itemSubType=itemSubType, param1=param1, param2=param2, tireValue=tireValue, consumePower=consumePower, specialAttackType=specialAttackType, specialAttackParam=specialAttackParam, effectId=effectId, coolSkillTime=coolSkillTime, startCoolSkillTime=startCoolSkillTime}


            for index, id in pairs (skillList.id) do
                if id ~= -1 and id ~= 0 then
                    hero.m_tSkillCdList[id] = skillList.startCoolSkillTime[index]
                    if bSameHero then 
                        heroMonster.m_tSkillCdList[id] = skillList.startCoolSkillTime[index]
                    end
                    WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_GotoBattle one-1",index,id, skillList.startCoolSkillTime[index])
                end
            end
            local flySkillId = BattleHeroUse.FLY_SKILL_ID
            hero.m_tSkillCdList[flySkillId] = GDatatab_skill["id_"..flySkillId].start_time
            if bSameHero then 
                heroMonster.m_tSkillCdList[flySkillId] = GDatatab_skill["id_"..flySkillId].start_time
            end
            if WBattleGlobal:getCurrent():isFlyCopy() then
                hero.m_tSkillCdList[flySkillId] = 0
            end
            WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_GotoBattle one-2",hero.m_tSkillCdList[flySkillId])
            --觉醒之技
            if WBattleGlobal.getCurrent().m_nAwakeSkillId and WBattleGlobal:getCurrent():getMyBattleId() == WBattleGlobal:getCurrent().m_tMakePairOk.playerId[i] then
                local nAwakSKillId = WBattleGlobal.getCurrent().m_nAwakeSkillId
                hero.m_tSkillCdList[nAwakSKillId] = GDatatab_skill["id_" .. nAwakSKillId].start_time
                if bSameHero then 
                    heroMonster.m_tSkillCdList[nAwakSKillId] = GDatatab_skill["id_" .. nAwakSKillId].start_time
                end
            end
		end
	end
	return true
end

--@brief    获得玩家宠物技能
--@return   #1:true:完成,false:未完成
function SceneBattleLoading:_getPetSkill()
    WZLog("SceneBattleLoading:_getPetSkill")
    BattlePetSkillManager:start()
    if WBattleGlobal:getCurrent().m_tMakePairOk.petSkill == nil then
        return
    end
    for i=1,WBattleGlobal:getCurrent().m_tMakePairOk.playerCount do
        if true then
            local id={}
            local name={}
            local icon={}
            local lv={}
            local itemMainType={}
            local itemSubType={}
            local effectId={}
            local coolSkillTime = {}
            local startCoolSkillTime = {}
            local rate = {}

            --WBattleGlobal:getCurrent().m_tMakePairOk.petSkill[i] = "60301|60401|60501"
            local petInfo = SplitStringWithSeparator(WBattleGlobal:getCurrent().m_tMakePairOk.petSkill[i], "|", nil, true)

            for i, v in ipairs (petInfo) do
                local itemId = v
                local skill = GDatatab_skill["id_"..itemId]

                WZLog("BattleLoading:_getPetSkill five", tostring(itemId), type(itemId), skill)
                if skill ~= nil and skill.skill_type == 4 then
                    table.insert(id,itemId)
                    local itemInfo = {name = 0, icon = 0, lv = 0, desc = 0, type = 0, subType = -1, parm1 = 0, parm2 = 0, consume = 0, specialAttackType = 0, specialAttackParam = 0, effect_id = {{-1}},cooling_time = 0,start_time=0,rate=0}
                    if tostring(itemId) ~= "" and itemId > 0 and GDatatab_skill["id_"..itemId] then
                        itemInfo = GDatatab_skill["id_"..itemId]
                    end
                    table.insert(name,itemInfo.name)
                    table.insert(icon,itemInfo.icon == -1 and "battleitems/pound.png" or itemInfo.icon)
                    table.insert(lv,itemInfo.lv_icon == -1 and "battleitems/battle_icon_jnl1.png" or itemInfo.lv_icon)
                    table.insert(itemMainType,itemInfo.skill_type)
                    table.insert(itemSubType,itemInfo.sub_type)
                    table.insert(effectId,itemInfo.effect_id[1][1])
                    table.insert(coolSkillTime,itemInfo.cooling_time)
                    table.insert(startCoolSkillTime,itemInfo.start_time)
                    table.insert(rate,itemInfo.rate)
                    WZLog("SceneBattleLoading:_getPetSkill two", tostring(itemInfo.name), tostring(itemInfo.cooling_time), tostring(itemInfo.effect_id[1][1]))
                end
            end

            local hero = WBattleGlobal:getCurrent():getCharacterWithId(WBattleGlobal:getCurrent().m_tMakePairOk.playerId[i])
            hero.m_tPetSkills = {count= #id, id=id, name=name, icon=icon,lv=lv, itemMainType=itemMainType, itemSubType=itemSubType, effectId=effectId, coolSkillTime=coolSkillTime, startCoolSkillTime=startCoolSkillTime, rate=rate} --CopyTable(id)
            local heroMonster = WBattleGlobal:getCurrent():getHeroMonster()
            if heroMonster and heroMonster:getId() == hero:getId() then 
                heroMonster.m_tPetSkills = {count= #id, id=id, name=name, icon=icon,lv=lv, itemMainType=itemMainType, itemSubType=itemSubType, effectId=effectId, coolSkillTime=coolSkillTime, startCoolSkillTime=startCoolSkillTime, rate=rate}
            end
            if WBattleGlobal:getCurrent():getMyBattleId() == WBattleGlobal:getCurrent().m_tMakePairOk.playerId[i] then
                WBattleGlobal:getCurrent().m_tMyPetSkill_Beginning = {count= #id, id=id, name=name, icon=icon,lv=lv, itemMainType=itemMainType, itemSubType=itemSubType, effectId=effectId, coolSkillTime=coolSkillTime, startCoolSkillTime=startCoolSkillTime, rate=rate}
                WZLog("SceneBattleLoading:_getPetSkill three-1", Serialize(WBattleGlobal:getCurrent().m_tMySkill_Beginning))
                WBattleGlobal:getCurrent().m_tPetSkillList = {}
                for i,v in pairs(GDatatab_skill) do
                    if v.skill_type == 4 then
                        WZLog("SceneBattleLoading:_getPetSkill three-2",v.name,v.id)
                        local skillList = { name=v.name, icon=v.icon, lv=v.lv_icon, itemSubType= v.sub_type, param1=5, param2=5, coolSkillTime = v.cooling_time,damageRange = v.specialAttackType ,consumePower=v.consume, specialAttackType=v.specialAttackType, specialAttackParam=v.specialAttackParam, effectId=v.effect_id[1][1], startCoolSkillTime = v.start_time}
                        WBattleGlobal:getCurrent().m_tPetSkillList[ v.id ] = skillList
                    end
                end
            end
            WZLog("SceneBattleLoading:_getPetSkill four", hero:getBattleId() ,Serialize(hero.m_tPetSkills))
        end
    end
    return true
end

--@brief	获得玩家技能
--@return	#1:true:完成,false:未完成
function SceneBattleLoading:_getPlayerProp()
    WZLog("SceneBattleLoading:_getPlayerProp")

    local heroMonster = WBattleGlobal:getCurrent():getHeroMonster()
    
    for i=1,WBattleGlobal:getCurrent().m_tMakePairOk.playerCount do
        if true then
            -- item_id : 技能道具ID
			-- item_used : 是否装备道具（1有装备，0没装备，-1锁）
			-- item_img : 道具图像路径
			-- item_name : 道具名称
			-- item_desc : 道具描述
			-- item_type : 道具类型
			-- item_subType : 道具子类型
			-- item_param1 : 参数1
			-- item_param2 : 参数2
			-- item_ConsumePower : 消耗体力
			-- specialAttackType : 附加的特殊攻击类型
			-- specialAttackParam : 附加的特殊攻击数值参数

            local id={}
            local name={}
            local icon={}
            local lv={}
            local priceCostGold={}
            local desc={}
            local itemMainType={}
            local itemSubType={}
            local param1={}
            local param2={}
            local tireValue={}
            local consumePower={}
            local specialAttackType={}
            local specialAttackParam={}
            local effectId={}
            local coolSkillTime = {}
            local startCoolSkillTime = {}

            local index = 1 + 5*(i-1)
            local openCount = 0
            local closeCount = 0
            for i = index, index+ 4 do
                local item = WBattleGlobal:getCurrent().m_tMakePairOk.item_id[i]
                local itemId = item <= 0 and item or item
                --itemId = 164

                local itemInfo = {name = 0, icon = 0, lv = 0, desc = 0, type = 0, subType = 0, parm1 = 0, parm2 = 0, consume = 0, specialAttackType = 0, specialAttackParam = 0, effect_id = {{-1}},cooling_time = 0,start_time=0,}
                if itemId > 0 and GDatatab_skill["id_"..itemId] then
                    table.insert(id,itemId)
                    itemInfo = GDatatab_skill["id_"..itemId]
                    table.insert(name,itemInfo.name)
                    table.insert(icon,itemInfo.icon)
                    table.insert(lv,itemInfo.lv_icon)
                    table.insert(priceCostGold,0)
                    table.insert(consumePower,itemInfo.consume)
                    table.insert(specialAttackType,itemInfo.specialAttackType)
                    table.insert(specialAttackParam,itemInfo.specialAttackParam)
                    table.insert(effectId,itemInfo.effect_id[1][1])
                    table.insert(coolSkillTime,itemInfo.cooling_time)
                    table.insert(startCoolSkillTime,itemInfo.start_time)
                    
                elseif itemId == 0 then
                    openCount = openCount + 1
                elseif itemId == -1 then
                    closeCount = closeCount + 1
                end
            end

            WZLog("SceneBattleLoading:_getPlayerProp two", openCount, closeCount)
            for i = 1, openCount do
                table.insert(id,0)
                local itemInfo = {name = 0, icon = 0, lv = 0, desc = 0, type = 0, subType = 0, parm1 = 0, parm2 = 0, consume = 0, specialAttackType = 0, specialAttackParam = 0, effect_id = {{-1}},cooling_time = 0,start_time=0,}
                table.insert(name,itemInfo.name)
                table.insert(icon,itemInfo.icon)
                table.insert(lv,itemInfo.lv_icon)
                table.insert(priceCostGold,0)
                table.insert(consumePower,itemInfo.consume)
                table.insert(specialAttackType,itemInfo.specialAttackType)
                table.insert(specialAttackParam,itemInfo.specialAttackParam)
                table.insert(effectId,itemInfo.effect_id[1][1])
                table.insert(coolSkillTime,itemInfo.cooling_time)
                table.insert(startCoolSkillTime,itemInfo.start_time)
            end

            for i = 1, closeCount do
                table.insert(id,-1)
                local itemInfo = {name = 0, icon = 0, lv = 0, desc = 0, type = 0, subType = 0, parm1 = 0, parm2 = 0, consume = 0, specialAttackType = 0, specialAttackParam = 0, effect_id = {{-1}},cooling_time = 0,start_time=0,}
                table.insert(name,itemInfo.name)
                table.insert(icon,itemInfo.icon)
                table.insert(lv,itemInfo.lv_icon)
                table.insert(priceCostGold,0)
                table.insert(consumePower,itemInfo.consume)
                table.insert(specialAttackType,itemInfo.specialAttackType)
                table.insert(specialAttackParam,itemInfo.specialAttackParam)
                table.insert(effectId,itemInfo.effect_id[1][1])
                table.insert(coolSkillTime,itemInfo.cooling_time)
                table.insert(startCoolSkillTime,itemInfo.start_time)
            end

            if WBattleGlobal:getCurrent():getMyBattleId() == WBattleGlobal:getCurrent().m_tMakePairOk.playerId[i] then
                WBattleGlobal:getCurrent().m_tMyProp_Beginning = {count=5, id=id, name=name, icon=icon, lv=lv, priceCostGold=priceCostGold, desc=desc, itemMainType=itemMainType, itemSubType=itemSubType, param1=param1, param2=param2, tireValue=tireValue, consumePower=consumePower, specialAttackType=specialAttackType, specialAttackParam=specialAttackParam, effectId=effectId, coolSkillTime=coolSkillTime, startCoolSkillTime=startCoolSkillTime}

                WZLog("SceneBattleLoading:_getPlayerProp three",Serialize(WBattleGlobal:getCurrent().m_tMyProp_Beginning))

                WBattleGlobal:getCurrent().m_tPropList = {}
                local _id = {4,5,0,1,2,6}
                _id[0] = 7
                for i,v in pairs(GDatatab_skill) do
                    if v.skill_type == 1 or v.skill_type == 9 then
                        local skillList = { name=v.name, icon=v.icon, lv=v.lv_icon, itemSubType= v.id , param1=5, param2=5, coolSkillTime = v.cooling_time,damageRange = v.specialAttackType ,consumePower=v.consume, specialAttackType=v.specialAttackType, specialAttackParam=v.specialAttackParam, effectId=v.effect_id[1][1], startCoolSkillTime = v.start_time}
                        WBattleGlobal:getCurrent().m_tPropList[ v.id ] = skillList
                    end
                end

                WZLog("SceneBattleLoading:_getPlayerSkill five-1", Serialize(WBattleGlobal:getCurrent().m_tPropList))

            else
                local hero = WBattleGlobal:getCurrent():getCharacterWithId(WBattleGlobal:getCurrent().m_tMakePairOk.playerId[i])
                hero.m_tItems = CopyTable(id)
                if heroMonster and heroMonster:getId() == hero:getId() then 
                    heroMonster.m_tItems = CopyTable(id)
                end
                WZLog("SceneBattleLoading:_getPlayerSkill five", hero:getBattleId() ,Serialize(hero.m_tItems))
            end

            local hero = WBattleGlobal:getCurrent():getCharacterWithId(WBattleGlobal:getCurrent().m_tMakePairOk.playerId[i])

            local skillList = {count=5, id=id, name=name, icon=icon, lv=lv , priceCostGold=priceCostGold, 
                consumePower=consumePower, specialAttackType=specialAttackType, specialAttackParam=specialAttackParam,
                 effectId=effectId, coolSkillTime=coolSkillTime, startCoolSkillTime=startCoolSkillTime}

            for index, id in pairs (skillList.id) do
                if id ~= -1 and id ~= 0 then
                    hero.m_tItemCdList[id] = skillList.startCoolSkillTime[index]
                    if heroMonster and heroMonster:getId() == hero:getId() then 
                        heroMonster.m_tItemCdList[id] = skillList.startCoolSkillTime[index]
                    end
                    WZLog("SceneBattleLoading:_getPlayerProp four",index, id, skillList.startCoolSkillTime[index])
                end
            end

            if WBattleGlobal:getCurrent():isAudience() then
                if WBattleGlobal:getCurrent().m_tHudItem == nil then
                    WBattleGlobal:getCurrent().m_tHudItem = {}
                end
                local playerId = WBattleGlobal:getCurrent().m_tMakePairOk.playerId[i]
                WBattleGlobal:getCurrent().m_tHudItem[playerId] = {playerId=playerId, count=5, id=id, name=name, icon=icon, lv=lv, priceCostGold=priceCostGold, desc=desc, itemMainType=itemMainType, itemSubType=itemSubType, param1=param1, param2=param2, tireValue=tireValue, consumePower=consumePower, specialAttackType=specialAttackType, specialAttackParam=specialAttackParam, effectId=effectId, coolSkillTime=coolSkillTime, startCoolSkillTime=startCoolSkillTime}
            end
		end
	end
	return true
end

--@brief	显示玩家技能道具(仅限排位赛)
function SceneBattleLoading:_showPlayerSkillProp()
	for i=1,WBattleGlobal:getCurrent().m_tMakePairOk.playerCount do
		local tbconSkillProp = GetElement(self.m_root,string.format("tbconCamp%dSkillProp_SceneBattleLoading",WBattleGlobal:getCurrent().m_tMakePairOk.camp[i]),WZUITableContainer)
		tbconSkillProp:cleanTable()
		tbconSkillProp:setVisible(true)
		for j=1,8 do
			if WBattleGlobal:getCurrent().m_tMakePairOk.item_used[(i-1)*8+j] == 1 then
				local conSkillProp = WZUISystem:getInstance():createElement("conSkillProp_SceneBattleLoading")
				GetElement(conSkillProp,"imgSkillProp_SceneBattleLoading",WZUIImage):setFile(WBattleGlobal:getCurrent().m_tMakePairOk.item_img[(i-1)*8+j])
				conSkillProp:setTag(j-1)
				conSkillProp:setVisible(true)
				tbconSkillProp:setCellElement(conSkillProp)
			end
		end
	end
end

--@brief    根据分隔符拆分ai字符串"
function SceneBattleLoading:_SplitPosStringWithSeparator(s)
    WZLog("SceneBattleLoading:_SplitPosStringWithSeparator 0", s)
    local nFindStartIndex = 1
    local nSplitIndex = 1
    local nSplitArray = {}
    local sSeparator = " | "
    local sChange = "%]%&%["
    local sChanged = " | "
    
    s = string.gsub(s, " ", "")
    s = string.gsub(s, sChange, sChanged)
    s = string.gsub(s, "%[", "")
    s = string.gsub(s, "%]", "")
    --WZLog("SplitAiStringWithSeparator 1", s)
    
    nSplitArray = SplitStringWithSeparator(s, sSeparator)
    
    for i, v in pairs(nSplitArray) do
        if v == nil or v == "" then
            break
        end
        --WZLog("SplitAiStringWithSeparator array: ", tostring(v), i)
        nSplitArray[i] = BattleMsgBossMapSkill:_splitStringWithSeparator(v, ",")
        
        for j, u in pairs (nSplitArray[i]) do
           --WZLog("SplitAiStringWithSeparator array[j]: ", u, j)
        end
    end
    
    WZLog("SceneBattleLoading:_SplitPosStringWithSeparator one", Serialize(nSplitArray))
    return nSplitArray
end

--@brief	获得玩家位置
--@return	#1:true:完成,false:未完成
function SceneBattleLoading:_getCharacterPos()
    WZLog("SceneBattleLoading:_getCharacterPos one", tostring(self.__bReceivePos), WBattleGlobal:getCurrent().m_tMakePairOk.mapId)

    local heroMonster = WBattleGlobal:getCurrent():getHeroMonster()

	if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS or (WBattleGlobal:getCurrent():isSingleStage() and not WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_DAILY)) then
		local born_position = self.m_tMapInfo.position
		local monster_data = CopyTable(self.m_tMapInfo.monster)
        if WBattleGlobal:getCurrent():isCopyTeach() then
            born_position = {}
            table.insert(born_position, {[1]=241,[2]=387})
            table.insert(born_position, {[1]=51,[2]=380})
            table.insert(born_position, {[1]=151,[2]=370})
        end
        WZLog("SceneBattleLoading:_getCharacterPos two", Serialize(born_position), Serialize(monster_data))
        
		local heroList = {}
        for id,hero in pairs(WBattleGlobal:getCurrent():getHeroList()) do
            table.insert(heroList, {obj=hero, id=id})
        end

        local index = 1
        Teach:bubbleSort(heroList, "id")
        for id, hero in ipairs(heroList) do
            if WBattleGlobal:getCurrent():getMyBattleId() == hero.obj:getBattleId() then
                WBattleGlobal:getCurrent().m_tFirstPos = {x=born_position[index][1],y=born_position[index][2]}
            end
			hero.obj:setPosition(Vector2:create(born_position[index][1],born_position[index][2]))
            if heroMonster and heroMonster:getId() == hero:getId() then 
                heroMonster.obj:setPosition(Vector2:create(born_position[index][1],born_position[index][2]))
            end
            index = index + 1
        end

        for id,guai in pairs(WBattleGlobal:getCurrent():getGuaiList()) do
            WZLog("rrrrrrrrrrrrrrrrrrr", id, guai.m_nIndexId)
            for index,guaiInfo in pairs(monster_data) do
                WZLog("kkkkkkkkkkkkkkkk", guai.m_nIndexId, guaiInfo[1], index)
                if guai.m_nIndexId == guaiInfo[1] then
                    guai:setPosition(Vector2:create(guaiInfo[2],guaiInfo[3]))
                    table.remove(monster_data,index)
                    break
                end
            end
        end
        if WBattleGlobal:getCurrent():isFlyCopy() then
            for id,guai in pairs(WBattleGlobal:getCurrent():getGuaiList()) do
                local guaiInfo = self.m_tMapInfo.monster[1]
                guai:setPosition(Vector2:create(guaiInfo[2],guaiInfo[3]))
                WZLog("SceneBattleLoading:_getCharacterPos three", guaiInfo[2], guaiInfo[3])
            end
        end
        return true
	end

	--do return end

    if self.__bReceivePos == nil  then
		self.__bReceivePos = false
		
		--BattleMapManager:loadMap(self.m_tMakePairOk.battleMap:match("%d+"))
		
		local xV = WZLuaVector_int_:create()
		local yV = WZLuaVector_int_:create()

        --BattleMapManager.m_tPositions = {{nPosX=1500,nPosY=500},{nPosX=1200,nPosY=500},{nPosX=1300,nPosY=500}}
		for i,pos in pairs(BattleMapManager.m_tPositions) do
			xV:push(pos.nPosX)
			yV:push(pos.nPosY)
		end
		
		ProtocolProcessorBattleInterface:send_BATTLE_PositionsInMap(self.m_tMakePairOk.battleId,xV:size(),xV,yV,WBattleGlobal:getCurrent():getMyBattleId())
	end

	if self.__bReceivePos == true --[[and self.m_bIsTestLink == true]] then
		self.__bReceivePos = nil
		WBattleGlobal:getCurrent().m_tPlayerBornPt = {}
		if self.m_tPlayerPos ~= nil then
			for i=1,self.m_tPlayerPos.idcount do
				local hero = WBattleGlobal:getCurrent():getHeroWithId(self.m_tPlayerPos.playerIds[i])
				if hero ~= nil then
					local vec2 = Vector2:create(self.m_tPlayerPos.postionX[i],self.m_tPlayerPos.postionY[i])
					hero:setPosition(vec2)
                    if heroMonster and heroMonster:getId() == hero:getId() then 
                        heroMonster:setPosition(vec2)
                    end
                    if WBattleGlobal:getCurrent():getMyBattleId() == hero:getBattleId() then
                        WBattleGlobal:getCurrent().m_tFirstPos = {x=self.m_tPlayerPos.postionX[i],y=self.m_tPlayerPos.postionY[i]}
                    end
                    WBattleGlobal:getCurrent().m_tPlayerBornPt[self.m_tPlayerPos.playerIds[i]] = {x=self.m_tPlayerPos.postionX[i],y=self.m_tPlayerPos.postionY[i]}
				end
			end
		end

		return true
	else
		return false
	end

end

--@brief	获得技能列表
--@return	#1:true:完成,false:未完成
function SceneBattleLoading:_getSkillList()
    WZLog("SceneBattleLoading:_getSkillList")
	if self.__bReceiveSkill == nil then
		self.__bReceiveSkill = false
		
		ProtocolProcessorBattleInterface:send_PLAYER_GetSkillList()
	end
	
	if self.__bReceiveSkill == true then
		self.__bReceiveSkill = nil
		return true
	else
		return false
	end
end

--@brief	获得道具列表
--@return	#1:true:完成,false:未完成
function SceneBattleLoading:_getPropList()
    WZLog("SceneBattleLoading:_getPropList")
	if self.__bReceiveProp == nil then
		self.__bReceiveProp = false
		
		ProtocolProcessorBattleInterface:send_PLAYER_GetPropList()
	end
	
	if self.__bReceiveProp == true then
		self.__bReceiveProp = nil
		return true
	else
		return false
	end
end

--@brief	添加技能
function SceneBattleLoading:addSkill(nameValue,iconValue,priceCostGoldValue,descValue,itemMainTypeValue,itemSubTypeValue,param1Value,param2Value,tireValueValue,consumePowerValue,specialAttackTypeValue,specialAttackParamValue)

    table.insert(self.m_tSkillList.name, nameValue)
    table.insert(self.m_tSkillList.icon, iconValue)
    table.insert(self.m_tSkillList.priceCostGold, priceCostGoldValue)
    table.insert(self.m_tSkillList.desc, descValue)

    table.insert(self.m_tSkillList.itemMainType, itemMainTypeValue)
    table.insert(self.m_tSkillList.itemSubType, itemSubTypeValue)
    table.insert(self.m_tSkillList.param1, param1Value)
    table.insert(self.m_tSkillList.param2, param2Value)

    table.insert(self.m_tSkillList.tireValue, tireValueValue)
    table.insert(self.m_tSkillList.consumePower, consumePowerValue)
    table.insert(self.m_tSkillList.specialAttackType, specialAttackTypeValue)
    table.insert(self.m_tSkillList.specialAttackParam, specialAttackParamValue)
end

--@brief	添加道具
function SceneBattleLoading:addProp(nameValue,iconValue,priceCostGoldValue,descValue,itemMainTypeValue,itemSubTypeValue,param1Value,param2Value,tireValueValue,consumePowerValue,specialAttackTypeValue,specialAttackParamValue)

    table.insert(self.m_tPropList.name, nameValue)
    table.insert(self.m_tPropList.icon, iconValue)
    table.insert(self.m_tPropList.priceCostGold, priceCostGoldValue)
    table.insert(self.m_tPropList.desc, descValue)

    table.insert(self.m_tPropList.itemMainType, itemMainTypeValue)
    table.insert(self.m_tPropList.itemSubType, itemSubTypeValue)
    table.insert(self.m_tPropList.param1, param1Value)
    table.insert(self.m_tPropList.param2, param2Value)

    table.insert(self.m_tPropList.tireValue, tireValueValue)
    table.insert(self.m_tPropList.consumePower, consumePowerValue)
    table.insert(self.m_tPropList.specialAttackType, specialAttackTypeValue)
    table.insert(self.m_tPropList.specialAttackParam, specialAttackParamValue)
end

--@brief    单人副本处理
--@return   #1:true:完成,false:未完成
function SceneBattleLoading:_endLoadingWithSingleMap()
    if WBattleGlobal:getCurrent():isReplayGame() then
        return
    end
    
    WBattleGlobal:getCurrent().m_tSingleActivityMemberList = {}
    local memberList = WBattleGlobal:getCurrent().m_tSingleActivityMemberList
    local guaiList = WBattleGlobal:getCurrent():getGuaiList()
    
    table.insert(memberList, WBattleGlobal:getCurrent():getCharacterWithId(-2))
    for i, v in pairs(guaiList) do
        if v:getBattleId() ~= -2 then
            table.insert(memberList, v)
        end
    end
    table.insert(memberList, WBattleGlobal:getCurrent():getMyHero())
    WBattleGlobal:getCurrent().m_nSingleActivityMemberIndex = 1
    
    -- math.randomseed(tostring(os.time()):reverse():sub(1, 6))

    -- local wind = math.random(-100,100)
    -- if math.abs(wind) > 98 then
    --     wind = wind / math.abs(wind) * 6
    -- elseif math.abs(wind) > 93 then
    --     wind = wind / math.abs(wind) * 5
    -- elseif math.abs(wind) > 90 then
    --     wind = wind / math.abs(wind) * 4
    -- elseif math.abs(wind) > 80 then
    --     wind = wind / math.abs(wind) * 3
    -- elseif math.abs(wind) > 60 then
    --     wind = wind / math.abs(wind) * 2
    -- elseif math.abs(wind) > 35 then
    --     wind = wind / math.abs(wind) * 1
    -- else
    --     wind = 0
    -- end

    local  wind = 0
    if WBattleGlobal:getCurrent():getMyHero().m_nRealLevel >= 10 or WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_TRAIN) then
        local windWeightList = {}
        local totalWeight = 0
        local startW,endW = 0,6
        if WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_TRAIN)then
            if type(self.m_tMapInfo.move) == "table" then
                startW = self.m_tMapInfo.move[1][1]
                endW = self.m_tMapInfo.move[1][2] - self.m_tMapInfo.move[1][1]
            end
        end
        for i = 0,endW - 1 do
            local weight = -500 * i + 3000 + WBattleGlobal:getCurrent():getMyHero().m_nRealLevel * 10
            if i < 3 and GlobalGame.g_nSingleCopyType == 3 then
                weight = 0
            end
            totalWeight = totalWeight + weight
            table.insert(windWeightList,weight)
        end
        local tmp = math.random(totalWeight)
        local tmpWeight = 0
        
        for i = 1,#windWeightList do
            tmpWeight = tmpWeight + windWeightList[i]
            if tmp > tmpWeight then
                wind = i
            else
                break
            end
            -- WZLog("checkWind:===",wind,i,tmp,tmpWeight)
        end

        wind = wind + startW
        WZLog("BattleMsgEndCurRound:processWithSingleMap zero0",startW,endW,wind)
    end

    if WBattleGlobal:getCurrent():isWindTeach() then
        if wind == 0 or wind == 1 then
            wind = 3
        elseif wind == 2 then
            wind = 4
        elseif wind == 6 then
            wind = 5
        end
    end
    if wind ~= 0 then
        wind = math.random() > 0.5 and wind or wind * -1
    end

    WBattleGlobal:getCurrent().m_tWind.x = wind
    if WBattleGlobal:getCurrent():getMyHero().m_nRealLevel < 10 then
        WBattleGlobal:getCurrent().m_tWind.x = 0
    end

    WBattleGlobal:getCurrent().m_nPlayerOrGuai = 1
    WBattleGlobal:getCurrent().m_nCurrentPlayerId = WBattleGlobal:getCurrent():getMyHero():getBattleId()
    WBattleGlobal:getCurrent().m_nIsCriticalHit = 0
    WBattleGlobal:getCurrent().m_tAttackRate = 100
    WBattleGlobal:getCurrent().m_nIsNewRound = 1
    
    local randList = {[1]=math.random(9999),[2]=math.random(9999),[3]=math.random(9999),[4]=math.random(9999),[5]=math.random(9999),[6]=math.random(9999),[7]=math.random(9999),[8]=math.random(9999),[9]=math.random(9999),[10]=math.random(9999)}
    local randIndexList = GetRandomNum(10, 10)
    WBattleGlobal:getCurrent().m_tBattleRand = {}
    for i = 1, 10 do
        table.insert(WBattleGlobal:getCurrent().m_tBattleRand, randList[randIndexList[i]])
 
    end

    WBattleGlobal:getCurrent().m_nLeftMedal = 0
    WBattleGlobal:getCurrent().m_nRightMedal = 0

    WBattleGlobal:getCurrent().m_tBattleRecord = {}
    --[[
    金币副本不创建怪物
    if WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_DAILY) then 
       if WBattleGlobal:getCurrent().m_tMakePairOk.section == DAILY_COPY_TYPE.COPPER then
            for id,guai in pairs(WBattleGlobal:getCurrent().m_tGuais) do
                if guai and guai:getIsExist() then
                    guai:destroy()
                end
            end
            WBattleGlobal:getCurrent().m_tGuais = {}
        end
    end
    ]]
   
    BattleCtbManager:initCTB()
    BattleCtbManager:sortCTB()

    local updateCTB_time = BattleCtbManager.m_nMinCTBTime
    local playerIds = BattleCtbManager.m_tCharaList
    local oldCTB = BattleCtbManager.m_tCharaCtbOldList
    local newCTB = BattleCtbManager.m_tCharaCtbNewList

    --根据ctb计算出手玩家
    local playerId = #BattleCtbManager.m_tCharaList
    local hero = nil
    local currentPlayerId = WBattleGlobal:getCurrent().m_nCurrentPlayerId
    while playerId > 0 do
        currentPlayerId = BattleCtbManager.m_tCharaList[playerId]
        hero = WBattleGlobal:getCurrent():getCharacterWithId(currentPlayerId)
        WZLog("BattleMsgEndCurRound:processWithSingleMap one", tostring(hero:isDead()))
        if hero:isDead() ~= true then
            break
        else
            playerId = playerId - 1
        end
    end
    WBattleGlobal:getCurrent().m_nCurrentPlayerId = currentPlayerId

    local tPlayerId = VectorToTable(playerIds)
    local tNowCtb = VectorToTable(oldCTB)
    local tNewCtb = VectorToTable(newCTB)
    BattleCtbManager:refreshLastCtb(tPlayerId,tNowCtb,tNewCtb,updateCTB_time)
    if WBattleGlobal:getCurrent():canRecordGame() then
        --录像记录
        local replayParam = {}
        replayParam.wind = WBattleGlobal:getCurrent().m_tWind.x
        replayParam.currentPlayerId = currentPlayerId
        replayParam.updateCTB_time = updateCTB_time
        replayParam.playerIds = playerIds
        replayParam.oldCTB = oldCTB
        replayParam.newCTB = newCTB
        replayParam.battleRand = WBattleGlobal:getCurrent().m_tBattleRand
        
        BattleMsgReplayGameRecord:setReadyBattle(replayParam)
    end
end


--@brief	结束loading
--@return	#1:true:完成,false:未完成
function SceneBattleLoading:_endLoading()
    --主机设置怪物可控制(防止怪物创建前处理 AIControlCommon 导致不可控制)
    if WBattleGlobal:getCurrent():canRecordGame() then
        --录像记录
        BattleMsgReplayGameRecord:setLoadingEnd()
    end
    if WBattleGlobal:getCurrent().m_nHostBattleId then
        for id, guai in pairs (WBattleGlobal:getCurrent():getGuaiList()) do
            guai.m_bCanControl = true
        end
    end
    
    WZLog("SceneBattleLoading:_endLoading", tostring(self.__bReceiveEndLoading))
    if WBattleGlobal:getCurrent():isSingleStage() then
        
        self:_endLoadingWithSingleMap()
		self.__bReceiveEndLoading = nil
		
		return true
    
    elseif WBattleGlobal:getCurrent():isAudience() then
        self.__bReceiveEndLoading = nil
        
        return true
    elseif self.__bReceiveEndLoading == nil then
		self.__bReceiveEndLoading = false

		ProtocolProcessorBattleInterface:send_BATTLE_FinishLoading(self.m_tMakePairOk.battleId, WBattleGlobal:getCurrent():getMyBattleId())
	end
	
	if self.__bReceiveEndLoading == true then
        --[[
		WBattleGlobal:getCurrent().m_tWind.x = self.m_tGotoToBattle.wind
		WBattleGlobal:getCurrent().m_nCurrentPlayerId = self.m_tGotoToBattle.currentPlayerId
		WBattleGlobal:getCurrent().m_nIsCriticalHit = 0
		WBattleGlobal:getCurrent().m_tAttackRate = self.m_tGotoToBattle.attackRate
		WBattleGlobal:getCurrent().m_nIsNewRound = 1
		WBattleGlobal:getCurrent().m_tBattleRand = self.m_tGotoToBattle.battleRand
        --]]
		WBattleGlobal:getCurrent().m_nLeftMedal = 0
		WBattleGlobal:getCurrent().m_nRightMedal = 0
		if WBattleGlobal:getCurrent():getBattleType() == BattleConstants.g_nBATTLE_TYPE_NORMAL then
			if GlobalGame.g_tBattleMode.BATTLE_MODE_FH == WBattleGlobal:getCurrent().m_tMakePairOk.battleMode then
				WBattleGlobal:getCurrent().m_nNeedMedal = 4
			else
				WBattleGlobal:getCurrent().m_nNeedMedal = 0
			end
		end

		self.__bReceiveEndLoading = nil

		return true
	else
		return false
	end
end

--@brief	更新函数
function SceneBattleLoading:_updateLoading(element,dt)

	if WBattleGlobal:getCurrent().m_tMakePairOk == nil then
		return
	end
    if WBattleGlobal:getCurrent():isReplayGame() then
        MsgManager:update(dt)
    end
    --发送心跳协议
    if self.m_fShakeHands == nil then
        self.m_fShakeHands = 0
    end
    if os.time() - self.m_fShakeHands > BattleConstants.g_fShakeHandsTime and NetManager.g_bConnectFailed ~= true then
        self.m_fShakeHands = os.time()
        ProtocolProcessorBattleInterface:send_SYSTEM_BattleShakeHands(self.m_tMakePairOk.battleId)
    end


	if #self.m_tStepFunction > 0 then
		local res = self.m_tStepFunction[1][1](self,self.m_tStepFunction[1][2])
		if res == true or res == nil then
			table.remove(self.m_tStepFunction,1)
		end
	else
		self.m_root:disableSchedule()
		-- local sceneBattle = SceneBattle:createElement()
		-- SceneBattle:setMapId(self.m_tMakePairOk.battleMap:match("%d+"))
		-- SceneBattle:init()
		-- replaceScene(sceneBattle)
	end
end

--@brief	更新函数
--@note		实际上的初始化函数
function SceneBattleLoading:_update()


	if WBattleGlobal:getCurrent().m_tMakePairOk == nil then

		return
	end

	--更新UI文本
	self:_updateUIText()

	--更新地图
	self:_updateMap()

	--更新Tips
	self:_updateTips()
end

--@brief	更新界面文本
--@note		主要用于语言适配
function SceneBattleLoading:_updateUIText()
--	WZUILabelTTF:luaTo(GetElement(self.m_root,"txtTipsTitle_SceneBattleLoading")):setText(LocalStrings.TIPS..":")
    WZUILabelTTF:luaTo(GetElement(self.m_root,"txtMapTitle_SceneBattleLoading")):setText(LocalStrings.LITLE_MAP..":")
end

--@brief	更新地图
function SceneBattleLoading:_updateMap()

	if WBattleGlobal:getCurrent().m_tMakePairOk == nil then
		return
	end

	WZUIImage:luaTo(GetElement(self.m_root,"imgMap_SceneBattleLoading")):setFile(self:_getMapBgByIcon(WBattleGlobal:getCurrent().m_tMakePairOk.battleMap))
	WZUIImage:luaTo(GetElement(self.m_root,"imgMapTitle_SceneBattleLoading")):setFile(self:_getMapTitleByIcon(WBattleGlobal:getCurrent().m_tMakePairOk.battleMap))
	WZUIContainer:luaTo(GetElement(self.m_root,"conMap_SceneBattleLoading")):setVisible(true)
end

--@brief	更新Tips
function SceneBattleLoading:_updateTips()
	if self.m_tTips ~= nil and #self.m_tTips.tips then
		if "en" == ProjConfig.LANGUAGE then 
			WZUILabelTTF:luaTo(GetElement(self.m_root,"txtTipsTitle_SceneBattleLoading")):setFontSize(24)
		end
		local tip
        local index = math.floor(math.random(#self.m_tTips.tips))
        index = (index <= 0 and 1) or (index >= #self.m_tTips.tips and #self.m_tTips.tips or index)
		if #self.m_tTips.tips == 0 then
			tip = self.m_tTips.tips[1]
		else
			tip = self.m_tTips.tips[index]
		end

        WZLog("SceneBattleLoading:_updateTips", #self.m_tTips.tips, index, tostring(tip))
		WZUILabelTTF:luaTo(GetElement(self.m_root,"txtTipsTitle_SceneBattleLoading")):setText(tip.text)
        WZUILabelTTF:luaTo(GetElement(self.m_root,"txtTipsTitle_SceneBattleLoading")):setVisible(false)
        local strFormat = [[<T S="20" C="255,121,31" P="0">%s</T><T S="20" C="255,236,196" P="0">%s</T>]]
        local strText = string.format(strFormat, LocalStrings.TIPS.."：", tip.text)
        GetElement(self.m_root, "txtTipsFreeBox_SceneBattleLoading", WZUIFreeTextBox):setShowText(strText)
	end
end

--@brief	根据icon返回地图背景图
--@param	mapIcon:地图icon
--@return	#1:地图背景图string
function SceneBattleLoading:_getMapBgByIcon(mapIcon)
	return RESOURCE_MAP_PATH..mapIcon:match("%w+").."_bg.png"
end

--@brief	根据icon返回地图标题图
--@param	mapIcon:地图icon
--@return	#1:地图标题图string
function SceneBattleLoading:_getMapTitleByIcon(mapIcon)

	return RESOURCE_MAP_TITLE_PATH..mapIcon:match("%w+")..".png"
end

--@brief	发送百分比
--@param	percent:百分比
function SceneBattleLoading:_sendPercent(percent)
	WZLog("SceneBattleLoading:_sendPercent",percent)
	for i,hero in pairs(WBattleGlobal:getCurrent():getHeroList()) do
		if hero:isCanControl() then
			
			ProtocolProcessorBattleInterface:send_BATTLE_LoadingPercent(WBattleGlobal:getCurrent().m_tMakePairOk.battleId,hero:getId(),percent)
		else
			
		end
	end

	self:_updatePercent(WBattleGlobal:getCurrent().m_tMakePairOk.battleId,WBattleGlobal:getCurrent():getMyBattleId(),WBattleGlobal:getCurrent():getMyBattleId(),percent)
end

--@brief	更新currentPlayerId的玩家的百分比
--@param	percent:百分比
function SceneBattleLoading:_updatePercent(battleId, currentPlayerId, percent)

	if self.m_root == nil then
		return
	end
	if WBattleGlobal:getCurrent().m_tMakePairOk.battleId == battleId then
		local hero = WBattleGlobal:getCurrent():getHeroWithId(currentPlayerId)
		if hero ~= nil then
			if hero:getCampPosition() < 0 then
				local conSeats = WZUIContainer:luaTo(GetElement(self.m_root,string.format("conLeftSeatFor%d_SceneBattleLoading",self.m_nLeftPeopleNum)))
				if WBattleGlobal:getCurrent():isEscapeBattle() then
                    conSeats = WZUIContainer:luaTo(GetElement(self.m_root,string.format("conLeftSeatFor%d_SceneBattleLoading",11)))
                end
                local conElement = GetElement(conSeats,string.format("conLeftPlayer%d_SceneBattleLoading",hero:getCampPosition() * -1))
				WZUIProgress:luaTo(GetElement(conElement,"progPlayerLoad_SceneBattleLoading")):setPercentage(percent)
			elseif hero:getCampPosition() > 0 then
				local conSeats = WZUIContainer:luaTo(GetElement(self.m_root,string.format("conRightSeatFor%d_SceneBattleLoading",self.m_nRightPeopleNum)))
				local conElement = GetElement(conSeats,string.format("conRightPlayer%d_SceneBattleLoading",hero:getCampPosition()))
				WZUIProgress:luaTo(GetElement(conElement,"progPlayerLoad_SceneBattleLoading")):setPercentage(percent)
			end
		end
	end
end
-------------------------------------私有方法模块End----------------------------------------

--@brief    越南语适配函数
--@note     越南语适配函数
function SceneBattleLoading:_adaptLanguage_vn()
	local txtTips = self.m_root:getChildElement("txtTipsTitle_SceneBattleLoading")
	if txtTips ~= nil then
		txtTips = WZUILabelTTF:luaTo(txtTips)
		txtTips:setDimensions(GlobalMethod:CCSize(350,0))
		txtTips:setFontSize(20)
	end
end
--------------------------------------葡语适配--------------------------------------------
function SceneBattleLoading:_adaptLanguage_pt()
	local txtTips = self.m_root:getChildElement("txtTipsTitle_SceneBattleLoading")
	if txtTips ~= nil then
		txtTips = WZUILabelTTF:luaTo(txtTips)
		txtTips:setDimensions(GlobalMethod:CCSize(350,0))
		txtTips:setFontSize(20)
	end
end

--@brief    添加信号
function SceneBattleLoading:_addNetSignal()
    -- body
    local conNetSignal = GetElement(self.m_root, "conNetSignal_SceneBattleLoading", WZUIContainer)
    CellNetSignal:showInterface(conNetSignal)
end

--@brief    公会战计算左边阵营玩家数量
function SceneBattleLoading:_getLeftPlayerNum(tPlayerCamp)
    -- body
    local num = 0

    for i = 1, #tPlayerCamp do
        if tPlayerCamp[i] == self:rtnMyCamp() then
            num = num + 1
        end
    end

    return num 
end

--@brief    公会战计算左边阵营玩家公会名字
function SceneBattleLoading:_getCommunityName(tPlayerCamp)
    -- body
    local numLeftIndex = 1
    local numRightIndex = 1
    

    for i = 1, #tPlayerCamp do
        if tPlayerCamp[i] == self:rtnMyCamp() then
            numLeftIndex = i
        else
            numRightIndex = i
        end
    end

    return numLeftIndex, numRightIndex
end


-------------------------------------------------------------------------------------------

-----------------------------------------语言适配Begin-----------------------------------
function SceneBattleLoading:_adaptLanguage_en()
    local imgMapTitle = GetElement(self.m_root,"imgMapTitle_SceneBattleLoading",WZUIImage)
    imgMapTitle:setScale(0.8)
end
-----------------------------------------语言适配End-------------------------------------