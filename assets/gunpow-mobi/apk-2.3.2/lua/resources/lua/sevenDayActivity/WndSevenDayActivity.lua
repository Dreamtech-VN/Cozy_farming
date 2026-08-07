--WndSevenDayActivity.lua
--@brief	WndSevenDayActivity的UI模块
--@date		2017/12/19
--@author	Tianxiang_Xu
--@note		七天乐活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSevenDayActivity:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSevenDayActivity:onExit(element)
	self.m_root:disableSchedule()
	self:_unInit()
end

--@brief 	界面加载完成回调
function WndSevenDayActivity:onEnterTransitionDidFinish(element)
	-- body
	self:setConfigTabText()
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetOpenServerTask()
end

--@brief 	显示
function WndSevenDayActivity:showWindow()
	-- body
	local nCurTime = SystemTime:getServerTime()
	if self.m_nCurSelDayIndex == nil then self.m_nCurSelDayIndex = 1 end
	if self.m_nCurSelTopIndex == nil then self.m_nCurSelTopIndex = 1 end 
	
	self:_createLeftMenuList()
	if self.m_tActivityType[self.m_nCurSelTopIndex] == 4 then 
		self:_showBuyLimit()
	else
		self:_showTaskList()
	end
	self:_setTopCheckBox()
	self:_showActivityTime()
	self.m_root:enableSchedule("_showActivityTime", 1)
end

--@brief 	点击关闭按钮回调
function WndSevenDayActivity:onCloseClick(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	WindowManager:removeWindow(self.m_root , self , true)
end

--@brief 	点击天数按钮回调
function WndSevenDayActivity:onClickDayBtn(nDayIndex)
	-- body
	if self.m_nCurSelDayIndex == nDayIndex then return end 

	local nCurTime = SystemTime:getServerTime()
	if nCurTime - self.m_nCreateRoleTime >= (nDayIndex - 1) * 24 * 3600 then 
		self.m_tLeftMenuCell[self.m_nCurSelDayIndex]:isItemHighLighted(false)
		self.m_nCurSelDayIndex = nDayIndex 
		self.m_tLeftMenuCell[self.m_nCurSelDayIndex]:isItemHighLighted(true)
		--右边内容刷新为相应的标签的第nDayIndex天的内容
		if self.m_tActivityType[self.m_nCurSelTopIndex] == 4 then 
			self:_showBuyLimit()
		else
			self:_showTaskList()
		end

		self:_setTopCheckBox()
	else
		MsgBoxManager:showTipBox(string.format(LocalStrings.SEVENDAY_TEXT2, nDayIndex))
	end 
end

--@brief 	点击顶部标签回调
function WndSevenDayActivity:onClickTab(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if self.m_nCurSelTopIndex == nTag then return end 
	
	self.m_nCurSelTopIndex = nTag 
	--刷新右边内容
	if self.m_tActivityType[self.m_nCurSelTopIndex] == 4 then 
		self:_showBuyLimit()
	else
		self:_showTaskList()
	end
end

--@brief	点击购买按钮回调
function WndSevenDayActivity:onClickBuy(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local tTempData = self.m_tLimitBuyList[self.m_nCurSelDayIndex]
	if not JudgeMoneyIsEnough(tTempData.priceId, tTempData.curPrice, nil, nil, nWindowId, nil, nil, nil, nil, self, self.sureUseDiamondInstead) then 
		return 
	end

	self:sureUseDiamondInstead()
end

--@brief 	确定用钻石代替粉钻购买
function WndSevenDayActivity:sureUseDiamondInstead()
	-- body
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_BuyOpenServerShop(self.m_tLimitBuyList[self.m_nCurSelDayIndex].id)
end

--@brief 	点击物品回调
function WndSevenDayActivity:onCLickItem(tCell, tag, tData)
	-- body
	WndItemInfo:showInfo(tCell.m_root, WndSevenDayActivity.m_root, 1, tData, false)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	创建左边菜单列表
function WndSevenDayActivity:_createLeftMenuList()
	-- body
	local tbActivityItem = GetElement(self.m_root, "tbActivityItem_WndSevenDayActivity", WZUITableContainer)
	tbActivityItem:cleanTable()

	local nCurTime = SystemTime:getServerTime()
	local nDay = self:getConfigDays()
	for i = 1, nDay do
		local element, tNewObj = CellSevenDayItem:createElement()
		if element and tNewObj then 
			element:setTag(i - 1)
			tNewObj:setTitle(LocalStrings.SEVENDAY_TEXT1[i], i)
			tNewObj:setCallBack(self, self.onClickDayBtn)
			tbActivityItem:setCellElement(element)
			if nCurTime - self.m_nCreateRoleTime >= (i - 1) * 24 * 3600 then
				tNewObj:setRedDot(self.m_tDayMenuRedDot[i])
			else
				tNewObj:setRedDot(false)
			end
			if i == self.m_nCurSelDayIndex then 
				tNewObj:isItemHighLighted(true)
			end
			self.m_tLeftMenuCell[i] = tNewObj 
		end
	end
end

--@brief	设置顶部标签
function WndSevenDayActivity:_setTopCheckBox()
	-- body
	WZLog("WndSevenDayActivity:_setTopCheckBox", Serialize(self.m_tActivityType), Serialize(self.m_tTopTabText))
	for i = 1, #self.m_tActivityType do 
		WZLog("WndSevenDayActivity:_setTopCheckBox", i)
		local checkBox = GetElement(self.m_root, "checkBox" .. i .. "_WndSevenDayActivity", WZUICheckBox)
		checkBox:setVisible(true)
		local txtCheckBox = GetElement(self.m_root, "txtCheckBox" .. i .. "_WndSevenDayActivity", WZUILabelTTF)
		local txtCheckBoxSel = GetElement(self.m_root, "txtCheckBoxSel" .. i .. "_WndSevenDayActivity", WZUILabelTTF)
		if self.m_tActivityType[i] == 4 then
			txtCheckBox:setText(LocalStrings.SEVENDAY_TEXT3[self.m_tActivityType[i]])
			txtCheckBoxSel:setText(LocalStrings.SEVENDAY_TEXT3[self.m_tActivityType[i]])
		else
			txtCheckBox:setText(self.m_tTopTabText[self.m_nCurSelDayIndex][self.m_tActivityType[i]])
			txtCheckBoxSel:setText(self.m_tTopTabText[self.m_nCurSelDayIndex][self.m_tActivityType[i]])
		end
	end
end

--@brief 	显示任务奖励列表
function WndSevenDayActivity:_showTaskList()
	-- body
	GetElement(self.m_root, "conForBuyLimit_WndSevenDayActivity", WZUIContainer):setVisible(false)
	GetElement(self.m_root, "conForReward_WndSevenDayActivity", WZUIContainer):setVisible(true)

	local tbForList = GetElement(self.m_root, "tbForList_WndSevenDayActivity", WZUITableContainer)
	tbForList:cleanTable()
	local conForReward = GetElement(self.m_root, "conForReward_WndSevenDayActivity", WZUIContainer)

	local nType = self.m_tActivityType[self.m_nCurSelTopIndex]
	if self.m_tTaskList[self.m_nCurSelDayIndex] then 
		local tTaskData = self.m_tTaskList[self.m_nCurSelDayIndex][nType]

		if tTaskData and #tTaskData > 0 then
			removeShowPanelNullTip(conForReward)

			for i = 1, #tTaskData do
				local element, tNewObj = CellSevenDayTask:createElement()
				if element and tNewObj then 
					element:setTag(i - 1)
					tNewObj:setData(tTaskData[i])
					tbForList:setCellElement(element)
				end
			end
		else
			ShowPanelNullTip(conForReward)
		end
	else
		ShowPanelNullTip(conForReward)
	end

	--顶部标签红点
	self:setTopRedDot()
end

--@brief 	显示折扣限购的内容
function WndSevenDayActivity:_showBuyLimit()
	-- body
	GetElement(self.m_root, "conForBuyLimit_WndSevenDayActivity", WZUIContainer):setVisible(true)
	GetElement(self.m_root, "conForReward_WndSevenDayActivity", WZUIContainer):setVisible(false)

	local conForItem = GetElement(self.m_root, "conForItem_WndSevenDayActivity", WZUIContainer)
	if conForItem:getChildByTag(99) then 
		conForItem:removeChildByTag(99, true)
	end
	local tTempData = self.m_tLimitBuyList[self.m_nCurSelDayIndex]
	if tTempData == nil then return end 

	local element, tNewObj = CellGoodItem:createElement()
	if element and tNewObj then 
		tNewObj:setCellGoodLocalId(tTempData.itemId, tTempData.itemNum, 4)
		tNewObj:setItemClickFun(self, self.onCLickItem)
		conForItem:addChild(element, 0, 99)
	end

	--物品的名字
	local tBasicInfo = GDatatab_item["id_" .. tTempData.itemId]
	local txtItemName = GetElement(self.m_root, "txtItemName_WndSevenDayActivity", WZUILabelTTF)
	if txtItemName then 
		txtItemName:setText(tBasicInfo.name)
		txtItemName:setColor(QUALITYCOLOR[tBasicInfo.quality])
	end
	--按钮
	self:_setBuyBtnState()
	--价格
	local ftxtOriginPrice = GetElement(self.m_root, "ftxtOriginPrice_WndSevenDayActivity", WZUIFreeTextBox)
	local ftxtCurPrice = GetElement(self.m_root, "ftxtCurPrice_WndSevenDayActivity", WZUIFreeTextBox)
	local sFormat = [[<T C="233,166,62" S="22" P="1" SC="79,60,48" SE="1" SS="4">%s:</T><T C="233,166,62" S="22" P="1" SC="79,60,48" SE="1" SS="4">%d</T><I P="1" Z="0.45">%s</I>]]
	local tPriceBasicInfo = GDatatab_item["id_" .. tTempData.priceId]
	if ftxtOriginPrice then 
		ftxtOriginPrice:setShowText(string.format(sFormat, LocalStrings.LIMITE_BUY_ORIGINPRICE, tTempData.originPrice, tPriceBasicInfo.icon))
	end

	if ftxtCurPrice then 
		ftxtCurPrice:setShowText(string.format(sFormat, LocalStrings.LIMITE_BUY_CURPRICE, tTempData.curPrice, tPriceBasicInfo.icon))
	end

	--顶部标签红点
	self:setTopRedDot()
end

--@brief 	设置顶部标签栏红点
function WndSevenDayActivity:setTopRedDot()
	--body
	for i = 1, 4 do
		local imgRedDot = GetElement(self.m_root, "imgRedDot" .. i .. "_WndSevenDayActivity", WZUIImage)
		if imgRedDot then 
			imgRedDot:setVisible(false)
		end
	end

	local tTempData = self.m_tTaskList[self.m_nCurSelDayIndex]
	local tRedDotMak = {}
	for i = 1, #self.m_tActivityType do 
		tRedDotMak[self.m_tActivityType[i]] = false
	end

	if tTempData then 
		for i, value in pairs(tTempData) do
			if type(value) == "table" then
				for j= 1, #value do
					if value[j] and value[j].state == 1 and tRedDotMak[value[j].type] == false then 
						tRedDotMak[value[j].type] = true
						break 
					end
				end
			end
		end
	end
	local bDayRedDot = false 
	for i = 1, 4 do
		if tRedDotMak[self.m_tActivityType[i]] then
			local imgRedDot = GetElement(self.m_root, "imgRedDot" .. i .. "_WndSevenDayActivity", WZUIImage)
			imgRedDot:setVisible(true)
			bDayRedDot = true
		end
	end
	--设置左边菜单红点
	if self.m_tLeftMenuCell and self.m_tLeftMenuCell[self.m_nCurSelDayIndex] then 
		self.m_tLeftMenuCell[self.m_nCurSelDayIndex]:setRedDot(bDayRedDot)
	end
end

--@brief 	设置折扣限购界面购买按钮的状态
function WndSevenDayActivity:_setBuyBtnState()
	-- body
	local tTempData = self.m_tLimitBuyList[self.m_nCurSelDayIndex]
	if tTempData == nil then return end 

	local btnBuy = GetElement(self.m_root, "btnBuy_WndSevenDayActivity", WZUIButton)
	if tTempData.leftTimes == 0 then 
		btnBuy:setTouchEnable(false)
	else
		btnBuy:setTouchEnable(true)
	end
end

--@brief 	展示活动结束倒计时和领奖倒计时
function WndSevenDayActivity:_showActivityTime()
	-- body
	local ftxtActivityLeftTime = GetElement(self.m_root, "ftxtActivityLeftTime_WndSevenDayActivity", WZUIFreeTextBox)
	local ftxtGetRewardTime = GetElement(self.m_root, "ftxtGetRewardTime_WndSevenDayActivity", WZUIFreeTextBox)
	local nCurTime = SystemTime:getServerTime()

	--是否在界面跨天
	local nCurDay = math.floor((nCurTime - self.m_nCreateRoleTime)/(24 * 3600)) + 1
	if nCurDay > self.m_nOriginDay then 
		self.m_nOriginDay = nCurDay
		if self.m_tLeftMenuCell[self.m_nOriginDay] then 
			self.m_tLeftMenuCell[self.m_nOriginDay]:setRedDot(self.m_tDayMenuRedDot[self.m_nOriginDay])
		end
	end
	--活动结束时间
	local nLeftTime = self.m_nEndTime - nCurTime
	local sFormat = [[<T C="255,227,116" S="16" P="1" SC="132,66,29" SE="1" SS="4">%s</T>]]
	if nLeftTime <= 0 then 
		local sTempAtt = string.format(sFormat, LocalStrings.COMMUNITY_COMPETE_TEXT25)
		ftxtActivityLeftTime:setShowText(LocalStrings.SEVENDAY_TEXT4 .. sTempAtt)
	else
		local nDay = math.floor(nLeftTime/(24 * 3600))
		local nHour = math.floor((nLeftTime - nDay * 24 *3600)/3600)
		local nMin = math.floor((nLeftTime - nDay * 24 *3600 - nHour * 3600)/60)
		local nSceonds = nLeftTime - nDay * 24 *3600 - nHour * 3600 - nMin * 60
		local sTempAtt = string.format(LocalStrings.SEVENDAY_TEXT6, nDay, nHour, nMin, nSceonds)
		ftxtActivityLeftTime:setShowText(LocalStrings.SEVENDAY_TEXT4 .. sTempAtt)
	end
	--领奖结束时间
	nLeftTime = self.m_nEndRewardTime - nCurTime
	if nLeftTime > 0 then 
		local nDay = math.floor(nLeftTime/(24 * 3600))
		local nHour = math.floor((nLeftTime - nDay * 24 *3600)/3600)
		local nMin = math.floor((nLeftTime - nDay * 24 *3600 - nHour * 3600)/60)
		local nSceonds = nLeftTime - nDay * 24 *3600 - nHour * 3600 - nMin * 60
		local sTempAtt = string.format(LocalStrings.SEVENDAY_TEXT6, nDay, nHour, nMin, nSceonds)
		ftxtGetRewardTime:setShowText(LocalStrings.SEVENDAY_TEXT5 .. sTempAtt)
	else
		self.m_root:disableSchedule()
		WindowManager:removeWindow(self.m_root , self , true)
	end
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin--------------------------------------------
function WndSevenDayActivity:_adaptLanguage_vn(  )
	for i=1,4 do
		local txtCheckBox = GetElement(self.m_root,"txtCheckBox"..i.."_WndSevenDayActivity",WZUILabelTTF)
		txtCheckBox:setScale(0.6)
		local txtCheckBoxSel = GetElement(self.m_root,"txtCheckBoxSel"..i.."_WndSevenDayActivity",WZUILabelTTF)
		txtCheckBoxSel:setScale(0.6)
	end
	local ftxtActivityLeftTime = GetElement(self.m_root,"ftxtActivityLeftTime_WndSevenDayActivity",WZUIFreeTextBox)
	ftxtActivityLeftTime:setScale(0.7)
	local ftxtGetRewardTime = GetElement(self.m_root,"ftxtGetRewardTime_WndSevenDayActivity",WZUIFreeTextBox)
	ftxtGetRewardTime:setScale(0.7)
end

function WndSevenDayActivity:_adaptLanguage_en(  )
	GetElement(self.m_root,"txtCheckBox1_WndSevenDayActivity",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtCheckBoxSel1_WndSevenDayActivity",WZUILabelTTF):setScale(0.8)

	GetElement(self.m_root,"txtCheckBox4_WndSevenDayActivity",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtCheckBoxSel4_WndSevenDayActivity",WZUILabelTTF):setScale(0.8)

	local txtCheckBox2 = GetElement(self.m_root,"txtCheckBox2_WndSevenDayActivity",WZUILabelTTF)
	txtCheckBox2:setScale(0.7)
	txtCheckBox2:setDimensions(GlobalMethod:CCSize(120,0))

	local txtCheckBoxSel2 = GetElement(self.m_root,"txtCheckBoxSel2_WndSevenDayActivity",WZUILabelTTF)
	txtCheckBoxSel2:setScale(0.7)
	txtCheckBoxSel2:setDimensions(GlobalMethod:CCSize(120,0))

	local txtCheckBox3 = GetElement(self.m_root,"txtCheckBox3_WndSevenDayActivity",WZUILabelTTF)
	txtCheckBox3:setScale(0.7)
	txtCheckBox3:setDimensions(GlobalMethod:CCSize(120,0))

	local txtCheckBoxSel3 = GetElement(self.m_root,"txtCheckBoxSel3_WndSevenDayActivity",WZUILabelTTF)
	txtCheckBoxSel3:setScale(0.7)
	txtCheckBoxSel3:setDimensions(GlobalMethod:CCSize(120,0))
end

function WndSevenDayActivity:_adaptLanguage_th(  )
	GetElement(self.m_root,"txtCheckBox1_WndSevenDayActivity",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtCheckBoxSel1_WndSevenDayActivity",WZUILabelTTF):setScale(0.8)

	local txtCheckBox2 = GetElement(self.m_root,"txtCheckBox2_WndSevenDayActivity",WZUILabelTTF)
	txtCheckBox2:setScale(0.8)

	local txtCheckBoxSel2 = GetElement(self.m_root,"txtCheckBoxSel2_WndSevenDayActivity",WZUILabelTTF)
	txtCheckBoxSel2:setScale(0.8)

	local txtCheckBox3 = GetElement(self.m_root,"txtCheckBox3_WndSevenDayActivity",WZUILabelTTF)
	txtCheckBox3:setScale(0.8)

	local txtCheckBoxSel3 = GetElement(self.m_root,"txtCheckBoxSel3_WndSevenDayActivity",WZUILabelTTF)
	txtCheckBoxSel3:setScale(0.8)
end

function WndSevenDayActivity:_adaptLanguage_pt(  )
	local txtCheckBox1 = GetElement(self.m_root, "txtCheckBox1_WndSevenDayActivity", WZUILabelTTF)
	txtCheckBox1:setScale(0.8)
	txtCheckBox1:setDimensions(GlobalMethod:CCSize(110))
	txtCheckBox1:setRelativePosition(GlobalMethod:ccp(0.5,0.53))
	local txtCheckBoxSel1 = GetElement(self.m_root, "txtCheckBoxSel1_WndSevenDayActivity", WZUILabelTTF)
	txtCheckBoxSel1:setScale(0.8)
	txtCheckBoxSel1:setDimensions(GlobalMethod:CCSize(110))
	txtCheckBoxSel1:setRelativePosition(GlobalMethod:ccp(0.5,0.53))
	local txtCheckBox2 = GetElement(self.m_root, "txtCheckBox2_WndSevenDayActivity", WZUILabelTTF)
	txtCheckBox2:setScale(0.8)
	txtCheckBox2:setDimensions(GlobalMethod:CCSize(110))
	txtCheckBox2:setRelativePosition(GlobalMethod:ccp(0.5,0.53))
	local txtCheckBoxSel2 = GetElement(self.m_root, "txtCheckBoxSel2_WndSevenDayActivity", WZUILabelTTF)
	txtCheckBoxSel2:setScale(0.8)
	txtCheckBoxSel2:setDimensions(GlobalMethod:CCSize(110))
	txtCheckBoxSel2:setRelativePosition(GlobalMethod:ccp(0.5,0.53))
	local txtCheckBox3 = GetElement(self.m_root, "txtCheckBox3_WndSevenDayActivity", WZUILabelTTF)
	txtCheckBox3:setScale(0.8)
	txtCheckBox3:setDimensions(GlobalMethod:CCSize(110))
	txtCheckBox3:setRelativePosition(GlobalMethod:ccp(0.5,0.53))
	local txtCheckBoxSel3 = GetElement(self.m_root, "txtCheckBoxSel3_WndSevenDayActivity", WZUILabelTTF)
	txtCheckBoxSel3:setScale(0.8)
	txtCheckBoxSel3:setDimensions(GlobalMethod:CCSize(110))
	txtCheckBoxSel3:setRelativePosition(GlobalMethod:ccp(0.5,0.53))
	local txtCheckBox4 = GetElement(self.m_root, "txtCheckBox4_WndSevenDayActivity", WZUILabelTTF)
	txtCheckBox4:setScale(0.8)
	txtCheckBox4:setDimensions(GlobalMethod:CCSize(110))
	txtCheckBox4:setRelativePosition(GlobalMethod:ccp(0.5,0.53))
	local txtCheckBoxSel4 = GetElement(self.m_root, "txtCheckBoxSel4_WndSevenDayActivity", WZUILabelTTF)
	txtCheckBoxSel4:setScale(0.8)
	txtCheckBoxSel4:setDimensions(GlobalMethod:CCSize(110))
	txtCheckBoxSel4:setRelativePosition(GlobalMethod:ccp(0.5,0.53))

	local ftxtActivityLeftTime = GetElement(self.m_root,"ftxtActivityLeftTime_WndSevenDayActivity",WZUIFreeTextBox)
	ftxtActivityLeftTime:setMaxWidth(400)	
	ftxtActivityLeftTime:setScale(0.65)
	local ftxtGetRewardTime = GetElement(self.m_root,"ftxtGetRewardTime_WndSevenDayActivity",WZUIFreeTextBox)
	ftxtGetRewardTime:setMaxWidth(400)
	ftxtGetRewardTime:setScale(0.65)
end

function WndSevenDayActivity:_adaptLanguage_es(  )
	local txtCheckBox1 = GetElement(self.m_root, "txtCheckBox1_WndSevenDayActivity", WZUILabelTTF)
	txtCheckBox1:setScale(0.8)
	txtCheckBox1:setDimensions(GlobalMethod:CCSize(110))
	txtCheckBox1:setRelativePosition(GlobalMethod:ccp(0.5,0.53))
	local txtCheckBoxSel1 = GetElement(self.m_root, "txtCheckBoxSel1_WndSevenDayActivity", WZUILabelTTF)
	txtCheckBoxSel1:setScale(0.8)
	txtCheckBoxSel1:setDimensions(GlobalMethod:CCSize(110))
	txtCheckBoxSel1:setRelativePosition(GlobalMethod:ccp(0.5,0.53))
	local txtCheckBox2 = GetElement(self.m_root, "txtCheckBox2_WndSevenDayActivity", WZUILabelTTF)
	txtCheckBox2:setScale(0.8)
	txtCheckBox2:setDimensions(GlobalMethod:CCSize(110))
	txtCheckBox2:setRelativePosition(GlobalMethod:ccp(0.5,0.53))
	local txtCheckBoxSel2 = GetElement(self.m_root, "txtCheckBoxSel2_WndSevenDayActivity", WZUILabelTTF)
	txtCheckBoxSel2:setScale(0.8)
	txtCheckBoxSel2:setDimensions(GlobalMethod:CCSize(110))
	txtCheckBoxSel2:setRelativePosition(GlobalMethod:ccp(0.5,0.53))
	local txtCheckBox3 = GetElement(self.m_root, "txtCheckBox3_WndSevenDayActivity", WZUILabelTTF)
	txtCheckBox3:setScale(0.8)
	txtCheckBox3:setDimensions(GlobalMethod:CCSize(110))
	txtCheckBox3:setRelativePosition(GlobalMethod:ccp(0.5,0.53))
	local txtCheckBoxSel3 = GetElement(self.m_root, "txtCheckBoxSel3_WndSevenDayActivity", WZUILabelTTF)
	txtCheckBoxSel3:setScale(0.8)
	txtCheckBoxSel3:setDimensions(GlobalMethod:CCSize(110))
	txtCheckBoxSel3:setRelativePosition(GlobalMethod:ccp(0.5,0.53))
	local txtCheckBox4 = GetElement(self.m_root, "txtCheckBox4_WndSevenDayActivity", WZUILabelTTF)
	txtCheckBox4:setScale(0.8)
	txtCheckBox4:setDimensions(GlobalMethod:CCSize(110))
	txtCheckBox4:setRelativePosition(GlobalMethod:ccp(0.5,0.53))
	local txtCheckBoxSel4 = GetElement(self.m_root, "txtCheckBoxSel4_WndSevenDayActivity", WZUILabelTTF)
	txtCheckBoxSel4:setScale(0.8)
	txtCheckBoxSel4:setDimensions(GlobalMethod:CCSize(110))
	txtCheckBoxSel4:setRelativePosition(GlobalMethod:ccp(0.5,0.53))

	local ftxtActivityLeftTime = GetElement(self.m_root,"ftxtActivityLeftTime_WndSevenDayActivity",WZUIFreeTextBox)
	ftxtActivityLeftTime:setMaxWidth(400)	
	ftxtActivityLeftTime:setScale(0.65)
	local ftxtGetRewardTime = GetElement(self.m_root,"ftxtGetRewardTime_WndSevenDayActivity",WZUIFreeTextBox)
	ftxtGetRewardTime:setMaxWidth(400)
	ftxtGetRewardTime:setScale(0.65)

	GetElement(self.m_root, "ftxtOriginPrice_WndSevenDayActivity", WZUIFreeTextBox):setScale(0.73)
	GetElement(self.m_root, "ftxtCurPrice_WndSevenDayActivity", WZUIFreeTextBox):setScale(0.73)
end

function WndSevenDayActivity:_adaptLanguage_tr(  )
	local txtCheckBox1 = GetElement(self.m_root, "txtCheckBox1_WndSevenDayActivity", WZUILabelTTF)
	txtCheckBox1:setScale(0.8)
	txtCheckBox1:setDimensions(GlobalMethod:CCSize(110))
	txtCheckBox1:setRelativePosition(GlobalMethod:ccp(0.5,0.53))
	local txtCheckBoxSel1 = GetElement(self.m_root, "txtCheckBoxSel1_WndSevenDayActivity", WZUILabelTTF)
	txtCheckBoxSel1:setScale(0.8)
	txtCheckBoxSel1:setDimensions(GlobalMethod:CCSize(110))
	txtCheckBoxSel1:setRelativePosition(GlobalMethod:ccp(0.5,0.53))
	local txtCheckBox2 = GetElement(self.m_root, "txtCheckBox2_WndSevenDayActivity", WZUILabelTTF)
	txtCheckBox2:setScale(0.8)
	txtCheckBox2:setDimensions(GlobalMethod:CCSize(110))
	txtCheckBox2:setRelativePosition(GlobalMethod:ccp(0.5,0.53))
	local txtCheckBoxSel2 = GetElement(self.m_root, "txtCheckBoxSel2_WndSevenDayActivity", WZUILabelTTF)
	txtCheckBoxSel2:setScale(0.8)
	txtCheckBoxSel2:setDimensions(GlobalMethod:CCSize(110))
	txtCheckBoxSel2:setRelativePosition(GlobalMethod:ccp(0.5,0.53))
	local txtCheckBox3 = GetElement(self.m_root, "txtCheckBox3_WndSevenDayActivity", WZUILabelTTF)
	txtCheckBox3:setScale(0.8)
	txtCheckBox3:setDimensions(GlobalMethod:CCSize(110))
	txtCheckBox3:setRelativePosition(GlobalMethod:ccp(0.5,0.53))
	local txtCheckBoxSel3 = GetElement(self.m_root, "txtCheckBoxSel3_WndSevenDayActivity", WZUILabelTTF)
	txtCheckBoxSel3:setScale(0.8)
	txtCheckBoxSel3:setDimensions(GlobalMethod:CCSize(110))
	txtCheckBoxSel3:setRelativePosition(GlobalMethod:ccp(0.5,0.53))
	local txtCheckBox4 = GetElement(self.m_root, "txtCheckBox4_WndSevenDayActivity", WZUILabelTTF)
	txtCheckBox4:setScale(0.8)
	txtCheckBox4:setDimensions(GlobalMethod:CCSize(110))
	txtCheckBox4:setRelativePosition(GlobalMethod:ccp(0.5,0.53))
	local txtCheckBoxSel4 = GetElement(self.m_root, "txtCheckBoxSel4_WndSevenDayActivity", WZUILabelTTF)
	txtCheckBoxSel4:setScale(0.8)
	txtCheckBoxSel4:setDimensions(GlobalMethod:CCSize(110))
	txtCheckBoxSel4:setRelativePosition(GlobalMethod:ccp(0.5,0.53))

	local ftxtActivityLeftTime = GetElement(self.m_root,"ftxtActivityLeftTime_WndSevenDayActivity",WZUIFreeTextBox)
	ftxtActivityLeftTime:setMaxWidth(500)	
	ftxtActivityLeftTime:setScale(0.7)
	local ftxtGetRewardTime = GetElement(self.m_root,"ftxtGetRewardTime_WndSevenDayActivity",WZUIFreeTextBox)
	ftxtGetRewardTime:setMaxWidth(500)
	ftxtGetRewardTime:setScale(0.7)

	GetElement(self.m_root, "ftxtOriginPrice_WndSevenDayActivity", WZUIFreeTextBox):setScale(0.8)
	local ftxtCurPrice = GetElement(self.m_root, "ftxtCurPrice_WndSevenDayActivity", WZUIFreeTextBox)
	ftxtCurPrice:setScale(0.8)
	ftxtCurPrice:setRelativePosition(GlobalMethod:ccp(0.5,0.646887))
end
-------------------------------------语言适配End----------------------------------------------
