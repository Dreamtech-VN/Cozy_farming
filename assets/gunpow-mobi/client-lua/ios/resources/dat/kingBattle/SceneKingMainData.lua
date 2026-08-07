--SceneKingMainData.lua
--@brief	SceneKingMain 的数据模块
--@date		2015/5/8
--@author	Zjh
--@note		弹王界面

SceneKingMain = {
	--请不要在这里定义变量
	MAX_WAIT_TIME = 30,
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function SceneKingMain:_init()
	self.m_root = nil	 	  			--场景根节点
	
	self.m_nKingScore = 0               --弹王积分
	self.m_nKingMoney = 0               --弹王币
	self.m_nKingRank = 0                --弹王排名
	                                    
	self.m_nRestTimes = 0               --剩余战斗次数
	
	self.m_nWaitTime = 0                --剩余倒计时时间
	self.m_nMaxTimes = 0                --倒计时最大时长

	self.m_nBattleTimes = 0             --战斗场数
	self.m_nWinTimes = 0                --胜利场数
	
	self.m_nTodayScore = 0              --今日积分
	
	self.m_tDayAward = nil              --日积分奖励表
	self.m_nResetDiamond = 0			--重置钻石数
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function SceneKingMain:_unInit()
    WZLog("SceneKingMain:_unInit")
	self.m_root = nil
	
	self.m_nKingScore = 0
	self.m_nKingMoney = 0
	self.m_nKingRank = 0
	
	self.m_nRestTimes = 0
	self.m_nMaxTimes = 0
	
	self.m_nBattleTimes = 0
	self.m_nWinTimes = 0
	
	self.m_nTodayScore = 0
	self.m_nWaitTime = 0
	
	self.m_tDayAward = nil
	self.m_nResetDiamond = nil          
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function SceneKingMain:createElement()
	local element = WZUISystem:getInstance():createElement("SceneKingMain")
	assert(element, "SceneKingMain create element failed!")
	self:_init()
	self.m_root = element
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
