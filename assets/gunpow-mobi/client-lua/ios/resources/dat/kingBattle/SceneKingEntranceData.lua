--SceneKingEntranceData.lua
--@brief	SceneKingEntrance的数据模块
--@date		2013/12/31
--@author	Zjh
--@note		弹王入口界面

SceneKingEntrance = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function SceneKingEntrance:_init()
	self.m_root = nil	 	  			--场景根节点
	                                    
	self.m_nKingScore = 0               --弹王积分
	self.m_nKingMoney = 0               --弹王币
	self.m_nKingRank = 0                --弹王排名
	                                    
	self.m_bStart = false               --弹王赛是否开启
	self.m_nRestTime = 0                --剩余开启/结束时间
	self.m_nNextStartTime = 0           --弹王赛下次从开始到结束的总时长
	self.m_nNextCloseTime = 0           --弹王赛下次从结束到开始的总时长
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function SceneKingEntrance:_unInit()
    WZLog("SceneKingEntrance:_unInit")
	self.m_root = nil
	
	self.m_nKingScore = 0
	self.m_nKingMoney = 0
	self.m_nKingRank = 0
	
	self.m_bStart = false
	self.m_nRestTime = 0
	self.m_nNextStartTime = 0
	self.m_nNextCloseTime = 0
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function SceneKingEntrance:createElement()
	local element = WZUISystem:getInstance():createElement("SceneKingEntrance")
	assert(element, "SceneKingEntrance create element failed!")
	self:_init()
	self.m_root = element
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
