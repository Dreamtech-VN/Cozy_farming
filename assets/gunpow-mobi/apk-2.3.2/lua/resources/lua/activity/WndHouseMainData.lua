--WndHouseMainData.lua
--@brief	WndHouseMain的数据模块
--@date		2021/09/27
--@author	hyx
--@note		房产主界面

WndHouseMain = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndHouseMain:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tFirstRewards = nil
	self.m_tSuperRewards = nil
	self.m_sInvestTaskTimeSchedule = nil --投资任务定时器
	self.m_tInvesTime = 0 --剩余时间
	self.m_nInvestNumber = 0 --投资卡个数
	self.m_nInvestGiftCount = 0 --投资礼包的个数
	self.m_tInvestTaskRewardItem = {}
	self.m_nCurInvestTask = nil --当前下放的投资任务
	self.m_tBigRewardData = nil
	self.m_sInvestSpine = nil
	self.m_nCurInvestIndex = 1
	self.m_sIsInvestIng = nil --是否投资中
	self.m_nLastChatChannel = nil 
	self.m_nActivityId = nil 
	self.m_nChooseReward = 0 		--选择奖励状态0：弹出预览界面；1：不弹
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndHouseMain:_unInit()
	self.m_root = nil
	self.m_tFirstRewards = nil
	self.m_tSuperRewards = nil
	self.m_sInvestTaskTimeSchedule = nil
	self.m_tInvesTime = 0
	self.m_nInvestNumber = 0
	self.m_nInvestGiftCount = 0
	self.m_tInvestTaskRewardItem = {}
	self.m_nCurInvestTask = nil
	self.m_tBigRewardData = nil
	self.m_sInvestSpine = nil
	self.m_nCurInvestIndex = 1
	self.m_sIsInvestIng = nil
	self.m_nLastChatChannel = nil 
	self.m_nActivityId = nil 
	self.m_nChooseReward = nil 		--选择奖励状态0：弹出预览界面；1：不弹
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndHouseMain:createElement()
	if WndHouseMain.m_root ~= nil then
		WindowManager:removeWindow(WndHouseMain.m_root, WndHouseMain, true)
	end
	local element = WZUISystem:getInstance():createElement("WndHouseMain")
	assert(element, "WndHouseMain create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------
function WndHouseMain:_onGetHouseInvestInfo(activityId,maxCount,count,status, rewardCounts, rewardItems,rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	local txtActivityTime = GetElement(self.m_root,"txtActivityTime",WZUILabelTTF)
	local startTime = SystemTime:getTimeConverLocal(startTime)
	local endTime = SystemTime:getTimeConverLocal11(endTime)
	txtActivityTime:setText(startTime.."~"..endTime)
	content = json.decode(content)
	if content then
		self.m_tFirstRewards = content.firstRewards
		self.m_tSuperRewards = content.superRewards
	end
	self.m_nActivityId = activityId
	self.m_nChooseReward = GetOperateTimes("HOUSEMAINACTIVITYID", self.m_nActivityId) 
end

function WndHouseMain:_onGetHouseInvestResult(activityId, doType, result, msg)
	if activityId == tonumber(g_cityExtenInfo.activity7029) then
		msg = json.decode(msg)
		if msg then
			if doType == 9 then --主动推送的活动信息
				self.m_nInvestGiftCount = msg.tzRewardCount
				self:setInvestGiftCount()
				self:setInvestTaskState(msg.tzTaskStatus, msg.tzTaskId, msg.tzTaskRemainTime, msg.tzTaskProgress, msg.tzTaskTarget)
				self:setMyHouseMsgData(msg)
				self.m_nInvestNumber = msg.tzTaskNum
				self:setInvestNumber()
			elseif doType == 7 then --投资次数返回
				self.m_sIsInvestIng = nil
				self.m_tBigRewardData = msg
				WndRewardShow:showById(msg.itemIds, msg.itemNums)
				if next(msg.upItemIds) ~= nil or next(msg.fItemIds) ~= nil or next(msg.sItemIds) ~= nil then
					WndRewardShow:closeCallBack(self, self.showBigReward)
				end
			elseif doType == 8 then --领取投资礼包奖励
				WndRewardShow:showById(msg.itemIds, msg.itemNums)
				self.m_nInvestGiftCount = 0
				self:setInvestGiftCount()
			elseif doType == 6 then --大奖限量
				local tResult = msg
				local nSex = CacheCenter:getPlayerInfo().sex
				local sBigReward = tResult.rewards
				local array = SplitStringWithSeparator(sBigReward, "&")
				local tItem = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.ACTIVITY_TEXT195, strAtt = LocalStrings.GONGANDDRUM_TEXT1[16], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31}
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

				if self.m_tFirstRewards then
					local ids1, nums1 = WndMainHorary:getRewardData(self.m_tFirstRewards)
					
					--一等奖
					local tab_rewards1 = {}
					tab_rewards1.name = LocalStrings.ACTIVITY_TEXT194
					tab_rewards1.reward_ids1 = ids1
					tab_rewards1.reward_nums1 = nums1

					local otherData = {}
					otherData.winType = 1
					otherData.activityId = self.m_nActivityId
					otherData.chooseInfo = {strKey=LocalStrings.ACTIVITY_TEXT195, doType=12}
					WndJoinReward:showInterface("", tab_rewards1, tItem, LocalStrings.TREASURE_TEXT7, nil, 2, otherData, 2)
				end
			elseif doType == 12 then 
				local tResult = msg
				if result == 0 then 
					local tTempList = nil 
					if tResult.status == 1 then 
						WndJoinReward:chooseReturn(2, tResult.id + 1, tResult.status)
					end
				elseif result == 1 then
					MsgBoxManager:showTipBox(LocalStrings.SUMMERSURF_TEXT1[24])
				end
			end
		end
	end
end
-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
