--WndEightYearData.lua
--@brief	WndEightYear的数据模块
--@date		2024/03/29
--@author	XTX
--@note		8周年庆典活动主界面

WndEightYear = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndEightYear:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_tBigRewardList = nil 		--大奖和特奖奖励
	self.m_bOpenState = false 
	self.m_tOpenResult = nil 
	self.m_nCoinId = 160640
	self.m_nCoinId2 = 160641
	self.m_nCoinId3 = 160652
	self.m_nCoinId4 = 160642
	self.m_nCoinId5 = 160643
	self.m_nMaxLotteryCount = 20    --最大抽奖次数
	self.m_nCount = 0 
	self.m_tBallAniName = {{"wait_dangao", "qdg_1", "qdg_2"}}
	self.m_nCalabashType = 0 			--当前选中的力度索引
	self.m_tCostByType = nil 
	self.m_nChooseReward = 0 		--选择奖励状态0：弹出预览界面；1：不弹
	self.m_bIsOpenReward = false 
	self.m_nAniType = 1 
	self.m_tGetTimes = {} 
	self.m_nGiftRewardNum = 0 		--全民探索奖励数量
	self.m_nGiftRewardConfig = nil  --全民搜索产出配置 
	self.m_tTempList = {7121, 7122, 7120, 7123}
	self.m_tActivityList = nil
	self.m_nActivityIndex = 1 
	self.m_tTaskData = nil 
	self.m_tDayTaskItemCell = nil 
	self.m_tMakeCost = nil 
	self.m_nNum = 1
	self.m_tLibraryData = nil 
	self.m_nFreshTimes = 0 --刷新次数
	self.m_tGoodsData = nil 
	self.m_nPageIndex = nil 
	self.m_nAllPage = nil 
	self.m_tCellExchange = nil 
	self.m_tBuyData = nil 
	self.m_tMyOrderData = {}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndEightYear:_unInit()
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
	self.m_nCoinId3 = nil
	self.m_nCoinId4 = nil
	self.m_nCoinId5 = nil
	self.m_nMaxLotteryCount = nil    --最大抽奖次数
	self.m_nCount = nil 
	self.m_tBallAniName = nil
	self.m_nCalabashType = nil 			--当前选中的力度索引
	self.m_tCostByType = nil 
	self.m_nChooseReward = nil 		--选择奖励状态0：弹出预览界面；1：不弹
	self.m_bIsOpenReward = nil 
	self.m_nAniType = nil 
	self.m_tGetTimes = nil 
	self.m_nGiftRewardNum = nil 		--全民探索奖励数量
	self.m_nGiftRewardConfig = nil  --全民搜索产出配置 
	self.m_tTempList = nil 
	self.m_tActivityList = nil 
	self.m_nActivityIndex = nil 
	self.m_tTaskData = nil 
	self.m_tDayTaskItemCell = nil 
	self.m_tMakeCost = nil 
	self.m_nNum = nil 
	self.m_tLibraryData = nil 
	self.m_nFreshTimes = nil --刷新次数
	self.m_tGoodsData = nil 
	self.m_nPageIndex = nil 
	self.m_nAllPage = nil 
	self.m_tCellExchange = nil 
	self.m_tBuyData = nil 
	self.m_tMyOrderData = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndEightYear:createElement()
	if WndEightYear.m_root ~= nil then
		WindowManager:removeWindow(WndEightYear.m_root, WndEightYear, true)
	end
	local element = WZUISystem:getInstance():createElement("WndEightYear")
	assert(element, "WndEightYear create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndEightYear:showInterface()
	LoadNewActivityRes(true)
	local wndWater = WndEightYear:createElement()
	if wndWater then 
		WindowManager:addWindow(wndWater, WndEightYear, false)
	end
end

--@brief 	获取活动详情成功
function WndEightYear:GetActivityInfoOK(activityId,maxCount,count,status, rewardCounts, rewardItems, rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	-- body
	WZLog("WndEightYear:GetActivityInfoOK", activityId)
	if g_cityExtenInfo.activity7120 == activityId then --吃蛋糕
		self.m_tContent = json.decode(content)
		self.m_nStartTime = startTime 
		self.m_nEndTime = endTime 
		self.m_nActivityId = activityId
		self.m_nCount = count
	--	WZLog("self.m_tContentself.m_tContent", Serialize(self.m_tContent))
		self.m_nGiftRewardConfig = self.m_tContent.globalConfig[1]
		self.m_tCostByType = {finishCondition[1]}

		self.m_nChooseReward = GetOperateTimes("EIGHTYEARACTIVITYID", self.m_nActivityId)
		GetElement(self.m_root, "imgBg02_WndEightYear", WZUIImage):setVisible(true)
		GetElement(self.m_root, "imgBg03_WndEightYear", WZUIImage):setVisible(true)
		self:_update()
	elseif g_cityExtenInfo.activity7121 == activityId then --周年庆典
		self.m_tContent = content
		self.m_nStartTime = startTime 
		self.m_nEndTime = endTime 
		self.m_nActivityId = activityId
		GetElement(self.m_root, "imgBg02_WndEightYear", WZUIImage):setVisible(false)
		GetElement(self.m_root, "imgBg03_WndEightYear", WZUIImage):setVisible(false)

		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, 2)
	elseif g_cityExtenInfo.activity7122 == activityId then --制作蛋糕
		self.m_tContent = json.decode(content)
		self.m_nStartTime = startTime 
		self.m_nEndTime = endTime 
		self.m_nActivityId = activityId
		self.m_tMakeCost = self.m_tContent.giftCostConfig
		GetElement(self.m_root, "imgBg02_WndEightYear", WZUIImage):setVisible(false)
		GetElement(self.m_root, "imgBg03_WndEightYear", WZUIImage):setVisible(false)
		WZLog("WndEightYear:GetActivityInfoOK", Serialize(self.m_tContent))
		self:_setLibraryData()
		self:_showMakeCake()
	elseif g_cityExtenInfo.activity7123 == activityId then --周年拼单
		self.m_tContent = json.decode(content)
		self.m_nStartTime = startTime 
		self.m_nEndTime = endTime
		self.m_nActivityId = activityId
		GetElement(self.m_root, "imgBg02_WndEightYear", WZUIImage):setVisible(false)
		GetElement(self.m_root, "imgBg03_WndEightYear", WZUIImage):setVisible(false)
	--	WZLog("self.m_tContentself.m_tContent 444", Serialize(self.m_tContent))

		self:_updateOrder()
	end
end

--@brief 	获取其他活动数据
function WndEightYear:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end 

	if doType == 1 then --等级奖励数据
		local tResult = json.decode(jsonData)
		WZLog("WndEightYear:_onGetOtherData 111", Serialize(tResult))
		if activityId == g_cityExtenInfo.activity7120 then 
			self.m_nGiftRewardNum = tResult.globalNum
			self:showBagGiftInfo()
		elseif g_cityExtenInfo.activity7122 == activityId then --周年拼单
			for i = 1, #tResult.tjLimit do
				self.m_tLibraryData[i].buyNum = tResult.tjLimit[i]
				self.m_tLibraryData[i].dayBuyNum = tResult.tjDailyLimit[i]
				self.m_tLibraryData[i].status = tResult.tjStatus[i] + 1
			end

			self:_showExchangeList()
		elseif g_cityExtenInfo.activity7123 == activityId then --周年拼单
			if self.m_nFreshTimes ~= tResult.resetTimes then 
				self.m_nPageIndex = 1
			end
			self.m_nFreshTimes = tResult.resetTimes

			local nSex = CacheCenter:getPlayerInfo().sex
			local itemIds = nil 
			if nSex == 0 then 
				itemIds = tResult.boyItemIds
			else
				itemIds = tResult.girlItemIds
			end
			self:_setGoodsData(tResult.ids, itemIds, tResult.nums, tResult.prices, tResult.discountPrices, tResult.finishNums, tResult.orderInfos)

			self:_showFreshBtn()
			self:_showGoodsList()
		end
	elseif doType == 2 then --等级奖励数据
		local tResult = json.decode(jsonData)
		WZLog("WndEightYear:_onGetOtherData 222", Serialize(tResult))
		if activityId == g_cityExtenInfo.activity7120 then 
			table.insert(self.m_tGetTimes, tResult.pool)
			local nSex = CacheCenter:getPlayerInfo().sex
			local sBigReward = tResult.rewards
			local array = SplitStringWithSeparator(sBigReward, "&")
			if tResult.pool == 0 then 
				local tItem = {reward_ids = {}, reward_nums = {}, name = LocalStrings.EIGHTYEAR_TEXT1[20], listBgSize = {474,228}, listBgPos = {0.5,0.431}, origin = 847120}
				for i = 1, #array do
					local string = string.sub(array[i], 2, -2) 
					local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
					local num = tonumber(SplitStringWithSeparator(string,",")[3])

					table.insert(tItem.reward_ids, id)
					table.insert(tItem.reward_nums, num)
				end

				self.m_tBigRewardList[3] = tItem
			elseif tResult.pool == 1 then 
				local tItem = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.EIGHTYEAR_TEXT1[21], strAtt = LocalStrings.CATHOUSE_TEXT1[16], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31, pool = tResult.pool, origin = 857120}
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
				local tItem = {reward_ids1 = {}, reward_nums1 = {}, name = LocalStrings.EIGHTYEAR_TEXT1[22], strAtt = LocalStrings.CATHOUSE_TEXT1[16], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31, pool = tResult.pool}

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
				otherData.imgBg = "ui/common/frame_tc_xiao_zi.png"
				otherData.img9SecBg = "ui/common/frame_04.png"
				otherData.imgClose = "ui/common/common_top_btn_guanbi_zi.png"
				otherData.str_color = ccc3(198,130,255)
				otherData.str_normal = "ui/activity/common_btn_48.png"
				otherData.str_select = "ui/activity/common_btn_47.png"
				otherData.changeRes = 2
				otherData.otherRewardData = self.m_tBigRewardList[3]
				otherData.chooseInfo = {strKey="EIGHTYEAR_TEXT1", wordIndex=20, doType=4}
				WndJoinReward:showInterface("", self.m_tBigRewardList[1], self.m_tBigRewardList[2], LocalStrings.WATERMELON_TEXT1[22], true, 3, otherData)
			end
		elseif activityId == g_cityExtenInfo.activity7122 then 
			if result == 0 then 
				local tReward = {}
				for i = 1, #tResult.itemIds do
					local tItem = {}
					tItem.itemId = tResult.itemIds[i]
					tItem.itemNum = tResult.itemNums[i]
					tItem.type = 8
					tItem.imgRewardTitle = "ui/newActivity/bt_text_gxhd_2.png"
					tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
					table.insert(tReward, tItem)
				end

				WndHoraryBigReward:showInterface(8, tReward)

				self:_showMakeCost()
			end
		elseif activityId == g_cityExtenInfo.activity7123 then --拼单信息
			local nSex = CacheCenter:getPlayerInfo().sex
			local itemIds = nil 
			if nSex == 0 then 
				itemIds = tResult.boyItemIds
			else
				itemIds = tResult.girlItemIds
			end
			self:_setMyOrderData(tResult.ids, itemIds, tResult.nums, tResult.prices, tResult.discountPrices, tResult.orderInfos)
		end
	elseif doType == 3 then --开启结果
		local tResult = json.decode(jsonData)
		WZLog("WndEightYear:_onGetOtherData 333", Serialize(tResult))
		if activityId == g_cityExtenInfo.activity7120 then
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
					tItem.strTitle = string.format(strTitleFormat, LocalStrings.EIGHTYEAR_TEXT1[20])
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
					tItem.strTitle = string.format(strTitleFormat, LocalStrings.EIGHTYEAR_TEXT1[21])
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
					tItem.strTitle = string.format(strTitleFormat, LocalStrings.EIGHTYEAR_TEXT1[22])
					tItem.txtTitlePt = {0.5,0.95}
					tItem.spineEffect = {path = "activity/ui_bengchuang_mxj", _sIndex = "ui_bengchuang_mxj", play = "wait1"}

					table.insert(self.m_tOpenResult.bigRewards, tItem)
				
					itemIdIndex = itemIdIndex + 1
				end
			end

			if result == 1 then 
				self.m_nCount = tResult.count
				self.m_tOpenResult.addExp = tResult.score

				self:showOpenAction()
				self:_setFreeBtnText()
			else
				self:setOpenState(false)
			end
		elseif activityId == g_cityExtenInfo.activity7123 then --拼单
			if result == 0 then 
				GetElement(self.m_root, "conPay_WndEightYear", WZUIContainer):setVisible(false)
				if tResult.itemId and #tResult.itemId > 0 then 
					local tReward = {}
					for i = 1, #tResult.itemId do
						local tItem = {}
						tItem.itemId = tResult.itemId[i]
						tItem.itemNum = tResult.itemNum[i]
						tItem.playerItemId = tResult.playerItemIds[i]
						tItem.type = 8
						tItem.imgRewardTitle = "ui/newActivity/bt_text_gxhd_2.png"
						tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
						table.insert(tReward, tItem)
					end

					WndHoraryBigReward:showInterface(8, tReward)
				end
			end
		end
	elseif doType == 4 then --选择奖励
		local tResult = json.decode(jsonData)
		WZLog("WndEightYear:_onGetOtherData 444", Serialize(tResult))
		if activityId == g_cityExtenInfo.activity7120 then --
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
		elseif activityId == g_cityExtenInfo.activity7123 then --拼单
			if result == 0 then 
				if tResult.itemId and #tResult.itemId > 0 then 
					local tReward = {}
					for i = 1, #tResult.itemId do
						local tItem = {}
						tItem.itemId = tResult.itemId[i]
						tItem.itemNum = tResult.itemNum[i]
						tItem.playerItemId = tResult.playerItemIds[i]
						tItem.type = 8
						tItem.imgRewardTitle = "ui/newActivity/bt_text_gxhd_2.png"
						tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
						table.insert(tReward, tItem)
					end

					WndHoraryBigReward:showInterface(8, tReward)
				end
				GetElement(self.m_root, "conOtherOrder_WndEightYear", WZUIContainer):setVisible(false)
			end
		end
	elseif doType == 5 then --领取全服礼包奖励
		local tResult = json.decode(jsonData)
		WZLog("WndEightYear:_onGetOtherData 555", Serialize(tResult))
		if activityId == g_cityExtenInfo.activity7120 then --
			if result == 1 then 
				local tReward = {}
				for i = 1, #tResult.itemIds do
					local tItem = {}
					tItem.itemId = tResult.itemIds[i]
					tItem.itemNum = tResult.itemNums[i]
					tItem.playerItemId = tResult.playerItemIds[i]
					tItem.type = 8
					tItem.imgRewardTitle = "ui/newActivity/bt_text_gxhd_2.png"
					tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
					table.insert(tReward, tItem)
				end

				WndHoraryBigReward:showInterface(8, tReward)
			end
		elseif activityId == g_cityExtenInfo.activity7123 then --拼单

		end
	elseif doType == 7 then --兑换奖励
		local tResult = json.decode(jsonData)
		WZLog("WndEightYear:_onGetOtherData 777", Serialize(tResult))
		if result == 0 then 
			for i = 1, #tResult.id do
				self.m_tLibraryData[tResult.id[i] + 1].status = tResult.tjStatus[i] + 1
				self.m_tLibraryData[tResult.id[i] + 1].buyNum = tResult.soldNum[i]
				self.m_tLibraryData[tResult.id[i] + 1].dayBuyNum = tResult.dailyBuyNum[i]

				self:updateCatchFishLibrary(tResult.id[i] + 1, tResult.tjStatus[i] + 1, self.m_tLibraryData[tResult.id[i] + 1].buyNum, self.m_tLibraryData[tResult.id[i] + 1].dayBuyNum)
			end
			self:showRedDot()
			WndRewardShow:showById(tResult.itemIds, tResult.itemNums)
		end
	end
end

--@brief	缓存推送更新物品时调用的函数
function WndEightYear:updatePlayerItemData()
	WZLog("WndEightYear:updatePlayerItemData")
	if self.m_root ~= nil then
		self:_updateLightNum()
	end
end

--@brief 	设置射箭的状态
function WndEightYear:setOpenState(state)
	-- body
	if self.m_root == nil then return end 

	self.m_bOpenState = state
end

--@brief 	获取射箭任务列表
function WndEightYear:_onGetTaskInfo(activityId, activityType, taskType, id, status, target, progress, progressCount, refreshTime, taskGroup)
	if activityId == self.m_nActivityId and activityId == g_cityExtenInfo.activity7121 then 
		self.m_tTaskData = CellNewYearTask:setTaskData(id, status, target, progress, activityId)

		self:_showYearTask()
	end
end

--@brief 	射箭任务奖励
function WndEightYear:_onGetTaskResult(activityId, id)
--	WZLog("WndEightYear:_onGetTaskResult", self.m_nActivityId, activityId, id)
	if self.m_nActivityId == activityId and activityId == g_cityExtenInfo.activity7121 then
		local taskData = GDatatab_new_activity_task["id_" .. id]
		if taskData and taskData.type == 2 then
			self:setTeskGetResult(id)
		end
	end
	
end

--@brief 	设置兑换数据
function WndEightYear:setExchangeData(id, cost, status, reward)
	self.m_tExchangeData = {}

	local nSex = CacheCenter:getPlayerInfo().sex
	for i = 1, #id do
		local tItem = {}
		tItem.id = id[i]
		tItem.costId = self.m_nCoinId3
		tItem.costNum = cost[i]
		tItem.reward = reward[i]
		tItem.status = status[i]
		tItem.activityId = self.m_nActivityId

		local array = SplitStringWithSeparator(reward[i], "&")
		tItem.ids = {}
		tItem.nums = {}
		for i = 1, #array do
			local string = string.sub(array[i], 2, -2) 
			local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
			local num = tonumber(SplitStringWithSeparator(string,",")[3])

			table.insert(tItem.ids, id)
			table.insert(tItem.nums, num)
		end

		table.insert(self.m_tExchangeData, tItem)
	end

	self:_showExchangeList()
end

--@brief 	设置图鉴数据
-- "cost:消耗道具兑换,dailyNum:个人日限量,limitNum:个人总限量,reward:[男物品id,女物品id,数量]&[]\,..."
function WndEightYear:_setLibraryData()
	self.m_tLibraryData = {}

	local nSex = CacheCenter:getPlayerInfo().sex
	for i = 1, #self.m_tContent.tjConfig do
		local strTemp = self.m_tContent.tjConfig[i]
		local value = {}
		value.activityId = self.m_nActivityId
		value.id = i 
		value.type = 0
		local nStart, nEnd = string.find(strTemp, "cost:")
		local nStart1, nEnd1 = string.find(strTemp, "limitNum:")
		local nStart2, nEnd2 = string.find(strTemp, "reward:")
		local nStart3, nEnd3 = string.find(strTemp, "dailyNum:")
		local costArray = SplitStringWithSeparator(string.sub(strTemp, nEnd + 2, nStart3 - 3), ",", nil, true)
		value.cost = {costArray[1], costArray[2]}
		value.num = tonumber(string.sub(strTemp, nEnd1 + 1, nStart2 - 2))
		value.dailyNum = tonumber(string.sub(strTemp, nEnd3 + 1, nStart1 - 2))
		local ids, nums = SplitItemString(string.sub(strTemp, nEnd2 + 1), nSex)
		value.ids = ids
		value.nums = nums

		table.insert(self.m_tLibraryData, value)
	end
--	WZLog("WndEightYear:_setLibraryData", Serialize(self.m_tLibraryData))
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	关闭抽奖奖励展示界面回调
function WndEightYear:_afterCloseReward()
	if self.m_root == nil then return end 

	if self.m_tOpenResult.normalRewards and #self.m_tOpenResult.normalRewards > 0 then 
		WndHoraryBigReward:showInterface(8, self.m_tOpenResult.normalRewards, self.m_tOpenResult.bigRewards)
	elseif #self.m_tOpenResult.bigRewards > 0 then 
		WndHoraryBigReward:showInterface(9, self.m_tOpenResult.bigRewards)
	end
end

function WndEightYear:setTeskGetResult(id)
	if self.m_tDayTaskItemCell then
		for i,v in pairs(self.m_tTaskData) do
			if v and v.id == id then
				self.m_tTaskData[i].status = 2	
				break
			end
		end
		taskTableSort(self.m_tTaskData)
		for i,v in ipairs(self.m_tDayTaskItemCell) do
			if v then
				v:setTaskItemMessage(i,self.m_tTaskData[i])
			end
		end
	end
end

--@brief 	设置拼单物品数据
function WndEightYear:_setGoodsData(id, itemId, itemNum, prices, discountPrices, finishNums, orderInfos)
	self.m_tGoodsData = {}

	for i = 1, #id do
		local tItem = {}

		tItem.id = id[i]
		tItem.itemId = itemId[i]
		tItem.itemNum = itemNum[i]
		tItem.times = finishNums[i]
		tItem.costId = self.m_nCoinId5
		tItem.price = prices[i]
		tItem.discountPrice = discountPrices[i]
		tItem.activityId = self.m_nActivityId
		tItem.orderInfo = json.decode(orderInfos[i])

		table.insert(self.m_tGoodsData, tItem)
	end

--	WZLog("WndEightYear:_setGoodsData", Serialize(self.m_tGoodsData))
end

--@brief 	设置我的拼单信息
function WndEightYear:_setMyOrderData(id, itemId, itemNum, prices, discountPrices, orderInfos)
	self.m_tMyOrderData = {}

	for i = 1, #id do
		local tItem = {}

		tItem.id = id[i]
		tItem.itemId = itemId[i]
		tItem.itemNum = itemNum[i]
		tItem.costId = self.m_nCoinId5
		tItem.price = prices[i]
		tItem.discountPrice = discountPrices[i]
		tItem.orderInfo = json.decode(orderInfos[i])

		table.insert(self.m_tMyOrderData, tItem)
	end

--	WZLog("WndEightYear:_setMyOrderData", Serialize(self.m_tMyOrderData))
	self:_showMyOrderList()
end

--@brief 	判断某商品中是否有玩家未完成的拼单
function WndEightYear:_judgeHaveNotFinishOrder(goodData)
	local orderCount = #goodData.orderInfo
	local myId = CacheCenter:getPlayerInfo().id
	local bCanLaunch = true 
	if orderCount > 0 then 
		for i = 1, orderCount do
			if goodData.orderInfo[i].masterPlayerId == myId then 
				bCanLaunch = false 
				break 
			end
		end
	end

	return bCanLaunch
end
-------------------------------------私有方法模块End----------------------------------------

--================== 任务子项 ========================
CellEightYearTaskItem = {}
function CellEightYearTaskItem:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tGoodItemCell = {}
	self.m_nTaskRewardId = nil
	self.m_bIsLoaded = false 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellEightYearTaskItem:_unInit()
	self.m_root = nil
	self.m_tGoodItemCell = nil 
	self.m_nTaskRewardId = nil
	self.m_bIsLoaded = nil 
end

--@brief	创建控件
function CellEightYearTaskItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(136,366))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end

function CellEightYearTaskItem:setGiftBuyMessage(index, data)
	self.m_nIndex = index
	self.m_tTaskItemData = data
end

--@brief 	开始加载
function CellEightYearTaskItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("CellEightYearTaskItem")
	celElement:setVisible(true)
	element:addChild(celElement)
	self.m_bIsLoaded = true 

	self:setTaskDayDataItem()

	AdaptLanguage(self)
end

function CellEightYearTaskItem:setTaskDayDataItem()
	if not self.m_tTaskItemData then return end
	local data = self.m_tTaskItemData

	self.m_tGoodItemCell = {}
	self:setTaskItemMessage(self.m_nIndex,data)
end
function CellEightYearTaskItem:setTaskItemMessage(index,data)
	--0=不可领取|1=可领取|2=已领取
	self.m_nIndex = index
	self.m_tTaskItemData = data
	if not self.m_bIsLoaded then return end 
	
	GetElement(self.m_root,"btnGoto_CellEightYearTaskItem",WZUIButton):setVisible(data.status == 0)
	GetElement(self.m_root,"btnGet_CellEightYearTaskItem",WZUIButton):setVisible(data.status == 1)
	GetElement(self.m_root,"imgHaveGet_CellEightYearTaskItem",WZUIImage):setVisible(data.status == 2)
	
	local txtName = GetElement(self.m_root,"txtName_CellEightYearTaskItem",WZUILabelTTF)
	local txtNum = GetElement(self.m_root,"txtNum_CellEightYearTaskItem",WZUILabelTTF)
	local txtDesc = GetElement(self.m_root,"txtDesc_CellEightYearTaskItem",WZUILabelTTF)
	local ftxtDescTitle = GetElement(self.m_root, "ftxtDesc_CellEightYearTaskItem", WZUIFreeTextBox)
	if string.find(data.desc, "<T") == nil then
		txtDesc:setText(data.desc)
	else
		ftxtDescTitle:setShowText(data.desc)
	end

	self.m_nTaskRewardId = data.id

	if self.m_tGoodItemCell then 
		for i = 1, #self.m_tGoodItemCell do 
			if self.m_tGoodItemCell[i] and self.m_tGoodItemCell[i].celElement and self.m_tGoodItemCell[i].tLuaObj then 
				self.m_tGoodItemCell[i].celElement:setVisible(false)
			end
		end
	end
	local good_con = GetElement(self.m_root,"conItem_CellEightYearTaskItem",WZUIContainer)
	WZLog("CellEightYearTaskItem:setTaskItemMessage", Serialize(data.ids))
	for i=1, #data.ids do
		local key = "id_"..data.ids[i]
		local tabItem = GDatatab_item[key]
		local num = data.nums[i]
		
		local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key]), origin = 807121}
		if i == 1 then 
			txtName:setText(tabItem.name)
			txtNum:setText("X" .. num)
		end
		if self.m_tGoodItemCell == nil or self.m_tGoodItemCell[i] == nil then
			if self.m_tGoodItemCell == nil then 
				self.m_tGoodItemCell = {}
			end
			local celElement,tLuaObj = CellGoodItem:createElement()
			good_con:addChild(celElement)
			celElement:setUseAbsCoordinate(true)
			local tab = {}
			tab.celElement = celElement
			tab.tLuaObj = tLuaObj
			self.m_tGoodItemCell[i] = tab
		end
		if self.m_tGoodItemCell[i] and self.m_tGoodItemCell[i].celElement and self.m_tGoodItemCell[i].tLuaObj then
			local celElement = self.m_tGoodItemCell[i].celElement
			local tLuaObj = self.m_tGoodItemCell[i].tLuaObj
			tLuaObj:setCellGoodItem(itemInfo, 15)
			tLuaObj:setItemClickFun(WndEightYear,WndEightYear.onItemClick)
			local _x = 40 + (i-1) * 85
			celElement:setAbsPosition(GlobalMethod:ccp(_x, 40))
			celElement:setVisible(true)
		end
	end
end

function CellEightYearTaskItem:onClickGoto(element)
	local nTag = element:getTag()
	if nTag == 1 then
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
		WndEightYear:onCloseClick(element)
	elseif nTag == 2 then 
		self:onBtnGet()
	end
end
function CellEightYearTaskItem:onBtnGet()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 
	WZLog("CellEightYearTaskItem:onBtnGet", self.m_tTaskItemData.activityId, self.m_nTaskRewardId)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ReceiveTaskReward(self.m_tTaskItemData.activityId, self.m_nTaskRewardId)
end
--@return	新建的表实例对象
function CellEightYearTaskItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--@brief	越南适配
function CellEightYearTaskItem:_adaptLanguage_vn()
	local ftxtDescTitle = GetElement(self.m_root, "ftxtDesc_CellEightYearTaskItem", WZUIFreeTextBox)
	ftxtDescTitle:setMaxWidth(160)
	ftxtDescTitle:setScale(0.7)
end

--================== 兑换子项 ========================
CellEightYearExchange = {}
function CellEightYearExchange:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tGoodItemCell = {}
	self.m_nTaskRewardId = nil
	self.m_bIsLoaded = false 
	self.m_tItemData = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellEightYearExchange:_unInit()
	self.m_root = nil
	self.m_tGoodItemCell = nil 
	self.m_nTaskRewardId = nil
	self.m_bIsLoaded = nil 
	self.m_tItemData = nil 
end

--@brief	创建控件
function CellEightYearExchange:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(260,70))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end

function CellEightYearExchange:setData(data)
	self.m_tItemData = data
end

function CellEightYearExchange:resetData(data)
	self.m_tItemData = data
	if self.m_bIsLoaded then 
		self:setItemMessage(data)
	end
end

--@brief 	开始加载
function CellEightYearExchange:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("CellEightYearExchange")
	celElement:setVisible(true)
	element:addChild(celElement)
	self.m_bIsLoaded = true 

	self:setDayDataItem()
end

--@brief 	获取数据
function CellEightYearExchange:getData()
	return self.m_tItemData
end

function CellEightYearExchange:setDayDataItem()
	if not self.m_tItemData then return end
	local data = self.m_tItemData

	self.m_tGoodItemCell = {}
	self:setItemMessage(data)
end
function CellEightYearExchange:setItemMessage(data)
	--0=不可领取|1=可领取|2=已领取
	self.m_tItemData = data
	if not self.m_bIsLoaded then return end 
	
	local btnExchange = GetElement(self.m_root,"btnExchange_CellEightYearExchange",WZUIButton)
	btnExchange:setVisible(data.status ~= 2)
	if data.status == 0 then 
		btnExchange:setTouchEnable(false)
	elseif data.status == 1 then 
		btnExchange:setTouchEnable(true)
	end
	GetElement(self.m_root,"imgHaveExchange_CellEightYearExchange",WZUIImage):setVisible(data.status == 2)
	GetElement(self.m_root,"txtExchangeW_CellEightYearExchange",WZUILabelTTF):setText(LocalStrings.EIGHTYEAR_TEXT1[31])
	GetElement(self.m_root, "imgCostIcon_CellEightYearExchange", WZUIImage):setFile(GDatatab_item["id_" .. data.cost[1]].icon)
	GetElement(self.m_root, "txtCostNum_CellEightYearExchange", WZUILabelTTF):setText("X" .. data.cost[2])
	local ftxtLimit = GetElement(self.m_root, "ftxtLimit_CellEightYearExchange", WZUIFreeTextBox)
	local limitFormat = [[<T C="255,255,255" S="12" P="1">%s</T><T C="255,227,116" S="14" P="1">%d/%d</T>]]
	if data.dailyNum then 
		local bVisibleLimit, strLimit = GetLimitData(data.buyNum, data.num, data.dailyNum, data.dayBuyNum)
		if bVisibleLimit then 
			GetElement(self.m_root, "imgCorner_CellEightYearExchange", WZUIImage):setVisible(true)
			local limitFormat2 = [[<T C="255,255,255" S="12" P="1">%s</T>]]
			ftxtLimit:setShowText(string.format(limitFormat2, strLimit))
		end
	else
		if data.num > 0 then 
			GetElement(self.m_root, "imgCorner_CellEightYearExchange", WZUIImage):setVisible(true)
			ftxtLimit:setShowText(string.format(limitFormat, LocalStrings.WATERMELON_TEXT1[25] .. ":", data.buyNum, data.num))
		end
	end

	self.m_nTaskRewardId = data.id
	
	if self.m_tGoodItemCell then 
		for i = 1, #self.m_tGoodItemCell do 
			if self.m_tGoodItemCell[i] and self.m_tGoodItemCell[i].celElement and self.m_tGoodItemCell[i].tLuaObj then 
				self.m_tGoodItemCell[i].celElement:setVisible(false)
			end
		end
	end
	local good_con = GetElement(self.m_root,"conItem_CellEightYearExchange",WZUIContainer)
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
			good_con:addChild(celElement)
			celElement:setScale(0.65)
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
			tLuaObj:setItemClickFun(WndEightYear,WndEightYear.onItemClick)
			local _x = 35 + (i-1) * 60
			celElement:setAbsPosition(GlobalMethod:ccp(_x, 35))
			celElement:setVisible(true)
		end
	end
end

function CellEightYearExchange:onClickExchange()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 
	WZLog("CellEightYearExchange:onClickExchange", self.m_tItemData.activityId, self.m_nTaskRewardId)
	local tData = {id={}, num={}}
	table.insert(tData.id, self.m_nTaskRewardId - 1)
	table.insert(tData.num, 1)
	local strJson = json.encode(tData)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_tItemData.activityId, 7, strJson)
end

--@brief 	刷新兑换按钮状态
function CellEightYearExchange:updateBtnState(ownNum)
	if self.m_tItemData.status == 0 then 
		if ownNum >= self.m_tItemData.cost[2] then 
			self.m_tItemData.status = 1
		end
	elseif self.m_tItemData.status == 1 then 
		if ownNum < self.m_tItemData.cost[2] then 
			self.m_tItemData.status = 0
		end
	end
	if not self.m_bIsLoaded then return end 
	if self.m_tItemData.status == 2 then return end 

	local btnExchange = GetElement(self.m_root, "btnExchange_CellEightYearExchange", WZUIButton)
	if self.m_tItemData.status == 0 then 
		btnExchange:setTouchEnable(false)
	elseif self.m_tItemData.status == 1 then 
		btnExchange:setTouchEnable(true)
	end
end

--@return	新建的表实例对象
function CellEightYearExchange:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--================== 拼单子项 ========================
CellEightYearOrder = {}
function CellEightYearOrder:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_bIsLoaded = false 
	self.m_tItemData = nil 
	self.m_tGoodData = nil 
	self.m_tOrderInfo = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellEightYearOrder:_unInit()
	self.m_root = nil
	self.m_bIsLoaded = nil 
	self.m_tItemData = nil 
	self.m_tGoodData = nil 
	self.m_tOrderInfo = nil 
end 

--@brief 	
function CellEightYearOrder:onEnter(element)

end

--@brief	创建控件
function CellEightYearOrder:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setName("__CellEightYearOrder")
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(250,62))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end

function CellEightYearOrder:setData(data, goodData)
	self.m_tItemData = data
	self.m_tGoodData = goodData
end

--@brief 	开始加载
function CellEightYearOrder:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("CellEightYearOrder")
	celElement:setVisible(true)
	element:addChild(celElement)
	self.m_bIsLoaded = true 

	self:setDataItem()
	AdaptLanguage(self)
end

function CellEightYearOrder:setDataItem()
	if not self.m_tItemData then return end
	local data = self.m_tItemData

	self:setItemMessage(data)
end
function CellEightYearOrder:setItemMessage(data)
	--0=不可领取|1=可领取|2=已领取
	self.m_tItemData = data
	if not self.m_bIsLoaded then return end 
	self:_setStaticText()
	WZLog("CellEightYearOrder:setItemMessage", Serialize(data))
	local conHead = GetElement(self.m_root, "conHead_CellEightYearOrder", WZUIContainer)
	local orderInfo = {}
	for i = 1, #data.playerIds do
		if data.masterPlayerId == data.playerIds[i] then 
			orderInfo.headId = data.headIds[i]
			orderInfo.faceId = data.faceIds[i]
			orderInfo.sex = data.sexs[i]
			orderInfo.level = data.levels[i]
			orderInfo.vipLevel = data.vipLevels[i]
			orderInfo.headColor = data.headColors[i]
			orderInfo.headEffectId = data.profileFrame[i]
			orderInfo.serverId = data.serverIds[i]
			orderInfo.playerName = data.names[i]
			break 
		end
	end
	orderInfo.price = self.m_tGoodData.price
	orderInfo.costId = self.m_tGoodData.costId
	orderInfo.discountPrice = data.discountPrice
	orderInfo.orderId = data.orderId
	orderInfo.masterPlayerId = data.masterPlayerId

	self.m_tOrderInfo = orderInfo

	local element = CellHead:show(conHead, orderInfo.headId, orderInfo.faceId, orderInfo.sex, false, nil, orderInfo.vipLevel, orderInfo.headColor, nil, nil,nil, nil, orderInfo.headEffectId)
	element:setScale(0.85)

	local btnToBuy = GetElement(self.m_root,"btnToBuy_CellEightYearOrder",WZUIButton)
	if orderInfo.masterPlayerId == CacheCenter:getPlayerInfo().id then 
		btnToBuy:setTouchEnable(false)
	end
	local txtName = GetElement(self.m_root,"txtName_CellEightYearOrder",WZUILabelTTF)
	txtName:setText(orderInfo.playerName)
	if orderInfo.serverId ~= CacheCenter:getPlayerInfo().serverId then 
		GetElement(self.m_root,"imgKuafu_CellEightYearOrder",WZUIImage):setVisible(true)
		txtName:setRelativePosition(GlobalMethod:ccp(0.46,0.65))
	end
	GetElement(self.m_root,"txtLv_CellEightYearOrder",WZUILabelTTF):setText(orderInfo.level)
end

--@brief 	设置静态文本
function CellEightYearOrder:_setStaticText()
	GetElement(self.m_root, "txtBtn1_CellEightYearOrder", WZUILabelTTF):setText(LocalStrings.EIGHTYEAR_TEXT1[14])
	GetElement(self.m_root, "txtBtn2_CellEightYearOrder", WZUILabelTTF):setText(LocalStrings.EIGHTYEAR_TEXT1[14])
	GetElement(self.m_root, "txtBtn3_CellEightYearOrder", WZUILabelTTF):setText(LocalStrings.EIGHTYEAR_TEXT1[14])
end

function CellEightYearOrder:onClickToBuy(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 	
	WZLog("CellEightYearOrder:onClickToBuy")
	WndEightYear:_showOtherOrder(self.m_tOrderInfo, self.m_tGoodData)
end

function CellEightYearOrder:onClickHead(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WndCheckOther:show(self.m_tOrderInfo.masterPlayerId)
end

--@return	新建的表实例对象
function CellEightYearOrder:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--@brief	越南适配
function CellEightYearOrder:_adaptLanguage_vn()
	GetElement(self.m_root, "txtBtn1_CellEightYearOrder", WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root, "txtBtn2_CellEightYearOrder", WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root, "txtBtn3_CellEightYearOrder", WZUILabelTTF):setFontSize(18)
end

--================== 拼单子项 ========================
CellEightYearOrderItem = {}
function CellEightYearOrderItem:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nTaskRewardId = nil
	self.m_bIsLoaded = false 
	self.m_tItemData = nil 
	self.m_tGoodData = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellEightYearOrderItem:_unInit()
	self.m_root = nil
	self.m_nTaskRewardId = nil
	self.m_bIsLoaded = nil 
	self.m_tItemData = nil 
	self.m_tGoodData = nil 
end

--@brief	创建控件
function CellEightYearOrderItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(142,227))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end

function CellEightYearOrderItem:setData(data, goodData)
	self.m_tItemData = data
	self.m_tGoodData = goodData
end

--@brief 	开始加载
function CellEightYearOrderItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("CellEightYearOrderItem")
	celElement:setVisible(true)
	element:addChild(celElement)
	self.m_bIsLoaded = true 

	self:setDataItem()
end

function CellEightYearOrderItem:setDataItem()
	if not self.m_tItemData then return end
	local data = self.m_tItemData

	self:setItemMessage(data)
end
function CellEightYearOrderItem:setItemMessage(data)
	--0=不可领取|1=可领取|2=已领取
	self.m_tItemData = data
	if not self.m_bIsLoaded then return end 

	WZLog("CellEightYearOrderItem:setItemMessage", Serialize(data))
	local nCurDay = os.date("%j", SystemTime:getServerTime())
	local nLaunchDay = os.date("%j", data.orderInfo.orderTime)
	local nNum = nCurDay - nLaunchDay 
	local txtDay = GetElement(self.m_root, "txtDay_CellEightYearOrderItem", WZUILabelTTF)
	if nNum == 0 then 
		txtDay:setText(LocalStrings.COMMUNITYTASK_TEXT1[1])
	elseif nNum >= 1 then 
		txtDay:setText(string.format(LocalStrings.DAYS_AGO, nNum))
	elseif nNum < 0 then 
		nNum = 366 - nLaunchDay + nCurDay 
		txtDay:setText(string.format(LocalStrings.DAYS_AGO, nNum))
	end

	local conItem = GetElement(self.m_root, "conItem_CellEightYearOrderItem", WZUIContainer)
	local element, tNewObj = CellGoodItem:createElement()
	if element and tNewObj then 
		tNewObj:setCellGoodLocalId(data.itemId, data.itemNum, 17)
		tNewObj:setItemClickFun(WndEightYear, WndEightYear.onItemClick)

		conItem:addChild(element)
	end
	
	local btnState = GetElement(self.m_root,"btnState_CellEightYearOrderItem",WZUIButton)
	if data.orderInfo.status == 0 then --进行中
		GetElement(self.m_root, "txtBtn1_CellEightYearOrderItem", WZUILabelTTF):setText(LocalStrings.TASK_DOING)
		GetElement(self.m_root, "txtBtn2_CellEightYearOrderItem", WZUILabelTTF):setText(LocalStrings.TASK_DOING)
		GetElement(self.m_root, "txtBtn3_CellEightYearOrderItem", WZUILabelTTF):setText(LocalStrings.TASK_DOING)
	elseif data.orderInfo.status == 1 then --成功
		btnState:setTouchEnable(false)
		GetElement(self.m_root, "txtBtn1_CellEightYearOrderItem", WZUILabelTTF):setText(LocalStrings.SUCCESS)
		GetElement(self.m_root, "txtBtn2_CellEightYearOrderItem", WZUILabelTTF):setText(LocalStrings.SUCCESS)
		GetElement(self.m_root, "txtBtn3_CellEightYearOrderItem", WZUILabelTTF):setText(LocalStrings.SUCCESS)
	else --失败
		btnState:setTouchEnable(false)
		GetElement(self.m_root, "txtBtn1_CellEightYearOrderItem", WZUILabelTTF):setText(LocalStrings.FAIL)
		GetElement(self.m_root, "txtBtn2_CellEightYearOrderItem", WZUILabelTTF):setText(LocalStrings.FAIL)
		GetElement(self.m_root, "txtBtn3_CellEightYearOrderItem", WZUILabelTTF):setText(LocalStrings.FAIL)
	end
	local txtName = GetElement(self.m_root,"txtName_CellEightYearOrderItem",WZUILabelTTF)
	txtName:setText(GDatatab_item["id_" .. data.costId].name .. ":" .. data.orderInfo.discountPrice)
end

--@return	新建的表实例对象
function CellEightYearOrderItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end