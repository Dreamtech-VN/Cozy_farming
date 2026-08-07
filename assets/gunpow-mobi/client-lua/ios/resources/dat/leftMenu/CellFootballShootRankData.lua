--CellFootballShootRankData.lua
--@brief	CellFootballShootRank的数据模块
--@date		2018/06/05
--@author	Tianxiang_Xu
--@note		点球排名界面

CellFootballShootRank = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellFootballShootRank:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_root = nil
	self.m_tRankInfo = nil
	self.m_nMyRank = nil
	self.footballReward = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellFootballShootRank:_unInit()
	self.m_root = nil
	self.m_root = nil
	self.m_tRankInfo = nil
	self.m_nMyRank = nil
	self.footballReward = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellFootballShootRank:createElement()
	local element = WZUISystem:getInstance():createElement("CellFootballShootRank")
	assert(element, "CellFootballShootRank create element failed!")
	self:_init()
	return element
end

--设置排行榜信息
function CellFootballShootRank:setRankListInfo(ranking, playerId, name, faceId, headId, sex, level, vipLevel, headColour,score,myRank,otherServer, rewardList)
	WZLog("CellFootballShootRank:setRankListInfo")
	local tempRanking = {}
	for i,v in ipairs(ranking) do
		local tempp = {}
		table.insert(tempp,v)
		table.insert(tempp,playerId[i])
		table.insert(tempp,name[i])
		table.insert(tempp,faceId[i])
		table.insert(tempp,headId[i])
		table.insert(tempp,sex[i])
		table.insert(tempp,level[i])
		table.insert(tempp,vipLevel[i])
		table.insert(tempp,headColour[i])
		table.insert(tempp,score[i])
		table.insert(tempp,otherServer[i])

		table.insert(tempRanking,tempp)
	end
	table.sort(tempRanking,function (a,b)
		if a[1] < b[1] then
			return true
		end
		return false
	end)
	self.m_nMyRank = myRank
	self.m_tRankInfo = tempRanking
	self.footballReward = rewardList
	WZLog("CellFootballShootRank:setRankListInfo BBBB", Serialize(self.m_tRankInfo))
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
