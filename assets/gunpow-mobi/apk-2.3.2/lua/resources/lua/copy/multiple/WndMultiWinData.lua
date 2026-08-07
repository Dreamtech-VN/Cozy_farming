--WndMultiWinData.lua
--@brief	WndMultiWin的数据模块
--@date		2015-11-20
--@author	binshao
--@note		组队副本结算胜利

WndMultiWin = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndMultiWin:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_tData = nil                  --数据表
    self.m_tCardObjList = nil           --翻牌lua对象列表
    self.m_nCountdown = 0               --倒计时
    self.m_bCard1Flag = false           --玩家第1张牌是否已翻状态
    self.m_bCard2Flag = false           --玩家第2张牌是否已翻状态
    self.m_bCard3Flag = false           --玩家第3张牌是否已翻状态
    self.m_tWaitTime = nil              --延迟时间，0-发射特效，1-落下特效，2-加载奖励动画， 3-返回按钮特效
    self.m_bCanBackRoom = false         --是否能回到房间
    self.m_tCellSettlmentObjs = nil     --结算单元格绑定的lua对象
    self.hurtPer = {}       -- 伤害百分比
    self.maxIndex = 1       -- 伤害最大下标
    self.isVideo = false
    self.m_tFlipCardFlag = {}           --标记翻牌的玩家翻牌记录
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndMultiWin:_unInit()
	self.m_root = nil
    self.m_tData = nil
    self.m_tCardObjList = nil
    self.m_nCountdown = 0
    self.m_bCard1Flag = false
    self.m_bCard2Flag = false
    self.m_bCard3Flag = false
    self.m_tWaitTime = nil
    self.m_bCanBackRoom = false
    self.m_tCellSettlmentObjs = nil     --结算单元格绑定的lua对象
    self.filpCardInfo = nil
    self.hurtPer = nil
    self.maxIndex = 1
    self.isVideo = false
    self.m_tFlipCardFlag = nil           --标记翻牌的玩家翻牌记录
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndMultiWin:createElement()
	local element = WZUISystem:getInstance():createElement("WndMultiWin")
	assert(element, "WndMultiWin create element failed!")
	self:_init()
	return element
end

--@brief    显示普通竞技场结算窗口
--@param    tData, 数据表, 包含以下参数
-- battleId : 战斗id
-- winCamp : 胜利的一方
-- playerIds : 角色id
-- playerLevel : 玩家当前的等级(增加经验前的数据)
-- playerExp : 玩家当前的经验(增加经验前的数据)
-- rewardNum : 玩家固定奖励物品数
-- rewardId : 固定奖励物品id
-- rewardCount : 固定奖励物品数量
-- flopNum : 玩家翻牌奖励物品数
-- flopId : 翻牌奖励物品id
-- flopCount : 翻牌奖励物品数量
function WndMultiWin:showWindow(tData)
    WZLog("WndMultiWin:showWindow",tData, Serialize(tData))
    local wnd = self:createElement()
    self.m_tData = tData
    self.isVideo = tData.isVideo
    self:initMaxHurt()
    WindowManager:addWindow(wnd, self, false)
    ProtocolProcessorGlobal:send_BOSSMAPROOM_GetBossMapList()

    g_copyET = os.time()
    local eventData = {stageType = 1,stageId = 3,subStageId = 1,stageCount = 1,
        startTime = g_copyST,endTime = g_copyET,playTime = g_copyET-g_copyST,resultType = 1}
    PostPlayerEvent:postEvent(PostPlayerEvent.event_playerstage, eventData)
end

--@brief    其它人抽一次奖
--@param    playerId : 谁抽奖了
--@param    rewardIndex : 翻牌的位置 1免费翻牌，2VIP翻牌，3钻石翻牌
function WndMultiWin:otherRewardOk(playerId, rewardIndex)
    self:playerFlipCard(playerId, rewardIndex)
end

--@brief    获取是否能回到房间
function WndMultiWin:canBackRoom()
    return self.m_bCanBackRoom
end

--@brief    回到房间错误
function WndMultiWin:backToRoomError(sError)
    MsgBoxManager:showTipBox(sError)
    self:goback()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    获取副本本地数据表
function WndMultiWin:_getCopyLocalData()
    if self.m_tData == nil then
        return
    end
    local nMapId = WBattleGlobal:getCurrent().m_tMakePairOk.mapId
    return GDatatab_team_map["id_"..nMapId]
end

--@brief    获取玩家结算数据
--@param    nIndex,序号
function WndMultiWin:_getPlayerSettlementData(nIndex)
    if self.m_tData == nil then
        return
    end
    local tData = {}
    tData.id = self.m_tData.playerIds[nIndex]
    if tData.id <= 0 then
        return
    end
    local myCamp = WBattleGlobal:getCurrent():getHeroWithId(WBattleGlobal:getCurrent():getMyBattleId()):getCamp()
    tData.isWin = (myCamp == self.m_tData.winCamp)
    tData.level = self.m_tData.playerLevel[nIndex]
    tData.exp = self.m_tData.playerExp[nIndex]
    tData.reward = self:_getRewardByIndex(nIndex)
    tData.flop = self:_getFlopRewardByIndex(nIndex)
    tData.hurtNum = self.hurtPer[nIndex]
    if #self.m_tData.playerIds > 1 then tData.mvp = self.maxIndex == nIndex end
    WZLog("------------------get battle-------------------",tData.level,tData.exp,tData.hurtNum,tData.mvp)
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

--@brief    根据玩家id获取玩家结算数据
--@param    nId,玩家id
function WndMultiWin:_getPlayerSettlementDataById(nId)
    for i = 1, #self.m_tData.playerIds do
        if self.m_tData.playerIds[i] == nId then
            return self:_getPlayerSettlementData(i)
        end
    end
end

-- 获取玩家固定奖励数据表
function WndMultiWin:_getRewardByIndex(nIndex)
    if not self.m_tData then  return end
    local nCursor = 1
    local tReward = {}
    for i = 1, #self.m_tData.rewardNum do
        if i == nIndex then
            for j = nCursor, nCursor+self.m_tData.rewardNum[i]-1 do
                table.insert(tReward, {rewardId=self.m_tData.rewardId[j],rewardCount=self.m_tData.rewardCount[j]})
            end
            break
        else
            nCursor = nCursor + self.m_tData.rewardNum[i]
        end
    end
    return tReward
end

-- 获取玩家翻牌奖励数据表
function WndMultiWin:_getFlopRewardByIndex(nIndex)
    if not self.m_tData then  return end
    local nCursor = 1
    local tReward = {}
    for i = 1, #self.m_tData.flopNum do
        if i == nIndex then
            for j = nCursor, nCursor+self.m_tData.flopNum[i]-1 do
                table.insert(tReward, {flopId=self.m_tData.flopId[j],flopCount=self.m_tData.flopCount[j]})
            end
            break
        else
            nCursor = nCursor + self.m_tData.flopNum[i]
        end
    end
    return tReward
end

-- 伤害值处理
-- 伤害百分比向下取整，如果百分比的总和不足一百，则mvp的玩家的百分比 = 100 - 其他玩家的百分比
-- 如果玩家的伤害值一样，那么MVP优先给座位靠前的
function WndMultiWin:initMaxHurt()
    self.hurtPer = {}

    -- 伤害总值
    local allHurt = 0
    for i = 1, #self.m_tData.playerIds do
        WZLog("------------each player hurt--------------",self.m_tData.hurtNum[i],i)
        allHurt = allHurt + self.m_tData.hurtNum[i]
    end
    WZLog("------------allHurt--------------",allHurt)



    local maxHurt = 0       -- 最大百分比伤害值
    local curAllHurt = 0    -- 当前总的伤害百分比
    for i = 1, #self.m_tData.playerIds do
        local per = 0
        if self.m_tData.hurtNum ~= 0 and allHurt ~= 0 then
            per = math.floor(self.m_tData.hurtNum[i]*100/allHurt)
        end
        --local per = math.floor(self.m_tData.hurtNum[i]*100/allHurt)
        table.insert(self.hurtPer,per)
        WZLog("aaaa = ",per)
        curAllHurt = curAllHurt + per
        if per > maxHurt then
            maxHurt = per
            self.maxIndex = i
        end
    end

    -- 如果总的百分比没有100%，则最大的伤害值进行修改
    local curMaxHurt = 100
    if curAllHurt < 100 and curAllHurt > 0 then
        for i = 1, #self.hurtPer do
            if i ~= self.maxIndex  then
                curMaxHurt = curMaxHurt - self.hurtPer[i]
            end
        end
        self.hurtPer[self.maxIndex] = curMaxHurt
    end

    for i = 1, #self.hurtPer do
        WZLog("hurt per-----------------",self.hurtPer[i])
    end
end
-------------------------------------私有方法模块End----------------------------------------