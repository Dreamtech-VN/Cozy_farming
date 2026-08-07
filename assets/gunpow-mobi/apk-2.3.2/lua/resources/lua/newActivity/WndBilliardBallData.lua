--WndBilliardBallData.lua
--@brief	WndBilliardBall的数据模块
--@date		2022/08/16
--@author	XTX
--@note		台无止境活动

WndBilliardBall = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndBilliardBall:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_tBigRewardList = nil 		--大奖和特奖奖励
	self.m_bOpenState = false 
	self.m_tOpenResult = nil 
	self.m_nCoinId = 171419
	self.m_nCount = 0  					--当天累计抽奖次数
	self.m_nPoleType = 0 			--0：木杆；1：银杆；2：金杆
	self.m_tLvRewardList = nil 			--捕鼠奖励列表
	self.m_nCurExp = 0
	self.m_nCurLevel = 0 				--当前等级
	self.m_tGlovesCost = {1, 2, 3}  --不同杆消耗的手套数量
	self.m_nMaxLotteryCount = 15    --最大抽奖次数
	self.m_tBallAniName = {{"wait1", "wait4"},{"wait2", "wait5"},{"wait3", "wait6"}}
	self.m_bIsOpenReward = false 
	self.m_nChooseReward = 0 		--选择奖励状态0：弹出预览界面；1：不弹
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndBilliardBall:_unInit()
	self.m_root = nil
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_tBigRewardList = nil 		--大奖和特奖奖励
	self.m_bOpenState = nil 
	self.m_tOpenResult = nil 
	self.m_nCoinId = nil
	self.m_nCount = nil  					--当天累计抽奖次数
	self.m_nPoleType = nil 
	self.m_tLvRewardList = nil
	self.m_nCurExp = nil 
	self.m_nCurLevel = nil 
	self.m_tGlovesCost = nil 
	self.m_nMaxLotteryCount = nil 
	self.m_tBallAniName = nil 
	self.m_bIsOpenReward = nil
	self.m_nChooseReward = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndBilliardBall:createElement()
	if WndBilliardBall.m_root ~= nil then
		WindowManager:removeWindow(WndBilliardBall.m_root, WndBilliardBall, true)
	end
	local element = WZUISystem:getInstance():createElement("WndBilliardBall")
	assert(element, "WndBilliardBall create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndBilliardBall:showInterface()
	LoadNewActivityRes(true)
	local wndWater = WndBilliardBall:createElement()
	if wndWater then 
		WindowManager:addWindow(wndWater, WndBilliardBall, false)
	end
end

--@brief 	获取活动详情成功
function WndBilliardBall:GetActivityInfoOK(activityId,maxCount,count,status, rewardCounts, rewardItems, rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	-- body
	WZLog("WndBilliardBall:GetActivityInfoOK", g_cityExtenInfo.activity7055, activityId, content)
	if g_cityExtenInfo.activity7055 == activityId then 
		self.m_tContent = json.decode(content)
		WZLog("WndBilliardBall:GetActivityInfoOK", Serialize(self.m_tContent))
		self.m_nStartTime = startTime 
		self.m_nEndTime = endTime 
		self.m_nActivityId = activityId
		self.m_nCount = count
		self.m_tGlovesCost = finishCondition
		if self.m_tLvRewardList == nil then 
			self.m_tLvRewardList = {}
		end
		for i = 1, #self.m_tContent.lvExp do
			if self.m_tLvRewardList[i] == nil then 
				self.m_tLvRewardList[i] = {}
			end
			self.m_tLvRewardList[i].lv = i
			self.m_tLvRewardList[i].name = self.m_tContent.lvTitle[i + 1]
			self.m_tLvRewardList[i].reward = self.m_tContent.lvRewards[i]
			self.m_tLvRewardList[i].exp = self.m_tContent.lvExp[i]
		end
		self.m_nChooseReward = GetOperateTimes("BILLIARBALLACTIVITYID", self.m_nActivityId)

		self:_showLvAndExp()
		self:_analyzeBigReward()
		self:_update()
	end
end

--@brief 	获取其他活动数据
function WndBilliardBall:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end 
	WZLog("WndBilliardBall:_onGetOtherData activityId", activityId, doType, result)
	if doType == 1 then --等级奖励数据
		local tResult = json.decode(jsonData)
		WZLog("WndBilliardBall:_onGetOtherData 111", Serialize(tResult))
		self.m_nCurExp = tResult.exp
		self.m_nCurLevel = tResult.lv

		local bUpdateShow = true 
		if self.m_tLvRewardList == nil then 
			self.m_tLvRewardList = {}
			bUpdateShow = false
		end
		for i = 1, #tResult.states do
			if self.m_tLvRewardList[i] == nil then 
				self.m_tLvRewardList[i] = {}
			end
			self.m_tLvRewardList[i].status = tResult.states[i]
		end
		if bUpdateShow then 
			self:_showLvAndExp()
		end
		self:showRedDot()
	elseif doType == 2 then --特大奖奖池限量信息
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
		WZLog("WndBilliardBall:_onGetOtherData 222", Serialize(tResult))

		local nSex = CacheCenter:getPlayerInfo().sex
		local sBigReward = tResult.rewards
		local array = SplitStringWithSeparator(sBigReward, "&")

		local tItem = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.BILLIARDBALL_TEXT1[8]}
		tItem = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.BILLIARDBALL_TEXT1[8], strAtt = LocalStrings.DETECTIVE_TEXT1[16], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31}
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
			-- otherData.winType = 1
			otherData.activityId = self.m_nActivityId
			-- otherData.otherRewardData = self.m_tBigRewardList[3]
			WndJoinReward:showInterface("", self.m_tBigRewardList[1], self.m_tBigRewardList[2], LocalStrings.TREASURE_TEXT7, nil, 2, otherData, 2)
		end
	elseif doType == 3 then --开启结果
		local tResult = json.decode(jsonData)
		WZLog("WndBilliardBall:_onGetOtherData 333", Serialize(tResult))
		self.m_tOpenResult = {}

		self.m_tOpenResult.normalRewards = {} --常规奖
		self.m_tOpenResult.firstRewards = {} --一等奖
		self.m_tOpenResult.bigRewards = {} --特等奖

		local rewardType = 8 
		for i = 1, #tResult.itemNums do
			local tItem = {}
			tItem.itemId = tResult.itemIds[i]
			tItem.itemNum = tResult.itemNums[i]
			tItem.type = rewardType
			table.insert(self.m_tOpenResult.normalRewards, tItem)
		end

		--一等奖
		for j = 1, #tResult.fItemIds do
			local tItem = {}

			tItem.itemId = tResult.fItemIds[j]
			tItem.itemNum = tResult.fItemNums[j]
			tItem.type = 19

			table.insert(self.m_tOpenResult.firstRewards, tItem)
		end
		--特等奖
		for j = 1, #tResult.sItemIds do
			local tItem = {}

			tItem.itemId = tResult.sItemIds[j]
			tItem.itemNum = tResult.sItemNums[j]
			tItem.type = 20

			table.insert(self.m_tOpenResult.bigRewards, tItem)
		end

		if result == 1 then 
			self.m_nCount = tResult.count
			self.m_tOpenResult.medalNum = tResult.extItemNums   --奖杯数量

			self:showOpenAction()
			self:_setFreeBtnText()
		else
			self:setOpenState(false)
		end
	elseif doType == 6 then --领取等级奖励
		if result == 1 then 
			local tResult = json.decode(jsonData)
			WZLog("WndBilliardBall:_onGetOtherData 666", Serialize(tResult))

			self.m_tLvRewardList[tResult.lv].status = 2
			WndRewardShow:showById(tResult.itemIds, tResult.itemNums)

			self:showRedDot()
			self:_createLvRewardList()
		end
	elseif doType == 7 then --选择奖励
		--[[
			{
				status	: int勾选的状态：0-取消，1-勾选,
				id	: int 自选大奖 下标从0开始
			}
		]]
		local tResult = json.decode(jsonData)
		WZLog("WndBilliardBall:_onGetOtherData 777", Serialize(tResult))
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
function WndBilliardBall:updatePlayerItemData()
	WZLog("WndBilliardBall:updatePlayerItemData")
	if self.m_root ~= nil then
		self:_updateLightNum()
		self:showRedDot()
	end
end

--@brief 	设置射箭的状态
function WndBilliardBall:setOpenState(state)
	-- body
	if self.m_root == nil then return end 

	self.m_bOpenState = state
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	关闭抽奖奖励展示界面回调
function WndBilliardBall:_afterCloseReward()
	if self.m_root == nil then return end 

	local tBigReward = {}
	local nIndex = 1
	if #self.m_tOpenResult.firstRewards > 0 then 
		for i = 1, #self.m_tOpenResult.firstRewards do
			table.insert(tBigReward, self.m_tOpenResult.firstRewards[i])
		end
	end
	if #self.m_tOpenResult.bigRewards > 0 then 
		for i = 1, #self.m_tOpenResult.bigRewards do
			table.insert(tBigReward, self.m_tOpenResult.bigRewards[i])
		end
	end

	if self.m_tOpenResult.normalRewards and #self.m_tOpenResult.normalRewards > 0 then 
		WndHoraryBigReward:showInterface(7, self.m_tOpenResult.normalRewards, tBigReward)
	elseif #tBigReward > 0 then 
		WndHoraryBigReward:showInterface(6, tBigReward)
	end
end

--@brief 	解析大奖数据
function WndBilliardBall:_analyzeBigReward()
	-- body
	local sBigReward = self.m_tContent.firstRewards
	local array = SplitStringWithSeparator(sBigReward, "&")
	local nSex = CacheCenter:getPlayerInfo().sex
	local tItem = {reward_ids1 = {}, reward_nums1 = {}, name = LocalStrings.BILLIARDBALL_TEXT1[7]}
	self.m_tBigRewardList = {}
	for i = 1, #array do
--		WZLog("WndBilliardBall:_analyzeBigReward", string.sub(array[i], 2, -2))
		local string = string.sub(array[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string,",")[3])

		table.insert(tItem.reward_ids1, id)
		table.insert(tItem.reward_nums1, num)
	end

	self.m_tBigRewardList[1] = tItem

	local specialReward = self.m_tContent.superRewards
	local array1 = SplitStringWithSeparator(specialReward, "&")
	local tItem1 = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.BILLIARDBALL_TEXT1[8]}
	for i = 1, #array1 do
--		WZLog("WndBilliardBall:_analyzeBigReward", string.sub(array1[i], 2, -2))
		local string = string.sub(array1[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string, ",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string, ",")[3])
		
		table.insert(tItem1.reward_ids2, id)
		table.insert(tItem1.reward_nums2, num)
	end

	self.m_tBigRewardList[2] = tItem1
end

--@brief 	获取当前捕鼠等级
function WndBilliardBall:getCurLvInfo()
	local nLevel = self.m_nCurLevel 
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

--@brief    添加保存上次选择球杆
function WndBilliardBall:savePoleType()
    WZLog("WndBilliardBall:savePoleType")
    local _KeyString = ""
    local curDate = os.date("*t", SystemTime:getServerTime())
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = "BILLIARDBALL" .. tostring(CacheCenter:getPlayerInfo().id)
    local strValue =  data:getStringValue("BILLIARDBALL_POLE_MARK", _KeyString)
    local curValue = string.format("%02d%02d_%d", curDate.month, curDate.day, self.m_nPoleType)
    if strValue == nil or strValue == "" or strValue ~= curValue then
        data:setStringValue("BILLIARDBALL_POLE_MARK", _KeyString, curValue)
        data:flush()
    end
end

--@brief    获取上次保存的球杆
function WndBilliardBall:getPoleType()
    WZLog("WndBilliardBall:getPoleType")
    local _KeyString = ""
    local curDate = os.date("*t", SystemTime:getServerTime())
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = "BILLIARDBALL" .. tostring(CacheCenter:getPlayerInfo().id)
    local strValue =  data:getStringValue("BILLIARDBALL_POLE_MARK", _KeyString)
    local curValue = string.format("%02d%02d", curDate.month, curDate.day)
    if strValue ~= nil and strValue ~= "" then
        local result = SplitStringWithSeparator(strValue, "_")
        if result[1] == curValue then 
        	self.m_nPoleType = tonumber(result[2])
        	if self.m_nPoleType ~= 0 then 
        		GetElement(self.m_root, "cbgTool_WndBilliardBall", WZUICheckBoxGroup):setCheckIndex(self.m_nPoleType)
        	end
        end
    end
end
-------------------------------------私有方法模块End----------------------------------------
