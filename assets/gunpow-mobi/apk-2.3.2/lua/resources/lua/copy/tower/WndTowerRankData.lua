--WndTowerRankData.lua
--@brief	WndTowerRank的数据模块
--@date		2015/04/28
--@author	xiaoyu_wu
-- modify   2015-7-3 binshao
--@modify   qixiang_xie
--@note		爬塔副本排名窗口

WndTowerRank = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndTowerRank:_init()
	self.m_root = nil	 	  			--场景根节点
    -- self.m_tData = nil                  --数据表
    self.m_bEnterAnimation = false      --是否正在播放进入动画
    self.m_nLoadListIndex = 0           --当前加载的页数
    self.m_oRankTableList = nil
    self.m_nTowerType = nil             --类型 0->默认 1->英雄塔 2->双人塔 3->组队世界boss 4->单人世界boss 5->夫妻争霸 6->羊了个羊
    -- self.m_tHistoryData = nil          --历史排名数据
    self.m_nTag = 1                    --1:每日排名；2：历史排名
    self.m_rType = 0

    self.m_tSaveData = {}
end


--@brief    反初始化表的成员变量
--@note     在退出场景时回调的onExit函数里面必须调用本函数
function WndTowerRank:_unInit()
    self.m_root = nil
    -- self.m_tData = nil
    self.m_bEnterAnimation = nil
    self.m_nLoadListCount = nil
    self.m_oRankTableList = nil
    self.m_nLoadListIndex = nil
    self.m_nTowerType = nil
    -- self.m_tHistoryData = nil          --历史排名数据
    self.m_nTag = nil
    self.m_rType = nil

    self.m_tSaveData = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndTowerRank:createElement()
	local element = WZUISystem:getInstance():createElement("WndTowerRank")
	assert(element, "WndTowerRank create element failed!")
	self:_init()
	return element
end

--@brief  返回根节点
function WndTowerRank:getRoot()
    return self.m_root
end

--@brief	显示窗口
--@note		调用此接口显示爬塔副本排行窗口
function WndTowerRank:showWindow(nWinType)
    --防止打开多个
    if self.m_root then return end

    local wndTowerRank = self:createElement()
    self.m_nTowerType = nWinType or 0
    WindowManager:addWindow(wndTowerRank,self, true,nil,nil, true)
end

--@brief	获取爬塔副本排名
--@param    topFloor : 我的最高记录层数
--@param    myRank : 我的排名
--@param    playerId : 玩家id
--@param    playerLevel : 玩家等级
--@param    playerSex : 玩家性别（0男，1女）
--@param    playerName : 玩家名称
--@param    playerGuild : 玩家公会
--@param    playerFloor : 玩家最高记录层数
--@param    headId : 玩家头部Id
--@param    faceId : 玩家脸部Id
--@note		由协议层回调
function WndTowerRank:getTowerRankOk(topFloor, myRank, playerId, playerLevel, playerSex, playerName, playerGuild, playerFloor, headId, faceId,vipLevel,headColors)
    local tData = {}
    tData.topFloor = topFloor
    tData.myRank = myRank

    tData.playerInfo = {}
    for i = 1, #playerId do
        local info = {}
        info.playerId = playerId[i]
        info.playerLevel = playerLevel[i]
        info.playerSex = playerSex[i]
        info.playerName = playerName[i]
        info.playerGuild = playerGuild[i]
        info.playerFloor = playerFloor[i]
        info.headId = headId[i]
        info.faceId = faceId[i]
        info.vipLevel = vipLevel[i]
        info.headColor = headColors[i]
        table.insert(tData.playerInfo,info)
    end

    self.m_tSaveData[self.m_nTag] = CopyTable(tData)
    
    self:_update(tData)
end

--@brief    获取爬塔副本历史排名
--@param    topFloor : 我的最高记录层数
--@param    myRank : 我的排名
--@param    playerId : 玩家id
--@param    playerLevel : 玩家等级
--@param    playerSex : 玩家性别（0男，1女）
--@param    playerName : 玩家名称
--@param    playerGuild : 玩家公会
--@param    playerFloor : 玩家最高记录层数
--@param    headId : 玩家头部Id
--@param    faceId : 玩家脸部Id
--@note     由协议层回调
function WndTowerRank:getTowerHistoryRankOk(rType, topFloor, myRank, playerId, playerLevel, playerSex, playerName, playerGuild, playerFloor, headId, faceId,vipLevel,headColors, serverId)
    self.m_rType = rType

    local tData = {}
    tData.topFloor = topFloor
    tData.myRank = myRank

    tData.playerInfo = {}
    for i = 1, #playerId do
        local info = {}
        info.playerId = playerId[i]
        info.playerLevel = playerLevel[i]
        info.playerSex = playerSex[i]
        info.playerName = playerName[i]
        info.playerGuild = playerGuild[i]
        info.playerFloor = playerFloor[i]
        info.headId = headId[i]
        info.faceId = faceId[i]
        info.vipLevel = vipLevel[i]
        info.headColor = headColors[i]
        info.serverId = serverId[i]
        table.insert(tData.playerInfo,info)
    end

    self.m_tSaveData[self.m_nTag] = CopyTable(tData)
    
    self:_update(tData)
end

--@brief    获取组队世界boss排名
function WndTowerRank:getTeamWorldbossRankOk(playerId, playerName, cross, hurt, headId, faceId, sex, headColor, vipLevel, level, playerNum, myRank, myHurt)
    local tData = {}

    tData.myHurt = myHurt
    tData.myRank = myRank

    tData.playerInfo = {}
    local nIndex = 1
    for i = 1, #playerNum do
        local info = {}
        info.rank = i
        info.hurt = tonumber(hurt[i])
        info.player = {}
        for j = 1, playerNum[i] do
            local tempPlayer = {}
            tempPlayer.playerId = playerId[nIndex]
            tempPlayer.playerName = playerName[nIndex]
            tempPlayer.headId = headId[nIndex]
            tempPlayer.faceId = faceId[nIndex]
            tempPlayer.playerSex = sex[nIndex]
            tempPlayer.headColor = headColor[nIndex]
            tempPlayer.vipLevel = vipLevel[nIndex]
            -- tempPlayer.playerLevel = level[nIndex]

            table.insert(info.player, tempPlayer)

            nIndex = nIndex + 1
        end
        table.insert(tData.playerInfo, info)
    end

    self.m_tSaveData[self.m_nTag] = CopyTable(tData)

    self:_update(tData)
end

--@brief    获取夫妻争霸boss排名
function WndTowerRank:getCoupleHegemonyRankOk(playerId, playerName, cross, hurt, headId, faceId, sex, headColor, vipLevel, level, playerNum, myRank, myHurt, curBossTotalHurt)
    local tData = {}
    tData.myHurt = myHurt
    tData.myRank = myRank

    tData.playerInfo = {}
    local nIndex = 1
    for i = 1, #playerNum do
        local info = {}
        info.rank = i
        info.hurt = tonumber(hurt[i])
        info.player = {}
        for j = 1, playerNum[i] do
            local tempPlayer = {}
            tempPlayer.playerId = playerId[nIndex]
            tempPlayer.playerName = playerName[nIndex]
            tempPlayer.headId = headId[nIndex]
            tempPlayer.faceId = faceId[nIndex]
            tempPlayer.playerSex = sex[nIndex]
            tempPlayer.headColor = headColor[nIndex]
            tempPlayer.vipLevel = vipLevel[nIndex]
            -- tempPlayer.playerLevel = level[nIndex]

            table.insert(info.player, tempPlayer)

            nIndex = nIndex + 1
        end
        table.insert(tData.playerInfo, info)
    end

    self.m_tSaveData[self.m_nTag] = CopyTable(tData)

    self:_update(tData)
end

--@brief    获取夫妻争霸boss排名
function WndTowerRank:getCoupleHegemonyHistoryRank(playerId, playerName, cross, hurt, headId, faceId, sex, headColor, vipLevel, level, playerNum, myRank)
    local tData = {}
    tData.myRank = myRank

    tData.playerInfo = {}
    local nIndex = 1
    for i = 1, #playerNum do
        local info = {}
        info.rank = i
        info.hurt = tonumber(hurt[i])
        info.player = {}
        for j = 1, playerNum[i] do
            local tempPlayer = {}
            tempPlayer.playerId = playerId[nIndex]
            tempPlayer.playerName = playerName[nIndex]
            tempPlayer.headId = headId[nIndex]
            tempPlayer.faceId = faceId[nIndex]
            tempPlayer.playerSex = sex[nIndex]
            tempPlayer.headColor = headColor[nIndex]
            tempPlayer.vipLevel = vipLevel[nIndex]
            -- tempPlayer.playerLevel = level[nIndex]

            table.insert(info.player, tempPlayer)

            nIndex = nIndex + 1
        end
        table.insert(tData.playerInfo, info)
    end

    self.m_tSaveData[self.m_nTag] = CopyTable(tData)

    self:_update(tData)
end


--@brief    获取单人世界boss排名
function WndTowerRank:updateWorldBossRankData()
    local tBossRoomInfo = SceneWorldBoss:getBossRoomInfo()

    local tData = {}
    tData.myHurt = tBossRoomInfo.hurt
    tData.myRank = tBossRoomInfo.hurt > 0 and tBossRoomInfo.myRank or 0

    tData.playerInfo = {}
    for i = 1, #tBossRoomInfo.rankPlayerId do
        local info = {}
        info.playerId = tBossRoomInfo.rankPlayerId[i]
        info.playerName = tBossRoomInfo.rankPlayerName[i]
        info.playerSex = tBossRoomInfo.sex[i]
        info.headId = tBossRoomInfo.headId[i]
        info.faceId = tBossRoomInfo.faceId[i]
        info.headColor = tBossRoomInfo.headColor[i]
        info.vipLevel = tBossRoomInfo.vipLevel[i]
        info.hurt = tBossRoomInfo.rankHurt[i]
        table.insert(tData.playerInfo,info)
    end

    self.m_tSaveData[self.m_nTag] = CopyTable(tData)

    self:_update(tData)
end

--@brief    获取羊了个羊排名
function WndTowerRank:getYangLeGeYangRankOk(gameType, rankingCode, myPoint, myRank, rewardConfig, playerIds, ranks, points, nicknames, headIds, headColors, faceIds, sexs, vipLevels, levels, bodyIds, windIds, title, guildName, serverId, season, settlementDate)
    local tData = {}
    tData.gameType = gameType
    tData.rankingCode = rankingCode
    tData.myPoint = myPoint
    tData.myRank = myRank
    tData.rewardConfig = rewardConfig
    tData.season = season
    tData.settlementDate = settlementDate

    tData.playerInfo = {}
    for i = 1, #playerIds do
        local info = {}
        info.playerId = playerIds[i]
        info.rank = ranks[i]
        info.point = points[i]
        info.nickname = nicknames[i]
        info.headId = headIds[i]
        info.headColor = headColors[i]
        info.faceId = faceIds[i]
        info.sex = sexs[i]
        info.vipLevel = vipLevels[i]
        info.level = levels[i]
        info.bodyId = bodyIds[i]
        info.windId = windIds[i]
        info.title = title[i]
        info.guildName = guildName[i]
        info.serverId = serverId[i]
        table.insert(tData.playerInfo,info)
    end

    self.m_tSaveData[self.m_nTag] = CopyTable(tData)
    
    self:_update(tData)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
