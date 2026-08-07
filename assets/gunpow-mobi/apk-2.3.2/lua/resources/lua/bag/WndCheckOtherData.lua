--WndCheckOtherData.lua
--@brief	WndCheckOther的数据模块
--@date		2015/07/06
--@author	zsq
--@note		查看其它玩家信息

WndCheckOther = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCheckOther:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nLoadingId = nil
	self.m_tSpaceCell = nil
	self.conPlayer = nil
	self.m_tMount = nil
	self.m_tFootMark = nil
	self.m_nChecFromMsg = nil
	self.m_nActionType = nil 		--0:添加黑名单;1:删除黑名单
	self.m_tBgList = nil 			--背景数据列表
	self.m_tCellClickBg = nil 		--当前选中的背景cell
	self.m_nShowBgId = nil 			--展示的背景Id
	self.m_tClickBgData = nil 		--点击的背景的数据
	self.m_nOperateType = nil 		--操作类型:0->使用背景;1->设置翅膀;2->设置伴侣;3->设置宠物;4->设置孩子;5->设置坐骑;6->设置皮肤;
	self.conMatePlayer = nil 		--伴侣
	self.conPlayerPet = nil 		--宠物
	self.m_tCellLastClickBg = nil   --上次点中的bg
	self.m_nUploadType = nil
	self.m_tUploadCell = nil
	self.m_topCellLua = nil 
	self.m_tData = nil 
	self.m_nProfit = nil
	self.m_nFlowerNum = nil
	self.m_tDownloadFileList = nil		--待下载的文件列表
	self.m_tMessageData = nil 
	self.m_nMessageIndex = 1 
	self.m_tFootTitleData = nil 		--踩一踩羁绊数据
	self.m_tFlowerTitleData = nil 		--送鲜花羁绊数据
	self.m_tSpacePhotoData = nil 		--玩家空间照片数据
	self.m_nHavePhotoNum = nil 			--已经上传的照片数量
	self.m_tSpaceDynamicData = nil 		--玩家最新心情数据
	self.m_rolePlayer = nil
	self.m_tSkin = nil 					--皮肤
	self.m_tCellLastUsingBg = nil 	--正在使用的BG
	self.m_bIsLoadCell = false 
	self.m_tFriendsTitleData = nil 		--好友度前三数据
	self.m_tGuildInfo = nil 		--玩家公会会长数据
	self.m_nTabIndex = 1 			--1:背景；2：头像框；3：信息框
	self.m_bGetInfoData = false 	--是否已经收到玩家信息数据

	self.m_bOtherPlayerExpand = nil 		--其他玩家是否展开展示栏

	self.m_tMountPlayerId = nil 			--收到坐骑数据对应的玩家id
	self.m_tFootMarkPlayerId = nil 			--收到足迹数据对应的玩家id
	self.m_nBgCheckNum = 7  				--背景界面可设置的复选框的数量
	self.m_tSkinPlayerId = nil 				--收到皮肤数据对应的玩家id
	self.m_nItemIdPlayerId = nil 			--收到物品id的玩家Id
	self.m_tReceiveItemId = nil 
	self.m_tReceiveIsUse = nil 
	self.m_tReceiveExInfo = nil 
	self.m_tReceiveExInfoTemp = nil 		--临时
	self.m_tPlayerItemData = nil  			--玩家装备数据
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCheckOther:_unInit()
	self.m_root = nil
	self.m_nLoadingId = nil
	--self.m_nPlayerId = nil
	self.m_tPlayerInfo = nil
	self.m_tSpaceCell = nil
	self.conPlayer = nil
	self.m_tMount = nil
	self.m_tFootMark = nil
	self.m_nChecFromMsg = nil
	self.m_nActionType = nil 
	self.m_tBgList = nil 
	self.m_tCellClickBg = nil
	self.m_nShowBgId = nil 			--展示的背景Id
	self.m_tClickBgData = nil 		--点击的背景的数据
	self.m_nOperateType = nil 		--操作类型
	self.conMatePlayer = nil 		--伴侣
	self.conPlayerPet = nil
	self.m_tCellLastClickBg = nil   --上次点中的bg
	self.m_nUploadType = nil
	self.m_tUploadCell = nil
	self.m_topCellLua = nil 
	self.m_tData = nil 
	self.m_nProfit = nil
	self.m_nFlowerNum = nil
	self.m_tDownloadFileList = nil		--待下载的文件列表
	self.m_tMessageData = nil 
	self.m_nMessageIndex = nil 
	self.m_tFootTitleData = nil 		--踩一踩羁绊数据
	self.m_tFlowerTitleData = nil 		--送鲜花羁绊数据
	self.m_tSpacePhotoData = nil
	self.m_nHavePhotoNum = nil 
	self.m_tSpaceDynamicData = nil
	self.m_rolePlayer = nil
	self.m_tSkin = nil
	self.m_tCellLastUsingBg = nil 
	self.m_bIsLoadCell = nil 
	self.m_tFriendsTitleData = nil
	self.m_tGuildInfo = nil
	self.m_bIsHost = nil 
	self.m_nStartIndex = nil 
	self.m_tFashionSoul = nil 
	self.m_tRuneInfo = nil 
	self.m_tStone = nil 
	self.m_nUseType = nil 
	self.m_nTabIndex = nil 
	self.m_bGetInfoData = nil

	self.m_bOtherPlayerExpand = nil

	self.m_tMountPlayerId = nil
	self.m_tFootMarkPlayerId = nil
	self.m_nBgCheckNum = nil 
	self.m_tSkinPlayerId = nil 	
	self.m_nItemIdPlayerId = nil 			--收到物品id的玩家Id
	self.m_tReceiveItemId = nil 
	self.m_tReceiveIsUse = nil 
	self.m_tReceiveExInfo = nil 
	self.m_tReceiveExInfoTemp = nil 		--临时
	self.m_tPlayerItemData = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCheckOther:createElement()
    if self.m_root then
        WindowManager:removeWindow(self.m_root,WndCheckOther)
    end
	
	local element = WZUISystem:getInstance():createElement("WndCheckOther")
	assert(element, "WndCheckOther create element failed!")
	self:_init()
	return element
end

--@brief	设置是否屏蔽私聊	
function WndCheckOther:setChat()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tPlayerInfo == nil then return end

	if self.m_tPlayerInfo.chum == 1 then
		MsgBoxManager:showTipBox(LocalStrings.BLACKLIST_TEXT9)
		return 
	end

	if self.m_tPlayerInfo.mateName == CacheCenter:getPlayerInfo().name then
		MsgBoxManager:showTipBox(LocalStrings.BLACKLIST_TEXT11)
		return 
	end

	local tMasterName = json.decode(CacheCenter:getPlayerInfo().masterName)
	for i, name in pairs(tMasterName) do
		if self.m_tPlayerInfo.name == name then
			MsgBoxManager:showTipBox(LocalStrings.BLACKLIST_TEXT10)
			return 
		end
	end

	self.m_nActionType = 0 
	BANCHAT = CacheCenter:getFriendBlacklist()
	for i = 1, #BANCHAT do
		if BANCHAT[i].id == self.m_nPlayerId then
			self.m_nActionType = 1
			break 
		end
	end

	if self.m_nActionType == 0 then
		local nMaxBlacklistNum = tonumber(CacheCenter:getGameParam().maxBlackListNum)
		if nMaxBlacklistNum and #BANCHAT >= nMaxBlacklistNum then
			MsgBoxManager:showTipBox(LocalStrings.BLACKLIST_TEXT14)
			return 
		end
		if self.m_tPlayerInfo.isFriend == false then
			MsgBoxManager:showConfirmBox(LocalStrings.BLACKLIST_TEXT2, self, self.sureToAddBlacklist)
		else
			MsgBoxManager:showConfirmBox(LocalStrings.BLACKLIST_TEXT3, self, self.sureToAddBlacklist)
		end
		return 
	end

	ProtocolProcessorWndFriends:send_FRIENT_BlackListOperate(self.m_nActionType, self.m_tPlayerInfo.id)
end

--@brief 	继续添加黑名单
function WndCheckOther:sureToAddBlacklist()
	-- body
	ProtocolProcessorWndFriends:send_FRIENT_BlackListOperate(self.m_nActionType, self.m_tPlayerInfo.id)
end

--@brief 	添加或移除黑名单成功
function WndCheckOther:operateBlacklistOK(actionType, playerId)
	--body
	if self.m_root == nil then return end 
	if self.m_tPlayerInfo == nil then return end 
	if self.m_tPlayerInfo.id ~= playerId then return end 

	if actionType == 0 then
		self.m_tPlayerInfo.isFriend = false
		if self.m_tPlayerInfo.isFriend == false then
	    	GetElement(self.m_root, "ttfBtn1_WndCheckOther", WZUILabelTTF):setText(LocalStrings.BAGBTNTEXT3)
	    	GetElement(self.m_root, "Btn1_WndCheckOther", WZUIButton):setVisible(true)
		else
	    	GetElement(self.m_root, "ttfBtn1_WndCheckOther", WZUILabelTTF):setText(LocalStrings.BAGBTNTEXT5)
	    	GetElement(self.m_root, "Btn1_WndCheckOther", WZUIButton):setVisible(true)
		end

		GetElement(self.m_root, "txtBlacklist_WndCheckOther", WZUILabelTTF):setText(LocalStrings.BLACKLIST_TEXT7)
	else
		GetElement(self.m_root, "txtBlacklist_WndCheckOther", WZUILabelTTF):setText(LocalStrings.BLACKLIST_TEXT8)
	end
end

--@brief	保存数据
function WndCheckOther:setData(playerId , playerName, playerSex, playerLevel, title, headScul, guildName, position, mateName, birthday, playerAge, 
	playerCon, distance, voiceInfo, giftNum, popularity, charmNum, giftPrice, visitorsInfos, locSeting, pahSeting, msgSeting, todayGFNum, beGFLower, 
	serverId, flowersInfo, joinInfo, friendsTop3Info, guildInfo, cityCode, advanceEnchantingIds, advanceEnchantingWingIds)
	local bFirstIn = false 
	if self.m_tData == nil then 
		bFirstIn = true 
	end
	self.m_tData = {}
	self.m_tData.playerId = playerId
	self.m_tData.playerName = playerName
	self.m_tData.playerSex = playerSex
	self.m_tData.playerLevel = playerLevel
	self.m_tData.title = title
	self.m_tData.headScul = headScul
	self.m_tData.guildName = guildName
	self.m_tData.position = position
	self.m_tData.mateName = mateName
	self.m_tData.birthday = birthday
	self.m_tData.playerAge = playerAge
	self.m_tData.playerCon = playerCon
	self.m_tData.distance = distance
	self.m_tData.voiceInfo = voiceInfo
	self.m_tData.giftNum = giftNum
	self.m_tData.popularity = popularity
	self.m_tData.charmNum = charmNum
	self.m_tData.giftPrice = giftPrice
	self.m_tData.visitorsInfos = VectorToTable(visitorsInfos)
	self.m_tData.locSeting = locSeting
	self.m_tData.pahSeting = pahSeting
	self.m_tData.msgSeting = msgSeting
	self.m_tData.todayGFNum = todayGFNum
	self.m_tData.beGFLower = beGFLower
	self.m_tData.serverId = serverId
	self.m_tData.cityCode = cityCode
	self.m_tData.havedAdvanceDressIds = advanceEnchantingIds
	self.m_tData.havedAdvanceWingIds = advanceEnchantingWingIds

	WZLog("WndCheckOther:setData", Serialize(flowersInfo), Serialize(joinInfo), Serialize(friendsTop3Info))
	if guildInfo and guildInfo ~= "" then 
		self.m_tGuildInfo = json.decode(guildInfo)
	end

	self:setFootAndFlowerFetterData(flowersInfo, joinInfo, friendsTop3Info)
	self:updateSpaceInfo()

	if bFirstIn then 
		if self.m_tSpaceCell then 
			self.m_tSpaceCell:_showCityAndAge()
			self.m_tSpaceCell:showBirthdayAndCity()
		end
	end
end

--@brief	保存留言数据
function WndCheckOther:setMessageData(messages)
	self.m_tMessageData = {}
	self.m_tMessageData.messages = messages

	if self.m_tPlayerInfo then 
		self:showMessageList()
	end
end

--@brief 	玩家照片数据
function WndCheckOther:setSpacePhotoData(photoUrl, photoStatus)
	--body
	local tData = {}
	local nPhotoNum = 0
	for i = 1, #photoUrl do
		local tItem = {}

		tItem.index = i 
		tItem.photoUrl = photoUrl[i]
		tItem.photoStatus = photoStatus[i]

		table.insert(tData, tItem)
		if photoStatus[i] == 4 then 
			nPhotoNum = nPhotoNum + 1
		end
	end

	self.m_tSpacePhotoData = tData
	table.sort(self.m_tSpacePhotoData, function (a, b)
		-- body
		if a.photoStatus ~= b.photoStatus then
			return a.photoStatus > b.photoStatus
		else
			return a.index < b.index
		end
	end)
	self.m_nHavePhotoNum = nPhotoNum
end

--@brief 	设置玩家心情数据
function WndCheckOther:setSpaceDynamicData(cId, message, spacePhoto, likeTotal, commentTotal, time, verify, giveGoodMark, commentState)
	-- body
	self.m_tSpaceDynamicData = {}

	self.m_tSpaceDynamicData.circleId = cId
	self.m_tSpaceDynamicData.message = message
	self.m_tSpaceDynamicData.photoUrl = spacePhoto
	self.m_tSpaceDynamicData.goodNum = likeTotal
	self.m_tSpaceDynamicData.commentNum = commentTotal
	self.m_tSpaceDynamicData.time = time
	self.m_tSpaceDynamicData.verify = verify
	self.m_tSpaceDynamicData.giveGoodMark = giveGoodMark
	self.m_tSpaceDynamicData.commentState = commentState
	WZLog("WndCheckOther:setSpaceDynamicData", Serialize(self.m_tSpaceDynamicData))
	self:updateInfo()
end

--@brief 	评论回复成功回调
function WndCheckOther:commentCircleOK(cId, commentId, commentMse, cPlayerId, cPlayerName, bCommentId, bPlayerId, bPlayerName)
	-- body
	if self.m_root == nil then return end 

	if cId == -1 then 
		MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT24)
		return 
	elseif cId == -2 then 
		MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT25)
		return
	end

	MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT34)
	WndSpaceDynamic:commentCircleOK(cId)
end

--@brief 	点赞成功回调
function WndCheckOther:giveGoodOK(cId, likeTotal, hasLike, likeName)
	-- body
	if self.m_root == nil then return end 

	MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT33)
	WndSpaceDynamic:giveGoodOK(cId, likeTotal, hasLike, likeName)
end

--@brief 	1删除心情  2.取消点赞  3.删除评论  4.举报 5.设置心情 6.发布成功  相应处理
function WndCheckOther:dealWithResultByType(oType, cId, param)
	-- body
	if self.m_root == nil then return end 
	WZLog("WndCheckOther:dealWithResultByType", oType)
	if oType == 1 then 
		MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT18)
		WndSpaceDynamic:deleteCircleOK(oType, cId, param)
	elseif oType == 2 then 
		MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT21)
		WndSpaceDynamic:cancelGiveGoodOK(oType, cId, param)
	elseif oType == 3 then 
		MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT19)
		WndSpaceDynamic:deleteCommentOK(oType, cId, param)
	elseif oType == 4 then 
		
	elseif oType == 5 then 
		MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT20)
		WndSpaceDynamic:setCommentStateOK(oType, cId, param)
	elseif oType == 6 then 
		
	end
end

--@brief 	获取玩家的性别
function WndCheckOther:getPlayerSex()
	-- body
	return self.m_tPlayerInfo.sex
end

--@brief 	获取是否已经被送过鲜花
function WndCheckOther:getIsBeGiveFlower()
	return self.m_tData.beGFLower
end

--@brief	缓存推送更新物品时调用的函数
function WndCheckOther:updatePlayerItemData()
	WZLog("WndCheckOther:updatePlayerItemData")
	if self.m_root ~= nil then
		local conForBg = GetElement(self.m_root, "conForBg_WndCHeckOther", WZUIContainer)
		if conForBg:isVisible() and self.m_nPlayerId == CacheCenter:getPlayerInfo().id then
			if self.m_nTabIndex == 2 or self.m_nTabIndex == 3 then 
				self.m_tPlayerInfo.infoBarItemId = CacheCenter:getPlayerInfoRectEffectItemId()
				self.m_tPlayerInfo.headEffectId = CacheCenter:getPlayerHeadEffectItemId()
				self.m_tSpaceCell:showInfoRectEffect()
				self:showFrame()
			end
		end
	end
end

--@brief 	接受坐骑和足迹数据
function WndCheckOther:setMountsAndFootsData(playerId, dataType, jsonData)
	if playerId == CacheCenter:getPlayerInfo().id then return end 

	if self.m_tPlayerInfo == nil then self.m_tPlayerInfo = {} end
	local tempDataType = math.floor(dataType/10000)
	if dataType == 1 then 
		self.m_tPlayerInfo.mountsMessage = jsonData
		self.m_tMount = self.m_tPlayerInfo.mountsMessage
		self.m_tMountPlayerId = playerId
	elseif dataType == 2 then 
		self.m_tPlayerInfo.footMark = jsonData
		self.m_tFootMark = self.m_tPlayerInfo.footMark
		self.m_tFootMarkPlayerId = playerId
	elseif dataType == 3 then 
		self.m_tPlayerInfo.shape = jsonData
		self.m_tSkin = self.m_tPlayerInfo.shape
		self.m_tSkinPlayerId = playerId
	elseif dataType == 4 then --itemId 4/5/6三个要都收到了，才去处理
		self.m_tReceiveItemId = jsonData
	elseif dataType == 5 then --isUse
		self.m_tReceiveIsUse = jsonData
	elseif tempDataType == 6 then --extraInfo
		local nTotalNum = math.floor((dataType-60000)/100)
		local nCurIndex = math.fmod(dataType, 100)
		WZLog("WndCheckOther:setMountsAndFootsData", dataType, nTotalNum, nCurIndex)
		if self.m_tReceiveExInfoTemp == nil then self.m_tReceiveExInfoTemp = {} end 
		self.m_tReceiveExInfoTemp[nCurIndex] = jsonData
		local nLength = GetTableLen(self.m_tReceiveExInfoTemp)
		WZLog("WndCheckOther:setMountsAndFootsData_0", nTotalNum, nLength)
		if nTotalNum ~= nLength then 
			return 
		end

		if self.m_tReceiveExInfo == nil then self.m_tReceiveExInfo = {} end 
		for j = 1, #self.m_tReceiveExInfoTemp do 
			local jsonDataTemp = self.m_tReceiveExInfoTemp[j]
			for i = 1, #jsonDataTemp do
				table.insert(self.m_tReceiveExInfo, jsonDataTemp[i])
			end
		end
	end
	if self.m_tReceiveItemId and self.m_tReceiveIsUse and self.m_tReceiveExInfo then  
		self.m_tPlayerInfo.item = {}
		for i = 1, #self.m_tReceiveItemId do
			local temp = {}
			temp.id = tonumber(self.m_tReceiveItemId[i])
			temp.basicInfo = GDatatab_item["id_"..self.m_tReceiveItemId[i]]
			temp.extraInfo = json.decode(self.m_tReceiveExInfo[i])
			temp.maintype = temp.basicInfo.main_type
			temp.subtype = temp.basicInfo.sub_type
			if tonumber(self.m_tReceiveIsUse[i]) == 1 then
				temp.isUse = true
			else
				temp.isUse = false
			end
			temp.extraInfo.fighting = caculateClothesFighting(temp.extraInfo)
			table.insert(self.m_tPlayerInfo.item,temp)
		end
		self.m_nItemIdPlayerId = playerId
		self.m_tPlayerItemData = CopyTable(self.m_tPlayerInfo.item)
	end 

	--右侧信息列表
	self:updateInfo()
end

--@brief 	心情置顶设置后，刷新为最新设置的置顶心情
function WndCheckOther:updateMyCircleOfFriend(tCircleData)
	if self.m_root == nil then return end 
	self.m_tSpaceDynamicData = {}

	self.m_tSpaceDynamicData.circleId = tCircleData.id
	self.m_tSpaceDynamicData.message = tCircleData.message
	self.m_tSpaceDynamicData.photoUrl = tCircleData.photoUrl
	self.m_tSpaceDynamicData.goodNum = tCircleData.goodNum
	self.m_tSpaceDynamicData.commentNum = tCircleData.commentNum
	self.m_tSpaceDynamicData.time = tCircleData.createTime
	self.m_tSpaceDynamicData.verify = tCircleData.picStatus
	self.m_tSpaceDynamicData.giveGoodMark = tCircleData.hasLike
	self.m_tSpaceDynamicData.commentState = tCircleData.commentState
	if WndSpaceDynamic.m_root then 
		WndSpaceDynamic:setData(self.m_tSpaceDynamicData)
	end
end

--@brief 	获取玩家已进阶的时装套装Id
function  WndCheckOther:getDressAdvanceId()
	-- body
	if self.m_tData == nil then return {} end 

	return self.m_tData.havedAdvanceDressIds or {}
end

--@brief 	获取玩家已进阶的翅膀Id
function  WndCheckOther:getWingAdvanceId()
	-- body
	if self.m_tData == nil then return {} end 

	return self.m_tData.havedAdvanceWingIds or {}
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	设置背包玩家缓存信息
function WndCheckOther:setPlayerInfo(id, name, sex, title, guildName, position, level, vipLevel, winNum, playNum, fighting, mateName, signature, isFriend, 
	itemId, extranInfo, property, strongSuitId, starSuitId, mosaicSuitId, petMessage, mountsMessage, tournamentLevel, segmentId, totemLevel, loveLevel, 
	loveSkill, moralityLevel, masterName, itemSuitId, itemSuitNum, snsValue, rankMatchMessage, starsoulId, guildLevel, spaceSex, giftNum, distance, 
	headScul, mentoring, couple, useMountsMessage, tournamentIntegral, marryFlag, serverId, prayInfo, xlId, xlExp, headColor, bodyColor, isUse, chum, 
	shapeId, shapeLevel, showShape, awakeSoulLevel, awakeStep, itemSuitId2, itemSuitNum2, homeLevel, sheerLuxury, footMark, shapeSkillId, awakeSkillId, 
	runeItemId, runeItemNum, obtainNum, cardMessage, bgId, showMes, coupleMes, childMes, careBuffProp, careToday, thumbUpNum, badgeInfo, professionId, 
	myMaxSegmentLevel, masterId, remarkName, ylJsonInfo, honourPoint, shape, shapeFetterProperties, soulInfo, rpIds, wedBufLevel, wedBufTime, loveSkill2, 
	professionAttr1, professionAttr2, vipMedal, phantomEquipment, pastureId, spriteStoneFp, spriteStoneInfo, friendliness, infoBarItemId,pupliInfo, 
	myMoralityLevel, headEffectId, footMarkCityIds, footMarkCityTimes, medalInfo, blueVipInfo, petEquip, runeResonateAdd, cardSoulBuffAdd, guildBaptismAdd, zlsJsonInfo)
	if id == CacheCenter:getPlayerInfo().id and self.m_tPlayerInfo ~= nil then 
		return
	end
	self.m_root:setVisible(true)
	--self:closeLoading()
	-- if self.m_tPlayerInfo == nil then 
		self.m_tPlayerInfo = {}
	-- end
	self.m_tPlayerInfo.id = id --Id
	self.m_tPlayerInfo.name = name  --名称
	self.m_tPlayerInfo.sex = sex  --性别
	self.m_tPlayerInfo.title = title --称号
	self.m_tPlayerInfo.guildName = guildName  --公会名称
	self.m_tPlayerInfo.position = position  --公会职务
	self.m_tPlayerInfo.level = GlobalGame:checkGlobalPlayerLevel(level)  --等级
	self.m_tPlayerInfo.vipLevel = vipLevel   --vip等级0表示非VIP
	self.m_tPlayerInfo.winNum = winNum  --胜利次数
	self.m_tPlayerInfo.playNum = playNum  --游戏次数
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

	self.m_tPlayerInfo.mateName = mateName  --伴侣名称
	self.m_tPlayerInfo.signature = signature  --个性签名
	self.m_tPlayerInfo.isFriend = isFriend
	self.m_tPlayerInfo.property = property  --属性字符串
	self.m_tPlayerInfo.strongSuitId = strongSuitId  --强化套装id
	self.m_tPlayerInfo.starSuitId = starSuitId  --升星套装id
	self.m_tPlayerInfo.mosaicSuitId = mosaicSuitId  --镶嵌套装id
	self.m_tPlayerInfo.petMessage = petMessage  --宠物信息
--	self.m_tPlayerInfo.mountsMessage = VectorToTable(mountsMessage)  --坐骑信息 --数据太大，已另用协议发送
	self.m_tPlayerInfo.tournamentLevel = tournamentLevel  --竞技等级
	self.m_tPlayerInfo.segmentId = segmentId 
	self.m_tPlayerInfo.totemLevel = totemLevel
	self.m_tPlayerInfo.loveLevel = loveLevel 
	self.m_tPlayerInfo.loveSkill = loveSkill
	self.m_tPlayerInfo.moralityLevel = moralityLevel
	self.m_tPlayerInfo.masterName = masterName
	self.m_tPlayerInfo.itemSuitId = itemSuitId
	self.m_tPlayerInfo.itemSuitNum = itemSuitNum
	self.m_tPlayerInfo.snsValue = snsValue
	self.m_tPlayerInfo.rankMatchMessage = rankMatchMessage
	self.m_tPlayerInfo.starsoulId = VectorToTable(starsoulId)
	self.m_tPlayerInfo.guildLevel = guildLevel
	self.m_tPlayerInfo.spaceSex = spaceSex
	self.m_tPlayerInfo.giftNum = giftNum
	self.m_tPlayerInfo.distance = distance
	self.m_tPlayerInfo.headScul = headScul
	self.m_tPlayerInfo.mentoring = mentoring
	self.m_tPlayerInfo.couple = couple
	self.m_tPlayerInfo.useMountsMessage = useMountsMessage
	self.m_tPlayerInfo.tournamentIntegral = tournamentIntegral
	self.m_tPlayerInfo.marryFlag = marryFlag or 0
	self.m_tPlayerInfo.serverId = serverId
	self.m_tPlayerInfo.prayInfo = prayInfo
	self.m_tPlayerInfo.xlId = VectorToTable(xlId)
	self.m_tPlayerInfo.xlExp = VectorToTable(xlExp)
	self.m_tPlayerInfo.serverName = CacheCenter:getServerNameByServerId(serverId)
	self.m_tPlayerInfo.headColor = headColor
	self.m_tPlayerInfo.bodyColor = bodyColor
	self.m_tPlayerInfo.isUse = isUse
	self.m_tPlayerInfo.chum = chum
	self.m_tPlayerInfo.shapeId = shapeId
	self.m_tPlayerInfo.shapeLevel = shapeLevel
	self.m_tPlayerInfo.showShape = showShape
	self.m_tPlayerInfo.awakeSoulLevel = awakeSoulLevel
	self.m_tPlayerInfo.awakeStep = awakeStep
	self.m_tPlayerInfo.itemSuitId2 = itemSuitId2
	self.m_tPlayerInfo.itemSuitNum2 = itemSuitNum2
	self.m_tPlayerInfo.homeLevel = homeLevel
	self.m_tPlayerInfo.sheerLuxury = sheerLuxury
--	self.m_tPlayerInfo.footMark = VectorToTable(footMark) --数据太大，已另用协议发送
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
	self.m_tPlayerInfo.thumbUpNum = thumbUpNum
	self.m_tPlayerInfo.badgeInfo = badgeInfo
	self.m_tPlayerInfo.professionId = professionId
	self.m_tPlayerInfo.myMaxSegmentLevel = myMaxSegmentLevel
	self.m_tPlayerInfo.masterId = masterId
	self.m_tPlayerInfo.remarkName = remarkName
	self.m_tPlayerInfo.ylJsonInfo = ylJsonInfo
	self.m_tPlayerInfo.honourPoint = honourPoint
	self.m_tPlayerInfo.wedBufLevel = wedBufLevel
	self.m_tPlayerInfo.wedBufTime = wedBufTime
--	self.m_tPlayerInfo.shape = VectorToTable(shape) -- 拥有皮肤id   --数据太大，已另用协议发送
	self.m_tPlayerInfo.shapeFetterProperties = shapeFetterProperties -- 皮肤加成属性
	self.m_tPlayerInfo.soulInfoJson = soulInfo
	self.m_tPlayerInfo.soulInfo = soulInfo -- 装备的元魂
	self.m_tPlayerInfo.rpIds = VectorToTable(rpIds)
	self.m_tPlayerInfo.professionAttr1 = professionAttr1
	self.m_tPlayerInfo.professionAttr2 = professionAttr2
	self.m_tPlayerInfo.vipMedal = vipMedal --VIP勋章
	self.m_tPlayerInfo.phantomEquipment = phantomEquipment
	self.m_tPlayerInfo.pastureId = pastureId
	self.m_tPlayerInfo.spriteStoneFp = spriteStoneFp
	self.m_tPlayerInfo.spriteStoneInfo = VectorToTable(spriteStoneInfo)
	self.m_tPlayerInfo.friendliness = friendliness
	self.m_tPlayerInfo.infoBarItemId = infoBarItemId
	self.m_tPlayerInfo.pupliInfo = pupliInfo
	self.m_tPlayerInfo.myMoralityLevel = myMoralityLevel
	self.m_tPlayerInfo.headEffectId = headEffectId
	self.m_tPlayerInfo.footMarkCityIds = VectorToTable(footMarkCityIds)
	self.m_tPlayerInfo.footMarkCityTimes = VectorToTable(footMarkCityTimes)
	self.m_tPlayerInfo.medalInfo = medalInfo
	self.m_tPlayerInfo.blueVipInfo = blueVipInfo or ""
	self.m_tPlayerInfo.petEquip = VectorToTable(petEquip)

	self.m_tPlayerInfo.runeResonateAdd = runeResonateAdd
	self.m_tPlayerInfo.cardSoulBuffAdd = cardSoulBuffAdd
	self.m_tPlayerInfo.guildBaptismAdd = guildBaptismAdd

	self.m_tPlayerInfo.zlsJsonInfo = zlsJsonInfo or ""

	if self.m_tPlayerInfo.coupleMes and self.m_tPlayerInfo.coupleMes ~= "" then 
		local tIdList = SplitStringWithSeparator(self.m_tPlayerInfo.coupleMes, "|", nil, true)
		if tIdList and tIdList[8] then 
			self.m_tPlayerInfo.mateServerId = tIdList[8]
		end
	end
	WZLog("WndCheckOther:setPlayerInfo 111", self.m_tPlayerInfo.background, Serialize(json.decode(medalInfo)))
	WZLog("WndCheckOther:setPlayerInfo", cardMessage, childMes, coupleMes, mateName, ylJsonInfo)

	if self.m_tPlayerInfo.soulInfoJson ~= "" then 
		local tempSoulInfo = json.decode(self.m_tPlayerInfo.soulInfoJson)
		self.m_tPlayerInfo.soulInfo = tempSoulInfo.sulInfo
	end

    if self.m_tPlayerInfo.useMountsMessage ~= "" then
        self.m_tPlayerInfo.mountsInfo = json.decode(self.m_tPlayerInfo.useMountsMessage)
        self.m_tPlayerInfo.mountsId = GDatatab_item["id_"..GDatatab_mounts["id_"..self.m_tPlayerInfo.mountsInfo.mountsId].item_id].animation_index_code
        self.m_tPlayerInfo.mountsType = GDatatab_item["id_"..GDatatab_mounts["id_"..self.m_tPlayerInfo.mountsInfo.mountsId].item_id].sub_type
    end

    if self.m_tPlayerInfo.petMessage ~= "" then
        self.m_tPlayerInfo.petInfo = json.decode(self.m_tPlayerInfo.petMessage)
    end

    if medalInfo and medalInfo ~= "" then 
    	self.m_tPlayerInfo.medalInfo = json.decode(medalInfo)
    end
    if blueVipInfo and blueVipInfo ~= "" then 
    	self.m_tPlayerInfo.qqHallData = json.decode(blueVipInfo)
    end

	--WZLog("玩家信息",shapeId,shapeLevel,showShape)
	if self.m_tPlayerInfo.tournamentLevel == nil or self.m_tPlayerInfo.tournamentLevel <= 0 then self.m_tPlayerInfo.tournamentLevel = 1 end

	local tProperty = json.decode(property)
	for k,v in pairs(tProperty) do
		self.m_tPlayerInfo[ATTR_PARAM_NAME[tonumber(k)]] = v
	end

	if self.m_tPlayerInfo.signature == "" then
		self.m_tPlayerInfo.signature = LocalStrings.NONE
	end

	--查看自己
	if self.m_nPlayerId == CacheCenter:getPlayerInfo().id then
		self.m_tPlayerInfo.sex = CacheCenter:getPlayerInfo().sex
	end
	
    if self.m_tPlayerInfo.zlsJsonInfo ~= "" then
        self.m_tPlayerInfo.zlsJsonInfo = json.decode(self.m_tPlayerInfo.zlsJsonInfo)
    end

	--玩家装备
	if self.m_nItemIdPlayerId == id and self.m_tPlayerItemData then 
		self.m_tPlayerInfo.item = self.m_tPlayerItemData
	end

	self.m_bGetInfoData = true 
	self.m_bOtherPlayerExpand = true

	--坐骑数据
	if self.m_tMountPlayerId == id and self.m_tMount then
		self.m_tPlayerInfo.mountsMessage = self.m_tMount
	end
	--足迹数据
	if self.m_tFootMarkPlayerId == id and self.m_tFootMark then
		self.m_tPlayerInfo.footMark = self.m_tFootMark
	end
	--皮肤数据
	if self.m_tSkinPlayerId == id and self.m_tSkin then 
		self.m_tPlayerInfo.shape = self.m_tSkin
	end

	self:_updateFire()
	self:_showPet()
	self:_showKids()
	self:setDianZanNum()

	--右侧信息列表
	self:updateInfo()
	--留言
	self:showMessageList()
end

--@brief   创建加载框
function WndCheckOther:createLoading()
	self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end

--@brief   关闭加载框
function WndCheckOther:closeLoading()
	MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
end

--@brief	已获得勋章的个数
function WndCheckOther:getMedalNum() 
	local sum = 0
	if CheckButtonShow(5) then
		sum = sum + 1
	end
	if CheckButtonShow(23) then
		sum = sum + 2
	end
	local level = WndCheckOther.m_tPlayerInfo.totemLevel
	if tonumber(level) > 0 then
		sum = sum + 1
	end
	if CheckButtonShow(8) then
		sum = sum + 1
	end
	if CheckButtonShow(30) then
		sum = sum + 1
	end
	--幻化
	local shapeId = WndCheckOther.m_tPlayerInfo.shapeId
	if shapeId ~= nil and shapeId >= 0 then
		sum = sum + 1
	end
	--觉醒
	if CheckButtonShow(120) then
		sum = sum + 1
	end
	--家园
	if CheckButtonShow(131) then
		sum = sum + 1
	end
	return sum
end

--@brief 	获取玩家坐骑数据
function WndCheckOther:getMyMountData()
	-- body
	local tData = self.m_tMount
	local tDataList = {}

	for i = 1, #tData do
		local tempTable = {}
		local idTable = {}
		local tMount = json.decode(tData[i])

		local mountsId = tMount.mountsId
		local attrNum = 1
		local attrIndex = 1
		if mountsId == nil or GDatatab_mounts["id_"..mountsId] == nil then break end
		local tData = GDatatab_item["id_"..GDatatab_mounts["id_"..mountsId].item_id]
		tempTable.icon = tData.icon
		tempTable.title1 = tData.name
		tempTable.name = tData.name
		tempTable.title2 = ""
		tempTable.quality = tData.quality
		tempTable.fighting = tMount.fighting
		tempTable.upgradeLevel = tMount.upgradeLevel
		tempTable.advancedLevel = tMount.advancedLevel
		tempTable.highLightObj = self
		for k,v in pairs(tMount) do
			if tonumber(k) ~= nil and v ~= 0 then
				table.insert(idTable,k)
			end
		end
		table.sort(idTable)
		for _,v in pairs(idTable) do
			if attrNum <= 5 then
				tempTable["attr"..attrIndex] = ATTR_TITLE[tonumber(v)]
				tempTable["attrVal"..attrIndex] = tMount[tostring(v)]
				attrIndex = attrIndex + 1
				attrNum = attrNum + 1
			end
		end
		table.insert(tDataList,tempTable)
	end
	table.sort(tDataList, sortQuality)

	return tDataList
end

--@brief 	获取玩家皮肤数据
function WndCheckOther:getMySkinData()
	local tData = self.m_tSkin
	local tDataList = {}
	for i = 1,#tData do 
		local tempTable = {}
		local idTable = {}
		local tSkin = json.decode(tData[i])
		local tRefineProperties = json.decode(tSkin.refineProperties)
		
		local skinId = tonumber(tSkin.shapeId)
		if skinId == nil or GDatatab_shape_skins["id_"..skinId] == nil then break end
		local tShapeInfo = GDatatab_shape_skins["id_"..skinId]
		local id = tShapeInfo.channel
		local property = tShapeInfo.property
		local tData = GDatatab_item["id_"..id]
		tempTable.icon = tData.icon
		tempTable.title1 = tData.name
		tempTable.name = tData.name
		tempTable.title2 = ""
		tempTable.quality = tShapeInfo.quality
		tempTable.upgradeLevel = 0
		tempTable.advancedLevel = tonumber(tSkin.advancedLevel)
		tempTable.highLightObj = self
		-- WZLog("皮肤炼化数据",Serialize(tRefineProperties))

		local curStarData 
		for k,v in pairs(GDatatab_shape_advanced) do
			if v.level == tonumber(tSkin.advancedLevel) then curStarData = v end
		end

		local tProp = {}
		for i=1,tShapeInfo.quality do
			tempTable["attr"..i] = ATTR_TITLE[property[i][1]]
			tempTable["attrVal"..i] = property[i][2]
			--炼化属性
			for x,y in pairs(tRefineProperties) do
				if property[i][1] == tonumber(x) and tonumber(y) ~= 0 then
					tempTable["attrVal"..i] = tempTable["attrVal"..i] + y
				end
			end
			--进阶加成比例
			if curStarData then
				tempTable["attrVal"..i] = math.ceil(tempTable["attrVal"..i] * (1 + curStarData.property_rate/10000))
			end

			table.insert(tProp,{property[i][1],tempTable["attrVal"..i]})
		end


		local fight = self:_caculateFighting(tProp)
		-- WZLog("皮肤基本战力",fight)
		table.insert(tDataList,tempTable)
		tempTable.fighting = fight
	end
	table.sort(tDataList, sortQuality)
	return tDataList
end

--@brief 	获取玩家足迹数据
function WndCheckOther:getMyFootMarkData()
	-- body
	local tData = self.m_tFootMark
	local tDataList = {}

	for i = 1, #tData do
		local tempTable = {}
		local idTable = {}
		local tMount = json.decode(tData[i])
		local footmarkId = tMount.footmarkId
		local attrNum = 1
		local attrIndex = 1
		if footmarkId == nil or GDatatab_footmark["id_"..footmarkId] == nil then break end
		local tData = GDatatab_item["id_"..GDatatab_footmark["id_"..footmarkId].item_id]
		tempTable.icon = tData.icon
		tempTable.title1 = tData.name
		tempTable.name = tData.name
		tempTable.title2 = ""
		tempTable.quality = tData.quality
		tempTable.fighting = tMount.fighting
		tempTable.upgradeLevel = tMount.upgradeLevel
		tempTable.advancedLevel = tMount.advancedLevel
		tempTable.highLightObj = self
		for k,v in pairs(tMount) do
			if tonumber(k) ~= nil and v ~= 0 then
				table.insert(idTable,k)
			end
		end
		table.sort(idTable)
		for _,v in pairs(idTable) do
			if attrNum <= 5 then
				tempTable["attr"..attrIndex] = ATTR_TITLE[tonumber(v)]
				tempTable["attrVal"..attrIndex] = tMount[tostring(v)]
				attrIndex = attrIndex + 1
				--WZLog("属性的key是",ATTR_TITLE[tonumber(v)],v,tMount[tostring(v)])
				attrNum = attrNum + 1
			end
		end
		table.insert(tDataList,tempTable)
	end
	table.sort(tDataList, sortQuality)

	return tDataList
end

--@brief	设置背景或设置隐藏翅膀、伴侣、宠物成功
function WndCheckOther:setBgOrOtherOK()
	-- body
	MsgBoxManager:showTipBox(LocalStrings.SET_SUCCESS)
	local showMes = CacheCenter:getPlayerInfo().showMes
	if self.m_nOperateType == 0 then --使用背景
		--更新背景
		CacheCenter:getPlayerInfo().background = self.m_tClickBgData.id
		self.m_nShowBgId = self.m_tClickBgData.id
		if self.m_tCellLastUsingBg then 
			self.m_tCellLastUsingBg:setUseingVisible(false)
		end
		self.m_tCellClickBg:setUseingVisible(true)
		self.m_tCellLastUsingBg = self.m_tCellClickBg
		self:_setNewBg(CacheCenter:getPlayerInfo().background)
	elseif self.m_nOperateType == 1 then --设置翅膀
		local checkBoxWing = GetElement(self.m_root, "checkBoxWing_WndCheckOther", WZUICheckBox)
		local nIndex = checkBoxWing:getCheckIndex()
		local tBits = self:_NumberToBits(showMes, self.m_nBgCheckNum)
		tBits[1] = nIndex
		CacheCenter:getPlayerInfo().showMes = BitsToNumber(tBits)
		--更新翅膀的展示
		self:showPlayer(self.m_tPlayerInfo.item)
	elseif self.m_nOperateType == 2 then --设置伴侣
		local checkBoxMate = GetElement(self.m_root, "checkBoxMate_WndCheckOther", WZUICheckBox)
		local nIndex = checkBoxMate:getCheckIndex()
		local tBits = self:_NumberToBits(showMes, self.m_nBgCheckNum)
		tBits[2] = nIndex
		self:setPetPosition(tBits)
		CacheCenter:getPlayerInfo().showMes = BitsToNumber(tBits)
		--更新伴侣的展示
		self:showPlayer(self.m_tPlayerInfo.item)
		self:_showKids()
	elseif self.m_nOperateType == 3 then --设置宠物
		local checkBoxPet = GetElement(self.m_root, "checkBoxPet_WndCheckOther", WZUICheckBox)
		local nIndex = checkBoxPet:getCheckIndex()
		local tBits = self:_NumberToBits(showMes, self.m_nBgCheckNum)
		tBits[3] = nIndex
		CacheCenter:getPlayerInfo().showMes = BitsToNumber(tBits)
		--更新宠物的展示
		self:_showPet()
	elseif self.m_nOperateType == 4 then --设置孩子
		local checkBoxKid = GetElement(self.m_root, "checkBoxKid_WndCheckOther", WZUICheckBox)
		local nIndex = checkBoxKid:getCheckIndex()
		local tBits = self:_NumberToBits(showMes, self.m_nBgCheckNum)
		tBits[4] = nIndex
		CacheCenter:getPlayerInfo().showMes = BitsToNumber(tBits)
		--更新孩子的展示
		self:_showKids()
	elseif self.m_nOperateType == 5 then --使用坐骑
		local checkBoxMount = GetElement(self.m_root, "checkBoxMount_WndCheckOther", WZUICheckBox)
		local nIndex = checkBoxMount:getCheckIndex()
		local tBits = self:_NumberToBits(showMes, self.m_nBgCheckNum)
		tBits[5] = nIndex
		CacheCenter:getPlayerInfo().showMes = BitsToNumber(tBits)
		--更新坐骑的展示
		self:showPlayer(self.m_tPlayerInfo.item)
	elseif self.m_nOperateType == 6 then --使用皮肤
		local checkBoxSkin = GetElement(self.m_root, "checkBoxSkin_WndCheckOther", WZUICheckBox)
		local nIndex = checkBoxSkin:getCheckIndex()
		local tBits = self:_NumberToBits(showMes, self.m_nBgCheckNum)
		tBits[6] = nIndex
		CacheCenter:getPlayerInfo().showMes = BitsToNumber(tBits)
		--更新皮肤的展示
		self:showPlayer(self.m_tPlayerInfo.item)
	elseif self.m_nOperateType == 7 then --留言
		local checkBoxMes = GetElement(self.m_root, "checkBoxMes_WndCheckOther", WZUICheckBox)
		local nIndex = checkBoxMes:getCheckIndex()
		local tBits = self:_NumberToBits(showMes, self.m_nBgCheckNum)
		tBits[7] = nIndex == 1 and 0 or 1
		CacheCenter:getPlayerInfo().showMes = BitsToNumber(tBits)
		--更新皮肤的展示
		self:showMessageList()
	end
end

--@brief	购买背景成功
function WndCheckOther:setBuyBgOK()
	-- body
	MsgBoxManager:showTipBox(LocalStrings.SHOP_BUY_SUCCESS)

	self:showSetBg()
	self:_setNewBg(CacheCenter:getPlayerInfo().background)
end

function WndCheckOther:_NumberToBits(n, nCount)
    local tBits = {}

    while n >= 0 and #tBits < nCount do
        table.insert(tBits, math.fmod(n, 2))
        n = math.floor(n/2)
    end

    return tBits
end

--@brief 	更新头像状态
function WndCheckOther:updateHeadImgState()
	-- body
	if self.m_root == nil then return end 

	if self.m_tPlayerInfo.id == CacheCenter:getPlayerInfo().id then
		self.m_tPlayerInfo.headSculStatus = CacheCenter:getPlayerInfo().headSculStatus
		self.m_tSpaceCell:setPhoteWords()
	end
end

--@brief 	更新头像
function WndCheckOther:updateHeadImg()
	-- body
	if self.m_root == nil then return end 
	
	if self.m_tPlayerInfo.id == CacheCenter:getPlayerInfo().id then
		self.m_tPlayerInfo.headScul = CacheCenter:getPlayerInfo().headScul
		self.m_tSpaceCell:showPhotoHead()
	end
end

--@brief 	设置踩一踩和鲜花羁绊数据
function WndCheckOther:setFootAndFlowerFetterData(flowersInfo, joinInfo, friendsTop3Info)
	-- body
	self.m_tFootTitleData = {} 		--踩一踩羁绊数据
	self.m_tFlowerTitleData = {} 		--送鲜花羁绊数据
	self.m_tFriendsTitleData = {} 		--好友度前三数据
	local sConfigFlower = CacheCenter:getGameParam().ganmTitleFlower
	local sConfigFoot = CacheCenter:getGameParam().ganmTitleLook
	local sConfigFriends = CacheCenter:getGameParam().friendliness
	WZLog("WndCheckOther:setFootAndFlowerFetterData", sConfigFlower, sConfigFoot)
	local tConfigFlower = json.decode(sConfigFlower)
	local tConfigFoot = json.decode(sConfigFoot)
	local tConfigFriends = json.decode(sConfigFriends)

	if #flowersInfo > 0 then 
		for i = 1, #flowersInfo do
			local tFlowersInfo = json.decode(flowersInfo[i])

			local tItem = {}
			local bAdd = false 
			if tonumber(tFlowersInfo.flowers) >= tConfigFlower.num3 then 
				tItem.title = tConfigFlower.title3
				tItem.rank = 1
				bAdd = true
			elseif tonumber(tFlowersInfo.flowers) >= tConfigFlower.num2 then 
				tItem.title = tConfigFlower.title2
				tItem.rank = 2
				bAdd = true
			elseif tonumber(tFlowersInfo.flowers) >= tConfigFlower.num1 then 
				tItem.title = tConfigFlower.title1
				tItem.rank = 3
				bAdd = true
			end
			tItem.flowerNum = tonumber(tFlowersInfo.flowers)
			tItem.time = tonumber(tFlowersInfo.time)
			tItem.playerId = tonumber(tFlowersInfo.playerId)
			tItem.sex = tonumber(tFlowersInfo.sex)
			tItem.headId = tonumber(tFlowersInfo.headId)
			tItem.faceId = tonumber(tFlowersInfo.faceId)
			tItem.headColor = tonumber(tFlowersInfo.headColor)
			tItem.level = tonumber(tFlowersInfo.playerLevel)
			tItem.playerName = tFlowersInfo.playerName
			tItem.vipLevel = tonumber(tFlowersInfo.vip)
			tItem.type = 2
			if bAdd then 
				table.insert(self.m_tFlowerTitleData, tItem)
			end
		end
		if #self.m_tFlowerTitleData > 1 then 
			table.sort(self.m_tFlowerTitleData, function (a,b)
				--body
				if a.rank ~= b.rank then 
					return a.rank < b.rank 
				else
					return a.time < b.time 
				end
			end)
		end
	end

	if #joinInfo > 0 then 
		for i = 1, #joinInfo do
			local tFootInfo = json.decode(joinInfo[i])
			local tItem = {}

			local bAdd = false 
			if tonumber(tFootInfo.join) >= tConfigFoot.term3 then 
				tItem.title = tConfigFoot.title3
				tItem.rank = 1
				bAdd = true
			elseif tonumber(tFootInfo.join) >= tConfigFoot.term2 then 
				tItem.title = tConfigFoot.title2
				tItem.rank = 2
				bAdd = true
			elseif tonumber(tFootInfo.join) >= tConfigFoot.term1 then 
				tItem.title = tConfigFoot.title1
				tItem.rank = 3
				bAdd = true
			end
			tItem.footNum = tonumber(tFootInfo.join)
			tItem.time = tonumber(tFootInfo.time)
			tItem.playerId = tonumber(tFootInfo.playerId)
			tItem.sex = tonumber(tFootInfo.sex)
			tItem.headId = tonumber(tFootInfo.headId)
			tItem.faceId = tonumber(tFootInfo.faceId)
			tItem.headColor = tonumber(tFootInfo.headColor)
			tItem.level = tonumber(tFootInfo.playerLevel)
			tItem.playerName = tFootInfo.playerName
			tItem.vipLevel = tonumber(tFootInfo.vip)
			tItem.type = 1
			if bAdd then 
				table.insert(self.m_tFootTitleData, tItem)
			end
		end
		if #self.m_tFootTitleData > 1 then 
			table.sort(self.m_tFootTitleData, function (a,b)
				--body
				if a.rank ~= b.rank then 
					return a.rank < b.rank 
				else
					return a.time < b.time 
				end
			end)
		end
	end

	if #friendsTop3Info > 0 then 
		for i = 1, #friendsTop3Info do
			local tFriendInfo = json.decode(friendsTop3Info[i])

			local tItem = {}
			local bAdd = false 
			if tonumber(tFriendInfo.friendNum) >= tConfigFriends.num3 then 
				tItem.title = tConfigFriends.title3
				tItem.rank = 1
				bAdd = true
			elseif tonumber(tFriendInfo.friendNum) >= tConfigFriends.num2 then 
				tItem.title = tConfigFriends.title2
				tItem.rank = 2
				bAdd = true
			elseif tonumber(tFriendInfo.friendNum) >= tConfigFriends.num1 then 
				tItem.title = tConfigFriends.title1
				tItem.rank = 3
				bAdd = true
			end
			tItem.friendliness = tonumber(tFriendInfo.friendNum)
			tItem.playerId = tonumber(tFriendInfo.playerId)
			tItem.sex = tonumber(tFriendInfo.sex)
			tItem.headId = tonumber(tFriendInfo.headId)
			tItem.faceId = tonumber(tFriendInfo.faceId)
			tItem.headColor = tonumber(tFriendInfo.headColor)
			tItem.level = tonumber(tFriendInfo.playerLevel)
			tItem.playerName = tFriendInfo.playerName
			tItem.vipLevel = tonumber(tFriendInfo.vip)
			tItem.type = 3
			if bAdd then 
				table.insert(self.m_tFriendsTitleData, tItem)
			end
		end
		if #self.m_tFriendsTitleData > 1 then 
			table.sort(self.m_tFriendsTitleData, function (a,b)
				--body
				if a.rank ~= b.rank then 
					return a.rank < b.rank 
				else
					if a.friendliness ~= b.friendliness then 
						return a.friendliness < b.friendliness 
					else
						return a.playerId < b.playerId
					end
				end
			end)
		end
	end
end

--@brief    赠送礼物成功后处理函数
function WndCheckOther:giveGiftOk(result)
    --body
    if WndCheckOther.m_root == nil then
        return
    end

    self.m_tPlayerInfo.friendliness = self.m_tPlayerInfo.friendliness + result
    if result > 0 then
        local txtSuccessAtt = string.format(LocalStrings.GIVE_GIFT_SUCCESS, result)
        MsgBoxManager:showTipBox(txtSuccessAtt)--增加好友度

        WndFriendGift:resetFriendliness(self.m_tPlayerInfo.id, result)
        WndWakeupcoinJump:resetFriendliness(self.m_tPlayerInfo.id, result)
    end
end

--@brief	更新个人资料
function WndCheckOther:sendProtocol()
	ProtocolProcessorWndSpace:send_SPACE_UpdatePlayerInfo(self.m_tData.playerSex, self.m_tData.birthday, self.m_tData.playerAge, self.m_tData.playerCon, self.m_tData.voiceInfo, self.m_tData.locSeting, self.m_tData.pahSeting, self.m_tData.msgSeting, self.m_tData.cityCode)
end

--@brief 	选定出生年月日省份城市后，刷新显示
function WndCheckOther:updateSetShow(nType, value)
	if self.m_root == nil then return end 
	if self.m_tSpaceCell == nil then return end 

	self.m_tSpaceCell:updateInfo(nType, value)
end
-------------------------------------私有方法模块End----------------------------------------
