--WndGopherBallData.lua
--@brief	WndGopherBall的数据模块
--@date		2022/10/31
--@author	XTX
--@note		全垒打活动

WndGopherBall = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndGopherBall:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_tBigRewardList = nil 		--大奖和特奖奖励
	self.m_bOpenState = false 
	self.m_tOpenResult = nil 
	self.m_nCoinId = 160349
	self.m_nCount = 0  					--当天累计抽奖次数
	self.m_nMaxLotteryCount = 10    	--最大抽奖次数
	self.m_nGiftRewardNum = 0 	--全服礼包数量
	self.m_nTalkGapping = nil 
	self.m_nLastTalkIndex = 0
	self.m_tRedBallData = nil 
	self.m_nPosIndex = -1 
	self.m_tBallAniName = {"wait", "wait_1", "wait_2"}
	self.m_nAniType = 2  --标记抽奖播放的动作索引
	self.m_bIsOpenReward = false 
	self.m_nChooseReward = 0 		--选择奖励状态0：弹出预览界面；1：不弹
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndGopherBall:_unInit()
	self.m_root = nil
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_tBigRewardList = nil 		--大奖和特奖奖励
	self.m_bOpenState = false 
	self.m_tOpenResult = nil 
	self.m_nCoinId = nil
	self.m_nCount = nil  					--当天累计抽奖次数
	self.m_nMaxLotteryCount = nil    	--最大抽奖次数
	self.m_tBallAniName = nil
	self.m_nGiftRewardNum = nil 	--全服礼包数量
	self.m_nTalkGapping = nil 
	self.m_nLastTalkIndex = nil 
	self.m_tRedBallData = nil 
	self.m_nPosIndex = nil 
	self.m_nAniType = nil 
	self.m_bIsOpenReward = nil 
	self.m_nChooseReward = nil 		--选择奖励状态0：弹出预览界面；1：不弹
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndGopherBall:createElement()
	if WndGopherBall.m_root ~= nil then
		WindowManager:removeWindow(WndGopherBall.m_root, WndGopherBall, true)
	end
	local element = WZUISystem:getInstance():createElement("WndGopherBall")
	assert(element, "WndGopherBall create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndGopherBall:showInterface()
	LoadNewActivityRes(true)
	local wndWater = WndGopherBall:createElement()
	if wndWater then 
		WindowManager:addWindow(wndWater, WndGopherBall, false)
	end
end

--@brief 	获取活动详情成功
function WndGopherBall:GetActivityInfoOK(activityId,maxCount,count,status, rewardCounts, rewardItems, rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	-- body
	WZLog("WndGopherBall:GetActivityInfoOK", g_cityExtenInfo.activity7059, activityId, content)
	if g_cityExtenInfo.activity7059 == activityId then 
		self.m_tContent = json.decode(content)
		WZLog("WndGopherBall:GetActivityInfoOK", Serialize(self.m_tContent), Serialize(finishCondition))
		self.m_nStartTime = startTime 
		self.m_nEndTime = endTime 
		self.m_nActivityId = activityId
		self.m_nCount = count
		self.m_nGiftRewardNum = maxCount
		self.m_tRedBallData = finishCondition
		self.m_nChooseReward = GetOperateTimes("GOPHERBALLACTIVITYID", self.m_nActivityId)

		self:_analyzeBigReward()
		self:_update()
	end
end

--@brief 	获取其他活动数据
function WndGopherBall:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end 

	WZLog("WndGopHerball:_onGetOtherData activityId", activityId, doType, result)
	if doType == 2 then --特大奖奖池限量信息
		--[[
			{
				rewards	: '大奖奖池物品 [男物品id,女物品id,数量]&[...',
				globalLimitConfig	: '大奖全局日限量配置 [限量数量,限量数量]',
				playerLimitConfig	: '大奖个人日限量配置 [限量数量,限量数量]',
				globalLimit	: int[]大奖全局日限量,
				playerLimit	: int[]大奖个人日限量,
				optionalList	: int[]大奖奖选中下标
			}
		]]
		local tResult = json.decode(jsonData)
		WZLog("WndGopHerball:_onGetOtherData 222", Serialize(tResult))

		local nSex = CacheCenter:getPlayerInfo().sex
		local sBigReward = tResult.rewards
		local array = SplitStringWithSeparator(sBigReward, "&")

		local tItem = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.GOPHERBALL_TEXT1[9] .. LocalStrings.GOPHERBALL_TEXT1[10]}
		tItem = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.GOPHERBALL_TEXT1[9] .. LocalStrings.GOPHERBALL_TEXT1[10], strAtt = LocalStrings.DETECTIVE_TEXT1[16], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31}
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

		if self.m_bIsOpenReward then 
			self.m_bIsOpenReward = false 
			local otherData = {}
			otherData.winType = 1
			otherData.activityId = self.m_nActivityId
			-- otherData.otherRewardData = self.m_tBigRewardList[3]
			WndJoinReward:showInterface("", self.m_tBigRewardList[1], self.m_tBigRewardList[2], LocalStrings.TREASURE_TEXT7, nil, 2, otherData, 2)
		end
	
	elseif doType == 3 then --开启结果
		local tResult = json.decode(jsonData)
		WZLog("WndGopherBall:_onGetOtherData 333", Serialize(tResult))
		self.m_tOpenResult = {}

		self.m_tOpenResult.normalRewards = {} --常规奖
		self.m_tOpenResult.firstRewards = {} --大奖
		self.m_tOpenResult.bigRewards = {} --特奖
		self.m_tOpenResult.runRewards = {} --跑垒奖

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
		local strTitleFormat = [[<T C="255,255,255" S="52" P="1" SC="222,78,0" SS="4" SE="0">%s</T><T C="249,255,0" S="52" P="1" SC="222,78,0" SS="4" SE="0">%s</T>]]
		if tResult.fItemIds then 
			for j = 1, #tResult.fItemIds do
				local tItem = {}

				tItem.itemId = tResult.fItemIds[j]
				tItem.itemNum = tResult.fItemNums[j]
				tItem.type = rewardType
				tItem.imgRewardTitle = "ui/newActivity/text_hd_tqq_di.png"
				tItem.imgBK = "ui/newActivity/hd_pic_bzch_dj.png"
				tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
				tItem.goodsconPt = GlobalMethod:ccp(0.5, 0.5)
				tItem.strTitle = string.format(strTitleFormat, LocalStrings.GOPHERBALL_TEXT1[9], LocalStrings.CRAZY_GASHAPON_TEXT3[6])
				tItem.spineEffect = {path = "activity/ui_quanleida_ptj", _sIndex = "ui_quanleida_ptj", play = "wait1"}

				table.insert(self.m_tOpenResult.firstRewards, tItem)
			end
		end
		--特奖
		for j = 1, #tResult.sItemIds do
			local tItem = {}

			tItem.itemId = tResult.sItemIds[j]
			tItem.itemNum = tResult.sItemNums[j]
			tItem.type = rewardType
			tItem.imgRewardTitle = "ui/newActivity/text_hd_tqq_di.png"
			tItem.imgBK = "ui/newActivity/hd_pic_qld_bqtj.png"
			tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
			tItem.goodsconPt = GlobalMethod:ccp(0.5, 0.48)
			tItem.strTitle = string.format(strTitleFormat, LocalStrings.GOPHERBALL_TEXT1[9], LocalStrings.GOPHERBALL_TEXT1[10])
			tItem.spineEffect = {path = "activity/ui_dishu_dj", _sIndex = "ui_dishu_dj", play = "wait1"}

			table.insert(self.m_tOpenResult.bigRewards, tItem)
		end
		--跑垒奖励
		for j = 1, #tResult.fortItemIds do
			local tItem = {}

			tItem.itemId = tResult.fortItemIds[j]
			tItem.itemNum = tResult.fortItemNums[j]
			tItem.type = rewardType
			tItem.imgRewardTitle = "ui/newActivity/text_hd_tqq_di.png"
			tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
			tItem.strTitle = string.format(strTitleFormat, LocalStrings.GOPHERBALL_TEXT1[21], LocalStrings.ATH_REWARD_CHECK)

			table.insert(self.m_tOpenResult.runRewards, tItem)
		end
		for j = 1, #tResult.sfortItemIds do
			local tItem = {}

			tItem.itemId = tResult.sfortItemIds[j]
			tItem.itemNum = tResult.sfortItemNums[j]
			tItem.type = rewardType
			tItem.imgRewardTitle = "ui/newActivity/text_hd_tqq_di.png"
			tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
			tItem.strTitle = string.format(strTitleFormat, LocalStrings.GOPHERBALL_TEXT1[21], LocalStrings.ATH_REWARD_CHECK)

			table.insert(self.m_tOpenResult.runRewards, tItem)
		end

		if result == 1 then 
			self.m_nCount = tResult.count
			self.m_nGiftRewardNum = tResult.maxCount
			self.m_tRedBallData = tResult.finishCondition

			self:showOpenAction()
			self:_setFreeBtnText()
			self:showBagGiftInfo()
			self:_showRedBall()
		else
			self:setOpenState(false)
		end
	elseif doType == 4 then --领取全民运动奖励
		local tResult = json.decode(jsonData)
		WZLog("WndGopherBall:_onGetOtherData 333", Serialize(tResult))
		self.m_tOpenResult = {}

		self.m_tOpenResult.normalRewards = {} --常规奖

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

		self.m_nGiftRewardNum = 0

		self:showBagGiftInfo()
		self:_afterCloseReward()
		self:setOpenState(false)
	elseif doType == 7 then --选择奖励
		--[[
			{
				status	: int勾选的状态：0-取消，1-勾选,
				id	: int 自选大奖 下标从0开始
			}
		]]
		local tResult = json.decode(jsonData)
		WZLog("WndGopherBall:_onGetOtherData 777", Serialize(tResult))
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
function WndGopherBall:updatePlayerItemData()
	WZLog("WndGopherBall:updatePlayerItemData")
	if self.m_root ~= nil then
		self:_updateLightNum()
		self:showRedDot()
	end
end

--@brief 	设置射箭的状态
function WndGopherBall:setOpenState(state)
	-- body
	if self.m_root == nil then return end 

	self.m_bOpenState = state
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	关闭抽奖奖励展示界面回调
function WndGopherBall:_afterCloseReward()
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
function WndGopherBall:_analyzeBigReward()
	-- body
	local sBigReward = self.m_tContent.firstRewards
	local array = SplitStringWithSeparator(sBigReward, "&")
	local nSex = CacheCenter:getPlayerInfo().sex
	local tItem = {reward_ids1 = {}, reward_nums1 = {}, name = LocalStrings.GOPHERBALL_TEXT1[9] .. LocalStrings.CRAZY_GASHAPON_TEXT3[6]}
	self.m_tBigRewardList = {}
	for i = 1, #array do
--		WZLog("WndGopherBall:_analyzeBigReward", string.sub(array[i], 2, -2))
		local string = string.sub(array[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string,",")[3])

		table.insert(tItem.reward_ids1, id)
		table.insert(tItem.reward_nums1, num)
	end

	self.m_tBigRewardList[1] = tItem

	local specialReward = self.m_tContent.superRewards
	local array1 = SplitStringWithSeparator(specialReward, "&")
	local tItem1 = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.GOPHERBALL_TEXT1[9] .. LocalStrings.GOPHERBALL_TEXT1[10]}
	for i = 1, #array1 do
--		WZLog("WndGopherBall:_analyzeBigReward", string.sub(array1[i], 2, -2))
		local string = string.sub(array1[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string, ",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string, ",")[3])
		
		table.insert(tItem1.reward_ids2, id)
		table.insert(tItem1.reward_nums2, num)
	end

	self.m_tBigRewardList[2] = tItem1
end




-------------------------------------私有方法模块End----------------------------------------
