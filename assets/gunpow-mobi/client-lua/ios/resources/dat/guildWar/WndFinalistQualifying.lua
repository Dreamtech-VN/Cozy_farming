--WndFinalistQualifying.lua
--@brief	WndFinalistQualifying的UI模块
--@date		2017/02/25
--@author	qixiang
--@note		出线赛与入围赛的排名


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFinalistQualifying:onEnter(element)
	WZLog("WndFinalistQualifying:onEnter")
	self.m_root = element
	AdaptLanguage(self)
	self:updateUI()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFinalistQualifying:onExit(element)
	self:_unInit()
end

function WndFinalistQualifying:onClose()
	-- body
	WZLog("WndFinalistQualifying:onClose")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	
    WindowManager:removeWindow(self.m_root, self, true)
end

function WndFinalistQualifying:updateUI()
	-- body
	WZLog("WndFinalistQualifying:updateUI")
	local txtT = GetElement(self.m_root,"txtT_WndFinalistQualifying",WZUILabelTTF)
	local txtCheckbox1Nor = GetElement(self.m_root,"txtCheckbox1Nor_WndFinalistQualifying",WZUILabelTTF)
	local txtCheckbox1Sel = GetElement(self.m_root,"txtCheckbox1Sel_WndFinalistQualifying",WZUILabelTTF)

	local txtCheckbox2Nor = GetElement(self.m_root,"txtCheckbox2Nor_WndFinalistQualifying",WZUILabelTTF)
	local txtCheckbox2Sel = GetElement(self.m_root,"txtCheckbox2Sel_WndFinalistQualifying",WZUILabelTTF)
	local txtTitle = GetElement(self.m_root,"txtTitle_WndFinalistQualifying",WZUILabelTTF)
	txtCheckbox2Nor:setText(LocalStrings.COMMUNITYWAR_TEXT34)
	txtCheckbox2Sel:setText(LocalStrings.COMMUNITYWAR_TEXT34)

	if ProjConfig.LANGUAGE == "en" then
		txtCheckbox1Nor:setDimensions(GlobalMethod:CCSize(100,0))
		txtCheckbox1Nor:setScale(0.88)
		txtCheckbox1Sel:setDimensions(GlobalMethod:CCSize(100,0))
		txtCheckbox1Sel:setScale(0.88)
		txtCheckbox2Nor:setDimensions(GlobalMethod:CCSize(100,0))
		txtCheckbox2Nor:setScale(0.88)
		txtCheckbox2Sel:setDimensions(GlobalMethod:CCSize(100,0))
		txtCheckbox2Sel:setScale(0.88)
	end

	if self.m_type == 1 then --出线赛(本服)
		txtT:setTextKey("COMMUNITYWAR_TEXT4")
		txtCheckbox1Nor:setText(LocalStrings.COMMUNITYWAR_TEXT33)
		txtCheckbox1Sel:setText(LocalStrings.COMMUNITYWAR_TEXT33)
		txtTitle:setTextKey("COMMUNITYWAR_TEXT6")
		ProtocolProcessorCommunityWar:send_GUILDWAR_GuildWarRank(1)
	elseif self.m_type == 2 then --入围赛(全服)
		txtCheckbox1Nor:setText(LocalStrings.TASK_TEXT7)
		txtCheckbox1Sel:setText(LocalStrings.TASK_TEXT7)
		txtT:setTextKey("COMMUNITYWAR_TEXT31")
		txtTitle:setTextKey("COMMUNITYWAR_TEXT7")
		if ProjConfig.LANGUAGE == "vn" then
			txtCheckbox1Nor:setDimensions(GlobalMethod:CCSize(100,0))
			txtCheckbox1Nor:setScale(0.88)
			txtCheckbox1Sel:setDimensions(GlobalMethod:CCSize(100,0))
			txtCheckbox1Sel:setScale(0.88)
		end
		ProtocolProcessorCommunityWar:send_GUILDWAR_GuildWarRank(2)
	end
end

--设置出线赛的本服排名
function WndFinalistQualifying:show1()
	-- body
	WZLog("WndFinalistQualifying:show1")
	local conTable = GetElement(self.m_root,"conTable_WndFinalistQualifying",WZUIContainer)

	local tabList = GetElement(conTable,"tabList_WndFinalistQualifying",WZUITableContainer)
	tabList:cleanTable()
	if self.m_type == 1 and self.m_nCurType == 1 then  
		if self.m_tRankInfo1 == nil or #self.m_tRankInfo1 <= 0 then
			ShowPanelNullTip(conTable)
		else
			removeShowPanelNullTip(conTable)
			for i,v in ipairs(self.m_tRankInfo1) do
				local element , luaObject = CellGVGRankList:createElement()
				luaObject:setFinalistComData(i,v.name,v.nameorsid,v.sorce,v.fightNum,v.winNum,v.gid)
				element:setTag(i-1)
				tabList:setCellElement(element)
			end
		end
	end
end

--设置出线赛的成员排名
function WndFinalistQualifying:show2()
	-- body
	WZLog("WndFinalistQualifying:show2")
	local conTable = GetElement(self.m_root,"conTable_WndFinalistQualifying",WZUIContainer)
	local tabList = GetElement(conTable,"tabList_WndFinalistQualifying",WZUITableContainer)
	tabList:cleanTable()
	if self.m_type == 1 and self.m_nCurType == 2 then  
		if self.m_tRankInfo2 == nil or #self.m_tRankInfo2 <= 0 then
			ShowPanelNullTip(conTable)
		else
			removeShowPanelNullTip(conTable)
			for i,v in ipairs(self.m_tRankInfo2) do
				local element , luaObject = CellGVGRankList:createElement()
				luaObject:setQualifyingData(i,v.pid,v.name,v.level,v.sorce,v.fightNum,v.winNum)
				element:setTag(i-1)
				tabList:setCellElement(element)
			end
		end
	end
end


--设置入围赛的全服排名
function WndFinalistQualifying:show3()
	-- body
	WZLog("WndFinalistQualifying:show3")
	local conTable = GetElement(self.m_root,"conTable_WndFinalistQualifying",WZUIContainer)
	local tabList = GetElement(conTable,"tabList_WndFinalistQualifying",WZUITableContainer)
	tabList:cleanTable()
	if self.m_type == 2 and self.m_nCurType == 1 then  
		if self.m_tRankInfo3 == nil or #self.m_tRankInfo3 <= 0 then
			ShowPanelNullTip(conTable)
		else
			removeShowPanelNullTip(conTable)
			for i,v in ipairs(self.m_tRankInfo3) do
				local element , luaObject = CellGVGRankList:createElement()
				local serviceName = CacheCenter:getServerNameByServerId(v.nameorsid)
				luaObject:setFinalistComData(i,v.name,serviceName,v.sorce,v.fightNum,v.winNum,v.gid)
				element:setTag(i-1)
				tabList:setCellElement(element)
			end
		end
	end
end

--设置入围赛的成员排名
function WndFinalistQualifying:show4()
	-- body
	WZLog("WndFinalistQualifying:show4")
	local conTable = GetElement(self.m_root,"conTable_WndFinalistQualifying",WZUIContainer)
	local tabList = GetElement(conTable,"tabList_WndFinalistQualifying",WZUITableContainer)
	tabList:cleanTable()
	if self.m_type == 2 and self.m_nCurType == 2 then  
		if self.m_tRankInfo4 == nil or #self.m_tRankInfo4 <= 0 then
			ShowPanelNullTip(conTable)
		else
			removeShowPanelNullTip(conTable)
			for i,v in ipairs(self.m_tRankInfo4) do
				local element , luaObject = CellGVGRankList:createElement()
				luaObject:setQualifyingData(i,v.pid,v.name,v.level,v.sorce,v.fightNum,v.winNum)
				element:setTag(i-1)
				tabList:setCellElement(element)
			end
		end
	end
end



--本服(全服)
function WndFinalistQualifying:onCheck1(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	local txtT = GetElement(self.m_root,"txtT_WndFinalistQualifying",WZUILabelTTF)
	if self.m_type == 1 then --出线赛 (本服)
		txtT:setTextKey("COMMUNITYWAR_TEXT4")
		if self.m_nCurType == 1 then return end
		self.m_nCurType = 1
		if self.m_tRankInfo1 == nil or  #self.m_tRankInfo1 <= 0 then
			ProtocolProcessorCommunityWar:send_GUILDWAR_GuildWarRank(1)
		else
			self:show1()
		end
	elseif self.m_type == 2 then --入围赛 (全服服)
		txtT:setTextKey("COMMUNITYWAR_TEXT31")
		if self.m_nCurType == 1 then return end
		self.m_nCurType = 1
		if self.m_tRankInfo3 == nil or #self.m_tRankInfo3 <= 0 then
			ProtocolProcessorCommunityWar:send_GUILDWAR_GuildWarRank(2)
		else
			self:show3()
		end
	end
end

--成员
function WndFinalistQualifying:onCheck2(element)
	-- body
	WZLog("WndFinalistQualifying:onCheck2")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	local txtT = GetElement(self.m_root,"txtT_WndFinalistQualifying",WZUILabelTTF)
	txtT:setTextKey("COMMUNITYWAR_TEXT32")
	if self.m_type == 1 then --出线赛 (成员)
		if self.m_nCurType == 2 then return end
		self.m_nCurType = 2
		if self.m_tRankInfo2 == nil or #self.m_tRankInfo2 <= 0 then
			ProtocolProcessorCommunityWar:send_GUILDWAR_GuildWarOut(1)
		else
			self:show2()
		end
	elseif self.m_type == 2 then --入围赛 (成员)
		if self.m_nCurType == 2 then return end
		self.m_nCurType = 2
		if self.m_tRankInfo4 == nil or #self.m_tRankInfo4 <= 0 then
			ProtocolProcessorCommunityWar:send_GUILDWAR_GuildWarOut(2)
		else
			self:show4()
		end
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


-------------------------------------私有方法模块End----------------------------------------

--------------------------------------语言适配Begin-----------------------------------------
function WndFinalistQualifying:_adaptLanguage_en(  )
	local txtCheckNor = GetElement(self.m_root,"txtCheckbox1Nor_WndFinalistQualifying",WZUILabelTTF)
	txtCheckNor:setDimensions(GlobalMethod:CCSize(100,0))
	txtCheckNor:setScale(0.86)

	local txtCheckSel = GetElement(self.m_root,"txtCheckbox1Sel_WndFinalistQualifying",WZUILabelTTF)
	txtCheckSel:setDimensions(GlobalMethod:CCSize(100,0))
	txtCheckSel:setScale(0.86)

	local txtCheckNor = GetElement(self.m_root,"txtCheckbox2Nor_WndFinalistQualifying",WZUILabelTTF)
	txtCheckNor:setDimensions(GlobalMethod:CCSize(100,0))
	txtCheckNor:setScale(0.86)

	local txtCheckSel = GetElement(self.m_root,"txtCheckbox2Sel_WndFinalistQualifying",WZUILabelTTF)
	txtCheckSel:setDimensions(GlobalMethod:CCSize(100,0))
	txtCheckSel:setScale(0.86)
end

function WndFinalistQualifying:_adaptLanguage_tr(  )
	local txtCheckNor = GetElement(self.m_root,"txtCheckbox1Nor_WndFinalistQualifying",WZUILabelTTF)
	txtCheckNor:setDimensions(GlobalMethod:CCSize(140,0))
	txtCheckNor:setScale(0.6)

	local txtCheckSel = GetElement(self.m_root,"txtCheckbox1Sel_WndFinalistQualifying",WZUILabelTTF)
	txtCheckSel:setDimensions(GlobalMethod:CCSize(140,0))
	txtCheckSel:setScale(0.6)

	local txtCheckNor = GetElement(self.m_root,"txtCheckbox2Nor_WndFinalistQualifying",WZUILabelTTF)
	txtCheckNor:setDimensions(GlobalMethod:CCSize(140,0))
	txtCheckNor:setScale(0.6)

	local txtCheckSel = GetElement(self.m_root,"txtCheckbox2Sel_WndFinalistQualifying",WZUILabelTTF)
	txtCheckSel:setDimensions(GlobalMethod:CCSize(140,0))
	txtCheckSel:setScale(0.6)
end


function WndFinalistQualifying:_adaptLanguage_th(  )
	for i=1,2 do
		local txtNor = GetElement(self.m_root,"txtCheckbox"..i.."Nor_WndFinalistQualifying",WZUILabelTTF)
		txtNor:setScale(0.8)
		local txtSel = GetElement(self.m_root,"txtCheckbox"..i.."Sel_WndFinalistQualifying",WZUILabelTTF)
		txtSel:setScale(0.8)
	end
end

function WndFinalistQualifying:_adaptLanguage_vn(  )
	local txtCheckNor = GetElement(self.m_root,"txtCheckbox2Nor_WndFinalistQualifying",WZUILabelTTF)
	txtCheckNor:setDimensions(GlobalMethod:CCSize(100,0))
	txtCheckNor:setScale(0.86)

	local txtCheckSel = GetElement(self.m_root,"txtCheckbox2Sel_WndFinalistQualifying",WZUILabelTTF)
	txtCheckSel:setDimensions(GlobalMethod:CCSize(100,0))
	txtCheckSel:setScale(0.86)
end

function WndFinalistQualifying:_adaptLanguage_es(  )
	for i=1,2 do
		local txtNor = GetElement(self.m_root,"txtCheckbox"..i.."Nor_WndFinalistQualifying",WZUILabelTTF)
		txtNor:setScale(0.8)
		txtNor:setDimensions(GlobalMethod:CCSize(100,0))

		local txtSel = GetElement(self.m_root,"txtCheckbox"..i.."Sel_WndFinalistQualifying",WZUILabelTTF)
		txtSel:setScale(0.8)
		txtSel:setDimensions(GlobalMethod:CCSize(100,0))
	end
end

function WndFinalistQualifying:_adaptLanguage_pt(  )
	for i=1,2 do
		local txtNor = GetElement(self.m_root,"txtCheckbox"..i.."Nor_WndFinalistQualifying",WZUILabelTTF)
		txtNor:setScale(0.8)
		txtNor:setDimensions(GlobalMethod:CCSize(100,0))

		local txtSel = GetElement(self.m_root,"txtCheckbox"..i.."Sel_WndFinalistQualifying",WZUILabelTTF)
		txtSel:setScale(0.8)
		txtSel:setDimensions(GlobalMethod:CCSize(100,0))
	end
end
--------------------------------------语言适配End-------------------------------------------