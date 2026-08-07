--WndServersSure.lua
--@brief	WndServersSure的UI模块
--@date		2021/11/30
--@author	XTX
--@note		突破


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndServersSure:onEnter(element)
    WZLog("WndServersSure:onEnter")
	self.m_root = element
	ProtocolProcessorGlobal:regAllTwo()
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品

	self.m_nMaxLevel = CacheCenter:getGameParam().gameMaxLevel
	self:_setStaticText()
	self:setData()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndServersSure:onExit(element)
    ProtocolProcessorGlobal:unregAllTwo()
    CacheCenter:unregisterUpatePlayerItemObserver(self)

	self:_unInit()
end

--@brief 	点击星星回调
function WndServersSure:onClickStar(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	local tLevelData = self.m_tStarList[self.m_nCurIndex]
	local tData 
	if self.m_tStarList[self.m_nCurIndex - 1] == nil then 
		tData = tLevelData[nTag + 1]
	else
		tData = tLevelData[nTag]
	end

	WndTips:show(element, self.m_root, 78, tData,GlobalMethod:ccp(150, 60))
end

--@brief 	点击上一级按钮回调
function WndServersSure:onClickLast(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTempIndex = self.m_nCurIndex - 1
	if self.m_tStarList[nTempIndex] then 
		self.m_nCurIndex = self.m_nCurIndex - 1
		if self.m_tStarList[nTempIndex - 1] == nil then 
			GetElement(self.m_root, "btnLast_WndServersSure", WZUIButton):setVisible(false)
		end
		GetElement(self.m_root, "btnNext_WndServersSure", WZUIButton):setVisible(false)
		--更细图标和进度条
		self:_showCurStarImgAndPro()
	end
end

--@brief 	点击下一级按钮回调
function WndServersSure:onClickNext(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	local nTempIndex = self.m_nCurIndex + 1
	if self.m_tStarList[nTempIndex] then 
		self.m_nCurIndex = self.m_nCurIndex + 1
		if self.m_tStarList[nTempIndex + 1] == nil then 
			GetElement(self.m_root, "btnNext_WndServersSure", WZUIButton):setVisible(false)
		end
		GetElement(self.m_root, "btnLast_WndServersSure", WZUIButton):setVisible(false)
		--更细图标和进度条
		self:_showCurStarImgAndPro()
	end
end

--@brief 	点击突破按钮回调
function WndServersSure:onClickBreak(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local tCost = GDatatab_level_breach["id_" .. self.m_nCurBreakId].cost
	for i = 1, #tCost do
		if not JudgeMoneyIsEnough(tCost[i][1], tCost[i][2], nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, ProtocolProcessorGlobal, ProtocolProcessorGlobal.send_PLAYER2_LevelBreach) then 
			return 
		end
	end
	
	ProtocolProcessorGlobal:send_PLAYER2_LevelBreach()
end

-------------------------------------公有方法模块End--------------------------------------
-------------------------------------私有方法模块Begin----------------------------------------
--@brief 	刷新
function WndServersSure:_update()
	self:_showCurStarImgAndPro()
	self:_showCurProperty(self.m_nCurBreakId)
	self:_showBreakCost()
	self:_showCoinNum()
end

--@brief 	设置静态文本
function WndServersSure:_setStaticText()
	GetElement(self.m_root, "txtBtnBreak1_WndServersSure", WZUILabelTTF):setText(LocalStrings.BREAK_TEXT2)
	GetElement(self.m_root, "txtBtnBreak2_WndServersSure", WZUILabelTTF):setText(LocalStrings.BREAK_TEXT2)
	GetElement(self.m_root, "txtBtnBreak3_WndServersSure", WZUILabelTTF):setText(LocalStrings.BREAK_TEXT2)
	GetElement(self.m_root, "txtPrgWord_WndServersSure", WZUILabelTTF):setText(LocalStrings.BREAK_TEXT1[2])
	GetElement(self.m_root, "imgCoin_WndServersSure", WZUIImage):setFile(GDatatab_item["id_161021"].icon)
end

--@brief 	显示当前属性
function WndServersSure:_showCurProperty(nCurBreakId)
	local nLevel = GDatatab_level_breach["id_" .. nCurBreakId].lv
	local nCurStar = GDatatab_level_breach["id_" .. nCurBreakId].star

	local tProperty = {}

	for i = nLevel, 1, -1 do
		local tItem = CopyTable(self.m_tStarList[i])
		if tItem then 
			local nCount = #tItem
			if i == nLevel then 
				for j = 1, nCount do
					if tItem[j].star <= nCurStar then 
						for k = 1, #tItem[j].value do
							local bExist = false 
							for n = 1, #tProperty do
								if tProperty[n][1] == tItem[j].value[k][1] then 
									bExist = true 
									tProperty[n][2] = tProperty[n][2] + tItem[j].value[k][2]
									break 
								end
							end

							if not bExist then 
								table.insert(tProperty, tItem[j].value[k])
							end
						end
					end
				end
			else
				for j = 1, nCount do
					for k = 1, #tItem[j].value do
						local bExist = false 
						for n = 1, #tProperty do
							if tProperty[n][1] == tItem[j].value[k][1] then 
								bExist = true 
								tProperty[n][2] = tProperty[n][2] + tItem[j].value[k][2]
								break 
							end
						end

						if not bExist then 
							table.insert(tProperty, tItem[j].value[k])
						end
					end
				end
			end
		else
			break 
		end
	end
	table.sort(tProperty, function (a, b)
		local sortA = a[1] == -1 and -4 or a[1]
		local sortB = b[1] == -1 and -4 or b[1]
		return sortA < sortB
		end)
	for i = 1, #tProperty do
		local txtPropertyWord = GetElement(self.m_root, "txtPropertyWord" .. i .. "_WndServersSure", WZUILabelTTF)
		local txtPropertyValue = GetElement(self.m_root, "txtPropertyValue" .. i .. "_WndServersSure", WZUILabelTTF)
		local nProperty = tProperty[i][2]
		if tProperty[i][1] == -1 then 
			txtPropertyWord:setText(LocalStrings.BREAK_TEXT1[3])
			nProperty = self.m_nMaxLevel
			txtPropertyValue:setText(nProperty)
		else
			txtPropertyWord:setText(ATTR_TITLE[tProperty[i][1]])
			if tProperty[i][1] < 0 then 
				nProperty = string.format("%0.2f%%", (100 * tProperty[i][2]/10000))
			end
			txtPropertyValue:setText("+" .. nProperty)
		end
	end
end

--@brief 	设置当前星星图标，属性
function WndServersSure:_showCurStarImgAndPro()
	-- body
	local tLevelData = self.m_tStarList[self.m_nCurIndex]
	local nCount = #tLevelData
	local nCurLv = GDatatab_level_breach["id_" .. self.m_nCurBreakId].lv
	local nCurStar = GDatatab_level_breach["id_" .. self.m_nCurBreakId].star
	local tShowData = self:getNextStarData()

	local strContent = string.format([[<T C="255,236,193" S="20" P="1"  SC="132,66,29" SS="4" SE="1">%s</T>]], LocalStrings.BREAK_TEXT3[3])
	if GDatatab_level_breach["id_" .. self.m_nCurBreakId].cost == -1 then 
		GetElement(self.m_root, "btnBreak_WndServersSure", WZUIButton):setTouchEnable(false)
		strContent = ""
	end

	local prgStar = GetElement(self.m_root, "prgStar_WndServersSure", WZUIProgress)
	local txtStarProgress = GetElement(self.m_root, "txtStarProgress_WndServersSure", WZUILabelTTF)
	local nPercent = math.floor(100 * nCurStar / 6)
	if self.m_nCurIndex > nCurLv then 
		nPercent = 0
	end
	prgStar:setPercentage(nPercent)
	txtStarProgress:setText(nPercent .. "%")


	local imgCurStar = GetElement(self.m_root, "imgCurStar_WndServersSure", WZUIImage)
	if tShowData.star == 6 then 
		imgCurStar:setFile("ui/bag/common_icon_xx_02.png")
	else
		imgCurStar:setFile("ui/bag/common_icon_xx_01.png")
	end

	local ftxtSelPro = GetElement(self.m_root, "ftxtSelPro_WndServersSure", WZUIFreeTextBox)
	local sFormat1 = [[<T C="255,236,193" S="20" P="1"  SC="132,66,29" SS="4" SE="1">%s</T><T C="255,236,193" S="20" P="1"  SC="132,66,29" SS="4" SE="1">+%d</T>]]
	local sFormat2 = [[<T C="255,236,193" S="20" P="1"  SC="132,66,29" SS="4" SE="1">,</T>]]
	local sFormat3 = [[<T C="255,236,193" S="20" P="1"  SC="132,66,29" SS="4" SE="1">%s</T><T C="255,236,193" S="20" P="1"  SC="132,66,29" SS="4" SE="1">+%0.2f%%</T>]]
	for i = 1, #tShowData.value do
		local strWord = LocalStrings.BREAK_TEXT1[3]
		local nTempValue = tShowData.value[i][2]
		local strTemp = nil 
		if tShowData.value[i][1] == -1 then 
			strWord = LocalStrings.BREAK_TEXT1[3]
			strTemp = string.format(sFormat1, strWord, nTempValue)
		elseif tShowData.value[i][1] < -1 then 
			strWord = ATTR_TITLE[tShowData.value[i][1]]
			nTempValue = 100 * tShowData.value[i][2]/10000
			strTemp = string.format(sFormat3, strWord, nTempValue)
		else
			strWord = ATTR_TITLE[tShowData.value[i][1]]
			strTemp = string.format(sFormat1, strWord, nTempValue)
		end

		if i > 1 then 
			strContent = strContent .. sFormat2
		end
		strContent = strContent .. strTemp 
	end
	ftxtSelPro:setShowText(strContent)
end

--@brief 	设置突破消耗
function WndServersSure:_showBreakCost()
	local tCurData = GDatatab_level_breach["id_" .. self.m_nCurBreakId]
	local ftxtBreakCost = GetElement(self.m_root, "ftxtBreakCost_WndServersSure", WZUIFreeTextBox)
	local sFormat = [[<T C="255,236,193" S="20" P="1"  SC="132,66,29" SS="4" SE="1">%s</T><I Z="0.5" P="1">%s</I><T C="99,255,95" S="20" P="1"  SC="132,66,29" SS="4" SE="1">%d</T>]]
	if ftxtBreakCost then 
		local strContent = nil 
		if tCurData.cost == -1 then 
			local sFormat2 = [[<T C="255,236,193" S="20" P="1"  SC="132,66,29" SS="4" SE="1">%s</T>]]
			strContent = string.format(sFormat2, LocalStrings.ACTIVITY_TEXT160[3])
			GetElement(self.m_root, "btnBreak_WndServersSure", WZUIButton):setTouchEnable(false)
		else
			local costData = tCurData.cost[1]
			strContent = string.format(sFormat, LocalStrings.CONSUME, GDatatab_item["id_" .. costData[1]].icon, costData[2])
		end
		ftxtBreakCost:setShowText(strContent)
	end
end

--@brief 	  显示货币数量
function WndServersSure:_showCoinNum()
	local txtCoinNum = GetElement(self.m_root, "txtCoinNum_WndServersSure", WZUILabelTTF)
	if txtCoinNum then 
		local nNum = CacheCenter:getPlayerItemCountById(161021)
		txtCoinNum:setText(nNum)
	end
end

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin----------------------------------------

function WndServersSure:_adaptLanguage_vn()
	GetElement(self.m_root, "txtPrgWord_WndServersSure", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.05,0.5))
end

-------------------------------------语言适配End----------------------------------------
