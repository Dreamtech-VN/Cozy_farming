--WndShopRank.lua
--@brief	WndShopRank的UI模块
--@date		2020/09/28
--@author	hyx
--@note		购物界面的达人榜


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndShopRank:onEnter(element)
	self.m_root = element
	self:register()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndShopRank:onExit(element)
	self:unregister()
	self:_unInit()
end
function WndShopRank:register()
	self.m_tDefaultType = {11, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 27, 28, 30, 31, 32, 33, 34, 35, 37, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 64, 65, 66, 67, 68, 69, 70, 72, 74, 75, 90}
	if self.m_nRankType == 10 then 
		GlobalGame:getGameEventDispathcer():Add(ShootArrowEvent.ShootArrowEvent_TeamInfoList,self._onArrowTeamInfo,self)
	elseif self.m_nRankType == 12 then 
		GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetArrowResult,self)
	elseif utilsValueInTable(self.m_nRankType, self.m_tDefaultType) then 
		GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetRankResult,self._onRankResult,self)
	elseif self.m_nRankType == 26 then 
		GlobalGame:getGameEventDispathcer():Add(HolidayVillageEvent.HolidayVillageEvent_Rank,self._onHVRankResult,self)
	elseif self.m_nRankType == 36 or self.m_nRankType == 63 or self.m_nRankType == 71 or self.m_nRankType == 73 then 
		GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetRankResult,self._onRankResult,self)
		GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetTaskList,self._onGetTaskInfo,self)
		GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetResult,self._onGetTaskResult,self)
	elseif self.m_nRankType == 38 then 
		GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetRankResult,self.setOrderRankData,self)
	else
		GlobalGame:getGameEventDispathcer():Add(WndPeopleShopEvent.WndPeopleShopEvent_Rank,self._onRankReward,self)
		GlobalGame:getGameEventDispathcer():Add(WndPeopleShopEvent.WndPeopleShopEvent_TreasureRank,self._onTreasureRankReward,self)
		GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_NewYearRankInfo,self._onNewYearRankReward,self)
		GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetRankResult,self._onRankResult,self)
	end
end
function WndShopRank:unregister()
	if self.m_nRankType == 10 then 
		GlobalGame:getGameEventDispathcer():Remove(ShootArrowEvent.ShootArrowEvent_TeamInfoList,self._onArrowTeamInfo,self)
	elseif self.m_nRankType == 12 then 
		GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetArrowResult,self)
	elseif utilsValueInTable(self.m_nRankType, self.m_tDefaultType) then
		GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetRankResult,self._onRankResult,self)
	elseif self.m_nRankType == 26 then
		GlobalGame:getGameEventDispathcer():Remove(HolidayVillageEvent.HolidayVillageEvent_Rank,self._onHVRankResult,self)
	elseif self.m_nRankType == 36 or self.m_nRankType == 63 or self.m_nRankType == 71 or self.m_nRankType == 73 then
		GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetRankResult,self._onRankResult,self)
		GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetTaskList,self._onGetTaskInfo,self)
		GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetResult,self._onGetTaskResult,self)
	elseif self.m_nRankType == 38 then
		GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetRankResult,self.setOrderRankData,self)
	else
		GlobalGame:getGameEventDispathcer():Remove(WndPeopleShopEvent.WndPeopleShopEvent_Rank,self._onRankReward,self)
		GlobalGame:getGameEventDispathcer():Remove(WndPeopleShopEvent.WndPeopleShopEvent_TreasureRank,self._onTreasureRankReward,self)
		GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_NewYearRankInfo,self._onNewYearRankReward,self)
		GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetRankResult,self._onRankResult,self)
	end
end

function WndShopRank:onEnterTransitionDidFinish(element)
	self:initShow()
end

function WndShopRank:initShow()
	local rank_bg = GetElement(self.m_root,"rank_bg",WZUI9Image)
	local titleBgImg = GetElement(self.m_root,"titleBgImg",WZUI9Image)
	local imgBtnClose = GetElement(self.m_root, "imgBtnClose_WndShopRank", WZUIImage)
	--可变的参数
	local txtChangeTitle = GetElement(self.m_root,"txtChangeTitle",WZUILabelTTF)
	txtChangeTitle:setText(LocalStrings.INTEGRATION)
	--次数
	local txtScoreTitle = GetElement(self.m_root,"txtScoreTitle",WZUILabelTTF)
	txtScoreTitle:setText(LocalStrings.KING_RANK_MY_SCORE)
	--展示多少名的
	local showManCountLabel = GetElement(self.m_root,"showManCountLabel",WZUILabelTTF)
	showManCountLabel:setText("")
	--标题
	local txtRankTitleName = GetElement(self.m_root,"txtRankTitleName",WZUILabelTTF)
	txtRankTitleName:setText(LocalStrings.PEOPLE_SHOP_TEXT13)
	self:setTitleAndPos()
	local defaultType = {4, 5, 24, 25, 31, 37, 38, 43, 45}
	if not utilsValueInTable(self.m_nRankType, defaultType) then 
		rank_bg:setFile("ui/common/frame_tc_xiao.png")
	end
	if self.m_nRankType == 1 then
		showManCountLabel:setText(LocalStrings.TREASURE_TEXT19)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_TreasureRankingList( )
	elseif self.m_nRankType == 2 then
		txtRankTitleName:setText(LocalStrings.EVERYDAYBUY_TEXT22)
		showManCountLabel:setText(LocalStrings.EVERYDAYBUY_TEXT25)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_Activity6120RankingList( )
	elseif self.m_nRankType == 3 then
		txtRankTitleName:setText(LocalStrings.NEWYEAR_TEXT28)
		showManCountLabel:setText(string.format(LocalStrings.NEWYEAR_TEXT15, 100))
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 4 or self.m_nRankType == 5 then
		rank_bg:setFile("ui/common/frame_tc_xiao_zi.png")
		titleBgImg:setFile("ui/common/frame_12_1.png")
		imgBtnClose:setFile("ui/common/common_top_btn_guanbi_zi.png")
		showManCountLabel:setText(LocalStrings.TREASURE_TEXT19)
		showManCountLabel:setColor(GlobalMethod:ccc3(255,236,193))
		txtRankTitleName:setText(LocalStrings.RANKLIST_TITLE)
		txtChangeTitle:setText(LocalStrings.BLIND_TEXT8)
		txtScoreTitle:setText(LocalStrings.BLIND_TEXT8..":")
		txtScoreTitle:setColor(GlobalMethod:ccc3(255,236,193))
		GetElement(self.m_root,"txtRankTitle",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,236,193))
		if self.m_nRankType == 5 then
			txtChangeTitle:setText(LocalStrings.INTEGRATION)
			txtScoreTitle:setText(LocalStrings.KING_RANK_MY_SCORE)
			showManCountLabel:setText(LocalStrings.EVERYDAYBUY_TEXT25)
			showManCountLabel:setColor(GlobalMethod:ccc3(255,255,255))
			GetElement(self.m_root,"my_rank",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,255,255))
			GetElement(self.m_root,"my_score",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,255,255))
		end
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 6 then 
		txtRankTitleName:setText(LocalStrings.RANKLIST_TITLE)
		txtChangeTitle:setText(LocalStrings.ACTIVITY_TEXT98)
		txtScoreTitle:setText(LocalStrings.ACTIVITY_TEXT98..":")
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 7 then
		txtRankTitleName:setText(LocalStrings.ACTIVITY_TEXT118)
		showManCountLabel:setText(LocalStrings.EVERYDAYBUY_TEXT25)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 10 then 
		txtRankTitleName:setText(LocalStrings.SHOOTARROW_TEXT6)
		GetElement(self.m_root, "conBottom1_WndShopRank", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "conBottom2_WndShopRank", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "txtRankDesc_WndShopRank", WZUILabelTTF):setText(LocalStrings.SHOOTARROW_TEXT14)
		
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 6, "")
	elseif self.m_nRankType == 11 then 
		GetElement(self.m_root, "conGroup_WndShopRank", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "txtCheck1_WndShopRank", WZUILabelTTF):setText(LocalStrings.SHOOTARROW_TEXT17)
		GetElement(self.m_root, "txtCheckSel1_WndShopRank", WZUILabelTTF):setText(LocalStrings.SHOOTARROW_TEXT17)
		GetElement(self.m_root, "txtCheck2_WndShopRank", WZUILabelTTF):setText(LocalStrings.SHOOTARROW_TEXT18)
		GetElement(self.m_root, "txtCheckSel2_WndShopRank", WZUILabelTTF):setText(LocalStrings.SHOOTARROW_TEXT18)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 12 then 
		txtRankTitleName:setText(LocalStrings.SHOOTARROW_TEXT5)
		GetElement(self.m_root, "conGroup_WndShopRank", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "txtCheck1_WndShopRank", WZUILabelTTF):setText(LocalStrings.DOUBLE_SEVEN_TEXT1)
		GetElement(self.m_root, "txtCheckSel1_WndShopRank", WZUILabelTTF):setText(LocalStrings.DOUBLE_SEVEN_TEXT1)
		GetElement(self.m_root, "txtCheck2_WndShopRank", WZUILabelTTF):setText(LocalStrings.SHOOTARROW_TEXT21)
		GetElement(self.m_root, "txtCheckSel2_WndShopRank", WZUILabelTTF):setText(LocalStrings.SHOOTARROW_TEXT21)
		GetElement(self.m_root, "conTopTitle_WndShopRank", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "conBottom1_WndShopRank", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "conBottom2_WndShopRank", WZUIContainer):setVisible(true)
		self:_showRedDot()
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 1, "")
	elseif self.m_nRankType == 13 then
		txtRankTitleName:setText(LocalStrings.RANKLIST_TITLE)
		showManCountLabel:setText(LocalStrings.EVERYDAYBUY_TEXT25)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 14 then
		txtRankTitleName:setText(LocalStrings.RANKLIST_TITLE)
		showManCountLabel:setText(LocalStrings.EVERYDAYBUY_TEXT25)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 15 then
		txtRankTitleName:setText(LocalStrings.YEARMONSTER_TEXT1[4])
		showManCountLabel:setText(LocalStrings.EVERYDAYBUY_TEXT25)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 16 then
		txtRankTitleName:setText(LocalStrings.NEWYEARWISH_TEXT1[5])
		showManCountLabel:setText(LocalStrings.EVERYDAYBUY_TEXT25)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 17 then 
		GetElement(self.m_root, "conGroup_WndShopRank", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "txtCheck1_WndShopRank", WZUILabelTTF):setText(LocalStrings.BEATENGINEER_TEXT1[9])
		GetElement(self.m_root, "txtCheckSel1_WndShopRank", WZUILabelTTF):setText(LocalStrings.BEATENGINEER_TEXT1[9])
		GetElement(self.m_root, "txtCheck2_WndShopRank", WZUILabelTTF):setText(LocalStrings.BEATENGINEER_TEXT1[10])
		GetElement(self.m_root, "txtCheckSel2_WndShopRank", WZUILabelTTF):setText(LocalStrings.BEATENGINEER_TEXT1[10])
		txtRankTitleName:setText(LocalStrings.BEATENGINEER_TEXT1[9])
		showManCountLabel:setText(LocalStrings.EVERYDAYBUY_TEXT25)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 18 then 
		GetElement(self.m_root, "conGroup_WndShopRank", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "txtCheck1_WndShopRank", WZUILabelTTF):setText(LocalStrings.ALCHEMY_TEXT1[4])
		GetElement(self.m_root, "txtCheckSel1_WndShopRank", WZUILabelTTF):setText(LocalStrings.ALCHEMY_TEXT1[4])
		GetElement(self.m_root, "txtCheck2_WndShopRank", WZUILabelTTF):setText(LocalStrings.ALCHEMY_TEXT1[8])
		GetElement(self.m_root, "txtCheckSel2_WndShopRank", WZUILabelTTF):setText(LocalStrings.ALCHEMY_TEXT1[8])
		showManCountLabel:setText(LocalStrings.EVERYDAYBUY_TEXT25)
		if self.m_nTabIndex == 2 then 
			showManCountLabel:setText(string.format(LocalStrings.NEWYEAR_TEXT15, 20))
		end
		GetElement(self.m_root, "checkGroup_WndShopRank", WZUICheckBoxGroup):setCheckIndex(self.m_nTabIndex - 1)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, self.m_nTabIndex)
	elseif self.m_nRankType == 19 then 
		txtRankTitleName:setText(LocalStrings.BEATMICE_TEXT1[4])
		showManCountLabel:setText(string.format(LocalStrings.NEWYEAR_TEXT15, 100))
		txtChangeTitle:setText(LocalStrings.BEATMICE_TEXT1[6])
		txtScoreTitle:setText(LocalStrings.BEATMICE_TEXT1[6]..":")
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 20 then
		GetElement(self.m_root, "conGroup_WndShopRank", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "txtCheck1_WndShopRank", WZUILabelTTF):setText(LocalStrings.ACTIVITY_TEXT183)
		GetElement(self.m_root, "txtCheckSel1_WndShopRank", WZUILabelTTF):setText(LocalStrings.ACTIVITY_TEXT183)
		GetElement(self.m_root, "txtCheck2_WndShopRank", WZUILabelTTF):setText(LocalStrings.ACTIVITY_TEXT196)
		GetElement(self.m_root, "txtCheckSel2_WndShopRank", WZUILabelTTF):setText(LocalStrings.ACTIVITY_TEXT196)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 21 then 
		txtRankTitleName:setText(LocalStrings.SETCIRCLE_TEXT1[4])
		showManCountLabel:setText(LocalStrings.EVERYDAYBUY_TEXT25)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 22 then 
		GetElement(self.m_root, "conGroup_WndShopRank", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "txtCheck1_WndShopRank", WZUILabelTTF):setText(LocalStrings.GARDEN_TEXT1[4])
		GetElement(self.m_root, "txtCheckSel1_WndShopRank", WZUILabelTTF):setText(LocalStrings.GARDEN_TEXT1[4])
		GetElement(self.m_root, "txtCheck2_WndShopRank", WZUILabelTTF):setText(LocalStrings.GARDEN_TEXT1[5])
		GetElement(self.m_root, "txtCheckSel2_WndShopRank", WZUILabelTTF):setText(LocalStrings.GARDEN_TEXT1[5])
		showManCountLabel:setText(LocalStrings.EVERYDAYBUY_TEXT25)
		GetElement(self.m_root, "checkGroup_WndShopRank", WZUICheckBoxGroup):setCheckIndex(self.m_nTabIndex - 1)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, self.m_nTabIndex)
	elseif self.m_nRankType == 23 then 
		txtRankTitleName:setText(LocalStrings.CAFFEE_TEXT1[3])
		showManCountLabel:setText(LocalStrings.EVERYDAYBUY_TEXT25)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 24 then 
		rank_bg:setFile("ui/common/frame_tc_xiao_zi.png")
		imgBtnClose:setFile("ui/common/common_top_btn_guanbi_zi.png")
		titleBgImg:setFile("ui/common/frame_12_1.png")
		showManCountLabel:setColor(GlobalMethod:ccc3(255,255,255))
		GetElement(self.m_root,"my_rank",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,255,255))
		GetElement(self.m_root,"my_score",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,255,255))
		txtScoreTitle:setColor(GlobalMethod:ccc3(255,236,193))
		GetElement(self.m_root,"txtRankTitle",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,236,193))
		txtRankTitleName:setText(LocalStrings.BOWLING_TEXT1[3])
		showManCountLabel:setText(string.format(LocalStrings.NEWYEAR_TEXT15, 100))
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 25 then 
		rank_bg:setFile("ui/common/frame_tc_xiao_zi.png")
		imgBtnClose:setFile("ui/common/common_top_btn_guanbi_zi.png")
		titleBgImg:setFile("ui/common/frame_12_1.png")
		showManCountLabel:setColor(GlobalMethod:ccc3(255,255,255))
		GetElement(self.m_root,"my_rank",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,255,255))
		GetElement(self.m_root,"my_score",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,255,255))
		txtScoreTitle:setColor(GlobalMethod:ccc3(255,236,193))
		GetElement(self.m_root,"txtRankTitle",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,236,193))
		txtRankTitleName:setText(LocalStrings.YEARPLAYER_TEXT1[3])
		showManCountLabel:setText(string.format(LocalStrings.NEWYEAR_TEXT15, 100))
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 26 then 
		txtRankTitleName:setText(LocalStrings.RANKLIST_TITLE)
		ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_GetRanks(2)
	elseif self.m_nRankType == 27 then 
		txtRankTitleName:setText(LocalStrings.RANKLIST_TITLE)
		showManCountLabel:setText(LocalStrings.EVERYDAYBUY_TEXT25)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 28 then 
		txtRankTitleName:setText(LocalStrings.SECRETTOWER_TEXT1[3])
		showManCountLabel:setText(LocalStrings.EVERYDAYBUY_TEXT25)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 30 then 
		txtRankTitleName:setText(LocalStrings.BILLIARDBALL_TEXT1[3])
		showManCountLabel:setText(LocalStrings.EVERYDAYBUY_TEXT25)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 31 then 
		rank_bg:setFile("ui/common/frame_tc_xiao_zi.png")
		imgBtnClose:setFile("ui/common/common_top_btn_guanbi_zi.png")
		titleBgImg:setFile("ui/common/frame_12_1.png")
		showManCountLabel:setColor(GlobalMethod:ccc3(255,255,255))
		GetElement(self.m_root,"my_rank",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,255,255))
		GetElement(self.m_root,"my_score",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,255,255))
		txtScoreTitle:setColor(GlobalMethod:ccc3(255,236,193))
		GetElement(self.m_root,"txtRankTitle",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,236,193))
		txtRankTitleName:setText(LocalStrings.CRAZY_GASHAPON_TEXT3[1])
		showManCountLabel:setText(string.format(LocalStrings.NEWYEAR_TEXT15, 100))
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 32 then 
		GetElement(self.m_root, "conGroup_WndShopRank", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "txtCheck1_WndShopRank", WZUILabelTTF):setText(LocalStrings.MIDNIGHTDINER_TEXT1[3])
		GetElement(self.m_root, "txtCheckSel1_WndShopRank", WZUILabelTTF):setText(LocalStrings.MIDNIGHTDINER_TEXT1[3])
		GetElement(self.m_root, "txtCheck2_WndShopRank", WZUILabelTTF):setText(LocalStrings.MIDNIGHTDINER_TEXT1[17])
		GetElement(self.m_root, "txtCheckSel2_WndShopRank", WZUILabelTTF):setText(LocalStrings.MIDNIGHTDINER_TEXT1[17])
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 33 then 
		GetElement(self.m_root, "conGroup_WndShopRank", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "txtCheck1_WndShopRank", WZUILabelTTF):setText(LocalStrings.GOPHERBALL_TEXT1[3])
		GetElement(self.m_root, "txtCheckSel1_WndShopRank", WZUILabelTTF):setText(LocalStrings.GOPHERBALL_TEXT1[3])
		GetElement(self.m_root, "txtCheck2_WndShopRank", WZUILabelTTF):setText(LocalStrings.GOPHERBALL_TEXT1[13])
		GetElement(self.m_root, "txtCheckSel2_WndShopRank", WZUILabelTTF):setText(LocalStrings.GOPHERBALL_TEXT1[13])
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 34 then 
		txtRankTitleName:setText(LocalStrings.BEINGIMMORTAL_TEXT1[6])
		showManCountLabel:setText(LocalStrings.EVERYDAYBUY_TEXT25)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 35 then 
		txtRankTitleName:setText(LocalStrings.BEINGIMMORTAL_TEXT1[14])
		showManCountLabel:setText(string.format(LocalStrings.NEWYEAR_TEXT15, 10))
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 2)
	elseif self.m_nRankType == 36 then 
		GetElement(self.m_root, "conGroup_WndShopRank", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "txtCheck1_WndShopRank", WZUILabelTTF):setText(LocalStrings.BEINGIMMORTAL_TEXT1[19])
		GetElement(self.m_root, "txtCheckSel1_WndShopRank", WZUILabelTTF):setText(LocalStrings.BEINGIMMORTAL_TEXT1[19])
		GetElement(self.m_root, "txtCheck2_WndShopRank", WZUILabelTTF):setText(LocalStrings.BEINGIMMORTAL_TEXT1[29])
		GetElement(self.m_root, "txtCheckSel2_WndShopRank", WZUILabelTTF):setText(LocalStrings.BEINGIMMORTAL_TEXT1[29])
		txtRankTitleName:setText(LocalStrings.BEINGIMMORTAL_TEXT1[19])
		GetElement(self.m_root, "conContent_WndShopRank", WZUIContainer):setVisible(false)

		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 3)
		self:_showRedDot()
	elseif self.m_nRankType == 37 then 
		rank_bg:setUseOriginSize(true)
		rank_bg:setFile("ui/specialBg/frame_tc_bcs_d.png")
		GetElement(self.m_root, "img9Bg_WndShopRank", WZUI9Image):setFile("")
		GetElement(self.m_root, "imgTab1_WndShopRank", WZUIImage):setFile("ui/newActivity/common_btn_bcs_06.png")
		GetElement(self.m_root, "imgTab1Sel_WndShopRank", WZUIImage):setFile("ui/newActivity/common_btn_bcs_05.png")
		GetElement(self.m_root, "imgTab2_WndShopRank", WZUIImage):setFile("ui/newActivity/common_btn_bcs_06.png")
		GetElement(self.m_root, "imgTab2Sel_WndShopRank", WZUIImage):setFile("ui/newActivity/common_btn_bcs_05.png")
		GetElement(self.m_root, "txtCheck1_WndShopRank", WZUILabelTTF):setColor(GlobalMethod:ccc3(229, 105, 22))
		GetElement(self.m_root, "txtCheck1_WndShopRank", WZUILabelTTF):setEnableStroke(false)
		GetElement(self.m_root, "txtCheckSel1_WndShopRank", WZUILabelTTF):setColor(GlobalMethod:ccc3(255,236,193))
		GetElement(self.m_root, "txtCheck2_WndShopRank", WZUILabelTTF):setColor(GlobalMethod:ccc3(229, 105, 22))
		GetElement(self.m_root, "txtCheck2_WndShopRank", WZUILabelTTF):setEnableStroke(false)
		GetElement(self.m_root, "txtCheckSel2_WndShopRank", WZUILabelTTF):setColor(GlobalMethod:ccc3(255,236,193))
		GetElement(self.m_root, "conGroup_WndShopRank", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "txtCheck1_WndShopRank", WZUILabelTTF):setText(LocalStrings.WORSHIPGOD_TEXT1[7])
		GetElement(self.m_root, "txtCheckSel1_WndShopRank", WZUILabelTTF):setText(LocalStrings.WORSHIPGOD_TEXT1[7])
		GetElement(self.m_root, "txtCheck2_WndShopRank", WZUILabelTTF):setText(LocalStrings.WORSHIPGOD_TEXT1[14])
		GetElement(self.m_root, "txtCheckSel2_WndShopRank", WZUILabelTTF):setText(LocalStrings.WORSHIPGOD_TEXT1[14])
		txtScoreTitle:setColor(GlobalMethod:ccc3(255,236,193))
		GetElement(self.m_root,"txtRankTitle",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,236,193))
		showManCountLabel:setColor(GlobalMethod:ccc3(255,255,255))
		GetElement(self.m_root,"my_rank",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,255,255))
		GetElement(self.m_root,"my_score",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,255,255))
		GetElement(self.m_root, "btnClose_WndShopRank", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.952,0.938))
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 38 then 
		rank_bg:setUseOriginSize(true)
		rank_bg:setScale(1.02)
		rank_bg:setFile("ui/holidayVillage/frame_tc_xhdd_dd.png")
		GetElement(self.m_root, "img9Bg_WndShopRank", WZUI9Image):setFile("")
		txtRankTitleName:setText(LocalStrings.HOLIDAYVILLAGE_TEXT3[3])
		txtRankTitleName:setRelativePosition(GlobalMethod:ccp(0.5,0.928))
		showManCountLabel:setText(LocalStrings.EVERYDAYBUY_TEXT25)
		GetElement(self.m_root, "conOtherTop_WndShopRank", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "conOtherTop_WndShopRank", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5,0.928))
		GetElement(self.m_root, "btnClose_WndShopRank", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.964,0.928))
		ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_GetFlowerTycoonRanks()
	elseif self.m_nRankType == 39 then 
		txtRankTitleName:setText(LocalStrings.RANKLIST_TITLE)
		showManCountLabel:setText(LocalStrings.EVERYDAYBUY_TEXT25)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 40 then 
		txtRankTitleName:setText(LocalStrings.SPRINGOUTING_TEXT1[17])
		showManCountLabel:setText(LocalStrings.EVERYDAYBUY_TEXT25)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 41 then 
		GetElement(self.m_root, "conGroup_WndShopRank", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "txtCheck1_WndShopRank", WZUILabelTTF):setText(LocalStrings.BEATBALLOON_TEXT1[2])
		GetElement(self.m_root, "txtCheckSel1_WndShopRank", WZUILabelTTF):setText(LocalStrings.BEATBALLOON_TEXT1[2])
		GetElement(self.m_root, "txtCheck2_WndShopRank", WZUILabelTTF):setText(LocalStrings.BEATBALLOON_TEXT1[15])
		GetElement(self.m_root, "txtCheckSel2_WndShopRank", WZUILabelTTF):setText(LocalStrings.BEATBALLOON_TEXT1[15])
		txtRankTitleName:setText(LocalStrings.BEATBALLOON_TEXT1[2])

		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 2)
	elseif self.m_nRankType == 42 then 
		GetElement(self.m_root, "conGroup_WndShopRank", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "txtCheck1_WndShopRank", WZUILabelTTF):setText(LocalStrings.SEAFARROAD_TEXT1[2])
		GetElement(self.m_root, "txtCheckSel1_WndShopRank", WZUILabelTTF):setText(LocalStrings.SEAFARROAD_TEXT1[2])
		GetElement(self.m_root, "txtCheck2_WndShopRank", WZUILabelTTF):setText(LocalStrings.SEAFARROAD_TEXT1[17])
		GetElement(self.m_root, "txtCheckSel2_WndShopRank", WZUILabelTTF):setText(LocalStrings.SEAFARROAD_TEXT1[17])
		txtRankTitleName:setText(LocalStrings.SEAFARROAD_TEXT1[2])

		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 43 then 
		rank_bg:setUseOriginSize(true)
		rank_bg:setFile("ui/specialBg/frame_tc_ptds_d.png")
		rank_bg:setRelativePosition(GlobalMethod:ccp(0.5, 0.52))
		titleBgImg:setFile("ui/common/frame_12_3.png")
		imgBtnClose:setFile("ui/common/common_top_btn_guanbi_l.png")
		GetElement(self.m_root, "img9Bg_WndShopRank", WZUI9Image):setFile("")
		txtRankTitleName:setText(LocalStrings.CLIMBTREE_TEXT1[10])
		txtRankTitleName:setEnableStroke(false)
		txtRankTitleName:setColor(GlobalMethod:ccc3(255,255,255))

		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 44 then 
		GetElement(self.m_root, "conGroup_WndShopRank", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "txtCheck1_WndShopRank", WZUILabelTTF):setText(LocalStrings.SUMMERSURF_TEXT1[4])
		GetElement(self.m_root, "txtCheckSel1_WndShopRank", WZUILabelTTF):setText(LocalStrings.SUMMERSURF_TEXT1[4])
		GetElement(self.m_root, "txtCheck2_WndShopRank", WZUILabelTTF):setText(LocalStrings.SUMMERSURF_TEXT1[10])
		GetElement(self.m_root, "txtCheckSel2_WndShopRank", WZUILabelTTF):setText(LocalStrings.SUMMERSURF_TEXT1[10])
		txtRankTitleName:setText(LocalStrings.SUMMERSURF_TEXT1[2])

		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 45 then 
		rank_bg:setFile("ui/specialBg/frame_tc_xxts_slale9.png")
		rank_bg:setScale(1.02)
		titleBgImg:setFile("ui/common/frame_12_1.png")
		imgBtnClose:setFile("ui/common/common_top_btn_guanbi_zi.png")
		txtRankTitleName:setText(LocalStrings.PLANETSEARCH_TEXT1[3])
		showManCountLabel:setText(LocalStrings.EVERYDAYBUY_TEXT25)
		txtRankTitleName:setStrokeColor(GlobalMethod:ccc3(0,112,202))
		txtRankTitleName:setColor(GlobalMethod:ccc3(255,255,255))
		showManCountLabel:setColor(GlobalMethod:ccc3(255,255,255))
		GetElement(self.m_root,"my_rank",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,255,255))
		GetElement(self.m_root,"my_score",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,255,255))
		txtScoreTitle:setColor(GlobalMethod:ccc3(255,236,193))
		GetElement(self.m_root,"txtRankTitle",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,236,193))
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 46 then 
		GetElement(self.m_root, "conGroup_WndShopRank", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "txtCheck1_WndShopRank", WZUILabelTTF):setText(LocalStrings.TRAMPOLINE_TEXT1[17])
		GetElement(self.m_root, "txtCheckSel1_WndShopRank", WZUILabelTTF):setText(LocalStrings.TRAMPOLINE_TEXT1[17])
		GetElement(self.m_root, "txtCheck2_WndShopRank", WZUILabelTTF):setText(LocalStrings.TRAMPOLINE_TEXT1[18])
		GetElement(self.m_root, "txtCheckSel2_WndShopRank", WZUILabelTTF):setText(LocalStrings.TRAMPOLINE_TEXT1[18])
		txtRankTitleName:setText(LocalStrings.TRAMPOLINE_TEXT1[17])

		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 47 then 
		GetElement(self.m_root, "conGroup_WndShopRank", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "txtCheck1_WndShopRank", WZUILabelTTF):setText(LocalStrings.GOLFBALL_TEXT1[17])
		GetElement(self.m_root, "txtCheckSel1_WndShopRank", WZUILabelTTF):setText(LocalStrings.GOLFBALL_TEXT1[17])
		GetElement(self.m_root, "txtCheck2_WndShopRank", WZUILabelTTF):setText(LocalStrings.GOLFBALL_TEXT1[18])
		GetElement(self.m_root, "txtCheckSel2_WndShopRank", WZUILabelTTF):setText(LocalStrings.GOLFBALL_TEXT1[18])
		txtRankTitleName:setText(LocalStrings.GOLFBALL_TEXT1[17])

		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 51 then 
		GetElement(self.m_root, "conGroup_WndShopRank", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "txtCheck1_WndShopRank", WZUILabelTTF):setText(LocalStrings.GOLD_MINER_TEXT1[13])
		GetElement(self.m_root, "txtCheckSel1_WndShopRank", WZUILabelTTF):setText(LocalStrings.GOLD_MINER_TEXT1[13])
		GetElement(self.m_root, "txtCheck2_WndShopRank", WZUILabelTTF):setText(LocalStrings.GOLFBALL_TEXT1[18])
		GetElement(self.m_root, "txtCheckSel2_WndShopRank", WZUILabelTTF):setText(LocalStrings.GOLFBALL_TEXT1[18])
		txtRankTitleName:setText(LocalStrings.GOLD_MINER_TEXT1[13])
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 48 then 
		txtRankTitleName:setText(LocalStrings.RANKLIST_TITLE)
		txtChangeTitle:setText(LocalStrings.WISHING_BOTTLE_TEXT1[12])
		txtScoreTitle:setText(LocalStrings.WISHING_BOTTLE_TEXT1[13]..":")
		showManCountLabel:setText(LocalStrings.EVERYDAYBUY_TEXT25)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 49 then 
		txtRankTitleName:setText(LocalStrings.DETECTIVE_TEXT1[3])
		showManCountLabel:setText(string.format(LocalStrings.NEWYEAR_TEXT15,100))
		txtChangeTitle:setText(LocalStrings.DETECTIVE_TEXT1[8])
		txtScoreTitle:setText(LocalStrings.DETECTIVE_TEXT1[8] .. ":")
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 50 then 
		txtRankTitleName:setText(LocalStrings.GONGANDDRUM_TEXT1[3])
		showManCountLabel:setText(string.format(LocalStrings.NEWYEAR_TEXT15,100))
		txtChangeTitle:setText(LocalStrings.GONGANDDRUM_TEXT1[9])
		txtScoreTitle:setText(LocalStrings.GONGANDDRUM_TEXT1[9] .. ":")
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 52 then 
		txtRankTitleName:setText(LocalStrings.DEEPSEA_TEXT1[3])
		showManCountLabel:setText(string.format(LocalStrings.NEWYEAR_TEXT15,100))
		txtChangeTitle:setText(LocalStrings.DEEPSEA_TEXT1[9])
		txtScoreTitle:setText(LocalStrings.DEEPSEA_TEXT1[9] .. ":")
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 53 then 
		txtRankTitleName:setText(LocalStrings.ZONGZI_TEXT1[29])
		txtChangeTitle:setText(LocalStrings.ZONGZI_TEXT1[30])
		txtScoreTitle:setText(LocalStrings.ZONGZI_TEXT1[30] .. ":")
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 54 then 
		GetElement(self.m_root, "conGroup_WndShopRank", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "txtCheck1_WndShopRank", WZUILabelTTF):setText(LocalStrings.TRAMPOLINE_TEXT1[17])
		GetElement(self.m_root, "txtCheckSel1_WndShopRank", WZUILabelTTF):setText(LocalStrings.TRAMPOLINE_TEXT1[17])
		GetElement(self.m_root, "txtCheck2_WndShopRank", WZUILabelTTF):setText(LocalStrings.TRAMPOLINE_TEXT1[18])
		GetElement(self.m_root, "txtCheckSel2_WndShopRank", WZUILabelTTF):setText(LocalStrings.TRAMPOLINE_TEXT1[18])
		txtRankTitleName:setText(LocalStrings.TRAMPOLINE_TEXT1[17])
		showManCountLabel:setText(string.format(LocalStrings.NEWYEAR_TEXT15,100))
		txtChangeTitle:setText(LocalStrings.CHESS_ACTIVITY_TEXT1[11])
		txtScoreTitle:setText(LocalStrings.CHESS_ACTIVITY_TEXT1[11] .. ":")
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 55 then 
		rank_bg:setFile("ui/common/frame_tc_xiao_zi.png")
		titleBgImg:setFile("ui/common/frame_12_1.png")
		imgBtnClose:setFile("ui/common/common_top_btn_guanbi_zi.png")
		showManCountLabel:setColor(GlobalMethod:ccc3(255,255,255))
		GetElement(self.m_root,"my_rank",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,255,255))
		GetElement(self.m_root,"my_score",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,255,255))
		txtScoreTitle:setColor(GlobalMethod:ccc3(255,236,193))
		GetElement(self.m_root,"txtRankTitle",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,236,193))
		txtRankTitleName:setText(LocalStrings.HOTBASKETBALL_TEXT1[3])
		showManCountLabel:setText(string.format(LocalStrings.NEWYEAR_TEXT15,100))
		txtChangeTitle:setText(LocalStrings.HOTBASKETBALL_TEXT1[18])
		txtScoreTitle:setText(LocalStrings.HOTBASKETBALL_TEXT1[18] .. ":")
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 56 then 
		txtRankTitleName:setText(LocalStrings.AUTUMNCAMP_TEXT1[3])
		showManCountLabel:setText(string.format(LocalStrings.NEWYEAR_TEXT15,100))
		txtChangeTitle:setText(LocalStrings.AUTUMNCAMP_TEXT1[9])
		txtScoreTitle:setText(LocalStrings.AUTUMNCAMP_TEXT1[9] .. ":")
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 57 then 
		txtRankTitleName:setText(LocalStrings.RANKLIST_TITLE)
		showManCountLabel:setText(string.format(LocalStrings.NEWYEAR_TEXT15,100))
		txtChangeTitle:setText(LocalStrings.FLYKITES_TEXT1[12])
		txtScoreTitle:setText(LocalStrings.FLYKITES_TEXT1[13] .. ":")
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 58 then 
		txtRankTitleName:setText(LocalStrings.THROWPOT_TEXT1[3])
		showManCountLabel:setText(string.format(LocalStrings.NEWYEAR_TEXT15,100))
		txtChangeTitle:setText(LocalStrings.THROWPOT_TEXT1[9])
		txtScoreTitle:setText(LocalStrings.THROWPOT_TEXT1[9] .. ":")
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 59 then 
		rank_bg:setFile("ui/common/frame_tc_xiao_lan.png")
		titleBgImg:setFile("ui/common/frame_12_4.png")
		imgBtnClose:setFile("ui/newvip/common_top_btn_guanbi_lan.png")
		showManCountLabel:setColor(GlobalMethod:ccc3(255,255,255))
		GetElement(self.m_root,"my_rank",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,255,255))
		GetElement(self.m_root,"my_score",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,255,255))
		txtScoreTitle:setColor(GlobalMethod:ccc3(255,227,116))
		GetElement(self.m_root,"txtRankTitle",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,227,116))
		txtRankTitleName:setText(LocalStrings.CATCHFISH_TEXT1[3])
		showManCountLabel:setText(string.format(LocalStrings.NEWYEAR_TEXT15,100))
		txtChangeTitle:setText(LocalStrings.CATCHFISH_TEXT1[18])
		txtScoreTitle:setText(LocalStrings.CATCHFISH_TEXT1[18] .. ":")
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 60 then 
		txtRankTitleName:setText(LocalStrings.BIKEMATCH_TEXT1[3])
		showManCountLabel:setText(string.format(LocalStrings.NEWYEAR_TEXT15,100))
		txtChangeTitle:setText(LocalStrings.BIKEMATCH_TEXT1[9])
		txtScoreTitle:setText(LocalStrings.BIKEMATCH_TEXT1[9] .. ":")
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 61 then 
		txtRankTitleName:setText(LocalStrings.LASHTOP_TEXT1[12])
		txtChangeTitle:setText(LocalStrings.LASHTOP_TEXT1[13])
		txtScoreTitle:setText(LocalStrings.LASHTOP_TEXT1[14] .. ":")
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 62 then 
		txtRankTitleName:setText(LocalStrings.KICKING_BIRDIE_TEXT1[16])
		txtChangeTitle:setText(LocalStrings.KICKING_BIRDIE_TEXT1[17])
		txtScoreTitle:setText(LocalStrings.KICKING_BIRDIE_TEXT1[18] .. ":")
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 63 then 
		GetElement(self.m_root, "conGroup_WndShopRank", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "txtCheck1_WndShopRank", WZUILabelTTF):setText(LocalStrings.KICKING_BIRDIE_TEXT1[19])
		GetElement(self.m_root, "txtCheckSel1_WndShopRank", WZUILabelTTF):setText(LocalStrings.KICKING_BIRDIE_TEXT1[19])
		GetElement(self.m_root, "txtCheck2_WndShopRank", WZUILabelTTF):setText(LocalStrings.KICKING_BIRDIE_TEXT1[20])
		GetElement(self.m_root, "txtCheckSel2_WndShopRank", WZUILabelTTF):setText(LocalStrings.KICKING_BIRDIE_TEXT1[20])
		txtRankTitleName:setText(LocalStrings.KICKING_BIRDIE_TEXT1[19])
		GetElement(self.m_root, "conContent_WndShopRank", WZUIContainer):setVisible(false)

		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 3)
		self:_showRedDot()
	elseif self.m_nRankType == 64 then 
		rank_bg:setFile("ui/common/frame_tc_xiao_lan.png")
		titleBgImg:setFile("ui/common/frame_12_4.png")
		imgBtnClose:setFile("ui/newvip/common_top_btn_guanbi_lan.png")
		showManCountLabel:setColor(GlobalMethod:ccc3(255,255,255))
		GetElement(self.m_root,"my_rank",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,255,255))
		GetElement(self.m_root,"my_score",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,255,255))
		txtScoreTitle:setColor(GlobalMethod:ccc3(255,227,116))
		GetElement(self.m_root,"txtRankTitle",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,227,116))
		txtRankTitleName:setText(LocalStrings.MAGIC_CLASSROOM_TEXT1[15])
		txtChangeTitle:setText(LocalStrings.MAGIC_CLASSROOM_TEXT1[16])
		txtScoreTitle:setText(LocalStrings.MAGIC_CLASSROOM_TEXT1[17] .. ":")
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 65 then 
		rank_bg:setFile("ui/common/frame_tc_xiao_lan.png")
		titleBgImg:setFile("ui/common/frame_12_4.png")
		imgBtnClose:setFile("ui/newvip/common_top_btn_guanbi_lan.png")
		showManCountLabel:setColor(GlobalMethod:ccc3(255,255,255))
		GetElement(self.m_root,"my_rank",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,255,255))
		GetElement(self.m_root,"my_score",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,255,255))
		txtScoreTitle:setColor(GlobalMethod:ccc3(255,227,116))
		GetElement(self.m_root,"txtRankTitle",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,227,116))
		txtRankTitleName:setText(LocalStrings.MAKE_SHOWMAN_TEXT1[15])
		txtChangeTitle:setText(LocalStrings.MAKE_SHOWMAN_TEXT1[16])
		txtScoreTitle:setText(LocalStrings.MAKE_SHOWMAN_TEXT1[17] .. ":")
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 66 then 
		txtRankTitleName:setText(LocalStrings.PIANIST_TEXT1[6])
		txtChangeTitle:setText(LocalStrings.PIANIST_TEXT1[15])
		txtScoreTitle:setText(LocalStrings.PIANIST_TEXT1[16] .. ":")
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 67 then 
		txtRankTitleName:setText(LocalStrings.CERAMIC_WORKSHOP_TEXT1[13])
		txtChangeTitle:setText(LocalStrings.CERAMIC_WORKSHOP_TEXT1[17])
		txtScoreTitle:setText(LocalStrings.CERAMIC_WORKSHOP_TEXT1[18] .. ":")
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 68 then 
		rank_bg:setFile("ui/common/frame_tc_xiao_lan.png")
		titleBgImg:setFile("ui/common/frame_12_4.png")
		imgBtnClose:setFile("ui/newvip/common_top_btn_guanbi_lan.png")
		showManCountLabel:setColor(GlobalMethod:ccc3(255,255,255))
		GetElement(self.m_root,"my_rank",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,255,255))
		GetElement(self.m_root,"my_score",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,255,255))
		txtScoreTitle:setColor(GlobalMethod:ccc3(255,227,116))
		GetElement(self.m_root,"txtRankTitle",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,227,116))
		txtRankTitleName:setText(LocalStrings.WEIGHTLIFTING_TEXT1[7])
		txtChangeTitle:setText(LocalStrings.WEIGHTLIFTING_TEXT1[8])
		txtScoreTitle:setText(LocalStrings.WEIGHTLIFTING_TEXT1[15] .. ":")
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 69 then 
		rank_bg:setFile("ui/common/frame_tc_xiao_lan.png")
		titleBgImg:setFile("ui/common/frame_12_4.png")
		imgBtnClose:setFile("ui/newvip/common_top_btn_guanbi_lan.png")
		showManCountLabel:setColor(GlobalMethod:ccc3(255,255,255))
		GetElement(self.m_root,"my_rank",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,255,255))
		GetElement(self.m_root,"my_score",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,255,255))
		txtScoreTitle:setColor(GlobalMethod:ccc3(255,227,116))
		txtScoreTitle:setRelativePosition(GlobalMethod:ccp(0.12,0.5))
		GetElement(self.m_root,"txtRankTitle",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,227,116))
		txtRankTitleName:setText(LocalStrings.ARCTIC_EXPLORATION_TEXT1[13])
		txtChangeTitle:setText(LocalStrings.ARCTIC_EXPLORATION_TEXT1[14])
		txtScoreTitle:setText(LocalStrings.ARCTIC_EXPLORATION_TEXT1[15] .. ":")
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 70 then 
		txtRankTitleName:setText(LocalStrings.BUILDING_BLOCKS_TEXT1[6])
		txtChangeTitle:setText(LocalStrings.BUILDING_BLOCKS_TEXT1[13])
		txtScoreTitle:setText(LocalStrings.BUILDING_BLOCKS_TEXT1[14] .. ":")
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 71 then 
		GetElement(self.m_root, "conGroup_WndShopRank", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "txtCheck1_WndShopRank", WZUILabelTTF):setText(LocalStrings.BUILDING_BLOCKS_TEXT1[5])
		GetElement(self.m_root, "txtCheckSel1_WndShopRank", WZUILabelTTF):setText(LocalStrings.BUILDING_BLOCKS_TEXT1[5])
		GetElement(self.m_root, "txtCheck2_WndShopRank", WZUILabelTTF):setText(LocalStrings.BUILDING_BLOCKS_TEXT1[9])
		GetElement(self.m_root, "txtCheckSel2_WndShopRank", WZUILabelTTF):setText(LocalStrings.BUILDING_BLOCKS_TEXT1[9])
		txtRankTitleName:setText(LocalStrings.BUILDING_BLOCKS_TEXT1[5])
		GetElement(self.m_root, "conContent_WndShopRank", WZUIContainer):setVisible(false)

		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 3)
		self:_showRedDot()
	elseif self.m_nRankType == 72 then
		txtRankTitleName:setText(LocalStrings.CASTING_MASTER_ACTIVITY_TEXT1[6])
		txtChangeTitle:setText(LocalStrings.CASTING_MASTER_ACTIVITY_TEXT1[9])
		txtScoreTitle:setText(LocalStrings.CASTING_MASTER_ACTIVITY_TEXT1[10] .. ":")
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 73 then 
		GetElement(self.m_root, "conGroup_WndShopRank", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "txtCheck1_WndShopRank", WZUILabelTTF):setText(LocalStrings.CASTING_MASTER_ACTIVITY_TEXT1[11])
		GetElement(self.m_root, "txtCheckSel1_WndShopRank", WZUILabelTTF):setText(LocalStrings.CASTING_MASTER_ACTIVITY_TEXT1[11])
		GetElement(self.m_root, "txtCheck2_WndShopRank", WZUILabelTTF):setText(LocalStrings.CASTING_MASTER_ACTIVITY_TEXT1[12])
		GetElement(self.m_root, "txtCheckSel2_WndShopRank", WZUILabelTTF):setText(LocalStrings.CASTING_MASTER_ACTIVITY_TEXT1[12])
		txtRankTitleName:setText(LocalStrings.CASTING_MASTER_ACTIVITY_TEXT1[11])
		GetElement(self.m_root, "conContent_WndShopRank", WZUIContainer):setVisible(false)

		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 3)
		self:_showRedDot()
	elseif self.m_nRankType == 74 then 
		txtRankTitleName:setText(LocalStrings.BOATING_LAKE_TEXT1[5])
		txtChangeTitle:setText(LocalStrings.BOATING_LAKE_TEXT1[13])
		txtScoreTitle:setText(LocalStrings.BOATING_LAKE_TEXT1[14] .. ":")
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 75 then 
		rank_bg:setFile("ui/common/frame_tc_xiao_lan.png")
		titleBgImg:setFile("ui/common/frame_12_4.png")
		imgBtnClose:setFile("ui/newvip/common_top_btn_guanbi_lan.png")
		showManCountLabel:setColor(GlobalMethod:ccc3(255,255,255))
		GetElement(self.m_root,"my_rank",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,255,255))
		GetElement(self.m_root,"my_score",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,255,255))
		txtScoreTitle:setColor(GlobalMethod:ccc3(255,227,116))
		GetElement(self.m_root,"txtRankTitle",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,227,116))
		txtScoreTitle:setRelativePosition(GlobalMethod:ccp(0.12,0.5))
		txtRankTitleName:setText(LocalStrings.BLOW_BUBBLES_TEXT1[6])
		txtChangeTitle:setText(LocalStrings.BLOW_BUBBLES_TEXT1[11])
		txtScoreTitle:setText(LocalStrings.BLOW_BUBBLES_TEXT1[15] .. ":")
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
	elseif self.m_nRankType == 90 then 
		if self.m_tOtherData and self.m_tOtherData.rankBg then 
			rank_bg:setFile(self.m_tOtherData.rankBg)
		end
		if self.m_tOtherData and self.m_tOtherData.titleBg then 
			titleBgImg:setFile(self.m_tOtherData.titleBg)
		end
		if self.m_tOtherData and self.m_tOtherData.imgBtnClose then 
			imgBtnClose:setFile(self.m_tOtherData.imgBtnClose)
		end
		if self.m_tOtherData and self.m_tOtherData.countLabelColor then 
			showManCountLabel:setColor(self.m_tOtherData.countLabelColor)
		end
		if self.m_tOtherData and self.m_tOtherData.myRankColor then 
			GetElement(self.m_root,"my_rank",WZUILabelTTF):setColor(self.m_tOtherData.myRankColor)
		end
		if self.m_tOtherData and self.m_tOtherData.myScoreColor then 
			GetElement(self.m_root,"my_score",WZUILabelTTF):setColor(self.m_tOtherData.myScoreColor)
		end
		if self.m_tOtherData and self.m_tOtherData.scoreTitleColor then 
			txtScoreTitle:setColor(self.m_tOtherData.scoreTitleColor)
		end
		if self.m_tOtherData and self.m_tOtherData.rankTitleColor then 
			GetElement(self.m_root,"txtRankTitle",WZUILabelTTF):setColor(self.m_tOtherData.rankTitleColor)
		end
		if self.m_tOtherData and self.m_tOtherData.strRankTitleName then 
			txtRankTitleName:setText(self.m_tOtherData.strRankTitleName)
		end
		if self.m_tOtherData and self.m_tOtherData.strCountLabel then 
			showManCountLabel:setText(self.m_tOtherData.strCountLabel)
		end
		if self.m_tOtherData and self.m_tOtherData.strChangeTitle then 
			txtChangeTitle:setText(self.m_tOtherData.strChangeTitle)
		end
		if self.m_tOtherData and self.m_tOtherData.strScoreTitle then 
			txtScoreTitle:setText(self.m_tOtherData.strScoreTitle)
		end

		if self.m_tOtherData and self.m_tOtherData.bConGroupVisible then 
			GetElement(self.m_root, "conGroup_WndShopRank", WZUIContainer):setVisible(self.m_tOtherData.bConGroupVisible)
			GetElement(self.m_root, "conContent_WndShopRank", WZUIContainer):setVisible(false)
		end
		if self.m_tOtherData and self.m_tOtherData.tTabStrList then 
			GetElement(self.m_root, "txtCheck1_WndShopRank", WZUILabelTTF):setText(self.m_tOtherData.tTabStrList[1])
			GetElement(self.m_root, "txtCheckSel1_WndShopRank", WZUILabelTTF):setText(self.m_tOtherData.tTabStrList[1])
			GetElement(self.m_root, "txtCheck2_WndShopRank", WZUILabelTTF):setText(self.m_tOtherData.tTabStrList[2])
			GetElement(self.m_root, "txtCheckSel2_WndShopRank", WZUILabelTTF):setText(self.m_tOtherData.tTabStrList[2])
		end
		if self.m_tOtherData then 
			if self.m_tOtherData.type == 1 then 
				ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
			elseif self.m_tOtherData.type == 2 then 
				ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 3)			
			end
		end
	else
		showManCountLabel:setText(LocalStrings.PEOPLE_SHOP_TEXT24)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetShoppingRanking( )
	end
end


function WndShopRank:onBtnClickClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nRankType == 12 then 
		WndShootArrow:showRedDot()
	elseif self.m_nRankType == 15 then 
		--刷新年兽血量
		WndYearMonster:setUpdateInterval()
	end
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief 	点击切换榜单类型会调
function WndShopRank:onClickTab(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local nTag = element:getTag()
	if self.m_nTabIndex == nTag then return end 

	self.m_nTabIndex = nTag

	if self.m_nRankType == 11 or self.m_nRankType == 20 or self.m_nRankType == 17 or self.m_nRankType == 18 or self.m_nRankType == 22 or self.m_nRankType == 32 or self.m_nRankType == 33 or self.m_nRankType == 37 or self.m_nRankType == 42 or self.m_nRankType == 43 or self.m_nRankType == 44 or self.m_nRankType == 46 or self.m_nRankType == 47 or self.m_nRankType == 51 or self.m_nRankType == 54 then 
		if self.m_nTabIndex == 1 and self.m_tSingleArrowList == nil then 
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, self.m_nTabIndex)
			return 
		elseif self.m_nTabIndex == 2 and self.m_tTeamArrowList == nil then 
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, self.m_nTabIndex)
			return 
		end
		self:setTitleAndPos()
		if self.m_nTabIndex == 1 then 
			self:showList(self.m_tSingleArrowList.list)
		elseif self.m_nTabIndex == 2 then 
			self:showList(self.m_tTeamArrowList.list)
		end
	elseif self.m_nRankType == 12 then 
		self:setTitleAndPos()
		if self.m_nTabIndex == 1 then 
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 1, "")
		elseif self.m_nTabIndex == 2 then 
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, "")
		end
	elseif self.m_nRankType == 36 then 
		self:setTitleAndPos()
		if self.m_nTabIndex == 1 then 
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 3)
		elseif self.m_nTabIndex == 2 and self.m_tTeamArrowList == nil then 
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 3)
			return 
		end
		if self.m_nTabIndex == 1 then 
			
		elseif self.m_nTabIndex == 2 then 
			self:showList(self.m_tTeamArrowList.list)
		end
	elseif self.m_nRankType == 41 then 
		self:setTitleAndPos()
		if self.m_nTabIndex == 1 then 
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 2)
			return 
		elseif self.m_nTabIndex == 2 then 
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 1)
			return 
		end
	elseif self.m_nRankType == 63 then 
		self:setTitleAndPos()
		if self.m_nTabIndex == 1 then 
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 3)
		elseif self.m_nTabIndex == 2 and self.m_tTeamArrowList == nil then 
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 2)
			return 
		end
		if self.m_nTabIndex == 1 then 
			
		elseif self.m_nTabIndex == 2 then 
			self:showList(self.m_tTeamArrowList.list)
		end
	elseif self.m_nRankType == 71 then 
		self:setTitleAndPos()
		if self.m_nTabIndex == 1 then 
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 3)
		elseif self.m_nTabIndex == 2 and self.m_tTeamArrowList == nil then 
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 2)
			return 
		end
		if self.m_nTabIndex == 1 then 
			
		elseif self.m_nTabIndex == 2 then 
			self:showList(self.m_tTeamArrowList.list)
		end
	elseif self.m_nRankType == 73 then 
		self:setTitleAndPos()
		if self.m_nTabIndex == 1 then 
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 3)
		elseif self.m_nTabIndex == 2 and self.m_tTeamArrowList == nil then 
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, 2)
			return 
		end
		if self.m_nTabIndex == 1 then 
			
		elseif self.m_nTabIndex == 2 then 
			self:showList(self.m_tTeamArrowList.list)
		end
	elseif self.m_nRankType == 90 then 
		if self.m_tOtherData.type == 1 then 
			if self.m_nTabIndex == 1 and self.m_tSingleArrowList == nil then 
				ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, self.m_nTabIndex)
				return 
			elseif self.m_nTabIndex == 2 and self.m_tTeamArrowList == nil then 
				ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, self.m_nTabIndex)
				return 
			end
			self:setTitleAndPos()
			if self.m_nTabIndex == 1 then 
				self:showList(self.m_tSingleArrowList.list)
			elseif self.m_nTabIndex == 2 then 
				self:showList(self.m_tTeamArrowList.list)
			end
		elseif self.m_tOtherData.type == 2 then 

		end
	end
end

--@brief 	点击组队奖励按钮回调
function WndShopRank:onClickTeamReward(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local data = nil
	local name = ""
	WZLog("WndShopRank:onClickTeamReward", self.m_nTabIndex, self.m_nRankType)
	if self.m_nTabIndex == 1 then
		data = self.m_tInvestData
		name = LocalStrings.ACTIVITY_TEXT192
		if self.m_nRankType == 19 then 
			name = LocalStrings.BEATMICE_TEXT1[4] .. LocalStrings.ATH_REWARD_CHECK
		end
	elseif self.m_nTabIndex == 2 then
		data = self.m_tTeamReward
		name = LocalStrings.ACTIVITY_TEXT193
		if self.m_nRankType == 32 then 
			name = LocalStrings.MIDNIGHTDINER_TEXT1[18]
		elseif self.m_nRankType == 36 then 
			name = LocalStrings.BEINGIMMORTAL_TEXT1[18]
		elseif self.m_nRankType == 63 then 
			name = LocalStrings.KICKING_BIRDIE_TEXT1[21]
		elseif self.m_nRankType == 71 then 
			name = LocalStrings.BUILDING_BLOCKS_TEXT1[15]
		elseif self.m_nRankType == 73 then 
			name = LocalStrings.CASTING_MASTER_ACTIVITY_TEXT1[13]
		end
	end
	WZLog("WndShopRank:onClickTeamReward 000", tostring(data))
	if data then
		WndPvpSegmentReward:showWndUI(data, {titleName = name})
	end
end

--@brief 	点击邀请参赛按钮回调
function WndShopRank:onClickInvite(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if WndShootArrow.m_tTeamState.zdStatus == 1 then 
		MsgBoxManager:showTipBox(LocalStrings.SHOOTARROW_TEXT25)
	else
		if self.m_tSelFriends == nil or #self.m_tSelFriends == 0 then 
			MsgBoxManager:showTipBox(LocalStrings.DOUBLE_SEVEN_TEXT23)
			return 
		end
		local tData = {}
		tData.ids = self.m_tSelFriends
		local sMsg = json.encode(tData)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 3, sMsg)
	end
end

--@brief 	点击接受按钮回调
function WndShopRank:onClickAccept(playerId)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local tData = {}
	tData.id = playerId
	local sMsg = json.encode(tData)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 4, sMsg)
end

--@brief 	点击拒绝按钮回调
function WndShopRank:onClickRefuse(playerId)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local tData = {}
	tData.id = playerId
	local sMsg = json.encode(tData)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 5, sMsg)
end

--@brief 	度假村排行榜点赞回调
function WndShopRank:onClickGoodCallBack(tCell, tData)
	self.m_tCellClick = tCell 
	self.m_tCellData = tData 

	ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_ThumbsUp(tData.playerId)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndShopRank:_onRankReward(myRank, myPoint, rewardRanks, itemCounts, itemIds, itemNums, playerIds, levels, points, names, faceIds, headIds, headColors, sexs, cross)
	local shopItemFreeList = GetElement(self.m_root,"shopItemFreeListContainer",WZUIFreeListContainer)
	if next(playerIds) == nil then
		ShowPanelNullTip(shopItemFreeList, LocalStrings.CHARM_RESULT)
		return
	end
	local my_rank = GetElement(self.m_root,"my_rank",WZUILabelTTF)
	if myRank < 0 then
		my_rank:setText(LocalStrings.NOT_IN_RANKLIST)
	else
		my_rank:setText(myRank)
	end
	local my_score = GetElement(self.m_root,"my_score",WZUILabelTTF)
	my_score:setText(myPoint)
	local table_insert = table.insert
	local data = {}
	local count = 1
	local rank_index = 1

	local ids = {}
	local nums = {}
	for i,v in ipairs(playerIds) do
		local tab = {}
		tab.playerId = playerIds[i]
		tab.level = levels[i]
		tab.point = points[i]
		tab.name = names[i]
		tab.faceId = faceIds[i]
		tab.headId = headIds[i]
		tab.headColor = headColors[i]
		tab.sex = sexs[i]
		tab.cross = cross[i]

		local array = SplitStringWithSeparator(rewardRanks[rank_index],"-")
		if tonumber(array[1]) <= 3 then
			ids = {}
			nums = {}
			for i=1,itemCounts[rank_index] do
				table_insert(ids,itemIds[count])
				table_insert(nums,itemNums[count])
				count = count + 1
			end
			rank_index = rank_index + 1
		else
			if tonumber(array[1]) == i then
				ids = {}
				nums = {}
				for i=1,itemCounts[rank_index] do
					table_insert(ids,itemIds[count])
					table_insert(nums,itemNums[count])
					count = count + 1
				end
				rank_index = rank_index + 1
				if rank_index > #rewardRanks then
					rank_index = rank_index - 1
				end
			end
		end
		tab.reward_id = ids
		tab.reward_num = nums

		data[i] = tab
	end
	for i = 1, #data do
		local element, tLuaObj = CellShopRankItem:createElement()
		shopItemFreeList:pushBack(WZUIContainer:luaTo(element))
		shopItemFreeList:getMoveElement():setPositionY(shopItemFreeList:getMinPosition().y)
		tLuaObj:setShopRankMessage(i,data[i])
	end
end
--藏宝图排行榜
function WndShopRank:_onTreasureRankReward(rewardConfig, myPoint, playerId, nickname, headId, headColor, faceId, sex, level, point)
	rewardConfig = json.decode(rewardConfig)
	if not rewardConfig then return end

	local shopItemFreeList = GetElement(self.m_root,"shopItemFreeListContainer",WZUIFreeListContainer)
	if next(playerId) == nil then
		ShowPanelNullTip(shopItemFreeList, LocalStrings.CHARM_RESULT)
		return
	end

	local tData, myCurRank = self:setRankData(rewardConfig, playerId, level, point, nickname, faceId, headId, headColor, sex)
	local my_rank = GetElement(self.m_root,"my_rank",WZUILabelTTF)
	if myCurRank < 0 then
		my_rank:setText(LocalStrings.NOT_IN_RANKLIST)
	else
		my_rank:setText(myCurRank)
	end
	local my_score = GetElement(self.m_root,"my_score",WZUILabelTTF)
	my_score:setText(myPoint)

	for i = 1, #tData do
		local element, tLuaObj = CellShopRankItem:createElement()
		shopItemFreeList:pushBack(WZUIContainer:luaTo(element))
		shopItemFreeList:getMoveElement():setPositionY(shopItemFreeList:getMinPosition().y)
		tLuaObj:setShopRankMessage(i,tData[i])
	end
end
--元旦求签
function WndShopRank:_onNewYearRankReward(rewardConfig, myPoint, playerId, nickname, headId, headColor, faceId, sex, level, point)
	local shopItemFreeList = GetElement(self.m_root,"shopItemFreeListContainer",WZUIFreeListContainer)
	if not rewardConfig or rewardConfig == "" then
		ShowPanelNullTip(shopItemFreeList, LocalStrings.CHARM_RESULT)
		return
	end

	rewardConfig = json.decode(rewardConfig)
	if not rewardConfig then return end

	if next(playerId) == nil then
		ShowPanelNullTip(shopItemFreeList, LocalStrings.CHARM_RESULT)
		return
	end

	local tData, myCurRank = self:setRankData(rewardConfig, playerId, level, point, nickname, faceId, headId, headColor, sex)
	local my_rank = GetElement(self.m_root,"my_rank",WZUILabelTTF)
	if myCurRank < 0 then
		my_rank:setText(LocalStrings.NOT_IN_RANKLIST)
	else
		my_rank:setText(myCurRank)
	end
	local my_score = GetElement(self.m_root,"my_score",WZUILabelTTF)
	my_score:setText(myPoint)

	shopItemFreeList:removeAll()
	for i = 1, #tData do
		local element, tLuaObj = CellShopRankItem:createElement()
		shopItemFreeList:pushBack(WZUIContainer:luaTo(element))
		shopItemFreeList:getMoveElement():setPositionY(shopItemFreeList:getMinPosition().y)
		tLuaObj:setShopRankMessage(i,tData[i])
	end
end

--[[
	估计这个是以后统一排行榜的
]]
function WndShopRank:_onRankResult(activityId, activityType, rankingType, myPoint, myRanking, rewardConfig, playerIds, ranks, points, nickname, headIds, 
								   headColors, faceIds, sexs, vipLevel, level, bodyIds, wingIds, title, serverId, session, settlementDate)
	self:setRankListData(activityId,myPoint,rewardConfig,playerIds,level,points,nickname,faceIds,headIds, headColors, sexs, title, vipLevel, rankingType, 
		myRanking, serverId, session, settlementDate)
end

function WndShopRank:setRankListData(activityId,myPoint,rewardConfig,playerIds,level,points,nickname,faceIds,headIds, headColors, sexs, title, vipLevel, 
	rankingType, myRanking, serverId, session, settlementDate, headEffectId, qqHallInfo)
	if activityId == self.m_nActivityId then
		local shopItemFreeList = GetElement(self.m_root,"shopItemFreeListContainer",WZUIFreeListContainer)
		shopItemFreeList:removeAll()
		local conInterface = GetElement(self.m_root, "conInterface_WndShopRank", WZUIContainer)
		local color = nil
		if self.m_nRankType == 4 then
			color = ccc3(255,255,255)
		end
		if not rewardConfig or rewardConfig == "" then
			ShowPanelNullTip(conInterface, LocalStrings.CHARM_RESULT, color)
			return
		end

		if self.m_nRankType ~= 38 then 
			rewardConfig = json.decode(rewardConfig)
			if not rewardConfig then return end
		end
		if self.m_nRankType == 41 and rankingType == 2 then 
			self.m_sSettlementDate = settlementDate
			GetElement(self.m_root,"showManCountLabel",WZUILabelTTF):setText(string.format(LocalStrings.BEATBALLOON_TEXT1[18], self.m_sSettlementDate))
		end
		WZLog("WndShopRank:setRankListData", Serialize(rewardConfig), #playerIds, settlementDate)

		local my_score = GetElement(self.m_root,"my_score",WZUILabelTTF)
		local my_rank = GetElement(self.m_root,"my_rank",WZUILabelTTF)
		local temp = analyzeActivityReward(rewardConfig)
		--只显示前x名玩家,根据配置显示
		local tTmpType = {53,61,62,64,65,66,67,68,69,70,72,74,75}
		if utilsValueInTable(self.m_nRankType, tTmpType) or (self.m_nRankType == 90 and self.m_tOtherData.type == 1) then 
			if temp and type(temp) == "table" and temp[#temp] and temp[#temp].rank2 and tonumber(temp[#temp].rank2) > 0 then
				GetElement(self.m_root,"showManCountLabel",WZUILabelTTF):setText(string.format(LocalStrings.NEWYEAR_TEXT15, temp[#temp].rank2))
			end
		end
		if next(playerIds) == nil then
			local tempType1 = {11,17,18,19,20,21,22,23,24,25,27,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,66,67,68,69,70,71,72,73,74,75,90}
			if utilsValueInTable(self.m_nRankType, tempType1) then 
				local temp = analyzeActivityReward(rewardConfig)
				if (self.m_nRankType == 20 or self.m_nRankType == 19) and rankingType == 1 then
					self.m_tInvestData = CopyTable(temp)
				elseif rankingType == 2 then 
					self.m_tTeamReward = CopyTable(temp)
				elseif self.m_nRankType == 36 or self.m_nRankType == 63 or self.m_nRankType == 71 or self.m_nRankType == 73 then 
					self.m_tTeamReward = CopyTable(temp)
				end
				self:setTitleAndPos()
			end
			ShowPanelNullTip(conInterface, LocalStrings.CHARM_RESULT, color)
			my_score:setText(LocalStrings.SPACE_CITY2)
			my_rank:setText(LocalStrings.SPACE_CITY2)
			return
		end
		removeShowPanelNullTip(conInterface)
		local tData, myCurRank = self:setRankData(rewardConfig, playerIds, level, points, nickname, faceIds, headIds, headColors, sexs, nil, nil, title, vipLevel, self.m_nRankType, rankingType, serverId, headEffectId, qqHallInfo)
		
		if (self.m_nRankType == 46 or self.m_nRankType == 47 or self.m_nRankType == 51 or self.m_nRankType == 54 or self.m_nRankType == 71 or self.m_nRankType == 73) and self.m_nTabIndex == 2 then 
			myCurRank = myRanking
		end
		if myCurRank < 0 then
			my_rank:setText(LocalStrings.NOT_IN_RANKLIST)
		else
			my_rank:setText(myCurRank)
		end
		if myPoint < 0 then myPoint = 0 end
		my_score:setText(myPoint)

		if self.m_nRankType == 4 then
			my_rank:setColor(GlobalMethod:ccc3(255,255,255))
			my_score:setColor(GlobalMethod:ccc3(255,255,255))
		end
		local tempType2 = {11,20,17,18,22,32,33,37,42,43,44,46,47,51,54}
		if utilsValueInTable(self.m_nRankType, tempType2) then 
			if rankingType == 1 then
				self.m_tSingleArrowList = {} 
				self.m_tSingleArrowList.list = tData
				self.m_tSingleArrowList.myRank = myCurRank
				self.m_tSingleArrowList.myPoint = myPoint
			elseif rankingType == 2 then 
				self.m_tTeamArrowList = {} 
				self.m_tTeamArrowList.list = tData
				self.m_tTeamArrowList.myRank = myCurRank
				self.m_tTeamArrowList.myPoint = myPoint
			end
			self:setTitleAndPos()
		end

		for i = 1, #tData do
			local nAddNum = 0
			if (self.m_nRankType == 46 or self.m_nRankType == 54) and self.m_nTabIndex == 2 then 
				local tPlayerInfo = json.decode(tData[i].title)
				local nNameCount = #tPlayerInfo.playerIds
				if nNameCount >= 3 then 
					nAddNum = nNameCount - 3
				end
			end
			local element, tLuaObj = CellShopRankItem:createElement(self.m_nRankType, self.m_nTabIndex, nAddNum)
			shopItemFreeList:pushBack(WZUIContainer:luaTo(element))
			shopItemFreeList:getMoveElement():setPositionY(shopItemFreeList:getMinPosition().y)
			tLuaObj:setShopRankMessage(i,tData[i],self.m_nRankType,self.m_tOtherData)
		end
	end
end

--@brief 	显示列表
function WndShopRank:showList(tData)
	--body
	local shopItemFreeList = GetElement(self.m_root,"shopItemFreeListContainer",WZUIFreeListContainer)
	shopItemFreeList:removeAll()
	local conInterface = GetElement(self.m_root, "conInterface_WndShopRank", WZUIContainer)
	if tData == nil or #tData == 0 then
		ShowPanelNullTip(conInterface, LocalStrings.CHARM_RESULT)
		return
	end

	if self.m_nRankType == 10 then 
		shopItemFreeList:setAbsContentSize(GlobalMethod:CCSize(822,326))
		shopItemFreeList:updateRelativeSize()
	elseif self.m_nRankType == 12 then 
		shopItemFreeList:setAbsContentSize(GlobalMethod:CCSize(822,370))
		shopItemFreeList:updateRelativeSize()
		shopItemFreeList:setRelativePosition(GlobalMethod:ccp(0.5, 0.88))
	end

	removeShowPanelNullTip(conInterface)
	for i = 1, #tData do
		local nAddNum = 0
		if (self.m_nRankType == 46 or self.m_nRankType == 54) and self.m_nTabIndex == 2 then 
			local tPlayerInfo = json.decode(tData[i].title)
			local nNameCount = #tPlayerInfo.playerIds
			if nNameCount >= 3 then 
				nAddNum = nNameCount - 3
			end
		end
		local element, tLuaObj = CellShopRankItem:createElement(self.m_nRankType, self.m_nTabIndex, nAddNum)
		shopItemFreeList:pushBack(WZUIContainer:luaTo(element))
		tLuaObj:setShopRankMessage(i, tData[i], self.m_nRankType)
	end

	shopItemFreeList:getMoveElement():setPositionY(shopItemFreeList:getMinPosition().y)
end

--@brief 	设置顶部标题文字和位置
function WndShopRank:setTitleAndPos()
	local txtTitle1 = GetElement(self.m_root, "txtTitle1_WndShopRank", WZUILabelTTF)
	local txtTitle2 = GetElement(self.m_root, "txtTitle2_WndShopRank", WZUILabelTTF)
	local txtTitle3 = GetElement(self.m_root, "txtChangeTitle", WZUILabelTTF)
	local txtTitle4 = GetElement(self.m_root, "txtTitle4_WndShopRank", WZUILabelTTF)
	local my_rank = GetElement(self.m_root,"my_rank",WZUILabelTTF)
	local my_score = GetElement(self.m_root,"my_score",WZUILabelTTF)
	local txtScoreTitle = GetElement(self.m_root,"txtScoreTitle",WZUILabelTTF)
	if self.m_nRankType == 10 then
		txtTitle1:setTextKey("SHOOTARROW_TEXT30")
		txtTitle2:setTextKey("TEAM")
		txtTitle2:setRelativePosition(GlobalMethod:ccp(0.48, 0.5))
		txtTitle3:setTextKey("SHOOTARROW_TEXT15")
		txtTitle3:setRelativePosition(GlobalMethod:ccp(0.83, 0.5))
		txtTitle4:setTextKey("VIP_TIP09")
		txtTitle4:setRelativePosition(GlobalMethod:ccp(0.95, 0.5))
	elseif self.m_nRankType == 11 then
		local showManCountLabel = GetElement(self.m_root,"showManCountLabel",WZUILabelTTF)
		local txtRankTitle = GetElement(self.m_root,"txtRankTitle",WZUILabelTTF)
		local btnTeamReward = GetElement(self.m_root, "btnTeamReward_WndShopRank", WZUIButton)
		local myCurRank = -1
		local myPoint = 0
		if self.m_nTabIndex == 1 then
			btnTeamReward:setVisible(false)
			showManCountLabel:setText(LocalStrings.EVERYDAYBUY_TEXT25)
			txtScoreTitle:setText(LocalStrings.SHOOTARROW_TEXT16 .. ":")
			GetElement(self.m_root, "txtRankTitleName", WZUILabelTTF):setText(LocalStrings.SHOOTARROW_TEXT17)
			txtTitle2:setTextKey("PLAYER")
			txtTitle2:setRelativePosition(GlobalMethod:ccp(0.281, 0.5))
			txtTitle3:setTextKey("SHOOTARROW_TEXT16")
			txtTitle3:setRelativePosition(GlobalMethod:ccp(0.48, 0.5))
			txtTitle4:setTextKey("ATH_REWARD_CHECK")
			txtTitle4:setRelativePosition(GlobalMethod:ccp(0.797, 0.5))
			txtRankTitle:setRelativePosition(GlobalMethod:ccp(0.842,0.5))
			if self.m_tSingleArrowList then 
				myCurRank = self.m_tSingleArrowList.myRank
				myPoint = self.m_tSingleArrowList.myPoint
			end
		elseif self.m_nTabIndex == 2 then 
			btnTeamReward:setVisible(true)
			showManCountLabel:setText(string.format(LocalStrings.SHOOTARROW_TEXT19, 10))
			txtScoreTitle:setText(LocalStrings.SHOOTARROW_TEXT15 .. ":")
			GetElement(self.m_root, "txtRankTitleName", WZUILabelTTF):setText(LocalStrings.SHOOTARROW_TEXT18)
			txtTitle2:setTextKey("TEAM")
			txtTitle2:setRelativePosition(GlobalMethod:ccp(0.48, 0.5))
			txtTitle3:setTextKey("SHOOTARROW_TEXT15")
			txtTitle3:setRelativePosition(GlobalMethod:ccp(0.88, 0.5))
			txtTitle4:setTextKey("")
			txtTitle4:setText("")
			txtRankTitle:setRelativePosition(GlobalMethod:ccp(0.78,0.5))

			if self.m_tTeamArrowList then 
				myCurRank = self.m_tTeamArrowList.myRank
				myPoint = self.m_tTeamArrowList.myPoint
			end
		end
		if myCurRank < 0 then
			my_rank:setText(LocalStrings.NOT_IN_RANKLIST)
		else
			my_rank:setText(myCurRank)
		end
		my_score:setText(myPoint)
	elseif self.m_nRankType == 12 then 
		local txtRankDesc = GetElement(self.m_root, "txtRankDesc_WndShopRank", WZUILabelTTF)
		if self.m_nTabIndex == 1 then 
			GetElement(self.m_root, "btnInviteFight_WndShopRank", WZUIContainer):setVisible(true)
			txtRankDesc:setDimensions(GlobalMethod:CCSize(600,0))
		elseif self.m_nTabIndex == 2 then 
			GetElement(self.m_root, "btnInviteFight_WndShopRank", WZUIContainer):setVisible(false)
			txtRankDesc:setDimensions(GlobalMethod:CCSize(810,0))
			GlobalGame.g_tRedPointTypeList[17020] = false
			self:_showRedDot()
		end
	elseif self.m_nRankType == 14 then 
		txtTitle3:setTextKey("DECORATIONS_TEXT2")
		txtScoreTitle:setText(LocalStrings.DECORATIONS_TEXT1[13])
	elseif self.m_nRankType == 15 then 
		txtTitle3:setTextKey("")
		txtTitle3:setText(LocalStrings.YEARMONSTER_TEXT1[9])
		txtScoreTitle:setText(LocalStrings.YEARMONSTER_TEXT1[9] .. ":")
	elseif self.m_nRankType == 16 then 
		txtTitle3:setTextKey("")
		txtTitle3:setText(LocalStrings.NEWYEARWISH_TEXT1[3])
		txtScoreTitle:setText(LocalStrings.NEWYEARWISH_TEXT1[3] .. ":")
	elseif self.m_nRankType == 17 then 
		txtTitle3:setTextKey("")
		txtTitle3:setText(LocalStrings.BEATENGINEER_TEXT1[6])
		txtScoreTitle:setText(LocalStrings.BEATENGINEER_TEXT1[6] .. ":")
		GetElement(self.m_root, "txtRankTitleName", WZUILabelTTF):setText(LocalStrings.BEATENGINEER_TEXT1[8 + self.m_nTabIndex])
		local myCurRank = -1
		local myPoint = 0
		if self.m_nTabIndex == 1 then 
			if self.m_tSingleArrowList then 
				myCurRank = self.m_tSingleArrowList.myRank
				myPoint = self.m_tSingleArrowList.myPoint
			end
		elseif self.m_nTabIndex == 2 then 
			if self.m_tTeamArrowList then 
				myCurRank = self.m_tTeamArrowList.myRank
				myPoint = self.m_tTeamArrowList.myPoint
			end
		end
		if myCurRank < 0 then
			my_rank:setText(LocalStrings.NOT_IN_RANKLIST)
		else
			my_rank:setText(myCurRank)
		end
		my_score:setText(myPoint)
	elseif self.m_nRankType == 18 then 
		local showManCountLabel = GetElement(self.m_root,"showManCountLabel",WZUILabelTTF)
		txtTitle3:setTextKey("")
		local myCurRank = -1
		local myPoint = 0
		if self.m_nTabIndex == 1 then 
			showManCountLabel:setText(string.format(LocalStrings.NEWYEAR_TEXT15, 100))
			txtTitle3:setText(LocalStrings.ALCHEMY_TEXT1[6])
			txtScoreTitle:setText(LocalStrings.ALCHEMY_TEXT1[6] .. ":")
			GetElement(self.m_root, "txtRankTitleName", WZUILabelTTF):setText(LocalStrings.ALCHEMY_TEXT1[4])
			if self.m_tSingleArrowList then 
				myCurRank = self.m_tSingleArrowList.myRank
				myPoint = self.m_tSingleArrowList.myPoint
			end
		elseif self.m_nTabIndex == 2 then 
			showManCountLabel:setText(string.format(LocalStrings.NEWYEAR_TEXT15, 20))
			txtTitle3:setText(LocalStrings.ALCHEMY_TEXT1[11])
			txtScoreTitle:setText(LocalStrings.ALCHEMY_TEXT1[11] .. ":")
			GetElement(self.m_root, "txtRankTitleName", WZUILabelTTF):setText(LocalStrings.ALCHEMY_TEXT1[8])
			if self.m_tTeamArrowList then 
				myCurRank = self.m_tTeamArrowList.myRank
				myPoint = self.m_tTeamArrowList.myPoint
			end
		end
		if myCurRank < 0 then
			my_rank:setText(LocalStrings.NOT_IN_RANKLIST)
		else
			my_rank:setText(myCurRank)
		end
		my_score:setText(myPoint)
	elseif self.m_nRankType == 19 then 
		local btnTeamReward = GetElement(self.m_root, "btnTeamReward_WndShopRank", WZUIButton)
		btnTeamReward:setVisible(true)
		local txtRankTitle = GetElement(self.m_root,"txtRankTitle",WZUILabelTTF)
		txtRankTitle:setRelativePosition(GlobalMethod:ccp(0.78,0.5))
	elseif self.m_nRankType == 20 then
		local title_name = {LocalStrings.ACTIVITY_TEXT183,LocalStrings.ACTIVITY_TEXT196}
		GetElement(self.m_root, "txtRankTitleName", WZUILabelTTF):setText(title_name[self.m_nTabIndex])
		local txtRankTitle = GetElement(self.m_root,"txtRankTitle",WZUILabelTTF)
		txtRankTitle:setRelativePosition(GlobalMethod:ccp(0.78,0.5))
		local showManCountLabel = GetElement(self.m_root,"showManCountLabel",WZUILabelTTF)
		local btnTeamReward = GetElement(self.m_root, "btnTeamReward_WndShopRank", WZUIButton)
		btnTeamReward:setVisible(true)
		local myCurRank = -1
		local myPoint = 0
		if self.m_nTabIndex == 1 then
			txtScoreTitle:setText(LocalStrings.ACTIVITY_TEXT197 .. ":")
			txtRankTitle:setText(LocalStrings.DOUBLE_SEVEN_TEXT14)
			showManCountLabel:setText(LocalStrings.EVERYDAYBUY_TEXT25)
			txtTitle2:setRelativePosition(GlobalMethod:ccp(0.281, 0.5))
			txtTitle3:setTextKey("ACTIVITY_TEXT197")
			txtTitle3:setRelativePosition(GlobalMethod:ccp(0.48, 0.5))
			txtTitle4:setTextKey("ATH_REWARD_CHECK")
			if self.m_tSingleArrowList then 
				myCurRank = self.m_tSingleArrowList.myRank
				myPoint = self.m_tSingleArrowList.myPoint
			end
		elseif self.m_nTabIndex == 2 then
			txtScoreTitle:setText(LocalStrings.ACTIVITY_TEXT199 .. ":")
			txtRankTitle:setText(LocalStrings.ACTIVITY_TEXT200)
			showManCountLabel:setText(string.format(LocalStrings.ACTIVITY_TEXT201,20))
			txtTitle2:setRelativePosition(GlobalMethod:ccp(0.48, 0.5))
			txtTitle3:setTextKey("ACTIVITY_TEXT199")
			txtTitle3:setRelativePosition(GlobalMethod:ccp(0.88, 0.5))
			txtTitle4:setTextKey("")
			txtTitle4:setText("")
			if self.m_tTeamArrowList then 
				myCurRank = self.m_tTeamArrowList.myRank
				myPoint = self.m_tTeamArrowList.myPoint
			end
		end
		if myCurRank < 0 then
			my_rank:setText(LocalStrings.NOT_IN_RANKLIST)
		else
			my_rank:setText(myCurRank)
		end
		my_score:setText(myPoint)
	elseif self.m_nRankType == 21 then 
		txtTitle3:setTextKey("")
		txtTitle3:setText(LocalStrings.INTEGRATION)
		txtScoreTitle:setText(LocalStrings.INTEGRATION .. ":")
	elseif self.m_nRankType == 22 then
		local title_name = {LocalStrings.GARDEN_TEXT1[4],LocalStrings.GARDEN_TEXT1[5]}
		GetElement(self.m_root, "txtRankTitleName", WZUILabelTTF):setText(title_name[self.m_nTabIndex])
		local showManCountLabel = GetElement(self.m_root,"showManCountLabel",WZUILabelTTF)
		local myCurRank = -1
		local myPoint = 0
		txtTitle3:setTextKey("")
		if self.m_nTabIndex == 1 then
			showManCountLabel:setText(LocalStrings.EVERYDAYBUY_TEXT25)
			txtTitle3:setText(LocalStrings.GARDEN_TEXT1[6])
			txtScoreTitle:setText(LocalStrings.GARDEN_TEXT1[6] .. ":")
			if self.m_tSingleArrowList then 
				myCurRank = self.m_tSingleArrowList.myRank
				myPoint = self.m_tSingleArrowList.myPoint
			end
		elseif self.m_nTabIndex == 2 then
			showManCountLabel:setText(string.format(LocalStrings.NEWYEAR_TEXT15,20))
			txtTitle3:setText(LocalStrings.INTEGRATION)
			txtScoreTitle:setText(LocalStrings.INTEGRATION .. ":")
			if self.m_tTeamArrowList then 
				myCurRank = self.m_tTeamArrowList.myRank
				myPoint = self.m_tTeamArrowList.myPoint
			end
		end
		if myCurRank < 0 then
			my_rank:setText(LocalStrings.NOT_IN_RANKLIST)
		else
			my_rank:setText(myCurRank)
		end
		my_score:setText(myPoint)
	elseif self.m_nRankType == 23 then 
		txtTitle3:setTextKey("")
		txtTitle3:setText(LocalStrings.CAFFEE_TEXT1[4])
		txtScoreTitle:setText(LocalStrings.CAFFEE_TEXT1[4] .. ":")
	elseif self.m_nRankType == 24 then 
		txtTitle3:setTextKey("")
		txtTitle3:setText(LocalStrings.BOWLING_TEXT1[4])
		txtScoreTitle:setText(LocalStrings.BOWLING_TEXT1[4] .. ":")
	elseif self.m_nRankType == 25 then 
		txtTitle3:setTextKey("")
		txtTitle3:setText(LocalStrings.YEARPLAYER_TEXT1[4])
		txtScoreTitle:setText(LocalStrings.YEARPLAYER_TEXT1[4] .. ":")
		txtTitle1:setTextKey("")
		txtTitle1:setText(LocalStrings.YEARPLAYER_TEXT1[8])
	elseif self.m_nRankType == 26 then 
		txtTitle3:setTextKey("")
		txtTitle3:setText(LocalStrings.HOLIDAYVILLAGE_TEXT1[38])
		txtTitle4:setTextKey("")
		txtTitle4:setRelativePosition(GlobalMethod:ccp(0.84,0.5))
		txtTitle4:setText(LocalStrings.HOLIDAYVILLAGE_TEXT1[67])
		GetElement(self.m_root, "txtTitle5_WndShopRank", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT1[19])
		txtScoreTitle:setText(LocalStrings.HOLIDAYVILLAGE_TEXT1[38] .. ":")
	elseif self.m_nRankType == 27 then 
		txtTitle3:setTextKey("")
		txtTitle3:setText(LocalStrings.WATERMELON_TEXT1[4])
		txtScoreTitle:setText(LocalStrings.WATERMELON_TEXT1[4] .. ":")
	elseif self.m_nRankType == 28 then 
		txtTitle3:setTextKey("")
		txtTitle3:setText(LocalStrings.SECRETTOWER_TEXT1[4])
		txtScoreTitle:setText(LocalStrings.SECRETTOWER_TEXT1[4] .. ":")
	elseif self.m_nRankType == 30 then 
		txtTitle3:setTextKey("")
		txtTitle3:setText(LocalStrings.BILLIARDBALL_TEXT1[4])
		txtScoreTitle:setText(LocalStrings.BILLIARDBALL_TEXT1[4] .. ":")
	elseif self.m_nRankType == 31 then 
		txtTitle3:setTextKey("")
		txtTitle3:setText(LocalStrings.CRAZY_GASHAPON_TEXT3[4])
		txtScoreTitle:setText(LocalStrings.CRAZY_GASHAPON_TEXT3[4] .. ":")
	elseif self.m_nRankType == 32 then
		local showManCountLabel = GetElement(self.m_root,"showManCountLabel",WZUILabelTTF)
		local txtRankTitle = GetElement(self.m_root,"txtRankTitle",WZUILabelTTF)
		local btnTeamReward = GetElement(self.m_root, "btnTeamReward_WndShopRank", WZUIButton)
		local myCurRank = -1
		local myPoint = 0
		if self.m_nTabIndex == 1 then
			btnTeamReward:setVisible(false)
			showManCountLabel:setText(LocalStrings.EVERYDAYBUY_TEXT25)
			txtScoreTitle:setText(LocalStrings.MIDNIGHTDINER_TEXT1[19] .. ":")
			GetElement(self.m_root, "txtRankTitleName", WZUILabelTTF):setText(LocalStrings.MIDNIGHTDINER_TEXT1[3])
			txtTitle2:setTextKey("PLAYER")
			txtTitle2:setRelativePosition(GlobalMethod:ccp(0.281, 0.5))
			txtTitle3:setTextKey("")
			txtTitle3:setText(LocalStrings.MIDNIGHTDINER_TEXT1[19])
			txtTitle3:setRelativePosition(GlobalMethod:ccp(0.48, 0.5))
			txtTitle4:setTextKey("ATH_REWARD_CHECK")
			txtTitle4:setRelativePosition(GlobalMethod:ccp(0.797, 0.5))
			txtRankTitle:setRelativePosition(GlobalMethod:ccp(0.842,0.5))
			if self.m_tSingleArrowList then 
				myCurRank = self.m_tSingleArrowList.myRank
				myPoint = self.m_tSingleArrowList.myPoint
			end
		elseif self.m_nTabIndex == 2 then 
			btnTeamReward:setVisible(true)
			showManCountLabel:setText(string.format(LocalStrings.SHOOTARROW_TEXT19, 20))
			txtScoreTitle:setText(LocalStrings.MIDNIGHTDINER_TEXT1[19] .. ":")
			GetElement(self.m_root, "txtRankTitleName", WZUILabelTTF):setText(LocalStrings.MIDNIGHTDINER_TEXT1[17])
			txtTitle2:setTextKey("TEAM")
			txtTitle2:setRelativePosition(GlobalMethod:ccp(0.48, 0.5))
			txtTitle3:setTextKey("")
			txtTitle3:setText(LocalStrings.MIDNIGHTDINER_TEXT1[19])
			txtTitle3:setRelativePosition(GlobalMethod:ccp(0.88, 0.5))
			txtTitle4:setTextKey("")
			txtTitle4:setText("")
			txtRankTitle:setRelativePosition(GlobalMethod:ccp(0.78,0.5))

			if self.m_tTeamArrowList then 
				myCurRank = self.m_tTeamArrowList.myRank
				myPoint = self.m_tTeamArrowList.myPoint
			end
		end
		if myCurRank < 0 then
			my_rank:setText(LocalStrings.NOT_IN_RANKLIST)
		else
			my_rank:setText(myCurRank)
		end
		my_score:setText(myPoint)
	elseif self.m_nRankType == 33 then
		local title_name = {LocalStrings.GOPHERBALL_TEXT1[3],LocalStrings.GOPHERBALL_TEXT1[13]}
		GetElement(self.m_root, "txtRankTitleName", WZUILabelTTF):setText(title_name[self.m_nTabIndex])
		local showManCountLabel = GetElement(self.m_root,"showManCountLabel",WZUILabelTTF)
		local myCurRank = -1
		local myPoint = 0
		txtTitle3:setTextKey("")
		if self.m_nTabIndex == 1 then
			showManCountLabel:setText(LocalStrings.EVERYDAYBUY_TEXT25)
			txtTitle3:setText(LocalStrings.GOPHERBALL_TEXT1[4])
			txtScoreTitle:setText(LocalStrings.GOPHERBALL_TEXT1[4] .. ":")
			if self.m_tSingleArrowList then 
				myCurRank = self.m_tSingleArrowList.myRank
				myPoint = self.m_tSingleArrowList.myPoint
			end
		elseif self.m_nTabIndex == 2 then
			showManCountLabel:setText(string.format(LocalStrings.NEWYEAR_TEXT15,20))
			txtTitle3:setText(LocalStrings.INTEGRATION)
			txtScoreTitle:setText(LocalStrings.INTEGRATION .. ":")
			if self.m_tTeamArrowList then 
				myCurRank = self.m_tTeamArrowList.myRank
				myPoint = self.m_tTeamArrowList.myPoint
			end
		end
		if myCurRank < 0 then
			my_rank:setText(LocalStrings.NOT_IN_RANKLIST)
		else
			my_rank:setText(myCurRank)
		end
		my_score:setText(myPoint)
	elseif self.m_nRankType == 34 then 
		txtTitle3:setTextKey("")
		txtTitle3:setText(LocalStrings.BEINGIMMORTAL_TEXT1[4])
		txtScoreTitle:setText(LocalStrings.BEINGIMMORTAL_TEXT1[4] .. ":")
	elseif self.m_nRankType == 35 then 
		txtTitle3:setTextKey("")
		txtTitle3:setText(LocalStrings.BEINGIMMORTAL_TEXT1[15])
		txtScoreTitle:setText(LocalStrings.BEINGIMMORTAL_TEXT1[15] .. ":")
	elseif self.m_nRankType == 36 then
		local btnTeamReward = GetElement(self.m_root, "btnTeamReward_WndShopRank", WZUIButton) 
		local txtRankTitle = GetElement(self.m_root,"txtRankTitle",WZUILabelTTF)
		local title_name = {LocalStrings.BEINGIMMORTAL_TEXT1[19],LocalStrings.BEINGIMMORTAL_TEXT1[29]}
		GetElement(self.m_root, "txtRankTitleName", WZUILabelTTF):setText(title_name[self.m_nTabIndex])
		if self.m_nTabIndex == 1 then
			removeShowPanelNullTip(GetElement(self.m_root, "conInterface_WndShopRank", WZUIContainer))
			GetElement(self.m_root, "conForTask_WndShopRank", WZUIContainer):setVisible(true)
			GetElement(self.m_root, "conContent_WndShopRank", WZUIContainer):setVisible(false)
		elseif self.m_nTabIndex == 2 then
			GetElement(self.m_root, "conForTask_WndShopRank", WZUIContainer):setVisible(false)
			GetElement(self.m_root, "conContent_WndShopRank", WZUIContainer):setVisible(true)
			GetElement(self.m_root, "imgTeamReward_WndShopRank", WZUIImage):setFile("ui/activityWords/text_hd_bt_zqzjl.png")
			btnTeamReward:setVisible(true)
			btnTeamReward:setRelativePosition(GlobalMethod:ccp(0.85, 0.5))
			txtTitle1:setTextKey("")
			txtTitle1:setText(LocalStrings.BEINGIMMORTAL_TEXT1[20])
			txtTitle2:setTextKey("")
			txtTitle2:setText(LocalStrings.BEINGIMMORTAL_TEXT1[30])
			txtTitle2:setRelativePosition(GlobalMethod:ccp(0.48, 0.5))
			txtTitle3:setTextKey("")
			txtTitle3:setText(LocalStrings.BEINGIMMORTAL_TEXT1[21])
			txtTitle3:setRelativePosition(GlobalMethod:ccp(0.88, 0.5))
			txtTitle4:setTextKey("")
			txtTitle4:setText("")
			txtScoreTitle:setText(LocalStrings.BEINGIMMORTAL_TEXT1[35] .. ":")
			txtRankTitle:setTextKey("")
			txtRankTitle:setText(LocalStrings.BEINGIMMORTAL_TEXT1[22])
			txtRankTitle:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
		end
	elseif self.m_nRankType == 37 then
		local title_name = {LocalStrings.WORSHIPGOD_TEXT1[7],LocalStrings.WORSHIPGOD_TEXT1[14]}
		GetElement(self.m_root, "txtRankTitleName", WZUILabelTTF):setText(title_name[self.m_nTabIndex])
		local showManCountLabel = GetElement(self.m_root,"showManCountLabel",WZUILabelTTF)
		local myCurRank = -1
		local myPoint = 0
		txtTitle3:setTextKey("")
		if self.m_nTabIndex == 1 then
			showManCountLabel:setText(LocalStrings.EVERYDAYBUY_TEXT25)
			txtTitle3:setText(LocalStrings.WORSHIPGOD_TEXT1[16])
			txtScoreTitle:setText(LocalStrings.WORSHIPGOD_TEXT1[16] .. ":")
			if self.m_tSingleArrowList then 
				myCurRank = self.m_tSingleArrowList.myRank
				myPoint = self.m_tSingleArrowList.myPoint
			end
		elseif self.m_nTabIndex == 2 then
			showManCountLabel:setText(string.format(LocalStrings.NEWYEAR_TEXT15,20))
			txtTitle3:setText(LocalStrings.WORSHIPGOD_TEXT1[17])
			txtScoreTitle:setText(LocalStrings.WORSHIPGOD_TEXT1[17] .. ":")
			if self.m_tTeamArrowList then 
				myCurRank = self.m_tTeamArrowList.myRank
				myPoint = self.m_tTeamArrowList.myPoint
			end
		end
		if myCurRank < 0 then
			my_rank:setText(LocalStrings.NOT_IN_RANKLIST)
		else
			my_rank:setText(myCurRank)
		end
		my_score:setText(myPoint)
	elseif self.m_nRankType == 38 then
		txtTitle3:setTextKey("")
		txtTitle3:setText(LocalStrings.HOLIDAYVILLAGE_TEXT3[9])
		txtScoreTitle:setText(LocalStrings.HOLIDAYVILLAGE_TEXT3[9] .. ":")
	elseif self.m_nRankType == 39 then 
		txtTitle3:setTextKey("")
		txtTitle3:setText(LocalStrings.CALABASH_TEXT1[14])
		txtScoreTitle:setText(LocalStrings.CALABASH_TEXT1[15] .. ":")
	elseif self.m_nRankType == 40 then 
		txtTitle3:setTextKey("")
		txtTitle3:setText(LocalStrings.SPRINGOUTING_TEXT1[16])
		txtScoreTitle:setText(LocalStrings.SPRINGOUTING_TEXT1[15] .. ":")
	elseif self.m_nRankType == 41 then 
		local title_name = {LocalStrings.BEATBALLOON_TEXT1[2],LocalStrings.BEATBALLOON_TEXT1[15]}
		GetElement(self.m_root, "txtRankTitleName", WZUILabelTTF):setText(title_name[self.m_nTabIndex])
		local showManCountLabel = GetElement(self.m_root,"showManCountLabel",WZUILabelTTF)
		local myCurRank = -1
		local myPoint = 0
		txtTitle3:setTextKey("")
		if self.m_nTabIndex == 1 then
			if self.m_sSettlementDate then 
				showManCountLabel:setText(string.format(LocalStrings.BEATBALLOON_TEXT1[18], self.m_sSettlementDate))
			end
			txtTitle3:setText(LocalStrings.BEATBALLOON_TEXT1[14])
			txtScoreTitle:setText(LocalStrings.BEATBALLOON_TEXT1[14] .. ":")
			if self.m_tSingleArrowList then 
				myCurRank = self.m_tSingleArrowList.myRank
				myPoint = self.m_tSingleArrowList.myPoint
			end
		elseif self.m_nTabIndex == 2 then
			showManCountLabel:setText(string.format(LocalStrings.NEWYEAR_TEXT15,100))
			txtTitle3:setText(LocalStrings.BEATBALLOON_TEXT1[14])
			txtScoreTitle:setText(LocalStrings.BEATBALLOON_TEXT1[14] .. ":")
			if self.m_tTeamArrowList then 
				myCurRank = self.m_tTeamArrowList.myRank
				myPoint = self.m_tTeamArrowList.myPoint
			end
		end
		if myCurRank < 0 then
			my_rank:setText(LocalStrings.NOT_IN_RANKLIST)
		else
			my_rank:setText(myCurRank)
		end
		my_score:setText(myPoint)
	elseif self.m_nRankType == 42 then 
		local title_name = {LocalStrings.SEAFARROAD_TEXT1[2],LocalStrings.SEAFARROAD_TEXT1[17]}
		GetElement(self.m_root, "txtRankTitleName", WZUILabelTTF):setText(title_name[self.m_nTabIndex])
		local showManCountLabel = GetElement(self.m_root,"showManCountLabel",WZUILabelTTF)
		local myCurRank = -1
		local myPoint = 0
		txtTitle3:setTextKey("")
		if self.m_nTabIndex == 1 then
			showManCountLabel:setText(string.format(LocalStrings.NEWYEAR_TEXT15,100))
			txtTitle3:setText(LocalStrings.SEAFARROAD_TEXT1[16])
			txtScoreTitle:setText(LocalStrings.SEAFARROAD_TEXT1[16] .. ":")
			if self.m_tSingleArrowList then 
				myCurRank = self.m_tSingleArrowList.myRank
				myPoint = self.m_tSingleArrowList.myPoint
			end
		elseif self.m_nTabIndex == 2 then
			showManCountLabel:setText(string.format(LocalStrings.NEWYEAR_TEXT15,20))
			txtTitle3:setText(LocalStrings.SEAFARROAD_TEXT1[33])
			txtScoreTitle:setText(LocalStrings.SEAFARROAD_TEXT1[33] .. ":")
			if self.m_tTeamArrowList then 
				myCurRank = self.m_tTeamArrowList.myRank
				myPoint = self.m_tTeamArrowList.myPoint
			end
		end
		if myCurRank < 0 then
			my_rank:setText(LocalStrings.NOT_IN_RANKLIST)
		else
			my_rank:setText(myCurRank)
		end
		my_score:setText(myPoint)
	elseif self.m_nRankType == 43 then 
		local title_name = {LocalStrings.CLIMBTREE_TEXT1[10],LocalStrings.CLIMBTREE_TEXT1[4]}
		GetElement(self.m_root, "txtRankTitleName", WZUILabelTTF):setText(title_name[self.m_nTabIndex])
		local showManCountLabel = GetElement(self.m_root,"showManCountLabel",WZUILabelTTF)
		local myCurRank = -1
		local myPoint = 0
		txtTitle3:setTextKey("")
		if self.m_nTabIndex == 1 then
			showManCountLabel:setText(string.format(LocalStrings.NEWYEAR_TEXT15,100))
			txtTitle3:setText(LocalStrings.CLIMBTREE_TEXT1[14])
			txtScoreTitle:setText(LocalStrings.CLIMBTREE_TEXT1[14] .. ":")
			if self.m_tSingleArrowList then 
				myCurRank = self.m_tSingleArrowList.myRank
				myPoint = self.m_tSingleArrowList.myPoint
			end
		elseif self.m_nTabIndex == 2 then
			showManCountLabel:setText(string.format(LocalStrings.NEWYEAR_TEXT15, 100))
			txtTitle3:setText(LocalStrings.CLIMBTREE_TEXT1[15])
			txtScoreTitle:setText(LocalStrings.CLIMBTREE_TEXT1[15] .. ":")
			if self.m_tTeamArrowList then 
				myCurRank = self.m_tTeamArrowList.myRank
				myPoint = self.m_tTeamArrowList.myPoint
			end
		end
		if myCurRank < 0 then
			my_rank:setText(LocalStrings.NOT_IN_RANKLIST)
		else
			my_rank:setText(myCurRank)
		end
		my_score:setText(myPoint)
	elseif self.m_nRankType == 44 then 
		local showManCountLabel = GetElement(self.m_root,"showManCountLabel",WZUILabelTTF)
		local myCurRank = -1
		local myPoint = 0
		txtTitle3:setTextKey("")
		if self.m_nTabIndex == 1 then
			showManCountLabel:setText(string.format(LocalStrings.NEWYEAR_TEXT15,100))
			txtTitle3:setText(LocalStrings.SUMMERSURF_TEXT1[14])
			txtScoreTitle:setText(LocalStrings.SUMMERSURF_TEXT1[14] .. ":")
			if self.m_tSingleArrowList then 
				myCurRank = self.m_tSingleArrowList.myRank
				myPoint = self.m_tSingleArrowList.myPoint
			end
		elseif self.m_nTabIndex == 2 then
			showManCountLabel:setText(string.format(LocalStrings.NEWYEAR_TEXT15, 100))
			txtTitle3:setText(LocalStrings.SUMMERSURF_TEXT1[15])
			txtScoreTitle:setText(LocalStrings.SUMMERSURF_TEXT1[15] .. ":")
			if self.m_tTeamArrowList then 
				myCurRank = self.m_tTeamArrowList.myRank
				myPoint = self.m_tTeamArrowList.myPoint
			end
		end
		if myCurRank < 0 then
			my_rank:setText(LocalStrings.NOT_IN_RANKLIST)
		else
			my_rank:setText(myCurRank)
		end
		my_score:setText(myPoint)
	elseif self.m_nRankType == 45 then 
		txtTitle3:setTextKey("")
		txtTitle3:setText(LocalStrings.PLANETSEARCH_TEXT1[14])
		txtScoreTitle:setText(LocalStrings.PLANETSEARCH_TEXT1[14] .. ":")
	elseif self.m_nRankType == 46 then 
		local title_name = {LocalStrings.TRAMPOLINE_TEXT1[17],LocalStrings.TRAMPOLINE_TEXT1[18]}
		GetElement(self.m_root, "txtRankTitleName", WZUILabelTTF):setText(title_name[self.m_nTabIndex])
		local showManCountLabel = GetElement(self.m_root,"showManCountLabel",WZUILabelTTF)
		local txtRankTitle = GetElement(self.m_root,"txtRankTitle",WZUILabelTTF)
		local myCurRank = -1
		local myPoint = 0
		txtTitle1:setTextKey("")
		txtTitle2:setTextKey("")
		txtTitle3:setTextKey("")
		txtRankTitle:setTextKey("")
		if self.m_nTabIndex == 1 then
			showManCountLabel:setText(string.format(LocalStrings.NEWYEAR_TEXT15,100))
			txtTitle1:setText(LocalStrings.RANK)
			txtTitle2:setText(LocalStrings.PLAYER)
			txtRankTitle:setText(LocalStrings.KING_RANK_MY_RANK)
			txtTitle3:setText(LocalStrings.TRAMPOLINE_TEXT1[19])
			txtScoreTitle:setText(LocalStrings.TRAMPOLINE_TEXT1[19] .. ":")
			if self.m_tSingleArrowList then 
				myCurRank = self.m_tSingleArrowList.myRank
				myPoint = self.m_tSingleArrowList.myPoint
			end
		elseif self.m_nTabIndex == 2 then
			showManCountLabel:setText(string.format(LocalStrings.TRAMPOLINE_TEXT1[32], 20))
			txtTitle1:setText(LocalStrings.TRAMPOLINE_TEXT1[27])
			txtTitle2:setText(LocalStrings.TRAMPOLINE_TEXT1[28])
			txtTitle3:setText(LocalStrings.TRAMPOLINE_TEXT1[31])
			txtRankTitle:setText(LocalStrings.TRAMPOLINE_TEXT1[29] .. ":")
			txtScoreTitle:setText(LocalStrings.TRAMPOLINE_TEXT1[30] .. ":")
			if self.m_tTeamArrowList then 
				myCurRank = self.m_tTeamArrowList.myRank
				myPoint = self.m_tTeamArrowList.myPoint
			end
		end
		if myCurRank < 0 then
			my_rank:setText(LocalStrings.NOT_IN_RANKLIST)
		else
			my_rank:setText(myCurRank)
		end
		my_score:setText(myPoint)
	elseif self.m_nRankType == 47 then 
		local title_name = {LocalStrings.GOLFBALL_TEXT1[17],LocalStrings.GOLFBALL_TEXT1[18]}
		GetElement(self.m_root, "txtRankTitleName", WZUILabelTTF):setText(title_name[self.m_nTabIndex])
		local showManCountLabel = GetElement(self.m_root,"showManCountLabel",WZUILabelTTF)
		local txtRankTitle = GetElement(self.m_root,"txtRankTitle",WZUILabelTTF)
		local myCurRank = -1
		local myPoint = 0
		txtTitle1:setTextKey("")
		txtTitle2:setTextKey("")
		txtTitle3:setTextKey("")
		txtRankTitle:setTextKey("")
		if self.m_nTabIndex == 1 then
			showManCountLabel:setText(string.format(LocalStrings.NEWYEAR_TEXT15,100))
			txtTitle1:setText(LocalStrings.RANK)
			txtTitle2:setText(LocalStrings.PLAYER)
			txtRankTitle:setText(LocalStrings.KING_RANK_MY_RANK)
			txtTitle3:setText(LocalStrings.GOLFBALL_TEXT1[29])
			txtScoreTitle:setText(LocalStrings.GOLFBALL_TEXT1[29] .. ":")
			if self.m_tSingleArrowList then 
				myCurRank = self.m_tSingleArrowList.myRank
				myPoint = self.m_tSingleArrowList.myPoint
			end
		elseif self.m_nTabIndex == 2 then
			showManCountLabel:setText(string.format(LocalStrings.ACTIVITY_TEXT201, 30))
			txtTitle1:setText(LocalStrings.GOLFBALL_TEXT1[23])
			txtTitle2:setText(LocalStrings.GOLFBALL_TEXT1[24])
			txtTitle3:setText(LocalStrings.GOLFBALL_TEXT1[25])
			txtRankTitle:setText(LocalStrings.GOLFBALL_TEXT1[23] .. ":")
			txtScoreTitle:setText(LocalStrings.GOLFBALL_TEXT1[32] .. ":")
			if self.m_tTeamArrowList then 
				myCurRank = self.m_tTeamArrowList.myRank
				myPoint = self.m_tTeamArrowList.myPoint
			end
		end
		if myCurRank < 0 then
			my_rank:setText(LocalStrings.NOT_IN_RANKLIST)
		else
			my_rank:setText(myCurRank)
		end
		my_score:setText(myPoint)
	elseif self.m_nRankType == 51 then 
		local title_name = {LocalStrings.GOLD_MINER_TEXT1[13],LocalStrings.GOLFBALL_TEXT1[18]}
		GetElement(self.m_root, "txtRankTitleName", WZUILabelTTF):setText(title_name[self.m_nTabIndex])
		local showManCountLabel = GetElement(self.m_root,"showManCountLabel",WZUILabelTTF)
		local txtRankTitle = GetElement(self.m_root,"txtRankTitle",WZUILabelTTF)
		local myCurRank = -1
		local myPoint = 0
		txtTitle1:setTextKey("")
		txtTitle2:setTextKey("")
		txtTitle3:setTextKey("")
		txtRankTitle:setTextKey("")
		if self.m_nTabIndex == 1 then
			showManCountLabel:setText(string.format(LocalStrings.NEWYEAR_TEXT15,100))
			txtTitle1:setText(LocalStrings.RANK)
			txtTitle2:setText(LocalStrings.PLAYER)
			txtRankTitle:setText(LocalStrings.KING_RANK_MY_RANK)
			txtTitle3:setText(LocalStrings.GOLD_MINER_TEXT1[14])
			txtScoreTitle:setText(LocalStrings.GOLD_MINER_TEXT1[14] .. ":")
			if self.m_tSingleArrowList then 
				myCurRank = self.m_tSingleArrowList.myRank
				myPoint = self.m_tSingleArrowList.myPoint
			end
		elseif self.m_nTabIndex == 2 then
			showManCountLabel:setText(string.format(LocalStrings.ACTIVITY_TEXT201, 30))
			txtTitle1:setText(LocalStrings.GOLFBALL_TEXT1[23])
			txtTitle2:setText(LocalStrings.GOLFBALL_TEXT1[24])
			txtTitle3:setText(LocalStrings.GOLD_MINER_TEXT1[14])
			txtRankTitle:setText(LocalStrings.GOLFBALL_TEXT1[23] .. ":")
			txtScoreTitle:setText(LocalStrings.GOLD_MINER_TEXT1[14] .. ":")
			if self.m_tTeamArrowList then 
				myCurRank = self.m_tTeamArrowList.myRank
				myPoint = self.m_tTeamArrowList.myPoint
			end
		end
		if myCurRank < 0 then
			my_rank:setText(LocalStrings.NOT_IN_RANKLIST)
		else
			my_rank:setText(myCurRank)
		end
		my_score:setText(myPoint)
	elseif self.m_nRankType == 54 then 
		local title_name = {LocalStrings.TRAMPOLINE_TEXT1[17],LocalStrings.TRAMPOLINE_TEXT1[18]}
		GetElement(self.m_root, "txtRankTitleName", WZUILabelTTF):setText(title_name[self.m_nTabIndex])
		local showManCountLabel = GetElement(self.m_root,"showManCountLabel",WZUILabelTTF)
		local txtRankTitle = GetElement(self.m_root,"txtRankTitle",WZUILabelTTF)
		local myCurRank = -1
		local myPoint = 0
		txtTitle1:setTextKey("")
		txtTitle2:setTextKey("")
		txtTitle3:setTextKey("")
		txtRankTitle:setTextKey("")
		if self.m_nTabIndex == 1 then
			showManCountLabel:setText(string.format(LocalStrings.NEWYEAR_TEXT15,100))
			txtTitle1:setText(LocalStrings.RANK)
			txtTitle2:setText(LocalStrings.PLAYER)
			txtRankTitle:setText(LocalStrings.KING_RANK_MY_RANK)
			txtTitle3:setText(LocalStrings.CHESS_ACTIVITY_TEXT1[11])
			txtScoreTitle:setText(LocalStrings.CHESS_ACTIVITY_TEXT1[11] .. ":")
			if self.m_tSingleArrowList then 
				myCurRank = self.m_tSingleArrowList.myRank
				myPoint = self.m_tSingleArrowList.myPoint
			end
		elseif self.m_nTabIndex == 2 then
			showManCountLabel:setText(string.format(LocalStrings.TRAMPOLINE_TEXT1[32], 20))
			txtTitle1:setText(LocalStrings.TRAMPOLINE_TEXT1[27])
			txtTitle2:setText(LocalStrings.TRAMPOLINE_TEXT1[28])
			txtTitle3:setText(LocalStrings.TRAMPOLINE_TEXT1[31])
			txtRankTitle:setText(LocalStrings.TRAMPOLINE_TEXT1[29] .. ":")
			txtScoreTitle:setText(LocalStrings.TRAMPOLINE_TEXT1[30] .. ":")
			if self.m_tTeamArrowList then 
				myCurRank = self.m_tTeamArrowList.myRank
				myPoint = self.m_tTeamArrowList.myPoint
			end
		end
		if myCurRank < 0 then
			my_rank:setText(LocalStrings.NOT_IN_RANKLIST)
		else
			my_rank:setText(myCurRank)
		end
		my_score:setText(myPoint)
	elseif self.m_nRankType == 63 then
		local btnTeamReward = GetElement(self.m_root, "btnTeamReward_WndShopRank", WZUIButton) 
		local txtRankTitle = GetElement(self.m_root,"txtRankTitle",WZUILabelTTF)
		local title_name = {LocalStrings.KICKING_BIRDIE_TEXT1[19],LocalStrings.KICKING_BIRDIE_TEXT1[20]}
		GetElement(self.m_root, "txtRankTitleName", WZUILabelTTF):setText(title_name[self.m_nTabIndex])
		if self.m_nTabIndex == 1 then
			removeShowPanelNullTip(GetElement(self.m_root, "conInterface_WndShopRank", WZUIContainer))
			GetElement(self.m_root, "conForTask_WndShopRank", WZUIContainer):setVisible(true)
			GetElement(self.m_root, "conContent_WndShopRank", WZUIContainer):setVisible(false)
		elseif self.m_nTabIndex == 2 then
			GetElement(self.m_root, "conForTask_WndShopRank", WZUIContainer):setVisible(false)
			GetElement(self.m_root, "conContent_WndShopRank", WZUIContainer):setVisible(true)
			GetElement(self.m_root, "imgTeamReward_WndShopRank", WZUIImage):setVisible(false)
			local conTeamRewardWord = GetElement(self.m_root, "conTeamRewardWord_WndShopRank", WZUIContainer)
			conTeamRewardWord:setVisible(true)
			local txtTeamReward = GetElement(self.m_root, "txtTeamRewardWord_WndShopRank", WZUILabelTTF)
			txtTeamReward:setText(LocalStrings.KICKING_BIRDIE_TEXT1[27])
			txtTeamReward:setVisible(true)
			btnTeamReward:setVisible(true)
			btnTeamReward:setRelativePosition(GlobalMethod:ccp(0.89, 0.5))
			txtTitle1:setTextKey("")
			txtTitle1:setText(LocalStrings.KICKING_BIRDIE_TEXT1[22])
			txtTitle2:setTextKey("")
			txtTitle2:setText(LocalStrings.KICKING_BIRDIE_TEXT1[23])
			txtTitle2:setRelativePosition(GlobalMethod:ccp(0.48, 0.5))
			txtTitle3:setTextKey("")
			txtTitle3:setText(LocalStrings.KICKING_BIRDIE_TEXT1[24])
			txtTitle3:setRelativePosition(GlobalMethod:ccp(0.88, 0.5))
			txtTitle4:setTextKey("")
			txtTitle4:setText("")
			txtScoreTitle:setText(LocalStrings.KICKING_BIRDIE_TEXT1[25] .. ":")
			txtRankTitle:setTextKey("")
			txtRankTitle:setText(LocalStrings.KICKING_BIRDIE_TEXT1[26] .. ":")
			txtRankTitle:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
		end
	elseif self.m_nRankType == 71 then
		local btnTeamReward = GetElement(self.m_root, "btnTeamReward_WndShopRank", WZUIButton) 
		local txtRankTitle = GetElement(self.m_root,"txtRankTitle",WZUILabelTTF)
		local title_name = {LocalStrings.BUILDING_BLOCKS_TEXT1[5],LocalStrings.BUILDING_BLOCKS_TEXT1[9]}
		GetElement(self.m_root, "txtRankTitleName", WZUILabelTTF):setText(title_name[self.m_nTabIndex])
		if self.m_nTabIndex == 1 then
			removeShowPanelNullTip(GetElement(self.m_root, "conInterface_WndShopRank", WZUIContainer))
			GetElement(self.m_root, "conForTask_WndShopRank", WZUIContainer):setVisible(true)
			GetElement(self.m_root, "conContent_WndShopRank", WZUIContainer):setVisible(false)
		elseif self.m_nTabIndex == 2 then
			GetElement(self.m_root, "conForTask_WndShopRank", WZUIContainer):setVisible(false)
			GetElement(self.m_root, "conContent_WndShopRank", WZUIContainer):setVisible(true)
			GetElement(self.m_root, "imgTeamReward_WndShopRank", WZUIImage):setVisible(false)
			local conTeamRewardWord = GetElement(self.m_root, "conTeamRewardWord_WndShopRank", WZUIContainer)
			conTeamRewardWord:setVisible(true)
			local txtTeamReward = GetElement(self.m_root, "txtTeamRewardWord_WndShopRank", WZUILabelTTF)
			txtTeamReward:setText(LocalStrings.BUILDING_BLOCKS_TEXT1[15])
			txtTeamReward:setVisible(true)
			btnTeamReward:setVisible(true)
			btnTeamReward:setRelativePosition(GlobalMethod:ccp(0.89, 0.5))
			txtTitle1:setTextKey("")
			txtTitle1:setText(LocalStrings.BUILDING_BLOCKS_TEXT1[17])
			txtTitle2:setTextKey("")
			txtTitle2:setText(LocalStrings.BUILDING_BLOCKS_TEXT1[18])
			txtTitle2:setRelativePosition(GlobalMethod:ccp(0.48, 0.5))
			txtTitle3:setTextKey("")
			txtTitle3:setText(LocalStrings.BUILDING_BLOCKS_TEXT1[19])
			txtTitle3:setRelativePosition(GlobalMethod:ccp(0.88, 0.5))
			txtTitle4:setTextKey("")
			txtTitle4:setText("")
			txtScoreTitle:setText(LocalStrings.BUILDING_BLOCKS_TEXT1[20] .. ":")
			txtRankTitle:setTextKey("")
			txtRankTitle:setText(LocalStrings.BUILDING_BLOCKS_TEXT1[16] .. ":")
			txtRankTitle:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
		end
	elseif self.m_nRankType == 73 then
		local btnTeamReward = GetElement(self.m_root, "btnTeamReward_WndShopRank", WZUIButton) 
		local txtRankTitle = GetElement(self.m_root,"txtRankTitle",WZUILabelTTF)
		local title_name = {LocalStrings.CASTING_MASTER_ACTIVITY_TEXT1[11],LocalStrings.CASTING_MASTER_ACTIVITY_TEXT1[12]}
		GetElement(self.m_root, "txtRankTitleName", WZUILabelTTF):setText(title_name[self.m_nTabIndex])
		if self.m_nTabIndex == 1 then
			removeShowPanelNullTip(GetElement(self.m_root, "conInterface_WndShopRank", WZUIContainer))
			GetElement(self.m_root, "conForTask_WndShopRank", WZUIContainer):setVisible(true)
			GetElement(self.m_root, "conContent_WndShopRank", WZUIContainer):setVisible(false)
		elseif self.m_nTabIndex == 2 then
			GetElement(self.m_root, "conForTask_WndShopRank", WZUIContainer):setVisible(false)
			GetElement(self.m_root, "conContent_WndShopRank", WZUIContainer):setVisible(true)
			GetElement(self.m_root, "imgTeamReward_WndShopRank", WZUIImage):setVisible(false)
			local conTeamRewardWord = GetElement(self.m_root, "conTeamRewardWord_WndShopRank", WZUIContainer)
			conTeamRewardWord:setVisible(true)
			conTeamRewardWord:setAbsContentSize(CCSize(120,6))
			conTeamRewardWord:updateRelativeSize()
			local txtTeamReward = GetElement(self.m_root, "txtTeamRewardWord_WndShopRank", WZUILabelTTF)
			txtTeamReward:setText(LocalStrings.CASTING_MASTER_ACTIVITY_TEXT1[13])
			txtTeamReward:setVisible(true)
			btnTeamReward:setVisible(true)
			btnTeamReward:setRelativePosition(GlobalMethod:ccp(0.89, 0.5))
			txtTitle1:setTextKey("")
			txtTitle1:setText(LocalStrings.CASTING_MASTER_ACTIVITY_TEXT1[14])
			txtTitle2:setTextKey("")
			txtTitle2:setText(LocalStrings.CASTING_MASTER_ACTIVITY_TEXT1[15])
			txtTitle2:setRelativePosition(GlobalMethod:ccp(0.48, 0.5))
			txtTitle3:setTextKey("")
			txtTitle3:setText(LocalStrings.CASTING_MASTER_ACTIVITY_TEXT1[16])
			txtTitle3:setRelativePosition(GlobalMethod:ccp(0.88, 0.5))
			txtTitle4:setTextKey("")
			txtTitle4:setText("")
			txtScoreTitle:setText(LocalStrings.CASTING_MASTER_ACTIVITY_TEXT1[17] .. ":")
			txtRankTitle:setTextKey("")
			txtRankTitle:setText(LocalStrings.CASTING_MASTER_ACTIVITY_TEXT1[18] .. ":")
			txtRankTitle:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
		end
	end
end

--@brief 	显示红点
function WndShopRank:_showRedDot()
	--body
	if self.m_nRankType == 12 then 
		local imgInviteRedDot = GetElement(self.m_root, "imgInviteRedDot_WndShopRank", WZUIImage)
		if GlobalGame.g_tRedPointTypeList[17020] then 
			imgInviteRedDot:setVisible(true)
		else
			imgInviteRedDot:setVisible(false)
		end
	elseif self.m_nRankType == 36 then 
		local imgTaskRed = GetElement(self.m_root, "imgTaskRed_WndShopRank", WZUIImage)
		if GlobalGame.g_tRedPointTypeList[237061] then 
			imgTaskRed:setVisible(true)
		else
			imgTaskRed:setVisible(false)
		end
	elseif self.m_nRankType == 63 then 
		local imgTaskRed = GetElement(self.m_root, "imgTaskRed_WndShopRank", WZUIImage)
		if GlobalGame.g_tRedPointTypeList[237097] then 
			imgTaskRed:setVisible(true)
		else
			imgTaskRed:setVisible(false)
		end
	elseif self.m_nRankType == 71 then 
		local imgTaskRed = GetElement(self.m_root, "imgTaskRed_WndShopRank", WZUIImage)
		if GlobalGame.g_tRedPointTypeList[237104] then 
			imgTaskRed:setVisible(true)
		else
			imgTaskRed:setVisible(false)
		end
	elseif self.m_nRankType == 73 then 
		local imgTaskRed = GetElement(self.m_root, "imgTaskRed_WndShopRank", WZUIImage)
		if GlobalGame.g_tRedPointTypeList[237105] then 
			imgTaskRed:setVisible(true)
		else
			imgTaskRed:setVisible(false)
		end
	end
end

--@brief 	设置度假村全服榜数据
function WndShopRank:_onHVRankResult(synType, myRank, playerId, serverId, playerName, playerLevel, headId, faceId, sex, headColor, headEffectId, vipLevel, goodNums, achieId, hvCoolValue)
	if synType == 0 then 
		local tData = {}
		for i = 1, #playerId do
			local tab = {}
			tab.rank_index = i
			tab.playerId = playerId[i]
			tab.level = playerLevel[i]
			tab.point = hvCoolValue[i]
			tab.name = playerName[i]
			tab.faceId = faceId[i]
			tab.headId = headId[i]
			tab.headColor = headColor[i]
			tab.sex = sex[i]
			tab.headEffectId = headEffectId[i]
			tab.goodNums = goodNums[i]
			tab.achieId = achieId[i]
			if vipLevel then 
				tab.vipLevel = vipLevel[i]
			end
			if serverId then 
				tab.serverId = serverId[i]
			end

			table.insert(tData, tab)
		end
		local shopItemFreeList = GetElement(self.m_root,"shopItemFreeListContainer",WZUIFreeListContainer)
		shopItemFreeList:removeAll()
		local my_rank = GetElement(self.m_root,"my_rank",WZUILabelTTF)
		if myRank < 0 then
			my_rank:setText(LocalStrings.NOT_IN_RANKLIST)
		else
			my_rank:setText(myRank)
		end
		local my_score = GetElement(self.m_root,"my_score",WZUILabelTTF)
		local myPoint = SceneHolidayVillage:getHostInfo() and SceneHolidayVillage:getHostInfo().hvCoolValue and SceneHolidayVillage:getHostInfo().hvCoolValue or 0
		my_score:setText(myPoint)
		if tData == nil or #tData == 0 then
			ShowPanelNullTip(shopItemFreeList, LocalStrings.CHARM_RESULT)
			return
		end

		for i = 1, #tData do
			local element, tLuaObj = CellShopRankItem:createElement()
			shopItemFreeList:pushBack(WZUIContainer:luaTo(element))
			shopItemFreeList:getMoveElement():setPositionY(shopItemFreeList:getMinPosition().y)
			tLuaObj:setShopRankMessage(i,tData[i],self.m_nRankType)
		end
	elseif synType == 2 then 
		local my_rank = GetElement(self.m_root,"my_rank",WZUILabelTTF)
		if myRank < 0 then
			my_rank:setText(LocalStrings.NOT_IN_RANKLIST)
		else
			my_rank:setText(myRank)
		end
		local my_score = GetElement(self.m_root,"my_score",WZUILabelTTF)
		local myPoint = SceneHolidayVillage:getHostInfo().hvCoolValue
		my_score:setText(myPoint)
		for i = 1, #playerId do
			if self.m_tCellData and self.m_tCellData.playerId == playerId[i] then 
				local tab = self.m_tCellData

				tab.level = playerLevel[i]
				tab.point = hvCoolValue[i]
				tab.goodNums = goodNums[i]
				tab.achieId = achieId[i]

				if self.m_tCellClick then 
					self.m_tCellClick:showAchieAndGoodNum(tab)
				end
			end
		end
	end
end

--@brief 	显示相应界面
function WndShopRank:_showTaskContent()
	-- body
	local conForTask = GetElement(self.m_root, "conForTask_WndShopRank", WZUIContainer)
	conForTask:removeAllChildrenWithCleanup(true)
	conForTask:setVisible(true)
	
	local panel = nil
	if self.m_nRankType == 36 then
		panel = CellNewYearTaskOther:createElement(self.m_tSingleArrowList, 20)
	elseif self.m_nRankType == 63 then
		panel = CellNewYearTaskOther:createElement(self.m_tSingleArrowList, 44)
	elseif self.m_nRankType == 71 then
		panel = CellNewYearTaskOther:createElement(self.m_tSingleArrowList, 51)
	elseif self.m_nRankType == 73 then
		panel = CellNewYearTaskOther:createElement(self.m_tSingleArrowList, 52)
	end
	if panel then
		conForTask:addChild(panel)
	end
end

--@brief 	射箭任务奖励
function WndShopRank:_onGetTaskResult(activityId, id)
--	WZLog("WndShopRank:_onGetTaskResult", self.m_nActivityId, activityId, id)
	if self.m_nActivityId ~= activityId then
		MsgBoxManager:showTipBox(LocalStrings.RETURNEE_TEXT28)
		return
	end
	
	local taskData = GDatatab_new_activity_task["id_" .. id]
	if taskData and taskData.group_by == 3 then
		if self.m_nRankType == 36 or self.m_nRankType == 63 or self.m_nRankType == 71 or self.m_nRankType == 73 then 
			CellNewYearTaskOther:setTeskGetResult(id)
			CellNewYearTaskOther:setRedPoint(GetElement(self.m_root, "imgTaskRed_WndShopRank", WZUIImage))
		end
	end
end
-------------------------------------私有方法模块End----------------------------------------
-------------------------------------语言适配Begin----------------------------------------

function WndShopRank:_adaptLanguage_vn()
	local txtTitle1 = GetElement(self.m_root, "txtTitle1_WndShopRank", WZUILabelTTF)
	local txtTitle2 = GetElement(self.m_root, "txtTitle2_WndShopRank", WZUILabelTTF)
	local txtChangeTitle = GetElement(self.m_root, "txtChangeTitle", WZUILabelTTF)
	local txtTitle4 = GetElement(self.m_root, "txtTitle4_WndShopRank", WZUILabelTTF)
	local txtTitle5 = GetElement(self.m_root, "txtTitle5_WndShopRank", WZUILabelTTF)
	txtTitle1:setScale(0.8)
	txtTitle2:setScale(0.8)
	txtChangeTitle:setScale(0.8)
	txtTitle4:setScale(0.8)
	txtTitle5:setScale(0.8)

	-- GetElement(self.m_root,"txtScoreTitle",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.105,0.5))


	local txtCheck1 = GetElement(self.m_root, "txtCheck1_WndShopRank", WZUILabelTTF)
	txtCheck1:setDimensions(GlobalMethod:CCSize(160,0))
	txtCheck1:setScale(0.7)
	local txtCheckSel1 = GetElement(self.m_root, "txtCheckSel1_WndShopRank", WZUILabelTTF)
	txtCheckSel1:setDimensions(GlobalMethod:CCSize(160,0))
	txtCheckSel1:setScale(0.7)
	local txtCheck2 = GetElement(self.m_root, "txtCheck2_WndShopRank", WZUILabelTTF)
	txtCheck2:setDimensions(GlobalMethod:CCSize(160,0))
	txtCheck2:setScale(0.7)
	local txtCheckSel2 = GetElement(self.m_root, "txtCheckSel2_WndShopRank", WZUILabelTTF)
	txtCheckSel2:setDimensions(GlobalMethod:CCSize(160,0))
	txtCheckSel2:setScale(0.7)

	if self.m_nRankType == 37 or self.m_nRankType == 90 then
		GetElement(self.m_root,"txtRankTitle",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.82,0.5))
	elseif self.m_nRankType == 41 then
		GetElement(self.m_root,"txtRankTitle",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.88,0.5))
	elseif self.m_nRankType == 63 then
		GetElement(self.m_root, "txtTeamRewardWord_WndShopRank", WZUILabelTTF):setScale(0.6)
	elseif self.m_nRankType == 71 or self.m_nRankType == 73 then
		GetElement(self.m_root, "btnTeamReward_WndShopRank", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.87, 0.5))
		GetElement(self.m_root, "txtTeamRewardWord_WndShopRank", WZUILabelTTF):setScale(0.6)
	end
end

-------------------------------------语言适配End----------------------------------------
