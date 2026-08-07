--WndFootballActData.lua
--@brief	WndFootballAct的数据模块
--@date		2018/05/30
--@author	yeruida
--@note		足球竞猜

WndFootballAct = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndFootballAct:_init()
	self.m_root = nil	 	  			--场景根节点
	self.tQuizList = nil
	self.curMatchData = nil
	self.nBettedNum = 0					--已下注筹码
	self.nselectTeam = nil				--选择队伍
	self.m_tLeftList = {}		
	self.m_tipes = nil 
	self.m_rewardItems = nil 
	self.m_rewardItemsParamCount = nil 
	self.m_rewardCounts = nil 		
	self.m_tRankReward = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndFootballAct:_unInit()
	self.m_root = nil
	self.tQuizList = nil
	self.curMatchData = nil
	self.nBettedNum = nil
	self.nselectTeam = nil
	self.m_tLeftList = nil		
	self.m_tipes = nil 
	self.m_rewardItems = nil 
	self.m_rewardItemsParamCount = nil 
	self.m_rewardCounts = nil 				
	self.m_tRankReward = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndFootballAct:createElement()
	if WndFootballAct.m_root ~= nil then
		WindowManager:removeWindow(WndFootballAct.m_root, WndFootballAct, true)
	end
	local element = WZUISystem:getInstance():createElement("WndFootballAct")
	assert(element, "WndFootballAct create element failed!")
	self:_init()
	return element
end

function WndFootballAct:setMessage(tips, rewardItems, rewardItemsParamCount, rewardCounts)
	WZLog("--dgadga-----233545",Serialize(tips),Serialize(rewardItems),Serialize(rewardItemsParamCount),Serialize(rewardCounts))
	self.m_tipes = tips 
	self.m_rewardItems = rewardItems 
	self.m_rewardItemsParamCount = rewardItemsParamCount 
	self.m_rewardCounts = rewardCounts 	

	self.m_tRankReward = {}
	local nIndex = 1 
	for i = 1, #self.m_tipes do
		local tItem = {}
		local result = SplitStringWithSeparator(self.m_tipes[i], "-", nil, true)
		if #result == 1 then
			tItem.minRank = result[1]
			tItem.maxRank = result[1]
		else
			tItem.minRank = result[1]
			tItem.maxRank = result[2]
		end
		tItem.reward = {}
		for k = 1, self.m_rewardCounts[i] do
			table.insert(tItem.reward, {self.m_rewardItems[nIndex], self.m_rewardItemsParamCount[nIndex]})
			nIndex = nIndex + 1
		end

		table.insert(self.m_tRankReward, tItem)
	end	

	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetFootballQuizInfoList( )
end

-------------------------------------公有方法模块End----------------------------------------
function WndFootballAct:getQuizInfoListOk(matchId, homeTeam, homeTeamScore, visitTeam, visitTeamScore, win, lose, draw, matchStartLeaveTime, disappearLeaveTime, status, winNum, loseNum, drawNum)
	self.tQuizList = {}
	for i = 1, #matchId do
		tQuizList = {} 
		tQuizList.matchId = matchId[i]
		tQuizList.homeTeam = homeTeam[i]
		tQuizList.homeTeamScore = homeTeamScore[i]
		tQuizList.visitTeam = visitTeam[i]
		tQuizList.visitTeamScore = visitTeamScore[i]
		tQuizList.win = win[i]
		tQuizList.lose = lose[i]
		tQuizList.draw = draw[i]
		tQuizList.matchStartLeaveTime = matchStartLeaveTime[i]
		tQuizList.disappearLeaveTime = disappearLeaveTime[i]
		tQuizList.status = status[i]
		tQuizList.winNum = winNum[i]
		tQuizList.loseNum = loseNum[i]
		tQuizList.drawNum = drawNum[i]
		table.insert(self.tQuizList,tQuizList)
	end

	local function getSortValue(a)
		-- body
		local curTime = SystemTime:getServerTime()
		if curTime >= a.matchStartLeaveTime then
			return 2
		else
			return 1
		end
	end
	table.sort(self.tQuizList,function(a,b)
		if a.status ~= b.status then
			return a.status < b.status
		else
			local valueA = getSortValue(a)
			local valueB = getSortValue(b)
			if valueA ~= valueB then
				return valueA < valueB
			else
				return a.matchId < b.matchId 
			end
		end
	end)

	WZLog("WndFootballAct:getQuizInfoListOk",Serialize(self.tQuizList))

	if not self.curMatchData then
		self.curMatchData = self.tQuizList[1]
	end
	self:_updateLeft()
	self:_updateRight()
end

function WndFootballAct:getBetOnFootballMatchOk(matchId, actionType, num, winNum, loseNum, drawNum)
	MsgBoxManager:showTipBox(LocalStrings.FOOTBALL_TEXT5)
	for i = 1, #self.tQuizList do
		if self.tQuizList[i].matchId == matchId then
			self.tQuizList[i].winNum = winNum
			self.tQuizList[i].loseNum = loseNum
			self.tQuizList[i].drawNum = drawNum
		end
		if self.tQuizList[i].matchId == self.curMatchData.matchId then
			self.curMatchData = self.tQuizList[i]
		end
	end
	self:_updateRight()
	self:updateBetNum()
end


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
