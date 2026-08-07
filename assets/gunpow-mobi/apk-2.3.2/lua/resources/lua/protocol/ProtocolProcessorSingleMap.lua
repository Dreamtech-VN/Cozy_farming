--ProtocolProcessorSingleMap.lua
--@brief	单人副本相关协议
--@date  	2014/4/26
--@author 	莫剑峰
--@note 	单人副本相关协议


ProtocolProcessorSingleMap = ProtocolProcessorBase:new()


-------------------------------------公有方法模块--------------------------------------

--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorSingleMap:regAll()
    WZLog("ProtocolProcessorSingleMap:regAll")
    --@brief	开始挑战成功
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_StartChallengeOk, "ProtocolProcessorSingleMap:parse_SINGLEMAP_StartChallengeOk", "iivi")

    --@brief	挑战单人副本结算
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_ChallengeSuccessOk, "ProtocolProcessorSingleMap:parse_SINGLEMAP_ChallengeSuccessOk", "iitvivii")

    --@brief	扫荡成功
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_StartRaidsOk, "ProtocolProcessorSingleMap:parse_SINGLEMAP_StartRaidsOk", "ivivivi")

    --@brief	重置副本信息成功
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_ResetDailyMapOk, "ProtocolProcessorSingleMap:parse_SINGLEMAP_ResetDailyMapOk", "iibi")
    --@brief    获取爬塔副本排名（MAP_GetTowerRankOk = 18）
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_GetTowerRankOk, "ProtocolProcessorSingleMap:parse_MAP_GetTowerRankOk", "iivlvivtvsvsvivivivtvi")


    --@brief	返回扫荡状态
    --self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_GetRaidsTowerInfoOk, "ProtocolProcessorSingleMap:parse_SINGLEMAP_GetRaidsTowerInfoOk", "ii")

    --@brief	扫荡成功
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_CompleteRaidsTowerOk, "ProtocolProcessorSingleMap:parse_SINGLEMAP_CompleteRaidsTowerOk", "iivivi")
    
    --@brief	领取章节奖励成功
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_GetSectionRewardOK, "ProtocolProcessorSingleMap:parse_SINGLEMAP_GetSectionRewardOK", "iitvivi")

    --@brief	获取日常副本信息成（MAP_GetDailyMapOk = 12）
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_GetDailyMapOk, "ProtocolProcessorSingleMap:parse_SINGLEMAP_GetDailyMapOk", "vivivivbvivivi")

    --@brief	获取爬塔副本层奖励（SINGLEMAP_GetTowerRewardOk = 26）
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_GetTowerRewardOk, "ProtocolProcessorSingleMap:parse_SINGLEMAP_GetTowerRewardOk", "")

    --@brief	获取日常副本信息（MAP_GetDailyMap = 11）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_GetDailyMap, "ProtocolProcessorSingleMap:send_SINGLEMAP_GetDailyMap_ErrorProcess", "is" )

    --@brief	开始挑战错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_StartChallenge, "ProtocolProcessorSingleMap:send_SINGLEMAP_StartChallenge_ErrorProcess", "is" )

    --@brief	挑战成功错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_ChallengeSuccess, "ProtocolProcessorSingleMap:send_SINGLEMAP_ChallengeSuccess_ErrorProcess", "is" )

    --@brief	开始扫荡错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_StartRaids, "ProtocolProcessorSingleMap:send_SINGLEMAP_StartRaids_ErrorProcess", "is" )
    
    --@brief	重置副本信息错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_ResetDailyMap, "ProtocolProcessorSingleMap:send_SINGLEMAP_ResetDailyMap_ErrorProcess", "is" )

    --@brief	获取爬塔副本信息错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_GetTowerInfo, "ProtocolProcessorSingleMap:send_SINGLEMAP_GetTowerInfo_ErrorProcess", "is" )

    --@brief	获取爬塔副本排名错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_GetTowerRank, "ProtocolProcessorSingleMap:send_SINGLEMAP_GetTowerRank_ErrorProcess", "is" )

    --@brief	获取爬塔副本层奖励（MAP_GetTowerReward = 25）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_GetTowerReward, "ProtocolProcessorSingleMap:send_SINGLEMAP_GetTowerReward_ErrorProcess", "is" )

    --@brief	获取扫荡状态错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_GetRaidsTowerInfo, "ProtocolProcessorSingleMap:send_SINGLEMAP_GetRaidsTowerInfo_ErrorProcess", "is" )

    --@brief	扫荡爬塔副本错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_StartRaidsTower, "ProtocolProcessorSingleMap:send_SINGLEMAP_StartRaidsTower_ErrorProcess", "is" )

    --@brief	完成扫荡错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_CompleteRaidsTower, "ProtocolProcessorSingleMap:send_SINGLEMAP_CompleteRaidsTower_ErrorProcess", "is" )

    --@brief	重置爬塔副本错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_ResetTowerMap, "ProtocolProcessorSingleMap:send_SINGLEMAP_ResetTowerMap_ErrorProcess", "is" )

    --@brief	领取章节奖励错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_GetSectionReward, "ProtocolProcessorSingleMap:send_SINGLEMAP_GetSectionReward_ErrorProcess", "is" )
    
    --@brief    获取好友爬塔信息（MAP_GetFriendTowerInfo = 27）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_GetFriendTowerInfo, "ProtocolProcessorSingleMap:send_MAP_GetFriendTowerInfo_ErrorProcess", "is" )
    
    --@brief    获取好友爬塔信息（MAP_GetFriendTowerInfoOk = 28）
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_GetFriendTowerInfoOk, "ProtocolProcessorSingleMap:parse_MAP_GetFriendTowerInfoOk", "vivsvivivivivi")

    
    --@brief    重置单人副本信息（MAP_ResetSingleMap = 29）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.MAP_ResetSingleMap, "ProtocolProcessorSingleMap:send_MAP_ResetSingleMap_ErrorProcess", "is" )

    --@brief    单人副本战斗记录（MAP_MapRecord = 30）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_MapRecord, "ProtocolProcessorSingleMap:send_SINGLEMAP_MapRecord_ErrorProcess", "is" )
    
    --@brief    单人副本战斗记录（MAP_RefreshMapRecord = 32）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.MAP_RefreshMapRecord, "ProtocolProcessorSingleMap:send_MAP_RefreshMapRecord_ErrorProcess", "is" )

    --@brief    单人副本战斗记录（MAP_MapRecordOk = 31）
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_MapRecordOk, "ProtocolProcessorSingleMap:parse_SINGLEMAP_MapRecordOk", "")

    --@brief    单人副本战斗记录（MAP_RefreshMapRecordOk = 33）
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.MAP_RefreshMapRecordOk, "ProtocolProcessorSingleMap:parse_MAP_RefreshMapRecordOk", "vivivivsvivivivi")

    --@brief    获取训练营信息成功（MAP_TrainMesOk = 35）
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.MAP_TrainMesOk, "ProtocolProcessorSingleMap:parse_MAP_TrainMesOk", "vi")

    --@brief    获取训练营信息（MAP_TrainMes = 34）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.MAP_TrainMes, "ProtocolProcessorSingleMap:send_MAP_TrainMes_ErrorProcess", "is" )



    --@brief    扫荡组队副本（MAP_StartRaidsTeam = 36）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.MAP_StartRaidsTeam, "ProtocolProcessorSingleMap:send_MAP_StartRaidsTeam_ErrorProcess", "is" )
    --@brief    扫荡成功（MAP_StartRaidsTeamOk = 37）
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.MAP_StartRaidsTeamOk, "ProtocolProcessorSingleMap:parse_MAP_StartRaidsTeamOk", "iviviviviviii")
    --@brief    当天扫荡组队副本次数（MAP_GetTodayRaidsTeamTimes = 38）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.MAP_GetTodayRaidsTeamTimes, "ProtocolProcessorSingleMap:send_MAP_GetTodayRaidsTeamTimes_ErrorProcess", "is" )
    --@brief    当天扫荡组队副本次数（MAP_GetTodayRaidsTeamTimesOk = 39）
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.MAP_GetTodayRaidsTeamTimesOk , "ProtocolProcessorSingleMap:parse_MAP_GetTodayRaidsTeamTimesOk", "i")

    --@brief	重置日常副本信息（MAP_GetDailyMap = 40）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.MAP_GetDailyMap, "ProtocolProcessorSingleMap:send_MAP_GetDailyMap_ErrorProcess", "is" )
    --@brief    扫荡日常副本（MAP_StartRaidsDaily = 41）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.MAP_StartRaidsDaily, "ProtocolProcessorSingleMap:send_MAP_StartRaidsDaily_ErrorProcess", "is" )
    --@brief    扫荡日常副本（MAP_StartRaidsDailyOk = 42）
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.MAP_StartRaidsDailyOk, "ProtocolProcessorSingleMap:parse_MAP_StartRaidsDailyOk", "iivivi")

    --@brief    获取自己占领岛屿的信息（MAP_GetLandlordData = 43）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.MAP_GetLandlordData, "ProtocolProcessorSingleMap:send_MAP_GetLandlordData_ErrorProcess", "is" )
    --@brief    获取自己占领岛屿的信息（MAP_GetLandlordDataOk = 44）
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.MAP_GetLandlordDataOk, "ProtocolProcessorSingleMap:parse_MAP_GetLandlordDataOk", "vivi")
    --@brief    指定副本的岛主数据（MAP_GetMapLandlordData = 45）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.MAP_GetMapLandlordData, "ProtocolProcessorSingleMap:send_MAP_GetMapLandlordData_ErrorProcess", "is" )
    --@brief    获取指定岛主副本数据（MAP_GetMapLandlordDataOk = 46）
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.MAP_GetMapLandlordDataOk, "ProtocolProcessorSingleMap:parse_MAP_GetMapLandlordDataOk", "iiiiivivivsvivivivivivivivi")
    --@brief    退出岛主（MAP_QuitLandlord = 60）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.MAP_QuitLandlord, "ProtocolProcessorSingleMap:send_MAP_QuitLandlord_ErrorProcess", "is")

    --@brief    获取英雄塔数据（MAP_GetHeroTowerData = 47）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.MAP_GetHeroTowerData, "ProtocolProcessorSingleMap:send_MAP_GetHeroTowerData_ErrorProcess", "is" )
    --@brief    获取英雄塔数据（MAP_GetHeroTowerDataOk = 48）
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.MAP_GetHeroTowerDataOk, "ProtocolProcessorSingleMap:parse_MAP_GetHeroTowerDataOk", "iiiiivsvivs")
    --@brief    更换英雄塔对手（MAP_ChangeHeroTowerEnemy = 49）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.MAP_ChangeHeroTowerEnemy, "ProtocolProcessorSingleMap:send_MAP_ChangeHeroTowerEnemy_ErrorProcess", "is" )
    --@brief    更换英雄塔对手（MAP_ChangeHeroTowerEnemyOk = 50）
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.MAP_ChangeHeroTowerEnemyOk, "ProtocolProcessorSingleMap:parse_MAP_ChangeHeroTowerEnemyOk", "is")
    --@brief    重置英雄（MAP_ResetHeroTower = 51）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.MAP_ResetHeroTower, "ProtocolProcessorSingleMap:send_MAP_ResetHeroTower_ErrorProcess", "is" )
    --@brief    获取英雄塔数据（MAP_ResetHeroTowerOk = 52）
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.MAP_ResetHeroTowerOk, "ProtocolProcessorSingleMap:parse_MAP_ResetHeroTowerOk", "ii")
    --@brief    获取爬塔副本跨服历史排名（MAP_CrossGetTowerRank = 53）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.MAP_CrossGetTowerRank, "ProtocolProcessorSingleMap:send_MAP_CrossGetTowerRank_ErrorProcess", "is" )
    --@brief    获取爬塔副本跨服历史排名（MAP_CrossGetTowerRankOK = 54）
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.MAP_CrossGetTowerRankOK, "ProtocolProcessorSingleMap:parse_MAP_CrossGetTowerRankOK", "iivivivtvsvsvivivivtvivi")
    --@brief    获取英雄塔副本跨服每日排名（MAP_CrossGetTodayHeroTowerRank = 55）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.MAP_CrossGetTodayHeroTowerRank, "ProtocolProcessorSingleMap:send_MAP_CrossGetTodayHeroTowerRank_ErrorProcess", "is" )
    --@brief    获取英雄塔副本跨服每日排名（MAP_CrossGetTodayHeroTowerRankOK = 56）
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.MAP_CrossGetTodayHeroTowerRankOK, "ProtocolProcessorSingleMap:parse_MAP_CrossGetTodayHeroTowerRankOK", "tiivivivtvsvsvivivivtvivi")

    --@brief    双人爬塔操作（BOSSMAPROOM_TwoTowerOperation= 40）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_TwoTowerOperation, "ProtocolProcessorSingleMap:send_BOSSMAPROOM_TwoTowerOperation_ErrorProcess", "is" )
    --@brief    双人爬塔操作（BOSSMAPROOM_TwoTowerOperationOk =41）
    self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_TwoTowerOperationOk, "ProtocolProcessorSingleMap:parse_BOSSMAPROOM_TwoTowerOperationOk", "iviviiii")
    --@brief    获取双人爬塔副本排名（BOSSMAPROOM_GetTwoTowerRank = 42）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_GetTwoTowerRank, "ProtocolProcessorSingleMap:send_BOSSMAPROOM_GetTwoTowerRank_ErrorProcess", "is" )
    --@brief    获取双人爬塔副本排名（BOSSMAPROOM_GetTwoTowerRankOk = 43）
    self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_GetTwoTowerRankOk, "ProtocolProcessorSingleMap:parse_BOSSMAPROOM_GetTwoTowerRankOk", "iivivivtvsvsvivivivtvi")
    --@brief    开始一键扫荡（MAP_StartRaidsBatch = 57）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.MAP_StartRaidsBatch, "ProtocolProcessorSingleMap:send_MAP_StartRaidsBatch_ErrorProcess", "is" )
    --@brief    一键扫荡成功（MAP_StartRaidsBatchOk = 58）
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.MAP_StartRaidsBatchOk, "ProtocolProcessorSingleMap:parse_MAP_StartRaidsBatchOk", "vivivivivi")
    --@brief    重置单人副本信息错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.MAP_ResetSingleMapBatch, "ProtocolProcessorSingleMap:send_MAP_ResetSingleMapBatch_ErrorProcess", "is" )
    --@brief    重置单人副本信息
    self:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.MAP_ResetSingleMapBatch, "ProtocolProcessorSingleMap:parse_MAP_ResetSingleMapBatch", "")

end 


--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorSingleMap:unregAll()
    WZLog("ProtocolProcessorSingleMap:unregAll")
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief    单人副本战斗记录（MAP_MapRecord = 30）
function ProtocolProcessorSingleMap:send_SINGLEMAP_MapRecord(mapId, record , makePairOk)
    WZLog("send_SINGLEMAP_MapRecord")
    local sender = Protocol:getSender( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_MapRecord )
    if sender==nil then WZLog("sender == nil") return end
    sender:writeInt( mapId )    -- 副本id
    sender:writeString( record )    -- 战斗记录
    sender:writeString( makePairOk )    -- 战斗信息
    SendProtocol(sender,false) --true:showLoading
end

--@brief	开始挑战
function ProtocolProcessorSingleMap:send_SINGLEMAP_StartChallenge(pointId, mapType )
	WZLog("send_SINGLEMAP_StartChallenge = ",pointId,mapType)
	local sender = Protocol:getSender( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_StartChallenge )
	if sender==nil then WZLog("sender == nil") return end
	sender:writeInt( pointId )	-- 小关卡ID
	sender:writeInt( mapType )	-- 副本类型（1单人副本，2日常副本，3爬塔副本, 7单人副本岛主）
	SendProtocol(sender,false) --true:showLoading
end


--@brief	挑战成功
function ProtocolProcessorSingleMap:send_SINGLEMAP_ChallengeSuccess(pointId, battleVerify, mapType, useAssistSkillIds, challengeResult)
	WZLog("send_SINGLEMAP_ChallengeSuccess", pointId, mapType, Serialize(VectorToTable(useAssistSkillIds)))

	local sender = Protocol:getSender( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_ChallengeSuccess )
	if sender==nil then WZLog("sender == nil") return end 
    if useAssistSkillIds == nil then 
        useAssistSkillIds = TableToVector({}, WZLuaVector_int_)
    end
	sender:writeInt( pointId )	-- 小关卡ID
	sender:writeStringEncrypt( battleVerify )	-- 战斗检验
	sender:writeInt( mapType )	-- 副本类型（1单人副本，2日常副本，3爬塔副本）
    sender:writeInts(useAssistSkillIds) -- 玩家在对战中使用了的助战技ID【162新增】
    sender:writeByte(challengeResult or 0)   -- 挑战结果，0=成功|1=失败【162新增】
	SendProtocol(sender,false) --true:showLoading

    if pointId < 20000 then
        TeachGroup1:taskTeach(pointId)
    end
    TeachGroup1:battleTeach()

end

--@brief	开始扫荡
function ProtocolProcessorSingleMap:send_SINGLEMAP_StartRaids(pointId ,times)
	WZLog("send_SINGLEMAP_StartRaids")
	local sender = Protocol:getSender( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_StartRaids )
	if sender==nil then WZLog("sender == nil") return end
    
	sender:writeInt( pointId )	-- 小关卡ID
    sender:writeInt( times )	
	SendProtocol(sender,false) --true:showLoading
end

--@brief	重置副本信息
function ProtocolProcessorSingleMap:send_SINGLEMAP_ResetDailyMap(mapId)
	WZLog("send_SINGLEMAP_ResetDailyMap")
	local sender = Protocol:getSender( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_ResetDailyMap )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( mapId )	-- 副本Id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取爬塔副本信息
function ProtocolProcessorSingleMap:send_SINGLEMAP_GetTowerInfo()
	WZLog("send_SINGLEMAP_GetTowerInfo")
	local sender = Protocol:getSender( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_GetTowerInfo )
	if sender==nil then WZLog("sender == nil") return end
    
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取爬塔副本排名
function ProtocolProcessorSingleMap:send_SINGLEMAP_GetTowerRank()
	WZLog("send_SINGLEMAP_GetTowerRank")
	local sender = Protocol:getSender( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_GetTowerRank )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取扫荡状态
function ProtocolProcessorSingleMap:send_SINGLEMAP_GetRaidsTowerInfo( )
	WZLog("send_SINGLEMAP_GetRaidsTowerInfo")
	local sender = Protocol:getSender( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_GetRaidsTowerInfo )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	扫荡爬塔副本
function ProtocolProcessorSingleMap:send_SINGLEMAP_StartRaidsTower( )
	WZLog("send_SINGLEMAP_StartRaidsTower")
	local sender = Protocol:getSender( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_StartRaidsTower )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	完成扫荡
--@param useDiamond ： 是否使用钻石快速扫荡
function ProtocolProcessorSingleMap:send_SINGLEMAP_CompleteRaidsTower(useDiamond)
	WZLog("send_SINGLEMAP_CompleteRaidsTower= ",useDiamond)
	local sender = Protocol:getSender( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_CompleteRaidsTower )
	if sender==nil then WZLog("sender == nil") return end
    sender:writeBoolean(useDiamond)
	SendProtocol(sender,false) --true:showLoading
end

--@brief	重置爬塔副本
function ProtocolProcessorSingleMap:send_SINGLEMAP_ResetTowerMap( )
	WZLog("send_SINGLEMAP_ResetTowerMap")
	local sender = Protocol:getSender( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_ResetTowerMap )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取爬塔副本层奖励（MAP_GetTowerReward = 25）
function ProtocolProcessorSingleMap:send_SINGLEMAP_GetTowerReward( )
    WZLog("send_MAP_GetTowerReward")
    local sender = Protocol:getSender( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_GetTowerReward )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief	领取章节奖励
function ProtocolProcessorSingleMap:send_SINGLEMAP_GetSectionReward(sectionId,mapType, rewardIndex )
	WZLog("send_SINGLEMAP_GetSectionReward")
	local sender = Protocol:getSender( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_GetSectionReward )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( sectionId )	-- 章节ID
    sender:writeInt( mapType )      -- 副本类型
	sender:writeInt( rewardIndex )	-- 领取奖励的Index
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取日常副本信息（MAP_GetDailyMap = 11）
function ProtocolProcessorSingleMap:send_SINGLEMAP_GetDailyMap( )
    WZLog("send_SINGLEMAP_GetDailyMap")
    local sender = Protocol:getSender( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_GetDailyMap )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取好友爬塔信息（MAP_GetFriendTowerInfo = 27）
function ProtocolProcessorSingleMap:send_MAP_GetFriendTowerInfo()
    WZLog("send_MAP_GetFriendTowerInfo")
    local sender = Protocol:getSender( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_GetFriendTowerInfo )
    if sender==nil then WZLog("sender == nil") return end
    
    SendProtocol(sender,false) --true:showLoading
    
end

--@brief    重置单人副本信息（MAP_ResetSingleMap = 29）
function ProtocolProcessorSingleMap:send_MAP_ResetSingleMap(mapId )
    WZLog("send_MAP_ResetSingleMap")
    local sender = Protocol:getSender( Protocol.MAIN_SINGLEMAP, Protocol.MAP_ResetSingleMap )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( mapId )    -- 副本Id
    SendProtocol(sender,false) --true:showLoading
end

--@brief    单人副本战斗记录（MAP_RefreshMapRecord = 32）
function ProtocolProcessorSingleMap:send_MAP_RefreshMapRecord(mapId )
    WZLog("send_MAP_RefreshMapRecord")
    local sender = Protocol:getSender( Protocol.MAIN_SINGLEMAP, Protocol.MAP_RefreshMapRecord )
    if sender==nil then WZLog("sender == nil") return end
    sender:writeInt( mapId )    -- 副本id
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取训练营信息（MAP_TrainMes = 34）
function ProtocolProcessorSingleMap:send_MAP_TrainMes( )
    WZLog("send_MAP_TrainMes")
    local sender = Protocol:getSender( Protocol.MAIN_SINGLEMAP, Protocol.MAP_TrainMes )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    扫荡组队副本（MAP_StartRaidsTeam = 36）
function ProtocolProcessorSingleMap:send_MAP_StartRaidsTeam(mapId, times)
    WZLog("send_MAP_StartRaidsTeam")
    local sender = Protocol:getSender( Protocol.MAIN_SINGLEMAP, Protocol.MAP_StartRaidsTeam )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( mapId )    -- 副本id
    sender:writeInt( times )    -- 当前扫荡次数
    SendProtocol(sender,false) --true:showLoading
end

--@brief    当天扫荡组队副本次数（MAP_GetTodayRaidsTeamTimes = 38）
function ProtocolProcessorSingleMap:send_MAP_GetTodayRaidsTeamTimes()
    WZLog("send_MAP_GetTodayRaidsTeamTimes")
    local sender = Protocol:getSender( Protocol.MAIN_SINGLEMAP, Protocol.MAP_GetTodayRaidsTeamTimes )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief	重置日常副本信息（MAP_GetDailyMap = 40）
function ProtocolProcessorSingleMap:send_MAP_GetDailyMap(sectionId )
	WZLog("send_MAP_GetDailyMap")
	local sender = Protocol:getSender( Protocol.MAIN_SINGLEMAP, Protocol.MAP_GetDailyMap )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( sectionId )	-- 章节ID
	SendProtocol(sender,false) --true:showLoading
end

--@brief    扫荡日常副本（MAP_StartRaidsDaily = 41）
function ProtocolProcessorSingleMap:send_MAP_StartRaidsDaily(pointId, times)
    WZLog("send_MAP_StartRaidsDaily")
    local sender = Protocol:getSender( Protocol.MAIN_SINGLEMAP, Protocol.MAP_StartRaidsDaily )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( pointId )    -- 副本Id
    sender:writeInt( times )    -- 扫荡次数
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取自己占领岛屿的信息（MAP_GetLandlordData = 43）
function ProtocolProcessorSingleMap:send_MAP_GetLandlordData()
    WZLog("send_MAP_GetLandlordData")
    local sender = Protocol:getSender( Protocol.MAIN_SINGLEMAP, Protocol.MAP_GetLandlordData )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    指定副本的岛主数据（MAP_GetMapLandlordData = 45）
function ProtocolProcessorSingleMap:send_MAP_GetMapLandlordData(pointId)
    WZLog("send_MAP_GetMapLandlordData", pointId)
    local sender = Protocol:getSender( Protocol.MAIN_SINGLEMAP, Protocol.MAP_GetMapLandlordData )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( pointId )    -- 副本Id
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取英雄塔数据（MAP_GetHeroTowerData = 47）
function ProtocolProcessorSingleMap:send_MAP_GetHeroTowerData()
    WZLog("send_MAP_GetHeroTowerData")
    local sender = Protocol:getSender( Protocol.MAIN_SINGLEMAP, Protocol.MAP_GetHeroTowerData )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    更换英雄塔对手（MAP_ChangeHeroTowerEnemy = 49）
function ProtocolProcessorSingleMap:send_MAP_ChangeHeroTowerEnemy(floor)
    WZLog("send_MAP_ChangeHeroTowerEnemy")
    local sender = Protocol:getSender( Protocol.MAIN_SINGLEMAP, Protocol.MAP_ChangeHeroTowerEnemy )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( floor )    -- 楼层
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取双人爬塔副本排名（BOSSMAPROOM_GetTwoTowerRank = 42）
function ProtocolProcessorSingleMap:send_BOSSMAPROOM_GetTwoTowerRank()
    WZLog("send_BOSSMAPROOM_GetTwoTowerRank")
    local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_GetTwoTowerRank )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    双人爬塔操作（BOSSMAPROOM_TwoTowerOperation= 40）
function ProtocolProcessorSingleMap:send_BOSSMAPROOM_TwoTowerOperation(operationType)
    WZLog("send_BOSSMAPROOM_TwoTowerOperation")
    local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_TwoTowerOperation )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( operationType )    -- 1购买挑战次数 2扫荡 3快速扫荡 4取消扫荡
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取爬塔副本跨服历史排名（MAP_CrossGetTowerRank = 53）
function ProtocolProcessorSingleMap:send_MAP_CrossGetTowerRank()
    WZLog("send_MAP_CrossGetTowerRank")
    local sender = Protocol:getSender( Protocol.MAIN_SINGLEMAP, Protocol.MAP_CrossGetTowerRank)
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取英雄塔副本跨服每日排名（MAP_CrossGetTodayHeroTowerRank = 55）
function ProtocolProcessorSingleMap:send_MAP_CrossGetTodayHeroTowerRank(rType)
    WZLog("send_MAP_CrossGetTodayHeroTowerRank",rType)
    local sender = Protocol:getSender( Protocol.MAIN_SINGLEMAP, Protocol.MAP_CrossGetTodayHeroTowerRank)
    if sender==nil then WZLog("sender == nil") return end

    sender:writeByte( rType )    -- 0本服每日排名  1跨服每日排名
    SendProtocol(sender,false) --true:showLoading
end

--@brief    重置英雄（MAP_ResetHeroTower = 51）
function ProtocolProcessorSingleMap:send_MAP_ResetHeroTower()
    WZLog("send_MAP_ResetHeroTower")
    local sender = Protocol:getSender( Protocol.MAIN_SINGLEMAP, Protocol.MAP_ResetHeroTower)
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end
--@brief    开始一键扫荡（MAP_StartRaidsBatch = 57）
function ProtocolProcessorSingleMap:send_MAP_StartRaidsBatch( ids )
    WZLog("send_MAP_StartRaidsBatch")
    local sender = Protocol:getSender( Protocol.MAIN_SINGLEMAP, Protocol.MAP_StartRaidsBatch )
    if sender==nil then WZLog("sender == nil") return end
    sender:writeInts( ids )
    SendProtocol(sender,false) --true:showLoading
end

--@brief    重置单人副本信息
function ProtocolProcessorSingleMap:send_MAP_ResetSingleMapBatch( ids )
    WZLog("send_MAP_ResetSingleMapBatch")
    local sender = Protocol:getSender( Protocol.MAIN_SINGLEMAP, Protocol.MAP_ResetSingleMapBatch )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInts( ids )
    SendProtocol(sender,false) --true:showLoading
end

--@brief    退出岛主（MAP_QuitLandlord = 60）
function ProtocolProcessorSingleMap:send_MAP_QuitLandlord(mapId)
    WZLog("send_MAP_QuitLandlord",mapId)
    local sender = Protocol:getSender( Protocol.MAIN_SINGLEMAP, Protocol.MAP_QuitLandlord )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt(mapId)  -- 副本id
    SendProtocol(sender,false) --true:showLoading
end

-------------------------------------服务器到客户端协议回调方法模块--------------------------------------

--@brief    获取训练营信息成功（MAP_TrainMesOk = 35）
function ProtocolProcessorSingleMap:parse_MAP_TrainMesOk(completeTrain)
    -- completeTrain : 完成训练营的关卡
    completeTrain = VectorToTable(completeTrain)
    WZLog("ProtocolProcessorSingleMap:parse_MAP_TrainMesOk", Serialize(completeTrain))

    --completeTrain = {1011}
    WndTrainingCamp:setRebateList(completeTrain)
    WndTrainingCamp:update(WndTrainingCamp.indexFirst or 1)
end

--@brief    单人副本战斗记录（MAP_MapRecordOk = 31）
function ProtocolProcessorSingleMap:parse_SINGLEMAP_MapRecordOk()
    WZLog("ProtocolProcessorSingleMap:parse_SINGLEMAP_MapRecordOk")
end

--@brief	获取爬塔副本层奖励（SINGLEMAP_GetTowerRewardOk = 26）
function ProtocolProcessorSingleMap:parse_SINGLEMAP_GetTowerRewardOk()
    WZLog("ProtocolProcessorSingleMap:parse_SINGLEMAP_GetTowerRewardOk")
    if WndTowerSettlement.m_root then
        WndTowerSettlement:GetTowerRewardOk()
    end
    if WndTowerScroll.m_root then
        WndTowerScroll:GetTowerRewardOk()
    end
end


--@brief	挑战单人副本结算
function ProtocolProcessorSingleMap:parse_SINGLEMAP_ChallengeSuccessOk(pointId, passTimes, factor, rewardId, rewardCount, recordFlag)
	-- pointId : 小关卡ID
	-- passTimes : 当日通关次数
	-- factor : 通关条件状态1位条件一，2位条件二，3位条件三
	-- rewardId : 奖励物品id
	-- rewardCount : 奖励物品数量
	WZLog("ProtocolProcessorSingleMap:parse_SINGLEMAP_ChallengeSuccessOk",Serialize(VectorToTable(pointId)),Serialize(VectorToTable(passTimes)),Serialize(VectorToTable(factor)),Serialize(VectorToTable(rewardId)),Serialize(VectorToTable(rewardCount)))
    --CacheCenter:updateSingleCopyData(pointId, passTimes, factor)
    if g_tSingCopyOver == nil then
        g_tSingCopyOver = {}
    end
    g_tSingCopyOver.pointId = pointId
    g_tSingCopyOver.passTimes = passTimes
    g_tSingCopyOver.factor = factor
    g_tSingCopyOver.rewardId = VectorToTable(rewardId)
    g_tSingCopyOver.rewardCount = VectorToTable(rewardCount)
    g_tSingCopyOver.recordFlag = recordFlag
    g_tSingCopyOver.isVideo = false

    g_bSingCopyOver = true

    if WBattleGlobal:getCurrent().m_nNetLoading ~= -1 then
        MsgBoxManager:stopLoadingBoxByMsgId(WBattleGlobal:getCurrent().m_nNetLoading)
        WBattleGlobal:getCurrent().m_nNetLoading = -1
    end
end

--@brief	扫荡成功
function ProtocolProcessorSingleMap:parse_SINGLEMAP_StartRaidsOk(pointId, rewardNum, rewardId, rewardCount)
	-- pointId : 小关卡ID
	-- rewardNum : 关卡获得物品数量
	-- rewardId : 奖励物品id
	-- rewardCount : 奖励物品数量
	WZLog("ProtocolProcessorSingleMap:parse_SINGLEMAP_StartRaidsOk")
    if WndTabooCopyInfo.m_root then
        WndTabooCopyInfo:showSweepResult(pointId, rewardNum, rewardId, rewardCount)
    else
        WndSingleCopyInfo:showSweepResult(pointId, rewardNum, rewardId, rewardCount)
        CacheCenter:updateSingleCopyData(pointId, nil, nil, rewardNum:size())
    end
end

--@brief	重置副本信息成功
function ProtocolProcessorSingleMap:parse_SINGLEMAP_ResetDailyMapOk(mapId, passTime, isOpen, resetTimes)
	-- mapId : 副本Id
	-- passTime : 已挑战次数
	-- isOpen : 是否开启
	-- resetTimes : 已重置次数
	WZLog("ProtocolProcessorSingleMap:parse_SINGLEMAP_ResetDailyMapOk")
    CacheCenter:updateDailyCopyData(mapId, passTime, isOpen, resetTimes)
    --WndResetCopy:resetSuccess()
end

--@brief    获取爬塔副本排名（MAP_GetTowerRankOk = 18）
function ProtocolProcessorSingleMap:parse_MAP_GetTowerRankOk(topFloor, myRank, platerId, playerLevel, playerSex, playerName, playerGuild, playerFloor, headId, faceId, vipLevel,headColors)
    -- topFloor : 我的最高记录层数
    -- myRank : 我的排名
    -- platerId : 玩家id
    -- playerLevel : 玩家等级
    -- playerSex : 玩家性别（0男，1女）
    -- playerName : 玩家名称
    -- playerGuild : 玩家公会
    -- playerFloor : 玩家最高记录层数
    -- headId : 玩家头部Id
    -- faceId : 玩家脸部Id
    -- vipLevel : vip等级
    WZLog("ProtocolProcessorSingleMap:parse_MAP_GetTowerRankOk",
        "\ntopFloor",Serialize(VectorToTable(topFloor)),
        "\nmyRank",Serialize(VectorToTable(myRank)),
        "\nplaterId",Serialize(VectorToTable(platerId)),
        "\nplayerLevel",Serialize(VectorToTable(playerLevel)),
        "\nplayerSex",Serialize(VectorToTable(playerSex)),
        "\nplayerName",Serialize(VectorToTable(playerName)),
        "\nplayerGuild",Serialize(VectorToTable(playerGuild)),
        "\nplayerFloor",Serialize(VectorToTable(playerFloor)),
        "\nheadId",Serialize(VectorToTable(headId)),
        "\nfaceId",Serialize(VectorToTable(faceId)),
        "\nvipLevel",Serialize(VectorToTable(vipLevel)),
        "\nheadColors",Serialize(VectorToTable(headColors)))
    if WndTowerRank.m_root then
        WndTowerRank:getTowerRankOk(topFloor, myRank, VectorToTable(platerId), VectorToTable(playerLevel), VectorToTable(playerSex), VectorToTable(playerName), VectorToTable(playerGuild), VectorToTable(playerFloor), VectorToTable(headId), VectorToTable(faceId),VectorToTable(vipLevel),VectorToTable(headColors))
    end

    if WndTowerScroll.m_root then
        WndTowerScroll:getTowerRankOk(topFloor, myRank, VectorToTable(platerId), VectorToTable(playerLevel), VectorToTable(playerSex), VectorToTable(playerName), VectorToTable(playerGuild), VectorToTable(playerFloor), VectorToTable(headId), VectorToTable(faceId),VectorToTable(vipLevel),VectorToTable(headColors))
    end

end


-- --@brief	返回扫荡状态
-- function ProtocolProcessorSingleMap:parse_SINGLEMAP_GetRaidsTowerInfoOk(state, remainTime)
-- 	-- state : 扫荡状态 0：未开始，1进行中
-- 	-- remainTime : 剩余秒数
-- 	WZLog("ProtocolProcessorSingleMap:parse_SINGLEMAP_GetRaidsTowerInfoOk", state, remainTime)
--     WndTowerScroll:getRaidsTowerInfoOk(state, remainTime)
-- end

--@brief	扫荡成功
function ProtocolProcessorSingleMap:parse_SINGLEMAP_CompleteRaidsTowerOk(startFloor, endFloor, rewardId, rewardCount)
	-- startFloor : 开始扫荡层数
	-- endFloor : 结束扫荡层数
	-- rewardId : 奖励物品id
	-- rewardCount : 奖励物品数量
	WZLog("ProtocolProcessorSingleMap:parse_SINGLEMAP_CompleteRaidsTowerOk")
    WndTowerScroll:completeRaidsTowerOk(startFloor, endFloor, VectorToTable(rewardId), VectorToTable(rewardCount))

end

--@brief	开始挑战成功
function ProtocolProcessorSingleMap:parse_SINGLEMAP_StartChallengeOk(mapId, mapType, itemId)
	-- mapId : 地图Id
	-- mapType : 地图类型

    itemId = VectorToTable(itemId)
	WZLog("ProtocolProcessorSingleMap:parse_SINGLEMAP_StartChallengeOk", mapId, mapType, Serialize(itemId))
    
    if mapType == COPYTYPE_SINGLE then --单人副本
        local loadTag = WndSingleCopyInfo:getLoadingTag()
        if loadTag ~= nil then
            WndSingleCopyInfo:resetLoadingTag()
            MsgBoxManager:stopLoadingBoxByMsgId(loadTag)
        end
        WndSingleCopy:receiveStartChallengeOk(mapId, mapType, itemId)
    elseif mapType == COPYTYPE_DAILY then --日常副本
        WndSingleCopy:receiveStartChallengeOk(mapId, mapType, itemId)
    elseif mapType == COPYTYPE_TOWER then --爬塔副本
        if not AutoRunBattleConst.AUTO_RUN_BATTLE then
            local cacheData = CacheCenter:getTowerCopyData()
            cacheData.dareTimes = cacheData.dareTimes +1
        end
        WndSingleCopy:receiveStartChallengeOk(mapId, mapType, itemId)
    elseif mapType == COPYTYPE_TRAIN then --训练营副本
        WndSingleCopy:receiveStartChallengeOk(mapId, mapType, itemId)
    elseif mapType == COPYTYPE_SINGLEHOST then --岛主挑战
        WndSingleCopyInfo:receiveStartChallengeOk()
    end
end

--@brief	领取章节奖励成功
function ProtocolProcessorSingleMap:parse_SINGLEMAP_GetSectionRewardOK(sectionId,mapType, rewardNum, rewardId, rewardCount)
	-- sectionId : 章节ID
	-- rewardNum : 领取的奖励数1位奖励一，2位奖励二，3位奖励三
	-- rewardId : 奖励物品id
	-- rewardCount : 奖励物品数量
	WZLog("ProtocolProcessorSingleMap:parse_SINGLEMAP_GetSectionRewardOK = ",sectionId,mapType, rewardNum)
    CacheCenter:updateSingleCopyRewardData(sectionId, rewardNum,mapType)
    WndSingleCopy:getSectionRewardOK(sectionId, rewardNum, VectorToTable(rewardId), VectorToTable(rewardCount))
end

--@brief	获取日常副本信息成（MAP_GetDailyMapOk = 12）
function ProtocolProcessorSingleMap:parse_SINGLEMAP_GetDailyMapOk(section, passTime, mapId, isOpen, resetTimes, count, canRaid)
    -- section : 副本所属玩法
    -- passTime : 已挑战次数
    -- mapId : 副本Id
    -- isOpen : 是否开启
    -- canRaid : 是否可扫荡（1为可扫荡）
    WZLog("ProtocolProcessorSingleMap:parse_SINGLEMAP_GetDailyMapOk", mapId:size(), canRaid:size())
    local section = VectorToTable(section)
    local passTime = VectorToTable(passTime)
    local mapId = VectorToTable(mapId)
    local isOpen = VectorToTable(isOpen)
    local resetTimes = VectorToTable(resetTimes)
    local count = VectorToTable(count)
    local canSweep = VectorToTable(canRaid)
--    local info = {section,passTime,mapId,isOpen }
--    for i = 1, #info do
--        local data = info[i]
--        for k,v in pairs(data) do
--            WZLog("--------------kv-------------------",k,v)
--        end
--    end

    -- 遍历mapId表，根据ID获取到对应的副本section
    local diff = {}
    for i = 1, #mapId do
        local temp = {}
        local index = "id_"..mapId[i]
        temp.mapId = mapId[i]
        temp.isOpen = isOpen[i]
        temp.canSweep = canSweep[i]
        temp.localData = GDatatab_daily_map[index]
        local section = temp.localData.section
        if not diff[section] then diff[section] = {} end
        table.insert(diff[section],temp)
    end

    -- 难度按id排序
    for i = 1, #diff do
        local difficult = diff[i]
        local function sort(d1, d2)
            if d1.mapId < d2.mapId then return true end
            return false
        end
        table.sort(difficult,sort)
    end

    -- 实例 dailyCopy = {{section = 1, passTime = 0, diff = {{mapId = 1001, isOpen = fasle, localData = {}},}, }
    local dailyCopy = {}
    for i = 1, #section do
        local temp = {}
        temp.section = section[i]
        temp.passTime = passTime[i]
		if resetTimes ~= nil then
        temp.resetTimes = resetTimes[i]
		end
        if count ~= nil then
            temp.count = count[i]
        end
        
        temp.diff = diff[i]
        table.insert(dailyCopy,temp)
   end

    CacheCenter:setDailyCopyData(dailyCopy)
    WndDailyCopy:setData(dailyCopy)
--    for o = 1, #dailyCopy do
--        local day = dailyCopy[o]
--        for k,v in pairs(day) do
--            WZLog("-----------------------kv--------------",k,v)
--            if type(v) == "table" then
--                for i,j in pairs(v) do
--                    WZLog("------------ij-------------------",i,j)
--                    if type(j) == "table" then
--                        for m,n in pairs(j) do
--                            WZLog("------------m,n---",m,n)
--                        end
--                    end
--                end
--            end
--        end
--        WZLog("\n")
--    end
end

--@brief    获取好友爬塔信息（MAP_GetFriendTowerInfoOk = 28）
function ProtocolProcessorSingleMap:parse_MAP_GetFriendTowerInfoOk(playerId, playerName, headId, faceId, topFloor,sex,headColors)
    -- playerId : 好友id
    -- playerName : 好友名称
    -- headId : 玩家头部Id
    -- faceId : 玩家脸部Id
    -- topFloor : 最高记录层数
    WZLog("ProtocolProcessorSingleMap:parse_MAP_GetFriendTowerInfoOk")
    WndTowerScroll:getFriendsTowerInfoOk(VectorToTable(playerId), VectorToTable(playerName), VectorToTable(headId), VectorToTable(faceId), VectorToTable(topFloor),VectorToTable(sex),VectorToTable(headColors))
   
end

--@brief    单人副本战斗记录（MAP_RefreshMapRecordOk = 33）
function ProtocolProcessorSingleMap:parse_MAP_RefreshMapRecordOk(id, faceId, headId, name, level,playerId,sex,headColors)
    -- id : 战斗唯一标示
    -- faceId : 脸部Id
    -- headId : 头部Id
    -- name : 名字
    -- level : 等级
    WZLog("ProtocolProcessorSingleMap:parse_MAP_RefreshMapRecordOk")
    if id ~= nil and faceId ~= nil and headId ~= nil and name ~= nil and  level ~= nil and playerId ~= nil and sex ~= nil then
        WndSingleCopyInfo:setVideoInfo(VectorToTable(id),VectorToTable(faceId),VectorToTable(headId),VectorToTable(name),VectorToTable(level),VectorToTable(playerId),VectorToTable(sex),VectorToTable(headColors))
    end
end

--@brief    扫荡成功（MAP_StartRaidsTeamOk = 37）
function ProtocolProcessorSingleMap:parse_MAP_StartRaidsTeamOk(pointId, rewardNum, rewardId, rewardCount,flopId,flopCount, times, flopRebate)
    -- pointId : 小关卡ID
    -- rewardNum : 关卡获得物品数量
    -- rewardId : 奖励物品id
    -- rewardCount : 奖励物品数量
    -- times : 本次扫荡次数
    -- flopRebate : 组队翻牌折扣
    WZLog("ProtocolProcessorSingleMap:parse_MAP_StartRaidsTeamOk")
    WndTeamCopySweep:sweepSuccess(pointId,VectorToTable(rewardNum),VectorToTable(rewardId),VectorToTable(rewardCount),VectorToTable(flopId),VectorToTable(flopCount), times, flopRebate)
end

--@brief    当天扫荡组队副本次数（MAP_GetTodayRaidsTeamTimesOk = 39）
function ProtocolProcessorSingleMap:parse_MAP_GetTodayRaidsTeamTimesOk(raidsTimes)
    -- raidsTimes : 已扫荡次数
    WZLog("ProtocolProcessorSingleMap:parse_MAP_GetTodayRaidsTeamTimesOk")
    WndTeamCopySweep:setSweepInfo(raidsTimes)
end

--@brief    扫荡日常副本（MAP_StartRaidsDailyOk = 42）
function ProtocolProcessorSingleMap:parse_MAP_StartRaidsDailyOk(pointId, times, rewardId, rewardCount)
    -- pointId : 小关卡ID
    -- times : 本次扫荡的次数
    -- rewardId : 奖励物品id
    -- rewardCount : 奖励物品数量
    WZLog("ProtocolProcessorSingleMap:parse_MAP_StartRaidsDailyOk")

    WndDailyCopy:showSweepResult(pointId, times, VectorToTable(rewardId), VectorToTable(rewardCount))
end

--@brief    获取自己占领岛屿的信息（MAP_GetLandlordDataOk = 44）
function ProtocolProcessorSingleMap:parse_MAP_GetLandlordDataOk(seizeMapId, assistMapId)
    -- seizeMapId : 占领岛屿
    -- assistMapId : 助战岛屿
    WZLog("ProtocolProcessorSingleMap:parse_MAP_GetLandlordDataOk", 
        "\nseizeMapId =",Serialize(VectorToTable(seizeMapId)), 
        "\nassistMapId =",Serialize(VectorToTable(assistMapId))
    )

    WndSingleCopy:getIslandDataOk(VectorToTable(seizeMapId),VectorToTable(assistMapId))
end

--@brief    获取指定岛主副本数据（MAP_GetMapLandlordDataOk = 46）
function ProtocolProcessorSingleMap:parse_MAP_GetMapLandlordDataOk(mapId, landlordId, time, protectTime, revenge, playerId, serverId, name, sex, vipLevel, headId, headColor, faceId, fight, level, landlordMapId)
    -- mapId : 副本id
    -- landlordId : 岛主id 没有岛主时为-1
    -- time : 占领时间(秒)
    -- protectTime : 岛主剩余保护时间
    -- revenge : 是否可复仇 1可复仇
    -- playerId : 玩家id
    -- serverId : 服务器id
    -- name : 玩家名字
    -- sex : 姓别
    -- vipLevel : vip等级
    -- headId : 头id
    -- headColor : 头颜色
    -- faceId : 脸id
    -- fight : 战力
    -- level : 等级
    -- landlordMapId : 玩家占领中的副本
    WZLog("ProtocolProcessorSingleMap:parse_MAP_GetMapLandlordDataOk", 
        "\nmapId",Serialize(VectorToTable(mapId)), 
        "\nlandlordId",Serialize(VectorToTable(landlordId)), 
        "\ntime",Serialize(VectorToTable(time)), 
        "\nprotectTime",Serialize(VectorToTable(protectTime)), 
        "\nrevenge",Serialize(VectorToTable(revenge)), 
        "\nplayerId",Serialize(VectorToTable(playerId)), 
        "\nserverId",Serialize(VectorToTable(serverId)), 
        "\nname",Serialize(VectorToTable(name)), 
        "\nsex",Serialize(VectorToTable(sex)), 
        "\nvipLevel",Serialize(VectorToTable(vipLevel)), 
        "\nheadId",Serialize(VectorToTable(headId)), 
        "\nheadColor",Serialize(VectorToTable(headColor)), 
        "\nfaceId",Serialize(VectorToTable(faceId)), 
        "\nfight",Serialize(VectorToTable(fight)),
        "\nlevel",Serialize(VectorToTable(level)),
        "\nlandlordMapId",Serialize(VectorToTable(landlordMapId)))


    if WndSingleCopyInfo.m_root then
        WndSingleCopyInfo:setIslangHostInfo(mapId, landlordId, time, protectTime, revenge, VectorToTable(playerId), VectorToTable(serverId), VectorToTable(name), VectorToTable(sex), VectorToTable(vipLevel), VectorToTable(headId), VectorToTable(headColor), VectorToTable(faceId), VectorToTable(fight), VectorToTable(level), VectorToTable(landlordMapId))
    end
    if WndIslandOwnerRevenge.m_root then
        WndIslandOwnerRevenge:counterattackCallback(mapId, landlordId, time, protectTime, revenge, VectorToTable(playerId), VectorToTable(serverId), VectorToTable(name), VectorToTable(sex), VectorToTable(vipLevel), VectorToTable(headId), VectorToTable(headColor), VectorToTable(faceId), VectorToTable(fight), VectorToTable(level), VectorToTable(landlordMapId))
    end
end

--@brief    获取英雄塔数据（MAP_GetHeroTowerDataOk = 48）
function ProtocolProcessorSingleMap:parse_MAP_GetHeroTowerDataOk(floor, hp, power, buffId, resetTimes, enemy, refreshTimes, sweepReward)
    -- floor : 所处层
    -- hp : 玩家当前剩余血量
    -- power : 当前怒气
    -- buffId : buffId
    -- resetTimes : 重置次数
    -- enemy : 对手玩家数据json表示
    -- refreshTimes : 刷新次数
    -- sweepReward : 扫荡奖励
    WZLog("ProtocolProcessorSingleMap:parse_MAP_GetHeroTowerDataOk")
    WndHeroTower:getHeroTowerDataOK(floor, hp, power, buffId, VectorToTable(enemy), VectorToTable(refreshTimes), resetTimes, VectorToTable(sweepReward))
end

--@brief    更换英雄塔对手（MAP_ChangeHeroTowerEnemyOk = 50）
function ProtocolProcessorSingleMap:parse_MAP_ChangeHeroTowerEnemyOk(floor, enemy)
    -- floor : 楼层
    -- enemy : 对手玩家数据json表示
    WZLog("ProtocolProcessorSingleMap:parse_MAP_ChangeHeroTowerEnemyOk")

    WndHeroTower:refreshEnemyDataOK(floor, enemy)
end

--@brief    双人爬塔操作（BOSSMAPROOM_TwoTowerOperationOk =41）
function ProtocolProcessorSingleMap:parse_BOSSMAPROOM_TwoTowerOperationOk(result, itemId, itemNum, startFloor, endFloor, operateType)
    -- result : 结果
    -- itemId : 奖励物品Id
    -- itemNum : 奖励物品数量
    -- operateType : 1购买挑战次数 2扫荡 3快速扫荡 4取消扫荡
    WZLog("ProtocolProcessorSingleMap:parse_BOSSMAPROOM_TwoTowerOperationOk")

    if operateType == 3 or operateType == 4 then 
        WndTowerScroll:completeRaidsTowerOk(startFloor, endFloor, VectorToTable(itemId), VectorToTable(itemNum))
    end
end

--@brief    获取双人爬塔副本排名（BOSSMAPROOM_GetTwoTowerRankOk = 43）
function ProtocolProcessorSingleMap:parse_BOSSMAPROOM_GetTwoTowerRankOk(topFloor, myRank, platerId, playerLevel, playerSex, playerName, playerGuild, playerFloor, headId, faceId, vipLevel,headColors)
    -- topFloor : 我的最高记录层数
    -- myRank : 我的排名
    -- platerId : 玩家id
    -- playerLevel : 玩家等级
    -- playerSex : 玩家性别（0男，1女）
    -- playerName : 玩家名称
    -- playerGuild : 玩家公会
    -- playerFloor : 玩家最高记录层数
    -- headId : 玩家头部Id
    -- faceId : 玩家脸部Id
    -- vipLevel : vip等级
    WZLog("ProtocolProcessorSingleMap:parse_BOSSMAPROOM_GetTwoTowerRankOk")
    if WndTowerRank.m_root then
        WndTowerRank:getTowerRankOk(topFloor, myRank, VectorToTable(platerId), VectorToTable(playerLevel), VectorToTable(playerSex), VectorToTable(playerName), VectorToTable(playerGuild), VectorToTable(playerFloor), VectorToTable(headId), VectorToTable(faceId),VectorToTable(vipLevel),VectorToTable(headColors))
    end
    
    if WndTowerScroll.m_root then
        WndTowerScroll:getTowerRankOk(topFloor, myRank, VectorToTable(platerId), VectorToTable(playerLevel), VectorToTable(playerSex), VectorToTable(playerName), VectorToTable(playerGuild), VectorToTable(playerFloor), VectorToTable(headId), VectorToTable(faceId),VectorToTable(vipLevel),VectorToTable(headColors))
    end

end

--@brief    获取爬塔副本跨服历史排名（MAP_CrossGetTowerRankOK = 54）
function ProtocolProcessorSingleMap:parse_MAP_CrossGetTowerRankOK(topFloor, myRank, platerId, playerLevel, playerSex, playerName, playerGuild, playerFloor, headId, faceId, vipLevel,headColors, serverId)
    -- topFloor : 我的最高记录层数
    -- myRank : 我的排名
    -- platerId : 玩家id
    -- playerLevel : 玩家等级
    -- playerSex : 玩家性别（0男，1女）
    -- playerName : 玩家名称
    -- playerGuild : 玩家公会
    -- playerFloor : 玩家最高记录层数
    -- headId : 玩家头部Id
    -- faceId : 玩家脸部Id
    -- vipLevel : vip等级
    -- serverId : 服务器Id
    WZLog("ProtocolProcessorSingleMap:parse_MAP_CrossGetTowerRankOK")
    WndTowerRank:getTowerHistoryRankOk(1, topFloor, myRank, VectorToTable(platerId), VectorToTable(playerLevel), VectorToTable(playerSex), VectorToTable(playerName), VectorToTable(playerGuild), VectorToTable(playerFloor), VectorToTable(headId), VectorToTable(faceId),VectorToTable(vipLevel),VectorToTable(headColors), VectorToTable(serverId))
end

--@brief    获取英雄塔副本跨服每日排名（MAP_CrossGetTodayHeroTowerRankOK = 56）
function ProtocolProcessorSingleMap:parse_MAP_CrossGetTodayHeroTowerRankOK(rType, topFloor, myRank, platerId, playerLevel, playerSex, playerName, playerGuild, playerFloor, headId, faceId, vipLevel,headColors, serverId)
    -- rType : 0本服每日排名  1跨服每日排名
    -- topFloor : 我的最高记录层数
    -- myRank : 我的排名
    -- platerId : 玩家id
    -- playerLevel : 玩家等级
    -- playerSex : 玩家性别（0男，1女）
    -- playerName : 玩家名称
    -- playerGuild : 玩家公会
    -- playerFloor : 玩家最高记录层数
    -- headId : 玩家头部Id
    -- faceId : 玩家脸部Id
    -- vipLevel : vip等级
    -- serverId : 服务器Id
    WZLog("ProtocolProcessorSingleMap:parse_MAP_CrossGetTodayHeroTowerRankOK",
        "\nrType",Serialize(VectorToTable(rType)),
        "\ntopFloor",Serialize(VectorToTable(topFloor)),
        "\nmyRank",Serialize(VectorToTable(myRank)),
        "\nplaterId",Serialize(VectorToTable(platerId)),
        "\nplayerLevel",Serialize(VectorToTable(playerLevel)),
        "\nplayerSex",Serialize(VectorToTable(playerSex)),
        "\nplayerName",Serialize(VectorToTable(playerName)),
        "\nplayerGuild",Serialize(VectorToTable(playerGuild)),
        "\nplayerFloor",Serialize(VectorToTable(playerFloor)),
        "\nheadId",Serialize(VectorToTable(headId)),
        "\nfaceId",Serialize(VectorToTable(faceId)),
        "\nvipLevel",Serialize(VectorToTable(vipLevel)),
        "\nheadColors",Serialize(VectorToTable(headColors)),
        "\nserverId",Serialize(VectorToTable(serverId)))
    if WndTowerRank.m_root then
        WndTowerRank:getTowerHistoryRankOk(rType, topFloor, myRank, VectorToTable(platerId), VectorToTable(playerLevel), VectorToTable(playerSex), VectorToTable(playerName), VectorToTable(playerGuild), VectorToTable(playerFloor), VectorToTable(headId), VectorToTable(faceId),VectorToTable(vipLevel),VectorToTable(headColors), VectorToTable(serverId))
    end

    if WndHeroTower.m_root then
        WndHeroTower:getTowerHistoryRankOk(rType, topFloor, myRank, VectorToTable(platerId), VectorToTable(playerLevel), VectorToTable(playerSex), VectorToTable(playerName), VectorToTable(playerGuild), VectorToTable(playerFloor), VectorToTable(headId), VectorToTable(faceId),VectorToTable(vipLevel),VectorToTable(headColors), VectorToTable(serverId))
    end

end

--@brief    重置英雄（MAP_ResetHeroTowerOk = 52）
function ProtocolProcessorSingleMap:parse_MAP_ResetHeroTowerOk(hp, power)
    WZLog("ProtocolProcessorSingleMap:parse_MAP_ResetHeroTowerOk")

    WndHeroTower:resetHeroHPSuccess(hp, power)
end
--@brief    一键扫荡成功（MAP_StartRaidsBatchOk = 58）
function ProtocolProcessorSingleMap:parse_MAP_StartRaidsBatchOk(pointIds, raidsNum, rewardNum, rewardId, rewardCount)
    -- pointIds : 小关卡ID
    -- raidsNum : 扫荡次数
    -- rewardNum : 关卡对应获得物品种类数量
    -- rewardId : 奖励物品id
    -- rewardCount : 奖励物品数量
    WZLog("ProtocolProcessorSingleMap:parse_MAP_StartRaidsBatchOk")
    local tRaidsNum = VectorToTable(raidsNum)
    WZLog("tRaidsNum....: ",Serialize(tRaidsNum))
    if next(tRaidsNum) ~= nil then
        local ids = VectorToTable(pointIds)
        for i=1, #tRaidsNum do
            CacheCenter:updateSingleCopyData(ids[i], nil, nil, tRaidsNum[i])
        end
        GlobalGame:getBattleEventDispatcher():Dispatch("CLEAR_RESULT_EVENT", pointIds, raidsNum, rewardNum, rewardId, rewardCount)
    else --体力不支的时候
        GlobalGame:getBattleEventDispatcher():Dispatch("CLEAR_NOT_POWER_EVENT")
    end
end
--@brief    重置单人副本信息
function ProtocolProcessorSingleMap:parse_MAP_ResetSingleMapBatch()
    WZLog("ProtocolProcessorSingleMap:parse_MAP_ResetSingleMapBatch")
end
-------------------------------------协议错误处理方法模块--------------------------------------
--@brief    单人副本战斗记录（MAP_MapRecord = 30）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorSingleMap:send_SINGLEMAP_MapRecord_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorSingleMap:send_SINGLEMAP_MapRecord_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_MapRecord, nflag, sMessage)
end

--@brief	开始挑战错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSingleMap:send_SINGLEMAP_StartChallenge_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSingleMap:send_SINGLEMAP_StartChallenge_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_StartChallenge, nflag, sMessage)
    local loadTag = WndSingleCopyInfo:getLoadingTag()
    if loadTag ~= nil then
        WndSingleCopyInfo:resetLoadingTag()
        MsgBoxManager:stopLoadingBoxByMsgId(loadTag)
    end
    MsgBoxManager:showTipBox(sMessage)
    SceneTabooBattle:isOpenLockedScene(true)
end

--@brief	挑战成功错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSingleMap:send_SINGLEMAP_ChallengeSuccess_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSingleMap:send_SINGLEMAP_ChallengeSuccess_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_ChallengeSuccess, nflag, sMessage)

    if g_bSingCopyOver ~= nil then
        if WBattleGlobal:getCurrent().m_nNetLoading then
            MsgBoxManager:stopLoadingBoxByMsgId(WBattleGlobal:getCurrent().m_nNetLoading)
            WBattleGlobal:getCurrent().m_nNetLoading = -1
        end
        MsgBoxManager:showConfirmBox(sMessage, SceneBattle, SceneBattle.leftBattle, MSGBOXLEVEL_NORMAL, nil, true)
        g_bSingCopyOver = nil
    end
end

--@brief	开始扫荡错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSingleMap:send_SINGLEMAP_StartRaids_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSingleMap:send_SINGLEMAP_StartRaids_ErrorProcess")
    if WndSweep then
        WndSweep.m_starting = false
    end
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_StartRaids, nflag, sMessage)
    MsgBoxManager:showTipBox(sMessage)
    WndSingleCopyInfo:updateSweepStatus()
end

--@brief	重置副本信息错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSingleMap:send_SINGLEMAP_ResetDailyMap_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSingleMap:send_SINGLEMAP_ResetDailyMap_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_ResetDailyMap, nflag, sMessage)
    MsgBoxManager:showTipBox(sMessage)
end

--@brief	获取爬塔副本信息错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSingleMap:send_SINGLEMAP_GetTowerInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSingleMap:send_SINGLEMAP_GetTowerInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_GetTowerInfo, nflag, sMessage)
    SceneCopy:closeLoading()
    MsgBoxManager:showTipBox(sMessage)

end

--@brief	获取爬塔副本排名错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSingleMap:send_SINGLEMAP_GetTowerRank_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSingleMap:send_SINGLEMAP_GetTowerRank_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_GetTowerRank, nflag, sMessage)
    MsgBoxManager:showTipBox(sMessage)
end

--@brief	获取扫荡状态错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSingleMap:send_SINGLEMAP_GetRaidsTowerInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSingleMap:send_SINGLEMAP_GetRaidsTowerInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_GetRaidsTowerInfo, nflag, sMessage)
    MsgBoxManager:showTipBox(sMessage)
end

--@brief	扫荡爬塔副本错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSingleMap:send_SINGLEMAP_StartRaidsTower_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSingleMap:send_SINGLEMAP_StartRaidsTower_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_StartRaidsTower, nflag, sMessage)
    MsgBoxManager:showTipBox(sMessage)
end

--@brief	获取爬塔副本层奖励（MAP_GetTowerReward = 25）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSingleMap:send_SINGLEMAP_GetTowerReward_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorSingleMap:send_SINGLEMAP_GetTowerReward_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SINGLEMAP, Protocol.MAP_GetTowerReward, nflag, sMessage)
end

--@brief	完成扫荡错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSingleMap:send_SINGLEMAP_CompleteRaidsTower_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSingleMap:send_SINGLEMAP_CompleteRaidsTower_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_CompleteRaidsTower, nflag, sMessage)
    MsgBoxManager:showTipBox(sMessage)
end

--@brief	重置爬塔副本错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSingleMap:send_SINGLEMAP_ResetTowerMap_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSingleMap:send_SINGLEMAP_ResetTowerMap_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_ResetTowerMap, nflag, sMessage)
    MsgBoxManager:showTipBox(sMessage)
end

--@brief	领取章节奖励错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSingleMap:send_SINGLEMAP_GetSectionReward_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSingleMap:send_SINGLEMAP_GetSectionReward_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_GetSectionReward, nflag, sMessage)
     self.m_bGetRewardItems = false
end

--@brief	获取日常副本信息（MAP_GetDailyMap = 11）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSingleMap:send_SINGLEMAP_GetDailyMap_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorSingleMap:send_SINGLEMAP_GetDailyMap_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_GetDailyMap, nflag, sMessage)
end

--@brief    获取好友爬塔信息（MAP_GetFriendTowerInfo = 27）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorSingleMap:send_MAP_GetFriendTowerInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorSingleMap:send_MAP_GetFriendTowerInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SINGLEMAP, Protocol.MAP_GetFriendTowerInfo, nflag, sMessage)
end


--@brief    重置单人副本信息（MAP_ResetSingleMap = 29）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorSingleMap:send_MAP_ResetSingleMap_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorSingleMap:send_MAP_ResetSingleMap_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SINGLEMAP, Protocol.MAP_ResetSingleMap, nflag, sMessage)
    WndSingleCopyInfo:resetLoadingTag()
end

--@brief    单人副本战斗记录（MAP_RefreshMapRecord = 32）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorSingleMap:send_MAP_RefreshMapRecord_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorSingleMap:send_MAP_RefreshMapRecord_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SINGLEMAP, Protocol.MAP_RefreshMapRecord, nflag, sMessage)
end

--@brief    获取训练营信息（MAP_TrainMes = 34）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorSingleMap:send_MAP_TrainMes_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorSingleMap:send_MAP_TrainMes_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SINGLEMAP, Protocol.MAP_TrainMes, nflag, sMessage)
end

--@brief    扫荡组队副本（MAP_StartRaidsTeam = 36）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorSingleMap:send_MAP_StartRaidsTeam_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorSingleMap:send_MAP_StartRaidsTeam_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SINGLEMAP, Protocol.MAP_StartRaidsTeam, nflag, sMessage)
    WndTeamCopySweep:setSweepStats(false)
    WndTeamCopySweep:closeLoadingB()
end

--@brief    当天扫荡组队副本次数（MAP_GetTodayRaidsTeamTimes = 38）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorSingleMap:send_MAP_GetTodayRaidsTeamTimes_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorSingleMap:send_MAP_GetTodayRaidsTeamTimes_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SINGLEMAP, Protocol.MAP_GetTodayRaidsTeamTimes, nflag, sMessage)
    WndTeamCopySweep:closeLoadingB()
end

--@brief	重置日常副本信息（MAP_GetDailyMap = 40）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSingleMap:send_MAP_GetDailyMap_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSingleMap:send_MAP_GetDailyMap_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SINGLEMAP, Protocol.MAP_GetDailyMap, nflag, sMessage)
end

--@brief    扫荡日常副本（MAP_StartRaidsDaily = 41）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorSingleMap:send_MAP_StartRaidsDaily_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorSingleMap:send_MAP_StartRaidsDaily_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SINGLEMAP, Protocol.MAP_StartRaidsDaily, nflag, sMessage)

    WndDailyCopy:resetSweepLab(true)
end

--@brief    获取自己占领岛屿的信息（MAP_GetLandlordData = 43）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorSingleMap:send_MAP_GetLandlordData_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorSingleMap:send_MAP_GetLandlordData_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SINGLEMAP, Protocol.MAP_GetLandlordData, nflag, sMessage)
end

--@brief    指定副本的岛主数据（MAP_GetMapLandlordData = 45）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorSingleMap:send_MAP_GetMapLandlordData_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorSingleMap:send_MAP_GetMapLandlordData_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SINGLEMAP, Protocol.MAP_GetMapLandlordData, nflag, sMessage)
end

--@brief    获取英雄塔数据（MAP_GetHeroTowerData = 47）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorSingleMap:send_MAP_GetHeroTowerData_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorSingleMap:send_MAP_GetHeroTowerData_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SINGLEMAP, Protocol.MAP_GetHeroTowerData, nflag, sMessage)
end

--@brief    更换英雄塔对手（MAP_ChangeHeroTowerEnemy = 49）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorSingleMap:send_MAP_ChangeHeroTowerEnemy_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorSingleMap:send_MAP_ChangeHeroTowerEnemy_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SINGLEMAP, Protocol.MAP_ChangeHeroTowerEnemy, nflag, sMessage)
end

--@brief   重置英雄（MAP_ResetHeroTower = 51）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorSingleMap:send_MAP_ResetHeroTower_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorSingleMap:send_MAP_ResetHeroTower_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SINGLEMAP, Protocol.MAP_ResetHeroTower, nflag, sMessage)
end

--@brief    双人爬塔操作（BOSSMAPROOM_TwoTowerOperation= 40）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorSingleMap:send_BOSSMAPROOM_TwoTowerOperation_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorSingleMap:send_BOSSMAPROOM_TwoTowerOperation_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_TwoTowerOperation, nflag, sMessage)
end


--@brief    获取双人爬塔副本排名（BOSSMAPROOM_GetTwoTowerRank = 42）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorSingleMap:send_BOSSMAPROOM_GetTwoTowerRank_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorSingleMap:send_BOSSMAPROOM_GetTwoTowerRank_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_GetTwoTowerRank, nflag, sMessage)
end

--@brief    领获取爬塔副本跨服历史排名（MAP_CrossGetTowerRank = 53）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorSingleMap:send_MAP_CrossGetTowerRank_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorSingleMap:send_MAP_CrossGetTowerRank_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SINGLEMAP, Protocol.MAP_CrossGetTowerRank, nflag, sMessage)
end

--@brief    获取英雄塔副本跨服每日排名（MAP_CrossGetTodayHeroTowerRank = 55）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorSingleMap:send_MAP_CrossGetTodayHeroTowerRank_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorSingleMap:send_MAP_CrossGetTodayHeroTowerRank_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SINGLEMAP, Protocol.MAP_CrossGetTodayHeroTowerRank, nflag, sMessage)
end
--@brief    开始一键扫荡（MAP_StartRaidsBatch = 57）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorSingleMap:send_MAP_StartRaidsBatch_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorSingleMap:send_MAP_StartRaidsBatch_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SINGLEMAP, Protocol.MAP_StartRaidsBatch, nflag, sMessage)
end
--@brief    重置单人副本信息错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorSingleMap:send_MAP_ResetSingleMapBatch_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorSingleMap:send_MAP_ResetSingleMapBatch_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SINGLEMAP, Protocol.MAP_ResetSingleMapBatch, nflag, sMessage)
end

--@brief    退出岛主（MAP_QuitLandlord = 60）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorSingleMap:send_MAP_QuitLandlord_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorSingleMap:parse_MAP_QuitLandlord_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SINGLEMAP, Protocol.MAP_QuitLandlord, nflag, sMessage)
end
