--WndFactionMain.lua
--@brief	WndFactionMain的UI模块
--@date		2023/05/26
--@author	yrd
--@note		宗门界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFactionMain:onEnter(element)
	self.m_root = element

	self:_initStaticText()

	ProtocolProcessorWndMaster:send_MENTORING_GetZmInfo()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFactionMain:onExit(element)
	self:_unInit()
end

--@brief	初始化静态文本
function WndFactionMain:_initStaticText(element)
	GetElement(self.m_root,"txt1Title_WndFactionMain",WZUILabelTTF):setText(LocalStrings.FACTION_TEXT1[2])
	GetElement(self.m_root,"txt1LevelWord_WndFactionMain",WZUILabelTTF):setText(LocalStrings.FACTION_TEXT1[4]..":")
	GetElement(self.m_root,"txt1AttributesWord_WndFactionMain",WZUILabelTTF):setText(LocalStrings.FACTION_TEXT1[5])
	GetElement(self.m_root,"txt1BuffWord_WndFactionMain",WZUILabelTTF):setText(LocalStrings.FACTION_TEXT1[6]..":")
	GetElement(self.m_root,"txt1Tips1_WndFactionMain",WZUILabelTTF):setText(LocalStrings.FACTION_TEXT1[7])
	GetElement(self.m_root,"txt1ExpWord_WndFactionMain",WZUILabelTTF):setText(LocalStrings.FACTION_TEXT1[20]..":")

	GetElement(self.m_root,"txt2Title_WndFactionMain",WZUILabelTTF):setText(LocalStrings.FACTION_TEXT1[3])
	GetElement(self.m_root,"txt2LevelWord1_WndFactionMain",WZUILabelTTF):setText(LocalStrings.FACTION_TEXT1[4]..":")
	GetElement(self.m_root,"txt2LevelWord2_WndFactionMain",WZUILabelTTF):setText(LocalStrings.FACTION_TEXT1[8]..":")
	GetElement(self.m_root,"txt2LevelWord3_WndFactionMain",WZUILabelTTF):setText(LocalStrings.FACTION_TEXT1[9]..":")
	GetElement(self.m_root,"txt2AttributesWord_WndFactionMain",WZUILabelTTF):setText(LocalStrings.FACTION_TEXT1[5])
	GetElement(self.m_root,"txt2BuffWord_WndFactionMain",WZUILabelTTF):setText(LocalStrings.FACTION_TEXT1[6]..":")
	GetElement(self.m_root,"txt2Tips1_WndFactionMain",WZUILabelTTF):setText(LocalStrings.FACTION_TEXT1[7])
	GetElement(self.m_root,"txt2Tips2_WndFactionMain",WZUILabelTTF):setText(LocalStrings.FACTION_TEXT1[10])
end

--@brief	更新界面
function WndFactionMain:updateUI()
	local masterInfo = CacheCenter:getMasterInfo()

	--我的宗门
	local tCurLevelInfo = self:getFactionLevelInfo(self.m_nMyZmLevel)
	local tNextLevelInfo = self:getFactionLevelInfo(self.m_nMyZmLevel+1)

	local txt1LevelValue = GetElement(self.m_root,"txt1LevelValue_WndFactionMain",WZUILabelTTF)
	txt1LevelValue:setText(string.format(LocalStrings.ACTIVITY_SHOW_LEVEL,self.m_nMyZmLevel))

	local img1ExpIcon = GetElement(self.m_root,"img1ExpIcon_WndFactionMain",WZUIImage)
	local tItemData = GDatatab_item["id_"..self.m_nItemId1]
	img1ExpIcon:setFile(tItemData.icon)

	local txt1ExpValue = GetElement(self.m_root,"txt1ExpValue_WndFactionMain",WZUILabelTTF)
	txt1ExpValue:setText(self.m_nMyZmExp)

	local tMyPropertyInfo
	for k,v in pairs(GDatatab_mentoring_zm_property) do
		if tonumber(v.level_zm) == self.m_nMyZmLevel then
			if tMyPropertyInfo == nil or tMyPropertyInfo.level_tudi < v.level_tudi then
				tMyPropertyInfo = v
			end
		end
	end

	for i=1,4 do
		local img1AttrStar = GetElement(self.m_root,"img1AttrStar"..i.."_WndFactionMain",WZUIImage)
		local txt1AttrName = GetElement(self.m_root,"txt1AttrName"..i.."_WndFactionMain",WZUILabelTTF)
		local txt1AttrValue = GetElement(self.m_root,"txt1AttrValue"..i.."_WndFactionMain",WZUILabelTTF)
		img1AttrStar:setVisible(false)
		if type(tMyPropertyInfo.property) == "table" and tMyPropertyInfo.property[i] then
			img1AttrStar:setVisible(true)
			txt1AttrName:setText(ATTR_TITLE[tMyPropertyInfo.property[i][1]])
			txt1AttrValue:setText(tMyPropertyInfo.property[i][2])
		end
	end
	if tMyPropertyInfo.property == -1 then
		GetElement(self.m_root,"txt1AttributesNone_WndFactionMain",WZUILabelTTF):setVisible(true)
	else
		GetElement(self.m_root,"txt1AttributesNone_WndFactionMain",WZUILabelTTF):setVisible(false)
	end

	local txt1BuffValue = GetElement(self.m_root,"txt1BuffValue_WndFactionMain",WZUILabelTTF)
	if tMyPropertyInfo.buff_id == -1 then
		txt1BuffValue:setText(LocalStrings.NONE)
	else
		local strProperty = ""
		local tBuffInfo = GDatatab_buff["id_"..tMyPropertyInfo.buff_id]
		local tEffectInfo = GDatatab_effect["id_"..tBuffInfo.effect_id]
		for i=1,#tEffectInfo.effect do
			if tEffectInfo.effect[i][1] == 0 and tEffectInfo.effect[i][2] == 1 and tEffectInfo.effect[i][3] == 1 and tEffectInfo.effect[i][4] == 2 then
				strProperty = strProperty .. " " .. ATTR_TITLE[tEffectInfo.effect[i][5]] .. "+" .. (tEffectInfo.effect[i][6]/100) .. "%"
			end
		end
		txt1BuffValue:setText(strProperty)
	end

	local btnUpgrade = GetElement(self.m_root,"btnUpgrade_WndFactionMain",WZUIButton)
	local txt1CurLevel = GetElement(self.m_root,"txt1CurLevel_WndFactionMain",WZUILabelTTF)
	local img1Arrow = GetElement(self.m_root,"img1Arrow_WndFactionMain",WZUIImage)
	local txt1NextLevel = GetElement(self.m_root,"txt1NextLevel_WndFactionMain",WZUILabelTTF)
	local txt1MaxLevel = GetElement(self.m_root,"txt1MaxLevel_WndFactionMain",WZUILabelTTF)
	local con1Cost = GetElement(self.m_root,"con1Cost_WndFactionMain",WZUIContainer)
	txt1CurLevel:setText(LocalStrings.LV..self.m_nMyZmLevel)
	txt1NextLevel:setText(LocalStrings.LV..(self.m_nMyZmLevel+1))
	if tNextLevelInfo then
		btnUpgrade:setTouchEnable(true)
		txt1CurLevel:setVisible(true)
		img1Arrow:setVisible(true)
		txt1NextLevel:setVisible(true)
		txt1MaxLevel:setVisible(false)
		con1Cost:setVisible(true)
	else
		btnUpgrade:setTouchEnable(false)
		txt1CurLevel:setVisible(false)
		img1Arrow:setVisible(false)
		txt1NextLevel:setVisible(false)
		txt1MaxLevel:setVisible(true)
		con1Cost:setVisible(false)
	end

	for i=1,2 do
		local con1CostItem = GetElement(self.m_root,"con1CostItem"..i.."_WndFactionMain",WZUIContainer)
		local img1CostItem = GetElement(self.m_root,"img1CostItem"..i.."_WndFactionMain",WZUIImage)
		local txt1CostItem = GetElement(self.m_root,"txt1CostItem"..i.."_WndFactionMain",WZUILabelTTF)
		con1CostItem:setVisible(false)
		if tCurLevelInfo.cost[i] then
			con1CostItem:setVisible(true)
			local tItemData = GDatatab_item["id_"..tCurLevelInfo.cost[i][1]]
			img1CostItem:setFile(tItemData.icon)
			txt1CostItem:setText(tCurLevelInfo.cost[i][2])
		end
	end
	

	--师傅宗门
	local con2Master1 = GetElement(self.m_root,"con2Master1_WndFactionMain",WZUIContainer)
	local con2Master2 = GetElement(self.m_root,"con2Master2_WndFactionMain",WZUIContainer)
	con2Master1:setVisible(false)
	con2Master2:setVisible(true)

	--有师傅
	local playerInfo = CacheCenter:getPlayerInfo()
	if playerInfo.masterName ~= "" and playerInfo.masterName ~= "[]" then
		con2Master1:setVisible(true)
		con2Master2:setVisible(false)

		local tCurTudiLevelInfo = self:getApprenticeLevelInfo(self.m_nTudiLevel)
		local tNextTudiLevelInfo = self:getApprenticeLevelInfo(self.m_nTudiLevel+1)

		local img2LevelIcon3 = GetElement(self.m_root,"img2LevelIcon3_WndFactionMain",WZUIImage)
		local tItemData = GDatatab_item["id_"..self.m_nItemId2]
		img2LevelIcon3:setFile(tItemData.icon)

		local txt2LevelValue1 = GetElement(self.m_root,"txt2LevelValue1_WndFactionMain",WZUILabelTTF)
		local txt2LevelValue2 = GetElement(self.m_root,"txt2LevelValue2_WndFactionMain",WZUILabelTTF)
		local txt2LevelValue3 = GetElement(self.m_root,"txt2LevelValue3_WndFactionMain",WZUILabelTTF)
		txt2LevelValue1:setText(string.format(LocalStrings.ACTIVITY_SHOW_LEVEL,self.m_nShifuZmLevel))
		txt2LevelValue2:setText(tCurTudiLevelInfo.name)
		txt2LevelValue3:setText(self.m_nTudiExp)

		local tMyPropertyInfo
		for k,v in pairs(GDatatab_mentoring_zm_property) do
			if tonumber(v.level_zm) == self.m_nShifuZmLevel and v.level_tudi == self.m_nTudiLevel then
				tMyPropertyInfo = v
			end
		end

		for i=1,4 do
			local img2AttrStar = GetElement(self.m_root,"img2AttrStar"..i.."_WndFactionMain",WZUIImage)
			local txt2AttrName = GetElement(self.m_root,"txt2AttrName"..i.."_WndFactionMain",WZUILabelTTF)
			local txt2AttrValue = GetElement(self.m_root,"txt2AttrValue"..i.."_WndFactionMain",WZUILabelTTF)
			img2AttrStar:setVisible(false)
			if type(tMyPropertyInfo.property) == "table" and tMyPropertyInfo.property[i] then
				img2AttrStar:setVisible(true)
				txt2AttrName:setText(ATTR_TITLE[tMyPropertyInfo.property[i][1]])
				txt2AttrValue:setText(tMyPropertyInfo.property[i][2])
			end
		end
		if tMyPropertyInfo.property == -1 then
			GetElement(self.m_root,"txt2AttributesNone_WndFactionMain",WZUILabelTTF):setVisible(true)
		else
			GetElement(self.m_root,"txt2AttributesNone_WndFactionMain",WZUILabelTTF):setVisible(false)
		end

		local txt2BuffValue = GetElement(self.m_root,"txt2BuffValue_WndFactionMain",WZUILabelTTF)
		if tMyPropertyInfo.buff_id == -1 then
			txt2BuffValue:setText(LocalStrings.NONE)
		else
			local strProperty = ""
			local tBuffInfo = GDatatab_buff["id_"..tMyPropertyInfo.buff_id]
			local tEffectInfo = GDatatab_effect["id_"..tBuffInfo.effect_id]
			for i=1,#tEffectInfo.effect do
				if tEffectInfo.effect[i][1] == 0 and tEffectInfo.effect[i][2] == 1 and tEffectInfo.effect[i][3] == 1 and tEffectInfo.effect[i][4] == 2 then
					strProperty = strProperty .. " " .. ATTR_TITLE[tEffectInfo.effect[i][5]] .. "+" .. (tEffectInfo.effect[i][6]/100) .. "%"
				end
			end
			txt2BuffValue:setText(strProperty)
		end

		local btnAscending = GetElement(self.m_root,"btnAscending_WndFactionMain",WZUIButton)
		local txt2CurLevel = GetElement(self.m_root,"txt2CurLevel_WndFactionMain",WZUILabelTTF)
		local img2Arrow = GetElement(self.m_root,"img2Arrow_WndFactionMain",WZUIImage)
		local txt2NextLevel = GetElement(self.m_root,"txt2NextLevel_WndFactionMain",WZUILabelTTF)
		local txt2MaxLevel = GetElement(self.m_root,"txt2MaxLevel_WndFactionMain",WZUILabelTTF)
		local con2Cost = GetElement(self.m_root,"con2Cost_WndFactionMain",WZUIContainer)
		txt2CurLevel:setText(tCurTudiLevelInfo.name)
		txt2NextLevel:setText(tNextTudiLevelInfo.name)
		if tNextTudiLevelInfo then
			btnAscending:setTouchEnable(true)
			txt2CurLevel:setVisible(true)
			img2Arrow:setVisible(true)
			txt2NextLevel:setVisible(true)
			txt2MaxLevel:setVisible(false)
			con2Cost:setVisible(true)
		else
			btnAscending:setTouchEnable(false)
			txt2CurLevel:setVisible(false)
			img2Arrow:setVisible(false)
			txt2NextLevel:setVisible(false)
			txt2MaxLevel:setVisible(true)
			con2Cost:setVisible(false)
		end

		for i=1,2 do
			local con2CostItem = GetElement(self.m_root,"con2CostItem"..i.."_WndFactionMain",WZUIContainer)
			local img2CostItem = GetElement(self.m_root,"img2CostItem"..i.."_WndFactionMain",WZUIImage)
			local txt2CostItem = GetElement(self.m_root,"txt2CostItem"..i.."_WndFactionMain",WZUILabelTTF)
			con2CostItem:setVisible(false)
			if tCurTudiLevelInfo.cost[i] then
				con2CostItem:setVisible(true)
				local tItemData = GDatatab_item["id_"..tCurTudiLevelInfo.cost[i][1]]
				img2CostItem:setFile(tItemData.icon)
				txt2CostItem:setText(tCurTudiLevelInfo.cost[i][2])
			end
		end
	end
end

--@brief	点击升级按钮回调
function WndFactionMain:onClickUpgrade(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	--物品不足
	local tCurLevelInfo = self:getFactionLevelInfo(self.m_nMyZmLevel)
	for i=1,2 do
		if tCurLevelInfo.cost[i] then
			if not JudgeMoneyIsEnough(tCurLevelInfo.cost[i][1], tCurLevelInfo.cost[i][2], nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.onSureUpgrade) then
				return 
			end
		end
	end

	self:onSureUpgrade()
end

--@brief	确定升级
function WndFactionMain:onSureUpgrade()
	ProtocolProcessorWndMaster:send_MENTORING_UpgradeZm()
end

--@brief	点击升阶按钮回调
function WndFactionMain:onClickAscending(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	--物品不足
	local tCurTudiLevelInfo = self:getApprenticeLevelInfo(self.m_nTudiLevel)
	for i=1,2 do
		if tCurTudiLevelInfo.cost[i] then
			if not JudgeMoneyIsEnough(tCurTudiLevelInfo.cost[i][1], tCurTudiLevelInfo.cost[i][2], nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.onSureAscending) then
				return 
			end
		end
	end

	self:onSureAscending()
end

--@brief	确定升阶
function WndFactionMain:onSureAscending()
	ProtocolProcessorWndMaster:send_MENTORING_UpgradeTudi()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
