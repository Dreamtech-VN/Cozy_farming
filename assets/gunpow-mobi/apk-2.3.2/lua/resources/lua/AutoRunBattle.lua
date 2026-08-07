-- AutoRunBattle.lua
AutoRunBattle = {}
AutoRunBattleConst = {
    --======玩法类型预定义（挂机设置justice1不可修改）==========--
    SINGLE_WAR = 0, --单人副本
    TEAM_WAR = 1,   --组队副本
    ARENA_WAR_INTEGRAL = 2, --pvp积分
    ARENA_WAR_PRACTICE = 3, --pvp练习
    TOWER_WAR = 4, --爬塔
    DAILY_WAR = 5, --日常
    HERO_WAR  = 6, --英雄联赛
    HERO_WAR_BUILD = 7, --英雄联赛创建队伍
    ARENA_WAR_REBORN = 8, --pvp复活
    RANK_WAR = 9,   --排位赛
    JD_WAR = 10, --求生
    --======玩法类型预定义（挂机设置不可修改）==========--

    --挂机设置修改以下参数
    AUTO_RUN_BATTLE = false, --自动挂机
    HOST_STATE = true, --是否主机
    BattleType = 10, -- (参考玩法预定义)
    BattlePassWord = "-1", --竞技房间密码（-1 时可等到机器人加入）//注意组队副本一定要填非“-1”的密码
    TeamWarType = 0, --组队副本选项 0全部，1 2 3 4...代表对应的副本
    ArenaTeamNum = 3, -- 组队副本人数1-3/多人竞技队伍数量1-3

    LoginServerName = "正义服", 
    LoginIndex = 0, --已登录次数（默认0次）
    --战队队伍账号队列 （1-3 队伍1的1-3位队员） （4-6队伍2的1-3位队员）
    --创建队伍 只有1-3
    HeroUserLoginNum = 1, 
    Boss_Room_Enter = false
}

function AutoRunBattle:init()
    if not g_AutoRunBattle_nLoginIndex then
        g_AutoRunBattle_nLoginIndex = AutoRunBattleConst.LoginIndex
        g_AutoRunBattle_nHeroUserLoginNum = AutoRunBattleConst.HeroUserLoginNum
    end
    self.m_nBattleIndex = 0
    self.m_nBattleIdList = nil

    self.m_nBattleType = AutoRunBattleConst.BattleType
    self.m_bSendStart = false
    self.m_bSendEnter = false
    self.m_nBattleId = nil
    if g_AutoRunBattle_nLoginIndex then
        g_AutoRunBattle_nLoginIndex = g_AutoRunBattle_nLoginIndex + 1
    end
    self:initEvent()
    -- GlobalGame:getGameEventDispathcer():Dispatch("GameState_Change","state_scene")
end

function AutoRunBattle:initEvent()
    if GlobalGame.g_bIsAutoFightOpen then 
        GlobalGame:getGameEventDispathcer():Add("BattleRound_Change", self._battleRoundChange,self)
    else
        GlobalGame:getGameEventDispathcer():Add("GameState_Change", self._gameStateChange,self)
        GlobalGame:getGameEventDispathcer():Add("BattleRound_Change", self._battleRoundChange,self)
        GlobalGame:getGameEventDispathcer():Add("Enter_Login_Scene",self._enterLoginScene,self)
        GlobalGame:getGameEventDispathcer():Add("Get_Server_List",self._getServerList,self)
    end
end

function AutoRunBattle:getBattleIndex()
    if not self.m_nBattleId then
        if not self.m_nBattleIdList then
            self:setBattleList()
        end
        self.m_nBattleIndex = self.m_nBattleIndex + 1
        if self.m_nBattleIndex >= #self.m_nBattleIdList then
            self.m_nBattleIndex = 1
        end
        WZLog("AutoRunBattle:getBattleIndex",self.m_nBattleIdList[self.m_nBattleIndex])
        self.m_nBattleId =  self.m_nBattleIdList[self.m_nBattleIndex]
    end
    return self.m_nBattleId
end

function AutoRunBattle:setBattleList()
    self.m_nBattleIdList = {}

    if self.m_nBattleType == AutoRunBattleConst.TEAM_WAR then
        for i,v in pairs(GDatatab_team_map) do
            local matchMap = true
           
            if AutoRunBattleConst.TeamWarType ~= 0 then
                if v.map_num ~= 0 and math.floor((v.id % 1000)/100) == AutoRunBattleConst.TeamWarType then
                    matchMap = true
                else
                    matchMap = false
                end
            end
            if v.map_num == 0 or v.map_num == 5 then
                matchMap = false
            end
            if matchMap then
                table.insert(self.m_nBattleIdList,v.id)
            end
        end
    elseif self.m_nBattleType == AutoRunBattleConst.TOWER_WAR then
        for i,v in pairs(GDatatab_tower_map) do
            table.insert(self.m_nBattleIdList,v.id)
        end
    elseif self.m_nBattleType == AutoRunBattleConst.DAILY_WAR then
        for i,v in pairs(GDatatab_daily_map) do
            table.insert(self.m_nBattleIdList,v.id)
        end
    else
        for i,v in pairs(GDatatab_single_map) do
            if tonumber(v.id) >= 10101 then
                table.insert(self.m_nBattleIdList,v.id)
            end
        end
    end
    table.sort(self.m_nBattleIdList)
end

function AutoRunBattle:_battleRoundChange()
    WZLog("AutoRunBattle:_battleRoundChange")
    self.m_bSendStart = false
    self.m_bSendEnter = false
    self.m_bSendChangeArean = false
    AutoRunBattleConst.Boss_Room_Enter = true
    self.m_nBattleId = nil
    if WBattleGlobal:getCurrent():isMyTurn() then
        self:_heroAiStart()
    end
end

function AutoRunBattle:_gameStateChange(stateType,param1,param2,param3,param4)
    WZLog("AutoRunBattle:_gameStateChange",stateType,tostring(param1),tostring(param2),tostring(param3))
    self.m_bHeroInit = false
    if stateType == "state_scene" then
        if self.m_nBattleType == AutoRunBattleConst.TEAM_WAR then
            self:_enterBossScene()
        elseif self.m_nBattleType == AutoRunBattleConst.TOWER_WAR then
            self:_enterTowerScene()
        elseif self.m_nBattleType == AutoRunBattleConst.DAILY_WAR then
            self:_enterDailyScene()
        elseif self.m_nBattleType == AutoRunBattleConst.ARENA_WAR_PRACTICE 
            or self.m_nBattleType == AutoRunBattleConst.ARENA_WAR_INTEGRAL 
            or self.m_nBattleType == AutoRunBattleConst.ARENA_WAR_REBORN then
            self:_enterArenaScene()
        elseif self.m_nBattleType == AutoRunBattleConst.HERO_WAR then
            self:_enterHeroScene()
        elseif self.m_nBattleType == AutoRunBattleConst.HERO_WAR_BUILD then
            self:_enterHeroBuildScene()
        elseif self.m_nBattleType == AutoRunBattleConst.RANK_WAR then
            self:_enterRankScene()
        elseif self.m_nBattleType == AutoRunBattleConst.JD_WAR then
            self:_enterJDScene()
        else
            self:_enterSingleScene()
        end
    elseif stateType == "state_hall" then
        if self.m_nBattleType == AutoRunBattleConst.TEAM_WAR then
            self:_enterBossHall()
        elseif self.m_nBattleType == AutoRunBattleConst.TOWER_WAR then
            self:_enterTowerHall()
        elseif self.m_nBattleType == AutoRunBattleConst.DAILY_WAR then
            self:_enterDailyHall()
        elseif self.m_nBattleType == AutoRunBattleConst.ARENA_WAR_PRACTICE
            or self.m_nBattleType == AutoRunBattleConst.ARENA_WAR_INTEGRAL  
            or self.m_nBattleType == AutoRunBattleConst.ARENA_WAR_REBORN then
            if not self.m_bSendChangeArean then
                self:_enterArenaHall()
            end
        elseif self.m_nBattleType == AutoRunBattleConst.RANK_WAR then
            if not self.m_bSendChangeArean then
                self:_enterRankHall()
            end
        elseif self.m_nBattleType == AutoRunBattleConst.JD_WAR then
            if not self.m_bSendChangeArean then
                self:_enterJDHall()
            end
        else
            self:_enterSingleHall()
        end
    elseif stateType == "state_room_boss" then
        if not self.m_bSendStart then
            self:_enterBossRoom(param1,param2,param3,param4)
        end
    elseif stateType == "state_room_boss_update" then
        if not self.m_bSendEnter then
            self:_bossRoomUpdate(param1,param2)
        end
    elseif stateType == "state_room_arean_update" then
        if not self.m_bSendEnter then
            self:_areanRoomUpdate(param1)
        end
    elseif stateType == "state_room_boss_update_2" then
        if not self.m_bSendEnter then
            if self.m_bBossRoomRush then
                WZLog("AutoRunBattle:rushRoom")
                self.m_bBossRoomRush = false
                WndMultiCopy:autoBattleChangeRoom()
            else
                self.m_bBossRoomRush = true
            end
        end
    elseif stateType == "state_room_arean" then
        if not self.m_bSendStart then
            self:_enterArenaRoom(param1,param2,param3,param4)
        end
    elseif stateType == "state_hero_ready" then
        self:_updateHeroHall()
    elseif stateType == "state_hero_build_team" then
        self:_updateHeroBuildTeam()
    elseif stateType == "state_hero_team_update" then
        self:_updateHeroTeamUpdate(param1,param2,param3)
    end
end

function AutoRunBattle:_enterTowerScene()
    ProtocolProcessorSingleMap:regAll()
    -- 处理战斗时默认皮肤大招id获取不到的问题,做一层保险
    if GlobalGame.g_saveBigSkillType == 2 and (CacheCenter.m_nDefaultShapeBigSkill == nil or CacheCenter.m_nDefaultShapeBigSkill <= 0) then
        ProtocolProcessorWndSkillProp:send_PLAYER_GetShapeSkillList(2)
    end
    ProtocolProcessorSingleMap:send_SINGLEMAP_StartChallenge(self:getBattleIndex(), COPYTYPE_TOWER)
end

function AutoRunBattle:_enterTowerHall()
    -- 处理战斗时默认皮肤大招id获取不到的问题,做一层保险
    if GlobalGame.g_saveBigSkillType == 2 and (CacheCenter.m_nDefaultShapeBigSkill == nil or CacheCenter.m_nDefaultShapeBigSkill <= 0) then
        ProtocolProcessorWndSkillProp:send_PLAYER_GetShapeSkillList(2)
    end
    ProtocolProcessorSingleMap:send_SINGLEMAP_StartChallenge(self:getBattleIndex(), COPYTYPE_TOWER)
end

function AutoRunBattle:_enterDailyScene()
    ProtocolProcessorSingleMap:regAll()
    -- 处理战斗时默认皮肤大招id获取不到的问题,做一层保险
    if GlobalGame.g_saveBigSkillType == 2 and (CacheCenter.m_nDefaultShapeBigSkill == nil or CacheCenter.m_nDefaultShapeBigSkill <= 0) then
        ProtocolProcessorWndSkillProp:send_PLAYER_GetShapeSkillList(2)
    end
    ProtocolProcessorSingleMap:send_SINGLEMAP_StartChallenge(self:getBattleIndex(), COPYTYPE_DAILY)
end

function AutoRunBattle:_enterDailyHall()
    -- 处理战斗时默认皮肤大招id获取不到的问题,做一层保险
    if GlobalGame.g_saveBigSkillType == 2 and (CacheCenter.m_nDefaultShapeBigSkill == nil or CacheCenter.m_nDefaultShapeBigSkill <= 0) then
        ProtocolProcessorWndSkillProp:send_PLAYER_GetShapeSkillList(2)
    end
    ProtocolProcessorSingleMap:send_SINGLEMAP_StartChallenge(self:getBattleIndex(), COPYTYPE_DAILY)
end

function AutoRunBattle:_enterSingleScene()
    WZLog("AutoRunBattle:_enterSingleScene")
    ProtocolProcessorSingleMap:regAll()
    -- 处理战斗时默认皮肤大招id获取不到的问题,做一层保险
    if GlobalGame.g_saveBigSkillType == 2 and (CacheCenter.m_nDefaultShapeBigSkill == nil or CacheCenter.m_nDefaultShapeBigSkill <= 0) then
        ProtocolProcessorWndSkillProp:send_PLAYER_GetShapeSkillList(2)
    end
    ProtocolProcessorSingleMap:send_SINGLEMAP_StartChallenge(self:getBattleIndex(), COPYTYPE_SINGLE)
end

function AutoRunBattle:_enterSingleHall()
    WZLog("AutoRunBattle:_enterSingleHall")
    -- 处理战斗时默认皮肤大招id获取不到的问题,做一层保险
    if GlobalGame.g_saveBigSkillType == 2 and (CacheCenter.m_nDefaultShapeBigSkill == nil or CacheCenter.m_nDefaultShapeBigSkill <= 0) then
        ProtocolProcessorWndSkillProp:send_PLAYER_GetShapeSkillList(2)
    end
    ProtocolProcessorSingleMap:send_SINGLEMAP_StartChallenge(self:getBattleIndex(), COPYTYPE_SINGLE)
end

--进入boss主城
function AutoRunBattle:_enterBossScene()
    WZLog("AutoRunBattle:_enterBossScene")
    if AutoRunBattleConst.HOST_STATE then
         ProtocolProcessorBossMap:regAll()
        ProtocolProcessorBossMap:send_BOSSMAPROOM_CreateRoom(self:getBattleIndex(),AutoRunBattleConst.BattlePassWord,1)
    else
        SceneCopy:showScene(2)
    end
end
--进入boss大厅(主机创建房间)
function AutoRunBattle:_enterBossHall()
    WZLog("AutoRunBattle:_enterBossHall")
    if AutoRunBattleConst.HOST_STATE then
        ProtocolProcessorBossMap:send_BOSSMAPROOM_CreateRoom(self:getBattleIndex(),AutoRunBattleConst.BattlePassWord,1)
    end
end

--boss大厅等待（客机等待刷新加入）
function AutoRunBattle:_bossRoomUpdate(roomId,mapId)
    if not AutoRunBattleConst.HOST_STATE then
        WZLog("AutoRunBattle:_bossRoomUpdate",roomId,mapId)
        self.m_bSendEnter = true
        ProtocolProcessorBossMap:send_BOSSMAPROOM_SelectRoom(roomId,AutoRunBattleConst.BattlePassWord,mapId,GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_ZF)
    end
end
--进入boss房间
function AutoRunBattle:_enterBossRoom(roomId,playerCount,sitNum,allReady)
    WZLog("AutoRunBattle:_enterBossRoom",roomId,playerCount)
    if AutoRunBattleConst.HOST_STATE then
        if playerCount == AutoRunBattleConst.ArenaTeamNum and allReady then
            self.m_bSendStart = true
            ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_MakePair(roomId)
        end
    else
        self.m_bSendStart = true
        ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_GameReady(roomId, sitNum, true )
    end
end

--进入pvp主城
--@battleModel, battleChanel
function AutoRunBattle:_enterArenaScene()
    WZLog("AutoRunBattle:_enterArenaScene")
    if AutoRunBattleConst.HOST_STATE then
        local battleModel,battleChannel = self:getArenaPairInfo()
        ProtocolProcessorSceneHall:regAll()
        ProtocolProcessorSceneHall:send_ROOM_CreateRoom("Warning Front Hight Power", 1,AutoRunBattleConst.ArenaTeamNum,AutoRunBattleConst.BattlePassWord,battleModel,battleChannel,0)
    else
        replaceScene(SceneHall:createElement())
    end
end
--进入pvp大厅
function AutoRunBattle:_enterArenaHall()
    WZLog("AutoRunBattle:_enterArenaHall")
    if AutoRunBattleConst.HOST_STATE then
        self.m_bSendChangeArean = true
        local battleModel,battleChannel = self:getArenaPairInfo()

        ProtocolProcessorSceneHall:send_ROOM_CreateRoom("Warning Front Hight Power", 1,AutoRunBattleConst.ArenaTeamNum,AutoRunBattleConst.BattlePassWord,battleModel,battleChannel,0)
    else
        self.m_bSendChangeArean = true
        -- ProtocolProcessorSceneHall:send_ROOM_GetRoomList(2,0)
        --练习赛换房间频道
        if self.m_nBattleType == AutoRunBattleConst.ARENA_WAR_PRACTICE then
            SceneHall:onSelMatch(nil,nil,nil,2)
        end
    end
end
--@ 积分1, 1; 练习组队 2,2 ; 练习混战3,2
function  AutoRunBattle:getArenaPairInfo( ... )
    local battleModel = 2
    local battleChannel = 2
    if self.m_nBattleType == AutoRunBattleConst.ARENA_WAR_INTEGRAL then
        battleModel = 1
        battleChannel = 1
    end
    if self.m_nBattleType == AutoRunBattleConst.ARENA_WAR_REBORN then
        battleModel = 1
        battleChannel = 30
    end
    return battleModel,battleChannel
end
--pvp大厅等待（客机等待刷新加入）
function AutoRunBattle:_areanRoomUpdate(roomId)
    if not AutoRunBattleConst.HOST_STATE then
        self.m_bSendEnter = true
        ProtocolProcessorSceneHall:send_ROOM_SelectRoom(roomId,1,0,AutoRunBattleConst.BattlePassWord)
    end
end
--进入pvp房间
function AutoRunBattle:_enterArenaRoom(roomId,playerCount,sitNum,allReady)
    WZLog("AutoRunBattle:_enterArenaRoom",roomId)
    if AutoRunBattleConst.HOST_STATE then
        --积分赛
        if self.m_nBattleType == AutoRunBattleConst.ARENA_WAR_INTEGRAL or self.m_nBattleType == AutoRunBattleConst.ARENA_WAR_REBORN then
            if playerCount == AutoRunBattleConst.ArenaTeamNum and allReady then
                self.m_bSendStart = true
                ProtocolProcessorSceneRoom:send_ROOM_MakePair(roomId,SceneRoom.m_tData.roomChannel,SceneRoom.m_tData.sechedule,SceneRoom.m_tData.battleMode,SceneRoom.m_tData.playerNumMode)
                SceneRoom:receiveMakePairring(roomId)
            end
        end
        --练习赛
        if self.m_nBattleType == AutoRunBattleConst.ARENA_WAR_PRACTICE and playerCount == AutoRunBattleConst.ArenaTeamNum * 2 and allReady then
            self.m_bSendStart = true
            ProtocolProcessorSceneRoom:send_ROOM_MakePair(roomId)
        end

        --排位赛
        if self.m_nBattleType == AutoRunBattleConst.RANK_WAR and playerCount == 3 and allReady then
            self.m_bSendStart = true
            ProtocolProcessorSceneRoom:send_ROOM_MakePair(roomId,SceneRoom.m_tData.roomChannel,SceneRoom.m_tData.sechedule,SceneRoom.m_tData.battleMode,SceneRoom.m_tData.playerNumMode)
            SceneRoom:receiveMakePairring(roomId)
        end
    else
        self.m_bSendStart = true
        ProtocolProcessorSceneRoom:send_ROOM_GameReady(roomId, sitNum, true)
    end
end

--@brief 排位赛
function AutoRunBattle:_enterRankScene()
    ScenePvpRank:showInterface()
end

--@brief 进入排位赛大厅
function AutoRunBattle:_enterRankHall()
    WZLog("AutoRunBattle:_enterRankHall")
    if AutoRunBattleConst.HOST_STATE then
        self.m_bSendChangeArean = true
        ProtocolProcessorSceneHall:send_ROOM_CreateRoom("Warning Front Hight Power", 1,3,"-1",ScenePvpRank.matchMode,ScenePvpRank.channel,0)
    else
        self.m_bSendChangeArean = true
    end
end

--@brief 绝地求生 
function AutoRunBattle:_enterJDScene()
    SceneAthMelee:showInterface(2)
end

function AutoRunBattle:_enterJDHall()
    WZLog("AutoRunBattle:_enterJDScene")
    if AutoRunBattleConst.HOST_STATE then
        self.m_bSendChangeArean = true
        ProtocolProcessorSceneHall:send_ROOM_QuickGame(11,3,0)
    else
        self.m_bSendChangeArean = true
    end
end

--=================================================================================================
--
--===========================英雄联赛start=========================================================
--
--=================================================================================================
function AutoRunBattle:_enterLoginScene()
    WZLog("AutoRunBattle:_enterLoginScene")
    if self.m_nBattleType == AutoRunBattleConst.HERO_WAR or self.m_nBattleType == AutoRunBattleConst.HERO_WAR_BUILD then
        local name,password = self:getUserData()
        g_tAccountData.accountName = name
        g_tAccountData.passWord = password
        -- local data = WZDataFile:getInstance():getUserData()
        -- if data then
        --     data:setStringValue("AccountData", "account", name)
        --     data:setStringValue("AccountData", "password", password)
        --     data:flush()
        -- end
        local ipdAddr = ProjConfig:getIpdAddr()
        local channelId = ProjConfig:getChannelId()
        local uId = WGameCmUtil:GetUDID()
        local version = WZDeviceInfo:appVersion()
        local isChannel = 0
        local sign = WZDeviceInfo:md5Generate(uId..name..password..version..channelId..isChannel.."gz!y^d&zh*wyd")
        local data = { id = uId, username = name, password = password, channel = channelId, version = version, isChannel = isChannel,sign = sign }
        local vBytes = WGameCmUtil:EnCrypt(json.encode(data), ENCRYPT_KEY)
        local sData = WGameCmUtil:transformBytesToString(vBytes)
        local url = "http://"..ipdAddr.."/load?data="..sData
        WZLog("IpdHttpServerListUrl = ",url)
        IPDhttpServer:getHttpServerData(url)
    end
end

function AutoRunBattle:getUserData()
    WZLog("AutoRunBattle:getUserData")
    local xmlDoc = WZDataFile:getInstance():createXmlDocument("userList.xml")
    if not xmlDoc then
        return "justice1","123456"
    end
    local name,password,elementMax = self:_getUserDataXmlDoc(xmlDoc)
    if name then
        return name,password
    end
    WZLog("AutoRunBattle:getUserData:resetIndex")
   
    if self.m_nBattleType == AutoRunBattleConst.HERO_WAR_BUILD then
        g_AutoRunBattle_nHeroUserLoginNum = g_AutoRunBattle_nHeroUserLoginNum + 3
        if g_AutoRunBattle_nHeroUserLoginNum > 6 then
            MsgBoxManager:showConfirmBox("账号创建队伍结束", self, function() end, MSGBOXLEVEL_NORMAL, nil,true)
            return
        end
    end
    if self.m_nBattleType == AutoRunBattleConst.HERO_WAR_BUILD then
        g_AutoRunBattle_nLoginIndex = AutoRunBattleConst.LoginIndex + 1 - math.floor(elementMax/3)
        if g_AutoRunBattle_nLoginIndex < 1 then
            g_AutoRunBattle_nLoginIndex = 1
        end
    else
        g_AutoRunBattle_nLoginIndex = 1
    end
    local name,password = self:_getUserDataXmlDoc(xmlDoc)
    if not name then
        MsgBoxManager:showConfirmBox("账号创建队伍结束", self, function() end, MSGBOXLEVEL_NORMAL, nil,true)
    end
    return name,password
end

function AutoRunBattle:_getUserDataXmlDoc(xmlDoc)
    local rootElement = xmlDoc:getRootElement()
    local xmlName = "info"
    if g_AutoRunBattle_nHeroUserLoginNum > 3 then
        xmlName = "infoSec"
    end
    local element = rootElement:findChildElement(xmlName)
    local index = 0
    local realIndex = (g_AutoRunBattle_nLoginIndex - 1)*3 + g_AutoRunBattle_nHeroUserLoginNum
    if g_AutoRunBattle_nHeroUserLoginNum > 3 then
        realIndex = realIndex - 3
    end
    WZLog("AutoRunBattle:realIndex",xmlName,realIndex)
    while element do
        index = index + 1
        if index == realIndex then
            local name = element:attributeString("name")
            local password = element:attributeString("password")
            self.m_sTeamName = element:attributeString("teamName")
            WZLog("AutoRunBattle:_getUserDataByIndex",index,name,password)
            return name,password,index
        end
        element = element:nextSiblingElement(xmlName)
    end
    return nil,nil,index
end

function AutoRunBattle:_getServerList()
    if self.m_nBattleType == AutoRunBattleConst.HERO_WAR or self.m_nBattleType == AutoRunBattleConst.HERO_WAR_BUILD then
        local serverId = nil
        for i = 1 , #IPDhttpServer.IpdServerList do
            WZLog("IPDhttpServer.IpdServerList",IPDhttpServer.IpdServerList[i].name)
            if IPDhttpServer.IpdServerList[i].name == AutoRunBattleConst.LoginServerName then
                serverId = IPDhttpServer.IpdServerList[i].serverId
                break
            end
        end
        if serverId then
            IPDhttpServer:setCurServer(serverId)
        end
        SceneLoginMgr:showScene(3)
        self.m_bBattleDone = false
    end
end

function AutoRunBattle:_enterHeroScene()
    if self.m_bBattleDone then
        self:_nextLogin()
        return
    end
    self.m_bBattleDone = true
    ProtocolProcessorWndLeague:send_HERO_ReadyFight()
    if not AutoRunBattleConst.HOST_STATE then
        ProtocolProcessorWndLeague:send_HERO_Ready( )
    end
end


--@brief 英雄联赛刷新
function AutoRunBattle:_updateHeroHall()
    if AutoRunBattleConst.HOST_STATE then
        if not self.m_bHeroMakePair then
            self.m_bHeroMakePair = true
            ProtocolProcessorWndLeague:send_HERO_MakePairHero()
        else
            self:_nextLogin()
        end
    end
end

function AutoRunBattle:_nextLogin()
    local frame = WZUISystem:getInstance():createElement("splash")
    replaceScene(frame)
end



--@brief 创建队伍场景
function AutoRunBattle:_enterHeroBuildScene()
    if not WndLeagueTeamList.m_tDataList then
        return
    end

    if CacheCenter:getPlayerInfo().teamId == 0 then
        if AutoRunBattleConst.HOST_STATE then
            --主机创建战队
            ProtocolProcessorWndLeague:send_HERO_CreateTeam(self.m_sTeamName, "declaration", "")
        else
            --客机申请战队
            for i,v in pairs(WndLeagueTeamList.m_tDataList) do
                if self.m_sTeamName == v.name then
                   ProtocolProcessorWndLeague:send_HERO_ApplyHeroTeam(v.id)
                end
            end
        end
    end
end

--@brief 队伍审核信息刷新
function AutoRunBattle:_updateHeroBuildTeam()
    if AutoRunBattleConst.HOST_STATE then
        for i,v in pairs(WndLeagueRecruit.m_tDataList) do
            local id = WZLuaVector_int_:create()
            id:push(v.playerId)
            ProtocolProcessorWndLeague:send_HERO_Reviewed(id, 1 )
        end
    end
end

--@brief 个人队伍信息刷新
function AutoRunBattle:_updateHeroTeamUpdate(teamId,teamName,teamNum)
    WZLog("AutoRunBattle:_udpateHeroTeamUpdate",tostring(teamId),tostring(teamName),tostring(teamNum))
    if CacheCenter:getPlayerInfo().teamId == teamId then
        if teamName == self.m_sTeamName then
            if teamNum >=3 then
                self:_nextLogin()
            end
        else
            ProtocolProcessorWndLeague:send_HERO_OutTeam()
        end
    end
end

--=================================================================================================
--
--===========================英雄联赛end=========================================================
--
--=================================================================================================


function AutoRunBattle:_heroInit()
    self.m_tHero = WBattleGlobal:getCurrent():getMyHero()
    self.m_tHero.m_tItems = {}
    self.m_tHero.m_tSkills = {}
    
    for i,v in pairs(WBattleGlobal:getCurrent().m_tMyProp_Beginning.id) do
        if v > 0 and WndBattleHud.m_tUseItem[i] > 0 then
            table.insert(self.m_tHero.m_tItems,v)
        end
    end

    WZLog("AutoRunBattle:_heroInit", Serialize(WBattleGlobal:getCurrent().m_tMyProp_Beginning.id), Serialize(WndBattleHud.m_tUseItem), Serialize(self.m_tHero.m_tItems))
    for i,v in pairs(WBattleGlobal:getCurrent().m_tMySkill_Beginning.id) do
        if v > 0 then
            table.insert(self.m_tHero.m_tSkills,v)
        end
    end
end

function AutoRunBattle:_heroAiStart()
    WZLog("AutoRunBattle:_heroAiStart")
    if not self.m_bHeroInit then
        self:_heroInit()
        self.m_bHeroInit = true
    end
    if self.m_tHero:isDead() or self.m_tHero:getHp() <= 0 then
        return
    end

    WBattleGlobal:getCurrent().m_bIsPlayerOperateAlready = true
    self.m_bUsingSkill = false
    self.m_tTarget = nil

    self.m_tActList = {}

    self:_choseTarget()
    if self.m_tTarget ~= nil then
        table.insert(self.m_tActList,self._move)
        if WBattleGlobal:getCurrent().m_nAutoFightActIndex == 0 then 
            if not self.m_tHero:isInBuffState(EffectTypeConfig.LIMIT_USE_SKILL) then
                table.insert(self.m_tActList,self._useItem)
                table.insert(self.m_tActList,self._useSkill)
            end
            table.insert(self.m_tActList,self._checkFlyOrShoot)
        elseif WBattleGlobal:getCurrent().m_nAutoFightActIndex == 1 then 
            table.insert(self.m_tActList,self._shoot)
        elseif WBattleGlobal:getCurrent().m_nAutoFightActIndex == 2 then 
            table.insert(self.m_tActList,self._fly)
        end
        self:_doNextAct()
    end
end

function AutoRunBattle:_choseTarget()
    WZLog("AutoRunBattle:_choseTarget")
    local list = WBattleGlobal:getCurrent():getCharacterList(true)
    local arr = {}
    for id, hero in pairs(list) do
        if hero:isDead() ~= true and not WBattleGlobal:getCurrent():isMyTeam(hero:getBattleId()) then
            table.insert(arr, hero)
        end
    end
    local len = #arr
    if len == 1 then
        self.m_tTarget = arr[1]
    else
        index = math.random(len + 1)
        if arr[index] then
            self.m_tTarget = arr[index]
        else
            self.m_tTarget = arr[len]
        end
    end
   
    self:_doNextAct()
end

function AutoRunBattle:_doNextAct()
    WZLog("AutoRunBattle:_doNextAct",#self.m_tActList)
    if #self.m_tActList > 0 then
        local func = self.m_tActList[1]
        table.remove(self.m_tActList,1)
        func(self)
    end
end

function AutoRunBattle:_move()
    WZLog("AutoRunBattle:_move")
    self:_doNextAct()
end

function AutoRunBattle:_getRandomIdByList(list)
    local random = math.random(#list + 1)
    local resultId = list[#list]
    if random < #list then
        resultId = list[random]
    end
    WZLog("AutoRunBattle:_getRandomIdByList",resultId)
    return resultId
end

function AutoRunBattle:_useItem()
    WZLog("AutoRunBattle:_useItem",Serialize(self.m_tHero.m_tItems))
    if not self.m_tHero.m_tItems or self.m_tHero:isInBuffState(EffectTypeConfig.LIMIT_USE_ITEM) and math.random() < 0.4 then
        self:_doNextAct()
        return
    end
    --获得道具列表
    local list = {}
    for i,v in pairs(self.m_tHero.m_tItems) do
        local inCd = false
        for ti,tv in pairs(self.m_tHero.m_tItemCdList) do
            if v == ti then
                inCd = true
                break
            end
        end
        WZLog("AutoRunBattle:_useItem-2",v,tv,tostring(inCd))

        if not inCd and v ~= BattleHeroUse.ITEM_FLY then
            local tItemData = GDatatab_skill["id_" .. v]
            if tItemData then
                local tCondition = SplitStringWithSeparator(tItemData.use_condition,"&")
                for i=1,#tCondition do
                    local nStart1, nEnd1 = string.find(tCondition[i],"^syxlxy%%=") --回光返照条件
                    if nStart1 then
                        local hp = self.m_tHero:getHp()
                        local hpNow = hp/self.m_tHero:getMaxHp()*100
                        local use_condition_num = string.match(tCondition[i], "%d+")
                        if hpNow < tonumber(use_condition_num) then
                            table.insert(list,v)
                        end
                    else
                        table.insert(list,v)
                    end
                end
            end
        end
    end

    if #list > 0 then
        local itemId = self:_getRandomIdByList(list)
        local skillData = GDatatab_skill["id_" .. itemId]
        if skillData and self.m_tHero.m_nUsePoint + skillData.consume <= 10000 then 
            self.m_tHero.m_nUsePoint = self.m_tHero.m_nUsePoint + skillData.consume
            BattleHeroUse:heroUse(self.m_tHero:getBattleId(),BattleHeroUse.USE_SKILL_OR_ITEM,itemId)
            WndBattleHud:dealwithItemAfterUse(itemId)
            for i = #self.m_tHero.m_tItems,1,-1 do
                if itemId == self.m_tHero.m_tItems[i] then
                    table.remove(self.m_tHero.m_tItems, i)
                    break
                end
            end
        end
    end

    self:_doNextAct()
end

function AutoRunBattle:_useSkill()
    WZLog("AutoRunBattle:_useSkill",Serialize(self.m_tHero.m_tSkills))
    
    if not self.m_tHero.m_tSkills or self.m_tHero:isInBuffState(EffectTypeConfig.LIMIT_USE_SKILL) then
        self:_doNextAct()
        return
    end
    --使用大招
    if self.m_tHero.m_nUsePoint <= 2000 then 
        local usingBigSkill = BattleHeroUse:heroUse(self.m_tHero:getBattleId(), BattleHeroUse.USE_BIGSKILL)
        if usingBigSkill then
            self.m_bUsingSkill = true
            self:_doNextAct()
            return
        end
    end 

    local useSkill = math.random() < 0.9
    if not useSkill then
        self:_doNextAct()
        return
    end
    --获得可用技能列表
    local list = {}
    for i,v in pairs(self.m_tHero.m_tSkills) do
        local inCd = false
        for ti,tv in pairs(self.m_tHero.m_tSkillCdList) do
            if v == ti then
                inCd = true
                break
            end
        end
        WZLog("AutoRunBattle:_useSkill-2",v,tv,tostring(inCd))
        if not inCd and v ~= BattleHeroUse.FLY_SKILL_ID then
            table.insert(list,v)
        end
    end

    if #list > 0 then
        local skillId = self:_getRandomIdByList(list)
        if skillId == WBattleGlobal.getCurrent().m_nAwakeSkillId then
            local MAX_CTB = BattleCtbManager.MAX_CTB
            local nMyCtb = self.m_tHero:getNowCtb(self.m_tHero:getBattleId())
            WZLog("WndBattleHud:onAwakeSkillClick", nMyCtb)
            if nMyCtb >= MAX_CTB then 
                self:_doNextAct()
                return 
            else
                BattleHeroUse:heroUse(self.m_tHero:getBattleId(), BattleHeroUse.USE_CTB, skillId)
            end
        else
            local skillData = GDatatab_skill["id_" .. skillId]
            if skillData and self.m_tHero.m_nUsePoint + skillData.consume <= 10000 then 
                self.m_tHero.m_nUsePoint = self.m_tHero.m_nUsePoint + skillData.consume
                BattleHeroUse:heroUse(self.m_tHero:getBattleId(), BattleHeroUse.USE_SKILL_OR_ITEM, skillId)
            end
        end
        self.m_bUsingSkill = true
    end
    
    self:_doNextAct()
    -- body
end

function AutoRunBattle:_checkFlyOrShoot()
    if self.m_bUsingSkill == true then
        table.insert(self.m_tActList,self._shoot)
        self:_doNextAct()
        return
    end

    local checkFly = false
    local random = math.random()
    if random < 0.4 and not self.m_tHero:isInBuffState(EffectTypeConfig.LIMIT_FLY) and not self.m_tHero:isInBuffState(EffectTypeConfig.LIMIT_USE_SKILL) then
        checkFly = true
    end

    if self.m_tHero.m_nUsePoint + 2000 > 10000 then 
        return 
    end
    if checkFly and BattleHeroUse:heroUse(self.m_tHero:getBattleId(),BattleHeroUse.USE_FLY) then
        self.m_tHero.m_nUsePoint = self.m_tHero.m_nUsePoint + 2000
        table.insert(self.m_tActList,self._fly)
        self:_doNextAct()
        return
    end
    local hasItem = false
    --飞行道具
    for i = #self.m_tHero.m_tItems,1,-1 do
        if BattleHeroUse.ITEM_FLY == self.m_tHero.m_tItems[i] then
            hasItem = true
            break
        end
    end
    if self.m_tHero.m_nUsePoint + 2000 > 10000 then 
        return 
    end
    if checkFly and hasItem and BattleHeroUse:heroUse(self.m_tHero:getBattleId(),BattleHeroUse.USE_ITEM,BattleHeroUse.ITEM_FLY) then
        --移除飞行道具
        self.m_tHero.m_nUsePoint = self.m_tHero.m_nUsePoint + 2000
        for i = #self.m_tHero.m_tItems,1,-1 do
            if BattleHeroUse.ITEM_FLY == self.m_tHero.m_tItems[i] then
                table.remove(self.m_tHero.m_tItems, i)
                break
            end
        end
        table.insert(self.m_tActList,self._fly)
        self:_doNextAct()
        return
    end

    
    table.insert(self.m_tActList,self._shoot)
    self:_doNextAct()
end

function AutoRunBattle:_fly()
    WZLog("AutoRunBattle:_fly", type(self.m_tHero), type(self.m_tTarget))
    local startPos
    local offset
    local hero = WBattleGlobal:getCurrent():getMyHero()
    local beginPos = hero:getCenterPos()
    local endPos = {x = self.m_tTarget:getCenterPos().x,y = self.m_tTarget:getCenterPos().y + 200}
    local isAtkSucceed,speed = BattleAiCheck:adjustAngle(beginPos,endPos)

    local face
    if endPos.x <= beginPos.x then
        face = 1
    else
        face = 0
    end

    local msg = MsgManager:createMsg(BattleMsgPlayerFly)
    msg.m_nBattleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
    msg.m_nPlayerId = WBattleGlobal:getCurrent():getMyBattleId()
    msg.m_nCurrentPlayerId = WBattleGlobal:getCurrent():getMyBattleId()
    msg.m_nSpeedx = speed.x
    msg.m_nSpeedy = speed.y
    msg.m_nIsEquip = WBattleGlobal:getCurrent():getMyHero():isUseItemFly() and 1 or 0

    local startPos
    local offset
    local hero = WBattleGlobal:getCurrent():getMyHero()

    if speed.x < 0 then
        msg.m_nLeftRight = 1
        startPos = BattleCommon:getShootPos(true,hero,offset)
    else
        msg.m_nLeftRight = 0
        startPos = BattleCommon:getShootPos(false,hero,offset)
    end
    msg.m_nStartX = startPos.x
    msg.m_nStartY = startPos.y

    MsgManager:pushBlockMsg(msg)

    self:_doNextAct()
end

function AutoRunBattle:_shoot()
    WZLog("AutoRunBattle:_shoot", type(self.m_tHero), type(self.m_tTarget))
    local startPos
    local offset
    local hero = WBattleGlobal:getCurrent():getMyHero()
    local beginPos = hero:getCenterPos()
    local endPos = self.m_tTarget:getCenterPos()
    local isAtkSucceed,speed = BattleAiCheck:adjustAngle(beginPos,endPos)
    
    local face
    if endPos.x <= beginPos.x then
        face = 1
    else
        face = 0
    end

    local msg = MsgManager:createMsg(BattleMsgPlayerShoot)
    msg.m_nBattleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
    msg.m_nPlayerId = WBattleGlobal:getCurrent():getMyBattleId()
    msg.m_nCurrentPlayerId = WBattleGlobal:getCurrent():getMyBattleId()
    msg.m_nSpeedx = speed.x
    msg.m_nSpeedy = speed.y
    msg.m_nLeftRight = face
    local startPos
    local offset
    local hero = WBattleGlobal:getCurrent():getMyHero()

    if hero:getUseBigSkill() then
        offset = {x=90,y=70}
    end
    if speed.x < 0 then
        msg.m_nLeftRight = 1
        startPos = BattleCommon:getShootPos(true,hero,offset)
    else
        msg.m_nLeftRight = 0
        startPos = BattleCommon:getShootPos(false,hero,offset)
    end
    msg.m_nStartX = startPos.x
    msg.m_nStartY = startPos.y
    MsgManager:pushBlockMsg(msg)

    self:_doNextAct()
end


--===============================================================================================================

-- AutoRunBattleGM_FATHER = {
--     m_bIsInList = nil,

--     m_tList = {
--     "漩涡秘境198644",
--     },
-- }
-- function AutoRunBattleGM_FATHER:isInList()
--     do return true end
--     if AutoRunBattleGM_FATHER.m_bIsInList ~= nil then
--         return AutoRunBattleGM_FATHER.m_bIsInList
--     end
--     AutoRunBattleGM_FATHER.m_bIsInList = false
--     for i,v in pairs(AutoRunBattleGM_FATHER.m_tList) do
--         if v == CacheCenter:getPlayerInfo().serverName .. tostring(CacheCenter:getPlayerInfo().id) then
--              AutoRunBattleGM_FATHER.m_bIsInList = true
--              break
--         end
--     end
--     WZLog("AutoRunBattleGM_FATHER:isInList-two",tostring(AutoRunBattleGM_FATHER.m_bIsInList),CacheCenter:getPlayerInfo().serverName,CacheCenter:getPlayerInfo().id)
--     return AutoRunBattleGM_FATHER.m_bIsInList
-- end