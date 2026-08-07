--WndFootballAct.lua
--@brief	WndFootballAct的UI模块
--@date		2018/05/30
--@author	yeruida
--@note		足球竞猜


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFootballAct:onEnter(element)
	self.m_root = element
	ProtocolProcessorWndActivityOnLine:regAll()
	CacheCenter:registerUpatePlayerItemObserver(self)
	self:_moreLanguage()
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFootballAct:onExit(element)
	CacheCenter:unregisterUpatePlayerItemObserver(self)
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndFootballAct:onCloseClick(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    WindowManager:removeWindow(self.m_root, self, true)
end

function WndFootballAct:showWindow( )
	local footballQuizItemId = CacheCenter:getGameParam().footballQuizItemId
	self:_setIcon(footballQuizItemId)
end

function WndFootballAct:updatePlayerItemData()
	WZLog("WndFootballAct:updatePlayerItemData")
	local footballQuizItemId = CacheCenter:getGameParam().footballQuizItemId
	local footballQuizItemName = GDatatab_item["id_"..footballQuizItemId].name
	local nQuizItemNum = 0
	if footballQuizItemId then
		nQuizItemNum = CacheCenter:getPlayerItemCountById(footballQuizItemId)
	end
	GetElement(self.m_root,"txtQuiz1Coin_WndFootballAct",WZUILabelTTF):setText(footballQuizItemName..":"..nQuizItemNum)
end

function WndFootballAct:_updateLeft(element)
	local flconLeft = GetElement(self.m_root,"flconLeft_WndFootballAct",WZUIFreeListContainer) 
	if flconLeft:size() > 0 then
		flconLeft:removeAll()
	end
	for i = 1, #self.tQuizList do
		local cellElement,tCell = CellFootballQuizBtn:createElement()
		self.m_tLeftList[self.tQuizList[i].matchId] = tCell
		cellElement = WZUIContainer:luaTo(cellElement)
        flconLeft:pushBack(cellElement)
        tCell:setData(self.tQuizList[i])
        tCell:setFuncCallBack(self,self.btnClickBack)
		if self.tQuizList[i].matchId == self.curMatchData.matchId then
			tCell:setHighLight(true)
		end
	end
	flconLeft:getMoveElement():setPositionY(flconLeft:getMinPosition().y)
end

function WndFootballAct:onOptions(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WZLog("WndFootballAct:onOptions",element:getTag())
	local nTag = element:getTag()

	GetElement(self.m_root,"conQuiz0_WndFootballAct",WZUIContainer):setVisible(false)
	local conQuiz = GetElement(self.m_root,"conQuiz1_WndFootballAct",WZUIContainer)
	conQuiz:setVisible(true)
	local footballQuizItemId = CacheCenter:getGameParam().footballQuizItemId
	local footballQuizItemName = GDatatab_item["id_"..footballQuizItemId].name
	local nQuizItemNum = 0
	if footballQuizItemId then
		nQuizItemNum = CacheCenter:getPlayerItemCountById(footballQuizItemId)
	end
	if nTag == 1 then
		GetElement(self.m_root,"conQuiz1RankTitle_WndFootballAct",WZUIContainer):setVisible(true)
		GetElement(self.m_root,"conQuiz1Coin_WndFootballAct",WZUIContainer):setVisible(false)
	else
		GetElement(self.m_root,"conQuiz1RankTitle_WndFootballAct",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"conQuiz1Coin_WndFootballAct",WZUIContainer):setVisible(true)
		GetElement(self.m_root,"txtQuiz1Coin_WndFootballAct",WZUILabelTTF):setText(footballQuizItemName..":"..nQuizItemNum)
	end
	WndFootballGuessList:showInterface(conQuiz, nTag)
end

function WndFootballAct:onJumpQuizMain(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	GetElement(self.m_root,"conQuiz0_WndFootballAct",WZUIContainer):setVisible(true)
	GetElement(self.m_root,"conQuiz1_WndFootballAct",WZUIContainer):setVisible(false)
end

function WndFootballAct:btnClickBack(tdata)
	WZLog("WndFootballAct:btnClickBack",Serialize(tdata))
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	GetElement(self.m_root,"conQuiz0_WndFootballAct",WZUIContainer):setVisible(true)
	local conQuiz = GetElement(self.m_root,"conQuiz1_WndFootballAct",WZUIContainer)
	conQuiz:setVisible(false)

	self.curMatchData = tdata
	for k, v in pairs(self.m_tLeftList) do
		v:setHighLight(false)
		if k == self.curMatchData.matchId then
			v:setHighLight(true)
		end
	end
	self:_updateRight()
end

function WndFootballAct:onBetClickback(element)
	WZLog("WndFootballAct:onBetClickback",element:getTag())	
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.curMatchData.status ~= 0 or SystemTime:getServerTime() >= self.curMatchData.matchStartLeaveTime then
		MsgBoxManager:showTipBox(LocalStrings.GAME_STARTED_CAN_NOT_BET)
		return
	end

	self.nBettedNum = 0
	GetElement(self.m_root,"txtBetNum_WndFootballAct",WZUILabelTTF):setText(self.nBettedNum)

	local footballQuizItemId = CacheCenter:getGameParam().footballQuizItemId
	local nQuizItemNum = 0
	if footballQuizItemId then
		nQuizItemNum = CacheCenter:getPlayerItemCountById(footballQuizItemId)
	end
	WZLog("WndFootballAct:onBetClickback nQuizItemNum",nQuizItemNum)

	local conBet = GetElement(self.m_root,"conBet_WndFootballAct",WZUIContainer)
	conBet:setVisible(not conBet:isVisible())

	local curHomeTeam = GDatatab_football_team["id_"..self.curMatchData.homeTeam]
	local curVisitTeam = GDatatab_football_team["id_"..self.curMatchData.visitTeam]
	self.nselectTeam = element:getTag()
	if element:getTag() == 1 then
		GetElement(self.m_root,"txtBetTip1_WndFootballAct",WZUILabelTTF):setText(string.format(LocalStrings.CURRENT_BET_WHO_WINS,curHomeTeam.name..LocalStrings.WORD_WIN))
	elseif element:getTag() == 2 then
		GetElement(self.m_root,"txtBetTip1_WndFootballAct",WZUILabelTTF):setText(string.format(LocalStrings.CURRENT_BET_WHO_WINS,curVisitTeam.name..LocalStrings.WORD_WIN))
	elseif element:getTag() == 3 then
		GetElement(self.m_root,"txtBetTip1_WndFootballAct",WZUILabelTTF):setText(string.format(LocalStrings.CURRENT_BET_WHO_WINS,LocalStrings.DRAW))
	end
	if footballQuizItemId then
		GetElement(self.m_root,"txtBetTip2_WndFootballAct",WZUILabelTTF):setText(string.format(LocalStrings.BET_AVAILABLE,0,0,GDatatab_item["id_"..footballQuizItemId].name))
	end
	GetElement(self.m_root,"txtBetTip3_WndFootballAct",WZUILabelTTF):setText(LocalStrings.SHOP_GOODSSHEGN..":"..nQuizItemNum)

end

function WndFootballAct:onChangeBetNum(element)
	WZLog("WndFootballAct:onChangeBetNum",element:getTag())
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local footballQuizItemId = CacheCenter:getGameParam().footballQuizItemId
	local footballQuizItemName = GDatatab_item["id_"..footballQuizItemId].name
	local nQuizItemNum = 0
	if footballQuizItemId then
		nQuizItemNum = CacheCenter:getPlayerItemCountById(footballQuizItemId)
	end
	if nQuizItemNum == 0 then
		MsgBoxManager:showTipBox(string.format(LocalStrings.CARD_COUNT1,footballQuizItemName))
	end
	if element:getTag() == 1 then
		if 0 == self.nBettedNum then
			MsgBoxManager:showTipBox(LocalStrings.CHESTMINNUM)
		end
		self.nBettedNum = math.max(self.nBettedNum-1000,0)
	elseif element:getTag() == 2 then
		if 0 == self.nBettedNum then
			MsgBoxManager:showTipBox(LocalStrings.CHESTMINNUM)
		end
		self.nBettedNum = math.max(self.nBettedNum-100,0)
	elseif element:getTag() == 3 then
		if nQuizItemNum == self.nBettedNum then
			MsgBoxManager:showTipBox(LocalStrings.CHESTMAXNUM)
		end
		self.nBettedNum = math.min(self.nBettedNum+100,nQuizItemNum)
	elseif element:getTag() == 4 then
		if nQuizItemNum == self.nBettedNum then
			MsgBoxManager:showTipBox(LocalStrings.CHESTMAXNUM)
		end
		self.nBettedNum = math.min(self.nBettedNum+1000,nQuizItemNum)
	elseif element:getTag() == 5 then
		if nQuizItemNum == self.nBettedNum then
			MsgBoxManager:showTipBox(LocalStrings.CHESTMAXNUM)
		end
		self.nBettedNum = nQuizItemNum
	end
	GetElement(self.m_root,"txtBetNum_WndFootballAct",WZUILabelTTF):setText(self.nBettedNum)

	local WinRate = 1
	if self.nselectTeam == 1 then
		WinRate = tonumber(self.curMatchData.win)
	elseif self.nselectTeam == 2 then
		WinRate = tonumber(self.curMatchData.lose)
	elseif self.nselectTeam == 3 then
		WinRate = tonumber(self.curMatchData.draw)
	end
	if footballQuizItemId then
		GetElement(self.m_root,"txtBetTip2_WndFootballAct",WZUILabelTTF):setText(string.format(LocalStrings.BET_AVAILABLE,self.nBettedNum,self.nBettedNum*WinRate,GDatatab_item["id_"..footballQuizItemId].name))
	end
	GetElement(self.m_root,"txtBetTip3_WndFootballAct",WZUILabelTTF):setText(LocalStrings.SHOP_GOODSSHEGN..":"..(nQuizItemNum-self.nBettedNum))
end

function WndFootballAct:onConfirmBet(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.curMatchData.status ~= 0 or SystemTime:getServerTime() >= self.curMatchData.matchStartLeaveTime then
		MsgBoxManager:showTipBox(LocalStrings.GAME_STARTED_CAN_NOT_BET)
		return
	end
	if self.nBettedNum == 0 then 
		MsgBoxManager:showTipBox(LocalStrings.FOOTBALL_TEXT4)
		return 
	end
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_BetOnFootballMatch(self.curMatchData.matchId, self.nselectTeam, self.nBettedNum )
end

function WndFootballAct:updateBetNum()
	self.nBettedNum = 0
	local footballQuizItemId = CacheCenter:getGameParam().footballQuizItemId
	local footballQuizItemName = GDatatab_item["id_"..footballQuizItemId].name
	local nQuizItemNum = 0
	if footballQuizItemId then
		nQuizItemNum = CacheCenter:getPlayerItemCountById(footballQuizItemId)
	end
	GetElement(self.m_root,"txtBetNum_WndFootballAct",WZUILabelTTF):setText(self.nBettedNum)
	GetElement(self.m_root,"txtBetTip2_WndFootballAct",WZUILabelTTF):setText(string.format(LocalStrings.BET_AVAILABLE,0,0,GDatatab_item["id_"..footballQuizItemId].name))
	GetElement(self.m_root,"txtBetTip3_WndFootballAct",WZUILabelTTF):setText(LocalStrings.SHOP_GOODSSHEGN..":"..(nQuizItemNum-self.nBettedNum))
end

function WndFootballAct:onCloseBet(element)
	local conBet = GetElement(self.m_root,"conBet_WndFootballAct",WZUIContainer)
	if conBet:isVisible() then
		conBet:setVisible(false)
	end
end

function WndFootballAct:_updateRight()
	local conQuiz0 = GetElement(self.m_root,"conQuiz0_WndFootballAct",WZUIContainer)
	conQuiz0:setVisible(true)
	local conQuiz1 = GetElement(self.m_root,"conQuiz1_WndFootballAct",WZUIContainer)
	if conQuiz1:isVisible() then
		conQuiz0:setVisible(false)
	end


	local curHomeTeam = GDatatab_football_team["id_"..self.curMatchData.homeTeam]
	local curVisitTeam = GDatatab_football_team["id_"..self.curMatchData.visitTeam]
	GetElement(self.m_root,"txtBet1_WndFootballAct",WZUILabelTTF):setText(curHomeTeam.name .. LocalStrings.WORD_WIN.." "..self.curMatchData.winNum)
	GetElement(self.m_root,"txtBet2_WndFootballAct",WZUILabelTTF):setText(LocalStrings.GUESS_DRAW.." "..self.curMatchData.drawNum)
	GetElement(self.m_root,"txtBet3_WndFootballAct",WZUILabelTTF):setText(curVisitTeam.name .. LocalStrings.WORD_WIN.." "..self.curMatchData.loseNum)

	GetElement(self.m_root,"imgHomeTeam_WndFootballAct",WZUIImage):setFile("ui/football/country/"..curHomeTeam.icon)
	GetElement(self.m_root,"txtHomeTeam_WndFootballAct",WZUILabelTTF):setText(curHomeTeam.name)
	GetElement(self.m_root,"imgVisitTeam_WndFootballAct",WZUIImage):setFile("ui/football/country/"..curVisitTeam.icon)
	GetElement(self.m_root,"txtVisitTeam_WndFootballAct",WZUILabelTTF):setText(curVisitTeam.name)

	GetElement(self.m_root,"txtBtn1_1_3_WndFootballAct",WZUILabelTTF):setText(curHomeTeam.name..LocalStrings.WORD_WIN)
	GetElement(self.m_root,"txtBtn1_1_1_WndFootballAct",WZUILabelTTF):setText(curHomeTeam.name..LocalStrings.WORD_WIN)
	GetElement(self.m_root,"txtBtn1_1_2_WndFootballAct",WZUILabelTTF):setText(curHomeTeam.name..LocalStrings.WORD_WIN)
	GetElement(self.m_root,"txtBtn2_1_3_WndFootballAct",WZUILabelTTF):setText(LocalStrings.DRAW)
	GetElement(self.m_root,"txtBtn2_1_1_WndFootballAct",WZUILabelTTF):setText(LocalStrings.DRAW)
	GetElement(self.m_root,"txtBtn2_1_2_WndFootballAct",WZUILabelTTF):setText(LocalStrings.DRAW)
	GetElement(self.m_root,"txtBtn3_1_3_WndFootballAct",WZUILabelTTF):setText(curVisitTeam.name..LocalStrings.WORD_WIN)
	GetElement(self.m_root,"txtBtn3_1_1_WndFootballAct",WZUILabelTTF):setText(curVisitTeam.name..LocalStrings.WORD_WIN)
	GetElement(self.m_root,"txtBtn3_1_2_WndFootballAct",WZUILabelTTF):setText(curVisitTeam.name..LocalStrings.WORD_WIN)

	GetElement(self.m_root,"txtBtn1_2_3_WndFootballAct",WZUILabelTTF):setText(LocalStrings.FOOTBALL_TEXT7 .. self.curMatchData.win)
	GetElement(self.m_root,"txtBtn1_2_1_WndFootballAct",WZUILabelTTF):setText(LocalStrings.FOOTBALL_TEXT7 .. self.curMatchData.win)
	GetElement(self.m_root,"txtBtn1_2_2_WndFootballAct",WZUILabelTTF):setText(LocalStrings.FOOTBALL_TEXT7 .. self.curMatchData.win)
	GetElement(self.m_root,"txtBtn2_2_3_WndFootballAct",WZUILabelTTF):setText(LocalStrings.FOOTBALL_TEXT7 .. self.curMatchData.draw)
	GetElement(self.m_root,"txtBtn2_2_1_WndFootballAct",WZUILabelTTF):setText(LocalStrings.FOOTBALL_TEXT7 .. self.curMatchData.draw)
	GetElement(self.m_root,"txtBtn2_2_2_WndFootballAct",WZUILabelTTF):setText(LocalStrings.FOOTBALL_TEXT7 .. self.curMatchData.draw)
	GetElement(self.m_root,"txtBtn3_2_3_WndFootballAct",WZUILabelTTF):setText(LocalStrings.FOOTBALL_TEXT7 .. self.curMatchData.lose)
	GetElement(self.m_root,"txtBtn3_2_1_WndFootballAct",WZUILabelTTF):setText(LocalStrings.FOOTBALL_TEXT7 .. self.curMatchData.lose)
	GetElement(self.m_root,"txtBtn3_2_2_WndFootballAct",WZUILabelTTF):setText(LocalStrings.FOOTBALL_TEXT7 .. self.curMatchData.lose)

	self:_updateCountDown()
	if self.curMatchData.status ~= 0 then 
		WZLog("_updateCountDown1")
		GetElement(self.m_root,"txtMatchResults_WndFootballAct",WZUILabelTTF):setText(string.format(LocalStrings.MATCH_RESULTS,self.curMatchData.homeTeamScore,self.curMatchData.visitTeamScore))
		GetElement(self.m_root,"txtMatchResults_WndFootballAct",WZUILabelTTF):setVisible(true)
		GetElement(self.m_root,"txtCountdown_WndFootballAct",WZUILabelTTF):setVisible(false)
		GetElement(self.m_root,"txtCountdownTip_WndFootballAct",WZUILabelTTF):setVisible(false)
	else
		WZLog("_updateCountDown2")
		GetElement(self.m_root,"txtMatchResults_WndFootballAct",WZUILabelTTF):setVisible(false)
		GetElement(self.m_root,"txtCountdown_WndFootballAct",WZUILabelTTF):setVisible(true)
		GetElement(self.m_root,"txtCountdownTip_WndFootballAct",WZUILabelTTF):setVisible(true)
		self.m_root:enableSchedule("_updateCountDown",1)
	end

	-- self:_updateCountDown()
	-- WZLog("_updateCountDown")
	-- self.m_root:enableSchedule("_updateCountDown",1)
end

function WndFootballAct:_updateCountDown(element)
	--WZLog("WndFootballAct:_updateCountDown",SystemTime:getServerTime(),self.curMatchData.matchStartLeaveTime)
	local countdown = 0
	if SystemTime:getServerTime() < self.curMatchData.matchStartLeaveTime then
		countdown = self.curMatchData.matchStartLeaveTime - SystemTime:getServerTime()
	else 
		countdown = 0
	end
	day = math.floor(countdown/(24*3600))
	hour = math.floor(countdown%(24*3600)/3600)
	min = math.floor(countdown%3600/60)
	sec = math.floor(countdown%60)
	GetElement(self.m_root,"txtCountdown_WndFootballAct",WZUILabelTTF):setText(string.format(LocalStrings.COUNTDOWN_TO_THE_GAME,day,hour,min,sec))
	if self.curMatchData.status ~= 0 or countdown <= 0 then
		GetElement(self.m_root,"txtCountdown_WndFootballAct",WZUILabelTTF):setText(LocalStrings.THE_GAME_HAS_STARTED)
		if element then
			element:disableSchedule()
		end
		-- ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetFootballQuizInfoList( )
	end
end

--@brief 	设置积分图标
function WndFootballAct:_setIcon(itemId)
	-- body
	local basicData = GDatatab_item["id_" .. itemId]
	if basicData then
		local imgIcon = GetElement(self.m_root, "imgIcon_WndFootballAct", WZUIImage)
		imgIcon:setScale(0.5)
		imgIcon:setFile(basicData.icon)
	end
end

function WndFootballAct:_moreLanguage()
	GetElement(self.m_root,"txtBet1_WndFootballAct",WZUILabelTTF):setText("")
	GetElement(self.m_root,"txtBet2_WndFootballAct",WZUILabelTTF):setText("")
	GetElement(self.m_root,"txtBet3_WndFootballAct",WZUILabelTTF):setText("")
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------私有方法模块End----------------------------------------
function WndFootballAct:_adaptLanguage_vn(  )
	GetElement(self.m_root,"txtCountdown_WndFootballAct",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,0.713157))
	GetElement(self.m_root,"txtCountdownTip_WndFootballAct",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,0.636841))

	GetElement(self.m_root,"txtPrize1_WndFootballAct",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtPrize2_WndFootballAct",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtPrize3_WndFootballAct",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtRecoeds1_WndFootballAct",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtRecoeds2_WndFootballAct",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtRecoeds3_WndFootballAct",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtRanking1_WndFootballAct",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtRanking2_WndFootballAct",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtRanking3_WndFootballAct",WZUILabelTTF):setScale(0.7)
end
-------------------------------------私有方法模块End----------------------------------------