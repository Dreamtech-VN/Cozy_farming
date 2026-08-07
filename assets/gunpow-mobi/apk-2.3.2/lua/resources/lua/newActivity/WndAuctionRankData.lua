--WndAuctionRankData.lua
--@brief	WndAuctionRank的数据模块
--@date		2020/08/04
--@author	yrd
--@note		竞拍榜

WndAuctionRank = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndAuctionRank:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nType = nil 					--1竞拍榜 2今日拍品 3鉴宝
	self.m_tData = nil
	self.m_myScore = nil 				--竞拍榜我的积分
	self.m_myRank = nil 				--竞拍榜我的排名
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndAuctionRank:_unInit()
	self.m_root = nil
	self.m_nType = nil
	self.m_tData = nil
	self.m_myScore = nil
	self.m_myRank = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndAuctionRank:createElement()
	if WndAuctionRank.m_root ~= nil then
		WindowManager:removeWindow(WndAuctionRank.m_root, WndAuctionRank, true)
	end
	local element = WZUISystem:getInstance():createElement("WndAuctionRank")
	assert(element, "WndAuctionRank create element failed!")
	self:_init()
	return element
end

function WndAuctionRank:showInterface(nType,tData)
	local wndAuctionRank = WndAuctionRank:createElement()
	WindowManager:addWindow(wndAuctionRank, WndAuctionRank, nil, nil, nil, true)

	self.m_nType = nType
	self.m_tData = tData

	self:updateUI()
end

--@brief	获取竞拍榜数据
function WndAuctionRank:getAuctionRankOk(rankType, rank, name, score, reward, myScore, myRank, faceIds, headIds, headColors, playerId)
	if self.m_tData == nil then
		self.m_tData = {}
	end
	if self.m_tData[rankType] == nil then
		self.m_tData[rankType] = {}
	end
	for i=1,#rank do
		local tempTab = {}
		tempTab.rank = rank[i]
		tempTab.name = name[i]
		tempTab.score = score[i]
		tempTab.reward = reward[i]
		tempTab.faceId = faceIds[i]
		tempTab.headId = headIds[i]
		tempTab.headColor = headColors[i]
		tempTab.playerId = playerId[i]
		table.insert(self.m_tData[rankType], tempTab)
	end
	self.m_nRankType = rankType
	if self.m_myScore == nil then
		self.m_myScore = {}
	end
	self.m_myScore[rankType] = myScore
	if self.m_myRank == nil then
		self.m_myRank = {}
	end
	self.m_myRank[rankType] = myRank

	self:updateRankUI()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
