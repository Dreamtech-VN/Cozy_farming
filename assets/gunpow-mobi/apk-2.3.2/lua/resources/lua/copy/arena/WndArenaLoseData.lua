--WndArenaLoseData.lua
--@brief	WndArenaLose的数据模块
--@date		2015-11-19
--@author	binshao
--@note		竞技场失败

WndArenaLose = {

}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndArenaLose:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_tData = nil                  --数据表
    self.m_tSettlementData = nil        --对原始数据经过处理后的，和界面相匹配的数据表
    self.m_nCountdown = 0               --倒计时
    self.lineCnt = 1                    -- 分割线的人数
    self.playerCon = {}
    self.isVideo = false

    self.winTeam = {}
    self.failTeam = {}
    self.teamInfo = {}          -- 战队信息，联赛用
    self.winScore = 0           -- 英雄联赛专用（赢方的分数）
    self.failScore = 0          -- 英雄联赛专用（输方的分数）
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndArenaLose:_unInit()
	self.m_root = nil
    self.m_tData = nil
    self.m_tSettlementData = nil
    self.m_nCountdown = 0
    self.lineCnt = nil
    self.playerCon = nil
    self.isVideo = false

    self.winTeam = nil
    self.failTeam = nil
    self.teamInfo = nil
    self.winScore = 0           -- 英雄联赛专用（赢方的分数）
    self.failScore = 0          -- 英雄联赛专用（输方的分数）
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndArenaLose:createElement()
	local element = WZUISystem:getInstance():createElement("WndArenaLose")
	assert(element, "WndArenaLose create element failed!")
	self:_init()
	return element
end

--@brief    显示普通竞技场结算窗口
function WndArenaLose:showWindow(tData)
    local wnd = self:createElement()
    self.m_tData = tData
    self.isVideo = tData.isVideo
    self:_parseData()
    self:_initTeamInfo()
    WindowManager:addWindow(wnd, self, false)

    local eventData = {}
    local battleMode = WBattleGlobal:getCurrent().m_tMakePairOk.battleMode
    local battleChannel = WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle
    if battleChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_DZ then
        eventData = {fightType = 1,fightMode = 1,fightLevel = 1}
    elseif battleChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_LS then
        eventData = {fightType = 2,fightMode = 1,fightLevel = 1 }
    elseif battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_LD then
        eventData = {fightType = 4,fightMode = 1,fightLevel = 1 }
    end
    PostPlayerEvent:postEvent(PostPlayerEvent.event_playerfight, eventData)
end
-- -----------------------------------公有方法模块End----------------------------------------

-- -----------------------------------私有方法模块Begin--------------------------------------
--@brief    解析原始数据表，生成与界面对应的数据表
--@param    tData, 数据表, 包含数据如下：
-- battleId : 战斗id
-- firstKillPlayerId : 首杀玩家ID
-- winCamp : 胜利的一方
-- playerIds : 角色id
-- playerCamp : 玩家的阵营
-- shootRate : 命中率(放大100倍）
-- killCount : 杀人数(包括同队的)
-- integral : 获得积分
function WndArenaLose:_parseData()
    local nWinCamp = self.m_tData.winCamp
    local nFBId = self.m_tData.firstKillPlayerId
    local nMyId = WBattleGlobal:getCurrent().m_tMakePairOk.selfId--CacheCenter:getPlayerInfo().id
    if WBattleGlobal:getCurrent():isAudience() then
        nMyId = WBattleGlobal:getCurrent():getMyBattleId()
    end
    local nMyCamp = WBattleGlobal:getCurrent():getHeroWithId(nMyId):getCamp()

    local tTeammate = {} --队友
    local tEnemy = {} --敌人
    local winTeam,failTeam = {},{}
    for i=1, #self.m_tData.playerIds do
        local tTmp = {}
        tTmp.playerId = self.m_tData.playerIds[i]
        tTmp.playerCamp = self.m_tData.playerCamp[i]
        tTmp.shootRate = self.m_tData.shootRate[i]
        tTmp.killCount = self.m_tData.killCount[i]
        tTmp.integral = self.m_tData.integral[i]
        tTmp.serverId = self.m_tData.serverId[i]
        tTmp.tournamentLevel = self.m_tData.tournamentLevel[i]

        --从战斗数据中获取额外的玩家信息
        AddTableToTable(tTmp, self:_getPlayerInfoById(tTmp.playerId))

        --是否获胜
        tTmp.isWin = tTmp.playerCamp == nWinCamp and true or false

        --是否首杀(人数>2才出现)
        if #self.m_tData.playerIds > 2 then
            tTmp.isFirstSkill = tTmp.playerId == nFBId and true or false
        end
        
        if tTmp.playerId == nMyId then
            tTmp.type = 0 --自己
            table.insert(tTeammate, 1, tTmp)
        elseif tTmp.playerCamp == nMyCamp then
            tTmp.type = 1 --队友
            table.insert(tTeammate, tTmp)
        else
            tTmp.type = 2 --敌人
            table.insert(tEnemy, tTmp)
        end

        -- 赢的一方放一起，输的一方放一起，便于人物显示
        if tTmp.isWin then
            table.insert(winTeam,tTmp)
            table.insert(self.winTeam,tTmp)
            self.winScore = tTmp.integral
        else
            table.insert(failTeam,tTmp)
            table.insert(self.failTeam,tTmp)
            self.failScore = tTmp.integral
        end
    end
    
    self.m_tSettlementData = {}
    if WBattleGlobal:getCurrent().m_tMakePairOk.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_LD then --混战
        table.insert(self.m_tSettlementData, tTeammate[1])
        for i = 1, #tEnemy do
            table.insert(self.m_tSettlementData, tEnemy[i])
        end
    else --组队
        for i = 1, #tTeammate do
            table.insert(self.m_tSettlementData, tTeammate[i])
        end
        for i = 1, #tEnemy do
            table.insert(self.m_tSettlementData, tEnemy[i])
        end
    end

    self.playerCon = {}
    self.lineCnt = #winTeam
    -- 先放胜利的一方，后面放失败的一方
    for i = 1, #winTeam do
        table.insert(self.playerCon,winTeam[i])
    end

    for i = 1 ,#failTeam do
        table.insert(self.playerCon,failTeam[i])
    end
end

--@brief    根据玩家id获取玩家信息
--@param    nPlayerId,玩家id
--@return   #1, 玩家信息表
function WndArenaLose:_getPlayerInfoById(nPlayerId)
    local nIndex = 0
    local tMakePairOk = WBattleGlobal:getCurrent().m_tMakePairOk
    for i = 1, #tMakePairOk.playerId do
        if nPlayerId == tMakePairOk.playerId[i] then
            nIndex = i
            break
        end
    end

    if nIndex == 0 then
        for i = 1, #tMakePairOk.playerId do
            WZLog("----------WndArenaLose id info-----------",nPlayerId, tMakePairOk.playerId[i])
        end
    end

    WZLog("---------------WndArenaLose----------------",nPlayerId, nIndex)
    if nIndex > 0 then
        local data = {}
        data.playerName = tMakePairOk.playerName[nIndex]
        data.playerLevel = tMakePairOk.playerLevel[nIndex]
        data.sex = tMakePairOk.playerSex[nIndex]
        data.headId = tMakePairOk.headId[nIndex]
        data.faceId = tMakePairOk.faceId[nIndex]
        data.bodyId = tMakePairOk.bodyId[nIndex]
        data.weaponId = tMakePairOk.weaponId[nIndex]
        data.wingId = tMakePairOk.wingId[nIndex]
        data.petId = tMakePairOk.petId[nIndex]
        data.headColor = tMakePairOk.colour[nIndex]
        data.bodyColor = tMakePairOk.bodyColour[nIndex]

        -- 公会战专用
        data.guildName = tMakePairOk.playerCommunity[nIndex]    -- 公会战的名字
        data.guildIndex = tMakePairOk.teamId[nIndex] + 1    -- 1~3 表示公会战比赛的下标

        local hero = WBattleGlobal:getCurrent():getCharacterWithId(nPlayerId)
        local hp,maxHp = 0,1
        local per = 0
        if hero then
            hp = hero:getHp()
            maxHp = hero:getMaxHp()
            per = math.floor(hp*100/maxHp)
        end
        data.hpPer = per

--        for k,v in pairs(data) do
--            WZLog("------------get  tMakePairOk----------------",k,v)
--        end
        return data
    end
    return {}
end

-- {teamId,teamName,url}
function WndArenaLose:_initTeamInfo()
    local my = WBattleGlobal:getCurrent().m_tMakePairOk.m_tSelfTeamInfo
    local other = WBattleGlobal:getCurrent().m_tMakePairOk.m_tEnemyTeamInfo
    self.teamInfo = {other,my}
end
-------------------------------------私有方法模块End----------------------------------------