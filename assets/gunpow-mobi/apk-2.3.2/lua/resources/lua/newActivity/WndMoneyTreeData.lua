--WndMoneyTreeData.lua
--@brief	WndMoneyTree的数据模块
--@date		2022/07/21
--@author	XTX
--@note		摇钱树活动

WndMoneyTree = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndMoneyTree:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tContent = nil 
	self.m_nStartTime = nil  
	self.m_nEndTime = nil  
	self.m_nActivityId = nil 
	self.m_tCoinList = {{1,50000},{70,200000},{2,500000000}}
	self.m_nTabIndex = 1 			--1=摇钱树；2=排行榜；3=收益图
	self.m_tTaskData = nil 			--任务数据
	self.m_tTaskItemCell = nil 
	self.m_nCoinId = 160306
	self.m_nCoinId2 = 160307
	self.m_nMaxOpTimes = 10 
	self.m_bOpenState = false 
	self.m_nShakeIndex = 1 			--摇1次；大力摇
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndMoneyTree:_unInit()
	self.m_root = nil
	self.m_tContent = nil 
	self.m_nStartTime = nil  
	self.m_nEndTime = nil  
	self.m_nActivityId = nil 
	self.m_tCoinList = nil 
	self.m_nTabIndex = nil 
	self.m_tTaskData = nil 			--任务数据
	self.m_tTaskItemCell = nil 
	self.m_nCoinId = nil 
	self.m_nCoinId2 = nil 
	self.m_nMaxOpTimes = nil 
	self.m_bOpenState = nil 
	self.m_nShakeIndex = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndMoneyTree:createElement()
	if WndMoneyTree.m_root ~= nil then
		WindowManager:removeWindow(WndMoneyTree.m_root, WndMoneyTree, true)
	end
	local element = WZUISystem:getInstance():createElement("WndMoneyTree")
	assert(element, "WndMoneyTree create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndMoneyTree:showInterface()
	LoadNewActivityRes(true)
	local wndWater = WndMoneyTree:createElement()
	if wndWater then 
		WindowManager:addWindow(wndWater, WndMoneyTree, false)
	end
end

--@brief 	获取活动详情成功
function WndMoneyTree:GetActivityInfoOK(activityId,maxCount,count,status, rewardCounts, rewardItems, rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	-- body
	WZLog("WndMoneyTree:GetActivityInfoOK", g_cityExtenInfo.activity7054, activityId, content)
	if g_cityExtenInfo.activity7054 == activityId then 
		self.m_tContent = json.decode(content)
		self.m_nStartTime = startTime 
		self.m_nEndTime = endTime 
		self.m_nActivityId = activityId

		self:_update()
	end
end

--@brief 	获取其他活动数据
function WndMoneyTree:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end 

	if doType == 1 then --收益信息 
		local tResult = json.decode(jsonData)
		WZLog("WndMoneyTree:_onGetOtherData 111", Serialize(tResult))
		self:_showIncomeChart(tResult.earning)
		self:setOpenState(false)
	elseif doType == 3 then --开启结果
		local tResult = json.decode(jsonData)
		WZLog("WndMoneyTree:_onGetOtherData 333", Serialize(tResult))
		self.m_tOpenResult = {}

		self.m_tOpenResult.normalRewards = {} --常规奖
		self.m_tOpenResult.normalRewards.itemIds = tResult.itemIds
		self.m_tOpenResult.normalRewards.itemNums = tResult.itemNums

		if result == 1 then 
			self:showOpenAction()
		else
			self:setOpenState(false)
		end
	end
end

--@brief	缓存推送更新物品时调用的函数
function WndMoneyTree:updatePlayerItemData()
	WZLog("WndMoneyTree:updatePlayerItemData")
	if self.m_root ~= nil then
		self:_updateLightNum()
	end
end

--@brief 	设置射箭的状态
function WndMoneyTree:setOpenState(state)
	-- body
	if self.m_root == nil then return end 

	self.m_bOpenState = state
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndMoneyTree:_onRankResult(activityId, activityType, rankingType, myPoint, myRanking, rewardConfig, playerIds, ranks, points, nickname, headIds, 
								   headColors, faceIds, sexs, vipLevel, level, bodyIds, wingIds, title, serverId, session, settlementDate)
	self:setRankListData(activityId,myPoint,rewardConfig,playerIds,level,points,nickname,faceIds,headIds, headColors, sexs, title, vipLevel, rankingType, 
		myRanking, serverId, session, settlementDate)
end

function WndMoneyTree:setRankListData(activityId,myPoint,rewardConfig,playerIds,level,points,nickname,faceIds,headIds, headColors, sexs, title, vipLevel, 
	rankingType, myRanking, serverId, session, settlementDate)
	if activityId == self.m_nActivityId then
		if self.m_nTabIndex ~= 2 then return end 

		local flRank = GetElement(self.m_root, "flRank_WndMoneyTree", WZUIFreeListContainer)
		flRank:removeAll()
		local conContent2 = GetElement(self.m_root, "conContent2_WndMoneyTree", WZUIContainer)
		local txtMyRank = GetElement(self.m_root, "txtMyRank_WndMoneyTree", WZUILabelTTF)
		local txtMyTimes = GetElement(self.m_root, "txtMyTimes_WndMoneyTree", WZUILabelTTF)
		if not rewardConfig or rewardConfig == "" then
			ShowPanelNullTip(conContent2, LocalStrings.CHARM_RESULT, nil, nil, nil, GlobalMethod:ccp(0.58, 0.5))

			txtMyRank:setText(LocalStrings.NOT_IN_RANKLIST)
			txtMyTimes:setText(0)
			return
		end

		rewardConfig = json.decode(rewardConfig)
		if not rewardConfig then return end
		WZLog("WndMoneyTree:setRankListData", Serialize(rewardConfig))
		if next(playerIds) == nil then
			ShowPanelNullTip(conContent2, LocalStrings.CHARM_RESULT, nil, nil, nil, GlobalMethod:ccp(0.58, 0.5))
			txtMyRank:setText(LocalStrings.NOT_IN_RANKLIST)
			if myPoint < 0 then myPoint = 0 end
			txtMyTimes:setText(myPoint)
			return
		end

		local tData, myCurRank = WndShopRank:setRankData(rewardConfig, playerIds, level, points, nickname, faceIds, headIds, headColors, sexs, nil, nil, title, vipLevel, 29, rankingType, serverId)

		removeShowPanelNullTip(conContent2)
		self:_showRank(myCurRank, myPoint, tData)
	end
end

--@brief 	获取任务列表
function WndMoneyTree:_onGetTaskInfo(activityId, activityType, taskType, id, status, target, progress, progressCount, refreshTime, taskGroup)
	if activityId == g_cityExtenInfo.activity7054 then 
		local tab = CellNewYearTask:setTaskData(id, status, target, progress, activityId)
		WZLog("WndMoneyTree:_onGetTaskInfo", taskType, taskGroup, Serialize(tab))

		self.m_tTaskData = tab
		taskTableSort(self.m_tTaskData)
		self:_showTaskContent()
	end
end

--@brief 	领取任务奖励
function WndMoneyTree:_onGetTaskResult(activityId, id)
--	WZLog("CellNewYearTask:_onGetTaskResult", self.m_nActivityId, activityId, id)
	if self.m_nActivityId ~= activityId then
		MsgBoxManager:showTipBox(LocalStrings.RETURNEE_TEXT28)
		return
	end
	
	local taskData = GDatatab_new_activity_task["id_" .. id]

	self:setTeskGetResult(id)
end

function WndMoneyTree:setTeskGetResult(id)
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
-------------------------------------私有方法模块End----------------------------------------
CellMoneyTreeTask = {}
function CellMoneyTreeTask:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tGoodItemCell = {}
	self.m_nTaskRewardId = nil
	self.m_bIsLoaded = false 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellMoneyTreeTask:_unInit()
	self.m_root = nil
	self.m_tGoodItemCell = nil 
	self.m_nTaskRewardId = nil
	self.m_bIsLoaded = nil 
end

--@brief	创建控件
function CellMoneyTreeTask:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(328,94))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end

function CellMoneyTreeTask:setGiftBuyMessage(index, data)
	self.m_nIndex = index
	self.m_tTaskItemData = data
end

--@brief 	开始加载
function CellMoneyTreeTask:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("CellMoneyTreeTask")
	celElement:setVisible(true)
	element:addChild(celElement)
	self.m_bIsLoaded = true 

	self:setTaskDayDataItem()
end

function CellMoneyTreeTask:setTaskDayDataItem()
	if not self.m_tTaskItemData then return end
	local data = self.m_tTaskItemData

	self.m_tGoodItemCell[self.m_nIndex] = {}
	self:setTaskItemMessage(self.m_nIndex,data)
end

function CellMoneyTreeTask:setTaskItemMessage(index,data)
	--0=不可领取|1=可领取|2=已领取
	self.m_nIndex = index
	self.m_tTaskItemData = data
	if not self.m_bIsLoaded then return end 

	GetElement(self.m_root,"btnGoto_CellMoneyTreeTask",WZUIButton):setVisible(false)
	GetElement(self.m_root,"btnGet_CellMoneyTreeTask",WZUIButton):setVisible(data.status == 1)
	GetElement(self.m_root,"imgGet_CellMoneyTreeTask",WZUIImage):setVisible(data.status == 2)
	local txtDescTitle = GetElement(self.m_root,"txtDescTitle_CellMoneyTreeTask",WZUILabelTTF)
	local ftxtDescTitle = GetElement(self.m_root, "ftxtDescTitle_CellMoneyTreeTask", WZUIFreeTextBox)
	if string.find(data.desc, "<T") == nil then
		txtDescTitle:setText(data.desc)
	else
		ftxtDescTitle:setShowText(data.desc)
	end

	self.m_nTaskRewardId = data.id
	for i = 1, 6 do --最大6个奖励
		if self.m_tGoodItemCell[index] and self.m_tGoodItemCell[index][i] and self.m_tGoodItemCell[index][i].celElement then
			self.m_tGoodItemCell[index][i].celElement:setVisible(false)
		end
	end
	local good_con = GetElement(self.m_root,"good_con_CellMoneyTreeTask",WZUIContainer)
	WZLog("CellMoneyTreeTask:setTaskItemMessage", Serialize(data.ids))
	for i=1, #data.ids do
		local key = "id_"..data.ids[i]
		local tabItem = GDatatab_item[key]
		local num = data.nums[i]
		local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key])}
		if self.m_tGoodItemCell[index] == nil or self.m_tGoodItemCell[index][i] == nil then
			if self.m_tGoodItemCell[index] == nil then 
				self.m_tGoodItemCell[index] = {}
			end
			local celElement,tLuaObj = CellGoodItem:createElement()
			good_con:addChild(celElement)
			celElement:setScale(0.6)
			celElement:setUseAbsCoordinate(true)
			local tab = {}
			tab.celElement = celElement
			tab.tLuaObj = tLuaObj
			self.m_tGoodItemCell[index][i] = tab
		end
		if self.m_tGoodItemCell[index][i] and self.m_tGoodItemCell[index][i].celElement and self.m_tGoodItemCell[index][i].tLuaObj then
			local celElement = self.m_tGoodItemCell[index][i].celElement
			local tLuaObj = self.m_tGoodItemCell[index][i].tLuaObj
			tLuaObj:setCellGoodItem(itemInfo, 17)
			tLuaObj:setItemClickFun(WndMoneyTree, WndMoneyTree.onClickItem)
			local _x = 35 + (i-1) * 60
			celElement:setAbsPosition(GlobalMethod:ccp(_x, 30))
			celElement:setVisible(true)
		end
	end
end

function CellMoneyTreeTask:onBtnGoto()
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
	end
end

function CellMoneyTreeTask:onBtnGet()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WZLog("CellMoneyTreeTask:onBtnGet", self.m_tTaskItemData.activityId, self.m_nTaskRewardId)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ReceiveTaskReward(self.m_tTaskItemData.activityId, self.m_nTaskRewardId)
end

--@return	新建的表实例对象
function CellMoneyTreeTask:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end