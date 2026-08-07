--GlobalGame.lua
--@brief	全局协议或者游戏环境变量的定义
--@date  	2013/12/12
--@author 	xiaoyu_wu
--@note 	全局协议或者游戏环境变量的定义

GlobalGame = 
{
	g_bIfLoginOk = false, --是否已经登录成功，除登录相关的协议与系统协议外，其他的协议需要登录成功之后才能发，否则会被服务器踢掉线
    g_bIfInBattle = false, --是否在战斗中
    g_bIfLevelUp = false, --战斗过程中是否升级了
    g_bIfInTeaching = false, --是否在新手教学中
	g_bIfExploration = false, --是否在密境探险转动中
	tPushWeibo = nil,--微博推特列表
	m_nSchedule = nil,--微博推特定时器Id
	
    --当前界面ID，其值与聊天频道ID一致
    g_nCurrentUIChannelId = -1,
    g_nLastMainChannelId = -1,
    --断线时的界面ID，用来识别断线时在哪个界面，其值与聊天频道ID一致
    g_nUIChannelIdBeforeReconnect = -1,
	--登录后活动界面弹出提示
    g_checkLoginActivities = true,
    g_tBtnRedPointEvent = nil, --按钮红点全局对象
    g_AnnouncementNeedReaq = false,
	g_tPlayerInfo = {}, --玩家信息
	g_tSysConfig = {}, --系统配置信息
    g_tButtonInfo = {}, --小岛界面按钮信息
	g_tBagInfo = {}, -- 背包信息
    g_tLookEquipment = {}, -- 当前设备信息
    g_tPlayerStoreEquipment1 = {}, -- 玩家背包装备列表(武器)
    g_tPlayerStoreEquipment2 = {}, -- 玩家背包装备列表(装扮)
    g_tPlayerStoreEquipment3 = {}, -- 玩家背包装备列表(其他)
    g_tPlayerEquipments = {}, -- 玩家装备信息
    g_tPrShopList = {}, -- 促销商品列表信息
    g_tFrientList = {}, -- 好友列表
    g_tBlackList = {}, -- 黑名单
    g_bIsActivityUIShow = false, --已进入活动界面
    g_nTaskCount = 0,  --未领取任务数量
    g_nMainTaskCount = 0, --主线任务未领取数量
    g_nBranchTaskCount = 0, --支线任务未领取数量
    g_nDailyTaskCount = 0, --日常任务未领取数量
    g_nAthleticsTaskCount = 0, --竞技任务未领取数量
    n_ActivityOnLineSubTabType = 0,  --活动面板的选项
    g_nSelectWaitingRoom = 0, --选择只显示等待状态的房间
    n_ActivitySelected = 0,
    g_nMailCount = 0,  --未读邮件数量
	g_nSignRewardNum = 0,  --签到可领取奖励数量
	g_nLoginRewardNum = 0,  --登录可领取奖励数量
	g_nLevelRewardNum = 0,  --等级可领取奖励数量
	g_nOnlineRewardNum = 0,  --在线可领取奖励数量
    g_nVipGiftBagNum = 0,   --vip可领取礼包数量
    g_nVipPrivilege = 0,   	--vip特权数量
    g_nHuiMesNum = 0, --公会界面聊天信息数目（设置信息ID用）
    g_nMesPriNum = 0,--私聊界面聊天信息数目（设置信息ID用）
    g_nAllMesNum = 0,--全部界面聊天信息数目（设置信息ID用）
    g_nWorldMesNum = 0,--世界界面聊天信息数目（设置信息ID用）
    g_nPrivateNum = 0,--私聊频道未读取聊天数目
	--全局开关
	g_bShowItemIndefinite = true,	--无期限的物品是否显示“无期限”
	bOpenGPS = false,
	g_tProducteList = {}, --产品列表
	bIsLoadInIsland = true,
    g_TeachTask = {},
    g_isHasSendToken = false,
    
    g_isMouthly = false,
    
    g_MarryPassWord = nil,
    g_sWenddingNum = nil,
    g_manName = nil,
    g_womanName = nil,
    g_tDownloadReward = {}, --下载奖励列表
    g_bIsHasDownload = false,
    
    g_isOpenMapEvent = false,   --地图事件
	g_ReincPlayerLeve = 999,--玩家转生前的等级判定(方便统一修改)
    g_subMissionID = -1,  --任务副本ID
    g_simstate = false,  --手机卡状态（true正常，false不正常）
    g_isyifubao = nil,   --是否使用易宝支付
    g_isCanPopPaySucc = nil, --是否可以弹出充值成功弹窗
    g_bIshasPlatForm = false,
    g_nHallLevelDividingLine = 25,  --游戏大厅高级初级等级分界线
	g_upgradePro = {},
    g_missionData = {},
    g_subMapData = {},

	g_isMounts = false,

    g_singleCopyData = nil,
    g_nMoveEndPointXNowMoveElement = nil,
    g_tMoveEndPointXNowPlayer = {},
    g_bMoveEndFlipXNowPlayer = nil,
    g_nFigureSceneId = nil,
    g_nSingleMapPage = nil,  
    g_nEliteSingleMapPage = nil ,
    g_nDevilSingleMapPage = nil ,
    g_sRecordToken = nil,   --语音聊天验证Token
    g_sRecordAppkey = nil,  --应用appkey
    g_tRecordRoomList = {},  --语音聊天室列表
    g_tRedPointList = {},
    g_tEnterRecordRoomList = {},  --已加入聊天室列表
    g_tSceneList = {SceneCity = 1,SceneHall = 2,SceneRoom = 4,WndSingCopy = 12,WndMultiCopy = 15,SceneBossRoom = 16,WndTowerScroll = 19,WndDailyCopy = 25,SceneWeddingChurch = 86,SceneWeddingDaily = 94,SceneCommunityMain=29,ScenePvpRank=118,SceneGuildWarRoom=174,ScenePvp=2,ScenePvpAmuse=191,SceneRune=195},
    g_nCurRecordRoomId = nil , --当前加入的语音聊天室ID
    g_tWndFightingList = {},
    g_nWorldBossInspire = 0,
    g_bSingCopyOver = false,   --单人副本结算是否已经结束
    g_tSingCopyOver = {},      --单人副本结算的数据
    g_tWndBottomBarObj = nil,
    g_bIsRewardShow = nil,
    g_nCurRecordRoomType = 3,
    g_nCurRecordRoomName = nil,  --当前主场景名称
    g_nCurRecordId = nil,  --地图ID或者婚礼ID
    g_nCurBattleId = nil,  --当前战斗ID
    g_nCurBattleRoomId = nil , --当前战斗ID
    g_bFightRage = false ,  --战斗力是否提高了(提高了就做相应的动画提示)
    g_nSingleCopyType = 1,  
    g_autoGameActivity = true,       --进游戏自动弹活动标记
    g_bisLogined = false,
    g_bIsDisconnectToLoginOk = nil,
    g_nPetScaleInCity = 0.55,    --宠物在主城的缩放比例
    g_nPetScaleInBattle = 0.55,  --宠物在战斗的缩放比例0.65
    g_sServerAppkey = nil ,        --保存服务器返回过来的appKey
    g_bIsGetFirstRecharge = nil,
    g_nRankOpenDay = 0,
    g_bIsOpenTouchScaleBtn = true,     --战斗触摸范围放大按钮的开关
    g_nPlayerInTeam = -1,  --玩家所在队伍
    g_nRoleSound = nil,
	g_ClickedDress = false,
    g_tSecretData = {},  --需要加密的信息的存储地址
    g_roamStartTime = -1,
    g_nSpaceSex = -1,   --空间性别
    g_sHeadScul = "",   --空间头像
    g_tSecretData = {},  --需要加密的信息的存储地址
    g_bIsNoFirstRechange = false,   --是否不是首冲
    g_bIsGuildWarHaveRedDot = false, --公会战是否有红点
    g_autoNewActivity = false,    --弹一周年活动标记

    g_autoSummerActivity = 1, --弹暑假活动标记
    g_autoSummerStartT = nil,  --暑假活动开始时间
    g_autoSummerEndT = nil , --暑假活动结束时间
    
    --战斗模式
    g_tBattleMode = {BATTLE_MODE_JJ=1,BATTLE_MODE_FH=2,BATTLE_MODE_LD = 3,BATTLE_MODE_DZ = 4,BATTLE_MODE_WK = 5,BATTLE_MODE_DJ = 6,BATTLE_MODE_FB = 7,BATTLE_MODE_GS = 8,BATTLE_MODE_JH = 9},
    --房间所属属性
    g_tRoomChannel = {BATTLE_CHANNEL_DZ = 1,BATTLE_CHANNEL_YL= 2,BATTLE_CHANNEL_PW = 3,BATTLE_CHANNEL_SJ = 4,BATTLE_CHANNEL_ZF = 5,BATTLE_CHANNEL_FF = 6,BATTLE_CHANNEL_GF= 7,BATTLE_CHANNEL_GZ = 8,BATTLE_CHANNEL_LS = 9,BATTLE_CHANNEL_LX = 10,BATTLE_CHANNEL_QS = 11,BATTLE_CHANNEL_WTB = 12,BATTLE_CHANNEL_YXT  = 13},
    --匹配模式
    g_tStartMode = {START_MODE_RANDOM = 1,START_MODE_LIBERTY = 2},
    --人数模式
    g_tNumMode = {NUM_MODE_ANY = -1,NUM_MODE_1 = 1,NUM_MODE_2 = 2,NUM_MODE_3 = 3},
    --比赛赛程
    g_tSchedule = {SCHEDULE_GW_1 = 1,SCHEDULE_GW_2 = 2,SCHEDULE_GW_3 = 3,SCHEDULE_LS_1= 1,SCHEDULE_LS_2= 2,SCHEDULE_LS_3 = 3, SCHEDULE_LS_4 = 4,SCHEDULE_LS_5 = 5,SCHEDULE_LS_6 = 6,SCHEDULE_LS_7 = 7,SCHEDULE_LS_8 = 8,SCHEDULE_LS_9 = 9,SCHEDULE_LS_10 = 10,SCHEDULE_LS_11 = 11,SCHEDULE_LS_12 = 12,SCHEDULE_LS_13 = 13,SCHEDULE_LS_14 = 14, SCHEDULE_LS_15 = 15,SCHEDULE_LS_16 = 16},
    g_nRecentChallengeSection = nil, --最近挑战的单人副本章节
    g_nRecentChallengeTime   = nil , --最近挑战单人副本的时间
    g_nEscapeReceiveTime = -1, --接收到大逃杀时的时间
    g_nEscapeSurplusTime = -1, --大逃杀剩余的时间
    g_nEscapeState = -1, --大逃杀状态

    G_ClownTreasure_Quick = 0,   --寻宝跳过动画 (0：不跳过，1：跳过)

    --最后进的房间号
    g_lastRoomNumber = nil, 
    --最后进的房间座位
    g_lastRoomSeat = nil,

    g_isServerTaskOpen = nil,   --七天乐是否开放
    g_serverTaskTime = 0,       --七天乐开始时间
    g_pvpPunishTime = nil,         --排位赛惩罚时间
    g_pvpPunishTimeCurServiceT = 0, --获取排位赛惩罚时间时服务器的时间

    g_oppo_channel = "-1", --判断是否有oppo买量渠道标志1-自然用户 3-广告用户、广告id
    g_oppo_adId = "-1",    --判断是否有oppo买量渠道标志1-自然用户 3-广告用户、广告id

    --苹果自动续订订阅相关
    g_nSubscrip = nil,          -- subscrip : 是否订阅ios月卡（1为订阅，0为没订阅）
    g_nSubscripEffective = nil, -- effective : 订阅是否在有效期内(1为有效，0为没效)
    g_bIsClickMonthCard = false,-- 是否是从充值列表或福利卡月卡界面点击了购买月卡（订阅错误协议返回时立即跳转到购买普通月卡，为防止错误协议是检查漏单时返回的，故添加个变量判断）
    g_bIsSubscriptionFailed = false,--是否在第一次发起订阅后订阅失败
}

GlobalGame.g_tInfo = 
{
	bUpLevel = false,--是否升级
	m_nFighting = 0,--战斗力的差值
    nFighting = 0,  --延迟的战斗力差值
}

GlobalGame.g_tPlayerInfo = 
{
	nAthLevel,          --竞技场等级
    nPvpRankLevel,          --竞技场等级
    nPlayerId, 			--角色id
	sPlayerName, 		--角色名称
	nTickets, 			--点卷数量
	nMaxLevel, 			--最高等级
	nPlayerHp, 			--HP
	nPlayerDefend, 		--防御
	nPlayerPhysical, 	--体力
	nPlayerDefense, 	--暴击
	nPlayerGold, 		--金币
	nPlayerHonor, 		--荣誉
	nPlayerSex, 		--性别
	nLevel, 			--角色等级
	nAattack, 			--攻击力
	nExp, 				--角色当前经验
	sGuildName, 		--公会名称
	nMedalNum, 			--勋章数量
	nCritRate, 			--暴击率
	nExplodeRadius, 	--爆破范围
	nProficiency, 		--武器熟练度
	sSuit_head, 		--着装串头
	sSuit_face, 		--着装串脸
	sSuit_body, 		--着装串身
	sSuit_weapon, 		--着装串武器
	nWeapon_type, 		--武器类型0:投掷类1:射击类
	nUpgradeexp, 		--角色当前升级所需经验
	nVipLevel, 			--vip等级，非vip返回0
	sSuit_wing, 		--着装翅膀
	sPlayer_title, 		--称号
	nWeaponLevel,		--玩家武器等级
	vsWbUserId, 		--玩家微博id
	nZsleve, 			--转生等级
	nInjuryFree, 		--免伤
	nWreckDefense, 		--破防
	nReduceCrit, 		--免暴
	nReduceBury, 		--免坑
	nforce, 			--力量
	nArmor, 			--护甲
	nAgility,			--敏捷
	nPhysique,			--体质
	nLuck, 				--幸运
	nQualifyingLevel, 	--排位赛等级
	bDoubleCard, 		--是否有双倍经验卡（true表示有）
	nFighting, 			--战斗力
	nGuildId, 			--公会ID
	nSteps, 			--新手教程步骤
	nVipMark, 			--是否vip
	nVipLastDay, 		--vip剩余数量
	nHeart, 			--爱心数
	nGuideLevel, 		--攻击自动制导最高等级
	nBlastLevel,		--爆破地图最低等级
	nPetNum ,			--玩家宠物数量
	
	nLabaNum, 			--普通喇叭数量
	nColorLabaNum, 		--彩色喇叭数量
}

GlobalGame.g_tSysConfig = 
{
	islandState,-- 0：非节日，1：春节，2：圣诞节
	openTapjoy,-- true, --打开，false：关闭
	openNewTeach,-- true, --打开新手教学，false：关闭
	noviceType,-- 新手教程类型 0和怪打，1和玩家打
	bindAccLevel,-- 弹出绑定帐号最低等级 默认5级
	bindAccDelta,-- 弹出绑定帐号间隔时间 秒 默认300秒
	openSMSCode,-- 是否开启短代功能
	popNotice,-- 是否自动弹出信息公告开关
	popGoldPeople,-- 是否自动弹出小金人活动
	worldChatExp,-- 世界聊天获得经验
	colorChatExp,-- 彩色聊天获得经验
	probability_x,-- 机器人邀请概率1
	probability_y,-- 机器人邀请概率2
	inviteLevel,-- 机器人邀请等级
	waitTime,-- 小岛界面等待秒数
	battleWaitTime,-- 战斗大厅界面等待秒数
	petInheritanceLevel,-- 开启宠物传承等级
	openLinShiVip ,-- 是否开启临时VIP
	openBind,-- 是否开启绑定
	serviceMode,-- 弹王挑战是否开启跨服模式（0否，1是）
	challengeStarted,-- 弹王挑战赛是否已开始
	openTipLevel,-- 显示tip的级别
	crossLevel,-- 默认跨服对战等级，0表示关闭跨服对战
    moreGame,-- 交叉推荐开关-1为不显示，显示时字段值作为URL
	squareTip,-- 小金人弹出信息
	playerLevel,--抛物线范围对应等级
	parabolaRange,--抛物线范围
	openRecharge,--充值赢暴击奖励开关   0表示关闭，1显示打开
	soundRoomOpen,--语音房间开关（false关，true开）
	openGPS,--GPS系统功能总开关（false关，true开）
	refreshGPSFrequency,--客户端访问GPS频率（单位秒）
	singleMapTag,--单人副本呼出标识
    singleMapCurPage,--单人副本当前页面
    multipleMapCurPage, --组队副本当前页数
    singleMapCurPoint,--单人副本小关卡
    connectState,--当前链接服务器状态
    cartonTab,--副本切换
}

GlobalGame.g_tButtonInfo = {
    buttonId,-- 按钮id
    buttonType,-- 按钮类型 0主界面建筑按钮，1主界面左侧按钮，2主界面中部按钮，3主界面右侧按钮。
    buttonIcon,-- 按钮的图标
    buttonTips,-- 按钮的提示
    buttonStatus1Level,--按钮状态  按钮显示不可用需求等级
    buttonStatus2Level,--按钮状态  按钮显示可用返回提示需求等级
    buttonStatus3Level,--按钮状态  按钮显示可用功能开放需求等级
    buttonSort,-- 按钮的排序值
    IsHighlight,-- 按钮是否高亮
}

GlobalGame.g_tProducteList = {
    ids = {},       --产品Id
    icons = {},    --产品icon
    pices = {},      --钻石数量
    discount = {} ,  --产品折扣
    productPrice = {},  --价格
    localizedTitle ={}, --
}

GlobalGame.g_TeachTask = {
    nTaskCount = 0,
    tTaskId = {},
    tTaskStatus = {},
    tTaskTargetValue = {},
    tPtId            = {},
    
}

--@brief 有聊天按钮的场景
GlobalGame.chatScene = 
{
    "SceneCity" ,
    "SceneHall" ,
    "SceneWeddingDaily" ,
    "SceneWeddingChurch" ,
    "SceneCommunityMain",
    "SceneWorldBoss",
}

GlobalGame.PayCard = 
{
	PAYCARD1 = "支付说明",
	PAYCARD2 = "支付宝",
	PAYCARD3 = "移动充值卡",
	PAYCARD4 = "电信充值卡",
	PAYCARD5 = "联通充值卡",
	PAYCARD6 = "骏网一卡通",
	PAYCARD7 = "盛大卡",
	PAYCARD8 = "征途卡",
	PAYCARD9 = "Q币卡",
	PAYCARD10 = "网易卡",
    PAYCARD11 = "短信支付",
	RECHARGE_TITLE = "单笔充值越多优惠越大",
    RECHARGE_TITLE_SMS = "一键完成充值操作",
	RECHARGE_CARD = [[
    1元=10钻石;
    11-50元,多百分之十;
    51-100元,多百分之十五;
    101-300元,多百分之二十;
    300元以上的多百分之二十五;
    ]],
    RECHARGE_CARD_SMS = [[
    所有充值秒速到账，轻松、便捷!

    充值越多，享受充值返利越多!

    首次充值还可领取首冲大礼包!
    
    ]],
	RECHARGE_PROMPT = "(温馨提示:支付宝支付页面可以使用储存卡快捷支付，无支付宝也可以充值!)",
	RECHARGE_PAYTITLE1 = "请选择你的充值卡面值",
    RECHARGE_PAYTITLE1_ZFB = "请选择充值金额",
	RECHARGE_PAYTITLE2 = "%d元人民币可兑换%d钻石",
	RECHARGE_PAYTITLE3 = "请你正确选择充值卡面值,与卡号不匹配会可能会导致交易失败,并造成充值卡失效,无法找回!",
}
--数据为模拟数据
GlobalGame.g_tDownloadReward =
{
    rewardItemsId = {}, --奖励物品id
    rewardItemsIcon = {},--奖励物品icon
    rewardItemsName = {},--奖励物品名字
    rewardItemsNum = {},--奖励物品数量
}

GlobalGame.g_imageCache = 
{
	-- [1] = {imgPath = "ui/city/main_scene/yasuo/tiankong50.png",cacheTexture = nil,textureFormat=kTexture2DPixelFormat_RGB565},
	-- [2] = {imgPath = "ui/city/main_scene/yasuo/xiaodao50.png",cacheTexture = nil,textureFormat=kTexture2DPixelFormat_RGBA4444},
	-- [3] = {imgPath = "ui/city/main_scene/yasuo/richangfuben.png",cacheTexture = nil},
	-- [4] = {imgPath = "ui/city/main_scene/yasuo/zhongjingtietu/02.png",cacheTexture = nil},
	-- [5] = {imgPath = "ui/city/main_scene/yasuo/zhongjingtietu/03.png",cacheTexture = nil},
	-- [6] = {imgPath = "ui/city/main_scene/yasuo/zhongjingtietu/04.png",cacheTexture = nil},
	-- [7] = {imgPath = "ui/city/main_scene/yasuo/zhongjingtietu/1.png",cacheTexture = nil},
	--[8] = {imgPath = "ui/common_bg/common_scale9_di2.png",cacheTexture = nil},
}
--@brief   添加文件缓存
function GlobalGame:checkCacheImage()
	for i,v in ipairs(GlobalGame.g_imageCache) do 
		local defaultPixelFormat = CCTexture2D:defaultAlphaPixelFormat()
		if v.cacheTexture == nil then 
			if v.textureFormat ~= nil then 
				CCTexture2D:setDefaultAlphaPixelFormat(v.textureFormat)
			end 
			v.cacheTexture = CCTextureCache:sharedTextureCache():addImage(v.imgPath)
			if v.cacheTexture ~= nil then 
				v.cacheTexture:retain()
			end
		end
		CCTexture2D:setDefaultAlphaPixelFormat(defaultPixelFormat)
		--print("GlobalGame:checkCacheImage",v.imgPath,v.cacheTexture)
	end
    local platForm =  WZUISystem:getInstance():getPlatformInfo()
    if WGCacheFileList ~= nil then 
        for i,v in ipairs(WGCacheFileList) do
            CCFileUtils:sharedFileUtils():cacheFileData(v.file)
            if v.cacheXml == 1 and CCFileUtils:sharedFileUtils().addCacheXml ~= nil then 
                if string.sub(v.file,string.len(v.file)-5) == ".plist" and platForm ~= 1 then
                    --CCFileUtils:sharedFileUtils():addCacheXml(v.file)                    
                end
                if string.sub(v.file,string.len(v.file)-3) == ".xml" then 
                    --CCFileUtils:sharedFileUtils():addCacheXml(v.file)
                end
            end
            if v.cacheTexture ~= nil and v.cacheTexture == 1 
                and CCFileUtils:sharedFileUtils().cacheImageData ~= nil 
                and string.sub(v.file,string.len(v.file)-3) == ".pkm" 
                and getTotalMemory() > 600
            then
                CCFileUtils:sharedFileUtils():cacheImageData(v.file)
            end
        end
    end
    if WGTextureFormatMapping ~= nil 
       and CCTextureFormatMapping ~= nil 
       and getTotalMemory() < 800 
       and (platForm == 1 or platForm == 2) 
    then 
        for i,v in ipairs(WGTextureFormatMapping) do
            CCTextureFormatMapping:getInstance():setTextureFormat(v.file,6)
        end
    end
end

function GlobalGame:load_plist_pack()
    
    if WZFileUtil:isFileExist("pack/chat/pack_chat_0.plist") then
        CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("pack/chat/pack_chat_0.plist")
    end
    if WZFileUtil:isFileExist("pack/common/pack_common_0.plist") then
        CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("pack/common/pack_common_0.plist")
        CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("pack/common/pack_common_1.plist")
    end
    if WZFileUtil:isFileExist("pack/common/pack_"..ProjConfig.LANGUAGE.."_common_0.plist") then
        CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("pack/common/pack_"..ProjConfig.LANGUAGE.."_common_0.plist")
    end
    if WZFileUtil:isFileExist("pack/city_new_ui/pack_city_new_ui_0.plist") then
        CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("pack/city_new_ui/pack_city_new_ui_0.plist")
    end
    if WZFileUtil:isFileExist("pack/city/pack_city_0.plist") then
        CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("pack/city/pack_city_0.plist")
    end

    CCSpriteFrameCache:sharedSpriteFrameCache():removeUnusedSpriteFrames()
    CCTextureCache:sharedTextureCache():removeUnusedTextures()
    local platForm =  WZUISystem:getInstance():getPlatformInfo()
    
    if WZFileUtil:isFileExist("pack/chat/pack_chat_0.plist") then
        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("pack/chat/pack_chat_0.plist")
    end
    if WZFileUtil:isFileExist("pack/common/pack_common_0.plist") then
        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("pack/common/pack_common_0.plist")
        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("pack/common/pack_common_1.plist")
    end
    if WZFileUtil:isFileExist("pack/common/pack_"..ProjConfig.LANGUAGE.."_common_0.plist") then
        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("pack/common/pack_"..ProjConfig.LANGUAGE.."_common_0.plist")
    end
    if WZFileUtil:isFileExist("pack/city_new_ui/pack_city_new_ui_0.plist") then
        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("pack/city_new_ui/pack_city_new_ui_0.plist")
    end
    if WZFileUtil:isFileExist("pack/city/pack_city_0.plist") then
        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("pack/city/pack_city_0.plist")
    end

end

--@brief    根据类型获取按钮信息表里面对应的按钮信息
--@param    nBtnType,按钮类型
--@return   #1,包含按钮信息的数据表
function GlobalGame:getBtnInfoByType(nBtnType)
    WZLog("GlobalGame:getBtnInfoByType", nBtnType)
    if self.g_tButtonInfo.buttonId == nil or self.g_tButtonInfo.buttonType == nil then
        return
    end
    local tBtnsInfo = {}
    for i,v in ipairs(self.g_tButtonInfo.buttonId) do
        if nBtnType == nil or self.g_tButtonInfo.buttonType[i] == nBtnType then
            local tBtnInfo = {}
            tBtnInfo.buttonId = self.g_tButtonInfo.buttonId[i]
            tBtnInfo.buttonType = self.g_tButtonInfo.buttonType[i]
            tBtnInfo.buttonSort = self.g_tButtonInfo.buttonSort[i]
            tBtnInfo.buttonChannel = self.g_tButtonInfo.buttonChannel[i]
            tBtnInfo.buttonGroup = self.g_tButtonInfo.buttonGroup[i]
            tBtnInfo.buttonSort2 = self.g_tButtonInfo.buttonSort2[i]

            if type(self.g_tButtonInfo.buttonTips) == "table" then
                tBtnInfo.buttonTips = self.g_tButtonInfo.buttonTips[i]
            end
            if type(self.g_tButtonInfo.buttonStatus1Level) == "table" then
                tBtnInfo.buttonStatus1Level = self.g_tButtonInfo.buttonStatus1Level[i]
            end
            if type(self.g_tButtonInfo.buttonStatus3Level) == "table" then
                tBtnInfo.buttonStatus3Level = self.g_tButtonInfo.buttonStatus3Level[i]
            end

            table.insert(tBtnsInfo, tBtnInfo)
        end
    end

    --WZLog("GlobalGame:getBtnInfoByType", nBtnType, Serialize(tBtnsInfo))
    if #tBtnsInfo == 0 then
        return
    end
    return tBtnsInfo
end

--@brief    根据类型获取按钮信息表里面对应的按钮信息
--@param    nBtnType,按钮类型
--@return   #1,包含按钮信息的数据表
function GlobalGame:getBtnInfoByGroupType(nBtnType)
    --WZLog("GlobalGame:getBtnInfoByGroupType0", nBtnType)
    if self.g_tButtonInfo.buttonId == nil or self.g_tButtonInfo.buttonType == nil then
        return
    end
    local tBtnsInfo = {}
    for i,v in ipairs(self.g_tButtonInfo.buttonId) do
        local group = self.g_tButtonInfo.buttonGroup[i]
        --WZLog("GlobalGame:getBtnInfoByGroupType1", nBtnType, type(group))
        if type(group) == "table" then
            for j,w in ipairs(group[1]) do
                --WZLog("GlobalGame:getBtnInfoByGroupType2", nBtnType, w)
                if nBtnType == nil or w == nBtnType then
                    local tBtnInfo = {}
                    tBtnInfo.buttonId = self.g_tButtonInfo.buttonId[i]
                    tBtnInfo.buttonType = nBtnType or self.g_tButtonInfo.buttonType[i]
                    tBtnInfo.buttonSort = self.g_tButtonInfo.buttonSort[i]
                    tBtnInfo.buttonChannel = self.g_tButtonInfo.buttonChannel[i]
                    tBtnInfo.buttonGroup = self.g_tButtonInfo.buttonGroup[i][1][j]
                    tBtnInfo.buttonSort2 = self.g_tButtonInfo.buttonSort2[i][1][j]

                    if type(self.g_tButtonInfo.buttonTips) == "table" then
                        tBtnInfo.buttonTips = self.g_tButtonInfo.buttonTips[i]
                    end
                    if type(self.g_tButtonInfo.buttonStatus1Level) == "table" then
                        tBtnInfo.buttonStatus1Level = self.g_tButtonInfo.buttonStatus1Level[i]
                    end
                    if type(self.g_tButtonInfo.buttonStatus3Level) == "table" then
                        tBtnInfo.buttonStatus3Level = self.g_tButtonInfo.buttonStatus3Level[i]
                    end

                    table.insert(tBtnsInfo, tBtnInfo)
                    break
                end
            end
        end
    end

    --WZLog("GlobalGame:getBtnInfoByGroupType3", nBtnType, Serialize(tBtnsInfo))
    if #tBtnsInfo == 0 then
        return
    end
    return tBtnsInfo
end

--@brief    掉线重连不重置  但是重新登陆必须重置的数据
function GlobalGame:resetAll()
    self.g_nSingleMapPage = nil  --玩家正在玩的单人副本页数
    self.g_sRecordToken = nil   --语音聊天验证Token
    self.g_sRecordAppkey = nil  --应用appkey
    self.g_tRecordRoomList = {}  --语音聊天室列表
    self.g_tRedPointList = {}
    self.g_tEnterRecordRoomList = {}  --已加入聊天室列表
    self.g_tSceneList = {SceneCity = 1,SceneHall = 2,SceneRoom = 4,WndSingCopy = 12,WndMultiCopy = 15,SceneBossRoom = 16,WndTowerScroll = 19,WndDailyCopy = 25,SceneWeddingChurch = 86,SceneWeddingDaily = 94}
    self.g_nCurRecordRoomId = nil  --当前加入的语音聊天室ID
    self.g_nCurrentUIChannelId = -1
    self.g_nLastMainChannelId = -1
    self.g_nRecentChallengeTime = nil 
    self.g_nRecentChallengeSection = nil 
end

--@brief    重置全局数据
function GlobalGame:reset()
	self.g_bIfLoginOk = false --是否已经登录成功，除登录相关的协议与系统协议外，其他的协议需要登录成功之后才能发，否则会被服务器踢掉线
    self.g_bIfInBattle = false --是否在战斗中
    self.g_bIfLevelUp = false --战斗过程中是否升级了
    self.g_bIfInTeaching = false --是否在新手教学中
    self.g_bIfExploration = false --是否在密境探险转动中
    self.tPushWeibo = nil --微博推特列表
    self.m_nSchedule = nil --微博推特定时器Id
    
    --当前界面ID，其值与聊天频道ID一致
    --self.g_nCurrentUIChannelId = -1 
    --断线时的界面ID，用来识别断线时在哪个界面，其值与聊天频道ID一致
    self.g_nUIChannelIdBeforeReconnect = -1
    --登录后活动界面弹出提示
    self.g_checkLoginActivities = true
    self.g_tBtnRedPointEvent = nil --按钮红点全局对象
    self.g_AnnouncementNeedReaq = false
    self.g_tPlayerInfo = {} --玩家信息
    self.g_tSysConfig = {} --系统配置信息
    self.g_tButtonInfo = {} --小岛界面按钮信息
    self.g_tBagInfo = {} -- 背包信息
    self.g_tLookEquipment = {} -- 当前设备信息
    self.g_tPlayerStoreEquipment1 = {} -- 玩家背包装备列表(武器)
    self.g_tPlayerStoreEquipment2 = {} -- 玩家背包装备列表(装扮)
    self.g_tPlayerStoreEquipment3 = {} -- 玩家背包装备列表(其他)
    self.g_tPlayerEquipments = {} -- 玩家装备信息
    self.g_tPrShopList = {} -- 促销商品列表信息
    self.g_tFrientList = {} -- 好友列表
    self.g_tBlackList = {} -- 黑名单
    self.g_bIsActivityUIShow = false --已进入活动界面
    self.g_nTaskCount = 0  --未领取任务数量
    self.g_nMainTaskCount = 0 --主线任务未领取数量
    self.g_nBranchTaskCount = 0 --支线任务未领取数量
    self.g_nAthleticsTaskCount = 0 --竞技任务未领取数量
    self.g_nDailyTaskCount = 0 --日常任务未领取数量
    self.n_ActivityOnLineSubTabType = 0  --活动面板的选项
    self.g_nSelectWaitingRoom = 0 --选择只显示等待状态的房间
    self.n_ActivitySelected = 0
    self.g_nMailCount = 0  --未读邮件数量
    self.g_nSignRewardNum = 0  --签到可领取奖励数量
    self.g_nLoginRewardNum = 0  --登录可领取奖励数量
    self.g_nLevelRewardNum = 0  --等级可领取奖励数量
    self.g_nOnlineRewardNum = 0  --在线可领取奖励数量
    self.g_nVipGiftBagNum = 0   --vip可领取礼包数量
    self.g_nVipPrivilege = 0    --vip特权数量
    self.g_nHuiMesNum = 0 --公会界面聊天信息数目（设置信息ID用）
    self.g_nMesPriNum = 0 --私聊界面聊天信息数目（设置信息ID用）
    self.g_nAllMesNum = 0 --全部界面聊天信息数目（设置信息ID用）
    self.g_nWorldMesNum = 0 --世界界面聊天信息数目（设置信息ID用）
    self.g_nPrivateNum = 0 --私聊频道未读取聊天数目
    --全局开关
    self.g_bShowItemIndefinite = true   --无期限的物品是否显示“无期限”
    self.bOpenGPS = false
    self.g_tProducteList = {} --产品列表
    self.bIsLoadInIsland = true
    self.g_TeachTask = {}
    self.g_isHasSendToken = false
    
    self.g_isMouthly = false
    
    self.g_MarryPassWord = nil
    self.g_sWenddingNum = nil
    self.g_manName = nil
    self.g_womanName = nil
    self.g_tDownloadReward = {} --下载奖励列表
    self.g_bIsHasDownload = false
    
    self.g_isOpenMapEvent = false   --地图事件
    self.g_ReincPlayerLeve = 999 --玩家转生前的等级判定(方便统一修改)
    self.g_subMissionID = -1  --任务副本ID
    self.g_simstate = false  --手机卡状态（true正常，false不正常）
    self.g_isyifubao = nil   --是否使用易宝支付
    self.g_isCanPopPaySucc = nil --是否可以弹出充值成功弹窗
    self.g_bIshasPlatForm = false
    self.g_nHallLevelDividingLine = 25  --游戏大厅高级初级等级分界线
    self.g_upgradePro = {}
    self.g_missionData = {}
    self.g_subMapData = {}

    self.g_isMounts = false

    self.g_singleCopyData = nil
    if (SceneCity == nil or SceneCity.m_root ~= nil) and (SceneCommunity == nil or SceneCommunity.m_root == nil)  then 
        self.g_nMoveEndPointXNowMoveElement = nil
        self.g_tMoveEndPointXNowPlayer = {}
        self.g_bMoveEndFlipXNowPlayer = nil
        self.g_nFigureSceneId = nil
    end 
    
    self.g_tWndFightingList = {}
    self.g_nWorldBossInspire = 0
    self.g_bSingCopyOver = false   --单人副本结算是否已经结束
    self.g_tSingCopyOver = {}      --单人副本结算的数据
    self.g_tWndBottomBarObj = nil
    self.g_bIsRewardShow = nil
    self.g_nCurRecordRoomType = 3
    self.g_nCurRecordRoomName = nil  --当前主场景名称
    self.g_nCurRecordId = nil  --地图ID或者婚礼ID
    self.g_nCurBattleId = nil  --当前战斗ID
    self.g_nCurBattleRoomId = nil  --当前战斗ID
    self.g_autoGameActivity = true       --进游戏自动弹活动标记
    self.g_bLoginTalkSDK = false --掉线重连语音SDK会自动重登SDK
    self.g_bIsGuildWarHaveRedDot = false  --公会战是否有红点
    self.g_autoNewActivity = true  --弹一周年活动标识
    self.g_lastRoomNumber = nil
    self.g_lastRoomSeat = nil
end

--@brief    设置是否在战斗中
--@param    bInBattle,是否在战斗中
function GlobalGame:setIfInBattle(bInBattle)
    WZLog("GlobalGame:setIfInBattle",bInBattle,GlobalGame.g_bIfLevelUp)
    self.g_bIfInBattle = bInBattle
	
	--进入战斗场景后设置网络链接标识位
	if bInBattle then
		IPDConnector.g_nNetConnectFlag = NET_FLAG_7
	end
    local sceneName = WindowManager:getSceneRoot():getName()
    if GlobalGame.g_bIfLevelUp == true and sceneName ~= "SceneThrowingEggs" and not WindowManager:ifWindowExist(SceneCarton)--检查是否升级了
        and sceneName ~= "ScenceBattleSettlment" then
        WZLog("GlobalGame.g_bIfLevelUp == true 2")
        WndUpgrade:showInfo(true)
        GlobalGame.g_bIfLevelUp = false
    end
end

--@brief    检查玩家等级，如果玩家已经转生，玩家等级a = a-99
--@return    level:返回玩家等级
function GlobalGame:checkGlobalPlayerLevel(level)
    if level ~= nil and type(level) == "string" then
        level = tonumber(level)
    end
	level = level or GlobalGame.g_tPlayerInfo.nLevel
	if level <= GlobalGame.g_ReincPlayerLeve then
		return level
	else
		return level - GlobalGame.g_ReincPlayerLeve
	end
end

--@brief    检查玩家转生等级，如果玩家等级超过99，玩家已经转生
--@return   zsleve:0:没转生,1已经转生
function GlobalGame:checkGlobalPlayerZsleve(level)
    if level ~= nil and type(level) == "string" then
        level = tonumber(level)
    end
	level = level or GlobalGame.g_tPlayerInfo.nLevel
	if level < 999 then
		return 0
	else
		return 1
	end
end

--@brief 全局事件
function GlobalGame:getBtnRedPointEvent()
    if not GlobalGame.g_tBtnRedPointEvent then
        GlobalGame.g_tBtnRedPointEvent = BtnRedPointEvent:New()
    end
    return GlobalGame.g_tBtnRedPointEvent
end

--@brief 重置全局事件
function GlobalGame:resetBtnRedPointEvent()
    GlobalGame.g_tBtnRedPointEvent = nil
    GlobalGame.g_tBtnRedPointEvent = BtnRedPointEvent:New()
end

--@brief 按钮状态
function GlobalGame:setButtonState()
    if GlobalGame.g_tButtonInfo == nil or #GlobalGame.g_tButtonInfo == 0 then
        local count = BattleCommon:tableLen(GDatatab_button_info)
        GlobalGame.g_tButtonInfo.buttonId = {}
        GlobalGame.g_tButtonInfo.buttonName = {}
        GlobalGame.g_tButtonInfo.buttonType = {}
        GlobalGame.g_tButtonInfo.buttonTips = {}
        GlobalGame.g_tButtonInfo.buttonStatus1Level = {}
        GlobalGame.g_tButtonInfo.buttonStatus3Level = {}
        GlobalGame.g_tButtonInfo.buttonSort = {}
        GlobalGame.g_tButtonInfo.buttonChannel = {}
        GlobalGame.g_tButtonInfo.buttonGroup = {}
        GlobalGame.g_tButtonInfo.buttonSort2 = {}

        local lastIndex = -999
        for i,v in pairs(GDatatab_button_info) do
            if v.id > lastIndex then
                lastIndex = v.id
            end
        end
        local lastIndex = -999
        for i,v in pairs(GDatatab_button_info) do
            if v.id > lastIndex then
                lastIndex = v.id
            end
        end
        for id=1, count do
            
            local button = GDatatab_button_info["id_"..id]
            if button == nil then
                if id == count then
                    button = GDatatab_button_info["id_"..lastIndex]
                elseif id == count - 1 then
                    button = GDatatab_button_info["id_"..lastIndex-1]
                elseif id == count - 2 then
                    button = GDatatab_button_info["id_"..lastIndex-1]
                elseif id == count - 2 then
                    button = GDatatab_button_info["id_"..lastIndex-2] or GDatatab_button_info["id_"..lastIndex2-1]
                elseif id == count - 3 then
                    button = GDatatab_button_info["id_"..lastIndex-3] or GDatatab_button_info["id_"..lastIndex2-2]
                elseif id == count - 4 then
                    button = GDatatab_button_info["id_"..lastIndex-4] or GDatatab_button_info["id_"..lastIndex2-3]

                end
            end

            WZLog("GlobalGame:setButtonState1", id, Serialize(button))
            GlobalGame.g_tButtonInfo.buttonId[id] = button.id
            GlobalGame.g_tButtonInfo.buttonName[id] = button.name
            GlobalGame.g_tButtonInfo.buttonType[id] = button.type
            GlobalGame.g_tButtonInfo.buttonTips[id] = button.feedback_info
            GlobalGame.g_tButtonInfo.buttonStatus1Level[id] = button.show_level
            GlobalGame.g_tButtonInfo.buttonStatus3Level[id] = button.open_level
            GlobalGame.g_tButtonInfo.buttonSort[id] = button.sort
            GlobalGame.g_tButtonInfo.buttonChannel[id] = button.channel
            GlobalGame.g_tButtonInfo.buttonGroup[id] = button.group
            GlobalGame.g_tButtonInfo.buttonSort2[id] = button.sort2
        end
    end
    WZLog("GlobalGame:setButtonState2", Serialize(GDatatab_button_info), "GlobalGame.g_tButtonInfo", Serialize(GlobalGame.g_tButtonInfo))
end

--@brief 战斗全局事件
function GlobalGame:getBattleEventDispatcher()
    if not GlobalGame.g_tBattleEvent then
        GlobalGame.g_tBattleEvent = EventDispatcher:New()
    end
    return GlobalGame.g_tBattleEvent
end

--@brief 全局事件
function GlobalGame:getGameEventDispathcer()
    if not GlobalGame.g_tGameEvent then
        GlobalGame.g_tGameEvent = EventDispatcher:New()
    end
    return GlobalGame.g_tGameEvent
end


--@brief    存储需要加密的数据信息
--@param    sKey 存储键
--@param    sValue 存储的数据
function GlobalGame:putSecretData(sKey,sValue)
    if sKey == nil then return end
    if sValue == nil then 
        self.g_tSecretData[sKey] = sValue
        return
    end
    local vBytes = WGameCmUtil:EnCrypt(sValue, ENCRYPT_KEY)
    local sData = WGameCmUtil:transformBytesToString(vBytes)
    self.g_tSecretData[sKey] = sData
end

--@brief    获取存储在加密信息存储器的数据
--@param    sKey 存储键
--@return   #1 返回解密后的数据信息
function GlobalGame:getSecretData(sKey)
    if sKey == nil then return nil end
    if self.g_tSecretData[sKey] == nil then return nil end
    local value = self.g_tSecretData[sKey]
    local vecData = WGameCmUtil:transformStringToBytes(value)
    local decValue = WGameCmUtil:DeCrypt(vecData, ENCRYPT_KEY)
    return decValue
end

--@brief    获取存储在加密信息存储器的数据
--@param    sKey 存储键
--@return   #1 返回解密后的数据信息并且转换成了数字类型
function GlobalGame:getSecretNumberData(sKey)
    local sValue = self:getSecretData(sKey)
    if sValue == nil then return nil end 
    return tonumber(sValue)
end

--@brief    获取大逃亡时间
function GlobalGame:getEscapeInfo()
    
    local overTime = os.time() - GlobalGame.g_nEscapeReceiveTime
    local surplusTime = GlobalGame.g_nEscapeSurplusTime - overTime
    if GlobalGame.g_nEscapeState == -1 then
        overTime = -1
        surplusTime = -1
    end
    WZLog("GlobalGame:getEscapeInfo",  tostring(GlobalGame.g_nEscapeState), overTime, surplusTime)
    return surplusTime, GlobalGame.g_nEscapeState
end