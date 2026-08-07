--WndLeagueTeamListData.lua
--@brief	WndLeagueTeamList的数据模块
--@date		2016/06/12
--@author	zsq
--@note		战队列表

WndLeagueTeamList = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndLeagueTeamList:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tDataList = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndLeagueTeamList:_unInit()
	self.m_root = nil
	self.m_tDataList = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndLeagueTeamList:createElement()
	local element = WZUISystem:getInstance():createElement("WndLeagueTeamList")
	assert(element, "WndLeagueTeamList create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndLeagueTeamList:setData(teamId, teamName, playerNum, photoURL)
	self.m_tDataList = {}
	for i=1,#teamId do
		local tempList = {}
		tempList.id = teamId[i]
		tempList.icon = photoURL[i]
		tempList.name = teamName[i]
		tempList.memberNumber = playerNum[i]
		table.insert(self.m_tDataList,tempList)
	end
	
	WZLog("战队列表",Serialize(self.m_tDataList))
	GlobalGame:getGameEventDispathcer():Dispatch("GameState_Change","state_scene")
	self:update()
end




-------------------------------------私有方法模块End----------------------------------------
