--WndPlanetSearchData.lua
--@brief	WndPlanetSearch的数据模块
--@date		2023/05/23
--@author	XTX
--@note		行星探索活动主界面

WndPlanetSearch = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndPlanetSearch:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_tBigRewardList = nil 		--大奖和特奖奖励
	self.m_bOpenState = false 
	self.m_tOpenResult = nil 
	self.m_nCoinId = 160455
	self.m_nMaxLotteryCount = 20    --最大抽奖次数
	self.m_nCount = 0 
	self.m_tBallAniName = {{"wait1_1", "wait1_3", "wait1_3"}, {"wait2_1", "wait2_3", "wait2_3"}}
	self.m_nAniType = 1 			--抽奖动画索引
	self.m_nCalabashType = 0 			--当前选中的星球索引
	self.m_tCostByType = nil 
	self.m_nChooseReward = 0 		--选择奖励状态0：弹出预览界面；1：不弹
	self.m_nGiftRewardNum = 0 		--全民探索奖励数量
	self.m_nGiftRewardConfig = nil  --全民搜索产出配置
	self.m_bIsOpenReward = false 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndPlanetSearch:_unInit()
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
	self.m_nAniType = nil 			--抽奖动画索引
	self.m_nCalabashType = nil 			--当前选中的星球索引
	self.m_tCostByType = nil 
	self.m_nChooseReward = nil 		--选择奖励状态0：弹出预览界面；1：不弹
	self.m_nGiftRewardNum = nil 
	self.m_nGiftRewardConfig = nil 
	self.m_bIsOpenReward = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndPlanetSearch:createElement()
	if WndPlanetSearch.m_root ~= nil then
		WindowManager:removeWindow(WndPlanetSearch.m_root, WndPlanetSearch, true)
	end
	local element = WZUISystem:getInstance():createElement("WndPlanetSearch")
	assert(element, "WndPlanetSearch create element failed!")
	self:_init()
	return element
end


--@brief 	外部接口
function WndPlanetSearch:showInterface()
	LoadNewActivityRes(true)
	local wndWater = WndPlanetSearch:createElement()
	if wndWater then 
		WindowManager:addWindow(wndWater, WndPlanetSearch, false)
	end
end

--@brief 	获取活动详情成功
function WndPlanetSearch:GetActivityInfoOK(activityId,maxCount,count,status, rewardCounts, rewardItems, rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	-- body
	WZLog("WndPlanetSearch:GetActivityInfoOK", activityId)
	if g_cityExtenInfo.activity7077 == activityId then 
		self.m_tContent = json.decode(content)
		self.m_nStartTime = startTime 
		self.m_nEndTime = endTime 
		self.m_nActivityId = activityId
		self.m_nCount = count
		WZLog("self.m_tContentself.m_tContent", Serialize(self.m_tContent))
		self.m_tCostByType = {finishCondition[1], finishCondition[2]}
		self.m_nGiftRewardConfig = self.m_tContent.globalConfig[1]

		self.m_nChooseReward = self:getOperateTimes()
		self:_analyzeBigReward()
		self:_update()
	end
end

--@brief 	获取其他活动数据
function WndPlanetSearch:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end 

	if doType == 1 then --获取达人奖、大奖限量数据
		local tResult = json.decode(jsonData)
		WZLog("WndPlanetSearch:_onGetOtherData 111", Serialize(tResult))
		local tTempList = self.m_tBigRewardList[2]
		for i = 1, #tResult.superGlobalLimit do
			local tab = {}
			tab.id = i - 1
			tab.limitNum = self.m_tContent.superPlayerLimitConfig[i]
			tab.dailyLimit = self.m_tContent.superGlobalLimitConfig[i]
			tab.dailyBuyNum = tResult.superGlobalLimit[i]
			tab.soldNum = tResult.superPlayerLimit[i]
			if utilsValueInTable(i - 1, tResult.superOptionalList) then 
				tTempList.chooseState[i] = 1
			else
				tTempList.chooseState[i] = 0
			end
			
			tTempList.leftConfig[i] = tab
		end

		local tTempList1 = self.m_tBigRewardList[1]
		for i = 1, #tResult.normalGlobalLimit do
			local tab = {}
			tab.id = i - 1
			tab.limitNum = self.m_tContent.normalPlayerLimitConfig[i]
			tab.dailyLimit = self.m_tContent.normalGlobalLimitConfig[i]
			tab.dailyBuyNum = tResult.normalGlobalLimit[i]
			tab.soldNum = tResult.normalPlayerLimit[i]
			if utilsValueInTable(i - 1, tResult.normalOptionalList) then 
				tTempList1.chooseState[i] = 1
			else
				tTempList1.chooseState[i] = 0
			end
			
			tTempList1.leftConfig[i] = tab
		end

		self.m_nGiftRewardNum = tResult.globalNum
		self:showBagGiftInfo()
		if self.m_bIsOpenReward then 
			self.m_bIsOpenReward = false 
			local otherData = {}
			otherData.winType = 1
			otherData.activityId = self.m_nActivityId
			otherData.otherRewardData = self.m_tBigRewardList[3]
			otherData.changeRes = 2
			otherData.bIsUseOriginSize = true
			otherData.imgBg = "ui/specialBg/frame_tc_xxts_slale9.png"
			otherData.imgBgPt = GlobalMethod:ccp(0.5, 0.5)
			otherData.img9SecBg = "ui/common/frame_90.png"
			otherData.imgClose = "ui/common/common_top_btn_guanbi_zi.png"
			otherData.titleColor = GlobalMethod:ccc3(255,255,255)
			otherData.titleStrokeColor = GlobalMethod:ccc3(0,112,202)
			otherData.str_color = ccc3(143,178,232)
			otherData.str_normal = "ui/newActivity/common_btn_63.png"
			otherData.str_select = "ui/newActivity/common_btn_62.png"
			otherData.selNameColor = GlobalMethod:ccc3(255,255,255)
			otherData.selNameStrokeEnable = false
			WndJoinReward:showInterface("", self.m_tBigRewardList[1], self.m_tBigRewardList[2], LocalStrings.TREASURE_TEXT7, true, 3, otherData)
		end
	elseif doType == 3 then --开启结果
		local tResult = json.decode(jsonData)
		WZLog("WndPlanetSearch:_onGetOtherData 333", Serialize(tResult))
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
				tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
				tItem.playerItemId = tResult.playerItemIds[itemIdIndex]
				table.insert(self.m_tOpenResult.normalRewards, tItem)

				itemIdIndex = itemIdIndex + 1
			end
		end
		--大奖
		local bigRewardType = 26 
		if tResult.fItemIds then 
			for i = 1, #tResult.fItemIds do
				local tItem = {}

				tItem.itemId = tResult.fItemIds[i]
				tItem.itemNum = tResult.fItemNums[i]
				tItem.type = bigRewardType
				tItem.imgRewardTitle = "ui/activityWords/text_hd_xxts_xj.png"
				tItem.imgBK = "ui/specialBg/hd_pic_xxts_jl_xj.png"
				tItem.imgBKPt = {0.5, 0.5}
				tItem.goodsconPt = {0.5, 0.5}
				tItem.playerItemId = tResult.playerItemIds[itemIdIndex]
				tItem.spineEffect = {path = "activity/ui_xxts_xj", _sIndex = "ui_xxts_xj", play = "wait1"}

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
				tItem.imgRewardTitle = "ui/activityWords/text_hd_xxts_dj.png"
				tItem.imgBK = "ui/specialBg/hd_pic_xxts_jl_dj.png"
				tItem.goodsconPt = {0.5, 0.5}
				tItem.imgBKPt = {0.51,0.5}
				tItem.spineEffect = {path = "activity/ui_xxts_dj", _sIndex = "ui_xxts_dj", play = "wait1"}

				table.insert(self.m_tOpenResult.bigRewards, tItem)
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
				tItem.imgRewardTitle = "ui/activityWords/text_hd_xxts_mb.png"
				tItem.imgBK = "ui/specialBg/hd_pic_xxts_jl_mb.png"
				tItem.goodsconPt = {0.5, 0.5}
				tItem.imgBKPt = {0.5,0.48}
				tItem.spineEffect = {path = "activity/ui_xxts_mbj", _sIndex = "ui_xxts_mbj", play = "wait1"}

				table.insert(self.m_tOpenResult.bigRewards, tItem)
				itemIdIndex = itemIdIndex + 1
			end
		end

		if result == 1 then 
			self.m_nCount = tResult.count
			self.m_tOpenResult.addExp = tResult.exp

			self:showOpenAction()
			self:_setFreeBtnText()
		else
			self:setOpenState(false)
		end
	elseif doType == 4 then --选择奖励
		local tResult = json.decode(jsonData)
		WZLog("WndPlanetSearch:_onGetOtherData 444", Serialize(tResult))
		if result == 0 then 
			local tTempList = nil 
			if tResult.pool == 0 then 
				tTempList = self.m_tBigRewardList[2]
			elseif tResult.pool == 1 then 
				tTempList = self.m_tBigRewardList[1]
			end
			tTempList.chooseState[tResult.id + 1] = tResult.status
			if tResult.status == 1 then 
				WndJoinReward:chooseReturn(tResult.pool + 2, tResult.id + 1, tResult.status)
			end
		elseif result == 1 then
			MsgBoxManager:showTipBox(LocalStrings.SUMMERSURF_TEXT1[24])
		end
	elseif doType == 5 then --领取全服奖励
		local tResult = json.decode(jsonData)
		WZLog("WndPlanetSearch:_onGetOtherData 555", Serialize(tResult))
		if result == 1 then 
			local tReward = {}
			for i = 1, #tResult.itemIds do
				local tItem = {}
				tItem.itemId = tResult.itemIds[i]
				tItem.itemNum = tResult.itemNums[i]
				tItem.type = 8
				tItem.imgRewardTitle = "ui/newActivity/bt_text_gxhd_2.png"
				tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
				tItem.playerItemId = tResult.playerItemIds[i]
				table.insert(tReward, tItem)
			end

			WndHoraryBigReward:showInterface(8, tReward)
			self.m_nGiftRewardNum = 0
			self:showBagGiftInfo()
		end
	end
end

--@brief	缓存推送更新物品时调用的函数
function WndPlanetSearch:updatePlayerItemData()
	WZLog("WndPlanetSearch:updatePlayerItemData")
	if self.m_root ~= nil then
		self:_updateLightNum()
	end
end

--@brief 	设置射箭的状态
function WndPlanetSearch:setOpenState(state)
	-- body
	if self.m_root == nil then return end 

	self.m_bOpenState = state
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	关闭抽奖奖励展示界面回调
function WndPlanetSearch:_afterCloseReward()
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
function WndPlanetSearch:_analyzeBigReward()
	-- body
	local sBigReward = self.m_tContent.firstRewards
	local array = SplitStringWithSeparator(sBigReward, "&")
	local nSex = CacheCenter:getPlayerInfo().sex
	local tItem = {reward_ids = {}, reward_nums = {}, name = LocalStrings.PLANETSEARCH_TEXT1[7], listBgSize = {474,228}, listBgPos = {0.5,0.431}}
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
	local tItem1 = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.PLANETSEARCH_TEXT1[8], strAtt = LocalStrings.PLANETSEARCH_TEXT1[4], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461} , cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31, origin = 857077}
	for i = 1, #array1 do
		local string = string.sub(array1[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string,",")[3])

		table.insert(tItem1.reward_ids2, id)
		table.insert(tItem1.reward_nums2, num)
		table.insert(tItem1.chooseState, 0)
	end

	self.m_tBigRewardList[2] = tItem1

	local specialReward2 = self.m_tContent.normalRewards
	local array2 = SplitStringWithSeparator(specialReward2, "&")
	local tItem2 = {reward_ids1 = {}, reward_nums1 = {}, name = LocalStrings.PLANETSEARCH_TEXT1[9], strAtt = LocalStrings.PLANETSEARCH_TEXT1[4], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31}
	for i = 1, #array2 do
		local string = string.sub(array2[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string,",")[3])

		table.insert(tItem2.reward_ids1, id)
		table.insert(tItem2.reward_nums1, num)
		table.insert(tItem2.chooseState, 0)
	end

	self.m_tBigRewardList[1] = tItem2
	WZLog("WndPlanetSearch:_analyzeBigReward", Serialize(self.m_tBigRewardList))
end

--@brief    添加保存上次选择的葫芦
function WndPlanetSearch:savePoleType()
    local _KeyString = ""
    local curDate = os.date("*t", SystemTime:getServerTime())
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = "CALABASH" .. tostring(CacheCenter:getPlayerInfo().id)
    local strValue =  data:getStringValue("PLANETSEARCH_MARK", _KeyString)
    local curValue = self.m_nCalabashType
    data:setStringValue("PLANETSEARCH_MARK", _KeyString, curValue)
    data:flush()
end

--@brief    获取上次保存的的葫芦
function WndPlanetSearch:getPoleType()
    local _KeyString = ""
    local curDate = os.date("*t", SystemTime:getServerTime())
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = "CALABASH" .. tostring(CacheCenter:getPlayerInfo().id)
    local strValue =  data:getStringValue("PLANETSEARCH_MARK", _KeyString)
    if strValue ~= nil and strValue ~= "" then 
		self.m_nCalabashType = tonumber(strValue)
		if self.m_nCalabashType ~= 0 then 
			GetElement(self.m_root, "cbgTool_WndPlanetSearch", WZUICheckBoxGroup):setCheckIndex(self.m_nCalabashType)
		end
	end
end

--@brief    添加保存是否该活动的首次抽奖
function WndPlanetSearch:saveOperateTimes()
    local _KeyString = ""
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = "PLANETSEARCH" .. tostring(CacheCenter:getPlayerInfo().id)
    local strValue =  data:getStringValue("PLANETSEARCH_MARK", _KeyString)
    local curValue = self.m_nActivityId
    data:setStringValue("PLANETSEARCH_MARK", _KeyString, curValue)
    data:flush()
end

--@brief    获取是否该活动的首次抽奖
--@return 	1:非首次抽奖；0首次抽奖
function WndPlanetSearch:getOperateTimes()
    local _KeyString = ""
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = "PLANETSEARCH" .. tostring(CacheCenter:getPlayerInfo().id)
    local strValue =  data:getStringValue("PLANETSEARCH_MARK", _KeyString)
    if strValue ~= nil and strValue ~= "" and tonumber(strValue) == self.m_nActivityId then 
		return 1
	else
		return 0
	end
end


-------------------------------------私有方法模块End----------------------------------------
