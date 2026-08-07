--ProtocolProcessorCache.lua
--@brief	客户端缓存中心相关协议
--@date  	2014/8/20
--@author 	刘凑贵
--@note 	关于相关协议

 
ProtocolProcessorCache = ProtocolProcessorBase:new()

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorCache:regAll()
	WZLog("ProtocolProcessorCache:regAll")
	--注册接收协议
	--@brief	角色信息（CACHE_PlayerInfo = 1）
	self:regProtocolCallbackFunction( Protocol.MAIN_CACHE, Protocol.CACHE_PlayerInfo, "ProtocolProcessorCache:parse_CACHE_PlayerInfo", "isisssiiiiiiissiiisiiisssiiiitiinsisiisiissviiivstisviviiiiiiitiivsisviviisiisssiiisiiiiisisiiivsssviiissssssiivssiviviiiisvssssisis")
	
	--@brief	物品信息（CACHE_PlayerItemCache = 2）
	self:regProtocolCallbackFunction( Protocol.MAIN_CACHE, Protocol.CACHE_PlayerItemCache, "ProtocolProcessorCache:parse_CACHE_PlayerItemCache", "vivsvivbvsviviviii")

	--@brief	更新角色信息（CACHE_UpdatePlayer = 5）(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_CACHE, Protocol.CACHE_UpdatePlayer, "ProtocolProcessorCache:parse_CACHE_UpdatePlayer", "vsvs")

	--@brief	增加物品(CACHE_AddItemCache = 6)
	self:regProtocolCallbackFunction( Protocol.MAIN_CACHE, Protocol.CACHE_AddItemCache, "ProtocolProcessorCache:parse_CACHE_AddItemCache", "vivsvivbvsvivi")

	--@brief	删除物品信息（CACHE_RemoveItemCache = 7）
	self:regProtocolCallbackFunction( Protocol.MAIN_CACHE, Protocol.CACHE_RemoveItemCache, "ProtocolProcessorCache:parse_CACHE_RemoveItemCache", "vivi")

	--@brief	更新物品信息（CACHE_UpdateItemCache = 8）
	self:regProtocolCallbackFunction( Protocol.MAIN_CACHE, Protocol.CACHE_UpdateItemCache, "ProtocolProcessorCache:parse_CACHE_UpdateItemCache", "ivsvs")

	--@brief	爱心许愿物品列表（CACHE_WishList = 11）
	self:regProtocolCallbackFunction( Protocol.MAIN_CACHE, Protocol.CACHE_WishList, "ProtocolProcessorCache:parse_CACHE_WishList", "vivivivs")

	--@brief	祝福礼盒物品列表（CACHE_ZflhList = 12）
	self:regProtocolCallbackFunction( Protocol.MAIN_CACHE, Protocol.CACHE_ZflhList, "ProtocolProcessorCache:parse_CACHE_ZflhList", "vivsvsvi")

	--@brief	游戏参数（CACHE_GameParam = 16）
	self:regProtocolCallbackFunction( Protocol.MAIN_CACHE, Protocol.CACHE_GameParam, "ProtocolProcessorCache:parse_CACHE_GameParam", "vsvs")

	--@brief	系统相关协议
	self:regProtocolCallbackFunction( Protocol.MAIN_SYSTEM, Protocol.SYSTEM_NextDay, "ProtocolProcessorCache:parse_SYSTEM_NextDay", "i")

	--@brief	保存个人第三方信息（PLAYER_SaveFacebook = 3）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_SaveFacebook, "ProtocolProcessorCache:send_PLAYER_SaveFacebook_ErrorProcess", "is" )

	--@brief	更新个人第三方信息成功（PLAYER_SaveFacebookOK = 4）
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_SaveFacebookOK, "ProtocolProcessorCache:parse_PLAYER_SaveFacebookOK", "i")

	--@brief	更新祈福召唤次数结果（CACHE_UpdateDataOk = 17）
	self:regProtocolCallbackFunction( Protocol.MAIN_CACHE, Protocol.CACHE_UpdateDataOk, "ProtocolProcessorCache:parse_CACHE_UpdateDataOk", "i")

	--@brief    公会战任务进度（CACHE_GuildWarTaskOk = 18）
    self:regProtocolCallbackFunction( Protocol.MAIN_CACHE, Protocol.CACHE_GuildWarTaskOk, "ProtocolProcessorCache:parse_CACHE_GuildWarTaskOk", "vivivi")

    --@brief	公寓物品（WEDDING_GetHouseItemCacheOk = 88）
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetHouseItemCacheOk, "ProtocolProcessorCache:parse_WEDDING_GetHouseItemCacheOk", "vivivivivbvivi")

	--@brief	新增公寓物品（WEDDING_AddHouseItemCache = 89）
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_AddHouseItemCache, "ProtocolProcessorCache:parse_WEDDING_AddHouseItemCache", "vivivivivbvivi")

	--@brief	移除公寓物品（WEDDING_RemoveHouseItemCache = 91）
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_RemoveHouseItemCache, "ProtocolProcessorCache:parse_WEDDING_RemoveHouseItemCache", "vivi")

	--@brief	更新公寓物品（WEDDING_UpdateHouseItemCache = 90）
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_UpdateHouseItemCache, "ProtocolProcessorCache:parse_WEDDING_UpdateHouseItemCache", "iivsvs")


    --@brief	批量更新物品信息（CACHE_BatchUpdateItemCache = 19）
	self:regProtocolCallbackFunction( Protocol.MAIN_CACHE, Protocol.CACHE_BatchUpdateItemCache, "ProtocolProcessorCache:parse_CACHE_BatchUpdateItemCache", "vivs")

	--批量更新
	self:regProtocolCallbackFunction( Protocol.MAIN_CACHE, Protocol.CACHE_UpdateItemsCache, "ProtocolProcessorCache:parse_CACHE_UpdateItemsCache", "vivivsvs")
	--@brief	玩家图鉴缓存（CACHE_PlayerPokedexCache = 22）
	self:regProtocolCallbackFunction( Protocol.MAIN_CACHE, Protocol.CACHE_PlayerPokedexCache, "ProtocolProcessorCache:parse_CACHE_PlayerPokedexCache", "iivivivi")
	--@brief	玩家附属数据缓存（CACHE_PlayerExtInfoCache = 23）
	self:regProtocolCallbackFunction( Protocol.MAIN_CACHE, Protocol.CACHE_PlayerExtInfoCache, "ProtocolProcessorCache:parse_CACHE_PlayerExtInfoCache", "vivi")
end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorCache:unregAll()
	self:clearReg()
end
  
-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief	保存个人第三方信息（PLAYER_SaveFacebook = 3）
function ProtocolProcessorCache:send_PLAYER_SaveFacebook(platform, nickName, comeFrom, faceIcon )
	WZLog("send_PLAYER_SaveFacebook")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_SaveFacebook )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( platform )	-- 平台标记 1:facebook 2：
	sender:writeString( nickName )	-- 玩家平台昵称
	sender:writeString( comeFrom )	-- 玩家来自哪里
	sender:writeString( faceIcon )	-- 头像URL
	SendProtocol(sender,false) --true:showLoading
end


-------------------------------------服务器到客户端协议回调方法模块--------------------------------------
--@brief	物品信息（CACHE_PlayerItemCache = 2）
function ProtocolProcessorCache:parse_CACHE_PlayerItemCache(itemId, lastNum, lastTime, isUse, data, playerItemId, disappearTime, color, startTag, endTag)
	-- itemId : 物品ID
	-- lastNum : 剩余数量，如果是-1，就是不限数量使用
	-- lastTime : 剩余的天数，如果是-1，就是不限时间使用
	-- isUse : 是否装备在身上
	-- data : 内容JSON格式如：{"starLevel":8,"strongLevel":3} 详见：数据字典
	-- playerItemId : 玩家物品ID(唯一)
	-- startTag, endTag 协议开始和结束的标识位
	
	-- WZLog("ProtocolProcessorCache:parse_CACHE_PlayerItemCache", 
	-- 	"\nitemId",Serialize(VectorToTable(itemId)), 
	-- 	"\nlastNum",Serialize(VectorToTable(lastNum)), 
	-- 	"\nlastTime",Serialize(VectorToTable(lastTime)), 
	-- 	"\nisUse",Serialize(VectorToTable(isUse)), 
	-- 	"\ndata",Serialize(VectorToTable(data)), 
	-- 	"\nplayerItemId",Serialize(VectorToTable(playerItemId)), 
	-- 	"\ndisappearTime",Serialize(VectorToTable(disappearTime)), 
	-- 	"\ncolor",Serialize(VectorToTable(color)), 
	-- 	"\nstartTag",Serialize(VectorToTable(startTag)), 
	-- 	"\nendTag",Serialize(VectorToTable(endTag)))

	CacheCenter:setPlayerItems(itemId, lastNum, lastTime, isUse, data, playerItemId, disappearTime, color, startTag, endTag)
end

--@brief	增加物品(CACHE_AddItemCache = 6)
function ProtocolProcessorCache:parse_CACHE_AddItemCache(itemId, lastNum, lastTime, isUse, data, playerItemId, disappearTime)
	-- itemId : 物品ID
	-- lastNum : 剩余数量，如果是-1，就是不限数量使用
	-- lastTime : 剩余的天数，如果是-1，就是不限时间使用
	-- isUse : 是否装备在身上
	-- data : 内容JSON格式如：{"starLevel":8,"strongLevel":3} 详见：数据字典
	-- playerItemId : 玩家物品ID(唯一)
	WZLog("ProtocolProcessorCache:parse_CACHE_AddItemCache")
	CacheCenter:addPlayerItem(itemId, lastNum, lastTime, isUse, data, playerItemId, disappearTime)
	GlobalGame:getGameEventDispathcer():Dispatch(GlobalEvent.GlobalEvent_AddItem, VectorToTable(itemId))
end

--@brief	删除物品信息（CACHE_RemoveItemCache = 7）
function ProtocolProcessorCache:parse_CACHE_RemoveItemCache(playerItemId, itemId)
	-- playerItemId : PlayerItemVo中的voId,代表玩家物品的唯一标识
	-- itemId : 道具id
	WZLog("ProtocolProcessorCache:parse_CACHE_RemoveItemCache",Serialize(VectorToTable(playerItemId)),Serialize(VectorToTable(itemId)))
	CacheCenter:removePlayerItems(VectorToTable(playerItemId), VectorToTable(itemId))
end

--@brief	更新物品信息（CACHE_UpdateItemCache = 8）
function ProtocolProcessorCache:parse_CACHE_UpdateItemCache(playerItemId, key, value)
	-- voId : PlayerItemVo中的voId,代表玩家物品的唯一标识
	-- key : 字段
	-- value : 值
	WZLog("ProtocolProcessorCache:parse_CACHE_UpdateItemCache")
	CacheCenter:updatePlayerItems(playerItemId, VectorToTable(key), VectorToTable(value))

    local isEndTeach, step = TeachGroup1:isTeachFinish(8)
    if isEndTeach ~= true and step > 0 then
        TeachGroup1:startGroup({8,5,WndBagMain.m_root})
    end
end

--@brief	物品数量批量更新处理
function ProtocolProcessorCache:parse_CACHE_UpdateItemsCache(playerItemId, splitCount, key, value)
	-- playerItemId : 物品id
	-- splitCount : 切割数量
	-- key : 值
	WZLog("ProtocolProcessorCache:parse_CACHE_UpdateItemsCache")
	CacheCenter:setCacheUpdataItem(VectorToTable(playerItemId), VectorToTable(splitCount), VectorToTable(key), VectorToTable(value))
end
--@brief	玩家图鉴缓存（CACHE_PlayerPokedexCache = 22）
function ProtocolProcessorCache:parse_CACHE_PlayerPokedexCache(level, exp, fettersItemId, fetterId, fetterCollectNum)
	-- level : 玩家图鉴等级
	-- exp : 玩家图鉴经验
	-- fettersItemId : 玩家获得过图鉴羁绊物品【只含最低品质】
	-- fetterId : 图鉴羁绊ID
	-- fetterCollectNum : 图鉴羁绊收集数量
	CacheCenter:setPlayerLibraryData(level,exp,VectorToTable(fettersItemId),VectorToTable(fetterId),VectorToTable(fetterCollectNum))
end

--@brief	角色信息（CACHE_PlayerInfo = 1）
function ProtocolProcessorCache:parse_CACHE_PlayerInfo(id, name, sex, title, guildName, position, level, exp, maxExp, vipLevel, winNum, playNum, fighting, mateName, 
	signature, vigor, maxVigor, guildId, property, strongSuitId, starSuitId, mosaicSuitId, petMessage, mountsMessage, fashionProperty, fashionFighting, 
	tournamentLevel, tournamentIntegral, itemSuitId, itemSuitNum, segmentLevel, totemLevel, lovelLevel, loveSkill, moralityLevel, masterName, vipExp, segmentExp, 
	rankMatchMessage, guildLevel, buyTimesPS, headScul, snsValue, starsoulId, spaceSex, giftNum, allMountsMessage, marryFlag, teamId, prayInfo, xlId, xlExp, shapeId, 
	shapeLevel, showShape, awakeSoulLevel, awakeStep, itemSuitId2, itemSuitNum2, homeLevel, sheerLuxury, footMark, shapeSkillId, awakeSkillId, runeItemId, 
	runeItemNum, obtainNum, cardMessage, bgId, showMes, coupleMes, childMes, careBuffProp, careToday, headSculStatus, thumbUpNum, badgeInfo, helpTime, assistTime, 
	professionId, myMaxSegmentLevel, masterId, shapeBigSkillId, awakeAssistTime, ylJsonInfo, honourPoint, itemSuitStrongNum, itemSuitStarNum, shape,
	shapeFetterProperties, soulInfo, rpIds, wedBufLevel, wedBufTime, loveSkill2, professionAttr1, professionAttr2, vipMedal, phantomEquipment, 
	chatShortcut, pastureId,spriteStoneFp,spriteStoneInfo,pupliInfo,myMoralityLevel, footMarkCityIds, footMarkCityTimes, levelBreachId, useShapeGroupId, 
	useShapeGroupAdvanceLevel, qqHallInfo, petEquip, runeResonateAdd, cardSoulBuffAdd, guildBaptismAdd, chatShield, zlsJsonInfo, praiseRewardStatus, leagueInfo)
		
	-- id : Id
	-- name : 名称
	-- sex : 性别
	-- title : 称号
	-- guildName : 公会名称
	-- position : 公会职务
	-- level : 等级
	-- exp : 当前经验
	-- maxExp : 该等级升级所需经验
	-- vipLevel : vip等级0表示非VIP
	-- winNum : 胜利次数
	-- playNum : 游戏次数
	-- fighting : 战斗力
	-- mateName : 伴侣名称
	-- signature : 个性签名
	-- vigor : 当前活力值
	-- maxVigor : 最大活力值
	-- guildId : 公会ID
	-- property : 属性，json格式
	-- strongSuitId : 强化套装id 没有为0
	-- starSuitId : 升星套装id 没有为0
	-- mosaicSuitId : 镶嵌套装id 没有为0
	-- petMessage : 宠物信息，json格式
	-- mountsMessage : 坐骑信息，json格式
	-- fashionProperty : 时装属性加成,json格式
	-- fashionFighting : 时装战斗力加成
	-- tournamentLevel : 竞技等级
	-- tournamentIntegral : 竞技积分
	-- itemSuitId : 套装装备id
	-- itemSuitNum : n件套
	-- segmentLevel : 排位赛等级
	-- totemLevel : 公会图腾等级
	-- lovelLevel : 恩爱等级
	-- loveSkill : 夫妻技能Json字符串，（技能类型属性，技能id）
	-- moralityLevel : 师德等级
	-- masterName : 师傅名称
	-- awakeSkillId : 觉醒之技子技能Id
	-- obtainNum : 获得排位印记数量
	-- cardMessage : 玩家卡牌信息
	-- bgId : 使用中的背景Id
	-- showMes : 标志->二进制第四位(0000)由低到高分别代表(翅膀、伴侣、宠物、孩子)0不显示，1显示
	-- coupleMes : 伴侣信息（空字符串没有伴侣）（faceId|headId|headcolour|bodyId|bodycolour|wingId|id|serverId|fighting|level|vipLevel）
	-- childMes : 孩子的数据json
	-- careBuffProp : 孩子关爱属性
	-- careToday : 是否关爱过
	-- thumbUpNum : 排位被点赞的次数
	-- badgeInfo : 成就徽章数据
	-- helpTime : 已帮助次数
	-- assistTime : 剩余赏金助战次数
	-- professionId : 玩家职业Id
	-- myMaxSegmentLevel : 玩家最高排位等级
	-- masterId : 玩家师傅Id(没有师傅=0)
	-- shapeBigSkillId : 皮肤大招Id
	-- awakeAssistTime : 觉醒副本助战次数
	-- ylJsonInfo : 娱乐竞技数据
	-- honourPoint : 荣誉值
	-- itemSuitStrongNum : 套装强化数量
	-- itemSuitStarNum : 套装升星数量
	-- shape : 皮肤
	-- shapeFetterProperties : 皮肤加成属性
	-- soulInfo : 元魂
	-- itemSuitStrongNum : 套装强化数量
	-- itemSuitStarNum : 套装升星数量
	-- wedBufLevel : buff等级
	-- wedBufTime : buff剩余时间
	-- loveSkill2 : 夫妻技能json字符串｛技能类型：技能id｝	同阵营
	-- vipMedal: 勋章
	-- phantomEquipment: 皮肤装备json
	-- pastureId: 牧场id
	-- spriteStoneFp: 坐骑灵石战力
	-- spriteStoneInfo: 灵石信息
	-- pupliInfo : 徒弟信息
	-- myMoralityLevel : 我的师德（师傅）
	-- footMarkCityIds : 足迹打卡的城市Id
	-- footMarkCityTimes : 打卡时间戳
	-- levelBreachId : 玩家突破等级Id
	-- useShapeGroupId : 使用中的皮肤组合ID【168+】 
	-- useShapeGroupAdvanceLevel : 使用中的皮肤组合进阶等级,用于单机玩法使用皮肤组合技能【0=无技能】【168+】 
	-- qqHallInfo : qq大厅玩家蓝钻信息
	-- runeResonateAdd : 符文共振加成
	-- cardSoulBuffAdd : 卡魂buff加成
	-- guildBaptismAdd : 公会洗礼
	-- chatShield : 聊天屏蔽陌生人
	-- zlsJsonInfo : 【177+】玩家战略赛数据信息，格式：{'level2V2':1,'score2V2':100,'joinNum2V2':200,'winNum2V2':100,'level3V3':1,'score3V3':100,'joinNum3V3':200,'winNum3V3':100}
	-- leagueInfo : 联盟数据信息json
	WZLog("ProtocolProcessorCache:parse_CACHE_PlayerInfo-1",
		"\n id =",Serialize(VectorToTable(id)),
		"\n name =",Serialize(VectorToTable(name)),
		"\n sex =",Serialize(VectorToTable(sex)),
		"\n title =",Serialize(VectorToTable(title)),
		"\n guildName =",Serialize(VectorToTable(guildName)),
		"\n position =",Serialize(VectorToTable(position)),
		"\n level =",Serialize(VectorToTable(level)),
		"\n exp =",Serialize(VectorToTable(exp)),
		"\n maxExp =",Serialize(VectorToTable(maxExp)),
		"\n vipLevel =",Serialize(VectorToTable(vipLevel)),
		"\n winNum =",Serialize(VectorToTable(winNum)),
		"\n playNum =",Serialize(VectorToTable(playNum)),
		"\n fighting =",Serialize(VectorToTable(fighting)),
		"\n mateName =",Serialize(VectorToTable(mateName)),
		"\n signature =",Serialize(VectorToTable(signature)),
		"\n vigor =",Serialize(VectorToTable(vigor)),
		"\n maxVigor =",Serialize(VectorToTable(maxVigor)),
		"\n guildId =",Serialize(VectorToTable(guildId)),
		"\n property =",Serialize(VectorToTable(property)),
		"\n strongSuitId =",Serialize(VectorToTable(strongSuitId)),
		"\n starSuitId =",Serialize(VectorToTable(starSuitId)),
		"\n mosaicSuitId =",Serialize(VectorToTable(mosaicSuitId)),
		"\n petMessage =",Serialize(VectorToTable(petMessage)),
		"\n mountsMessage =",Serialize(VectorToTable(mountsMessage)),
		"\n fashionProperty =",Serialize(VectorToTable(fashionProperty)),
		"\n fashionFighting =",Serialize(VectorToTable(fashionFighting)),
		"\n tournamentLevel =",Serialize(VectorToTable(tournamentLevel)),
		"\n tournamentIntegral =",Serialize(VectorToTable(tournamentIntegral)),
		"\n itemSuitId =",Serialize(VectorToTable(itemSuitId)),
		"\n itemSuitNum =",Serialize(VectorToTable(itemSuitNum)),
		"\n segmentLevel =",Serialize(VectorToTable(segmentLevel)),
		"\n totemLevel =",Serialize(VectorToTable(totemLevel)),
		"\n lovelLevel =",Serialize(VectorToTable(lovelLevel)),
		"\n loveSkill =",Serialize(VectorToTable(loveSkill)),
		"\n moralityLevel =",Serialize(VectorToTable(moralityLevel)),
		"\n masterName =",Serialize(VectorToTable(masterName)),
		"\n vipExp =",Serialize(VectorToTable(vipExp)),
		"\n segmentExp =",Serialize(VectorToTable(segmentExp)),
		"\n rankMatchMessage =",Serialize(VectorToTable(rankMatchMessage)),
		"\n guildLevel =",Serialize(VectorToTable(guildLevel)),
		"\n buyTimesPS =",Serialize(VectorToTable(buyTimesPS)),
		"\n headScul =",Serialize(VectorToTable(headScul)),
		"\n snsValue =",Serialize(VectorToTable(snsValue)),
		"\n starsoulId =",Serialize(VectorToTable(starsoulId)),
		"\n spaceSex =",Serialize(VectorToTable(spaceSex)),
		"\n giftNum =",Serialize(VectorToTable(giftNum)),
		"\n allMountsMessage =",Serialize(VectorToTable(allMountsMessage)),
		"\n marryFlag =",Serialize(VectorToTable(marryFlag)),
		"\n teamId =",Serialize(VectorToTable(teamId)),
		"\n prayInfo =",Serialize(VectorToTable(prayInfo)))

	WZLog("ProtocolProcessorCache:parse_CACHE_PlayerInfo-2",
		"\n xlId =",Serialize(VectorToTable(xlId)),
		"\n xlExp =",Serialize(VectorToTable(xlExp)),
		"\n shapeId =",Serialize(VectorToTable(shapeId)),
		"\n shapeLevel =",Serialize(VectorToTable(shapeLevel)),
		"\n showShape =",Serialize(VectorToTable(showShape)),
		"\n awakeSoulLevel =",Serialize(VectorToTable(awakeSoulLevel)),
		"\n awakeStep =",Serialize(VectorToTable(awakeStep)),
		"\n itemSuitId2 =",Serialize(VectorToTable(itemSuitId2)),
		"\n itemSuitNum2 =",Serialize(VectorToTable(itemSuitNum2)),
		"\n homeLevel =",Serialize(VectorToTable(homeLevel)),
		"\n sheerLuxury =",Serialize(VectorToTable(sheerLuxury)),
		"\n footMark =",Serialize(VectorToTable(footMark)),
		"\n shapeSkillId =",Serialize(VectorToTable(shapeSkillId)),
		"\n awakeSkillId =",Serialize(VectorToTable(awakeSkillId)),
		"\n runeItemId =",Serialize(VectorToTable(runeItemId)),
		"\n runeItemNum =",Serialize(VectorToTable(runeItemNum)),
		"\n obtainNum =",Serialize(VectorToTable(obtainNum)),
		"\n cardMessage =",Serialize(VectorToTable(cardMessage)),
		"\n bgId =",Serialize(VectorToTable(bgId)),
		"\n showMes =",Serialize(VectorToTable(showMes)),
		"\n coupleMes =",Serialize(VectorToTable(coupleMes)),
		"\n childMes =",Serialize(VectorToTable(childMes)),
		"\n careBuffProp =",Serialize(VectorToTable(careBuffProp)),
		"\n careToday =",Serialize(VectorToTable(careToday)),
		"\n headSculStatus =",Serialize(VectorToTable(headSculStatus)),
		"\n thumbUpNum =",Serialize(VectorToTable(thumbUpNum)),
		"\n badgeInfo =",Serialize(VectorToTable(badgeInfo)),
		"\n helpTime =",Serialize(VectorToTable(helpTime)),
		"\n assistTime =",Serialize(VectorToTable(assistTime)),
		"\n professionId =",Serialize(VectorToTable(professionId)),
		"\n myMaxSegmentLevel =",Serialize(VectorToTable(myMaxSegmentLevel)),
		"\n masterId =",Serialize(VectorToTable(masterId)),
		"\n shapeBigSkillId =",Serialize(VectorToTable(shapeBigSkillId)),
		"\n awakeAssistTime =",Serialize(VectorToTable(awakeAssistTime)),
		"\n ylJsonInfo =",Serialize(VectorToTable(ylJsonInfo)),
		"\n honourPoint =",Serialize(VectorToTable(honourPoint)),
		"\n itemSuitStrongNum =",Serialize(VectorToTable(itemSuitStrongNum)),
		"\n itemSuitStarNum =",Serialize(VectorToTable(itemSuitStarNum)),
		"\n shape =",Serialize(VectorToTable(shape)),
		"\n shapeFetterProperties =",Serialize(VectorToTable(shapeFetterProperties)),
		"\n soulInfo =",Serialize(VectorToTable(soulInfo)),
		"\n rpIds =",Serialize(VectorToTable(rpIds)),
		"\n wedBufLevel =",Serialize(VectorToTable(wedBufLevel)),
		"\n wedBufTime =",Serialize(VectorToTable(wedBufTime)),
		"\n loveSkill2 =",Serialize(VectorToTable(loveSkill2)),
		"\n professionAttr1 =",Serialize(VectorToTable(professionAttr1)),
		"\n professionAttr2 =",Serialize(VectorToTable(professionAttr2)),
		"\n vipMedal =",Serialize(VectorToTable(vipMedal)),
		"\n phantomEquipment =",Serialize(VectorToTable(phantomEquipment)),
		"\n chatShortcut =",Serialize(VectorToTable(chatShortcut)))

	WZLog("ProtocolProcessorCache:parse_CACHE_PlayerInfo-3",
		"\n pastureId =",Serialize(VectorToTable(pastureId)),
		"\n spriteStoneFp =",Serialize(VectorToTable(spriteStoneFp)),
		"\n spriteStoneInfo =",Serialize(VectorToTable(spriteStoneInfo)),
		"\n pupliInfo =",Serialize(VectorToTable(pupliInfo)),
		"\n myMoralityLevel =",Serialize(VectorToTable(myMoralityLevel)),
		"\n footMarkCityIds =",Serialize(VectorToTable(footMarkCityIds)),
		"\n footMarkCityTimes =",Serialize(VectorToTable(footMarkCityTimes)),
		"\n levelBreachId =",Serialize(VectorToTable(levelBreachId)),
		"\n useShapeGroupId =",Serialize(VectorToTable(useShapeGroupId)),
		"\n useShapeGroupAdvanceLevel =",Serialize(VectorToTable(useShapeGroupAdvanceLevel)))

	CacheCenter:setPlayerInfo(id, name, sex, title, guildName, position, level, exp, maxExp, vipLevel, winNum, playNum, fighting, mateName, signature, vigor, 
	maxVigor, guildId, property, strongSuitId, starSuitId, mosaicSuitId, petMessage, mountsMessage, fashionProperty, fashionFighting, tournamentLevel, 
	tournamentIntegral, itemSuitId, itemSuitNum, segmentLevel, totemLevel, lovelLevel, loveSkill, moralityLevel, masterName, vipExp, segmentExp, 
	rankMatchMessage, guildLevel, buyTimesPS, headScul, snsValue, starsoulId, spaceSex, giftNum, allMountsMessage, marryFlag, teamId, prayInfo, xlId, xlExp, 
	shapeId, shapeLevel, showShape, awakeSoulLevel, awakeStep, itemSuitId2, itemSuitNum2, homeLevel, sheerLuxury, footMark, shapeSkillId, awakeSkillId, 
	runeItemId, runeItemNum, obtainNum, cardMessage, bgId, showMes, coupleMes, childMes, careBuffProp, careToday, headSculStatus, thumbUpNum, badgeInfo, 
	helpTime, assistTime, professionId, myMaxSegmentLevel, masterId, shapeBigSkillId, awakeAssistTime, ylJsonInfo, honourPoint, itemSuitStrongNum,
	itemSuitStarNum, shape, shapeFetterProperties, soulInfo, rpIds, wedBufLevel, wedBufTime, loveSkill2, professionAttr1, professionAttr2,vipMedal,
	phantomEquipment, chatShortcut, pastureId, spriteStoneFp, spriteStoneInfo, pupliInfo, myMoralityLevel, footMarkCityIds, footMarkCityTimes, levelBreachId,
	useShapeGroupId, useShapeGroupAdvanceLevel, qqHallInfo, petEquip, runeResonateAdd, cardSoulBuffAdd, guildBaptismAdd, chatShield, zlsJsonInfo, praiseRewardStatus, leagueInfo)
end

--@brief	更新角色信息（CACHE_UpdatePlayer = 5）(S->C)
function ProtocolProcessorCache:parse_CACHE_UpdatePlayer(key, value)
	-- key : 字段
	-- value : 值
	WZLog("ProtocolProcessorCache:parse_CACHE_UpdatePlayer")
	CacheCenter:updatePlayerInfo(VectorToTable(key), VectorToTable(value))
end

--@brief	爱心许愿物品列表（CACHE_WishList = 11）
function ProtocolProcessorCache:parse_CACHE_WishList(id, num ,lotteryCount,lotteryReward)
	-- id : 物品序号
	-- num : 物品数量
	-- lotteryCount :抽奖次数
	-- lotteryReward :抽奖次数达到获得的物品
	WZLog("ProtocolProcessorCache:parse_CACHE_WishList",id:size(),num:size())
	
	CacheCenter:setLotteryItems(id,num,lotteryCount,lotteryReward)
end

--@brief	祝福礼盒物品列表（CACHE_ZflhList = 12）
function ProtocolProcessorCache:parse_CACHE_ZflhList(id, itemId, itemNum, state)
	-- id : 礼盒序号
	-- itemId : 物品ID 格式[865,866,867,868]
	-- itemNum : 物品数量 格式[1,2,2,5]
	-- state : 0不可领取，1可以领取，2已领取
	WZLog("ProtocolProcessorCache:parse_CACHE_ZflhList",id:size(),itemId:size(),itemNum:size())
	for i=0,id:size()-1 do
		WZLog(id:get(i),itemId:get(i),itemNum:get(i),state:get(i))
	end
	CacheCenter:setZflhList(id, itemId, itemNum, state)
end

--@brief	游戏参数（CACHE_GameParam = 16）
function ProtocolProcessorCache:parse_CACHE_GameParam(name, value)
	-- name : 参数名称（具体参数内容，找服务端给）OperationParam
	-- value : 参数值
	WZLog("ProtocolProcessorCache:parse_CACHE_GameParam")
	CacheCenter:setGameParam(VectorToTable(name), VectorToTable(value))
	if ProjConfig.LANGUAGE == "vn" then
		if CacheCenter:getGameParam() and CacheCenter:getGameParam().gameStatus and CacheCenter:getGameParam().gameStatus ~= "1" then
			--WZLog("ProtocolProcessorCache:parse_CACHE_GameParam", Serialize(CacheCenter:getGameParam()))
    		DSSdkManager:createBucket("wyd-vn-ddd2");
    	end
    end
end

--@brief	系统相关协议
function ProtocolProcessorCache:parse_SYSTEM_NextDay(time)
	-- time : 服务器时间（精确到秒）
	WZLog("ProtocolProcessorCache:parse_SYSTEM_NextDay")
	CacheCenter:setIsNewDayState( time )
end

--@brief	更新个人第三方信息成功（PLAYER_SaveFacebookOK = 4）
function ProtocolProcessorCache:parse_PLAYER_SaveFacebookOK(status)
	-- status : 处理结果 0:失败,1:成功
	WZLog("ProtocolProcessorCache:parse_PLAYER_SaveFacebookOK")
end

--@brief	更新祈福召唤次数结果（CACHE_UpdateDataOk = 17）
function ProtocolProcessorCache:parse_CACHE_UpdateDataOk(summonNum)
	-- summonNum : 今天召唤次数
	WZLog("ProtocolProcessorCache:parse_CACHE_UpdateDataOk")
	if WndBless then
		WndBless:resetSummonNum(summonNum)
	end
end

--@brief    公会战任务进度（CACHE_GuildWarTaskOk = 18）
function ProtocolProcessorCache:parse_CACHE_GuildWarTaskOk(typeId, num, taskId)
    -- typeId : 类型（1为参与公会战，2为参与公会战并胜利，3为公会战击杀数）
    -- num : 该类型完成数量
    -- taskId : 正在进行的任务Id
    WZLog("ProtocolProcessorCache:parse_CACHE_GuildWarTaskOk")
    CacheCenter:setGuildWarTargetData(VectorToTable(typeId), VectorToTable(num), VectorToTable(taskId))
end

--@brief	批量更新物品信息（CACHE_BatchUpdateItemCache = 19）
function ProtocolProcessorCache:parse_CACHE_BatchUpdateItemCache(playerItemId, value)
	-- playerItemId : PlayerItemVo中的voId,代表玩家物品的唯一标识
	-- value : key和值
	WZLog("ProtocolProcessorCache:parse_CACHE_BatchUpdateItemCache")
	CacheCenter:batchUpdatePlayerItems(VectorToTable(playerItemId), VectorToTable(value))
end

--@brief	公寓物品（WEDDING_GetHouseItemCacheOk = 88）
function ProtocolProcessorCache:parse_WEDDING_GetHouseItemCacheOk(playerItemId, itemId, lastNum, lastTime, isUse, ownerId, childId)
	-- itemId : 物品ID
	-- lastNum : 剩余数量，如果是-1，就是不限数量使用
	-- lastTime : 剩余的天数，如果是-1，就是不限时间使用
	-- isUse : 是否装备在身上
	-- ownerId : 所属玩家Id
	-- playerItemId : 玩家物品ID(唯一)
	-- childId : 所属Id使用的物品
	WZLog("ProtocolProcessorCache:parse_WEDDING_GetHouseItemCacheOk",itemId:size())
	-- for i=0,itemId:size()-1 do
	-- 	if GDatatab_item["id_"..itemId:get(i)] ~= nil then
	-- 		WZLog("parse_WEDDING_GetHouseItemCacheOk",GDatatab_item["id_"..itemId:get(i)].name,isUse:get(i))
	-- 	end
	-- end

	CacheCenter:setPlayerKidHomeItems(itemId, lastNum, lastTime, isUse, playerItemId, ownerId, childId)
end

--@brief	新增公寓物品（WEDDING_AddHouseItemCache = 89）
function ProtocolProcessorCache:parse_WEDDING_AddHouseItemCache(playerItemId, itemId, lastNum, lastTime, isUse, ownerId, childId)
	-- playerItemId : 玩家物品ID(唯一)
	-- itemId : 物品ID
	-- lastNum : 剩余数量，如果是-1，就是不限数量使用
	-- lastTime : 剩余的天数，如果是-1，就是不限时间使用
	-- isUse : 是否装备在身上
	-- ownerId : 所属玩家Id
	-- childId : 所属Id使用的物品
	WZLog("ProtocolProcessorCache:parse_WEDDING_AddHouseItemCache")
	CacheCenter:addPlayerHomeItem(itemId, lastNum, lastTime, isUse, playerItemId, ownerId, childId)

end

--@brief	移除公寓物品（WEDDING_RemoveHouseItemCache = 91）
function ProtocolProcessorCache:parse_WEDDING_RemoveHouseItemCache(playerItemId, itemId)
	-- playerItemId : 玩家物品ID,除了时装其它为0
	-- itemId : 道具id
	WZLog("ProtocolProcessorCache:parse_WEDDING_RemoveHouseItemCache",Serialize(VectorToTable(playerItemId)),Serialize(VectorToTable(itemId)))
	CacheCenter:removePlayerHomeItems(VectorToTable(playerItemId), VectorToTable(itemId))
end

--@brief	更新公寓物品（WEDDING_UpdateHouseItemCache = 90）
function ProtocolProcessorCache:parse_WEDDING_UpdateHouseItemCache(playerItemId, itemId, key, value)
	-- PlayerItemId : 玩家物品ID,除了时装其它为0
	-- itemId : 物品Id
	-- key : 字段
	-- value : 值
	WZLog("ProtocolProcessorCache:parse_WEDDING_UpdateHouseItemCache")
	CacheCenter:updatePlayerHomeItems(playerItemId, itemId, VectorToTable(key), VectorToTable(value))
end

--@brief	玩家附属数据缓存（CACHE_PlayerExtInfoCache = 23）
function ProtocolProcessorCache:parse_CACHE_PlayerExtInfoCache(advanceEnchantingIds, advanceEnchantingWingIds)
	-- advanceEnchantingIds : 玩家已进阶了的时装套装Id集合
	WZLog("ProtocolProcessorCache:parse_CACHE_PlayerExtInfoCache")

	CacheCenter:setDressAdvanceId(VectorToTable(advanceEnchantingIds))
	CacheCenter:setWingAdvanceId(VectorToTable(advanceEnchantingWingIds))
end
-------------------------------------协议错误处理方法模块--------------------------------------
--@brief	保存个人第三方信息（PLAYER_SaveFacebook = 3）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorCache:send_PLAYER_SaveFacebook_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorCache:send_PLAYER_SaveFacebook_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_SaveFacebook, nflag, sMessage)
end

-------------------------------------公有方法模块End----------------------------------------







