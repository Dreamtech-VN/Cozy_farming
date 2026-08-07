--CacheCenterData.lua
--@brief	客户端缓存中心
--@date		2014/8/20
--@author	刘凑贵
--@note     定义客户端缓存中心数据

CacheCenter = 
{
	m_tPlayerInfo = nil,           --玩家背包基础信息
	m_tPlayerItemList = nil,       --解析后的玩家背包物品列表信息
	m_tPlayerPetInfo = {},         --玩家宠物信息
	m_tMounts = nil,                --坐骑信息
	m_tShopItems = nil,            --商城商品列表信息
	m_tShopItemsSended = nil,      --请求商城商品列表协议已发送
	m_tShopItemsCallBack = {},     --商城刷新列表
	m_tLotteryItems = nil,         --爱心许愿物品列表
	m_tGiftList = nil,             --祝福礼盒物品列表
	m_tGuildInfo = nil,			   --公会信息
	m_tLeagueInfo = nil,		   --联赛信息
	m_tAdMessage = nil,			   --广告信息

	m_tUpdatePlayerItem = nil,     --更新背包物品信息

	m_tWeaponList = nil,      --武器列表
	m_tDecorationList = nil,  --装扮列表
	m_tOtherItemList = nil,   --其他类物品列表
	m_tMaterialList = nil,   --材料列表
	m_tCardItemList = nil,   --卡牌物品列表
	m_tCardChipList = nil,   --卡牌碎片物品列表
	m_tMoneyList = nil,   --玩家财富列表，即钻石、金币、红钻等
	m_tEquipmentList = nil, --玩家身上已装备的物品列表

	m_tActiveInfoList = nil, --活跃系统里的缓存信息

	m_tPlayerInfoObservers = nil, --玩家数据改变的监听者
	m_tPlayerItemObservers = nil, --玩家物品数据改变的监听者
	m_tPlayerPetInfoObservers = nil, --玩家宠物数据改变的监听者
	m_tMoneyObservers = nil, --钻石、金币数据改变的监听者
	m_tWeaponObservers = nil, --武器数据改版的监听者
	m_tDecorationObservers = nil, --装扮数据改版的监听者
	m_tPetEquitObservers = nil, --宠物装备数据改版的监听者
	m_tOtherObservers = nil, --其他数据改版的监听者
	m_tMaterialObservers = nil, --材料数据改版的监听者
	m_tFriendListObservers = nil, --好友列表(结婚，邮件，私聊)数据回调函数
	
	m_tMailList = nil,--邮件列表
	m_nMailMark= 0, --邮件标识
	m_tFriend = nil,
	m_tCurrentFriends = nil,--当前通过审批的好友列表
	m_nCityFriendsMark = 0 ,--有新的好友审批信息
	m_tFriendList = nil,
	m_nAppMark = 0,
	m_nDailyMark = 0,
	m_nInviteMark = 0, 		--邀请任务有可领取的任务
    
    m_tSingleCopyData = nil,    --单人副本数据
    m_tMultiCopyData = nil,     --组队副本数据
    m_tDailyCopyData = nil,     --日常副本数据
    m_tTowerCopyData = nil,      -- 爬塔副本
    
    m_tAchieList = nil,              --成就列表
	m_tAchieListCallBack = nil,      --成就列表回调
	m_tAchieListSender   = nil,      --成就列表请求协议
	m_tAchieNotViewList  = nil, 	 --成就表不显示出来部分

	m_tDesiList = nil,              --称号列表
	m_tDesiListCallBack = nil,      --称号列表回调
	m_tDesiListSender   = nil,      --称号列表请求协议

	m_sDesignationShow  = nil,      --显示的称号
	m_sDeShowObservers  = nil,      --显示的称号面板坚挺者

    m_tRankListInfo = nil,          --排行榜
	m_tMasterInfo = nil,			--师徒信息

	m_tGameParam = nil,             --游戏参数
	m_nDynamic = 0,
	m_bOneKeyOperator_Friends = false , --好友动态进行一键操作

	m_tRedPoint = {},                -- 红点信息
    m_bInitRedPointFlag = false,
	
	m_tActivityItemRedDotList = nil , --活动列表红点信息
	m_tNextDay = nil, 				 --跨天状态
	m_bSignItemEnter = false,       --签到是否需要换行
	m_tTaskRecordingArrays = {}, 	--任务状态记录表
	m_tSignCacheData = {},           --签到缓存数据

	m_tMyRankListInfo = nil, 		--我的排行榜数据

	m_nUpdatePlayerItem = 0,		--推送缓存调用_updatePlayerItemData函数的数量
	m_nUpdatePlayerInfo = 0,		--推送缓存调用_updatePlayerInfoData函数的数量
	m_nUpdating = false,			 --是否正在更新观察者

    m_tRedPointInfo = {},            -- 红点信息
    m_nPlayerLevel = 0,              -- 玩家等级，战斗前保存一次，方便战斗结算动画
    m_nPlayerExp = 0,              -- 玩家经验，战斗前保存一次，方便战斗结算动画

    m_tVipList = nil,    -- 充值列表
    m_nLeftAchiePoints = nil, --当前剩余成就点
    m_tStarSoulList = nil, 	--星魂列表
    m_bStopUpdateNewData = nil ,  --用于标记如果有信息更新是否及时显示
    m_tPlayerSkill = {} ,   	--玩家已装备的道具
    m_tSkillList = {},       	--玩家道具列表
    m_tWelfareItemRedDotList = nil , --福利列表红点信息
    m_tInviteFriends = nil, 	--邀请码好友列表
    m_tInviteTaskList = nil, 	--邀请码任务列表
    m_sMyInviteCode = nil, 		--自己的邀请码
    m_nInviteState = nil, 		--邀请状态1：已提交过邀请码；0：未提交过邀请码
	m_serverInfo = {},
	m_fyberInfo = {},       --东南亚广告信息数据     
	m_serverInfo = {},
	m_tApplyBestFriendId = nil, --密友申请请求ID
	m_tGuildWarTargetData = nil, 	--公会战目标数据

	m_tChatCache = {},   --保存服务器推过来的私聊缓存

	m_tAreanAddInfo = {addValue = {},timeValue = {},timeType = {}}, --保存竞技加成卡信息
	m_tPromiseData 	= nil,
	m_tRunePlaceIds = {},
	m_tRuneItemId = {},

	m_nBuyTabooCoinTimes = 0, --购买骰子次数
	m_nTabooCoinNum = 0,	--骰子数量
	m_tTabooCoinLimitNum = nil, --最大数量
	m_nTabooBoxCountDown = nil, --宝箱倒计时
	m_tYearActivityItemRedDotList = nil , --周年活动列表红点信息
	m_nDesignationShowId  = nil,      --显示的称号ID

	m_tSkill = nil,		--玩家技能列表
	m_bIsSkillRed = nil, --是否技能红点
	m_bFundFinish = true,
	m_tNewUserPackageList = nil, --新手定推礼包列表
	m_tFootMarkList = nil, 	--足迹列表
	m_nUseFootMarkId = nil, --正在使用的足迹ID
	m_tApartmentRedDotList = nil, --代言人活動紅點
	m_tLimitPackageList = nil,
	m_tDressSuit = nil,	  --保存的套装
	m_tDressSuitObservers = nil, 	--套装改变的监听者
	m_tPetEquipSchemeData = nil,		--宠物装备选择方案
	m_tPetEquipSchemeObservers = nil,		--宠物装备改变的监听者
	m_tFriendBlacklist = {}, 		--好友黑名单
	m_tPlayerHomeItemList = nil, 	--玩家小家背包数据
	m_nUpdatePlayerHomeItem = 0, 	--推送缓存调用_updatePlayerHomeItemData函数的数量
	m_tPlayerHomeItemObservers = nil, --玩家小家物品数据改变的监听者 
	m_tKidDecorationObservers = nil, --小孩装扮数据改变监听者
	m_tBackActivityRedDotList = nil , --回流活动红点信息
	m_tFreecaRedDotList = nil,	--福利卡红点信息
	m_tMarkCoinData = nil, 	--纪念币充值数据
	m_tProfessionData = nil, --职业数据
	m_tSkillSuit = nil,	  --保存的技能方案
	m_tSkillSuitObservers = nil, 	--技能方案改变的监听者
	m_tSkinStatus = {}, 	--皮肤领取状态
	m_tAssistSkill = {}, 	--玩家的辅助技能
	m_bIsAssistSkillRed = nil, 	--是否辅助技能有红点
	m_tPlayerLibraryItemList = {}, --玩家图鉴
	m_tPlayerLibraryInfo = {}, --图鉴等级和经验
	m_tFiveTypePackageList = nil, --5类型定推礼包列表
	m_tDefaultShapeBigSkill = nil, 		--默认皮肤技能列表
	m_tShapeBigSkillList = {},			--皮肤技能列表
	m_tStarsSpecialAttr = nil,			--足迹星辰特殊属性
	m_tAllFlowerpot = nil, 				--所有配置的花盆
	m_tPlayerFootItemList = nil, 		--所有可激活足迹物品
	m_tPlayerMountItemList = nil, 		--所有可激活坐骑物品
	m_tUnionInfo = nil, 				--联盟信息
	m_tHavedAdvanceDressIds = nil, 		--已进阶的时装套装Id(对应表GDatatab_enchanting中的Id)
	m_tConfigAdvanceDressIds = nil, 	--配置的可进阶的时装套装Id(对应表GDatatab_enchanting中的Id)
	m_tHavedAdvanceWingIds = nil, 		--已进阶的翅膀Id(对应表GDatatab_enchanting中的Id)
	m_tConfigAdvanceWingIds = nil, 		--配置的可进阶的翅膀Id(对应表GDatatab_enchanting中的Id)
}

UPDATESINGLECOPYDATANOTIFICATION = "UpdateSingleCopyDataNotification" --单人副本数据更新通知
UPDATEMULTICOPYDATANOTIFICATION = "UpdateMultiCopyDataNotification" --组队副本数据更新通知
UPDATEDAILYCOPYDATANOTIFICATION = "UpdateDailyCopyDataNotification" --日常副本数据更新通知
UPDATETOWERCOPYDATANOTIFICATION = "UpdateTowerCopyDataNotification" --爬塔副本数据更新通知
UPDATEDOUBLETOWERCOPYDATANOTIFICATION = "UpdateDoubleTowerCopyDataNotification" --双人爬塔副本数据更新通知

-------------------------------------公有方法模块Begin--------------------------------------
--@brief	设置背包玩家缓存信息
function CacheCenter:setPlayerInfo(id, name, sex, title, guildName, position, level, exp, maxExp, vipLevel, winNum, playNum, fighting, mateName, signature, vigor, 
	maxVigor, guildId, property, strongSuitId, starSuitId, mosaicSuitId, petMessage, mountsMessage, fashionProperty, fashionFighting, tournamentLevel, 
	tournamentIntegral, itemSuitId, itemSuitNum, segmentLevel, totemLevel, lovelLevel, loveSkill, moralityLevel, masterName, vipExp, segmentExp, rankMatchMessage, 
	guildLevel, buyTimesPS, headScul, snsValue, starsoulId, spaceSex, giftNum, allMountsMessage, marryFlag, teamId, prayInfo, xlId, xlExp, shapeId, shapeLevel, 
	showShape, awakeSoulLevel, awakeStep, itemSuitId2, itemSuitNum2, homeLevel, sheerLuxury, footMark, shapeSkillId, awakeSkillId, runeItemId, runeItemNum, 
	obtainNum, cardMessage, bgId, showMes, coupleMes, childMes, careBuffProp, careToday, headSculStatus, thumbUpNum, badgeInfo, helpTime, assistTime, professionId, 
	myMaxSegmentLevel, masterId, shapeBigSkillId, awakeAssistTime, ylJsonInfo, honourPoint, itemSuitStrongNum, itemSuitStarNum, shape,shapeFetterProperties, 
	soulInfo, rpIds, wedBufLevel, wedBufTime, loveSkill2, professionAttr1, professionAttr2, vipMedal, phantomEquipment, chatShortcut,pastureId, spriteStoneFp,
	spriteStoneInfo, pupliInfo, myMoralityLevel, footMarkCityIds, footMarkCityTimes, levelBreachId, useShapeGroupId, useShapeGroupAdvanceLevel, blueVipInfo, petEquip, 
	runeResonateAdd, cardSoulBuffAdd, guildBaptismAdd, chatShield, zlsJsonInfo, praiseRewardStatus, leagueInfo)
	ADINDEX = 999999

	self.m_tPlayerInfo = {}
	self.m_tPlayerInfo.id = id --Id
	self.m_tPlayerInfo.name = name  --名称
	self.m_tPlayerInfo.sex = sex  --性别 0:男 1:女
	self.m_tPlayerInfo.title = title --称号
	self.m_tPlayerInfo.guildName = guildName  --公会名称
	self.m_tPlayerInfo.position = position  --公会职务
	self.m_tPlayerInfo.level = GlobalGame:checkGlobalPlayerLevel(level)  --等级
	self.m_tPlayerInfo.exp = exp  --当前经验
	self.m_tPlayerInfo.maxExp = maxExp  --该等级升级所需经验
	self.m_tPlayerInfo.rank = rank  --军衔
	self.m_tPlayerInfo.vipLevel = vipLevel   --vip等级0表示非VIP
	self.m_tPlayerInfo.winNum = winNum  --胜利次数
	self.m_tPlayerInfo.playNum = playNum  --游戏次数
	self.m_tPlayerInfo.zsLevel = zsLevel  --0:表示没有转生，1：表示玩家已经转生
	self.m_tPlayerInfo.fighting = fighting  --战斗力

	self.m_tPlayerInfo.force = 0  --力量
	self.m_tPlayerInfo.hp = 0	--生命
	self.m_tPlayerInfo.armor = 0  --护甲
	self.m_tPlayerInfo.attack = 0--攻击
	self.m_tPlayerInfo.agility = 0--敏捷
	self.m_tPlayerInfo.defend = 0--防御
	self.m_tPlayerInfo.physique = 0 --体质
	self.m_tPlayerInfo.critRate = 0  --暴击
	self.m_tPlayerInfo.injuryFree = 0  --免伤
	self.m_tPlayerInfo.reduceCrit = 0  --免暴
	self.m_tPlayerInfo.physical = 0 --体力
	self.m_tPlayerInfo.wreckDefense = 0 --破防
	self.m_tPlayerInfo.luck = 0 --幸运
	self.m_tPlayerInfo.range = 0 --范围

	self.m_tPlayerInfo.age = age  --年龄
	self.m_tPlayerInfo.mateName = mateName  --伴侣名称
	self.m_tPlayerInfo.signature = signature  --个性签名
	self.m_tPlayerInfo.constellation = constellation  --星座
	self.m_tPlayerInfo.pictureUrl = pictureUrl  --头像地址
	self.m_tPlayerInfo.pendingUrl = pendingUrl  --待定头像地址
	self.m_tPlayerInfo.cardSeatNum = cardSeatNum  --卡牌位置数量
	self.m_tPlayerInfo.buff = buff  --玩家生效的BUFF。格式：["exp","life"]
	self.m_tPlayerInfo.vigor = vigor  --当前活力值
	self.m_tPlayerInfo.maxVigor = maxVigor  --最大活力值
	self.m_tPlayerInfo.starSoulLeve = starSoulLeve  --星魂等级
	self.m_tPlayerInfo.soulDot = soulDot  --当前星点
	self.m_tPlayerInfo.useLimitNumber = useLimitNumber --使用勋章上限数
	self.m_tPlayerInfo.useTodayNumber = useTodayNumber --今日还可以使用勋章数
	self.m_tPlayerInfo.practiceAttributeExp = practiceAttributeExp -- 属性对应的经验值
	self.m_tPlayerInfo.practiceLeve = practiceLeve -- 属性等级
	self.m_tPlayerInfo.seniorMedlNumber = seniorMedlNumber --高级徽章数
	self.m_tPlayerInfo.weibo = weibo --微博id,微博Icon
	self.m_tPlayerInfo.guildId = guildId --公会id
    self.m_tPlayerInfo.singleMapId = singleMapId --开放副本ID
    self.m_tPlayerInfo.property = property --属性字符串
    self.m_tPlayerInfo.strongSuitId = strongSuitId --强化套id
    self.m_tPlayerInfo.starSuitId = starSuitId --升星套id
    self.m_tPlayerInfo.mosaicSuitId = mosaicSuitId --镶嵌套id
	self.m_tPlayerInfo.fashionProperty = fashionProperty--时装属性
	self.m_tPlayerInfo.fashionFighting = fashionFighting--时装战斗力
	self.m_tPlayerInfo.tournamentLevel = tournamentLevel--竞技等级
	GlobalGame.g_tPlayerInfo.nAthLevel = tournamentLevel
	self.m_tPlayerInfo.tournamentIntegral = tournamentIntegral--竞技积分
	self.m_tPlayerInfo.itemSuitId = itemSuitId--套装id
	self.m_tPlayerInfo.itemSuitNum = itemSuitNum--套装数量
	self.m_tPlayerInfo.petMessage = petMessage
	self.m_tPlayerInfo.mountsMessage = mountsMessage
	self.m_tPlayerInfo.segmentLevel = segmentLevel       --排位赛等级 
	GlobalGame.g_tPlayerInfo.nPvpRankLevel = segmentLevel
	self.m_tPlayerInfo.totemLevel = totemLevel
	self.m_tPlayerInfo.loveLevel = lovelLevel
	self.m_tPlayerInfo.loveSkill = loveSkill
	self.m_tPlayerInfo.moralityLevel = moralityLevel
	self.m_tPlayerInfo.masterName = masterName
	self.m_tPlayerInfo.vipExp = vipExp
	self.m_tPlayerInfo.segmentExp = segmentExp
	self.m_tPlayerInfo.rankMatchMessage = rankMatchMessage
	self.m_tPlayerInfo.guildLevel = guildLevel
	self.m_tPlayerInfo.buyTimesPS = buyTimesPS
	self.m_tPlayerInfo.headScul = headScul
	self.m_tPlayerInfo.snsValue = snsValue
	self.m_tPlayerInfo.starsoulId = starsoulId
	self.m_tPlayerInfo.spaceSex = spaceSex
	self.m_tPlayerInfo.giftNum = giftNum
	self.m_tPlayerInfo.allMountsMessage = VectorToTable(allMountsMessage)
	self.m_tPlayerInfo.marryFlag = marryFlag or 0
	local serverName,serverId = IPDhttpServer:getCurServerName()
	WZLog("CacheCenter:setPlayerInfo one", showShape, serverName,serverId, exp, maxExp)
	self.m_tPlayerInfo.serverId = serverId
	self.m_tPlayerInfo.teamId = teamId
	self.m_tPlayerInfo.prayInfo = prayInfo
	self.m_tPlayerInfo.xlId = VectorToTable(xlId)
	self.m_tPlayerInfo.xlExp = VectorToTable(xlExp)
	self.m_tPlayerInfo.shapeId = shapeId
	self.m_tPlayerInfo.shapeLevel = shapeLevel
	self.m_tPlayerInfo.showShape = showShape
	self.m_tPlayerInfo.awakeSoulLevel = awakeSoulLevel
	self.m_tPlayerInfo.awakeStep = awakeStep
	self.m_tPlayerInfo.itemSuitId2 = itemSuitId2
	self.m_tPlayerInfo.itemSuitNum2 = itemSuitNum2
	self.m_tPlayerInfo.homeLevel = homeLevel
	self.m_tPlayerInfo.sheerLuxury = sheerLuxury
--	self.m_tPlayerInfo.footMark = VectorToTable(footMark) --179vn版本，数据太大，通过102-5协议推送allFootmark获取
	self.m_tPlayerInfo.shapeSkillId = shapeSkillId
	self.m_tPlayerInfo.awakeSkillId = awakeSkillId
	self.m_tPlayerInfo.runeItemId = VectorToTable(runeItemId)
	self.m_tPlayerInfo.runeItemNum = VectorToTable(runeItemNum)
	self.m_tPlayerInfo.obtainNum = obtainNum
	self.m_tPlayerInfo.cardMessage = cardMessage
	self.m_tPlayerInfo.background = bgId
	self.m_tPlayerInfo.showMes = showMes
	self.m_tPlayerInfo.coupleMes = coupleMes
	self.m_tPlayerInfo.childMes = childMes
	self.m_tPlayerInfo.careBuffProp = careBuffProp
	self.m_tPlayerInfo.careToday = careToday
	self.m_tPlayerInfo.headSculStatus = headSculStatus
	self.m_tPlayerInfo.thumbUpNum = thumbUpNum
	self.m_tPlayerInfo.badgeInfo = badgeInfo
	self.m_tPlayerInfo.helpTime = helpTime
	self.m_tPlayerInfo.assistTime = assistTime
	self.m_tPlayerInfo.professionId = professionId
	self.m_tPlayerInfo.myMaxSegmentLevel = myMaxSegmentLevel
	self.m_tPlayerInfo.masterId = masterId
	self.m_tPlayerInfo.shapeBigSkillId = shapeBigSkillId
	self.m_tPlayerInfo.awakeAssistTime = awakeAssistTime
	self.m_tPlayerInfo.ylJsonInfo = ylJsonInfo 
	self.m_tPlayerInfo.honourPoint = honourPoint --荣誉值

	self.m_tPlayerInfo.wedBufLevel = wedBufLevel
	self.m_tPlayerInfo.wedBufTime = wedBufTime
	self.m_tPlayerInfo.loveSkill2 = loveSkill2

	self.m_tPlayerInfo.itemSuitStrongNum = itemSuitStrongNum -- 套装强化数量
	self.m_tPlayerInfo.ItemSuitStarNum = ItemSuitStarNum -- 套装升星数量
	self.m_tPlayerInfo.shape = VectorToTable(shape)
	self.m_tPlayerInfo.shapeFetterProperties = shapeFetterProperties
	self.m_tPlayerInfo.soulInfoJson = soulInfo
	self.m_tPlayerInfo.rpIds = VectorToTable(rpIds)
	self.m_tPlayerInfo.professionAttr1 = professionAttr1
	self.m_tPlayerInfo.professionAttr2 = professionAttr2
	self.m_tPlayerInfo.vipMedal = vipMedal
	self.m_tPlayerInfo.phantomEquipment = phantomEquipment
	self.m_tPlayerInfo.chatShortcut = chatShortcut
	self.m_tPlayerInfo.pastureId = pastureId
	self.m_tPlayerInfo.spriteStoneFp = spriteStoneFp
	self.m_tPlayerInfo.spriteStoneInfo = VectorToTable(spriteStoneInfo)
	self.m_tPlayerInfo.pupliInfo = pupliInfo
	self.m_tPlayerInfo.myMoralityLevel = myMoralityLevel
	self.m_tPlayerInfo.footMarkCityIds = VectorToTable(footMarkCityIds)
	self.m_tPlayerInfo.footMarkCityTimes = VectorToTable(footMarkCityTimes)
	self.m_tPlayerInfo.levelBreachId = levelBreachId or 1
	self.m_tPlayerInfo.useShapeGroupId = useShapeGroupId or 0
	self.m_tPlayerInfo.useShapeGroupAdvanceLevel = useShapeGroupAdvanceLevel or 0
	self.m_tPlayerInfo.blueVipInfo = blueVipInfo or "" --'{"is_blue_vip":true,"is_blue_year_vip":true,"blue_vip_level":0,"is_super_blue_vip":true}'
	self.m_tPlayerInfo.petEquip = VectorToTable(petEquip)

	self.m_tPlayerInfo.runeResonateAdd = runeResonateAdd
	self.m_tPlayerInfo.cardSoulBuffAdd = cardSoulBuffAdd
	self.m_tPlayerInfo.guildBaptismAdd = guildBaptismAdd
	self.m_tPlayerInfo.praiseRewardStatus = praiseRewardStatus or 0 --玩家商店评分奖励领取状态0:未领取；1已领取

	self.m_tPlayerInfo.chatShield = chatShield

	self.m_tPlayerInfo.zlsJsonInfo = zlsJsonInfo or ""
	self.m_tPlayerInfo.leagueInfo = leagueInfo or ""

	WZLog("符文加的等级特殊属性",rpIds:size(), blueVipInfo, levelBreachId, childMes, zlsJsonInfo, leagueInfo)
	-- WZLog("皮肤加成属性",shapeFetterProperties)
	-- if self.m_tPlayerInfo.shape ~= "" then
	-- 	self.m_tPlayerInfo.shape = json.decode(self.m_tPlayerInfo.shape)
	-- end
	WZLog("皮肤数量",Serialize(self.m_tPlayerInfo.shape))
	if self.m_tPlayerInfo.coupleMes and self.m_tPlayerInfo.coupleMes ~= "" then 
		local tIdList = SplitStringWithSeparator(self.m_tPlayerInfo.coupleMes, "|", nil, true)
		if tIdList and tIdList[8] then 
			self.m_tPlayerInfo.mateServerId = tIdList[8]
		end
	end

	if self.m_tPlayerInfo.soulInfoJson ~= "" then 
		local tempSoulInfo = json.decode(self.m_tPlayerInfo.soulInfoJson)
		self.m_tPlayerInfo.soulInfo = tempSoulInfo.sulInfo
	end

    if self.m_tPlayerInfo.petMessage ~= "" then
        self.m_tPlayerInfo.petInfo = json.decode(self.m_tPlayerInfo.petMessage)
    end
    if self.m_tPlayerInfo.mountsMessage ~= "" then
        self.m_tPlayerInfo.mountsInfo = json.decode(self.m_tPlayerInfo.mountsMessage)
        if GDatatab_mounts["id_"..self.m_tPlayerInfo.mountsInfo.mountsId] then
	        self.m_tPlayerInfo.mountsId = GDatatab_item["id_"..GDatatab_mounts["id_"..self.m_tPlayerInfo.mountsInfo.mountsId].item_id].animation_index_code
	        self.m_tPlayerInfo.mountsType = GDatatab_item["id_"..GDatatab_mounts["id_"..self.m_tPlayerInfo.mountsInfo.mountsId].item_id].sub_type
	    end
    end

    if tonumber(ProjConfig:getChannelId()) == 1118 then 
	    if self.m_tPlayerInfo.blueVipInfo ~= "" then 
	    	self.m_tPlayerInfo.qqHallData = json.decode(self.m_tPlayerInfo.blueVipInfo)
	    end
	end

    if self.m_tPlayerInfo.zlsJsonInfo ~= "" then
        self.m_tPlayerInfo.zlsJsonInfo = json.decode(self.m_tPlayerInfo.zlsJsonInfo)
    end

    if self.m_tPlayerInfo.leagueInfo ~= "" then
        self.m_tPlayerInfo.unionInfo = json.decode(self.m_tPlayerInfo.leagueInfo)
    end

	GlobalGame.g_tInfo.m_nFighting = 0

	local tProperty = json.decode(property)
	for k,v in pairs(tProperty) do
		self.m_tPlayerInfo[ATTR_PARAM_NAME[tonumber(k)]] = v
	end
	self:upgradePlayerPro(CopyTable(self.m_tPlayerInfo))

	if SceneBattle.m_root == nil then
		self:_updatePlayerInfoData()
	end
    WZLog("CacheCenter:setPlayerInfo", masterName, type(masterName), ylJsonInfo, self.m_tPlayerInfo.shapeBigSkillId, awakeAssistTime)
end

--@brief	设置背包玩家物品列表缓存信息
function CacheCenter:setPlayerItems(itemId, lastNum, lastTime, isUse, data, playerItemId, disappearTime, color, startTag, endTag)
	if (startTag == 1 and endTag == 0) or (startTag == 1 and endTag == 1) then --开始的时候
		self.m_tPlayerItemList = {}
		self.m_tWeaponList = {}
		self.m_tDecorationList = {}
		self.m_tOtherItemList = {}
		self.m_tMaterialList = {}
		self.m_tCardItemList = {}
		self.m_tCardChipList = {}
		self.m_tEquipmentList = {}
		self.m_tPlayerFootItemList = {}
		self.m_tPlayerMountItemList = {}
	end
	local mainType = 0

	local receiveTime = SystemTime:getServerTime()
	for i=0,itemId:size() - 1 do
		local tTempItem = {}
		tTempItem.id = itemId:get(i)
		tTempItem.lastTime = lastTime:get(i)
		tTempItem.lastNum = tonumber(lastNum:get(i))
		tTempItem.isUse = isUse:get(i)
		tTempItem.playerItemId = playerItemId:get(i)
		tTempItem.disappearTime = disappearTime:get(i)
		tTempItem.color = color:get(i)
		tTempItem.receiveTime = receiveTime - 2

		--tTempItem.lastTime = 3300

		--物品基础数据
		local key = "id_"..itemId:get(i)
		if GDatatab_item[key] then
			tTempItem.basicInfo = CopyTable(GDatatab_item[key])
			if tTempItem.basicInfo ~= nil then
				tTempItem.maintype = tTempItem.basicInfo.main_type
				tTempItem.subtype = tTempItem.basicInfo.sub_type

				if tTempItem.maintype ~= 42 then
					if tTempItem.basicInfo.use_type == 0 then--num 
						if tTempItem.maintype ~= 4 then
							tTempItem.lastTime = tTempItem.lastNum
						else
							tTempItem.lastNum = 1
						end
					else
						tTempItem.lastNum = tTempItem.lastTime
					end
				end
			end
			
			--物品附加数据
			tTempItem.extraInfo = json.decode(data:get(i)) 
			if tTempItem.maintype == 5 then
				local nFighting = caculateClothesFighting(tTempItem.extraInfo)
				tTempItem.extraInfo.fighting = nFighting
			end
			if tTempItem.maintype == 4 and (tTempItem.subtype == 0 or tTempItem.subtype == 1) and tTempItem.isUse ~= true then
				tTempItem.extraInfo.weaponskill = nil
			end
			if tTempItem.maintype == 43 then --宠物装备
				if tTempItem.extraInfo.randAttr then
					tTempItem.extraInfo.randAttr = json.decode(tTempItem.extraInfo.randAttr)
				end
			end

			if tTempItem.maintype == 23 then 
				table.insert(self.m_tPlayerFootItemList, tTempItem)
			elseif tTempItem.maintype == 2 and tTempItem.subtype == 11 then 
				table.insert(self.m_tPlayerMountItemList, tTempItem)
			end
		end
		table.insert(self.m_tPlayerItemList, tTempItem)
	end

	--保存系统时间
	SETITEMSTIME = os.time()

	if (startTag == 0 and endTag == 1) or (startTag == 1 and endTag == 1) then --结束的时候
		--初始化货币缓存
		self:_setMoneyList()
	end
	--通知监测者物品列表数据更新
	if SceneBattle.m_root == nil then
		self:_receivePlayerItemData()
	end

	CacheCenter:updateStrengthenRed()
end

--@brief	设置更新背包玩家信息
function CacheCenter:setUpdatePlayer(key,value)
	self.m_tUpdatePlayer = {}
	self.m_tUpdatePlayer.key = VectorToTable(key)      --字段
	self.m_tUpdatePlayer.value = VectorToTable(value)  --值
end

--@brief    清空玩家宠物缓存信息
function CacheCenter:clearPlayerPetInfo()
	if self.m_tPlayerPetInfo ~= nil or #self.m_tPlayerPetInfo >0 then
		self.m_tPlayerPetInfo = {}
	end
end

--@brief	设置玩家宠物信息
function CacheCenter:setPlayerPetInfo(itemId, name, icon,animation,advancedLevel,upgradeLevel ,property,giftSkill, commonSkill1, commonSkill2, isInUsed, playerPetId,num,petExp,fighting,birthSkill,skill, petSkinItemId, fetterStatus)
	WZLog("CacheCenter:setPlayerPetInfo")
	if self.m_tPlayerPetInfo == nil then
		return
	end

	for i=1,#(self.m_tPlayerPetInfo) do
		if self.m_tPlayerPetInfo[i].playerPetId == playerPetId then
			self.m_tPlayerPetInfo[i].itemId = itemId
			self.m_tPlayerPetInfo[i].name = GetPetNameById(itemId,advancedLevel)
			self.m_tPlayerPetInfo[i].icon = icon
			self.m_tPlayerPetInfo[i].animation = animation
			self.m_tPlayerPetInfo[i].advancedLevel = advancedLevel
			self.m_tPlayerPetInfo[i].upgradeLevel = upgradeLevel
			self.m_tPlayerPetInfo[i].property = property
			self.m_tPlayerPetInfo[i].giftSkill = giftSkill
			self.m_tPlayerPetInfo[i].commonSkill1 = commonSkill1
			self.m_tPlayerPetInfo[i].commonSkill2 = commonSkill2
			self.m_tPlayerPetInfo[i].isInUsed = isInUsed
			self.m_tPlayerPetInfo[i].num = num
			self.m_tPlayerPetInfo[i].petExp = petExp
            self.m_tPlayerPetInfo[i].fighting = fighting
            self.m_tPlayerPetInfo[i].birthSkill = birthSkill
            self.m_tPlayerPetInfo[i].skill = skill
            self.m_tPlayerPetInfo[i].petSkinItemId = petSkinItemId
            self.m_tPlayerPetInfo[i].fetterStatus = fetterStatus
            break
		end
	end
end

--@brief	设置玩家宠物信息
function CacheCenter:setPlayerPetInfoBySkillId(playerPetId, skill)
	WZLog("CacheCenter:setPlayerPetInfoBySkillId")
	if self.m_tPlayerPetInfo == nil then
		return
	end
	for i=1,#(self.m_tPlayerPetInfo) do
		if self.m_tPlayerPetInfo[i].playerPetId == playerPetId then			
			self.m_tPlayerPetInfo[i].skill = skill
			break		
		end
	end
end

--@brief	设置商城商品列表信息
function CacheCenter:setShopItems(id, itemId, itemName, isHot, isNew, isVip, discount, mainType, moneyId, floorPrice, agingPrice, limitLeave,isOnSale,transaction,ad,newad, moneyId2, suit, isPromotion, discountTime, pageSum, pageCount)

	g_nShopCachePage = pageSum
	if g_tShopCacheCount == nil then
		g_tShopCacheCount = {}
	end
	if pageCount == 0 then
		self.m_tShopItems = {}
		WndShop.m_tPromotion = {}
		g_tShopCacheCount = {}
	end
	g_tShopCacheCount[pageCount+1] = 1

	-- self.m_tShopItems = {}
	-- WndShop.m_tPromotion = {}
	for i=0,id:size()-1 do 
--		WZLog("CacheCenter:setShopItems1",id:get(i),itemId:get(i),itemName:get(i),limitLeave:get(i),agingPrice:get(i),discount:get(i),mainType:get(i),isOnSale:get(i), suit:get(i))
		local tTempItem = {}
		tTempItem.id = id:get(i)
		tTempItem.shopItemId = itemId:get(i)
		tTempItem.shopItemName = itemName:get(i)
		tTempItem.isHot = isHot:get(i)
		tTempItem.isNew = isNew:get(i)
		tTempItem.isPrivilege = isVip:get(i)
		tTempItem.discount = discount:get(i)
		tTempItem.mainType = mainType:get(i)
		tTempItem.moneyId = moneyId:get(i)
		tTempItem.floorPrice = floorPrice:get(i)
		tTempItem.agingPrice = agingPrice:get(i)
		tTempItem.limitLeave = limitLeave:get(i)
		tTempItem.isOnSale = isOnSale:get(i)
		tTempItem.transaction = transaction:get(i)
		tTempItem.ad = ad:get(i)
		tTempItem.newad = newad:get(i)
		tTempItem.moneyId2 = moneyId2:get(i)
		tTempItem.suit = suit:get(i)
		tTempItem.isPromotion = isPromotion:get(i)
		tTempItem.discountTime = discountTime:get(i)

		if tTempItem.isPromotion then
			table.insert(WndShop.m_tPromotion, {initData=tTempItem})
		end
		--物品基础数据
		local key = "id_"..itemId:get(i)
		--tTempItem.basicInfo = CopyTable(GDatatab_item[key])
		tTempItem.basicInfo = GDatatab_item[key]
		if not tTempItem.basicInfo then
			WZLog("CacheCenter:setShopItems",key)
		end
		if tTempItem.basicInfo and tTempItem.basicInfo.main_type == 5 and tTempItem.isOnSale and tTempItem.isNew then
			WZLog("新品推荐剩余秒数",tTempItem.discountTime)
			WndShop.m_nNewTime = tTempItem.discountTime   	--新品推荐剩余秒数
		end

		if tTempItem.basicInfo ~= nil then
			table.insert(self.m_tShopItems,tTempItem)
		end
	end
	--WZLog("CacheCenter:setShopItems", Serialize(self.m_tShopItems))

	if pageSum == pageCount + 1 then
		if self.m_tShopItemsCallBack ~= nil and #self.m_tShopItemsCallBack >0 then
			for i=1,#self.m_tShopItemsCallBack do
				self.m_tShopItemsCallBack[i][1](self.m_tShopItemsCallBack[i][2],self.m_tShopItems)
			end
			self.m_tShopItemsCallBack = {}
		end
	end
end

--@brief	更新商城商品列表限购信息
function CacheCenter:setShopItemsLimitLeave(id, limitLeave)
    WZLog("--------------------get shop limit--------------------------------")
	for i=1,#id do
		for k,v in pairs(self.m_tShopItems) do
			if v.id == id[i] then
				v.limitLeave = limitLeave[i]
			end
		end
	end
end

--@brief 	商城新增商品
function CacheCenter:addNewGoods(id, itemId, itemNum, limitNum, totalLimitNum, costId, costNum, mainType, endTime)
	-- body
	if self.m_tShopItems == nil then self.m_tShopItems = {} end 

	WZLog("CacheCenter:addNewGoods",id, itemId, itemNum, limitNum, totalLimitNum, costId, costNum, mainType, endTime)
	local tTempItem = {}
	tTempItem.id = id
	tTempItem.shopItemId = itemId
	tTempItem.isHot = false
	tTempItem.isNew = false
	tTempItem.isPrivilege = false
	tTempItem.discount = 10000
	tTempItem.mainType = mainType
	tTempItem.moneyId = costId
	tTempItem.floorPrice = costNum
	local agPrice = {}
	agPrice["0"] = {}
	agPrice["0"][tostring(itemNum)] = tostring(costNum)
	tTempItem.agingPrice = json.encode(agPrice)
	tTempItem.limitLeave = limitNum
	tTempItem.isOnSale = true
	tTempItem.transaction = -1
	tTempItem.ad = ""
	tTempItem.newad = ""
	tTempItem.moneyId2 = totalLimitNum
	tTempItem.suit = 255
	tTempItem.isPromotion = false
	tTempItem.discountTime = endTime

	--物品基础数据
	local key = "id_"..itemId
	tTempItem.basicInfo = GDatatab_item[key]
	if not tTempItem.basicInfo then
		WZLog("CacheCenter:addNewGoods", key)
	end

	if tTempItem.basicInfo ~= nil and tTempItem.discountTime - SystemTime:getServerTime() > 0 then
		tTempItem.shopItemName = tTempItem.basicInfo.name
		table.insert(self.m_tShopItems,tTempItem)
	end

	WZLog("CacheCenter:addNewGoods", Serialize(tTempItem))

	WndShop:updateExchangeGoodsData(self.m_tShopItems)
	WndShop:reflashExchangeList()
end

--@brief 	更新兑换商品数据
--@param 	bUpdate: true执行刷新，false 不执行刷新
function CacheCenter:updateExchangeGoodsInfo(operateType, mallId, limitNum, bUpdate)
	-- body
	if operateType == 1 then 
		for i = 1, #self.m_tShopItems do
			if self.m_tShopItems[i].id == mallId then 
				self.m_tShopItems[i].limitLeave = limitNum
				break 
			end
		end
	elseif operateType == 2 then 
		for i = 1, #self.m_tShopItems do
			if self.m_tShopItems[i].id == mallId then 
				table.remove(self.m_tShopItems, i)
				break 
			end
		end
	end
	if bUpdate then 
		WndShop:updateExchangeGoodsData(self.m_tShopItems)
		WndShop:reflashExchangeList()
	end
end

--@brief  创建成就界面的数据列表
--@param  id          子分类成就属性id
--@param  status      领取按钮的状态
--@param  target      目标数量
--@param  complete    完成数量
function CacheCenter:setAchieList(id, status, count, target, complete, achievementPort)
	if achievementPort ~= nil then
		self.m_nLeftAchiePoints = achievementPort
	end
    
	-- body
	self.m_tAchieList = {}
	self.m_tAchieNotViewList = {}
	for key, value in pairs(GDatatab_achievement) do      --主分类归类
--        WZLog("p_id=1==",value.p_id,value.name)
    	if value.p_id == -1 and value.view == 1 then
    		local tem_tAchiementList = {p_id = value.p_id, id = value.id, name = value.name , view = value.view, target = 0, complete = 0 , childList = {} , statusNum = 0}
    		table.insert(self.m_tAchieList, tem_tAchiementList)
    	end
	end
	table.sort(self.m_tAchieList, sortMainAchiList)       --主分类排序
    WZLog("========子分类归类=======")
	for key,value in pairs(GDatatab_achievement) do       --子分类归类
--        WZLog("p_id=2==",key,value.p_id,value.name)
		if value.p_id ~= -1 then
 --           WZLog("id,name",key,value.id,value.name,value.view)
			if value.view == 1 then                     --view为显示的
				table.insert(self.m_tAchieList[value.p_id].childList, value)
			elseif value.view == 0 then
				table.insert(self.m_tAchieNotViewList, value)
			end
		end
	end
	
	for key, value in pairs(self.m_tAchieList) do      --主分类归类 删除不显示的
    	if value.view ~= 1 then
    		 table.remove(self.m_tAchieList, key)
    	end
	end 
	table.sort(self.m_tAchieList, sortMainAchiList)       --主分类排序

	local nTargetIndex = 0 			--索引条件目标值

	--添加后端闯过来的额外字段
	for i=1,#self.m_tAchieList do
		for j=1,#self.m_tAchieList[i].childList do
			nTargetIndex = 0
			for k=0,id:size()-1 do
				nTargetIndex = nTargetIndex + count:get(k)
				if self.m_tAchieList[i].childList[j].id  == id:get(k) then
					self.m_tAchieList[i].childList[j].count = count:get(k)
					self.m_tAchieList[i].childList[j].status = status:get(k)

					nTargetIndex = nTargetIndex - count:get(k)

					if self.m_tAchieList[i].childList[j].count > 0 then
						self.m_tAchieList[i].childList[j].target = target:get(nTargetIndex)
						self.m_tAchieList[i].childList[j].complete = complete:get(nTargetIndex)
						nTargetIndex = nTargetIndex + 1
						if self.m_tAchieList[i].childList[j].count == 2 then
							self.m_tAchieList[i].childList[j].target2 = target:get(nTargetIndex)
							self.m_tAchieList[i].childList[j].complete2 = complete:get(nTargetIndex)
							nTargetIndex = nTargetIndex + 1
						end
						--Modified by tianxiang_xu
						if self.m_tAchieList[i].childList[j].status == 1 or (self.m_tAchieList[i].childList[j].status == 2 and self.m_tAchieList[i].childList[j].reward ~= -1) then
							self.m_tAchieList[i].statusNum =  self.m_tAchieList[i].statusNum + 1
							g_bHaveRedPointForAchieEntry = true
						end
						--modified by Tianxiang_Xu
						if self.m_tAchieList[i].childList[j].count == 1 and (self.m_tAchieList[i].childList[j].complete >= self.m_tAchieList[i].childList[j].target or self.m_tAchieList[i].childList[j].status > 0 ) then
							self.m_tAchieList[i].complete = self.m_tAchieList[i].complete  + 1
						elseif self.m_tAchieList[i].childList[j].count == 2 and ((self.m_tAchieList[i].childList[j].complete >= self.m_tAchieList[i].childList[j].target and self.m_tAchieList[i].childList[j].complete2 >= self.m_tAchieList[i].childList[j].target2) or self.m_tAchieList[i].childList[j].status > 0) then
							self.m_tAchieList[i].complete = self.m_tAchieList[i].complete  + 1
						end
					end
					break
				end
			end
			self.m_tAchieList[i].target = #self.m_tAchieList[i].childList
		end
	end

	--添加后端闯过来的额外字段  不显示在成就列表，单要弹成就特效的成就
	for i=1,#self.m_tAchieNotViewList do
		nTargetIndex = 0
		for k=0,id:size()-1 do
			nTargetIndex = nTargetIndex + count:get(k)
			if self.m_tAchieNotViewList[i].id  == id:get(k) then
				self.m_tAchieNotViewList[i].count = count:get(k)
				self.m_tAchieNotViewList[i].status = status:get(k)

				nTargetIndex = nTargetIndex - count:get(k)

				--End
				if self.m_tAchieNotViewList[i].count > 0 then
					self.m_tAchieNotViewList[i].target = target:get(nTargetIndex)
					self.m_tAchieNotViewList[i].complete = complete:get(nTargetIndex)
					nTargetIndex = nTargetIndex + 1
					if self.m_tAchieNotViewList[i].count == 2 then
						self.m_tAchieNotViewList[i].target2 = target:get(nTargetIndex)
						self.m_tAchieNotViewList[i].complete2 = complete:get(nTargetIndex)
						nTargetIndex = nTargetIndex + 1
					end
					--modified by Tianxiang_Xu
					if self.m_tAchieNotViewList[i].count == 1 and (self.m_tAchieNotViewList[i].complete >= self.m_tAchieNotViewList[i].target or self.m_tAchieNotViewList[i].status > 0 ) then
						self.m_tAchieNotViewList[i].complete = self.m_tAchieNotViewList[i].complete  + 1
					elseif self.m_tAchieNotViewList[i].count == 2 and ((self.m_tAchieNotViewList[i].complete >= self.m_tAchieNotViewList[i].target and self.m_tAchieNotViewList[i].complete2 >= self.m_tAchieNotViewList[i].target2) or self.m_tAchieNotViewList[i].status > 0) then
						self.m_tAchieNotViewList[i].complete = self.m_tAchieNotViewList[i].complete  + 1
					end
				end
				break
			end
		end
	end

	for i=1,#self.m_tAchieList do           
		if self.m_tAchieList[i].id == 1 then 
			table.sort(self.m_tAchieList[i].childList, sortSubAchiListTwo)  --VIP称号子分类排序
		else
			table.sort(self.m_tAchieList[i].childList, sortSubAchiList)  --子分类排序
		end
	end

	CacheCenter:setRedState("btnBag",CacheCenter:isEquipedDecorationRedPoint())
    GlobalGame:getBtnRedPointEvent():dispatcher()

	if self.m_tAchieListCallBack ~= nil and #self.m_tAchieListCallBack > 0 then
		for i=1,#self.m_tAchieListCallBack do
			self.m_tAchieListCallBack[i][1](self.m_tAchieListCallBack[i][2], self.m_tAchieList)
		end
		self.m_tAchieListCallBack = {}
	end
end

function  sortMainAchiList(a, b)   
	-- body
	return a.id < b.id     --父类正序
end

function  sortSubAchiList(a, b)   
	-- body
	local statusA = CacheCenter:resetSortStatus(a)
	local statusB = CacheCenter:resetSortStatus(b)
	if statusA == statusB then
		return a.id < b.id
	else
		return statusA < statusB     --子类正序
	end	
end

function  sortSubAchiListTwo(a, b)   
	-- body
	local statusA = CacheCenter:resetSortStatusTwo(a)
	local statusB = CacheCenter:resetSortStatusTwo(b)
	if statusA == statusB then
		return a.id < b.id
	else
		return statusA > statusB     --子类正序
	end	
end

function CacheCenter:resetSortStatus(a)
	-- body
	if a.status == 1 then
		return 0
	elseif a.status == 2 then
		return 1
	elseif a.status == 0 then
		return 2
	elseif a.status == 3 then
		return 3
	end

	return 0
end

function CacheCenter:resetSortStatusTwo(a)
	-- body
	local bStatus = CacheCenter:judgeWhetherDesiUsed(a.id)
	if bStatus then 
		return 4
	else
		return a.status or 0
	end

	return 0
end

--@brief  设置成就系统称号列表数据
function CacheCenter:setDesiList(id, sort, name, remain, status, desc)
	-- body
	self.m_tDesiList = {}
	for i=0,id:size()-1 do
		local bIsExist = false
		for k, v in pairs(self.m_tDesiList) do 
			if id:get(i) == v.id then
				bIsExist = true
				break
			end
		end
		--称号列表中尚未存在该称号，才添加到称号列表
		if bIsExist == false then
			local  temp = {}
			temp.id  =  id:get(i)
			temp.sort = sort:get(i)
			temp.name = name:get(i)
			temp.remain = remain:get(i)
			temp.status = status:get(i)
			local basicData = GDatatab_achievement["id_" .. temp.id]
			if basicData then 
				temp.view = basicData.view
				temp.desc = basicData.desc
			else
				temp.view = 0
				temp.desc = desc:get(i)
			end
			if temp.status == 3 and temp.view == 0 then
				g_bHaveNewDesi = true
			end
--	        WZLog("CacheCenter:setDesiList:i===",i,temp.id,temp.sort,temp.name,temp.status)
			if temp.status == 2 then
				self.m_sDesignationShow = temp.name
			end
			table.insert(self.m_tDesiList, temp)
		end
	end
	table.sort(self.m_tDesiList, sortDesig)
	--WZLog("self.m_tDesiList",Serialize(self.m_tDesiList))

	if self.m_tDesiListCallBack ~= nil and #self.m_tDesiListCallBack > 0 then
        WZLog("#self.m_tDesiListCallBack===",#self.m_tDesiListCallBack)
		for i=1,#self.m_tDesiListCallBack do
			self.m_tDesiListCallBack[i][1](self.m_tDesiListCallBack[i][2], self.m_tDesiList)
		end
		self.m_tDesiListCallBack = {}
	end
end

function CacheCenter:resetDesiList()
	-- body
	if self.m_tDesiList == nil or self.m_tDesiList == {} then return end

	for i = 1, #self.m_tDesiList do
		if self.m_tDesiList[i].status == 3 then
			self.m_tDesiList[i].status = 1
		end
	end

	g_bHaveNewDesi = false
end

function sortDesig(a,b)
	local nStatusA = CacheCenter:checkDesigStatus(a)
	local nStatusB = CacheCenter:checkDesigStatus(b)
	if nStatusA ~= nStatusB then
		return nStatusA < nStatusB
	else
		return a.id < b.id
	end
end

function CacheCenter:checkDesigStatus(a)
	--body
	if a.status == 0 then 
		return 0
	elseif a.status == 3 then
		return 1
	elseif a.status == 2 then 
		return 2
	else
		return 3
	end
end

--@brief	设置爱心许愿列表信息
function CacheCenter:setLotteryItems(id, num,lotteryCount,lotteryReward)
	WZLog("CacheCenter:setLotteryItems",id:size(),num:size(),lotteryCount:size())
	self.m_tLotteryItems = {}
	self.m_tLotteryItems.id = {}
	self.m_tLotteryItems.name = {}
	self.m_tLotteryItems.icon = {}
	self.m_tLotteryItems.num = {}
	self.m_tLotteryItems.lotteryCount = {}
	self.m_tLotteryItems.lotteryReward = {}
	local idSize = id:size()
	for i=0,idSize-1 do 
		--物品基础数据
		local key = "id_"..id:get(i)
		if GDatatab_item[key] ~= nil and GDatatab_item[key].name ~= nil then
			table.insert(self.m_tLotteryItems.id,id:get(i))
			table.insert(self.m_tLotteryItems.name,GDatatab_item[key].name)
			table.insert(self.m_tLotteryItems.icon,GDatatab_item[key].icon)
			table.insert(self.m_tLotteryItems.num,num:get(i))
		end
	end

	idSize = lotteryCount:size()
	for i=0,idSize-1 do
		table.insert(self.m_tLotteryItems.lotteryCount,lotteryCount:get(i))
		table.insert(self.m_tLotteryItems.lotteryReward,lotteryReward:get(i))
	end
end

--@brief	设置祝福礼盒物品列表
function CacheCenter:setZflhList(id, itemId, itemNum, state)
	self.m_tGiftList = {}
	self.m_tGiftList.id = {}
	self.m_tGiftList.itemId = {}
	self.m_tGiftList.itemNum = {}
	self.m_tGiftList.state = {}

	for i=0,id:size()-1 do 
		table.insert(self.m_tGiftList.id,id:get(i))
		table.insert(self.m_tGiftList.itemId,itemId:get(i))
		table.insert(self.m_tGiftList.itemNum,itemNum:get(i))
		table.insert(self.m_tGiftList.state,state:get(i))
	end
end

--@brief	设置联赛信息
function CacheCenter:setLeagueInfo(countDown, stage)
	self.m_tLeagueInfo = {}
	self.m_tLeagueInfo.countDown = countDown
	self.m_tLeagueInfo.stage = stage
end

--@brief	设置广告信息
function CacheCenter:setAdMessage(imgUrl, params, sort, ad_type)
	self.m_tAdMessage = {}

	for i=1,#imgUrl do
		local temp = {}
		temp.imgUrl = imgUrl[i]
		temp.params = params[i]
		temp.sort = sort[i]
		temp.ad_type = ad_type[i]
		table.insert(self.m_tAdMessage, temp)
	end
	table.sort(self.m_tAdMessage, _sortAdvertising)
	WZLog("CacheCenter:setAdMessage",Serialize(self.m_tAdMessage))
end

--@brief	设置公会信息
function CacheCenter:setGuildInfo(guildId, guildName, guildLevel, prestige, members, desc, setting, totemLevel, schoolLevel, storeLevel, newApply, id, level, post, donate, totalDonate, buyDonate, totemPayTime, sex, weekDonate, lastDonate, allDonate, vipLevel, examine, joinVipLevel, guildwarStage, qualification, presidentInfo, isXili, noticeStatus)
	self.m_tGuildInfo = {}
	self.m_tGuildInfo.guildId = guildId
	self.m_tGuildInfo.guildName = guildName
	self.m_tGuildInfo.guildLevel = guildLevel
	self.m_tGuildInfo.prestige = prestige
	self.m_tGuildInfo.members = members
	self.m_tGuildInfo.desc = desc
	self.m_tGuildInfo.setting = setting
	self.m_tGuildInfo.totemLevel = totemLevel
	self.m_tGuildInfo.schoolLevel = schoolLevel
	self.m_tGuildInfo.storeLevel = storeLevel
	self.m_tGuildInfo.newApply = newApply
	self.m_tGuildInfo.examine = examine
	self.m_tGuildInfo.joinVipLevel = joinVipLevel
	self.m_tGuildInfo.presidentInfo = presidentInfo
	self.m_tGuildInfo.isXili = isXili
	self.m_tGuildInfo.noticeStatus = noticeStatus
	
	for i=1,#id do
		if id[i] == CacheCenter:getPlayerInfo().id then
			self.m_tGuildInfo.level = level[i]
			self.m_tGuildInfo.position = post[i]
			self.m_tGuildInfo.donate = donate[i]
			self.m_tGuildInfo.totalDonate = totalDonate[i]
			self.m_tGuildInfo.buyDonate = buyDonate[i]
			self.m_tGuildInfo.totemPayTime = totemPayTime[i]
			self.m_tGuildInfo.sex = sex[i]
			self.m_tGuildInfo.weekDonate = weekDonate[i]
			self.m_tGuildInfo.lastDonate = lastDonate[i]
			self.m_tGuildInfo.allDonate = allDonate[i]
			self.m_tGuildInfo.vipLevel = vipLevel[i]
		end
	end
end

--@brief	设置师徒信息
function CacheCenter:setMasterInfo(hasMaster, pupil, moralityLevel, moralityExp, baishiLevel, addVigor, message, num, lastTime, taskfinish, lastXjTime)
	self.m_tMasterInfo = {}
	self.m_tMasterInfo.hasMaster = hasMaster
	self.m_tMasterInfo.pupil = pupil
	self.m_tMasterInfo.moralityLevel = moralityLevel
	self.m_tMasterInfo.moralityExp = moralityExp
	self.m_tMasterInfo.baishiLevel = baishiLevel
	self.m_tMasterInfo.addVigor = addVigor
	self.m_tMasterInfo.message = message
	self.m_tMasterInfo.honorTime = num
	self.m_tMasterInfo.lastTime = lastTime
	self.m_tMasterInfo.taskfinish = taskfinish
	self.m_tMasterInfo.lastXjTime = lastXjTime

    if GlobalGame.m_bIsSendMaterGetTemple == true then
        GlobalGame.m_bIsSendMaterGetTemple = nil
        return
    end
	--战斗中不打开师徒界面
	if GlobalGame.g_bIfInBattle == true then return end
	if SceneLeagueMain.m_root ~= nil or SceneRoom.m_root ~= nil or SceneBossRoom.m_root ~= nil or SceneBattle.m_root ~= nil or SceneBattleLoading.m_root ~= nil or WindowManager:isHaveTeachTouchLayer() == true or WndTeachTalk.m_root ~= nil or WndDoubleTowerRoom.m_root ~= nil then return end

	if WndMasterHall ~= nil and WndMasterHall.m_root ~= nil then
		WZLog("WndMasterHall:update()1")
		WndMasterHall:update()
	end
	if WndMaster.m_root then
		WndMaster:updateUI()
	end
end

--添加宠物列表信息
function CacheCenter:addPlayerPetInfo(itemId, name, icon,animation,advancedLevel,upgradeLevel ,property,giftSkill, commonSkill1, commonSkill2, isInUsed, playerPetId,num,petExp,fighting,birthSkill,skill, petSkinItemId, fetterStatus)
	if self.m_tPlayerPetInfo == nil then
		self.m_tPlayerPetInfo = {}
	end
	local tTempPetInfo = {}
	tTempPetInfo.itemId = itemId
	tTempPetInfo.name = GetPetNameById(itemId,advancedLevel)
	tTempPetInfo.icon = icon
	tTempPetInfo.animation = animation
	tTempPetInfo.advancedLevel = advancedLevel
	tTempPetInfo.upgradeLevel = upgradeLevel
	tTempPetInfo.property = property
	tTempPetInfo.giftSkill = giftSkill
	tTempPetInfo.commonSkill1 = commonSkill1
	tTempPetInfo.commonSkill2 = commonSkill2
	tTempPetInfo.isInUsed = isInUsed
	tTempPetInfo.playerPetId = playerPetId
	tTempPetInfo.num = num
	tTempPetInfo.petExp = petExp
    tTempPetInfo.fighting = fighting
    tTempPetInfo.birthSkill = birthSkill
    tTempPetInfo.skill = skill
    tTempPetInfo.petSkinItemId = petSkinItemId
    tTempPetInfo.fetterStatus = fetterStatus
	table.insert(self.m_tPlayerPetInfo, tTempPetInfo)
	
end

--@brief	获取邮件列表函数
--@param	#1 mailId:邮件ID 
--@param	#2 theme:邮件主题 
--@param	#3 time:时间
--@param	#4 status:是否读
--@param	#5 senderId:发送者Id
function CacheCenter:setMailList(id, theme, time, status, sendId, attachment, headId, faceId, cost, content, attachments, sexs,senderName,recvName,color,mail_type)
	if self.m_tMailList == nil then
        self.m_tMailList = {}
	end

	--收到普通邮件就先清空原来的普通邮件,后面再添加. 商务邮件同理
	for i = #self.m_tMailList, 1, -1 do
		if self.m_tMailList[i].mail_type == mail_type then
			table.remove(self.m_tMailList,i)
		end
	end

	local isMark = false
	for i = 0 , id:size() - 1 do
		local temp = {}
		temp.mailId = id:get(i)
		temp.theme = theme:get(i)
		temp.time = time:get(i)
		temp.isRead = status:get(i)
		temp.sendId = sendId:get(i)
		temp.attachment = attachment:get(i)
		temp.headId = headId:get(i)
		temp.faceId = faceId:get(i)
		temp.cost = cost:get(i)
		temp.content = content:get(i)
		temp.attachments = attachments:get(i)
		temp.sexs = sexs:get(i)
		temp.senderName = senderName:get(i) 
		temp.recvName = recvName:get(i)
		temp.color = color:get(i)
		temp.mail_type = mail_type
		temp.timeSort = TimeStrToTime(temp.time)
		table.insert(self.m_tMailList,temp)
--		WZLog("CacheCenter:setMailList:",i, temp.senderName, temp.mailId, temp.isRead, temp.sendId, temp.cost, "attachment " .. temp.attachment, "content " .. temp.content, "attachments " .. temp.attachments)
		if not isMark then
			if (temp.isRead == 0 or temp.isRead == 1 or temp.isRead == 3 or temp.isRead == 8) and temp.sendId ~= CacheCenter:getPlayerInfo().id then
				isMark = true
			end
		end
	end	
	if isMark then
		self.m_nMailMark = 1
    	self:addMark("btnMail_WndOwnCity",1,3)
	end
	if WndMail.m_root ~= nil then
        WndMail:updateMailList()
   	end
end

--@brief 设置邮件红点
function CacheCenter:setMailStatus(id, status, operate)
	WZLog("CacheCenter:setMailStatus one")
	if operate == "open" or operate == "get" then
		for i, v in pairs (self.m_tMailList) do
			if v.mailId == id and (operate == "open" and v.isRead == 0 or operate == "get") then
				self.m_tMailList[i].redStatus = status
				break
			end
		end
	elseif operate == "getAll" then
		for i, v in pairs (self.m_tMailList) do
			for j, k in pairs (id) do
				WZLog("CacheCenter:setMailStatus two", v.mailId , k, v.sendId, tostring(v.attachments))
				if v.mailId == k then
					self.m_tMailList[i].redStatus = status
					break
				end
			end
		end
	elseif operate == "del" then
		for i, v in pairs (self.m_tMailList) do
			for j, k in pairs (id) do
				WZLog("CacheCenter:setMailStatus three", v.mailId , k, v.sendId, tostring(v.attachments))
				if v.mailId == k then
					self.m_tMailList[i].redStatus = status
					break
				end
			end
		end
	end
end

--@brief 是否邮件红点
function CacheCenter:isMailRedPoint()
	WZLog("CacheCenter:isMailRedPoint")
	if self.m_tMailList == nil then return end 
	
	local isMark = false
	for i, temp in pairs (self.m_tMailList) do
		--WZLog("CacheCenter:isMailRedPoint:",i, temp.senderName, temp.mailId, temp.isRead, tostring(temp.redStatus), temp.sendId, temp.cost, "attachment " .. temp.attachment, "content " .. temp.content, "attachments " .. temp.attachments)
		if (((temp.isRead == 0 or temp.isRead == 1 or temp.isRead == 8) and 
			(temp.redStatus and temp.redStatus ~= 2 or temp.redStatus == nil)) or temp.isRead == 3) and 
			temp.sendId ~= CacheCenter:getPlayerInfo().id then
			isMark = true
			break
		end
	end

	if isMark then
		self.m_nMailMark = 1
    	self:addMark("btnMail_WndOwnCity",1,3)
    else
    	CacheCenter.m_nMailMark = 0
    	CacheCenter:addMark("btnMail_WndOwnCity",0,3)
	end
end

--@brief	推送邮件
function CacheCenter:pushMail(id, theme, time, status, sendId, attachment, headId, faceId, cost, content, attachments,sexs,senderName,recvName, deleMailId,color)
    WZLog("推送邮件CacheCenter:pushMail:",id, theme, time, status, sendId, attachment, headId, faceId, cost, content, attachments,sexs,senderName,recvName, deleMailId)
	if self.m_tMailList == nil then
        WZLog("CacheCenter:pushMail self.m_tMailList == nil")
        self.m_tMailList = {}
	end
	if deleMailId ~= -1 then
		for i =1, #self.m_tMailList do
			if self.m_tMailList[i].mailId == deleMailId then
				table.remove(self.m_tMailList, i)
				break
			end
		end
	end
    WZLog("id====",id)
    WZLog("sendId====",sendId)
	local temp = {}
	temp.mailId = id
	temp.theme = theme
	temp.time = time
	temp.isRead = status
	temp.sendId = sendId
	temp.attachment = attachment
	temp.headId = headId
	temp.faceId = faceId
	temp.cost = cost
	temp.content = content
	temp.attachments = attachments
	temp.sexs = sexs
	temp.senderName = senderName
	temp.recvName = recvName
	temp.color = color
	temp.mail_type = sendId > 0 and 1 or 0
	temp.timeSort = TimeStrToTime(temp.time)
	table.insert(self.m_tMailList,1,temp)

    --服务器要求普通邮件超过500条就删除最后一条
    local cnt = 0
    local idx = 0
    for i=1,#self.m_tMailList do
    	if self.m_tMailList[i].mail_type == 0 then
    		cnt = cnt + 1
    		if cnt > 500 then
    			idx = i
    			break
    		end
    	end
    end
    table.remove(self.m_tMailList,idx)
    
    --更新收件箱
    if sendId == CacheCenter:getPlayerInfo().id then
        WndMail:getInfoFromServer(1)
    else
    	--conBtnMail_WndOwnCity
    	if WndMail.m_root == nil then
    		self.m_nMailMark = 1
    		self:addMark("btnMail_WndOwnCity",1,3)
    	end
        WndMail:updateMailList(temp)
    end
end

--@brief	推送邮件
function CacheCenter:pushMailList(id, theme, time, status, sendId, attachment, headId, faceId, cost, content, attachments, sexs, sendName, receivedName, deleteId, colour)
    WZLog("CacheCenter:pushMailList")

	if self.m_tMailList == nil then
        WZLog("CacheCenter:pushMailList self.m_tMailList == nil")
        self.m_tMailList = {}
	end
	for i=1,#deleteId do
		if deleteId[i] ~= -1 then
			for j = #self.m_tMailList, 1, -1 do
				if self.m_tMailList[j].mailId == deleteId[i] then
					table.remove(self.m_tMailList, j)
					break
				end
			end
		end
	end

	for i=1,#id do
		local temp = {}
		temp.mailId = id[i]
		temp.theme = theme[i]
		temp.time = time[i]
		temp.isRead = status[i]
		temp.sendId = sendId[i]
		temp.attachment = attachment[i]
		temp.headId = headId[i]
		temp.faceId = faceId[i]
		temp.cost = cost[i]
		temp.content = content[i]
		temp.attachments = attachments[i]
		temp.sexs = sexs[i]
		temp.senderName = sendName[i]
		temp.recvName = receivedName[i]
		temp.color = colour[i]
		temp.mail_type = sendId[i] > 0 and 1 or 0
		temp.timeSort = TimeStrToTime(temp.time)
		table.insert(self.m_tMailList,1,temp)
	end

    --服务器要求普通邮件超过500条就删除最后一条
    local cnt = 0
    local idx = {}
    for i=1,#self.m_tMailList do
    	if self.m_tMailList[i].mail_type == 0 then
    		cnt = cnt + 1
    		if cnt > 500 then
    			table.insert(idx,i)
    		end
    	end
    end
    for i=#idx,1,-1 do
	    table.remove(self.m_tMailList,idx[i])
    end
    
    --更新收件箱
	if WndMail.m_root == nil then
		self.m_nMailMark = 1
		self:addMark("btnMail_WndOwnCity",1,3)
	end
    WndMail:updateMailList(temp)

end

--@brief    新增编写邮件
function CacheCenter:addOneEditMailToCache()
    WZLog("CacheCenter:addOneEditMailToCache")
    if self.m_tMailList == nil then
        WZLog("addOneEditMailToCache self.m_tMailList == nil")
        self.m_tMailList = {}
    end
end

--@brief	保存游戏参数
function CacheCenter:setGameParam(name, value)
	--WZLog("CacheCenter:setGameParam",Serialize(name),Serialize(value))
	self.m_tGameParam = {}
	for i=1,#name do
		self.m_tGameParam[name[i]] = value[i]
	end
    
    if self.m_tGameParam.gameStatus ~= nil and self.m_tGameParam.gameStatus == "1" then 
        --GDatatab_button_info = GDatatab_button_info1
    end
    
	--WZLog("CacheCenter:setGameParam::A:",Serialize(self.m_tGameParam))
	WZLog("maxMountsUpgradeLevel::::",self.m_tGameParam["greatEscapeCoinWeekLimitRatio"])
	if self.m_tGameParam.upgradeBlueLevel ~= nil then
		LANASCENDINGSTRONG = tonumber(self.m_tGameParam.upgradeBlueLevel)
	end
	if self.m_tGameParam.upgradeBlueStar ~= nil then
		LANASCENDINGSTAR = tonumber(self.m_tGameParam.upgradeBlueStar)
	end
	if self.m_tGameParam.upgradePurpleLevel ~= nil then
		ZIASCENDINGSTRONG = tonumber(self.m_tGameParam.upgradePurpleLevel)
	end
	if self.m_tGameParam.upgradePurpleStar ~= nil then
		ZIASCENDINGSTAR = tonumber(self.m_tGameParam.upgradePurpleStar)
	end
	if self.m_tGameParam.drawingPurpleWeapon ~= nil then
		DRAWINGPURPLEWEAPON = tonumber(self.m_tGameParam.drawingPurpleWeapon)
	end
	if self.m_tGameParam.drawingPurpleNecklace ~= nil then
		DRAWINGPURPLENECKLACE = tonumber(self.m_tGameParam.drawingPurpleNecklace)
	end
	if self.m_tGameParam.drawingPurpleRing ~= nil then
		DRAWINGPURPLERING = tonumber(self.m_tGameParam.drawingPurpleRing)
	end
	if self.m_tGameParam.drawingPurpleWrister ~= nil then
		DRAWINGPURPLEWRISTER = tonumber(self.m_tGameParam.drawingPurpleWrister)
	end
	if self.m_tGameParam.drawingPurpleBadge ~= nil then
		DRAWINGPURPLEBADGE = tonumber(self.m_tGameParam.drawingPurpleBadge)
	end
	if self.m_tGameParam.drawingPurpleTreasure ~= nil then
		DRAWINGPURPLETREASURE = tonumber(self.m_tGameParam.drawingPurpleTreasure)
	end
	if self.m_tGameParam.orangeChangeGradeMaterial ~= nil then
		ORANGECHANGEGRADEMATERIAL = tonumber(self.m_tGameParam.orangeChangeGradeMaterial)
	end

	if self.m_tGameParam.forbiddenDiceLimit ~= nil then
		self.m_tTabooCoinLimitNum = {}
		local s = self.m_tGameParam.forbiddenDiceLimit
		s = string.gsub(s, "%[", "")
        s = string.gsub(s, "%]", "")
		local splitArray = SplitStringWithSeparator(s, "&")
	    for i, v in pairs(splitArray) do
	        if v == nil or v == "" then
	            break
	        end
	        local result = SplitStringWithSeparator(v, ",")
	        self.m_tTabooCoinLimitNum[tonumber(result[1])]  = tonumber(result[2])
	    end
	end
	--解析小孩时装套装数据
	if g_tKidDressSuitData == nil then 
		g_tKidDressSuitData = {}
		local strTemp = self.m_tGameParam["childrenFashonSuit"]
		strTemp = string.gsub(strTemp, "%[", "")
        strTemp = string.gsub(strTemp, "%],", "&")
        strTemp = string.gsub(strTemp, "%]", "")
		local splitArray = SplitStringWithSeparator(strTemp, "&")
		for i, v in pairs(splitArray) do
			local result = SplitStringWithSeparator(v, ",", nil, true)
			table.insert(g_tKidDressSuitData, result)
		end
	end
	--WZLog("CacheCenter:setGameParam tabooCoinMaxNum:",Serialize(self.m_tTabooCoinLimitNum))
end

--@brief	设置单人副本数据
--@param    pointId : 小关卡id
--@param    passTime : 已挑战次数
--@param    factor : 通关条件状态1位条件一，2位条件二，3位条件三
--@param    sectionId : 章节ID
--@param    rewardNum : 领取的奖励数1位奖励一，2位奖励二，3位奖励三
--@param    sectionId2 : 精英副本章节id
--@param    sectionId3 : 地獄副本章节id
function CacheCenter:setSingleCopyData(pointId, passTime, factor, sectionId, rewardNum,sectionId2,rewardnum2,restTimes,sectionId3,rewardNum3)
    WZLog("CacheCenter:setSingleCopyData")
    self.m_tSingleCopyData = {}
    self.m_tSingleResertData = {}
    --小关卡信息
    for i = 1,#pointId do
        self.m_tSingleCopyData[i] = {
            pointId = pointId[i],
            restTimes = restTimes[i],
            passTime = passTime[i] or 0,
            factor = factor[i] or 1,
        }
    	--获取每一个关卡的重置次数 by hyx
    	self.m_tSingleResertData[pointId[i]] = restTimes[i]
    end
    -- WZLog("self.m_tSingleResertData.....: ",Serialize(self.m_tSingleResertData))
    -- WZLog("20805... CacheCenter:getSingleResetCount ..: ",CacheCenter:getSingleResetCount(20805))
    self.m_tSingleCopyData.sectionReward = {}  --单人副本普通章节奖励

    --章节奖励信息
    for i = 1,#sectionId do
        self.m_tSingleCopyData.sectionReward[i] = {
            sectionId = sectionId[i],
            rewardNum = rewardNum[i],
        }
    end
    
    self.m_tSingleCopyData.sectionReward2 = {}
    for i = 1,#sectionId2 do
        self.m_tSingleCopyData.sectionReward2[i] = {
            sectionId = sectionId2[i],
            rewardNum = rewardnum2[i],
        }
    end

    self.m_tSingleCopyData.sectionReward3 = {}
    for i = 1,#sectionId3 do
        self.m_tSingleCopyData.sectionReward3[i] = {
            sectionId = sectionId3[i],
            rewardNum = rewardNum3[i],
        }
    end
    --WZLog("CacheCenter:setSingleCopyData =",Serialize(self.m_tSingleCopyData))
    GlobalGame:getBattleEventDispatcher():Dispatch("CLEAR_BUY_RESET_EVENT")
    --发送更新通知
    NotificationCenter:sendNotification(UPDATESINGLECOPYDATANOTIFICATION)
end

--@brief	更新单人副本数据
--@param    pointId : 小关卡id
--@param    passTime : 已挑战次数
--@param    factor : 通关条件状态1位条件一，2位条件二，3位条件三
--@param    passTimeInc : 已挑战次数的增
--@note     挑战或者扫荡完后更新本地数据，passTime为额外多挑战或者扫荡的次数
function CacheCenter:updateSingleCopyData(pointId, passTime, factor, passTimeInc)
	WZLog("CacheCenter:updateSingleCopyData")
    self.m_tSingleCopyData = self.m_tSingleCopyData or {}
    local bFlag = false
    for i,v in ipairs(self.m_tSingleCopyData) do
        if v.pointId == pointId then
        	bFlag = true
            if passTimeInc then
                v.passTime = v.passTime + passTimeInc
            elseif passTime then
                v.passTime = passTime
            end

            if v.factor == 7 then
            	break
            elseif v.factor == 1 and factor then
            	v.factor = factor
            elseif v.factor == 5 and factor == 3  then
            	v.factor = 7
            elseif v.factor == 3 and factor == 5 then
            	v.factor = 7
            elseif factor == 7 then
            	v.factor = 7
            end
            
            break
        end
    end
    if bFlag == false then
        table.insert(self.m_tSingleCopyData, {pointId=pointId, passTime=passTime, factor=factor})
    end
    --发送更新通知
    NotificationCenter:sendNotification(UPDATESINGLECOPYDATANOTIFICATION)
end

--@brief	更新单人副本奖励数据
--@param    sectionId : 章节ID
--@param    rewardNum : 领取的奖励数1位奖励一，2位奖励二，3位奖励三
--@param    mapType   :副本类型 1普通单人副本 2精英单人副本
--@note     领取后更新本地数据，passTime为额外多挑战或者扫荡的次数
function CacheCenter:updateSingleCopyRewardData(sectionId, rewardNum,mapType)
	WZLog("CacheCenter:updateSingleCopyRewardData = ",sectionId,rewardNum,mapType,type(mapType))
    self.m_tSingleCopyData = self.m_tSingleCopyData or {}
    local bFlag = false
    if mapType == 1 then
    	self.m_tSingleCopyData.sectionReward = self.m_tSingleCopyData.sectionReward or {}
		for i,v in ipairs(self.m_tSingleCopyData.sectionReward) do
		    if v.sectionId == sectionId then
		        v.rewardNum = rewardNum
		        bFlag = true
		        break
		    end
		end
		if bFlag == false then
		    table.insert(self.m_tSingleCopyData.sectionReward, {sectionId=sectionId, rewardNum=rewardNum})
		end
    elseif mapType == 2 then
    	self.m_tSingleCopyData.sectionReward2 = self.m_tSingleCopyData.sectionReward2 or {}
		for i,v in ipairs(self.m_tSingleCopyData.sectionReward2) do
		    if v.sectionId == sectionId then
		        v.rewardNum = rewardNum
		        bFlag = true
		        break
		    end
		end
		if bFlag == false then
		    table.insert(self.m_tSingleCopyData.sectionReward2, {sectionId=sectionId, rewardNum=rewardNum})
		end
	elseif  mapType == 3 then
		self.m_tSingleCopyData.sectionReward3 = self.m_tSingleCopyData.sectionReward3 or {}
		for i,v in ipairs(self.m_tSingleCopyData.sectionReward3) do
		    if v.sectionId == sectionId then
		        v.rewardNum = rewardNum
		        bFlag = true
		        break
		    end
		end
		if bFlag == false then
		    table.insert(self.m_tSingleCopyData.sectionReward3, {sectionId=sectionId, rewardNum=rewardNum})
		end
    end
end

--@brief	设置组队副本数据
--@param    resetTime : 重置次数
--@param    mapId : 地图id
--@param    passTime : 已挑战次数
--@param    starLevel : 副本星级（未打过的副本星级为0）
--@param    awakeMap : 开启的觉醒难度的副本Id
--@param    awakeTimes : 挑战觉醒难度的副本的次数
--@param    awakeJson : 觉醒镜像玩家信息
function CacheCenter:setMultiCopyData(resetTime, mapId, passTime, starLevel, awakeMap, awakeTimes, awakeJson)
    self.m_tMultiCopyData = {}
    self.m_tMultiCopyData.resetTime = resetTime
    self.m_tMultiCopyData.awakeMapId = awakeMap
    self.m_tMultiCopyData.awakeTimes = awakeTimes
    if awakeJson ~= nil and awakeJson ~= "" then
	    self.m_tMultiCopyData.awakeMirrorInfo = json.decode(awakeJson)
	end
    
    for i,v in ipairs(mapId) do
        self.m_tMultiCopyData[i] = {
            mapId = v,
            passTime = passTime[i] or 0,
            starLevel = starLevel[i] or 0,
        }
    end
    WZLog("CacheCenter:setMultiCopyData", Serialize(self.m_tMultiCopyData))
    --发送更新通知
    NotificationCenter:sendNotification(UPDATEMULTICOPYDATANOTIFICATION)
end

--@brief	更新组队副本数据
--@param    mapId : 地图id
--@param    passTime : 额外的挑战次数，在已有挑战次数上增加的数量
--@param    starLevel : 副本星级（未打过的副本星级为0）
function CacheCenter:updateMultiCopyData(mapId, passTime, starLevel)
    self.m_tMultiCopyData = self.m_tMultiCopyData or {}
    local bFlag = false
    for i,v in ipairs(self.m_tMultiCopyData) do
        if v.mapId == mapId then
            bFlag = true
            if passTime then
                v.passTime = v.passTime + passTime
            end
            if starLevel then
                v.starLevel = starLevel
            end
            break
        end
    end
    if bFlag == false then
        table.insert(self.m_tMultiCopyData, {
            mapId = mapId,
            passTime = passTime or 0,
            starLevel = starLevel or 0,
        })
    end
    --发送更新通知
    NotificationCenter:sendNotification(UPDATEMULTICOPYDATANOTIFICATION)
end

--@brief	重置组队副本成功
--@param    mapId : 地图id
--@param    resetTime : 玩家副本重置次数
function CacheCenter:resetMultiCopySuccess(mapId, resetTime)
    self.m_tMultiCopyData = self.m_tMultiCopyData or {}
    self.m_tMultiCopyData.resetTime = resetTime
    for i,v in ipairs(self.m_tMultiCopyData) do
        if v.mapId == mapId then
            v.passTime = 0
            break
        end
    end
    NotificationCenter:sendNotification(UPDATEMULTICOPYDATANOTIFICATION)
end

--@brief	更新觉醒组队副本挑战次数
function CacheCenter:resetAwakeMultiCopyTimes()
    if self.m_tMultiCopyData == nil then self.m_tMultiCopyData = {} end 
    self.m_tMultiCopyData.awakeTimes = 0
    
    --发送更新通知
    NotificationCenter:sendNotification(UPDATEMULTICOPYDATANOTIFICATION)
end

--@brief	设置组队副本数据
function CacheCenter:setDailyCopyData(data)
    WZLog("CacheCenter:setDailyCopyData")
    self.m_tDailyCopyData = data
end

-- 设置爬塔副本的信息
--m_tTowerCopyData
function CacheCenter:setTowerCopyData(data)
	self.m_tTowerCopyData = data
	NotificationCenter:sendNotification(UPDATETOWERCOPYDATANOTIFICATION)
end

--@brief  更新爬塔副本缓存信息
function CacheCenter:updateTowerCopyData(data)
	for k,v in pairs(data) do
		self.m_tTowerCopyData[k] = v
	end
end

--@brief	更新组队副本数据
--@param    mapId : 副本Id
--@param    passTime : 已挑战次数
--@param    isOpen : 是否开启
--@param    resetTimes : 已重置次数
--@param    passTimeInc : 已挑战次数的增值
function CacheCenter:updateDailyCopyData(mapId, passTime, isOpen, resetTimes, passTimeInc)
    WZLog("CacheCenter:updateDailyCopyData", mapId)
    self.m_tDailyCopyData = self.m_tDailyCopyData or {}
    for i,v in ipairs(self.m_tDailyCopyData) do
        if v.mapId == mapId then
            v.passTime = passTime or v.passTime
            v.isOpen = isOpen or v.isOpen
            v.resetTimes = resetTimes or v.resetTimes
            if passTime == nil and passTimeInc then
                v.passTime = v.passTime + passTimeInc
            end
            break
        end
    end
    --发送更新通知
    NotificationCenter:sendNotification(UPDATEDAILYCOPYDATANOTIFICATION)
end

-- 设置双人爬塔副本的信息
function CacheCenter:setDoubleTowerCopyData(data)
	self.m_tDoubleTowerCopyData = data
	NotificationCenter:sendNotification(UPDATEDOUBLETOWERCOPYDATANOTIFICATION)
end

function CacheCenter:resetObservers()
    self.m_tPlayerInfoObservers = nil --玩家数据改变的监听者
    self.m_tPlayerItemObservers = nil --玩家物品数据改变的监听者
    self.m_tPlayerPetInfoObservers = nil --玩家宠物数据改变的监听者
    self.m_tMoneyObservers = nil --钻石、金币数据改变的监听者
    self.m_tWeaponObservers = nil --武器数据改版的监听者
    self.m_tDecorationObservers = nil --装扮数据改版的监听者
    self.m_tPetEquitObservers = nil --宠物装备数据改版的监听者
    self.m_tOtherObservers = nil --其他数据改版的监听者
    self.m_tMaterialObservers = nil --材料数据改版的监听者
    self.m_tFriendListObservers = nil --好友列表(结婚，邮件，私聊)数据回调函数
    self.m_sDeShowObservers  = nil      --显示的称号面板坚挺者
    self.m_tSingleCopyData = nil    --单人副本数据
    self.m_tMultiCopyData = nil     --组队副本数据
    self.m_tDailyCopyData = nil     --日常副本数据
    self.m_tTowerCopyData = nil      -- 爬塔副本
    self.m_tDressSuitObservers = nil --玩家套装改变的监听者
    self.m_tPetEquipSchemeObservers = nil --宠物装备改变的监听者
    self.m_tPlayerHomeItemObservers = nil --玩家小家物品数据改变的监听者
    self.m_tKidDecorationObservers = nil --小孩装扮数据改版的监听者
    self.m_tSingleResertData = nil --重置副本扫荡次数的获取
    self.m_tSkillSuitObservers = nil --玩家技能方案改变的监听者
end

--@brief	重置缓存中心
function CacheCenter:reset()
	WZLog("CacheCenter:reset")
	BANCHAT = {}
    self.m_tPlayerInfo = nil           --玩家背包基础信息
    self.m_tPlayerItemList = nil       --解析后的玩家背包物品列表信息
    self.m_tPlayerPetInfo = {}         --玩家宠物信息
    self.m_tMounts = nil                --坐骑信息
    self.m_tShopItems = nil            --商城商品列表信息
    self.m_tShopItemsSended = nil     --请求商城商品列表协议已发送
    self.m_tShopItemsCallBack = {}     --商城刷新列表
    self.m_tLotteryItems = nil         --爱心许愿物品列表
    self.m_tGiftList = nil             --祝福礼盒物品列表
    --self.m_tGuildInfo = nil			   --公会信息
	self.m_tLeagueInfo = nil
	self.m_tAdMessage = nil
    self.m_tUpdatePlayerItem = nil     --更新背包物品信息
    self.m_tWeaponList = nil      --武器列表
    self.m_tDecorationList = nil  --装扮列表
    self.m_tOtherItemList = nil   --其他类物品列表
    self.m_tMaterialList = nil   --材料列表
    self.m_tCardItemList = nil   --卡牌物品列表
    self.m_tCardChipList = nil   --卡牌碎片物品列表
    self.m_tMoneyList = nil   --玩家财富列表，即钻石、金币、红钻等
    self.m_tEquipmentList = nil --玩家身上已装备的物品列表
    self.m_tActiveInfoList = nil --活跃系统里的缓存信息
    self.m_tMailList = nil--邮件列表
    self.m_nMailMark= 0 --邮件标识
    self.m_tFriend = nil
    self.m_tCurrentFriends = nil--当前通过审批的好友列表
    self.m_nCityFriendsMark = 0 --有新的好友审批信息
    self.m_tFriendList = nil
    self.m_nAppMark = 0
    self.m_nDailyMark = 0
    self.m_nInviteMark = 0 		--邀请任务有可领取的任务
    self.m_tAchieList = nil              --成就列表
    self.m_tAchieListCallBack = nil      --成就列表回调
    self.m_tAchieListSender   = nil      --成就列表请求协议
    self.m_tAchieNotViewList = nil
    self.m_tDesiList = nil              --称号列表
    self.m_tDesiListCallBack = nil      --称号列表回调
    self.m_tDesiListSender   = nil      --称号列表请求协议
    self.m_sDesignationShow  = nil      --显示的称号
    self.m_tRankListInfo = nil          --排行榜
    self.m_tMasterInfo = nil			--师徒信息
    self.m_tGameParam = nil             --游戏参数
    self.m_nDynamic = 0
    self.m_bOneKeyOperator_Friends = false --好友动态进行一键操作
    self.m_tRedPoint = {}                -- 红点信息
    self.m_bInitRedPointFlag = false
    self.m_tActivityItemRedDotList = nil  --活动列表红点信息
    self.m_tNextDay = nil 				 --跨天状态
    self.m_bSignItemEnter = false       --签到是否需要换行
    self.m_tTaskRecordingArrays = {} 	--任务状态记录表
    self.m_tSignCacheData = {}           --签到缓存数据
    self.m_tMyRankListInfo = nil 		--我的排行榜数据
    self.m_nUpdatePlayerItem = 0		--推送缓存调用_updatePlayerItemData函数的数量
    self.m_nUpdatePlayerInfo = 0		--推送缓存调用_updatePlayerInfoData函数的数量
	self.m_nUpdating = false			 --是否正在更新观察者
    self.m_tRedPointInfo = {}            -- 红点信息
    self.m_nPlayerLevel = 0              -- 玩家等级，战斗前保存一次，方便战斗结算动画
    self.m_tVipList = nil    -- 充值列表
    self.m_nLeftAchiePoints = nil 
    self.m_tStarSoulList = nil 	--星魂列表
	self.m_serverInfo = nil

    g_isGlobalProtocolReged = false
    g_bIsShowFightingLater = true   --标记登录进游戏时，遇到战斗力变化，待进入主城才弹变化效果
	g_nLaterShowFighting = nil      --登录时，保存时装过期的战斗力变化
	g_bHaveNewDesi = false            --用于标记成就界面称号选项卡右上角的红点提示是否显示
	g_bHaveRedPointForAchieEntry = false           --用于标记成就界面入口处是否显示红点提示
	self.m_tWelfareItemRedDotList = nil  --活动列表红点信息
	g_tMarryDiscountTime = nil 
	g_tRedPackList = {}

	self.m_tInviteFriends = nil 	--邀请码好友列表
    self.m_tInviteTaskList = nil 	--邀请码任务列表
    self.m_sMyInviteCode = nil 		--自己的邀请码
    self.m_nInviteState = nil 		--邀请状态1：已提交过邀请码；0：未提交过邀请码
    self.m_tGuildWarTargetData = nil 	--公会战目标数据

    self.m_tChatCache = {}
    self.m_tAreanAddInfo = {addValue = {},timeValue = {},timeType = {}}
    self.m_tGuildWarTargetData = nil 
    self.m_tPromiseData = nil

    self.m_nBuyTabooCoinTimes = 0
   	self.m_nTabooCoinNum = 0
	self.m_nTabooBoxCountDown = nil
	self.m_tYearActivityItemRedDotList = nil 	 --周年活动列表红点信息
	self.m_nDesignationShowId  = nil      --显示的称号ID

   	self.m_tTabooCoinLimitNum = {}

	self.m_tSkill = nil		--玩家技能列表
	self.m_bFundFinish = true --基金是否领完
	self.m_tNewUserPackageList = nil --新手已经触发的定推礼包列表
	self.m_tFootMarkList = nil 	--足迹列表
	self.m_nUseFootMarkId = nil 	--正在使用的足迹Id
	self.m_tApartmentRedDotList = nil 
	self.m_tLimitPackageList = nil --登录推送
	self.m_tDressSuit = nil 
	self.m_tPetEquipSchemeData = nil
	self.m_tFriendBlacklist = {} 
	self.m_tPlayerHomeItemList = nil 
	self.m_nUpdatePlayerHomeItem = 0
	self.m_tBackActivityRedDotList = nil --回流活动红点信息
	self.m_tFreecaRedDotList = nil --福利卡红点信息
	self.m_tMarkCoinData = nil 
	self.m_tProfessionData = nil 
	self.m_tSkillSuit = nil 
	self.m_tSkinStatus = {}
	self.m_tAssistSkill = {}
	self.m_tPlayerLibraryItemList = {}
	self.m_tPlayerLibraryInfo = {}
	GlobalGame.g_isMounts = false
	g_tBusinessCode = nil 
	g_tCellTopHandleObj = {}
	self.m_tFiveTypePackageList = nil 
	self.m_tDefaultShapeBigSkill = nil
	self.m_tShapeBigSkillList = {}
	g_cityExtenInfo = nil 
	self.m_tStarsSpecialAttr = nil
	self.m_tAllFlowerpot = nil 
	self.m_tPlayerFootItemList = nil 
	self.m_tPlayerMountItemList = nil 
	self.m_tHavedAdvanceDressIds = nil 
	self.m_tHavedAdvanceWingIds = nil 
end

--@brief	保存更新玩家升级界面显示的生命，攻击，防御，战斗力四个属性
function CacheCenter:upgradePlayerPro(tPlayer,key,value)
	if key == nil or value == nil then
		GlobalGame.g_upgradePro = {}
		GlobalGame.g_upgradePro.hp = tPlayer.hp
		GlobalGame.g_upgradePro.attack = tPlayer.attack
		GlobalGame.g_upgradePro.defend = tPlayer.defend
		GlobalGame.g_upgradePro.fighting = tPlayer.fighting
		GlobalGame.g_upgradePro.level = tPlayer.level
		GlobalGame.g_upgradePro.zsLevel = tPlayer.zsLevel
		return
	end
	if tostring(key) == "hp" then
		GlobalGame.g_upgradePro.hp = tonumber(tPlayer.hp)
	elseif tostring(key) == "attack" then
		GlobalGame.g_upgradePro.attack = tonumber(tPlayer.attack)
	elseif tostring(key) == "defend" then
		GlobalGame.g_upgradePro.defend = tonumber(tPlayer.defend)
	elseif tostring(key) == "fighting" then
		GlobalGame.g_upgradePro.fighting = tonumber(tPlayer.fighting)
	elseif tostring(key) == "level" then
		GlobalGame.g_upgradePro.level = tonumber(tPlayer.level)
	elseif tostring(key) == "zsLevel" then
		GlobalGame.g_upgradePro.zsLevel = tPlayer.zsLevel
	end
end

--@brief 	重置排行榜缓存
function CacheCenter:resetRankListInfo()
	--body
	self.m_tRankListInfo = nil
end
--@brief    缓存排行榜数据ranking, playerId, name, faceId, headId, sex, level, param1, param2, param3, param4, param5, param6, param7, param8, rankType, trendRank, vipLevel
function CacheCenter:setRankListInfo(ranking, playerId, name, faceId, headId, sex, level, param1, param2, param3, param4, param5, param6, param7, rankType, trendRank, vipLevel, param8, headColor, param9, headEffectId, wifeHeadEffectId, qqHallInfo)
    WZLog("排行榜CacheCenter:setRankListInfo",rankType)
    if self.m_tRankListInfo == nil then
        WZLog("缓存排行榜数据self.m_tRankListInfo == nil")
        self.m_tRankListInfo = {}
    end
    WZLog("type(p1)===",type(ranking),ranking)
    local dataLen = ranking:size()   --数据量
    WZLog("dataLen ====",dataLen)
    if dataLen == 0 then 
    	--彈出沒有數據tips框
    	WndRankList:noDataAtt()
    	return 
    end --没有数据
    local t = {}
    for i = 0,dataLen-1 do
        local temp = {}
        temp.ranking   = ranking:get(i)
        temp.playerId   = playerId:get(i)
        temp.name     = name:get(i)
        temp.faceId   = faceId:get(i)
        temp.headId  = headId:get(i)
        temp.sex 	= sex:get(i)
        temp.level   = level:get(i)
        temp.param1   = param1:get(i)
        temp.param2   = param2:get(i)
        if rankType and tonumber(rankType) == 12 or tonumber(rankType) == 22 then
        	local nParam2 = tonumber(temp.param2)
        	nParam2 = nParam2 + CaculateAllValue(rankType, tonumber(temp.param1))
        	temp.param2 = tostring(nParam2)
        end
        temp.param3   = param3:get(i)
        temp.param4   = param4:get(i)
        temp.param5   = param5:get(i)
        temp.param6   = param6:get(i)
        temp.param7   = param7:get(i)
        temp.vipLevel = vipLevel:get(i)
        temp.param8 = param8:get(i)
        temp.headColor = headColor:get(i)
        temp.param9 = param9:get(i)
        temp.headEffectId = headEffectId:get(i)
        temp.wifeHeadEffectId = wifeHeadEffectId:get(i)
        if qqHallInfo and qqHallInfo:get(i) ~= "" then 
        	temp.qqHallData = json.decode(qqHallInfo:get(i))
        end

        if rankType == 23 then
        	local nParam7 = tonumber(temp.param7)
        	nParam7 = nParam7 + CaculateAllValue(rankType, tonumber(temp.param6))
        	temp.param7 = tostring(nParam7)
        end

        temp.trendRank     = trendRank:get(i)
        table.insert(t,temp)
    end

    local rtype = tonumber(rankType)
    self.m_tRankListInfo[rtype] = t
    WZLog("#self.m_tRankListInfo===",#self.m_tRankListInfo)
    WZLog("getn()====",table.getn(self.m_tRankListInfo))
    local tt =  self.m_tRankListInfo[rtype]
    WndRankList:receivedServerData(rtype)

end

--@brief 	获取我的排行榜数据信息
function CacheCenter:setMyRankListInfo(myRank, rankValue, rankExp, myTrendRank, rankType, canWorship)
 	--body
 	WZLog("********* CacheCenter:setMyRankListInfo *************", myRank, rankValue, rankExp, myTrendRank, rankType)

	if self.m_tMyRankListInfo == nil then
		self.m_tMyRankListInfo = {}
	end
	local tTemp = {}
	tTemp.myRank = myRank
	tTemp.rankValue = rankValue
	tTemp.rankExp = rankExp
	tTemp.myTrendRank = myTrendRank
	tTemp.nCanWorship = canWorship
 	local nType = tonumber(rankType)
 	self.m_tMyRankListInfo[nType] = tTemp

 	WndRankList:receiveMyRankListData(nType)
end

--@brief	发送好友列表
-- playerId : 好友Id
-- playerName : 好友名称
-- level : 好友等级
-- sex : 好友性别，0是男，1是女
-- online : 好友是否在线
-- fighting : 玩家战斗力
-- send : 是否可赠送
-- friendType : 好友类型1、正式好友，2、等待审批
-- faceItemId : 脸道具id,没有为0
-- headItemId : 头道具id，没有为0
-- isMentoring：是否是师徒关系
function CacheCenter:setFriendList(playerId, playerName, level, sex, online, fighting, send, friendType, faceItemId, headItemId,appTimer,isMentoring, sendGift, couple, friendNum, isOnlineRemind, vipLevel, offlineTime, serverId, headColor, chum, applychum, mentoringNum, spaceVisitState, remarkName,bodyId, wingId, bodyColor, headEffectId, qqHallInfo, topFriendIds)
    WZLog("CacheCenter:setFriendList", playerId:size())
	local count = playerId:size()
	-- if count== 0 then
	-- 	return
	-- end
	local nMark = 0 
	self.m_tFriend = {}
	for i=0,count-1 do
        WZLog("i==========",playerId:get(i),playerName:get(i),isMentoring:get(i),online:get(i),isOnlineRemind:get(i))
		local temp = {}
		local level , reinc = ChangeLevelReinc(level:get(i))
		temp.id = playerId:get(i)
		temp.name = playerName:get(i)
		temp.level = level
		temp.reinc = reinc
		temp.time = appTimer:get(i)
		temp.sex = sex:get(i)
		temp.isOnline = online:get(i)
		temp.fighting = fighting:get(i)
		temp.send = send:get(i)
		temp.type = friendType:get(i)
		temp.faceItemId = faceItemId:get(i)
		temp.headItemId = headItemId:get(i)
        temp.isMentoring = isMentoring:get(i)
        temp.canSendGift = 1
        temp.relation = couple:get(i)
        temp.friendliness = friendNum:get(i)
        temp.isOnlineRemind = isOnlineRemind:get(i)
        temp.vipLevel = vipLevel:get(i)
        temp.offlineTime = offlineTime:get(i)
        temp.serverId = serverId:get(i)
        temp.headColor = headColor:get(i)
        temp.bBestFriend = chum:get(i)
        temp.moralityLevel = mentoringNum:get(i)
        temp.spaceVisitState = spaceVisitState:get(i)
        temp.remarkName = remarkName:get(i)
        temp.bodyId = bodyId:get(i)
        temp.wingId = wingId:get(i)
        temp.bodyColor = bodyColor:get(i)
        temp.headEffectId = headEffectId and headEffectId:size() > 0 and headEffectId:get(i) or 0
        if qqHallInfo and qqHallInfo:get(i) ~= "" then 
        	temp.qqHallData = json.decode(qqHallInfo:get(i))
        end
        temp.isTop = utilsValueInTable(playerId:get(i), VectorToTable(topFriendIds)) and true or false

		table.insert(self.m_tFriend,temp)
		if tonumber(temp.type) == 2 then
			nMark = nMark + 1 
		end
	end

	self.m_tApplyBestFriendId = {}
	for j = 0, applychum:size() - 1 do
		local applyId = applychum:get(j)
		table.insert(self.m_tApplyBestFriendId, applyId)
	end

	if nMark > 0 then
		self.m_nAppMark = 1		
	end

	if WndFriends.m_root ~= nil then 
		WndFriends:RefreshInterface()
	end 

	--
	self:pushAppFriInDynamicList()
end

--note 		初始化签到缓存数据
function CacheCenter:initSignCacheData()
	self.m_tSignCacheData.idx = 0 
	self.m_tSignCacheData.state = false 
end

--@note 	设置签到缓存数据
function CacheCenter:setSignCacheData( day,state )
	self.m_tSignCacheData.idx = day 	--数据表天数
	self.m_tSignCacheData.state = state --是否需要升级VIP
end

--@brief	上下线协议
-- playerId : 玩家id
-- isOnline : 1、在线，0、离线
-- faceItemId : 脸道具id, 不存在为0
-- headItemId : 头道具id, 不存在为0
function CacheCenter:onlineStatic(playerId, isOnline, faceItemId, headItemId, headColor)
	if self.m_tFriend == nil then 
		return 
	end
	for i,data in pairs(self.m_tFriend) do 
		if data.id == playerId then
			data.isOnline = isOnline
			data.faceItemId = faceItemId
			data.headItemId = headItemId
			data.headColor = headColor
			data.offlineTime = SystemTime:getServerTime()
			--提示好友上线
			if data.isOnlineRemind == 1 and isOnline == 1 then
				WZLog("CacheCenter:onlineStatic", data.name)
				WndChat:showFriendsLoginTips(data.name)
			end
			break 
		end
	end
	WndFriends:RefreshInterface(nil,0)
end

--转换等级,转生
function ChangeLevelReinc(level)
	--if level < GlobalGame.g_ReincPlayerLeve then
	--	return level ,0 
	--end
	--return level - GlobalGame.g_ReincPlayerLeve ,1
	return level,0
end

--添加好友列表
function CacheCenter:addFriendList(playerId, playerName, level, sex, online, fighting, send, friendType, faceItemId, headItemId,appTimer, isMentoring, friendNum, sendGift, vipLevel, serverId, headColor, mentoringNum, headEffectId)
    WZLog("CacheCenter:addFriendList",playerId,playerName)
    --查看好友是否已经在存在
    if self.m_tFriend ~= nil and #self.m_tFriend ~= 0 then
        for i,v in pairs(self.m_tFriend) do
            WZLog("i,id====",i,v.id)
            if v.id == playerId then
                return
            end
        end
    end
	local temp = {}
	local level , reinc = ChangeLevelReinc(level)
	temp.id = playerId
	temp.name = playerName
	temp.level = level
	temp.reinc = reinc
	temp.sex = sex
	temp.time = appTimer
	temp.isOnline = online
	temp.fighting = fighting
	temp.send = send
	temp.type = friendType
	temp.faceItemId = faceItemId
	temp.headItemId = headItemId
	temp.friendliness = friendNum
	temp.canSendGift = 1
	temp.relation = 0
	temp.isMentoring = isMentoring
	temp.isOnlineRemind = 0
	temp.vipLevel = vipLevel
	temp.offlineTime = SystemTime:getServerTime()
	temp.serverId = serverId
	temp.headColor = headColor
	temp.bBestFriend = 0
	temp.moralityLevel = mentoringNum
	temp.spaceVisitState = 0 
	temp.remarkName = ""
	temp.headEffectId = headEffectId or 0

	if self.m_tFriend == nil then
		self.m_tFriend = {}
	end
	table.insert(self.m_tFriend,temp)
	local index = 0 
	WZLog("CacheCenter:addFriendList:::",friendType)
	if friendType == 2 then
		index = 1 
		self.m_nDailyMark = 1
		self:addMark("btnFriend_WndOwnCity",1,2)

		local tempAdd = {}
		tempAdd.id = temp.id
		tempAdd.name = temp.name
		tempAdd.level = temp.level
		tempAdd.typeList = 4
		tempAdd.time = temp.offlineTime
		tempAdd.status = 1
		tempAdd.sendType = 0
		tempAdd.vigor = 0
		tempAdd.friendliness = 0
		tempAdd.faceItemId = faceItemId
		tempAdd.headItemId = headItemId
		tempAdd.sex = sex
		tempAdd.headColor = headColor
		tempAdd.isOnline = isOnline
		tempAdd.vipLevel = vipLevel
		tempAdd.headEffectId = headEffectId or 0
		table.insert(self.m_tDynamic, tempAdd)
		table.sort(self.m_tDynamic, sortDynamicFriends)
	end
	WndFriends:RefreshInterface(index)
end

--审核好友结果
function CacheCenter:ApprovalFriendResult(playerId, result,nType)
	if self.m_tFriend == nil then
		return
	end
	if nType == 2 then--拒绝类型
		for i=0,playerId:size()-1 do 
			for k,data in pairs(self.m_tFriend) do 
				if data.id == playerId:get(i) then
					table.remove(self.m_tFriend,k)
				end
			end
		end
		WndFriends:RefreshInterface(nil, nil, 3)
		return 
	end
	
	--同意类型
	for i=0,playerId:size() - 1 do 		
		if result:get(i) == 1 or result:get(i) == true then
			for k,data in pairs(self.m_tFriend) do 
				if tonumber(data.id) == tonumber(playerId:get(i)) then 
					WZLog("Change friend Approval type")
					data.type = 1
				end
			end
		elseif result:get(i) == 0 or result:get(i) == false then
			for k,data in pairs(self.m_tFriend) do 
				if tonumber(data.id) == tonumber(playerId:get(i)) then 
					table.remove(self.m_tFriend,k)
				end
			end
		end
	end
	WndFriends:RefreshInterface(nil, nil, 3)
end

--@brief 	审核蜜友结果
function CacheCenter:ApprovalBestFriendResult(playerId, result, nType, applychum)
	if self.m_tFriend == nil then
		return
	end
	self.m_tApplyBestFriendId = {}
	for j = 0, applychum:size() - 1 do
		local applyId = applychum:get(j)
		table.insert(self.m_tApplyBestFriendId, applyId)
	end
	if nType == 2 then--拒绝类型
		for i = 1,#self.m_tApplyBestFriendId do 
			if self.m_tApplyBestFriendId[i] == playerId then
				table.remove(self.m_tApplyBestFriendId,i)
				break 
			end
		end
		WndFriends:RefreshInterface(nil, nil, 3)
		return 
	end
	
	--同意类型
	if result == 1 or result == true then
		for k,data in pairs(self.m_tFriend) do 
			if data.id == playerId then 
				WZLog("ApprovalBestFriendResult")
				data.bBestFriend = 1
			end
		end
	else
		for i = 1,#self.m_tApplyBestFriendId do 
			if self.m_tApplyBestFriendId[i] == playerId then
				table.remove(self.m_tApplyBestFriendId,i)
				break 
			end
		end
	end

	WndFriends:RefreshInterface(nil, nil, 3)
end

--@brief 刷新好友类表中的玩家类型
function CacheCenter:updateFriendRelations( nId )
	for k,data in pairs(self.m_tFriend) do 
		if tonumber(data.id) == tonumber(nId) then 
			data.type = 1
		end
	end
	WndFriends:RefreshInterface()
end

function CacheCenter:setDynamicCount(vigorNum)
	self.m_nHaveVigor = vigorNum
end

function CacheCenter:checkDynamicDeduplication(tDynamic,playerId, typeList)
	if self.m_tDynamic == nil or #self.m_tDynamic == 0 then
		return true
	end
	for i,data in pairs(self.m_tDynamic) do 
		if tonumber(data.id) == tonumber(playerId) and tonumber(data.typeList) == tonumber(typeList) then
			return false 
		end
	end
	return true
end

--@brief 	将列表中的好友申请数据，添加进动态表中
function CacheCenter:pushAppFriInDynamicList()
	-- body
	if self.m_tDynamic == nil then
		self.m_tDynamic = {}	
	end
	local tDynamic = CopyTable(self.m_tDynamic)
	local tFriendList = self:getFriendList()
	if tFriendList == nil then return end
	local nMark = 0

	for i = 1, #tFriendList do
		local bIsExist = false
		for j = 1, #self.m_tDynamic do
			if self.m_tDynamic[j].id == tFriendList[i].id and self.m_tDynamic[j].typeList == 4 and tFriendList[i].type == 2 then
				bIsExist = true
				break
			elseif self.m_tDynamic[j].id == tFriendList[i].id and self.m_tDynamic[j].typeList == 7 then
				bIsExist = true
			end
		end
		--好友申请
		if not bIsExist then
			if tFriendList[i].type == 2 then
				local temp = {}
				temp.id = tFriendList[i].id
				temp.name = tFriendList[i].name
				temp.level = tFriendList[i].level 
				temp.typeList = 4
				temp.time = tFriendList[i].offlineTime
				temp.status = 1
				temp.sendType = 0
				temp.vigor = 0
				temp.friendliness = 0
				temp.serverId = tFriendList[i].serverId
				temp.headItemId = tFriendList[i].headItemId
				temp.faceItemId = tFriendList[i].faceItemId
				temp.headColor = tFriendList[i].headColor
				temp.sex = tFriendList[i].sex
				temp.isOnline = tFriendList[i].isOnline
				temp.vipLevel = tFriendList[i].vipLevel
				temp.headEffectId = tFriendList[i].headEffectId
				table.insert(self.m_tDynamic, temp)
				if tonumber(temp.status) == 1 then
					nMark = nMark + 1
				end
			else
				for k = 1, #self.m_tApplyBestFriendId do
					if tFriendList[i].id == self.m_tApplyBestFriendId[k] then
						local temp = {}
						temp.id = tFriendList[i].id
						temp.name = tFriendList[i].name
						temp.typeList = 7
						temp.time = tFriendList[i].offlineTime
						temp.status = 1
						temp.sendType = 0
						temp.vigor = 0
						temp.friendliness = 0
						temp.serverId = tFriendList[i].serverId
						temp.headItemId = tFriendList[i].headItemId
						temp.faceItemId = tFriendList[i].faceItemId
						temp.headColor = tFriendList[i].headColor
						temp.sex = tFriendList[i].sex
						temp.isOnline = tFriendList[i].isOnline
						temp.vipLevel = tFriendList[i].vipLevel
						temp.headEffectId = tFriendList[i].headEffectId
						table.insert(self.m_tDynamic, temp)
						if tonumber(temp.status) == 1 then
							nMark = nMark + 1
						end
					end
				end
			end
		end
	end

	if nMark > 0 then 	
		self.m_nDailyMark = 1
		self:addMark("btnFriend_WndOwnCity",1,2)
	end
end

--好友动态列表
function CacheCenter:setDynamicFriendList(playerId, playerName, typeList, date, acceptType,sendType, vigor, friendNum, vigorNum, idonly,faceItemId,headItemId,sex,headColor,isOnline,vipLevel, headEffectId)	
	self.m_nHaveVigor = vigorNum
	local bIsUpdateCache = true 	--是否为更新缓存信息
	if self.m_tDynamic == nil then
		self.m_tDynamic = {}	
		bIsUpdateCache = false 	--
	end
	local tDynamic = CopyTable(self.m_tDynamic)
    WZLog("CacheCenter:setDynamicFriendList",vigorNum,#tDynamic, playerId:size())
    self.m_tDynamic = {}
	local nMark = 0
	local nDoubleMark = 0 
	for i=0,playerId:size()-1 do 
		local temp = {}
		local id = playerId:get(i)
		local nTypeList = typeList:get(i)
--        WZLog("i===",id,playerName:get(i),acceptType:get(i),vigor:get(i))
		temp.id = id
		temp.name = playerName:get(i)
		temp.typeList = typeList:get(i)
		temp.time = date:get(i)
		temp.status = acceptType:get(i)
		temp.sendType = sendType:get(i)
		temp.vigor = vigor:get(i)
		temp.friendliness = friendNum:get(i)
		temp.onlyId = idonly:get(i)
		temp.faceItemId = faceItemId:get(i)
		temp.headItemId = headItemId:get(i)
		temp.sex = sex:get(i)
		temp.headColor = headColor:get(i)
		temp.isOnline = isOnline:get(i)
		temp.vipLevel = vipLevel:get(i)
		temp.headEffectId = headEffectId and headEffectId:size() > 0 and headEffectId:get(i) or 0
		table.insert(self.m_tDynamic,temp)
		if tonumber(temp.status) == 1 and temp.typeList == 1 then
			nMark = nMark + 1
		end
		if temp.typeList == 9 then 
			temp.status = 1
			nDoubleMark = nDoubleMark + 1
		end
--		WZLog("acceptType:::",nMark,vigorNum)
		--WZLog("***setDynamicFriendList Temp *****", Serialize(temp))
	end	
	--Add By Tianxiang_Xu
	--限制当领取次数达到最高的次数时，动态不显示红点
	local Maxcount = GetReceiveUpper(CacheCenter:getPlayerInfo().vipLevel) 
	if self.m_nHaveVigor >= Maxcount then
		nMark = 0 
	end
	--如果更新动态缓存信息，则重新添加审批好友动态数据
	if bIsUpdateCache then
		if WndFriends.m_root then
			self:pushAppFriInDynamicList()
			table.sort(self.m_tDynamic, sortDynamicFriends)
			--WZLog("CacheCenter:setDynamicFriendList 0000",Serialize(self.m_tDynamic))
			WndFriends:RefreshDynamicList()
		end
	end
	--End Add 
	if nMark > 0 or nDoubleMark > 0 then 	
		self.m_nDailyMark = 1
		self:addMark("btnFriend_WndOwnCity",1,2)
		WndFriends:showDynamicMark(true)
	end
end
--删除好友
function CacheCenter:delFriendList(playerId)
	for i,data in pairs(self.m_tFriend) do 
		for k=0,playerId:size()-1 do 
			if tonumber(data.id) == tonumber(playerId:get(k)) then
				table.remove(self.m_tFriend,i)
			end
		end
	end

	WndFriends:DelFriendSuccess()
end

--@brief 	申请密友成功
function CacheCenter:applyBestFriendSuccess(playerId, result)
	-- body
	WndFriends:closeLoading()
	--WZLog("CacheCenter:applyBestFriendSuccess", Serialize(VectorToTable(playerId)), Serialize(VectorToTable(result)))
    local count = result:size()
	local num = 0 
	if count == 1 then
		if result:get(0) == 0 then
			MsgBoxManager:showTipBox(LocalStrings.FRIENDS_BESTFRIEND12)
		elseif result:get(0) == 1 then
			WndOnlineHintFriend:onCloseActionCallback(nil)
			MsgBoxManager:showTipBox(LocalStrings.FRIENDS_BESTFRIEND11)
		elseif result:get(0) == 2 then
			MsgBoxManager:showTipBox(LocalStrings.FRIENDS_BESTFRIEND13)
		elseif result:get(0) == 3 then
			MsgBoxManager:showTipBox(LocalStrings.FRIENDS_BESTFRIEND14)
		elseif result:get(0) == 4 then
			local name = self:getFriendNameById(playerId:get(0))
			MsgBoxManager:showTipBox(name .. LocalStrings.FRIENDS_BESTFRIEND10)
		end
		return
	end

	local fullNum = 0
	local name = ""
	for i = 0, result:size() - 1 do
		if result:get(i) == 4 then
			fullNum = fullNum + 1 
			if name == "" then
				name = self:getFriendNameById(playerId:get(i))
			else
				name = name .. "," .. self:getFriendNameById(playerId:get(i))
			end
		end
	end

	if fullNum > 0 then
		MsgBoxManager:showTipBox(name .. LocalStrings.FRIENDS_BESTFRIEND10)
		return 
	end

	WndOnlineHintFriend:onCloseActionCallback(nil)
	MsgBoxManager:showTipBox(LocalStrings.FRIENDS_BESTFRIEND11)
end

--@brief 	解除密友成功
function CacheCenter:removeBestFriendList(playerId)
	for i,data in pairs(self.m_tFriend) do 
		if tonumber(data.id) == tonumber(playerId) then
			data.bBestFriend = 0 
		end
	end

	WndFriends:removeBestFriendSuccess(tonumber(playerId))
end

--@brief 	重新更新提示好友上线数据
function CacheCenter:resetRemindFriends(tNeedRemindList)
	--body
	for i,data in pairs(self.m_tFriend) do 
		data.isOnlineRemind = 0
		for k = 1, #tNeedRemindList do 
			if tonumber(data.id) == tNeedRemindList[k].id then
				data.isOnlineRemind = 1
			end
		end
	end
end

--@brief 	重新更新置顶好友数据
function CacheCenter:resetTopFriends(tNeedTopList)
	--body
	for i,data in pairs(self.m_tFriend) do 
		data.isTop = false
		for k = 1, #tNeedTopList do 
			if tonumber(data.id) == tNeedTopList[k].id then
				data.isTop = true
			end
		end
	end
end

--@brief	操作协议
-- playerId : 好友Id
-- acceptType : 状态1、可领取，0、已领取
--@param 	sendType:1->可以赠送活力；0->已结赠送过
function CacheCenter:OperationFriendOK(playerId, acceptType,vigorNum, sendType, friendNum)
	self.m_nHaveVigor = vigorNum
	if self.m_tFriend == nil then
		return
	end
	--WZLog("CacheCenter:OperationFriendOK",Serialize(VectorToTable(playerId)), Serialize(VectorToTable(acceptType)), Serialize(VectorToTable(sendType)))
	local itemIdx = 0
	local count = playerId:size()
	if self.m_tDynamic then 
		for i,data in pairs(self.m_tDynamic) do 
			for k=0,count-1 do 
				if data.id == playerId:get(k) and (data.typeList == 1 or data.typeList == 6) then 
					WZLog("CacheCenter:OperationFriendOK:",acceptType:get(k),data.id,data.typeList)
					if data.typeList == 6 then
						data.status = 0
						data.sendType = 0
					else
						data.status = acceptType:get(k)
						data.sendType = sendType:get(k)
					end
					itemIdx = i
				end
			end
		end
	end
	
	for j,u in pairs(self.m_tFriend) do 
		for n=0,count - 1 do 
			if u.id == playerId:get(n) then
				if acceptType:get(n) == 2 then 
					u.send = true 
				else
				 	u.send = false
				 	itemIdx = j 
				 	u.friendliness = friendNum:get(n)
				end
			end
		end
	end
	--WZLog("====== 下标测试"..itemIdx)
	if self.m_bOneKeyOperator_Friends then 
		itemIdx = 0 
		self.m_bOneKeyOperator_Friends = false 
	end 
	WndFriends:RefreshInterface(nil,nil,itemIdx,nil,playerId)
	WndFriends:showResultForOperator(vigorNum, playerId)
end

--@brief 	赠送好友礼物成功
--@param 	result：0赠送失败，大于0，则为增加的好友度
--@param 	playerId:好友Id
--@param 	sendType :1可赠送；0不可赠送 
function CacheCenter:giveFriendGiftOK(result, playerId, sendType)
	--body
	WZLog("CacheCenter:giveFriendGiftOK", result, playerId:size())
	local itemIdx = 0
	for j = 0, playerId:size() - 1 do
		WZLog("CacheCenter:giveFriendGiftOK 00", playerId:get(j))
		for i = 1, #self.m_tFriend do
			if self.m_tFriend[i].id == playerId:get(j) and self.m_tFriend[i].type == 1 then
				WZLog("CacheCenter:giveFriendGiftOK", sendType:get(j), self.m_tFriend[i].id)
				self.m_tFriend[i].canSendGift = 1
				itemIdx = i
				break
			end
		end
	end

	WndFriends:RefreshInterface(nil,nil,itemIdx, result)
	WndCheckOther:giveGiftOk(result)
end

--@brief 	送礼后，增加好友度
--@param 	friendId : 好友的id
function CacheCenter:UpdateFriendLinessAfterGift(friendId, result)
	-- body
	WZLog("CacheCenter:UpdateFriendLinessAfterGift")
	for i = 1, #self.m_tFriend do
		if self.m_tFriend[i].id == friendId and self.m_tFriend[i].type == 1 then
			self.m_tFriend[i].friendliness = self.m_tFriend[i].friendliness + result
			local nMaxFriendliness = tonumber(CacheCenter:getGameParam()["maxFriendNum"]) or 99999
			if self.m_tFriend[i].friendliness > nMaxFriendliness then
				self.m_tFriend[i].friendliness = nMaxFriendliness
			end
			WZLog("CacheCenter:UpdateFriendLinessAfterGift", self.m_tFriend[i].friendliness)
			break
		end
	end
end

--删除好友动态
function CacheCenter:delDynamicFriendList(playerId)
	if self.m_tDynamic == nil then
		return
	end
	local count = playerId:size()
	for i,data in pairs(self.m_tDynamic) do 
		for k=0,count-1 do 
			if data.id == playerId:get(k) then
				table.remove(self.m_tDynamic,i)
			end
		end
	end
	WndFriends:RefreshInterface()
	WndFriends:showDynamicMark(false)
end

--获取好友列表
function CacheCenter:getFriendList()
	return self.m_tFriend
end

--获得当前已通过审批的好友列表
function CacheCenter:getCurrentFriendList(  )
	self.m_tCurrentFriends = {} 
	
	if  self.m_tFriend ~= nil  then 
		for i,data in pairs(self.m_tFriend) do
			if data.type == 1 then 
				table.insert(self.m_tCurrentFriends,data)
			end 
		end
	end 
	return self.m_tCurrentFriends
end

--判断玩家ID是否在玩家好友列表中
--return true  该ID在好友列表中
--return false 该ID不在好友列表中 
function CacheCenter:judgeIsContainsById( nId )
	local m_tFriendsList = self:getCurrentFriendList()
	for i,v in pairs (m_tFriendsList) do
		if v.id == nId then 
			return true
		end 
	end
	return false 
end

--根据名字判断是否为好友
function CacheCenter:isFriendByName(playerName)
	local m_tFriendsList = self:getCurrentFriendList()
	for i,v in pairs (m_tFriendsList) do
		if v.name == playerName then 
			return true
		end 
	end
	return false 
end

--获取好友数量
function CacheCenter:getFriendCount()
	local count = 0 
	if self.m_tFriend == nil or #self.m_tFriend == 0 then
		return count
	end
	for i,data in pairs(self.m_tFriend) do 
		if data.type == 1 then
			count = count + 1 
		end
	end
	return count
end
--获取好友动态列表
function CacheCenter:getDynamicFriendList()
	return self.m_tDynamic
end
--@brief 更新好友动态数据
function CacheCenter:updateDynamicList(tData)
	-- body
	--WZLog("CacheCenter:updateDynamicList", Serialize(tData))
	for i = 1, #self.m_tDynamic do
		if self.m_tDynamic[i].id == tData.id and self.m_tDynamic[i].typeList == tData.typeList then
			table.remove(self.m_tDynamic, i)
			break
		end
	end
end
--今日领取次数
function CacheCenter:getTodayRecvVigor()	
	return self.m_nHaveVigor or 0  
end

function CacheCenter:setFriendDataList(playerId, playerName, level, sex ,faceItemId ,headItemId,isMentoring,playerFighting, friendNum, isOnline, vipLevel, tournamentLevel, serverId, headColor, isChum, mentoringNum, couple, useType, professionId, status, bodyId, wingId, assistSize, headEffectId, qqHallInfo, topFriendIds)
	WZLog("CacheCenter:setFriendDataList", useType)
	if useType == 3 or useType == 6 or useType == 11 or useType == 12 or useType == 20 then 
		local tFriendList = {}
		for i=0,playerId:size()-1 do 
			local level , reinc = ChangeLevelReinc(level:get(i))
			local temp = {}
			temp.level = level
			temp.reinc = reinc
			temp.id = playerId:get(i)
			temp.name = playerName:get(i)		
			temp.sex = sex:get(i)		
			temp.faceItemId = faceItemId:get(i)
			temp.headItemId = headItemId:get(i)
			temp.isMentoring = isMentoring:get(i)
			temp.fighting = playerFighting:get(i)
			temp.friendliness = friendNum:get(i)
			temp.isOnline = isOnline:get(i)
			temp.vipLevel = vipLevel:get(i)
			temp.tournamentLevel = tournamentLevel:get(i)
			temp.serverId = serverId:get(i)
			temp.headColor = headColor:get(i)
			temp.bBestFriend = isChum:get(i)
			temp.moralityLevel = mentoringNum:get(i)
			temp.relation = couple:get(i)
			temp.professionId = professionId:get(i)
			temp.status = status:get(i)
			temp.bodyId = bodyId:get(i)
			temp.wingId = wingId:get(i)
			temp.assistSize = assistSize:get(i)
			temp.headEffectId = headEffectId and headEffectId:size() > 0 and headEffectId:get(i) or 0
			if qqHallInfo and qqHallInfo:size() > 0 and qqHallInfo:get(i) and qqHallInfo:get(i) ~= "" then 
				temp.qqHallData = json.decode(qqHallInfo:get(i))
			end
	        temp.isTop = utilsValueInTable(playerId:get(i), VectorToTable(topFriendIds)) and true or false

			table.insert(tFriendList,temp)
		end
		if useType == 3 and SceneRoom.m_root and SceneRoom.m_tData and SceneRoom.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_LX and WndFriendList.m_root then 
			self.m_tFriendList = CopyTable(tFriendList)
			self:_receiveFriendListData()
		else
			WndRoomInviteList:receiveFriendListData(tFriendList)
		end
	else
		self.m_tFriendList = {}
		for i=0,playerId:size()-1 do 
			local level , reinc = ChangeLevelReinc(level:get(i))
			local temp = {}
			temp.level = level
			temp.reinc = reinc
			temp.id = playerId:get(i)
			temp.name = playerName:get(i)		
			temp.sex = sex:get(i)		
			temp.faceItemId = faceItemId:get(i)
			temp.headItemId = headItemId:get(i)
			temp.isMentoring = isMentoring:get(i)
			temp.fighting = playerFighting:get(i)
			temp.friendliness = friendNum:get(i)
			temp.isOnline = isOnline:get(i)
			temp.vipLevel = vipLevel:get(i)
			temp.tournamentLevel = tournamentLevel:get(i)
			temp.serverId = serverId:get(i)
			temp.headColor = headColor:get(i)
			temp.bBestFriend = isChum:get(i)
			temp.moralityLevel = mentoringNum:get(i)
			temp.relation = couple:get(i)
			temp.status = status:get(i)
			temp.bodyId = bodyId:get(i)
			temp.wingId = wingId:get(i)
			temp.assistSize = assistSize:get(i)
			temp.headEffectId = headEffectId and headEffectId:size() > 0 and headEffectId:get(i) or 0
			if qqHallInfo and qqHallInfo:size() > 0 and qqHallInfo:get(i) and qqHallInfo:get(i) ~= "" then 
				temp.qqHallData = json.decode(qqHallInfo:get(i))
			end
	        temp.isTop = utilsValueInTable(playerId:get(i), VectorToTable(topFriendIds)) and true or false

			table.insert(self.m_tFriendList,temp)
			WZLog("CacheCenter:setFriendDataList::",temp.id,temp.name,#self.m_tFriendList)
		end
		self:_receiveFriendListData()
	end
end

function CacheCenter:getFriendDataList()
	return self.m_tFriendList
end

function CacheCenter:updateDynamicAccept(playerId, timer)
	if self.m_tDynamic == nil or #self.m_tDynamic == 0 then
		return
	end
	for i,data in pairs(self.m_tDynamic) do 
		if tonumber(data.id) == tonumber(playerId) then
			data.time = timer
			WndFriends:setDynamicData(self.m_tDynamic)
			return
		end
	end
	
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief     初始化玩家财富列表
function CacheCenter:_setMoneyList()
	self.m_tMoneyList = {}
	self.m_tMoneyList.blueDiamond = 0  --蓝钻
	self.m_tMoneyList.gold = 0  --金币
	self.m_tMoneyList.medal = 0  --勋章
	self.m_tMoneyList.athMoney = 0  --竞技金币
	self.m_tMoneyList.pet = 0  --宠物蛋壳
	self.m_tMoneyList.bless= 0  --祝福碎片
	self.m_tMoneyList.reel = 0	-- 紫装卷轴
	self.m_tMoneyList.blessMedal = 0 --祈福勋章
	self.m_tMoneyList.card = 0 	--卡牌系统卡币
	self.m_tMoneyList.gemCoin = 0 	--矿晶
	self.m_tMoneyList.phantomCoin = 0 	--幻化晶石
	self.m_tMoneyList.ticket = 0  --礼券
	self.m_tMoneyList.lotteryCoin = 0 --抽奖代币
	self.m_tMoneyList.vnPinkDiamond = 0 --越南粉钻

	local list = self.m_tPlayerItemList
	if list == nil then return end
	for i=1,#list do
		if list[i].id == 1 then
			self.m_tMoneyList.blueDiamond = list[i].lastNum  --蓝钻
		end
		if list[i].id == 2 then
			self.m_tMoneyList.gold = list[i].lastNum  --金币
		end
		if list[i].id == 11 then
			self.m_tMoneyList.athMoney = list[i].lastNum  --金币
		end
		if list[i].id == 22 then
			self.m_tMoneyList.bless = list[i].lastNum --祝福碎片
		end
		if list[i].id == 23 then
			self.m_tMoneyList.blessMedal = list[i].lastNum --祝福碎片
		end
		if list[i].id == 26 then
			self.m_tMoneyList.card = list[i].lastNum --卡币
		end
		if list[i].id == 58 then
			self.m_tMoneyList.gemCoin = list[i].lastNum
		end
		if list[i].id == 60 then
			self.m_tMoneyList.diceCoin = list[i].lastNum --骰子
		end
		if list[i].id == 61 then
			self.m_tMoneyList.phantomCoin = list[i].lastNum
		end
		if list[i].id == 70 then
			self.m_tMoneyList.ticket = list[i].lastNum
		end
		if list[i].id == 107 then
			self.m_tMoneyList.pet = list[i].lastNum  --宠物碎片
		end
		if list[i].id == 166 then
			self.m_tMoneyList.reel = list[i].lastNum
		end
		if list[i].id == 96 then
			self.m_tMoneyList.lotteryCoin = list[i].lastNum
		end
		if list[i].id == 177 then --越南粉钻
			self.m_tMoneyList.vnPinkDiamond = list[i].lastNum
		end
		-- WZLog("CacheCenter:_setMoneyList1",list[i].id,self.m_tMoneyList.lotteryCoin)
	end
	WZLog("CacheCenter:_setMoneyList2",self.m_tMoneyList.blueDiamond,self.m_tMoneyList.gold, self.m_tMoneyList.card, self.m_tMoneyList.ticket,self.m_tMoneyList.lotteryCoin)
end

--@brief     检查玩家是否升级
function CacheCenter:_checkPlayerUpgrade(bUpLevel)
	if bUpLevel == true then
		return
	end
	if GlobalGame.g_upgradePro.level == nil then
		return
	end
	local beforeLevel = GlobalGame.g_upgradePro.level or 1 
	local afterLevel = CacheCenter:getPlayerInfo().level or 1
	WZLog("CacheCenter:_checkPlayerUpgrade:",beforeLevel,afterLevel,GlobalGame.g_bIfInBattle,self:_checkUNOpenUpgrade())
	if beforeLevel < afterLevel then
		if GlobalGame.g_bIfInBattle == false and self:_checkUNOpenUpgrade() == true then
			WndUpgrade:showInfo()
			GlobalGame.g_bIfLevelUp = false
		else
			GlobalGame.g_bIfLevelUp = true
		end
	end
end

--@brief     检查升级界面是否显示
function CacheCenter:_checkUNOpenUpgrade()
	local sName = PushWeibo.SceneName
    WZLog("CacheCenter:_checkUNOpenUpgrade",tostring(sName))
	if tostring(sName) == "ScenceBattleSettlment" then   --战斗结算
		return false
	elseif tostring(sName) == "SceneThrowingEggs" then--砸蛋界面
		return false
	elseif tostring(sName) == "SceneBattle" then--战斗界面
		return false
	elseif tostring(sName) == "SceneBattleLoading" then--装备进入战斗界面
		return false
	else
		return true
	end
end

function CacheCenter:addMark(name,index,nTag)
	local isAdd = true
	if index == 0 then
		isAdd = false 
	end

	local name2 = name
	local isFriend = false
	if name == "btnFriend_WndOwnCity" then
		isFriend = true
	end
	local elementObj = WndOwnCity.m_root

	if name == "btnMail_WndOwnCity" or name == "btnFriend_WndOwnCity" then
		elementObj = SceneCity.m_tWndBottomBarObj and SceneCity.m_tWndBottomBarObj.m_root
		if name == "btnMail_WndOwnCity" then
			name2 = "btnMail_WndBottomBar"
		elseif name == "btnFriend_WndOwnCity" then
			name2 = "btnFriend_WndBottomBar"
		end
	end

	if isFriend then
		elementObj = WndOwnCity.m_root
	end
	WZLog("CacheCenter:addMark one", name, tostring(elementObj), tostring(GlobalGame.g_tWndBottomBarObj), tostring(GlobalGame.g_tWndBottomBarObj and GlobalGame.g_tWndBottomBarObj.m_root))

    if elementObj then
		local btn = WZUIButton:luaTo(elementObj:getChildElement(name2))

        if btn and btn:getChildByTag(2560) then
            btn:removeChildByTag(2560,true)
        end
        
		--Add By Tianxiang_Xu
		if nTag == 2 and (WndFriends.m_root == nil or (WndFriends.m_root and WndFriends.m_nCheckIndex ~= 3)) then --动态
			local Maxcount = GetReceiveUpper(CacheCenter:getPlayerInfo().vipLevel)
			if self.m_nHaveVigor >= Maxcount then
				isAdd = false 
			end
		elseif nTag == 2 and (WndFriends.m_root and WndFriends.m_nCheckIndex == 3) and self.m_nDailyMark == 1 then --当处于动态界面时，收到新的可领取的活力，则返回主城时，主城好友按钮不显示红点
			self.m_nDailyMark = 0
			isAdd = false
		end

		if name == "btnMail_WndOwnCity" or name == "btnFriend_WndOwnCity" then
			local AllBtn = GetElement(elementObj,"btnSwitch_WndBottomBar",WZUIButton)
		    if AllBtn then 
		    	local allred = elementObj:getLuaObjectIndex().m_bRed-- or CacheCenter:getRedState("btnFriend") or CacheCenter:getRedState("btnMail") --1.6.4设置邮箱好友移至右上角，这里的红点不显示
		    	if elementObj:getLuaObjectIndex().m_nMoveDirection == 0 then
		    		--allred = CacheCenter:getRedState("btnFriend") or CacheCenter:getRedState("btnMail")--1.6.4设置邮箱好友移至右上角，这里的红点不显示
		    	else
		    		allred = elementObj:getLuaObjectIndex().m_bRed
		    	end
			    WZLog("CacheCenter:addMark two", isAdd, allred)
			    if allred then
			    	if not AllBtn:getChildByTag(89) then
			            local spr_redPoint =  CCSprite:create("ui/common/common_icon_xiaodianzhui.png")
			            AllBtn:addChild(spr_redPoint,5,89)

			            local position = ccp(45,45)
			            spr_redPoint:setPosition(position)
			        end
			    else 
			    	if AllBtn:getChildByTag(89) then 
			    		AllBtn:removeChildByTag(89,true)
			    	end
			    end
			end
		end

		if isAdd then
			--End Add 
			local img = WZUIImage:create()
			img:setFile("ui/common/common_icon_xiaodianzhui.png")
	        img:setTouchEnable(false)
			img:setUseOriginSize(true)
			img:setTag(2560)
			img:setColor(ccc3(255,255,255))
			img:setAnchorPoint(ccp(1,1))
			if name == "btnMail_WndOwnCity" or name == "btnFriend_WndOwnCity" then
				img:setRelativePosition(ccp(1,1))
				img:setScale(1)
			else
				img:setRelativePosition(ccp(0.9,0.9))
			end
			if btn then
				btn:addChild(img,10)
			end
			if nTag == 1 then--审核
				self.m_nAppMark = 1
			end
			if nTag == 2 and (WndFriends.m_root == nil or (WndFriends.m_root and WndFriends.m_nCheckIndex ~= 3)) then --动态
				self.m_nDailyMark = 1 
				WndFriends:showDynamicMark(true)
			end
			if nTag == 3 then --邮箱
				self.m_nMailMark = 1
			end
		end
	end

	-- if name == "btnFriend_WndOwnCity" then
	-- 	isAdd = isAdd or GlobalGame.g_tRedPointTypeList[300] or GlobalGame.g_tRedPointTypeList[301] or GlobalGame.g_tRedPointTypeList[302]
	-- 	CacheCenter:setRedState("btnFriend",isAdd)
    --     GlobalGame:getBtnRedPointEvent():dispatcher()
    -- end

    if name == "btnMail_WndOwnCity" then
		CacheCenter:setRedState("btnMail",isAdd)
        GlobalGame:getBtnRedPointEvent():dispatcher()
    end
end

-- 初始化红点信息
function CacheCenter:initRedInfo()
    if self.m_bInitRedPointFlag then return end
    self.m_bInitRedPointFlag = true
    self.m_tRedPoint = {
        left = {
            btnNotice =     {state = false, index = 1},      -- 公告
            btnMail =       {state = false, index = 2},      -- 邮件
            btnFriend =     {state = false, index = 3},      -- 好友
            btnTeach =      {state = false, index = 4},      -- 指引
            btnSet =        {state = false, index = 5}       -- 设置
        },
        right = {
            btnBag =        {state = false, index = 1},      -- 背包
            btnItem =       {state = false, index = 2},      -- 道具
            btnStrong =     {state = false, index = 3},      -- 锻造
            btnPet =        {state = false, index = 4},      -- 宠物
            btnMount =      {state = false, index = 5},      -- 坐骑
            btnTask =       {state = false, index = 6},      -- 任务
            btnChat =       {state = false, index = 7},      -- 聊天
            btnBless_ExtendUp =    {state = false, index = 8},   -- 修炼
            btnPractice_ExtendUp = {state = false, index = 9},   -- 修炼
            btnCard_ExtendUp = 	   {state = false, index = 10},  -- 卡牌
            btnFriend =     {state = false, index = 11},      -- 好友
            btnRune =     {state = false, index = 12},      -- 符文
            btnFootMark  = {state = false,index = 13},		--足迹
            btnCastSoul  = {state = false,index = 15},		--时装注魂
            btnBlessBag  = {state = false,index = 16},		--祈福背包
            gemMounting_btnStrong = {state = false,index = 17},		--宝石镶嵌-锻造
            btnUnion  = {state = false,index = 18},		--聯盟
        },
        up = {
            btnRank =       {state = false, index = 1},     -- 排位赛
            btnKing =       {state = false, index = 2},     -- 弹王赛
            btnActivity =   {state = false, index = 3},     -- 活动
            btnliveness =   {state = false, index = 4},     -- 活跃度
            btnFund =       {state = false, index = 5},     -- 成长基金
            btnSign =       {state = false, index = 6},     -- 签到
            btnRecharge =   {state = false, index = 7}      -- 充值
        }
    }
end

-- 设置红点的状态
-- btnName btn的名字{btnBag，.....}见函数CacheCenter:initRedInfo 如果btnName为空，则更新node上面的所有btn
-- state 红点状态，true为添加红点，false为去掉红点
function CacheCenter:setRedState(btnName,state,note)
    WZLog("--------------setRedState---------------------",btnName,state,note)

    if btnName == "btnChat" and WndBattleHud.m_root then
        local btn = GetElement(WndBattleHud.m_root,"btnChat_WndBattleHud")
        SceneCity:setRedPoint(btn,state,ccp(70,70))
        WZLog("CacheCenter:setRedState two")
    end

    if not self.m_bInitRedPointFlag then self:initRedInfo() end
    for pos, data in pairs(self.m_tRedPoint) do
        for k,v in pairs(data) do
            if k == btnName then
                v.state = state
                return
            end
        end
    end
end

--note 获得指定按钮的红点状态
function CacheCenter:getRedState( btnName )
	for pos, data in pairs(self.m_tRedPoint) do
        for k,v in pairs(data) do
            if k == btnName then
                return v.state
            end
        end
    end
end

--  更新对应位置的红点
-- pos为位置，pos ={"left","right"}
-- node 为根节点
-- btnName btn的名字{btnBag，.....}见函数CacheCenter:initRedInfo 如果btnName为空，则更新node上面的所有btn
function CacheCenter:updateRedPoint(pos,node,btnName,note)
--    WZLog("CacheCenter:updateRedPoint1", note, tostring(pos), tostring(node), tostring(SceneCity.m_tWndBottomBar))
    local leftBtnName = {   "btnNotice_WndOwnCity","btnMail_WndOwnCity","btnFriend_WndOwnCity",
        "btnGuide_WndOwnCity","btnSet_WndOwnCity" }
    local rightBtnName = {  "btnPlayer_WndBottomBar","btnItem_WndBottomBar","btnStrong_WndBottomBar",
         "btnPet_WndBottomBar","btnMount_WndBottomBar","btnTask_WndBottomBar","btnChat_WndBottomBar",
         "btnBless_ExtendUp_WndBottomBar","btnPractice_ExtendUp_WndBottomBar","btnCard_ExtendUp_WndBottomBar",
         "btnFriend_WndBottomBar","btnRune_WndBottomBar","btnFootMark_WndBottomBar","btnPhantom_WndBottomBar",
         "btnCastSoul_WndBottomBar","btnBlessBag_other","btnStrong_WndBottomBar2","btnUnion_WndBottomBar"}

    if not node then return end
    if not pos then return end

    local name,data,position,scale
    if pos == "left" then
        name = leftBtnName
        data = self.m_tRedPoint.left
        position = ccp(45,53)
        scale = 1
    elseif pos == "right" then
        name = rightBtnName
        data = self.m_tRedPoint.right
        position = ccp(45,53)
        if btnName == "btnChat" then
        	if (SceneCity.m_tWndBottomBar and node == SceneCity.m_tWndBottomBar) then
		        position = ccp(72,72)
		    else
	            position = ccp(45,45)
	        end
	   	elseif btnName == "btnPet" or btnName == "btnFootMark" or btnName == "btnMount" or btnName == "btnPhantom" then
	        position = ccp(54,53)
	   	elseif btnName == "btnFriend" then
		    position = ccp(28,28)
	    end
    end

    if data == nil then
        return
    end
    -- 设置btn的红点状态
    local function setRedPoint(btn,state, position0, scale)
    	if btn == nil then return end
        if state then
            if not btn:getChildByTag(88) then
                local spr =  CCSprite:create("ui/common/common_icon_xiaodianzhui.png")
                btn:addChild(spr,5,88)
                spr:setPosition(position0 or position)
                if scale then
                	spr:setScale(scale)
                end
            end
        else
            if btn:getChildByTag(88) then btn:removeChildByTag(88,true) end
        end
    end

    if btnName then
        local curData
        for k,v in pairs(data) do
            if k == btnName then  curData = v  end
        end
        if curData then
--        	WZLog("CacheCenter:updateRedPoint2_0", name[curData.index])
            local btn = GetElement(node,name[curData.index],WZUIButton)
--            WZLog("CacheCenter:updateRedPoint2_1", name[curData.index], btn)
            if name[curData.index] == "btnTask_WndBottomBar" and (SceneCity.m_tWndBottomBar and node == SceneCity.m_tWndBottomBar) then
            	WZLog("updateRedPointupdateRedPoint 00")
	            setRedPoint(btn,curData.state,ccp(50,50),scale)
	            if not curData.state then 
	            	local bIsExist = judgeHavedRecordString("TASK_UINAME", false)
	            	if CacheCenter:getPlayerInfo() then
		            	if CacheCenter:getPlayerInfo().level <= 20 and not bIsExist then 
		            		WZLog("updateRedPointupdateRedPoint 11")
		            		setRedPoint(btn, not curData.state, ccp(50,50), scale)
		            	end
		            end
	            end
            else
            	local tempPos = nil 
            	if btnName == "btnFriend" or name[curData.index] == "btnFriend_WndOwnCity" then 
            		tempPos = ccp(30,30)
            	elseif btnName == "btnCastSoul" or name[curData.index] == "btnCastSoul_WndBottomBar" then 
            		tempPos = ccp(45, 53)
            	end

            	setRedPoint(btn,curData.state, tempPos, scale)
        	end


            if name[curData.index] == "btnCard_ExtendUp_WndBottomBar" then
            	local btn = GetElement(node,"btnKapai_WndBottomBar",WZUIButton)
            	if btn then
            		setRedPoint(btn,curData.state, nil, scale)
            	end
        	end

        	if name[curData.index] == "btnItem_WndBottomBar" then
            	local btn = GetElement(node,"btnItem_WndBottomBar",WZUIButton)
            	if btn then
--            		WZLog("CacheCenter:updateRedPointbtnItem1", CacheCenter:getRedState("btnItem"), CacheCenter:getSkillRed(), CacheCenter:getPropsRed())
            		local state = CacheCenter:getRedState("btnItem") or CacheCenter:getSkillRed() or CacheCenter:getAssistSkillRed() or CacheCenter:getPropsRed()
            		setRedPoint(btn,state, nil, scale)
            	end
        	end

        	if name[curData.index] == "btnPractice_ExtendUp_WndBottomBar" or name[curData.index] == "btnPlayer_WndBottomBar" or name[curData.index] == "btnBlessBag_other" then
            	local btn = GetElement(node,"btnPlayer_WndBottomBar",WZUIButton)
            	if btn then
--            		WZLog("CacheCenter:updateRedPointbtnBag1", CacheCenter:getRedState("btnBag"), CacheCenter:getRedState("btnPractice_ExtendUp"), CacheCenter:getRedState("btnBlessBag"))
            		local library_status = false
            		if GlobalGame.g_tRedPointTypeList then
            			library_status = GlobalGame.g_tRedPointTypeList[290] or (GlobalGame.g_tRedPointTypeList[291] or false)
            		end
            		local state = CacheCenter:getRedState("btnBag") or CacheCenter:getRedState("btnPractice_ExtendUp") or 
            					  CacheCenter:getRedState("btnBlessBag") or library_status
            		setRedPoint(btn,state, ccp(50,50), scale)
            	end
        	end

        	if name[curData.index] == "btnPet_WndBottomBar" or name[curData.index] == "btnMount_WndBottomBar" or name[curData.index] == "btnFootMark_WndBottomBar" then
            	local btn = GetElement(node,"btnPet_WndBottomBar",WZUIButton)
            	if btn then
            		local mount_status = false
            		if CheckButtonShow(MOUNTSTONE) then
            			mount_status = GlobalGame.g_tRedPointList.mountstone_redpoint
            		end
--            		WZLog("CacheCenter:updateRedPointbtnBag Pet", CacheCenter:getRedState("btnPet"), CacheCenter:getRedState("btnMount"), CacheCenter:getRedState("btnFootMark"))
            		local state = CacheCenter:getRedState("btnMount") and CheckButtonOpen(ISLAND_RIGHT_MOUNT, false) 
            				   or CacheCenter:getRedState("btnFootMark") and CheckButtonOpen(ISLAND_RIGHT_FOOTMARK, false) 
            				   or GlobalGame.g_tRedPointList.petFetter or (CacheCenter:getRedState("btnPhantom") or GlobalGame.g_tRedPointList.phantomEquipment or GlobalGame.g_tRedPointList.phantomGroup) and CheckButtonOpen(ISLAND_RIGHT_PHANTOM, false)
            				   or mount_status
            		setRedPoint(btn,state, ccp(54,53), scale)
            	end
        	end

        	--时装注魂红点
        	if name[curData.index] == "btnCastSoul_WndBottomBar" then
            	local btn = GetElement(node,"btnCastSoul_WndBottomBar",WZUIButton)
            	if btn then
            	--	WZLog("CacheCenter:updateRedPointbtnBag btnCastSoul_WndBottomBar1 = ", CacheCenter:getRedState("btnCastSoul"))
            		local state = CacheCenter:getRedState("btnCastSoul")
            		setRedPoint(btn,state, ccp(45, 53), scale)
            	end
        	end

        	--锻造红点
        	if name[curData.index] == "btnStrong_WndBottomBar" or name[curData.index] == "btnStrong_WndBottomBar2" then
            	local btn = GetElement(node,"btnStrong_WndBottomBar",WZUIButton)
            	if btn then
--            		WZLog("CacheCenter:updateRedPointbtnBag btnStrong1 = ", CacheCenter:getRedState("btnStrong"), CacheCenter:getRedState("gemMounting_btnStrong"))
            		local state = CacheCenter:getRedState("btnStrong") or (CacheCenter:getRedState("gemMounting_btnStrong") and CheckButtonOpen(43,1))
            		setRedPoint(btn,state, nil, scale)
            	end
        	end
        	--聯盟红点
        	if name[curData.index] == "btnUnion_WndBottomBar" then
            	local btn = GetElement(node,"btnUnion_WndBottomBar",WZUIButton)
            	if btn then
--            		WZLog("CacheCenter:updateRedPointbtnBag btnUnion_WndBottomBar1 = ", CacheCenter:getRedState("btnUnion"))
            		local state = CacheCenter:getRedState("btnUnion")
            		setRedPoint(btn,state, nil, scale)
            	end
        	end
        end
    else
        for k,v in pairs(data) do
--        	WZLog("CacheCenter:updateRedPoint2_2", k, v.index, name[v.index], tostring(v.state))
            local btn = GetElement(node,name[v.index],WZUIButton)
--            WZLog("CacheCenter:updateRedPoint2_3", k, v.index, name[v.index], tostring(v.state), btn)
            if name[v.index] == "btnTask_WndBottomBar" and (SceneCity.m_tWndBottomBar and node == SceneCity.m_tWndBottomBar) then
                setRedPoint(btn,v.state,ccp(50,50), scale)
                if not v.state then 
                	local bIsExist = judgeHavedRecordString("TASK_UINAME", false)
	            	if CacheCenter:getPlayerInfo() and CacheCenter:getPlayerInfo().level <= 20 and not bIsExist then 
	            		setRedPoint(btn, not v.state, ccp(50,50), scale)
	            	end
	            end
            elseif k == "btnChat" then
            	if (SceneCity.m_tWndBottomBar and node == SceneCity.m_tWndBottomBar) then
			        position = ccp(72,72)
			    else
		            position = ccp(45,45)
		        end
		        setRedPoint(btn,v.state,position, scale)
            else
            	local tempPos = nil 
            	local status = v.state
            	if k == "btnFriend" or name[v.index] == "btnFriend_WndOwnCity" then 
            		tempPos = ccp(30,30)
            	elseif btnName == "btnCastSoul" or name[v.index] == "btnCastSoul_WndBottomBar" then 
            		tempPos = ccp(45, 53)
            	end
            	setRedPoint(btn,status, tempPos, scale)
        	end

            if name[v.index] == "btnCard_ExtendUp_WndBottomBar" then
            	local btn = GetElement(node,"btnKapai_WndBottomBar",WZUIButton)
            	if btn then
            		setRedPoint(btn,v.state, nil, scale)
            	end
        	end

        	if name[v.index] == "btnItem_WndBottomBar" then
            	local btn = GetElement(node,"btnItem_WndBottomBar",WZUIButton)
            	if btn then
--            		WZLog("CacheCenter:updateRedPointbtnItem1", CacheCenter:getRedState("btnItem"), CacheCenter:getSkillRed(), CacheCenter:getPropsRed())
            		local state = CacheCenter:getRedState("btnItem") or CacheCenter:getSkillRed() or CacheCenter:getAssistSkillRed() or CacheCenter:getPropsRed()
            		setRedPoint(btn,state, nil, scale)
            	end
        	end

        	if name[v.index] == "btnPractice_ExtendUp_WndBottomBar" or name[v.index] == "btnPlayer_WndBottomBar" or name[v.index] == "btnBlessBag_other" then
            	local btn = GetElement(node,"btnPlayer_WndBottomBar",WZUIButton)
            	if btn then
--            		WZLog("CacheCenter:updateRedPointbtnBag1", CacheCenter:getRedState("btnBag"), CacheCenter:getRedState("btnPractice_ExtendUp"), CacheCenter:getRedState("btnBlessBag"))
            		local library_status = false
            		if GlobalGame.g_tRedPointTypeList then
            			library_status = GlobalGame.g_tRedPointTypeList[290] or (GlobalGame.g_tRedPointTypeList[291] or false)
            		end
            		local state = CacheCenter:getRedState("btnBag") or CacheCenter:getRedState("btnPractice_ExtendUp") or CacheCenter:getRedState("btnBlessBag") or library_status
            		setRedPoint(btn,state, ccp(50,50), scale)
            	end
        	end

        	if name[v.index] == "btnPet_WndBottomBar" or name[v.index] == "btnMount_WndBottomBar" or name[v.index] == "btnFootMark_WndBottomBar" or name[v.index] == "btnPhantom_WndBottomBar" then
            	local btn = GetElement(node,"btnPet_WndBottomBar",WZUIButton)
            	if btn then
            		local mount_status = false
            		if CheckButtonShow(MOUNTSTONE) then
            			mount_status = GlobalGame.g_tRedPointList.mountstone_redpoint
            		end
--            		WZLog("CacheCenter:updateRedPointbtnBag Pet", CacheCenter:getRedState("btnPet"), CacheCenter:getRedState("btnMount"), CacheCenter:getRedState("btnFootMark"), CacheCenter:getRedState("btnPhantom"))
            		local state = CacheCenter:getRedState("btnMount") and CheckButtonOpen(ISLAND_RIGHT_MOUNT, false) or CacheCenter:getRedState("btnFootMark") and CheckButtonOpen(ISLAND_RIGHT_FOOTMARK, false) 
            				   or GlobalGame.g_tRedPointList.petFetter or (CacheCenter:getRedState("btnPhantom") or GlobalGame.g_tRedPointList.phantomEquipment or GlobalGame.g_tRedPointList.phantomGroup) and CheckButtonOpen(ISLAND_RIGHT_PHANTOM, false)
            				   or mount_status
--            		WZLog("CacheCenter:updateRedPointbtnBag Pet two", state)
            		setRedPoint(btn, state, ccp(54,53), scale)
            	end
        	end

        	--时装注魂红点
        	if name[v.index] == "btnCastSoul_WndBottomBar" then
            	local btn = GetElement(node,"btnCastSoul_WndBottomBar",WZUIButton)
            	if btn then
            		local state = CacheCenter:getRedState("btnCastSoul")
            	--	WZLog("CacheCenter:updateRedPointbtnBag btnCastSoul_WndBottomBar2 = ", state, btn)
            		setRedPoint(btn, state, ccp(45, 53), scale)
            	end
        	end
        	--联盟红点
        	if name[v.index] == "btnUnion_WndBottomBar" then
            	local btn = GetElement(node,"btnUnion_WndBottomBar",WZUIButton)
            	if btn then
--            		WZLog("CacheCenter:updateRedPointbtnBag btnUnion_WndBottomBar2 = ", CacheCenter:getRedState("btnUnion"))
            		local state = CacheCenter:getRedState("btnUnion")
            		setRedPoint(btn,state, nil, scale)
            	end
        	end

        	--锻造红点
        	if name[v.index] == "btnStrong_WndBottomBar" or name[v.index] == "btnStrong_WndBottomBar2" then
            	local btn = GetElement(node,"btnStrong_WndBottomBar",WZUIButton)
            	if btn then
--            		WZLog("CacheCenter:updateRedPointbtnBag btnStrong2 = ", CacheCenter:getRedState("btnStrong"), CacheCenter:getRedState("gemMounting_btnStrong"))
            		local state = CacheCenter:getRedState("btnStrong") or (CacheCenter:getRedState("gemMounting_btnStrong") and CheckButtonOpen(43,1))
            		setRedPoint(btn,state, nil, scale)
            	end
        	end
        end
    end

    --add by wuweidong 
    local m_bContainsRedPoint = false 
    if pos == "right" then
    	for k,v in pairs(data) do
            if (v.state or CacheCenter:getSkillRed() or CacheCenter:getPropsRed() or CacheCenter:getAssistSkillRed()) and v.index ~= 4 and v.index ~= 7 and (SceneCity.m_tWndBottomBar == nil or node ~= SceneCity.m_tWndBottomBar or (v.index ~= 6 and v.index ~= 11)) then
            	m_bContainsRedPoint = true
--            	WZLog("CacheCenter:updateRedPoint3", v.index, tostring(SceneCity.m_tWndBottomBar), tostring(node ~= SceneCity.m_tWndBottomBar))
            	break 
            end 
        end
    end

    local AllBtn = GetElementWithoutAssert(node,"btnSwitch_WndBottomBar",WZUIButton)
    if AllBtn == nil then 
    	return 
    end 

    node:getLuaObjectIndex():setRed(m_bContainsRedPoint)
    if node:getLuaObjectIndex().m_nMoveDirection == 0 then
    	--m_bContainsRedPoint = CacheCenter:getRedState("btnFriend") or CacheCenter:getRedState("btnMail")--1.6.4设置邮箱好友移至右上角，这里的红点不显示
    end

    if m_bContainsRedPoint then
    	if not AllBtn:getChildByTag(89) then
            local spr_redPoint =  CCSprite:create("ui/common/common_icon_xiaodianzhui.png")
            AllBtn:addChild(spr_redPoint,5,89)

            local position = ccp(70,55)
            if (SceneCity.m_tWndBottomBar and node == SceneCity.m_tWndBottomBar) then
	        	position = ccp(45,45)
	    	end
            spr_redPoint:setPosition(position)
        end
    else 
    	if  AllBtn:getChildByTag(89) then 
    		AllBtn:removeChildByTag(89,true)
    	end
    end 

end

-- 设置VIP充值列表
function CacheCenter:setVipList(ids, icons, number, giftNumber, price, payCodeId, flag, name, remark,showPrice,itemId,sortId)
    
    self.m_tVipList = {}
    for i = 1, #ids do
        local info = {
			ids = ids[i],
			icons = icons[i],
			number = number[i],
			giftNumber = giftNumber[i],
			price = price[i],
			payCodeId = payCodeId[i],
			flag = flag[i],
			name = name[i],
			remark = remark[i],
			showPrice = showPrice[i],
			itemId = itemId[i],
			sortId = sortId[i],
		}
        table.insert(self.m_tVipList,info)
    end
    local function sort(v1,v2)
        return v1.sortId < v2.sortId
    end
    table.sort(self.m_tVipList, sort)
--    WZLog("---------------set vip list--------------:", Serialize(self.m_tVipList))
    --判断是否是需要去appStore获取产品列表
    PassportSdkManager:QequestFromAppStore(payCodeId)
    -- WndVip:showWndUIRecharge()
    GlobalGame:getGameEventDispathcer():Dispatch(NewVipEvent.NewVipEvent_ChargeListData)
end

-- 获取VIP充值列表
function CacheCenter:getVipList()
    if self.m_tVipList then
        return self.m_tVipList
    else
        ProtocolProcessorRecharge:send_PURCHASE_GetProductIdList(ProjConfig:getChannelId())
    end
end

--@brief 	设置星魂列表数据
function CacheCenter:setStarSoulList()
	-- body
	if self.m_tStarSoulList == nil then
		self.m_tStarSoulList = {}
	end

	for key, value in pairs(GDatatab_starsoul) do
		local tTemp = {}
		tTemp.id = value.id
		tTemp.star = value.star
		tTemp.star_icon = value.star_icon 
		tTemp.star_soul = value.star_soul 
		tTemp.star_name = value.star_name 
		tTemp.starsoul_icon = value.starsoul_icon 
		tTemp.property = value.property 
		tTemp.cost = value.cost 
		tTemp.name = value.name
		tTemp.absPosition = ccp(value.location[1][1],value.location[1][2])--value.ccp
		tTemp.status = 0 	--星魂的状态：0->未激活；1->待激活；2->已激活

		table.insert(self.m_tStarSoulList, tTemp)
	end

	table.sort(self.m_tStarSoulList, sortStarList)
end

function sortStarList(a, b)
	-- body
	if a.star == b.star then
		return a.star_soul < b.star_soul 
	else
		return a.star < b.star
	end
end

--@brief 	更新星魂列表数据
function CacheCenter:updateStarSoulList(id)
	-- body
	local nBreakIndex = 0   --计数为2跳出循环
	for i = 1, #self.m_tStarSoulList do
		if self.m_tStarSoulList[i].id == id then
			self.m_tStarSoulList[i].status = 2
			nBreakIndex = nBreakIndex + 1
		elseif self.m_tStarSoulList[i] == id + 1 then
			self.m_tStarSoulList[i].status = 1
			nBreakIndex = nBreakIndex + 1
		end

		if nBreakIndex == 2 or (nBreakIndex == 1 and (id + 1) > #self.m_tStarSoulList) then 
			break
		end
	end
end

--@brief 如果有缓存信息更新后金币等数据是否及时刷新显示出来
function CacheCenter:setUpdateNewStatus(status)
	self.m_bStopUpdateNewData = status
end

function CacheCenter:updateMoneyData()
	self:_updateMoneyData()
end

--@note		好友动态排序
function sortDynamicFriends(a,b)
	local operateA = CacheCenter:checkSortOperate(a)
	local operateB = CacheCenter:checkSortOperate(b)

	if operateA ~= operateB then
		return operateA > operateB
	elseif a.time == nil or b.time == nil then
        return false
    end

	if a.time ~= b.time then
		return a.time >= b.time
	end
end

function CacheCenter:checkSortOperate(a)
	if a.typeList == 9 then
		return 5
	elseif a.typeList == 4 then
		return 4
	elseif a.status == 1 then
		return 3
	elseif a.sendType == 1 then 
		return 2
	else 
		return 1 
	end
end

--@brief 	设置邀请码列表的数据
function CacheCenter:setInviteData(myInviteCode, friendIdList, nameList, pictureList, faceIdList, levelList, vipLevelList, sex, lineStatusList, serverIdList, taskIdList, conditions, currCount, statusList, writeFlag, headColor, headEffectId)
	-- body
	self.m_sMyInviteCode = myInviteCode
	self.m_nInviteState = writeFlag
	--邀请码好友列表
--	if self.m_tInviteFriends == nil then
		self.m_tInviteFriends = {}
--	end
	for i = 0, friendIdList:size() - 1 do
		local tItemTemp = {}
		tItemTemp.id = friendIdList:get(i)
		tItemTemp.name = nameList:get(i)
		tItemTemp.headItemId = pictureList:get(i)
		tItemTemp.faceItemId = faceIdList:get(i)
		tItemTemp.isOnline = lineStatusList:get(i)
		tItemTemp.level = levelList:get(i)
		tItemTemp.vipLevel = vipLevelList:get(i)
		tItemTemp.sex = sex:get(i)
		tItemTemp.serverId = serverIdList:get(i)
		tItemTemp.headColor = headColor:get(i)
		tItemTemp.headEffectId = headEffectId and headEffectId:size() > 0 and headEffectId:get(i) or 0
		WZLog("CacheCenter:setInviteData", tItemTemp.name, tItemTemp.headColor)

		table.insert(self.m_tInviteFriends, tItemTemp)
	end
	table.sort(self.m_tInviteFriends, sortInviteFriends)

	--邀请码任务列表
	self.m_tInviteTaskList = {}
	self.m_nInviteMark = 0
	for j = 0, taskIdList:size() - 1 do
		local tempItem = {}
		tempItem.id = taskIdList:get(j)
		tempItem.desc = GDatatab_invite_rewards["id_" .. tempItem.id].desc
		local rewardList = GDatatab_invite_rewards["id_" .. tempItem.id].reward
		table.sort(rewardList, sortRewards)
		tempItem.reward = rewardList
		tempItem.status = statusList:get(j)
		tempItem.nTarget = conditions:get(j)
		tempItem.nComplete = currCount:get(j)

		table.insert(self.m_tInviteTaskList, tempItem)
		if tempItem.status == 0 then 
			self.m_nInviteMark = self.m_nInviteMark + 1
		end
	end

	if self.m_nInviteMark > 0 then
		self:addMark("btnFriend_WndOwnCity",1)
	end
	--排序任务
	table.sort(self.m_tInviteTaskList, sortInviteTask)
	--WZLog("CacheCenter:setInviteData", self.m_sMyInviteCode, self.m_nInviteState, Serialize(self.m_tInviteFriends), self.m_nInviteMark)

	WndFriends:setInviteTaskData()
end

--@brief 	更新邀请码任务状态
function CacheCenter:updateInviteTask(id, status, count, currCount)
	-- body
	if self.m_tInviteTaskList == nil or id:size() == 0 then return end
	WZLog("CacheCenter:updateInviteTask", id:size())
	for j = 0, id:size() - 1 do
		for i = 1, #self.m_tInviteTaskList do 
			if self.m_tInviteTaskList[i].id == id:get(j) then 
				self.m_tInviteTaskList[i].status = status:get(j)
				self.m_tInviteTaskList[i].nTarget = count:get(j)
				self.m_tInviteTaskList[i].nComplete = currCount:get(j)
				if self.m_tInviteTaskList[i].status == -1 and self.m_tInviteTaskList[i].nTarget == self.m_tInviteTaskList[i].nComplete then
					self.m_tInviteTaskList[i].status = 0 
				end
				break 
			end
		end
	end

	self.m_nInviteMark = 0 
	for k = 1, #self.m_tInviteTaskList do
		if self.m_tInviteTaskList[k].status == 0 then
			self.m_nInviteMark = self.m_nInviteMark + 1
		end
	end
	if self.m_nInviteMark > 0 then
		self:addMark("btnFriend_WndOwnCity",1)
	end
	--排序任务
	table.sort(self.m_tInviteTaskList, sortInviteTask)
	--只刷新邀请码任务
	WndFriends:RefreshInterface(nil, nil, 2)
end

--@brief 	更新邀请码任务状态
function CacheCenter:refreshInviteTask(id, status)
	-- body
	if self.m_tInviteTaskList == nil then return end

	WZLog("CacheCenter:refreshInviteTask", id, status)
	for i = 1, #self.m_tInviteTaskList do
		if self.m_tInviteTaskList[i].id == id then 
			self.m_tInviteTaskList[i].status = status
			break 
		end
	end

	if self.m_nInviteMark > 0 then
		self:addMark("btnFriend_WndOwnCity",1)
	elseif self.m_nInviteMark == 0 and self.m_nDailyMark == 0 and not GlobalGame.g_tRedPointList.myCircle then
		self:addMark("btnFriend_WndOwnCity",0)
	end
	--排序任务
	table.sort(self.m_tInviteTaskList, sortInviteTask)
	WZLog("CacheCenter:refreshInviteTask 111", Serialize(self.m_tInviteTaskList))
	--只刷新邀请码任务
	WndFriends:RefreshInterface(nil, nil, 2)
end

--@brief 	新增邀请码好友
function CacheCenter:addInviteFriend(friendId, name, headId, faceId, level, vipLevel, sex, lineStatus, serverId, headColor, headEffectId)
	-- body
	if self.m_tInviteFriends == nil then
		self.m_tInviteFriends = {}
	end

	local bIsExist = false
	local bIsNeedRefresh = false 
	for i = 1, #self.m_tInviteFriends do
		if self.m_tInviteFriends[i].id == friendId then
			bIsExist = true
			self.m_tInviteFriends[i].name = name
			self.m_tInviteFriends[i].headItemId = headId
			self.m_tInviteFriends[i].faceItemId = faceId
			if self.m_tInviteFriends[i].isOnline ~= lineStatus or self.m_tInviteFriends[i].level ~= level or self.m_tInviteFriends[i].vipLevel ~= vipLevel then
				bIsNeedRefresh = true
			end
			self.m_tInviteFriends[i].isOnline = lineStatus
			self.m_tInviteFriends[i].level = level
			self.m_tInviteFriends[i].vipLevel = vipLevel
			self.m_tInviteFriends[i].sex = sex
			self.m_tInviteFriends[i].serverId = serverId
			self.m_tInviteFriends[i].headColor = headColor
			self.m_tInviteFriends[i].headEffectId = headEffectId or 0

			table.sort(self.m_tInviteFriends, sortInviteFriends)

			if bIsNeedRefresh then
				WndFriends:RefreshInterface(nil, nil, 1)
			end
			break 
		end
	end
	WZLog("CacheCenter:addInviteFriend", friendId, name)
	if bIsExist == false then
		local tItemTemp = {}
		tItemTemp.id = friendId
		tItemTemp.name = name
		tItemTemp.headItemId = headId
		tItemTemp.faceItemId = faceId
		tItemTemp.isOnline = lineStatus
		tItemTemp.level = level
		tItemTemp.vipLevel = vipLevel
		tItemTemp.sex = sex
		tItemTemp.serverId = serverId
		tItemTemp.headColor = headColor
		tItemTemp.headEffectId = headEffectId or 0

		table.insert(self.m_tInviteFriends, tItemTemp)
		table.sort(self.m_tInviteFriends, sortInviteFriends)
		--只刷新邀请码好友
		WndFriends:RefreshInterface(nil, nil, 1)
	end
end

--brief 	重新设置提交状态
function CacheCenter:resetInviteState(nState)
	-- body
	self.m_nInviteState = nState
end

function CacheCenter:checkInviteTaskStatus(a)
	-- body
	if a.status == 0 then 
		return 3
	elseif a.status == -1 then
		return 2
	else
		return 1
	end
end

function sortInviteTask(a, b)
	-- body
	local statusA = CacheCenter:checkInviteTaskStatus(a)
	local statusB = CacheCenter:checkInviteTaskStatus(b)
	if statusA ~= statusB then
		return statusA > statusB
	else
		return a.id < b.id
	end
end

function CacheCenter:checkInviteFriendOnline(a)
	-- body
	if a.isOnline == 1 or a.isOnline == true then 
		return 2
	else
		return 1
	end
end

function sortInviteFriends(a, b)
	-- body
	local onlineA = CacheCenter:checkInviteFriendOnline(a)
	local onlineB = CacheCenter:checkInviteFriendOnline(b)
	if onlineA ~= onlineB then
		return onlineA > onlineB 
	elseif a.level ~= b.level then
		return a.level > b.level
	else
		return a.id < b.id
	end
end

-- 记录所有服务器的ID和名字
function CacheCenter:setServerInfo(serverName,serverId,serverStatus)
	for i=0,serverName:size()-1 do
		local name = serverName:get(i)
		local id = serverId:get(i)
--		WZLog("--------cur info-----------",name,id)
	end

	local name = VectorToTable(serverName)
	local serverId = VectorToTable(serverId)
	local serverStat = VectorToTable(serverStatus)
	if not self.m_serverInfo then self.m_serverInfo = {} end
	for i = 1, #name do
		local info = {}
		info.name = name[i]
		info.serverId = tonumber(serverId[i])
		info.serverStat = tonumber(serverStat[i])
--		WZLog("all server info-----------id and name-----------",name[i],serverId[i],serverStat[i])
		table.insert(self.m_serverInfo,info)
	end
end

-- 通过名字获取服务器ID
function CacheCenter:getServerNameByServerId(serverId)
	if self.m_serverInfo then
		for i = 1, #self.m_serverInfo do
			if tonumber(self.m_serverInfo[i].serverId) == tonumber(serverId) then
				return self.m_serverInfo[i].name
			end
		end
	end
	
	return ""
end

-- 通过服务器ID获取服务器名字
function CacheCenter:getServerIdByServerName(name)
	for i = 1, #self.m_serverInfo do
		if tostring(self.m_serverInfo[i].name) == tostring(name) then
			return self.m_serverInfo[i].serverId
		end
	end
	return 0
end

-- 通过服务器ID获取服务器状态
function CacheCenter:getServerStatusByServerId(serverId)
	if self.m_serverInfo == nil then return end
	for i = 1, #self.m_serverInfo do
		if tonumber(self.m_serverInfo[i].serverId) == tonumber(serverId) then
			return self.m_serverInfo[i].serverStat
		end
	end
	return 0
end

--@brief 	公会战目标数据
function CacheCenter:setGuildWarTargetData(typeId, num, taskId)
	-- body
	self.m_tGuildWarTargetData = {}

	self.m_tGuildWarTargetData[1] = typeId
	self.m_tGuildWarTargetData[2] = num
	self.m_tGuildWarTargetData[3] = taskId

	if WndCompeteTask then
        GlobalGame.g_bIsGuildWarHaveRedDot = WndCompeteTask:judgeTaskState(typeId, num, taskId)
        SceneCommunityWar:updateTargetBtnRedDot()
    end
	--如果界面打开，就刷新
	if WndCompeteTask.m_root then
        WndCompeteTask:setData(typeId, num, taskId)
    end
end

--私聊缓存
function CacheCenter:addPriChatCache(iMainChannel, iSendID, sSendName, iRecvID, sRecvName, sMsgContent, tm, vipLevel,playerHead,playerFace,playerSex,headScul,serviceId,headColor,senderLevel,rtime,bubbleId, playerTitle, playerPvpLevel, professionId, openStatus, bRecordChat,nRecordT,messageId, headEffectId)
	WZLog("CacheCenter:addPriChatCache", bRecordChat,nRecordT,messageId)
	local temp = {}
	table.insert(temp,iMainChannel)
	table.insert(temp,iSendID)
	table.insert(temp,sSendName)
	table.insert(temp,iRecvID)
	table.insert(temp,sRecvName)
	table.insert(temp,sMsgContent)
	table.insert(temp,tm)
	table.insert(temp,vipLevel)
	table.insert(temp,playerHead)
	table.insert(temp,playerFace)
	table.insert(temp,playerSex)
	table.insert(temp,headScul)
	table.insert(temp,serviceId)
	table.insert(temp,headColor)
	table.insert(temp,senderLevel)
	table.insert(temp,rtime)
	table.insert(temp,bubbleId)
	table.insert(temp,playerTitle)
	table.insert(temp,playerPvpLevel)
	table.insert(temp,professionId or 0)
	table.insert(temp,openStatus)
	table.insert(temp,bRecordChat)
	table.insert(temp,nRecordT)
	table.insert(temp,messageId)
	table.insert(temp,headEffectId or 0)

	table.insert(self.m_tChatCache,temp)
	--WZLog("CacheCenter:addPriChatCache", Serialize(temp))
end

--@breif 竞技加成卡 信息 time
function CacheCenter:setArenaAddInfo(addValue, timeValue, timeType,serverTime)
	-- addValue = {200,100,300}
	-- timeValue = {20,100000,5}
	-- timeType = {0,1,2}
	-- serverTime = SystemTime:getServerTime()
	self.m_tAreanAddInfo.addValue = addValue
	self.m_tAreanAddInfo.timeValue = timeValue
	self.m_tAreanAddInfo.timeType = timeType
	self.m_tAreanAddInfo.rushServerTime = serverTime
end

--@breif 竞技卡刷 
function CacheCenter:updateArenaAddInfo()
	if not self.m_tAreanAddInfo or not self.m_tAreanAddInfo.rushServerTime or #self.m_tAreanAddInfo.addValue == 0 then
		return
	end

	local serverTime = SystemTime:getServerTime()
	local time = math.floor((serverTime - self.m_tAreanAddInfo.rushServerTime)/60)
	for i = #self.m_tAreanAddInfo.timeType ,1,-1 do
		if self.m_tAreanAddInfo.timeType[i] == 1 then
			if time > 0 then
				self.m_tAreanAddInfo.timeValue[i] = self.m_tAreanAddInfo.timeValue[i] - time
			end
			if self.m_tAreanAddInfo.timeValue[i] <= 0 then
				table.remove(self.m_tAreanAddInfo.addValue,i)
				table.remove(self.m_tAreanAddInfo.timeValue,i)
				table.remove(self.m_tAreanAddInfo.timeType,i)
			end
		end
	end
	if time > 0 then
		self.m_tAreanAddInfo.rushServerTime = serverTime - (serverTime - self.m_tAreanAddInfo.rushServerTime)%60
	end
end

--@brief 获得竞技加成
function CacheCenter:getArenaAddInfo()
	return self.m_tAreanAddInfo
end

--@brief 收到服务端消息时候会调用此方法
-- status : 状态 2结束  1 进行
-- startTimestamp : 开始时间戳
-- endTimestamp : 结束时间戳
-- leftWishTimes : 剩余许愿次数
-- configId : 充值id,0为无可充值项目,-1为任意充值
-- leftPurchaseTimes : 剩余的购买次数
-- countDown : 倒计时
function CacheCenter:setPromiseData(status, startTimestamp, endTimestamp, leftWishTimes, configId, leftPurchaseTimes, countDown)

	--self:_resetConfigCache()

	local tData = {
		status 			= status,
		startTimestamp 	= startTimestamp,
		endTimestamp 	= endTimestamp,
		leftWishTimes 	= leftWishTimes,
		configId 		= configId,
		leftPurchaseTimes = leftPurchaseTimes,
		countDown 		= countDown,
	} 
	
    self.m_tPromiseData = tData
    GlobalGame:getBtnRedPointEvent():dispatcher("WishWell",{[1]=CacheCenter:isOpenPromiseRedPoint(), [2]=CacheCenter:isOpenPromise()})
end

function CacheCenter:getPromiseData()
	return self.m_tPromiseData
end

--@brief 许愿池开放
function CacheCenter:isOpenPromise()
	if nil == self.m_tPromiseData then
		return false
	end
	local nCurrentTimestamp = SystemTime:getServerTime()

	WZLog("CacheCenter:isOpenPromise", nCurrentTimestamp, Serialize(self.m_tPromiseData))
	-- if nCurrentTimestamp < self.m_tPromiseData.endTimestamp then
	-- 	return true
	-- end
	if 1 == self.m_tPromiseData.status then
		return true
	end
	return false
end

--@brief 是否开启红点(是否显示按钮)
function CacheCenter:isOpenPromiseRedPoint() 
	if 0 < self.m_tPromiseData.leftWishTimes then
		return true
	end
	return false
end

function CacheCenter:parse_RUNE_GetRuneInfoOk(placeIds, placeItemId,itemIds)
	WZLog("CacheCenter:parse_RUNE_GetRuneInfoOk")
	CacheCenter.m_tRunePlaceIds = placeIds
	CacheCenter.m_tRuneItemId = placeItemId
	local isRed = false
	local tNull = {}
	for k,v in pairs(CacheCenter.m_tRuneItemId) do
		if v == 0 then
			local grid = GDatatab_rune_grid["id_" .. CacheCenter.m_tRunePlaceIds[k]]
			table.insert(tNull,grid.type)
		end
	end

    local gDatatab_item = GDatatab_item
	for i,v in ipairs(tNull) do
		for j,k in ipairs(itemIds) do
			local typee = gDatatab_item["id_" .. k].sub_type
			if typee == v then
				isRed = true
				break
			end
		end
	end

	WZLog("CacheCenter:parse_RUNE_GetRuneInfoOk two", isRed)
	CacheCenter:setRedState("btnRune",isRed)
    GlobalGame:getBtnRedPointEvent():dispatcher()
end

function CacheCenter:parse_RUNE_OpenPlaceStatus(status, placeId)
	if status == 0 then
		table.insert(CacheCenter.m_tRunePlaceIds, placeId)
		table.insert(CacheCenter.m_tRuneItemId, 0)

		CacheCenter:setRedState("btnRune",true)
        GlobalGame:getBtnRedPointEvent():dispatcher()
	end
end

function CacheCenter:parse_RUNE_UpdateRuneStatus(status,placeId,itemId)
	if status == 0 then
		local isRed = false
		if placeId == -1 then
			isRed = true
		elseif placeId == 0 then
			isRed = true
		else
			for k,v in pairs(CacheCenter.m_tRunePlaceIds) do
				if placeId == v then
					CacheCenter.m_tRuneItemId[k] = itemId
				end
			end

			for k,v in pairs(CacheCenter.m_tRuneItemId) do
				if v == 0 then
					isRed = true
					break
				end
			end
		end

		CacheCenter:setRedState("btnRune",isRed)
        GlobalGame:getBtnRedPointEvent():dispatcher()
	end
end

--@breif 禁忌之地购买骰子次数
function CacheCenter:updateBuyTabooCoinTimes(value)
	self.m_nBuyTabooCoinTimes = value
end

--@brief 禁忌之地购买骰子次数 
function CacheCenter:getBuyTabooCoinTimes()
	return self.m_nBuyTabooCoinTimes
end

--@brief 禁忌之地骰子数量（max）
function CacheCenter:getTabooCoinMaxNum()
	local vipLv = self:getPlayerInfo().vipLevel
	if self.m_tTabooCoinLimitNum[vipLv] then
		return self.m_tTabooCoinLimitNum[vipLv]
	end
	return 0
end

function CacheCenter:setSkill(unlockSkill, skillNum, useSkill, openLevel, logtype, logskillId, mes, mentorSkill)
	WZLog("CacheCenter:setSkill", type(WndSkillProp.upTip), type(WndSkillProp.learnTip), Serialize(useSkill), Serialize(openLevel))

	self.m_tSkill = {} 
	self.m_tSkill.unlockSkill = unlockSkill
	self.m_tSkill.skillNum = skillNum
	self.m_tSkill.useSkill = useSkill
	self.m_tSkill.openLevel = openLevel
	self.m_tSkill.logtype = logtype
	self.m_tSkill.logskillId = logskillId
	self.m_tSkill.mes = mes
	self.m_tSkill.mentorSkill = mentorSkill
	self.m_tSkill.expv = {}
	self.m_tSkill.skillExplain = {}
	for i=1,50 do
		self.m_tSkill.expv[i] = skillNum
	end
	local level = CacheCenter:getPlayerInfo().level
	for i=1,#useSkill do
		self.m_tSkill.skillExplain[i] = ""
		if useSkill[i] == -1 and level >= tonumber(openLevel[i]) then
			useSkill[i] = 0
		end
		if useSkill[i] == -1 and level < tonumber(openLevel[i]) then
			if tonumber(openLevel[i]) == 999 then 
				self.m_tSkill.skillExplain[i] = LocalStrings.PROFESSION_TEXT24
			else
				self.m_tSkill.skillExplain[i] = string.format(LocalStrings.OPAN_FOR_LEVEL, tonumber(openLevel[i]))
			end
		end
	end
	CacheCenter:setSkillRed()

--	WZLog("武器技能",Serialize(self.m_tSkill))
	if WndSkillProp.m_root ~= nil then
		WndSkillProp:initSkills()
		WndSkillProp:actionCallback()
		WndSkillProp:updateLog()
		--更新右侧
--		WZLog("升级后更新右侧",WndSkillProp.m_nCurShowSkillId,Serialize(WndSkillProp.m_tAllSkillProps))
    	local skillInfo = GDatatab_skill["id_"..WndSkillProp.m_nCurShowSkillId]
		local showSkillId = WndSkillProp.m_nCurShowSkillId
		local bEquipped = false
		for k,v in pairs(WndSkillProp.m_tAllSkillProps) do
			if v.id == skillInfo.upgrade_id or v.id == skillInfo.id then
				showSkillId = v.id
				if v.equip == 5 then
					bEquipped = true
				end
			end
		end
	    WndSkillProp:showSkillDetailInfo(showSkillId,bEquipped,true)
	end

	--更新完界面再开放操作
	if WndSkillProp.upTip ~= nil and WndSkillProp.upTip >= 0 then
		WndSkillProp.upTip = WndSkillProp.upTip - 1
		if WndSkillProp.upTip == 0 then
			MsgBoxManager:showTipBox(LocalStrings.NEWSKILL14)
		end
		return
	end
	if WndSkillProp.learnTip ~= nil and WndSkillProp.learnTip >= 0 then
		WndSkillProp.learnTip = WndSkillProp.learnTip - 1
		if WndSkillProp.learnTip == 0 then
			MsgBoxManager:showTipBox(LocalStrings.NEWSKILL16)
		end
		return
	end
	WZLog("CacheCenter:setSkill1", WndSkillProp.upTip, WndSkillProp.learnTip, type(WndSkillProp.upTip), type(WndSkillProp.learnTip))
end

function CacheCenter:getSkill()
	--self.m_tSkill = {} 
	--self.m_tSkill.unlockSkill = {73,78,83,88}
	--self.m_tSkill.skillNum = 6669
	--self.m_tSkill.useSkill = {78,0,0,73,0}
	--self.m_tSkill.openLevel = {1,1,1,1,1}
	return self.m_tSkill
end

--@brief 设置技能红点状况
function CacheCenter:setSkillRed() 
	CacheCenter.m_bIsSkillRed = CacheCenter:getIsSkillRed()
end

--@brief 获取技能红点状况
function CacheCenter:getSkillRed() 
	if CacheCenter.m_bIsSkillRed == nil then
		CacheCenter.m_bIsSkillRed = CacheCenter:getIsSkillRed()
	end
	return CacheCenter.m_bIsSkillRed
end

--技能红点判断是否可以进行
function CacheCenter:bContinue()
--	WZLog("CacheCenter:bContinue")
    local playerInfo = CacheCenter:getPlayerInfo()
    --local skillNum = CacheCenter:getSkill().skillNum
    --if playerInfo.level <= 13 and skillNum < 30 then
    if playerInfo and playerInfo.level <= 13 then
    	return false
    end
    return true
end

--@brief 获取技能是否有红点
function CacheCenter:getIsSkillRed() 
	local red = false
	if self.m_tSkill == nil then return false end
	if not self:bContinue() then
		return false
	end
	--有技能空位
	for i=1,#self.m_tSkill.useSkill do
		if self.m_tSkill.useSkill[i] ~= -1 and self.m_tSkill.useSkill[i] <= 0 then
			WZLog("技能空位红点")
			return true
		end
	end

	local skills = {}
	for i,v in ipairs(self.m_tSkill.unlockSkill) do
		local skillInfo = GDatatab_skill["id_" .. v]
	--	WZLog("拥有技能", v)
		if skillInfo then 
			local id_group  = skillInfo.id_group
			local skillItem = {id = v, status = 1, id_group=skillInfo.id_group}
			table.insert(skills,skillItem)
		end
	end

	local m_tSkillList = {}
	local skill_type = 0
	for k,v in pairs(GDatatab_skill) do
		if v.skill_type == skill_type then
			if v.id_group ~= 108 and v.id_group ~= 109 and v.target_type ~= -1 then
				table.insert(m_tSkillList,v.id)
			end
		end
	end
	
	for i,v in ipairs(m_tSkillList) do
		local isExit = false
		local skillInfo  = GDatatab_skill["id_" .. v]
		for j,k in ipairs(skills) do
			if k.id == v or skillInfo.id_group == k.id_group  then
				isExit = true
			end
		end
		
		if not isExit then
			local id_group = skillInfo.id_group
			if skillInfo.specialAttackParam == 1 then
				local skillItem = {id = v, status = 0, id_group=skillInfo.id_group}
		        table.insert(skills,skillItem)
			end
		end
	end

	--WZLog("所有技能id",Serialize(skills))
	-- --有技能可激活
	-- for k,v in pairs(skills) do
	-- 	local skillId = v.id
	-- 	local skillNum = CacheCenter:getSkill().skillNum
	-- 	local needNum = GDatatab_skill["id_" .. skillId].hdtjcs
	-- 	if v.status == 0 and type(needNum) == "table" and skillNum >= needNum[1][2] then
	-- 		WZLog("技能激活红点",skillId)
	-- 		return true
	-- 	else
	-- 		--return false
	-- 	end
	-- end

	--有技能可升级
	for k,v in pairs(skills) do
		local skillId = v.id
		local skillNum = CacheCenter:getSkill().skillNum
		local needNum = GDatatab_skill["id_" .. skillId].upgrade
		if v.status == 1 and type(needNum) == "table" and (needNum[1][1] == 63 and skillNum >= needNum[1][2] or needNum[1][1] ~= 63 and CacheCenter:getPlayerItemCountById(needNum[1][1]) >= needNum[1][2]) then
			WZLog("技能升级红点",skillId)
			return true
		else
			--return false
		end
	end
	return false
end

--@brief 设置技能红点状况
function CacheCenter:setPropsRed() 
	CacheCenter.m_bIsPropsRed = CacheCenter:getIsPropsRed()
end

--@brief 获取技能红点状况
function CacheCenter:getPropsRed() 
	if CacheCenter.m_bIsPropsRed == nil then
		CacheCenter.m_bIsPropsRed = CacheCenter:getIsPropsRed()
	end
	return CacheCenter.m_bIsPropsRed
end

--@brief 获取道具是否有红点
function CacheCenter:getIsPropsRed() 
	if self.m_tPlayerSkill == nil or self.m_tSkillList == nil then return false end
	if not self:bContinue() then
		return false
	end

	--有道具空位
	for i=1,#self.m_tPlayerSkill do
		if self.m_tPlayerSkill.skillId[i] ~= -1 and self.m_tPlayerSkill.skillId[i] <= 0 then
--			WZLog("道具空位红点")
			return true
		end
	end

	local skills = {}
	if self.m_tSkillList.itemId then
		for i,v in ipairs(self.m_tSkillList.itemId) do
			local skillInfo = GDatatab_skill["id_" .. v]
--			WZLog("拥有道具", v)
			if skillInfo then 
				local id_group  = skillInfo.id_group
				local sort  = skillInfo.sort
				local skillItem = {id = v, status = 1, id_group=skillInfo.id_group, sort=skillInfo.sort}
				table.insert(skills,skillItem)
			end
		end
	end

	local tempSkillList = {}
	local skill_type = 1
	for k,v in pairs(GDatatab_skill) do
		if v.skill_type == skill_type then
			table.insert(tempSkillList,v.id)
		end
	end
	
	for i,v in ipairs(tempSkillList) do
		local isExit = false
		local skillInfo  = GDatatab_skill["id_" .. v]
		for j,k in ipairs(skills) do
			if k.id == v or skillInfo.id_group == k.id_group or skillInfo.sort == k.sort then
				isExit = true
			end
		end
		
		if not isExit then
			local id_group = skillInfo.id_group
			if skillInfo.specialAttackParam == 1 then
				local skillItem = {id = v, status = 0, id_group=skillInfo.id_group}
		        table.insert(skills,skillItem)
			end
		end
	end

--	WZLog("所有道具id",Serialize(skills))
	--有道具可激活
	for k,v in pairs(skills) do
		local skillId = v.id
		local needNum = GDatatab_skill["id_" .. skillId].hdtjcs
		if v.status == 0 and type(needNum) == "table" and CacheCenter:getPlayerItemCountById(needNum[1][1]) >= needNum[1][2] then
--			WZLog("道具激活红点",skillId,CacheCenter:getPlayerItemCountById(needNum[1][1]),needNum[1][2])
			return true
		else
			--return false
		end
	end

	--有道具可升级
	for k,v in pairs(skills) do
		local skillId = v.id
		local needNum = GDatatab_skill["id_" .. skillId].upgrade
		if v.status == 1 and type(needNum) == "table" and CacheCenter:getPlayerItemCountById(needNum[1][1]) >= needNum[1][2] then
--			WZLog("道具升级红点",skillId,CacheCenter:getPlayerItemCountById(needNum[1][1]),needNum[1][2])
			return true
		else
			--return false
		end
	end
	return false
end

function CacheCenter:setFundFinish(bool)
	self.m_bFundFinish = bool

	WndOwnCity:updateFund(not bool)
end

--@return	true:基金领完
function CacheCenter:getFundFinish()
	return self.m_bFundFinish 
end

--@breif 	设置新手定推礼包数据
function CacheCenter:setNewUserPackageList(funcId, pushInfo, lastNum, endTime, originPrice)
	-- body
	self.m_tNewUserPackageList = {}

	for i = 1, #funcId do
		local tItem = {}
		tItem.funcId = funcId[i]
		tItem.pushInfo = pushInfo[i]
		tItem.lastNum = lastNum[i]
		tItem.endTime = endTime[i]
		tItem.originPrice = originPrice[i]

		table.insert(self.m_tNewUserPackageList, tItem)
	end

	WZLog("CacheCenter:setNewUserPackageList", Serialize(self.m_tNewUserPackageList))
end

--@breif 	设置登录定推礼包数据
function CacheCenter:setLimitPackageList(pushInfo, lastNum, originPrice, endTime)
	-- body
	self.m_tLimitPackageList = {}

	for i = 1, #pushInfo do
		local tItem = {}
		tItem.pushInfo = pushInfo[i]
		tItem.lastNum = lastNum[i]
		tItem.endTime = endTime[i]
		tItem.originPrice = originPrice[i]

		table.insert(self.m_tLimitPackageList, tItem)
	end

	WZLog("CacheCenter:setLimitPackageList", Serialize(self.m_tLimitPackageList))
end

--@breif 	更新新手定推礼包数据
function CacheCenter:updateNewUserPackageList(funcId, pushInfo, lastNum, endTime, originPrice, pushType)
	-- body
	WZLog("CacheCenter:updateNewUserPackageList")
	if pushType and pushType == 5 then 
		self.m_tFiveTypePackageList = {}
		if pushInfo and pushInfo[1] then 
			local tItem = {}
			tItem.funcId = funcId
			tItem.pushInfo = pushInfo[1]
			tItem.lastNum = lastNum[1]
			tItem.endTime = endTime[1]
			tItem.originPrice = originPrice[1]

			table.insert(self.m_tFiveTypePackageList, tItem)
		end
		return 
	end
	--重新获取登录定向数据
	if tostring(ProjConfig:getChannelId()) ~= "53" and tostring(ProjConfig:getChannelId()) ~= "75" and tostring(ProjConfig:getChannelId()) ~= "275" then
		ProtocolProcessorCommonPush:send_COMMONPUSH_LoginDirectionalPush( )
	end
	if not funcId then return end

	if self.m_tNewUserPackageList == nil then 
		self.m_tNewUserPackageList = {}
	end

	local bExist = false 
	for i = 1, #self.m_tNewUserPackageList do
		if self.m_tNewUserPackageList[i].funcId == funcId then 
			bExist = true
			if pushInfo then
				self.m_tNewUserPackageList[i].pushInfo = pushInfo[1]
			end
			if lastNum then
				self.m_tNewUserPackageList[i].lastNum = lastNum[1]
			end
			if endTime then
				self.m_tNewUserPackageList[i].endTime = endTime[1]
			end
			if originPrice then 
				self.m_tNewUserPackageList[i].originPrice = originPrice[1]
			end
			break 
		end
	end
	if not bExist then
		local tItem = {}
		tItem.funcId = funcId
		tItem.pushInfo = pushInfo[1]
		tItem.lastNum = lastNum[1]
		tItem.endTime = endTime[1]
		tItem.originPrice = originPrice[1]

		table.insert(self.m_tNewUserPackageList, tItem)
		--进入界面以后才收到的数据
		local nodeParent, bShowAll, relationPosition
		if funcId == 11 and WndEquipmentLottery.m_root then 
			nodeParent = GetElement(WndEquipmentLottery.m_root, "conMiddle_WndEquipmentLottery", WZUIContainer)
			if IsIphoneX() then
				relationPosition = GlobalMethod:ccp(0.07,0.55)
			else
				relationPosition = GlobalMethod:ccp(0.053,0.55)
			end
			bShowAll = true
		elseif funcId == 27 and WndPets.m_root then
			nodeParent = GetElement(WndPets.m_root,"conPetLeft_WndPets",WZUIContainer)
			relationPosition = GlobalMethod:ccp(0.08,0.9)
			bShowAll = false
		elseif funcId == 41 and WndImproveStrengthen.m_root then
			nodeParent = GetElement(WndImproveStrengthen.m_root, "conTop_WndImproveStrengthen", WZUIContainer)
			relationPosition = GlobalMethod:ccp(0.1, 0.95)
			bShowAll = false
		elseif funcId == 43 and WndGemMountingStrengthen.m_root then
			nodeParent = WndGemMountingStrengthen.m_root
			relationPosition = GlobalMethod:ccp(0.1, 0.95)
			bShowAll = false
		elseif funcId == 64 and WndBlessBag.m_root then
			nodeParent = GetElement(WndBlessBag.m_root, "conLeft_WndBlessBag", WZUIContainer)
			relationPosition = GlobalMethod:ccp(0.76, 0.17)
			bShowAll = false
		elseif funcId == 131 and WndFamilyOperate.m_root then
			nodeParent = GetElement(WndFamilyOperate.m_root, "conRightUp_WndFamileOperate", WZUIContainer)
			relationPosition = GlobalMethod:ccp(0.5, 0.45)
			bShowAll = false
		elseif funcId == 28 and WndMounts.m_root then
			nodeParent = GetElement(WndMounts.m_root, "conForMount_WndMounts", WZUIContainer)
			relationPosition = GlobalMethod:ccp(0.1, 0.93)
			bShowAll = false
		elseif funcId == 76 and WndCard.m_root then
			nodeParent = GetElement(WndCard.m_root, "conTopMenu_WndCard", WZUIContainer)
			relationPosition = GlobalMethod:ccp(0,-2.6)
			bShowAll = false
		end
		if nodeParent and relationPosition then
			CreateLimitPackage(funcId, nodeParent, relationPosition, bShowAll)
		end
	end
end

--@brief  刷新足迹红点
function CacheCenter:updateFootMarkRedPoint()
	if not self.m_tFootMarkList then
		return
	end

	local isRed = false
    local itemList = CacheCenter:getFootMarkList()
    for i = 1, #self.m_tFootMarkList do
    	local data = self.m_tFootMarkList[i]
    	if not data.isHave then
    		for k,v in pairs(itemList) do
    			if data.item_id == v.id then
    				isRed = true
    				break
    			end
    		end
    	end

    	if isRed then
    		break
    	end
	end
  	WZLog("CacheCenter:updateFootMarkRedPoint",tostring(isRed))
    CacheCenter:setRedState("btnFootMark", isRed or GlobalGame.g_tRedPointList.footBeatCard)
    GlobalGame:getBtnRedPointEvent():dispatcher()
end

--@brief  拥有足迹的数据列表
function CacheCenter:setFootMarkData(footMarkId, upgradeLevel, advancedLevel, advancedBlessingValue, property, upgradeBlessingValue, fighting, remainingTime, useFootmark, collectStatus, starsSpecialAttr)
--	WZLog("CacheCenter:setFootMarkData",Serialize(VectorToTable(footMarkId)))
    -- 如果足迹列表未初始化，先初始化
	if not self.m_tFootMarkList then  CacheCenter:getAllFootMarkData() end

	for j = 1, #self.m_tFootMarkList do
		self.m_tFootMarkList[j].isHave = false
		self.m_tFootMarkList[j].upgradeLevel = 0
	end
--	WZLog("CacheCenter:setFootMarkData", Serialize(footMarkId), Serialize(remainingTime))
	self.m_nUseFootMarkId = useFootmark
	self.m_tStarsSpecialAttr = json.decode(starsSpecialAttr)
    -- 如果当前足迹，直接返回
    if #footMarkId == 0 then
        if WndFootMark.m_root then WndFootMark:initAllFootMarkData() end
        CacheCenter:updateFootMarkRedPoint()
        return
    end
    local nCurTime = SystemTime:getServerTime()
    -- 同步服务器的足迹最新信息
	for i = 1, #footMarkId do 
		-- WZLog("CacheCenter:setFootMarkData", footMarkId[i], remainingTime[i], upgradeLevel[i], advancedLevel[i])
--		WZLog("CacheCenter:setFootMarkData",collectStatus[i])
		for j = 1, #self.m_tFootMarkList do
			if self.m_tFootMarkList[j].id == footMarkId[i] then 
				self.m_tFootMarkList[j].isHave = true
				self.m_tFootMarkList[j].item_id = GDatatab_footmark["id_" .. footMarkId[i]].item_id
				self.m_tFootMarkList[j].upgradeLevel = upgradeLevel[i]
				self.m_tFootMarkList[j].advancedLevel = advancedLevel[i]
				self.m_tFootMarkList[j].blessingValue = advancedBlessingValue[i]
				self.m_tFootMarkList[j].upgradeBless = upgradeBlessingValue[i]
				self.m_tFootMarkList[j].property = json.decode(property[i])
				self.m_tFootMarkList[j].fighting = fighting[i]
				self.m_tFootMarkList[j].collectStatus = collectStatus[i] or 0
				if tonumber(remainingTime[i]) >= 0 then --体验时候保存结束时间
	            	self.m_tFootMarkList[j].remainTime = remainingTime[i] + nCurTime
	            else
	            	self.m_tFootMarkList[j].remainTime = remainingTime[i]
	            end
				self.m_tFootMarkList[j].basicInfo = GDatatab_item["id_" .. tostring(self.m_tFootMarkList[j].item_id)]
				break 
			end
		end
    end

    CacheCenter:updateFootMarkRedPoint()

	if WndFootMark.m_root then WndFootMark:initAllFootMarkData() end
end

--@brief	足迹成功信息（激活、升级、精炼）
function CacheCenter:updateFootMarkInfoOK(footmarkId, upgradeLevel, advancedLevel, advancedBlessingValue, property, fighting, originType, remainingTime, upgradeBlessingValue, collectStatus)
    WZLog("CacheCenter:updateFootMarkInfoOK", footmarkId, upgradeBlessingValue, remainingTime)
    local nCurTime = SystemTime:getServerTime()
    local bIsNewActivity = false 
	for i, data in pairs(self.m_tFootMarkList) do
		if tonumber(data.id) == tonumber(footmarkId) then
			data.upgradeLevel = upgradeLevel
			data.advancedLevel = advancedLevel
			data.blessingValue = advancedBlessingValue
			data.upgradeBless = upgradeBlessingValue
			data.collectStatus = collectStatus
			if remainingTime >= 0 then --体验时候保存结束时间
				if data.remainTime <= nCurTime then 
					bIsNewActivity = true
				end
				data.remainTime = remainingTime + nCurTime
			else  --永久激活时候
				bIsNewActivity = true
				data.remainTime = remainingTime
			end
			data.fighting = fighting
			data.isHave = true
			data.property = json.decode(property)
            break
		end
    end

    if WndFootMark.m_root == nil then 
    	if originType == 1 then 
    		if bIsNewActivity then 
    			WndFootMarkActive:showInterface(footmarkId)
    		else
    			WndFootMarkActive:showUseCarTips()
    		end
    	end
    end
    
    CacheCenter:updateFootMarkRedPoint()
end

--@brief 	使用的足迹变换
function CacheCenter:resetFootMarkState(useFootmarkId)
	-- body
	--保存原使用中的足迹
	local originFootMarkId = self.m_nUseFootMarkId
	self.m_nUseFootMarkId = useFootmarkId
	--更新原使用和现在使用的足迹的状态
	WndFootMark:changeFootMark(originFootMarkId, useFootmarkId)
end

--@brief 	足迹体验时间用完，更新数据
function CacheCenter:updateAfterUseTimeEnd(footMarkId)
	-- body
	for i,data in pairs(self.m_tFootMarkList) do
		if data.id == footMarkId then 
			data.isHave = false
			data.remainTime = 0 
			WZLog("CacheCenter:updateAfterUseTimeEnd")
			break 
		end
	end
end

--@brief 	设置保存的套装数据
function CacheCenter:setDressSuitData(id, suitName, bIsUsed)
	-- body
	self.m_tDressSuit = {}

	for i = 1, #id do
		local tItem = {}

		tItem.id = id[i]
		tItem.name = suitName[i]
		tItem.bIsUsed = bIsUsed[i] 

		table.insert(self.m_tDressSuit, tItem)
	end

	local function getUseValue(a)
		-- body
		if a.bIsUsed == true then
			return 0
		else
			return 1
		end
	end

	table.sort(self.m_tDressSuit, function (a, b)
		-- body
		return a.id < b.id
	end)

	WZLog("CacheCenter:setDressSuitData", Serialize(self.m_tDressSuit))
end

--@brief 	套装改名
function CacheCenter:dressSuitRename(id, newName)
	-- body
	if self.m_tDressSuit == nil then return end 
	for i = 1, #self.m_tDressSuit do
		if self.m_tDressSuit[i].id == id then
			self.m_tDressSuit[i].name = newName

			break 
		end
	end
end

--@brief 	新增套装
function CacheCenter:addNewDressSuit(id, name)
	-- body
	if self.m_tDressSuit == nil then
		self.m_tDressSuit = {}
	end

	local tItem = {}

	tItem.id = id
	tItem.name = name
	tItem.bIsUsed = false

	table.insert(self.m_tDressSuit, tItem)
end

--@brief 	设置宠物装备方案数据
function CacheCenter:setPetEquipSchemeData(id, suitName, bIsUsed)
	self.m_tPetEquipSchemeData = {}

	for i = 1, #id do
		local tItem = {}

		tItem.id = id[i]
		tItem.name = suitName[i]
		tItem.bIsUsed = bIsUsed[i] 

		table.insert(self.m_tPetEquipSchemeData, tItem)
	end

	local function getUseValue(a)
		if a.bIsUsed == true then
			return 0
		else
			return 1
		end
	end

	table.sort(self.m_tPetEquipSchemeData, function (a, b)
		return a.id < b.id
	end)

	WZLog("CacheCenter:setPetEquipSchemeData", Serialize(self.m_tPetEquipSchemeData))
end


--@brief 	套装改名
function CacheCenter:petEquipSchemeRename(id, newName)
	if self.m_tPetEquipSchemeData == nil then return end 
	for i = 1, #self.m_tPetEquipSchemeData do
		if self.m_tPetEquipSchemeData[i].id == id then
			self.m_tPetEquipSchemeData[i].name = newName

			break 
		end
	end
end

--@brief 	新增套装
function CacheCenter:addNewPetEquipScheme(id, name)
	if self.m_tPetEquipSchemeData == nil then
		self.m_tPetEquipSchemeData = {}
	end

	local tItem = {}

	tItem.id = id
	tItem.name = name
	tItem.bIsUsed = false

	table.insert(self.m_tPetEquipSchemeData, tItem)
end

--@brief 	设置好友黑名单数据
function CacheCenter:setFriendBlacklistData(playerId, playerName, level, sex ,faceItemId ,headItemId,isOnline, vipLevel, serverId, headColor, headEffectId)
	--body
	self.m_tFriendBlacklist = {}
	for i = 0, playerId:size()-1 do 
		local level , reinc = ChangeLevelReinc(level:get(i))
		local temp = {}
		temp.level = level
		temp.reinc = reinc
		temp.id = playerId:get(i)
		temp.name = playerName:get(i)		
		temp.sex = sex:get(i)		
		temp.faceItemId = faceItemId:get(i)
		temp.headItemId = headItemId:get(i)
		temp.isOnline = isOnline:get(i)
		temp.vipLevel = vipLevel:get(i)
		temp.serverId = serverId:get(i)
		temp.headColor = headColor:get(i)
		temp.headEffectId = headEffectId and headEffectId:size() > 0 and headEffectId:get(i) or 0

		table.insert(self.m_tFriendBlacklist, temp)
	end
end

--@brief 	拒绝或同意收徒或拜师请求后，处理缓存中的拜师或收徒数据
function CacheCenter:dealwithMasterMessageAfterOperate()
	-- body
	if self.m_tChatCache == nil or self.m_tChatCache == {} or g_nOperatePlayerId == nil then return end 

	WZLog("CacheCenter:dealwithMasterMessageAfterOperate", Serialize(self.m_tChatCache), g_nOperatePlayerId)
	for i, v in ipairs(self.m_tChatCache) do
		if tonumber(v[2]) == g_nOperatePlayerId then
			v[2] = string.gsub(v[2], g_nOperatePlayerId, "")
		end
	end
end

--@brief 	--增加黑名单
function CacheCenter:delFriendBlacklist(playerId)
	-- body
	for i = 1, #self.m_tFriendBlacklist do
		if self.m_tFriendBlacklist[i].id == playerId then
			table.remove(self.m_tFriendBlacklist, i)
			break 
		end
	end
end

--@brief	设置小家背包玩家物品列表缓存信息
function CacheCenter:setPlayerKidHomeItems(itemId, lastNum, lastTime, isUse, playerItemId, ownerId, childId)
	self.m_tPlayerHomeItemList = {}

	local mainType = 0

	local receiveTime = SystemTime:getServerTime()
--	WZLog("CacheCenter:setPlayerKidHomeItems", Serialize(VectorToTable(itemId)), Serialize(VectorToTable(isUse)), Serialize(VectorToTable(childId)))
	for i=0,itemId:size() - 1 do
		local tTempItem = {}
		tTempItem.id = itemId:get(i)
		tTempItem.lastTime = lastTime:get(i)
		tTempItem.lastNum = lastNum:get(i)
		tTempItem.isUse = isUse:get(i)
		tTempItem.playerItemId = playerItemId:get(i)
		tTempItem.ownerId = ownerId:get(i)
		tTempItem.receiveTime = receiveTime - 2
		tTempItem.childId = childId:get(i)

		--tTempItem.lastTime = 3300

		--物品基础数据
		local key = "id_"..itemId:get(i)
		tTempItem.basicInfo = CopyTable(GDatatab_item[key])
		if tTempItem.basicInfo ~= nil then
			tTempItem.maintype = tTempItem.basicInfo.main_type
			tTempItem.subtype = tTempItem.basicInfo.sub_type

			if tTempItem.basicInfo.use_type == 0 then--num 
				if tTempItem.maintype ~= 4 then
					tTempItem.lastTime = tTempItem.lastNum
				else
					tTempItem.lastNum = 1
				end
			else
				tTempItem.lastNum = tTempItem.lastTime
			end
		end
		--物品附加数据
		-- tTempItem.extraInfo = json.decode(data:get(i)) 
		-- if tTempItem.maintype == 31 then
		-- 	local nFighting = caculateClothesFighting(tTempItem.extraInfo)
		-- 	tTempItem.extraInfo.fighting = nFighting
		-- end

		table.insert(self.m_tPlayerHomeItemList, tTempItem)
	end

	-- WZLog("CacheCenter:setPlayerItems",Serialize(self.m_tPlayerHomeItemList))

	--保存系统时间
	SETITEMSTIME = os.time()

	--通知监测者物品列表数据更新
	-- if SceneBattle.m_root == nil then
	-- 	self:_receivePlayerItemData()
	-- end
end

--@brief 	审核双修请求结果
function CacheCenter:ApprovalDoublePracticeResult(playerId, result, nType)
	WndFriends:RefreshInterface(nil, nil, 3)
end

--@brief 	设置纪念币充值数据
function CacheCenter:setMarkCoinRechargeData(ids, icons, number, giftNumber, price, payCodeId, flag, name, remark,showPrice,itemId,sortId,leftTimes, limitType, needVipLv)
	-- body
	for i = 1, #ids do
		if itemId[i] == 81 then 
	        self.m_tMarkCoinData = {
	            ids = ids[i],
	            icons = "shopitems/payment_7_shengxing.png",--icons[i],
	            number = number[i],
	            giftNumber = giftNumber[i],
	            price = price[i],
	            payCodeId = payCodeId[i],
	            flag = flag[i],
	            name = name[i],
	            remark = remark[i],
	            showPrice = showPrice[i],
	            itemId = itemId[i],
	            sortId = sortId[i],
	            leftTimes = leftTimes[i],
	            limitType = limitType[i],
	            needVipLv = needVipLv[i],
	        }
	        break 
	    end
    end
end

--@brief 	设置职业数据
function CacheCenter:setProfessionData(status, profession, node, talentSkill, roleNode, roleTalentSkill, petNode, petTalentSkill)
	-- body
	self.m_tProfessionData = {}
	self.m_tProfessionData.status = status
	self.m_tProfessionData.professionId = profession
	self.m_tProfessionData.node = node
	self.m_tProfessionData.talentSkill = talentSkill 
	--二转技能
	self.m_tProfessionData.secondRoleNode = roleNode
	self.m_tProfessionData.secondRoleTalentSkill = roleTalentSkill
	self.m_tProfessionData.petNode = petNode
	self.m_tProfessionData.petTalentSkill = petTalentSkill 
end

--@brief 	设置保存的技能方案数据
function CacheCenter:setSkillSuitData(id, suitName, bIsUsed)
	-- body
	self.m_tSkillSuit = {}

	for i = 1, #id do
		local tItem = {}

		tItem.id = id[i]
		tItem.name = suitName[i]
		tItem.bIsUsed = bIsUsed[i] 

		table.insert(self.m_tSkillSuit, tItem)
	end

	local function getUseValue(a)
		-- body
		if a.bIsUsed == true then
			return 0
		else
			return 1
		end
	end

	table.sort(self.m_tSkillSuit, function (a, b)
		-- body
		return a.id < b.id
	end)

	WZLog("CacheCenter:setSkillSuitData", Serialize(self.m_tSkillSuit))
end

--@brief 	套装改名
function CacheCenter:skillSuitRename(id, newName)
	-- body
	if self.m_tSkillSuit == nil then return end 
	for i = 1, #self.m_tSkillSuit do
		if self.m_tSkillSuit[i].id == id then
			self.m_tSkillSuit[i].name = newName

			break 
		end
	end
end

--@brief 	新增套装
function CacheCenter:addNewSkillSuit(id, name)
	-- body
	if self.m_tSkillSuit == nil then
		self.m_tSkillSuit = {}
	end

	local tItem = {}

	tItem.id = id
	tItem.name = name
	tItem.bIsUsed = false

	table.insert(self.m_tSkillSuit, tItem)
end

function CacheCenter:resetFriendRemarkName(playerId, remarkName)
	--body
	local tFriends = CacheCenter:getCurrentFriendList(  )
	if tFriends == nil or #tFriends == 0 then return end 

	for i = 1, #tFriends do
		if tFriends[i].id == playerId then 
			tFriends[i].remarkName = remarkName
			break 
		end
	end
end

--@brief 	皮肤图鉴领取状态
function CacheCenter:setSkinStatus(shapeId,Status)
 	-- body
 	self.m_tSkinStatus = {}
 	-- self.m_tSkinStatus = Status
-- 	WZLog("皮肤图鉴领取状态",Serialize(shapeId),Serialize(Status))
 	for i = 1,#shapeId do
 		local tempList = {}
 		tempList.id = shapeId[i]
 		tempList.status = Status[i] or 0
 		table.insert(self.m_tSkinStatus,tempList)
 	end
end 

--@brief 	设置玩家小孩的辅助技能
function CacheCenter:setKidAssistSkillData(childId, childName, childSex, childLevel, childHeadId, childFaceId, childBodyId, useSkill, unlockRemark, unlockSkill, unlockSkillNum, headEffectId)
	-- body
	if self.m_tAssistSkill.kidSkill == nil then 
		self.m_tAssistSkill.kidSkill = {}
	end

	-- if childId > 0 then 
	-- 	local useSkillNum = 0 
	-- 	local bHaveNullGrid = false 
	-- 	for i, v in pairs(useSkill) do
	-- 		if v == 0 then 
	-- 			bHaveNullGrid = true 
	-- 		elseif v > 0 then 
	-- 			useSkillNum = useSkillNum + 1 
	-- 		end
	-- 	end

	-- 	local unlockNum = 0
	-- 	for i = 1, #unlockSkillNum do
	-- 		if unlockSkillNum[i] > 0 then 
	-- 			unlockNum = unlockNum + 1
	-- 		end
	-- 	end
	-- 	if useSkillNum < unlockNum and bHaveNullGrid then 
	-- 		self.m_bIsAssistSkillRed = true 
	-- 	end
	-- end

	local kidSkill = {}
	kidSkill.kidId = childId
	kidSkill.kidName = childName
	kidSkill.kidSex = childSex
	kidSkill.kidAge = childLevel
	kidSkill.kidHeadId = childHeadId
	kidSkill.kidFaceId = childFaceId
	kidSkill.kidBodyId = childBodyId
	kidSkill.key = "kid"
	kidSkill.skillId = useSkill
	kidSkill.skillExplain = unlockRemark
	kidSkill.unlockSkill = unlockSkill
	kidSkill.unlockSkillNum = unlockSkillNum
	kidSkill.headEffectId = headEffectId

	self.m_tAssistSkill.kidSkill = kidSkill

	WndAssistSkill:receiveGetKidSkillOk(kidSkill)
end

--@brief 	设置玩家坐骑的辅助技能
function CacheCenter:setMountAssistSkillData(mountsId, useProp, unlockRemark, unlockSkill, unlockSkillNum)
	-- body
	if self.m_tAssistSkill.mountSkill == nil then 
		self.m_tAssistSkill.mountSkill = {}
	end

	-- if mountsId > 0 then 
	-- 	local useSkillNum = 0 
	-- 	local bHaveNullGrid = false 
	-- 	for i, v in pairs(useProp) do
	-- 		if v == 0 then 
	-- 			bHaveNullGrid = true 
	-- 		elseif v > 0 then 
	-- 			useSkillNum = useSkillNum + 1 
	-- 		end
	-- 	end

	-- 	local unlockNum = 0
	-- 	for i = 1, #unlockSkillNum do
	-- 		if unlockSkillNum[i] > 0 then 
	-- 			unlockNum = unlockNum + 1
	-- 		end
	-- 	end
	-- 	if useSkillNum < unlockNum and bHaveNullGrid then 
	-- 		self.m_bIsAssistSkillRed = true 
	-- 	end
	-- end

	local mountSkill = {}
	mountSkill.mountId = mountsId
	mountSkill.skillId = useProp
	mountSkill.key = "mount"
	mountSkill.skillExplain = unlockRemark
	mountSkill.unlockSkill = unlockSkill
	mountSkill.unlockSkillNum = unlockSkillNum

	self.m_tAssistSkill.mountSkill = mountSkill

	WndAssistSkill:receiveGetMountSkillOk(mountSkill)
end

--图鉴的梳理分类处理
function CacheCenter:setLibrayData()
	if self.mLibraryData then
		return self.mLibraryData
	end
	if not self.mLibraryData then
 		self.mLibraryData = {}
 	end
 	local table_insert = table.insert
 	if self.mLibraryData then
 		for _,v in pairs(GDatatab_item) do
 			if type(v.pokedex) == "table" then
 				local _type = v.pokedex[1][1]
 				local num = v.pokedex[1][2]
 				--道具的时候特殊处理
 				if _type == 2 and num == 2 then
 				else
	 				if _type == 5 then
	 					_type = 9
	 				elseif _type == 6 then
	 					_type = 10
	 				end
	 				if self.mLibraryData[_type] == nil then
						self.mLibraryData[_type] = {}
					end
					if _type == 2 and num == 3 then
						num = 2
					end
					if _type == 10 and num == 4 then
						num = 3
					end
					if self.mLibraryData[_type][num] == nil then
						self.mLibraryData[_type][num] = {}
					end
					local itemInfo = GDatatab_item["id_" ..v.id]
					table_insert(self.mLibraryData[_type][num], itemInfo)
				end
 			end
 		end
 	end
 	--坐骑 足迹 皮肤
 	for i=5,7 do
	 	if self.mLibraryData[i] == nil then
			self.mLibraryData[i] = {}
			local data
			if i == 5 then
				data = GDatatab_mounts
			elseif i == 6 then
				data = GDatatab_footmark
			elseif i == 7 then
				data = GDatatab_shape_skins
			end
			for m,v in pairs(data) do
				if self.mLibraryData[i][v.type] == nil then
					self.mLibraryData[i][v.type] = {}
				end
				if type(v.reward) == "table" then
					local id = v.item_id
					if i == 7 then
						id = v.channel
					end
					if GDatatab_item["id_"..id] then
						local itemInfo = CopyTable(GDatatab_item["id_"..id])
						itemInfo.pokedex = v.reward
						table_insert(self.mLibraryData[i][v.type], itemInfo)
					end
				end
			end
		end
	end
 	return self.mLibraryData
end
--玩家图鉴缓存
function CacheCenter:setPlayerLibraryData(level,exp,fettersItemId,fetterId,fetterCollectNum)
	self:setPlayerLibraryInfo(level, exp)

	if not self.m_tPlayerLibraryItemList then
		self.m_tPlayerLibraryItemList = {}
	end
	for i=1,#fettersItemId do
		if self.m_tPlayerLibraryItemList[fettersItemId[i]] == nil then
			self.m_tPlayerLibraryItemList[fettersItemId[i]] = true
		end
	end
end
function CacheCenter:setPlayerLibraryInfo(level, exp)
	local tab = {}
	tab.level = level
	tab.exp = exp
	self.m_tPlayerLibraryInfo = tab
end
function CacheCenter:getPlayerLibraryInfo()
	return self.m_tPlayerLibraryInfo
end
function CacheCenter:getPlayerLibraryItemData()
	return self.m_tPlayerLibraryItemList
end

--@brief 	设置玩家岛主数据 复仇相关
function CacheCenter:setIslandOwnerData(mapId, createTime, leaveTime, reward, playerNum, playerId, serverId, name, sex, vipLevel, headId, headColor, faceId, fight)
	self.m_tIslandOwnerData = {}
	local nPlayerIndex = 1
	for i=1,#mapId do
		local tempData = {}
		tempData.mapId = mapId[i]
		tempData.createTime = createTime[i]
		tempData.leaveTime = leaveTime[i]
		tempData.reward = reward[i]
		tempData.playerNum = playerNum[i]
		tempData.playerData = {}
		for j=1,playerNum[i] do
			local tempPlayer = {}
			tempPlayer.playerId = playerId[nPlayerIndex]
			tempPlayer.serverId = serverId[nPlayerIndex]
			tempPlayer.name = name[nPlayerIndex]
			tempPlayer.sex = sex[nPlayerIndex]
			tempPlayer.vipLevel = vipLevel[nPlayerIndex]
			tempPlayer.headId = headId[nPlayerIndex]
			tempPlayer.headColor = headColor[nPlayerIndex]
			tempPlayer.faceId = faceId[nPlayerIndex]
			tempPlayer.fight = fight[nPlayerIndex]
			table.insert(tempData.playerData,tempPlayer)

			nPlayerIndex = nPlayerIndex + 1
		end

		table.insert(self.m_tIslandOwnerData,tempData)
	end
end

--@brief 	获取玩家岛主数据 复仇相关
function CacheCenter:getIslandOwnerData()
	return self.m_tIslandOwnerData
end

--@brief 	取消一个玩家岛主数据
function CacheCenter:removeIslandOwnerData(nMapId)
	for i=#self.m_tIslandOwnerData,1,-1 do
		if self.m_tIslandOwnerData[i].mapId == nMapId then
			table.remove(self.m_tIslandOwnerData,i)
		end
	end
end

--@brief 	设置玩家岛主红点数据
function CacheCenter:setIslandOwnerRedData(tMapId)
	self.m_tIslandOwnerRedData = tMapId
end

--@brief 	获取玩家岛主红点数据
function CacheCenter:getIslandOwnerRedData()
	return self.m_tIslandOwnerRedData
end

--@brief 	取消一个玩家岛主红点数据
function CacheCenter:removeIslandOwnerRedData(nMapId)
	for i=#self.m_tIslandOwnerRedData,1,-1 do
		if self.m_tIslandOwnerRedData[i] == nMapId then
			table.remove(self.m_tIslandOwnerRedData,i)
		end
	end
end

--@brief 	设置主动皮肤大招数据,单人战斗(比如日常副本,爬塔副本,训练营副本)的时候需要用到默认皮肤大招和皮肤列表数据
function CacheCenter:setSkinBigSkillData(skillType, useSkill, skillList, shapeList)
    if skillType == 2 then
        self.m_tDefaultShapeBigSkill = useSkill
        self.m_tShapeBigSkillList = skillList
    end
end

--@brief	设置联盟信息
function CacheCenter:setUnionInfo(id, name, level, exp, joinLimitLv, joinLimitVipLv, joinLimitFight, examine, memberNum, totemLevel, schoolLevel, playerId, headId, faceId, colour, headEffectId, playerName, playerLevel, vipLevel, sex, loginTime, isOnline, post, fight, donate, totalDonate)
	if id ~= CacheCenter:getPlayerInfo().unionInfo.id then return end 
	
	self.m_tUnionInfo = {}
	self.m_tUnionInfo.guildId = id
	self.m_tUnionInfo.guildName = name
	self.m_tUnionInfo.guildLevel = level
	self.m_tUnionInfo.prestige = exp
	self.m_tUnionInfo.members = memberNum
	self.m_tUnionInfo.setting = joinLimitLv
	self.m_tUnionInfo.totemLevel = totemLevel
	self.m_tUnionInfo.schoolLevel = schoolLevel
	self.m_tUnionInfo.storeLevel = storeLevel
	self.m_tUnionInfo.examine = examine
	self.m_tUnionInfo.joinVipLevel = joinLimitVipLv
	self.m_tUnionInfo.fight = joinLimitFight
	
	for i=1,#playerId do
		if playerId[i] == CacheCenter:getPlayerInfo().id then
			self.m_tUnionInfo.level = playerLevel[i]
			self.m_tUnionInfo.position = post[i]
			self.m_tUnionInfo.donate = donate[i]
			self.m_tUnionInfo.totalDonate = totalDonate[i]
			self.m_tUnionInfo.sex = sex[i]
			self.m_tUnionInfo.vipLevel = vipLevel[i]
			break 
		end
	end
end

--@brief 	设置已进阶的时装套装Id数据
function CacheCenter:setDressAdvanceId(advanceEnchantingIds)
	if self.m_tHavedAdvanceDressIds == nil then 
		self.m_tHavedAdvanceDressIds = {}
	end

	self.m_tHavedAdvanceDressIds = advanceEnchantingIds
end

--@brief 	设置已进阶的翅膀Id数据
function CacheCenter:setWingAdvanceId(advanceEnchantingIds)
	if self.m_tHavedAdvanceWingIds == nil then 
		self.m_tHavedAdvanceWingIds = {}
	end

	self.m_tHavedAdvanceWingIds = advanceEnchantingIds
end