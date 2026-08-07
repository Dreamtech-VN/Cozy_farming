--WndFourStarRank.lua
--@brief	WndFourStarRank的UI模块
--@date		2021/02/24
--@author	hyx
--@note		排行榜


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFourStarRank:onEnter(element)
	self.m_root = element
	self:register()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFourStarRank:onExit(element)
	self:_unInit()
	self:unregister()
end
function WndFourStarRank:register()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetRankResult,self._onGetRankResultInfo,self)
end
function WndFourStarRank:unregister()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetRankResult,self._onGetRankResultInfo,self)
end

function WndFourStarRank:showInterface(activityId, _type)
	local wndRank = WndFourStarRank:createElement(activityId, _type)
	if wndRank ~= nil then
	    WindowManager:addWindow(wndRank,WndFourStarRank,nil,false)
	end
end

function WndFourStarRank:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndFourStarRank:actionCallback()
	self:initShow()
end

function WndFourStarRank:initShow()
	self.m_sSummonCon = GetElement(self.m_root,"summon_con",WZUIContainer)
	self.m_sTxtShowSummonPlayer = GetElement(self.m_sSummonCon,"txtShowSummonPlayer",WZUILabelTTF)
	self.m_sFreeMySummonTxt = GetElement(self.m_sSummonCon,"freeMySummonTxt",WZUIFreeTextBox)
	self.m_sFreeMyRankTxt1 = GetElement(self.m_sSummonCon,"freeMyRankTxt1",WZUIFreeTextBox)
	
	self.m_sLibraryCon =GetElement(self.m_root,"library_con",WZUIContainer)
	self.m_sTxtShowLibraryPlayer = GetElement(self.m_sLibraryCon,"txtShowLibraryPlayer",WZUILabelTTF)
	self.m_sFreeMyLibraryTxt = GetElement(self.m_sLibraryCon,"freeMyLibraryTxt",WZUIFreeTextBox)
	self.m_sFreeMyRankTxt2 = GetElement(self.m_sLibraryCon,"freeMyRankTxt2",WZUIFreeTextBox)
	
	local imageBg = GetElement(self.m_root,"imageBg",WZUI9Image)
	local imageClose = GetElement(self.m_root,"imageClose",WZUIImage)
	local imageTitle = GetElement(self.m_root,"imageTitle",WZUI9Image)
	if self.m_nSurfaceType == 2 then
		self.m_nCurIndex = 1
		imageBg:setFile("ui/common/frame_tc_xiao.png")
		imageClose:setFile("ui/common/common_top_btn_guanbi.png")
		imageTitle:setFile("ui/common/frame_12.png")
	else
		imageBg:setFile("ui/common/frame_tc_xiao_zi.png")
		imageClose:setFile("ui/common/common_top_btn_guanbi_zi.png")
		imageTitle:setFile("ui/common/frame_12_1.png")
	end

	local str_name = {LocalStrings.FOURSTAR_TEXT24,LocalStrings.FOURSTAR_TEXT25}
	if self.m_nSurfaceType == 2 then
		str_name = {LocalStrings.ACTIVITY_TEXT142,LocalStrings.ACTIVITY_TEXT156}
	end
	for i=1,2 do
		local tab = {}
		local btn = GetElement(self.m_root,"btn"..i,WZUIButton)
		btn:setVisible(true)
		tab.normal = GetElement(btn,"normal"..i,WZUIImage)
		tab.select = GetElement(btn,"select"..i,WZUIImage)
		tab.select:setVisible(false)
		if self.m_nSurfaceType == 2 then
			tab.normal:setFile("ui/common/common_btn_21.png")
			tab.select:setFile("ui/common/common_btn_20.png")
		else
			tab.normal:setFile("ui/activity/common_btn_40.png")
			tab.select:setFile("ui/activity/common_btn_39.png")
		end
		tab.name = GetElement(btn,"name"..i,WZUILabelTTF)
		tab.name:setText(str_name[i])
		self.m_tBtnTitle[i] = tab
	end
	if ProjConfig.LANGUAGE == "vn" then
		if self.m_nSurfaceType == 1 then 
			self.m_nCurIndex = 1
			GetElement(self.m_root,"btn1",WZUIButton):setVisible(false)
			GetElement(self.m_root,"btn2",WZUIButton):setVisible(false)
		end
	end
	self:setChangeTitle(self.m_nCurIndex)
end
function WndFourStarRank:onBtnChange( element )
	local tag = element:getTag()
	if self.m_nCurIndex == tag then return end
	self:setChangeTitle(tag)
	self.m_nCurIndex = tag
end
function WndFourStarRank:setChangeTitle(tag)
	if self.m_tBtnTitle[self.m_nCurIndex] ~= nil then
		self.m_tBtnTitle[self.m_nCurIndex].select:setVisible(false)
		self.m_tBtnTitle[self.m_nCurIndex].name:setEnableStroke(false)
		self.m_tBtnTitle[self.m_nCurIndex].name:setColor(GlobalMethod:ccc3(127,70,26))
	end
	if self.m_tBtnTitle[tag] ~= nil then
		self.m_tBtnTitle[tag].select:setVisible(true)
		self.m_tBtnTitle[tag].name:setEnableStroke(true)
		self.m_tBtnTitle[tag].name:setColor(GlobalMethod:ccc3(255,236,193))
		self.m_tBtnTitle[tag].name:setStrokeColor(GlobalMethod:ccc3(127,70,26))
		self.m_tBtnTitle[tag].name:setStrokeSize(4)
	end
	local str_title = {LocalStrings.FOURSTAR_TEXT8, LocalStrings.FRAGMENT}
	local activityId = g_cityExtenInfo.activity7008
	if self.m_nSurfaceType == 2 then
		-- 1、记忆总榜，2、弹珠周榜
		str_title = {LocalStrings.ACTIVITY_TEXT155, LocalStrings.ACTIVITY_TEXT154}
		activityId = g_cityExtenInfo.activity7028
	end
	if tag == 1 and next(self.m_tSummonRankData) == nil then
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(activityId, 2)
	elseif tag == 2 and next(self.m_tLibraryRankData) == nil then
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(activityId, 1)
	end
	self.m_sSummonCon:setVisible(tag == 1)
	self.m_sLibraryCon:setVisible(tag == 2)

	local txtChangeTitle = GetElement(self.m_root,"txtChangeTitle",WZUILabelTTF)
	txtChangeTitle:setText(str_title[tag])
end

function WndFourStarRank:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndFourStarRank:_onGetRankResultInfo(activityId, activityType, rankingType, myPoint, myRanking, rewardConfig, playerIds, ranks, points, nickname, 
	headIds, headColors, faceIds, sexs, vipLevel, level, bodyIds, windIds, title, serverIds, session, settlementDate)
	rewardConfig = json.decode(rewardConfig)
	if not rewardConfig then return end
	
	-- 2 召唤排行榜 =1 图鉴排行榜
	local rankSummonFreeList = GetElement(self.m_sSummonCon,"rankSummonFreeList",WZUIFreeListContainer)
	local rankLibraryFreeList = GetElement(self.m_sLibraryCon,"rankLibraryFreeList",WZUIFreeListContainer)
	if myRanking <= 0 then
		myRanking = 0
	end
	if rankingType == 2 then
		local tData, myCurRank = WndShopRank:setRankData(rewardConfig, playerIds, level, points, nickname, faceIds, headIds, headColors, sexs, nil, nil, nil, nil, 3)--3只是让取数据排名的时候取到并列排名，并没有实际意义
		self.m_tSummonRankData = tData
		self:setRankListData(rankSummonFreeList, tData)
		local num = 100
		local str1 = LocalStrings.FOURSTAR_TEXT29
		local str2 = LocalStrings.FOURSTAR_TEXT31
		if self.m_nSurfaceType == 2 then
			num = 50
			self.m_sTxtShowSummonPlayer:setColor(ccc3(127,70,26))
			str1 = LocalStrings.ACTIVITY_TEXT171
			str2 = LocalStrings.ACTIVITY_TEXT165
		end
		if activityType == 7028 then
			self.m_sTxtShowSummonPlayer:setText(string.format(LocalStrings.ACTIVITY_TEXT170,settlementDate))
		else
			self.m_sTxtShowSummonPlayer:setText(string.format(LocalStrings.FOURSTAR_TEXT28,num))
		end
		self.m_sFreeMySummonTxt:setShowText(string.format(str1, myPoint))
		self.m_sFreeMyRankTxt1:setShowText(string.format(str2, myCurRank))
	elseif rankingType == 1 then
		local tData, myCurRank = WndShopRank:setRankData(rewardConfig, playerIds, level, points, nickname, faceIds, headIds, headColors, sexs, nil, nil, nil, nil, 3)--3只是让取数据排名的时候取到并列排名，并没有实际意义
		self.m_tLibraryRankData = tData
		self:setRankListData(rankLibraryFreeList, tData)
		local num = 10
		local str1 = LocalStrings.FOURSTAR_TEXT30
		local str2 = LocalStrings.FOURSTAR_TEXT31
		if self.m_nSurfaceType == 2 then
			num = 100
			self.m_sTxtShowLibraryPlayer:setColor(ccc3(127,70,26))
			str1 = LocalStrings.ACTIVITY_TEXT172
			str2 = LocalStrings.ACTIVITY_TEXT165
		end
		self.m_sTxtShowLibraryPlayer:setText(string.format(LocalStrings.FOURSTAR_TEXT28,num))
		self.m_sFreeMyLibraryTxt:setShowText(string.format(str1, myPoint))
		self.m_sFreeMyRankTxt2:setShowText(string.format(str2, myCurRank))
	end
end

function WndFourStarRank:setRankListData(node, data)
	if not node then return end

	if next(data) ~= nil then
		removeShowPanelNullTip(node)
		for i = 1, #data do
			local element, tLuaObj = CellLibraryRankItem:createElement()
			node:pushBack(WZUIContainer:luaTo(element))
			node:getMoveElement():setPositionY(node:getMinPosition().y)
			tLuaObj:setGiftBuyMessage(i, data[i], self.m_nSurfaceType)
		end
	else
		ShowPanelNullTip( node, LocalStrings.FRIENDS_SEND_TIP_3)
	end
end

-------------------------------------私有方法模块End----------------------------------------
