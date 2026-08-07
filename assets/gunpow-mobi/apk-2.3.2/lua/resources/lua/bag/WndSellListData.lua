--WndSellListData.lua
--@brief	WndSellList的数据模块
--@date		2015/07/03
--@author	zsq
--@note		出售物品列表

WndSellList = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSellList:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tLeft = nil
    self.m_vItemID = nil
    self.m_vItemNum = nil
    self.m_vItemID_Huanhua = nil        --幻化装备列表
    self.m_vItemNum_Huanhua = nil
    self.m_nLoadingID = nil
	self.m_tGetList = nil
	self.m_tGetResetIdsList = nil
    self.m_tGetResetNumsList = nil
    self.m_sResertContainer = nil

    self.m_bOpenState = false			--正在兑换中
    self.m_tActivityData = nil 			--被废为宝活动数据
    self.m_nExchangeType = 0			--兑换倍数 0:一倍 1:两倍

    self.m_tRewards = {}    --记录回收成功返回的奖励
    self.m_bIsIncludeHuanhua = false	--用来记录回收商品列表是否包含幻化装备（幻化装备需要发送两条协议）
    self.m_nRecvRecycleProtoNums = 0    --记录收到回收商品协议数量
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSellList:_unInit()
	self.m_root = nil
	self.m_tLeft = nil
    self.m_vItemID = nil
    self.m_vItemNum = nil
    self.m_vItemID_Huanhua = nil        --幻化装备列表
    self.m_vItemNum_Huanhua = nil
    self.m_nLoadingID = nil
	self.m_tGetList = nil
	self.m_tGetResetIdsList = nil
    self.m_tGetResetNumsList = nil
    self.m_sResertContainer = nil
    self.m_bOpenState = nil
    self.m_tActivityData = nil
    self.m_nExchangeType = nil

    self.m_tRewards = nil    --记录回收成功返回的奖励
    self.m_bIsIncludeHuanhua = false	--用来记录回收商品列表是否包含幻化装备（幻化装备需要发送两条协议）
    self.m_nRecvRecycleProtoNums = 0    --记录收到回收商品协议数量
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSellList:createElement()
	local element = WZUISystem:getInstance():createElement("WndSellList")
	assert(element, "WndSellList create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	获得出售列表内同类型装备个数
function WndSellList:getInSaleNum(itemId) 
	if self.m_tLeft == nil then return 0 end
	local num = 0
	local tData = GDatatab_item["id_"..itemId]
	--武器
	if tData.main_type == 4 and (tData.sub_type == 0 or tData.sub_type == 1) then
		for i=1,#self.m_tLeft do
			local tItem = self.m_tLeft[i].basicInfo
			if tItem.main_type == 4 and (tItem.sub_type == 0 or tItem.sub_type == 1) then 
				num = num + 1
			end
		end
		return num
	else
		for i=1,#self.m_tLeft do
			local tItem = self.m_tLeft[i].basicInfo
			if tItem.main_type == 4 and tItem.sub_type == tData.sub_type then 
				num = num + 1
			end
		end
		return num
	end
end

--@brief	获得拥有的同类型装备个数
function WndSellList:getOwnNum(itemId) 
	local tDataList = CacheCenter:getPlayerItems()
	local num = 0
	local tData = GDatatab_item["id_"..itemId]
	--武器
	if tData.main_type == 4 and (tData.sub_type == 0 or tData.sub_type == 1) then
		for i=1,#tDataList do
			local tItem = tDataList[i].basicInfo
			if tItem.main_type == 4 and (tItem.sub_type == 0 or tItem.sub_type == 1) then 
				num = num + 1
			end
		end
		return num
	else
		for i=1,#tDataList do
			local tItem = tDataList[i].basicInfo
			if tItem.main_type == 4 and tItem.sub_type == tData.sub_type then 
				num = num + 1
			end
		end
		return num
	end
end

--@brief	获得拥有的同类型体验装备个数
function WndSellList:getOwnLimitNum(itemId) 
	local tDataList = CacheCenter:getPlayerItems()
	local num = 0
	local tData = GDatatab_item["id_"..itemId]
	--武器
	if tData.main_type == 4 and (tData.sub_type == 0 or tData.sub_type == 1) then
		for i=1,#tDataList do
			local tItem = tDataList[i].basicInfo
			if tItem.main_type == 4 and (tItem.sub_type == 0 or tItem.sub_type == 1) and tItem.time_limit ~= -1 then 
				num = num + 1
			end
		end
		return num
	else
		for i=1,#tDataList do
			local tItem = tDataList[i].basicInfo
			if tItem.main_type == 4 and tItem.sub_type == tData.sub_type and tItem.time_limit ~= -1 then 
				num = num + 1
			end
		end
		return num
	end
end

--@brief	获得活动内容成功
function WndSellList:getActivityInfoOK(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts, count, maxCount, finishCondition)
	if activityId == g_cityExtenInfo.activity7066 then
		self.m_tActivityData = {}
		self.m_tActivityData.activityId = activityId
		self.m_tActivityData.content = json.decode(content)
		self.m_tActivityData.tips = tips
		self.m_tActivityData.startTime = startTime
		self.m_tActivityData.endTime = endTime
		self.m_tActivityData.serverTime = serverTime
		self.m_tActivityData.rewardId = rewardId
		self.m_tActivityData.status = status
		self.m_tActivityData.rewardItems = rewardItems
		self.m_tActivityData.rewardItemsParamCount = rewardItemsParamCount
		self.m_tActivityData.rewardCounts = rewardCounts
		self.m_tActivityData.count = count
		self.m_tActivityData.maxCount = maxCount
		self.m_tActivityData.finishCondition = finishCondition

		self:updateMakeWasteProfitable()
		self:updateActProgress()
		self:_analyzeBigReward()
	end
end

--@brief 	解析大奖数据
function WndSellList:_analyzeBigReward()
	local sBigReward = self.m_tActivityData.content.recycleRwards
	local array = SplitStringWithSeparator(sBigReward, "&")
	local nSex = CacheCenter:getPlayerInfo().sex
	local tItem = {reward_ids1 = {}, reward_nums1 = {}, name = LocalStrings.ACT_MAKE_WASTE_PROFITABLE[9]}
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

	local specialReward = self.m_tActivityData.content.recycleRwards2
	local array1 = SplitStringWithSeparator(specialReward, "&")
	local tItem1 = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.ACT_MAKE_WASTE_PROFITABLE[10]}
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

--@brief 	获取其他活动数据
function WndSellList:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end 

	if doType == 3 then --开启结果
		local tResult = json.decode(jsonData)
		WZLog("WndSellList:_onGetOtherData", Serialize(tResult))

		--变废为宝活动进度数据
		self.m_tActivityData.count = tResult.count

		self.m_tOpenResult = {}
		if tResult.itemNums and tResult.itemNums then
			self.m_tOpenResult.normalRewards = {}
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
		end

		if result == 1 then
			self:showOpenAction()
			self:updateActProgress()
		end
	end
end

--@brief 	设置射箭的状态
function WndSellList:setOpenState(state)
	if self.m_root == nil then return end 

	self.m_bOpenState = state
end

--@brief 	设置射箭的状态
function WndSellList:getOpenState()
	return self.m_bOpenState
end

--@brief	回收物品数量
function WndSellList:getResetCount()
	local nResetCount = 0
	if self.m_tLeft then
		for i,data in pairs(self.m_tLeft) do
			nResetCount = nResetCount + data.lastNum
		end
	end
	return nResetCount
end

--@brief	是否在活动内开放时间
function WndSellList:isActivityOpenTime()
	local bOpen = false
	local day = os.date("*t", SystemTime:getServerTime()).day
	if g_cityExtenInfo and g_cityExtenInfo.activity7066 and g_cityExtenInfo.activity7066 > 0 then
		for i=1,#self.m_tActivityData.finishCondition do
			if self.m_tActivityData.finishCondition[i] == day then
				bOpen = true
				break
			end
		end
	end
	return bOpen
end

--@brief	回收物品成功
function WndSellList:recycleItemOk(result, items, nums)
	if result == 0 then
    	self.m_nRecvRecycleProtoNums = self.m_nRecvRecycleProtoNums + 1   --记录收到回收商品协议数量
		WZLog("WndSellList:recycleItemOk self.m_nRecvRecycleProtoNums", self.m_nRecvRecycleProtoNums)
		WZLog("WndSellList:recycleItemOk self.m_bIsIncludeHuanhua", self.m_bIsIncludeHuanhua)
		WndRewardShow:showByIdForRecvMulti(VectorToTable(items),VectorToTable(nums))
		-- if type(VectorToTable(items)) == "table" and #VectorToTable(items) > 0 then
		-- 	if self.m_bIsIncludeHuanhua == false then
		-- 		self.m_nRecvRecycleProtoNums = 0
		-- 		WndRewardShow:showById(VectorToTable(items),VectorToTable(nums))
		-- 	else
		-- 		if self.m_tRewards == nil then self.m_tRewards = {} end
		-- 		if self.m_tRewards["items"] == nil then self.m_tRewards["items"] = {} end
		-- 		if self.m_tRewards["nums"] == nil then self.m_tRewards["nums"] = {} end
		-- 		local tItems = VectorToTable(items)
		-- 		local tNums = VectorToTable(nums)
		-- 		for i=1,#tItems do
		-- 			local v1 = tItems[i]
		-- 			WZLog("WndSellList:recycleItemOk item", v1)
		-- 			local bIsSameItem = false
		-- 			local nIndexSameItem = 1
		-- 			for j=1,#(self.m_tRewards["items"]) do
		-- 				local v2 = self.m_tRewards["items"][j]
		-- 				WZLog("WndSellList:recycleItemOk m_tRewards", v2)
		-- 				if v1 == v2 then
		-- 					WZLog("WndSellList:recycleItemOk same item", v1, v2)
		-- 					bIsSameItem = true
		-- 					nIndexSameItem = j
		-- 				else
		-- 					WZLog("WndSellList:recycleItemOk new item", v1, v2)
		-- 				end
		-- 			end
		-- 			WZLog("WndSellList:recycleItemOk bIsSameItem", bIsSameItem, nIndexSameItem)
		-- 			if bIsSameItem then
		-- 				self.m_tRewards["nums"][nIndexSameItem] = (self.m_tRewards["nums"][nIndexSameItem] or 0) + tNums[i]
		-- 			else
		-- 				self.m_tRewards["items"][#(self.m_tRewards["items"]) + 1] = tItems[i]
		-- 				self.m_tRewards["nums"][#(self.m_tRewards["nums"]) + 1] = tNums[i]
		-- 			end
		-- 		end
		-- 		if self.m_nRecvRecycleProtoNums > 1 then
		-- 			--self:recycleSucc2ShowReward()
		-- 			WndRewardShow:showById(CopyTable(self.m_tRewards["items"]),CopyTable(self.m_tRewards["nums"]))
		-- 			self.m_tRewards["items"] = {}
		-- 			self.m_tRewards["nums"] = {}	
		-- 			self.m_nRecvRecycleProtoNums = 0
		-- 			self.m_bIsIncludeHuanhua = false
		-- 		end
		-- 	end
		-- 	--WndRewardShow:showById(VectorToTable(items),VectorToTable(nums))				
		-- end
	elseif result == 1 then
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITYCLOSE)
	elseif result == 2 then
		local costId = 70
		local basicInfo = GDatatab_item["id_" .. costId]
		MsgBoxManager:showTipBox(string.format(LocalStrings.CARD_COUNT1, basicInfo.name))
	end
	self:recycleSucc()
end

-------------------------------------私有方法模块End----------------------------------------
