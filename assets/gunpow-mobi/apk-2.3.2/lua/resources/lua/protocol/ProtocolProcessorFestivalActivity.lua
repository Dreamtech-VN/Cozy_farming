--@note 	节日活动相关协议
-- 活动系统相关协议2.xlsx

ProtocolProcessorFestivalActivity = ProtocolProcessorBase:new()

-------------------------------------公有方法模块--------------------------------------

--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorFestivalActivity:regAll()
	--@brief	获取我的答题信息（ACTIVITY2_GetInterestingAnswerInfo = 52）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetInterestingAnswerInfo, "ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetInterestingAnswerInfo_ErrorProcess", "is" )
	--@brief	获取我的答题信息（ACTIVITY2_GetInterestingAnswerInfoOk = 53）
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetInterestingAnswerInfoOk, "ProtocolProcessorFestivalActivity:parse_ACTIVITY2_GetInterestingAnswerInfoOk", "tiiivivt")
	--@brief	获取题目（ACTIVITY2_GetInterestingAnswer = 54）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetInterestingAnswer, "ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetInterestingAnswer_ErrorProcess", "is" )
	--@brief	获取题目（ACTIVITY2_GetInterestingAnswerOk = 55）
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetInterestingAnswerOk, "ProtocolProcessorFestivalActivity:parse_ACTIVITY2_GetInterestingAnswerOk", "tisvs")
	--@brief	获取答题个人排行榜（ACTIVITY2_GetInterestingAnswerRanking = 56）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetInterestingAnswerRanking, "ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetInterestingAnswerRanking_ErrorProcess", "is" )
	--@brief	获取答题个人排行榜（ACTIVITY2_GetInterestingAnswerRankingOk = 57）
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetInterestingAnswerRankingOk, "ProtocolProcessorFestivalActivity:parse_ACTIVITY2_GetInterestingAnswerRankingOk", "iiivivivivivsvivivivtvivt")
	--@brief	获取答题公会排行榜（ACTIVITY2_GetInterestingAnswerGuildRanking = 58）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetInterestingAnswerGuildRanking, "ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetInterestingAnswerGuildRanking_ErrorProcess", "is" )
	--@brief	获取答题公会排行榜（ACTIVITY2_GetInterestingAnswerGuildRankingOk = 59）
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetInterestingAnswerGuildRankingOk, "ProtocolProcessorFestivalActivity:parse_ACTIVITY2_GetInterestingAnswerGuildRankingOk", "iiivivivivsvi")
	--@brief	领取答题奖励（ACTIVITY2_ReceiveInterestingReward = 60）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_ReceiveInterestingReward, "ProtocolProcessorFestivalActivity:send_ACTIVITY2_ReceiveInterestingReward_ErrorProcess", "is" )
	--@brief	领取答题奖励（ACTIVITY2_ReceiveInterestingRewardOk = 61）
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_ReceiveInterestingRewardOk, "ProtocolProcessorFestivalActivity:parse_ACTIVITY2_ReceiveInterestingRewardOk", "tvivi")
	--@brief	排行榜奖励（ACTIVITY2_GetInterestingReward = 62）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetInterestingReward, "ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetInterestingReward_ErrorProcess", "is" )
	--@brief	排行榜奖励（ACTIVITY2_GetInterestingRewardOk = 63）
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetInterestingRewardOk, "ProtocolProcessorFestivalActivity:parse_ACTIVITY2_GetInterestingRewardOk", "tvsvivivi")
	--@brief	答题（ACTIVITY2_InterestingAnswer = 64）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_InterestingAnswer, "ProtocolProcessorFestivalActivity:send_ACTIVITY2_InterestingAnswer_ErrorProcess", "is" )
	--@brief	答题（ACTIVITY2_InterestingAnswerOk = 65）
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_InterestingAnswerOk, "ProtocolProcessorFestivalActivity:parse_ACTIVITY2_InterestingAnswerOk", "ts")
	--@brief	任务奖励（ACTIVITY2_GetInterestingAnswerRewardOk = 66）
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetInterestingAnswerRewardOk, "ProtocolProcessorFestivalActivity:parse_ACTIVITY2_GetInterestingAnswerRewardOk", "vivivivivi")

end
--全民购物的协议
function ProtocolProcessorFestivalActivity:regAll1()
	--@brief	获取优惠券信息（ACTIVITY2_GetShoppingCoupon = 67）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetShoppingCoupon, "ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetShoppingCoupon_ErrorProcess", "is" )
	--@brief	获取优惠券信息（ACTIVITY2_GetShoppingCouponOk = 68）
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetShoppingCouponOk, "ProtocolProcessorFestivalActivity:parse_ACTIVITY2_GetShoppingCouponOk", "vivivivivsvsvivi")
	--@brief	添加到购物车（ACTIVITY2_AddToShoppingCar = 69）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_AddToShoppingCar, "ProtocolProcessorFestivalActivity:send_ACTIVITY2_AddToShoppingCar_ErrorProcess", "is" )
	--@brief	添加到购物车（ACTIVITY2_AddToShoppingCarOk = 70）
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_AddToShoppingCarOk, "ProtocolProcessorFestivalActivity:parse_ACTIVITY2_AddToShoppingCarOk", "it")
	--@brief	付款（ACTIVITY2_PayForShoppingCar = 71）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_PayForShoppingCar, "ProtocolProcessorFestivalActivity:send_ACTIVITY2_PayForShoppingCar_ErrorProcess", "is" )
	--@brief	支付购物车（ACTIVITY2_PayForShoppingCarOk = 72）
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_PayForShoppingCarOk, "ProtocolProcessorFestivalActivity:parse_ACTIVITY2_PayForShoppingCarOk", "tvivii")
	--@brief	获取排行榜相关（ACTIVITY2_GetShoppingRanking = 73）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetShoppingRanking, "ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetShoppingRanking_ErrorProcess", "is" )
	--@brief	获取排行榜相关（ACTIVITY2_GetShoppingRankingOk = 74）
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetShoppingRankingOk, "ProtocolProcessorFestivalActivity:parse_ACTIVITY2_GetShoppingRankingOk", "iivsvivivivivivivivsvivivivtvt")
end
--藏宝图
function ProtocolProcessorFestivalActivity:regAll2()
	--@brief	获取活动详情信息（ACTIVITY2_TreasureActivityInfo = 75）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_TreasureActivityInfo, "ProtocolProcessorFestivalActivity:send_ACTIVITY2_TreasureActivityInfo_ErrorProcess", "is" )
	--@brief	获取活动详情信息（ACTIVITY2_TreasureActivityInfoOk = 76）
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_TreasureActivityInfoOk, "ProtocolProcessorFestivalActivity:parse_ACTIVITY2_TreasureActivityInfoOk", "iiiiviviviviviivtti")
	--@brief	寻宝（ACTIVITY2_Treasure = 77）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_Treasure, "ProtocolProcessorFestivalActivity:send_ACTIVITY2_Treasure_ErrorProcess", "is" )
	--@brief	寻宝结果（ACTIVITY2_TreasureOk = 78）
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_TreasureOk, "ProtocolProcessorFestivalActivity:parse_ACTIVITY2_TreasureOk", "ivivivivi")
	--@brief	领取奖励（ACTIVITY2_TreasureReceiveReward = 79）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_TreasureReceiveReward, "ProtocolProcessorFestivalActivity:send_ACTIVITY2_TreasureReceiveReward_ErrorProcess", "is" )
	--@brief	领取奖励结果（ACTIVITY2_TreasureReceiveRewardOk = 80）
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_TreasureReceiveRewardOk, "ProtocolProcessorFestivalActivity:parse_ACTIVITY2_TreasureReceiveRewardOk", "itivivi")
	--@brief	获取排行榜相关（ACTIVITY2_TreasureRankingList = 81）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_TreasureRankingList, "ProtocolProcessorFestivalActivity:send_ACTIVITY2_TreasureRankingList_ErrorProcess", "is" )
	--@brief	获取排行榜相关（ACTIVITY2_TreasureRankingListOk = 82）
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_TreasureRankingListOk, "ProtocolProcessorFestivalActivity:parse_ACTIVITY2_TreasureRankingListOk", "sivivsvivivivtvnvi")

end
--每日必购
function ProtocolProcessorFestivalActivity:regAll3()
	--@brief	获取活动详情信息（ACTIVITY2_DailyBuyActivityInfo = 83）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_DailyBuyActivityInfo, "ProtocolProcessorFestivalActivity:send_ACTIVITY2_DailyBuyActivityInfo_ErrorProcess", "is" )
	--@brief	获取活动详情信息（ACTIVITY2_DailyBuyActivityInfoOk = 84）
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_DailyBuyActivityInfoOk, "ProtocolProcessorFestivalActivity:parse_ACTIVITY2_DailyBuyActivityInfoOk", "iiiiviviviviviviviviviivivt")
	--@brief	预购（ACTIVITY2_DailyBuyPreorder = 85）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_DailyBuyPreorder, "ProtocolProcessorFestivalActivity:send_ACTIVITY2_DailyBuyPreorder_ErrorProcess", "is" )
	--@brief	预购（ACTIVITY2_DailyBuyPreorderOk = 86）
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_DailyBuyPreorderOk, "ProtocolProcessorFestivalActivity:parse_ACTIVITY2_DailyBuyPreorderOk", "ii")
	--@brief	领取奖励（ACTIVITY2_DailyBuyReceiveReward = 87）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_DailyBuyReceiveReward, "ProtocolProcessorFestivalActivity:send_ACTIVITY2_DailyBuyReceiveReward_ErrorProcess", "is" )
	--@brief	领取奖励（ACTIVITY2_DailyBuyReceiveRewardOk = 88）
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_DailyBuyReceiveRewardOk, "ProtocolProcessorFestivalActivity:parse_ACTIVITY2_DailyBuyReceiveRewardOk", "iviviiivivt")

end
--元旦求签
function ProtocolProcessorFestivalActivity:regAll4()
	--@brief	获取活动详情信息（ACTIVITY2_Activity6120Info = 89）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_Activity6120Info, "ProtocolProcessorFestivalActivity:send_ACTIVITY2_Activity6120Info_ErrorProcess", "is" )
	--@brief	获取活动详情信息（ACTIVITY2_Activity6120InfoOk = 90）
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_Activity6120InfoOk, "ProtocolProcessorFestivalActivity:parse_ACTIVITY2_Activity6120InfoOk", "iiiiitb")
	--@brief	获取活动详情信息（ACTIVITY2_Activity6120DoOk = 92）
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_Activity6120DoOk, "ProtocolProcessorFestivalActivity:parse_ACTIVITY2_Activity6120DoOk", "iviviitb")
	--@brief	获取活动详情信息（ACTIVITY2_Activity6120TaskListOk = 94）
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_Activity6120TaskListOk, "ProtocolProcessorFestivalActivity:parse_ACTIVITY2_Activity6120TaskListOk", "vivtvtvivivivivi")
	--@brief	获取活动详情信息（ACTIVITY2_Activity6120ReceiveRewardOk = 96）
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_Activity6120ReceiveRewardOk, "ProtocolProcessorFestivalActivity:parse_ACTIVITY2_Activity6120ReceiveRewardOk", "tvivi")
	--@brief	获取活动详情信息（ACTIVITY2_Activity6120ReceiveTaskRewardOk = 98）
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_Activity6120ReceiveTaskRewardOk, "ProtocolProcessorFestivalActivity:parse_ACTIVITY2_Activity6120ReceiveTaskRewardOk", "titbvivi")
	--@brief	获取排行榜相关（ACTIVITY2_Activity6120RankingListOk = 100）
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_Activity6120RankingListOk, "ProtocolProcessorFestivalActivity:parse_ACTIVITY2_Activity6120RankingListOk", "sivivsvivivivtvnvi")

end

function ProtocolProcessorFestivalActivity:regAll5()
	--@brief	获取圣诞消费排行榜相关（ACTIVITY2_GetRankingListOk = 106)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetRankingListOk, "ProtocolProcessorFestivalActivity:parse_ACTIVITY2_GetRankingListOk", "iiiiisvivivivsvivivivtvnvnvivivsvivivsis" )
	--@brief	获取圣诞消费排行榜相关（ACTIVITY2_GetRankingList = 105）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetRankingList, "ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList_ErrorProcess", "is" )

end

--新年活动
--也有可能是活动通用协议
function ProtocolProcessorFestivalActivity:regAll6()
	--@brief	返回任务列表（ACTIVITY2_GetTaskListOk = 102）
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetTaskListOk, "ProtocolProcessorFestivalActivity:parse_ACTIVITY2_GetTaskListOk", "iiiviviviviviii")
	--@brief	获取任务奖励（ACTIVITY2_ReceiveTaskRewardOk = 104）
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_ReceiveTaskRewardOk, "ProtocolProcessorFestivalActivity:parse_ACTIVITY2_ReceiveTaskRewardOk", "iiiivivi")
	--@brief	获取排行榜相关（ACTIVITY2_GetRankingListOk = 106）
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetRankingListOk, "ProtocolProcessorFestivalActivity:parse_ACTIVITY2_GetRankingListOk1", "iiiiisvivivivsvivivivtvnvnvivivsvivivsis")
	--@brief	复用的操作协议（ACTIVITY2_ActivityDoOk = 108）
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_ActivityDoOk, "ProtocolProcessorFestivalActivity:parse_ACTIVITY2_ActivityDoOk", "iiiis")
	--@brief	获取圣诞消费排行榜相关（ACTIVITY2_GetRankingList = 105）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetRankingList, "ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList_ErrorProcess", "is" )
	--@brief	通用获取活动历届榜首（ACTIVITY2_GetRankingTopList = 111）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetRankingTopList, "ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingTopList_ErrorProcess", "is")
	--@brief	通用获取活动排行榜（ACTIVITY2_GetRankingTopListOk = 112）
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetRankingTopListOk, "ProtocolProcessorFestivalActivity:parse_ACTIVITY2_GetRankingTopListOk", "iiivivivivsvivivivtvnvnvivivivsvivivsvi")
	--@brief	膜拜（ACTIVITY2_MoBai = 113）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_MoBai, "ProtocolProcessorFestivalActivity:send_ACTIVITY2_MoBai_ErrorProcess", "is")
	--@brief	通用获取活动历届榜首（ACTIVITY2_MoBaiOk = 114）
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_MoBaiOk, "ProtocolProcessorFestivalActivity:parse_ACTIVITY2_MoBaiOk", "iiii")
end
--@brief	获取任务列表（ACTIVITY2_GetTaskList = 101）
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(activityId, taskType, taskGroup)
	WZLog("send_ACTIVITY2_GetTaskList", activityId, taskType, taskGroup)
	local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetTaskList )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( activityId )	-- 活动id
	sender:writeInt( taskType )	-- 任务类型   1日常任务 2 唯一任务 
	sender:writeInt(taskGroup or 0)	-- 任务分组 如果使用分组获取任务的列表，taskType必须传-1 167+
	SendProtocol(sender,false) --true:showLoading
end
--@brief	返回任务列表（ACTIVITY2_GetTaskListOk = 102）
function ProtocolProcessorFestivalActivity:parse_ACTIVITY2_GetTaskListOk(activityId, activityType, taskType, id, status, target, progress, progressCount, refreshTime, taskGroup)
	-- activityId : 活动ID
	-- activityType : 活动类型
	-- taskType : 任务类型
	-- id : 任务ID
	-- status : -1不可领取 0可领取 1已领取
	-- target : 目标数量
	-- progress : 任务进度
	-- progressCount : 进度分割  如果一个任务多个目标值时用 只有一个目标值则填1,1,1,1,1....
	-- refreshTime : 刷新倒计时（秒） 没有刷新的返回0
	-- taskGroup : 对应策划配置的group(1、2、3)
	WZLog("ProtocolProcessorFestivalActivity:parse_ACTIVITY2_GetTaskListOk",
		"\n activityId = ",Serialize(VectorToTable(activityId)),
		"\n activityType = ",Serialize(VectorToTable(activityType)),
		"\n taskType = ",Serialize(VectorToTable(taskType)),
		"\n id = ",Serialize(VectorToTable(id)),
		"\n status = ",Serialize(VectorToTable(status)),
		"\n target = ",Serialize(VectorToTable(target)),
		"\n progress = ",Serialize(VectorToTable(progress)),
		"\n progressCount = ",Serialize(VectorToTable(progressCount)),
		"\n refreshTime = ",Serialize(VectorToTable(refreshTime)),
		"\n taskGroup = ",Serialize(VectorToTable(taskGroup)))
	GlobalGame:getGameEventDispathcer():Dispatch(WndNationalEvent.WndNationalEvent_GetTaskList, activityId, activityType, taskType, 
		VectorToTable(id), VectorToTable(status), VectorToTable(target), VectorToTable(progress), VectorToTable(progressCount), refreshTime, taskGroup)
end
--@brief	获取任务奖励（ACTIVITY2_ReceiveTaskReward = 103）
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_ReceiveTaskReward(activityId, taskId )
	WZLog("send_ACTIVITY2_ReceiveTaskReward", activityId, taskId)
	local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_ReceiveTaskReward )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( tonumber(activityId) )	-- 活动id
	sender:writeInt( taskId )	-- 任务id
	SendProtocol(sender,false) --true:showLoading
end
--@brief	获取任务奖励（ACTIVITY2_ReceiveTaskRewardOk = 104）
function ProtocolProcessorFestivalActivity:parse_ACTIVITY2_ReceiveTaskRewardOk(taskId, result, activityId, activityType, rewardItems, rewardCount)
	-- taskId : 任务id
	-- result : 结果，1=成功，2已经领取了 3任务未完成 4 其他异常
	-- activityId : 活动ID
	-- activityType : 活动类型
	-- rewardItems : 奖励物品Id
	-- rewardCount : 奖励物品数量
	WZLog("ProtocolProcessorFestivalActivity:parse_ACTIVITY2_ReceiveTaskRewardOk", 
		"\n taskId = ",Serialize(taskId), 
		"\n result = ",Serialize(result), 
		"\n activityId = ",Serialize(activityId), 
		"\n activityType = ",Serialize(activityType), 
		"\n rewardItems = ",Serialize(rewardItems), 
		"\n rewardCount = ",Serialize(rewardCount))
	if result == 1 then
		if activityType == 7028 then
			local num,num1 = 0,0
			local ids = VectorToTable(rewardItems)
			local nums = VectorToTable(rewardCount)
			for i=1,#ids do
				if ids[i] == 160145 then
					num = num + nums[i]
				end
			end
			if num ~= 0 then
				WndPelletMain:setPlayerCoin(num)
			end
		end
		WndRewardShow:showById(VectorToTable(rewardItems),VectorToTable(rewardCount))
		GlobalGame:getGameEventDispathcer():Dispatch(WndNationalEvent.WndNationalEvent_GetResult, activityId, taskId, activityType, rewardItems, rewardCount)
	else
		MsgBoxManager:showTipBox(LocalStrings.RETURNEE_TEXT28)
	end
end
--@brief	获取排行榜相关（ACTIVITY2_GetRankingList = 105）
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(activityId, rankingType )
	WZLog("send_ACTIVITY2_GetRankingList", activityId, rankingType)
	local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetRankingList )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( tonumber(activityId) )	-- 活动id
	sender:writeInt( rankingType )	-- 排行榜类型  1~n
	SendProtocol(sender,false) --true:showLoading
end
--@brief	获取排行榜相关（ACTIVITY2_GetRankingListOk = 106）
function ProtocolProcessorFestivalActivity:parse_ACTIVITY2_GetRankingListOk1(activityId, activityType, rankingType, myPoint, myRanking, rewardConfig, playerIds, 
	ranks, points, nickname, headIds, headColors, faceIds, sexs, vipLevel, level, bodyIds, wingIds, title, serverIds, headEffectId, qqInfo, session, settlementDate)
	-- activityId : 活动ID
	-- activityType : 活动类型
	-- rankingType : 排行榜类型
	-- myPoint : 我的积分值
	-- myRanking : 我的排名 从1开始  -1未上榜
	-- rewardConfig : 排行榜奖励配置【["rank:[1,1],reward:[263,1]&[2799,1]","rank:[2,2],reward:[264,1]&[4920,-1]","rank:[3,3],reward:[265,1]&[1312,2]","rank:[4,50],reward:[266,1]&[70,999]"]】
	-- playerIds : 玩家ID
	-- ranks : 排名
	-- points : 积分值
	-- nickname : 玩家昵称
	-- headIds : 玩家头像
	-- headColors : 玩家头像颜色
	-- faceIds : 玩家脸蛋
	-- sexs : 玩家性别
	-- vipLevel : 玩家Vip等级
	-- level : 玩家等级
	-- bodyIds : 身体
	-- wingIds : 翅膀
	-- title : 称号
	-- serverIds : 服务器Id
	-- headEffectId : 头像框
	-- qqInfo : 大厅信息
	-- session : 期数，第几期排行榜
	-- settlementDate : 排行榜结算日期
	WZLog("ProtocolProcessorFestivalActivity:parse_ACTIVITY2_GetRankingListOk1", 
		"\n activityId =",TableToString(VectorToTable(activityId)),
		"\n activityType =",TableToString(VectorToTable(activityType)),
		"\n rankingType =",TableToString(VectorToTable(rankingType)),
		"\n myPoint =",TableToString(VectorToTable(myPoint)),
		"\n myRanking =",TableToString(VectorToTable(myRanking)),
		"\n rewardConfig =",TableToString(VectorToTable(rewardConfig)),
		"\n playerIds =",TableToString(VectorToTable(playerIds)),
		"\n ranks =",TableToString(VectorToTable(ranks)),
		"\n points =",TableToString(VectorToTable(points)),
		"\n nickname =",TableToString(VectorToTable(nickname)),
		"\n headIds =",TableToString(VectorToTable(headIds)),
		"\n headColors =",TableToString(VectorToTable(headColors)),
		"\n faceIds =",TableToString(VectorToTable(faceIds)),
		"\n sexs =",TableToString(VectorToTable(sexs)),
		"\n vipLevel =",TableToString(VectorToTable(vipLevel)),
		"\n level =",TableToString(VectorToTable(level)),
		"\n bodyIds =",TableToString(VectorToTable(bodyIds)),
		"\n wingIds =",TableToString(VectorToTable(wingIds)),
		"\n title =",TableToString(VectorToTable(title)),
		"\n serverIds =",TableToString(VectorToTable(serverIds)),
		"\n headEffectId =",TableToString(VectorToTable(headEffectId)),
		"\n qqInfo =",TableToString(VectorToTable(qqInfo)),
		"\n session =",TableToString(VectorToTable(session)),
		"\n settlementDate =",TableToString(VectorToTable(settlementDate))
)
	GlobalGame:getGameEventDispathcer():Dispatch(WndNationalEvent.WndNationalEvent_GetRankResult,activityId, activityType, rankingType, myPoint, myRanking, 
		rewardConfig, VectorToTable(playerIds), VectorToTable(ranks), VectorToTable(points), VectorToTable(nickname), VectorToTable(headIds), VectorToTable(headColors),
		VectorToTable(faceIds), VectorToTable(sexs), VectorToTable(vipLevel), VectorToTable(level), VectorToTable(bodyIds), VectorToTable(wingIds), VectorToTable(title), 
		VectorToTable(serverIds), session, settlementDate, VectorToTable(headEffectId), VectorToTable(qqInfo))
end
--@brief	复用的操作协议（ACTIVITY2_ActivityDo = 107）
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(activityId, doType, json )
	WZLog("send_ACTIVITY2_ActivityDo", activityId, doType, json)
	local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_ActivityDo )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( tonumber(activityId) )	-- 活动id
	sender:writeInt( doType )	-- 操作类型
	sender:writeString( json )	-- json字符串
	SendProtocol(sender,false) --true:showLoading
end
--@brief	复用的操作协议（ACTIVITY2_ActivityDoOk = 108）
function ProtocolProcessorFestivalActivity:parse_ACTIVITY2_ActivityDoOk(activityId, activityType, doType, result, json)
	-- activityId : 活动id
	-- activityType : 活动类型
	-- doType : 操作类型
	-- json : json字符串
	-- result=1 成功 2商城跨天刷新了 3库存不足 4钻石不足
	WZLog("ProtocolProcessorFestivalActivity:parse_ACTIVITY2_ActivityDoOk", activityId, activityType, doType, result, json)
	if activityType == 7041 or activityType == 7042 then
		-- CellPrivilegesNewbie:getActivityDoOk(activityId, activityType, doType, result, strjson)
		GlobalGame:getGameEventDispathcer():Dispatch(LobbyPrivilegesEvent.LobbyPrivilegesEvent_NewbieReceive, activityId, activityType, doType, result, json)
		return
	elseif activityType == 7043 then
		-- CellPrivilegesGrowth:getActivityDoOk(activityId, activityType, doType, result, strjson)
		GlobalGame:getGameEventDispathcer():Dispatch(LobbyPrivilegesEvent.LobbyPrivilegesEvent_GrowthReceive, activityId, activityType, doType, result, json)
		return
	elseif activityType == 7080 then
		GlobalGame:getGameEventDispathcer():Dispatch(WndNationalEvent.WndNationalEvent_GetProtocal108Result, activityId, activityType, doType, result, json)
		return
	end

	if activityType == 7080 then
		GlobalGame:getGameEventDispathcer():Dispatch(WndNationalEvent.WndNationalEvent_GetProtocal108Result, activityId, activityType, doType, result, json)
		return
	end

	local _result = false
	if activityType == 7029 or activityType == 7058 then
		_result = true
	end
	if result == 0 or result == 1 or result == 2 or result == 3 or result == 4 or _result == true then
		if activityType == g_tGameActivityTypes.ACTIVITY_SHOOT_ARROW then 
			if doType == 6 then 
				GlobalGame:getGameEventDispathcer():Dispatch(ShootArrowEvent.ShootArrowEvent_TeamInfoList, activityId, activityType, doType, result, json)
			elseif doType == 9 or doType == 7 or doType == 8 then 
				GlobalGame:getGameEventDispathcer():Dispatch(ShootArrowEvent.ShootArrowEvent_TeamReward, activityId, activityType, doType, result, json)
			else
				GlobalGame:getGameEventDispathcer():Dispatch(WndNationalEvent.WndNationalEvent_GetProtocal108Result, activityId, doType, result, json)
			end
		else
			GlobalGame:getGameEventDispathcer():Dispatch(WndNationalEvent.WndNationalEvent_GetProtocal108Result, activityId, doType, result, json)
		end
	elseif result == 5 then
		if activityType == g_tGameActivityTypes.ACTIVITY_SHOOT_ARROW then  
			if doType == 4 then 
				MsgBoxManager:showTipBox(LocalStrings.SHOOTARROW_TEXT25)
				GlobalGame:getGameEventDispathcer():Dispatch(WndNationalEvent.WndNationalEvent_GetProtocal108Result, activityId, doType, result, json)
			end
		elseif activityType == 7024 then
			MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT131)
		elseif activityType == 7054 then
			MsgBoxManager:showTipBox(LocalStrings.MONEYTREE_TEXT1[11])
			g_cityExtenInfo.activity7054 = nil 
			WndOwnCity:createMainIcon(false, MONEYTREE_ACTIVITY)
			WndMoneyTree:onClose()
		elseif activityType == 7074 or activityType == 7082 or activityType == 7087 then 
			GlobalGame:getGameEventDispathcer():Dispatch(WndNationalEvent.WndNationalEvent_GetProtocal108Result, activityId, doType, result, json)
		else
			if activityType ~= 7050 then 
				MsgBoxManager:showTipBox(LocalStrings.REFRESH_COUNT..LocalStrings.NOT_ENABLE)
			end
		end
	else
		if activityType == 7074 or activityType == 7082 or activityType == 7087 then 
			GlobalGame:getGameEventDispathcer():Dispatch(WndNationalEvent.WndNationalEvent_GetProtocal108Result, activityId, doType, result, json)
		else
			MsgBoxManager:showTipBox(LocalStrings.NEWYEAR_TEXT9)
		end
	end
end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorFestivalActivity:unregAll()
	self:clearReg()
end

--新年活动
--也有可能是活动通用协议
function ProtocolProcessorFestivalActivity:unregAll6()
	--@brief	返回任务列表（ACTIVITY2_GetTaskListOk = 102）
	self:unregProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetTaskListOk, "ProtocolProcessorFestivalActivity:parse_ACTIVITY2_GetTaskListOk", "iiiviviviviviii")
	--@brief	获取任务奖励（ACTIVITY2_ReceiveTaskRewardOk = 104）
	self:unregProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_ReceiveTaskRewardOk, "ProtocolProcessorFestivalActivity:parse_ACTIVITY2_ReceiveTaskRewardOk", "iiiivivi")
	--@brief	获取排行榜相关（ACTIVITY2_GetRankingListOk = 106）
	self:unregProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetRankingListOk, "ProtocolProcessorFestivalActivity:parse_ACTIVITY2_GetRankingListOk1", "iiiiisvivivivsvivivivtvnvnvivivsvivivsis")
	--@brief	复用的操作协议（ACTIVITY2_ActivityDoOk = 108）
	self:unregProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_ActivityDoOk, "ProtocolProcessorFestivalActivity:parse_ACTIVITY2_ActivityDoOk", "iiiis")
	--@brief	获取圣诞消费排行榜相关（ACTIVITY2_GetRankingList = 105）错误处理(S->C)
	self:unregProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetRankingList, "ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList_ErrorProcess", "is" )
	--@brief	通用获取活动历届榜首（ACTIVITY2_GetRankingTopList = 111）错误处理(S->C)
	self:unregProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetRankingTopList, "ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingTopList_ErrorProcess", "is")
	--@brief	通用获取活动排行榜（ACTIVITY2_GetRankingTopListOk = 112）
	self:unregProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetRankingTopListOk, "ProtocolProcessorFestivalActivity:parse_ACTIVITY2_GetRankingTopListOk", "iiivivivivsvivivivtvnvnvivivivsvivivsvi")
	--@brief	膜拜（ACTIVITY2_MoBai = 113）错误处理(S->C)
	self:unregProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_MoBai, "ProtocolProcessorFestivalActivity:send_ACTIVITY2_MoBai_ErrorProcess", "is")
	--@brief	通用获取活动历届榜首（ACTIVITY2_MoBaiOk = 114）
	self:unregProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_MoBaiOk, "ProtocolProcessorFestivalActivity:parse_ACTIVITY2_MoBaiOk", "iiii")
end
-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief	获取我的答题信息（ACTIVITY2_GetInterestingAnswerInfo = 52）
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetInterestingAnswerInfo( )
	WZLog("send_ACTIVITY2_GetInterestingAnswerInfo")
	local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetInterestingAnswerInfo )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end
--@brief	获取题目（ACTIVITY2_GetInterestingAnswer = 54）
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetInterestingAnswer( )
	WZLog("send_ACTIVITY2_GetInterestingAnswer")
	local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetInterestingAnswer )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end
--@brief	获取答题个人排行榜（ACTIVITY2_GetInterestingAnswerRanking = 56）
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetInterestingAnswerRanking( )
	WZLog("send_ACTIVITY2_GetInterestingAnswerRanking")
	local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetInterestingAnswerRanking )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end
--@brief	获取答题公会排行榜（ACTIVITY2_GetInterestingAnswerGuildRanking = 58）
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetInterestingAnswerGuildRanking( )
	WZLog("send_ACTIVITY2_GetInterestingAnswerGuildRanking")
	local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetInterestingAnswerGuildRanking )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end
--@brief	领取答题奖励（ACTIVITY2_ReceiveInterestingReward = 60）
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_ReceiveInterestingReward(rewardId )
	WZLog("send_ACTIVITY2_ReceiveInterestingReward")
	local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_ReceiveInterestingReward )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( rewardId )	-- 奖励id
	SendProtocol(sender,false) --true:showLoading
end
--@brief	排行榜奖励（ACTIVITY2_GetInterestingReward = 62）
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetInterestingReward(rType )
	WZLog("send_ACTIVITY2_GetInterestingReward")
	local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetInterestingReward )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeByte( rType )	-- 0个人排行榜奖励  1公会排行榜奖励
	SendProtocol(sender,false) --true:showLoading
end
--@brief	答题（ACTIVITY2_InterestingAnswer = 64）
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_InterestingAnswer(select )
	WZLog("send_ACTIVITY2_InterestingAnswer")
	local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_InterestingAnswer )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeByte( select )	-- 1~4 第1到第4个
	SendProtocol(sender,false) --true:showLoading
end
--@brief	获取优惠券信息（ACTIVITY2_GetShoppingCoupon = 67）
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetShoppingCoupon( )
	WZLog("send_ACTIVITY2_GetShoppingCoupon")
	local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetShoppingCoupon )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end
--@brief	添加到购物车（ACTIVITY2_AddToShoppingCar = 69）
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_AddToShoppingCar(doType, refreshDate)
	WZLog("send_ACTIVITY2_AddToShoppingCar", doType, refreshDate)
	local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_AddToShoppingCar )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( doType )	-- 操作类型
	-- int[] goodIds 商品id
	-- int[] nums 商品数量
	-- Stirng refreshDate 商城刷新的日期 避免跨天产生的数据问题
	sender:writeString( refreshDate )	-- 内容
	SendProtocol(sender,false) --true:showLoading
end

--@brief	付款（ACTIVITY2_PayForShoppingCar = 71）
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_PayForShoppingCar(goodIds, nums, refreshDate, price )
	WZLog("send_ACTIVITY2_PayForShoppingCar")
	local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_PayForShoppingCar )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInts( goodIds )	-- 商品id
	sender:writeInts( nums )	-- 商品数量
	sender:writeString( refreshDate )	-- 商城刷新的日期 避免跨天产生的数据问题
	sender:writeInt( price )	-- 最终付款价格 避免跨天客户端物品还没更新
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取排行榜相关（ACTIVITY2_GetShoppingRanking = 73）
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetShoppingRanking( )
	WZLog("send_ACTIVITY2_GetShoppingRanking")
	local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetShoppingRanking )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--以下为藏宝图的协议
--@brief	获取活动详情信息（ACTIVITY2_TreasureActivityInfo = 75）
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_TreasureActivityInfo( )
	local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_TreasureActivityInfo )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end
--@brief	寻宝（ACTIVITY2_Treasure = 77）
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_Treasure(treasureNum )
	WZLog("send_ACTIVITY2_Treasure")
	local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_Treasure )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeByte( treasureNum )	-- 寻宝次数【1 或 10】
	SendProtocol(sender,false) --true:showLoading
end
--@brief	领取奖励（ACTIVITY2_TreasureReceiveReward = 79）
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_TreasureReceiveReward(rewardType, param )
	WZLog("send_ACTIVITY2_TreasureReceiveReward")
	local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_TreasureReceiveReward )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeByte( rewardType )	-- 奖励类型
	sender:writeInt( param )	-- 参数
	SendProtocol(sender,false) --true:showLoading
end
--@brief	获取排行榜相关（ACTIVITY2_TreasureRankingList = 81）
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_TreasureRankingList( )
	WZLog("send_ACTIVITY2_TreasureRankingList")
	local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_TreasureRankingList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end
--============ 每日必购 ==================
--@brief	获取活动详情信息（ACTIVITY2_DailyBuyActivityInfo = 83）
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_DailyBuyActivityInfo( )
	WZLog("send_ACTIVITY2_DailyBuyActivityInfo")
	local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_DailyBuyActivityInfo )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end
--@brief	预购（ACTIVITY2_DailyBuyPreorder = 85）
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_DailyBuyPreorder(giftId, chooseIndex, rechargId)
	WZLog("send_ACTIVITY2_DailyBuyPreorder")
	local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_DailyBuyPreorder )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( giftId )	-- 奖励所属礼包的ID【ID为gift所在数组的下标】
	sender:writeInts( chooseIndex )	-- 选取的道具在对应礼包中的下标【下标从0开始】
	sender:writeInt( rechargId ) --充值id
	SendProtocol(sender,false) --true:showLoading
end
--@brief	领取奖励（ACTIVITY2_DailyBuyReceiveReward = 87）
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_DailyBuyReceiveReward(taskId, chooseIndex )
	WZLog("send_ACTIVITY2_DailyBuyReceiveReward")
	local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_DailyBuyReceiveReward )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( taskId )	-- 奖励所属礼包的ID【ID为gift所在数组的下标】
	sender:writeInts( chooseIndex )	-- 选取的奖励在对应奖励池里的下标【下标从0开始】
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取圣诞消费榜数据（ACTIVITY2_GetRankingList = 105）
function  ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(activityId,tagId)
	WZLog("send_ACTIVITY2_GetRankingList",activityId,tagId)
	local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetRankingList )
	if sender==nil then WZLog("sender == nil") return end
	sender:writeInt(activityId)	--活动ID
	sender:writeInt(tagId)		--第几个:1蓝钻/2粉钻
	SendProtocol(sender,false)	--true:showLoading
end

--@brief	通用获取活动历届榜首（ACTIVITY2_GetRankingTopList = 111）
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingTopList(activityId, rankingType)
	WZLog("send_ACTIVITY2_GetRankingTopList")
	local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetRankingTopList )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(activityId)	-- 活动id
	sender:writeInt(rankingType)	-- 排行榜类型
	SendProtocol(sender,false) --true:showLoading
end

--@brief	膜拜（ACTIVITY2_MoBai = 113）
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_MoBai(activityId, rankingType, playerId)
	WZLog("send_ACTIVITY2_MoBai")
	local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_MoBai )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(activityId)	-- 活动id
	sender:writeInt(rankingType)	-- 排行榜类型
	sender:writeInt(playerId)	-- 玩家ID
	SendProtocol(sender,false) --true:showLoading
end
--=============== 元旦求签 =======================
--@brief	获取活动详情信息（ACTIVITY2_Activity6120Info = 89）
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_Activity6120Info( )
	WZLog("send_ACTIVITY2_Activity6120Info")
	local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_Activity6120Info )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end
--@brief	获取活动详情信息（ACTIVITY2_Activity6120InfoOk = 90）
function ProtocolProcessorFestivalActivity:parse_ACTIVITY2_Activity6120InfoOk(activityId, startTime, endTime, nextDayTime, prayItemNum, joinRewardStatus, isTaskReward)
	-- activityId : 活动ID
	-- startTime : 活动开始时间
	-- endTime : 活动结束时间
	-- prayItemNum : 玩家拥有的求签道具数量
	-- lastTimePray : 玩家最近一次求签时间【用于判断是否有资格领取参与奖励】
	-- lastTimeGetJoinReward : 玩家最近一次领取参与奖励时间【用于判断参与奖励是否已领取】
	-- isTaskReward : 是否有任务奖励可领取【用于任务入口红点】
	GlobalGame:getGameEventDispathcer():Dispatch(WndNationalEvent.WndNationalEvent_NewYearInfo, startTime, endTime, nextDayTime, prayItemNum, joinRewardStatus, isTaskReward)
end
--@brief	获取活动详情信息（ACTIVITY2_Activity6120Do = 91）
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_Activity6120Do( )
	WZLog("send_ACTIVITY2_Activity6120Do")
	local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_Activity6120Do )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end
--@brief	获取活动详情信息（ACTIVITY2_Activity6120DoOk = 92）
function ProtocolProcessorFestivalActivity:parse_ACTIVITY2_Activity6120DoOk(result, itemId, itemNum, prayItemNum, joinRewardStatus, isTaskReward)
	-- result : 求签结果【0=末吉|1=小吉|2=中吉|3=大吉】
	-- itemId : 获得的奖品ID
	-- itemNum : 获得的奖品数量
	-- prayItemNum : 玩家拥有的求签道具数量
	-- joinRewardStatus : 是否领取参与奖励
	-- isTaskReward : 是否有任务奖励可领取【用于任务入口红点】
	WZLog("ProtocolProcessorFestivalActivity:parse_ACTIVITY2_Activity6120DoOk")
	GlobalGame:getGameEventDispathcer():Dispatch(WndNationalEvent.WndNationalEvent_NewYearSignResult, result, VectorToTable(itemId), VectorToTable(itemNum), prayItemNum, joinRewardStatus, isTaskReward)
end
--@brief	获取活动详情信息（ACTIVITY2_Activity6120TaskList = 93）
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_Activity6120TaskList( )
	WZLog("send_ACTIVITY2_Activity6120TaskList")
	local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_Activity6120TaskList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end
--@brief	获取活动详情信息（ACTIVITY2_Activity6120TaskListOk = 94）
function ProtocolProcessorFestivalActivity:parse_ACTIVITY2_Activity6120TaskListOk(id, resetType, status, target, progress, rewardNum, itemId, itemNum)
	-- id : 任务ID
	-- resetType : 任务重置类型【0=不重置，成长任务|1=每日重置，每日任务】
	-- status : 状态【0=不可领取|1=可领取|2=已领取】
	-- target : 任务目标
	-- progress : 任务进度
	-- rewardNum : 奖励个数【此数组的长度与任务数保持一致】
	-- itemId : 奖励物品Id【此数组长度与上面的数组未必一致，需要根据rewardNum去切割各个奖励属于哪个任务】
	-- itemNum : 奖励物品数量【此数组长度与上面的一致，需要根据rewardNum去切割各个奖励属于哪个任务】
	WZLog("ProtocolProcessorFestivalActivity:parse_ACTIVITY2_Activity6120TaskListOk")
	GlobalGame:getGameEventDispathcer():Dispatch(WndNationalEvent.WndNationalEvent_NewYearTaskInfo, VectorToTable(id), VectorToTable(resetType), VectorToTable(status), 
		VectorToTable(target), VectorToTable(progress), VectorToTable(rewardNum), VectorToTable(itemId), VectorToTable(itemNum))
end
--@brief	获取活动详情信息（ACTIVITY2_Activity6120ReceiveReward = 95）
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_Activity6120ReceiveReward( )
	WZLog("send_ACTIVITY2_Activity6120ReceiveReward")
	local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_Activity6120ReceiveReward )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end
--@brief	获取活动详情信息（ACTIVITY2_Activity6120ReceiveRewardOk = 96）
function ProtocolProcessorFestivalActivity:parse_ACTIVITY2_Activity6120ReceiveRewardOk(result, itemId, itemNum)
	-- result : 领取求签一次
	-- itemId : 获得的奖品ID
	-- itemNum : 获得的奖品数量
	GlobalGame:getGameEventDispathcer():Dispatch(WndNationalEvent.WndNationalEvent_NewYearSignGet,result,VectorToTable(itemId), VectorToTable(itemNum))
end
--@brief	获取活动详情信息（ACTIVITY2_Activity6120ReceiveTaskReward = 97）
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_Activity6120ReceiveTaskReward(id )
	WZLog("send_ACTIVITY2_Activity6120ReceiveTaskReward")
	local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_Activity6120ReceiveTaskReward )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( id )	-- 任务id
	SendProtocol(sender,false) --true:showLoading
end
--@brief	获取活动详情信息（ACTIVITY2_Activity6120ReceiveTaskRewardOk = 98）
function ProtocolProcessorFestivalActivity:parse_ACTIVITY2_Activity6120ReceiveTaskRewardOk(result, id, resetType, isTaskReward, itemId, itemNum)
	-- result : 求签结果【0=末吉|1=小吉|2=中吉|3=大吉】
	-- id : 任务id【前端领取时传递上来的id】
	-- resetType: 0 成长  1每日
	-- isTaskReward : 是否有任务奖励可领取【用于任务入口红点】
	WZLog("ProtocolProcessorFestivalActivity:parse_ACTIVITY2_Activity6120ReceiveTaskRewardOk")
	GlobalGame:getGameEventDispathcer():Dispatch(WndNationalEvent.WndNationalEvent_NewYearTaskGet, result, id, resetType, isTaskReward, VectorToTable(itemId), VectorToTable(itemNum))
end
--@brief	获取排行榜相关（ACTIVITY2_Activity6120RankingList = 99）
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_Activity6120RankingList( )
	WZLog("send_ACTIVITY2_Activity6120RankingList")
	local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_Activity6120RankingList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end
--@brief	获取排行榜相关（ACTIVITY2_Activity6120RankingListOk = 100）
function ProtocolProcessorFestivalActivity:parse_ACTIVITY2_Activity6120RankingListOk(rewardConfig, myPoint, playerId, nickname, headId, headColor, faceId, sex, level, point)
	-- rewardConfig : 排行榜奖励配置【["rank:[1,1],reward:[263,1]&[2799,1]","rank:[2,2],reward:[264,1]&[4920,-1]","rank:[3,3],reward:[265,1]&[1312,2]","rank:[4,50],reward:[266,1]&[70,999]"]】
	-- myPoint : 我的积分值
	-- playerId : 玩家ID
	-- nickname : 玩家昵称
	-- headId : 玩家头像
	-- headColor : 玩家头像颜色
	-- faceId : 玩家脸蛋
	-- sex : 玩家性别
	-- level : 玩家等级
	-- point : 积分值
	GlobalGame:getGameEventDispathcer():Dispatch(WndNationalEvent.WndNationalEvent_NewYearRankInfo,rewardConfig, myPoint, VectorToTable(playerId), VectorToTable(nickname), 
		VectorToTable(headId), VectorToTable(headColor), VectorToTable(faceId), VectorToTable(sex), VectorToTable(level), VectorToTable(point))
end

-------------------------------------服务器到客户端协议回调方法模块--------------------------------------
--@brief	获取我的答题信息（ACTIVITY2_GetInterestingAnswerInfoOk = 53）
function ProtocolProcessorFestivalActivity:parse_ACTIVITY2_GetInterestingAnswerInfoOk(result, itemNum, rightNum, totalNum, rewardProcess, rewardStatus)
	-- result : 0未出现答题的情况 1可以答题 2今日的题目已经答完了 3没有答题劵了
	-- itemNum : 剩余答题劵数量
	-- rightNum : 答对题数
	-- totalNum : 总答题数
	-- rewardStatus : 奖励状态
	GlobalGame:getGameEventDispathcer():Dispatch(WndNationalEvent.WndNationalEvent_AnswerInfoData,result,itemNum,rightNum,totalNum,VectorToTable(rewardProcess),VectorToTable(rewardStatus))
end
--@brief	获取题目（ACTIVITY2_GetInterestingAnswerOk = 55）
function ProtocolProcessorFestivalActivity:parse_ACTIVITY2_GetInterestingAnswerOk(result, aIndex, title, answers)
	-- result : 1成功 2今日的题目已经答完了 3没有答题劵了
	-- aIndex ： 刷到第几题
	-- title : 题目
	-- answers : 答案
	GlobalGame:getGameEventDispathcer():Dispatch(WndNationalEvent.WndNationalEvent_StartAnswerResult, result, aIndex, title, VectorToTable(answers))
end
--@brief	获取答题个人排行榜（ACTIVITY2_GetInterestingAnswerRankingOk = 57）
function ProtocolProcessorFestivalActivity:parse_ACTIVITY2_GetInterestingAnswerRankingOk(myRank, myRightNum, myTotalNum, ranks, playerIds, levels, vipLevels, names, faceIds, headIds, headColors, sexs, rightNums, cross)
	-- myRank : 我的排名
	-- myRightNum : 答对题数
	-- myTotalNum : 总题数
	-- ranks : 排名
	-- playerIds : 玩家id
	-- levels : 玩家等级
	-- vipLevels : 玩家vip等级
	-- names : 玩家名称
	-- faceIds : 玩家脸
	-- headIds : 玩家头
	-- headColors : 玩家头颜色
	-- sexs : 玩家性别
	-- rightNums : 玩家答对题数
	GlobalGame:getGameEventDispathcer():Dispatch(WndNationalEvent.WndNationalEvent_GetAnswerRankTotal, myRank, myRightNum, myTotalNum, VectorToTable(ranks), VectorToTable(playerIds), VectorToTable(levels), VectorToTable(vipLevels), 
		VectorToTable(names), VectorToTable(faceIds),  VectorToTable(headIds), VectorToTable(headColors),VectorToTable(sexs), VectorToTable(rightNums), VectorToTable(cross))
end
--@brief	获取答题公会排行榜（ACTIVITY2_GetInterestingAnswerGuildRankingOk = 59）
function ProtocolProcessorFestivalActivity:parse_ACTIVITY2_GetInterestingAnswerGuildRankingOk(myRank, myRightNum, myTotalNum, ranks, guildIds, levels, names, rightNums)
	-- myRank : 我的公会排名
	-- myRightNum : 我的公会答对题数
	-- myTotalNum : 我的公会总题数
	-- ranks : 排名
	-- guildIds : 公会id
	-- levels : 公会等级
	-- names : 公会名称
	-- rightNums : 公会答对题数
	GlobalGame:getGameEventDispathcer():Dispatch(WndNationalEvent.WndNationalEvent_GetAnswerRankGuild, myRank, myRightNum, myTotalNum, VectorToTable(ranks), VectorToTable(guildIds), VectorToTable(levels), VectorToTable(names), VectorToTable(rightNums))
end
--@brief	领取答题奖励（ACTIVITY2_ReceiveInterestingRewardOk = 61）
function ProtocolProcessorFestivalActivity:parse_ACTIVITY2_ReceiveInterestingRewardOk(result, itemIds, itemNums)
	-- result : 1成功 2领取失败
	-- itemIds : 奖励物品id
	-- itemNums : 奖励数量
	if result == 1 then
		WndRewardShow:showById(VectorToTable(itemIds), VectorToTable(itemNums))
	elseif result == 2 then
		MsgBoxManager:showTipBox(LocalStrings.RETURNEE_TEXT28)
	end
end
--@brief	排行榜奖励（ACTIVITY2_GetInterestingRewardOk = 63）
function ProtocolProcessorFestivalActivity:parse_ACTIVITY2_GetInterestingRewardOk(rType, ranks, itemCounts, itemIds, itemNums)
	-- rType : 0个人排行榜奖励  1公会排行榜奖励
	-- ranks : 排名["1","2","3","4-10"...]
	-- itemCounts : 奖励种类
	-- itemIds : 奖励id
	-- itemNums : 奖励数量
	GlobalGame:getGameEventDispathcer():Dispatch(WndNationalEvent.WndNationalEvent_GetAnswerRankReward, rType, VectorToTable(ranks), VectorToTable(itemCounts), VectorToTable(itemIds), VectorToTable(itemNums))
end
--@brief	答题（ACTIVITY2_InterestingAnswerOk = 65）
function ProtocolProcessorFestivalActivity:parse_ACTIVITY2_InterestingAnswerOk(result, tips)
	-- result : 1正确 2错误
	-- tips : 正常或者错误提示
	if result == 1 then 
		MsgBoxManager:showTipBox(LocalStrings.FESTIVAL_TEXT22)
	elseif result == 2 then
		MsgBoxManager:showTipBox(LocalStrings.FESTIVAL_TEXT23)
	end
end
--@brief	任务奖励（ACTIVITY2_GetInterestingAnswerRewardOk = 66）
function ProtocolProcessorFestivalActivity:parse_ACTIVITY2_GetInterestingAnswerRewardOk(rewardIds, rewardTargets, rewartItemCounts, rewardItemIds, rewardItemNums)
	-- rewardTargets : 任务目标(完成XXX题)
	-- rewartItemCounts : 奖励种类
	-- rewardItemIds : 奖励物品id
	-- rewardItemNums : 奖励物品数量
	GlobalGame:getGameEventDispathcer():Dispatch(WndNationalEvent.WndNationalEvent_GetAnswerRewardInfo,VectorToTable(rewardIds),VectorToTable(rewardTargets),VectorToTable(rewartItemCounts),VectorToTable(rewardItemIds),VectorToTable(rewardItemNums))
end
--@brief	获取优惠券信息（ACTIVITY2_GetShoppingCouponOk = 68）
function ProtocolProcessorFestivalActivity:parse_ACTIVITY2_GetShoppingCouponOk(rewardIds, status, process, targets, tips1, tips2, fulls, subs)
	-- rewardIds : 优惠券任务id
	-- status : 任务领取状态 -1不可领取| 0 可领取 | 1已领取 | 2 已使用
	-- process : 任务进度
	-- targets : 任务目标
	-- tips1 : 任务描述1
	-- tips2 : 任务描述2
	-- fulls : 满
	-- subs : 减
	GlobalGame:getGameEventDispathcer():Dispatch(WndPeopleShopEvent.WndPeopleShopEvent_DiscountInfo, VectorToTable(rewardIds), VectorToTable(status), VectorToTable(process), VectorToTable(targets),
		VectorToTable(tips1), VectorToTable(tips2), VectorToTable(fulls), VectorToTable(subs))
end

--@brief	添加到购物车（ACTIVITY2_AddToShoppingCarOk = 70）
function ProtocolProcessorFestivalActivity:parse_ACTIVITY2_AddToShoppingCarOk(dotype, result)
	-- result : 1成功 2失败 3参数错误 4没清空购物车 5刷新上限 6道具不足
	WZLog("ProtocolProcessorFestivalActivity:parse_ACTIVITY2_AddToShoppingCarOk", dotype, result)
	if dotype == 0 then
		if result == 1 then
			-- MsgBoxManager:showTipBox(LocalStrings.PEOPLE_SHOP_TEXT19)
		else
			MsgBoxManager:showTipBox(LocalStrings.PEOPLE_SHOP_TEXT20)
		end
	elseif dotype == 1 then
		if result == 1 then
			MsgBoxManager:showTipBox(LocalStrings.PEOPLE_SHOP_TEXT26)
		elseif result == 4 then
			MsgBoxManager:showTipBox(LocalStrings.PEOPLE_SHOP_TEXT25)
		elseif result == 5 then
			MsgBoxManager:showTipBox(LocalStrings.HEROTOWER_TEXT16)
		elseif result == 6 then
			MsgBoxManager:showTipBox(LocalStrings.SEND_PROPOSAL_LETTER2)
		end
	end
end
--@brief	支付购物车（ACTIVITY2_PayForShoppingCarOk = 72）
function ProtocolProcessorFestivalActivity:parse_ACTIVITY2_PayForShoppingCarOk(result, itemIds, itemNums, coin)
	-- result : 1成功 2失败
	-- itemIds : 奖励id
	-- itemNums : 奖励数量
	WZLog("ProtocolProcessorFestivalActivity:parse_ACTIVITY2_PayForShoppingCarOk")
	GlobalGame:getGameEventDispathcer():Dispatch(WndPeopleShopEvent.WndPeopleShopEvent_PaySuccess, result, VectorToTable(itemIds), VectorToTable(itemNums), coin)
end
--@brief	获取排行榜相关（ACTIVITY2_GetShoppingRankingOk = 74）
function ProtocolProcessorFestivalActivity:parse_ACTIVITY2_GetShoppingRankingOk(myRank, myPoint, rewardRanks, itemCounts, itemIds, itemNums, ranks, playerIds, levels, points, names, faceIds, headIds, headColors, sexs, cross)
	-- myRank : 我的排名
	-- myPoint : 我的积分
	-- rewardRanks : 经理排名 ["1","2","3","4~10","11~20"...]
	-- itemCounts : 奖励物品种类
	-- itemIds : 奖励id
	-- itemNums : 奖励数量
	-- playerIds : 玩家id
	-- levels : 玩家等级
	-- points : 玩家积分
	-- names : 玩家名称
	-- faceIds : 玩家脸
	-- headIds : 玩家头
	-- headColors : 玩家头颜色
	-- sexs : 玩家性别
	GlobalGame:getGameEventDispathcer():Dispatch(WndPeopleShopEvent.WndPeopleShopEvent_Rank, myRank, myPoint, VectorToTable(rewardRanks),VectorToTable(itemCounts),VectorToTable(itemIds),VectorToTable(itemNums),VectorToTable(playerIds),
		VectorToTable(levels),VectorToTable(points),VectorToTable(names),VectorToTable(faceIds),VectorToTable(headIds),VectorToTable(headColors),VectorToTable(sexs),VectorToTable(cross))
end
--*********************以下为藏宝图的协议
--@brief	获取活动详情信息（ACTIVITY2_TreasureActivityInfoOk = 76）
function ProtocolProcessorFestivalActivity:parse_ACTIVITY2_TreasureActivityInfoOk(activityId, startTime, endTime, mapPeriod, unOpenCell, itemIdCell, itemNumCell, itemIdBigReward, itemNumBigReward, dayPoint, pointTaskRewardStatus, joinRewardStatus, finishMapRewardNum)
	-- activityId : 活动ID
	-- startTime : 活动开始时间
	-- endTime : 活动结束时间
	-- mapPeriod : 第几张藏宝图
	-- unOpenCell : 未打开的格子编号[格子编号从0开始]【剩余格子数用此数组的长度计算】
	-- itemIdCell : 全部格子的奖品ID[数组下标 即 格子编号]【格子中的奖励显不显示根据上一个字段判断】
	-- itemNumCell : 全部格子的奖品数量[数组下标 即 格子编号]
	-- itemIdBigReward : 大奖奖品ID
	-- itemNumBigReward : 大奖奖品数量
	-- dayPoint : 我的今日积分
	-- pointTaskRewardStatus : 积分任务奖励状态【0=不可领取 | 1=可领取 | 2=已领取】
	-- joinRewardStatus : 参与奖励状态【0=不可领取 | 1=可领取 | 2=已领取】
	-- finishMapRewardNum : 未领取的“全服进度奖励”份数
	GlobalGame:getGameEventDispathcer():Dispatch(WndTreasureSerachEvent.WndTreasureSerach_InitInfo,activityId, startTime, endTime, mapPeriod, 
		VectorToTable(unOpenCell), VectorToTable(itemIdCell), VectorToTable(itemNumCell), VectorToTable(itemIdBigReward), VectorToTable(itemNumBigReward), 
		dayPoint, VectorToTable(pointTaskRewardStatus), joinRewardStatus, finishMapRewardNum)
end
--@brief	寻宝结果（ACTIVITY2_TreasureOk = 78）
function ProtocolProcessorFestivalActivity:parse_ACTIVITY2_TreasureOk(result, itemId, itemNum, bigRewardItemId, bigRewardItemNum)
	-- result : 寻宝结果【0=成功| 1=失败(剩余格子数量不足以寻宝10次)】
	-- itemId : 寻宝获得的奖品ID
	-- itemNum : 寻宝获得的奖品数量
	WZLog("ProtocolProcessorFestivalActivity:parse_ACTIVITY2_TreasureOk")
	GlobalGame:getGameEventDispathcer():Dispatch(WndTreasureSerachEvent.WndTreasureSerach_GetCommonSerachResult, result, VectorToTable(itemId), 
		VectorToTable(itemNum), VectorToTable(bigRewardItemId), VectorToTable(bigRewardItemNum))
end
--@brief	领取奖励结果（ACTIVITY2_TreasureReceiveRewardOk = 80）
function ProtocolProcessorFestivalActivity:parse_ACTIVITY2_TreasureReceiveRewardOk(result, rewardType, param, itemId, itemNum)
	-- result : 领取奖励结果【0=成功】
	-- itemId : 获得的奖品ID
	-- itemNum : 获得的奖品数量
	WZLog("ProtocolProcessorFestivalActivity:parse_ACTIVITY2_TreasureReceiveRewardOk")
	GlobalGame:getGameEventDispathcer():Dispatch(WndTreasureSerachEvent.WndTreasureSerach_GetRewardResult, result, rewardType, param, VectorToTable(itemId), VectorToTable(itemNum))
end
--@brief	获取排行榜相关（ACTIVITY2_TreasureRankingListOk = 82）
function ProtocolProcessorFestivalActivity:parse_ACTIVITY2_TreasureRankingListOk(rewardConfig, myPoint, playerId, nickname, headId, headColor, faceId, sex, level, point)
	-- rewardConfig : 排行榜奖励配置【["rank:[1,1],reward:[263,1]&[2799,1]","rank:[2,2],reward:[264,1]&[4920,-1]","rank:[3,3],reward:[265,1]&[1312,2]","rank:[4,50],reward:[266,1]&[70,999]"]】
	-- myPoint : 我的积分值
	-- playerId : 玩家ID【每2个组成一对情侣，即数组下标0、1为一对，2、3为一对；下同】
	-- nickname : 玩家昵称
	-- headId : 玩家头像
	-- headColor : 玩家头像颜色
	-- faceId : 玩家脸蛋
	-- sex : 玩家性别
	-- level : 玩家等级
	-- point : 积分值
	GlobalGame:getGameEventDispathcer():Dispatch(WndPeopleShopEvent.WndPeopleShopEvent_TreasureRank,rewardConfig, myPoint, VectorToTable(playerId), VectorToTable(nickname), 
		VectorToTable(headId), VectorToTable(headColor), VectorToTable(faceId), VectorToTable(sex), VectorToTable(level), VectorToTable(point))
end
--@brief 获取圣诞消费排行榜相关（ACTIVITY2_TreasureRankingListOK = 106)
function ProtocolProcessorFestivalActivity:parse_ACTIVITY2_GetRankingListOk(activityId,activityType,rankingType,myPoint,myRank,rewardConfig,playerIds,ranks,points,nickname,headIds,headColors,faceIds,sexs,vipLevels,levels)
	WZLog("ProtocolProcessorFestivalActivity:parse_ACTIVITY2_GetRankingListOk>>>>>>> 获取排行榜相关 >>>>>>>",VectorToTable(playerIds))
	--activityId :活动ID
	--activityType :活动类型
	--rankingType :排行榜类型
	--myPoint :我得积分
	--myRank ：我得排名
	--rewardConfig: 奖励内容
	--playerIds :玩家ID
	--ranks ：玩家排名
	--points: 玩家积分值
	--nickname :名字
	--headIds : 头像id
	--headColors :头像颜色
	--faceIds: 面部id
	--sexs: 性别
	--vipLevels: vip等级
	--levels: 等级
	GlobalGame:getGameEventDispathcer():Dispatch(WndPeopleShopEvent.WndPeopleShopEvent_ChristmasRank,activityId,activityType,rankingType,myPoint,myRank,rewardConfig,VectorToTable(playerIds),VectorToTable(ranks),
		VectorToTable(points),VectorToTable(nickname),VectorToTable(headIds),VectorToTable(headColors),VectorToTable(faceIds),VectorToTable(sexs),VectorToTable(vipLevels),VectorToTable(levels))
	-- CellChristmasConsumptionList:setRankData(activityId,activityType,rankingType,myPoint,myRank,rewardConfig,playerIds,ranks,points,nickname,headIds,headColors,faceIds,sexs,vipLevels,levels)
end
--============= 每日必备 ===================
--@brief	获取活动详情信息（ACTIVITY2_DailyBuyActivityInfoOk = 84）
function ProtocolProcessorFestivalActivity:parse_ACTIVITY2_DailyBuyActivityInfoOk(activityId, startTime, endTime, nextDayTime, rechargeType, rechargeSort, giftItemId, giftItemNum, giftSize, giftDayBuyCount, rewardItemId, rewardItemNum, rewardSize, giftBuyCount, rewardBuyNum, rewardStatus)
	-- activityId : 活动ID
	-- startTime : 活动开始时间
	-- endTime : 活动结束时间
	-- nextDayTime : 服务器所在时区还有多少秒就会发生夸天【用于前端做限购判断】
	-- rechargeType : 每个礼包对应的计费点type
	-- rechargeSort : 每个礼包对应的计费点sort
	-- giftItemId : 全部礼包中的道具ID【每连续N个属于同一个礼包，N见giftSize】
	-- giftItemNum : 全部礼包中的道具数量【每连续N个属于同一个礼包，N见giftSize】
	-- giftSize : 每个礼包的大小，礼包中的道具个数
	-- giftDayBuyCount : 每个礼包今天累计购买次数【用于前端做限购判断】
	-- rewardItemId : 累购奖品ID【每连续N个奖品属于同一个奖励池，N见rewardSize】
	-- rewardItemNum : 累购奖品数量【每连续N个奖品属于同一个奖励池，N见rewardSize】
	-- rewardSize : 累购奖励池大小，每项累购奖励包含多少个奖品
	-- giftBuyCount : 玩家各个礼包的总累购次数
	-- rewardBuyNum : 每项累购多少次才能从中领取奖励
	-- rewardStatus : 每项累购的奖励 0:不可领取 1:可领取 2:已领取
	GlobalGame:getGameEventDispathcer():Dispatch(WndNationalEvent.WndNationalEvent_GetEveryDayInfo,activityId, startTime, endTime, nextDayTime, 
		VectorToTable(rechargeType), VectorToTable(rechargeSort), VectorToTable(giftItemId), VectorToTable(giftItemNum), VectorToTable(giftSize), VectorToTable(giftDayBuyCount), 
		VectorToTable(rewardItemId), VectorToTable(rewardItemNum), VectorToTable(rewardSize), giftBuyCount, VectorToTable(rewardBuyNum), VectorToTable(rewardStatus))
end
--@brief	预购（ACTIVITY2_DailyBuyPreorderOk = 86）
function ProtocolProcessorFestivalActivity:parse_ACTIVITY2_DailyBuyPreorderOk(result, rechargeId)
	-- result : 预购成功【0=成功】
	WZLog("ProtocolProcessorFestivalActivity:parse_ACTIVITY2_DailyBuyPreorderOk")
	GlobalGame:getGameEventDispathcer():Dispatch(WndNationalEvent.WndNationalEvent_GetEveryDayBuyResult, result, rechargeId)
end
--@brief	领取奖励（ACTIVITY2_DailyBuyReceiveRewardOk = 88）
function ProtocolProcessorFestivalActivity:parse_ACTIVITY2_DailyBuyReceiveRewardOk(result, itemId, itemNum, taskId, giftBuyCount, rewardBuyNum, rewardStatus)
	-- result : 领取奖励结果【0=成功】
	-- itemId : 获得的奖品ID
	-- itemNum : 获得的奖品数量
	-- taskId : 领取时传递上来的奖励所属礼包的ID【ID为gift所在数组的下标】
	-- giftBuyCount : 领奖后剩余累购次数
	WZLog("ProtocolProcessorFestivalActivity:parse_ACTIVITY2_DailyBuyReceiveRewardOk")
	GlobalGame:getGameEventDispathcer():Dispatch(WndNationalEvent.WndNationalEvent_GetEveryDayGetReward,result, VectorToTable(itemId), 
		VectorToTable(itemNum), taskId, giftBuyCount, VectorToTable(rewardBuyNum), VectorToTable(rewardStatus))
end

--@brief	通用获取活动排行榜（ACTIVITY2_GetRankingTopListOk = 112）
function ProtocolProcessorFestivalActivity:parse_ACTIVITY2_GetRankingTopListOk(activityId, activityType, rankingType, moBaiPlayerIds, playerIds, points, nicknames, headIds, headColors, faceIds, sexs, vipLevels, levels, bodyIds, bodyColors, windIds, title, serverId, seasonNum, blueVip, worshipNum, sessions)
	-- activityId : 活动id
	-- activityType : 活动类型
	-- rankingType : 排行榜类型
	-- moBaiPlayerIds : 玩家今日膜拜过的玩家ID[数组长度等于玩家今日已消耗掉的膜拜次数]
	-- playerIds : 玩家id
	-- points : 积分
	-- nicknames : 昵称
	-- headIds : 头
	-- headColors : 头颜色
	-- faceIds : 脸
	-- sexs : 性别
	-- vipLevels : vip等级
	-- levels : 等级
	-- bodyIds : 身体
	-- bodyColors : 身体染色
	-- windIds : 翅膀
	-- title : 称号
	-- serverId : 服务器id
	-- seasonNum : 期数，第几期排行榜
	-- blueVip : QQ蓝钻信息
	-- worshipNum : 被膜拜次数
	-- sessions : 活动多次结算排行榜
	WZLog("ProtocolProcessorFestivalActivity:parse_ACTIVITY2_GetRankingTopListOk", 
		"\n activityId =",Serialize(VectorToTable(activityId)), 
		"\n activityType =",Serialize(VectorToTable(activityType)), 
		"\n rankingType =",Serialize(VectorToTable(rankingType)), 
		"\n moBaiPlayerIds =",Serialize(VectorToTable(moBaiPlayerIds)), 
		"\n playerIds =",Serialize(VectorToTable(playerIds)), 
		"\n points =",Serialize(VectorToTable(points)), 
		"\n nicknames =",Serialize(VectorToTable(nicknames)), 
		"\n headIds =",Serialize(VectorToTable(headIds)), 
		"\n headColors =",Serialize(VectorToTable(headColors)), 
		"\n faceIds =",Serialize(VectorToTable(faceIds)), 
		"\n sexs =",Serialize(VectorToTable(sexs)), 
		"\n vipLevels =",Serialize(VectorToTable(vipLevels)), 
		"\n levels =",Serialize(VectorToTable(levels)), 
		"\n bodyIds =",Serialize(VectorToTable(bodyIds)), 
		"\n bodyColors =",Serialize(VectorToTable(bodyColors)), 
		"\n windIds =",Serialize(VectorToTable(windIds)), 
		"\n title =",Serialize(VectorToTable(title)), 
		"\n serverId =",Serialize(VectorToTable(serverId)), 
		"\n seasonNum =",Serialize(VectorToTable(seasonNum)), 
		"\n blueVip =",Serialize(VectorToTable(blueVip)), 
		"\n worshipNum =",Serialize(VectorToTable(worshipNum)),
		"\n sessions =",Serialize(VectorToTable(sessions)))
	GlobalGame:getGameEventDispathcer():Dispatch(WndNationalEvent.WndNationalEvent_GetHistoryRankResult, activityId, activityType, rankingType, VectorToTable(moBaiPlayerIds), VectorToTable(playerIds), VectorToTable(points), VectorToTable(nicknames), VectorToTable(headIds), VectorToTable(headColors), VectorToTable(faceIds), VectorToTable(sexs), VectorToTable(vipLevels), VectorToTable(levels), VectorToTable(bodyIds), VectorToTable(bodyColors), VectorToTable(windIds), VectorToTable(title), VectorToTable(serverId), VectorToTable(seasonNum), VectorToTable(blueVip), VectorToTable(worshipNum))
end

--@brief	通用获取活动历届榜首（ACTIVITY2_MoBaiOk = 114）
function ProtocolProcessorFestivalActivity:parse_ACTIVITY2_MoBaiOk(activityId, rankingType, playerId, mobaiNum)
	-- activityId : 活动id
	-- rankingType : 排行榜类型
	-- playerId : 被膜拜玩家ID
	-- mobaiNum : 被膜拜次数
	WZLog("ProtocolProcessorFestivalActivity:parse_ACTIVITY2_MoBaiOk")
	GlobalGame:getGameEventDispathcer():Dispatch(WndNationalEvent.WndNationalEvent_WorshipHistoryRankResult, activityId, rankingType, playerId, mobaiNum)
end
-------------------------------------协议错误处理方法模块--------------------------------------
--@brief	获取我的答题信息（ACTIVITY2_GetInterestingAnswerInfo = 52）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetInterestingAnswerInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetInterestingAnswerInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetInterestingAnswerInfo, nflag, sMessage)
end
--@brief	获取题目（ACTIVITY2_GetInterestingAnswer = 54）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetInterestingAnswer_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetInterestingAnswer_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetInterestingAnswer, nflag, sMessage)
end
--@brief	获取答题个人排行榜（ACTIVITY2_GetInterestingAnswerRanking = 56）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetInterestingAnswerRanking_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetInterestingAnswerRanking_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetInterestingAnswerRanking, nflag, sMessage)
end
--@brief	获取答题公会排行榜（ACTIVITY2_GetInterestingAnswerGuildRanking = 58）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetInterestingAnswerGuildRanking_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetInterestingAnswerGuildRanking_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetInterestingAnswerGuildRanking, nflag, sMessage)
end
--@brief	领取答题奖励（ACTIVITY2_ReceiveInterestingReward = 60）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_ReceiveInterestingReward_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorFestivalActivity:send_ACTIVITY2_ReceiveInterestingReward_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_ReceiveInterestingReward, nflag, sMessage)
end
--@brief	排行榜奖励（ACTIVITY2_GetInterestingReward = 62）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetInterestingReward_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetInterestingReward_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetInterestingReward, nflag, sMessage)
end
--@brief	答题（ACTIVITY2_InterestingAnswer = 64）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_InterestingAnswer_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorFestivalActivity:send_ACTIVITY2_InterestingAnswer_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_InterestingAnswer, nflag, sMessage)
end
--@brief	获取优惠券信息（ACTIVITY2_GetShoppingCoupon = 67）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetShoppingCoupon_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetShoppingCoupon_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetShoppingCoupon, nflag, sMessage)
end
--@brief	添加到购物车（ACTIVITY2_AddToShoppingCar = 69）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_AddToShoppingCar_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorFestivalActivity:send_ACTIVITY2_AddToShoppingCar_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_AddToShoppingCar, nflag, sMessage)
end
--@brief	付款（ACTIVITY2_PayForShoppingCar = 71）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_PayForShoppingCar_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorFestivalActivity:send_ACTIVITY2_PayForShoppingCar_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_PayForShoppingCar, nflag, sMessage)
end

--@brief	获取排行榜相关（ACTIVITY2_GetShoppingRanking = 73）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetShoppingRanking_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetShoppingRanking_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetShoppingRanking, nflag, sMessage)
end
--@brief	获取活动详情信息（ACTIVITY2_TreasureActivityInfo = 75）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_TreasureActivityInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorFestivalActivity:send_ACTIVITY2_TreasureActivityInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_TreasureActivityInfo, nflag, sMessage)
end
--@brief	寻宝（ACTIVITY2_Treasure = 77）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_Treasure_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorFestivalActivity:send_ACTIVITY2_Treasure_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_Treasure, nflag, sMessage)
end
--@brief	领取奖励（ACTIVITY2_TreasureReceiveReward = 79）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_TreasureReceiveReward_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorFestivalActivity:send_ACTIVITY2_TreasureReceiveReward_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_TreasureReceiveReward, nflag, sMessage)
end
--@brief	获取排行榜相关（ACTIVITY2_TreasureRankingList = 81）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_TreasureRankingList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorFestivalActivity:send_ACTIVITY2_TreasureRankingList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_TreasureRankingList, nflag, sMessage)
end
--@brief	获取活动详情信息（ACTIVITY2_DailyBuyActivityInfo = 83）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_DailyBuyActivityInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorFestivalActivity:send_ACTIVITY2_DailyBuyActivityInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_DailyBuyActivityInfo, nflag, sMessage)
end
--@brief	预购（ACTIVITY2_DailyBuyPreorder = 85）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_DailyBuyPreorder_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorFestivalActivity:send_ACTIVITY2_DailyBuyPreorder_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_DailyBuyPreorder, nflag, sMessage)
end
--@brief	领取奖励（ACTIVITY2_DailyBuyReceiveReward = 87）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_DailyBuyReceiveReward_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorFestivalActivity:send_ACTIVITY2_DailyBuyReceiveReward_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_DailyBuyReceiveReward, nflag, sMessage)
end

--@brief	获取活动详情信息（ACTIVITY2_Activity6120Info = 89）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_Activity6120Info_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorFestivalActivity:send_ACTIVITY2_Activity6120Info_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_Activity6120Info, nflag, sMessage)
end
--@brief	获取圣诞消费榜数据（ACTIVITY2_GetRankingList = 105）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList_ErrorProcess(nFlag, sMessage)
	-- body
	WZLog("ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetRankingList, nflag, sMessage)
end

--@brief	通用获取活动历届榜首（ACTIVITY2_GetRankingTopList = 111）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingTopList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorFestivalActivity:parse_ACTIVITY2_GetRankingTopList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_GetRankingTopList, nflag, sMessage)
end

--@brief	膜拜（ACTIVITY2_MoBai = 113）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorFestivalActivity:send_ACTIVITY2_MoBai_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorFestivalActivity:parse_ACTIVITY2_MoBai_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_MoBai, nflag, sMessage)
end