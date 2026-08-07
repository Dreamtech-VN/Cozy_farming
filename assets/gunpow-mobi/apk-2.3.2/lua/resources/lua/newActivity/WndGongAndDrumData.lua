--WndGongAndDrumData.lua
--@brief	WndGongAndDrum的数据模块
--@date		2023/08/02
--@author	XTX
--@note		锣鼓喧天活动主界面

WndGongAndDrum = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndGongAndDrum:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_tBigRewardList = nil 		--大奖和特奖奖励
	self.m_bOpenState = false 
	self.m_tOpenResult = nil 
	self.m_nCoinId = 160482
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
	self.m_tGetTimes = nil 
	self.m_tFiveKeyReward = nil --五音奖励配置
	self.m_tItemList = {160483, 160484, 160485, 160486, 160487} --宮、商、角、徽、羽  
	self.m_tCellFiveKey = nil 
	self.m_tRecFiveKeyReward = nil --本次抽奖，获得的五音奖励
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndGongAndDrum:_unInit()
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
	self.m_tGetTimes = nil 
	self.m_tFiveKeyReward = nil 
	self.m_tItemList = nil 
	self.m_tCellFiveKey = nil 
	self.m_tRecFiveKeyReward = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndGongAndDrum:createElement()
	if WndGongAndDrum.m_root ~= nil then
		WindowManager:removeWindow(WndGongAndDrum.m_root, WndGongAndDrum, true)
	end
	local element = WZUISystem:getInstance():createElement("WndGongAndDrum")
	assert(element, "WndGongAndDrum create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndGongAndDrum:showInterface()
	LoadNewActivityRes(true)
	local wndWater = WndGongAndDrum:createElement()
	if wndWater then 
		WindowManager:addWindow(wndWater, WndGongAndDrum, false)
	end
end

--@brief 	获取活动详情成功
function WndGongAndDrum:GetActivityInfoOK(activityId,maxCount,count,status, rewardCounts, rewardItems, rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	-- body
	WZLog("WndGongAndDrum:GetActivityInfoOK", activityId)
	if g_cityExtenInfo.activity7086 == activityId then 
		self.m_tContent = json.decode(content)
		self.m_nStartTime = startTime 
		self.m_nEndTime = endTime 
		self.m_nActivityId = activityId
		self.m_nCount = count
		WZLog("self.m_tContentself.m_tContent", Serialize(self.m_tContent))
		self.m_tCostByType = {finishCondition[1], finishCondition[2]}

		self.m_nChooseReward = self:getOperateTimes()
		self:_update()
	end
end

--@brief 	获取其他活动数据
function WndGongAndDrum:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end 

	if doType == 1 then --额外数据
		local tResult = json.decode(jsonData)
		WZLog("WndGongAndDrum:_onGetOtherData 111", Serialize(tResult))
		self.m_nGiftRewardNum = tResult.globalNum
		self:showBagGiftInfo()
	elseif doType == 2 then --获取达人奖、大奖限量数据
		local tResult = json.decode(jsonData)
		WZLog("WndGongAndDrum:_onGetOtherData 222", Serialize(tResult))
		if tResult.pool ~= 3 then 
			table.insert(self.m_tGetTimes, tResult.pool)
		end
		local nSex = CacheCenter:getPlayerInfo().sex
		local sBigReward = tResult.rewards
		local array = SplitStringWithSeparator(sBigReward, "&")
		if tResult.pool == 0 then 
			local tItem = {reward_ids = {}, reward_nums = {}, name = LocalStrings.GONGANDDRUM_TEXT1[12], listBgSize = {474,228}, listBgPos = {0.5,0.431}}
			for i = 1, #array do
				local string = string.sub(array[i], 2, -2) 
				local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
				local num = tonumber(SplitStringWithSeparator(string,",")[3])

				table.insert(tItem.reward_ids, id)
				table.insert(tItem.reward_nums, num)
			end

			self.m_tBigRewardList[3] = tItem
		elseif tResult.pool == 1 then 
			local tItem = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.GONGANDDRUM_TEXT1[13], strAtt = LocalStrings.GONGANDDRUM_TEXT1[16], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31, pool = tResult.pool}
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
		elseif tResult.pool == 2 or tResult.pool == 3 then 
			local tItem = {reward_ids1 = {}, reward_nums1 = {}, name = LocalStrings.GONGANDDRUM_TEXT1[14], strAtt = LocalStrings.GONGANDDRUM_TEXT1[16], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31, pool = tResult.pool}
			if tResult.pool == 3 then 
				tItem.name = LocalStrings.GONGANDDRUM_TEXT1[18]
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
			WndJoinReward:showInterface("", self.m_tBigRewardList[1], self.m_tBigRewardList[2], LocalStrings.WATERMELON_TEXT1[22], false, 3, otherData)
		end
	elseif doType == 3 then --开启结果
		local tResult = json.decode(jsonData)
		WZLog("WndGongAndDrum:_onGetOtherData 333", Serialize(tResult))
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
				tItem.strTitle = string.format(strTitleFormat, LocalStrings.GONGANDDRUM_TEXT1[12])
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
				tItem.strTitle = string.format(strTitleFormat, LocalStrings.GONGANDDRUM_TEXT1[13])
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
				tItem.itemNum = tResult.sItemNums[i]
				tItem.playerItemId = tResult.playerItemIds[itemIdIndex]
				tItem.type = bigRewardType
				tItem.imgRewardTitle = "ui/newActivity/bt_text_ty_tj.png"
				tItem.imgBK = "ui/specialBg/hd_pic_ty_tj.png"
				tItem.titlePt = {0.5,0.97}
				tItem.strTitle = string.format(strTitleFormat, LocalStrings.GONGANDDRUM_TEXT1[14])
				tItem.txtTitlePt = {0.5,0.95}
				tItem.spineEffect = {path = "activity/ui_bengchuang_mxj", _sIndex = "ui_bengchuang_mxj", play = "wait1"}

				table.insert(self.m_tOpenResult.bigRewards, tItem)
			
				itemIdIndex = itemIdIndex + 1
			end
		end

		--获得的五音奖励
		if tResult.giftItemIds then 
			for i = 1, #tResult.giftItemIds do
				local tItem = {tResult.giftItemIds[i], tResult.giftItemNums[i]}
				table.insert(self.m_tOpenResult.otherRewards, tItem)
			
				itemIdIndex = itemIdIndex + 1
			end
		end

		if result == 1 then 
			self.m_nCount = tResult.count

			self:showOpenAction()
			self:_setFreeBtnText()
		else
			self:setOpenState(false)
		end
	elseif doType == 4 then --选择奖励
		local tResult = json.decode(jsonData)
		WZLog("WndGongAndDrum:_onGetOtherData 444", Serialize(tResult))
		if result == 0 then 
			local tTempList = nil 
			local nTag = 0
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
				WndGongAndDrum:chooseReturn(nTag, tResult.id + 1, tResult.status)
			end
		elseif result == 1 then
			MsgBoxManager:showTipBox(LocalStrings.SUMMERSURF_TEXT1[24])
		end
	elseif doType == 5 then --全服礼包
		local tResult = json.decode(jsonData)
		WZLog("WndGongAndDrum:_onGetOtherData 555", Serialize(tResult))
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
	elseif doType == 6 then --五音奖励
		local tResult = json.decode(jsonData)
		WZLog("WndGongAndDrum:_onGetOtherData 666", Serialize(tResult))
		local itemIdIndex = 1
		self.m_tRecFiveKeyReward = {}
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
				tItem.imgBKPt = {0.5,0.5}
				tItem.strTitle = string.format(strTitleFormat, LocalStrings.GONGANDDRUM_TEXT1[18])
				tItem.txtTitlePt = {0.5,0.95}
				tItem.spineEffect = {path = "activity/ui_bengchuang_mxj", _sIndex = "ui_bengchuang_mxj", play = "wait1"}

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

--@brief	缓存推送更新物品时调用的函数
function WndGongAndDrum:updatePlayerItemData()
	WZLog("WndGongAndDrum:updatePlayerItemData")
	if self.m_root ~= nil then
		self:_updateLightNum()
	end
end

--@brief 	设置射箭的状态
function WndGongAndDrum:setOpenState(state)
	-- body
	if self.m_root == nil then return end 

	self.m_bOpenState = state
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	关闭抽奖奖励展示界面回调
function WndGongAndDrum:_afterCloseReward()
	if self.m_root == nil then return end 

	if self.m_tRecFiveKeyReward and #self.m_tRecFiveKeyReward > 0 then 
		for i = 1, #self.m_tRecFiveKeyReward do
			table.insert(self.m_tOpenResult.bigRewards, self.m_tRecFiveKeyReward[i])
		end
		self.m_tRecFiveKeyReward = nil 
	end
	if self.m_tOpenResult.normalRewards and #self.m_tOpenResult.normalRewards > 0 then 
		WndHoraryBigReward:showInterface(8, self.m_tOpenResult.normalRewards, self.m_tOpenResult.bigRewards)
	elseif #self.m_tOpenResult.bigRewards > 0 then 
		WndHoraryBigReward:showInterface(9, self.m_tOpenResult.bigRewards)
	end
end

--@brief    添加保存上次选择的葫芦
function WndGongAndDrum:savePoleType()
    local _KeyString = ""
    local curDate = os.date("*t", SystemTime:getServerTime())
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = "GONGANDDRUM" .. tostring(CacheCenter:getPlayerInfo().id)
    local curValue = self.m_nCalabashType
    data:setStringValue("CALABASH_MARK", _KeyString, curValue)
    data:flush()
end

--@brief    获取上次保存的的葫芦
function WndGongAndDrum:getPoleType()
    local _KeyString = ""
    local curDate = os.date("*t", SystemTime:getServerTime())
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = "GONGANDDRUM" .. tostring(CacheCenter:getPlayerInfo().id)
    local strValue =  data:getStringValue("CALABASH_MARK", _KeyString)
    if strValue ~= nil and strValue ~= "" then 
		self.m_nCalabashType = tonumber(strValue)
		if self.m_nCalabashType ~= 0 then 
			GetElement(self.m_root, "cbgTool_WndGongAndDrum", WZUICheckBoxGroup):setCheckIndex(self.m_nCalabashType)
		end
	end
end

--@brief    添加保存是否该活动的首次抽奖
function WndGongAndDrum:saveOperateTimes(bOther)
    local _KeyString = ""
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = "GONGANDDRUMACTIVITYID" .. tostring(CacheCenter:getPlayerInfo().id)
    if bOther then 
    	_KeyString = "GONGANDDRUMACTIVITYID_TWO" .. tostring(CacheCenter:getPlayerInfo().id)
    end
    local curValue = self.m_nActivityId
    data:setStringValue("CALABASH_MARK", _KeyString, curValue)
    data:flush()
end

--@brief    获取是否该活动的首次抽奖
--@return 	1:非首次抽奖；0首次抽奖
function WndGongAndDrum:getOperateTimes(bOther)
    local _KeyString = ""
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = "GONGANDDRUMACTIVITYID" .. tostring(CacheCenter:getPlayerInfo().id)
    if bOther then 
    	_KeyString = "GONGANDDRUMACTIVITYID_TWO" .. tostring(CacheCenter:getPlayerInfo().id)
    end
    local strValue =  data:getStringValue("CALABASH_MARK", _KeyString)
    if strValue ~= nil and strValue ~= "" and tonumber(strValue) == self.m_nActivityId then 
		return 1
	else
		return 0
	end
end




-------------------------------------私有方法模块End----------------------------------------
