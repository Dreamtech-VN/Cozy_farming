--WndTowerSettlementData.lua
--@brief	WndTowerSettlement的数据模块
--@date		2015/05/07
--@author	xiaoyu_wu
--@note		爬塔副本结算窗口

WndTowerSettlement = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndTowerSettlement:_init()
	self.m_root = nil	 	  			--场景根节点
    self.data = nil                  --数据表
    self.staticData = nil
    self.m_nCountdown = 0               --倒计时
    
    self.m_nAddExp = 0                  --增加的总经验            
    self.m_nCurAddExp = 0               --当前显示的已经增加的经验，动画用
    self.m_nAddExpStep = 0              --每次经验增加的数值，动画用
    self.m_nCurLevel = 0                --当前显示的等级，动画用
    self.m_nCurExp = 0                  --当前显示的经验，动画用
    self.dtTime = 0                     --定时器
    self.cellList = nil                 --任务子容器
    self.n_Tag = nil                    --当前的动画顺序的执行id
    self.n_moveTime = 0.25              --移动动画时间
    self.n_yanchi = 0.30
    self.n_scaleTime = 0.20             --按钮缩放大小的时间
    self.n_waitTime = {}                --延迟时间，0-发射特效，1-落下特效，2-加载奖励动画， 3-返回按钮特效
    self.b_doBack = false               --是否可以按返回键

    self.levelId = nil

    self.needAddExp = 0
    self.curLv = 0
    self.curExp = 0
    self.leftExp = 0
    self.failUiData = {}                 --失败的UI跳转相关信息
    self.typeId = nil                   --1，爬塔，2英雄塔，3岛主副本
    self.btnTime = 0                    --按钮倒计时
    self.btnTxt = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndTowerSettlement:_unInit()
	self.m_root = nil
    self.data = nil
    self.staticData = nil
    self.m_nCountdown = 0
    
    self.m_nAddExp = 0                         
    self.m_nCurAddExp = 0  
    self.m_nAddExpStep = 0     
    self.m_nCurLevel = 0              
    self.m_nCurExp = 0
    self.dtTime = 0                     
    self.cellList = nil                
    self.n_Tag = nil                   
    self.n_moveTime = nil
    self.n_yanchi = nil
    self.n_scaleTime = nil
    self.n_waitTime = nil               
    self.b_doBack = nil         

    self.levelId = nil

    self.needAddExp = nil
    self.curLv = nil
    self.curExp = nil
    self.leftExp = nil
    self.failUiData = nil
    self.btnTime = nil
    self.btnTxt = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndTowerSettlement:createElement()
	local element = WZUISystem:getInstance():createElement("WndTowerSettlement")
	assert(element, "WndTowerSettlement create element failed!")
	self:_init()
	return element
end

--@brief    显示爬塔副本结算窗口
-- tData = {levelId = 40001, curHpPer = 40, curRoundCnt = 20}
-- levelId 关卡ID
-- curHpPer 当前HP剩余百分比
-- curRoundCnt 当前战斗的回合数
function WndTowerSettlement:showWindow(tData,typeId)
    --tData = {levelId = 40001, curHpPer = 40, curRoundCnt = 5}
    local wnd = WndTowerSettlement:createElement()
    self.data = tData
    self.typeId = typeId
    WZLog("WndTowerSettlement:showWindow", Serialize(tData),typeId)
    if WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_TOWER) then 
        self.staticData = GDatatab_tower_map["id_"..self.data.levelId]
    end
    WindowManager:addWindow(wnd, self, false)
    g_copyET = os.time()
    local resultType = 0
    if WBattleGlobal:getCurrent():isHeroTowerStage() then 
        if self.data.nHp > 0 then resultType = 1 end
        local eventData = {stageType = 1,stageId = 5,subStageId = 1,stageCount = 1,
            startTime = g_copyST,endTime = g_copyET,playTime = g_copyET-g_copyST,resultType = resultType}
        PostPlayerEvent:postEvent(PostPlayerEvent.event_playerstage, eventData)
    elseif WBattleGlobal:getCurrent():isHostChallengeStage() then 
        if self.data.nHp > 0 then resultType = 1 end
        local eventData = {stageType = 1,stageId = 7,subStageId = 1,stageCount = 1,
            startTime = g_copyST,endTime = g_copyET,playTime = g_copyET-g_copyST,resultType = resultType}
        PostPlayerEvent:postEvent(PostPlayerEvent.event_playerstage, eventData)
    else
        if self:_getFightResult() == 1 then resultType = 1 end
        local eventData = {stageType = 1,stageId = 4,subStageId = 1,stageCount = 1,
            startTime = g_copyST,endTime = g_copyET,playTime = g_copyET-g_copyST,resultType = resultType}
        PostPlayerEvent:postEvent(PostPlayerEvent.event_playerstage, eventData)
    end
end

-- 获取战斗结果
-- 返回结果1表示战斗成功，2表示未达到条件失败，3表示死亡失败
function WndTowerSettlement:_getFightResult()
    local bIsWin = WBattleGlobal.getCurrent().m_bIsWin

    if bIsWin then
        return 1
    else
        return 2
    end

    return 1
end

--@brief    返回结果
function WndTowerSettlement:returnResult()
    -- body
    if WBattleGlobal:getCurrent():isHeroTowerStage() then 
        if self.data.nHp > 0 then
            return true
        end
    elseif WBattleGlobal:getCurrent():isHostChallengeStage() then
        return self.data.isWin
    else
        if self:_getFightResult() == 1 then 
            return true
        end
    end

    return false 
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    获取所需条件
function WndTowerSettlement:getAllContition()
    -- body
    local tConticion = {}

    for i = 1, 3 do
        if type(self.staticData["pass" .. i]) == "table" then 
            local tPass = self.staticData["pass" .. i][1]
            local txtLabel

            local content = ""
            if tPass[1] == 6 or tPass[1] == 8 then 
                local skillName = WndDoubleTowerRoom:getSkillName(tPass[2])
                content = string.format(LocalStrings.DOUBLETOWER_TEXT6[tPass[1]], skillName)
            else
                content = string.format(LocalStrings.DOUBLETOWER_TEXT6[tPass[1]], tPass[2])
            end
            content = content .. ":"

            tConticion[i] = content
        end
    end

    return tConticion
end

--@brief    获取各个条件的状态
function WndTowerSettlement:getAllConditionState()
    -- body
    local tData = self.data
    local curHp = tData.curHpPer
    local curCnt = tData.curRoundCnt
    local nMaxHp = tData.maxHp
    local maxHurt = tData.maxHurt
    local hitRate = tData.hitRate
    local useItemTimes = tData.useItemTimes
    local useSkillAndItemList = tData.useSkillAndItemList
    local deadPlayerNum = tData.deadPlayerNum
    local killEnemySkills = tData.killEnemySkills
    local windLevelLimit = tData.windLevelLimit
    local killEnemyKidSkills = tData.killEnemyKidSkills
    local killMonsterNum = tData.killMonsterNum
    local tConditionState = {true, true, true}
    local tConditionValue = {}
    WZLog("WndTowerSettlement:getAllConditionState", Serialize(windLevelLimit))
    for i = 1, 3 do
        if type(self.staticData["pass" .. i]) == "table" then 
            local tPass = self.staticData["pass" .. i][1]
            if tPass[1] == 1 then 
                if curHp < tPass[2] then 
                    tConditionState[i] = false 
                end
                tConditionValue[i] = curHp
            elseif tPass[1] == 2 then 
                if curCnt > tPass[2] then 
                    tConditionState[i] = false 
                end
                tConditionValue[i] = curCnt
            elseif tPass[1] == 3 then 
                if maxHurt < tPass[2] then 
                    tConditionState[i] = false 
                end
                tConditionValue[i] = maxHurt
            elseif tPass[1] == 4 then 
                if hitRate < tPass[2] then 
                    tConditionState[i] = false 
                end
                tConditionValue[i] = hitRate
            elseif tPass[1] == 5 then 
                if useItemTimes >= tPass[2] then 
                    tConditionState[i] = false 
                end
                tConditionValue[i] = useItemTimes
            elseif tPass[1] == 6 then 
                tConditionValue[i] = 0
                if useSkillAndItemList ~= nil then 
                    for j = 1, #useSkillAndItemList do
                        local skillData = GDatatab_skill["id_" .. useSkillAndItemList[j]]
                        if skillData then 
                            for k = 1, #self.staticData["pass" .. i] do
                                if skillData.sub_type == self.staticData["pass" .. i][k][2] then
                                    tConditionState[i] = false 
                                    break 
                                end
                            end
                        end
                        if not tConditionState[i] then 
                            tConditionValue[i] = 1
                            break 
                        end
                    end
                end
            elseif tPass[1] == 7 then 
            elseif tPass[1] == 8 then 
                local bAchie = false 
                tConditionValue[i] = 0
                if killEnemySkills ~= nil then 
                    for j = 1, #killEnemySkills do
                        local skillData = GDatatab_skill["id_" .. killEnemySkills[j]]
                        if skillData then 
                            for k = 1, #self.staticData["pass" .. i] do
                                if skillData.sub_type == self.staticData["pass" .. i][k][2] then
                                    bAchie = true 
                                    break 
                                end
                            end
                        end
                        if bAchie then 
                            tConditionValue[i] = 1
                            break 
                        end
                    end
                end
                if not bAchie then 
                    tConditionState[i] = false 
                end
            elseif tPass[1] == 9 then 
                local bAchie = false 
                tConditionValue[i] = 0
                if killMonsterNum ~= nil then 
                    for k = 1, #self.staticData["pass" .. i] do
                        if killMonsterNum >= self.staticData["pass" .. i][k][2] then
                            bAchie = true 
                            tConditionValue[i] = 1
                            break
                        end
                    end
                end
                if not bAchie then 
                    tConditionState[i] = false 
                end
            elseif tPass[1] == 10 then 
                local bAchie = false 
                tConditionValue[i] = 0
                if windLevelLimit ~= nil and windLevelLimit.min then 
                    for k = 1, #self.staticData["pass" .. i] do
                        if windLevelLimit.min >= self.staticData["pass" .. i][k][2] then
                            bAchie = true 
                            tConditionValue[i] = 1
                            break 
                        end
                    end
                end
                if not bAchie then 
                    tConditionState[i] = false 
                end
            elseif tPass[1] == 11 then 
                local bAchie = false 
                tConditionValue[i] = 0
                if killEnemyKidSkills ~= nil then 
                    for j = 1, #killEnemyKidSkills do
                        local skillData = GDatatab_skill["id_" .. killEnemyKidSkills[j]]
                        if skillData then 
                            for k = 1, #self.staticData["pass" .. i] do
                                if skillData.skill_type == self.staticData["pass" .. i][k][2] then
                                    bAchie = true 
                                    break 
                                end
                            end
                        end
                        if bAchie then 
                            tConditionValue[i] = 1
                            break 
                        end
                    end
                end
                if not bAchie then 
                    tConditionState[i] = false 
                end
            end
        end
    end

    return tConditionState, tConditionValue
end

function WndTowerSettlement:GetTowerRewardOk()
--@brief  领取本层奖励成功
    WZLog("WndTowerSettlement:GetTowerRewardOk ")
    local tData = GDatatab_tower_map
    local towerInfo1 =  CacheCenter:getTowerCopyData()
    local floor_reward = {}
    local vnId = {}
    local vnNum = {} 

    WZLog("领取奖励问题",self.data.levelId,CacheCenter:getTowerCopyData().oneFloor)
    if not self:isFristPass(self.data.levelId) then
        floor_reward = tData["id_"..self.data.levelId].floor_reward
    else
        floor_reward = tData["id_"..self.data.levelId].one_reward
    end
    WZLog("GetTowerRewardOk:",Serialize(floor_reward))

    if floor_reward == {} or floor_reward == -1 then 
        self:onNext()
    elseif  floor_reward and next(floor_reward) then
        for i,v in ipairs(floor_reward) do
            table.insert(vnId,v[1])
            table.insert(vnNum,v[2])
        end   
        local towerInfo = {isReward = true}
        CacheCenter:updateTowerCopyData(towerInfo)
       
        WndRewardShow:showById(vnId,vnNum,nil,nil,nil,nil,nil,nil,nil,1)
        pushEquipInList()
    end
end

--@brief  是否是第一次通关
function WndTowerSettlement:isFristPass(level)
    WZLog("WndTowerScroll:isFristPass")
    local towerInfo1 =  CacheCenter:getTowerCopyData()
    local FloorNum = 0  --层数
    for k,v in pairs(GDatatab_tower_map) do
        if level == v.id then
            FloorNum = v.floor_num
        end
    end
    if FloorNum > towerInfo1.oneFloor then
        return true
    end
    return false
end

--@brief    获取玩家结算数据
--@param    nIndex,序号
function WndTowerSettlement:_getPlayerSettlementData(nIndex)
    if self.data == nil then
        return
    end
    local tData = {}
    tData.id = self.data.playerIds[nIndex]
    if tData.id <= 0 then
        return
    end
    tData.isWin = (WBattleGlobal:getCurrent():getHeroWithId(WBattleGlobal:getCurrent():getMyBattleId()):getCamp() == self.data.winCamp)
    tData.level = self.data.playerLevel[nIndex]
    tData.exp = self.data.playerExp[nIndex]
    tData.reward = self:_getRewardByIndex(nIndex)
    if #self.data.playerIds > 1 then tData.mvp = self.maxIndex == nIndex end
    WZLog("------------------get battle-------------------",tData.level,tData.exp)
    local tMakePairOk = WBattleGlobal:getCurrent().m_tMakePairOk
    for i = 1, #tMakePairOk.playerId do
        if tData.id == tMakePairOk.playerId[i] then
            tData.name = tMakePairOk.playerName[i]
            tData.sex = tMakePairOk.playerSex[i]
            tData.headId = tMakePairOk.headId[i]
            tData.faceId = tMakePairOk.faceId[i]
            tData.bodyId = tMakePairOk.bodyId[i]
            tData.weaponId = tMakePairOk.weaponId[i]
            tData.wingId = tMakePairOk.wingId[i]
            tData.petId = tMakePairOk.petId[i]
            tData.headColor = tMakePairOk.colour[i]
            tData.bodyColor = tMakePairOk.bodyColour[i]
            WZLog("------------iii-----------",tData.id,tData.headColor,tData.bodyColor)
            break
        end
    end
    
    return tData
end

--@brief    获取结算奖励
function WndTowerSettlement:_getRewardByIndex(nIndex)
    -- body
    -- 获取玩家固定奖励数据表
    if not self.data then  return end
    local nCursor = 1
    local tReward = {}
    for i = 1, #self.data.rewardNum do
        if i == nIndex then
            for j = nCursor, nCursor+self.data.rewardNum[i]-1 do
                table.insert(tReward, {rewardId=self.data.rewardId[j], rewardCount=self.data.rewardCount[j]})
            end
            break
        else
            nCursor = nCursor + self.data.rewardNum[i]
        end
    end
    return tReward
end

--@brief    更新玩家列表
--@param    conParent, 父亲节点
--@param    tPlayerList, 玩家数据列表
function WndTowerSettlement:_updatePlayerFigure(isWin)
    local tPlayerList = {}
    WZLog("#self.data.playerIds-------------------",#self.data.playerIds)
    for i = 1, #self.data.playerIds do
        if self.data.playerIds[i] > 0 then
            table.insert(tPlayerList, self:_getPlayerSettlementData(i))
        end
    end

    local nCount = #tPlayerList
    for i = 1, #tPlayerList do
        local conPlayer
        if i == 1 then 
            if not self:returnResult() then 
                conPlayer = GetElement(self.m_root, "conPlayerFail_WndTowerSettlement", WZUIContainer)
            else
                conPlayer = GetElement(self.m_root, "conPlayer_WndTowerSettlement", WZUIContainer)
            end
        end

        if i == 2 then 
            if not self:returnResult() then 
                conPlayer = GetElement(self.m_root, "conPlayerFail2_WndTowerSettlement", WZUIContainer)
            else
                conPlayer = GetElement(self.m_root, "conPlayer2_WndTowerSettlement", WZUIContainer)
            end
            conPlayer:setVisible(true)
        end

        if i == 3 then 
            if not self:returnResult() then 
                conPlayer = GetElement(self.m_root, "conPlayerFail3_WndTowerSettlement", WZUIContainer)
            else
                conPlayer = GetElement(self.m_root, "conPlayer3_WndTowerSettlement", WZUIContainer)
            end
            conPlayer:setVisible(true)
        end

        local cellPlayer = self:_createPlayerFigure(tPlayerList[i], isWin)
        local aniNode = cellPlayer:getAnimNode()
        conPlayer:addChild(aniNode)
    end
end

--@brief    创建玩家形象
function WndTowerSettlement:_createPlayerFigure(tData, isWin)
    local tEquip = {tData.faceId, tData.headId, tData.bodyId, tData.wingId, tData.weaponId}
    local sAniName = isWin and "win" or "failure"

    local aniPlayer = CreatePlayerFigure(tData.sex, tEquip, sAniName,nil,nil,nil,nil,nil,false,nil,tData.headColor,tData.bodyColor)

    return aniPlayer
end

-------------------------------------私有方法模块End----------------------------------------
