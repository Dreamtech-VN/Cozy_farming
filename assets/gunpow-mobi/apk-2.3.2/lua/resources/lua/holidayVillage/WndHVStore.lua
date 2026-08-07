--WndHVStore.lua
--@brief	WndHVStore的UI模块
--@date		2022/05/30
--@author	XTX
--@note		度假村-仓库界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndHVStore:onEnter(element)
	self.m_root = element
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndHVStore:onExit(element)
	CacheCenter:unregisterUpatePlayerItemObserver(self)

	self:_unInit()
end

--@brief 	加载完成回调
function WndHVStore:onEnterTransitionDidFinish(element)
	WZLog("WndHVStore:onEnterTransitionDidFinish")
	self:_setStaticText()
	ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_WarehouseOp(self.m_nTabIndex)
end

--@brief 	点击关闭按钮回调
function WndHVStore:onClickClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	WindowManager:removeWindow(self.m_root, WndHVStore , true)
end

--@brief 	切换仓库物品类型
function WndHVStore:onClickTab(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local nTag = element:getTag()
	if self.m_nTabIndex == nTag then return end 
	self.m_nTabIndex = nTag
	self.m_nChooseNum = 1
	if self.m_tStoreData[nTag] == nil then 
		ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_WarehouseOp(self.m_nTabIndex)
		return 
	end
	
	self:_update()
end

--@brief 	点击物品格子回调
function WndHVStore:onItemClick(tCell, tData)
	if tData == nil then
       return
    end
    if self.m_tCellSel and self.m_tCellSelData.id == tData.id then return end 

    if self.m_tCellSel then 
    	self.m_tCellSel:setSelState(false)
    end
    self.m_nChooseNum = 1
    self.m_tCellSel = tCell 
    self.m_tCellSel:setSelState(true)
    self.m_tCellSelData = tData 
    self:_showItemDetail()
end

--@brief 	点击图鉴和成就按钮回调
function WndHVStore:onClickTop(element)
	local nTag = element:getTag()
	if nTag == 1 then --图鉴
		WndHVOperate:onClickLibrary(element)
	elseif nTag == 2 then --成就
		WndHVOperate:onClickAchie(element)
	end
end

--@brief 	点击播种按钮回调
function WndHVStore:onClickSow(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--判断能量值是否足够
	local seedData = WndHVLibrary:getSeedDataByItemId(self.m_tCellSelData.id)
	local fieldConfig = WndHVField:getFieldLevelData(self.m_tFieldData)
	local hostInfo = self.m_tLuaTable:getHostInfo()
	if hostInfo.hvCurEnergy < seedData.energy_cost + fieldConfig.energy_cost then 
		MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT1[74])
		return 
	end
	self.m_tLuaTable:setOperateType(1, self.m_tCellSelData)
	WindowManager:removeWindow(self.m_root, WndHVStore, true)
end

--@brief 	点击前往购买按钮回调
function WndHVStore:onClickBuy(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WndHVShop:showInterface()
end

--@brief 	点击加成/出售按钮回调
function WndHVStore:onClickSell(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
--	do WndHVStore:sellFlowerResult({1,1,1,1,1,1}, {50,50,50,50,50,50}, {2,2,2,2,2,2,2,2,2,2}, {2000,2000,2000,2000,2000,2000,2000,200,2000,2000}) return end 
	local nTag = element:getTag()
	local nOwnNum = self.m_tCellSelData.lastNum
	if nOwnNum < self.m_nChooseNum * self.m_nPerNum then 
		MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT3[34])
		return
	end
	if nTag == 2 then --直接出售 
		ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_FlowerRecovery(self.m_tCellSelData.id, self.m_nChooseNum, -1, -1)
	elseif nTag == 1 then --加成出售 
		local nCostCardNum = self.m_nChooseNum * self.m_tSpriteCardConfig[2]
		local nOwnCards = self:getItemsCountByItemId(self.m_tSpriteCardConfig[1])
		WZLog("WndHVStore:onClickSell", nCostCardNum, nOwnCards, self.m_tSpriteCardConfig[2])
		if nCostCardNum > nOwnCards then 
			local nAddNums = math.floor(nOwnCards/self.m_tSpriteCardConfig[2])
			local strAttContent = string.format(LocalStrings.HOLIDAYVILLAGE_TEXT3[35], self.m_nChooseNum, nAddNums)
			MsgBoxManager:showConfirmBox(strAttContent, self, self.sureToSell)
		else
			ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_FlowerRecovery(self.m_tCellSelData.id, self.m_nChooseNum, self.m_tSpriteCardConfig[1], nCostCardNum)
		end
	end
end

--@brief 	确认加成
function WndHVStore:sureToSell()
	local nOwnCards = self:getItemsCountByItemId(self.m_tSpriteCardConfig[1])
	local nAddNums = math.floor(nOwnCards/self.m_tSpriteCardConfig[2])
	ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_FlowerRecovery(self.m_tCellSelData.id, self.m_nChooseNum, self.m_tSpriteCardConfig[1], nAddNums)
end

--@brief 	点击改变出售数量回调
function WndHVStore:onClickChange(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if nTag == 1 then 
		if self.m_nChooseNum < 2 then 
			MsgBoxManager:showTipBox(LocalStrings.CHESTMINNUM)
		else
			self.m_nChooseNum = self.m_nChooseNum - 1
			self:_showTotalPrice()		
		end
	elseif nTag == 2 then 
		local nOwnNum = self.m_tCellSelData.lastNum 
		if self.m_nChooseNum >= self.m_nMaxSell or self.m_nPerNum * (self.m_nChooseNum + 1) > nOwnNum then 
			MsgBoxManager:showTipBox(LocalStrings.CHESTMAXNUM)
		else
			self.m_nChooseNum = self.m_nChooseNum + 1
			self:_showTotalPrice()		
		end
	end
end

--@brief    点击规则按钮回调
function WndHVStore:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 
    WndSingleMapDesc:showInterface1(LocalStrings.SPRINGOUTING_TEXT3) 
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	设置静态文本
function WndHVStore:_setStaticText()
	self.m_nPerNum = tonumber(CacheCenter:getGameParam().aBunchFlowerNum or 99)
	self.m_tSpriteCardConfig = {}
	local strTemp = CacheCenter:getGameParam().resortSoldFlowerCard or "[55402,1]"
	local strConfig = string.sub(strTemp, 2, -2) 
	self.m_tSpriteCardConfig[1] = tonumber(SplitStringWithSeparator(strConfig, ",")[1])
	self.m_tSpriteCardConfig[2] = tonumber(SplitStringWithSeparator(strConfig, ",")[2])

	GetElement(self.m_root, "txtTitle_WndHVStore", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT1[7])
	GetElement(self.m_root, "txtTab1_WndHVStore", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT1[95])
	GetElement(self.m_root, "txtTab1Sel_WndHVStore", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT1[95])
	GetElement(self.m_root, "txtTab2_WndHVStore", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT1[96])
	GetElement(self.m_root, "txtTab2Sel_WndHVStore", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT1[96])
	GetElement(self.m_root, "txtBtnSow_WndHVStore", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT1[45])
	GetElement(self.m_root, "txtGotoBuy_WndHVStore", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT1[77])

	GetElement(self.m_root, "txtItemPrice_WndHVStore", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT3[29])
	GetElement(self.m_root, "txtSellTotal_WndHVStore", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT3[30])
	GetElement(self.m_root, "txtBtnSell1_WndHVStore", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT3[27])
	GetElement(self.m_root, "txtBtnSell2_WndHVStore", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT3[28])
	GetElement(self.m_root, "txtCardSellAtt_WndHVStore", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT3[31])
	GetElement(self.m_root, "txtSellAtt_WndHVStore", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT3[32])
	GetElement(self.m_root, "txtSellTitle_WndHVStore", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT3[33])
end

--@brief 	刷新
function WndHVStore:_update()
	local tbItemsList = GetElement(self.m_root, "tbItemsList_WndHVStore", WZUITableContainer)
	tbItemsList:cleanTable()

	local tStoreData = {}
	local tTempStoreData = self.m_tStoreData[self.m_nTabIndex]

	if self.m_bIsSow and self.m_nTabIndex == 1 then 
		if self.m_tFieldData and self.m_tFieldData.configId and tTempStoreData then 
			for i = 1, #tTempStoreData do
				if tTempStoreData[i].seedType == self.m_tFieldData.configId then 
					table.insert(tStoreData, tTempStoreData[i])
				end
			end
		end
	else
		tStoreData = self.m_tStoreData[self.m_nTabIndex]
	end
	self.m_tCellItem = {}
	self.m_tCellSel = nil 
    self.m_tCellSelData = nil  

	local conRight = GetElement(self.m_root, "conRight_WndHVStore", WZUIContainer)
	GetElement(self.m_root, "btnGotoBuy_WndHVStore", WZUIButton):setVisible(false)
	if tStoreData == nil or #tStoreData == 0 then 
		ShowPanelNullTip( conRight, LocalStrings.HOLIDAYVILLAGE_TEXT1[43])
		if self.m_nTabIndex == 1 and self.m_bIsSow then 
			GetElement(self.m_root, "btnGotoBuy_WndHVStore", WZUIButton):setVisible(true)
		end
		self:_showItemDetail()
		return 
	end

	removeShowPanelNullTip(conRight)
	for i = 1, #tStoreData do
		local element, tNewObj = CellHVStoreItem:createElement()
        if element == nil or tNewObj == nil then
            return 
        end
        element:setTag(i - 1)
        tNewObj:setData(tStoreData[i], self.m_nTabIndex)
        tbItemsList:setCellElement(element)
        if i == 1 then 
        	self.m_tCellSel = tNewObj 
    		self.m_tCellSelData = tStoreData[i]
    		self.m_tCellSel:setSelState(true)
    		self:_showItemDetail()
        end

        table.insert(self.m_tCellItem, tNewObj)
	end
end

--@brief 	显示右侧物品详情
function WndHVStore:_showItemDetail()
	local txtItemDesc = GetElement(self.m_root, "txtItemDesc_WndHVStore", WZUILabelTTF)
	local conLeftTop = GetElement(self.m_root, "conLeftTop_WndHVStore", WZUIContainer)
	local conLeft = GetElement(self.m_root, "conLeft_WndHVStore", WZUIContainer)
	local btnSow = GetElement(self.m_root, "btnSow_WndHVStore", WZUIButton)
	local txtCostEnergy = GetElement(self.m_root, "txtCostEnergy_WndHVStore", WZUILabelTTF)
	local conSell = GetElement(self.m_root, "conSell_WndHVStore", WZUIContainer)
	if self.m_tCellSelData == nil then 
		conLeftTop:setVisible(false)
		conSell:setVisible(false)
		btnSow:setVisible(false)
		txtCostEnergy:setText("")
		txtItemDesc:setVisible(false)
		ShowPanelNullTip( conLeft, LocalStrings.HOLIDAYVILLAGE_TEXT1[43])
		return 
	end 

	removeShowPanelNullTip(conLeft)
	local tData = self.m_tCellSelData
	local seedData = WndHVLibrary:getSeedDataByItemId(self.m_tCellSelData.id)
	if self.m_nTabIndex == 2 and seedData and seedData.recovery ~= -1 then 
		conLeft:setVisible(false)
		conSell:setVisible(true)
		local txtSellItemName = GetElement(self.m_root, "txtSellItemName_WndHVStore", WZUILabelTTF)
		if txtSellItemName then 
			txtSellItemName:setText(tData.basicInfo.name)
			txtSellItemName:setColor(QUALITYCOLOR[tData.basicInfo.quality])
		end
		local ftxtPrice = GetElement(self.m_root, "ftxtPrice_WndHVStore", WZUIFreeTextBox)
		local strPriceFormat = [[<T C="229,105,22" S="16" P="1">%d</T><I Z="0.5" P="1">%s</I>]]
		if ftxtPrice then 
			local basicInfo = GDatatab_item["id_" .. seedData.recovery[1][1]]
			ftxtPrice:setShowText(string.format(strPriceFormat, seedData.recovery[1][2], basicInfo.icon))
		end
		--图标
		local imgSellItemIcon = GetElement(self.m_root, "imgSellItemIcon_WndHvStore", WZUIImage)
		if imgSellItemIcon then 
			imgSellItemIcon:setFile(tData.basicInfo.icon)
		end
		local imgSellItemQuality = GetElement(self.m_root, "imgSellItemQuality_WndHVStore", WZUIImage)
		if imgSellItemQuality then 
			imgSellItemQuality:setFile(g_tQualityRect[tData.basicInfo.quality])
		end
		--总售价
		self:_showTotalPrice()
		self:_showSpriteCardNum()
	else
		conSell:setVisible(false)
		conLeft:setVisible(true)
		conLeftTop:setVisible(true)
		txtItemDesc:setVisible(true)
		local txtItemName = GetElement(self.m_root, "txtItemName_WndHVStore", WZUILabelTTF)
		if txtItemName then 
			txtItemName:setText(tData.basicInfo.name)
			txtItemName:setColor(QUALITYCOLOR[tData.basicInfo.quality])
		end
		if txtItemDesc then 
			txtItemDesc:setText(LocalStrings.NEWSKILL4 .. tData.basicInfo.desc)
		end
		--图标
		local imgItemIcon = GetElement(self.m_root, "imgItemIcon_WndHvStore", WZUIImage)
		if imgItemIcon then 
			imgItemIcon:setFile(tData.basicInfo.icon)
		end
		local imgItemQuality = GetElement(self.m_root, "imgItemQuality_WndHVStore", WZUIImage)
		if imgItemQuality then 
			imgItemQuality:setFile(g_tQualityRect[tData.basicInfo.quality])
		end
		if self.m_nTabIndex == 1 and self.m_bIsSow then 
			btnSow:setVisible(true)
			local fieldConfig = WndHVField:getFieldLevelData(self.m_tFieldData)
			txtCostEnergy:setText(LocalStrings.HOLIDAYVILLAGE_TEXT1[86] .. (seedData.energy_cost + fieldConfig.energy_cost))
		else
			btnSow:setVisible(false)
			txtCostEnergy:setText("")
		end
	end
end

--@brief 	显示精灵卡的数量
function WndHVStore:_showSpriteCardNum()
	local ftxtSpriteCards = GetElement(self.m_root, "ftxtSpriteCards_WndHVStore", WZUIFreeTextBox)
	if ftxtSpriteCards then 
		local strFormat = [[<I Z="0.5" P="1">%s</I><T C="127,70,26" S="20" P="1">%s：</T><T C="229,105,22" S="20" P="1">%d</T>]]
		local basicInfo = GDatatab_item["id_" .. self.m_tSpriteCardConfig[1]]
		local nCount = self:getItemsCountByItemId(self.m_tSpriteCardConfig[1])
		local strContent = string.format(strFormat, basicInfo.icon, basicInfo.name, nCount)
		ftxtSpriteCards:setShowText(strContent)
	end
end

--@brief 	总售价
function WndHVStore:_showTotalPrice()
	local txtTotalNum = GetElement(self.m_root, "txtTotalNum_WndHVStore", WZUILabelTTF)
	if txtTotalNum then 
		txtTotalNum:setText(self.m_nChooseNum)
	end
	local ftxtSellMoney = GetElement(self.m_root, "ftxtSellMoney_WndHVStore", WZUIFreeTextBox)
	local strPriceFormat = [[<T C="229,105,22" S="16" P="1">%d</T><I Z="0.5" P="1">%s</I>]]
	local seedData = WndHVLibrary:getSeedDataByItemId(self.m_tCellSelData.id)
	if ftxtSellMoney then 
		local basicInfo = GDatatab_item["id_" .. seedData.recovery[1][1]]		
		local nTotalNum = self.m_nChooseNum * seedData.recovery[1][2]
		ftxtSellMoney:setShowText(string.format(strPriceFormat, nTotalNum, basicInfo.icon))
	end
end
-------------------------------------私有方法模块End----------------------------------------

----------------------------------------语言适配Begin---------------------------------------

function WndHVStore:_adaptLanguage_vn(  )
	GetElement(self.m_root, "txtItemDesc_WndHVStore", WZUILabelTTF):setFontSize(16)

	GetElement(self.m_root, "ftxtPrice_WndHVStore", WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.716,0.56))
	GetElement(self.m_root, "ftxtSellMoney_WndHVStore", WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.665,0.4))

	GetElement(self.m_root, "txtBtnSell1_WndHVStore", WZUILabelTTF):setFontSize(20)
	GetElement(self.m_root, "txtBtnSell2_WndHVStore", WZUILabelTTF):setFontSize(20)
end

---------------------------------------语言适配End-----------------------------------------
