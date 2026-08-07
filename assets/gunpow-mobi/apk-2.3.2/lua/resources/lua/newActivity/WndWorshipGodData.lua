--WndWorshipGodData.lua
--@brief	WndWorshipGod的数据模块
--@date		2022/12/27
--@author	XTX
--@note		拜财神活动界面

WndWorshipGod = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndWorshipGod:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_tBigRewardList = nil 		--大奖和特奖奖励
	self.m_bOpenState = false 
	self.m_tOpenResult = nil 
	self.m_nCoinId = 160392
	self.m_nCoinId2 = 160393
	self.m_nCoinId3 = 160398
	self.m_nMaxLotteryCount = 20    --最大抽奖次数
	self.m_nCount = 0 
	self.m_tBallAniName = {"wait", "wait_1", "wait_2"}
	self.m_tRedPackConfig = nil 	--红包配置
	self.m_nAniType = 2 			--抽奖动画索引
	self.m_nChooseReward = 0 		--选择奖励状态0：弹出预览界面；1：不弹
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndWorshipGod:_unInit()
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
	self.m_nCurExp = nil  
	self.m_tLvRewardList = nil 			--捕鼠奖励列表
	self.m_nCurLevel = nil 				--当前等级
	self.m_nMaxLotteryCount = nil    --最大抽奖次数
	self.m_nCount = nil 
	self.m_tBallAniName = nil 
	self.m_tRedPackConfig = nil 	--红包配置
	self.m_nAniType = nil 
	self.m_nChooseReward = nil 		--选择奖励状态0：弹出预览界面；1：不弹
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndWorshipGod:createElement()
	if WndWorshipGod.m_root ~= nil then
		WindowManager:removeWindow(WndWorshipGod.m_root, WndWorshipGod, true)
	end
	local element = WZUISystem:getInstance():createElement("WndWorshipGod")
	assert(element, "WndWorshipGod create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndWorshipGod:showInterface()
	LoadNewActivityRes(true)
	local wndWater = WndWorshipGod:createElement()
	if wndWater then 
		WindowManager:addWindow(wndWater, WndWorshipGod, false)
	end
end

--@brief 	获取活动详情成功
function WndWorshipGod:GetActivityInfoOK(activityId,maxCount,count,status, rewardCounts, rewardItems, rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	-- body
	WZLog("WndWorshipGod:GetActivityInfoOK", g_cityExtenInfo.activity7062, Serialize(finishCondition), content)
	if g_cityExtenInfo.activity7062 == activityId then 
		self.m_tContent = json.decode(content)
		self.m_nStartTime = startTime 
		self.m_nEndTime = endTime 
		self.m_nActivityId = activityId
		self.m_nCount = count
		self.m_tRedPackConfig = self.m_tContent.redPacketConfig
		self.m_nChooseReward = GetOperateTimes("WORSHIPGODACTIVITYID", self.m_nActivityId) 

		self:_analyzeBigReward()
		self:_update()
	end
end

--@brief 	获取其他活动数据
function WndWorshipGod:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end 

	if doType == 2 then --大奖限量
		local tResult = json.decode(jsonData)
		local nSex = CacheCenter:getPlayerInfo().sex
		local sBigReward = tResult.rewards
		local array = SplitStringWithSeparator(sBigReward, "&")
		local tItem = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.WORSHIPGOD_TEXT1[9], strAtt = LocalStrings.GONGANDDRUM_TEXT1[16], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31}
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
		otherData.changeRes = 1
		otherData.activityId = self.m_nActivityId
		otherData.chooseInfo = {strKey=LocalStrings.WORSHIPGOD_TEXT1[9], doType=12}
		WndJoinReward:showInterface("", self.m_tBigRewardList[1], self.m_tBigRewardList[2], LocalStrings.WORSHIPGOD_TEXT1[3], true, 2, otherData, 2)
	elseif doType == 3 then --开启结果
		local tResult = json.decode(jsonData)
		WZLog("WndWorshipGod:_onGetOtherData 333", Serialize(tResult))
		self.m_tOpenResult = {}

		self.m_tOpenResult.normalRewards = {} --常规奖
		self.m_tOpenResult.firstRewards = {} --初级奖
		self.m_tOpenResult.bigRewards = {} --大奖奖
		self.m_tOpenResult.runRewards = {}

		local rewardType = 8 
		for i = 1, #tResult.itemNums do
			local tItem = {}
			tItem.itemId = tResult.itemIds[i]
			tItem.itemNum = tResult.itemNums[i]
			tItem.type = rewardType
			tItem.imgRewardTitle = "ui/newActivity/bt_text_gxhd_2.png"
			tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
			tItem.randomBtnVisible = false 
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
				tItem.imgRewardTitle = "ui/activityWords/text_bcs_xj.png"
				tItem.imgBK = "ui/specialBg/hd_pic_bcs_dj_02.png"
			--	tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
				tItem.imgBKPt = GlobalMethod:ccp(0.45, 0.55)
				tItem.goodsconPt = GlobalMethod:ccp(0.5, 0.5)
				tItem.randomBtnVisible = false 
			--	tItem.strTitle = string.format(strTitleFormat, LocalStrings.BEINGIMMORTAL_TEXT1[9], LocalStrings.BEINGIMMORTAL_TEXT1[10])
				tItem.spineEffect = {path = "activity/ui_caishen_xj", _sIndex = "ui_caishen_xj", play = "wait1"}

				table.insert(self.m_tOpenResult.firstRewards, tItem)
			end
		end
		--特奖
		for j = 1, #tResult.sItemIds do
			local tItem = {}

			tItem.itemId = tResult.sItemIds[j]
			tItem.itemNum = tResult.sItemNums[j]
			tItem.type = bigRewardType
			tItem.imgRewardTitle = "ui/activityWords/text_bcs_dj.png"
			tItem.imgBK = "ui/newActivity/hd_pic_bcs_dj_01.png"
			tItem.goodsconPt = GlobalMethod:ccp(0.5, 0.5)
			tItem.imgBKPt = GlobalMethod:ccp(0.49,0.6)
			tItem.randomBtnVisible = false 
		--	tItem.strTitle = string.format(strTitleFormat, LocalStrings.BEINGIMMORTAL_TEXT1[9], LocalStrings.CRAZY_GASHAPON_TEXT3[6])
			tItem.spineEffect = {path = "activity/ui_caishen_dj", _sIndex = "ui_caishen_dj", play = "wait1"}

			table.insert(self.m_tOpenResult.bigRewards, tItem)
		end

		--元宝奖励
		if tResult.extItemNums and tResult.extItemNums > 0 then
			local tItem = {}

			tItem.itemId = self.m_nCoinId2
			tItem.itemNum = tResult.extItemNums
			tItem.type = rewardType
			tItem.imgRewardTitle = "ui/newActivity/text_hd_tqq_di.png"
			tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
			tItem.randomBtnVisible = false 
			local basicData = GDatatab_item["id_" .. self.m_nCoinId2]
			tItem.strTitle = string.format(strTitleFormat, basicData.name, LocalStrings.ATH_REWARD_CHECK)

			table.insert(self.m_tOpenResult.runRewards, tItem)
		end
		
		if result == 1 then 
			self.m_nCount = tResult.count
			
			self:showOpenAction()
			self:_setFreeBtnText()
		else
			self:setOpenState(false)
		end
	elseif doType == 4 then --自选奖励
		local tResult = json.decode(jsonData)
		if result == 1 then 
			WndBringTreasure:setRewardPoolData(tResult)
		end
	elseif doType == 5 then --自选奖池领取
		local tResult = json.decode(jsonData)
		WZLog("WndWorshipGod:_onGetOtherData 55", Serialize(tResult))
		if result == 0 then 
			WndBringTreasure:getPoolRewardOK(tResult)
		end
	elseif doType == 6 or doType == 7 then --获取和刷新摇摇乐奖励
		local tResult = json.decode(jsonData)
		WZLog("WndWorshipGod:_onGetOtherData 6677", Serialize(tResult))
		if result == 1 then 
			WndBringTreasure:setShakeRewardData(tResult.itemIds, tResult.itemNums, tResult.dailyRefreshCount, tResult.zcjbConfig)
			local redPack = {}
			local strTitleFormat = [[<T C="255,255,255" S="46" P="1" SC="222,78,0" SS="4" SE="1">%s</T><T C="249,255,0" S="46" P="1" SC="222,78,0" SS="4" SE="1">%s</T>]]
			if tResult.itemRedPacketNum and tResult.itemRedPacketNum > 0 then 
				local tItem = {}

				tItem.itemId = self.m_nCoinId3
				tItem.itemNum = tResult.itemRedPacketNum
				tItem.type = 8
				tItem.imgRewardTitle = "ui/newActivity/text_hd_tqq_di.png"
				tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
				local basicData = GDatatab_item["id_" .. self.m_nCoinId3]
				tItem.strTitle = string.format(strTitleFormat, basicData.name, LocalStrings.ATH_REWARD_CHECK)

				table.insert(redPack, tItem)
			end
			if #redPack > 0 then 
				WndHoraryBigReward:showInterface(8, redPack)
			end
		end
	elseif doType == 8 then --招财进宝抽奖
		local tResult = json.decode(jsonData)
		WZLog("WndWorshipGod:_onGetOtherData 88", Serialize(tResult))
		local tOpenResult = {normalReward = {}, redPack = {}}
		if result == 1 then 
			local nIndex = 1
			local strTitleFormat = [[<T C="255,255,255" S="46" P="1" SC="222,78,0" SS="4" SE="1">%s</T><T C="249,255,0" S="46" P="1" SC="222,78,0" SS="4" SE="1">%s</T>]]
			for j = 1, #tResult.itemIds do
				if tResult.itemIds[j] ~= 160394 and tResult.itemIds[j] ~= 160398 then 
					local tItem = {}

					tItem.itemId = tResult.itemIds[j]
					tItem.itemNum = tResult.itemNums[j]
					tItem.playerItemId = tResult.playerItemIds[j]
					tItem.type = 8
					tItem.imgRewardTitle = "ui/newActivity/bt_text_gxhd_2.png"
					tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)

					table.insert(tOpenResult.normalReward, tItem)
				end
			end
			if tResult.itemRedPacketNum and tResult.itemRedPacketNum > 0 then 
				local tItem = {}

				tItem.itemId = self.m_nCoinId3
				tItem.itemNum = tResult.itemRedPacketNum
				tItem.type = 8
				tItem.imgRewardTitle = "ui/newActivity/text_hd_tqq_di.png"
				tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
				local basicData = GDatatab_item["id_" .. self.m_nCoinId3]
				tItem.strTitle = string.format(strTitleFormat, basicData.name, LocalStrings.ATH_REWARD_CHECK)

				table.insert(tOpenResult.redPack, tItem)
			end

			local tOtherRewards = {}
			if tOpenResult.redPack and #tOpenResult.redPack > 0 then 
				table.insert(tOtherRewards, tOpenResult.redPack)
			end
			WndHoraryBigReward:showInterface(8, tOpenResult.normalReward, nil, tOtherRewards)
			WndBringTreasure:setOpenState(false)
		end
	elseif doType == 9 then --发红包
		local tResult = json.decode(jsonData)
		WZLog("WndWorshipGod:_onGetOtherData 99", Serialize(tResult))
		if result == 1 then 
			WndChallengeLevel:closeWin()
		end
	elseif doType == 12 then 
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
function WndWorshipGod:updatePlayerItemData()
	WZLog("WndWorshipGod:updatePlayerItemData")
	if self.m_root ~= nil then
		self:_updateLightNum()
		self:showRedDot()
		self:_showLeftRedPackNum()
	end
end

--@brief 	设置射箭的状态
function WndWorshipGod:setOpenState(state)
	-- body
	if self.m_root == nil then return end 

	self.m_bOpenState = state
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	关闭抽奖奖励展示界面回调
function WndWorshipGod:_afterCloseReward()
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
function WndWorshipGod:_analyzeBigReward()
	-- body
	local sBigReward = self.m_tContent.firstRewards
	local array = SplitStringWithSeparator(sBigReward, "&")
	local nSex = CacheCenter:getPlayerInfo().sex
	local tItem = {reward_ids1 = {}, reward_nums1 = {}, name = LocalStrings.WORSHIPGOD_TEXT1[8]}
	self.m_tBigRewardList = {}
	for i = 1, #array do
--		WZLog("WndWorshipGod:_analyzeBigReward", string.sub(array[i], 2, -2))
		local string = string.sub(array[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string,",")[3])

		table.insert(tItem.reward_ids1, id)
		table.insert(tItem.reward_nums1, num)
	end

	self.m_tBigRewardList[1] = tItem

	local specialReward = self.m_tContent.superRewards
	local array1 = SplitStringWithSeparator(specialReward, "&")
	local tItem1 = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.WORSHIPGOD_TEXT1[9] }
	for i = 1, #array1 do
--		WZLog("WndWorshipGod:_analyzeBigReward", string.sub(array1[i], 2, -2))
		local string = string.sub(array1[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string, ",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string, ",")[3])
		
		table.insert(tItem1.reward_ids2, id)
		table.insert(tItem1.reward_nums2, num)
	end

	self.m_tBigRewardList[2] = tItem1
end




-------------------------------------私有方法模块End----------------------------------------
