--WndHeroTowerData.lua
--@brief	WndHeroTower的数据模块
--@date		2020/03/27
--@author	XTX
--@note		英雄塔界面

WndHeroTower = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndHeroTower:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nMyCurHP = 0     --我当前的血量
    self.m_nMyCurSP = 0     --我当前的怒气
    self.m_nMyFloor = 0 
    self.m_nAllFloorNum = 10 --
    self.m_tResetCost = nil 
    self.m_tCurEnemyData = nil --当前可以挑战的玩家的数据
    self.m_tEnemyData = nil 
    self.m_tEnemyCell = nil 
    self.m_tEnemyElement = nil 
    self.m_nResetTimes = 0 
    self.m_bLoadMapFinish = false
    self.m_tSweepRewardNum = nil 
    self.m_tSweepRewardId = nil 
    self.m_tSweepRewardCount = nil 
    self.m_nLoadingTag = nil 
    self.m_nCurSelIndex = 1     --当前选中的英雄
    self.m_bIsExchangeEnemy = false     --是否正在切换对手
    self.m_nTouchBeginX = 0 
    self.m_nMoveDistance = 0 
    self.m_nTouchBeginTime = 0
    self.m_bIsPtInList = false 
    self.m_nLoadIndex = 1
    self.matchGoal = {}         --排行榜
end


--@brief    反初始化表的成员变量
--@note     在退出场景时回调的onExit函数里面必须调用本函数
function WndHeroTower:_unInit()
    self.m_root = nil
    self.m_nMyCurHP = nil     --我当前的血量
    self.m_nMyCurSP = nil     --我当前的怒气
    self.m_nMyFloor = nil 
    self.m_nAllFloorNum = nil 
    self.m_tResetCost = nil 
    self.m_tCurEnemyData = nil 
    self.m_tEnemyData = nil 
    self.m_tEnemyCell = nil 
    self.m_tEnemyElement = nil 
    self.m_nResetTimes = nil 
    self.m_bLoadMapFinish = nil 
    self.m_tSweepRewardNum = nil 
    self.m_tSweepRewardId = nil 
    self.m_tSweepRewardCount = nil 
    self.m_nLoadingTag = nil 
    self.m_nCurSelIndex = nil
    self.m_bIsExchangeEnemy = nil 
    self.m_nTouchBeginX = nil 
    self.m_nMoveDistance = nil 
    self.m_nTouchBeginTime = nil 
    self.m_bIsPtInList = nil 
    self.m_nLoadIndex = nil 
    self.matchGoal = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndHeroTower:createElement()
	if WndHeroTower.m_root ~= nil then
		WindowManager:removeWindow(WndHeroTower.m_root, WndHeroTower, true)
	end
	local element = WZUISystem:getInstance():createElement("WndHeroTower")
	assert(element, "WndHeroTower create element failed!")
	self:_init()
	return element
end


--@brief    获取英雄塔数据成功
function WndHeroTower:getHeroTowerDataOK(floor, hp, power, buffId, enemy, refreshTimes, resetTimes, sweepReward)
    -- body
    if self.m_root == nil then return end 
    MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingTag)
    WZLog("WndHeroTower:getHeroTowerDataOK", floor, hp, power, buffId, resetTimes, Serialize(sweepReward), Serialize(enemy))
    self.m_nMyCurHP = hp     --我当前的血量
    self.m_nMyCurSP = power     --我当前的怒气
    self.m_nMyFloor = floor 
    self.m_nCurSelIndex = self.m_nMyFloor + 1 <= self.m_nAllFloorNum and self.m_nMyFloor + 1 or self.m_nAllFloorNum
    self.m_nResetTimes = resetTimes 
    g_myHeroTowerBuffId = buffId 
    self.m_tSweepRewardNum = {}
    self.m_tSweepRewardId = {} 
    self.m_tSweepRewardCount = {} 
    for i = 1, #sweepReward do
        local ids, nums = SplitItemString(sweepReward[i])
        table.insert(self.m_tSweepRewardNum, #ids)
        for j = 1, #ids do
            table.insert(self.m_tSweepRewardId, tonumber(ids[j]))
            table.insert(self.m_tSweepRewardCount, tonumber(nums[j]))
        end
    end
    WZLog("WndHeroTower:getHeroTowerDataOK 000", Serialize(self.m_tSweepRewardNum), Serialize(self.m_tSweepRewardId), Serialize(self.m_tSweepRewardCount))
    if self.m_nMyFloor > self.m_nAllFloorNum then 
        self.m_nMyFloor = self.m_nAllFloorNum
    end

    self.m_tEnemyData = {} 
    self.m_nTowerMapCount = 0

    for i = 1, self.m_nAllFloorNum do
        self.m_tEnemyData[i] = {}
        self.m_tEnemyData[i].playerInfo = json.decode(enemy[i])
        self.m_tEnemyData[i].refreshTimes = refreshTimes[i]
        self.m_tEnemyData[i].state = 0
        if i <= self.m_nMyFloor then 
            self.m_tEnemyData[i].state = 1
        end
        for key, value in pairs(GDatatab_herotower_map) do
            if value.num == i then 
                self.m_tEnemyData[i].towerInfo = value
                self.m_nTowerMapCount = self.m_nTowerMapCount + 1
                break 
            end
        end
    end
    WZLog("WndHeroTower:getHeroTowerDataOK", Serialize(self.m_tEnemyData))

    if not self.m_bLoadMapFinish then
        self:_update()
        self:showHeroBuff()
    end
end

--@brief    刷新对手数据成功
function WndHeroTower:refreshEnemyDataOK(floor, enemy)
    -- body
    MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingTag)

    if self.m_tEnemyData[floor] then 
        self.m_tEnemyData[floor].playerInfo = json.decode(enemy)
        self.m_tEnemyData[floor].refreshTimes = self.m_tEnemyData[floor].refreshTimes + 1

        --刷新玩家形象
        if self.m_tEnemyCell[self.m_nMyFloor + 1] then 
            self.m_tEnemyCell[self.m_nMyFloor + 1]:resetData(self.m_tEnemyData[floor])
        end

        --更新刷新消耗
        self:_showUpdateEnemyCost()
    end
end

--@brief    重置玩家HP成功
function WndHeroTower:resetHeroHPSuccess(hp, power)
    -- body
    if self.m_root == nil then return end 
    MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingTag)

    self.m_nResetTimes = self.m_nResetTimes + 1
    self.m_nMyCurHP = hp     --我当前的血量
    self.m_nMyCurSP = power     --我当前的怒气

    local spineReset = GetElement(self.m_root, "spineReset_WndHeroTower", WZUISpine)
    if spineReset then 
        spineReset:setVisible(true)
        spineReset:play("wait", false)
        spineReset:enableSchedule("afterResetHero", 0.75)
    end
end

--@brief    更新人物缓存信息
function WndHeroTower:updatePlayerInfoData()
    if self.m_root == nil then return end 
    if not self.m_bLoadMapFinish then return end 
    WZLog("WndHeroTower:updatePlayerInfoData")
    self:_showPlayerInfo()
end

--@brief 显示扫荡结果
function WndHeroTower:showSweepResult(rewardNum, rewardId, rewardCount)
    WZLog("WndHeroTower:showSweepResult")
    if self.m_root == nil then return end
    WndSweepResult:showWindow({
        pointId = 0,
        rewardNum = rewardNum,
        rewardId = rewardId,
        rewardCount = rewardCount,
    }, 2, 1)
    
end

function WndHeroTower:getTowerHistoryRankOk(rType, topFloor, myRank, playerId, playerLevel, playerSex, playerName, playerGuild, playerFloor, headId, faceId, vipLevel, headColors, serverId)
    if rType ~= 0 then
        return
    end

    self.matchGoal = {}
    self.matchGoal.topFloor = topFloor
    self.matchGoal.myRank = myRank

    self.matchGoal.playerInfo = {}
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
        table.insert(self.matchGoal.playerInfo,info)
    end

    self:createMatchGoal()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    重置动画播放完成后，的处理
function WndHeroTower:afterResetHero(element)
    -- body
    element:disableSchedule()
    element:setVisible(false)

    self:_showPlayerHP()
end




-------------------------------------私有方法模块End----------------------------------------
