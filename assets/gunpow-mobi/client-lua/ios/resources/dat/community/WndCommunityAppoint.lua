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
	if position == COMMUNITY_PRESIDENT then
		self.m_nTag = 1
		GetElement(self.m_root,"checkInfo0",WZUICheckBox):setCheckIndex(1)
		GetElement(self.m_root,"checkInfo1",WZUICheckBox):setCheckIndex(0)
		GetElement(self.m_root,"checkInfo2",WZUICheckBox):setCheckIndex(0)
	elseif position == COMMUNITY_VICE_PRESIDENT then
		self.m_nTag = 2
		GetElement(self.m_root,"checkInfo0",WZUICheckBox):setCheckIndex(1)
		GetElement(self.m_root,"checkInfo0",WZUICheckBox):setTouchEnable(false)
		GetElement(self.m_root,"imgTab1",WZUI9Image):setGrayRender(true)
		GetElement(self.m_root,"imgTab11",WZUI9Image):setGrayRender(true)
		GetElement(self.m_root,"checkInfo1",WZUICheckBox):setCheckIndex(1)
		GetElement(self.m_root,"checkInfo2",WZUICheckBox):setCheckIndex(0)
	elseif position == COMMUNITY_ELDER then
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

	self:refresh()
	AdaptLanguage(self)
end

--@brief	成员按职位排序
function _sortAppoint(a,b)
	--职位
	if a.position ~= b.position then
		return a.position > b.position
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
	self.m_tDataList = CopyTable(SceneMemberList.m_tMemberList)
	table.sort(self.m_tDataList , _sortAppoint)
	self:update()
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
	WZLog("WndCommunityAppoint:onSure")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_bLoding == true then
		MsgBoxManager:showTipBox(LocalStrings.RESOURCES_LOADING)
		return
	end
    local ids = WZLuaVector_int_:create()
	if self.m_tChangeList ~= nil then
		for i=1,#self.m_tChangeList do
			ids:push(self.m_tChangeList[i])
		end
	end
	--if #self.m_tChangeList == 0 then return end
	ProtocolProcessorSceneCommunity:send_GUILD_ChangeMemberPost(ids, (4 - self.m_nTag))
end

function WndCommunityAppoint:onTouchEnd()
	self:_updateCheckboxGroupIndex()
end

--@brief 	更新CheckboxGroup选中标签
function WndCommunityAppoint:_updateCheckboxGroupIndex()
	local position = tonumber(CacheCenter:getPlayerInfo().position)
	if position == COMMUNITY_VICE_PRESIDENT then
		GetElement(self.m_root,"checkInfo0",WZUICheckBox):setCheckIndex(1)
	elseif position == COMMUNITY_ELDER then
		GetElement(self.m_root,"checkInfo0",WZUICheckBox):setCheckIndex(1)
		GetElement(self.m_root,"checkInfo1",WZUICheckBox):setCheckIndex(1)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndCommunityAppoint:update()
	WZLog("WndCommunityAppoint:update", self.m_nTag)
	if self.m_root == nil then return end 
	self.m_root:disableSchedule()
	self.m_bLoding = true
	local freeListContainer = GetElement(self.m_root,"freeconText_Wnd",WZUIFreeListContainer)
	freeListContainer:removeAll()

	--没有数据时显示提示
	if self.m_tDataList == nil or #self.m_tDataList == 0 then 
		ShowPanelNullTip(freeListContainer,nil,GlobalMethod:ccc3(255,236,193))
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
	if self.m_nCurrentCellIndex > #self.m_tDataList then
		self.m_root:disableSchedule()
		self.m_bLoding = false

		key = {"fhz","zl","jy"}
		for k,v in pairs(GDatatab_guild_level) do
			if v.level == CacheCenter:getGuildInfo().guildLevel then
				self.m_nTotal = v[key[self.m_nTag]]
			end
		end
		tPosition = {LocalStrings.VICE_PRESIDENT,LocalStrings.ELDERS,LocalStrings.PICK}
		GetElement(self.m_root,"ttf1",WZUILabelTTF):setText(string.format(LocalStrings.COMMUNITYINFO131,tPosition[self.m_nTag]))
		GetElement(self.m_root,"ttf2",WZUILabelTTF):setText(self.m_nNumber.."/"..self.m_nTotal)
		return
	end

	local freeListContainer = GetElement(self.m_root,"freeconText_Wnd",WZUIFreeListContainer)
	local max = math.min(self.m_nCurrentCellIndex+10, #self.m_tDataList)
	local position = tonumber(CacheCenter:getPlayerInfo().position)
	for i=self.m_nCurrentCellIndex,max do
		if tonumber(self.m_tDataList[i].position) < position then
			if tonumber(self.m_tDataList[i].position) == (4 - self.m_nTag) then
				self.m_nNumber = self.m_nNumber + 1
			end
			local celElement,tCell = CellCommunityAppoint:createElement()
			if celElement ~= nil and tCell ~= nil then 
				celElement = WZUIContainer:luaTo(celElement)
				tCell:setData(self.m_tDataList[i])
				freeListContainer:pushBack(celElement)
				freeListContainer:getMoveElement():setPositionY(freeListContainer:getMinPosition().y)
			end 
		end
		self.m_nCurrentCellIndex = self.m_nCurrentCellIndex + 1
	end
	self:scheduleCreateCell()
	local total
	key = {"fhz","zl","jy"}
	for k,v in pairs(GDatatab_guild_level) do
		if v.level == CacheCenter:getGuildInfo().guildLevel then
			total = v[key[self.m_nTag]]
		end
	end
	tPosition = {LocalStrings.VICE_PRESIDENT,LocalStrings.ELDERS,LocalStrings.PICK}
	local ttf1 = GetElement(self.m_root,"ttf1",WZUILabelTTF)
	ttf1:setText(string.format(LocalStrings.COMMUNITYINFO131,tPosition[self.m_nTag]))
	local ttf2 = GetElement(self.m_root,"ttf2",WZUILabelTTF)
	ttf2:setText(self.m_nNumber.."/"..total)
	--self.m_nNumber = number
	self.m_nTotal = total
	if ProjConfig.LANGUAGE == "pt" then
		if self.m_nTag == 1 then
			ttf1:setRelativePosition(GlobalMethod:ccp(0.3,0.085))
			ttf2:setRelativePosition(GlobalMethod:ccp(0.6,0.085))
		elseif self.m_nTag == 2 or self.m_nTag == 3 then
			ttf1:setRelativePosition(GlobalMethod:ccp(0.2,0.085))
			ttf2:setRelativePosition(GlobalMethod:ccp(0.38,0.085))
		end
	elseif ProjConfig.LANGUAGE == "en" then
		if self.m_nTag == 1 then
			ttf1:setRelativePosition(GlobalMethod:ccp(0.3,0.085))
			ttf2:setRelativePosition(GlobalMethod:ccp(0.6,0.085))
		elseif self.m_nTag == 2 or self.m_nTag == 3 then
			ttf2:setRelativePosition(GlobalMethod:ccp(0.52,0.085))
		end
	elseif ProjConfig.LANGUAGE == "tr" then
		if self.m_nTag == 1 then
			ttf1:setRelativePosition(GlobalMethod:ccp(0.3,0.085))
			ttf2:setRelativePosition(GlobalMethod:ccp(0.6,0.085))
		else
			ttf1:setRelativePosition(GlobalMethod:ccp(0.25,0.085))
			ttf2:setRelativePosition(GlobalMethod:ccp(0.47,0.085))
		end
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
	ttf1:setRelativePosition(GlobalMethod:ccp(0.3,0.085))
	ttf1:setFontSize(18)
	local ttf2 = GetElement(self.m_root,"ttf2",WZUILabelTTF)
	ttf2:setRelativePosition(GlobalMethod:ccp(0.6,0.085))
	ttf2:setFontSize(18)
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
	ttf1:setRelativePosition(GlobalMethod:ccp(0.35,0.085))
	ttf1:setFontSize(14)

	local ttf2 = GetElement(self.m_root,"ttf2",WZUILabelTTF)
	ttf2:setRelativePosition(GlobalMethod:ccp(0.66,0.085))
	ttf2:setFontSize(18)
end
-------------------------------------私有方法模块End----------------------------------------
