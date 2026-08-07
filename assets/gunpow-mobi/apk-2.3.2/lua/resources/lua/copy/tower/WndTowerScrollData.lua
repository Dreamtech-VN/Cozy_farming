--WndTowerScrollData.lua
--@brief	WndTowerScroll的数据模块
--@date		2015/06/25
--@author	xiaoyu_wu
--@modify   2015-7-2 binshao
--@note		爬塔副本主界面

WndTowerScroll = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndTowerScroll:_init()
	self.m_root = nil	 	  			--场景根节点
    self.Data = nil                     -- 存放配置表信息
    self.UserData = nil                 --用户数据信息表
    self.SweepState = 0                 --扫荡状态 0：未开始，1：进行中
    self.curFloor = 0                   --当前层数

    self.m_nSweepTime = 0               --剩余扫荡时间
    self.m_nMapStartFloor = 1           --地图开始的层数
    self.m_nCurPosIndex = 0             --玩家当前位置序号，计数包括关卡和关卡箱子，例如在第5关时位置为9，第5关奖励时位置为10
    self.m_tMoveDest = nil              --人物移动目的地
    self.m_tPlayerAni = nil             --玩家动画形象
    self.m_tMapBlocks = nil             --地图块节点列表
    self.tMapPt = {{568,0},{568,640},{568,1280},{568,1920},}
    self.tMiddlePt = {{568,0},{568,640},{568,1280},{568,1920},}
    self.m_conScrollMap = nil                 --地图容器
    self.m_conSweap = nil
    self.m_conFire = nil
    self.towerVipData = nil
    self.m_tFriendsData = nil            --好友爬塔信息
    self.m_tOLevels = {}                 --存放当前大地图里的所有小层对象
    self.m_tPlayerStartP = nil           --记录玩家所在层的对象
    self.m_tPlayerSweepCurLP = nil       --记录玩家正在扫荡的层的对象
    self.m_nPlayerCurIndex = nil
    self.m_tCollisionList = {}           --存放点击屏幕时需要做碰撞检测的控件
    self.m_nTouchStartX = nil
    self.m_nInitMapCount = 2             --记录加载几层地图(一层宽度为1136)
    self.m_nPlayerStartIndex = 0         --记录从玩家的第几层开始加载玩家信息
    self.m_nLoadCount = 0               --记录是否加载完成
    self.m_tEquipArmatures  = {}         --记录怪物骨骼动画列表
    self.m_tArmatures  = {}               --记录怪物骨骼动画列表
    self.m_nLevelSweepT = 30             --每个小层扫荡的时间
    self.m_bResert = false               --是否重置
    self.m_nLoadMapDataIndex = 1
    self.m_bSweepStart = false
    self.m_nPlayerCurPTX = 0             --记录玩家当前所在X轴上的位置
    self.m_bPlayerMoveOut = false        --记录玩家是否走到屏幕外面
    self.m_bLoadMapFinish = false        --记录是否加载完地图
    self.m_nTowerMapCount = 0
    self.m_tFloorInfo = nil
    self.m_oNextFloor = nil              --可以进行找到的下一层
    self.m_nCountFloor = nil             --爬塔副本共有多少层
    self.m_nLoadingTag = nil
    self.m_nCallengeCount = 0
    self.m_bChallenge = true
    self.m_nScreenSize = nil
    self.m_nWinSize = nil
    self.m_bFirstLoad = true
    self.m_oBeforeFloor = nil  --当前层的前一层
    self.m_bFirstPass = nil
    self.m_tempPlayerPs = {}
    self.m_tempNode = nil
    self.m_bStopSweepSuccess = false
    self.m_tSweepInfo = {}

    self.m_nTowerType = 0 --类型：0->默认；1->英雄塔
    self.m_tEnemyData = {}  --英雄塔被挑战玩家数据
    self.m_tHeroTowerBoxState = nil 
    self.m_nMyCurHP = 0     --我当前的血量
    self.m_nMyCurSP = 0     --我当前的怒气
    self.m_nMyFloor = 0     --我当前所在的层   初始0
    self.m_bIsReward = false --当前层奖励是否领取
    self.m_tClickEnemyData = nil 
    self.m_elementClick = nil 
    self.m_bIsShowBigBuff = true
    self.m_tBuyTimesCost = nil  --双人爬塔购买挑战次数消耗
    self.m_tSuitGuaiArmatures  = {}               --记录人形怪物骨骼动画列表
    self.m_nAddSpeedPrice = 2 --加速加个
    self.m_nBuyTimesNum = 0     --购买挑战次数的次数

    self.matchGoal = {}             --排行榜数据
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndTowerScroll:_unInit()
	self.m_root = nil
    
    self.Data = nil
    self.UserData = nil
    self.SweepState = 0
    self.m_nSweepTime = 0
    self.curFloor = 0
    self.m_nMapStartFloor = 1
    self.m_nCurPosIndex = 0
    self.m_tMoveDest = nil
    self.m_tPlayerAni = nil 
    self.m_tMapBlocks = nil
    
    self.m_batchNode = nil
    self.m_conScrollMap = nil
    self.m_conSweap = nil
    self.m_conFire = nil
    self.towerVipData = nil
    self.m_tFriendsData = nil
    self.m_tPlayerStartP = nil
    self.m_nPlayerCurIndex = nil
    self.m_tCollisionList = nil
    self.m_nTouchStartX = nil
    self.m_tOLevels = nil
    self.m_nInitMapCount  = nil
    self.m_tPlayerSweepCurLP = nil 
    self.m_nPlayerStartIndex = nil
    self.m_tEquipArmatures = nil
    self.m_tArmatures  = nil
    self.m_nLoadCount = nil
    self.m_bResert = nil
    self.m_nLevelSweepT = nil
    self.m_nLoadMapDataIndex = nil
    self.m_bSweepStart = nil
    self.m_nPlayerCurPTX= nil
    self.m_bPlayerMoveOut = nil
    self.m_bLoadMapFinish = nil
    self.m_nTowerMapCount = nil
    self.m_tFloorInfo = nil
    self.m_oNextFloor = nil
    self.m_nCountFloor = nil 
    self.m_nLoadingTag = nil
    self.m_nCallengeCount = nil       
    self.m_bChallenge = nil   
    self.m_nScreenSize = nil
    self.m_nWinSize = nil
    self.m_oBeforeFloor = nil
    self.m_bFirstLoad = false
    self.m_bFirstPass = nil
    self.m_tempPlayerPs = nil
    self.m_tempNode = nil
    self.m_bStopSweepSuccess = nil
    self.m_tSweepInfo = nil

    self.m_nTowerType = nil
    self.m_tEnemyData = nil 
    self.m_tHeroTowerBoxState = nil 
    self.m_nMyCurHP = nil     --我当前的血量
    self.m_nMyCurSP = nil     --我当前的怒气
    self.m_nMyFloor = nil 
    self.m_bIsReward = nil 
    self.m_tClickEnemyData = nil 
    self.m_elementClick = nil 
    self.m_bIsShowBigBuff = nil 
    self.m_tBuyTimesCost = nil 
    self.m_tSuitGuaiArmatures = nil 
    self.m_nAddSpeedPrice = nil
    self.m_nBuyTimesNum = nil 

    self.matchGoal = nil             --排行榜数据
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndTowerScroll:createElement()
	local element = WZUISystem:getInstance():createElement("WndTowerScroll")
	assert(element, "WndTowerScroll create element failed!")
	self:_init()
	return element
end

--@brief    外部接口
--@param    nTowerType : 0->默认；1->英雄塔；2->噩梦塔
function WndTowerScroll:showInterface(parentNode, nTowerType)
    -- body
    local wnd = WndTowerScroll:createElement()
    if wnd then 
        self.m_nTowerType = nTowerType or 0 
        parentNode:addChild(wnd, 0, 4)
    end
end

-- 获取爬塔副本信息
-- topFloor : 最高记录层数
-- nowFloor : 当前层数
-- dareTimes : 当天挑战次数
-- resetTimes : 可重置次数
-- myRank : 我的排名
-- isReward : 当前层数奖励是否领取
-- state : 扫荡状态 0：未开始，1进行中
-- remainTime : 剩余秒数
function WndTowerScroll:getTowerInfoOk(topFloor, nowFloor, dareTimes, resetTimes, myRank,isReward,state,remainTime,oneFloor)
    WZLog("WndTowerScroll:getTowerInfoOk === ",oneFloor,nowFloor)
    if nowFloor == 0 then  isReward = false  end
    if self.m_root == nil then
        return
    end
    self.UserData = {}
    self.UserData.topFloor = topFloor
    self.UserData.nowFloor = nowFloor
    self.UserData.dareTimes = dareTimes
    self.UserData.oneFloor = oneFloor
    self.UserData.resetTimes = resetTimes
    self.UserData.myRank = myRank
    self.UserData.isReward = isReward
    self.m_nCurPosIndex = nowFloor
    self.SweepState = state
    self.m_nSweepTime = remainTime
    self.m_nLoadCount = 1
    self.m_tMoveDest = nil
    self:stopSweepSchedule()
    if self.m_conScrollMap then
        self.m_conScrollMap:disableSchedule()
    end
    self.m_root:disableSchedule()
    if nowFloor == 0 then  self.UserData.isReward = false end

    WZLog("---------------topFloor-------------",topFloor)
    WZLog("---------------nowFloor-------------",nowFloor)
    WZLog("---------------dareTimes------------",dareTimes)
    WZLog("---------------resetTimes-----------",resetTimes)
    WZLog("---------------myRank---------------",myRank)
    WZLog("---------------isReward-------------",isReward)
    
    WZLog("---------------SweepState---------------",state)
    WZLog("---------------m_nSweepTime-------------",remainTime)
    if self.m_nSweepTime < 0 then  --如果服务器返回的扫荡时间少于0则设置扫荡时间为0
        self.m_nSweepTime = 0
    end

    if self.UserData.nowFloor > self.UserData.topFloor then --如果服务器返回的当前层大于最高层则把当前层设置为最高层
        --MsgBoxManager:showTipBox("error.......")
        self.UserData.nowFloor = self.UserData.topFloor
    end

    if self.SweepState == 1 then
        local floor = self:wetherCanSweep(self.UserData.nowFloor)
        if floor > 0 then
            local nCountSweepSecond = floor * self.m_nLevelSweepT
            nCountSweepSecond = nCountSweepSecond - self.m_nSweepTime
            local nCurSweepFloor = math.floor(nCountSweepSecond / self.m_nLevelSweepT)
            self.UserData.nowFloor = self.UserData.nowFloor + nCurSweepFloor
            g_bIsShowWndDressUp = false
            g_tTempItemForLaterShow = {}
        end
    end

    if not self.m_bLoadMapFinish or self.m_bResert then
        self.curFloor = self.UserData.nowFloor + 1
        if self.UserData.nowFloor >= #self.Data then
            self.curFloor = #self.Data
        end
        self.m_bLoadMapFinish = false
        if self.m_bResert then
            local imgAction= GetElement(self.m_root,"imgAction_WndTowerScroll",WZUIImage)
            imgAction:setVisible(true)
            local fadeOut = CCFadeOut:create(0.8)
            imgAction:runAction(fadeOut)
            self.m_bResert = false
        end
        self:_update()
        self.m_root:enableSchedule("scheduleMonitorMapLoad",0.1)
    else
        self:setRaidsTowerInfoOk(self.SweepState,self.m_nSweepTime)
    end
     --语言适配函数
    AdaptLanguage(self)
end

--@brief	返回扫荡状态
--@param    state : 扫荡状态 0：未开始，1：进行中
--@param    remainTime : 剩余秒数
--@note		由协议层回调
function WndTowerScroll:setRaidsTowerInfoOk(state, remainTime)
    WZLog("--------------cur raids info---------------",state,remainTime)
    if state == 1 and remainTime > 0 then --进行中时，开启定时器
        if self.m_nTowerType == 2 then 
            self.m_nLevelSweepT = 5
        else
            self.m_nLevelSweepT = 30
        end
        self:_updateSweepState()
        if self.m_bLoadMapFinish then
            self:checkPlayerStats()
            self:_changeCurSeatTreasureBox(self.m_tPlayerStartP)
        end
    elseif state == 1 and remainTime <= 0 then --已完成，发送完成的协议
        g_bIsShowWndDressUp = false
        g_tTempItemForLaterShow = {}
        if self.m_nTowerType == 2 then 
            ProtocolProcessorSingleMap:send_BOSSMAPROOM_TwoTowerOperation(3)
        else
            ProtocolProcessorSingleMap:send_SINGLEMAP_CompleteRaidsTower()
        end
    end
    
end

--@brief	扫荡成功
--@param    startFloor : 开始扫荡层数
--@param    endFloor : 结束扫荡层数
--@param    rewardId : 奖励物品id
--@param    rewardCount : 奖励物品数量
--@note		由协议层回调
function WndTowerScroll:completeRaidsTowerOk(startFloor, endFloor, rewardId, rewardCount)
    WZLog("WndTowerScroll:completeRaidsTowerOk =",startFloor,endFloor)
    if self.m_root == nil then return end
    self.SweepState = 0
    self.m_nSweepTime = 0
    self:_stopFightAnim()

    WZLog("WndTowerScroll:completeRaidsTowerOk 00")
    if self.m_conSweap then
       self.m_conSweap:disableSchedule()
    end

    if self.m_conScrollMap then
        self.m_conScrollMap:disableSchedule()
    end
   
    if self.UserData then
        self.UserData.nowFloor = endFloor
        self.m_root:disableSchedule()
    end
    WZLog("WndTowerScroll:completeRaidsTowerOk 11")
    self.m_bResert = true
    self.m_bStopSweepSuccess = true
    self.m_tSweepInfo={startFloor=startFloor,endFloor=endFloor,rewardId=rewardId,rewardCount=rewardCount}
    WZLog("WndTowerScroll:completeRaidsTowerOk 22")
end

--@brief  扫荡成功
function WndTowerScroll:showSweepSuccess()
    WZLog("WndTowerScroll:showSweepSuccess")
    if self.m_bStopSweepSuccess and self.m_tSweepInfo.startFloor ~= nil then
        WndTowerSweepResult:showWindow()
        WndTowerSweepResult:setData(self.m_tSweepInfo.startFloor, self.m_tSweepInfo.endFloor, self.m_tSweepInfo.rewardId, self.m_tSweepInfo.rewardCount)
        self:_updateSweepState()   
    end
    self.m_bStopSweepSuccess = false
    self.m_tSweepInfo = {}
end

--@brief	根据层数获取名称
--@param    nFloor,层数
--@return   #1,名称
function WndTowerScroll:getNameByFloor(nFloor)
    if self.Data == nil then
        self:_initData()
    end
    local tFloorData = self.Data[nFloor]
    if tFloorData then
        return tFloorData.name
    end
    return LocalStrings.NONE
end

--@brief	更新数据
function WndTowerScroll:updateData()
    if self.m_root == nil then
        return
    end
    ProtocolProcessorSingleMap:send_SINGLEMAP_GetTowerInfo()
    ProtocolProcessorSingleMap:send_SINGLEMAP_GetRaidsTowerInfo()
end

--@brief  领取本层奖励成功
function WndTowerScroll:GetTowerRewardOk()
    WZLog("---------------------recevie tower reward-------------------- = ",self.UserData.nowFloor)
    MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingTag)
    if self.UserData == nil then return end
    self.UserData.isReward = true

    local vnId = {}
    local vnNum = {} 

    local floor_reward = nil
    if not self:isFristPass(self.UserData.nowFloor) then
        floor_reward = self.Data[self.UserData.nowFloor].floor_reward
    else
        floor_reward = self.Data[self.UserData.nowFloor].one_reward
    end
    for i,v in ipairs(floor_reward) do
        for j,k in ipairs(v) do
            if j == 1 then
                table.insert(vnId,k)
            else
                table.insert(vnNum,k)
            end
        end
    end   
    local towerInfo = {isReward = true}
    CacheCenter:updateTowerCopyData(towerInfo)
    self:_changeYellowArrow()
   
    WndRewardShow:showById(vnId,vnNum)
    pushEquipInList()
    g_bIsShowWndDressUp = true
end

--@brief 获取好友爬塔信息
--@param playerId : 好友id
--@param playerName : 好友名称
--@param headId : 玩家头部Id
--@param faceId : 玩家脸部Id
--@param topFloor : 最高记录层数
--@param sex : 玩家性别
function WndTowerScroll:getFriendsTowerInfoOk(playerId, playerName, headId, faceId, topFloor,sex,headColors)
    WZLog("WndTowerScroll:getFriendsTowerInfoOk")
    self.m_tFriendsData = {playerId=playerId,playerName=playerName,headId=headId,faceId=faceId,topFloor=topFloor,sex=sex,headColor=headColors}
    local towerCacheInfo =  CacheCenter:getTowerCopyData()
    if towerCacheInfo then
        if towerCacheInfo.state == 1 or (towerCacheInfo.remainTime ~= nil and towerCacheInfo.remainTime > 0 )then
            ProtocolProcessorSingleMap:send_SINGLEMAP_GetTowerInfo()
        else
            SceneCopy:closeLoading()
            self:getTowerInfoOk(towerCacheInfo.topFloor, towerCacheInfo.nowFloor, towerCacheInfo.dareTimes, towerCacheInfo.resetTimes, towerCacheInfo.myRank,towerCacheInfo.isReward,towerCacheInfo.state,towerCacheInfo.remainTime,towerCacheInfo.oneFloor) 
        end
    end
end

--@breif  爬塔副本缓存信息更新
function WndTowerScroll:updateData2()
    WZLog("WndTowerScroll:updateData")
    local towerInfo =  CacheCenter:getTowerCopyData()
    if WndTowerScroll.m_root ~= nil then
        WndTowerScroll:getTowerInfoOk(towerInfo.topFloor, towerInfo.nowFloor, towerInfo.dareTimes, towerInfo.resetTimes, towerInfo.myRank,towerInfo.isReward,towerInfo.state,towerInfo.remainTime,towerInfo.oneFloor)
    end
end

--@brief 创建宝箱
function WndTowerScroll:createTreasureBox(icon )
    if icon == nil then return nil end
    local img = WZUIImage:create()
    img:setUseOriginSize(true)
    img:setAnchorPoint(GlobalMethod:ccp(0,0))
    img:setRelativePosition(GlobalMethod:ccp(0,0))
    img:setFile("ui/common/" .. icon)
    img:setTag(1234)
    return img
end

--@brief 创建气泡窗
function WndTowerScroll:createBubbleWindow(conNode)
    -- body
    local itemId = self.m_tFloorInfo.display
    local key = "id_"..itemId
    if GDatatab_item[key] then
        local name = GDatatab_item[key].name
        local path = GDatatab_item[key].icon
        local quality = GDatatab_item[key].quality
        local num = 1
        local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key])}
        local celElement,tLuaObj = CellGoodItem:createElement()
        tLuaObj:setCellGoodItem(itemInfo, 15)
        celElement:setScale(0.6)
        celElement:setRelativePosition(GlobalMethod:ccp(0.5,0.55))
        conNode:addChild(celElement)
        tLuaObj:setItemClickFun(WndTowerScroll,self.onItemClick)
    end
end

--@brief    点击物品弹出对应的tips
function WndTowerScroll:onItemClick(tCell,tag,tData)
    if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tCell.m_root,WndTowerScroll.m_root,1,tData,false,nil,true)
end

--@brief  创建已打开过的宝箱
function WndTowerScroll:createOpenTreauseBox(icon)
    if icon == nil then return end
    local img = WZUIImage:create()
    img:setUseOriginSize(true)
    img:setAnchorPoint(GlobalMethod:ccp(0,0))
    img:setRelativePosition(GlobalMethod:ccp(0,0))
    if icon == "common_icon_zi1.png" then
        img:setFile("ui/common/common_icon_zi3.png")
    elseif icon == "common_icon_lan1.png" then
        img:setFile("ui/common/common_icon_lan3.png")
    elseif icon == "common_icon_huang1.png" then
        img:setFile("ui/common/common_icon_huang3.png")
    end
    
    img:setTag(1234)
    return img
end


--@brief  是否是第一次通关
function WndTowerScroll:isFristPass(level)
    WZLog("WndTowerScroll:isFristPass")
    if level > self.UserData.oneFloor then
        return true
    end
    return false
end

--@brief    获取英雄塔数据成功
function WndTowerScroll:getHeroTowerDataOK(floor, hp, power, buffId, rewardState, enemy, refreshTimes)
    -- body
    if self.m_root == nil then return end 
    MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingTag)

    self.m_tHeroTowerBoxState = rewardState 
    self.m_nMyCurHP = hp     --我当前的血量
    self.m_nMyCurSP = power     --我当前的怒气
    self.m_nMyFloor = floor 
    g_myHeroTowerBuffId = buffId 
    if self.m_nMyFloor > 7 then 
        self.m_nMyFloor = 7
    end

    self.m_tEnemyData = {} 
    self.m_nTowerMapCount = 0

    for i = 1, 7 do
        self.m_tEnemyData[i] = {}
        self.m_tEnemyData[i].playerInfo = json.decode(enemy[i])--{playerId = 19564 + i, playerName = "不用理会" .. i, headId = 4860, faceId = 4310, bodyId = 4550, sex = 0, wingId = 4751, headColor = 0, bodyColor = 0, fighting = 10000}
        self.m_tEnemyData[i].refreshTimes = refreshTimes[i]
        for key, value in pairs(GDatatab_herotower_map) do
            if value.num == i then 
                self.m_tEnemyData[i].towerInfo = value
                self.m_nTowerMapCount = self.m_nTowerMapCount + 1
                break 
            end
        end
    end
    WZLog("WndTowerScroll:getHeroTowerDataOK", floor, hp, power, buffId, Serialize(rewardState), Serialize(self.m_tEnemyData))

    if self.m_nMyFloor > 0 and self.m_tHeroTowerBoxState[self.m_nMyFloor] == 2 then 
        self.m_bIsReward = true
    end
    self.m_nCountFloor = #self.m_tEnemyData
    if not self.m_bLoadMapFinish then
        self:_updateHero()
        self.m_root:enableSchedule("scheduleMonitorMapLoad",0.1)
        self:showHeroBuff()
    end
end

--@brief    刷新对手数据成功
function WndTowerScroll:refreshEnemyDataOK(floor, enemy)
    -- body
    MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingTag)

    if self.m_tEnemyData[floor] then 
        self.m_tEnemyData[floor].playerInfo = json.decode(enemy)
        self.m_tEnemyData[floor].refreshTimes = self.m_tEnemyData[floor].refreshTimes + 1
        WndTips:resetData(self.m_tEnemyData[floor])
        --刷新玩家形象
        if self.m_elementClick then 
            local parElement = WZUIContainer:luaTo(self.m_elementClick:getParent())
            local conPlayerFigure = GetElement(parElement,"conPlayerFigure_WndTowerScroll",WZUIContainer)
            local monsterCon = conPlayerFigure:getChildByTag(1144)
            local playerNode = monsterCon:getChildByTag(12345)
            if playerNode then 
                playerNode:removeFromParentAndCleanup(true)
            end
            local playerInfo = self.m_tEnemyData[floor].playerInfo
            local conPlayer = self:_createPlayer(playerInfo)
            conPlayer:setScale(0.5)
            self:_flipX(parElement, conPlayer:getAnimNode())
            monsterCon:addChild(conPlayer:getAnimNode())
        end
    end
end

--@brief    获取英雄塔宝箱奖励成功
function WndTowerScroll:getHeroTowerBoxRewardOK(floor, itemId, itemNum)
    -- body
    WZLog("WndTowerScroll:getHeroTowerBoxRewardOK", Serialize(itemId), Serialize(itemNum))
    MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingTag)

    local vnId = {}
    local vnNum = {} 

    self.m_tHeroTowerBoxState[floor] = 2
    if self.m_nMyFloor > 0 and self.m_tHeroTowerBoxState[self.m_nMyFloor] == 2 then 
        self.m_bIsReward = true
    end

    for j = 1, #itemId do
        table.insert(vnId, itemId[j])
        table.insert(vnNum, itemNum[j])
    end  

    self:_changeYellowArrow()
   
    WndRewardShow:showById(vnId,vnNum)
    pushEquipInList()
    g_bIsShowWndDressUp = true
end

-- 获取噩梦爬塔副本信息
-- topFloor : 最高记录层数
-- nowFloor : 当前层数
-- dareTimes : 当天挑战次数
-- resetTimes : 可重置次数
-- myRank : 我的排名
-- isReward : 当前层数奖励是否领取
-- state : 扫荡状态 0：未开始，1进行中
-- remainTime : 剩余秒数
-- buyTimesNum : 购买挑战次数的次数
function WndTowerScroll:getDoubleTowerInfoOk(topFloor, nowFloor, dareTimes, helpTimes, state, remainTime, floorState, buyTimesNum)
    WZLog("WndTowerScroll:getDoubleTowerInfoOk === ", nowFloor, Serialize(floorState))
    if self.m_root == nil then
        return
    end
    self.UserData = {}
    self.UserData.topFloor = topFloor
    self.UserData.nowFloor = nowFloor
    self.UserData.dareTimes = dareTimes
    self.UserData.helpTimes = helpTimes
    self.UserData.floorState = floorState
    self.m_nCurPosIndex = nowFloor
    self.SweepState = state
    self.m_nSweepTime = remainTime
    self.m_nLoadCount = 1
    self.m_tMoveDest = nil
    self.m_nBuyTimesNum = buyTimesNum

    self:stopSweepSchedule()
    if self.m_conScrollMap then
        self.m_conScrollMap:disableSchedule()
    end
    self.m_root:disableSchedule()
    self.UserData.isReward = false 

    WZLog("---------------getDoubleTowerInfoOk topFloor-------------",topFloor)
    WZLog("---------------getDoubleTowerInfoOk nowFloor-------------",nowFloor)
    WZLog("---------------getDoubleTowerInfoOk dareTimes------------",dareTimes)
    WZLog("---------------getDoubleTowerInfoOk helpTimes-----------",helpTimes)
    
    WZLog("---------------getDoubleTowerInfoOk SweepState---------------",state)
    WZLog("---------------getDoubleTowerInfoOk m_nSweepTime-------------",remainTime, buyTimesNum)
    if self.m_nSweepTime < 0 then  --如果服务器返回的扫荡时间少于0则设置扫荡时间为0
        self.m_nSweepTime = 0
    end

    if self.UserData.nowFloor > self.UserData.topFloor then --如果服务器返回的当前层大于最高层则把当前层设置为最高层
        self.UserData.nowFloor = self.UserData.topFloor
    end

    if self.SweepState == 1 then
        local floor = self:wetherCanSweep(self.UserData.nowFloor)
        if floor > 0 then
            local nCountSweepSecond = floor * self.m_nLevelSweepT
            nCountSweepSecond = nCountSweepSecond - self.m_nSweepTime
            local nCurSweepFloor = math.floor(nCountSweepSecond / self.m_nLevelSweepT)
            self.UserData.nowFloor = self.UserData.nowFloor + nCurSweepFloor
            g_bIsShowWndDressUp = false
            g_tTempItemForLaterShow = {}
        end
    end

    if not self.m_bLoadMapFinish or self.m_bResert then
        self.curFloor = self.UserData.nowFloor + 1
        if self.UserData.nowFloor >= #self.Data then
            self.curFloor = #self.Data
        end
        self.m_bLoadMapFinish = false
        if self.m_bResert then
            local imgAction= GetElement(self.m_root,"imgAction_WndTowerScroll",WZUIImage)
            imgAction:setVisible(true)
            local fadeOut = CCFadeOut:create(0.8)
            imgAction:runAction(fadeOut)
            self.m_bResert = false
        end
        self:_update()
        self.m_root:enableSchedule("scheduleMonitorMapLoad",0.1)
    else
        self:_initMoreLanguage()
        self:setRaidsTowerInfoOk(self.SweepState,self.m_nSweepTime)
    end
     --语言适配函数
    AdaptLanguage(self)
end

--@breif  爬塔副本缓存信息更新
function WndTowerScroll:updateDoubleTowerData()
    WZLog("WndTowerScroll:updateDoubleTowerData")
    local towerInfo =  CacheCenter:getDoubleTowerCopyData()
    if WndTowerScroll.m_root ~= nil then
        WndTowerScroll:getDoubleTowerInfoOk(towerInfo.topFloor, towerInfo.nowFloor, towerInfo.dareTimes, towerInfo.helpTimes, towerInfo.state, towerInfo.remainTime, towerInfo.floorState, towerInfo.buyTimesNum)
    end
end

--@breif  获得排行榜数据
function WndTowerScroll:getTowerRankOk(topFloor, myRank, playerId, playerLevel, playerSex, playerName, playerGuild, playerFloor, headId, faceId, vipLevel, headColors)
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
        table.insert(self.matchGoal.playerInfo,info)
    end

    self:createMatchGoal()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	初始化数据表
function WndTowerScroll:_initData()
    self.Data = {}
    self.m_nTowerMapCount = 0
    if self.m_nTowerType == 2 then 
        for i,v in pairs(GDatatab_grouptower_map) do
            self.m_nTowerMapCount = self.m_nTowerMapCount + 1
            self.Data[v.floor_num] = v
        end
        self.m_nCallengeCount = tonumber(CacheCenter:getGameParam().doublePagodaTimes)
    else
        for i,v in pairs(GDatatab_tower_map) do
            self.m_nTowerMapCount = self.m_nTowerMapCount + 1
            self.Data[v.floor_num] = v
        end
        self.m_nCallengeCount = self.Data[1].pass_times
    end
    WZLog("WndTowerScroll:_initData", self.m_nTowerType, type(self.m_nCallengeCount))
    self.m_nCountFloor = #self.Data
    self:_initTowerVipData()
end

--@brief 初始化本地爬塔VIP信息
function WndTowerScroll:_initTowerVipData()
    self.towerVipData = {}
    for k ,v in pairs(GDatatab_vip_restriction) do
        if v.type == 5 then
           table.insert(self.towerVipData,v)
        end
    end
end

--@brief 获取对应VIP的爬塔信息
function WndTowerScroll:_getVipTowerData()
    local playerInfo = CacheCenter:getPlayerInfo()
    local vipLevel = playerInfo.vipLevel
    local vipData = nil
    local count = 0
    for k,v in pairs(self.towerVipData) do
        if vipLevel >= v.vip_level  then
            if v.count > count then
                count = v.count
                vipData = v
            end
        end
    end
    return vipData
end

--@brief  获取爬塔副本重置花费
--@param  resertCount : 重置次数
function WndTowerScroll:_getVipTowerCost(resertCount)
    for k,v in pairs(self.towerVipData) do
        if v.count  == resertCount then
            return v.cost
        end
    end
end

-- 获取剩余挑战的次数
function WndTowerScroll:_getFightNum()
    return self.UserData.dareTimes
end

-- 玩家走到目的地后将要执行的操作
function WndTowerScroll:_moveDestWillDo()
    WZLog("WndTowerScroll:_moveDestWillDo ")
    --英雄塔处理
    if self.m_nTowerType == 1 then 
        self:_moveDestWillDoHeroTower()
        return 
    end
    --普通怪物爬塔处理
    if self.m_oNextFloor == nil then
        return
    end

    if not self.m_bChallenge then
        self:_playerFlipX()
        self.m_bChallenge = true
        local ppoint = nil
        if self.SweepState == 1 then
            ppoint = self:nextFloorPs(self.m_oNextFloor)
        else
            ppoint = self:nextFloorPs(self.m_tPlayerStartP)
        end
        self:_playerMoveTo(nIndex,ppoint,true)
        return
    end

    local conPlayerFigure = GetElement(self.m_oNextFloor,"conPlayerFigure_WndTowerScroll",WZUIContainer):getChildByTag(1144):getChildByTag(12345) 
    -- 位于起点，或者奖励已经领取，则到目的地后将进入战斗
    if conPlayerFigure then
        if self.SweepState ~= 1 then  --不处于扫荡状态才能进行战斗
            self.m_nLoadingTag = MsgBoxManager:showLoadingBox()
            if CacheCenter:getPlayerInfo() then
                CacheCenter.m_nPlayerLevel = CacheCenter:getPlayerInfo().level
                CacheCenter.m_nPlayerExp = CacheCenter:getPlayerInfo().exp
            end

            -- 处理战斗时默认皮肤大招id获取不到的问题,做一层保险
            if GlobalGame.g_saveBigSkillType == 2 and (CacheCenter.m_nDefaultShapeBigSkill == nil or CacheCenter.m_nDefaultShapeBigSkill <= 0) then
                ProtocolProcessorWndSkillProp:send_PLAYER_GetShapeSkillList(2)
            end
            ProtocolProcessorSingleMap:send_SINGLEMAP_StartChallenge(self.Data[self.curFloor].id, COPYTYPE_TOWER)
         
            g_copyST = os.time()
        else
            self:_playFightAnim(math.floor(self.m_nSweepTime % self.m_nLevelSweepT))
        end
        
    else    -- 奖励没有领取则领取奖励
        self.UserData.isReward = true
        self:_playerFlipX()

        if self.SweepState ~= 1 then --处于扫荡状态不显示获奖的礼品框
            self.m_nLoadingTag = MsgBoxManager:showLoadingBox()
            g_bIsShowWndDressUp = false
            g_tTempItemForLaterShow = {}
            ProtocolProcessorSingleMap:send_SINGLEMAP_GetTowerReward()
        else
            --玩家移动到超过的指定范围不做任何操作
            if self.m_bPlayerMoveOut then return end
            if self.m_nSweepTime > 0 then
                self.m_oBeforeFloor =  self.m_tPlayerStartP 
                self.m_tPlayerStartP = self.m_oNextFloor
                local nextFloor = self:findNextFloor()
                self.m_oNextFloor = nextFloor
                if nextFloor then
                    self.m_tPlayerSweepCurLP = nextFloor
                    self:sweepingAction(nextFloor)
                end
            end
        end
    end
end

--@brief    玩家走到目的地后将要执行的操作(英雄塔)
function WndTowerScroll:_moveDestWillDoHeroTower()
    WZLog("WndTowerScroll:_moveDestWillDoHeroTower ")
    if self.m_oNextFloor == nil then
        return
    end

    if not self.m_bChallenge then
        self:_playerFlipX()
        self.m_bChallenge = true
        local ppoint = nil
        if self.SweepState == 1 then
            ppoint = self:nextFloorPs(self.m_oNextFloor)
        else
            ppoint = self:nextFloorPs(self.m_tPlayerStartP)
        end
        self:_playerMoveTo(nIndex,ppoint,true)
        return
    end

    local conPlayerFigure = GetElement(self.m_oNextFloor,"conPlayerFigure_WndTowerScroll",WZUIContainer):getChildByTag(1144):getChildByTag(12345) 
    -- 位于起点，或者奖励已经领取，则到目的地后将进入战斗
    if conPlayerFigure then
        self.m_nLoadingTag = MsgBoxManager:showLoadingBox()
        if CacheCenter:getPlayerInfo() then
            CacheCenter.m_nPlayerLevel = CacheCenter:getPlayerInfo().level
            CacheCenter.m_nPlayerExp = CacheCenter:getPlayerInfo().exp
        end

        SceneCity:updateRedDotBuilding("heroTower", false)
        ProtocolProcessorSceneCity:send_PLAYER_CancelRedDot(247)
        GlobalGame.g_tRedPointList.heroTower = false

        -- 处理战斗时默认皮肤大招id获取不到的问题,做一层保险
        if GlobalGame.g_saveBigSkillType == 2 and (CacheCenter.m_nDefaultShapeBigSkill == nil or CacheCenter.m_nDefaultShapeBigSkill <= 0) then
            ProtocolProcessorWndSkillProp:send_PLAYER_GetShapeSkillList(2)
        end
        ProtocolProcessorSingleMap:send_SINGLEMAP_StartChallenge(self.m_tEnemyData[self.m_nMyFloor + 1].towerInfo.id, COPYTYPE_HEROTOWER)
     
        g_copyST = os.time()
    else    -- 奖励没有领取则领取奖励
        self:_playerFlipX()

        self.m_nLoadingTag = MsgBoxManager:showLoadingBox()
        g_bIsShowWndDressUp = false
        g_tTempItemForLaterShow = {}
--        ProtocolProcessorSingleMap:send_MAP_ReceiveHeroTowerReward(self.m_nMyFloor)
    end
end

--@brief  改变箭头指引
function WndTowerScroll:_changeYellowArrow()
    WZLog("WndTowerScroll:_changeYellowArrow")
    local conPlayerFigure = GetElement(self.m_tPlayerStartP,"conPlayerFigure_WndTowerScroll",WZUIContainer)
    local rewardImage = conPlayerFigure:getChildByTag(1234)
    local armBonusBox = GetElement(self.m_tPlayerStartP,"armBonusBox_WndTowerScroll",WZArmature)
    if rewardImage then
        rewardImage:setVisible(false)
        local conBubble = GetElement(self.m_tPlayerStartP,"conBubbleParent_WndTowerScroll",WZUIContainer)
        conBubble:setVisible(false)
    end

    if armBonusBox then
       self:controlBounsBoxStatus(self.m_tPlayerStartP,false)
    end
    
    GetElement(self.m_tPlayerStartP,"imgArrow_WndTowerScroll",WZUIImage):setVisible(false)
    if self.m_nPlayerStartIndex >=200 then
        --return
    end
    local nextFloor = self:findNextFloor()
    self.m_oNextFloor = nextFloor
    if nextFloor then
        GetElement(nextFloor,"imgArrow_WndTowerScroll",WZUIImage):setVisible(true)
        local isBounsBox = nextFloor:getChildByTag(1234)
        if isBounsBox then
            local armBonus = GetElement(nextFloor,"armBonusBox_WndTowerScroll",WZArmature)
            armBonus:setVisible(true)
        end
    end
end

--@brief  扫荡状态不显示黄色箭头指引
function WndTowerScroll:disableYellowArrow(nextFloor)
    local imgArrow = GetElement(nextFloor,"imgArrow_WndTowerScroll",WZUIImage)
    if imgArrow:isVisible() then
       imgArrow:setVisible(false)
    end
end

--@brief  查找当前关的下一关地图层
function WndTowerScroll:findNextFloor()
    WZLog("WndTowerScroll:findNextFloor")
    for i,v in ipairs(self.m_tOLevels) do
        for k,j in ipairs(v) do
            if k == 2 then
                if self.m_tPlayerStartP == j then
                    if i >= #self.m_tOLevels then
                        return nil
                    end
                
                    local nextFloor = self.m_tOLevels[i+1][2]
                    local  conPlayerFigure = nextFloor:getChildElement("conPlayerFigure_WndTowerScroll")
                    conPlayerFigure = WZUIContainer:luaTo(conPlayerFigure)
                    if conPlayerFigure:getChildByTag(1234) or conPlayerFigure:getChildByTag(1144):getChildByTag(12345) then
                        return nextFloor
                    else
                        nextFloor = self.m_tOLevels[i+2][2]
                        return nextFloor
                    end
                end
            end
        end
    end
    return nil
end

--@brief  查找当前关的前一关地图层，不管有没有宝箱或者怪物
function WndTowerScroll:findPreviousFloor(node)
    for i,v in ipairs(self.m_tOLevels) do
        for k,j in ipairs(v) do
            if k == 2 then
                if node == j then
                    local previousFloor = self.m_tOLevels[i-1][2]
                    return previousFloor
                end
            end
        end
    end
    return nil
end

--@brief  查找当前关的前一关地图层，不管有没有宝箱或者怪物
function WndTowerScroll:findNextFloor2(curNode)
    WZLog("WndTowerScroll:findNextFloor2")
    local nLevelCount = #self.m_tOLevels
    for i,v in ipairs(self.m_tOLevels) do
        for k,j in ipairs(v) do
            if k == 2 then
                if curNode == j then
                    if i >= nLevelCount then
                        return nil
                    end
                    local previousFloor = self.m_tOLevels[i+1][2]
                    return previousFloor
                end
            end
        end
    end
    return nil
end

function WndTowerScroll:setSweepSuccess()
    self.UserData.nowFloor = self.UserData.nowFloor + 1
    self.curFloor = self.curFloor + 1
    self.UserData.isReward = false
end

--@brief 开启扫荡定时器
function WndTowerScroll:startSweepSchedule()
   if self.m_nSweepTime <= 0 then return end
   local conSweap = GetElement(self.m_root,"conSweap_WndTowerScroll",WZUIContainer)
   conSweap:enableSchedule("scheduleSweepCountdown", 1)
   self.m_conSweap = conSweap
end

--@brief 暂停扫荡定时器
function WndTowerScroll:stopSweepSchedule()
    local conSweap = GetElement(self.m_root,"conSweap_WndTowerScroll",WZUIContainer)
    if conSweap ~= nil then
        conSweap:disableSchedule()
        self.m_conSweap = conSweap
    end
end

--@breif  初始化地图位置
function WndTowerScroll:resertMapPos()
    local movMap = GetElement(self.m_root,"movMap_WndTowerScroll",WZUIMoveContainer)
    movMap:UpdateInsidePosition()

    local moveMaxY = movMap:getMaxPosition().y
    local moveMinY = movMap:getMinPosition().y

    local moveMaxX = movMap:getMaxPosition().x
    local moveMinX = movMap:getMinPosition().x

    
    movMap:getMoveElement():setPositionY(moveMaxY)
    movMap:getMoveElement():setPositionX((moveMaxX+moveMinX)/2)
    movMap:UpdateInsidePosition()
end

--@brief  返回下层坐标
function WndTowerScroll:nextFloorPs(node)
    if not node then
        return
    end
    local btnLevel = GetElement(node ,"btnLevel_WndTowerScroll",WZUIButton)
    local ppoint = self:findElementWorldPT(btnLevel)
    return ppoint
end

--@brief    获取是否可以扫荡
function WndTowerScroll:wetherCanSweep(nowFloor)
    -- body
    local perfectFloor = 0
    if self.m_nTowerType == 2 then 
        local floorState = CacheCenter:getDoubleTowerCopyData().floorState

        for i = nowFloor + 1, #floorState do
            if floorState[i] and floorState[i] == 7 then 
                perfectFloor = perfectFloor + 1
            else
                break 
            end
        end
    else
        perfectFloor = self.UserData.topFloor - nowFloor
    end

    return perfectFloor
end

--@brief    获取数据
function WndTowerScroll:getUserData()
    -- body
    return self.UserData
end

--@brief    获取当前VIP限购数据
function WndTowerScroll:_getVipLimitDataTwo()
    -- body
    local tTempList = {}
    local nCurVip = CacheCenter:getPlayerInfo().vipLevel
    for key, value in pairs(GDatatab_vip_restriction) do
        if value.type == 28 and value.count == self.m_nBuyTimesNum + 1 then
            table.insert(tTempList, CopyTable(value))
        end
    end
    table.sort( tTempList, function (a,b) return a.id < b.id end )

    for i = 1, #tTempList do
        if tTempList[i].count == self.m_nBuyTimesNum + 1 then
            return tTempList[i]
        end
    end

    return nil 
end
-------------------------------------私有方法模块End----------------------------------------
