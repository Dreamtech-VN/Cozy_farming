--WndGameSingInData.lua
--@brief	WndGameSingIn的数据模块
--@date		2015/04/29
--@author	weidong_wu
--@note		签到

WndGameSingIn = {
	--请不要在这里定义变量
	m_bNeedSendProtocol = false  
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndGameSingIn:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nLoadingID = nil 
	self.days = 0 						--累计签到次数
	self.b_sign = false  				--今天是否已签到
	self.b_vipSign = false 				--vip是否已成功签到
	self.m_currentDay = 0 				--今年的当前天数
	self.m_currentYear = 0 				--今年是第几年
	self.m_tMsgData = nil 
	self.monthReward = nil
	self.tReward = nil
	self.m_nSignType = nil
	self.dayOfMonth = nil
	self.m_tBoxStatusMessage = nil
	self.m_tBoxStatus = {} --宝箱的状态
	self.m_tBoxItemIds = {}
	self.m_tBoxNumbers = {}
	self.m_tBoxDays = {}
	self.m_celElementTotleItem = nil
	self.m_tSignCell = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndGameSingIn:_unInit()
	self.m_root = nil
	self.m_nLoadingID = nil 
	self.days = 0
	self.b_sign = false 
	self.b_vipSign = false 
	self.m_currentDay = 0
	self.m_currentYear = 0 				--今年是第几年
	self.m_tMsgData = nil 
	self.monthReward = nil
	self.tReward = nil
	self.m_nSignType = nil
	self.dayOfMonth = nil
	self.m_tBoxStatusMessage = nil
	self.m_tBoxStatus = {}
	self.m_tBoxItemIds = {}
	self.m_tBoxNumbers = {}
	self.m_tBoxDays = {}
	self.m_celElementTotleItem = nil
	self.m_tSignCell = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndGameSingIn:createElement()
	local element = WZUISystem:getInstance():createElement("WndGameSingIn")
    assert(element, "WndGameSingIn create element failed!")
    self:_init()
    return element
end


function WndGameSingIn:GetSingInDataOK( days, sign ,vipSign , nCurrentTime , monthReward, reissueTimes, todaySignNum, totaRewardDays, totaReWardStatus)
	for i=1,#totaRewardDays do
		self.m_tBoxStatus[totaRewardDays[i]] = totaReWardStatus[i]
	end

	self:_finishedLoading()
	self.days = days
	self.b_sign = sign 
	self.b_vipSign = vipSign 
	self.m_nTime = SystemTime:getServerTime()
 	self.dayOfMonth = nCurrentTime
	self.monthReward = monthReward
	self.reissueTimes = reissueTimes
	self.todaySignNum = todaySignNum
	if self.reissueTimes == nil or self.reissueTimes == -1 then
		self.reissueTimes = 3
	end

	local replenishSignCost = CacheCenter:getGameParam().replenishSignCost
	local ids, nums = SplitItemString(replenishSignCost)
	if self.reissueTimes >= #ids then
		self.reissueTimes = #ids - 1
	end

	local t = os.date("*t",self.m_nTime)
  	self.m_currentDay = t.yday
  	self.m_currentYear = t.year
	self:_setSignDays(days)
	self:_update()
end

function WndGameSingIn:setMsgData(tMsg)
	-- body
	local tData = tMsg.tData
	self.days = tData.days
	self.b_sign = tData.sign 
	self.b_vipSign = tData.vipSign 
	self.m_nTime = SystemTime:getServerTime()
 	self.dayOfMonth = tData.nCurrentTime
	local t = os.date("*t",self.m_nTime)
  	self.m_currentDay = t.yday
  	self.m_currentYear = t.year
  	self.m_tMsgData = tMsg 
  	self.m_tMsgData.nStatus = MSGBOXSTATUS_DOING

	self:_setSignDays(tData.days)
	self:_update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndGameSingIn:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end




-------------------------------------私有方法模块End----------------------------------------
