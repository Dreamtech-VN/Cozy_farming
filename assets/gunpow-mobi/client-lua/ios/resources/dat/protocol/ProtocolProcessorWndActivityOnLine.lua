--ProtocolProcessorWndActivityOnLine.lua
--@brief    线上活动/公告模块协议
--@date     2014/11/27
--@author   weidong_wu


ProtocolProcessorWndActivityOnLine = ProtocolProcessorBase:new()
-------------------------------------公有方法模块--------------------------------------
--@brief    注册协议组所有协议
function ProtocolProcessorWndActivityOnLine:regAll()
    --@brief    获取公告列表等信息错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ANNOUNCEMENT, Protocol.CIRCULAR_ANNOUNCEMENT_GETDETAIL, "ProtocolProcessorWndActivityOnLine:send_CIRCULAR_ANNOUNCEMENT_GETDETAIL_ErrorProcess", "is" )
    --@brief    获取公告列表等信息成功
    self:regProtocolCallbackFunction( Protocol.MAIN_ANNOUNCEMENT, Protocol.CIRCULAR_ANNOUNCEMENT_GETDETAILOK, "ProtocolProcessorWndActivityOnLine:parse_CIRCULAR_ANNOUNCEMENT_GETDETAILOK", "vsvs")
    --@brief    获取活动列表等信息错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetActivityListInfo, "ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityListInfo_ErrorProcess", "is" )
    --@brief    获取活获取活动列表等信息成功
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetActivityListInfoOK, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetActivityListInfoOK", "vivsviviivivivivs")
    --@brief    获取活动详细内容错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetActivityInfo, "ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo_ErrorProcess", "is" )
    --@brief    获取活动详细内容成功
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetActivityInfoOK, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetActivityInfoOK", "isvsiiiviviviviviiivi")
    --@brief    领取奖励操作错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_ReceiveActivityReward, "ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward_ErrorProcess", "is" )
    --@brief    活动排行榜（ACTIVITY_RankList = 7）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_RankList, "ProtocolProcessorWndActivityOnLine:send_ACTIVITY_RankList_ErrorProcess", "is" )

    --@brief    领取奖励成功
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_ReceiveActivityRewardOK, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_ReceiveActivityRewardOK", "vivii")
    --@brief    活动排行榜（ACTIVITY_RankListOk = 8）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_RankListOk, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_RankListOk", "ivivivsvivivtvivtvivsvsvsvsvsvsvsiivivs")
    
    --@brief    获取暑期活动状态（ACTIVITY_GetSummerActivityStatus = 26）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetSummerActivityStatus, "ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetSummerActivityStatus_ErrorProcess", "is" )
    
    --@brief    获取怪物通缉信息（ACTIVITY_GetWantedMonsterInfo = 28）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetWantedMonsterInfo, "ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetWantedMonsterInfo_ErrorProcess", "is" )
    
    --@brief    获取怪物通缉信息（ACTIVITY_GetWantedMonsterInfo = 28）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetWantedMonsterInfoOk, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetWantedMonsterInfoOk", "tvivivtivivivs")
    
    --@brief    领取怪物通缉奖励（ACTIVITY_DrawWantedMonsterReward = 30）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_DrawWantedMonsterReward, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_DrawWantedMonsterReward", "ti")
    
    --@brief    领取怪物通缉奖励（ACTIVITY_DrawWantedMonsterRewardOk = 31）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_DrawWantedMonsterRewardOk, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_DrawWantedMonsterRewardOk", "s")
    --@brief    获取每日折扣信息（ACTIVITY_GetDailyDiscountInfoOk = 37）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetDailyDiscountInfoOk, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetDailyDiscountInfoOk", "vivsvsvivsvivii")
    
    --@brief    领取怪物通缉奖励（ACTIVITY_DrawWantedMonsterReward = 30）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_DrawWantedMonsterReward, "ProtocolProcessorWndActivityOnLine:send_ACTIVITY_DrawWantedMonsterReward_ErrorProcess", "is" )

	--@brief	获取代言人活动状态（ACTIVITY_GetSpokesmanActivityStatus = 32）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetSpokesmanActivityStatus, "ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetSpokesmanActivityStatus_ErrorProcess", "is" )
	
    --@brief    获取每日折扣信息（ACTIVITY_GetDailyDiscountInfo = 36）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetDailyDiscountInfo, "ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetDailyDiscountInfo_ErrorProcess", "is" )

    --@brief    获取钻石抽奖信息（ACTIVITY_GetDiamondLotteryInfo = 38）   错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetDiamondLotteryInfo, "ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetDiamondLotteryInfo_ErrorProcess", "is" )

    --@brief    获取钻石抽奖信息（ACTIVITY_GetDiamondLotteryInfoOk = 39）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetDiamondLotteryInfoOk, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetDiamondLotteryInfoOk", "isvivs")
    
    --@brief    钻石抽奖（ACTIVITY_DiamondLottery = 39）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_DiamondLottery, "ProtocolProcessorWndActivityOnLine:send_ACTIVITY_DiamondLottery_ErrorProcess", "is" )
    
    --@brief    钻石抽奖（ACTIVITY_DiamondLotteryOk = 40）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_DiamondLotteryOk, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_DiamondLotteryOk", "ivivi")

    --@brief     获取战力之王信息（ACTIVITY_GetFightingKingInfo = 34）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetFightingKingInfo, "ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetFightingKingInfo_ErrorProcess", "is" )
    --@brief    获取战力之王信息（ACTIVITY_GetFightingKingInfoOk = 35）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetFightingKingInfoOk, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetFightingKingInfoOk", "ivivivivivivsvivivtvivivivivivivivsvs")

    --@brief    获取排行榜数据（RANK_GetRankRecord = 1）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_RANK, Protocol.RANK_GetRankRecord, "ProtocolProcessorWndActivityOnLine:send_RANK_GetRankRecord_ErrorProcess", "is" )
    --@brief    排行榜信息（RANK_GetRankRecordOK = 2）
    self:regProtocolCallbackFunction( Protocol.MAIN_RANK, Protocol.RANK_GetRankRecordOK, "ProtocolProcessorWndActivityOnLine:parse_RANK_GetRankRecordOK", "tvtvivivsvivivtvivsvsvsvsvsvsvsvtvsvivs")
    --@brief    获取个人排行榜数据（RANK_GetPlayerRank = 3）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_RANK, Protocol.RANK_GetPlayerRank, "ProtocolProcessorWndActivityOnLine:send_RANK_GetPlayerRank_ErrorProcess", "is" )
    --@brief    获取个人排行榜数据（RANK_GetPlayerRankOK = 4）
    self:regProtocolCallbackFunction( Protocol.MAIN_RANK, Protocol.RANK_GetPlayerRankOK, "ProtocolProcessorWndActivityOnLine:parse_RANK_GetPlayerRankOK", "iiittt")

    --@brief     膜拜战力之王（ACTIVITY_WorshipFigthingKing = 42）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_WorshipFigthingKing, "ProtocolProcessorWndActivityOnLine:send_ACTIVITY_WorshipFigthingKing_ErrorProcess", "is" )
    --@brief    膜拜战力之王（ACTIVITY_WorshipFigthingKingOk = 43）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_WorshipFigthingKingOk, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_WorshipFigthingKingOk", "ii")

    --@brief    获取众筹活动信息（ACTIVITY_GetGrowdfunding = 48）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetGrowdfunding, "ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetGrowdfunding_ErrorProcess", "is" )
    --@brief    获取众筹活动信息（ACTIVITY_GetGrowdfundingOk = 49）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetGrowdfundingOk, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetGrowdfundingOk", "vivivivivivtvsvsvsvi")

    --@brief    参与众筹（ACTIVITY_Growdfunding = 50）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_Growdfunding, "ProtocolProcessorWndActivityOnLine:send_ACTIVITY_Growdfunding_ErrorProcess", "is" )
    --@brief    参与众筹（ACTIVITY_GrowdfundingOk = 51）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GrowdfundingOk, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GrowdfundingOk", "vivi")

    --@brief    获奖名单（ACTIVITY_GetGrowdfundingLog = 52）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetGrowdfundingLog, "ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetGrowdfundingLog_ErrorProcess", "is" )
    --@brief    获奖名单（ACTIVITY_GetGrowdfundingLogOk = 53）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetGrowdfundingLogOk, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetGrowdfundingLogOk", "vsvi")
    --@brief    幸运转盘奖励信息（ACTIVITY_GetLuckActivityInfo = 60）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetLuckActivityInfo, "ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetLuckActivityInfo_ErrorProcess", "is" )
    --@brief    幸运转盘奖励信息（ACTIVITY_GetLuckActivityInfoOk = 61）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetLuckActivityInfoOk, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetLuckActivityInfoOk", "ivi")
    --@brief    福利卡活动信息（ACTIVITY_GetWelfareCardActivityInfo = 62）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetWelfareCardActivityInfo, "ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetWelfareCardActivityInfo_ErrorProcess", "is" )
    --@brief    福利卡活动信息（ACTIVITY_GetWelfareCardActivityInfoOk = 63）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetWelfareCardActivityInfoOk, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetWelfareCardActivityInfoOk", "iii")
    --@brief    圣诞礼物活动信息（ACTIVITY_GetChristmasGiftActivityInfo = 64）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetChristmasGiftActivityInfo, "ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetChristmasGiftActivityInfo_ErrorProcess", "is" )
    --@brief    圣诞礼物抽奖（ACTIVITY_ChristmasGiftLottery = 66）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_ChristmasGiftLottery, "ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ChristmasGiftLottery_ErrorProcess", "is" )
    --@brief    圣诞礼物活动整理背包（ACTIVITY_SortChristmasGiftBack = 68）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_SortChristmasGiftBack, "ProtocolProcessorWndActivityOnLine:send_ACTIVITY_SortChristmasGiftBack_ErrorProcess", "is" )
    --@brief    获取抽中的圣诞礼物（ACTIVITY_GetChristmasGift = 70）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetChristmasGift, "ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetChristmasGift_ErrorProcess", "is" )

    --@brief    圣诞礼物活动信息（ACTIVITY_GetChristmasGiftActivityInfoOk = 65）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetChristmasGiftActivityInfoOk, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetChristmasGiftActivityInfoOk", "iiiviviivivsviiiviviivivsvs")
    --@brief    圣诞礼物抽奖（ACTIVITY_ChristmasGiftLotteryOk = 67）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_ChristmasGiftLotteryOk, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_ChristmasGiftLotteryOk", "vivivivsviiiivii")
    --@brief    圣诞礼物活动整理背包（ACTIVITY_SortChristmasGiftBackOk = 69）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_SortChristmasGiftBackOk, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_SortChristmasGiftBackOk", "vivi")
    --@brief    获取抽中的圣诞礼物（ACTIVITY_GetChristmasGiftOk = 71）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetChristmasGiftOk, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetChristmasGiftOk", "")

    --@brief    获取任务活动信息（ACTIVITY_GetActivityTaskList = 72）     错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetActivityTaskList, "ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityTaskList_ErrorProcess", "is" )

    --@brief    获取任务活动信息（ACTIVITY_GetActivityTaskListOk = 73）       
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetActivityTaskListOk, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetActivityTaskListOk", "vivivivii")

    --@brief    获取任务活动信息（ACTIVITY_GetActivityTaskReward = 74）       错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetActivityTaskReward, "ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityTaskReward_ErrorProcess", "is" )

    --@brief    获取任务活动信息（ACTIVITY_GetActivityTaskRewardOk = 75）     
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetActivityTaskRewardOk, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetActivityTaskRewardOk", "i")

    --@brief	获取秒杀中的商品（ACTIVITY_GetActivitiesShopInfo = 77）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetActivitiesShopInfo, "ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivitiesShopInfo_ErrorProcess", "is" )
    --@brief	退出秒杀活动界面（ACTIVITY_OutActivitiesShop = 79）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_OutActivitiesShop, "ProtocolProcessorWndActivityOnLine:send_ACTIVITY_OutActivitiesShop_ErrorProcess", "is" )
    --@brief	购买秒杀活动商品（ACTIVITY_BuyActivitiesShop = 81）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_BuyActivitiesShop, "ProtocolProcessorWndActivityOnLine:send_ACTIVITY_BuyActivitiesShop_ErrorProcess", "is" )


    --@brief	推送秒杀活动是否开启（ACTIVITY_PushActivitiesShopMess = 76）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_PushActivitiesShopMess, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_PushActivitiesShopMess", "iii")
    --@brief	获取秒杀中的商品（ACTIVITY_GetActivitiesShopInfoOk = 78）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetActivitiesShopInfoOk, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetActivitiesShopInfoOk", "issssssiiiisi")
    --@brief	退出秒杀活动界面（ACTIVITY_OutActivitiesShopOk = 80）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_OutActivitiesShopOk, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_OutActivitiesShop", "")
    --@brief	购买秒杀活动商品（ACTIVITY_BuyActivitiesShopOk = 82）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_BuyActivitiesShopOk, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_BuyActivitiesShopOk", "ii")
    --@brief	推送秒杀活动商品数量更新（ACTIVITY_PushActivitiesShop = 83）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_PushActivitiesShop, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_PushActivitiesShop", "ii")
    --@brief    获取开服任务活动信息（ACTIVITY_GetOpenServerTask = 84）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetOpenServerTask, "ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetOpenServerTask_ErrorProcess", "is" )
    --@brief    领取开服任务活动奖励（ACTIVITY_GetOpenServerReward = 86）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetOpenServerReward, "ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetOpenServerReward_ErrorProcess", "is" )
    --@brief    购买开服任务活动商品（ACTIVITY_BuyOpenServerShop = 88）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_BuyOpenServerShop, "ProtocolProcessorWndActivityOnLine:send_ACTIVITY_BuyOpenServerShop_ErrorProcess", "is" )
    --@brief    获取开服任务活动信息（ACTIVITY_GetOpenServerTaskOk = 85）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetOpenServerTaskOk, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetOpenServerTaskOk", "iviviviviivi")
    --@brief    领取开服任务活动奖励（ACTIVITY_GetOpenServerRewardOk = 87）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetOpenServerRewardOk, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetOpenServerRewardOk", "i")
    --@brief    购买开服任务活动商品（ACTIVITY_BuyOpenServerShopOk = 89）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_BuyOpenServerShopOk, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_BuyOpenServerShopOk", "i")
    --@brief    获取点球活动信息（ACTIVITY_ShootBall = 90）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_ShootBall, "ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ShootBall_ErrorProcess", "b" )
    --@brief    获取射门结果信息（ACTIVITY_ShootBallOk = 91）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_ShootBallOk, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_ShootBallOk", "ii")
    --@brief    获取竞猜记录（ACTIVITY_GetBetOnMatchInfo = 101）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetBetOnMatchInfo, "ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetBetOnMatchInfo_ErrorProcess", "is" )
    --@brief   获取竞猜记录（ACTIVITY_GetBetOnMatchInfoOk = 102）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetBetOnMatchInfoOk, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetBetOnMatchInfoOk", "vivivivivivivivi")

    --@brief    获取竞猜列表（ACTIVITY_GetFootballQuizInfoList = 93）       错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetFootballQuizInfoList, "ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetFootballQuizInfoList_ErrorProcess", "" )
    --@brief    获取竞猜列表（ACTIVITY_GetFootballQuizInfoListOk = 94）     
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetFootballQuizInfoListOk, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetFootballQuizInfoListOk", "vivivivivivsvsvsvivivivivivi")
    --@brief    获取点球活动信息（ACTIVITY_ShootBall = 90）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_ShootBall, "ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ShootBall_ErrorProcess", "b" )
    --@brief    获取射门结果信息（ACTIVITY_ShootBallOk = 91）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_ShootBallOk, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_ShootBallOk", "ii")
    --@brief    获取竞猜记录（ACTIVITY_GetBetOnMatchInfo = 101）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetBetOnMatchInfo, "ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetBetOnMatchInfo_ErrorProcess", "is" )
    --@brief   获取竞猜记录（ACTIVITY_GetBetOnMatchInfoOk = 102）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetBetOnMatchInfoOk, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetBetOnMatchInfoOk", "vivivivivivivivi")

    --@brief    获取竞猜列表（ACTIVITY_GetFootballQuizInfoList = 93）       错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetFootballQuizInfoList, "ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetFootballQuizInfoList_ErrorProcess", "" )
    --@brief    获取竞猜列表（ACTIVITY_GetFootballQuizInfoListOk = 94）     
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetFootballQuizInfoListOk, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetFootballQuizInfoListOk", "vivivivivivsvsvsvivivivivivi")

    --@brief    下注（ACTIVITY_BetOnFootballMatch = 97）        错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_BetOnFootballMatch, "ProtocolProcessorWndActivityOnLine:send_ACTIVITY_BetOnFootballMatch_ErrorProcess", "is" )
    --@brief    下注（ACTIVITY_BetOnFootballMatchOk = 98）      
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_BetOnFootballMatchOk, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_BetOnFootballMatchOk", "iiiiii")

    --@brief    获取竞猜商店（ACTIVITY_GetFootballQuizStore = 105） 错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetFootballQuizStore, "ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetFootballQuizStore_ErrorProcess", "is" )
    --@brief    购买竞猜商店商品（ACTIVITY_PurchaseFootballQuizStore = 107）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_PurchaseFootballQuizStore, "ProtocolProcessorWndActivityOnLine:send_ACTIVITY_PurchaseFootballQuizStore_ErrorProcess", "is" )
    --@brief    获取竞猜商店（ACTIVITY_GetFootballQuizStoreOk = 106）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetFootballQuizStoreOk, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetFootballQuizStoreOk", "vivsvsvi")
    --@brief    购买竞猜商店商品（ACTIVITY_PurchaseFootballQuizStoreOK = 108）      
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_PurchaseFootballQuizStoreOK, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_PurchaseFootballQuizStoreOK", "isi")

    --@brief    赠送鲜花（ACTIVITY_GiveFlower = 113）     错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GiveFlower, "ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GiveFlower_ErrorProcess", "iii" )
    --@brief    赠送鲜花（ACTIVITY_GiveFlowerOk = 114）       
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GiveFlowerOk, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GiveFlowerOk", "t")
    --@brief    获取鲜花排行榜活动赠送详情（ACTIVITY_GetFlowerActivityInfo = 117）     错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetFlowerActivityInfo, "ProtocolProcessorBase:send_ACTIVITY_GetFlowerActivityInfo_ErrorProcess", "is" )
    --@brief    获取鲜花排行榜活动赠送详情（ACTIVITY_GetFlowerActivityInfoOk = 118）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetFlowerActivityInfoOk, "ProtocolProcessorBase:parse_ACTIVITY_GetFlowerActivityInfoOk", "vivsvtvivsviviii")
    --@brief    获取纪念任务活动信息（ACTIVITY_GetMarkTaskInfo = 119）     错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetMarkTaskInfo, "ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetMarkTaskInfo_ErrorProcess", "is" )
    --@brief    获取纪念任务活动信息（ACTIVITY_GetMarkTaskInfoOk = 120）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetMarkTaskInfoOk, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetMarkTaskInfoOk", "vivivivivi")
    --@brief   领取纪念奖活动奖励（ACTIVITY_ReceiveMarkTaskReward = 121）     错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_ReceiveMarkTaskReward, "ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveMarkTaskReward_ErrorProcess", "is" )
    --@brief    领取纪念奖活动奖励（ACTIVITY_ReceiveMarkTaskRewardOk = 122）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_ReceiveMarkTaskRewardOk, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_ReceiveMarkTaskRewardOk", "iivivi")
end


--@brief    反注册协议组所有协议
function ProtocolProcessorWndActivityOnLine:unregAll()
    WZLog("ProtocolProcessorWndActivityOnLine:unregAll")
    self:clearReg()
end


-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief    获取公告列表等信息
function ProtocolProcessorWndActivityOnLine:send_CIRCULAR_ANNOUNCEMENT_GETDETAIL( )
    WZLog("send_CIRCULAR_ANNOUNCEMENT_GETDETAIL")
    local sender = Protocol:getSender( Protocol.MAIN_ANNOUNCEMENT, Protocol.CIRCULAR_ANNOUNCEMENT_GETDETAIL )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取活动详细内容
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(activityId ,activityType)
    WZLog("send_ACTIVITY_GetActivityInfo ",activityId ,activityType)
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetActivityInfo )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( activityId )  -- 活动id
    sender:writeInt(activityType)
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取活动列表等信息
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityListInfo()
    WZLog("send_ACTIVITY_GetActivityListInfo")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetActivityListInfo )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end


--@brief    领取奖励操作
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(activityId, rewardId, count)
    WZLog("send_ACTIVITY_ReceiveActivityReward "..activityId.."|"..rewardId)
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_ReceiveActivityReward )
    if sender==nil then WZLog("sender == nil") return end

	if count == nil then count = 1 end 
    sender:writeInt( activityId )  -- 活动id
    sender:writeInt( rewardId ) -- 奖励id(第N个奖励)
	sender:writeInt( count )
    SendProtocol(sender,false) --true:showLoading
end

--@brief    活动排行榜（ACTIVITY_RankList = 7）
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_RankList(rankType )
    WZLog("send_ACTIVITY_RankList")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_RankList )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( rankType ) -- 排行榜类型
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取暑期活动状态（ACTIVITY_GetSummerActivityStatus = 26）
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetSummerActivityStatus()
    WZLog("send_ACTIVITY_GetSummerActivityStatus")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetSummerActivityStatus )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取怪物通缉信息（ACTIVITY_GetWantedMonsterInfo = 28）
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetWantedMonsterInfo()
    WZLog("send_ACTIVITY_GetWantedMonsterInfo")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetWantedMonsterInfo )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    领取怪物通缉奖励（ACTIVITY_DrawWantedMonsterReward = 30）
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_DrawWantedMonsterReward(rewardType, param )
    WZLog("send_ACTIVITY_DrawWantedMonsterReward")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_DrawWantedMonsterReward )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeByte( rewardType )  -- 奖励类型(1:怪物击杀奖励;2:积分奖励)
    sender:writeInt( param )    -- 参数(上述类型为1时:怪物id;2:目标积分值)
    SendProtocol(sender,false) --true:showLoading
end

--@brief	获取代言人活动状态（ACTIVITY_GetSpokesmanActivityStatus = 32）
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetSpokesmanActivityStatus( )
	WZLog("send_ACTIVITY_GetSpokesmanActivityStatus")
	local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetSpokesmanActivityStatus )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief    获取每日折扣信息（ACTIVITY_GetDailyDiscountInfo = 36）
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetDailyDiscountInfo( )
    WZLog("send_ACTIVITY_GetDailyDiscountInfo")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetDailyDiscountInfo )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取钻石抽奖信息（ACTIVITY_GetDiamondLotteryInfo = 38）   
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetDiamondLotteryInfo()
    WZLog("send_ACTIVITY_GetDiamondLotteryInfo")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetDiamondLotteryInfo )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    钻石抽奖（ACTIVITY_DiamondLottery = 39）
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_DiamondLottery()
    WZLog("send_ACTIVITY_DiamondLottery")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_DiamondLottery )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief     获取战力之王信息（ACTIVITY_GetFightingKingInfo = 34）
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetFightingKingInfo(rankType)
    WZLog("send_ACTIVITY_GetFightingKingInfo",rankType)
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetFightingKingInfo )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt(rankType)
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取排行榜数据（RANK_GetRankRecord = 1）
function ProtocolProcessorWndActivityOnLine:send_RANK_GetRankRecord(rankType)
    WZLog("send_RANK_GetRankRecord",rankType)
    local sender = Protocol:getSender( Protocol.MAIN_RANK, Protocol.RANK_GetRankRecord )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeByte(rankType)-- 排行榜类型【1、战力榜，2、等级榜，3、宠物榜，4、坐骑榜， 11、战迹榜，12、胜绩榜，13、成就榜,14、公会榜， 21、魅力榜，22、师德榜，23、恩爱榜】
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取个人排行榜数据（RANK_GetPlayerRank = 3）
function ProtocolProcessorWndActivityOnLine:send_RANK_GetPlayerRank(rankType )
    WZLog("send_RANK_GetPlayerRank")
    local sender = Protocol:getSender( Protocol.MAIN_RANK, Protocol.RANK_GetPlayerRank )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeByte( rankType )    -- 排行榜类型【1、战力榜，2、等级榜，3、宠物榜，4、坐骑榜， 11、战迹榜，12、胜绩榜，13、成就榜,14、公会榜， 21、魅力榜，22、师德榜，23、恩爱榜】
    SendProtocol(sender,false) --true:showLoading
end

--@brief    膜拜战力之王（ACTIVITY_WorshipFigthingKing = 42）
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_WorshipFigthingKing(playerId)
    WZLog("send_ACTIVITY_WorshipFigthingKing",rankType)
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_WorshipFigthingKing )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt(playerId)-- 
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取众筹活动信息（ACTIVITY_GetGrowdfunding = 48）
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetGrowdfunding( )
    WZLog("send_ACTIVITY_GetGrowdfunding")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetGrowdfunding )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    参与众筹（ACTIVITY_Growdfunding = 50）
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_Growdfunding(configId, verifyKey, num )
    WZLog("send_ACTIVITY_Growdfunding")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_Growdfunding )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( configId ) -- 配置表id
    sender:writeInt( verifyKey )    -- 校验key
    sender:writeInt( num )  -- 参与股数
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获奖名单（ACTIVITY_GetGrowdfundingLog = 52）
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetGrowdfundingLog( )
    WZLog("send_ACTIVITY_GetGrowdfundingLog")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetGrowdfundingLog )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    幸运转盘奖励信息（ACTIVITY_GetLuckActivityInfo = 60）
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetLuckActivityInfo()
    WZLog("send_ACTIVITY_GetLuckActivityInfo")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetLuckActivityInfo )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    福利卡活动信息（ACTIVITY_GetWelfareCardActivityInfo = 62）
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetWelfareCardActivityInfo(activityType)
    WZLog("send_ACTIVITY_GetWelfareCardActivityInfo")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetWelfareCardActivityInfo )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( activityType ) -- 活动类型
    SendProtocol(sender,false) --true:showLoading
end

--@brief    圣诞礼物活动信息（ACTIVITY_GetChristmasGiftActivityInfo = 64）
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetChristmasGiftActivityInfo(activityId )
    WZLog("send_ACTIVITY_GetChristmasGiftActivityInfo")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetChristmasGiftActivityInfo )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( activityId )   -- 活动ID
    SendProtocol(sender,false) --true:showLoading
end

--@brief    圣诞礼物抽奖（ACTIVITY_ChristmasGiftLottery = 66）
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ChristmasGiftLottery(lotteryType )
    WZLog("send_ACTIVITY_ChristmasGiftLottery")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_ChristmasGiftLottery )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( lotteryType )  -- 抽奖类型,0:免费抽;1:钻石抽1次 2:钻石十连抽
    SendProtocol(sender,false) --true:showLoading
end

--@brief    圣诞礼物活动整理背包（ACTIVITY_SortChristmasGiftBack = 68）
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_SortChristmasGiftBack( )
    WZLog("send_ACTIVITY_SortChristmasGiftBack")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_SortChristmasGiftBack )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取抽中的圣诞礼物（ACTIVITY_GetChristmasGift = 70）
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetChristmasGift( )
    WZLog("send_ACTIVITY_GetChristmasGift")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetChristmasGift )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取任务活动信息（ACTIVITY_GetActivityTaskList = 72）     
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityTaskList( )
    WZLog("send_ACTIVITY_GetActivityTaskList")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetActivityTaskList )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取任务活动信息（ACTIVITY_GetActivityTaskReward = 74）       
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityTaskReward(id )
    WZLog("send_ACTIVITY_GetActivityTaskReward",id)
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetActivityTaskReward )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( id )   -- 任务Id
    SendProtocol(sender,false) --true:showLoading
end

--@brief	获取秒杀中的商品（ACTIVITY_GetActivitiesShopInfo = 77）
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivitiesShopInfo( )
	WZLog("send_ACTIVITY_GetActivitiesShopInfo")
	local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetActivitiesShopInfo )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	退出秒杀活动界面（ACTIVITY_OutActivitiesShop = 79）
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_OutActivitiesShop( )
	WZLog("send_ACTIVITY_OutActivitiesShop")
	local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_OutActivitiesShop )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	购买秒杀活动商品（ACTIVITY_BuyActivitiesShop = 81）
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_BuyActivitiesShop( )
	WZLog("send_ACTIVITY_BuyActivitiesShop")
	local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_BuyActivitiesShop )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief    获取开服任务活动信息（ACTIVITY_GetOpenServerTask = 84）
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetOpenServerTask( )
    WZLog("send_ACTIVITY_GetOpenServerTask")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetOpenServerTask )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    领取开服任务活动奖励（ACTIVITY_GetOpenServerReward = 86）
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetOpenServerReward(taskId )
    WZLog("send_ACTIVITY_GetOpenServerReward")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetOpenServerReward )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( taskId )   -- 任务Id
    SendProtocol(sender,false) --true:showLoading
end

--@brief    购买开服任务活动商品（ACTIVITY_BuyOpenServerShop = 88）
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_BuyOpenServerShop(shopId )
    WZLog("send_ACTIVITY_BuyOpenServerShop")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_BuyOpenServerShop )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( shopId )   -- 商品Id
    SendProtocol(sender,false) --true:showLoading
end

--@brief    足球射门（ACTIVITY_ShootBall = 90）
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ShootBall(isdoll, goal)
    WZLog("send_ACTIVITY_ShootBall")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_ShootBall )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeBoolean( isdoll )   -- 是否进入框内
    sender:writeInt( goal )   -- 是否进球.1.进球 2.不进球
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取竞猜列表（ACTIVITY_GetFootballQuizInfoList = 93）       
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetFootballQuizInfoList( )
    WZLog("send_ACTIVITY_GetFootballQuizInfoList")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetFootballQuizInfoList )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    下注（ACTIVITY_BetOnFootballMatch = 97）        
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_BetOnFootballMatch(matchId, actionType, num )
    WZLog("send_ACTIVITY_BetOnFootballMatch")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_BetOnFootballMatch )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( matchId )  -- 比赛ID
    sender:writeInt( actionType )   -- 下注哪方.1.主队赢 2.客队赢 3.平局
    sender:writeInt( num )  -- 投注数
    SendProtocol(sender,false) --true:showLoading
end

--@brief    足球射门（ACTIVITY_ShootBall = 90）
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ShootBall(isdoll, goal)
    WZLog("send_ACTIVITY_ShootBall")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_ShootBall )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeBoolean( isdoll )   -- 是否进入框内
    sender:writeInt( goal )   -- 是否进球.1.进球 2.不进球
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取竞猜列表（ACTIVITY_GetFootballQuizInfoList = 93）       
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetFootballQuizInfoList( )
    WZLog("send_ACTIVITY_GetFootballQuizInfoList")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetFootballQuizInfoList )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    下注（ACTIVITY_BetOnFootballMatch = 97）        
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_BetOnFootballMatch(matchId, actionType, num )
    WZLog("send_ACTIVITY_BetOnFootballMatch")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_BetOnFootballMatch )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( matchId )  -- 比赛ID
    sender:writeInt( actionType )   -- 下注哪方.1.主队赢 2.客队赢 3.平局
    sender:writeInt( num )  -- 投注数
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取竞猜记录（ACTIVITY_GetBetOnMatchInfo = 101）   
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetBetOnMatchInfo( )
    WZLog("send_ACTIVITY_GetBetOnMatchInfo")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetBetOnMatchInfo )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取竞猜商店（ACTIVITY_GetFootballQuizStore = 105）  
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetFootballQuizStore( )
    WZLog("send_ACTIVITY_GetFootballQuizStore")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetFootballQuizStore )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    购买竞猜商店商品（ACTIVITY_PurchaseFootballQuizStore = 107）
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_PurchaseFootballQuizStore(id)
    WZLog("send_ACTIVITY_PurchaseFootballQuizStore")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_PurchaseFootballQuizStore )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( id )  -- 商店配置id
    SendProtocol(sender,false) --true:showLoading
end

--@brief    赠送鲜花（ACTIVITY_GiveFlower = 113）     
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GiveFlower(playerId, itemId, num )
    WZLog("send_ACTIVITY_GiveFlower", playerId, itemId, num)
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GiveFlower )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( playerId ) -- 玩家ID
    sender:writeInt( itemId )   -- 物品ID
    sender:writeInt( num )  -- 赠送数量
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取鲜花排行榜活动赠送详情（ACTIVITY_GetFlowerActivityInfo = 117）     
function ProtocolProcessorBase:send_ACTIVITY_GetFlowerActivityInfo( )
    WZLog("send_ACTIVITY_GetFlowerActivityInfo")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetFlowerActivityInfo )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief   获取几年任务活动信息（ACTIVITY_GetMarkTaskInfo = 119）  
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetMarkTaskInfo()
    WZLog("send_ACTIVITY_GetMarkTaskInfo")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetMarkTaskInfo )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    领取纪念奖活动奖励（ACTIVITY_ReceiveMarkTaskReward = 121）     
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveMarkTaskReward(taskId, rewardType)
    WZLog("send_ACTIVITY_ReceiveMarkTaskReward")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_ReceiveMarkTaskReward )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( taskId ) -- 任务id
    sender:writeInt( rewardType )   -- 奖励类型 1： 普通奖励 2 ：纪念奖奖励
    SendProtocol(sender,false) --true:showLoading
end
-------------------------------------协议接收处理方法模块--------------------------------------
--@brief    获取公告列表等信息成功
function ProtocolProcessorWndActivityOnLine:parse_CIRCULAR_ANNOUNCEMENT_GETDETAILOK(title, content)
    -- title : 游戏公告名
    -- content : 游戏公告内容
    WZLog("ProtocolProcessorWndActivityOnLine:parse_CIRCULAR_ANNOUNCEMENT_GETDETAILOK")
    WndAnnouncement:GetAnnouncementOk( VectorToTable(title) ,VectorToTable(content ))
end


--@brief    获取活获取活动列表等信息成功
function ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetActivityListInfoOK(activityId, title, startTime, endTime, serverTime , types, type2, param1, param2)
    -- activityId : 活动id
    -- title : 活动标题
    -- startTime : 生效开始时间
    -- endTime : 生效结束时间
    -- serverTime            : 服务器时间
    -- types : 活动类型
    -- type2 : 0为活动；1位福利
    -- param1 : 用作保存活动消失时间戳
    WZLog("ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetActivityListInfoOK",CellRechargePanelActivity.m_root ~= nil)
    if #VectorToTable(activityId) >0 then
        WZLog("=====================活动不为空")
    else 
        WZLog("=====================活动为空")
    end
    WZLog("parse_ACTIVITY_GetActivityListInfoOK", Serialize(VectorToTable(types)), Serialize(VectorToTable(types2)))
    -- if GlobalGame.g_autoGameActivity then
    --     if #VectorToTable(activityId) >0 then
    --         WZLog("=====================NOT NIL")
    --         if WndGameActivity.m_root == nil then
    --             WndGameActivity:showInterface()
    --         end
    --     else 
    --         WZLog("进主城==============EMPTY")
    --         GlobalGame.g_autoGameActivity = false
    --         ProtocolProcessorWndGameSingIn:regAll()
    --         ProtocolProcessorWndGameSingIn:send_TASK_GetSignStatus()
    --         GlobalGame.g_bIsActivityUIShow = false
    --         return
    --     end
    -- end 
	
	getNewOnlineRewardState1(VectorToTable(activityId), VectorToTable(types))
	
	--首充活动
	if CellRechargePanelActivity.m_root ~= nil then
			WZLog("获取首充信息")
		CellRechargePanelActivity:getInfoOk(VectorToTable(activityId), VectorToTable(title), VectorToTable(startTime), VectorToTable(endTime), serverTime , VectorToTable(types), VectorToTable(type2))
	end
    --空间
    if WndSpaceSendFlower.m_root then 
        WndSpaceSendFlower:GetActivityListInfoOK(VectorToTable(activityId), VectorToTable(title), VectorToTable(startTime), VectorToTable(endTime), serverTime , VectorToTable(types), VectorToTable(type2))
    end
	--活动
    if WndGameActivity.m_root then
        WndGameActivity:GetActivityListInfoOK(VectorToTable(activityId), VectorToTable(title), VectorToTable(startTime), VectorToTable(endTime), serverTime , VectorToTable(types), VectorToTable(type2))
        return
    end

	--新年活动
    if WndNewActivity.m_root then
        WndNewActivity:GetActivityListInfoOK(VectorToTable(activityId), VectorToTable(title), VectorToTable(startTime), VectorToTable(endTime), serverTime , VectorToTable(types), VectorToTable(type2))
        return
    end

	--夏日活动
    if WndSumVacAct.m_root then
        WndSumVacAct:GetActivityListInfoOK(VectorToTable(activityId), VectorToTable(title), VectorToTable(startTime), VectorToTable(endTime), serverTime , VectorToTable(types), VectorToTable(type2))
        return
    end

	--福利
    if WndWelfare.m_root then
        WndWelfare:GetWelfareListInfoOK(VectorToTable(activityId), VectorToTable(title), VectorToTable(startTime), VectorToTable(endTime), serverTime , VectorToTable(types), VectorToTable(type2))
        return
    end

    --代言人活动
    if WndApartmentAct.m_root then
        WndApartmentAct:GetActivityListInfoOK(VectorToTable(activityId), VectorToTable(title), VectorToTable(startTime), VectorToTable(endTime), serverTime , VectorToTable(types), VectorToTable(type2), VectorToTable(param1), VectorToTable(param2))
        return
    end

    -- if WndFootballAct.m_root then
    --     WndFootballAct:GetActivityListInfoOK(VectorToTable(activityId), VectorToTable(title), VectorToTable(startTime), VectorToTable(endTime), serverTime , VectorToTable(types), VectorToTable(type2))
    --     return
    -- end

    if WndFootballActivity.m_root then
        WndFootballActivity:GetActivityListInfoOK(VectorToTable(activityId), VectorToTable(title), VectorToTable(startTime), VectorToTable(endTime), serverTime , VectorToTable(types), VectorToTable(type2))
        return
    end
end

--@brief    获取活动详细内容成功
function ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetActivityInfoOK(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,target)
    -- activityId : 活动id
    -- content               : 活动内容
    -- tips : 提示内容
    -- startTime : 生效开始时间
    -- endTime : 生效结束时间
    -- serverTime            : 服务器时间
    -- rewardId : 奖励ID【多个奖励Id】
    -- status                : 是否已领取奖励【玩家是否已领取该级别奖励(-1不可领取,0可领取，1已领取)】
    -- rewardItems : 奖励物品ID【多个物品id】
    -- rewardItemsParamCount : 该项奖励物品参数的数量【每个物品id对于1个物品数量】
    -- rewardCounts : 每个奖励id对应一个物品数量
    WZLog("ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetActivityInfoOK macCount=",activityId,maxCount)
	getNewOnlineRewardState2( VectorToTable(rewardItems), VectorToTable(rewardCounts), count, VectorToTable(target), VectorToTable(status))

	if CellRechargePanelActivity.m_root ~= nil then
		CellRechargePanelActivity:getDetailInfoOk(activityId, content, VectorToTable(tips) , startTime, endTime, serverTime, VectorToTable(rewardId), VectorToTable(status), VectorToTable(rewardItems), VectorToTable(rewardItemsParamCount), VectorToTable(rewardCounts),count,maxCount,VectorToTable(target))
	end
    if WndGameActivity.m_root then
        WZLog("--Protocol--")
        WndGameActivity:GetActivityInfoOK(activityId, content, VectorToTable(tips) , startTime, endTime, serverTime, VectorToTable(rewardId), VectorToTable(status), VectorToTable(rewardItems), VectorToTable(rewardItemsParamCount), VectorToTable(rewardCounts),count,maxCount,VectorToTable(target))
        return
    end
    if WndWelfare.m_root then
        WndWelfare:GetActivityInfoOK(activityId, content, VectorToTable(tips) , startTime, endTime, serverTime, VectorToTable(rewardId), VectorToTable(status), VectorToTable(rewardItems), VectorToTable(rewardItemsParamCount), VectorToTable(rewardCounts),count,maxCount,VectorToTable(target))
    end
    if WndNewActivity.m_root then
        WZLog("--Protocol--")
        WndNewActivity:GetActivityInfoOK(activityId, content, VectorToTable(tips) , startTime, endTime, serverTime, VectorToTable(rewardId), VectorToTable(status), VectorToTable(rewardItems), VectorToTable(rewardItemsParamCount), VectorToTable(rewardCounts),count,maxCount,VectorToTable(target))
        return
    end
    
    if WndSumVacAct.m_root then
        WndSumVacAct:GetActivityInfoOK(activityId, content, VectorToTable(tips) , startTime, endTime, serverTime, VectorToTable(rewardId), VectorToTable(status), VectorToTable(rewardItems), VectorToTable(rewardItemsParamCount), VectorToTable(rewardCounts),count,maxCount,VectorToTable(target))
        return
    end

	--代言人活动
    if WndApartmentAct.m_root then
        WndApartmentAct:GetActivityInfoOK(activityId, content, VectorToTable(tips) , startTime, endTime, serverTime, VectorToTable(rewardId), VectorToTable(status), VectorToTable(rewardItems), VectorToTable(rewardItemsParamCount), VectorToTable(rewardCounts),count,maxCount,VectorToTable(target))
        return
    end

    if WndFootballActivity.m_root then
        WZLog("--Protocol--11")
        WndFootballActivity:GetActivityInfoOK(activityId, content, VectorToTable(tips) , startTime, endTime, serverTime, VectorToTable(rewardId), VectorToTable(status), VectorToTable(rewardItems), VectorToTable(rewardItemsParamCount), VectorToTable(rewardCounts),count,maxCount,VectorToTable(target))
        return
    end
end

--@brief    领取奖励成功
function ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_ReceiveActivityRewardOK(rewardItems, rewardCount,type)
    -- rewardItems : 物品id
    -- rewardCount : 物品数量
    WZLog("ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_ReceiveActivityRewardOK")
	if CellRechargePanelActivity.m_root ~= nil then
		CellRechargePanelActivity:showRewardBox(0,VectorToTable(rewardItems),VectorToTable(rewardCount))
	end
    if WndGameActivity.m_root ~= nil then
        WndGameActivity:GetRewardOk(VectorToTable(rewardItems),VectorToTable(rewardCount),type)
    end
    if WndWelfare.m_root then
        WndWelfare:GetRewardOk(VectorToTable(rewardItems),VectorToTable(rewardCount),type)
    end
    if WndNewActivity.m_root ~= nil then
        WndNewActivity:GetRewardOk(VectorToTable(rewardItems),VectorToTable(rewardCount),type)
    end

    if WndSumVacAct.m_root ~= nil then
        WndSumVacAct:GetRewardOk(VectorToTable(rewardItems),VectorToTable(rewardCount),type)
    end

	WndApartmentAct:GetRewardOk( VectorToTable(rewardItems), VectorToTable(rewardCount), ntype)
end

--@brief    活动排行榜（ACTIVITY_RankListOk = 8）
function ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_RankListOk(rankType, ranking, playerId, name, faceId, headId, sex, level, vipLevel, winCount, guildName, param1, param2, param3, param5, param6, param7, myRanking, myCount, headColor, param8)
    -- rankType : 排行榜类型
    -- ranking : 名次
    -- playerId : 玩家id
    -- name : 玩家名称
    -- faceId : 玩家1脸
    -- headId : 玩家1头
    -- sex : 性别
    -- level : 等级
    -- vipLevel : vip等级
    -- winCount : 活动期间胜利次数
    -- guildName : 工会名称
    -- param1 : 妻子id
    -- param2 : 妻子名称
    -- param3 : 妻子等级
    -- param5 : 妻子脸
    -- param6 : 妻子头
    -- param7 : 妻子的vip等级
    -- myRanking : 我的排名
    -- myCount : 我的胜场数
    -- headColor : 头颜色索引
    -- param8 : 妻子头颜色索引
    WZLog("ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_RankListOk")
    WndActivityRankList:setRankListData(rankType, ranking, playerId, name, faceId, headId, sex, level, vipLevel, winCount, guildName, param1, param2, param3, param5, param6, param7, myRanking, myCount, headColor, param8)
end

--@brief    获取怪物通缉信息（ACTIVITY_GetWantedMonsterInfo = 28）
function ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetWantedMonsterInfoOk(status, configId, killTimes, rewardStatus, score, targetScore, drawStatus,rewardStr)
    -- status : 状态:1关闭;2开启
    -- configId : 怪物通缉表id
    -- killTimes : 击杀次数
    -- rewardStatus : 怪物击杀奖励领取状态(1未完成;2已完成;3已领取)
    -- score : 总积分
    -- targetScore : 目标积分
    -- drawStatus : 积分奖励领取状态(1未完成;2已完成;3已领取)
    WZLog("ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetWantedMonsterInfoOk")
    if WndSumVacAct.m_root then
        WndSumVacAct:updateMonsterActInfo(VectorToTable(configId),VectorToTable(killTimes),VectorToTable(rewardStatus),score,VectorToTable(targetScore),VectorToTable(drawStatus),VectorToTable(rewardStr))
    end

    if WndSummerReward.m_root then
        WndSummerReward:updateMonsterActInfo(VectorToTable(configId),VectorToTable(killTimes),VectorToTable(rewardStatus),score,VectorToTable(targetScore),VectorToTable(drawStatus),VectorToTable(rewardStr))
    end
end


--@brief    领取怪物通缉奖励（ACTIVITY_DrawWantedMonsterRewardOk = 31）
function ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_DrawWantedMonsterRewardOk(rewzardStr)
    -- rewzardStr : 奖励(为空时表示没有奖励)
    WZLog("ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_DrawWantedMonsterRewardOk")
    if WndSumVacAct.m_root then
        WndSumVacAct:showGetReward(rewzardStr)
    end

    if WndSummerReward.m_root then
        WndSummerReward:showGetReward(rewzardStr)
    end
end

--@brief    获取每日折扣信息（ACTIVITY_GetDailyDiscountInfoOk = 37）
function ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetDailyDiscountInfoOk(configId, originPrice, curPrice, needVip, reward, timesLimit, times, countdown)
    -- body
    -- configId : 标记
    -- originPrice : 原价"[1,200]"
    -- curPrice : 现价
    -- needVip : 需要的vip等级
    -- reward : 物品
    -- timesLimit : 次数限制
    -- times : 已购买的次数
    -- countdown ：当天还剩余多少时间
    WZLog("ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetDailyDiscountInfoOk")

    WndGameActivity:GetActivityInfoOK_newServer(VectorToTable(configId), VectorToTable(originPrice), VectorToTable(curPrice), VectorToTable(needVip), VectorToTable(reward), VectorToTable(timesLimit), VectorToTable(times), countdown)
end

--@brief    获取钻石抽奖信息（ACTIVITY_GetDiamondLotteryInfoOk = 39）
function ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetDiamondLotteryInfoOk(leftTimes,cost, index, reward)
    -- leftTimes : 可抽取次数
    -- cost : 消耗
    -- index : 下标
    -- reward : 奖励
    WZLog("ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetDiamondLotteryInfoOk")
    WndTurnTableLottery:setLotteryInfo(leftTimes,cost,VectorToTable(index),VectorToTable(reward))
end


--@brief    钻石抽奖（ACTIVITY_DiamondLotteryOk = 40）
function ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_DiamondLotteryOk(gridId,itemId, itemNum)
    -- gridId : 选中的格子序号
    -- itemId : 格子里的物品
    -- itemNum : 格子里的物品数量
    WZLog("ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_DiamondLotteryOk")
    WndTurnTableLottery:ReceiveRewardOk(gridId, VectorToTable(itemId), VectorToTable(itemNum))
end

--@brief     获取战力之王信息（ACTIVITY_GetFightingKingInfoOk = 35）
function ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetFightingKingInfoOk(session, playerId, rank, worshipTimes, totlaWorshipTimes, fighting, name, faceId, headId, sex, level, vipLevel, headColor, bodyId, bodyColor, windId, crossServer,rewardRank,reward)
    -- body
    -- session : 届数
    -- worshipTimes : 每日膜拜次数
    -- totlaWorshipTimes : 总膜拜次数
    -- rewardRank: 奖励排名（本服消费活动，跨服消费活动，本服充值活动，跨服充值活动）
    -- reward ：奖励（本服消费活动，跨服消费活动，本服充值活动，跨服充值活动）

    WZLog("ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetFightingKingInfoOk")

    WndGameActivity:GetMonthFightingListOK_newServer(session, VectorToTable(playerId), VectorToTable(rank), VectorToTable(worshipTimes), VectorToTable(totlaWorshipTimes), VectorToTable(fighting), VectorToTable(name), VectorToTable(faceId), VectorToTable(headId), VectorToTable(sex), 
        VectorToTable(level), VectorToTable(vipLevel), VectorToTable(headColor), VectorToTable(bodyId), VectorToTable(bodyColor), VectorToTable(windId), VectorToTable(crossServer), VectorToTable(rewardRank), VectorToTable(reward))
end

--@brief    排行榜信息（RANK_GetRankRecordOK = 2）
function ProtocolProcessorWndActivityOnLine:parse_RANK_GetRankRecordOK(rankType, trendRank, ranking, playerId, name, faceId, headId, sex, level, param1, param2, param3, param4, param5, param6, param7, vipLevel, param8, headColor, param9)
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
    WZLog("ProtocolProcessorWndActivityOnLine:parse_RANK_GetRankRecordOK",rankType)
    if WndMonthFighting.m_root then 
        WndMonthFighting:setRankListData(ranking, playerId, name, faceId, headId, sex, level, param1, param2, param3, param4, param5, param6, param7, rankType, trendRank, vipLevel, param8, headColor, param9)
    end
end

--@brief    获取个人排行榜数据（RANK_GetPlayerRankOK = 4）
function ProtocolProcessorWndActivityOnLine:parse_RANK_GetPlayerRankOK(myRank, rankValue, rankExp, myTrendRank, rankType, canWorship)
    -- myRank : 我的排名（没有排名，-1，没有排名）
    -- rankValue : 排名值
    -- rankExp : 第二排名值
    -- myTrendRank : 趋势0、不变，1、上升，2、下降
    -- rankType : 排行榜类型
    -- canWorship : 是否可膜拜1、可膜拜，0、不可膜拜
    WZLog("ProtocolProcessorWndActivityOnLine:parse_RANK_GetPlayerRankOK",rankType,myRank,rankValue)
    if WndMonthFighting.m_root then 
        WndMonthFighting:setMyRankData(myRank)
    end
end

--@brief     膜拜战力之王（ACTIVITY_WorshipFigthingKingOk = 43）
function ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_WorshipFigthingKingOk(vigor, result)
    -- body
    -- vigor : 增加活力
    -- result : 膜拜结果（1:成功,2:失败）

    WZLog("ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_WorshipFigthingKingOk")
    CellFightingRankItem:receiveWorshipOK(vigor, result)
end

--@brief    获取众筹活动信息（ACTIVITY_GetGrowdfundingOk = 49）
function ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetGrowdfundingOk(configId, verifyKey, target, current, join, joinType, costItem, joinGain, randomGain, defaultNum)
    -- configId : 配置表id
    -- verifyKey : 校验key
    -- target : 目标股数
    -- current : 当前股数
    -- join : 已购买股数
    -- joinType : 0:只能入股一次;1:无限制
    -- costItem : 消耗
    -- joinGain : 参与奖
    -- randomGain : 随机大奖
    -- defaultNum : 缺省股数
    WZLog("ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetGrowdfundingOk")

    WndGameActivity:GetManyCollectDataOK(VectorToTable(configId), VectorToTable(verifyKey), VectorToTable(target), VectorToTable(current), VectorToTable(join), VectorToTable(joinType), VectorToTable(costItem), VectorToTable(joinGain), VectorToTable(randomGain), VectorToTable(defaultNum))
end

--@brief    参与众筹（ACTIVITY_GrowdfundingOk = 51）
function ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GrowdfundingOk(itemId, num)
    -- itemId : 参与奖id
    -- num : 奖励数目
    WZLog("ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GrowdfundingOk")
    WndGameActivity:GetRewardOk(VectorToTable(itemId), VectorToTable(num), g_tGameActivityTypes.ACTIVITY_MANY_COLLECT)
end

--@brief    获奖名单（ACTIVITY_GetGrowdfundingLogOk = 53）
function ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetGrowdfundingLogOk(playerName, timestamp)
    -- playerName : 玩家名字
    -- timestamp : 获奖时间
    WZLog("ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetGrowdfundingLogOk")

    WndCollectRewardList:setLogData(VectorToTable(playerName), VectorToTable(timestamp))
end

--@brief    幸运转盘奖励信息（ACTIVITY_GetLuckActivityInfoOk = 61）
function ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetLuckActivityInfoOk(luckNum, rewardSet)
    -- luckNum : 累计的幸运点数
    -- rewardSet : 已获取奖励
    WZLog("ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetLuckActivityInfoOk")

    CellLoveLotteryBox:setData(luckNum, VectorToTable(rewardSet))
end

--@brief    福利卡活动信息（ACTIVITY_GetWelfareCardActivityInfoOk = 63）
function ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetWelfareCardActivityInfoOk(progress, num, endTime)
    -- progress : 活动是否在进行. 0-进行中 1-已结束
    -- num : 购买次数
    -- endTime : 活动结束时间. 秒.
    WZLog("ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetWelfareCardActivityInfoOk")
    if WndFreeca.m_root then 
        WndFreeca:GetCardActivityInfoOK(progress, num, endTime)
    end
end

--@brief    圣诞礼物活动信息（ACTIVITY_GetChristmasGiftActivityInfoOk = 65）
function ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetChristmasGiftActivityInfoOk(activityId, startTime, endTime, rewardItems, rewardCounts, serverIntegration, rank, rankPlayerName, rankIntegration, myRank, myIntegration, itemId, itemNum, freeCount, rankPlayerId, rankParam, rankReward)
    -- activityId : 活动ID
    -- startTime : 开始时间（秒）
    -- endTime : 结束时间（秒）
    -- rewardItems : 圣诞礼物ID
    -- rewardCounts : 圣诞礼物数量
    -- serverIntegration : 本服总积分
    -- rank : 积分排行榜-排名
    -- rankPlayerName : 积分排行榜-玩家名称
    -- rankIntegration : 积分排行榜-玩家积分
    -- myRank : 积分排行榜-我的排名
    -- myIntegration : 玩家积分
    -- itemId : 玩家抽奖已获得物品ID
    -- itemNum : 玩家抽奖已获得物品对应数量
    -- freeCount : 玩家拥有的免费抽奖次数
    -- rankPlayerId : 榜单玩家id
    -- rankParam : 排名
    -- rankReward : 排名奖励
    WZLog("ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetChristmasGiftActivityInfoOk")

    WndApartmentAct:getChristmasTreeDataOK(activityId, startTime, endTime, VectorToTable(rewardItems), VectorToTable(rewardCounts), serverIntegration, VectorToTable(rank), VectorToTable(rankPlayerName), VectorToTable(rankIntegration), myRank, myIntegration, VectorToTable(itemId), VectorToTable(itemNum), freeCount, VectorToTable(rankPlayerId), VectorToTable(rankParam), VectorToTable(rankReward))
end

--@brief    圣诞礼物抽奖（ACTIVITY_ChristmasGiftLotteryOk = 67）
function ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_ChristmasGiftLotteryOk(itemId, itemNum, rank, rankPlayerName, rankIntegration, myRank, myIntegration, serverIntegration, rankPlayerId, freeCount)
    -- itemId : 抽中的圣诞礼物
    -- itemNum : 抽中的圣诞礼物数量
    -- rank : 积分排行榜-排名
    -- rankPlayerName : 积分排行榜-玩家名称
    -- rankIntegration : 积分排行榜-玩家积分
    -- myRank : 积分排行榜-我的排名
    -- myIntegration : 玩家积分
    -- serverIntegration : 本服玩家总积分
    -- rankPlayerId : 榜单玩家id
    -- freeCount : 玩家拥有的免费抽奖次数
    WZLog("ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_ChristmasGiftLotteryOk")

    WndChristmasTree:lotteryOK(VectorToTable(itemId), VectorToTable(itemNum), VectorToTable(rank), VectorToTable(rankPlayerName), VectorToTable(rankIntegration), myRank, myIntegration, serverIntegration, VectorToTable(rankPlayerId), freeCount)
end

--@brief    圣诞礼物活动整理背包（ACTIVITY_SortChristmasGiftBackOk = 69）
function ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_SortChristmasGiftBackOk(itemId, itemNum)
    -- itemId : 抽中的圣诞礼物
    -- itemNum : 抽中的圣诞礼物数量
    WZLog("ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_SortChristmasGiftBackOk")

    WndChristmasTreeBag:operateOK(VectorToTable(itemId), VectorToTable(itemNum), 1)
end

--@brief    获取抽中的圣诞礼物（ACTIVITY_GetChristmasGiftOk = 71）
function ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetChristmasGiftOk()
    -- itemId : 抽中的圣诞礼物
    -- itemNum : 抽中的圣诞礼物数量
    WZLog("ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetChristmasGiftOk")

    WndChristmasTreeBag:operateOK({}, {}, 2)
end

--@brief    获取任务活动信息（ACTIVITY_GetActivityTaskListOk = 73）       
function ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetActivityTaskListOk(id, status, target, complete, refreshTime)
    -- id : 任务Id
    -- status : 状态0新增,1完成未领取,2完成
    -- target : 目标数量
    -- complete : 完成数量
    -- refreshTime : 刷新倒计时（秒）
    WZLog("ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetActivityTaskListOk")
    WndThematicTasks:getActivityTaskListOk(VectorToTable(id),VectorToTable(status),VectorToTable(target),VectorToTable(complete),refreshTime)
end

--@brief    获取任务活动信息（ACTIVITY_GetActivityTaskRewardOk = 75）     
function ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetActivityTaskRewardOk(status)
    -- status : 状态0失败,1成功
    WZLog("ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetActivityTaskRewardOk",status)
    CellThematicTasks:getActivityTaskRewardOk(status)
end

--@brief	推送秒杀活动是否开启（ACTIVITY_PushActivitiesShopMess = 76）
function ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_PushActivitiesShopMess(status, endTime, startTime)
	-- status : 是否开启（1为开启，0为没开启）
	-- limitTime : 该活动最后结束时间倒计时（秒）
	WZLog("ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_PushActivitiesShopMess", status, endTime, startTime, SystemTime:getServerTime())
	WndApartmentAct.showSeckill = status
	WndApartmentAct.seckillStartTime = startTime
	WndApartmentAct.seckillEndTime = endTime
	WndApartmentAct.receiveSeckill = SystemTime:getServerTime()
	WZLog("收到时间", WndApartmentAct.receiveSeckill)
end

--@brief	获取秒杀中的商品（ACTIVITY_GetActivitiesShopInfoOk = 78）
function ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetActivitiesShopInfoOk(id, item, price, normalPrice, killPrice, startTime, endTime, killStartTime, killEndTime, limitNum, buyNum, timeStr, maxNum)
	-- id : 商品Id
	-- item : 商品
	-- price : 正常价格
	-- normalPrice : 销售价格
	-- killPrice : 秒杀价格
	-- startTime : 开始时间
	-- endTime : 结束时间
	-- killStartTime : 当天秒杀开始倒计时（-1为在已经开始秒杀）
	-- killEndTime : 当天秒杀结束倒计时（-1为在已经结束秒杀）
	-- limitNum : 还剩余数量
	-- buyNum : 还能购买数量
	WZLog("ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetActivitiesShopInfoOk", killStartTime, killEndTime, timeStr, maxNum)
	WndSeckill:setData(id, item, price, normalPrice, killPrice, startTime, endTime, killStartTime, killEndTime, limitNum, buyNum, timeStr, maxNum)
end

--@brief	退出秒杀活动界面（ACTIVITY_OutActivitiesShopOk = 80）
function ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_OutActivitiesShop()
	WZLog("ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_OutActivitiesShop")
end

--@brief	购买秒杀活动商品（ACTIVITY_BuyActivitiesShopOk = 82）
function ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_BuyActivitiesShopOk(limitNum, buyNum)
	-- limitNum : 还剩余数量
	-- buyNum : 还能购买数量
	WZLog("ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_BuyActivitiesShopOk")
	WndSeckill:updateNum1(limitNum, buyNum)
end

--@brief	推送秒杀活动商品数量更新（ACTIVITY_PushActivitiesShop = 83）
function ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_PushActivitiesShop(id, limitNum)
	-- id : 商品Id
	-- limitNum : 还剩余数量
	WZLog("ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_PushActivitiesShop")
	WndSeckill:updateNum2(id, limitNum)
end

--@brief    获取开服任务活动信息（ACTIVITY_GetOpenServerTaskOk = 85）
function ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetOpenServerTaskOk(open, id, status, target, complete, time, buyShop)
    -- open : 开服任务活动是否存在（1为存在，0为不存在，0时下面所有数据无效）
    -- id : 任务Id
    -- status : 状态0新增,1完成未领取,2完成
    -- target : 目标数量
    -- complete : 完成数量
    -- time : 创建账号当天的凌晨时间戳
    -- buyShop : 已购买的限购物品
    WZLog("ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetOpenServerTaskOk", open, time)
    if WndSevenDayActivity.m_root then 
        WndSevenDayActivity:setData(open, VectorToTable(id), VectorToTable(status), VectorToTable(target), VectorToTable(complete), time, VectorToTable(buyShop))
    end

    GlobalGame.g_isServerTaskOpen = open == 1
    GlobalGame.g_serverTaskTime = time
end

--@brief    领取开服任务活动奖励（ACTIVITY_GetOpenServerRewardOk = 87）
function ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetOpenServerRewardOk(taskId)
    -- taskId : 任务Id
    WZLog("ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetOpenServerRewardOk")

    WndSevenDayActivity:receiveRewardOK(taskId)
end

--@brief    购买开服任务活动商品（ACTIVITY_BuyOpenServerShopOk = 89）
function ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_BuyOpenServerShopOk(shopId)
    -- shopId : 商品Id
    WZLog("ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_BuyOpenServerShopOk")

    WndSevenDayActivity:buyLimiteGoodsOK(shopId)
end

--@brief    购买开服任务活动商品（ACTIVITY_ShootBallOk = 91）
function ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_ShootBallOk(status, goal)
    -- status : 是否进球    1：进球    2：不进球
    WZLog("ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_ShootBallOk")

    CellFootballGame:getResult(status, goal)
end

--@brief    获取竞猜列表（ACTIVITY_GetFootballQuizInfoListOk = 94）     
function ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetFootballQuizInfoListOk(matchId, homeTeam, homeTeamScore, visitTeam, visitTeamScore, win, lose, draw, matchStartLeaveTime, disappearLeaveTime, status, winNum, loseNum, drawNum)
    -- matchId : 比赛ID
    -- homeTeam : 主队
    -- homeTeamScore : 主队得分
    -- visitTeam : 客队
    -- visitTeamScore : 客队得分
    -- win : 主队赢的赔率
    -- lose : 客队赢的赔率
    -- draw : 平局的赔率
    -- matchStartLeaveTime : 比赛开始剩余时间
    -- disappearLeaveTime : 比赛不显示的时间
    -- status : 比赛状态. 0:进行中 1:等待开奖 2:已经开奖
    -- winNum : 主队赢投注数
    -- loseNum : 客队赢投注数
    -- drawNum : 平局投注数
    WZLog("ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetFootballQuizInfoListOk",Serialize(VectorToTable(matchId)),Serialize(VectorToTable(homeTeam)),Serialize(VectorToTable(homeTeamScore)),Serialize(VectorToTable(visitTeam)),Serialize(VectorToTable(visitTeamScore)),Serialize(VectorToTable(win)),Serialize(VectorToTable(lose)),Serialize(VectorToTable(draw)),Serialize(VectorToTable(matchStartLeaveTime)),Serialize(VectorToTable(disappearLeaveTime)),Serialize(VectorToTable(status)),Serialize(VectorToTable(winNum)),Serialize(VectorToTable(loseNum)),Serialize(VectorToTable(drawNum)))
    WndFootballAct:getQuizInfoListOk(VectorToTable(matchId),VectorToTable(homeTeam),VectorToTable(homeTeamScore),VectorToTable(visitTeam),VectorToTable(visitTeamScore),VectorToTable(win),VectorToTable(lose),VectorToTable(draw),VectorToTable(matchStartLeaveTime),VectorToTable(disappearLeaveTime),VectorToTable(status),VectorToTable(winNum),VectorToTable(loseNum),VectorToTable(drawNum))
end


--@brief    下注（ACTIVITY_BetOnFootballMatchOk = 98）      
function ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_BetOnFootballMatchOk(matchId, actionType, num, winNum, loseNum, drawNum)
    -- matchId : 比赛ID
    -- actionType : 下注哪方.1.主队赢 2.客队赢 3.平局
    -- num : 投注数
    -- winNum : 主队赢投注数
    -- loseNum : 客队赢投注数
    -- drawNum : 平局投注数
    WZLog("ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_BetOnFootballMatchOk",matchId, actionType, num, winNum, loseNum, drawNum)
    WndFootballAct:getBetOnFootballMatchOk(matchId, actionType, num, winNum, loseNum, drawNum)
end

--@brief    获取竞猜记录（ACTIVITY_GetBetOnMatchInfoOk = 102）
function ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetBetOnMatchInfoOk(matchId, status, homeTeam, visitTeam, winNum, loseNum, drawNum, gainNum)
    -- matchId : 比赛ID
    -- status : 比赛状态. 0:进行中 1:已结束 2:已开奖
    -- homeTeam : 主队ID
    -- visitTeam : 客队ID
    -- winNum : 主队赢投注数
    -- loseNum : 客队赢投注数
    -- drawNum : 平局投注数
    -- gainNum : 下注赢得数量
    WZLog("ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetBetOnMatchInfoOk")
    WndFootballGuessList:handleResultInfo(VectorToTable(matchId), VectorToTable(status), VectorToTable(homeTeam), VectorToTable(visitTeam), VectorToTable(winNum), VectorToTable(loseNum), VectorToTable(drawNum), VectorToTable(gainNum))
end

--@brief    获取竞猜商店（ACTIVITY_GetFootballQuizStoreOk = 106）
function ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetFootballQuizStoreOk(id, item, cost, leftTimes)
    -- id : 商品Id
    -- item : 物品id,数量
    -- cost : 消耗
    -- leftTimes : 剩余购买次数
    WZLog("ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetFootballQuizStoreOk")
    WndFootballGuessList:handleShopInfo(VectorToTable(id), VectorToTable(item), VectorToTable(cost), VectorToTable(leftTimes))
end

--@brief    购买开服任务活动商品（ACTIVITY_ShootBallOk = 91）
function ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_ShootBallOk(status, goal)
    -- status : 是否进球    1：进球    2：不进球
    WZLog("ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_ShootBallOk")

    CellFootballGame:getResult(status, goal)
end

--@brief    获取竞猜列表（ACTIVITY_GetFootballQuizInfoListOk = 94）     
function ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetFootballQuizInfoListOk(matchId, homeTeam, homeTeamScore, visitTeam, visitTeamScore, win, lose, draw, matchStartLeaveTime, disappearLeaveTime, status, winNum, loseNum, drawNum)
    -- matchId : 比赛ID
    -- homeTeam : 主队
    -- homeTeamScore : 主队得分
    -- visitTeam : 客队
    -- visitTeamScore : 客队得分
    -- win : 主队赢的赔率
    -- lose : 客队赢的赔率
    -- draw : 平局的赔率
    -- matchStartLeaveTime : 比赛开始剩余时间
    -- disappearLeaveTime : 比赛不显示的时间
    -- status : 比赛状态. 0:进行中 1:等待开奖 2:已经开奖
    -- winNum : 主队赢投注数
    -- loseNum : 客队赢投注数
    -- drawNum : 平局投注数
    WZLog("ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetFootballQuizInfoListOk",Serialize(VectorToTable(matchId)),Serialize(VectorToTable(homeTeam)),Serialize(VectorToTable(homeTeamScore)),Serialize(VectorToTable(visitTeam)),Serialize(VectorToTable(visitTeamScore)),Serialize(VectorToTable(win)),Serialize(VectorToTable(lose)),Serialize(VectorToTable(draw)),Serialize(VectorToTable(matchStartLeaveTime)),Serialize(VectorToTable(disappearLeaveTime)),Serialize(VectorToTable(status)),Serialize(VectorToTable(winNum)),Serialize(VectorToTable(loseNum)),Serialize(VectorToTable(drawNum)))
    WndFootballAct:getQuizInfoListOk(VectorToTable(matchId),VectorToTable(homeTeam),VectorToTable(homeTeamScore),VectorToTable(visitTeam),VectorToTable(visitTeamScore),VectorToTable(win),VectorToTable(lose),VectorToTable(draw),VectorToTable(matchStartLeaveTime),VectorToTable(disappearLeaveTime),VectorToTable(status),VectorToTable(winNum),VectorToTable(loseNum),VectorToTable(drawNum))
end


--@brief    下注（ACTIVITY_BetOnFootballMatchOk = 98）      
function ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_BetOnFootballMatchOk(matchId, actionType, num, winNum, loseNum, drawNum)
    -- matchId : 比赛ID
    -- actionType : 下注哪方.1.主队赢 2.客队赢 3.平局
    -- num : 投注数
    -- winNum : 主队赢投注数
    -- loseNum : 客队赢投注数
    -- drawNum : 平局投注数
    WZLog("ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_BetOnFootballMatchOk",matchId, actionType, num, winNum, loseNum, drawNum)
    WndFootballAct:getBetOnFootballMatchOk(matchId, actionType, num, winNum, loseNum, drawNum)
end

--@brief    获取竞猜记录（ACTIVITY_GetBetOnMatchInfoOk = 102）
function ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetBetOnMatchInfoOk(matchId, status, homeTeam, visitTeam, winNum, loseNum, drawNum, gainNum)
    -- matchId : 比赛ID
    -- status : 比赛状态. 0:进行中 1:已结束 2:已开奖
    -- homeTeam : 主队ID
    -- visitTeam : 客队ID
    -- winNum : 主队赢投注数
    -- loseNum : 客队赢投注数
    -- drawNum : 平局投注数
    -- gainNum : 下注赢得数量
    WZLog("ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetBetOnMatchInfoOk")
    WndFootballGuessList:handleResultInfo(VectorToTable(matchId), VectorToTable(status), VectorToTable(homeTeam), VectorToTable(visitTeam), VectorToTable(winNum), VectorToTable(loseNum), VectorToTable(drawNum), VectorToTable(gainNum))
end

--@brief    获取竞猜商店（ACTIVITY_GetFootballQuizStoreOk = 106）
function ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetFootballQuizStoreOk(id, item, cost, leaveNum)
    -- id : 商品Id
    -- item : 物品id,数量
    -- cost : 消耗
    -- leaveNum : 剩余购买次数
    WZLog("ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetFootballQuizStoreOk")
    WndFootballGuessList:handleShopInfo(VectorToTable(id), VectorToTable(item), VectorToTable(cost), VectorToTable(leaveNum))
end

--@brief    购买竞猜商店商品（ACTIVITY_PurchaseFootballQuizStoreOK = 108）
function ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_PurchaseFootballQuizStoreOK(id, item, leaveNum)
    -- id : 商品Id
    -- item : 物品id,数量
    -- leaveNum : 剩余购买次数
    WZLog("ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_PurchaseFootballQuizStoreOK")
    WndFootballGuessList:buyOK(id, item, leaveNum)
end

--@brief    赠送鲜花（ACTIVITY_GiveFlowerOk = 114）       
function ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GiveFlowerOk(result)
    -- result : 状态(1.成功 2.活动不存在 3.非指定赠送物品 4.物品数量不足 5.赠送失败 6.通知显示特效)
    WZLog("ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GiveFlowerOk",result)
    if SceneCity.m_root or SceneCommunityMain.m_root then
        CellSpaceFlower:giveFlowerOk(result)
    end
end

--@brief    获取鲜花排行榜活动赠送详情（ACTIVITY_GetFlowerActivityInfoOk = 118）       
function ProtocolProcessorBase:parse_ACTIVITY_GetFlowerActivityInfoOk(playerId, name, sex, level, headScul, cross, num, time, total)
    -- playerId : 玩家id
    -- name : 名字
    -- sex : 性别
    -- level : 等级
    -- headScul : 头像信息
    -- cross : 0:本服 1:跨服
    -- num : 赠送数量
    -- time : 收到鲜花的次数
    -- total : 总共收到的鲜花数
    WZLog("ProtocolProcessorBase:parse_ACTIVITY_GetFlowerActivityInfoOk",Serialize(VectorToTable(playerId)),Serialize(VectorToTable(name)),Serialize(VectorToTable(sex)),Serialize(VectorToTable(level)),Serialize(VectorToTable(cross)),Serialize(VectorToTable(num)),Serialize(VectorToTable(time)),Serialize(VectorToTable(total)))
    WndMonthFighting:setFlowerRecordData(playerId,name,sex,level,headScul,cross,num,time,total)
end

--@brief    获取几年任务活动信息（ACTIVITY_GetMarkTaskInfoOk = 120）  
function ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetMarkTaskInfoOk(id, status1, status2, target, complete)
    -- id : 任务Id
    -- status1 : 常规领奖 状态0新增,1完成未领取,2完成
    -- status2 : 纪念奖 状态0新增,1完成未领取,2完成
    -- target : 目标数量
    -- complete : 完成数量
    WZLog("ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetMarkTaskInfoOk",Serialize(VectorToTable(id)),Serialize(VectorToTable(status1)),Serialize(VectorToTable(status2)),Serialize(VectorToTable(target)),Serialize(VectorToTable(complete)))
    
    CellMarkCoinPanel:getActivityTaskListOk( VectorToTable(id), VectorToTable(status1), VectorToTable(target), VectorToTable(complete), VectorToTable(status2))
end

--@brief    领取纪念奖活动奖励（ACTIVITY_ReceiveMarkTaskRewardOk = 122）       
function ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_ReceiveMarkTaskRewardOk(taskId, rewardType, itemId, itemNum)
    -- taskId : 玩家id
    -- rewardType : 名字
    -- itemId : 性别
    -- itemNum : 等级
    WZLog("ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_ReceiveMarkTaskRewardOk",taskId,rewardType,Serialize(VectorToTable(itemId)),Serialize(VectorToTable(itemNum)))
    
    CellMarkCoinItem:getActivityTaskRewardOk(taskId, rewardType, VectorToTable(itemId), VectorToTable(itemNum))
end
-------------------------------------协议错误处理方法模块--------------------------------------
--@brief    获取公告列表等信息错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndActivityOnLine:send_CIRCULAR_ANNOUNCEMENT_GETDETAIL_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndActivityOnLine:send_CIRCULAR_ANNOUNCEMENT_GETDETAIL_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ANNOUNCEMENT, Protocol.CIRCULAR_ANNOUNCEMENT_GETDETAIL, nflag, sMessage)
end

--@brief    获取活动列表等信息错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityListInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityListInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetActivityListInfo, nflag, sMessage)
end

--@brief    获取活动详细内容错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetActivityInfo, nflag, sMessage)
end

--@brief    领取奖励操作错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_ReceiveActivityReward, nflag, sMessage)
    WndNewActivity:sendProErrorResetCellLua()
end

--@brief    活动排行榜（ACTIVITY_RankList = 7）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_RankList_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndActivityOnLine:send_ACTIVITY_RankList_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_RankList, nflag, sMessage)
end


--@brief    获取暑期活动状态（ACTIVITY_GetSummerActivityStatus = 26）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetSummerActivityStatus_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetSummerActivityStatus_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetSummerActivityStatus, nflag, sMessage)
end

--@brief    获取怪物通缉信息（ACTIVITY_GetWantedMonsterInfo = 28）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetWantedMonsterInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetWantedMonsterInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetWantedMonsterInfo, nflag, sMessage)
end


--@brief    领取怪物通缉奖励（ACTIVITY_DrawWantedMonsterReward = 30）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_DrawWantedMonsterReward_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndActivityOnLine:send_ACTIVITY_DrawWantedMonsterReward_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_DrawWantedMonsterReward, nflag, sMessage)
end

--@brief	获取代言人活动状态（ACTIVITY_GetSpokesmanActivityStatus = 32）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetSpokesmanActivityStatus_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetSpokesmanActivityStatus_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetSpokesmanActivityStatus, nflag, sMessage)
end


--@brief    获取每日折扣信息（ACTIVITY_GetDailyDiscountInfo = 36）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetDailyDiscountInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetDailyDiscountInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetDailyDiscountInfo, nflag, sMessage)
end

--@brief    获取钻石抽奖信息（ACTIVITY_GetDiamondLotteryInfo = 38）   错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetDiamondLotteryInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetDiamondLotteryInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetDiamondLotteryInfo, nflag, sMessage)
end

--@brief    钻石抽奖（ACTIVITY_DiamondLottery = 39）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_DiamondLottery_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndActivityOnLine:send_ACTIVITY_DiamondLottery_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_DiamondLottery, nflag, sMessage)
end

--@brief     获取战力之王信息（ACTIVITY_GetFightingKingInfo = 34）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetFightingKingInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetFightingKingInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetFightingKingInfo, nflag, sMessage)
end

--@brief    获取排行榜数据（RANK_GetRankRecord = 1）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndActivityOnLine:send_RANK_GetRankRecord_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndActivityOnLine:send_RANK_GetRankRecord_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_RANK, Protocol.RANK_GetRankRecord, nflag, sMessage)
end

--@brief    获取个人排行榜数据（RANK_GetPlayerRank = 3）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndActivityOnLine:send_RANK_GetPlayerRank_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndActivityOnLine:send_RANK_GetPlayerRank_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_RANK, Protocol.RANK_GetPlayerRank, nflag, sMessage)
end

--@brief     膜拜战力之王（ACTIVITY_WorshipFigthingKing = 42）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_WorshipFigthingKing_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndActivityOnLine:send_ACTIVITY_WorshipFigthingKing_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_WorshipFigthingKing, nflag, sMessage)
end

--@brief    获取众筹活动信息（ACTIVITY_GetGrowdfunding = 48）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetGrowdfunding_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetGrowdfunding_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetGrowdfunding, nflag, sMessage)
end

--@brief    参与众筹（ACTIVITY_Growdfunding = 50）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_Growdfunding_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndActivityOnLine:send_ACTIVITY_Growdfunding_ErrorProcess")
    if WndChooseStockNum.m_root then 
        WndChooseStockNum:closeWin()
    end
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_Growdfunding, nflag, sMessage)
end

--@brief    获奖名单（ACTIVITY_GetGrowdfundingLog = 52）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetGrowdfundingLog_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetGrowdfundingLog_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetGrowdfundingLog, nflag, sMessage)
end

--@brief    幸运转盘奖励信息（ACTIVITY_GetLuckActivityInfo = 60）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetLuckActivityInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetLuckActivityInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetLuckActivityInfo, nflag, sMessage)
end

--@brief    福利卡活动信息（ACTIVITY_GetWelfareCardActivityInfo = 62）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetWelfareCardActivityInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetWelfareCardActivityInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetWelfareCardActivityInfo, nflag, sMessage)
end

--@brief    圣诞礼物活动信息（ACTIVITY_GetChristmasGiftActivityInfo = 64）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetChristmasGiftActivityInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetChristmasGiftActivityInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetChristmasGiftActivityInfo, nflag, sMessage)
end

--@brief    圣诞礼物抽奖（ACTIVITY_ChristmasGiftLottery = 66）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ChristmasGiftLottery_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ChristmasGiftLottery_ErrorProcess")
    WndChristmasTree:resetLotteryState()
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_ChristmasGiftLottery, nflag, sMessage)
end

--@brief    圣诞礼物活动整理背包（ACTIVITY_SortChristmasGiftBack = 68）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_SortChristmasGiftBack_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndActivityOnLine:send_ACTIVITY_SortChristmasGiftBack_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_SortChristmasGiftBack, nflag, sMessage)
end

--@brief    获取抽中的圣诞礼物（ACTIVITY_GetChristmasGift = 70）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetChristmasGift_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetChristmasGift_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetChristmasGift, nflag, sMessage)
end

--@brief    获取任务活动信息（ACTIVITY_GetActivityTaskList = 72）     错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityTaskList_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityTaskList_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetActivityTaskList, nflag, sMessage)
end

--@brief    获取任务活动信息（ACTIVITY_GetActivityTaskReward = 74）       错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityTaskReward_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityTaskReward_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetActivityTaskReward, nflag, sMessage)
end

--@brief	获取秒杀中的商品（ACTIVITY_GetActivitiesShopInfo = 77）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivitiesShopInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivitiesShopInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetActivitiesShopInfo, nflag, sMessage)
end 

--@brief	退出秒杀活动界面（ACTIVITY_OutActivitiesShop = 79）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_OutActivitiesShop_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndActivityOnLine:send_ACTIVITY_OutActivitiesShop_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_OutActivitiesShop, nflag, sMessage)
end

--@brief	购买秒杀活动商品（ACTIVITY_BuyActivitiesShop = 81）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_BuyActivitiesShop_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndActivityOnLine:send_ACTIVITY_BuyActivitiesShop_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_BuyActivitiesShop, nflag, sMessage)
end

--@brief    足球射门（ACTIVITY_ShootBall = 90）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ShootBall_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ShootBall_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_ShootBall, nflag, sMessage)
end

--@brief    获取竞猜列表（ACTIVITY_GetFootballQuizInfoList = 93）       错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetFootballQuizInfoList_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetFootballQuizInfoList_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetFootballQuizInfoList, nflag, sMessage)
end

--@brief    下注（ACTIVITY_BetOnFootballMatch = 97）        错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_BetOnFootballMatch_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndActivityOnLine:send_ACTIVITY_BetOnFootballMatch_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_BetOnFootballMatch, nflag, sMessage)
end

--@brief    足球射门（ACTIVITY_ShootBall = 90）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ShootBall_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ShootBall_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_ShootBall, nflag, sMessage)
end

--@brief    获取竞猜列表（ACTIVITY_GetFootballQuizInfoList = 93）       错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetFootballQuizInfoList_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetFootballQuizInfoList_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetFootballQuizInfoList, nflag, sMessage)
end

--@brief    下注（ACTIVITY_BetOnFootballMatch = 97）        错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_BetOnFootballMatch_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndActivityOnLine:send_ACTIVITY_BetOnFootballMatch_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_BetOnFootballMatch, nflag, sMessage)
end

--@brief    获取竞猜记录（ACTIVITY_GetBetOnMatchInfo = 101）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetBetOnMatchInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetBetOnMatchInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetBetOnMatchInfo, nflag, sMessage)
end

--@brief    获取竞猜商店（ACTIVITY_GetFootballQuizStore = 105）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetFootballQuizStore_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetFootballQuizStore_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetFootballQuizStore, nflag, sMessage)
end

--@brief    购买竞猜商店商品（ACTIVITY_PurchaseFootballQuizStore = 107）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_PurchaseFootballQuizStore_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndActivityOnLine:send_ACTIVITY_PurchaseFootballQuizStore_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_PurchaseFootballQuizStore, nflag, sMessage)
end

--@brief    赠送鲜花（ACTIVITY_GiveFlower = 113）     错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GiveFlower_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GiveFlower_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GiveFlower, nflag, sMessage)
end

--@brief    获取鲜花排行榜活动赠送详情（ACTIVITY_GetFlowerActivityInfo = 117）     错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorBase:send_ACTIVITY_GetFlowerActivityInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorBase:send_ACTIVITY_GetFlowerActivityInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetFlowerActivityInfo, nflag, sMessage)
end

--@brief    获取几年任务活动信息（ACTIVITY_GetMarkTaskInfo = 119）     错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetMarkTaskInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetMarkTaskInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetMarkTaskInfo, nflag, sMessage)
end

--@brief    领取纪念奖活动奖励（ACTIVITY_ReceiveMarkTaskReward = 121）     错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveMarkTaskReward_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveMarkTaskReward_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_ReceiveMarkTaskReward, nflag, sMessage)
end