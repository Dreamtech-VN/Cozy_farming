--ProtocolProcessorWndCharmRank.lua
--@brief	排行榜相关协议
--@date  	2016/9/24
--@author 	mpt
--@note 	魅力空间相关协议


ProtocolProcessorWndCharmRank = ProtocolProcessorBase:new()

-------------------------------------公有方法模块--------------------------------------
--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorWndCharmRank:regAll()

    --@brief	获取排行榜数据（RANK_GetRankRecord = 1）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_RANK, Protocol.RANK_GetRankRecord, "ProtocolProcessorWndCharmRank:send_RANK_GetRankRecord_ErrorProcess", "is" )
    --@brief    排行榜信息（RANK_GetRankRecordOK = 2）
    self:regProtocolCallbackFunction( Protocol.MAIN_RANK, Protocol.RANK_GetRankRecordOK, "ProtocolProcessorWndCharmRank:parse_RANK_GetRankRecordOK", "tvtvivivsvivivtvivsvsvsvsvsvsvsvtvsvivsvivivs")
    --@brief    获取个人排行榜数据（RANK_GetPlayerRankOK = 4）
    self:regProtocolCallbackFunction( Protocol.MAIN_RANK, Protocol.RANK_GetPlayerRankOK, "ProtocolProcessorWndCharmRank:parse_RANK_GetPlayerRankOK", "iiittt")
    --@brief    获取个人排行榜数据（RANK_GetPlayerRank = 3）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_RANK, Protocol.RANK_GetPlayerRank, "ProtocolProcessorWndCharmRank:send_RANK_GetPlayerRank_ErrorProcess", "is" )

end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorWndCharmRank:unregAll()
    self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief	获取魅力空间鲜花排行榜数据（RANK_GetRankRecord = 1）
function ProtocolProcessorWndCharmRank:send_RANK_GetRankRecord(rankType )
    WZLog("send_RANK_GetRankRecord",rankType)
    local sender = Protocol:getSender( Protocol.MAIN_RANK, Protocol.RANK_GetRankRecord )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeByte( rankType )-- 排行榜类型【26、鲜花周榜,27、鲜花总榜】
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取个人排行榜数据（RANK_GetPlayerRank = 3）
function ProtocolProcessorWndCharmRank:send_RANK_GetPlayerRank(rankType )
    WZLog("send_RANK_GetPlayerRank")
    local sender = Protocol:getSender( Protocol.MAIN_RANK, Protocol.RANK_GetPlayerRank )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeByte( rankType )    -- 排行榜类型【26、鲜花周榜,27、鲜花总榜】
    SendProtocol(sender,false) --true:showLoading
end

-------------------------------------服务器到客户端协议回调方法模块--------------------------------------
--@brief    鲜花排行榜信息（RANK_GetRankRecordOK = 2）
function ProtocolProcessorWndCharmRank:parse_RANK_GetRankRecordOK(rankType, trendRank, ranking, playerId, name, faceId, headId, sex, level, param1, param2, param3, param4, param5, param6, param7, vipLevel, param8, headColor, param9, headEffectId, wifeHeadEffectId, qqHallInfo)
    -- rankType : 排行榜类型
    -- trendRank : 排行趋势0、不变，1、上升，2、下降
    -- ranking : 名次
    -- playerId : 从左向右，第一个显示玩家
    -- name : 从左向右，第一个显示名称
    -- faceId : 玩家脸
    -- headId : 玩家头
    -- sex : 性别
    -- level : 等级【人物等级】
    -- param1 : 【玩家战力、宠物头像、竞技等级、成就数量、师德等级、妻子id】
    -- param2 : 【公会名称、宠物等级、竞技积分、当前称号、师德经验、妻子名称】
    -- param3 : 【宠物名称、竞技胜利场数、出徒数量、妻子等级】
    -- param4 : 【宠物战斗力、竞技总场、妻子头】
    -- param5 : 【妻子脸, 宠物品质】
    -- param6 : 【恩爱等级】
    -- param7 : 【恩爱经验】
    -- vipLevel : vip等级
    -- param8 : 妻子vip等级
    -- headColor : 头颜色索引
    -- param9 : 妻子头颜色索引
    -- headEffectId : 玩家头像框特效
    -- wifeHeadEffectId : 妻子头像框特效
    -- qqHallInfo : qq大厅玩家蓝钻数据
    WZLog("ProtocolProcessorWndCharmRank:parse_RANK_GetRankRecordOK",
 "\nrankType",Serialize(VectorToTable(rankType)),
 "\ntrendRank",Serialize(VectorToTable(trendRank)),
 "\nranking",Serialize(VectorToTable(ranking)),
 "\nplayerId",Serialize(VectorToTable(playerId)),
 "\nname",Serialize(VectorToTable(name)),
 "\nfaceId",Serialize(VectorToTable(faceId)),
 "\nheadId",Serialize(VectorToTable(headId)),
 "\nsex",Serialize(VectorToTable(sex)),
 "\nlevel",Serialize(VectorToTable(level)),
 "\nparam1",Serialize(VectorToTable(param1)),
 "\nparam2",Serialize(VectorToTable(param2)),
 "\nparam3",Serialize(VectorToTable(param3)),
 "\nparam4",Serialize(VectorToTable(param4)),
 "\nparam5",Serialize(VectorToTable(param5)),
 "\nparam6",Serialize(VectorToTable(param6)),
 "\nparam7",Serialize(VectorToTable(param7)),
 "\nvipLevel",Serialize(VectorToTable(vipLevel)),
 "\nparam8",Serialize(VectorToTable(param8)),
 "\nheadColor",Serialize(VectorToTable(headColor)),
 "\nparam9",Serialize(VectorToTable(param9)))
    -- 24 ,28,29 -- 分别为高级，初级，中级排行,25高级,30初级,31中级为竞技场历史排行
    -- if rankType == 24 or rankType == 28 or rankType == 29 or rankType == 25 or rankType == 30 or rankType == 31 then
    --     --        rankType	byte	排行榜类型
    --     --        trendRank	byte[]	排行趋势0、不变，1、上升，2、下降
    --     --        ranking	int[]	名次
    --     --        playerId	int[]	从左向右，第一个显示玩家
    --     --        name	String[]	从左向右，第一个显示名称
    --     --        faceId	int[]	玩家脸
    --     --        headId	int[]	玩家头
    --     --        sex	byte[]	性别
    --     --        level	int[]	等级【人物等级】
    --     --        param1	String[]	竞技积分
    --     --        param2	String[]	竞技场数
    --     --        param3	String[]	竞技胜利场数
    --     local index = {[24] = 3, [28] = 1, [29] = 2, [25] = 3,[30] = 1, [31] = 2 }
    --     if rankType == 24 or rankType == 28 or rankType == 29 then
    --         WndAthRank:setRankData(ranking,playerId,name,faceId,headId,sex,level,param1,param2,param3,param4,vipLevel,headColor,index[rankType])
    --     else
    --         WndAthRank:setLastData(ranking,playerId,name,faceId,headId,sex,level,param1,param2,param3,param4,vipLevel,headColor,index[rankType])
    --     end

    -- if rankType == 26 or rankType == 27 then
    --     WndCharmSpace:setData3(VectorToTable(ranking),VectorToTable(playerId),VectorToTable(name),VectorToTable(sex),VectorToTable(level),VectorToTable(param1),VectorToTable(param2),VectorToTable(param3),VectorToTable(param4),VectorToTable(param5),VectorToTable(param6))
    -- elseif rankType == 48 or rankType == 49 then 
    --     WndCharmSpace:setDataFashion(VectorToTable(ranking),VectorToTable(playerId),VectorToTable(name), VectorToTable(faceId), VectorToTable(headId),VectorToTable(sex),VectorToTable(level),VectorToTable(param1),VectorToTable(param2),VectorToTable(param3),VectorToTable(param4),VectorToTable(param5),VectorToTable(param6),VectorToTable(param7),VectorToTable(vipLevel),VectorToTable(param8),VectorToTable(headColor),VectorToTable(param9))
    -- elseif rankType == 50 or rankType == 51 then 
    --     WndCharmSpace:setData3(VectorToTable(ranking),VectorToTable(playerId),VectorToTable(name),VectorToTable(sex),VectorToTable(level),VectorToTable(param1),VectorToTable(param2),VectorToTable(param3),VectorToTable(param4),VectorToTable(param5),VectorToTable(param6))
    -- end
    if rankType == 26 or rankType == 27 or rankType == 48 or rankType == 49 or rankType == 50 or rankType == 51 or rankType == 57 or rankType == 58 then 
        WndCharmSpace:setDataFashion(VectorToTable(ranking),VectorToTable(playerId),VectorToTable(name), VectorToTable(faceId), VectorToTable(headId),VectorToTable(sex),VectorToTable(level),VectorToTable(param1),VectorToTable(param2),VectorToTable(param3),VectorToTable(param4),VectorToTable(param5),VectorToTable(param6),VectorToTable(param7),VectorToTable(vipLevel),VectorToTable(param8),VectorToTable(headColor),VectorToTable(param9), VectorToTable(qqHallInfo))
    end

end

-- --@brief    获取玩家简单信息（PLAYER_GetSimpleInfoOK = 69）
-- function ProtocolProcessorWndRankList:parse_PLAYER_GetSimpleInfoOK(playerId, name, level, title, fighting, weaponId, headId, faceId, bodyId, wingId, petMessage, sex, guildName, wrshipNum, headColor, bodyColor)
--     -- playerId : 玩家id
--     -- name : 名称
--     -- level : 玩家等级
--     -- title : 称号
--     -- fighting : 战力
--     -- weaponId : 武器
--     -- headId : 头
--     -- faceId : 脸
--     -- bodyId : 身
--     -- wingId : 翅膀
--     -- petMessage : 宠物信息json
--     -- sex : 性别0男，1女
--     -- guildName : 公会名称
--     -- wrshipNum : 被膜拜次数
--     WZLog("ProtocolProcessorWndRankList:parse_PLAYER_GetSimpleInfoOK")
--     WndRankList:setFamousListData(VectorToTable(playerId), VectorToTable(name), VectorToTable(level), VectorToTable(title), VectorToTable(fighting), VectorToTable(weaponId), VectorToTable(headId), VectorToTable(faceId), VectorToTable(bodyId), VectorToTable(wingId), VectorToTable(petMessage), VectorToTable(sex), VectorToTable(guildName), VectorToTable(wrshipNum), VectorToTable(headColor), VectorToTable(bodyColor))
-- end

--@brief    获取个人排行榜数据（RANK_GetPlayerRankOK = 4）
function ProtocolProcessorWndCharmRank:parse_RANK_GetPlayerRankOK(myRank, rankValue, rankExp, myTrendRank, rankType, canWorship)
    -- myRank : 我的排名（没有排名，-1，没有排名）
    -- rankValue : 排名值
    -- rankExp : 第二排名值
    -- myTrendRank : 趋势0、不变，1、上升，2、下降
    -- rankType : 排行榜类型
    -- canWorship : 是否可膜拜1、可膜拜，0、不可膜拜
    WZLog("ProtocolProcessorWndCharmRank:parse_RANK_GetPlayerRankOK",rankType,myRank,rankValue)
    CacheCenter:setMyRankListInfo(myRank, rankValue, rankExp, myTrendRank, rankType, canWorship)
    if rankType == 26 or rankType == 48 or rankType == 50 or rankType == 57 then
        WndCharmSpace:_update2(2)
    elseif rankType == 27 or rankType == 49 or rankType == 51 or rankType == 58 then
        WndCharmSpace:_update2(3)
    end
end

-- --@brief    膜拜成功（RANK_WorshipOK = 6）
-- function ProtocolProcessorWndRankList:parse_RANK_WorshipOK(vigor, result)
--     -- vigor : 体力值
--     -- result : 1、成功，2、失败
--     WZLog("ProtocolProcessorWndRankList:parse_RANK_WorshipOK")
--     WndRankList:hideRedDot(result)
--     CellRankSeat:receiveWorshipOK(vigor, result)
--     ProtocolProcessorSceneCity:send_PLAYER_CancelRedDot(106)
--     GlobalGame.g_tRedPointList.chart = false
-- end

-- --@brief    膜拜日志成功 (RANK_GetWorshipLogOK = 8）
-- function ProtocolProcessorWndRankList:parse_RANK_GetWorshipLogOK(playerName, worshipDate, worshipName)
--     -- playerName : 膜拜者名称
--     -- worshipDate : 膜拜时间（秒）时间戳
--     -- worshipName : 被膜拜者名称
--     WZLog("ProtocolProcessorWndRankList:parse_RANK_GetWorshipLogOK")
--     WndRankList:getWorshipLogOK(VectorToTable(playerName), VectorToTable(worshipDate), VectorToTable(worshipName))
-- end

-------------------------------------协议错误处理方法模块--------------------------------------
--@brief	获取鲜花排行榜数据（RANK_GetRankRecord = 1）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndCharmRank:send_RANK_GetRankRecord_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndCharmRank:send_RANK_GetRankRecord_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_RANK, Protocol.RANK_GetRankRecord, nflag, sMessage)
end

--@brief    获取玩家简单信息（PLAYER_GetSimpleInfo = 68）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
-- function ProtocolProcessorWndRankList:send_PLAYER_GetSimpleInfo_ErrorProcess(nFlag, sMessage)
--     WZLog("ProtocolProcessorWndRankList:send_PLAYER_GetSimpleInfo_ErrorProcess")
--     ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_GetSimpleInfo, nflag, sMessage)
-- end

--@brief    获取个人排行榜数据（RANK_GetPlayerRank = 3）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndCharmRank:send_RANK_GetPlayerRank_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndCharmRank:send_RANK_GetPlayerRank_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_RANK, Protocol.RANK_GetPlayerRank, nflag, sMessage)
end

--@brief    膜拜（RANK_Worship = 5）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
-- function ProtocolProcessorWndRankList:send_RANK_Worship_ErrorProcess(nFlag, sMessage)
--     WZLog("ProtocolProcessorWndRankList:send_RANK_Worship_ErrorProcess")
--     ProtocolErrorProcessor:errorProcess(Protocol.MAIN_RANK, Protocol.RANK_Worship, nflag, sMessage)
-- end

--@brief    膜拜日志（RANK_GetWorshipLog = 7）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
-- function ProtocolProcessorWndRankList:send_RANK_GetWorshipLog_ErrorProcess(nFlag, sMessage)
--     WZLog("ProtocolProcessorWndRankList:send_RANK_GetWorshipLog_ErrorProcess")
--     ProtocolErrorProcessor:errorProcess(Protocol.MAIN_RANK, Protocol.RANK_GetWorshipLog, nflag, sMessage)
-- end


