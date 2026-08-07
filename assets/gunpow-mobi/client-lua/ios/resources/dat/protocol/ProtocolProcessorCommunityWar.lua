--ProtocolProcessorCommunityWar.lua
--@brief	公会战相关协议
--@date  	2016/09/18
--@author 	Tianxiang_Xu
--@note 	公会战相关协议


ProtocolProcessorCommunityWar = ProtocolProcessorBase:new()

-------------------------------------公有方法模块--------------------------------------
--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorCommunityWar:regAll()
    --@brief    获取战队分组信息（GUILDWAR_GuildFightInfoOk = 2）
    self:regProtocolCallbackFunction( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_GuildFightInfoOk, "ProtocolProcessorCommunityWar:parse_GUILDWAR_GuildFightInfoOk", "vivsvii")
    --@brief    进入公会战房间（GUILDWAR_EntryGuildRoomOk = 4）
    self:regProtocolCallbackFunction( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_EntryGuildRoomOk, "ProtocolProcessorCommunityWar:parse_GUILDWAR_EntryGuildRoomOk", "vivsvivivivivivivivivivsvivivivi")
    --@brief    获取战队战斗记录信息（GUILDWAR_GuildFightRecordOk = 9）
    self:regProtocolCallbackFunction( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_GuildFightRecordOk, "ProtocolProcessorCommunityWar:parse_GUILDWAR_GuildFightRecordOk", "ivivivsvivivivivivivivivivivivivi")
    --@brief    获取战斗回放信息（GUILDWAR_GuildFightRecordMesOk = 11）
    self:regProtocolCallbackFunction( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_GuildFightRecordMesOk, "ProtocolProcessorCommunityWar:parse_GUILDWAR_GuildFightRecordMesOk", "vs")
    --@brief    公会战任务进度（GUILDWAR_GetGuildWarTaskOk = 13）
    self:regProtocolCallbackFunction( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_GetGuildWarTaskOk, "ProtocolProcessorCommunityWar:parse_GUILDWAR_GetGuildWarTaskOk", "vivivi")
    --@brief    领取公会战任务奖励（GUILDWAR_ObtainGuildWarTaskOk = 15）
    self:regProtocolCallbackFunction( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_ObtainGuildWarTaskOk, "ProtocolProcessorCommunityWar:parse_GUILDWAR_ObtainGuildWarTaskOk", "vivivivivi")
    --@brief    提示语（GUILDWAR_MessageOk = 16）
    self:regProtocolCallbackFunction( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_MessageOk, "ProtocolProcessorCommunityWar:parse_GUILDWAR_MessageOk", "s")
    --@brief    邀请会员进入公会战房间（GUILDWAR_InviteOk = 18）
    self:regProtocolCallbackFunction( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_InviteOk, "ProtocolProcessorCommunityWar:parse_GUILDWAR_InviteOk", "s")
    --@brief    没有对手战斗胜利提示（GUILDWAR_FightSucOk = 19）
    self:regProtocolCallbackFunction( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_FightSucOk, "ProtocolProcessorCommunityWar:parse_GUILDWAR_FightSucOk", "")
    --@brief    公会战斗结束提示（GUILDWAR_FightFinishOk = 20）
    self:regProtocolCallbackFunction( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_FightFinishOk, "ProtocolProcessorCommunityWar:parse_GUILDWAR_FightFinishOk", "")
    --@brief    出线赛公会成员信息（GUILDWAR_GuildWarOutOk = 25）
    self:regProtocolCallbackFunction( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_GuildWarOutOk, "ProtocolProcessorCommunityWar:parse_GUILDWAR_GuildWarOutOk", "vivivsvivivii")
    --@brief    公会战公会排名（GUILDWAR_GuildWarRankOk = 27）
    self:regProtocolCallbackFunction( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_GuildWarRankOk, "ProtocolProcessorCommunityWar:parse_GUILDWAR_GuildWarRankOk", "vivivsvivivivsivi")
    --@brief    往届前三名信息（GUILDWAR_OldGuildWarMesOk = 31）
    self:regProtocolCallbackFunction( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_OldGuildWarMesOk, "ProtocolProcessorCommunityWar:parse_GUILDWAR_OldGuildWarMesOk", "vivsvivsvii")


    --@brief    加载排名页面信息返回（GUILDWAR_LoadRankInfoOk = 61）
    self:regProtocolCallbackFunction( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_LoadRankInfoOk, "ProtocolProcessorCommunityWar:parse_GUILDWAR_LoadRankInfoOk", "iitvivivsvsvivtis")

    --@brief    获取战队分组信息（GUILDWAR_GuildFightInfo = 1）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_GuildFightInfo, "ProtocolProcessorCommunityWar:send_GUILDWAR_GuildFightInfo_ErrorProcess", "is" )
    --@brief    进入公会战房间（GUILDWAR_EntryGuildRoom = 3）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_EntryGuildRoom, "ProtocolProcessorCommunityWar:send_GUILDWAR_EntryGuildRoom_ErrorProcess", "is" )
    --@brief    玩家退出公会房间（GUILDWAR_OutGuildRoom = 5）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_OutGuildRoom, "ProtocolProcessorCommunityWar:send_GUILDWAR_OutGuildRoom_ErrorProcess", "is" )
    --@brief    设置队员进入队伍（GUILDWAR_InstallMember = 6）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_InstallMember, "ProtocolProcessorCommunityWar:send_GUILDWAR_InstallMember_ErrorProcess", "is" )
    --@brief    取消队伍的队员（GUILDWAR_OutMember = 7）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_OutMember, "ProtocolProcessorCommunityWar:send_GUILDWAR_OutMember_ErrorProcess", "is" )
    --@brief    获取战队战斗记录信息（GUILDWAR_GuildFightRecord = 8）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_GuildFightRecord, "ProtocolProcessorCommunityWar:send_GUILDWAR_GuildFightRecord_ErrorProcess", "is" )
    --@brief    获取战斗回放信息（GUILDWAR_GuildFightRecordMes = 10）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_GuildFightRecordMes, "ProtocolProcessorCommunityWar:send_GUILDWAR_GuildFightRecordMes_ErrorProcess", "is" )
    --@brief    公会战任务进度（GUILDWAR_GetGuildWarTask = 12）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_GetGuildWarTask, "ProtocolProcessorCommunityWar:send_GUILDWAR_GetGuildWarTask_ErrorProcess", "is" )
    --@brief    领取公会战任务奖励（GUILDWAR_ObtainGuildWarTask = 14）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_ObtainGuildWarTask, "ProtocolProcessorCommunityWar:send_GUILDWAR_ObtainGuildWarTask_ErrorProcess", "is" )
    --@brief    邀请会员进入公会战房间（GUILDWAR_Invite = 17）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_Invite, "ProtocolProcessorCommunityWar:send_GUILDWAR_Invite_ErrorProcess", "is" )


	--@brief   加载排名页面信息（GUILDWAR_LoadRankInfo = 60）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_LoadRankInfo, "ProtocolProcessorCommunityWar:send_GUILDWAR_LoadRankInfo_ErrorProcess", "is" )
    --@brief    报名（GUILDWAR_Signup = 62）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_Signup, "ProtocolProcessorCommunityWar:send_GUILDWAR_Signup_ErrorProcess", "is" )
    --@brief    出线赛公会成员信息（GUILDWAR_GuildWarOut = 24）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_GuildWarOut, "ProtocolProcessorCommunityWar:send_GUILDWAR_GuildWarOut_ErrorProcess", "is" )
    --@brief    公会战公会排名（GUILDWAR_GuildWarRank = 26）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_GuildWarRank, "ProtocolProcessorCommunityWar:send_GUILDWAR_GuildWarRank_ErrorProcess", "is" )
    --@brief    往届前三名信息（GUILDWAR_OldGuildWarMes = 30）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_OldGuildWarMes, "ProtocolProcessorCommunityWar:send_GUILDWAR_OldGuildWarMes_ErrorProcess", "is" )


    --@brief    获取代理人操作（GUILDWAR_GetAgent = 34）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_GetAgent, "ProtocolProcessorCommunityWar:send_GUILDWAR_GetAgent_ErrorProcess", "is" )
    --@brief 获取代理人操作（GUILDWAR_GetAgentOk = 35）
    self:regProtocolCallbackFunction( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_GetAgentOk, "ProtocolProcessorCommunityWar:parse_GUILDWAR_GetAgentOk", "vivivivivivivivivivs")

    --@brief    设置代理人操作（GUILDWAR_SetAgent = 32）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_SetAgent, "ProtocolProcessorCommunityWar:send_GUILDWAR_SetAgent_ErrorProcess", "is" )
    --@brief    设置代理人操作（GUILDWAR_SetAgentOk = 33）
    self:regProtocolCallbackFunction( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_SetAgentOk, "ProtocolProcessorCommunityWar:parse_GUILDWAR_SetAgentOk", "vi")

    --@brief    公会战战斗时间（GUILDWAR_GuildWarTime = 36）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_GuildWarTime, "ProtocolProcessorCommunityWar:send_GUILDWAR_GuildWarTime_ErrorProcess", "is" )
    --@brief    公会战战斗时间（GUILDWAR_GuildWarTimeOk = 37）
    self:regProtocolCallbackFunction( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_GuildWarTimeOk, "ProtocolProcessorCommunityWar:parse_GUILDWAR_GuildWarTimeOk", "sii")

end 

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorCommunityWar:unregAll()
	self:clearReg()
end

----------------------------客户端到服务器协议发送方法模块-----------------------------------
--@brief    获取战队分组信息（GUILDWAR_GuildFightInfo = 1）
function ProtocolProcessorCommunityWar:send_GUILDWAR_GuildFightInfo()
    WZLog("send_GUILDWAR_GuildFightInfo")
    local sender = Protocol:getSender( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_GuildFightInfo )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    进入公会战房间（GUILDWAR_EntryGuildRoom = 3）
function ProtocolProcessorCommunityWar:send_GUILDWAR_EntryGuildRoom( )
    WZLog("send_GUILDWAR_EntryGuildRoom")
    local sender = Protocol:getSender( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_EntryGuildRoom )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    玩家退出公会房间（GUILDWAR_OutGuildRoom = 5）
function ProtocolProcessorCommunityWar:send_GUILDWAR_OutGuildRoom( )
    WZLog("send_GUILDWAR_OutGuildRoom")
    local sender = Protocol:getSender( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_OutGuildRoom )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    设置队员进入队伍（GUILDWAR_InstallMember = 6）
function ProtocolProcessorCommunityWar:send_GUILDWAR_InstallMember(playerId, teamIndex )
    WZLog("send_GUILDWAR_InstallMember")
    local sender = Protocol:getSender( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_InstallMember )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( playerId ) -- 被设置玩家Id
    sender:writeInt( teamIndex )    -- 队伍编号（0为1队，1为2队，2为3队）
    SendProtocol(sender,false) --true:showLoading
end

--@brief    取消队伍的队员（GUILDWAR_OutMember = 7）
function ProtocolProcessorCommunityWar:send_GUILDWAR_OutMember(playerId, teamIndex )
    WZLog("send_GUILDWAR_OutMember")
    local sender = Protocol:getSender( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_OutMember )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( playerId )    -- 被设置玩家Id
    sender:writeInt( teamIndex )    -- 队伍编号（0为1队，1为2队，2为3队）
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取战队战斗记录信息（GUILDWAR_GuildFightRecord = 8）
function ProtocolProcessorCommunityWar:send_GUILDWAR_GuildFightRecord()
    WZLog("send_GUILDWAR_GuildFightRecord")
    local sender = Protocol:getSender( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_GuildFightRecord )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取战斗回放信息（GUILDWAR_GuildFightRecordMes = 10）
function ProtocolProcessorCommunityWar:send_GUILDWAR_GuildFightRecordMes(recordId)
    WZLog("send_GUILDWAR_GuildFightRecordMes")
    local sender = Protocol:getSender( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_GuildFightRecordMes )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( recordId ) -- 战斗记录Id
    SendProtocol(sender,false) --true:showLoading
end

--@brief    公会战任务进度（GUILDWAR_GetGuildWarTask = 12）
function ProtocolProcessorCommunityWar:send_GUILDWAR_GetGuildWarTask( )
    WZLog("send_GUILDWAR_GetGuildWarTask")
    local sender = Protocol:getSender( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_GetGuildWarTask )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    领取公会战任务奖励（GUILDWAR_ObtainGuildWarTask = 14）
function ProtocolProcessorCommunityWar:send_GUILDWAR_ObtainGuildWarTask(taskId )
    WZLog("send_GUILDWAR_ObtainGuildWarTask")
    local sender = Protocol:getSender( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_ObtainGuildWarTask )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( taskId )   -- 领取的任务奖励Id
    SendProtocol(sender,false) --true:showLoading
end

--@brief    邀请会员进入公会战房间（GUILDWAR_Invite = 17）
function ProtocolProcessorCommunityWar:send_GUILDWAR_Invite(pid )
    WZLog("send_GUILDWAR_Invite")
    local sender = Protocol:getSender( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_Invite )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( pid )  -- 被邀请玩家
    SendProtocol(sender,false) --true:showLoading
end

--@brief    出线赛公会成员信息（GUILDWAR_GuildWarOut = 24）
function ProtocolProcessorCommunityWar:send_GUILDWAR_GuildWarOut(warType)
    WZLog("send_GUILDWAR_GuildWarOut")
    local sender = Protocol:getSender( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_GuildWarOut )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( warType )  -- 公会战类型（1为出线赛，2为入围赛）
    SendProtocol(sender,false) --true:showLoading
end

--@brief    公会战公会排名（GUILDWAR_GuildWarRank = 26）
function ProtocolProcessorCommunityWar:send_GUILDWAR_GuildWarRank(warType )
    WZLog("send_GUILDWAR_GuildWarRank")
    local sender = Protocol:getSender( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_GuildWarRank )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( warType )  -- 公会战类型（1为出线赛，2为入围赛）
    SendProtocol(sender,false) --true:showLoading
end

--@brief    往届前三名信息（GUILDWAR_OldGuildWarMes = 30）
function ProtocolProcessorCommunityWar:send_GUILDWAR_OldGuildWarMes(version )
    WZLog("send_GUILDWAR_OldGuildWarMes")
    local sender = Protocol:getSender( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_OldGuildWarMes )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( version )  --  公会战届数
    SendProtocol(sender,false) --true:showLoading
end


--@brief    加载排名页面信息（GUILDWAR_LoadRankInfo = 60）
function ProtocolProcessorCommunityWar:send_GUILDWAR_LoadRankInfo( )
    WZLog("send_GUILDWAR_LoadRankInfo")
    local sender = Protocol:getSender( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_LoadRankInfo )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    报名（GUILDWAR_Signup = 62）
function ProtocolProcessorCommunityWar:send_GUILDWAR_Signup( )
    WZLog("send_GUILDWAR_Signup")
    local sender = Protocol:getSender( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_Signup )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取代理人操作（GUILDWAR_GetAgent = 34）
function ProtocolProcessorCommunityWar:send_GUILDWAR_GetAgent( )
    WZLog("send_GUILDWAR_GetAgent")
    local sender = Protocol:getSender( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_GetAgent )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    设置代理人操作（GUILDWAR_SetAgent = 32）
function ProtocolProcessorCommunityWar:send_GUILDWAR_SetAgent(operation, playerId, index)
    WZLog("send_GUILDWAR_SetAgent")
    local sender = Protocol:getSender( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_SetAgent )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( operation )    --  1为设置为代理人，2为取消代理人
    sender:writeInt( playerId ) -- 被设置玩家Id
    sender:writeInt( index ) -- 下标位置（1到4下标有效）
    SendProtocol(sender,false) --true:showLoading
end

--@brief    公会战战斗时间（GUILDWAR_GuildWarTime = 36）
function ProtocolProcessorCommunityWar:send_GUILDWAR_GuildWarTime( )
    WZLog("send_GUILDWAR_GuildWarTime")
    local sender = Protocol:getSender( Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_GuildWarTime )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

---------------------------服务器到客户端协议回调方法模块--------------------------------------
--@brief    获取战队分组信息（GUILDWAR_GuildFightInfoOk = 2）
function ProtocolProcessorCommunityWar:parse_GUILDWAR_GuildFightInfoOk(guildId, guildName, num, version)
    -- guildId : 公会id
    -- guildName : 公会名称
    -- num :  比赛名次（1为32强,2为16强，3为8强，4为4强，5为 4强进2强失败，6为2强，7为 第四名,8为季军，9为亚军，10为冠军）
    -- version : 第几届
    WZLog("ProtocolProcessorCommunityWar:parse_GUILDWAR_GuildFightInfoOk")
    if SceneCommunityWar.m_root then
        SceneCommunityWar:setGroupData(VectorToTable(guildId), VectorToTable(guildName), VectorToTable(num))
        return
    end
end

--@brief    进入公会战房间（GUILDWAR_EntryGuildRoomOk = 4）
function ProtocolProcessorCommunityWar:parse_GUILDWAR_EntryGuildRoomOk(playerId, playerName, sex, faceId, headId, colour, fight, level, vip, teamIndex, index, entryGuild, position, status, donate, agent)
    -- playerId : 玩家Id
    -- playerName : 玩家名字
    -- sex : 性别
    -- faceId : 玩家脸
    -- headId : 玩家头
    -- colour : 头颜色
    -- fight : 战斗力
    -- level : 等级
    -- vip : vip
    -- teamIndex : 队伍编号（0为1队，1为2队，2为3队）
    -- index : 队伍中位置
    -- entryGuild : 进公会时间戳
    -- position : 职位
    WZLog("ProtocolProcessorCommunityWar:parse_GUILDWAR_EntryGuildRoomOk")
    
    SceneCommunityKnockout:setRoomData(VectorToTable(playerId), VectorToTable(playerName), VectorToTable(sex), VectorToTable(level), VectorToTable(vip), VectorToTable(fight), VectorToTable(headId), VectorToTable(faceId), VectorToTable(colour), VectorToTable(teamIndex), VectorToTable(index), VectorToTable(entryGuild), VectorToTable(position), VectorToTable(status), VectorToTable(donate), VectorToTable(agent))
end

--@brief    获取战队战斗记录信息（GUILDWAR_GuildFightRecordOk = 9）
function ProtocolProcessorCommunityWar:parse_GUILDWAR_GuildFightRecordOk(version, size, guildId, guildName, playerId, faceId, headId, colour, sex, vip, camp, win, index, num, recordId, vision, ids)
    -- version : 第几届
    -- size : 该场战斗的玩家数
    -- guildId : 公会id
    -- guildName : 公会名
    -- playerId : 玩家Id
    -- faceId : 玩家脸
    -- headId : 玩家头
    -- colour : 玩家头颜色
    -- sex : 性别
    -- vip : VIP等级
    -- camp : 阵营
    -- win : 胜利公会Id
    -- index : 第几队
    -- num : 比赛名次（1为16强，2为8强，3为4强，4为 4强进2强失败，5为2强，6为 第四名,7为季军，8为亚军，9为冠军）
    -- recordId : 战斗记录Id
    -- vision : 是否观看过，1为观看过，0为没有
    WZLog("ProtocolProcessorCommunityWar:parse_GUILDWAR_GuildFightRecordOk")

    WndGuildGroupTeam:setData(version, VectorToTable(size), VectorToTable(guildId), VectorToTable(guildName), VectorToTable(playerId), VectorToTable(faceId), VectorToTable(headId), VectorToTable(colour), VectorToTable(sex), VectorToTable(vip), VectorToTable(camp), VectorToTable(win), VectorToTable(index), VectorToTable(num), VectorToTable(recordId), VectorToTable(vision), VectorToTable(ids))

end

--@brief    获取战斗回放信息（GUILDWAR_GuildFightRecordMesOk = 11）
function ProtocolProcessorCommunityWar:parse_GUILDWAR_GuildFightRecordMesOk(mes)
    -- mes : 战斗内容
    WZLog("ProtocolProcessorCommunityWar:parse_GUILDWAR_GuildFightRecordMesOk")

    BattleMsgReplayGameRecord:setRecord(VectorToTable(mes),4)
    replaceScene(SceneBattleLoading:createElement())
end

--@brief    公会战任务进度（GUILDWAR_GetGuildWarTaskOk = 13）
function ProtocolProcessorCommunityWar:parse_GUILDWAR_GetGuildWarTaskOk(typeId, num, taskId)
    -- typeId : 类型（1为参与公会战，2为参与公会战并胜利，3为公会战击杀数）
    -- num : 该类型完成数量
    -- taskId : 正在进行的任务Id
    WZLog("ProtocolProcessorCommunityWar:parse_GUILDWAR_GetGuildWarTaskOk")
    if WndCompeteTask then
        GlobalGame.g_bIsGuildWarHaveRedDot = WndCompeteTask:judgeTaskState(VectorToTable(typeId), VectorToTable(num), VectorToTable(taskId))
        
        WZLog("ProtocolProcessorCommunityWar:parse_GUILDWAR_GetGuildWarTaskOk", GlobalGame.g_tRedPointList.community, GlobalGame.g_bIsGuildWarHaveRedDot)
        local community = GlobalGame.g_tRedPointList.community or GlobalGame.g_bIsGuildWarHaveRedDot
        SceneCity:updateRedDotBuilding("community", community)
    end

    if WndCompeteTask.m_root then
        WndCompeteTask:setData(VectorToTable(typeId), VectorToTable(num), VectorToTable(taskId))
    end
end

--@brief    领取公会战任务奖励（GUILDWAR_ObtainGuildWarTaskOk = 15）
function ProtocolProcessorCommunityWar:parse_GUILDWAR_ObtainGuildWarTaskOk(typeId, num, taskId, itemId, itemNum)
    -- typeId : 类型（1为参与公会战，2为参与公会战并胜利，3为公会战击杀数）
    -- num : 该类型完成数量
    -- taskId : 正在进行的任务Id
    -- itemId : 奖励物品Id
    -- itemNum : 奖励物品数量
    WZLog("ProtocolProcessorCommunityWar:parse_GUILDWAR_ObtainGuildWarTaskOk")
    --公会战目标红点
    if WndCompeteTask then
        GlobalGame.g_bIsGuildWarHaveRedDot = WndCompeteTask:judgeTaskState(VectorToTable(typeId), VectorToTable(num), VectorToTable(taskId))
        SceneCommunityWar:updateTargetBtnRedDot()
    end

    if WndCompeteTask.m_root then
        WndCompeteTask:getRewardSuccess(VectorToTable(typeId), VectorToTable(num), VectorToTable(taskId),VectorToTable(itemId),VectorToTable(itemNum))
        return
    end
end

--@brief    提示语（GUILDWAR_MessageOk = 16）
function ProtocolProcessorCommunityWar:parse_GUILDWAR_MessageOk(mes)
    -- mes : 提示语
    WZLog("ProtocolProcessorCommunityWar:parse_GUILDWAR_MessageOk")

    if mes then
        MsgBoxManager:showTipBox(mes)
    end
end

--@brief    邀请会员进入公会战房间（GUILDWAR_InviteOk = 18）
function ProtocolProcessorCommunityWar:parse_GUILDWAR_InviteOk(playerName)
    WZLog("ProtocolProcessorCommunityWar:parse_GUILDWAR_InviteOk")
    -- playerName : 邀请人的名字
    SceneCommunityKnockout:receiveInvite(playerName)
end

--@brief    没有对手战斗胜利提示（GUILDWAR_FightSucOk = 19）
function ProtocolProcessorCommunityWar:parse_GUILDWAR_FightSucOk()
    WZLog("ProtocolProcessorCommunityWar:parse_GUILDWAR_FightSucOk")

    MsgBoxManager:showTipBox(LocalStrings.COMMUNITY_COMPETE_TEXT56)
end

--@brief    公会战斗结束提示（GUILDWAR_FightFinishOk = 20）
function ProtocolProcessorCommunityWar:parse_GUILDWAR_FightFinishOk()
    WZLog("ProtocolProcessorCommunityWar:parse_GUILDWAR_FightFinishOk")

    if SceneCommunityKnockout.m_root then
        SceneCommunityKnockout:showExitRoomAtt()
    end
end

--@brief    出线赛公会成员信息（GUILDWAR_GuildWarOutOk = 25）
function ProtocolProcessorCommunityWar:parse_GUILDWAR_GuildWarOutOk(pid, level, name, sorce, fightNum, winNum,dataType)
    -- pid : 玩家Id
    -- level : 等级
    -- name : 名字
    -- sorce : 分数
    -- fightNum : 战斗次数
    -- winNum : 胜利次数
    --dataType : 1：出线赛 2:入围赛
    WZLog("ProtocolProcessorCommunityWar:parse_GUILDWAR_GuildWarOutOk =",dataType)
    if dataType == 1 then
        WndFinalistQualifying:setData2(VectorToTable(pid),VectorToTable(level),VectorToTable(name),VectorToTable(sorce),VectorToTable(fightNum),VectorToTable(winNum))
    else
        WndFinalistQualifying:setData4(VectorToTable(pid),VectorToTable(level),VectorToTable(name),VectorToTable(sorce),VectorToTable(fightNum),VectorToTable(winNum))
    end
end

--@brief    公会战公会排名（GUILDWAR_GuildWarRankOk = 27）
function ProtocolProcessorCommunityWar:parse_GUILDWAR_GuildWarRankOk(gid, level, name, sorce, fightNum, winNum, nameorsid, myRank, inRaceId)
    -- gid : 公会ID
    -- level : 公会等级
    -- name : 公会名字
    -- sorce : 分数
    -- fightNum : 战斗次数
    -- winNum : 胜利次数
    -- nameorsid : 出线赛为该公会会长名称
    WZLog("ProtocolProcessorCommunityWar:parse_GUILDWAR_GuildWarRankOk")
    if WndFinalistQualifying.m_root then
        local nCurDay = SceneCommunityWar:getCurDay(SceneCommunityWar.m_sCommunityTime)
        if nCurDay >= 1 and nCurDay <= 7 then --出线赛
            WndFinalistQualifying:setData1(VectorToTable(gid),VectorToTable(level),VectorToTable(name),VectorToTable(sorce),VectorToTable(fightNum),VectorToTable(winNum),VectorToTable(nameorsid))
        elseif nCurDay >= 8 and nCurDay <= 14 then
            WndFinalistQualifying:setData3(VectorToTable(gid),VectorToTable(level),VectorToTable(name),VectorToTable(sorce),VectorToTable(fightNum),VectorToTable(winNum),VectorToTable(nameorsid))
        end
        return 
    end

    SceneCommunityWar:setRankData(VectorToTable(gid), VectorToTable(name), VectorToTable(nameorsid), VectorToTable(sorce), VectorToTable(fightNum), VectorToTable(winNum), myRank, VectorToTable(inRaceId))
end

--@brief    加载排名页面信息返回（GUILDWAR_LoadRankInfoOk = 61）
function ProtocolProcessorCommunityWar:parse_GUILDWAR_LoadRankInfoOk(rankOfPlayerGuild, prestigeLastWeek, signupStatus, rank, guildIds, rankGuildNames, rankCaptainNames, rankPrestigeLastWeek, rankSignUpStatus, version, activityTime)
    -- rankOfPlayerGuild : 玩家所在公会排名
    -- prestigeLastWeek : 玩家所在公会上周贡献
    -- signupStatus : 报名状态(-1:不满足参赛资格;0:未报名;1:已经报名;-2:活动已关闭;-3:冲榜周;-4:不足10个2级公会;-5:入围不足4个公会;-6:报名不足4个公会)
    -- rank : 周榜-排名
    -- guildIds : 公会Id
    -- rankGuildNames : 周榜-公会名
    -- rankCaptainNames : 周榜-公会会长名
    -- rankPrestigeLastWeek : 周榜-贡献
    -- rankSignUpStatus : 周榜-报名状态 
    -- version : 当前届
    WZLog("ProtocolProcessorCommunityWar:parse_GUILDWAR_LoadRankInfoOk")

end

--@brief    往届前三名信息（GUILDWAR_OldGuildWarMesOk = 31）
function ProtocolProcessorCommunityWar:parse_GUILDWAR_OldGuildWarMesOk(guildId, serverId, level, name, num, version)
    -- guildId : 公会Id
    -- serverId : 服务器Id
    -- level : 等级
    -- name : 名称
    -- num :  8为季军，9为亚军，10为冠军
    -- version: int 届数
    WZLog("ProtocolProcessorCommunityWar:parse_GUILDWAR_OldGuildWarMesOk")

    if nil ~= WndCompeteHistory.m_root then
        WndCompeteHistory:closeLoading()
        local tData = {
            ["guildId"      ] = VectorToTable(guildId),
            ["serverId"     ] = VectorToTable(serverId),
            ["level"        ] = VectorToTable(level),
            ["name"         ] = VectorToTable(name),
            ["num"          ] = VectorToTable(num),
            ["version"      ] = VectorToTable(version)
        }
        WndCompeteHistory:setData(tData)
    end

end


--@brief    获取代理人操作（GUILDWAR_GetAgentOk = 35）
function ProtocolProcessorCommunityWar:parse_GUILDWAR_GetAgentOk(agent, faceId, headId, colour, sex, viplevel, level, post, donate, name)
    -- agent : 代理人
    -- faceId : 玩家脸
    -- headId : 玩家头
    -- colour : 玩家头颜色
    -- sex : 性别
    -- viplevel : vip等级
    -- level : 等级
    -- post : 职位
    -- donate : 贡献
    -- name : 名字
    if nil ~= WndCompeteAgentSetting.m_root then
        local tData = {
            ["agent"    ] = VectorToTable(agent),
            ["faceId"   ] = VectorToTable(faceId),
            ["headId"   ] = VectorToTable(headId),
            ["colour"   ] = VectorToTable(colour),
            ["sex"      ] = VectorToTable(sex),
            ["viplevel" ] = VectorToTable(viplevel),
            ["level"    ] = VectorToTable(level),
            ["post"     ] = VectorToTable(post),
            ["donate"   ] = VectorToTable(donate),
            ["name"     ] = VectorToTable(name),
        }
        WndCompeteAgentSetting:setData(tData)
    end
end

--@brief    设置代理人操作（GUILDWAR_SetAgentOk = 33）
function ProtocolProcessorCommunityWar:parse_GUILDWAR_SetAgentOk(agent)
    -- agent : 代理人
    WZLog("ProtocolProcessorCommunityWar:parse_GUILDWAR_SetAgentOk")

    if nil ~= WndCompeteAgent.m_root then
        WndCompeteAgent:onRecvData(VectorToTable(agent))
    end
end

--@brief    公会战战斗时间（GUILDWAR_GuildWarTimeOk = 37）
function ProtocolProcessorCommunityWar:parse_GUILDWAR_GuildWarTimeOk(nowtime, startime, open)
    -- nowtime : 当前时间（yyyy-MM-dd HH:mm:ss）
    -- startime : 开始时间（秒）
    -- open : 是否开启（1为开启，0为没开启）
    WZLog("ProtocolProcessorCommunityWar:parse_GUILDWAR_GuildWarTimeOk")
    WndWelfare:onReceiveCommunityWarTimeOK(nowtime, startime, open)
    SceneCommunityWar:onReceiveCommunityWarTimeOK(nowtime, startime, open)
    SceneGuildWarRoom:onReceiveCommunityWarTimeOK(nowtime, startime, open)
end

-------------------------------------协议错误处理方法模块--------------------------------------
--@brief    获取战队分组信息（GUILDWAR_GuildFightInfo = 1）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorCommunityWar:send_GUILDWAR_GuildFightInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorCommunityWar:send_GUILDWAR_GuildFightInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_GuildFightInfo, nflag, sMessage)
end

--@brief    进入公会战房间（GUILDWAR_EntryGuildRoom = 3）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorCommunityWar:send_GUILDWAR_EntryGuildRoom_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorCommunityWar:send_GUILDWAR_EntryGuildRoom_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_EntryGuildRoom, nflag, sMessage)
end

--@brief    玩家退出公会房间（GUILDWAR_OutGuildRoom = 5）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorCommunityWar:send_GUILDWAR_OutGuildRoom_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorCommunityWar:send_GUILDWAR_OutGuildRoom_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_OutGuildRoom, nflag, sMessage)
end

--@brief    设置队员进入队伍（GUILDWAR_InstallMember = 6）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorCommunityWar:send_GUILDWAR_InstallMember_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorCommunityWar:send_GUILDWAR_InstallMember_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_InstallMember, nflag, sMessage)
end

--@brief    取消队伍的队员（GUILDWAR_OutMember = 7）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorCommunityWar:send_GUILDWAR_OutMember_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorCommunityWar:send_GUILDWAR_OutMember_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_OutMember, nflag, sMessage)
end

--@brief    获取战队战斗记录信息（GUILDWAR_GuildFightRecord = 8）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorCommunityWar:send_GUILDWAR_GuildFightRecord_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorCommunityWar:send_GUILDWAR_GuildFightRecord_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_GuildFightRecord, nflag, sMessage)
end

--@brief    获取战斗回放信息（GUILDWAR_GuildFightRecordMes = 10）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorCommunityWar:send_GUILDWAR_GuildFightRecordMes_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorCommunityWar:send_GUILDWAR_GuildFightRecordMes_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_GuildFightRecordMes, nflag, sMessage)
end

--@brief    公会战任务进度（GUILDWAR_GetGuildWarTask = 12）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorCommunityWar:send_GUILDWAR_GetGuildWarTask_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorCommunityWar:send_GUILDWAR_GetGuildWarTask_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_GetGuildWarTask, nflag, sMessage)
end

--@brief    领取公会战任务奖励（GUILDWAR_ObtainGuildWarTask = 14）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorCommunityWar:send_GUILDWAR_ObtainGuildWarTask_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorCommunityWar:send_GUILDWAR_ObtainGuildWarTask_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_ObtainGuildWarTask, nflag, sMessage)
end

--@brief    邀请会员进入公会战房间（GUILDWAR_Invite = 17）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorCommunityWar:send_GUILDWAR_Invite_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorCommunityWar:send_GUILDWAR_Invite_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_Invite, nflag, sMessage)
end

--@brief    加载排名页面信息（GUILDWAR_LoadRankInfo = 60）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorCommunityWar:send_GUILDWAR_LoadRankInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorCommunityWar:send_GUILDWAR_LoadRankInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_LoadRankInfo, nflag, sMessage)
end

--@brief    报名（GUILDWAR_Signup = 62）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorCommunityWar:send_GUILDWAR_Signup_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorCommunityWar:send_GUILDWAR_Signup_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_Signup, nflag, sMessage)
end

--@brief    出线赛公会成员信息（GUILDWAR_GuildWarOut = 24）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorCommunityWar:send_GUILDWAR_GuildWarOut_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorCommunityWar:send_GUILDWAR_GuildWarOut_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_GuildWarOut, nflag, sMessage)
end

--@brief    公会战公会排名（GUILDWAR_GuildWarRank = 26）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorCommunityWar:send_GUILDWAR_GuildWarRank_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorCommunityWar:send_GUILDWAR_GuildWarRank_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_GuildWarRank, nflag, sMessage)
end

--@brief    往届前三名信息（GUILDWAR_OldGuildWarMes = 30）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorCommunityWar:send_GUILDWAR_OldGuildWarMes_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorCommunityWar:send_GUILDWAR_OldGuildWarMes_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_OldGuildWarMes, nflag, sMessage)
end


--@brief    获取代理人操作（GUILDWAR_GetAgent = 34）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorCommunityWar:send_GUILDWAR_GetAgent_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorCommunityWar:send_GUILDWAR_GetAgent_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_GetAgent, nflag, sMessage)
end

--@brief    设置代理人操作（GUILDWAR_SetAgent = 32）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorCommunityWar:send_GUILDWAR_SetAgent_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorCommunityWar:send_GUILDWAR_SetAgent_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_SetAgent, nflag, sMessage)
end

--@brief    公会战战斗时间（GUILDWAR_GuildWarTime = 36）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorCommunityWar:send_GUILDWAR_GuildWarTime_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorCommunityWar:send_GUILDWAR_GuildWarTime_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_GUILDWAR, Protocol.GUILDWAR_GuildWarTime, nflag, sMessage)
end