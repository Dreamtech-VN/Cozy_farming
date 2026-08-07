--CellAuctionHouse.lua
--@brief	CellAuctionHouse的UI模块
--@date		2020/08/03
--@author	yrd
--@note		拍卖行活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellAuctionHouse:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
	ProtocolProcessorGlobal:send_CHAT_ChangeChannel(Chat_Channel_AUCTION_HOUSE)
	self:_initStaticText()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellAuctionHouse:onExit(element)
	self:_unInit()
end

function CellAuctionHouse:showWindow()
	self:_initTimeText()
	self:updateUI()
end

function CellAuctionHouse:updateUI()
	--活动状态
	if self.m_status == -1 then
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END)
		-- return
	elseif self.m_status == 0 then
		-- local auctionStartTime = CacheCenter:getGameParam()["auctionStartTime"]
		-- local tTempTime = SplitStringWithSeparator(auctionStartTime, "-")
		local tTempTime = SplitStringWithSeparator(self.m_auctionStartTime, "-")
		MsgBoxManager:showTipBox(string.format(LocalStrings.AUCTION_HOUSE_TEXT28,tTempTime[1]))
		-- return
	elseif self.m_status == 2 then
		MsgBoxManager:showTipBox(LocalStrings.AUCTION_HOUSE_TEXT29)
		-- return
	end

    local tCurrencyInfo = GDatatab_item["id_"..self.m_currencyId]

    --当前拍卖品
    local nAuctionNum = self.m_auction == 0 and 1 or self.m_auction
    local tCurAuction = SplitStringToTable(self.m_auctions[nAuctionNum])

	--拍卖品
	local conItem = GetElement(self.m_root,"conItem_CellAuctionHouse",WZUIContainer)
	conItem:removeAllChildrenWithCleanup(true)
	local celElement,tLuaObj = CellGoodItem:createElement()
	if celElement ~= nil and tLuaObj ~= nil then
		tLuaObj:setCellGoodLocalId(tCurAuction[1], tCurAuction[2], 4)
		tLuaObj:setBackImgFile2()
		tLuaObj:setItemClickFun(self,self.onClickItem)
		conItem:addChild(celElement)
	end
 
 	--拍卖品名
	local tItemInfo = GDatatab_item["id_"..tCurAuction[1]]
	local txtItemName = GetElement(self.m_root,"txtItemName_CellAuctionHouse",WZUILabelTTF)
	txtItemName:setText(tItemInfo.name)

 	--拍卖数
	local txtNumberAuctions1 = GetElement(self.m_root,"txtNumberAuctions1_CellAuctionHouse",WZUILabelTTF)
	txtNumberAuctions1:setText(LocalStrings.AUCTION_HOUSE_TEXT1)
	local txtNumberAuctions2 = GetElement(self.m_root,"txtNumberAuctions2_CellAuctionHouse",WZUILabelTTF)
	txtNumberAuctions2:setText(tCurAuction[2]==-1 and 1 or tCurAuction[2])

 	--起拍价
	local txtStartingPrice1 = GetElement(self.m_root,"txtStartingPrice1_CellAuctionHouse",WZUILabelTTF)
	txtStartingPrice1:setText(LocalStrings.AUCTION_HOUSE_TEXT2)
	local txtStartingPrice2 = GetElement(self.m_root,"txtStartingPrice2_CellAuctionHouse",WZUILabelTTF)
	txtStartingPrice2:setText(self.m_initPrice)

	--拍卖总时长
	local txtTotalAuctionTime1 = GetElement(self.m_root,"txtTotalAuctionTime1_CellAuctionHouse",WZUILabelTTF)
	txtTotalAuctionTime1:setText(LocalStrings.AUCTION_HOUSE_TEXT3)
	local txtTotalAuctionTime2 = GetElement(self.m_root,"txtTotalAuctionTime2_CellAuctionHouse",WZUILabelTTF)
	txtTotalAuctionTime2:setText(self:getFormatTime(self.m_totalTime))
    txtTotalAuctionTime2:enableSchedule("_updateAcutionTime",1)

	--第几件拍品
	local txtManyAuction = GetElement(self.m_root,"txtManyAuction_CellAuctionHouse",WZUILabelTTF)
	txtManyAuction:setText(string.format(LocalStrings.AUCTION_HOUSE_TEXT17, LocalStrings.AUCTION_HOUSE_TEXT16[nAuctionNum]))

	--当前出价
	local txtCurrentOffer1 = GetElement(self.m_root,"txtCurrentOffer1_CellAuctionHouse",WZUILabelTTF)
	txtCurrentOffer1:setText(LocalStrings.AUCTION_HOUSE_TEXT4)
	local txtCurrentOffer2 = GetElement(self.m_root,"txtCurrentOffer2_CellAuctionHouse",WZUILabelTTF)
	txtCurrentOffer2:setText(self.m_price)

	--出价人
	local txtBidder1 = GetElement(self.m_root,"txtBidder1_CellAuctionHouse",WZUILabelTTF)
	txtBidder1:setText(LocalStrings.AUCTION_HOUSE_TEXT18)
	local txtBidder2 = GetElement(self.m_root,"txtBidder2_CellAuctionHouse",WZUILabelTTF)
	txtBidder2:setText(self.m_name=="" and LocalStrings.WNDCHECKOTHER46 or self.m_name)

	--剩余时间
	local txtBiddingCountdown1 = GetElement(self.m_root,"txtBiddingCountdown1_CellAuctionHouse",WZUILabelTTF)
	txtBiddingCountdown1:setText(LocalStrings.AUCTION_HOUSE_TEXT19)
	local txtBiddingCountdown2 = GetElement(self.m_root,"txtBiddingCountdown2_CellAuctionHouse",WZUILabelTTF)
	txtBiddingCountdown2:setText(self:getFormatTime(self.m_time>0 and self.m_time or 0))
    -- txtBiddingCountdown2:enableSchedule("_updateAcutionTime",1)
    
    --我的竞拍币
	local txtMyAuctionCurrency1 = GetElement(self.m_root,"txtMyAuctionCurrency1_CellAuctionHouse",WZUILabelTTF)
	txtMyAuctionCurrency1:setText(LocalStrings.AUCTION_HOUSE_TEXT5)
	local txtMyAuctionCurrency2 = GetElement(self.m_root,"txtMyAuctionCurrency2_CellAuctionHouse",WZUILabelTTF)
	txtMyAuctionCurrency2:setText(CacheCenter:getPlayerItemCountById(self.m_currencyId))

    --加价
	local imgCoin1 = GetElement(self.m_root,"imgCoin1_CellAuctionHouse",WZUIImage)
	local imgCoin2 = GetElement(self.m_root,"imgCoin2_CellAuctionHouse",WZUIImage)
	local imgCoin3 = GetElement(self.m_root,"imgCoin3_CellAuctionHouse",WZUIImage)
	imgCoin1:setFile(tCurrencyInfo.icon)
	imgCoin2:setFile(tCurrencyInfo.icon)
	imgCoin3:setFile(tCurrencyInfo.icon)
	local txtCoin1 = GetElement(self.m_root,"txtCoin1_CellAuctionHouse",WZUILabelTTF)
	local txtCoin2 = GetElement(self.m_root,"txtCoin2_CellAuctionHouse",WZUILabelTTF)
	local txtCoin3 = GetElement(self.m_root,"txtCoin3_CellAuctionHouse",WZUILabelTTF)
	local nPrice1 = self.m_name=="" and self.m_price or math.ceil(self.m_price*(1+self.m_markupRate[1]))
	local nPrice2 = math.ceil(self.m_price*(1+self.m_markupRate[2]))
	local nPrice3 = math.ceil(self.m_price*(1+self.m_markupRate[3]))
	txtCoin1:setText(nPrice1)
	txtCoin2:setText(nPrice2)
	txtCoin3:setText(nPrice3)

	--加价按钮字
	local txtBtn1_1 = GetElement(self.m_root,"txtBtn1_1_CellAuctionHouse",WZUILabelTTF)
	local txtBtn1_2 = GetElement(self.m_root,"txtBtn1_2_CellAuctionHouse",WZUILabelTTF)
	local txtBtn1_3 = GetElement(self.m_root,"txtBtn1_3_CellAuctionHouse",WZUILabelTTF)
	local txtBtn2_1 = GetElement(self.m_root,"txtBtn2_1_CellAuctionHouse",WZUILabelTTF)
	local txtBtn2_2 = GetElement(self.m_root,"txtBtn2_2_CellAuctionHouse",WZUILabelTTF)
	local txtBtn2_3 = GetElement(self.m_root,"txtBtn2_3_CellAuctionHouse",WZUILabelTTF)
	local txtBtn3_1 = GetElement(self.m_root,"txtBtn3_1_CellAuctionHouse",WZUILabelTTF)
	local txtBtn3_2 = GetElement(self.m_root,"txtBtn3_2_CellAuctionHouse",WZUILabelTTF)
	local txtBtn3_3 = GetElement(self.m_root,"txtBtn3_3_CellAuctionHouse",WZUILabelTTF)
	local strBtnPrice1 = self.m_name=="" and LocalStrings.AUCTION_HOUSE_TEXT21 or LocalStrings.AUCTION_HOUSE_TEXT20..(self.m_markupRate[1]*100).."%"
	local strBtnPrice2 = LocalStrings.AUCTION_HOUSE_TEXT20..(self.m_markupRate[2]*100).."%"
	local strBtnPrice3 = LocalStrings.AUCTION_HOUSE_TEXT20..(self.m_markupRate[3]*100).."%"
	txtBtn1_1:setText(strBtnPrice1)
	txtBtn1_2:setText(strBtnPrice1)
	txtBtn1_3:setText(strBtnPrice1)
	txtBtn2_1:setText(strBtnPrice2)
	txtBtn2_2:setText(strBtnPrice2)
	txtBtn2_3:setText(strBtnPrice2)
	txtBtn3_1:setText(strBtnPrice3)
	txtBtn3_2:setText(strBtnPrice3)
	txtBtn3_3:setText(strBtnPrice3)

	--加价按钮
	self:updateBtnStatus()
	-- local btnBid1 = GetElement(self.m_root,"btnBid1_CellAuctionHouse",WZUIButton)
	-- local btnBid2 = GetElement(self.m_root,"btnBid2_CellAuctionHouse",WZUIButton)
	-- local btnBid3 = GetElement(self.m_root,"btnBid3_CellAuctionHouse",WZUIButton)
	-- btnBid1:setLuaActionName("Normal")
	-- btnBid2:setLuaActionName("Normal")
	-- btnBid3:setLuaActionName("Normal")
	-- btnBid1:setTouchEnable(true)
	-- btnBid2:setTouchEnable(self.m_name~="")
	-- btnBid3:setTouchEnable(self.m_name~="")	

	--本周竞拍王
	local txtAuctionKing = GetElement(self.m_root,"txtAuctionKing_CellAuctionHouse",WZUILabelTTF)
	txtAuctionKing:setText(self.m_weekName=="" and LocalStrings.WNDCHECKOTHER46 or self.m_weekName)

	--竞拍王奖励
    local conAuctionKingReward = GetElement(self.m_root,"conAuctionKingReward_CellAuctionHouse",WZUITableContainer)
	local auctionGift = CacheCenter:getGameParam().auctionGift
    local ids, nums = SplitItemString(auctionGift)
    for i=1,#ids do
    	local celElement,tLuaObj = CellGoodItem:createElement()
    	celElement:setTag(i-1)
		tLuaObj:setCellGoodLocalId(tonumber(ids[i]), tonumber(nums[i]), 4)
		tLuaObj:setBackImgFile2()
		tLuaObj:setItemClickFun(self,self.onClickKingItem)
		conAuctionKingReward:setCellElement(celElement)
    end

    --出价记录
    local tconBidRecord = GetElement(self.m_root,"tconBidRecord_CellAuctionHouse",WZUITableContainer)
    tconBidRecord:cleanTable()
    for i=1,#self.m_bidInfo do
		local conLog = WZUIContainer:create()
		conLog = WZUIContainer:luaTo(conLog)
        conLog:setTag(i-1)
        conLog:setUseAbsSize(true)
        conLog:setAbsContentSize(GlobalMethod:CCSize(320,24))
        tconBidRecord:setCellElement(conLog)
        local ftbLog = WZUIFreeTextBox:create()
        ftbLog:setAnchorPoint(GlobalMethod:ccp(0,0.5))
        ftbLog:setRelativePosition(GlobalMethod:ccp(0.0375,0.5))
		ftbLog:setMaxWidth(500)
		local strFormat = [[<T C="127,70,26" S="20">%s</T>]]
		ftbLog:setShowText(string.format(strFormat, self.m_bidInfo[i]))
		conLog:addChild(ftbLog)
	end
	tconBidRecord:getMoveElement():setPositionY(tconBidRecord:getMinPosition().y)

	--按钮
	local btnRank = GetElement(self.m_root,"btnRank_CellAuctionHouse",WZUIButton)
	btnRank:setLuaActionName("Normal")
	local btnStore = GetElement(self.m_root,"btnStore_CellAuctionHouse",WZUIButton)
	btnStore:setLuaActionName("Normal")

end

--刷新硬币数
function CellAuctionHouse:updateCoinNum()
	local txtMyAuctionCurrency2 = GetElement(self.m_root,"txtMyAuctionCurrency2_CellAuctionHouse",WZUILabelTTF)
	txtMyAuctionCurrency2:setText(CacheCenter:getPlayerItemCountById(self.m_currencyId))
end

function CellAuctionHouse:updateBtnStatus()
	--加价按钮
    local btnBid1 = GetElement(self.m_root,"btnBid1_CellAuctionHouse",WZUIButton)
    local btnBid2 = GetElement(self.m_root,"btnBid2_CellAuctionHouse",WZUIButton)
    local btnBid3 = GetElement(self.m_root,"btnBid3_CellAuctionHouse",WZUIButton)
    btnBid1:setLuaActionName("Normal")
	btnBid2:setLuaActionName("Normal")
	btnBid3:setLuaActionName("Normal")
	if self.m_status == 1 then
		btnBid1:setTouchEnable(true)
		btnBid2:setTouchEnable(self.m_name~="")
		btnBid3:setTouchEnable(self.m_name~="")
	else
		btnBid1:setTouchEnable(false)
		btnBid2:setTouchEnable(false)
		btnBid3:setTouchEnable(false)
	end
end

function CellAuctionHouse:getFormatTime(time)
	local min = math.floor(time/60)
	local sec = time%60
	local strTime = string.format("%s:%s",min,sec)
	return strTime
end

-- 点击获取按钮
function CellAuctionHouse:onClickObtain(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndAuctionCurrencyObtain:showInterface(1)
end

--今日拍品
function CellAuctionHouse:onSeeAuction(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndAuctionRank:showInterface(2,self.m_auctions)
end

--鉴宝
function CellAuctionHouse:onClickIdentify(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WndAuctionIdentifyMain:showInterface()
end

--竞拍榜
function CellAuctionHouse:onClickRank(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndAuctionRank:showInterface(1)
end

--拍卖行商店
function CellAuctionHouse:onClickStore(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndAuctionStore:showInterface()
end

-- 点击拍卖品回调
function CellAuctionHouse:onClickKingItem(tItem, nTag, tData)
    if self.m_root == nil then return end
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData, false)
end

-- 点击拍卖之王奖励回调
function CellAuctionHouse:onClickItem(tItem, nTag, tData)
    if self.m_root == nil then return end
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData, false)
end

-- 竞拍倒计时
function CellAuctionHouse:_updateAcutionTime(element)
	local txtTotalAuctionTime2 = GetElement(self.m_root,"txtTotalAuctionTime2_CellAuctionHouse",WZUILabelTTF)
	local txtBiddingCountdown2 = GetElement(self.m_root,"txtBiddingCountdown2_CellAuctionHouse",WZUILabelTTF)

	self.m_totalTime = self.m_totalTime - 1
	if self.m_totalTime <= 0 then
		self.m_totalTime = 0

		txtTotalAuctionTime2:disableSchedule()
        MsgBoxManager:showTipBox(LocalStrings.AUCTION_HOUSE_TEXT29)
		self.m_status = 2
		self:updateBtnStatus()
	end
	txtTotalAuctionTime2:setText(self:getFormatTime(self.m_totalTime))

	self.m_time = self.m_time - 1
	if self.m_time <= 0 then
		self.m_time = 0
	end
	txtBiddingCountdown2:setText(self:getFormatTime(self.m_time))
end

function CellAuctionHouse:onPriceMarkup(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_status ~= 1 then
		MsgBoxManager:showTipBox(LocalStrings.AUCTION_HOUSE_TEXT28)
		return
	end

	if self.m_nBtnCDStatus == true then
		MsgBoxManager:showTipBox(LocalStrings.AUCTION_HOUSE_TEXT36)
		return
	end

	self.m_nBtnCDStatus = true
	element:enableSchedule("_scheduleBtnCD",0.2)

	local tag = element:getTag()

	local price = {}
	price[1] = self.m_name=="" and self.m_price or math.ceil(self.m_price*(1+self.m_markupRate[1]))
	price[2] = math.ceil(self.m_price*(1+self.m_markupRate[2]))
	price[3] = math.ceil(self.m_price*(1+self.m_markupRate[3]))

    --物品不足
	local ownNum = CacheCenter:getPlayerItemCountById(self.m_currencyId)
	if ownNum < price[tag] then
		local basicData = GDatatab_item["id_" .. self.m_currencyId]
		MsgBoxManager:showConfirmBox(string.format(LocalStrings.WATERCOUNTRY_TEXT4, basicData.name), self, self.goToBuy)
		return 
	end

    if JudgeMoneyIsEnough(self.m_currencyId, price[tag], LocalStrings.AUCTION_HOUSE_TEXT24, nil, Chat_Channel_AUCTION_HOUSE) then
        local bType = 0
        if self.m_name=="" then
        	bType = 0
        else
        	bType = tag
        end
		ProtocolProcessorNewActivity:send_ACTIVITY2_Bid(self.m_auction, bType, self.m_price)
    end
end

--@brief 	前往小推车购买
function CellAuctionHouse:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

function CellAuctionHouse:_scheduleBtnCD(element)
	self.m_nBtnCDStatus = false
	element:disableSchedule()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------



--@brief 	初始化UI文本
function CellAuctionHouse:_initTimeText()
	local txtTimeWords = GetElement(self.m_root, "txtTimeWords_CellAuctionHouse", WZUILabelTTF)
	if txtTimeWords then
		txtTimeWords:setText(LocalStrings.ACTIVITY_TIME_KEY..":")
	end

	local DayStartTab = os.date("*t", self.m_startTime)
	local DayEndTab = os.date("*t", self.m_endTime)

	local timeFormat = "%d-%02d-%02d %d-%02d-%02d"

    local format_txt_value = string.format(timeFormat, DayStartTab.year, DayStartTab.month, DayStartTab.day, DayEndTab.year, DayEndTab.month, DayEndTab.day)
    local txtTimeValue = GetElement(self.m_root, "txtTimeValue_CellAuctionHouse", WZUILabelTTF)
	if txtTimeValue then
		txtTimeValue:setText(format_txt_value)
	end 
end

--@brief 	初始化静态文本
function CellAuctionHouse:_initStaticText()
	local txtIdentify = GetElement(self.m_root,"txtIdentify_CellAuctionHouse",WZUILabelTTF)
	txtIdentify:setText(LocalStrings.AUCTION_HOUSE_TEXT37[1])
end

-------------------------------------私有方法模块End----------------------------------------


function CellAuctionHouse:_adaptLanguage_vn()
	local btnSearch = GetElement(self.m_root,"btnSearch",WZUIButton)
    if btnSearch then
        btnSearch:setRelativePosition(GlobalMethod:ccp(0.78,0.877))
    end
    GetElement(self.m_root,"txtBiddingCountdown1_CellAuctionHouse",WZUILabelTTF):setScale(0.9)
    for i=1,3 do
    	local txtBtn2 = GetElement(self.m_root,"txtBtn2_"..i.."_CellAuctionHouse",WZUILabelTTF)
    	txtBtn2:setScale(0.7)
    	local txtBtn3 = GetElement(self.m_root,"txtBtn3_"..i.."_CellAuctionHouse",WZUILabelTTF)
    	txtBtn3:setScale(0.7)
    end
	GetElement(self.m_root,"txtItemName_CellAuctionHouse",WZUILabelTTF):setScale(0.7)
end