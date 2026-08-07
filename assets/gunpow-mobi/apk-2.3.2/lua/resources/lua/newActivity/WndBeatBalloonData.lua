--WndBeatBalloonData.lua
--@brief	WndBeatBalloon的数据模块
--@date		2023/03/17
--@author	XTX
--@note		打气球活动主界面

WndBeatBalloon = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndBeatBalloon:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_tBigRewardList = nil 		--大奖和特奖奖励
	self.m_bOpenState = false 
	self.m_tOpenResult = nil 
	self.m_nCoinId = 160429
	self.m_nMaxLotteryCount = 20    --最大抽奖次数
	self.m_nCount = 0 
	self.m_tBallAniName = {{"wait1", "wait3", "wait3_1", "wait3_2"}, {"wait2", "wait4", "wait4_1", "wait4_2"}}
	self.m_nAniType = 1 			--抽奖动画索引
	self.m_nCalabashType = 0
	self.m_nSurprisedBalloon = 0 	--惊喜气球触发配置
	self.m_nCurProcress = 0 		--当前惊喜气球的进度
	self.m_tBalloonColor = {"ui/newActivity/common_dqq_qiu_da.png", "ui/newActivity/common_dqq_qiu_zi.png", "ui/newActivity/common_dqq_qiu_lan.png", "ui/newActivity/common_dqq_qiu_cheng.png", "ui/newActivity/common_dqq_qiu_hong.png", "ui/newActivity/common_dqq_qiu_lv.png"}
	self.m_tBalloonData = nil 		--界面气球数据
	self.m_nSelBalloonIndex = nil 	--选中的气球
	self.m_tSpecialTask = nil 		--特殊任务
	self.m_tCostNumConfig = nil 	--消耗飞镖数配置
	self.m_tPointCount = {10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10} 
	self.m_tBombEffect = {"activity/ui_dqq_bn", "activity/ui_dqq_hn"}
	self.m_nChooseReward = 0 		--选择奖励状态0：弹出预览界面；1：不弹
	self.m_tGetTimes = {}
	self.m_bIsOpenReward = false
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndBeatBalloon:_unInit()
	self.m_root = nil
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_tBigRewardList = nil 		--大奖和特奖奖励
	self.m_bOpenState = nil 
	self.m_tOpenResult = nil 
	self.m_nCoinId = nil
	self.m_nMaxLotteryCount = nil    --最大抽奖次数
	self.m_nCount = nil 
	self.m_tBallAniName = nil
	self.m_nAniType = nil 			--抽奖动画索引
	self.m_nCalabashType = nil 
	self.m_nSurprisedBalloon = nil 	--惊喜气球触发配置
	self.m_nCurProcress = nil 
	self.m_tBalloonColor = nil 
	self.m_tBalloonData = nil 		--界面气球数据
	self.m_nSelBalloonIndex = nil 
	self.m_tSpecialTask = nil 		--特殊任务
	self.m_tCostNumConfig = nil 	--消耗飞镖数配置
	self.m_tPointCount = nil 
	self.m_tBombEffect = nil 
	self.m_nChooseReward = nil 		--选择奖励状态0：弹出预览界面；1：不弹
	self.m_bIsOpenReward = nil 
	self.m_tGetTimes = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndBeatBalloon:createElement()
	if WndBeatBalloon.m_root ~= nil then
		WindowManager:removeWindow(WndBeatBalloon.m_root, WndBeatBalloon, true)
	end
	local element = WZUISystem:getInstance():createElement("WndBeatBalloon")
	assert(element, "WndBeatBalloon create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndBeatBalloon:showInterface()
	LoadNewActivityRes(true)
	local wndWater = WndBeatBalloon:createElement()
	if wndWater then 
		WindowManager:addWindow(wndWater, WndBeatBalloon, false)
	end
end

--@brief 	获取活动详情成功
function WndBeatBalloon:GetActivityInfoOK(activityId,maxCount,count,status, rewardCounts, rewardItems, rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	-- body
	WZLog("WndBeatBalloon:GetActivityInfoOK", g_cityExtenInfo.activity7070, Serialize(finishCondition), content)
	if g_cityExtenInfo.activity7070 == activityId then 
		self.m_tContent = json.decode(content)
		self.m_nStartTime = startTime 
		self.m_nEndTime = endTime 
		self.m_nActivityId = activityId
		self.m_nCount = count
		self.m_nSurprisedBalloon = self.m_tContent.jxConfig[2]
		self.m_nCurProcress = maxCount
		self.m_tBalloonData = status
		self.m_nSelBalloonIndex = self:_randomChooseBalloon()
		self.m_tCostNumConfig = {self.m_tContent.jxConfig[5], self.m_tContent.jxConfig[6]}
		WZLog("self.m_tContentself.m_tContent", Serialize(self.m_tContent))
		self.m_nChooseReward = GetOperateTimes("BEATBALLOONACTIVITYID", self.m_nActivityId) 
		
		self:_analyzeBigReward()
		self:_update()
	end
end

--@brief 	获取其他活动数据
function WndBeatBalloon:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end 

	if doType == 2 then --大奖限量
		local tResult = json.decode(jsonData)
		local nSex = CacheCenter:getPlayerInfo().sex
		local sBigReward = tResult.rewards
		local array = SplitStringWithSeparator(sBigReward, "&")

		table.insert(self.m_tGetTimes, tResult.pool)
		local tItem = {}
		if tResult.pool == 1 then 
			tItem = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.BEATBALLOON_TEXT1[9], strAtt = LocalStrings.GONGANDDRUM_TEXT1[16], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31, pool = tResult.pool}
		elseif tResult.pool == 2 then 
			tItem = {reward_ids = {}, reward_nums = {}, name = LocalStrings.BEATBALLOON_TEXT1[10], strAtt = LocalStrings.GONGANDDRUM_TEXT1[16], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31, pool = tResult.pool}
		end
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
			if tResult.pool == 1 then 
				table.insert(tItem.reward_ids2, id)
				table.insert(tItem.reward_nums2, num)
			elseif tResult.pool == 2 then 
				table.insert(tItem.reward_ids, id)
				table.insert(tItem.reward_nums, num)
			end
		end
		if tResult.pool == 1 then 
			self.m_tBigRewardList[2] = tItem
		elseif tResult.pool == 2 then 
			self.m_tBigRewardList[3] = tItem
		end

		if self.m_bIsOpenReward and self.m_tGetTimes and #self.m_tGetTimes == 2 then 
			self.m_bIsOpenReward = false 
			local otherData = {}
			otherData.winType = 1
			otherData.activityId = self.m_nActivityId
			otherData.otherRewardData = self.m_tBigRewardList[3]
			otherData.chooseInfo = {strKey="BEATBALLOON_TEXT1", wordIndex=8, doType=4}

			WndJoinReward:showInterface("", self.m_tBigRewardList[1], self.m_tBigRewardList[2], LocalStrings.TREASURE_TEXT7, nil, 3, otherData, 3)
		end
	elseif doType == 3 then --开启结果
		local tResult = json.decode(jsonData)
		WZLog("WndBeatBalloon:_onGetOtherData 333", Serialize(tResult))
		self.m_tOpenResult = {}

		self.m_tOpenResult.normalRewards = {} --常规奖
		self.m_tOpenResult.firstRewards = {} --小礼奖
		self.m_tOpenResult.bigRewards = {} --大礼奖
		self.m_tOpenResult.surprisedRewards = {} --惊喜气球奖励
		self.m_tOpenResult.addScore = 0 --增加的积分

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
		local strTitleFormat = [[<T C="255,255,255" S="46" P="1" SC="222,78,0" SS="4" SE="0">%s</T><T C="249,255,0" S="46" P="1" SC="222,78,0" SS="4" SE="0">%s</T>]]
		--大奖
		if tResult.fItemIds then 
			for j = 1, #tResult.fItemIds do
				local tItem = {}

				tItem.itemId = tResult.fItemIds[j]
				tItem.itemNum = tResult.fItemNums[j]
				tItem.type = bigRewardType
				tItem.imgRewardTitle = "ui/newActivity/text_hd_tqq_di.png"
				tItem.imgBK = "ui/newActivity/hd_pic_dqq_dj_01.png"
			--	tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
				tItem.imgBKPt = GlobalMethod:ccp(0.5, 0.5)
				tItem.goodsconPt = GlobalMethod:ccp(0.5, 0.5)
				tItem.strTitle = string.format(strTitleFormat, LocalStrings.BEATBALLOON_TEXT1[1], LocalStrings.CRAZY_GASHAPON_TEXT3[7])
				tItem.spineEffect = {path = "activity/ui_dqq_xj", _sIndex = "ui_dqq_xj", play = "wait1"}

				table.insert(self.m_tOpenResult.firstRewards, tItem)
			end
		end
		--特奖
		strTitleFormat = [[<T C="255,255,255" S="36" P="1" SC="225,79,115" SS="4" SE="1">%s</T>]]
		for j = 1, #tResult.sItemIds do
			local tItem = {}

			tItem.itemId = tResult.sItemIds[j]
			tItem.itemNum = tResult.sItemNums[j]
			tItem.type = bigRewardType
			tItem.imgBK = "ui/newActivity/hd_pic_dqq_dj_02.png"
			tItem.goodsconPt = GlobalMethod:ccp(0.5, 0.55)
			tItem.imgBKPt = GlobalMethod:ccp(0.49,0.5)
			tItem.spineEffect = {path = "activity/ui_dqq_dj", _sIndex = "ui_dqq_dj", play = "wait1"}

			table.insert(self.m_tOpenResult.bigRewards, tItem)
		end

		--狂魔奖
		strTitleFormat = [[<T C="255,255,255" S="36" P="1" SC="222,78,0" SS="4" SE="1">%s</T>]]
		for j = 1, #tResult.nItems do
			local tItem = {}

			tItem.itemId = tResult.nItems[j]
			tItem.itemNum = tResult.nItemNums[j]
			tItem.type = bigRewardType
			tItem.imgBK = "ui/newActivity/hd_pic_dqq_dj_03.png"
			tItem.imgBKPt = GlobalMethod:ccp(0.49,0.5)
			tItem.goodsconPt = GlobalMethod:ccp(0.5, 0.55)
		
			tItem.spineEffect = {path = "activity/ui_dqq_wz", _sIndex = "ui_dqq_wz", play = "wait1"}

			table.insert(self.m_tOpenResult.bigRewards, tItem)
		end
		--惊喜气球奖励
		strTitleFormat = [[<T C="255,255,255" S="40" P="1" SC="222,78,0" SS="4" SE="0">%s</T><T C="249,255,0" S="40" P="1" SC="222,78,0" SS="4" SE="0">%s</T>]]
		if tResult.jxItemsId and #tResult.jxItemsId > 0 then 
			for i = 1, #tResult.jxItemsId do
				local tItem = {}

				tItem.itemId = tResult.jxItemsId[i]
				tItem.itemNum = tResult.jxItemNums[i]
				tItem.type = rewardType
				tItem.imgRewardTitle = "ui/newActivity/text_hd_tqq_di.png"
				tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
				tItem.strTitle = string.format(strTitleFormat, LocalStrings.BEATBALLOON_TEXT1[19], LocalStrings.ATH_REWARD_CHECK)

				table.insert(self.m_tOpenResult.surprisedRewards, tItem)
			end
		end

		if result == 1 then 
			self.m_nCount = tResult.count
			self.m_tOpenResult.addScore = tResult.scoreNum or 0 --增加的积分
			self.m_nCurProcress = tResult.jxTimes
			self.m_tOpenResult.shootPos = {}
			--刷新数据
			for i = 1, #tResult.qqPos do
				self.m_tBalloonData[tResult.qqPos[i] + 1] = -1
				self.m_tOpenResult.shootPos = tResult.qqPos
			end
			if tResult.qqList and #tResult.qqList > 0 then
				self.m_tBalloonData = tResult.qqList
			end
			--重新随机一个气球打
			self.m_nSelBalloonIndex = self:_randomChooseBalloon()

			self:showOpenAction()
			self:_setFreeBtnText()
		else
			self:setOpenState(false)
		end
	elseif doType == 4 then 
		local tResult = json.decode(jsonData)
		if result == 0 then 
			local tTempList = nil 
			local nTag = 2 
			if tResult.pool == 1 then 
				nTag = 2 
				tTempList = self.m_tBigRewardList[2]
			elseif tResult.pool == 2 then 
				nTag = 4 
				tTempList = self.m_tBigRewardList[3]
			end
			tTempList.chooseState[tResult.id + 1] = tResult.status
			if tResult.status == 1 then 
				WndJoinReward:chooseReturn(nTag, tResult.id + 1, tResult.status)
			end
		elseif result == 1 then
			MsgBoxManager:showTipBox(LocalStrings.SUMMERSURF_TEXT1[24])
		end
	end
end

--@brief	缓存推送更新物品时调用的函数
function WndBeatBalloon:updatePlayerItemData()
	WZLog("WndBeatBalloon:updatePlayerItemData")
	if self.m_root ~= nil then
		self:_updateLightNum()
		self:showRedDot()
		self:_setFreeBtnText()
	end
end

--@brief 	设置射箭的状态
function WndBeatBalloon:setOpenState(state)
	-- body
	if self.m_root == nil then return end 

	self.m_bOpenState = state
end

--@brief 	获取射箭任务列表
function WndBeatBalloon:_onGetTaskInfo(activityId, activityType, taskType, id, status, target, progress, progressCount, refreshTime, taskGroup)
	if activityId == self.m_nActivityId and taskType == 3 then 
		local tab = CellNewYearTask:setTaskData(id, status, target, progress, activityId)
		WZLog("WndBeatBalloon:_onGetTaskInfo", taskType, taskGroup, Serialize(tab))
		self.m_tSpecialTask = tab

		self:showSpecialTask()
	end
end

--@brief 	射箭任务奖励
function WndBeatBalloon:_onGetTaskResult(activityId, id)
--	WZLog("CellNewYearTask:_onGetTaskResult", self.m_nActivityId, activityId, id)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	关闭抽奖奖励展示界面回调
function WndBeatBalloon:_afterCloseReward()
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
	if self.m_tOpenResult.surprisedRewards and #self.m_tOpenResult.surprisedRewards > 0 then 
		table.insert(tOtherRewards, self.m_tOpenResult.surprisedRewards)
	end

	if self.m_tOpenResult.normalRewards and #self.m_tOpenResult.normalRewards > 0 then 
		WndHoraryBigReward:showInterface(8, self.m_tOpenResult.normalRewards, tBigReward, tOtherRewards)
	elseif self.m_tOpenResult.surprisedRewards and #self.m_tOpenResult.surprisedRewards > 0 then 
		WndHoraryBigReward:showInterface(8, self.m_tOpenResult.surprisedRewards, tBigReward)
	elseif #tBigReward > 0 then 
		WndHoraryBigReward:showInterface(9, tBigReward)
	end
end

--@brief 	解析大奖数据
function WndBeatBalloon:_analyzeBigReward()
	-- body
	local sBigReward = self.m_tContent.firstRewards
	local array = SplitStringWithSeparator(sBigReward, "&")
	local nSex = CacheCenter:getPlayerInfo().sex
	local tItem = {reward_ids1 = {}, reward_nums1 = {}, name = LocalStrings.BEATBALLOON_TEXT1[8]}
	self.m_tBigRewardList = {}
	for i = 1, #array do
--		WZLog("WndBeatBalloon:_analyzeBigReward", string.sub(array[i], 2, -2))
		local string = string.sub(array[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string,",")[3])

		table.insert(tItem.reward_ids1, id)
		table.insert(tItem.reward_nums1, num)
	end

	self.m_tBigRewardList[1] = tItem

	local specialReward = self.m_tContent.superRewards
	local array1 = SplitStringWithSeparator(specialReward, "&")
	local tItem1 = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.BEATBALLOON_TEXT1[9] }
	for i = 1, #array1 do
--		WZLog("WndBeatBalloon:_analyzeBigReward", string.sub(array1[i], 2, -2))
		local string = string.sub(array1[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string, ",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string, ",")[3])
		
		table.insert(tItem1.reward_ids2, id)
		table.insert(tItem1.reward_nums2, num)
	end

	self.m_tBigRewardList[2] = tItem1

	local specialReward2 = self.m_tContent.normalRewards
	local array2 = SplitStringWithSeparator(specialReward2, "&")
	local tItem2 = {reward_ids = {}, reward_nums = {}, name = LocalStrings.BEATBALLOON_TEXT1[10]}
	for i = 1, #array2 do
--		WZLog("WndMidnightDiner:_analyzeBigReward", string.sub(array2[i], 2, -2))
		local string = string.sub(array2[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string, ",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string, ",")[3])
		
		table.insert(tItem2.reward_ids, id)
		table.insert(tItem2.reward_nums, num)
	end

	self.m_tBigRewardList[3] = tItem2
end

--@brief    添加保存上次选择的怒气
function WndBeatBalloon:savePoleType()
    WZLog("WndBeatBalloon:savePoleType")
    local _KeyString = ""
    local curDate = os.date("*t", SystemTime:getServerTime())
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = "BEATBALLOON" .. tostring(CacheCenter:getPlayerInfo().id)
    local strValue =  data:getStringValue("CALABASH_MARK", _KeyString)
    local curValue = string.format("%02d%02d_%d", curDate.month, curDate.day, self.m_nCalabashType)
    if strValue == nil or strValue == "" or strValue ~= curValue then
        data:setStringValue("CALABASH_MARK", _KeyString, curValue)
        data:flush()
    end
end

--@brief    获取上次保存的怒气
function WndBeatBalloon:getPoleType()
    WZLog("WndBeatBalloon:getPoleType")
    local _KeyString = ""
    local curDate = os.date("*t", SystemTime:getServerTime())
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = "BEATBALLOON" .. tostring(CacheCenter:getPlayerInfo().id)
    local strValue =  data:getStringValue("CALABASH_MARK", _KeyString)
    local curValue = string.format("%02d%02d", curDate.month, curDate.day)
    if strValue ~= nil and strValue ~= "" then
        local result = SplitStringWithSeparator(strValue, "_")
        if result[1] == curValue then 
        	self.m_nCalabashType = tonumber(result[2])
        	if self.m_nCalabashType ~= 0 then 
        		GetElement(self.m_root, "cbgTool_WndBeatBalloon", WZUICheckBoxGroup):setCheckIndex(self.m_nCalabashType)
        	end
        end
    end
end

--@brief 	随机选中一个气球打
function WndBeatBalloon:_randomChooseBalloon()
	local tBalloonPos = {}
	for i = 1, #self.m_tBalloonData do
		if self.m_tBalloonData[i] ~= -1 then 
			table.insert(tBalloonPos, i)
		end
	end

	local randomNum = math.random(1, 100)
	local indexPos = 1
	if #tBalloonPos == 1 then 
		indexPos = 1
	else
		local nCount = #tBalloonPos
		indexPos = math.fmod(randomNum, nCount) + 1
	end

	return indexPos - 1
end

--@brief 	获取剩余未打气球数量
function WndBeatBalloon:_getBalloonNum()
	local nCount = 0
	for i = 1, #self.m_tBalloonData do
		if self.m_tBalloonData[i] ~= -1 then 
			nCount = nCount + 1
		end
	end

	return nCount
end
-------------------------------------私有方法模块End----------------------------------------
