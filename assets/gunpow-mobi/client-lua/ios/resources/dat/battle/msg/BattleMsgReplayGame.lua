--BattleMsgReplayGame.lua
--@brief    战斗重播
--@date     2016/04/19
--@note     战斗重播（非堵塞消息）
BattleMsgReplayType = {
    BATTLE_MAKE_PAIR_OK = "6019", --战斗基础信息 60-19
    BATTLE_START_LOAD = "703",  --开始加载  70-3
    BATTLE_OTHER_LOAD = "7042",  --加载进度  70-42
    BATTLE_GET_POS = "705", --获得位置  70-5
    BATTLE_LOADING_END = "709",   --开始战斗   70-9
    -- BATTLE_GET_SKILL = 5,   --获得玩家技能列表
    -- BATTLE_GET_SKILL_LIST = 6,  --获得技能列表
    -- BATTLE_GET_ITEM = 7,    --获得玩家道具
    -- BATTLE_GET_ITEM_LIST = 8,   --获得道具列表

    START_ROUND = "7012", --回合切换   70-12
    GAME_OVER = "7027",  --游戏结束    70-27
    SOME_ONE_DEAD = "7030", --玩家死亡 70-30
    PLAYER_LOSE = "7032", --玩家掉线   70-32

    PLAYER_SHOOT = "7021", --玩家射击  70-21
    PLAYER_MOVE = "7014",  --玩家移动  70-14
    PLAYER_FLY = "7024",   --玩家飞行  70-24
    PLAYER_SKILL = "7016", --玩家使用技能    70-16
    RECEVIE_BUILD_GUAI = "7050", --收到创建怪物的battleId 70-50
    PLAYER_ADD_BUFF = "7045",  --buff状态同步  70-45
    -- PLAYER_CHANGE_ANGRY = 207, --怒气变化 70-17
    PLAYER_PASS = "7028",  --玩家pass    70-28

    BATTLE_MAKE_PAIR_OK_BOSS = "1825", --战斗基础信息 18-25
    BATTLE_START_LOAD_BOSS = "713",  --开始加载  71-3
    BATTLE_OTHER_LOAD_BOSS = "7142",  --加载进度  71-42
    BATTLE_LOADING_END_BOSS = "719",   --开始战斗   71-9

    START_ROUND_BOSS = "7112", --回合切换   71-12
    GAME_OVER_BOSS = "7127",  --游戏结束    71-27
    SOME_ONE_DEAD_BOSS = "7130", --玩家死亡 71-30
    PLAYER_LOSE_BOSS = "7132", --玩家掉线   71-32

    PLAYER_SHOOT_BOSS = "7121", --玩家射击  71-21
    PLAYER_MOVE_BOSS = "7114",  --玩家移动  71-14
    PLAYER_FLY_BOSS = "7124",   --玩家飞行  71-24
    PLAYER_SKILL_BOSS = "7116", --玩家使用技能    71-16
    RECEVIE_BUILD_GUAI_BOSS = "7150", --收到创建怪物的battleId 71-50
    PLAYER_ADD_BUFF_BOSS = "7145",  --buff状态同步  71-45
    PLAYER_PASS_BOSS = "7128",  --玩家pass    71-28

    BATTLE_LOADING_END_SINGLE = "109",  --单人副本加载结束
    BATTLE_READY_SINGLE = "209", --单人副本准备战斗
    BATTLE_REFRESH_CTB = "2010", --单人副本刷新ctb
    START_ROUND_SINGLE = "1012",   --单人副本回合开始
    GAME_OVER_SINGLE = "1027",     --单人副本游戏结束
    BATTLE_UPDATE_POS = "1000",     --单人副本位置同步
    PLAYER_SHOOT_SINGLE = "1021", --单人副本玩家射击
    PLAYER_MOVE_SINGLE = "1014",  --单人副本玩家移动
    PLAYER_FLY_SINGLE = "1024",   --单人副本玩家飞行
    PLAYER_SKILL_SINGLE = "1016", --单人副本玩家使用技能
    PLAYER_PASS_SINGLE = "1028",  --单人副本玩家pass
    MONSTER_MOVE_SINGLE = "2014",   --单人副本怪物移动
    MONSTER_FLY_SINGLE = "2024",    --单人副本怪物飞行
    MOSNTER_AICTION_SINGLE = "2021", --单人副本怪物行动
}
--@brief    消息数据表
BattleMsgReplayGame = {
    m_sName = "BattleMsgReplayGame",

    m_bOnReplay = false,    --重放中
    m_sGameRecord = nil,
    m_tStepList = nil,

    m_bIsWaitScene = nil,   --等待场景切换
}

--战斗记录表
BattleMsgReplayGameRecord = {
   m_tRecordStrList = nil,
   m_tMakePairOk = nil,
   m_tSingleRecord = nil,
   m_sSingleMakeOkRecord = nil,
   m_nBattleType = 1,
   m_bRecordConfig = false, --读取战斗记录标记(正常战斗入口不可读取)
   m_sSingleMakePairStr = nil,

   m_tProtoList = nil,
}

--@brief    注册协议
function BattleMsgReplayGameRecord:regProtocol(mainId, subId, callbackFunc, dataFormat, func)
    WZLog("BattleMsgReplayGameRecord:regProtocol",mainId..subId,tostring(func))
    if not BattleMsgReplayGameRecord.m_tProtoList then
        BattleMsgReplayGameRecord.m_tProtoList = {}
    end
    BattleMsgReplayGameRecord.m_tProtoList[mainId..subId] = func
end

--@brief 设置记录数据
function BattleMsgReplayGameRecord:setRecord(recordStrList,typeId)
    WZLog("BattleMsgReplayGameRecord:setRecord")
    WBattleGlobal:getCurrent():destroy()
    self.m_nBattleType = typeId
    self.m_tRecordStrList = recordStrList
    self.m_bRecordConfig = true
    self.m_bIsDecodeDone = false
    self.m_sSingleMakePairStr = nil
end

--@brief 重新播放
function BattleMsgReplayGameRecord:replayRecord()
    WZLog("BattleMsgReplayGameRecord:replayRecord")
    self.m_bRecordConfig = true
    replaceScene(SceneBattleLoading:createElement())
end

function BattleMsgReplayGameRecord:checkReplayConfig()
    WZLog("BattleMsgReplayGame:checkReplayConfig",tostring(self.m_bRecordConfig))
    if not self.m_bRecordConfig then
        return
    end
    self.m_bRecordConfig = false
    WBattleGlobal:getCurrent().m_bIsReplayGame = true
    self:initBattleGlobalData()
    WBattleGlobal:getCurrent().m_tMakePairOk = self.m_tMakePairOk
end

--@brief 初始化战斗数据
function BattleMsgReplayGameRecord:initBattleGlobalData()
    WZLog("BattleMsgReplayGameRecord:initBattleGlobalData",Serialize(self.m_tRecordStrList))
    local step = self:parseString(1,true)
    self.m_bIsSingleRecord = false
    if step.type == "-1" then
        self.m_bIsSingleRecord = true
        self:setSingleMakePairOk(unpack(step.serverRec))
    else
        if self.m_nBattleType == 6 then
            self:setBossMakePairOk(unpack(step.serverRec))
        else
            self:setMakePairOk(unpack(step.serverRec))
        end
    end
end

--@brief 清除记录数据
function BattleMsgReplayGameRecord:clearRecord()
    self.m_tRecordStrList = nil
    self.m_tMakePairOk = nil
end
--========================单人副本回放记录begin=================================--
function BattleMsgReplayGameRecord:getRecordTable(replayType)
    local record = {}
    record.proType = replayType or "-1"
    record.time = os.time()*1000 or "0"
    record.param = ""
    return record
end

function BattleMsgReplayGameRecord:appendParam(result,value,typeName)
    local record = typeName
    value = value or ""
    if typeName == "ints" or typeName == "booleans" or typeName == "strings" then
        for i,v in pairs(value) do
            record = record.."@"..tostring(value[i])
        end
    else
        record = record.."@"..tostring(value)
    end
    if result == "" then
        return record
    else
        return result.."#"..record
    end
end

-- guaiSex,guaiWeaponType,battleMode,mapType,mapId,playerId,
-- name,title,guildName,level,sex,hp,attack,critRate,defend,injuryFree,wreckDefense,reduceCrit,force,
-- armor,physical,agility,luck,fighting,winRate,headId,faceId,bodyId,wingId,weaponId,item_id,petId,
-- petParam,guaiBattleId,guaiId,section,weaponSkill
-- WZLuaLog:testII: #int_table: 0xeb56210#string_table: 0xeb56230#int_7#int_1#int_10101#int_1976796
 
--@brief 单人副本信息
function BattleMsgReplayGameRecord:setSingleMakePairOkRecord(param)
    WZLog("BattleMsgReplayGameRecord:setSingleMakePairOkRecord")
    local result = ""
    result = self:appendParam(result,json.encode(param.guaiSex),"string")
    result = self:appendParam(result,json.encode(param.guaiWeaponType),"string")
    result = self:appendParam(result,param.battleMode,"int")
    result = self:appendParam(result,param.mapType,"int")
    result = self:appendParam(result,param.mapId,"int")
    result = self:appendParam(result,param.playerId,"int")

    result = self:appendParam(result,param.name,"string")
    result = self:appendParam(result,param.title,"string")
    result = self:appendParam(result,param.guildName,"string")
    result = self:appendParam(result,param.level,"int")
    result = self:appendParam(result,param.sex,"int")
    result = self:appendParam(result,param.hp,"int")
    result = self:appendParam(result,param.attack,"int")
    result = self:appendParam(result,param.critRate,"int")
    result = self:appendParam(result,param.defend,"int")
    result = self:appendParam(result,param.injuryFree,"int")
    result = self:appendParam(result,param.wreckDefense,"int")
    result = self:appendParam(result,param.reduceCrit,"int")
    result = self:appendParam(result,param.force,"int")

    result = self:appendParam(result,param.armor,"int")
    result = self:appendParam(result,param.physical,"int")
    result = self:appendParam(result,param.agility,"int")
    result = self:appendParam(result,param.lucky,"int")
    result = self:appendParam(result,param.fighting,"int")
    result = self:appendParam(result,param.winRate,"int")
    result = self:appendParam(result,param.headId,"int")
    result = self:appendParam(result,param.faceId,"int")
    result = self:appendParam(result,param.bodyId,"int")
    result = self:appendParam(result,param.wingId,"int")
    result = self:appendParam(result,param.weaponId,"int")
    result = self:appendParam(result,param.item_id,"ints")
    result = self:appendParam(result,json.encode(param.petId),"string")
    result = self:appendParam(result,json.encode(param.petSkill),"string")
    result = self:appendParam(result,json.encode(param.petParam),"string")
    result = self:appendParam(result,json.encode(param.guaiBattleId),"string")
    result = self:appendParam(result,json.encode(param.guaiId),"string")
    result = self:appendParam(result,param.section,"int")
    result = self:appendParam(result,param.weaponSkill,"string")
    result = self:appendParam(result,param.exp,"int")
    result = self:appendParam(result,json.encode(param.petLevel),"string")
    result = self:appendParam(result,json.encode(param.colour),"string")
    result = self:appendParam(result,json.encode(param.bodyColour),"string")
    result = self:appendParam(result,json.encode(param.footmark),"string")
    result = self:appendParam(result,param.awakeId,"string")
    self.m_sSingleMakeOkRecord = result
    -- table.insert(self.m_tSingleRecord,record)
end

--@brief 加载结束
function BattleMsgReplayGameRecord:setLoadingEnd()
    self.m_tSingleRecord = {}
    table.insert(self.m_tSingleRecord,self:getRecordTable())
    local record = self:getRecordTable(BattleMsgReplayType.BATTLE_LOADING_END_SINGLE)
    table.insert(self.m_tSingleRecord,record)
end

--@brief 加载结束
function BattleMsgReplayGameRecord:setReadyBattle(param)
    local record = self:getRecordTable(BattleMsgReplayType.BATTLE_READY_SINGLE)
    local result = ""
    result = self:appendParam(result,param.wind,"int")
    result = self:appendParam(result,param.currentPlayerId,"int")
    result = self:appendParam(result,param.updateCTB_time,"int")
    result = self:appendParam(result,param.playerIds,"ints")
    result = self:appendParam(result,param.oldCTB,"ints")
    result = self:appendParam(result,param.newCTB,"ints")
    result = self:appendParam(result,param.battleRand,"ints")
    record.param = result
    table.insert(self.m_tSingleRecord,record)
end

--@brief ctb刷新
function BattleMsgReplayGameRecord:setRefreshCtb(param)
    WZLog("BattleMsgReplayGameRecord:setRefreshCtb")
    local record = self:getRecordTable(BattleMsgReplayType.BATTLE_REFRESH_CTB)
    local result = ""
    result = self:appendParam(result,param.playerIds,"ints")
    result = self:appendParam(result,param.oldCTB,"ints")
    result = self:appendParam(result,param.newCTB,"ints")
    result = self:appendParam(result,param.updateCTB_time,"int")
    record.param = result
    table.insert(self.m_tSingleRecord,record)
end

--@brief 回合开始
function BattleMsgReplayGameRecord:setStartRound(param)
    WZLog("BattleMsgReplayGameRecord:setStartRound")
    local record = self:getRecordTable(BattleMsgReplayType.START_ROUND_SINGLE)
    local result = ""
    result = self:appendParam(result,param.m_nBattleId,"int")
    result = self:appendParam(result,param.m_nPlayerId,"int")
    result = self:appendParam(result,param.m_nCurrentPlayerId,"int")
    result = self:appendParam(result,param.m_nPlayerOrGuai,"int")
    result = self:appendParam(result,param.m_nWind,"int")
    result = self:appendParam(result,param.m_bIsCrit,"int")
    result = self:appendParam(result,param.m_tAttackRate,"int")
    result = self:appendParam(result,param.m_tBattleRand,"ints")
    record.param = result
    table.insert(self.m_tSingleRecord,record)
end

--@brief 角色移动
function BattleMsgReplayGameRecord:setPlayerMove(param)
    local record = self:getRecordTable(BattleMsgReplayType.PLAYER_MOVE_SINGLE)
    local result = ""
    result = self:appendParam(result,param.m_nBattleId,"int")
    result = self:appendParam(result,param.m_nCurrentPlayerId,"int")
    result = self:appendParam(result,param.m_nMovecount,"int")
    result = self:appendParam(result,param.m_tMovestep,"ints")
    result = self:appendParam(result,param.m_nCurPositionX,"int")
    result = self:appendParam(result,param.m_nCurPositionY,"int")
    record.param = result
    table.insert(self.m_tSingleRecord,record)
end

--@brief 角色飞行
function BattleMsgReplayGameRecord:setPlayerFly(param)
    local record = self:getRecordTable(BattleMsgReplayType.PLAYER_FLY_SINGLE)
    local result = ""
    result = self:appendParam(result,param.m_nBattleId,"int")
    result = self:appendParam(result,param.m_nPlayerId,"int")
    result = self:appendParam(result,param.m_nCurrentPlayerId,"int")
    result = self:appendParam(result,param.m_nSpeedx,"int")
    result = self:appendParam(result,param.m_nSpeedy,"int")
    result = self:appendParam(result,param.m_nIsEquip,"int")
    result = self:appendParam(result,param.m_nLeftRight,"int")
    result = self:appendParam(result,param.m_nStartX,"int")
    result = self:appendParam(result,param.m_nStartY,"int")
    record.param = result
    table.insert(self.m_tSingleRecord,record)
end

--@brief 角色使用道具
function BattleMsgReplayGameRecord:setPlayerUse(param)
    local record = self:getRecordTable(BattleMsgReplayType.PLAYER_SKILL_SINGLE)
    local result = ""
    result = self:appendParam(result,param.playerId,"int")
    result = self:appendParam(result,param.useType,"int")
    result = self:appendParam(result,param.useId,"int")
    result = self:appendParam(result,param.bNotShowCell,"boolean")
    result = self:appendParam(result,param.isTreasure,"boolean")
    record.param = result
    table.insert(self.m_tSingleRecord,record)
end

--@brief 角色位置 
function BattleMsgReplayGameRecord:setBattlePos(param)
    local record = self:getRecordTable(BattleMsgReplayType.BATTLE_UPDATE_POS)
    local result = ""
    result = self:appendParam(result,param.nPlayerCount,"int")
    result = self:appendParam(result,param.tPlayerId,"ints")
    result = self:appendParam(result,param.tCurPositionX,"ints")
    result = self:appendParam(result,param.tCurPositionY,"ints")
    result = self:appendParam(result,param.tCurPositionR,"ints")
    result = self:appendParam(result,param.tCurPositionD,"ints")
    record.param = result
    table.insert(self.m_tSingleRecord,record)
end

--@brief 角色射击
function BattleMsgReplayGameRecord:setPlayerShoot(param)
    local record = self:getRecordTable(BattleMsgReplayType.PLAYER_SHOOT_SINGLE)
    local result = ""
    result = self:appendParam(result,param.m_nBattleId,"int")
    result = self:appendParam(result,param.m_nPlayerId,"int")
    result = self:appendParam(result,param.m_nCurrentPlayerId,"int")
    result = self:appendParam(result,param.m_nSpeedx,"int")
    result = self:appendParam(result,param.m_nSpeedy,"int")
    result = self:appendParam(result,param.m_nLeftRight,"int")
    result = self:appendParam(result,param.m_nStartX,"int")
    result = self:appendParam(result,param.m_nStartY,"int")
    record.param = result
    table.insert(self.m_tSingleRecord,record)
end

--@brief 角色pass
function BattleMsgReplayGameRecord:setPlayerPass(param)
    local record = self:getRecordTable(BattleMsgReplayType.PLAYER_PASS_SINGLE)
    local result = ""
    result = self:appendParam(result,param.m_nBattleId,"int")
    result = self:appendParam(result,param.m_nPlayerId,"int")
   
    record.param = result
    table.insert(self.m_tSingleRecord,record)
end

--@brief 怪物行动
function BattleMsgReplayGameRecord:setMonsterMove(param)
    local record = self:getRecordTable(BattleMsgReplayType.MONSTER_MOVE_SINGLE)
    local result = ""
    result = self:appendParam(result,param.m_nBattleId,"int")
    result = self:appendParam(result,param.actionParm1,"int")
    result = self:appendParam(result,param.actionParm2,"int")
    result = self:appendParam(result,param.actionParm3,"int")
    result = self:appendParam(result,param.actionParm4,"int")
    record.param = result
    table.insert(self.m_tSingleRecord,record)
end

--@brief 怪物行动
function BattleMsgReplayGameRecord:setMonsterFly(param)
    local record = self:getRecordTable(BattleMsgReplayType.MONSTER_FLY_SINGLE)
    local result = ""
    result = self:appendParam(result,param.m_nBattleId,"int")
    result = self:appendParam(result,param.actionParm1,"int")
    result = self:appendParam(result,param.actionParm2,"int")
    result = self:appendParam(result,param.actionParm3,"int")
    result = self:appendParam(result,param.actionParm4,"int")
    record.param = result
    table.insert(self.m_tSingleRecord,record)
end

--@brief 怪物行动
function BattleMsgReplayGameRecord:setMonsterAction(param)
    local record = self:getRecordTable(BattleMsgReplayType.MOSNTER_AICTION_SINGLE)
    local result = ""
    result = self:appendParam(result,param.m_nBattleId,"int")
    result = self:appendParam(result,param.m_nSkillId,"int")
    result = self:appendParam(result,param.m_nTalkId,"int")
    record.param = result
    table.insert(self.m_tSingleRecord,record)
end

-- --@brief 结束行动
-- function BattleMsgReplayGameRecord:setEndRound(param)
--     local record = self:getRecordTable(BattleMsgReplayType.START_ROUND_SINGLE)
--     record.param = param
--     table.insert(self.m_tSingleRecord,record)
-- end

--@brief 游戏结束
function BattleMsgReplayGameRecord:setGameOver(param)
    local record = self:getRecordTable(BattleMsgReplayType.GAME_OVER_SINGLE)
    local result = ""
    result = self:appendParam(result,param.m_bWin,"boolean")
    result = self:appendParam(result,json.encode(param.m_tSettlementData),"string")
    result = self:appendParam(result,json.encode(param.g_tSingCopyOver),"string")
    record.param = result
    table.insert(self.m_tSingleRecord,record)
end
--========================单人副本回放记录end=================================--

--@brief 解析战斗记录
--@note "#" 分割参数队列  参数结构1;参数结构2;...
--@note "_" 分割参数结构  参数类型[(数组)vec,(普通)def],参数,...
function BattleMsgReplayGameRecord:parseString(index,parseParam)
    if not self.m_tRecordStrList or not self.m_tRecordStrList[index] then
        return nil
    end
    
    local stepJson = self.m_tRecordStrList[index]
    WZLog("BattleMsgReplayGameRecord:parseString",index,stepJson)
    if not self.m_bIsDecodeDone then
        WZLog("BattleMsgReplayGameRecord:parseString-one")
        stepJson = json.decode(stepJson)
    else
        WZLog("BattleMsgReplayGameRecord:parseString-two",tostring(stepJson))
    end
    local step = {}
    step.type = stepJson.proType
    step.time = stepJson.time
    if not self.m_sSingleMakePairStr then
        self.m_sSingleMakePairStr = stepJson.param
    end
    if index == 1 then
        stepJson.param = self.m_sSingleMakePairStr
    end
    if step.type == "-1" and index > 1 then
        step.serverRec = stepJson.param
        return step
    end
    step.serverRec = {}
    --解析参数
    if parseParam then
        local paramStr = stepJson.param
        if paramStr and paramStr ~= "" then
            local paramList = SplitStringWithSeparator(paramStr, "#")
            for i,v in pairs(paramList) do
                local subParamList = SplitStringWithSeparator(v,"@")
                --类型1 byte,int,short,long,boolean,string
                --类型2 bytes,ints,shorts,longs,booleans,strings
                local typeName = subParamList[1]
                local value = subParamList[2]
                if typeName == "bytes" or typeName == "ints" or typeName == "shorts" 
                    or typeName == "longs" or typeName == "booleans" or typeName == "strings" then
                    value = self:getParamList(subParamList,index == 1)
                elseif typeName == "boolean" then
                    value = subParamList[2] == "true" and true or false
                    
                elseif typeName == "byte" or typeName == "int" or typeName == "short" or typeName == "long" then
                    value = tonumber(subParamList[2])
                end
                step.serverRec[i] = value
            end
        end
    end

    WZLog("BattleMsgReplayGameRecord:parseString-three",Serialize(step))
    
    return step
end

function BattleMsgReplayGameRecord:parseSingleStr(recordStr)
    WZLog("BattleMsgReplayGameRecord:parseSingleStr")
    if type(recordStr) ~= "string" then
        WZLog("BattleMsgReplayGameRecord:parseSingleStr-two")
        self.m_tRecordStrList = recordStr
    else
        WZLog("BattleMsgReplayGameRecord:parseSingleStr-three")
        self.m_tRecordStrList = json.decode(recordStr)
    end
    --self.m_tRecordStrList = json.decode(recordStr)
    self.m_bIsDecodeDone = true
end

function BattleMsgReplayGameRecord:getParamList(list,isMakePair)
    local typeName = list[1]
    local paramList = {}
    for i ,v in pairs(list) do
        if v ~= typeName then
            local value = v
            if typeName == "bytes" or typeName == "ints" or typeName == "shorts" or typeName == "longs" then
                value = tonumber(v)
            elseif typeName == "booleans" then
                value = v == "true" and true or false
            end
            table.insert(paramList,value)
        end
    end

    if typeName == "bytes" or typeName == "ints" or typeName == "shorts" or typeName == "longs" then
        if not isMakePair and not self.m_bIsSingleRecord then
            paramList = TableToIntVector(paramList)
        end
    end

    return paramList
end

function BattleMsgReplayGameRecord:setSingleMakePairOk(guaiSex,guaiWeaponType,battleMode,mapType,mapId,playerId,
    name,title,guildName,level,sex,hp,attack,critRate,defend,injuryFree,wreckDefense,reduceCrit,force,
    armor,physical,agility,lucky,fighting,winRate,headId,faceId,bodyId,wingId,weaponId,item_id,petId,petSkill,
    petParam,guaiBattleId,guaiId,section,weaponSkill,exp,petLevel,colour,bodyColour,footmark)
    
    WZLog("BattleMsgReplayGameRecord:setSingleMakePairOk")
    self.m_tMakePairOk = {
        battleMull=false,
        battleChannle=-1,
        guaiSex = json.decode(guaiSex),
        guaiWeaponType = json.decode(guaiWeaponType),
        battleId=1,
        battleMode=battleMode,
        mapType=mapType,

        mapId=mapId,
        playerCount=1,
        playerCamp={[1]=0},
        playerId={[1]=playerId},
        playerName={[1]=name},
        playerTitle={[1]=title},
        playerCommunity={[1]=guildName},
        playerLevel={[1]=level},
        playerSex={[1]=sex},

        maxHP={[1]=hp},
        maxPF={[1]=100},
        maxSP={[1]=0},
        attack={[1]=math.floor(attack)},
        critRate={[1]=critRate},
        defence={[1]=defend},
        injuryFree={[1]=injuryFree},
        wreckDefense={[1]=wreckDefense},
        reduceCrit={[1]=reduceCrit},
        reduceBury={[1]=0},
        power={[1]=force},
        armor={[1]=armor},
        constitution={[1]=physical},
        agility={[1]=agility},
        lucky={[1]=lucky},
        fighting ={[1]=fighting},
        winRate = {[1]=winRate},

        headId={[1]=headId},
        faceId={[1]=faceId},
        bodyId={[1]=bodyId},
        wingId={[1]=wingId},
        weaponId={[1]=weaponId},

        item_id= item_id,
        playerBuffCount = {[1]=0},
        buffId = {[1]=0},

        petId=json.decode(petId),
        petSkill = json.decode(petSkill),
        petSkillId={[1]=0},
        petParam=json.decode(petParam),
        petLevel = petLevel and json.decode(petLevel) or {[1]=0},

        guaiBattleId=json.decode(guaiBattleId),
        guaiId=json.decode(guaiId),
        section = section,
        weaponSkill={[1]=weaponSkill},
        colour= colour and json.decode(colour) or {[1]=0}, 
        bodyColour= bodyColour and json.decode(bodyColour) or {[1]=0},
        footmark = footmark and json.decode(footmark) or {[1]=0},
        selfId = playerId
        -- selfCamp = 
    }
    -- playerData = {sex,level,exp,equip = {faceId,headId,bodyId,wingId,weaponId}}
    self.m_tMakePairOk.m_tPlayerInfo = {sex =sex,level = level,exp = exp,colour = colour and json.decode(colour) or {[1]=0},bodyColour = bodyColour and json.decode(bodyColour) or {[1]=0},equip = {faceId,headId,bodyId,wingId,weaponId}}

    WBattleGlobal:getCurrent().m_nBattleType = BattleConstants.g_nBATTLE_TYPE_BOSS
    WBattleGlobal:getCurrent().battleMode = battleMode
    local item_name = {[1]=0}
    local item_img = {[1]=0}
    local item_ConsumePower = {[1]=0}
    local item_desc = {[1]=0}
    local item_type = {[1]=0}
    local item_subType = {[1]=0}
    local item_param1 = {[1]=0}
    local item_param2 = {[1]=0}
    local specialAttackType = {[1]=0}
    local specialAttackParam = {[1]=0}
    SceneBattleLoading:receiveGetSkillListOk(#item_id, item_id, item_name, item_img, item_ConsumePower, item_desc, item_type, item_subType, item_param1, item_param2, item_ConsumePower, item_ConsumePower, specialAttackType, specialAttackParam)
    
    SceneBattleLoading:receiveGetPropListOk(#item_id, item_id, item_name, item_img, item_ConsumePower, item_desc, item_type, item_subType, item_param1, item_param2, item_ConsumePower, item_ConsumePower, specialAttackType, specialAttackParam)
end

function BattleMsgReplayGameRecord:setMakePairOk(
    battleId,battleMode,battleChannle,schedule,mapId, 
    playerCount, playerCamp,playerId, serverId, playerName, 
    playerTitle, playerCommunity, playerLevel,playerSex, maxHP, 
    maxPF, maxSP, attack, critRate, defence, 
    injuryFree, wreckDefense, reduceCrit, power, armor,
    constitution, agility, lucky, winRate, fighting, 
    headId, faceId, bodyId, weaponId, wingId, 
    item_id, petSkill,playerBuffCount, buffId, petId, 
    petParam, battleTimes, winTimes, streakTimes, segmentLevel,
    tournamentLevel,teamId,teamName,url,petLevel, 
    colour, bodyColour,isCaptain,footmark)
    
    -- WZLog("checkParam-0\n",Serialize(VectorToTable(battleId)),Serialize(VectorToTable(battleMode)),
    --     battleMull,battleChannle,Serialize(VectorToTable(mapId)),
    --     Serialize(VectorToTable(playerCount)),Serialize(VectorToTable(playerCamp)),
    --     Serialize(VectorToTable(playerId)),Serialize(VectorToTable(playerName)),
    --     Serialize(VectorToTable(playerTitle)))

    -- WZLog("checkParam-1\n",Serialize(VectorToTable(playerCommunity)),Serialize(VectorToTable(playerLevel)),
    --     Serialize(VectorToTable(playerSex)),Serialize(VectorToTable(maxHP)),
    --     Serialize(VectorToTable(maxPF)),Serialize(VectorToTable(maxSP)),
    --     Serialize(VectorToTable(attack)),Serialize(VectorToTable(critRate)),
    --     Serialize(VectorToTable(defence)),Serialize(VectorToTable(injuryFree)))
    local rPetLevel = petLevel and petLevel or {}
    local rColour = colour and colour or {}
    local rBodyColour = bodyColour or {}

    self.m_tMakePairOk = {
    battleId=VectorToTable(battleId),battleMode=VectorToTable(battleMode), battleMull=battleMull, battleChannle=battleChannle,mapId=VectorToTable(mapId),playerCount=VectorToTable(playerCount),playerCamp=VectorToTable(playerCamp),playerId=VectorToTable(playerId),serverId=VectorToTable(serverId),

    playerName= VectorToTable(playerName),

    playerTitle=VectorToTable(playerTitle),playerCommunity=VectorToTable(playerCommunity),playerLevel=VectorToTable(playerLevel),playerSex=VectorToTable(playerSex),maxHP=VectorToTable(maxHP),maxPF=VectorToTable(maxPF),maxSP=VectorToTable(maxSP),attack=VectorToTable(attack),

    critRate=VectorToTable(critRate),defence=VectorToTable(defence),injuryFree=VectorToTable(injuryFree),wreckDefense=VectorToTable(wreckDefense),reduceCrit=VectorToTable(reduceCrit),reduceBury=VectorToTable(reduceBury),power=VectorToTable(power),armor=VectorToTable(armor),

    constitution=VectorToTable(constitution),agility=VectorToTable(agility),lucky=VectorToTable(lucky),winRate=VectorToTable(winRate),fighting=VectorToTable(fighting),headId=VectorToTable(headId),faceId=VectorToTable(faceId),bodyId=VectorToTable(bodyId),weaponId=VectorToTable(weaponId),wingId=VectorToTable(wingId),item_id=VectorToTable(item_id),

    playerBuffCount=VectorToTable(playerBuffCount),buffId=VectorToTable(buffId),petId=VectorToTable(petId),petSkill=VectorToTable(petSkill),petSkillId=VectorToTable(petId),petParam=VectorToTable(petParam),guaiBattleId=guaiBattleId,guaiId=guaiId,weaponSkill= VectorToTable(weaponSkill),tournamentLevel=VectorToTable(tournamentLevel),
    teamId=VectorToTable(teamId),teamName=VectorToTable(teamName),url=VectorToTable(url),petLevel=VectorToTable(rPetLevel),colour = VectorToTable(rColour),bodyColour=VectorToTable(rBodyColour),isCaptain=VectorToTable(isCaptain),footmark = VectorToTable(footmark)}
    
    
    WBattleGlobal:getCurrent().m_nBattleType = BattleConstants.g_nBATTLE_TYPE_NORMAL
    WBattleGlobal:getCurrent().battleMode = battleMode
    self.m_tMakePairOk.selfId = playerId[1]

    -- self.m_tMakePairOk.selfId = -10000
     WZLog("BattleMsgReplayGameRecord:setMakePairOk", tostring(battleMull), battleChannle,"\n\nbattleId",

    Serialize(VectorToTable(battleId)),Serialize(VectorToTable(battleMode)),Serialize(VectorToTable(mapId)),Serialize(VectorToTable(playerCount)),Serialize(VectorToTable(playerCamp)),Serialize(VectorToTable(playerId)),Serialize(VectorToTable(playerName)),Serialize(VectorToTable(playerTitle)),Serialize(VectorToTable(playerCommunity)),"\n\nplayerLevel",

    Serialize(VectorToTable(playerLevel)),Serialize(VectorToTable(playerSex)),Serialize(VectorToTable(maxHP)),Serialize(VectorToTable(maxPF)),Serialize(VectorToTable(maxSP)),Serialize(VectorToTable(attack)),Serialize(VectorToTable(critRate)),Serialize(VectorToTable(defence)),Serialize(VectorToTable(injuryFree)),"\n\nwreckDefense",

    Serialize(VectorToTable(wreckDefense)),Serialize(VectorToTable(reduceCrit)),Serialize(VectorToTable(power)),Serialize(VectorToTable(armor)),Serialize(VectorToTable(constitution)),Serialize(VectorToTable(agility)),Serialize(VectorToTable(lucky)),"\n\nheadId",

    Serialize(VectorToTable(headId)),Serialize(VectorToTable(faceId)),Serialize(VectorToTable(bodyId)),Serialize(VectorToTable(weaponId)),Serialize(VectorToTable(wingId)),Serialize(VectorToTable(item_id)),Serialize(VectorToTable(playerBuffCount)),Serialize(VectorToTable(buffId)),"\n\npetId",

        Serialize(VectorToTable(petId)),Serialize(VectorToTable(petParam)), "\n\nweaponSkill",
        Serialize(VectorToTable(weaponSkill)),
        Serialize(VectorToTable(tournamentLevel)))
end

function BattleMsgReplayGameRecord:setBossMakePairOk(battleId,mapId, playerCount, playerId,serverId,
    playerName, 
    playerTitle, playerCommunity, playerLevel, playerSex, maxHP, 
    maxPF, maxSP, attack, critRate, defence, 
    injuryFree, wreckDefense, reduceCrit, power, armor, 
    constitution, agility, lucky, headId, faceId, 
    bodyId, weaponId, wingId, item_id,petSkill,
    playerBuffCount, buffId, petId,petParam, guaiBattleId, guaiId,
    tournamentLevel,petLevel,colour,bodyColour,footmark)
    local rPetLevel = petLevel and petLevel or {}
    local rColour = colour and colour or {}
    local rBodyColour = bodyColour or {}

    self.m_tMakePairOk = {
    battleId=battleId, battleMull=false, battleChannle=-1,mapId=mapId,playerCount=playerCount,playerId=playerId,serverId = serverId,playerName=playerName,

    playerTitle=playerTitle,playerCommunity=playerCommunity,playerLevel=playerLevel,playerSex=playerSex,maxHP=maxHP,maxPF=maxPF,maxSP=maxSP,attack=attack,

    critRate=critRate,defence=defence,injuryFree=injuryFree,wreckDefense=wreckDefense,reduceCrit=reduceCrit,reduceBury=reduceBury,power=power,armor=armor,

    constitution=constitution,agility=agility,lucky=lucky,headId=headId,faceId=faceId,bodyId=bodyId,weaponId=weaponId,wingId=wingId,item_id=item_id,

    playerBuffCount=playerBuffCount,buffId=buffId,petId=petId,petSkill = petSkill,petSkillId=petId,petParam=petParam,guaiBattleId=guaiBattleId,
    guaiId=guaiId,battleMode=BattleConstants.g_tBossBattleMode.MODE_BOSSMAP_2,weaponSkill=weaponSkill,
    tournamentLevel=tournamentLevel,petLevel=rPetLevel,colour = rColour,bodyColour=rBodyColour,footmark = footmark}
    
    WBattleGlobal:getCurrent().m_nBattleType = BattleConstants.g_nBATTLE_TYPE_BOSS
    WBattleGlobal:getCurrent().battleMode = BattleConstants.g_tBossBattleMode.MODE_BOSSMAP_2
    self.m_tMakePairOk.selfId = playerId[1]
end

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgReplayGame:init()
    WZLog("BattleMsgReplayGame:init")
    self.m_bOnReplay = true
    self.m_nRecordIndex = 1
    self.m_nRecordTime = nil
    self.m_nRunTime = nil
    self.m_tStep = nil
    self.m_nReplaySpeed = 1
    self.m_nStartTime = os.time()
    -- CCDirector:sharedDirector():getScheduler():setTimeScale(2)
    self:doNextAction()
end

--@brief 处理下一个
function BattleMsgReplayGame:doNextAction()
    self.m_nRecordIndex = self.m_nRecordIndex + 1
    if self.m_tNextStep then
        self.m_tStep = self.m_tNextStep
    else
        self.m_tStep = BattleMsgReplayGameRecord:parseString(self.m_nRecordIndex)
    end
    self.m_tNextStep = BattleMsgReplayGameRecord:parseString(self.m_nRecordIndex + 1)
    if not self.m_tStep then
        self.m_bOnReplay = false
        return
    end
    if not self.m_nRecordTime then
        self.m_nRecordTime = tonumber(self.m_tStep.time)
    end
    if not self.m_nRunTime then
        self.m_nRunTime = self.m_nRecordTime
    end
    WZLog("BattleMsgReplayGame:doNextAction",self.m_tStep.type)
    if self.m_tStep.type == "-1" then
        self.m_nRecordIndex = 1 --第一条不读
        self.m_nRecordTime = nil 
        self.m_nRunTime = nil
        BattleMsgReplayGameRecord:parseSingleStr(self.m_tStep.serverRec)
        self:doNextAction()
        return
    end

    self:checkRecordTime(0)
end

--@breif 检测时间
function BattleMsgReplayGame:checkRecordTime(dt)
    if self.m_nRunTime then
        local stepType = self.m_tStep and self.m_tStep.type or "-1"
        local timeSpeed = self.m_nReplaySpeed
        if stepType == BattleMsgReplayType.PLAYER_MOVE or stepType == BattleMsgReplayType.PLAYER_FLY 
            or stepType == BattleMsgReplayType.PLAYER_MOVE_SINGLE or stepType == BattleMsgReplayType.PLAYER_FLY_SINGLE 
            or stepType == BattleMsgReplayType.PLAYER_MOVE_BOSS or stepType == BattleMsgReplayType.PLAYER_FLY_BOSS then
            timeSpeed = 1
        end
        local time = os.time()
        local dt = (time - self.m_nStartTime)*timeSpeed
        self.m_nStartTime = time
        self.m_nRunTime = self.m_nRunTime + dt * 1000
        -- WZLog("BattleMsgReplayGame:checkRecordTime",self.m_nRunTime,self.m_nRecordTime)
        if  self.m_nRecordTime and self.m_nRunTime >= self.m_nRecordTime then
            if stepType == BattleMsgReplayType.START_ROUND or stepType == BattleMsgReplayType.START_ROUND_BOSS
                or stepType == BattleMsgReplayType.START_ROUND_SINGLE then
                --回合开始先等待消息结束
                if self:waitForRoundEnd() then
                    return
                else
                    self.m_nRunTime = self.m_nRecordTime 
                end
            end
            self.m_nRecordTime = nil
            self:doAction()
        end
    end
end

function BattleMsgReplayGame:waitForRoundEnd()
    if #MsgManager.m_tBlockMsgList > 0 then
       return true
    end
    return false
end

function BattleMsgReplayGame:setReplaySpeed(value)
    if self.m_nReplaySpeed == value then
        return
    end
    if self.m_nReplaySpeed == 0 then
        self.m_nStartTime = os.time()
    end
    self.m_nReplaySpeed = value
end

--@brief 处理下一个
function BattleMsgReplayGame:doAction()
    self.m_tStep = BattleMsgReplayGameRecord:parseString(self.m_nRecordIndex,true)
    local step = self.m_tStep
    WZLog("BattleMsgReplayGame:doAction",step.type)
    if step.serverRec then
        WZLog("BattleMsgReplayGame:doAction-two\n",unpack(step.serverRec))
    end
    
    local msgType = step.type
    local msgParam = step.serverRec
    if BattleMsgReplayGameRecord.m_bIsSingleRecord then
        self:doSingleAction(msgType,msgParam)
        return
    end
    local protocol = BattleMsgReplayGameRecord.m_tProtoList[msgType]
    if protocol then
        protocol(ProtocolProcessorSceneBattle, unpack(msgParam))
    else
        WZLog("BattleMsgReplayGame:doAction empty protocol",msgType)
    end

    self:doNextAction()
end

--@brief 单人副本处理
function BattleMsgReplayGame:doSingleAction(msgType,msgParam)
    --单人副本
    if msgType == BattleMsgReplayType.BATTLE_LOADING_END_SINGLE then
        self:_battleLoadingEndSingle(unpack(msgParam))
    elseif msgType == BattleMsgReplayType.BATTLE_REFRESH_CTB then
        self:_battleRefreshCtb(unpack(msgParam))
    elseif msgType == BattleMsgReplayType.BATTLE_READY_SINGLE then
        self:_battleReadySingle(unpack(msgParam))
    elseif msgType == BattleMsgReplayType.START_ROUND_SINGLE then
        self:_startRoundSingle(unpack(msgParam))
    elseif msgType == BattleMsgReplayType.GAME_OVER_SINGLE then
        self:_gameOverSingle(unpack(msgParam))
    elseif msgType == BattleMsgReplayType.PLAYER_SHOOT_SINGLE then
        self:_playerShootSingle(unpack(msgParam))
    elseif msgType == BattleMsgReplayType.PLAYER_MOVE_SINGLE then
        self:_playerMoveSingle(unpack(msgParam))
    elseif msgType == BattleMsgReplayType.PLAYER_FLY_SINGLE then
        self:_playerFlySingle(unpack(msgParam))
    elseif msgType == BattleMsgReplayType.PLAYER_SKILL_SINGLE then
        self:_palyerSkillSingle(unpack(msgParam))
    elseif msgType == BattleMsgReplayType.PLAYER_PASS_SINGLE then
        self:_playerPassSingle(unpack(msgParam))
    elseif msgType == BattleMsgReplayType.MONSTER_MOVE_SINGLE then
        self:_monsterMoveSingle(unpack(msgParam))
    elseif msgType == BattleMsgReplayType.MONSTER_FLY_SINGLE then
        self:_monsterFlySingle(unpack(msgParam))
    elseif msgType == BattleMsgReplayType.MOSNTER_AICTION_SINGLE then
        self:_monsterActionSingle(unpack(msgParam))
    elseif msgType == BattleMsgReplayType.BATTLE_UPDATE_POS then
        self:_battleUpdatePosSingle(unpack(msgParam))
    else
        self:doNextAction()
        return
    end
    
    if self.m_tNextStep and (self.m_tNextStep.type == BattleMsgReplayType.RECEVIE_BUILD_GUAI or self.m_tNextStep.type == BattleMsgReplayType.RECEVIE_BUILD_GUAI_BOSS) then
        self.m_bBuildGuaiActionNext = false
        self.m_nBuildGuaiActionIndex = self.m_nRecordIndex + 1
        self:_recevieBuildGuai(unpack(self.m_tNextStep.serverRec))
    end
    -- if self.m_tStepList[1] and self.m_tStepList[1].type == BattleMsgReplayType.RECEVIE_BUILD_GUAI then
    --     self:doNextAction()
    -- end
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgReplayGame:process(dt)
    self:checkRecordTime(dt)

    if self.m_bIsWaitScene then
        if WBattleGlobal:getCurrent().m_bIsSchedule then
            self.m_bIsWaitScene = nil
            self:doNextAction()
        end
    end
    if self.m_bOnReplay then
        return false
    end
    return true
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgReplayGame:done()
    WZLog("BattleMsgReplayGame:done")
end

-------------------------------------私有方法模块--------------------------------------
   

--==============================================单人副本====================================================================
--|
--|
--|
--|
--|
--|
--|
--==============================================单人副本====================================================================
--@brief 加载结束
function BattleMsgReplayGame:_battleLoadingEndSingle()
    WZLog("BattleMsgReplayGame:_battleLoadingEndSingle")
    SceneBattleLoading:receiveGotoBattle()
    self:doNextAction()
end

--@brief 战斗准备
function BattleMsgReplayGame:_battleReadySingle(wind,currentPlayerId,updateCTB_time,playerIds,oldCTB,newCTB,battleRand)
    WZLog("BattleMsgReplayGame:_battleReadySingle")
    WBattleGlobal:getCurrent().m_tSingleActivityMemberList = {}
    WBattleGlobal:getCurrent().m_nSingleActivityMemberIndex = 1
    WBattleGlobal:getCurrent().m_nPlayerOrGuai = 1
    WBattleGlobal:getCurrent().m_nIsCriticalHit = 0
    WBattleGlobal:getCurrent().m_tAttackRate = 100
    WBattleGlobal:getCurrent().m_nIsNewRound = 1
    WBattleGlobal:getCurrent().m_nLeftMedal = 0
    WBattleGlobal:getCurrent().m_nRightMedal = 0
    WBattleGlobal:getCurrent().m_tBattleRecord = {}

    BattleCtbManager:initCTB()
    -- BattleCtbManager:sortCTB()

    WBattleGlobal:getCurrent().m_tWind.x = wind
    WBattleGlobal:getCurrent().m_nCurrentPlayerId = currentPlayerId
    WBattleGlobal:getCurrent().m_tBattleRand = battleRand
    local tPlayerId = VectorToTable(playerIds)
    local tNowCtb = VectorToTable(oldCTB)
    local tNewCtb = VectorToTable(newCTB)
    BattleCtbManager:refreshLastCtb(tPlayerId,tNowCtb,tNewCtb,updateCTB_time)

    WBattleGlobal:getCurrent().m_tBattleRand = battleRand
    self.m_bIsWaitScene = true
end

--@brief 刷新ctb
function BattleMsgReplayGame:_battleRefreshCtb(playerIds,oldCTB,newCTB,updateCTB_time)
    WZLog("BattleMsgReplayGame:_battleRefreshCtb")
    local tPlayerId = VectorToTable(playerIds)
    local tNowCtb = VectorToTable(oldCTB)
    local tNewCtb = VectorToTable(newCTB)
    BattleCtbManager:refreshLastCtb(tPlayerId,tNowCtb,tNewCtb,updateCTB_time)
    self:doNextAction()
end

--@brief 回合开始
function BattleMsgReplayGame:_startRoundSingle(mapBattleId,playerId,currentPlayerId,playerOrGuai,wind,isCrit,attactRate,battleRand)
    WZLog("BattleMsgReplayGame:_startRoundSingle")
    local msg = MsgManager:createMsg(BattleMsgShowCtbTime)
    msg.m_tBattleRand = battleRand
    MsgManager:pushBlockMsg(msg)
   
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(currentPlayerId)
    local pos = hero and hero:getPosition() or {x = 500,y=500}
    local msg = MsgManager:createMsg(BattleMsgZoomToHero)
    msg.m_nPlayerId = currentPlayerId
    msg.m_nPlayerPos = hero and hero:getAnimation():getPosition()
    msg.m_bIsFollow = true
    MsgManager:pushBlockMsg(msg)

    local msg = MsgManager:createMsg(BattleMsgCanStartCurRound)
    msg.m_nBattleId = battleId
    msg.m_nPlayerId = playerId
    msg.m_nCurrentPlayerId = currentPlayerId
    msg.m_nPlayerOrGuai = playerOrGuai
    msg.m_nWind = wind
    msg.m_bIsCrit = isCrit
    msg.m_tAttackRate = attactRate
    msg.m_nIsNewRound = false--WBattleGlobal:getCurrent().m_nIsNewRound
    msg.m_tBattleRand = battleRand
    msg.m_bIsReplayMsg = true --结束标记
    MsgManager:pushBlockMsg(msg)
end

--@brief 游戏结束
function BattleMsgReplayGame:_gameOverSingle(isWin,tSettlementData,tSingCopyOver)
    WZLog("BattleMsgReplayGame:_gameOverSingle")
    local msg = MsgManager:createMsg(BattleMsgGameOver)
    msg.m_bWin = isWin
    msg.m_tSettlementData = json.decode(tSettlementData)
    g_tSingCopyOver = json.decode(tSingCopyOver)
    g_tSingCopyOver.isVideo = true
    MsgManager:pushNonBlockMsg(msg)
    self:doNextAction()
end

--@brief 玩家射击
function BattleMsgReplayGame:_playerShootSingle(mapBattleId,playerId,currentId,speedx,speedy,face,startX,startY)
    WZLog("BattleMsgReplayGame:_playerShootSingle")
    local msg = MsgManager:createMsg(BattleMsgPlayerShoot)
    msg.m_nBattleId = mapBattleId
    msg.m_nPlayerId = playerId
    msg.m_nCurrentPlayerId = currentId
    msg.m_nSpeedx = speedx
    msg.m_nSpeedy = speedy
    msg.m_nLeftRight = face
    msg.m_nStartX = startX
    msg.m_nStartY = startY
    msg.m_bIsReplayMsg = true --结束标记
    MsgManager:pushBlockMsg(msg)
end

--@brief 玩家飞行
function BattleMsgReplayGame:_playerFlySingle(mapBattleId,playerId,currentId,speedx,speedy,isEquip,face,startX,startY)
    WZLog("BattleMsgReplayGame:_playerFlySingle")
    local msg = MsgManager:createMsg(BattleMsgPlayerFly)
    msg.m_nBattleId = mapBattleId
    msg.m_nPlayerId = playerId
    msg.m_nCurrentPlayerId = currentId
    msg.m_nSpeedx = speedx
    msg.m_nSpeedy = speedy
    msg.m_nIsEquip = isEquip
    msg.m_nLeftRight = face
    msg.m_nStartX = startX
    msg.m_nStartY = startY
    msg.m_bIsReplayMsg = true --结束标记
    MsgManager:pushBlockMsg(msg)
end


--@brief 玩家移动
function BattleMsgReplayGame:_playerMoveSingle(mapBattleId,playerId,movecount,moveStep,startX,startY)
    WZLog("BattleMsgReplayGame:_playerMoveSingle")
    local msg = MsgManager:createMsg(BattleMsgPlayerMove)
    msg.m_nBattleId = mapBattleId
    msg.m_nCurrentPlayerId = playerId
    msg.m_nMovecount = movecount
    msg.m_tMovestep = moveStep
    msg.m_nCurPositionX = math.floor(startX)
    msg.m_nCurPositionY = math.floor(startY)
    msg.m_bIsReplayMsg = true --结束标记
    MsgManager:pushBlockMsg(msg)
end

--@brief 玩家使用道具
function BattleMsgReplayGame:_palyerSkillSingle(playerId,useType,useId,bNotShowCell,isTreasure)
    WZLog("BattleMsgReplayGame:_palyerSkillSingle")
    BattleHeroUse:heroUse(playerId,useType,useId,bNotShowCell,isTreasure)
end

--@brief 玩家pass
function BattleMsgReplayGame:_playerPassSingle(battleId,playerId)
    WZLog("BattleMsgReplayGame:_playerPassSingle")
    local msg = MsgManager:createMsg(BattleMsgPass)
    msg.m_nBattleId = battleId
    msg.m_nPlayerId = playerId
    msg.m_bIsReplayMsg = true --结束标记
    MsgManager:pushBlockMsg(msg)
end

--@brief 怪物移动
function BattleMsgReplayGame:_monsterMoveSingle(battleId,actionParm1,actionParm2,actionParm3,actionParm4)
    WZLog("BattleMsgReplayGame:_monsterMoveSingle")
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(battleId)
    hero:getAI():doAction(AiActionConfig.MOVE_NEW,
        {[1] = {actionParm1 = actionParm1,actionParm2 = actionParm2,actionParm3 = actionParm3,actionParm4 = actionParm4}},
        nil, nil,nil, true)
end

--@brief 怪物飞行
function BattleMsgReplayGame:_monsterFlySingle(battleId,actionParm1,actionParm2,actionParm3,actionParm4)
    WZLog("BattleMsgReplayGame:_monsterFlySingle")
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(battleId)
    hero:getAI():doAction(AiActionConfig.FLY,{[1] = {actionParm1 = actionParm1,actionParm2 = actionParm2,actionParm3 = actionParm3,actionParm4 = actionParm4}})
end

--@brief 怪物行动
function BattleMsgReplayGame:_monsterActionSingle(battleId,skillId,talkId)
    WZLog("BattleMsgReplayGame:_monsterActionSingle")
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(battleId)
    local msg = MsgManager:createMsg(BattleMsgSkillShow)
    msg.m_tOwner = hero
    msg.m_nSkillId = skillId
    msg.m_nTalkId = talkId
    msg.m_bIsReplayMsg = true --结束标记
    MsgManager:pushBlockMsg(msg)
end

function BattleMsgReplayGame:_battleUpdatePosSingle(playerCount,tPlayerId,tCurPositionX,tCurPositionY,tCurPositionR,tCurPositionD)
    for i=1, playerCount do
        local _hero = WBattleGlobal:getCurrent():getCharacterWithId(tPlayerId[i])
        if _hero then
            WZLog("m_bIsReplayGame",_hero:getType())
            local rotate = _hero:getAnimation():getRotate()
            local flip = _hero:getAnimation():isFlipX() and 1 or 0

            _hero:setPosition({x = tCurPositionX[i] , y = tCurPositionY[i] } )
            if _hero:getMover() then
                _hero:getMover():setMoverSpeed(Vector2:create(0,0))
                _hero:getMover():setMoverPrePosition( Vector2:create( tCurPositionX[i] , tCurPositionY[i]) )
            end
            if tCurPositionR[i] then
                _hero:getAnimation():setRotate(tCurPositionR[i])
            end
            if tCurPositionD[i] then
                _hero:getAnimation():setFlipX(tCurPositionD[i] == 1 and true or false)
            end
        end
        WZLog("BattleMsgReplayGame:_battleUpdatePosSingle",tPlayerId[i],tCurPositionX[i], tCurPositionY[i], rotate, tCurPositionR[i], flip, tCurPositionD[i])
    end
    self:doNextAction()
end
