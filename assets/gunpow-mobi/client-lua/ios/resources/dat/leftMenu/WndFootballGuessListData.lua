--WndFootballGuessListData.lua
--@brief	WndFootballGuessList的数据模块
--@date		2018/06/01
--@author	Tianxiang_Xu
--@note		足球精彩列表

WndFootballGuessList = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndFootballGuessList:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nType = nil 				--类型；1->排名；2->结果；3->商店
	self.m_tDataList = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndFootballGuessList:_unInit()
	self.m_root = nil
	self.m_nType = nil
	self.m_tDataList = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndFootballGuessList:createElement()
	local element = WZUISystem:getInstance():createElement("WndFootballGuessList")
	assert(element, "WndFootballGuessList create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndFootballGuessList:showInterface(parentNode, nType)
	-- body
	if parentNode:getChildByTag(99) then
		parentNode:removeChildByTag(99, true)
	end
	local wndGuess = WndFootballGuessList:createElement()
	if wndGuess then
		self.m_nType = nType or 1
		wndGuess:setTag(99)
		parentNode:addChild(wndGuess)
	end
end

--处理接收嫂烟花排行榜积分
function WndFootballGuessList:handleRankInfo(status, ranking, playerId, name, faceId, headId, sex, level, vipLevel, headColour,score, myRnak, otherServer)
    if self.m_root == nil then return end
    
    self.m_tDataList = {}

    for i = 1, #ranking do
		local tItem = {}
		tItem.rank = ranking[i]
		tItem.id = playerId[i]
		tItem.name = name[i]
		tItem.faceId = faceId[i]
		tItem.headId = headId[i]
		tItem.sex = sex[i]
		tItem.level = level[i]
		tItem.vipLevel = vipLevel[i]
		tItem.headColour = headColour[i]
		tItem.curNum = score[i]
		tItem.serverMark = otherServer[i]
		tItem.reward = {}
		for k = 1, #WndFootballAct.m_tRankReward do
			if tItem.rank >= WndFootballAct.m_tRankReward[k].minRank and tItem.rank <= WndFootballAct.m_tRankReward[k].maxRank then
				tItem.reward = WndFootballAct.m_tRankReward[k].reward
				break 
			end
		end

		table.insert(self.m_tDataList, tItem)
	end
    WZLog("WndFootballGuessList:handleRankInfo", Serialize(self.m_tDataList))
    
    self:_update()
end

--@brief 	比赛结果列表
function WndFootballGuessList:handleResultInfo(matchId, status, homeTeam, visitTeam, winNum, loseNum, drawNum, gainNum)
    if status == 0 or self.m_root == nil then return end
    
    self.m_tDataList = {}

    for i = 1, #matchId do
		local tItem = {}
		tItem.matchId = matchId[i]
		tItem.state = status[i]
		tItem.name1 = GDatatab_football_team["id_" .. homeTeam[i]].name
		tItem.name2 = GDatatab_football_team["id_" .. visitTeam[i]].name
		tItem.num1 = winNum[i]
		tItem.num2 = loseNum[i]
		tItem.num3 = drawNum[i]
		tItem.num4 = gainNum[i]

		table.insert(self.m_tDataList, tItem)
	end
    WZLog("WndFootballGuessList:handleResultInfo", Serialize(self.m_tDataList))
    
    self:_update()
end

--@brief 	兑换列表
function WndFootballGuessList:handleShopInfo(id, item, cost, leftNum)
	--body
	self.m_tDataList = {}

	for i = 1, #id do
		local tItem = {}
		tItem.id = id[i]
		tItem.item = item[i]
		tItem.cost = cost[i]
		tItem.leftNum = leftNum[i]

		table.insert(self.m_tDataList, tItem)
	end

	WZLog("WndFootballGuessList:handleShopInfo", Serialize(self.m_tDataList))
    
    self:_update()
end

--@brief 	兑换商店购买东西成功
function WndFootballGuessList:buyOK(ids, item, leftNum)
	-- body
	local string = string.sub(item, 2, -2) 
	local id = SplitStringWithSeparator(string,",")[1]
	local num = SplitStringWithSeparator(string,",")[2]
	WZLog("WndFootballGuessList:buyOK", item)
	WndRewardShow:showById({tonumber(id)}, {tonumber(num)})
	--刷新剩余数量
	CellFootballGuessShop:updateLeftTimes(ids, leftNum)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
