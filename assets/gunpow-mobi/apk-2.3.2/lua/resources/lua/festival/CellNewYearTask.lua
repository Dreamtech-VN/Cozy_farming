--CellNewYearTask.lua
--@brief	CellNewYearTask的UI模块
--@date		2020/12/01
--@author	hyx
--@note		元旦求签任务


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellNewYearTask:onEnter(element)
	self.m_root = element
	self:register()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellNewYearTask:onExit(element)
	if self.m_tTabChangeContainer and next(self.m_tTabChangeContainer) ~= nil then
		for i,v in pairs(self.m_tTabChangeContainer) do
			if v then
				v:removeFromParentAndCleanup(true)
			end
		end
	end	 
	self:_unInit()
	self:unregister()
end
function CellNewYearTask:register()
	if self.m_nType == 0 then 
		GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_NewYearTaskInfo,self._onGetNewYearTaskInfo,self)
		GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_NewYearTaskGet,self._onGetNewYearTaskGetResult,self)
	else
		GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetTaskList,self._onGetTaskInfo,self)
		GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetResult,self._onGetTaskResult,self)
	end
end
function CellNewYearTask:unregister()
	if self.m_nType == 0 then 
		GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_NewYearTaskInfo,self._onGetNewYearTaskInfo,self)
		GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_NewYearTaskGet,self._onGetNewYearTaskGetResult,self)
	else
		GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetTaskList,self._onGetTaskInfo,self)
		GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetResult,self._onGetTaskResult,self)
	end
end
function CellNewYearTask:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,false,"actionCallback",self)
end
function CellNewYearTask:actionCallback()
	self:initShow()
end
function CellNewYearTask:initShow()
	local tab_container = GetElement(self.m_root,"tab_container",WZUIContainer)
	local nTaskCount = 2 
	--三个任务页签的活动要加
	local tTempList = {9, 10, 11, 16, 18, 21, 22, 23, 24, 25, 29, 30, 31, 34, 36, 39, 46, 47, 49, 53, 54}
	if utilsValueInTable(self.m_nType, tTempList) then 
		nTaskCount = 3
		if ProjConfig.LANGUAGE == "vn" then
			if self.m_nType == 11 then
				nTaskCount = 2
			end
		end
	elseif self.m_tOtherData then 
		nTaskCount = self.m_tOtherData.taskCount 
	end
	for i=1, nTaskCount do
		GetElement(self.m_root, "tab_" .. i .. "_CellNewYearTask", WZUIContainer):setVisible(true)	
		local tab = {}
		tab.normal = GetElement(self.m_root,"normal_"..i,WZUI9Image)
		tab.select = GetElement(self.m_root,"select_"..i,WZUI9Image)
		tab.select:setVisible(false)
		tab.title = GetElement(self.m_root,"title_"..i,WZUILabelTTF)
		self.m_tCellTitleTab[i] = tab
		local bIsDefaultTab = true 
		if self.m_nType == 6 then 
			tab.title:setTextKey("")
			tab.title:setText(LocalStrings.BEATENGINEER_TEXT1[18 + i])
		elseif self.m_nType == 7 then 
			tab.title:setTextKey("")
			tab.title:setText(LocalStrings.BEATENGINEER_TEXT1[16 + i])
		elseif self.m_nType == 8 then 
			tab.title:setTextKey("")
			tab.title:setText(LocalStrings.ALCHEMY_TEXT1[8 + i])
		elseif self.m_nType == 9 then 
			if i == 3 then 
				tab.title:setText(LocalStrings.BEATMICE_TEXT1[2])
			end
		elseif self.m_nType == 10 then 
			if i == 3 then 
				tab.title:setText(LocalStrings.SETCIRCLE_TEXT1[2])
			else
				tab.title:setTextKey("")
				tab.title:setText(LocalStrings.SETCIRCLE_TEXT1[10 + i])
			end
			if ProjConfig.LANGUAGE == "vn" then
				if i == 3 then
					GetElement(self.m_root, "tab_" .. i .. "_CellNewYearTask", WZUIContainer):setVisible(false)	
				end
			end
		elseif self.m_nType == 11 then 
			if i == 3 then 
				tab.title:setText(LocalStrings.GARDEN_TEXT1[2])
			else
				tab.title:setTextKey("")
				tab.title:setText(LocalStrings.GARDEN_TEXT1[10 + i])
			end
		elseif self.m_nType == 12 then 
			tab.title:setTextKey("")
			tab.title:setText(LocalStrings.CAFFEE_TEXT1[8 + i])
		elseif self.m_nType == 13 then 
			tab.title:setTextKey("")
			tab.title:setText(LocalStrings.BOWLING_TEXT1[8 + i])
			tab.normal:setFile("ui/activity/common_btn_40.png")
			tab.select:setFile("ui/activity/common_btn_39.png")
			bIsDefaultTab = false 
		elseif self.m_nType == 14 then 
			tab.title:setTextKey("")
			tab.title:setText(LocalStrings.WATERMELON_TEXT1[7 + i])
		elseif self.m_nType == 15 then 
			tab.title:setTextKey("")
			tab.title:setText(LocalStrings.SECRETTOWER_TEXT1[8 + i])
		elseif self.m_nType == 16 then 
			if i == 3 then 
				tab.title:setText(LocalStrings.BILLIARDBALL_TEXT1[2])
			end
		elseif self.m_nType == 17 then 
			tab.title:setTextKey("")
			tab.title:setText(LocalStrings.CRAZY_GASHAPON_TEXT3[1 + i])
		elseif self.m_nType == 18 then 
			tab.title:setTextKey("")
			tab.title:setText(LocalStrings.MIDNIGHTDINER_TEXT1[10 + i])
		elseif self.m_nType == 19 then 
			tab.title:setTextKey("")
			tab.title:setText(LocalStrings.GOPHERBALL_TEXT1[10 + i])
		elseif self.m_nType == 20 then 
			tab.title:setTextKey("")
			tab.title:setText(LocalStrings.BEINGIMMORTAL_TEXT1[10 + i])
		elseif self.m_nType == 21 then 
			tab.normal:setFile("ui/newActivity/common_btn_bcs_06.png")
			tab.select:setFile("ui/newActivity/common_btn_bcs_05.png")
			tab.title:setTextKey("")
			tab.title:setColor(GlobalMethod:ccc3(229,105,22))
			tab.title:setText(LocalStrings.WORSHIPGOD_TEXT1[10 + i])
			bIsDefaultTab = false 
		elseif self.m_nType == 22 then 
			tab.title:setTextKey("")
			tab.title:setText(LocalStrings.CALABASH_TEXT1[10 + i])
		elseif self.m_nType == 23 then 
			tab.title:setTextKey("")
			tab.title:setText(LocalStrings.SPRINGOUTING_TEXT1[10 + i])
		elseif self.m_nType == 24 then 
			tab.title:setTextKey("")
			tab.title:setText(LocalStrings.BEATBALLOON_TEXT1[10 + i])
		elseif self.m_nType == 25 then 
			tab.title:setTextKey("")
			tab.title:setText(LocalStrings.SEAFARROAD_TEXT1[10 + i])
		elseif self.m_nType == 26 then 
			tab.title:setTextKey("")
			tab.title:setText(LocalStrings.CLIMBTREE_TEXT1[10 + i])
			tab.normal:setFile("ui/newActivity/common_btn_61.png")
			tab.select:setFile("ui/newActivity/common_btn_60.png")
			bIsDefaultTab = false 
		elseif self.m_nType == 27 then 
			tab.title:setTextKey("")
			tab.title:setText(LocalStrings.SUMMERSURF_TEXT1[10 + i])
		elseif self.m_nType == 28 then 
			tab.title:setTextKey("")
			tab.title:setText(LocalStrings.PLANETSEARCH_TEXT1[10 + i])
			tab.normal:setFile("ui/newActivity/common_btn_65.png")
			tab.select:setFile("ui/newActivity/common_btn_64.png")
			tab.title:setColor(GlobalMethod:ccc3(143,178,232))
			bIsDefaultTab = false 
		elseif self.m_nType == 29 then 
			tab.title:setTextKey("")
			tab.title:setText(LocalStrings.TRAMPOLINE_TEXT1[9 + i])
		elseif self.m_nType == 30 then 
			tab.title:setTextKey("")
			tab.title:setText(LocalStrings.GOLFBALL_TEXT1[9 + i])
		elseif self.m_nType == 31 then
			tab.title:setTextKey("")
			tab.title:setText(LocalStrings.WISHING_BOTTLE_TEXT1[15 + i])
		elseif self.m_nType == 32 then 
			tab.title:setTextKey("")
			tab.title:setText(LocalStrings.DETECTIVE_TEXT1[9 + i])
		elseif self.m_nType == 33 then 
			tab.title:setTextKey("")
			tab.title:setText(LocalStrings.GONGANDDRUM_TEXT1[9 + i])
		elseif self.m_nType == 34 then 
			tab.title:setTextKey("")
			tab.title:setText(LocalStrings.GOLD_MINER_TEXT1[8 + i])
		elseif self.m_nType == 35 then 
			tab.title:setTextKey("")
			tab.title:setText(LocalStrings.DEEPSEA_TEXT1[9 + i])
		elseif self.m_nType == 36 then 
			tab.title:setTextKey("")
			tab.title:setText(LocalStrings.CHESS_ACTIVITY_TEXT1[11 + i])
		elseif self.m_nType == 37 then 
			tab.title:setTextKey("")
			tab.title:setText(LocalStrings.HOTBASKETBALL_TEXT1[9 + i])
			tab.normal:setFile("ui/activity/common_btn_40.png")
			tab.select:setFile("ui/activity/common_btn_39.png")
			bIsDefaultTab = false 
		elseif self.m_nType == 38 then 
			tab.title:setTextKey("")
			tab.title:setText(LocalStrings.AUTUMNCAMP_TEXT1[9 + i])
		elseif self.m_nType == 39 then 
			tab.title:setTextKey("")
			tab.title:setText(LocalStrings.FLYKITES_TEXT1[8 + i])
		elseif self.m_nType == 40 then 
			tab.title:setTextKey("")
			tab.title:setText(LocalStrings.THROWPOT_TEXT1[9 + i])
		elseif self.m_nType == 41 then 
			tab.normal:setFile("ui/common/common_btn_69.png")
			tab.select:setFile("ui/common/common_btn_68.png")
			tab.title:setTextKey("")
			tab.title:setText(LocalStrings.CATCHFISH_TEXT1[9 + i])
			bIsDefaultTab = false 
		elseif self.m_nType == 42 then 
			tab.title:setTextKey("")
			tab.title:setText(LocalStrings.BIKEMATCH_TEXT1[9 + i])
		elseif self.m_nType == 43 then 
			tab.title:setTextKey("")
			tab.title:setText(LocalStrings.LASHTOP_TEXT1[9 + i])
		elseif self.m_nType == 44 then 
			tab.title:setTextKey("")
			tab.title:setText(LocalStrings.KICKING_BIRDIE_TEXT1[11 + i])
		elseif self.m_nType == 45 then
			bIsDefaultTab = false 
			tab.normal:setFile("ui/common/common_btn_69.png")
			tab.select:setFile("ui/common/common_btn_68.png")
			tab.title:setTextKey("")
			tab.title:setText(LocalStrings.MAGIC_CLASSROOM_TEXT1[12 + i])
		elseif self.m_nType == 46 then
			bIsDefaultTab = false 
			tab.normal:setFile("ui/common/common_btn_69.png")
			tab.select:setFile("ui/common/common_btn_68.png")
			tab.title:setTextKey("")
			local tTitleText = {LocalStrings.MAKE_SHOWMAN_TEXT1[13], LocalStrings.MAKE_SHOWMAN_TEXT1[14], LocalStrings.MAKE_SHOWMAN_TEXT1[23]}
			tab.title:setText(tTitleText[i])
		elseif self.m_nType == 47 then 
			tab.title:setTextKey("")
			tab.title:setText(LocalStrings.PIANIST_TEXT1[11 + i])
		elseif self.m_nType == 48 then
			tab.title:setTextKey("")
			tab.title:setText(LocalStrings.CERAMIC_WORKSHOP_TEXT1[10 + i])
		elseif self.m_nType == 49 then
			bIsDefaultTab = false 
			tab.normal:setFile("ui/common/common_btn_69.png")
			tab.select:setFile("ui/common/common_btn_68.png")
			tab.title:setTextKey("")
			tab.title:setText(LocalStrings.WEIGHTLIFTING_TEXT1[11 + i])
		elseif self.m_nType == 50 then
			bIsDefaultTab = false 
			tab.normal:setFile("ui/common/common_btn_69.png")
			tab.select:setFile("ui/common/common_btn_68.png")
			tab.title:setTextKey("")
			tab.title:setText(LocalStrings.ARCTIC_EXPLORATION_TEXT1[10 + i])
		elseif self.m_nType == 51 then 
			tab.title:setTextKey("")
			local tTitleText = {LocalStrings.BUILDING_BLOCKS_TEXT1[8], LocalStrings.BUILDING_BLOCKS_TEXT1[4]}
			tab.title:setText(tTitleText[i])
		elseif self.m_nType == 52 then
			tab.title:setTextKey("")
			local tTitleText = {LocalStrings.CASTING_MASTER_ACTIVITY_TEXT1[7], LocalStrings.CASTING_MASTER_ACTIVITY_TEXT1[8]}
			tab.title:setText(tTitleText[i])
		elseif self.m_nType == 53 then
			tab.title:setTextKey("")
			local tTitleText = {LocalStrings.BOATING_LAKE_TEXT1[10], LocalStrings.BOATING_LAKE_TEXT1[11], LocalStrings.BOATING_LAKE_TEXT1[12]}
			tab.title:setText(tTitleText[i])
		elseif self.m_nType == 54 then
			bIsDefaultTab = false 
			tab.normal:setFile("ui/common/common_btn_69.png")
			tab.select:setFile("ui/common/common_btn_68.png")
			tab.title:setTextKey("")
			local tTitleText = {LocalStrings.BLOW_BUBBLES_TEXT1[12], LocalStrings.BLOW_BUBBLES_TEXT1[13], LocalStrings.BLOW_BUBBLES_TEXT1[14]}
			tab.title:setText(tTitleText[i])
		elseif self.m_tOtherData then 
			tab.title:setTextKey("")
			tab.title:setText(self.m_tOtherData.tTaskTypeName[i])
			if self.m_tOtherData.normal then 
				bIsDefaultTab = false 
				tab.normal:setFile(self.m_tOtherData.normal)
			end
			if self.m_tOtherData.select then 
				tab.select:setFile(self.m_tOtherData.select)
			end
		end

		if bIsDefaultTab then 
			tab.normal:setFile("ui/common/common_btn_21.png")
			tab.select:setFile("ui/common/common_btn_20.png")
		end
	end
	self.m_sDesContainer = GetElement(self.m_root,"des_container",WZUIContainer)
	self.m_sImageDayRedPoint = GetElement(self.m_root,"imageDayRedPoint",WZUIImage)
	self.m_sImageGrowupRedPoint = GetElement(self.m_root,"imageGrowupRedPoint",WZUIImage)
	self.m_imgRedPoint3 = GetElement(self.m_root,"imageRedPoint3_CellNewYearTask",WZUIImage)
	local txtTitle = GetElement(self.m_root, "txtTitle_CellNewYearTask", WZUILabelTTF)
	local img9Bg = GetElement(self.m_root, "img9Bg_CellNewYearTask", WZUI9Image)
	local imgBtnClose = GetElement(self.m_root, "imgBtnClose_CellNewYearTask", WZUIImage)
	local defaultType = {13, 17, 21, 26, 28, 37}
	if not utilsValueInTable(self.m_nType, defaultType) then 
		img9Bg:setFile("ui/common/frame_tc_xiao.png")
	end
	local tTempType = {1,4,5,6,7,8,9,10,11,12,14,15,19,32,33,35,37,40,41,42,43,45,48,50}
	if self.m_nType == 0 then 
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_Activity6120TaskList( )
	else
		txtTitle:setTextKey("")
		if utilsValueInTable(self.m_nType, tTempType) then 
			-- local titleType = {title1=LocalStrings.SHOOTARROW_TEXT8,title4=LocalStrings.TASK_UINAME,title5=LocalStrings.YEARMONSTER_TEXT1[2],title6=LocalStrings.NEWYEARWISH_TEXT1[2],title7=LocalStrings.BEATENGINEER_TEXT1[4],title8=LocalStrings.ALCHEMY_TEXT1[2],title9=LocalStrings.BEATMICE_TEXT1[2],title10=LocalStrings.EVERYDAYBUY_TEXT3,title11=LocalStrings.GARDEN_TEXT1[11],title12=LocalStrings.CAFFEE_TEXT1[9],title14=LocalStrings.WATERMELON_TEXT1[2],title15=LocalStrings.SECRETTOWER_TEXT1[2],title19=LocalStrings.GOPHERBALL_TEXT1[2],title32=LocalStrings.DETECTIVE_TEXT1[2],title33=LocalStrings.GONGANDDRUM_TEXT1[2],title35=LocalStrings.DEEPSEA_TEXT1[2],title37=LocalStrings.HOTBASKETBALL_TEXT1[2],title40=LocalStrings.THROWPOT_TEXT1[2],title41=LocalStrings.CATCHFISH_TEXT1[2],title42=LocalStrings.BIKEMATCH_TEXT1[2]}
			local titleType = {title1=LocalStrings.SHOOTARROW_TEXT8,title4=LocalStrings.TASK_UINAME,title5=LocalStrings.YEARMONSTER_TEXT1[2],title6=LocalStrings.NEWYEARWISH_TEXT1[2],title7=LocalStrings.BEATENGINEER_TEXT1[4],title8=LocalStrings.ALCHEMY_TEXT1[2],title9=LocalStrings.BEATMICE_TEXT1[2],title10=LocalStrings.EVERYDAYBUY_TEXT3,title11=LocalStrings.GARDEN_TEXT1[11],title12=LocalStrings.CAFFEE_TEXT1[9],title14=LocalStrings.WATERMELON_TEXT1[2],title15=LocalStrings.SECRETTOWER_TEXT1[2],title19=LocalStrings.GOPHERBALL_TEXT1[2],title32=LocalStrings.DETECTIVE_TEXT1[2],title41=LocalStrings.CATCHFISH_TEXT1[2]}
			txtTitle:setText(titleType["title" .. tostring(self.m_nType)])
			if self.m_nType == 37 then 
				img9Bg:setFile("ui/common/frame_tc_xiao_zi.png")
				imgBtnClose:setFile("ui/common/common_top_btn_guanbi_zi.png")
			elseif self.m_nType == 41 or self.m_nType == 45 or self.m_nType == 50 then 
				img9Bg:setFile("ui/common/frame_tc_xiao_lan.png")
				imgBtnClose:setFile("ui/newvip/common_top_btn_guanbi_lan.png")
			end
		elseif self.m_nType == 2 then 
			txtTitle:setText(LocalStrings.WATERCOUNTRY_TEXT2[1])
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 1)
			self:showRedDot()
			return 
		elseif self.m_nType == 3 then 
			tab_container:setVisible(false)
			txtTitle:setText(LocalStrings.WATERCOUNTRY_TEXT2[2])
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 3)
			return 
		elseif self.m_nType == 13 then 
			txtTitle:setText(LocalStrings.BOWLING_TEXT1[9])
			img9Bg:setFile("ui/common/frame_tc_xiao_zi.png")
			imgBtnClose:setFile("ui/common/common_top_btn_guanbi_zi.png")
		elseif self.m_nType == 17 then 
			img9Bg:setFile("ui/common/frame_tc_xiao_zi.png")
			imgBtnClose:setFile("ui/common/common_top_btn_guanbi_zi.png")
			txtTitle:setText(LocalStrings.CRAZY_GASHAPON_TEXT1[2])
		elseif self.m_nType == 18 then 
			txtTitle:setText(LocalStrings.MIDNIGHTDINER_TEXT1[2])
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 1)
			self:showRedDot()
			return 
		elseif self.m_nType == 20 then 
			txtTitle:setText(LocalStrings.BEINGIMMORTAL_TEXT1[2])
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 1)
			self:showRedDot()
			return 
		elseif self.m_nType == 21 then 
			img9Bg:setUseOriginSize(true)
			img9Bg:setFile("ui/specialBg/frame_tc_bcs_d.png")
			GetElement(self.m_root, "btnClose_CellNewYearTask", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.95,0.946756))
			txtTitle:setText(LocalStrings.WORSHIPGOD_TEXT1[11])
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 1)
			self:showRedDot()
			return 
		elseif self.m_nType == 22 then 
			txtTitle:setText(LocalStrings.CALABASH_TEXT1[3])
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 1)
			self:showRedDot()
			return 
		elseif self.m_nType == 23 then 
			txtTitle:setText(LocalStrings.SPRINGOUTING_TEXT1[11])
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 1)
			self:showRedDot()
			return 
		elseif self.m_nType == 24 then 
			txtTitle:setText(LocalStrings.BEATBALLOON_TEXT1[11])
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 1)
			self:showRedDot()
			return 
		elseif self.m_nType == 25 then 
			txtTitle:setText(LocalStrings.SEAFARROAD_TEXT1[11])
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 1)
			self:showRedDot()
			return 
		elseif self.m_nType == 26 then 
			GetElement(self.m_root, "img9BottomBg_CellNewYearTask", WZUI9Image):setVisible(false)
			img9Bg:setUseOriginSize(true)
			img9Bg:setFile("ui/specialBg/frame_tc_ptds_d.png")
			img9Bg:setRelativePosition(GlobalMethod:ccp(0.5, 0.52))
			imgBtnClose:setFile("ui/common/common_top_btn_guanbi_l.png")
			txtTitle:setText(LocalStrings.CLIMBTREE_TEXT1[11])
			txtTitle:setEnableStroke(false)
			txtTitle:setColor(GlobalMethod:ccc3(255,255,255))
		elseif self.m_nType == 27 then 
			txtTitle:setText(LocalStrings.SUMMERSURF_TEXT1[11])
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 1)
			self:showRedDot()
			return
		elseif self.m_nType == 28 then 
			txtTitle:setText(LocalStrings.PLANETSEARCH_TEXT1[2])
			txtTitle:setStrokeColor(GlobalMethod:ccc3(0,112,202))
			txtTitle:setColor(GlobalMethod:ccc3(255,255,255))
			img9Bg:setFile("ui/specialBg/frame_tc_xxts_slale9.png")
			img9Bg:setScale(1.02)
			imgBtnClose:setFile("ui/common/common_top_btn_guanbi_zi.png")
		elseif self.m_nType == 29 then 
			txtTitle:setText(LocalStrings.TRAMPOLINE_TEXT1[10])
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 1)
			self:showRedDot()
			return 
		elseif self.m_nType == 30 then 
			txtTitle:setText(LocalStrings.TRAMPOLINE_TEXT1[10])
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 1)
			self:showRedDot()
			return 
		elseif self.m_nType == 31 then 
			txtTitle:setText(LocalStrings.WISHING_BOTTLE_TEXT1[16])
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 1)
			self:showRedDot()
			return
		elseif self.m_nType == 34 then 
			txtTitle:setText(LocalStrings.GOLD_MINER_TEXT1[9])
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 1)
			self:showRedDot()
			return
		elseif self.m_nType == 36 then 
			txtTitle:setText(LocalStrings.CHESS_ACTIVITY_TEXT1[12])
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 1)
			self:showRedDot()
			return 
		elseif self.m_nType == 38 then 
			txtTitle:setText(LocalStrings.AUTUMNCAMP_TEXT1[2])
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 1)
			self:showRedDot()
			return 
		elseif self.m_nType == 39 then 
			txtTitle:setText(LocalStrings.FLYKITES_TEXT1[8])
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 1)
			self:showRedDot()
			return 
		elseif self.m_nType == 44 then
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 1)
			self:showRedDot()
			return 
		elseif self.m_nType == 46 then 
			img9Bg:setFile("ui/common/frame_tc_xiao_lan.png")
			imgBtnClose:setFile("ui/newvip/common_top_btn_guanbi_lan.png")
			txtTitle:setText(LocalStrings.MAKE_SHOWMAN_TEXT1[13])
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 1)
			self:showRedDot()
			return 
		elseif self.m_nType == 47 then 
			txtTitle:setText(LocalStrings.PIANIST_TEXT1[12])
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 1)
			self:showRedDot()
			return 
		elseif self.m_nType == 49 then 
			img9Bg:setFile("ui/common/frame_tc_xiao_lan.png")
			imgBtnClose:setFile("ui/newvip/common_top_btn_guanbi_lan.png")
			txtTitle:setText(LocalStrings.WEIGHTLIFTING_TEXT1[12])
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 1)
			self:showRedDot()
			return 
		elseif self.m_nType == 51 then
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 1)
			self:showRedDot()
			return 
		elseif self.m_nType == 52 then
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 1)
			self:showRedDot()
			return 
		elseif self.m_nType == 53 then
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 1)
			self:showRedDot()
			return 
		elseif self.m_nType == 54 then
			img9Bg:setFile("ui/common/frame_tc_xiao_lan.png")
			imgBtnClose:setFile("ui/newvip/common_top_btn_guanbi_lan.png")
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 1)
			self:showRedDot()
			return 
		elseif self.m_tOtherData then 
			txtTitle:setText(self.m_tOtherData.taskTitle)
			if self.m_tOtherData.titleStrokeColor then 
				txtTitle:setStrokeColor(self.m_tOtherData.titleStrokeColor)
			end
			if self.m_tOtherData.titleColor then 
				txtTitle:setColor(self.m_tOtherData.titleColor)
			end
			if self.m_tOtherData.bEnableStroke ~= nil then
				txtTitle:setEnableStroke(self.m_tOtherData.bEnableStroke)
			end
			if self.m_tOtherData.isBgUseOrigin ~= nil then 
				img9Bg:setUseOriginSize(self.m_tOtherData.isBgUseOrigin)
			end
			if self.m_tOtherData.img9Bg then 
				img9Bg:setFile(self.m_tOtherData.img9Bg)
			end
			if self.m_tOtherData.bgScale then 
				img9Bg:setScale(self.m_tOtherData.bgScale)
			end
			if self.m_tOtherData.bgPos then 
				img9Bg:setRelativePosition(self.m_tOtherData.bgPos)
			end
			if self.m_tOtherData.imgBtnClose then 
				imgBtnClose:setFile(self.m_tOtherData.imgBtnClose)
			end
			if self.m_tOtherData.btnClosePos then 
				GetElement(self.m_root, "btnClose_CellNewYearTask", WZUIButton):setRelativePosition(self.m_tOtherData.btnClosePos)
			end
			if self.m_tOtherData.taskType == 1 then 
				ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, self.m_tOtherData.typeIndex or 1)
			elseif self.m_tOtherData.taskType == 2 then 
				ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, self.m_tOtherData.typeIndex or 2)
			end
			self:showRedDot()
			return 
		end
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, 2)
		self:showRedDot()
	end
end
function CellNewYearTask:onBtnClickTab(element)
	local index = nil
	if type(element) == "number" then
		index = element
	else
		index = tonumber(element:getTag())
	end
	if index == self.m_nCellCurIndex then return end

	local tempType1 = {1, 4, 5, 6, 7, 8, 12, 13, 14, 15, 17, 19, 26, 28, 32, 33, 35, 37, 40, 41, 42, 43, 45, 48, 50}
	local tempType2 = {18, 20, 21, 22, 23, 24, 25, 29, 30, 31, 34, 36, 38, 39, 44, 46, 47, 49, 51, 52, 53, 54}
	if self.m_nType == 0 then 
		self:_showTaskContent(index)

		self.m_nCellCurIndex = index
	elseif utilsValueInTable(self.m_nType, tempType1) then 
		if index == 1 then 
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, 2)
		else
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, 1)
		end
	elseif self.m_nType == 2 or self.m_nType == 27 then 
		if index == 1 then 
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 1)
		else
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 2)
		end
	elseif self.m_nType == 9 or self.m_nType == 10 or self.m_nType == 11 or self.m_nType == 16 then 
		if index == 1 then 
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, 2)
		elseif index == 2 then 
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, 1)
		elseif index == 3 then 
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, 3)
		end
	elseif utilsValueInTable(self.m_nType, tempType2) then 
		if index == 1 then 
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 1)
		elseif index == 2 then 
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 2)
		elseif index == 3 then 
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 3)
		end
	elseif self.m_tOtherData then 
		if self.m_tOtherData.taskType == 1 then 
			if index == 1 then 
				ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 1)
			elseif index == 2 then 
				ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 2)
			elseif index == 3 then 
				ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, -1, 3)
			end
		elseif self.m_tOtherData.taskType == 2 then 
			if index == 1 then 
				ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, 2)
			else
				ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, 1)
			end
		end
	end
end

function CellNewYearTask:onBtnClickClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nType == 0 then 
		WndNewYearMain:setSignSelectVisible(true)
	elseif self.m_nType == 1 then 
		WndShootArrow:showRedDot()
	elseif self.m_nType == 2 or self.m_nType == 3 then 
		WndWaterCountry:showRedDot()
	elseif self.m_nType == 4 then 
		WndDecorations:showRedDot()
	elseif self.m_nType == 5 then 
		WndYearMonster:setUpdateInterval()
		WndYearMonster:showRedDot()
	elseif self.m_nType == 6 then 
		WndNewYearWish:showRedDot()
	elseif self.m_nType == 7 then 
		WndBeatEngineer:showRedDot()
	elseif self.m_nType == 8 then 
		WndAlchemy:showRedDot()
	elseif self.m_nType == 9 then 
		WndBeatMice:showRedDot()
	elseif self.m_nType == 10 then 
		WndSetCircle:showRedDot()
	elseif self.m_nType == 11 then 
		WndGarden:showRedDot()
	elseif self.m_nType == 12 then 
		WndCaffee:showRedDot()
	elseif self.m_nType == 13 then 
		WndBowling:showRedDot()
	elseif self.m_nType == 14 then 
		WndWatermelon:showRedDot()
	elseif self.m_nType == 15 then 
		WndSecretTower:showRedDot()
	elseif self.m_nType == 16 then 
		WndBilliardBall:showRedDot()
	elseif self.m_nType == 17 then 
		WndCrazyGashapon:showRedDot()
	elseif self.m_nType == 18 then 
		WndMidnightDiner:showRedDot()
	else
		GlobalGame:getGameEventDispathcer():Dispatch(Independent_Activity.ActivityReddot)
	end
	WindowManager:removeWindow(self.m_root, self, true)
	
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellNewYearTask:_onGetNewYearTaskInfo(id, resetType, status, target, progress, rewardNum, itemId, itemNum)
	self:setTaskTypeData(id, resetType, status, target, progress, rewardNum, itemId, itemNum)
	self:onBtnClickTab(1)
	CellNewYearTaskDay:setRedPoint(self.m_sImageDayRedPoint, self.m_tTaskDayData)
	CellNewYearTaskGrowup:setRedPoint(self.m_sImageGrowupRedPoint, self.m_tTaskGrowupData)
end

function CellNewYearTask:_onGetNewYearTaskGetResult(result, id, resetType, isTaskReward, itemId, itemNum)
	if result ~= 0 then
		MsgBoxManager:showTipBox(LocalStrings.RETURNEE_TEXT28)
		return
	end
	WndRewardShow:showById(itemId, itemNum)
	if self.m_nType == 0 then 
		WndNewYearMain:setTaskRedPointVisible(isTaskReward)
	elseif self.m_nType == 1 or self.m_nType == 2 then 
		resetType = resetType - 1
	elseif self.m_nType == 3 then 
		resetType = 0
	end
	WZLog("CellNewYearTask:_onGetNewYearTaskGetResult", self.m_nType, resetType)
	if resetType == 0 then
		CellNewYearTaskGrowup:setTeskGetResult(id)
		CellNewYearTaskGrowup:setRedPoint(self.m_sImageGrowupRedPoint)
	elseif resetType == 1 then
		CellNewYearTaskDay:setTeskGetResult(id)
		CellNewYearTaskDay:setRedPoint(self.m_sImageDayRedPoint)
	elseif resetType == 2 then
		CellNewYearTaskOther:setTeskGetResult(id)
		CellNewYearTaskOther:setRedPoint(self.m_imgRedPoint3)
	end
end

--@brief 	显示相应界面
--@param 	index:1->日常；2->成长；3->欢乐地鼠-欢乐任务
function CellNewYearTask:_showTaskContent(index)
	-- body
	if self.m_tCellTitleTab[self.m_nCellCurIndex] ~= nil then
		self.m_tCellTitleTab[self.m_nCellCurIndex].select:setVisible(false)
		self.m_tCellTitleTab[self.m_nCellCurIndex].normal:setVisible(true)
		self.m_tCellTitleTab[self.m_nCellCurIndex].title:setEnableStroke(false)
		if self.m_nType == 21 then 
			self.m_tCellTitleTab[self.m_nCellCurIndex].title:setColor(GlobalMethod:ccc3(229,105,22))
		elseif self.m_nType == 28 then 
			self.m_tCellTitleTab[self.m_nCellCurIndex].title:setColor(GlobalMethod:ccc3(14,178,232))
		else
			self.m_tCellTitleTab[self.m_nCellCurIndex].title:setColor(GlobalMethod:ccc3(127,70,26))
		end
	end
	if self.m_tCellTitleTab[index] ~= nil then
		self.m_tCellTitleTab[index].select:setVisible(true)
		self.m_tCellTitleTab[index].normal:setVisible(false)
		if self.m_nType == 28 then 
			self.m_tCellTitleTab[index].title:setEnableStroke(false)
			self.m_tCellTitleTab[index].title:setColor(GlobalMethod:ccc3(255,255,255))
		else
			self.m_tCellTitleTab[index].title:setEnableStroke(true)
			self.m_tCellTitleTab[index].title:setColor(GlobalMethod:ccc3(255,236,193))
		end
	end

	if self.m_sTouchCurWinFace ~= nil then
		self.m_sTouchCurWinFace:setVisible(false)
		self.m_sTouchCurWinFace = nil
	end

	if self.m_nType == 10 or self.m_nType == 11 or self.m_nType == 12 or self.m_nType == 13 or self.m_nType == 16 or self.m_nType == 21 or self.m_nType == 23 or self.m_nType == 24 or self.m_nType == 25 or self.m_nType == 26 or self.m_nType == 27 or self.m_nType == 29 or self.m_nType == 30 or self.m_nType == 31 or self.m_nType == 34 or self.m_nType == 36 or self.m_nType == 43 or self.m_nType == 44 or self.m_nType == 45 or self.m_nType == 46 or self.m_nType == 47 or self.m_nType == 48 or self.m_nType == 49 or self.m_nType == 50 or self.m_nType == 51 or self.m_nType == 52 or self.m_nType == 53 or self.m_nType == 54 then 
		local tTitleText = {LocalStrings.SETCIRCLE_TEXT1[11], LocalStrings.SETCIRCLE_TEXT1[12], LocalStrings.SETCIRCLE_TEXT1[2]}
		if self.m_nType == 10 then 
			tTitleText = {LocalStrings.SETCIRCLE_TEXT1[11], LocalStrings.SETCIRCLE_TEXT1[12], LocalStrings.SETCIRCLE_TEXT1[2]}
		elseif self.m_nType == 11 then 
			tTitleText = {LocalStrings.GARDEN_TEXT1[11], LocalStrings.GARDEN_TEXT1[12], LocalStrings.GARDEN_TEXT1[2]}
		elseif self.m_nType == 12 then 
			tTitleText = {LocalStrings.CAFFEE_TEXT1[9], LocalStrings.CAFFEE_TEXT1[10]}
		elseif self.m_nType == 13 then 
			tTitleText = {LocalStrings.BOWLING_TEXT1[9], LocalStrings.BOWLING_TEXT1[10]}
		elseif self.m_nType == 16 then 
			tTitleText = {LocalStrings.EVERYDAYBUY_TEXT3, LocalStrings.EVERYDAYBUY_TEXT4, LocalStrings.BILLIARDBALL_TEXT1[2]}
		elseif self.m_nType == 21 then 
			tTitleText = {LocalStrings.WORSHIPGOD_TEXT1[11], LocalStrings.WORSHIPGOD_TEXT1[12], LocalStrings.WORSHIPGOD_TEXT1[13]}
		elseif self.m_nType == 23 then 
			tTitleText = {LocalStrings.SPRINGOUTING_TEXT1[11], LocalStrings.SPRINGOUTING_TEXT1[12], LocalStrings.SPRINGOUTING_TEXT1[13]}
		elseif self.m_nType == 24 then 
			tTitleText = {LocalStrings.BEATBALLOON_TEXT1[11], LocalStrings.BEATBALLOON_TEXT1[12], LocalStrings.BEATBALLOON_TEXT1[13]}
		elseif self.m_nType == 25 then 
			tTitleText = {LocalStrings.SEAFARROAD_TEXT1[11], LocalStrings.SEAFARROAD_TEXT1[12], LocalStrings.SEAFARROAD_TEXT1[13]}
		elseif self.m_nType == 26 then 
			tTitleText = {LocalStrings.CLIMBTREE_TEXT1[11], LocalStrings.CLIMBTREE_TEXT1[12]}
		elseif self.m_nType == 27 then 
			tTitleText = {LocalStrings.SUMMERSURF_TEXT1[11], LocalStrings.SUMMERSURF_TEXT1[12]}
		elseif self.m_nType == 29 then 
			tTitleText = {LocalStrings.TRAMPOLINE_TEXT1[10], LocalStrings.TRAMPOLINE_TEXT1[11], LocalStrings.TRAMPOLINE_TEXT1[12]}
		elseif self.m_nType == 30 then 
			tTitleText = {LocalStrings.GOLFBALL_TEXT1[10], LocalStrings.GOLFBALL_TEXT1[11], LocalStrings.GOLFBALL_TEXT1[12]}
		elseif self.m_nType == 31 then 
			tTitleText = {LocalStrings.WISHING_BOTTLE_TEXT1[16], LocalStrings.WISHING_BOTTLE_TEXT1[17], LocalStrings.WISHING_BOTTLE_TEXT1[18]}
		elseif self.m_nType == 34 then 
			tTitleText = {LocalStrings.GOLD_MINER_TEXT1[9], LocalStrings.GOLD_MINER_TEXT1[10], LocalStrings.GOLD_MINER_TEXT1[11]}
		elseif self.m_nType == 36 then 
			tTitleText = {LocalStrings.CHESS_ACTIVITY_TEXT1[12], LocalStrings.CHESS_ACTIVITY_TEXT1[13], LocalStrings.CHESS_ACTIVITY_TEXT1[14]}
		elseif self.m_nType == 43 then 
			tTitleText = {LocalStrings.LASHTOP_TEXT1[10], LocalStrings.LASHTOP_TEXT1[11]}
		elseif self.m_nType == 44 then 
			tTitleText = {LocalStrings.KICKING_BIRDIE_TEXT1[12], LocalStrings.KICKING_BIRDIE_TEXT1[13]}
		elseif self.m_nType == 45 then
			tTitleText = {LocalStrings.MAGIC_CLASSROOM_TEXT1[13], LocalStrings.MAGIC_CLASSROOM_TEXT1[14]}
		elseif self.m_nType == 46 then
			tTitleText = {LocalStrings.MAKE_SHOWMAN_TEXT1[13], LocalStrings.MAKE_SHOWMAN_TEXT1[14], LocalStrings.MAKE_SHOWMAN_TEXT1[23]}
		elseif self.m_nType == 47 then
			tTitleText = {LocalStrings.PIANIST_TEXT1[12], LocalStrings.PIANIST_TEXT1[13], LocalStrings.PIANIST_TEXT1[14]}
		elseif self.m_nType == 48 then
			tTitleText = {LocalStrings.CERAMIC_WORKSHOP_TEXT1[11], LocalStrings.CERAMIC_WORKSHOP_TEXT1[12]}
		elseif self.m_nType == 49 then
			tTitleText = {LocalStrings.WEIGHTLIFTING_TEXT1[12], LocalStrings.WEIGHTLIFTING_TEXT1[13], LocalStrings.WEIGHTLIFTING_TEXT1[14]}
		elseif self.m_nType == 50 then
			tTitleText = {LocalStrings.ARCTIC_EXPLORATION_TEXT1[11], LocalStrings.ARCTIC_EXPLORATION_TEXT1[12]}
		elseif self.m_nType == 51 then
			tTitleText = {LocalStrings.BUILDING_BLOCKS_TEXT1[8], LocalStrings.BUILDING_BLOCKS_TEXT1[4]}
		elseif self.m_nType == 52 then
			tTitleText = {LocalStrings.CASTING_MASTER_ACTIVITY_TEXT1[7], LocalStrings.CASTING_MASTER_ACTIVITY_TEXT1[8]}
		elseif self.m_nType == 53 then
			tTitleText = {LocalStrings.BOATING_LAKE_TEXT1[10], LocalStrings.BOATING_LAKE_TEXT1[11], LocalStrings.BOATING_LAKE_TEXT1[12]}
		elseif self.m_nType == 54 then
			tTitleText = {LocalStrings.BLOW_BUBBLES_TEXT1[12], LocalStrings.BLOW_BUBBLES_TEXT1[13], LocalStrings.BLOW_BUBBLES_TEXT1[14]}
		end
		local txtTitle = GetElement(self.m_root, "txtTitle_CellNewYearTask", WZUILabelTTF)
		txtTitle:setTextKey("")
		txtTitle:setText(tTitleText[index])
	elseif self.m_tOtherData then 
		if self.m_tOtherData.titleList then 
			local txtTitle = GetElement(self.m_root, "txtTitle_CellNewYearTask", WZUILabelTTF)
			txtTitle:setTextKey("")
			txtTitle:setText(self.m_tOtherData.titleList[index])
		end
	end

	if self.m_tTabChangeContainer[index] == nil then
		local panel = nil
		if index == 1 then
			panel = CellNewYearTaskDay:createElement(self.m_tTaskDayData, self.m_nType, self.m_tOtherData)
		elseif index == 2 then
			panel = CellNewYearTaskGrowup:createElement(self.m_tTaskGrowupData, self.m_nType, self.m_tOtherData)
		elseif index == 3 then
			panel = CellNewYearTaskOther:createElement(self.m_tTaskOtherData, self.m_nType, self.m_tOtherData)
		end
		if panel then
			self.m_sDesContainer:addChild(panel)
			self.m_tTabChangeContainer[index] = panel
		end
	end
	self.m_sTouchCurWinFace = self.m_tTabChangeContainer[index]
	if self.m_sTouchCurWinFace ~= nil then
		self.m_sTouchCurWinFace:setVisible(true)
	end

end

--@brief 	射箭任务奖励
function CellNewYearTask:_onGetTaskResult(activityId, id)
--	WZLog("CellNewYearTask:_onGetTaskResult", self.m_nActivityId, activityId, id)
	if self.m_nActivityId ~= activityId then
		MsgBoxManager:showTipBox(LocalStrings.RETURNEE_TEXT28)
		return
	end
	
	local taskData = GDatatab_new_activity_task["id_" .. id]
	if taskData and taskData.type == 1 then
		if (self.m_nType == 18 or self.m_nType == 24 or self.m_nType == 25 or self.m_nType == 29 or self.m_nType == 30 or self.m_nType == 31 or self.m_nType == 34 or self.m_nType == 36 or self.m_nType == 39 or self.m_nType == 46 or self.m_nType == 47 or self.m_nType == 49 or self.m_nType == 53 or self.m_nType == 54 or self.m_nType == 60) and taskData.group_by == 3 then 
			CellNewYearTaskOther:setTeskGetResult(id)
			CellNewYearTaskOther:setRedPoint(self.m_imgRedPoint3)
		else
			CellNewYearTaskGrowup:setTeskGetResult(id)
			CellNewYearTaskGrowup:setRedPoint(self.m_sImageGrowupRedPoint)
		end
	elseif taskData and taskData.type == 2 then
		if (self.m_nType == 29 or self.m_nType == 30 or self.m_nType == 31 or self.m_nType == 34 or self.m_nType == 36 or self.m_nType == 39 or self.m_nType == 46 or self.m_nType == 47 or self.m_nType == 49 or self.m_nType == 53 or self.m_nType == 54 or self.m_nType == 60) and taskData.group_by == 3 then 
			CellNewYearTaskOther:setTeskGetResult(id)
			CellNewYearTaskOther:setRedPoint(self.m_imgRedPoint3)
		else
			CellNewYearTaskDay:setTeskGetResult(id)
			CellNewYearTaskDay:setRedPoint(self.m_sImageDayRedPoint)
		end
	elseif taskData and taskData.type == 3 then
		CellNewYearTaskOther:setTeskGetResult(id)
		CellNewYearTaskOther:setRedPoint(self.m_imgRedPoint3)
	end
end

--@brief 	设置红点
function CellNewYearTask:showRedDot()
	-- body
	if self.m_nType == 3 then return end 
	local tRedList = {{117020, 127020}, {227031, 217031}, {}, {117030, 127030}, {117035, 127035}, {117033, 127033}, {117034, 127034}, {117036, 127036}, {117037, 127037, 137037}, {117046, 127046, 137046}, {117047, 127047, 137047}, {117048, 127048}, {117049, 127049}, {117051, 127051}, {117052, 127052}, {117055, 127055, 137055}, {117057, 127057}, {227058, 217058, 237058}, {117059, 127059}, {227061, 217061}, {227062, 217062, 237062}, {227063, 217063, 237063}, {227065, 217065, 237065}, {227070, 217070, 237070}, {227072, 217072, 237072}, {117075, 127075}, {227076, 217076}, {117077, 127077}, {227081, 217081, 237081}, {227082, 217082, 237082}, {227083,217083,237083}, {117084, 127084}, {117086, 127086}, {227087, 217087, 237087}, {117089, 127089}, {227088, 217088, 237088}, {117091, 127091}, {227090, 217090}, {227092, 217092, 237092}, {117093, 127093}, {117094, 127094}, {117095, 127095}, {117096, 127096}, {227097, 217097}, {117098, 127098}, {227099, 217099, 237099}, {227100, 217100, 237100}, {117101, 127101}, {227102, 217102, 237102}, {117103, 127103}, {227104, 217104}, {227105, 217105}, {227106, 217106, 237106}, {227107, 217107, 237107}}

	if self.m_tOtherData then 
		local redPoint = self.m_tOtherData.redPoint 
		--成长任务
		if GlobalGame.g_tRedPointTypeList[redPoint[1]] then
			self.m_sImageGrowupRedPoint:setVisible(true)
		else
			self.m_sImageGrowupRedPoint:setVisible(false)
		end
		--日常任务
		if GlobalGame.g_tRedPointTypeList[redPoint[2]] then 
			self.m_sImageDayRedPoint:setVisible(true)
		else
			self.m_sImageDayRedPoint:setVisible(false)
		end
		if redPoint[3] ~= nil then
			if GlobalGame.g_tRedPointTypeList[redPoint[3]] then 
				self.m_imgRedPoint3:setVisible(true)
			else
				self.m_imgRedPoint3:setVisible(false)
			end
		end
		return 
	end
	--成长任务
	if GlobalGame.g_tRedPointTypeList[tRedList[self.m_nType][1]] then
		self.m_sImageGrowupRedPoint:setVisible(true)
	else
		self.m_sImageGrowupRedPoint:setVisible(false)
	end
	--日常任务
	if GlobalGame.g_tRedPointTypeList[tRedList[self.m_nType][2]] then 
		self.m_sImageDayRedPoint:setVisible(true)
	else
		self.m_sImageDayRedPoint:setVisible(false)
	end
	--欢乐地鼠/套圈圈
	if self.m_nType == 9 or self.m_nType == 10 or self.m_nType == 11 or self.m_nType == 16 or self.m_nType == 18 or self.m_nType == 21 or self.m_nType == 22 or self.m_nType == 23 or self.m_nType == 24 or self.m_nType == 25 or self.m_nType == 29 or self.m_nType == 30 or self.m_nType == 31 or self.m_nType == 34 or self.m_nType == 36 or self.m_nType == 39 or self.m_nType == 46 or self.m_nType == 47 or self.m_nType == 49 or self.m_nType == 53 or self.m_nType == 54 then 
		if GlobalGame.g_tRedPointTypeList[tRedList[self.m_nType][3]] then 
			self.m_imgRedPoint3:setVisible(true)
		else
			self.m_imgRedPoint3:setVisible(false)
		end
	end
end
-------------------------------------私有方法模块End----------------------------------------


function CellNewYearTask:_adaptLanguage_vn()
	local title_1 = GetElement(self.m_root,"title_1",WZUILabelTTF)
	title_1:setDimensions(GlobalMethod:CCSize(130,0))
	title_1:setScale(0.8)
	title_1:setFontSize(18)
	local title_2 = GetElement(self.m_root,"title_2",WZUILabelTTF)
	title_2:setDimensions(GlobalMethod:CCSize(130,0))
	title_2:setScale(0.8)
	title_2:setFontSize(18)
	local title_3 = GetElement(self.m_root,"title_3",WZUILabelTTF)
	title_3:setDimensions(GlobalMethod:CCSize(130,0))
	title_3:setScale(0.8)
	title_3:setFontSize(18)
end