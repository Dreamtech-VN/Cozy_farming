--WndWeekendSpecial2Data.lua
--@brief	WndWeekendSpecial2的数据模块
--@date		2024/08/19
--@author	yrd
--@note		周末特惠 - 7182

WndWeekendSpecial2 = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndWeekendSpecial2:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tFirstGiftObj = {}
	self.m_tSuperGiftObj = {}
	self.m_bRecordedPt = false     --是否记录坐标
	self.m_tReceivedInfo = nil 		--记录领取的是哪个礼包
	self.m_nGiftAPrevPtY = nil
	self.m_nGiftBPrevPtY = nil
	self.m_nShowType = nil 			--显示类型 0:充值 1:消耗道具
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndWeekendSpecial2:_unInit()
	self.m_root = nil
	self.m_tFirstGiftObj = nil
	self.m_tSuperGiftObj = nil
	self.m_bRecordedPt = nil
	self.m_tReceivedInfo = nil
	self.m_nGiftAPrevPtY = nil
	self.m_nGiftBPrevPtY = nil
	self.m_nShowType = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndWeekendSpecial2:createElement()
	if WndWeekendSpecial2.m_root ~= nil then
		WindowManager:removeWindow(WndWeekendSpecial2.m_root, WndWeekendSpecial2, true)
	end
	local element = WZUISystem:getInstance():createElement("WndWeekendSpecial2")
	assert(element, "WndWeekendSpecial2 create element failed!")
	self:_init()
	return element
end

--@brief 	获取活动详情成功
function WndWeekendSpecial2:GetActivityInfoOK(activityId, maxCount, count, status, rewardCounts, rewardItems, rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	if g_cityExtenInfo.activity7182 == activityId then
		self.m_nActivityId = activityId
		-- self.m_nMaxCount = maxCount
		-- self.m_nCount = count
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

		local nSex = CacheCenter:getPlayerInfo().sex

		self.m_nShowType = self.m_tContent.showType or 0

		self.m_tFirstGiftData = {}
		self.m_tSuperGiftData = {}
		if self.m_nShowType == 0 then
			for i=1,#self.m_tContent.firstRechargeConfig do
				local tData = {}
				tData.showType = 0
				tData.type = 1
				tData.index = i
				tData.config = self.m_tContent.firstRechargeConfig[i]
				tData.rewards = {}
				local array = SplitStringWithSeparator(self.m_tContent.firstGiftRewards[i], "&")
				for i = 1, #array do
					local strTemp = string.sub(array[i], 2, -2)
					local id = tonumber(SplitStringWithSeparator(strTemp,",")[nSex + 1])
					local num = tonumber(SplitStringWithSeparator(strTemp,",")[3])
					table.insert(tData.rewards, {id, num})
				end
				table.insert(self.m_tFirstGiftData, tData)
			end

			for i=1,#self.m_tContent.superRechargeConfig do
				local tData = {}
				tData.showType = 0
				tData.type = 2
				tData.index = i
				tData.config = self.m_tContent.superRechargeConfig[i]
				tData.rewards = {}
				local array = SplitStringWithSeparator(self.m_tContent.superGiftRewards[i], "&")
				for i = 1, #array do
					local strTemp = string.sub(array[i], 2, -2)
					local id = tonumber(SplitStringWithSeparator(strTemp,",")[nSex + 1])
					local num = tonumber(SplitStringWithSeparator(strTemp,",")[3])
					table.insert(tData.rewards, {id, num})
				end
				table.insert(self.m_tSuperGiftData, tData)
			end
		elseif self.m_nShowType == 1 then
			for i=1,#self.m_tContent.shopConfigA do
				local strTemp = self.m_tContent.shopConfigA[i]
				local nStart1, nEnd1 = string.find(strTemp, "cost:")
				local nStart2, nEnd2 = string.find(strTemp, "reward:")
				local tmpCost = SplitStringWithSeparator(string.sub(strTemp, nEnd1 + 2, nStart2 - 3), ",", nil, true)
				local tData = {}
				tData.showType = 1
				tData.type = 1
				tData.index = i
				tData.config = tmpCost
				tData.rewards = {}
				local array = SplitStringWithSeparator(string.sub(strTemp, nEnd2 + 1), "&")
				for i = 1, #array do
					local strTemp = string.sub(array[i], 2, -2)
					local id = tonumber(SplitStringWithSeparator(strTemp,",")[nSex + 1])
					local num = tonumber(SplitStringWithSeparator(strTemp,",")[3])
					table.insert(tData.rewards, {id, num})
				end
				table.insert(self.m_tFirstGiftData, tData)
			end

			for i=1,#self.m_tContent.shopConfigB do
				local strTemp = self.m_tContent.shopConfigB[i]
				local nStart1, nEnd1 = string.find(strTemp, "cost:")
				local nStart2, nEnd2 = string.find(strTemp, "reward:")
				local tmpCost = SplitStringWithSeparator(string.sub(strTemp, nEnd1 + 2, nStart2 - 3), ",", nil, true)
				local tData = {}
				tData.showType = 1
				tData.type = 2
				tData.index = i
				tData.config = tmpCost
				tData.rewards = {}
				local array = SplitStringWithSeparator(string.sub(strTemp, nEnd2 + 1), "&")
				for i = 1, #array do
					local strTemp = string.sub(array[i], 2, -2)
					local id = tonumber(SplitStringWithSeparator(strTemp,",")[nSex + 1])
					local num = tonumber(SplitStringWithSeparator(strTemp,",")[3])
					table.insert(tData.rewards, {id, num})
				end
				table.insert(self.m_tSuperGiftData, tData)
			end
		end

		local showDayConfig = self.m_tContent.showDayConfig
		if #showDayConfig == 7 then
			self.m_nEndTimestamp = self.m_nEndTime
		else
			local nServerTime = SystemTime:getServerTime()
			local tServerTime = os.date("*t", nServerTime)
			local nEndDayOfWeek = tServerTime.wday-1
			local bLoop = true
			while bLoop do
				nEndDayOfWeek = nEndDayOfWeek % 7 + 1
				bLoop = false
				for i=1,#showDayConfig do
					if showDayConfig[i] == nEndDayOfWeek then
						bLoop = true
						break
					end
				end
			end
			local diffDay = (nEndDayOfWeek - tServerTime.wday) % 7
			self.m_nEndTimestamp = os.time({year=tServerTime.year, month=tServerTime.month, day=tServerTime.day+diffDay, hour=23, min=59, sec=59})
			self.m_nEndTimestamp = math.min(self.m_nEndTimestamp, self.m_nEndTime)
		end
		self:showRemainingTime()
	end
end

--@brief 	获取其他活动数据
function WndWeekendSpecial2:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end 

	if doType == 1 then
		local tResult = json.decode(jsonData)
		WZLog("WndWeekendSpecial2:_onGetOtherData", doType, Serialize(tResult))

		self.m_nShowGift = tResult.showGift

		for i=1,#self.m_tFirstGiftData do
			if self.m_nShowType == 0 then
				self.m_tFirstGiftData[i].status = tResult.firstStatus[i]
			elseif self.m_nShowType == 1 then
				self.m_tFirstGiftData[i].status = tResult.shopAStatus[i]
			end
		end
		self.m_nFirstCurIdx = 1
		for i=1,#self.m_tFirstGiftData do
			if self.m_tFirstGiftData[i].status ~= 1 then
				self.m_nFirstCurIdx = i
				break
			end
		end
		for i=1,#self.m_tFirstGiftData do
			self.m_tFirstGiftData[i].startIdx = self.m_nFirstCurIdx
		end
		self.m_tFirstGiftCopy = CopyTable(self.m_tFirstGiftData)
		table.sort( self.m_tFirstGiftCopy, function(a,b)
			local indexA = (a.index-self.m_nFirstCurIdx+#self.m_tFirstGiftCopy)%#self.m_tFirstGiftCopy+1
			local indexB = (b.index-self.m_nFirstCurIdx+#self.m_tFirstGiftCopy)%#self.m_tFirstGiftCopy+1
			local valueA1 = math.floor((indexA - 1) / 6)
			local valueB1 = math.floor((indexB - 1) / 6)
			if valueA1 ~= valueB1 then
				return valueA1 < valueB1
			else
				local tab = {1,2,3,6,5,4}
				local valueA2 = (indexA - 1) % 6 + 1
				local valueB2 = (indexB - 1) % 6 + 1
				return tab[valueA2] < tab[valueB2]
			end
		end )

		for i=1,#self.m_tSuperGiftData do
			if self.m_nShowType == 0 then
				self.m_tSuperGiftData[i].status = tResult.superStatus[i]
			elseif self.m_nShowType == 1 then
				self.m_tSuperGiftData[i].status = tResult.shopBStatus[i]
			end
		end
		self.m_nSuperCurIdx = 1
		for i=1,#self.m_tSuperGiftData do
			if self.m_tSuperGiftData[i].status ~= 1 then
				self.m_nSuperCurIdx = i
				break
			end
		end
		for i=1,#self.m_tSuperGiftData do
			self.m_tSuperGiftData[i].startIdx = self.m_nSuperCurIdx
		end
		self.m_tSuperGiftCopy = CopyTable(self.m_tSuperGiftData)
		table.sort( self.m_tSuperGiftCopy, function(a,b)
			local indexA = (a.index-self.m_nSuperCurIdx+#self.m_tSuperGiftCopy)%#self.m_tSuperGiftCopy+1
			local indexB = (b.index-self.m_nSuperCurIdx+#self.m_tSuperGiftCopy)%#self.m_tSuperGiftCopy+1
			local valueA1 = math.floor((indexA - 1) / 6)
			local valueB1 = math.floor((indexB - 1) / 6)
			if valueA1 ~= valueB1 then
				return valueA1 < valueB1
			else
				local tab = {1,2,3,6,5,4}
				local valueA2 = (indexA - 1) % 6 + 1
				local valueB2 = (indexB - 1) % 6 + 1
				return tab[valueA2] < tab[valueB2]
			end
		end )

		if self.m_tReceivedInfo then
			self:playAnimation()
		else
			self:showGifts()
		end
	elseif doType == 2 then
		if result == 0 then
			local tResult = json.decode(jsonData)
			WndRewardShow:showById(tResult.itemIds, tResult.itemNums)
		end
	elseif doType == 3 then
		if result == 1 then
			local tResult = json.decode(jsonData)
			self:gotoBuy(tResult.rechargeId)
		end
	elseif doType == 4 then
		if result == 0 then
			local tResult = json.decode(jsonData)
			WndRewardShow:showById(tResult.itemIds, tResult.itemNums)

			if tResult.giftId == 0 then
				self.m_tFirstGiftData[tResult.id + 1].status = 1
				self.m_nFirstCurIdx = (self.m_nFirstCurIdx) % #self.m_tFirstGiftData + 1
				for i=1,#self.m_tFirstGiftData do
					self.m_tFirstGiftData[i].startIdx = self.m_nFirstCurIdx
				end
				self.m_tFirstGiftCopy = CopyTable(self.m_tFirstGiftData)
				table.sort( self.m_tFirstGiftCopy, function(a,b)
					local indexA = (a.index-self.m_nFirstCurIdx+#self.m_tFirstGiftCopy)%#self.m_tFirstGiftCopy+1
					local indexB = (b.index-self.m_nFirstCurIdx+#self.m_tFirstGiftCopy)%#self.m_tFirstGiftCopy+1
					local valueA1 = math.floor((indexA - 1) / 6)
					local valueB1 = math.floor((indexB - 1) / 6)
					if valueA1 ~= valueB1 then
						return valueA1 < valueB1
					else
						local tab = {1,2,3,6,5,4}
						local valueA2 = (indexA - 1) % 6 + 1
						local valueB2 = (indexB - 1) % 6 + 1
						return tab[valueA2] < tab[valueB2]
					end
				end )
			elseif tResult.giftId == 1 then
				self.m_tSuperGiftData[tResult.id + 1].status = 1
				self.m_nSuperCurIdx = (self.m_nSuperCurIdx) % #self.m_tSuperGiftData + 1
				for i=1,#self.m_tSuperGiftData do
					self.m_tSuperGiftData[i].startIdx = self.m_nSuperCurIdx
				end
				self.m_tSuperGiftCopy = CopyTable(self.m_tSuperGiftData)
				table.sort( self.m_tSuperGiftCopy, function(a,b)
					local indexA = (a.index-self.m_nSuperCurIdx+#self.m_tSuperGiftCopy)%#self.m_tSuperGiftCopy+1
					local indexB = (b.index-self.m_nSuperCurIdx+#self.m_tSuperGiftCopy)%#self.m_tSuperGiftCopy+1
					local valueA1 = math.floor((indexA - 1) / 6)
					local valueB1 = math.floor((indexB - 1) / 6)
					if valueA1 ~= valueB1 then
						return valueA1 < valueB1
					else
						local tab = {1,2,3,6,5,4}
						local valueA2 = (indexA - 1) % 6 + 1
						local valueB2 = (indexB - 1) % 6 + 1
						return tab[valueA2] < tab[valueB2]
					end
				end )
			end
			if self.m_tReceivedInfo then
				self:playAnimation()
			else
				self:showGifts()
			end
		end
	end
end

--@brief 	下订单
function WndWeekendSpecial2:gotoBuy(rechargeId)
	local sdkData = {}
	local vipData = GDatatab_recharge["id_" .. rechargeId]
	sdkData.id = rechargeId
	sdkData.price = vipData.price
	sdkData.productName = tostring(vipData.name)
	sdkData.payCode = GetPayCodeIdByChannelId(vipData)
	sdkData.quantifier = LocalStrings.SHOP_IND
	sdkData.number = "1"
	sdkData.giftNumber = "0"
	sdkData.productDesc = tostring(vipData.name)
	PassportSdkManager:getOrderNum(sdkData)
end

--@brief 	解锁成功回调
function WndWeekendSpecial2:_onRechargeSuccessResult()
	--刷新领取状态
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 1, "")
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------


-------------------------------------分割线----------------------------------------

CellWeekendSpecial2 = {}
function CellWeekendSpecial2:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_bIsLoaded = false
	self.m_tData = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellWeekendSpecial2:_unInit()
	self.m_root = nil
	self.m_bIsLoaded = nil
	self.m_tData = nil
end

--@brief	创建控件
function CellWeekendSpecial2:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(242,168))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end

function CellWeekendSpecial2:setData(data)
	self.m_tData = data
	self:updateUI()
end

--@brief 	获取数据
function CellWeekendSpecial2:getData()
	return self.m_tData
end

--@brief 	开始加载
function CellWeekendSpecial2:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("CellWeekendSpecial2")
	celElement:setVisible(true)
	element:addChild(celElement)
	self.m_bIsLoaded = true 

	self:updateUI()
end

--@brief    获得充值数据
function CellWeekendSpecial2:getRechargeData()
	local tRechargeData = nil
	for i, value in pairs(GDatatab_recharge) do
		if tonumber(value.type) == self.m_tData.config[1] and tonumber(value.sort) == self.m_tData.config[2] then 
			tRechargeData = value
		end
	end
	return tRechargeData
end

--@brief    更新界面
function CellWeekendSpecial2:updateUI()
	if not self.m_bIsLoaded then
		return
	end

	for i=1,2 do
		local conItem = GetElement(self.m_root,"conItem"..i,WZUIContainer)
		conItem:removeAllChildrenWithCleanup(true)
		if self.m_tData.rewards[i] then
			local celElement,tCell = CellGoodItem:createElement()
			celElement:setTag(i-1)
			tCell:setCellGoodLocalId(self.m_tData.rewards[i][1], self.m_tData.rewards[i][2], 17)
			tCell:setItemClickFun(self,self.onItemClick)
			tCell:setItemCount(self.m_tData.rewards[i][2])
			conItem:addChild(celElement)
		end
	end

	local imgBg = GetElement(self.m_root,"imgBg",WZUIImage)
	local imgItemBg1 = GetElement(self.m_root,"imgItemBg1",WZUIImage)
	local imgItemBg2 = GetElement(self.m_root,"imgItemBg2",WZUIImage)
	local btnBuy = GetElement(self.m_root,"btnBuy",WZUIButton)
	local imgBuy = GetElement(self.m_root,"imgBuy",WZUIImage)
	local ftbBuy = GetElement(self.m_root,"ftbBuy",WZUIFreeTextBox)
	local imgRedDot = GetElement(self.m_root,"imgRedDot",WZUIImage)
	imgRedDot:setVisible(false)
	if self.m_tData.startIdx == self.m_tData.index then --第一个
		imgBg:setFile("ui/newActivity/common_zmth_di_01.png")
		imgItemBg1:setFile("ui/newActivity/common_zmth_tbd_01.png")
		imgItemBg2:setFile("ui/newActivity/common_zmth_tbd_01.png")
		btnBuy:setTouchEnable(true)
		imgBuy:setGrayRender(false)
		local strFormat1 = [[<T C="255,250,236" S="22" P="1" SC="0,108,3" SS="4" SE="1">%s</T>]]
		local strFormat2 = [[<I Z="0.4">%s</I><T C="255,250,236" S="22" P="1" SC="0,108,3" SS="4" SE="1">%s</T>]]
		if self.m_tData.showType == 0 then
			if self.m_tData.status == 0 then --免费或可领取
				if self.m_tData.config[1] == -1 and self.m_tData.config[2] == -1 then --免费
					ftbBuy:setShowText(string.format(strFormat1, LocalStrings.PETFREE2))
				else --可领取
					ftbBuy:setShowText(string.format(strFormat1, LocalStrings.ACTIVE_BTN_GET))
				end
				imgRedDot:setVisible(true)
			elseif self.m_tData.status == 2 then --购买金额
				local tRechargeData = self:getRechargeData()
				ftbBuy:setShowText(string.format(strFormat1, tRechargeData.unit))
			end
		elseif self.m_tData.showType == 1 then
			if self.m_tData.config[1] == -1 and self.m_tData.config[2] == -1 then
				ftbBuy:setShowText(string.format(strFormat1, LocalStrings.PETFREE2))
			else
				local tItemInfo = GDatatab_item["id_"..self.m_tData.config[1]]
				ftbBuy:setShowText(string.format(strFormat2, tItemInfo.icon, self.m_tData.config[2]))
			end
		end
	else --其他列按钮置灰
		imgBg:setFile("ui/newActivity/common_zmth_di_02.png")
		imgItemBg1:setFile("ui/newActivity/common_zmth_tbd_02.png")
		imgItemBg2:setFile("ui/newActivity/common_zmth_tbd_02.png")
		btnBuy:setTouchEnable(false)
		imgBuy:setGrayRender(true)
		local strFormat1 = [[<T C="255,250,236" S="22" P="1" SC="97,98,98" SS="4" SE="1">%s</T><I Z="0.8">ui/common/common_icon_suo10.png</I>]]
		local strFormat2 = [[<I Z="0.4">%s</I><T C="255,250,236" S="22" P="1" SC="97,98,98" SS="4" SE="1">%s</T><I Z="0.8">ui/common/common_icon_suo10.png</I>]]
		if self.m_tData.config[1] == -1 and self.m_tData.config[2] == -1 then --免费
			ftbBuy:setShowText(string.format(strFormat1, LocalStrings.PETFREE2))
		else
			if self.m_tData.showType == 0 then
				local tRechargeData = self:getRechargeData()
				ftbBuy:setShowText(string.format(strFormat1, tRechargeData.unit))
			elseif self.m_tData.showType == 1 then
				local tItemInfo = GDatatab_item["id_"..self.m_tData.config[1]]
				ftbBuy:setShowText(string.format(strFormat2, tItemInfo.icon, self.m_tData.config[2]))
			end
		end
	end

	self:setArrawType(self.m_nArrawType)
end

--@brief	显示
function CellWeekendSpecial2:showUI(bShow)
	self.m_root:setVisible(bShow)
end

--@brief	设置箭头指向 1朝右,2朝下,3朝左 其他不显示箭头
function CellWeekendSpecial2:setArrawType(nType)
	self.m_nArrawType = nType

	if not self.m_bIsLoaded then
		return
	end

	self.m_nArrawType = nil

	local imgArrawR = GetElement(self.m_root,"imgArrawR",WZUIImage)
	local imgArrawL = GetElement(self.m_root,"imgArrawL",WZUIImage)
	local imgArrawD = GetElement(self.m_root,"imgArrawD",WZUIImage)
	imgArrawR:setVisible(false)
	imgArrawL:setVisible(false)
	imgArrawD:setVisible(false)
	if nType == 1 then
		imgArrawR:setVisible(true)
	elseif nType == 2 then
		imgArrawD:setVisible(true)
	elseif nType == 3 then
		imgArrawL:setVisible(true)
	end
end

--@brief	点击物品弹出对应的tips
function CellWeekendSpecial2:onItemClick(tCell,tag,tData)
	if tData == nil then
	   return
	end
	WndItemInfo:onCloseClick()
	WndItemInfo:showInfo(tCell.m_root,WndWeekendSpecial2.m_root,1,tData,false)
end

--@brief    点击领取奖励
function CellWeekendSpecial2:onClickBuy()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_tData.startIdx == self.m_tData.index then --第一列
		if self.m_tData.showType == 0 then
			if self.m_tData.status == 0 then
				--用作动画
				WndWeekendSpecial2.m_tReceivedInfo = {type=self.m_tData.type,index=self.m_tData.index}

				local sjson = {}
				sjson.giftId = self.m_tData.type - 1
				sjson.id = self.m_tData.index - 1
				sjson = json.encode(sjson)
				ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7182, 2, sjson)
			elseif self.m_tData.status == 2 then
				local tRechargeData = self:getRechargeData()
				local sjson = {}
				sjson.giftId = self.m_tData.type - 1
				sjson.id = self.m_tData.index - 1
				sjson.rechargeId = tRechargeData.id
				sjson = json.encode(sjson)
				ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7182, 3, sjson)
			end
		elseif self.m_tData.showType == 1 then
			if self.m_tData.config[1] ~= -1 and self.m_tData.config[2] ~= -1 then
				if not JudgeMoneyIsEnough(self.m_tData.config[1], self.m_tData.config[2], nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.onClickBuyCall) then
					return
				end
			end
			self:onClickBuyCall()
		end
	end
end

--@brief 	确定购买
function CellWeekendSpecial2:onClickBuyCall()
	WndWeekendSpecial2.m_tReceivedInfo = {type=self.m_tData.type,index=self.m_tData.index}

	local sjson = {}
	sjson.id = self.m_tData.index - 1
	sjson = json.encode(sjson)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7182, 4, sjson)
end

--@return	新建的表实例对象
function CellWeekendSpecial2:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end