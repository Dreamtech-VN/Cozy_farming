--WndZooSightseeingData.lua
--@brief	WndZooSightseeing的数据模块
--@date		2024/11/15
--@author	yrd
--@note		动物园观光

WndZooSightseeing = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndZooSightseeing:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_tBigRewardList = nil 		--大奖和特奖奖励
	self.m_bOpenState = false 
	self.m_tOpenResult = nil 
	self.m_nCoinId = 160772
	self.m_nCoinId2 = 160773
	self.m_nMaxLotteryCount = 20    --最大抽奖次数
	self.m_nCount = 0 
	self.m_tBallAniName = {{"", "wait1_1", "wait1_2"}, {"", "wait2_1", "wait2_2"}}
	self.m_nCalabashType = 0 			--当前选中的力度索引
	self.m_tCostByType = nil 
	self.m_nChooseReward = 0 		--选择奖励状态0：弹出预览界面；1：不弹
	self.m_nTalkGapping = nil 
	self.m_nLastTalkIndex = 0
	self.m_bIsOpenReward = false 
	self.m_nAniType = 1 
	self.m_tLvRewardList = nil 
	self.m_nCurExp = 0 
	self.m_tGetTimes = {}
	self.m_bIsFirstIn = true 
	self.m_bIsBlessing = false 		--是否正在祈福中
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndZooSightseeing:_unInit()
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
	self.m_nCalabashType = nil 			--当前选中的力度索引
	self.m_tCostByType = nil 
	self.m_nChooseReward = nil 		--选择奖励状态0：弹出预览界面；1：不弹
	self.m_nTalkGapping = nil 
	self.m_nLastTalkIndex = nil 
	self.m_bIsOpenReward = nil 
	self.m_nAniType = nil 
	self.m_tLvRewardList = nil 
	self.m_nCurExp = nil  	 	
	self.m_tGetTimes = nil 
	self.m_bIsFirstIn = nil  
	self.m_bIsBlessing = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndZooSightseeing:createElement()
	if WndZooSightseeing.m_root ~= nil then
		WindowManager:removeWindow(WndZooSightseeing.m_root, WndZooSightseeing, true)
	end
	local element = WZUISystem:getInstance():createElement("WndZooSightseeing")
	assert(element, "WndZooSightseeing create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndZooSightseeing:showInterface()
	LoadNewActivityRes(true)
	local wndWater = WndZooSightseeing:createElement()
	if wndWater then 
		WindowManager:addWindow(wndWater, WndZooSightseeing, false)
	end
end

--@brief 	获取活动详情成功
function WndZooSightseeing:GetActivityInfoOK(activityId,maxCount,count,status, rewardCounts, rewardItems, rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	-- body
	WZLog("WndZooSightseeing:GetActivityInfoOK", activityId)
	if g_cityExtenInfo.activity7147 == activityId then 
		self.m_tContent = json.decode(content)
		self.m_nStartTime = startTime 
		self.m_nEndTime = endTime 
		self.m_nActivityId = activityId
		self.m_nCount = count
		WZLog("self.m_tContentself.m_tContent", Serialize(self.m_tContent))
		self.m_tCostByType = finishCondition

		self.m_nChooseReward = GetOperateTimes("OPERATETIMES_7147", self.m_nActivityId)
		if self.m_tLvRewardList == nil then 
			self.m_tLvRewardList = {}
		end
		local tLvRewards = self.m_tContent.scoreRewards
		for i = 1, #self.m_tContent.scoreConfig do
			if self.m_tLvRewardList[i] == nil then 
				self.m_tLvRewardList[i] = {}
			end
			self.m_tLvRewardList[i].lv = i
			self.m_tLvRewardList[i].name = LocalStrings.ZOO_SIGHTSEEING_TEXT1[17][i + 1]
			self.m_tLvRewardList[i].reward = tLvRewards[i]
			self.m_tLvRewardList[i].exp = self.m_tContent.scoreConfig[i]
			self.m_tLvRewardList[i].activityId = activityId
		end

		self:_showLvAndExp()
		self:_update()

		self.m_tGiftRewards = {}
		local nSex = CacheCenter:getPlayerInfo().sex
		local arrGift = SplitStringWithSeparator(self.m_tContent.giftRewards, "&")
		for i = 1, #arrGift do
			local tItem = {}
			local strGift = string.sub(arrGift[i], 2, -2) 
			local id = tonumber(SplitStringWithSeparator(strGift,",")[nSex + 1])
			local num = tonumber(SplitStringWithSeparator(strGift,",")[3])

			table.insert(tItem, id)
			table.insert(tItem, num)
			table.insert(self.m_tGiftRewards, tItem)
		end
		self.m_tGiftMultipleConfig = {}
		local nSex = CacheCenter:getPlayerInfo().sex
		local arrGift = SplitStringWithSeparator(self.m_tContent.giftMultipleConfig, "&")
		for i = 1, #arrGift do
			local num = tonumber(string.sub(arrGift[i], 2, -2))

			table.insert(self.m_tGiftMultipleConfig, num)
		end

		self:_showWheelItems()
	end
end

--@brief 	获取其他活动数据
function WndZooSightseeing:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end 

	if doType == 1 then --等级奖励数据
		local tResult = json.decode(jsonData)
		WZLog("WndZooSightseeing:_onGetOtherData 111", Serialize(tResult))
		self.m_nCurExp = tResult.score

		local bUpdateShow = true 
		if self.m_tLvRewardList == nil then 
			self.m_tLvRewardList = {}
			bUpdateShow = false
		end
		for i = 1, #tResult.scoreRewardStatus do
			if self.m_tLvRewardList[i] == nil then 
				self.m_tLvRewardList[i] = {}
			end
			self.m_tLvRewardList[i].status = tResult.scoreRewardStatus[i] + 1
		end
		if bUpdateShow then 
			self:_showLvAndExp()
		end

		self:showRedDot()
		self:_setFreeBtnText()
		if self.m_bIsFirstIn then 
			self.m_bIsFirstIn = false 
		end
	elseif doType == 2 then --等级奖励数据
		local tResult = json.decode(jsonData)
		WZLog("WndZooSightseeing:_onGetOtherData 222", Serialize(tResult))
		table.insert(self.m_tGetTimes, tResult.pool)
		local nSex = CacheCenter:getPlayerInfo().sex
		local sBigReward = tResult.rewards
		local array = SplitStringWithSeparator(sBigReward, "&")
		if tResult.pool == 0 then 
			local tItem = {reward_ids = {}, reward_nums = {}, name = LocalStrings.ZOO_SIGHTSEEING_TEXT1[12], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5}
			for i = 1, #array do
				local string = string.sub(array[i], 2, -2) 
				local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
				local num = tonumber(SplitStringWithSeparator(string,",")[3])

				table.insert(tItem.reward_ids, id)
				table.insert(tItem.reward_nums, num)
			end

			self.m_tBigRewardList[3] = tItem
		elseif tResult.pool == 1 then 
			local tItem = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.ZOO_SIGHTSEEING_TEXT1[13], strAtt = LocalStrings.REWARDTIPS_TEXT, listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31, pool = tResult.pool}
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
		elseif tResult.pool == 2 then 
			local tItem = {reward_ids1 = {}, reward_nums1 = {}, name = LocalStrings.ZOO_SIGHTSEEING_TEXT1[14], strAtt = LocalStrings.REWARDTIPS_TEXT, listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31, pool = tResult.pool}
			for i = 1, #array do
				local string = string.sub(array[i], 2, -2) 
				local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
				local num = tonumber(SplitStringWithSeparator(string,",")[3])

				table.insert(tItem.reward_ids1, id)
				table.insert(tItem.reward_nums1, num)
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

			self.m_tBigRewardList[1] = tItem
		end
		if self.m_bIsOpenReward and self.m_tGetTimes and #self.m_tGetTimes == 3 then 
			self.m_bIsOpenReward = false 
			local otherData = {}
			otherData.winType = 1
			otherData.activityId = self.m_nActivityId
			otherData.otherRewardData = self.m_tBigRewardList[3]
			otherData.chooseInfo = {strKey="ZOO_SIGHTSEEING_TEXT1", wordIndex=12, doType=4}
			WndJoinReward:showInterface("", self.m_tBigRewardList[1], self.m_tBigRewardList[2], LocalStrings.WATERMELON_TEXT1[22], false, 3, otherData)
		end
	elseif doType == 3 then --开启结果
		local tResult = json.decode(jsonData)
		WZLog("WndZooSightseeing:_onGetOtherData 333", Serialize(tResult))
		self.m_tOpenResult = {}

		self.m_tOpenResult.normalRewards = {} --常规奖
		self.m_tOpenResult.otherRewards = {} --小礼奖
		self.m_tOpenResult.bigRewards = {} --大礼奖

		local rewardType = 8 
		local itemIdIndex = 1
		if tResult.itemIds then 
			for i = 1, #tResult.itemIds do
				local tItem = {}
				tItem.itemId = tResult.itemIds[i]
				tItem.itemNum = tResult.itemNums[i]
				tItem.type = rewardType
				tItem.imgRewardTitle = "ui/newActivity/bt_text_gxhd_2.png"
				tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
				tItem.playerItemId = tResult.playerItemIds[itemIdIndex]
				table.insert(self.m_tOpenResult.normalRewards, tItem)

				itemIdIndex = itemIdIndex + 1
			end
		end
		--大奖
		local strTitleFormat = [[<T C="255,255,255" S="46" P="1" SC="222,78,0" SS="4" SE="1">%s</T>]]
		local bigRewardType = 26 
		if tResult.fItemIds then 
			for i = 1, #tResult.fItemIds do
				local tItem = {}

				tItem.itemId = tResult.fItemIds[i]
				tItem.itemNum = tResult.fItemNums[i]
				tItem.type = bigRewardType
				tItem.imgRewardTitle = "ui/newActivity/bt_text_ty_dxj.png"
				tItem.imgBK = "ui/specialBg/hd_pic_ty_xj.png"
				tItem.playerItemId = tResult.playerItemIds[itemIdIndex]
				tItem.strTitle = string.format(strTitleFormat, LocalStrings.ZOO_SIGHTSEEING_TEXT1[12])
				tItem.txtTitlePt = {0.5,0.885}
				tItem.spineEffect = {path = "activity/ui_bengchuang_xj", _sIndex = "ui_bengchuang_xj", play = "wait1"}

				table.insert(self.m_tOpenResult.bigRewards, tItem)

				itemIdIndex = itemIdIndex + 1
			end
		end
		--特奖
		if tResult.sItemIds then 
			for i = 1, #tResult.sItemIds do
				local tItem = {}
				tItem.itemId = tResult.sItemIds[i]
				tItem.itemNum = tResult.sItemNums[i]
				tItem.playerItemId = tResult.playerItemIds[itemIdIndex]
				tItem.type = bigRewardType
				tItem.imgRewardTitle = "ui/newActivity/bt_text_ty_dxj.png"
				tItem.imgBK = "ui/specialBg/hd_pic_ty_dj.png"
				tItem.goodsconPt = {0.515, 0.498}
				tItem.strTitle = string.format(strTitleFormat, LocalStrings.ZOO_SIGHTSEEING_TEXT1[13])
				tItem.txtTitlePt = {0.5,0.885}
				tItem.spineEffect = {path = "activity/ui_bengchuang_drj", _sIndex = "ui_bengchuang_drj", play = "wait1"}

				table.insert(self.m_tOpenResult.bigRewards, tItem)
				
				itemIdIndex = itemIdIndex + 1
			end
		end

		--大神奖
		if tResult.nItemIds then 
			for i = 1, #tResult.nItemIds do
				local tItem = {}
				tItem.itemId = tResult.nItemIds[i]
				tItem.itemNum = tResult.nItemNums[i]
				tItem.playerItemId = tResult.playerItemIds[itemIdIndex]
				tItem.type = bigRewardType
				tItem.imgRewardTitle = "ui/newActivity/bt_text_ty_tj.png"
				tItem.imgBK = "ui/specialBg/hd_pic_ty_tj.png"
				tItem.titlePt = {0.5,0.97}
				tItem.strTitle = string.format(strTitleFormat, LocalStrings.ZOO_SIGHTSEEING_TEXT1[14])
				tItem.txtTitlePt = {0.5,0.95}
				tItem.spineEffect = {path = "activity/ui_bengchuang_mxj", _sIndex = "ui_bengchuang_mxj", play = "wait1"}

				table.insert(self.m_tOpenResult.bigRewards, tItem)
			
				itemIdIndex = itemIdIndex + 1
			end
		end

		--茶叶奖励
		if tResult.gItemIds and #tResult.gItemIds > 0 then 
			for i = 1, #tResult.gItemIds do
				local bIsExist = false 
				for j = 1, #self.m_tOpenResult.otherRewards do
					if self.m_tOpenResult.otherRewards[j][1] == tResult.gItemIds[i] then 
						bIsExist = true
						self.m_tOpenResult.otherRewards[j][2] = self.m_tOpenResult.otherRewards[j][2] + tResult.gItemNums[i]
						break 
					end
				end
				if not bIsExist then 
					local tItem = {tResult.gItemIds[i], tResult.gItemNums[i]}

					table.insert(self.m_tOpenResult.otherRewards, tItem)
				end
			end
		end

		if result == 1 then 
			self.m_nCount = tResult.count
			self.m_tOpenResult.addScore = tResult.score
			self.m_tOpenResult.addShopNum = tResult.shopNum

			self:showOpenAction()
			self:_setFreeBtnText()
		else
			self:setOpenState(false)
		end
	elseif doType == 4 then --选择奖励
		local tResult = json.decode(jsonData)
		WZLog("WndZooSightseeing:_onGetOtherData 444", Serialize(tResult))
		if result == 0 then 
			local tTempList = nil 
			local nTag = 0
			if tResult.pool == 1 then 
				tTempList = self.m_tBigRewardList[2]
				nTag = 2
			elseif tResult.pool == 2 then 
				tTempList = self.m_tBigRewardList[1]
				nTag = 3
			end
			tTempList.chooseState[tResult.id + 1] = tResult.status
			WndJoinReward:chooseReturn(nTag, tResult.id + 1, tResult.status)
		elseif result == 1 then
			MsgBoxManager:showTipBox(LocalStrings.SUMMERSURF_TEXT1[24])
		end
	elseif doType == 5 then --领取等级奖励
		local tResult = json.decode(jsonData)
		WZLog("WndZooSightseeing:_onGetOtherData 666", Serialize(tResult))
		if result == 0 then 
			self.m_tLvRewardList[tResult.id + 1].status = 2
			WndRewardShow:showById(tResult.itemIds, tResult.itemNums)

			self:showRedDot()
			self:_createLvRewardList()
		end
	elseif doType == 8 then
		local tResult = json.decode(jsonData)
		WZLog("WndZooSightseeing:_onGetOtherData 666", Serialize(tResult))
		if result == 0 then 
			-- WndRewardShow:showById(tResult.itemIds, tResult.itemNums)
			self.m_tBlessItemIds = tResult.itemIds
			self.m_tBlessItemNums = tResult.itemNums

			self.m_tBlessId = tResult.ids[1] + 1

			for i=1,#self.m_tGiftMultipleConfig do
				if self.m_tGiftMultipleConfig[i] == tResult.multipleNum then
					self.m_nBlessMultiple = i
					break
				end
			end

			self:_startRoll()
		end
	end
end

--@brief	缓存推送更新物品时调用的函数
function WndZooSightseeing:updatePlayerItemData()
	WZLog("WndZooSightseeing:updatePlayerItemData")
	if self.m_root ~= nil then
		self:_updateLightNum()
	end
end

--@brief 	设置射箭的状态
function WndZooSightseeing:setOpenState(state)
	-- body
	if self.m_root == nil then return end 

	self.m_bOpenState = state
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	关闭抽奖奖励展示界面回调
function WndZooSightseeing:_afterCloseReward()
	if self.m_root == nil then return end 

	if self.m_tOpenResult.normalRewards and #self.m_tOpenResult.normalRewards > 0 then 
		WndHoraryBigReward:showInterface(8, self.m_tOpenResult.normalRewards, self.m_tOpenResult.bigRewards)
	elseif #self.m_tOpenResult.bigRewards > 0 then 
		WndHoraryBigReward:showInterface(9, self.m_tOpenResult.bigRewards)
	end
end

--@brief 	获取当前捕鼠等级
function WndZooSightseeing:getCurLvInfo()
	local nLevel = 0 
	for i = 1, #self.m_tLvRewardList do
		if self.m_tLvRewardList[i].exp <= self.m_nCurExp and nLevel < self.m_tLvRewardList[i].lv then 
			nLevel = self.m_tLvRewardList[i].lv  
		end
	end
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




-------------------------------------私有方法模块End----------------------------------------
