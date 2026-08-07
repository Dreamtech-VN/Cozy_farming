--WndCeramicWorkshopData.lua
--@brief	WndCeramicWorkshop的数据模块
--@date		2023/11/29
--@author	yrd
--@note		陶艺工坊

WndCeramicWorkshop = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCeramicWorkshop:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nCoinId = 160549				--货币
	self.m_nDrawToolType = 0 			--抽奖工具类型 0,1
	self.m_nDrawNumType = 1 			--抽奖数量类型 1,2
	self.m_tDrawNumList = {1,20} 		--抽奖数量列表
	self.m_bOpenState = nil 			--抽奖按钮开放状态
	self.m_nCount = 0 					--免费次数
	self.m_bIsOpenReward = false 		--是否打开自选奖励界面
	self.m_nChooseReward = 0 			--选择奖励状态0：弹出预览界面；1：不弹
	self.m_tClipAniName1 = {{"wait1", "xz1", "xz1"}, {"wait2", "xz2", "xz2"}}	--机器特效播放动作名
	self.m_tClipAniName2 = {{"wait3", "xz3", "xz3"}, {"wait3", "xz3", "xz3"}}	--机器特效播放动作名

	self.m_nCurExp = 0
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCeramicWorkshop:_unInit()
	self.m_root = nil
	self.m_nCoinId = nil
	self.m_nDrawToolType = nil
	self.m_nDrawNumType = nil
	self.m_tDrawNumList = nil
	self.m_bOpenState = nil
	self.m_nCount = nil
	self.m_bIsOpenReward = nil
	self.m_nChooseReward = nil
	self.m_tClipAniName1 = nil
	self.m_tClipAniName2 = nil

	self.m_nCurExp = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCeramicWorkshop:createElement()
	if WndCeramicWorkshop.m_root ~= nil then
		WindowManager:removeWindow(WndCeramicWorkshop.m_root, WndCeramicWorkshop, true)
	end
	local element = WZUISystem:getInstance():createElement("WndCeramicWorkshop")
	assert(element, "WndCeramicWorkshop create element failed!")
	self:_init()
	return element
end

--@brief	缓存推送更新物品时调用的函数
function WndCeramicWorkshop:updatePlayerItemData()
	WZLog("WndCeramicWorkshop:updatePlayerItemData")
	if self.m_root ~= nil then
		self:_updateCoinNum()
		self:updateDrawgBtn()
	end
end


--@brief 	获取活动详情成功
function WndCeramicWorkshop:GetActivityInfoOK(activityId, maxCount, count, status, rewardCounts, rewardItems, rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	if g_cityExtenInfo.activity7101 == activityId then
		self.m_nActivityId = activityId
		-- self.m_nMaxCount = maxCount
		self.m_nCount = count
		-- self.m_nStatus = status
		-- self.m_nRewardCounts = rewardCounts
		-- self.m_nRewardItems = rewardItems
		-- self.m_nRewardItemsParamCount = rewardItemsParamCount
		self.m_nStartTime = startTime
		self.m_nEndTime = endTime
		self.m_tContent = json.decode(content)
		-- self.m_nRewardId = rewardId
		-- self.m_nFinishCondition = finishCondition
		-- self.m_nTips = tips

		self.m_tCostByType = {finishCondition[1], finishCondition[2]}

		self.m_nChooseReward = self:getOperateTimes()

		if self.m_tLvRewardList == nil then 
			self.m_tLvRewardList = {}
		end
		local tLvRewards = self.m_tContent.scoreRewards
		for i = 1, #self.m_tContent.scoreConfig do
			if self.m_tLvRewardList[i] == nil then 
				self.m_tLvRewardList[i] = {}
			end
			local tLevelReward = {}
			local array = SplitStringWithSeparator(tLvRewards[i], "&")
			for i = 1, #array do
				local tmpReward = SplitStringWithSeparator(string.sub(array[i], 2, -2),",")
				table.insert(tLevelReward, tmpReward)
			end
			self.m_tLvRewardList[i].lv = i
			self.m_tLvRewardList[i].name = LocalStrings.CERAMIC_WORKSHOP_TEXT2[i + 1]
			self.m_tLvRewardList[i].reward = tLevelReward
			self.m_tLvRewardList[i].exp = self.m_tContent.scoreConfig[i]
			self.m_tLvRewardList[i].activityId = activityId
		end
		self:_showLvAndExp()

		self:_initActivityTime()
	end
end

--@brief 	获取其他活动数据
function WndCeramicWorkshop:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end 

	if doType == 1 then --活动信息
		local tResult = json.decode(jsonData)
		WZLog("WndCeramicWorkshop:_onGetOtherData", doType, Serialize(tResult))

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

		self.m_nCurFireLeftProg = tResult.giftTimes --大于0为烧窑,否则为捏陶
		self.m_nCostTimes = tResult.costTimes --烧窑出现进度
		self:showMainUI()
		self:updateDrawgBtn()

		self:showRedDot()
	elseif doType == 2 then --获取达人奖、大奖限量数据
		local tResult = json.decode(jsonData)
		WZLog("WndCeramicWorkshop:_onGetOtherData", doType, Serialize(tResult))
		if tResult.pool ~= 3 then 
			table.insert(self.m_tGetTimes, tResult.pool)
		end
		local nSex = CacheCenter:getPlayerInfo().sex
		local sBigReward = tResult.rewards
		local array = SplitStringWithSeparator(sBigReward, "&")
		if tResult.pool == 0 then 
			local tItem = {reward_ids = {}, reward_nums = {}, name = LocalStrings.CERAMIC_WORKSHOP_TEXT1[8], listBgSize = {474,228}, listBgPos = {0.5,0.431}}
			for i = 1, #array do
				local string = string.sub(array[i], 2, -2) 
				local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
				local num = tonumber(SplitStringWithSeparator(string,",")[3])

				table.insert(tItem.reward_ids, id)
				table.insert(tItem.reward_nums, num)
			end

			self.m_tBigRewardList[3] = tItem
		elseif tResult.pool == 1 then 
			local tItem = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.CERAMIC_WORKSHOP_TEXT1[7], strAtt = LocalStrings.PLANETSEARCH_TEXT1[4], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31, pool = tResult.pool}
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

			self.m_tBigRewardList[2] = tItem
		elseif tResult.pool == 2 then
			local tItem = {reward_ids1 = {}, reward_nums1 = {}, name = LocalStrings.CERAMIC_WORKSHOP_TEXT1[6], strAtt = LocalStrings.PLANETSEARCH_TEXT1[4], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31, pool = tResult.pool}
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
			WndJoinReward:showInterface("", self.m_tBigRewardList[1], self.m_tBigRewardList[2], LocalStrings.WATERMELON_TEXT1[22], false, 3, otherData)
		end
	elseif doType == 3 then --开启结果
		local tResult = json.decode(jsonData)
		WZLog("WndCeramicWorkshop:_onGetOtherData", doType, Serialize(tResult))
		self.m_tOpenResult = {}

		self.m_tOpenResult.normalRewards = {} --常规奖
		self.m_tOpenResult.firstRewards = {} --小礼奖
		self.m_tOpenResult.bigRewards = {} --大礼奖
		self.m_tOpenResult.doyensRewards = {} --达人奖

		local rewardType = 8 
		local itemIdIndex = 1
		if tResult.itemIds then 
			for i = 1, #tResult.itemIds do
				local tItem = {}
				tItem.itemId = tResult.itemIds[i]
				tItem.itemNum = tResult.itemNums[i]
				tItem.type = rewardType
				tItem.imgRewardTitle = "ui/newActivity/bt_text_gxhd_2.png"
				tItem.img9BG = "ui/activity/common_jl_di_04.png"
				tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
				tItem.playerItemId = tResult.playerItemIds[itemIdIndex]

				table.insert(self.m_tOpenResult.normalRewards, tItem)
				itemIdIndex = itemIdIndex + 1
			end
		end
		--倍率奖励
		if tResult.mItemIds then 
			for i = 1, #tResult.mItemIds do
				local tItem = {}
				tItem.itemId = tResult.mItemIds[i]
				tItem.itemNum = tResult.mItemNums[i]
				tItem.type = rewardType
				tItem.imgRewardTitle = "ui/newActivity/bt_text_gxhd_2.png"
				tItem.img9BG = "ui/activity/common_jl_di_04.png"
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
				tItem.strTitle = string.format(strTitleFormat, LocalStrings.CERAMIC_WORKSHOP_TEXT1[8])
				tItem.txtTitlePt = {0.5,0.885}
				tItem.spineEffect = {path = "activity/ui_bengchuang_xj", _sIndex = "ui_bengchuang_xj", play = "wait1"}

				table.insert(self.m_tOpenResult.firstRewards, tItem)
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
				tItem.strTitle = string.format(strTitleFormat, LocalStrings.CERAMIC_WORKSHOP_TEXT1[7])
				tItem.txtTitlePt = {0.5,0.885}
				tItem.spineEffect = {path = "activity/ui_bengchuang_drj", _sIndex = "ui_bengchuang_drj", play = "wait1"}

				table.insert(self.m_tOpenResult.firstRewards, tItem)
				itemIdIndex = itemIdIndex + 1
			end
		end
		--达人奖
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
				tItem.imgBKPt = {0.491,0.499}
				tItem.strTitle = string.format(strTitleFormat, LocalStrings.CERAMIC_WORKSHOP_TEXT1[6])
				tItem.txtTitlePt = {0.5,0.95}
				tItem.spineEffect = {path = "activity/ui_bengchuang_mxj", _sIndex = "ui_bengchuang_mxj", play = "wait1"}

				table.insert(self.m_tOpenResult.firstRewards, tItem)
				itemIdIndex = itemIdIndex + 1
			end
		end

		if result == 1 then 
			self.m_nCount = tResult.count
			self.m_tOpenResult.addExp = tResult.scoreTimes

			self.m_nCurFireLeftProg = tResult.giftTimes --大于0为烧窑,否则为捏陶
			self:showMainUI()
			self:updateDrawgBtn()
			
			self:showOpenAction()
		else
			self:setOpenState(false)
		end
	elseif doType == 4 then --选择奖励
		local tResult = json.decode(jsonData)
		WZLog("WndCeramicWorkshop:_onGetOtherData", doType, Serialize(tResult))
		if result == 0 then 
			local tTempList = nil 
			local nTag = nil
			if tResult.pool == 1 then 
				tTempList = self.m_tBigRewardList[2]
				nTag = 2
			elseif tResult.pool == 2 then 
				tTempList = self.m_tBigRewardList[1]
				nTag = 3
			end
			tTempList.chooseState[tResult.id + 1] = tResult.status
			if tResult.status == 1 then 
				WndJoinReward:chooseReturn(nTag, tResult.id + 1, tResult.status)
			end
		elseif result == 1 then
			MsgBoxManager:showTipBox(LocalStrings.SUMMERSURF_TEXT1[24])
		end
	elseif doType == 5 then --领取等级奖励
		local tResult = json.decode(jsonData)
		WZLog("WndCeramicWorkshop:_onGetOtherData", doType, Serialize(tResult))
		if result == 0 then 
			self.m_tLvRewardList[tResult.id + 1].status = 2
			WndRewardShow:showById(tResult.itemIds, tResult.itemNums)

			self:showRedDot()
			self:_createLvRewardList()
		end
	end
end

--@brief 	设置射箭的状态
function WndCeramicWorkshop:setOpenState(state)
	if self.m_root == nil then return end 
	self.m_bOpenState = state
end

--@brief    添加保存上次选择的瓶子
function WndCeramicWorkshop:saveToolType()
    local _KeyString = ""
    local curDate = os.date("*t", SystemTime:getServerTime())
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = "TOOLTYPE" .. tostring(CacheCenter:getPlayerInfo().id)
    local strValue =  data:getStringValue("CERAMICWORKSHOP_MARK", _KeyString)
    local curValue = self.m_nDrawToolType
    data:setStringValue("CERAMICWORKSHOP_MARK", _KeyString, curValue)
    data:flush()
end

--@brief    获取上次保存的的瓶子
function WndCeramicWorkshop:getToolType()
    local _KeyString = ""
    local curDate = os.date("*t", SystemTime:getServerTime())
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = "TOOLTYPE" .. tostring(CacheCenter:getPlayerInfo().id)
    local strValue =  data:getStringValue("CERAMICWORKSHOP_MARK", _KeyString)
    if strValue ~= nil and strValue ~= "" then 
		self.m_nDrawToolType = tonumber(strValue)
		if self.m_nDrawToolType ~= 0 then 
			GetElement(self.m_root, "cbgTools", WZUICheckBoxGroup):setCheckIndex(self.m_nDrawToolType)
		end
	end
end

--@brief    添加保存是否该活动的首次抽奖
function WndCeramicWorkshop:saveOperateTimes()
    local _KeyString = ""
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = "OPERATETIMES" .. tostring(CacheCenter:getPlayerInfo().id)
    local strValue =  data:getStringValue("CERAMICWORKSHOP_MARK", _KeyString)
    local curValue = self.m_nActivityId
    data:setStringValue("CERAMICWORKSHOP_MARK", _KeyString, curValue)
    data:flush()
end

--@brief    获取是否该活动的首次抽奖
--@return 	1:非首次抽奖；0首次抽奖
function WndCeramicWorkshop:getOperateTimes()
    local _KeyString = ""
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = "OPERATETIMES" .. tostring(CacheCenter:getPlayerInfo().id)
    local strValue =  data:getStringValue("CERAMICWORKSHOP_MARK", _KeyString)
    if strValue ~= nil and strValue ~= "" and tonumber(strValue) == self.m_nActivityId then 
		return 1
	else
		return 0
	end
end


--@brief 	关闭抽奖奖励展示界面回调
function WndCeramicWorkshop:_afterCloseReward()
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

--@brief 	获取当前捕鼠等级
function WndCeramicWorkshop:getCurLvInfo()
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

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
