--WndCommunityAppoint.lua
--@brief	WndCommunityAppoint的UI模块
--@date		2016/08/30
--@author	zsq
--@note		职位任命


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCommunityAppoint:onEnter(element)
	self.m_root = element
end

--@brief    onenter函数已执行
function WndCommunityAppoint:onEnterTransitionDidFinish(element)
	self.m_nTag = 1

	local position = tonumber(CacheCenter:getPlayerInfo().position)
	local tPosList = {COMMUNITY_PRESIDENT, COMMUNITY_VICE_PRESIDENT, COMMUNITY_ELDER}
	if self.m_nWinType == 1 then 
		position = tonumber(CacheCenter:getUnionInfo().position)
		tPosList = {UNION_PRESIDENT, UNION_VICE_PRESIDENT, UNION_ELDER}
	end
	if position == tPosList[1] then
		self.m_nTag = 1
		GetElement(self.m_root,"checkInfo0",WZUICheckBox):setCheckIndex(1)
		GetElement(self.m_root,"checkInfo1",WZUICheckBox):setCheckIndex(0)
		GetElement(self.m_root,"checkInfo2",WZUICheckBox):setCheckIndex(0)
	elseif position == tPosList[2] then
		self.m_nTag = 2
		GetElement(self.m_root,"checkInfo0",WZUICheckBox):setCheckIndex(1)
		GetElement(self.m_root,"checkInfo0",WZUICheckBox):setTouchEnable(false)
		GetElement(self.m_root,"imgTab1",WZUI9Image):setGrayRender(true)
		GetElement(self.m_root,"imgTab11",WZUI9Image):setGrayRender(true)
		GetElement(self.m_root,"checkInfo1",WZUICheckBox):setCheckIndex(1)
		GetElement(self.m_root,"checkInfo2",WZUICheckBox):setCheckIndex(0)
	elseif position == tPosList[3] then
		self.m_nTag = 3
		GetElement(self.m_root,"checkInfo0",WZUICheckBox):setCheckIndex(1)
		GetElement(self.m_root,"checkInfo0",WZUICheckBox):setTouchEnable(false)
		GetElement(self.m_root,"imgTab1",WZUI9Image):setGrayRender(true)
		GetElement(self.m_root,"imgTab11",WZUI9Image):setGrayRender(true)
		GetElement(self.m_root,"checkInfo1",WZUICheckBox):setCheckIndex(1)
		GetElement(self.m_root,"checkInfo1",WZUICheckBox):setTouchEnable(false)
		GetElement(self.m_root,"imgTab2",WZUI9Image):setGrayRender(true)
		GetElement(self.m_root,"imgTab22",WZUI9Image):setGrayRender(true)
		GetElement(self.m_root,"checkInfo2",WZUICheckBox):setCheckIndex(1)
	end
	self:_setStaticText()
	self:refresh()
	AdaptLanguage(self)
end

--@brief	成员按战力排序
function _sortAppointByFight(a,b)
	--战力
	if a.fight ~= b.fight then
		return a.fight > b.fight
	--本周贡献
	elseif a.weekDonate ~= b.weekDonate then
		return a.weekDonate >= b.weekDonate
	--等级
	elseif a.playerLevel ~= b.playerLevel then
		return a.playerLevel >= b.playerLevel
	--ID
	else
		return a.playerId < b.playerId
	end
end

--@brief	成员按周贡献排序
function _sortAppointByWeekDonate(a,b)
	--本周贡献
	if a.weekDonate ~= b.weekDonate then
		return a.weekDonate >= b.weekDonate
	--职位
	elseif a.position ~= b.position then
		return a.position > b.position
	--等级
	elseif a.playerLevel ~= b.playerLevel then
		return a.playerLevel >= b.playerLevel
	--ID
	else
		return a.playerId < b.playerId
	end
end

--@brief	成员按总贡献排序
function _sortAppointByTotalDonate(a,b)
	--职位
	if a.allDonate ~= b.allDonate then
		return a.allDonate >= b.allDonate
	--本周贡献
	elseif a.position ~= b.position then
		return a.position > b.position
	--等级
	elseif a.playerLevel ~= b.playerLevel then
		return a.playerLevel >= b.playerLevel
	--ID
	else
		return a.playerId < b.playerId
	end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCommunityAppoint:onExit(element)
	self:_unInit()
end

--@brief	关闭按钮
function WndCommunityAppoint:onClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if self.m_root ~= nil then 
		WindowManager:removeWindow(self.m_root, WndCommunityAppoint, true)
	end 
end

--@brief	协议返回后刷新界面
function WndCommunityAppoint:refresh()
	self.m_tChangeList = {}
	if self.m_nWinType == 0 then 
		self.m_tDataList = CopyTable(SceneMemberList.m_tMemberList)
	elseif self.m_nWinType == 1 then 
		self.m_tDataList = CopyTable(WndUnionHall.m_tMemberList)
	end
	if self.m_nSortTypeSel == 1 then 
		table.sort(self.m_tDataList , _sortAppointByFight)
	elseif self.m_nSortTypeSel == 2 then 
		table.sort(self.m_tDataList , _sortAppointByWeekDonate)
	elseif self.m_nSortTypeSel == 3 then 
		table.sort(self.m_tDataList , _sortAppointByTotalDonate)
	end
	self:update()
	self:_showSortTypeList()
end

--@brief	点击标签
function WndCommunityAppoint:onCheck(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	self.m_tChangeList = {}
	self.m_nTag = tonumber(element:getTag()) or 1
	self:update()
end

--@brief	确认任命
function WndCommunityAppoint:onSure(element)
	WZLog("WndCommunityAppoint:onSure",Serialize(self.m_tChangeList),self.m_nTag)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_bLoding == true then
		MsgBoxManager:showTipBox(LocalStrings.RESOURCES_LOADING)
		return
	end
    local ids = WZLuaVector_int_:create()
	if self.m_tChangeList and next(self.m_tChangeList) then
		for i=1,#self.m_tChangeList do
			ids:push(self.m_tChangeList[i])
		end
		if self.m_nWinType == 0 then 
			ProtocolProcessorSceneCommunity:send_GUILD_ChangeMemberPost(ids, (4 - self.m_nTag))
		elseif self.m_nWinType == 1 then 
			ProtocolProcessorUnion:send_LEAGUE_ChangePostBatch(ids, (4 - self.m_nTag))
		end
	else 
		MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO240)
	end
end

function WndCommunityAppoint:onTouchEnd()
	self:_updateCheckboxGroupIndex()
end

--@brief 	更新CheckboxGroup选中标签
function WndCommunityAppoint:_updateCheckboxGroupIndex()
	local position = tonumber(CacheCenter:getPlayerInfo().position)
	local tPosList = {COMMUNITY_VICE_PRESIDENT, COMMUNITY_ELDER}
	if self.m_nWinType == 1 then 
		position = tonumber(CacheCenter:getUnionInfo().position)
		tPosList = {UNION_VICE_PRESIDENT, UNION_ELDER}
	end
	if position == tPosList[1] then
		GetElement(self.m_root,"checkInfo0",WZUICheckBox):setCheckIndex(1)
	elseif position == tPosList[2] then
		GetElement(self.m_root,"checkInfo0",WZUICheckBox):setCheckIndex(1)
		GetElement(self.m_root,"checkInfo1",WZUICheckBox):setCheckIndex(1)
	end
end

--@brief 	点击切换排序按钮回调
function WndCommunityAppoint:onSwitchSort(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	-- if self.m_nWinType == 1 then return end 

	self:_switchSortType()
end

--@brief 	切换排序
function WndCommunityAppoint:onClickSortType(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()

	if nTag == self.m_nSortTypeSel then return end 

	self.m_nSortTypeSel = nTag 
	self.m_tChangeList = {}
	self:_showSortTypeList()
	self:_switchSortType()
	if self.m_nSortTypeSel == 1 then 
		table.sort(self.m_tDataList , _sortAppointByFight)
	elseif self.m_nSortTypeSel == 2 then 
		table.sort(self.m_tDataList , _sortAppointByWeekDonate)
	elseif self.m_nSortTypeSel == 3 then 
		table.sort(self.m_tDataList , _sortAppointByTotalDonate)
	end
	self:update()
end

--@brief 	触摸开始回调
function WndCommunityAppoint:onTouchBegan(element, pt)
	-- body
	if self.m_bIsShowSortList then 
		if not self:checkPointInBtn(pt) then
			self:_switchSortType()
		end
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndCommunityAppoint:update()
	WZLog("WndCommunityAppoint:update", self.m_nTag, #self.m_tDataList)
	if self.m_root == nil then return end 
	self.m_root:disableSchedule()
	self.m_bLoding = true
	local freeListContainer = GetElement(self.m_root,"freeconText_Wnd",WZUIFreeListContainer)
	freeListContainer:removeAll()

	--没有数据时显示提示
	if self.m_tDataList == nil or #self.m_tDataList == 0 then 
		ShowPanelNullTip(freeListContainer)
		return 
	else
		removeShowPanelNullTip(freeListContainer)
	end

	self.m_nNumber = 0
	self.m_nCurrentCellIndex = 1 
	--开启逐帧加载tbconContainer每个单元格的定时器
	--self.m_root:enableSchedule("scheduleCreateCell")
	self:scheduleCreateCell()
end

function WndCommunityAppoint:scheduleCreateCell(element, delta)
	--WZLog("WndCommunityAppoint:scheduleCreateCell", self.m_nTag, self.m_nCurrentCellIndex, #self.m_tDataList)
	--判断是否加载完
	local tPosition = {LocalStrings.VICE_PRESIDENT,LocalStrings.ELDERS,LocalStrings.PICK}
	local strFormat = LocalStrings.COMMUNITYINFO131
	if self.m_nWinType == 1 then 
		tPosition = {LocalStrings.UNION_TEXT1[13],LocalStrings.ELDERS,LocalStrings.PICK}
		strFormat = LocalStrings.UNION_TEXT1[21]
	end
	if self.m_nCurrentCellIndex > #self.m_tDataList then
		self.m_root:disableSchedule()
		self.m_bLoding = false

		key = {"fhz","zl","jy"}
		if self.m_nWinType == 0 then 
			for k,v in pairs(GDatatab_guild_level) do
				if v.level == CacheCenter:getGuildInfo().guildLevel then
					self.m_nTotal = v[key[self.m_nTag]]
				end
			end
		elseif self.m_nWinType == 1 then 
			for k,v in pairs(GDatatab_league_level) do
				if v.level == CacheCenter:getUnionInfo().guildLevel then
					self.m_nTotal = v[key[self.m_nTag]]
				end
			end
		end
		GetElement(self.m_root,"ttf1",WZUILabelTTF):setText(string.format(strFormat,tPosition[self.m_nTag]))
		GetElement(self.m_root,"ttf2",WZUILabelTTF):setText(self.m_nNumber.."/"..self.m_nTotal)
		return
	end

	local freeListContainer = GetElement(self.m_root,"freeconText_Wnd",WZUIFreeListContainer)
	local max = math.min(self.m_nCurrentCellIndex+10, #self.m_tDataList)
	local position = tonumber(CacheCenter:getPlayerInfo().position)
	if self.m_nWinType == 1 then 
		position = tonumber(CacheCenter:getUnionInfo().position)
	end
	for i=self.m_nCurrentCellIndex,max do
		if tonumber(self.m_tDataList[i].position) < position then
			if tonumber(self.m_tDataList[i].position) == (4 - self.m_nTag) then
				self.m_nNumber = self.m_nNumber + 1
			end
			local celElement,tCell = CellCommunityAppoint:createElement()
			if celElement ~= nil and tCell ~= nil then 
				celElement = WZUIContainer:luaTo(celElement)
				tCell:setData(self.m_tDataList[i], self.m_nWinType)
				freeListContainer:pushBack(celElement)
				freeListContainer:getMoveElement():setPositionY(freeListContainer:getMinPosition().y)
			end 
		end
		self.m_nCurrentCellIndex = self.m_nCurrentCellIndex + 1
	end
	self:scheduleCreateCell()
	local total
	key = {"fhz","zl","jy"}
	if self.m_nWinType == 0 then 
		for k,v in pairs(GDatatab_guild_level) do
			if v.level == CacheCenter:getGuildInfo().guildLevel then
				total = v[key[self.m_nTag]]
			end
		end
	elseif self.m_nWinType == 1 then 
		for k,v in pairs(GDatatab_league_level) do
			if v.level == CacheCenter:getUnionInfo().guildLevel then
				total = v[key[self.m_nTag]]
			end
		end
	end
	
	local ttf1 = GetElement(self.m_root,"ttf1",WZUILabelTTF)
	ttf1:setText(string.format(strFormat, tPosition[self.m_nTag]))
	local ttf2 = GetElement(self.m_root,"ttf2",WZUILabelTTF)
	ttf2:setText(self.m_nNumber.."/"..total)
	--self.m_nNumber = number
	self.m_nTotal = total
end

--@brief 	展示排序列表
function WndCommunityAppoint:_showSortTypeList()
	-- body
	local sortTypeList = {LocalStrings.BATTLE, LocalStrings.COMMUNITY_SORT1, LocalStrings.COMMUNITY_SORT2}
	local txtSortSel = GetElement(self.m_root, "txtSortSel_WndCommunityAppoint", WZUILabelTTF)
	if txtSortSel then 
		txtSortSel:setText(sortTypeList[self.m_nSortTypeSel])
	end
	for i = 1, 3 do
		if self.m_nSortTypeSel == i then 
			GetElement(self.m_root, "img9SortSel" .. i .. "_WndCommunityAppoint", WZUI9Image):setVisible(true)
		else
			GetElement(self.m_root, "img9SortSel" .. i .. "_WndCommunityAppoint", WZUI9Image):setVisible(false)
		end
	end
end

--@brief 	切换排序方式
function WndCommunityAppoint:_switchSortType()
	-- body
	self.m_bIsShowSortList = not self.m_bIsShowSortList
	GetElement(self.m_root, "conOther_WndCommunityAppoint", WZUIContainer):setVisible(self.m_bIsShowSortList)
	GetElement(self.m_root, "imgArrow_WndCommunityAppoint", WZUIImage):setFlipY(self.m_bIsShowSortList)

end

--@brief 	检测触摸是否在某个区域
function WndCommunityAppoint:checkPointInBtn(pt)
	WZLog("WndCommunityAppoint:checkPointInBtn")
	if self.m_root == nil then return end
	local btn = GetElement(self.m_root, "conOther_WndCommunityAppoint", WZUIContainer)
	if btn == nil then return false end
	local btnSize = btn:getContentSize()
	--获得btn的世界坐标
	local ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
	WZLog("获得btn 世界坐标",ptA.x,ptA.y, ptA.x + btnSize.width, ptA.y + btnSize.height, pt.x, pt.y)
	WZLog("按钮大小",btnSize.width,btnSize.height)
	if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
		WZLog("WndCommunityAppoint:checkPoint  true")
		return true
	end 

	btn = GetElement(self.m_root, "conSort_WndCommunityAppoint", WZUIContainer)
	if btn == nil then return false end
	local btnSize = btn:getContentSize()
	--获得btn的世界坐标
	local ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
	if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
		return true
	else
		return false 
	end 
end

--@brief 	设置静态文本
function WndCommunityAppoint:_setStaticText()
	local txtTab1 = GetElement(self.m_root, "txtTab1", WZUILabelTTF)
	local txtTab1Sel = GetElement(self.m_root, "txtTab1Sel", WZUILabelTTF)
	if self.m_nWinType == 0 then 
		txtTab1:setText(LocalStrings.VICE_PRESIDENT)
		txtTab1Sel:setText(LocalStrings.VICE_PRESIDENT)
	elseif self.m_nWinType == 1 then 
		txtTab1:setText(LocalStrings.UNION_TEXT1[13])
		txtTab1Sel:setText(LocalStrings.UNION_TEXT1[13])
	end
end

--@brief    越南语适配
function WndCommunityAppoint:_adaptLanguage_en()
    WZLog("WndCommunityAppoint:_adaptLanguage_en")
	local txtTab1 = GetElement(self.m_root,"txtTab1",WZUILabelTTF)
    txtTab1:setScale(0.7)
    txtTab1:setDimensions(GlobalMethod:CCSize(170,0))

    local txtTab1Sel = GetElement(self.m_root,"txtTab1Sel",WZUILabelTTF)
    txtTab1Sel:setScale(0.7)
    txtTab1Sel:setDimensions(GlobalMethod:CCSize(170,0))
end

function WndCommunityAppoint:_adaptLanguage_th(  )
	GetElement(self.m_root,"ttf2",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.55,0.085))
end

function WndCommunityAppoint:_adaptLanguage_vn(  )
	local ttf = GetElement(self.m_root,"ttf3_WndCommunityAppoint",WZUILabelTTF)
	ttf:setDimensions(GlobalMethod:CCSize(130,0))
	ttf:setScale(0.68)
	local ttf1 = GetElement(self.m_root,"ttf1",WZUILabelTTF)
	ttf1:setFontSize(18)
	local ttf2 = GetElement(self.m_root,"ttf2",WZUILabelTTF)
	ttf2:setFontSize(18)
	GetElement(self.m_root,"txtTab1",WZUILabelTTF):setScale(0.75)
	GetElement(self.m_root,"txtTab1Sel",WZUILabelTTF):setScale(0.75)
	GetElement(self.m_root, "txtSortSel_WndCommunityAppoint", WZUILabelTTF):setFontSize(16)
end

function WndCommunityAppoint:_adaptLanguage_pt(  )
	local txtTab1 = GetElement(self.m_root,"txtTab1",WZUILabelTTF)
	txtTab1:setDimensions(GlobalMethod:CCSize(180,0))
	txtTab1:setScale(0.6)
	local txtTab1Sel = GetElement(self.m_root,"txtTab1Sel",WZUILabelTTF)
	txtTab1Sel:setDimensions(GlobalMethod:CCSize(150,0))
	txtTab1Sel:setFontSize(20)
end

function WndCommunityAppoint:_adaptLanguage_tr(  )
	local txtTab1 = GetElement(self.m_root,"txtTab1",WZUILabelTTF)
	txtTab1:setDimensions(GlobalMethod:CCSize(180,0))
	txtTab1:setScale(0.6)
	local txtTab1Sel = GetElement(self.m_root,"txtTab1Sel",WZUILabelTTF)
	txtTab1Sel:setDimensions(GlobalMethod:CCSize(150,0))
	txtTab1Sel:setFontSize(20)
end

function WndCommunityAppoint:_adaptLanguage_es(  )
	local txtTab1 = GetElement(self.m_root,"txtTab1",WZUILabelTTF)
	txtTab1:setScale(0.7)
	txtTab1:setDimensions(GlobalMethod:CCSize(110,0))

	local txtTab1Sel = GetElement(self.m_root,"txtTab1Sel",WZUILabelTTF)
	txtTab1Sel:setScale(0.7)
	txtTab1Sel:setDimensions(GlobalMethod:CCSize(110,0))

	local ttf1 = GetElement(self.m_root,"ttf1",WZUILabelTTF)
	ttf1:setFontSize(14)

	local ttf2 = GetElement(self.m_root,"ttf2",WZUILabelTTF)
	ttf2:setFontSize(18)
end

function WndCommunityAppoint:_adaptLanguage_ug(  )
	local txtTab1 = GetElement(self.m_root,"txtTab1",WZUILabelTTF)
	txtTab1:setScale(0.5)
	txtTab1:setDimensions(GlobalMethod:CCSize(220,0))
	local txtTab1Sel = GetElement(self.m_root,"txtTab1Sel",WZUILabelTTF)
	txtTab1Sel:setScale(0.5)
	txtTab1Sel:setDimensions(GlobalMethod:CCSize(110,0))
	local txtTab2 = GetElement(self.m_root,"txtTab2",WZUILabelTTF)
	txtTab2:setScale(0.5)
	txtTab2:setDimensions(GlobalMethod:CCSize(220,0))
	local txtTab2Sel = GetElement(self.m_root,"txtTab2Sel",WZUILabelTTF)
	txtTab2Sel:setScale(0.5)
	txtTab2Sel:setDimensions(GlobalMethod:CCSize(110,0))
	local txtTab3 = GetElement(self.m_root,"txtTab3",WZUILabelTTF)
	txtTab3:setScale(0.5)
	txtTab3:setDimensions(GlobalMethod:CCSize(220,0))
	local txtTab3Sel = GetElement(self.m_root,"txtTab3Sel",WZUILabelTTF)
	txtTab3Sel:setScale(0.5)
	txtTab3Sel:setDimensions(GlobalMethod:CCSize(110,0))

	local ttf1 = GetElement(self.m_root,"ttf1",WZUILabelTTF)
	ttf1:setRelativePosition(GlobalMethod:ccp(0.42,0.085))
	ttf1:setDimensions(GlobalMethod:CCSize(440))
	local ttf2 = GetElement(self.m_root,"ttf2",WZUILabelTTF)
	ttf2:setRelativePosition(GlobalMethod:ccp(0.12,0.085))
	ttf2:setAnchorPoint(GlobalMethod:ccp(1,0.5))

	local ttf3 = GetElement(self.m_root,"ttf3_WndCommunityAppoint",WZUILabelTTF)
	ttf3:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
	ttf3:setDimensions(GlobalMethod:CCSize(240,0))
	ttf3:setScale(0.5)
end
-------------------------------------私有方法模块End----------------------------------------
