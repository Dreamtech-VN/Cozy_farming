--ProtocolProcessorWndRankList.lua
--@brief	排行榜相关协议
--@date  	2015/4/23
--@author 	hyq
--@note 	排行榜相关协议


ProtocolProcessorWndRankList = ProtocolProcessorBase:new()

-------------------------------------公有方法模块--------------------------------------
--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorWndRankList:regAll()

    --@brief	获取排行榜数据（RANK_GetRankRecord = 1）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_RANK, Protocol.RANK_GetRankRecord, "ProtocolProcessorWndRankList:send_RANK_GetRankRecord_ErrorProcess", "is" )

    --@brief    排行榜信息（RANK_GetRankRecordOK = 2）
    self:regProtocolCallbackFunction( Protocol.MAIN_RANK, Protocol.RANK_GetRankRecordOK, "ProtocolProcessorWndRankList:parse_RANK_GetRankRecordOK", "tvtvivivsvivivtvivsvsvsvsvsvsvsvtvsvivs")

    --@brief    获取玩家简单信息（PLAYER_GetSimpleInfoOK = 69）
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetSimpleInfoOK, "ProtocolProcessorWndRankList:parse_PLAYER_GetSimpleInfoOK", "vivsvivsvivivivivivivsvtvsvivivi")

    --@brief    获取个人排行榜数据（RANK_GetPlayerRankOK = 4）
    self:regProtocolCallbackFunction( Protocol.MAIN_RANK, Protocol.RANK_GetPlayerRankOK, "ProtocolProcessorWndRankList:parse_RANK_GetPlayerRankOK", "iiittt")

    --@brief    膜拜成功（RANK_WorshipOK = 6）
    self:regProtocolCallbackFunction( Protocol.MAIN_RANK, Protocol.RANK_WorshipOK, "ProtocolProcessorWndRankList:parse_RANK_WorshipOK", "ii")

    --@brief    膜拜日志成功 (RANK_GetWorshipLogOK = 8）
    self:regProtocolCallbackFunction( Protocol.MAIN_RANK, Protocol.RANK_GetWorshipLogOK, "ProtocolProcessorWndRankList:parse_RANK_GetWorshipLogOK", "vsvivs")

    --@brief    获取玩家简单信息（PLAYER_GetSimpleInfo = 68）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetSimpleInfo, "ProtocolProcessorWndRankList:send_PLAYER_GetSimpleInfo_ErrorProcess", "is" )

    --@brief    获取个人排行榜数据（RANK_GetPlayerRank = 3）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_RANK, Protocol.RANK_GetPlayerRank, "ProtocolProcessorWndRankList:send_RANK_GetPlayerRank_ErrorProcess", "is" )

    --@brief    膜拜（RANK_Worship = 5）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_RANK, Protocol.RANK_Worship, "ProtocolProcessorWndRankList:send_RANK_Worship_ErrorProcess", "is" )

    --@brief    膜拜日志（RANK_GetWorshipLog = 7）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_RANK, Protocol.RANK_GetWorshipLog, "ProtocolProcessorWndRankList:send_RANK_GetWorshipLog_ErrorProcess", "is" )
    
    --@brief    获取烟花排行榜（RANK_GetFireworkRank = 9）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_RANK, Protocol.RANK_GetFireworkRank, "ProtocolProcessorWndRankList:send_RANK_GetFireworkRank_ErrorProcess", "is" )

    --@brief    获取烟花排行榜成功 (RANK_GetFireworkRankOK = 10）
    self:regProtocolCallbackFunction( Protocol.MAIN_RANK, Protocol.RANK_GetFireworkRankOK, "ProtocolProcessorWndRankList:parse_RANK_GetFireworkRankOK", "ivivivsvivivtvivtviviivii")

end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorWndRankList:unregAll()
    self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief	获取排行榜数据（RANK_GetRankRecord = 1）
function ProtocolProcessorWndRankList:send_RANK_GetRankRecord(rankType)
    WZLog("send_RANK_GetRankRecord",rankType)
    local sender = Protocol:getSender( Protocol.MAIN_RANK, Protocol.RANK_GetRankRecord )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeByte(rankType)-- 排行榜类型【1、战力榜，2、等级榜，3、宠物榜，4、坐骑榜， 11、战迹榜，12、胜绩榜，13、成就榜,14、公会榜， 21、魅力榜，22、师德榜，23、恩爱榜】
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取玩家简单信息（PLAYER_GetSimpleInfo = 68）
function ProtocolProcessorWndRankList:send_PLAYER_GetSimpleInfo(playerId )
    WZLog("send_PLAYER_GetSimpleInfo")
    local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetSimpleInfo )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInts( playerId )    -- 玩家id
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取个人排行榜数据（RANK_GetPlayerRank = 3）
function ProtocolProcessorWndRankList:send_RANK_GetPlayerRank(rankType )
    WZLog("send_RANK_GetPlayerRank")
    local sender = Protocol:getSender( Protocol.MAIN_RANK, Protocol.RANK_GetPlayerRank )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeByte( rankType )    -- 排行榜类型【1、战力榜，2、等级榜，3、宠物榜，4、坐骑榜， 11、战迹榜，12、胜绩榜，13、成就榜,14、公会榜， 21、魅力榜，22、师德榜，23、恩爱榜】
    SendProtocol(sender,false) --true:showLoading
end

--@brief    膜拜（RANK_Worship = 5）
function ProtocolProcessorWndRankList:send_RANK_Worship(rankType, playerId )
    WZLog("send_RANK_Worship")
    local sender = Protocol:getSender( Protocol.MAIN_RANK, Protocol.RANK_Worship )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeByte( rankType )    -- 排行榜类型【1、战力榜，2、等级榜，3、宠物榜，4、坐骑榜， 12、竞技榜，13、成就榜,14、公会榜， 21、魅力榜，22、师德榜，23、恩爱榜】
    sender:writeInt( playerId ) -- 被膜拜的人
    SendProtocol(sender,false) --true:showLoading
end

--@brief    膜拜日志（RANK_GetWorshipLog = 7）
function ProtocolProcessorWndRankList:send_RANK_GetWorshipLog( )
    WZLog("send_RANK_GetWorshipLog")
    local sender = Protocol:getSender( Protocol.MAIN_RANK, Protocol.RANK_GetWorshipLog )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取烟花排行榜（RANK_GetFireworkRank = 9）
function ProtocolProcessorWndRankList:send_RANK_GetFireworkRank(rankType)
    WZLog("send_RANK_GetFireworkRank")
    local sender = Protocol:getSender( Protocol.MAIN_RANK, Protocol.RANK_GetFireworkRank )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( rankType or 1 ) -- 1.烟花榜 2.点球大战排行榜 3.足球竞猜
    SendProtocol(sender,false) --true:showLoading
end




-------------------------------------服务器到客户端协议回调方法模块--------------------------------------
--@brief    排行榜信息（RANK_GetRankRecordOK = 2）
function ProtocolProcessorWndRankList:parse_RANK_GetRankRecordOK(rankType, trendRank, ranking, playerId, name, faceId, headId, sex, level, param1, param2, param3, param4, param5, param6, param7, vipLevel, param8, headColor, param9)
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
    WZLog("ProtocolProcessorWndRankList:parse_RANK_GetRankRecordOK",rankType,Serialize(VectorToTable(name)))
    -- 24 ,28,29 -- 分别为高级，初级，中级排行,25高级,30初级,31中级为竞技场历史排行.  积分榜:跨服总榜42,跨服历史总榜43,本服总榜44,本服历史总榜45
    if rankType == 24 or rankType == 28 or rankType == 29 or rankType == 25 or rankType == 30 or rankType == 31 or rankType == 32 or rankType == 33 or rankType == 34 or rankType == 35 or rankType == 36 or rankType == 37 or rankType == 42 or rankType == 43 or rankType == 44 or rankType == 45 then
        --        rankType	byte	排行榜类型
        --        trendRank	byte[]	排行趋势0、不变，1、上升，2、下降
        --        ranking	int[]	名次
        --        playerId	int[]	从左向右，第一个显示玩家
        --        name	String[]	从左向右，第一个显示名称
        --        faceId	int[]	玩家脸
        --        headId	int[]	玩家头
        --        sex	byte[]	性别
        --        level	int[]	等级【人物等级】
        --        param1	String[]	竞技积分
        --        param2	String[]	竞技场数
        --        param3	String[]	竞技胜利场数
        
        local index = {[24] = 3, [28] = 1, [29] = 2, [25] = 3,[30] = 1, [31] = 2, [32] = 7,[33] = 5,[34]= 6,[35] = 7,[36] = 5,[37] = 6, [42] = 4,[43] = 4,[44] = 8,[45] = 8}
        if rankType == 24 or rankType == 28 or rankType == 29 or rankType == 32 or rankType == 33 or rankType == 34 or rankType == 42 or rankType == 44 then
            WndAthRank:setRankData(ranking,playerId,name,faceId,headId,sex,level,param1,param2,param3,param4,vipLevel,headColor,index[rankType])
        else
            WndAthRank:setLastData(ranking,playerId,name,faceId,headId,sex,level,param1,param2,param3,param4,vipLevel,headColor,index[rankType])
        end
    elseif rankType == 26 or rankType == 27 then
        WndCharmSpace:setData3(VectorToTable(ranking),VectorToTable(playerId),VectorToTable(name),VectorToTable(sex),VectorToTable(level),VectorToTable(param1),VectorToTable(param2),VectorToTable(param3),VectorToTable(param4),VectorToTable(param5),VectorToTable(param6))
    else
        CacheCenter:setRankListInfo(ranking, playerId, name, faceId, headId, sex, level, param1, param2, param3, param4, param5, param6, param7, rankType, trendRank, vipLevel, param8, headColor, param9)
    end

end

--@brief    获取玩家简单信息（PLAYER_GetSimpleInfoOK = 69）
function ProtocolProcessorWndRankList:parse_PLAYER_GetSimpleInfoOK(playerId, name, level, title, fighting, weaponId, headId, faceId, bodyId, wingId, petMessage, sex, guildName, wrshipNum, headColor, bodyColor)
    -- playerId : 玩家id
    -- name : 名称
    -- level : 玩家等级
    -- title : 称号
    -- fighting : 战力
    -- weaponId : 武器
    -- headId : 头
    -- faceId : 脸
    -- bodyId : 身
    -- wingId : 翅膀
    -- petMessage : 宠物信息json
    -- sex : 性别0男，1女
    -- guildName : 公会名称
    -- wrshipNum : 被膜拜次数
    WZLog("ProtocolProcessorWndRankList:parse_PLAYER_GetSimpleInfoOK")
    WndRankList:setFamousListData(VectorToTable(playerId), VectorToTable(name), VectorToTable(level), VectorToTable(title), VectorToTable(fighting), VectorToTable(weaponId), VectorToTable(headId), VectorToTable(faceId), VectorToTable(bodyId), VectorToTable(wingId), VectorToTable(petMessage), VectorToTable(sex), VectorToTable(guildName), VectorToTable(wrshipNum), VectorToTable(headColor), VectorToTable(bodyColor))
end

--@brief    获取个人排行榜数据（RANK_GetPlayerRankOK = 4）
function ProtocolProcessorWndRankList:parse_RANK_GetPlayerRankOK(myRank, rankValue, rankExp, myTrendRank, rankType, canWorship)
    -- myRank : 我的排名（没有排名，-1，没有排名）
    -- rankValue : 排名值
    -- rankExp : 第二排名值
    -- myTrendRank : 趋势0、不变，1、上升，2、下降
    -- rankType : 排行榜类型
    -- canWorship : 是否可膜拜1、可膜拜，0、不可膜拜
    WZLog("ProtocolProcessorWndRankList:parse_RANK_GetPlayerRankOK",rankType,myRank,rankValue)
    CacheCenter:setMyRankListInfo(myRank, rankValue, rankExp, myTrendRank, rankType, canWorship)
    if rankType == 26 then
        WndCharmSpace:_update2(2)
    elseif rankType == 27 then
        WndCharmSpace:_update2(3)
    end
end

--@brief    膜拜成功（RANK_WorshipOK = 6）
function ProtocolProcessorWndRankList:parse_RANK_WorshipOK(vigor, result)
    -- vigor : 体力值
    -- result : 1、成功，2、失败
    WZLog("ProtocolProcessorWndRankList:parse_RANK_WorshipOK")
    WndRankList:hideRedDot(result)
    CellRankSeat:receiveWorshipOK(vigor, result)
    ProtocolProcessorSceneCity:send_PLAYER_CancelRedDot(106)
    GlobalGame.g_tRedPointList.chart = false
end

--@brief    膜拜日志成功 (RANK_GetWorshipLogOK = 8）
function ProtocolProcessorWndRankList:parse_RANK_GetWorshipLogOK(playerName, worshipDate, worshipName)
    -- playerName : 膜拜者名称
    -- worshipDate : 膜拜时间（秒）时间戳
    -- worshipName : 被膜拜者名称
    WZLog("ProtocolProcessorWndRankList:parse_RANK_GetWorshipLogOK")
    WndRankList:getWorshipLogOK(VectorToTable(playerName), VectorToTable(worshipDate), VectorToTable(worshipName))
end

--@brief    获取烟花排行榜成功 (RANK_GetFireworkRankOK = 10）
function ProtocolProcessorWndRankList:parse_RANK_GetFireworkRankOK(status, ranking, playerId, name, faceId, headId, sex, level, vipLevel, headColour,score,myRank,otherServer, rankType)
    -- status : 状态（1为活动还在显示期间，0为活动已经失效了）
    -- ranking : 排名
    -- playerId : 玩家Id
    -- name : 玩家名字
    -- faceId : 脸Id
    -- headId : 头Id
    -- sex : 性别
    -- level : 等级
    -- vipLevel : VIP等级
    -- headColour : 头颜色
    -- score : 积分
    -- rankType : 类型 1.烟花榜 2.点球大战排行榜 3.足球竞猜
    WZLog("ProtocolProcessorWndRankList:parse_RANK_GetFireworkRankOK")

    if WndFootballActivity.m_root then
        WZLog("--dsgag----35345",IS_FOOTBALL_RANK, rankType)
        if rankType == 3 then
            WndFootballGuessList:handleRankInfo(status, VectorToTable(ranking), VectorToTable(playerId), VectorToTable(name), VectorToTable(faceId), VectorToTable(headId), VectorToTable(sex), VectorToTable(level), VectorToTable(vipLevel), VectorToTable(headColour),VectorToTable(score),myRank,VectorToTable(otherServer))
        else
            if not IS_FOOTBALL_RANK then
                CellFootballGame:getPlayerScore(status,VectorToTable(ranking),VectorToTable(name),VectorToTable(score),myRank)
            else
                WndFootballActivity:handleRankInfo(status, VectorToTable(ranking), VectorToTable(playerId), VectorToTable(name), VectorToTable(faceId), VectorToTable(headId), VectorToTable(sex), VectorToTable(level), VectorToTable(vipLevel), VectorToTable(headColour),VectorToTable(score),myRank,VectorToTable(otherServer))
            end
        end
    else
        if WndNewActivity.m_root then
            WndNewActivity:handleRankInfo(status, VectorToTable(ranking), VectorToTable(playerId), VectorToTable(name), VectorToTable(faceId), VectorToTable(headId), VectorToTable(sex), VectorToTable(level), VectorToTable(vipLevel), VectorToTable(headColour),VectorToTable(score),myRank,VectorToTable(otherServer))
        end
        if WndApartmentAct.m_root then
            WndApartmentAct:handleRankInfo(VectorToTable(ranking), VectorToTable(playerId), VectorToTable(name), VectorToTable(faceId), VectorToTable(headId), VectorToTable(sex), VectorToTable(level), VectorToTable(vipLevel), VectorToTable(headColour),VectorToTable(score),myRank,VectorToTable(otherServer))
        end
    end
end


-------------------------------------协议错误处理方法模块--------------------------------------
--@brief	获取排行榜数据（RANK_GetRankRecord = 1）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndRankList:send_RANK_GetRankRecord_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndRankList:send_RANK_GetRankRecord_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_RANK, Protocol.RANK_GetRankRecord, nflag, sMessage)
end

--@brief    获取玩家简单信息（PLAYER_GetSimpleInfo = 68）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndRankList:send_PLAYER_GetSimpleInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndRankList:send_PLAYER_GetSimpleInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_GetSimpleInfo, nflag, sMessage)
end

--@brief    获取个人排行榜数据（RANK_GetPlayerRank = 3）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndRankList:send_RANK_GetPlayerRank_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndRankList:send_RANK_GetPlayerRank_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_RANK, Protocol.RANK_GetPlayerRank, nflag, sMessage)
end

--@brief    膜拜（RANK_Worship = 5）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndRankList:send_RANK_Worship_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndRankList:send_RANK_Worship_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_RANK, Protocol.RANK_Worship, nflag, sMessage)
end

--@brief    膜拜日志（RANK_GetWorshipLog = 7）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndRankList:send_RANK_GetWorshipLog_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndRankList:send_RANK_GetWorshipLog_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_RANK, Protocol.RANK_GetWorshipLog, nflag, sMessage)
end


--@brief    获取烟花排行榜（RANK_GetFireworkRank = 9）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndRankList:send_RANK_GetFireworkRank_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndRankList:send_RANK_GetFireworkRank_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_RANK, Protocol.RANK_GetFireworkRank, nflag, sMessage)
end