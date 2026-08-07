--WndSpringOutingData.lua
--@brief	WndSpringOuting的数据模块
--@date		2023/02/23
--@author	XTX
--@note		春游踏青活动

WndSpringOuting = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSpringOuting:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_tBigRewardList = nil 		--大奖和特奖奖励
	self.m_bOpenState = false 
	self.m_tOpenResult = nil 
	self.m_nCoinId = 160423
	self.m_nMaxLotteryCount = 20    --最大抽奖次数
	self.m_nCount = 0 
	self.m_tBallAniName = {"wait", "run"}
	self.m_nAniType = 1 			--抽奖动画索引
	self.m_tScoreConfig = nil 
	self.m_tStepBoxConfig = nil 
	self.m_nCurScore = 0 	--当前步行积分
	self.m_nCurStep = 0 	--当前步行数
	self.m_nGiftRewardNum = 0 	--全服礼包数
	self.m_tMovePos = {{0.12, 0.74}, {0.13, 0.7}, {0.15, 0.67}, {0.17, 0.65}, {0.2, 0.62}, {0.23, 0.61}, {0.27, 0.56}, {0.31, 0.57}, {0.33, 0.55}, {0.37, 0.53}, {0.41, 0.52}, {0.44, 0.534}, {0.46, 0.58}, {0.465, 0.62}, {0.474, 0.67}, {0.488, 0.715}, {0.52, 0.73}, {0.56, 0.73}, {0.6, 0.72}, {0.645, 0.7}, {0.67, 0.66}, {0.69, 0.6}, {0.71, 0.57}, {0.73, 0.54}, {0.763, 0.54}, {0.805, 0.51}, {0.84, 0.5}, {0.88, 0.48}, {0.875, 0.42}, {0.84, 0.41}, {0.82, 0.39}, {0.79, 0.38}, {0.75, 0.37}, {0.717, 0.37}, {0.67, 0.36}, {0.65, 0.385}, {0.63, 0.385}, {0.61, 0.385}, {0.59, 0.385}, {0.57, 0.385}, {0.55, 0.385}, {0.52, 0.385}, {0.5, 0.385}, {0.47, 0.385}, {0.44, 0.385}, {0.42, 0.385}, {0.4, 0.385}, {0.37, 0.385}, {0.35, 0.385}, {0.32, 0.385}, {0.3, 0.385}, {0.28, 0.385}, {0.26, 0.385}, {0.24, 0.385}, {0.22, 0.385}, {0.2, 0.385}, {0.2, 0.36}, {0.2, 0.34}, {0.2, 0.32}, {0.2, 0.3}, {0.2, 0.28}, {0.2, 0.26}, {0.2, 0.24}, {0.22, 0.23}, {0.25, 0.21}, {0.25, 0.21}, {0.27, 0.21}, {0.29, 0.21}, {0.31, 0.21}, {0.33, 0.21}, {0.35, 0.21}, {0.37, 0.21}, {0.39, 0.21}, {0.41, 0.21}, {0.43, 0.21}, {0.45, 0.21}, {0.47, 0.21}, {0.49, 0.21}, {0.53, 0.184}, {0.56, 0.16}, {0.58, 0.137}, {0.58, 0.11}, {0.58, 0.09}, {0.58, 0.07}, {0.58, 0.05}, {0.58, 0.03}, {0.58, 0}, {0.58, -0.01}}
	self.m_nPosIndex = 1
	self.m_bIsOpenReward = false 
	self.m_nRecvRewardsPool = {}    --两个特殊奖池信息分两次协议接收，两个奖池都接收到，才显示奖池弹框
	self.m_nChooseReward = 0 		--选择奖励状态0：弹出预览界面；1：不弹
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSpringOuting:_unInit()
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
	self.m_nAniType = nil 
	self.m_tScoreConfig = nil 
	self.m_tStepBoxConfig = nil 
	self.m_nCurScore = nil 	--当前步行积分
	self.m_nCurStep = nil 	--当前步行数
	self.m_nGiftRewardNum = nil 	--全服礼包数
	self.m_tMovePos = nil 
	self.m_nPosIndex = nil 
	self.m_bIsOpenReward = nil 
	self.m_nRecvRewardsPool = nil    --两个特殊奖池信息分两次协议接收，两个奖池都接收到，才显示奖池弹框
	self.m_nChooseReward = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSpringOuting:createElement()
	if WndSpringOuting.m_root ~= nil then
		WindowManager:removeWindow(WndSpringOuting.m_root, WndSpringOuting, true)
	end
	local element = WZUISystem:getInstance():createElement("WndSpringOuting")
	assert(element, "WndSpringOuting create element failed!")
	self:_init()
	return element
end


--@brief 	外部接口
function WndSpringOuting:showInterface()
	LoadNewActivityRes(true)
	local wndWater = WndSpringOuting:createElement()
	if wndWater then 
		WindowManager:addWindow(wndWater, WndSpringOuting, false)
	end
end

--@brief 	获取活动详情成功
function WndSpringOuting:GetActivityInfoOK(activityId,maxCount,count,status, rewardCounts, rewardItems, rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	-- body
	WZLog("WndSpringOuting:GetActivityInfoOK", g_cityExtenInfo.activity7065, activityId)
	if g_cityExtenInfo.activity7065 == activityId then 
		self.m_tContent = json.decode(content)
		self.m_nStartTime = startTime 
		self.m_nEndTime = endTime 
		self.m_nActivityId = activityId
		self.m_nCount = count
		WZLog("self.m_tContentself.m_tContent", Serialize(self.m_tContent))
		local tempScoreReward = json.decode(self.m_tContent.scoreRewards)
		local tempScoreTarget = json.decode(self.m_tContent.scoreConfig)

		--步行积分配置
		self.m_tScoreConfig = {}
		local nSex = CacheCenter:getPlayerInfo().sex
		for j = 1, #tempScoreReward do
			local array = SplitStringWithSeparator(tempScoreReward[j], "&")
			local nSex = CacheCenter:getPlayerInfo().sex
			local tItem = {}
			tItem.reward = {}
			tItem.scoreTarget = tempScoreTarget[j]
			tItem.status = -1
			for i = 1, #array do
				local strTemp = string.sub(array[i], 2, -2) 
				local id = tonumber(SplitStringWithSeparator(strTemp,",")[nSex + 1])
				local num = tonumber(SplitStringWithSeparator(strTemp,",")[3])

				table.insert(tItem.reward, {id, num})
			end

			table.insert(self.m_tScoreConfig, tItem)
		end
		--步数宝箱配置
		local tempStepReward = json.decode(self.m_tContent.giftRewards)
		local tempStepTarget = json.decode(self.m_tContent.giftConfig)
		self.m_tStepBoxConfig = {}
		for j = 1, #tempStepReward do
			local array = SplitStringWithSeparator(tempStepReward[j], "&")
			local nSex = CacheCenter:getPlayerInfo().sex
			local tItem = {}
			tItem.reward = {}
			tItem.stepTarget = tempStepTarget[j]
			tItem.status = -1
			for i = 1, #array do
				local strTemp = string.sub(array[i], 2, -2) 
				local id = tonumber(SplitStringWithSeparator(strTemp,",")[nSex + 1])
				local num = tonumber(SplitStringWithSeparator(strTemp,",")[3])

				table.insert(tItem.reward, {id, num})
			end

			table.insert(self.m_tStepBoxConfig, tItem)
		end
		self.m_nChooseReward = GetOperateTimes("SPRINGOUTINGACTIVITYID", self.m_nActivityId)

		self:_analyzeBigReward()
		self:_update()
	end
end

--@brief 	获取其他活动数据
function WndSpringOuting:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end 

	if doType == 1 then 
		local tResult = json.decode(jsonData)
		WZLog("WndSpringOuting:_onGetOtherData 111", Serialize(tResult))
		self.m_nCurScore = tResult.score
		self.m_nCurStep = tResult.giftTimes 	--当前步行数
		self.m_nGiftRewardNum = tResult.globalNum
		--更新积分宝箱的状态
		for i = 1, #tResult.scoreRewardStatus do
			self.m_tScoreConfig[i].status = tResult.scoreRewardStatus[i]
		end
		--更新步数宝箱的状态
		for i = 1, #tResult.giftRewardStatus do
			self.m_tStepBoxConfig[i].status = tResult.giftRewardStatus[i]
		end

		self:_showProgress()
		self:showBagGiftInfo()
	elseif doType == 2 then --获取踏青大奖、步数狂魔奖
		--[[
			{
				pool	: int 大奖类型 1:踏青大奖 2:步数狂魔奖,
				rewards	: '大奖奖池物品 [男物品id,女物品id,数量]&[...',
				globalLimitConfig	: '大奖全局日限量配置 [限量数量,限量数量]',
				playerLimitConfig	: '大奖个人日限量配置 [限量数量,限量数量]',
				globalLimit	: int[]大奖全局日限量,
				playerLimit	: int[]大奖个人日限量,
				optionalList	: int[]大奖奖选中下标
			}
		]]
		local tResult = json.decode(jsonData)
		--WZLog("WndSpringouting:_onGetOtherData 222", Serialize(tResult))
		WZLog("WndSpringouting:_onGetOtherData 222 self.m_nRecvRewardsPool = ", Serialize(self.m_nRecvRewardsPool))

		local pool = tonumber(tResult.pool)
		if pool and pool == 1 then
			self.m_nRecvRewardsPool.pool1 = true
			local nSex = CacheCenter:getPlayerInfo().sex
			local sBigReward = tResult.rewards
			local array = SplitStringWithSeparator(sBigReward, "&")

			local tItem = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.SPRINGOUTING_TEXT1[9]}
			tItem = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.SPRINGOUTING_TEXT1[9], strAtt = LocalStrings.DETECTIVE_TEXT1[16], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31, pool = pool}
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
		elseif pool == 2 then
			self.m_nRecvRewardsPool.pool2 = true
			local nSex = CacheCenter:getPlayerInfo().sex
			local sBigReward = tResult.rewards
			local array = SplitStringWithSeparator(sBigReward, "&")

			local tItem = {reward_ids = {}, reward_nums = {}, name = LocalStrings.SPRINGOUTING_TEXT1[10] }
			tItem = {reward_ids = {}, reward_nums = {}, name = LocalStrings.SPRINGOUTING_TEXT1[10], strAtt = LocalStrings.DETECTIVE_TEXT1[16], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31, pool = pool}
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

				table.insert(tItem.reward_ids, id)
				table.insert(tItem.reward_nums, num)
			end

			self.m_tBigRewardList[3] = tItem
		end
		WZLog("WndSpringouting:_onGetOtherData 222 self.m_nRecvRewardsPool = ", Serialize(self.m_nRecvRewardsPool))

		if self.m_bIsOpenReward and self.m_nRecvRewardsPool.pool1 == true and self.m_nRecvRewardsPool.pool2 == true then 
			self.m_bIsOpenReward = false 
			local otherData = {}
			otherData.winType = 1
			otherData.activityId = self.m_nActivityId
			otherData.otherRewardData = self.m_tBigRewardList[3]
			WndJoinReward:showInterface("", self.m_tBigRewardList[1], self.m_tBigRewardList[2], LocalStrings.TREASURE_TEXT7, false, 3, otherData, 3)
		end
	elseif doType == 3 then --开启结果
		local tResult = json.decode(jsonData)
		WZLog("WndSpringOuting:_onGetOtherData 333", Serialize(tResult))
		self.m_tOpenResult = {}

		self.m_tOpenResult.normalRewards = {} --常规奖
		self.m_tOpenResult.firstRewards = {} --小礼奖
		self.m_tOpenResult.bigRewards = {} --大礼奖
		self.m_tOpenResult.addScore = 0 --增加的积分
		self.m_tOpenResult.addStep = 0 --增加的步数

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
		local strTitleFormat = [[<T C="255,255,255" S="36" P="1" SC="7,142,11" SS="4" SE="1">%s</T>]]
		--大奖
		if tResult.fItemIds then 
			for j = 1, #tResult.fItemIds do
				local tItem = {}

				tItem.itemId = tResult.fItemIds[j]
				tItem.itemNum = tResult.fItemNums[j]
				tItem.type = bigRewardType
				tItem.imgRewardTitle = "ui/newActivity/bt_text_cytq_tqxj.png"
				tItem.imgBK = "ui/newActivity/hd_pic_cytq_tqxj.png"
			--	tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
				tItem.imgBKPt = GlobalMethod:ccp(0.5, 0.5)
				tItem.goodsconPt = GlobalMethod:ccp(0.5, 0.5)
				tItem.strTitle = string.format(strTitleFormat, LocalStrings.SPRINGOUTING_TEXT1[8])
				tItem.spineEffect = {path = "activity/ui_tq_ptj", _sIndex = "ui_tq_ptj", play = "wait1"}

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
			tItem.imgRewardTitle = "ui/newActivity/bt_text_cytq_tqdj.png"
			tItem.imgBK = "ui/newActivity/hd_pic_cytq_tqdj.png"
			tItem.goodsconPt = GlobalMethod:ccp(0.5, 0.5)
			tItem.imgBKPt = GlobalMethod:ccp(0.49,0.5)
			tItem.strTitle = string.format(strTitleFormat, LocalStrings.SPRINGOUTING_TEXT1[9])
			tItem.spineEffect = {path = "activity/ui_tq_dj", _sIndex = "ui_tq_dj", play = "wait1"}

			table.insert(self.m_tOpenResult.bigRewards, tItem)
		end

		--狂魔奖
		strTitleFormat = [[<T C="255,255,255" S="36" P="1" SC="222,78,0" SS="4" SE="1">%s</T>]]
		for j = 1, #tResult.nItems do
			local tItem = {}

			tItem.itemId = tResult.nItems[j]
			tItem.itemNum = tResult.nItemNums[j]
			tItem.type = bigRewardType
			tItem.imgRewardTitle = "ui/newActivity/bt_text_cytq_bskmj.png"
			tItem.titlePt = GlobalMethod:ccp(0.5,0.95)
			tItem.imgBK = "ui/newActivity/hd_pic_cytq_bskmj.png"
			tItem.imgBKPt = GlobalMethod:ccp(0.49,0.5)
			tItem.goodsconPt = GlobalMethod:ccp(0.5, 0.5)
			tItem.imgBKPt = GlobalMethod:ccp(0.49,0.5)
			tItem.bIsShowLongBg = true 
			tItem.strTitle = string.format(strTitleFormat, LocalStrings.SPRINGOUTING_TEXT1[10])
			tItem.txtTitlePt = GlobalMethod:ccp(0.5,0.98)
			tItem.imgLongBg = "ui/common/common_jl_di_05.png"
			tItem.spineEffect = {path = "activity/ui_tq_kmj", _sIndex = "ui_tq_kmj", play = "wait1"}

			table.insert(self.m_tOpenResult.bigRewards, tItem)
		end

		if result == 1 then 
			self.m_nCount = tResult.count
			self.m_tOpenResult.addScore = tResult.score --增加的积分
			self.m_tOpenResult.addStep = tResult.bsNum --增加的步数
			
			self:showOpenAction()
			self:_setFreeBtnText()
		else
			self:setOpenState(false)
		end
	elseif doType == 4 then --领取步行积分奖励
		local tResult = json.decode(jsonData)
		WZLog("WndSpringOuting:_onGetOtherData 444", Serialize(tResult))
		if result == 0 then 
			WndRewardShow:showById(tResult.itemIds, tResult.itemNums)
			--刷新积分宝箱状态
			self.m_tScoreConfig[tResult.scoreType + 1].status = tResult.status
			if tResult.status == 0 then 
				GetElement(self.m_root, "spineScoreBox" .. (tResult.scoreType + 1) .. "_WndSpringOuting", WZUISpine):play("wait1_" .. (tResult.scoreType + 1), true)
			else
				GetElement(self.m_root, "spineScoreBox" .. (tResult.scoreType + 1) .. "_WndSpringOuting", WZUISpine):play("wait" .. (tResult.scoreType + 1), true)
			end
			self.m_tScoreConfig[tResult.scoreType + 1].lastStatus = tResult.status
		end
	elseif doType == 5 then --领取步数宝箱奖励
		local tResult = json.decode(jsonData)
		WZLog("WndSecretTower:_onGetOtherData 555", Serialize(tResult))
		if result == 0 then 
			WndRewardShow:showById(tResult.itemIds, tResult.itemNums)
			--刷新积分宝箱状态
			self.m_tStepBoxConfig[tResult.giftType + 1].status = tResult.status
			if tResult.status == 0 then 
				GetElement(self.m_root, "spineStepBox" .. (tResult.giftType + 1) .. "_WndSpringOuting", WZUISpine):play("wait1_" .. (tResult.giftType + 1), true)
			else
				GetElement(self.m_root, "spineStepBox" .. (tResult.giftType + 1) .. "_WndSpringOuting", WZUISpine):play("wait" .. (tResult.giftType + 1), true)
			end
			self.m_tStepBoxConfig[tResult.giftType + 1].lastStatus = tResult.status
		end
	elseif doType == 6 then --领取全服踏青奖励
		local tResult = json.decode(jsonData)
		WZLog("WndSecretTower:_onGetOtherData 666", Serialize(tResult))
		if result == 1 then 
			WndRewardShow:showById(tResult.itemIds, tResult.itemNums)
			self.m_nGiftRewardNum = 0
			self:showBagGiftInfo()
		end
	elseif doType == 7 then --选择奖励
		local tResult = json.decode(jsonData)
		WZLog("WndSpringouting:_onGetOtherData 777", Serialize(tResult))
		if result == 0 then 
			local tTempList = nil 
			if tResult.pool == 1 then 
				tTempList = self.m_tBigRewardList[2]
			elseif tResult.pool == 2 then 
				tTempList = self.m_tBigRewardList[3]
			end
			tTempList.chooseState[tResult.id + 1] = tResult.status
			if tResult.status == 1 then 
				WndJoinReward:chooseReturn(tResult.pool + 1, tResult.id + 1, tResult.status)
			end
		elseif result == 1 then
			MsgBoxManager:showTipBox(LocalStrings.SUMMERSURF_TEXT1[24])
		end
	end
end

--@brief	缓存推送更新物品时调用的函数
function WndSpringOuting:updatePlayerItemData()
	WZLog("WndSpringOuting:updatePlayerItemData")
	if self.m_root ~= nil then
		self:_updateLightNum()
	end
end

--@brief 	设置射箭的状态
function WndSpringOuting:setOpenState(state)
	-- body
	if self.m_root == nil then return end 

	self.m_bOpenState = state
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	关闭抽奖奖励展示界面回调
function WndSpringOuting:_afterCloseReward()
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

	if self.m_tOpenResult.normalRewards and #self.m_tOpenResult.normalRewards > 0 then 
		WndHoraryBigReward:showInterface(8, self.m_tOpenResult.normalRewards, tBigReward)
	elseif #tBigReward > 0 then 
		WndHoraryBigReward:showInterface(9, tBigReward)
	end
end

--@brief 	解析大奖数据
function WndSpringOuting:_analyzeBigReward()
	-- body
	local sBigReward = self.m_tContent.firstRewards
	local array = SplitStringWithSeparator(sBigReward, "&")
	local nSex = CacheCenter:getPlayerInfo().sex
	local tItem = {reward_ids1 = {}, reward_nums1 = {}, name = LocalStrings.SPRINGOUTING_TEXT1[8]}
	self.m_tBigRewardList = {}
	for i = 1, #array do
--		WZLog("WndSpringOuting:_analyzeBigReward", string.sub(array[i], 2, -2))
		local string = string.sub(array[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string,",")[3])

		table.insert(tItem.reward_ids1, id)
		table.insert(tItem.reward_nums1, num)
	end

	self.m_tBigRewardList[1] = tItem

	local specialReward = self.m_tContent.superRewards
	local array1 = SplitStringWithSeparator(specialReward, "&")
	local tItem1 = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.SPRINGOUTING_TEXT1[9] }
	for i = 1, #array1 do
--		WZLog("WndSpringOuting:_analyzeBigReward", string.sub(array1[i], 2, -2))
		local string = string.sub(array1[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string, ",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string, ",")[3])
		
		table.insert(tItem1.reward_ids2, id)
		table.insert(tItem1.reward_nums2, num)
	end

	self.m_tBigRewardList[2] = tItem1

	local specialReward2 = self.m_tContent.normalRewards
	local array2 = SplitStringWithSeparator(specialReward2, "&")
	local tItem2 = {reward_ids = {}, reward_nums = {}, name = LocalStrings.SPRINGOUTING_TEXT1[10]}
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

--@brief    添加保存是否主动弹感恩打卡活动设置
function WndSpringOuting:saveAutoActivity()
    WZLog("WndSpringOuting:saveAutoActivity")
    local _KeyString = ""
    local curDate = os.date("*t", SystemTime:getServerTime())
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = "SPRINGOUTING" .. tostring(CacheCenter:getPlayerInfo().id)
    local strValue =  data:getStringValue("CALABASH_MARK", _KeyString)
    local curValue = self.m_nPosIndex
   
    data:setStringValue("CALABASH_MARK", _KeyString, curValue)
    data:flush()
end

--@brief    获取上次保存的感恩打卡活动设置
function WndSpringOuting:getAutoActivity()
    WZLog("WndSpringOuting:getAutoActivity")
    local _KeyString = ""
    local curDate = os.date("*t", SystemTime:getServerTime())
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = "SPRINGOUTING" .. tostring(CacheCenter:getPlayerInfo().id)
    local strValue =  data:getStringValue("CALABASH_MARK", _KeyString)
    WZLog("WndSpringOuting:getAutoActivity", strValue)
    if strValue ~= nil and strValue ~= "" then
        self.m_nPosIndex = tonumber(strValue)
    end
end


-------------------------------------私有方法模块End----------------------------------------
