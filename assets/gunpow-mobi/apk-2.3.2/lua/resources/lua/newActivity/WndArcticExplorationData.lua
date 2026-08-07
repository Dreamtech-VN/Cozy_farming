--WndArcticExplorationData.lua
--@brief	WndArcticExploration的数据模块
--@date		2023/11/01
--@author	yrd
--@note		极地探险

WndArcticExploration = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndArcticExploration:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nCoinId = 160550				--货币
	self.m_nCoinId2 = 160554			--货币2
	self.m_nDrawToolType = 0 			--抽奖工具类型 0,1
	self.m_nDrawNumType = 1 			--抽奖数量类型 1,2
	self.m_tDrawNumList = {1,20} 		--抽奖数量列表
	self.m_bOpenState = nil 			--抽奖按钮开放状态
	self.m_nCount = 0 					--免费次数
	self.m_bIsOpenReward = false 		--是否打开自选奖励界面
	self.m_nChooseReward = 0 			--选择奖励状态0：弹出预览界面；1：不弹
	self.m_tClipAniName = {{"wait2_1", "wait2_2", "wait2_2"}, {"wait1_1", "wait1_2", "wait1_2"}}	--机器特效播放动作名

	self.m_nCurExp = 0
	self.m_tRecFiveKeyReward = nil --本次抽奖，获得的五音奖励
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndArcticExploration:_unInit()
	self.m_root = nil
	self.m_nCoinId = nil
	self.m_nCoinId2 = nil
	self.m_nDrawToolType = nil
	self.m_tDrawNumList = nil
	self.m_bOpenState = nil
	self.m_nCount = nil
	self.m_bIsOpenReward = nil
	self.m_nChooseReward = nil
	self.m_tClipAniName = nil

	self.m_nCurExp = nil
	self.m_tRecFiveKeyReward = nil --本次抽奖，获得的五音奖励
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndArcticExploration:createElement()
	if WndArcticExploration.m_root ~= nil then
		WindowManager:removeWindow(WndArcticExploration.m_root, WndArcticExploration, true)
	end
	local element = WZUISystem:getInstance():createElement("WndArcticExploration")
	assert(element, "WndArcticExploration create element failed!")
	self:_init()
	return element
end

--@brief	缓存推送更新物品时调用的函数
function WndArcticExploration:updatePlayerItemData()
	WZLog("WndArcticExploration:updatePlayerItemData")
	if self.m_root ~= nil then
		self:_updateCoinNum()
		self:updateDrawgBtn()
	end
end


--@brief 	获取活动详情成功
function WndArcticExploration:GetActivityInfoOK(activityId, maxCount, count, status, rewardCounts, rewardItems, rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	if g_cityExtenInfo.activity7103 == activityId then
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

		self:_initActivityTime()
		self:updateDrawgBtn()
	end
end

--@brief 	获取其他活动数据
function WndArcticExploration:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end 

	if doType == 1 then --活动信息
		local tResult = json.decode(jsonData)
		self.m_nGiftRewardNum = tResult.globalNum
		self:showBagGiftInfo()
		self.m_nGiftTimes = tResult.giftTimes
		self:showPageProgress()
		self:showRedDot()
	elseif doType == 2 then --获取达人奖、大奖限量数据
		local tResult = json.decode(jsonData)
		if tResult.pool ~= 3 then 
			table.insert(self.m_tGetTimes, tResult.pool)
		end
		local nSex = CacheCenter:getPlayerInfo().sex
		local sBigReward = tResult.rewards
		local array = SplitStringWithSeparator(sBigReward, "&")
		if tResult.pool == 0 then 
			local tItem = {reward_ids = {}, reward_nums = {}, name = LocalStrings.ARCTIC_EXPLORATION_TEXT1[9], listBgSize = {474,228}, listBgPos = {0.5,0.431}}
			for i = 1, #array do
				local string = string.sub(array[i], 2, -2) 
				local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
				local num = tonumber(SplitStringWithSeparator(string,",")[3])

				table.insert(tItem.reward_ids, id)
				table.insert(tItem.reward_nums, num)
			end

			self.m_tBigRewardList[3] = tItem
		elseif tResult.pool == 1 then 
			local tItem = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.ARCTIC_EXPLORATION_TEXT1[8], strAtt = LocalStrings.PLANETSEARCH_TEXT1[4], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31, pool = tResult.pool}
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
		elseif tResult.pool == 2 or tResult.pool == 3 then
			local tItem = {reward_ids1 = {}, reward_nums1 = {}, name = LocalStrings.ARCTIC_EXPLORATION_TEXT1[7], strAtt = LocalStrings.PLANETSEARCH_TEXT1[4], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31, pool = tResult.pool}
			if tResult.pool == 3 then 
				tItem.name = LocalStrings.ARCTIC_EXPLORATION_TEXT1[18]
			end
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
			if tResult.pool == 2 then
				self.m_tBigRewardList[1] = tItem
			elseif tResult.pool == 3 then 
				self.m_tFiveKeyReward = tItem
				self:_showFiveKeyReward()
			end
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
			WndJoinReward:showInterface("", self.m_tBigRewardList[1], self.m_tBigRewardList[2], LocalStrings.WATERMELON_TEXT1[22], true, 3, otherData)
		end
	elseif doType == 3 then --开启结果
		local tResult = json.decode(jsonData)
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
				tItem.strTitle = string.format(strTitleFormat, LocalStrings.ARCTIC_EXPLORATION_TEXT1[9])
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
				tItem.strTitle = string.format(strTitleFormat, LocalStrings.ARCTIC_EXPLORATION_TEXT1[8])
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
				tItem.strTitle = string.format(strTitleFormat, LocalStrings.ARCTIC_EXPLORATION_TEXT1[7])
				tItem.txtTitlePt = {0.5,0.95}
				tItem.spineEffect = {path = "activity/ui_bengchuang_mxj", _sIndex = "ui_bengchuang_mxj", play = "wait1"}

				table.insert(self.m_tOpenResult.firstRewards, tItem)
				itemIdIndex = itemIdIndex + 1
			end
		end

		if result == 1 then 
			self.m_nCount = tResult.count
			self.m_tOpenResult.addExp = tResult.giftNum

			self:showOpenAction()
			self:updateDrawgBtn()
		else
			self:setOpenState(false)
		end
	elseif doType == 4 then --选择奖励
		local tResult = json.decode(jsonData)
		if result == 0 then 
			local tTempList = nil 
			local nTag = nil
			if tResult.pool == 1 then 
				tTempList = self.m_tBigRewardList[2]
				nTag = 2
			elseif tResult.pool == 2 then 
				tTempList = self.m_tBigRewardList[1]
				nTag = 3
			elseif tResult.pool == 3 then 
				tTempList = self.m_tFiveKeyReward
			end
			tTempList.chooseState[tResult.id + 1] = tResult.status
			if tResult.status == 1 and tResult.pool ~= 3 then 
				WndJoinReward:chooseReturn(nTag, tResult.id + 1, tResult.status)
			elseif tResult.status == 1 and tResult.pool == 3 then 
				self:chooseReturn(nTag, tResult.id + 1, tResult.status)
			end
		elseif result == 1 then
			MsgBoxManager:showTipBox(LocalStrings.SUMMERSURF_TEXT1[24])
		end
	elseif doType == 5 then --全服礼包
		local tResult = json.decode(jsonData)
		if result == 1 then 
			local normalRewards = {}
			for i = 1, #tResult.itemIds do
				local tItem = {}
				tItem.itemId = tResult.itemIds[i]
				tItem.itemNum = tResult.itemNums[i]
				tItem.type = 8
				tItem.imgRewardTitle = "ui/newActivity/bt_text_gxhd_2.png"
				tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
				tItem.playerItemId = tResult.playerItemIds[i]
				table.insert(normalRewards, tItem)
			end

			WndHoraryBigReward:showInterface(8, normalRewards)
		end
	elseif doType == 6 then --残页奖励
		local tResult = json.decode(jsonData)
		self.m_tRecFiveKeyReward = {}
		local itemIdIndex = 1
		local strTitleFormat = [[<T C="255,255,255" S="46" P="1" SC="222,78,0" SS="4" SE="1">%s</T>]]
		if tResult.itemIds then 
			for i = 1, #tResult.itemIds do
				local tItem = {}
				tItem.itemId = tResult.itemIds[i]
				tItem.itemNum = tResult.itemNums[i]
				tItem.playerItemId = tResult.playerItemIds[itemIdIndex]
				tItem.type = 26
				tItem.imgRewardTitle = "ui/newActivity/bt_text_ty_tj.png"
				tItem.imgBK = "ui/specialBg/hd_pic_ty_tj.png"
				tItem.titlePt = {0.5,0.97}
				tItem.imgBKPt = {0.491,0.499}
				tItem.strTitle = string.format(strTitleFormat, LocalStrings.ARCTIC_EXPLORATION_TEXT1[18])
				tItem.txtTitlePt = {0.5,0.885}
				tItem.spineEffect = {path = "activity/ui_bengchuang_drj", _sIndex = "ui_bengchuang_drj", play = "wait1"}

				table.insert(self.m_tRecFiveKeyReward, tItem)
				itemIdIndex = itemIdIndex + 1
			end
		end

		--刷新五音大奖限购状态
		local tData = {pool = 3}
		local strJson = json.encode(tData)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson)
	end
end

--@brief 	设置射箭的状态
function WndArcticExploration:setOpenState(state)
	if self.m_root == nil then return end 
	self.m_bOpenState = state
end

--@brief    添加保存上次选择的瓶子
function WndArcticExploration:saveToolType()
    local _KeyString = ""
    local curDate = os.date("*t", SystemTime:getServerTime())
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = "TOOLTYPE" .. tostring(CacheCenter:getPlayerInfo().id)
    local strValue =  data:getStringValue("ArcticExploration_MARK", _KeyString)
    local curValue = self.m_nDrawToolType
    data:setStringValue("ARCTICEXPLORATION_MARK", _KeyString, curValue)
    data:flush()
end

--@brief    获取上次保存的的瓶子
function WndArcticExploration:getToolType()
    local _KeyString = ""
    local curDate = os.date("*t", SystemTime:getServerTime())
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = "TOOLTYPE" .. tostring(CacheCenter:getPlayerInfo().id)
    local strValue =  data:getStringValue("ARCTICEXPLORATION_MARK", _KeyString)
    if strValue ~= nil and strValue ~= "" then 
		self.m_nDrawToolType = tonumber(strValue)
		if self.m_nDrawToolType ~= 0 then 
			GetElement(self.m_root, "cbgTools", WZUICheckBoxGroup):setCheckIndex(self.m_nDrawToolType)
		end
	end
end

--@brief    添加保存是否该活动的首次抽奖
function WndArcticExploration:saveOperateTimes()
    local _KeyString = ""
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = "OPERATETIMES" .. tostring(CacheCenter:getPlayerInfo().id)
    local strValue =  data:getStringValue("ARCTICEXPLORATION_MARK", _KeyString)
    local curValue = self.m_nActivityId
    data:setStringValue("ARCTICEXPLORATION_MARK", _KeyString, curValue)
    data:flush()
end

--@brief    获取是否该活动的首次抽奖
--@return 	1:非首次抽奖；0首次抽奖
function WndArcticExploration:getOperateTimes()
    local _KeyString = ""
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = "OPERATETIMES" .. tostring(CacheCenter:getPlayerInfo().id)
    local strValue =  data:getStringValue("ARCTICEXPLORATION_MARK", _KeyString)
    if strValue ~= nil and strValue ~= "" and tonumber(strValue) == self.m_nActivityId then 
		return 1
	else
		return 0
	end
end


--@brief 	关闭抽奖奖励展示界面回调
function WndArcticExploration:_afterCloseReward()
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
	if self.m_tRecFiveKeyReward and #self.m_tRecFiveKeyReward > 0 then 
		for i = 1, #self.m_tRecFiveKeyReward do
			table.insert(tBigReward, self.m_tRecFiveKeyReward[i])
		end
		self.m_tRecFiveKeyReward = nil 
	end

	if self.m_tOpenResult.normalRewards and #self.m_tOpenResult.normalRewards > 0 then 
		WndHoraryBigReward:showInterface(8, self.m_tOpenResult.normalRewards, tBigReward)
	elseif #tBigReward > 0 then 
		WndHoraryBigReward:showInterface(9, tBigReward)
	end
end

--@brief 	获取当前捕鼠等级
function WndArcticExploration:getCurLvInfo()
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
