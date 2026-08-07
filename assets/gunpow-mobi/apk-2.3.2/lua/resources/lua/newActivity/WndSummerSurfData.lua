--WndSummerSurfData.lua
--@brief	WndSummerSurf的数据模块
--@date		2023/05/04
--@author	XTX
--@note		夏日冲浪活动界面

WndSummerSurf = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSummerSurf:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_tBigRewardList = nil 		--大奖和特奖奖励
	self.m_bOpenState = false 
	self.m_tOpenResult = nil 
	self.m_nCoinId = 160445
	self.m_nCoinId2 = 160446
	self.m_nMaxLotteryCount = 20    --最大抽奖次数
	self.m_nCount = 0 
	self.m_tBallAniName = {{"wait2_1", "wait2_3", "wait2_3"}, {"wait1_1", "wait1_3", "wait1_3"}}
	self.m_nAniType = 1 			--抽奖动画索引
	self.m_nCalabashType = 0 			--当前选中的浪板索引
	self.m_nWinTimes = 0 			--井字棋赢场
	self.m_tWellChessConfig = nil 
	self.m_tWellChessData = nil 	--井字棋数据0：未翻，1：O,2:X
	self.m_nSelChess = 0 			--选中的棋子
	self.m_tLoginGiftData = nil 	--每日登录礼包数据
	self.m_tCostByType = nil 
	self.m_tHideReward = nil 		--井字棋隐藏奖励
	self.m_nChooseReward = 0 		--选择奖励状态0：弹出预览界面；1：不弹
	self.m_tGetTimes = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSummerSurf:_unInit()
	self.m_root = nil
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_tBigRewardList = nil 		--大奖和特奖奖励
	self.m_bOpenState = nil 
	self.m_tOpenResult = nil 
	self.m_nCoinId = nil
	self.m_nCoinId2 = nil 
	self.m_nMaxLotteryCount = nil    --最大抽奖次数
	self.m_nCount = nil 
	self.m_tBallAniName = nil	
	self.m_nAniType = nil 			--抽奖动画索引
	self.m_nCalabashType = nil 			--当前选中的浪板索引
	self.m_nWinTimes = nil 
	self.m_tWellChessConfig = nil 
	self.m_tWellChessData = nil 
	self.m_nSelChess = nil 
	self.m_tLoginGiftData = nil 	--每日登录礼包数据
	self.m_tCostByType = nil 
	self.m_tHideReward = nil 		--井字棋隐藏奖励
	self.m_nChooseReward = nil 
	self.m_tGetTimes = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSummerSurf:createElement()
	if WndSummerSurf.m_root ~= nil then
		WindowManager:removeWindow(WndSummerSurf.m_root, WndSummerSurf, true)
	end
	local element = WZUISystem:getInstance():createElement("WndSummerSurf")
	assert(element, "WndSummerSurf create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndSummerSurf:showInterface()
	LoadNewActivityRes(true)
	local wndWater = WndSummerSurf:createElement()
	if wndWater then 
		WindowManager:addWindow(wndWater, WndSummerSurf, false)
	end
end

--@brief 	获取活动详情成功
function WndSummerSurf:GetActivityInfoOK(activityId,maxCount,count,status, rewardCounts, rewardItems, rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	-- body
	WZLog("WndSummerSurf:GetActivityInfoOK", activityId)
	if g_cityExtenInfo.activity7076 == activityId then 
		self.m_tContent = json.decode(content)
		self.m_nStartTime = startTime 
		self.m_nEndTime = endTime 
		self.m_nActivityId = activityId
		self.m_nCount = self.m_tContent.freeTimes
		WZLog("self.m_tContentself.m_tContent", Serialize(self.m_tContent))
		self.m_nWinTimes = self.m_tContent.winTimes
		self.m_tWellChessData = self.m_tContent.checkerboard
		self.m_tCostByType = {self.m_tContent.seniorCost[2], self.m_tContent.masterCost[2]}
		self.m_tHideReward = {}
		for id, value in pairs(self.m_tContent.reward) do
			local tItem = {tonumber(id), tonumber(value)}
			table.insert(self.m_tHideReward, tItem)
		end

		local ids, nums = {}, {}
		for id, value in pairs(self.m_tContent.dailyReward) do
			table.insert(ids, tonumber(id))
			table.insert(nums, tonumber(value))
		end
		self.m_tLoginGiftData = {status = self.m_tContent.dailyRewardStatus, ids = ids, nums = nums}

		self.m_nChooseReward = self:getOperateTimes()
		self:_analyzeBigReward()
		self:_update()
	end
end

--@brief 	获取其他活动数据
function WndSummerSurf:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end 

	if doType == 1 then --翻开贝壳
		local tResult = json.decode(jsonData)
		WZLog("WndSummerSurf:_onGetOtherData 111", Serialize(tResult))
		if result == 1 then 
			self.m_tWellChessData[tResult.index + 1] = tResult.type
			if tResult.win == true then 
				local nCount = #LocalStrings.SUMMERSURF_TEXT1[25]
				local tempRand = math.random(1, 10)
				local strIndex = math.fmod(tempRand, nCount) + 1
				MsgBoxManager:showTipBox(LocalStrings.SUMMERSURF_TEXT1[25][strIndex])
				self.m_tOpenResult = {}
				self.m_tOpenResult.exchange = tResult.exchange
				if tResult.received ~= 1 then 
					local basicData = GDatatab_item["id_" .. tResult.exchange[1]]
					local strContent = string.format(LocalStrings.SUMMERSURF_TEXT1[23], basicData.icon, tResult.exchange[2])
					local nLightNum = CacheCenter:getPlayerItemCountById(tResult.exchange[1])
					local bIsItemEnough = nLightNum >= tResult.exchange[2]
					local tWordConfig = {MSGBOXUICFG_CANCEL=LocalStrings.TABOO_TEXT1, MSGBOXUICFG_CONFIRM=LocalStrings.GAME_ACIVIITY_OLD_EXCHANGE, bIsItemEnough = bIsItemEnough}
					MsgBoxManager:showConfirmBox(strContent, self, self.clickSureExchange, nil, tWordConfig, nil, nil, nil, self.cancelExchangeItem)

					self.m_nWinTimes = self.m_nWinTimes + 1
					self:_updateWellChessBoxData(self.m_nWinTimes)
					self:_showProgress()
				end
			end
			self:_showWellChessStatus()

			if tResult.reward and tResult.reward ~= "" then 
				local tHideReward = {}
				for id, value in pairs(tResult.reward) do
					local tItem = {}

					tItem.itemId = tonumber(id)
					tItem.itemNum = tonumber(value)
					tItem.type = 26
					tItem.imgRewardTitle = "ui/newActivity/bt_text_xrcl_stjzq_gxhd_di.png"
					tItem.imgBK = "ui/newActivity/hd_pic_xrcl_stjzq_gxhd.png"
				--	tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
					tItem.imgBKPt = GlobalMethod:ccp(0.5, 0.5)
					tItem.goodsconPt = GlobalMethod:ccp(0.5, 0.51)
					tItem.imgTitle = "ui/activityWords/bt_text_xrcl_stjzq_gxhd.png"
					tItem.imgTitlePt = GlobalMethod:ccp(0.5,0.893)
				--	tItem.spineEffect = {path = "activity/ui_hh_dj", _sIndex = "ui_hh_dj", play = "wait1"}

					table.insert(tHideReward, tItem)
				end
				if #tHideReward > 0 then 
					WndHoraryBigReward:showInterface(6, tHideReward)
				end
			end
			self:setOpenState(false)
		end
	elseif doType == 2 then --兑换隐藏道具操作
		local tResult = json.decode(jsonData)
		WZLog("WndSummerSurf:_onGetOtherData 222", Serialize(tResult))
		if result == 1 then 
			if tResult.reward and tResult.reward ~= "" then 
				local tHideReward = {}
				for id, value in pairs(tResult.reward) do
					local tItem = {}

					tItem.itemId = tonumber(id)
					tItem.itemNum = tonumber(value)
					tItem.type = 26
					tItem.imgRewardTitle = "ui/newActivity/bt_text_xrcl_stjzq_gxhd_di.png"
					tItem.imgBK = "ui/newActivity/hd_pic_xrcl_stjzq_gxhd.png"
				--	tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
					tItem.imgBKPt = GlobalMethod:ccp(0.5, 0.5)
					tItem.goodsconPt = GlobalMethod:ccp(0.5, 0.51)
					tItem.imgTitle = "ui/activityWords/bt_text_xrcl_stjzq_gxhd.png"
					tItem.imgTitlePt = GlobalMethod:ccp(0.5,0.893)
				--	tItem.spineEffect = {path = "activity/ui_hh_dj", _sIndex = "ui_hh_dj", play = "wait1"}

					table.insert(tHideReward, tItem)
				end
				if #tHideReward > 0 then 
					WndHoraryBigReward:showInterface(6, tHideReward)
				end
			end
		end
	elseif doType == 3 then --选择奖励
		local tResult = json.decode(jsonData)
		WZLog("WndSummerSurf:_onGetOtherData 333", Serialize(tResult))
		if result == 1 then 
			local tTempList = nil 
			if tResult.type == 2 then 
				tTempList = self.m_tBigRewardList[2]
			elseif tResult.type == 3 then 
				tTempList = self.m_tBigRewardList[1]
			end
			tTempList.chooseState[tResult.index + 1] = tResult.status
			if tResult.status == 1 then 
				WndJoinReward:chooseReturn(tResult.type, tResult.index + 1, tResult.status)
			end
		elseif result == 3 then
			MsgBoxManager:showTipBox(LocalStrings.SUMMERSURF_TEXT1[24])
		end
	elseif doType == 4 then --开启结果
		local tResult = json.decode(jsonData)
		WZLog("WndSummerSurf:_onGetOtherData 444", Serialize(tResult))
		self.m_tOpenResult = {}

		self.m_tOpenResult.normalRewards = {} --常规奖
		self.m_tOpenResult.firstRewards = {} --小礼奖
		self.m_tOpenResult.bigRewards = {} --大礼奖
		self.m_tOpenResult.doyensRewards = {} --达人奖

		local rewardType = 8 
		if tResult.reward["0"] then 
			for i = 1, #tResult.reward["0"].ids do
				local tItem = {}
				tItem.itemId = tResult.reward["0"].ids[i]
				tItem.itemNum = tResult.reward["0"].nums[i]
				tItem.type = rewardType
				tItem.imgRewardTitle = "ui/newActivity/bt_text_gxhd_2.png"
				tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
				table.insert(self.m_tOpenResult.normalRewards, tItem)
			end
		end
		--击杀死海盗奖励
		local strTitleFormat = [[<T C="255,255,255" S="42" P="1" SC="222,78,0" SS="4" SE="1">%s</T>]]
		--大奖
		local bigRewardType = 26 
		--大奖
		if tResult.reward["1"] then 
			for i = 1, #tResult.reward["1"].ids do
				local tItem = {}

				tItem.itemId = tResult.reward["1"].ids[i]
				tItem.itemNum = tResult.reward["1"].nums[i]
				tItem.type = bigRewardType
				tItem.imgRewardTitle = "ui/newActivity/bt_text_xrcl_clxsxj.png"
				tItem.imgBK = "ui/specialBg/hd_pic_xrcl_clxsxj.png"
			--	tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
				tItem.imgBKPt = GlobalMethod:ccp(0.5, 0.5)
				tItem.goodsconPt = GlobalMethod:ccp(0.51, 0.5)
				tItem.txtTitlePt = GlobalMethod:ccp(0.5,0.87)
				tItem.strTitle = string.format(strTitleFormat, LocalStrings.SUMMERSURF_TEXT1[9])
			--	tItem.spineEffect = {path = "activity/ui_hh_xj", _sIndex = "ui_hh_xj", play = "wait1"}

				table.insert(self.m_tOpenResult.firstRewards, tItem)
			end
		end
		--特奖
		if tResult.reward["2"] then 
			for i = 1, #tResult.reward["2"].ids do
				local tItem = {}
				tItem.itemId = tResult.reward["2"].ids[i]
				tItem.itemNum = tResult.reward["2"].nums[i]
				tItem.type = bigRewardType
				tItem.imgRewardTitle = "ui/newActivity/bt_text_xrcl_clxsdj.png"
				tItem.imgBK = "ui/specialBg/hd_pic_xrcl_clxsdj.png"
				tItem.goodsconPt = GlobalMethod:ccp(0.5, 0.5)
				tItem.imgBKPt = GlobalMethod:ccp(0.49,0.5)
				tItem.txtTitlePt = GlobalMethod:ccp(0.5,0.87)
				tItem.strTitle = string.format(strTitleFormat, LocalStrings.SUMMERSURF_TEXT1[8])
			--	tItem.spineEffect = {path = "activity/ui_hh_dj", _sIndex = "ui_hh_dj", play = "wait1"}

				table.insert(self.m_tOpenResult.bigRewards, tItem)
			end
		end

		--达人奖
		strTitleFormat = [[<T C="255,255,255" S="42" P="1" SC="0,113,174" SS="4" SE="1">%s</T>]]
		if tResult.reward["3"] then 
			for i = 1, #tResult.reward["3"].ids do
				local tItem = {}

				tItem.itemId = tResult.reward["3"].ids[i]
				tItem.itemNum = tResult.reward["3"].nums[i]
				tItem.type = bigRewardType
				tItem.imgRewardTitle = "ui/newActivity/bt_text_xrcl_cldrj.png"
				tItem.imgBK = "ui/newActivity/hd_pic_xrcl_cldrj.png"
				tItem.goodsconPt = GlobalMethod:ccp(0.52, 0.5)
				tItem.imgBKPt = GlobalMethod:ccp(0.49,0.5)
				tItem.txtTitlePt = GlobalMethod:ccp(0.5,0.87)
				tItem.strTitle = string.format(strTitleFormat, LocalStrings.SUMMERSURF_TEXT1[7])
			--	tItem.spineEffect = {path = "activity/ui_hh_dj", _sIndex = "ui_hh_dj", play = "wait1"}

				table.insert(self.m_tOpenResult.bigRewards, tItem)
			end
		end

		if result == 1 then 
			self.m_nCount = tResult.freeTimes
			
			self:showOpenAction()
			self:_setFreeBtnText()
		else
			self:setOpenState(false)
		end
	elseif doType == 5 then --棋盘数据刷新
		local tResult = json.decode(jsonData)
		WZLog("WndSummerSurf:_onGetOtherData 555", Serialize(tResult))
		if tResult.winTimes ~= self.m_nWinTimes then 
			self:_updateWellChessBoxData(tResult.winTimes)
		end
		self.m_nWinTimes = tResult.winTimes
		self.m_tWellChessData = tResult.checkerboard
		self.m_tHideReward = {}
		for id, value in pairs(tResult.reward) do
			local tItem = {tonumber(id), tonumber(value)}
			table.insert(self.m_tHideReward, tItem)
		end

		self:_showProgress()
		self:_showWellChessStatus()
	elseif doType == 6 then --每日登录奖励
		local tResult = json.decode(jsonData)
		WZLog("WndSummerSurf:_onGetOtherData 666", Serialize(tResult))
		if result == 1 then 
			self.m_tLoginGiftData.status = 1
			local ids, nums = {}, {}
			for id, value in pairs(tResult.reward) do
				table.insert(ids, tonumber(id))
				table.insert(nums, tonumber(value))
			end
			WndRewardShow:showById(ids, nums)
			GetElement(self.m_root, "imgCardRedDot_WndSummerSurf", WZUIImage):setVisible(false)
		end
	elseif doType == 7 then --获取达人奖、大奖限量数据
		local tResult = json.decode(jsonData)
		WZLog("WndSummerSurf:_onGetOtherData 777", Serialize(tResult))
		table.insert(self.m_tGetTimes, tResult.type)
		local tTempList = nil 
		if tResult.type == 2 then 
			tTempList = self.m_tBigRewardList[2]
		elseif tResult.type == 3 then 
			tTempList = self.m_tBigRewardList[1]
		end

		for i = 1, #tResult.indexs do
			local tab = {}
			tab.id = tResult.indexs[i]
			tab.limitNum = tResult.limitNums[i]
			tab.dailyLimit = tResult.playerDailyLimits[i]
			tab.dailyBuyNum = tResult.dailyBuyNums[i]
			tab.soldNum = tResult.soldNums[i]
			
			tTempList.leftConfig[tResult.indexs[i] + 1] = tab
		end

		if self.m_tGetTimes and #self.m_tGetTimes == 2 then 
			local otherData = {}
			otherData.winType = 1
			otherData.activityId = self.m_nActivityId
			otherData.otherRewardData = self.m_tBigRewardList[3]
			WndJoinReward:showInterface("", self.m_tBigRewardList[1], self.m_tBigRewardList[2], LocalStrings.TREASURE_TEXT7, nil, 3, otherData)
		end
	end
end

--@brief	缓存推送更新物品时调用的函数
function WndSummerSurf:updatePlayerItemData()
	WZLog("WndSummerSurf:updatePlayerItemData")
	if self.m_root ~= nil then
		self:_updateLightNum()
	end
end

--@brief 	设置射箭的状态
function WndSummerSurf:setOpenState(state)
	-- body
	if self.m_root == nil then return end 

	self.m_bOpenState = state
end

--@brief 	获取射箭任务列表
function WndSummerSurf:_onGetTaskInfo(activityId, activityType, taskType, id, status, target, progress, progressCount, refreshTime, taskGroup)
	if activityId == self.m_nActivityId and taskType == -1 and taskGroup == 4 then 
		local tab = CellNewYearTask:setTaskData(id, status, target, progress, activityId)
		WZLog("WndSummerSurf:_onGetTaskInfo 000", taskType, taskGroup, Serialize(tab))
		--井字棋宝箱配置
		self.m_tWellChessConfig = tab
		self:_showWellChess()
	end
end

--@brief 	射箭任务奖励
function WndSummerSurf:_onGetTaskResult(activityId, id)
--	WZLog("WndSummerSurf:_onGetTaskResult", self.m_nActivityId, activityId, id)
	if self.m_nActivityId ~= activityId then
		MsgBoxManager:showTipBox(LocalStrings.RETURNEE_TEXT28)
		return
	end
	
	local taskData = GDatatab_new_activity_task["id_" .. id]
	if taskData and taskData.group_by == 4 then
		for i = 1, #self.m_tWellChessConfig do
			if self.m_tWellChessConfig[i].id == id then 
				--刷新积分宝箱状态
				self.m_tWellChessConfig[i].status = 2
				local nullBox = {"ui/common/common_icon_lan3.png","ui/common/common_icon_zi3.png","ui/common/common_icon_huang3.png","ui/common/common_icon_zis3.png", "ui/common/common_icon_hong3.png"}
				
				GetElement(self.m_root, "armScoreBox" .. i .. "_WndSummerSurf", WZArmature):setVisible(false)
				local imgScoreBox = GetElement(self.m_root, "imgScoreBox" .. i .. "_WndSummerSurf", WZUIImage)
				imgScoreBox:setFile(nullBox[i])

				self.m_tWellChessConfig[i].lastStatus = 2

				break 
			end
		end
	end
end

--@brief 	更新胜场宝箱的状态
function WndSummerSurf:_updateWellChessBoxData(nWinTimes)
	for i = 1, #self.m_tWellChessConfig do
		if self.m_tWellChessConfig[i].status == 0 then 
			self.m_tWellChessConfig[i].progress = nWinTimes
			if self.m_tWellChessConfig[i].progress >= self.m_tWellChessConfig[i].target then 
				self.m_tWellChessConfig[i].progress = self.m_tWellChessConfig[i].target
				self.m_tWellChessConfig[i].status = 1
			end
		end
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	关闭抽奖奖励展示界面回调
function WndSummerSurf:_afterCloseReward()
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

	local tOtherReward = {}
	if self.m_tOpenResult.firstZLRewards and #self.m_tOpenResult.firstZLRewards > 0 then 
		table.insert(tOtherReward, self.m_tOpenResult.firstZLRewards)
	end
	if self.m_tOpenResult.normalZLRewards and #self.m_tOpenResult.normalZLRewards > 0 then 
		table.insert(tOtherReward, self.m_tOpenResult.normalZLRewards)
	end

	if self.m_tOpenResult.normalRewards and #self.m_tOpenResult.normalRewards > 0 then 
		WndHoraryBigReward:showInterface(8, self.m_tOpenResult.normalRewards, tBigReward, tOtherReward)
	elseif #tBigReward > 0 then 
		WndHoraryBigReward:showInterface(9, tBigReward)
	end
end

--@brief 	解析大奖数据
function WndSummerSurf:_analyzeBigReward()
	-- body
	local tBigReward = self.m_tContent.rewardPool["1"]
	local tItem = {reward_ids = {}, reward_nums = {}, name = LocalStrings.SUMMERSURF_TEXT1[9], listBgSize = {474,228}, listBgPos = {0.5,0.431}}
	self.m_tBigRewardList = {}
	for key, value in pairs(tBigReward) do
		local tValue = SplitStringWithSeparator(value, ",", nil, true)
		local id = tValue[1]
		local num = tValue[2]
		tItem.reward_ids[tonumber(key) + 1] = id
		tItem.reward_nums[tonumber(key) + 1] = num
	end

	self.m_tBigRewardList[3] = tItem

	local specialReward = self.m_tContent.rewardPool["2"]
	local tItem1 = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.SUMMERSURF_TEXT1[8], strAtt = LocalStrings.SUMMERSURF_TEXT1[17], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461} , cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31}
	for key, value in pairs(specialReward) do
		local tValue = SplitStringWithSeparator(value, ",", nil, true)
		local id = tValue[1]
		local num = tValue[2]

		tItem1.reward_ids2[tonumber(key) + 1] = id
		tItem1.reward_nums2[tonumber(key) + 1] = num
		tItem1.chooseState[tonumber(key) + 1] = tValue[3]
	end

	self.m_tBigRewardList[2] = tItem1

	local specialReward2 = self.m_tContent.rewardPool["3"]
	local tItem2 = {reward_ids1 = {}, reward_nums1 = {}, name = LocalStrings.SUMMERSURF_TEXT1[7], strAtt = LocalStrings.SUMMERSURF_TEXT1[17], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31}
	for key, value in pairs(specialReward2) do
		local tValue = SplitStringWithSeparator(value, ",", nil, true)
		local id = tValue[1]
		local num = tValue[2]

		tItem2.reward_ids1[tonumber(key) + 1] = id
		tItem2.reward_nums1[tonumber(key) + 1] = num
		tItem2.chooseState[tonumber(key) + 1] = tValue[3]
	end

	self.m_tBigRewardList[1] = tItem2
	WZLog("WndSummerSurf:_analyzeBigReward", Serialize(self.m_tBigRewardList))
end

--@brief    添加保存上次选择的葫芦
function WndSummerSurf:savePoleType()
    WZLog("WndSummerSurf:savePoleType")
    local _KeyString = ""
    local curDate = os.date("*t", SystemTime:getServerTime())
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = "CALABASH" .. tostring(CacheCenter:getPlayerInfo().id)
    local strValue =  data:getStringValue("SUMMERSURF_MARK", _KeyString)
    local curValue = self.m_nCalabashType
    data:setStringValue("SUMMERSURF_MARK", _KeyString, curValue)
    data:flush()
end

--@brief    获取上次保存的的葫芦
function WndSummerSurf:getPoleType()
    WZLog("WndSummerSurf:getPoleType")
    local _KeyString = ""
    local curDate = os.date("*t", SystemTime:getServerTime())
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = "CALABASH" .. tostring(CacheCenter:getPlayerInfo().id)
    local strValue =  data:getStringValue("SUMMERSURF_MARK", _KeyString)
    if strValue ~= nil and strValue ~= "" then 
		self.m_nCalabashType = tonumber(strValue)
		if self.m_nCalabashType ~= 0 then 
			GetElement(self.m_root, "cbgTool_WndSummerSurf", WZUICheckBoxGroup):setCheckIndex(self.m_nCalabashType)
		end
	end
end

--@brief    添加保存是否该活动的首次抽奖
function WndSummerSurf:saveOperateTimes()
    WZLog("WndSummerSurf:saveOperateTimes")
    local _KeyString = ""
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = "SUMMERSURF" .. tostring(CacheCenter:getPlayerInfo().id)
    local strValue =  data:getStringValue("SUMMERSURF_MARK", _KeyString)
    local curValue = self.m_nActivityId
    data:setStringValue("SUMMERSURF_MARK", _KeyString, curValue)
    data:flush()
end

--@brief    获取是否该活动的首次抽奖
--@return 	1:非首次抽奖；0首次抽奖
function WndSummerSurf:getOperateTimes()
    WZLog("WndSummerSurf:getOperateTimes")
    local _KeyString = ""
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = "SUMMERSURF" .. tostring(CacheCenter:getPlayerInfo().id)
    local strValue =  data:getStringValue("SUMMERSURF_MARK", _KeyString)
    if strValue ~= nil and strValue ~= "" and tonumber(strValue) == self.m_nActivityId then 
		return 1
	else
		return 0
	end
end
-------------------------------------私有方法模块End----------------------------------------
