--WndKingRankData.lua
--@brief	WndKingRank的数据模块
--@date		2015/5/12
--@author	Zjh
--@note		

WndKingRank = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndKingRank:_init()
	self.m_root = nil	 	  			--场景根节点
	
	self.m_tData = nil
	
	self.m_nMyRank = 0                  --我的排名
	self.m_nMyScore = 0                 --我的积分
	self.m_nBattleTimes = 0             --我的战斗场数
	self.m_nWinTimes = 0                --我的胜利场数
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndKingRank:_unInit()
	self.m_root = nil
	
	self.m_tData = nil
	
	self.m_nMyRank = 0
	
	self.m_nMyScore = 0
	
	self.m_nBattleTimes = 0
	
	self.m_nWinTimes = 0
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndKingRank:createElement()
	local element = WZUISystem:getInstance():createElement("WndKingRank")
	assert(element, "WndKingRank create element failed!")
	self:_init()
	return element
end

function WndKingRank:setData(tData)
	self.m_tData = {}
	for i,v in ipairs(tData.playerId) do
		local data = {}
		data.m_nRank		= i
		data.m_nPlayerId	= tData.playerId[i]
		data.m_sName 		= tData.playerName[i]
		data.m_sServerName  = tData.serverName[i]
		data.m_nScore  		= tData.score[i]
		data.m_nBattleTimes = tData.battleTimes[i]
		data.m_nWinTimes    = tData.winTimes[i]
		table.insert(self.m_tData,data)
	end
	
	self.m_nMyRank 		= tData.myRank 		     
	self.m_nMyScore 	= tData.myScore 		    
	self.m_nBattleTimes = tData.myBattleTimes 
	self.m_nWinTimes 	= tData.myWinTimes 	
	
	self:_updateUI_dynamic()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
