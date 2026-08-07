--WndWelfareData.lua
--@brief	WndWelfare的数据模块
--@date		2016/05/13
--@author	Tianxiang_Xu
--@note		福利

WndWelfare = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function WndWelfare:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tListItem = nil 		--左按钮列表
	self.m_nType 	= nil 		--界面类型 ：1->福利；2->比赛
	self.m_tWelfareList = {{name = LocalStrings.SingInTitle, ui_id = 79, button_id = 18},
						   {name = LocalStrings.FUNDINFO6, ui_id = 115, button_id = 19},
                           {name = LocalStrings.GAME_ACTIVITY_TITLE34, ui_id = 165, button_id = 18},
                           --{name = LocalStrings.LUCKY_GIFT,ui_id = 190,button_id = 97},
                           {name = LocalStrings.ATH_REWARD_CHECK, ui_id = 999998, button_id = 69}
						}
    --欧洲渠道
    if ProjConfig.CHANNEL_ID == 1061 or ProjConfig.CHANNEL_ID == 1062 or ProjConfig.CHANNEL_ID == 1051 or ProjConfig.CHANNEL_ID == 1048 or ProjConfig.CHANNEL_ID == 1053 or ProjConfig.CHANNEL_ID == 1060 then                    
        self.m_tCompeteList = {{name = LocalStrings.BATTLE_MODEL_RANK, ui_id = 118, button_id = 23},
                            {name = LocalStrings.SETTLMENT_GANGFIGHT, ui_id = 110, button_id = 56},
                            {name = LocalStrings.LEAGUE10, ui_id = 156, button_id = 71},
                            -- {name = LocalStrings.WELFARE_COMPETE1, ui_id = 181, button_id = 84},
                            }
    else
	    self.m_tCompeteList = {{name = LocalStrings.BATTLE_MODEL_RANK, ui_id = 118, button_id = 23},
                            {name = LocalStrings.SETTLMENT_GANGFIGHT, ui_id = 110, button_id = 56},
                            {name = LocalStrings.LEAGUE10, ui_id = 156, button_id = 71},
                            {name = LocalStrings.WELFARE_COMPETE1, ui_id = 181, button_id = 84},
							}
    end
	self.m_nCurUIId = nil 		--当前UIId 
	self.m_tLeftCell = nil 		--保存左边栏相应的表结构
	self.m_tPanelElement = nil
	self.m_tPanelLuaObj = nil 
	self.m_nLoadingId = nil 	
	self.m_tData = nil 
	self.m_nListItemServerTime = nil
	self.m_tTempListItem = nil
	self.m_tMsgData = nil 
    self.m_nLeagueStartTime = nil 
    self.m_nLeagueEndTime = nil 
    self.m_nLeagueType = nil 
    self.m_nCommunityState = nil    --公会战开启状态（1为开启，0为没开启）
    self.m_sCommunityTime = nil     --当前的日期格式串
    self.m_nNextStartTime = nil  --公会战开启倒计时
end

--@brief    反初始化表的成员变量
--@note     在退出场景时回调的onExit函数里面必须调用本函数
function WndWelfare:_unInit()
    self.m_root = nil
    self.m_nType    = nil       --界面类型 ：1->福利；2->比赛
    self.m_tWelfareList = nil
    self.m_tCompeteList = nil
    self.m_nCurUIId = nil       --当前UIId 
    self.m_tLeftCell = nil      --保存左边栏相应的表结构
    self.m_tPanelElement = nil
    self.m_tPanelLuaObj = nil 
    self.m_nLoadingId = nil     
    self.m_tData = nil 
    self.m_nListItemServerTime = nil
    self.m_tTempListItem = nil
    self.m_tMsgData = nil 
    self.m_nLeagueStartTime = nil 
    self.m_nLeagueEndTime = nil 
    self.m_nLeagueType = nil        --联赛进度：0->没有比赛；1->海选赛；2->小组赛；3->16强；4->8强
    self.m_nCommunityState = nil 
    self.m_sCommunityTime = nil 
    self.m_nNextStartTime = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function WndWelfare:createElement()
	local element = WZUISystem:getInstance():createElement("WndWelfare")
	assert(element, "WndWelfare create element failed!")
	self:_init()
	return element
end

--@brief    外部接口
--@param 	nType : 界面类型：1->福利；2->比赛；6->回归活动
--@param    ui_id: 活动类型，值从m_tListItem列表中的ui_id取
--@tMsg     从消息列表传过来的数据
function WndWelfare:showInterface(nType, ui_id, tMsg)
    -- body
    if CheckButtonOpen(69) then
        local wndWelfare = WndWelfare:createElement()
        if wndWelfare ~= nil then
            self.m_nType = nType
            WindowManager:addWindow(wndWelfare,WndWelfare)
            self.m_nCurUIId = ui_id
            if tMsg then
                self.m_tMsgData = tMsg
            end
        end
    end
end

--@brief 	网络成功返回数据后调用
--@param 	nSeason:赛季
function WndWelfare:onReceiveDataOK(currentSeason, startTimestamp, endTimestamp, isInActivity, startTime, endTime)
	self:_closeLoading()
	if self.m_tData == nil then
		self.m_tData = {}
	end
    local tInitDate = json.decode(CacheCenter:getGameParam()["trioRankMatchConfig"]) 
	WZLog("WndWelfare:onReceiveDataOK", currentSeason, startTimestamp, endTimestamp, isInActivity)
	local sYear, sMonth, sDay, eYear, eMonth, eDay = ScenePvpRank:parseTime(startTimestamp, endTimestamp)
	self.m_tData.season = currentSeason
    self.m_tData.startYear = sYear
    self.m_tData.endYear = eYear
    self.m_tData.startMonth = sMonth
    self.m_tData.endMonth = eMonth
    self.m_tData.startDay = sDay
    self.m_tData.endDay = eDay
    self.m_tData.startTime = tInitDate.startTime
    self.m_tData.endTime = tInitDate.endTime
    self.m_tData.seasonStatus = isInActivity
    self.m_tData.start_Time = startTime
    self.m_tData.end_Time = endTime

	self:_updateRightContent()
end

--@brief    网络成功返回英雄联赛时间数据后调用
--@param    nSeason:赛季
function WndWelfare:onReceiveLeagueDataOK(startTime32,startTime16,startTime8, endTime32, endTime16, endTime8, nowTime, startTimeAll, endTimeAll)
    if self.m_root == nil then return end
    -- body
    self:_closeLoading()
    if self.m_tData == nil then
        self.m_tData = {}
    end

    WZLog("WndWelfare:onReceiveLeagueDataOK", startTime32,startTime16,startTime8, endTime32, endTime16, endTime8, nowTime, startTimeAll, endTimeAll)
    self.m_tData.LeagueTime = {}

    self.m_tData.LeagueTime[1] = SceneLeagueMain:transformStringToTime(startTimeAll)
    self.m_tData.LeagueTime[2] = SceneLeagueMain:transformStringToTime(endTimeAll)
    self.m_tData.LeagueTime[3] = SceneLeagueMain:transformStringToTime(startTime32)
    self.m_tData.LeagueTime[4] = SceneLeagueMain:transformStringToTime(endTime32)
    self.m_tData.LeagueTime[5] = SceneLeagueMain:transformStringToTime(startTime16)
    self.m_tData.LeagueTime[6] = SceneLeagueMain:transformStringToTime(endTime16)
    self.m_tData.LeagueTime[7] = SceneLeagueMain:transformStringToTime(startTime8)
    self.m_tData.LeagueTime[8] = SceneLeagueMain:transformStringToTime(endTime8)

    WZLog("WndWelfare:onReceiveLeagueDataOK 111", nowTime, Serialize(self.m_tData.LeagueTime))
    local nLeagueStarTime = nil 
    local nLeagueEndTime = nil 

    if nowTime < self.m_tData.LeagueTime[1] then
        --进行海选赛
        nLeagueStarTime = self.m_tData.LeagueTime[1] 
        nLeagueEndTime = self.m_tData.LeagueTime[2] 
        self.m_nLeagueType = 0 
    elseif nowTime >= self.m_tData.LeagueTime[1] and nowTime <= self.m_tData.LeagueTime[2] then
        --海选赛进行中
        nLeagueStarTime = self.m_tData.LeagueTime[1] 
        nLeagueEndTime = self.m_tData.LeagueTime[2] 
        self.m_nLeagueType = 1 
    elseif nowTime > self.m_tData.LeagueTime[2] and nowTime < self.m_tData.LeagueTime[3] then
        --进行小组赛
        nLeagueStarTime = self.m_tData.LeagueTime[3] 
        nLeagueEndTime = self.m_tData.LeagueTime[4] 
        self.m_nLeagueType = 6
    elseif nowTime >= self.m_tData.LeagueTime[3] and nowTime <= self.m_tData.LeagueTime[4] then
        --小组赛进行中
        nLeagueStarTime = self.m_tData.LeagueTime[3] 
        nLeagueEndTime = self.m_tData.LeagueTime[4] 
        self.m_nLeagueType = 2 
    elseif nowTime > self.m_tData.LeagueTime[4] and nowTime < self.m_tData.LeagueTime[5] then
        --进行十六强比赛
        nLeagueStarTime = self.m_tData.LeagueTime[5] 
        nLeagueEndTime = self.m_tData.LeagueTime[6] 
        self.m_nLeagueType = 7
    elseif nowTime >= self.m_tData.LeagueTime[5] and nowTime <= self.m_tData.LeagueTime[6] then
        --十六强进行中
        nLeagueStarTime = self.m_tData.LeagueTime[5] 
        nLeagueEndTime = self.m_tData.LeagueTime[6] 
        self.m_nLeagueType = 3 
    elseif nowTime >= self.m_tData.LeagueTime[6] and nowTime <= self.m_tData.LeagueTime[7] then
        --进行8强
        nLeagueStarTime = self.m_tData.LeagueTime[7] 
        nLeagueEndTime = self.m_tData.LeagueTime[8] 
        self.m_nLeagueType = 8 
    elseif nowTime >= self.m_tData.LeagueTime[7] and nowTime <= self.m_tData.LeagueTime[8] then
        --8强进行中
        nLeagueStarTime = self.m_tData.LeagueTime[7] 
        nLeagueEndTime = self.m_tData.LeagueTime[8] 
        self.m_nLeagueType = 4 
    elseif nowTime > self.m_tData.LeagueTime[8] then
        self.m_nLeagueType = 5 
    end

    self.m_nLeagueStartTime = nLeagueStarTime
    self.m_nLeagueEndTime = nLeagueEndTime

    self:_updateRightContent()
end

--@brief    获取公会战信息成功
function WndWelfare:onReceiveCommunityWarTimeOK(nowtime, startime, open)
    -- body
    if self.m_root == nil then return end
    -- body
    self:_closeLoading()
    WZLog("WndWelfare:onReceiveCommunityWarTimeOK", nowtime, startime, open, SystemTime:getServerTime())
    self.m_nCommunityState = open 
    self.m_sCommunityTime = nowtime 
    self.m_nNextStartTime = startime

    self:_updateRightContent()
end

--@brief 	获得列表成功
function WndWelfare:GetWelfareListInfoOK( activityId, title, startTime, endTime, serverTime , types, type2)
	--body
    if self.m_root == nil then return end
	self.m_nListItemServerTime = serverTime
	local index = 1 
    self.m_tTempListItem = {}
	for i=1,#activityId do
		WZLog("WndWelfare:GetWelfareListInfoOK", type2[i])
		if type2[i] == self.m_nType then    --1 的才是福利; 6 是回归活动
    		if serverTime < endTime[i] then 
    			if types[i]>0 then 
    				self.m_tTempListItem[index] = {}
    				self.m_tTempListItem[index].activityId = activityId[i]
    				self.m_tTempListItem[index].title = g_tGameActivityTitle[types[i]]
    				self.m_tTempListItem[index].startTime = startTime[i]
    				self.m_tTempListItem[index].endTime = endTime[i]
    				self.m_tTempListItem[index].type = types[i]
    				index = index + 1
    			end 
    		end 
        end
	end
	self:_closeLoading()
	self:_update()
end

function WndWelfare:GetActivityInfoOK(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,target)
	self:_closeLoading()
    WZLog("********* WndWelfare:GetActivityInfoOK *****")
	self:_updateActivityContext(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,target)
end

--@brief 获取奖励成功
function WndWelfare:GetRewardOk(rewardItems,rewardCount,ntype)
	if self.m_root == nil then return end
	WZLog("WndWelfare:GetRewardOk type="..ntype)
	if ntype == g_tGameActivityTypes.ACTIVITY_FIRSTRECHARGE then 
		CellRechargePanelActivity:showRewardBox(0,rewardItems,rewardCount)
	elseif ntype == g_tGameActivityTypes.ACTIVITY_TOTALFIRSTRECHARGE or g_tGameActivityTypes.ACTIVITY_CUMULATIVECOST == ntype or g_tGameActivityTypes.ACTIVITY_STRENGTHEN == ntype  then 
		CellTotalRechargeItem:ACTIVITY_ReceiveActivityRewardOk(rewardItems,rewardCount)
	elseif ntype == g_tGameActivityTypes.ACTIVITY_GRADE then 
		CellLevelSprintPanelItem:ACTIVITY_ReceiveActivityRewardOk(rewardItems,rewardCount)
	elseif ntype == g_tGameActivityTypes.ACTIVITY_CUMULATIVELOGIN then 
        CellGradePanelItem:ACTIVITY_ReceiveActivityRewardOk(rewardItems,rewardCount)
	elseif ntype == g_tGameActivityTypes.ACTIVITY_TIMEDLOGIN then 
		CellGradePanelItem:ACTIVITY_ReceiveActivityRewardOk(rewardItems,rewardCount)
	elseif ntype == g_tGameActivityTypes.ACTIVITY_IMPROVEFIGHT then 
		CellFightingPanelItem:ACTIVITY_ReceiveActivityRewardOk(rewardItems,rewardCount)
	elseif ntype == g_tGameActivityTypes.ACTIVITY_DISCOUNTGIFBAG then 
		CellActivityGifPanel:ACTIVITY_ReceiveActivityRewardOk(rewardItems,rewardCount)
	elseif ntype == g_tGameActivityTypes.ACTIVITY_VIPGIFBAG then 
		CellActivityVipItem:ACTIVITY_ReceiveActivityRewardOk(rewardItems,rewardCount)
	elseif ntype == g_tGameActivityTypes.ACTIVITY_TARGETREWARD_1 or g_tGameActivityTypes.ACTIVITY_TARGETREWARD_2 ==ntype or g_tGameActivityTypes.ACTIVITY_TARGETREWARD_3 == ntype or g_tGameActivityTypes.ACTIVITY_TARGETREWARD_4 == ntype then 
		CellCostActivityItem:ACTIVITY_ReceiveActivityRewardOk(rewardItems,rewardCount)
    elseif ntype == g_tGameActivityTypes.ACTIVITY_EASTTHINGS then
        CellEatthingsPanel:ACTIVITY_TasteOk()
    elseif ntype == g_tGameActivityTypes.ACTIVITY_DAILYFIRSTRECHARGE then 
        CellDailyFirstRecharge:ACTIVITY_ReceiveActivityRewardOk(rewardItems,rewardCount, nType)
    elseif ntype == g_tGameActivityTypes.ACTIVITY_TIMEDFIRSTRECHARGE then 
        CellTimeFirstRecharge:ACTIVITY_ReceiveActivityRewardOk(rewardItems,rewardCount, nType)
    elseif ntype == g_tGameActivityTypes.ACTIVITY_BACK_LOGIN then 
        CellGradePanelItem:ACTIVITY_ReceiveActivityRewardOk(rewardItems, rewardCount)
    elseif ntype == g_tGameActivityTypes.ACTIVITY_BACK_RECHARGE then 
        CellTotalRechargeItem:ACTIVITY_ReceiveActivityRewardOk(rewardItems, rewardCount)
    elseif ntype == g_tGameActivityTypes.ACTIVITY_BACK_FIGHT then 
        CellBackFightItem:ACTIVITY_ReceiveActivityRewardOk(rewardItems, rewardCount)
    -- elseif ntype == g_tGameActivityTypes.ACTIVITY_TODAYRECHARGE then
    --     CellTodayRechargeItem:ACTIVITY_ReceiveActivityRewardOk(rewardItems,rewardCount)
	end 

	self:removeRedDot(ntype)
end

--@brief 	移除福利中某福利的红点
function WndWelfare:removeRedDot(ntype)
	-- body
	if self.m_root == nil then return end
	local m_bIsContainerActivityType = false
    if self.m_nType == 6 then 
        if CacheCenter.m_tBackActivityRedDotList ~= nil then
            for idx=1,#CacheCenter.m_tBackActivityRedDotList do
                if ntype == CacheCenter.m_tBackActivityRedDotList[idx] then 
                    m_bIsContainerActivityType = true  
                end 
            end
        end
    else
        if CacheCenter.m_tWelfareItemRedDotList ~= nil then
        	for idx=1,#CacheCenter.m_tWelfareItemRedDotList do
                if ntype == CacheCenter.m_tWelfareItemRedDotList[idx] then 
                    m_bIsContainerActivityType = true  
                end 
            end
        end
    end

    if m_bIsContainerActivityType == false then 
    	for i=1,#self.m_tLeftCell do
    	 	local cellTab = self.m_tLeftCell[i]
    	 	local ui_id = cellTab:getItemId()
    	 	if tonumber(ntype) == ui_id then 
    	 		cellTab:removeRedDot()
    	 		return
    	 	end 
    	end 
    end 
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    获取第一个红点的ui_id
function WndWelfare:_getFirstRedDotItem()
    -- body
    local nFirstUI_Id = nil 
    local nFirstIndex = nil 

    for i = 1, #self.m_tListItem do
        if self.m_nType == 6 then 
            if CacheCenter.m_tBackActivityRedDotList then
                for idx = 1, #CacheCenter.m_tBackActivityRedDotList do
                    if self.m_tListItem[i].ui_id == CacheCenter.m_tBackActivityRedDotList[idx] then
                        nFirstUI_Id = self.m_tListItem[i].ui_id
                        nFirstIndex = i
                        break 
                    end
                end
                if nFirstUI_Id then 
                    break
                end
            end
        else
            if CacheCenter.m_tWelfareItemRedDotList then
                for idx = 1, #CacheCenter.m_tWelfareItemRedDotList do
                    if self.m_tListItem[i].ui_id == CacheCenter.m_tWelfareItemRedDotList[idx] then
                        nFirstUI_Id = self.m_tListItem[i].ui_id
                        nFirstIndex = i
                        break 
                    end
                end
                if nFirstUI_Id then 
                    break
                end
            end
        end
    end

    return nFirstUI_Id, nFirstIndex
end

-------------------------------------私有方法模块End----------------------------------------
