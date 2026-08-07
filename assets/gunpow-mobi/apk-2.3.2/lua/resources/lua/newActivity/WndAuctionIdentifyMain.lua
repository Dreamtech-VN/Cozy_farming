--WndAuctionIdentifyMain.lua
--@brief	WndAuctionIdentifyMain的UI模块
--@date		2023/05/31
--@author	yrd
--@note		拍卖行-鉴宝界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndAuctionIdentifyMain:onEnter(element)
	self.m_root = element

	local opType = 9
	local sjson = json.encode({})
	ProtocolProcessorNewActivity:send_ACTIVITY2_JBActivityDo(opType, sjson)

	local opType = 8
	local sjson = json.encode({})
	ProtocolProcessorNewActivity:send_ACTIVITY2_JBActivityDo(opType, sjson)

	local opType = 4
	local sjson = json.encode({})
	ProtocolProcessorNewActivity:send_ACTIVITY2_JBActivityDo(opType, sjson)

	self:_initStaticText()

	self:updateIdentifyBtn()

	GetElement(self.m_root,"conMain2_WndAuctionIdentifyMain",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conMain3_WndAuctionIdentifyMain",WZUIContainer):setVisible(false)

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndAuctionIdentifyMain:onExit(element)
	self:_unInit()
end

--@brief	点击关闭按钮回调
function WndAuctionIdentifyMain:onClickClose(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndAuctionIdentifyMain:_playAni(aniIndex, bLoop)
	local spineCircle = GetElement(self.m_root, "spineCircle_WndAuctionIdentifyMain", WZUISpine)
	aniIndex = aniIndex or 1
	bLoop = bLoop == true

	if spineCircle then 
		spineCircle:play(self.m_tClipAniName[aniIndex], bLoop)
	end
end

--@brief	更新鉴宝物品
function WndAuctionIdentifyMain:updateChooseUI1()
	self.m_tRewardList1Obj = {}
	local tcM2Reward = GetElement(self.m_root,"tcM2Reward_WndAuctionIdentifyMain",WZUITableContainer)
    tcM2Reward:cleanTable()
	for i=1,#self.m_tRewardList1Data do
        local cellElement,cellObj = CellGoodItem:createElement()
        cellElement:setTag(self.m_tRewardList1Data[i][1])
    	cellObj:setCellGoodLocalId(self.m_tRewardList1Data[i][3],self.m_tRewardList1Data[i][4],31)
        cellObj.m_tItem.rootNode = self.m_root
    	cellObj:setItemClickFun(self,self.onClickItem1)
    	if self.m_tRewardList1Data[i][5] == 1 then
	    	cellObj:showSelectedIcon(2)
    	else
	    	cellObj:removeGouIcon()
    	end
    	tcM2Reward:setCellElement(cellElement)
    	table.insert(self.m_tRewardList1Obj,cellObj)
	end

	--主界面鉴宝物品
	local conM1Item = GetElement(self.m_root,"conM1Item_WndAuctionIdentifyMain",WZUIContainer)
	conM1Item:removeAllChildrenWithCleanup(true)
	if self.m_nSureChoose1Index ~= nil then
		local cellElement,cellObj = CellGoodItem:createElement()
    	cellObj:setCellGoodLocalId(self.m_tRewardList1Data[self.m_nSureChoose1Index][3],self.m_tRewardList1Data[self.m_nSureChoose1Index][4],17)
    	cellObj:setItemClickFun(self,self.onClickItem2)
		conM1Item:addChild(cellElement)
	end
end

--@brief	点击选中的鉴宝物品
function WndAuctionIdentifyMain:onClickItem2(luaTable,tag,tData)
    WndItemInfo:showInfo(luaTable.m_root,self.m_root,1,tData,false)
end

--@brief	点击鉴宝物品
function WndAuctionIdentifyMain:onClickItem1(luaTable,tag,tData)
	--已鉴定过就不能再换鉴宝物品
	if self.m_tData.curRound > 0 then
		return
	end

	self.m_nWillChoose1value = tag
	self:updateChooseStatus1()
end

--@brief	点击鉴宝奖励选择状态
function WndAuctionIdentifyMain:updateChooseStatus1()
	for i=1,#self.m_tRewardList1Obj do
		if i == self:getRewardList1DataKey(self.m_nWillChoose1value) then
			self.m_tRewardList1Obj[i]:showSelectedIcon(2)
		else
	    	self.m_tRewardList1Obj[i]:removeGouIcon()
		end
	end
end

--@brief	点击确定按钮
function WndAuctionIdentifyMain:onClickM2Confirm()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    --已确定物品和选的物品一样时就不用再发协议
    local nRewardList1Key = self:getRewardList1DataKey(self.m_nWillChoose1value)
	if self.m_nSureChoose1Index and nRewardList1Key == self.m_nSureChoose1Index then
		GetElement(self.m_root,"conMain2_WndAuctionIdentifyMain",WZUIContainer):setVisible(false)
		return
	end

	--没选物品
    if self.m_nWillChoose1value == nil then
    	MsgBoxManager:showTipBox(LocalStrings.AUCTION_HOUSE_TEXT37[12])
    	return
    end 

	GetElement(self.m_root,"conMain2_WndAuctionIdentifyMain",WZUIContainer):setVisible(false)

	local opType = 3
	local sjson = json.encode({index=self.m_nWillChoose1value})
	ProtocolProcessorNewActivity:send_ACTIVITY2_JBActivityDo(opType, sjson)
end

--@brief	点击刷新按钮
function WndAuctionIdentifyMain:onClickM2Refresh()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local costId = self.m_tData.refreshCost1[1]
    local costNum = self.m_tData.refreshCost1[2]*self.m_tData.refreshCost1[3]^self.m_tData.refreshCost1[4]
	if not JudgeMoneyIsEnough(self.m_tData.refreshCost1[1], costNum, nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.clickSureRefresh2) then
		return 
	end

	self:clickSureRefresh2()
end

--@brief	确定刷新
function WndAuctionIdentifyMain:clickSureRefresh2()
	local opType = 2
	local sjson = json.encode({})
	ProtocolProcessorNewActivity:send_ACTIVITY2_JBActivityDo(opType, sjson)
end

--@brief	更新大奖奖励
function WndAuctionIdentifyMain:updateChooseUI2()
	self.m_tRewardList2Obj = {}
	local tcBigReward = GetElement(self.m_root,"tcBigReward_WndAuctionIdentifyMain",WZUITableContainer)
    tcBigReward:cleanTable()
	for i=1,#self.m_tRewardList2Data do
        local cellElement,cellObj = CellGoodItem:createElement()
        cellElement:setTag(self.m_tRewardList2Data[i][1])
        cellElement:setScale(0.8)
    	cellObj:setCellGoodLocalId(self.m_tRewardList2Data[i][3],self.m_tRewardList2Data[i][4],31)
        cellObj.m_tItem.rootNode = self.m_root
    	cellObj:setItemClickFun(self,self.onClickItem3)
    	tcBigReward:setCellElement(cellElement)
    	table.insert(self.m_tRewardList2Obj,cellObj)

		--显示限量
		if self.m_tRewardList2Data[i][5] > 0 and self.m_tRewardList2Data[i][6] > 0 then
			local nMaxLimit = self.m_tRewardList2Data[i][5]
			local nCurLimit = self.m_tRewardList2Data[i][7]
			local limit1 = self.m_tRewardList2Data[i][5] - self.m_tRewardList2Data[i][7]
			local limit2 = self.m_tRewardList2Data[i][6] - self.m_tRewardList2Data[i][8]
			if limit1 > limit2 then
				nMaxLimit = self.m_tRewardList2Data[i][6]
				nCurLimit = self.m_tRewardList2Data[i][8]
			end
			cellObj:_addNumLimit(LocalStrings.SHOP_LIMIT_TITLE..":"..nCurLimit.."/"..nMaxLimit)
		elseif self.m_tRewardList2Data[i][5] > 0 then
			local nMaxLimit = self.m_tRewardList2Data[i][5]
			local nCurLimit = self.m_tRewardList2Data[i][7]
			cellObj:_addNumLimit(LocalStrings.SHOP_LIMIT_TITLE..":"..nCurLimit.."/"..nMaxLimit)
		elseif self.m_tRewardList2Data[i][6] > 0 then
			local nMaxLimit = self.m_tRewardList2Data[i][6]
			local nCurLimit = self.m_tRewardList2Data[i][8]
			cellObj:_addNumLimit(LocalStrings.SHOP_LIMIT_TITLE..":"..nCurLimit.."/"..nMaxLimit)
		end
	end
end

--@brief	点击大奖奖励
function WndAuctionIdentifyMain:onClickItem3(luaTable,tag,tData)
	local tempIndex = self:getChooseBigRewardKey(tag)
	if tempIndex ~= 0 then
		table.remove(self.m_tChooseIndexList,tempIndex)
		luaTable:removeGouIcon()
	else
		--超出次数
		local value = math.floor(self.m_tData.totalTimes/self.m_tData.accumulateTimes)
		if #self.m_tChooseIndexList >= value then
			MsgBoxManager:showTipBox(LocalStrings.AUCTION_HOUSE_TEXT37[18])
			return
		end

		--已达限量
		for i=1,#self.m_tRewardList2Data do
			if self.m_tRewardList2Data[i][1] == tag then
				if self.m_tRewardList2Data[i][5] ~= -1 and self.m_tRewardList2Data[i][5] <= self.m_tRewardList2Data[i][7] then
					MsgBoxManager:showTipBox(LocalStrings.AUCTION_HOUSE_TEXT37[16])
					return
				elseif self.m_tRewardList2Data[i][6] ~= -1 and self.m_tRewardList2Data[i][6] <= self.m_tRewardList2Data[i][8] then
					MsgBoxManager:showTipBox(LocalStrings.AUCTION_HOUSE_TEXT37[17])
					return
				end
			end
		end

		table.insert(self.m_tChooseIndexList,tag)
		luaTable:showSelectedIcon(2)
	end
end

--@brief	点击刷新按钮
function WndAuctionIdentifyMain:onClickRefresh()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local opType = 5
	local sjson = json.encode({})
	ProtocolProcessorNewActivity:send_ACTIVITY2_JBActivityDo(opType, sjson)
end

--@brief	点击领取按钮
function WndAuctionIdentifyMain:onClickReceive()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if #self.m_tChooseIndexList == 0 then
		MsgBoxManager:showTipBox(LocalStrings.AUCTION_HOUSE_TEXT37[20])
		return
    end	

    local str = ""
    for i=1,#self.m_tChooseIndexList do
    	if i == 1 then
    		str = str .. self.m_tChooseIndexList[i]
		else
	    	str = str .. "," .. self.m_tChooseIndexList[i]
    	end
    end
	local opType = 6
	local sjson = json.encode({index=str})
	ProtocolProcessorNewActivity:send_ACTIVITY2_JBActivityDo(opType, sjson)
end

--@brief	更新界面
function WndAuctionIdentifyMain:updateUI()
	--消耗
	local imgCoin = GetElement(self.m_root,"imgCoin_WndAuctionIdentifyMain",WZUIImage)
	local txtCoin = GetElement(self.m_root,"txtCoin_WndAuctionIdentifyMain",WZUILabelTTF)
	local tempItem = GDatatab_item["id_"..self.m_tData.cost[1]]
	imgCoin:setFile(tempItem.icon)
	txtCoin:setText(self.m_tData.cost[2])

	--当前鉴宝值/最大鉴宝值
	local txtIdentifyTitle2 = GetElement(self.m_root,"txtIdentifyTitle2_WndAuctionIdentifyMain",WZUILabelTTF)
	local maxValue = self.m_tData.rate[tostring(GetTableLen(self.m_tData.rate))]
	local curValue = self.m_tData.curValue
	txtIdentifyTitle2:setText(curValue.."/"..maxValue)

	--倍数
	for i=1,GetTableLen(self.m_tData.rate) do
		local conMultiple = GetElement(self.m_root,"conMultiple"..i,WZUIContainer)
		local imgMultiple = GetElement(conMultiple,"imgMultiple",WZUIImage)
		local txtMultiple = GetElement(conMultiple,"txtMultiple",WZUILabelTTF)
		local txtIdentifyValue = GetElement(self.m_root,"txtIdentifyValue"..i.."_WndAuctionIdentifyMain",WZUILabelTTF)
		imgMultiple:setFile("ui/common/frame_pmh_02.png")

		txtMultiple:setText(string.format(LocalStrings.FOURYEAR_TEXT11,i))
		txtIdentifyValue:setText(self.m_tData.rate[tostring(i)])

		txtMultiple:setColor(GlobalMethod:ccc3(255,255,255))
		txtIdentifyValue:setColor(GlobalMethod:ccc3(255,255,255))
		if self.m_tData.curValue >= self.m_tData.rate[tostring(i)] then
			imgMultiple:setFile("ui/common/frame_pmh_01.png")
			txtMultiple:setColor(GlobalMethod:ccc3(255,236,193))
			txtIdentifyValue:setColor(GlobalMethod:ccc3(93,222,254))
		end
	end

	--这轮鉴定次数
	local ftbIdentifyDesc1 = GetElement(self.m_root,"ftbIdentifyDesc1_WndAuctionIdentifyMain",WZUIFreeTextBox)
	ftbIdentifyDesc1:setShowText(string.format(LocalStrings.AUCTION_HOUSE_TEXT38,self.m_tData.maxRounds,(self.m_tData.maxRounds-self.m_tData.curRound)))
	local txtCurrentValue = GetElement(self.m_root,"txtCurrentValue_WndAuctionIdentifyMain",WZUILabelTTF)
	txtCurrentValue:setText(LocalStrings.CHAT_CURRENT.."("..self.m_tData.curRound.."/"..self.m_tData.maxRounds..")")
	
	--自选次数
	local ftbIdentifyDesc2 = GetElement(self.m_root,"ftbIdentifyDesc2_WndAuctionIdentifyMain",WZUIFreeTextBox)
	local value1 = self.m_tData.totalTimes
	local value2 = self.m_tData.accumulateTimes
	local value3 = math.floor(self.m_tData.totalTimes/self.m_tData.accumulateTimes)
	local value4 = 1
	ftbIdentifyDesc2:setShowText(string.format(LocalStrings.AUCTION_HOUSE_TEXT39,value1,value2,value3,value4))

	--自选刷新消耗
    local costId = self.m_tData.refreshCost2[1]
    local costNum = self.m_tData.refreshCost2[2]*(self.m_tData.refreshCost2[3]^self.m_tData.refreshCost2[4])
	for i=1,3 do
		local imgRefreshCost = GetElement(self.m_root,"imgRefreshCost"..i.."_WndAuctionIdentifyMain",WZUIImage)
		local txtRefreshCost = GetElement(self.m_root,"txtRefreshCost"..i.."_WndAuctionIdentifyMain",WZUILabelTTF)
		local tempItem = GDatatab_item["id_"..costId]
		imgRefreshCost:setFile(tempItem.icon)
		txtRefreshCost:setText(costNum)
	end

	--选择鉴宝物品界面的刷新消耗
    local costId = self.m_tData.refreshCost1[1]
    local costNum = self.m_tData.refreshCost1[2]*(self.m_tData.refreshCost1[3]^self.m_tData.refreshCost1[4])
	for i=1,3 do
		local imgM2RefreshCost = GetElement(self.m_root,"imgM2RefreshCost"..i.."_WndAuctionIdentifyMain",WZUIImage)
		local txtM2RefreshCost = GetElement(self.m_root,"txtM2RefreshCost"..i.."_WndAuctionIdentifyMain",WZUILabelTTF)
		local tempItem = GDatatab_item["id_"..costId]
		imgM2RefreshCost:setFile(tempItem.icon)
		txtM2RefreshCost:setText(costNum)
	end

	--选择鉴宝物品界面
	local btnM2Confirm = GetElement(self.m_root,"btnM2Confirm_WndAuctionIdentifyMain",WZUIButton)
	local btnM2Refresh = GetElement(self.m_root,"btnM2Refresh_WndAuctionIdentifyMain",WZUIButton)
	if self.m_tData.curRound == 0 then --没有鉴定过
		btnM2Confirm:setTouchEnable(true)
		btnM2Refresh:setTouchEnable(true)
	else
		btnM2Confirm:setTouchEnable(false)
		btnM2Refresh:setTouchEnable(false)
	end

	--结算界面当前倍数
	local txtM3T1Rate = GetElement(self.m_root,"txtM3T1Rate_WndAuctionIdentifyMain",WZUILabelTTF)
	txtM3T1Rate:setText(string.format(LocalStrings.AUCTION_HOUSE_TEXT37[14],self:getCurRate()))

end

--@brief	点击切换鉴定次数按钮
function WndAuctionIdentifyMain:onClickSwitch(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self.m_nIdentifyNumIndex = self.m_nIdentifyNumIndex % #self.m_nIdentifyNumList + 1
    self:updateIdentifyBtn()
end

--@brief	点击鉴定按钮回调
function WndAuctionIdentifyMain:onClickIdentify(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    if self.m_bIsOpenBtn ~= true then
    	return
	end

    --未选择鉴宝物品
    if self.m_nSureChoose1Index == nil then
    	MsgBoxManager:showTipBox(LocalStrings.AUCTION_HOUSE_TEXT37[12])
    	return
    end

	--物品不足
	local ownNum = CacheCenter:getPlayerItemCountById(self.m_tData.cost[1])
	if ownNum < self.m_tData.cost[2] * self.m_nIdentifyNumList[self.m_nIdentifyNumIndex] then
		local basicData = GDatatab_item["id_" .. self.m_tData.cost[1]]
		MsgBoxManager:showConfirmBox(string.format(LocalStrings.WATERCOUNTRY_TEXT4, basicData.name), self, self.goToBuy)
		return 
	end

	self.m_bIsOpenBtn = false

	self:clickSureIdentify()
end

--@brief 	前往小推车购买
function WndAuctionIdentifyMain:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

--@brief	确定鉴定
function WndAuctionIdentifyMain:clickSureIdentify()
	local opType = 1
	local sjson = json.encode({type=self.m_nIdentifyNumIndex})
	ProtocolProcessorNewActivity:send_ACTIVITY2_JBActivityDo(opType, sjson)
end

--@brief	更新鉴定次数按钮
function WndAuctionIdentifyMain:updateIdentifyBtn()
	local txtBtnIdentify = GetElement(self.m_root,"txtBtnIdentify_WndAuctionIdentifyMain",WZUILabelTTF)
	txtBtnIdentify:setText(string.format(LocalStrings.AUCTION_HOUSE_TEXT37[3],self.m_nIdentifyNumList[self.m_nIdentifyNumIndex]))
end

--@brief	点击规则按钮
function WndAuctionIdentifyMain:onClickRule(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndAuctionIdentifyRule:showInterface(LocalStrings.AUCTION_HOUSE_TEXT40)
end

--@brief	点击奖励选择按钮
function WndAuctionIdentifyMain:onClickChooseReward(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	self.m_nWillChoose1value = nil
	if self.m_nSureChoose1Index ~= nil then
		self.m_nWillChoose1value = self.m_tRewardList1Data[self.m_nSureChoose1Index][1]
	end
	self:updateChooseStatus1()

	GetElement(self.m_root,"conMain2_WndAuctionIdentifyMain",WZUIContainer):setVisible(true)
end

--@brief	关闭选择奖励界面按钮回调
function WndAuctionIdentifyMain:onClickCloseChoose(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	GetElement(self.m_root,"conMain2_WndAuctionIdentifyMain",WZUIContainer):setVisible(false)
end

--@brief	点击打开结算界面按钮回调
function WndAuctionIdentifyMain:onClickSettlement(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    --未选择鉴宝物品
    if self.m_nSureChoose1Index == nil then
    	MsgBoxManager:showTipBox(LocalStrings.AUCTION_HOUSE_TEXT37[12])
    	return
    end

    --未鉴定过
    if self.m_tData.curRound == 0 then
    	MsgBoxManager:showTipBox(LocalStrings.AUCTION_HOUSE_TEXT37[7])
    	return
    end

	self.m_bNotRemind = false

	local conMain3 = GetElement(self.m_root,"conMain3_WndAuctionIdentifyMain",WZUIContainer)
	local conM3Type1 = GetElement(self.m_root,"conM3Type1_WndAuctionIdentifyMain",WZUIContainer)
	local conM3Type2 = GetElement(self.m_root,"conM3Type2_WndAuctionIdentifyMain",WZUIContainer)
	conM3Type1:setVisible(false)
	conM3Type2:setVisible(false)
	if self.m_tData.curRound < self.m_tData.maxRounds and not judgeHavedRecordString(self.m_sNotRemindContent) then
		conMain3:setVisible(true)
		conM3Type1:setVisible(true)
	else
		self:sureSettlement()
	end
end

--@brief	点击不在提示按钮回调
function WndAuctionIdentifyMain:onClickM3T1NotRemind(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    element = WZUICheckBox:luaTo(element)
    local chekcIndex = element:getCheckIndex()
    if chekcIndex == 1 then
    	self.m_bNotRemind = true
	else
		self.m_bNotRemind = false
	end
end

--@brief	点击确定结算按钮回调
function WndAuctionIdentifyMain:onClickM3T1Confirm(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_bNotRemind == true then
    	judgeHavedRecordString(self.m_sNotRemindContent,true)
	end
	self:sureSettlement()
end

--@brief	确定结算
function WndAuctionIdentifyMain:sureSettlement()
	local conMain3 = GetElement(self.m_root,"conMain3_WndAuctionIdentifyMain",WZUIContainer)
	conMain3:setVisible(false)

	local opType = 7
	local sjson = json.encode({})
	ProtocolProcessorNewActivity:send_ACTIVITY2_JBActivityDo(opType, sjson)
end

--@brief	点击关闭结算界面按钮回调
function WndAuctionIdentifyMain:onClickCloseSettlement(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	GetElement(self.m_root,"conMain3_WndAuctionIdentifyMain",WZUIContainer):setVisible(false)
end

--@brief	显示结算奖励
function WndAuctionIdentifyMain:showSettlementReward(itemIds,nums,rate)
	local conMain3 = GetElement(self.m_root,"conMain3_WndAuctionIdentifyMain",WZUIContainer)
	local conM3Type1 = GetElement(self.m_root,"conM3Type1_WndAuctionIdentifyMain",WZUIContainer)
	local conM3Type2 = GetElement(self.m_root,"conM3Type2_WndAuctionIdentifyMain",WZUIContainer)
	conMain3:setVisible(true)
	conM3Type1:setVisible(false)
	conM3Type2:setVisible(true)

	local conM3T2Items = GetElement(self.m_root,"conM3T2Items_WndAuctionIdentifyMain",WZUIContainer)
	conM3T2Items:removeAllChildrenWithCleanup(true)
	for i=1,#itemIds do
        local cellElement,cellObj = CellGoodItem:createElement()
        cellElement:setTag(i-1)
    	cellObj:setCellGoodLocalId(itemIds[i],nums[i],17)
    	cellObj:setItemClickFun(self,self.onClickItem4)
    	conM3T2Items:addChild(cellElement)
    	cellElement:setRelativePosition(GlobalMethod:ccp(0.14+0.24*(i-1),0.5))
	end
	conM3T2Items:setRelativePosition(GlobalMethod:ccp(0.98-0.12*(#itemIds),0.5))

	local ftbM3T2Desc = GetElement(self.m_root,"ftbM3T2Desc_WndAuctionIdentifyMain",WZUIFreeTextBox)
	ftbM3T2Desc:setShowText(string.format(LocalStrings.AUCTION_HOUSE_TEXT41,rate))
end

--@brief	点击结算的奖励
function WndAuctionIdentifyMain:onClickItem4(luaTable,tag,tData)
    WndItemInfo:showInfo(luaTable.m_root,self.m_root,1,tData,false)
end

--@brief	显示鉴定动画
function WndAuctionIdentifyMain:showIdentifyAnimal()
	self:_playAni(2, false)

	local spineCircle = GetElement(self.m_root, "spineCircle_WndAuctionIdentifyMain", WZUISpine)
	spineCircle:enableSchedule("scheduleIdentify",1.2)
end

--@brief	计时器
function WndAuctionIdentifyMain:scheduleIdentify(element)
	element:disableSchedule()
	self:_playAni(1, true)

	MsgBoxManager:showTipBox(LocalStrings.AUCTION_HOUSE_TEXT37[24])

	self.m_bIsOpenBtn = true

	if self.m_tRewardList.itemIds and #self.m_tRewardList.itemIds > 0 and self.m_tRewardList.nums and #self.m_tRewardList.nums > 0 then
		self:showSettlementReward(self.m_tRewardList.itemIds, self.m_tRewardList.nums, self.m_tRewardList.rate)

		--清除选择鉴宝物品
		for i=1,#self.m_tRewardList1Data do
			self.m_tRewardList1Data[i][5] = 0
		end
		self.m_nSureChoose1Index = nil
		self.m_nWillChoose1value = nil
		self:updateChooseUI1()
	end

	local opType = 9
	local sjson = json.encode({})
	ProtocolProcessorNewActivity:send_ACTIVITY2_JBActivityDo(opType, sjson)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


--@brief	初始化静态文本
function WndAuctionIdentifyMain:_initStaticText()
	GetElement(self.m_root,"txtIdentifyTitle1_WndAuctionIdentifyMain",WZUILabelTTF):setText(LocalStrings.AUCTION_HOUSE_TEXT37[2])
	GetElement(self.m_root,"txtRewardTitle_WndAuctionIdentifyMain",WZUILabelTTF):setText(LocalStrings.AUCTION_HOUSE_TEXT37[4])

	GetElement(self.m_root,"txtM2RewardTitle_WndAuctionIdentifyMain",WZUILabelTTF):setText(LocalStrings.AUCTION_HOUSE_TEXT37[10])
	GetElement(self.m_root,"txtM2RewardDesc_WndAuctionIdentifyMain",WZUILabelTTF):setText(LocalStrings.AUCTION_HOUSE_TEXT37[11])

	GetElement(self.m_root,"txtM3T1Title_WndAuctionIdentifyMain",WZUILabelTTF):setText(LocalStrings.LZTQ_TEXT1[18])
	GetElement(self.m_root,"txtM3T1Desc_WndAuctionIdentifyMain",WZUILabelTTF):setText(LocalStrings.AUCTION_HOUSE_TEXT37[13])
	GetElement(self.m_root,"txtM3T1Tips_WndAuctionIdentifyMain",WZUILabelTTF):setText(LocalStrings.NOMORETIP)

	GetElement(self.m_root,"txtM3T2Title_WndAuctionIdentifyMain",WZUILabelTTF):setText(LocalStrings.AUCTION_HOUSE_TEXT37[15])

	self:_setBallAni()
end

--@brief 	设置待机特效
function WndAuctionIdentifyMain:_setBallAni()
	local spinePath = "activity/hd_pic_jianbao"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		local spineOpen = GetElement(self.m_root, "spineCircle_WndAuctionIdentifyMain", WZUISpine)
		if spineOpen then 
			spineOpen:setFileJson(spinePath .. ".json")
			spineOpen:setFileAtlas(spinePath .. ".atlas")
			self:_playAni(1, true)
		end
	end
end
-------------------------------------私有方法模块End----------------------------------------


function WndAuctionIdentifyMain:_adaptLanguage_vn()
	local txtIdentifyTitle1 = GetElement(self.m_root,"txtIdentifyTitle1_WndAuctionIdentifyMain",WZUILabelTTF)
	txtIdentifyTitle1:setDimensions(GlobalMethod:CCSize(80,0))
	txtIdentifyTitle1:setScale(0.7)

	local ftbIdentifyDesc1 = GetElement(self.m_root,"ftbIdentifyDesc1_WndAuctionIdentifyMain",WZUIFreeTextBox)
	ftbIdentifyDesc1:setMaxWidth(250)
	ftbIdentifyDesc1:setScale(0.7)

	GetElement(self.m_root,"txtCurrentValue_WndAuctionIdentifyMain",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,0.05))

	GetElement(self.m_root,"txtBtnIdentify_WndAuctionIdentifyMain",WZUILabelTTF):setScale(0.8)

	GetElement(self.m_root,"txtM3T1Desc_WndAuctionIdentifyMain",WZUILabelTTF):setFontSize(16)
	local txtM3T1Tips = GetElement(self.m_root,"txtM3T1Tips_WndAuctionIdentifyMain",WZUILabelTTF)
	txtM3T1Tips:setFontSize(14)
	txtM3T1Tips:setRelativePosition(GlobalMethod:ccp(0.66,0.5))
end