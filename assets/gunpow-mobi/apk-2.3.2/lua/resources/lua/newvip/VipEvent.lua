--[[vip事件触发器]]

NewVipEvent = {
	NewVipEvent_ChargeListData = "NewVipEvent_ChargeListData", --获取充值列表(登录角色成功的时候回请求一次，现在这个是如果在登录失败的时候请求失败会再次请求)
	NewVipEvent_ChargeSuccessResult = "NewVipEvent_ChargeSuccessResult", --充值成功的时候返回
	NewVipEvent_WelfareCardResult = "NewVipEvent_WelfareCardResult",-- 福利卡活动信息
	NewVipEvent_GiftInfo = "NewVipEvent_GiftInfo",-- VIP礼包
	NewVipEvent_RebateInfo = "NewVipEvent_RebateInfo",-- 返利
	NewVipEvent_WeekGiftInfo = "NewVipEvent_WeekGiftInfo",-- 周礼包
	NewVipEvent_PrivilegeInfo = "NewVipEvent_PrivilegeInfo",-- 特权
	NewVipEvent_VipRankInfo = "NewVipEvent_VipRankInfo",--名人榜排行
	NewVipEvent_VipRankWorshipResult = "NewVipEvent_VipRankWorshipResult",--名人榜膜拜
	NewVipEvent_MedalInfo = "NewVipEvent_MedalInfo",--勋章基础信息
	NewVipEvent_GetMedalRewardResult = "NewVipEvent_GetMedalRewardResult",--勋章领取等级返回
	NewVipEvent_GetMedalItemInfo = "NewVipEvent_GetMedalItemInfo",--点击勋章返回
	NewVipEvent_GetPrivilegeResult = "NewVipEvent_GetPrivilegeResult",--特权奖励领取返回
}