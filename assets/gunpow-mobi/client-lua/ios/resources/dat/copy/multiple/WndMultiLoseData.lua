--WndMultiLoseData.lua
--@brief	WndMultiLose的数据模块
--@date		2015-11-20
--@author	binshao
--@note		组队副本结算失败

WndMultiLose = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndMultiLose:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_tData = nil                  --数据表
    self.m_nCountdown = 0               --倒计时
    self.m_bCanBackRoom = false         --是否能回到房间
    self.isVideo = false
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndMultiLose:_unInit()
	self.m_root = nil
    self.m_tData = nil
    self.m_nCountdown = 0
    self.m_bCanBackRoom = false
    self.isVideo = false
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndMultiLose:createElement()
	local element = WZUISystem:getInstance():createElement("WndMultiLose")
	assert(element, "WndMultiLose create element failed!")
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
function WndMultiLose:showWindow(tData)
    WZLog("WndMultiLose:showWindow")
    local wnd = self:createElement()
    self.m_tData = tData
    self.isVideo = tData.isVideo
    WindowManager:addWindow(wnd, self, false)
    ProtocolProcessorGlobal:send_BOSSMAPROOM_GetBossMapList()

    g_copyET = os.time()
    local eventData = {stageType = 1,stageId = 3,subStageId = 1,stageCount = 1,
        startTime = g_copyST,endTime = g_copyET,playTime = g_copyET-g_copyST,resultType = 0}
    PostPlayerEvent:postEvent(PostPlayerEvent.event_playerstage, eventData)
end

--@brief    获取是否能回到房间
function WndMultiLose:canBackRoom()
    return self.m_bCanBackRoom
end

--@brief    回到房间错误
function WndMultiLose:backToRoomError(sError)
    MsgBoxManager:showTipBox(sError)
    self:goback()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    获取副本本地数据表
function WndMultiLose:_getCopyLocalData()
    if not self.m_tData  then  return end
    local nMapId = WBattleGlobal:getCurrent().m_tMakePairOk.mapId
    return GDatatab_team_map["id_"..nMapId]
end

--@brief    获取玩家结算数据
--@param    nIndex,序号
function WndMultiLose:_getPlayerSettlementData(nIndex)
    if self.m_tData == nil then
        return
    end
    local tData = {}
    tData.id = self.m_tData.playerIds[nIndex]
    if tData.id <= 0 then  return end
    tData.level = self.m_tData.playerLevel[nIndex]
    tData.exp = self.m_tData.playerExp[nIndex]
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
            break
        end
    end
    
    return tData
end
-------------------------------------私有方法模块End----------------------------------------