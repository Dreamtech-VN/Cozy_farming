--WndSingleCopySettlementData.lua
--@brief	WndSingleCopySettlement的数据模块
--@date		2015/05/22
--@author	xiaoyu_wu
--@note		单人副本结算窗口

WndSingleCopySettlement = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSingleCopySettlement:_init()
	self.m_root = nil	 	  			--场景根节点
    
    self.m_tData = nil                  --数据表
    self.isWin = nil
    self.m_nCountdown = 0               --倒计时

    self.dtTime = 0                     --定时器
    self.cellList = nil                 --任务子容器
    self.n_Tag = nil                    --当前的动画顺序的执行id
    self.n_moveTime = 0.25              --移动动画时间
    self.n_yanchi = 0.30
    self.n_scaleTime = 0.20             --按钮缩放大小的时间
    self.n_waitTime = {}                --延迟时间，0-发射特效，1-落下特效，2-加载奖励动画， 3-返回按钮特效
    self.b_doBack = false               --是否可以按返回键

    self.needAddExp = 0
    self.curLv = 0
    self.curExp = 0
    self.leftExp = 0
    self.failUiData = {}                 --失败的UI跳转相关信息
    self.isVideo = false
    self.m_nWinType = 0                  -- 0默认；1双人爬塔
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSingleCopySettlement:_unInit()
	self.m_root = nil
    
    self.m_tData = nil
    self.isWin = nil
    self.m_nCountdown = 0

    self.dtTime = nil                     
    self.cellList = nil
    self.n_Tag = nil
    self.n_moveTime = nil
    self.n_yanchi =nil         
    self.n_scaleTime = nil
    self.n_waitTime = nil
    self.b_doBack = nil

    self.needAddExp = nil
    self.curLv = nil
    self.curExp = nil
    self.leftExp = nil
    self.failUiData = nil
    self.isVideo = false
    self.m_nWinType = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSingleCopySettlement:createElement()
	local element = WZUISystem:getInstance():createElement("WndSingleCopySettlement")
	assert(element, "WndSingleCopySettlement create element failed!")
	self:_init()
	return element
end

--@brief    显示普通竞技场结算窗口
--@param    tData, 数据表, 包含以下数据
-- pointId : 小关卡ID
-- passTimes : 当日通关次数
-- factor : 通关条件状态1位条件一，2位条件二，3位条件三
-- rewardId : 奖励物品id
-- rewardCount : 奖励物品数量
-- playerData = "sex,lv,exp,faceId,headId,bodyId,wingId,weaponId"
-- playerData = {sex = sex,level = level,exp = exp,equip = {faceId,headId,bodyId,wingId,weaponId}}
function WndSingleCopySettlement:showWindow(isWin,tData, nWinType)
    local wnd = self:createElement()
    if tData == nil then
        WZLog("WndSingleCopySettlement:showWindow:   eeee")
    end
    self.m_tData = tData
    self.m_nWinType = nWinType or 0 
    self.isVideo = tData.isVideo
    if self.m_nWinType == 0 then 
        WZLog("WndSingleCopySettlement:showWindow:",tData.factor)
        WZLog("----------------------777---------------------",tData.pointId)
        for k,v in pairs(tData.playerData) do
            WZLog("---------k,v-----------",k,v)
        end
    end

    self.isWin = isWin
    WindowManager:addWindow(wnd, self, false)

    if self.m_nWinType == 0 then 
        g_copyET = os.time()
        local resultType = 0
        if isWin then resultType = 1 end
        local eventData = {stageType = 1,stageId = 2,subStageId = 1,stageCount = 1,
            startTime = g_copyST,endTime = g_copyET,playTime = g_copyET-g_copyST,resultType = resultType}
        PostPlayerEvent:postEvent(PostPlayerEvent.event_playerstage, eventData)
    end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    是否有已完成的任务
--@return   #1,是否有已完成的任务
function WndSingleCopySettlement:_hasCompletedTask()
    if PrefetchCache:hasTaskList() then
        local tTaskList = PrefetchCache:getTaskList()
        if #tTaskList.tDailyTask.tToSubmit > 0 then
            return true
        end
        for i = 1, #tTaskList.tMainTask do
            if tTaskList.tMainTask[i].nTaskStatus == TASKSTATUS_TOSUBMIT then
                return true
            end
        end
        for i = 1, #tTaskList.tBranchTask do
            if tTaskList.tBranchTask[i].nTaskStatus == TASKSTATUS_TOSUBMIT then
                return true
            end
        end
    end
    return false
end

--@brief    获取玩家结算数据
--@param    nIndex,序号
function WndSingleCopySettlement:_getPlayerSettlementData(nIndex)
    if self.m_tData == nil then
        return
    end
    local tData = {}
    tData.id = self.m_tData.playerIds[nIndex]
    if tData.id <= 0 then
        return
    end
    tData.isWin = (WBattleGlobal:getCurrent():getHeroWithId(WBattleGlobal:getCurrent():getMyBattleId()):getCamp() == self.m_tData.winCamp)
    tData.level = self.m_tData.playerLevel[nIndex]
    tData.exp = self.m_tData.playerExp[nIndex]
    tData.reward = self:_getRewardByIndex(nIndex)
    if #self.m_tData.playerIds > 1 then tData.mvp = self.maxIndex == nIndex end
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
function WndSingleCopySettlement:_getRewardByIndex(nIndex)
    -- body
    -- 获取玩家固定奖励数据表
    if not self.m_tData then  return end
    local nCursor = 1
    local tReward = {}
    for i = 1, #self.m_tData.rewardNum do
        if i == nIndex then
            for j = nCursor, nCursor+self.m_tData.rewardNum[i]-1 do
                table.insert(tReward, {rewardId=self.m_tData.rewardId[j], rewardCount=self.m_tData.rewardCount[j]})
            end
            break
        else
            nCursor = nCursor + self.m_tData.rewardNum[i]
        end
    end
    return tReward
end

--@brief    更新玩家列表
--@param    conParent, 父亲节点
--@param    tPlayerList, 玩家数据列表
function WndSingleCopySettlement:_updatePlayerFigure(isWin)
    local tPlayerList = {}
    WZLog("#self.m_tData.playerIds-------------------",#self.m_tData.playerIds)
    for i = 1, #self.m_tData.playerIds do
        if self.m_tData.playerIds[i] > 0 then
            table.insert(tPlayerList, self:_getPlayerSettlementData(i))
        end
    end

    local nCount = #tPlayerList
    for i = 1, #tPlayerList do
        local conPlayer
        if not self.isWin then 
            conPlayer = GetElement(self.m_root, "conPlayerFail_WndSingleCopySettlement", WZUIContainer)
            if i == 1 and nCount == 2 then 
                conPlayer:setRelativePosition(GlobalMethod:ccp(0.45,0.378474))
            end
        else
            conPlayer = GetElement(self.m_root, "conPlayer_WndSingleCopySettlement", WZUIContainer)
            if i == 1 and nCount == 2 then 
                conPlayer:setRelativePosition(GlobalMethod:ccp(0.3,0.35))
            end
        end

        if i == 2 then 
            if not self.isWin then 
                conPlayer = GetElement(self.m_root, "conPlayerFail2_WndSingleCopySettlement", WZUIContainer)
            else
                conPlayer = GetElement(self.m_root, "conPlayer2_WndSingleCopySettlement", WZUIContainer)
            end
            conPlayer:setVisible(true)
        end
        local cellPlayer = self:_createPlayerFigure(tPlayerList[i], isWin)
        local aniNode = cellPlayer:getAnimNode()
        conPlayer:addChild(aniNode)
    end
end

--@brief    创建玩家形象
function WndSingleCopySettlement:_createPlayerFigure(tData, isWin)
    local tEquip = {tData.faceId, tData.headId, tData.bodyId, tData.wingId, tData.weaponId}
    local sAniName = isWin and "win" or "failure"

    local aniPlayer = CreatePlayerFigure(tData.sex, tEquip, sAniName,nil,nil,nil,nil,nil,false,nil,tData.headColor,tData.bodyColor)

    return aniPlayer
end
-------------------------------------私有方法模块End----------------------------------------
