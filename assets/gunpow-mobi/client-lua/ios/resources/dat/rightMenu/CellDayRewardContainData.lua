--CellDayRewardContainData.lua
--@brief	CellDayRewardContain的数据模块
--@date		2017/05/28
--@author	 
--@note		 

CellDayRewardContain = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellDayRewardContain:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_nRewardid = nil
	self.m_nRewardItemId = nil
	self.m_nRewardCount = nil
	self.m_nGetStats = nil
	self.m_nActivityId = nil
	self.m_callbackLua = nil
	self.m_callbackFun = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellDayRewardContain:_unInit()
	self.m_root = nil
	self.m_nRewardid = nil
	self.m_nRewardItemId = nil
	self.m_nRewardCount = nil
	self.m_nGetStats = nil
	self.m_nActivityId = nil
	self.m_callbackLua = nil
	self.m_callbackFun = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellDayRewardContain:createElement()
	if CellDayRewardContain.m_root ~= nil then
		WindowManager:removeWindow(CellDayRewardContain.m_root, CellDayRewardContain, true)
	end
	local element = WZUISystem:getInstance():createElement("CellDayRewardContain")
	assert(element, "CellDayRewardContain create element failed!")
	self:_init()
	return element
end

--设置奖励物品信息
function CellDayRewardContain:setRewardData(acitityId,rewardid,rewardItemId,rewardCount,getStats,startTime,endTime,rewardItemsParamCount)
	WZLog("CellDayRewardContain:setRewardData")
	self.m_nRewardid = rewardid
	self.m_nRewardItemId = rewardItemId
	self.m_nRewardCount = rewardCount
	self.m_nGetStats = getStats
	self.m_nActivityId = acitityId
	self.m_nStartTime = startTime
	self.m_nEndTime = endTime
	self.m_nRewardItemsParamCount = rewardItemsParamCount
end

function CellDayRewardContain:setGetRewardCallback(callbackLua,callbackFun)
	WZLog("CellDayRewardContain:setGetRewardCallback")
	self.m_callbackLua = callbackLua
	self.m_callbackFun = callbackFun
end

function CellDayRewardContain:updateUI(itemIndex,stats)
	WZLog("CellDayRewardContain:updateUI")
	local conDay = GetElement(self.m_root,"conDay" .. itemIndex .. "_CellDayRewardContain",WZUIContainer)

	self.m_nGetStats[itemIndex] = 1
	local imgGet= GetElement(conDay,"imgGet_CellDayRewardContain",WZUIImage)
	local sp = GetElement(conDay,"sp_CellDayRewardContain",WZUISpine)
	local txtNum = GetElement(conDay,"txtNum_CellDayRewardContain",WZUILabelTTF)
	local imgBlack = GetElement(conDay,"imgBlack_CellDayRewardContain",WZUI9Image)
	sp:setVisible(false)
	imgGet:setVisible(true)
	imgBlack:setVisible(true)
	txtNum:setVisible(false)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
