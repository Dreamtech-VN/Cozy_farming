--CellInvestRebate.lua
--@brief	CellInvestRebate的UI模块
--@date		2020/05/18
--@author	XTX
--@note		投资返利Cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellInvestRebate:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellInvestRebate:onExit(element)
	self:_unInit()
end

--@brief 	点击购买、领取按钮回调
function CellInvestRebate:onClickBuy(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_tData.status == -1 then 
		if WndInvestRebateNor.m_root then 
			WndInvestRebateNor:_createLoading()
		else
			WndFrameActivity:_createLoading()
		end

        PostPlayerEvent:postEvent(PostPlayerEvent.event_clickPay)
        local sdkData = {}
        local vipData = GDatatab_recharge["id_" .. self.m_tData.rechargeId]
        WZLog("CellInvestRebate:onClickBuy:")
        sdkData.id = self.m_tData.rechargeId
        sdkData.price = vipData.price
        sdkData.productName = tostring(vipData.name)
        sdkData.payCode = GetPayCodeIdByChannelId(vipData)
        sdkData.quantifier = LocalStrings.SHOP_IND
        sdkData.number = "1"
        sdkData.giftNumber = "0"
        sdkData.productDesc = tostring(vipData.name)

        PassportSdkManager:getOrderNum(sdkData)
	elseif self.m_tData.status == 0 then 
		--领取奖励
		if WndFrameActivity.m_root then 
			WndFrameActivity:_createLoading()
			ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(g_cityExtenInfo.IRStatus, self.m_tData.rewardId)
		elseif WndInvestRebateNor.m_root then 
			WndInvestRebateNor:_createLoading()
			ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(WndInvestRebateNor.m_nActivityId, self.m_tData.rewardId)
		end
	end
end

--@brief 	点击物品回调
function CellInvestRebate:clickItemBack(luaTable, tag, tData)
	-- body
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
    if WndInvestRebate.m_root then 
    	WndItemInfo:showInfo(luaTable.m_root, WndInvestRebate.m_root, 1, tData, false)
    else
    	WndItemInfo:showInfo(luaTable.m_root, WndInvestRebateNor.m_root, 1, tData, false)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function CellInvestRebate:_update()
	-- body
	local txtName = GetElement(self.m_root, "txtName_CellInvestRebate", WZUILabelTTF)
	if txtName then 
		txtName:setText(string.format(LocalStrings.CASTSOUL_TEXT14, self.m_tData.tips))
	end
	--奖励
-- 	local tableList = GetElement(self.m_root, "tableList_CellInvestRebate", WZUITableContainer)
-- --	tableList:cleanTable()

-- 	local nCount = #self.m_tData.reward
-- 	for i = 1, nCount do
-- 		local element, tNewObj = CellGoodItem:createElement()
-- 		if element and tNewObj then 
-- 			element:setTag(i - 1)
-- 			element:setScale(0.8)
-- 			tNewObj:setCellGoodLocalId(self.m_tData.reward[i][1], self.m_tData.reward[i][2], 17)
-- 			tNewObj:setItemClickFun(self, self.clickItemBack)

-- 		 	tableList:setCellElement(element)
-- 		end
-- 	end

	local conMove = GetElement(self.m_root, "conMove_CellInvestRebate", WZUIMoveContainer)
	local conBag = GetElement(self.m_root, "conBag_CellInvestRebate", WZUIContainer)
	local nCount = #self.m_tData.reward
	if nCount <= 4 then 
		conMove:setVisible(false)
		conBag:setVisible(true)
	else
		conBag:setVisible(false)
		conMove:setVisible(true)
	end
	for i = 1, nCount do
		local conReward 
		if nCount <= 4 then 
			conReward = GetElement(self.m_root, "conReward0" .. i .. "_CellInvestRebate", WZUIContainer)
			if nCount == 1 then 
				conReward:setRelativePosition(GlobalMethod:ccp(0.5,0.75))
			elseif nCount == 2 then 
				if i == 1 then 
					conReward:setRelativePosition(GlobalMethod:ccp(0.285,0.75))
				elseif i == 2 then 
					conReward:setRelativePosition(GlobalMethod:ccp(0.715,0.75))
				end
			end
		else
			conReward = GetElement(self.m_root, "conReward" .. i .. "_CellInvestRebate", WZUIContainer)
		end
		conReward:setVisible(true)
		conReward:removeAllChildrenWithCleanup(true)

		local element, tNewObj = CellGoodItem:createElement()
		if element and tNewObj then 
			element:setTag(i - 1)
			element:setScale(0.8)
			tNewObj:setCellGoodLocalId(self.m_tData.reward[i][1], self.m_tData.reward[i][2], 17)
			tNewObj:setItemClickFun(self, self.clickItemBack)

		 	conReward:addChild(element)
		end
	end

	self:_setBtnState()
end

--@brief 	按钮状态
function CellInvestRebate:_setBtnState()
	-- body
	if self.m_tData.status ~= -1 then 
		GetElement(self.m_root, "imgBuyState_CellInvestRebate", WZUIImage):setVisible(true)
	else
		GetElement(self.m_root, "imgBuyState_CellInvestRebate", WZUIImage):setVisible(false)
	end

	local txtBuyNor = GetElement(self.m_root, "txtBuyNor_CellInvestRebate", WZUILabelTTF)
	local txtBuySel = GetElement(self.m_root, "txtBuySel_CellInvestRebate", WZUILabelTTF)
	local txtBuyGray = GetElement(self.m_root, "txtBuyGray_CellInvestRebate", WZUILabelTTF)
	local btnBuy = GetElement(self.m_root, "btnBuy_CellInvestRebate", WZUIButton)
	if self.m_tData.status == -1 then 
		btnBuy:setTouchEnable(true)

		local vipData = GDatatab_recharge["id_" .. self.m_tData.rechargeId]

		txtBuyNor:setUseSystemFont(true)
		txtBuySel:setUseSystemFont(true)
		txtBuyGray:setUseSystemFont(true)
		txtBuyNor:setText(vipData.unit .. LocalStrings.BUY)
		txtBuySel:setText(vipData.unit .. LocalStrings.BUY)
		txtBuyGray:setText(vipData.unit .. LocalStrings.BUY)
	elseif self.m_tData.status == 0 then 
		btnBuy:setTouchEnable(true)

		txtBuyNor:setUseSystemFont(false)
		txtBuySel:setUseSystemFont(false)
		txtBuyGray:setUseSystemFont(false)
		txtBuyNor:setText(LocalStrings.ACTIVE_BTN_GET)
		txtBuySel:setText(LocalStrings.ACTIVE_BTN_GET)
		txtBuyGray:setText(LocalStrings.ACTIVE_BTN_GET)
	elseif self.m_tData.status == 1 then 
		btnBuy:setTouchEnable(false)

		txtBuyNor:setUseSystemFont(false)
		txtBuySel:setUseSystemFont(false)
		txtBuyGray:setUseSystemFont(false)
		txtBuyNor:setText(LocalStrings.ACTIVE_GET)
		txtBuySel:setText(LocalStrings.ACTIVE_GET)
		txtBuyGray:setText(LocalStrings.ACTIVE_GET)
	end
end

--@brief 	设置购买按钮不可点击
function CellInvestRebate:setBuyBtnEnable()
	-- body
	local txtBuyNor = GetElement(self.m_root, "txtBuyNor_CellInvestRebate", WZUILabelTTF)
	local txtBuySel = GetElement(self.m_root, "txtBuySel_CellInvestRebate", WZUILabelTTF)
	local txtBuyGray = GetElement(self.m_root, "txtBuyGray_CellInvestRebate", WZUILabelTTF)
	local btnBuy = GetElement(self.m_root, "btnBuy_CellInvestRebate", WZUIButton)
	if self.m_tData.status == -1 then 
		btnBuy:setTouchEnable(false)

		local vipData = GDatatab_recharge["id_" .. self.m_tData.rechargeId]

		txtBuyNor:setUseSystemFont(true)
		txtBuySel:setUseSystemFont(true)
		txtBuyGray:setUseSystemFont(true)
		txtBuyNor:setText(vipData.unit .. LocalStrings.BUY)
		txtBuySel:setText(vipData.unit .. LocalStrings.BUY)
		txtBuyGray:setText(vipData.unit .. LocalStrings.BUY)
	end
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配begin----------------------------------------
function CellInvestRebate:_adaptLanguage_vn()
	local txtName = GetElement(self.m_root, "txtName_CellInvestRebate", WZUILabelTTF)
	txtName:setScale(0.8)
	local txtBuyNor = GetElement(self.m_root, "txtBuyNor_CellInvestRebate", WZUILabelTTF)
	txtBuyNor:setScale(0.8)
	local txtBuySel = GetElement(self.m_root, "txtBuySel_CellInvestRebate", WZUILabelTTF)
	txtBuySel:setScale(0.8)
	local txtBuyGray = GetElement(self.m_root, "txtBuyGray_CellInvestRebate", WZUILabelTTF)
	txtBuyGray:setScale(0.8)
end


-------------------------------------语言适配begin----------------------------------------
