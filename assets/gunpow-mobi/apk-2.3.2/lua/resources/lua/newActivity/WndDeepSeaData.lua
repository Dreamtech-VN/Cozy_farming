--WndDeepSeaData.lua
--@brief	WndDeepSea的数据模块
--@date		2023/08/15
--@author	XTX
--@note		深海寻宝活动主界面

WndDeepSea = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndDeepSea:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_tBigRewardList = nil 		--大奖和特奖奖励
	self.m_bOpenState = false 
	self.m_tOpenResult = nil 
	self.m_nCoinId = 160492
	self.m_nMaxLotteryCount = 20    --最大抽奖次数
	self.m_nCount = 0 
	self.m_tBallAniName = {{"wait", "1", "1"}, {"wait", "2", "2"}}
	self.m_nCalabashType = 0 			--当前选中的力度索引
	self.m_tCostByType = nil 
	self.m_nChooseReward = 0 		--选择奖励状态0：弹出预览界面；1：不弹
	self.m_nTalkGapping = nil 
	self.m_nLastTalkIndex = 0
	self.m_bIsOpenReward = false 
	self.m_nAniType = 1 
	self.m_tLvRewardList = nil 
	self.m_nCurExp = 0 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndDeepSea:_unInit()
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
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndDeepSea:createElement()
	if WndDeepSea.m_root ~= nil then
		WindowManager:removeWindow(WndDeepSea.m_root, WndDeepSea, true)
	end
	local element = WZUISystem:getInstance():createElement("WndDeepSea")
	assert(element, "WndDeepSea create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndDeepSea:showInterface()
	LoadNewActivityRes(true)
	local wndWater = WndDeepSea:createElement()
	if wndWater then 
		WindowManager:addWindow(wndWater, WndDeepSea, false)
	end
end

--@brief 	获取活动详情成功
function WndDeepSea:GetActivityInfoOK(activityId,maxCount,count,status, rewardCounts, rewardItems, rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	-- body
	WZLog("WndDeepSea:GetActivityInfoOK", activityId)
	if g_cityExtenInfo.activity7089 == activityId then 
		self.m_tContent = json.decode(content)
		self.m_nStartTime = startTime 
		self.m_nEndTime = endTime 
		self.m_nActivityId = activityId
		self.m_nCount = count
		WZLog("self.m_tContentself.m_tContent", Serialize(self.m_tContent))
		self.m_tCostByType = {finishCondition[1], finishCondition[2]}

		self.m_nChooseReward = GetOperateTimes("DEEPSEAACTIVITYID", self.m_nActivityId)
		if self.m_tLvRewardList == nil then 
			self.m_tLvRewardList = {}
		end
		local tLvRewards = json.decode(self.m_tContent.levelRewards)
		for i = 1, #self.m_tContent.levelExps do
			if self.m_tLvRewardList[i] == nil then 
				self.m_tLvRewardList[i] = {}
			end
			self.m_tLvRewardList[i].lv = i
			self.m_tLvRewardList[i].name = LocalStrings.DEEPSEA_TEXT1[17][i + 1]
			self.m_tLvRewardList[i].reward = tLvRewards[i]
			self.m_tLvRewardList[i].exp = self.m_tContent.levelExps[i]
			self.m_tLvRewardList[i].activityId = activityId
		end

		self:_analyzeBigReward()
		self:_showLvAndExp()
		self:_update()
	end
end

--@brief 	获取其他活动数据
function WndDeepSea:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end 

	if doType == 1 then --等级奖励数据
		local tResult = json.decode(jsonData)
		WZLog("WndBilliardBall:_onGetOtherData 111", Serialize(tResult))
		self.m_nCurExp = tResult.levelExp

		local bUpdateShow = true 
		if self.m_tLvRewardList == nil then 
			self.m_tLvRewardList = {}
			bUpdateShow = false
		end
		for i = 1, #tResult.levelRewardStatus do
			if self.m_tLvRewardList[i] == nil then 
				self.m_tLvRewardList[i] = {}
			end
			self.m_tLvRewardList[i].status = tResult.levelRewardStatus[i]
		end
		if bUpdateShow then 
			self:_showLvAndExp()
		end
		self:showRedDot()
		local tTempList = self.m_tBigRewardList[2]
		for i = 1, #tResult.superGlobalLimit do
			tTempList.leftConfig[i].dailyBuyNum = tResult.superGlobalLimit[i]
			tTempList.leftConfig[i].soldNum = tResult.superPlayerLimit[i]
			if utilsValueInTable(i - 1, tResult.superOptionalList) then 
				tTempList.chooseState[i] = 1
			else
				tTempList.chooseState[i] = 0
			end
		end

		local tTempList1 = self.m_tBigRewardList[1]
		for i = 1, #tResult.normalGlobalLimit do
			tTempList1.leftConfig[i].dailyBuyNum = tResult.normalGlobalLimit[i]
			tTempList1.leftConfig[i].soldNum = tResult.normalPlayerLimit[i]
			if utilsValueInTable(i - 1, tResult.normalOptionalList) then 
				tTempList1.chooseState[i] = 1
			else
				tTempList1.chooseState[i] = 0
			end
		end
		if self.m_bIsOpenReward then 
			self.m_bIsOpenReward = false 
			local otherData = {}
			otherData.winType = 1
			otherData.activityId = self.m_nActivityId
			otherData.otherRewardData = self.m_tBigRewardList[3]
			WndJoinReward:showInterface("", self.m_tBigRewardList[1], self.m_tBigRewardList[2], LocalStrings.WATERMELON_TEXT1[22], false, 3, otherData)
		end
	elseif doType == 3 then --开启结果
		local tResult = json.decode(jsonData)
		WZLog("WndDeepSea:_onGetOtherData 333", Serialize(tResult))
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
				tItem.strTitle = string.format(strTitleFormat, LocalStrings.DEEPSEA_TEXT1[12])
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
				tItem.strTitle = string.format(strTitleFormat, LocalStrings.DEEPSEA_TEXT1[13])
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
				tItem.strTitle = string.format(strTitleFormat, LocalStrings.DEEPSEA_TEXT1[14])
				tItem.txtTitlePt = {0.5,0.95}
				tItem.spineEffect = {path = "activity/ui_bengchuang_mxj", _sIndex = "ui_bengchuang_mxj", play = "wait1"}

				table.insert(self.m_tOpenResult.bigRewards, tItem)
			
				itemIdIndex = itemIdIndex + 1
			end
		end

		--获得的五音奖励
		if tResult.extItemNums and tResult.extItemNums > 0 then 
			local tItem = {160493, tResult.extItemNums}
			table.insert(self.m_tOpenResult.otherRewards, tItem)
		end

		if result == 1 then 
			self.m_nCount = tResult.count
			self.m_tOpenResult.addExp = tResult.addExp

			self:showOpenAction()
			self:_setFreeBtnText()
		else
			self:setOpenState(false)
		end
	elseif doType == 8 then --选择奖励
		local tResult = json.decode(jsonData)
		WZLog("WndDeepSea:_onGetOtherData 444", Serialize(tResult))
		if result == 0 then 
			local tTempList = nil 
			local nTag = 0
			if tResult.pool == 0 then 
				tTempList = self.m_tBigRewardList[2]
				nTag = 2
			elseif tResult.pool == 1 then 
				tTempList = self.m_tBigRewardList[1]
				nTag = 3
			end
			tTempList.chooseState[tResult.id + 1] = tResult.status
			WndJoinReward:chooseReturn(nTag, tResult.id + 1, tResult.status)
		elseif result == 1 then
			MsgBoxManager:showTipBox(LocalStrings.SUMMERSURF_TEXT1[24])
		end
	elseif doType == 7 then --领取等级奖励
		local tResult = json.decode(jsonData)
		WZLog("WndBilliardBall:_onGetOtherData 666", Serialize(tResult))
		if result == 0 then 
			self.m_tLvRewardList[tResult.level].status = 2
			WndRewardShow:showById(tResult.itemIds, tResult.itemNums)

			self:showRedDot()
			self:_createLvRewardList()
		end
	end
end

--@brief	缓存推送更新物品时调用的函数
function WndDeepSea:updatePlayerItemData()
	WZLog("WndDeepSea:updatePlayerItemData")
	if self.m_root ~= nil then
		self:_updateLightNum()
	end
end

--@brief 	设置射箭的状态
function WndDeepSea:setOpenState(state)
	-- body
	if self.m_root == nil then return end 

	self.m_bOpenState = state
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	解析大奖数据
function WndDeepSea:_analyzeBigReward()
	-- body
	local sBigReward = self.m_tContent.firstRewards
	local array = SplitStringWithSeparator(sBigReward, "&")
	local nSex = CacheCenter:getPlayerInfo().sex
	local tItem = {reward_ids = {}, reward_nums = {}, name = LocalStrings.DEEPSEA_TEXT1[12], listBgSize = {474,228}, listBgPos = {0.5,0.431}}
	self.m_tBigRewardList = {}
	for i = 1, #array do
		local string = string.sub(array[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string,",")[3])

		table.insert(tItem.reward_ids, id)
		table.insert(tItem.reward_nums, num)
	end

	self.m_tBigRewardList[3] = tItem

	local specialReward = self.m_tContent.superRewards
	local array1 = SplitStringWithSeparator(specialReward, "&")
	local tItem1 = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.DEEPSEA_TEXT1[13], strAtt = LocalStrings.DEEPSEA_TEXT1[16], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461} , cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31}
	for i = 1, #array1 do
		local string = string.sub(array1[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string,",")[3])

		local tab = {}
		tab.id = i - 1
		tab.limitNum = self.m_tContent.superPlayerLimitConfig[i]
		tab.dailyLimit = self.m_tContent.superGlobalLimitConfig[i]

		table.insert(tItem1.reward_ids2, id)
		table.insert(tItem1.reward_nums2, num)
		table.insert(tItem1.chooseState, 0)
		table.insert(tItem1.leftConfig, tab)
	end

	self.m_tBigRewardList[2] = tItem1

	local specialReward2 = self.m_tContent.normalRewards
	local array2 = SplitStringWithSeparator(specialReward2, "&")
	local tItem2 = {reward_ids1 = {}, reward_nums1 = {}, name = LocalStrings.DEEPSEA_TEXT1[14], strAtt = LocalStrings.DEEPSEA_TEXT1[16], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31}
	for i = 1, #array2 do
		local string = string.sub(array2[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string,",")[3])

		local tab = {}
		tab.id = i - 1
		tab.limitNum = self.m_tContent.normalPlayerLimitConfig[i]
		tab.dailyLimit = self.m_tContent.normalGlobalLimitConfig[i]

		table.insert(tItem2.reward_ids1, id)
		table.insert(tItem2.reward_nums1, num)
		table.insert(tItem2.chooseState, 0)
		table.insert(tItem2.leftConfig, tab)
	end

	self.m_tBigRewardList[1] = tItem2
end

--@brief 	关闭抽奖奖励展示界面回调
function WndDeepSea:_afterCloseReward()
	if self.m_root == nil then return end 

	if self.m_tOpenResult.normalRewards and #self.m_tOpenResult.normalRewards > 0 then 
		WndHoraryBigReward:showInterface(8, self.m_tOpenResult.normalRewards, self.m_tOpenResult.bigRewards)
	elseif #self.m_tOpenResult.bigRewards > 0 then 
		WndHoraryBigReward:showInterface(9, self.m_tOpenResult.bigRewards)
	end
end

--@brief 	获取当前捕鼠等级
function WndDeepSea:getCurLvInfo()
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
