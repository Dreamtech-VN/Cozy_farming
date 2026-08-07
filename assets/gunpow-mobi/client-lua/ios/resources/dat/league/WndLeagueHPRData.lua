--WndLeagueHPRData.lua
--@brief	WndLeagueHPR的数据模块
--@date		2016/06/15
--@author	Tianxiang_Xu
--@note		英雄联赛-荣誉、回放、奖励

WndLeagueHPR = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function WndLeagueHPR:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_nIndex = nil 		--选中标签索引
	self.m_tHonourData = nil 	--荣誉数据
	self.m_tReplayData = nil 	--回放数据
	self.m_tRewardData = nil 	--奖励数据
	self.m_tHonourItemList = nil --荣誉左边列表
	self.m_tReplayItemList = nil --回放左边列表
	self.m_tRewardItemList = nil --奖励左边列表
	self.m_nCurIndex = nil 		 --当前选中的左边列表索引
	self.m_nWinNum = 0 		 --胜利次数
	self.m_nFightNum = 0 		 --战斗次数
	self.m_nLoadingId = nil 	
	self.m_sStartTime = nil 
	self.m_sEndTime = nil 
	self.m_sGiveRewardsTime = nil 
	self.m_nKillNum = nil 
	self.m_nMyTeamRank = nil 
	self.m_Element = nil 
	self.m_nClickId = nil 
	self.m_nPositionIndex = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndLeagueHPR:_unInit()
	self.m_root = nil
	self.m_nIndex = nil 		--选中标签索引
	self.m_tHonourData = nil 	--荣誉数据
	self.m_tReplayData = nil 	--回放数据
	self.m_tRewardData = nil 	--奖励数据
	self.m_tHonourItemList = nil --荣誉左边列表
	self.m_tReplayItemList = nil --回放左边列表
	self.m_tRewardItemList = nil --奖励左边列表
	self.m_nCurIndex = nil 		 --当前选中的左边列表索引
	self.m_nWinNum = nil 		 --胜利次数
	self.m_nFightNum = nil 		 --战斗次数
	self.m_nLoadingId = nil 	
	self.m_sStartTime = nil 
	self.m_sEndTime = nil 
	self.m_sGiveRewardsTime = nil 
	self.m_nKillNum = nil 
	self.m_nMyTeamRank = nil 
	self.m_Element = nil 
	self.m_nClickId = nil 
	self.m_nPositionIndex = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function WndLeagueHPR:createElement()
	local element = WZUISystem:getInstance():createElement("WndLeagueHPR")
	assert(element, "WndLeagueHPR create element failed!")
	self:_init()
	return element
end

--@brief    外部公共接口
function WndLeagueHPR:showInterface(parentNode, nIndex)
    -- body
    if self.m_root ~= nil then
        self.m_root:removeFromParentAndCleanup(true)
    end

    local wndLeagueHPR = WndLeagueHPR:createElement()
    self.m_nIndex = nIndex
    parentNode:addChild(wndLeagueHPR)
end

--@brief 	设置荣誉左边列表数据
function WndLeagueHPR:setHonourItemData(teamId, teamName, periodNum)
	--body
	self.m_tHonourItemList = nil 
	self.m_tHonourItemList = {}
	
	for i = 0, periodNum:size() - 1 do
		local tItem = {}
		tItem.roundId = periodNum:get(i)
		tItem.teamId = teamId:get(i)
		tItem.teamName = teamName:get(i)

		table.insert(self.m_tHonourItemList, tItem)
	end
	self:_closeLoading()
	table.sort(self.m_tHonourItemList, sortHonourItem)
	WZLog("WndLeagueHPR:setHonourData", Serialize(self.m_tHonourItemList))
	--创建荣誉左菜单列表
	self:_createHonourList()
end

--@brief  	设置荣誉数据
function WndLeagueHPR:setHonourData(teamId, teamName, photoURL, declaration, playerId, name, level, sex, faceId, headId, bodyId, wingId, mvpMark, captain)
	-- body
	self.m_tHonourData = {}

	self.m_tHonourData.roundId = self.m_nCurIndex
	self.m_tHonourData.teamId = teamId
	self.m_tHonourData.teamName = teamName
	self.m_tHonourData.teamWords = declaration
	self.m_tHonourData.teamIcon = photoURL
	
	self.m_tHonourData.player = {}
	for i = 0, playerId:size() - 1 do
		local tItem = {}
		tItem.id = playerId:get(i)
		tItem.name = name:get(i)
		tItem.level = level:get(i)
		tItem.sex = sex:get(i)
		tItem.headId = headId:get(i)
		tItem.faceId = faceId:get(i)
		tItem.bodyId = bodyId:get(i)
		tItem.wingId = wingId:get(i)
		tItem.mvpMark = mvpMark:get(i)

		if playerId:get(i) == captain then
			tItem.leader = 1 
		else
			tItem.leader = 0 
		end

		table.insert(self.m_tHonourData.player, tItem)
	end
	
	self:_closeLoading()
	WZLog("WndLeagueHPR:setHonourData", Serialize(self.m_tHonourData))
	self:_createHonourContent()
end

--@brief 	设置回放左边列表数据
function WndLeagueHPR:setReplayItemData()
	--body
	if self.m_tReplayItemList == nil then 
		self.m_tReplayItemList = {
	--	{id = 1, itemName = LocalStrings.LEAGUE_REPLAY_ITEM1},
		{id = 2, itemName = LocalStrings.LEAGUE_REPLAY_ITEM2},
		{id = 3, itemName = LocalStrings.LEAGUE_REPLAY_ITEM3},
		} --{id = 4, itemName = LocalStrings.LEAGUE_REPLAY_ITEM4} 
	end
	--创建回放左菜单列表
	self:_createReplayList()
end

--@brief  	设置回放数据
--@param 	channel:1为海选赛，2为三十二强，3为十六强，4为八强，5为四强，6为决赛
--@param 	winteamId:回放/正在进行时候的观战人数
function WndLeagueHPR:setReplayData(id, teamId, teamName, photoURL, winteamId, channel, isnew)
	-- body
	self.m_tReplayData = nil 
	self.m_tReplayData = {}

	local nTeamIndex = 0 
	for i = 0, id:size() - 1 do
		local tItem = {}
		tItem.id = id:get(i)
		WZLog("WndLeagueHPR:setReplayData", channel:get(i))
		if channel:get(i) == 1 then
			tItem.mark = LocalStrings.LEAGUE_REPLAY_TEXT7
		elseif channel:get(i) == 2 then
			tItem.mark = LocalStrings.LEAGUE_REPLAY_TEXT8
		elseif channel:get(i) == 3 then
			tItem.mark = LocalStrings.LEAGUE_REPLAY_TEXT9
		elseif channel:get(i) == 4 then
			tItem.mark = LocalStrings.LEAGUE_REPLAY_TEXT10
		elseif channel:get(i) == 5 then
			tItem.mark = LocalStrings.LEAGUE_REPLAY_TEXT11
		elseif channel:get(i) == 6 then
			tItem.mark = LocalStrings.LEAGUE_REPLAY_TEXT12
		end
		if self.m_nCurIndex ~= 1 then
			if isnew:get(i) == 2 then
				tItem.state = -1
			else
				tItem.state = 1
			end
			tItem.checkNum = 0
		else
			tItem.checkNum = winteamId:get(i)
		end
		
		tItem.team1 = {}
		tItem.team1.teamId = teamId:get(nTeamIndex) 
		tItem.team1.teamName = teamName:get(nTeamIndex)
		tItem.team1.teamIcon = photoURL:get(nTeamIndex)
		
		if self.m_nCurIndex ~= 1 and winteamId:get(i) == tItem.team1.teamId then
			tItem.team1.result = 1
		else
			tItem.team1.result = 0
		end

		nTeamIndex = nTeamIndex + 1
		
		tItem.team2 = {}
		tItem.team2.teamId = teamId:get(nTeamIndex) 
		tItem.team2.teamName = teamName:get(nTeamIndex)
		tItem.team2.teamIcon = photoURL:get(nTeamIndex)
		
		if self.m_nCurIndex ~= 1 and winteamId:get(i) == tItem.team2.teamId then
			tItem.team2.result = 1
		else
			tItem.team2.result = 0
		end
		nTeamIndex = nTeamIndex + 1

		table.insert(self.m_tReplayData, tItem)
	end
	WZLog("WndLeagueHPR:setReplayData", Serialize(self.m_tReplayData), channel:size())
	self:_closeLoading()
	--创建回放右边栏列表
	self:_createReplayContent()
end

--@brief 	设置奖励左边列表数据
function WndLeagueHPR:setRewardItemData()
	--body
	if self.m_tRewardItemList == nil then 
		self.m_tRewardItemList = {{id = 1, itemName = LocalStrings.LEAGUE_REWARD_ITEM1},
		{id = 2, itemName = LocalStrings.LEAGUE_REWARD_ITEM2},
		{id = 3, itemName = LocalStrings.LEAGUE_REWARD_ITEM3},
		{id = 4, itemName = LocalStrings.LEAGUE_REWARD_ITEM4}}
	end
	--创建回放左菜单列表
	self:_createRewardList()
end

--@brief  	设置奖励数据
function WndLeagueHPR:setRewardsData(rewardId, state, complete, target, startTime, endTime, dayFightNum, dayWinNum, rewardTime, killNum, myTeamRank)
	-- body
	WZLog("WndLeagueHPR:setRewardsData")
	self.m_tRewardData = {}
	self.m_nFightNum = dayFightNum
	self.m_nWinNum = dayWinNum
	self.m_sStartTime = startTime 
	self.m_sEndTime = endTime 
	self.m_sGiveRewardsTime = rewardTime 
	self.m_nKillNum = killNum 
	self.m_nMyTeamRank = myTeamRank 

	WZLog("WndLeagueHPR:setRewardsData", rewardId:size(), dayFightNum, dayWinNum, killNum, myTeamRank, rewardTime)

	for idx, value in pairs(GDatatab_hero_reward) do
		if value.type == self.m_nCurIndex then
			local tItem = {}
			tItem.id = value.id 
			tItem.type = value.type
			tItem.title = value.name 
			tItem.reward = value.reward 
			tItem.rank = value.rank
			for i = 0, rewardId:size() - 1 do
				if value.id == rewardId:get(i) then
					tItem.nComplete = complete:get(i)
					tItem.nTarget = target:get(i)
					tItem.state = state:get(i)
				end
			end

			table.insert(self.m_tRewardData, tItem)
		end
	end
	table.sort(self.m_tRewardData, sortReward1)
	WZLog("WndLeagueHPR:setRewardsData", Serialize(self.m_tRewardData))
	--关闭加载框
	self:_closeLoading()
	WZLog("WndLeagueHPR:setRewardsData", Serialize(self.m_tRewardData))
	--关闭加载框
	self:_closeLoading()
	--创建回放右边栏列表
	self:_createRewardContent()
end

--@brief 	奖励排序行数
function sortReward1(a, b)
	-- body
	return a.id < b.id 
end

--@brief 	荣誉左边列表按届的降序排
function sortHonourItem(a, b)
	-- body
	return a.roundId > b.roundId
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------
