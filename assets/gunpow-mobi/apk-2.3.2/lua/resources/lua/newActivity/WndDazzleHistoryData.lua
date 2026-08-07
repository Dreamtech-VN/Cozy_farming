--WndDazzleHistoryData.lua
--@brief	WndDazzleHistory的数据模块
--@date		2023/03/24
--@author	XTX
--@note		耀眼榜活动-历届榜首界面

WndDazzleHistory = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndDazzleHistory:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tRankChanpionData = nil 
	self.m_tSelCell = nil 
	self.m_nTabIndex = 1 
	self.m_nActivityId = nil 
	self.m_tWorshipPlayerIds = {} 		--当天已膜拜的玩家Id
	self.m_tCellByPlayerId = {}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndDazzleHistory:_unInit()
	self.m_root = nil
	self.m_tRankChanpionData = nil 
	self.m_tSelCell = nil 
	self.m_nTabIndex = nil 
	self.m_nActivityId = nil 
	self.m_tWorshipPlayerIds = nil 		--当天已膜拜的玩家Id
	self.m_tCellByPlayerId = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndDazzleHistory:createElement()
	if WndDazzleHistory.m_root ~= nil then
		WindowManager:removeWindow(WndDazzleHistory.m_root, WndDazzleHistory, true)
	end
	local element = WZUISystem:getInstance():createElement("WndDazzleHistory")
	assert(element, "WndDazzleHistory create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndDazzleHistory:showInterface(activityId)
	local wndWater = WndDazzleHistory:createElement()
	if wndWater then 
		self.m_nActivityId = activityId
		WindowManager:addWindow(wndWater, WndDazzleHistory, false, nil, nil, true)
	end
end

--@brief 	获取历届数据
function WndDazzleHistory:onGetOtherData(activityId, activityType, rankingType, moBaiPlayerIds, playerIds, points, names, headIds, headColors, faceIds, sexs, vipLevels, levels, bodyIds, bodyColors, windIds, title, serverId, seasonNum, blueVip, mobai)
	if self.m_nActivityId == activityId and rankingType == self.m_nTabIndex then 
		self.m_tWorshipPlayerIds = moBaiPlayerIds

		self:setChanpionRankData(playerIds, seasonNum, names, levels, faceIds, headIds, sexs, points, serverId, bodyIds, windIds, headColors, bodyColors, title, blueVip, mobai, activityId, rankingType)
		local tbList = GetElement(self.m_root,"tbList_WndDazzleHistory", WZUITableContainer)
		tbList:cleanTable()
		self.m_tCellByPlayerId = {} 

		if next(self.m_tRankChanpionData) == nil then
			ShowPanelNullTip( tbList, LocalStrings.CHARM_RESULT)
			return
		end

		for i=1, #self.m_tRankChanpionData do
			local element, tLuaObj = CellDazzleFirstItem:createElement()
			if element and tLuaObj then 
				element:setTag(i - 1)
				tLuaObj:setRankItemData(self.m_tRankChanpionData[i])

				tbList:setCellElement(element)
				if self.m_tCellByPlayerId[tostring(self.m_tRankChanpionData[i].playerId)] == nil then 
					self.m_tCellByPlayerId[tostring(self.m_tRankChanpionData[i].playerId)] = {}
				end
				table.insert(self.m_tCellByPlayerId[tostring(self.m_tRankChanpionData[i].playerId)], tLuaObj)
			end
		end
	end
end

function WndDazzleHistory:setChanpionRankData(playerId, ranking, name, level, faceId, headId, sex, param1, serverId, bodyId, windId,headColor,bodyColor, title, qqHallInfo, mobai, activityId, rankingType)
	self.m_tRankChanpionData = {}

	for i = 1, #ranking do
		local temp = {}
		temp.ranking   = ranking[i]
		temp.playerId   = playerId[i]
		temp.name = name[i]
		temp.level = level[i]
		temp.score = param1[i]
		temp.headId   = headId[i]
		temp.faceId = faceId[i]
		temp.bodyId = tonumber(bodyId[i])
		temp.wingId = tonumber(windId[i])
		temp.sex = sex[i]
		temp.headColor = headColor[i]
		temp.bodyColor = bodyColor[i]
		temp.title = title[i]
		if serverId[i] == CacheCenter:getPlayerInfo().serverId then 
			temp.cross = 0
		else
			temp.cross = 1
		end
		if qqHallInfo and qqHallInfo[i] ~= "" then 
			temp.qqHallData = json.decode(qqHallInfo[i])
		end
		temp.worshipNum = mobai[i]
		temp.activityId = activityId
		temp.rankingType = rankingType

		self.m_tRankChanpionData[i] = temp
	end
	return self.m_tRankChanpionData
end

--@brief 	膜拜成功 
function WndDazzleHistory:worshipOK(activityId, rankingType, playerId, mobaiNum)
	WZLog("WndDazzleHistory:worshipOK", playerId)
	if self.m_nActivityId == activityId then 
		table.insert(self.m_tWorshipPlayerIds, playerId)
		for i = 1, #self.m_tRankChanpionData do
			if self.m_tRankChanpionData[i].playerId == playerId then 
				self.m_tRankChanpionData[i].worshipNum = mobaiNum
			end
		end
		if self.m_tCellByPlayerId[tostring(playerId)] then 
			WZLog("WndDazzleHistory:worshipOK 00", #self.m_tCellByPlayerId[tostring(playerId)])
			for i = 1, #self.m_tCellByPlayerId[tostring(playerId)] do
				self.m_tCellByPlayerId[tostring(playerId)][i]:setWorshipNum(mobaiNum)
			end
		end
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
CellDazzleFirstItem = {}
function CellDazzleFirstItem:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_bIsLoaded = false 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellDazzleFirstItem:_unInit()
	self.m_root = nil
	self.m_bIsLoaded = nil 
end

--@brief	创建控件
function CellDazzleFirstItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(254,400))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end

function CellDazzleFirstItem:setRankItemData(data)
	self.m_tChanpionRankData = data
end

--@brief 	获取数据
function CellDazzleFirstItem:getData()
	return self.m_tChanpionRankData
end

--@brief 	开始加载
function CellDazzleFirstItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("CellDazzleFirstItem")
	celElement:setVisible(true)
	element:addChild(celElement)
	self.m_bIsLoaded = true 

	self:setChanpionRankItem()
end

function CellDazzleFirstItem:setChanpionRankItem()
	if not self.m_tChanpionRankData then return end

	local data = self.m_tChanpionRankData

	local txtCurChanpion = GetElement(self.m_root,"txtCurChanpion_CellDazzleFirstItem",WZUILabelTTF)
	txtCurChanpion:setText(string.format(LocalStrings.NEWVIP_TEXT23,tostring(data.ranking)))

	local conContent = GetElement(self.m_root, "conContent_CellDazzleFirstItem", WZUIContainer)
	CreatePlayerLvNameAndBlueIcon(conContent, {0.5, 0.82}, data.level, GlobalMethod:ccc3(255,236,193), GlobalMethod:ccc3(132,66,29), 22, data.qqHallData, data.name, GlobalMethod:ccc3(255,236,193), GlobalMethod:ccc3(132,66,29), 22)
	
	local txtScore = GetElement(self.m_root,"ftxtScore_CellDazzleFirstItem",WZUIFreeTextBox)

	local scoreFormat = [[<T C="255,236,193" S="18" P="1" SC="132,66,29" SS="4" SE="1">%s:</T><T C="255,227,116" S="18" P="1" SC="132,66,29" SS="4" SE="1">%d</T>]]
	if data.rankingType == 1 then 
		txtScore:setShowText(string.format(scoreFormat, LocalStrings.DAZZLERANK_TEXT1[3], data.score))
	elseif data.rankingType == 2 then 
		txtScore:setShowText(string.format(scoreFormat, LocalStrings.DAZZLERANK_TEXT1[4], data.score))
	end

	local tEquip = {}
    table.insert(tEquip,data.headId)
    table.insert(tEquip,data.faceId)
    table.insert(tEquip,data.bodyId)
    table.insert(tEquip,data.wingId)
	local roleCon = GetElement(self.m_root,"roleCon_CellDazzleFirstItem",WZUIContainer)
	--人物
	local conPlayer = CreatePlayerFigure(data.sex, tEquip, "wait0", nil, nil, nil, nil, nil, nil, nil, data.headColor, data.bodyColor, false)
	roleCon:addChild(conPlayer:getAnimNode())

	--称号
	local sTempTitle,sTitleString
	local title_con = GetElement(self.m_root,"conTitle_CellDazzleFirstItem",WZUIContainer)
	local playerTitle = GetElement(self.m_root,"playerTitle_CellDazzleFirstItem",WZUILabelTTF)
	CreateDesiSpine(title_con, playerTitle, data.title, GlobalMethod:ccp(0.5,0.893))
	--膜拜次数
	self:setWorshipNum(data.worshipNum)
end

--膜拜个数
function CellDazzleFirstItem:setWorshipNum(num)
	self.m_tChanpionRankData.worshipNum = num 
	if not self.m_bIsLoaded then return end 
	local txtShipCount = GetElement(self.m_root, "txtShipCount_CellDazzleFirstItem", WZUIFreeTextBox)
	if txtShipCount then
		local strTemp = string.gsub(LocalStrings.NEWVIP_TEXT22, [[S="22"]], [[S="18"]])
		txtShipCount:setShowText(string.format(strTemp, num))
	end
end

function CellDazzleFirstItem:onBtnRole()
	local conChanpion = GetElement(self.m_root,"conChanpion_CellDazzleFirstItem",WZUIContainer)
	if conChanpion:isVisible() == true then
		conChanpion:setVisible(false)
	else
		conChanpion:setVisible(true)
	end
end

function CellDazzleFirstItem:onBtnCheckRole()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not self.m_tChanpionRankData then return end
	ProtocolProcessorWndBag:regAll1()
	ProtocolProcessorWndBag:send_PLAYER_GetPlayerInfo(self.m_tChanpionRankData.playerId)
end

function CellDazzleFirstItem:onBtnWorship()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local timesLimit = tonumber(CacheCenter:getGameParam().activityDayMobaiLimit)
	local nLeftWorshipTimes = timesLimit - #WndDazzleHistory.m_tWorshipPlayerIds

	if self.m_tChanpionRankData.playerId == CacheCenter:getPlayerInfo().id then 
		MsgBoxManager:showTipBox(LocalStrings.CANT_WORSHIP_SELF)
	else
		if nLeftWorshipTimes <= 0 then 
			MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT3[17])
		else
			local bWorshipToday = false 
			for i = 1, #WndDazzleHistory.m_tWorshipPlayerIds do
				if WndDazzleHistory.m_tWorshipPlayerIds[i] == self.m_tChanpionRankData.playerId then 
					bWorshipToday = true
					break 
				end
			end
			if bWorshipToday then 
				MsgBoxManager:showTipBox(LocalStrings.DAZZLERANK_TEXT1[10])
				return 
			end
			if self.m_tChanpionRankData then
				ProtocolProcessorFestivalActivity:send_ACTIVITY2_MoBai(self.m_tChanpionRankData.activityId, self.m_tChanpionRankData.rankingType, self.m_tChanpionRankData.playerId)
				GetElement(self.m_root,"conChanpion_CellDazzleFirstItem",WZUIContainer):setVisible(false)
			end
		end
	end
end

--@return	新建的表实例对象
function CellDazzleFirstItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end