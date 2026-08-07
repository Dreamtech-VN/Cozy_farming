--WndLeagueApplyData.lua
--@brief	WndLeagueApply的数据模块
--@date		2016/06/14
--@author	zsq
--@note		战队申请

WndLeagueApply = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndLeagueApply:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tDataList = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndLeagueApply:_unInit()
	self.m_root = nil
	self.m_tDataList = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndLeagueApply:createElement()
	local element = WZUISystem:getInstance():createElement("WndLeagueApply")
	assert(element, "WndLeagueApply create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndLeagueApply:setData(myTeamScore, myTeamTatus, teamId, url, score, rank, name)
	self.m_tDataList = {}
	for i=1,#teamId do
		local tempList = {}
		tempList.id = teamId[i]
		tempList.url = url[i]
		tempList.score = score[i]
		tempList.rank = rank[i]
		tempList.name = name[i]
		table.insert(self.m_tDataList,tempList)
	end
	--for i=1,4000 do
	--	local tempList = {}
	--	tempList.id = i
	--	tempList.url = ""
	--	tempList.score = i
	--	tempList.rank = i
	--	tempList.name = "战队"..i
	--	table.insert(self.m_tDataList,tempList)
	--end
	table.sort(self.m_tDataList, _sortTeam)

	self.myTeamScore = myTeamScore	
	self.myTeamTatus = myTeamTatus	

	WZLog("报名列表",myTeamScore,myTeamTatus,Serialize(self.m_tDataList))
	
	self:update()
end

function _sortTeam(a,b)
	if a.score ~= b.score then
		return a.score > b.score
	else
		return a.id < b.id
	end
end


-------------------------------------私有方法模块End----------------------------------------
