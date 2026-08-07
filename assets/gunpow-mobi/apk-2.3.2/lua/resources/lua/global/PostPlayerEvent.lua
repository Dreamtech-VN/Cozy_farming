--PostPlayerEvent.lua
--@brief 从打开游戏到完成新手的过程中，在每个关键节点向服务器发送事件信息
--@date  2014/12/22
--@author linshubin
local RECORDFILENAME = "ddd2_event52352351.db"

PostPlayerEvent=
{
	--事件列表
	event_startgame 	     = 10000, --开始游戏，启动闪屏
	event_playCG             = 10101, --播放视频
	event_playCGEnd          = 10102, --播放CG结束
	event_playCGStop         = 10103, --手动停止CG

	event_enterDownUI        = 10201, --进入下载更新界面
	event_checkUpdateFail    = 10202, --检查更新失败
	event_showUpdateTips     = 10203, --提示下载框
	event_clickStartUpdate   = 10204, --点击下载
	event_clickCancelUpdate  = 10205, --点击取消下载
	event_updateSuccess      = 10206, --更新成功
	event_updateFail         = 10207, --更新失败

	event_enterLoginUI       = 10301, --进入登入界面
	event_clickStartLogin    = 10302, --点击开始游戏
	event_startSDKLogin      = 10303, --开始sdk登入
	event_loginSuccess       = 10304, --登入成功
	event_loginFail          = 10305, --登入失败

	event_requestServerList  = 10401, --请求服务器列表
	event_requestServerListSuccess       = 10402, --请求列表成功
	event_requestServerListFail          = 10403, --请求列表失败
	event_enterServerUI      = 10404, --进入服务器界面
	event_openServerList     = 10405, --打开服务器列表
	event_chooiceServer      = 10406, --点击选服

	event_clickEnterGame     = 10501, --点击进入游戏
	event_checkNeedQueue     = 10502, --检查是否需要排队
	event_openQueueUI        = 10503, --打开排队信息界面
	event_finshQueue         = 10504, --完成排队
	event_cancelQueue        = 10505, --取消排队
	event_starLoadRes        = 10506, --加载资源
	event_loadResSuccess     = 10507, --加载资源成功
	event_connectIPD         = 10508, --链接Ipd
	event_connectIPDSuccess  = 10509, --链接Ipd成功
	event_connectIPDFail     = 10510, --链接Ipd失败
	event_agreeUserAgreementAndPrivacy     = 10511, --勾选同意用户协议和隐私政策

	event_enterCreateActorUI = 10600, --打开创建角色界面
	event_clickCreateActor   = 10601, --点击创建角色
	event_createActorSuccess = 10602, --创建角色成功
	event_createActorFail    = 10603, --创建角色失败
	event_roleActorLogin     = 10604, --角色登陆
	event_roleActorLoginSuccess          = 10605, --角色登陆成功
	event_roleActorLoginFail             = 10606, --角色登陆失败
	--新手boss
	event_enterBattleOk99_1    = 10701, --战斗加载成功
	event_teachBossAttack      = 10702, --BOSS攻击
	event_teachBossAttackShow  = 10703, --攻击引导
	event_teachBossPlayerAttack= 10704, --玩家还击
	event_teachBossScatter 	   = 10705, --BOSS散射
	event_teachBossWeaponAppear= 10706, --出现武器
	event_teachBossMoveGuide   = 10707, --移动引导
	event_teachBossPickupWeapon= 10708, --移动引导拾取武器（变化形象）
	event_teachBossChooseShoot = 10709, --选择连发
	event_teachBossSkillAni    = 10710, --技能效果动画
	event_teachBossAttackBoss  = 10711, --攻击BOSS
	event_teachBossContinueShoot= 10712, --BOSS连发
	event_teachBossChooseSp    = 10713, --选择怒气技能
	event_teachBossBigSkillGuide= 10714, --大招引导
	event_teachBossKillBoss    = 10715, --使用大招秒杀BOSS
	--1级
	event_oneLvEnterCity = 10801, --返回主城界面
	event_ShowStory101 = 10802, --播放对白，101
	event_SkipStory101 = 9001, 	  --跳过剧情
	event_clickCopyShip1 = 10803, --点击副本飞船
	event_oneLvClickSingleCopy = 10804, --点击单人副本页签
	event_gotoSingleCopy1_1 = 10805, --点击单人副本第一关
	event_SingleCopyStart1_1 = 10806, --点击开始挑战按钮
	event_enterBattleOk1_1 = 10807, --加载成功，进入战斗
	event_ShowStory102 = 10808, --播放对白，102
	event_SkipStory102 = 9002, 	  --跳过剧情
	event_oneLvClickFly = 10809, --选择飞行道具
	event_oneLvFlyGuide = 10810, --飞行引导
	event_oneLvDoFly = 10811, --反向拉动角色飞行
	event_oneLvMonsterAttack = 10812, --怪物攻击
	event_ShowStory103 = 10813, --播放剧情，103
	event_oneLvChooseScatter = 10814, --选择散射
	event_oneLvAttackMonster = 10815, --攻击敌人
	event_oneLvMonsterAttack2 = 10816, --怪物攻击
	event_ShowStory104 = 10817, --播放剧情，104
	event_oneLvChooseForceSkill = 10818, --选择威力弹
	event_oneLvAttackMonster2 = 10819, --攻击敌人
	event_SingleCopyWin1_1 = 10820, --进入胜利结算界面
	event_ShowStory106 = 10821, --播放对白，106
	event_oneLvClickTask = 10822, --点击任务按钮
	event_finishTask1_1 = 10823, --点击完成任务按钮
	event_oneLvGotoTask = 10824, --点击执行任务按钮
	event_gotoSingleCopy1_2 = 10825, --点击单人副本第二关
	event_SingleCopyStart1_2 = 10826, --点击开始挑战按钮
	event_enterBattleOk1_2 = 10827, --加载成功，进入战斗
	event_ShowStory2 = 10828, --播放剧情，2
	event_oneLvPlayerShoot = 10829, --玩家发动过攻击，仅记录一次
	event_oneLvPlayerFirstSkill = 10830, --玩家首次使用了技能攻击
	event_oneLvHitMonster = 10831, --玩家首次攻击命中
	event_ShowStory3 = 10832, --播放剧情，3
	event_SingleCopyWin1_2 = 10833, --进入胜利结算界面
	event_enterUpgrade2 = 10834, --进入2等级升级结算界面
	event_enterPreFunction2 = 10835, --进入新功能预告/开启界面
	event_backtoSingleCopy1_2 = 10836, --返回单人副本界面
	--2级
	event_finishTask1_2 = 10901, --点击完成任务按钮
	event_gotoSingleCopy1_3 = 10902, --点击执行任务按钮
	event_SingleCopyStart1_3 = 10903, --点击第三关开始挑战按钮
	event_enterBattleOk1_3 = 10904, --加载成功，进入战斗
	event_ShowStory4 = 10905, --点播放剧情，4
	event_SkipStory4 = 9003, 	  --跳过剧情
	event_twoLvOperateShow = 10906, --镜头操作说明
	event_twoLvPlayerShoot = 10907, --玩家发动过攻击，仅记录一次
	event_twoLvCreatePartner = 10908, --助战怪成功生成
	event_ShowStory5 = 10909, --播放剧情，5
	event_SingleCopyWin1_3 = 10910, --进入胜利结算界面
	event_backtoSingleCopy1_3 = 10911, --返回单人副本界面
	event_ShowStory113 = 10912, --播放对白，113
	event_clickSingleCopyBox2 = 10913, --点击第一个章节宝箱
	event_finishTask1_3 = 10914, --点击领取奖励
	event_enterUpgrade3 = 10915, --进入3等级升级结算界面
	event_enterPreFunction3 = 10916, --进入新功能预告/开启界面
	--3级
	event_ShowStory110 = 11001, --播放剧情，110
	event_SkipStory110 = 9004, 	  --跳过剧情
	event_clickSwitch3 = 11002, --点击导航栏按钮
	event_ClickFunction3 = 11003, --点击技能按钮
	event_threeLvClickEdit = 11004, --点击编辑
	event_threeLvClickBomb = 11005, --点击核弹
	event_threeLvClickPropTab = 11006, --点击道具页签
	event_threeLvClickFire = 11007, --点击怒火
	event_threeLvClickBack = 11008, --点击返回
	event_threeLvFinishTask = 11009, --点击任务领奖
	event_gotoSingleCopy1_4 = 11010, --点击任务前往
	event_SingleCopyStart1_4 = 11011, --点击第四关开始挑战按钮
	event_enterBattleOk1_4 = 11012, --加载成功，进入战斗
	event_threeLvUseBomb = 11013, --玩家使用了核弹攻击
	event_threeLvMonsterDead = 11014, --怪物被坑死
	event_SingleCopyWin1_4 = 11015, --进入胜利结算界面
	event_backtoSingleCopy1_4 = 11016, --返回单人副本界面
	event_finishTask1_4 = 11017, --点击领取任务奖励
	event_enterUpgrade4 = 11018, --进入4等级升级结算界面
	event_enterPreFunction4 = 11019, --进入新功能预告/开启界面
	--4级
	event_clickSwitch4 = 12001, 	--展开导航栏
	event_ClickFunction4 = 12002, 	--点击角色按钮
	event_fourLvChooseEquip = 12003, 	--选择装备
	event_fourLvDressup = 12004, 	--点击穿上按钮
	event_fourLvClickBack = 12005, 	--点击返回按钮
	event_fourLvFinishTask = 12006, 	--点击领取奖励
	event_fourLvGotoTask = 12007, 	--点击前往任务按钮
	event_fourLvStrengthen = 12008, 	--点击强化按钮
	event_fourLvClickBack2 = 12009, 	--点击返回按钮
	event_fourLvFinishTask2 = 12010, 	--点击完成任务
	event_gotoSingleCopy1_5 = 12011, 	--点击前往
	event_SingleCopyStart1_5 = 12012, 	--点击第五关开始挑战按钮
	event_enterBattleOk1_5 = 12013, 	--加载成功，进入战斗
	event_ShowStory306 = 12014, 	--播放剧情，306
	event_SkipStory306 = 9005, 	  --跳过剧情
	event_fourLvUseBigSkill = 12015, 	--玩家使用了大招攻击
	event_ShowStory7 = 12016, 	--播放剧情，7
	event_SingleCopyWin1_5 = 12017, 	--进入胜利结算界面
	event_backtoSingleCopy1_5 = 12018, 	--返回单人副本界面
	event_ShowStory8 = 12019, 	--播放剧情，8
	event_finishTask1_5 = 12020, 	--点击完成任务
	event_enterUpgrade5 = 12021, --进入5等级升级结算界面
	event_enterPreFunction5 = 12022, --进入新功能预告/开启界面
	--5级
	event_fiveLvDressup = 13001, 	--穿上装备
	event_gotoSingleCopy2_1 = 13002, 	--点击前往任务
	event_SingleCopyStart2_1 = 13003, 	--点击开始2-1战斗按钮
	event_SingleCopyWin2_1 = 13004, 	--进入胜利结算界面
	event_backtoSingleCopy2_1 = 13005, 	--返回单人副本界面
	event_finishTask2_1 = 13006, 	--点击完成任务
	event_enterUpgrade6 = 13007, --进入6等级升级结算界面
	event_enterPreFunction6 = 13008, --进入新功能预告/开启界面
	--6级
	event_sixLvGotoTask = 14001,	--点击前往任务
	event_singleCopyClickBack6 = 14002,	--6级点击返回按钮
	event_beInCityShowWelfare6 = 14003,	--6级回到了主城（弹出了福利）
	event_SingleCopyStart2_2 = 14004,	--点击2-2开始按钮
	event_enterBattleOk2_2 = 14005,	--加载成功，进入战斗
	event_SingleCopyWin2_2 = 14006,	--进入胜利结算界面
	event_backtoSingleCopy2_2 = 14007,	--返回单人副本界面
	event_finishTask2_2 = 14008,	--点击完成任务
	event_enterUpgrade7 = 14009, --进入7等级升级结算界面
	event_enterPreFunction7 = 14010, --进入新功能预告/开启界面
	--7级
	event_sevenLvGotoTask = 15001,	--点击前往任务
	event_singleCopyClickBack7 = 15002,	--7级点击返回按钮
	event_beInCityShowWelfare7 = 15003,	--7级回到了主城（弹出了福利）
	event_SingleCopyStart2_3 = 15004,	--点击2-3开始按钮
	event_enterBattleOk2_3 = 15005,	--加载成功，进入战斗
	event_ShowStory9 = 15006,	--播放剧情，9
	event_ShowStory310 = 15007,	--播放剧情，310
	event_SkipStory310 = 9006, 	  --跳过剧情
	event_SingleCopyWin2_3 = 15008,	--进入胜利结算界面
	event_backtoSingleCopy2_3 = 15009,	--返回单人副本界面
	event_finishTask2_3 = 15010,	--点击完成任务
	event_gotoSingleCopy2_4 = 15011,	--点击前往任务
	event_SingleCopyStart2_4 = 15012,	--点击2-4开始按钮
	event_enterBattleOk2_4 = 15013,	--加载成功，进入战斗
	event_SingleCopyWin2_4 = 15014,	--进入胜利结算界面
	event_backtoSingleCopy2_4 = 15015,	--返回单人副本界面
	event_finishTask2_4 = 15016,	--点击完成任务
	event_enterUpgrade8 = 15017, --进入8等级升级结算界面
	event_enterPreFunction8 = 15018, --进入新功能预告/开启界面
	--8级
	event_backToCity8 = 16001, 	--返回主城界面
	event_eightLvClickHallBuilding = 16002, 	--19.1、点击竞技场建筑物
	event_eightLvClickFightTab = 16003, 	--19.2、点击对战赛页签
	event_eightLvChooseNum = 16004, 	--19.3、点击1V1按钮
	event_eightLvClickStart = 16005, 	--19.4、点击开始战斗按钮
	event_eightLvEnterBattle = 16006, 	--进入战斗
	event_eightLvFirstWin = 16007, 	--第一场竞技胜利
	event_eightLvFirstFail = 16008, 	--第一场竞技失败
	event_eightLvEnterWinUI = 16009, 	--进入胜利结算界面
	event_clickSwitch8 = 16010, 	--19.5、展开导航栏
	event_ClickFunction8 = 16011, 	--19.6、点击任务图标
	event_eightLvFinishTask = 16012, 	--19.7、点击完成任务
	event_gotoSingleCopy2_5 = 16013, 	--19.8、点击前往按钮
	event_SingleCopyStart2_5 = 16014, 	--点击2-5开始按钮
	event_enterBattleOk2_5 = 16015, 	--加载成功，进入战斗
	event_SingleCopyWin2_5 = 16016, 	--进入胜利结算界面
	event_backtoSingleCopy2_5 = 16017, 	--返回单人副本界面
	event_finishTask2_5 = 16018, 	--点击完成任务
	event_gotoSingleCopy2_6 = 16019, 	--点击前往任务按钮
	event_SingleCopyStart2_6 = 16020, 	--点击2-6开始按钮
	event_enterBattleOk2_6 = 16021, 	--加载成功，进入战斗
	event_ShowStory73 = 16022, 	--播放剧情，73
	event_SkipStory73 = 9007, 	  --跳过剧情
	event_SingleCopyWin2_6 = 16023, 	--进入胜利结算界面
	event_backtoSingleCopy2_6 = 16024, 	--返回单人副本界面
	event_finishTask2_6 = 16025, 	--点击完成任务
	--9级
	event_backToCity9 = 17001,	--返回主城界面
	event_nineLvClickLuckyCall = 17002,	--点击幸运召唤
	event_nineLvClickCall = 17003,	--点击召唤
	event_nineLvClickDressup = 17004,	--点击穿上装备
	event_nineLvClickHCall = 17005,	--点击高级召唤
	event_nineLvClickDressup2 = 17006,	--点击穿上装备
	event_nineLvPopGift = 17007,	--弹出购买礼包
	event_nineLvClosePopGift = 8001,	--关闭购买礼包操作
	event_nineLvBuyPopGiftOk = 8002,	--购买礼包成功操作
	event_nineLvBackCity2 = 17008,	--返回主城界面
	event_nineLvOpenTask = 17009,	--打开任务界面
	event_gotoSingleCopy2_7 = 17010,	--前往任务
	event_SingleCopyStart2_7 = 17011,	--点击2-7开始按钮
	event_enterBattleOk2_7 = 17012,	--加载成功，进入战斗
	event_SingleCopyWin2_7 = 17013,	--进入胜利结算界面
	event_backtoSingleCopy2_7 = 17014,	--返回单人副本界面
	event_finishTask2_7 = 17015,	--点击完成任务
	event_nineLvGotoTask2 = 17016,	--点击前往任务
	event_nineLvFinishEquipStrengthen = 17017,	--完成强化任意装备任务
	event_SingleCopyStart2_8 = 17018,	--点击2-8开始按钮
	event_enterBattleOk2_8 = 17019,	--加载成功，进入战斗
	event_ShowStory11 = 17020,	--播放剧情，11
	event_ShowStory12 = 17021,	--播放剧情，12
	event_finishTask2_8 = 17022,	--点击完成任务
	--10级
	event_backToCity10 = 18001,	--返回主城界面
	event_tenLvClickRank = 18002,	--点击排行榜
	event_tenLvClickPlayer = 18003,	--点击玩家
	event_tenLvClickWorship = 18004,	--点击膜拜
	event_tenLvClickBack = 18005,	--点击返回
	event_tenLvFinishTask = 18006,	--点击完成排行榜查看任务
	event_tenLvClickShop = 18007,	--点击商城
	event_tenLvClickBodyTab = 18008,	--点击商城身体页签
	event_tenLvClickDress = 18009,	--点击时装
	event_tenLvClickBuy = 18010,	--点击购买
	event_tenLvClickPay = 18011,	--点击付款
	--other
	event_SingleCopyStart3_1 = 19001,	--点击3-1开始按钮
	event_SingleCopyStart3_2 = 19002,	--点击3-2开始按钮
	event_SingleCopyStart3_3 = 19003,	--点击3-3开始按钮
	event_SingleCopyStart3_4 = 19004,	--点击3-4开始按钮
	event_SingleCopyStart3_5 = 19005,	--点击3-5开始按钮
	event_SingleCopyStart3_6 = 19006,	--点击3-6开始按钮
	event_SingleCopyStart3_7 = 19007,	--点击3-7开始按钮
	event_SingleCopyStart3_8 = 19008,	--点击3-8开始按钮
	event_SingleCopyStart3_9 = 19009,	--点击3-9开始按钮
	event_SingleCopyStart3_10 = 19010,	--点击3-10开始按钮
	event_SingleCopyWin3_1 = 19011,	--3-1第一次战斗胜利
	event_SingleCopyWin3_2 = 19012,	--3-2第一次战斗胜利
	event_SingleCopyWin3_3 = 19013,	--3-3第一次战斗胜利
	event_SingleCopyWin3_4 = 19014,	--3-4第一次战斗胜利
	event_SingleCopyWin3_5 = 19015,	--3-5第一次战斗胜利
	event_SingleCopyWin3_6 = 19016,	--3-6第一次战斗胜利
	event_SingleCopyWin3_7 = 19017,	--3-7第一次战斗胜利
	event_SingleCopyWin3_8 = 19018,	--3-8第一次战斗胜利
	event_SingleCopyWin3_9 = 19019,	--3-9第一次战斗胜利
	event_SingleCopyWin3_10 = 19020,	--3-10第一次战斗胜利
	--补充
	event_clickPowerItem5 = 19101,	--5级点击怒气技能道具
	event_clickPowerItem6 = 19102, 	--6级点击怒气技能道具
	event_clickPowerItem7 = 19103, 	--7级点击怒气技能道具
	event_clickPowerItem8 = 19104,	--8级点击怒气技能道具

	event_clickSevenDay6 = 19201, 	--6级点击七天乐
	event_clickSevenDay7 = 19202, 	--7级点击七天乐
	event_clickSevenDay8 = 19203, 	--8级点击七天乐
	event_clickSevenDay9 = 19204, 	--9级点击七天乐
	event_clickSevenDay10 = 19205, 	--10级点击七天乐

	event_clickCopyShip6 = 19301, 	--6级主城点击冒险船
	event_clickCopyShip7 = 19302, 	--7级主城点击冒险船
	event_clickCopyShip8 = 19303, 	--8级主城点击冒险船
	event_clickCopyShip9 = 19304, 	--9级主城点击冒险船
	event_clickCopyShip10 = 19305, 	--10级主城点击冒险船

	event_clickSingleCopyBox6 = 19401, 	--6级点击领取单人副本宝箱
	event_clickSingleCopyBox7 = 19402, 	--7级点击领取单人副本宝箱
	event_clickSingleCopyBox8 = 19403, 	--8级点击领取单人副本宝箱
	event_clickSingleCopyBox9 = 19404, 	--9级点击领取单人副本宝箱
	event_clickSingleCopyBox10 = 19405, 	--10级点击领取单人副本宝箱

	event_gameSignIn6 = 19501, 	--6级进行签到
	event_gameSignIn7 = 19502, 	--7级进行签到
	event_gameSignIn8 = 19503, 	--8级进行签到
	event_gameSignIn9 = 19504, 	--9级进行签到
	event_gameSignIn10 = 19505, 	--10级进行签到




	--越南的特殊埋点
	event_payVnWeb           = 11000, --越南网页支付埋点

	--充值模块(会重复发送)
	event_payStep1           = 80001, --弹出充值提示所在界面
	event_payStep2           = 80002, --打开充值界面(主城和上拉栏)
	event_payStep3           = 80003, --跳转到充值界面
	event_payStep4           = 80004, --选择档次
	event_payStep5           = 80005, --获得订单
	event_payStep6           = 80006, --拉起sdk
	event_payStep7           = 80007, --sdk支付失败
	event_payStep8           = 80008, --充值成功


	--英雄相关埋点
	event_playerregister     = 90001, 
	event_sdkLoginSuccess    = 90002, 
	event_deviceactive       = 90003,
	event_task    			 = 90003,
	event_playerorder    	 = 90003,
	event_playerstage    	 = 90003,
	event_playerfight    	 = 90003,

    
    event_luaErrorLog      = 9999, --lua错误日志
    --服务器名称
    m_sServiceName = nil,
    
    --错误log发送限制，最多20条
    m_nTotalErrorLogNum = 0,
    m_nErrorLogMax = 20,

    --不限制发送次数
    m_bPostNoLimit = false,

    --发送记录
    m_tPostRecord = nil,
    
    m_nTaskIndex = 10000
}


--@brief    初始化
function PostPlayerEvent:init()
	self.m_tBasisData = {}
	--游戏包名
	self.m_tBasisData.packageName = WGameCmUtil:GetBundleIdentifier()
	--游戏平台
	local platformId = WZUISystem:getInstance():getPlatformInfo()
	if platformId == 2 then
		self.m_tBasisData.platformInfo = "android"
	elseif platformId == 1 then
		self.m_tBasisData.platformInfo = "ios"
	else
		self.m_tBasisData.platformInfo = tostring(platformId)
	end
	--设备名称
	self.m_tBasisData.deviceName = WZDeviceInfo:systemName()
	--设备版本
	self.m_tBasisData.deviceVersion = WZDeviceInfo:systemVersion()
	--网络类型
	self.m_tBasisData.networkType ="unknown"
	--idfa
	self.m_tBasisData.idfa = WGameCmUtil:GetUDID()
	--当前时间
	self.m_nCurTime = os.time() 
	--WZLog("PostPlayerEvent:init m_tBasisData", Serialize(self.m_tBasisData))
	--埋点地址
	self.m_sAddress = ProjConfig.POST_EVENT_URL
	--版本号
	self.m_tBasisData.gameVersion = ProjConfig.INSTALLVERSION
	self.m_tPostRecord = ReadFileToTable(RECORDFILENAME, "ddd2", false)
   -- WZLog("PostPlayerEvent:init", Serialize(self.m_tPostRecord))
	if self.m_tPostRecord == nil or type(self.m_tPostRecord) ~= "table" then
		self.m_tPostRecord = {}
	end
	self.gameId,self.gameKey = self:getHeroIdAndKey()
end

--@brief    设置服务器名称
function PostPlayerEvent:setServiceName(sName)
	if sName~= nil then
		self.m_sServiceName="service"..sName
	end
end

function PostPlayerEvent:getHeroIdAndKey()
	local packName = WGameCmUtil:GetBundleIdentifier()
	if packName == "com.herogame.bombleadsa" or packName == "com.herogame.gplay.dddsea" or packName == "com.herogame.gplay.dddglo" then
		--东南亚
		return 10010,"0abfa2f17cbb4f7d"
	elseif packName == "com.herogame.bombleadtw" or packName == "com.herogame.gplay.bombleadtw" then
		--ios海外
		return 10011,"8383e27f8c374e09"
	end
	if ProjConfig.LANGUAGE == "cn" then
		return 109,"9d409206ecee428a"
	end
	return 0,""
end

function PostPlayerEvent:dealHeroData(eventId,_tData)
	--英雄的埋点 
	if not eventId then
		return
	end
	WZLog("PostPlayerEvent:dealHeroData:", eventId,self.gameId) 
	local nEventId = eventId
	if self.gameId ~= 0 then
		WZLog("PostPlayerEvent:dealHeroData2222")
		if nEventId == self.event_playerregister then
			--注册成功
			local tData = {}
			tData.gameUserId = CacheCenter:getPlayerInfo().id
			tData.roleName = CacheCenter:getPlayerInfo().name
			self:postHeroData(nEventId,"playerregister",tData)
		elseif nEventId == self.event_sdkLoginSuccess then
			--新增设备
			WZLog("PostPlayerEvent:dealHeroData333")
			local data = WZDataFile:getInstance():getUserData()
  			if data then
  				local isNew = data:getStringValue("postData", "isNew")
  				WZLog("PostPlayerEvent:dealHeroData444:",isNew)
        		if isNew == nil or isNew == "" then
        			WZLog("PostPlayerEvent:dealHeroData555")
					local tData = {}
					tData.phoneMode = WZDeviceInfo:systemName()
					tData.os = WZDeviceInfo:systemVersion()
					tData.netMode = 1
					self:postHeroData(nEventId,"deviceregister",tData)
					data:setStringValue("postData", "isNew", "false")
        			data:flush()
				end
			end
		elseif nEventId == self.event_deviceactive then
			--设备激活
			local data = WZDataFile:getInstance():getUserData()
  			if data then
  				local isNew = data:getStringValue("postData", "isFirstLogin")
        		if isNew == nil or isNew == "" then
					local tData = {}
					tData.phoneMode = WZDeviceInfo:systemName()
					tData.os = WZDeviceInfo:systemVersion()
					tData.netMode = 1
					self:postHeroData(nEventId,"deviceactive",tData)
					data:setStringValue("postData", "isFirstLogin", "false")
        			data:flush()
				end
			end
			--玩家登陆
			WZLog("PostPlayerEvent:dealHeroData1043")
			local loginData = {}
			local playInfo = CacheCenter:getPlayerInfo()
			loginData.gameUserId = playInfo.id
			loginData.roleName = playInfo.name
			loginData.level = playInfo.level
			loginData.vipLevel = playInfo.vipLevel
			loginData.netMode = 1
			self:postHeroData(nEventId,"playerlogin",loginData)
		elseif nEventId == self.event_task then
			--任务追踪
			self:postHeroData(nEventId,"playertask",_tData)
		elseif nEventId == self.event_playerorder then
			--任务追踪
			self:postHeroData(nEventId,"playerorder",_tData)
		elseif nEventId == self.event_playerstage then
			--任务追踪
			self:postHeroData(nEventId,"playerstage",_tData)
		elseif nEventId == self.event_playerfight then
			--任务追踪
			self:postHeroData(nEventId,"playerfight",_tData)
		end
	end

end

function PostPlayerEvent:postHeroData(eventId,eventName,tData)
	WZLog("PostPlayerEvent:postHeroData:",eventId, eventName)
	tData.roleId = eventName
	if eventId ~=  self.event_sdkLoginSuccess then
		tData.gameServerId = IPDhttpServer:getCurServerId() 
		tData.roleId = CacheCenter:getPlayerInfo().id
		if eventId == self.event_playerorder then
			if self.gameId == 10010 then
				--东南亚
			    tData.currency = "USD"
			elseif self.gameId == 10011 then
				--繁体
				tData.currency = "NTD"
			else
				tData.currency = "CNY"
			end
		end
	end
  local sign = WZDeviceInfo:md5Generate("HDC"..self.gameId..self.gameKey)
  tData.sign = sign
  tData.eventId = eventId..os.time()
  tData.channelId = ProjConfig:getChannelId()
  tData.platformId = WZUISystem:getInstance():getPlatformInfo()-1
  tData.vCode = WZDeviceInfo:appVersion()
  tData.actionId = tData.roleId..os.time()
  tData.opTime = os.date("%Y")..os.date("%m")..os.date("%d")..os.date("%H")..os.date("%M")..os.date("%S")
  tData.deviceId = WGameCmUtil:GetUDID()
  tData.eventName  = eventName
  tData.gameId = self.gameId
  --tData.appkey = self.gameKey
  local sPostData = json.encode(tData)
  local sPostData = "["..sPostData.."]"
  local sign = WZDeviceInfo:md5Generate("HDC"..sPostData..self.gameKey)
  print("hhh:"..sPostData.."---"..sign)
  local url = ""
  if ProjConfig.DEBUG == 1 then
  	url = "https://sandbox-data.yingxiong.com/server/data/"..self.gameId
  else
  	url = "https://data.0sdk.com/server/data/"..self.gameId
  	if self.gameId == 109 then
  		url = "https://data.yingxiong.com/server/data/"..self.gameId
  	end
  end
  local fullUrl = url .. "?data=" ..sPostData
  print("HHHHHHHHHHH:"..fullUrl)
  local mulThreadSystem = WZUISystem:getInstance():getMultiThreadSystem()
  local downLoadInfoTask = nil
  downLoadInfoTask = WZHTTPPostDataLuaTask:create(1, url,sPostData,PostPlayerEvent.postCallback, PostPlayerEvent)
  if downLoadInfoTask.setHeader then
	  downLoadInfoTask:setHeader("token","wyd5")
	  downLoadInfoTask:setHeader("gameid",""..self.gameId)
	  downLoadInfoTask:setHeader("sign",string.lower(sign))
	  mulThreadSystem:addDownloadTask(downLoadInfoTask)
  else
  	WZLog("NNNNNNNNNNNNNN")
  end 

end

--@brief 向服务器post信息
--@param nEventId 事件id
--@param tExInf 额外信息
function PostPlayerEvent:postEvent(nEventId,tExInf)
    WZLog("PostPlayerEvent:postEvent")
	if not nEventId then
		return
	end
	if not self:_judgeInTheLevel(nEventId) then 
		return 
	end

	if nEventId >= 90000 then
		self:dealHeroData(nEventId,tExInf)
		return
	end
	if not self:_check(nEventId)  then 
		return
	end
    local platForm =  WZUISystem:getInstance():getPlatformInfo()
    if nEventId ~= event_openPay and nEventId ~= event_clickPay and nEventId ~= event_starPaySDK and nEventId ~= event_finshPaySDK then 
        if platForm == 2 then  -- android 不处理埋点
            --return 
        end
    end 
    
	--下载时post有时会导致线程问题，闪退，现在屏蔽
	--[[if nEventId==PostPlayerEvent.event_downloadFail or
		nEventId==PostPlayerEvent.event_downloadTipOpen	or
		nEventId==PostPlayerEvent.event_downloadClickConfirm  then
		return
	end]]
    if self.m_sAddress == nil or self.m_sAddress == "" then
        WZLog("PostPlayerEvent:postEvent m_sAddress invalid")
        return
    end
	local tPostData = self:_stuffPostData(nEventId,tExInf)
	WZLog("PostPlayerEvent:postEvent:", Serialize(tPostData))
    local sPostData = json.encode(tPostData)
    local vBytes = WGameCmUtil:EnCrypt(sPostData, "d8w3jfd2s2")
    local sData = WGameCmUtil:transformBytesToString(vBytes)
	local request = WZHTTPPostDataLuaTask:createWithTimeout(1, self.m_sAddress, "data="..sData, 3, 5)
	WZUISystem:getInstance():getMultiThreadSystem():addDownloadTask(request)
    
    self.m_nTaskIndex = self.m_nTaskIndex + 1
    self:_record(nEventId)
end

function PostPlayerEvent:postCallback(nTaskId, sResponse, nTotalSize, nNowSize, bFinished, bFailed)
    if nTaskId > self.m_nTaskIndex or nTaskId < 10000 then
        return
    end
    if bFinished then --成功
		WZLog("PostPlayerEvent:postCallback success", sResponse)
    elseif bFailed then --失败
        WZLog("PostPlayerEvent:postCallback failed")
    end
end

--@breif 获取发送的参数
function PostPlayerEvent:_stuffPostData(nEventId, tExInf)
	local tData = self.m_tBasisData or {}
	--耗时
	local time = os.time()
	tData.useTime = time - self.m_nCurTime
	self.m_nCurTime = time
	--事件点
	tData.eventid = tostring(nEventId)
	--渠道号，qucik子包会改变所以要在这里设置
	tData.channelId = tostring(ProjConfig.CHANNEL_ID)
	--角色id 
	tData.playerId = self:_getPlayerId()
	--服务器ID
	tData.gameServerId = self:_getServerId()
	--网络状态
	local platForm =  WZUISystem:getInstance():getPlatformInfo()
	if platForm == 2 then
		--美洲android需要上传google advertising id
  		WZLog("PostPlayerEvent:_stuffPostData:googleadid:", PassportSdkManager.s_googleAdvertiseId)
  		tData.googleAdId = PassportSdkManager.s_googleAdvertiseId	
    end

	if WZDeviceInfo.networkType then
		--self.m_tBasisData.networkType = WZDeviceInfo:networkType()
	end

	if tExInf then
		tData.dict = tExInf
	end 
	--tData.dict = self:_getExtraData(nEventId, tExInf)
	
	return tData
end

--服务器名称
function PostPlayerEvent:_getServerId()
	if IPDhttpServer.IpdCurServer and IPDhttpServer.getCurServerId then
		return IPDhttpServer:getCurServerId() 
	else
		return "-1"
	end
end

function PostPlayerEvent:_getChannelId()
	return tostring(ProjConfig.CHANNEL_ID) 
end

function PostPlayerEvent:_getPlayerId()
	local tPlayerInfo = CacheCenter:getPlayerInfo()
    if tPlayerInfo then
        return tostring(tPlayerInfo.id)
    else
        return "-1"
    end
end

--@brief 检测是否需要post
function PostPlayerEvent:_check(nEventId)
	if self.m_tPostRecord == nil or type(self.m_tPostRecord) ~= "table" then 
		self.m_tPostRecord = {}
		return true
	end
	if nEventId == self.event_errorlog then
		if self.m_nTotalErrorLogNum >= self.m_nErrorLogMax then
			print("##### error log out of range")
			return false
		end
		self.m_nTotalErrorLogNum = self.m_nTotalErrorLogNum + 1
		return true
	end
	if nEventId > 80000 and nEventId < 90000 then
		return true
	end	
	if nEventId == self.event_agreeUserAgreementAndPrivacy then
		return true
	end
	return self.m_tPostRecord[tostring(nEventId)] == nil
end

--@brief 记录发送的次数
function PostPlayerEvent:_record(nEventId)
    WZLog("PostPlayerEvent:_record", nEventId)
	--if self:_isEveryEvent(nEventId) then return end

	if nEventId then
		self.m_tPostRecord[tostring(nEventId)] = 1
        WriteTableToFile(self.m_tPostRecord, RECORDFILENAME, "ddd2", false)
--        WZLog("PostPlayerEvent:_record finished", Serialize(self.m_tPostRecord))
	end
end

--@brief新手教程埋点
--@param tag步骤标识 比如“25-1”
function PostPlayerEvent:postTeach(teachTag)
	local tagTab =SplitStringWithSeparator(teachTag,"-") or {}
	local teachEventId = 20000
	if tagTab[1] then
		teachEventId = teachEventId + tonumber(tagTab[1]) * 100
	end
	if tagTab[2] then
		teachEventId = teachEventId + tonumber(tagTab[2])
	end
    WZLog("HHHHHH:",teachEventId)
    self:postEvent(teachEventId)
    WZLog("PostPlayerEvent:postTeach", tag)
end

function PostPlayerEvent:_getClockTime()
	local nTime, nClockTime = WZUISystem:getTimeOfDay()
	return tostring(nTime)
end

--@brief 	判断是否在相应的等级
function PostPlayerEvent:_judgeInTheLevel(nEventId)
	-- body
	if nEventId >= PostPlayerEvent.event_oneLvEnterCity and nEventId <= PostPlayerEvent.event_backtoSingleCopy1_2 or nEventId == PostPlayerEvent.event_SkipStory101 or nEventId == PostPlayerEvent.event_SkipStory102 then 
		local level = CacheCenter:getPlayerInfo().level
		if level > 2 then 
			return false 
		end
	end
	if nEventId >= PostPlayerEvent.event_finishTask1_2 and nEventId <= PostPlayerEvent.event_enterPreFunction3 or nEventId == PostPlayerEvent.event_SkipStory4 then 
		local level = CacheCenter:getPlayerInfo().level
		if level ~= 2 then 
			return false 
		end
	end
	if nEventId >= PostPlayerEvent.event_ShowStory110 and nEventId <= PostPlayerEvent.event_enterPreFunction4 or nEventId == PostPlayerEvent.event_SkipStory110 then 
		local level = CacheCenter:getPlayerInfo().level
		if level ~= 3 then 
			return false
		end
	end
	if nEventId >= PostPlayerEvent.event_clickSwitch4 and nEventId <= PostPlayerEvent.event_enterPreFunction5 or nEventId == PostPlayerEvent.event_SkipStory306 then 
		local level = CacheCenter:getPlayerInfo().level
		if level ~= 4 then 
			return false
		end
	end
	if nEventId >= PostPlayerEvent.event_fiveLvDressup and nEventId <= PostPlayerEvent.event_enterPreFunction6 then 
		local level = CacheCenter:getPlayerInfo().level
		if level ~= 5 then 
			return false
		end
	end
	if nEventId >= PostPlayerEvent.event_sixLvGotoTask and nEventId <= PostPlayerEvent.event_enterPreFunction7 then 
		local level = CacheCenter:getPlayerInfo().level
		if level ~= 6 then 
			return false
		end
	end
	if nEventId >= PostPlayerEvent.event_sevenLvGotoTask and nEventId <= PostPlayerEvent.event_enterPreFunction8 or nEventId == PostPlayerEvent.event_SkipStory310 then 
		local level = CacheCenter:getPlayerInfo().level
		if level ~= 7 then 
			return false
		end
	end
	if nEventId >= PostPlayerEvent.event_backToCity8 and nEventId <= PostPlayerEvent.event_finishTask2_6 or nEventId == PostPlayerEvent.event_SkipStory73 then 
		local level = CacheCenter:getPlayerInfo().level
		if level ~= 8 then 
			return false
		end
	end
	if nEventId >= PostPlayerEvent.event_backToCity9 and nEventId <= PostPlayerEvent.event_finishTask2_8 then 
		local level = CacheCenter:getPlayerInfo().level
		if level ~= 9 then 
			return false
		end
	end
	if nEventId >= PostPlayerEvent.event_backToCity10 and nEventId <= PostPlayerEvent.event_tenLvClickPay then 
		local level = CacheCenter:getPlayerInfo().level
		if level ~= 10 then 
			return false
		end
	end

	return true
end

--@brief 检测是否需要post
function PostPlayerEvent:_checkVN(strEvent)
	if self.m_tPostRecord == nil or type(self.m_tPostRecord) ~= "table" then 
		self.m_tPostRecord = {}
		return true
	end

	return self.m_tPostRecord[strEvent] == nil
end