--WndCalabashData.lua
--@brief	WndCalabash的数据模块
--@date		2023/02/01
--@author	XTX
--@note		葫芦娃活动

WndCalabash = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCalabash:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_tBigRewardList = nil 		--大奖和特奖奖励
	self.m_bOpenState = false 
	self.m_tOpenResult = nil 
	self.m_nCoinId = 160406
	self.m_nCoinId2 = 160407
	self.m_nMaxLotteryCount = 20    --最大抽奖次数
	self.m_nCount = 0 
	self.m_tBallAniName = {"wait1"}
	self.m_nAniType = 1 			--抽奖动画索引
	self.m_nCalabashType = 0 			--当前选中的葫芦索引
	self.m_tExpConfig = nil 		--成熟度目标配置
	self.m_tCurExp = nil 		    --当前成熟度
	self.m_tCalabashIds = {160408, 160409, 160410, 160411, 160412, 160413, 160414}
	self.m_tLibraryTaskData = nil 
	self.m_nChooseReward = 0 		--选择奖励状态0：弹出预览界面；1：不弹
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCalabash:_unInit()
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
	self.m_nAniType = nil 
	self.m_nCalabashType = nil 			--当前选中的葫芦索引
	self.m_tExpConfig = nil 		--成熟度目标配置
	self.m_tCurExp = nil 		    --当前成熟度
	self.m_tCalabashIds = nil 
	self.m_tLibraryTaskData = nil 
	self.m_nChooseReward = nil 		--选择奖励状态0：弹出预览界面；1：不弹
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCalabash:createElement()
	if WndCalabash.m_root ~= nil then
		WindowManager:removeWindow(WndCalabash.m_root, WndCalabash, true)
	end
	local element = WZUISystem:getInstance():createElement("WndCalabash")
	assert(element, "WndCalabash create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndCalabash:showInterface()
	LoadNewActivityRes(true)
	local wndWater = WndCalabash:createElement()
	if wndWater then 
		WindowManager:addWindow(wndWater, WndCalabash, false)
	end
end

--@brief 	获取活动详情成功
function WndCalabash:GetActivityInfoOK(activityId,maxCount,count,status, rewardCounts, rewardItems, rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	-- body
	WZLog("WndCalabash:GetActivityInfoOK", g_cityExtenInfo.activity7063, Serialize(finishCondition), content)
	if g_cityExtenInfo.activity7063 == activityId then 
		self.m_tContent = json.decode(content)
		self.m_nStartTime = startTime 
		self.m_nEndTime = endTime 
		self.m_nActivityId = activityId
		self.m_nCount = count
		WZLog("self.m_tContentself.m_tContent", Serialize(self.m_tContent))
		local tempGourdsConfig = json.decode(self.m_tContent.gourdsConfig)
		local tempGourdsProgress = json.decode(self.m_tContent.gourdsProgress)
		self.m_tExpConfig = {}
		for i = 1, #tempGourdsConfig do
			for j = 1, #self.m_tCalabashIds do
				if self.m_tCalabashIds[j] == tempGourdsConfig[i][1] then 
					self.m_tExpConfig[j] = tempGourdsConfig[i][2]
					break 
				end
			end
		end

		self.m_tCurExp = {}
		for i = 1, #tempGourdsProgress do
			for j = 1, #self.m_tCalabashIds do
				if self.m_tCalabashIds[j] == tempGourdsProgress[i][1] then 
					self.m_tCurExp[j] = tempGourdsProgress[i][2]
					break 
				end
			end
		end
		self.m_nChooseReward = GetOperateTimes("CALABASHACTIVITYID", self.m_nActivityId) 

		self:_analyzeBigReward()
		self:_update()
	end
end

--@brief 	获取其他活动数据
function WndCalabash:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end 

	if doType == 2 then --大奖限量
		local tResult = json.decode(jsonData)
		local nSex = CacheCenter:getPlayerInfo().sex
		local sBigReward = tResult.rewards
		local array = SplitStringWithSeparator(sBigReward, "&")
		local tItem = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.CALABASH_TEXT1[9], strAtt = LocalStrings.GONGANDDRUM_TEXT1[16], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31}
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
		otherData.chooseInfo = {strKey=LocalStrings.CALABASH_TEXT1[9], doType=8}
		WndJoinReward:showInterface("", self.m_tBigRewardList[1], self.m_tBigRewardList[2], LocalStrings.TREASURE_TEXT7, nil, 2, otherData, 2)
	elseif doType == 3 then --开启结果
		local tResult = json.decode(jsonData)
		WZLog("WndCalabash:_onGetOtherData 333", Serialize(tResult))
		self.m_tOpenResult = {}

		self.m_tOpenResult.normalRewards = {} --常规奖
		self.m_tOpenResult.firstRewards = {} --小礼奖
		self.m_tOpenResult.bigRewards = {} --大礼奖
		self.m_tOpenResult.cardRewards = {} --爷爷卡奖励

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
		local strTitleFormat = [[<T C="255,255,255" S="46" P="1" SC="222,78,0" SS="4" SE="1">%s</T>]]
		--成熟葫芦奖励
		if tResult.gItems and #tResult.gItems > 0 then 
			for i = 1, #tResult.gItems do
				local bIsAdd = true 
				local tItem = {}
				for j = 1, #self.m_tCalabashIds do
					if tResult.gItems[i] == self.m_tCalabashIds[j] then 
						bIsAdd = false 
						tItem.itemId = tResult.gItems[i]
						tItem.itemNum = tResult.gItemNums[i]
						tItem.type = bigRewardType
						tItem.imgRewardTitle = "ui/newActivity/bt_text_hlw_hlxj.png"
						tItem.imgBK = "ui/newActivity/hd_pic_hlw_hlxj.png"
					--	tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
						tItem.imgBKPt = GlobalMethod:ccp(0.45, 0.5)
						tItem.goodsconPt = GlobalMethod:ccp(0.5, 0.5)
						tItem.strTitle = string.format(strTitleFormat, LocalStrings.CALABASH_TEXT1[17])

						table.insert(self.m_tOpenResult.firstRewards, tItem)
					end
				end
				if bIsAdd then 
					tItem.itemId = tResult.gItems[i]
					tItem.itemNum = tResult.gItemNums[i]
					tItem.type = rewardType
					tItem.imgRewardTitle = "ui/newActivity/bt_text_gxhd_2.png"
					tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
					table.insert(self.m_tOpenResult.normalRewards, tItem)
				end
			end
		end
		--大奖
		if tResult.fItemIds then 
			for j = 1, #tResult.fItemIds do
				local tItem = {}

				tItem.itemId = tResult.fItemIds[j]
				tItem.itemNum = tResult.fItemNums[j]
				tItem.type = bigRewardType
				tItem.imgRewardTitle = "ui/newActivity/bt_text_hlw_hlxj.png"
				tItem.imgBK = "ui/newActivity/hd_pic_hlw_hlxj.png"
			--	tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
				tItem.imgBKPt = GlobalMethod:ccp(0.45, 0.5)
				tItem.goodsconPt = GlobalMethod:ccp(0.5, 0.5)
				tItem.strTitle = string.format(strTitleFormat, LocalStrings.CALABASH_TEXT1[8])
				tItem.spineEffect = {path = "activity/ui_hl_ptj", _sIndex = "ui_hl_ptj", play = "wait1"}

				table.insert(self.m_tOpenResult.firstRewards, tItem)
			end
		end
		--特奖
		for j = 1, #tResult.sItemIds do
			local tItem = {}

			tItem.itemId = tResult.sItemIds[j]
			tItem.itemNum = tResult.sItemNums[j]
			tItem.type = bigRewardType
			tItem.imgRewardTitle = "ui/newActivity/bt_text_hlw_hldj.png"
			tItem.imgBK = "ui/specialBg/hd_pic_hlw_hldj.png"
			tItem.goodsconPt = GlobalMethod:ccp(0.5, 0.5)
			tItem.imgBKPt = GlobalMethod:ccp(0.49,0.5)
			tItem.strTitle = string.format(strTitleFormat, LocalStrings.CALABASH_TEXT1[9])
			tItem.spineEffect = {path = "activity/ui_hl_dj", _sIndex = "ui_hl_dj", play = "wait1"}

			table.insert(self.m_tOpenResult.bigRewards, tItem)
		end

		--爷爷卡片奖励
		if tResult.shopItemNums and tResult.shopItemNums > 0 then
			local tItem = {}

			tItem.itemId = self.m_nCoinId2
			tItem.itemNum = tResult.shopItemNums
			tItem.type = rewardType
			tItem.imgRewardTitle = "ui/newActivity/bt_text_gxhd_2.png"
			tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)

			table.insert(self.m_tOpenResult.cardRewards, tItem)
		end
		
		if result == 1 then 
			self.m_nCount = tResult.count
			if tResult.gourdsId and tResult.gourdsId > 0 then 
				for i = 1, #self.m_tCalabashIds do
					if self.m_tCalabashIds[i] == tResult.gourdsId then 
						self.m_tCurExp[i] = tResult.gourdsProgress
						break 
					end
				end
			end
			
			self:showOpenAction()
			self:_setFreeBtnText()
			self:_showProgress()
		else
			self:setOpenState(false)
		end
	elseif doType == 6 then --获取图鉴数据
		local tResult = json.decode(jsonData)
		WZLog("WndCalabash:_onGetOtherData 666", Serialize(tResult))
		if result == 1 then 
			self.m_tLibraryTaskData = {}

			local nIndex = 0
			local nIndex1 = 0 
			for i = 1, #tResult.ids do
				local tItem = {}

				tItem.id = tResult.ids[i]
				tItem.name = tResult.name[i]
				tItem.desc = tResult.tips[i]
				tItem.icon = tResult.icon[i]
				tItem.status = tResult.status[i]
				tItem.reward = {}
				tItem.activityId = activityId
				local nCount = tResult.split[i]
				for j = nIndex + 1, nCount + nIndex do
					local tItem1 = {}
					tItem1[1] = tResult.itemIds[j]
					tItem1[2] = tResult.nums[j]

					table.insert(tItem.reward, tItem1)
				end
				nIndex = nIndex + nCount

				tItem.cost = {}
				local nCount1 = tResult.split2[i]
				for j = nIndex1 + 1, nCount1 + nIndex1 do
					local tItem1 = {}
					tItem1[1] = tResult.costItemIds[j]
					tItem1[2] = tResult.costNums[j]

					table.insert(tItem.cost, tItem1)
				end
				nIndex1 = nIndex1 + nCount1

				table.insert(self.m_tLibraryTaskData, tItem)
			end

			self:_checkLibraryRedDot()
		end
	elseif doType == 7 then --领取图鉴奖励
		local tResult = json.decode(jsonData)
		WZLog("WndSecretTower:_onGetOtherData 777", Serialize(tResult))
		if result == 0 then 
			WndRewardShow:showById(tResult.itemIds, tResult.itemNums)
			--更新图鉴任务状态
			for j = 1, #tResult.ids do
				for i = 1, #self.m_tLibraryTaskData do
					if self.m_tLibraryTaskData[i].id == tResult.ids[j] then 
						self.m_tLibraryTaskData[i].status = tResult.status
						WndCalabashLibrary:updateLibraryStatus(tResult.ids[j], tResult.status)
						break 
					end
				end
			end
		end
	elseif doType == 8 then 
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
function WndCalabash:updatePlayerItemData()
	WZLog("WndCalabash:updatePlayerItemData")
	if self.m_root ~= nil then
		self:_updateLightNum()
		self:showRedDot()
		self:_checkLibraryRedDot()
	end
end

--@brief 	设置射箭的状态
function WndCalabash:setOpenState(state)
	-- body
	if self.m_root == nil then return end 

	self.m_bOpenState = state
end

--@brief 	获取图鉴数据
function WndCalabash:getLibraryData()
	return self.m_tLibraryTaskData
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	关闭抽奖奖励展示界面回调
function WndCalabash:_afterCloseReward()
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
	if self.m_tOpenResult.cardRewards and #self.m_tOpenResult.cardRewards > 0 then 
		table.insert(tOtherRewards, self.m_tOpenResult.cardRewards)
	end

	if self.m_tOpenResult.normalRewards and #self.m_tOpenResult.normalRewards > 0 then 
		WndHoraryBigReward:showInterface(8, self.m_tOpenResult.normalRewards, tBigReward, tOtherRewards)
	elseif #tBigReward > 0 then 
		WndHoraryBigReward:showInterface(9, tBigReward)
	end
end

--@brief 	解析大奖数据
function WndCalabash:_analyzeBigReward()
	-- body
	local sBigReward = self.m_tContent.firstRewards
	local array = SplitStringWithSeparator(sBigReward, "&")
	local nSex = CacheCenter:getPlayerInfo().sex
	local tItem = {reward_ids1 = {}, reward_nums1 = {}, name = LocalStrings.CALABASH_TEXT1[8]}
	self.m_tBigRewardList = {}
	for i = 1, #array do
--		WZLog("WndCalabash:_analyzeBigReward", string.sub(array[i], 2, -2))
		local string = string.sub(array[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string,",")[3])

		table.insert(tItem.reward_ids1, id)
		table.insert(tItem.reward_nums1, num)
	end

	self.m_tBigRewardList[1] = tItem

	local specialReward = self.m_tContent.superRewards
	local array1 = SplitStringWithSeparator(specialReward, "&")
	local tItem1 = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.CALABASH_TEXT1[9] }
	for i = 1, #array1 do
--		WZLog("WndCalabash:_analyzeBigReward", string.sub(array1[i], 2, -2))
		local string = string.sub(array1[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string, ",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string, ",")[3])
		
		table.insert(tItem1.reward_ids2, id)
		table.insert(tItem1.reward_nums2, num)
	end

	self.m_tBigRewardList[2] = tItem1
end

--@brief 	检测图鉴入口红点
function WndCalabash:_checkLibraryRedDot()
	if self.m_tLibraryTaskData == nil then return end 

	local bIsRedDot = false   
	for i = 1, #self.m_tLibraryTaskData do
		bIsRedDot = true  
		if self.m_tLibraryTaskData[i].status == 1 then 
			bIsRedDot = false
		else
			for j = 1, #self.m_tLibraryTaskData[i].cost do
				local nOwnNum = CacheCenter:getPlayerItemCountById(self.m_tLibraryTaskData[i].cost[j][1])
				if nOwnNum < self.m_tLibraryTaskData[i].cost[j][2] then 
					bIsRedDot = false  
					break 
				end
			end

			if bIsRedDot then 
				break 
			end
		end
	end

	local imgFinancialRedDot = GetElement(self.m_root, "imgLibraryRedDot_WndCalabash", WZUIImage)
	imgFinancialRedDot:setVisible(bIsRedDot)
end

--@brief    添加保存上次选择的葫芦
function WndCalabash:savePoleType()
    WZLog("WndCalabash:savePoleType")
    local _KeyString = ""
    local curDate = os.date("*t", SystemTime:getServerTime())
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = "CALABASH" .. tostring(CacheCenter:getPlayerInfo().id)
    local strValue =  data:getStringValue("CALABASH_MARK", _KeyString)
    local curValue = string.format("%02d%02d_%d", curDate.month, curDate.day, self.m_nCalabashType)
    if strValue == nil or strValue == "" or strValue ~= curValue then
        data:setStringValue("CALABASH_MARK", _KeyString, curValue)
        data:flush()
    end
end

--@brief    获取上次保存的的葫芦
function WndCalabash:getPoleType()
    WZLog("WndCalabash:getPoleType")
    local _KeyString = ""
    local curDate = os.date("*t", SystemTime:getServerTime())
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = "CALABASH" .. tostring(CacheCenter:getPlayerInfo().id)
    local strValue =  data:getStringValue("CALABASH_MARK", _KeyString)
    local curValue = string.format("%02d%02d", curDate.month, curDate.day)
    if strValue ~= nil and strValue ~= "" then
        local result = SplitStringWithSeparator(strValue, "_")
        if result[1] == curValue then 
        	self.m_nCalabashType = tonumber(result[2])
        	if self.m_nCalabashType ~= 0 then 
        		GetElement(self.m_root, "cbgTool_WndCalabash", WZUICheckBoxGroup):setCheckIndex(self.m_nCalabashType)
        	end
        end
    end
end
-------------------------------------私有方法模块End----------------------------------------
