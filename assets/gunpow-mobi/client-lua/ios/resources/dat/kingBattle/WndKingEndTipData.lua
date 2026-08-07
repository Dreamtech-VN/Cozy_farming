--WndKingEndTipData.lua
--@brief	WndKingEndTip的数据模块
--@date		2015/5/12
--@author	Zjh
--@note		

WndKingEndTip = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndKingEndTip:_init()
	self.m_root = nil	 	  			--场景根节点
	
	self.m_nBattleTimes = 0             --战斗场数
	self.m_nWinTimes = 0                --胜利场数

	self.m_nMaxWinningStreak = 0        --最高连胜场数
	self.m_nTodayScore = 0              --今日获得积分
	self.m_nTodayMoney = 0              --今日获得弹王币
	self.m_nKingRank = 0                --弹王排名
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndKingEndTip:_unInit()
	self.m_root = nil	
	
	self.m_nBattleTimes = 0
	self.m_nWinTimes = 0
	
	self.m_nMaxWinningStreak = 0
	self.m_nTodayScore = 0
	self.m_nTodayMoney = 0
	self.m_nKingRank = 0
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndKingEndTip:createElement()
	local element = WZUISystem:getInstance():createElement("WndKingEndTip")
	assert(element, "WndKingEndTip create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
