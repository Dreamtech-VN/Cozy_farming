--WndTeamConsumeData.lua
--@brief	WndTeamConsume的数据模块
--@date		2023/04/10
--@author	XTX
--@note		组团消费活动主界面

WndTeamConsume = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndTeamConsume:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nTabIndex = 1
	self.m_nActivityId = nil 
	self.m_tTaskData = nil 
	self.m_tTaskItemCell = {}
	self.m_tTeamMenbers = nil 		--队伍数据
	self.m_nGiftRewardNum = 0 
	self.m_nGiftConfigNum = 1000
	self.m_tTeamInfo = nil 			--队伍队名、总消耗
	self.m_nCaptainId = 0 			--队长Id
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndTeamConsume:_unInit()
	self.m_root = nil
	self.m_nTabIndex = nil 
	self.m_nActivityId = nil 
	self.m_tTaskData = nil 
	self.m_tTaskItemCell = nil 
	self.m_tTeamMenbers = nil 
	self.m_nGiftRewardNum = nil 
	self.m_nGiftConfigNum = nil 
	self.m_tTeamInfo = nil 
	self.m_nCaptainId = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndTeamConsume:createElement()
	if WndTeamConsume.m_root ~= nil then
		WindowManager:removeWindow(WndTeamConsume.m_root, WndTeamConsume, true)
	end
	local element = WZUISystem:getInstance():createElement("WndTeamConsume")
	assert(element, "WndTeamConsume create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndTeamConsume:showInterface()
	LoadNewActivityRes(true)
	local wndWater = WndTeamConsume:createElement()
	if wndWater then 
		g_nLastChannelId_ShootArrow = GlobalGame.g_nCurrentUIChannelId
		WindowManager:addWindow(wndWater, WndTeamConsume, false)
	end
end

function WndTeamConsume:GetActivityInfoOK(activityId,maxCount,count,status, rewardCounts, rewardItems,rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	if activityId == tonumber(g_cityExtenInfo.activity7074) then
		self.m_nActivityId = activityId
		self.m_tContent = json.decode(content)
		WZLog("WndTeamConsume:GetActivityInfoOK", Serialize(self.m_tContent))
		self.m_nCaptainId = self.m_tContent.captainId
		self.m_tTeamMenbers = self.m_tContent.teams or {}
		self.m_nGiftRewardNum = self.m_tContent.captainPackStatus + 1
		self.m_nGiftConfigNum = self.m_tContent.captainTaskCost
		self.m_tTeamInfo = {teamName = self.m_tContent.name or "", costId = self.m_tContent.itemId, costNum = self.m_tContent.totalCost or 0}
		local txtActivityTime = GetElement(self.m_root,"txtActivityTime_WndTeamConsume",WZUILabelTTF)
		local _start = SystemTime:getTimeConverLocal6(startTime)
   		local _end = SystemTime:getTimeConverLocal6(endTime)
   		txtActivityTime:setText(_start.."-".._end)

   		self:_showTeamMenbers()
   		self:showBagGiftInfo()
   		self:showRedDot()
	end
end

function WndTeamConsume:_onGetRankResultInfo(activityId, activityType, rankingType, myPoint, myRanking, rewardConfig, playerIds, ranks, points, nickname, headIds, 
	headColors, faceIds, sexs, vipLevel, level, bodyIds, windIds, title, serverId, session, settlementDate, headEffectId, qqInfo)
	if activityId == self.m_nActivityId then
		WZLog("WndTeamConsume:_onGetRankResultInfo", Serialize(playerIds), Serialize(json.decode(rewardConfig)), Serialize(title), myPoint, myRanking)
		rewardConfig = json.decode(rewardConfig)
		if not rewardConfig then return end
		local fightFreeList = GetElement(self.m_root,"fightFreeList_WndTeamConsume",WZUIFreeListContainer)
		if fightFreeList:size() > 0 then 
			fightFreeList:removeAll()
		end
		myPoint = myPoint >= 0 and myPoint or 0
		local my_rank = GetElement(self.m_root,"txtMyRank_WndTeamConsume",WZUILabelTTF)
		if next(playerIds) == nil then
			ShowPanelNullTip(fightFreeList, LocalStrings.CHARM_RESULT, ccc3(138,122,106))
			my_rank:setText(LocalStrings.NOT_IN_RANKLIST)
			GetElement(self.m_root,"txtMyFight_WndTeamConsume",WZUILabelTTF):setText(myPoint)
			return
		end
		
		removeShowPanelNullTip(fightFreeList)
		local tData, myCurRank, _myPoint = self:setRankData(rewardConfig, playerIds, level, points, nickname, faceIds, headIds, headColors, sexs, bodyIds, 
			windIds,title, nil, 3, rankingType, serverId, headEffectId, qqInfo)--此处3只是为了获取并列名字，没有实际意义
		if myCurRank < 0 then
			my_rank:setText(LocalStrings.NOT_IN_RANKLIST)
		else
			my_rank:setText(myCurRank)
		end
		GetElement(self.m_root,"txtMyFight_WndTeamConsume",WZUILabelTTF):setText(myPoint)

		for i = 1, #tData do
			local element, tLuaObj = CellTeamCRankItem:createElement()
			element:setVisible(true)
			fightFreeList:pushBack(WZUIContainer:luaTo(element))
			fightFreeList:getMoveElement():setPositionY(fightFreeList:getMinPosition().y)
			tLuaObj:setFightItemData(tData[i], 3)
		end
	end
end

--排行榜数据
--@param 	title:队伍名字
function WndTeamConsume:setRankData(data, playerId, level, point, nickname, faceId, headId, headColor, sex, bodyIds, windIds, title, vipLevel, nRankType, rankingType, serverId, headEffectId, qqHallInfo)
	if not data then
		return {}, -1
	end
	local table_insert = table.insert
	local temp = nil
	temp = analyzeActivityReward(data)
	local index, myCurRank, myPoint = 1, -1, 0
	local tData, ids, nums = {}, {}, {}
	local my_id = CacheCenter:getPlayerInfo().id
	if rankingType == 1 then 
		my_id = self.m_nCaptainId
	end
	local nCount = #nickname
	local rankDataIndex = 0 
	local nRankIndex = 0
	local nCurScore = 0 
	local playerIndex = 1
	for i = 1, nCount do
		local nIndex = i
		rankDataIndex = i
		if my_id == playerId[nIndex] then
			myCurRank = nIndex
		end
		if nRankType and nRankType > 2 then 
			if nRankIndex == 0 and nCurScore ~= point[nIndex] then 
				nRankIndex = nRankIndex + 1
				nCurScore = point[nIndex]
			elseif nCurScore ~= point[nIndex] then 
				nRankIndex = nRankIndex + 1
			end
			if my_id == playerId[nIndex] then
				myCurRank = nRankIndex
			end
		else
			nRankIndex = nIndex
		end

		local tab = {}
		tab.rank_index = nRankIndex
		tab.point = point[nIndex]
		tab.name = nickname[nIndex]
		if title then
			tab.title = title[nIndex]
		end

		local tTempName = SplitStringWithSeparator(title[nIndex], ",")
		tab.playerData = {}
		if rankingType == 1 then 
			playerNum = #tTempName/2
			for j = 1, playerNum do
				tab.playerData[j] = {}
				tab.playerData[j].playerName = tTempName[j*2 - 1]
				if serverId then 
					tab.playerData[j].serverId = tonumber(tTempName[j*2])
				end

				playerIndex = playerIndex + 1
			end
		else
			tab.name = title[nIndex]
			playerNum = 1
			for j = 1, playerNum do
				tab.playerData[j] = {}
				tab.playerData[j].playerId = playerId[playerIndex]
				tab.playerData[j].playerName = nickname[playerIndex]
				tab.playerData[j].level = level[playerIndex]
				tab.playerData[j].faceId = faceId[playerIndex]
				tab.playerData[j].headId = headId[playerIndex]
				tab.playerData[j].headColor = headColor[playerIndex]
				tab.playerData[j].sex = sex[i]
				if bodyIds then
					tab.playerData[j].bodyId = bodyIds[playerIndex]
				end
				if windIds then
					tab.playerData[j].windId = windIds[playerIndex]
				end
				if vipLevel then 
					tab.playerData[j].vipLevel = vipLevel[playerIndex]
				end
				if serverId then 
					tab.playerData[j].serverId = serverId[playerIndex]
				end
				if headEffectId then 
					tab.playerData[j].headEffectId = headEffectId[playerIndex]
				end
				if qqHallInfo and qqHallInfo[playerIndex] ~= "" then 
					tab.playerData[j].qqHallData = json.decode(qqHallInfo[playerIndex])
				end

				playerIndex = playerIndex + 1
			end
		end

		ids,nums = {},{}
		if nRankType and nRankType > 2 then 
			for k = 1, #temp do
				if temp[k] and tab.rank_index >= tonumber(temp[k].rank1) and tab.rank_index <= tonumber(temp[k].rank2) then
					index = k
				end
			end
		else
			for k = 1, #temp do
				if temp[k] and rankDataIndex >= tonumber(temp[k].rank1) and rankDataIndex <= tonumber(temp[k].rank2) then
					index = k
				end
			end
		end
		if temp[index] then
			ids = temp[index].ids
			nums = temp[index].nums
		end
		tab.reward_id = ids
		tab.reward_num = nums
		tData[rankDataIndex] = tab
	end
	return tData, myCurRank, myPoint
end

--@brief 	获取其他活动数据
function WndTeamConsume:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end 

	if doType == 1 then --成为队长
		local tResult = json.decode(jsonData)
		WZLog("WndTeamConsume:_onGetOtherData 111", Serialize(tResult))
		if result == 1 then 
			MsgBoxManager:showTipBox(LocalStrings.TEAMCONSUME_TEXT1[21])
		end
	elseif doType == 2 then --队长礼包
		local tResult = json.decode(jsonData)
		WZLog("WndTeamConsume:_onGetOtherData 222", Serialize(tResult))
		if result == 1 then 
			local ids, nums = {}, {}
			for key, value in pairs(tResult) do
				table.insert(ids, tonumber(key))
				table.insert(nums, tonumber(value))
			end
			WndRewardShow:showById(ids, nums)
			self.m_nGiftRewardNum = 2
			self:showBagGiftInfo()
		end
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	获取射箭任务列表
function WndTeamConsume:_onGetTaskInfo(activityId, activityType, taskType, id, status, target, progress, progressCount, refreshTime, taskGroup)
	if activityId == self.m_nActivityId then 
		local tab = CellNewYearTask:setTaskData(id, status, target, progress, activityId)
		WZLog("WndTeamConsume:_onGetTaskInfo", taskType, taskGroup, Serialize(tab))
		self.m_tTaskData = tab

		self:_createTastList()
	end
end

--@brief 	任务奖励
function WndTeamConsume:_onGetTaskResult(activityId, id)
--	WZLog("WndTeamConsume:_onGetTaskResult", self.m_nActivityId, activityId, id)
	if self.m_nActivityId ~= activityId then
		MsgBoxManager:showTipBox(LocalStrings.RETURNEE_TEXT28)
		return
	end
	
	self:setTeskGetResult(id)
end

function WndTeamConsume:setTeskGetResult(id)
	if self.m_tTaskItemCell then
		for i,v in pairs(self.m_tTaskData) do
			if v and v.id == id then
				self.m_tTaskData[i].status = 2	
				break
			end
		end
		taskTableSort(self.m_tTaskData)
		for i,v in ipairs(self.m_tTaskItemCell) do
			if v then
				v:setTaskItemMessage(i,self.m_tTaskData[i])
			end
		end
	end
end

--@brief	判断我是否队长
function WndTeamConsume:_judgeIsCaptain()
	local bIsCaptain = false 
	if self.m_nCaptainId <= 0 then return bIsCaptain end

	if self.m_nCaptainId == CacheCenter:getPlayerInfo().id then
		bIsCaptain = true 
	end

	return bIsCaptain
end
-------------------------------------私有方法模块End----------------------------------------
CellTeamCTaskItem = {}
function CellTeamCTaskItem:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tGoodItemCell = {}
	self.m_nTaskRewardId = nil
	self.m_nType = nil 
	self.m_bIsLoaded = false 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellTeamCTaskItem:_unInit()
	self.m_root = nil
	self.m_tGoodItemCell = nil 
	self.m_nTaskRewardId = nil
	self.m_nType = nil 
	self.m_bIsLoaded = nil 
end

--@brief	创建控件
function CellTeamCTaskItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(550,112))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end

function CellTeamCTaskItem:setGiftBuyMessage(index, data, nType)
	self.m_nIndex = index
	self.m_tTaskItemData = data
	self.m_nType = nType 
end

--@brief 	开始加载
function CellTeamCTaskItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("CellTeamCTaskItem")
	celElement:setVisible(true)
	element:addChild(celElement)
	self.m_bIsLoaded = true 

	self:setTaskDayDataItem()

	AdaptLanguage(self)
end

function CellTeamCTaskItem:setTaskDayDataItem()
	if not self.m_tTaskItemData then return end
	local data = self.m_tTaskItemData

	self.m_tGoodItemCell = {}
	self:setTaskItemMessage(self.m_nIndex,data)
end
function CellTeamCTaskItem:setTaskItemMessage(index,data)
	--0=不可领取|1=可领取|2=已领取
	self.m_nIndex = index
	self.m_tTaskItemData = data
	if not self.m_bIsLoaded then return end 
	
	GetElement(self.m_root,"btnGoto_CellTeamCTaskItem",WZUIButton):setVisible(data.status == 0)
	GetElement(self.m_root,"btnGet_CellTeamCTaskItem",WZUIButton):setVisible(data.status == 1)
	GetElement(self.m_root,"imgGet_CellTeamCTaskItem",WZUIImage):setVisible(data.status == 2)
	local txtDescTitle = GetElement(self.m_root,"txtDescTitle_CellTeamCTaskItem",WZUILabelTTF)
	local ftxtDescTitle = GetElement(self.m_root, "ftxtDescTitle_CellTeamCTaskItem", WZUIFreeTextBox)
	if string.find(data.desc, "<T") == nil then
		txtDescTitle:setText(data.desc)
	else
		ftxtDescTitle:setShowText(data.desc)
	end

	local imgType = GetElement(self.m_root, "imgType_CellTeamCTaskItem", WZUIImage)
	local txtType = GetElement(self.m_root, "txtType_CellTeamCTaskItem", WZUILabelTTF)
	if data.type == 1 then 
		imgType:setFile("ui/common/common_bq_cq.png")
		txtType:setText(LocalStrings.FOURYEAR_TEXT16)
	elseif data.type == 2 then 
		imgType:setFile("ui/common/common_bq_mr.png")
		txtType:setText(LocalStrings.FOURYEAR_TEXT15)
	end

	self.m_nTaskRewardId = data.id
	for i=1,6 do --最大6个奖励
		if self.m_tGoodItemCell and self.m_tGoodItemCell[i] and self.m_tGoodItemCell[i].celElement then
			self.m_tGoodItemCell[i].celElement:setVisible(false)
		end
	end
	local conGood = GetElement(self.m_root,"conGood_CellTeamCTaskItem",WZUIContainer)
	WZLog("CellTeamCTaskItem:setTaskItemMessage", Serialize(data.ids))
	for i=1, #data.ids do
		local key = "id_"..data.ids[i]
		local tabItem = GDatatab_item[key]
		local num = data.nums[i]
		local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key])}
		if self.m_tGoodItemCell == nil or self.m_tGoodItemCell[i] == nil then
			if self.m_tGoodItemCell == nil then 
				self.m_tGoodItemCell = {}
			end
			local celElement,tLuaObj = CellGoodItem:createElement()
			conGood:addChild(celElement)
			celElement:setScale(0.85)
			celElement:setUseAbsCoordinate(true)
			local tab = {}
			tab.celElement = celElement
			tab.tLuaObj = tLuaObj
			self.m_tGoodItemCell[i] = tab
		end
		if self.m_tGoodItemCell[i] and self.m_tGoodItemCell[i].celElement and self.m_tGoodItemCell[i].tLuaObj then
			local celElement = self.m_tGoodItemCell[i].celElement
			local tLuaObj = self.m_tGoodItemCell[i].tLuaObj
			tLuaObj:setCellGoodItem(itemInfo, 17)
			tLuaObj:setItemClickFun(CellNewYearTask,self.onItemClick)
			local _x = 35 + (i-1) * 85
			celElement:setAbsPosition(GlobalMethod:ccp(_x, 40))
			celElement:setVisible(true)
		end
	end
end
--@brief	点击物品弹出对应的tips
function CellTeamCTaskItem:onItemClick(tCell,tag,tData)
	if tData == nil then
	    return
	end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root, WndTeamConsume.m_root, 1, tData, false, nil, true)
end
function CellTeamCTaskItem:onBtnGoto()
	local data = self.m_tTaskItemData
	if data and data.script and type(data.script) == "table" and data.script[1][1] > 0 then 
		local mainId = data.script[1][1]
		if mainId == 27 then --公会
        	SceneCommunity:onJumpToCommunity()
		elseif mainId == 192 and CacheCenter:getPlayerInfo() and CacheCenter:getPlayerInfo().guildId == 0 then --公会副本
			SceneCommunity:onJumpToCommunity()
		elseif mainId > 0 then
			JumpByUIId(mainId)
		end
		if WndTeamConsume.m_root then 
			WindowManager:removeWindow(WndTeamConsume.m_root, WndTeamConsume, true)
		end
	else
		WindowManager:removeWindow(WndTeamConsume.m_root, WndTeamConsume, true)
	end
end
function CellTeamCTaskItem:onBtnGet()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WZLog("CellTeamCTaskItem:onBtnGet", self.m_tTaskItemData.activityId, self.m_nTaskRewardId)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ReceiveTaskReward(self.m_tTaskItemData.activityId, self.m_nTaskRewardId)
end
--@return	新建的表实例对象
function CellTeamCTaskItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end


--@brief	语言适配
function CellTeamCTaskItem:_adaptLanguage_vn()
	local txtType = GetElement(self.m_root, "txtType_CellTeamCTaskItem", WZUILabelTTF)
	txtType:setScale(0.7)
	txtType:setDimensions(GlobalMethod:CCSize(50,0))
end

----------------------榜单CellItem------------------------------------
CellTeamCRankItem = {}
function CellTeamCRankItem:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nType = 1   					--1:战力飞升；2：新萌榜；3：耀眼榜
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellTeamCRankItem:_unInit()
	self.m_root = nil
	self.m_nType = nil 
end

--@brief	创建控件
function CellTeamCRankItem:createElement()
	local tNewObj = self:_new()
	tNewObj:_init()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(902,82))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end
function CellTeamCRankItem:setFightItemData(data, nType)
	self.m_nFightData = data
	self.m_nType = nType or 1
end
--@brief 	开始加载
function CellTeamCRankItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("CellTeamCRankItem")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:setData()
end

function CellTeamCRankItem:setData()
	if not self.m_nFightData then return end
	local data = self.m_nFightData
	local imgRankIndex = GetElement(self.m_root,"imgRankIndex_CellTeamCRankItem",WZUIImage)
	imgRankIndex:setVisible(false)
	local txtRankIndex = GetElement(self.m_root,"txtRankIndex_CellTeamCRankItem",WZUILabelTTF)
	imgRankIndex:setVisible(false)
	local rank_name = {"ui/common/common_icon_1st_1.png","ui/common/common_icon_2nd_1.png","ui/common/common_icon_3rd_1.png"}
	if tonumber(data.rank_index) <= 3 then
		imgRankIndex:setVisible(true)
		imgRankIndex:setFile(rank_name[tonumber(data.rank_index)])
	else
		txtRankIndex:setVisible(true)
		txtRankIndex:setText(tostring(data.rank_index))
	end
	local img_bg = GetElement(self.m_root,"img_bg_CellTeamCRankItem",WZUI9Image)
	if CacheCenter:getPlayerInfo().id == data.playerId then
   		img_bg:setFile("ui/common/frame_lieb_01.png")
   	else
   		img_bg:setFile("ui/common/frame_lieb_03.png")
   	end

	local txtTeamName = GetElement(self.m_root,"txtTeamName_CellTeamCRankItem",WZUILabelTTF)
	txtTeamName:setText(data.name)
	local tNamePos = {{{0.36, 0.5}}, {{0.36, 0.65}, {0.36, 0.35}}, {{0.36, 0.8}, {0.36, 0.5}, {0.36, 0.2}}}
	local tPos = tNamePos[#data.playerData]
	for i = 1, #data.playerData do
		local txtName = GetElement(self.m_root,"txtName" .. i .. "_CellTeamCRankItem",WZUILabelTTF)
		txtName:setText(data.playerData[i].playerName)
		txtName:setRelativePosition(GlobalMethod:ccp(tPos[i][1], tPos[i][2]))
		if data.playerData.serverId and data.playerData.serverId ~= CacheCenter:getPlayerInfo().serverId then 
			GetElement(self.m_root, "imgKuafu" .. i .. "_CellTeamCRankItem", WZUIImage):setVisible(true)
	   		txtName:setRelativePosition(GlobalMethod:ccp(0.26,0.5))
		end
	end
	GetElement(self.m_root,"txtFight_CellTeamCRankItem",WZUILabelTTF):setText(data.point)

	if data.reward_id then
		for i=1, #data.reward_id do
			local itemInfo = {lastTime=data.reward_num[i],lastNum=data.reward_num[i],basicInfo=CopyTable(GDatatab_item["id_"..data.reward_id[i]])}
			local celElement, tLuaObj = CellGoodItem:createElement()
			self.m_root:addChild(celElement)
			celElement:setScale(0.86)
			celElement:setUseAbsCoordinate(true)

			tLuaObj:setCellGoodItem(itemInfo, 17)
			tLuaObj:setItemClickFun(self,self.onItemClick)
			local _x = 935 - i * 85
			celElement:setAbsPosition(GlobalMethod:ccp(_x, 40))
			celElement:setVisible(true)
		end
	end
end

function CellTeamCRankItem:onBtnHead()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nFightData then
		ProtocolProcessorWndBag:regAll1()
		ProtocolProcessorWndBag:send_PLAYER_GetPlayerInfo(self.m_nFightData.playerId) 
	end
end
function CellTeamCRankItem:onItemClick(tCell,tag,tData)
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
    WZLog("CellTeamCRankItem:onItemClick", self.m_nType)
    local tempRoot = WndTeamConsume.m_root
   	WndItemInfo:showInfo(tCell.m_root, tempRoot, 1, tData, false, nil, true)
end
--@return	新建的表实例对象
function CellTeamCRankItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end