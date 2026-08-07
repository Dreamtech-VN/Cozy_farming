--WndCastSoulUpgrade.lua
--@brief	WndCastSoulUpgrade的UI模块
--@date		2020/05/20
--@author	XTX
--@note		时装铸魂升级界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCastSoulUpgrade:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCastSoulUpgrade:onExit(element)
	self:_unInit()
end

--@brief    加载界面完成回调
function WndCastSoulUpgrade:onEnterTransitionDidFinish(element)
	--body
	if self.m_tData.basicInfo.sub_type == 4 or self.m_tData.basicInfo.sub_type ~= 4 and self.m_tData.basicInfo.gridId > 9 or self.m_nTabIndex == 3 then 
		local conOut = GetElement(self.m_root, "conOut_WndCastSoulUpgrade", WZUIContainer)
		conOut:setAbsContentSize(GlobalMethod:CCSize(330, 380))
		conOut:updateRelativeSize()
		local conCost = GetElement(self.m_root, "conCost_WndCastSoulUpgrade", WZUIContainer)
		conCost:setAbsContentSize(GlobalMethod:CCSize(320, 80))
		conCost:updateRelativeSize()
		conCost:setRelativePosition(GlobalMethod:ccp(0.5,0.32))
		GetElement(self.m_root, "img9Cost1_WndCastSoulUpgrade", WZUI9Image):setVisible(false)
		GetElement(self.m_root, "img9Cost2_WndCastSoulUpgrade", WZUI9Image):setVisible(true)
		GetElement(self.m_root, "ftxtCost_WndCastSoulUpgrade", WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.07, 0.7))
	end
	self:_update()
end

--@brief    点击关闭按钮回调
function WndCastSoulUpgrade:onClickClose(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief 	点击物品格子回调
function WndCastSoulUpgrade:onClickItem(luaTable, tag, tData)
	-- body
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
    
    WndItemInfo:showInfo(luaTable.m_root, self.m_root, 1, tData, false, nil, true)
end

--@brief 	点击升级按钮回调
function WndCastSoulUpgrade:onClickUpgrade(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = element:getTag()

	local maxLevel = WndDressCastSoul:getMaxLevelByItemId(self.m_tData.basicInfo.id)
	if self.m_tData.basicInfo.levelInfo.level >= maxLevel then 
		MsgBoxManager:showTipBox(LocalStrings.PROFESSION_TEXT15)
		return 
	end

	if tag == 5 then
		self.m_fiveNum = self.m_nCanUpgrade
	end

	local costList = self.m_tData.basicInfo.levelInfo.exp
	WZLog("WndCastSoulUpgrade:onClickUpgrade",self.m_tData.basicInfo.levelInfo.level)
	local haveNum = CacheCenter:getPlayerItemCountById(self.m_tData.basicInfo.id)
	WZLog("WndCastSoulUpgrade:onClickUpgrade ii",self.m_fiveNum, haveNum)
	local nType = 0 
	if self.m_nTabIndex == 3 then 
		nType = 1
	end
	if tag == 5 then 
		local number1 = 0
		local number2 = 0
		for i = 1,self.m_fiveNum do
			for k,v in pairs(GDatatab_spirit) do
				local tExp = v.exp
				if self.m_tData.basicInfo.sub_type ~= 4 and self.m_tData.basicInfo.gridId > 9 or self.m_tData.basicInfo.sub_type == 4 and self.m_tData.basicInfo.gridId > 3 or self.m_nTabIndex == 3 then
					tExp = v.exp2
				end
				if v.item_id == self.m_tData.basicInfo.id and v.level == self.m_tData.basicInfo.levelInfo.level + i -1 and v.type == nType then
					number1 = number1 + tExp[1][2]
					break
				end
			end
			WZLog("WndCastSoulUpgrade:onClickUpgrade iiii", i, number1)
			if number1 == haveNum then
				number2 = i
				break
			elseif number1 > haveNum then
				number2 = i - 1
				break
			else
				number2 = i
			end
		end

		local num3 = math.max(number2,1)

		local num1 = 0
		local num2 = 0
		for i = 1,num3 do
			for k,v in pairs(GDatatab_spirit) do
				local tExp = v.exp
				if self.m_tData.basicInfo.sub_type ~= 4 and self.m_tData.basicInfo.gridId > 9 or self.m_tData.basicInfo.sub_type == 4 and self.m_tData.basicInfo.gridId > 3 or self.m_nTabIndex == 3 then
					tExp = v.exp2
				end
				if v.item_id == self.m_tData.basicInfo.id and v.level == self.m_tData.basicInfo.levelInfo.level + i -1 and v.type == nType then
					num1 = num1 + tExp[1][2]
					num2 = num2 + tExp[2][2]
				end
			end
		end
		WZLog("WndCastSoulUpgrade:onClickUpgrade iii", num1, num2, num3)
		if not JudgeMoneyIsEnough(costList[1][1], num1, nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureToUseOtherInstead) then
			self.m_fiveNum = 1
			return 
		end
		if not JudgeMoneyIsEnough(costList[2][1], num2, nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureToUseOtherInstead) then
			self.m_fiveNum = 1
			return 
		end
	else 
		for i = 1, #costList do
			if not JudgeMoneyIsEnough(costList[i][1], costList[i][2], nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureToUseOtherInstead) then
				return 
			end
		end
	end
	self:sureToUseOtherInstead()

end

function WndCastSoulUpgrade:updateLogTime()
    local conLog = GetElement(self.m_root,"conLog_WndCastSoulUpgrade",WZUIContainer)
    conLog:disableSchedule()
    self.logTime = 0
end
function WndCastSoulUpgrade:updateUpLog(num, result, nCurLevel)
	local conLog = GetElement(self.m_root, "conLog_WndCastSoulUpgrade", WZUIContainer)
	conLog:setVisible(true)
	conLog:setScale(0)

	local disTime = 0.3
	local tData = {}
	local num1 = 0
	local num2 = 0
	local currentLv = nCurLevel
	for i = 1,5 do
		local ftb = GetElement(self.m_root,"tfbLog"..i.."_WndCastSoulUpgrade",WZUIFreeTextBox):setVisible(false)
	end
	local nType = 0 
	if self.m_nTabIndex == 3 then 
		nType = 1
	end
	for i = 1, num do
		local ftb = GetElement(self.m_root,"tfbLog"..i.."_WndCastSoulUpgrade",WZUIFreeTextBox)
		for k,v in pairs(GDatatab_spirit) do
			local tExp = v.exp
			if self.m_tData.basicInfo.sub_type ~= 4 and self.m_tData.basicInfo.gridId > 9 or self.m_tData.basicInfo.sub_type == 4 and self.m_tData.basicInfo.gridId > 3 or self.m_nTabIndex == 3 then
				tExp = v.exp2
			end
			if v.item_id == self.m_tData.basicInfo.id and v.level == currentLv and v.type == nType then
				num1 = num1 + tExp[1][2]
				num2 = num2 + tExp[2][2]
				-- MOUNT_UP_LOG5 = [[<T C="195,171,148" S="22" P="0">第%d次升级，%d->%d，消耗%d金币，消耗%d元魂</T>]],
				local tempContent = string.format(LocalStrings.MOUNT_UP_LOG5,i,currentLv,currentLv + 1,tExp[2][2],tExp[1][2])
				if self.m_tData.basicInfo.sub_type == 4 or self.m_tData.basicInfo.sub_type ~= 4 and self.m_tData.basicInfo.gridId > 9 or self.m_nTabIndex == 3 then 
					local resultText = ""
					if result[i] == 0 then 
						resultText = string.format([[<T C="5,180,0" S="20" P="0">,%s</T>]], LocalStrings.NEWSKILL14)
						currentLv = currentLv + 1
					else
						resultText = string.format([[<T C="255,89,74" S="20" P="0">,%s</T>]], LocalStrings.STAR_SOUL_LIGHT_FAIL)
					end
					tempContent = tempContent .. resultText
				else
					currentLv = currentLv + 1
				end
				ftb:setShowText(tempContent)
				break 
			end
		end
        ftb:setScale(0)
        ftb:setVisible(true)
        local act1 = CCDelayTime:create(0.1+disTime*i)
        local act2 = CCScaleTo:create(0,1)
        local act = CCSequence:createWithTwoActions(act1,act2)
        ftb:runAction(act)
	end
	local ftb = GetElement(self.m_root,"tfbLog6_WndCastSoulUpgrade",WZUIFreeTextBox)
	ftb:setShowText(string.format(LocalStrings.MOUNT_UP_LOG6,num,num2,num1))
    ftb:setScale(0)
    local act1 = CCDelayTime:create(0.1+disTime*(num+1))
    local act2 = CCScaleTo:create(0,1)
    local act = CCSequence:createWithTwoActions(act1,act2)
    ftb:runAction(act)

    local act1 = CCScaleTo:create(0.1,1)
    conLog:runAction(act1)

    self.logTime = disTime*(num+1)+0.1
    conLog:enableSchedule("updateLogTime",self.logTime)
end

function WndCastSoulUpgrade:onTouchBegin()
    if self.logTime == 0 then
        local conLog = GetElement(self.m_root,"conLog_WndCastSoulUpgrade",WZUIContainer)
        conLog:setVisible(false)
    end
end

--@brief 	确认使用其他物品代替
function WndCastSoulUpgrade:sureToUseOtherInstead()
	-- body
	local yType = self.m_nTabIndex
	if self.m_nTabIndex == 3 then 
		yType = 5 
	end
	if self.m_nTabIndex == 1 and self.m_tData.basicInfo.sub_type == 4 then 
		yType = 3
	elseif self.m_nTabIndex == 2 and self.m_tData.basicInfo.sub_type == 4 then 
		yType = 4
	elseif self.m_nTabIndex == 3 and self.m_tData.basicInfo.sub_type == 4 then 
		yType = 6
	end
	WZLog("WndCastSoulUpgrade:sureToUseOtherInstead",yType, self.m_tData.basicInfo.gridId, self.m_fiveNum)
	ProtocolProcessorRecycling:send_PLAYERITEM_CastSoul(yType, 2, self.m_tData.basicInfo.gridId - 1,0,self.m_fiveNum)
	self.m_fiveNum = 1
end

--@brief 关闭升级显示页面
function WndCastSoulUpgrade:onCloseResult()
	-- body
	GetElement(self.m_root,"conLog_WndCastSoulUpgrade",WZUIContainer):setVisible(false)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndCastSoulUpgrade:_update()
	-- body
	--图标
	local canUpdate = 5
	local maxLevel = WndDressCastSoul:getMaxLevelByItemId(self.m_tData.basicInfo.id)
	if maxLevel - self.m_tData.basicInfo.levelInfo.level >= 5 then
		canUpdate = 5
	else 
		canUpdate = maxLevel - self.m_tData.basicInfo.levelInfo.level
	end

	local haveNum = CacheCenter:getPlayerItemCountById(self.m_tData.basicInfo.id)
	local num1 = 0
	local num2 = canUpdate
	local nType = 0 
	if self.m_nTabIndex == 3 then 
		nType = 1
	end
	for i = 1,canUpdate do
		for k,v in pairs(GDatatab_spirit) do
			local tExp = v.exp
			if self.m_tData.basicInfo.sub_type ~= 4 and self.m_tData.basicInfo.gridId > 9 or self.m_tData.basicInfo.sub_type == 4 and self.m_tData.basicInfo.gridId > 3 or self.m_nTabIndex == 3 then
				tExp = v.exp2
			end
			if v.item_id == self.m_tData.basicInfo.id and v.level == self.m_tData.basicInfo.levelInfo.level + i -1 and nType == v.type then
				num1 = num1 + tExp[1][2]
				break
			end
		end
		if num1 == haveNum then
			num2 = i
			break
		elseif num1 > haveNum then
			num2 = i - 1
			break
		else
			num2 = i
		end
	end

	local num3 = math.max(num2,1)
	self.m_nCanUpgrade = num3
	for i = 1,3 do           
		local txtFive = GetElement(self.m_root, "txtFive"..i.."_WndCastSoulUpgrade",WZUILabelTTF)
		-- txtSpillExp:setText(string.format(LocalStrings.EXCHANGEEXP_TEXT4, self.m_nCurSpillExp))
		txtFive:setText(string.format(LocalStrings.STAR_SOUL_FIVE_UPDATE, num3))
	end
	local imgIcon = GetElement(self.m_root, "imgIcon_WndCastSoulUpgrade", WZUIImage)
	if imgIcon then 
		imgIcon:setFile(self.m_tData.basicInfo.levelInfo.icon)
	end
	local imgQualityRect = GetElement(self.m_root, "imgQualityRect_WndCastSoulUpgrade", WZUIImage)
	local qualityPic = {"ui/common/frame_green.png","ui/common/frame_bule.png","ui/common/frame_violet.png","ui/common/frame_orange.png","ui/common/common_scale9_beibaodi1.png"}
	if imgQualityRect then 
		imgQualityRect:setFile(qualityPic[self.m_tData.basicInfo.levelInfo.quality])
	end

	local txtName = GetElement(self.m_root, "txtName_WndCastSoulUpgrade", WZUILabelTTF)
	if txtName then 
		txtName:setText(LocalStrings.LV .. self.m_tData.basicInfo.levelInfo.level .. self.m_tData.basicInfo.name)
		txtName:setColor(QUALITYCOLOR[self.m_tData.basicInfo.levelInfo.quality])
	end
	--描述
	local txtDesc = GetElement(self.m_root, "txtDesc_WndCastSoulUpgrade", WZUILabelTTF)
	if txtDesc then 
		txtDesc:setText(self.m_tData.basicInfo.desc)
	end
	--属性
	local ftxtProperty = GetElement(self.m_root, "ftxtProperty_WndCastSoulUpgrade", WZUIFreeTextBox)
	local proFormat = [[<T C="127,70,26" S="20" P="1" SC="128,54,13" SS="4" SE="0">%s:</T><T C="5,180,0" S="20" P="1" SC="128,54,13" SS="4" SE="0">%d   </T>]]
	if ftxtProperty then 
		local proContent = ""
		if self.m_tData.basicInfo.sub_type == 4 then 
			proFormat = [[<T C="127,70,26" S="20" P="1" SC="128,54,13" SS="4" SE="0">%s:</T><T C="5,180,0" S="20" P="1" SC="128,54,13" SS="4" SE="0">%.02f%%   </T>]]
			local tempContent = string.format(proFormat, LocalStrings.CASTSOUL_TEXT24, self.m_tData.basicInfo.levelInfo.property * 100 / 10000)
			proContent = proContent .. tempContent
			self:showLucky()
		else
			for i = 1, #self.m_tData.basicInfo.levelInfo.property do
				local property = self.m_tData.basicInfo.levelInfo.property[i]
				local tempContent = string.format(proFormat, ATTR_TITLE[property[1]], property[2])
				proContent = proContent .. tempContent
				if self.m_tData.basicInfo.sub_type ~= 4 and self.m_tData.basicInfo.gridId > 9 or self.m_nTabIndex == 3 then
					self:showLucky()
				end
			end
		end
		ftxtProperty:setShowText(proContent)
	end

	local cost = self.m_tData.basicInfo.levelInfo.exp
	local ftxtCost = GetElement(self.m_root, "ftxtCost_WndCastSoulUpgrade", WZUIFreeTextBox)
	local costFormat = [[<I Z="0.5" P="1">%s</I><T C="229,105,22" S="20" P="1" SC="128,54,13" SS="4" SE="0">%d/%d   </T>]]
	local goldCostFormat = [[<I Z="0.5" P="1">%s</I><T C="229,105,22" S="20" P="1" SC="128,54,13" SS="4" SE="0">%d   </T>]]
	local contentCost = string.format([[<T C="127,70,26" S="20" P="1" SC="128,54,13" SS="4" SE="0">%s</T>]], LocalStrings.COST)
	if cost ~= -1 then 
		for i = 1, #cost do
			local haveNum = CacheCenter:getPlayerItemCountById(cost[i][1])
			local tempString = string.format(costFormat, GDatatab_item["id_" .. cost[i][1]].icon, haveNum, cost[i][2])
			if cost[i][1] == 2 then 
				tempString = string.format(goldCostFormat, GDatatab_item["id_" .. cost[i][1]].icon, cost[i][2])
			end

			contentCost = contentCost .. tempString 
		end

		ftxtCost:setShowText(contentCost)
		ftxtCost:setVisible(true)
	else
		ftxtCost:setVisible(false)
	end

	--获取下一级数据
	-- local nextData = self:getNextLevelData()
	-- local ftxtAtt = GetElement(self.m_root, "ftxtAtt_WndCastSoulUpgrade", WZUIFreeTextBox)
	-- if nextData then 
	-- 	if ftxtAtt then 
	-- 		ftxtAtt:setShowText(string.format(LocalStrings.CASTSOUL_TEXT19, nextData.level, ATTR_TITLE[nextData.property[1][1]], nextData.property[1][2]))
	-- 	end
	-- else
	-- 	local sMaxLevelFormat = [[<T C="255,227,116" S="20" P="1" SC="128,54,13" SS="4" SE="1">%s</T>]]
	-- 	ftxtAtt:setShowText(string.format(sMaxLevelFormat, LocalStrings.PROFESSION_TEXT15))
	-- 	GetElement(self.m_root, "btnUpgrade_WndCastSoulUpgrade", WZUIButton):setTouchEnable(false)
	-- end
end

--@brief 	显示幸运值
function WndCastSoulUpgrade:showLucky()
	GetElement(self.m_root, "conLucky_WndCastSoulUpgrade", WZUIContainer):setVisible(true)
	local txtLuckyValue = GetElement(self.m_root, "txtLuckyValue_WndCastSoulUpgrade", WZUILabelTTF)
	local txtCurLucky = GetElement(self.m_root, "txtCurLucky_WndCastSoulUpgrade", WZUILabelTTF)
	local percentage = math.floor(self.m_tData.basicInfo.lucky * 100/self.m_tData.basicInfo.levelInfo.luckeylimit)
	if percentage > 100 then 
		percentage = 100
	end
	if txtLuckyValue then 
		txtLuckyValue:setText(LocalStrings.LUCKY_NAME .. percentage .. "%")
		txtCurLucky:setText(self.m_tData.basicInfo.lucky .. "/" .. self.m_tData.basicInfo.levelInfo.luckeylimit)
	end
	GetElement(self.m_root, "prgLucky_WndCastSoulUpgrade", WZUIProgress):setPercentage(percentage)
	local ftxtRate = GetElement(self.m_root, "ftxtRate_WndCastSoulUpgrade", WZUIFreeTextBox)
	local rateFormat = [[<T C="255,236,193" S="20" P="1" SC="132,66,29" SS="4" SE="1">%s</T><T C="255,89,74" S="20" P="1" SC="132,66,29" SS="4" SE="1">%d%%</T>]]
	ftxtRate:setShowText(string.format(rateFormat, LocalStrings.MOUNTS_SUCCESS1, self.m_tData.basicInfo.levelInfo.rate))
end

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配begin----------------------------------------
function WndCastSoulUpgrade:_adaptLanguage_vn()
	local txtDesc = GetElement(self.m_root, "txtDesc_WndCastSoulUpgrade", WZUILabelTTF)
	txtDesc:setScale(0.75)
	txtDesc:setDimensions(GlobalMethod:CCSize(280))

	for i = 1, 5 do
		local ftb = GetElement(self.m_root,"tfbLog"..i.."_WndCastSoulUpgrade",WZUIFreeTextBox):setMaxWidth(700)
	end
end
-------------------------------------语言适配end----------------------------------------
