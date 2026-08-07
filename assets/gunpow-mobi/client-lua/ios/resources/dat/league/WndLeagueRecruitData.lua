--WndLeagueRecruitData.lua
--@brief	WndLeagueRecruit的数据模块
--@date		2016/06/14
--@author	zsq
--@note		战队审批

WndLeagueRecruit = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndLeagueRecruit:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tDataList = nil
	self.m_tID = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndLeagueRecruit:_unInit()
	self.m_root = nil
	self.m_tDataList = nil
	self.m_tID = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndLeagueRecruit:createElement()
	local element = WZUISystem:getInstance():createElement("WndLeagueRecruit")
	assert(element, "WndLeagueRecruit create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndLeagueRecruit:setData(playerId, level, playerName, outTeamNum, fight, faceId, headId, sex, vip, headColor)
	self.m_tDataList = {}
	for i=1,#playerId do
		local tempList = {}
		tempList.playerId = playerId[i]
		tempList.level = level[i]
		tempList.playerName = playerName[i]
		tempList.outTeamNum = outTeamNum[i]
		tempList.fight = fight[i]
		tempList.faceId = faceId[i]
		tempList.headId = headId[i]
		tempList.sex = sex[i]
		tempList.vip = vip[i]
		tempList.headColor = headColor[i]
		table.insert(self.m_tDataList,tempList)
	end
	
	WZLog("申请列表",Serialize(self.m_tDataList))
	GlobalGame:getGameEventDispathcer():Dispatch("GameState_Change","state_hero_build_team")
	self:update()
end


-------------------------------------私有方法模块End----------------------------------------
