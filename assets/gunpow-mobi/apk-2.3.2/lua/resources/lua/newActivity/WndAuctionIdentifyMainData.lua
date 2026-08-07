--WndAuctionIdentifyMainData.lua
--@brief	WndAuctionIdentifyMain的数据模块
--@date		2023/05/31
--@author	yrd
--@note		拍卖行-鉴宝界面

WndAuctionIdentifyMain = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndAuctionIdentifyMain:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nIdentifyNumIndex = 1 		--鉴定x次下标 1:鉴定1次 2鉴定5次
	self.m_nIdentifyNumList = {1,5} 	--鉴定x次列表 1:鉴定1次 2鉴定5次
	self.m_tData = nil 					--基础数据

	self.m_tRewardList1Data = nil 		--鉴宝奖励数据列表
	self.m_tRewardList1Obj = nil 		--鉴宝奖励对象列表
	self.m_nSureChoose1Index = nil 		--鉴宝奖励数据列表的下标,表示确定的物品
	self.m_nWillChoose1value = nil 		--鉴宝奖励数据列表各项第一个值,表示正在选择的物品

	self.m_tRewardList2Data = nil 		--自选奖励数据
	self.m_tRewardList2Obj = nil 		--自选奖励对象
	self.m_tChooseIndexList = {} 		--自选奖励将选中的下标列表

	self.m_sNotRemindContent = "AuctionIdentifyM3T1"		--不再提示
	self.m_bNotRemind = false 								--不再提示

	self.m_tClipAniName = {"wait1", "wait2", "wait2"}
	self.m_bIsOpenBtn = true
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndAuctionIdentifyMain:_unInit()
	self.m_root = nil
	self.m_nIdentifyNumIndex = nil
	self.m_nIdentifyNumList = nil
	self.m_tData = nil

	self.m_tRewardList1Data = nil
	self.m_tRewardList1Obj = nil
	self.m_nSureChoose1Index = nil
	self.m_nWillChoose1value = nil

	self.m_tRewardList2Data = nil
	self.m_tRewardList2Obj = nil
	self.m_tChooseIndexList = nil

	self.m_sNotRemindContent = nil
	self.m_bNotRemind = nil

	self.m_tClipAniName = nil
	self.m_bIsOpenBtn = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndAuctionIdentifyMain:createElement()
	if WndAuctionIdentifyMain.m_root ~= nil then
		WindowManager:removeWindow(WndAuctionIdentifyMain.m_root, WndAuctionIdentifyMain, true)
	end
	local element = WZUISystem:getInstance():createElement("WndAuctionIdentifyMain")
	assert(element, "WndAuctionIdentifyMain create element failed!")
	self:_init()
	return element
end

--@brief	外部接口
function WndAuctionIdentifyMain:showInterface()
	local wnd = WndAuctionIdentifyMain:createElement()
	WindowManager:addWindow(wnd, WndAuctionIdentifyMain, nil, nil, nil, true)
end

--@brief	获取鉴宝自定义协议OK
function WndAuctionIdentifyMain:getJBActivityDoOk(opType, result, sjson)
	if self.m_root == nil then return end

	WZLog("WndAuctionIdentifyMain:getJBActivityDoOk",TableToString(json.decode(sjson)))

	-- result 操作结果：1-成功，2-失败，3-参数异常，4-道具不足，5-请先选择物品，6-不能切换已选物品，7-本轮未鉴定过，8-未达成条件，9-已达限量
	if result == 1 or result == 0 then
		if opType == 1 then --鉴宝
			-- MsgBoxManager:showTipBox(LocalStrings.AUCTION_HOUSE_TEXT37[24])

			-- local tData = json.decode(sjson)
			-- if tData.itemIds and #tData.itemIds > 0 and tData.nums and #tData.nums > 0 then
			-- 	self:showSettlementReward(tData.itemIds,tData.nums,tData.rate)

			-- 	--清除选择鉴宝物品
			-- 	for i=1,#self.m_tRewardList1Data do
			-- 		self.m_tRewardList1Data[i][5] = 0
			-- 	end
			-- 	self.m_nSureChoose1Index = nil
			-- 	self.m_nWillChoose1value = nil
			-- 	self:updateChooseUI1()
			-- end

			-- local opType = 9
			-- local sjson = json.encode({})
			-- ProtocolProcessorNewActivity:send_ACTIVITY2_JBActivityDo(opType, sjson)

			self.m_tRewardList = json.decode(sjson)
			self:showIdentifyAnimal()
		elseif opType == 2 then --刷新鉴宝奖池
			self.m_tRewardList1Data = json.decode(sjson)

			self.m_nSureChoose1Index = nil
			for i=1,#self.m_tRewardList1Data do
				if self.m_tRewardList1Data[i][5] == 1 then
					self.m_nSureChoose1Index = i
					break
				end
			end
			self.m_nWillChoose1value = nil
			if self.m_nSureChoose1Index ~= nil then
			    self.m_nWillChoose1value = self.m_tRewardList1Data[self.m_nSureChoose1Index][1]
			end
			self:updateChooseUI1()

			--更新刷新消耗
			self.m_tData.refreshCost1[4] = self.m_tData.refreshCost1[4] + 1
			self:updateUI()
		elseif opType == 3 then --自选鉴宝奖池物品
			local tData = json.decode(sjson)

			self.m_nSureChoose1Index = nil
			if tData.status == 1 then
				for i=1,#self.m_tRewardList1Data do
					self.m_tRewardList1Data[i][5] = 0
					if self.m_tRewardList1Data[i][1] == tData.index then
						self.m_tRewardList1Data[i][5] = 1
						self.m_nSureChoose1Index = i
					end
				end
			end
			self.m_nWillChoose1value = nil
			if self.m_nSureChoose1Index ~= nil then
			    self.m_nWillChoose1value = self.m_tRewardList1Data[self.m_nSureChoose1Index][1]
			end

			self:updateChooseUI1()
		elseif opType == 4 then --获取大奖奖池

			self.m_tRewardList2Data = json.decode(sjson)

			self:updateChooseUI2()
		elseif opType == 5 then --刷新大奖奖池
			self.m_tChooseIndexList = {}

			self.m_tRewardList2Data = json.decode(sjson)

			self:updateChooseUI2()

			--更新刷新消耗
			self.m_tData.refreshCost2[4] = self.m_tData.refreshCost2[4] + 1
			self:updateUI()
		elseif opType == 6 then --领取大奖
			self.m_tChooseIndexList = {}
			local tData = json.decode(sjson)

			WndRewardShow:showById(tData.itemIds, tData.nums)

			self.m_tData.totalTimes = tData.totalTimes
			self:updateUI()

			local opType = 4
			local sjson = json.encode({})
			ProtocolProcessorNewActivity:send_ACTIVITY2_JBActivityDo(opType, sjson)
		elseif opType == 7 then --结算
			local tData = json.decode(sjson)
			if tData.itemIds and #tData.itemIds > 0 and tData.nums and #tData.nums > 0 then
				self:showSettlementReward(tData.itemIds,tData.nums,tData.rate)
			end

			--清除选择鉴宝物品
			for i=1,#self.m_tRewardList1Data do
				self.m_tRewardList1Data[i][5] = 0
			end
			self.m_nSureChoose1Index = nil
			self.m_nWillChoose1value = nil
			self:updateChooseUI1()

			local opType = 9
			local sjson = json.encode({})
			ProtocolProcessorNewActivity:send_ACTIVITY2_JBActivityDo(opType, sjson)
		elseif opType == 8 then --获取鉴宝奖池
			self.m_tRewardList1Data = json.decode(sjson)

			self.m_nSureChoose1Index = nil
			for i=1,#self.m_tRewardList1Data do
				if self.m_tRewardList1Data[i][5] == 1 then
					self.m_nSureChoose1Index = i
					break
				end
			end
			self.m_nWillChoose1value = nil
			if self.m_nSureChoose1Index ~= nil then
			    self.m_nWillChoose1value = self.m_tRewardList1Data[self.m_nSureChoose1Index][1]
			end
			self:updateChooseUI1()
		elseif opType == 9 then --获取基础数据
			self.m_tData = json.decode(sjson)

			local curRate = 0
			for i=1,GetTableLen(self.m_tData.rate) do
				if self.m_tData.curValue >= self.m_tData.rate[tostring(i)] then
					curRate = i
				end
			end

			self:updateUI()
		end
	elseif result == 2 then
		MsgBoxManager:showTipBox(LocalStrings.FAIL)
	elseif result == 3 then
		MsgBoxManager:showTipBox(LocalStrings.OPERATION_ERROR)
	elseif result == 4 then
		MsgBoxManager:showTipBox(LocalStrings.SEND_PROPOSAL_LETTER2)
	elseif result == 5 then
		MsgBoxManager:showTipBox(LocalStrings.AUCTION_HOUSE_TEXT37[5])
	elseif result == 6 then
		MsgBoxManager:showTipBox(LocalStrings.AUCTION_HOUSE_TEXT37[6])
	elseif result == 7 then
		MsgBoxManager:showTipBox(LocalStrings.AUCTION_HOUSE_TEXT37[7])
	elseif result == 8 then
		MsgBoxManager:showTipBox(LocalStrings.AUCTION_HOUSE_TEXT37[8])
	elseif result == 9 then
		MsgBoxManager:showTipBox(LocalStrings.AUCTION_HOUSE_TEXT37[9])
	end

	--开放按钮
	if result == 1 or result == 0 then
	else
		self.m_bIsOpenBtn = true
	end
end

--是否是已选择的大奖
function WndAuctionIdentifyMain:getChooseBigRewardKey(val)
    local idx = 0
    for i=1,#self.m_tChooseIndexList do
		if self.m_tChooseIndexList[i] == val then
            idx = i
        end
    end
    return idx
end

--获得当前倍数
function WndAuctionIdentifyMain:getCurRate()
	local curRate = 0
	for i=1,GetTableLen(self.m_tData.rate) do
		if self.m_tData.curValue >= self.m_tData.rate[tostring(i)] then
			curRate = i
		end
	end
	return curRate
end

--获得鉴宝池物品数据列表下标
function WndAuctionIdentifyMain:getRewardList1DataKey(nValue)
    local nRewardList1Key = nil
	for i=1,#self.m_tRewardList1Data do
		if self.m_tRewardList1Data[i][1] == nValue then
			nRewardList1Key = i
			break
		end
	end
	return nRewardList1Key
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
