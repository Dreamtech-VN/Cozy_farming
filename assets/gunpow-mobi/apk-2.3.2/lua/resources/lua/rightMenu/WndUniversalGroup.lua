--WndUniversalGroup.lua
--@brief	WndUniversalGroup 的UI模块
--@date		2020/05/26
--@author	XTX
--@note		全民团购界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndUniversalGroup:onEnter(element)
	self.m_root = element

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndUniversalGroup:onExit(element)
	self:_unInit()
end

--@brief 	显示
function WndUniversalGroup:showWindow()
	-- body
	if self.m_root == nil then return end 
	
	self:_initUIText()
	self:_updateCountAndProgress()
	self:showRechargePoint()
	WZLog("WndUniversalGroup:showWindow33")
end

--@brief 	点击宝箱回调
function WndUniversalGroup:onClickBox(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nTag = element:getTag()
	local tData = self.m_tBoxData[nTag]

	if tData.status == 0 then 
		--领取宝箱奖励
        ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(self.m_nActivityId, tData.rewardId)
	else
		--弹宝箱tips
		local rewardData = {}
        rewardData.coinId = tData.coinId
        rewardData.nType = 6
        rewardData.strartNum = self.m_nCount
        rewardData.endNum = tData.target
        rewardData.icon = {}
        rewardData.id = {}
        rewardData.num = {}
        for i = 1, #tData.reward do
            local icon = GDatatab_item["id_" .. tData.reward[i][1]].icon
            table.insert(rewardData.icon, icon)
            table.insert(rewardData.id, tData.reward[i][1])
            table.insert(rewardData.num, tData.reward[i][2])
        end
        WndTips:show(element, self.m_root, 3, rewardData, GlobalMethod:ccp(120,60))
        WndTips.m_root:setShowAll(true)
	end
end

--@brief    点击规则按钮回调
function WndUniversalGroup:onClickInfo(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local nTag = element:getTag()
    if nTag == 1 then 
    	WndSingleMapDesc:showInterface1(LocalStrings.FOURYEAR_TEXT3) 
    elseif nTag == 2 then 
    	WndSingleMapDesc:showInterface1(LocalStrings.FOURYEAR_TEXT4) 
    end
end

--@brief 	点击购买、领取按钮回调
function WndUniversalGroup:onClickBuy(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	local tData = self.m_tRewardData[nTag]
	if tData.status == -1 then 
		WndGameActivity:_createLoading()

        PostPlayerEvent:postEvent(PostPlayerEvent.event_clickPay)
        local sdkData = {}
        local vipData = GDatatab_recharge["id_" .. tData.rechargeId]
        WZLog("WndUniversalGroup:onClickBuy:")
        sdkData.id = tData.rechargeId
        sdkData.price = vipData.price
        sdkData.productName = tostring(vipData.name)
        sdkData.payCode = GetPayCodeIdByChannelId(vipData)
        sdkData.quantifier = LocalStrings.SHOP_IND
        sdkData.number = "1"
        sdkData.giftNumber = "0"
        sdkData.productDesc = tostring(vipData.name)

        PassportSdkManager:getOrderNum(sdkData)
	elseif tData.status == 0 then 
		--领取奖励
		WndGameActivity:_createLoading()
		ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(self.m_nActivityId, tData.rewardId)
	end
end

--@brief 	点击物品回调
function WndUniversalGroup:clickItemBack(luaTable, tag, tData)
	-- body
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(luaTable.m_root, self.m_root, 1, tData, false)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	初始化UI文本
function WndUniversalGroup:_initUIText()
	-- body
	if self.m_root == nil then return end 

	local txtTimeWords = GetElement(self.m_root, "txtTimeWords_WndUniversalGroup", WZUILabelTTF)
	if txtTimeWords then 
		txtTimeWords:setText(LocalStrings.ACTIVITY_TIME_KEY .. ":")
		txtTimeWords:setFontSize(18)
	end
	local todayBuyNumber = GetElement(self.m_root, "todayBuyNumber", WZUILabelTTF)
	if not todayBuyNumber then return end
	
	todayBuyNumber:setText(LocalStrings.NEW_ACTIVITY_TEXT_2)
	todayBuyNumber:setFontSize(18)
	local todayBuyNumber1 = GetElement(self.m_root, "todayBuyNumber1", WZUILabelTTF)
	todayBuyNumber1:setText(LocalStrings.SPACE8)
	todayBuyNumber1:setFontSize(18)
	
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtTimeValue = GetElement(self.m_root, "txtTimeValue_WndUniversalGroup", WZUILabelTTF)
    if txtTimeValue then 
    	txtTimeValue:setText(needDay_str)
    	txtTimeValue:setFontSize(18)
    end
end

--@brief 	更新累计购买次数和进度
function WndUniversalGroup:_updateCountAndProgress()
	-- body
	local txtBuyTimes = GetElement(self.m_root, "txtBuyTimes_WndUniversalGroup", WZUILabelTTF)
	if txtBuyTimes then
		txtBuyTimes:setText(self.m_nCount)
	end

	local nCurNum = self.m_nCount
	local prgTotalReward = GetElement(self.m_root, "prgTotalReward_WndUniversalGroup", WZUIProgress)
	if prgTotalReward then 
		if nCurNum <= self.m_tBoxData[1].target then 
            prgTotalReward:setPercentage(math.floor(nCurNum * 15/self.m_tBoxData[1].target))
        elseif nCurNum <= self.m_tBoxData[2].target then 
            local nTempNum = self.m_tBoxData[2].target - self.m_tBoxData[1].target
            prgTotalReward:setPercentage(15 + math.floor((nCurNum - self.m_tBoxData[1].target) * 15/nTempNum))
        elseif nCurNum <= self.m_tBoxData[3].target then 
            local nTempNum = self.m_tBoxData[3].target - self.m_tBoxData[2].target
            prgTotalReward:setPercentage(30 + math.floor((nCurNum - self.m_tBoxData[2].target) * 15/nTempNum))
        elseif nCurNum <= self.m_tBoxData[4].target then 
            local nTempNum = self.m_tBoxData[4].target - self.m_tBoxData[3].target
            prgTotalReward:setPercentage(45 + math.floor((nCurNum - self.m_tBoxData[3].target) * 15/nTempNum))
        elseif nCurNum <= self.m_tBoxData[5].target then 
            local nTempNum = self.m_tBoxData[5].target - self.m_tBoxData[4].target
            prgTotalReward:setPercentage(60 + math.floor((nCurNum - self.m_tBoxData[4].target) * 15/nTempNum))
        elseif nCurNum <= self.m_tBoxData[6].target then 
            local nTempNum = self.m_tBoxData[6].target - self.m_tBoxData[5].target
            prgTotalReward:setPercentage(75 + math.floor((nCurNum - self.m_tBoxData[5].target) * 25/nTempNum))
        else
            prgTotalReward:setPercentage(100)
        end
	end

	self:setBoxState()
end

--@brief 	设置宝箱的状态
function WndUniversalGroup:setBoxState()
	if not self.m_tBoxData then return end

	-- body
	--宝箱数据
    local closeBox = {"ui/common/common_icon_lan1.png","ui/common/common_icon_lan1.png","ui/common/common_icon_lan1.png","ui/common/common_icon_zi1.png","ui/common/common_icon_zi1.png","ui/common/common_icon_huang1.png"}
    local openBox = {"ui/common/common_icon_lan2.png","ui/common/common_icon_lan2.png","ui/common/common_icon_lan2.png","ui/common/common_icon_zi2.png","ui/common/common_icon_zi2.png","ui/common/common_icon_huang2.png"}
    local nullBox = {"ui/common/common_icon_lan3.png","ui/common/common_icon_lan3.png","ui/common/common_icon_lan3.png","ui/common/common_icon_zi3.png","ui/common/common_icon_zi3.png","ui/common/common_icon_huang3.png"}

	for i = 1, 6 do
        local imgBox = GetElement(self.m_root, "imgBtn" .. i .. "_WndUniversalGroup", WZUIImage)
        local txtTimes = GetElement(self.m_root, "txtTimes" .. i .. "_WndUniversalGroup", WZUILabelTTF)
        local armBox = GetElement(self.m_root, "armBox" .. i .. "_WndUniversalGroup", WZArmature)

        local tData = self.m_tBoxData[i]
        if self.m_nCount < tData.target then
            imgBox:setFile(closeBox[i])
            armBox:setVisible(false)
        else
            if tData.status == 1 then
                imgBox:setFile(nullBox[i])
                armBox:setVisible(false)
            else
                imgBox:setFile(openBox[i])
                armBox:setVisible(true)
            end
        end
        txtTimes:setText(tData.target)
    end
end

--@brief 	显示充值点
function WndUniversalGroup:showRechargePoint()
	if not self.m_tRewardData then return end
	
	-- body
	for i = 1, #self.m_tRewardData do
		local conRechargeItem = GetElement(self.m_root, "conRechargeItem" .. i .. "_WndUniversalGroup", WZUIContainer)
		conRechargeItem:setVisible(true)
		local conItem = GetElement(conRechargeItem, "conItem_WndUniversalGroup", WZUIContainer)
		conItem:removeAllChildrenWithCleanup(true)

		local tData = self.m_tRewardData[i]
		local element, tNewObj = CellGoodItem:createElement()
		if element and tNewObj then 
			tNewObj:setCellGoodLocalId(tData.reward[1][1], tData.reward[1][2], 17)
			tNewObj:setItemClickFun(self, self.clickItemBack)

			conItem:addChild(element)
		end

		local basicInfo = GDatatab_item["id_" .. tData.reward[1][1]]
		local txtItemName = GetElement(conRechargeItem, "txtItemName_WndUniversalGroup", WZUILabelTTF)
		if txtItemName and basicInfo then
			txtItemName:setText(basicInfo.name)
		end
		--原价
		local txtOriginPrice = GetElement(conRechargeItem, "txtOriginPrice_WndUniversalGroup", WZUILabelTTF)
		local vipData = GDatatab_recharge["id_" .. tData.rechargeId]
		if txtOriginPrice and vipData then 
			txtOriginPrice:setVisible(true)
			txtOriginPrice:setUseSystemFont(true)
			txtOriginPrice:setText(LocalStrings.NEWSHOP15 ..  tData.originPrice)
		end
		--现价
		local txtCurPrice = GetElement(conRechargeItem, "txtCurPrice_WndUniversalGroup", WZUILabelTTF)
		if txtCurPrice then
			txtCurPrice:setText(LocalStrings.LIMITE_BUY_CURPRICE .. ": " .. vipData.price)
			txtCurPrice:setFontSize(22)
		end
		--折扣
		if tData.discount ~= "" and tData.discount < 10 then 
			GetElement(conRechargeItem, "imgDiscount_WndUniversalGroup", WZUIImage):setVisible(true)
			GetElement(conRechargeItem, "txtDiscount_WndUniversalGroup", WZUILabelTTF):setText((10 - tData.discount) * 10 * -1 .. "%")
		end
		--按钮字
		self:setBtnState(conRechargeItem, tData)
	end
end

--@brief 	设置按钮状态
function WndUniversalGroup:setBtnState(conRechargeItem, tData)
	-- body
	local btnBuy = GetElement(conRechargeItem, "btnBuy_WndUniversalGroup", WZUIButton)
	local txtBtnBuyNor = GetElement(conRechargeItem, "txtBtnBuyNor_WndUniversalGroup", WZUILabelTTF)
	local txtBtnBuySel = GetElement(conRechargeItem, "txtBtnBuySel_WndUniversalGroup", WZUILabelTTF)
	local txtBtnBuyGray = GetElement(conRechargeItem, "txtBtnBuyGray_WndUniversalGroup", WZUILabelTTF)

	if tData.status == -1 then 
		btnBuy:setTouchEnable(true)

		txtBtnBuyNor:setTextKey("BUY")
		txtBtnBuySel:setTextKey("BUY")
		txtBtnBuyGray:setTextKey("BUY")
	elseif tData.status == 0 then 
		btnBuy:setTouchEnable(true)

		txtBtnBuyNor:setTextKey("BUY")
		txtBtnBuySel:setTextKey("BUY")
		txtBtnBuyGray:setTextKey("BUY")
	elseif tData.status == 1 then 
		btnBuy:setTouchEnable(false)

		txtBtnBuyNor:setTextKey("BOUGHT")
		txtBtnBuySel:setTextKey("BOUGHT")
		txtBtnBuyGray:setTextKey("BOUGHT")
	end
end
-------------------------------------私有方法模块End----------------------------------------


function WndUniversalGroup:_adaptLanguage_vn()
	GetElement(self.m_root,"todayBuyNumber",WZUILabelTTF):setScale(0.8)
	for i = 1, 3 do
		local conRechargeItem = GetElement(self.m_root, "conRechargeItem" .. i .. "_WndUniversalGroup", WZUIContainer)
		local txtDiscount = GetElement(conRechargeItem,"txtDiscount_WndUniversalGroup",WZUILabelTTF)
		txtDiscount:setFontSize(14)
		txtDiscount:setDimensions(GlobalMethod:CCSize(30,0))
	end
end

