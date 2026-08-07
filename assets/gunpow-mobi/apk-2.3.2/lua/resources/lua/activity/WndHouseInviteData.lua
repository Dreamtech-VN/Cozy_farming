--WndHouseInviteData.lua
--@brief	WndHouseInvite的数据模块
--@date		2021/09/27
--@author	hyx
--@note		房产主界面

WndHouseInvite = {
	--请不要在这里定义变量
}
WndHouseInvite.Panel = {
	[1] = "CellHouseInviteTeam",
	[2] = "CellHouseInviteFriend",
	[3] = "CellHouseInviteNotice",
}
--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndHouseInvite:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nCurIndex = nil
	self.m_tChangeTitle = {}
	self.m_tHouseActivityPanel = {}
	self.m_sCurInvestActivityPanel = nil
	self.m_nWinType = 1 	--1:房产大亨-我的团队；2：张灯结彩-贺卡；3：心愿墙 4:秘境闯塔-八卦方位 5:深夜食堂-一起打卡 6:组团消费 7:高尔夫赛事 8:侦探所-整理案件 9:黄金矿工 10:秋日露营-篝火奖励 11:捕鱼大王：12:一起来采茶；图鉴 13:植树造林 14:魔药炼制 15:丹青圣手 16寻找龙珠 17:点石成翡 18 颠倒雷竹阵 19：潘家园鉴宝-文物修复 20采矿大王
	self.m_nActivityId = nil  
	self.m_tCardLeftNum = {} --贺卡剩余数量
	self.m_tCardState = {}
	self.m_tEightTask = nil 	--八卦方位任务
	self.m_tNodeReward = nil 	--八卦方位奖励节点
	self.m_nShowTabIndex = nil  --首次需要显示的标签
	self.m_tAddCaseItem = {}   --已添加的案件道具
	self.m_tNumCostList = {5, 3}
	self.m_tIdCostList = {160474, 160475}
	self.m_nChooseReward = 0 		--选择奖励状态0：弹出预览界面；1：不弹
	self.m_nAniType = 1 	--抽奖次数索引
	self.m_nCoinId = 160501
	self.m_nMaxLotteryCount = 20 
	self.m_bOpenState = false 
	self.m_tTaskItemCell = nil 
	self.m_tTaskData = nil 
	self.m_nRefreshTime = 0
	self.m_nCampTabIndex = 3 
	self.m_tCatchFishSData = nil 
	self.m_tCatchFishLData = nil 
	self.m_tCellCatchFish = nil 
	self.m_tOtherData = nil 
	--7109
	self.m_tRankData = nil
	self.m_tRankOther = nil
	self.m_tTaskList = nil
	--7110
	self.m_tSlotElement = nil
	self.m_tOwnElement = nil
	self.m_tIdCostList2 = {160582, 160583}
	self.m_nPushNum = 0
	self.m_tPieceItemIds = {160687, 160688, 160689, 160690, 160691, 160692}  	--瓷器碎片Id
	self.m_tPieceState = nil   --碎片是否激活0：未激活；1激活
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndHouseInvite:_unInit()
	self.m_root = nil
	self.m_nCurIndex = nil
	self.m_tChangeTitle = nil
	self.m_tHouseActivityPanel = nil
	self.m_sCurInvestActivityPanel = nil
	self.m_nWinType = nil 
	self.m_nActivityId = nil  
	self.m_tCardLeftNum = nil 
	self.m_tCardState = nil 
	self.m_tEightTask = nil 	--八卦方位任务
	self.m_tNodeReward = nil 	--八卦方位奖励节点
	self.m_nShowTabIndex = nil  --首次需要显示的标签
	self.m_tAddCaseItem = nil   --已添加的案件道具
	self.m_tNumCostList = nil 
	self.m_tIdCostList = nil 
	self.m_nChooseReward = nil 		--选择奖励状态0：弹出预览界面；1：不弹
	self.m_nAniType = nil 
	self.m_nCoinId = nil 
	self.m_nMaxLotteryCount = nil 
	self.m_bOpenState = nil 
	self.m_tTaskItemCell = nil 
	self.m_tTaskData = nil 
	self.m_nRefreshTime = nil 
	self.m_nCampTabIndex = nil 
	self.m_tCatchFishSData = nil 
	self.m_tCatchFishLData = nil 
	self.m_tCellCatchFish = nil 
	self.m_tOtherData = nil 

	self.m_tRankData = nil
	self.m_tRankOther = nil
	self.m_tTaskList = nil

	self.m_tSlotElement = nil
	self.m_tOwnElement = nil
	self.m_tIdCostList2 = nil
	self.m_nPushNum = nil
	self.m_tPieceItemIds = nil 
	self.m_tPieceState = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndHouseInvite:createElement()
	if WndHouseInvite.m_root ~= nil then
		WindowManager:removeWindow(WndHouseInvite.m_root, WndHouseInvite, true)
	end
	local element = WZUISystem:getInstance():createElement("WndHouseInvite")
	assert(element, "WndHouseInvite create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndHouseInvite:showInterface(nWinType, nActivityId, nShowTabIndex, otherData)
	local wndInvest = WndHouseInvite:createElement()
	if wndInvest ~= nil then
		self.m_nWinType = nWinType or 1
		self.m_nActivityId = nActivityId
		self.m_nShowTabIndex = nShowTabIndex
		self.m_tOtherData = otherData
	    WindowManager:addWindow(wndInvest, WndHouseInvite, nil, false, nil, true)
	end
end

--@brief	缓存推送更新物品时调用的函数
function WndHouseInvite:updatePlayerItemData()
	if self.m_root ~= nil then
		if self.m_nWinType == 2 or self.m_nWinType == 8 then 
			self:updateLeftNum()
		elseif self.m_nWinType == 4 then 
			self:showEightDiagram()
		elseif self.m_nWinType == 10 then 
			self:updateCampWoodNum()
		elseif self.m_nWinType == 11 then 
			self:updateFishNum()
		elseif self.m_nWinType == 12 or self.m_nWinType == 17 then 
			self:updateFishNum()
		elseif self.m_nWinType == 15 then
			self:updatePaintingNum()
		elseif self.m_nWinType == 16 then
			self:updateDragonBallNum()
		elseif self.m_nWinType == 19 then
			self:updatePieceNum()
		end
	end
end

--@brief 	更新收礼剩余次数
function WndHouseInvite:updateTakeLeftNum()
	if self.m_root == nil then return end 
	if self.m_tHouseActivityPanel[2] == nil then return end 

	self.m_tHouseActivityPanel[2]:updateLeftNum()
end

--@brief 	获取其他活动数据
function WndHouseInvite:_onGetOtherData(uniIndex)
	if self.m_root == nil then return end 
	if self.m_tHouseActivityPanel[2] == nil then return end 

	self.m_tHouseActivityPanel[2]:updateList(uniIndex)
end

--@brief 	祝福成功
function WndHouseInvite:blessSuccess()
	if self.m_root == nil then return end 

	self:onBtnChangeTitle(3)
end

--@brief 	领取心愿礼物成功
function WndHouseInvite:getWishGiftSuccess()
	if self.m_root == nil then return end 

	self:showWishWords()
end

--@brief 	整理案件结果
function WndHouseInvite:caseSortResult(nIndex)
	if self.m_root == nil then return end 

	self:_cleanCaseUIData(nIndex)
	self.m_tAddCaseItem = {}
end

--@brief 	设置射箭的状态
function WndHouseInvite:setOpenState(state)
	-- body
	if self.m_root == nil then return end 

	self.m_bOpenState = state
end

--@brief 	获取射箭任务列表
function WndHouseInvite:_onGetTaskInfo(activityId, activityType, taskType, id, status, target, progress, progressCount, refreshTime, taskGroup)
	if activityId == self.m_nActivityId then 
		local tab = CellNewYearTask:setTaskData(id, status, target, progress, activityId)
		WZLog("WndHouseInvite:_onGetTaskInfo", taskType, taskGroup, #tab, Serialize(tab))
		self.m_tTaskData = tab
		self:_showCampFireTask()
	end
end

--@brief 	刷新捕鱼图鉴
function WndHouseInvite:updateCatchFishLibrary(id, status, buyNum, dayBuyNum)
	if self.m_root == nil then return end 

	local tDataList 
	if self.m_nCurIndex == 1 then 
		tDataList = self.m_tCatchFishSData
	elseif self.m_nCurIndex == 2 then 
		tDataList = self.m_tCatchFishLData
	end
	for i = 1, #tDataList do
		if tDataList[i].id == id then 
			tDataList[i].status = status 
			tDataList[i].buyNum = buyNum
			if dayBuyNum then 
				tDataList[i].dayBuyNum = dayBuyNum
			end
			break 
		end
	end

	for i = 1, #self.m_tCellCatchFish do
		local tData = self.m_tCellCatchFish[i]:getGiftBuyMessage()
		if tData and tData.id == id then 
			tData.status = status 
			tData.buyNum = buyNum 
			if tData.dayBuyNum then 
				tData.dayBuyNum = dayBuyNum
			end
			self.m_tCellCatchFish[i]:resetGiftBuyMessage(tData)
		end
	end

	self:setInviteNoticeRedPoint()
end

--@brief 	获取活动其他数据
function WndHouseInvite:_onGetOtherData2(activityId, doType, result, jsonData)
	if self.m_root == nil then return end

	if self.m_nWinType == 13 then
		if doType == 1 then
			local tResult = json.decode(jsonData)

			self.m_nTeamScore = tResult.teamScore
			self.m_nPlayerTimes = tResult.playerTimes
			self.m_nDailyTeamScore = tResult.dailyTeamScore
			self:_showAfforestation()
		elseif doType == 5 then --联盟奖励
			local tResult = json.decode(jsonData)
			if result == 0 then
				if tResult.itemIds and tResult.itemNums then
					WndRewardShow:showById(tResult.itemIds, tResult.itemNums)
				end
				self.m_nDailyTeamScore = tResult.dailyTeamScore
				self:_showAfforestation()
			end
		end
	elseif self.m_nWinType == 14 then
		if doType == 2 then
			local tResult = json.decode(jsonData)
			if tResult.pool == 3 or tResult.pool == 4 then
				table.insert(self.m_tGetTimes2, tResult.pool)
			end
			local nSex = CacheCenter:getPlayerInfo().sex
			local sBigReward = tResult.rewards
			local array = SplitStringWithSeparator(sBigReward, "&")
			if tResult.pool == 3 then
				local tItem = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.POTIONS_REFININ_TEXT1[8], strAtt = LocalStrings.PLANETSEARCH_TEXT1[4], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31, pool = tResult.pool}
				for i = 1, #array do
					local string = string.sub(array[i], 2, -2) 
					local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
					local num = tonumber(SplitStringWithSeparator(string,",")[3])

					table.insert(tItem.reward_ids2, id)
					table.insert(tItem.reward_nums2, num)
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

				self.m_tBigRewardList2[2] = tItem
			elseif tResult.pool == 4 then
				local tItem = {reward_ids1 = {}, reward_nums1 = {}, name = LocalStrings.POTIONS_REFININ_TEXT1[7], strAtt = LocalStrings.PLANETSEARCH_TEXT1[4], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31, pool = tResult.pool}
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

				self.m_tBigRewardList2[1] = tItem
			end

			if self.m_tGetTimes2 and #self.m_tGetTimes2 == 2 then 
				local otherData = {}
				otherData.winType = 1
				otherData.tabType = 2
				otherData.activityId = self.m_nActivityId
				WndJoinReward:showInterface("", self.m_tBigRewardList2[1], self.m_tBigRewardList2[2], LocalStrings.WATERMELON_TEXT1[22], false, 2, otherData)
			end
		elseif doType == 4 then --选择奖励
			local tResult = json.decode(jsonData)
			if result == 0 then 
				local tTempList = nil 
				local nTag = 0
				if tResult.pool == 3 then 
					tTempList = self.m_tBigRewardList2[2]
					nTag = 2
				elseif tResult.pool == 4 then 
					tTempList = self.m_tBigRewardList2[1]
					nTag = 3
				end
				tTempList.chooseState[tResult.id + 1] = tResult.status
				WndJoinReward:chooseReturn(nTag, tResult.id + 1, tResult.status)
			elseif result == 1 then
				MsgBoxManager:showTipBox(LocalStrings.SUMMERSURF_TEXT1[24])
			end
		elseif doType == 5 then --合成奖励
			local tResult = json.decode(jsonData)
			if result == 0 then 
				local itemIdIndex = 1
				local bigRewards = {}
				local strTitleFormat = [[<T C="255,255,255" S="46" P="1" SC="222,78,0" SS="4" SE="1">%s</T>]]
				if tResult.itemIds then 
					for i = 1, #tResult.itemIds do
						local tItem = {}
						tItem.itemId = tResult.itemIds[i]
						tItem.itemNum = tResult.itemNums[i]
						tItem.playerItemId = tResult.playerItemIds[itemIdIndex]
						if tResult.pool == 0 then 
							tItem.type = 26
							tItem.imgRewardTitle = "ui/newActivity/bt_text_ty_dxj.png"
							tItem.imgBK = "ui/specialBg/hd_pic_ty_dj.png"
							tItem.goodsconPt = {0.515, 0.498}
							tItem.strTitle = string.format(strTitleFormat, LocalStrings.POTIONS_REFININ_TEXT1[8])
							tItem.txtTitlePt = {0.5,0.885}
							tItem.spineEffect = {path = "activity/ui_bengchuang_drj", _sIndex = "ui_bengchuang_drj", play = "wait1"}
						elseif tResult.pool == 1 then --真相
							tItem.type = 26
							tItem.imgRewardTitle = "ui/newActivity/bt_text_ty_tj.png"
							tItem.imgBK = "ui/specialBg/hd_pic_ty_tj.png"
							tItem.titlePt = {0.5,0.95}
							tItem.imgBKPt = {0.5,0.5}
							tItem.strTitle = string.format(strTitleFormat, LocalStrings.POTIONS_REFININ_TEXT1[7])
							tItem.txtTitlePt = {0.5,0.92}
							tItem.spineEffect = {path = "activity/ui_bengchuang_mxj", _sIndex = "ui_bengchuang_mxj", play = "wait1"}
						end

						table.insert(bigRewards, tItem)
						itemIdIndex = itemIdIndex + 1
					end
				end
				if tResult.pool == 0 then 
					WndHoraryBigReward:showInterface(6, bigRewards)
				elseif tResult.pool == 1 then 
					if tResult.ztzz and tResult.ztzz > 0 then 
						local tItem = {}
						tItem.itemId = self.m_nCoinId2
						tItem.itemNum = tResult.ztzz
						tItem.type = 26
						tItem.spineEffect = {path = "activity/ui_bengchuang_mxj", _sIndex = "ui_bengchuang_mxj", play = "wait1"}

						table.insert(bigRewards, tItem)
					end

					WndHoraryBigReward:showInterface(6, bigRewards)
				end
				
				self.m_nPushNum = 0
				self:_showPotionsRefining()
			end
		end
	elseif self.m_nWinType == 15 then
		if doType == 2 then
			local tResult = json.decode(jsonData)
			local nSex = CacheCenter:getPlayerInfo().sex
			local sBigReward = tResult.rewards
			local array = SplitStringWithSeparator(sBigReward, "&")
			if tResult.pool == 3 then
				local tItem = {reward_ids1 = {}, reward_nums1 = {}, name = "", strAtt = LocalStrings.PLANETSEARCH_TEXT1[4], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31, pool = tResult.pool}
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

				self.m_tBigRewardList2[1] = tItem
			end

			self:_showHolyHand()
		elseif doType == 4 then --选择奖励
			local tResult = json.decode(jsonData)
			if result == 0 then 
				local tTempList = nil 
				local nTag = 0
				if tResult.pool == 3 then 
					tTempList = self.m_tBigRewardList2[1]
					nTag = 1
				end
				if tTempList == nil then
					return
				end
				tTempList.chooseState[tResult.id + 1] = tResult.status
				self:chooseReturn(nTag, tResult.id + 1, tResult.status)
			elseif result == 1 then
				MsgBoxManager:showTipBox(LocalStrings.SUMMERSURF_TEXT1[24])
			end
		elseif doType == 6 then
			local tResult = json.decode(jsonData)
			if result == 1 then
				if tResult.itemIds and tResult.itemNums then
					WndRewardShow:showById(tResult.itemIds, tResult.itemNums)
				end
			end

			--刷新
			self.m_tBigRewardList2 = {}
			local tData = {pool = 3}
			local strJson = json.encode(tData)
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson)
		end
	elseif self.m_nWinType == 16 then
		if doType == 2 then
			local tResult = json.decode(jsonData)
			local nSex = CacheCenter:getPlayerInfo().sex
			local sBigReward = tResult.rewards
			local array = SplitStringWithSeparator(sBigReward, "&")
			if tResult.pool == 2 or tResult.pool == 3 then
				table.insert(self.m_tGetTimes2, tResult.pool)

				local tItem = {reward_ids1 = {}, reward_nums1 = {}, name = "", strAtt = LocalStrings.PLANETSEARCH_TEXT1[4], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31, pool = tResult.pool}
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

				self.m_tBigRewardList2[tResult.pool] = tItem

				if #self.m_tGetTimes2 == 2 then
					self:_updateDragonBallReward()
				end
			end
		elseif doType == 4 then --选择奖励
			local tResult = json.decode(jsonData)
			if result == 0 then 
				local tTempList = nil 
				local nTag = tResult.pool
				if tResult.pool == 2 or tResult.pool == 3 then 
					tTempList = self.m_tBigRewardList2[tResult.pool]
				end
				if tTempList == nil then
					return
				end
				tTempList.chooseState[tResult.id + 1] = tResult.status
				self:chooseReturn(nTag, tResult.id + 1, tResult.status)
			elseif result == 1 then
				MsgBoxManager:showTipBox(LocalStrings.SUMMERSURF_TEXT1[24])
			end
		elseif doType == 5 then
			local tResult = json.decode(jsonData)
			if result == 1 then
				if tResult.itemIds and tResult.itemNums then
					WndRewardShow:showById(tResult.itemIds, tResult.itemNums)
				end
			end

			--刷新
			self.m_tGetTimes2 = {}
			self.m_tBigRewardList2 = {}
			local tData = {pool = 2}
			local tData2 = {pool = 3}
			local strJson = json.encode(tData)
			local strJson2 = json.encode(tData2)
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson)
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson2)
		end
	elseif self.m_nWinType == 19 then  --潘家园-修复
		if doType == 1 then 
			local tResult = json.decode(jsonData)
			WZLog("self.m_nWinType == 19", Serialize(tResult))
			self.m_tPieceState = tResult.giftPointStatus
			self:_showPieceNum()
		elseif doType == 2 then
			local tResult = json.decode(jsonData)
			if tResult.pool == 2 or tResult.pool == 3 then
				if #self.m_tGetTimes2 < 2 then 
					table.insert(self.m_tGetTimes2, tResult.pool)
				end
			end
			local nSex = CacheCenter:getPlayerInfo().sex
			local sBigReward = tResult.rewards
			local array = SplitStringWithSeparator(sBigReward, "&")
			if tResult.pool == 2 then
				local tItem = {reward_ids = {}, reward_nums = {}, name = LocalStrings.POTIONS_REFININ_TEXT1[14], strAtt = LocalStrings.PLANETSEARCH_TEXT1[4], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31, pool = tResult.pool}
				for i = 1, #array do
					local string = string.sub(array[i], 2, -2) 
					local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
					local num = tonumber(SplitStringWithSeparator(string,",")[3])

					table.insert(tItem.reward_ids, id)
					table.insert(tItem.reward_nums, num)
				end

				--空的话赋默认值
				if tResult.globalLimit == nil or #tResult.globalLimit == 0 then 
					for i = 1, #tResult.playerLimitConfig do
						tResult.globalLimit[i] = 0
						tResult.globalLimitConfig[i] = -1
					end
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

				self.m_tBigRewardList2[1] = tItem
			elseif tResult.pool == 3 then
				local tItem = {reward_ids = {}, reward_nums = {}, name = LocalStrings.POTIONS_REFININ_TEXT1[15], strAtt = LocalStrings.PLANETSEARCH_TEXT1[4], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31, pool = tResult.pool}
				for i = 1, #array do
					local string = string.sub(array[i], 2, -2) 
					local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
					local num = tonumber(SplitStringWithSeparator(string,",")[3])

					table.insert(tItem.reward_ids, id)
					table.insert(tItem.reward_nums, num)
				end
				--空的话赋默认值
				if tResult.globalLimit == nil or #tResult.globalLimit == 0 then 
					for i = 1, #tResult.playerLimitConfig do
						tResult.globalLimit[i] = 0
						tResult.globalLimitConfig[i] = -1
					end
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

				self.m_tBigRewardList2[2] = tItem
			end
			WZLog("WndHouseInvite:_onGetOtherData2", #self.m_tGetTimes2)
			if #self.m_tGetTimes2 == 2 then
				self:_showRestoreReward()
			end
		elseif doType == 4 then --选择奖励
			local tResult = json.decode(jsonData)
			if result == 0 then 
				local tTempList = nil 
				local nTag = 0
				if tResult.pool == 3 then 
					tTempList = self.m_tBigRewardList2[2]
					nTag = tResult.pool - 1
				elseif tResult.pool == 2 then 
					tTempList = self.m_tBigRewardList2[1]
					nTag = tResult.pool - 1
				end
				tTempList.chooseState[tResult.id + 1] = tResult.status
				self:chooseReturn(nTag, tResult.id + 1, tResult.status)
			elseif result == 1 then
				MsgBoxManager:showTipBox(LocalStrings.SUMMERSURF_TEXT1[24])
			end
		elseif doType == 6 then --文物修复奖励
			local tResult = json.decode(jsonData)
			if result == 0 then 
				local itemIdIndex = 1
				local bigRewards = {}
				local strTitleFormat = [[<T C="255,255,255" S="46" P="1" SC="222,78,0" SS="4" SE="1">%s</T>]]
				if tResult.itemIds then 
					for i = 1, #tResult.itemIds do
						local tItem = {}
						tItem.itemId = tResult.itemIds[i]
						tItem.itemNum = tResult.itemNums[i]
						tItem.playerItemId = tResult.playerItemIds[itemIdIndex]
						if tResult.id == 0 then --元青花
							tItem.type = 26
							tItem.imgRewardTitle = "ui/newActivity/bt_text_ty_dxj.png"
							tItem.imgBK = "ui/specialBg/hd_pic_ty_dj.png"
							tItem.goodsconPt = {0.515, 0.498}
							tItem.strTitle = string.format(strTitleFormat, LocalStrings.PANJIAYUAN_TEXT1[14])
							tItem.txtTitlePt = {0.5,0.885}
							tItem.spineEffect = {path = "activity/ui_bengchuang_drj", _sIndex = "ui_bengchuang_drj", play = "wait1"}
						elseif tResult.id == 1 then --唐三彩
							tItem.type = 26
							tItem.imgRewardTitle = "ui/newActivity/bt_text_ty_tj.png"
							tItem.imgBK = "ui/specialBg/hd_pic_ty_tj.png"
							tItem.titlePt = {0.5,0.95}
							tItem.imgBKPt = {0.5,0.5}
							tItem.strTitle = string.format(strTitleFormat, LocalStrings.PANJIAYUAN_TEXT1[15])
							tItem.txtTitlePt = {0.5,0.92}
							tItem.spineEffect = {path = "activity/ui_bengchuang_mxj", _sIndex = "ui_bengchuang_mxj", play = "wait1"}
						end

						table.insert(bigRewards, tItem)
						itemIdIndex = itemIdIndex + 1
					end
				end

				WndHoraryBigReward:showInterface(6, bigRewards)
				--刷新对应的奖池奖励选中状态
				local tData = {pool = tResult.id + 2}
				local strJson = json.encode(tData)
				ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson)
				--重置碎片激活状态
				self:_showPieceNum()
			end
		elseif doType == 8 then --赠送
			local tResult = json.decode(jsonData)
			if result == 0 then 
				self.m_tOtherData.dayGiveTimes = tResult.giftTimes
				WndPanJiaYuan:setLeftGiveTimes(tResult.giftTimes)
			end
		elseif doType == 10 then --点亮碎片
			--点亮成功
		end
	end
end

--@brief 	获取活动排行榜数据
function WndHouseInvite:_onRankResult(activityId, activityType, rankingType, myPoint, myRanking, rewardConfig, playerIds, ranks, points, nickname, headIds, 
								   headColors, faceIds, sexs, vipLevel, level, bodyIds, wingIds, title, serverId, session, settlementDate, headEffectId)

	if self.m_root == nil then return end

	if self.m_tRankData == nil then
		self.m_tRankData = {}
	end
	if self.m_tRankOther == nil then
		self.m_tRankOther = {}
	end
	if self.m_nWinType == 13 then
		if rankingType == 2 then
			self.m_tRankOther[rankingType] = {}
			self.m_tRankOther[rankingType].myPoint = myPoint
			self.m_tRankOther[rankingType].myRanking = myRanking
			self.m_tRankOther[rankingType].rewardConfig = analyzeActivityReward(json.decode(rewardConfig))

			self.m_tRankData[rankingType] = {}

			local nRankIndex = 0
			local nCurScore = 0
			for i=1,#playerIds do
				if nRankIndex == 0 and nCurScore ~= points[i] then 
					nRankIndex = nRankIndex + 1
					nCurScore = points[i]
				elseif nCurScore ~= points[i] then 
					nRankIndex = nRankIndex + 1
				end

				local tData = {}
				tData.playerIds = playerIds[i]
				tData.ranks = nRankIndex
				tData.points = points[i]
				tData.nickname = nickname[i]
				tData.headIds = headIds[i]
				tData.headColors = headColors[i]
				tData.faceIds = faceIds[i]
				tData.sexs = sexs[i]
				tData.vipLevel = vipLevel[i]
				tData.level = level[i]
				tData.bodyIds = bodyIds[i]
				tData.windIds = wingIds[i]
				tData.title = title[i]
				tData.serverId = serverId[i]
				tData.headEffectId = headEffectId[i]
				table.insert(self.m_tRankData[rankingType], tData)
			end

			self:_showAffRank2()
		elseif rankingType == 3 then
			self.m_tRankData[rankingType] = {}
			for i=1,#playerIds do
				local tData = {}
				tData.playerIds = playerIds[i]
				tData.ranks = ranks[i]
				tData.points = points[i]
				tData.nickname = nickname[i]
				tData.headIds = headIds[i]
				tData.headColors = headColors[i]
				tData.faceIds = faceIds[i]
				tData.sexs = sexs[i]
				tData.vipLevel = vipLevel[i]
				tData.level = level[i]
				tData.bodyIds = bodyIds[i]
				tData.windIds = wingIds[i]
				tData.title = title[i]
				tData.serverId = serverId[i]
				tData.headEffectId = headEffectId[i]
				table.insert(self.m_tRankData[rankingType], tData)
			end
			self:_showAffRank1()
		end
	elseif self.m_nWinType == 18 then
		if rankingType == 2 then
			self.m_tRankOther[rankingType] = {}
			self.m_tRankOther[rankingType].myPoint = myPoint
			self.m_tRankOther[rankingType].myRanking = myRanking
			self.m_tRankOther[rankingType].rewardConfig = analyzeActivityReward(json.decode(rewardConfig))

			self.m_tRankData[rankingType] = {}

			local nRankIndex = 0
			local nCurScore = 0
			for i=1,#playerIds do
				if nRankIndex == 0 and nCurScore ~= points[i] then 
					nRankIndex = nRankIndex + 1
					nCurScore = points[i]
				elseif nCurScore ~= points[i] then 
					nRankIndex = nRankIndex + 1
				end

				local tData = {}
				tData.playerIds = playerIds[i]
				tData.ranks = nRankIndex
				tData.points = points[i]
				tData.nickname = nickname[i]
				tData.headIds = headIds[i]
				tData.headColors = headColors[i]
				tData.faceIds = faceIds[i]
				tData.sexs = sexs[i]
				tData.vipLevel = vipLevel[i]
				tData.level = level[i]
				tData.bodyIds = bodyIds[i]
				tData.windIds = wingIds[i]
				tData.title = title[i]
				tData.serverId = serverId[i]
				tData.headEffectId = headEffectId[i]
				table.insert(self.m_tRankData[rankingType], tData)
			end

			self:_showLeiZhuZhen1()
		end
	end
end



--@brief 	获取射箭任务列表
function WndHouseInvite:_onGetTaskInfo2(activityId, activityType, taskType, id, status, target, progress, progressCount, refreshTime, taskGroup)
	if activityId == self.m_nActivityId then 
		local tab = CellNewYearTask:setTaskData(id, status, target, progress, activityId)
--		WZLog("WndShopRank:_onGetTaskInfo2", taskType, taskGroup, Serialize(tab))

		if self.m_nWinType == 13 then
			if self.m_nCurIndex == 2 and taskType == -1 and taskGroup == 4 then
				self.m_tTaskList = tab
				self:_showTaskContent()
			end
		elseif self.m_nWinType == 18 then
			if self.m_nCurIndex == 1 and taskType == -1 and taskGroup == 4 then
				self.m_tTaskList = tab
				self:_showTaskContent()
			end
		end
	end
end

--@brief 	射箭任务奖励
function WndHouseInvite:_onGetTaskResult2(activityId, id)
--	WZLog("WndShopRank:_onGetTaskResult2", self.m_nActivityId, activityId, id)
	if self.m_nActivityId ~= activityId then
		MsgBoxManager:showTipBox(LocalStrings.RETURNEE_TEXT28)
		return
	end
	
	if self.m_nWinType == 13 then
		local taskData = GDatatab_new_activity_task["id_" .. id]
		if taskData and taskData.group_by == 4 then
			CellNewYearTaskOther:setTeskGetResult(id)
			CellNewYearTaskOther:setRedPoint(GetElement(self.m_root, "imgRedDot2_WndHouseInvite", WZUIImage))
		end
	elseif self.m_nWinType == 18 then
		local taskData = GDatatab_new_activity_task["id_" .. id]
		if taskData and taskData.group_by == 4 then
			CellNewYearTaskOther:setTeskGetResult(id)
			CellNewYearTaskOther:setRedPoint(GetElement(self.m_root, "imgRedDot1_WndHouseInvite", WZUIImage))
		end
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
CellEightDiagramItem = {}
function CellEightDiagramItem:_init()
	self.m_root = nil	 	  			--场景根节点
	
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellEightDiagramItem:_unInit()
	self.m_root = nil

end

--@brief	创建控件
function CellEightDiagramItem:createElement()
	local tNewObj = self:_new()
	tNewObj:_init()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(376,112))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellEightDiagramItem:onEnter(element)
	
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellEightDiagramItem:onExit(element)
	self:_unInit()
end

--@brief 	八卦方位点击领取按钮回调
function CellEightDiagramItem:onGetReward(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	local tData = {}
	tData.id = {nTag}
	tData.num = {1}

	local stringData = json.encode(tData)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(WndHouseInvite.m_nActivityId, 5, stringData)
end

--@brief 加载
function CellEightDiagramItem:setData(tData)
	-- body
	self.m_tData = tData 

	local celElement = WZUISystem:getInstance():createElement("CellItem_cellEightDiagram")
    self.m_root:addChild(celElement)

    self:_update(celElement)
end

--@brief 加载
function CellEightDiagramItem:_update(element)
	element:setVisible(true)
	local ftxtDesc = GetElement(element, "ftxtDesc_cellEightDiagram", WZUIFreeTextBox)
	local btnGetReward = GetElement(element, "btnGetReward_cellEightDiagram", WZUIButton)
	local desc = nil 
	local tFormatList = {LocalStrings.SECRETTOWER_TEXT1[26], LocalStrings.SECRETTOWER_TEXT1[27]}
	if self.m_tData.cost then 
		if #self.m_tData.cost == 8 then 
			desc = tFormatList[2]
		else
			desc = tFormatList[1]
			local strWords = ""
			for j = 1, #self.m_tData.cost do
				local tempData = GDatatab_item["id_" .. self.m_tData.cost[j][1]]
				if j > 1 then 
					strWords = strWords .. "、"
				end
				strWords = strWords .. tempData.name
			end
			desc = string.format(desc, strWords)
		end
		ftxtDesc:setShowText(desc)
	end
	btnGetReward:setTag(self.m_tData.id)
	local conForReward = GetElement(self.m_root, "conForReward_CellItem", WZUIContainer)

	local nPosStart2 = 0.12
	local nPadding2 = 0.24
	for j = 1, #self.m_tData.reward do
		if j > 4 then break end 
		local tempReward = self.m_tData.reward[j]
		local celElement, tNewObj = CellGoodItem:createElement()
		if celElement and tNewObj then 
			celElement:setTag(j - 1)
			celElement:setScale(0.8)
			tNewObj:setCellGoodLocalId(tempReward[1], tempReward[2], 17)
			tNewObj:setItemClickFun(WndHouseInvite, WndHouseInvite.onClickItem)
			celElement:setRelativePosition(GlobalMethod:ccp(nPosStart2 + nPadding2 * (j - 1), 0.5))
			conForReward:addChild(celElement)
		end
	end

	self:setBtnState()
end

--@brief 	设置按钮是否可点击
function CellEightDiagramItem:setBtnState()
	WZLog("CellEightDiagramItem:setBtnState", type(self.m_root))
	if self.m_root == nil then return end 

	local btnGetReward = GetElement(self.m_root, "btnGetReward_cellEightDiagram", WZUIButton)
	local bCanTouch = true 
	for j = 1, #self.m_tData.cost do
		local nOwnNum = CacheCenter:getPlayerItemCountById(self.m_tData.cost[j][1])
		if nOwnNum < self.m_tData.cost[j][2] then 
			bCanTouch = false 
			break 
		end
	end

	btnGetReward:setTouchEnable(bCanTouch)
end

--@return	新建的表实例对象
function CellEightDiagramItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

CellCampFireTaskItem = {}
function CellCampFireTaskItem:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tGoodItemCell = {}
	self.m_nTaskRewardId = nil
	self.m_nType = nil 
	self.m_bIsLoaded = false 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellCampFireTaskItem:_unInit()
	self.m_root = nil
	self.m_tGoodItemCell = nil 
	self.m_nTaskRewardId = nil
	self.m_nType = nil 
	self.m_bIsLoaded = nil 
end

--@brief	创建控件
function CellCampFireTaskItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(372,122))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end

function CellCampFireTaskItem:setGiftBuyMessage(index, data, nType)
	self.m_nIndex = index
	self.m_tTaskItemData = data
	self.m_nType = nType 
end

function CellCampFireTaskItem:resetGiftBuyMessage(index, data, nType)
	self.m_nIndex = index
	self.m_tTaskItemData = data
	if self.m_bIsLoaded then 
		self:setTaskDayDataItem()
	end
end

--@brief 	开始加载
function CellCampFireTaskItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("CellCampFireTaskItem")
	celElement:setVisible(true)
	element:addChild(celElement)
	self.m_bIsLoaded = true 

	self:setTaskDayDataItem()

	AdaptLanguage(self)
end

function CellCampFireTaskItem:setTaskDayDataItem()
	if not self.m_tTaskItemData then return end
	local data = self.m_tTaskItemData

	self.m_tGoodItemCell = {}
	self:setTaskItemMessage(self.m_nIndex,data)
end
function CellCampFireTaskItem:setTaskItemMessage(index,data)
	--0=不可领取|1=可领取|2=已领取
	self.m_nIndex = index
	self.m_tTaskItemData = data
	if not self.m_bIsLoaded then return end 
	
	GetElement(self.m_root,"btnGet_CellCampFireTaskItem",WZUIButton):setTouchEnable(data.status == 1)
	if data.status == 2 then 
		GetElement(self.m_root,"btnGet_CellCampFireTaskItem",WZUIButton):setVisible(false)
	end
	GetElement(self.m_root,"imgGet_CellCampFireTaskItem",WZUIImage):setVisible(data.status == 2)
	local txtDescTitle = GetElement(self.m_root,"txtDescTitle_CellCampFireTaskItem",WZUILabelTTF)
	local ftxtDescTitle = GetElement(self.m_root, "ftxtDescTitle_CellCampFireTaskItem", WZUIFreeTextBox)
	if string.find(data.desc, "<T") == nil then
		txtDescTitle:setText(data.desc)
	else
		ftxtDescTitle:setShowText(data.desc)
	end

	self.m_nTaskRewardId = data.id
	for i=1,6 do --最大6个奖励
		if self.m_tGoodItemCell and self.m_tGoodItemCell[i] and self.m_tGoodItemCell[i].celElement then
			self.m_tGoodItemCell[i].celElement:setVisible(false)
		end
	end
	local good_con = GetElement(self.m_root,"good_con_CellCampFireTaskItem",WZUIContainer)
	WZLog("CellCampFireTaskItem:setTaskItemMessage", Serialize(data.ids))
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
			celElement:setScale(0.75)
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
			local _x = 35 + (i-1) * 65
			celElement:setAbsPosition(GlobalMethod:ccp(_x, 30))
			celElement:setVisible(true)
		end
	end
end
--@brief	点击物品弹出对应的tips
function CellCampFireTaskItem:onItemClick(tCell,tag,tData)
    if tData == nil then
        return
    end
    WndItemInfo:onCloseClick()

   	WndItemInfo:showInfo(tCell.m_root,WndHouseInvite.m_root,1,tData,false,nil,true)
end
function CellCampFireTaskItem:onBtnGoto()
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
		CellNewYearTask:onBtnClickClose()
	end
end
function CellCampFireTaskItem:onBtnGet()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WZLog("CellCampFireTaskItem:onBtnGet", self.m_tTaskItemData.activityId, self.m_nTaskRewardId)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ReceiveTaskReward(self.m_tTaskItemData.activityId, self.m_nTaskRewardId)
end
--@return	新建的表实例对象
function CellCampFireTaskItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------语言适配Begin----------------------------------------

function CellCampFireTaskItem:_adaptLanguage_vn()
	local ftxtDescTitle = GetElement(self.m_root, "ftxtDescTitle_CellCampFireTaskItem", WZUIFreeTextBox)
	ftxtDescTitle:setScale(0.7)
end

-------------------------------------语言适配End----------------------------------------



CellCatchFishItem = {}
function CellCatchFishItem:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tGoodItemCell = {}
	self.m_nTaskRewardId = nil
	self.m_nType = nil 
	self.m_bIsLoaded = false 
	self.m_tClickCell = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellCatchFishItem:_unInit()
	self.m_root = nil
	self.m_tGoodItemCell = nil 
	self.m_nTaskRewardId = nil
	self.m_nType = nil 
	self.m_bIsLoaded = nil 
	self.m_tClickCell = nil 
end

--@brief	创建控件
function CellCatchFishItem:createElement(nType)
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	if nType == 1 then 
		element:setAbsContentSize(GlobalMethod:CCSize(260,134))
	elseif nType == 2 then 
		element:setAbsContentSize(GlobalMethod:CCSize(826,128))
	end
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_nType = nType
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end

function CellCatchFishItem:setGiftBuyMessage(data)
	self.m_tTaskItemData = data 
end

function CellCatchFishItem:getGiftBuyMessage()
	return self.m_tTaskItemData 
end

function CellCatchFishItem:resetGiftBuyMessage(data)
	self.m_tTaskItemData = data
	self.m_tClickCell = nil 
	if self.m_bIsLoaded then 
		self:setTaskDayDataItem()
	end
end

--@brief 	开始加载
function CellCatchFishItem:onLoadData(element)
	local celElement = nil 
	if self.m_nType == 1 then 
		celElement = WZUISystem:getInstance():createElement("CellCatchFishSItem")
	elseif self.m_nType == 2 then 
		celElement = WZUISystem:getInstance():createElement("CellCatchFishLItem")
	end
	celElement:setVisible(true)
	element:addChild(celElement)
	self.m_bIsLoaded = true 

	self:setTaskDayDataItem()

	AdaptLanguage(self)
end

function CellCatchFishItem:setTaskDayDataItem()
	if not self.m_tTaskItemData then return end
	local data = self.m_tTaskItemData

	self.m_tGoodItemCell = {}
	self:setTaskItemMessage(data)
end
function CellCatchFishItem:setTaskItemMessage(data)
	--0=不可领取|1=可领取|2=已领取
	self.m_tTaskItemData = data
	if not self.m_bIsLoaded then return end 
	
	local ownNum = CacheCenter:getPlayerItemCountById(data.cost[1])
	if ownNum < data.cost[2] then 
		if data.status ~= 2 then 
			data.status = 0
		end
	end
	local btnGet = GetElement(self.m_root,"btnGet_CellCatchFishItem",WZUIButton)
	if btnGet:getChildByTag(88) then 
		btnGet:removeChildByTag(88, true)
	end
	btnGet:setTouchEnable(data.status == 1)
	if data.status == 2 then 
		btnGet:setVisible(false)
	end
	local txtDescTitle = GetElement(self.m_root,"txtDescTitle_CellCatchFishItem",WZUILabelTTF)
	local ftxtDescTitle = GetElement(self.m_root, "ftxtDescTitle_CellCatchFishItem", WZUIFreeTextBox)
	local ftxtLimit = GetElement(self.m_root, "ftxtLimit_CellCatchFishItem", WZUIFreeTextBox)
	local descFormat = [[<T C="127,70,26" S="20" P="1">%s</T><T C="229,105,22" S="20" P="1">%d/%d</T>]]
	local limitFormat = [[<T C="255,255,255" S="14" P="1">%s</T><T C="255,227,116" S="14" P="1">%d/%d</T>]]
	local costBasicInfo = GDatatab_item["id_" .. data.cost[1]]
	ftxtDescTitle:setShowText(string.format(descFormat, costBasicInfo.name, ownNum, data.cost[2]))
	if data.dailyNum then 
		local bVisibleLimit, strLimit = GetLimitData(data.buyNum, data.num, data.dailyNum, data.dayBuyNum)
		if bVisibleLimit then 
			GetElement(self.m_root, "imgCorner_CellCatchFishItem", WZUIImage):setVisible(true)
			local limitFormat2 = [[<T C="255,255,255" S="14" P="1">%s</T>]]
			ftxtLimit:setShowText(string.format(limitFormat2, strLimit))
		end
	else
		if data.num > 0 then 
			GetElement(self.m_root, "imgCorner_CellCatchFishItem", WZUIImage):setVisible(true)
			ftxtLimit:setShowText(string.format(limitFormat, LocalStrings.WATERMELON_TEXT1[25] .. ":", data.buyNum, data.num))
		end
	end
	if self.m_nType == 1 then 
		if data.status == 1 then 
			btnGet:setVisible(true)
			local spineData = {path="ui/ui_common_JJLQ", play="wait_1", loop=true}
			local spineEffect = createEffectSpine(btnGet,spineData)
			spineEffect:setTag(88)
			WZLog("CellCatchFishItem:setTaskItemMessage 00", tostring(spineEffect))
		end
		GetElement(self.m_root,"imgGet_CellCatchFishItem",WZUIImage):setVisible(data.status == 2)
		if WndHouseInvite.m_tOtherData then 
			if WndHouseInvite.m_tOtherData.img9TitleBg then 
				GetElement(self.m_root, "img9Bg_CellCatchFishSItem", WZUI9Image):setFile(WndHouseInvite.m_tOtherData.img9Bg)
			end
			if WndHouseInvite.m_tOtherData.img9TitleBg then 
				GetElement(self.m_root, "img9TitleBg_cellCatchFishItem", WZUI9Image):setFile(WndHouseInvite.m_tOtherData.img9TitleBg)
			end
		end
	elseif self.m_nType == 2 then 
		GetElement(self.m_root, "txtDescTitle2_CellCatchFishItem", WZUILabelTTF):setText(LocalStrings.CATCHFISH_TEXT1[22])
		GetElement(self.m_root,"imgGet_CellCatchFishItem",WZUIImage):setVisible(data.status == 2)
	end

	self.m_nTaskRewardId = data.id
	for i=1,6 do --最大6个奖励
		if self.m_tGoodItemCell and self.m_tGoodItemCell[i] and self.m_tGoodItemCell[i].celElement then
			self.m_tGoodItemCell[i].celElement:setVisible(false)
		end
	end
	local conGood1 = GetElement(self.m_root,"conGood1_CellCatchFishItem",WZUIContainer)
	local conGood2 = GetElement(self.m_root,"conGood2_CellCatchFishItem",WZUIContainer)
	WZLog("CellCatchFishItem:setTaskItemMessage", Serialize(data.ids))
	for i=1, #data.ids do
		local key = "id_"..data.ids[i]
		local tabItem = GDatatab_item[key]
		local num = data.nums[i]
		local itemInfo = {lastTime=num,lastNum=num,basicInfo=CopyTable(GDatatab_item[key]), rootNode = WndHouseInvite.m_root, bShowAll = false, index = i}
		if self.m_tGoodItemCell == nil or self.m_tGoodItemCell[i] == nil then
			if self.m_tGoodItemCell == nil then 
				self.m_tGoodItemCell = {}
			end
			local celElement,tLuaObj = CellGoodItem:createElement()
			conGood2:addChild(celElement)
			celElement:setUseAbsCoordinate(true)
			local tab = {}
			tab.celElement = celElement
			tab.tLuaObj = tLuaObj
			self.m_tGoodItemCell[i] = tab
		end
		if self.m_tGoodItemCell[i] and self.m_tGoodItemCell[i].celElement and self.m_tGoodItemCell[i].tLuaObj then
			local celElement = self.m_tGoodItemCell[i].celElement
			local tLuaObj = self.m_tGoodItemCell[i].tLuaObj
			local nType = 31
			tLuaObj:setCellGoodItem(itemInfo, nType)
			local _x = 40 + (i-1) * 85
			
			if self.m_nType == 1 then 
				tLuaObj:setItemClickFun(self,self.onItemClick3)
			else
				tLuaObj:setItemClickFun(self,self.onItemClick2)
			end
			celElement:setAbsPosition(GlobalMethod:ccp(_x, 40))
			celElement:setVisible(true)
		end
	end

	--消耗
	conGood1:removeAllChildrenWithCleanup(true)
	local celElement,tLuaObj = CellGoodItem:createElement()
	local key = "id_"..data.cost[1]
	local tabItem = GDatatab_item[key]
	local itemInfo = {lastTime=data.cost[2],lastNum=data.cost[2],basicInfo=CopyTable(GDatatab_item[key]), rootNode = WndHouseInvite.m_root, bShowAll = false}
	tLuaObj:setCellGoodItem(itemInfo, 17)
	tLuaObj:setItemClickFun(self,self.onItemClick)
	conGood1:addChild(celElement)
end
--@brief	点击物品弹出对应的tips
function CellCatchFishItem:onItemClick3(tCell,tag,tData)
    if tData == nil then
        return
    end
    WndItemInfo:onCloseClick()

    if self.m_nType == 1 and self.m_tTaskItemData.status == 1 then 
    	self:onBtnGet()
    else
   		WndItemInfo:showInfo(tCell.m_root,WndHouseInvite.m_root,1,tData,false,nil,true)
   	end
end

--@brief	点击物品弹出对应的tips
function CellCatchFishItem:onItemClick(tCell,tag,tData)
    if tData == nil then
        return
    end
    WndItemInfo:onCloseClick()

   	WndItemInfo:showInfo(tCell.m_root,WndHouseInvite.m_root,1,tData,false,nil,true)
end

--@brief	点击物品弹出对应的tips
function CellCatchFishItem:onItemClick2(tCell,tag,tData)
    if tData == nil then
        return
    end
    if self.m_tClickCell then 
    	local tTempData = self.m_tClickCell:getData()
    	if tTempData.index ~= tData.index then 
    		self.m_tClickCell:setItemSelState(false)
    	else
    		self.m_tClickCell:setItemSelState(false)
    		self.m_tClickCell = nil 
    		return 
    	end
    end
    self.m_tClickCell = tCell
    self.m_tClickCell:setItemSelState(true)
end

function CellCatchFishItem:onBtnGet()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WZLog("CellCatchFishItem:onBtnGet", self.m_tTaskItemData.activityId, self.m_nTaskRewardId)
	if self.m_nType == 1 then 
		local strJson = ""
		local doType = 6 
		if WndHouseInvite.m_tOtherData then 
			local tData = {id={}, num = {}}
			tData.id[1] = self.m_nTaskRewardId - 1
			tData.num[1] = 1

			strJson = json.encode(tData)
			doType = WndHouseInvite.m_tOtherData.doType
		else
			local tData = {id = self.m_nTaskRewardId - 1, rewardId = 0}
			strJson = json.encode(tData)
		end
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_tTaskItemData.activityId, doType, strJson)
	elseif self.m_nType == 2 then 
		if self.m_tClickCell == nil then 
			MsgBoxManager:showTipBox(LocalStrings.CATCHFISH_TEXT1[23])
			return 
		end
		local tSelData = self.m_tClickCell:getData()
		local tData = {id = self.m_nTaskRewardId - 1, rewardId = tSelData.index - 1}
		local strJson = json.encode(tData)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_tTaskItemData.activityId, 6, strJson)
	end
end
--@return	新建的表实例对象
function CellCatchFishItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配Begin----------------------------------------

function CellCatchFishItem:_adaptLanguage_vn()
	local ftxtLimit = GetElement(self.m_root, "ftxtLimit_CellCatchFishItem", WZUIFreeTextBox)
	ftxtLimit:setScale(0.7)
end

-------------------------------------语言适配End----------------------------------------