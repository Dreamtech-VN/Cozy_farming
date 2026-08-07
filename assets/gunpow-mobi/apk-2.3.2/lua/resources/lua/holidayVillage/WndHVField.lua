--WndHVField.lua
--@brief	WndHVField的UI模块
--@date		2022/05/31
--@author	XTX
--@note		度假村-土坑界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndHVField:onEnter(element)
	self.m_root = element

	GlobalGame:getGameEventDispathcer():Add(HolidayVillageEvent.HolidayVillageEvent_Field, self.updateFieldData, self)

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndHVField:onExit(element)
	GlobalGame:getGameEventDispathcer():Remove(HolidayVillageEvent.HolidayVillageEvent_Field, self.updateFieldData, self)

	self:_unInit()
end

--@brief 	加载完成回调
function WndHVField:onEnterTransitionDidFinish(element)
	WZLog("WndHVField:onEnterTransitionDidFinish")
	self:_setStaticText()
	self:_update()
end

--@brief 	点击关闭按钮回调
function WndHVField:onClickClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	WindowManager:removeWindow(self.m_root, WndHVField , true)
end

--@brief 	点击查看土坑的整体属性
function WndHVField:onClickTips(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local tCurLvData = self:getFieldLevelData(self.m_tData)
	local tData = {}
	tData.winType = 1
	tData.property = CopyTable(tCurLvData.addition)
	tData.propertyPlayer = CopyTable(tCurLvData.property)
	--添加源石的属性
	local extraInfo = self.m_tData.extraInfo
	for key, value in pairs(extraInfo) do
		local basicData = GDatatab_item["id_" .. value]
		if basicData.property ~= -1 then 
			for j = 1, #basicData.property do
				local bExist = false 
				for i = 1, #tData.property do
					if tData.property[i][1] == basicData.property[j][1] then 
						tData.property[i][2] = tData.property[i][2] + basicData.property[j][2]
						bExist = true 
						break 
					end
				end
				if not bExist then 
					table.insert(tData.property, basicData.property[j])
				end
			end
		end
	end
	--添加花盆属性
	if self.m_tData.flowerpotId and self.m_tData.flowerpotId > 0 then 
		local flowerpotConfig = WndItemInfo:getFlowerpotFieldProperty(self.m_tData.flowerpotId)
		for i = 1, #flowerpotConfig.addition do
			local bIsExist = false 
			for j = 1, #tData.property do
				if tData.property[j][1] == flowerpotConfig.addition[i][1] then 
					tData.property[j][2] = tData.property[j][2] + flowerpotConfig.addition[i][2]
					bIsExist = true 
					break 
				end
			end
			if not bIsExist then 
				table.insert(tData.property, flowerpotConfig.addition[i])
			end
		end
	end
	WndTips:show(element,WndHVField.m_root,82,tData,nil,true)
end

--@brief 	点击加号按钮回调
function WndHVField:onClickAdd(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local tFieldConfig = self:_getFieldStoneConfigData()

	local nTag = element:getTag()
	if self.m_tData.fieldLv >= tFieldConfig[nTag].openLv then 
		local tData = {}
		tData.stonePos = nTag
		tData.stoneId = self.m_tData.extraInfo[tostring(nTag - 1)]
		tData.stone_type = tFieldConfig[nTag].stone_type

		WndSelectTipsStrengthen:showSelectTips(6, tData)
	end
end

--@brief 	点击升级按钮会滴
function WndHVField:onClickUpgrade(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local tCurLvData = self:getFieldLevelData(self.m_tData)
	local hostInfo = self.m_tLuaTable:getHostInfo()
	if hostInfo.hvLevel < tCurLvData.need_lv then 
		MsgBoxManager:showTipBox(string.format(LocalStrings.HOLIDAYVILLAGE_TEXT1[82], tCurLvData.need_lv))
		return 
	end

	if tCurLvData.exp == -1 and tCurLvData.lv_cost == -1 then 
		GetElement(self.m_root, "btnUpgrade_WndHVField", WZUIButton):setVisible(false)
		GetElement(self.m_root, "conUpgradeCost_WndHVField", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "txtMaxLvAtt_WndHVField", WZUILabelTTF):setVisible(true)
		return 
	end

	if tCurLvData.exp > self.m_tData.refine then
		if self.m_tData.configId == 2 then 
			MsgBoxManager:showTipBox(string.format(LocalStrings.CARD_COUNT1, LocalStrings.HOLIDAYVILLAGE_TEXT3[23]))
		else 
			MsgBoxManager:showTipBox(string.format(LocalStrings.CARD_COUNT1, LocalStrings.HOLIDAYVILLAGE_TEXT1[28]))
		end
		return 
	end
	if tCurLvData.lv_cost ~= -1 then 
		for i = 1, #tCurLvData.lv_cost do
			local nOwnNum = CacheCenter:getPlayerItemCountById(tCurLvData.lv_cost[1][1])
			if not JudgeMoneyIsEnough(tCurLvData.lv_cost[1][1], tCurLvData.lv_cost[1][2]) then 
				return 
			end
		end
	end

	ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_PitOp(self.m_tLuaTable:getHostId(), 7, self.m_tData.fieldId - 1, 0)
end

--@brief    选择源石添加到源石槽时调用
--@param	opType:1=镶嵌，-1=卸下
function WndHVField:addStoneToCell(tData, pos, opType)
	WZLog("WndHVField:addStoneToCell", pos, opType)

    if opType == -1 then --卸下
		ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_PitStone(self.m_tData.fieldId - 1, pos - 1, -1)
    else
    	if tData == nil then return end
		ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_PitStone(self.m_tData.fieldId - 1, pos - 1, tData.id)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	设置静态文本
function WndHVField:_setStaticText()
	if self.m_tData.configId == 2 then 
		GetElement(self.m_root, "txtTitle_WndHVField", WZUILabelTTF):setText(string.format(LocalStrings.HOLIDAYVILLAGE_TEXT3[24], self.m_tData.fieldId - 9))
	else
		GetElement(self.m_root, "txtTitle_WndHVField", WZUILabelTTF):setText(string.format(LocalStrings.HOLIDAYVILLAGE_TEXT1[44], self.m_tData.fieldId))
	end
end

--@brief 	刷新
function WndHVField:_update()
	self:_showLevel()
	self:_showNextLvDetail()
	self:_showStone()
end

--@brief 	显示当前等级
function WndHVField:_showLevel()
	local txtCurLv = GetElement(self.m_root, "txtCurLv_WndHVField", WZUILabelTTF)
	if txtCurLv then
		txtCurLv:setText(LocalStrings.LV .. self.m_tData.fieldLv)
	end
	--下一等级
	local txtNextLv = GetElement(self.m_root, "txtNextLv_WndHVField", WZUILabelTTF)
	if txtNextLv then
		txtNextLv:setText(string.format(LocalStrings.HOLIDAYVILLAGE_TEXT1[22], self.m_tData.fieldLv + 1))
	end

	GetElement(self.m_root, "txtNextLvP_WndHVField", WZUILabelTTF):setText(LocalStrings.CHARACTER_ATTRIBUTES)
end

--@brief 	显示下一等级加成和升级消耗
function WndHVField:_showNextLvDetail()
	for i = 1, 4 do
		GetElement(self.m_root, "txtProperty" .. i .. "_WndHVField", WZUILabelTTF):setText("")
		GetElement(self.m_root, "txtPropertyValue" .. i .. "_WndHVField", WZUILabelTTF):setText("")
		GetElement(self.m_root, "txtPropertyP" .. i .. "_WndHVField", WZUILabelTTF):setText("")
		GetElement(self.m_root, "txtPropertyValueP" .. i .. "_WndHVField", WZUILabelTTF):setText("")
	end
	--
	local tCurLvData, tNextLvData = self:getFieldLevelData(self.m_tData)
	--土坑土块
	if tCurLvData.maintype == 2 then
		local spineField = GetElement(self.m_root, "spineField_WndHVField", WZUISpine)
		local tTmepArray = SplitStringWithSeparator(tCurLvData.icon, ",")

        spineField:setFileAtlas(tTmepArray[1] .. ".atlas")
        spineField:setFileJson(tTmepArray[1] .. ".json")
        spineField:play(tTmepArray[2], true)
	else 
		local imgField = GetElement(self.m_root, "imgField_WndHVField", WZUIImage)
		if imgField then 
			imgField:setFile(tCurLvData.icon)
		end
	end
	local imgFlowerpot = GetElement(self.m_root, "imgFlowerpot_WndHVField", WZUIImage)
	local strFlowerpot = ""
	if self.m_tData.flowerpotId and self.m_tData.flowerpotId > 0 then 
		local flowerpotData = GDatatab_item["id_" .. self.m_tData.flowerpotId]
        if flowerpotData then
            local tTmepArray1 = SplitStringWithSeparator(flowerpotData.animation_index_code, ",") 
            strFlowerpot = string.gsub(tCurLvData.icon, "common_djc_tk", tTmepArray1[1])
        end
	end
	imgFlowerpot:setFile(strFlowerpot)
	--加成
	local conUpgradeCost = GetElement(self.m_root, "conUpgradeCost_WndHVField", WZUIContainer)
	local txtMaxLvAtt = GetElement(self.m_root, "txtMaxLvAtt_WndHVField", WZUILabelTTF)
	local btnUpgrade = GetElement(self.m_root, "btnUpgrade_WndHVField", WZUIButton)
	if tCurLvData.exp == -1 and tCurLvData.lv_cost == -1 then 
		for i = 1, #tCurLvData.addition do
			local txtProperty = GetElement(self.m_root, "txtProperty" .. i .. "_WndHVField", WZUILabelTTF)
			txtProperty:setText(HVATTR_TITLE[tCurLvData.addition[i][1]] .. ":")
			local txtPropertyValue = GetElement(self.m_root, "txtPropertyValue" .. i .. "_WndHVField", WZUILabelTTF)
			txtPropertyValue:setText("Max")
		end

		for i = 1, #tCurLvData.property do
			local txtProperty = GetElement(self.m_root, "txtPropertyP" .. i .. "_WndHVField", WZUILabelTTF)
			txtProperty:setText(ATTR_TITLE[tCurLvData.property[i][1]] .. ":")
			local txtPropertyValue = GetElement(self.m_root, "txtPropertyValueP" .. i .. "_WndHVField", WZUILabelTTF)
			txtPropertyValue:setText("Max")
		end

		conUpgradeCost:setVisible(false)
		btnUpgrade:setVisible(false)
		txtMaxLvAtt:setVisible(true)
	else
		for i = 1, #tNextLvData.addition do
			local txtProperty = GetElement(self.m_root, "txtProperty" .. i .. "_WndHVField", WZUILabelTTF)
			txtProperty:setText(HVATTR_TITLE[tNextLvData.addition[i][1]] .. ":")
			local txtPropertyValue = GetElement(self.m_root, "txtPropertyValue" .. i .. "_WndHVField", WZUILabelTTF)
			local addPro = (tNextLvData.addition[i][2] * 100 / 10000).."%"
			txtPropertyValue:setText("+" .. addPro)
		end
		--人物属性
		for i = 1, #tNextLvData.property do
			local txtProperty = GetElement(self.m_root, "txtPropertyP" .. i .. "_WndHVField", WZUILabelTTF)
			txtProperty:setText(ATTR_TITLE[tNextLvData.property[i][1]] .. ":")
			local txtPropertyValue = GetElement(self.m_root, "txtPropertyValueP" .. i .. "_WndHVField", WZUILabelTTF)
			local addPro = tNextLvData.property[i][2]
			txtPropertyValue:setText("+" .. addPro)
		end

		btnUpgrade:setVisible(true)
		txtMaxLvAtt:setVisible(false)
		conUpgradeCost:setVisible(true)
		--消耗
		--土坑精炼
		local txtCost1 = GetElement(self.m_root, "txtCost1_WndHVField", WZUILabelTTF)
		local txtCostValue1 = GetElement(self.m_root, "txtCostValue1_WndHVField", WZUILabelTTF)
		local imgGou1 = GetElement(self.m_root, "imgGou1_WndHVField", WZUIImage)
		if tCurLvData.exp ~= -1 then 
			if self.m_tData.configId == 2 then 
				txtCost1:setText(LocalStrings.HOLIDAYVILLAGE_TEXT3[23])
			else
				txtCost1:setText(LocalStrings.HOLIDAYVILLAGE_TEXT1[28])
			end
			txtCostValue1:setText(self.m_tData.refine .. "/" .. tCurLvData.exp)
			if tCurLvData.exp <= self.m_tData.refine then 
				imgGou1:setVisible(true)
				txtCostValue1:setColor(GlobalMethod:ccc3(5,180,0))
			else
				txtCostValue1:setColor(GlobalMethod:ccc3(255,89,74))
				imgGou1:setVisible(false)
			end
		else
			imgGou1:setVisible(false)
		end
		--度假币
		local txtCost2 = GetElement(self.m_root, "txtCost2_WndHVField", WZUILabelTTF)
		local txtCostValue2 = GetElement(self.m_root, "txtCostValue2_WndHVField", WZUILabelTTF)
		local imgGou2 = GetElement(self.m_root, "imgGou2_WndHVField", WZUIImage)
		local nCoinNum = 0 
		if tCurLvData.lv_cost ~= -1 then 
			nCoinNum = CacheCenter:getPlayerItemCountById(tCurLvData.lv_cost[1][1])
			local basicData = GDatatab_item["id_" .. tCurLvData.lv_cost[1][1]]
			if basicData then 
				txtCost2:setText(basicData.name)
			end
			txtCostValue2:setText(nCoinNum .. "/" .. tCurLvData.lv_cost[1][2])
			if tCurLvData.lv_cost[1][2] <= nCoinNum then 
				imgGou2:setVisible(true)
				txtCostValue2:setColor(GlobalMethod:ccc3(5,180,0))
			else
				imgGou2:setVisible(false)
				txtCostValue2:setColor(GlobalMethod:ccc3(255,89,74))
			end
		else
			imgGou2:setVisible(false)
		end
	end
end

--@brief 	显示镶嵌的源石
function WndHVField:_showStone()
	local extraInfo = self.m_tData.extraInfo
	local configData = self:_getFieldStoneConfigData()
	WZLog("WndHVField:_showStone", Serialize(extraInfo))
	--设置解锁等级
	for i = 1, #configData do
		local conStone = GetElement(self.m_root, "conStone" .. i .. "_WndHVField", WZUIContainer)
		local imgAdd = GetElement(conStone, "imgAdd_WndHVField", WZUIImage)
		local txtOpenLv = GetElement(conStone, "txtOpenLv_WndHVField", WZUILabelTTF)
		local txtStoneLv = GetElement(conStone, "txtStoneLv_WndHVField", WZUILabelTTF)
		txtOpenLv:setText(string.format(LocalStrings.LV .. configData[i].openLv))
		if self.m_tData.fieldLv >= configData[i].openLv then 
			GetElement(conStone, "conLock_WndHVField", WZUIContainer):setVisible(false)
			imgAdd:setVisible(true)
			if extraInfo[tostring(i - 1)] then 
				local basicData = GDatatab_item["id_" .. extraInfo[tostring(i - 1)]]
				if basicData then 
					imgAdd:setFile(basicData.icon)
					txtStoneLv:setText(LocalStrings.LV .. basicData.value)
				else
					txtStoneLv:setText("")
					imgAdd:setFile("ui/common/common_btn_+.png")
				end
			else
				txtStoneLv:setText("")
				imgAdd:setFile("ui/common/common_btn_+.png")
			end
		else
			txtStoneLv:setText("")
			GetElement(conStone, "conLock_WndHVField", WZUIContainer):setVisible(true)
			imgAdd:setVisible(false)
		end
	end

end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配Begin----------------------------------------

function WndHVField:_adaptLanguage_vn()
	GetElement(self.m_root, "txtCostValue2_WndHVField", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.4,0.3))
	GetElement(self.m_root, "txtCurLv_WndHVField", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.88,0.5))
end

-------------------------------------语言适配End----------------------------------------
