--WndHVLibrary.lua
--@brief	WndHVLibrary的UI模块
--@date		2022/05/28
--@author	XTX
--@note		度假村-图鉴界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndHVLibrary:onEnter(element)
	self.m_root = element

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndHVLibrary:onExit(element)
	self:_unInit()
end

--@brief 	加载完成回调
function WndHVLibrary:onEnterTransitionDidFinish(element)
	WZLog("WndHVLibrary:onEnterTransitionDidFinish")
	self:_setStaticText()
	self:_initLibraryData()
	ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_WarehouseOp(2)
	ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_PictureOp(1, 0)
end

--@brief 	点击关闭按钮回调
function WndHVLibrary:onClickClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	local nTag = element:getTag()
	if nTag == 1 then 
		WindowManager:removeWindow(self.m_root, WndHVLibrary , true)
	elseif nTag == 2 then 
		self:_hideUnlockInterface()
	elseif nTag == 3 then 
		GetElement(self.m_root, "conUpgrade_WndHVLibrary", WZUIContainer):setVisible(false)
		local elem = self.m_root:getChildElement("wnd_black_bg___")
	    if elem ~= nil then 
	        elem:setVisible(true)
	    end
	end
end

--@brief 	点击解锁/升级按钮回调
function WndHVLibrary:onClickUpgradeCallBack(tCell, tData)
	self.m_tCellSel = tCell 
	self.m_tCellSelData = tData
	
	if tData.level == 0 then 
		self:_showUnlockDetail()
	else
		self:_showUpgradeDetail()
	end
	local elem = self.m_root:getChildElement("wnd_black_bg___")
    if elem ~= nil then 
        elem:setVisible(false)
    end
end

--@brief 	升级界面点击升级按钮回调
function WndHVLibrary:onUpgradeLibrary(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	local tData = self.m_tCellSelData 
	--判断数量是否满足需求
	local nOwnNum = self.m_tLuaTable:getItemCountByItemId(tData.needItemId)
	if tData.needNum > nOwnNum then 
		MsgBoxManager:showTipBox(string.format(LocalStrings.HOLIDAYVILLAGE_TEXT1[25], tData.name, tData.needNum))
		return 
	end
	--判断消耗
	for i = 1, #tData.cost do
		if not JudgeMoneyIsEnough(tData.cost[i][1], tData.cost[i][2], nil, nil, nil, nil, nil, nil, nil, self, self.sureUseBlueInstead) then 
			return 
		end
	end

	ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_PictureOp(2, tData.plant)
end

--@brief 	点击物品格子回调
function WndHVLibrary:onItemClick(tCell,tag,tData)
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData,false,nil,true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	设置静态文本
function WndHVLibrary:_setStaticText()
	GetElement(self.m_root, "txtTitle_WndHVLibrary", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT1[20])
	local txtTitleUnlock = GetElement(self.m_root, "txtTitleUnlock_WndHVLibrary", WZUILabelTTF)
	if txtTitleUnlock then 
		txtTitleUnlock:setText(LocalStrings.TIPSWORD6)
	end

	GetElement(self.m_root, "txtCostTitle_conUpLevel", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT1[37])
	GetElement(self.m_root, "txtCondition1_WndHVLibrary", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT1[81])
	GetElement(self.m_root, "txtCondition2_WndHVLibrary", WZUILabelTTF):setText(LocalStrings.CONSUME)
end

--@brief 	刷新
function WndHVLibrary:_update()
	local tbLibraryList = GetElement(self.m_root, "tbLibraryList_WndHVLibrary", WZUITableContainer)
	tbLibraryList:cleanTable()

	for i = 1, #self.m_tLibraryData do
		local element, tNewObj = CellHVLibraryItem:createElement()
        if element == nil or tNewObj == nil then
            return 
        end
        element:setTag(i - 1)
        tNewObj:setData(self.m_tLibraryData[i])
        tbLibraryList:setCellElement(element)
	end
end

--@brief 	显示升级界面
function WndHVLibrary:_showUpgradeDetail()
	GetElement(self.m_root, "conUpgrade_WndHVLibrary", WZUIContainer):setVisible(true)
	GetElement(self.m_root, "conUpLevel_WndHVLibrary", WZUIContainer):setVisible(true)
	GetElement(self.m_root, "conUnlock_WndHVLibrary", WZUIContainer):setVisible(false)
	local tData = self.m_tCellSelData
	local txtTitleUpgrade = GetElement(self.m_root, "txtTitleUpgrade_WndHVLibrary", WZUILabelTTF)
	if txtTitleUpgrade then 
		txtTitleUpgrade:setText(tData.name .. LocalStrings.STAR_SOUL_BUTTON_UPDATE)
	end

	GetElement(self.m_root, "txtCurLv_WndHVLibrary", WZUILabelTTF):setText(string.format(LocalStrings.HOLIDAYVILLAGE_TEXT1[21], tData.level))
	GetElement(self.m_root, "txtNextLv_WndHVLibrary", WZUILabelTTF):setText(string.format(LocalStrings.HOLIDAYVILLAGE_TEXT1[22], tData.level + 1))
	--当前等级属性
	for i = 1, 5 do
		GetElement(self.m_root, "txtCurPro" .. i .. "_WndHVLibrary", WZUILabelTTF):setText("")
		GetElement(self.m_root, "txtCurProValue" .. i .. "_WndHVLibrary", WZUILabelTTF):setText("")
		GetElement(self.m_root, "imgArrow" .. i .. "_WndHVLibrary", WZUIImage):setVisible(false)
	end
	local strWords = {LocalStrings.HOLIDAYVILLAGE_TEXT1[78], LocalStrings.HOLIDAYVILLAGE_TEXT1[38], LocalStrings.HOLIDAYVILLAGE_TEXT1[79]}
	for i = 1, #tData.property do
		local txtCurPro = GetElement(self.m_root, "txtCurPro" .. i .. "_WndHVLibrary", WZUILabelTTF)
		local txtCurProValue = GetElement(self.m_root, "txtCurProValue" .. i .. "_WndHVLibrary", WZUILabelTTF)
		txtCurPro:setVisible(true)
		GetElement(self.m_root, "imgArrow" .. i .. "_WndHVLibrary", WZUIImage):setVisible(true)

		if i <= 3 then 
			local addPro = tData.property[i]
			if addPro > 0 then 
				txtCurPro:setText(strWords[i])
				txtCurProValue:setText("+" .. addPro)
			else
				GetElement(self.m_root, "imgArrow" .. i .. "_WndHVLibrary", WZUIImage):setVisible(false)
			end
		elseif i == 4 then 
			if type(tData.property[i]) == "table" then 
				local itemInfo = GDatatab_item["id_" .. tData.property[i][1][1]]
				if itemInfo then 
					txtCurPro:setText(itemInfo.name)
					txtCurProValue:setText("+" .. tData.property[i][1][2])
				end
			else
				GetElement(self.m_root, "imgArrow" .. i .. "_WndHVLibrary", WZUIImage):setVisible(false)
			end
		end
	end
	--下一等级属性
	for i = 1, 5 do
		GetElement(self.m_root, "txtNextPro" .. i .. "_WndHVLibrary", WZUILabelTTF):setText("")
		GetElement(self.m_root, "txtNextProValue" .. i .. "_WndHVLibrary", WZUILabelTTF):setText("")
	end
	if tData.nextProperty then 
		GetElement(self.m_root, "btnUpgradeLibrary_WndHVLibrary", WZUIButton):setVisible(true)
		GetElement(self.m_root, "txtMaxLvAtt_WndHVLibrary", WZUILabelTTF):setVisible(false)
		for i = 1, #tData.nextProperty do
			local txtNextPro = GetElement(self.m_root, "txtNextPro" .. i .. "_WndHVLibrary", WZUILabelTTF)
			local txtNextProValue = GetElement(self.m_root, "txtNextProValue" .. i .. "_WndHVLibrary", WZUILabelTTF)
			txtNextPro:setVisible(true)

			if i <= 3 then 
				local addPro = tData.nextProperty[i]
				if addPro > 0 then 
					txtNextPro:setText(strWords[i])
					txtNextProValue:setText("+" .. addPro)
				end
			elseif i == 4 then 
				if type(tData.nextProperty[i]) == "table" then 
					local itemInfo = GDatatab_item["id_" .. tData.nextProperty[i][1][1]]
					if itemInfo then 
						txtNextPro:setText(itemInfo.name)
						txtNextProValue:setText("+" .. tData.nextProperty[i][1][2])
					end
				end
			end
		end
	else
		GetElement(self.m_root, "btnUpgradeLibrary_WndHVLibrary", WZUIButton):setVisible(false)
		GetElement(self.m_root, "txtMaxLvAtt_WndHVLibrary", WZUILabelTTF):setVisible(true)
		for i = 1, #tData.property do
			local txtNextPro = GetElement(self.m_root, "txtNextPro" .. i .. "_WndHVLibrary", WZUILabelTTF)
			local txtNextProValue = GetElement(self.m_root, "txtNextProValue" .. i .. "_WndHVLibrary", WZUILabelTTF)
			txtNextPro:setVisible(true)

			if i <= 3 then 
				local addPro = tData.property[i]
				if addPro ~= 0 then 
					txtNextPro:setText(strWords[i])
					txtNextProValue:setText("Max")
				end
			elseif i == 4 then 
				if type(tData.property[i]) == "table" then 
					local itemInfo = GDatatab_item["id_" .. tData.property[i][1][1]]
					if itemInfo then 
						txtNextPro:setText(itemInfo.name)
						txtNextProValue:setText("Max")
					end
				end
			end
		end
	end
	--升级消耗
	local imgCondition1 = GetElement(self.m_root, "imgCondition1_WndHVLibrary", WZUIImage)
	local txtConditionValue1 = GetElement(self.m_root, "txtConditionValue1_WndHVLibrary", WZUILabelTTF)
	if tData.needNum > 0 then 
		local nOwnNum = self.m_tLuaTable:getItemCountByItemId(tData.needItemId)
		local tempData = GDatatab_item["id_" .. tData.needItemId]
		imgCondition1:setFile(tempData.icon)
		txtConditionValue1:setText(nOwnNum .. "/" .. tData.needNum)
	end
	if tData.cost ~= -1 then 
		GetElement(self.m_root, "conForCost_WndHVLibrary", WZUIContainer):setVisible(true)
		local imgCondition2 = GetElement(self.m_root, "imgCondition2_WndHVLibrary", WZUIImage)
		local txtConditionValue2 = GetElement(self.m_root, "txtConditionValue2_WndHVLibrary", WZUILabelTTF)

		for i = 1, #tData.cost do
			local basicData = GDatatab_item["id_" .. tData.cost[i][1]]
			imgCondition2:setFile(basicData.icon)
			txtConditionValue2:setText(tData.cost[i][2])
		end

	else
		GetElement(self.m_root, "conForCost_WndHVLibrary", WZUIContainer):setVisible(false)
	end
end

--@brief 	解锁界面
--@brief 	显示升级界面
function WndHVLibrary:_showUnlockDetail()
	GetElement(self.m_root, "conUpgrade_WndHVLibrary", WZUIContainer):setVisible(true)
	GetElement(self.m_root, "conUpLevel_WndHVLibrary", WZUIContainer):setVisible(false)
	GetElement(self.m_root, "conUnlock_WndHVLibrary", WZUIContainer):setVisible(true)

	local ftxtUnlockCost = GetElement(self.m_root, "ftxtUnlockCost_WndHVLibrary", WZUIFreeTextBox)
	if ftxtUnlockCost then 
		local strCost = LocalStrings.HOLIDAYVILLAGE_TEXT1[23]
		local strFormat1 = [[<I Z="0.5" P="1">%s</I><T C="127,70,26" S="20" P="1">*%d</T>]]
		local tData = self.m_tCellSelData
		for i = 1, #tData.cost do
			local basicData = GDatatab_item["id_" .. tData.cost[i][1]]
			local strTemp = string.format(strFormat1, basicData.icon, tData.cost[i][2])
			if i > 1 then 
				strCost = strCost .. [[<T C="127,70,26" S="20" P="1">,</T>]]
			end
			strCost = strCost .. strTemp
		end
		local strTemp1 = string.format(LocalStrings.HOLIDAYVILLAGE_TEXT1[24], tData.name)
		strCost = strCost .. strTemp1

		ftxtUnlockCost:setShowText(strCost)
	end
end

--@brief 	隐藏解锁界面
function WndHVLibrary:_hideUnlockInterface()
	GetElement(self.m_root, "conUpgrade_WndHVLibrary", WZUIContainer):setVisible(false)
	local elem = self.m_root:getChildElement("wnd_black_bg___")
    if elem ~= nil then 
        elem:setVisible(true)
    end
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配Begin----------------------------------------

function WndHVLibrary:_adaptLanguage_vn()
	for i = 1, 5 do
		local txtCurPro = GetElement(self.m_root, "txtCurPro" .. i .. "_WndHVLibrary", WZUILabelTTF)
		local txtCurProValue = GetElement(self.m_root, "txtCurProValue" .. i .. "_WndHVLibrary", WZUILabelTTF)
		txtCurPro:setFontSize(16)
		txtCurProValue:setFontSize(16)
		local txtNextPro = GetElement(self.m_root, "txtNextPro" .. i .. "_WndHVLibrary", WZUILabelTTF)
		local txtNextProValue = GetElement(self.m_root, "txtNextProValue" .. i .. "_WndHVLibrary", WZUILabelTTF)
		txtNextPro:setFontSize(16)
		txtNextProValue:setFontSize(16)
	end

	local imgCondition1 = GetElement(self.m_root, "imgCondition1_WndHVLibrary", WZUIImage)
	local imgCondition2 = GetElement(self.m_root, "imgCondition2_WndHVLibrary", WZUIImage)
	imgCondition1:setRelativePosition(GlobalMethod:ccp(0.3,0.7))
	imgCondition2:setRelativePosition(GlobalMethod:ccp(0.3,0.3))
	local txtConditionValue1 = GetElement(self.m_root,"txtConditionValue1_WndHVLibrary",WZUILabelTTF)
	local txtConditionValue2 = GetElement(self.m_root,"txtConditionValue2_WndHVLibrary",WZUILabelTTF)
	txtConditionValue1:setRelativePosition(GlobalMethod:ccp(0.35,0.7))
	txtConditionValue2:setRelativePosition(GlobalMethod:ccp(0.35,0.3))
end

-------------------------------------语言适配End----------------------------------------