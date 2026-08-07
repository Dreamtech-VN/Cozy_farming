--[[
	活动事件触发器
]]
WndNationalEvent = {
	WndNationalEvent_FestivalLogin = "WndNationalEvent_FestivalLogin", --节日登录信息详情
	WndNationalEvent_GetInfo = "WndNationalEvent_GetInfo", --节日登录领取
	WndNationalEvent_AnswerInfoData = "WndNationalEvent_AnswerInfo", --获取我的答题信息
	WndNationalEvent_StartAnswerResult = "WndNationalEvent_StartAnswerResult", --开始答题后获取到的题目
	WndNationalEvent_GetAnswerRewardInfo = "WndNationalEvent_GetAnswerRewardInfo", --获取答题的奖励信息
	WndNationalEvent_GetAnswerRankTotal = "WndNationalEvent_GetAnswerRankTotal", --获取答题总排行榜
	WndNationalEvent_GetAnswerRankGuild = "WndNationalEvent_GetAnswerRankGuild", --获取答题公会排行榜
	WndNationalEvent_GetAnswerRankReward = "WndNationalEvent_GetAnswerRankReward", --排行榜奖励
	WndNationalEvent_GetEveryDayInfo = "WndNationalEvent_GetEveryDayInfo", --每日必备基本信息
	WndNationalEvent_GetEveryDayGetReward = "WndNationalEvent_GetEveryDayGetReward", --每日必备领取奖励
	WndNationalEvent_GetEveryDayBuyResult = "WndNationalEvent_GetEveryDayBuyResult", --每日必备购买返回
	WndNationalEvent_NewYearInfo = "WndNationalEvent_NewYearInfo", --元旦求签基本信息
	WndNationalEvent_NewYearSignResult = "WndNationalEvent_NewYearSignResult", --元旦求签返回
	WndNationalEvent_NewYearRankInfo = "WndNationalEvent_NewYearRankInfo", --元旦求签排行榜基本信息
	WndNationalEvent_NewYearTaskInfo = "WndNationalEvent_NewYearTaskInfo", --元旦求签任务基本信息
	WndNationalEvent_NewYearTaskGet = "WndNationalEvent_NewYearTaskGet", --元旦求签任务领取
	WndNationalEvent_NewYearSignGet = "WndNationalEvent_NewYearSignGet", --元旦求签签到领取

	WndNationalEvent_GetTaskList = "WndNationalEvent_GetTaskList", --请求任务列表
	WndNationalEvent_GetResult = "WndNationalEvent_GetResult", --任务领取返回
	
	WndNationalEvent_GetProtocal108Result = "WndNationalEvent_GetProtocal108Result", --108领取返回
	WndNationalEvent_GetRankResult = "WndNationalEvent_GetRankResult", --排行榜返回
	WndNationalEvent_GetActivityTitleName = "WndNationalEvent_GetActivityTitleName", --新年活动获取标题
	WndNationalEvent_GetHistoryRankResult = "WndNationalEvent_GetHistoryRankResult", --历届榜首
	WndNationalEvent_WorshipHistoryRankResult = "WndNationalEvent_WorshipHistoryRankResult", --膜拜历届榜首

	WndNationalEvent_GiftItemChoose = "WndNationalEvent_GiftItemChoose", --崛起之路的礼包物品选择
	WndNationalEvent_BuyGiftResult = "WndNationalEvent_BuyGiftResult", --崛起之路购买礼包返回
}

--@brief 	射箭活动事件
ShootArrowEvent = {
	ShootArrowEvent_TeamInfoList = "ShootArrowEvent_TeamInfoList", --队伍信息列表
	ShootArrowEvent_TeamReward = "ShootArrowEvent_TeamReward", --组队奖励
}

--@brief 	大厅特权活动事件
LobbyPrivilegesEvent = {
	LobbyPrivilegesEvent_NewbieReceive = "LobbyPrivilegesEvent_NewbieReceive", --新手礼包领取
	LobbyPrivilegesEvent_GrowthReceive = "LobbyPrivilegesEvent_GrowthReceive", --成长礼包领取
}

--@brief 	独立活动红点事件
Independent_Activity = {
	ActivityReddot = "Activity_Reddot",
}

--@brief 	度假村事件
HolidayVillageEvent = {
	HolidayVillageEvent_Rank = "HolidayVillageEvent_Rank", --全服排行榜
	HolidayVillageEvent_Field = "HolidayVillageEvent_Field", --土坑数据更新
	HolidayVillageEvent_Store = "HolidayVillageEvent_Store", --获取仓库数据
	HolidayVillageEvent_Visitors = "HolidayVillageEvent_Visitors", --访问者
}
