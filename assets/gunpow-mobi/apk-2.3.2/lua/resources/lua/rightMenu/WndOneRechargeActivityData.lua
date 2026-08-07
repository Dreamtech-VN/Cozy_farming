--WndOneRechargeActivityData.lua
--@brief	WndOneRechargeActivity的数据模块
--@date		2020/07/02
--@author	yrd
--@note		幸运一元冲活动主界面

WndOneRechargeActivity = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndOneRechargeActivity:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nLoadingId = nil
	self.m_phase = nil
	self.m_rewardItemId = nil
	self.m_rewardItemNum = nil
	self.m_joinCount = nil
	self.m_openRewardCondition = nil
	self.m_rechargeSum = nil
	self.m_luckyCodeRechargeNum = nil
	self.m_luckyCodeCount = nil
	self.m_nickname = nil
	self.m_luckyCodeNum = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndOneRechargeActivity:_unInit()
	self.m_root = nil
	self.m_nLoadingId = nil
	self.m_phase = nil
	self.m_rewardItemId = nil
	self.m_rewardItemNum = nil
	self.m_joinCount = nil
	self.m_openRewardCondition = nil
	self.m_rechargeSum = nil
	self.m_luckyCodeRechargeNum = nil
	self.m_luckyCodeCount = nil
	self.m_nickname = nil
	self.m_luckyCodeNum = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndOneRechargeActivity:createElement()
	if WndOneRechargeActivity.m_root ~= nil then
		WindowManager:removeWindow(WndOneRechargeActivity.m_root, WndOneRechargeActivity, true)
	end
	local element = WZUISystem:getInstance():createElement("WndOneRechargeActivity")
	assert(element, "WndOneRechargeActivity create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndOneRechargeActivity:showInterface()
	local wndActivity = WndOneRechargeActivity:createElement()
	if wndActivity then 
		WindowManager:addWindow(wndActivity, WndOneRechargeActivity, nil, nil, nil, true)
	end
end

--@brief 	活动详情协议返回
function WndOneRechargeActivity:getOneYuanLuckyInfoOk(phase, rewardItemId, rewardItemNum, joinCount, openRewardCondition, rechargeSum, luckyCodeRechargeNum, luckyCodeCount, nickname, luckyCodeNum)
	self.m_phase = phase
	self.m_rewardItemId = rewardItemId
	self.m_rewardItemNum = rewardItemNum
	self.m_joinCount = joinCount
	self.m_openRewardCondition = openRewardCondition
	self.m_rechargeSum = rechargeSum
	self.m_luckyCodeRechargeNum = luckyCodeRechargeNum
	self.m_luckyCodeCount = luckyCodeCount
	self.m_nickname = nickname
	self.m_luckyCodeNum = luckyCodeNum

	self:_initUi()
end

--@brief 	领取幸运码协议返回
function WndOneRechargeActivity:getOneYuanLuckyCodeOk(status)
	self:_closeLoading()
	if status == 0 then
		MsgBoxManager:showTipBox(LocalStrings.RETURNEE_TEXT28)
	elseif status == 1 then
		MsgBoxManager:showTipBox(LocalStrings.VIP_RECVSUCCESS)
	elseif status == 2 then
    	WndOneActivityRule:showInterface(2,LocalStrings.ACTIVITY_TEXT_DESC_16,LocalStrings.ACTIVITY_TEXT_DESC_13)
	elseif status == 3 then
    	WndOneActivityRule:showInterface(2,LocalStrings.ACTIVITY_TEXT_DESC_16,LocalStrings.ACTIVITY_TEXT_DESC_14)
	end
end

function WndOneRechargeActivity:sendOneYuanActivityProtocol()
	ProtocolProcessorNewActivity:send_ACTIVITY2_GetOneYuanLuckyInfo( )
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
