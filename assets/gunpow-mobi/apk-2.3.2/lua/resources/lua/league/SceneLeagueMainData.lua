--SceneLeagueMainData.lua
--@brief	SceneLeagueMain的数据模块
--@date		2016/06/12
--@author	zsq
--@note		英雄联赛主界面

SceneLeagueMain = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function SceneLeagueMain:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tDownloadFileList = nil
	self.m_nSize = nil
	self.m_tTop = nil
	self.m_tCheckWnd = nil
	self.m_tCheckElement = nil
	self.m_nCheckType = nil
	self.m_tCheckPoint = nil
	self.m_nTab = nil
	self.m_nJumpToTab = nil 
	self.m_tTime = nil
	self.m_tTimeList = nil
	self.m_nCaptain = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function SceneLeagueMain:_unInit()
	self.m_root = nil
	self.m_tDownloadFileList = nil
	self.m_nSize = nil
	self.m_tTop = nil
	self.m_tCheckWnd = nil
	self.m_tCheckElement = nil
	self.m_nCheckType = nil
	self.m_tCheckPoint = nil
	self.m_nTab = nil
	self.m_nJumpToTab = nil 
	self.m_tTime = nil
	self.m_tTimeList = nil
	self.m_nCaptain = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function SceneLeagueMain:createElement()
	WZLog("SceneLeagueMain:createElement")
	local element = WZUISystem:getInstance():createElement("SceneLeagueMain")
	assert(element, "SceneLeagueMain create element failed!")
	self:_init()
	return element
end

--@brief 	对战结束，返回联赛接口
--@param 	nTabIndex:标签索引：2->战队
function SceneLeagueMain:showInterface(nTabIndex,showBox)
	-- body
	--replaceScene(SceneCity:createElement())
	
	local leagueMain = SceneLeagueMain:createElement()
	local tabIndex = nTabIndex or 2
	self.m_nJumpToTab = tabIndex
	replaceScene(leagueMain)

	if showBox then
		MsgBoxManager:showConfirmBox(LocalStrings.LEAGUE67,nil,nil, MSGBOXLEVEL_NORMAL, nil,true)
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@param	表示时间的字符串  例如:1970.01.01 12:00
--@param 	bNextDay:true->增加1天，到凌晨；如传进来的是1970.01.01 12:00，最后得出1970.01.02 00:00
function SceneLeagueMain:transformStringToTime(date, bNextDay, bToday)
	WZLog("SceneLeagueMain:transformStringToTime", date)
	local time = date
	local time1 = SplitStringWithSeparator(time," ")
	local time2 = SplitStringWithSeparator(time1[#time1],":")

	local year = string.sub(time1[1],1,4)
	local month = string.sub(time1[1],6,7)
	local day = string.sub(time1[1],9,10)
	local hour = tonumber(time2[1])
	local min = tonumber(time2[2])

	if bNextDay then
		hour = 0
		min = 0
		local nSeconds = os.time({year=year,month=month,day=day,hour=hour,min=min})
		return nSeconds + 86400
	end

	if bToday == true then
		hour = 0
		min = 0
		local nSeconds = os.time({year=year,month=month,day=day,hour=hour,min=min})
		return nSeconds
	end
	
	return os.time({year=year,month=month,day=day,hour=hour,min=min})
end

--@brief	保存比赛时间
function SceneLeagueMain:saveGameTime(startTime32One, endTime32One, startTime32Two, endTime32Two, startTime32Three, endTime32Three, startTime16One, endTime16One, startTime16Two, endTime16Two, startTime16Three, endTime16Three, startTime8One, endTime8One, startTime8Two, endTime8Two, startTime8Three, endTime8Three, startTime4One, endTime4One, startTime4Two, endTime4Two, startTime4Three, endTime4Three, startTimeFOne, endTimeFOne, startTimeFTwo, endTimeFTwo, startTimeFThree, endTimeFThree, nowTime, startDateAll, endDateAll, startTimeAll, endTimeAll, startSignTime, endSignTime, winScore, failScore, applyPunish, makePairPunish)
	self.m_tTime = {}
	self.m_tTime.startTime32 = startTime32One
	self.m_tTime.startTime16 = startTime16One
	self.m_tTime.startTime8 = startTime8One
	self.m_tTime.endTime32 = endTime32One
	self.m_tTime.endTime16 = endTime16One
	self.m_tTime.endTime8 = endTime8One
	self.m_tTime.nowTime = nowTime
	self.m_tTime.startTimeAll = startDateAll.." "..startTimeAll
	self.m_tTime.endTimeAll = endDateAll.." "..endTimeAll
	self.m_tTime.startDateAll = startDateAll
	self.m_tTime.endDateAll = endDateAll
	self.m_tTime.startSignTime = startSignTime
	self.m_tTime.endSignTime = endSignTime
	self.m_tTime.startTime1 = startDateAll
	self.m_tTime.endTime1 = endDateAll
	self.m_tTime.startTime = startTimeAll
	self.m_tTime.endTime = endTimeAll
	self.m_tTime.winScore = winScore
	self.m_tTime.failScore = failScore
	self.m_tTime.applyPunish = applyPunish
	self.m_tTime.makePairPunish = makePairPunish
	
	self.m_tTime.startTimeFThree = startTimeFThree
	self.m_tTime.endTimeFThree = endTimeFThree
	WZLog("联赛时间",nowTime,startTime32One,endTimeFThree)

	self.m_tTimeList = {}
	self.m_tTimeList[#self.m_tTimeList+1] = startDateAll.." "..startTimeAll
	self.m_tTimeList[#self.m_tTimeList+1] = endDateAll.." "..endTimeAll
	self.m_tTimeList[#self.m_tTimeList+1] = startTime32One
	self.m_tTimeList[#self.m_tTimeList+1] = endTime32One
	self.m_tTimeList[#self.m_tTimeList+1] = startTime32Two
	self.m_tTimeList[#self.m_tTimeList+1] = endTime32Two
	self.m_tTimeList[#self.m_tTimeList+1] = startTime32Three
	self.m_tTimeList[#self.m_tTimeList+1] = endTime32Three
	self.m_tTimeList[#self.m_tTimeList+1] = startTime16One
	self.m_tTimeList[#self.m_tTimeList+1] = endTime16One
	self.m_tTimeList[#self.m_tTimeList+1] = startTime16Two
	self.m_tTimeList[#self.m_tTimeList+1] = endTime16Two
	self.m_tTimeList[#self.m_tTimeList+1] = startTime16Three
	self.m_tTimeList[#self.m_tTimeList+1] = endTime16Three
	self.m_tTimeList[#self.m_tTimeList+1] = startTime8One
	self.m_tTimeList[#self.m_tTimeList+1] = endTime8One
	self.m_tTimeList[#self.m_tTimeList+1] = startTime8Two
	self.m_tTimeList[#self.m_tTimeList+1] = endTime8Two
	self.m_tTimeList[#self.m_tTimeList+1] = startTime8Three
	self.m_tTimeList[#self.m_tTimeList+1] = endTime8Three
	self.m_tTimeList[#self.m_tTimeList+1] = startTime4One
	self.m_tTimeList[#self.m_tTimeList+1] = endTime4One
	self.m_tTimeList[#self.m_tTimeList+1] = startTime4Two
	self.m_tTimeList[#self.m_tTimeList+1] = endTime4Two
	self.m_tTimeList[#self.m_tTimeList+1] = startTime4Three
	self.m_tTimeList[#self.m_tTimeList+1] = endTime4Three
	self.m_tTimeList[#self.m_tTimeList+1] = startTimeFOne
	self.m_tTimeList[#self.m_tTimeList+1] = endTimeFOne
	self.m_tTimeList[#self.m_tTimeList+1] = startTimeFTwo
	self.m_tTimeList[#self.m_tTimeList+1] = endTimeFTwo
	self.m_tTimeList[#self.m_tTimeList+1] = startTimeFThree
	self.m_tTimeList[#self.m_tTimeList+1] = endTimeFThree

	if self.m_root ~= nil then
		self:tickTime()
		self.m_root:enableSchedule("tickTime",1)
	end

	WndLeagueMatch:setGameStartTag()
end

--@brief	当前时间计时器
function SceneLeagueMain:tickTime()
	if self.m_tTime.nowTime ~= nil then
		self.m_tTime.nowTime = self.m_tTime.nowTime + 1
	end

	if self.m_tTime.nowTime == nil then return end

	--计算当前比赛阶段
	WndLeagueTeamDetail.m_bGameStart = false
	WndLeagueTeamDetail.m_bFighting = false
	WndLeagueTeamDetail.m_bshowCountDown = false
	local timeList = SceneLeagueMain.m_tTimeList
	local countDown = 0
	local nowTime = SceneLeagueMain.m_tTime.nowTime--+86400*22+3600*10+60*2
	--例如:1970.01.01 12:00
	for i=1,16 do
		if i == 1 then
			--海选赛时,每天有时间段
			local todayStart = os.date("%Y.%m.%d",nowTime)..string.sub(timeList[1],-6)
			local todayEnd = os.date("%Y.%m.%d",nowTime)..string.sub(timeList[2],-6)
			if SceneLeagueMain:transformStringToTime(timeList[1]) < nowTime and SceneLeagueMain:transformStringToTime(todayStart) < nowTime and SceneLeagueMain:transformStringToTime(todayEnd) > nowTime and SceneLeagueMain:transformStringToTime(timeList[2]) > nowTime then
				WndLeagueTeamDetail.m_bGameStart = true
				WndLeagueTeamDetail.m_nGameStage = i
				countDown = 0
			end
		end
		--比赛前10分钟到比赛开始
		if i ~= 1 and SceneLeagueMain:transformStringToTime(timeList[i*2-1]) < nowTime + 600 and SceneLeagueMain:transformStringToTime(timeList[i*2-1]) > nowTime then
			WndLeagueTeamDetail.m_bGameStart = true
			countDown = 0
			WndLeagueTeamDetail.m_nGameStage = i
			if SceneLeagueMain:transformStringToTime(timeList[i*2-1]) > nowTime then
				WZLog("设置显示倒计时1")
				WndLeagueTeamDetail.m_bshowCountDown = true
				countDown = SceneLeagueMain:transformStringToTime(timeList[i*2-1]) - nowTime
			end
		end
		--比赛中
		if i ~= 1 and SceneLeagueMain:transformStringToTime(timeList[i*2-1]) < nowTime and SceneLeagueMain:transformStringToTime(timeList[i*2]) > nowTime then
			WndLeagueTeamDetail.m_bFighting = true
			WndLeagueTeamDetail.m_bGameStart = false
			countDown = SceneLeagueMain:transformStringToTime(timeList[i*2]) - nowTime
			WndLeagueTeamDetail.m_bshowCountDown = true
			WndLeagueTeamDetail.m_nGameStage = i
		end
		
			if i == 1 then
				if SceneLeagueMain:transformStringToTime(timeList[2]) > nowTime then
					countDown = 0
					WndLeagueTeamDetail.m_nGameStage = i
				end
			else
				--上一轮比赛结束到比赛开始
				if SceneLeagueMain:transformStringToTime(timeList[i*2-2]) < nowTime and SceneLeagueMain:transformStringToTime(timeList[i*2-1]) > nowTime then
					countDown = SceneLeagueMain:transformStringToTime(timeList[i*2-1]) - nowTime
					WndLeagueTeamDetail.m_nGameStage = i
					WZLog("设置显示倒计时2",i,countDown)
					WndLeagueTeamDetail.m_bshowCountDown = true
				end
			end
	end
	if SceneLeagueMain:transformStringToTime(timeList[32]) < nowTime then
		WndLeagueTeamDetail.m_bshowCountDown = false
		WndLeagueTeamDetail.m_nGameStage = 17
	end
	CacheCenter:setLeagueInfo(countDown, WndLeagueTeamDetail.m_nGameStage)

	--WZLog("SceneLeagueMain:tickTime",self:transformStringToTime(self.m_tTimeList[3]),self.m_tTime.nowTime)
	if WndLeagueMatch.m_root ~= nil then
		--设置比赛界面按钮文字
		if self:transformStringToTime(self.m_tTimeList[3]) < self.m_tTime.nowTime then
			local txtGoToFight = GetElement(WndLeagueMatch.m_root,"txtGoToFight",WZUILabelTTF)
			txtGoToFight:setText(LocalStrings.LEAGUE110)
			if ProjConfig.LANGUAGE == "vn" then
				txtGoToFight:setScale(0.8)
				txtGoToFight:setDimensions(GlobalMethod:CCSize(130,0))
			end
		else
			GetElement(WndLeagueMatch.m_root,"txtGoToFight",WZUILabelTTF):setText(LocalStrings.LEAGUE96)
		end
	end
end

--@brief	适配分辨率
function SceneLeagueMain:AdaptResolution()
	do return end
	local directorSize = CCDirector:sharedDirector():getOpenGLView():getFrameSize()
	WZLog("SceneLeagueMain:AdaptResolution",directorSize.height)
	--iphone5适配
	if directorSize.width > 1136 then
	end
	--ipad适配
	if directorSize.width == 1024 and directorSize.height == 768 then
		GetElement(self.m_root,"checkGroup_SceneLeagueMain",WZUICheckBoxGroup):setRelativePosition(GlobalMethod:ccp(0.5,0.8))
	end
	if directorSize.width == 2048 and directorSize.height == 1536 then
		GetElement(self.m_root,"checkGroup_SceneLeagueMain",WZUICheckBoxGroup):setRelativePosition(GlobalMethod:ccp(0.5,0.8))
	end
end
-------------------------------------私有方法模块End----------------------------------------
