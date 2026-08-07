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
	self.m_nOperateType = nil 		--操作类型:1->设置翅膀;2->设置伴侣;3->设置宠物;4->设置孩子;5->使用背景
	self.conMatePlayer = nil 		--伴侣
	self.conPlayerPet = nil 		--宠物
	self.m_tCellLastClickBg = nil   --上次点中的bg
	self.m_nUploadType = nil
	self.m_tUploadCell = nil
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
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	设置背包玩家缓存信息
function WndCheckOther:setPlayerInfo(id, name, sex, title, guildName, position, level, vipLevel, winNum, playNum, fighting, mateName, signature, isFriend, itemId, extranInfo, property, strongSuitId, starSuitId, mosaicSuitId, petMessage, mountsMessage, tournamentLevel, segmentId, totemLevel, loveLevel, loveSkill, moralityLevel, masterName, itemSuitId, itemSuitNum, snsValue, rankMatchMessage, starsoulId, guildLevel, spaceSex, giftNum, distance, headScul, mentoring, couple, useMountsMessage, tournamentIntegral, marryFlag, serverId, prayIds, xlId, xlExp, headColor, bodyColor, isUse, chum, shapeId, shapeLevel, showShape, awakeSoulLevel, awakeStep, itemSuitId2, itemSuitNum2, homeLevel, sheerLuxury, footMark, shapeSkillId, awakeSkillId, runeItemId, runeItemNum, obtainNum, cardMessage, bgId, showMes, coupleMes, childMes, careBuffProp, careToday, thumbUpNum, badgeInfo)
	if id == CacheCenter:getPlayerInfo().id and self.m_tPlayerInfo ~= nil then 
		return ;
	end
	self.m_root:setVisible(true)
	--self:closeLoading()
	self.m_tPlayerInfo = {}
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
	self.m_tPlayerInfo.mountsMessage = VectorToTable(mountsMessage)  --坐骑信息
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
	self.m_tPlayerInfo.prayIds = VectorToTable(prayIds)
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
	self.m_tPlayerInfo.footMark = VectorToTable(footMark)
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
	WZLog("WndCheckOther:setPlayerInfo", cardMessage, childMes)

    if self.m_tPlayerInfo.useMountsMessage ~= "" then
        self.m_tPlayerInfo.mountsInfo = json.decode(self.m_tPlayerInfo.useMountsMessage)
        self.m_tPlayerInfo.mountsId = GDatatab_item["id_"..GDatatab_mounts["id_"..self.m_tPlayerInfo.mountsInfo.mountsId].item_id].animation_index_code
        self.m_tPlayerInfo.mountsType = GDatatab_item["id_"..GDatatab_mounts["id_"..self.m_tPlayerInfo.mountsInfo.mountsId].item_id].sub_type
    end
	
	self.m_tMount = self.m_tPlayerInfo.mountsMessage
	self.m_tFootMark = self.m_tPlayerInfo.footMark

    if self.m_tPlayerInfo.petMessage ~= "" then
        self.m_tPlayerInfo.petInfo = json.decode(self.m_tPlayerInfo.petMessage)
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

	--玩家装备
	self.m_tPlayerInfo.item = {}
	for i = 0,itemId:size()-1 do
		local temp = {}
		temp.id = itemId:get(i)
		--WZLog("---itemId:get(i)--",itemId:get(i))
		temp.basicInfo = GDatatab_item["id_"..itemId:get(i)]
		temp.extraInfo = json.decode(extranInfo:get(i))
		temp.maintype = temp.basicInfo.main_type
		temp.subtype = temp.basicInfo.sub_type
		if isUse:get(i) == 1 then
			temp.isUse = true
		else
			temp.isUse = false
		end
		--if temp.maintype == 5 then
			temp.extraInfo.fighting = caculateClothesFighting(temp.extraInfo)
		--end
		table.insert(self.m_tPlayerInfo.item,temp)
	end

	self:showPlayer(self.m_tPlayerInfo.item)
	self:_updateFire()
	self:_showPet()
	self:_showKids()
	self:setDianZanNum()

	--右侧信息列表
	self:updateInfo()
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
	if self.m_nOperateType == 1 then --设置翅膀
		local checkBoxWing = GetElement(self.m_root, "checkBoxWing_WndCheckOther", WZUICheckBox)
		local nIndex = checkBoxWing:getCheckIndex()
		local tBits = self:_NumberToBits(showMes, 4)
		tBits[1] = nIndex
		CacheCenter:getPlayerInfo().showMes = BitsToNumber(tBits)
		--更新翅膀的展示
		self:showPlayer(self.m_tPlayerInfo.item)
	elseif self.m_nOperateType == 2 then --设置伴侣
		local checkBoxMate = GetElement(self.m_root, "checkBoxMate_WndCheckOther", WZUICheckBox)
		local nIndex = checkBoxMate:getCheckIndex()
		local tBits = self:_NumberToBits(showMes, 4)
		tBits[2] = nIndex
		self:setPetPosition(tBits)
		CacheCenter:getPlayerInfo().showMes = BitsToNumber(tBits)
		--更新伴侣的展示
		self:showPlayer(self.m_tPlayerInfo.item)
		self:_showKids()
	elseif self.m_nOperateType == 3 then --设置宠物
		local checkBoxPet = GetElement(self.m_root, "checkBoxPet_WndCheckOther", WZUICheckBox)
		local nIndex = checkBoxPet:getCheckIndex()
		local tBits = self:_NumberToBits(showMes, 4)
		tBits[3] = nIndex
		CacheCenter:getPlayerInfo().showMes = BitsToNumber(tBits)
		--更新宠物的展示
		self:_showPet()
	elseif self.m_nOperateType == 4 then --设置孩子
		local checkBoxKid = GetElement(self.m_root, "checkBoxKid_WndCheckOther", WZUICheckBox)
		local nIndex = checkBoxKid:getCheckIndex()
		local tBits = self:_NumberToBits(showMes, 4)
		tBits[4] = nIndex
		CacheCenter:getPlayerInfo().showMes = BitsToNumber(tBits)
		--更新孩子的展示
		self:_showKids()
	elseif self.m_nOperateType == 5 then --使用背景
		--更新背景
		CacheCenter:getPlayerInfo().background = self.m_tClickBgData.id
		self.m_nShowBgId = self.m_tClickBgData.id
		if self.m_tCellLastClickBg then 
			self.m_tCellLastClickBg:setUseingVisible(false)
		end
		self.m_tCellClickBg:setUseingVisible(true)
		self:_setNewBg(CacheCenter:getPlayerInfo().background)
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
        table.insert(tBits, math.mod(n, 2))
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
-------------------------------------私有方法模块End----------------------------------------
