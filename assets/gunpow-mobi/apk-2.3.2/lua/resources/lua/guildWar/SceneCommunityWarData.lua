--SceneCommunityWarData.lua
--@brief	SceneCommunityWar的数据模块
--@date		2017/02/03
--@author	Tianxiang_Xu
--@note		新公会战

SceneCommunityWar = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function SceneCommunityWar:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_nSectionIndex = nil          --本次赛程的进度
    self.m_nBottomIndex = nil           --当前选中的进度
    self.m_nMyOutRaceRank = nil             --我的公会出线榜排名
    self.m_nMyInRaceRank = nil             --我的公会入围排名
    self.m_tRankList = nil 
    self.m_nLoadingId = nil 
    self.m_nLeftSeconds = nil           --剩余时间
    self.m_nTempSecond = 0            
    self.m_tGroupData = nil 
    self.m_tFinalData = nil 
    self.m_nGroupSelIndex = 1           --当前显示的组的索引
    self.m_nLeftTimeIndex = nil         --用于标记倒计时类型：1->未到时间；2->正在进行；3->已经结束

    self.matchMode = 1          -- 比赛模式， 1 匹配赛 2 组队赛  3 混战赛
    self.personCnt = 3          -- 人数 1v1 = 1, 2v2 = 2, 3v3 = 3, 混战6

    self.m_sOutStartTime = nil      --出线赛开始时间
    self.m_sOutEndTime = nil        --出线赛结束时间
    self.m_sInStartTime = nil       --入围赛开始时间
    self.m_sInEndTime = nil         --入围赛结束时间
    self.m_sGroupReadyTime = "20:00"         --小组赛准备时间
    self.m_sGroupStartTime = "20:15"         --小组赛开始时间
    self.m_sGroupEndTime = "20:30"         --小组赛结束时间
    self.m_sFinalReadyTime = "20:00"         --决赛准备时间
    self.m_sFinalStartTime = "20:15"         --决赛开始时间
    self.m_sFinalEndTime = "20:30"         --决赛结束时间
    self.m_nJoinPlayerLevel = 25            --玩家参与等级
    self.m_nJoinGuildLevel = 2            --公会参与等级
    self.m_tInRaceGuildId = nil             --本服可以参加入围赛的公会ID
    self.m_tCallBack = nil 

    --不能进入房间提示语
    self.m_tEnterRoomAtt = {LocalStrings.TXT_NOSOCISY_FREND, LocalStrings.COMMUNITYWAR_TEXT17, LocalStrings.COMMUNITYWAR_TEXT18, LocalStrings.COMMUNITYWAR_TEXT19, LocalStrings.COMMUNITYWAR_TEXT20, LocalStrings.COMMUNITYWAR_TEXT21, LocalStrings.COMMUNITYWAR_TEXT22, LocalStrings.COMMUNITYWAR_TEXT23, LocalStrings.COMMUNITYWAR_TEXT36}

    self.m_nCommunityState = nil 
    self.m_sCommunityTime = nil 
    self.m_nNextStartTime = nil
    self.m_nCurDaySeconds = nil 
    self.m_ReceiveTimeType = 0 
    self.m_nodeTopCon = nil  
end


--@brief    反初始化表的成员变量
--@note     在退出场景时回调的onExit函数里面必须调用本函数
function SceneCommunityWar:_unInit()
    self.m_root = nil
    self.m_nSectionIndex = nil          
    self.m_nBottomIndex = nil
    self.m_nMyOutRaceRank = nil             
    self.m_nMyInRaceRank = nil             
    self.m_tRankList = nil 
    self.m_nLoadingId = nil 
    self.m_nLeftSeconds = nil
    self.m_nTempSecond = nil            
    self.m_tGroupData = nil 
    self.m_tFinalData = nil 
    self.m_nGroupSelIndex = nil
    self.m_nLeftTimeIndex = nil         

    self.matchMode = nil          -- 比赛模式， 1 匹配赛 2 组队赛  3 混战赛
    self.personCnt = nil          -- 人数 1v1 = 1, 2v2 = 2, 3v3 = 3, 混战6

    self.m_sOutStartTime = nil      --出线赛开始时间
    self.m_sOutEndTime = nil        --出线赛结束时间
    self.m_sInStartTime = nil       --入围赛开始时间
    self.m_sInEndTime = nil         --入围赛结束时间
    self.m_sGroupReadyTime = nil         --小组赛准备时间
    self.m_sGroupStartTime = nil         --小组赛开始时间
    self.m_sGroupEndTime = nil         --小组赛结束时间
    self.m_sFinalReadyTime = nil         --决赛准备时间
    self.m_sFinalStartTime = nil         --决赛开始时间
    self.m_sFinalEndTime = nil         --决赛结束时间
    self.m_nJoinPlayerLevel = nil            --玩家参与等级
    self.m_nJoinGuildLevel = nil             --公会参与等级
    self.m_tInRaceGuildId = nil
    self.m_tCallBack = nil 

    self.m_tEnterRoomAtt = nil 

    self.m_nCommunityState = nil 
    self.m_sCommunityTime = nil 
    self.m_nNextStartTime = nil
    self.m_nCurDaySeconds = nil 
    self.m_nodeTopCon = nil  
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function SceneCommunityWar:createElement()
	local element = WZUISystem:getInstance():createElement("SceneCommunityWar")
	assert(element, "SceneCommunityWar create element failed!")
	self:_init()
	return element
end

--@brief    外部接口
function SceneCommunityWar:showInterface()
    -- body
    local tempScene = SceneCommunityWar:createElement()
    if tempScene then
        replaceScene(tempScene)
    end
end

function SceneCommunityWar:setCallBackFunc(tCell, func)
    --body
    self.m_tCallBack = {}
    
    self.m_tCallBack[1] = tCell
    self.m_tCallBack[2] = func
end

--@brief    设置出线、入围数据
function SceneCommunityWar:setRankData(guildId, guildName, presidentName, guildIntegral, guildFightNum, guildWinNum, nMyRaceRank, inRaceId)
    -- body
    self:_stopLoading()

    if self.m_tRankList == nil then
        self.m_tRankList = {}
    end
    if self.m_nBottomIndex == 1 then
        self.m_tRankList[1] = {}
        self.m_nMyOutRaceRank = nMyRaceRank
    elseif self.m_nBottomIndex == 2 then
        self.m_tRankList[2] = {}
        self.m_nMyInRaceRank = nMyRaceRank
    end

    for i = 1, #guildId do
        local tItem = {}
        tItem.rank = i 
        tItem.guildId = guildId[i]
        tItem.guildName = guildName[i]
        tItem.presidentName = presidentName[i]
        tItem.guildIntegral = guildIntegral[i]
        tItem.guildFightNum = guildFightNum[i]
        tItem.guildWinNum = guildWinNum[i]
        
        table.insert(self.m_tRankList[self.m_nBottomIndex], tItem)
    end
    self.m_tInRaceGuildId = inRaceId
    WZLog("SceneCommunityWar:setRankData", Serialize(self.m_tInRaceGuildId))
    self:_loadRankList(self.m_nBottomIndex)
end

--@brief    设置分组数据
function SceneCommunityWar:setGroupData(id, guildName, rankMark)
    -- body
    self.m_tGroupData = {}
    self.m_tGroupData[1] = {}
    self.m_tGroupData[2] = {}
    self.m_tGroupData[3] = {}
    self.m_tGroupData[4] = {}
    WZLog("SceneCommunityWar:setGroupData", Serialize(id), Serialize(guildName), Serialize(rankMark))
    for i = 1, 32 do
        local tItem = {}
        --计算组号
        local rowIndex = math.floor((i-1) / 4)
        local groupId = i - rowIndex * 4
        if id then
            if i <= #id then
                tItem.guildId = id[i]
                tItem.guildName = guildName[i]
                tItem.guildResult = rankMark[i]
            else
                tItem.guildId = -1
                tItem.guildName = nil 
                tItem.guildResult = 0
            end
            tItem.guildGroupNo = rowIndex + 1
            
            table.insert(self.m_tGroupData[groupId], tItem)
        else
            break 
        end
    end
    self:_stopLoading()

    if self.m_nBottomIndex == 3 then
        self:loadAllGroup()
    elseif self.m_nBottomIndex == 4 then
        self:loadGroupFinal()
    end
end

--@brief    取得公会信息
function SceneCommunityWar:getCommunityInfoOk(id, name, level, members, chairman, desc, totemLevel, warRank, rank, declaration, prestige, setting)
    WZLog("SceneCommunityWar:getCommunityInfoOk", Serialize(VectorToTable(warRank)))
    --弹出公会信息窗口
    if WndCommunityInfo and WndCommunityInfo.m_root then
        WindowManager:removeWindow(WndCommunityInfo.m_root, WndCommunityInfo, true)
    end
    local wndCommunityInfo = WndCommunityInfo:createElement()
    WindowManager:addWindow(wndCommunityInfo, WndCommunityInfo)
    local bHaveEnemyComminityInfo = false
    --设置公会内容
    WndCommunityInfo:setFreeconText(name,tostring(id),chairman, tostring(level),tostring(members),totemLevel,0,desc,bHaveEnemyComminityInfo,VectorToTable(warRank))

    --设置通告栏内容
    WndCommunityInfo:setFreeconsCommunityDeclareText(desc)
    --设置申请入会按钮是否可用
    local guildId = CacheCenter:getPlayerInfo().guildId
    if guildId ~= nil and guildId > 0 then
        WndCommunityInfo:setJoinCommunityBtnEnable(false)
    end
	if CacheCenter:getPlayerInfo().level < tonumber(setting) then
		WndCommunityInfo:setJoinCommunityBtnEnable(false)
	end
    --取消圆圈的转动效果
    self:_stopLoading()
end

--@brief    接受公会战房间邀请
function SceneCommunityWar:receiveInvite()
    -- body
    local nCurDay = self:getCurDay(self.m_sCommunityTime)
    --淘汰赛
    if nCurDay >= 15 and nCurDay <= 20 then
        if WndInvited then
            WndInvited:showInterface(SceneCommunityKnockout, SceneCommunityKnockout.onAcceptInvite, nil, nil,nil, string.format(LocalStrings.COMMUNITY_COMPETE_TEXT53, playerName),playerName)
        end
    end
end

--@brief    设置数据
--@note     获取服务器的日期，最近开始比赛的时间戳
function SceneCommunityWar:onReceiveCommunityWarTimeOK(nowtime, startime, open)
    -- body
    if SceneCommunityWar.m_root == nil then return end 

    self:_stopLoading()
    self.m_nCommunityState = open 
    self.m_sCommunityTime = nowtime 
    self.m_nNextStartTime = startime

    --如果跨天，重新获取数据
    local curDate = SplitStringWithSeparator(self.m_sCommunityTime," ")
    self.m_nCurDaySeconds = TimeToSeconds(curDate[2])
    WZLog("SceneCommunityWar:onReceiveCommunityWarTimeOK", self.m_ReceiveTimeType, nowtime, startime, open)
    if self.m_ReceiveTimeType == 0 then 
        self.m_ReceiveTimeType = 2 
        self.m_nodeTopCon:enableSchedule("_caculateDateTime", 1)
        self:_initWnd()
    elseif self.m_ReceiveTimeType == 1 then 
        self.m_ReceiveTimeType = 2
        self.m_nodeTopCon:enableSchedule("_caculateDateTime", 1)
        self:showWarProgress()
    else
        self:showWarProgress()
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    数据加载动画
function SceneCommunityWar:_createLoading()
    -- body
     if self.m_root == nil then return end
    if self.m_nLoadingId == nil then
        self.m_nLoadingId = MsgBoxManager:showLoadingBox()
    end
end

--@brief    加载动画停止
function SceneCommunityWar:_stopLoading()
    if self.m_root == nil then return end
    -- body
    if self.m_nLoadingId ~= nil then
        MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
    end
    self.m_nLoadingId = nil 
end

--@brief    获取当前是几号
--@param    dateString:日期字符串，格式为：2017-10-01 11:36:42
function SceneCommunityWar:getCurDay(dateString)
    -- body
    if dateString then 
        local curDate = SplitStringWithSeparator(dateString," ")
        local tDate = SplitStringWithSeparator(curDate[1],"-")
        WZLog("SceneCommunityWar:getCurDay", type(tDate[3]), tonumber(tDate[3]))
        
        return tonumber(tDate[3])
    else
        local nCurTime = SystemTime:getServerTime()

        local sDate = os.date("%d", nCurTime)
        WZLog("SceneCommunityWar:getCurDay", type(sDate))

        return tonumber(sDate)
    end
end

--@param    表示时间的字符串  例如:12:00
--@param    nDay:日期：如 1， 2
function SceneCommunityWar:transformStringToTime(sTime, nDay)
    local time = sTime
    local time2 = SplitStringWithSeparator(time,":")
    local nCurTime = SystemTime:getServerTime()
    local year = tonumber(os.date("%Y",nCurTime))
    local month = tonumber(os.date("%m",nCurTime))
    local nTempDay = tonumber(os.date("%d",nCurTime))
    local day = nDay or nTempDay
    local hour = tonumber(time2[1])
    local min = tonumber(time2[2])

    WZLog("SceneCommunityWar:transformStringToTime******", year, month, day, hour, min)
    return os.time({year=year,month=month,day=day,hour=hour,min=min})
end

--@brief    判断不能进房间的集中情况和提示语
function SceneCommunityWar:_cantEnterRoomAtt()
    -- body
    local tPlayerInfo = CacheCenter:getPlayerInfo()
    local nCurTime = SystemTime:getServerTime()

    if tPlayerInfo.guildId == nil or tPlayerInfo.guildId <= 0 then
        return 0    --没有公会
    else
        local nCurDay = self:getCurDay(self.m_sCommunityTime)
        if nCurDay == 2 or nCurDay == 4 or nCurDay == 6 or nCurDay == 9 or nCurDay == 11 or nCurDay == 13 then
            return 1   --尚未开启，请耐心等待
        elseif nCurDay == 1 or nCurDay == 3 or nCurDay == 5 or nCurDay == 7 then  --出线赛
            local nStartTime = self.m_nNextStartTime
            local nEndTime = self.m_nNextStartTime + (self:transformStringToTime(self.m_sOutEndTime) - self:transformStringToTime(self.m_sOutStartTime))
            if nCurTime >= nStartTime and nCurTime <= nEndTime then
                if tPlayerInfo.level < self.m_nJoinPlayerLevel then
                    return 2    --玩家等级不足
                elseif tPlayerInfo.guildLevel < self.m_nJoinGuildLevel then 
                    return 3    --玩家公会等级不足
                elseif tPlayerInfo.level >= self.m_nJoinPlayerLevel and tPlayerInfo.guildLevel >= self.m_nJoinGuildLevel then
                    return 99   --可以创建房间
                end
                return 
            elseif nCurTime < nStartTime then
                return 1        --尚未开启
            elseif nCurTime > nEndTime then
                return 4        --今天的比赛已经结束
            end
        elseif nCurDay == 8 or nCurDay == 10 or nCurDay == 12 or nCurDay == 14 then  --入围赛
            local bIsExist = false 
            if self.m_tInRaceGuildId then
                for i = 1, #self.m_tInRaceGuildId do
                    if tPlayerInfo.guildId == self.m_tInRaceGuildId[i] then
                        bIsExist = true
                        break  
                    end
                end
            end
            WZLog("SceneCommunityWar:_cantEnterRoomAtt", bIsExist)
            if not bIsExist then
                return 5    --您的公会没有进入入围赛，下次记得努力点噢
            else
                local nStartTime = self.m_nNextStartTime
                local nEndTime = self.m_nNextStartTime + (self:transformStringToTime(self.m_sInEndTime) - self:transformStringToTime(self.m_sInStartTime))
                if nCurTime >= nStartTime and nCurTime <= nEndTime then
                    if tPlayerInfo.level < self.m_nJoinPlayerLevel then
                        return 2    --玩家等级不足
                    elseif tPlayerInfo.guildLevel < self.m_nJoinGuildLevel then 
                        return 3    --玩家公会等级不足
                    elseif tPlayerInfo.level >= self.m_nJoinPlayerLevel and tPlayerInfo.guildLevel >= self.m_nJoinGuildLevel then
                        return 99   --可以创建房间
                    end
                    return 
                elseif nCurTime < nStartTime then
                    return 1        --尚未开启
                elseif nCurTime > nEndTime then
                    return 4        --今天的比赛已经结束
                end
            end
        elseif nCurDay >= 15 and nCurDay <= 20 then
            local bIsExist = false
            
            if self.m_tGroupData then
                for i = 1, #self.m_tGroupData do
                    for j = 1, #self.m_tGroupData[i] do
                        -- 比赛名次（1为32强,2为16强，3为8强，4为4强，5为 4强进2强失败，6为2强，7为 第四名,8为季军，9为亚军，10为冠军）
                        if self.m_tGroupData[i][j].guildId == tPlayerInfo.guildId then
                            if nCurDay == 15 then
                                bIsExist = true
                            elseif nCurDay == 16 then
                                if self.m_tGroupData[i][j].guildResult > 1 then
                                    bIsExist = true
                                end
                            elseif nCurDay == 17 then
                                if self.m_tGroupData[i][j].guildResult > 2 then
                                    bIsExist = true
                                end
                            elseif nCurDay == 18 then
                                if self.m_tGroupData[i][j].guildResult > 3 then
                                    bIsExist = true
                                end
                            elseif nCurDay == 19 then
                                if self.m_tGroupData[i][j].guildResult == 5 or self.m_tGroupData[i][j].guildResult == 7 or self.m_tGroupData[i][j].guildResult == 8 then
                                    bIsExist = true
                                elseif self.m_tGroupData[i][j].guildResult == 6 then
                                    return 8
                                end
                            elseif nCurDay == 20 then
                                if self.m_tGroupData[i][j].guildResult == 6 or self.m_tGroupData[i][j].guildResult == 9 or self.m_tGroupData[i][j].guildResult == 10 then
                                    bIsExist = true
                                end
                            end
                        end
                    end
                end
                if not bIsExist then
                    return 6    --您的公会已经失去资格，下次一定要努力啊
                else
                    if nCurDay == 15 or nCurDay == 16 or nCurDay == 17 then
                        local nStartTime = self.m_nNextStartTime - 15 * 60 
                        local nEndTime = nStartTime + (self:transformStringToTime(self.m_sGroupEndTime) - self:transformStringToTime(self.m_sGroupReadyTime))
                        if nCurTime >= nStartTime and nCurTime <= nEndTime then
                            return 99 --淘汰赛可以进房间
                        elseif nCurTime < nStartTime then
                            return 1    --尚未开始
                        elseif nCurTime > nEndTime then
                            return 4    --今天比赛已经结束
                        end
                    elseif nCurDay == 18 or nCurDay == 19 or nCurDay == 20 then
                        local nStartTime2 = self.m_nNextStartTime - 15 * 60 
                        local nEndTime2 = nStartTime2 + (self:transformStringToTime(self.m_sFinalEndTime) - self:transformStringToTime(self.m_sFinalReadyTime))
                        if nCurTime >= nStartTime2 and nCurTime <= nEndTime2 then
                            return 99   --淘汰赛可以进房间
                        elseif nCurTime < nStartTime2 then 
                            return 1    --尚未开始
                        elseif nCurTime > nEndTime2 then
                            return 4    --今天比赛已经结束
                        end
                    end
                end
            end
        else
            return 7            --本轮公会战已经结束
        end
    end
end

--@brief    判断当前用户是否加入公会或所在的公会是否在当前的赛程中
function SceneCommunityWar:_judgeWhetherCanInRoom()
    -- body
    local tPlayerInfo = CacheCenter:getPlayerInfo()
    if tPlayerInfo.guildId == nil or tPlayerInfo.guildId <= 0 then
        return false
    else
        local nCurDay = self:getCurDay(self.m_sCommunityTime)
        --本服出线赛（玩家等级>=25,并且公会等级>=2）
        if nCurDay == 1 or nCurDay == 3 or nCurDay == 5 or nCurDay == 7 then
            if tPlayerInfo.level >= 25 and tPlayerInfo.guildLevel >= 2 then
                return true
            end
            return false 
        elseif nCurDay == 2 or nCurDay == 4 or nCurDay == 6 then
            return false
        end 
        --判断入围列表中是否有玩家所在的公会
        if nCurDay == 8 or nCurDay == 10 or nCurDay == 12 or nCurDay == 14 then
            if self.m_tInRaceGuildId then
                for i = 1, #self.m_tInRaceGuildId do
                    if tPlayerInfo.guildId == self.m_tInRaceGuildId[i] then
                        return true
                    end
                end
            end
            return false
        elseif nCurDay == 9 or nCurDay == 11 or nCurDay == 13 then
            return false
        end 
        --小组赛和决赛
        if self.m_tGroupData then
            for i = 1, #self.m_tGroupData do
                for j = 1, #self.m_tGroupData[i] do
                    if self.m_tGroupData[i][j].guildId == tPlayerInfo.guildId then
                        if nCurDay == 15 then
                            return true
                        elseif nCurDay == 16 then
                            if self.m_tGroupData[i][j].guildResult > 0 then
                                return true
                            end
                        elseif nCurDay == 17 then
                            if self.m_tGroupData[i][j].guildResult > 1 then
                                return true
                            end
                        elseif nCurDay == 18 then
                            if self.m_tGroupData[i][j].guildResult > 2 then
                                return true
                            end
                        elseif nCurDay == 19 then
                            if self.m_tGroupData[i][j].guildResult > 3 and self.m_tGroupData[i][j].guildResult < 6 then
                                return true
                            end
                        elseif nCurDay == 20 then
                            if self.m_tGroupData[i][j].guildResult > 5 then
                                return true
                            end
                        end
                    end
                end
            end
        end

        return false
    end
end

--@brief    获取剩余时间
function SceneCommunityWar:_getLastTime()
    -- body
    local nLeftTime = 0
    local nLeftTimeIndex = 1
    local nCurDay = self:getCurDay(self.m_sCommunityTime)
    local nCurTime = SystemTime:getServerTime()
    
    WZLog("SceneCommunityWar:_getLastTime", nCurDay, nCurTime)
    if nCurDay == 1 or nCurDay == 3 or nCurDay == 5 or nCurDay == 7 then
        local nStartTime = self.m_nNextStartTime
        local nEndTime = self.m_nNextStartTime + (self:transformStringToTime(self.m_sOutEndTime) - self:transformStringToTime(self.m_sOutStartTime))
        if nCurTime >= nStartTime and nCurTime <= nEndTime then
            nLeftTime = nEndTime - nCurTime 
            nLeftTimeIndex = 2
        elseif nCurTime < nStartTime then
            nLeftTime = nStartTime - nCurTime 
            nLeftTimeIndex = 1
        elseif nCurTime > nEndTime then
            if nCurDay == 7 then
                nLeftTime = 0
                nLeftTimeIndex = 3
            else
                if self.m_nNextStartTime > nCurTime then 
                    nLeftTime = self.m_nNextStartTime - nCurTime
                    nLeftTimeIndex = 1
                else
                    nLeftTime = 0
                    nLeftTimeIndex = 4
                end
            end
        end
    elseif nCurDay == 2 or nCurDay == 4 or nCurDay == 6 then
        nLeftTime = self.m_nNextStartTime - nCurTime
        nLeftTimeIndex = 1
    elseif nCurDay == 8 or nCurDay == 10 or nCurDay == 12 or nCurDay == 14 then
        local nStartTime2 = self.m_nNextStartTime
        local nEndTime2 = self.m_nNextStartTime + (self:transformStringToTime(self.m_sInEndTime) - self:transformStringToTime(self.m_sInStartTime))
        if nCurTime >= nStartTime2 and nCurTime <= nEndTime2 then
            nLeftTime = nEndTime2 - nCurTime 
            nLeftTimeIndex = 2
        elseif nCurTime < nStartTime2 then
            nLeftTime = nStartTime2 - nCurTime 
            nLeftTimeIndex = 1
        elseif nCurTime > nEndTime2 then
            if nCurDay == 14 then
                nLeftTime = 0
                nLeftTimeIndex = 3
            else
                if self.m_nNextStartTime > nCurTime then 
                    nLeftTime = self.m_nNextStartTime - nCurTime
                    nLeftTimeIndex = 1
                else
                    nLeftTime = 0
                    nLeftTimeIndex = 4
                end
            end
        end
    elseif nCurDay == 9 or nCurDay == 11 or nCurDay == 13 then
        nLeftTime = self.m_nNextStartTime - nCurTime
        nLeftTimeIndex = 1
    elseif nCurDay >= 15 and nCurDay <= 17 then
        local nReadyTime3 = self.m_nNextStartTime - 15 * 60
        local nStartTime3 = self.m_nNextStartTime
        local nEndTime3 = nReadyTime3 + (self:transformStringToTime(self.m_sGroupEndTime) - self:transformStringToTime(self.m_sGroupReadyTime))
        if nCurTime >= nReadyTime3 and nCurTime <= nEndTime3 then
            nLeftTime = nEndTime3 - nCurTime 
            nLeftTimeIndex = 2
        elseif nCurTime < nReadyTime3 then
            nLeftTime = nReadyTime3 - nCurTime
            nLeftTimeIndex = 1
        elseif nCurTime > nEndTime3 then
            if nCurDay == 17 then
                nLeftTime = 0 
                nLeftTimeIndex = 3
            else
                if self.m_nNextStartTime > nCurTime then 
                    nLeftTime = self.m_nNextStartTime - nCurTime
                    nLeftTimeIndex = 1
                else
                    nLeftTime = 0
                    nLeftTimeIndex = 4
                end
            end
        end
    elseif nCurDay >= 18 and nCurDay <= 20 then
        local nReadyTime4 = self.m_nNextStartTime - 15 * 60
        local nStartTime4 = self.m_nNextStartTime
        local nEndTime4 = nReadyTime4 + (self:transformStringToTime(self.m_sFinalEndTime) - self:transformStringToTime(self.m_sFinalReadyTime))
        if nCurTime >= nReadyTime4 and nCurTime <= nEndTime4 then
            nLeftTime = nEndTime4 - nCurTime 
            nLeftTimeIndex = 2
        elseif nCurTime < nReadyTime4 then
            nLeftTime = nReadyTime4 - nCurTime
            nLeftTimeIndex = 1
        elseif nCurTime > nEndTime4 then
            if nCurDay == 20 then
                nLeftTime = 0 
                nLeftTimeIndex = 3
            else
                if self.m_nNextStartTime > nCurTime then 
                    nLeftTime = self.m_nNextStartTime - nCurTime
                    nLeftTimeIndex = 1
                else
                    nLeftTime = 0
                    nLeftTimeIndex = 4
                end
            end
        end
    else
        nLeftTime = 0
        nLeftTimeIndex = 3
    end

    return nLeftTime, nLeftTimeIndex
end

--@brief    获取当前进度
function SceneCommunityWar:getCurSection()
    -- body
    local nCurSection = 0
    local nCurDay = self:getCurDay(self.m_sCommunityTime)

    if nCurDay >= 1 and nCurDay <= 7 then
        nCurSection = 1
    elseif nCurDay >= 8 and nCurDay <= 14 then
        nCurSection = 2
    elseif nCurDay >= 15 and nCurDay <= 17 then
        nCurSection = 3
    elseif nCurDay >= 18 and nCurDay <= 20 then
        nCurSection = 4
    else
        nCurSection = 5
    end

    return nCurSection
end

--@brief    获取系统配置的比赛具体时间
function SceneCommunityWar:_getRaceTime()
    -- body
    local sOutRaceTime = CacheCenter:getGameParam()["warOutTime"]
    local sInRaceTime = CacheCenter:getGameParam()["warFinalistTime"]
    local sTempTime = SplitStringWithSeparator(sOutRaceTime, "-")
    WZLog("SceneCommunityWar:_getRaceTime", Serialize(sTempTime))
    self.m_sOutStartTime = sTempTime[1]      --出线赛开始时间
    self.m_sOutEndTime = sTempTime[2]        --出线赛结束时间
    sTempTime = SplitStringWithSeparator(sInRaceTime, "-")
    WZLog("SceneCommunityWar:_getRaceTime", Serialize(sTempTime))
    self.m_sInStartTime = sTempTime[1]       --入围赛开始时间
    self.m_sInEndTime = sTempTime[2]         --入围赛结束时间
end
-------------------------------------私有方法模块End----------------------------------------
