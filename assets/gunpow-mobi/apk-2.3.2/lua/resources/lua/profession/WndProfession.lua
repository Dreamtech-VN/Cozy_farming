--WndProfession.lua
--@brief	WndProfession的UI模块
--@date		2019/11/11
--@author	Tianxiang_Xu
--@note		职业系统


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndProfession:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
	ProtocolProcessorProfession:regAll()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndProfession:onExit(element)
	ProtocolProcessorProfession:unregAll()

	self:_unInit()
end

function WndProfession:onEnterTransitionDidFinish(element)
	--body
	WZLog("WndProfession:onEnterTransitionDidFinish")
	self:setBornSkillData()
	self:_initUI()
	self:_addTop()

	self:_createLoading()
	ProtocolProcessorProfession:send_PROFESSION_GetInfo()
	self:_adaptIphoneX()
end

--@brief    关闭界面按钮点击相应
function WndProfession:onCloseClick(element)
    -- body
    --播放点击音效
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    if self.m_bIsPreview then 
    	self.m_bIsPreview = false 
    	self.m_nTurnIndex = self.m_nSaveTurnIndex or 1 
    	GetElement(self.m_root, "checkboxTurn_WndProfession", WZUICheckBoxGroup):setCheckIndex(self.m_nTurnIndex - 1)
    	self:_setContentByTurn(self.m_nTurnIndex)

    	self:_update()
    else
    	WindowManager:removeWindow(self.m_root, self, true)
    end
end

--@brief 	触摸开始回调
function WndProfession:onTouchBegan(element, pt)
	-- body
	if self.m_topCellLua then
		if self.m_topCellLua.goldCellInfo and self.m_topCellLua.goldCellInfo.tcell then 
        	self.m_topCellLua.goldCellInfo.tcell:removeCreateTips()
        end
    end
end

--@brief 	点击选中职业
function WndProfession:onChooseProfession(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if self.m_nProfessionSel and self.m_nProfessionSel == nTag then return end 

	self.m_nProfessionSel = nTag
	self:_setProfessionSelState()
end

--@brief 	点击确认选择按钮回调
function WndProfession:onClickChoose(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_nProfessionSel == nil then 
		MsgBoxManager:showTipBox(LocalStrings.PROFESSION_TEXT5)
		return 
	end

	local professionDoingNum = PrefetchCache:getProfessionTaskDoingNum()
	if professionDoingNum > 0 then 
		-- MsgBoxManager:showTipBox(LocalStrings.PROFESSION_TEXT7)
		MsgBoxManager:showConfirmBox(LocalStrings.PROFESSION_TEXT7,self,self.gotoTaskProfession)
		return 
	end

	MsgBoxManager:showConfirmBox(string.format(LocalStrings.PROFESSION_TEXT6, LocalStrings.PROFESSION_TEXT2[self.m_nProfessionSel]), self, self.sureToChoose)
end

--@brief 	前往任务-职业
function WndProfession:gotoTaskProfession(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndTask:showInterface(4)
    end
end

function WndProfession:sureToChoose()
	-- body
	--发送职业选中协议
	self:_createLoading()
	ProtocolProcessorProfession:send_PROFESSION_Choose(self.m_nProfessionSel)
end

--@brief 	点击预览按钮回调
function WndProfession:onClickPreview(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_nProfessionSel == nil then 
		MsgBoxManager:showTipBox(LocalStrings.PROFESSION_TEXT5)
		return 
	end
	if not self.m_bIsPreview then 
		self.m_nSaveTurnIndex = self.m_nTurnIndex 
	end

	self:_showPreview(self.m_nProfessionSel)
end

--@brief 	点击查看规则
function WndProfession:onClickRule(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_nCurProfessionId > 0 then 
		WndProfessionRule:showInterface(1, LocalStrings.PROFESSION_TEXT9)
		-- WndSingleMapDesc:showInterface(LocalStrings.PROFESSION_TEXT9)
	else
		WndSingleMapDesc:showInterface(LocalStrings.PROFESSION_TEXT9)
	end
end

--@brief 	点击升级按钮回调
function WndProfession:onClickUpgrade(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nCrystalOperateType = nil
	self.m_bIsTransColor = false 	 

	if self.m_nTurnIndex == 1 then 
		if self.m_bIsChooseAdSkill then 
			local tTempData = self:getAdvanceSkillData()
			if tTempData == nil then return end 
			if tTempData.expend == -1 then 
				MsgBoxManager:showTipBox(LocalStrings.PROFESSION_TEXT15)
				return 
			end
			for i = 1, #tTempData.expend do
				if not JudgeMoneyIsEnough(tTempData.expend[i][1], tTempData.expend[i][2], nil, nil, GlobalGame.g_nCurrentUIChannelId) then 
					return 
				end
			end

			self:_createLoading()
			ProtocolProcessorProfession:send_PROFESSION_UpAdvSkill()
			return 
		else
			local tTempData = self.m_tBornSkillData[self.m_nCurProfessionId][self.m_nSelBornSkillIndex]
			if tTempData == nil then return end
			if self.m_nSelBornSkillIndex > 1 then 
				--要激活下一个节点，前一节点首先要激活
				local preTempData = self.m_tBornSkillData[self.m_nCurProfessionId][self.m_nSelBornSkillIndex - 1]
				if self.m_nSelBornSkillIndex == 3 and preTempData.state == 0 then 
					preTempData = self.m_tBornSkillData[self.m_nCurProfessionId][13]
				elseif self.m_nSelBornSkillIndex == 9 then 
					preTempData = self.m_tBornSkillData[self.m_nCurProfessionId][1]
				end
				if preTempData and preTempData.state == 0 then 
					MsgBoxManager:showTipBox(LocalStrings.PROFESSION_TEXT21)
					return 
				end
				--第八个节点要第七个升满级才能激活
				if preTempData and self.m_nSelBornSkillIndex == 8 and tTempData.state == 0 then 
					local lastNodeNextLvData = self:_getBornSkillNextLevelData(preTempData)
					if lastNodeNextLvData then 
						MsgBoxManager:showTipBox(LocalStrings.PROFESSION_TEXT22)
						return 
					end
				end
			end
			if tTempData.state == 0 and (self.m_nSelBornSkillIndex == 2 or self.m_nSelBornSkillIndex == 9) then 
				MsgBoxManager:showConfirmCancelBox(string.format(LocalStrings.PROFESSION_TEXT20, tTempData.name), self, self.sureToActive)
				return 
			end
		end
	elseif self.m_nTurnIndex == 2 then 
		if not CheckButtonOpen(191) then return end 
		self.m_tBeforeData = CopyTable(self.m_tSecondTurnData[self.m_nCurProfessionId])
		local tTempData = self.m_tSecondTurnData[self.m_nCurProfessionId][self.m_nSelBornSkillIndex]
		if tTempData == nil then return end
		if tTempData.node > 0 then 
			--要激活下一个节点，前一节点首先要激活
			local preTempData = self.m_tSecondTurnData[self.m_nCurProfessionId][self.m_nSelBornSkillIndex - 1]
			if preTempData and preTempData.state == 0 then 
				MsgBoxManager:showTipBox(LocalStrings.PROFESSION_TEXT21)
				return 
			end
		elseif tTempData.node == 0 and self.m_nProfessionState ~= 2 then 
			local tTempData = self.m_tBornSkillData[self.m_nCurProfessionId][8] 
			if tTempData.state == 0 then
				MsgBoxManager:showTipBox(LocalStrings.PROFESSION_TWO3)
				return
			end
		end
	end

	self:sureToActive(nil, MSGBOXRESTYPE_CONFIRM)
end

--@brief 	确定激活该路线
function WndProfession:sureToActive(nId, nResType)
	WZLog("WndProfession:sureToActive")
	if nResType == MSGBOXRESTYPE_CONFIRM then
		local tTempData = self.m_tBornSkillData[self.m_nCurProfessionId][self.m_nSelBornSkillIndex]
		if self.m_nTurnIndex == 2 then 
			tTempData = self.m_tSecondTurnData[self.m_nCurProfessionId][self.m_nSelBornSkillIndex]
		end

		if not JudgeMoneyIsEnough(tTempData.expend[1][1], tTempData.expend[1][2], nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureToUseDiamond) then 
			return 
		end

		self:sureToUseDiamond()
	end
end

--@brief 	确定使用蓝钻代替粉钻
function WndProfession:sureToUseDiamond()
	-- body
	local nIndex = self.m_nTurnIndex
	local tTempData = self.m_tBornSkillData[self.m_nCurProfessionId][self.m_nSelBornSkillIndex]
	if self.m_nTurnIndex == 2 then 
		tTempData = self.m_tSecondTurnData[self.m_nCurProfessionId][self.m_nSelBornSkillIndex]
		if self.m_nSelBornSkillIndex >= 6 then 
			nIndex = 3
		end
		--水晶节点
		if tTempData.type == 8 then 
			local nextNodeData = self.m_tSecondTurnData[self.m_nCurProfessionId][self.m_nSelBornSkillIndex + 1]
			if nextNodeData and nextNodeData.state == 1 then 
				self.m_nCrystalOperateType = 2
			end
		end
	end

	self:_createLoading()
	self.m_bIsActivity = false
	if tTempData.state == 0 then 
		self.m_bIsActivity = true
		if tTempData.type == 8 then 
			--激活第二个水晶
			if (nIndex - 1 == 1 and tTempData.node == 3) or (nIndex - 1 == 2 and tTempData.node == 2) then 
				self.m_nCrystalOperateType = 1
			end
		end
	end

	ProtocolProcessorProfession:send_PROFESSION_UpSKill(tTempData.node, nIndex - 1, 0)
end

--@brief 	点击天赋图标回调
function WndProfession:onClickBornSkill(element)
	-- body
	local nTag = element:getTag()
	if nTag == self.m_nSelBornSkillIndex then 
		if self.m_nTurnIndex == 1 and self.m_bIsChooseAdSkill and not self.m_bIsPreview then 
			GetElement(self.m_root, "img9AdSel_WndProfession", WZUI9Image):setVisible(false)
			self.m_bIsChooseAdSkill = false 
		else
			return 
		end
	else
		if self.m_nTurnIndex == 1 and self.m_bIsChooseAdSkill and not self.m_bIsPreview then 
			GetElement(self.m_root, "img9AdSel_WndProfession", WZUI9Image):setVisible(false)
			self.m_bIsChooseAdSkill = false 
		end
	end 

	self.m_nSelBornSkillIndex = nTag
	--天赋详情
	WZLog("WndProfession:onClickBornSkill", self.m_nProfessionSel, self.m_nSelBornSkillIndex)
	if self.m_bIsPreview then 
		self:_showSelBornSkillContent(self.m_nProfessionSel, self.m_nSelBornSkillIndex)
	else
		self:_showSelBornSkillContent(self.m_nCurProfessionId, self.m_nSelBornSkillIndex)
	end
end

--@brief    点击重置按钮回调
function WndProfession:onClickReset()
    -- body
    WZLog("WndProfession:onClickReset")
    local bNeedReset = self:_judgeNeedReset()
    if not bNeedReset then
        MsgBoxManager:showTipBox(LocalStrings.PROFESSION_TEXT18)
        return
    end

    local content = nil 
    if self.m_nTurnIndex == 1 then 
	    local sConfig = CacheCenter:getGameParam().occupationalresetConsume
		local string = string.sub(sConfig,2,-2) 
		local id = SplitStringWithSeparator(string,",")[1]
		local num = SplitStringWithSeparator(string,",")[2]
		local icon = GDatatab_item["id_" .. id].icon

		local returnPercentConfig = CacheCenter:getGameParam().occupationalsystemFirstRe
		string = string.sub(returnPercentConfig,2,-2) 
		local returnPercent = SplitStringWithSeparator(string,",")[2]
		content = string.format(LocalStrings.PROFESSION_TEXT19, tonumber(num), icon, tonumber(returnPercent))
		if self.m_nBornSkillResetTimes == 0 then
			content = string.format(LocalStrings.PROFESSION_TEXT23, returnPercent)
		end
	elseif self.m_nTurnIndex == 2 then 
		local sConfig = CacheCenter:getGameParam().occupationalresetConsume2
		local string = string.sub(sConfig,2,-2) 
		local id = SplitStringWithSeparator(string,",")[1]
		local num = SplitStringWithSeparator(string,",")[2]
		local icon = GDatatab_item["id_" .. id].icon

		local returnPercentConfig = CacheCenter:getGameParam().occupationalsystemFirstRe
		string = string.sub(returnPercentConfig,2,-2) 
		local returnPercent = SplitStringWithSeparator(string,",")[2]
		content = string.format(LocalStrings.PROFESSION_TWO9, tonumber(num), icon, tonumber(returnPercent), GDatatab_item["id_95"].icon)
		if self.m_nSecondSkillResetTimes == 0 then
			content = string.format(LocalStrings.PROFESSION_TWO10, tonumber(returnPercent), GDatatab_item["id_95"].icon)
		end
	end

    MsgBoxManager:showConfirmBox(content, self, self.sureToReset)
end

--@brief    确认重置天赋点
function WndProfession:sureToReset()
    -- body
    local nResetTimes = 0
    local sConfig = nil 
    if self.m_nTurnIndex == 1 then 
    	nResetTimes = self.m_nBornSkillResetTimes
		sConfig = CacheCenter:getGameParam().occupationalresetConsume
	elseif self.m_nTurnIndex == 2 then 
		nResetTimes = self.m_nSecondSkillResetTimes
		sConfig = CacheCenter:getGameParam().occupationalresetConsume2
	end
	if nResetTimes > 0 then 
		local string = string.sub(sConfig,2,-2) 
		local id = tonumber(SplitStringWithSeparator(string,",")[1])
		local num = tonumber(SplitStringWithSeparator(string,",")[2])

	    if not JudgeMoneyIsEnough(id, num, nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureToUseDiamondForReset) then
	        return 
	    end
	end

    self:sureToUseDiamondForReset()
end

--@brief 	确定使用蓝钻代替粉钻
function WndProfession:sureToUseDiamondForReset()
	-- body
	self:_createLoading()
	ProtocolProcessorProfession:send_PROFESSION_ResetTalent(self.m_nTurnIndex - 1)
end

--@brief 	点击切换职业一二转按钮回调
function WndProfession:onChangeTurn(element)
	-- body
	local nTag = element:getTag()
	if self.m_nTurnIndex == nTag then return end 

	self.m_nTurnIndex = nTag
	self:_setContentByTurn(self.m_nTurnIndex)

	if self.m_bIsPreview then 
		self:_showPreview(self.m_nProfessionSel)
	else
		self:_showContentByProfession(self.m_nCurProfessionId)
	end
end

--@brief 	点击图鉴按钮回调
function WndProfession:onClickLibrary(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local professionId = self.m_nCurProfessionId
	if self.m_bIsPreview then 
		professionId = self.m_nProfessionSel
	end
	local nRoleOrPet = 1
	local tTempData = self.m_tSecondTurnData[professionId][self.m_nSelBornSkillIndex]
	if self.m_nSelBornSkillIndex == 9 then 
		nRoleOrPet = 2 
	end

	WndProfessionCrystalLibrary:showInterface(tTempData.profession, nRoleOrPet)
end

--@brief 	点击转换水晶颜色按钮回调
function WndProfession:onClickExchange(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nCrystalOperateType = nil 
	self.m_bIsTransColor = false 	

	local tTempData = self.m_tSecondTurnData[self.m_nCurProfessionId][self.m_nSelBornSkillIndex]
	if tTempData == nil then return end
	local sExchangeFormat = [[<T C="127,70,26" S="24" P="0">%d</T><I Z="0.5" P="0">%s</I>]]
	local sExchangeAtt = LocalStrings.PROFESSION_TWO11
	for i = 1, #tTempData.expend2 do
		local tItemData = GDatatab_item["id_" .. tTempData.expend2[i][1]]
		local costString = string.format(sExchangeFormat, tTempData.expend2[i][2], tItemData.icon)
		sExchangeAtt = sExchangeAtt .. costString 
	end
	sExchangeAtt = sExchangeAtt .. LocalStrings.PROFESSION_TWO12

	MsgBoxManager:showConfirmCancelBox(sExchangeAtt, self, self.sureToExchangeCrystal, nil, {[MSGBOXUICFG_USEFREETXT] = true})
end

--@brief 	确认转换水晶
function WndProfession:sureToExchangeCrystal(nId, nResType)
	if nResType ~= MSGBOXRESTYPE_CONFIRM then return end
	-- body
	local tTempData = self.m_tSecondTurnData[self.m_nCurProfessionId][self.m_nSelBornSkillIndex]
	if tTempData == nil then return end

	for i = 1, #tTempData.expend2 do
		if not JudgeMoneyIsEnough(tTempData.expend2[i][1], tTempData.expend2[i][2], nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.gotoExchange) then
	        return 
	    end
	end

	self:gotoExchange()
end

--@brief 	前往转换
function WndProfession:gotoExchange()
	-- body
	local nIndex = self.m_nTurnIndex
	local tTempData = self.m_tSecondTurnData[self.m_nCurProfessionId][self.m_nSelBornSkillIndex]
	self.m_tBeforeData = CopyTable(self.m_tSecondTurnData[self.m_nCurProfessionId])
	if self.m_nTurnIndex == 2 then 
		if self.m_nSelBornSkillIndex >= 6 then 
			nIndex = 3
		end
	end

	self:_createLoading()
	self.m_bIsActivity = false
	local nextNodeData = self.m_tSecondTurnData[self.m_nCurProfessionId][self.m_nSelBornSkillIndex + 1]
	if nextNodeData and nextNodeData.state == 1 then 
		self.m_nCrystalOperateType = 3
	end
	self.m_bIsTransColor = true
	ProtocolProcessorProfession:send_PROFESSION_UpSKill(tTempData.node, nIndex - 1, 1)
end

--@brief 	点击继续文字按钮回调
function WndProfession:onClickContinue(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	GetElement(self.m_root, "conCrystalOperate_WndProfession", WZUIContainer):setVisible(false)
end

--@brief 	点击进阶技能回调
function WndProfession:onClickAdvanceSkill(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_nTurnIndex ~= 1 then return end

	GetElement(self.m_root, "img9AdSel_WndProfession", WZUI9Image):setVisible(true)
	self.m_bIsChooseAdSkill = true
	self:_showSelBornSkillContent(self.m_nCurProfessionId, self.m_nSelBornSkillIndex, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    添加顶部钻石栏
function WndProfession:_addTop()
    -- body
    WZLog("WndProfession:_addTop")
    local conTop = GetElement(self.m_root, "conTop_WndProfession", WZUIContainer)
    local celElement, tNewObj = CellTopHandle:createElement()
    tNewObj:setTopData("ui/common/common_icon_zyxt.png", WndProfession, WndProfession.onCloseClick, true, false, false, nil, {goldType = 14})
    conTop:addChild(celElement)
    self.m_topCellLua = tNewObj
end

--@brief 	设置选中职业标记
function WndProfession:_setProfessionSelState()
	-- body
	for i = 1, 3 do
		if self.m_nProfessionSel and i == self.m_nProfessionSel then 
			GetElement(self.m_root, "img9Sel" .. i .. "_WndProfession", WZUI9Image):setVisible(true)
		else
			GetElement(self.m_root, "img9Sel" .. i .. "_WndProfession", WZUI9Image):setVisible(false)
		end
	end
end

--@brief 	初始化UI
function WndProfession:_initUI()
	-- body
	for i = 1, 3 do
		GetElement(self.m_root, "txtProfessionName" .. i .. "_WndProfession", WZUILabelTTF):setText(LocalStrings.PROFESSION_TEXT2[i])
		GetElement(self.m_root, "txtProfessionDesc" .. i .. "_WndProfession", WZUILabelTTF):setText(LocalStrings.PROFESSION_TEXT3[i])
	end
end

--@brief 	刷新
function WndProfession:_update()
	-- body
	if self.m_nCurProfessionId == 0 then
		GetElement(self.m_root, "conBeforeChoose_WndProfession", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "conAfterChoose_WndProfession", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "checkboxTurn_WndProfession", WZUIContainer):setVisible(false)
		self:setAdvanceSkillVisible()
	else
		GetElement(self.m_root, "conBeforeChoose_WndProfession", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "conAfterChoose_WndProfession", WZUIContainer):setVisible(true)
		if CheckButtonOpen(191, false) then 
			GetElement(self.m_root, "checkboxTurn_WndProfession", WZUIContainer):setVisible(true)
		end

		self:_showContentByProfession(self.m_nCurProfessionId)
	end
end

--@brief 	根据职业显示相应的内容
function WndProfession:_showContentByProfession(profession)
	-- body
	local rootNode = self:getTurnParentNode()
	for i = 1, 3 do
		GetElement(rootNode, "conProfession" .. i .. "_WndProfession", WZUIContainer):setVisible(false)
	end
	GetElement(self.m_root, "btnExchange_WndProfession", WZUIButton):setVisible(false)
	GetElement(self.m_root, "btnLibrary_WndProfession", WZUIButton):setVisible(false)
	self:setAdvanceSkillVisible()

	if self.m_nTurnIndex == 1 then --一转职业天赋
		if profession and profession > 0 then 
			local bgPath = {"ui/common_bg/zhiye_pic_jinniu.png", "ui/common_bg/zhiye_pic_shizi.png", "ui/common_bg/zhiye_pic_shuangyu.png"}
			local conProfession = GetElement(rootNode, "conProfession" .. profession .. "_WndProfession", WZUIContainer)
			conProfession:setVisible(true)
			local imgBg = GetElement(self.m_root, "imgBg_WndProfession", WZUIImage)
			if imgBg then 
				imgBg:setFile(bgPath[profession])
			end
			--天赋线路图标
			local nActiveLine = self:getActiveLineIndex()
			for i = 1, #self.m_tBornSkillData[profession] do
				local tTempData = self.m_tBornSkillData[profession][i]

				local imgSkillBG = GetElement(conProfession, "imgSkillBG" .. i .. "_WndProfession", WZUIImage)
				local imgSkillIcon = GetElement(conProfession, "imgSkillIcon" .. i .. "_WndProfession", WZUIImage)
				local txtSkillLv = GetElement(conProfession, "txtSkillLv" .. i .. "_WndProfession", WZUILabelTTF)

				imgSkillIcon:setFile(tTempData.icon)
				txtSkillLv:setText(LocalStrings.LV .. tTempData.lv)
				if tTempData.state == 0 then 
					imgSkillBG:setGrayRender(true)
					imgSkillIcon:setGrayRender(true)
					txtSkillLv:setVisible(false)
					if i == 1 then
						GetElement(conProfession, "spineFirst_WndProfession", WZUISpine):setVisible(true)
					end
				else
					if i == 1 then 
						GetElement(conProfession, "spineFirst_WndProfession", WZUISpine):setVisible(false)
					end
					imgSkillBG:setGrayRender(false)
					imgSkillIcon:setGrayRender(false)
					txtSkillLv:setVisible(true)
					if profession == self.m_nCurProfessionId then 
						if nActiveLine == 1 then 
							if i == 9 then 
								imgSkillBG:setGrayRender(true)
								imgSkillIcon:setGrayRender(true)
								txtSkillLv:setVisible(false)
							end
						elseif nActiveLine == 2 then 
							if i == 2 then 
								imgSkillBG:setGrayRender(true)
								imgSkillIcon:setGrayRender(true)
								txtSkillLv:setVisible(false)
							end
						end
					end
				end
			end
			--天赋详情
			self:_showSelBornSkillContent(profession, self.m_nSelBornSkillIndex)
		end
	elseif self.m_nTurnIndex == 2 then 
		if profession and profession > 0 then 
			local bgPath = {"ui/common_bg/zhiye_pic_jinniu.png", "ui/common_bg/zhiye_pic_shizi.png", "ui/common_bg/zhiye_pic_shuangyu.png"}
			local conProfession = GetElement(rootNode, "conProfession" .. profession .. "_WndProfession", WZUIContainer)
			conProfession:setVisible(true)
			local imgBg = GetElement(self.m_root, "imgBg_WndProfession", WZUIImage)
			if imgBg then 
				imgBg:setFile(bgPath[profession])
			end
			--天赋线路图标
			local nActiveLine = self:getActiveLineIndex()
			for i = 1, #self.m_tSecondTurnData[profession] do
				local tTempData = self.m_tSecondTurnData[profession][i]

				local imgSkillBG = GetElement(conProfession, "imgSkillBG" .. i .. "_WndProfession", WZUIImage)
				local imgSkillIcon = GetElement(conProfession, "imgSkillIcon" .. i .. "_WndProfession", WZUIImage)
				local txtSkillLv = GetElement(conProfession, "txtSkillLv" .. i .. "_WndProfession", WZUILabelTTF)

				imgSkillIcon:setFile(tTempData.icon)
				txtSkillLv:setText(LocalStrings.LV .. tTempData.lv)
				if tTempData.state == 0 then 
					imgSkillBG:setGrayRender(true)
					imgSkillIcon:setGrayRender(true)
					txtSkillLv:setVisible(false)
					if i == 1 then
						GetElement(conProfession, "spineFirst_WndProfession", WZUISpine):setVisible(true)
					elseif i == 6 then 
						GetElement(conProfession, "spinePetFirst_WndProfession", WZUISpine):setVisible(true)
					end
					--未激活，不知道具体什么技能
					if tTempData.type == 8 or i == 5 or i == 9 then 
						if i== 5 or i == 9 then 
							if self.m_tSecondTurnData[profession][i - 2].state == 0 or self.m_tSecondTurnData[profession][i - 1].state == 0 then
								imgSkillIcon:setFile("ui/common/common_btn_wh.png")
							end 
						else
							imgSkillIcon:setFile("ui/common/common_btn_wh.png")
						end
					end
				else
					if i == 1 then 
						GetElement(conProfession, "spineFirst_WndProfession", WZUISpine):setVisible(false)
					elseif i == 6 then
						GetElement(conProfession, "spinePetFirst_WndProfession", WZUISpine):setVisible(false)
					end
					imgSkillBG:setGrayRender(false)
					imgSkillIcon:setGrayRender(false)
					txtSkillLv:setVisible(true)
				end
			end
			--天赋详情
			self:_showSelBornSkillContent(profession, self.m_nSelBornSkillIndex)
		end
	end
end

--@brief 	显示选中的天赋技能详情
function WndProfession:_showSelBornSkillContent(profession, nSelIndex, bAdvanceSkill)
	-- body
	if self.m_nTurnIndex == 2 then 
		self:_showSelSecondTurnContent(profession, nSelIndex)
		return 
	elseif self.m_nTurnIndex == 1 and not self.m_bIsPreview and (bAdvanceSkill or self.m_bIsChooseAdSkill) then 
		self:_showAdvanceSkillContent(profession, nSelIndex)
		return
	end
	self:_setBornSkillSelState(profession, nSelIndex)

	local tTempData = self.m_tBornSkillData[profession][nSelIndex]
	if tTempData == nil then return end

	local imgSkillIconSel = GetElement(self.m_root, "imgSkillIconSel_WndProfession", WZUIImage)
	if imgSkillIconSel then 
		imgSkillIconSel:setFile(tTempData.icon)
	end
	--技能名字
	local txtSkillName = GetElement(self.m_root, "txtSkillName_WndProfession", WZUILabelTTF)
	if txtSkillName then 
		txtSkillName:setText(tTempData.name)
	end
	--当前等级的描述
	local txtSkillDesc = GetElement(self.m_root, "txtSkillDesc_WndProfession", WZUILabelTTF)
	if txtSkillDesc then 
		txtSkillDesc:setText(tTempData.desc)
	end
	--下级描述
	GetElement(self.m_root, "btnUpgrade_WndProfession", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.5,0.1))
	local nextLevelData = self:_getBornSkillNextLevelData(tTempData)
	local txtSkillDescNext = GetElement(self.m_root, "txtSkillDescNext_WndProfession", WZUILabelTTF)
	GetElement(self.m_root, "ftxtAdNextAddPro_WndProfession", WZUIFreeTextBox):setVisible(false)
	GetElement(self.m_root, "ftxtAdPro_WndProfession", WZUIFreeTextBox):setVisible(false)
	GetElement(self.m_root, "conCost_WndProfession", WZUIContainer):setVisible(true)
	local txtBtnUpgrade = GetElement(self.m_root, "txtBtnUpgrade_WndProfession", WZUILabelTTF)
	local ftxtUpgradeCost = GetElement(self.m_root, "ftxtUpgradeCost_WndProfession", WZUIFreeTextBox)
	local sCostFormat = [[<T C="255,227,116" S="20" P="1" SC="79,60,48" SE="0" SS="4" >%s</T><I Z = "0.45">%s</I><T C="255,227,116" S="20" P="1" SC="79,60,48" SE="0" SS="4">%d</T>]]
	if txtSkillDescNext then
		if tTempData.state == 0 then 
			txtSkillDescNext:setText(LocalStrings.STAR_SOUL_NOT_ACTIVE)
			txtBtnUpgrade:setTextKey("ACTIVATION")
			if tTempData.expend ~= -1 then 
				local costIcon = GDatatab_item["id_" .. tTempData.expend[1][1]].icon
				ftxtUpgradeCost:setShowText(string.format(sCostFormat, LocalStrings.COST, costIcon, tTempData.expend[1][2]))
			end
		else
			txtBtnUpgrade:setTextKey("STAR_SOUL_BUTTON_UPDATE")
			if nextLevelData then 
				txtSkillDescNext:setText(nextLevelData.desc)
				if nextLevelData.expend ~= -1 then 
					local costIcon = GDatatab_item["id_" .. nextLevelData.expend[1][1]].icon
					ftxtUpgradeCost:setShowText(string.format(sCostFormat, LocalStrings.COST, costIcon, nextLevelData.expend[1][2]))
				end
			else
				txtSkillDescNext:setText(LocalStrings.PROFESSION_TEXT15)
				GetElement(self.m_root, "conCost_WndProfession", WZUIContainer):setVisible(false)
			end
		end
	end
	--预览状态隐藏升级按钮
	GetElement(self.m_root, "btnUpgrade_WndProfession", WZUIButton):setVisible(true)
	if self.m_bIsPreview then
		GetElement(self.m_root, "btnUpgrade_WndProfession", WZUIButton):setVisible(false)
	else
		local nActiveLine = self:getActiveLineIndex()
		if nActiveLine == 1 then 
			if nSelIndex == 9 then
				GetElement(self.m_root, "btnUpgrade_WndProfession", WZUIButton):setVisible(false)
			end
		elseif nActiveLine == 2 then 
			if nSelIndex == 2 then
				GetElement(self.m_root, "btnUpgrade_WndProfession", WZUIButton):setVisible(false)
			end
		end
	end
end

--@brief 	设置天赋选中状态
function WndProfession:_setBornSkillSelState(profession, nSelIndex)
	-- body
	local conSkillSelState = GetElement(self.m_root, "conSkillSelState_WndProfession", WZUIContainer)
	local rootNode = self:getTurnParentNode()
	if profession and profession > 0 then 
		local conProfession = GetElement(rootNode, "conProfession" .. profession .. "_WndProfession", WZUIContainer)
		local conBornSkill = GetElement(conProfession, "conBornSkill" .. nSelIndex .. "_WndProfession", WZUIContainer)
		local posX, posY = conBornSkill:getPositionX(), conBornSkill:getPositionY()
		WZLog("WndProfession:_setBornSkillSelState", posX, posY)
		conSkillSelState:setPosition(posX, posY)
	end

	if self.m_nTurnIndex == 1 and self.m_bIsChooseAdSkill and not self.m_bIsPreview then 
		conSkillSelState:setVisible(false)
	else
		conSkillSelState:setVisible(true)
	end
end

--@brief 	预览
function WndProfession:_showPreview(profession)
	-- body
	if self.m_root == nil then return end 

	self.m_bIsPreview = true
	self.m_nProfessionSel = profession

	GetElement(self.m_root, "conBeforeChoose_WndProfession", WZUIContainer):setVisible(false)
	GetElement(self.m_root, "conAfterChoose_WndProfession", WZUIContainer):setVisible(true)
	if CheckButtonOpen(191, false) then 
		GetElement(self.m_root, "checkboxTurn_WndProfession", WZUIContainer):setVisible(true)
	end

	self:_showContentByProfession(profession)
end

--@brief 	获取一转二转父容器
function WndProfession:getTurnParentNode()
	-- body
	local rootNode = GetElement(self.m_root, "conFirstTurn_WndProfession", WZUIContainer)
	if self.m_nTurnIndex == 2 then 
		rootNode = GetElement(self.m_root, "conSecondTurn_WndProfession", WZUIContainer)
	end

	return rootNode
end

--@brief 	设置是否可见
function WndProfession:_setContentByTurn(nTurnIndex)
	-- body
	if nTurnIndex == 1 then 
		GetElement(self.m_root, "conFirstTurn_WndProfession", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "conSecondTurn_WndProfession", WZUIContainer):setVisible(false)
		self.m_topCellLua:resetData("ui/common/common_icon_zyxt.png", WndProfession, WndProfession.onCloseClick, true, false, false, nil, {goldType = 14})
	elseif nTurnIndex == 2 then 
		GetElement(self.m_root, "conFirstTurn_WndProfession", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "conSecondTurn_WndProfession", WZUIContainer):setVisible(true)
		self.m_topCellLua:resetData("ui/common/common_icon_zyxt.png", WndProfession, WndProfession.onCloseClick, true, false, false, nil, {goldType = 15})
	end
end

--@brief 	显示选中的天赋技能详情
function WndProfession:_showSelSecondTurnContent(profession, nSelIndex)
	-- body
	self:_setBornSkillSelState(profession, nSelIndex)

	local tTempData = self.m_tSecondTurnData[profession][nSelIndex]
	if tTempData == nil then return end

	local imgSkillIconSel = GetElement(self.m_root, "imgSkillIconSel_WndProfession", WZUIImage)
	if imgSkillIconSel then 
		imgSkillIconSel:setFile(tTempData.icon)
	end
	--技能名字
	local txtSkillName = GetElement(self.m_root, "txtSkillName_WndProfession", WZUILabelTTF)
	if txtSkillName then 
		txtSkillName:setText(tTempData.name)
	end
	--当前等级的描述
	local txtSkillDesc = GetElement(self.m_root, "txtSkillDesc_WndProfession", WZUILabelTTF)
	if txtSkillDesc then 
		txtSkillDesc:setText(tTempData.desc)
	end
	GetElement(self.m_root, "btnUpgrade_WndProfession", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.5,0.1))
	GetElement(self.m_root, "btnExchange_WndProfession", WZUIButton):setVisible(false)
	if tTempData.state == 0 and (tTempData.type == 8 or nSelIndex == 5 or nSelIndex == 9) then 
		local bUnknow = false 
		if nSelIndex== 5 or nSelIndex == 9 then 
			if self.m_tSecondTurnData[profession][nSelIndex - 2].state == 0 or self.m_tSecondTurnData[profession][nSelIndex - 1].state == 0 then
				bUnknow = true 
			end 
		else
			bUnknow = true
		end
		if bUnknow then 
			imgSkillIconSel:setFile("ui/common/common_btn_wh.png")
			txtSkillName:setText(LocalStrings.PROFESSION_TWO4)
			txtSkillDesc:setText(LocalStrings.PROFESSION_TWO5)
		end
	elseif tTempData.state == 1 and tTempData.type == 8 then 
		GetElement(self.m_root, "btnExchange_WndProfession", WZUIButton):setVisible(true)
	end
	--下级描述
	local nextLevelData = self:_getBornSkillNextLevelData(tTempData)
	local txtSkillDescNext = GetElement(self.m_root, "txtSkillDescNext_WndProfession", WZUILabelTTF)
	GetElement(self.m_root, "ftxtAdNextAddPro_WndProfession", WZUIFreeTextBox):setVisible(false)
	GetElement(self.m_root, "ftxtAdPro_WndProfession", WZUIFreeTextBox):setVisible(false)
	GetElement(self.m_root, "conCost_WndProfession", WZUIContainer):setVisible(true)
	local txtBtnUpgrade = GetElement(self.m_root, "txtBtnUpgrade_WndProfession", WZUILabelTTF)
	local ftxtUpgradeCost = GetElement(self.m_root, "ftxtUpgradeCost_WndProfession", WZUIFreeTextBox)
	local sCostFormat = [[<T C="255,227,116" S="20" P="1" SC="79,60,48" SE="0" SS="4" >%s</T><I Z = "0.45">%s</I><T C="255,227,116" S="20" P="1" SC="79,60,48" SE="0" SS="4">%d</T>]]
	if txtSkillDescNext then
		if tTempData.state == 0 then 
			txtSkillDescNext:setText(LocalStrings.STAR_SOUL_NOT_ACTIVE)
			txtBtnUpgrade:setTextKey("ACTIVATION")
			if tTempData.expend ~= -1 then 
				local costIcon = GDatatab_item["id_" .. tTempData.expend[1][1]].icon
				ftxtUpgradeCost:setShowText(string.format(sCostFormat, LocalStrings.COST, costIcon, tTempData.expend[1][2]))
			end
		else
			txtBtnUpgrade:setTextKey("STAR_SOUL_BUTTON_UPDATE")
			if nextLevelData then 
				txtSkillDescNext:setText(nextLevelData.desc)
				if nextLevelData.expend ~= -1 then 
					local costIcon = GDatatab_item["id_" .. nextLevelData.expend[1][1]].icon
					ftxtUpgradeCost:setShowText(string.format(sCostFormat, LocalStrings.COST, costIcon, nextLevelData.expend[1][2]))
				end
				if tTempData.type == 8 then 
					GetElement(self.m_root, "btnExchange_WndProfession", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.25,0.1))
					GetElement(self.m_root, "btnUpgrade_WndProfession", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.75,0.1))
				end
			else
				txtSkillDescNext:setText(LocalStrings.PROFESSION_TEXT15)
				GetElement(self.m_root, "conCost_WndProfession", WZUIContainer):setVisible(false)
				GetElement(self.m_root, "btnExchange_WndProfession", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.5,0.1))
			end
		end
	end
	--预览状态隐藏升级按钮
	GetElement(self.m_root, "btnUpgrade_WndProfession", WZUIButton):setVisible(true)
	GetElement(self.m_root, "btnLibrary_WndProfession", WZUIButton):setVisible(false)
	if nSelIndex == 5 or nSelIndex == 9 then 
		GetElement(self.m_root, "btnUpgrade_WndProfession", WZUIButton):setVisible(false)
		GetElement(self.m_root, "btnLibrary_WndProfession", WZUIButton):setVisible(true)
		ftxtUpgradeCost:setShowText(LocalStrings.PROFESSION_TWO13)
	end
	if self.m_bIsPreview then
		GetElement(self.m_root, "btnUpgrade_WndProfession", WZUIButton):setVisible(false)
		GetElement(self.m_root, "btnExchange_WndProfession", WZUIButton):setVisible(false)
	end
end

--@brief 	显示转换和升级水晶后技能的状态
function WndProfession:showCrystalStateAfterUpgrade()
	-- body
	if self.m_nCrystalOperateType == nil then return end 

	local conCrystalOperate = GetElement(self.m_root, "conCrystalOperate_WndProfession", WZUIContainer)
	conCrystalOperate:setVisible(true)
	local txtTitleTwo = GetElement(conCrystalOperate, "txtTitleTwo_WndProfession", WZUILabelTTF)
	local imgTitle = GetElement(conCrystalOperate, "imgTitle_WndProfession", WZUIImage)

	if self.m_nCrystalOperateType == 1 then --激活水晶和技能
		txtTitleTwo:setText(LocalStrings.PROFESSION_TWO16)
		imgTitle:setFile("ui/common/bt_text_jhcg.png")
	elseif self.m_nCrystalOperateType == 2 then --水晶升级
		txtTitleTwo:setText(LocalStrings.PROFESSION_TWO17)
		imgTitle:setFile("ui/common/bt_text_sjcg.png")
	elseif self.m_nCrystalOperateType == 3 then --水晶转换
		txtTitleTwo:setText(LocalStrings.PROFESSION_TWO15)
		imgTitle:setFile("ui/common/bt_text_zhcg.png")
	end

	local tBeforeData = self.m_tBeforeData
	local tCurData = self.m_tSecondTurnData[self.m_nCurProfessionId]
	local nGapping = 2
	if self.m_nOperateTreeType == 1 then 
		nGapping = 2
	elseif self.m_nOperateTreeType == 2 then 
		nGapping = 6
	end
	for i = 1, 3 do
		local conCrystalOrigin = GetElement(self.m_root, "conCrystalOrigin" .. i .. "_WndProfession", WZUIContainer)
		local imgCrystalBG = GetElement(conCrystalOrigin, "imgCrystalBG" .. i .. "_WndProfession", WZUIImage)
		local imgCrystalIcon = GetElement(conCrystalOrigin, "imgCrystalIcon" .. i .. "_WndProfession", WZUIImage)
		local txtCrystalLv = GetElement(conCrystalOrigin, "txtCrystalLv" .. i .. "_WndProfession", WZUILabelTTF)

		imgCrystalIcon:setFile(tBeforeData[i + nGapping].icon)
		txtCrystalLv:setText(LocalStrings.LV .. tBeforeData[i + nGapping].lv)
		if tBeforeData[i + nGapping].state == 0 then 
			imgCrystalBG:setGrayRender(true)
			imgCrystalIcon:setGrayRender(true)
			txtCrystalLv:setVisible(false)
			imgCrystalIcon:setFile("ui/common/common_btn_wh.png")
		else
			imgCrystalBG:setGrayRender(false)
			imgCrystalIcon:setGrayRender(false)
			txtCrystalLv:setVisible(true)
		end

		local conCrystalAfter = GetElement(self.m_root, "conCrystalAfter" .. i .. "_WndProfession", WZUIContainer)
		imgCrystalBG = GetElement(conCrystalAfter, "imgCrystalBG" .. i .. "_WndProfession", WZUIImage)
		imgCrystalIcon = GetElement(conCrystalAfter, "imgCrystalIcon" .. i .. "_WndProfession", WZUIImage)
		txtCrystalLv = GetElement(conCrystalAfter, "txtCrystalLv" .. i .. "_WndProfession", WZUILabelTTF)

		imgCrystalIcon:setFile(tCurData[i + nGapping].icon)
		txtCrystalLv:setText(LocalStrings.LV .. tCurData[i + nGapping].lv)
		if tCurData[i + nGapping].state == 0 then 
			imgCrystalBG:setGrayRender(true)
			imgCrystalIcon:setGrayRender(true)
			txtCrystalLv:setVisible(false)
			imgCrystalIcon:setFile("ui/common/common_btn_wh.png")
		else
			imgCrystalBG:setGrayRender(false)
			imgCrystalIcon:setGrayRender(false)
			txtCrystalLv:setVisible(true)
		end
	end

	self.m_nCrystalOperateType = nil 
	self.m_bIsTransColor = false 
end

--@brief 	设置进阶技能的可见与否
function WndProfession:setAdvanceSkillVisible()
	local conAdvanceSkill = GetElement(self.m_root, "conAdvanceSkill_WndProfession", WZUIContainer)

	if self.m_nTurnIndex == 2 or self.m_nCurProfessionId == 0 or self.m_nAdvanceSkillFloor < 0 or self.m_bIsPreview then 
		conAdvanceSkill:setVisible(false)
	else
		conAdvanceSkill:setVisible(true)
		self:setAdvanceSkillContent()
	end
end

--@brief 	设置进阶技能的内容
function WndProfession:setAdvanceSkillContent()
	local conAdvanceSkill = GetElement(self.m_root, "conAdvanceSkill_WndProfession", WZUIContainer)
	if conAdvanceSkill:isVisible() then 
		local imgAdSkillIcon = GetElement(conAdvanceSkill, "imgAdSkillIcon_WndProfession", WZUIImage)
		local advanceSkillData = self:getAdvanceSkillData()
		if advanceSkillData then 
			imgAdSkillIcon:setFile(advanceSkillData.icon)
		end
	end
end

--@brief 	显示选中的进阶技能详情
function WndProfession:_showAdvanceSkillContent(profession, nSelIndex)
	-- body
	self:_setBornSkillSelState(profession, nSelIndex)

	local tTempData = self:getAdvanceSkillData()
	if tTempData == nil then return end

	local imgSkillIconSel = GetElement(self.m_root, "imgSkillIconSel_WndProfession", WZUIImage)
	if imgSkillIconSel then 
		imgSkillIconSel:setFile(tTempData.icon)
	end
	--技能名字
	local txtSkillName = GetElement(self.m_root, "txtSkillName_WndProfession", WZUILabelTTF)
	if txtSkillName then 
		txtSkillName:setText(LocalStrings.PROFESSION_ADVANCE1 .. "·" .. LocalStrings.PROFESSION_TEXT2[self.m_nCurProfessionId])
	end
	--当前等级的描述
	local txtSkillDesc = GetElement(self.m_root, "txtSkillDesc_WndProfession", WZUILabelTTF)
	if txtSkillDesc then 
		txtSkillDesc:setText(string.format(LocalStrings.PROFESSION_ADVANCE2, tTempData.lv, tTempData.grade))
	end
	--升级消耗
	local ftxtUpgradeCost = GetElement(self.m_root, "ftxtUpgradeCost_WndProfession", WZUIFreeTextBox)
	local sCostFormat = [[<T C="255,227,116" S="20" P="1" SC="79,60,48" SE="0" SS="4" >%s</T>]]
	local sCostFormat2 = [[<I Z = "0.45">%s</I><T C="255,227,116" S="20" P="1" SC="79,60,48" SE="0" SS="4">%d</T><BL>30</BL>]]
	if tTempData.expend ~= -1 then 
		local costContent = string.format(sCostFormat, LocalStrings.COST)
		for i = 1, #tTempData.expend do
			local costIcon = GDatatab_item["id_" .. tTempData.expend[i][1]].icon
			local tempCostString = string.format(sCostFormat2, costIcon, tTempData.expend[i][2])

			costContent = costContent .. tempCostString
		end
		ftxtUpgradeCost:setShowText(costContent)
	end
	--当前属性的显示
	local sProFormat = [[<T C="255,236,193" S="20" P="1" SC="79,60,48" SE="0" SS="4">%s:</T><T C="229,105,22" S="20" P="1" SC="79,60,48" SE="0" SS="4">%d</T>]]
	local sProFormat2 = [[<BL>30</BL>]]
	local sProFormat3 = [[<BR>4</BR>]]
	local ftxtAdPro = GetElement(self.m_root, "ftxtAdPro_WndProfession", WZUIFreeTextBox)
	ftxtAdPro:setVisible(true)
	local proContent = ""
	for i = 1, #self.m_tAdvanceProperty do
		local tempProString = string.format(sProFormat, ATTR_TITLE[self.m_tAdvanceProperty[i][1]], self.m_tAdvanceProperty[i][2])
		proContent = proContent .. tempProString
		if math.fmod(i, 2) == 1 then 
			proContent = proContent .. sProFormat2
		else
			proContent = proContent .. sProFormat3
		end
	end
	if #self.m_tAdvanceProperty <= 0 then 
		local sProAttFormat = [[<T C="255,255,255" S="20" P="1" SC="79,60,48" SE="0" SS="4">%s</T>]]
		proContent = string.format(sProAttFormat, LocalStrings.WAKEUP_TEXT17)
	end
	ftxtAdPro:setShowText(proContent)

	--下级描述
	GetElement(self.m_root, "btnUpgrade_WndProfession", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.5,0.1))
	local nextLevelData = self:getAdvanceSkillData(true)
	local txtSkillDescNext = GetElement(self.m_root, "txtSkillDescNext_WndProfession", WZUILabelTTF)
	local ftxtAdNextAddPro = GetElement(self.m_root, "ftxtAdNextAddPro_WndProfession", WZUIFreeTextBox)
	GetElement(self.m_root, "conCost_WndProfession", WZUIContainer):setVisible(true)
	local txtBtnUpgrade = GetElement(self.m_root, "txtBtnUpgrade_WndProfession", WZUILabelTTF)
	if txtSkillDescNext then
		txtBtnUpgrade:setTextKey("STAR_SOUL_BUTTON_UPDATE")
		ftxtAdNextAddPro:setVisible(true)
		if nextLevelData then 
			txtSkillDescNext:setText("")
			local proAddContent = ""
			for i = 1, #nextLevelData.attribute do
				local sProFormat4 = [[<T C="255,236,193" S="20" P="1" SC="79,60,48" SE="0" SS="4">%s:</T><T C="229,105,22" S="20" P="1" SC="79,60,48" SE="0" SS="4">+%d</T>]]
				local tempProString = string.format(sProFormat4, ATTR_TITLE[nextLevelData.attribute[i][1]], nextLevelData.attribute[i][2])
				proAddContent = proAddContent .. tempProString
				if math.fmod(i, 2) == 1 then 
					proAddContent = proAddContent .. sProFormat2
				else
					proAddContent = proAddContent .. sProFormat3
				end
			end
			ftxtAdNextAddPro:setShowText(proAddContent)
		else
			ftxtAdNextAddPro:setVisible(false)
			txtSkillDescNext:setText(LocalStrings.PROFESSION_TEXT15)
			GetElement(self.m_root, "conCost_WndProfession", WZUIContainer):setVisible(false)
		end
	end
	--预览状态隐藏升级按钮
	GetElement(self.m_root, "btnUpgrade_WndProfession", WZUIButton):setVisible(true)
end

--@brief 	适配iphoneX 
function WndProfession:_adaptIphoneX()
	-- body
	if IsIphoneX() then
		GetElement(self.m_root, "conAdvanceSkill_WndProfession", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.08, 0.7))
	end
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配begin----------------------------------------
function WndProfession:_adaptLanguage_vn()
	local txtSkillName = GetElement(self.m_root, "txtSkillName_WndProfession", WZUILabelTTF)
	txtSkillName:setScale(0.8)
	txtSkillName:setDimensions(GlobalMethod:CCSize(160))
	local txtSkillDesc = GetElement(self.m_root, "txtSkillDesc_WndProfession", WZUILabelTTF)
	txtSkillDesc:setScale(0.7)
	txtSkillDesc:setDimensions(GlobalMethod:CCSize(380))
	local txtSkillDescNext = GetElement(self.m_root, "txtSkillDescNext_WndProfession", WZUILabelTTF)
	txtSkillDescNext:setScale(0.7)
	txtSkillDescNext:setDimensions(GlobalMethod:CCSize(380))

	GetElement(self.m_root,"txtProfessionDesc1_WndProfession",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,0.223538))
	GetElement(self.m_root,"txtProfessionDesc2_WndProfession",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,0.223538))
	GetElement(self.m_root,"txtProfessionDesc3_WndProfession",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,0.223538))

	GetElement(self.m_root,"txtAdSkillName_WndProfession",WZUILabelTTF):setScale(0.8)
end
-------------------------------------语言适配end----------------------------------------
