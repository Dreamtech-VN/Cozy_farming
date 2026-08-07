--WndYearPlayerData.lua
--@brief	WndYearPlayer的数据模块
--@date		2022/04/21
--@author	XTX
--@note		年度玩家活动主界面

WndYearPlayer = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndYearPlayer:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_fashionRecommendCost = nil 	
	self.m_nFashionRecommendConfigTime = nil 
	self.m_tPlayerList = nil 
	self.m_signUpCost = nil 		--报名消耗
	self.m_nMaxWordsCount = 10  	--宣言最大字数
	self.m_nTabIndex = 1 			--当前选中的标签1:报名；2海选
	self.m_tPickCell = nil 
	self.m_tPickData = nil 
	self.m_nNum = nil 				--投票数量
	self.m_ncostCount = nil 
	self.m_tCoinId = {70, 1}
	self.m_nCoinIndex = 1 			--默认选中的货币索引
	self.m_tRefreshCost = {70, 66}  --刷新消耗
	self.m_tTaskGrowupData = nil 	--成长任务
	self.m_tTaskDayData = nil 		--日常任务数据
	self.m_nCellCurIndex = 2 	
	self.m_tTaskItemCell = {}	
	self.m_nRefreshCount = 0 		--刷新次数
	self.m_tPickCostConfig = nil 		--投票消耗配置
	self.m_nitemCount = 100 		--一次最大投票数量
	self.m_nRefreshTime = 0 		--定时刷新海选列表
	self.m_nSearchTimes = 10 		--搜索功能显示刷新次数
	self.m_tCellPickList = nil 		--
	self.m_bNeedCleanTable = true 	--是否需要清掉列表
	self.m_bIsFindPlayer = false 	--是否找到相应的玩家
	self.m_nPlayerDayPicCount = 0 	--玩家当天总投票数量
	self.m_tVipLevelConfig = nil 	--vip等级配置
	self.m_tCountLimitConfig = nil 	--根据vip等级限制pick次数
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndYearPlayer:_unInit()
	self.m_root = nil
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_fashionRecommendCost = nil 
	self.m_nFashionRecommendConfigTime = nil 
	self.m_tPlayerList = nil 
	self.m_signUpCost = nil 		--报名消耗
	self.m_nMaxWordsCount = nil   	--宣言最大字数
	self.m_nTabIndex = nil 
	self.m_tPickCell = nil 
	self.m_tPickData = nil 
	self.m_nNum = nil 				--投票数量
	self.m_ncostCount = nil 
	self.m_tCoinId = nil 
	self.m_nCoinIndex = nil 
	self.m_tRefreshCost = nil --刷新消耗
	self.m_tTaskGrowupData = nil 	--成长任务
	self.m_tTaskDayData = nil 		--日常任务数据
	self.m_nCellCurIndex = nil 
	self.m_tTaskItemCell = nil 
	self.m_nRefreshCount = nil 		--刷新次数
	self.m_tPickCostConfig = nil 		--投票消耗配置
	self.m_nitemCount = nil 
	self.m_nRefreshTime = nil 		--定时刷新海选列表
	self.m_nSearchTimes = nil 		--搜索功能显示刷新次数
	self.m_tCellPickList = nil 		--
	self.m_bNeedCleanTable = nil 	--是否需要清掉列表
	self.m_bIsFindPlayer = nil 	--是否找到相应的玩家
	self.m_nPlayerDayPicCount = nil 	--玩家当天总投票数量
	self.m_tVipLevelConfig = nil 	--vip等级配置
	self.m_tCountLimitConfig = nil 	--根据vip等级限制pick次数
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndYearPlayer:createElement()
	if WndYearPlayer.m_root ~= nil then
		WindowManager:removeWindow(WndYearPlayer.m_root, WndYearPlayer, true)
	end
	local element = WZUISystem:getInstance():createElement("WndYearPlayer")
	assert(element, "WndYearPlayer create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndYearPlayer:showInterface()
	LoadNewActivityRes(true)
	local wndWater = WndYearPlayer:createElement()
	if wndWater then 
		WindowManager:addWindow(wndWater, WndYearPlayer, false)
	end
end

--@brief 	获取活动详情成功
function WndYearPlayer:GetActivityInfoOK(activityId,maxCount,count,status, rewardCounts, rewardItems, rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	-- body
	WZLog("WndYearPlayer:GetActivityInfoOK", g_cityExtenInfo.activity7050, activityId, content)
	if g_cityExtenInfo.activity7050 == activityId then 
		self.m_tContent = json.decode(content)
		WZLog("WndYearPlayer:GetActivityInfoOK", count, maxCount, SystemTime:getServerTime(), Serialize(self.m_tContent))
		self.m_nStartTime = startTime 
		self.m_nEndTime = endTime 
		self.m_nActivityId = activityId
		local nRecomTime = maxCount - SystemTime:getServerTime() 
		local isRecomm = 0 
		if nRecomTime > 0 then 
			isRecomm = 1
		end
		self.m_nPlayerDayPicCount = self.m_tContent.playerDayPickCount
		self.m_tVipLevelConfig = self.m_tContent.vipLevel 	--vip等级配置
		self.m_tCountLimitConfig = self.m_tContent.pickLimit 	--根据vip等级限制pick次数

		self:_setConfigData()
		self:_setSignUpData({like = 0, isApply = count, time = nRecomTime, isRecomm = isRecomm})
		self:_update()
	end
end

--@brief 	获取其他活动数据
function WndYearPlayer:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end 

	if doType == 1 then --获取海选列表
		local tResult = json.decode(jsonData)
		WZLog("WndYearPlayer:_onGetOtherData 11", Serialize(tResult))
		self:_setRecommendData(tResult)
	elseif doType == 2 then --刷新投票列表
		local tResult = json.decode(jsonData)
		WZLog("WndYearPlayer:_onGetOtherData 22", Serialize(tResult))
		if result == 1 then 
			self.m_nRefreshCount = tResult.refreshCount
			self:_setFreeBtnText()
		end
	elseif doType == 3 then --pick返回
		local tResult = json.decode(jsonData)
		WZLog("WndYearPlayer:_onGetOtherData 44", Serialize(tResult))
		self:_pickResultBack(result, tResult)
	elseif doType == 4 then --报名成功
		if result == 1 then 
			MsgBoxManager:showTipBox(LocalStrings.CHARM_LIFT17)
			self.m_tMyFashionData.applyState = SystemTime:getServerTime()

			GetElement(self.m_root, "conSingUpAsk_WndYearPlayer", WZUIContainer):setVisible(false)
			local editCircle = GetElement(self.m_root, "editBoxInPutContent_WndYearPlayer", WZUIEditBox)
			editCircle:setText("")
		end
	elseif doType == 5 then --推荐
		local tResult = json.decode(jsonData)
		WZLog("WndYearPlayer:_onGetOtherData 55", Serialize(tResult))
		if result == 1 then 
			MsgBoxManager:showTipBox(LocalStrings.CHARM_LIFT19)
			GetElement(self.m_root, "conRecommendAsk_WndYearPlayer", WZUIContainer):setVisible(false)

			self.m_tMyFashionData.recommendTime = tResult.recommendEndTime - SystemTime:getServerTime() 
			if self.m_tMyFashionData.recommendTime > 0 then 
				self.m_tMyFashionData.recommendState = 1
				GetElement(self.m_root, "conSignUp_WndYearPlayer", WZUIContainer):enableSchedule("_setTimeCaculate", 1)
			end
			self:_showLeftRecommendTime()
			if self.m_tMyRole then 
				self.m_tMyRole[2]:setData2(self.m_tMyFashionData, 0)
			end
		end
	elseif doType == 6 then --搜索
		local tResult = json.decode(jsonData)
		if result == 1 then 
			self.m_bIsFindPlayer = true 
			self:_setRecommendData(tResult)
			return 
		elseif result == 3 then 
			self.m_bNeedCleanTable = false 
			MsgBoxManager:showTipBox(LocalStrings.YEARPLAYER_TEXT1[19])
		else
			self.m_bNeedCleanTable = false
		end
		self.m_bIsFindPlayer = false 
	end
end

--@brief 	获取射箭任务列表
function WndYearPlayer:_onGetTaskInfo(activityId, activityType, taskType, id, status, target, progress, progressCount, refreshTime, taskGroup)
	if activityId == self.m_nActivityId then 
		local tab = CellNewYearTask:setTaskData(id, status, target, progress, activityId)
		WZLog("WndYearPlayer:_onGetTaskInfo", taskType, taskGroup, Serialize(tab))
		if taskType == 1 then
			self.m_tTaskGrowupData= tab
			self:_showTaskContent(2)
			self.m_nCellCurIndex = 1
		elseif taskType == 2 then
			self.m_tTaskDayData = tab
			self:_showTaskContent(1)
			self.m_nCellCurIndex = 2
		end
	end
end

--@brief 	射箭任务奖励
function WndYearPlayer:_onGetTaskResult(activityId, id)
--	WZLog("WndYearPlayer:_onGetTaskResult", self.m_nActivityId, activityId, id)
	if self.m_nActivityId ~= activityId then
		MsgBoxManager:showTipBox(LocalStrings.RETURNEE_TEXT28)
		return
	end
	
	self:setTeskGetResult(id)
end

--@brief 	更新任务数据
function WndYearPlayer:setTeskGetResult(id)
	local taskData = GDatatab_new_activity_task["id_" .. id]
	if self.m_tTaskItemCell then
		local tTaskData = nil 
		if taskData and taskData.type == 2 then
			for i,v in pairs(self.m_tTaskDayData) do
				if v and v.id == id then
					self.m_tTaskDayData[i].status = 2	
					break
				end
			end
			taskTableSort(self.m_tTaskDayData)
			tTaskData = self.m_tTaskDayData
			local imageDayRedPoint = GetElement(self.m_root, "imageDayRedPoint_WndYearPlayer", WZUIImage)
			self:setRedPoint(imageDayRedPoint, tTaskData, taskData.type)
		elseif taskData and taskData.type == 1 then
			for i,v in pairs(self.m_tTaskGrowupData) do
				if v and v.id == id then
					self.m_tTaskGrowupData[i].status = 2	
					break
				end
			end
			taskTableSort(self.m_tTaskGrowupData)
			tTaskData = self.m_tTaskGrowupData
			local imageGrowupRedPoint = GetElement(self.m_root, "imageGrowupRedPoint_WndYearPlayer", WZUIImage)
			self:setRedPoint(imageGrowupRedPoint, tTaskData, taskData.type)
		end
		self:showRedDot()
		for i,v in ipairs(self.m_tTaskItemCell) do
			if v then
				v:setTaskItemMessage(i, tTaskData[i])
			end
		end
	end
end

--@brief 	红点
function WndYearPlayer:setRedPoint(node, data, nType)
	if not node then return end
	
	local status = false
	data = data 
	local tTypeList = {127050, 117050}
	if data then
		for i,v in pairs(data) do
			if v.status == 1 then
				status = true
				break
			end
		end
		if node then
			node:setVisible(status)
			GlobalGame.g_tRedPointTypeList[nType] = status
			return
		end
	end

	GlobalGame.g_tRedPointTypeList[nType] = false
	node:setVisible(status)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	设置报名界面数据
function WndYearPlayer:_setSignUpData(tResult)
	self.m_tMyFashionData = {}
	local headColor, bodyColor = CacheCenter:getHeadAndBodyColor()
	local tEquip = CacheCenter:getEquipmentList()
	local playerInfo = CacheCenter:getPlayerInfo()
	local headId, faceId, bodyId, wingId = nil, nil, nil, nil
	if tEquip then 
		for i = 1, #tEquip do 
			local basicData = GDatatab_item["id_" .. tEquip[i].id]
			if basicData then 
				if basicData.main_type == 5 and basicData.sub_type == 0 then 
					headId = tEquip[i].id
				elseif basicData.main_type == 5 and basicData.sub_type == 1 then 
					faceId = tEquip[i].id
				elseif basicData.main_type == 5 and basicData.sub_type == 2 then 
					bodyId = tEquip[i].id
				elseif basicData.main_type == 5 and basicData.sub_type == 3 then 
					wingId = tEquip[i].id
				end
			end
		end
	end

	self.m_tMyFashionData.id = playerInfo.id
	self.m_tMyFashionData.playerName = playerInfo.name
	self.m_tMyFashionData.level = playerInfo.level
	self.m_tMyFashionData.headId = headId or 0
	self.m_tMyFashionData.faceId = faceId or 0
	self.m_tMyFashionData.bodyId = bodyId or 0
	self.m_tMyFashionData.wingId = wingId or 0
	self.m_tMyFashionData.headColor = headColor
	self.m_tMyFashionData.bodyColor = bodyColor
	self.m_tMyFashionData.sex = playerInfo.sex
	self.m_tMyFashionData.goodNum = tResult.like
	self.m_tMyFashionData.applyState = tResult.isApply
	self.m_tMyFashionData.recommendTime = tResult.time
	self.m_tMyFashionData.recommendState = tResult.isRecomm

	self:_showMyFashionInfo()
end

--@brief 	设置海选界面数据
function WndYearPlayer:_setRecommendData(tResult)
	self.m_tPlayerList = {}
	local nCurTime = SystemTime:getServerTime() 

	for i = 1, #tResult.pick do
		local tItem = {}
		tItem.id = tResult.playerId[i]
		tItem.playerName = tResult.nickname[i]
		tItem.level = tResult.level[i]
		tItem.vipLevel = tResult.vipLevel[i]
		tItem.headId = tResult.headId[i]
		tItem.faceId = tResult.faceId[i]
		tItem.serverId = tResult.serverId[i]
		tItem.headColor = tResult.headColor[i]
		tItem.sex = tResult.sex[i]
		tItem.declaration = tResult.declaration[i]
		tItem.goodNum = tResult.pick[i]
		tItem.recommendTime = tResult.recommendEndTime[i] - nCurTime
		tItem.recommendState = tItem.recommendTime > 0 and 1 or 0
		tItem.headEffectId = tResult.profileFrame[i]

		table.insert(self.m_tPlayerList, tItem)
	end

	self:_showRecommendList()
end

--@brief 	投票成功处理
function WndYearPlayer:_pickResultBack(result, tResult)
	if result == 1 then 
		self.m_nPlayerDayPicCount = tResult.playerDayPickCount
		if self.m_tPickData and tResult.playerId == self.m_tPickData.id then 
			if self.m_tPickCell then 
				self:_showTalk(tResult.pickAdd)
				self.m_tPickData.goodNum = tResult.pickNum
				self.m_tPickCell:updatePickNum(self.m_tPickData)
				
				GetElement(self.m_root, "conPickAsk_WndYearPlayer", WZUIContainer):setVisible(false)
				self.m_tPickData = nil
				self.m_tPickCell = nil
			end
		end
	elseif result == 5 then 
		MsgBoxManager:showConfirmBox(LocalStrings.YEARPLAYER_TEXT1[20], self, self.sureToRecharge)
	end
end

--@brief 	设置配置消耗数据
function WndYearPlayer:_setConfigData()
	self.m_signUpCost = self.m_tContent.joinCost

	self.m_fashionRecommendCost = self.m_tContent.recommendCost
	self.m_nFashionRecommendConfigTime = self.m_tContent.recommendTime

	self.m_tRefreshCost = self.m_tContent.refreshCost
	self.m_nRefreshCount = self.m_tContent.refreshCount

	self.m_tCoinId = {}
	self.m_tPickCostConfig = {}
	local tItem = {}
	
	tItem[1] = self.m_tContent.pick[1]
	tItem[2] = self.m_tContent.pick[2]
	tItem[3] = self.m_tContent.pick[3]
	self.m_tCoinId[1] = self.m_tContent.pick[1]
	self.m_tPickCostConfig[1] = tItem

	local tItem1 = {}
	tItem1[1] = self.m_tContent.pick[4]
	tItem1[2] = self.m_tContent.pick[5]
	tItem1[3] = self.m_tContent.pick[6]
	self.m_tCoinId[2] = self.m_tContent.pick[4]
	self.m_tPickCostConfig[2] = tItem1

	self.m_ncostCount = self.m_tPickCostConfig[self.m_nCoinIndex][2]
	local moneyList = CacheCenter:getMoneyList()
	local moneyNum = 0
	if self.m_tPickCostConfig[self.m_nCoinIndex][1] == 70 then 
		moneyNum = moneyList.ticket
	elseif self.m_tPickCostConfig[self.m_nCoinIndex][1] == 1 then 
		moneyNum = moneyList.blueDiamond
	end
	local nTempNum = math.floor(moneyNum/self.m_ncostCount)
	local limitCount = self:_getPickLimit()
	local nLeftCount = limitCount - self.m_nPlayerDayPicCount
	WZLog("WndYearPlayer:_setConfigData", nLeftCount, nTempNum)
	if nLeftCount > 0 and nTempNum > nLeftCount then 
		nTempNum = nLeftCount
	end
	self.m_nitemCount = nTempNum > 0 and nTempNum or 1

	local ftxtSignCost = GetElement(self.m_root, "ftxtSignCost_WndYearPlayer", WZUIFreeTextBox)
	local costData = GDatatab_item["id_" .. self.m_signUpCost[1]]
	local strContent = string.format(LocalStrings.YEARPLAYER_TEXT1[15], self.m_signUpCost[2], costData.icon)
	ftxtSignCost:setShowText(strContent)
end

--@brief 	根据vip等级获取pick上限
function WndYearPlayer:_getPickLimit()
	local playerInfo = CacheCenter:getPlayerInfo()
	local limitCount = 0 
	local maxVipLevel = 0 
	local nVipMin = 0
	for i = 1, #self.m_tVipLevelConfig do
		local nVipMin = 0
		if i > 1 then 
			nVipMin = self.m_tVipLevelConfig[i - 1]
		end
		
		if playerInfo.vipLevel >= nVipMin and playerInfo.vipLevel < self.m_tVipLevelConfig[i] then 
			limitCount = self.m_tCountLimitConfig[i]
		end
		if self.m_tVipLevelConfig[i] > maxVipLevel then 
			maxVipLevel = self.m_tVipLevelConfig[i]
		end
 	end

 	if playerInfo.vipLevel >= maxVipLevel then 
 		limitCount = -1
 	end

 	return limitCount 
end
-------------------------------------私有方法模块End----------------------------------------
CellPickItem = {}

function CellPickItem:_init()
	self.m_root = nil 
	self.m_tData = nil 
	self.m_bIsLoaded = false 
end

function CellPickItem:_unInit()
	self.m_root = nil 
	self.m_tData = nil 
	self.m_bIsLoaded = nil  
end

function CellPickItem:createElement()
	-- body
	local tNewObj = self:_new()
	tNewObj:_init()

	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setName("__CellPickItem")
	element:setAbsContentSize(GlobalMethod:CCSize(160,250))
	element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end

function CellPickItem:onEnter(element)
	-- body
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellPickItem:onExit(element)
	self:_unInit()
end

--@brief 	点击！按钮回调
function CellPickItem:onClickTip(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local tData = {}
	tData.txtTitle = self.m_tData.declaration
	tData.nType = 2
	WndTips:show(element, WndYearPlayer.m_root, 52, tData, GlobalMethod:ccp(250,80), true)
end

--@brief 	点击pick按钮回调
function CellPickItem:onClickPick(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_tData.id == CacheCenter:getPlayerInfo().id then 
		MsgBoxManager:showTipBox(LocalStrings.YEARPLAYER_TEXT1[17])
		return
	end
	WndYearPlayer:clickPickCallBack(self, self.m_tData)
end

--@brief 	显示玩家信息
function CellPickItem:onClickHead(element)
	-- body
	WndCheckOther:show(self.m_tData.id)
end

function CellPickItem:_new()
	-- body
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self

	return tNewObj
end

function CellPickItem:setData(tData)
	-- body
	self.m_tData = tData
end

function CellPickItem:updateData(tData)
	-- body
	self.m_tData = tData
	if self.m_bIsLoaded == false then return end 

	self:_update()
end

function CellPickItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("CellPickItem_WndYearPlayer")
	celElement:setVisible(true)

	self.m_root:addChild(celElement)
	self.m_bIsLoaded = true 

	self:_update()
end

function CellPickItem:_update()
	-- body
	GetElement(self.m_root, "txtBtnPick_CellPickItem", WZUILabelTTF):setText(LocalStrings.YEARPLAYER_TEXT1[5])
	
	local txtPlayerName = GetElement(self.m_root, "txtPlayerName_CellPickItem", WZUILabelTTF)
	txtPlayerName:setText(self.m_tData.playerName)
	local txtGoodNum = GetElement(self.m_root, "txtGoodNum_CellPickItem", WZUILabelTTF)
	txtGoodNum:setText(self.m_tData.goodNum)
	--玩家头像
	local conHead = GetElement(self.m_root, "conHead_CellPickItem", WZUIContainer)
	local headElement = CellHead:show(conHead, self.m_tData.headId, self.m_tData.faceId, self.m_tData.sex, false, nil, self.m_tData.vipLevel, self.m_tData.headColor)
	local imgRecommend = GetElement(self.m_root, "imgRecommend_CellPickItem", WZUIImage)
	if self.m_tData.recommendState == 1 then 
		imgRecommend:setVisible(true)
	else
		imgRecommend:setVisible(false)
	end
end

--@brief 	更新获得的投票数
function CellPickItem:updatePickNum(tData)
	self.m_tData = tData
	if self.m_bIsLoaded == false then return end 

	local txtGoodNum = GetElement(self.m_root, "txtGoodNum_CellPickItem", WZUILabelTTF)
	txtGoodNum:setText(self.m_tData.goodNum)
end

--================== 任务子项 ========================
CellYearPlayerTask = {}
function CellYearPlayerTask:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tGoodItemCell = {}
	self.m_nTaskRewardId = nil
	self.m_bIsLoaded = false 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellYearPlayerTask:_unInit()
	self.m_root = nil
	self.m_tGoodItemCell = nil 
	self.m_nTaskRewardId = nil
	self.m_bIsLoaded = nil 
end

--@brief	创建控件
function CellYearPlayerTask:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(658,112))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end

function CellYearPlayerTask:setGiftBuyMessage(index, data)
	self.m_nIndex = index
	self.m_tTaskItemData = data
end

--@brief 	开始加载
function CellYearPlayerTask:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("CellYearPlayerTask")
	celElement:setVisible(true)
	element:addChild(celElement)
	self.m_bIsLoaded = true 

	self:setTaskDayDataItem()
end

function CellYearPlayerTask:setTaskDayDataItem()
	if not self.m_tTaskItemData then return end
	local data = self.m_tTaskItemData

	self.m_tGoodItemCell[self.m_nIndex] = {}
	self:setTaskItemMessage(self.m_nIndex,data)
end
function CellYearPlayerTask:setTaskItemMessage(index,data)
	--0=不可领取|1=可领取|2=已领取
	self.m_nIndex = index
	self.m_tTaskItemData = data
	if not self.m_bIsLoaded then return end 
	
	GetElement(self.m_root,"btnGoto_CellYearPlayerTask",WZUIButton):setVisible(data.status == 0)
	GetElement(self.m_root,"btnGet_CellYearPlayerTask",WZUIButton):setVisible(data.status == 1)
	GetElement(self.m_root,"imgGet_CellYearPlayerTask",WZUIImage):setVisible(data.status == 2)
	local txtDescTitle = GetElement(self.m_root,"txtDescTitle_CellYearPlayerTask",WZUILabelTTF)
	local ftxtDescTitle = GetElement(self.m_root, "ftxtDescTitle_CellYearPlayerTask", WZUIFreeTextBox)
	if string.find(data.desc, "<T") == nil then
		txtDescTitle:setText(data.desc)
	else
		ftxtDescTitle:setShowText(data.desc)
	end

	self.m_nTaskRewardId = data.id
	for i=1,6 do --最大6个奖励
		if self.m_tGoodItemCell[index] and self.m_tGoodItemCell[index][i] and self.m_tGoodItemCell[index][i].celElement then
			self.m_tGoodItemCell[index][i].celElement:setVisible(false)
		end
	end
	local good_con = GetElement(self.m_root,"conGood_CellYearPlayerTask",WZUIContainer)
	WZLog("CellYearPlayerTask:setTaskItemMessage", Serialize(data.ids))
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
			celElement:setScale(0.85)
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
			tLuaObj:setItemClickFun(WndYearPlayer,WndYearPlayer.onItemClick)
			local _x = 35 + (i-1) * 85
			celElement:setAbsPosition(GlobalMethod:ccp(_x, 40))
			celElement:setVisible(true)
		end
	end
end
--@brief	点击物品弹出对应的tips
function WndYearPlayer:onItemClick(tCell,tag,tData)
    if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,WndYearPlayer.m_root,1,tData,false,nil,true)
end
function CellYearPlayerTask:onBtnGoto()
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
	else
		GetElement(WndYearPlayer.m_root, "cbgTool_WndYearPlayer", WZUICheckBoxGroup):setCheckIndex(1)
		WndYearPlayer:_showTabContent(2)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(WndYearPlayer.m_nActivityId, 1, "")
	end
end
function CellYearPlayerTask:onBtnGet()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WZLog("CellYearPlayerTask:onBtnGet", self.m_tTaskItemData.activityId, self.m_nTaskRewardId)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ReceiveTaskReward(self.m_tTaskItemData.activityId, self.m_nTaskRewardId)
end
--@return	新建的表实例对象
function CellYearPlayerTask:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end