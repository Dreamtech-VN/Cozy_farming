--CellFireworksAnnData.lua
--@brief	CellFireworksAnn的数据模块
--@date		2017/05/26
--@author	 
--@note		烟花排行榜

CellFireworksAnn = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellFireworksAnn:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tRankInfo = nil
	self.m_nMyRank = nil
	self.footballReward = nil 	--點球獎勵
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellFireworksAnn:_unInit()
	self.m_root = nil
	self.m_tRankInfo = nil
	self.m_nMyRank = nil
	self.footballReward = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellFireworksAnn:createElement()
	local element = WZUISystem:getInstance():createElement("CellFireworksAnn")
	assert(element, "CellFireworksAnn create element failed!")
	self:_init()
	return element
end

--设置排行榜信息
function CellFireworksAnn:setRankListInfo(ranking, playerId, name, faceId, headId, sex, level, vipLevel, headColour,score,myRank,otherServer, type,rewradList)
	WZLog("CellFireworksAnn:setRankListInfo")
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
	self.m_tRankInfo.type = type
	self.footballReward = rewradList
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
