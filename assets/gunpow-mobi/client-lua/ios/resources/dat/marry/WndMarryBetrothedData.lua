--WndMarryBetrothedData.lua
--@brief	WndMarryBetrothed的数据模块
--@date		2014/01/15
--@author	叶威
--@note		已订婚界面

WndMarryBetrothed = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndMarryBetrothed:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_nWeddingType = 1             --当前婚礼类型，定义参看WndMarryManager
	self.m_tData = nil                  --存储数据的表
	self.mWedTimeTag = 2                --时间段标记
	self.m_nMyWeddingTime = nil         --我的婚礼开始时间
	self.m_nInType = 1                  --婚礼邀请请柬默认1
	self.m_tInviteFriendData = nil 		--发送请柬的好友数据
end



--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndMarryBetrothed:_unInit()
	self.m_root = nil
    self.m_nWeddingType = nil
	self.m_tData = nil                  --存储数据的表
	self.mWedTimeTag = nil                --时间段标记
	self.m_nMyWeddingTime = nil         --我的婚礼开始时间
	self.m_nInType = nil
	self.m_tInviteFriendData = nil 		--发送请柬的好友数据
end



--@brief	设置我的结婚时间
function WndMarryBetrothed:setMyWeddingTime(nMyWeddingTime)
	self.m_nMyWeddingTime = nMyWeddingTime
end


--[[

WndMarryBetrothed:setCanWedTime(self.m_tData.timeId[1],self.m_tData.timeId[2],
									self.m_tData.startTime[1],self.m_tData.startTime[2],
									self.m_tData.endTime[2],self.m_tData.endTime[2])
--]]



-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndMarryBetrothed:createElement()
	local element = WZUISystem:getInstance():createElement("WndMarryBetrothed")
	assert(element, "WndMarryBetrothed create element failed!")
	self:_init()
	return element
end

--@brief  设置选择的举办婚礼类型
function WndMarryBetrothed:setWeddingType(weddingType)
	WZLog("WndMarryBetrothed:setWeddingType = ",weddingType)
	self.m_nWeddingType = weddingType
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
