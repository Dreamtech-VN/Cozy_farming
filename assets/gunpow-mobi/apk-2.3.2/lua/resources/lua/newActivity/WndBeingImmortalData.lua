--WndBeingImmortalData.lua
--@brief	WndBeingImmortal的数据模块
--@date		2022/12/01
--@author	XTX
--@note		修仙传活动

WndBeingImmortal = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndBeingImmortal:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_tBigRewardList = nil 		--大奖和特奖奖励
	self.m_bOpenState = false 
	self.m_tOpenResult = nil 
	self.m_nCoinId = 160369
	self.m_nCurExp = 0 
	self.m_tLvRewardList = nil 			--捕鼠奖励列表
	self.m_nCurLevel = 0 				--当前等级
	self.m_nMaxLotteryCount = 20    --最大抽奖次数
	self.m_tBallAniName = {"wait1", "wait2", "wait3", "wait4", "wait5"}
	self.m_nCurMapId = 1 			--底图索引
	self.m_nCurMapExp = 0
	self.m_nCurMapTargetExp = 0
	self.m_tMapConfig = nil 	--地图配置
	self.m_tLvCell = nil 
	self.m_tAllMapId = nil 
	self.m_tAllMapExp = nil 
	self.m_tFightPos = {GlobalMethod:ccp(0.272,0.28), GlobalMethod:ccp(0.567,0.436), GlobalMethod:ccp(0.214,0.63), GlobalMethod:ccp(0.88,0.31), GlobalMethod:ccp(0.64,0.754)}
	self.m_nChooseReward = 0 		--选择奖励状态0：弹出预览界面；1：不弹
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndBeingImmortal:_unInit()
	self.m_root = nil
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_tBigRewardList = nil 		--大奖和特奖奖励
	self.m_bOpenState = false 
	self.m_tOpenResult = nil 
	self.m_nCoinId = nil 
	self.m_nCurExp = nil  
	self.m_tLvRewardList = nil 			--捕鼠奖励列表
	self.m_nCurLevel = nil 				--当前等级
	self.m_nMaxLotteryCount = nil    --最大抽奖次数
	self.m_tBallAniName = nil 
	self.m_nCurMapId = nil 			--底图索引
	self.m_nCurMapExp = nil 
	self.m_nCurMapTargetExp = nil 
	self.m_tMapConfig = nil 	--地图配置
	self.m_tLvCell = nil 
	self.m_tAllMapId = nil 
	self.m_tAllMapExp = nil 
	self.m_tFightPos = nil 
	self.m_nChooseReward = nil 		--选择奖励状态0：弹出预览界面；1：不弹
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndBeingImmortal:createElement()
	if WndBeingImmortal.m_root ~= nil then
		WindowManager:removeWindow(WndBeingImmortal.m_root, WndBeingImmortal, true)
	end
	local element = WZUISystem:getInstance():createElement("WndBeingImmortal")
	assert(element, "WndBeingImmortal create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndBeingImmortal:showInterface()
	LoadNewActivityRes(true)
	local wndWater = WndBeingImmortal:createElement()
	if wndWater then 
		WindowManager:addWindow(wndWater, WndBeingImmortal, false)
	end
end

--@brief 	获取活动详情成功
function WndBeingImmortal:GetActivityInfoOK(activityId,maxCount,count,status, rewardCounts, rewardItems, rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	-- body
	WZLog("WndBeingImmortal:GetActivityInfoOK", g_cityExtenInfo.activity7061, Serialize(finishCondition), content)
	if g_cityExtenInfo.activity7061== activityId then 
		self.m_tContent = json.decode(content)
		self.m_nStartTime = startTime 
		self.m_nEndTime = endTime 
		self.m_nActivityId = activityId

		self.m_nCurLevel = finishCondition[1] 
		self.m_nCurExp = finishCondition[2] 
		self.m_nCurMapId = finishCondition[3]
		self.m_nCurMapExp = finishCondition[4]
		self:_setMagConfigData()
		self.m_nCurMapTargetExp = self:_getMagTarget(self.m_nCurMapId) 
		self.m_nChooseReward = GetOperateTimes("BEINGIMMORTALACTIVITYID", self.m_nActivityId) 

		self:_analyzeBigReward()
		self:_update()
	end
end

--@brief 	获取其他活动数据
function WndBeingImmortal:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end 

	if doType == 3 then --开启结果
		local tResult = json.decode(jsonData)
		WZLog("WndBeingImmortal:_onGetOtherData 333", Serialize(tResult))
		self.m_tOpenResult = {}

		self.m_tOpenResult.normalRewards = {} --常规奖
		self.m_tOpenResult.firstRewards = {} --初级奖
		self.m_tOpenResult.bigRewards = {} --大奖奖
		self.m_tOpenResult.runRewards = {} --额外获得的丹药

		local rewardType = 8 
		for i = 1, #tResult.itemNums do
			local tItem = {}
			tItem.itemId = tResult.itemIds[i]
			tItem.itemNum = tResult.itemNums[i]
			tItem.type = rewardType
			tItem.imgRewardTitle = "ui/newActivity/bt_text_gxhd_2.png"
			tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
			table.insert(self.m_tOpenResult.normalRewards, tItem)
		end

		--大奖
		local bigRewardType = 26 
		local strTitleFormat = [[<T C="255,255,255" S="46" P="1" SC="222,78,0" SS="4" SE="1">%s</T><T C="249,255,0" S="46" P="1" SC="222,78,0" SS="4" SE="1">%s</T>]]
		if tResult.fItemIds then 
			for j = 1, #tResult.fItemIds do
				local tItem = {}

				tItem.itemId = tResult.fItemIds[j]
				tItem.itemNum = tResult.fItemNums[j]
				tItem.type = bigRewardType
				tItem.imgRewardTitle = "ui/newActivity/bt_text_xxz_xlcjj.png"
				tItem.imgBK = "ui/specialBg/hd_pic_xxz_xlcjj.png"
			--	tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
				tItem.goodsconPt = GlobalMethod:ccp(0.5, 0.5)
				tItem.strTitle = string.format(strTitleFormat, LocalStrings.BEINGIMMORTAL_TEXT1[9], LocalStrings.BEINGIMMORTAL_TEXT1[10])
				tItem.spineEffect = {path = "activity/ui_xiuxian_cj", _sIndex = "ui_xiuxian_cj", play = "wait1"}

				table.insert(self.m_tOpenResult.firstRewards, tItem)
			end
		end
		--特奖
		for j = 1, #tResult.sItemIds do
			local tItem = {}

			tItem.itemId = tResult.sItemIds[j]
			tItem.itemNum = tResult.sItemNums[j]
			tItem.type = bigRewardType
			tItem.imgRewardTitle = "ui/newActivity/bt_text_xxz_xlzjj.png"
			tItem.imgBK = "ui/specialBg/hd_pic_xxz_xlzjj.png"
		--	tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
			tItem.goodsconPt = GlobalMethod:ccp(0.5, 0.48)
			tItem.imgBKPt = GlobalMethod:ccp(0.52, 0.48)
			tItem.strTitle = string.format(strTitleFormat, LocalStrings.BEINGIMMORTAL_TEXT1[9], LocalStrings.BEINGIMMORTAL_TEXT0_VN[1])
			tItem.spineEffect = {path = "activity/ui_xiuxian_zj", _sIndex = "ui_xiuxian_zj", play = "wait1"}

			table.insert(self.m_tOpenResult.bigRewards, tItem)
		end
		--跑垒奖励
		for j = 1, #tResult.mapItemIds do
			local tItem = {}

			tItem.itemId = tResult.mapItemIds[j]
			tItem.itemNum = tResult.mapItemNums[j]
			tItem.type = rewardType
			tItem.imgRewardTitle = "ui/newActivity/text_hd_tqq_di.png"
			tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
			tItem.strTitle = string.format(strTitleFormat, LocalStrings.BEINGIMMORTAL_TEXT1[28], LocalStrings.ATH_REWARD_CHECK)

			table.insert(self.m_tOpenResult.runRewards, tItem)
		end

		if result == 1 then 
			self.m_tAllMapId = tResult.mapId
			self.m_tAllMapExp = tResult.mapExp
			self.m_nCurMapId = self:_setCurMapId()
			self.m_nCurMapTargetExp = self:_getMagTarget(self.m_nCurMapId) 

			self.m_nCurLevel = tResult.lv
			self.m_nCurExp = tResult.lvExp

			self:showOpenAction()
			self:_setFreeBtnText()
			self:_showLvAndExp()
			self:_showMap()
		else
			self:setOpenState(false)
		end
	elseif doType == 5 then --大奖限量
		local tResult = json.decode(jsonData)
		local nSex = CacheCenter:getPlayerInfo().sex
		local sBigReward = tResult.rewards
		local array = SplitStringWithSeparator(sBigReward, "&")
		local tItem = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.BEINGIMMORTAL_TEXT1[9] .. LocalStrings.CRAZY_GASHAPON_TEXT3[6], strAtt = LocalStrings.GONGANDDRUM_TEXT1[16], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31}
		for i = 1, #tResult.globalLimit do
			local tab = {}
			tab.id = i - 1
			tab.limitNum = tResult.playerLimitConfig[i]
			tab.dailyLimit = tResult.globalLimitConfig[i]
			tab.dailyBuyNum = tResult.globalLimit[i]
			tab.soldNum = tResult.playerLimit[i]
			if utilsValueInTable(i - 1, tResult.optionalList) then 
				tItem.chooseState[i] = 1
			else
				tItem.chooseState[i] = 0
			end
			
			tItem.leftConfig[i] = tab
		end

		for i = 1, #array do
			local string = string.sub(array[i], 2, -2) 
			local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
			local num = tonumber(SplitStringWithSeparator(string,",")[3])

			table.insert(tItem.reward_ids2, id)
			table.insert(tItem.reward_nums2, num)
		end
		self.m_tBigRewardList[2] = tItem

		local otherData = {}
		otherData.winType = 1
		otherData.activityId = self.m_nActivityId
		otherData.chooseInfo = {strKey=LocalStrings.BEINGIMMORTAL_TEXT1[9] .. LocalStrings.CRAZY_GASHAPON_TEXT3[6], doType=6}
		WndJoinReward:showInterface("", self.m_tBigRewardList[1], self.m_tBigRewardList[2], LocalStrings.BEINGIMMORTAL_TEXT1[8], nil, 2, otherData, 2)
	elseif doType == 6 then 
		local tResult = json.decode(jsonData)
		if result == 0 then 
			local tTempList = nil 
			tTempList = self.m_tBigRewardList[2]
			tTempList.chooseState[tResult.id + 1] = tResult.status
			if tResult.status == 1 then 
				WndJoinReward:chooseReturn(2, tResult.id + 1, tResult.status)
			end
		elseif result == 1 then
			MsgBoxManager:showTipBox(LocalStrings.SUMMERSURF_TEXT1[24])
		end
	end
end

--@brief	缓存推送更新物品时调用的函数
function WndBeingImmortal:updatePlayerItemData()
	WZLog("WndBeingImmortal:updatePlayerItemData")
	if self.m_root ~= nil then
		self:_updateLightNum()
		self:showRedDot()
	end
end

--@brief 	设置射箭的状态
function WndBeingImmortal:setOpenState(state)
	-- body
	if self.m_root == nil then return end 

	self.m_bOpenState = state
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	关闭抽奖奖励展示界面回调
function WndBeingImmortal:_afterCloseReward()
	if self.m_root == nil then return end 

	local tBigReward = {}
	local nIndex = 1
	if self.m_tOpenResult.firstRewards and #self.m_tOpenResult.firstRewards > 0 then 
		for i = 1, #self.m_tOpenResult.firstRewards do
			table.insert(tBigReward, self.m_tOpenResult.firstRewards[i])
		end
	end
	if self.m_tOpenResult.bigRewards and #self.m_tOpenResult.bigRewards > 0 then 
		for i = 1, #self.m_tOpenResult.bigRewards do
			table.insert(tBigReward, self.m_tOpenResult.bigRewards[i])
		end
	end

	local tOtherRewards = {}
	if self.m_tOpenResult.runRewards and #self.m_tOpenResult.runRewards > 0 then 
		table.insert(tOtherRewards, self.m_tOpenResult.runRewards)
	end

	if self.m_tOpenResult.normalRewards and #self.m_tOpenResult.normalRewards > 0 then 
		WndHoraryBigReward:showInterface(8, self.m_tOpenResult.normalRewards, tBigReward, tOtherRewards)
	elseif #tBigReward > 0 then 
		WndHoraryBigReward:showInterface(9, tBigReward)
	end
end

--@brief 	解析大奖数据
function WndBeingImmortal:_analyzeBigReward()
	-- body
	local sBigReward = self.m_tContent.firstRewards
	local array = SplitStringWithSeparator(sBigReward, "&")
	local nSex = CacheCenter:getPlayerInfo().sex
	local tItem = {reward_ids1 = {}, reward_nums1 = {}, name = LocalStrings.BEINGIMMORTAL_TEXT1[9] .. LocalStrings.BEINGIMMORTAL_TEXT1[10]}
	self.m_tBigRewardList = {}
	for i = 1, #array do
--		WZLog("WndBeingImmortal:_analyzeBigReward", string.sub(array[i], 2, -2))
		local string = string.sub(array[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string,",")[3])

		table.insert(tItem.reward_ids1, id)
		table.insert(tItem.reward_nums1, num)
	end

	self.m_tBigRewardList[1] = tItem

	local specialReward = self.m_tContent.superRewards
	local array1 = SplitStringWithSeparator(specialReward, "&")
	local tItem1 = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.BEINGIMMORTAL_TEXT1[9] .. LocalStrings.BEINGIMMORTAL_TEXT0_VN[1]}
	for i = 1, #array1 do
--		WZLog("WndBeingImmortal:_analyzeBigReward", string.sub(array1[i], 2, -2))
		local string = string.sub(array1[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string, ",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string, ",")[3])
		
		table.insert(tItem1.reward_ids2, id)
		table.insert(tItem1.reward_nums2, num)
	end

	self.m_tBigRewardList[2] = tItem1
end

--@brief 	获取当前捕鼠等级
function WndBeingImmortal:getCurLvInfo()
	local nLevel = self.m_nCurLevel 
	local tCurInfo = self.m_tLvRewardList[nLevel]  
	local nMaxLv = #self.m_tLvRewardList 
	local tMaxInfo = self.m_tLvRewardList[nMaxLv] 
	local tNextInfo = self.m_tLvRewardList[nLevel + 1]  

	if nLevel >= nMaxLv then 
		tCurInfo = tMaxInfo
		tNextInfo = tMaxInfo
	end

	return tCurInfo, tNextInfo, nMaxLv
end

--@brief 	获取射箭任务列表
function WndBeingImmortal:_onGetTaskInfo(activityId, activityType, taskType, id, status, target, progress, progressCount, refreshTime, taskGroup)
	if activityId == self.m_nActivityId and taskGroup == 4 then 
		local tab = WndBeingImmortal:setTaskData(id, status, target, progress, activityId)
		WZLog("WndBeingImmortal:_onGetTaskInfo", taskType, taskGroup, Serialize(tab))
		self.m_tLvRewardList = tab

		self:_showLvAndExp()
		self:_showMap()
		self:_createLvRewardList()
	end
end

--@brief 	设置任务数据成功
function WndBeingImmortal:setTaskData(id, status, target, progress, activityId)
	local data = {}
	if id and next(id) ~= nil then
		for i = 1, #id do
			local tab = {}
			tab.id = id[i]
			tab.status = status[i] + 1
			tab.exp = target[i]
			tab.progress = progress[i]
			tab.name = ""
			tab.reward = {}
			tab.activityId = activityId
			local config = GDatatab_new_activity_task["id_"..id[i]]
			if config then
				local nStart = string.find(config.target, "*")
				local nEnd = string.find(config.target, "=")
				tab.lv = tonumber(string.sub(config.target, nStart + 1, nEnd - 1))
				tab.name = config.desc
				tab.reward = config.reward
				tab.script = config.script
			end
			tab.ids = {}
			tab.nums = {}
			for i = 1, #tab.reward do
				table.insert(tab.ids, tab.reward[i][1])
				table.insert(tab.nums, tab.reward[i][2])
			end

			data[i] = tab
		end
	end
	return data
end

--@brief 	设置地图配置数据
function WndBeingImmortal:_setMagConfigData()
	self.m_tMapConfig = {}

	local sBigReward = self.m_tContent.mapInterval
	
	for i = 1, #sBigReward do
		local tItem = {}
		tItem.mapId = sBigReward[i][1]
		tItem.level = sBigReward[i][2]
		tItem.target = sBigReward[i][6]

		table.insert(self.m_tMapConfig, tItem)
	end

	table.sort(self.m_tMapConfig, function (a,b) return a.mapId < b.mapId end)
end

--@brief 	设置地图配置数据
function WndBeingImmortal:_getMagTarget(mapId)
	for i = 1, #self.m_tMapConfig do
		if self.m_tMapConfig[i].mapId == mapId then 
			return self.m_tMapConfig[i].target
		end
	end
end

--@brief 	获取当前地图Id
function  WndBeingImmortal:_setCurMapId()
	-- body
	local curMapId = 1 

	for i = 1, #self.m_tAllMapId do
		local target = self:_getMagTarget(self.m_tAllMapId[i])
		if target > self.m_tAllMapExp[i] then 
			curMapId = self.m_tAllMapId[i]
			break 
		end
	end

	return curMapId
end
-------------------------------------私有方法模块End----------------------------------------
