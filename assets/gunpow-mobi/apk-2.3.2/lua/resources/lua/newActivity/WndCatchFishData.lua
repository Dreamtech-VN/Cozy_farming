--WndCatchFishData.lua
--@brief	WndCatchFish的数据模块
--@date		2023/09/27
--@author	XTX
--@note		捕鱼大王活动主界面

WndCatchFish = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCatchFish:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_tBigRewardList = nil 		--大奖和特奖奖励
	self.m_bOpenState = false 
	self.m_tOpenResult = nil 
	self.m_nCoinId = 160515
	self.m_nMaxLotteryCount = 20    --最大抽奖次数
	self.m_nCount = 0 
	self.m_tBallAniName = {{"wait1_1", "wait2_1"}, {"wait1_2", "wait2_2"}}
	self.m_nCalabashType = 0 			--当前选中的力度索引
	self.m_tCostByType = nil 
	self.m_nChooseReward = 0 		--选择奖励状态0：弹出预览界面；1：不弹
	self.m_nTalkGapping = nil 
	self.m_nLastTalkIndex = 0
	self.m_bIsOpenReward = false 
	self.m_nAniType = 1 
	self.m_tLvRewardList = nil 
	self.m_nCurExp = 0 
	self.m_nPirate = 0 	--是否出现鯊魚
	self.m_nPirateHP = 0 	--鯊魚血量
	self.m_nPirateProgress = 0  	--鯊魚出现进度
	self.m_tGetTimes = {}
	self.m_tLibraryData = nil 		--图鉴数据
	self.m_bIsCatchShark = false 	--抽奖是否是捕捉鲨鱼
	self.m_tBallAniName2 = {"wait3_1", "wait3_2"}
	self.m_tBallAniName3 = {"wait4_1", "wait4_2"}
	self.m_bIsAppear = false 
	self.m_bIsFirstIn = true 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCatchFish:_unInit()
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
	self.m_nCalabashType = nil 			--当前选中的力度索引
	self.m_tCostByType = nil 
	self.m_nChooseReward = nil 		--选择奖励状态0：弹出预览界面；1：不弹
	self.m_nTalkGapping = nil 
	self.m_nLastTalkIndex = nil 
	self.m_bIsOpenReward = nil 
	self.m_nAniType = nil 
	self.m_tLvRewardList = nil 
	self.m_nCurExp = nil 
	self.m_nPirate = nil  	
	self.m_nPirateHP = nil  	
	self.m_nPirateProgress = nil  	--鯊魚出现进度
	self.m_tGetTimes = nil 
	self.m_tLibraryData = nil
	self.m_bIsCatchShark = nil 
	self.m_tBallAniName2 = nil 
	self.m_tBallAniName3 = nil 
	self.m_bIsAppear = nil 
	self.m_bIsFirstIn = nil  
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCatchFish:createElement()
	if WndCatchFish.m_root ~= nil then
		WindowManager:removeWindow(WndCatchFish.m_root, WndCatchFish, true)
	end
	local element = WZUISystem:getInstance():createElement("WndCatchFish")
	assert(element, "WndCatchFish create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndCatchFish:showInterface()
	LoadNewActivityRes(true)
	local wndWater = WndCatchFish:createElement()
	if wndWater then 
		WindowManager:addWindow(wndWater, WndCatchFish, false)
	end
end

--@brief 	获取活动详情成功
function WndCatchFish:GetActivityInfoOK(activityId,maxCount,count,status, rewardCounts, rewardItems, rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	-- body
	WZLog("WndCatchFish:GetActivityInfoOK", activityId)
	if g_cityExtenInfo.activity7094 == activityId then 
		self.m_tContent = json.decode(content)
		self.m_nStartTime = startTime 
		self.m_nEndTime = endTime 
		self.m_nActivityId = activityId
		self.m_nCount = count
		WZLog("self.m_tContentself.m_tContent", Serialize(self.m_tContent))
		self.m_tCostByType = {finishCondition[1], finishCondition[2]}

		self.m_nChooseReward = GetOperateTimes("CATCHFISHACTIVITYID", self.m_nActivityId)
		if self.m_tLvRewardList == nil then 
			self.m_tLvRewardList = {}
		end
		local tLvRewards = self.m_tContent.scoreRewards
		for i = 1, #self.m_tContent.scoreConfig do
			if self.m_tLvRewardList[i] == nil then 
				self.m_tLvRewardList[i] = {}
			end
			self.m_tLvRewardList[i].lv = i
			self.m_tLvRewardList[i].name = LocalStrings.CATCHFISH_TEXT1[17][i + 1]
			self.m_tLvRewardList[i].reward = tLvRewards[i]
			self.m_tLvRewardList[i].exp = self.m_tContent.scoreConfig[i]
			self.m_tLvRewardList[i].activityId = activityId
		end

		self:_setLibraryData()
		self:_showLvAndExp()
		self:_update()
	end
end

--@brief 	获取其他活动数据
function WndCatchFish:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end 

	if doType == 1 then --等级奖励数据
		local tResult = json.decode(jsonData)
		WZLog("WndCatchFish:_onGetOtherData 111", Serialize(tResult))
		self.m_nCurExp = tResult.score
		if self.m_nPirateHP == 0 and tResult.fishRarHP > 0 or self.m_nPirateHP > 0 and tResult.fishRarHP == 0 then 
			self.m_bIsAppear = true
		end
		self.m_nPirateHP = tResult.fishRarHP 	--鯊魚血量
		if tResult.fishRarHP > 0 then 
			self.m_nPirate = 1
		else
			self.m_nPirate = 0
		end
		self.m_nPirateProgress = tResult.rareTimes

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
		for i = 1, #tResult.tjNum do
			self.m_tLibraryData[i].buyNum = tResult.tjNum[i]
			self.m_tLibraryData[i].status = tResult.tjStatus[i] + 1
		end
		if bUpdateShow then 
			self:_showLvAndExp()
		end
		self:showRedDot()
		self:_setFreeBtnText()
		if not self.m_bIsAppear or self.m_bIsFirstIn then 
			self.m_bIsFirstIn = false 
			self:_showPirate()
		end
	elseif doType == 2 then --等级奖励数据
		local tResult = json.decode(jsonData)
		WZLog("WndCatchFish:_onGetOtherData 222", Serialize(tResult))
		table.insert(self.m_tGetTimes, tResult.pool)
		local nSex = CacheCenter:getPlayerInfo().sex
		local sBigReward = tResult.rewards
		local array = SplitStringWithSeparator(sBigReward, "&")
		if tResult.pool == 0 then 
			local tItem = {reward_ids = {}, reward_nums = {}, name = LocalStrings.CATCHFISH_TEXT1[12], listBgSize = {474,228}, listBgPos = {0.5,0.431}}
			for i = 1, #array do
				local string = string.sub(array[i], 2, -2) 
				local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
				local num = tonumber(SplitStringWithSeparator(string,",")[3])

				table.insert(tItem.reward_ids, id)
				table.insert(tItem.reward_nums, num)
			end

			self.m_tBigRewardList[3] = tItem
		elseif tResult.pool == 1 then 
			local tItem = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.CATCHFISH_TEXT1[13], strAtt = LocalStrings.CATCHFISH_TEXT1[16], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31, pool = tResult.pool}
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
			local tItem = {reward_ids1 = {}, reward_nums1 = {}, name = LocalStrings.CATCHFISH_TEXT1[14], strAtt = LocalStrings.CATCHFISH_TEXT1[16], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31, pool = tResult.pool}
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
			otherData.changeRes = 2
			otherData.imgBg = "ui/common/frame_tc_xiao_lan.png"
			otherData.img9SecBg = "ui/common/frame_lieb_11.png"
			otherData.imgClose = "ui/newvip/common_top_btn_guanbi_lan.png"
			otherData.str_normal = "ui/common/common_mlrs_xz_04.png"
			otherData.str_select = "ui/common/common_mlrs_xz_03.png"
			otherData.str_color = GlobalMethod:ccc3(93,222,245)
			otherData.chooseInfo = {strKey="CATCHFISH_TEXT1", wordIndex=12, doType=4}
			WndJoinReward:showInterface("", self.m_tBigRewardList[1], self.m_tBigRewardList[2], LocalStrings.WATERMELON_TEXT1[22], true, 3, otherData)
		end
	elseif doType == 3 then --开启结果
		local tResult = json.decode(jsonData)
		WZLog("WndCatchFish:_onGetOtherData 333", Serialize(tResult))
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
		--翻倍奖励
		if tResult.mItemIds then 
			for i = 1, #tResult.mItemIds do
				local tItem = {}
				tItem.itemId = tResult.mItemIds[i]
				tItem.itemNum = tResult.mItemNums[i]
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
				tItem.strTitle = string.format(strTitleFormat, LocalStrings.CATCHFISH_TEXT1[12])
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
				tItem.strTitle = string.format(strTitleFormat, LocalStrings.CATCHFISH_TEXT1[13])
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
				tItem.strTitle = string.format(strTitleFormat, LocalStrings.CATCHFISH_TEXT1[14])
				tItem.txtTitlePt = {0.5,0.95}
				tItem.spineEffect = {path = "activity/ui_bengchuang_mxj", _sIndex = "ui_bengchuang_mxj", play = "wait1"}

				table.insert(self.m_tOpenResult.bigRewards, tItem)
			
				itemIdIndex = itemIdIndex + 1
			end
		end

		--鱼类奖励
		if tResult.fishRareItemIds and #tResult.fishRareItemIds > 0 then 
			for i = 1, #tResult.fishRareItemIds do
				local bIsExist = false 
				for j = 1, #self.m_tOpenResult.otherRewards do
					if self.m_tOpenResult.otherRewards[j][1] == tResult.fishRareItemIds[i] then 
						bIsExist = true
						self.m_tOpenResult.otherRewards[j][2] = self.m_tOpenResult.otherRewards[j][2] + tResult.fishRareItemNums[i]
						break 
					end
				end
				if not bIsExist then 
					local tItem = {tResult.fishRareItemIds[i], tResult.fishRareItemNums[i]}

					table.insert(self.m_tOpenResult.otherRewards, tItem)
				end
			end
		end
		if tResult.fishItemIds and #tResult.fishItemIds > 0 then 
			for i = 1, #tResult.fishItemIds do
				local bIsExist = false 
				for j = 1, #self.m_tOpenResult.otherRewards do
					if self.m_tOpenResult.otherRewards[j][1] == tResult.fishItemIds[i] then 
						bIsExist = true
						self.m_tOpenResult.otherRewards[j][2] = self.m_tOpenResult.otherRewards[j][2] + tResult.fishItemNums[i]
						break 
					end
				end
				if not bIsExist then 
					local tItem = {tResult.fishItemIds[i], tResult.fishItemNums[i]}

					table.insert(self.m_tOpenResult.otherRewards, tItem)
				end
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
	elseif doType == 4 then --选择奖励
		local tResult = json.decode(jsonData)
		WZLog("WndCatchFish:_onGetOtherData 444", Serialize(tResult))
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
		WZLog("WndCatchFish:_onGetOtherData 555", Serialize(tResult))
		if result == 0 then 
			self.m_tLvRewardList[tResult.id + 1].status = 2
			WndRewardShow:showById(tResult.itemIds, tResult.itemNums)

			self:showRedDot()
			self:_createLvRewardList()
		end
	elseif doType == 6 then --领取图鉴奖励
		local tResult = json.decode(jsonData)
		WZLog("WndCatchFish:_onGetOtherData 666", Serialize(tResult))
		if result == 0 then 
			self.m_tLibraryData[tResult.id + 1].status = tResult.status + 1
			self.m_tLibraryData[tResult.id + 1].buyNum = self.m_tLibraryData[tResult.id + 1].buyNum + 1
			WndRewardShow:showById(tResult.itemIds, tResult.itemNums)

			self:showRedDot()
			WndHouseInvite:updateCatchFishLibrary(tResult.id + 1, tResult.status + 1, self.m_tLibraryData[tResult.id + 1].buyNum)
		end
	end
end

--@brief	缓存推送更新物品时调用的函数
function WndCatchFish:updatePlayerItemData()
	WZLog("WndCatchFish:updatePlayerItemData")
	if self.m_root ~= nil then
		self:_updateLightNum()
	end
end

--@brief 	设置射箭的状态
function WndCatchFish:setOpenState(state)
	-- body
	if self.m_root == nil then return end 

	self.m_bOpenState = state
end

--@brief 	获取不同鱼类图鉴数据
--@param 	nType = 0普通鱼类；=1稀有鱼类
function WndCatchFish:getLibraryData(nType)
	local tData = {}
	for i = 1, #self.m_tLibraryData do
		if self.m_tLibraryData[i].type == nType then 
			table.insert(tData, self.m_tLibraryData[i])
		end
	end

	return tData
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	关闭抽奖奖励展示界面回调
function WndCatchFish:_afterCloseReward()
	if self.m_root == nil then return end 

	if self.m_tOpenResult.normalRewards and #self.m_tOpenResult.normalRewards > 0 then 
		WndHoraryBigReward:showInterface(8, self.m_tOpenResult.normalRewards, self.m_tOpenResult.bigRewards)
	elseif #self.m_tOpenResult.bigRewards > 0 then 
		WndHoraryBigReward:showInterface(9, self.m_tOpenResult.bigRewards)
	end
end

--@brief 	获取当前捕鼠等级
function WndCatchFish:getCurLvInfo()
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

--@brief 	设置图鉴数据
-- "type:0,cost:[160528,10],num:10,reward:[70,100]"
function WndCatchFish:_setLibraryData()
	self.m_tLibraryData = {}

	local nSex = CacheCenter:getPlayerInfo().sex
	for i = 1, #self.m_tContent.fishTjConfig do
		local strTemp = self.m_tContent.fishTjConfig[i]
		local value = {}
		value.activityId = self.m_nActivityId
		value.id = i 
		value.type = tonumber(string.sub(strTemp, 6, 6))
		local nStart, nEnd = string.find(strTemp, "cost:")
		local nStart1, nEnd1 = string.find(strTemp, "num:")
		local nStart2, nEnd2 = string.find(strTemp, "reward:")
		local costArray = SplitStringWithSeparator(string.sub(strTemp, nEnd + 2, nStart1 - 3), ",", nil, true)
		value.cost = {costArray[1], costArray[2]}
		value.num = tonumber(string.sub(strTemp, nEnd1 + 1, nStart2 - 2))
		local ids, nums = SplitItemString(string.sub(strTemp, nEnd2 + 1), nSex)
		value.ids = ids
		value.nums = nums

		table.insert(self.m_tLibraryData, value)
	end
end
-------------------------------------私有方法模块End----------------------------------------
