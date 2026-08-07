--WndHouseInvite.lua
--@brief	WndHouseInvite的UI模块
--@date		2021/09/27
--@author	hyx
--@note		房产主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndHouseInvite:onEnter(element)
	self.m_root = element
	if self.m_nWinType == 13 then
		GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData2,self)
		GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetRankResult,self._onRankResult,self)
		GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetTaskList,self._onGetTaskInfo2,self)
		GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetResult,self._onGetTaskResult2,self)
	elseif self.m_nWinType == 14 or self.m_nWinType == 15 or self.m_nWinType == 16 or self.m_nWinType == 19 then
		GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData2,self)
	elseif self.m_nWinType == 18 then
		GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetRankResult,self._onRankResult,self)
		GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetTaskList,self._onGetTaskInfo2,self)
		GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetResult,self._onGetTaskResult2,self)
	end

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndHouseInvite:onExit(element)
	if self.m_nWinType == 2 or self.m_nWinType == 4 or self.m_nWinType == 8 or self.m_nWinType == 10 or self.m_nWinType == 11 or self.m_nWinType == 15 or self.m_nWinType == 16 or self.m_nWinType == 19 then 
		CacheCenter:unregisterUpatePlayerItemObserver(self)--反注册物品
		if self.m_nWinType == 10 and self.m_root then 
			self.m_root:disableSchedule()
		end
	end
	if self.m_nWinType == 13 then
		GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData2,self)
		GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetRankResult,self._onRankResult,self)
		GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetTaskList,self._onGetTaskInfo2,self)
		GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetResult,self._onGetTaskResult2,self)
	elseif self.m_nWinType == 14 or self.m_nWinType == 15 or self.m_nWinType == 16 or self.m_nWinType == 19 then
		GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData2,self)
	elseif self.m_nWinType == 18 then
		GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetRankResult,self._onRankResult,self)
		GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetTaskList,self._onGetTaskInfo2,self)
		GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetResult,self._onGetTaskResult2,self)
	end
	self:_unInit()
end

function WndHouseInvite:onEnterTransitionDidFinish(element)
	self:actionCallback()
end
function WndHouseInvite:actionCallback()
	self:setInviteNoticeRedPoint()
	local str_title = {LocalStrings.ACTIVITY_TEXT182, LocalStrings.ACTIVITY_TEXT186, LocalStrings.SHOOTARROW_TEXT21} 
	if self.m_nWinType == 2 then 
		CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
		self:_initStaticText()
		self:updateLeftNum()
		str_title = {LocalStrings.DECORATIONS_TEXT1[7], LocalStrings.DECORATIONS_TEXT1[5], LocalStrings.DECORATIONS_TEXT1[6]}
	elseif self.m_nWinType == 3 then 
		GetElement(self.m_root, "img9BigBg_WndHouseInvite", WZUI9Image):setFile("ui/common_bg/hd_pic_xnyy_xyq.png")
		for i = 1, 3 do
			GetElement(self.m_root,"btn"..i,WZUIButton):setVisible(false)
		end
	elseif self.m_nWinType == 4 or self.m_nWinType == 8 or self.m_nWinType == 10 then 
		CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
		for i = 1, 3 do
			GetElement(self.m_root,"btn"..i,WZUIButton):setVisible(false)
		end
		if self.m_nWinType == 8 then 
			self:_initStaticText()
		elseif self.m_nWinType == 10 then 
			self.m_root:enableSchedule("_caculateTime", 1)
			GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetTaskList,self._onGetTaskInfo,self)
			GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetResult,self._onGetTaskResult,self)
			self:getTaskData()
			GetElement(self.m_root, "cellCampFire_WndHouseInvite", WZUIContainer):setVisible(true)
			self:_initStaticText()
			self:_setBallAni()
		end
	elseif self.m_nWinType == 6 then 
		GetElement(self.m_root, "img9BigBg_WndHouseInvite", WZUI9Image):setFile("ui/common/frame_tc_xiao_zi.png")
		GetElement(self.m_root, "imgClose_WndHouseInvite", WZUIImage):setFile("ui/common/common_top_btn_guanbi_zi.png")
		str_title = {LocalStrings.DOUBLE_SEVEN_TEXT19, LocalStrings.MASTERINFO24, LocalStrings.MASTERINFO24} 
		GetElement(self.m_root,"btn3",WZUIButton):setVisible(false)
		for i=1,3 do
			local btn = GetElement(self.m_root,"btn"..i,WZUIButton)
			GetElement(btn,"normal",WZUIImage):setFile("ui/activity/common_btn_40.png")
			GetElement(btn,"select",WZUIImage):setFile("ui/activity/common_btn_39.png")
		end
	elseif self.m_nWinType == 7 or self.m_nWinType == 9 then 
		str_title = {LocalStrings.ACTIVITY_TEXT182, LocalStrings.SHOOTARROW_TEXT22, LocalStrings.SHOOTARROW_TEXT21} 
	elseif self.m_nWinType == 11 then
		GetElement(self.m_root, "cellCatchFish_WndHouseInvite", WZUIContainer):setVisible(true)
		CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
		GetElement(self.m_root, "img9BigBg_WndHouseInvite", WZUI9Image):setFile("ui/common/frame_tc_xiao_lan.png") 
		GetElement(self.m_root, "imgClose_WndHouseInvite", WZUIImage):setFile("ui/newvip/common_top_btn_guanbi_lan.png")
		str_title = {LocalStrings.CATCHFISH_TEXT1[20], LocalStrings.CATCHFISH_TEXT1[21], LocalStrings.SHOOTARROW_TEXT21} 
		for i = 1, 3 do
			local btn = GetElement(self.m_root,"btn"..i,WZUIButton)
			GetElement(btn,"normal",WZUIImage):setFile("ui/common/common_btn_69.png")
			GetElement(btn,"select",WZUIImage):setFile("ui/common/common_btn_68.png")
			if i > 2 then 
				btn:setVisible(false)
			end
		end
	elseif self.m_nWinType == 12 or self.m_nWinType == 17 then
		GetElement(self.m_root, "cellCatchFish_WndHouseInvite", WZUIContainer):setVisible(true)
		CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
		for i = 1, 3 do
			local btn = GetElement(self.m_root,"btn"..i,WZUIButton)
			btn:setVisible(false)
		end
	elseif self.m_nWinType == 13 then
		self:_initStaticText()
		self:_showAfforestation()
		GetElement(self.m_root, "cellAfforestation1_WndHouseInvite", WZUIContainer):setVisible(true)
		str_title = {LocalStrings.AFFORESTATION_TEXT1[16], LocalStrings.AFFORESTATION_TEXT1[17], LocalStrings.AFFORESTATION_TEXT1[18]}
	elseif self.m_nWinType == 14 then
		for i = 1, 3 do
			GetElement(self.m_root,"btn"..i,WZUIButton):setVisible(false)
		end
		self:_initStaticText()
		self:_showPotionsRefining()
		GetElement(self.m_root, "cellPotions_WndHouseInvite", WZUIContainer):setVisible(true)
	elseif self.m_nWinType == 15 then
		CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
		for i = 1, 3 do
			GetElement(self.m_root,"btn"..i,WZUIButton):setVisible(false)
		end
		self:_initStaticText()
		self.m_nCoinId = 160610
		self:updatePaintingNum()
		GetElement(self.m_root, "cellHolyHand_WndHouseInvite", WZUIContainer):setVisible(true)
	elseif self.m_nWinType == 16 then
		CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
		GetElement(self.m_root,"btn3",WZUIButton):setVisible(false)
		self:_initStaticText()
		self.m_nCampTabIndex = 2
		self:updateDragonBallNum()
		self:_showDragonBall()
		GetElement(self.m_root, "cellDragonBall_WndHouseInvite", WZUIContainer):setVisible(true)
		str_title = {LocalStrings.DRAGON_BALL_TEXT1[15], LocalStrings.DRAGON_BALL_TEXT1[16]}

		self.m_tGetTimes2 = {}
		self.m_tBigRewardList2 = {}
		local tData = {pool = 2}
		local tData2 = {pool = 3}
		local strJson = json.encode(tData)
		local strJson2 = json.encode(tData2)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson2)
	elseif self.m_nWinType == 18 then
		GetElement(self.m_root, "img9BigBg_WndHouseInvite", WZUI9Image):setFile("ui/common/frame_tc_xiao_zi.png")
		GetElement(self.m_root, "imgClose_WndHouseInvite", WZUIImage):setFile("ui/common/common_top_btn_guanbi_zi.png")
		for i=1,3 do
			local btn = GetElement(self.m_root,"btn"..i,WZUIButton)
			GetElement(btn,"normal",WZUIImage):setFile("ui/activity/common_btn_40.png")
			GetElement(btn,"select",WZUIImage):setFile("ui/activity/common_btn_39.png")
		end
		GetElement(self.m_root,"titleBgImg_cellLeiZhuZhen1",WZUI9Image):setFile("ui/common/frame_12_1.png")

		GetElement(self.m_root,"btn3",WZUIButton):setVisible(false)
		self:_initStaticText()
		str_title = {LocalStrings.LEIZHUZHEN_TEXT1[20], LocalStrings.LEIZHUZHEN_TEXT1[21]}

		--尚未加入联盟提示
		if not checkInUnion() then
			MsgBoxManager:showTipBox(LocalStrings.AFFORESTATION_TEXT1[29])
		end
	elseif self.m_nWinType == 19 then
		GetElement(self.m_root, "cellAntiqueRestore_WndHouseInvite", WZUIContainer):setVisible(true)
		self:_initStaticText()
		CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
		str_title = {LocalStrings.PANJIAYUAN_TEXT1[14], LocalStrings.PANJIAYUAN_TEXT1[15], ""} 
		for i = 1, 3 do
			local btn = GetElement(self.m_root,"btn"..i,WZUIButton)
			if i > 2 then 
				btn:setVisible(false)
			end
		end
		--获取奖池
		self.m_tGetTimes2 = {}
		self.m_tBigRewardList2 = {}
		self.m_tPieceState = self.m_tOtherData.pieceState
		local tData = {pool = 2}
		local tData2 = {pool = 3}
		local strJson = json.encode(tData)
		local strJson2 = json.encode(tData2)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson2)
	elseif self.m_nWinType == 20 then 
		str_title = {LocalStrings.KINGOFMINING_TEXT1[29], LocalStrings.KINGOFMINING_TEXT1[30], LocalStrings.KINGOFMINING_TEXT1[31]} 
	end

	for i=1,3 do
		local tab = {}
		local btn = GetElement(self.m_root,"btn"..i,WZUIButton)
		tab.normal = GetElement(btn,"normal",WZUIImage)
		tab.select = GetElement(btn,"select",WZUIImage)
		tab.name = GetElement(btn,"name",WZUILabelTTF)
		self.m_tChangeTitle[i] = tab
		tab.name:setText(str_title[i])
	end
	self:onBtnChangeTitle(self.m_nShowTabIndex or 1)
end
function WndHouseInvite:onBtnChangeTitle(element)
	local tag
	if type(element) == "number" then
		tag = element
	else
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
		tag = element:getTag()
		if self.m_nWinType == 6 then 
			if tag == 1 and not WndTeamConsume:_judgeIsCaptain() then 
				MsgBoxManager:showTipBox(LocalStrings.TEAMCONSUME_TEXT1[19])
				return
			end
		end
	end
	if self.m_nCurIndex then
		self.m_tChangeTitle[self.m_nCurIndex].normal:setVisible(true)
		self.m_tChangeTitle[self.m_nCurIndex].select:setVisible(false)
		self.m_tChangeTitle[self.m_nCurIndex].name:setEnableStroke(false)
		self.m_tChangeTitle[self.m_nCurIndex].name:setColor(ccc3(127,70,26))
	end
	self.m_tChangeTitle[tag].normal:setVisible(false)
	self.m_tChangeTitle[tag].select:setVisible(true)
	self.m_tChangeTitle[tag].name:setColor(ccc3(255,236,193))
	self.m_tChangeTitle[tag].name:setEnableStroke(true)
	self.m_tChangeTitle[tag].name:setStrokeSize(4)
	self.m_tChangeTitle[tag].name:setStrokeColor(ccc3(132,66,29))

	local str_title = {LocalStrings.ACTIVITY_TEXT182, LocalStrings.ACTIVITY_TEXT186, LocalStrings.SHOOTARROW_TEXT21}
	if self.m_nWinType == 2 then 
		str_title = {LocalStrings.DECORATIONS_TEXT1[7], LocalStrings.DECORATIONS_TEXT1[5], LocalStrings.DECORATIONS_TEXT1[6]}
	elseif self.m_nWinType == 6 then 
		str_title = {LocalStrings.DOUBLE_SEVEN_TEXT19, LocalStrings.MASTERINFO24, LocalStrings.MASTERINFO24} 
	elseif self.m_nWinType == 7 or self.m_nWinType == 9 then 
		str_title = {LocalStrings.ACTIVITY_TEXT182, LocalStrings.SHOOTARROW_TEXT22, LocalStrings.SHOOTARROW_TEXT21} 
	elseif self.m_nWinType == 11 then 
		str_title = {LocalStrings.CATCHFISH_TEXT1[20], LocalStrings.CATCHFISH_TEXT1[21], LocalStrings.SHOOTARROW_TEXT21} 
	elseif self.m_nWinType == 12 then 
		str_title = {LocalStrings.PICKTEA_TEXT1[8]} 
	elseif self.m_nWinType == 13 then
		str_title = {LocalStrings.AFFORESTATION_TEXT1[16], LocalStrings.AFFORESTATION_TEXT1[17], LocalStrings.AFFORESTATION_TEXT1[18]}
	elseif self.m_nWinType == 16 then
		str_title = {LocalStrings.DRAGON_BALL_TEXT1[15], LocalStrings.DRAGON_BALL_TEXT1[16]}
	elseif self.m_nWinType == 17 then 
		str_title = {LocalStrings.JADE_TOUCH_TEXT1[8]} 
	elseif self.m_nWinType == 18 then
		str_title = {LocalStrings.LEIZHUZHEN_TEXT1[20], LocalStrings.LEIZHUZHEN_TEXT1[21]}
	elseif self.m_nWinType == 19 then
		str_title = {LocalStrings.PANJIAYUAN_TEXT1[14], LocalStrings.PANJIAYUAN_TEXT1[15]} 
	elseif self.m_nWinType == 20 then 
		str_title = {LocalStrings.KINGOFMINING_TEXT1[29], LocalStrings.KINGOFMINING_TEXT1[30], LocalStrings.KINGOFMINING_TEXT1[31]}
	end
	GetElement(self.m_root,"txtTitleName",WZUILabelTTF):setText(str_title[tag])

	if self.m_nWinType == 1 or self.m_nWinType == 5 or self.m_nWinType == 7 or self.m_nWinType == 9 or self.m_nWinType == 20 then 
		if self.m_sCurInvestActivityPanel ~= nil then
			if self.m_sCurInvestActivityPanel.setVisibleStatus then
				self.m_sCurInvestActivityPanel:setVisibleStatus(false)
			end
			self.m_sCurInvestActivityPanel = nil
		end

		local panel_con = GetElement(self.m_root,"panel_con",WZUIContainer)
		if self.m_tHouseActivityPanel[tag] == nil then
			local view = WndHouseInvite.Panel[tag]
	        if _G[view] then
	            local element, tObj = (_G[view]):createElement()
	            tObj:setWinType(self.m_nWinType)
	            self.m_tHouseActivityPanel[tag] = tObj
	            panel_con:addChild(element)
	        end
		end
		self.m_sCurInvestActivityPanel = self.m_tHouseActivityPanel[tag]
		if self.m_sCurInvestActivityPanel then
			if self.m_sCurInvestActivityPanel.setVisibleStatus then
				self.m_sCurInvestActivityPanel:setVisibleStatus(true)
			end
		end
	elseif self.m_nWinType == 2 then 
		local panel_con = GetElement(self.m_root,"panel_con",WZUIContainer)
		panel_con:setVisible(false)
		GetElement(self.m_root, "cellMyCard_WndHouseInvite", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "cellBless_WndHouseInvite", WZUIContainer):setVisible(false)
		if tag == 1 then 
			GetElement(self.m_root, "cellMyCard_WndHouseInvite", WZUIContainer):setVisible(true)
		elseif tag == 2 then 
			panel_con:setVisible(true)
			if self.m_tHouseActivityPanel[tag] == nil then 
				local element, tObj = CellHouseInviteNotice:createElement()
				tObj:setWinType(self.m_nWinType)
	            self.m_tHouseActivityPanel[tag] = tObj
	            panel_con:addChild(element)
	        end
        	if self.m_tHouseActivityPanel[tag].setVisibleStatus then
				self.m_tHouseActivityPanel[tag]:setVisibleStatus(true)
			end
		elseif tag == 3 then 
			self.m_tCardState = {}
			for i = 1, 3 do
				GetElement(self.m_root, "imgCar" .. i .. "_WndHouseInvite", WZUIImage):setFile("ui/newActivity/common_pic_zdjc_add.png")
			end
			GetElement(self.m_root, "imgCar4_WndHouseInvite", WZUIImage):setFile("ui/newActivity/common_pic_zdjc_add1.png")
			self:updateLeftNum()
			GetElement(self.m_root, "cellBless_WndHouseInvite", WZUIContainer):setVisible(true)
		end
	elseif self.m_nWinType == 3 then 
		GetElement(self.m_root,"txtTitleName",WZUILabelTTF):setText(LocalStrings.NEWYEARWISH_TEXT1[4])
		local panel_con = GetElement(self.m_root,"panel_con",WZUIContainer)
		panel_con:setVisible(false)
		GetElement(self.m_root, "cellWishWall_WndHouseInvite", WZUIContainer):setVisible(true)

		self:showWishWords()
	elseif self.m_nWinType == 4 then 
		GetElement(self.m_root,"txtTitleName",WZUILabelTTF):setText(LocalStrings.SECRETTOWER_TEXT1[11])
		local panel_con = GetElement(self.m_root,"panel_con",WZUIContainer)
		panel_con:setVisible(false)

		self:showEightDiagram()
	elseif self.m_nWinType == 6 then 
		local panel_con = GetElement(self.m_root,"panel_con",WZUIContainer)
		panel_con:setVisible(true)
		if self.m_sCurInvestActivityPanel ~= nil then
			if self.m_sCurInvestActivityPanel.setVisibleStatus then
				self.m_sCurInvestActivityPanel:setVisibleStatus(false)
			end
			self.m_sCurInvestActivityPanel = nil
		end
		if tag == 1 then 
			if self.m_tHouseActivityPanel[tag] == nil then 
				local element, tObj = CellHouseInviteFriend:createElement()
				tObj:setWinType(self.m_nWinType)
				self.m_tHouseActivityPanel[tag] = tObj
				panel_con:addChild(element)
			end
		elseif tag == 2 then 
			if self.m_tHouseActivityPanel[tag] == nil then 
				local element, tObj = CellHouseInviteNotice:createElement()
				tObj:setWinType(self.m_nWinType)
				self.m_tHouseActivityPanel[tag] = tObj
				panel_con:addChild(element)
			end
		end
		self.m_sCurInvestActivityPanel = self.m_tHouseActivityPanel[tag]
		if self.m_sCurInvestActivityPanel then
			if self.m_sCurInvestActivityPanel.setVisibleStatus then
				self.m_sCurInvestActivityPanel:setVisibleStatus(true)
			end
		end
	elseif self.m_nWinType == 8 then 
		GetElement(self.m_root,"txtTitleName",WZUILabelTTF):setText(LocalStrings.DETECTIVE_TEXT1[4])
		local panel_con = GetElement(self.m_root,"panel_con",WZUIContainer)
		panel_con:setVisible(false)

		self:showCaseSort()
	elseif self.m_nWinType == 10 then 
		GetElement(self.m_root,"txtTitleName",WZUILabelTTF):setText(LocalStrings.AUTUMNCAMP_TEXT1[15])
		local panel_con = GetElement(self.m_root,"panel_con",WZUIContainer)
		panel_con:setVisible(false)
	elseif self.m_nWinType == 11 then 
		local panel_con = GetElement(self.m_root,"panel_con",WZUIContainer)
		panel_con:setVisible(false)
		if tag == 1 then 
			self.m_tCatchFishSData = WndCatchFish:getLibraryData(0)
			GetElement(self.m_root, "tbShort_cellCatchFish", WZUITableContainer):setVisible(true)
			GetElement(self.m_root, "tbLong_cellCatchFish", WZUITableContainer):setVisible(false)
		else
			self.m_tCatchFishLData = WndCatchFish:getLibraryData(1)
			GetElement(self.m_root, "tbShort_cellCatchFish", WZUITableContainer):setVisible(false)
			GetElement(self.m_root, "tbLong_cellCatchFish", WZUITableContainer):setVisible(true)
		end
		self:_ShowCatchFishLibrary(tag)
	elseif self.m_nWinType == 12 then 
		local panel_con = GetElement(self.m_root,"panel_con",WZUIContainer)
		panel_con:setVisible(false)

		self.m_tCatchFishSData = WndPickTea:getLibraryData(0)
		GetElement(self.m_root, "tbShort_cellCatchFish", WZUITableContainer):setVisible(true)
		GetElement(self.m_root, "tbLong_cellCatchFish", WZUITableContainer):setVisible(false)
		
		self:_ShowCatchFishLibrary(tag)
	elseif self.m_nWinType == 13 then
		local panel_con = GetElement(self.m_root,"panel_con",WZUIContainer)
		panel_con:setVisible(false)
		local cellAfforestation1 = GetElement(self.m_root, "cellAfforestation1_WndHouseInvite", WZUIContainer)
		cellAfforestation1:setVisible(false)
		local cellAfforestation2 = GetElement(self.m_root, "cellAfforestation2_WndHouseInvite", WZUIContainer)
		cellAfforestation2:setVisible(false)

		if tag == 1 then 
			cellAfforestation1:setVisible(true)
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 3)
		elseif tag == 2 then 
			panel_con:setVisible(true)
			if self.m_tTaskList == nil then 
				ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 4)
			end
		elseif tag == 3 then
			cellAfforestation2:setVisible(true)
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 2)
		end
	elseif self.m_nWinType == 14 then
		GetElement(self.m_root,"txtTitleName",WZUILabelTTF):setText(LocalStrings.POTIONS_REFININ_TEXT1[4])
	elseif self.m_nWinType == 15 then
		GetElement(self.m_root,"txtTitleName",WZUILabelTTF):setText(LocalStrings.HOLY_HAND_TEXT1[6])
		self.m_tBigRewardList2 = {}
		local tData = {pool = 3}
		local strJson = json.encode(tData)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson)
	elseif self.m_nWinType == 16 then
		if tag == 1 then
			self.m_nCampTabIndex = 2
		elseif tag == 2 then
			self.m_nCampTabIndex = 3
		end
		self:_showDragonBall()
	elseif self.m_nWinType == 17 then 
		local panel_con = GetElement(self.m_root,"panel_con",WZUIContainer)
		panel_con:setVisible(false)

		self.m_tCatchFishSData = WndJadeTouch:getLibraryData(0)
		GetElement(self.m_root, "tbShort_cellCatchFish", WZUITableContainer):setVisible(true)
		GetElement(self.m_root, "tbLong_cellCatchFish", WZUITableContainer):setVisible(false)
		
		self:_ShowCatchFishLibrary(tag)
	elseif self.m_nWinType == 18 then
		local panel_con = GetElement(self.m_root,"panel_con",WZUIContainer)
		panel_con:setVisible(false)
		local cellLeiZhuZhen1 = GetElement(self.m_root, "cellLeiZhuZhen1_WndHouseInvite", WZUIContainer)
		cellLeiZhuZhen1:setVisible(false)

		if tag == 1 then
			panel_con:setVisible(true)
			if self.m_tTaskList == nil then 
				ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 4)
			end
		elseif tag == 2 then
			cellLeiZhuZhen1:setVisible(true)
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 2)
		end
	elseif self.m_nWinType == 19 then
		local panel_con = GetElement(self.m_root,"panel_con",WZUIContainer)
		panel_con:setVisible(false)
		local conRestoreTips1 = GetElement(self.m_root, "conRestoreTips1_cellAntiqueRestore", WZUIContainer)
		local conRestoreTips2 = GetElement(self.m_root, "conRestoreTips2_cellAntiqueRestore", WZUIContainer)
		if tag == 1 then
			conRestoreTips1:setVisible(true)
			conRestoreTips2:setVisible(false)
		elseif tag == 2 then
			conRestoreTips1:setVisible(false)
			conRestoreTips2:setVisible(true)
		end
		self:_showPieceNum(tag)
		if #self.m_tGetTimes2 == 2 then
			self:_showRestoreReward(tag)
		end
	end

	self.m_nCurIndex = tag
end
function WndHouseInvite:setInviteNoticeRedPoint()
	if not self.m_root then return end
	if self.m_nWinType == 3 or self.m_nWinType == 8 or self.m_nWinType == 10 or self.m_nWinType == 12 then return end 
	
	if self.m_nWinType == 2 then 
		GetElement(self.m_root,"imgRedDot2_WndHouseInvite",WZUIImage):setVisible(GlobalGame.g_tRedPointTypeList[27030])
	elseif self.m_nWinType == 5 then 
		GetElement(self.m_root,"imgNoticeRedPoint",WZUIImage):setVisible(GlobalGame.g_tRedPointTypeList[17058])
	elseif self.m_nWinType == 6 then 
		GetElement(self.m_root,"imgRedDot2_WndHouseInvite",WZUIImage):setVisible(GlobalGame.g_tRedPointTypeList[17074])
	elseif self.m_nWinType == 7 then 
		GetElement(self.m_root,"imgNoticeRedPoint",WZUIImage):setVisible(GlobalGame.g_tRedPointTypeList[17082])
	elseif self.m_nWinType == 9 then 
		GetElement(self.m_root,"imgNoticeRedPoint",WZUIImage):setVisible(GlobalGame.g_tRedPointTypeList[17087])
	elseif self.m_nWinType == 11 then 
		local tDataList = WndCatchFish:getLibraryData(0)
		local bIsHaveReddot = false 
		for i = 1, #tDataList do
			if tDataList[i].status == 1 then 
				bIsHaveReddot = true 
				break 
			end
		end
		tDataList = WndCatchFish:getLibraryData(1)
		local bIsHaveReddot2 = false 
		for i = 1, #tDataList do
			if tDataList[i].status == 1 then 
				bIsHaveReddot2 = true 
				break 
			end
		end
		GetElement(self.m_root,"imgRedDot1_WndHouseInvite",WZUIImage):setVisible(bIsHaveReddot)
		GetElement(self.m_root,"imgRedDot2_WndHouseInvite",WZUIImage):setVisible(bIsHaveReddot2)
	elseif self.m_nWinType == 13 then 
		GetElement(self.m_root,"imgRedDot2_WndHouseInvite",WZUIImage):setVisible(GlobalGame.g_tRedPointTypeList[247109])
	elseif self.m_nWinType == 18 then
		GetElement(self.m_root,"imgRedDot1_WndHouseInvite",WZUIImage):setVisible(GlobalGame.g_tRedPointTypeList[247119])
	elseif self.m_nWinType == 20 then 
		GetElement(self.m_root,"imgNoticeRedPoint",WZUIImage):setVisible(GlobalGame.g_tRedPointTypeList[17130])
	elseif self.m_nWinType == 5 then 
		GetElement(self.m_root,"imgNoticeRedPoint",WZUIImage):setVisible(GlobalGame.g_tRedPointTypeList[17058])
	else
		GetElement(self.m_root,"imgNoticeRedPoint",WZUIImage):setVisible(GlobalGame.g_tRedPointTypeList[17029])
	end
end
function WndHouseInvite:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief 	点击祝福按钮回调
function WndHouseInvite:onClickBless(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()

	local tItemIds = {160167, 160168}
	if nTag <= 4 then 
		if not self.m_tCardState[nTag] then 
			local tData = {}
			tData.num1 = self.m_tCardLeftNum[1]
			tData.num2 = self.m_tCardLeftNum[2]
			tData.itemIds = tItemIds
			tData.nTag = nTag 

			WndTips:show(element, self.m_root, 77, tData)
		end
	elseif nTag == 5 then 
		local bIsCanBless = false 
		if self.m_tCardState[1] and self.m_tCardState[2] and self.m_tCardState[3] and self.m_tCardState[4] then 
			bIsCanBless = true 
		end
		if bIsCanBless then 
			local tData = {}
			tData.times = 1
			tData.optType = 2
			tData.costCardNum = 0
			for i = 1, 4 do
				if self.m_tCardState[i] == tItemIds[1] then 
					tData.costCardNum = tData.costCardNum + 1
				end
			end

			local stringData = json.encode(tData)
			WZLog("ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo", self.m_nActivityId, stringData)
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 1, stringData)
		else
			MsgBoxManager:showTipBox(LocalStrings.DECORATIONS_TEXT1[17])
		end
	end
end

--@brief 	点击赠礼/收礼按钮回调
function WndHouseInvite:onClickGive(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if nTag == 1 then 
		if WndDecorations.m_tContent.sendCardLeftNum <= 0 then 
			MsgBoxManager:showTipBox(LocalStrings.DECORATIONS_TEXT1[10])
			return 
		end
		local wnd = WndOnlineHintFriend:createElement()
		if wnd then
			WindowManager:addWindow(wnd, WndOnlineHintFriend, true)
			local tTempFriend = CacheCenter:getCurrentFriendList()
			local tFriends = CopyTable(tTempFriend)
			WndOnlineHintFriend:setData(tFriends, 3)
		end
	elseif nTag == 2 then 
		self:onBtnChangeTitle(2)
	elseif nTag == 3 then --潘家园鉴宝-赠送好友
		if self.m_tOtherData.dayGiveTimes >= self.m_tOtherData.dayGiveLimit then 
			MsgBoxManager:showTipBox(LocalStrings.PANJIAYUAN_TEXT1[20])
			return 
		end
		WndActivityGive:showInterface(self.m_nActivityId, 1, self.m_tPieceItemIds, self.m_tOtherData)
	elseif nTag == 4 then --潘家园鉴宝-赠送记录
		WndActivityGive:showInterface(self.m_nActivityId, 3)
	end
end

--@brief 	选中卡片回调
function WndHouseInvite:chooseCardCallBack(tData, nTag)
	local imgCar = GetElement(self.m_root, "imgCar" .. tData.nTag .. "_WndHouseInvite", WZUIImage)
	if not self.m_tCardState[tData.nTag] then 
		self.m_tCardState[tData.nTag] = tData.itemIds[nTag]
		imgCar:setFile(WndDecorations.m_tCardPath[nTag])
		self.m_tCardLeftNum[nTag] = self.m_tCardLeftNum[nTag] - 1
	end
end

--@brief 	点击礼包按钮回调
function WndHouseInvite:onClickGet(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if WndNewYearWish.m_nGiftRewardNum >= 1 then
		--背包已满提示
		if CacheCenter:getRemainAmount() <= 0 then
			MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
			return
		end
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, "")
	else
		local tData = {}
		tData.txtTitle = LocalStrings.NEWYEARWISH_TEXT1[9]
		tData.nType = 2
		WndTips:show(element, self.m_root, 52, tData, GlobalMethod:ccp(100,80))
	end
end

--@brief 	点击物品回调
function WndHouseInvite:onClickItem(tCell,tag,tData)
	if tData == nil then
	   return
	end
	WndItemInfo:onCloseClick()
	WndItemInfo:showInfo(tCell.m_root, self.m_root,1,tData,false,nil,true)
end

--@brief 	点击整理案件按钮回调
function WndHouseInvite:onClickSort(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if nTag == 1 then 
		local tabLen = GetTableLen(self.m_tAddCaseItem)
		WZLog("WndHouseInvite:onClickSort", tabLen, self.m_tNumCostList[self.m_nShowTabIndex])
		if tabLen < self.m_tNumCostList[self.m_nShowTabIndex] then 
			MsgBoxManager:showTipBox(LocalStrings.DETECTIVE_TEXT1[19])
		else
			if self.m_nChooseReward == 0 then 
				WndDetective:onClickBigReward(2)

				self.m_nChooseReward = 1
				WndDetective:saveOperateTimes(true)
				return 
			end
			local tData = {pool = self.m_nShowTabIndex-1}
			local strJson = json.encode(tData)
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 5, strJson)
		end
	elseif nTag == 2 then 
		WndDetective:onClickBigReward(element)
	elseif nTag == 3 then 
		WndSingleMapDesc:showInterface1(LocalStrings.DETECTIVE_TEXT3) 
	elseif nTag == 4 then --潘家园鉴宝-修复完成
		local tData = {id = self.m_nCurIndex-1}
		local strJson = json.encode(tData)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 6, strJson)
	end
end

--@brief 	切换不同道具
function WndHouseInvite:onChooseType(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if nTag == self.m_nShowTabIndex then return end 

	self:_cleanCaseUIData(self.m_nShowTabIndex)
	self.m_tAddCaseItem = {}
	self.m_nShowTabIndex = nTag 
	self:_showCaseCostItem()
end

--@brief 	点击一键放入按钮回调
function WndHouseInvite:onClickPut(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local itemList = self.m_tIdCostList
	local nTag = element:getTag()
	if nTag ~= self.m_nShowTabIndex then 
		self:_cleanCaseUIData(self.m_nShowTabIndex)
		self.m_tAddCaseItem = {}
		self.m_nShowTabIndex = nTag 
		self:_showCaseCostItem()
	end
	WZLog("WndHouseInvite:onClickPut", nTag, Serialize(self.m_tCardLeftNum))
	local tabLen = GetTableLen(self.m_tAddCaseItem)
	if tabLen == self.m_tNumCostList[nTag] then 
		MsgBoxManager:showTipBox(LocalStrings.DETECTIVE_TEXT1[18])
	else
		local basicData = GDatatab_item["id_" .. itemList[nTag]]
		if self.m_tCardLeftNum[nTag] == 0 or self.m_tCardLeftNum[nTag] - tabLen <= 0 then 
			MsgBoxManager:showTipBox(string.format(LocalStrings.CARD_COUNT1, basicData.name))
		else
			local minNum = math.min(self.m_tNumCostList[nTag], self.m_tCardLeftNum[nTag])
			local conCaseTips = GetElement(self.m_root, "conCaseTips" .. nTag .. "_cellCaseSort", WZUIContainer)
			for i = 1, minNum do
				self.m_tAddCaseItem[i] = itemList[nTag]
				local txtItemN = GetElement(conCaseTips, "txtItemN" .. i .. "_cellCaseSort", WZUILabelTTF)
				local imgIcon = GetElement(conCaseTips, "imgIcon" .. i .. "_cellCaseSort", WZUIImage)
				local btnAdd = GetElement(conCaseTips, "btnAdd" .. i .. "_cellCaseSort", WZUIButton)
				txtItemN:setText(basicData.name)
				imgIcon:setFile(basicData.icon)
				btnAdd:setVisible(false)
			end

			txtLeftNum = GetElement(self.m_root, "txtLeftNum" .. nTag .. "_cellCaseSort", WZUILabelTTF)
			txtLeftNum:setText(self.m_tCardLeftNum[nTag] - minNum)
		end
	end
end

--@brief 	点击添加单个道具按钮回调
function WndHouseInvite:onClickAdd(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	local itemList = self.m_tIdCostList
	local basicData = GDatatab_item["id_" .. itemList[self.m_nShowTabIndex]]
	local tabLen = GetTableLen(self.m_tAddCaseItem)
	if self.m_tCardLeftNum[self.m_nShowTabIndex] == 0 or self.m_tCardLeftNum[self.m_nShowTabIndex] - tabLen <= 0 then 
		MsgBoxManager:showTipBox(string.format(LocalStrings.CARD_COUNT1, basicData.name))
	else
		local conCaseTips = GetElement(self.m_root, "conCaseTips" .. self.m_nShowTabIndex .. "_cellCaseSort", WZUIContainer)

		self.m_tAddCaseItem[nTag] = itemList[self.m_nShowTabIndex]
		local txtItemN = GetElement(conCaseTips, "txtItemN" .. nTag .. "_cellCaseSort", WZUILabelTTF)
		local imgIcon = GetElement(conCaseTips, "imgIcon" .. nTag .. "_cellCaseSort", WZUIImage)
		local btnAdd = GetElement(conCaseTips, "btnAdd" .. nTag .. "_cellCaseSort", WZUIButton)
		txtItemN:setText(basicData.name)
		imgIcon:setFile(basicData.icon)
		btnAdd:setVisible(false)

		txtLeftNum = GetElement(self.m_root, "txtLeftNum" .. self.m_nShowTabIndex .. "_cellCaseSort", WZUILabelTTF)
		txtLeftNum:setText(self.m_tCardLeftNum[self.m_nShowTabIndex] - tabLen - 1)
	end
end

--@brief 	点击开启按钮回调
function WndHouseInvite:onClickAddWood(element) 
	if SystemTime:getServerTime() >= WndAutumnCamp.m_nEndTime then 
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END) 
		self:onBtnClose()
		WndAutumnCamp:onCloseClick(0)
		return 
	end 
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if nTag == 2 then 
		if self.m_nAniType == 2 then 
			self.m_nAniType = 1
		else
			self.m_nAniType = 2
		end
		
		self:_setFreeBtnText()
		return 
	end
	--背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
    if self.m_bOpenState then MsgBoxManager:showTipBox(LocalStrings.AUTUMNCAMP_TEXT1[21]) return end 
    
	local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local nTempTimes = nArrowNum
	local nTimes = nTag
	local freeCount = 0
	if self.m_nAniType == 2 then 
		nTag = self.m_nMaxLotteryCount 
		nTimes = (nTempTimes + freeCount) >= self.m_nMaxLotteryCount and self.m_nMaxLotteryCount or nTempTimes > 0 and (nTempTimes + freeCount) or self.m_nMaxLotteryCount 
	end
	local nCostNum = nTimes
	nCostNum = nTimes 
	if nCostNum - freeCount > nArrowNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		MsgBoxManager:showTipBox(string.format(LocalStrings.CARD_COUNT1, basicData.name))
		return 
	end

    local tData = {}
	tData.times = nTag

	local stringData = json.encode(tData)

	self:setOpenState(true)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 6, stringData)
	self.m_nRefreshTime = 0
end

--@brief 	切换篝火类型
function WndHouseInvite:onClickCampTab(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local nTag = element:getTag()
	if self.m_nCampTabIndex == nTag then return end 
	self.m_nCampTabIndex = nTag
	self.m_tTaskItemCell = nil 
	self:getTaskData()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	初始化
function WndHouseInvite:_initStaticText()
	GetElement(self.m_root, "txtLeft1_WndHouseInvite", WZUILabelTTF):setText(LocalStrings.SHOP_GOODSSHEGN .. ":")
	GetElement(self.m_root, "txtLeft2_WndHouseInvite", WZUILabelTTF):setText(LocalStrings.SHOP_GOODSSHEGN .. ":")
	GetElement(self.m_root, "txtBtn1_WndHouseInvite", WZUILabelTTF):setText(LocalStrings.DECORATIONS_TEXT1[8])
	GetElement(self.m_root, "txtBtn2_WndHouseInvite", WZUILabelTTF):setText(LocalStrings.DECORATIONS_TEXT1[9])
	GetElement(self.m_root, "txtBtn3_WndHouseInvite", WZUILabelTTF):setText(LocalStrings.BEATENGINEER_TEXT1[11])
	if self.m_nWinType == 8 then 
		GetElement(self.m_root, "txtBtn4_WndHouseInvite", WZUILabelTTF):setText(LocalStrings.DETECTIVE_TEXT1[4])
		GetElement(self.m_root, "txtBtn5_WndHouseInvite", WZUILabelTTF):setText(LocalStrings.ALCHEMY_TEXT1[13])
		GetElement(self.m_root, "txtBtn6_WndHouseInvite", WZUILabelTTF):setText(LocalStrings.ALCHEMY_TEXT1[13])
		GetElement(self.m_root, "txtBtn7_WndHouseInvite", WZUILabelTTF):setText(LocalStrings.WATERMELON_TEXT1[22])
		GetElement(self.m_root, "txtLeft1_cellCaseSort", WZUILabelTTF):setText(LocalStrings.NUM1 .. ":")
		GetElement(self.m_root, "txtLeft2_cellCaseSort", WZUILabelTTF):setText(LocalStrings.NUM1 .. ":")

		self.m_nChooseReward = WndDetective:getOperateTimes(true)
	elseif self.m_nWinType == 10 then 
		GetElement(self.m_root, "txtLeft1_cellCampFire", WZUILabelTTF):setText(LocalStrings.AUTUMNCAMP_TEXT1[17] .. ":")
		GetElement(self.m_root, "txtLeft2_cellCampFire", WZUILabelTTF):setText(LocalStrings.AUTUMNCAMP_TEXT1[20] .. ":")
		GetElement(self.m_root, "txtTab1_cellCampFire", WZUILabelTTF):setText(LocalStrings.AUTUMNCAMP_TEXT1[22])
		GetElement(self.m_root, "txtTab1Sel_cellCampFire", WZUILabelTTF):setText(LocalStrings.AUTUMNCAMP_TEXT1[22])
		GetElement(self.m_root, "txtTab2_cellCampFire", WZUILabelTTF):setText(LocalStrings.AUTUMNCAMP_TEXT1[23])
		GetElement(self.m_root, "txtTab2Sel_cellCampFire", WZUILabelTTF):setText(LocalStrings.AUTUMNCAMP_TEXT1[23])
		self:_setFreeBtnText()
		self:_showCampHot()
		self:updateCampWoodNum()
	elseif self.m_nWinType == 13 then
		GetElement(self.m_root, "txtTreeBelong1_cellAfforestation1", WZUILabelTTF):setText(LocalStrings.AFFORESTATION_TEXT1[19] .. ":")
		GetElement(self.m_root, "txtTreeBelong2_cellAfforestation1", WZUILabelTTF):setText(LocalStrings.AFFORESTATION_TEXT1[20] .. ":")
		GetElement(self.m_root, "txtRankTitle1_cellAfforestation1", WZUILabelTTF):setText(LocalStrings.PLAYER)
		GetElement(self.m_root, "txtRankTitle2_cellAfforestation1", WZUILabelTTF):setText(LocalStrings.AFFORESTATION_TEXT1[27])
		GetElement(self.m_root, "txtRewardTitle_cellAfforestation1", WZUILabelTTF):setText(LocalStrings.AFFORESTATION_TEXT1[22])

		GetElement(self.m_root, "txtTitle1_cellAfforestation2", WZUILabelTTF):setText(LocalStrings.AFFORESTATION_TEXT1[23])
		GetElement(self.m_root, "txtTitle2_cellAfforestation2", WZUILabelTTF):setText(LocalStrings.AFFORESTATION_TEXT1[24])
		GetElement(self.m_root, "txtTitle3_cellAfforestation2", WZUILabelTTF):setText(LocalStrings.AFFORESTATION_TEXT1[21])
		GetElement(self.m_root, "txtTitle4_cellAfforestation2", WZUILabelTTF):setText(LocalStrings.ATH_REWARD_CHECK)
		GetElement(self.m_root, "txtScoreTitle_cellAfforestation2", WZUILabelTTF):setText(LocalStrings.AFFORESTATION_TEXT1[25] .. ":")
		GetElement(self.m_root, "txtRankTitle_cellAfforestation2", WZUILabelTTF):setText(LocalStrings.DOUBLE_SEVEN_TEXT14)
	elseif self.m_nWinType == 14 then
		GetElement(self.m_root, "txtChooseRewards_cellPotions", WZUILabelTTF):setText(LocalStrings.WATERMELON_TEXT1[22])
	elseif self.m_nWinType == 15 then
		GetElement(self.m_root, "txtTitleName", WZUILabelTTF):setText(LocalStrings.HOLY_HAND_TEXT1[6])
		GetElement(self.m_root, "txtCostName_cellHolyHand", WZUILabelTTF):setText(LocalStrings.HOLY_HAND_TEXT1[18] .. ":")
		GetElement(self.m_root, "txtBtnGet_cellHolyHand", WZUILabelTTF):setText(LocalStrings.HOLY_HAND_TEXT1[19])
	elseif self.m_nWinType == 18 then
		GetElement(self.m_root, "txtTitle1_cellLeiZhuZhen1", WZUILabelTTF):setText(LocalStrings.LEIZHUZHEN_TEXT1[22])
		GetElement(self.m_root, "txtTitle2_cellLeiZhuZhen1", WZUILabelTTF):setText(LocalStrings.LEIZHUZHEN_TEXT1[23])
		GetElement(self.m_root, "txtTitle3_cellLeiZhuZhen1", WZUILabelTTF):setText(LocalStrings.LEIZHUZHEN_TEXT1[24])
		GetElement(self.m_root, "txtScoreTitle_cellLeiZhuZhen1", WZUILabelTTF):setText(LocalStrings.LEIZHUZHEN_TEXT1[25] .. ":")
		GetElement(self.m_root, "txtRankTitle_cellLeiZhuZhen1", WZUILabelTTF):setText(LocalStrings.LEIZHUZHEN_TEXT1[26] .. ":")

		GetElement(self.m_root, "txtScoreTitle_cellLeiZhuZhen1", WZUILabelTTF):setColor(ccc3(255,236,193))
		GetElement(self.m_root, "txtRankTitle_cellLeiZhuZhen1", WZUILabelTTF):setColor(ccc3(255,236,193))
		GetElement(self.m_root,"txtMyScore_cellLeiZhuZhen1",WZUILabelTTF):setColor(ccc3(255,255,255))
		GetElement(self.m_root,"txtMyRank_cellLeiZhuZhen1",WZUILabelTTF):setColor(ccc3(255,255,255))

		local txtTeamRewardWord = GetElement(self.m_root, "txtTeamRewardWord_cellLeiZhuZhen1", WZUILabelTTF)
		txtTeamRewardWord:setText(LocalStrings.LEIZHUZHEN_TEXT1[28])
		local txtSize = txtTeamRewardWord:getLabelContentSize()
		local conTeamRewardWord = GetElement(self.m_root, "conTeamRewardWord_cellLeiZhuZhen1", WZUIContainer)
		conTeamRewardWord:setAbsContentSize(CCSize(txtSize.width, 6))
		conTeamRewardWord:updateRelativeSize()
	elseif self.m_nWinType == 19 then
		GetElement(self.m_root, "txtBtn1_cellAntiqueRestore", WZUILabelTTF):setText(LocalStrings.PANJIAYUAN_TEXT1[21])
		GetElement(self.m_root, "txtBtn2_cellAntiqueRestore", WZUILabelTTF):setText(LocalStrings.PANJIAYUAN_TEXT1[23])
		GetElement(self.m_root, "txtTitleL_cellAntiqueRestore", WZUILabelTTF):setText(LocalStrings.PANJIAYUAN_TEXT1[8])
		GetElement(self.m_root, "txtAtt_cellAntiqueRestore", WZUILabelTTF):setText(LocalStrings.PANJIAYUAN_TEXT1[17])
	end
end

--@brief 	刷新贺卡和礼品卡的数量
function WndHouseInvite:updateLeftNum()
	local tItemIds = {160167, 160168}
	if self.m_nWinType == 8 then 
		tItemIds = self.m_tIdCostList
		WndDetective:showRedDotTwo()
	end
	for i = 1, 2 do
		local txtLeftNum = nil 
		if self.m_nWinType == 8 then 
			txtLeftNum = GetElement(self.m_root, "txtLeftNum" .. i .. "_cellCaseSort", WZUILabelTTF)
		else
			txtLeftNum = GetElement(self.m_root, "txtLeftNum" .. i .. "_WndHouseInvite", WZUILabelTTF)
		end

		local num = CacheCenter:getPlayerItemCountById(tItemIds[i])
		txtLeftNum:setText(num)

		self.m_tCardLeftNum[i] = num
	end
end

--@brief 	刷新柴火的数量
function WndHouseInvite:updateCampWoodNum()
	local ftxtCoin = GetElement(self.m_root, "ftxtCoin_cellCampFire", WZUIFreeTextBox)
	local sFormat = [[<I Z="0.45" P="1">%s</I><T C="255,250,236" S="18" P="1" SC="163,74,20" SS="4" SE="1">%d</T>]]
	if ftxtCoin then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
		ftxtCoin:setShowText(string.format(sFormat, basicData.icon, nLightNum))
	end
end

--@brief 	显示心愿墙内容
function WndHouseInvite:showWishWords()
	for i = 1, #WndNewYearWish.m_tWishWords do
		local txtWishWord = GetElement(self.m_root, "txtWishWord" .. i .. "_cellWishWall", WZUILabelTTF)
		txtWishWord:setText(WndNewYearWish.m_tWishWords[i])
		if WndNewYearWish.m_tWishWordsNum[i] < 0 then 
			txtWishWord:setColor(GlobalMethod:ccc3(142,1,0))
		end
	end

	local imgRedDot = GetElement(self.m_root, "imgRedDot_cellWishWall", WZUIImage)
	local txtRewardNum = GetElement(self.m_root, "txtRewardNum_cellWishWall", WZUILabelTTF)
	if WndNewYearWish.m_nGiftRewardNum > 0 then 
		imgRedDot:setVisible(true)
		txtRewardNum:setVisible(true)
		txtRewardNum:setText(WndNewYearWish.m_nGiftRewardNum)
	else
		imgRedDot:setVisible(false)
		txtRewardNum:setVisible(false)
	end
end

--@brief 	显示八卦方位
function WndHouseInvite:showEightDiagram()
	GetElement(self.m_root, "cellEightDiagram_WndHouseInvite", WZUIContainer):setVisible(true)

	local itemList = {160289, 160290, 160291, 160292, 160293, 160294, 160295, 160296}
	for i = 1, #itemList do
		local conWords = GetElement(self.m_root, "conWords" .. i .. "_cellEightDiagram", WZUIContainer)
		local imgWordBg = GetElement(conWords, "imgWordBg_cellEightDiagram", WZUIImage)
		local imgItemIcon = GetElement(conWords, "imgItemIcon_cellEightDiagram", WZUIImage)
		local txtItemNum = GetElement(conWords, "txtItemNum_cellEightDiagram", WZUILabelTTF)
		local ownNum = CacheCenter:getPlayerItemCountById(itemList[i])
		local basicData = GDatatab_item["id_" .. itemList[i]]
		imgItemIcon:setFile(basicData.icon)
		if ownNum > 0 then 
			imgWordBg:setFile("ui/newActivity/common_mjct_di_02.png")
			imgItemIcon:setGrayRender(false)
			txtItemNum:setText(ownNum)
		else
			imgWordBg:setFile("ui/newActivity/common_mjct_di_01.png")
			imgItemIcon:setGrayRender(true)
			txtItemNum:setText("")
		end
	end
	--临时数据
	self.m_tEightTask = WndSecretTower:getEightPragramData()
	--奖励
	local conReward = GetElement(self.m_root, "conReward_cellEightDiagram", WZUIContainer)
	if self.m_tNodeReward == nil then 
		self.m_tNodeReward = {}
		local nPosStart = 0.87
		local nPadding = 0.27
		for i = 1, #self.m_tEightTask do
			local element, tNewObj = CellEightDiagramItem:createElement()
			if element and tNewObj then 
				tNewObj:setData(self.m_tEightTask[i])
				element:setRelativePosition(GlobalMethod:ccp(0.5, nPosStart - (i - 1) * nPadding))
				conReward:addChild(element)

				table.insert(self.m_tNodeReward, tNewObj)
			end
		end
	else
		for i = 1, #self.m_tNodeReward do
			local tNewObj = self.m_tNodeReward[i]
			if tNewObj then 
				tNewObj:setBtnState()
			end
		end
	end
end

--@brief 	显示整理案件
function WndHouseInvite:showCaseSort()
	GetElement(self.m_root, "cellCaseSort_WndHouseInvite", WZUIContainer):setVisible(true)

	local itemList = self.m_tIdCostList
	for i = 1, #itemList do
		local conItem = GetElement(self.m_root, "conItem" .. i .. "_cellCaseSort", WZUIContainer)
		local txtLeftNum = GetElement(self.m_root, "txtLeftNum" .. i .. "_cellCaseSort", WZUILabelTTF)
		local txtItemName = GetElement(conItem, "txtItemName_cellCaseSort", WZUILabelTTF)
		local conGood = GetElement(conItem, "conGood_cellCaseSort", WZUIContainer)
		conGood:removeAllChildrenWithCleanup(true)

		local basicData = GDatatab_item["id_" .. itemList[i]]
		txtItemName:setText(basicData.name)
		local num = CacheCenter:getPlayerItemCountById(itemList[i])
		txtLeftNum:setText(num)

		self.m_tCardLeftNum[i] = num
		local element, tNewObj = CellGoodItem:createElement()
		if element and tNewObj then 
			tNewObj:setCellGoodLocalId(itemList[i], 0, 4)
			conGood:addChild(element)
		end
	end

	self:_showCaseCostItem()
end

--@brief 	显示整理案件消耗道具
function WndHouseInvite:_showCaseCostItem()
	for i = 1, 2 do
		local conSel = GetElement(self.m_root, "conSel" .. i .. "_cellCaseSort", WZUIContainer)
		local conCaseTips = GetElement(self.m_root, "conCaseTips" .. i .. "_cellCaseSort", WZUIContainer)
		if i == self.m_nShowTabIndex then 
			conSel:setVisible(true)
			conCaseTips:setVisible(true)
		else
			conSel:setVisible(false)
			conCaseTips:setVisible(false)
		end
	end
end

--@brief 	清除界面数据
function WndHouseInvite:_cleanCaseUIData(nIndex)
	local num = self.m_tNumCostList[nIndex]
	local conCaseTips = GetElement(self.m_root, "conCaseTips" .. nIndex .. "_cellCaseSort", WZUIContainer)
	for i = 1, num do
		local txtItemN = GetElement(conCaseTips, "txtItemN" .. i .. "_cellCaseSort", WZUILabelTTF)
		local imgIcon = GetElement(conCaseTips, "imgIcon" .. i .. "_cellCaseSort", WZUIImage)
		local btnAdd = GetElement(conCaseTips, "btnAdd" .. i .. "_cellCaseSort", WZUIButton)
		txtItemN:setText("")
		imgIcon:setFile("")
		btnAdd:setVisible(true)
	end

	txtLeftNum = GetElement(self.m_root, "txtLeftNum" .. nIndex .. "_cellCaseSort", WZUILabelTTF)
	txtLeftNum:setText(self.m_tCardLeftNum[nIndex])
end

--@brief 	设置免费丢
function WndHouseInvite:_setFreeBtnText()
	local txtBtnOpenOne = GetElement(self.m_root, "txtBtn8_WndHouseInvite", WZUILabelTTF)

	local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local freeTimes = 0 
	local nTempTimes = nLightNum
	local nTimes = 0
	if self.m_nAniType == 1 then 
		nTimes = 1
	else
		nTimes = (nTempTimes + freeTimes) >= self.m_nMaxLotteryCount and self.m_nMaxLotteryCount or nTempTimes > 0 and (nTempTimes + freeTimes) or self.m_nMaxLotteryCount 
	end
	txtBtnOpenOne:setText(string.format(LocalStrings.AUTUMNCAMP_TEXT1[8], nTimes))
end

--@brief 	显示任务
function WndHouseInvite:_showCampFireTask()
	local count = getnTableCount(self.m_tTaskData)
	taskTableSort(self.m_tTaskData)
	if self.m_tTaskItemCell == nil then 
		local flTask = GetElement(self.m_root,"flTask_cellCampFire",WZUIFreeListContainer)
		if flTask:size() > 0 then 
			flTask:removeAll()
		end
		self.m_tTaskItemCell = {}
		for i = 1, count do
			local element, tLuaObj = CellCampFireTaskItem:createElement()
			self.m_tTaskItemCell[i] = tLuaObj
			element:setContentSize(GlobalMethod:CCSize(372,130))
			element:setRelativeSize(GlobalMethod:CCSize(1, 130/362))
			flTask:pushBack(WZUIContainer:luaTo(element))
			flTask:getMoveElement():setPositionY(flTask:getMinPosition().y)
			tLuaObj:setGiftBuyMessage(i, self.m_tTaskData[i])
		end
	else
		for i = 1, count do
			self.m_tTaskItemCell[i]:resetGiftBuyMessage(i, self.m_tTaskData[i])
		end
	end
end

--@brief 	射箭任务奖励
function WndHouseInvite:_onGetTaskResult(activityId, id)
--	WZLog("CellNewYearTask:_onGetTaskResult", self.m_nActivityId, activityId, id)
	if self.m_nActivityId ~= activityId then
		MsgBoxManager:showTipBox(LocalStrings.RETURNEE_TEXT28)
		return
	end
	
	local taskData = GDatatab_new_activity_task["id_" .. id]
	if taskData then
		if self.m_tTaskItemCell then
			for i,v in pairs(self.m_tTaskData) do
				if v and v.id == id then
					self.m_tTaskData[i].status = 2	
					break
				end
			end
			taskTableSort(self.m_tTaskData)
			for i,v in ipairs(self.m_tTaskItemCell) do
				if v then
					v:setTaskItemMessage(i,self.m_tTaskData[i])
				end
			end
		end
	end
end

--@brief 	显示个人和全服热度
function WndHouseInvite:_showCampHot()
	if self.m_root == nil then return end 

	GetElement(self.m_root, "txtLeftNum1_cellCampFire", WZUILabelTTF):setText(WndAutumnCamp.m_nGlobalHot)
	GetElement(self.m_root, "txtLeftNum2_cellCampFire", WZUILabelTTF):setText(WndAutumnCamp.m_nPersonalHot)
end

--@brief 	计时器
function WndHouseInvite:_caculateTime()
	-- body
	self.m_nRefreshTime = self.m_nRefreshTime + 1
	if self.m_nRefreshTime >= 8 then 
		self.m_nRefreshTime = 0
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 1, "")
		self:getTaskData()
	end
end

--@brief 	请求任务数据更新
function WndHouseInvite:getTaskData()
	if self.m_root == nil then return end 

	self.m_tTaskData = nil
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, self.m_nCampTabIndex)
end

--@brief 	设置待机特效
function WndHouseInvite:_setBallAni()
	local spinePath = "activity/hd_pic_luying"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		local spineFire = GetElement(self.m_root, "spineFire_cellCampFire", WZUISpine)
		if spineFire then 
			spineFire:setFileJson(spinePath .. ".json")
			spineFire:setFileAtlas(spinePath .. ".atlas")
			spineFire:play("wait1_4", true)
		end
	end
end

--@brief 	显示捕鱼图鉴
function WndHouseInvite:_ShowCatchFishLibrary(index)
	local tbList = nil 
	local tDataList = nil 
	if index == 1 then 
		tDataList = self.m_tCatchFishSData
		tbList = GetElement(self.m_root, "tbShort_cellCatchFish", WZUITableContainer)
	elseif index == 2 then 
		tDataList = self.m_tCatchFishLData
		tbList = GetElement(self.m_root, "tbLong_cellCatchFish", WZUITableContainer)
	end
	tbList:setVisible(true)
	self.m_tCellCatchFish = {}

	for i = 1, #tDataList do
		local element, tNewObj = CellCatchFishItem:createElement(index)
		if element and tNewObj then 
			element:setTag(i - 1)
			tNewObj:setGiftBuyMessage(tDataList[i])

			tbList:setCellElement(element)
			table.insert(self.m_tCellCatchFish, tNewObj)
		end
	end
end

--@brief 	更新鱼的数量
function WndHouseInvite:updateFishNum()
	local tDataList 
	if self.m_nCurIndex == 1 then 
		tDataList = self.m_tCatchFishSData
	elseif self.m_nCurIndex == 2 then 
		tDataList = self.m_tCatchFishLData
	end


	for i = 1, #self.m_tCellCatchFish do
		local tData = self.m_tCellCatchFish[i]:getGiftBuyMessage()
		if tData then 
			self.m_tCellCatchFish[i]:resetGiftBuyMessage(tData)
		end
	end
end


--@brief 	显示植树内容
function WndHouseInvite:_showAfforestation()
	WZLog("WndHouseInvite:_showAfforestation")

	if not checkInUnion() then
		MsgBoxManager:showTipBox(LocalStrings.AFFORESTATION_TEXT1[29])
	end

	local tContent = WndAfforestation.m_tContent
	local nTeamScore = self.m_nTeamScore or WndAfforestation.m_nTeamScore
	local nPlayerTimes = self.m_nPlayerTimes or WndAfforestation.m_nPlayerTimes
	local nDailyTeamScore = self.m_nDailyTeamScore or WndAfforestation.m_nDailyTeamScore

	local nRewardScore = nTeamScore
	if nDailyTeamScore >= 0 then --领取后不变化奖励
		nRewardScore = nDailyTeamScore
	end
	local showIndex = 1
	for i=1,#tContent.teamScoreConfig do
		if nRewardScore >= tContent.teamScoreConfig[i] then
			showIndex = i
		else
			break
		end
	end

	local sex = CacheCenter:getPlayerInfo().sex
	local flcReward = GetElement(self.m_root,"flcReward_cellAfforestation1",WZUIFreeListContainer)
	flcReward:removeAll()
	for i=1,#tContent.teamScoreRewards[showIndex] do
		local itemId = sex == 1 and tContent.teamScoreRewards[showIndex][i][2] or tContent.teamScoreRewards[showIndex][i][1]
		local itemNum = tContent.teamScoreRewards[showIndex][i][3]
		local element, tNewObj = CellGoodItem:createElement()
		if element and tNewObj then 
			element:setTag(i - 1)
			element:setScale(0.8)
			tNewObj:setCellGoodLocalId(tonumber(itemId), tonumber(itemNum), 17)
			tNewObj:setItemClickFun(self, self.onClickItem)
			flcReward:pushBack(WZUIContainer:luaTo(element))
		end
	end

	local btnGet = GetElement(self.m_root,"btnGet_cellAfforestation1",WZUIButton)
	local txtGet1 = GetElement(self.m_root,"txtGet1_cellAfforestation1",WZUILabelTTF)
	local txtGet2 = GetElement(self.m_root,"txtGet2_cellAfforestation1",WZUILabelTTF)
	local txtGet3 = GetElement(self.m_root,"txtGet3_cellAfforestation1",WZUILabelTTF)
	if nDailyTeamScore < 0 then
		if nTeamScore >= tContent.teamScoreConfig[1] then --可以领奖
			btnGet:setTouchEnable(true)
		else
			btnGet:setTouchEnable(false)
		end
		txtGet1:setText(LocalStrings.ACTIVE_BTN_GET)
		txtGet2:setText(LocalStrings.ACTIVE_BTN_GET)
		txtGet3:setText(LocalStrings.ACTIVE_BTN_GET)
	elseif nDailyTeamScore >= 0 then
		btnGet:setTouchEnable(false)
		txtGet1:setText(LocalStrings.AFFORESTATION_TEXT1[28])
		txtGet2:setText(LocalStrings.AFFORESTATION_TEXT1[28])
		txtGet3:setText(LocalStrings.AFFORESTATION_TEXT1[28])
	end

	GetElement(self.m_root,"txtTreeNum1_cellAfforestation1",WZUILabelTTF):setText(nTeamScore)
	GetElement(self.m_root,"txtTreeNum2_cellAfforestation1",WZUILabelTTF):setText(nPlayerTimes)

	--背景图
	local showIndex = 1
	for i=1,#tContent.teamScoreConfig do
		if nTeamScore >= tContent.teamScoreConfig[i] then
			showIndex = i
		else
			break
		end
	end
	GetElement(self.m_root,"imgBg1_cellAfforestation1",WZUIImage):setFile("ui/specialBg/zszl_lmzs_"..showIndex..".png")

	--联盟奖励红点
	GetElement(self.m_root,"imgRedDot1_WndHouseInvite",WZUIImage):setVisible(nDailyTeamScore < 0 and nTeamScore >= tContent.teamScoreConfig[1])
end

--@brief 	显示植树排行
function WndHouseInvite:_showAffRank1()
	local flcRank = GetElement(self.m_root,"flcRank_cellAfforestation1",WZUIFreeListContainer)
	flcRank:removeAll()
	for i=1,#self.m_tRankData[3] do
		local tData = self.m_tRankData[3][i]
		local cellAfforestationItem1 = CreateElement("cellAfforestationItem1_WndHouseInvite")
		cellAfforestationItem1 = WZUIContainer:luaTo(cellAfforestationItem1)
		cellAfforestationItem1:setVisible(true)
		local btnHead = GetElement(cellAfforestationItem1,"btnHead_cellAfforestationItem1",WZUIButton)
		btnHead:setTag(tData.playerIds)
		local conHead = GetElement(cellAfforestationItem1,"conHead_cellAfforestationItem1",WZUIContainer)
		conHead:removeAllChildrenWithCleanup(true)
		local headNode, headLua  = CellHead:show(conHead, tData.headIds, tData.faceIds, tData.sexs, nil, nil, tData.vipLevel, tData.headColors)
		headNode:setScale(0.6)
		local txtOtherName = GetElement(cellAfforestationItem1,"txtOtherName_cellAfforestationItem1",WZUILabelTTF)
		txtOtherName:setText(tData.nickname)
		local txtOtherNum = GetElement(cellAfforestationItem1,"txtOtherNum_cellAfforestationItem1",WZUILabelTTF)
		txtOtherNum:setText(tData.points)
		flcRank:pushBack(cellAfforestationItem1)
	end
	flcRank:getMoveElement():setPositionY(flcRank:getMinPosition().y)
end

function WndHouseInvite:onClickAffHead(element)
	local tag = element:getTag()
	WndCheckOther:show(tag)
end

--@brief 	点击大奖预览按钮
function WndHouseInvite:onClickPreview(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tContent = WndAfforestation.m_tContent
	local tData = {}
	tData.title = {}
	for i=1,#tContent.teamScoreConfig do
		local strTitle = string.format(LocalStrings.AFFORESTATION_TEXT1[30], tContent.teamScoreConfig[i])
		table.insert(tData.title, strTitle)
	end
	tData.rewards = tContent.teamScoreRewards
	WndTips:show(element, self.m_root, 92, tData, GlobalMethod:ccp(300, -100), false)
end

--@brief 	显示相应界面
function WndHouseInvite:_showTaskContent()
	local panel_con = GetElement(self.m_root, "panel_con", WZUIContainer)
	panel_con:removeAllChildrenWithCleanup(true)
	panel_con:setVisible(true)
	
	local panel = nil
	if self.m_nWinType == 13 then
		panel = CellNewYearTaskOther:createElement(self.m_tTaskList, 56)
	elseif self.m_nWinType == 18 then
		local otherData = {}
		otherData.itemImg9Bg = "ui/common/frame_lieb_03.png"
		otherData.itemImg9Title = "ui/activity/title_frame_10.png"
		otherData.redPoint = {nil, nil, 247119}
		panel = CellNewYearTaskOther:createElement(self.m_tTaskList, 60, otherData)
	end
	if panel then
		panel_con:addChild(panel)
	end
end

--@brief 	显示植树排行
function WndHouseInvite:_showAffRank2()
	local txtMyScore = GetElement(self.m_root,"txtMyScore_cellAfforestation2",WZUILabelTTF)
	if self.m_tRankOther[2].myPoint <= 0 then
		txtMyScore:setText(LocalStrings.NONE)
	else
		txtMyScore:setText(self.m_tRankOther[2].myPoint)
	end

	local txtMyRank = GetElement(self.m_root,"txtMyRank_cellAfforestation2",WZUILabelTTF)
	if self.m_tRankOther[2].myRanking <= 0 then
		txtMyRank:setText(LocalStrings.NOT_IN_RANKLIST)
	else
		txtMyRank:setText(self.m_tRankOther[2].myRanking)
	end

	local rewardConfig = self.m_tRankOther[2].rewardConfig
	local txtShowCount = GetElement(self.m_root,"txtShowCount_cellAfforestation2",WZUILabelTTF)
	txtShowCount:setText(string.format(LocalStrings.AFFORESTATION_TEXT1[26], rewardConfig[#rewardConfig].rank2))

	local flcRank = GetElement(self.m_root,"flcRank_cellAfforestation2",WZUIFreeListContainer)
	flcRank:removeAll()
	for i=1,#self.m_tRankData[2] do
		local tData = self.m_tRankData[2][i]
		local cellRankItem = CreateElement("cellRankItem_cellAfforestation2")
		cellRankItem = WZUIContainer:luaTo(cellRankItem)
		cellRankItem:setVisible(true)

		local img_rank = GetElement(cellRankItem, "img_rank", WZUIImage)
		local txt_rank = GetElement(cellRankItem,"txt_rank",WZUILabelTTF)
		img_rank:setVisible(false)
		txt_rank:setVisible(false)
		local rank_name = {"ui/common/common_icon_1st_1.png","ui/common/common_icon_2nd_1.png","ui/common/common_icon_3rd_1.png"}
		if tData.ranks <= 3 then
			img_rank:setVisible(true)
			img_rank:setFile(rank_name[tData.ranks])
		else
			txt_rank:setVisible(true)
			txt_rank:setText(tData.ranks)
		end

		local txtName = GetElement(cellRankItem,"txtName",WZUILabelTTF)
		txtName:setText(tData.nickname)

		local strFormat = [[<T C="127,70,26" S="18" P="1">Lv.</T><T C="229,105,22" S="18" P="1">%s </T><T C="127,70,26" S="18" P="1">ID:%s</T>]]
		local ftbId = GetElement(cellRankItem,"ftbId",WZUIFreeTextBox)
		ftbId:setShowText(string.format(strFormat, tData.level, tData.playerIds))

		local txtScore = GetElement(cellRankItem,"txtScore",WZUILabelTTF)
		txtScore:setText(tData.points)

		local rewardConfig = self.m_tRankOther[2].rewardConfig
		local conReward = GetElement(cellRankItem,"conReward",WZUIContainer)
		for j=1,#rewardConfig do
			if tData.ranks >= tonumber(rewardConfig[j].rank1) and tData.ranks <= tonumber(rewardConfig[j].rank2) then
				for k=1, #rewardConfig[j].ids do
					local key = "id_"..rewardConfig[j].ids[k]
					if GDatatab_item[key] then
						local celElement,tLuaObj = CellGoodItem:createElement()
						tLuaObj:setCellGoodLocalId(rewardConfig[j].ids[k], rewardConfig[j].nums[k], 17)
						celElement:setScale(0.8)
						conReward:addChild(celElement)
						tLuaObj:setItemClickFun(self,self.onClickItem)
						celElement:setUseAbsCoordinate(true)
						celElement:setAbsPosition(GlobalMethod:ccp(260-(k-1)*70,40))
					end
				end
			end
		end

		flcRank:pushBack(cellRankItem)
	end
end

--@brief 	领取植树联盟奖励
function WndHouseInvite:onClickAff1Get(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 5, "")
end

--@brief 	显示魔药炼制内容
function WndHouseInvite:_showPotionsRefining()
	local tContent = WndPotionsRefining.m_tContent
	local nSlotNum = tContent.mergeConfig[self.m_nShowTabIndex][1]
	local conSoltList = GetElement(self.m_root,"conSoltList_cellPotions",WZUIContainer)
	conSoltList:removeAllChildrenWithCleanup(true)
	self.m_tSlotElement = {}
	for i=1,nSlotNum do
		local conSlot = CreateElement("conSlot_cellPotions")
		conSlot = WZUIContainer:luaTo(conSlot)
		conSlot:setVisible(true)
		local tCpp = {GlobalMethod:ccp(-0.1+0.2*i,0.5), GlobalMethod:ccp(0.25*i,0.5)}
		conSlot:setRelativePosition(tCpp[self.m_nShowTabIndex])

		local btnSlotAdd = GetElement(conSlot,"btnSlotAdd_cellPotions",WZUIButton)
		btnSlotAdd:setTag(i)
		btnSlotAdd:setVisible(true)
		if self.m_nPushNum >= i then
			local conSlotItem = GetElement(conSlot,"conSlotItem_cellPotions",WZUIContainer)
			local celElement,tLuaObj = CellGoodItem:createElement()
			tLuaObj:setCellGoodLocalId(self.m_tIdCostList2[self.m_nShowTabIndex], 1, 17)
			tLuaObj:_setItemVisible(false)
			tLuaObj:setItemClickFun(self,self.onClickItem)
			celElement:setScale(0.8)
			conSlotItem:addChild(celElement)
			btnSlotAdd:setVisible(false)
		end

		conSoltList:addChild(conSlot)
		table.insert(self.m_tSlotElement, conSlot)
	end

	self.m_tOwnElement = {}
	local flcOwnItem = GetElement(self.m_root,"flcOwnItem_cellPotions",WZUIFreeListContainer)
	flcOwnItem:removeAll()
	local index = 1
	for i=1, #self.m_tIdCostList2 do
		local count = CacheCenter:getPlayerItemCountById(self.m_tIdCostList2[i])
		local basicData = GDatatab_item["id_" .. self.m_tIdCostList2[i]]

		local conOwn = CreateElement("conOwn_cellPotions")
		conOwn = WZUIContainer:luaTo(conOwn)
		conOwn:setVisible(true)

		local conOwnItem = GetElement(conOwn,"conOwnItem_cellPotions",WZUIContainer)
		conOwnItem:removeAllChildrenWithCleanup(true)
		local celElement,tLuaObj = CellGoodItem:createElement()
		tLuaObj:setCellGoodLocalId(self.m_tIdCostList2[i], count, 17)
		tLuaObj:_setItemVisible(false)
		tLuaObj:setItemClickFun(self,self.onClickItem)
		conOwnItem:addChild(celElement)

		local txtOwnName = GetElement(conOwn,"txtOwnName_cellPotions",WZUILabelTTF)
		txtOwnName:setText(basicData.name)
		local nPushNum = self.m_nShowTabIndex == i and self.m_nPushNum or 0
		local txtOwnCount = GetElement(conOwn,"txtOwnCount_cellPotions",WZUILabelTTF)
		txtOwnCount:setText(count - nPushNum)
		local txtOwnPush = GetElement(conOwn,"txtOwnPush_cellPotions",WZUILabelTTF)
		txtOwnPush:setText(LocalStrings.ALCHEMY_TEXT1[13])

		local btnPotionsSel = GetElement(conOwn,"btnPotionsSel_cellPotions",WZUIButton)
		btnPotionsSel:setTag(i)
		local btnPotQuickPush = GetElement(conOwn,"btnPotQuickPush_cellPotions",WZUIButton)
		btnPotQuickPush:setTag(i)

		flcOwnItem:pushBack(conOwn)
		table.insert(self.m_tOwnElement, conOwn)

		if ProjConfig.LANGUAGE == "vn" then
			GetElement(conOwn,"txtOwnPush_cellPotions",WZUILabelTTF):setScale(0.8)
		end
	end

	self:_showPotionsSel()
end

--@brief 	显示整理案件消耗道具
function WndHouseInvite:_showPotionsSel()
	for i = 1, #self.m_tOwnElement do
		local conSel = GetElement(self.m_tOwnElement[i], "conSel_cellPotions", WZUIContainer)
		if i == self.m_nShowTabIndex then 
			conSel:setVisible(true)
		else
			conSel:setVisible(false)
		end
	end
end

--@brief 	点击魔药炼制精炼按钮
function WndHouseInvite:onClickPotionsPool(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	self.m_tGetTimes2 = {}
	self.m_tBigRewardList2 = {}

	local tData3 = {pool = 3}
	local tData4 = {pool = 4}
	local strJson3 = json.encode(tData3)
	local strJson4 = json.encode(tData4)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson3)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson4)
end

--@brief 	点击魔药炼制规则按钮
function WndHouseInvite:onClickPotionsRule(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSingleMapDesc:showInterface(LocalStrings.POTIONS_REFININ_TEXT3)
end

--@brief 	选中魔药炼制药剂
function WndHouseInvite:onClickPotionsSel(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = element:getTag()
	if tag == self.m_nShowTabIndex then
		return
	end
	self.m_nShowTabIndex = tag
	self.m_nPushNum = 0
	self:_showPotionsRefining()
end

--@brief 	选中魔药炼制药剂
function WndHouseInvite:onClickPotQuickPush(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = element:getTag()
	self.m_nShowTabIndex = tag

	local count = CacheCenter:getPlayerItemCountById(self.m_tIdCostList2[self.m_nShowTabIndex])
	local tContent = WndPotionsRefining.m_tContent
	local nSlotNum = tContent.mergeConfig[self.m_nShowTabIndex][1]
	self.m_nPushNum = math.min(count, nSlotNum)
	self:_showPotionsRefining()
end

--@brief 	点击魔药合成
function WndHouseInvite:onClickPotionsGet(element)
	local tContent = WndPotionsRefining.m_tContent
	local nSlotNum = tContent.mergeConfig[self.m_nShowTabIndex][1]
	local count = CacheCenter:getPlayerItemCountById(self.m_tIdCostList2[self.m_nShowTabIndex])

	if self.m_nPushNum < nSlotNum then
		MsgBoxManager:showTipBox(LocalStrings.POTIONS_REFININ_TEXT1[16])
		return
	end

	local tData = {pool = self.m_nShowTabIndex-1}
	local strJson = json.encode(tData)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 5, strJson)
end

--@brief 	关闭抽奖奖励展示界面回调
function WndHouseInvite:onClickPotPushOne(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = element:getTag()
	local tContent = WndPotionsRefining.m_tContent
	local nSlotNum = tContent.mergeConfig[self.m_nShowTabIndex][1]
	local count = CacheCenter:getPlayerItemCountById(self.m_tIdCostList2[self.m_nShowTabIndex])

	if self.m_nPushNum < nSlotNum and self.m_nPushNum < count then
		self.m_nPushNum = self.m_nPushNum + 1
		 
		local conSlotItem = GetElement(self.m_tSlotElement[tag],"conSlotItem_cellPotions",WZUIContainer)
		conSlotItem:removeAllChildrenWithCleanup(true)
		local celElement,tLuaObj = CellGoodItem:createElement()
		tLuaObj:setCellGoodLocalId(self.m_tIdCostList2[self.m_nShowTabIndex], 1, 17)
		tLuaObj:_setItemVisible(false)
		tLuaObj:setItemClickFun(self,self.onClickItem)
		celElement:setScale(0.8)
		conSlotItem:addChild(celElement)
		local btnSlotAdd = GetElement(self.m_tSlotElement[tag],"btnSlotAdd_cellPotions",WZUIButton)
		btnSlotAdd:setVisible(false)

		local count = CacheCenter:getPlayerItemCountById(self.m_tIdCostList2[self.m_nShowTabIndex])
		local txtOwnCount = GetElement(self.m_tOwnElement[self.m_nShowTabIndex],"txtOwnCount_cellPotions",WZUILabelTTF)
		txtOwnCount:setText(count - self.m_nPushNum)
	end
end

--@brief 	显示丹青圣手内容
function WndHouseInvite:_showHolyHand()
	local basicData = GDatatab_item["id_" .. self.m_nCoinId]
	local imgCostItem = GetElement(self.m_root, "imgCostItem_cellHolyHand", WZUIImage)
	imgCostItem:setFile(basicData.icon)

	local txtDesc = GetElement(self.m_root, "txtDesc_cellHolyHand", WZUILabelTTF)
	txtDesc:setText(string.format(LocalStrings.HOLY_HAND_TEXT1[17], WndHolyHand.m_tContent.giftConfig[3]))

	local tcReward = GetElement(self.m_root, "tcReward_cellHolyHand", WZUITableContainer)
	tcReward:cleanTable()

	local reward_ids = self.m_tBigRewardList2[1].reward_ids1
	local reward_nums = self.m_tBigRewardList2[1].reward_nums1
	local tTempData = self.m_tBigRewardList2[1]
	for i = 1, #reward_ids do
		local tabItem = GDatatab_item["id_".. reward_ids[i]]
		local itemInfo = {id = tabItem.id, name=tabItem.name,icon=tabItem.icon,lastTime=reward_nums[i],quality=tabItem.quality,basicInfo=CopyTable(tabItem), index = i}
		local bVisibleLimit = false
		local strLimit = "" 
		if tTempData.leftConfig then 
			itemInfo.leftConfig = tTempData.leftConfig[i]
			bVisibleLimit, strLimit = WndJoinReward:getLimitData(itemInfo.leftConfig.soldNum, itemInfo.leftConfig.limitNum, itemInfo.leftConfig.dailyLimit, itemInfo.leftConfig.dailyBuyNum)
		end
		if tTempData.chooseState then 
			itemInfo.chooseState = tTempData.chooseState[i]
		end
		if tTempData.pool then 
			itemInfo.pool = tTempData.pool
		end
		local nType = 17 
		if tTempData.type then 
			nType = tTempData.type
			itemInfo.rootNode = self.m_root
		end
		local celElement,tCell = CellGoodItem:createElement()
		if celElement and tCell then
			tCell:setCellGoodItem(itemInfo, nType)
			celElement:setTag(i-1)
			-- celElement:setScale(0.75)
			tcReward:setCellElement(celElement)
			if tTempData.chooseState then 
				tCell:setItemClickFun(self,self.onClickItem2)
			else
				tCell:setItemClickFun(self,self.onItemClick)
			end
			if bVisibleLimit then 
				tCell:_addNumLimit(strLimit)
			end
			if itemInfo.chooseState and itemInfo.chooseState == 1 then 
				tCell:setItemSelState(true)
			end
		end
	end
end

--@brief    点击奖励回调
function WndHouseInvite:onClickItem2(tCell, tag, tData)
	WZLog("WndHouseInvite:onClickItem2 ")
	if tData.chooseState and tData.chooseState == 0 then 
		local _, _, bIsSoldOut = WndJoinReward:getLimitData(tData.leftConfig.soldNum, tData.leftConfig.limitNum, tData.leftConfig.dailyLimit, tData.leftConfig.dailyBuyNum)
		if bIsSoldOut then
			local strDesc = ""
			if self.m_nWinType == 15 then
				strDesc = LocalStrings.HOLY_HAND_TEXT1[6]
			elseif self.m_nWinType == 16 then
				if self.m_nCurIndex == 1 then
					strDesc = LocalStrings.DRAGON_BALL_TEXT1[9]
				elseif self.m_nCurIndex == 2 then
					strDesc = LocalStrings.DRAGON_BALL_TEXT1[10]
				end
			elseif self.m_nWinType == 19 then
				if self.m_nCurIndex == 1 then
					strDesc = LocalStrings.PANJIAYUAN_TEXT1[14]
				elseif self.m_nCurIndex == 2 then
					strDesc = LocalStrings.PANJIAYUAN_TEXT1[15]
				end
			end
			MsgBoxManager:showTipBox(string.format(LocalStrings.PLANETSEARCH_TEXT1[18], strDesc, tData.basicInfo.name, tData.lastTime))
			return
		else
			self.m_tClickCell = tCell 
			local tTempData = {}
			local doType = 4
			tTempData.id = tData.index - 1
			tTempData.pool = tData.pool
			
			local stringData = json.encode(tTempData)
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, doType, stringData)
	   end
	elseif tData.chooseState and tData.chooseState == 1 then 
		self.m_tClickCell = tCell 
		local tTempData = {}
		local doType = 4
		tTempData.id = tData.index - 1
		tTempData.pool = tData.pool
			
		local stringData = json.encode(tTempData)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, doType, stringData)
		tCell:setItemSelState(false)
	end
end

--@brief 	选择奖励返回
function WndHouseInvite:chooseReturn(tag, index, status)
	if self.m_root == nil then return end 

	local tTempData = self.m_tBigRewardList2[tag]
	tTempData.chooseState[index] = status
	self.m_tClickCell:updateChooseStateData(status)
	if status == 0 then 
		self.m_tClickCell:setItemSelState(false)
	elseif status == 1 then 
		self.m_tClickCell:setItemSelState(true)
	end
end

--@brief	点击物品弹出对应的tips
function WndHouseInvite:onItemClick(tCell,tag,tData)
	if tData == nil then
	   return
	end
	WndItemInfo:onCloseClick()
	WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData,false)
end

--@brief 	刷新数量
function WndHouseInvite:updatePaintingNum()
	local txtCostNum = GetElement(self.m_root, "txtCostNum_cellHolyHand", WZUILabelTTF)
	if txtCostNum then
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
		txtCostNum:setText(nLightNum)
	end
end

--@brief 	点击获得
function WndHouseInvite:onClickHolyHandGet(element)
	local tContent = WndHolyHand.m_tContent
	local nNum = WndHolyHand.m_tContent.giftConfig[3]
	local count = CacheCenter:getPlayerItemCountById(self.m_nCoinId)

	if count < nNum then
		MsgBoxManager:showTipBox(LocalStrings.HOLY_HAND_TEXT1[20])
		return
	end

	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 6, "")
end

--@brief 	更新寻找龙珠奖励
function WndHouseInvite:_updateDragonBallReward()
	for j = 2, 3 do
		local tcReward = GetElement(self.m_root, "tcReward" .. j .."_cellDragonBall", WZUITableContainer)
		tcReward:cleanTable()
		local reward_ids = self.m_tBigRewardList2[j].reward_ids1
		local reward_nums = self.m_tBigRewardList2[j].reward_nums1
		local tTempData = self.m_tBigRewardList2[j]
		for i = 1, #reward_ids do
			local tabItem = GDatatab_item["id_".. reward_ids[i]]
			local itemInfo = {id = tabItem.id, name=tabItem.name,icon=tabItem.icon,lastTime=reward_nums[i],quality=tabItem.quality,basicInfo=CopyTable(tabItem), index = i}
			local bVisibleLimit = false
			local strLimit = "" 
			if tTempData.leftConfig then 
				itemInfo.leftConfig = tTempData.leftConfig[i]
				bVisibleLimit, strLimit = WndJoinReward:getLimitData(itemInfo.leftConfig.soldNum, itemInfo.leftConfig.limitNum, itemInfo.leftConfig.dailyLimit, itemInfo.leftConfig.dailyBuyNum)
			end
			if tTempData.chooseState then 
				itemInfo.chooseState = tTempData.chooseState[i]
			end
			if tTempData.pool then 
				itemInfo.pool = tTempData.pool
			end
			local nType = 17 
			if tTempData.type then 
				nType = tTempData.type
				itemInfo.rootNode = self.m_root
			end
			local celElement,tCell = CellGoodItem:createElement()
			if celElement and tCell then
				tCell:setCellGoodItem(itemInfo, nType)
				celElement:setTag(i-1)
				celElement:setScale(0.8)
				tcReward:setCellElement(celElement)
				if tTempData.chooseState then 
					tCell:setItemClickFun(self,self.onClickItem2)
				else
					tCell:setItemClickFun(self,self.onItemClick)
				end
				if bVisibleLimit then 
					tCell:_addNumLimit(strLimit)
				end
				if itemInfo.chooseState and itemInfo.chooseState == 1 then 
					tCell:setItemSelState(true)
				end
			end
		end
	end
end

--@brief 	显示寻找龙珠内容
function WndHouseInvite:_showDragonBall()
	local conShow2 = GetElement(self.m_root, "conShow2_cellDragonBall", WZUIContainer)
	local conShow3 = GetElement(self.m_root, "conShow3_cellDragonBall", WZUIContainer)
	local tcReward2 = GetElement(self.m_root, "tcReward2_cellDragonBall", WZUITableContainer)
	local tcReward3 = GetElement(self.m_root, "tcReward3_cellDragonBall", WZUITableContainer)
	local txtTitle = GetElement(self.m_root, "txtTitle_cellDragonBall", WZUILabelTTF)
	local txtDesc = GetElement(self.m_root, "txtDesc_cellDragonBall", WZUILabelTTF)
	local txtBtnGet = GetElement(self.m_root, "txtBtnGet_cellDragonBall", WZUILabelTTF)
	if self.m_nCampTabIndex == 2 then
		conShow2:setVisible(true)
		conShow3:setVisible(false)
		tcReward2:setVisible(true)
		tcReward3:setVisible(false)
		txtTitle:setText(LocalStrings.DRAGON_BALL_TEXT1[17])
		txtDesc:setText(LocalStrings.DRAGON_BALL_TEXT1[19])
		txtBtnGet:setText(LocalStrings.DRAGON_BALL_TEXT1[27])
	elseif self.m_nCampTabIndex == 3 then
		conShow2:setVisible(false)
		conShow3:setVisible(true)
		tcReward2:setVisible(false)
		tcReward3:setVisible(true)
		txtTitle:setText(LocalStrings.DRAGON_BALL_TEXT1[18])
		txtDesc:setText(LocalStrings.DRAGON_BALL_TEXT1[20])
		txtBtnGet:setText(LocalStrings.DRAGON_BALL_TEXT1[28])
	end

end

--@brief 	切换寻找龙珠
function WndHouseInvite:onClickTabDragonBall(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nCampTabIndex = element:getTag()
	self:_showDragonBall()
end

--@brief 	摆放龙珠
function WndHouseInvite:updateDragonBallNum()
	local tContent = WndDragonBall.m_tContent
	local sex = CacheCenter:getPlayerInfo().sex
	local tPos = {}
	tPos[2] = {{0.355022,0.831233},{0.145591,0.431195},{0.587002,0.573408},{0.80276,0.689019},{0.634868,0.177583},{0.301191,0.137485},{0.864884,0.346553}}
	tPos[3] = {{0.355022,0.831233},{0.145591,0.431195},{0.587002,0.573408},{0.80276,0.689019},{0.634868,0.177583},{0.301191,0.137485},{0.864884,0.346553}}
	local tScale = {}
	tScale[2] = {0.6, 0.5, 0.7, 0.65, 0.65, 0.65, 0.6}
	tScale[3] = {0.6, 0.5, 0.7, 0.65, 0.65, 0.65, 0.6}
	for j=2,3 do
		local conPut = GetElement(self.m_root,"conPut"..j.."_cellDragonBall",WZUIContainer)
		conPut:removeAllChildrenWithCleanup(true)
		local tCostItem = {}
		if j == 2 then
			tCostItem = tContent.costNormal[1]
		elseif j == 3 then
			tCostItem = tContent.costGift[1]
		end
		local nItemIdIdx = sex == 0 and 1 or 2
		
		for i = 1, #tCostItem do
			local nItemId = tCostItem[i][nItemIdIdx]
			local nItemCount = CacheCenter:getPlayerItemCountById(nItemId)
			local celElement,tCell = CellGoodItem:createElement()
			tCell:setCellGoodLocalId(nItemId, tCostItem[i][3], 15)
			tCell:setItemClickFun(self, self.onClickItem)
			tCell:_showItemNum()
			tCell:_setItemCountText(nItemCount, tonumber(tCostItem[i][3]))
			if nItemCount < tonumber(tCostItem[i][3]) then
				tCell:setGrayRender(true)
			else
				tCell:setGrayRender(false)
			end
			tCell.m_txtCount:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
			tCell.m_txtCount:setRelativePosition(GlobalMethod:ccp(0.5,0))
			tCell.m_imgItem:setScale(tScale[j][i])
			celElement:setTag(i - 1)
			celElement:setRelativePosition(GlobalMethod:ccp(tPos[j][i][1],tPos[j][i][2]))
			conPut:addChild(celElement)
		end
	end
end

--@brief 	点击寻找龙珠
function WndHouseInvite:onClickDragonBallGet(element)
	local tContent = WndDragonBall.m_tContent
	local sex = CacheCenter:getPlayerInfo().sex

	local tCostItem = {}
	if self.m_nCampTabIndex == 2 then
		tCostItem = tContent.costNormal[1]
	elseif self.m_nCampTabIndex == 3 then
		tCostItem = tContent.costGift[1]
	end
	local nItemIdIdx = sex == 0 and 1 or 2
	for i = 1, #tCostItem do
		local count = CacheCenter:getPlayerItemCountById(tCostItem[i][nItemIdIdx])
		if count < tCostItem[i][3] then
			MsgBoxManager:showTipBox(LocalStrings.DRAGON_BALL_TEXT1[21])
			return
		end
	end

	local bChoosed = false
	local tTempList = self.m_tBigRewardList2[self.m_nCampTabIndex]
	for i=1,#tTempList.chooseState do
		if tTempList.chooseState[i] == 1 then
			bChoosed = true
			break
		end 
	end
	if bChoosed == false then
		MsgBoxManager:showConfirmBox(LocalStrings.DRAGON_BALL_TEXT1[29], self,self.sureDragonBallGet)
		return
	end

	local tData = {pool = self.m_nCampTabIndex - 1}
	local strJson = json.encode(tData)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 5, strJson)
end

--@brief    确定寻找龙珠回调
function WndHouseInvite:sureDragonBallGet(element, btnTag)
    if btnTag == MSGBOXTYPE_CONFIRM then
		local tData = {pool = self.m_nCampTabIndex - 1}
		local strJson = json.encode(tData)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 5, strJson)
    end
end


--@brief 	显示颠倒雷竹阵排行
function WndHouseInvite:_showLeiZhuZhen1()
	local txtMyScore = GetElement(self.m_root,"txtMyScore_cellLeiZhuZhen1",WZUILabelTTF)
	if self.m_tRankOther[2].myPoint <= 0 then
		txtMyScore:setText(LocalStrings.NONE)
	else
		txtMyScore:setText(self.m_tRankOther[2].myPoint)
	end

	local txtMyRank = GetElement(self.m_root,"txtMyRank_cellLeiZhuZhen1",WZUILabelTTF)
	if self.m_tRankOther[2].myRanking <= 0 then
		txtMyRank:setText(LocalStrings.NOT_IN_RANKLIST)
	else
		txtMyRank:setText(self.m_tRankOther[2].myRanking)
	end

	local flcRank = GetElement(self.m_root,"flcRank_cellLeiZhuZhen1",WZUIFreeListContainer)
	flcRank:removeAll()
	for i=1,#self.m_tRankData[2] do
		local tData = self.m_tRankData[2][i]
		local cellRankItem = CreateElement("cellRankItem_cellLeiZhuZhen1")
		cellRankItem = WZUIContainer:luaTo(cellRankItem)
		cellRankItem:setVisible(true)

		local img_rank = GetElement(cellRankItem, "img_rank", WZUIImage)
		local txt_rank = GetElement(cellRankItem,"txt_rank",WZUILabelTTF)
		img_rank:setVisible(false)
		txt_rank:setVisible(false)
		local rank_name = {"ui/common/common_icon_1st_1.png","ui/common/common_icon_2nd_1.png","ui/common/common_icon_3rd_1.png"}
		if tData.ranks <= 3 then
			img_rank:setVisible(true)
			img_rank:setFile(rank_name[tData.ranks])
		else
			txt_rank:setVisible(true)
			txt_rank:setText(tData.ranks)
		end

		local txtName = GetElement(cellRankItem,"txtName",WZUILabelTTF)
		txtName:setText(tData.nickname)

		local strFormat = [[<T C="127,70,26" S="18" P="1">Lv.</T><T C="229,105,22" S="18" P="1">%s </T><T C="127,70,26" S="18" P="1">ID:%s</T>]]
		local ftbId = GetElement(cellRankItem,"ftbId",WZUIFreeTextBox)
		ftbId:setShowText(string.format(strFormat, tData.level, tData.playerIds))

		local txtScore = GetElement(cellRankItem,"txtScore",WZUILabelTTF)
		txtScore:setText(tData.points)

		local rankItemImg = GetElement(self.m_root,"rankItemImg",WZUI9Image)
		rankItemImg:setFile("ui/common/frame_lieb_03.png")
		if tData.ranks == self.m_tRankOther[2].myRanking then
			rankItemImg:setFile("ui/common/frame_lieb_01.png")
		end

		flcRank:pushBack(cellRankItem)
	end
	flcRank:getMoveElement():setPositionY(flcRank:getMinPosition().y)
end

--@brief 	点击组队奖励按钮回调
function WndHouseInvite:onClickTeamReward(element)
	WZLog("WndHouseInvite:onClickTeamReward", self.m_nWinType, self.m_nCurIndex)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local data = nil
	local name = ""

	if self.m_nWinType == 18 then
		if self.m_nCurIndex == 2 then
			data = self.m_tRankOther[2].rewardConfig
			name = LocalStrings.LEIZHUZHEN_TEXT1[28]
		end
	end
	if data then
		WndPvpSegmentReward:showWndUI(data, {titleName = name})
	end
end

--@brief 	显示瓷器碎片数量
function WndHouseInvite:_showPieceNum(tag)
	local nTag = tag or self.m_nCurIndex
	local itemIds = self.m_tPieceItemIds
	local pieceState = self.m_tPieceState[nTag]
	WZLog("WndHouseInvite:_showPieceNum", tostring(tag))
	local conRestoreTips = GetElement(self.m_root, "conRestoreTips" .. nTag .. "_cellAntiqueRestore", WZUIContainer)
	for i = 1, #itemIds do
		local txtItemN = GetElement(conRestoreTips, "txtItemN" .. i .. "_cellAntiqueRestore", WZUILabelTTF)
		local imgPiece = GetElement(conRestoreTips, "imgPiece" .. i .. "_cellAntiqueRestore", WZUIImage)
		local imgRedDot = GetElement(conRestoreTips, "imgRedDot" .. i .. "_cellAntiqueRestore", WZUIImage)
		local nOwnNum = CacheCenter:getPlayerItemCountById(itemIds[i])
		if txtItemN and imgPiece and imgRedDot then 
			txtItemN:setText(GDatatab_item["id_" .. itemIds[i]].name .. ":" .. nOwnNum)
			if pieceState[i] == 0 then 
				imgPiece:setGrayRender(true)
			elseif pieceState[i] == 1 then 
				imgPiece:setGrayRender(false)
			end
			if pieceState[i] == 0 then 
				if nOwnNum > 0 then 
					imgRedDot:setVisible(true)
				else
					imgRedDot:setVisible(false)
				end
			else
				imgRedDot:setVisible(false)
			end
		end
	end

	local bIsCanRestore = true 
	for i = 1, #pieceState do
		if pieceState[i] == 0 then 
			bIsCanRestore = false
			break 
		end
	end
	GetElement(self.m_root, "conBtn_cellAntiqueRestore", WZUIContainer):setVisible(bIsCanRestore)
end

--@brief 	点击碎片回调
function WndHouseInvite:onClickPiece(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local itemIds = self.m_tPieceItemIds
	local nTag = element:getTag()
	local nOwnNum = CacheCenter:getPlayerItemCountById(itemIds[nTag])

	if nOwnNum > 0 then 
		if self.m_tPieceState[self.m_nCurIndex][nTag] == 0 then 
			local tData = {id = self.m_nCurIndex - 1, point = nTag - 1}
			local strJson = json.encode(tData)
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 10, strJson)
		end
	end
end

--@brief 	显示元青花/唐三彩修复奖励
--@param 	tabIndex:右边标签索引
function WndHouseInvite:_showRestoreReward(tabIndex)
	local tbReward = GetElement(self.m_root, "tbReward_cellAntiqueRestore", WZUITableContainer)
	tbReward:cleanTable()

	local nTempIndex = tabIndex or self.m_nCurIndex
	local reward_ids = self.m_tBigRewardList2[nTempIndex].reward_ids
	local reward_nums = self.m_tBigRewardList2[nTempIndex].reward_nums
	local tTempData = self.m_tBigRewardList2[nTempIndex]
	for i = 1, #reward_ids do
		local tabItem = GDatatab_item["id_".. reward_ids[i]]
		local itemInfo = {id = tabItem.id, name=tabItem.name,icon=tabItem.icon,lastTime=reward_nums[i],quality=tabItem.quality,basicInfo=CopyTable(tabItem), index = i}
		local bVisibleLimit = false
		local strLimit = "" 
		if tTempData.leftConfig then 
			itemInfo.leftConfig = tTempData.leftConfig[i]
			bVisibleLimit, strLimit = WndJoinReward:getLimitData(itemInfo.leftConfig.soldNum, itemInfo.leftConfig.limitNum, itemInfo.leftConfig.dailyLimit, itemInfo.leftConfig.dailyBuyNum)
		end
		if tTempData.chooseState then 
			itemInfo.chooseState = tTempData.chooseState[i]
		end
		if tTempData.pool then 
			itemInfo.pool = tTempData.pool
		end
		local nType = 17 
		if tTempData.type then 
			nType = tTempData.type
			itemInfo.rootNode = self.m_root
		end
		local celElement,tCell = CellGoodItem:createElement()
		if celElement and tCell then
			tCell:setCellGoodItem(itemInfo, nType)
			celElement:setTag(i-1)
			celElement:setScale(0.8)
			tbReward:setCellElement(celElement)
			if tTempData.chooseState then 
				tCell:setItemClickFun(self,self.onClickItem2)
			else
				tCell:setItemClickFun(self,self.onItemClick)
			end
			if bVisibleLimit then 
				tCell:_addNumLimit(strLimit)
			end
			if itemInfo.chooseState and itemInfo.chooseState == 1 then 
				tCell:setItemSelState(true)
			end
		end
	end
end

function WndHouseInvite:updatePieceNum()
	local itemIds = self.m_tPieceItemIds
	local pieceState = self.m_tPieceState[self.m_nCurIndex]
	local conRestoreTips = GetElement(self.m_root, "conRestoreTips" .. self.m_nCurIndex .. "_cellAntiqueRestore", WZUIContainer)
	for i = 1, #itemIds do
		local txtItemN = GetElement(conRestoreTips, "txtItemN" .. i .. "_cellAntiqueRestore", WZUILabelTTF)
		local imgPiece = GetElement(conRestoreTips, "imgPiece" .. i .. "_cellAntiqueRestore", WZUIImage)
		local imgRedDot = GetElement(conRestoreTips, "imgRedDot" .. i .. "_cellAntiqueRestore", WZUIImage)
		local nOwnNum = CacheCenter:getPlayerItemCountById(itemIds[i])
		if txtItemN then 
			txtItemN:setText(GDatatab_item["id_" .. itemIds[i]].name .. ":" .. nOwnNum)
		end
		if nOwnNum <= 0 then 
			if imgRedDot then 
				if pieceState[i] and pieceState[i] == 0 then 
					imgRedDot:setVisible(false)
				end
			end
		end
	end
end

-- 采矿按钮调整
function WndHouseInvite:setMiningBtn()
	GetElement(self.m_root,"btn2",WZUIButton):setVisible(false)
	GetElement(self.m_root,"btn3",WZUIButton):setRelativePosition(GlobalMethod:ccp(1.062,0.69))
end

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin----------------------------------------

function WndHouseInvite:_adaptLanguage_vn()
	for i=1,3 do
		local btn = GetElement(self.m_root,"btn"..i,WZUIButton)
		local name = GetElement(btn, "name", WZUILabelTTF)
		name:setDimensions(GlobalMethod:CCSize(130,0))
		name:setScale(0.8)
	end

	if self.m_nWinType == 10 then 
		GetElement(self.m_root, "txtTab1_cellCampFire", WZUILabelTTF):setScale(0.9)
		GetElement(self.m_root, "txtTab1Sel_cellCampFire", WZUILabelTTF):setScale(0.9)
		GetElement(self.m_root, "txtTab2_cellCampFire", WZUILabelTTF):setScale(0.9)
		GetElement(self.m_root, "txtTab2Sel_cellCampFire", WZUILabelTTF):setScale(0.9)
		GetElement(self.m_root, "txtBtn8_WndHouseInvite", WZUILabelTTF):setScale(0.8)
	end
	GetElement(self.m_root, "txtScoreTitle_cellAfforestation2", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.14,0.5))
	GetElement(self.m_root, "txtRankTitle_cellAfforestation2", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.8,0.5))
	GetElement(self.m_root, "txtTreeBelong1_cellAfforestation1", WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root, "txtTreeBelong2_cellAfforestation1", WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root, "txtTitle1_cellAfforestation2", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.09,0.5))
end

-------------------------------------语言适配End----------------------------------------
