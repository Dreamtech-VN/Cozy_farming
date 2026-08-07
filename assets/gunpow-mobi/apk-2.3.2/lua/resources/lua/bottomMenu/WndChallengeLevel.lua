--WndChallengeLevel.lua
--@brief	WndChallengeLevel的UI模块
--@date		2014/01/15
--@author	林庆凯
--@note		发红包/收红包界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndChallengeLevel:onEnter(element)
	self.m_root = element
	--彩色喇叭
	ChangeChatChannel(Chat_Channel_FuChoice)

	--多语言版本界面适配
	AdaptLanguage(self)
end
--@brief onEnter函数执行完成回调
function WndChallengeLevel:onEnterTransitionDidFinish(element)
    --弹窗动画
    self:actionCallback()
end

--@brief    弹窗动画完成后的回调
function WndChallengeLevel:actionCallback(element, data)
	local redpackNumConfig = CacheCenter:getGameParam().redPacketNum
	local _string = string.sub(redpackNumConfig, 2, -2)
    self.m_tRedPackNumLimit = SplitStringWithSeparator(_string, ",", nil, true)
    local redDiaTotalNumConfig = CacheCenter:getGameParam().redPacketDiamond
	_string = string.sub(redDiaTotalNumConfig, 2, -2)
	self.m_tDiaTotalNumLimit = SplitStringWithSeparator(_string, ",", nil, true)
	local redGoldTotalNumConfig = CacheCenter:getGameParam().redPacketMoney
	_string = string.sub(redGoldTotalNumConfig, 2, -2)
	self.m_tGoldTotalNumLimit = SplitStringWithSeparator(_string, ",", nil, true)
--	WZLog("WndChallengeLevel:actionCallback", self.m_nWinType, redpackNumConfig, redDiaTotalNumConfig, redGoldTotalNumConfig)
	if self.m_nWinType == 3 then --红包雨
		self.m_tRedPackNumLimit = {self.m_tResultData[3], self.m_tResultData[4], 1}
		self.m_tDiaTotalNumLimit = {self.m_tResultData[5], self.m_tResultData[6], self.m_tResultData[7] or 100}
	end
	if self.m_nSelModel == 1 then 
		self.m_nTotalNum = self.m_tGoldTotalNumLimit[1]
	elseif self.m_nSelModel == 2 then 
		self.m_nTotalNum = self.m_tDiaTotalNumLimit[1]
	end
	self.m_nRedPackNum = self.m_tRedPackNumLimit[1]

	self.m_nUsingSkinId = self:getRedpackSkinId()

	--初始化UI静态文本
	self:_initStaticUiText()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndChallengeLevel:onExit(element)
	self:_unInit()
end

--@brief	关闭按钮点击时被调用的函数
--@param	element:表绑定的UI节点引用
function WndChallengeLevel:onCloseWindowBtn(element)
	if self.m_root ~= nil then 
		--音效
		SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

		self:closeWin()
	end 
end 

--@brief 	关闭发红包界面
function WndChallengeLevel:closeWin()
	self:saveRedpackSkinId()
    WindowManager:removeWindow(self.m_root, self, true)
    --关闭界面，如果有红包雨，显示
    ShowRedEnvelopesRain()
end


--@brief	确定按钮点击时被调用的函数
--@param	element:表绑定的UI节点引用
function WndChallengeLevel:onSureBtn(element)
	--音效
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local costId = self.m_tCoinType[self.m_nSelModel]
	if not JudgeMoneyIsEnough(costId, self.m_nTotalNum, nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureUseDiamondInstead) then
		return 
	end

	self:sureUseDiamondInstead()
end

--@brief 	发红包
function WndChallengeLevel:sureUseDiamondInstead()
	WZLog("WndChallengeLevel:sureUseDiamondInstead", self.m_nTotalNum, self.m_nRedPackNum)
	if self.m_nWinType == 3 then 
		local tData = {}
		tData.money = self.m_nTotalNum
		tData.num = self.m_nRedPackNum
		tData.wishWordsId = self.m_nBlessWordIndex
		tData.coverId = self.m_nUsingSkinId

		local stringData = json.encode(tData)

		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nChannelId, 9, stringData)
	else
		ProtocolProcessorGlobal:send_CHAT_SendRedEnvelope(self.m_nTotalNum, self.m_nRedPackNum, self.m_tCoinType[self.m_nSelModel], self.m_nBlessWordIndex, self.m_nUsingSkinId, self.m_nChannelId)
	end
end

--@brief	简单模式复选框选中后被调用的函数
--@param	element:表绑定的UI节点引用
function WndChallengeLevel:onCheckBox1(element)
	if self.m_nSelModel == 1 then 
		return 
	end
	--音效
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nSelModel = 1
	self.m_nTotalNum = self.m_tGoldTotalNumLimit[1]
	self:_setModelExplain()
end 


--@brief	困难模式复选框选中后被调用的函数
--@param	element:表绑定的UI节点引用
function WndChallengeLevel:onCheckBox2(element)
	if self.m_nSelModel == 2 then 
		return 
	end
	--音效
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nSelModel = 2
	self.m_nTotalNum = self.m_tDiaTotalNumLimit[1]
	self:_setModelExplain()
end 

--@brief 	点击感恩或吐槽按钮回调
function WndChallengeLevel:onClickOther(element)
	--body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local channelType = CHANNEL_WORLD
	if self.m_nChannelId == 1 then
		channelType = CHANNEL_GUILD
	end
	if self.m_nWinType ~= 4 then 
		if self.m_nStatus == 0 then 
			local nIndex = math.random(1, #LocalStrings.RED_PACK6)
			local tempText = string.format(LocalStrings.RED_PACK6[nIndex], self.m_tResultData.playerName)
			WndChat:showChatWindowForFightingByOrder(channelType, tempText)
		elseif self.m_nStatus == 1 then 
			local nIndex = math.random(1, #LocalStrings.RED_PACK5)
			local tempText = LocalStrings.RED_PACK5[nIndex]
			WndChat:showChatWindowForFightingByOrder(channelType, tempText)
		end
	end

	WindowManager:removeWindow(self.m_root, self, true)
	ShowRedEnvelopesRain()
end

--@brief 	点击更换皮肤回调
function WndChallengeLevel:onClickChangeSkin(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local conChooseSkin = GetElement(self.m_root, "conChooseSkin_WndChallengeLevel", WZUIContainer)
	local conGive = GetElement(self.m_root, "conGive_WndChallengeLevel", WZUIContainer)
	if conChooseSkin:isVisible() then 
		conChooseSkin:setVisible(false)
		conGive:setRelativePosition(GlobalMethod:ccp(0.5, 0.5))
	else
		conChooseSkin:setVisible(true)
		conGive:setRelativePosition(GlobalMethod:ccp(0.38, 0.5))
		self:_createSkinList()
	end
end

--@brief 	点击背景列表回调
function WndChallengeLevel:clickBgCellCallBack(element, tCell, tData)
	-- body
	if self.m_tCellClickBg then
		self.m_tCellLastClickBg = self.m_tCellClickBg
		self.m_tCellClickBg:setSelState(false)
	end

	self.m_tCellClickBg = tCell 
	self.m_tClickBgData = tData
	self.m_tCellClickBg:setSelState(true)

	local basicData = GDatatab_item["id_" .. tData.id]
	local function rtnState(itemId)
		-- body
		local state = -1 
		local nNum = 0
		if itemId == 0 then 
			state = 0 
		else
			nNum = CacheCenter:getPlayerItemCountById(itemId)
			if nNum > 0 then
				state = 0 
			end

			if basicData.property[1][1] == -1 then 
				if CacheCenter:getPlayerInfo().vipLevel >= basicData.property[1][2] then 
					state = 0
				end
			elseif basicData.property[1][1] == -2 then 
				local vipMedal	
				if self.m_tPlayerInfo.vipMedal and self.m_tPlayerInfo.vipMedal ~= "" then
					vipMedal = json.decode(self.m_tPlayerInfo.vipMedal)
				end
				if vipMedal and vipMedal.level >= basicData.property[1][2] then 
					state = 0
				end
			elseif basicData.property[1][1] == 0 and itemId ~= 830 then
				if whetherHaveWelfareCard() then 
					state = 0 
				end
			end
		end

		if self.m_nUsingSkinId == itemId then
			state = 1
		end

		return state
	end

	local state = rtnState(tData.id)
	if state == -1 then
		WndFastGetItems:show(tData.id)
	elseif state == 0 then
		--发送使用协议
		self.m_nUsingSkinId = tData.id
		self:_setSkin(self.m_nUsingSkinId)
		if self.m_tCellLastClickBg then 
			self.m_tCellLastClickBg:updateUseState()
		end
		if self.m_tCellClickBg then 
		 	self.m_tCellClickBg:updateUseState()
		end
	elseif state == 1 then
		
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief 初始化UI静态文本
function WndChallengeLevel:_initStaticUiText(element)
	if self.m_root == nil then 
		return 
	end 

	if self.m_nWinType == 1 or self.m_nWinType == 3 then 
		if self.m_nWinType == 3 then 
			GetElement(self.m_root, "btnSkinChange_WndChallengeLevel", WZUIButton):setVisible(false)
			GetElement(self.m_root, "img9Bg_WndChallengeLevel", WZUI9Image):setFile("ui/redpackbg/common_lt_fhb_4.png")
			GetElement(self.m_root, "img9Bg_WndChallengeLevel", WZUI9Image):setRelativePosition(GlobalMethod:ccp(0.496425,0.21))
		else
			self:_setSkin(self.m_nUsingSkinId)
		end
		GetElement(self.m_root, "conGive_WndChallengeLevel", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "txtBtnSkin_WndChallengeLevel", WZUILabelTTF):setText(LocalStrings.BREAK_TEXT3[6])
		--描边字
		local txtBlessWords = GetElement(self.m_root, "txtBlessWords_WndChallengeLevel", WZUILabelTTF)
		txtBlessWords:setText(LocalStrings.RED_PACK1[self.m_nBlessWordIndex])

		for i = 1, #self.m_tCoinType do
			local basicInfo = GDatatab_item["id_" .. self.m_tCoinType[i]]
			local txtBox = GetElement(self.m_root, "txtBox" .. i .. "_WndChallengeLevel", WZUILabelTTF)
			local txtBoxSel = GetElement(self.m_root, "txtBoxSel" .. i .. "_WndChallengeLevel", WZUILabelTTF)
			txtBox:setText(basicInfo.name)
			txtBoxSel:setText(basicInfo.name)
		end

		local ftxtLeftTimes = GetElement(self.m_root, "ftxtLeftTimes_WndChallengeLevel", WZUIFreeTextBox)
		if ftxtLeftTimes then 
			local sFormat = [[<T C="255,255,255" S="20" P="0">%s</T><T C="255,227,116" S="20" P="0">%d</T>]]
			local sContent = string.format(sFormat, LocalStrings.TODAY_REST_COUNT, self.m_nLeftTimes)
			ftxtLeftTimes:setShowText(sContent)
		end

		GetElement(self.m_root, "checkBoxGroup_WndChallengeLevel", WZUICheckBoxGroup):setCheckIndex(1)
		GetElement(self.m_root, "checkBoxGold_WndChallengeLevel", WZUICheckBox):setVisible(false)
		GetElement(self.m_root, "checkBoxDia_WndChallengeLevel", WZUICheckBox):setTouchEnable(false)
		GetElement(self.m_root, "checkBoxDia_WndChallengeLevel", WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.5,0.5))

		self:_setModelExplain()
	else
		GetElement(self.m_root, "conGet_WndChallengeLevel", WZUIContainer):setVisible(true)
		self:showGetInterface()
	end
end 

--@brief 设置模式说明文字的函数
--@param  sTxt 说明文字
function WndChallengeLevel:_setModelExplain()
	if self.m_root == nil then 
		return 
	end 

	local txtTotalNum = GetElement(self.m_root, "txtTotalNum_WndChallengeLevel", WZUILabelTTF)
	local txtRedPackNum = GetElement(self.m_root, "txtRedPackNum_WndChallengeLevel", WZUILabelTTF)
	local txtOwnNum = GetElement(self.m_root, "txtOwnNum_WndChallengeLevel", WZUILabelTTF)
	local txtCostNum = GetElement(self.m_root, "txtCostNum_WndChallengeLevel", WZUILabelTTF)
	local imgCoin1 = GetElement(self.m_root, "imgCoin1_WndChallengeLevel", WZUIImage)
	local imgCoin2 = GetElement(self.m_root, "imgCoin2_WndChallengeLevel", WZUIImage)
	local basicInfo = GDatatab_item["id_" .. self.m_tCoinType[self.m_nSelModel]]
	imgCoin1:setFile(basicInfo.icon)
	imgCoin2:setFile(basicInfo.icon)
	local nOwnNum = CacheCenter:getMoneyList().gold
	if self.m_tCoinType[self.m_nSelModel] == 70 then 
		nOwnNum = CacheCenter:getMoneyList().ticket
	end
	if self.m_tCoinType[self.m_nSelModel] == 1 then 
		nOwnNum = CacheCenter:getMoneyList().blueDiamond
	end
	txtOwnNum:setText(nOwnNum)
	txtCostNum:setText(self.m_nTotalNum)
	txtTotalNum:setText(self.m_nTotalNum)
	txtRedPackNum:setText(self.m_nRedPackNum)
end 


--@brief	开始按下回调函数
function WndChallengeLevel:onCloseTips(element,pt)
    WZLog("WndMultipleMap:onCloseTips")
    WndItemInfo:onCloseClick()
end
--@brief	其它Item点击回调
function WndChallengeLevel:onItemClick(luaTable,tag,tData)
    if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
	WndItemInfo:showInfo(luaTable.m_root, self.m_root, 1, tData, false)
end

--@brief 	点击切换祝福语
function WndChallengeLevel:onChooseWord(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local tData = {}
	tData.type = 10
	WZLog("CellCheckOther3:onClickSetting", nTag)
	local pt = GlobalMethod:ccp(70,-35)
	tData.selIndex = self.m_nBlessWordIndex
	tData.blessList = LocalStrings.RED_PACK1
	WndTips:show(element, self.m_root, 75, tData, pt, true)
end

--@brief 	点击+按钮回调
function WndChallengeLevel:onAddNum(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	local nTag = element:getTag()
	if nTag == 1 then 
		if self.m_nSelModel == 1 then 
			if self.m_nTotalNum >= self.m_tGoldTotalNumLimit[2] then 
				MsgBoxManager:showTipBox(LocalStrings.CHESTMAXNUM)
			elseif self.m_nTotalNum + self.m_tGoldTotalNumLimit[3] > self.m_tGoldTotalNumLimit[2] then 
				self.m_nTotalNum = self.m_tGoldTotalNumLimit[2]
			else
				self.m_nTotalNum = self.m_nTotalNum + self.m_tGoldTotalNumLimit[3]
			end
		elseif self.m_nSelModel == 2 then 
			if self.m_nTotalNum >= self.m_tDiaTotalNumLimit[2] then 
				MsgBoxManager:showTipBox(LocalStrings.CHESTMAXNUM)
			elseif self.m_nTotalNum + self.m_tDiaTotalNumLimit[3] > self.m_tDiaTotalNumLimit[2] then 
				self.m_nTotalNum = self.m_tDiaTotalNumLimit[2]
			else
				self.m_nTotalNum = self.m_nTotalNum + self.m_tDiaTotalNumLimit[3]
			end
		end
	elseif nTag == 2 then 
		if self.m_nRedPackNum >= self.m_tRedPackNumLimit[2] then 
			MsgBoxManager:showTipBox(LocalStrings.CHESTMAXNUM)
		elseif self.m_nRedPackNum + self.m_tRedPackNumLimit[3] > self.m_tRedPackNumLimit[2] then 
			self.m_nRedPackNum = self.m_tRedPackNumLimit[2]
		else
			self.m_nRedPackNum = self.m_nRedPackNum + self.m_tRedPackNumLimit[3]
		end
	end

	self:_setModelExplain()
end

--@brief 	点击-按钮回调
function WndChallengeLevel:onReduceNum(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	local nTag = element:getTag()
	if nTag == 1 then 
		if self.m_nSelModel == 1 then 
			if self.m_nTotalNum <= self.m_tGoldTotalNumLimit[1] then 
				MsgBoxManager:showTipBox(LocalStrings.CHESTMINNUM)
			elseif self.m_nTotalNum - self.m_tGoldTotalNumLimit[3] < self.m_tGoldTotalNumLimit[1] then 
				self.m_nTotalNum = self.m_tGoldTotalNumLimit[1]
			else
				self.m_nTotalNum = self.m_nTotalNum - self.m_tGoldTotalNumLimit[3]
			end
		elseif self.m_nSelModel == 2 then 
			if self.m_nTotalNum <= self.m_tDiaTotalNumLimit[1] then 
				MsgBoxManager:showTipBox(LocalStrings.CHESTMINNUM)
			elseif self.m_nTotalNum - self.m_tDiaTotalNumLimit[3] < self.m_tDiaTotalNumLimit[1] then 
				self.m_nTotalNum = self.m_tDiaTotalNumLimit[1]
			else
				self.m_nTotalNum = self.m_nTotalNum - self.m_tDiaTotalNumLimit[3]
			end
		end
	elseif nTag == 2 then 
		if self.m_nRedPackNum <= self.m_tRedPackNumLimit[1] then 
			MsgBoxManager:showTipBox(LocalStrings.CHESTMINNUM)
		elseif self.m_nRedPackNum - self.m_tRedPackNumLimit[3] < self.m_tRedPackNumLimit[1] then 
			self.m_nRedPackNum = self.m_tRedPackNumLimit[1]
		else
			self.m_nRedPackNum = self.m_nRedPackNum - self.m_tRedPackNumLimit[3]
		end
	end

	self:_setModelExplain()
end

--@brief 	点击头像回调
function WndChallengeLevel:onCheckPlayer(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_tResultData == nil then return end 

	WndCheckOther:show(self.m_tResultData.playerId)
end

--@brief 	显示领红包界面
function WndChallengeLevel:showGetInterface()
	--body
	if self.m_nStatus == 0 then 
		GetElement(self.m_root, "txtBtnWord_WndChallengeLevel", WZUILabelTTF):setText(LocalStrings.RED_PACK9[1])
		GetElement(self.m_root, "txtRewardWord_WndChallengeLevel", WZUILabelTTF):setText(LocalStrings.SPREE_SUCCESS)
		local conRewardItem = GetElement(self.m_root, "conRewardItem_WndChallengeLevel", WZUIContainer)
		conRewardItem:removeAllChildrenWithCleanup(true)
		local element, tNewObj = CellGoodItem:createElement()
		if element and tNewObj then 
			tNewObj:setCellGoodLocalId(self.m_tResultData.itemId, self.m_tResultData.itemNum, 4)
			tNewObj:setItemClickFun(self, self.onItemClick)

			conRewardItem:addChild(element)
		end
	elseif self.m_nStatus == 1 then 
		GetElement(self.m_root, "txtBtnWord_WndChallengeLevel", WZUILabelTTF):setText(LocalStrings.RED_PACK9[2])
		GetElement(self.m_root, "txtRewardWord_WndChallengeLevel", WZUILabelTTF):setText(LocalStrings.RED_PACK10)
	end
	local img9GetBg = GetElement(self.m_root, "img9GetBg_WndChallengeLevel", WZUI9Image)
	local conHead = GetElement(self.m_root, "conHead_WndChallengeLevel", WZUIContainer)
	if self.m_nWinType == 4 then 
		GetElement(self.m_root, "txtBtnWord_WndChallengeLevel", WZUILabelTTF):setText(LocalStrings.CONFIRM)
	else
		if self.m_tResultData.redpackSkinId and self.m_tResultData.redpackSkinId > 0 then
			local basicData = GDatatab_item["id_" .. self.m_tResultData.redpackSkinId]
			if basicData then 
				local filePath = string.gsub(basicData.icon, "ui/chat/common_lt_xzhb", "ui/chat/common_lt_shb")
			    img9GetBg:setFile(filePath)
			end
			if self.m_tResultData.redpackSkinId == 883 then 
				GetElement(self.m_root, "txtBlessWordsGet_WndChallengeLevel", WZUILabelTTF):setColor(GlobalMethod:ccc3(229,105,22))
				conHead:setRelativePosition(GlobalMethod:ccp(0.38,0.74))
			end
		end
	end
	--头像
	local cellElement =  CellHead:show(conHead,self.m_tResultData.headId,self.m_tResultData.faceId,self.m_tResultData.sex, nil, nil, self.m_tResultData.vipLevel, self.m_tResultData.headColor, nil, nil, nil, nil, self.m_tResultData.headEffectId)
	local txtPlayerName = GetElement(self.m_root, "txtPlayerName_WndChallengeLevel", WZUILabelTTF)
	if txtPlayerName then 
		txtPlayerName:setText(string.format(LocalStrings.RED_PACK11, self.m_tResultData.playerName))
	end
	local txtBlessWordsGet = GetElement(self.m_root, "txtBlessWordsGet_WndChallengeLevel", WZUILabelTTF)
	if txtBlessWordsGet then 
		if LocalStrings.RED_PACK1[self.m_tResultData.wishWorldsId] then 
			txtBlessWordsGet:setText(LocalStrings.RED_PACK1[self.m_tResultData.wishWorldsId])
		else
			txtBlessWordsGet:setText(LocalStrings.RED_PACK1[1])
		end
	end
end

--@brief 	创建可选的皮肤列表
function WndChallengeLevel:_createSkinList()
	local tbSkinList = GetElement(self.m_root, "tbSkinList_WndChallengeLevel", WZUITableContainer)
	tbSkinList:cleanTable()

	if self.m_tSkinList == nil then 
		self.m_tSkinList = {}
		for i, v in pairs(GDatatab_item) do
			if v.main_type == 25 and v.sub_type == 4 and v.can_sale ~= -1 then
				local tItem = CopyTable(v)
				table.insert(self.m_tSkinList, tItem)
			end
		end
		local tDefaultItem = {}
		tDefaultItem.id = 0 
		tDefaultItem.icon = "ui/chat/common_lt_xzhb_1.png" 
		table.insert(self.m_tSkinList, tDefaultItem)
	end
	WZLog("WndChallengeLevel:_createSkinList one", Serialize(self.m_tSkinList))
	local function rtnState(itemId)
		-- body
		local state = -1 
		if itemId == 0 then 
			state = 0 
		else
			local nNum = CacheCenter:getPlayerItemCountById(itemId)
			if nNum > 0 then
				state = 0 
			end

			local basicData = GDatatab_item["id_" .. itemId]
			if basicData.property[1][1] == -1 then 
				if CacheCenter:getPlayerInfo().vipLevel >= basicData.property[1][2] then 
					state = 0
				end
			elseif basicData.property[1][1] == 0 and itemId ~= 830 then
				if whetherHaveWelfareCard() then 
					state = 0 
				end
			elseif basicData.property[1][1] == -2 then 
				local vipMedal	
				if CacheCenter:getPlayerInfo().vipMedal and CacheCenter:getPlayerInfo().vipMedal ~= "" then
					vipMedal = json.decode(CacheCenter:getPlayerInfo().vipMedal)
				end
				if vipMedal and vipMedal.level >= basicData.property[1][2] then 
					state = 0
				end
			end
		end
		if self.m_nUsingSkinId == itemId then
			state = 1
		end

		return state
	end
	table.sort(self.m_tSkinList, function (a,b)
		-- body
		local stateA = rtnState(a.id)
		local stateB = rtnState(b.id)
		if stateA ~= stateB then
			return stateA > stateB
		else
			return a.id < b.id
		end
	end)
	WZLog("WndChallengeLevel:_createSkinList", Serialize(self.m_tSkinList))
	for i = 1, #self.m_tSkinList do
		local element, tNewObj = CellCheckOtherBg:createElement()
		if element and tNewObj then
			element:setTag(i - 1)
			tNewObj:setData(self.m_tSkinList[i], 1)
			if self.m_tSkinList[i].id == self.m_nUsingSkinId then
				tNewObj:setSelState(true)
				self.m_tCellClickBg = tNewObj 
				self.m_tCellLastUsingBg = tNewObj
			end
			tbSkinList:setCellElement(element)
		end
	end
end

--@brief    保存当前使用的红包皮肤Id到本地
function WndChallengeLevel:saveRedpackSkinId()
    WZLog("WndChallengeLevel:addCellItemId")
    local _KeyString = ""
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = "PLAYER_" .. CacheCenter:getPlayerInfo().id
    local cellId_stringArray =  data:getStringValue("REDPACKSKINID", _KeyString)
    if cellId_stringArray == nil or tonumber(cellId_stringArray) ~= self.m_nUsingSkinId then
        local idString = tostring(self.m_nUsingSkinId)
        data:setStringValue("REDPACKSKINID", _KeyString, idString)
        data:flush()
    end
end

--@brief    获取当前使用的红包皮肤Id到本地
function WndChallengeLevel:getRedpackSkinId()
    local data = WZDataFile:getInstance():getUserData()
    local _KeyString = "PLAYER_" .. CacheCenter:getPlayerInfo().id
    local cellId_stringArray = data:getStringValue("REDPACKSKINID", _KeyString)

    WZLog("SceneSelectActor:CheckItemIsClick ", cellId_stringArray)
    if cellId_stringArray == nil or cellId_stringArray == "" then
        return 0
    end

    return tonumber(cellId_stringArray)
end

--@brief 	设置红包皮肤
function WndChallengeLevel:_setSkin(itemId)
	-- body
	if self.m_root == nil then return end 

	local img9Bg = GetElement(self.m_root, "img9Bg_WndChallengeLevel", WZUI9Image)
	if itemId == 0 then 
		img9Bg:setFile("ui/redpackbg/common_lt_fhb_1.png")
	else
		local tBasicData = GDatatab_item["id_" .. itemId]
		local filePath = string.gsub(tBasicData.icon, "ui/chat/common_lt_xzhb", "ui/redpackbg/common_lt_fhb")
		img9Bg:setFile(filePath)
	end
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配器模块Begin--------------------------------------
--@brief	英文适配函数
--@note		英文适配函数
function WndChallengeLevel:_adaptLanguage_en()

end 

--@brief	葡语适配函数
--@note		葡语适配函数
function WndChallengeLevel:_adaptLanguage_pt()

end 

--@brief  越南语适配函数
--@return 无
--@note   备注
function WndChallengeLevel:_adaptLanguage_vn()
	GetElement(self.m_root,"txtBlessWordsGet_WndChallengeLevel",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(180,0))
	GetElement(self.m_root,"txtRewardWord_WndChallengeLevel",WZUILabelTTF):setScale(0.8)
end
-------------------------------------语言适配器模块End----------------------------------------
